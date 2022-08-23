import 'CoreLibs/ui'
import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/crank'
import 'CoreLibs/timer'

import 'player'
import 'background'
import 'history'

-- ! timers and other aux variables

local gfx <const> = playdate.graphics

local timeToUpdateLife = 5 * 1000
local timeToHide = 2 * 1000
local lifeTimer = nil
local keyTimer = nil
local hideTimer = nil

local displayWidth, displayHeight = playdate.display.getSize()
local halfDisplayWidth = displayWidth / 2
local quarterDisplayWidth = displayWidth / 4
local halfDisplayHeight = displayHeight / 2
local quarterDisplayHeight = displayHeight / 4

local leftPosition = halfDisplayWidth-quarterDisplayWidth
local rightPosition = displayWidth-quarterDisplayWidth
local leftHiddenPosition = - 80
local rightHiddenPosition = displayWidth + 80

-- ! game states

local file = playdate.datastore.read()
local numberOfPlayers = 2
local activePlayer = 1
local availableFonts = {"Flak Attack", "Gaiapolis", "Hot Chase"}
local currentFont = availableFonts[3]
local lifeHistoryActive = false

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

local player1historySprite = History()
local player2historySprite = History()
local player3historySprite = History()
local player4historySprite = History()

local history = {player1historySprite, player2historySprite, player3historySprite, player4historySprite}

local backgroundSprite = Background()

-- ! aux functions

function setPlayersLife()
	local life = 20
	if numberOfPlayers > 2 then life = 40 end
	for i,p in ipairs(players) do
		p:setLife(life)
		history[i]:resetLife(numberOfPlayers, life)
	end
end

function loadPlayersLife()
	if file~=nil then
		local lifes = file[3]
		for i in ipairs(players) do
			players[i]:setLife(lifes[i])
			history[i]:resetLife(numberOfPlayers, players[i].life)
		end
	else setPlayersLife()
	end
end

function setPlayersLayout(newNumberOfPlayers)
	for i in ipairs(players) do
		players[i]:remove()
		history[i]:remove()
	end
	players[1]:moveTo(leftPosition,halfDisplayHeight)
	players[2]:moveTo(rightPosition,halfDisplayHeight)
	players[3]:moveTo(leftPosition,halfDisplayHeight+quarterDisplayHeight)
	players[4]:moveTo(rightPosition,halfDisplayHeight+quarterDisplayHeight)
	history[1]:moveTo(leftHiddenPosition,halfDisplayHeight)
	history[2]:moveTo(rightHiddenPosition,halfDisplayHeight)
	history[3]:moveTo(leftHiddenPosition,quarterDisplayHeight)
	history[4]:moveTo(rightHiddenPosition,halfDisplayHeight+quarterDisplayHeight)
	if newNumberOfPlayers > 2 then
		players[1]:moveTo(leftPosition,quarterDisplayHeight)
		players[2]:moveTo(rightPosition,quarterDisplayHeight)
		history[1]:moveTo(leftHiddenPosition,quarterDisplayHeight)
		history[2]:moveTo(rightHiddenPosition,quarterDisplayHeight)
	end
	for i = 1,newNumberOfPlayers do
		players[i]:add()
		history[i]:add()
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
	backgroundSprite.timer=0
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

function slideScreen(direction)
	local slide = 180
	if (not lifeHistoryActive and (direction == 2 or direction == 4)) or (lifeHistoryActive and (direction == 1 or direction == 3)) then slide = -slide end
	backgroundSprite:moveBy(slide,0)
	for i = 1, numberOfPlayers do
		players[i]:moveBy(slide,0)
		history[i]:moveBy(slide,0)
	end
	lifeHistoryActive = not lifeHistoryActive
end

function updateLifeHistory()
	for i in ipairs(history) do
		history[i]:updateLife(players[i].life)
	end
end

function resetLifeTimer()
		if lifeTimer ~= nil then lifeTimer:remove() end
	lifeTimer = playdate.timer.new(timeToUpdateLife, updateLifeHistory)
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
playdate.setAutoLockDisabled(true)

setup()

-- ! main loop

function playdate.update()
--	if(playdate.isCrankDocked()) then playdate.ui.crankIndicator:update() end
	gfx.sprite.update()
	playdate.timer.updateTimers()
end

-- ! Button Functions

function playdate.leftButtonDown()
	if not lifeHistoryActive and activePlayer > 1 then
		activePlayer -= 1
		updatePlayersColours()
	end
end
function playdate.leftButtonUp()	end
function playdate.rightButtonDown()
	if not lifeHistoryActive and activePlayer < numberOfPlayers then
		activePlayer += 1
		updatePlayersColours()
	end
end
function playdate.rightButtonUp()	end

function playdate.upButtonDown()
	local function timerCallback()
		life = players[activePlayer].life + 1
		players[activePlayer]:setLife(life)
		resetLifeTimer()
	end
	keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
end

function playdate.upButtonUp() keyTimer:remove() end

function playdate.downButtonDown()
	local function timerCallback()
		life = players[activePlayer].life - 1
		players[activePlayer]:setLife(life)
		resetLifeTimer()
	end
	keyTimer = playdate.timer.keyRepeatTimer(timerCallback)
end

function playdate.downButtonUp() keyTimer:remove() end

function playdate.AButtonDown()
	slideScreen(activePlayer)
end
function playdate.AButtonUp()	end
function playdate.BButtonDown()
	if lifeHistoryActive then slideScreen(activePlayer) end
end
function playdate.BButtonUp()			end
function playdate.cranked(change, acceleratedChange)
	revolution = playdate.getCrankTicks(1)
	if revolution~=0 then
		if change > 4 or change < -4 then
			life = players[activePlayer].life - revolution
			players[activePlayer]:setLife(life)
			resetLifeTimer()
		end
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