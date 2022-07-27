local displayWidth, displayHeight = playdate.display.getSize()
local gfx = playdate.graphics

local halfDisplayWidth = displayWidth / 2
local cuarterDisplayWidth = displayWidth / 4
local halfDisplayHeight = displayHeight /2

class('Background').extends(playdate.graphics.sprite)

function Background:init()
	Background.super.init(self)
    self.x=0
    self.y=0
    self.width=halfDisplayWidth
    self.height=displayHeight
	self:setZIndex(0)
	self:setIgnoresDrawOffset(true)
    self:setSize(self.width, self.height)
    self:setCenter(0,0)
	self:add()
end

function Background:setBackgroundSize(numPlayers)
    self.height = displayHeight
    if numPlayers > 2 then
        self.width = cuarterDisplayWidth
    else 
        self.width = halfDisplayWidth
    end
    self:markDirty()
end

-- draw callback from the sprite library
function Background:draw(x, y, width, height)
    gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(x,y,width, height)
end
