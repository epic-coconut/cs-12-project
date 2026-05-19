local DepositAccount = {}

DepositAccount.name = "Deposit"
DepositAccount.interestRate = 0.02 -- 2% per year
DepositAccount.interestInterval = 30 -- seconds

-- Buy deposit
function DepositAccount.buy(player, amount)
	local playerMoney = player:FindFirstChild("PlayerMoney")
	local investmentFolder = player:FindFirstChild("Investments")
	local depositAmount = investmentFolder and investmentFolder:FindFirstChild("Deposit")
	
	if playerMoney and depositAmount and playerMoney.Value >= amount then
		playerMoney.Value = playerMoney.Value - amount
		depositAmount.Value = depositAmount.Value + amount
		print(player.Name .. " deposited $" .. amount .. " into Deposit Account")
		return true
	end
	return false
end

-- Sell deposit (withdraw all)
function DepositAccount.sell(player)
	local playerMoney = player:FindFirstChild("PlayerMoney")
	local investmentFolder = player:FindFirstChild("Investments")
	local depositAmount = investmentFolder and investmentFolder:FindFirstChild("Deposit")
	
	if playerMoney and depositAmount and depositAmount.Value > 0 then
		local interest = depositAmount.Value * DepositAccount.interestRate
		local totalReturn = depositAmount.Value + interest
		playerMoney.Value = playerMoney.Value + totalReturn
		print(player.Name .. " withdrew $" .. totalReturn .. " (including $" .. interest .. " interest)")
		depositAmount.Value = 0
		return true
	end
	return false
end

-- Apply interest (called by TimerManager every 30 seconds)
function DepositAccount.applyInterest(player)
	local investmentFolder = player:FindFirstChild("Investments")
	local depositAmount = investmentFolder and investmentFolder:FindFirstChild("Deposit")
	
	if depositAmount and depositAmount.Value > 0 then
		local interest = depositAmount.Value * DepositAccount.interestRate
		local playerMoney = player:FindFirstChild("PlayerMoney")
		if playerMoney then
			playerMoney.Value = playerMoney.Value + interest
			print(player.Name .. " earned $" .. interest .. " interest from Deposit Account")
		end
	end
end

return DepositAccount
