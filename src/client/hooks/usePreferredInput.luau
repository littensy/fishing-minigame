local UserInputService = game:GetService("UserInputService")

local Vide = require("../../../modules/Vide")
local useEventListener = require("./useEventListener")

local function usePreferredInput(): () -> Enum.PreferredInput
	local preferredInput = Vide.source(UserInputService.PreferredInput)

	useEventListener(UserInputService:GetPropertyChangedSignal("PreferredInput"), function()
		preferredInput(UserInputService.PreferredInput)
	end)

	return preferredInput
end

return usePreferredInput
