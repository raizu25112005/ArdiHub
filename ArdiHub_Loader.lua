--[[
    Ardi Hub Loader
    Version: 1.0.0
    Game: Blox Fruits
    Discord: Coming Soon
]]

-- Check game
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Ardi Hub",
        Text = "This script only works in Blox Fruits!",
        Duration = 5
    })
    return
end

-- Initialize Global Variables
getgenv().AutoFarm = false
getgenv().AutoBoss = false
getgenv().SubmergeQuest = false
getgenv().FastAttack = false
getgenv().AutoHaki = true
getgenv().AntiAFK = true
getgenv().TweenSpeed = 300
getgenv().SelectedBoss = "Cursed Captain"

-- Anti-Ban Setup
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then
        return wait(9e9)
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- Load Components
local success, error = pcall(function()
    -- Load Anti-Detection System
    local AntiDetection = loadstring(game:HttpGet('https://raw.githubusercontent.com/raizu25112005/ArdihubBF/main/antidetection.lua'))()
    
    -- Initialize Anti-Detection
    AntiDetection.InitializeAntiDetection()
    
    -- Load Main Functions with AI behavior
    local Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/raizu25112005/ArdihubBF/main/functions.lua'))()
    
    -- Load UI Interface
    loadstring(game:HttpGet('https://raw.githubusercontent.com/raizu25112005/ArdihubBF/main/interface.lua'))()
    
    -- Replace normal auto farm with AI version
    getgenv().AutoFarmFunction = AntiDetection.AutoFarmWithAI
end)

if not success then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Ardi Hub Error",
        Text = tostring(error),
        Duration = 5
    })
end