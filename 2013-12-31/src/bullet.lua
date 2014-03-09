local bullet_mt = {}
bullet = {}

bullet.all = {}

function bullet.new(x, y, dx, dy)
	local self = setmetatable({}, {__index=bullet_mt})
	self.x = x
	self.y = y
	self.dx = dx
	self.dy = dy

	table.insert(bullet.all,self)
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
			i=i+1
		end
	end
end

function bullet.draw()
	for i,v in ipairs(bullet.all) do
		v:draw()
	end
end


function bullet_mt:update( dt )
	self.x = self.x+self.dx*dt
	self.y = self.y+self.dy*dt
	if self.x>love.graphics.getWidth() or self.x<0 or self.y>love.graphics.getHeight() or self.y<0 then
		self.purge = true
	end
end

function bullet_mt:draw()
	love.graphics.setLineWidth(3)
	love.graphics.line(self.x-self.dx/200,self.y-self.dy/200,self.x+self.dx/200, self.y+self.dy/200)
end