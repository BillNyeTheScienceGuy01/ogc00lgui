--[[ 
  FULL c00lGUI v1.0 
  By Greg (your personal code savage) 
  Inject this LocalScript via KRNL or any executor in-game 
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- === Setup Main ScreenGui ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "c00lGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- === Main Window Frame ===
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- === Title Bar ===
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1,0,0,30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1,-10,1,0)
TitleLabel.Position = UDim2.new(0,5,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "c00lGUI v1.0 - Powered by Greg"
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- === Container for buttons ===
local ButtonsFrame = Instance.new("ScrollingFrame")
ButtonsFrame.Name = "ButtonsFrame"
ButtonsFrame.Size = UDim2.new(1, 0, 1, -30)
ButtonsFrame.Position = UDim2.new(0, 0, 0, 30)
ButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonsFrame.ScrollBarThickness = 6
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Utility: Create button factory
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = text
    btn.Parent = ButtonsFrame

    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            warn("c00lGUI button error:", err)
        end
    end)

    return btn
end

-- === Features ===

-- 1) Toss All Players (launch into space)
createButton("Toss All Players", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Velocity = Vector3.new(0, 120, 0)
        end
    end
end)

-- 2) Spam RemoteEvents in ReplicatedStorage (fire spam)
createButton("Spam RemoteEvents", function()
    local remotesFolder = ReplicatedStorage:FindFirstChildWhichIsA("Folder") or ReplicatedStorage
    for _, remote in pairs(remotesFolder:GetChildren()) do
        if remote:IsA("RemoteEvent") then
            spawn(function()
                while true do
                    remote:FireServer("spam")
                    wait(0.1)
                end
            end)
        end
    end
end)

-- 3) Give Ban Gun (tool + sound effect)
createButton("Give Ban Gun", function()
    local Tool = Instance.new("Tool")
    Tool.Name = "Ban Gun"
    Tool.RequiresHandle = false
    Tool.CanBeDropped = false

    -- Sound hawk tuah
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1843530880" -- Hawk Tuah sound effect ID
    sound.Volume = 1
    sound.Parent = Tool

    Tool.Activated:Connect(function()
        sound:Play()
        -- Here you can add ban logic or trolling effect
        print("Ban Gun fired! Pew pew!")
    end)

    Tool.Parent = LocalPlayer.Backpack
end)

-- 4) Spam Chat "c00lGUI rules!"
createButton("Spam Chat", function()
    local chatEvent = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
    spawn(function()
        while true do
            chatEvent:FireServer("c00lGUI rules!", "All")
            wait(0.4)
        end
    end)
end)

-- 5) Fake System Message (popup overlay)
createButton("Fake Ban Message", function()
    local fakeMsg = Instance.new("TextLabel")
    fakeMsg.Size = UDim2.new(0.5, 0, 0, 80)
    fakeMsg.Position = UDim2.new(0.25, 0, 0.3, 0)
    fakeMsg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fakeMsg.TextColor3 = Color3.new(1, 1, 1)
    fakeMsg.TextScaled = true
    fakeMsg.Font = Enum.Font.GothamBlack
    fakeMsg.Text = "You have been banned from this game."
    fakeMsg.BorderSizePixel = 2
    fakeMsg.ZIndex = 1000
    fakeMsg.Parent = ScreenGui

    wait(3)
    fakeMsg:Destroy()
end)

-- 6) Jumpscare flicker effect on MainFrame
createButton("Toggle Jumpscare Flicker", function()
    local flickerOn = false
    local flickerConn

    if flickerConn then
        flickerConn:Disconnect()
        flickerConn = nil
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        return
    end

    flickerConn = RunService.Heartbeat:Connect(function()
        if flickerOn then
            MainFrame.BackgroundColor3 = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        else
            MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        end
        flickerOn = not flickerOn
    end)
end)

-- You can keep adding more buttons and features here, all modular and clean.

print("[c00lGUI] Loaded and ready to wreck")

