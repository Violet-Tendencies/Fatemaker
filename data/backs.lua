SMODS.Back {
    key = "deck_solar",
    loc_txt = {
        name = "{C:attention}Solar{} Deck",
        text = {
            "To {C:attention}scorch{} and to heal,",
            "to {C:attention}burn{} and to cauterize."
        }
    },
    pos = { x = 1, y = 3 },
    unlocked = true,
    apply = function(self, back)
        local tf = {
            true,
            true,
            false,
            false
        }
        local enhancements = {
            G.P_CENTERS.m_fm_radiant,-- Solar
            G.P_CENTERS.m_fm_scorch,
            G.P_CENTERS.m_fm_restoration,
            G.P_CENTERS.m_fm_cure
        }
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if pseudorandom_element(tf, pseudoseed('Idk')) then
                        v:set_ability(pseudorandom_element(enhancements, pseudoseed('Break Through')))
                    end
                end
                return true
            end
        }))
    end
}
SMODS.Back {
    key = "deck_void",
    loc_txt = {
        name = "{C:purple}Void{} Deck",
        text = {
            "The {C:purple}darkest{} reaches,",
            "the {C:purple}deepest{} depths;",
            "Knowledge as boundless as power.",
        }
    },
    pos = { x = 1, y = 3 },
    unlocked = true,
    apply = function(self, back)
        local tf = {
            true,
            true,
            false,
            false
        }
        local enhancements = {
            G.P_CENTERS.m_fm_overshield, -- Void
            G.P_CENTERS.m_fm_volatile,
            G.P_CENTERS.m_fm_devour,
            G.P_CENTERS.m_fm_suppress
        }
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if pseudorandom_element(tf, pseudoseed('Idk')) then
                        v:set_ability(pseudorandom_element(enhancements, pseudoseed('Break Through')))
                    end
                end
                return true
            end
        }))
    end
}
SMODS.Back {
    key = "deck_arc",
    loc_txt = {
        name = "{C:blue}Arc{} Deck",
        text = {
            'A {C:blue}spark{} of {C:blue}chaos{}, shining;',
            'Open your mind and hear it sing.'
        }
    },
    pos = { x = 1, y = 3 },
    unlocked = true,
    apply = function(self, back)
        local tf = {
            true,
            true,
            false,
            false
        }
        local enhancements = {
            G.P_CENTERS.m_fm_amplified, -- Arc
            G.P_CENTERS.m_fm_jolt,
            G.P_CENTERS.m_fm_blinded,
            G.P_CENTERS.m_fm_bolt_charge
        }
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if pseudorandom_element(tf, pseudoseed('Idk')) then
                        v:set_ability(pseudorandom_element(enhancements, pseudoseed('Break Through')))
                    end
                end
                return true
            end
        }))
    end
}
SMODS.Back {
    key = "deck_stasis",
    loc_txt = {
        name = "{C:spades}Stasis{} Deck",
        text = {
            'The {C:spades}coldest{} reaches of your mind;',
            "The {C:spades}tundra{} that will {C:spades}freeze{} all."
        }
    },
    pos = { x = 1, y = 3 },
    unlocked = true,
    apply = function(self, back)
        local tf = {
            true,
            true,
            false,
            false
        }
        local enhancements = {
            G.P_CENTERS.m_fm_shatter, -- Stasis
            G.P_CENTERS.m_fm_freeze,
            G.P_CENTERS.m_fm_slow,
            G.P_CENTERS.m_fm_stasis_crystal
        }
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if pseudorandom_element(tf, pseudoseed('Idk')) then
                        v:set_ability(pseudorandom_element(enhancements, pseudoseed('Break Through')))
                    end
                end
                return true
            end
        }))
    end
}
SMODS.Back {
    key = "deck_strand",
    loc_txt = {
        name = "Strand Deck",
        text = {
            "The {C:green}web{} is made, the {C:green}bait{} is laid.",
            "Catch all within, make yourself known."
        }
    },
    pos = { x = 1, y = 3 },
    unlocked = true,
    apply = function(self, back)
        local tf = {
            true,
            true,
            true,
            false
        }
        local enhancements = {
            G.P_CENTERS.m_fm_wovenmail, -- Strand
            G.P_CENTERS.m_fm_tangle,
            G.P_CENTERS.m_fm_unravel,
            G.P_CENTERS.m_fm_suspend
        }
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if pseudorandom_element(tf, pseudoseed('Idk')) then
                        v:set_ability(pseudorandom_element(enhancements, pseudoseed('Break Through')))
                    end
                end
                return true
            end
        }))
    end
}
SMODS.Back {
    key = "deck_resonant",
    loc_txt = {
        name = "{C:fm_resonance_hue}Resonance{} Deck",
        text = {
            "\"{C:fm_resonance_hue}Subjugation{} or {C:fm_reverse_resonance_hue}Liberation{}?\"",
            "You have chosen both."
        }
    },
    pos = { x = 1, y = 3 },
    unlocked = true,
    apply = function(self, back)
        local tf = {
            true,
            true,
            false,
            false
        }
        local enhancements = {
            G.P_CENTERS.m_fm_resonant, -- Resonant
            G.P_CENTERS.m_fm_finalized,
            G.P_CENTERS.m_fm_dissected,
            G.P_CENTERS.m_fm_rooted
        }
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if pseudorandom_element(tf, pseudoseed('Idk')) then
                        v:set_ability(pseudorandom_element(enhancements, pseudoseed('Resonant')))
                    end
                end
                return true
            end
        }))
    end
}
SMODS.Back {
    key = "deck_prismatic",
    loc_txt = {
        name = "Prismatic Deck",
        text = {
            "Having braved the temptations of the",
            "{C:dark_edition}Dark{} and the chaos of the {C:edition}Light{};",
            "your greatness is now known by gods",
            "of the Sky and the Deep."
        }
    },
    pos = { x = 1, y = 3 },
    unlocked = true,
    apply = function(self, back)
        local tf = {
            true,
            true,
            false
        }
        local enhancements = {
            G.P_CENTERS.m_fm_radiant,-- Solar
            G.P_CENTERS.m_fm_scorch,
            G.P_CENTERS.m_fm_restoration,
            G.P_CENTERS.m_fm_cure,
            G.P_CENTERS.m_fm_overshield, -- Void
            G.P_CENTERS.m_fm_volatile,
            G.P_CENTERS.m_fm_devour,
            G.P_CENTERS.m_fm_suppress,
            G.P_CENTERS.m_fm_amplified, -- Arc
            G.P_CENTERS.m_fm_jolt,
            G.P_CENTERS.m_fm_blinded,
            G.P_CENTERS.m_fm_bolt_charge,
            G.P_CENTERS.m_fm_shatter, -- Stasis
            G.P_CENTERS.m_fm_freeze,
            G.P_CENTERS.m_fm_slow,
            G.P_CENTERS.m_fm_stasis_crystal,
            G.P_CENTERS.m_fm_wovenmail, -- Strand
            G.P_CENTERS.m_fm_tangle,
            G.P_CENTERS.m_fm_unravel,
            G.P_CENTERS.m_fm_suspend,
            G.P_CENTERS.m_fm_resonant, -- Resonant
            G.P_CENTERS.m_fm_finalized,
            G.P_CENTERS.m_fm_dissected,
            G.P_CENTERS.m_fm_rooted
        }
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.value == 'Ace' then
                        v:set_ability(G.P_CENTERS.m_fm_transcendent)
                    else
                        if pseudorandom_element(tf, pseudoseed('Idk')) then
                            v:set_ability(pseudorandom_element(enhancements, pseudoseed('Break Through')))
                        end
                    end
                end
                return true
            end
        }))
    end
}