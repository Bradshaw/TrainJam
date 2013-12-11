local bonus_mt = {}
bonus = {}

bonus.all = {}

function bonus.new( cb )
	local self = setmetatable({},{__index=bonus_mt})

	local marb = m:select(function(tile)
		return tile.pass
	end)
	local start = marb[math.random(1,#marb)]
	while math.abs(start.x-d.x)<10 and math.abs(start.y-d.y)<10 do
		start = marb[math.random(1,#marb)]
	end
	self.x = start.x
	self.y = start.y

	self.cb = cb or function() end

	self.time = 1

	table.insert(bonus.all, self)
	return self
end

function bonus.update( dt )
	local i = 1
	while i <= #bonus.all do
		local v = bonus.all[i]
		if v.purge then
			table.remove(bonus.all, i)
		else
			v:update(dt)
			i=i+1
		end

	end
end

function bonus.draw(  )
	for i,v in ipairs(bonus.all) do
		v:draw()
	end
end

function bonus_mt:update( dt )
	self.time = self.time+dt
	if math.floor(d.x)==self.x and math.floor(d.y)==self.y then
		self.cb()
		self.purge = true
	end
end

function bonus_mt:draw(  )
	love.graphics.setColor(120,120,200)
	local bnc = math.pow(  ((self.time*4)%2)-1, 2  ) * -3
	love.graphics.rectangle("fill",(self.x-0.5)*tile.sizex-2,(self.y-0.5)*tile.sizey-5-bnc,5,5)
end