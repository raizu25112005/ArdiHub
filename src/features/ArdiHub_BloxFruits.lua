-- Blox Fruits API Integration
local BloxFruits = {}

-- Import common Blox Fruits libraries
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/main/Fluent.lua"))()
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Load.lua"))()
local VirtualUser = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")

-- Initialize game services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Common Blox Fruits Functions
BloxFruits.Functions = {
    -- Auto Farm Functions
    AutoFarm = {
        Level = function()
            local mob = BloxFruits.Utils.getNearestMob()
            if mob then
                BloxFruits.Combat.attackMob(mob)
            end
        end,
        
        Fruit = function()
            local fruit = BloxFruits.Utils.getNearestFruit()
            if fruit then
                BloxFruits.Movement.collectFruit(fruit)
            end
        end,
        
        Chest = function()
            local chest = BloxFruits.Utils.getNearestChest()
            if chest then
                BloxFruits.Movement.collectChest(chest)
            end
        end
    },
    
    -- Combat Functions
    Combat = {
        useSkill = function(skill)
            VIM:SendKeyEvent(true, Enum.KeyCode[skill], false, game)
            wait(0.1)
            VIM:SendKeyEvent(false, Enum.KeyCode[skill], false, game)
        end,
        
        comboAttack = function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0,0))
        end,
        
        activateBuso = function()
            local args = {
                [1] = "Buso"
            }
            ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        end,
        
        activateKen = function()
            local args = {
                [1] = "Ken"
            }
            ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        end
    },
    
    -- Utility Functions
    Utils = {
        getNearestMob = function()
            local nearest = nil
            local minDist = math.huge
            
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = mob
                    end
                end
            end
            
            return nearest
        end,
        
        getNearestFruit = function()
            local nearest = nil
            local minDist = math.huge
            
            for _, fruit in pairs(workspace:GetChildren()) do
                if fruit.Name:find("Fruit") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - fruit.Handle.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = fruit
                    end
                end
            end
            
            return nearest
        end,
        
        getNearestChest = function()
            local nearest = nil
            local minDist = math.huge
            
            for _, chest in pairs(workspace:GetChildren()) do
                if chest.Name:find("Chest") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - chest.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = chest
                    end
                end
            end
            
            return nearest
        end
    },
    
    -- Movement Functions
    Movement = {
        tween = function(target)
            local TweenInfo = TweenInfo.new(
                (target.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude/300,
                Enum.EasingStyle.Linear
            )
            
            local Tween = TweenService:Create(
                LocalPlayer.Character.HumanoidRootPart,
                TweenInfo,
                {CFrame = target.CFrame * CFrame.new(0,2,0)}
            )
            
            Tween:Play()
            return Tween
        end,
        
        collectFruit = function(fruit)
            BloxFruits.Movement.tween(fruit.Handle)
        end,
        
        collectChest = function(chest)
            BloxFruits.Movement.tween(chest)
        end
    },
    
    -- ESP Functions
    ESP = {
        toggleMobESP = function()
            ESP:Toggle(true)
            ESP.Players = false
            ESP.Boxes = true
            ESP.Names = true
            ESP:AddObjectListener(workspace.Enemies, {
                Name = "HumanoidRootPart",
                CustomName = function(obj)
                    return obj.Parent.Name .. " | " .. math.floor(obj.Parent.Humanoid.Health) .. "/" .. math.floor(obj.Parent.Humanoid.MaxHealth)
                end,
                Color = Color3.fromRGB(255,0,0),
                IsEnabled = "enemy"
            })
            ESP.enemy = true
        end,
        
        toggleFruitESP = function()
            ESP:Toggle(true)
            ESP:AddObjectListener(workspace, {
                Name = "Handle",
                CustomName = function(obj)
                    return obj.Parent.Name
                end,
                Color = Color3.fromRGB(0,255,0),
                IsEnabled = "fruit"
            })
            ESP.fruit = true
        end,
        
        toggleChestESP = function()
            ESP:Toggle(true)
            ESP:AddObjectListener(workspace, {
                Name = "Chest",
                CustomName = "Chest",
                Color = Color3.fromRGB(255,255,0),
                IsEnabled = "chest"
            })
            ESP.chest = true
        end
    },
    
    -- Aiming Functions
    Aiming = {
        toggleAimbot = function()
            Aiming.ShowFOV = true
            Aiming.TargetPart = {"Head", "HumanoidRootPart"}
            Aiming.FOV = 250
            Aiming.Enabled = true
        end,
        
        toggleSilentAim = function()
            Aiming.Silent = true
            Aiming.ShowFOV = false
            Aiming.TargetPart = {"Head", "HumanoidRootPart"}
            Aiming.FOV = 100
            Aiming.Enabled = true
        end
    }
}

-- Auto Farm Settings
BloxFruits.Settings = {
    AutoFarm = false,
    AutoFruits = false,
    AutoChest = false,
    BusoHaki = false,
    KenHaki = false,
    MobESP = false,
    FruitESP = false,
    ChestESP = false,
    Aimbot = false,
    SilentAim = false
}

-- Main Loop
RunService.Heartbeat:Connect(function()
    if BloxFruits.Settings.AutoFarm then
        BloxFruits.Functions.AutoFarm.Level()
    end
    
    if BloxFruits.Settings.AutoFruits then
        BloxFruits.Functions.AutoFarm.Fruit()
    end
    
    if BloxFruits.Settings.AutoChest then
        BloxFruits.Functions.AutoFarm.Chest()
    end
    
    if BloxFruits.Settings.BusoHaki then
        BloxFruits.Functions.Combat.activateBuso()
    end
    
    if BloxFruits.Settings.KenHaki then
        BloxFruits.Functions.Combat.activateKen()
    end
end)

return BloxFruits