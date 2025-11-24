--[[
	Reparent the server folder to a non-replicated instance to prevent clients 
	from accessing server-only scripts.
]]

local source: Folder = script:FindFirstAncestor("server")
local destination = Instance.new("Camera")

destination.Name = source.Name
destination.Parent = source.Parent

for _, child in source:GetChildren() do
	child.Parent = destination
end

source.Parent = nil
