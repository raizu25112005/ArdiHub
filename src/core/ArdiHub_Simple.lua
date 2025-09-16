-- Ardi Hub Main
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "Ardi Hub | Blox Fruits", 
    HidePremium = false,
    SaveConfig = true, 
    ConfigFolder = "ArdiHubConfig"
})

-- Check game
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    OrionLib:MakeNotification({
        Name = "Wrong Game!",
        Content = "This script only works in Blox Fruits!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
    return
end

-- Values
_G.AutoFarm = false
_G.AutoStats = false
_G.SelectedStat = "Melee"
_G.AutoSkills = false
_G.FastAttack = false

-- Functions
function AutoFarm()
    spawn(function()
        while _G.AutoFarm do
            pcall(function()
                -- Find nearest mob
                local nearestMob = nil
                local shortestDistance = math.huge
                
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestMob = mob
                        end
                    end
                end
                
                if nearestMob then
                    -- Teleport to mob
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = nearestMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 7)
                    
                    -- Attack
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                end
            end)
            task.wait()
        end
    end)
end

function AutoStats()
    spawn(function()
        while _G.AutoStats do
            local args = {
                [1] = "AddPoint",
                [2] = _G.SelectedStat,
                [3] = 1
            }
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            wait(0.1)
        end
    end)
end

function AutoSkills()
    spawn(function()
        while _G.AutoSkills do
            pcall(function()
                -- Use all skills
                game:GetService("VirtualUser"):SendKeyEvent(true, "Z", false, game)
                wait(0.1)
                game:GetService("VirtualUser"):SendKeyEvent(true, "X", false, game)
                wait(0.1)
                game:GetService("VirtualUser"):SendKeyEvent(true, "C", false, game)
                wait(0.1)
                game:GetService("VirtualUser"):SendKeyEvent(true, "V", false, game)
            end)
            wait(1)
        end
    end)
end

-- Fast Attack
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local CameraShakerR = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.CameraShaker)
local CameraShaker = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.CameraShaker)

function FastAttack()
    spawn(function()
        while _G.FastAttack do
            pcall(function()
                CameraShakerR:Stop()
                CombatFramework.activeController.attacking = false
                CombatFramework.activeController.timeToNextAttack = 0
                CombatFramework.activeController.increment = 3
                CombatFramework.activeController.hitboxMagnitude = 100
            end)
            task.wait()
        end
    end)
end

-- Tabs
local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local StatsTab = Window:MakeTab({
    Name = "Stats",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Farm Tab
FarmTab:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        if Value then
            AutoFarm()
        end
    end    
})

-- Stats Tab
StatsTab:AddDropdown({
    Name = "Select Stat",
    Default = "Melee",
    Options = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
    Callback = function(Value)
        _G.SelectedStat = Value
    end    
})

StatsTab:AddToggle({
    Name = "Auto Stats",
    Default = false,
    Callback = function(Value)
        _G.AutoStats = Value
        if Value then
            AutoStats()
        end
    end    
})

-- Combat Tab
CombatTab:AddToggle({
    Name = "Auto Skills",
    Default = false,
    Callback = function(Value)
        _G.AutoSkills = Value
        if Value then
            AutoSkills()
        end
    end    
})

CombatTab:AddToggle({
    Name = "Fast Attack",
    Default = false,
    Callback = function(Value)
        _G.FastAttack = Value
        if Value then
            FastAttack()
        end
    end    
})

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Welcome Message
OrionLib:MakeNotification({
    Name = "Script Loaded!",
    Content = "Welcome to Ardi Hub!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

OrionLib:Init()