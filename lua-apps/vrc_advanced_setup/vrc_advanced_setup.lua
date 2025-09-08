if not string.startsWith(ac.getCarID(0), "vrc_formula_alpha_2024_csp") then
	ac.setWindowOpen("setupApp", false)
	ac.setWindowOpen("carCockpitControls", false)
	ac.unloadApp()
	return
end

require("src.connections")
require("src.optimization")
require("src.ui.ers_mapper.ers_mapper")
require("src.ui.brake_shaper.brake_shaper")
require("src.ui.steering_wheel.steering_wheel")
require("src.ui.car_cockpit_controls.car_cockpit_controls")
require("src.ui.driver_settings.driver_settings")
require("src.ui.setup_control")
require("src.ui.tab_bar")
require("src.ui.plank_wear.plank_wear")
require("src.ui.manual.manual")
require("src.ui.app_info.app_info")
require("src.utils")

cui = require("src.cui")

local SIM = ac.getSim()
local CPHYS = ac.getCarPhysics(0)

local extConfigINI = ac.INIConfig.load(
	string.format("%s\\%s\\extension\\ext_config.ini", ac.getFolder(ac.FolderID.ContentCars), ac.getCarID(0))
)

local extConfigSkinINI = ac.INIConfig.load(
	string.format(
		"%s\\%s\\skins\\%s\\ext_config.ini",
		ac.getFolder(ac.FolderID.ContentCars),
		ac.getCarID(0),
		ac.getCarSkinID(0)
	)
)

local defaultWheelIndex = extConfigINI:get("STEERING_WHEEL", "INDEX", -1)
local defaultWheelSkinIndex = extConfigSkinINI:get("STEERING_WHEEL", "INDEX", -1)
local ignoreWheelSkinIndex = extConfigINI:get("STEERING_WHEEL", "OVERRIDE_SKIN", -1) == 1

if defaultWheelSkinIndex ~= -1 and not ignoreWheelSkinIndex then
	defaultWheelIndex = defaultWheelSkinIndex
end

defaultWheelIndex = math.clamp(defaultWheelIndex, 0, 6)

local setupINI = ac.INIConfig.carData(0, "setup.ini")
setupIDToSectionKeyMap = {}
for k, v in pairs(setupINI.sections) do
	if string.startsWith(k, "CUSTOM_SCRIPT_ITEM_") and v["ID"] then
		setupIDToSectionKeyMap[v["ID"][1]] = k
	end
end
setupINI:iterate("CUSTOM_SCRIPT_ITEM")

ac.setWindowOpen("setupApp", true)

local setupTabOpened = false
local defaultWheelSet = false

local appList = {
	{ "DEPLOYMENT STRATS", runErsMapper },
	{ "BRAKE SHAPES", brakeShapeGraphWindow },
	{ "PLANK WEAR", runPlankWear },
	{ "SETTINGS", runDriverSettings },
	{ "MANUAL", runManual },
	{ "INFO", runAppInfo },
}

function script.setupApp()
	if not setupTabOpened then
		setupTabOpened = true
	end

	cui.bestFit()

	cui.setScaleX(cui.windowMaxWidth() / 1020)
	cui.setScaleY(cui.windowMaxHeight() / 510)

	ui.beginGroup(1020)

	ui.pushStyleVar(ui.StyleVar.ItemSpacing, 5 * cui.scaleY())
	ui.pushStyleColor(ui.StyleColor.ChildBg, rgbm(0.1, 0.1, 0.1, 0.5))

	local currentApp = tabBar(appList)
	appList[currentApp][2]()

	ui.popStyleVar(1)
	ui.popStyleColor(1)

	ui.endGroup()
end

local modelOptimizations = MODEL_OPTIMIZATION()

function script.update(dt)
	if SIM.isInMainMenu then
		if not setupTabOpened then
			ac.tryToOpenRaceMenu("setup")
		end

		if not defaultWheelSet and CPHYS.wings[12].angle ~= defaultWheelIndex then
			ac.setSetupSpinnerValue("WING_12", defaultWheelIndex)
		elseif not defaultWheelSet then
			defaultWheelSet = true
		end
	end

	modelOptimizations()
end
