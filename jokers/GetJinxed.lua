-- Select to use on this hand and reset. Gains x0.2 Mult and 1 in 50
-- chance to fail when used for each discarded card
-- (Currently x1 Mult, 1 in 50 chance to fail)

SMODS.Joker {
    key = "get_jinxed",
    cost = 9,
    rarity = 3,

    config = {
        extra = {
            x_mult_gain = 0.2,
            num_failure = 0,
            den_failure = 50,
            x_mult = 1,
            base_failure = 1,
            used = false
        }
    },

    -- #1# : Joker's gained XMult when criteria is matched
    -- #2# : Failure chance numerator
    -- #3# : Failure chance denominator
    -- #4# : Current extra XMult Joker is giving
    -- #5# : Additive failure chance
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.x_mult_gain,
                card.ability.extra.num_failure,
                card.ability.extra.den_failure,
                card.ability.extra.x_mult,
                card.ability.extra.base_failure
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    atlas = "ArcaneJokers",
    pos = {x = 2, y = 1},

    -- TODO: maybe look into doing a floating hologram-esque of the jinx graffiti when the joker
    -- is selected in game
    calculate = function(self, card, context)
        -- adds xmult and failure chance for each discard
        if context.discard and not context.other_card.debuff and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
            local buffer = card.ability.extra.num_failure + card.ability.extra.base_failure

            if buffer <= card.ability.extra.den_failure then card.ability.extra.num_failure = buffer end

            return {
                message = localize{type = "variable", key = "a_xmult",
                    vars = {card.ability.extra.x_mult}},
                colour = G.C.RED,
                delay = 0.45,
                card = card,
            }

        -- detonate if using on this current hand
        elseif context.joker_main and (card.ability.extra.x_mult > 1) then
            if card.highlighted then
                card.ability.extra.used = true
                local fail_prob = (G.GAME.probabilities.normal * card.ability.extra.num_failure) / card.ability.extra.den_failure

                if pseudorandom("getjinxed") < fail_prob then
                    return {
                        message = localize("k_jinxed_ex"),
                        colour = HEX("00B3FF"),
                        delay = 0.9
                    }
                else return {
                    x_mult = card.ability.extra.x_mult
                }
                end
            end

        -- reset to default values if it was used on prev. hand
        elseif context.after and not context.blueprint then
            if card.ability.extra.used then
                G.jokers:remove_from_highlighted(card)  -- deselect joker
                card.ability.extra.used = false
                card.ability.extra.x_mult = 1
                card.ability.extra.num_failure = 0
            end
        end
    end,

}