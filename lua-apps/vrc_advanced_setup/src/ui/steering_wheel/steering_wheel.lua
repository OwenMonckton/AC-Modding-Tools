local rpmLedColorMap = {}

for i = 1, 15 do
	if i < 6 then
		rpmLedColorMap[i] = rgbm.colors.black
	elseif i < 11 then
		rpmLedColorMap[i] = rgbm.colors.red
	else
		rpmLedColorMap[i] = rgbm.colors.blue
	end
end

local leftInnerLedColorMap = { rgbm.colors.black, rgbm.colors.blue, rgbm.colors.red }
local leftOuterLedColorMap = { rgbm.colors.red, rgbm.colors.red }

local xPos = 270
local yPos = 300
local gap = 40
local ledSize = 15
local outlineColor = rgbm(0.5, 0.5, 0.5, 1)

local function drawLed(pos, color)
	ui.drawCircleFilled(pos, ledSize + 3, outlineColor, 20)
	ui.drawCircleFilled(pos, ledSize, color, 20)
end

local function drawRpmLeds()
	for i in ipairs(rpmLedColorMap) do
		drawLed(vec2(xPos + (i * gap), yPos), rpmLedColorMap[i])
	end
end

local function leftLeds()
	for i in ipairs(leftInnerLedColorMap) do
		drawLed(vec2(xPos, yPos + (i * gap)), leftInnerLedColorMap[i])
	end

	for i in ipairs(leftOuterLedColorMap) do
		drawLed(vec2(xPos - gap, yPos + ((i - 1) * 90) + gap), leftOuterLedColorMap[i])
	end
end

local function rightLeds()
	for i in ipairs(leftInnerLedColorMap) do
		drawLed(vec2(xPos + (16 * gap), yPos + (i * gap)), leftInnerLedColorMap[i])
	end

	for i in ipairs(leftOuterLedColorMap) do
		drawLed(vec2(xPos + (16 * gap) + gap, yPos + ((i - 1) * 90) + gap), leftOuterLedColorMap[i])
	end
end

function runSteeringWheel()
	drawRpmLeds()
	leftLeds()
	rightLeds()
end
