-- 集中讀取設定；保留舊存檔的繼承與缺省行為。
local modid = env.no_group_aggro.modid
local BeeSettings = require("no_group_aggro/bee_settings")
local function Read(suffix, default)
    local value = GetModConfigData(modid .. suffix)
    if value == nil then return default end
    return value
end

local bee, beehive, beebox = BeeSettings.Resolve(Read("_bee"), Read("_beehive"), Read("_beebox"))

local config = {
    frog = Read("_frog"),
    bee = bee,
    beehive = beehive,
    beebox = beebox,
    spider = Read("_spider", true),
    spider_nest_help = Read("_spider_nest_help", true),
    spider_nest_defense = Read("_spider_nest_defense", "untargeted"),
    spider_nest_alarm = Read("_spider_nest_alarm", "vanilla"),
    spiderqueen = Read("_spiderqueen", true),
    beefalo = Read("_beefalo"),
    pigman = Read("_pigman"),
    bunnyman = Read("_bunnyman"),
    merm = Read("_merm"),
    penguin = Read("_penguin"),
    otter = Read("_otter"),
    lightninggoat = Read("_lightninggoat"),
    rocky = Read("_rocky"),
    monkey = Read("_monkey"),
}

env.no_group_aggro.config = config
