-- un-debuffs cards, currently only indiv. playing cards but may change later
function remove_debuffs_in_deck()
    for k, v in pairs(G.playing_cards) do
        if v.base.id == 6 and v.base.suit == "Hearts" and not v.perma_debuff then
            v.ability.s_six_h = false
            v:set_debuff(false)
        end
    end
end

-- return list of most played hands
function most_played_hands()
    local most_played_count = 0
    local hands = {}

    -- k: hand name (e.g., context.scoring_name)
    for k, v in pairs(G.GAME.hands) do
        if v.played >= most_played_count and v.visible then
            if v.played > most_played_count then
                hands = {}
                most_played_count = v.played
            end
            hands[#hands + 1] = k
        end
    end

    return hands
end

-- check if card/deck has any enhancements (bonus, mult, wild, glass, steel, stone, gold, lucky)
function has_any_enhancement(card, deck)
    local enhancement_list = {
        "m_bonus",
        "m_mult",
        "m_wild",
        "m_glass",
        "m_steel",
        "m_stone",
        "m_gold",
        "m_lucky"
    }

    if deck == nil then
        -- checks for enhancements for a singular card
        for i = 1, #enhancement_list do
            if card ~= nil and SMODS.has_enhancement(card, enhancement_list[i]) then return true end
        end
    else
        -- checks for enhancements in deck
        for k, v in pairs(G.playing_cards) do
            for i = 1, #enhancement_list do
                if v ~= nil and SMODS.has_enhancement(v, enhancement_list[i]) then return true end
            end
        end
    end

    return false
end

-- check if card has any modification (edition, seal, enhancement)
function has_modification(card)
    -- checks for seal or edition
    if card.seal or card.edition or has_any_enhancement(card) then return true end

    return false
end

-- check if deck has wild cards
function has_wild_cards()
    for k, v in pairs(G.playing_cards) do
        if SMODS.has_enhancement(v, "m_wild") then return true end
    end

    return false
end

-- create set of all hands
function hand_set()
    local poker_hands = {
        ["Flush Five"] = true,
        ["Flush House"] = true,
        ["Five of a Kind"] = true,
        ["Straight Flush"] = true,
        ["Four of a Kind"] = true,
        ["Full House"] = true,
        ["Flush"] = true,
        ["Straight"] = true,
        ["Three of a Kind"] = true,
        ["Two Pair"] = true,
        ["Pair"] = true,
        ["High Card"] = true
    }

    return poker_hands
end

-- set of arcane jokers
function arcane_joker_set()
    local arc_joker_set = {
        "j_arc_ace_in_the_hole",
        "j_arc_bleeding_heart",
        "j_arc_chosen",
        "j_arc_convergence",
        "j_arc_get_jinxed",
        "j_arc_glorious_evolution",
        "j_arc_gravity",
        "j_arc_gunpowder",
        "j_arc_high_roller",
        "j_arc_hound",
        "j_arc_league",
        "j_arc_like_the_first_time",
        "j_arc_man_of_progress",
        "j_arc_mastermind",
        "j_arc_mirror_mirror",
        "j_arc_oil_and_water",
        "j_arc_progress_day",
        "j_arc_shimmer",
        "j_arc_sisters",
        "j_arc_tenets",
        "j_arc_upgrade",
        "j_arc_wolf"
    }

    return arc_joker_set
end

-- SEE: functions/UI_definitions.lua -> function G.UIDEF.use_and_sell_buttons(card)
-- function create_use_button(card)
--     local current_card = G.UIDEF.use_and_sell_buttons(card)
--     if G.jokers and card.area.config.type == "joker" then
--         local button_use = current_card.nodes[1].nodes[2].nodes[1]
--     end
-- end

-- local use = {
--     n = G.UIT.C,
--     config = {align = "cr"},
--     nodes = {
--         {
--             n = G.UIT.C,
--             config = {
--                 ref_table = card,
--                 align = "cr",
--                 maxw = 1.25,
--                 padding = 0.1,
--                 r=0.08,
--                 minw = 1.25,
--                 minh = (card.area and card.area.config.type == 'joker') and 0 or 1,
--                 hover = true,
--                 shadow = true,
--                 colour = G.C.UI.BACKGROUND_INACTIVE,
--                 one_press = true,
--                 button = 'use_card',
--                 func = 'can_use_consumeable'
--             },
--             nodes = {
--                 {
--                     n = G.UIT.B,
--                     config = {w=0.1,h=0.6}
--                 },
--                 {
--                     n = G.UIT.T,
--                     config = {
--                         text = localize('b_use'),
--                         colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true
--                     }
--                 }
--             }
--         }
--     }
-- }

-- local sell = {
--     n = G.UIT.C,
--     config = {align = "cr"},
--     nodes = {
--         {n = G.UIT.C,
--             config = {
--                 ref_table = card, align = "cr", padding = 0.1, r = 0.08, minw = 1.25,
--                 hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE,
--                 one_press = true, button = 'sell_card', func = 'can_sell_card'
--             },
--             nodes = {
--                 {
--                     n = G.UIT.B, config = {w=0.1,h=0.6}
--                 },
--                 {
--                     n = G.UIT.C, config={align = "tm"},
--                     nodes = {
--                         {
--                             n = G.UIT.R, config={align = "cm", maxw = 1.25},
--                             nodes = {
--                                 {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
--                             }
--                         },
--                         {
--                             n=G.UIT.R, config={align = "cm"},
--                             nodes = {
--                                 {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
--                                 {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
--                             }
--                         }
--                     }
--                 }
--             }
--         },
--     }
-- }


-- local t = {
--     n = G.UIT.ROOT,
--     config = {
--         padding = 0, 
--         colour = G.C.CLEAR
--     },
--     nodes = {
--         {
--             n = G.UIT.C,
--             config = {padding = 0.15, align = 'cl'},
--             nodes = {
--                 {
--                     n = G.UIT.R,
--                     config = {align = 'cl'}, 
--                     nodes = {sell}
--                 },
--                 {
--                     n = G.UIT.R,
--                     config={align = 'cl'},
--                     nodes={use}
--                 },
--             }
--         },
--     }
-- }

-- t.nodes[1].nodes[2].nodes[1]

