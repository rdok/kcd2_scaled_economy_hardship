local log = _G.ScaledEconomyHardship.Log

log:info("### INITIALIZED PerkManager ###")

local PerkManager = {
    check_interval = 5000,
    timer_id = nil,
    applied_perk_id = nil
}

PerkManager.perks = {
    { name = "dawn_of_want", max_level = 5, id = "c0c0db5e-e001-405f-bbb5-01488eae60b2" },
    { name = "shadow_of_scarcity", max_level = 10, id = "b2c3d4e5-f678-9012-bcde-f23456789012" },
    { name = "blight_of_trade", max_level = 15, id = "34894718-7947-4ce6-9692-439f8ed923bc" },
    { name = "reign_of_ruin", max_level = 20, id = "f3459ca0-ff2d-4c76-838f-95210773fc1f" },
    { name = "fall_of_plenty", max_level = 25, id = "f2aa55d8-58b6-4f0f-a7b7-2e81a1e029ff" },
    { name = "echoes_of_desolation", max_level = 99, id = "9e907773-734e-42f6-806f-ccddfb247ed3" },
}

function PerkManager:init()
    log:info("Started init")

    for _, perk in pairs(self.perks) do
        log:info("Removing perk with id " .. perk.id)
        _G.player.soul:RemovePerk(perk.id)
    end

    self:clear_active_perk()
    self:update_perk()

    self.timer_id = Script.SetTimer(self.check_interval, function()
        self:update_perk()
    end)
    log:info("Timer set with interval " .. self.check_interval)
end

function PerkManager:clear_active_perk()
    if self.applied_perk_id then
        log:info("Removing current perk with id " .. self.applied_perk_id)
        _G.player.soul:RemovePerk(self.applied_perk_id)
        self.applied_perk_id = nil
        log:info("Cleared currently active perk")
    else
        log:info("No active perk to clear")
    end
end

function PerkManager:update_perk()
    log:info("Checking perks for update")
    local main_level = _G.player.soul:GetDerivedStat("lvl")
    log:info("Player level is " .. main_level)

    local new_perk = nil

    for _, perk in pairs(self.perks) do
        if main_level <= perk.max_level and (not new_perk or perk.max_level > new_perk.max_level) then
            new_perk = perk
            break
        end
    end

    log:info("New perk to apply: ", new_perk)

    local active_perk_is_stale = self.applied_perk_id ~= new_perk.id
    log:info("active_perk_is_stale", active_perk_is_stale)

    --local activePerkIsStale = player.soul:HasPerk(new_perk.perk_id, false);
    if new_perk and active_perk_is_stale then
        log:info("Updating to " .. new_perk.name .. " at level " .. new_perk.max_level)
        self:clear_active_perk()
        _G.player.soul:AddPerk(new_perk.id)
        self.applied_perk_id = new_perk.id
        log:info("Applied perk " .. new_perk.name .. " with id " .. new_perk.id)
    end

    self.timer_id = Script.SetTimer(self.check_interval, function()
        self:update_perk()
    end)
    log:info("Next check scheduled")
end

_G.ScaledEconomyHardship.PerkManager = _G.ScaledEconomyHardship.PerkManager
        or PerkManager

return PerkManager