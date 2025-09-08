---@ext

local SIM = ac.getSim()
local car = ac.getCar(0)

local round = math.round

local quickPitMenuFocused = true

local margins = 20

local defaultWidth = 255
local defaultHeight = 452
local ratio = defaultWidth / defaultHeight
local windowMaxWidth = 0
local windowMaxHeight = 0
local currentScale = 1
local itemSpacing = 5

local vec2Temp1 = vec2()
local vec2Temp2 = vec2()

local colors = {
	activatedRed = rgbm(1, 0, 0, 0.8),
	activeRed = rgbm(0.5, 0, 0, 0.8),
	gray = rgbm(0, 0, 0, 0.5),
}

local function setPitMenuAccess(active)
	if quickPitMenuFocused == active then
		return
	end

	quickPitMenuFocused = active
	ac.disableQuickMenuPitstop(not quickPitMenuFocused)
end

local navControlToggleMenus = ac.ControlButton("vrc_advanced_setup_COCKPIT_MENUS")
local navControlRightButton = ac.ControlButton(
	"vrc_advanced_setup_COCKPIT_X_R",
	{ keyboard = ac.KeyIndex.Left, gamepad = ac.GamepadButton.DPadLeft }
)
local navControlLeftButton = ac.ControlButton(
	"vrc_advanced_setup_COCKPIT_X_L",
	{ keyboard = ac.KeyIndex.Right, gamepad = ac.GamepadButton.DPadRight }
)
local navControlDownButton = ac.ControlButton(
	"vrc_advanced_setup_COCKPIT_Y_DN",
	{ keyboard = ac.KeyIndex.Down, gamepad = ac.GamepadButton.DPadDown }
)
local navControlUpButton = ac.ControlButton(
	"vrc_advanced_setup_COCKPIT_Y_UP",
	{ keyboard = ac.KeyIndex.Up, gamepad = ac.GamepadButton.DPadUp }
)

local activeGroupID = 12
local activeGroupItemIDs = {}
local activateItemTriggered = false
local activateItem = -1
local lastActiveItem = -1

local carCockpitIDIndex = 1

CarCockpitControl = class("CarCockpitControl")

function CarCockpitControl:initialize(
	longName,
	shortName,
	event,
	activation,
	qsKey,
	ecuKey,
	format,
	displayOffset,
	displayMult,
	zeroIsOff
)
	self.id = carCockpitIDIndex
	carCockpitIDIndex = carCockpitIDIndex + 1

	self.longName = longName
	self.shortName = shortName
	self.event = event
	self.activation = activation
	self.qsKey = qsKey
	self.ecuKey = ecuKey
	self.format = format
	self.displayOffset = displayOffset
	self.displayMult = displayMult
	self.carStart = false
	self.zeroIsOff = zeroIsOff or false

	self.itemIDs = {}

	if type(self.shortName) == "boolean" then
		self.carStart = true
	end
end

local popActiveButtonStyle = false
function CarCockpitControl:popButtonStyle()
	if popActiveButtonStyle then
		ui.popStyleColor(2)
		popActiveButtonStyle = false
	end
end

function CarCockpitControl:pushButtonStyle(push)
	if push then
		ui.pushStyleColor(ui.StyleColor.Button, colors.activatedRed)
		ui.pushStyleColor(ui.StyleColor.FrameBg, colors.activatedRed)
		popActiveButtonStyle = true
	elseif activeGroupID == self.id then
		ui.pushStyleColor(ui.StyleColor.Button, colors.activeRed)
		ui.pushStyleColor(ui.StyleColor.FrameBg, colors.activeRed)
		popActiveButtonStyle = true
	end
end

function CarCockpitControl:carStartControl()
	ui.setCursorX(margins)
	self:pushButtonStyle(lastActiveItem == self.itemIDs[1] and navControlLeftButton:down())
	if
		ui.button(
			"IGNITION",
			vec2Temp1:set(windowMaxWidth / 2 - margins - itemSpacing, 32 * currentScale),
			car.speedKmh < 5 and ui.ButtonFlags.None or ui.ButtonFlags.Disabled
		)
	then
		ac.broadcastSharedEvent("IGNITION")
	end

	if not self.itemIDs[1] then
		self.itemIDs[1] = ui.getLastID()
	end

	if activeGroupID == self.id then
		activeGroupItemIDs[1] = ui.getLastID()
	end
	self:popButtonStyle()

	self:pushButtonStyle(lastActiveItem == self.itemIDs[2] and ECU.isElectronicsBooted and navControlRightButton:down())
	ui.sameLine()
	if
		ui.button(
			"STARTER",
			vec2Temp1:set(windowMaxWidth / 2 - margins, 32 * currentScale),
			(ECU.isElectronicsBooted and car.speedKmh < 5) and ui.ButtonFlags.None or ui.ButtonFlags.Disabled
		)
	then
		if ECU.isElectronicsBooted then
			ac.broadcastSharedEvent("STARTER")
		end
	end

	if not self.itemIDs[2] then
		self.itemIDs[2] = ui.getLastID()
	end

	if activeGroupID == self.id then
		activeGroupItemIDs[2] = ui.getLastID()
	end
	self:popButtonStyle()
end

function CarCockpitControl:sequentialControl()
	local format = self.format
	if self.format == 0 then
		format = round(ECU[self.ecuKey] * 1000) / 1000 == 0 and "%.1f" or "%+.1f"
	end

	local buttonFlag = ui.ButtonFlags.None

	if QUICK_SWITCH.activeIndex > 0 and self.qsKey and QUICK_SWITCH[self.qsKey] ~= -1 then
		buttonFlag = ui.ButtonFlags.Disabled
	end

	self:pushButtonStyle(lastActiveItem == self.itemIDs[1] and navControlLeftButton:down())
	ui.setCursorX(margins)
	if
		ui.arrowButton(
			"##" .. self.longName .. "dn",
			ui.Direction.Left,
			vec2Temp1:set(32, 32) * currentScale,
			buttonFlag
		)
	then
		ac.broadcastSharedEvent(self.event .. (self.activation and "" or "_DN"))
	end

	if not self.itemIDs[1] then
		self.itemIDs[1] = ui.getLastID()
	end

	if activeGroupID == self.id then
		activeGroupItemIDs[1] = ui.getLastID()
	end
	self:popButtonStyle()

	self:pushButtonStyle(activeGroupID == self.id and navControlRightButton:down())
	ui.sameLine()
	ui.setCursorX(windowMaxWidth - (32 * currentScale) - margins)
	if
		ui.arrowButton(
			"##" .. self.longName .. "up",
			ui.Direction.Right,
			vec2Temp1:set(32, 32) * currentScale,
			buttonFlag
		)
	then
		ac.broadcastSharedEvent(self.event .. (self.activation and "" or "_UP"))
	end

	if not self.itemIDs[2] then
		self.itemIDs[2] = ui.getLastID()
	end

	if activeGroupID == self.id then
		activeGroupItemIDs[2] = ui.getLastID()
	end
	self:popButtonStyle()

	ui.sameLine(55 * currentScale)
	ui.textAligned(self.shortName, vec2Temp1:set(0.35, 0.6), vec2Temp2:set(100, 30))

	ui.sameLine(150 * currentScale)

	if self.activation then
		ui.textAligned(ECU[self.ecuKey] and "ON" or "OFF", vec2Temp1:set(0.5, 0.5), vec2Temp2:set(40, 30))
	else
		local valueText = ""

		if self.zeroIsOff then
			valueText = ECU[self.ecuKey] == 0 and "OFF"
				or string.format(format, ECU[self.ecuKey] * self.displayMult + self.displayOffset)
		else
			valueText = string.format(format, ECU[self.ecuKey] * self.displayMult + self.displayOffset)
		end

		ui.textAligned(valueText, vec2Temp1:set(0.5, 0.5), vec2Temp2:set(40, 30))
	end
end

function CarCockpitControl:drawControl()
	if self.carStart then
		self:carStartControl()
	else
		self:sequentialControl()
	end
end

local cockpitControls = {
	CarCockpitControl("Driver Preset", "Preset", "QS", false, nil, "qsActiveIndex", "%.0f", 0, 1, true),
	CarCockpitControl(
		"Brake Bias Offset",
		"BB Offset",
		"BB_COARSE",
		false,
		"BRAKE_BIAS_OFFSET",
		"brakeBiasOffset",
		0,
		0,
		100
	),
	CarCockpitControl("Brake Shape", "BBAL", "BMIG", false, "BRAKE_SHAPE_MAP", "brakeShapeMap", "%.0f", 0, 1),
	CarCockpitControl("Deploy Strat", "STRT", "DEPLOYMENT_STRAT", false, nil, "deploymentStrat", "%.0f", 1, 1),
	CarCockpitControl("PU Mode", "MODE", "PU_MODE", false, nil, "puMode", "%.0f", 0, 1),
	CarCockpitControl("Engine Braking", "TRQ", "EB", false, "ENGINE_BRAKE", "engineBrakeSetting", "%.0f", 1, 1),
	CarCockpitControl("Diff Entry", "DIFF", "DIFF_ENTRY", false, "DIFF_ENTRY", "differentialEntry", "%.0f", 1, 1),
	CarCockpitControl("Diff Mid", "MID", "DIFF_MID", false, "DIFF_MID", "differentialMid", "%.0f", 1, 1),
	CarCockpitControl(
		"Diff Exit/Hispd",
		"EXIT",
		"DIFF_EXIT_HISPD",
		false,
		"DIFF_EXIT_HISPD",
		"differentialExitHispd",
		"%.0f",
		1,
		1
	),
	CarCockpitControl("Brake Warming", "BWARM", "BRAKE_MAGIC", true, nil, "isBrakeMagicActive"),
	CarCockpitControl("Display Page", "Ds", "DISPLAY_PAGE", nil, false, "displayPage", "%.0f", 0, 1),
	CarCockpitControl("", true),
}

local acCarControls = ac.overrideCarControls(0)

navControlToggleMenus:onPressed(function()
	if not quickPitMenuFocused then
		ac.setWindowOpen("carCockpitControls", false)
		setPitMenuAccess(true)
	else
		ac.setWindowOpen("carCockpitControls", true)
		setPitMenuAccess(false)
	end
end)

navControlLeftButton:onPressed(function()
	if quickPitMenuFocused then
		acCarControls.lookLeft = true
		return
	end

	activateItem = activeGroupItemIDs[1]
	activateItemTriggered = true
end)

navControlLeftButton:onReleased(function()
	acCarControls.lookLeft = false
end)

navControlRightButton:onPressed(function()
	if quickPitMenuFocused then
		acCarControls.lookRight = true
		return
	end

	activateItem = activeGroupItemIDs[2]
	activateItemTriggered = true
end)

navControlRightButton:onReleased(function()
	acCarControls.lookRight = false
end)

navControlDownButton:onPressed(function()
	if quickPitMenuFocused then
		acCarControls.lookBack = true
		return
	end

	activeGroupID = activeGroupID < #cockpitControls and activeGroupID + 1 or 1
end)

navControlDownButton:onReleased(function()
	acCarControls.lookBack = false
end)

navControlUpButton:onPressed(function()
	if quickPitMenuFocused then
		return
	end
	activeGroupID = activeGroupID > 1 and activeGroupID - 1 or #cockpitControls
end)

local function drawAppBackground()
	ui.drawRectFilled(vec2Temp1:set(0, 0), vec2Temp2:set(windowMaxWidth, windowMaxHeight), colors.gray)
end

local function triggerAciveItem()
	if activateItemTriggered then
		ui.activateItem(activateItem)
		lastActiveItem = activateItem
		activateItemTriggered = false
	end
end

local function drawCarCockpitControls()
	ui.pushFont(ui.Font.Title)

	for i in ipairs(cockpitControls) do
		cockpitControls[i]:drawControl()
	end

	ui.popFont()
end

local resizeWindow = true
local function bestFit()
	windowMaxWidth = math.clamp(ui.windowWidth(), 0, ui.windowHeight() * ratio)
	windowMaxHeight = math.clamp(ui.windowHeight(), 0, ui.windowWidth() / ratio)

	if ui.windowResizing() then
		resizeWindow = true
	end

	if resizeWindow and not ui.windowResizing() then
		cui.getWindow("VRC Car Cockpit Controls"):resize(vec2Temp1:set(windowMaxWidth, windowMaxHeight))
		resizeWindow = false
	end

	currentScale = ui.windowHeight() / defaultHeight
	itemSpacing = 5 * currentScale
end

function script.carCockpitControls()
	if SIM.isReplayActive then
		return
	end

	bestFit()
	setPitMenuAccess(false)
	ui.pushStyleVar(ui.StyleVar.ItemSpacing, itemSpacing)
	drawAppBackground()
	triggerAciveItem()
	drawCarCockpitControls()
	ui.popStyleVar(1)
end
