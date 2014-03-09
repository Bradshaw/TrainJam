player = {}

function player.init()
	player.x = love.graphics.getWidth()/2
	player.y = love.graphics.getHeight()-40
	player.dx = 0
	player.dy = 0
	player.accel = 3000
	player.fric = 10
	player.warpin = true

end

function player.update( dt )
	if player.warpin then
		player.dy = player.dy - dt*player.accel
		if player.y<love.graphics.getHeight()-30 then
			player.warpin = false
		end
	else
		if love.keyboard.isDown("left","q","a") then
			player.dx = player.dx - dt*player.accel
		end
		if love.keyboard.isDown("right","d") then
			player.dx = player.dx + dt*player.accel
		end
		if love.keyboard.isDown("up","z","w") then
			player.dy = player.dy - dt*player.accel
		end
		if love.keyboard.isDown("down","s") then
			player.dy = player.dy + dt*player.accel
		end
	end
	player.dx = player.dx - player.dx*dt*player.fric
	player.dy = player.dy - player.dy*dt*player.fric
	player.x = useful.clamp(player.x + player.dx*dt, 0, love.graphics.getWidth())
	player.y = useful.clamp(player.y + player.dy*dt, 0, love.graphics.getHeight())
end

function player.draw()
	love.graphics.rectangle("fill", player.x-2, player.y-2,4,4)
end