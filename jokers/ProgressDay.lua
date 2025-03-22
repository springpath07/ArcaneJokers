-- Earn $1 at end of round per unique poker hand played each round (Currently $0)

SMODS.Joker {
    key = "progress_day",
    cost = 4,
    rarity = 1,

    config = {
        extra = {
            cash_gain = 1,
            cash = 0,
            cash_end = 0,  -- holder var for calc_dollar_bonus so cash can reset
            used_poker_hands = hand_set()
        }
    },

    -- #1# : Amount of cash gained per unique poker hand
    -- #2# : Total cash Joker gives at end of round
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cash_gain,
                card.ability.extra.cash
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    atlas = "ArcaneJokers",
    pos = {x = 5, y = 2},

    calculate = function(self, card, context)
        -- check if hand has been played this ante
        if context.before and card.ability.extra.used_poker_hands[context.scoring_name] then
            card.ability.extra.used_poker_hands[context.scoring_name] = false
            card.ability.extra.cash = card.ability.extra.cash + card.ability.extra.cash_gain

            return {
                message = localize("k_pd_inc"),
                colour = G.C.MONEY,
                card = card
            }

        -- reset poker hands played & money
        elseif context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.cash_end = card.ability.extra.cash
            card.ability.extra.cash = 0
            card.ability.extra.used_poker_hands = hand_set()
        end
    end,

    calc_dollar_bonus = function(self, card)
        return card.ability.extra.cash_end
    end
}