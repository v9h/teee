-- // TODO \\ --
-- 1. Dangerous Areas Check, Don't want oil going in 7 battleships


local Pathfinder = {}


local Console = Console
local PathfindingService = game:GetService("PathfindingService")


function Pathfinder:GetPath(Unit:Unit, Destination:Vector3, Costs:Table, OnBlocked:Function)
    local Path = PathfindingService:CreatePath({
        AgentCanJump = false,
        AgentHeight = 3,
        AgentRadius = 6,
        Costs = Costs,
        WaypointSpacing = 1 -- Precision
    })

    local Success = pcall(function() -- Result is always nil?
        Path:ComputeAsync(Unit.Torso.Position, Destination)
    end)

    local OnBlocked = typeof(OnBlocked) == "function" and OnBlocked or function() end
    Path.Blocked:Connect(OnBlocked)

    if Success and Path.Status == Enum.PathStatus.Success then
        return Path
    else
        Console:Error("[PATHFINDER] ERROR COULDN'T COMPUTE WAYPOINTS FOR \"" .. string.upper(tostring(Unit)) .. "\"")
    end
end


getgenv().Pathfinder = Pathfinder


return Pathfinder