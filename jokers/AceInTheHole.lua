-- Gains +3 Mult per scoring Ace in a [Poker Hand]
-- (hand changes each round) (Currently +0 Mult)

SMODS.Joker {
    key = "ace_in_the_hole",
    cost = 6,
    rarity = 2,

    config = {
        extra = {
            mult_gain = 3,
            aith_hand = nil,
            mult = 0
        }
    },

    -- get initial poker hand (ref. "To-Do List" implementation)
    set_ability = function(self, card, initial)
        local poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible then poker_hands[#poker_hands + 1] = k end
        end
        local old_hand = card.ability.extra.aith_hand
        card.ability.extra.aith_hand = nil
        while not card.ability.extra.aith_hand do
            card.ability.extra.aith_hand = pseudorandom_element(poker_hands,
                pseudoseed("aceinthehole"))
            if card.ability.extra.aith_hand == old_hand then
                card.ability.extra.aith_hand = nil end
        end
    end,

    -- #1# : Joker's gained Mult when criteria is matched
    -- #2# : Current poker hand
    -- #3# : Current extra Mult Joker is giving
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult_gain,
                localize(card.ability.extra.aith_hand, "poker_hands"),
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
    pos = {x = 0, y = 0},

    calculate = function(self, card, context)
        if context.individual and not context.blueprint and
          (context.scoring_name == card.ability.extra.aith_hand) then
            -- add mult to joker if conditions are met
            if context.other_card:get_id() == 14 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    extra = {focus = card, message = localize('k_upgrade_ex'), colour = HEX("000833")},
                    card = card
                }
            end

        -- return mult during scoring time
        elseif context.joker_main and (card.ability.extra.mult > 0) then
            return {
                mult = card.ability.extra.mult
            }

        -- change poker hand at end of round (ref. "To-Do List" implementation)
        elseif context.end_of_round and not context.blueprint and context.cardarea == G.jokers then
            local poker_hands = {}

            for k, v in pairs(G.GAME.hands) do
                if v.visible and k ~= card.ability.extra.aith_hand then
                    poker_hands[#poker_hands + 1] = k end
            end

            card.ability.extra.aith_hand = pseudorandom_element(poker_hands, pseudoseed("aceinthehole"))

            return {
                delay = 0.9,
                message = localize("k_new_target"),
                colour = HEX("000833")
            }
        end
    end
}