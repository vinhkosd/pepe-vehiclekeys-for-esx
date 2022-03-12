**Use this code to give vehicle key to ped when spawn their vehicle**
```javascript
 ESX.Game.SpawnVehicle(vehicle.model, {
                    x = SpawnCoords.x,
                    y = SpawnCoords.y,
                    z = SpawnCoords.z
                }, OffsetGarage.listplace[i].h, function(**callback_vehicle**)
                    ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
                    SetVehRadioStation(callback_vehicle, "OFF")
                    SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
                    SetVehicleEngineHealth(callback_vehicle, vehicle.engineHealth + 0.0)
                    table.insert(ListVehilce, callback_vehicle)
                    INSERT THIS LINE --> 
					exports['kingwolf-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(callback_vehicle), true)
                end)
				
				end)
```
###### Remember the variable callback_vehicle you inserted must be your callback variable, in my example that is callback_vehicle. And **kingwolf-vehiclekeys** is resource name, in my case is kingwolf-vehiclekeys, may be that is pepe-vehiclekeys-for-esx in your resource

#### If you want to turn off vehicle if PED doesn't have key of vehicle, you just uncomment that code:If you want to turn off vehicle if PED doesn't have key of vehicle, you just uncomment that code:
```javascript
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
```

