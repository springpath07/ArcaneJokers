-- Gains +3 Mult when Strength, The Hanged Man, or Death is used (Currently +0 Mult)

SMODS.Joker {
    key = "tenets",
    cost = 5,
    rarity = 1,

    config = {
        extra = {
            mult_gain = 3,
            mult = 0
        }
    },

    -- #1# : Joker's gained Mult when criteria is matched
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
    perishable_compat = false,

    atlas = "ArcaneJokers",
    pos = {x = 4, y = 1},

    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            if context.consumeable.ability.name == "Strength" or
               context.consumeable.ability.name == "The Hanged Man" or
               context.consumeable.ability.name == "Death" then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.MULT,
                    card = card
                }
            end
        elseif context.joker_main and (card.ability.extra.mult > 0) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}