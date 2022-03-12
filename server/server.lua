ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Code

ESX.RegisterServerCallback("kingwolf-vehiclekeys:server:get:key:config", function(source, cb)
  cb(Config)
end)

ESX.RegisterServerCallback("kingwolf-vehiclekeys:server:has:keys", function(source, cb, plate)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if Config.VehicleKeys[plate] ~= nil then
        if Config.VehicleKeys[plate]['Identifier'] == Player.getIdentifier() and Config.VehicleKeys[plate]['HasKey'] then
            HasKey = true
        else
            HasKey = false
        end
    else
        HasKey = false
    end
    cb(HasKey)
end)

-- // Events \\ --

RegisterServerEvent('kingwolf-vehiclekeys:server:set:keys')
AddEventHandler('kingwolf-vehiclekeys:server:set:keys', function(Plate, bool)
  local Player = ESX.GetPlayerFromId(source)
  Config.VehicleKeys[Plate] = {['Identifier'] = Player.getIdentifier(), ['HasKey'] = bool}
  TriggerClientEvent('kingwolf-vehiclekeys:client:set:keys', -1, Plate, Player.getIdentifier(), bool)
end)

RegisterServerEvent('kingwolf-vehiclekeys:server:give:keys')
AddEventHandler('kingwolf-vehiclekeys:server:give:keys', function(Target, Plate, bool)
  local Player = ESX.GetPlayerFromId(Target)
  if Player ~= nil then
    TriggerClientEvent('ESX:Notify', Player.PlayerData.source, "Bạn đã nhận được chìa khóa từ một chiếc xe với biển số xe: "..Plate, 'success')
    Config.VehicleKeys[Plate] = {['Identifier'] = Player.getIdentifier(), ['HasKey'] = bool}
    TriggerClientEvent('kingwolf-vehiclekeys:client:set:keys', -1, Plate, Player.getIdentifier(), bool)
  end
end)