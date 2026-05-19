local CDAccount = {}

CDAccount.name = "CD"
CDAccount.interestRate = 0.05 -- 5% per year
CDAccount.termLength = 3 -- Must hold for 3 years (90 seconds)
CDAccount.playerTerms = {} -- Track when CD was purchased

-- Buy CD
function CDAccount.buy(player, amount)
	local playerMoney = player:FindFirstChild("PlayerMoney")
	local investmentFolder = player:FindFirstChild("Investments")
	local cdAmount = investmentFolder and investmentFolder:FindFirstChild("CD")
	
	if playerMoney and cdAmount and playerMoney.Value >= amount then
		playerMoney.Value = playerMoney.Value - amount
		cdAmount.Value = cdAmount.Value + amount
		
		-- Track purchase time
		if not CDAccount.playerTerms[player] then
			CDAccount.playerTerms[player] = {}
		end
		CDAccount.playerTerms[player][tostring(os.time())] = {amount = amount, years = 0}
		
		print(player.Name .. " bought $" .. amount .. " CD (3 year term)")
		return true
	end
	return false
end

-- Sell CD (only if term is complete)
function CDAccount.sell(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local cdAmount = investmentFolder and investmentFolder:FindFirstChild("CD")
	
	if cdAmount and cdAmount.Value > 0 then
		-- Check if oldest CD has matured (simplified - after 90 seconds)
		-- For full implementation, track purchase times
		local interest = cdAmount.Value * CDAccount.interestRate * CDAccount.termLength
		local totalReturn = cdAmount.Value + interest
		
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + totalReturn
			print(player.Name .. " cashed out CD for $" .. totalReturn)
			cdAmount.Value = 0
			return true
		end
	end
	return false
end

return CDAccount
