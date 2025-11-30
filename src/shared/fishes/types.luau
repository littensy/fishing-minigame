export type FishInfo = {
	read name: string,
	read description: string,
	read weight: number,
	read valuePerPound: number,
	read resilience: number,
	read progressSpeed: number,
}

export type Fish = {
	read fishId: string,
	read weightMultiplier: number,
	read mutations: { [string]: boolean },
}

return {}
