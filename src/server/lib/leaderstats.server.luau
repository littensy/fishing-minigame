local Players = game:GetService("Players")

local Charm = require("../../../modules/Charm")
local accountStore = require("../stores/accountStore")
local types = require("../../shared/types")

type Account = types.Account

Charm.observe(accountStore.getAccounts, function(initialAccount: Account, username: string)
	local player = Players:FindFirstChild(username) :: Player?

	if not player then
		return
	end

	local getAccount = Charm.computed(function(prevAccount: Account?)
		return accountStore.getAccount(username) or prevAccount or initialAccount
	end)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local gold = Instance.new("IntValue")
	gold.Name = "Gold"
	gold.Parent = leaderstats

	Charm.effect(function()
		local account = getAccount()
		gold.Value = account.gold
	end)

	return function()
		leaderstats:Destroy()
	end
end)
