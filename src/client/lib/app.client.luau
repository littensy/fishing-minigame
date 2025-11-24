local Players = game:GetService("Players")

local App = require("../components/App")
local Inputs = require("../components/Inputs")
local Vide = require("../../../submodules/Vide")

local mount = Vide.mount

mount(App, Players.LocalPlayer.PlayerGui)
mount(Inputs, Players.LocalPlayer)
