local RunService = game:GetService("RunService")
local Run = Instance.new("BindableEvent")

for _, v in ipairs({RunService.PreRender, RunService.PreSimulation, RunService.PostSimulation}) do
    v:Connect(function(...)
        Run:Fire(...)
    end)
end

return Run.Event
