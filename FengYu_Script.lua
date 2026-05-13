repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

local FengYuUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/FengYu-X/FengYu-ui/refs/heads/main/UI.lua'))()

local Window = FengYuUI:CreateWindow({
    Subtitle = "脚本作者 风御 X | QQ:1926190957",
    Title = "撕咬之夜脚本",
    Keybind = Enum.KeyCode.RightControl,
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
local killAllEnabled = false
local autoBlockEnabled = false

local SafePlatform = Instance.new('Part')
SafePlatform.Name = 'SafePlatform'
SafePlatform.Size = Vector3.new(50, 2, 50)
SafePlatform.Position = Vector3.new(0, 1000, 0)
SafePlatform.Anchored = true
SafePlatform.CanCollide = true
SafePlatform.Material = Enum.Material.ForceField
SafePlatform.Color = Color3.fromRGB(0, 170, 255)
SafePlatform.Transparency = 0.3
SafePlatform.Parent = workspace

local MainTab = Window:Tab('[主要]', '84830962019412')
local MainSection = MainTab:Section('主要功能', { Y = '84830962019412', F = '84830962019412' }, true)

MainSection:Toggle('绕过反作弊', false, function(state)
    if state then
        for _, obj in pairs(getgc(true)) do
            if type(obj) == "function" then
                local info = debug.getinfo(obj)
                if info and info.name == "IsInBypass" then
                    hookfunction(obj, function() return true end)
                end
            end
        end
        Window:Notification('已打开', '', 'Success', 4)
    end
end)

MainSection:Toggle('自动挡门', false, function(state)
    autoDoorEnabled = state
    if autoDoorEnabled then
        if autoDoorConnection then autoDoorConnection:Disconnect() end
        autoDoorConnection = RunService.RenderStepped:Connect(function()
            local playerGui = LocalPlayer:WaitForChild('PlayerGui')
            local dot = playerGui:FindFirstChild('Dot')
            if dot and dot:IsA('ScreenGui') then
                local container = dot:FindFirstChild('Container')
                if container then
                    local frame = container:FindFirstChild('Frame')
                    if frame and frame:IsA('GuiObject') then
                        frame.AnchorPoint = Vector2.new(0.5, 0.5)
                        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
                    end
                end
            end
        end)
    else
        if autoDoorConnection then autoDoorConnection:Disconnect() end
    end
end)

MainSection:Toggle('穿墙', false, function(state)
    noclipEnabled = state
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
    else
        if noclipConnection then noclipConnection:Disconnect() end
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA('BasePart') then
                    part.CanCollide = true
                end
            end
        end
    end
end)

MainSection:Toggle('全亮', false, function(state)
    fullbrightEnabled = state
    if fullbrightEnabled then
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 0
        Lighting.FogEnd = 500
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end)

MainSection:Button('删除所有门', function()
    local gameMap = workspace.MAPS:FindFirstChild('GAME MAP')
    if gameMap then
        local doors = gameMap:FindFirstChild('Doors')
        if doors then
            doors:Destroy()
            Window:Notification('成功', '已删除所有门', 'Success', 3)
        end
    end
end)

-- ===== 体力标签页 =====
local StaminaTab = Window:Tab('[体力]', '84830962019412')
local StaminaSection = StaminaTab:Section('体力功能', { Y = '84830962019412', F = '84830962019412' }, true)

StaminaSection:Toggle('无限体力', false, function(state)
    infiniteStaminaEnabled = state
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
    else
        if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
    end
end)

-- ===== 速度标签页 =====
local SpeedTab = Window:Tab('[速度]', '84830962019412')
local SpeedSection = SpeedTab:Section('速度功能', { Y = '84830962019412', F = '84830962019412' }, true)

SpeedSection:Toggle('冲刺加速', false, function(state)
    runSpeedEnabled = state
    if runSpeedEnabled then
        if RunService:FindFirstChild('RunSpeedConnection') then
            RunService.RunSpeedConnection:Disconnect()
        end
        RunService.RunSpeedConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild('Humanoid')
                if humanoid then
                    humanoid.WalkSpeed = runSpeedValue
                end
            end
        end)
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
    end
end)

SpeedSection:Slider('冲刺速度', 16, 100, runSpeedValue, function(value)
    runSpeedValue = value
end)

SpeedSection:Toggle('行走加速', false, function(state)
    walkSpeedEnabled = state
    if walkSpeedEnabled then
        if RunService:FindFirstChild('WalkSpeedConnection') then
            RunService.WalkSpeedConnection:Disconnect()
        end
        RunService.WalkSpeedConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild('Humanoid')
                if humanoid then
                    humanoid.WalkSpeed = walkSpeedValue
                end
            end
        end)
    else
        if RunService:FindFirstChild('WalkSpeedConnection') then
            RunService.WalkSpeedConnection:Disconnect()
        end
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild('Humanoid')
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

SpeedSection:Slider('行走速度', 16, 50, walkSpeedValue, function(value)
    walkSpeedValue = value
end)

-- ===== 战斗标签页 =====
local CombatTab = Window:Tab('[战斗]', '84830962019412')
local CombatSection = CombatTab:Section('战斗功能', { Y = '84830962019412', F = '84830962019412' }, true)

CombatSection:Toggle('自动修复', false, function(state)
    autoRepairEnabled = state
    if autoRepairEnabled then
        if autoRepairThread then
            task.cancel(autoRepairThread)
        end
        autoRepairThread = task.spawn(function()
            while autoRepairEnabled do
                task.wait(autoRepairDelay)
                if LocalPlayer.Character then
                    local tool = LocalPlayer.Character:FindFirstChildOfClass('Tool')
                    if tool then
                        if tool:FindFirstChild('Durability') then
                            tool.Durability.Value = 100
                        end
                    end
                end
            end
        end)
    else
        if autoRepairThread then
            task.cancel(autoRepairThread)
        end
    end
end)

CombatSection:Slider('修复延迟', 0.1, 2, autoRepairDelay, function(value)
    autoRepairDelay = value
end)

CombatSection:Toggle('扩大击杀范围', false, function(state)
    hitboxEnabled = state
    if hitboxEnabled then
        if hitboxConnection then hitboxConnection:Disconnect() end
        hitboxConnection = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild('HumanoidRootPart')
                        if humanoidRootPart then
                            humanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        end
                    end
                end
            end
        end)
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
    end
end)

CombatSection:Slider('击杀范围', 2, 50, hitboxSize, function(value)
    hitboxSize = value
end)

CombatSection:Toggle('自动格挡', false, function(state)
    autoBlockEnabled = state
    if autoBlockEnabled then
        Window:Notification('已启用', '自动格挡已打开', 'Success', 3)
    else
        Window:Notification('已禁用', '自动格挡已关闭', 'Info', 3)
    end
end)

CombatSection:Button('击杀所有敌人', function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild('Humanoid')
            if humanoid then
                humanoid.Health = 0
            end
        end
    end
    Window:Notification('成功', '所有敌人已被击杀', 'Success', 3)
end)

-- ===== 其他标签页 =====
local OtherTab = Window:Tab('[其他]', '84830962019412')
local OtherSection = OtherTab:Section('其他功能', { Y = '84830962019412', F = '84830962019412' }, true)

OtherSection:Button('传送到安全平台', function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SafePlatform.CFrame + Vector3.new(0, 5, 0)
        Window:Notification('成功', '已传送到安全平台', 'Success', 3)
    end
end)

OtherSection:Button('显示所有玩家', function()
    local playerList = ""
    for _, player in pairs(Players:GetPlayers()) do
        playerList = playerList .. player.Name .. "\n"
    end
    Window:Notification('玩家列表', playerList, 'Info', 5)
end)

OtherSection:Button('删除脚本', function()
    if noclipConnection then noclipConnection:Disconnect() end
    if autoDoorConnection then autoDoorConnection:Disconnect() end
    if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
    if hitboxConnection then hitboxConnection:Disconnect() end
    if autoRepairThread then task.cancel(autoRepairThread) end
    if RunService:FindFirstChild('RunSpeedConnection') then RunService.RunSpeedConnection:Disconnect() end
    if RunService:FindFirstChild('WalkSpeedConnection') then RunService.WalkSpeedConnection:Disconnect() end
    SafePlatform:Destroy()
    Window:Notification('已卸载', '脚本已完全删除', 'Info', 3)
end)

-- ===== 清理脚本 =====
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        if noclipConnection then noclipConnection:Disconnect() end
        if autoDoorConnection then autoDoorConnection:Disconnect() end
        if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
        if hitboxConnection then hitboxConnection:Disconnect() end
        if autoRepairThread then task.cancel(autoRepairThread) end
    end
end)

Window:Notification('成功', '脚本已加载完成！', 'Success', 3)