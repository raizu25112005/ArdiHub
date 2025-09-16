-- Advanced Movement AI System
local MovementAI = {}

-- Import dependencies
local DeepLearning = require("ArdiHub_DeepLearning")

-- Movement States
MovementAI.States = {
    IDLE = "idle",
    WALKING = "walking",
    RUNNING = "running",
    JUMPING = "jumping",
    DODGING = "dodging"
}

-- Movement Parameters
local MovementConfig = {
    walkSpeed = {min = 12, max = 16},
    runSpeed = {min = 20, max = 25},
    jumpPower = {min = 45, max = 55},
    turnSpeed = {min = 0.1, max = 0.3}
}

-- Initialize movement system
function MovementAI.init()
    -- Setup neural network for movement prediction
    local networkStructure = {
        inputSize = 10,  -- Position, velocity, surrounding data
        hiddenLayers = {16, 8},
        outputSize = 4   -- Movement directions + action
    }
    
    DeepLearning.initializeNetwork(networkStructure)
    
    return true
end

-- Path finding with natural movement
function MovementAI.findPath(start, target)
    local path = {}
    local currentPos = start
    
    while (currentPos - target).Magnitude > 1 do
        -- Calculate next position with natural deviation
        local direction = (target - currentPos).Unit
        local deviation = Vector3.new(
            math.random(-0.1, 0.1),
            0,
            math.random(-0.1, 0.1)
        )
        
        local nextPos = currentPos + (direction + deviation) * 5
        table.insert(path, nextPos)
        
        currentPos = nextPos
    end
    
    return path
end

-- Natural movement execution
function MovementAI.move(character, target)
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Apply natural movement variations
    local function naturalizeMovement()
        -- Randomize movement parameters slightly
        local walkSpeed = math.random(
            MovementConfig.walkSpeed.min,
            MovementConfig.walkSpeed.max
        )
        
        local turnSpeed = math.random(
            MovementConfig.turnSpeed.min,
            MovementConfig.turnSpeed.max
        )
        
        -- Apply with smooth transition
        local currentSpeed = humanoid.WalkSpeed
        local targetSpeed = walkSpeed
        
        -- Smooth speed transition
        game:GetService("RunService").Heartbeat:Connect(function(dt)
            currentSpeed = currentSpeed + (targetSpeed - currentSpeed) * turnSpeed
            humanoid.WalkSpeed = currentSpeed
        end)
    end
    
    -- Calculate path with natural curves
    local path = MovementAI.findPath(rootPart.Position, target)
    
    -- Execute movement with human-like behavior
    for _, position in ipairs(path) do
        -- Add slight delay for natural movement
        wait(math.random() * 0.1)
        
        -- Look towards target with smooth turning
        local lookAt = CFrame.lookAt(rootPart.Position, position)
        local currentRot = rootPart.CFrame.Rotation
        local targetRot = lookAt.Rotation
        
        -- Smooth rotation
        for i = 0, 1, 0.1 do
            rootPart.CFrame = CFrame.new(rootPart.Position) *
                currentRot:Lerp(targetRot, i)
            wait()
        end
        
        -- Move to position
        humanoid:MoveTo(position)
        
        -- Random jump chance
        if math.random() < 0.1 then
            humanoid.Jump = true
        end
    end
end

-- Advanced movement patterns
function MovementAI.executePattern(pattern, target)
    local patterns = {
        circle = function(radius)
            local center = target
            local angle = 0
            local steps = 36
            
            for i = 1, steps do
                angle = angle + (math.pi * 2) / steps
                local offset = Vector3.new(
                    math.cos(angle) * radius,
                    0,
                    math.sin(angle) * radius
                )
                local position = center + offset
                MovementAI.move(game.Players.LocalPlayer.Character, position)
                wait(0.1)
            end
        end,
        
        zigzag = function(distance)
            local start = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            local direction = (target - start).Unit
            local right = Vector3.new(-direction.Z, 0, direction.X)
            
            for i = 1, 5 do
                local offset = right * (i % 2 == 0 and distance or -distance)
                local position = start + direction * (i * distance) + offset
                MovementAI.move(game.Players.LocalPlayer.Character, position)
                wait(0.2)
            end
        end,
        
        approach = function()
            local character = game.Players.LocalPlayer.Character
            local distance = (target - character.HumanoidRootPart.Position).Magnitude
            
            while distance > 5 do
                -- Calculate approach vector with slight variation
                local direction = (target - character.HumanoidRootPart.Position).Unit
                local variation = Vector3.new(
                    math.random(-0.1, 0.1),
                    0,
                    math.random(-0.1, 0.1)
                )
                
                local nextPos = character.HumanoidRootPart.Position +
                    (direction + variation) * 5
                
                MovementAI.move(character, nextPos)
                
                distance = (target - character.HumanoidRootPart.Position).Magnitude
                wait(0.1)
            end
        end
    }
    
    if patterns[pattern] then
        patterns[pattern](10) -- Default radius/distance
    end
end

-- Collision avoidance system
function MovementAI.avoidCollision(character, obstacle)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Calculate avoidance direction
    local awayVector = (rootPart.Position - obstacle.Position).Unit
    local avoidancePoint = rootPart.Position + awayVector * 10
    
    -- Execute avoidance movement
    MovementAI.move(character, avoidancePoint)
end

-- Environmental awareness
function MovementAI.scanEnvironment(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return {} end
    
    local environment = {
        obstacles = {},
        players = {},
        terrain = {}
    }
    
    -- Scan for nearby objects
    local radius = 50
    local objects = game.Workspace:GetPartBoundsInRadius(
        rootPart.Position,
        radius
    )
    
    -- Categorize objects
    for _, object in ipairs(objects) do
        if object.ClassName == "Part" then
            table.insert(environment.obstacles, {
                position = object.Position,
                size = object.Size
            })
        end
    end
    
    -- Scan for players
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character and player ~= game.Players.LocalPlayer then
            local distance = (player.Character.HumanoidRootPart.Position -
                rootPart.Position).Magnitude
            
            if distance <= radius then
                table.insert(environment.players, {
                    player = player,
                    distance = distance,
                    position = player.Character.HumanoidRootPart.Position
                })
            end
        end
    end
    
    return environment
end

return MovementAI