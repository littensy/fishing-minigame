local Lyra = require(script.Parent.submodules.Lyra)
local MockDataStoreService = require(script.Parent.submodules.Lyra.MockDataStoreService)
local MockMemoryStoreService = require(script.Parent.submodules.Lyra.MockMemoryStoreService)

export type PlayerStoreConfig<T> = {
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

return {
	MockDataStoreService = MockDataStoreService,
	MockMemoryStoreService = MockMemoryStoreService,
	MigrationStep = Lyra.MigrationStep,
	createPlayerStore = Lyra.createPlayerStore,
	setLogLevel = Lyra.setLogLevel,
}
