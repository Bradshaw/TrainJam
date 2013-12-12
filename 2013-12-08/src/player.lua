local player_mt = {}
player = {}

function player.new()
	local self = setmetatable({},{__index = player_mt})
	self.x = love.graphics.getWidth()/2
	self.y = love.graphics.getHeight()/2

	self.oldx = self.x
	self.oldy = self.y

	self.dx = 0
	self.dy = 0

	self.acc = 800
	self.fric = 5

	self.time = 0

	return self
end

function player_mt:update(dt)
	
	self.time = self.time + dt

	if love.keyboard.isDown("left", "q", "a") then
		self.dx = self.dx - self.acc*dt*2
		self.keyboard = true
	end

	if love.keyboard.isDown("right", "d") then
		self.dx = self.dx + self.acc*dt*2
		self.keyboard = true
	end

	if love.keyboard.isDown("up", "z", "w") then
		self.dy = self.dy - self.acc*dt*2
		self.keyboard = true
	end

	if love.keyboard.isDown("down", "s") then
		self.dy = self.dy + self.acc*dt*2
		self.keyboard = true
	end

	if love.mouse.isDown("l", "r") then
		self.keyboard = false
	end
	if not self.keyboard then
		local dx = love.mouse.getX()-self.x
		local dy = love.mouse.getY()-self.y
		local d = math.sqrt(dx*dx+dy*dy)

		if d>0 then
			local nx = dx/100
			local ny = dy/100

			self.dx = self.dx + nx*dt*self.acc
			self.dy = self.dy + ny*dt*self.acc
		end
	end

	self.dx = self.dx - self.dx * dt * self.fric
	self.dy = self.dy - self.dy * dt * self.fric

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	if self.x<0 or self.x>love.graphics.getWidth() then
		self.dx = -self.dx * 0.9
		self.x = math.min(love.graphics.getWidth(),math.max(0,self.x))
	end

	if self.y<0 or self.y>love.graphics.getHeight() then
		self.dy = -self.dy * 0.9
		self.y = math.min(love.graphics.getHeight(),math.max(0,self.y))
	end

	local speed = math.max(1,math.min(100,math.sqrt(self.dx*self.dx+self.dy*self.dy)/200))

end

function player_mt:draw()
	if not finalised then
		love.graphics.setColor(0,0,0)
		local speed = math.max(1,math.min(100,math.sqrt(self.dx*self.dx+self.dy*self.dy)/200))
		love.graphics.circle("fill", self.x, self.y, 10/speed)
		love.graphics.setLineWidth(10/speed*2)
		love.graphics.line(self.x, self.y, self.oldx, self.oldy)
		self.oldx = self.x
		self.oldy = self.y
	end
end