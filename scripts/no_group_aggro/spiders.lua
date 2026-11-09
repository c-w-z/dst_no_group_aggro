-- 蜘蛛、巢穴與女王共用生成上下文，必須一起註冊。
local config = env.no_group_aggro.config

local spider_share = config.spider
local spider_nest_help = config.spider_nest_help
local spider_defense = config.spider_nest_defense
local spider_alarm = config.spider_nest_alarm
local spider_queen = config.spiderqueen
local spider_context = nil
-- 只有巢穴或女王 Hook 會建立生成上下文。
local nest_hooks = spider_defense ~= "vanilla" or spider_alarm ~= "vanilla"

-- Lua 5.1 相容：保留 nil 與多重回傳，拋錯前也恢復可巢狀的上下文並保留原始 traceback。
local function WithSpiderContext(context, fn, ...)
    local previous = spider_context
    spider_context = context
    local args, n = { ... }, select("#", ...)
    local function Finish(ok, ...)
        spider_context = previous
        if not ok then error((...), 0) end
        return ...
    end
    return Finish(xpcall(function() return fn(unpack(args, 1, n)) end, debug.traceback))
end

local function SpiderLeader(inst)
    local follower = inst.components.follower
    return follower ~= nil and follower:GetLeader() or nil
end

local function ProtectedSpider(inst)
    local leader = SpiderLeader(inst)
    return inst:HasTag("shadowthrall_parasite_hosted")
        or (leader ~= nil and leader:HasTag("player"))
end

-- 原版調查者在走到 investigate 位置時清除記憶（ACTIONS.INVESTIGATE），戰鬥中不會走過去；
-- brain 中 Investigate 優先於白天回巢，所以調查期間不回巢。
-- untargeted 警報不給位置，改以步行到原位置的時間模擬：期間計入調查者並借用 summoned 阻止 brain 回巢；
-- 有戰鬥目標時延後，丟失目標後重新計時；出巢的 taunt/落下等 busy 狀態期間原版不能移動，不計入步行。
local CheckAlarmSpider

local function StartAlarmTravel(inst)
    local pos = inst._no_group_aggro_alarm
    if pos == nil then return end
    if inst._no_group_aggro_alarm_task ~= nil then inst._no_group_aggro_alarm_task:Cancel() end
    local x, _, z = inst.Transform:GetWorldPosition()
    local dist = math.max(0, math.sqrt((pos.x - x) ^ 2 + (pos.z - z) ^ 2) - 1)
    local speed = inst.components.locomotor ~= nil and inst.components.locomotor:GetWalkSpeed() or 0
    inst._no_group_aggro_alarm_task = inst:DoTaskInTime(speed > 0 and dist / speed or 0, CheckAlarmSpider)
end

local function OnAlarmNewState(inst)
    if not inst.sg:HasStateTag("busy") then
        inst:RemoveEventCallback("newstate", OnAlarmNewState)
        StartAlarmTravel(inst)
    end
end

-- 延後一幀：dropperweb 在 SpawnChild 回傳後才進入 dropper_enter。
local function BeginAlarmTravel(inst)
    inst._no_group_aggro_alarm_task = nil
    if inst.sg ~= nil and inst.sg:HasStateTag("busy") then
        inst:RemoveEventCallback("newstate", OnAlarmNewState)
        inst:ListenForEvent("newstate", OnAlarmNewState)
    else
        StartAlarmTravel(inst)
    end
end

CheckAlarmSpider = function(inst)
    inst._no_group_aggro_alarm_task = nil
    if inst.components.combat:HasTarget() then return end
    inst._no_group_aggro_alarm = nil
    inst:RemoveEventCallback("droppedtarget", StartAlarmTravel)
    inst:RemoveEventCallback("newstate", OnAlarmNewState)
    -- 只還原自己設定的 summoned；吹哨 buff 仍在時由 buff 的 detachfn 負責。
    if inst._no_group_aggro_summoned then
        inst._no_group_aggro_summoned = nil
        if not inst:HasDebuff("spider_summoned_buff") then inst.summoned = false end
    end
end

local function MarkAlarmSpider(inst, x, z)
    if inst._no_group_aggro_alarm == nil then
        inst:ListenForEvent("droppedtarget", StartAlarmTravel)
        if not inst.summoned then
            inst.summoned = true
            inst._no_group_aggro_summoned = true
        end
    end
    inst._no_group_aggro_alarm = { x = x, z = z }
    if inst._no_group_aggro_alarm_task ~= nil then inst._no_group_aggro_alarm_task:Cancel() end
    inst._no_group_aggro_alarm_task = inst:DoTaskInTime(0, BeginAlarmTravel)
end

local function SpiderPostInit(inst)
    if not TheWorld.ismastersim then return end

    local combat = inst.components.combat
    if combat ~= nil then
        if spider_share or spider_queen then
            local old_share = combat.ShareTarget
            combat.ShareTarget = function(self, ...)
                if inst:HasTag("shadowthrall_parasite_hosted") then return old_share(self, ...) end
                local leader = SpiderLeader(inst)
                local disabled = false
                if leader == nil then
                    disabled = spider_share
                elseif leader.prefab == "spiderqueen" then
                    disabled = spider_queen
                end
                if not disabled then
                    return old_share(self, ...)
                end
            end
        end

        local old_hit = combat.onhitfn
        if old_hit ~= nil and spider_nest_help then
            combat:SetOnHit(function(self_inst, ...)
                if ProtectedSpider(self_inst) then return old_hit(self_inst, ...) end
            end)
        end

        -- 在實際生成後攔截指派，而非移除 SpawnChild 的 target 參數：
        -- 原版無敵檢查、選擇 prefab 及女王產子機率仍看得到原目標。
        if nest_hooks or spider_queen then
            local old_target = combat.SetTarget
            combat.SetTarget = function(self, target, ...)
                local context = spider_context
                if target ~= nil and context ~= nil and context.children[inst]
                    and (context.mode == "untargeted" or context.queen ~= nil) then
                    -- dropperweb 警報直接指派目標而非調查位置；以目標位置模擬同樣的延後回巢。
                    if context.kind == "alarm" and target.Transform ~= nil then
                        local x, _, z = target.Transform:GetWorldPosition()
                        MarkAlarmSpider(inst, x, z)
                    end
                    return
                end
                return old_target(self, target, ...)
            end
        end
    end

    local locations = inst.components.knownlocations
    if locations ~= nil and nest_hooks then
        local old_remember = locations.RememberLocation
        locations.RememberLocation = function(self, name, pos, ...)
            local context = spider_context
            if name == "investigate" and context ~= nil and context.mode == "untargeted"
                and context.children[inst] then
                if pos ~= nil and context.kind == "alarm" then MarkAlarmSpider(inst, pos.x, pos.z) end
                return
            end
            return old_remember(self, name, pos, ...)
        end
    end

    if spider_alarm == "untargeted" then
        local old_save, old_load = inst.OnSave, inst.OnLoad
        inst.OnSave = function(self, data, ...)
            -- 原版 callback 可以寫入其他欄位，也可回傳實體 references。
            local function Finish(...)
                local pos = self._no_group_aggro_alarm
                if pos ~= nil then data.no_group_aggro_alarm = { x = pos.x, z = pos.z } end
                return ...
            end
            if old_save ~= nil then return Finish(old_save(self, data, ...)) end
            return Finish()
        end
        inst.OnLoad = function(self, data, ...)
            local pos = data ~= nil and data.no_group_aggro_alarm or nil
            if type(pos) == "table" then MarkAlarmSpider(self, pos.x, pos.z) end
            if old_load ~= nil then return old_load(self, data, ...) end
        end
    end

    local context = spider_context
    if context ~= nil and context.spawning then
        context.children[inst] = true
    end
end

local function NestContext(inst, kind)
    return {
        nest = inst, kind = kind, children = {},
        mode = kind == "defense" and spider_defense or (kind == "alarm" and spider_alarm or "vanilla"),
    }
end

local function WrapNestCallback(inst, component, field, kind)
    if component == nil or component[field] == nil then return end
    local original = component[field]
    component[field] = function(...)
        return WithSpiderContext(NestContext(inst, kind), original, ...)
    end
end

local function SpiderNestPostInit(inst)
    if not TheWorld.ismastersim then return end
    local spawner = inst.components.childspawner
    if spawner == nil then return end

    -- 停止生成必須在 SpawnChild 扣庫存及 TakeOwnership 之前返回。
    for _, name in ipairs({ "SpawnChild", "SpawnEmergencyChild" }) do
        local original = spawner[name]
        spawner[name] = function(self, ...)
            local context = spider_context
            if context ~= nil and context.nest == inst and context.mode == "disabled" then return nil end
            return original(self, ...)
        end
    end
    local old_spawn = spawner.DoSpawnChild
    spawner.DoSpawnChild = function(self, ...)
        local context = spider_context
        if context == nil or context.nest ~= inst or context.mode == "vanilla" then
            return old_spawn(self, ...)
        end
        local spawning = {
            nest = inst, kind = context.kind, mode = context.mode,
            children = context.children, spawning = true,
        }
        return WithSpiderContext(spawning, old_spawn, self, ...)
    end

    local old_count = spawner.CountChildrenOutside
    spawner.CountChildrenOutside = function(self, fn, ...)
        local context = spider_context
        if fn ~= nil and context ~= nil and context.nest == inst
            and context.kind == "alarm" and context.mode == "untargeted" and not context.spawning then
            local original = fn
            fn = function(child)
                return original(child) or child._no_group_aggro_alarm ~= nil
            end
        end
        return old_count(self, fn, ...)
    end

    WrapNestCallback(inst, inst.components.combat, "onhitfn", "defense")
    WrapNestCallback(inst, inst.components.workable, "onwork", "defense")
    WrapNestCallback(inst, inst.components.shaveable, "on_shaved", "defense")
    WrapNestCallback(inst, inst.components.hauntable, "onhaunt", "defense")
    WrapNestCallback(inst, inst.components.burnable, "onignite", "defense")

    for _, name in ipairs({ "PushEvent", "PushEventImmediate" }) do
        local original = inst[name]
        inst[name] = function(self, event, ...)
            if event == "creepactivate" or (event == "activated" and self.prefab == "oceanvine_cocoon") then
                return WithSpiderContext(NestContext(self, "alarm"), original, self, event, ...)
            elseif event == "lunarhailbuildupworked" then
                -- 海黽巢繭清理月冰雹時直接呼叫局部 OnHit，不經 combat.onhitfn。
                return WithSpiderContext(NestContext(self, "defense"), original, self, event, ...)
            elseif event == "death" then
                -- 致死攻擊、剃巢中發生的原版無目標逸出不算防衛生成。
                return WithSpiderContext(NestContext(self, "escape"), original, self, event, ...)
            end
            return original(self, event, ...)
        end
    end

    local old_task = inst.DoTaskInTime
    inst.DoTaskInTime = function(self, delay, fn, ...)
        local context = spider_context
        if context ~= nil and context.nest == inst
            and (context.kind == "defense" or context.kind == "alarm") then
            local original = fn
            fn = function(...) return WithSpiderContext(context, original, ...) end
        end
        return old_task(self, delay, fn, ...)
    end
end

local function SpiderQueenPostInit(inst)
    if not TheWorld.ismastersim then return end
    inst.components.combat.ShareTarget = function() end
    local leader = inst.components.leader
    -- 只修改女王實例，不修改玩家 leader，也不拆掉追隨關係。
    leader.OnAttacked = function() end
    leader.OnNewTarget = function() end
    local producer = inst.components.incrementalproducer
    local old_produce = producer.producefn
    producer.producefn = function(...)
        return WithSpiderContext({ queen = inst, children = {}, spawning = true }, old_produce, ...)
    end
end

if spider_share or spider_nest_help or spider_queen or nest_hooks then
    for _, prefab in ipairs({ "spider", "spider_warrior", "spider_hider", "spider_spitter",
        "spider_dropper", "spider_moon", "spider_healer", "spider_water" }) do
        AddPrefabPostInit(prefab, SpiderPostInit)
    end
end
if nest_hooks then
    for _, prefab in ipairs({ "spiderden", "spiderden_2", "spiderden_3", "spiderhole",
        "moonspiderden", "dropperweb", "oceanvine_cocoon" }) do
        AddPrefabPostInit(prefab, SpiderNestPostInit)
    end
end
if spider_queen then AddPrefabPostInit("spiderqueen", SpiderQueenPostInit) end
