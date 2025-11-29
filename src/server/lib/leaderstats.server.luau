local Players = game:GetService("Players")

local Charm = require("../../../modules/Charm")
local accountStore = require("../stores/accountStore")
local types = require("../../shared/types")

type Account = types.Account

Charm.observe(accountStore.getAccounts, function(account: Account, username: string): (() -> ())?
	local player = Players:FindFirstChild(username) :: Player?

	if not player then
		return nil
	end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local gold = Instance.new("IntValue")
	gold.Name = "Gold"
	gold.Parent = leaderstats

	Charm.effect(function()
		gold.Value = account.gold
	end)

	return function()
		leaderstats:Destroy()
	end
end)
