local Crypto = {}

Crypto.name = "Crypto"
Crypto.volatility = 0.30 -- 30% random change per year (extreme)

-- Buy crypto
function Crypto.buy(player, amount)
	local playerMoney = player:FindFirstChild("PlayerMoney")
	local investmentFolder = player:FindFirstChild("Investments")
	local cryptoAmount = investmentFolder and investmentFolder:FindFirstChild("Crypto")
	
	if playerMoney and cryptoAmount and playerMoney.Value >= amount then
		playerMoney.Value = playerMoney.Value - amount
		cryptoAmount.Value = cryptoAmount.Value + amount
		print(player.Name .. " bought $" .. amount .. " of Cryptocurrency")
		return true
	end
	return false
end

-- Sell crypto
function Crypto.sell(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local cryptoAmount = investmentFolder and investmentFolder:FindFirstChild("Crypto")
	
	if cryptoAmount and cryptoAmount.Value > 0 then
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + cryptoAmount.Value
			print(player.Name .. " sold Cryptocurrency for $" .. cryptoAmount.Value)
			cryptoAmount.Value = 0
			return true
		end
	end
	return false
end

-- Apply crypto volatility
function Crypto.applyChange(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local cryptoAmount = investmentFolder and investmentFolder:FindFirstChild("Crypto")
	
	if cryptoAmount and cryptoAmount.Value > 0 then
		local changePercent = (math.random() - 0.5) * 2 * Crypto.volatility
		local change = cryptoAmount.Value * changePercent
		local newValue = cryptoAmount.Value + change
		
		if newValue < 0 then newValue = 0 end
		
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			if change > 0 then
				playerMoney.Value = playerMoney.Value + change
				print(player.Name .. " gained $" .. math.floor(change) .. " from Crypto")
			else
				cryptoAmount.Value = newValue
				print(player.Name .. " lost $" .. math.floor(-change) .. " from Crypto")
			end
		end
	end
end

return Crypto
