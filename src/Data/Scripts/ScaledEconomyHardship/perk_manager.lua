local log = _G.ScaledEconomyHardship.Log

log:info("### INITIALIZED PerkManager ###")

local PerkManager = {
    check_interval = 5000,
    timer_id = nil,
    applied_perk_id = nil
}

PerkManager.perks = {
    { name = "tougher_economy_dawn_of_want", level = 5, id = "c0c0db5e-e001-405f-bbb5-01488eae60b2" },
    { name = "tougher_economy_shadow_of_scarcity", level = 10, id = "b2c3d4e5-f678-9012-bcde-f23456789012" },
    { name = "tougher_economy_blight_of_trade", level = 15, id = "34894718-7947-4ce6-9692-439f8ed923bc" },
    { name = "tougher_economy_reign_of_ruin", level = 20, id = "f3459ca0-ff2d-4c76-838f-95210773fc1f" },
    { name = "tougher_economy_fall_of_plenty", level = 25, id = "f2aa55d8-58b6-4f0f-a7b7-2e81a1e029ff" },
}

function PerkManager:init()
    log:info("Started init")

    for _, perk in pairs(self.perks) do
        log:info("Removing perk with id " .. perk.id)
        _G.player.soul:RemovePerk(perk.id)
    end

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
    local max_perk_level = _G.player.soul:GetDerivedStat("lvl")
    log:info("Player level is " .. max_perk_level)

    local new_perk = nil

    for _, perk in pairs(self.perks) do
        if max_perk_level >= perk.level and (not new_perk or perk.level > new_perk.level) then
            new_perk = perk
        end
    end

    local activePerkIsStale = self.applied_perk_id ~= new_perk.id
    --local activePerkIsStale = player.soul:HasPerk(new_perk.perk_id, false);
    if new_perk and activePerkIsStale then
        log:info("Updating to " .. new_perk.name .. " at level " .. new_perk.level)
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