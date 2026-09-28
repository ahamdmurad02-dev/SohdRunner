-- ============================================================================
-- SohdRunner - Game State & UI Sync System (ui_state.lua)
-- Developer: Ahmed
-- Manages game states: MENU, PLAYING, PAUSED, GAME_OVER
-- ============================================================================

local UIState = {}

UIState.STATE_MENU = "MENU"
UIState.STATE_PLAYING = "PLAYING"
UIState.STATE_PAUSED = "PAUSED"
UIState.STATE_GAME_OVER = "GAME_OVER"

function UIState.create()
    return {
        state = UIState.STATE_MENU,
        score = 0,
        coins = 0,
        high_score = 0,
        total_coins = 0,
        total_runs = 0,
        speed = 14.5,
        is_new_record = false
    }
end

function UIState.sync_to_bridge(ui)
    if __bridge_set_ui_state then
        __bridge_set_ui_state(
            ui.state,
            math.floor(ui.score),
            math.floor(ui.coins),
            math.floor(ui.high_score),
            math.floor(ui.total_coins),
            math.floor(ui.total_runs),
            ui.speed,
            ui.is_new_record and 1 or 0
        )
    end
end

return UIState
