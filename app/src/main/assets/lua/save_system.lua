-- ============================================================================
-- SohdRunner - Offline Local Save System (save_system.lua)
-- Developer: Ahmed
-- Persists high score, total collected coins, and run count completely offline.
-- ============================================================================

local SaveSystem = {}

SaveSystem.high_score = 0
SaveSystem.total_coins = 0
SaveSystem.total_runs = 0

function SaveSystem.load()
    if __bridge_load_save then
        local hs, tc, tr = __bridge_load_save()
        SaveSystem.high_score = tonumber(hs) or 0
        SaveSystem.total_coins = tonumber(tc) or 0
        SaveSystem.total_runs = tonumber(tr) or 0
    end
end

function SaveSystem.record_run(final_score, run_coins)
    local is_new_record = false
    local int_score = math.floor(final_score or 0)
    local int_coins = math.floor(run_coins or 0)

    if int_score > SaveSystem.high_score then
        SaveSystem.high_score = int_score
        is_new_record = true
    end

    SaveSystem.total_coins = SaveSystem.total_coins + int_coins
    SaveSystem.total_runs = SaveSystem.total_runs + 1

    if __bridge_save_progress then
        __bridge_save_progress(
            SaveSystem.high_score,
            SaveSystem.total_coins,
            SaveSystem.total_runs,
            int_score,
            int_coins
        )
    end

    return is_new_record
end

return SaveSystem
