local Gold = {}

Gold.name = "Gold"
Gold.growthRate = 0.03 -- 3% steady growth per year
Gold.safeHavenBonus = 0.01 -- Extra 1% during market downturns (simplified)

-- Buy gold
function Gold.buy(player, amount)
	local playerMoney = player:FindFirstChild("PlayerMoney")
	local investmentFolder = player:FindFirstChild("Investments")
	local goldAmount = investmentFolder and investmentFolder:FindFirstChild("Gold")
	
	if playerMoney and goldAmount and playerMoney.Value >= amount then
		playerMoney.Value = playerMoney.Value - amount
		goldAmount.Value = goldAmount.Value + amount
		print(player.Name .. " bought $" .. amount .. " of Gold")
		return true
	end
	return false
end

-- Sell gold
function Gold.sell(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local goldAmount = investmentFolder and investmentFolder:FindFirstChild("Gold")
	
	if goldAmount and goldAmount.Value > 0 then
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + goldAmount.Value
			print(player.Name .. " sold Gold for $" .. goldAmount.Value)
			goldAmount.Value = 0
			return true
		end
	end
	return false
end

-- Apply gold growth
function Gold.applyGrowth(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local goldAmount = investmentFolder and investmentFolder:FindFirstChild("Gold")
	
	if goldAmount and goldAmount.Value > 0 then
		local growth = goldAmount.Value * Gold.growthRate
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + growth
			print(player.Name .. " earned $" .. math.floor(growth) .. " from Gold")
		end
	end
end

return Gold
