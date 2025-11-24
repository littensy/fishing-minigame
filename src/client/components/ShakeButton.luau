local Button = require("./Button")
local Vide = require("../../../submodules/Vide")
local VideCharm = require("../../../submodules/VideCharm")
local appStore = require("../stores/appStore")
local inputStore = require("../stores/inputStore")
local remotes = require("../../shared/remotes")
local useSpringFrom = require("../hooks/useSpringFrom")

local show = Vide.show
local source = Vide.source
local useSignalState = VideCharm.useSignalState

local function ShakeButton()
	return show(useSignalState(appStore.isLuring), function()
		local random = Random.new()
		local position = source(UDim2.fromScale(0.5, 0.5))
		local positionSpring, setPositionSpring = useSpringFrom(position, UDim2.fromScale(0.5, 0.6), 0.3, 0.5)

		return Button({
			text = "SHAKE",
			pressed = inputStore.shakeRod,
			ref = inputStore.shakeButton,
			position = positionSpring,

			onPress = function()
				position(UDim2.fromScale(random:NextNumber(0.3, 0.7), random:NextNumber(0.3, 0.7)))
				setPositionSpring({
					impulse = UDim2.fromScale(random:NextNumber(-6, 6), random:NextNumber(-6, 6)),
				})
				remotes.shakeRod:FireServer()
			end,
		})
	end)
end

return ShakeButton
