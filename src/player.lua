local gfx <const> = playdate.graphics

local player = {}
local yrottimer = nil

function crankToY(crankvalue)
	if crankvalue >= 180 and crankvalue <= 360 then
		return (1 - ((crankvalue - 180) / 180)) * 240
	else
		return (1 - (crankvalue / 180)) * 240
	end
end

function player.update()
	local crankvalue = playdate.getCrankPosition()
	local crankchange = playdate.getCrankChange()
	local oldy = crankToY(crankvalue - crankchange)
	player.y = crankToY(crankvalue)
	local y = player.y
	local ychange = y - oldy;

	local rotation = 0
	if ychange > 0 then
		if yrottimer == nil then
			yrottimer = playdate.timer.new(200, 0, 30)
		elseif yrottimer.endValue ~= 30 then
			yrottimer = playdate.timer.new(200, yrottimer.value, 30)
		end
	elseif ychange < 0 then
		if yrottimer == nil then
			yrottimer = playdate.timer.new(200, 0, -30)
		elseif yrottimer.endValue ~= -30 then
			yrottimer = playdate.timer.new(200, yrottimer.value, -30)
		end
	else
		if yrottimer ~= nil then
			if yrottimer.value == 0 then
				yrottimer = nil
			elseif yrottimer.endValue ~= 0 then
				yrottimer = playdate.timer.new(200, yrottimer.value, 0)
			end
		end
	end
	if yrottimer == nil then
		rotation = 0
	else
		rotation = yrottimer.value
	end
	local transform = playdate.geometry.affineTransform.new()
	transform = transform:rotatedBy(rotation, 20, y)
	local x1, y1 = transform:transformXY(15, y - 5)
	local x2, y2 = transform:transformXY(15, y + 5)
	local x3, y3 = transform:transformXY(25, y)
	gfx.setLineWidth(3)
	gfx.drawTriangle(x1, y1, x2, y2, x3, y3)
end

return player;
