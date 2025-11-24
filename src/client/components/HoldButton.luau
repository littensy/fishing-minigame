local Button = require("./Button")
local Vide = require("../../../submodules/Vide")
local VideCharm = require("../../../submodules/VideCharm")
local appStore = require("../stores/appStore")
local inputStore = require("../stores/inputStore")
local px = require("../utils/px")
local usePreferredInput = require("../hooks/usePreferredInput")

local show = Vide.show
local useSignalState = VideCharm.useSignalState

local function HoldButton()
	return show(useSignalState(appStore.isCatching), function()
		local getPreferredInput = usePreferredInput()

		return Button({
			text = "HOLD",
			pressed = inputStore.holdRod,
			ref = inputStore.holdButton,
			position = function()
				return if getPreferredInput() == Enum.PreferredInput.Touch
					then px.udim2(1, -80, 0.5, 40)()
					else px.udim2(1, -80, 1, -80)()
			end,
		})
	end)
end

return HoldButton
