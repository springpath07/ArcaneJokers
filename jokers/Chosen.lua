-- If the first hand of the round contains only Queens, create Strength,
-- The Hanged Man, or Death (Must have room)

SMODS.Joker {
    key = "chosen",
    cost = 8,
    rarity = 3,

    config = {
        extra = {
            is_all_queens = true
        }
    },

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 5, y = 1},

    calculate = function(self, card, context)
        local is_first_hand = G.GAME.current_round.hands_played == 0

        if context.first_hand_drawn then  -- jiggle during first hand
            local eval = function()
                return G.GAME.current_round.hands_played == 0
            end
            juice_card_until(card, eval, true)

        -- checks during first hand
        elseif context.before and is_first_hand then
            if G.GAME.consumeable_buffer == 1 then G.GAME.consumeable_buffer = 0 end
            local has_card_space = #G.consumeables.cards +
                G.GAME.consumeable_buffer < G.consumeables.config.card_limit

            if has_card_space then  -- consumable area has space to create card
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                -- queen check
                for i = 1, #context.full_hand do
                    if context.full_hand[i]:get_id() ~= 12 then
                        card.ability.extra.is_all_queens = false break
                    end
                end

                if card.ability.extra.is_all_queens then
                    local roll = pseudorandom("chosen", 1, 3)
                    if roll == 1 then  -- strength
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = SMODS.create_card({set = "Tarot", area = G.consumeables,
                                    key = "c_strength"})
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                    elseif roll == 2 then  -- the hanged man
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = SMODS.create_card({set = "Tarot", area = G.consumeables,
                                    key = "c_hanged_man"})
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                    else  -- death
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = SMODS.create_card({set = "Tarot", area = G.consumeables,
                                    key = "c_death"})
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                    end

                    -- joker text when card is created
                    card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil,
                        {message = localize("k_plus_tarot"), colour = G.C.PURPLE})

                else card.ability.extra.is_all_queens = true
                end
            end
        end
    end
}