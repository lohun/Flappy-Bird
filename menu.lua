local composer = require("composer")

local scene = composer.newScene();




local function goToGame()
	composer.gotoScene("level1")
end

local function goToHighScore()
	composer.gotoScene("highscores")
end

function scene:create(event)
	local sceneGroup = self.view

	local background = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
	background:setFillColor(3)

	local title = display.newText(sceneGroup, "Flappy Bird", display.contentCenterX, 50, native.systemFont, 44)
	title:setFillColor(0.82, 0.86, 1);

	local playButton = display.newText(sceneGroup, "Play", display.contentCenterX, 400, native.systemFont, 44);
	playButton:setFillColor(0.82, 0.86, 1);

	local highscoresButton = display.newText(sceneGroup, "Highscores", display.contentCenterX, 450, native.systemFont, 44)
	highscoresButton:setFillColor(0.75, 0.78, 1)

	playButton:addEventListener("tap", goToGame)
	highscoresButton:addEventListener("tap", goToHighScore)
end

-- show()
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif (phase == "did") then
		-- Code here runs when the scene is entirely on screen
	end
end

-- hide()
function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif (phase == "did") then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end

-- destroy()
function scene:destroy(event)
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
