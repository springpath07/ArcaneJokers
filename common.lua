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

-- returns number of [rank] held in hand
function held_in_hand(rank)
    local n = 0
    if G.hand and G.hand.cards then
        for k, v in pairs(G.hand.cards) do
            if v:get_id() == rank then
                n = n + 1
            end
        end
    end
    return n
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

-- un-debuffs cards, currently only indiv. playing cards but may change later
function remove_bleeding_heart_debuff()
    for k, v in pairs(G.playing_cards) do
        if v.ability.s_six_h and not v.perma_debuff then
            v.ability.s_six_h = false
            v:set_debuff(false)
        end
    end
end