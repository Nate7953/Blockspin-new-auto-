local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local teleporting = false
local originalPos = nil
local sittingSeat = nil
local bikeBasePart = nil
local lockBlock = nil

-- Random nearby air position
local function getRandomNearbyPosition(center)
	local radius = 20
	local height = 10
	local offset = Vector3.new(
		math.random(-radius, radius),
		height + math.random(2, 5),
		math.random(-radius, radius)
	)
	return center + offset
end

-- Find seat and detect base of bike
local function tryDismountAndGetBikeBase()
	for _, part in pairs(Workspace:GetDescendants()) do
		if (part:IsA("Seat") or part:IsA("VehicleSeat")) and part.Occupant == humanoid then
			sittingSeat = part
			part:Sit(nil)
			bikeBasePart = part.Parent and part.Parent:FindFirstChildWhichIsA("BasePart")
			break
		end
	end
end

-- Re-seat player if possible
local function tryReseat()
	if sittingSeat and sittingSeat.Parent then
		task.delay(0.2, function()
			sittingSeat:Sit(humanoid)
		end)
	end
end

-- Place invisible anchor block under bike
local function placeLockBlock()
	if bikeBasePart then
		lockBlock = Instance.new("Part")
		lockBlock.Anchored = true
		lockBlock.CanCollide = true
		lockBlock.Size = Vector3.new(6, 2, 6)
		lockBlock.Position = bikeBasePart.Position - Vector3.new(0, bikeBasePart.Size.Y / 2 + 1, 0)
		lockBlock.Transparency = 1
		lockBlock.Name = "BikeLockBlock"
		lockBlock.Parent = Workspace
	end
end

-- Remove the anchor block
local function removeLockBlock()
	if lockBlock and lockBlock.Parent then
		lockBlock:Destroy()
		lockBlock = nil
	end
end

-- Teleport + Lock logic
local function teleportAwayLoop()
	RunService.Heartbeat:Connect(function()
		if humanoid.Health <= 16 and not teleporting then
			teleporting = true
			originalPos = hrp.Position
			tryDismountAndGetBikeBase()
			placeLockBlock()
			print("Escaping, bike locked to ground.")

			while humanoid.Health <= 32 and humanoid.Health > 0 do
				hrp.CFrame = CFrame.new(getRandomNearbyPosition(originalPos))
				task.wait(0.3)
			end

			if humanoid.Health > 0 then
				hrp.CFrame = CFrame.new(originalPos + Vector3.new(0, 3, 0))
				tryReseat()
				removeLockBlock()
				print("Returned and bike unlocked.")
			end

			teleporting = false
			sittingSeat = nil
			bikeBasePart = nil
		end
	end)
end

teleportAwayLoop()
