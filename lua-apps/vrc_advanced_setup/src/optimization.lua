local SIM = ac.getSim()

MODEL_OPTIMIZATION = function()
	local carNodes = {}
	local wheelModelsOptimized = {}
	local aerokitModelsOptimized = {}

	for i, car in ac.iterateCars() do
		carNodes[car.index] = ac.findNodes("carRoot:" .. car.index)
		wheelModelsOptimized[car.index] = false
		aerokitModelsOptimized[car.index] = false
	end

	local steeringWheelNode = {
		[0] = "STW_RB",
		[1] = "STW_AL",
		[2] = "STW_AM",
		[3] = "STW_FE",
		[4] = "STW_MC",
		[5] = "STW_ME",
		[6] = "STW_WI",
	}

	local aeroKitNodes = {
		"BEAM_HI_LOWER",
		"BEAM_HI_UPPER",
		"BEAM_LOW_LOWER",
		"BEAM_LOW_UPPER",
		"DRS_HIMID",
		"DRS_LOW",
		"DRS_LOWMID",
		"HI",
		"HI_MID_LOWMID_SUPPORT",
		"LOWMID",
		"MID",
	}

	local aeroKitDefinitions = {
		[0] = { false, false, true, false, false, true, false, false, false, false, false },
		[1] = { false, false, true, true, false, false, true, false, true, true, false },
		[2] = { true, true, false, false, false, false, true, false, true, false, true },
		[3] = { false, false, true, true, true, false, false, true, true, false, false },
		[4] = { true, true, false, false, true, false, false, true, true, false, false },
	}

	local function optimizeCarModel(car)
		if ac.getCarID(car.index) ~= "vrc_formula_alpha_2024_csp" then
			return
		end

		local carNode = carNodes[car.index]

		if not carNode then
			carNodes[car.index] = ac.findNodes("carRoot:" .. car.index)
			wheelModelsOptimized[car.index] = false
			aerokitModelsOptimized[car.index] = false
			return
		end

		if SIM.isInMainMenu or SIM.isReplayActive then
			if wheelModelsOptimized[car.index] then
				for i = 0, 6 do
					carNode:findNodes(steeringWheelNode[i]):getChildren():setVisible(true)
				end
				wheelModelsOptimized[car.index] = false
			end

			if aerokitModelsOptimized[car.index] then
				for i in ipairs(aeroKitDefinitions[0]) do
					carNode:findNodes(aeroKitNodes[i]):getChildren():setVisible(true)
				end
				aerokitModelsOptimized[car.index] = false
			end

			return
		end

		if not wheelModelsOptimized[car.index] and ((car.index == 0 and ECU.isElectronicsBooted) or car.index ~= 0) then
			local wingAngle = ac.getSetupSpinnerValue("WING_12")

			if car.isRemote then
				wingAngle = 0
			end

			for i = 0, 6 do
				carNode:findNodes(steeringWheelNode[i]):getChildren():setVisible(i == wingAngle)
			end

			wheelModelsOptimized[car.index] = true
		end

		if not aerokitModelsOptimized[car.index] then
			local aeroKit = ac.getSetupSpinnerValue(setupIDToSectionKeyMap["AEROKIT"])

			if car.isRemote then
				aeroKit = 0
			end

			for i in ipairs(aeroKitDefinitions[aeroKit]) do
				local showNode = aeroKitDefinitions[aeroKit][i]
				carNode:findNodes(aeroKitNodes[i]):getChildren():setVisible(showNode)
			end
			aerokitModelsOptimized[car.index] = true
		end
	end

	return function()
		for i, car in ac.iterateCars() do
			optimizeCarModel(car)
		end
	end
end
