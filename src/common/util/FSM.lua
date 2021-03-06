local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")

local Signal = require(lib:WaitForChild("Signal"))

local errors = {
    invalidState = "Cannot transition to state [%s] Does not exist!"
}

local FSM = {}

function FSM.new(states, startState)
    local self = setmetatable({},{__index=FSM})

    self.states = states

    -- name states
    for name,state in pairs(self.states) do
        state.name = name
    end

    self.enteringState = Signal.new()
    self.leavingState = Signal.new()

    self.stateLocked = false
    self.deadLocked = false

    self:transition(startState)

    return self
end

function FSM:transition(newState, ...)
    if not newState then return end
    if self.stateLocked then return end
    if self.deadLocked then return end

    return self:_transition(newState, ...)
end

function FSM:_transition(newState, ...)
    if not newState then return end

    if self.currentState and typeof(self.currentState.leaving) == "function" then
        self.leavingState:fire(self.currentState.name)
        self.currentState.leaving()
    end

    local targetState = self.states[newState]
    assert(targetState, errors.invalidState:format(newState))
    self.currentState = targetState

    if targetState.stateLockTime then
        self.stateLocked = true
        delay(targetState.stateLockTime, function()
            self.stateLocked = false
        end)
    end

    self.enteringState:fire(self.currentState.name, self.currentState)
    return self:transition(targetState.enter(...))
end

function FSM:step(...)
    if not self.currentState.step then return end
    if not typeof(self.currentState.step) == "function" then return end

    self:transition(self.currentState.step(...))
end

return FSM