local Charm = require("../../../submodules/Charm")

export type BobberEntry = {
	character: Model,
	power: number,
	rodId: string,
}

type BobberStore = {
	bobbers: { [string]: BobberEntry },
}

local state: BobberStore = Charm.reactive({
	bobbers = {},
})

local function getBobbers(): { [string]: BobberEntry }
	return state.bobbers
end

local function addBobber(username: string, character: Model, power: number, rodId: string)
	if state.bobbers[username] then
		state.bobbers[username] = nil
	end
	state.bobbers[username] = {
		character = character,
		power = power,
		rodId = rodId,
	}
end

local function removeBobber(username: string)
	state.bobbers[username] = nil
end

return {
	getBobbers = getBobbers,
	addBobber = addBobber,
	removeBobber = removeBobber,
}
