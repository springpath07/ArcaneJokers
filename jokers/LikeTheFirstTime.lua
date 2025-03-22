-- +14 Mult the first time you play a new poker hand each Ante, resets when
-- Boss Blind is defeated

SMODS.Joker {
    key = "like_the_first_time",
    cost = 5,
    rarity = 1,

    config = {
        extra = {
            mult = 14,
            used_poker_hands = hand_set(),
            valid_hand = false
        }
    },

    -- #1# : Joker's given Mult
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
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
    pos = {x = 4, y = 0},

    calculate = function(self, card, context)
        -- check if hand has been played this ante
        if context.before and card.ability.extra.used_poker_hands[context.scoring_name]
          and not context.blueprint then
            card.ability.extra.valid_hand = true
            card.ability.extra.used_poker_hands[context.scoring_name] = false

        -- scoring time
        elseif context.joker_main and card.ability.extra.valid_hand then
            card.ability.extra.valid_hand = false
            return {
                mult = card.ability.extra.mult
            }

        -- reset poker hands played
        elseif G.GAME.blind.boss and context.end_of_round and context.cardarea == G.jokers
          and not context.blueprint then
            card.ability.extra.used_poker_hands = hand_set()
            return {
                message = localize("k_reset"),
                colour = G.C.RED
            }
        end
    end
}