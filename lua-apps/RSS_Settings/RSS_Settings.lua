--RSS Extended Controls App
--File generated on  2024/01/20   16:04:33 JST
--Copyright & Proprietary Race Sim Studio

if ac.INIConfig.load(ac.getFolder(ac.FolderID.ContentCars) .. "/" .. ac.getCarID(0) .. "/extension/display/Extended_config.ini"):get("ABOUT", "VERSION", -1) == -1 or ac.getCar(0).extendedPhysics == false then
	ac.setWindowOpen("main", false)
	return nil
end

ac.debug("0.RSS Settings", "app")

local SIM = ac.getSim()
local CAR = ac.getCar(0)
local Page = 0
local IGMode = 0
local MAXPage = 3
local RaceLogicPage = 0
local RaceLogicStyle = 0
local MFD_Brightness = 50
local LED_Brightness = 50
local RaceLogicMaxPage = 0
local windowWidth = 316

local ECUFlag = {}
local DIS = false
local Open = false
local Speedunit = 0
local AutoClutch = 0
local CARINITIALIZED = false
local APPINITIALIZED = false
local ECUINITIALIZED = false
local LOGICINITIALIZED = false
local Hede_System_Message = false

local Version = ac.INIConfig.load("manifest.ini"):get("ABOUT", "VERSION ", 0)
local app_config = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "/lua/RSS_Settings/settings/" .. "settings.ini")
local car_config = ac.INIConfig.load(ac.getFolder(ac.FolderID.ACApps) .. "/lua/RSS_Settings/settings/" .. "car_settings.ini")
local ac_config = ac.INIConfig.load(ac.getFolder(ac.FolderID.Documents) .. "/Assetto Corsa/cfg/" .. "gameplay.ini")
local appShelf
local appShelfUtilsAvailable = ac.getPatchVersionCode() >= 3007

if appShelfUtilsAvailable then
	appShelf = require("shared/utils/appshelf")
end

ac.uninstallApp("RSS_Extended_Controls")

local function offerApp()
	appShelf.offer({ id = "ext_controls", reason = "Bind car controls" }, function(err)
		if not io.dirExists(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\ext_controls") then
			ac.log("Failed to install Extended Controls")
		else
			ac.setAppOpen("ext_controls")
		end
	end)
end

local extendedControlsPrefix = "__EXT_CAR_"
local MFDPageUp = ac.ControlButton(extendedControlsPrefix .. "MFD_PAGE_UP",0x69)
local MFDPageDown = ac.ControlButton(extendedControlsPrefix .. "MFD_PAGE_DN",0x67)
local MFDBrightnessUp = ac.ControlButton(extendedControlsPrefix .. "MFD_BRIGHTNESS_UP",0x66)
local MFDBrightnessDown = ac.ControlButton(extendedControlsPrefix .. "MFD_BRIGHTNESS_DN",0x64)

local RaceLogicPageUp = ac.ControlButton(extendedControlsPrefix .. "RACELOGIC_PAGE_UP")
local RaceLogicPageDown = ac.ControlButton(extendedControlsPrefix .. "RACELOGIC_PAGE_DN")
local RaceLogicBrightnessUp = ac.ControlButton(extendedControlsPrefix .. "RACELOGIC_BRIGHTNESS_UP")
local RaceLogicBrightnessDown = ac.ControlButton(extendedControlsPrefix .. "RACELOGIC_BRIGHTNESS_DN")
local RaceLogicStyleUp = ac.ControlButton(extendedControlsPrefix .. "RACELOGIC_STYLE_UP")
local RaceLogicStyleDown = ac.ControlButton(extendedControlsPrefix .. "RACELOGIC_STYLE_DN")

local LEDBrightnessUp = ac.ControlButton(extendedControlsPrefix .. "LED_BRIGHTNESS_UP",0x63)
local LEDBrightnessDown = ac.ControlButton(extendedControlsPrefix .. "LED_BRIGHTNESS_DN",0x61)

local APPSwitching = ac.ControlButton(extendedControlsPrefix .. "RSS_SETTINGS_SWITCH",0x65)

local Ignitionkey = ac.ControlButton(extendedControlsPrefix .. "IGNITION",0x49)
local StarterKey = ac.ControlButton(extendedControlsPrefix .. "STARTER",0x53)

local control = {}
control[0] = Ignitionkey
control[1] = StarterKey

local Text = {}
Text[0] = "Ignition:"
Text[1] = "Engine Start:"

local Extended_config = ac.INIConfig.load(ac.getFolder(ac.FolderID.ContentCars).. "/".. ac.getCarID(0).. "/extension/display/".. "Extended_config.ini")

local function carinitialize()
	Page = car_config:get(ac.getCarID(0), "MFD_Page", 0)
	MFD_Brightness = car_config:get(ac.getCarID(0), "MFD_Brightness", 50)
	LED_Brightness = car_config:get(ac.getCarID(0), "LED_Brightness", 50)
	RaceLogicBrightness = car_config:get(ac.getCarID(0), "RaceLogic_Brightness", 50)
	MAXPage = Extended_config:get("MFD", "MFD_Max_Page", 0)
	RaceLogicMaxPage = Extended_config:get("RACELOGIC", "RaceLogic_Max_Page", -1)
	RaceLogicStyleCount = Extended_config:get("RACELOGIC", "RaceLogic_Style_Count", 0)
	ECUVersion = Extended_config:get("ECU", "VERSION", 0)
	CARINITIALIZED = true
end

local function appinitialize()
	Speedunit =  ac_config:get("OPTIONS","USE_MPH",0) == 0 and -1 or 1
	if app_config:get("MAIN", "Hede_System_Message", -1) == 1 then
		Hede_System_Message = true
	else
		Hede_System_Message = false
	end
	APPINITIALIZED = true
end

local function logicinitialize()
	RaceLogicPage = car_config:get(ac.getCarID(0), "RaceLogic_Page", 0)
	RaceLogicBrightness = car_config:get(ac.getCarID(0), "RaceLogic_Brightness", 50)
	LOGICINITIALIZED = true
end

local function ecuinitialize()
	if app_config:get("MAIN", "Disable_ignition_sequence", 1) == 1 then
		DIS = true
	else
		DIS = false
	end
	ECUINITIALIZED = true
end

local function mfd()
	windowWidth = 316
	if MAXPage > 0 then
		ui.textAligned("MFD Page", vec2(0, 0.7), vec2(250, 20))
		ui.setNextItemWidth(windowWidth - 40)
		Volume, changed = ui.slider("##Page", Page, 0, MAXPage, "%.0f")
		if changed then
			Page = Volume
		end
	end

	ui.textAligned("MFD Brightness", vec2(0, 0.7), vec2(250, 20))
	ui.setNextItemWidth(windowWidth - 40)
	Volume, changed = ui.slider("##MFD_Brightness", MFD_Brightness, 20, 100, "%.0f")
	if changed then
		MFD_Brightness = Volume
	end

	ui.textAligned("LED Brightness", vec2(0, 0.7), vec2(250, 20))
	ui.setNextItemWidth(windowWidth - 40)
	Volume, changed = ui.slider("##LED_Brightness", LED_Brightness, 20, 100, "%.0f")
	if changed then
		LED_Brightness = Volume
	end

	if ui.button("SAVE") then
		car_config:set(ac.getCarID(0), "MFD_Page", Page)
		car_config:set(ac.getCarID(0), "MFD_Brightness", MFD_Brightness)
		car_config:set(ac.getCarID(0), "LED_Brightness", LED_Brightness)
		car_config:save(ac.getFolder(ac.FolderID.ACApps) .. "/lua/RSS_Settings/settings/" .. "car_settings.ini")
	end

	ui.sameLine()

	if ui.button("RESET") then
		CARINITIALIZED = false
	end
end

function racelogic()
	windowWidth = 316
	ui.textAligned("Page", vec2(0, 0.7), vec2(250, 20))
	ui.setNextItemWidth(windowWidth - 40)
	Volume, changed = ui.slider("##RaceLogicPage", RaceLogicPage, 0, RaceLogicMaxPage, "%.0f")
	if changed then
		RaceLogicPage = Volume
	end

	ui.textAligned("Brightness", vec2(0, 0.7), vec2(250, 20))
	ui.setNextItemWidth(windowWidth - 40)
	Volume, changed = ui.slider("##RaceLogicBrightness", RaceLogicBrightness, 20, 100, "%.0f")
	if changed then
		RaceLogicBrightness = Volume
	end

	ui.textAligned("Style", vec2(0, 0.7), vec2(250, 20))
	ui.setNextItemWidth(windowWidth - 40)
	Volume, changed = ui.slider("##RaceLogicStyle", RaceLogicStyle, 0, RaceLogicStyleCount, "%.0f")
	if changed then
		RaceLogicStyle = Volume
	end

	if ui.button("SAVE") then
		car_config:set(ac.getCarID(0), "RaceLogic_Page", RaceLogicPage)
		car_config:set(ac.getCarID(0), "RaceLogic_Brightness", RaceLogicBrightness)
		car_config:set(ac.getCarID(0), "RaceLogic_Style", RaceLogicStyle)
		car_config:save(ac.getFolder(ac.FolderID.ACApps) .. "/lua/RSS_Settings/settings/" .. "car_settings.ini")
	end

	ui.sameLine()

	if ui.button("RESET") then
		LOGICINITIALIZED = false
	end
end

local function ecu()
	windowWidth = 316
    if DIS == false then
        if IGMode > 0 then
            ECUFlag[0] = ui.ButtonFlags.Active
        else
            ECUFlag[0] = ui.ButtonFlags.None
        end
        if IGMode > 1 then
            ECUFlag[1] = ui.ButtonFlags.Active
        else
            ECUFlag[1] = ui.ButtonFlags.None
        end
        for i = 0,1 do
            ui.textAligned(Text[i], vec2(1,0.2), vec2(80,20))
            ui.sameLine()
            control[i]:control(vec2(158,20),ui.ControlButtonControlFlags.AlterRealConfig)
            ui.sameLine()
            if ui.button("##"..i,vec2(22,20),ECUFlag[i]) then
                if i == 0 then
                    ac.simulateCustomHotkeyPress(extendedControlsPrefix .. "IGNITION", 1)
                elseif i == 1 then
                    ac.simulateCustomHotkeyPress(extendedControlsPrefix .. "STARTER", 1)
                end
            end
            ui.addIcon(ui.Icons.Record, 7,0.5, nil, 0)
        end
    end

	if ui.checkbox("Disable ignition sequence", DIS) then
		DIS = not DIS
	end
	if ui.button("SAVE") then
		app_config:set("MAIN", "Disable_ignition_sequence", DIS)
		app_config:save(ac.getFolder(ac.FolderID.ACApps) .. "/lua/RSS_Settings/settings/" .. "settings.ini")
	end
end

local function settings()
	windowWidth = 316
	local extControlsInstalled = io.dirExists(ac.getFolder(ac.FolderID.ACApps) .. "\\lua\\ext_controls")

	if ui.button(extControlsInstalled and "Open Extended Controls" or "Install Extended Controls",vec2(276, 24),ui.ButtonFlags.None) then
		if extControlsInstalled then
			ac.setAppOpen("ext_controls")
		else
			ac.setAppOpen("AppShelf")

			if appShelfUtilsAvailable then
				offerApp()
			end
		end
	end

	ui.textAligned("Speed unit", vec2(0, 0.8), vec2(250, 20))

	if ui.radioButton("km/h", Speedunit == -1) then
		Speedunit = -1
	end

	ui.sameLine()

	if ui.radioButton("mph", Speedunit == 1) then
		Speedunit = 1
	end

	ui.textAligned("Hide RSS App Notifications", vec2(0, 0.8), vec2(250, 30))
	if ui.checkbox("Hide", Hede_System_Message) then
		Hede_System_Message = not Hede_System_Message
	end

	if ui.button("SAVE") then
		app_config:set("MAIN", "Hede_System_Message", Hede_System_Message)
		app_config:save(ac.getFolder(ac.FolderID.ACApps) .. "/lua/RSS_Settings/settings/" .. "settings.ini")
	end
end

function information(dt)
	windowWidth = 316
	ui.text("CAR : " .. ac.getCarID(0))
	ui.text("CSP : " .. ac.getPatchVersion() .. " (" .. ac.getPatchVersionCode() .. ")")
	ui.text("APP : Version " .. Version)
	ui.text("MFD : Version ".. ac.INIConfig.load(ac.getFolder(ac.FolderID.ContentCars).. "/".. ac.getCarID(0).. "/extension/display/Extended_config.ini"):get("ABOUT", "VERSION", 0))
	ui.text("ECU : Version ".. ECUVersion)
	ui.text("app setting")
	ui.setNextItemWidth(250)
	ui.copyable(app_config)
	ui.setNextItemWidth(250)
	ui.text("car setting")
	ui.copyable(car_config)
end

function script.windowmain(dt)
	ui.drawImage("icon.png", vec2(windowWidth - 60, 0), vec2(windowWidth - 20, 40))

	ui.textAligned("RSS Settings", vec2(0.5, 0), vec2(windowWidth - 40, 20))
	ui.tabBar("main", function()
		ui.tabItem("MFD", mfd)
		if RaceLogicMaxPage > -1 then
			ui.tabItem("RaceLogic", racelogic)
		end
		ui.tabItem("ECU", ecu)
		ui.tabItem("Settings", settings)
		ui.tabItem("info", information)
	end)
end

local MFDKey = ac.getCarID(CAR.index) .. "_mfd"
local MFDsharedData = {
	ac.StructItem.key(MFDKey .. "_" .. CAR.index),
	SpeedUnit = ac.StructItem.int32(),
	MFDPage =  ac.StructItem.int32(),
	MFDBrt =  ac.StructItem.int32(),
	LEDBrt =  ac.StructItem.int32()
}
MFD = ac.connect(MFDsharedData, false, ac.SharedNamespace.Shared)

local ECUKey = ac.getCarID(CAR.index) .. "_ecu"
local ECUsharedData = {
	ac.StructItem.key(ECUKey .. "_" .. CAR.index),
	HedeSystemMessage = ac.StructItem.int32(),
	AutoClutch = ac.StructItem.int32(),
	DisableIgnitionSequence = ac.StructItem.int32()
}
ECU = ac.connect(ECUsharedData, false, ac.SharedNamespace.Shared)

IGKey = ac.getCarID(CAR.index) .. "_Ignition"
local IGsharedData = {
	ac.StructItem.key(IGKey .. "_" .. CAR.index),
	Mode = ac.StructItem.int32()
}
Ignition = ac.connect(IGsharedData, false, ac.SharedNamespace.Shared)

local RaceLogicKey = ac.getCarID(CAR.index) .. "_RaceLogic"
local RaceLogicsharedData = {
	ac.StructItem.key(RaceLogicKey .. "_" .. CAR.index),
	Brt = ac.StructItem.int32(),
	Page = ac.StructItem.int32(),
	Style =ac.StructItem.int32()
}
RaceLogic = ac.connect(RaceLogicsharedData, false, ac.SharedNamespace.Shared)

function connect()
	MFD.SpeedUnit = Speedunit
	MFD.MFDPage = Page
	MFD.MFDBrt = MFD_Brightness
	MFD.LEDBrt = LED_Brightness

	RaceLogic.Page = RaceLogicPage
	RaceLogic.Brt = RaceLogicBrightness
	RaceLogic.Style = RaceLogicStyle

	ECU.HedeSystemMessage = Hede_System_Message
	ECU.AutoClutch = AutoClutch
	ECU.DisableIgnitionSequence = DIS

	IGMode = Ignition.Mode

end

function update(dt)
	if not CARINITIALIZED then carinitialize() end
	if not APPINITIALIZED then appinitialize() end
	if not ECUINITIALIZED then ecuinitialize() end
	if not LOGICINITIALIZED then logicinitialize() end

	connect()
	Open = ac.isWindowOpen("main")
	if MFDPageUp:pressed() then
		Page = Page + 1
		if Page > MAXPage then
			Page = 0
		end
	end

	if MFDPageDown:pressed() then
		Page = Page - 1
		if Page < 0 then
			Page = MAXPage
		end
	end

	if MFDBrightnessUp:pressed() then
		MFD_Brightness = math.min((MFD_Brightness + 10), 100)
	end

	if MFDBrightnessDown:pressed() then
		MFD_Brightness = math.max((MFD_Brightness - 10), 20)
	end

	if RaceLogicPageUp:pressed() then
		RaceLogicPage = RaceLogicPage + 1
		if RaceLogicPage > RaceLogicMaxPage then
			RaceLogicPage = 0
		end
	end

	if RaceLogicPageDown:pressed() then
		RaceLogicPage = RaceLogicPage - 1
		if RaceLogicPage < 0 then
			RaceLogicPage = RaceLogicMaxPage
		end
	end

	if RaceLogicBrightnessUp:pressed() then
		RaceLogicBrightness = math.min((RaceLogicBrightness + 10), 100)
	end

	if RaceLogicBrightnessDown:pressed() then
		RaceLogicBrightness = math.max((RaceLogicBrightness - 10), 20)
	end

	if RaceLogicStyleUp:pressed() then
		RaceLogicStyle = RaceLogicStyle + 1
		if RaceLogicStyle > RaceLogicStyleCount then
			RaceLogicStyle = 0
		end
	end

	if RaceLogicStyleDown:pressed() then
		RaceLogicStyle = RaceLogicStyle - 1
		if RaceLogicStyle < 0 then
			RaceLogicStyle = RaceLogicStyleCount
		end
	end

	if LEDBrightnessUp:pressed() then
		LED_Brightness = math.min((LED_Brightness + 10), 100)
	end

	if LEDBrightnessDown:pressed() then
		LED_Brightness = math.max((LED_Brightness - 10), 20)
	end

	if APPSwitching:pressed() then
		Open = not Open
		ac.setWindowOpen("main", Open)
	end

    ac.store("RSS_ECU_Ctrl_Engine_Starter",true)
    ac.store("RSS_ECU_Ctrl_Ignition",true)
end
