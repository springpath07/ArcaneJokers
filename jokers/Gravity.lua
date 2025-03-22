-- For every 6 Planet cards used, create a Black Hole (Must have room, 6 remaining)

SMODS.Joker {
    key = "gravity",
    cost = 8,
    rarity = 3,

    config = {
        extra = {
            p_cards = 6,
            p_remaining = 6
        }
    },

    -- #1# : Planet cards remaining
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.p_cards,
                card.ability.extra.p_remaining
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 1, y = 2},

    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable.ability.set == "Planet" then
                card.ability.extra.p_remaining = card.ability.extra.p_remaining - 1

                -- card countdown
                if not context.blueprint and card.ability.p_remaining ~= 0 then
                    card_eval_status_text(card,
                            'extra', nil, nil, nil,
                            {message = localize{type = "variable", key = "a_remaining",
                            vars = {card.ability.extra.p_remaining}},
                            colour = G.C.SECONDARY_SET.Spectral})
                end

                -- create black hole if there's space
                if card.ability.extra.p_remaining == 0 then
                    if G.GAME.consumeable_buffer == 1 then G.GAME.consumeable_buffer = 0 end

                    local has_card_space = #G.consumeables.cards +
                        G.GAME.consumeable_buffer < G.consumeables.config.card_limit
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    card.ability.extra.p_remaining = 6  -- reset

                    if has_card_space then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = SMODS.create_card({set = "Spectral", area = G.consumeables,
                                    key = "c_black_hole"})
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        card_eval_status_text(context.blueprint_card or card,
                            'extra', nil, nil, nil,
                            {message = localize('k_activate_ex'),
                            colour = G.C.SECONDARY_SET.Spectral})
                    end
                end
            end
        end
    end
}