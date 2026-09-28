-- ============================================================================
-- SohdRunner - 3D Collision System (collision.lua)
-- Developer: Ahmed
-- ============================================================================

local Collision = {}

function Collision.update_aabb(box, center_x, base_y, center_z, half_w, height, half_d)
    box = box or {}
    box.min_x = center_x - half_w
    box.max_x = center_x + half_w
    box.min_y = base_y
    box.max_y = base_y + height
    box.min_z = center_z - half_d
    box.max_z = center_z + half_d
    return box
end

function Collision.aabb_vs_aabb(a, b)
    if a.max_x < b.min_x or a.min_x > b.max_x then return false end
    if a.max_y < b.min_y or a.min_y > b.max_y then return false end
    if a.max_z < b.min_z or a.min_z > b.max_z then return false end
    return true
end

function Collision.aabb_vs_sphere(box, sx, sy, sz, radius)
    local closest_x = math.max(box.min_x, math.min(sx, box.max_x))
    local closest_y = math.max(box.min_y, math.min(sy, box.max_y))
    local closest_z = math.max(box.min_z, math.min(sz, box.max_z))
    local dx = sx - closest_x
    local dy = sy - closest_y
    local dz = sz - closest_z
    local dist_sq = (dx * dx) + (dy * dy) + (dz * dz)
    return dist_sq <= (radius * radius)
end

function Collision.capsule_vs_aabb(cx, min_y, max_y, cz, radius, box)
    if max_y < box.min_y or min_y > box.max_y then
        return false
    end
    local closest_x = math.max(box.min_x, math.min(cx, box.max_x))
    local closest_z = math.max(box.min_z, math.min(cz, box.max_z))
    local dx = cx - closest_x
    local dz = cz - closest_z
    return ((dx * dx) + (dz * dz)) <= (radius * radius)
end

function Collision.get_ground_height(x, y, z)
    return 0.0
end

function Collision.check_boundaries(x, half_width, min_bound, max_bound)
    if (x - half_width) < min_bound then
        return min_bound + half_width, true
    elseif (x + half_width) > max_bound then
        return max_bound - half_width, true
    end
    return x, false
end

return Collision
