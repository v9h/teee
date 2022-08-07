local function streets_raycast(Start: Vector3, End: Vector3, Distance: number, Ignore: table): tuple
    return workspace:FindPartOnRay(Ray.new(Start, CFrame.new(Start, End).LookVector * Distance), Ignore)
end

local function Raycast(Position: Vector3, Position_2: Vector3, Blacklist: table): RaycastResult
    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Blacklist
    RayParams.FilterDescendantsInstances = Blacklist

    return workspace:Raycast(Position, Position_2, RayParams)
end


return {
    new = Raycast,
    streets = streets_raycast
}