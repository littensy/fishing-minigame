local CastButton = require("./CastButton")
local CastMeter = require("./CastMeter")
local FishingBar = require("./FishingBar")
local HoldButton = require("./HoldButton")
local ShakeButton = require("./ShakeButton")
local Vide = require("../../../submodules/Vide")
local px = require("../utils/px")

local create = Vide.create

local function App()
	px.usePx()

	return create("ScreenGui", {
		Name = "Gameplay",

		CastMeter(),
		CastButton(),
		ShakeButton(),
		HoldButton(),
		FishingBar(),
	})
end

return App
