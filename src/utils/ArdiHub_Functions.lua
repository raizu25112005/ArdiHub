-- Main Functions for Blox Fruits
-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Error Handling Function
local function SafeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Ardi Hub Error: " .. tostring(result))
        return nil
    end
    return result
end

-- Player Variables
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("Ardi Hub Error: LocalPlayer not found")
    return
end

-- Character Handler
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local function setupCharacter(char)
    if not char then return end
    
    local Humanoid = char:WaitForChild("Humanoid", 5)
    local HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)
    
    if not Humanoid or not HumanoidRootPart then
        warn("Ardi Hub Error: Character parts not found")
        return
    end
    
    return Humanoid, HumanoidRootPart
end

local Humanoid, HumanoidRootPart = setupCharacter(Character)

-- Character Added Handler
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid, HumanoidRootPart = setupCharacter(newCharacter)
end)

-- Check if Remote Events exist
local function checkRemotes()
    local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_", 10)
    if not CommF then
        warn("Ardi Hub Error: Required remotes not found")
        return false
    end
    return true
end

if not checkRemotes() then
    warn("Ardi Hub Error: Game not fully loaded. Please wait and retry.")
    return
end

-- Auto Farm Functions
function AutoFarmLevel()
    spawn(function()
        while getgenv().AutoFarm do
            if not Character or not HumanoidRootPart or not Humanoid then
                Character = LocalPlayer.Character
                if Character then
                    Humanoid, HumanoidRootPart = setupCharacter(Character)
                end
                wait(1)
                continue
            end

            SafeCall(function()
                -- Check if GUI exists
                local MainGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main", 5)
                if not MainGui then
                    warn("Ardi Hub Error: Main GUI not found")
                    wait(1)
                    return
                end

                -- Check for quest
                local QuestGui = MainGui:FindFirstChild("Quest")
                if QuestGui and not QuestGui.Visible then
                    -- Get nearest NPC quest
                    local QuestNPC = getNearestQuestNPC()
                    if QuestNPC and QuestNPC:FindFirstChild("HumanoidRootPart") then
                        SafeCall(function()
                            tween(QuestNPC.HumanoidRootPart.CFrame)
                            wait(1)
                            if QuestNPC:FindFirstChild("ProximityPrompt") then
                                fireproximityprompt(QuestNPC.ProximityPrompt)
                            end
                        end)
                    end
                end

                -- Get target mob
                local Mob = getNearestMob()
                if Mob then
                    -- Enable Haki if available
                    if getgenv().AutoHaki then
                        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                        end
                    end

                    -- Attack mob
                    tween(Mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    attackMob(Mob)
                end
            end)
            wait()
        end
    end)
end

-- Boss Functions
function AutoBoss()
    spawn(function()
        while getgenv().AutoBoss do
            pcall(function()
                local Boss = getBoss(getgenv().SelectedBoss)
                if Boss then
                    -- Enable Haki
                    if getgenv().AutoHaki then
                        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                        end
                    end

                    -- Attack boss
                    tween(Boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    attackMob(Boss)
                end
            end)
            wait()
        end
    end)
end

-- Submerge Quest Functions
function AutoSubmergeQuest()
    spawn(function()
        while getgenv().SubmergeQuest do
            pcall(function()
                -- Check if in correct sea
                if not checkSea(3) then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
                    wait(3)
                end

                -- Get quest if not active
                if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    local Args = {
                        [1] = "StartQuest",
                        [2] = "SubmergeQuest",
                        [3] = 1
                    }
                    ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(Args))
                end

                -- Find and collect quest items
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "SubmergeQuestItem" and v:FindFirstChild("Handle") then
                        tween(v.Handle.CFrame)
                        wait(1)
                        fireproximityprompt(v.Handle.ProximityPrompt)
                    end
                end
            end)
            wait(1)
        end
    end)
end

-- Helper Functions
function tween(targetCFrame)
    if not HumanoidRootPart or not targetCFrame then
        warn("Ardi Hub Error: Invalid tween parameters")
        return
    end

    return SafeCall(function()
        -- Check if player is already close to target
        local Distance = (HumanoidRootPart.Position - targetCFrame.Position).Magnitude
        if Distance < 10 then return end

        -- Calculate tween duration
        local Time = Distance/getgenv().TweenSpeed
        Time = math.clamp(Time, 0.1, 20) -- Prevent too short or too long tweens

        -- Create and execute tween
        local Tween = TweenService:Create(
            HumanoidRootPart, 
            TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
            {CFrame = targetCFrame}
        )

        -- Add error handling for tween
        local success, _ = pcall(function()
            Tween:Play()
            Tween.Completed:Wait()
        end)

        if not success then
            warn("Ardi Hub Error: Tween failed")
            Tween:Cancel()
        end
    end)
end

function attackMob(mob)
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then
        warn("Ardi Hub Error: Invalid mob for attack")
        return
    end

    return SafeCall(function()
        local args = {
            [1] = mob.HumanoidRootPart.Position
        }
        
        local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
        if not CommF then
            warn("Ardi Hub Error: Combat remote not found")
            return
        }
        
        -- Fast Attack with error handling
        if getgenv().FastAttack then
            for i = 1, 3 do
                SafeCall(function()
                    CommF:InvokeServer("Combat", unpack(args))
                    wait(getgenv().FastAttackDelay or 0.1)
                end)
            end
        else
            SafeCall(function()
                CommF:InvokeServer("Combat", unpack(args))
            end)
        end
    end)
end

function getNearestMob()
    local nearest = nil
    local minDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and 
           mob:FindFirstChild("HumanoidRootPart") and 
           mob.Humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if distance < minDistance then
                minDistance = distance
                nearest = mob
            end
        end
    end
    
    return nearest
end

function getBoss(bossName)
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name == bossName and 
           mob:FindFirstChild("Humanoid") and 
           mob:FindFirstChild("HumanoidRootPart") and 
           mob.Humanoid.Health > 0 then
            return mob
        end
    end
    return nil
end

function checkSea(seaNumber)
    local placeid = game.PlaceId
    if seaNumber == 1 then
        return placeid == 2753915549
    elseif seaNumber == 2 then
        return placeid == 4442272183
    elseif seaNumber == 3 then
        return placeid == 7449423635
    end
    return false
end

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Global Settings
getgenv().TweenSpeed = 300 -- Adjust this for faster/slower movement
getgenv().FastAttackDelay = 0.1 -- Adjust this for faster/slower attacks

-- Return functions for use in UI
return {
    AutoFarmLevel = AutoFarmLevel,
    AutoBoss = AutoBoss,
    AutoSubmergeQuest = AutoSubmergeQuest,
    checkSea = checkSea
}