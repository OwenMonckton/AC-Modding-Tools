ERS_MAPS_AUTOGEN_INIT = false

local sim = ac.getSim()

local trackStratMapResolution = sim.trackLengthM

local straights = {}
local splits = {}

local function straightsTableSort(a, b)
	return a[1] < b[1]
end

local function straightTableMergeShortStraights()
	for i in ipairs(straights) do
		if i ~= 1 then
			local splitLength = (straights[i][2] - straights[i][1]) * sim.trackLengthM
			local distanceBetweenLastSplit = (straights[i][1] - straights[i - 1][2]) * sim.trackLengthM

			if splitLength < 100 and distanceBetweenLastSplit < 150 then
				straights[i][1] = straights[i - 1][1]
				straights[i - 1][1] = straights[i - 1][2]
			elseif splitLength < 100 then
				straights[i][2] = straights[i][1]
			end
		end
	end

	for i in ipairs(straights) do
		local splitLength = (straights[i][2] - straights[i][1]) * sim.trackLengthM
		if splitLength > 50 then
			table.insert(splits, straights[i])
		end
	end
end

local function setStratSetupItems(strat, split)
	local v = splits[split]
	setSplitHKStart(strat, split, v[1] * trackStratMapResolution)

	local derateIncrease = 0

	derateIncrease = v[2] == 1 and 0 or (v[2] - v[1]) * 0.075 * (strat + 1)

	setSplitKEnd(strat, split, math.clamp((v[2] - derateIncrease), v[1], v[2]) * trackStratMapResolution)

	if (v[2] - v[1]) * sim.trackLengthM > 200 and strat == 1 and v[1] ~= 0 then
		setSplitHEnd(strat, split, (v[1] + (v[2] - v[1]) / 6) * trackStratMapResolution)
	else
		setSplitHEnd(strat, split, v[1] * trackStratMapResolution)
	end
end

function setAutoGenStratSetupItems(strat)
	for targetSplit in ipairs(splits) do
		for targetStrat = 1, 8 do
			if strat then
				if targetStrat == strat then
					setStratSetupItems(targetStrat, targetSplit)
				end
			else
				setStratSetupItems(targetStrat, targetSplit)
			end
		end
	end
end

local function sanitizeStraights(line)
	local splitLine = string.split(line, ":")
	local startLine = tonumber(string.trim(splitLine[2], ", length"))
	local length = tonumber(splitLine[3])

	local endLine = startLine + length / sim.trackLengthM

	if endLine > 1 then
		table.insert(straights, { 0, length / sim.trackLengthM - (1 - startLine) })
		table.insert(straights, { startLine, 1 })
	else
		table.insert(
			straights,
			{ math.max(startLine - 5 / sim.trackLengthM, 0), startLine + length / sim.trackLengthM }
		)
	end
end

io.loadAsync(ac.getFolder(ac.FolderID.Logs) .. "\\log.txt", function(err, data)
	local foundPitLines = false

	for line in data:gmatch("[^\n]+") do
		if line:match("^Straight") then
			if line:match("Straight 0") then
				if not foundPitLines then
					foundPitLines = true
				else
					table.sort(straights, straightsTableSort)
					straightTableMergeShortStraights()

					setAutoGenStratSetupItems()

					return
				end
			end

			sanitizeStraights(line)
		end
	end
end)
