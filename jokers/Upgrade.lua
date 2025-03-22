-- When you enhance a playing card, it has a 1 in 4 chance of gaining Foil,
-- Holographic, or Polychrome edition

SMODS.Joker {
    key = "upgrade",
    cost = 4,
    rarity = 1,

    config = {
        extra = {
            edition_chance = 4
        }
    },

    -- #1# : Edition chance numerator
    -- #2# : Edition chance denominator
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME and G.GAME.probabilities.normal or 1,
                card.ability.extra.edition_chance
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 3, y = 0},

    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.effect == "Enhance" then
            for i = 1, #G.hand.highlighted do
                -- reset prob for each potential card
                local hit = pseudorandom("upgrade") <
                    G.GAME.probabilities.normal / card.ability.extra.edition_chance
                local upgrade_card = G.hand.highlighted[i]

                -- determine which card edition to give if it's a hit
                if hit and upgrade_card ~= nil then
                    G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.4, func = function()
                        local edition = poll_edition("upgrade", nil, true, true)
                        upgrade_card:set_edition(edition, true)
                    return true end }))

                    card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil,
                        {message = localize("k_upgrade_heim"), colour = G.C.SECONDARY_SET.Edition,
                        delay = 1})

                -- Nope!
                elseif not hit then
                    return {
                        delay = 0.9,
                        message = localize("k_nope_ex")
                    }
                end
            end
        end
    end
}