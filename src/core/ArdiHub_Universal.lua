-- Ardi Hub Universal Loader
local supported = {
    ["Synapse X"] = true,
    ["ScriptWare"] = true,
    ["Krnl"] = true,
    ["Fluxus"] = true,
    ["Oxygen U"] = true,
    ["Electron"] = true,
    ["Temple"] = true,
    ["Comet"] = true,
    ["EasyExploits"] = true
}

-- Detect Executor
local executor = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "Unknown"

-- Universal Functions
local function httpRequest(url)
    local success, result
    
    -- Try different http request methods
    if syn and syn.request then
        success, result = pcall(function()
            return syn.request({url = url}).Body
        end)
    elseif http and http.request then
        success, result = pcall(function()
            return http.request({url = url})
        end)
    elseif request then
        success, result = pcall(function()
            return request({url = url}).Body
        end)
    elseif http_request then
        success, result = pcall(function()
            return http_request({url = url}).Body
        end)
    elseif game.HttpGet then
        success, result = pcall(function()
            return game:HttpGet(url)
        end)
    end
    
    if success and result then
        return result
    else
        error("Failed to make HTTP request")
    end
end

-- Universal Mouse Functions
local function createUniversalMouse()
    local mouse = {
        Target = nil,
        Hit = CFrame.new(),
        X = 0,
        Y = 0
    }
    
    -- Update mouse position
    game:GetService("RunService").RenderStepped:Connect(function()
        local mouseLocation = game:GetService("UserInputService"):GetMouseLocation()
        mouse.X = mouseLocation.X
        mouse.Y = mouseLocation.Y
        
        local raycastResult = workspace:Raycast(
            workspace.CurrentCamera.CFrame.Position,
            workspace.CurrentCamera.CFrame.LookVector * 1000
        )
        
        if raycastResult then
            mouse.Hit = CFrame.new(raycastResult.Position)
            mouse.Target = raycastResult.Instance
        end
    end)
    
    return mouse
end

-- Universal Input Functions
local function simulateInput(inputType, keyCode)
    if keypress and keyrelease then
        -- KRNL style
        if inputType == "keydown" then
            keypress(keyCode)
        else
            keyrelease(keyCode)
        end
    elseif syn and syn.key then
        -- Synapse style
        if inputType == "keydown" then
            syn.key.press(keyCode)
        else
            syn.key.release(keyCode)
        end
    else
        -- Virtual Input Manager fallback
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(inputType == "keydown", keyCode, false, game)
    end
end

-- Universal Drawing Functions
local function createDrawing(type, properties)
    local drawing
    
    if Drawing then
        -- Modern exploits
        drawing = Drawing.new(type)
    elseif syn and syn.create_drawing then
        -- Synapse fallback
        drawing = syn.create_drawing(type)
    else
        -- Basic fallback using Instance
        drawing = Instance.new(type == "Square" and "Frame" or type == "Text" and "TextLabel" or "Frame")
        drawing.Parent = game:GetService("CoreGui")
    end
    
    -- Apply properties
    for prop, value in pairs(properties) do
        drawing[prop] = value
    end
    
    return drawing
end

-- Load UI Library with fallbacks
local function loadUILibrary()
    local success, ui
    
    -- Try Rayfield
    success, ui = pcall(function()
        return loadstring(httpRequest('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    end)
    
    if not success then
        -- Try Orion
        success, ui = pcall(function()
            return loadstring(httpRequest('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
        end)
    end
    
    if not success then
        -- Fallback to basic UI
        success, ui = pcall(function()
            return loadstring(httpRequest('https://raw.githubusercontent.com/raizu25112005/ArdiHub/master/src/utils/BasicUI.lua'))()
        end)
    end
    
    if not success then
        error("Failed to load UI library")
    end
    
    return ui
end

-- Check game
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    return warn("This script only works in Blox Fruits!")
end

-- Print executor info
print("Current Executor:", executor)
print("Supported:", supported[executor] and "Yes" or "Limited")

-- Create universal environment
getgenv().ArdiHub = {
    Executor = executor,
    Mouse = createUniversalMouse(),
    SimulateInput = simulateInput,
    CreateDrawing = createDrawing,
    HttpRequest = httpRequest
}

-- Load main script with error handling
local success, error = pcall(function()
    loadstring(httpRequest('https://raw.githubusercontent.com/raizu25112005/ArdiHub/master/src/core/ArdiHub_Loader_Simple.lua'))()
end)

if not success then
    warn("Failed to load script:", error)
    -- Try loading backup version
    pcall(function()
        loadstring(httpRequest('https://raw.githubusercontent.com/raizu25112005/ArdiHub/master/src/core/ArdiHub_Loader_Backup.lua'))()
    end)
end

return getgenv().ArdiHub