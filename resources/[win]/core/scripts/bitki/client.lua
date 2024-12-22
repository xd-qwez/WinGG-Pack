CreateThread(function()

	while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil do
        Wait(100)
    end

	for k, v in pairs(Config['bitki'].Zones) do
		v.blip = AddBlipForCoord(v.coords)

		SetBlipSprite(v.blip, 668)
		SetBlipColour(v.blip, 1)
		SetBlipAsShortRange(v.blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Bitka')
		EndTextCommandSetBlipName(v.blip)

		SetBlipInfoTitle(v.blip, "Bitka", false)
		if string.find(ESX.PlayerData.job.name, "org") then
			AddBlipInfoIcon(v.blip, "INFO:", "Bitki", 4, 0, true)
		else
			AddBlipInfoIcon(v.blip, "INFO:", "Bitki", 4, 0, false)
		end
		AddBlipInfoHeader(v.blip, "System bitek odseparowanych sesjami", "")
		--AddBlipInfoName(v.blip, "TOP:", "[1] Czesionny, [2] zjeby, [3] omegaZjeby")

		v.blipradius = AddBlipForRadius(v.coords, v.size)
		SetBlipColour(v.blipradius, 1)
		SetBlipAlpha(v.blipradius, 100)
	end
end)

CreateThread(function()

	while ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil do
        Wait(100)
    end

	for k, v in pairs(Config["bitki"].Zones) do
		CM.RegisterPlace(v.coords, {type = 28, size = vector3(v.size, v.size, v.size), dist = v.size * 2}, nil, function()
			if ESX.PlayerData.job then
				if string.find(ESX.PlayerData.job.name, "org") then
					ESX.TriggerServerCallback("orgs:IsSuspended", function(time)
						if not time then
							OpenBitkaMenu(k)
						else
							TriggerEvent('win:showNotification', {
								type = 'error',
								title = 'Bitki',
								text = "Twoja org została zawieszona, do: "..time
							})
						end
					end)
				else
					TriggerEvent('win:showNotification', {
						type = 'error',
						title = 'Bitki',
						text = "Musisz być w organizacji"
					})
				end
			end
		end,
		function()
			ESX.HideUI()
			ESX.UI.Menu.CloseAll()
		end,
		function()
			ESX.TextUI("Naciśnij [E], aby otworzyć menu bitek")
		end)
	end
end)

function OpenBitkaMenu(bitkaPlace)
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Organizacje online", value = "available_orgs"}
	}

	if ESX.PlayerData.job.grade == 1 or ESX.PlayerData.job.grade_permissions["bitki_menager"] then
		elements[#elements + 1] = {label = "Matchmaking", value = "matchmaking"}
		elements[#elements + 1] = {label = "Zaproś na bitke", value = "invite"}
	else
		elements[#elements + 1] = {label = '<span style="color:gray;">Matchmaking</span>'}
		elements[#elements + 1] = {label = '<span style="color:gray;">Zaproś na bitke</span>'}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "BitkiMenu", {
		title    = "Menu Bitki",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value == "available_orgs" then
			menu.close()
			ESX.TriggerServerCallback("bitki:getAvailableOrgs", function(availableOrgs)
				OpenAvailableOrgsMenu(availableOrgs, false, bitkaPlace)
			end)
		elseif data.current.value == "invite" then
			menu.close()
			ESX.TriggerServerCallback("bitki:getAvailableOrgs", function(availableOrgs)
				OpenAvailableOrgsMenu(availableOrgs, true, bitkaPlace)
			end, bitkaPlace)
		elseif data.current.value == "matchmaking" then
			menu.close()
			OpenMatchMakingMenu(bitkaPlace)
		else
			TriggerEvent('win:showNotification', {
				type = 'error',
				title = 'Bitki',
				text = "Nie masz uprawnień, aby tego użyć"
			})
		end

	end, function(data, menu)
		menu.close()
		ESX.UI.Menu.CloseAll()
	end)
end

function OpenMatchMakingMenu(bitkaPlace, elements)
	if not elements then
		elements = {
			{label = "Rankingowa", name = "ranked", value = false},
			{label = "Dodatkowy czas lootowania", name = "looting", value = false},

			{label = "<b>Potwierdź</b>", name = "confirm"}
		}

		for i = 1, #elements do
			if elements[i].name ~= "confirm" then
				elements[i].clearlabel = elements[i].label
				if elements[i].value then
					elements[i].label = elements[i].label..' - <span style="color:green;">Tak</span>'
				else
					elements[i].label = elements[i].label..' - <span style="color:red;">Nie</span>'
				end
			end
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "dsadasdasd", {
		title    = "Ustawienia bitki",
		align    = "center",
		elements = elements
	}, function(data, menu)
		if data.current.name == "confirm" then
			menu.close()

		else
			for i = 1, #elements do
				if data.current.name == elements[i].name then
					menu.close()
					if data.current.value then
						elements[i].label = elements[i].clearlabel..' - <span style="color:red;">Nie</span>'
						elements[i].value = false
					else
						elements[i].label = elements[i].clearlabel..' - <span style="color:green;">Tak</span>'
						elements[i].value = true
					end
					OpenMatchMakingMenu(bitkaPlace, elements)
				end
			end
		end
	end, function(data, menu)
		menu.close()
		OpenBitkaMenu(bitkaPlace)
	end)
end

function OpenAvailableOrgsMenu(availableOrgs, invite, bitkaPlace)
	local elements = {}

	for org, values in pairs(availableOrgs) do
		if values.isBusy then
			if org == ESX.PlayerData.job.name then
				elements[#elements + 1] = {label = values.label.." [Twoja org] [Zajęta]"}
			else
				elements[#elements + 1] = {label = values.label.." [Zajęta]"}
			end
		else
			if org == ESX.PlayerData.job.name then
				elements[#elements + 1] = {label = values.label.." [Twoja org]"}
			else
				elements[#elements + 1] = {label = values.label, value = org}
			end
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "AvailableOrgsMenu", {
		title    = "Dostępne organizacje",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if invite and data.current.value then
			menu.close()
			OpenBitkaSetting(bitkaPlace, data.current.value, data.current.label)
		end

	end, function(data, menu)
		menu.close()
		OpenBitkaMenu(bitkaPlace)
	end)
end

function OpenBitkaSetting(bitkaPlace, org, orgLabel, elements)
	if not elements then
		elements = {
			{label = "Auto pozycje", name = "prespawn", value = true},
			{label = "Rankingowa", name = "ranked", value = false},
			{label = "Czas na lootowanie", name = "looting", value = false},


			{label = "<b>Potwierdź</b>", name = "confirm"}
		}

		for i = 1, #elements do
			if elements[i].name ~= "confirm" then
				elements[i].clearlabel = elements[i].label
				if elements[i].value then
					elements[i].label = elements[i].label..' - <span style="color:green;">Tak</span>'
				else
					elements[i].label = elements[i].label..' - <span style="color:red;">Nie</span>'
				end
			end
		end
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "dsadasdasd", {
		title    = "Ustawienia bitki",
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.name == "confirm" then
			menu.close()
			ESX.TriggerServerCallback("bitki:getAvailableNearOrgsPlayers", function(availableOrgsPlayers, availableMyOrgsPlayers)
				if elements[2].value then
					local count = 0
					local countMy = 0
					for _ in pairs(availableOrgsPlayers) do
						count = count + 1
					end
					for _ in pairs(availableMyOrgsPlayers) do
						countMy = countMy + 1
					end
					if count < 1 then
						TriggerEvent('win:showNotification', {
							type = 'error',
							title = 'Bitki',
							text = "Drużyna przeciwna ma tylko "..count.. " graczy (wymagane 5)"
						})
					elseif countMy < 1 then
						TriggerEvent('win:showNotification', {
							type = 'error',
							title = 'Bitki',
							text = "Twoja drużyna ma tylko "..countMy.. " graczy (wymagane 5)"
						})
					else
						OpenPlayersListConfirmation(availableOrgsPlayers, availableMyOrgsPlayers, bitkaPlace, org, orgLabel, elements)
					end
				else
					OpenPlayersListConfirmation(availableOrgsPlayers, availableMyOrgsPlayers, bitkaPlace, org, orgLabel, elements)
				end
			end, bitkaPlace, org)
		else
			for i = 1, #elements do
				if data.current.name == elements[i].name then
					menu.close()
					if data.current.value then
						elements[i].label = elements[i].clearlabel..' - <span style="color:red;">Nie</span>'
						elements[i].value = false
					else
						elements[i].label = elements[i].clearlabel..' - <span style="color:green;">Tak</span>'
						elements[i].value = true
					end
					OpenBitkaSetting(bitkaPlace, org, orgLabel, elements)
				end
			end
		end

	end, function(data, menu)
		menu.close()
		ESX.TriggerServerCallback("bitki:getAvailableOrgs", function(availableOrgs)
			OpenAvailableOrgsMenu(availableOrgs, true, bitkaPlace)
		end, bitkaPlace)
	end)
end

function OpenPlayersListConfirmation(availableOrgsPlayers, availableMyOrgsPlayers, bitkaPlace, targetOrg, targetOrglabel, settings)
	local elements = {}

	elements[#elements+1] = {label = "<b>Twoja drużyna:</b>"}
	for src, name in pairs(availableMyOrgsPlayers) do
		elements[#elements+1] = {label = name}
	end

	elements[#elements+1] = {label = "<b>Drużyna przeciwna:</b>"}
	for src, name in pairs(availableOrgsPlayers) do
		elements[#elements+1] = {label = name}
	end

	elements[#elements+1] = {label = "<b>Ustawienia:</b>"}
	for _, name in pairs(settings) do
		if name.name ~= "confirm" then
			elements[#elements+1] = {label = name.label}
		end
	end

	elements[#elements+1] = {label = ""}
	elements[#elements+1] = {label = '<span style="color:red;"><b>Potwierdź</b></span>', value = true}

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "PlayersListConfirmation", {
		title    = 'Bitka z: '..targetOrglabel,
		align    = "center",
		elements = elements
	}, function(data, menu)

		if data.current.value then
			menu.close()
			ESX.TriggerServerCallback("bitki:sendInvite", function()
			end, availableOrgsPlayers, availableMyOrgsPlayers, targetOrg, targetOrglabel, bitkaPlace, settings)
		end

	end, function(data, menu)
		menu.close()
		OpenBitkaSetting(bitkaPlace, targetOrg, targetOrglabel, settings)
	end)
end

RegisterNetEvent("bitki:receiveInvite", function(availableMyOrgsPlayers, availableOrgsPlayers, targetOrg, targetOrgLabel, bitkaPlace, settings)
	local isReact = false
	ESX.UI.Menu.CloseAll()
	CreateThread(function ()
		PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 1)
		Wait(60*1000)
		if not isReact then
			ESX.UI.Menu.CloseAll()
		end
	end)

	local elements = {}

	elements[#elements+1] = {label = "<b>Twoja drużyna:</b>"}
	for src, name in pairs(availableMyOrgsPlayers) do
		elements[#elements+1] = {label = name}
	end

	elements[#elements+1] = {label = "<b>Drużyna przeciwna:</b>"}
	for src, name in pairs(availableOrgsPlayers) do
		elements[#elements+1] = {label = name}
	end

	elements[#elements+1] = {label = "<b>Ustawienia:</b>"}
	for _, name in pairs(settings) do
		if  name.name ~= "confirm" then
			elements[#elements+1] = {label = name.label}
		end
	end

	elements[#elements+1] = {label = ""}
	elements[#elements+1] = {label = '<span style="color:red;"><b>Potwierdź</b></span>', isButton = true ,value = true}
	elements[#elements+1] = {label = '<span style="color:red;"><b>Odrzuć</b></span>', isButton = true, value = false}

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "acceptInvite", {
		title    = 'Zaproszenie do bitki od org: '..targetOrgLabel,
		align    = "center",
		elements = elements
	}, function(data, menu)
		isReact = true

		if data.current.isButton then
			menu.close()
			ESX.TriggerServerCallback("bitki:ResponseToInvite", function()
			end, availableMyOrgsPlayers, availableOrgsPlayers, data.current.value, targetOrg, targetOrgLabel, bitkaPlace, settings)
		end

	end, function(data, menu)
		isReact = true
		menu.close()
	end)
end)


local boolKillSphere = false
RegisterNetEvent("bitki:switchSphere", function(bool, bitkaPlace)
	boolKillSphere = bool
	local ped = PlayerPedId()

	if bool then
		ESX.HideUI()
	else
		ESX.TextUI("Naciśnij [E], aby otworzyć menu bitek")
	end

	while boolKillSphere do
		if #(GetEntityCoords(ped) - Config["bitki"].Zones[bitkaPlace].coords) > Config["bitki"].Zones[bitkaPlace].size then
			SetEntityHealth(ped, GetEntityHealth(ped) - 1)
		end
		Wait(100)
	end
end)

RegisterNetEvent("bitki:notify", function(main, desc, time, time2)
	PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 1)
	ESX.Scaleform.ShowFreemodeMessage(main, desc, time)
	if time2 > 0 then
		showProgress({title = 'Czas na lootowanie', time = time2 - (time*1000)}, function()
			PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 1)
			ESX.Scaleform.ShowFreemodeMessage("~r~Koniec bitki!", "", 3)
		end)
	end
end)

RegisterNetEvent("bitki:setHealth", function(health)
	SetEntityHealth(PlayerPedId(), health)
end)

RegisterNetEvent("bitki:preSpawn", function(preCoords)
	DoScreenFadeOut(300)
	Wait(300)

	local entity
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local veh = GetVehiclePedIsIn(PlayerPedId(), false)
		if GetPedInVehicleSeat(veh, -1) == PlayerPedId() then
			entity = veh
		end
	else
		entity = PlayerPedId()
	end

	if entity then
		while true do
			local coords = vector4(preCoords.x + math.random(-15, 15), preCoords.y + math.random(-10, 10), preCoords.z, preCoords.w)
			if ESX.Game.IsSpawnPointClear(coords, 3.0) then
				ESX.Game.Teleport(entity, coords)
				FreezeEntityPosition(entity, true)
				break
			end
			Wait(0)
		end
	end

	PlaySoundFrontend(-1, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset", true)
	Wait(1000)
	DoScreenFadeIn(300)

	for i = 5, 1, -1 do
		ESX.Scaleform.ShowFreemodeMessage('~r~'..i, '', 1)
	end

	PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", true)
	FreezeEntityPosition(entity, false)
	ESX.Scaleform.ShowFreemodeMessage('~r~Bitka Rozpoczęta!', '', 3)
end)


function IsInBitka()
	return boolKillSphere
end
exports("IsInBitka", IsInBitka)


local soundlist = {
	{"10s", "MP_MISSION_COUNTDOWN_SOUNDSET"},
	{"1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET"},
	{"3_2_1", "HUD_MINI_GAME_SOUNDSET"},
	{"3_2_1_NON_RACE", "HUD_MINI_GAME_SOUNDSET"},
	{"5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET"},
	{"5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"5s", "MP_MISSION_COUNTDOWN_SOUNDSET"},
	{"5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset"},
	{"Airhorn", "DLC_TG_Running_Back_Sounds"},
	{"Apt_Style_Purchase", "DLC_APT_Apartment_SoundSet"},

	{"ARM_3_CAR_GLASS_CRASH", "0"},
	{"ARM_3_PISTOL_COCK", "0"},
	{"ARM_WRESTLING_WHOOSH_MASTER", "0"},
	{"Arming_Countdown", "GTAO_Speed_Convoy_Soundset"},
	{"ASSASSINATIONS_HOTEL_TIMER_COUNTDOWN", "ASSASSINATION_MULTI"},
	{"ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"BACK", "HUD_AMMO_SHOP_SOUNDSET"},
	{"BACK", "HUD_FREEMODE_SOUNDSET"},
	{"BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET"},

	{"BACK", "HUD_FRONTEND_MP_SOUNDSET"},
	{"BACK", "HUD_FRONTEND_TATTOO_SHOP_SOUNDSET"},
	{"BACK", "HUD_MINI_GAME_SOUNDSET"},
	{"Banshee2_Upgrade", "JA16_Super_Mod_Garage_Sounds"},
	{"BASE_JUMP_PASSED", "HUD_AWARDS"},
	{"Beast_Checkpoint", "APT_BvS_Soundset"},
	{"Beast_Checkpoint_NPC", "APT_BvS_Soundset"},
	{"Bed", "WastedSounds"},
	{"Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},

	{"Blade_Appear", "APT_BvS_Soundset"},
	{"BOATS_PLANES_HELIS_BOOM", "MP_LOBBY_SOUNDS"},
	{"Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset"},
	{"Boss_Blipped", "GTAO_Magnate_Hunt_Boss_SoundSet"},
	{"Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset"},
	{"Breaker_01", "DLC_HALLOWEEN_FVJ_Sounds"},
	{"Breaker_02", "DLC_HALLOWEEN_FVJ_Sounds"},
	{"BULL_SHARK_TESTOSTERONE_END_MASTER", ""},
	{"BULL_SHARK_TESTOSTERONE_START_MASTER", ""},
	{"Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS"},

	{"CABLE_SNAPS", "CONSTRUCTION_ACCIDENT_1_SOUNDS"},
	{"CAM_PAN_DARTS", "HUD_MINI_GAME_SOUNDSET"},
	{"Camera_Shoot", "Phone_Soundset_Franklin"},
	{"CANCEL", "HUD_FREEMODE_SOUNDSET"},
	{"CANCEL", "HUD_FRONTEND_CLOTHESSHOP_SOUNDSET"},
	{"CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"CANCEL", "HUD_LIQUOR_STORE_SOUNDSET"},
	{"CANCEL", "HUD_MINI_GAME_SOUNDSET"},
	{"CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS"},

	{"CHALLENGE_UNLOCKED", "HUD_AWARDS"},
	{"CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET"},
	{"Checkpoint_Beast_Hit", "FM_Events_Sasquatch_Sounds"},
	{"CHECKPOINT_BEHIND", "HUD_MINI_GAME_SOUNDSET"},
	{"Checkpoint_Cash_Hit", "GTAO_FM_Events_Soundset"},
	{"Checkpoint_Hit", "GTAO_FM_Events_Soundset"},
	{"CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET"},
	{"CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET"},
	{"CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET"},

	{"Checkpoint_Teammate", "GTAO_Shepherd_Sounds"},
	{"CHECKPOINT_UNDER_THE_BRIDGE", "HUD_MINI_GAME_SOUNDSET"},
	{"Cheers", "DLC_TG_Running_Back_Sounds"},
	{"Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE"},
	{"Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE"},
	{"Click_Special", "WEB_NAVIGATION_SOUNDS_PHONE"},
	{"CLOSE_WINDOW", "LESTER1A_SOUNDS"},
	{"CLOSED", "DLC_APT_YACHT_DOOR_SOUNDS"},
	{"CLOSED", "MP_PROPERTIES_ELEVATOR_DOORS"},

	{"COMPUTERS_MOUSE_CLICK", "0"},
	{"CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET"},
	{"CONTINUE", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"CONTINUE", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Continue_Accepted", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Continue_Appears", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Crash", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"Criminal_Damage_High_Value", "GTAO_FM_Events_Soundset"},
	{"Criminal_Damage_Kill_Player", "GTAO_FM_Events_Soundset"},
	{"Criminal_Damage_Low_Value", "GTAO_FM_Events_Soundset"},

	{"CUTSCENE_DIALOGUE_OVERRIDE_SOUND_01", "0"},
	{"CUTSCENE_DIALOGUE_OVERRIDE_SOUND_02", "0"},
	{"Cycle_Item", "DLC_Dmod_Prop_Editor_Sounds"},
	{"DELETE", "HUD_DEATHMATCH_SOUNDSET"},
	{"Delete_Placed_Prop", "DLC_Dmod_Prop_Editor_Sounds"},
	{"Deliver_Pick_Up", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS"},
	{"DiggerRevOneShot", "BulldozerDefault"},
	{"Door_Open", "DOCKS_HEIST_FINALE_2B_SOUNDS"},
	{"Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET"},
	{"Dropped", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS"},

	{"DRUG_TRAFFIC_AIR_BOMB_DROP_ERROR_MASTER", "0"},
	{"DRUG_TRAFFIC_AIR_SCREAMS", "0"},
	{"EDIT", "HUD_DEATHMATCH_SOUNDSET"},
	{"End_Squelch", "CB_RADIO_SFX"},
	{"Enemy_Capture_Start", "GTAO_Magnate_Yacht_Attack_Soundset"},
	{"Enemy_Deliver", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS"},
	{"Enemy_Pick_Up", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS"},
	{"Enter_1st", "GTAO_FM_Events_Soundset"},
	{"Enter_1st", "GTAO_Magnate_Boss_Modes_Soundset"},
	{"Enter_Area", "DLC_Lowrider_Relay_Race_Sounds"},

	{"Enter_Capture_Zone", "DLC_Apartments_Drop_Zone_Sounds"},
	{"ERROR", "HUD_AMMO_SHOP_SOUNDSET"},
	{"ERROR", "HUD_FRONTEND_CLOTHESSHOP_SOUNDSET"},
	{"ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"ERROR", "HUD_FRONTEND_TATTOO_SHOP_SOUNDSET"},
	{"ERROR", "HUD_LIQUOR_STORE_SOUNDSET"},
	{"Event_Message_Purple", "GTAO_FM_Events_Soundset"},
	{"Event_Start_Text", "GTAO_FM_Events_Soundset"},
	{"EXILE_3_TRAIN_BRAKE_PULL_MASTER", "0"},
	{"EXILE_3_TRAIN_BRAKE_RELEASE_MASTER", "0"},

	{"EXIT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Exit_Capture_Zone", "DLC_Apartments_Drop_Zone_Sounds"},
	{"Failure", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"Falling_Crates", "EXILE_1"},
	{"FAMILY_1_CAR_BREAKDOWN", "FAMILY1_BOAT"},
	{"FAMILY_1_CAR_BREAKDOWN_ADDITIONAL", "FAMILY1_BOAT"},
	{"Faster_Bar_Full", "RESPAWN_ONLINE_SOUNDSET"},
	{"Faster_Click", "RESPAWN_ONLINE_SOUNDSET"},
	{"FestiveGift", "Feed_Message_Sounds"},
	{"FIRST_PLACE", "HUD_MINI_GAME_SOUNDSET"},

	{"FLIGHT_SCHOOL_LESSON_PASSED", "HUD_AWARDS"},
	{"FLYING_STREAM_END_INSTANT", "FAMILY_5_SOUNDS"},
	{"FocusIn", "HintCamSounds"},
	{"FocusOut", "HintCamSounds"},
	{"Friend_Deliver", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS"},
	{"Friend_Pick_Up", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS"},
	{"Friend_Pick_Up", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS"},
	{"Frontend_Beast_Fade_Screen", "FM_Events_Sasquatch_Sounds"},
	{"Frontend_Beast_Freeze_Screen", "FM_Events_Sasquatch_Sounds"},
	{"Frontend_Beast_Text_Hit", "FM_Events_Sasquatch_Sounds"},

	{"Frontend_Beast_Transform_Back", "FM_Events_Sasquatch_Sounds"},
	{"GO", "HUD_MINI_GAME_SOUNDSET"},
	{"GO_NON_RACE", "HUD_MINI_GAME_SOUNDSET"},
	{"Goal", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"GOLF_BIRDIE", "HUD_AWARDS"},
	{"GOLF_EAGLE", "HUD_AWARDS"},
	{"GOLF_HUD_HOLE_IN_ONE_MASTER", "0"},
	{"GOLF_HUD_SCORECARD_MASTER", "0"},
	{"GOLF_NEW_RECORD", "HUD_AWARDS"},
	{"Goon_Paid_Small", "GTAO_Boss_Goons_FM_Soundset"},

	{"Grab_Parachute", "BASEJUMPS_SOUNDS"},
	{"Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"},
	{"Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"},
	{"HACKING_CLICK", "0"},
	{"HACKING_CLICK_BAD", "0"},
	{"HACKING_CLICK_GOOD", "0"},
	{"HACKING_FAILURE", "0"},
	{"HACKING_MOVE_CURSOR", "0"},
	{"HACKING_SUCCESS", "0"},
	{"Hang_Up", "Phone_SoundSet_Michael"},

	{"HIGHLIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Highlight_Accept", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Highlight_Cancel", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Highlight_Error", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Highlight_Move", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"HIGHLIGHT_NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Hit", "RESPAWN_ONLINE_SOUNDSET"},
	{"Hit", "RESPAWN_SOUNDSET"},
	{"Hit_1", "LONG_PLAYER_SWITCH_SOUNDS"},
	{"Hit_In", "PLAYER_SWITCH_CUSTOM_SOUNDSET"},

	{"Hit_Out", "PLAYER_SWITCH_CUSTOM_SOUNDSET"},
	{"HOORAY", "BARRY_02_SOUNDSET"},
	{"HORDE_COOL_DOWN_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"HUD_FREEMODE_CANCEL_MASTER", "0"},
	{"Kill_List_Counter", "GTAO_FM_Events_Soundset"},
	{"LAMAR1_PARTYGIRLS_master", "0"},
	{"LEADER_BOARD", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"LEADERBOARD", "HUD_MINI_GAME_SOUNDSET"},
	{"Lester_Laugh_Phone", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"Lights_On", "GTAO_MUGSHOT_ROOM_SOUNDS"},

	{"LIMIT", "DLC_APT_YACHT_DOOR_SOUNDS"},
	{"LIMIT", "GTAO_APT_DOOR_DOWNSTAIRS_GLASS_SOUNDS"},
	{"LIMIT", "GTAO_APT_DOOR_DOWNSTAIRS_WOOD_SOUNDS"},
	{"Load_Scene", "DLC_Dmod_Prop_Editor_Sounds"},
	{"LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"LOCAL_PLYR_CASH_COUNTER_INCREASE	", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"LOOSE_MATCH", "HUD_MINI_GAME_SOUNDSET"},
	{"Lose_1st", "GTAO_FM_Events_Soundset"},
	{"Lose_1st", "GTAO_Magnate_Boss_Modes_Soundset"},
	{"LOSER", "HUD_AWARDS"},

	{"Lowrider_Upgrade", "Lowrider_Super_Mod_Garage_Sounds"},
	{"Map_Roll_Down", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Map_Roll_Up", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"MARKER_ERASE", "HEIST_BULLETIN_BOARD_SOUNDSET"},
	{"MARTIN1_DISTANT_TRAIN_HORNS_MASTER", "0"},
	{"MEDAL_BRONZE", "HUD_AWARDS"},
	{"MEDAL_GOLD", "HUD_AWARDS"},
	{"MEDAL_SILVER", "HUD_AWARDS"},
	{"MEDAL_UP", "HUD_MINI_GAME_SOUNDSET"},
	{"Menu_Accept", "Phone_SoundSet_Default"},

	{"MICHAEL_LONG_SCREAM", "FAMILY_5_SOUNDS"},
	{"MICHAEL_SOFA_REMOTE_CLICK_VOLUME_MASTER", "0"},
	{"MICHAEL_SOFA_TV_CHANGE_CHANNEL_MASTER", "0"},
	{"MICHAEL_SOFA_TV_ON_MASTER", "0"},
	{"Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"MP_5_SECOND_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"MP_AWARD", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"MP_Flash", "WastedSounds"},
	{"MP_IDLE_KICK", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"MP_IDLE_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET"},

	{"MP_Impact", "WastedSounds"},
	{"MP_RANK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"MP_WAVE_COMPLETE", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"NAV", "HUD_AMMO_SHOP_SOUNDSET"},
	{"Nav_Arrow_Ahead", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"Nav_Arrow_Behind", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"Nav_Arrow_Left", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"Nav_Arrow_Right", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"NAV_LEFT_RIGHT", "HUD_FREEMODE_SOUNDSET"},
	{"NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},

	{"NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET"},
	{"NAV_UP_DOWN", "HUD_FRONTEND_CLOTHESSHOP_SOUNDSET"},
	{"NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"NAV_UP_DOWN", "HUD_FRONTEND_TATTOO_SHOP_SOUNDSET"},
	{"NAV_UP_DOWN", "HUD_LIQUOR_STORE_SOUNDSET"},
	{"NAV_UP_DOWN", "HUD_MINI_GAME_SOUNDSET"},
	{"Near_Miss_Counter_Reset", "GTAO_FM_Events_Soundset"},
	{"NET_RACE_START_EVENT_MASTER", "0"},

	{"NO", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Object_Collect_Player", "GTAO_FM_Events_Soundset"},
	{"Object_Collect_Remote", "GTAO_FM_Events_Soundset"},
	{"Object_Dropped_Remote", "GTAO_FM_Events_Soundset"},
	{"Off_High", "MP_RADIO_SFX"},
	{"OK", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"ON", "NOIR_FILTER_SOUNDS"},
	{"On_Call_Player_Join", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"Oneshot_Final", "MP_MISSION_COUNTDOWN_SOUNDSET"},
	{"OOB_Cancel", "GTAO_FM_Events_Soundset"},

	{"OOB_Start", "GTAO_FM_Events_Soundset"},
	{"OPEN_WINDOW", "LESTER1A_SOUNDS"},
	{"OPENED", "MP_PROPERTIES_ELEVATOR_DOORS"},
	{"OTHER_TEXT", "HUD_AWARDS"},
	{"Out_Of_Area", "DLC_Lowrider_Relay_Race_Sounds"},
	{"Out_Of_Bounds_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"Paper_Shuffle", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Parcel_Vehicle_Lost", "GTAO_FM_Events_Soundset"},
	{"Payment_Non_Player", "DLC_HEISTS_GENERIC_SOUNDS"},
	{"Payment_Player", "DLC_HEISTS_GENERIC_SOUNDS"},

	{"Pen_Tick", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"PERSON_SCROLL", "HEIST_BULLETIN_BOARD_SOUNDSET"},
	{"PERSON_SELECT", "HEIST_BULLETIN_BOARD_SOUNDSET"},
	{"Phone_Generic_Key_02", "HUD_MINIGAME_SOUNDSET"},
	{"Phone_Generic_Key_03", "HUD_MINIGAME_SOUNDSET"},
	{"PICK_UP", "HUD_FRONTEND_CUSTOM_SOUNDSET"},
	{"PICK_UP_WEAPON", "HUD_FRONTEND_CUSTOM_SOUNDSET"},
	{"PICK_UP_SOUND", "HUD_FRONTEND_CUSTOM_SOUNDSET"},
	{"PICKUP_WEAPON_SMOKEGRENADE", "HUD_FRONTEND_WEAPONS_PICKUPS_SOUNDSET"},
	{"Pin_Bad", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"},

	{"PIN_BUTTON", "ATM_SOUNDS"},
	{"Pin_Centred", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"},
	{"Pin_Good", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS"},
	{"PIPES_LAND", "CONSTRUCTION_ACCIDENT_1_SOUNDS"},
	{"Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds"},
	{"Place_Prop_Success", "DLC_Dmod_Prop_Editor_Sounds"},
	{"Player_Collect", "DLC_PILOT_MP_HUD_SOUNDS"},
	{"Player_Enter_Line", "GTAO_FM_Cross_The_Line_Soundset"},
	{"Player_Exit_Line", "GTAO_FM_Cross_The_Line_Soundset"},
	{"Power_Down", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},

	{"Pre_Screen_Stinger", "DLC_HEISTS_FAILED_SCREEN_SOUNDS"},
	{"Pre_Screen_Stinger", "DLC_HEISTS_FINALE_SCREEN_SOUNDS"},
	{"Pre_Screen_Stinger", "DLC_HEISTS_PREP_SCREEN_SOUNDS"},
	{"PROPERTY_PURCHASE", "HUD_AWARDS"},
	{"PROPERTY_PURCHASE_MEDIUM", "HUD_PROPERTY_SOUNDSET"},
	{"PS2A_DISTANT_TRAIN_HORNS_MASTER", "0"},
	{"PS2A_MONEY_LOST", "PALETO_SCORE_2A_BANK_SS"},
	{"PURCHASE", "HUD_FRONTEND_TATTOO_SHOP_SOUNDSET"},
	{"PURCHASE", "HUD_LIQUOR_STORE_SOUNDSET"},
	{"PUSH", "DLC_APT_YACHT_DOOR_SOUNDS"},

	{"PUSH", "GTAO_APT_DOOR_DOWNSTAIRS_GLASS_SOUNDS"},
	{"PUSH", "GTAO_APT_DOOR_DOWNSTAIRS_WOOD_SOUNDS"},
	{"Put_Away", "Phone_SoundSet_Michael"},
	{"QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"QUIT_WHOOSH", "HUD_MINI_GAME_SOUNDSET"},
	{"RACE_PLACED", "HUD_AWARDS"},
	{"Radar_Beast_Blip", "FM_Events_Sasquatch_Sounds"},
	{"RAMP_DOWN", "TRUCK_RAMP_DOWN"},
	{"RAMP_UP", "TRUCK_RAMP_DOWN"},
	{"RAMPAGE_KILLED_COUNTER_MASTER", "0"},

	{"RAMPAGE_KILLED_HEAD_SHOT_MASTER", "0"},
	{"RAMPAGE_PASSED_MASTER", "0"},
	{"RAMPAGE_ROAR_MASTER", "0"},
	{"RANK_UP", "HUD_AWARDS"},
	{"REMOTE_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"REMOTE_PLYR_CASH_COUNTER_INCREASE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS"},
	{"Remote_Sniper_Rifle_Fire", "0"},
	{"Reset_Prop_Position", "DLC_Dmod_Prop_Editor_Sounds"},
	{"RESTART", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"RETRY", "HUD_FRONTEND_DEFAULT_SOUNDSET"},

	{"Retune_High", "MP_RADIO_SFX"},
	{"ROBBERY_MONEY_TOTAL", "HUD_FRONTEND_CUSTOM_SOUNDSET"},
	{"ROPE_CUT", "ROPE_CUT_SOUNDSET"},
	{"ROUND_ENDING_STINGER_CUSTOM", "CELEBRATION_SOUNDSET"},
	{"Save_Scene", "DLC_Dmod_Prop_Editor_Sounds"},
	{"SCOPE_UI_MASTER", "0"},
	{"SCREEN_FLASH", "CELEBRATION_SOUNDSET"},
	{"ScreenFlash", "MissionFailedSounds"},
	{"ScreenFlash", "WastedSounds"},
	{"SCREEN_SWIPE", "CELEBRATION_SWIPE"},

	{"SELECT", "HUD_FREEMODE_SOUNDSET"},
	{"SELECT", "HUD_FRONTEND_CLOTHESSHOP_SOUNDSET"},
	{"SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"SELECT", "HUD_FRONTEND_MP_SOUNDSET"},
	{"SELECT", "HUD_FRONTEND_TATTOO_SHOP_SOUNDSET"},
	{"SELECT", "HUD_LIQUOR_STORE_SOUNDSET"},
	{"SELECT", "HUD_MINI_GAME_SOUNDSET"},
	{"Select_Placed_Prop", "DLC_Dmod_Prop_Editor_Sounds"},
	{"Shard_Disappear", "GTAO_Boss_Goons_FM_Shard_Sounds"},
	{"Shard_Disappear", "GTAO_FM_Events_Soundset"},

	{"SHOOTING_RANGE_ROUND_OVER", "HUD_AWARDS"},
	{"Short_Transition_In", "PLAYER_SWITCH_CUSTOM_SOUNDSET"},
	{"Short_Transition_Out", "PLAYER_SWITCH_CUSTOM_SOUNDSET"},
	{"SKIP", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Start", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"Start_Squelch", "CB_RADIO_SFX"},
	{"STUN_COLLECT", "MINUTE_MAN_01_SOUNDSET"},
	{"Success", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"SultanRS_Upgrade", "JA16_Super_Mod_Garage_Sounds"},
	{"Swap_Sides", "DLC_HALLOWEEN_FVJ_Sounds"},

	{"SWING_SHUT", "GTAO_APT_DOOR_DOWNSTAIRS_GLASS_SOUNDS"},
	{"SWING_SHUT", "GTAO_APT_DOOR_DOWNSTAIRS_WOOD_SOUNDS"},
	{"Tattooing_Oneshot", "TATTOOIST_SOUNDS"},
	{"Tattooing_Oneshot_Remove", "TATTOOIST_SOUNDS"},
	{"Team_Capture_Start", "GTAO_Magnate_Yacht_Attack_Soundset"},
	{"TENNIS_MATCH_POINT", "HUD_AWARDS"},
	{"TENNIS_POINT_WON", "HUD_AWARDS"},
	{"TextHit", "WastedSounds"},
	{"Thermal_Off", "CAR_STEAL_2_SOUNDSET"},
	{"Thermal_On", "CAR_STEAL_2_SOUNDSET"},

	{"THERMAL_VISION_GOGGLES_OFF_MASTER", "0"},
	{"THERMAL_VISION_GOGGLES_OFF_MASTER", "0"},
	{"THERMAL_VISION_GOGGLES_ON_MASTER", "0"},
	{"TIME_LAPSE_MASTER", "0"},
	{"TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Timer_10s", "DLC_HALLOWEEN_FVJ_Sounds"},
	{"TIMER_STOP", "HUD_MINI_GAME_SOUNDSET"},
	{"TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Traffic_Control_Fail", "BIG_SCORE_3A_SOUNDS"},

	{"Traffic_Control_Fail_Blank", "BIG_SCORE_3A_SOUNDS"},
	{"Traffic_Control_Light_Switch_Back", "BIG_SCORE_3A_SOUNDS"},
	{"TRAFFIC_CONTROL_MOVE_CROSSHAIR", "BIG_SCORE_3A_SOUNDS"},
	{"Turn", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"UNDER_THE_BRIDGE", "HUD_AWARDS"},
	{"UNDER_WATER_COME_UP", "0"},
	{"UNDO", "HEIST_BULLETIN_BOARD_SOUNDSET"},
	{"WAYPOINT_SET", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"WEAKEN", "CONSTRUCTION_ACCIDENT_1_SOUNDS"},
	{"WEAPON_AMMO_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET"},

	{"WEAPON_ATTACHMENT_EQUIP", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_ARMOR", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_BATON", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_FUEL_CAN", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_GRENADE_LAUNCHER", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_HANDGUN", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_KNIFE", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_OTHER", "HUD_AMMO_SHOP_SOUNDSET"},

	{"WEAPON_SELECT_PARACHUTE", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_RIFLE", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_SELECT_RPG_LAUNCHER", ""},
	{"WEAPON_SELECT_SHOTGUN", "HUD_AMMO_SHOP_SOUNDSET"},
	{"Whistle", "DLC_TG_Running_Back_Sounds"},
	{"Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS"},
	{"Whoosh_1s_R_to_L", "MP_LOBBY_SOUNDS"},
	{"WIN", "HUD_AWARDS"},
	{"WOODEN_DOOR_CLOSED_AT", "0"},
	{"WOODEN_DOOR_CLOSED_AT", "0"},

	{"WOODEN_DOOR_CLOSING_AT", "0"},
	{"WOODEN_DOOR_CLOSING_AT", "0"},
	{"WOODEN_DOOR_OPEN_HANDLE_AT", "0"},
	{"WOODEN_DOOR_OPEN_HANDLE_AT", "0"},
	{"WOODEN_DOOR_OPEN_NO_HANDLE_AT", "0"},
	{"YES", "HUD_FRONTEND_DEFAULT_SOUNDSET"},
	{"Zone_Enemy_Capture", "DLC_Apartments_Drop_Zone_Sounds"},
	{"Zone_Neutral", "DLC_Apartments_Drop_Zone_Sounds"},
	{"Zone_Team_Capture", "DLC_Apartments_Drop_Zone_Sounds"},
	{"Zoom_In", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},

	{"Zoom_Left", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
	{"Zoom_Right", "DLC_HEIST_PLANNING_BOARD_SOUNDS"},
}

RegisterCommand("soundlist", function ()
	local elements = {}

	for i = 1, #soundlist do
		elements[#elements+1] = {label = soundlist[i][1], value = soundlist[i][2]}
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "soundlist", {
		title    = 'Lista dźwięków',
		align    = "center",
		elements = elements
	}, function(data, menu)

		PlaySoundFrontend(-1, data.current.label, data.current.value, 1)

	end, function(data, menu)
		menu.close()
	end)
end, false)