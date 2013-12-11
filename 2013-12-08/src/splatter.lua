local splatter_mt = {}
splatter = {}

splatter.all = {}

function splatter.new(x,y,size,time)
	local self = setmetatable({},{__index = splatter_mt})
	self.time = time or math.random()/10
	self.x = x
	self.y = y
	self.r = 0
	self.g = 0
	self.b = 0
	self.size = size
	table.insert(splatter.all,self)
	return self
end

function splatter.update( dt )
	local i = 1
	while i<=#splatter.all do
		local v = splatter.all[i]
		if v.purge then
			table.remove(splatter.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function splatter.draw(  )
	for i,v in ipairs(splatter.all) do
		v:draw()
	end
end

function splatter_mt:update( dt )
	self.time = self.time-dt
	if self.time<=0 then
		self.purge = true
		for i=1,math.floor(self.size/3) do
			local o = math.random()*math.pi*2
			local d = self.size+math.random()*self.size
			local s = splatter.new(self.x+math.cos(o)*d,self.y+math.sin(o)*d,math.random()*self.size*0.8)
			s.r = self.r
			s.g = self.g
			s.b = self.b
		end
	end
end

function splatter_mt:draw( ... )
	if self.purge then
		love.graphics.setColor(self.r, self.g, self.b)
		love.graphics.circle("fill",self.x,self.y,self.size)
	end
end