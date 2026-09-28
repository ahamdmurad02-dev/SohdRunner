-- ============================================================================
-- SohdRunner - Lightweight 3D Particle Effect System (particles.lua)
-- Developer: Ahmed
-- ============================================================================

local Renderer = require("renderer")

local Particles = {}

Particles.KIND_SPARK = 1
Particles.KIND_DUST  = 2

local SPARK_DIRECTIONS = {
    { dx = -2.8, dy = 4.6, dz =  1.4, color = 0xFFF9DB, size = 0.24 },
    { dx =  2.8, dy = 4.6, dz =  1.4, color = 0xF6C90E, size = 0.24 },
    { dx = -3.4, dy = 2.8, dz =  0.4, color = 0xECC94B, size = 0.21 },
    { dx =  3.4, dy = 2.8, dz =  0.4, color = 0xF6AD55, size = 0.21 },
    { dx = -1.6, dy = 5.6, dz = -0.8, color = 0xFFF3BF, size = 0.25 },
    { dx =  1.6, dy = 5.6, dz = -0.8, color = 0xF6C90E, size = 0.25 },
    { dx =  0.0, dy = 6.2, dz =  1.8, color = 0xFFFFFF, size = 0.26 },
    { dx =  0.0, dy = 3.5, dz = -1.6, color = 0xF6E05E, size = 0.22 }
}

local DUST_DIRECTIONS = {
    { dx = -1.9, dy = 1.8, dz =  0.9, color = 0xFEFCBF, size = 0.30 },
    { dx =  1.9, dy = 1.8, dz =  0.9, color = 0xFAF089, size = 0.30 },
    { dx = -2.3, dy = 1.1, dz = -0.6, color = 0xEDF2F7, size = 0.28 },
    { dx =  2.3, dy = 1.1, dz = -0.6, color = 0xEDF2F7, size = 0.28 },
    { dx = -0.9, dy = 2.6, dz =  1.5, color = 0xFBD38D, size = 0.32 },
    { dx =  0.9, dy = 2.6, dz = -1.1, color = 0xFEFCBF, size = 0.32 }
}

function Particles.create_system()
    return { active = {}, pool = {} }
end

function Particles.reset(sys)
    for i = #sys.active, 1, -1 do
        local p = sys.active[i]
        p.active = false
        sys.pool[#sys.pool + 1] = p
        sys.active[i] = nil
    end
end

local function acquire_particle(sys)
    if #sys.pool > 0 then
        local p = sys.pool[#sys.pool]
        sys.pool[#sys.pool] = nil
        return p
    end
    return {}
end

function Particles.spawn_coin_burst(sys, x, y, z, forward_speed)
    local carry_vz = (forward_speed or 14.5) * 0.42
    for i = 1, #SPARK_DIRECTIONS do
        local spec = SPARK_DIRECTIONS[i]
        local p = acquire_particle(sys)
        p.kind = Particles.KIND_SPARK
        p.x = x + (spec.dx * 0.06)
        p.y = y + 0.05
        p.z = z + (spec.dz * 0.06)
        p.vx = spec.dx
        p.vy = spec.dy
        p.vz = carry_vz + spec.dz
        p.gravity = -15.0
        p.drag = 1.2
        p.base_size = spec.size
        p.color = spec.color
        p.spin = i * 0.78
        p.spin_speed = 9.5 + (i % 3) * 2.5
        p.max_life = 0.44
        p.life = 0.44
        p.active = true
        sys.active[#sys.active + 1] = p
    end
    for i = 1, #DUST_DIRECTIONS do
        local spec = DUST_DIRECTIONS[i]
        local p = acquire_particle(sys)
        p.kind = Particles.KIND_DUST
        p.x = x + (spec.dx * 0.10)
        p.y = y
        p.z = z + (spec.dz * 0.10)
        p.vx = spec.dx
        p.vy = spec.dy
        p.vz = carry_vz + spec.dz
        p.gravity = -4.5
        p.drag = 3.8
        p.base_size = spec.size
        p.color = spec.color
        p.spin = i * 0.52
        p.spin_speed = 4.0
        p.max_life = 0.38
        p.life = 0.38
        p.active = true
        sys.active[#sys.active + 1] = p
    end
end

function Particles.update(sys, dt)
    local i = 1
    while i <= #sys.active do
        local p = sys.active[i]
        p.life = p.life - dt
        if p.life <= 0.0 then
            p.active = false
            sys.pool[#sys.pool + 1] = p
            sys.active[i] = sys.active[#sys.active]
            sys.active[#sys.active] = nil
        else
            local damping = math.max(0.0, 1.0 - (p.drag * dt))
            p.vx = p.vx * damping
            p.vz = p.vz * damping
            p.vy = p.vy + p.gravity * dt
            p.x = p.x + p.vx * dt
            p.y = math.max(0.05, p.y + p.vy * dt)
            p.z = p.z + p.vz * dt
            p.spin = p.spin + p.spin_speed * dt
            i = i + 1
        end
    end
end

function Particles.render(sys, min_z, max_z)
    for i = 1, #sys.active do
        local p = sys.active[i]
        if p.z >= min_z and p.z <= max_z then
            local life_ratio = math.max(0.0, math.min(1.0, p.life / p.max_life))
            local scale
            local alpha
            if p.kind == Particles.KIND_SPARK then
                scale = math.max(0.05, p.base_size * (0.35 + 0.65 * life_ratio))
                alpha = math.max(0.20, life_ratio)
            else
                local expand = 1.0 + (1.0 - life_ratio) * 0.45
                scale = math.max(0.06, p.base_size * expand * life_ratio)
                alpha = math.max(0.15, life_ratio * 0.85)
            end
            Renderer.add_particle(p.x, p.y, p.z, scale, p.color, alpha, p.spin)
        end
    end
end

return Particles
