local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lib = ReplicatedStorage:WaitForChild("lib")
local commands = script:WaitForChild("commands")
local types = script:WaitForChild("types")

local Cmdr = require(lib:WaitForChild("Cmdr"))
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Promise = require(lib:WaitForChild("Promise"))

local CmdrContainer = PizzaAlpaca.GameModule:extend("CmdrContainer")

function CmdrContainer:onResolve(store, recsCore)
    Cmdr.Registry:RegisterHook("BeforeRun", function(context)
        context.State.pzCore = self.core
        context.State.store = store
        context.State.recsCore = recsCore
    end)

    Cmdr:RegisterDefaultCommands()
    Cmdr:RegisterCommandsIn(commands)
    Cmdr:RegisterTypesIn(types)
end

function CmdrContainer:init()
    local storeContainer = self.core:getModule("StoreContainer")
    local recsContainer = self.core:getModule("ServerRECSContainer")

    Promise.all({
        storeContainer:getStore(),
        recsContainer:getCore()
    }):andThen(function(results)
        self:onResolve(unpack(results))
    end)
end

return CmdrContainer