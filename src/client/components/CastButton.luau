local Button = require("./Button")
local Vide = require("../../../submodules/Vide")
local VideCharm = require("../../../submodules/VideCharm")
local appStore = require("../stores/appStore")
local inputStore = require("../stores/inputStore")
local px = require("../utils/px")
local usePreferredInput = require("../hooks/usePreferredInput")
local useRod = require("../hooks/useRod")

local show = Vide.show
local useSignalState = VideCharm.useSignalState

local function CastButton()
	local getRod = useRod()
	local isFishing = useSignalState(appStore.isFishing)

	local function canCastRod()
		return getRod() ~= nil and not isFishing()
	end

	return show(canCastRod, function()
		local getPreferredInput = usePreferredInput()

		return Button({
			text = "CAST\nROD",
			pressed = inputStore.castRod,
			ref = inputStore.castButton,
			position = function()
				return if getPreferredInput() == Enum.PreferredInput.Touch
					then px.udim2(1, -80, 0.5, 40)()
					else px.udim2(1, -80, 1, -80)()
			end,
		})
	end)
end

return CastButton
