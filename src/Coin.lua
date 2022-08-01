local gfx <const> = playdate.graphics

local Coin = {};

function Coin.new()
	local instance = {}
	local timer = playdate.timer.new(2000, 405, -10)
	instance.y = math.floor(math.random(0, 10)) * 24 + 12
	instance.colliding = false
	function instance.update()
		local x = timer.value
		if x <= -5 then
			return false
		end
		if x >= 15 and x <= 26 then
			local playertop = player.y - 5
			local playerbottom = player.y + 5
			local thistop = instance.y - 5
			local thisbottom = instance.y + 5
			if (thistop >= playertop and thistop <= playerbottom) or (thisbottom >= playertop and thisbottom <= playerbottom) then
				instance.colliding = true
			end
		end
    gfx.setColor(gfx.kColorBlack)
		gfx.fillCircleAtPoint(x, instance.y, 5)
		return true
	end
	return instance
end

return Coin;
