-- Ardi Hub Test Version
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Wrong Game",
        Text = "This script only works in Blox Fruits!",
        Duration = 5
    })
    return
end

-- Create Basic UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArdiHubGUI"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BorderSizePixel = 0
Title.Text = "Ardi Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Parent = MainFrame

-- Auto Farm Button
local AutoFarmButton = Instance.new("TextButton")
AutoFarmButton.Name = "AutoFarmButton"
AutoFarmButton.Size = UDim2.new(0.8, 0, 0, 40)
AutoFarmButton.Position = UDim2.new(0.1, 0, 0.2, 0)
AutoFarmButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoFarmButton.BorderSizePixel = 0
AutoFarmButton.Text = "Auto Farm: OFF"
AutoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmButton.TextSize = 16
AutoFarmButton.Parent = MainFrame

-- Auto Farm Function
local autoFarmEnabled = false
AutoFarmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    AutoFarmButton.Text = "Auto Farm: " .. (autoFarmEnabled and "ON" or "OFF")
    AutoFarmButton.BackgroundColor3 = autoFarmEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    
    if autoFarmEnabled then
        spawn(function()
            while autoFarmEnabled do
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
end)

-- Fast Attack Button
local FastAttackButton = Instance.new("TextButton")
FastAttackButton.Name = "FastAttackButton"
FastAttackButton.Size = UDim2.new(0.8, 0, 0, 40)
FastAttackButton.Position = UDim2.new(0.1, 0, 0.4, 0)
FastAttackButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FastAttackButton.BorderSizePixel = 0
FastAttackButton.Text = "Fast Attack: OFF"
FastAttackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FastAttackButton.TextSize = 16
FastAttackButton.Parent = MainFrame

-- Fast Attack Function
local fastAttackEnabled = false
FastAttackButton.MouseButton1Click:Connect(function()
    fastAttackEnabled = not fastAttackEnabled
    FastAttackButton.Text = "Fast Attack: " .. (fastAttackEnabled and "ON" or "OFF")
    FastAttackButton.BackgroundColor3 = fastAttackEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    
    if fastAttackEnabled then
        spawn(function()
            local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
            local CameraShakerR = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework.CameraShaker)
            
            while fastAttackEnabled do
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
end)

-- Auto Skills Button
local AutoSkillsButton = Instance.new("TextButton")
AutoSkillsButton.Name = "AutoSkillsButton"
AutoSkillsButton.Size = UDim2.new(0.8, 0, 0, 40)
AutoSkillsButton.Position = UDim2.new(0.1, 0, 0.6, 0)
AutoSkillsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AutoSkillsButton.BorderSizePixel = 0
AutoSkillsButton.Text = "Auto Skills: OFF"
AutoSkillsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoSkillsButton.TextSize = 16
AutoSkillsButton.Parent = MainFrame

-- Auto Skills Function
local autoSkillsEnabled = false
AutoSkillsButton.MouseButton1Click:Connect(function()
    autoSkillsEnabled = not autoSkillsEnabled
    AutoSkillsButton.Text = "Auto Skills: " .. (autoSkillsEnabled and "ON" or "OFF")
    AutoSkillsButton.BackgroundColor3 = autoSkillsEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
    
    if autoSkillsEnabled then
        spawn(function()
            while autoSkillsEnabled do
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
end)

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Ardi Hub Loaded!",
    Text = "Basic version loaded successfully.",
    Duration = 5
})

return ScreenGui