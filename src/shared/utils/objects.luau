type function NonNilable(ty: type)
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
		result[key] = fn(value :: VI, key)
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

return {
	map = map,
	filter = filter,
}
