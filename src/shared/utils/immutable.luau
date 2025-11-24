local function set<K, V>(object: { [K]: V }, key: K, value: V): { [K]: V }
	if object[key] == value then
		return object
	end
	object = table.clone(object)
	object[key] = value
	return object
end

local function delete<K, V>(object: { [K]: V }, key: K): { [K]: V }
	if object[key] == nil then
		return object
	end
	object = table.clone(object)
	object[key] = nil
	return object
end

local function map<K, VI, VO>(object: { [K]: VI }, fn: (VI, K) -> VO): { [K]: VO }
	local result: { [K]: VO } = {}
	for key, value in object do
		result[key] = fn(value, key)
	end
	return result
end

return {
	set = set,
	delete = delete,
	map = map,
}
