local Players = game:GetService("Players")

local Vide = require("../../../submodules/Vide")
local useEventListener = require("./useEventListener")

local function useCharacter(): () -> Model?
	local character = Vide.source(Players.LocalPlayer.Character)

	useEventListener(Players.LocalPlayer.CharacterAdded, character)

	useEventListener(Players.LocalPlayer.CharacterRemoving, function(removedCharacter)
		if character() == removedCharacter then
			character(nil)
		end
	end)

	return character
end

return useCharacter
