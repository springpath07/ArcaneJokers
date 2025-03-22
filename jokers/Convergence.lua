-- After playing 4 different poker hands, Retrigger played most-played poker hands;
-- resets when Boss Blind is defeated (4 hand types left)

SMODS.Joker {
    key = "convergence",
    cost = 7,
    rarity = 2,

    config = {
        extra = {
            unique_hands = 4,
            hands_left = 4,
            used_poker_hands = hand_set(),
            most_played = {}
        }
    },

    -- #1# : Number of unique poker hands needed to trigger effect
    -- #2# : Number of unique poker hands remaining to trigger effect
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.unique_hands,
                card.ability.extra.hands_left
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = "ArcaneJokers",
    pos = {x = 0, y = 3},

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            -- jiggle after activation
            local eval = function()
                return card.ability.extra.hands_left == 0
            end
            juice_card_until(card, eval)

            -- countdown unique poker hands
            if card.ability.extra.hands_left > 0
              and card.ability.extra.used_poker_hands[context.scoring_name] then
                card.ability.extra.used_poker_hands[context.scoring_name] = false
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
            -- get most played hands
            elseif card.ability.extra.hands_left == 0 then
                card.ability.extra.most_played = most_played_hands()
            end

        -- retrigger cards if conditions met
        elseif context.repetition and context.cardarea == G.play and #card.ability.extra.most_played > 0 then
            for i = 1, #card.ability.extra.most_played do
                if context.scoring_name == card.ability.extra.most_played[i] then
                    return {
                        message = localize("k_chronobreak_ex"),
                        repetitions = 1,
                        card = card,
                        colour = G.C.GREEN,
                        delay = 0.7
                    } end
                break
            end

        -- reset after boss blind
        elseif G.GAME.blind.boss and context.end_of_round and context.cardarea == G.jokers
          and not context.blueprint then
            card.ability.extra.hands_left = 4
            card.ability.extra.most_played = {}
            card.ability.extra.used_poker_hands = hand_set()

            return {
                message = localize("k_reset"),
                colour = G.C.GREEN,
                delay = 0.9
            }
        end
    end
}