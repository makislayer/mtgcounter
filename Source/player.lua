local screenWidth = playdate.display.getWidth()
local gfx = playdate.graphics

local font = gfx.font.new('fonts/Flak Attack Huge');
local invertedFont = gfx.font.new('fonts/Flak Attack Huge Inverted');

class('Player').extends(playdate.graphics.sprite)

function Player:init()

	Player.super.init(self)
	self.lifeFont = font
	self.life = 20
	self.name = "Player"
	self:setCenter(0.5,0.5)
	self:setZIndex(900)
	self:setIgnoresDrawOffset(true)
end

function Player:setLife(newNumber)
	self.life = newNumber

	gfx.setFont(self.lifeFont)
	local width = gfx.getTextSize(self.life)
	self:setSize(width, 84)
	self:markDirty()
end

function Player:setName(newName)
	self.name = newNumber

	gfx.setFont(self.lifeFont)
	local width = gfx.getTextSize(self.life)
	self:setSize(width, 84)
	self:markDirty()
end

function Player:setActive()
	self.lifeFont = invertedFont
	self:markDirty()
end

function Player:setInactive()
	self.lifeFont = font
	self:markDirty()
end

-- draw callback from the sprite library
function Player:draw(x, y, width, height)
	
	gfx.setFont(self.lifeFont)
	gfx.drawText(self.life, 0, 0)
		
end