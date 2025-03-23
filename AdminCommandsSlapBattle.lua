local intro = Instance.new("ScreenGui")
intro.Parent = game.Players.LocalPlayer.PlayerGui

local textLabel = Instance.new("TextLabel")
textLabel.Parent = intro
textLabel.Text = "Made By Cludehub And Paras"
textLabel.TextSize = 30
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.BackgroundTransparency = 1
textLabel.Position = UDim2.new(0.5, -150, 0.5, -25)
textLabel.Size = UDim2.new(0, 300, 0, 50)

wait(2)

intro:Destroy()

local player = game:GetService("Players").LocalPlayer

player.Chatted:Connect(function(msg)
    if msg == "/e glove Edgelord" then
        loadstring([[
    fireclickdetector(workspace.Lobby.Boxer.ClickDetector)

local teleportPosition = Vector3.new(0, -5, 0)

game:GetService("RunService").Heartbeat:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local char = game.Players.LocalPlayer.Character
        local position = char.HumanoidRootPart.Position
        if position.Y < -100 then  -- Adjust the value if necessary for your needs
            char:SetPrimaryPartCFrame(CFrame.new(teleportPosition))
        end
    end
end)

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
            local slapDistance = 60 -- Set range to 50
            local slapCooldown = 1
            local lastSlapTime = 0
            local slapAnimCooldown = 1  
            local lastSlapAnimTime = 0  

            local auraParticles = {}  
            local auraVisible = true  

            local slapSound = Instance.new("Sound")
            slapSound.SoundId = "rbxassetid://858508159"
            slapSound.Volume = 100
            slapSound.Parent = game.Workspace  -- Place the sound in the workspace

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
                            auraParticle.Rate = 120
                            auraParticle.Speed = NumberRange.new(0.5)
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
                            glitchParticle.Rate = 160
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
                            -- Play the slap sound and animation when the aura slaps
                            slapSound:Play()  -- Ensure the slap sound plays here
                            
                            -- Fire the slap hit
                            local args = {head}
                            local generalRemote = ReplicatedStorage:FindFirstChild("GeneralHit")
                            if generalRemote then 
                                generalRemote:FireServer(unpack(args)) 
                            end
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

            -- Fixed: This connects the slap aura and animation to the activation of the Telekinetic tool
            slapTool.Activated:Connect(function()
                playSlapAnimation()
                activateSlapAura()  -- Ensure the slap aura is activated properly here
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
                Sound.Volume = 1
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
