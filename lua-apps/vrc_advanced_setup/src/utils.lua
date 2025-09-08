local activeItem = ""

function slider(label, value, min, max, round, format, color, size, step, noScroll, ceil, shiftStep, mult, offset)
	if not step then
		step = 1
	end

	if not offset then
		offset = 0
	end

	if not shiftStep then
		shiftStep = 1
	end

	if not color then
		color = rgbm(0.5, 0.5, 0.5, 1)
	end

	if not mult then
		mult = 1
	end

	local width, height

	if not size then
		width = 475 * cui.scaleY()
		height = 32 * cui.scaleY()
	else
		width = size.x * cui.scaleY()
		height = size.y * cui.scaleY()
	end

	local sliderWidth = 10 * cui.scaleY()

	local value, changed = value, false

	local xPos = ui.getCursorX()
	local yPos = ui.getCursorY()
	local xMax = xPos + width

	ui.drawRectFilled(ui.getCursor(), ui.getCursor() + vec2(width, height), rgbm(0.2, 0.2, 0.2, 0.5))

	ui.invisibleButton("invis" .. label, vec2(width, height))
	ui.setCursor(vec2(xPos, yPos))

	local sliderPosition = ((value - min) / (max - min)) * (width - sliderWidth)

	if not ui.mouseDown(ui.MouseButton.Left) then
		activeItem = ""
	end

	if activeItem == label and ui.mouseDown(ui.MouseButton.Left) then
		ui.pushStyleColor(ui.StyleColor.Button, rgbm(0.74, 0, 0, 1))
	else
		ui.pushStyleColor(ui.StyleColor.Button, color)
	end

	ui.offsetCursorX(sliderPosition)
	ui.button("##" .. label, vec2(sliderWidth, height), ui.ButtonFlags.None)
	ui.popStyleColor(1)

	if
		ui.itemActive()
		or (activeItem == label and ui.mouseDown(ui.MouseButton.Left))
		or (
			ui.mouseLocalPos() > vec2(xPos, yPos)
			and ui.mouseLocalPos() <= vec2(xPos, yPos) + vec2(width, height)
			and (
				(ui.mouseClicked(ui.MouseButton.Left) and not ui.itemHovered(ui.HoveredFlags.None))
				or (ui.mouseWheel() ~= 0 and not noScroll)
			)
		)
	then
		changed = true

		if ui.mouseWheel() ~= 0 then
			local valueChangeAmount = (ui.keyboardButtonDown(ui.KeyIndex.Shift) and shiftStep or step)
			value = ui.mouseWheel() < 0 and (math.round(value) - valueChangeAmount)
				or (math.round(value) + valueChangeAmount)
		else
			activeItem = label
			value = (ui.mouseLocalPos().x - xPos) / (xMax - (sliderWidth / 2) - xPos) * (max - min) + min
		end
	end

	value = math.clamp(value, min, max)

	if ceil then
		value = math.ceil(value)
	else
		value = math.round(value, round)
	end

	ui.sameLine()
	ui.setCursorX(xPos)

	ui.dwriteTextAligned(
		string.format(format, value * mult + offset),
		16 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(width, height) + vec2(sliderWidth, 0)
	)

	return value, changed
end

function setupSlider(setupItemString, min, max, round, format, multiplier, offset, step, shiftStep)
	if not offset then
		offset = 0
	end

	if not step then
		step = 1
	end

	if not shiftStep then
		shiftStep = 1
	end

	local prevValue = ac.getSetupSpinnerValue(setupItemString) * multiplier + offset

	local value, changed =
		slider("##" .. setupItemString, prevValue, min, max, round, format, nil, nil, step, false, true, shiftStep)

	if changed then
		ac.setSetupSpinnerValue(setupItemString, value / multiplier - offset)
	end

	return value, changed
end
