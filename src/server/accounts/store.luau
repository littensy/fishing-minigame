local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Lyra = require("../../../modules/Lyra")
local accountStore = require("../stores/accountStore")
local schema = require("./schema")
local types = require("../../shared/types")

type Account = types.Account

-- FIXME: Remove type cast when Luau issue #1986 is resolved
type PlayerStoreConfig<T> = {
	name: string,
	template: T,
	useDSSLocking: boolean?,
	schema: (value: any) -> (boolean, string?),
	migrationSteps: any,
	importLegacyData: ((key: string) -> any?)?,
	changedCallbacks: any,
	logCallback: any,
	memoryStoreService: MemoryStoreService?,
	dataStoreService: DataStoreService?,
}

local function accountChanged(key: string, account: Account)
	local player = Players:GetPlayerByUserId(tonumber(key) :: number)
	if player then
		accountStore.reconcileAccount(player.Name, account)
	end
end

local config = {
	name = "PlayerData",
	template = types.accountTemplate,
	schema = function(data)
		local ok, reason = schema:matches(data)
		return ok, tostring(reason)
	end,
	changedCallbacks = { accountChanged },
} :: PlayerStoreConfig<Account>

if RunService:IsStudio() then
	config.dataStoreService = Lyra.MockDataStoreService.new()
	config.memoryStoreService = Lyra.MockMemoryStoreService.new()
end

return Lyra.createPlayerStore(config)
