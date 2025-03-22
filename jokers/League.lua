-- +6 Mult per Arcane Joker (Currently +0 Mult)

SMODS.Joker {
    key = "league",
    cost = 4,
    rarity = 1,

    config = {
        extra = {
            mult_gain = 6,
            mult = 0
        }
    },

    -- #1# : Extra Mult given per Arcane Joker
    -- #2# : Current extra Mult Joker is giving
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult_gain,
                card.ability.extra.mult
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 2, y = 2},

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN then
            local arc_j_list = arcane_joker_set()
            local n = 0

            -- calc number of arcane jokers
            for i = 1, #G.jokers.cards do
                if not G.jokers.cards[i].debuff and (G.jokers.cards[i].area and G.jokers.cards[i].area == G.jokers) then
                    local j_name = G.jokers.cards[i].ability.name

                    for k, v in ipairs(arc_j_list) do
                        if v == j_name then n = n + 1 end
                    end
                end
            end

            card.ability.extra.mult = n * card.ability.extra.mult_gain
        end
    end
}