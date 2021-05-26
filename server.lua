ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterServerEvent('requestInventory')
AddEventHandler('requestInventory', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    slots = {}
    slotid = 0
    id = 1
    data = xPlayer.getInventory()
    
    for key, value in pairs(data) do

	
        if value.count > 0 then
            items = {Slot = slotid, Id = id, Amount = value.count, ImagePath = value.name .. ".png", Weight = value.weight, Name = value.name}
            table.insert(slots, items)
            slotid = slotid + 1
            id = id + 1
        end

    end
    datas = xPlayer.getLoadout()
    
    for key, value in pairs(datas) do
	image = value.name
	image = image:gsub("WEAPON_", "")

            waffen = {Slot = slotid, Id = id, Amount = 1, ImagePath = image ..".png", Weight = 5, Name = value.name}
            table.insert(slots, waffen)
            slotid = slotid + 1
            id = id + 1

    end

    inventory = {inventory = {{Id = 1, Name = "Inventar | GVRP.eu", Money = xPlayer.getMoney(), Blackmoney = 0, Weight = xPlayer.getWeight(), MaxWeight = 40000, MaxSlots = 9, Slots = slots}}}
    TriggerClientEvent('responseInventory', source, json.encode(inventory))
end)



RegisterNetEvent('useInventoryItem')
AddEventHandler('useInventoryItem', function(name)
    local xPlayer = ESX.GetPlayerFromId(source)

    print(name)
	if name ~= nil then
		ESX.UseItem(xPlayer.source, name)
	end
end)

RegisterNetEvent('giveInventoryItem')
AddEventHandler('giveInventoryItem', function(name, count, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(target)

    if string.match(name, "WEAPON_") then
        if xPlayer.hasWeapon(name) then
            xPlayer.removeWeapon(name, 200)
            xTarget.addWeapon(name, 200)
        end

        return
    end
	local notdupi = xPlayer.getInventoryItem(name).count

	if notdupi < tonumber(count) then 
			xPlayer.showNotification("Ungültige Anzahl!")
			
		else
	xPlayer.removeInventoryItem(name, tonumber(count))
	xTarget.addInventoryItem(name, tonumber(count))
	TriggerClientEvent('esx:showNotification', target, "Du hast " ..count.. "x " ..name.. "  bekommen ")
	end
end)


RegisterNetEvent('dropInventoryItem')
AddEventHandler('dropInventoryItem', function(name, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if string.match(name, "WEAPON_") then
        if xPlayer.hasWeapon(name) then
            xPlayer.removeWeapon(name, 200)
        end

        return
    end

	local thetrolls = xPlayer.getInventoryItem(name).count

	if thetrolls < tonumber(count) then 
			xPlayer.showNotification("Ungültige Anzahl!")
			
		else
            xPlayer.removeInventoryItem(name, count)    
		end
end)