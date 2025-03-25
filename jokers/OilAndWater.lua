-- x2 Mult if scoring hand contains exactly one Heart and Spade

SMODS.Joker {
    key = "oil_and_water",
    cost = 5,
    rarity = 1,

    config = {
        extra = {
            x_mult = 2,
            check_cards = false
        }
    },

    -- #1# : Joker's given XMult
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.x_mult
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 0, y = 1},

    calculate = function(self, card, context)
        local check_one_spade = 0
        local check_one_heart = 0

        if context.before then
            -- checks for EXACTLY 1 spade and heart
            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].debuff then
                    if context.scoring_hand[i]:is_suit("Spades") then
                        if check_one_spade == 0 then check_one_spade = 1
                        elseif check_one_spade == 1 then check_one_spade = 0 break end
                    elseif context.scoring_hand[i]:is_suit("Hearts") then
                        if check_one_heart == 0 then check_one_heart = 1
                        elseif check_one_heart == 1 then check_one_heart = 0 break end
                    end
                end
            end

            card.ability.extra.check_cards = check_one_spade == 1 and check_one_heart == 1

        -- returns xmult if conditions met
        elseif context.joker_main and card.ability.extra.check_cards then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}