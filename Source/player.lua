local screenWidth = playdate.display.getWidth()
local gfx = playdate.graphics

class('Player').extends(playdate.graphics.sprite)

function Player:init()

	Player.super.init(self)
	self.lifeFont = gfx.font.new('fonts/Roobert-24-Medium-Numerals');
	self.life = 20
	self.name = "Player"
	self:setCenter(1,0)
	self:setZIndex(900)
	self:setIgnoresDrawOffset(true)
	self:add()
end

function Player:setLife(newNumber)
	self.life = newNumber

	gfx.setFont(self.lifeFont)
	local width = gfx.getTextSize(self.life)
	self:setSize(width, 36)
	self:markDirty()
end

function Player:setName(newName)
	self.name = newNumber

	gfx.setFont(self.lifeFont)
	local width = gfx.getTextSize(self.life)
	self:setSize(width, 36)
	self:markDirty()
end

function Player:setActive(newName)

end

-- draw callback from the sprite library
function Player:draw(x, y, width, height)
	
	gfx.setFont(self.lifeFont)
	gfx.drawText(self.life, 0, 0)
		
end