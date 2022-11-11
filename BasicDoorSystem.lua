--[[

	Author: TheFish

]]

local TS = game:GetService("TweenService")

local Colors = {
	['Red'] = Color3.fromRGB(255,0,0),
	['Yellow'] = Color3.fromRGB(255,255,0),
	['Green'] = Color3.fromRGB(0, 255, 0),
	['White'] = Color3.fromRGB(255, 255, 255)
}


for _,prompt in ipairs(workspace:GetDescendants()) do
	if prompt.Name == "Prompt" and prompt.Parent.Parent.Parent.Name:find("Reader") and prompt.Parent.Parent.Parent.Parent:FindFirstChild("Configuration") and prompt.Parent.Parent.Parent.Parent.Configuration:FindFirstChild("DoorType") then
		prompt.Triggered:Connect(function(player)

			local Model = prompt.Parent.Parent.Parent.Parent
			local Config = Model.Configuration
			local Permissions = require(Model.Permissions)


			for _,pro in ipairs(Model:GetDescendants()) do
				if pro.Name == "Prompt" then
					pro.Enabled = false
				end
			end


			local TweenDuration = Config.TweenDuration.Value
			local DoorType = Config.DoorType.Value
			local AutoClose = Config.AutoClose
			local ClosureCooldown = Config.ClosureCooldown.Value

			local Broken = Config.Broken
			local Locked = Config.Locked
			local Opened = Config.Opened
			local Repairing = Config.Repairing

			local function Color(number, color, duration)
				for _,light in ipairs(Model:GetDescendants()) do
					if light.Name == "light"..number then
						TS:Create(light, TweenInfo.new(duration), {Color = Colors[color]}):Play()
					end
				end
			end


			local function TweenDoor(state)
				if DoorType == "SingleSlidingDoor" then

					local Door = Model.Door.PrimaryPart

					if state then
						TS:Create(Door, TweenInfo.new(TweenDuration), {CFrame = Door.CFrame * CFrame.new(0,0,Door.Size.Z-.125)}):Play()
					else
						TS:Create(Door, TweenInfo.new(TweenDuration), {CFrame = Door.CFrame * CFrame.new(0,0,-Door.Size.Z+.125)}):Play()
					end
					wait(TweenDuration)

				elseif DoorType == "DoubleSlidingDoor" then

					local LDoor = Model.LDoor.PrimaryPart
					local RDoor = Model.RDoor.PrimaryPart

					if state then
						TS:Create(LDoor, TweenInfo.new(TweenDuration), {CFrame = LDoor.CFrame * CFrame.new(0,0,LDoor.Size.Z-.125)}):Play()
						TS:Create(RDoor, TweenInfo.new(TweenDuration), {CFrame = RDoor.CFrame * CFrame.new(0,0,RDoor.Size.Z-.125)}):Play()
					else
						TS:Create(LDoor, TweenInfo.new(TweenDuration), {CFrame = LDoor.CFrame * CFrame.new(0,0,-LDoor.Size.Z+.125)}):Play()
						TS:Create(RDoor, TweenInfo.new(TweenDuration), {CFrame = RDoor.CFrame * CFrame.new(0,0,-RDoor.Size.Z+.125)}):Play()
					end
					wait(TweenDuration)

				elseif DoorType == "SingleBlastDoor" then

					local Door = Model.Door.PrimaryPart

					if state then
						TS:Create(Door, TweenInfo.new(TweenDuration), {CFrame = Door.CFrame * CFrame.new(0,Door.Size.Y-.125,0)}):Play()
					else
						TS:Create(Door, TweenInfo.new(TweenDuration), {CFrame = Door.CFrame * CFrame.new(0,-Door.Size.Y+.125,0)}):Play()	
					end
					wait(TweenDuration)

				elseif DoorType == "SingleSwingDoor" then

					local Door = Model.Door.PrimaryPart

					if state then
						TS:Create(Door, TweenInfo.new(TweenDuration), {CFrame = Door.CFrame * CFrame.Angles(0,math.rad(100),0)}):Play()
					else
						TS:Create(Door, TweenInfo.new(TweenDuration), {CFrame = Door.CFrame * CFrame.Angles(0,math.rad(-100),0)}):Play()
					end
					wait(TweenDuration)

				elseif DoorType == "DoubleSwingDoor" then

					local LDoor = Model.LDoor.PrimaryPart
					local RDoor = Model.RDoor.PrimaryPart

					if state then
						TS:Create(LDoor, TweenInfo.new(TweenDuration), {CFrame = LDoor.CFrame * CFrame.Angles(0,math.rad(100),0)}):Play()
						TS:Create(RDoor, TweenInfo.new(TweenDuration), {CFrame = RDoor.CFrame * CFrame.Angles(0,math.rad(-100),0)}):Play()
					else
						TS:Create(LDoor, TweenInfo.new(TweenDuration), {CFrame = LDoor.CFrame * CFrame.Angles(0,math.rad(-100),0)}):Play()
						TS:Create(RDoor, TweenInfo.new(TweenDuration), {CFrame = RDoor.CFrame * CFrame.Angles(0,math.rad(100),0)}):Play()
					end
					wait(TweenDuration)
				end
			end
			
			
			
			
			

			local function CheckAccess()
				if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") then

					local playerLevel = player.leaderstats.Level.Value
					if Permissions[playerLevel] then
						return true
					else
						if Permissions[player.Team.Name] then
							return true
						else
							return false
						end
					end

				end
			end
			
			local function AccessGrantedFunc()
				if AutoClose.Value then

					Color(1, "Green", .5)
					
					if DoorType:find("SwingDoor") then
						print("Swing Door")
						if prompt.Parent.Parent.Parent.Name == "Reader1" then
							TweenDoor(true)
						else
							TweenDoor(false)
						end
					else
						TweenDoor(true)
					end
					
					Opened.Value = true

					Color(2, "Yellow", .5)

					wait(ClosureCooldown)

					Color(2, "Green", .5)
					Color(3, "Yellow", .5)

					if DoorType:find("SwingDoor") then
						if prompt.Parent.Parent.Parent.Name == "Reader1" then
							TweenDoor(false)
						else
							TweenDoor(true)
						end
					else
						TweenDoor(false)
					end
					Opened.Value = false

					Color(3, "Green", .5) wait(1)

					Color(1, "White", .5)
					Color(2, "White", .5)
					Color(3, "White", .5)

				else

					if Opened.Value then
						
						if DoorType:find("SwingDoor") then
							print("Swing Door")
							if AutoClose.UsedReader.Value == "Reader1" then
								TweenDoor(false)
							else
								TweenDoor(true)
							end
						else
							TweenDoor(false)
						end
						
						Color(2, "Green", .5)
						Color(3, "Yellow", .5)

						Opened.Value = false

						Color(3, "Green", .5) wait(1)

						Color(1, "White", .5)
						Color(2, "White", .5)
						Color(3, "White", .5)

					else
						
						if DoorType:find("SwingDoor") then
							print("Swing Door")
							if prompt.Parent.Parent.Parent.Name == "Reader1" then
								TweenDoor(true)
							else
								TweenDoor(false)
							end
							AutoClose.UsedReader.Value = prompt.Parent.Parent.Parent.Name
						else
							TweenDoor(true)
						end
						
						Color(1, "Green", .5)

						Opened.Value = true

						Color(2, "Yellow", .5)

					end

				end
			end
			local function AccessDeniedFunc()
				Color(1, "Yellow", .5) wait(.75)

				Color(1, "Red", .5) wait(.5)
				Color(1, "White", 0) wait(.25)
				Color(1, "Red", .25) wait(.5)

				Color(1, "White", .5)
			end
			local function BrokenFunc()
				Color(1, "Yellow", .5) wait(.5)
				Color(1, "White", 0) wait(.25)
				Color(1, "Yellow", .25) wait(.5)

				Color(1, "White", .5)
			end
			local function RepairedFunc()
				Color(1, "Yellow", .5) wait(.5)
				Color(1, "Green", .5)
				Color(2, "Yellow", .5) wait(.5)
				Color(2, "Green", .5)
				Color(3, "Yellow", .5) wait(.5)
				Color(3, "Green", .5) wait(1)

				Color(1, "White", .5)
				Color(2, "White", .5)
				Color(3, "White", .5)
			end
			local function LockedFunc()
				Color(1, "Yellow", .5) wait(.75)

				Color(1, "Red", .5) wait(.5)
				Color(2, "Red", .5) wait(.5)
				Color(3, "Red", .5) wait(.5)
				
				Color(1, "White", 0) 
				Color(2, "White", 0) 
				Color(3, "White", 0) wait(.25)
				
				Color(1, "Red", .5)
				Color(2, "Red", .5) 
				Color(3, "Red", .5) wait(.5)

				Color(1, "White", .5)
				Color(2, "White", .5) 
				Color(3, "White", .5)
			end
			local function OpenCloseReader()
				if not prompt.Parent.Parent.Parent.Opened.Value then
					TS:Create(prompt.Parent.Parent["1"], TweenInfo.new(1), {CFrame = prompt.Parent.Parent["1"].CFrame * CFrame.new(-.25,0,0), Transparency = 1}):Play() wait(1)
					TS:Create(prompt.Parent.Parent["2"], TweenInfo.new(1), {CFrame = prompt.Parent.Parent["2"].CFrame * CFrame.new(-.25,0,0), Transparency = 1}):Play()
					wait(1)
					TS:Create(prompt.Parent.Parent.PrimaryPart, TweenInfo.new(1), {CFrame = prompt.Parent.Parent.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(-90),0)}):Play()
					wait(1)
				else
					TS:Create(prompt.Parent.Parent.PrimaryPart, TweenInfo.new(1), {CFrame = prompt.Parent.Parent.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(90),0)}):Play()
					wait(1)
					TS:Create(prompt.Parent.Parent["2"], TweenInfo.new(1), {CFrame = prompt.Parent.Parent["2"].CFrame * CFrame.new(.25,0,0), Transparency = 0}):Play() wait(1)
					TS:Create(prompt.Parent.Parent["1"], TweenInfo.new(1), {CFrame = prompt.Parent.Parent["1"].CFrame * CFrame.new(.25,0,0), Transparency = 0}):Play()
					wait(1)
				end
				prompt.Parent.Parent.Parent.Opened.Value = not prompt.Parent.Parent.Parent.Opened.Value
			end
			
			if Broken.Value then
				if player.Character:FindFirstChild("RepairTool") then
					if not prompt.Parent.Parent.Parent.Opened.Value then
						OpenCloseReader()
						Repairing.Value = true
						prompt.Enabled = true
					else
						if Repairing.Value then
							Repairing.Value = false
							for _,part in ipairs(Model:GetDescendants()) do
								if part.Name == "Box" then
									part.Part.Color = Color3.fromRGB(255,255,0)
								end
							end wait(1)
							for _,part in ipairs(Model:GetDescendants()) do
								if part.Name == "Box" then
									part.Part.Color = Color3.fromRGB(0,255,0)
								end
							end
							wait(.5)
							prompt.Enabled = true
						else
							Broken.Value = false
							OpenCloseReader()
							RepairedFunc()
						end
					end
				else
					BrokenFunc()
				end
			else
				if Locked.Value then
					if player.Character:FindFirstChild("DoorLocker") then
						Locked.Value = false
						RepairedFunc()
					elseif player.leaderstats.Level.Value == "L4" or player.leaderstats.Level.Value == "L5" then
						AccessGrantedFunc()
					else
						LockedFunc()
					end
				else
					if CheckAccess() then
						if player.Character:FindFirstChild("DoorLocker") then
							if not Locked.Value then
								Locked.Value = true
								LockedFunc()
							end
						else
							AccessGrantedFunc()							
						end
					else
						AccessDeniedFunc()
					end
				end

			end

			for _,pro in ipairs(Model:GetDescendants()) do
				if pro.Name == "Prompt" then
					pro.Enabled = true
				end
			end
		end)
	end
end
