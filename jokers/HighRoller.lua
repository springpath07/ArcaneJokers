-- Gives either +60 Chips, +30 Mult, x3 Mult, or all of the above
-- (50%, 35%, 10%, 5%); rolls for each card left in your hand (takes best roll)

SMODS.Joker {
    key = "high_roller",
    cost = 6,
    rarity = 2,

    -- #1# : Joker's given Chips
    -- #2# : Joker's given Mult
    -- #3# : Joker's given XMult
    config = {
        extra = {
            chips = 60,
            mult = 30,
            x_mult = 3,
            effect = "chips"
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult,
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
    pos = {x = 5, y = 0},

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local roll = 0
            card.ability.extra.effect = "chips"  -- reset for each hand

            -- rolls for each card left in hand
            for i = 1, #G.hand.cards do
                roll = pseudorandom("highroller", 1, 100)
                if roll <= 5 then  -- jackpot
                    card.ability.extra.effect = "all"
                    card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil,
                        {message = localize("k_jackpot_ex"), colour = G.C.GOLD, delay = 0.9})
                    break
                elseif roll <= 10 then card.ability.extra.effect = "xmult"  -- x3M
                elseif roll <= 35 and card.ability.extra.effect ~= "xmult" then  -- +30M
                    card.ability.extra.effect = "mult"
                end
            end

        -- scoring time
        elseif context.joker_main then
            if card.ability.extra.effect == "chips" then
                return {
                    chips = card.ability.extra.chips
                }
            elseif card.ability.extra.effect == "mult" then
                return {
                    mult = card.ability.extra.mult
                }
            elseif card.ability.extra.effect == "xmult" then
                return {
                    x_mult = card.ability.extra.x_mult
                }
            elseif card.ability.extra.effect == "all" then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    x_mult = card.ability.extra.x_mult
                }
            end
        end
    end
}