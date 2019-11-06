local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")

local lib = ReplicatedStorage:WaitForChild("lib")
local common = ReplicatedStorage:WaitForChild("common")

local Selectors = require(common:WaitForChild("Selectors"))
local PizzaAlpaca = require(lib:WaitForChild("PizzaAlpaca"))
local Roact = require(lib:WaitForChild("Roact"))
local RoactRodux = require(lib:WaitForChild("RoactRodux"))
local Actions = require(common:WaitForChild("Actions"))
local Thunks = require(common:WaitForChild("Thunks"))
local uiComponents = script:WaitForChild("uiComponents")
local App = require(uiComponents.App)

local GuiContainer = PizzaAlpaca.GameModule:extend("GuiContainer")

local function makeApp(store, props)
    local storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
        store = store,
    }, {
        app = Roact.createElement(App, props)
    })

    return storeProvider
end

function GuiContainer:preInit()
    PlayerGui:SetTopbarTransparency(0)
    GuiService.AutoSelectGuiEnabled = true
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
end

function GuiContainer:init()

    Roact.setGlobalConfig({elementTracing = true})

    self.logger = self.core:getModule("Logger"):createLogger(self)

    local storeContainer = self.core:getModule("StoreContainer")
    local inputHandler = self.core:getModule("InputHandler")

    local openInventory = inputHandler:getActionSignal("openInventory")
    local openCrafting = inputHandler:getActionSignal("openCrafting")

    local cancel = inputHandler:getActionSignal("cancel")

    storeContainer:getStore():andThen(function(store)

        store:dispatch(Thunks.VIEW_SET("default"))


        cancel.began:connect(function()
            store:dispatch(Thunks.VIEW_SET("default"))
        end)

        openInventory.began:connect(function()
            local currentView = Selectors.getView(store:getState())
            local targetView = "inventory"
            targetView = ((currentView ~= targetView) and targetView) or "default"
            store:dispatch(Thunks.VIEW_SET(targetView))
        end)

        openCrafting.began:connect(function()
            local currentView = Selectors.getView(store:getState())
            local targetView = "crafting"
            targetView = ((currentView ~= targetView) and targetView) or "default"
            store:dispatch(Thunks.VIEW_SET(targetView))
        end)

        local screenSizer = Instance.new("ScreenGui")
        screenSizer.Name = "ScreenSizeReporter"
        screenSizer.Parent = PlayerGui
        screenSizer:GetPropertyChangedSignal("AbsoluteSize"):connect(function()
            store:dispatch(Actions.SCREENSIZE_SET(screenSizer.AbsoluteSize))
        end)

        self.appHandle = Roact.mount(makeApp(store, {
            pzCore = self.core,
        }), PlayerGui)
        self.logger:log("UI Mounted")
    end)
end

function GuiContainer:postInit()
end

return GuiContainer