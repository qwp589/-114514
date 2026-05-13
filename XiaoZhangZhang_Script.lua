repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local noclipEnabled = false
local noclipConnection = nil
local fullbrightEnabled = false
local autoDoorEnabled = false
local autoDoorConnection = nil
local infiniteStaminaEnabled = false
local infiniteStaminaConnection = nil
local runSpeedEnabled = false
local walkSpeedEnabled = false
local runSpeedValue = 24
local walkSpeedValue = 15
local autoRepairEnabled = false
local autoRepairDelay = 0.5
local autoRepairThread = nil
local hitboxEnabled = false
local hitboxSize = 15
local hitboxConnection = nil
local autoBlockEnabled = false

-- 创建简单GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XiaoZhangZhangScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 标题框
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 300, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 10)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "小张张脚本"
TitleLabel.Parent = ScreenGui

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "Subtitle"
SubtitleLabel.Size = UDim2.new(0, 300, 0, 20)
SubtitleLabel.Position = UDim2.new(0, 10, 0, 50)
SubtitleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SubtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
SubtitleLabel.TextSize = 12
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.Text = "制作者: 小张张"
SubtitleLabel.Parent = ScreenGui

-- 按钮函数
local function CreateButton(name, position, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(0, 140, 0, 30)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.Gotham
    Button.Text = name
    Button.Parent = ScreenGui
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- 主要功能
local y = 80
CreateButton("穿墙", UDim2.new(0, 10, 0, y), function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA('BasePart') then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("✓ 穿墙已启用")
    else
        if noclipConnection then noclipConnection:Disconnect() end
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA('BasePart') then
                    part.CanCollide = true
                end
            end
        end
        print("✗ 穿墙已禁用")
    end
end)

y = y + 40
CreateButton("全亮", UDim2.new(0, 10, 0, y), function()
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        print("✓ 全亮已启用")
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 0
        Lighting.FogEnd = 500
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        print("✗ 全亮已禁用")
    end
end)

y = y + 40
CreateButton("无限体力", UDim2.new(0, 10, 0, y), function()
    infiniteStaminaEnabled = not infiniteStaminaEnabled
    if infiniteStaminaEnabled then
        if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
        infiniteStaminaConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild('Humanoid')
                if humanoid then
                    pcall(function()
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                        if humanoid:FindFirstChild('Stamina') then
                            humanoid.Stamina.Value = 100
                        end
                    end)
                end
            end
        end)
        print("✓ 无限体力已启用")
    else
        if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
        print("✗ 无限体力已禁用")
    end
end)

y = y + 40
CreateButton("冲刺加速", UDim2.new(0, 10, 0, y), function()
    runSpeedEnabled = not runSpeedEnabled
    if runSpeedEnabled then
        if RunService:FindFirstChild('RunSpeedConnection') then
            RunService.RunSpeedConnection:Disconnect()
        end
        RunService.RunSpeedConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild('Humanoid')
                if humanoid then
                    humanoid.WalkSpeed = 50
                end
            end
        end)
        print("✓ 冲刺加速已启用 (50)")
    else
        if RunService:FindFirstChild('RunSpeedConnection') then
            RunService.RunSpeedConnection:Disconnect()
        end
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild('Humanoid')
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        print("✗ 冲刺加速已禁用")
    end
end)

y = y + 40
CreateButton("扩大范围", UDim2.new(0, 10, 0, y), function()
    hitboxEnabled = not hitboxEnabled
    if hitboxEnabled then
        if hitboxConnection then hitboxConnection:Disconnect() end
        hitboxConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild('HumanoidRootPart')
                        if humanoidRootPart then
                            humanoidRootPart.Size = Vector3.new(30, 30, 30)
                        end
                    end
                end
            end
        end)
        print("✓ 扩大范围已启用")
    else
        if hitboxConnection then hitboxConnection:Disconnect() end
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local humanoidRootPart = player.Character:FindFirstChild('HumanoidRootPart')
                if humanoidRootPart then
                    humanoidRootPart.Size = Vector3.new(2, 2, 1)
                end
            end
        end
        print("✗ 扩大范围已禁用")
    end
end)

y = y + 40
CreateButton("击杀所有敌人", UDim2.new(0, 10, 0, y), function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild('Humanoid')
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
    print("✓ 所有敌人已被击杀")
end)

y = y + 40
CreateButton("传送安全", UDim2.new(0, 10, 0, y), function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0)
        print("✓ 已传送到安全位置")
    end
end)

y = y + 40
CreateButton("删除脚本", UDim2.new(0, 10, 0, y), function()
    if noclipConnection then noclipConnection:Disconnect() end
    if autoDoorConnection then autoDoorConnection:Disconnect() end
    if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
    if hitboxConnection then hitboxConnection:Disconnect() end
    if autoRepairThread then task.cancel(autoRepairThread) end
    if RunService:FindFirstChild('RunSpeedConnection') then RunService.RunSpeedConnection:Disconnect() end
    ScreenGui:Destroy()
    print("✓ 脚本已删除")
end)

print("小张张脚本已加载完成！按下 RightControl 隐藏/显示界面")

-- 隐藏/显示快捷键
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Visible = not ScreenGui.Visible
    end
end)

-- 清理
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        if noclipConnection then noclipConnection:Disconnect() end
        if autoDoorConnection then autoDoorConnection:Disconnect() end
        if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
        if hitboxConnection then hitboxConnection:Disconnect() end
    end
end)