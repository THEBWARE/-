-- Create a ScreenGui instance
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a TextLabel instance
local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 200, 0, 50) -- Width: 200, Height: 50
textLabel.Position = UDim2.new(0, 10, 1, -60) -- Bottom-left corner (10 pixels from the left, 60 pixels from the bottom)
textLabel.AnchorPoint = Vector2.new(0, 1) -- Anchor to the bottom-left corner
textLabel.Text = "Cevor Successfully Attached"
textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
textLabel.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
textLabel.BackgroundTransparency = 0.5 -- Semi-transparent background
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextStrokeTransparency = 0
textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

-- Optional: Remove the GUI after a few seconds
wait(5) -- Wait for 5 seconds
screenGui:Destroy()
