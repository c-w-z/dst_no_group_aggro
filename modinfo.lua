---@diagnostic disable: lowercase-global, undefined-global

local modid = 'no_group_aggro'
-- DST 內建燈泡字元（emoji_lightbulb）。
local update_icon = '󰀏'

local onof_zh = {
    { '原版', false, "不修改任何机制" },
    { '无群体仇恨', true },
}

local onof_en = {
    { 'Vanilla', false, "Do not modify any mechanics" },
    { 'No Group Aggro',  true },
}

-- TODO: 新增一个移除对所有生物群体仇恨还是只移除对玩家和玩家随从的群体仇恨的选项

local LANGS = {
    ['zh'] = {
        name = '无群体仇恨（aka 雨女无瓜）',
        description =
        update_icon .. '更新后，请重新加载并启用本MOD来自动将旧蜜蜂设置转成蜜蜂、蜂巢、蜂箱三项，行为不变。\n\n' ..
        '移除青蛙、皮弗娄牛、猪人、企鸥等生物的群体仇恨机制。\n每种生物可单独开关，不影响玩家雇佣的生物。\n注意：不会改变生物的主动仇恨范围，因此对于索敌范围大的主动敌对生物效果可能较不明显，使用远程武器才比较容易感受到，例如鱼人、猪人守卫、永冻企鸥、充电伏特羊。',
        config = {
            { modid .. '_frog', '青蛙', '包含明眼青蛙', true, onof_zh },
            { modid .. '_beefalo', '皮弗娄牛', '包含小皮弗娄牛', true, onof_zh },
            { modid .. '_pigman', '猪人', '包含猪人守卫和疯猪，不含面具猪人', true, onof_zh },
            { modid .. '_bunnyman', '兔人', '不含舒适兔人、皇家兔子警卫和面具兔人', true, onof_zh },
            { modid .. '_merm', '鱼人', '包含忠诚鱼人守卫，不含面具鱼人', true, onof_zh },
            { modid .. '_penguin', '企鸥', '包含永冻企鸥', true, onof_zh },
            { modid .. '_otter', '水獭掠夺者', '', true, onof_zh },
            { modid .. '_lightninggoat', '充电伏特羊', '', true, onof_zh },
            { modid .. '_rocky', '石虾', '不含面具石虾', true, onof_zh },
            { modid .. '_monkey', '穴居猴', '', true, onof_zh },
            { "蜜蜂相关" },
            { modid .. '_bee', '蜜蜂', '蜜蜂被打时不会叫同伴一起上；含杀人蜂，不含嗡嗡蜜蜂；蜂巢、蜂箱另外设置', true, onof_zh },
            { modid .. '_beehive', '蜂巢', '野生蜂巢被打，或巢外蜜蜂被打、被捕时放蜂的反应；不影响杀人蜂巢', true, {
                { '原版', false, "放出有仇恨的杀人蜂" },
                { '无仇恨蜜蜂', true, "放出无仇恨的普通蜜蜂" },
            } },
            { modid .. '_beebox', '蜂箱', '包含隐士蜂箱', true, {
                { '原版', false, "采蜜激怒蜜蜂" },
                { '安全蜂箱', true, "采蜜不放蜂，放蜂不仇恨" },
            } },
            { "蜘蛛相关" },
            { modid .. '_spider', '蜘蛛互相援助', '所有蜘蛛；其他蜘蛛被打时不会帮忙；女王生的蜘蛛看女王设置', true, onof_zh },
            { modid .. '_spider_nest_help', '蜘蛛呼叫蛛巢', '蜘蛛被打时蛛巢不会出兵；不影响面具蜘蛛', true, onof_zh },
            { modid .. '_spider_nest_defense', '蛛巢防卫', '各种蛛巢被打、挖掘、作祟、点燃时放蜘蛛的反应；打爆巢后跑出来的蜘蛛不受影响', "untargeted", {
                { '原版', "vanilla", "不修改任何机制" },
                { '无目标出蛛', "untargeted", "照常出蛛但不会瞬间锁定你；蜘蛛自己看到你仍会攻击" },
                { '停止防卫出蛛', "disabled", "不出蛛，巢里蜘蛛也不减少；夜间出巢、吹哨、打爆巢时仍会出来" },
            } },
            { modid .. '_spider_nest_alarm', '蛛网警报', '踩到蛛网、砍蛛网蘑菇树、在海黾巢附近采摘时放蛛出来查看；与蛛巢防卫分开设置', "untargeted", {
                { '原版', "vanilla", "不修改任何机制" },
                { '无目标出蛛', "untargeted", "照常出蛛但不会走向你，在巢附近停留一阵；蜘蛛自己看到你仍会攻击；悬蛛网维持原版" },
                { '停止警报出蛛', "disabled", "不因警报出蛛；蛛巢防卫、夜间出巢、吹哨及海黾捕鱼照常" },
            } },
            { modid .. '_spiderqueen', '蜘蛛女王', '女王之间不互相帮忙，不指挥小蜘蛛围攻，新生小蜘蛛也不直接仇恨你；产子、跟随和各自战斗不变', true, onof_zh },
        }
    },
    ['en'] = {
        name = 'No Group Aggro (aka Not Your Business)',
        description =
        update_icon .. 'After update, please reload and enable this mod to automatically split your old bee setting into Bees, Bee Hives and Bee Boxes, preserving its behavior.\n\n' ..
        'Removes the group aggro mechanics from creatures like Frogs, Beefalos, Pigmen, and Pengulls.\nEach creature can be toggled individually. Does not affect followers hired by players.\nNote: This does not change the active aggro range of creatures. Therefore, the effect might be less noticeable for actively hostile creatures with large aggro radii (e.g., Merms, Guard Pigs, Mutated Pengulls, Charged Lightning Goats) unless you use ranged weapons.',
        config = {
            { modid .. '_frog', 'Frogs', 'Includes Bright-Eyed Frog', true, onof_en },
            { modid .. '_beefalo', 'Beefalos', 'Includes Baby Beefalos', true, onof_en },
            { modid .. '_pigman', 'Pigmen', 'Includes Guard Pigs and Werepigs, excludes Enthralled Pigmen', true, onof_en },
            { modid .. '_bunnyman', 'Bunnymen', 'Excludes Cozy Bunnymen, Royal Rabbit Enforcer, and Enthralled Bunnymen', true, onof_en },
            { modid .. '_merm', 'Merms', 'Includes Loyal Merm Guards, excludes Enthralled Merms', true, onof_en },
            { modid .. '_penguin', 'Pengulls', 'Includes Mutated Pengulls', true, onof_en },
            { modid .. '_otter', 'Marotter', '', true, onof_en },
            { modid .. '_lightninggoat', 'Charged Lightning Goats', '', true, onof_en },
            { modid .. '_rocky', 'Rock Lobsters', 'Excludes Enthralled Rock Lobsters', true, onof_en },
            { modid .. '_monkey', 'Splumonkey', '', true, onof_en },
            { "Bee Related" },
            { modid .. '_bee', 'Bees', 'Hit bees no longer call others to join; includes Killer Bees, not Grumble Bees; hives and boxes are separate', true, onof_en },
            { modid .. '_beehive', 'Bee Hives', 'Wild hives when hit, or when their bees are hit or caught; Killer Bee Hives unaffected', true, {
                { 'Vanilla', false, "Release aggressive Killer Bees" },
                { 'Untargeted Bees', true, "Release regular bees without aggro" },
            } },
            { modid .. '_beebox', 'Bee Boxes', 'Includes Hermit Bee Boxes', true, {
                { 'Vanilla', false, "Harvesting angers bees" },
                { 'Safe Bee Boxes', true, "No bees on harvest; released bees have no aggro" },
            } },
            { "Spider Related" },
            { modid .. '_spider', 'Spider Assistance', 'All spiders; other spiders no longer help when one is hit; queen-born spiders follow Queen setting', true, onof_en },
            { modid .. '_spider_nest_help', 'Spider Calls to Nests', 'Dens no longer send help when a spider is hit; masked spiders unaffected', true, onof_en },
            { modid .. '_spider_nest_defense', 'Spider Nest Defense', 'All dens when hit, mined, haunted or lit: whether they send out spiders; spiders escaping a destroyed den unaffected', "untargeted", {
                { 'Vanilla', "vanilla", "Do not modify any mechanics" },
                { 'Untargeted Releases', "untargeted", "Spiders come out as usual but don't instantly lock onto you; they still attack if they spot you" },
                { 'No Defensive Releases', "disabled", "No spiders, den keeps them; night outings, whistles and escapes still happen" },
            } },
            { modid .. '_spider_nest_alarm', 'Spider Web Alarms', 'Stepping on webs, chopping Webbed Mushtrees, or picking near Oceanvine Cocoons sends spiders out to check; separate from defense', "untargeted", {
                { 'Vanilla', "vanilla", "Do not modify any mechanics" },
                { 'Untargeted Releases', "untargeted", "Spiders come out but linger near the den instead of heading to you; they still attack if they spot you; dropper webs stay vanilla" },
                { 'No Alarm Releases', "disabled", "No alarm spiders; defense, night outings, whistles and fishing unaffected" },
            } },
            { modid .. '_spiderqueen', 'Spider Queens', "Queens don't help each other, order babies to attack, or pass targets to newborns; births, following and own fights unchanged", true, onof_en },
        }
    }
}

-- 决定当前用的语言
local cur = (locale == 'zh' or locale == 'zhr' or locale == 'zht') and 'zh' or 'en'

-- mod相关信息
version = '1.1.0'
author = 'Icya'
forumthread = ''
api_version = 10
priority = 0                                 -- 加载优先级，越低加载越晚，默认为0

dst_compatible = true                        -- 联机版适配性
dont_starve_compatible = false               -- 单机版适配性
reign_of_giants_compatible = false           -- 单机版：巨人国适配性
-- all_clients_require_mod = true     -- 服务端/所有端模组
server_only_mod = true                       -- 仅服务端模组
-- client_only_mod = true -- 仅客户端模组
server_filter_tags = { 'creature', 'tweak' } -- 创意工坊模组分类标签
icon_atlas = 'modicon.xml'                   -- 图集
icon = 'modicon.tex'                         -- 图标

-- 以下自动配置
name = LANGS[cur].name
description = version .. '\n' .. LANGS[cur].description

local config = LANGS[cur].config or {}
local _configuration_options = {}
for i = 1, #config do
    local options = {}
    if config[i][5] then
        for k = 1, #config[i][5] do
            options[k] = { description = config[i][5][k][1], data = config[i][5][k][2], hover = config[i][5][k][3] }
        end
    end
    _configuration_options[i] = {
        name = config[i][1],
        label = config[i][2],
        hover = config[i][3] or '',
        default = config[i][4] or false,
        options = #options > 0 and options or { { description = "", data = false } },
    }
    if config[i].slider_data then
        _configuration_options[i].slider_data = config[i].slider_data
    end
end

configuration_options = _configuration_options
