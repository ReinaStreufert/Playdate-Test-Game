import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

player = import "player"
local Obstacle = import "Obstacle"
local obstacles = {}

local gfx <const> = playdate.graphics

local function newobstacle()
	table.insert(obstacles, Obstacle.new())
	playdate.timer.new(100, newobstacle)
end
newobstacle()

function playdate.update()
	gfx.clear(gfx.kColorWhite)
	playdate.timer.updateTimers()
	player.update()

	local deadobstacle = nil
	for i,obstacle in ipairs(obstacles) do
		if not obstacle.update() then
			deadobstacle = i
		elseif obstacle.colliding then
			obstacles = {}
		end
	end
	if deadobstacle then
		table.remove(obstacles, deadobstacle)
	end
end
