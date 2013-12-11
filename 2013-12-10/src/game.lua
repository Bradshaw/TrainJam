local state = gstate.new()


function state:init()
end


function state:enter()
	m = map.dungeon()
	d = dude.new()


	for i=1,0 do
		blob.new()
	end

	for i=1,0 do
		bonus.new()
	end

	bonspawn = 0
	ennspawn = 0
end


function state:focus()

end


function state:mousepressed(x, y, btn)

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

	bonspawn = bonspawn-dt
	if bonspawn<0 then
		bonspawn=15
		if #bonus.all<5 then
			bonus.new()
		end
	end

	ennspawn = ennspawn-dt
	if ennspawn<0 then
		ennspawn=1
		if #blob.all<150 then
			blob.new()
		end
	end


	m:update(dt)
	blob.update(dt)
	bonus.update(dt)
	d:update(dt)
end


function state:draw()
	m:draw()
	blob.draw()
	bonus.draw()
	d:draw()
	m:drawcap()
end

return state