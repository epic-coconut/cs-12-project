local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteFolder = replicatedStorage:WaitForChild("InvestmentRemotes")

local buyRemote = remoteFolder:WaitForChild("BuyInvestment")
local sellRemote = remoteFolder:WaitForChild("SellInvestment")

-- Wait for the GUI to load
local starterGui = player:WaitForChild("PlayerGui")
local dashboard = starterGui:WaitForChild("Dashboard")
local mainFrame = dashboard:WaitForChild("MainFrame")
local rightPanel = mainFrame:WaitForChild("RightPanel")
local investmentsGrid = rightPanel:WaitForChild("InvestmentsGrid")

-- Investment box names (must match your UI)
local investmentBoxes = {
	Deposit = {buyAmount = 1000, sellAmount = 0},
	CD = {buyAmount = 1000, sellAmount = 0},
	IndexFund = {buyAmount = 1000, sellAmount = 0},
	Stocks = {buyAmount = 1000, sellAmount = 0},
	Gold = {buyAmount = 1000, sellAmount = 0},
	Crypto = {buyAmount = 1000, sellAmount = 0}
}

-- Connect buttons for each investment
for investmentName, data in pairs(investmentBoxes) do
	local box = investmentsGrid:FindFirstChild(investmentName .. "Box")
	if box then
		local buyButton = box:FindFirstChild("BuyButton")
		local sellButton = box:FindFirstChild("SellButton")
		
		if buyButton then
			buyButton.MouseButton1Click:Connect(function()
				buyRemote:FireServer(investmentName, data.buyAmount)
			end)
		end
		
		if sellButton then
			sellButton.MouseButton1Click:Connect(function()
				sellRemote:FireServer(investmentName)
			end)
		end
	end
end
