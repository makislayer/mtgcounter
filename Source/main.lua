import 'CoreLibs/ui'
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/crank'
import 'CoreLibs/timer'

import 'player'


-- ! timers and other aux variables

local gfx = playdate.graphics
local displayWidth, displayHeight = playdate.display.getSize()
local halfDisplayWidth = displayWidth / 2

-- ! game states

local numberOfPlayers = 2

-- ! set up sprites

local player1Sprite = Player()
local player2Sprite = Player()
local player3Sprite = Player()
local player4Sprite = Player()

local players = {player1Sprite, player2Sprite, player3Sprite, player4Sprite}

-- ! aux functions

function setPlayersLife(numberOfPlayers)
	if numberOfPlayers > 2 then 

	end
end

function setPlayersfLayout(numberOfPlayers)
	if numberOfPlayers > 2 then 

	end
end

-- ! game flow functions

function setup()
	playdate.ui.crankIndicator:start()
	setPlayersLife(numberOfPlayers)
	setPlayersfLayout(numberOfPlayers)	
end

-- ! game initialization

playdate.display.setRefreshRate(15)

setup()

-- ! main loop

function playdate.update()
--	if(playdate.isCrankDocked()) then playdate.ui.crankIndicator:update() end
end

-- ! Button Functions

local player = 0

function playdate.leftButtonDown()	player -= 1; print("leftD")	end
function playdate.leftButtonUp()	player += 1; print("leftU")	end
function playdate.rightButtonDown()	player += 1; print("rightD")	end
function playdate.rightButtonUp()	player -= 1; print("rightU")	end

function playdate.AButtonDown()		print("AD")	end
function playdate.AButtonUp()		print("AU")	end
function playdate.BButtonDown()		print("BD")	end
function playdate.BButtonUp()		print("BU")	end
function playdate.cranked(change, acceleratedChange)		print(change)	end