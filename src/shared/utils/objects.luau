type function NonNilable(ty: type): type
	if not ty:is("union") then
		return ty
	end
	local union = nil
	for _, member in ty:components() do
		if not member:is("nil") then
			union = if union then types.unionof(union, member) else member
		end
	end
	return union or ty
end

local function map<K, VI, VO>(object: { [K]: VI }, fn: (NonNilable<VI>, K) -> VO): { [K]: NonNilable<VO> }
	local result: { [K]: VO } = {}
	for key, value in object do
		result[key] = fn(value, key)
	end
	return result
end

local function filter<K, V>(object: { [K]: V }, predicate: (NonNilable<V>, K) -> boolean): { [K]: V }
	local result: { [K]: V } = {}
	for key, value in object do
		if predicate(value, key) then
			result[key] = value
		end
	end
	return result
end

local function keys<K>(object: { [K]: any }): { K }
	local result: { K } = {}
	for key in object do
		table.insert(result, key)
	end
	return result
end

local function reconcile<T>(target: T & {}, source: T & {})
	for key in target :: any do
		if source[key] == nil then
			target[key] = nil
		end
	end

	for key, sourceValue in source :: any do
		target[key] = sourceValue
	end
end

return {
	map = map,
	filter = filter,
	keys = keys,
	reconcile = reconcile,
}
