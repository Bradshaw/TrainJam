local state = gstate.new()


function state:init()
	p = player.new()
	screen = love.graphics.newCanvas(2048,2048)
	love.graphics.setCanvas(screen)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,2048,2048)
	love.graphics.setCanvas()
	for i=1,0 do
		enemy.new()
	end
	for i=1,4 do
		target.new()
	end
	spawntime = 3
	time = 0
	count = 0
	shake = 0
	maxink = 120
	ink = maxink
	maxlife = maxink
	life = 0
end


function state:enter()

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
	music:setVolume(math.max(0,math.min(1,(ink/maxink))))
	music2:setVolume(math.max(0,math.min(1,(life/maxlife))))
	time = time+dt
	shake = math.max(0,shake-dt)
	spawntime = spawntime-dt
	if count<20 and spawntime<=0 then
		count = count + 1
		spawntime = 1
	end

	if #enemy.all<count and ink>0 then
		enemy.new()
		ink = ink - 1
		splatter.new(15+15/2,love.graphics.getHeight()+(-ink/maxink)*500,15/2)
	end

	if #target.all<4 and #enemy.all>0 then
		target.new()
	end
	if ink<=0 and #enemy.all<=0 and not finalised then
		finalised = true
		for i,v in ipairs(target.all) do
			v.health=0
		end
		splatter.new(p.x,p.y,15)
	end
	p:update(dt)
	target.update()
	enemy.update(dt)
	splatter.update(dt)
end


function state:draw()
	love.graphics.setCanvas(screen)
	local r = math.random(0,255)
	local g = math.random(0,255)
	local b = math.random(0,255)
	local t = math.random(0,love.graphics.getHeight())
	local b = math.random(0,love.graphics.getHeight())
	local l = math.random(0,love.graphics.getWidth())
	local r = math.random(0,love.graphics.getWidth())
	--love.graphics.setBlendMode("additive")
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(r,g,b,1.5)
	love.graphics.rectangle("fill",math.min(l,r),math.min(t,b),math.abs(l-r),math.abs(t-b))


	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(0,0,0,0)
	love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())


	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",15,love.graphics.getHeight(),15,(-ink/maxink)*500)
	love.graphics.circle("fill",15+15/2,love.graphics.getHeight()+(-ink/maxink)*500,15/2)

	love.graphics.setColor(80,5,5)
	love.graphics.rectangle("fill",love.graphics.getWidth()-30,love.graphics.getHeight(),15,(-life/maxlife)*500)
	love.graphics.circle("fill",love.graphics.getWidth()-30+15/2,love.graphics.getHeight()+(-life/maxlife)*500,15/2)

	enemy.draw()
	target.draw()
	p:draw()
	splatter.draw()

	love.graphics.setCanvas()

	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(255,255,255,64)
	--love.graphics.draw(screen)

	love.graphics.setColor(255,255,255)
	love.graphics.setBlendMode("additive")
	love.graphics.draw(screen,math.sin(time*300)*shake*5,math.sin(time*333)*shake*5)
	


end

return state