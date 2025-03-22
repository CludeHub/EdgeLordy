-- EdgeLord Slap Battle --
-- Edgelord made by CludeHub/Paras/Paul/LordClude

game:GetService("Players").LocalPlayer:WaitForChild("Reset"):FireServer()
wait(5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
wait(0.1)
-- Services and Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Slap Aura Variables
local slapEnabled = false
local slapDistance = 45
local slapCooldown = 1
local lastSlapTime = 0
local slapAnimCooldown = 1  
local lastSlapAnimTime = 0  

local auraParticles = {}  -- Store aura & glitch particles
local auraVisible = true  -- Track aura visibility

-- Function to add animations, effects, and slap aura
local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Animations
    local idleAnimation = Instance.new("Animation")
    idleAnimation.AnimationId = "rbxassetid://16163355836"

    local walkAnimation = Instance.new("Animation")
    walkAnimation.AnimationId = "rbxassetid://16163350920"

    local slapAnimation = Instance.new("Animation")
    slapAnimation.AnimationId = "rbxassetid://16102717448"

    -- Load animations
    local idleAnimTrack = humanoid:LoadAnimation(idleAnimation)
    local walkAnimTrack = humanoid:LoadAnimation(walkAnimation)
    local slapAnimTrack = humanoid:LoadAnimation(slapAnimation)

    -- Loop idle and walking animations
    idleAnimTrack.Looped = true
    walkAnimTrack.Looped = true
    idleAnimTrack:Play()

    -- Play walking animation when moving
    local function updateAnimation()
        if humanoid.MoveDirection.Magnitude > 0 then
            if not walkAnimTrack.IsPlaying then
                idleAnimTrack:Stop()
                walkAnimTrack:Play()
            end
        else
            if not idleAnimTrack.IsPlaying then
                walkAnimTrack:Stop()
                idleAnimTrack:Play()
            end
        end
    end

    humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(updateAnimation)

    -- Sound for slap
    local slapSound = Instance.new("Sound")
    slapSound.SoundId = "rbxassetid://858508159"
    slapSound.Volume = 150
    slapSound.Parent = humanoidRootPart

    -- Function to create aura & glitch effects
    local function createParticles()
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local auraParticle = Instance.new("ParticleEmitter")
                auraParticle.Texture = "rbxassetid://833874434"
                auraParticle.Brightness = 6
                auraParticle.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
                auraParticle.LightEmission = 0.5
                auraParticle.Size = NumberSequence.new(1.4)
                auraParticle.Lifetime = NumberRange.new(0.5)
                auraParticle.Rate = 140
                auraParticle.Speed = NumberRange.new(2)
                auraParticle.Parent = part
                table.insert(auraParticles, auraParticle)

                local glitchParticle = Instance.new("ParticleEmitter")
                glitchParticle.Texture = "rbxassetid://3876444567"
                glitchParticle.Brightness = 0.9
                glitchParticle.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 22, 42)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(21, 42, 148)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 148))
                })
                glitchParticle.LightEmission = 0.9
                glitchParticle.Size = NumberSequence.new(1)
                glitchParticle.Lifetime = NumberRange.new(0.1)
                glitchParticle.Rate = 135
                glitchParticle.Speed = NumberRange.new(2)
                glitchParticle.Parent = part
                table.insert(auraParticles, glitchParticle)
            end
        end
    end

    createParticles()

    -- Function to activate Slap Aura
    local function activateSlapAura()
        slapEnabled = true
        wait(1)
        slapEnabled = false
    end

    -- Play slap animation with cooldown
    local function playSlapAnimation()
        if tick() - lastSlapAnimTime < slapAnimCooldown then return end  
        lastSlapAnimTime = tick()  

        slapAnimTrack:Play()
        slapAnimTrack.Looped = false
    end

    -- Slap nearest player
    local function slapClosestPlayer()
        if not slapEnabled then return end

        local closestPlayer = nil
        local closestDistance = slapDistance

        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude

                if distance <= closestDistance then
                    closestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end

        if closestPlayer and tick() - lastSlapTime >= slapCooldown then
            lastSlapTime = tick()
            local head = closestPlayer.Character:FindFirstChild("Head")
            if head then
                local args = {head}
                local generalRemote = ReplicatedStorage:FindFirstChild("GeneralHit")
                local plagueRemote = ReplicatedStorage:FindFirstChild("PlagueHit")

                if generalRemote then generalRemote:FireServer(unpack(args)) end
                if plagueRemote then plagueRemote:FireServer(unpack(args)) end

                slapSound:Play()
            end
        end
    end

    -- Continuous slap aura checking
    RunService.RenderStepped:Connect(function()
        if slapEnabled then
            slapClosestPlayer()
        end
    end)

    return activateSlapAura, playSlapAnimation
end

-- Initial setup
local activateSlapAura, playSlapAnimation = setupCharacter(player.Character)

-- Function to toggle aura visibility
local function toggleAura()
    auraVisible = not auraVisible
    for _, particle in ipairs(auraParticles) do
        particle.Enabled = auraVisible
    end
end

-- Create "Aura" toggle tool
local auraTool = Instance.new("Tool")
auraTool.RequiresHandle = false
auraTool.Name = "Aura"
auraTool.Parent = player.Backpack

-- Toggle aura on tool activation
auraTool.Activated:Connect(toggleAura)

-- Create "Telekinetic Force" tool
local slapTool = Instance.new("Tool")
slapTool.RequiresHandle = false
slapTool.Name = "Telekinetic Force"
slapTool.Parent = player.Backpack

-- When the tool is used, activate the slap aura
slapTool.Activated:Connect(function()
    playSlapAnimation()
    activateSlapAura()
end)

-- Create "Click TP" tool
local tpTool = Instance.new("Tool")
tpTool.RequiresHandle = false
tpTool.Name = "Click TP"
tpTool.Parent = player.Backpack

-- Teleport function
tpTool.Activated:Connect(function()
    local targetPosition = mouse.Hit.Position
    if targetPosition then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        end
    end
end)

local player = game.Players.LocalPlayer

local function playMusic()
    local char = player.Character or player.CharacterAdded:Wait()
    local Sound = Instance.new("Sound")
    Sound.Parent = char
    Sound.SoundId = "rbxassetid://9133844756"
    Sound.Volume = 9
    Sound.Looped = true
    Sound:Play()

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            Sound:Destroy() -- Stop the music when the player dies
        end)
    end
end

playMusic()
