-- Gains x0.2 Mult per scoring 6 of Hearts; scored 6 of Hearts are debuffed
-- for the rest of the Ante (Currently x1 Mult)

SMODS.Joker {
    key = "bleeding_heart",
    cost = 7,
    rarity = 2,

    config = {
        extra = {
            x_mult_gain = 0.2,
            x_mult = 1
        }
    },

    -- #1# : Joker's gained XMult when criteria is matched
    -- #2# : Current extra XMult Joker is giving
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.x_mult_gain,
                card.ability.extra.x_mult
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    atlas = "ArcaneJokers",
    pos = {x = 3, y = 2},

    calculate = function(self, card, context)
        if context.individual and not context.blueprint then
            -- adds xmult if requirements met
            if context.other_card:get_id() == 6 and context.other_card:is_suit("Hearts") then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                context.other_card.ability.s_six_h = true  -- tag for card to be debuffed for rest of ante
                context.other_card:set_debuff(true)
                return {
                    extra = {focus = card, message = localize("k_upgrade_ex"), colour = HEX("FF005F")},
                    card = card
                }
            end

        -- return xmult during scoring time
        elseif context.joker_main and (card.ability.extra.x_mult > 0) then
            return {
                x_mult = card.ability.extra.x_mult
            }

        -- removes debuffs on played 6Hs at end of ante
        elseif G.GAME.blind.boss and context.end_of_round and context.cardarea == G.jokers
          and not context.blueprint then
            remove_bleeding_heart_debuff()
            return {
                delay = 1,
                message = localize("k_debuffs_reset"),
                colour = HEX("FF005F")
            }
        end
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and G.GAME.blind.name ~= "The Head" then
            for k, v in pairs(G.playing_cards) do
                if v.ability.s_six_h then v:set_debuff(true) end
            end
        end
    end
}