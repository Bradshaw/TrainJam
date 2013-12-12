local bullet_mt = {}
bullet = {}

bullet.all = {}

function bullet.new(x, y, dx, dy)
	local self = setmetatable({},{__index=bullet_mt})

	self.speed = 30

	self.x = x
	self.y = y 
	self.dx = dx
	self.dy = dy

	table.insert(bullet.all, self)
	return self
end

function bullet.update( dt )
	local i = 1
	while i<=#bullet.all do
		local v = bullet.all[i]
		if v.purge then
			table.remove(bullet.all,i)
		else
			v:update(dt)
			i = i+1
		end
	end
end

function bullet.draw()
	for i,v in ipairs(bullet.all) do
		v:draw()
	end
end

function bullet_mt:update( dt )
	self.x = self.x + self.dx * self.speed * dt
	self.y = self.y + self.dy * self.speed * dt
	for i,v in ipairs(blob.all) do
		local dx = self.x - v.x+v.posx
		local dy = self.y - v.y+v.posy
		local d = math.sqrt(dx*dx+dy*dy)
		if d<1 then
			v.purge = true
			self.purge = true
		end
	end
end

function bullet_mt:draw(  )
	love.graphics.setColor(255,255,255)
	love.graphics.line((self.x-1)*tile.sizex+self.dx*3, (self.y-1)*tile.sizey+self.dy*3, (self.x-1)*tile.sizex-self.dx*3, (self.y-1)*tile.sizey-self.dy*3)
end
