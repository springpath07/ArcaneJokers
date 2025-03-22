-- Retrigger Enhanced cards 2 more times for the next 4 hands; then become Eternal and destroy
-- scoring Enhanced cards (4 remaining)

SMODS.Joker {
    key = "shimmer",
    cost = 5,
    rarity = 1,

    config = {
        extra = {
            retrigger_count = 2,
            retrigger_hands = 4,
            retriggers_left = 4,
            expired = false
        }
    },

    -- #1# : Card retrigger count
    -- #2# : Number of times effect is triggered
    -- #3# : Number of times effect triggers left
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.retrigger_count,
                card.ability.extra.retrigger_hands,
                card.ability.extra.retriggers_left
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,

    atlas = "ArcaneJokers",
    pos = {x = 0, y = 2},

    in_pool = function(self, args)
        return has_any_enhancement(nil, true)
    end,

    calculate = function(self, card, context)
        -- retrigger enhanced cards if effect still active
        if context.repetition and card.ability.extra.retriggers_left > 0 then
            if has_any_enhancement(context.other_card) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger_count,
                    card = card
                }
            end

        -- destroy cards if initial effect has expired
        elseif context.destroy_card and card.ability.extra.retriggers_left == 0
          and not context.blueprint then
            if context.cardarea == G.play then
                if has_any_enhancement(context.destroy_card) then
                    return {
                        remove = true
                    }
                end
            else  -- also destroy scoring steel cards
                if SMODS.has_enhancement(context.destroy_card, "m_steel") then
                    return {
                        remove = true
                    }
                end
            end

        -- count down retriggers left
        elseif context.after and context.cardarea == G.jokers
          and card.ability.extra.retriggers_left > 0 and not context.blueprint then
            if card.ability.extra.retriggers_left == 1 then
                card.ability.extra.retriggers_left = 0
                -- set eternal
                if not card.ability.extra.expired then
                    card.ability.extra.expired = true
                    card:set_eternal(true)
                    card_eval_status_text(card, "extra", nil, nil, nil, {
                        message = localize("k_hooked_ex"),
                        colour = G.C.ETERNAL,
                        delay = 0.45
                    })
                end
            else
                card.ability.extra.retriggers_left = card.ability.extra.retriggers_left - 1
                card_eval_status_text(card, "extra", nil, nil, nil, {
                    message = localize {
                        type = "variable",
                        key = "a_remaining",
                        vars = {card.ability.extra.retriggers_left}
                    },
                    colour = G.C.PURPLE,
                    delay = 0.45
                })
            end
        end
    end
}