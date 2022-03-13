local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- UPDATE license plate to the database
ESX.RegisterServerCallback('hop_licenseplates:update', function(source, cb, oldP, newP)
    local oldplate = string.upper(tostring(oldP):match("^%s*(.-)%s*$"))
    local newplate = string.upper(newP)
    local xPlayer  = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles', {},
        function (result)
            local dupe = false
        for i=1, #result, 1 do
            if result[i].plate == newplate then
                dupe = true
            end
        end
        if string.match(newplate, "%d+") ~= nil then
            if not dupe then
                MySQL.Async.fetchAll('SELECT plate, vehicle FROM owned_vehicles WHERE plate = @plate', {['@plate'] = oldplate},
                function (result)
                    if result[1] ~= nil then
                        if xPlayer.getMoney() >= 2000 then		
                            xPlayer.removeMoney(2000)
                            local vehicle = json.decode(result[1].vehicle)
                            vehicle.plate = newplate
                            MySQL.Async.execute('UPDATE owned_vehicles SET plate = @newplate, vehicle = @vehicle WHERE plate = @oldplate', {['@newplate'] = newplate, ['@oldplate'] = oldplate, ['@vehicle'] = json.encode(vehicle)})
                            cb('confirm')
                        else 
                            cb('money')
                        end
                    else
                        cb('unowned')
                    end
                end)
            else 
                cb('error')
            end
        else 
            cb('number')
        end
    end)
end)