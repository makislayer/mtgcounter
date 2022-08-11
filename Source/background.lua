import 'CoreLibs/graphics'

local displayWidth, displayHeight = playdate.display.getSize()
local gfx <const> = playdate.graphics

local halfDisplayWidth = displayWidth / 2
local cuarterDisplayWidth = displayWidth / 4
local halfDisplayHeight = displayHeight / 2

local upArrowImage=gfx.image.new("images/up_arrow")
local downArrowImage=gfx.image.new("images/down_arrow")

class('Background').extends(playdate.graphics.sprite)

function Background:init()
	Background.super.init(self)
    self.x=0
    self.y=0
    self.width=halfDisplayWidth
    self.height=displayHeight
    self.timer=0
	self:setZIndex(0)
	self:setIgnoresDrawOffset(true)
    self:setSize(self.width, self.height)
    self:setCenter(0.5,0.5)
	self:add()
end

function Background:setBackgroundSize(numPlayers)
    self.width = halfDisplayWidth
    if numPlayers > 2 then
        self.height = halfDisplayHeight
    else 
        self.height = displayHeight
    end
    self:setSize(self.width, self.height)
    self:markDirty()
end

function Background:drawNormal(x, y, width, height)
    gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(x,y,width, height)
end

function Background:drawWithArrows(x, y, width, height)
    gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(x,y,width, height)
    upArrowImage:draw(0,0)
    downArrowImage:draw(0,self.height-16)
end

-- draw callback from the sprite library
function Background:draw(x, y, width, height)
    if(self.timer<30) then self:drawWithArrows(x, y, width, height) else self:drawNormal(x, y, width, height) end
end

function Background:update()
    self.timer+=1
    if self.timer == 30 then self:markDirty() end
end
