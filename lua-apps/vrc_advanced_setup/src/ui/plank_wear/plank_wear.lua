local sim = ac.getSim()
local car = ac.getCar(0)

COLLIDERS = ac.connect({
	ac.StructItem.key(ac.getCarID(0) .. "_COLLIDERS_" .. 0),
	plankWear = ac.StructItem.float(),
	frontLegalityWear = ac.StructItem.float(),
	midLegalityWear = ac.StructItem.float(),
	rearLegalityWear = ac.StructItem.float(),
	installNewPlank = ac.StructItem.boolean(),
	frontWingDamage = ac.StructItem.array(ac.StructItem.boolean(), 3),
	collisionDepth = ac.StructItem.float(),
	collidedWith = ac.StructItem.int16(),
}, true, ac.SharedNamespace.Shared)

local plankImage = ac.dirname() .. "\\assets\\plank.png"
local plankImageSize = ui.imageSize(plankImage) / 2.48

function runPlankWear()
	cui.pushTabWindow("plankData", 0, 50, 505, 440)

	ui.setCursorX(ui.windowWidth() / 2 - plankImageSize.x / 2)
	ui.image(plankImage, plankImageSize * cui.scaleY())

	cui.setCursorX(135)
	ui.setCursorY(ui.windowHeight() / 2)
	ui.dwriteTextAligned(
		"Max Wear Limit - 1 mm",
		16 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(ui.windowWidth(), 24 * cui.scaleY())
	)

	cui.setCursorY(14)
	local frontLegalWear = math.round(COLLIDERS.frontLegalityWear * 1000, 5)

	ui.dwriteText(
		string.format("Front Legality Wear: %.5f mm", frontLegalWear),
		12 * cui.scaleY(),
		frontLegalWear < 1 and rgbm.colors.white or rgbm.colors.red
	)

	cui.setCursorY(107)
	local midLegalWear = math.round(COLLIDERS.midLegalityWear * 1000, 5)

	ui.dwriteText(
		string.format("Mid Legality Wear: %.5f mm", midLegalWear),
		12 * cui.scaleY(),
		midLegalWear < 1 and rgbm.colors.white or rgbm.colors.red
	)

	cui.setCursorY(356)
	local rearLegalWear = math.round(COLLIDERS.rearLegalityWear * 1000, 5)
	ui.dwriteText(
		string.format("Rear Legality Wear: %.5f mm", rearLegalWear),
		12 * cui.scaleY(),
		rearLegalWear < 1 and rgbm.colors.white or rgbm.colors.red
	)

	cui.popTabWindow()

	cui.pushTabWindow("plankData2", 515, 50, 505, 440)

	local plankButtonFlags = ui.ButtonFlags.None
	local plankString = "Install New Plank"

	if car.maxRelativePlankWear == 0 then
		plankButtonFlags = ui.ButtonFlags.Disabled
		plankString = "New Plank Installed"
	elseif sim.raceSessionType == ac.SessionType.Qualify or sim.raceSessionType == ac.SessionType.Race then
		plankButtonFlags = ui.ButtonFlags.Disabled
		plankString = "Plank Cannot Be Replaced"
	end

	if cui.button(plankString, 475, 32, 14, ui.Alignment.Center, ui.Alignment.Center, plankButtonFlags) then
		COLLIDERS.installNewPlank = true
	end
	ui.pushTextWrapPosition(475 * cui.scaleY())
	ui.dwriteText(
		"Exceeding the 1 mm plank wear limit for any of the legality check zones, will result in all subsequent laps being invalidated.",
		12 * cui.scaleY()
	)

	ui.dwriteText(
		"A new floor plank can be installed only during practice sessions, planks cannot be replaced during qualifying or race sessions. A new plank will automatically be installed at the beginning of a qualifying session.",
		12 * cui.scaleY()
	)

	ui.dwriteText(
		"Planks should be replaced when making large setup alterations that may affect the plank wear significantly.",
		12 * cui.scaleY()
	)
	ui.popTextWrapPosition()

	cui.popTabWindow()
end
