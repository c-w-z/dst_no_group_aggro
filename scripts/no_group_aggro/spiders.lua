-- 蜘蛛、巢穴與女王共用生成上下文，必須一起註冊。
local config = env.no_group_aggro.config

local spider_share = config.spider
local spider_nest_help = config.spider_nest_help
local spider_defense = config.spider_nest_defense
local spider_alarm = config.spider_nest_alarm
local spider_queen = config.spiderqueen
local spider_context = nil
-- 只有巢穴或女王 Hook 會建立生成上下文。
local nest_hooks = spider_defense ~= "vanilla" or spider_alarm == "disabled"

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
        if spider_defense == "untargeted" or spider_queen then
            local old_target = combat.SetTarget
            combat.SetTarget = function(self, target, ...)
                local context = spider_context
                if target ~= nil and context ~= nil and context.children[inst]
                    and (context.mode == "untargeted" or context.queen ~= nil) then
                    return
                end
                return old_target(self, target, ...)
            end
        end
    end

    local locations = inst.components.knownlocations
    if locations ~= nil and spider_defense == "untargeted" then
        local old_remember = locations.RememberLocation
        locations.RememberLocation = function(self, name, ...)
            local context = spider_context
            if name == "investigate" and context ~= nil and context.mode == "untargeted"
                and context.children[inst] then
                return
            end
            return old_remember(self, name, ...)
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
