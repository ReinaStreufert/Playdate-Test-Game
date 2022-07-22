local gfx <const> = playdate.graphics

local Obstacle = {};

function Obstacle.new()
	local instance = {}
	local timer = playdate.timer.new(2000, 400, 0)
	instance.y = math.floor(math.random(0, 10)) * 24
	instance.colliding = false
	function instance.update()
		local x = timer.value
		if x <= 0 then
			return false
		end
		if x >= 15 and x <= 26 then
			local playertop = player.y - 5
			local playerbottom = player.y + 5
			local thistop = instance.y
			local thisbottom = instance.y + 24
			if (playertop >= thistop and playertop <= thisbottom) or (playerbottom >= thistop and playerbottom <= thisbottom) then
				instance.colliding = true
			end
		end
		gfx.setLineWidth(5)
		gfx.drawLine(x, instance.y, x, instance.y + 24)
		return true
	end
	return instance
end

return Obstacle;
