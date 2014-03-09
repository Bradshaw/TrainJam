local tile_mt = {}
local water_mt = setmetatable({},{__index = tile_mt})
local weed_mt = setmetatable({},{__index = tile_mt})
tile = {}

tile.all = {}
tile.sizex = 6
tile.sizey = 6
tile.mintime = 0
tile.maxtime = 0.01

function tile.new( x, y, energy, dir, meta )
	local x = math.floor(x)
	local y = math.floor(y)
	if not tile.get(x,y) then
		local self = setmetatable({},{__index=tile_mt})
		if math.random()>0.5 then
			setmetatable(self,{__index=weed_mt})
		end
		if meta then
			setmetatable(self,meta)
		end
		self.x = x
		self.y = y
		self.energy = energy or 10

		self.time = tile.mintime+(math.random()*(tile.maxtime-tile.mintime))
		self.dir = (dir or math.random(-1,1)) + math.random(-1,1)
		self.dir = math.max(-1,math.min(1,self.dir))


		if not tile.all[x] then
			tile.all[x]={}
		end
		tile.all[x][y] = self
		return self
	end
end

function tile.update(dt)
	for k,v in pairs(tile.all) do
		for j,u in pairs(v) do
			if k<0 or k>love.graphics.getWidth()/tile.sizex or j<0 or j>love.graphics.getHeight()/tile.sizey or u.purge then
				tile.all[k][j] = nil
			else
				u:update(dt)
			end
		end
	end
end

function tile.draw()
	for k,v in pairs(tile.all) do
		for j,u in pairs(v) do
			u:draw()
		end
	end
end

function tile.water(x,y)
	local self = tile.new(x, y)
	if self then
		setmetatable(self,{__index = water_mt})
		self.time = 0.03
	end
end

function tile.get(x, y)
	if tile.all[x] then
		return tile.all[x][y]
	end
end

function tile_mt:update( dt )
	if self.energy > 0 then
		self.time = self.time - dt
		if self.time<=0 then
			self.time = self.time+tile.mintime+(math.random()*(tile.maxtime-tile.mintime))
			local dir = {{self.dir,-1},{self.dir,-1},{self.dir,0},{self.dir,0},{self.dir,-1},{self.dir,-1},{0,-1},{0,-1}}
			local d = dir[math.random(1,#dir)]
			if not tile.get(self.x+d[1],self.y+d[2]) then
				tile.new(self.x+d[1],self.y+d[2], math.max(0,self.energy-3), self.dir, getmetatable(self))
				self.energy = math.floor(math.max(0,self.energy-2))
			else
				local t = tile.get(self.x+d[1],self.y+d[2])
				if self.energy>t.energy then
					t.energy = t.energy+1
					self.energy = self.energy-1
					self.energy = math.floor(math.max(0,self.energy))
				end
			end
		end
	else
		self.time = tile.mintime+(math.random()*(tile.maxtime-tile.mintime))
	end
end

function weed_mt:update( dt )
	if self.energy > 0 then
		self.time = self.time - dt
		if self.time<=0 then
			self.time = self.time+tile.mintime+(math.random()*(tile.maxtime-tile.mintime))
			local dir = {{0,-1},{self.dir,-1},{self.dir,0},{self.dir,0}}
			local d = dir[math.random(1,#dir)]
			if not tile.get(self.x+d[1],self.y+d[2]) then
				tile.new(self.x+d[1],self.y+d[2], self.energy-1, self.dir, getmetatable(self))
				if math.random()>0.2 then
					self.energy = 0
				else
					self.energy = self.energy-1
				end
			else
				local t = tile.get(self.x+d[1],self.y+d[2])
				t.energy = t.energy+self.energy
				self.energy = 0
			end
		end
	else
		self.time = self.time - dt
		--[[
		if self.time<=0 then
			if self.prepped and not self.dropped then
				local d = {0,1}
				if not tile.get(self.x+d[1],self.y+d[2]) then
					--tile.water(self*.x+d[1],self.y+d[2],0,0,getmetatable(self))
					--self.purge = true
					self.energy = 2
				else
					
				end
			elseif not self.prepped then
				self.time = 2+math.random()*2
				self.prepped = true
			end
		end
		--]]
	end
end

function water_mt:update( dt )
	if self.ticked then
		local d = {0,1}
		if not tile.get(self.x+d[1],self.y+d[2]) then
			tile.water(self.x+d[1],self.y+d[2])
			self.purge = true
		else
			local t = tile.get(self.x+d[1],self.y+d[2])
			t.energy = t.energy+20
			self.purge = true
		end
	else
		self.ticked = true
	end
end

function tile_mt:draw()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(0,200,0)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex,(self.y-1)*tile.sizey,tile.sizex,tile.sizey)
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(self.energy*40,self.energy*40,self.energy*40)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex+1,(self.y-1)*tile.sizey+1,tile.sizex-2,tile.sizey-2)
end

function weed_mt:draw()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(200,200,0)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex,(self.y-1)*tile.sizey,tile.sizex,tile.sizey)
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(self.energy*40,self.energy*40,self.energy*40)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex+1,(self.y-1)*tile.sizey+1,tile.sizex-2,tile.sizey-2)
end

function water_mt:draw()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(30,100,255)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex,(self.y-1)*tile.sizey,tile.sizex,tile.sizey)
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(self.energy,self.energy,self.energy)
	love.graphics.rectangle("fill",(self.x-1)*tile.sizex+1,(self.y-1)*tile.sizey+1,tile.sizex-2,tile.sizey-2)
end