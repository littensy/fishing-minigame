export type FishInfo = {
	name: string,
	description: string,
	weight: number,
	valuePerPound: number,
	resilience: number,
	progressSpeed: number,
}

export type Fish = {
	fishId: string,
	weightMultiplier: number,
	mutations: { [string]: boolean },
}

return {}
