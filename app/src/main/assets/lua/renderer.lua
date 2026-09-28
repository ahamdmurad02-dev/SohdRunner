-- ============================================================================
-- SohdRunner - 3D Scene Renderer Bridge (renderer.lua)
-- Developer: Ahmed
-- ============================================================================

local Renderer = {}

Renderer.box_count = 0
Renderer.coin_count = 0
Renderer.shadow_count = 0
Renderer.particle_count = 0

Renderer.camera_state = {
    eye_x = 0.0, eye_y = 3.35, eye_z = -5.6,
    look_x = 0.0, look_y = 1.25, look_z = 9.5,
    fov = 56.0
}

function Renderer.begin_frame()
    Renderer.box_count = 0
    Renderer.coin_count = 0
    Renderer.shadow_count = 0
    Renderer.particle_count = 0
    if __bridge_clear_scene then
        __bridge_clear_scene()
    end
end

function Renderer.set_camera(eye_x, eye_y, eye_z, look_x, look_y, look_z, fov)
    Renderer.camera_state.eye_x = eye_x
    Renderer.camera_state.eye_y = eye_y
    Renderer.camera_state.eye_z = eye_z
    Renderer.camera_state.look_x = look_x
    Renderer.camera_state.look_y = look_y
    Renderer.camera_state.look_z = look_z
    Renderer.camera_state.fov = fov or 56.0
    if __bridge_set_camera then
        __bridge_set_camera(eye_x, eye_y, eye_z, look_x, look_y, look_z, fov or 56.0)
    end
end

function Renderer.add_box(cx, cy, cz, sx, sy, sz, color_rgb, pitch_rad, yaw_rad)
    Renderer.box_count = Renderer.box_count + 1
    if __bridge_add_box then
        __bridge_add_box(cx, cy, cz, sx, sy, sz, color_rgb, pitch_rad or 0.0, yaw_rad or 0.0)
    end
end

function Renderer.add_shadow(cx, cz, rx, rz, alpha)
    Renderer.shadow_count = Renderer.shadow_count + 1
    if __bridge_add_shadow then
        __bridge_add_shadow(cx, cz, rx, rz, alpha or 0.35)
    end
end

function Renderer.add_coin(cx, cy, cz, radius, spin_angle)
    Renderer.coin_count = Renderer.coin_count + 1
    if __bridge_add_coin then
        __bridge_add_coin(cx, cy, cz, radius, spin_angle)
    end
end

function Renderer.add_particle(cx, cy, cz, size, color_rgb, alpha, spin_angle)
    Renderer.particle_count = Renderer.particle_count + 1
    if __bridge_add_particle then
        __bridge_add_particle(cx, cy, cz, size, color_rgb, alpha or 1.0, spin_angle or 0.785)
    end
end

return Renderer
