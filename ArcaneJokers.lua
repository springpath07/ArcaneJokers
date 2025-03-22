SMODS.Atlas {
    key = "ArcaneJokers",
    path = "ArcaneJokers.png",
    px = 71,
    py = 95,
}
-- 69 x 93
-- 138 x 186

assert(SMODS.load_file("common.lua"))()

-- load all individual jokers
local subdir = "jokers"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
    assert(SMODS.load_file(subdir .. "/" .. filename))()
end