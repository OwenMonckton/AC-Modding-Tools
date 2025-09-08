local sim = ac.getSim()

local trackStratMapResolution = 50000

local copiedStrat = -1

local finalUpdate = true
local update = false
local wait = false
local last = {}

function stratSelector()
	cui.pushTabWindow("stratSelector", 515, 50, 505, 105)

	ui.setNextItemWidth(cui.availableSpaceX())
	local strat, changed = slider("##stratSlider", ERS_MAPPER_SELECTED_STRAT, 1, 8, 0, "Strat Map: %.0f")
	if changed then
		ERS_MAPPER_SELECTED_STRAT = strat
		update = true
		ac.setMGUKDelivery(strat - 1)
	end

	cui.offsetCursorY(10)

	if cui.iconButton("Copy", ui.Icons.Copy, 100, 32) then
		copiedStrat = ERS_MAPPER_SELECTED_STRAT
		copyStrat(copiedStrat)
	end
	if ui.itemHovered() then
		ui.tooltip(3, function()
			ui.text("[L-Click] Copy Strat")
		end)
	end

	local pasteButtonFlag = ui.ButtonFlags.None

	if copiedStrat == -1 then
		pasteButtonFlag = ui.ButtonFlags.Disabled
	end

	ui.sameLine(110 * cui.scaleY())
	if cui.iconButton("Paste", ui.Icons.Paste, 100, 32, pasteButtonFlag) then
		pasteStrat(ERS_MAPPER_SELECTED_STRAT)
	end

	if copiedStrat ~= -1 then
		if ui.itemClicked(ui.MouseButton.Right) then
			for targetStrat = 1, 8 do
				pasteStrat(targetStrat)
			end
		end
		if ui.itemHovered() then
			ui.tooltip(3, function()
				ui.text("[L-Click] Paste Strat " .. copiedStrat .. " to Strat " .. ERS_MAPPER_SELECTED_STRAT)
				ui.text("[R-Click] Paste Strat " .. copiedStrat .. " to All Strats")
			end)
		end
	end

	ui.sameLine(375 * cui.scaleY())
	if cui.iconButton("Reset", ui.Icons.Restart, 100, 32) then
		clearSplits(ERS_MAPPER_SELECTED_STRAT)
		setAutoGenStratSetupItems(ERS_MAPPER_SELECTED_STRAT)
	end
	if ui.itemClicked(ui.MouseButton.Right) then
		for targetStrat = 1, 8 do
			clearSplits(targetStrat)
			setAutoGenStratSetupItems()
		end
	end
	if ui.itemHovered() then
		ui.tooltip(3, function()
			ui.text("[L-Click] Reset Strat " .. ERS_MAPPER_SELECTED_STRAT)
			ui.text("[R-Click] Reset All Strats")
		end)
	end

	ui.sameLine()
	ui.sameLine(265 * cui.scaleY())
	if cui.iconButton("Clear", ui.Icons.Cancel, 100, 32) then
		clearSplits(ERS_MAPPER_SELECTED_STRAT)
	end
	if ui.itemClicked(ui.MouseButton.Right) then
		for targetStrat = 1, 8 do
			clearSplits(targetStrat)
		end
	end
	if ui.itemHovered() then
		ui.tooltip(3, function()
			ui.text("[L-Click] Clear Strat " .. ERS_MAPPER_SELECTED_STRAT)
			ui.text("[R-Click] Clear All Strats")
		end)
	end

	cui.popTabWindow()

	cui.pushTabWindow("deploymentEstimations", 515, 165, 505, 100)

	local mgukDeployLengthM = 0
	local eboostTurboLengthM = 0

	for i = 1, 24 do
		local length = getSplitKEnd(ERS_MAPPER_SELECTED_STRAT, i) - getSplitHEnd(ERS_MAPPER_SELECTED_STRAT, i)
		mgukDeployLengthM = mgukDeployLengthM + length

		local length = getSplitHEnd(ERS_MAPPER_SELECTED_STRAT, i) - getSplitHKStart(ERS_MAPPER_SELECTED_STRAT, i)
		eboostTurboLengthM = eboostTurboLengthM + length
	end

	ui.dwriteText(string.format("Potential MGU-K Deploy: %.1f MJ", mgukDeployLengthM * 0.0011), 15 * cui.scaleY())
	ui.dwriteText(string.format("Potential E-Boost Turbo: %.1f MJ", eboostTurboLengthM * 0.0021), 15 * cui.scaleY())
	ui.dwriteText(
		string.format("Potential Total Delivery: %.1f MJ", (mgukDeployLengthM * 0.0011) + (eboostTurboLengthM * 0.0021)),
		15 * cui.scaleY()
	)

	cui.popTabWindow()
end

local splitHKStartKey = ""
local splitHEndKey = ""
local splitKEndKey = ""

local function updateSplitKeys(strat, split)
	splitHKStartKey = setupIDToSectionKeyMap["STRAT_" .. strat .. "_HK_DEPLOYMENT_" .. split .. "_START"]
	splitHEndKey = setupIDToSectionKeyMap["STRAT_" .. strat .. "_H_DEPLOYMENT_" .. split .. "_END"]
	splitKEndKey = setupIDToSectionKeyMap["STRAT_" .. strat .. "_K_DEPLOYMENT_" .. split .. "_END"]
end

local frame = 0

local lastStrat = nil
local lastSplit = nil

function split(strat)
	cui.pushTabWindow("splitEditor", 515, 275, 505, 215)

	ui.setNextItemWidth(cui.availableSpaceX())
	local split, changed = slider("##someSliderID2", ERS_MAPPER_SELECTED_SPLIT, 1, 24, 0, "SPLIT: %.0f")
	if changed then
		ERS_MAPPER_SELECTED_SPLIT = split
		update = true
	end

	if lastStrat ~= ERS_MAPPER_SELECTED_STRAT or lastSplit ~= ERS_MAPPER_SELECTED_SPLIT then
		updateSplitKeys(ERS_MAPPER_SELECTED_STRAT, ERS_MAPPER_SELECTED_SPLIT)
		lastStrat = ERS_MAPPER_SELECTED_STRAT
		lastSplit = ERS_MAPPER_SELECTED_SPLIT
		update = true
	end

	local hkStartValueChange = 0

	ui.newLine(15)
	ui.setNextItemWidth(cui.availableSpaceX())
	local hkStartvalue, changed = slider(
		"##strat" .. strat .. "hk" .. split .. "start",
		ac.getSetupSpinnerValue(splitHKStartKey),
		0,
		sim.trackLengthM,
		0,
		"Split Start Pos: %.0f m",
		nil,
		nil,
		10,
		false,
		true,
		1
	)
	if changed or not last[splitHKStartKey] or last[splitHKStartKey] ~= hkStartvalue then
		update = true

		if changed then
			hkStartValueChange = hkStartvalue - (last[splitHKStartKey] and last[splitHKStartKey] or 0)
		end

		last[splitHKStartKey] = hkStartvalue
	end

	ui.pushStyleColor(ui.StyleColor.SliderGrab, rgbm.colors.aqua)

	ui.setNextItemWidth(cui.availableSpaceX())
	local kEndValue, changed = slider(
		"##strat" .. strat .. "k" .. split .. "end",
		ac.getSetupSpinnerValue(splitKEndKey) + hkStartValueChange,
		hkStartvalue,
		sim.trackLengthM,
		0,
		"MGU-K Deploy Length: %.0f m",
		rgbm.colors.aqua,
		nil,
		10,
		false,
		true,
		1,
		1,
		-hkStartvalue
	)
	if changed or not last[splitKEndKey] or last[splitKEndKey] ~= kEndValue then
		update = true
		last[splitKEndKey] = kEndValue
	end

	ui.popStyleColor(1)

	ui.pushStyleColor(ui.StyleColor.SliderGrab, rgbm(0.7, 0, 0, 1))

	ui.setNextItemWidth(cui.availableSpaceX())
	local hEndValue, changed = slider(
		"##strat" .. strat .. "h" .. split .. "end",
		ac.getSetupSpinnerValue(splitHEndKey) + hkStartValueChange,
		hkStartvalue,
		kEndValue,
		0,
		"E-Boost Turbo Length: %.0f m",
		rgbm(0.7, 0, 0, 1),
		nil,
		10,
		false,
		true,
		1,
		1,
		-hkStartvalue
	)
	if changed or not last[splitHEndKey] or last[splitHEndKey] ~= hEndValue then
		update = true
		last[splitHEndKey] = hEndValue
	end

	ui.popStyleColor(1)

	if not ui.mouseDown(ui.MouseButton.Left) and not finalUpdate and not update then
		finalUpdate = true

		drawERSCanvas()
	end

	if update and not wait then
		finalUpdate = false
		ac.setSetupSpinnerValue(splitHKStartKey, hkStartvalue)

		ac.setSetupSpinnerValue(splitKEndKey, kEndValue)

		ac.setSetupSpinnerValue(splitHEndKey, hEndValue)

		if frame < 0.1 then
			frame = frame + ac.getScriptDeltaT()
		else
			frame = 0
			drawErsSplitCanvas(split, finalUpdate)
			update = false
		end
	end

	cui.popTabWindow()
end

function splitChildWindow()
	split(ERS_MAPPER_SELECTED_STRAT)
end
