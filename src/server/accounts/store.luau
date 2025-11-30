local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Lyra = require("../../../modules/Lyra")
local accountStore = require("../stores/accountStore")
local schema = require("./schema")
local types = require("../../shared/types")

type Account = types.Account

local function accountChanged(key: string, account: Account)
	local player = Players:GetPlayerByUserId(tonumber(key) :: number)
	if player then
		accountStore.setAccount(player.Name, account)
	end
end

-- FIXME: Remove explicit type when luau-lang/luau#1986 is resolved
local config: Lyra.PlayerStoreConfig<Account> = {
	name = "PlayerData",
	template = types.accountTemplate,
	schema = function(data)
		local ok, reason = schema:matches(data)
		return ok, tostring(reason)
	end,
	changedCallbacks = { accountChanged },
}

if RunService:IsStudio() then
	config.dataStoreService = Lyra.MockDataStoreService.new()
	config.memoryStoreService = Lyra.MockMemoryStoreService.new()
end

return Lyra.createPlayerStore(config)
