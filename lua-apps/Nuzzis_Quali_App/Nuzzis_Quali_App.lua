-- Author Nuzzi

-- USER VARS START
local matchPlayerFuelWithAi    = false  -- Set this to true if you want to start quali with same fuel level as AI (+3 Litres)
local aiTakePlayerFuel         = false  -- Set this to true if you want the AI to start quali with the same fuel level as you.
local enableAiOutlapPullToLeft = false  -- Set to true to enable AI pulling to left of racing line on outlaps. (Some tracks may cause AI to crash)
-- USER VARS END

-- Global Vars
local initalisationComplete = false
local trackLengthKM = math.round(ac.getSim().trackLengthM / 1000, 1)
local isLongTrack = nil
if trackLengthKM > 6.0 then
  isLongTrack = true
else
  isLongTrack = false
end
local aiState = {}
local aiPitRequested = {}

-- Testing Vars
local testCarId = 1

ac.onSessionStart(function(sessionIndex) -- Runs once on session restart (doesn't work on session start, only restart)
    ac.log("-----------------")
    ac.log("Session Restarted")
    ac.log("-----------------")
end)

-- Runs once per frame
---@diagnostic disable-next-line: duplicate-set-field
function script.update(dt)
  if CheckSessionValidity() == true then
    -- Run once on session start
    if initalisationComplete == false then
      ContructAiInfoArrays()
      initalisationComplete = true
      ac.log("Initial Setup Complete")
    end

    -- Runs once each frame
    MatchPlayerAiStartFuel()
    InvalidateOutLaps()
    ManageAiStates()
    ManageAiBehaviour()
    RestoreTyres()
  end
end

-- Runs once per frame on the Main window
---@diagnostic disable-next-line: duplicate-set-field
function script.windowMain(dt)
  if CheckSessionValidity() == true then
    -- Show Session info
    ui.text("Session Info:")
    ui.text("Session Type: " .. ac.getSessionName(ac.getSim().currentSessionIndex))
    ui.text("Track Length: " .. trackLengthKM .. "km")
    --ui.text("Is long track:" .. tostring(isLongTrack))

    -- Next / Last Driver Buttons
    if ui.button("Next Driver") and testCarId < (ac.getSim().carsCount - 1) then
      testCarId = testCarId + 1
    end
    if ui.button("Prev Driver") and (testCarId > 0) then
      testCarId = testCarId - 1
    end

    -- Show AI Car status
    ui.newLine(5)
    ui.text(ac.getDriverName(testCarId) .. " info:")
    ui.text("Lap: " .. ac.getCar(testCarId).lapCount)
    ui.text("Fuel: " .. math.round(ac.getCar(testCarId).fuel, 1) .. "L")
    ui.text("Front Left Tyre virtKm: " .. math.round(ac.getCar(testCarId).wheels[ac.Wheel.FrontLeft].tyreVirtualKM, 2))
    --ui.text("Front Right virtKm: " .. math.round(ac.getCar(testCarId).wheels[ac.Wheel.FrontRight].tyreVirtualKM, 2))
    --ui.text("Rear Left virtKm: " .. math.round(ac.getCar(testCarId).wheels[ac.Wheel.RearLeft].tyreVirtualKM, 2))
    --ui.text("Rear Right virtKm: " .. math.round(ac.getCar(testCarId).wheels[ac.Wheel.RearRight].tyreVirtualKM, 2))
    -- MGUK / Battery
    if ac.getCar(testCarId).hasCockpitERSDelivery == true then
      --ui.text("MGUK current delivery mode: " .. ac.getCar(testCarId).mgukDelivery)
      ui.text("MGUK active delivery mode: " .. ac.getMGUKDeliveryName(testCarId))
      ui.text("Battery: " .. math.round(ac.getCar(testCarId).kersCharge * 100) .. "%")
      --ui.text("Max KJ per lap allowance: " .. ac.getCar(testCarId).kersMaxKJ)
      --ui.text("Used KJ this lap: " .. ac.getCar(testCarId).kersCurrentKJ)
      ui.text("Battery lap allowance used: " .. math.round(((ac.getCar(testCarId).kersCurrentKJ / ac.getCar(testCarId).kersMaxKJ) * 100), 0) .. "%")
    else
      ui.text("This car doesn't have MGUK modes.")
    end
    -- Location
    if ac.getCar(testCarId).isInPitlane then
      ui.text("Location: In Pitlane")
    elseif ac.getCar(testCarId).isInPit then
      ui.text("Location: In Pit")
    else
      ui.text("Location: On track")
      ui.text("Location: On track - Lap Progress: " .. math.round((ac.getCar(testCarId).splinePosition * 100), 0) .. "%")
    end

    -- Disable Track Physics Button
    ui.newLine(5)
    if ui.button("Reset track physics for playing online") then
      DisablePhysics()
      ui.toast(ui.Icons.Code, "Track Physics Disabled, restart from C.M to apply.")
    end
  else
    -- Enable Track Physics Button
    if physics.allowed() == false then
      if ui.button("Enable Track Physics") then
        EnablePhysics()
        ui.toast(ui.Icons.Code, "Track Physics Enabled, restart from C.M to apply.")
      end
    else
      ui.text("Not in quali session, so app will be inactive")
    end
  end
end

-- FUNCTIONS
function ContructAiInfoArrays()
  for i = 1, ac.getSim().carsCount -1, 1
  do
    if aiState[i] == nil then
      aiState[i] = "outlap"
    end
    if aiPitRequested[i] == nil then
      aiPitRequested[i] = false
    end
  end

  ac.log("AI Info Arrays Constructed")
end

function ManageAiStates()
  local outLaps =  { 0,3,6,9 ,12,15,18,21,24,27,30 }
  local fastLaps = { 1,4,7,10,13,16,19,22,25,28,31 }
  local inLaps =   { 2,5,8,11,14,17,20,23,26,29,32 }

 -- loop ai
 for i = 1, ac.getSim().carsCount -1, 1
 do
    -- Check current lap number
    local currentLap = ac.getCar(i).lapCount

    -- Are we on an out-lap?
    if DoesArrayContain(outLaps, currentLap) and aiState[i] ~= "outLap" then
      aiState[i] = "outLap"
      ac.log(ac.getDriverName(i) .. ": set to outLap")
    end

    -- Are we on a fast-lap?
    if DoesArrayContain(fastLaps, currentLap) and aiState[i] ~= "fastLap" then
      aiState[i] = "fastLap"
      ac.log(ac.getDriverName(i) .. ": set to fastLap")
    end

    -- Are we on a in-lap?
    if DoesArrayContain(inLaps, currentLap) and aiState[i] ~= "inLap" then
      aiState[i] = "inLap"
      ac.log(ac.getDriverName(i) .. ": set to inLap")
    end
  end
end

function ManageAiBehaviour()
  -- Read States and apply appropriate behaviour

  -- loop ai
  for i = 1, ac.getSim().carsCount -1, 1
  do
    -- Out-Lap
    if aiState[i] == "outLap" and ac.getCar(i).splinePosition > 0.1 and ac.getCar(i).splinePosition < 0.9 then
      physics.setAIThrottleLimit(i, 0.6)

      if enableAiOutlapPullToLeft == true then
        physics.setAISplineOffset(i, -0.5, false)
      end

      -- Set Battery deployment to min
      if ac.getCar(i).hasCockpitERSDelivery == true then
        SetCarMinDeployment(i)
      end
    end

    -- End of Out-Lap
    if aiState[i] == "outLap" and ac.getCar(i).splinePosition >= 0.9 then -- On out-lap but either beginning or end of lap
      physics.setAIThrottleLimit(i, 1)

      if enableAiOutlapPullToLeft == true then
        physics.setAISplineOffset(i, 0, false)
      end

      -- Set Battery deployment to max
      if ac.getCar(i).hasCockpitERSDelivery == true then
        SetCarMaxDeployment(i)
      end
    end

    -- Fast-Lap
    if aiState[i] == "fastLap" then
      physics.setAIThrottleLimit(i, 1)

      if enableAiOutlapPullToLeft == true then
        physics.setAISplineOffset(i, 0, false)
      end

      -- Set Battery deployment for fast lap
      if ac.getCar(i).hasCockpitERSDelivery == true then

        local ersLapAllowanceUsedPercent = ((ac.getCar(i).kersCurrentKJ / ac.getCar(i).kersMaxKJ) * 100)
        if ersLapAllowanceUsedPercent > 90 then
          SetCarLowDeployment(i)
        elseif ersLapAllowanceUsedPercent > 70 then
          SetCarMediumDeployment(i)
        else
          if isLongTrack == true then
            SetCarHighDeployment(i)
          else
            SetCarMaxDeployment(i)
          end
        end

      end
    end

    -- In-Lap
    if aiState[i] == "inLap" and ac.getCar(i).splinePosition > 0.1 then
      physics.setAIThrottleLimit(i, 0.6)

      -- Request pit once
      if aiPitRequested[i] == false and ac.getCar(i).isInPitlane == false then
        physics.setAIPitStopRequest(i, true)
        aiPitRequested[i] = true
        ac.log(ac.getDriverName(i) .. ": requested pit stop")
      end

      if enableAiOutlapPullToLeft == true then
        physics.setAISplineOffset(i, -0.5, false)
      end

      -- Set Battery deployment to min
      if ac.getCar(i).hasCockpitERSDelivery == true then
        SetCarMinDeployment(i)
      end
    end

    -- Misc when stopped in pit box reset pit requested to false
    if ac.getCar(i).isInPitlane and aiPitRequested[i] == true then
      aiPitRequested[i] = false
      ac.log(ac.getDriverName(i) .. ": returned to pits")
    end

  end
end

function MatchPlayerAiStartFuel()
  -- Player take AI fuel at session start
  if matchPlayerFuelWithAi == true and ac.getCar(0).fuel ~= ac.getCar(1).fuel and ac.getCar(0).isInPit and ac.getCar(0).lapCount < 1 and ac.getCar(1).isInPit == true then
    physics.setCarFuel(0, ac.getCar(1).fuel +3)
    ac.log("Set player fuel: " .. math.round(ac.getCar(1).fuel, 1))
  end

  -- AI take Player fuel at session start
  if aiTakePlayerFuel == true and ac.getCar(0).isInPit and ac.getCar(0).lapCount < 1 then
    for i = 1, ac.getSim().carsCount -1, 1
    do
      if ac.getCar(0).fuel ~= ac.getCar(i).fuel and ac.getCar(i).lapCount < 1 then
        physics.setCarFuel(i, ac.getCar(0).fuel)
        ac.log("Set " .. ac.getDriverName(i) .. " fuel: " .. math.round(ac.getCar(0).fuel, 1))
      end
    end
  end
end

function InvalidateOutLaps()
  -- loop player and ai
  for i = 0, ac.getSim().carsCount -1, 1
  do
    if ac.getCar(i).lapCount == 0 and ac.getCar(i).isInPitlane == true and ac.getCar(i).isLapValid == true then
      physics.markLapAsSpoiled(i)
      ac.log(ac.getDriverName(i) .. ": lap invalidated")
    end
  end
end

function SetCarMaxDeployment(carIndex)
  -- Handle VRC Formula Alpha cars (the highest mode is wet for these cars)
  if ac.getMGUKDeliveryName(carIndex, (ac.getCar(carIndex).mgukDeliveryCount - 1)) == "Wet" then
    -- Only do if not currently in mode
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 2) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 2))
      ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
    end
  else
    -- Handle all normal cars
    -- Only do if not currently in mode
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 1) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 1))
      ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
    end
  end
end

function SetCarHighDeployment(carIndex)
  -- Handle VRC Formula Alpha cars (the highest mode is wet for these cars)
  if ac.getMGUKDeliveryName(carIndex, (ac.getCar(carIndex).mgukDeliveryCount - 1)) == "Wet" then
    -- Only do if not currently in mode
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 3) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 3))
      ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
    end
  else
    -- Handle all normal cars
    -- Only do if not currently in mode
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 2) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 2))
      ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
    end
  end
end

function SetCarMediumDeployment(carIndex)
  -- Handle VRC Formula Alpha cars (the highest mode is wet for these cars)
  if ac.getMGUKDeliveryName(carIndex, (ac.getCar(carIndex).mgukDeliveryCount - 1)) == "Wet" then
    -- Only do if not currently in mode
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 4) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 4))
      ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
    end
  else
    -- Handle all normal cars
    -- Only do if not currently in mode
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 3) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 3))
      ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
    end
  end
end

function SetCarLowDeployment(carIndex)
  if ac.getCar(carIndex).mgukDelivery ~= 1 then
    ac.setTargetCar(carIndex)
    ac.setMGUKDelivery(1)
    -- physics.setMGUKDelivery(carIndex, 0) -- not sure why this isn't working
    ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
  end
end

function SetCarMinDeployment(carIndex)
  if ac.getCar(carIndex).mgukDelivery ~= 0 then
    ac.setTargetCar(carIndex)
    ac.setMGUKDelivery(0)
    -- physics.setMGUKDelivery(carIndex, 0) -- not sure why this isn't working
    ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
  end
end

function RestoreTyres()
  for i = 1, ac.getSim().carsCount - 1, 1
  do
    -- if in pit restore tyres
    if ac.getCar(i).isInPitlane == true and ac.getCar(i).speedKmh < 10 and ac.getCar(i).speedKmh > 1 then
      physics.setAITyres(i, 0)
      --ac.log(ac.getDriverName(carIndex) .. ": tyre wear restored")
    end
  end
end

function CheckSessionValidity()

  if ac.getPatchVersionCode() < 3281 then -- 3281 == CSP 0.2.6  (Preview versions min CSP 0.2.7 - preview)
    ac.log("CSP version too low")
    return false
  end

  if ac.getSessionName(ac.getSim().currentSessionIndex) ~= "Qualifying" then
    ac.log("Not in a qualifying session, current session is: " .. ac.getSessionName(ac.getSim().currentSessionIndex))
    return false
  end

  if physics.allowed() == false then
    ac.log("Track Physics is not enabled")
    return false
  end

  if ac.getSim().isReplayActive == true then
    ac.log("In Replay mode, app inactive")
    return false
  end

  if ac.getSim().isOnlineRace == true then
    ac.log("Not in an offline session")
    return false
  end

  return true
end

function EnablePhysics()
  -- Add needed lines to track/layout/surfaces.ini
  local trackFolderPath = ac.getFolder(tostring(ac.FolderID.ContentTracks)) .. "\\" .. ac.getTrackID()
  local surfacesFilePath = trackFolderPath .. "\\" .. ac.getTrackLayout() .. "\\data\\surfaces.ini"
  local surfacesIni = ac.INIConfig.load(surfacesFilePath, ac.INIFormat.Default)
  surfacesIni:setAndSave("SURFACE_0", "WAV_PITCH", "extended-0")
  surfacesIni:setAndSave("_SCRIPTING_PHYSICS", "ALLOW_APPS", "1")

  ac.log("Track Physics Enabled, restart from Content Manager to apply change.")
end

function DisablePhysics()
  -- Get surfaces.ini file path
  local trackFolderPath = ac.getFolder(tostring(ac.FolderID.ContentTracks)) .. "\\" .. ac.getTrackID()
  local surfacesFilePath = trackFolderPath .. "\\" .. ac.getTrackLayout() .. "\\data\\surfaces.ini"

  -- Read all lines from surfaces.ini (apart those we want to delete)
  local newLines = {}
  local readFile = io.open(surfacesFilePath, "r")
  if readFile ~= nil then
    for line in readFile:lines() do
      if line == "ALLOW_APPS=1" or line == "[_SCRIPTING_PHYSICS]" then
        -- Ignore these lines are for removal
      elseif line == "WAV_PITCH=extended-0" then
        table.insert(newLines, "WAV_PITCH=0")
      else
        table.insert(newLines, line)
      end
    end
  end

  -- Re-write the new version of the file
  local writeFile = io.open(surfacesFilePath, "w+")
  if writeFile ~= nil then
    for i = 1, #newLines, 1 do
      writeFile:write(newLines[i] .. "\n")
      ac.log(newLines[i])
    end
  end

  ac.log("Track Physics Disabled, restart from Content Manager to apply.")
end

-- MISC Functions
function DoesArrayContain(array, number)
  for index, value in ipairs(array) do
    if value == number then
      return true
    end
  end

  return false
end

-- FOR THE FUTURE

  -- Below doesn't work yet due to CSP or AC bug.
  -- if low battery at start of a lap manually restore it
  --if ac.getCar(i).kersCharge < 0.75 and ac.getCar(i).splinePosition < 0.05 then
  --ac.setTargetCar(i)
  --ac.setKERSCharge(0.99)
  --ac.getCar(i).kersCharge = 1
  --ac.log(ac.getDriverName(i) .. ": Battery Restored")

  -- physics.teleportCarTo(i, ac.SpawnSet.Pits) -- bug causes ai dead at race start
  --ac.log(ac.getDriverName(i) .. ": battery empty, sent to pits.")
  --end