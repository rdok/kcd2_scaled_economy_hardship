local log = _G.ScaledEconomyHardship.Log

log:info("### INITIALIZED PerkManager ###")

local PerkManager = {
    check_interval = 5000,
    timer_id = nil,
    applied_perk_id = nil
}

PerkManager.perks = {
    { name = "tougher_economy_50_percent", level = 5, id = "a1b2c3d4-e5f6-7890-abcd-ef1234567890" },
    { name = "tougher_economy_75_percent", level = 10, id = "b2c3d4e5-f678-9012-bcde-f23456789012" },
    { name = "tougher_economy_80_percent", level = 15, id = "c3d4e5f6-7890-1234-cdef-345678901234" },
    { name = "tougher_economy_85_percent", level = 20, id = "d4e5f678-9012-3456-def0-456789012345" },
    { name = "tougher_economy_90_percent", level = 25, id = "h3d6e9f2-8c1b-4d1a-9e7f-0b2a4c5d3816" },
    { name = "tougher_economy_95_percent", level = 30, id = "j7f0c4b9-5e2d-4d1a-8b3e-6a9f2c0d5718" }
}

function PerkManager:init()
    log:info("Started init")
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

    -- Find the best perk the player qualifies for (highest level ≤ player's level)
    for _, perk in pairs(self.perks) do
        if max_perk_level >= perk.level and (not new_perk or perk.level > new_perk.level) then
            new_perk = perk
        end
    end

    local activePerkIsStale =  self.applied_perk_id ~= new_perk.id
    --local hasPerk = player.soul:HasPerk(best_perk.perk_id, false);
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

_G.ScaledEconomyHardship.PerkManager = PerkManager

return PerkManager