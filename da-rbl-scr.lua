-- GUI Speed & Invisibility Script for KRNL

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedInvisGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Speed & Invisibility"
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = frame

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 200, 0, 50)
speedButton.Position = UDim2.new(0, 25, 0, 60)
speedButton.Text = "Speed Boost"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Parent = frame

-- Invisibility Button
local invisButton = Instance.new("TextButton")
invisButton.Size = UDim2.new(0, 200, 0, 50)
invisButton.Position = UDim2.new(0, 25, 0, 120)
invisButton.Text = "Invisibility"
invisButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
invisButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisButton.Parent = frame

-- Reset Button
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0, 200, 0, 50)
resetButton.Position = UDim2.new(0, 25, 0, 180)
resetButton.Text = "Reset Invisibility"
resetButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.Parent = frame

-- Speed Function
local function boostSpeed()
    if humanoid and humanoid.Parent then
        humanoid.WalkSpeed = 100
    end
end

-- Invisibility Function
local function makeInvisible()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end

-- Reset Invisibility
local function resetVisibility()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
        end
    end
end

-- Connect buttons
speedButton.MouseButton1Click:Connect(boostSpeed)
invisButton.MouseButton1Click:Connect(makeInvisible)
resetButton.MouseButton1Click:Connect(resetVisibility)
