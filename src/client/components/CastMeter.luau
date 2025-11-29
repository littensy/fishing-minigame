local Vide = require("../../../modules/Vide")
local VideCharm = require("../../../modules/VideCharm")
local appStore = require("../stores/appStore")
local inputStore = require("../stores/inputStore")
local px = require("../utils/px")
local remotes = require("../../shared/remotes")
local useCharacter = require("../hooks/useCharacter")
local useRod = require("../hooks/useRod")
local useSpringFrom = require("../hooks/useSpringFrom")
local useTimer = require("../hooks/useTimer")
local useTransparency = require("../hooks/useTransparency")

local create = Vide.create
local effect = Vide.effect
local show = Vide.show
local untrack = Vide.untrack
local useSignalState = VideCharm.useSignalState

local function CastMeterView(visible: () -> boolean)
	local speed = math.lerp(1.5, 2.5, math.random())
	local timer = useTimer()

	local transition = useSpringFrom(function()
		return if visible() then 1 else 0
	end, 0, 0.3)

	local transparency = useSpringFrom(function()
		return if visible() then 0 else 1
	end, 1, 0.15)

	local function getPower()
		return math.abs((timer.time() * speed - 1) % 2 - 1)
	end

	effect(function()
		if visible() then
			timer.reset()
			timer.start()
		else
			timer.stop()
		end
	end)

	effect(function()
		if not inputStore.castRod() and untrack(timer.time) > 0.2 then
			remotes.castRod:FireServer(getPower())
		end
	end)

	return create("BillboardGui")({
		Name = "CastMeter",
		Adornee = useCharacter() :: () -> Instance,
		AlwaysOnTop = true,
		Size = px.offset(12, 200),
		StudsOffset = function()
			return Vector3.new(math.lerp(2, 3, transition()), 0, 0)
		end,

		create("Frame")({
			Name = "MeterBackground",
			BackgroundColor3 = Color3.fromHex("#000000"),
			BackgroundTransparency = useTransparency(0.3, transparency),
			Size = UDim2.fromScale(1, 1),

			create("Frame")({
				Name = "MeterFill",
				BackgroundColor3 = Color3.fromHex("#FFFFFF"),
				BackgroundTransparency = transparency,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = function()
					return UDim2.fromScale(1, math.lerp(0.075, 1, getPower()))
				end,

				create("UICorner")({
					CornerRadius = UDim.new(1, 0),
				}),
			}),

			create("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),

			create("UIStroke")({
				Thickness = px.scale(3),
				Transparency = useTransparency(0.3, transparency),
			}),
		}),
	})
end

local function CastMeter()
	local getRod = useRod()
	local isFishing = useSignalState(appStore.isFishing)

	local function isCasting()
		return getRod() ~= nil and not isFishing() and inputStore.castRod()
	end

	return show(isCasting, function()
		return CastMeterView(isCasting), 0.25
	end)
end

return CastMeter
