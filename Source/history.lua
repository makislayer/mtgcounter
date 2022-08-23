local displayWidth, displayHeight = playdate.display.getSize()
local quarterDisplayWidth = displayWidth / 4
local halfdisplayHeight = displayHeight / 2
local middle = quarterDisplayWidth / 2
local gfx <const> = playdate.graphics

local font = gfx.font.new('fonts/Hot Chase');

class('History').extends(playdate.graphics.sprite)

function History:init(lifeValue)

	History.super.init(self)
	self.lifeFont = font
	self.life = {"20"," "," "," "," "," "," "," "," "}
	self.dif = {"*"," "," "," "," "," "," "," "," "}
	self.elements = 1
	self.maxElements = 18
	self:setCenter(0.5,0.5)
	self:setSize(90, displayHeight)
	self:setZIndex(900)
	self:setIgnoresDrawOffset(true)
end

function History:resetLife(numberOfPlayers, startingValue)
	if startingValue == 0 then
		startingValue = "20"
		if numberOfPlayers > 2 then startingValue = "40" end
	end
	self.elements = 1
	for i = 1, self.maxElements do
		self.life[i] = " "
		self.dif[i] = " "
	end
	self.life[1] = startingValue
	self.dif[1] = " "
	self:markDirty()
end

function History:updateLife(newLife)
	local diff = newLife - tonumber(self.life[self.elements])
	if diff ~= 0 then
		local diffString = tostring(diff)
		if diff > 0 then diffString = "+"..diff end
		if self.elements <= self.maxElements then
			self.elements += 1
			self.life[self.elements] = tostring(newLife)
			self.dif[self.elements] = diffString
		else 
			table.remove(self.life, 1)
			table.remove(self.dif, 1)
			table.insert(self.life, tostring(newLife))
			table.insert(self.dif, diffString)
		end
		gfx.setFont(self.lifeFont)
		self:markDirty()
	end
	
end

function History:setPlayers(numberOfPlayers)
	if numberOfPlayers > 2 then
		self.maxElements = 8
		self:setSize(90, halfdisplayHeight)
	else
		self.maxElements = 18
		self:setSize(90, displayHeight)
	end
	self:resetLife(numberOfPlayers, 0)
end

function History:updateFont(newFont)
	font = gfx.font.new('fonts/'..newFont)
end

function History:drawTable()
	gfx.setFont(self.lifeFont)
	for i in ipairs(self.life) do
		gfx.drawText(self.dif[i], middle - 34, (i)*12)
		gfx.drawText(self.life[i], middle, (i)*12)
	end
end

-- draw callback from the sprite library
function History:draw(x, y, width, height)
	self:drawTable()
end