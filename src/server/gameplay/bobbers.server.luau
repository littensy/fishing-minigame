local Players = game:GetService("Players")

local Charm = require("../../../modules/Charm")
local fishingStore = require("../../shared/stores/fishingStore")
local pools = require("../../shared/constants/pools")

type Fisher = fishingStore.Fisher

type BobberInstance = {
	Part: {
		Attachment: Attachment,
	} & Part,
	AlignOrientation: AlignOrientation,
} & Model

local bobberContainer = Instance.new("Folder")
bobberContainer.Name = "Bobbers"
bobberContainer.Parent = workspace

local function shootBobberFromCharacter(bobber: BobberInstance, character: Model, power: number)
	local direction = character:GetPivot() * CFrame.Angles(math.rad(60), 0, 0)
	local velocity = math.lerp(10, 50, power)

	bobber.Parent = bobberContainer
	bobber.Part.AssemblyLinearVelocity = direction.LookVector * velocity
	bobber.Part:SetNetworkOwner(Players:GetPlayerFromCharacter(character))
end

local function createBobber(character: Model): BobberInstance
	local bobber = Instance.new("Model")
	bobber.Name = "Bobber"

	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(0.5, 0.5, 0.5)
	part.CFrame = character:GetPivot() * CFrame.new(0, 0, -2)
	part.CustomPhysicalProperties = PhysicalProperties.new(1, 1, 0, 1, 1)
	part.Parent = bobber

	local attachment = Instance.new("Attachment")
	attachment.Name = "BobberAttachment"
	attachment.Parent = part

	local alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.Attachment0 = attachment
	alignOrientation.CFrame = character:GetPivot()
	alignOrientation.RigidityEnabled = true
	alignOrientation.Parent = part

	return bobber :: BobberInstance
end

Charm.observe(fishingStore.getFishers, function(fisher: Fisher, username: string)
	local player = Players:FindFirstChild(username) :: Player?
	local character = player and player.Character

	if not character then
		return
	end

	local bobber = createBobber(character)

	local isSubmerged = Charm.computed(function()
		return fishingStore.isLuring(username) or fishingStore.isReeling(username)
	end)

	local touched = bobber.Part.Touched:Connect(function(touching)
		if touching:HasTag("Water") then
			local poolId = pools.getPoolIdFromInstance(touching)
			if poolId then
				fishingStore.setLuringPool(username, poolId)
			end
		end
	end)

	Charm.effect(function()
		if isSubmerged() then
			bobber.Part.Anchored = true
			touched:Disconnect()
		end
	end)

	shootBobberFromCharacter(bobber, character, fisher.castPower)

	return function()
		bobber:Destroy()
	end
end)
