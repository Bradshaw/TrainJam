require("weapon")

local dude_mt = {}
dude = {}

function dude.new()
	local self = setmetatable({},{__index=dude_mt})

	local marb = m:select(function(tile) return tile.tiletype=="marble" end)
	print(#marb)
	local start = marb[math.random(1,#marb)]
	self.x = start.x+0.5
	self.y = start.y+0.5

	self.dx = 0
	self.dy = 0

	self.aim = {x=1, y=0}

	self.weapon = {
		pistol = weapon.new()
	}
	self.currentweapon = self.weapon.pistol


	return self
end

function dude_mt:update( dt )
	self.dy = self.dy - self.dy * 3 * dt
	self.dx = self.dx - self.dx * 3 * dt
	local ax = 0
	local ay = 0
	if love.keyboard.isDown("left","q","a") then
		self.dx = self.dx - dt * 10
		ax = ax-1
	end
	if love.keyboard.isDown("right","d") then
		self.dx = self.dx + dt * 10
		ax = ax+1
	end
	if love.keyboard.isDown("up","z","w") then
		self.dy = self.dy - dt * 10
		ay = ay-1
	end
	if love.keyboard.isDown("down","s") then
		self.dy = self.dy + dt * 10
		ay = ay+1
	end

	self.y = self.y + self.dy*dt
	if not m.data[math.floor(self.x)][math.floor(self.y)].pass then
		self.y = self.y - self.dy*dt
		self.dy = -self.dy
	end

	self.x = self.x + self.dx*dt
	if not m.data[math.floor(self.x)][math.floor(self.y)].pass then
		self.x = self.x - self.dx*dt
		self.dx = -self.dx
	end
	self.currentweapon:update(dt)
	if love.keyboard.isDown(" ") then
		self.currentweapon:tryFire(self, self.aim)
	else
		if ax~=0 or ay~=0 then
			local dx, dy = ax, ay
			local d = math.sqrt(dx*dx+dy*dy)
			local nx, ny = dx/d, dy/d
			self.aim = {x=nx, y=ny}
		end
	end
	
end

function dude_mt:draw(  )

	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(5,5,5,127)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex-3,(self.y-1)*tile.sizey-1,7,2)

	love.graphics.setColor(200,25,25)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex-2,(self.y-1)*tile.sizey-7,5,7)
end