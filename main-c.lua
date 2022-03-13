-----------------------------------
-- ESX Init
-----------------------------------

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
		ESX = obj
		end)
	end
end)

-----------------------------------
-- Blip / Marker
-----------------------------------
Citizen.CreateThread(function()
    for _, item in pairs(Config.Locations) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, 225)
        SetBlipAsShortRange(item.blip, true)
        SetBlipColour(blip, 47)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end


    while true do
        Citizen.Wait(5)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped, true)
        for _, item in pairs(Config.Locations) do
            if (IsPedSittingInAnyVehicle(ped)) then
                if(Vdist(pos.x, pos.y, pos.z, item.x, item.y, item.z) < 100) then
                    DrawMarker(36, item.x, item.y, item.z+1.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 5.0, 1.0, 255, 0, 0, 100, true, true, 2, true, false, false, false)
                    DrawMarker(0, item.x, item.y, item.z-0.4, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 255, 0, 255, 100, false, false, 2, false, false, false, false)
                    if(Vdist(pos.x, pos.y, pos.z, item.x, item.y, item.z) < 2.5) then
                        Hint("Press ~INPUT_PICKUP~ to access the DMV")
                        if IsControlJustPressed(0, 38) then	
                            DMV()
                        end	
                    end
                end
            end
        end
    end
end)
-----------------------------------
-- DMV Logic
-----------------------------------


RegisterCommand("dmv", function()
    DMV()
end, false)

function DMV()
    local ped = GetPlayerPed(-1)
    if (IsPedSittingInAnyVehicle(ped)) then
        local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(ped, false))
        SetCursorLocation(0.5, 0.5)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "show",
            currentPlate = plate
        })
    end
end

RegisterNUICallback('plateRequest', function(data, cb) -- Execute command from block clicked
    local newPlate = data.itemId
    local ped = GetPlayerPed(-1)
    local oldPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(ped, false))
    if (IsPedSittingInAnyVehicle(ped)) then
        plateCheck(newPlate, oldPlate)
    end
end)

function plateCheck(plate, oldPlate)
    local ped = GetPlayerPed(-1)
    ESX.TriggerServerCallback('hop_licenseplates:update', function( cb )
        if cb == 'confirm' then
            SetVehicleNumberPlateText(GetVehiclePedIsIn(ped, false), plate)
            ESX.ShowNotification("Vehicle license plate changed too: ".. plate)
            SendNUIMessage({
                type = "valid"
            })
        elseif cb == 'error' then
            ESX.ShowNotification("The plate: ".. plate .." is currently not availible.")
            SendNUIMessage({
                type = "notValid"
            })
        elseif cb == 'money' then
            ESX.ShowNotification("The plate: ".. plate .." is valid but you cannot afford it.")
        end
      end, oldPlate, plate)
end


RegisterNUICallback('close', function(data, cb) -- Return focus on close
    SetNuiFocus(false, false)
end)

function Hint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end