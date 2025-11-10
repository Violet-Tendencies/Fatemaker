SMODS.Consumable {
    key = 'clown_cartridge',
    loc_txt = {
        name = "Clown Cartridge",
        text = {
            "Draw up to {C:attention}5{} extra cards"
        }
    },
    set = 'traits',
    atlas = 'Consumables',
    discovered = false,
    pos = { x = 4, y = 0 },
    use = function(self, card, area, copier)
        local odds = {
            1,
            2,
            3,
            4,
            5
        }
        for i = 1, pseudorandom_element(odds, pseudoseed('Balalalala')) do
            draw_card(G.deck, G.hand, 90, 'up', nil)
        end
    end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}

SMODS.Consumable {
    key = 'vivisection',
    loc_txt = {
        name = "Vivisection",
        text = {
            "Draw a card, Dissect it but",
            "debuff it until the end of the round"
        }
    },
    set = 'traits',
    atlas = 'Consumables',
    discovered = false,
    pos = { x = 6, y = 0 },
    use = function(self, card, area, copier)
        local _cards = {}
        for _, playing_card in ipairs(G.playing_cards) do
            _cards[#_cards + 1] = playing_card
        end
        local selected_card = pseudorandom_element(_cards, pseudoseed('Balalalala'))

        draw_card(G.deck, G.hand, 90, 'up', nil, selected_card)

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.5,
            func = function()
                selected_card:flip()
                selected_card:set_ability(G.P_CENTERS.m_fm_dissected)
                SMODS.debuff_card(selected_card, true, "vivisected")
                selected_card.ability.vivisected = true
                selected_card:flip()
                return true
            end
        }))

        local end_round_ref = end_round
        function end_round()
            local ret = end_round_ref()
            for _,v in ipairs(G.playing_cards) do
                if v.ability.vivisected then
                    v.ability.vivisected = false
                    SMODS.debuff_card(v, false, "vivisected")
                end
            end
            return ret
        end
    end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
}

SMODS.Consumable {
    key = 'kinetic_tremors',
    loc_txt = {
        name = "Kinetic Tremors",
        text = {
            "Select a card, create two copies of it with",
            "a Red seal that get destroyed on round end"
        }
    },
    atlas = 'Consumables',
    discovered = false,
    set = 'traits',
    pos = { x = 3, y = 0 },
    use = function(self, card, area, copier)
        local destroy = false

        local destroyList = {}

        for i = 1, 2 do
            local selectedCard = G.hand.highlighted[1]
            local new_card = copy_card(selectedCard, nil, nil, G.playing_card)
            new_card:set_seal("Red")
            new_card.T.y = selectedCard.T.y - G.CARD_H
            table.insert(G.playing_cards, new_card)
            G.hand.config.card_limit = G.hand.config.card_limit + 1
            draw_card(G.hand, G.hand, 90, 'up', nil, new_card)
            table.insert(destroyList, new_card)
            new_card:start_materialize()
        end

        local end_round_ref = end_round
        function end_round()
            local ret = end_round_ref()
            for i, _ in ipairs(destroyList) do
                SMODS.destroy_cards(destroyList[i])
            end
            return ret
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= 1 and
            #G.hand.highlighted <= 1
    end
}

SMODS.Consumable {
    key = 'voltshot',
    loc_txt = {
        name = "Voltshot",
        text = {
            "Select up to 2 cards, Jolt them and grant them +10 mult"
        }
    },
    atlas = 'Consumables',
    set = 'traits',
    discovered = false,
    pos = { x = 7, y = 0 },
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
            handCard = G.hand.highlighted[i]
            handCard:flip()
            handCard:set_ability(G.P_CENTERS.m_fm_jolt)
            handCard.ability.perma_mult = handCard.ability.perma_mult + 10
            handCard:flip()
        end        
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= 1 and
            #G.hand.highlighted <= 2
    end
}

SMODS.Consumable {
    key = 'reconstruction',
    loc_txt = {
        name = "Reconstruction",
        text = {
            "Draw 1 card for each",
            "hand played this round"
        }
    },
    discovered = false,
    atlas = 'Consumables',
    set = 'traits',
    pos = { x = 2, y = 1 },
    use = function(self, card, area, copier)
        for i = 1, G.GAME.current_round.hands_played do
           draw_card(G.deck, G.hand, 90, 'up', false)
        end
    end,
    can_use = function(self, card)
        return G.consumeables and G.GAME.current_round.hands_played > 0
    end
}

SMODS.Consumable {
    key = 'recombination',
    loc_txt = {
        name = "Recombination",
        text = {
            "Add +1 to mult per Enhanced card held, up to +10",
            "{C:inactive}(Can’t be used, triggers automatically, self destructs after triggering){}"
        }
    },
    atlas = 'Consumables',
    set = 'traits',
    pos = { x = 2, y = 1 },
    discovered = false,
    calculate = function (self, card, context)
        local amount = 0
        if context.joker_main then
            for _, handCard in ipairs(G.hand.cards) do
                if handCard.ability.set == "Enhanced" then
                    amount = amount + 1
                end
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    card:start_dissolve()
                    return true
                end
            }))
            return {
                mult = amount
            }
        end   
    end
}

SMODS.Consumable {
    key = 'wewind_wounds',
    loc_txt = {
        name = "Rewind Rounds",
        text = {
            "Draw a random card from the",
            "last played hand"
        }
    },
    atlas = 'Consumables',
    set = 'traits',
    discovered = false,
    pos = { x = 2, y = 1 },
    config = {
        extra = {
            last_round_cards = {}
        }
    },
    calculate = function (self, card, context)
        if context.before then
            card.ability.extra.last_round_cards = {}
        end
        if context.joker_main then
            for i, scoredCard in ipairs(context.scoring_hand) do
                table.insert(card.ability.extra.last_round_cards, scoredCard)
            end
        end   
    end,
    use = function(self, card, area, copier)
        local i = pseudorandom("card", 1, #card.ability.extra.last_round_cards)
        CArd = card.ability.extra.last_round_cards[i]

        for i, _ in ipairs(G.discard.cards) do
            if G.discard.cards[i] == CArd then
                draw_card(G.discard, G.hand, 90, 'up', nil, CArd)
                table.remove(card.ability.extra.last_round_cards, i)
            end
        end
    end,
    can_use = function(self, card)
        return G.consumeables and G.GAME.blind.in_blind and #(card.ability.extra.last_round_cards) >= 1
    end

}

SMODS.Consumable {
    key = 'precision_instrument',
    loc_txt = {
        name = "Precision Instrument",
        text = {
            "Scoring at least one Ace per hand",
            "will grant this card +10 Mult (limit +100).",
            "Self destructs when a hand is played with no Aces in it",
            "{C:inactive}(Currently #1#){}"
        }
    },
    atlas = 'Consumables',
    discovered = false,
    set = 'traits',
    pos = { x = 2, y = 1 },
    config = {
        extra = {
            mult = 0,
            containsAce = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult or 0 } }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            card.ability.extra.containsAce = false
            for i, scoredCard in ipairs(context.scoring_hand) do
                if scoredCard.base.value == "Ace" then
                    card.ability.extra.containsAce = true
                end
            end
            if card.ability.extra.containsAce == false then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        card:start_dissolve()
                        return true
                    end
                }))
            else
                if card.ability.extra.mult < 100 then
                card.ability.extra.mult = card.ability.extra.mult + 10
                end
                return {
                    mult = card.ability.extra.mult
                }
            end
        end  
    end
}

SMODS.Consumable {
    key = 'destabilizing_rounds',
    loc_txt = {
        name = "Destabilizing Rounds",
        text = {
            "Select up to 3 cards, discard them and draw",
            "cards equal to the amount of cards discarded",
            "All cards drawn this way become Volatile"
        }
    },
    atlas = 'Consumables',
    set = 'traits',
    discovered = false,
    pos = { x = 8, y = 0 },
    use = function(self, card, area, copier)

        local drawCards = #G.hand.highlighted
        G.FUNCS.discard_cards_from_highlighted(nil, true)

        for i = 1, drawCards do
            local _cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                _cards[#_cards + 1] = playing_card
            end
            local selected_card = pseudorandom_element(_cards, pseudoseed('Balalalala'))

            draw_card(G.deck, G.hand, 90, 'up', nil, selected_card)

            selected_card:flip()
            if not SMODS.has_enhancement(selected_card, "m_fm_blinded") then
                selected_card:flip()
            end
            selected_card:set_ability(G.P_CENTERS.m_fm_volatile)
        end
    end,
    can_use = function(self, card)
        return G.consumeables and #G.hand.highlighted >= 1 and
            #G.hand.highlighted <= 3
    end
}

SMODS.Consumable {
    key = 'hatchling',
    loc_txt = {
        name = "Hatchling",
        text = {
            "Create an Unraveled duplicate of the selected card"
        }
    },
    atlas = 'Consumables',
    discovered = false,
    set = 'traits',
    pos = { x = 9, y = 0 },
    use = function(self, card, area, copier)
        local new_card = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
        new_card:set_ability(G.P_CENTERS.m_fm_unravel)
        new_card.T.y = G.hand.highlighted[1].T.y - G.CARD_H
        table.insert(G.playing_cards, new_card)
        G.deck.config.card_limit = G.deck.config.card_limit + 1
        draw_card(G.hand, G.deck, 90, 'up', nil, new_card)
        new_card:start_materialize()
    end,
    can_use = function(self, card)
        return G.consumeables and #G.hand.highlighted >= 1 and
            #G.hand.highlighted <= 1
    end
}

SMODS.Consumable {
    key = 'souldrinker',
    loc_txt = {
        name = "Souldrinker",
        text = {
            "Grant +1 hand per every two cards scored last hand",
            "{C:inactive}(Currently: #1#){}"
        }
    },
    atlas = 'Consumables',
    discovered = false,
    set = 'traits',
    pos = { x = 0, y = 1 },
    config = {
        extra = {
            souls = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.souls or 0 } }
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step then
            card.ability.extra.souls = math.ceil(#G.play.cards/2)
        end
    end,
    use = function(self, card, area, copier)
        ease_hands_played(card.ability.extra.souls)
    end,
    can_use = function(self, card)
        return G.consumeables and G.GAME.blind.in_blind
    end
}

SMODS.Consumable {
    key = 'ambush',
    loc_txt = {
        name = "Ambush",
        text = {
            "When used, discard the top 5 cards",
            "in hand and draw 5 new cards",
            "Cards drawn this way will be the",
            "highest rank cards avalible in the deck"
        }
    },
    atlas = 'Consumables',
    discovered = false,
    set = 'traits',
    pos = { x = 1, y = 1 },
    use = function(self, card, area, copier)
        for i=1, 5 do
            G.hand:add_to_highlighted(G.hand.cards[i])
            if i >= 5 then
                break
            end
        end
        G.FUNCS.discard_cards_from_highlighted(nil, true)
        local _cards = {}
        for _, playing_card in ipairs(G.deck.cards) do
            _cards[#_cards + 1] = playing_card
        end

        table.sort(_cards, function(a, b) return a:get_id() > b:get_id() end)

        for i = 1, 5 do
            draw_card(G.deck, G.hand, 90, 'up', nil, _cards[i])
        end
    end,
    can_use = function(self, card)
        return G.consumeables and G.GAME.blind.in_blind
    end
}

SMODS.Consumable {
    key = 'frenzy',
    loc_txt = {
        name = "Frenzy",
        text = {
            "Grant +1 hand size and +25",
            "chips to 1 selected card",
            "per amount of hands played",
            "Draw cards equal to the amount",
            "of hand size gained this way"
        }
    },
    discovered = false,
    atlas = 'Consumables',
    set = 'traits',
    pos = { x = 2, y = 1 },
    use = function(self, card, area, copier)
        local CArd = G.hand.highlighted[1]
        local amountA = 25 * G.GAME.current_round.hands_played
        local amountB = G.GAME.current_round.hands_played
        CArd.ability.perma_bonus = CArd.ability.perma_bonus + amountA
        G.hand:change_size(amountB)
        for i = 1, amountB do
            draw_card(G.deck, G.hand, 90, 'up', nil)
        end

        local end_round_ref = end_round
        function end_round()
            local ret = end_round_ref()
            CArd.ability.perma_bonus = CArd.ability.perma_bonus - amountA
            G.hand:change_size(amountB)
            return ret
        end
    end,
    can_use = function(self, card)
        return G.consumeables and G.GAME.current_round.hands_played > 0 and G.GAME.blind.in_blind and #G.hand.highlighted >= 1 and #G.hand.highlighted <= 1
    end
}

SMODS.Consumable {
    key = 'bait_and_switch',
    loc_txt = {
        name = "Bait and Switch",
        text = {
            "Select 3 cards, discard the leftmost and rightmost cards,",
            "but the middle one grants 2x chips and +20 mult when scored",
            "(Stacks infinitely, bonus removed on round end)"
        }
    },
    atlas = 'Consumables',
    discovered = false,
    set = 'traits',
    pos = { x = 2, y = 0 },
    use = function(self, card, area, copier)
        local CArd = G.hand.highlighted[2]
        CArd:flip()
        if CArd.ability.perma_x_chips == 0 then
            CArd.ability.perma_x_chips = 1
        else
            CArd.ability.perma_x_chips = CArd.ability.perma_x_chips + 2
        end
        CArd.ability.perma_mult = CArd.ability.perma_mult + 20
        CArd:flip()
        G.hand:remove_from_highlighted(CArd, true)
        G.FUNCS.discard_cards_from_highlighted(nil, true)

        local end_round_ref = end_round
        function end_round()
            local ret = end_round_ref()
            if CArd.ability.perma_x_chips == 1 then
                CArd.ability.perma_x_chips = 0
            else
                CArd.ability.perma_x_chips = CArd.ability.perma_x_chips - 2
            end
            CArd.ability.perma_mult = CArd.ability.perma_mult - 20
            return ret
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= 3 and
            #G.hand.highlighted <= 3
    end
}

SMODS.Consumable {
    key = 'incandescent',
    loc_txt = {
        name = "Incandescent",
        text = {
            "Grant up to two selected cards a stack of Scorch",
            "(If the selected cards aren't scorched, scorch them)"
        }
    },
    atlas = 'Consumables',
    discovered = false,
    set = 'traits',
    pos = { x = 3, y = 1 },
    use = function(self, card, area, copier)
        for i, selectedCard in ipairs(G.hand.highlighted) do
            selectedCard:flip()
            if not SMODS.has_enhancement(selectedCard, "m_fm_scorch") then
                selectedCard:set_ability(G.P_CENTERS.m_fm_scorch)
            end
            selectedCard.ability.extra.stacks = selectedCard.ability.extra.stacks + 1
            selectedCard:flip()
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= 1 and
            #G.hand.highlighted <= 2
    end
}

SMODS.Sticker {
    key = "boxmarked",
    loc_txt = {
        name = "Marked",
        text = {
            "Every hand this card isn't played,",
            "this card gains {C:red}+10{} Mult"
        }
    },
    default_compat = true,
    sets = {
        traits = false
    },
    atlas = "Stickers",
    discovered = false,
    pos = {x = 3, y = 0},
    calculate = function(self, card, context)
        
        if card.area == G.hand and context.after then
            card.ability.perma_mult = (card.ability.perma_mult or 0) + 10
            return {
                message = "Focused!",
                colour = G.C.MULT
            }
        end

        if context.main_scoring and card.area == G.play then
            card:flip()
            SMODS.Stickers.fm_boxmarked:apply(card, false)
            card.ability.perma_mult = 0
            card:flip()
            return {
                message = "Focus Lost!",
                colour = G.C.MULT
            }
        end
        if context.end_of_round then
            card:flip()
            SMODS.Stickers.fm_boxmarked:apply(card, false)
            card.ability.perma_mult = 0
            card:flip()
            return {
                message = "Focus Lost!",
                colour = G.C.MULT
            }
        end
    end
}

SMODS.Consumable {
    key = 'box_breathing',
    loc_txt = {
        name = "Box Breathing",
        text = {
            "Select up to three cards to be permanently marked", 
            "These cards will grant {C:red}+20{} Mult when scored ",
            "after not playing them for one hand"
        }
    },
    discovered = false,
    atlas = 'Consumables',
    set = 'traits',
    pos = { x = 5, y = 0 },
    use = function(self, card, area, copier)
        for i = 1, #G.hand.highlighted do
            G.hand.highlighted[i]:flip()
            SMODS.Stickers.fm_boxmarked:apply(G.hand.highlighted[i], true)
            G.hand.highlighted[i]:flip()
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted >= 1 and #G.hand.highlighted <= 3
    end
}