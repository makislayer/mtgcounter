import 'CoreLibs/ui'
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/crank'
import 'CoreLibs/timer'

import 'player'
import 'background'


-- ! timers and other aux variables

local gfx = playdate.graphics
local displayWidth, displayHeight = playdate.display.getSize()
local halfDisplayWidth = displayWidth / 2
local quarterDisplayWidth = displayWidth / 4
local halfDisplayHeight = displayHeight / 2

-- ! game states

local numberOfPlayers = 2
local activePlayer = 1

-- ! set up sprites

local player1Sprite = Player()
local player2Sprite = Player()
local player3Sprite = Player()
local player4Sprite = Player()

local players = {player1Sprite, player2Sprite, player3Sprite, player4Sprite}

local backgroundSprite = Background()

-- ! aux functions

function setPlayersLife(numberOfPlayers)
	if numberOfPlayers > 2 then 
		for i,p in ipairs(players) do p:setLife(40)	end
	end
end

function setPlayersLayout(numberOfPlayers)
	if numberOfPlayers > 2 then 
	else 
		for i = 1,numberOfPlayers do
			players[i]:add()
			players[i]:moveTo(i*halfDisplayWidth-quarterDisplayWidth,halfDisplayHeight)
		end
		backgroundSprite:setBackgroundSize(numberOfPlayers)
		backgroundSprite:moveTo((activePlayer-1)*halfDisplayWidth,0)
	end
end

function setPlayersNames() 
	for i in ipairs(players) do 
		players[i]:setName("Player " .. i)	
	end
end

function updatePlayersColours()
	backgroundSprite:moveTo((activePlayer-1)*halfDisplayWidth,0)
	for i = 1,numberOfPlayers do
		players[i]:setInactive()
	end
	players[activePlayer]:setActive()
end

-- ! game flow functions

function setup()
	playdate.ui.crankIndicator:start()
	setPlayersLife(numberOfPlayers)
	setPlayersLayout(numberOfPlayers)
	setPlayersNames()
	players[activePlayer]:setActive()	
end

-- ! game initialization

playdate.display.setRefreshRate(15)

setup()

-- ! main loop

function playdate.update()
--	if(playdate.isCrankDocked()) then playdate.ui.crankIndicator:update() end
	gfx.sprite.update()
end

-- ! Button Functions

function playdate.leftButtonDown()	
	if activePlayer > 1 then 
		activePlayer -= 1
		updatePlayersColours()
	end
end
function playdate.leftButtonUp()	end
function playdate.rightButtonDown()
	if activePlayer < numberOfPlayers then 
		activePlayer += 1
		updatePlayersColours()
	end	
end
function playdate.rightButtonUp()	end

function playdate.upButtonDown()
	life = players[activePlayer].life + 1
	players[activePlayer]:setLife(life)
end
function playdate.upButtonUp()end

function playdate.downButtonDown()
	life = players[activePlayer].life - 1
	players[activePlayer]:setLife(life)
end
function playdate.downButtonUp()end

function playdate.AButtonDown()		
	print(players[activePlayer].life)
end
function playdate.AButtonUp()	end
function playdate.BButtonDown()		print("BD")	end
function playdate.BButtonUp()		print("BU")	end
function playdate.cranked(change, acceleratedChange)
	revolution = playdate.getCrankTicks(1)
	if revolution~=0 then
		life = players[activePlayer].life + revolution
		players[activePlayer]:setLife(life)
	end
end