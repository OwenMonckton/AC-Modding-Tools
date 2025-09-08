-- Author Nuzzi

-- USER VARS START
local allowLowerCspVersions = false -- Allows users to run this app on CSP versions down to CSP 0.2.0
-- USER VARS END

-- Global Vars
local initalisationComplete = false
local raceLength = (ac.getSession(ac.getSim().currentSessionIndex).laps - 1)
local aiDriverPresetArr = {}

-- Testing Vars
local testCarId = 1

-- Runs once on session restart (doesn't work on session start, only restart)
ac.onSessionStart(function(sessionIndex, restarted)
  if CheckSessionValidity() == true then
    if restarted then
      ac.log("Session Restarted")
    end
  end
end)

-- Runs once per frame
---@diagnostic disable-next-line: duplicate-set-field
function script.update(dt)
  if CheckSessionValidity() == true then
    -- Run once on session start
    if initalisationComplete == false then
      AssignAiPresets()
      initalisationComplete = true
      ac.log("Initial Setup Complete")
    end

    -- Runs once each frame
    ManageAllAi()
  end
end

-- Runs once per frame on the Main window
---@diagnostic disable-next-line: duplicate-set-field
function script.windowMain(dt)
  -- Show Session info
    ui.text("Session Info:")
    ui.text("Session Type: " .. ac.getSessionName(ac.getSim().currentSessionIndex))
  if CheckSessionValidity() == true then
    -- Next / Last Driver Buttons
    if ui.button("Next Driver") and testCarId < (ac.getSim().carsCount - 1) then
      testCarId = testCarId + 1
    end
    if ui.button("Prev Driver") and testCarId > 1 then
      testCarId = testCarId - 1
    end

    -- Show AI Car status
    ui.newLine(5)
    ui.text(ac.getDriverName(testCarId) .. " info:")
    ui.text("Lap: " .. ac.getCar(testCarId).lapCount + 1) -- +1 to make first lap == 1

    -- Location
    if ac.getCar(testCarId).isInPitlane == true then
      ui.text("Location: In Pitlane")
    else
      ui.text("Location: On track")
    end

    -- MGUK / Battery
    ui.newLine(1)
    ui.text("Driver AI Preset: " .. aiDriverPresetArr[testCarId])
    ui.text("Battery: " .. math.round(ac.getCar(testCarId).kersCharge * 100) .. "%")

    if ac.getCar(testCarId).hasCockpitERSDelivery == true then
      ui.text("MGUK mode: " .. ac.getCar(testCarId).mgukDelivery .. "/" .. (ac.getCar(testCarId).mgukDeliveryCount - 1))
      ui.text("MGUK mode name: " .. ac.getMGUKDeliveryName(testCarId))
      if ac.getCar(testCarId).kersCharging == true then
        ui.text("Battery is charging")
      else
        ui.text("Battery is depleting")
      end
    else
      ui.text("This car does not have cockpit ERS/MGUK modes")
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
    end
  end
end

-- FUNCTIONS
function AssignAiPresets()
  -- Extra Randomness
  math.randomseed(os.time())

  for i = 1, ac.getSim().carsCount - 1, 1
  do
    local rand = math.random(1, 3)
    if rand == 1 then
      aiDriverPresetArr[i] = "Default"
      ac.log(ac.getDriverName(i) .. " Default Preset Assigned")
    elseif rand == 2 then
      aiDriverPresetArr[i] = "AggressiveStarter"
      ac.log(ac.getDriverName(i) .. " AggressiveStarter Preset Assigned")
    else
      aiDriverPresetArr[i] = "PassiveStarter"
      ac.log(ac.getDriverName(i) .. " PassiveStarter Preset Assigned")
    end
  end

  ac.log("All AI Presets Assigned")
end

function ManageAllAi()
  for i = 1, ac.getSim().carsCount - 1, 1
  do
    -- current car vars
    local lapAllowanceLeftPercent = (100 - ((ac.getCar(i).kersCurrentKJ / ac.getCar(i).kersMaxKJ) * 100))
    local batteryPercent = math.round(ac.getCar(i).kersCharge * 100)

    if ac.getCar(i).hasCockpitERSDelivery == true then -- Only do for cars that have MGUK/Battery modes
      if aiDriverPresetArr[i] == "Default" then
        ManageAiDefaultPreset(i, batteryPercent, lapAllowanceLeftPercent)
      elseif aiDriverPresetArr[i] == "AggressiveStarter" then
        ManageAiAggressiveStarterPreset(i, batteryPercent, lapAllowanceLeftPercent)
      else
        ManageAiPassiveStarterPreset(i, batteryPercent, lapAllowanceLeftPercent)
      end
    end
  end
end

function ManageAiDefaultPreset(carIndex, batteryPercent, lapAllowanceLeftPercent)
  -- Yellow Flag? or In Pitlane? or Race Finished?
  if ac.getSim().raceFlagType == ac.FlagType.Caution or ac.getCar(carIndex).isInPitlane == true or ac.getCar(carIndex).isRaceFinished == true then
    SetCarMinimalDeployment(carIndex)
  else

    -- Battery Empty?
    if batteryPercent < 1 or lapAllowanceLeftPercent < 1 then
    SetCarMinimalDeployment(carIndex)
    else

      -- Final Lap?
      if raceLength == ac.getCar(carIndex).lapCount then
        if batteryPercent < 10 or lapAllowanceLeftPercent < 10 then
          SetCarMediumDeployment(carIndex)
        else
          SetCarMaxDeployment(carIndex)
        end
      else

        -- Default Management (Always runs when none of the above cases are triggered)
        if batteryPercent < 10 or lapAllowanceLeftPercent < 10 then
          SetCarLowDeployment(carIndex)
        elseif batteryPercent < 50 or lapAllowanceLeftPercent < 20 then
          SetCarMediumDeployment(carIndex)
        else
          SetCarMaxDeployment(carIndex)
        end
      end
    end
  end
end

function ManageAiAggressiveStarterPreset(carIndex, batteryPercent, lapAllowanceLeftPercent)
  -- Yellow Flag? or In Pitlane? or Race Finished?
  if ac.getSim().raceFlagType == ac.FlagType.Caution or ac.getCar(carIndex).isInPitlane == true or ac.getCar(carIndex).isRaceFinished == true then
    SetCarMinimalDeployment(carIndex)
  else

    -- Battery Empty?
    if batteryPercent < 1 or lapAllowanceLeftPercent < 1 then
    SetCarMinimalDeployment(carIndex)
    else

      -- Final Lap or First 3 Laps?
      if raceLength == ac.getCar(carIndex).lapCount or (ac.getCar(carIndex).lapCount + 1) <= 3 then
        if batteryPercent < 10 or lapAllowanceLeftPercent < 10 then
          SetCarMediumDeployment(carIndex)
        else
          SetCarMaxDeployment(carIndex)
        end
      else

        -- Default Management (Always runs when none of the above cases are triggered)
        if batteryPercent < 10 or lapAllowanceLeftPercent < 10 then
          SetCarLowDeployment(carIndex)
        elseif batteryPercent < 50 or lapAllowanceLeftPercent < 20 then
          SetCarMediumDeployment(carIndex)
        else
          SetCarMaxDeployment(carIndex)
        end
      end
    end
  end
end

function ManageAiPassiveStarterPreset(carIndex, batteryPercent, lapAllowanceLeftPercent)
  -- Yellow Flag? or In Pitlane? or Race Finished?
  if ac.getSim().raceFlagType == ac.FlagType.Caution or ac.getCar(carIndex).isInPitlane == true or ac.getCar(carIndex).isRaceFinished == true then
    SetCarMinimalDeployment(carIndex)
  else

    -- Battery Empty?
    if batteryPercent < 1 or lapAllowanceLeftPercent < 1 then
    SetCarMinimalDeployment(carIndex)
    else

      -- First 3 Laps?
      if (ac.getCar(carIndex).lapCount + 1) <= 3 then
        if batteryPercent < 50 or lapAllowanceLeftPercent < 10 then
          SetCarLowDeployment(carIndex)
        elseif batteryPercent < 75 or lapAllowanceLeftPercent < 25 then
          SetCarMediumDeployment(carIndex)
        else
          SetCarMaxDeployment(carIndex)
        end
      else

        -- Final Lap?
        if raceLength == ac.getCar(carIndex).lapCount then
          if batteryPercent < 10 or lapAllowanceLeftPercent < 10 then
            SetCarMediumDeployment(carIndex)
          else
            SetCarMaxDeployment(carIndex)
          end
        else

          -- Default Management (Always runs when none of the above cases are triggered)
          if batteryPercent < 10 or lapAllowanceLeftPercent < 10 then
            SetCarLowDeployment(carIndex)
          elseif batteryPercent < 50 or lapAllowanceLeftPercent < 20 then
            SetCarMediumDeployment(carIndex)
          else
            SetCarMaxDeployment(carIndex)
          end
        end
      end
    end
  end
end

-- MISC FUNCTIONS
function SetCarMaxDeployment(carIndex)
  -- Handle VRC Formula Alpha cars (highest mode is 'wet' for these cars)
  if ac.getMGUKDeliveryName(carIndex, (ac.getCar(carIndex).mgukDeliveryCount - 1)) == "Wet" then
    -- Only do if not currently in mode
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 2) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 2))
      ac.log(ac.getDriverName(carIndex) .. " mguk set MAX mode")
    end
  else
    -- Handle all normal cars where highest mode is highest deployment
    if ac.getCar(carIndex).mgukDelivery ~= (ac.getCar(carIndex).mgukDeliveryCount - 1) then
      ac.setTargetCar(carIndex)
      ac.setMGUKDelivery((ac.getCar(carIndex).mgukDeliveryCount - 1))
      ac.log(ac.getDriverName(carIndex) .. " mguk set MAX mode")
    end
  end
end

function SetCarHighDeployment(carIndex) -- Not Currently Being Used
  if ac.getCar(carIndex).mgukDelivery ~= 3 then
    ac.setTargetCar(carIndex)
    ac.setMGUKDelivery(3)
    -- physics.setMGUKDelivery(carIndex, 0) -- not sure why this isn't working
    ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
  end
end

function SetCarMediumDeployment(carIndex)
  if ac.getCar(carIndex).mgukDelivery ~= 2 then
    ac.setTargetCar(carIndex)
    ac.setMGUKDelivery(2)
    -- physics.setMGUKDelivery(carIndex, 0) -- not sure why this isn't working
    ac.log(ac.getDriverName(carIndex) .. " mguk set to " .. ac.getMGUKDeliveryName(carIndex))
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

function SetCarMinimalDeployment(carIndex)
  -- Only do if not currently in this mode
  if ac.getCar(carIndex).mgukDelivery ~= 0 then
    ac.setTargetCar(carIndex)
    ac.setMGUKDelivery(0)
    ac.log(ac.getDriverName(carIndex) .. " mguk set MINIMAL mode")
  end
end

function CheckSessionValidity()
  if CheckCspVersion == false then
    ac.log("CSP version too low")
    return false
  end

  if ac.getSessionName(ac.getSim().currentSessionIndex) ~= "Quick Race" and ac.getSessionName(ac.getSim().currentSessionIndex) ~= "Race" then
    ac.log("Not in a race session, current session is: " .. ac.getSessionName(ac.getSim().currentSessionIndex))
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

function CheckCspVersion()
  if allowLowerCspVersions == true then
    if ac.getPatchVersionCode() >= 2651 then -- 2651 == CSP 0.2.0
      return true
    else
      ac.log("ERROR: CSP too low. Minimum CSP 0.2.0 when allowing lower versions.")
      return false
    end
  else
    if ac.getPatchVersionCode() >= 3044 then -- 3044 == CSP 0.2.3  (Preview versions min CSP 0.2.4 - preview)
      return true
    else
      ac.log("ERROR: CSP too low. Minimum free version is CSP 0.2.3.  Minimum preview version is CSP 0.2.4 - Preview.")
      return false
    end
  end
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

 -- Supported & Tested cars: (can't use AI CSP cars):
    -- VRC 24 - High - 3/4
    -- VRC 23 - High - 4/5
    -- rss 2022 - Attack - 5/5
    -- rss 2021 - Hotlap - 5/5
    -- rss 2020 - Hotlap - 5/5
    -- rss 2019 - Hotlap - 5/5
    -- rss 2018 - Hotlap - 5/5
    -- rss 2017 - Hotlap - 5/5
    -- kunos f1 2017 - Hotlap - 6/6
    -- kunos f1 2015 - Hotlap 5/5
    -- kunos Porche 919 Hybrid 2016 - Hotlap
    -- (should support all other kunos cars with MGUK modes)
  -- All other cars will work but not as well as the above supported.
