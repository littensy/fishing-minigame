local Vide = require("../../../submodules/Vide")
local fonts = require("../utils/fonts")
local px = require("../utils/px")

local action = Vide.action
local create = Vide.create
local effect = Vide.effect
local spring = Vide.spring

type Props = {
	text: string,
	pressed: () -> boolean,
	ref: (Instance) -> any,
	position: UDim2 | () -> UDim2,
	onPress: (() -> ())?,
}

local function Button(props: Props)
	local pressed = props.pressed()

	effect(function()
		local wasPressed = pressed
		pressed = props.pressed()
		if props.onPress and wasPressed and not pressed then
			props.onPress()
		end
	end)

	return create("TextButton", {
		FontFace = fonts.inter.bold,
		Text = props.text,
		TextSize = px(20),
		TextColor3 = Color3.fromHex("#FFFFFF"),
		BackgroundColor3 = Color3.fromHex("#000000"),
		BackgroundTransparency = 0.3,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = props.position,
		Size = spring(function()
			return if props.pressed() then px.offset(90, 90)() else px.offset(110, 110)()
		end, 0.2, 0.6),

		action(function(instance)
			props.ref(instance)
		end),

		create("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		create("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			BorderOffset = px.udim(0, -8),
			Thickness = px.scale(2),
			Color = Color3.fromHex("#FFFFFF"),
			Transparency = 0.6,
		}),
	})
end

return Button
