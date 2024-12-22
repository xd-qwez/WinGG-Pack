CreateThread(function()

    RequestModel(`s_m_m_doctor_01`)
	while not HasModelLoaded(`s_m_m_doctor_01`) do
	  Wait(100)
	end

    for k, v in pairs(Config['healer'].Healers) do
        local ped = CreatePed(5, `s_m_m_doctor_01`, v.x, v.y, v.z, v.w, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
    end

end)

for k, v in pairs(Config['healer'].Healers) do
	CM.RegisterPlace(v, {size = vector3(2.0, 2.0, 2.0)}, "skorzystać z pomocy",
	function()
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            if math.random(3) == 1 then
                TriggerServerEvent('InteractSound_SV:PlayOnSource', 'czarnymedyk', 0.2)
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'healer_confirm',
            {
                title = 'Chcesz skorzystać z pomocy?',
                align = 'center',
                elements = {
                    {label = 'Tak', value = true},
                    {label = 'Nie', value = false}
                }
            }, function(data, menu)
                menu.close()
                if data.current.value then
                    TriggerServerEvent('win:useHealer')
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end, function()
        ESX.UI.Menu.CloseAll()
    end)
end