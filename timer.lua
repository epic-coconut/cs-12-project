local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent for timer updates
local timerRemote = Instance.new("RemoteEvent")
timerRemote.Name = "TimerUpdate"
timerRemote.Parent = ReplicatedStorage

local ROUND_DURATION = 600 -- 10 minutes in seconds
local YEAR_DURATION = 30 -- 30 seconds per year

local function startTimer()
	local startTime = os.time()
	local endTime = startTime + ROUND_DURATION
	
	while true do
		local currentTime = os.time()
		local timeLeft = endTime - currentTime
		
		if timeLeft <= 0 then
			-- Round ended
			for _, player in pairs(Players:GetPlayers()) do
				local playerMoney = player:FindFirstChild("PlayerMoney")
				local computerMoney = player:FindFirstChild("ComputerMoney")
				if playerMoney and computerMoney then
					if playerMoney.Value > computerMoney.Value then
						print(player.Name .. " WINS!")
					elseif computerMoney.Value > playerMoney.Value then
						print(player.Name .. " LOSES to computer!")
					else
						print(player.Name .. " TIES with computer!")
					end
				end
			end
			timerRemote:FireAllClients("roundEnd")
			break
		end
		
		local yearsElapsed = math.floor((ROUND_DURATION - timeLeft) / YEAR_DURATION)
		local secondsInYear = (ROUND_DURATION - timeLeft) % YEAR_DURATION
		
		timerRemote:FireAllClients("update", yearsElapsed, secondsInYear, timeLeft)
		
		task.wait(1)
	end
end

task.spawn(startTimer)
