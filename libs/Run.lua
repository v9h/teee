local RunService = game:GetService("RunService")
local Event = Instance.new("BindableEvent")
local Run = {}
Run.Stepped = Event.Event

for _, v in ipairs({RunService.RenderStepped, RunService.Stepped, RunService.Heartbeat}) do
    v:Connect(function(...)
        Event:Fire(...)
    end)
end

return Run
