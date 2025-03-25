-- Scoring Wild Cards permanently gain +4 Mult

SMODS.Joker {
    key = "hound",
    cost = 4,
    rarity = 1,

    config = {
        extra = {
            card_mult_gain = 4
        }
    },

    -- #1# : Wild Cards' gained Mult
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
        return {
            vars = {
                card.ability.extra.card_mult_gain
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 3, y = 3},

    in_pool = function(self, args)
        return has_wild_cards()
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, "m_wild") and not
              context.other_card.debuff then
                context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
                context.other_card.ability.perma_mult = context.other_card.ability.perma_mult +
                    card.ability.extra.card_mult_gain
                return {
                    extra = {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT
                    },
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
    end

}