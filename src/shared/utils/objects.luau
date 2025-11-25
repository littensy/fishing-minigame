local function map<K, VI, VO>(object: { [K]: VI? }, fn: (VI, K) -> VO): { [K]: VO }
	local result: { [K]: VO } = {}
	for key, value in object do
		result[key] = fn(value :: VI, key)
	end
	return result
end

local function filter<K, V>(object: { [K]: V? }, predicate: (V, K) -> boolean): { [K]: V }
	local result: { [K]: V } = {}
	for key, value in object do
		if predicate(value :: V, key) then
			result[key] = value :: V
		end
	end
	return result
end

return {
	map = map,
	filter = filter,
}
