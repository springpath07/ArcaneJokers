-- When you add a Modified card to your deck, 1 in 2 chance of adding an exact copy

SMODS.Joker {
    key = "glorious_evolution",
    cost = 8,
    rarity = 2,

    config = {
        extra = {
            copy_chance = 2
        }
    },

    -- #1# : Copy chance
    -- #2# : Copy chance denominator
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME and G.GAME.probabilities.normal or 1,
                card.ability.extra.copy_chance
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 1, y = 3},

    calculate = function(self, card, context)
        if context.playing_card_added and not card.getting_sliced then
            if context.cards and context.cards[1] then
                if has_modification(context.cards[1]) and pseudorandom("gloriousevo")
                  < G.GAME.probabilities.normal / card.ability.extra.copy_chance then
                    -- adds card to deck (ref. "DNA" implementation)
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local ge_card = copy_card(context.cards[1], nil, nil, G.playing_card)
                    ge_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, ge_card)
                    ge_card.states.visible = nil

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ge_card:start_materialize()
                            return true
                        end
                    }))

                    card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil,
                        {message = localize("k_created_ex"),
                        colour = G.C.GREY,
                        delay = 0.9})

                    -- hacky fix for Hologram bc it doesn't add xmult for the created card...
                    for j = 1, #G.jokers.cards do
                        if G.jokers.cards[j].ability.name == "Hologram" and not context.blueprint then
                            G.jokers.cards[j].ability.x_mult = G.jokers.cards[j].ability.x_mult
                                + G.jokers.cards[j].ability.extra

                            card_eval_status_text(G.jokers.cards[j], 'extra', nil, nil, nil,
                                {message = localize{type = 'variable', key = 'a_xmult',
                                vars = {G.jokers.cards[j].ability.x_mult}}})
                        end
                    end
                end
            end
        end
    end
}