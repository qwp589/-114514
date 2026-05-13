重复task.wait()直到游戏载入() task.wait() 重复 game:IsLoaded()
重复task.wait()直到游戏:GetService(“玩家”)。本地播放器task.wait()直到游戏:GetService(“玩家”).本地播放器

当地的光线场=负荷线(游戏:http get(https://Sirius .'菜单/光线场'))()Rayfield = loadstring(游戏:HttpGet(https://sirius.menu/rayfield的))()

当地的窗口=光线场:创建窗口({ Window = ray field:创建窗口({
名称="撕咬之夜脚本","撕咬之夜脚本",
加载标题="加载中...","加载中...",
LoadingSubtitle ="脚本作者 小张张x "，"脚本作者 小张张x ",
配置保存= {
启用=真实的，真实的,
文件夹名=" RayfieldConfig "，" RayfieldConfig ",
文件名=“风雨配置”“风雨配置”
   },
不和= {
启用=假，错误的,
邀请=“noinvitelink”，“noinvitelink”，
RememberJoins = truetrue
   },
密钥系统=错误的，错误的,
按键设置= {
标题="密钥系统","密钥系统",
字幕= "输入密钥","输入密钥",
注意= "密钥: 114514","密钥: 114514",
文件名="钥匙"，"钥匙",
保存密钥=真实的,
只读=
字符="1234567890"
   }
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

-- ===== 主要功能标签页 =====
local MainTab = Window:CreateTab("主要功能", 4483362458)
local MainSection = MainTab:CreateSection("基础功能")

MainTab:CreateToggle({
   Name = "绕过反作弊",
   CurrentValue = false,
   Flag = "BypassAnticheat",
   Callback = function(Value)
      if Value then
         for _, obj in pairs(getgc(true)) do
            if type(obj) == "function" then
               local info = debug.getinfo(obj)
               if info and info.name == "IsInBypass" then
                  hookfunction(obj, function() return true end)
               end
            end
         end
         Rayfield:Notify({
            Title = "成功",
            Content = "反作弊已绕过",
            Duration = 6.5,
            Image = 4483362458
         })
      end
   end
})

MainTab:CreateToggle({
   Name = "自动挡门",
   CurrentValue = false,
   Flag = "AutoDoor",
   Callback = function(Value)
      autoDoorEnabled = Value
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
   end
})

MainTab:CreateToggle({
   Name = "穿墙",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      noclipEnabled = Value
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
   end
})

MainTab:CreateToggle({
   Name = "全亮",
   CurrentValue = false,
   Flag = "Fullbright",
   Callback = function(Value)
      fullbrightEnabled = Value
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
   end
})

MainTab:CreateButton({
   Name = "删除所有门",
   Callback = function()
      local gameMap = workspace.MAPS:FindFirstChild('GAME MAP')
      if gameMap then
         local doors = gameMap:FindFirstChild('Doors')
         if doors then
            doors:Destroy()
            Rayfield:Notify({
               Title = "成功",
               Content = "已删除所有门",
               Duration = 4.5,
               Image = 4483362458
            })
         end
      end
   end
})

-- ===== 体力标签页 =====
local StaminaTab = Window:CreateTab("体力系统", 4483362458)
local StaminaSection = StaminaTab:CreateSection("体力功能")

StaminaTab:CreateToggle({
   Name = "无限体力",
   CurrentValue = false,
   Flag = "InfiniteStamina",
   Callback = function(Value)
      infiniteStaminaEnabled = Value
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
   end
})

-- ===== 速度标签页 =====
local SpeedTab = Window:CreateTab("速度增强", 4483362458)
local SpeedSection = SpeedTab:CreateSection("移动速度")

SpeedTab:CreateToggle({
   Name = "冲刺加速",
   CurrentValue = false,
   Flag = "RunSpeed",
   Callback = function(Value)
      runSpeedEnabled = Value
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
   end
})

SpeedTab:CreateSlider({
   Name = "冲刺速度",
   Range = {16, 100},
   Increment = 1,
   Suffix = "速度",
   CurrentValue = 24,
   Flag = "RunSpeedValue",
   Callback = function(Value)
      runSpeedValue = Value
   end
})

SpeedTab:CreateToggle({
   Name = "行走加速",
   CurrentValue = false,
   Flag = "WalkSpeed",
   Callback = function(Value)
      walkSpeedEnabled = Value
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
   end
})

SpeedTab:CreateSlider({
   Name = "行走速度",
   Range = {16, 50},
   Increment = 1,
   Suffix = "速度",
   CurrentValue = 15,
   Flag = "WalkSpeedValue",
   Callback = function(Value)
      walkSpeedValue = Value
   end
})

-- ===== 战斗标签页 =====
local CombatTab = Window:CreateTab("战斗系统", 4483362458)
local CombatSection = CombatTab:CreateSection("战斗功能")

CombatTab:CreateToggle({
   Name = "自动修复",
   CurrentValue = false,
   Flag = "AutoRepair",
   Callback = function(Value)
      autoRepairEnabled = Value
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
   end
})

CombatTab:CreateSlider({
   Name = "修复延迟",
   Range = {0.1, 2},
   Increment = 0.1,
   Suffix = "秒",
   CurrentValue = 0.5,
   Flag = "AutoRepairDelay",
   Callback = function(Value)
      autoRepairDelay = Value
   end
})

CombatTab:CreateToggle({
   Name = "扩大击杀范围",
   CurrentValue = false,
   Flag = "Hitbox",
   Callback = function(Value)
      hitboxEnabled = Value
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
   end
})

CombatTab:CreateSlider({
   Name = "击杀范围",
   Range = {2, 50},
   Increment = 1,
   Suffix = "大小",
   CurrentValue = 15,
   Flag = "HitboxSize",
   Callback = function(Value)
      hitboxSize = Value
   end
})

CombatTab:CreateToggle({
   Name = "自动格挡",
   CurrentValue = false,
   Flag = "AutoBlock",
   Callback = function(Value)
      autoBlockEnabled = Value
      if autoBlockEnabled then
         Rayfield:Notify({
            Title = "已启用",
            Content = "自动格挡已打开",
            Duration = 4.5,
            Image = 4483362458
         })
      else
         Rayfield:Notify({
            Title = "已禁用",
            Content = "自动格挡已关闭",
            Duration = 4.5,
            Image = 4483362458
         })
      end
   end
})

CombatTab:CreateButton({
   Name = "击杀所有敌人",
   Callback = function()
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild('Humanoid')
            if humanoid then
               humanoid.Health = 0
            end
         end
      end
      Rayfield:Notify({
         Title = "成功",
         Content = "所有敌人已被击杀",
         Duration = 4.5,
         Image = 4483362458
      })
   end
})

-- ===== 其他功能标签页 =====
local OtherTab = Window:CreateTab("其他功能", 4483362458)
local OtherSection = OtherTab:CreateSection("杂项")

OtherTab:CreateButton({
   Name = "传送到安全平台",
   Callback = function()
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
         LocalPlayer.Character.HumanoidRootPart.CFrame = SafePlatform.CFrame + Vector3.new(0, 5, 0)
         Rayfield:Notify({
            Title = "成功",
            Content = "已传送到安全平台",
            Duration = 4.5,
            Image = 4483362458
         })
      end
   end
})

OtherTab:CreateButton({
   Name = "显示所有玩家",
   Callback = function()
      local playerList = "当前服务器玩家:\n"
      for _, player in pairs(Players:GetPlayers()) do
         playerList = playerList .. "• " .. player.Name .. "\n"
      end
      Rayfield:Notify({
         Title = "玩家列表",
         Content = playerList,
         Duration = 6.5,
         Image = 4483362458
      })
   end
})

OtherTab:CreateButton({
   Name = "删除脚本",
   Callback = function()
      if noclipConnection then noclipConnection:Disconnect() end
      if autoDoorConnection then autoDoorConnection:Disconnect() end
      if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
      if hitboxConnection then hitboxConnection:Disconnect() end
      if autoRepairThread then task.cancel(autoRepairThread) end
      if RunService:FindFirstChild('RunSpeedConnection') then RunService.RunSpeedConnection:Disconnect() end
      if RunService:FindFirstChild('WalkSpeedConnection') then RunService.WalkSpeedConnection:Disconnect() end
      SafePlatform:Destroy()
      Rayfield:Notify({
         Title = "已卸载",
         Content = "脚本已完全删除",
         Duration = 4.5,
         Image = 4483362458
      })
   end
})

-- ===== 自动清理 =====
Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        if noclipConnection then noclipConnection:Disconnect() end
        if autoDoorConnection then autoDoorConnection:Disconnect() end
        if infiniteStaminaConnection then infiniteStaminaConnection:Disconnect() end
        if hitboxConnection then hitboxConnection:Disconnect() end
        if autoRepairThread then task.cancel(autoRepairThread) end
    end
end)

Rayfield:Notify({
   Title = "成功加载",
   Content = "撕咬之夜脚本已加载完成！",
   Duration = 4.5,
   Image = 4483362458
})
