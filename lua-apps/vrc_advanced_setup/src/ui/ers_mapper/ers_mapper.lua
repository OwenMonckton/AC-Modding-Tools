ERS_MAPPER_SELECTED_STRAT = 1
ERS_MAPPER_SELECTED_SPLIT = 1

local isDeploymentMapsAvailable = ac.hasTrackSpline() and ac.getTrackID() ~= "endlessfloor"

if isDeploymentMapsAvailable then
	require("src\\ui\\ers_mapper\\map")
	require("src\\ui\\ers_mapper\\strat_control")
	require("src\\ui\\ers_mapper\\strat_auto_gen")
end

local function drawErsMapperUnavailableWindow()
	cui.pushTabWindow("aiSplineNotPresent", 0, 50, 1020, 510)

	cui.setCursorY(185)

	ui.dwriteTextAligned(
		"No Spline Detected",
		50 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(1020, 50) * cui.scaleY()
	)
	ui.dwriteTextAligned(
		"Deployment Maps Disabled",
		20 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(1020, 50) * cui.scaleY()
	)

	cui.popTabWindow()
end

local function autogenStrats()
	for targetStrat = 1, 8 do
		clearSplits(targetStrat)
		setAutoGenStratSetupItems()
	end
	ERS_MAPS_AUTOGEN_INIT = true
end

function runErsMapper()
	if not isDeploymentMapsAvailable then
		drawErsMapperUnavailableWindow()
		return
	end

	drawMap()

	ui.pushFont(ui.Font.Title)
	stratSelector()
	splitChildWindow()
	ui.popFont()

	if not ERS_MAPS_AUTOGEN_INIT then
		autogenStrats()
	end

	convertSetup()
end
