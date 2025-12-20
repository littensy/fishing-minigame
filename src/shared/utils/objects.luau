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

type function PartialImpl(ty: type): type
	local result = types.copy(ty)
	for key, property in ty:properties() do
		if property.read then
			result:setreadproperty(key, types.unionof(property.read, types.singleton(nil)))
		end
		if property.write then
			result:setwriteproperty(key, types.unionof(property.write, types.singleton(nil)))
		end
	end
	return result
end

-- This intersection allows nilable properties to be omitted instead of
-- explicitly set to nil
type Partial<T> = PartialImpl<T> & { [any]: nil }

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

local function set<T, K>(object: T & {}, key: K & keyof<T>, value: index<T, K>): T
	if object[key] ~= value then
		object = table.clone(object)
		object[key] = value
	end
	return object
end

local function delete<T>(object: T & {}, key: keyof<T>): T
	if object[key] ~= nil then
		object = table.clone(object)
		object[key] = nil
	end
	return object
end

local function update<T, K>(object: T & {}, key: K & keyof<T>, fn: (NonNilable<index<T, K>>) -> index<T, K>?): T
	local value: unknown = object[key]
	if value ~= nil then
		local newValue = fn(value :: K)
		if newValue ~= value then
			object = table.clone(object)
			object[key] = newValue
		end
	end
	return object
end

local function join<T>(object: T & {}, source: Partial<T>?): T
	if not source then
		return object
	end
	local result = object
	for key, value in source :: { [any]: any } do
		if result[key] ~= value then
			if result == object then
				result = table.clone(object) :: never
			end
			result[key] = value
		end
	end
	return result
end

return {
	map = map,
	filter = filter,
	keys = keys,
	set = set,
	delete = delete,
	update = update,
	join = join,
}
