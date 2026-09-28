-- ============================================================================
-- SohdRunner - Collectible Coins & Particle Burst System (coins.lua)
-- Developer: Ahmed
-- ============================================================================

local Collision = require("collision")
local Renderer = require("renderer")
local Particles = require("particles")

local Coins = {}

Coins.COIN_RADIUS = 0.40
Coins.PICKUP_SPHERE_RADIUS = 0.72
Coins.SPIN_SPEED = 3.8

function Coins.create_manager()
    return {
        active = {},
        pool = {},
        particle_system = Particles.create_system(),
        spin_angle = 0.0
    }
end

function Coins.reset(mgr)
    for i = #mgr.active, 1, -1 do
        local c = mgr.active[i]
        c.active = false
        mgr.pool[#mgr.pool + 1] = c
        mgr.active[i] = nil
    end
    Particles.reset(mgr.particle_system)
    mgr.spin_angle = 0.0
end

function Coins.spawn(mgr, lane, y_pos, z_pos)
    local c = nil
    if #mgr.pool > 0 then
        c = mgr.pool[#mgr.pool]
        mgr.pool[#mgr.pool] = nil
    else
        c = {}
    end

    c.lane = lane
    c.x = lane * 2.2
    c.base_y = y_pos or 0.85
    c.y = c.base_y
    c.z = z_pos
    c.phase = (z_pos * 0.25) % 6.28
    c.active = true

    mgr.active[#mgr.active + 1] = c
    return c
end

function Coins.update_and_collect(mgr, player, dt, recycle_behind_z, audio)
    mgr.spin_angle = (mgr.spin_angle + Coins.SPIN_SPEED * dt) % 6.283185

    local collected_count = 0
    local i = 1
    while i <= #mgr.active do
        local c = mgr.active[i]
        if c.z < recycle_behind_z then
            c.active = false
            mgr.pool[#mgr.pool + 1] = c
            mgr.active[i] = mgr.active[#mgr.active]
            mgr.active[#mgr.active] = nil
        else
            c.y = c.base_y + math.sin(mgr.spin_angle + c.phase) * 0.10
            if math.abs(c.z - player.body.z) < 1.8 then
                if Collision.aabb_vs_sphere(player.aabb, c.x, c.y, c.z, Coins.PICKUP_SPHERE_RADIUS) then
                    collected_count = collected_count + 1
                    Particles.spawn_coin_burst(mgr.particle_system, c.x, c.y, c.z, player.body.vz)
                    if audio then
                        audio.play_coin()
                    end
                    c.active = false
                    mgr.pool[#mgr.pool + 1] = c
                    mgr.active[i] = mgr.active[#mgr.active]
                    mgr.active[#mgr.active] = nil
                else
                    i = i + 1
                end
            else
                i = i + 1
            end
        end
    end

    Particles.update(mgr.particle_system, dt)
    return collected_count
end

function Coins.render(mgr, min_z, max_z)
    for i = 1, #mgr.active do
        local c = mgr.active[i]
        if c.z >= min_z and c.z <= max_z then
            Renderer.add_shadow(c.x, c.z, 0.34, 0.26, 0.25)
            Renderer.add_coin(c.x, c.y, c.z, Coins.COIN_RADIUS, mgr.spin_angle + c.phase)
        end
    end
    Particles.render(mgr.particle_system, min_z, max_z)
end

return Coins
