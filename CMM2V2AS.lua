local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Function to fetch keys from a URL
local function fetchKeys(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then
        warn("Failed to fetch keys from: " .. url)
        return {}
    end
    local keys = {}
    for key in response:gmatch("[^\r\n]+") do
        table.insert(keys, key)
    end
    return keys
end

-- Fetch keys from both sources
local validKeys = {}
local githubKeys = fetchKeys("https://raw.githubusercontent.com/THEBWARE/-/refs/heads/main/johncenaop.txt")
local pastebinKeys = fetchKeys("https://pastebin.com/raw/UEuXVrir")

-- Combine keys from both sources
for _, key in ipairs(githubKeys) do
    table.insert(validKeys, key)
end
for _, key in ipairs(pastebinKeys) do
    table.insert(validKeys, key)
end

-- Create Window with Key System
local Window = Rayfield:CreateWindow({
    Name = "Cevor MM2 V5",
    Icon = 0,
    LoadingTitle = "Cevor MM2 V7",
    LoadingSubtitle = "by ScripterBob",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CevorMM2Config",
        FileName = "CevorMM2Config"
    },
    Discord = {
        Enabled = true,
        Invite = "https://discord.gg/PpYn4v5vR2",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Cevor MM2 V5",
        Subtitle = "Key System",
        Note = "https://thebware.github.io/-/key.html",
        FileName = "CevorMM2Key",
        SaveKey = false,
        GrabKeyFromSite = false, -- Disable grabbing key from site (we handle it manually)
        Key = validKeys -- Use the combined keys
    }
})

-- Notify User
Rayfield:Notify({
    Title = "Cevor MM2 V4",
    Content = "Script loaded successfully!",
    Duration = 6.5,
    Image = nil,
})

-- Main Tab
local MainTab = Window:CreateTab("🏠 Main", nil)
local Section = MainTab:CreateSection("Main Features")

-- Notify User
Rayfield:Notify({
   Title = "Loading Cevor MM2 V4",
   Content = "Loaded Successfully",
   Duration = 6.5,
   Image = nil,
})

-- Config Management Dropdown
local ConfigDropdown = MainTab:CreateDropdown({
   Name = "Config Management",
   Options = {"Default"},
   CurrentOption = {"Default"},
   MultipleOptions = false,
   Flag = "ConfigDropdown",
   Callback = function(Options)
      Rayfield:LoadConfiguration(Options[1])
   end,
})

-- Create New Config Button
local CreateConfigButton = MainTab:CreateButton({
   Name = "Create New Config",
   Callback = function()
      local configName = tostring(math.random(1, 10000))
      table.insert(ConfigDropdown.Options, configName)
      ConfigDropdown:Refresh(ConfigDropdown.Options)
      Rayfield:SaveConfiguration(configName)
      Rayfield:Notify({
         Title = "Config Created",
         Content = "New config created: " .. configName,
         Duration = 6.5,
         Image = nil,
      })
   end,
})

-- Delete Config Button
local DeleteConfigButton = MainTab:CreateButton({
   Name = "Delete Config",
   Callback = function()
      local selectedConfig = ConfigDropdown.CurrentOption[1]
      if selectedConfig == "Default" then
         Rayfield:Notify({
            Title = "Error",
            Content = "Cannot delete the default config.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      table.remove(ConfigDropdown.Options, table.find(ConfigDropdown.Options, selectedConfig))
      ConfigDropdown:Refresh(ConfigDropdown.Options)
      Rayfield:DeleteConfiguration(selectedConfig)
      Rayfield:Notify({
         Title = "Config Deleted",
         Content = "Config deleted: " .. selectedConfig,
         Duration = 6.5,
         Image = nil,
      })
   end,
})

-- AutoLoad Config Toggle
local AutoLoadConfigToggle = MainTab:CreateToggle({
   Name = "AutoLoad Config",
   CurrentValue = false,
   Flag = "AutoLoadConfig",
   Callback = function(Value)
      if Value then
         local selectedConfig = ConfigDropdown.CurrentOption[1]
         Rayfield:SaveConfiguration("AutoLoadConfig", selectedConfig)
         Rayfield:Notify({
            Title = "AutoLoad Config",
            Content = "Config set to auto-load: " .. selectedConfig,
            Duration = 6.5,
            Image = nil,
         })
      else
         Rayfield:DeleteConfiguration("AutoLoadConfig")
         Rayfield:Notify({
            Title = "AutoLoad Config",
            Content = "Auto-load config disabled.",
            Duration = 6.5,
            Image = nil,
         })
      end
   end,
})

-- Load AutoLoad Config on Script Start
local function loadAutoLoadConfig()
   local autoLoadConfig = Rayfield:LoadConfiguration("AutoLoadConfig")
   if autoLoadConfig then
      Rayfield:LoadConfiguration(autoLoadConfig)
      Rayfield:Notify({
         Title = "AutoLoad Config",
         Content = "Loaded auto-load config: " .. autoLoadConfig,
         Duration = 6.5,
         Image = nil,
      })
   end
end

loadAutoLoadConfig()

-- Main Account Mode Toggle
local MainAccountModeToggle = MainTab:CreateToggle({
   Name = "Main Account Mode",
   CurrentValue = false,
   Flag = "MainAccountMode",
   Callback = function(Value)
      if Value then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "Risky features have been disabled to protect your account.",
            Duration = 6.5,
            Image = nil,
         })
      else
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "Risky features have been enabled.",
            Duration = 6.5,
            Image = nil,
         })
      end
   end,
})

-- Function to check if Main Account Mode is enabled
local function isMainAccountMode()
   return MainAccountModeToggle.CurrentValue
end

-- Unload Button
local UnloadButton = MainTab:CreateButton({
   Name = "Unload Script",
   Callback = function()
      Rayfield:Destroy()
      for _, v in pairs(game.CoreGui:GetChildren()) do
         if v.Name == "ScreenGui" then
            v:Destroy()
         end
      end
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
      for _, connection in pairs(getconnections(game:GetService("RunService").Stepped)) do
         connection:Disconnect()
      end
   end,
})

-- Kill All Button (Disabled in Main Account Mode)
local KillAllButton = MainTab:CreateButton({
   Name = "Kill All",
   Callback = function()
      if isMainAccountMode() then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "This feature is disabled in Main Account Mode.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      local teleportedPlayers = {}
      local function killAll()
         while true do
            wait(2)
            local players = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and not table.find(teleportedPlayers, player) then
                    table.insert(players, player)
                end
            end
            if #players > 0 then
                local randomPlayer = players[math.random(1, #players)]
                local character = randomPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character:MoveTo(character.HumanoidRootPart.Position)
                    table.insert(teleportedPlayers, randomPlayer)
                end
            else
                break
            end
         end
      end
      killAll()
   end,
})

-- ESP Button (Enabled in Main Account Mode)
local ESPButton = MainTab:CreateButton({
   Name = "ESP",
   Callback = function()
      local Players = game:GetService("Players")
      local function createHighlight(player)
         local character = player.Character
         if not character then return end
         local highlight = Instance.new("Highlight")
         highlight.Adornee = character
         highlight.FillColor = Color3.new(1, 0, 0)
         highlight.FillTransparency = 0.5
         highlight.OutlineTransparency = 0
         highlight.Parent = character
      end
      local function onCharacterAdded(character)
         local player = Players:GetPlayerFromCharacter(character)
         if player then
            createHighlight(player)
         end
      end
      local function refreshHighlights()
         for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
               for _, child in pairs(player.Character:GetChildren()) do
                  if child:IsA("Highlight") then
                     child:Destroy()
                  end
               end
               createHighlight(player)
            end
         end
      end
      Players.PlayerAdded:Connect(function(player)
         player.CharacterAdded:Connect(onCharacterAdded)
         if player.Character then
            createHighlight(player)
         end
      end)
      for _, player in pairs(Players:GetPlayers()) do
         if player.Character then
            createHighlight(player)
         end
         player.CharacterAdded:Connect(onCharacterAdded)
      end
      while true do
         refreshHighlights()
         print("Refreshed Cevor ESP")
         wait(1)
      end
   end,
})

-- Player Tab (Blocked in Main Account Mode)
local PlayerTab = Window:CreateTab("👤 Player", nil)
local PlayerSection = PlayerTab:CreateSection("Player Modifications")

-- Disable Players Tab if Main Account Mode is enabled
if isMainAccountMode() then
   PlayerTab:SetEnabled(false)
   Rayfield:Notify({
      Title = "Main Account Mode",
      Content = "Player modifications are disabled in Main Account Mode.",
      Duration = 6.5,
      Image = nil,
   })
end

-- Walk Speed Slider (Blocked in Main Account Mode)
local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      if isMainAccountMode() then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "This feature is disabled in Main Account Mode.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Jump Power Slider (Blocked in Main Account Mode)
local JumpPowerSlider = PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 200},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
      if isMainAccountMode() then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "This feature is disabled in Main Account Mode.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- Infinite Jump Toggle (Blocked in Main Account Mode)
local InfiniteJumpToggle = PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJump",
   Callback = function(Value)
      if isMainAccountMode() then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "This feature is disabled in Main Account Mode.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      if Value then
         game:GetService("UserInputService").JumpRequest:Connect(function()
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
         end)
      end
   end,
})

-- No Clip Toggle (Blocked in Main Account Mode)
local NoClipToggle = PlayerTab:CreateToggle({
   Name = "No Clip",
   CurrentValue = false,
   Flag = "NoClip",
   Callback = function(Value)
      if isMainAccountMode() then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "This feature is disabled in Main Account Mode.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      if Value then
         local noclipLoop
         noclipLoop = game:GetService("RunService").Stepped:Connect(function()
            if NoClipToggle.CurrentValue then
               for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                  if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                     part.CanCollide = false
                  end
               end
            else
               noclipLoop:Disconnect()
            end
         end)
      end
   end,
})

-- Anti-AFK
local AntiAFKButton = PlayerTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      local VirtualUser = game:GetService("VirtualUser")
      game.Players.LocalPlayer.Idled:Connect(function()
         VirtualUser:CaptureController()
         VirtualUser:ClickButton2(Vector2.new())
      end)
   end,
})

-- Teleport to Player Dropdown (Fixed)
local TeleportDropdown = PlayerTab:CreateDropdown({
   Name = "Teleport to Player",
   Options = {},
   CurrentOption = "Select Player",
   Flag = "TeleportDropdown",
   Callback = function(Option)
      local targetPlayer = game.Players:FindFirstChild(Option)
      if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
         game.Players.LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
      end
   end,
})

-- Update Teleport Dropdown
local function updateTeleportDropdown()
   TeleportDropdown.Options = {}
   for _, player in pairs(game.Players:GetPlayers()) do
      if player ~= game.Players.LocalPlayer then
         table.insert(TeleportDropdown.Options, player.Name)
      end
   end
end

updateTeleportDropdown()
game.Players.PlayerAdded:Connect(updateTeleportDropdown)
game.Players.PlayerRemoving:Connect(updateTeleportDropdown)

-- Fly GUI (Mobile Support, Disabled in Main Account Mode)
local FlyButton = PlayerTab:CreateButton({
   Name = "Fly GUI",
   Callback = function()
      if isMainAccountMode() then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "This feature is disabled in Main Account Mode.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      -- Fly Script
      local player = game.Players.LocalPlayer
      local flying = false
      local speed = 50 -- Default fly speed
      local torso = player.Character:FindFirstChild("HumanoidRootPart")
      local bg, bp

      -- Function to start flying
      local function startFlying()
         flying = true
         bg = Instance.new("BodyGyro", torso)
         bg.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
         bg.P = 10000
         bg.cframe = torso.CFrame

         bp = Instance.new("BodyPosition", torso)
         bp.maxForce = Vector3.new(math.huge, math.huge, math.huge)
         bp.position = torso.Position

         -- Fly movement
         local function fly()
            while flying and torso and bg and bp do
               wait()
               local direction = Vector3.new()
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                  direction = direction + workspace.CurrentCamera.CFrame.lookVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                  direction = direction - workspace.CurrentCamera.CFrame.lookVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                  direction = direction - workspace.CurrentCamera.CFrame.rightVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                  direction = direction + workspace.CurrentCamera.CFrame.rightVector
               end
               bp.position = bp.position + direction * speed
               bg.cframe = workspace.CurrentCamera.CFrame
            end
         end
         fly()
      end

      -- Function to stop flying
      local function stopFlying()
         flying = false
         if bg then bg:Destroy() end
         if bp then bp:Destroy() end
         player.Character.Humanoid.PlatformStand = false
      end

      -- Toggle fly on/off
      game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
         if input.KeyCode == Enum.KeyCode.X and not gameProcessed then
            if flying then
               stopFlying()
            else
               startFlying()
            end
         end
      end)

      -- Fly GUI
      local ScreenGui = Instance.new("ScreenGui")
      local Frame = Instance.new("Frame")
      local TextLabel = Instance.new("TextLabel")
      local TextLabel_2 = Instance.new("TextLabel")
      local TextButton = Instance.new("TextButton")

      ScreenGui.Parent = game.CoreGui
      Frame.Parent = ScreenGui
      Frame.BackgroundColor3 = Color3.fromRGB(24, 255, 51)
      Frame.BorderColor3 = Color3.fromRGB(255, 0, 4)
      Frame.BorderSizePixel = 15
      Frame.Position = UDim2.new(0.0575905927, 0, 0.653887033, 0)
      Frame.Size = UDim2.new(0, 295, 0, 152)
      Frame.Active = true
      Frame.Draggable = true

      TextLabel.Parent = Frame
      TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      TextLabel.BackgroundTransparency = 1.000
      TextLabel.BorderColor3 = Color3.fromRGB(255, 255, 255)
      TextLabel.BorderSizePixel = 0
      TextLabel.Size = UDim2.new(0, 295, 0, 63)
      TextLabel.Font = Enum.Font.SciFi
      TextLabel.Text = "OP FLY SCRIPT"
      TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
      TextLabel.TextScaled = true
      TextLabel.TextSize = 14.000
      TextLabel.TextStrokeTransparency = 0.000
      TextLabel.TextWrapped = true

      TextLabel_2.Parent = Frame
      TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      TextLabel_2.BackgroundTransparency = 1.000
      TextLabel_2.BorderColor3 = Color3.fromRGB(255, 255, 255)
      TextLabel_2.BorderSizePixel = 0
      TextLabel_2.Position = UDim2.new(0, 0, 0.342105269, 0)
      TextLabel_2.Size = UDim2.new(0, 295, 0, 18)
      TextLabel_2.Font = Enum.Font.SciFi
      TextLabel_2.Text = "(Press X to Fly)"
      TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
      TextLabel_2.TextScaled = true
      TextLabel_2.TextSize = 14.000
      TextLabel_2.TextStrokeTransparency = 0.000
      TextLabel_2.TextWrapped = true

      TextButton.Parent = Frame
      TextButton.BackgroundColor3 = Color3.fromRGB(8, 0, 255)
      TextButton.Position = UDim2.new(0.159322038, 0, 0.552631557, 0)
      TextButton.Size = UDim2.new(0, 200, 0, 50)
      TextButton.Font = Enum.Font.SciFi
      TextButton.Text = "Click Me To Fly"
      TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
      TextButton.TextScaled = true
      TextButton.TextSize = 14.000
      TextButton.TextStrokeTransparency = 0.000
      TextButton.TextWrapped = true

      -- Toggle fly on button click
      TextButton.MouseButton1Click:Connect(function()
         if flying then
            stopFlying()
         else
            startFlying()
         end
      end)
   end,
})

-- Fly Speed Slider
local FlySpeedSlider = PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
      speed = Value -- Update fly speed
   end,
})

-- Server Hop Tab
local ServerHopTab = Window:CreateTab("🌐 Server Hop", nil)
local ServerHopSection = ServerHopTab:CreateSection("Server Hop Features")

-- Auto Server Hop Toggle
local AutoServerHopToggle = ServerHopTab:CreateToggle({
   Name = "Auto Server Hop (30 mins)",
   CurrentValue = false,
   Flag = "AutoServerHop",
   Callback = function(Value)
      if Value then
         local function serverHop()
            while AutoServerHopToggle.CurrentValue do
               wait(1800) -- 30 minutes
               local Http = game:GetService("HttpService")
               local TPS = game:GetService("TeleportService")
               local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
               for i, v in pairs(Servers.data) do
                  if v.playing ~= v.maxPlayers then
                     TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
                  end
               end
            end
         end
         serverHop()
      end
   end,
})

-- Manual Server Hop Button
local ServerHopButton = ServerHopTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local Http = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
      for i, v in pairs(Servers.data) do
         if v.playing ~= v.maxPlayers then
            TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
         end
      end
   end,
})

-- Random Stuff Tab
local RandomTab = Window:CreateTab("🎲 Random Stuff", nil)
local RandomSection = RandomTab:CreateSection("Fun Features")

-- Infinite Yield
local InfiniteYieldButton = RandomTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

-- Yarhm
local YarhmButton = RandomTab:CreateButton({
   Name = "Yarhm",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/yarhm.lua", true))()
   end,
})

-- XhubMM2
local XhubMM2Button = RandomTab:CreateButton({
   Name = "XhubMM2",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"))()
   end,
})

-- Invisibility
local InvisibilityButton = RandomTab:CreateButton({
   Name = "Invisibility",
   Callback = function()
      loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
   end,
})

-- Aimbot (Placeholder)
local AimbotToggle = MainTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Flag = "Aimbot",
   Callback = function(Value)
      if Value then
         -- Add your aimbot logic here
      else
         -- Stop aimbot logic here
      end
   end,
})

-- Avatar Adjustment Tab (Blocked in Main Account Mode)
local AvatarTab = Window:CreateTab("👤 Avatar Adjustment", nil)
local AvatarSection = AvatarTab:CreateSection("FilteringEnabled-Compatible Avatar Features")

-- Disable Avatar Tab if Main Account Mode is enabled
if isMainAccountMode() then
   AvatarTab:SetEnabled(false)
   Rayfield:Notify({
      Title = "Main Account Mode",
      Content = "Avatar adjustments are disabled in Main Account Mode.",
      Duration = 6.5,
      Image = nil,
   })
end

-- Resize Character Slider (Blocked in Main Account Mode)
local ResizeSlider = AvatarTab:CreateSlider({
   Name = "Resize Character",
   Range = {0.5, 5},
   Increment = 0.1,
   Suffix = "Scale",
   CurrentValue = 1,
   Flag = "ResizeCharacter",
   Callback = function(Value)
      if isMainAccountMode() then
         Rayfield:Notify({
            Title = "Main Account Mode",
            Content = "This feature is disabled in Main Account Mode.",
            Duration = 6.5,
            Image = nil,
         })
         return
      end
      local character = game.Players.LocalPlayer.Character
      for _, part in pairs(character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.Size = part.Size * Value
         end
      end
   end,
})

-- Rainbow Character
local RainbowToggle = AvatarTab:CreateToggle({
   Name = "Rainbow Character",
   CurrentValue = false,
   Flag = "RainbowCharacter",
   Callback = function(Value)
      if Value then
         local function rainbowEffect()
            while RainbowToggle.CurrentValue do
               for i = 0, 1, 0.01 do
                  for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                     if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(i, 1, 1)
                     end
                  end
                  wait(0.1)
               end
            end
         end
         rainbowEffect()
      else
         -- Reset colors
         for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
               part.Color = Color3.new(1, 1, 1)
            end
         end
      end
   end,
})

-- Invisible Head
local InvisibleHeadToggle = AvatarTab:CreateToggle({
   Name = "Invisible Head",
   CurrentValue = false,
   Flag = "InvisibleHead",
   Callback = function(Value)
      local head = game.Players.LocalPlayer.Character:FindFirstChild("Head")
      if head then
         head.Transparency = Value and 1 or 0
      end
   end,
})

-- Legless (Replaces Fake Korblox)
local LeglessButton = AvatarTab:CreateButton({
   Name = "Legless",
   Callback = function()
      local character = game.Players.LocalPlayer.Character
      local leftLeg = character:FindFirstChild("Left Leg")
      local rightLeg = character:FindFirstChild("Right Leg")
      if leftLeg then
         leftLeg.Size = Vector3.new(0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001)
      end
      if rightLeg then
         rightLeg.Size = Vector3.new(0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001)
      end
   end,
})

-- Fake Headless
local FakeHeadlessButton = AvatarTab:CreateButton({
   Name = "Fake Headless",
   Callback = function()
      local character = game.Players.LocalPlayer.Character
      local head = character:FindFirstChild("Head")
      if head then
         head.Size = Vector3.new(0.0000000000000000000001, 0.000000000000000000000000000000000001, 0.000000000000000000000000000000001) -- Super small head
      end
   end,
})

-- Giant Arms
local GiantArmsButton = AvatarTab:CreateButton({
   Name = "Giant Arms",
   Callback = function()
      local character = game.Players.LocalPlayer.Character
      local leftArm = character:FindFirstChild("Left Arm")
      local rightArm = character:FindFirstChild("Right Arm")
      if leftArm then leftArm.Size = leftArm.Size * 2 end
      if rightArm then rightArm.Size = rightArm.Size * 2 end
   end,
})

-- Tiny Legs
local TinyLegsButton = AvatarTab:CreateButton({
   Name = "Tiny Legs",
   Callback = function()
      local character = game.Players.LocalPlayer.Character
      local leftLeg = character:FindFirstChild("Left Leg")
      local rightLeg = character:FindFirstChild("Right Leg")
      if leftLeg then leftLeg.Size = leftLeg.Size / 2 end
      if rightLeg then rightLeg.Size = rightLeg.Size / 2 end
   end,
})

-- Spin Character
local SpinToggle = AvatarTab:CreateToggle({
   Name = "Spin Character",
   CurrentValue = false,
   Flag = "SpinCharacter",
   Callback = function(Value)
      if Value then
         local bodyGyro = Instance.new("BodyGyro", game.Players.LocalPlayer.Character.HumanoidRootPart)
         bodyGyro.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
         bodyGyro.P = 10000
         while SpinToggle.CurrentValue do
            bodyGyro.CFrame = bodyGyro.CFrame * CFrame.Angles(0, math.rad(10), 0)
            wait()
         end
         bodyGyro:Destroy()
      end
   end,
})

-- Invisible Body
local InvisibleBodyToggle = AvatarTab:CreateToggle({
   Name = "Invisible Body",
   CurrentValue = false,
   Flag = "InvisibleBody",
   Callback = function(Value)
      local character = game.Players.LocalPlayer.Character
      for _, part in pairs(character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.Transparency = Value and 1 or 0
         end
      end
   end,
})

-- Floating Head
local FloatingHeadButton = AvatarTab:CreateButton({
   Name = "Floating Head",
   Callback = function()
      local character = game.Players.LocalPlayer.Character
      local head = character:FindFirstChild("Head")
      if head then
         for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= head then
               part.Transparency = 1
            end
         end
      end
   end,
})

-- Custom Color
local CustomColorButton = AvatarTab:CreateButton({
   Name = "Custom Color",
   Callback = function()
      local color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
      for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
         if part:IsA("BasePart") then
            part.Color = color
         end
      end
   end,
})

-- Reset Avatar
local ResetAvatarButton = AvatarTab:CreateButton({
   Name = "Reset Avatar",
   Callback = function()
      game.Players.LocalPlayer.Character:BreakJoints()
   end,
})

-- Main Account Mode Tab (Safe Features)
local MainAccountModeTab = Window:CreateTab("🔒 Main Account Mode", nil)
local MainAccountModeSection = MainAccountModeTab:CreateSection("Safe Features for Main Account Mode")

-- Anti-AFK
local AntiAFKButton = MainAccountModeTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      local VirtualUser = game:GetService("VirtualUser")
      game.Players.LocalPlayer.Idled:Connect(function()
         VirtualUser:CaptureController()
         VirtualUser:ClickButton2(Vector2.new())
      end)
   end,
})

-- Server Hop Button
local ServerHopButton = MainAccountModeTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local Http = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
      for i, v in pairs(Servers.data) do
         if v.playing ~= v.maxPlayers then
            TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
         end
      end
   end,
})

-- ESP Button (Safe Version)
local ESPButton = MainAccountModeTab:CreateButton({
   Name = "ESP",
   Callback = function()
      local Players = game:GetService("Players")
      local function createHighlight(player)
         local character = player.Character
         if not character then return end
         local highlight = Instance.new("Highlight")
         highlight.Adornee = character
         highlight.FillColor = Color3.new(1, 0, 0)
         highlight.FillTransparency = 0.5
         highlight.OutlineTransparency = 0
         highlight.Parent = character
      end
      local function onCharacterAdded(character)
         local player = Players:GetPlayerFromCharacter(character)
         if player then
            createHighlight(player)
         end
      end
      Players.PlayerAdded:Connect(function(player)
         player.CharacterAdded:Connect(onCharacterAdded)
         if player.Character then
            createHighlight(player)
         end
      end)
      for _, player in pairs(Players:GetPlayers()) do
         if player.Character then
            createHighlight(player)
         end
         player.CharacterAdded:Connect(onCharacterAdded)
      end
   end,
})

-- Notify User
Rayfield:Notify({
   Title = "Cevor MM2 V4",
   Content = "Script loaded successfully!",
   Duration = 6.5,
   Image = nil,
})
