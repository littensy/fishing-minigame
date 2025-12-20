local Players = game:GetService("Players")

local Vide = require("../../../modules/Vide")
local useEventListener = require("./useEventListener")

local function useCharacter(): () -> Model?
	local character = Vide.source(Players.LocalPlayer.Character)

	useEventListener(Players.LocalPlayer.CharacterAdded, function(model: Model)
		character(model)
	end)

	useEventListener(Players.LocalPlayer.CharacterRemoving, function()
		character(nil)
	end)

	return character
end

return useCharacter
