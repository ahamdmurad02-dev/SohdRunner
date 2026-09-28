-- ============================================================================
-- SohdRunner - Audio Event System (audio.lua)
-- Developer: Ahmed
-- ============================================================================

local Audio = {}

Audio.sound_enabled = true
Audio.music_enabled = true

local function emit_sfx(name)
    if Audio.sound_enabled and __bridge_play_sound then
        __bridge_play_sound(name)
    end
end

function Audio.play_jump()
    emit_sfx("jump")
end

function Audio.play_coin()
    emit_sfx("coin")
end

function Audio.play_crash()
    emit_sfx("crash")
end

function Audio.play_lane_switch()
    emit_sfx("swipe")
end

function Audio.play_fast_fall()
    emit_sfx("fast_fall")
end

function Audio.play_land()
    emit_sfx("land")
end

function Audio.play_step()
    emit_sfx("step")
end

function Audio.play_button()
    emit_sfx("button")
end

function Audio.play_start()
    emit_sfx("start")
end

function Audio.play_highscore()
    emit_sfx("highscore")
end

function Audio.play_gameover()
    emit_sfx("gameover")
end

function Audio.set_music_playing(is_playing)
    if __bridge_set_music then
        __bridge_set_music(Audio.music_enabled and is_playing)
    end
end

return Audio
