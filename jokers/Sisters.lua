-- +60 Chips and +16 Mult if hand contains a scoring 10 and 6

SMODS.Joker {
    key = "sisters",
    cost = 4,
    rarity = 1,

    config = {
        extra = {
            chips = 60,
            mult = 16,
            card1 = 10,
            card2 = 6,
            check_cards = false
        }
    },

    -- #1# : Joker's given Chips
    -- #2# : Joker's given Mult
    -- #3# : Card 1 rank criteria
    -- #4# : Card 2 rank criteria
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult,
                card.ability.extra.card1,
                card.ability.extra.card2
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 1, y = 0},

    calculate = function(self, card, context)
        if context.before then
            local check_card1 = 0  -- 10
            local check_card2 = 0  -- 6

            -- check for 10 and 6
            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].debuff then
                    local card_id = context.scoring_hand[i]:get_id()
                    if card_id == 10 then check_card1 = 1
                    elseif card_id == 6 then check_card2 = 1 end
                end
            end

            card.ability.extra.check_cards = check_card1 == 1 and check_card2 == 1

        elseif context.joker_main and card.ability.extra.check_cards then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}