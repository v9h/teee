local Events = {}
Events.__index = Events

type Event = {
    new: (any),
    Fire: (any),
    Wait: (any),
    Kill: (any),
    Add: (any),

    Yield: boolean,
    Result: any,
    Listeners: table
}


local RunService = game:GetService("RunService")


function Events:Fire(...)
    self.Return = ...
    self.Yield = false
    for Callback in pairs(self.Listeners) do
        Callback(...)
    end
end


function Events:Wait(): any
    self.Yield = true
    while self.Yield do
        RunService.Heartbeat:Wait()
    end

    return self.Return
end


function Events:Kill()
    self.Result = nil
    self.Yield = false

    table.clear(self.Listeners)
    setmetatable(self, {
        __index = function()
            error("Attempted to use dead event")
        end
    })
end


function Events:Add(Callback: any): table
    self.Listeners[Callback] = Callback
    local function Remove()
        self.Listeners[Callback] = nil
    end

    return {Remove = Remove}
end


function Events.new(): Event
    local Event = setmetatable({}, Events)

    Event.Yield = false
    Event.Result = nil
    Event.Listeners = {}

    return Event
end


return Events