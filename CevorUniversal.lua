local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Cevor Universal " .. Fluent.Version,
    SubTitle = "by ScripterBob",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Enable blur effect
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Minimize keybind
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "eye" }),
    AntiAim = Window:AddTab({ Title = "Anti-Aim", Icon = "shield" }),
    FPSGames = Window:AddTab({ Title = "FPS Games", Icon = "target" }),
    World = Window:AddTab({ Title = "World", Icon = "globe" }),
    Admin = Window:AddTab({ Title = "Admin", Icon = "shield" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Notify user on load
Fluent:Notify({
    Title = "Cevor Universal",
    Content = "Welcome to the ultimate mod menu!",
    Duration = 5
})

-- Main Tab
Tabs.Main:AddParagraph({
    Title = "Welcome to Cevor Universal",
    Content = "The most advanced mod menu for Roblox games."
})

Tabs.Main:AddButton({
    Title = "Destroy GUI",
    Description = "Closes the mod menu.",
    Callback = function()
        Window:Destroy()
    end
})

-- Player Tab
Tabs.Player:AddParagraph({
    Title = "Player Modifications",
    Content = "Modify your player's properties."
})

local SpeedToggle = Tabs.Player:AddToggle("SpeedToggle", {Title = "Speed Hack", Default = false })
SpeedToggle:OnChanged(function()
    if Options.SpeedToggle.Value then
        -- Speed hack logic
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

local JumpPowerToggle = Tabs.Player:AddToggle("JumpPowerToggle", {Title = "Jump Power Hack", Default = false })
JumpPowerToggle:OnChanged(function()
    if Options.JumpPowerToggle.Value then
        -- Jump power hack logic
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)

local FlyToggle = Tabs.Player:AddToggle("FlyToggle", {Title = "Fly", Default = false })
FlyToggle:OnChanged(function()
    if Options.FlyToggle.Value then
        -- Fly logic
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGui-V3/main/FlyGuiV3.lua"))()
    else
        -- Disable fly
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    end
end)

local NoclipToggle = Tabs.Player:AddToggle("NoclipToggle", {Title = "Noclip", Default = false })
NoclipToggle:OnChanged(function()
    if Options.NoclipToggle.Value then
        -- Noclip logic
        local noclipLoop
        noclipLoop = game:GetService("RunService").Stepped:Connect(function()
            if Options.NoclipToggle.Value then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            else
                noclipLoop:Disconnect()
            end
        end)
    end
end)

-- Visuals Tab (ESP, Chams, etc.)
Tabs.Visuals:AddParagraph({
    Title = "Visual Modifications",
    Content = "Enhance your visual experience."
})

local ESPToggle = Tabs.Visuals:AddToggle("ESPToggle", {Title = "ESP", Default = false })
ESPToggle:OnChanged(function()
    if Options.ESPToggle.Value then
        -- ESP logic
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 1, 1)
            end
        end
    else
        -- Remove ESP
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end
    end
end)

-- Aimbot Tab
Tabs.Aimbot:AddParagraph({
    Title = "Aimbot Settings",
    Content = "Configure your Aimbot settings."
})

local AimbotToggle = Tabs.Aimbot:AddToggle("AimbotToggle", {Title = "Aimbot", Default = false })
local DeadCheckToggle = Tabs.Aimbot:AddToggle("DeadCheckToggle", {Title = "Dead Check", Default = false })
local TeamCheckToggle = Tabs.Aimbot:AddToggle("TeamCheckToggle", {Title = "Team Check", Default = false })
local WallCheckToggle = Tabs.Aimbot:AddToggle("WallCheckToggle", {Title = "Wall Check", Default = false })

local AimbotPartDropdown = Tabs.Aimbot:AddDropdown("AimbotPartDropdown", {
    Title = "Aimbot Part",
    Values = {"Head", "Torso", "HumanoidRootPart"},
    Multi = false,
    Default = 1,
})

local DetectionMethodDropdown = Tabs.Aimbot:AddDropdown("DetectionMethodDropdown", {
    Title = "Detection Method",
    Values = {"Closest", "Farthest", "Random", "Closest to Mouse"},
    Multi = false,
    Default = 1,
})

AimbotToggle:OnChanged(function()
    if Options.AimbotToggle.Value then
        -- Aimbot logic
        local camera = workspace.CurrentCamera
        local runService = game:GetService("RunService")
        local userInputService = game:GetService("UserInputService")

        runService.RenderStepped:Connect(function()
            if Options.AimbotToggle.Value then
                local nearestPlayer, nearestDistance = nil, math.huge
                local mouse = game.Players.LocalPlayer:GetMouse()

                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        -- Dead Check
                        if Options.DeadCheckToggle.Value and player.Character.Humanoid.Health <= 0 then
                            continue
                        end

                        -- Team Check
                        if Options.TeamCheckToggle.Value and player.Team == game.Players.LocalPlayer.Team then
                            continue
                        end

                        -- Wall Check
                        if Options.WallCheckToggle.Value then
                            local ray = Ray.new(
                                camera.CFrame.Position,
                                (player.Character.HumanoidRootPart.Position - camera.CFrame.Position).Unit * 1000
                            )
                            local hit, _ = workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character)
                            if hit and not hit:IsDescendantOf(player.Character) then
                                continue
                            end
                        end

                        -- Detection Method
                        local distance = (player.Character.HumanoidRootPart.Position - camera.CFrame.Position).Magnitude
                        local screenPoint, onScreen = camera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)

                        if Options.DetectionMethodDropdown.Value == "Closest" and distance < nearestDistance then
                            nearestPlayer = player
                            nearestDistance = distance
                        elseif Options.DetectionMethodDropdown.Value == "Farthest" and distance > nearestDistance then
                            nearestPlayer = player
                            nearestDistance = distance
                        elseif Options.DetectionMethodDropdown.Value == "Random" then
                            nearestPlayer = player
                            break
                        elseif Options.DetectionMethodDropdown.Value == "Closest to Mouse" and onScreen then
                            local mouseDistance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                            if mouseDistance < nearestDistance then
                                nearestPlayer = player
                                nearestDistance = mouseDistance
                            end
                        end
                    end
                end

                if nearestPlayer then
                    local part = nearestPlayer.Character:FindFirstChild(Options.AimbotPartDropdown.Value)
                    if part then
                        camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
                    end
                end
            end
        end)
    end
end)

-- ESP Tab
Tabs.ESP:AddParagraph({
    Title = "ESP Settings",
    Content = "Configure your ESP settings."
})

local ESPBoxToggle = Tabs.ESP:AddToggle("ESPBoxToggle", {Title = "Box ESP", Default = false })
ESPBoxToggle:OnChanged(function()
    if Options.ESPBoxToggle.Value then
        -- Box ESP logic
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = player.Character.HumanoidRootPart.Size
                box.Adornee = player.Character.HumanoidRootPart
                box.Transparency = 0.5
                box.Color3 = Color3.new(1, 0, 0)
                box.Parent = player.Character
            end
        end
    else
        -- Remove Box ESP
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("BoxHandleAdornment") then
                player.Character.BoxHandleAdornment:Destroy()
            end
        end
    end
end)

-- Anti-Aim Tab
Tabs.AntiAim:AddParagraph({
    Title = "Anti-Aim Settings",
    Content = "Configure your Anti-Aim settings."
})

local AntiAimToggle = Tabs.AntiAim:AddToggle("AntiAimToggle", {Title = "Anti-Aim", Default = false })
AntiAimToggle:OnChanged(function()
    if Options.AntiAimToggle.Value then
        -- Anti-Aim logic
        local runService = game:GetService("RunService")
        runService.RenderStepped:Connect(function()
            if Options.AntiAimToggle.Value then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
                )
            end
        end)
    end
end)

-- FPS Games Tab
Tabs.FPSGames:AddParagraph({
    Title = "FPS Games AutoFarm",
    Content = "Automatically farm kills in FPS games."
})

local AutoFarmToggle = Tabs.FPSGames:AddToggle("AutoFarmToggle", {Title = "AutoFarm", Default = false })
AutoFarmToggle:OnChanged(function()
    if Options.AutoFarmToggle.Value then
        -- AutoFarm logic
        local runService = game:GetService("RunService")
        runService.RenderStepped:Connect(function()
            if Options.AutoFarmToggle.Value then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                        if player.Character.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                            break
                        end
                    end
                end
            end
        end)
    end
end)

-- Admin Tab (Infinite Yield-like Commands)
Tabs.Admin:AddParagraph({
    Title = "Admin Commands",
    Content = "Execute admin commands like Infinite Yield."
})

-- Command List
local CommandList = Tabs.Admin:AddParagraph({
    Title = "Available Commands",
    Content = [[
=== Player Commands ===
- fly: Enables flying.
- god: Makes you invincible.
- heal: Restores your health to 100.
- noclip: Enables noclip.
- clip: Disables noclip.
- speed [value]: Sets your walkspeed (e.g., speed 100).
- jump [value]: Sets your jump power (e.g., jump 100).

=== Player Targeting Commands ===
- goto [player]: Teleports you to a player.
- bring [player]: Brings a player to you.
- kill [player]: Kills a player (sets their health to 0).

=== Visual Commands ===
- esp: Enables ESP.
- noesp: Disables ESP.
- invisible: Makes you invisible.
- visible: Makes you visible again.

=== World Commands ===
- time [value]: Sets the time of day (e.g., time 12).
- gravity [value]: Sets the gravity (e.g., gravity 50).

=== Combat Commands ===
- aimbot: Enables Aimbot.
- noaimbot: Disables Aimbot.
    ]]
})

local CommandInput = Tabs.Admin:AddInput("CommandInput", {
    Title = "Command",
    Default = "",
    Placeholder = "Enter command...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        -- Command execution logic
        local command = string.lower(Value)
        local args = string.split(command, " ")

        if args[1] == "fly" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGui-V3/main/FlyGuiV3.lua"))()
        elseif args[1] == "god" then
            game.Players.LocalPlayer.Character.Humanoid:Destroy()
        elseif args[1] == "heal" then
            game.Players.LocalPlayer.Character.Humanoid.Health = 100
        elseif args[1] == "goto" and args[2] then
            local targetPlayer = game.Players:FindFirstChild(args[2])
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            end
        elseif args[1] == "bring" and args[2] then
            local targetPlayer = game.Players:FindFirstChild(args[2])
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                targetPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        elseif args[1] == "kill" and args[2] then
            local targetPlayer = game.Players:FindFirstChild(args[2])
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                targetPlayer.Character.Humanoid.Health = 0
            end
        elseif args[1] == "invisible" then
            game.Players.LocalPlayer.Character.Head.Transparency = 1
            for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
        elseif args[1] == "visible" then
            game.Players.LocalPlayer.Character.Head.Transparency = 0
            for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
        elseif args[1] == "noclip" then
            Options.NoclipToggle:SetValue(true)
        elseif args[1] == "clip" then
            Options.NoclipToggle:SetValue(false)
        elseif args[1] == "speed" and args[2] then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(args[2])
        elseif args[1] == "jump" and args[2] then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = tonumber(args[2])
        elseif args[1] == "time" and args[2] then
            game.Lighting.TimeOfDay = args[2]
        elseif args[1] == "gravity" and args[2] then
            workspace.Gravity = tonumber(args[2])
        elseif args[1] == "esp" then
            Options.ESPToggle:SetValue(true)
        elseif args[1] == "noesp" then
            Options.ESPToggle:SetValue(false)
        elseif args[1] == "aimbot" then
            Options.AimbotToggle:SetValue(true)
        elseif args[1] == "noaimbot" then
            Options.AimbotToggle:SetValue(false)
        else
            Fluent:Notify({
                Title = "Error",
                Content = "Unknown command: " .. args[1],
                Duration = 5
            })
        end
    end
})

-- World Tab (Time, Gravity, etc.)
Tabs.World:AddParagraph({
    Title = "World Modifications",
    Content = "Modify the game world."
})

local TimeSlider = Tabs.World:AddSlider("TimeSlider", {
    Title = "Time of Day",
    Description = "Change the time of day.",
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Callback = function(Value)
        game.Lighting.TimeOfDay = Value
    end
})

local GravitySlider = Tabs.World:AddSlider("GravitySlider", {
    Title = "Gravity",
    Description = "Change the gravity.",
    Default = 196.2,
    Min = 0,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        workspace.Gravity = Value
    end
})

-- Settings Tab (Save/Load Configs)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Load the first tab by default
Window:SelectTab(1)

-- Notify user when the script is fully loaded
Fluent:Notify({
    Title = "Cevor Universal",
    Content = "The mod menu has been fully loaded.",
    Duration = 8
})

-- Load auto-saved config
SaveManager:LoadAutoloadConfig()
