Graph = class("Graph")

function Graph:initialize(pos, size, segments)
	self.xSize = size.x
	self.ySize = size.y
	self.segments = segments
	self.xRatio = size.x / segments
	self.yRatio = size.y / segments
	self.xStart = pos.x
	self.yStart = pos.y

	self.activePoints = {}
	for i = 1, 11 do
		self.activePoints[i] = false
	end
end

function Graph:drawGraph()
	for i = 0, self.segments do
		ui.drawSimpleLine(
			vec2(i * self.xRatio + self.xStart, self.yStart) * cui.scaleY(),
			vec2(i * self.xRatio + self.xStart, self.ySize + self.yStart) * cui.scaleY(),
			rgbm.colors.gray / 1.2,
			2
		)
		ui.drawSimpleLine(
			vec2(self.xStart, i * self.yRatio + self.yStart) * cui.scaleY(),
			vec2(self.xStart + self.xSize, i * self.yRatio + self.yStart) * cui.scaleY(),
			rgbm.colors.gray / 1.2,
			2
		)
	end
end

function Graph:drawLines(points, color)
	for i = 1, #points do
		if points[i] then
			ui.pathLineTo(
				vec2(
					i * self.xRatio - self.xRatio + self.xStart,
					self.ySize - points[i] * self.ySize / 100 + self.yStart
				) * cui.scaleY()
			)
		end
	end

	ui.pathStroke(color, false, 5 * cui.scaleY())
end

function Graph:drawLabels(xLabel, yLabel, xMin, xMax, yMin, yMax)
	ui.beginRotation()
	cui.setCursorY(self.yStart + self.ySize / 2 - 10)

	ui.dwriteTextAligned(
		yLabel,
		14 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(self.xSize * cui.scaleX(), 14 * cui.scaleY())
	)

	ui.endRotation(180, vec2(-self.xSize * 0.5 * cui.scaleY(), 0))

	cui.setCursorX(self.xStart)
	cui.setCursorY(self.yStart + self.ySize + 10)
	ui.dwriteTextAligned(
		xLabel,
		14 * cui.scaleY(),
		ui.Alignment.Center,
		ui.Alignment.Center,
		vec2(self.xSize * cui.scaleX(), 14 * cui.scaleY())
	)

	ui.pushFont(ui.Font.Main)

	for i = 0, self.segments do
		cui.setCursorX(self.xStart - 30)
		cui.setCursorY(self.yStart + i * self.yRatio - 7)

		ui.dwriteTextAligned(
			math.round(yMin + (yMax - yMin) / self.segments * (self.segments - i)),
			12 * cui.scaleY(),
			ui.Alignment.Center,
			ui.Alignment.Center,
			vec2(30 * cui.scaleX(), 14 * cui.scaleY())
		)
	end
	ui.popFont()
end
