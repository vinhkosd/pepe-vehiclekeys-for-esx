ESX = nil

local IsRobbing = false
local LastVehicle = nil
local isLoggedIn = true

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
  Citizen.SetTimeout(1250, function()
      isLoggedIn = true
  end)
end)

Citizen.CreateThread(function()
    while ESX == nil do Wait(1) end
    while not ESX.IsPlayerLoaded() do Wait(1000) end
    isLoggedIn = true
end)

-- Code

-- // Loops \\ --
--I Just turn off the code what was turn off vehicle on not have key because my server just use this code for lock and unlock car, no engine off if not have key
-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(5)
--         if isLoggedIn then
--         local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
--         local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
--         if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), true), -1) == GetPlayerPed(-1) then
--             if LastVehicle ~= Vehicle then
--             ESX.TriggerServerCallback("kingwolf-vehiclekeys:server:has:keys", function(HasKey)
--                 if HasKey then
--                     HasCurrentKey = true
--                     SetVehicleEngineOn(Vehicle, true, false, true)
--                 else 
--                     HasCurrentKey = false
--                     SetVehicleEngineOn(Vehicle, false, false, true)
--                 end
--                 LastVehicle = Vehicle
--             end, Plate)  
--             else
--             Citizen.Wait(750)
--           end
--         else
--             Citizen.Wait(750)
--         end
--         if not HasCurrentKey and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
--             local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
--             SetVehicleEngineOn(Vehicle, false, false, true)
--         end
--      end
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if isLoggedIn then
            if IsControlJustReleased(1, Config.Keys["L"]) then
                ToggleLocks()
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('kingwolf-vehiclekeys:client:set:keys')
AddEventHandler('kingwolf-vehiclekeys:client:set:keys', function(Plate, Identifier, bool)
    Config.VehicleKeys[Plate] = {['Identifier'] = Identifier, ['HasKey'] = bool}
    LastVehicle = nil
end)

RegisterNetEvent('kingwolf-vehiclekeys:client:give:key')
AddEventHandler('kingwolf-vehiclekeys:client:give:key', function(TargetPlayer)
    local Vehicle, VehDistance = ESX.Game.GetClosestVehicle()
    local Player, Distance = ESX.Game.GetClosestPlayer()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    ESX.TriggerServerCallback("kingwolf-vehiclekeys:server:has:keys", function(HasKey)
        if HasKey then
            if Player ~= -1 and Player ~= 0 and Distance < 2.3 then
                 ESX.Functions.Notify("Bạn đã đưa chìa khóa xe với biển số xe: "..Plate, 'success')
                 TriggerServerEvent('kingwolf-vehiclekeys:server:give:keys', GetPlayerServerId(Player), Plate, true)
            else
                ESX.Functions.Notify("Không có công dân gần đó?", 'error')
            end
        else
            ESX.Functions.Notify("Bạn không có chìa khóa cho chiếc xe này.", 'error')
        end
    end, Plate)
end)

RegisterNetEvent('kingwolf-items:client:use:lockpick')
AddEventHandler('kingwolf-items:client:use:lockpick', function(IsAdvanced)
 local Vehicle, VehDistance = ESX.Game.GetClosestVehicle()
 local Plate = GetVehicleNumberPlateText(Vehicle)
 local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
 if VehDistance <= 4.5 then
   ESX.TriggerServerCallback("kingwolf-vehiclekeys:server:has:keys", function(HasKey)
      if not HasKey then
       if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
          LoadAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
          TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
          exports['kingwolf-lockpick']:OpenLockpickGame(function(Success)
             if Success then
                 SetVehicleKey(Plate, true)
                 StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             else
                  if IsAdvanced then
                    if math.random(1,100) < 19 then
                      TriggerServerEvent('ESX:Server:RemoveItem', 'advancedlockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", ESX.Shared.Items['advancedlockpick'], "remove")
                    end
                  else
                    if math.random(1,100) < 35 then
                      TriggerServerEvent('ESX:Server:RemoveItem', 'lockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", ESX.Shared.Items['lockpick'], "remove")
                    end
                  end
                 ESX.Functions.Notify("Thất bại.", 'error')
                 StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end
          end)
       else
          if VehicleLocks == 2 then
          LoadAnim("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
          TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
          exports['kingwolf-lockpick']:OpenLockpickGame(function(Success)
             if Success then
                 SetVehicleDoorsLocked(Vehicle, 1)
                 ESX.Functions.Notify("Đã phá khoá cửa", 'success')
                 TriggerEvent('kingwolf-vehiclekeys:client:blink:lights', Vehicle)
                 local coords = GetEntityCoords(GetPlayerPed(-1))
                 TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "car-unlock", 0.2, coords)
                 StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             else
                if IsAdvanced then
                    if math.random(1,100) < 25 then
                      TriggerServerEvent('ESX:Server:RemoveItem', 'advancedlockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", ESX.Shared.Items['advancedlockpick'], "remove")
                    end
                  else
                    if math.random(1,100) < 35 then
                      TriggerServerEvent('ESX:Server:RemoveItem', 'lockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", ESX.Shared.Items['lockpick'], "remove")
                    end
                end
                ESX.Functions.Notify("Thất bại.", 'error')
                StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end
           end)
          end
       end
      end
   end, Plate)  
 end
end)

RegisterNetEvent('kingwolf-vehiclekeys:client:toggle:lock')
AddEventHandler('kingwolf-vehiclekeys:client:toggle:lock', function()
    ToggleLocks()
end)

-- // Functions \\ --

function SetVehicleKey(Plate, bool)
 TriggerServerEvent('kingwolf-vehiclekeys:server:set:keys', Plate, bool)
end

function ToggleLocks()
 local Vehicle, VehDistance = ESX.Game.GetClosestVehicle()
 if Vehicle ~= nil and Vehicle ~= 0 then
    local VehicleCoords = GetEntityCoords(Vehicle)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if VehDistance <= 5.0 then
        ESX.TriggerServerCallback("kingwolf-vehiclekeys:server:has:keys", function(HasKey)
         if HasKey then
            LoadAnim("anim@mp_player_intmenu@key_fob@")
            TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
            if VehicleLocks == 1 then
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 2)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerEvent('kingwolf-vehiclekeys:client:blink:lights', Vehicle)
                ESX.Functions.Notify("Đã khoá xe", 'error')
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "car-lock", 0.2, PlayerCoords)
            else
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 1)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerEvent('kingwolf-vehiclekeys:client:blink:lights', Vehicle)
                ESX.Functions.Notify("Đã mở khoá", 'success')
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "car-unlock", 0.2, PlayerCoords)
            end
         else
            ESX.Functions.Notify("Bạn không có chìa khóa cho chiếc xe này.", 'error')
        end
    end, Plate)
    end
 end
end

RegisterNetEvent('kingwolf-vehiclekeys:client:blink:lights')
AddEventHandler('kingwolf-vehiclekeys:client:blink:lights', function(Vehicle)
 SetVehicleLights(Vehicle, 2)
 SetVehicleBrakeLights(Vehicle, true)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
 Citizen.Wait(450)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleLights(Vehicle, 0)
 SetVehicleBrakeLights(Vehicle, false)
 SetVehicleInteriorlight(Vehicle, false)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
end)

function LoadAnim(animDict)
    RequestAnimDict(animDict)
  
    while not HasAnimDictLoaded(animDict) do
      Citizen.Wait(10)
    end
  end
  
  function LoadModel(model)
    RequestModel(model)
  
    while not HasModelLoaded(model) do
      Citizen.Wait(10)
    end
  end
  