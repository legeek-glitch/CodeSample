--[[

	TheFish
	Tool Giver

]]

-- Services
local SS = game:GetService("ServerStorage")
local P = game:GetService("Players")

-- Components
local Tool = SS:WaitForChild("Tool",5)

P.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function() -- Fired once player spawns or respawns
		Tool:Clone().Parent = player.Backpack
	end)
end)
