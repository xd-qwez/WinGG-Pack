local perms = {
	{label = "Wkładanie do schowka",  name = "deposit_item",    value = false},
	{label = "Wyciąganie z schowka",  name = "withdraw_item",   value = false},
	{label = "Wkładanie do sejfu", 	  name = "deposit_money",   value = false},
	{label = "Wyciąganie z sejfu", 	  name = "withdraw_money",  value = false},
	{label = "Zarządzanie ubraniami", name = "edit_clothes", 	value = false},
	{label = "Zarządzanie Kitami",	  name = "kits_menager",   value = false},
	{label = "Zarządzanie bitkami",   name = "bitki_menager", 	value = false},
	{label = "Zarządzanie członkami", name = "members_menager", value = false},
	{label = "Zarządzanie rangami",	  name = "ranks_menager",   value = false},

	{label = "<b>Potwierdź</b>", name = "confirm"},
}

local f6menus = {}

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	ESX.PlayerData.job = job
	f6menus = {}
	ESX.TriggerServerCallback("orgs:GetUpgrades", function(upgrades)
		f6menus = upgrades
	end)
end)

RegisterNetEvent("orgs:NewUpdates", function(upgrades)
	f6menus = upgrades
end)

CreateThread(function()

	while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil do
        Wait(100)
    end

	ESX.TriggerServerCallback("orgs:GetUpgrades", function(upgrades)
		f6menus = upgrades
	end)

	for k, v in pairs(Config["orgs"].Zones) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite(blip, 565)
		SetBlipColour(blip, 78)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Organizacja')
		EndTextCommandSetBlipName(blip)

		SetBlipInfoTitle(blip, "Organizacja przestępcza", false)
		if string.find(ESX.PlayerData.job.name, "org") then
			AddBlipInfoIcon(blip, "INFO:", "Organizacje", 4, 0, true)
			SetBlipInfoEconomy(blip, "", "")
		else
			AddBlipInfoIcon(blip, "INFO:", "Organizacje", 4, 0, false)
			SetBlipInfoEconomy(blip, "", "1.25M")
		end
		AddBlipInfoHeader(blip, "DAJE DOSTĘP DO:", "Strefy, Bitki")

		CM.RegisterPlace(v, {size = vector3(5.0, 5.0, 0.3)}, "otworzyć menu organizacji",
		function()
			if ESX.PlayerData.job then
				if string.find(ESX.PlayerData.job.name, "org") then
					ESX.TriggerServerCallback("orgs:IsSuspended", function(time)
						if not time then
							OpenOrgMenu()
						else
							TriggerEvent('win:showNotification', {
								type = 'error',
								title = 'Organizacje',
								text = "Twoja org została zawieszona, do: "..time
							})
						end
					end)
				elseif string.find(ESX.PlayerData.job.name, "police") then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Wypierdalaj psiaku, nie dla ciebie to"
					})
				else
					OpenBuyOrgMenu()
				end
			end
		end,
		function()
			ESX.UI.Menu.CloseAll()
		end,
		function()

		end)
	end
end)

local ListOfProps = {}

AddEventHandler("onClientResourceStop", function (resourceName)
	if GetCurrentResourceName() == resourceName then
		for i = 1, #ListOfProps do
			DeleteObject(ListOfProps[i])
		end
	end
end)

CreateThread(function()
	RequestModel(`s_m_y_blackops_01`)
	while not HasModelLoaded(`s_m_y_blackops_01`) do
		Wait(100)
	end

	RequestModel(`s_m_y_armymech_01`)
	while not HasModelLoaded(`s_m_y_armymech_01`) do
		Wait(100)
	end

	for k, v in pairs(Config["orgs"].Zones) do

		local coords1 = GetObjectOffsetFromCoords(v.x, v.y, v.z, v.w, 1.6, -0.8, 0.0)
		local coords2 = GetObjectOffsetFromCoords(v.x, v.y, v.z, v.w, -1.6, -0.8, 0.0)
		local coords3 = GetObjectOffsetFromCoords(v.x, v.y, v.z, v.w, 0.0, -1.2, 0.0)
		local coords4 = GetObjectOffsetFromCoords(v.x, v.y, v.z, v.w, -0.3, -1.4, 1.5)
		local coords5 = GetObjectOffsetFromCoords(v.x, v.y, v.z, v.w, 0.5, -1.2, 1.5)

		local ped = CreatePed(5, `s_m_y_blackops_01`, coords1.x, coords1.y, coords1.z, v.w + 30.0, false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
		SetPedCanRagdollFromPlayerImpact(ped, false)
		GiveWeaponToPed(ped, `weapon_compactrifle`, 1, false, true)
		SetCurrentPedWeapon(ped, `weapon_compactrifle`, true)


		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GUARD_STAND", 0, false)

		local ped2 = CreatePed(5, `s_m_y_armymech_01`, coords2.x, coords2.y, coords2.z, v.w - 30.0, false, true)
		FreezeEntityPosition(ped2, true)
		SetEntityInvincible(ped2, true)
		SetBlockingOfNonTemporaryEvents(ped2, true)
		SetPedCanRagdollFromPlayerImpact(ped2, false)
		GiveWeaponToPed(ped2, `weapon_heavysniper_mk2`, 1, false, true)
		SetCurrentPedWeapon(ped2, `weapon_heavysniper_mk2`, true)


		ESX.Streaming.RequestAnimDict("amb@world_human_stand_guard@male@base", function()
			TaskPlayAnim(ped, "amb@world_human_stand_guard@male@base", "base", 8.0, -8.0, -1, 51, 1, false, false, false)
			RemoveAnimDict("amb@world_human_stand_guard@male@base")
		end)

		ESX.Game.SpawnObject(`p_secret_weapon_02`, coords3, function(obj)
			SetEntityHeading(obj, v.w)
			FreezeEntityPosition(obj, true)
            ListOfProps[#ListOfProps] = obj
		end, false)

		ESX.Game.SpawnObject(`prop_box_ammo03a`, coords4, function(obj)
			SetEntityHeading(obj, v.w - 35.0)
			FreezeEntityPosition(obj, true)
            ListOfProps[#ListOfProps] = obj
		end, false)

		ESX.Game.SpawnObject(`prop_box_ammo07b`, coords5, function(obj)
			SetEntityHeading(obj, v.w - 180.0)
			FreezeEntityPosition(obj, true)
            ListOfProps[#ListOfProps] = obj
		end, false)
		SetModelAsNoLongerNeeded(`s_m_y_blackops_01`)
		SetModelAsNoLongerNeeded(`s_m_y_armymech_01`)
	end
end)

function OpenBuyOrgMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "BuyOrgMenu", {
		title    = "Menu organizacji",
		align    = "center",
		elements = {{label = "Kup organizacje za (1.25M$)", value = "buy"}}
	}, function(data, menu)
		if data.current.value == "buy" then
			menu.close()

			ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "BuyOrgMenu2", {
				title = "Nazwa twojej organizacji"
			}, function(data2, menu2)

				menu2.close()
				if data2.value then
					if string.len(data2.value) > 15 then
						TriggerEvent('win:showNotification', {
							type = 'error',
							title = 'Organizacje',
							text = "Nazwa ogranizacji musi mieć do 15 znaków"
						})
					elseif string.len(data2.value) < 4 then
						TriggerEvent('win:showNotification', {
							type = 'error',
							title = 'Organizacje',
							text = "Nazwa ogranizacji musi mieć co najmniej 4 znaki"
						})
					else
						ESX.TriggerServerCallback("orgs:BuyOrg", function(bool)
							if bool then
								TriggerEvent('win:showNotification', {
									type = 'success',
									title = 'Organizacje',
									text = "Pomyślnie zakupiono organizacje"
								})
								menu.close()
							else
								TriggerEvent('win:showNotification', {
									type = 'error',
									title = 'Organizacje',
									text = "Nie posiadasz wystarczająco dużo pieniędzy"
								})
							end
						end, data2.value)
					end
				else
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Nie podałeś nazwy organizacji"
					})
				end


			end, function(data2, menu2)
				menu2.close()
			end)

		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenOrgMenu()
	local elements = {}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_item"] or ESX.PlayerData.job.grade_permissions["deposit_item"] then
		elements[#elements+1] = {label = "Schowek", value = "stashboard"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Schowek</span>'}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_money"] or ESX.PlayerData.job.grade_permissions["deposit_money"] then
		elements[#elements+1] = {label = "Konto", value = "bank"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Konto</span>'}
	end

	elements[#elements+1] = {label = "Przebieralnia", value = "cloakroom"}
	elements[#elements + 1] = {label = "Menu Szefa", value = "bossmenu"}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgMenu", {
		title    = "Menu organizacji",
		align    = "center",
		elements = elements
	}, function(data, menu)


		if data.current.value == "stashboard" then
			menu.close()
			OpenStashBoard()
		elseif data.current.value == "cloakroom" then
			menu.close()
			OpenCloakroomMenu()
		elseif data.current.value == "bank" then
			menu.close()
			ESX.TriggerServerCallback("orgs:getAccount", function(orgMoney_, playerMoney_)
				OpenAccountMenu(orgMoney_, playerMoney_)
			end)
		elseif data.current.value == "bossmenu" then
			menu.close()
			OpenBossMenu()
		else
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Organizacje',
				text = "Nie masz uprawnień, aby tego użyć"
			})
		end

	end, function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	end)
end

function OpenBossMenu()
	local elements = {}

	if ESX.PlayerData.job.grade == 1 then
		elements[#elements+1] = {label = "Ulepszenia", value = "upgrades"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Ulepszenia</span>'}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["ranks_menager"] then
		elements[#elements+1] = {label = "Rangi", value = "grades"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Rangi</span>'}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "Członkowie", value = "members"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Członkowie</span>'}
	end

	if ESX.PlayerData.job.grade == 1 then
		elements[#elements+1] = {label = "Logi", value = "webhooks"}
		elements[#elements+1] = {label = '<span style="color:red;">Usuń organizacje</span>', value = "remove"}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Logi</span>'}
		elements[#elements+1] = {label = '<span style="color:red;">Opuść organizacje</span>', value = "leave"}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgBossMenu", {
		title    = "Menu szefa organizacji",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value == "upgrades" then
			menu.close()
			ESX.TriggerServerCallback("orgs:GetUpgrades", function(upgrades)
				OpenUpgradesMenu(upgrades)
			end)
		elseif data.current.value == "grades" then
			menu.close()
			ESX.TriggerServerCallback("orgs:GetGrades", function(grades)
				OpenGradesMenu(grades)
			end)
		elseif data.current.value == "members" then
			menu.close()
			ESX.TriggerServerCallback("orgs:GetMembers", function(members)
				OpenMembersMenu(members)
			end)
		elseif data.current.value == "webhooks" then
			menu.close()
			ESX.TriggerServerCallback("orgs:GetWebhooks", function(webHooks)
				OpenWebhooksMenu(webHooks)
			end)
		elseif data.current.value == "remove" then
			menu.close()
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Orgremove", {
				title    = "Czy napewno chcesz usunąć org?",
				align    = "center",
				elements = {
					{label = "Nie", value = false},
                	{label = "Tak", value = true},
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback("orgs:RemoveOrg", function()
					end)
				else
					OpenBossMenu()
				end
			end, function(data2, menu2)
				menu2.close()
				OpenBossMenu()
			end)
		elseif data.current.value == "leave" then
			ESX.TriggerServerCallback("orgs:LeaveOrg", function(bool)
				if bool then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('win:showNotification', {
						type = 'success',
						title = 'Organizacje',
						text = "Pomyślnie opuszczono organizacje"
					})
				else
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Coś poszło grubo nie tak"
					})
				end
			end)
		else
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Organizacje',
				text = "Nie masz uprawnień, aby tego użyć"
			})
		end

	end, function(data, menu)
		menu.close()
		OpenOrgMenu()
	end)
end

function OpenUpgradesMenu(upgrades)
	local elements = {}
	for upgrade, bool in pairs(upgrades) do
		if bool then
			elements[#elements+1] = {label = '<span style="color:gray;">'..Config['orgs'].upgrades[upgrade].label.. '</span>'}
		else
			elements[#elements+1] = {label = Config['orgs'].upgrades[upgrade].label..' (na '..ESX.Math.Round(Config['orgs'].upgrades[upgrade].time/86400)..' dni) - <span style="color:gray;">$'..Config['orgs'].upgrades[upgrade].price..'</span>', value = upgrade}
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgUpgrades", {
		title    = "Menu ulepszeń",
		align    = "center",
		elements = elements
	}, function(data, menu)
		if data.current.value then
			ESX.TriggerServerCallback("orgs:BuyUpgrade", function(upgrades_)
				if upgrades_ then
					menu.close()
					OpenUpgradesMenu(upgrades_)
				else
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Twoja organizacja nie posiada wystarczająco pieniędzy"
					})
				end
			end, data.current.value)
		end
	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenCloakroomMenu()
	local elements = {
		{label = 'Prywatne ubrania', value = 'player_wear'},
		{label = 'Zapisane stroje', value = 'saved_wear'}
	}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["edit_clothes"] then
		elements[#elements+1] = {label = 'Zapisz strój', value = 'save_wear'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Zapisz strój</span>'}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom_menu', {
		title    = 'Przebieralnia',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'player_wear' then
			PlayerDressings()
		elseif data.current.value == 'save_wear' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'save_wear_name', {
				title = 'Nazwa stroju'
			}, function(data2, menu2)
				menu2.close()

				TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('win-dressings:saveSharedOutfit', data2.value, skin, ESX.PlayerData.job.name)
					TriggerEvent('win:showNotification', {
						type = 'success',
						title = 'Organizacje',
						text = "Pomyślnie zapisano ubiór o nazwie: " .. data2.value
					})
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'saved_wear' then
			ESX.TriggerServerCallback('win-dressings:getSharedDressing', function(dressing)
				local clothesElements = {}
				for i=1, #dressing, 1 do
				  table.insert(clothesElements, {label = dressing[i], value = i})
				end
				local secondClothesElements = {}
				if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["edit_clothes"] then
					table.insert(secondClothesElements, {label = 'Ubierz strój', value = 'wear'})
					table.insert(secondClothesElements, {label = 'Usuń strój', value = 'delete_wear'})
				end
				if #clothesElements > 0 then
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'saved_wear_menu', {
					title    = 'Zapisane stroje',
					align    = 'center',
					elements = clothesElements
					}, function(data2, menu2)
						if #secondClothesElements > 0 then
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'saved_wear_menu_choose', {
								title    = 'Wybierz opcje',
								align    = 'center',
								elements = secondClothesElements
							}, function(data3, menu3)
								if data3.current.value == 'wear' then
									TriggerEvent('skinchanger:getSkin', function(skin)
										ESX.TriggerServerCallback('win-dressings:getSharedOutfit', function(clothes)
											TriggerEvent('skinchanger:loadClothes', skin, clothes)
											TriggerEvent('esx_skin:setLastSkin', skin)
											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_skin:save', skin)
											end)
											TriggerEvent('win:showNotification', {
												type = 'success',
												title = 'Organizacje',
												text = "Pomyślnie zmieniono strój"
											})
											ClearPedBloodDamage(PlayerPedId())
										end, data2.current.value, ESX.PlayerData.job.name)
									end)
								elseif data3.current.value == 'delete_wear' then
									TriggerServerEvent('win-dressings:removeSharedOutfit', data2.current.value, ESX.PlayerData.job.name)
									TriggerEvent('win:showNotification', {
										type = 'success',
										title = 'Organizacje',
										text = "Pomyślnie usunięto strój o nazwie: " .. data2.current.label
									})
									menu3.close()
									menu2.close()
								end
							end, function(data3, menu3)
								menu3.close()
							end)
						else
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('win-dressings:getSharedOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
									TriggerEvent('win:showNotification', {
										type = 'success',
										title = 'Organizacje',
										text = "Pomyślnie zmieniono strój"
									})
									ClearPedBloodDamage(PlayerPedId())
								end, data2.current.value, ESX.PlayerData.job.name)
							end)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				else
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Brak zapisanych strojów"
					})
				end
			end, ESX.PlayerData.job.name)
		end
	end, function(data, menu)
		menu.close()
		OpenOrgMenu()
	end)
end

--===================================================== Grades ============================================================--

function OpenGradesMenu(elements)

	if #elements < 10 then
		elements[#elements + 1] = {label = "<b>Dodaj rangę</b>", addNew = true}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgGradesMenu", {
		title    = "Menu Rang",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.addNew then
			local name = DynamicInputMenu("Podaj nazwę rangi")
			if name then
				OpenNewGradePermissionsMenu(name, nil)
			else
				ESX.TriggerServerCallback("orgs:GetGrades", function(grades)
					OpenGradesMenu(grades)
				end)
			end
		else
			OpenSpecifiedGradeMenu(data.current)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function DynamicInputMenu(title)
	local result = nil
	ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "OrgMenu", {
		title = title
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback("orgs:GetGrades", function(grades)
			local used = false
			for i = 1, #grades do
				if grades[i].name == data.value then
					used = true
				end
			end
			if data.value then
				if string.len(data.value) > 15 then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Nazwa rangi musi mieć do 15 znaków"
					})
					result = false
				elseif string.len(data.value) < 4 then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Nazwa rangi musi mieć co najmniej 4 znaki"
					})
					result = false
				elseif used then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Nazwa jest już zajęta"
					})
					result = false
				else
					result = data.value
				end
			else
				result = false
			end
		end)

	end, function(data, menu)
		menu.close()
		result = false
	end)

	while result == nil do
        Wait(0)
    end

    return result
end

function OpenNewGradePermissionsMenu(name, elements)

	if not elements then
		elements = json.decode(json.encode(perms))

		for i = 1, #elements do
			if elements[i].name ~= "confirm" then
				elements[i].clearlabel = elements[i].label
				elements[i].label = elements[i].label..' - <span style="color:red;">Nie</span>'
			end
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgNewGradePermissionsMenu", {
		title    = "Uprawnienia rangi",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.name == "confirm" then
			local permissions = {}
			for i = 1, #elements do
				if elements[i].value then
					permissions[elements[i].name] = true
				end
			end

			local newGrade = {name = name, permissions = permissions, salary = 0}
			ESX.TriggerServerCallback("orgs:AddNewGrade", function(grades)
				OpenGradesMenu(grades)
			end, newGrade)
		else
			for i = 1, #elements do
				if data.current.name == elements[i].name then
					if data.current.value then
						elements[i].label = elements[i].clearlabel..' - <span style="color:red;">Nie</span>'
						elements[i].value = false
					else
						elements[i].label = elements[i].clearlabel..' - <span style="color:green;">Tak</span>'
						elements[i].value = true
					end
					OpenNewGradePermissionsMenu(name, elements)
				end
			end
		end


	end, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("orgs:GetGrades", function(grades)
			OpenGradesMenu(grades)
		end)
	end)
end

function OpenSpecifiedGradeMenu(grade)
	local elements = {
		{label = "Zmień nazwę", value = "name"},
	}

	if grade.id and grade.id > 1 then
		elements[#elements+1] = {label = "Zmień uprawnienia", value = "perms"}
		elements[#elements+1] = {label = "Posiadacze rangi", value = "members"}
		elements[#elements+1] = {label = '<span style="color:red;"><b>Usuń</b></span>', value = "remove"}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgSpecifiedGradeMenu", {
		title    = grade.label,
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == "members" then

			ESX.TriggerServerCallback("orgs:GetMembers", function(members)
				OpenMembersMenu(members, grade)
			end, grade.id)

		elseif data.current.value == "name" then

			local name = DynamicInputMenu("Podaj nową nazwę rangi")
			if name then
				ESX.TriggerServerCallback("orgs:ChangeGradeName", function(grades)
					TriggerEvent('win:showNotification', {
						type = 'success',
						title = 'Organizacje',
						text = "Pomyślnie zapisano zmiany"
					})
					OpenSpecifiedGradeMenu(grade.id)
				end, grade.id, name)
			else
				OpenSpecifiedGradeMenu(grade)
			end

		elseif data.current.value == "perms" then

			OpenSpecifiedGradePermsMenu(grade, nil)

		elseif data.current.value == "remove" then
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Organizacje',
				text = "Wyrzuci to wszystkie osoby posiadające tą range",
				duration = 10000
			})
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgtruefalseMenu", {
				title    = 'Czy na pewno chcesz usunąć: "'..grade.label..'"',
				align    = "center",
				elements = {
					{label = "Nie", value = false},
                	{label = "Tak", value = true},
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback("orgs:RemoveGrade", function(grades)
						OpenGradesMenu(grades)
					end, grade.id)
				else
					OpenSpecifiedGradeMenu(grade)
				end
			end, function(data2, menu2)
				menu2.close()
				OpenSpecifiedGradeMenu(grade)
			end)

		end

	end, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("orgs:GetGrades", function(grades)
			OpenGradesMenu(grades)
		end)
	end)
end

function OpenSpecifiedGradePermsMenu(grade, elements)

	if not elements then
		elements = json.decode(json.encode(perms))

		for i = 1, #elements do
			if elements[i].name ~= "confirm" then
				elements[i].clearlabel = elements[i].label
				for perm, bool in pairs(grade.permissions) do
					if elements[i].name == perm then
						elements[i].value = true
					end
				end
				if elements[i].value then
					elements[i].label = elements[i].label..' - <span style="color:green;">Tak</span>'
				else
					elements[i].label = elements[i].label..' - <span style="color:red;">Nie</span>'
				end
			end
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgSpecifiedGradePermsMenu", {
		title    = 'Uprawnienia: "'..grade.label..'"',
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.name == "confirm" then
			local permissions = {}
			for i = 1, #elements do
				if elements[i].value then
					permissions[elements[i].name] = true
				end
			end

			local updateGrade = {name = grade.label, permissions = permissions, salary = 0, id = grade.id}
			ESX.TriggerServerCallback("orgs:UpdateGrade", function(grades)
				TriggerEvent('win:showNotification', {
					type = 'success',
					title = 'Organizacje',
					text = "Pomyślnie zapisano zmiany",
				})
				OpenSpecifiedGradeMenu(grades[grade.id])
			end, updateGrade)
		else
			for i = 1, #elements do
				if data.current.name == elements[i].name then
					if data.current.value then
						elements[i].label = elements[i].clearlabel..' - <span style="color:red;">Nie</span>'
						elements[i].value = false
					else
						elements[i].label = elements[i].clearlabel..' - <span style="color:green;">Tak</span>'
						elements[i].value = true
					end
					OpenSpecifiedGradePermsMenu(grade, elements)
				end
			end
		end

	end, function(data, menu)
		menu.close()
		OpenSpecifiedGradeMenu(grade)
	end)
end

--================================================================================= Members ==================================================================================--

function OpenMembersMenu(members, grade)
	local elements = {}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["members_menager"] then
		elements[#elements+1] = {label = "<b>Dodaj członka</b>", addNew = true}
	else
		elements[#elements+1] = {label = '<span style="color:gray;"><b>Dodaj członka</b></span>', noPerm = true}
	end

	local gradesQuantity = 1

	for identifier, xPlayer in pairs(members) do
		if xPlayer.job.grade > gradesQuantity then
			gradesQuantity = xPlayer.job.grade
		end
	end

	for i = 1, gradesQuantity do
		for identifier, xPlayer in pairs(members) do
			if xPlayer.online and xPlayer.job.grade == i then
				if grade then
					elements[#elements+1] = {label = xPlayer.name, value = xPlayer}
				else
					elements[#elements+1] = {label = xPlayer.name.." ["..xPlayer.job.grade_name.."]", value = xPlayer}
				end
			end
		end
	end

	for i = 1, gradesQuantity do
		for identifier, xPlayer in pairs(members) do
			if not xPlayer.online and xPlayer.job.grade == i then
				if grade then
					elements[#elements+1] = {label = '<span style="color:gray;">'..xPlayer.name..'</span>', value = xPlayer}
				else
					elements[#elements+1] = {label = '<span style="color:gray;">'..xPlayer.name..'</span>'.." ["..xPlayer.job.grade_name.."]", value = xPlayer}
				end
			end
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgMembersMenu", {
		title    = grade and "Lista członków ["..grade.label.."]" or "Lista członków",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.addNew then
			if grade then
				ESX.TriggerServerCallback("orgs:GetNearPlayers", function(nearPlayers)
					OpenSelectPlayerToIviteMenu(nearPlayers, grade)
				end)
			else
				ESX.TriggerServerCallback("orgs:GetGrades", function(grades)
					OpenSelectGradeToIviteMenu(grades)
				end)
			end
		elseif data.current.noPerm then
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Organizacje',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		else
			OpenSpecifiedMemberMenu(data.current.value)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenSelectGradeToIviteMenu(elements)
	for i = 1, #elements do
		if  elements[i].id <= ESX.PlayerData.job.grade then
			elements[i].label = '<span style="color:gray;">'..elements[i].label..'</span>'
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgSelectGradeToIviteMenu", {
		title    = "Wybierz rangę",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.id > ESX.PlayerData.job.grade then
			menu.close()
			ESX.TriggerServerCallback("orgs:GetNearPlayers", function(nearPlayers)
				OpenSelectPlayerToIviteMenu(nearPlayers, data.current)
			end)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenSelectPlayerToIviteMenu(nearPlayers, grade)
	local elements = {}

	for src, name in pairs(nearPlayers) do
		elements[#elements+1] = {label = name.." ["..src.."]", value = src}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgSelectPlayerToIviteMenu", {
		title    = "Wybierz gracza",
		align    = "center",
		elements = elements
	}, function(data, menu)
		menu.close()

		TriggerServerEvent("orgs:server:AskToJoin", data.current.value, grade)

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

RegisterNetEvent("orgs:client:AskToJoin", function(senderId, jobName, grade)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Orgtruefalse2Menu", {
		title    = 'Czy chcesz dołączyć do: "'..jobName..'"?',
		align    = "center",
		elements = {
			{label = "Tak", value = true},
			{label = "Nie", value = false},
		}
	}, function(data, menu)
		menu.close()
		if data.current.value then
			TriggerEvent('win:showNotification', {
				type = 'info',
				title = 'Organizacje',
				text = 'Dołączono do "'..jobName..'" na stanowisko "'..grade.label..'"',
			})
		end
		TriggerServerEvent("orgs:server:ResponseToJoin", senderId, grade, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end)

function OpenSpecifiedMemberMenu(xPlayer)
	local elements = {
		{label = xPlayer.online and '<span style="color:green;">Online</span>' or '<span style="color:red;">Offline</span>'},
	}

	if xPlayer.job.grade > ESX.PlayerData.job.grade then
		elements[#elements+1] = {label = 'Zmień range', value = "changeMemberGrade"}
		elements[#elements+1] = {label = '<span style="color:red;"><b>Wyrzuć</b></span>', value = "kickMember"}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgSpecifiedMemberMenu", {
		title    = xPlayer.name,
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value == "changeMemberGrade" then
			menu.close()
			ESX.TriggerServerCallback("orgs:GetGrades", function(grades)
				OpenChangeMemberGradeMenu(xPlayer, grades)
			end)
		elseif data.current.value == "kickMember" then
			menu.close()

			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Orgtruefalse3Menu", {
				title    = 'Czy na pewno chcesz wyrzucić: "'..xPlayer.name..'"',
				align    = "center",
				elements = {
					{label = "Nie", value = false},
                	{label = "Tak", value = true},
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value then
					ESX.TriggerServerCallback("orgs:KickMember", function()
						TriggerEvent('win:showNotification', {
							type = 'success',
							title = 'Organizacje',
							text = 'Pomyślnie Wyrzucono: '..xPlayer.name..'"',
						})
						OpenBossMenu()
					end, xPlayer)
				else
					OpenSpecifiedMemberMenu(xPlayer)
				end
			end, function(data2, menu2)
				menu2.close()
				OpenSpecifiedMemberMenu(xPlayer)
			end)
		end

	end, function(data, menu)
		menu.close()
		OpenBossMenu()
	end)
end

function OpenChangeMemberGradeMenu(xPlayer, elements)
	for i = 1, #elements do
		if xPlayer.job.grade == elements[i].id or elements[i].id <= ESX.PlayerData.job.grade then
			elements[i].label = '<span style="color:gray;">'..elements[i].label..'</span>'
			elements[i].disable = true
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "OrgChangeMemberGradeMenu", {
		title    = "Wybierz rangę",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if not data.current.disable then
			menu.close()
			ESX.TriggerServerCallback("orgs:ChangeMemberRank", function(newxPlayer)
				OpenSpecifiedMemberMenu(newxPlayer)
			end, data.current, xPlayer)
		end

	end, function(data, menu)
		menu.close()
		OpenSpecifiedMemberMenu(xPlayer)
	end)
end

--===================================================== webhooks ===========================================================--

function OpenWebhooksMenu(webhooks)
	local elements = {
		{label = 'Logi schowka', value = 'stashboard'},
		{label = 'Logi sejfu', value = 'bank'},
		{label = 'Logi kitów', value = 'kits'}
	}

	for i = 1, #elements do
		if webhooks[elements[i].value] then
			elements[i].label = "Zmień "..elements[i].label
		else
			elements[i].label = "Ustaw "..elements[i].label
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'OrgWebhooksMenu', {
		title    = 'Logi',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "OrgMenu", {
			title = "Wklej discord webhooka"
		}, function(data2, menu2)

			menu2.close()
			if data2.value then
				if string.len(data2.value) > 256 then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Misiu coś... coś kurwa za długi ten link",
					})
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'listwa', 0.4)
					OpenWebhooksMenu(webhooks)
				elseif string.len(data2.value) < 100 then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Misiu coś... coś kurwa za krótki ten link",
					})
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'ta-napewno-mordo', 1.0)
					OpenWebhooksMenu(webhooks)
				elseif string.find(data2.value, "https://discord.com/api/webhooks/") == 1 or string.find(data2.value, "https://canary.discordapp.com/api/webhooks/") == 1 or string.find(data2.value, "https://discordapp.com/api/webhooks/") == 1 then
					ESX.TriggerServerCallback("orgs:AddWebhook", function(webHooks)
						OpenWebhooksMenu(webHooks)
					end, data.current.value, data2.value)
				else
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "O stary ale żeś kake odpierdolił",
					})
					TriggerServerEvent('InteractSound_SV:PlayOnSource', 'kurwa-co-za-debil-jebany', 1.0)
					OpenWebhooksMenu(webhooks)
				end
			else
				TriggerEvent('win:showNotification', {
					type = 'error',
					title = 'Organizacje',
					text = "Nie podałeś Webhooka",
				})
				TriggerServerEvent('InteractSound_SV:PlayOnSource', 'dobra-nie-wnikam', 1.0)
				OpenWebhooksMenu(webhooks)
			end

		end, function(data2, menu2)
			menu2.close()
			ESX.TriggerServerCallback("orgs:GetWebhooks", function(webHooks)
				OpenWebhooksMenu(webHooks)
			end)
		end)

	end, function(data, menu)
		OpenBossMenu()
	end)
end

--===================================================== Schowek ===========================================================--

function OpenStashBoard()
	local elements = {}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["deposit_item"] then
		elements[#elements+1] = {label = 'Schowaj przedmiot', value = 'put_stock'}
		elements[#elements+1] = {label = 'Schowaj wszystko', value = 'put_all_in_stock'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Schowaj przedmiot</span>'}
		elements[#elements+1] = {label = '<span style="color:gray;">Schowaj wszystko</span>'}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_item"] then
		elements[#elements+1] = {label = 'Wyciągnij przedmiot', value = 'get_stock'}
		elements[#elements+1] = {label = 'Zestawy', value = 'kits'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Wyciągnij przedmiot</span>'}
		elements[#elements+1] = {label = '<span style="color:gray;">Zestawy</span>'}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'OrgStashBoardMenu', {
		title    = 'Schowek',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			menu.close()
			ESX.TriggerServerCallback('orgs:getPlayerInventory', function(inventory)
				OpenPutStocksMenu(inventory)
			end)
		elseif data.current.value == 'put_all_in_stock' then
			menu.close()
			ESX.TriggerServerCallback('orgs:putAllInStock', function()
				OpenOrgMenu()
			end)
		elseif data.current.value == 'get_stock' then
			menu.close()
			ESX.TriggerServerCallback('orgs:getStockItems', function(items)
				OpenGetStocksMenu(items)
			end)
		elseif data.current.value == 'kits' then
			menu.close()
			OpenKitsMenu()
		else
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Organizacje',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		end
	end, function(data, menu)
		menu.close()
		OpenOrgMenu()
	end)
end

function OpenPutStocksMenu(inventory)
	local elements = {}

	for i = 1, #inventory do
		local item = inventory[i]

		if item.count > 0 then
			elements[#elements+1] = {
				label = item.label .. ' x' .. item.count,
				type = 'item_standard',
				value = item.name
			}
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'OrgPutStocksMenu', {
		title    = "Ekwipunek",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
			title = "Ilość"
		}, function(data2, menu2)
			if not tonumber(data2.value) then
				TriggerEvent('win:showNotification', {
					type = 'error',
					title = 'Organizacje',
					text = "Nieprawidłowa wartość",
				})
			else
				menu2.close()
				ESX.TriggerServerCallback('orgs:putStockItems', function(inventory_)
					OpenPutStocksMenu(inventory_)
				end, data.current.value, tonumber(data2.value))
			end
		end, function(data2, menu2)
			menu2.close()
			OpenPutStocksMenu(inventory)
		end)
	end, function(data, menu)
		menu.close()
		OpenStashBoard()
	end)
end

function OpenGetStocksMenu(items)
	local elements = {}

	for i = 1, #items do
		local item = items[i]

		if item.count > 0 then
			elements[#elements+1] = {
				label = item.label .. ' x' .. item.count,
				value = item.name
			}
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'OrgGetStocksMenu', {
		title    = "Schowek",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
			title = "Ilość"
		}, function(data2, menu2)
			if not tonumber(data2.value) then
				TriggerEvent('win:showNotification', {
					type = 'error',
					title = 'Organizacje',
					text = "Nieprawidłowa wartość",
				})
			else
				menu2.close()
				ESX.TriggerServerCallback('orgs:getStockItem', function(data3)
					OpenGetStocksMenu(data3)
				end, data.current.value, tonumber(data2.value))
			end
		end, function(data2, menu2)
			menu2.close()
			OpenGetStocksMenu(items)
		end)
	end, function(data, menu)
		menu.close()
		OpenStashBoard()
	end)
end

--===================================================== Konto ===========================================================--

function OpenAccountMenu(orgMoney, playerMoney)
	local elements = {
		{label = '<span style="color:gray;">Sejf org: '..orgMoney..'</span>'},
		{label = '<span style="color:gray;">Twoja gotówka: '..playerMoney..'</span>'},
	}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["deposit_money"] then
		elements[#elements+1] = {label = 'Schowaj gotówkę', value = 'put_money'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Schowaj gotówkę</span>', value = "no_perm"}
	end

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["withdraw_money"] then
		elements[#elements+1] = {label = 'Wyciągnij gotówkę', value = 'get_money'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Wyciągnij gotówkę</span>', value = "no_perm"}
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'OrgStashBoardMenu', {
		title    = 'Sejf',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_money' then
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menu_put_money_count', {
				title = "Ilość"
			}, function(data2, menu2)
				if not tonumber(data2.value) then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Nieprawidłowa wartość",
					})
				else
					menu2.close()
					ESX.TriggerServerCallback('orgs:putMoney', function(orgMoney_, playerMoney_)
						OpenAccountMenu(orgMoney_, playerMoney_)
					end, math.ceil(tonumber(data2.value)))
				end
			end, function(data2, menu2)
				menu2.close()
				OpenAccountMenu(orgMoney, playerMoney)
			end)
		elseif data.current.value == 'get_money' then
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'menu_get_money_count', {
				title = "Ilość"
			}, function(data2, menu2)

				if not tonumber(data2.value) then
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Organizacje',
						text = "Nieprawidłowa wartość",
					})
				else
					menu2.close()
					ESX.TriggerServerCallback('orgs:getMoney', function(orgMoney_, playerMoney_)
						OpenAccountMenu(orgMoney_, playerMoney_)
					end, math.ceil(tonumber(data2.value)))
				end
			end, function(data2, menu2)
				menu2.close()
				OpenAccountMenu(orgMoney, playerMoney)
			end)
		elseif data.current.value == 'no_perm' then
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Organizacje',
				text = "Nie masz uprawnień, aby tego użyć",
			})
		end
	end, function(data, menu)
		menu.close()
		OpenOrgMenu()
	end)
end

-- KITS

function OpenKitsMenu()
    local elements = {}

	elements[#elements+1] = {label = 'Zestawy', value = 'kits'}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["kits_menager"] then
		elements[#elements+1] = {label = 'Stwórz zestaw (twój ekwipunek)', value = 'createkit'}
	else
		elements[#elements+1] = {label = '<span style="color:gray;">Stwórz zestaw </span>'}
	end

	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_kits', {
        title    = 'Zestawy',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'createkit' then
			menu.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'organisations_kits_name', {
                title = 'Nazwa zestawu'
            }, function(data2, menu2)
                ESX.TriggerServerCallback('orgs:CreateKit', function(bool, data3)
					menu2.close()
					if bool then
						OpenKitsSubMenu(data3)
					else
						OpenKitsMenu()
					end
				end, data2.value)
            end, function(data2, menu2)
				menu2.close()
                OpenKitsMenu()
            end)
        elseif data.current.value == 'kits' then
			ESX.TriggerServerCallback('orgs:GetKits', function(data2)
				menu.close()
				OpenKitsSubMenu(data2)
			end)
        end
    end, function(data, menu)
        menu.close()
        OpenStashBoard()
    end)
end

function OpenKitsSubMenu(kits)
	local elements = {}

    for i = 1, #kits do
		elements[#elements+1] = {label = kits[i].label, iteration = i}
	end

	ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_saved_kits', {
        title    = 'Zestawy',
        align    = 'center',
        elements = elements
    }, function(data, menu)
		menu.close()
		OpenSpecifiedKitsMenu(data.current)
    end, function(data, menu)
        menu.close()
        OpenKitsMenu()
    end)
end

function OpenSpecifiedKitsMenu(currentKit)
	local options = {
		{label = 'Wybierz zestaw', value = 'choose'},
	}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["kits_menager"] then
		options[#options+1] = {label = 'Daj zestaw', value = 'give'}
		options[#options+1] = {label = '<span style="color:red;"><b>Usuń zestaw</b></span>', value = 'delete'}
	else
		options[#options+1] = {label = '<span style="color:gray;">Daj zestaw</span>'}
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_saved_kits2', {
		title    = 'Zestaw: '..currentKit.label,
		align    = 'center',
		elements = options
	}, function(data, menu)

		if data.current.value == 'choose' then
			ESX.TriggerServerCallback('orgs:EquipKit', function()
				ESX.UI.Menu.CloseAll()
			end, currentKit.iteration)
		elseif data.current.value == 'delete' then
			ESX.TriggerServerCallback('orgs:DeleteKit', function(data2)
				menu.close()
				OpenKitsSubMenu(data2)
			end, currentKit.iteration)
		elseif data.current.value == 'give' then
			local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
			local serverIds = {}

			for i = 1, #players, 1 do
				if players[i] ~= PlayerId() then
					serverIds[#serverIds+1] = {label = 'ID: '..GetPlayerServerId(players[i]), value = GetPlayerServerId(players[i])}
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_givekit', {
				title    = 'Wybierz gracza',
				align    = 'center',
				elements = serverIds
			}, function(data2, menu2)
				menu2.close()
				ESX.TriggerServerCallback('orgs:EquipKit', function()
				end, currentKit.iteration, data2.current.value)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		ESX.TriggerServerCallback('orgs:GetKits', function(data2)
			menu.close()
			OpenKitsSubMenu(data2)
		end)
	end)
end

ESX.RegisterInput("orgs:quickactions", "Menu organizacji", "keyboard", "F6", function()
	if ESX.PlayerData.job and (not string.find(ESX.PlayerData.job.name, "org") or LocalPlayer.state.dead or IsPedCuffed(PlayerPedId())) then
        return
    end

	local elements = {}
	for name, values in pairs(Config['orgs'].upgrades) do
		if values.f6menu then
			if f6menus[name] then
				if name == "handcuffs" then
					table.insert(elements, 1, {label = values.label, value = name})
				else
					elements[#elements+1] = {label = values.label, value = name}
				end
			else
				elements[#elements+1] = {label = '<span style="color:gray;">'..values.label..'</span>'}
			end
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'org_f6', {
		title    = 'Menu organizacji',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'handcuffs' then
			exports['esx_policejob']:OpenHandcuffsMenu()
		elseif data.current.value == 'repairkit' then
			TriggerEvent('win:onRepairKit', true)
		else
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Organizacje',
				text = "Twoja organizacja nie wykupiła dostępu do tej akcji",
			})
		end
	end, function(data, menu)
		menu.close()
	end)
end)