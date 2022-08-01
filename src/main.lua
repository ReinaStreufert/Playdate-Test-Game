import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

player = import "player"
local Obstacle = import "Obstacle"
local Coin = import "Coin"
local obstacles = {}
local coins = {}
local score = 0
local scorescreentimer = nil

local gfx <const> = playdate.graphics

local nextgeneration = true --true means to generate an obstacle next, false means to generate a "coin" next
local function generate()
	if scorescreentimer then
		playdate.timer.new(50, generate)
		return
	end
	if nextgeneration then
		table.insert(obstacles, Obstacle.new())
		playdate.timer.new(50, generate)
		nextgeneration = false
	else
		table.insert(coins, Coin.new())
		playdate.timer.new(50, generate)
		nextgeneration = true
	end
end
generate()
playdate.display.setInverted(true)

function playdate.update()
	gfx.clear(gfx.kColorWhite)
	playdate.timer.updateTimers()

	if scorescreentimer then
		if scorescreentimer.timeLeft <= 0 then
			score = 0
			scorescreentimer = nil
			playdate.display.setScale(1)
		else
			playdate.display.setScale(2)
			gfx.setFont(gfx.getSystemFont(gfx.font.kVariantBold))
			gfx.drawTextAligned("score: " .. score, 100, 55, kTextAlignment.center)
			return
		end
	end

	player.update()

	local deadobstacle = nil
	for i,obstacle in ipairs(obstacles) do
		if not obstacle.update() then
			deadobstacle = i
		elseif obstacle.colliding then
			obstacles = {}
			coins = {}
			scorescreentimer = playdate.timer.new(1000)
		end
	end
	if deadobstacle then
		table.remove(obstacles, deadobstacle)
	end
	local deadcoin = nil
	for i,coin in ipairs(coins) do
		if not coin.update() then
			deadcoin = i
		elseif coin.colliding then
			deadcoin = i
			score = score + 1
		end
	end
	if deadcoin then
		table.remove(coins, deadcoin)
	end
end
