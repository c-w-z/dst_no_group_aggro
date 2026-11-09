# 无群体仇恨（又名关我屁事）No Group Aggro (aka Not My Business)

[h2]如果你喜欢我的模组，请点赞并收藏！[/h2]
[img]https://steamuserimages-a.akamaihd.net/ugc/27680204237595119/AD467A988E9C966C580668CA6BFECE0849A48893/[/img]

本模组又名：我打你同伴关你屁事，雨女无瓜！
[h2]模组介绍[/h2]
现在各种生物被攻击时，同伴会选择看戏而不是上前帮忙！
有了这个MOD，再也不怕不小心打到猪人或牛了，你也可以和企鸥单挑了！
本模组移除了青蛙、皮弗娄牛、猪人、企鸥等生物的群体仇恨机制。每种生物可单独开关，不影响玩家雇佣的生物。
[spoiler]其实制作这个模组是因为我玩模组时，随从常常不小心打到牛之类的群体仇恨生物导致被围殴致死[/spoiler]

[h2]支援的生物列表[/h2]
[list]
[*] 蜜蜂：单独控制普通蜜蜂和杀人蜂之间的群体仇恨传播，不含嗡嗡蜜蜂。不会改变蜜蜂自身反击或主动索敌。
[*] 蜂巢：单独控制野生普通蜂巢的放蜂反应（包含巢外蜜蜂被攻击或捕捉时的放蜂）。可选择原版（被攻击时放出有仇恨的杀人蜂）或无仇恨普通蜜蜂，不影响杀人蜂巢。
[*] 蜂箱：包含隐士蜂箱，可选择原版或安全蜂箱。安全模式下采蜜不放蜂，其他放蜂反应放出无仇恨的普通蜜蜂。
[*] 三项均为独立的原版/启用选项，新安装默认启用。蜂巢和蜂箱的无仇恨放蜂不会关闭巢外蜂群的仇恨传播，也不会改变春季等主动索敌行为。建立伺服器页面载入已启用的本MOD时，会将已储存的旧设置自动转成三个布尔值：旧原版为false/false/false，旧选项1为true/true/true，旧选项2为true/false/true；已有独立蜂巢、蜂箱设置优先保留，不必重设。更新后须重新加载并启用MOD；停留在主画面直接覆盖MOD文件，不会让已载入的旧代码重新执行。专用伺服器和旧世界仍可读取旧字符串和缺少新key的设置，在运行时保留旧行为，不改写modoverrides.lua。
[*] 青蛙、明眼青蛙
[*] 蜘蛛：包含普通蜘蛛、蜘蛛战士、洞穴蜘蛛、喷吐蜘蛛、穴居悬蛛、破碎蜘蛛、护士蜘蛛和海黽。分别控制蜘蛛互相援助、受击呼叫附近蛛巢、巢穴防卫、蛛网警报以及女王军队，共五项配置。
[*] 蛛巢防卫：包含各级普通巢、岩穴、月岛巢、海黽巢繭的攻击、采掘、剃巢、作祟及着火反应。可选原版、无目标出蛛（默认）或停止防卫出蛛。无目标模式保留原版数量、种类和生成资格检查，不指定仇恨或调查位置；停止模式不扣巢内库存。
[*] 蛛网警报：包含各巢踩网、砍蜘蛛网蘑菇树及海黽巢繭的激活警报。可选原版（默认）、无目标出蛛或停止警报出蛛。与防卫配置独立，悬蛛网直接指定目标的路径也包含在内；无目标模式保留原有调查者数量限制及存档标记，避免移除调查位置后反复触发额外放蛛；原版本来没有调查者计数限制的出蛛机制不新增数量限制。
[*] 蜘蛛女王：可关闭女王间援助、首领对子蛛的目标指派、新生子蛛继承目标及同女王子蛛互相援助；保留女王目标、产子数量／种类／机率、跟随和单体战斗。
[*] 蜘蛛互相援助、呼叫蛛巢及女王连动默认关闭。玩家通过韦伯或蜘蛛帽招募的蜘蛛固定保留原版；面具蜘蛛、装饰安抚、哨子、驱散和护士治疗保留。正常繁殖、日常出巢、吹哨、海黽捕鱼及毁巢后的原版无目标逸出也保留，停止防卫出蛛不等于完全不产蛛。
[*] 皮弗娄牛、小皮弗娄牛
[*] 猪人、猪人守卫和疯猪（不含面具猪人）
[*] 兔人（不含舒适兔人、皇家兔子警卫和面具兔人）
[*] 鱼人、忠诚鱼人守卫（不含面具鱼人）
[*] 企鸥、永冻企鸥
[*] 水獭掠夺者
[*] 充电伏特羊
[*] 石虾（不含面具石虾）
[*] 穴居猴
[/list]

[img]https://images.steamusercontent.com/ugc/11237512703173357918/85197A2790A4E3D09E56BB81F20DD46B0F408375/[/img]
[img]https://images.steamusercontent.com/ugc/12214714446227910701/12B3B08D2BE832B9A0BDEDB7EE696466741CEF1D/[/img]

[h2]注意事项[/h2]
[list]
[*] 不会改变生物的主动仇恨范围，因此对于索敌范围大的主动敌对生物效果可能较不明显，使用远程武器才比较容易感受到，例如鱼人、猪人守卫、永冻企鸥、充电伏特羊。
[*] 蜘蛛设置独立生效，关闭蜘蛛互相援助不会自动关闭蛛网警报。无目标出蛛后，附近蜘蛛仍可能各自索敌同一玩家，因此不保证始终一对一。女王子蛛援助由女王设置控制，不属于玩家随从例外。
[*] 版本 1.1.0 共 18 项配置。旧 modoverrides.lua 缺少蜘蛛新 key 时采用上述默认；所有蜘蛛配置选择原版可恢复原版机制。本实现依据本地 2026/7/7 源码快照，实际游戏 build 尚未核对。
[/list]

[h2]未来计划[/h2]
[list]
[*] 移除更多生物的群体仇恨机制
[/list]

[h2]蜘蛛功能验证（1.1.0）[/h2]
[list]
[*] 已通过 Lua 5.5 语法检查及原版 callback/component 的模拟引擎行为测试，包含防卫／警报九种组合、普通／紧急／延迟出蛛、生成资格、玩家与女王随从、计数／存档和错误恢复；这不证明 Lua 5.1 或 DST 游戏内兼容性。
[*] 游戏内测试尚未执行：需在实际游戏 build 验证主机／远程客户端或 dedicated server、地表／洞穴／海洋、八种蜘蛛及所有巢穴、韦伯／蜘蛛帽／女王、配置切换及存档重载。特别对照攻击、采掘、剃巢、点燃、作祟、踩网和砍蜘蛛网蘑菇树，全部原版设置须与未启用 MOD 的蜘蛛行为一致。
[/list]

[url=https://github.com/C-W-Z/dst_no_group_aggro]GitHub Repo Here[/url]

# No Group Aggro (aka Not My Business) 无群体仇恨（又名关我屁事）

[h2]If you like my mod, please thumbs up and favorite![/h2]
[img]https://steamuserimages-a.akamaihd.net/ugc/27680204237595119/AD467A988E9C966C580668CA6BFECE0849A48893/[/img]

[h2]Mod Introduction[/h2]
Now when creatures are attacked, their companions will just mind their own business instead of helping!
With this mod, you'll never have to worry about accidentally hitting a pigman or a beefalo again, and you can even fight a pengull 1-vs-1!
This mod removes the group aggro mechanics of creatures such as frogs, beefalos, pigmen, and pengulls. Each creature can be toggled individually, and player-hired followers are not affected.
[spoiler]I made this mod because when I was playing mods, my followers often accidentally hit creatures like cows, resulting in them being ganged up on and killed.[/spoiler]

[h2]Supported Creatures List[/h2]
[list]
[*] Bees: independently controls aggro sharing between regular and Killer Bees, excluding Grumble Bees. Does not change individual retaliation or active targeting.
[*] Bee Hives: independently controls regular wild hive releases, including releases when their bees are attacked or netted. Choose Vanilla (attacks release aggressive Killer Bees) or untargeted regular bees. Excludes Killer Bee Hives.
[*] Bee Boxes: includes Hermit Bee Boxes. Choose Vanilla or Safe Bee Boxes. Safe mode prevents harvest releases and releases untargeted regular bees in other cases.
[*] All three menus now have independent Vanilla/enabled boolean choices, enabled by default for new installations. Untargeted releases do not disable outdoor aggro sharing or active targeting, such as in spring. When the server creation frontend loads this enabled mod, stored old settings are automatically saved as three booleans: old Vanilla becomes false/false/false; old option 1 becomes true/true/true; old option 2 becomes true/false/true. Existing independent hive and box choices take precedence. Reload and enable the mod after updating; replacing files while staying on the main menu does not reload code already in memory. Dedicated servers and old worlds still accept legacy strings and missing new keys at runtime without rewriting modoverrides.lua.
[*] Frogs, Bright-Eyed Frogs
[*] Spiders: all eight variants (Spider, Warrior, Cave Spider, Spitter, Dangling Depth Dweller, Shattered Spider, Nurse Spider and Sea Strider). Five independent settings control assistance, calls to nearby nests, nest defense, web alarms and queen armies.
[*] Nest Defense: attacks, mining, shaving, haunting and ignition for regular den stages, Spilagmites, Shattered Spider Holes and Oceanvine Cocoons, including lunar hail buildup clearing on cocoons. Choose Vanilla, Untargeted Releases (default), or No Defensive Releases. Untargeted mode retains numbers, types and spawn eligibility without targets or investigation positions; disabled spawning does not consume nest stock.
[*] Web Alarms: nest web triggers, chopping Webbed Mushtrees and Oceanvine Cocoon activation alarms. Choose Vanilla, Untargeted Releases (default), or No Alarm Releases, independently of defense. Includes direct targeting from dropper webs. Untargeted mode retains existing investigator limits and saved markers to prevent extra releases from repeated triggers after removing investigation positions; mechanisms without vanilla investigator limits do not gain new caps.
[*] Queens: disable queen-to-queen assistance, leader assignments, newborn target inheritance and assistance between a queen's minions. Preserve the queen's own target, birth numbers/types/chances, following and individual combat.
[*] Spider assistance, nest calls and queen target sharing are disabled by default. Player spiders recruited through Webber or Spider Hats retain vanilla behavior. Parasite hosts, decorations, whistles, repellent and nurse healing are preserved, as are routine spawning, fishing and vanilla untargeted escapes on nest destruction. No Defensive Releases does not disable all spider spawning.
[*] Beefalos, Baby Beefalos
[*] Pigmen, Guard Pigs, and Werepigs (excludes Enthralled Pigmen)
[*] Bunnymen (excludes Cozy Bunnymen, Royal Rabbit Enforcer, and Enthralled Bunnymen)
[*] Merms, Loyal Merm Guards (excludes Enthralled Merms)
[*] Pengulls, Mutated Pengulls
[*] Marotter
[*] Charged Lightning Goats
[*] Rock Lobsters (excludes Enthralled Rock Lobsters)
[*] Splumonkey
[/list]

[img]https://images.steamusercontent.com/ugc/11237512703173357918/85197A2790A4E3D09E56BB81F20DD46B0F408375/[/img]
[img]https://images.steamusercontent.com/ugc/12214714446227910701/12B3B08D2BE832B9A0BDEDB7EE696466741CEF1D/[/img]

[h2]Notes[/h2]
[list]
[*] This does not change the active aggro range of creatures. Therefore, the effect might be less noticeable for actively hostile creatures with large aggro radii (e.g., Merms, Pig Guards, Mutated Pengulls, Charged Lightning Goats) unless you use ranged weapons.
[*] Spider settings are independent: disabling assistance does not disable web alarms. Released spiders can still independently target the same player, so this does not guarantee one-on-one fights. Queen minions follow the Queen setting and are not exempt as player followers.
[*] Version 1.1.0 has 18 settings. Missing spider keys in old modoverrides.lua files use the defaults above; selecting vanilla for all spider settings restores vanilla mechanics. Implementation targets the local 2026/7/7 source snapshot; the actual game build has not been verified.
[/list]

[h2]Future Plans[/h2]
[list]
[*] Remove group aggro mechanics for more creatures
[/list]

[h2]Spider Validation (1.1.0)[/h2]
[list]
[*] Lua 5.5 syntax checks and real snapshot callback/component tests under a mocked engine passed, including nine defense/alarm combinations, regular/emergency/delayed spawning, eligibility, player/queen followers, counting/save markers and error restoration. These do not establish Lua 5.1 or in-game DST compatibility.
[*] In-game tests have not been run. Validate the actual build on a host with remote clients or a dedicated server, surface/caves/ocean, all eight variants and nest families, Webber/Spider Hats/Queens, config changes and save reloads. Compare attacks, mining, shaving, ignition, haunting, web triggers and Webbed Mushtree chopping. All vanilla spider settings must match spider behavior with this mod disabled.
[/list]

[url=https://github.com/C-W-Z/dst_no_group_aggro]GitHub Repo Here[/url]
