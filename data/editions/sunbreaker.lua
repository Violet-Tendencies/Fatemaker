SMODS.Shader({ key = 'sunbreaker', path = 'sunbreaker.fs' })

SMODS.Edition({
    key = "sunbreaker",
    shader = "sunbreaker",
    loc_txt = {
        name = "Sunbreaker",
        label = "Sunbreaker",
        text = {
            "Fan the Flames of oblivion.",
            "{C:inactive}(#1#/3){}"
        }
    },
    sound = { sound = "fm_sunbreaker" },
    disable_shadow = false,
    disable_base_shader = false,
    discovered = false,
    unlocked = true,
    config = {
        extra = {
            absorbed = 0,
            loop = 0
        }
    },
    in_shop = false,
    apply_to_float = true,
    loc_vars = function(self)
        return { vars = {self.config.extra.loop} }
    end,
    calculate = function(self, card, context)
        if self.config.extra.loop >= 3 and context.cardarea == G.hand then
            juice_card(card)
        end
        if context.main_scoring then
            if self.config.extra.loop < 3 then
                for k, v in ipairs(G.play.cards) do
                    if v.config.center == G.P_CENTERS.m_fm_radiant or
                    v.config.center == G.P_CENTERS.m_fm_restoration or
                    v.config.center == G.P_CENTERS.m_fm_scorch or
                    v.config.center == G.P_CENTERS.m_fm_cure then
                        juice_card(v)
                        v:set_ability(G.P_CENTERS.c_base)
                        self.config.extra.absorbed = self.config.extra.absorbed + 1
                    end
                end
                self.config.extra.loop = self.config.extra.loop + 1
            else
                juice_card(card)
                self.config.extra.loop = 0
                local a = self.config.extra.absorbed
                self.config.extra.absorbed = 0
                return {
                    xmult = 2 * a
                }
            end
        end
    end
})