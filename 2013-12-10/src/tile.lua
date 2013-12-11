local tile_mt = {
	super = function(self) return getmetatable(getmetatable(self).__index).__index end,
	tiletype = "none"
}
local wall_mt = setmetatable({tiletype = "wall"},{__index=tile_mt})
local floor_mt = setmetatable({tiletype = "floor"},{__index=tile_mt})
local marble_mt = setmetatable({tiletype = "marble"},{__index=tile_mt})

tile = {}

tile.sizex = 20
tile.sizey = 16

function tile.new()
	local self = setmetatable({},{__index=tile_mt})
	self.pass = true

	return self
end

function tile.wall( )
	local self = setmetatable({},{__index=wall_mt})
	self.pass = false

	return self
end

function tile.floor()
	local self = setmetatable({},{__index=floor_mt})
	self.pass = true

	self.rocks = {}
	for i=1,math.random(0,4) do
		self.rocks[i] = {x=math.random(), y=math.random()}
	end


	return self
end

function tile.marble()
	local self = setmetatable({},{__index=marble_mt})
	self.pass = true

	self.rocks = {}
	for i=1,math.random(0,4) do
		self.rocks[i] = {x=math.random(), y=math.random()}
	end


	return self
end


function tile_mt:update( dt )
	
end


function tile_mt:draw( x, y )
	love.graphics.setColor(65,65,75)
	love.graphics.rectangle("fill", (x-1)*tile.sizex, (y-1)*tile.sizey, tile.sizex, tile.sizey)
end

function tile_mt:drawcap( x, y)
end

function wall_mt:drawcap( x, y)
	love.graphics.setColor(40,40,50)
	love.graphics.rectangle("fill", (x-1)*tile.sizex, (y-1)*tile.sizey-7, tile.sizex, tile.sizey)
end


function wall_mt:draw( x, y )
	love.graphics.setColor(30,30,40)
	love.graphics.rectangle("fill", (x-1)*tile.sizex, (y-1)*tile.sizey, tile.sizex, tile.sizey)
end

function floor_mt:draw( x, y )
	self:super():draw(x, y)
	love.graphics.setColor(55,55,65)
	for i,v in ipairs(self.rocks) do
		love.graphics.rectangle("fill",(x-1+v.x)*tile.sizex-1,(y-1+v.y)*tile.sizey,3,4)
	end

	love.graphics.setColor(75,75,85)
	for i,v in ipairs(self.rocks) do
		love.graphics.rectangle("fill",(x-1+v.x)*tile.sizex-1,(y-1+v.y)*tile.sizey,3,2)
	end
end

function marble_mt:draw( x, y )
	love.graphics.setColor(85,75,65)
	love.graphics.rectangle("fill", (x-1)*tile.sizex, (y-1)*tile.sizey, tile.sizex, tile.sizey)
	love.graphics.setColor(75,65,55)
	for i,v in ipairs(self.rocks) do
		love.graphics.rectangle("fill",(x-1+v.x)*tile.sizex-1,(y-1+v.y)*tile.sizey,3,4)
	end

	love.graphics.setColor(95,85,75)
	for i,v in ipairs(self.rocks) do
		love.graphics.rectangle("fill",(x-1+v.x)*tile.sizex-1,(y-1+v.y)*tile.sizey,3,2)
	end
end