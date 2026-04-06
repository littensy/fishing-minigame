local Charm = require("../../../modules/Charm")
local accountStore = require("../stores/accountStore")
local accounts = require("../accounts")
local attribute = require("../../shared/utils/attribute")
local fishes = require("../../shared/fishes")
local observers = require("../../shared/utils/observers")

type Fish = fishes.Fish

local guidAttribute = attribute<<string?>>("FishGuid")

local function createFishTool(fish: Fish, guid: string): Tool
	local tool = Instance.new("Tool")
	tool.Name = fishes.stringifyFish(fish)
	tool.ToolTip = string.format("%.2f lbs", fishes.getFishWeight(fish))
	tool.CanBeDropped = false

	guidAttribute.set(tool, guid)

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(2, 2, 2) * fish.weightMultiplier
	handle.Parent = tool

	return tool
end

local function getEquippedFishGuid(player: Player): string?
	local character = player.Character
	local tool = character and character:FindFirstChildWhichIsA("Tool")
	return tool and guidAttribute.get(tool)
end

observers.observePlayers(function(player)
	return observers.observeChildWhichIsA(player, "Backpack", function(backpack: Backpack)
		local function getFishes(): { [string]: Fish }
			local account = accountStore.getAccount(player.Name)
			return if account then account.fishes else {}
		end

		return Charm.observe(getFishes, function(fish, guid)
			local tool = createFishTool(fish, guid)
			tool.Parent = backpack
			return function()
				tool:Destroy()
			end
		end)
	end)
end)

observers.observeTag("SellPrompt", function(prompt: ProximityPrompt)
	local triggered = prompt.Triggered:Connect(function(player)
		local guid = getEquippedFishGuid(player)
		if guid then
			accounts.sellFish(player, guid)
		end
	end)

	return function()
		triggered:Disconnect()
	end
end)
