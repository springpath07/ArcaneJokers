-- Gives x0.5 Mult per Ace held in hand; discards an Ace after each hand

SMODS.Joker {
    key = "gunpowder",
    cost = 7,
    rarity = 2,

    config = {
        extra = {
            x_mult_gain = 0.5,
        }
    },

    -- #1# : Joker's gained Mult when criteria is matched
    -- #2# : Current extra Mult Joker is giving
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.x_mult_gain,
                math.max(1, 1 + card.ability.extra.x_mult_gain * held_in_hand(14))
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 4, y = 2},

    calculate = function(self, card, context)
        -- calc xmult
        if context.scoring_hand and context.joker_main then
            local x_mult = math.max(1, 1 + card.ability.extra.x_mult_gain * held_in_hand(14))
            if x_mult > 1 then
                return {
                    message = localize{type = "variable", key = "a_xmult", vars = {x_mult}},
                    colour = G.C.XMULT
                }
            end

        -- discard a random (non-debuffed) ace if there's >= 1 ace in hand (ref. "The Hook" implementation)
        elseif context.after and not context.blueprint then
            G.E_MANAGER:add_event(Event({ func = function()
                local any_selected = nil
                local aces = {}

                for k, v in ipairs(G.hand.cards) do
                    if v:get_id() == 14 then aces[#aces + 1] = v end
                end

                if #aces > 0 then
                    local selected_card, card_key = pseudorandom_element(aces, pseudoseed('gunpowder'))
                    G.hand:add_to_highlighted(selected_card, true)
                    table.remove(aces, card_key)
                    any_selected = true
                    play_sound("card1", 1)
                end

                if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
            return true end }))
        end
    end
}