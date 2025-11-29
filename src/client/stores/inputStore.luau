local Vide = require("../../../modules/Vide")

local castRod = Vide.source(false)
local shakeRod = Vide.source(false)
local holdRod = Vide.source(false)

local castButton = Vide.source(nil :: Instance?)
local shakeButton = Vide.source(nil :: Instance?)
local holdButton = Vide.source(nil :: Instance?)

return {
	castRod = castRod,
	shakeRod = shakeRod,
	holdRod = holdRod,
	castButton = castButton,
	shakeButton = shakeButton,
	holdButton = holdButton,
}
