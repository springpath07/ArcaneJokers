-- Gains +2 Mult when a card is destroyed

SMODS.Joker {
    key = "mastermind",
    cost = 4,
    rarity = 1,

    config = {
        extra = {
            mult_gain = 2,
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
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 3, y = 1},

    calculate = function(self, card, context)
        -- add mult when card is destroyed
        if context.remove_playing_cards and not context.blueprint then
            for i = 1, #context.removed do
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                card_eval_status_text(card, "extra", nil, nil, nil, {
                    message = localize {
                        type = "variable",
                        key = "a_mult",
                        vars = {card.ability.extra.mult}
                    },
                    colour = G.C.RED,
                    delay = 0.45
                })
            end

        -- return mult during scoring time
        elseif context.joker_main and (card.ability.extra.mult > 0) then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}