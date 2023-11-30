-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"



local pillars = {}
local top
local bottom
local bird
local background
local gameLoopTimer

local mainGroup




local function createPillars()
	local difference = 450;
	top = display.newImageRect(mainGroup, "Assets/pipeUp.png", 52, 320)
	physics.addBody(top, "static", { bounce = 0.5 })
	top.x = display.contentWidth + 100
	top.y = math.random(display.contentHeight * 0.2);
	top.myName = "pillar"
	top:toBack()


	bottom = display.newImageRect(mainGroup, "Assets/pipeDown.png", 52, 320)
	physics.addBody(bottom, "static", { bounce = 0.5 })
	bottom.x = display.contentWidth + 105
	bottom.y = top.y + difference
	bottom.myName = "pillar"
	bottom:toBack()

	table.insert(pillars, top);
	table.insert(pillars, bottom);
end


local function gameLoop()
	createPillars()

	for i = #pillars, 1, -1 do
		local thisPillar = pillars[i]
		transition.to(thisPillar, {
			x = -50,
			y = thisPillar.y,
			time = 2000,
			onComplete = function()
				display.remove(thisPillar)
				table.remove(pillars, i);
			end
		})
	end
end
--------------------------------------------

local options =
{
	width = 70,
	height = 50,
	numFrames = 4,
	sheetContentWidth = 280, -- width of original 1x size of entire sheet
	sheetContentHeight = 50 -- height of original 1x size of entire sheet
}
local imageSheet = graphics.newImageSheet("Assets/bird.png", options)

local sequenceData =
{
	name = "walking",
	start = 1,
	count = 3,
	time = 300,
	loopCount = 2,         -- Optional ; default is 0 (loop indefinitely)
	loopDirection = "forward" -- Optional ; values include "forward" or "bounce"
}

local function steadyBird()
	bird:applyLinearImpulse(0, -0.1, bird.x, bird.y)
end

local function endGame()
	composer.gotoScene("menu", { time = 800 })
end

local function onCollision(event)
	if (event.phase == "began") then
		local obj1 = event.object1
		local obj2 = event.object2

		if ((obj1.myName == "bird" and obj2.myName == "pillar") or
				(obj1.myName == "pillar" and obj2.myName == "bird") or
				(obj1.myName == "land" and obj2.myName == "bird") or
				(obj1.myName == "bird" and obj2.myName == "pillar")) then
			display.remove(bird)
			timer.performWithDelay(2000, endGame)
			composer.gotoScene("menu", { time = 800, effect = "crossFade" })
		end
	end
end

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create(event)
	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()

	background = display.newImageRect("Assets/ground.png", 320, 569)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local land = display.newImageRect("Assets/land.png", 640, 213)
	land.x = display.contentCenterX
	land.y = display.contentCenterY + 390
	physics.addBody(land, "static");
	land.myName = "land"


	bird = display.newSprite(imageSheet, sequenceData)
	physics.addBody(bird, "dynamic", { isSensor = true });
	bird.x = display.contentCenterX * 0.2
	bird.y = 60
	bird.myName = "bird"

	local landTop = display.newImageRect("Assets/land.png", 640, 213)
	landTop.x = display.contentCenterX
	landTop.y = display.contentCenterY * -0.6
	physics.addBody(landTop, "static", { rotate = 180 });
	landTop.myName = "land"
	landTop:rotate(180)


	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	-- local grassShape = { -halfW, -34, halfW, -34, halfW, 34, -halfW, 34 }
	-- physics.addBody(grass, "static", { friction = 0.3, shape = grassShape })

	mainGroup = display.newGroup()

	-- all display objects must be inserted into group
	sceneGroup:insert(background)
	sceneGroup:insert(mainGroup)
	mainGroup:insert(land)
	mainGroup:insert(bird)
end

function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		gameLoopTimer = timer.performWithDelay(2000, gameLoop, 0)
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		Runtime:addEventListener("collision", onCollision)
		background:addEventListener('tap', steadyBird)
	end

end

function scene:hide(event)
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
	elseif phase == "did" then
		timer.cancel(gameLoopTimer)
		Runtime:removeEventListener("collision", onCollision)
		Runtime:removeEventListener('tap', steadyBird)
		physics.pause()
		composer.removeScene("level1")
		-- Called when the scene is now off screen
	end
end

function scene:destroy(event)
	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view



	-- package.loaded[physics] = nil
	-- physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)


-----------------------------------------------------------------------------------------

return scene
