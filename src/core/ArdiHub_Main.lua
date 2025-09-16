-- Ardi Hub Main Script
local ArdiHub = {}

-- Check if game is Blox Fruits
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    game.Players.LocalPlayer:Kick("This script only works in Blox Fruits!")
    return
end

-- Load Essential Libraries
local success, result = pcall(function()
    ArdiHub.Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    ArdiHub.ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
    ArdiHub.Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Load.lua"))()
end)

if not success then
    warn("Failed to load libraries:", result)
    return
end

-- Load Core Modules
local function loadModule(name)
    local module, err = loadstring(readfile("ArdiHub_" .. name .. ".lua"))()
    if not module then
        warn("Failed to load " .. name .. ":", err)
        return nil
    end
    return module
end

-- Initialize Core Systems
ArdiHub.Security = loadModule("Security")
ArdiHub.BloxFruits = loadModule("BloxFruits")
ArdiHub.Interface = loadModule("Interface")
ArdiHub.CombatAI = loadModule("CombatAI")
ArdiHub.MovementAI = loadModule("MovementAI")

-- Create Window
local Window = ArdiHub.Rayfield:CreateWindow({
    Name = "Ardi Hub Premium | Blox Fruits",
    LoadingTitle = "Ardi Hub Loading...",
    LoadingSubtitle = "by Team Ardi",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ArdiHubConfig",
        FileName = "BloxFruits"
    },
    KeySystem = true,
    KeySettings = {
        Title = "Ardi Hub Authentication",
        Subtitle = "Key System",
        Note = "Join Discord for key (discord.gg/ardihub)",
        FileName = "ArdiKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"ARDI-PREMIUM-2025"}
    }
})

-- Create Main Tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Farm Section
local FarmSection = MainTab:CreateSection("Farming")

MainTab:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Flag = "AutoFarmLevel",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.AutoFarm = Value
        if Value then
            ArdiHub.Rayfield:Notify({
                Title = "Auto Farm",
                Content = "Started auto farming levels",
                Duration = 3
            })
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Farm Fruits",
    CurrentValue = false,
    Flag = "AutoFarmFruits",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.AutoFruits = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto Farm Chests",
    CurrentValue = false,
    Flag = "AutoFarmChests",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.AutoChest = Value
    end
})

-- Combat Section
local CombatSection = MainTab:CreateSection("Combat")

MainTab:CreateToggle({
    Name = "Auto Buso Haki",
    CurrentValue = false,
    Flag = "AutoBuso",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.BusoHaki = Value
    end
})

MainTab:CreateToggle({
    Name = "Auto Ken Haki",
    CurrentValue = false,
    Flag = "AutoKen",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.KenHaki = Value
    end
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateToggle({
    Name = "Mob ESP",
    CurrentValue = false,
    Flag = "MobESP",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.MobESP = Value
        if Value then
            ArdiHub.BloxFruits.Functions.ESP.toggleMobESP()
        else
            ArdiHub.ESP.enemy = false
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Flag = "FruitESP",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.FruitESP = Value
        if Value then
            ArdiHub.BloxFruits.Functions.ESP.toggleFruitESP()
        else
            ArdiHub.ESP.fruit = false
        end
    end
})

-- Combat Enhancement Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.Aimbot = Value
        if Value then
            ArdiHub.BloxFruits.Functions.Aiming.toggleAimbot()
        else
            ArdiHub.Aiming.Enabled = false
        end
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(Value)
        ArdiHub.BloxFruits.Settings.SilentAim = Value
        if Value then
            ArdiHub.BloxFruits.Functions.Aiming.toggleSilentAim()
        else
            ArdiHub.Aiming.Silent = false
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSlider({
    Name = "Tween Speed",
    Range = {100, 300},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 150,
    Flag = "TweenSpeed",
    Callback = function(Value)
        ArdiHub.BloxFruits.TweenSpeed = Value
    end
})

-- Initialize Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Error Handler
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        if ArdiHub.BloxFruits.Settings.AutoFarm then
            if not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                ArdiHub.Rayfield:Notify({
                    Title = "Error",
                    Content = "Character not found, respawning...",
                    Duration = 3
                })
                wait(5)
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
            end
        end
    end)
end)

-- Return the main module
return ArdiHub