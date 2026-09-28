-- ============================================================================
-- SohdRunner - Third-Person 3D Camera System (camera.lua)
-- Developer: Ahmed
-- ============================================================================

local Camera = {}

Camera.DIST_BEHIND = 5.6
Camera.BASE_HEIGHT = 3.35
Camera.LOOK_AHEAD_Z = 9.5
Camera.LOOK_BASE_Y = 1.25
Camera.FOV = 56.0

function Camera.create()
    return {
        eye_x = 0.0,
        eye_y = Camera.BASE_HEIGHT,
        eye_z = -Camera.DIST_BEHIND,
        look_x = 0.0,
        look_y = Camera.LOOK_BASE_Y,
        look_z = Camera.LOOK_AHEAD_Z,
        fov = Camera.FOV,
        shake_timer = 0.0,
        shake_intensity = 0.0
    }
end

function Camera.reset(cam, player_x, player_y, player_z)
    cam.eye_x = (player_x or 0.0) * 0.62
    cam.eye_y = Camera.BASE_HEIGHT + (player_y or 0.0) * 0.25
    cam.eye_z = (player_z or 0.0) - Camera.DIST_BEHIND
    cam.look_x = (player_x or 0.0) * 0.45
    cam.look_y = Camera.LOOK_BASE_Y + (player_y or 0.0) * 0.18
    cam.look_z = (player_z or 0.0) + Camera.LOOK_AHEAD_Z
    cam.shake_timer = 0.0
    cam.shake_intensity = 0.0
end

function Camera.trigger_impact_shake(cam)
    cam.shake_timer = 0.32
    cam.shake_intensity = 0.22
end

function Camera.update(cam, player, dt)
    local safe_dt = math.min(math.max(dt or 0.016, 0.001), 0.05)
    local target_eye_x = player.body.x * 0.65
    local target_eye_y = Camera.BASE_HEIGHT + (player.body.y * 0.28)
    local target_eye_z = player.body.z - Camera.DIST_BEHIND
    local target_look_x = player.body.x * 0.45
    local target_look_y = Camera.LOOK_BASE_Y + (player.body.y * 0.18)
    local target_look_z = player.body.z + Camera.LOOK_AHEAD_Z
    local smooth_xy = 1.0 - math.exp(-14.0 * safe_dt)
    cam.eye_x = cam.eye_x + (target_eye_x - cam.eye_x) * smooth_xy
    cam.eye_y = cam.eye_y + (target_eye_y - cam.eye_y) * smooth_xy
    cam.eye_z = target_eye_z
    cam.look_x = cam.look_x + (target_look_x - cam.look_x) * smooth_xy
    cam.look_y = cam.look_y + (target_look_y - cam.look_y) * smooth_xy
    cam.look_z = target_look_z
    if cam.shake_timer > 0.0 then
        cam.shake_timer = math.max(0.0, cam.shake_timer - safe_dt)
        local wave = math.sin(cam.shake_timer * 65.0) * cam.shake_intensity * (cam.shake_timer / 0.32)
        cam.eye_x = cam.eye_x + wave
        cam.eye_y = cam.eye_y + math.abs(wave) * 0.5
    end
end

return Camera
