local fishes = require("./fishes")

type Fish = fishes.Fish

export type function Writable(ty: type): type
	local result = types.copy(ty)
	for key, value in result:properties() do
		result:setproperty(key, value.read)
	end
	return result
end

export type Account = {
	read gold: number,
	read fishes: { [string]: Fish },
}

local accountTemplate: Account = {
	gold = 0,
	fishes = {},
}

return {
	accountTemplate = accountTemplate,
}
