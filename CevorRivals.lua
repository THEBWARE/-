local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Rivals Script - Fluent " .. Fluent.Version,
    SubTitle = "by YourName",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs (All tabs are visible by default)
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    PromoCode = Window:AddTab({ Title = "Promo Code", Icon = "lock" }), -- Promo Code Tab
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Secret Tab (Unlocked with Promo Code)
local SecretTab = Window:AddTab({ Title = "OP Features", Icon = "zap", Visible = false }) -- Hidden by default

local Options = Fluent.Options

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local AimbotEnabled = false
local AntiAimEnabled = false
local NoclipEnabled = false
local FlyEnabled = false
local GodModeEnabled = false
local InfiniteJumpEnabled = false
local SpeedHackEnabled = false
local ESPEnabled = false
local KillAllEnabled = false
local ExplodeAllEnabled = false
local FreezeAllEnabled = false
local LagServerEnabled = false
local TeleportAllEnabled = false
local DeleteAllEnabled = false
local CrashServerEnabled = false
local GodModeAllEnabled = false
local InvisibilityEnabled = false
local NoClipAllEnabled = false
local AntiKickEnabled = false
local AntiBanEnabled = false
local AntiCheatBypassEnabled = false
local PromoCodeEntered = false -- Track if promo code is entered

-- Aimbot Variables
local AimbotTarget = nil
local AimbotSmoothness = 5
local AimMethod = "Smooth" -- Can be "Smooth" or "Instant"
local TeamCheck = true
local WallCheck = true
local DeadCheck = true

-- Functions
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = math.huge

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            if TeamCheck and Player.Team == LocalPlayer.Team then
                continue
            end
            if DeadCheck and Player.Character.Humanoid.Health <= 0 then
                continue
            end
            if WallCheck then
                local Ray = Ray.new(Camera.CFrame.Position, (Player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 1000)
                local Hit, Position = workspace:FindPartOnRay(Ray, LocalPlayer.Character)
                if Hit and Hit:IsDescendantOf(Player.Character) == false then
                    continue
                end
            end

            local Distance = (Player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if Distance < ShortestDistance then
                ShortestDistance = Distance
                ClosestPlayer = Player
            end
        end
    end

    return ClosestPlayer
end

local function Aimbot()
    RunService.RenderStepped:Connect(function()
        if AimbotEnabled then
            local Target = GetClosestPlayer()
            if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
                local TargetPosition = Target.Character.HumanoidRootPart.Position
                local CameraPosition = Camera.CFrame.Position
                local Delta = (TargetPosition - CameraPosition)

                if AimMethod == "Smooth" then
                    local SmoothDelta = Delta / AimbotSmoothness
                    Camera.CFrame = CFrame.new(CameraPosition, CameraPosition + SmoothDelta)
                elseif AimMethod == "Instant" then
                    Camera.CFrame = CFrame.new(CameraPosition, TargetPosition)
                end
            end
        end
    end)
end

local function AntiAim()
    while AntiAimEnabled and task.wait() do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
        end
    end
end

local function Noclip()
    RunService.Stepped:Connect(function()
        if NoclipEnabled and LocalPlayer.Character then
            for _, Part in pairs(LocalPlayer.Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = false
                end
            end
        end
    end)
end

local function Fly()
    local BodyVelocity = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(0, 0, 0)

    while FlyEnabled and task.wait() do
        BodyVelocity.Velocity = Vector3.new(0, 50, 0) -- Adjust for flying
    end
end

local function GodMode()
    while GodModeEnabled and task.wait() do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 100
        end
    end
end

local function InfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end

local function ESP()
    while ESPEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = Player.Character
                Highlight.FillColor = Color3.new(1, 0, 0)
                Highlight.OutlineColor = Color3.new(1, 1, 1)
            end
        end
    end
end

local function KillAll()
    while KillAllEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- Teleport to player
                LocalPlayer.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame
                -- Kill player (replace with your kill logic)
                Player.Character.Humanoid.Health = 0
                -- Wait for player to respawn
                repeat task.wait() until Player.Character.Humanoid.Health <= 0
            end
        end
    end
end

local function ExplodeAll()
    while ExplodeAllEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- Create explosion at player's position
                local Explosion = Instance.new("Explosion")
                Explosion.Position = Player.Character.HumanoidRootPart.Position
                Explosion.Parent = workspace
            end
        end
    end
end

local function FreezeAll()
    while FreezeAllEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- Freeze player
                Player.Character.HumanoidRootPart.Anchored = true
            end
        end
    end
end

local function LagServer()
    while LagServerEnabled and task.wait() do
        -- Spam parts to lag the server
        for i = 1, 100 do
            local Part = Instance.new("Part", workspace)
            Part.Position = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
        end
    end
end

local function TeleportAll()
    while TeleportAllEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                -- Teleport all players to your position
                Player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end

local function DeleteAll()
    while DeleteAllEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                -- Delete player's character
                Player.Character:Destroy()
            end
        end
    end
end

local function CrashServer()
    while CrashServerEnabled and task.wait() do
        -- Spam parts to crash the server
        for i = 1, 1000 do
            local Part = Instance.new("Part", workspace)
            Part.Position = Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
        end
    end
end

local function GodModeAll()
    while GodModeAllEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                -- Enable God Mode for all players
                Player.Character.Humanoid.Health = 100
            end
        end
    end
end

local function Invisibility()
    while InvisibilityEnabled and task.wait() do
        if LocalPlayer.Character then
            for _, Part in pairs(LocalPlayer.Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.Transparency = 1
                end
            end
        end
    end
end

local function NoClipAll()
    while NoClipAllEnabled and task.wait() do
        for _, Player in pairs(Players:GetPlayers()) do
            if Player.Character then
                for _, Part in pairs(Player.Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = false
                    end
                end
            end
        end
    end
end

local function AntiKick()
    while AntiKickEnabled and task.wait() do
        -- Prevent the player from being kicked
        LocalPlayer:Kick("You can't kick me!")
    end
end

local function AntiBan()
    while AntiBanEnabled and task.wait() do
        -- Prevent the player from being banned
        LocalPlayer:Ban("You can't ban me!")
    end
end

local function AntiCheatBypass()
    while AntiCheatBypassEnabled and task.wait() do
        -- Bypass anti-cheat (replace with your bypass logic)
        print("Anti-Cheat Bypassed!")
    end
end

-- Main Tab
Tabs.Main:AddParagraph({
    Title = "Welcome to Rivals Script",
    Content = "This script provides various utilities for the Rivals game."
})

-- Player Tab
local WalkSpeedSlider = Tabs.Player:AddSlider("WalkSpeedSlider", {
    Title = "Walk Speed",
    Description = "Adjust the player's walk speed.",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local JumpPowerSlider = Tabs.Player:AddSlider("JumpPowerSlider", {
    Title = "Jump Power",
    Description = "Adjust the player's jump power.",
    Default = 50,
    Min = 50,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

local NoclipToggle = Tabs.Player:AddToggle("NoclipToggle", {
    Title = "Enable Noclip",
    Default = false
})

NoclipToggle:OnChanged(function()
    NoclipEnabled = Options.NoclipToggle.Value
    if NoclipEnabled then
        coroutine.wrap(Noclip)()
    end
    print("Noclip:", NoclipEnabled)
end)

local FlyToggle = Tabs.Player:AddToggle("FlyToggle", {
    Title = "Enable Fly",
    Default = false
})

FlyToggle:OnChanged(function()
    FlyEnabled = Options.FlyToggle.Value
    if FlyEnabled then
        coroutine.wrap(Fly)()
    end
    print("Fly:", FlyEnabled)
end)

local GodModeToggle = Tabs.Player:AddToggle("GodModeToggle", {
    Title = "Enable God Mode",
    Default = false
})

GodModeToggle:OnChanged(function()
    GodModeEnabled = Options.GodModeToggle.Value
    if GodModeEnabled then
        coroutine.wrap(GodMode)()
    end
    print("God Mode:", GodModeEnabled)
end)

local InfiniteJumpToggle = Tabs.Player:AddToggle("InfiniteJumpToggle", {
    Title = "Enable Infinite Jump",
    Default = false
})

InfiniteJumpToggle:OnChanged(function()
    InfiniteJumpEnabled = Options.InfiniteJumpToggle.Value
    if InfiniteJumpEnabled then
        coroutine.wrap(InfiniteJump)()
    end
    print("Infinite Jump:", InfiniteJumpEnabled)
end)

local ESPToggle = Tabs.Player:AddToggle("ESPToggle", {
    Title = "Enable ESP",
    Default = false
})

ESPToggle:OnChanged(function()
    ESPEnabled = Options.ESPToggle.Value
    if ESPEnabled then
        coroutine.wrap(ESP)()
    end
    print("ESP:", ESPEnabled)
end)

-- Aimbot Tab
local AimbotToggle = Tabs.Aimbot:AddToggle("AimbotToggle", {
    Title = "Enable Aimbot",
    Default = false
})

AimbotToggle:OnChanged(function()
    AimbotEnabled = Options.AimbotToggle.Value
    if AimbotEnabled then
        coroutine.wrap(Aimbot)()
    end
    print("Aimbot:", AimbotEnabled)
end)

local AimbotSmoothnessSlider = Tabs.Aimbot:AddSlider("AimbotSmoothnessSlider", {
    Title = "Aimbot Smoothness",
    Description = "Adjust the smoothness of the aimbot.",
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        AimbotSmoothness = Value
    end
})

local AimMethodDropdown = Tabs.Aimbot:AddDropdown("AimMethodDropdown", {
    Title = "Aim Method",
    Values = {"Smooth", "Instant"},
    Multi = false,
    Default = "Smooth",
    Callback = function(Value)
        AimMethod = Value
        print("Aim Method changed to:", Value)
    end
})

local TeamCheckToggle = Tabs.Aimbot:AddToggle("TeamCheckToggle", {
    Title = "Team Check",
    Default = true,
    Callback = function(Value)
        TeamCheck = Value
        print("Team Check:", Value)
    end
})

local WallCheckToggle = Tabs.Aimbot:AddToggle("WallCheckToggle", {
    Title = "Wall Check",
    Default = true,
    Callback = function(Value)
        WallCheck = Value
        print("Wall Check:", Value)
    end
})

local DeadCheckToggle = Tabs.Aimbot:AddToggle("DeadCheckToggle", {
    Title = "Dead Check",
    Default = true,
    Callback = function(Value)
        DeadCheck = Value
        print("Dead Check:", Value)
    end
})

local AntiAimToggle = Tabs.Aimbot:AddToggle("AntiAimToggle", {
    Title = "Enable Anti-Aim",
    Default = false
})

AntiAimToggle:OnChanged(function()
    AntiAimEnabled = Options.AntiAimToggle.Value
    if AntiAimEnabled then
        coroutine.wrap(AntiAim)()
    end
    print("Anti-Aim:", AntiAimEnabled)
end)

-- Teleport Tab
local TeleportDropdown = Tabs.Teleport:AddDropdown("TeleportDropdown", {
    Title = "Teleport to Player",
    Values = {},
    Multi = false,
    Default = "",
    Callback = function(Value)
        local TargetPlayer = Players:FindFirstChild(Value)
        if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
})

-- Update Teleport Dropdown with Player Names
local function UpdateTeleportDropdown()
    local PlayerNames = {}
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            table.insert(PlayerNames, Player.Name)
        end
    end
    TeleportDropdown:SetValues(PlayerNames)
end

UpdateTeleportDropdown()
Players.PlayerAdded:Connect(UpdateTeleportDropdown)
Players.PlayerRemoving:Connect(UpdateTeleportDropdown)

-- Promo Code Tab
local PromoCodeInput = Tabs.PromoCode:AddInput("PromoCodeInput", {
    Title = "Enter Promo Code",
    Default = "",
    PlaceholderText = "Enter Promo Code",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        if Value == "Cevor_78922324ios#78koj" then
            PromoCodeEntered = true
            SecretTab.Visible = true
            Fluent:Notify({
                Title = "Promo Code Accepted",
                Content = "OP Features unlocked!",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Invalid Promo Code",
                Content = "Please try again.",
                Duration = 5
            })
        end
    end
})

-- Secret Tab (OP Features)
SecretTab:AddParagraph({
    Title = "OP Features Unlocked!",
    Content = "You now have access to extremely overpowered features."
})

local KillAllToggle = SecretTab:AddToggle("KillAllToggle", {
    Title = "Enable Kill All",
    Default = false
})

KillAllToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    KillAllEnabled = Options.KillAllToggle.Value
    if KillAllEnabled then
        coroutine.wrap(KillAll)()
    end
    print("Kill All:", KillAllEnabled)
end)

local ExplodeAllToggle = SecretTab:AddToggle("ExplodeAllToggle", {
    Title = "Enable Explode All",
    Default = false
})

ExplodeAllToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    ExplodeAllEnabled = Options.ExplodeAllToggle.Value
    if ExplodeAllEnabled then
        coroutine.wrap(ExplodeAll)()
    end
    print("Explode All:", ExplodeAllEnabled)
end)

local FreezeAllToggle = SecretTab:AddToggle("FreezeAllToggle", {
    Title = "Enable Freeze All",
    Default = false
})

FreezeAllToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    FreezeAllEnabled = Options.FreezeAllToggle.Value
    if FreezeAllEnabled then
        coroutine.wrap(FreezeAll)()
    end
    print("Freeze All:", FreezeAllEnabled)
end)

local LagServerToggle = SecretTab:AddToggle("LagServerToggle", {
    Title = "Enable Lag Server",
    Default = false
})

LagServerToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    LagServerEnabled = Options.LagServerToggle.Value
    if LagServerEnabled then
        coroutine.wrap(LagServer)()
    end
    print("Lag Server:", LagServerEnabled)
end)

local TeleportAllToggle = SecretTab:AddToggle("TeleportAllToggle", {
    Title = "Enable Teleport All",
    Default = false
})

TeleportAllToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    TeleportAllEnabled = Options.TeleportAllToggle.Value
    if TeleportAllEnabled then
        coroutine.wrap(TeleportAll)()
    end
    print("Teleport All:", TeleportAllEnabled)
end)

local DeleteAllToggle = SecretTab:AddToggle("DeleteAllToggle", {
    Title = "Enable Delete All",
    Default = false
})

DeleteAllToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    DeleteAllEnabled = Options.DeleteAllToggle.Value
    if DeleteAllEnabled then
        coroutine.wrap(DeleteAll)()
    end
    print("Delete All:", DeleteAllEnabled)
end)

local CrashServerToggle = SecretTab:AddToggle("CrashServerToggle", {
    Title = "Enable Crash Server",
    Default = false
})

CrashServerToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    CrashServerEnabled = Options.CrashServerToggle.Value
    if CrashServerEnabled then
        coroutine.wrap(CrashServer)()
    end
    print("Crash Server:", CrashServerEnabled)
end)

local GodModeAllToggle = SecretTab:AddToggle("GodModeAllToggle", {
    Title = "Enable God Mode for All",
    Default = false
})

GodModeAllToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    GodModeAllEnabled = Options.GodModeAllToggle.Value
    if GodModeAllEnabled then
        coroutine.wrap(GodModeAll)()
    end
    print("God Mode for All:", GodModeAllEnabled)
end)

local InvisibilityToggle = SecretTab:AddToggle("InvisibilityToggle", {
    Title = "Enable Invisibility",
    Default = false
})

InvisibilityToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    InvisibilityEnabled = Options.InvisibilityToggle.Value
    if InvisibilityEnabled then
        coroutine.wrap(Invisibility)()
    end
    print("Invisibility:", InvisibilityEnabled)
end)

local NoClipAllToggle = SecretTab:AddToggle("NoClipAllToggle", {
    Title = "Enable No Clip for All",
    Default = false
})

NoClipAllToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    NoClipAllEnabled = Options.NoClipAllToggle.Value
    if NoClipAllEnabled then
        coroutine.wrap(NoClipAll)()
    end
    print("No Clip for All:", NoClipAllEnabled)
end)

local AntiKickToggle = SecretTab:AddToggle("AntiKickToggle", {
    Title = "Enable Anti-Kick",
    Default = false
})

AntiKickToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    AntiKickEnabled = Options.AntiKickToggle.Value
    if AntiKickEnabled then
        coroutine.wrap(AntiKick)()
    end
    print("Anti-Kick:", AntiKickEnabled)
end)

local AntiBanToggle = SecretTab:AddToggle("AntiBanToggle", {
    Title = "Enable Anti-Ban",
    Default = false
})

AntiBanToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    AntiBanEnabled = Options.AntiBanToggle.Value
    if AntiBanEnabled then
        coroutine.wrap(AntiBan)()
    end
    print("Anti-Ban:", AntiBanEnabled)
end)

local AntiCheatBypassToggle = SecretTab:AddToggle("AntiCheatBypassToggle", {
    Title = "Enable Anti-Cheat Bypass",
    Default = false
})

AntiCheatBypassToggle:OnChanged(function()
    if not PromoCodeEntered then
        Fluent:Notify({
            Title = "Error",
            Content = "You must enter the promo code to use this feature.",
            Duration = 5
        })
        return
    end
    AntiCheatBypassEnabled = Options.AntiCheatBypassToggle.Value
    if AntiCheatBypassEnabled then
        coroutine.wrap(AntiCheatBypass)()
    end
    print("Anti-Cheat Bypass:", AntiCheatBypassEnabled)
end)

-- Settings Tab
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("RivalsScript")
SaveManager:SetFolder("RivalsScript/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Notify
Window:SelectTab(1)

Fluent:Notify({
    Title = "Rivals Script",
    Content = "The script has been loaded.",
    Duration = 8
})

-- Load AutoLoad Config
SaveManager:LoadAutoloadConfig()
