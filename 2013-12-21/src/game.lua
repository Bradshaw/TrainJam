local state = gstate.new()


function state:init()
	
end


function state:enter()
	--[[
	for i=1,10 do
		local sx = 	math.floor(love.graphics.getWidth()/tile.sizex)
		local sy = 	math.floor(love.graphics.getHeight()/tile.sizey)
		tile.new(math.floor(math.random(sx/3,2*sx/3)),math.floor(math.random(sy/3,2*sy/3)),math.random(10,20))	
	end
	--]]
	local sx = 	math.floor(love.graphics.getWidth()/tile.sizex)
	local sy = 	math.floor(love.graphics.getHeight()/tile.sizey)
	for i=1,sx do
		tile.new(i,sy,math.random(0,0))
	end
	watspawn = 1
end


function state:focus()

end


function state:mousepressed(x, y, btn)
	local sx = 	math.floor(x/tile.sizex)
	local sy = 	math.floor(y/tile.sizey)
	tile.water(sx,sy)
end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if key=="escape" then
		love.event.push("quit")
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	tile.update(dt)
	watspawn = watspawn-dt
	if watspawn<=0 then
		watspawn = 1+math.random()*1
		local sx = 	math.floor(love.graphics.getWidth()/tile.sizex)
		local sy = 	math.floor(love.graphics.getHeight()/tile.sizey)
		local px = math.floor(math.random(0,sx/3))
		px = px + math.floor(math.random(0,sx/3))
		px = px + math.floor(math.random(0,sx/3))
		--tile.water(px,0)
		local t = tile.get(px,sy)
		if t then
			t.energy = t.energy+math.random(1,20)
		end
	end
end


function state:draw()
	tile.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print(love.timer.getFPS(),10,10)
end

return state