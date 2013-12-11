local target_mt = {}
target = {}

target.all = {}

sumi = {}
sumin = 1
for i=1,4 do
	sumi[i]=love.graphics.newImage("images/sumi_"..i..".png")
end

function target.new()
	local self = setmetatable({},{__index = target_mt})

	self.x = math.random(love.graphics.getWidth()/6,5*love.graphics.getWidth()/6)
	self.y = math.random(love.graphics.getHeight()/6,5*love.graphics.getHeight()/6)

	self.r = 80
	self.g = 5
	self.b = 5

	self.health = 10

	table.insert(target.all, self)
	return self
end

function target.update( dt )
	local i = 1
	while i<=#target.all do
		local v = target.all[i]
		if v.purge then
			table.remove(target.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function target.draw( )
	for i,v in ipairs(target.all) do
		v:draw()
	end
end

function target_mt:update( dt )
	if self.health<=5 then
		local s = splatter.new(self.x,self.y,25,0)
		s.r = self.r
		s.g = self.g
		s.b = self.b

		for i=1,3 do
			s = splatter.new(self.x+i*20,self.y,25)
			s.r = self.r
			s.g = self.g
			s.b = self.b
			s = splatter.new(self.x-i*20,self.y,25)
			s.r = self.r
			s.g = self.g
			s.b = self.b
		end

		self.purge = true
		shake = shake+0.3
		life = life + 5
		s = splatter.new(love.graphics.getWidth()-30+15/2,love.graphics.getHeight()+(-life/maxlife)*500,15/2)
		s.r = self.r
		s.g = self.g
		s.b = self.b
	end
	if math.random()>0.99 then
		local o = math.random()*math.pi*2
		local d = self.health
		s = splatter.new(self.x+math.cos(o)*d,self.y+math.sin(o)*d,5,0)
		s.r = self.r
		s.g = self.g
		s.b = self.b
	end
end

function target_mt:draw(  )

	love.graphics.setColor(self.r,self.g,self.b)
	love.graphics.circle("fill", self.x+math.sin(time)*4, self.y+math.cos(time)*4, 3+self.health)
	if self.purge then
		love.graphics.setColor(0,0,0)
		love.graphics.draw(sumi[sumin],self.x,self.y,0,1,1,200,200)
		sumin = (sumin%#sumi)+1
	end
end