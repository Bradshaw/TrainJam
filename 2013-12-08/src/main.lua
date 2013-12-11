function love.load(arg)
	math.randomseed(os.time())

	require("player")
	require("enemy")
	require("target")
	require("splatter")

	music = love.audio.newSource("audio/Plume.ogg")
	music:setLooping(true)
	music:setVolume(1)
	music2 = love.audio.newSource("audio/Plume2.ogg")
	music2:setLooping(true)
	music:setVolume(0)
	music2:play()
	music:play()


	gstate = require "gamestate"
	game = require("game")
	gstate.switch(game)
end


function love.focus(f)
	gstate.focus(f)
end

function love.mousepressed(x, y, btn)
	gstate.mousepressed(x, y, btn)
end

function love.mousereleased(x, y, btn)
	gstate.mousereleased(x, y, btn)
end

function love.joystickpressed(joystick, button)
	gstate.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
	gstate.joystickreleased(joystick, button)
end

function love.quit()
	gstate.quit()
end

function love.keypressed(key, uni)
	gstate.keypressed(key, uni)
end

function love.keyreleased(key, uni)
	gstate.keyreleased(key)
end

function love.update(dt)
	if dt>0.3 then
		love.event.push("quit")
	end
	gstate.update(dt)
end

function love.draw()
	gstate.draw()
end
