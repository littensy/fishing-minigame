local Vide = require("../../../submodules/Vide")
local VideCharm = require("../../../submodules/VideCharm")
local appStore = require("../stores/appStore")
local inputStore = require("../stores/inputStore")
local objects = require("../../shared/utils/objects")
local useRod = require("../hooks/useRod")

local create = Vide.create
local useSignalState = VideCharm.useSignalState

type InputProps = {
	key: Enum.KeyCode?,
	button: (() -> Instance?)?,
}

type BoolInputActionProps = {
	name: string,
	enabled: () -> boolean,
	action: (boolean) -> (),
	inputs: { InputProps },
}

local function BoolInputAction(props: BoolInputActionProps)
	return create("InputAction", {
		StateChanged = props.action,
		Name = props.name,
		Type = Enum.InputActionType.Bool,
		Enabled = props.enabled,

		objects.map(props.inputs, function(input)
			return create("InputBinding", {
				Name = if input.key then input.key.Name else "UIButton",
				KeyCode = input.key,
				UIButton = input.button,
			})
		end),
	})
end

local function Inputs()
	local getRod = useRod()
	local isFishing = useSignalState(appStore.isFishing)
	local isLuring = useSignalState(appStore.isLuring)
	local isCatching = useSignalState(appStore.isReeling)

	return create("InputContext", {
		Name = "GameplayContext",

		BoolInputAction({
			name = "CastRod",
			enabled = function()
				return getRod() ~= nil and not isFishing()
			end,
			action = inputStore.castRod,
			inputs = {
				{ key = Enum.KeyCode.MouseLeftButton },
				{ key = Enum.KeyCode.ButtonX },
				{ button = inputStore.castButton },
			},
		}),

		BoolInputAction({
			name = "ShakeRod",
			enabled = function()
				return getRod() ~= nil and isLuring()
			end,
			action = inputStore.shakeRod,
			inputs = {
				{ key = Enum.KeyCode.ButtonA },
				{ button = inputStore.shakeButton },
			},
		}),

		BoolInputAction({
			name = "HoldRod",
			enabled = function()
				return getRod() ~= nil and isCatching()
			end,
			action = inputStore.holdRod,
			inputs = {
				{ key = Enum.KeyCode.MouseLeftButton },
				{ key = Enum.KeyCode.ButtonX },
				{ button = inputStore.holdButton },
			},
		}),
	})
end

return Inputs
