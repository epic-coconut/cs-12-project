local Stocks = {}

Stocks.name = "Stocks"
Stocks.volatility = 0.15 -- 15% random change per year (very volatile)

-- Buy stocks
function Stocks.buy(player, amount)
	local playerMoney = player:FindFirstChild("PlayerMoney")
	local investmentFolder = player:FindFirstChild("Investments")
	local stocksAmount = investmentFolder and investmentFolder:FindFirstChild("Stocks")
	
	if playerMoney and stocksAmount and playerMoney.Value >= amount then
		playerMoney.Value = playerMoney.Value - amount
		stocksAmount.Value = stocksAmount.Value + amount
		print(player.Name .. " bought $" .. amount .. " of Stocks")
		return true
	end
	return false
end

-- Sell all stocks
function Stocks.sell(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local stocksAmount = investmentFolder and investmentFolder:FindFirstChild("Stocks")
	
	if stocksAmount and stocksAmount.Value > 0 then
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + stocksAmount.Value
			print(player.Name .. " sold Stocks for $" .. stocksAmount.Value)
			stocksAmount.Value = 0
			return true
		end
	end
	return false
end

-- Apply market change (can be positive or negative)
function Stocks.applyMarketChange(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local stocksAmount = investmentFolder and investmentFolder:FindFirstChild("Stocks")
	
	if stocksAmount and stocksAmount.Value > 0 then
		local changePercent = (math.random() - 0.5) * 2 * Stocks.volatility
		local change = stocksAmount.Value * changePercent
		local newValue = stocksAmount.Value + change
		
		if newValue < 0 then newValue = 0 end
		
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			if change > 0 then
				playerMoney.Value = playerMoney.Value + change
				print(player.Name .. " gained $" .. math.floor(change) .. " from Stocks")
			else
				-- Negative change just reduces stock value, doesn't take from cash
				-- For simplicity, we adjust the stock value directly
				stocksAmount.Value = newValue
				print(player.Name .. " lost $" .. math.floor(-change) .. " from Stocks")
			end
		end
	end
end

return Stocks
