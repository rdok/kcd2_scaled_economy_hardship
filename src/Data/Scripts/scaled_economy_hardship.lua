System.LogAlways("$5[ScaledEconomyHardship] ### INITIALIZED ###")
ScaledEconomyHardship = {}

ScaledEconomyHardship.perks = {
    tough_economy_1 = {id = "a1b2c3d4-e5f6-7890-abcd-ef1234567890", level = 7},
    tough_economy_2 = {id = "b2c3d4e5-f678-9012-bcde-f23456789012", level = 10},
    tough_economy_3 = {id = "c3d4e5f6-7890-1234-cdef-345678901234", level = 15},
    tough_economy_4 = {id = "d4e5f678-9012-3456-def0-456789012345", level = 20},
    tough_economy_5 = {id = "h3d6e9f2-8c1b-4a5d-9e7f-0b2a4c5d3816", level = 25},
    tough_economy_6 = {id = "j7f0c4b9-5e2d-4d1a-8b3e-6a9f2c0d5718", level = 30}
}

ScaledEconomyHardship.check_interval = 5000
ScaledEconomyHardship.timer_id = nil

function ScaledEconomyHardship:init()
    System.LogAlways("$5[ScaledEconomyHardship] Started init")
    ScaledEconomyHardship.timer_id = Script.SetTimer(ScaledEconomyHardship.check_interval, ScaledEconomyHardship.swap_perks)
    System.LogAlways("$5[ScaledEconomyHardship] Timer set with interval " .. ScaledEconomyHardship.check_interval)
end

function ScaledEconomyHardship:clear_active_perks()
    System.LogAlways("$5[ScaledEconomyHardship] Clearing active perks")
    for perk_key, perk_data in pairs(ScaledEconomyHardship.perks) do
        if player.soul:HasPerk(perk_data.id) then
            System.LogAlways("$5[ScaledEconomyHardship] Removing perk " .. perk_key .. " with id " .. perk_data.id)
            player.soul:RemovePerk(perk_data.id)
        end
    end
    System.LogAlways("$5[ScaledEconomyHardship] Finished clearing active perks")
end

function ScaledEconomyHardship:swap_perks()
    System.LogAlways("$5[ScaledEconomyHardship] Checking perks for swap")
    local player_level = player.soul:GetDerivedStat("lvl")
    System.LogAlways("$5[ScaledEconomyHardship] Player level is " .. player_level)
    for perk_key, perk_data in pairs(ScaledEconomyHardship.perks) do
        if player_level >= perk_data.level and not player.soul:HasPerk(perk_data.id) then
            System.LogAlways("$5[ScaledEconomyHardship] Swapping to " .. perk_key .. " at level " .. perk_data.level)
            ScaledEconomyHardship:clear_active_perks()
            player.soul:AddPerk(perk_data.id)
            System.LogAlways("$5[ScaledEconomyHardship] Applied perk " .. perk_key .. " with id " .. perk_data.id)
        end
    end
    ScaledEconomyHardship.timer_id = Script.SetTimer(ScaledEconomyHardship.check_interval, ScaledEconomyHardship.swap_perks)
    System.LogAlways("$5[ScaledEconomyHardship] Next check scheduled")
end

ScaledEconomyHardship:init()

return ScaledEconomyHardship