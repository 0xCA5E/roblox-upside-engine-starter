-- @ScriptType: ModuleScript
-- Simplex handlers for 2D GJK collision detection

local function ensurePerpendicularTowardsOrigin(edge, toOrigin)
        local perpendicular = Vector3.new(-edge.Y, edge.X, 0)

        if perpendicular:Dot(toOrigin) < 0 then
                perpendicular *= -1
        end

        return perpendicular
end

local function handlePoint(direction, simplex)
        local a = simplex[#simplex]
        return -a
end

local function handleLine(direction, simplex)
        local a = simplex[#simplex]
        local b = simplex[#simplex - 1]

        local ab = b - a
        local ao = -a

        return ensurePerpendicularTowardsOrigin(ab, ao)
end

local function handleTriangle(direction, simplex)
        local a = simplex[#simplex]
        local b = simplex[#simplex - 1]
        local c = simplex[#simplex - 2]

        local ab = b - a
        local ac = c - a
        local ao = -a

        local abPerp = ensurePerpendicularTowardsOrigin(ab, c - a)
        if abPerp:Dot(ao) > 0 then
                simplex[1] = b
                simplex[2] = a
                simplex[3] = nil

                return abPerp
        end

        local acPerp = ensurePerpendicularTowardsOrigin(ac, b - a)
        if acPerp:Dot(ao) > 0 then
                simplex[1] = c
                simplex[2] = a
                simplex[3] = nil

                return acPerp
        end

        return direction, true
end

return {
        point = handlePoint,
        line = handleLine,
        triangle = handleTriangle,
}
