local windowSettings = ac.storage({
	pinned = false,
})

local currentApp = 0

local function tabItem(tabCount, index, title)
	ui.pushStyleColor(
		ui.StyleColor.ButtonHovered,
		currentApp == index and rgbm(0.74, 0, 0, 1) or rgbm(0.25, 0.25, 0.25, 0.4)
	)
	ui.pushStyleColor(ui.StyleColor.Button, currentApp == index and rgbm(0.74, 0, 0, 1) or rgbm.colors.transparent)
	ui.pushStyleColor(
		ui.StyleColor.ButtonActive,
		currentApp == index and rgbm(0.74, 0, 0, 1) or rgbm.colors.transparent
	)

	cui.setCursorY(0)
	if cui.button(title, 200, 34, 14, ui.Alignment.Center, ui.Alignment.Start) then
		currentApp = index
	end

	ui.sameLine()

	ui.popStyleColor(3)
end

local acArrow = ac.getFolder(ac.FolderID.Root) .. "\\launcher\\themes\\default\\graphics\\24\\pulldown_icons.png"
local acArrowSize = ui.imageSize(acArrow)
acArrowSize.x = acArrowSize.x * 1.1
local acArrowSizeY = acArrowSize.y

local divPositions = {}

local tabBarPosition = 0

function tabBar(apps)
	ui.pushFont(ui.Font.Title)
	ui.pushStyleVar(ui.StyleVar.ItemSpacing, 0)

	cui.setCursorX(0)

	ui.drawRectFilled(vec2(0, 0), vec2(ui.availableSpaceX(), 36) * cui.scaleY(), rgbm(0.1, 0.1, 0.1, 0.5))

	ui.pushClipRect(vec2(25, 0) * cui.scaleY(), vec2(995, 36) * cui.scaleY())

	tabBarPosition = math.applyLag(
		tabBarPosition,
		currentApp * (-200 * cui.scaleY()) + (224 * cui.scaleY()),
		0.4,
		ac.getScriptDeltaT()
	)

	ui.setCursorX(tabBarPosition)
	cui.setCursorY(-1)
	for i in ipairs(apps) do
		divPositions[i] = ui.getCursorX()
		tabItem(#apps, i - 1, apps[i][1])
	end

	for i in ipairs(apps) do
		if i ~= 1 then
			local divPos = divPositions[i]
			ui.drawSimpleLine(vec2(divPos, 6 * cui.scaleY()), vec2(divPos, 26 * cui.scaleY()), rgbm.colors.white, 2)
		end
	end

	ui.popClipRect()

	ui.drawRect(vec2(0, 0), vec2(cui.windowMaxWidth(), 35 * cui.scaleY()), rgbm(0.1, 0.1, 0.1, 1), 0, nil, 1)

	if
		ui.mouseClicked(ui.MouseButton.Right)
		and ui.mouseLocalPos() >= vec2(0, 0)
		and ui.mouseLocalPos() < vec2(cui.windowMaxWidth(), 35 * cui.scaleY())
	then
		ui.popup(function()
			ui.setCursorX(0)
			ui.setCursorY(0)
			if
				cui.iconButton(
					windowSettings.pinned and "Unpin" or "Pin",
					windowSettings.pinned and ui.Icons.Pinned or ui.Icons.Pin,
					100,
					32,
					ui.ButtonFlags.None
				)
			then
				windowSettings.pinned = not windowSettings.pinned
			end
		end, {
			size = vec2(100 * cui.scaleY(), 32 * cui.scaleY()),
			flags = ui.WindowFlags.NoScrollWithMouse + ui.WindowFlags.NoScrollbar,
		})
	end

	ui.drawRectFilled(vec2(3, 1) * cui.scaleY(), vec2(25, 33) * cui.scaleY(), rgbm(0.74, 0, 0, 1))
	ui.drawRectFilled(vec2(1017, 1) * cui.scaleY(), vec2(995, 33) * cui.scaleY(), rgbm(0.74, 0, 0, 1))

	cui.setCursorX(1)
	cui.setCursorY(5)
	ui.beginRotation()
	ui.image(acArrow, acArrowSize * cui.scaleY())
	ui.endRotation(0)

	cui.setCursorX(993)
	cui.setCursorY(5)
	ui.beginRotation()
	ui.image(acArrow, acArrowSize * cui.scaleY())
	ui.endRotation(180)

	cui.setCursorX(3)
	cui.setCursorY(1)
	if ui.invisibleButton("##prevTab", vec2(22, 32) * cui.scaleY()) then
		currentApp = currentApp == 0 and #apps - 1 or currentApp - 1
	end

	cui.setCursorX(995)
	cui.setCursorY(1)
	if ui.invisibleButton("##nextTab", vec2(22, 32) * cui.scaleY()) then
		currentApp = currentApp == #apps - 1 and 0 or currentApp + 1
	end

	ui.popStyleVar(1)
	ui.popFont()

	return currentApp + 1
end
