active = false
ESX = nil

Citizen.CreateThread(function()
  	while ESX == nil do
    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    	Citizen.Wait(250)
  	end

  	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(250)
	end
	
  ESX.PlayerData = ESX.GetPlayerData()

end)


Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 289) then
            TriggerServerEvent('requestInventory')
        end
        Citizen.Wait(0)
    end
end)

RegisterNUICallback('trigger', function(data, cb)
	if data.args[2] == "useInventoryItem" then
    TriggerServerEvent("useInventoryItem", data.args[3])
    end
    if data.args[2] == "giveInventoryItem" then
        TriggerEvent("giveInventoryItem", data.args[3], data.args[4])
        end
        if data.args[2] == "dropInventoryItem" then
            TriggerEvent("dropInventoryItem", data.args[3], data.args[4])
            end
	cb('ok')
end)

RegisterNetEvent('responseInventory')
AddEventHandler('responseInventory', function(data)
    openMenu(data)
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNetEvent('giveInventoryItem')
AddEventHandler('giveInventoryItem', function(name, count)
    if tonumber(count) > 0 then

        local playerPed = GetPlayerPed(-1)
        loadAnimDict('anim@mp_snowball')
        local player, dist = ESX.Game.GetClosestPlayer()
    
        if player == -1 or dist > 3.0 then
            ESX.ShowNotification('Es ist keine Person in der Nähe')
        else
            TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
            Citizen.Wait(1300)
            ClearPedTasksImmediately(playerPed)
            TriggerServerEvent('giveInventoryItem', name, count, GetPlayerServerId(player))
            ESX.ShowNotification(("Du hast jemanden %sx %s zugesteckt"):format(count, name))
        end
            else
        
            ESX.ShowNotification("pls dont dupe :(!")
            end
end)

RegisterNetEvent('dropInventoryItem')
AddEventHandler('dropInventoryItem', function(name, count)
    if tonumber(count) > 0 then

        local playerPed = GetPlayerPed(-1)
        loadAnimDict('anim@mp_snowball')
        local player, dist = ESX.Game.GetClosestPlayer()
    

            TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0)
            Citizen.Wait(1300)
            ClearPedTasksImmediately(playerPed)
            TriggerServerEvent('dropInventoryItem', name, count)
            ESX.ShowNotification(("Du wirfst %sx %s weg"):format(count, name))
            else
        
        ESX.ShowNotification("pls dont dupe :(!")
        end
end)
RegisterNUICallback('close', function(data, cb)
	closeMenu()
end)

function openMenu(data)
    SendNUIMessage({
        action = "open",
        data = data
    })
    SetNuiFocus(true, true)
end

function closeMenu()
    SetNuiFocus(false, false)
end