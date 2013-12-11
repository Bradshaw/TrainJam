require("tile")

local map_mt = {}
map = {}
map.sizex = math.floor(love.graphics.getWidth()/tile.sizex)
map.sizey = math.floor(love.graphics.getHeight()/tile.sizey)

function map.new()
	local self = setmetatable({},{__index = map_mt})

	self.data = {}
	for i=1,map.sizex do
		self.data[i] = {}
		for j=1,map.sizey do
			self.data[i][j] = tile.wall()
		end
	end

	return self
end

function map.maze()
	local self = map.new()

	local sx, sy = math.random(1,math.floor(map.sizex/2))*2, math.random(1,math.floor(map.sizey/2))*2

	self:doMaze(sx, sy)



	return self
end

function map.dungeon( )
	local self = map.maze()

	for i=1,12 do
		local cx = math.random(4,map.sizex-5)
		local cy = math.random(4,map.sizey-5)
		local bx = math.random(2,4)
		local by = math.random(2,4)
		for i=math.floor(math.max(2,cx-bx)/2)*2,math.floor(math.min(map.sizex-1,cx+bx)/2)*2 do
			for j=math.floor(math.max(2,cy-by)/2)*2,math.floor(math.min(map.sizey-1,cy+by)/2)*2 do
				self.data[i][j]=tile.marble()
			end		
		end

	end

	self:removeDead()




	return self
end

function map_mt:doMaze(x, y)
	local dir = {{0,-1},{0,1},{1,0},{-1,0}}
	--self.data[x][y] = tile.floor()
	dir = useful.shuffle(dir)
	for i,v in ipairs(dir) do
		local lx, ly = x+v[1]*2, y+v[2]*2
		if lx>=1 and lx<=map.sizex-1 and ly>=1 and ly<=map.sizey-1 then
			if not self.data[lx][ly].pass then
				self.data[x+v[1]][y+v[2]] = tile.floor()
				self.data[lx][ly] = tile.floor()
				self:doMaze(lx,ly)
			end
		end
	end
end

function map_mt:removeDead()
	repeat
		local removed = 0
		for i=2,map.sizex-1 do
			for j=2,map.sizey-1 do
				if self.data[i][j].pass then
					local edges = 0
					local dir = {{0,-1},{0,1},{1,0},{-1,0}}
					for _,v in ipairs(dir) do
						if not self.data[i+v[1]][j+v[2]].pass then
							edges = edges+1
						end
					end
					if edges>=3 then
						self.data[i][j]=tile.wall()
						removed = removed+1
					end
				end
			end
		end
	until removed==0
end

function map_mt:select(func)
	local selection = {}
	for i,v in ipairs(self.data) do
		for j,u in ipairs(v) do
			if func(u) then
				table.insert(selection, {x=i,y=j})
			end
		end
	end
	return selection
end

function map_mt:update( dt )
	for i,v in ipairs(self.data) do
		for j,u in ipairs(v) do
			u:update(dt)
		end
	end
end

function map_mt:draw(  )
	for i,v in ipairs(self.data) do
		for j,u in ipairs(v) do
			u:draw(i,j)
		end
	end
end

function map_mt:drawcap(  )
	for i,v in ipairs(self.data) do
		for j,u in ipairs(v) do
			u:drawcap(i,j)
		end
	end
end