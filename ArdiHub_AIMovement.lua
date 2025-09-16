-- Advanced AI Movement Patterns
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local AIMovement = {}

-- Advanced pathfinding with obstacle avoidance
function AIMovement.calculatePath(start, target)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4
    })

    local success, errorMessage = pcall(function()
        path:ComputeAsync(start, target)
    end)

    if success and path.Status == Enum.PathStatus.Success then
        return path:GetWaypoints()
    end
    return nil
end

-- Natural movement between waypoints
function AIMovement.moveToWaypoint(character, waypoint)
    if not character or not character:FindFirstChild("Humanoid") then return end
    
    local humanoid = character.Humanoid
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Random speed variations
    local speed = math.random(12, 16)
    humanoid.WalkSpeed = speed

    -- Calculate movement direction
    local direction = (waypoint.Position - rootPart.Position).Unit
    local targetCFrame = CFrame.new(waypoint.Position, waypoint.Position + direction)

    -- Smooth rotation
    local rotationTween = game:GetService("TweenService"):Create(rootPart, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quad), 
        {CFrame = targetCFrame}
    )
    rotationTween:Play()

    -- Jump if needed
    if waypoint.Action == Enum.PathWaypointAction.Jump then
        wait(math.random(0.1, 0.3))
        humanoid.Jump = true
    end
end

-- Combat movement patterns
function AIMovement.combatMovement(character, target)
    if not character or not target then return end

    local patterns = {
        circleStrafe = function()
            local angle = 0
            local radius = math.random(8, 12)
            
            while angle < 360 do
                local targetPos = target.Position + Vector3.new(
                    math.cos(math.rad(angle)) * radius,
                    0,
                    math.sin(math.rad(angle)) * radius
                )
                AIMovement.moveToWaypoint(character, {Position = targetPos})
                angle = angle + math.random(20, 40)
                wait(0.1)
            end
        end,
        
        zigzag = function()
            local offset = 5
            local forward = target.CFrame.LookVector * 10
            
            for i = 1, 4 do
                local targetPos = target.Position + forward + Vector3.new(offset, 0, 0)
                AIMovement.moveToWaypoint(character, {Position = targetPos})
                offset = -offset
                wait(0.2)
            end
        end,
        
        retreat = function()
            local retreatDist = math.random(15, 20)
            local retreatPos = character.Position - target.CFrame.LookVector * retreatDist
            AIMovement.moveToWaypoint(character, {Position = retreatPos})
        end
    }

    -- Randomly select and execute movement pattern
    local patternNames = {"circleStrafe", "zigzag", "retreat"}
    local selectedPattern = patterns[patternNames[math.random(1, #patternNames)]]
    selectedPattern()
end

-- Environment awareness
function AIMovement.scanEnvironment(character)
    local results = {}
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return results end

    -- Scan for nearby objects
    local nearbyObjects = workspace:GetPartBoundsInRadius(rootPart.Position, 50)
    
    for _, obj in pairs(nearbyObjects) do
        if obj.Parent:FindFirstChild("Humanoid") then
            table.insert(results, {
                type = "entity",
                position = obj.Position,
                distance = (obj.Position - rootPart.Position).Magnitude
            })
        elseif obj.CanCollide then
            table.insert(results, {
                type = "obstacle",
                position = obj.Position,
                size = obj.Size
            })
        end
    end

    return results
end

-- Adaptive movement based on environment
function AIMovement.adaptiveMovement(character, target, environment)
    local obstacles = environment.obstacles or {}
    local entities = environment.entities or {}
    
    -- Check for nearby threats
    local threats = #entities > 0
    local crowded = #obstacles > 5
    
    if threats then
        -- Evasive movement
        AIMovement.combatMovement(character, target)
    elseif crowded then
        -- Careful navigation
        local path = AIMovement.calculatePath(character.Position, target.Position)
        if path then
            for _, waypoint in ipairs(path) do
                AIMovement.moveToWaypoint(character, waypoint)
                wait(0.1)
            end
        end
    else
        -- Direct approach
        AIMovement.moveToWaypoint(character, {Position = target.Position})
    end
end

return AIMovement