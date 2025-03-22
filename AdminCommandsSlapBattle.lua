local player = game:GetService("Players").LocalPlayer

player.Chatted:Connect(function(msg)
    if msg == "/e glove Edgelord" then
        loadstring([[
            -- EdgeLord Slap Battle --
            -- Edgelord made by CludeHub/Paras/Paul/LordClude

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

            local auraParticles = {}  
            local auraVisible = true  

            local function setupCharacter(character)
                local humanoid = character:WaitForChild("Humanoid")
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

                local idleAnimation = Instance.new("Animation")
                idleAnimation.AnimationId = "rbxassetid://16163355836"

                local walkAnimation = Instance.new("Animation")
                walkAnimation.AnimationId = "rbxassetid://16163350920"

                local slapAnimation = Instance.new("Animation")
                slapAnimation.AnimationId = "rbxassetid://16102717448"

                local idleAnimTrack = humanoid:LoadAnimation(idleAnimation)
                local walkAnimTrack = humanoid:LoadAnimation(walkAnimation)
                local slapAnimTrack = humanoid:LoadAnimation(slapAnimation)

                idleAnimTrack.Looped = true
                walkAnimTrack.Looped = true
                idleAnimTrack:Play()

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

                local slapSound = Instance.new("Sound")
                slapSound.SoundId = "rbxassetid://858508159"
                slapSound.Volume = 150
                slapSound.Parent = humanoidRootPart

                local function createParticles()
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            local auraParticle = Instance.new("ParticleEmitter")
                            auraParticle.Texture = "rbxassetid://833874434"
                            auraParticle.Brightness = 2
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
                            glitchParticle.Rate = 145
                            glitchParticle.Speed = NumberRange.new(2)
                            glitchParticle.Parent = part
                            table.insert(auraParticles, glitchParticle)
                        end
                    end
                end

                createParticles()

                local function activateSlapAura()
                    slapEnabled = true
                    wait(1)
                    slapEnabled = false
                end

                local function playSlapAnimation()
                    if tick() - lastSlapAnimTime < slapAnimCooldown then return end  
                    lastSlapAnimTime = tick()  

                    slapAnimTrack:Play()
                    slapAnimTrack.Looped = false
                end

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

                RunService.RenderStepped:Connect(function()
                    if slapEnabled then
                        slapClosestPlayer()
                    end
                end)

                return activateSlapAura, playSlapAnimation
            end

            local activateSlapAura, playSlapAnimation = setupCharacter(player.Character)

            local function toggleAura()
                auraVisible = not auraVisible
                for _, particle in ipairs(auraParticles) do
                    particle.Enabled = auraVisible
                end
            end

            local auraTool = Instance.new("Tool")
            auraTool.RequiresHandle = false
            auraTool.Name = "Aura"
            auraTool.Parent = player.Backpack

            auraTool.Activated:Connect(toggleAura)

            local slapTool = Instance.new("Tool")
            slapTool.RequiresHandle = false
            slapTool.Name = "Telekinetic"
            slapTool.Parent = player.Backpack

            slapTool.Activated:Connect(function()
                playSlapAnimation()
                activateSlapAura()
            end)

            local tpTool = Instance.new("Tool")
            tpTool.RequiresHandle = false
            tpTool.Name = "Click TP"
            tpTool.Parent = player.Backpack

            tpTool.Activated:Connect(function()
                local targetPosition = player:GetMouse().Hit.Position
                if targetPosition then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
                    end
                end
            end)

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
                        Sound:Destroy()
                    end)
                end
            end

            playMusic()
        ]])()
    end
end)

local player = game:GetService("Players").LocalPlayer

local function setNametag(text)
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:FindFirstChild("Head")

    if head then  
        local existingTag = head:FindFirstChild("Nametag")  
        if existingTag then  
            existingTag:Destroy()  
        end  

        local billboard = Instance.new("BillboardGui")  
        billboard.Name = "Nametag"  
        billboard.Size = UDim2.new(3, 0, 1, 0)  
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)  
        billboard.Adornee = head  
        billboard.Parent = head  

        local textLabel = Instance.new("TextLabel")  
        textLabel.Size = UDim2.new(1, 0, 1, 0)  
        textLabel.BackgroundTransparency = 1  
        textLabel.Text = text  
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)  
        textLabel.TextStrokeTransparency = 0  
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  
        textLabel.TextScaled = true  
        textLabel.Font = Enum.Font.SourceSansBold  
        textLabel.Parent = billboard  
    end
end

-- This function will be called when the player's character respawns
local function onCharacterAdded(character)
    local name = player.Name  -- or any default name
    setNametag(name)
end

-- Listen for the player's character respawn
player.CharacterAdded:Connect(onCharacterAdded)

-- Initial nametag setup in case the player is already in the game
if player.Character then
    onCharacterAdded(player.Character)
end

-- Handling custom name change via chat command
player.Chatted:Connect(function(msg)
    local args = string.split(msg, " ")
    if args[1] == "/e" and args[2] == "setname" then
        local name = msg:sub(#"/e setname " + 1)
        if name and name ~= "" then
            setNametag(name)
        end
    end
end)

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

-- Create the main frame to hold the buttons
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0.5, -100, 0.5, -25)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0

-- Add UICorner for rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame

-- Create the "Die" button (initially green)
local dieButton = Instance.new("TextButton")
dieButton.Parent = frame
dieButton.Size = UDim2.new(0.1, 90, 1, -19)
dieButton.Position = UDim2.new(0, 181, -4, 0)
dieButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
dieButton.Text = "Die"
dieButton.TextColor3 = Color3.fromRGB(0, 0, 0)
dieButton.Font = Enum.Font.SourceSans
dieButton.TextSize = 18

-- Add UICorner to the "Die" button
local dieButtonUICorner = Instance.new("UICorner")
dieButtonUICorner.CornerRadius = UDim.new(0, 5)
dieButtonUICorner.Parent = dieButton

-- Create the "Touchey" button (toggle)
local toucheyButton = Instance.new("TextButton")
toucheyButton.Parent = frame
toucheyButton.Size = UDim2.new(0.1, 90, 1, -19)
toucheyButton.Position = UDim2.new(0, 300, -4, 0)
toucheyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toucheyButton.Text = "Touchey"
toucheyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toucheyButton.Font = Enum.Font.SourceSans
toucheyButton.TextSize = 18

-- Add UICorner to the "Touchey" button
local toucheyButtonUICorner = Instance.new("UICorner")
toucheyButtonUICorner.CornerRadius = UDim.new(0, 5)
toucheyButtonUICorner.Parent = toucheyButton

-- Variables for fling functionality
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local hiddenfling = false
local flingThread
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1

    while hiddenfling do
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

-- "Die" button functionality
dieButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    if dieButton.BackgroundColor3 == Color3.fromRGB(0, 255, 0) then
        dieButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Change button to red
        dieButton.Text = "Die'nt"  -- Change text to "Die'nt"
        game:GetService("Players").LocalPlayer.Reset:FireServer()

        wait(5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0, -5, 0)
        print("Godmode")
    else
        dieButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Change button back to green
        dieButton.Text = "Die"  -- Change text back to "Die"
        game:GetService("Players").LocalPlayer.Reset:FireServer()
        print("Green")
    end
end)

-- "Touchey" button toggle functionality (starts and stops fling)
local toucheyActive = false
toucheyButton.MouseButton1Click:Connect(function()
    toucheyActive = not toucheyActive
    if toucheyActive then
        toucheyButton.Text = "No Touchey"  -- Change text to "No Touchey" when active
        toucheyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Change button to red
        hiddenfling = true  -- Start the fling
        flingThread = coroutine.create(fling)
        coroutine.resume(flingThread)
    else
        toucheyButton.Text = "Touchey"  -- Change text back to "Touchey"
        toucheyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Reset button to green
        hiddenfling = false  -- Stop the fling
    end
end)

-- Chat command "/e toucheydie" functionality
game.Players.LocalPlayer.Chatted:Connect(function(message)
    if message:lower() == "/e toucheydie" then
        -- Trigger the die button action (same as when clicked)
        dieButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Change button to red
        dieButton.Text = "Die'nt"  -- Change text to "Die'nt"
        game:GetService("Players").LocalPlayer.Reset:FireServer()

        wait(5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0, -5, 0)
        print("Godmode")

        -- Enable the "Touchey" functionality
        toucheyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Change button to red
        toucheyButton.Text = "No Touchey"  -- Change text to "No Touchey" when active
        hiddenfling = true  -- Start the fling
        flingThread = coroutine.create(fling)
        coroutine.resume(flingThread)
    end
end)
