weap = {}

function weap.update(dt)
	for i,v in ipairs(weap) do
		if v.have then
			v.time = v.time - dt
			if v.time<=0 then
				v.time = v.cool
				v.fire()
			end
		end
	end
end

table.insert(weap,
	{
		have = true,
		cool = 0.1,
		time = 0,
		fire = function()
			bullet.new(player.x+math.random(-5,5), player.y, 0, -800+math.random(0,50))
		end
	}
)
table.insert(weap,
	{
		have = true,
		cool = 0.3,
		time = 0,
		fire = function()
			bullet.new(player.x, player.y, -300, -300)
			bullet.new(player.x, player.y, 300, -300)
		end
	}
)