-- If the first hand of the round contains a scoring Jack, create a random
-- Planet card (Must have room)

SMODS.Joker {
    key = "man_of_progress",
    cost = 3,
    rarity = 1,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 2, y = 0},

    calculate = function(self, card, context)
        local is_first_hand = G.GAME.current_round.hands_played == 0  -- check first hand

        if context.first_hand_drawn then  -- jiggle during first hand
            local eval = function()
                return G.GAME.current_round.hands_played == 0
            end
            juice_card_until(card, eval, true)
        end

        if context.before and is_first_hand then
            -- TODO: potential issue here (same as the former issue from tenets, check for this)
            local has_card_space = #G.consumeables.cards +
                G.GAME.consumeable_buffer < G.consumeables.config.card_limit

            if has_card_space then  -- consumable area has space to create card
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 11 then
                        -- creates planet card
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = SMODS.create_card{set = "Planet", area = G.consumeables}
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))

                        -- joker text when card is created
                        card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil,
                            {message = localize("k_plus_planet"), colour = G.C.SECONDARY_SET.Planet})
                        break
                    end
                end
            end
        end
    end
}