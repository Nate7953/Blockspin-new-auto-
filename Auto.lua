-- Wall Maker Script for Delta
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local placeId = game.PlaceId

local wallColor = Color3.fromRGB(255, 0, 0) -- Red

-- Wall 1
local wall1_point1 = Vector3.new(-287.26, 250, 350)
local wall1_point2 = Vector3.new(-231.89, 265.07, 357.42)

local wall1_center = (wall1_point1 + wall1_point2) / 2
local wall1_size = Vector3.new(
    math.abs(wall1_point1.X - wall1_point2.X),
    math.abs(wall1_point1.Y - wall1_point2.Y),
    math.max(1, math.abs(wall1_point1.Z - wall1_point2.Z))
)

local wall1 = Instance.new("Part")
wall1.Size = wall1_size
wall1.Position = wall1_center
wall1.Anchored = true
wall1.Color = wallColor
wall1.Material = Enum.Material.Neon
wall1.CanCollide = false
wall1.Transparency = 0
wall1.Parent = workspace
task.wait(0.1)

-- Wall 2
local wall2_point1 = Vector3.new(-287.26, 250, 350)
local wall2_point2 = Vector3.new(-287.16, 265, 330.31)

local wall2_center = (wall2_point1 + wall2_point2) / 2
local wall2_size = Vector3.new(
    math.max(1, math.abs(wall2_point1.X -wall2_point2.X)),
    math.abs(wall2_point1.Y - wall2_point2.Y),
    math.abs(wall2_point1.Z - wall2_point2.Z)
)

local wall2 = Instance.new("Part")
wall2.Size = wall2_size
wall2.Position = wall2_center
wall2.Anchored = true
wall2.Color = wallColor
wall2.Material = Enum.Material.Neon
wall2.CanCollide = false
wall2.Transparency = 0
wall2.Parent = workspace
task.wait(0.1)

-- Function to teleport to a new server and auto-load scripts
local function rejoinNewServer()
    -- Queue the scripts to run when teleporting
    local queuedScript = [[
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xQuartyx/QuartyzScript/refs/heads/main/Block%20Spin/Default.lua"))();
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Nate7953/Blockspin-new-auto-/refs/heads/main/Auto.lua"))();
    ]]
    queue_on_teleport(queuedScript)

    -- Teleport to a new random server (not same one)
    TeleportService:TeleportAsync(placeId, {}, player)
end

-- Connect Touch
local function connectWallTouch(wall)
    wall.Touched:Connect(function(hit)
        if hit and hit.Parent == character then
            rejoinNewServer()
        end
    end)
end

connectWallTouch(wall1)
connectWallTouch(wall2)

