local blob_mt = {}
blob = {}

blob.all = {}

function blob.new()
	local self = setmetatable({},{__index=blob_mt})

	local marb = m:select(function(tile)
		return tile.pass
	end)
	local start = marb[math.random(1,#marb)]
	while math.abs(start.x-d.x)<3 and math.abs(start.y-d.y)<3 do
		start = marb[math.random(1,#marb)]
	end
	self.x = start.x
	self.y = start.y
	self.posx = 0.5
	self.posy = 0.5
	self.dx = self.x+0.5
	self.dy = self.y+0.5

	self.time = 1

	table.insert(blob.all, self)
	return self
end

function blob.update( dt )
	local i = 1
	while i<=#blob.all do
		local v = blob.all[i]
		if v.purge then
			table.remove(blob.all, i)
		else
			v:update(dt)
			if i>=2 then
				if v.y<blob.all[i-1].y then
					blob.all[i], blob.all[i-1] = blob.all[i-1], blob.all[i]
				end
			end
			i = i + 1
		end
	end
end

function blob.draw()
	for i,v in ipairs(blob.all) do
		v:draw()
	end
end

function blob_mt:update( dt )
	self.time = self.time - dt
	self.dx = useful.lerp(dt*2,self.dx,self.x+self.posx)
	self.dy = useful.lerp(dt*2,self.dy,self.y+self.posy)
	if self.time <=0 then
		self.posx = math.random()
		self.posy = math.random()
		self.time = math.random()
		local blocked = false
		useful.bresenham(self.x,self.y,math.floor(d.x),math.floor(d.y),function( x, y )
			if not m.data[x][y].pass then
				blocked = true
			end
		end)
		if not blocked then
			local dx = math.floor(d.x)-self.x
			local dy = math.floor(d.y)-self.y
			if dx==0 and dy==0 then
				--self.posx = d.x-math.floor(d.x)
				--self.posy = d.y-math.floor(d.y)
			elseif math.random()<math.abs(dx)/(math.abs(dx)+math.abs(dy)) and m.data[self.x+useful.sign(dx)][self.y].pass then
				self.x = self.x+useful.sign(dx)
			elseif m.data[self.x][self.y+useful.sign(dy)].pass then
				self.y = self.y+useful.sign(dy)
			end
		end
	end

end

function blob_mt:draw(  )

	--love.graphics.setBlendMode("additive")
	--love.graphics.setColor(0,255,0)
	--love.graphics.rectangle("line", (self.x-1)*tile.sizex, (self.y-1)*tile.sizey, tile.sizex-1, tile.sizey-1)

	love.graphics.setColor(5,5,5,127)
	love.graphics.rectangle("fill",(self.dx-1)*tile.sizex-3,(self.dy-1)*tile.sizey-1,7,2)

	love.graphics.setColor(25,200,25)
	love.graphics.rectangle("fill",(self.dx-1)*tile.sizex-2,(self.dy-1)*tile.sizey-4,5,4)
end