-- LocalScript (dán vào StarterPlayerScripts hoặc StarterGui)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CONFIG
local UI_TITLE = "VIET NAM"
local DEFAULT_SPEED = 16
local SPEED_STEP = 8

-- state
local state = {
    fast = false,
    invisible = false,
    noclip = false,
    speed = DEFAULT_SPEED
}

-- create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniToolGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 320, 0, 380)
mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.Active = true

-- shadow / rounding (simple)
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- top bar for dragging & title
local topBar = Instance.new("Frame", mainFrame)
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 34)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = UI_TITLE
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

-- close button
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 28, 0, 24)
closeBtn.Position = UDim2.new(1, -36, 0, 5)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 75)
closeBtn.BorderSizePixel = 0
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
local ccorner = Instance.new("UICorner", closeBtn)
ccorner.CornerRadius = UDim.new(0,6)

-- minimize button
local minBtn = Instance.new("TextButton", topBar)
minBtn.Name = "Min"
minBtn.Size = UDim2.new(0, 28, 0, 24)
minBtn.Position = UDim2.new(1, -72, 0, 5)
minBtn.Text = "—"
minBtn.Font = Enum.Font.Gotham
minBtn.TextSize = 18
minBtn.BackgroundColor3 = Color3.fromRGB(120,120,130)
minBtn.BorderSizePixel = 0
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
local mcorner = Instance.new("UICorner", minBtn)
mcorner.CornerRadius = UDim.new(0,6)

-- content area (below topbar)
local content = Instance.new("Frame", mainFrame)
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -34)
content.Position = UDim2.new(0, 0, 0, 34)
content.BackgroundTransparency = 1

-- decorative header bar
local deco = Instance.new("Frame", content)
deco.Name = "Deco"
deco.Size = UDim2.new(1, -20, 0, 60)
deco.Position = UDim2.new(0, 10, 0, 6)
deco.BackgroundColor3 = Color3.fromRGB(45, 65, 150)
deco.BorderSizePixel = 0
local dcorner = Instance.new("UICorner", deco)
dcorner.CornerRadius = UDim.new(0,10)
local decoLabel = Instance.new("TextLabel", deco)
decoLabel.Size = UDim2.new(1, -12, 1, 0)
decoLabel.Position = UDim2.new(0, 8, 0, 0)
decoLabel.Text = "Player Tools"
decoLabel.TextColor3 = Color3.fromRGB(255,255,255)
decoLabel.Font = Enum.Font.GothamSemibold
decoLabel.TextSize = 18
decoLabel.BackgroundTransparency = 1

-- Scrolling list for buttons
local scroll = Instance.new("ScrollingFrame", content)
scroll.Name = "Scroll"
scroll.Size = UDim2.new(1, -20, 1, -86)
scroll.Position = UDim2.new(0, 10, 0, 74)
scroll.CanvasSize = UDim2.new(0, 0, 1, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 8
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- helper to create a row button
local function makeRow(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 44)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0,8)
    return btn
end

-- status label helper
local function statusLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0, 110, 1, 0)
    lbl.Position = UDim2.new(1, -120, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.fromRGB(200,200,200)
    lbl.TextXAlignment = Enum.TextXAlignment.Right
    return lbl
end

-- Fast toggle
local fastBtn = makeRow("🏃 Chạy nhanh: TẮT")
fastBtn.Name = "FastBtn"
fastBtn.LayoutOrder = 1
fastBtn.Parent = scroll
local fastStatus = statusLabel(fastBtn, "16")

-- Invisible toggle
local invisBtn = makeRow("🕵️ Tàng hình: TẮT")
invisBtn.Name = "InvisBtn"
invisBtn.LayoutOrder = 2
invisBtn.Parent = scroll
local invisStatus = statusLabel(invisBtn, "OFF")

-- Noclip toggle
local noclipBtn = makeRow("🔓 Xuyên tường: TẮT")
noclipBtn.Name = "NoclipBtn"
noclipBtn.LayoutOrder = 3
noclipBtn.Parent = scroll
local noclipStatus = statusLabel(noclipBtn, "OFF")

-- Speed adjust (increase/decrease)
local speedRow = Instance.new("Frame", scroll)
speedRow.Size = UDim2.new(1, -24, 0, 44)
speedRow.BackgroundTransparency = 1
speedRow.LayoutOrder = 4
local minus = Instance.new("TextButton", speedRow)
minus.Size = UDim2.new(0,44,1,0)
minus.Position = UDim2.new(0,0,0,0)
minus.Text = "−"
minus.Font = Enum.Font.GothamBold
minus.TextSize = 22
minus.BackgroundColor3 = Color3.fromRGB(90,90,100)
minus.BorderSizePixel = 0
local spLabel = Instance.new("TextLabel", speedRow)
spLabel.Size = UDim2.new(1, -88, 1, 0)
spLabel.Position = UDim2.new(0,48,0,0)
spLabel.BackgroundTransparency = 1
spLabel.Text = "Tốc độ: "..tostring(state.speed)
spLabel.Font = Enum.Font.Gotham
spLabel.TextSize = 16
spLabel.TextColor3 = Color3.fromRGB(230,230,230)
spLabel.TextXAlignment = Enum.TextXAlignment.Center
local plus = Instance.new("TextButton", speedRow)
plus.Size = UDim2.new(0,44,1,0)
plus.Position = UDim2.new(1, -44, 0, 0)
plus.Text = "+"
plus.Font = Enum.Font.GothamBold
plus.TextSize = 22
plus.BackgroundColor3 = Color3.fromRGB(90,90,100)
plus.BorderSizePixel = 0

-- Helpers for character changes
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-- apply speed
local function applySpeed()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = state.fast and (state.speed) or DEFAULT_SPEED
        fastStatus.Text = tostring(humanoid.WalkSpeed)
        fastBtn.Text = "🏃 Chạy nhanh: "..(state.fast and "BẬT" or "TẮT")
    end
end

-- apply invisibility
local function setInvisible(enabled)
    local char = getCharacter()
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            if enabled then
                obj.LocalTransparencyModifier = 1 -- prefer LocalTransparencyModifier so server changes less likely to show
            else
                obj.LocalTransparencyModifier = 0
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if enabled then
                obj.Transparency = 1
            else
                obj.Transparency = 0
            end
        end
    end
    invisStatus.Text = enabled and "ON" or "OFF"
    invisBtn.Text = "🕵️ Tàng hình: "..(enabled and "BẬT" or "TẮT")
end

-- noclip loop
local noclipConnection
local function startNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end
local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    -- restore CanCollide only for character parts (server may also override)
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- UI interactions
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
    if content.Visible == false then
        content.Visible = true
        mainFrame.Size = UDim2.new(0, 320, 0, 380)
    else
        content.Visible = false
        mainFrame.Size = UDim2.new(0, 320, 0, 34)
    end
end)

-- drag logic
do
    local dragging = false
    local dragStart = nil
    local startPos = nil

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            -- handled in RenderStepped to be smooth
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and UserInputService:GetMouseLocation() then
            local mpos = UserInputService:GetMouseLocation()
            -- convert to scale position (approx)
            local offset = mpos - dragStart
            -- convert offset pixels to UDim2
            local newX = startPos.X.Offset + offset.X
            local newY = startPos.Y.Offset + offset.Y
            -- clamp inside screen roughly
            newX = math.clamp(newX, 0, math.max(0, workspace.CurrentCamera.ViewportSize.X - mainFrame.AbsoluteSize.X))
            newY = math.clamp(newY, 0, math.max(0, workspace.CurrentCamera.ViewportSize.Y - mainFrame.AbsoluteSize.Y))
            mainFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
end

-- button callbacks
fastBtn.MouseButton1Click:Connect(function()
    state.fast = not state.fast
    applySpeed()
end)

plus.MouseButton1Click:Connect(function()
    state.speed = math.max(8, state.speed + SPEED_STEP)
    spLabel.Text = "Tốc độ: "..tostring(state.speed)
    applySpeed()
end)
minus.MouseButton1Click:Connect(function()
    state.speed = math.max(8, state.speed - SPEED_STEP)
    spLabel.Text = "Tốc độ: "..tostring(state.speed)
    applySpeed()
end)

invisBtn.MouseButton1Click:Connect(function()
    state.invisible = not state.invisible
    setInvisible(state.invisible)
end)

noclipBtn.MouseButton1Click:Connect(function()
    state.noclip = not state.noclip
    if state.noclip then
        startNoclip()
    else
        stopNoclip()
    end
    noclipStatus.Text = state.noclip and "ON" or "OFF"
    noclipBtn.Text = "🔓 Xuyên tường: "..(state.noclip and "BẬT" or "TẮT")
end)

-- ensure features re-applied on character spawn
player.CharacterAdded:Connect(function(char)
    wait(0.1)
    -- apply current state after spawn
    applySpeed()
    setInvisible(state.invisible)
    if state.noclip then
        startNoclip()
    end
end)

-- initial apply
if player.Character then
    applySpeed()
    setInvisible(state.invisible)
    if state.noclip then startNoclip() end
end

-- small UX: update canvas size based on content
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
end)

-- friendly hint text
local hint = Instance.new("TextLabel", content)
hint.Size = UDim2.new(1, -20, 0, 20)
hint.Position = UDim2.new(0, 10, 1, -26)
hint.BackgroundTransparency = 1
hint.Font = Enum.Font.Gotham
hint.TextSize = 12
hint.TextColor3 = Color3.fromRGB(170,170,170)
hint.Text = "D.AN"
hint.TextXAlignment = Enum.TextXAlignment.Left
