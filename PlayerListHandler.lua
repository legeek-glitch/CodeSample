--[[

	TheFish

]]
self = {}

-- Services
local TS = game:GetService("TweenService")
local T = game:GetService("Teams")
local P = game:GetService("Players")
local Rep = game:GetService("ReplicatedStorage")

local Modules = Rep:WaitForChild("Modules")
local TA = require(Modules:WaitForChild("TeamAbbreviations"))

-- Constants
self.TweenDuration = 1 -- Player List toggle tween duration
self.ShowedPos = UDim2.fromScale(1,0) -- Position of PlayerList when shown
self.HiddenPos = UDim2.fromScale(1.1,0) -- Position of PlayerList when hidden
self.ShowedRot = 180 -- Rotation of toggle button when shown
self.HiddenRot = 0 -- Rotation of toggle button when hidden
self.KeyCode = Enum.KeyCode.Tab -- Key to toggle the playerlist.
self.State = false
self.db = true

self.Teams = { -- Teams layout order using abbreviations found in the module script in server storage.
	"AD",
	"MTF",
	"SD",
	"ScD",
	"MD",
	"IA",
	"ISD",
	"E&TD",
	"LD",
	"CD",
	"CI",
	"P"
}


--[[

	Don't modify anything past this point, unless you know what you're doing.

]]


-- UI COmponents
self.Frame = script.Parent
self.List = self.Frame:WaitForChild("List")
self.ToggleButton = self.Frame:WaitForChild("Toggle")
self.TeamTemplate = script:WaitForChild("TeamTemplate")
self.PlayerTemplate = script:WaitForChild("PlayerTemplate")

function self.Update()
	for _,team in ipairs(self.List:GetChildren()) do -- Checks if there are players in this team, if not, hides it.
		if team:IsA("TextLabel") then
			local players = 0
			for _,player in ipairs(P:GetChildren()) do
				if TA[player.Team.Name] == team.Name then
					players+=1
				end
			end
			if players == 0 then
				team.Visible = false
			else
				team.Visible = true
			end
		end
	end
	for _,player in ipairs(P:GetChildren()) do -- Adds players in the list if not existing, else, updating the layout order.
		if not self.List:FindFirstChild(player.Name) then
			local ui = self.PlayerTemplate:Clone()
			ui.Name = player.Name
			ui.Text = ui.Name
			ui.LayoutOrder = self.List[TA[player.Team.Name]].LayoutOrder+1
			ui.Parent = self.List
		else
			self.List:FindFirstChild(player.Name).LayoutOrder = self.List[TA[player.Team.Name]].LayoutOrder+1
		end
	end
	for _,ui in ipairs(self.List:GetChildren()) do -- Destroying the player object if not found in the game
		if ui:IsA("TextButton") then
			if not P:FindFirstChild(ui.Name) then
				ui:Destroy()
			end
		end
	end
	local size = 0
	for _,child in ipairs(self.List:GetChildren()) do -- Updating the list canvas size
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			if child.Visible then
				size += child.AbsoluteSize.Y + 1				
			end
		end
	end
	self.List.CanvasSize = UDim2.fromOffset(0,size)
end

function self:Toggle(state) -- Hide or show the playerlist
	if not self.db then return end
	self.db = false
	delay(.5, function() self.db = true end)
	if state then
		TS:Create(self.Frame, TweenInfo.new(self.TweenDuration, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Position = self.ShowedPos}):Play()
		TS:Create(self.ToggleButton, TweenInfo.new(self.TweenDuration), {Rotation = self.ShowedRot}):Play()
	else
		TS:Create(self.Frame, TweenInfo.new(self.TweenDuration, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {Position = self.HiddenPos}):Play()
		TS:Create(self.ToggleButton, TweenInfo.new(self.TweenDuration), {Rotation = self.HiddenRot}):Play()
	end
	self.State = state
end

function self:Setup()
	game:GetService("StarterGui"):SetCoreGuiEnabled("PlayerList", false) -- removes default playerlist
	local current = 0
	for i = 1,#self.Teams do -- adds teams in the list
		local text
		for a,b in pairs(TA) do -- TA = Team Abbreviations, a module script in ServerStorage
			if b == self.Teams[i] then
				text = a
			end
		end
		local ui = self.TeamTemplate:Clone()
		ui.Name = self.Teams[i]
		ui.Text = text
		ui.LayoutOrder = current
		ui.BackgroundColor = T[text].TeamColor
		ui.Parent = self.List
		print(ui.Parent.Name)
		current+=2
	end
	self.Update() -- place everything else like players etc
	P.PlayerAdded:Connect(self.Update)
	P.PlayerRemoving:Connect(self.Update)
	self.ToggleButton.MouseButton1Click:Connect(function() -- Toggle button pressed
		self:Toggle(not self.State)
	end) 
	
	for _,player in ipairs(P:GetChildren()) do
		player.Changed:Connect(self.Update) -- updates if any player changed team
	end
end

function self:Terminate() -- Destroys playerlist, I don't know if it will be used but yeah.
	self.Frame:Destroy()
end


return self
