local Charm = require("../../../modules/Charm")
local accountStore = require("../stores/accountStore")
local accounts = require("../accounts")
local fishes = require("../../shared/fishes")
local observers = require("../../shared/utils/observers")

type Fish = fishes.Fish

local function createFishTool(fish: Fish, uniqueId: string): Tool
	local tool = Instance.new("Tool")
	tool:SetAttribute("UniqueId", uniqueId)
	tool.Name = fishes.stringifyFish(fish)
	tool.ToolTip = string.format("%.2f lbs", fishes.getFishWeight(fish))
	tool.CanBeDropped = false

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(2, 2, 2) * fish.weightMultiplier
	handle.Parent = tool

	return tool
end

local function getEquippedFishId(player: Player): string?
	local character = player.Character
	local tool = character and character:FindFirstChildWhichIsA("Tool")
	return tool and tool:GetAttribute("UniqueId") :: string?
end

observers.observePlayers(function(player)
	return observers.observeChildWhichIsA(player, "Backpack", function(backpack: Backpack)
		local function getFishes(): { [string]: Fish }
			local account = accountStore.getAccount(player.Name)
			return if account then account.fishes else {}
		end

		return Charm.observe(getFishes, function(fishProxy, uniqueId)
			local tool = createFishTool(fishProxy, uniqueId)
			tool.Parent = backpack
			return function()
				tool:Destroy()
			end
		end)
	end)
end)

observers.observeTag("SellPrompt", function(prompt: ProximityPrompt)
	local triggered = prompt.Triggered:Connect(function(player)
		local uniqueId = getEquippedFishId(player)
		if uniqueId then
			accounts.sellFish(player, uniqueId)
		end
	end)

	return function()
		triggered:Disconnect()
	end
end)
