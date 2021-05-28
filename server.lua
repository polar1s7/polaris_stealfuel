ESX = nil
oten = true

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback("polaris_fuelsteal:checkItem", function(source, cb, itemname, count)
    
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)["count"]
    if item >= count then
        cb(true)
    else
        cb(false)
    end
end)


RegisterServerEvent("polaris_fuelsteal:removeitem")
AddEventHandler("polaris_fuelsteal:removeitem", function(itemname, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(itemname, count)
end)

RegisterServerEvent("polaris_fuelsteal:giveitem")
AddEventHandler("polaris_fuelsteal:giveitem", function(itemname, count)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.hasWeapon(itemname) then
        	xPlayer.removeWeapon(item)
        	Citizen.Wait(1000)
            xPlayer.addWeaponAmmo(itemname, count)
        else
        	xPlayer.addWeapon(itemname, count)
    end
end)