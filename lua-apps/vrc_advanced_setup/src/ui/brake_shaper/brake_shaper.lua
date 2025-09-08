require("src.ui.brake_shaper.graph")
require("src.utils")

local brakeShapes = {}

local shapeCompareGraph = Graph(vec2(55, 20), vec2(420, 385), 25, 100)

local copiedShape = -1

local maxFrontBrakeTorque = ac.INIConfig.carData(0, "brakes.ini"):get("DATA", "MAX_TORQUE", 4524.89) * 2 * 0.62

local function getBrakeShapes()
	for shape = 1, 5 do
		if not brakeShapes[shape] then
			brakeShapes[shape] = {}
		end

		local fbtup = ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. shape .. "_RAMP_START_TORQUE"])
		local fbtdn = ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. shape .. "_RAMP_END_TORQUE"])
		local bb = ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_BIAS_COARSE"]) / 10

		for i = 0, 25 do
			local torqueStep = (6309 / 25) * i
			local bmig = ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MIG_" .. shape]) / 100

			local baseBB = bb - bmig

			local migrationAmount = math.smootherstep(math.saturateN((torqueStep - fbtup) / (fbtdn - fbtup))) * bmig
			brakeShapes[shape][i + 1] = (baseBB + migrationAmount - 37) / (62 - 37) * 100
		end
	end
end

local function brakeShapeEditorGraph()
	cui.pushTabWindow("brakeShapeSelector", 515, 50, 505, 140)

	local value, changed = slider(
		"##BRAKE_BIAS_COARSE",
		ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_BIAS_COARSE"]),
		520,
		620,
		0,
		"Brake Bias: %.1f %%",
		nil,
		nil,
		5,
		false,
		true,
		5,
		0.1
	)
	if changed then
		ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_BIAS_COARSE"], value)
	end

	local value, changed = slider(
		"##BRAKE_SHAPE_MAP",
		ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MAP"]) + 1,
		1,
		5,
		0,
		"Brake Shape Map: %.0f",
		nil,
		nil,
		1,
		false,
		false
	)
	if changed then
		ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MAP"], value - 1)
	end
	local brakeShapeMap = value

	cui.offsetCursorY(10)

	if cui.iconButton("Copy", ui.Icons.Copy, 100, 32) then
		copiedShape = brakeShapeMap
		copyBrakeShape(copiedShape)
	end

	if ui.itemHovered() then
		ui.tooltip(3, function()
			ui.text("[L-Click] Copy Shape")
		end)
	end

	local pasteButtonFlag = ui.ButtonFlags.None

	if copiedShape == -1 then
		pasteButtonFlag = ui.ButtonFlags.Disabled
	end

	ui.sameLine(110 * cui.scaleY())
	if cui.iconButton("Paste", ui.Icons.Paste, 100, 32, pasteButtonFlag) then
		pasteBrakeShape(brakeShapeMap)
	end

	if copiedShape ~= -1 then
		if ui.itemClicked(ui.MouseButton.Right) then
			for targetShape = 1, 5 do
				pasteBrakeShape(targetShape)
			end
		end
		if ui.itemHovered() then
			ui.tooltip(3, function()
				ui.text("[L-Click] Paste Shape " .. copiedShape .. " to Shape " .. brakeShapeMap)
				ui.text("[R-Click] Paste Shape " .. copiedShape .. " to All Shapes")
			end)
		end
	end

	ui.sameLine(374 * cui.scaleY())
	if cui.iconButton("Reset", ui.Icons.Restart, 100, 32) then
		resetShape(brakeShapeMap)
	end
	if ui.itemClicked(ui.MouseButton.Right) then
		for targetShape = 1, 5 do
			resetShape(targetShape)
		end
	end
	if ui.itemHovered() then
		ui.tooltip(3, function()
			ui.text("[L-Click] Reset Shape " .. brakeShapeMap)
			ui.text("[R-Click] Reset All Shapes")
		end)
	end

	cui.popTabWindow()
	cui.pushTabWindow("brakeShapeEdit", 515, 200, 505, 290)

	-- local brakeMigration = setupSlider(
	-- 	setupIDToSectionKeyMap["BRAKE_SHAPE_MIG_" .. brakeShapeMap],
	-- 	0,
	-- 	15,
	-- 	2,
	-- 	"Brake Migration: %.2f %%",
	-- 	0.01,
	-- 	2,
	-- 	2,
	-- 	1
	-- )

	local value, changed = slider(
		"##BRAKE_SHAPE_MIG_" .. brakeShapeMap,
		ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MIG_" .. brakeShapeMap]),
		0,
		1500,
		0,
		"Brake Migration: %.2f %%",
		nil,
		nil,
		25,
		false,
		true,
		25,
		0.01
	)
	if changed then
		ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MIG_" .. brakeShapeMap], value)
	end

	local value, changed = slider(
		"##BRAKE_SHAPE_" .. brakeShapeMap .. "_RAMP_START_TORQUE",
		ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. brakeShapeMap .. "_RAMP_START_TORQUE"]),
		0,
		maxFrontBrakeTorque / 2 - 100,
		0,
		"Front Brake Ramp Start Torque: %.0f Nm",
		nil,
		nil,
		50,
		false,
		true,
		1
	)
	if changed then
		ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. brakeShapeMap .. "_RAMP_START_TORQUE"], value)
	end

	local value, changed = slider(
		"##BRAKE_SHAPE_" .. brakeShapeMap .. "_RAMP_END_TORQUE",
		ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. brakeShapeMap .. "_RAMP_END_TORQUE"]),
		maxFrontBrakeTorque / 2 + 100,
		maxFrontBrakeTorque,
		0,
		"Front Brake Ramp End Torque: %.0f Nm",
		nil,
		nil,
		50,
		false,
		true,
		1
	)
	if changed then
		ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. brakeShapeMap .. "_RAMP_END_TORQUE"], value)
	end

	cui.popTabWindow()

	cui.pushTabWindow("brakeShapeGraph", 0, 50, 505, 440)

	shapeCompareGraph:drawGraph(true)
	shapeCompareGraph:drawLabels("Front Brake Torque (Nm)", "Brake Balance (%)", 0, 6600, 62 - 25, 62)

	for i = 1, 5 do
		if i ~= brakeShapeMap then
			shapeCompareGraph:drawLines(brakeShapes[i], rgbm.colors.gray * 1.5)
		end
	end

	shapeCompareGraph:drawLines(brakeShapes[brakeShapeMap], rgbm.colors.red)

	cui.popTabWindow()
end

function brakeShapeGraphWindow()
	getBrakeShapes()

	ui.pushFont(ui.Font.Title)
	brakeShapeEditorGraph()
	ui.popFont()
end
