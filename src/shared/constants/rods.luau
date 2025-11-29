export type RodInfo = {
	name: string,
	description: string,
	control: number,
	resilience: number,
	lureSpeed: number,
	progressSpeed: number,
}

local rodsById: { [string]: RodInfo } = {
	basic = {
		name = "Basic Rod",
		description = "A simple fishing rod for beginners.",
		control = 0,
		resilience = 0,
		lureSpeed = 0,
		progressSpeed = 0,
	},
	advanced = {
		name = "Advanced Rod",
		description = "A high-quality rod for experienced anglers.",
		control = 0.2,
		resilience = 0.3,
		lureSpeed = 0.5,
		progressSpeed = 0.25,
	},
	fast = {
		name = "Fast Rod",
		description = "A fishing rod that prioritizes speed over control.",
		control = -0.3,
		resilience = -0.5,
		lureSpeed = 1,
		progressSpeed = 1,
	},
}

local function getRod(rodId: string): RodInfo
	return assert(rodsById[rodId], `Failed to get rod {rodId}`)
end

local function getRodIdFromTool(tool: Tool): string?
	local rodId = tool:GetAttribute("RodId")
	return if type(rodId) == "string" and rodsById[rodId] then rodId else nil
end

local function getRodIdFromCharacter(character: Model): string?
	local tool = character and character:FindFirstChildWhichIsA("Tool")
	return tool and getRodIdFromTool(tool)
end

return {
	rodsById = rodsById,
	getRod = getRod,
	getRodIdFromTool = getRodIdFromTool,
	getRodIdFromCharacter = getRodIdFromCharacter,
}
