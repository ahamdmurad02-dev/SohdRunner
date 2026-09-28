-- ============================================================================
-- SohdRunner - Touch & Gesture Input System (input.lua)
-- Developer: Ahmed
-- ============================================================================

local Input = {}

Input.ACTION_LEFT = "LEFT"
Input.ACTION_RIGHT = "RIGHT"
Input.ACTION_JUMP = "JUMP"
Input.ACTION_FAST_FALL = "FAST_FALL"

function Input.create()
    return {
        buffered_jump_timer = 0.0,
        last_action = "NONE"
    }
end

function Input.reset(state)
    state.buffered_jump_timer = 0.0
    state.last_action = "NONE"
end

function Input.handle_action(state, player, audio, action)
    state.last_action = action or "NONE"
    if action == Input.ACTION_LEFT then
        if player:move_left() then
            audio.play_lane_switch()
        end
    elseif action == Input.ACTION_RIGHT then
        if player:move_right() then
            audio.play_lane_switch()
        end
    elseif action == Input.ACTION_JUMP then
        if player:jump() then
            state.buffered_jump_timer = 0.0
            audio.play_jump()
        else
            state.buffered_jump_timer = 0.16
        end
    elseif action == Input.ACTION_FAST_FALL then
        if player:fast_fall() then
            state.buffered_jump_timer = 0.0
            audio.play_fast_fall()
        end
    end
end

function Input.update(state, player, audio, dt)
    if state.buffered_jump_timer > 0.0 then
        state.buffered_jump_timer = math.max(0.0, state.buffered_jump_timer - dt)
        if player.body.is_grounded then
            if player:jump() then
                state.buffered_jump_timer = 0.0
                audio.play_jump()
            end
        end
    end
end

return Input
