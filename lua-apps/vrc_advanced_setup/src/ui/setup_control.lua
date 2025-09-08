local sim = ac.getSim()

function setSplitKEnd(strat, split, value)
	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["STRAT_" .. strat .. "_K_DEPLOYMENT_" .. split .. "_END"], value)
end

function setSplitHEnd(strat, split, value)
	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["STRAT_" .. strat .. "_H_DEPLOYMENT_" .. split .. "_END"], value)
end

function setSplitHKStart(strat, split, value)
	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["STRAT_" .. strat .. "_HK_DEPLOYMENT_" .. split .. "_START"], value)
end

function getSplitKEnd(strat, split)
	return ac.getSetupSpinnerValue(setupIDToSectionKeyMap["STRAT_" .. strat .. "_K_DEPLOYMENT_" .. split .. "_END"])
end

function getSplitHEnd(strat, split)
	return ac.getSetupSpinnerValue(setupIDToSectionKeyMap["STRAT_" .. strat .. "_H_DEPLOYMENT_" .. split .. "_END"])
end

function getSplitHKStart(strat, split)
	return ac.getSetupSpinnerValue(setupIDToSectionKeyMap["STRAT_" .. strat .. "_HK_DEPLOYMENT_" .. split .. "_START"])
end

function clearSplits(strat)
	for split = 1, 24 do
		setSplitHKStart(strat, split, 0)
		setSplitHEnd(strat, split, 0)
		setSplitKEnd(strat, split, 0)
	end
end

function convertSetup()
	local needsConversion = true
	local counter = 0

	for strat = 1, 8 do
		for split = 1, 24 do
			if getSplitHKStart(strat, split) > 0 and getSplitKEnd(strat, split) > 1000 then
				needsConversion = false
				return
			end

			if getSplitHKStart(strat, split) > 0 and getSplitKEnd(strat, split) < 1000 then
				counter = counter + 1
			end
		end
	end

	if needsConversion and counter > 3 then
		for strat = 1, 8 do
			for split = 1, 24 do
				setSplitHKStart(strat, split, getSplitHKStart(strat, split) / 1000 * sim.trackLengthM)
				setSplitHEnd(strat, split, getSplitHEnd(strat, split) / 1000 * sim.trackLengthM)
				setSplitKEnd(strat, split, getSplitKEnd(strat, split) / 1000 * sim.trackLengthM)
			end
		end
	end
end

local copiedSplits = {}

function copyStrat(copiedStrat)
	copiedSplits = {}

	for split = 1, 24 do
		copiedSplits[split] =
			{ getSplitHKStart(copiedStrat, split), getSplitHEnd(copiedStrat, split), getSplitKEnd(copiedStrat, split) }
	end
end

function pasteStrat(targetStrat)
	for split = 1, 24 do
		ac.setSetupSpinnerValue(
			setupIDToSectionKeyMap["STRAT_" .. targetStrat .. "_HK_DEPLOYMENT_" .. split .. "_START"],
			copiedSplits[split][1]
		)
		ac.setSetupSpinnerValue(
			setupIDToSectionKeyMap["STRAT_" .. targetStrat .. "_H_DEPLOYMENT_" .. split .. "_END"],
			copiedSplits[split][2]
		)
		ac.setSetupSpinnerValue(
			setupIDToSectionKeyMap["STRAT_" .. targetStrat .. "_K_DEPLOYMENT_" .. split .. "_END"],
			copiedSplits[split][3]
		)
	end
end

local copiedShape = {}

function copyBrakeShape(copiedBrakeShape)
	copiedShape = {}

	copiedShape[1] = ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MIG_" .. copiedBrakeShape])
	copiedShape[2] =
		ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. copiedBrakeShape .. "_RAMP_START_TORQUE"])
	copiedShape[3] =
		ac.getSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. copiedBrakeShape .. "_RAMP_END_TORQUE"])
end

function pasteBrakeShape(targetShape)
	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MIG_" .. targetShape], copiedShape[1])

	ac.setSetupSpinnerValue(
		setupIDToSectionKeyMap["BRAKE_SHAPE_" .. targetShape .. "_RAMP_START_TORQUE"],
		copiedShape[2]
	)

	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. targetShape .. "_RAMP_END_TORQUE"], copiedShape[3])
end

function resetShape(shape)
	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_MIG_" .. shape], 200 * shape)

	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. shape .. "_RAMP_START_TORQUE"], 1000)

	ac.setSetupSpinnerValue(setupIDToSectionKeyMap["BRAKE_SHAPE_" .. shape .. "_RAMP_END_TORQUE"], 5000)
end
