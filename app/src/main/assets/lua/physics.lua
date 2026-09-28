-- ============================================================================
-- SohdRunner - Physics System (physics.lua)
-- Developer: Ahmed
-- ============================================================================

local Physics = {}

Physics.GRAVITY = -30.0
Physics.FAST_FALL_GRAVITY = -68.0
Physics.JUMP_VELOCITY = 11.8
Physics.GROUND_Y = 0.0
Physics.BASE_FORWARD_SPEED = 14.5
Physics.MAX_FORWARD_SPEED = 32.0
Physics.SPEED_ACCELERATION = 0.22
Physics.LANE_WIDTH = 2.2
Physics.LANE_CHANGE_SPEED = 15.5
Physics.LANE_SNAP_EPSILON = 0.02
Physics.MIN_BOUND_X = -2.65
Physics.MAX_BOUND_X = 2.65

function Physics.create_body(x, y, z)
    return {
        x = x or 0.0,
        y = y or Physics.GROUND_Y,
        z = z or 0.0,
        vx = 0.0,
        vy = 0.0,
        vz = Physics.BASE_FORWARD_SPEED,
        ax = 0.0,
        ay = Physics.GRAVITY,
        az = Physics.SPEED_ACCELERATION,
        target_x = x or 0.0,
        is_grounded = true,
        fast_falling = false,
        ground_y = Physics.GROUND_Y
    }
end

function Physics.clamp_dt(raw_dt)
    if not raw_dt or raw_dt <= 0.0 then
        return 0.0
    end
    if raw_dt > 0.05 then
        return 0.05
    end
    return raw_dt
end

function Physics.jump(body)
    if body.is_grounded then
        body.vy = Physics.JUMP_VELOCITY
        body.is_grounded = false
        body.fast_falling = false
        return true
    end
    return false
end

function Physics.fast_fall(body)
    if not body.is_grounded and body.vy > -12.0 then
        body.fast_falling = true
        if body.vy > 2.0 then
            body.vy = 2.0
        end
        return true
    end
    return false
end

function Physics.set_target_lane(body, lane_index)
    local clamped_lane = math.max(-1, math.min(1, lane_index))
    body.target_x = clamped_lane * Physics.LANE_WIDTH
end

function Physics.integrate(body, raw_dt, ground_collider_fn)
    local dt = Physics.clamp_dt(raw_dt)
    if dt <= 0.0 then
        return
    end
    local steps = 1
    if dt > 0.018 then
        steps = 2
    end
    local step_dt = dt / steps
    for _ = 1, steps do
        if body.vz < Physics.MAX_FORWARD_SPEED then
            body.vz = math.min(Physics.MAX_FORWARD_SPEED, body.vz + body.az * step_dt)
        end
        body.z = body.z + body.vz * step_dt
        local dx = body.target_x - body.x
        if math.abs(dx) <= Physics.LANE_SNAP_EPSILON then
            body.x = body.target_x
            body.vx = 0.0
        else
            local desired_vx = dx * Physics.LANE_CHANGE_SPEED
            if desired_vx > 18.0 then desired_vx = 18.0 end
            if desired_vx < -18.0 then desired_vx = -18.0 end
            body.vx = desired_vx
            local next_x = body.x + body.vx * step_dt
            if (dx > 0 and next_x > body.target_x) or (dx < 0 and next_x < body.target_x) then
                body.x = body.target_x
                body.vx = 0.0
            else
                body.x = next_x
            end
        end
        if body.x < Physics.MIN_BOUND_X then
            body.x = Physics.MIN_BOUND_X
            body.vx = 0.0
        elseif body.x > Physics.MAX_BOUND_X then
            body.x = Physics.MAX_BOUND_X
            body.vx = 0.0
        end
        if not body.is_grounded then
            local active_gravity = Physics.GRAVITY
            if body.fast_falling then
                active_gravity = Physics.FAST_FALL_GRAVITY
            end
            body.vy = body.vy + active_gravity * step_dt
            body.y = body.y + body.vy * step_dt
        end
        local detected_ground_y = body.ground_y
        if ground_collider_fn then
            detected_ground_y = ground_collider_fn(body.x, body.y, body.z)
        end
        if body.y <= detected_ground_y then
            body.y = detected_ground_y
            body.vy = 0.0
            body.is_grounded = true
            body.fast_falling = false
        else
            body.is_grounded = false
        end
    end
end

return Physics
