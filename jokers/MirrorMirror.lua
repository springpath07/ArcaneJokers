-- Gains scoring Queens' Chip and Mult modifiers (Currently +0 Chips, +0 Mult)

SMODS.Joker {
    key = "mirror_mirror",
    cost = 8,
    rarity = 3,

    config = {
        extra = {
            chips = 0,
            mult = 0
        }
    },

    -- #1# : Current extra Chips Joker is giving
    -- #2# : Current extra Mult Joker is giving
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips,
                card.ability.extra.mult
            }
        }
    end,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    atlas = "ArcaneJokers",
    pos = {x = 1, y = 1},

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for i = 1, #context.scoring_hand do
                local current_card = context.scoring_hand[i]

                if current_card:get_id() == 12 and not current_card.debuff then
                    -- addt. chips/mult from relevant enhanced cards (bonus/mult/lucky)
                    if SMODS.has_enhancement(current_card, "m_bonus") then  -- bonus
                        card.ability.extra.chips = card.ability.extra.chips + 30
                        card_eval_status_text(card, "chips", 30)
                    elseif SMODS.has_enhancement(current_card, "m_mult") then  -- mult
                        card.ability.extra.mult = card.ability.extra.mult + 4
                        card_eval_status_text(card, "mult", 4)
                    elseif SMODS.has_enhancement(current_card, "m_lucky") then  -- lucky
                        -- ref. base game's lucky card implementation
                        if (pseudorandom("lucky_mult") < G.GAME.probabilities.normal / 5) then
                            card.ability.extra.mult = card.ability.extra.mult + 20
                            card_eval_status_text(card, "mult", 20)
                        end
                    end

                    -- addt. chips/mult from individual card permabonuses
                    if current_card.ability.perma_bonus > 0 then  -- bonus chips
                        card.ability.extra.chips = card.ability.extra.chips + current_card.ability.perma_bonus
                        card_eval_status_text(card, "chips",
                            current_card.ability.perma_bonus)
                    end
                    if current_card.ability.perma_mult > 0 then  -- bonus mult
                        card.ability.extra.mult = card.ability.extra.mult + current_card.ability.perma_mult
                        card_eval_status_text(card, "mult",
                            current_card.ability.perma_mult)
                    end

                    -- addt. chips/mult from relevant editions (foil/holo)
                    if card.edition then
                        if card.edition.key == "e_foil" then  -- foil
                            card.ability.extra.chips = card.ability.extra.chips + 50
                            card_eval_status_text(card, "chips", 50)
                        elseif card.edition.key == "e_holo" then  -- holo
                            card.ability.extra.mult = card.ability.extra.mult + 10
                            card_eval_status_text(card, "mult", 10)
                        end
                    end
                end
            end

        -- set joker's current given chips/mult during scoring time
        elseif context.joker_main and (card.ability.extra.mult > 0 or card.ability.extra.chips > 0) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
}