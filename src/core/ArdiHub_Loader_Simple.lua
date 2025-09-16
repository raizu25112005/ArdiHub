-- Ardi Hub Loader
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Check game
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    Rayfield:Notify({
        Title = "Wrong Game",
        Content = "This script only works in Blox Fruits!",
        Duration = 6.5,
        Image = 4483362458
    })
    return
end

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Ardi Hub | Blox Fruits",
    LoadingTitle = "Ardi Hub Loading...",
    LoadingSubtitle = "by Ardi",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ArdiHub",
        FileName = "Config"
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Farm Section
local FarmingSection = MainTab:CreateSection("Farming")

-- Auto Farm Toggle
MainTab:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        getgenv().AutoFarm = Value
        if Value then
            AutoFarm()
        end
    end    
})

-- Auto Farm Function
function AutoFarm()
    spawn(function()
        while getgenv().AutoFarm do
            pcall(function()
                local Players = game:GetService("Players")
                local Player = Players.LocalPlayer
                local Character = Player.Character
                if Character then
                    -- Find nearest mob
                    local nearestMob = nil
                    local shortestDistance = math.huge
                    
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            local distance = (Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestMob = mob
                            end
                        end
                    end
                    
                    if nearestMob then
                        -- Teleport to mob
                        Character.HumanoidRootPart.CFrame = nearestMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 7)
                        
                        -- Attack
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new())
                    end
                end
            end)
            wait()
        end
    end)
end

-- Stats Section
local StatsSection = MainTab:CreateSection("Stats")

-- Auto Stats
MainTab:CreateToggle({
    Name = "Auto Stats",
    CurrentValue = false,
    Flag = "AutoStats",
    Callback = function(Value)
        getgenv().AutoStats = Value
        if Value then
            AutoStats()
        end
    end    
})

-- Stats Dropdown
MainTab:CreateDropdown({
    Name = "Select Stat",
    Options = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
    CurrentOption = "Melee",
    Flag = "StatSelection",
    Callback = function(Option)
        getgenv().SelectedStat = Option
    end,
})

-- Auto Stats Function
function AutoStats()
    spawn(function()
        while getgenv().AutoStats do
            pcall(function()
                local args = {
                    [1] = "AddPoint",
                    [2] = getgenv().SelectedStat,
                    [3] = 1
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end)
            wait(0.1)
        end
    end)
end

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- Skills Section
local SkillsSection = CombatTab:CreateSection("Skills")

-- Auto Skills
CombatTab:CreateToggle({
    Name = "Auto Skills",
    CurrentValue = false,
    Flag = "AutoSkills",
    Callback = function(Value)
        getgenv().AutoSkills = Value
        if Value then
            AutoSkills()
        end
    end    
})

-- Skills Function
function AutoSkills()
    spawn(function()
        while getgenv().AutoSkills do
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                -- Use skills
                VirtualUser:SendKeyEvent(true, "Z", false, game)
                wait(0.1)
                VirtualUser:SendKeyEvent(true, "X", false, game)
                wait(0.1)
                VirtualUser:SendKeyEvent(true, "C", false, game)
                wait(0.1)
                VirtualUser:SendKeyEvent(true, "V", false, game)
            end)
            wait(1)
        end
    end)
end

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- ESP Section
local ESPSection = MiscTab:CreateSection("ESP")

-- ESP Toggle
MiscTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        getgenv().PlayerESP = Value
        if Value then
            PlayerESP()
        end
    end    
})

-- ESP Function
function PlayerESP()
    spawn(function()
        while getgenv().PlayerESP do
            pcall(function()
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game:GetService("Players").LocalPlayer then
                        if not player.Character.Head:FindFirstChild("PlayerESP") then
                            local BillboardGui = Instance.new("BillboardGui")
                            local TextLabel = Instance.new("TextLabel")
                            
                            BillboardGui.Name = "PlayerESP"
                            BillboardGui.Parent = player.Character.Head
                            BillboardGui.AlwaysOnTop = true
                            BillboardGui.Size = UDim2.new(0, 100, 0, 50)
                            BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
                            
                            TextLabel.Parent = BillboardGui
                            TextLabel.BackgroundTransparency = 1
                            TextLabel.Size = UDim2.new(1, 0, 1, 0)
                            TextLabel.Text = player.Name
                            TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            TextLabel.TextScaled = true
                        end
                    end
                end
            end)
            wait(1)
        end
    end)
end

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Notification
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Welcome to Ardi Hub!",
    Duration = 6.5,
    Image = 4483362458
})

return Window