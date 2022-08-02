import 'CoreLibs/ui'
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/crank'
import 'CoreLibs/timer'

import 'player'
import 'background'


-- ! timers and other aux variables

local gfx <const> = playdate.graphics
local displayWidth, displayHeight = playdate.display.getSize()
local halfDisplayWidth = displayWidth / 2
local quarterDisplayWidth = displayWidth / 4
local halfDisplayHeight = displayHeight / 2
local quarterDisplayHeight = displayHeight / 4

local leftPosition = halfDisplayWidth-quarterDisplayWidth
local rightPostion = displayWidth-quarterDisplayWidth

-- ! game states

local file = playdate.datastore.read()
local numberOfPlayers = 2
local activePlayer = 1
local availableFonts = {"Flak Attack", "Gaiapolis", "Hot Chase"}
local currentFont = availableFonts[3]

if file~=nil then 
	numberOfPlayers = file[1]
	currentFont = file[2]
end

-- ! set up sprites

local player1Sprite = Player()
local player2Sprite = Player()
local player3Sprite = Player()
local player4Sprite = Player()

local players = {player1Sprite, player2Sprite, player3Sprite, player4Sprite}

local backgroundSprite = Background()

-- ! aux functions

function setPlayersLife()
	local life = 20
	if numberOfPlayers > 2 then life = 40 end
	for i,p in ipairs(players) do
		p:setLife(life)
	end
end

function loadPlayersLife()
	if file~=nil then
		local lifes = file[3]
		for i in ipairs(players) do
			players[i]:setLife(lifes[i])
		end
	else setPlayersLife()
	end
end

function setPlayersLayout(newNumberOfPlayers)
	for i in ipairs(players) do
		players[i]:remove()
	end
	players[1]:moveTo(leftPosition,halfDisplayHeight)
	players[2]:moveTo(rightPostion,halfDisplayHeight)
	players[3]:moveTo(leftPosition,halfDisplayHeight+quarterDisplayHeight)
	players[4]:moveTo(rightPostion,halfDisplayHeight+quarterDisplayHeight)
	if newNumberOfPlayers > 2 then
		players[1]:moveTo(leftPosition,quarterDisplayHeight)
		players[2]:moveTo(rightPostion,quarterDisplayHeight)
	end
	for i = 1,newNumberOfPlayers do
		players[i]:add()
	end
	backgroundSprite:setBackgroundSize(newNumberOfPlayers)
	backgroundSprite:moveTo(players[activePlayer]:getPosition())
	numberOfPlayers=newNumberOfPlayers
end

function setPlayersFont(newFont)
	currentFont = newFont
	for i in ipairs(players) do
		players[i]:updateFont(currentFont)
	end
	updatePlayersColours()
end

function updatePlayersColours()
	backgroundSprite:moveTo(players[activePlayer]:getPosition())
	for i = 1,numberOfPlayers do
		players[i]:setInactive()
	end
	players[activePlayer]:setActive()
end

function saveConfiguration()
	local lifes = {}
	for i in ipairs(players) do
		lifes[i]=players[i].life
	end
	playdate.datastore.write({numberOfPlayers, currentFont, lifes})
end

-- ! game flow functions

function setup()
	playdate.ui.crankIndicator:start()
	loadPlayersLife()
	setPlayersLayout(numberOfPlayers)
	setPlayersFont(currentFont)
	players[activePlayer]:setActive()
end

-- ! game initialization

playdate.display.setRefreshRate(15)

setup()

-- ! main loop

function playdate.update()
--	if(playdate.isCrankDocked()) then playdate.ui.crankIndicator:update() end
	gfx.sprite.update()
	playdate.timer.updateTimers()
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
end
function playdate.AButtonUp()	end
function playdate.BButtonDown()			end
function playdate.BButtonUp()			end
function playdate.cranked(change, acceleratedChange)
	revolution = playdate.getCrankTicks(1)
	if revolution~=0 then
		life = players[activePlayer].life + revolution
		players[activePlayer]:setLife(life)
	end
end

-- ! Menu Functions

local menu = playdate.getSystemMenu()

menu:addOptionsMenuItem("Font", availableFonts, currentFont, function(value)
	setPlayersFont(value)
	saveConfiguration()
end)

menu:addOptionsMenuItem("Players", {1,2,3,4}, numberOfPlayers, function(value)
	newNumberOfPlayers = tonumber(value)
	if(newNumberOfPlayers < activePlayer) then
		activePlayer = newNumberOfPlayers
	end
    setPlayersLayout(newNumberOfPlayers)
	updatePlayersColours()
	saveConfiguration()
end)

menu:addMenuItem("Reset life", function()
    setPlayersLife()
end)

-- ! System Functions

function playdate.gameWillTerminate()
	saveConfiguration()
end

function playdate.deviceWillSleep()
	saveConfiguration()
end