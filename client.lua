ESX = nil


isInVehicle = false
isLocked = 1

Citizen.CreateThread(function()
  	while ESX == nil do
  	    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
  	    Citizen.Wait(1)

  	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local getVeh = GetVehiclePedIsIn(PlayerPedId(), false)
		isInVehicle = IsPedInVehicle(PlayerPedId(), getVeh, false)
		isLocked = GetVehicleDoorLockStatus(VehicleInFront())
	end
end)

 -- Get the Vehicle in Front
function VehicleInFront()
    local vehicle, distance = ESX.Game.GetClosestVehicle()
    if vehicle ~= nil and distance < 3 then
        return vehicle
    else 
        return nil
    end
end

TriggerEvent('chat:addSuggestion', '/stealfuel', 'Steal fuel from any car that is unlocked')



RegisterCommand('stealfuel', function(source)
	local fuelLevel = exports["LegacyFuel"]:GetFuel(VehicleInFront())
	if isLocked <= 1 then
		if fuelLevel >= Config.fuel_limit_to_steal then
			if not isInVehicle then
				if VehicleInFront() ~= nil then
					ESX.TriggerServerCallback("polaris_fuelsteal:checkItem", function(output)
						if output then
							TriggerServerEvent("polaris_fuelsteal:removeitem", Config.itemneedtosteal, Config.NeededAmountToSteal)
							playanimation(PlayerPedId(), "mini@repair", "fixing_a_ped")
							exports['progressBars']:startUI(Config.Time_to_steal, "Stealing Fuel")
							Citizen.Wait(Config.Time_to_steal)
							GiveWeaponToPed(PlayerPedId(), "WEAPON_PETROLCAN", math.floor(fuelLevel), false, true)
							exports["LegacyFuel"]:SetFuel(VehicleInFront(), 0)
							exports['mb_notify']:sendNotification('You successfully stole the fuel.')
							SetCurrentPedWeapon(PlayerPedId(), "WEAPON_PETROLCAN", true)
							ClearPedTasks(PlayerPedId())
						else
							exports['mb_notify']:sendNotification('You don\'t have bread.')
						end
					end, Config.itemneedtosteal, Config.NeededAmountToSteal)
				else
					exports['mb_notify']:sendNotification('There is no vehicle near you.', {type="error", vertical="top", duration=1000})

				end
			else
				exports['mb_notify']:sendNotification('There is no fuel inside the vehicle.', {type="error", vertical="top", duration=1000})
			end
		else
			exports['mb_notify']:sendNotification('Gas is too low.', {type="error", vertical="top", duration=2000})
		end
	else
		exports['mb_notify']:sendNotification('Fuel Filler is locked.', {type="error", vertical="top", duration=2000})
	end
end)

-- Just to check the fuel
RegisterCommand('fuel', function(source)
	local fuelLevel = exports["LegacyFuel"]:GetFuel(VehicleInFront())
	print(math.floor(fuelLevel))
end)

--
function playanimaton(ped, dic, anim)
	ESX.Streaming.RequestAnimDict(dic, function()
		TaskPlayAnim(ped, dic, anim, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
	end)
end
