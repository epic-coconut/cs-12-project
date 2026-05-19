local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local timerRemote = replicatedStorage:WaitForChild("InvestmentRemotes"):WaitForChild("TimerUpdate")

-- Wait for UI elements
local starterGui = player:WaitForChild("PlayerGui")
local dashboard = starterGui:WaitForChild("Dashboard")
local mainFrame = dashboard:WaitForChild("MainFrame")
local leftPanel = mainFrame:WaitForChild("LeftPanel")

-- Find UI elements
local yourMoneyValue = leftPanel:FindFirstChild("MoneyFrame"):FindFirstChild("YourMoneyValue")
local computerMoneyValue = leftPanel:FindFirstChild("VSFrame"):FindFirstChild("ComputerMoneyValue")
local leaderboardStatus = leftPanel:FindFirstChild("VSFrame"):FindFirstChild("LeaderboardStatus")
local timerLabel = leftPanel:FindFirstChild("TimerFrame"):FindFirstChild("TimerLabel")
local progressBarFill = leftPanel:FindFirstChild("TimerFrame"):FindFirstChild("ProgressBarBG"):FindFirstChild("ProgressBarFill")

-- Update money displays
local playerMoney = player:WaitForChild("PlayerMoney")
local computerMoney = player:WaitForChild("ComputerMoney")

playerMoney.Changed:Connect(function()
	if yourMoneyValue then
		yourMoneyValue.Text = "$" .. playerMoney.Value
	end
end)

computerMoney.Changed:Connect(function()
	if computerMoneyValue then
		computerMoneyValue.Text = "Computer: $" .. computerMoney.Value
	end
	updateLeaderboard()
end)

local function updateLeaderboard()
	if not leaderboardStatus then return end
	if playerMoney.Value > computerMoney.Value then
		leaderboardStatus.Text = "🏆 YOU ARE WINNING!"
		leaderboardStatus.TextColor3 = Color3.new(0, 1, 0)
	elseif computerMoney.Value > playerMoney.Value then
		leaderboardStatus.Text = "⚠️ COMPUTER IS WINNING"
		leaderboardStatus.TextColor3 = Color3.new(1, 0, 0)
	else
		leaderboardStatus.Text = "🤝 TIED WITH COMPUTER"
		leaderboardStatus.TextColor3 = Color3.new(1, 1, 0)
	end
end

-- Timer updates
timerRemote.OnClientEvent:Connect(function(event, yearsElapsed, secondsInYear, timeLeft)
	if event == "update" then
		local minutes = math.floor(timeLeft / 60)
		local seconds = timeLeft % 60
		if timerLabel then
			timerLabel.Text = "Year " .. (yearsElapsed + 1) .. " - " .. string.format("%02d:%02d", minutes, seconds) .. " left"
		end
		if progressBarFill then
			local progress = (30 - secondsInYear) / 30
			progressBarFill.Size = UDim2.new(progress, 0, 1, 0)
		end
	elseif event == "roundEnd" then
		if timerLabel then
			timerLabel.Text = "GAME OVER!"
		end
	end
end)

-- Initial values
if yourMoneyValue then
	yourMoneyValue.Text = "$" .. playerMoney.Value
end
if computerMoneyValue then
	computerMoneyValue.Text = "Computer: $" .. computerMoney.Value
end
updateLeaderboard()
