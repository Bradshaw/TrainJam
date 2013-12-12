require("bullet")

local weapon_mt = {
	super = function(self) return getmetatable(getmetatable(self).__index).__index end,
	top = function(self)
		if self:super() then
			return self:super():top()
		else
			return getmetatable(self).__index
		end
	end,
}
weapon = {}

function weapon.new()
	local self = setmetatable({},{__index = weapon_mt})
	self.ammo = 100
	self.cooldown = 0.3
	self.cool = 0
	return self
end

function weapon_mt:update( dt )
	self.cool = math.max(0,self.cool-dt)
end

function weapon_mt:tryFire(pos, aim)
	if self.cool<=0 and self.ammo>=1 then
		self.cool = self.cooldown
		self:fire(pos, aim)
		self.ammo = self.ammo - 1
	end
end

function weapon_mt:fire( pos, aim )
	bullet.new(pos.x, pos.y, aim.x, aim.y)
end

