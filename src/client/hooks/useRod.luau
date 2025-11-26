local Vide = require("../../../submodules/Vide")
local rods = require("../../shared/constants/rods")
local useCharacter = require("./useCharacter")
local useEventListener = require("./useEventListener")

local function useRod(): () -> rods.RodInfo?
	local currentRod = Vide.source(nil :: rods.RodInfo?)
	local getCharacter = useCharacter()

	Vide.effect(function()
		local character = getCharacter()

		if not character then
			return
		end

		local function updateCurrentRod()
			local rodId = rods.getRodIdFromCharacter(character)
			currentRod(rodId and rods.byId[rodId])
		end

		useEventListener(character.ChildAdded, function(child: Instance)
			if child:IsA("Tool") then
				updateCurrentRod()
			end
		end)

		useEventListener(character.ChildRemoved, function(child: Instance)
			if child:IsA("Tool") then
				updateCurrentRod()
			end
		end)

		updateCurrentRod()

		Vide.cleanup(function()
			currentRod(nil)
		end)
	end)

	return currentRod
end

return useRod
