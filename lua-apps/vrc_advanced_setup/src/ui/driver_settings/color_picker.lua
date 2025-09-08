local currentEditColor = "Red"

function ledColorPicker(color)
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

function ledColorEditor()
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
