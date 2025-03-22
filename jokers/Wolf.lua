-- If hand contains a scoring Wild Card, another random scoring card becomes a Wild Card

SMODS.Joker {
    key = "wolf",
    cost = 4,
    rarity = 1,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    atlas = "ArcaneJokers",
    pos = {x = 2, y = 3},

    in_pool = function(self, args)
        return has_wild_cards()
    end,

    calculate = function(self, card, context)
        if context.before then
            local wild_debuff = 0
            local wild_count = 0
            local has_wild = false
            local scoring_count = #context.scoring_hand

            -- check which, if any, cards are wild
            for i = 1, scoring_count do
                if SMODS.has_enhancement(context.scoring_hand[i], "m_wild") then
                    has_wild = true
                    if context.scoring_hand[i].debuff then
                        wild_debuff = wild_debuff + 1
                        has_wild = false
                    end
                    wild_count = wild_count + 1
                end
            end

            -- enhance another scoring card to be wild if possible (CAN overwrite other enhancements!)
            if has_wild and scoring_count > 1 and wild_count + wild_debuff < scoring_count then
                local roll = pseudorandom("shimmer", 1, scoring_count)

                -- rerolls until we get scoring card that isn't already wild
                while SMODS.has_enhancement(context.scoring_hand[roll], "m_wild") do
                    roll = pseudorandom("shimmer", 1, scoring_count)
                end

                context.scoring_hand[roll]:set_ability(G.P_CENTERS.m_wild, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.scoring_hand[roll]:juice_up()
                        return true end
                }))

                has_wild = false  -- reset

                if context.scoring_hand[roll] ~= nil then
                    return {
                        extra = localize("k_gonewild_ex"),
                        colour = G.C.PURPLE,
                        card = card
                    }
                end
            end
        end
    end
}