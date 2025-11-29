local Vide = require("../../../modules/Vide")

local function useTransparency(...: number | () -> number): () -> number
	local values = { ... }

	return Vide.derive(function()
		local opacity = 1
		for _, transparency in values do
			opacity *= 1 - if type(transparency) == "number" then transparency else transparency()
		end
		return 1 - opacity
	end)
end

return useTransparency
