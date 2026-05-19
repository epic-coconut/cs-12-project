local IndexFund = {}

IndexFund.name = "IndexFund"
IndexFund.baseGrowth = 0.07 -- 7% average yearly return
IndexFund.volatility = 0.03 -- 3% random variation

-- Buy index fund
function IndexFund.buy(player, amount)
	local playerMoney = player:FindFirstChild("PlayerMoney")
	local investmentFolder = player:FindFirstChild("Investments")
	local indexAmount = investmentFolder and investmentFolder:FindFirstChild("IndexFund")
	
	if playerMoney and indexAmount and playerMoney.Value >= amount then
		playerMoney.Value = playerMoney.Value - amount
		indexAmount.Value = indexAmount.Value + amount
		print(player.Name .. " invested $" .. amount .. " in Index Fund")
		return true
	end
	return false
end

-- Sell all index fund
function IndexFund.sell(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local indexAmount = investmentFolder and investmentFolder:FindFirstChild("IndexFund")
	
	if indexAmount and indexAmount.Value > 0 then
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + indexAmount.Value
			print(player.Name .. " sold Index Fund for $" .. indexAmount.Value)
			indexAmount.Value = 0
			return true
		end
	end
	return false
end

-- Apply yearly growth
function IndexFund.applyGrowth(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local indexAmount = investmentFolder and investmentFolder:FindFirstChild("IndexFund")
	
	if indexAmount and indexAmount.Value > 0 then
		local randomFactor = 1 + (math.random() - 0.5) * IndexFund.volatility * 2
		local growth = IndexFund.baseGrowth * randomFactor
		local gain = indexAmount.Value * growth
		
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + gain
			print(player.Name .. " earned $" .. math.floor(gain) .. " from Index Fund")
		end
	end
end

return IndexFund
