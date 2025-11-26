local Vide = require("../../../submodules/Vide")
local VideCharm = require("../../../submodules/VideCharm")
local appStore = require("../stores/appStore")
local fishes = require("../../shared/constants/fishes")
local fonts = require("../utils/fonts")
local inputStore = require("../stores/inputStore")
local numbers = require("../../shared/utils/numbers")
local px = require("../utils/px")
local remotes = require("../../shared/remotes")
local rods = require("../../shared/constants/rods")
local stats = require("../../shared/stats")
local useMinigame = require("../hooks/useMinigame")
local useSpringFrom = require("../hooks/useSpringFrom")
local useTransparency = require("../hooks/useTransparency")

local create = Vide.create
local cleanup = Vide.cleanup
local effect = Vide.effect
local show = Vide.show
local useSignalState = VideCharm.useSignalState

local HOTBAR_INSET = 70

local function FishingBarView(visible: () -> boolean, seed: number, rod: rods.RodInfo, fish: fishes.FishInfo)
	local minigame = useMinigame(seed, rod, fish)
	local progressSpeed = stats.getProgressSpeedPercentage(minigame.state.speed)

	local transition = useSpringFrom(function()
		return if visible() then 1 else 0
	end, 0, 0.4)

	local transparency = useSpringFrom(function()
		return if visible() then 0 else 1
	end, 1, 0.25)

	cleanup(task.delay(2, function()
		minigame.start()
	end))

	effect(function()
		if minigame.getStatus() == "complete" then
			remotes.catchFish:FireServer(minigame.export())
		end
	end)

	return create("Frame", {
		Name = "FishingBar",
		BackgroundColor3 = Color3.fromHex("#000000"),
		BackgroundTransparency = useTransparency(0.3, transparency),
		AnchorPoint = Vector2.new(0.5, 1),
		Position = function()
			return px.udim2(0.5, 0, 1, -74 - px.raw(HOTBAR_INSET) + math.lerp(30, 0, transition()))()
		end,
		Size = function()
			return px.offset(math.lerp(340, 440, transition()), 20)()
		end,

		create("Frame", {
			Name = "ControlBar",
			BackgroundColor3 = Color3.fromHex("#FFFFFF"),
			BackgroundTransparency = transparency,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = function()
				return UDim2.fromScale(minigame.getBarPosition(), 0.5)
			end,
			Size = UDim2.fromScale(minigame.state.range * 2, 1),

			create("TextLabel", {
				Name = "ArrowLeft",
				FontFace = fonts.inter.heavy,
				Text = "←",
				TextSize = px(20),
				TextTransparency = useTransparency(0.5, transparency),
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Position = px.udim2(0, 2, 0, 0),
				Size = UDim2.fromScale(0, 1),
				Visible = function()
					return not inputStore.holdRod()
				end,
			}),

			create("TextLabel", {
				Name = "ArrowRight",
				FontFace = fonts.inter.heavy,
				Text = "→",
				TextSize = px(20),
				TextTransparency = useTransparency(0.5, transparency),
				TextXAlignment = Enum.TextXAlignment.Right,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = px.udim2(1, -2, 0, 0),
				Size = UDim2.fromScale(0, 1),
				Visible = inputStore.holdRod,
			}),

			create("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),

		create("Frame", {
			Name = "ProgressBar",
			BackgroundColor3 = Color3.fromHex("#000000"),
			BackgroundTransparency = useTransparency(0.3, transparency),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = px.udim2(0.5, 0, 1, 26),
			Size = px.offset(250, 8),

			create("Frame", {
				Name = "ProgressFill",
				BackgroundColor3 = Color3.fromHex("#FFFFFF"),
				BackgroundTransparency = useTransparency(0.5, transparency),
				Size = function()
					return UDim2.fromScale(math.max(0.025, minigame.getProgress()), 1)
				end,

				create("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}),

			math.abs(progressSpeed) > 0.01 and create("TextLabel", {
				Name = "ProgressSpeed",
				FontFace = fonts.inter.semibold,
				Text = `{numbers.signedPercentage(progressSpeed)} Progress Speed`,
				TextColor3 = Color3.fromHex("#FFFFFF"),
				TextSize = px(16),
				TextYAlignment = Enum.TextYAlignment.Top,
				TextTransparency = useTransparency(0.25, transparency),
				BackgroundTransparency = 1,
				Position = px.udim2(0.5, 0, 1, 10),

				create("UIStroke", {
					Thickness = px.scale(2),
					Transparency = useTransparency(0.7, transparency),
				}),
			}) or nil,

			create("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			create("UIStroke", {
				Thickness = px.scale(3),
				Transparency = useTransparency(0.3, transparency),
			}),
		}),

		create("Frame", {
			Name = "Fish",
			BackgroundColor3 = Color3.fromHex("#6EB5F1"),
			BackgroundTransparency = transparency,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = function()
				return UDim2.fromScale(minigame.getFishPosition(), 0.5)
			end,
			Size = px.offset(14, 50),

			create("TextLabel", {
				Name = "FishEmoji",
				Text = "🐟",
				TextSize = px(40),
				TextTransparency = transparency,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0),
			}),

			create("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),

			create("UIStroke", {
				BorderStrokePosition = Enum.BorderStrokePosition.Inner,
				Color = Color3.fromHex("#FFFFFF"),
				Thickness = px(2),
				Transparency = useTransparency(0.75, transparency),
			}),
		}),

		create("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		create("UIStroke", {
			Thickness = px.scale(5),
			Transparency = useTransparency(0.3, transparency),
		}),
	})
end

local function FishingBar()
	local isReeling = useSignalState(appStore.isReeling)

	return show(isReeling, function()
		local fisher = appStore.getFisher() :: appStore.FisherReeling
		local rod = rods.byId[fisher.rodId]
		local fish = fishes.byId[fisher.fishId]

		return FishingBarView(isReeling, fisher.seed, rod, fish), 0.5
	end)
end

return FishingBar
