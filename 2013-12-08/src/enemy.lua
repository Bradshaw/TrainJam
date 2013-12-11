local enemy_mt = {}
enemy = {}
enemy.all = {}

hitsnd = {}
for i=1,5 do
	hitsnd[i] = love.audio.newSource("audio/hit_"..i..".ogg")
	hitsnd[i]:setVolume(0.5)
end

awksnd = {}
for i=1,5 do
	awksnd[i] = love.audio.newSource("audio/awk_"..i..".ogg")
	awksnd[i]:setVolume(0.5)
end

function enemy.new()
	local self = setmetatable({},{__index = enemy_mt})

	self.x = 0
	self.y = 0
	if math.random()>0.5 then
		self.x = math.random(0,1) * love.graphics.getWidth()
		self.y = math.random() * love.graphics.getHeight()
	else
		self.x = math.random() * love.graphics.getWidth()
		self.y = math.random(0,1) * love.graphics.getHeight()
	end

	self.oldx = self.x
	self.oldy = self.y

	self.acc = 200+math.random()*100
	self.fric = 1+math.random()

	self.dx = 0
	self.dy = 0

	self.timeto = 1
	self.off  = math.random()*math.pi*2
	self.freq = 8+math.random()*2

	table.insert(enemy.all, self)

	return self
end

function enemy.update( dt )
	local i = 1
	while i<=#enemy.all do
		local v = enemy.all[i]
		if v.purge then
			table.remove(enemy.all, i)
		else
			v:update(dt)
			i = i + 1
		end
	end
end

function enemy.draw()
	for i,v in ipairs(enemy.all) do
		v:draw()
	end
end

function enemy_mt:update( dt )

	self.timeto = math.max(0,self.timeto-dt)

	local dx = p.x-self.x
	local dy = p.y-self.y
	local d = math.sqrt(dx*dx+dy*dy)

	if d>0 then
		local nx = dx/d
		local ny = dy/d

		self.dx = self.dx + nx*dt*self.acc
		self.dy = self.dy + ny*dt*self.acc
	end

	if d<10 then
		shake = 0.3
		self.purge = true
		local s = splatter.new(self.x,self.y,math.random(10,20),0)
		local awk = math.random(1,#awksnd)
		awksnd[awk]:rewind()
		awksnd[awk]:play()
	end

	for i,v in ipairs(target.all) do
		local dx = v.x-self.x
		local dy = v.y-self.y
		local d = math.sqrt(dx*dx+dy*dy)
		if d<5+v.health then
			local snd = v.health-5
			if snd>=1 and snd<=5 then
				hitsnd[snd]:rewind()
				hitsnd[snd]:play()
			end
			v.health=v.health-1
			self.purge = true
			local s = splatter.new(self.x,self.y,math.random(10,20),0)
		end
	end

	self.dx = self.dx - self.dx * dt * self.fric
	self.dy = self.dy - self.dy * dt * self.fric

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	if self.x<0 or self.x>love.graphics.getWidth() or self.y<0 or self.y>love.graphics.getHeight() then
		--self.purge = true
	end

end

function enemy_mt:draw()
	love.graphics.setColor(0,0,0)
	if self.timeto==0 then
		love.graphics.circle("fill",self.x, self.y,3+math.sin(time*self.freq+self.off))
		love.graphics.setLineWidth((3+math.sin(time*self.freq+self.off))*2)
		love.graphics.line(self.x, self.y, self.oldx, self.oldy)
		self.oldx = self.x
		self.oldy = self.y
	else
		local col = self.timeto*255
		love.graphics.setColor(0,0,0,(255-col)/4)
		love.graphics.circle("fill",self.x, self.y,3+math.sin(time*self.freq+self.off)+self.timeto*10)
	end
end