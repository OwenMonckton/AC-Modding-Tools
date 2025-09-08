local tonePanString = {
	[-1] = "Left",
	[0] = "Center",
	[1] = "Right",
}

local ledShiftPatternString = {
	"Sequential",
	"Sequential-Block",
	"Block-Block",
}

-- for _k, _v in pairs(driverSettingsStorage) do
-- 	for key, table in pairs(_v) do
-- 		driverSettingsStorage[key] = table["default"]
-- 	end
-- end

local currentEditColor = "Red"

local function ledColorPicker(color)
	ui.dwriteText(
		color .. ": ",
		16 * cui.scaleY(),
		currentEditColor == color and rgbm.colors.yellow or rgbm.colors.white
	)
	ui.sameLine()

	local colorKey = "led" .. color

	local colorPickerFlags = ui.ColorPickerFlags.None
	ui.colorButton("Pick Me", DRIVER_SETTINGS[colorKey], colorPickerFlags, vec2(32, 32) * cui.scaleY())

	if ui.itemClicked(ui.MouseButton.Left) then
		currentEditColor = color
	end

	if ui.itemClicked(ui.MouseButton.Right) then
		DRIVER_SETTINGS[colorKey .. "Reset"] = true
		DRIVER_SETTINGS.settingsChanged = true
	end

	ui.sameLine()
	ui.dummy(10 * cui.scaleY())
end

local function ledColorEditor()
	local color = currentEditColor
	local colorKey = "led" .. color

	local value, changed =
		slider("##led" .. color .. "R", DRIVER_SETTINGS[colorKey].r * 100, 0, 100, 0, "R: %.0f", nil, nil, nil, true)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS[colorKey].r = value / 100
	end

	local value, changed =
		slider("##led" .. color .. "G", DRIVER_SETTINGS[colorKey].g * 100, 0, 100, 0, "G: %.0f", nil, nil, nil, true)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS[colorKey].g = value / 100
	end

	local value, changed =
		slider("##led" .. color .. "B", DRIVER_SETTINGS[colorKey].b * 100, 0, 100, 0, "B: %.0f", nil, nil, nil, true)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS[colorKey].b = value / 100
	end

	local value, changed = slider(
		"##led" .. color .. "M",
		DRIVER_SETTINGS[colorKey].mult * 100,
		0,
		100,
		0,
		"Mult: %.0f",
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS[colorKey].mult = value / 100
	end
end

function runDriverSettings()
	if not DRIVER_SETTINGS.connected then
		return
	end

	cui.pushTabWindow("settingsLeft", 0, 50, 505, 440, true)

	ui.pushFont(ui.Font.Title)

	ui.setCursorX(0)
	ui.dwriteTextAligned(
		"Audio",
		18 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Start,
		vec2(505, 30) * cui.scaleY()
	)

	ui.setNextItemWidth(cui.availableSpaceX())
	local value, changed = slider(
		"##drsTone",
		DRIVER_SETTINGS.drsTone,
		0,
		3,
		0,
		DRIVER_SETTINGS.drsTone == 0 and "DRS Tone: Off" or "DRS Tone: %.0f"
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.drsTone = value
	end

	local value, changed = slider(
		"##drsTonePan",
		DRIVER_SETTINGS.drsTonePan,
		-1,
		1,
		0,
		"DRS Tone L\\R Balance: " .. tonePanString[DRIVER_SETTINGS.drsTonePan]
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.drsTonePan = math.round(value)
	end

	local value, changed =
		slider("##drsToneVolume", DRIVER_SETTINGS.drsToneVolume * 100, 50, 150, 0, "DRS Tone Volume: %.0f %%")
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.drsToneVolume = value / 100
	end

	local value, changed =
		slider("##drsTonePitch", DRIVER_SETTINGS.drsTonePitch * 100, 90, 110, 0, "DRS Tone Pitch: %.0f %%")
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.drsTonePitch = value / 100
	end

	cui.dummy(10, 32)

	local value, changed = slider(
		"##shiftTone",
		DRIVER_SETTINGS.shiftTone,
		0,
		3,
		0,
		DRIVER_SETTINGS.shiftTone == 0 and "Shift Tone: Off" or "Shift Tone: %.0f"
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.shiftTone = value
	end

	local value, changed = slider(
		"##shiftTonePan",
		DRIVER_SETTINGS.shiftTonePan,
		-1,
		1,
		0,
		"Shift Tone L\\R Balance: " .. tonePanString[DRIVER_SETTINGS.shiftTonePan]
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.shiftTonePan = math.round(value)
	end

	local value, changed =
		slider("##shiftToneVolume", DRIVER_SETTINGS.shiftToneVolume * 100, 50, 150, 0, "Shift Tone Volume: %.0f %%")
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.shiftToneVolume = value / 100
	end

	ui.setNextItemWidth(cui.availableSpaceX())
	local value, changed =
		slider("##shiftTonePitch", DRIVER_SETTINGS.shiftTonePitch * 100, 90, 110, 0, "Shift Tone Pitch: %.0f %%")
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.shiftTonePitch = value / 100
	end

	ui.popFont()
	cui.popTabWindow(true)

	cui.pushTabWindow("settingsRight", 515, 50, 505, 440, true)

	ui.pushFont(ui.Font.Title)

	ui.setCursorX(0)
	ui.dwriteTextAligned(
		"Display",
		18 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Start,
		vec2(505, 30) * cui.scaleY()
	)

	local value, changed = slider(
		"##displayPopupTime",
		DRIVER_SETTINGS.displayPopupTime / 100,
		0.2,
		3,
		1,
		"Popup Time: %.2f seconds",
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.displayPopupTime = value * 100
	end

	local value, changed = slider(
		"##displayLapPopupTime",
		DRIVER_SETTINGS.displayLapPopupTime / 100,
		0.2,
		3,
		1,
		"Lap Popup Time: %.2f seconds",
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.displayLapPopupTime = value * 100
	end

	local value, changed = slider(
		"##displayInteriorDayBrightness",
		DRIVER_SETTINGS.displayInteriorDayBrightness,
		0,
		100,
		0,
		"Interior Day Brightness: %.0f %%",
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.displayInteriorDayBrightness = value
	end

	local value, changed = slider(
		"##displayInteriorNightBrightness",
		DRIVER_SETTINGS.displayInteriorNightBrightness,
		0,
		100,
		0,
		"Interior Night Brightness: %.0f %%",
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.displayInteriorNightBrightness = value
	end

	local value, changed = slider(
		"##displayExteriorDayBrightness",
		DRIVER_SETTINGS.displayExteriorDayBrightness,
		0,
		100,
		0,
		"Exterior Day Brightness: %.0f %%",
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.displayExteriorDayBrightness = value
	end

	local value, changed = slider(
		"##displayExteriorNightBrightness",
		DRIVER_SETTINGS.displayExteriorNightBrightness,
		0,
		100,
		0,
		"Exterior Night Brightness: %.0f %%",
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.displayExteriorNightBrightness = value
	end

	cui.dummy(10, 32)

	ui.setCursorX(0)
	ui.dwriteTextAligned(
		"LEDs",
		18 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Start,
		vec2(505, 30) * cui.scaleY()
	)

	local value, changed = slider(
		"##ledShiftPattern",
		DRIVER_SETTINGS.ledShiftPattern,
		1,
		3,
		0,
		"Shift Pattern: " .. ledShiftPatternString[DRIVER_SETTINGS.ledShiftPattern],
		nil,
		nil,
		nil,
		true
	)
	if changed then
		DRIVER_SETTINGS.settingsChanged = true
		DRIVER_SETTINGS.ledShiftPattern = value
	end

	if cui.button("LED TEST", 475, 32, 14) then
		DRIVER_SETTINGS.ledTest = not DRIVER_SETTINGS.ledTest
	end

	ledColorPicker("Red")
	ui.sameLine()
	ledColorPicker("Green")
	ui.sameLine()
	ledColorPicker("Blue")
	ui.sameLine()
	ledColorPicker("Yellow")
	ui.sameLine()
	ledColorPicker("Purple")
	ledColorEditor()

	cui.dummy(10, 32)

	ui.popFont()
	cui.popTabWindow(true)
end
