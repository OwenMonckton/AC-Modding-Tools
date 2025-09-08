local appManifestINI = ac.INIConfig.load("manifest.ini")
local appECManifestINI =
	ac.INIConfig.load(string.format("%s\\lua\\ext_controls\\manifest.ini", ac.getFolder(ac.FolderID.ACApps)))

local cspVersion = ac.getPatchVersion()
local vrcasVersion = appManifestINI:get("ABOUT", "VERSION ", "0.0"):gsub(" ", "")
local ecVersion = appECManifestINI:get("ABOUT", "VERSION ", "0.0"):gsub(" ", "")

local vrcLogoImage = ac.dirname() .. "\\assets\\vrc_white_mono.png"
local vrcLogoImageSize = ui.imageSize(vrcLogoImage) / 4

function runAppInfo()
	cui.pushTabWindow("appInfo", 0, 50, 505, 440, true)

	ui.dwriteTextAligned(
		"VRC Advanced Setup",
		24 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(490, 26) * cui.scaleY()
	)

	ui.dwriteTextAligned(" ", 18 * cui.scaleY(), ui.Alignment.Center, ui.Alignment.Center, vec2(500, 26) * cui.scaleY())
	ui.dwriteTextAligned(
		string.format("CSP: v%s", cspVersion),
		18 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(490, 26) * cui.scaleY()
	)

	ui.dwriteTextAligned(
		string.format("VRC Advanced Setup: v%s", vrcasVersion),
		18 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(490, 26) * cui.scaleY()
	)

	ui.dwriteTextAligned(
		string.format("Extended Controls: v%s", ecVersion),
		18 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(490, 26) * cui.scaleY()
	)

	cui.dummy(32, 45)

	ui.setCursorX((ui.windowWidth() / 2) - (vrcLogoImageSize.x * cui.scaleY()) / 2)
	ui.image(vrcLogoImage, vrcLogoImageSize * cui.scaleY())

	cui.popTabWindow()
end
