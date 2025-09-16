-- Ardi Hub Basic UI Library
local BasicUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Constants
local TWEEN_TIME = 0.3
local PADDING = 10

-- Create base GUI
function BasicUI.createWindow(config)
    local window = Instance.new("ScreenGui")
    window.Name = config.Name or "ArdiHub"
    window.Parent = CoreGui
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 300, 0, 400)
    main.Position = UDim2.new(0.5, -150, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    main.Parent = window
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.BorderSizePixel = 0
    title.Text = config.Name or "Ardi Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Parent = main
    
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, -30)
    container.Position = UDim2.new(0, 0, 0, 30)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 4
    container.Parent = main
    
    -- Make window draggable
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    return {
        Window = window,
        Container = container,
        
        -- Create button
        CreateButton = function(name, callback)
            local button = Instance.new("TextButton")
            button.Name = name
            button.Size = UDim2.new(1, -PADDING*2, 0, 30)
            button.Position = UDim2.new(0, PADDING, 0, #container:GetChildren() * 40 + PADDING)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            button.BorderSizePixel = 0
            button.Text = name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Parent = container
            
            button.MouseButton1Click:Connect(callback)
            
            -- Hover effect
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(TWEEN_TIME), {
                    BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                }):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(TWEEN_TIME), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                }):Play()
            end)
            
            container.CanvasSize = UDim2.new(0, 0, 0, #container:GetChildren() * 40 + PADDING*2)
        end,
        
        -- Create toggle
        CreateToggle = function(name, callback)
            local toggle = Instance.new("Frame")
            toggle.Name = name
            toggle.Size = UDim2.new(1, -PADDING*2, 0, 30)
            toggle.Position = UDim2.new(0, PADDING, 0, #container:GetChildren() * 40 + PADDING)
            toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggle.BorderSizePixel = 0
            toggle.Parent = container
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -40, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggle
            
            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 20, 0, 20)
            indicator.Position = UDim2.new(1, -25, 0.5, -10)
            indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            indicator.BorderSizePixel = 0
            indicator.Parent = toggle
            
            local isEnabled = false
            
            toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isEnabled = not isEnabled
                    
                    TweenService:Create(indicator, TweenInfo.new(TWEEN_TIME), {
                        BackgroundColor3 = isEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
                    }):Play()
                    
                    callback(isEnabled)
                end
            end)
            
            container.CanvasSize = UDim2.new(0, 0, 0, #container:GetChildren() * 40 + PADDING*2)
        end,
        
        -- Create dropdown
        CreateDropdown = function(name, options, callback)
            local dropdown = Instance.new("Frame")
            dropdown.Name = name
            dropdown.Size = UDim2.new(1, -PADDING*2, 0, 30)
            dropdown.Position = UDim2.new(0, PADDING, 0, #container:GetChildren() * 40 + PADDING)
            dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdown.BorderSizePixel = 0
            dropdown.Parent = container
            
            local label = Instance.new("TextButton")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Parent = dropdown
            
            local optionContainer = Instance.new("Frame")
            optionContainer.Size = UDim2.new(1, 0, 0, 0)
            optionContainer.Position = UDim2.new(0, 0, 1, 0)
            optionContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            optionContainer.BorderSizePixel = 0
            optionContainer.ClipsDescendants = true
            optionContainer.Parent = dropdown
            
            local isOpen = false
            
            label.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                TweenService:Create(optionContainer, TweenInfo.new(TWEEN_TIME), {
                    Size = isOpen and UDim2.new(1, 0, 0, #options * 30) or UDim2.new(1, 0, 0, 0)
                }):Play()
            end)
            
            for i, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
                optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                optionButton.BorderSizePixel = 0
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.TextSize = 14
                optionButton.Parent = optionContainer
                
                optionButton.MouseButton1Click:Connect(function()
                    label.Text = name .. ": " .. option
                    callback(option)
                    
                    TweenService:Create(optionContainer, TweenInfo.new(TWEEN_TIME), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    isOpen = false
                end)
            end
            
            container.CanvasSize = UDim2.new(0, 0, 0, #container:GetChildren() * 40 + PADDING*2)
        end
    }
end

return BasicUI