local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local currentProp = nil
local timer = GetGameTimer()
local markerplayer = nil
local isBinding = false

local store = {}
store.toggle = false

store.nui = {
    type = 2,
    distance = 0.00,
    cursive = 0,
    angle = 0,
    heading = 0
}

local carryTypes = {
	['carry'] = {
		label = 'Na strażaka',
		dict = 'missfinale_c2mcs_1',
		dictTarget = 'nm',
		anim = 'fin_c2_mcs_1_camman',
		animTarget = 'firemans_carry',
		distance = 0.15,
		distanceTarget = 0.27,
		height = 0.63,
		length = -1,
		spin = 0,
		controlFlag = 49,
		controlFlagTarget = 33
	},
	['piggy'] = {
		label = 'Na plecy',
		dict = 'anim@arena@celeb@flat@paired@no_props@',
		dictTarget = 'anim@arena@celeb@flat@paired@no_props@',
		anim = 'piggyback_c_player_a',
		animTarget = 'piggyback_c_player_b',
		distance = -0.07,
		distanceTarget = 0.0,
		height = 0.45,
		length = -1,
		spin = 0,
		controlFlag = 49,
		controlFlagTarget = 33
	},
	['lift'] = {
		label = 'Na ręce',
		dict = 'anim@heists@box_carry@',
		dictTarget = 'amb@code_human_in_car_idles@generic@ps@base',
		anim = 'idle',
		animTarget = 'base',
		distance = 0.4,
		distanceTarget = 0,
		height = 0.15,
		length = -1,
		spin = 90.0,
		controlFlag = 49,
		controlFlagTarget = 33
	},
}

local isCarried, isCarrying = false, false
local currentCarryType = nil

function startAnim(libr, anim, loop, propTable)

	local ped = PlayerPedId()

	if exports['core']:isPedAble(ped) then
		SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)

		store.currentAnim = {
			lib = libr,
			anim = anim,
			loop = loop
		}

		if propTable then
			if currentProp then
				DeleteEntity(currentProp)
				currentProp = nil
			end
			currentProp = CreateObject(propTable.name, GetEntityCoords(ped), true)
			AttachEntityToEntity(currentProp, ped, GetPedBoneIndex(ped, propTable.bone), propTable.xPos, propTable.yPos, propTable.zPos, tonumber(propTable.xRot), tonumber(propTable.yRot), tonumber(propTable.zRot), true, propTable.useSoftPinning, propTable.collision, propTable.isPed, propTable.rotationOrder, propTable.fixedRot)
		end

		ESX.Streaming.RequestAnimDict(libr, function()
			TaskPlayAnim(ped, libr, anim, 8.0, -8.0, -1, loop, 1, false, false, false)
			RemoveAnimDict(libr)
		end)
	end
end

exports('startAnim', startAnim)

function chooseAnim(animTable, propTable, animType)
	if animType == 'scenario' then
		startScenario(animTable.anim)
	elseif animType == 'attitude' then
		startAttitude(animTable.lib, animTable.anim)
	elseif animType == 'faceExpression' then
		startFaceExpression(animTable.anim)
	elseif animType == 'anim' then
		startAnim(animTable.lib, animTable.anim, animTable.loop, propTable)
	end
end

function playAnim(anim)
	for i=1, #Config['anims'].Animations, 1 do
		for j=1, #Config['anims'].Animations[i].items, 1 do
			if Config['anims'].Animations[i].items[j].data.e == anim then
				local item = Config['anims'].Animations[i].items[j]
				chooseAnim(item.data, item.prop, item.type)
				break
			end
		end
	end
end

function cancelAnim()
	local ped = PlayerPedId()
	ClearPedTasks(ped)
	store.currentAnim = nil
	if store.toggle then
		store.toggleFunc()
	end
	if currentProp then
		DeleteEntity(currentProp)
		currentProp = nil
	end
end

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startScenario(anim)
	SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function startFaceExpression(anim)
	SetFacialIdleAnimOverride(PlayerPedId(), anim)
end
 
function OpenAnimationsMenu(showAnimations, useBinding)
	local elements = {}
	local title = 'Animacje'

	if not useBinding then
		if showAnimations then
			ESX.UI.Menu.CloseAll()
			for i=1, #Config['anims'].Animations, 1 do
				elements[#elements+1] = {label = Config['anims'].Animations[i].label, value = Config['anims'].Animations[i].name}
			end
			title = 'Kategorie'
		else
			elements[#elements+1] = { label = "Wybierz animacje", value = "animations" }
			elements[#elements+1] = { label = "Przypisz animacje", value = "bind" }
			elements[#elements+1] = { label = "Lista przypisanych animacji", value = "binds" }
			elements[#elements+1] = { label = "Wspólne animacje", value = "synced" }
		end
	else
		for i=1, #Config['anims'].Animations, 1 do
			elements[#elements+1] = {label = Config['anims'].Animations[i].label, value = Config['anims'].Animations[i].name}
		end
		title = 'Bindy'
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_2") or 'animations', {
		title    = title,
		align    = 'right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			if data.current.value == "bind" then
				OpenAnimationsMenu(false, true)
			elseif data.current.value == "synced" then
				OpenSyncedMenu()
			elseif data.current.value == "binds" then
				OpenBindsMenu()
			elseif data.current.value == "animations" then
				OpenAnimationsMenu(true, false)
			else		
				OpenAnimationsSubMenu(data.current.value, useBinding)			
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenAnimationsSubMenu(menu, binding)
	local elements, title = {}, ""

	for i=1, #Config['anims'].Animations, 1 do
		if Config['anims'].Animations[i].name == menu then
			title = Config['anims'].Animations[i].label
  
			for j=1, #Config['anims'].Animations[i].items, 1 do
				if Config['anims'].Animations[i].items[j].data.e ~= nil and tostring(Config['anims'].Animations[i].items[j].data.e) ~= "" then
					elements[#elements+1] = {
						label = Config['anims'].Animations[i].items[j].label .. ' <span style="color: #20cc02; text-transform: none">'..tostring(Config['anims'].Animations[i].items[j].data.e)..'</span>',
						type  = Config['anims'].Animations[i].items[j].type,
						value = Config['anims'].Animations[i].items[j].data,
						bind = Config['anims'].Animations[i].items[j].data.e
					}
				else
					elements[#elements+1] = {
						label = Config['anims'].Animations[i].items[j].label,
						type  = Config['anims'].Animations[i].items[j].type,
						value = Config['anims'].Animations[i].items[j].data,
						prop = Config['anims'].Animations[i].items[j].prop
					}
				end
			end

			break
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_sub_2") or 'animations_sub', {
		title = title,
		align = 'right',
		elements = elements
	}, function(data, menu)
		if binding then
			ESX.ShowNotification("Za chwilę rozpocznie się nasłuchiwanie klawisza (BACKSPACE/ESC = Anulowanie)", "info")
			Wait(1500)
			isBinding = true
			ESX.ShowNotification("Trwa nasłuchiwanie klawisza...", "info")
			while isBinding do
				if IsControlJustPressed(0, 202) then
					ESX.ShowNotification("Anulowano bindowanie", "info")
					isBinding = false
					break
				end

				for keyName,keyId in pairs(Keys) do
					if IsControlJustPressed(0, keyId) then
						menu.close()
						BindKey(keyName:upper(), data.current.bind)
						isBinding = false				
						return
					end
				end

				Wait(0)
			end
		else
			local animTable = data.current.value
			local animPropTable = data.current.prop
			local animType = data.current.type

			chooseAnim(animTable, animPropTable, animType)
		end
	end, function(data, menu)
		menu.close()
	end)
end

----------- [[
-- Binding
----------- ]]
Bindings = {}

RegisterNUICallback("setBinding", function(data)
	if data.binding then
		for key, anim in pairs(data.binding) do
			local remove = ZC.RegisterButton(key, function()
				playAnim(anim)
			end)

			Bindings[key] = {anim = (type(anim) == "string" and anim or anim.anim), remove = remove}
		end
	end
end)

function OpenBindsMenu()
	local elements = {}
	local bindCount = 0

	for k, v in pairs(Bindings) do
		bindCount += 1
	end

	if bindCount > 0 then
		elements[#elements+1] = {label = "======= Usuń wszystkie =======", value = "ALL"}
		for key, data in pairs(Bindings) do
			elements[#elements+1] = {label = ("%s - /e %s"):format(key, data.anim), value = key}
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_delter', {
			title = 'Aktualne bindy',
			align = 'right',
			elements = elements
		}, function(data, menu)
			menu.close()

			if data.current.value ~= "ALL" then
				ESX.ShowNotification(("Pomyślnie usunięto powiązanie [%s] z /e %s"):format(data.current.value, Bindings[data.current.value]), 'success')

				Bindings[data.current.value].remove()
				Bindings[data.current.value] = nil

				SendNUIMessage({
					action = 'animations',
					key = 'binding',
					data = json.encode(Bindings)
				})

				Wait(200)
				OpenBindsMenu()
			else
				for key, data2 in pairs(Bindings) do
					data2.remove()
				end

				SendNUIMessage({
					action = 'animations',
					key = 'binding',
					data = json.encode(Bindings)
				})

				menu.close()
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('Nie posiadasz przypisanych animacji', 'error')
	end
end

function BindKey(key, anim)
	if not Bindings[key:upper()] then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_check', {
			title = 'Potwierdź przypisanie '..key..' do /e '..anim..'.',
			align = 'right',
			elements = { { label = "Tak", check = true }, { label = "Nie" } }
		}, function(data, menu)
			menu.close()

			if data.current.check then
				local remove = ZC.RegisterButton(key, function()
					playAnim(anim)
				end)

				Bindings[key] = {anim = anim, remove = remove}
				SendNUIMessage({
					action = 'animations',
					key = 'binding',
					data = json.encode(Bindings)
				})
				ESX.ShowNotification(("Pomyślnie powiązano [%s] z /e %s"):format(key:upper(), anim:lower()), "success")
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification("Ten klawisz jest już zajęty", "error")
	end
end

-- SYNCED

function OpenSyncedMenu()
	local elements2 = {}

	for k, v in pairs(Config['anims'].Synced) do
		elements2[#elements2+1] = {label = v['Label'], id = k}
	end
            
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'play_synced',
	{
		title = 'Wspólne animacje',
		align = 'right',
		elements = elements2
	}, function(data2, menu2)
		local allowed = false
		if Config['anims'].Synced[data2.current.id]['Car'] then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				allowed = true
			else
				ESX.ShowNotification('Nie jesteś w pojeździe', 'error')
			end
		else
			allowed = true
		end
		if allowed then
			if timer < GetGameTimer() then
				local player = ESX.UI.ChoosePlayerMenu()
				if player then
					TriggerServerEvent('win:requestSynced', player, data2.current.id)
					timer = GetGameTimer() + 10000
				end
			else
				ESX.ShowNotification('Poczekaj chwilę przed następną propozycją wspólnej animacji', 'error')
			end
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end

RegisterNetEvent('win:syncRequest', function(requester, id)
    local accepted = false

	local elements = {}

	elements[#elements+1] = { label = "Zaakceptuj", value = true }
	elements[#elements+1] = { label = "Odrzuć", value = false }

	CreateThread(function()
		local resetmenu = false
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'synced_animation_request', {
			title = 'Propozycja animacji '..Config['anims'].Synced[id]['Label']..' od '..requester,
			align = 'center',
			elements = {
				{ label = '<span style="color: lightgreen">Zaakceptuj</span>', value = true },
				{ label = '<span style="color: lightcoral">Odrzuć</span>', value = false },
			}
		}, function(data, menu)
			menu.close()
			if data.current.value then
				resetmenu = true
				TriggerServerEvent('win:syncAccepted', requester, id)
			else
				resetmenu = true
				TriggerServerEvent('win:cancelSync', requester)
				ESX.ShowNotification('Odrzuciłeś/aś propozycję wspólnej animacji', 'info')
			end
		end, function(data, menu)
			resetmenu = true
			menu.close()
			TriggerServerEvent('win:cancelSync', requester)
			ESX.ShowNotification('Odrzuciłeś/aś propozycję wspólnej animacji', 'info')
		end)
		Wait(5000)
		if not resetmenu then
			menu.close()
			TriggerServerEvent('win:cancelSync', requester)
			ESX.ShowNotification('Propozycja wspólnej animacji wygasła', 'info')
		end
	end)
end)

RegisterNetEvent('win:playSynced', function(serverid, id, type)
    local anim = Config['anims'].Synced[id][type]

    local target = GetPlayerPed(GetPlayerFromServerId(serverid))
    if anim['Attach'] then
        local attach = anim['Attach']
        AttachEntityToEntity(PlayerPedId(), target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
    end

    Wait(750)

    if anim['Type'] == 'animation' then
		ESX.Streaming.RequestAnimDict(anim['Dict'], function()
			TaskPlayAnim(PlayerPedId(), anim['Dict'], anim['Anim'], 8.0, -8.0, -1, anim['Flags'] or 0, 1, false, false, false)
			RemoveAnimDict(anim['Dict'])
		end)
    end

    if type == 'Requester' then
        anim = Config['anims'].Synced[id]['Accepter']
    else
        anim = Config['anims'].Synced[id]['Requester']
    end

    while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end

    DetachEntity(PlayerPedId())

    while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end

    ClearPedTasks(PlayerPedId())
end)

CreateThread(function()
	for i=1, #Config['anims'].Animations, 1 do
		for j=1, #Config['anims'].Animations[i].items, 1 do
			if Config['anims'].Animations[i].items[j].data.e ~= "" then
				TriggerEvent('chat:addSuggestion', '/e '..Config['anims'].Animations[i].items[j].data.e, Config['anims'].Animations[i].items[j].label)
			end
		end
	end
end)

RegisterCommand('e', function(source, args)
	if not LocalPlayer.state.dead then
		playAnim(args[1])
	end
end)

RegisterCommand('animacje', function()
	if not LocalPlayer.state.dead then
		OpenAnimationsMenu()
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 73) then
			cancelAnim()
		end
	end
end)

RegisterKeyMapping('animacje', 'Otwórz menu animacji', 'keyboard', 'F4')

store.startThread = function()
    CreateThread(function()
        if store.toggle then
            store.lastPosition = GetEntityCoords(store.ped)
            
            while store.toggle do
                local yoff = 0.0
                local hoff = 0.0
                local zoff = 0.0
        
                -- FORWARD / BACKWARD
                if IsControlPressed(0, 32) then
                    yoff = 0.01
                end
        
                if IsControlPressed(0, 33) then
                    yoff = -0.01
                end
        
                -- HEADING
                if IsControlPressed(0, 34) then
                    hoff = 0.2
                end
        
                if IsControlPressed(0, 35) then
                    hoff = -0.2
                end
        
                -- UP / DOWN
                if IsControlPressed(0, 216) then
                    zoff = 0.01
                end
        
                if IsControlPressed(0, 209) then
                    zoff = -0.01
                end
        
                local newHeading = GetEntityHeading(store.ped) + hoff
                local newPos = GetOffsetFromEntityInWorldCoords(store.ped, 0.0, yoff * 0.3, zoff * 0.3)

                if IsControlJustPressed(0, 38) then
					FreezeEntityPosition(store.ped, true)
                    SetEntityCoordsNoOffset(store.ped, newPos.x, newPos.y, newPos.z, false, false, false)
                    SendNUIMessage({
                        type = 'toggle',
                        data = false
                    })
					startAnim(store.currentAnim.lib, store.currentAnim.anim, store.currentAnim.loop)
                    store.toggle = false
                end

                SetEntityHeading(store.ped, newHeading)
                SetEntityCoordsNoOffset(store.ped, newPos.x, newPos.y, newPos.z, true, false, false)
        
                store.nui.heading = store.mathFloor(newHeading)
                store.nui.distance = store.mathFloor(#(store.lastPosition - newPos))
        
                if store.nui.distance >= 2.25 then
                    cancelAnim()
                end
        
                SendNUIMessage({
                    type = 'update',
                    data = store.nui
                })

                Wait(1)
            end
        else
            SetEntityCoords(store.ped, vector3(store.lastPosition.x, store.lastPosition.y, store.lastPosition.z - 0.9))
            store.lastPosition = vector3(0, 0, 0)
			cancelAnim()
        end
    
        FreezeEntityPosition(store.ped, store.toggle)
    end)
end

store.mathFloor = function(v)
    return tonumber(string.format('%.2f', v))
end

store.toggleFunc = function()
    store.toggle = not store.toggle
    store.startThread()
    SendNUIMessage({
        type = 'toggle',
        data = store.toggle
    })
end

RegisterCommand('dostosuj', function()
    store.ped = PlayerPedId()
    if exports['core']:isPedAble(store.ped) then
		if store.currentAnim then
			store.toggleFunc()
		else
			ESX.ShowNotification('Aby to zrobić musisz mieć odpaloną animację')
		end
	end
end)

local function carriedThread()
	while isCarried do
		local ped = PlayerPedId()
		if not IsEntityPlayingAnim(ped, carryTypes[currentCarryType].dictTarget, carryTypes[currentCarryType].animTarget, 3) then
			TaskPlayAnim(ped, carryTypes[currentCarryType].dictTarget, carryTypes[currentCarryType].animTarget, 8.0, -8.0, carryTypes[currentCarryType].length, carryTypes[currentCarryType].controlFlagTarget, 0, false, false, false)
		end
		Wait(0)
	end
end

local function carryThread()
	while isCarrying do
		local ped = PlayerPedId()
		if not IsEntityPlayingAnim(ped, carryTypes[currentCarryType].dict, carryTypes[currentCarryType].anim, 3) then
			TaskPlayAnim(ped, carryTypes[currentCarryType].dict, carryTypes[currentCarryType].anim, 8.0, -8.0, carryTypes[currentCarryType].length, carryTypes[currentCarryType].controlFlag, 0, false, false, false)
		end
		if not IsPedInAnyVehicle(ped, false) then
			local coords = GetEntityCoords(ped)
			ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
			if IsControlJustPressed(0, Keys['L']) then
				TriggerServerEvent('win:cancelSyncedCarry', isCarrying)
				ClearPedTasks(ped)
				isCarrying = false
			end
		end
		Wait(0)
	end
end

local function Carry()
	local elements = {}
	for carryType, v in pairs(carryTypes) do
		elements[#elements+1] = {label = v.label, value = carryType}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'carry_select', {
		title    = 'Wybierz styl noszenia',
		align    = 'right',
		elements = elements
	}, function(data, menu)
		local target = ESX.Game.GetClosestPlayer()
		local sID = GetPlayerServerId(target)
		if sID then
			TriggerServerEvent('win:requestSyncedCarry', sID, data.current.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('win:requestClientSyncedCarry', function(sender, carryType, personType)
	CreateThread(function()
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'request_carry', {
			title = '['..sender..'] chce Cię podnieść',
			align = 'center',
			elements = {
				{label = 'Tak', value = true},
				{label = 'Nie', value = false},
			}
		}, function(data, menu)
			menu.close()
			if data.current.value then
				local sender_ped = GetPlayerPed(GetPlayerFromServerId(sender))
				local playerBag = Player(GetPlayerServerId(sender))
				if playerBag.state.dead or IsPedCuffed(sender_ped) or IsPedBeingStunned(sender_ped) or IsPedDiving(sender_ped) or IsPedFalling(sender_ped) or IsPedJumping(sender_ped) or IsPedRunning(sender_ped) or IsPedSwimming(sender_ped) then
					ESX.ShowNotification('Osoba nie zdołała cię podnieśc', 'error')
					return
				end
				TriggerServerEvent('win:answerSyncedCarry', sender, carryType)
			end
		end)
		Wait(5000)
		menu.close()
	end)
end)

RegisterNetEvent('win:playSyncedCarry', function(target, carryType, personType)
	local playerPed = PlayerPedId()
	if personType == 'sender' then
		ESX.Streaming.RequestAnimDict(carryTypes[carryType].dict, function()
			TaskPlayAnim(playerPed, carryTypes[carryType].dict, carryTypes[carryType].anim, 8.0, -8.0, carryTypes[carryType].length, carryTypes[carryType].controlFlag, 0, false, false, false)
			isCarrying = target
			currentCarryType = carryType
			CreateThread(carryThread)
		end)
	else
		local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
		ESX.Streaming.RequestAnimDict(carryTypes[carryType].dictTarget, function()
			ClearPedTasksImmediately(playerPed)
			local coords = GetEntityCoords(playerPed, true)
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)

			AttachEntityToEntity(playerPed, targetPed, 0, carryTypes[carryType].distanceTarget, carryTypes[carryType].distance, carryTypes[carryType].height, 0.5, 0.5, carryTypes[carryType].spin, false, false, false, false, 2, false)
			TaskPlayAnim(playerPed, carryTypes[carryType].dictTarget, carryTypes[carryType].animTarget, 8.0, -8.0, carryTypes[carryType].length, carryTypes[carryType].controlFlagTarget, 0, false, false, false)
			isCarried = true
			currentCarryType = carryType
			CreateThread(carriedThread)
		end)
	end
end)

RegisterNetEvent('win:cancelClientSyncedCarry', function()
	isCarried = false
	currentCarryType = nil
	ClearPedTasksImmediately(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)