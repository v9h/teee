local RunService = game:GetService("RunService")
local Run = Instance.new("BindableEvent")

for _, v in ipairs({RunService.RenderStepped, RunService.Stepped, RunService.Heartbeat}) do
    v:Connect(function(...)
        Run:Fire(...)
    end)
end

return Run.Event
