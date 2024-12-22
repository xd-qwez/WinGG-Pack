Config = {}

Config['healer'] = {}
Config['healer'].HealerPrice = 10000
Config['healer'].Healers = {
    vector4(2528.05, 2588.88, 36.94, 277.613), -- DINO
    vector4(599.09, 2744.43, 41.05, 180.80), -- PET SHOP
    vector4(1017.8762, -2511.6604, 27.4595, 91.1212), -- DOKI
    vector4(1724.5941, 3323.9028, 40.3235, 224.3635), -- HANGAR LOTNIA
    vector4(4992.9702, -5192.1602, 1.5078, 29.7473), -- CAYO
}

Config['shops'] = {}
Config['shops'].coords = {
    vector4(2545.09, 2579.17, 36.94, 66.93), -- DINO
    vector4(605.75, 2745.42, 41.01, 180.62), -- PET SHOP
    vector4(1003.2303, -2529.2117, 27.4542, 357.9215), -- DOKI
    vector4(5003.5684, -5190.3857, 1.5162, 308.5041), -- CAYO
}

Config['shops'].shopItems = {
    {
        label = 'Redbull',
        item = 'energydrink',
        price = 2500
    },
    {
        label = 'Krótkofalówka',
        item = 'radiocrime',
        price = 10000
    },
    {
        label = 'Magazynek do pistoletu',
        item = 'pistol_ammo_box',
        price = 12500
    },
    {
        label = 'Zestaw naprawczy',
        item = 'repairkit',
        price = 15000
    },
    {
        label = 'Kajdanki',
        item = 'handcuffs',
        price = 20000
    },
    {
        label = 'Laptop do hackowania',
        item = 'rob_laptop',
        price = 50000
    },
    {
        label = 'Łom do napadu',
        item = 'rob_lifeinvader',
        price = 60000
    },
    {
        label = 'Pistolet SNS',
        item = 'snspistol',
        price = 70000
    },
    {
        label = 'Pistolet',
        item = 'pistol',
        price = 100000
    },
    {
        label = 'Pistolet (MK II)',
        item = 'pistol_mk2',
        price = 140000
    },
    {
        label = 'Pistolet SNS (MK II)',
        item = 'snspistol_mk2',
        price = 250000
    },
    {
        label = 'Pistolet Vintage',
        item = 'vintagepistol',
        price = 250000
    },
    {
        label = 'Pistolet Ceramiczny',
        item = 'ceramicpistol',
        price = 280000
    },
    {
        label = 'Pistolet Heavy',
        item = 'heavypistol',
        price = 1000000
    },
}

Config['clotheshop'] = {
    Price = 1000,
    Shops = {
        vector3(75.3675, -1398.3821, 29.3785-0.95),
        vector3(-710.3318, -161.6475, 37.4153-0.95),
        vector3(-156.4907, -297.4386, 39.7334-0.95),
        vector3(425.2813, -800.7861, 29.4935-0.95),
        vector3(-827.0078, -1075.9574, 11.3304-0.95),
        vector3(-1458.8124, -239.7576, 49.8013-0.95),
        vector3(9.0692, 6515.7617, 31.8801-0.95),
        vector3(124.3844, -219.1595, 54.5577-0.95),
        vector3(1693.7871, 4828.1216, 42.0655-0.95),
        vector3(617.4639, 2759.2559, 42.0883-0.95),
        vector3(1191.4226, 2710.5498, 38.2250-0.95),
        vector3(-1194.4746, -772.3811, 17.3235-0.95),
        vector3(-3171.5891, 1048.3875, 20.8634-0.95),
        vector3(-1105.3882, 2707.1033, 19.1102-0.95)
    }
}

Config['barbershop'] = {
    Price = 500,
    Shops = {
        vector3(-814.2688, -183.7940, 37.5741-0.95),
        vector3(136.7658, -1708.3912, 29.2919-0.95),
        vector3(-1281.9149, -1117.4049, 6.9904-0.95),
        vector3(1931.4818, 3731.4314, 32.8446-0.95),
        vector3(1213.3481, -473.4205, 66.2082-0.95),
        vector3(-33.7514, -153.5050, 57.0768-0.95),
        vector3(-277.8112, 6227.0718, 31.6958-0.95)
    }
}

Config['greenzone'] = {}
Config['greenzone'].Zones = {
    {
        coords = vector3(-266.21, -961.94, 30.32), -- GREENZONE START
        size = 20.0,
        addBlip = false,
    },
    {
        label = 'Greenzone - Elektrownia',
        coords = vector3(2537.35, 2605.02, 37.94), -- GREENZONE DINO
        size = 35.0,
        addBlip = true,
    },
    {
        label = 'Greenzone - Doki',
        coords = vector3(1008.0433, -2521.7927, 28.3076), -- GREENZONE DOKI
        size = 50.0,
        addBlip = true,
    },
    {
        label = 'Greenzone - Cayo Perico',
        coords = vector3(5013.3374, -5184.7832, 2.5188), -- GREENZONE CAYO
        size = 30.0,
        addBlip = true,
    },
    {
        coords = vector3(-109.33, 1910.48, 196.2), -- ZBIORKA MARIHU
        size = 20.0,
        addBlip = false,
    },
    {
        coords = vector3(2224.36, 5576.92, 52.95), -- PRZERÓBKA MARIHU
        size = 20.0,
        addBlip = false,
    },
}

Config['greenzone'].Teleports = {
    vector3(-266.25, -968.0, 30.32), -- START
    vector3(562.39, 2741.03, 41.91), -- PET SHOP
    vector3(1009.77, -2504.47, 27.4), -- DOKI
    vector3(2529.09, 2616.87, 37.04), -- DINO
    vector3(5002.6128, -5177.0649, 1.6082), -- CAYO
}

Config['deposit'] = {}
Config['deposit'].Zones = {
    vector4(2530.19, 2576.74, 36.94, 288.79), -- DINO
    vector4(591.08, 2744.14, 41.04, 183.31), -- PET SHOP
    vector4(1024.9854, -2507.2388, 27.4560, 356.2845), -- DOKI
    vector4(5006.4878, -5196.5220, 1.5148, 310.3901), -- CAYO
}

Config['orgs'] = {}
Config['orgs'] = {
    Zones = {
        vector4(559.84, 2728.03, 41.05, 277.0), -- GREENZONE PET SHOP
        vector4(2521.62, 2624.51, 36.99, 297.6),  -- GREENZONE DINO
        vector4(1016.2828, -2520.5361, 27.3031, 135.7672), -- GREENZONE DOKI
        vector4(1735.8542, 3322.6624, 40.3235, 142.2794), -- HANGAR LOTNIA
        vector4(5013.4150, -5200.5005, 1.5173, 338.5336), -- GREENZONE CAYO
    },
    upgrades = {
        handcuffs = {label = 'Kajdanki', price = 2000000, f6menu = true, time = 7*24*60*60},
        repairkit = {label = 'Naprawka', price = 800000, f6menu = true, time = 7*24*60*60},
    },
}

Config['bitki'] = {}
Config['bitki'].Zones = {
    {coords = vector3(1388.49, 3130.32, 40.72), size = 360.0, spawn = {vector4(1703.2285, 3250.4104, 39.8492, 105.4690), vector4(1062.8557, 3079.3967, 40.0469, 286.2292)}}, -- lotnisko sandy
    {coords = vector3(166.68, 3099.69, 41.55), size = 350.0, spawn = {vector4(402.5220, 3176.8823, 51.6745, 114.0551), vector4(59.0284, 2957.3337, 52.8305, 318.0521)}}, -- domki 77 
}

Config['strefy'] = {}
Config['strefy'].Zones = {
    {name = "Lotnisko Grapeseed", coords = vector3(2134.29, 4784.87, 39.95), size = 10.0, hours = {17, 20, 23, 2}},
    {name = "Wiatraki", coords = vector3(2300.58, 1969.98, 130.12), size = 10.0, hours = {16, 19, 22, 1}},
    {name = "Tartak", coords = vector3(-572.04, 5341.61, 69.32), size = 10.0, hours = {18, 21, 0, 3}},
    {name = "Losty", coords = vector3(53.3, 3708.43, 38.86), size = 10.0, hours = {16, 19, 22, 1}},
    {name = "Mini Losty", coords = vector3(2329.85, 2557.35, 45.77), size = 10.0, hours = {17, 20, 23, 2}},
    {name = "Kościół", coords = vector3(-299.61, 2802.09, 58.26), size = 10.0, hours = {18, 21, 0, 3}},
}

Config['weaponcomponents'] = {}
Config['weaponcomponents'].componentsList = {
    suppressor = {
        [`WEAPON_PISTOL`] = `COMPONENT_AT_PI_SUPP_02`,
        [`WEAPON_PISTOL_MK2`] = `COMPONENT_AT_PI_SUPP_02`,
        [`WEAPON_COMBATPISTOL`] = `COMPONENT_AT_PI_SUPP`,
        [`WEAPON_SNSPISTOL_MK2`] = `COMPONENT_AT_PI_SUPP_02`,
        [`WEAPON_HEAVYPISTOL`] = `COMPONENT_AT_PI_SUPP`,
        [`WEAPON_VINTAGEPISTOL`] = `COMPONENT_AT_PI_SUPP`,
        [`WEAPON_CERAMICPISTOL`] = `COMPONENT_CERAMICPISTOL_SUPP`,
    },
    suppressor2 = {
        [`WEAPON_MICROSMG`] = `COMPONENT_AT_AR_SUPP_02`,
        [`WEAPON_SMG_MK2`] = `COMPONENT_AT_PI_SUPP`,
    },
    extendedclip = {
        [`WEAPON_SNSPISTOL`] = `COMPONENT_SNSPISTOL_CLIP_02`,
        [`WEAPON_SNSPISTOL_MK2`] = `COMPONENT_SNSPISTOL_MK2_CLIP_02`,
        [`WEAPON_VINTAGEPISTOL`] = `COMPONENT_VINTAGEPISTOL_CLIP_02`,
        [`WEAPON_PISTOL`] = `COMPONENT_PISTOL_CLIP_02`,
        [`WEAPON_PISTOL_MK2`] = `COMPONENT_PISTOL_MK2_CLIP_02`,
        [`WEAPON_COMBATPISTOL`] = `COMPONENT_COMBATPISTOL_CLIP_02`,
        [`WEAPON_HEAVYPISTOL`] = `COMPONENT_HEAVYPISTOL_CLIP_02`,
        [`WEAPON_CERAMICPISTOL`] = `COMPONENT_CERAMICPISTOL_CLIP_02`,
    },
    extendedclip2 = {
        [`WEAPON_MINISMG`] = `COMPONENT_MINISMG_CLIP_02`,
        [`WEAPON_MICROSMG`] = `COMPONENT_MICROSMG_CLIP_02`,
        [`WEAPON_SMG_MK2`] = `COMPONENT_SMG_MK2_CLIP_02`,
    },
    flashlight = {
        [`WEAPON_SNSPISTOL_MK2`] = `COMPONENT_AT_PI_FLSH_03`,
        [`WEAPON_PISTOL`] = `COMPONENT_AT_PI_FLSH`,
        [`WEAPON_PISTOL_MK2`] = `COMPONENT_AT_PI_FLSH_02`,
        [`WEAPON_COMBATPISTOL`] = `COMPONENT_AT_PI_FLSH`,
        [`WEAPON_HEAVYPISTOL`] = `COMPONENT_AT_PI_FLSH`,
    },
    scope = {
        [`WEAPON_MICROSMG`] = `COMPONENT_AT_SCOPE_MACRO`,
        [`WEAPON_SMG_MK2`] = `COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2`,
    },
    scope2 = {
        [`WEAPON_SMG_MK2`] = `COMPONENT_AT_SCOPE_SMALL_SMG_MK2`,
    },
}

Config['drugs'] = {
    weed = {
        field = {
            coords = vector3(-109.33, 1910.48, 196.2),
            title = 'Marihuana',
            text = 'zebrać marihuane',
            item = 'weed',
            blip = {
                sprite = 469,
                colour = 2,
                scale = 0.8,
            }
        },
        process = {
            coords = vector3(2224.36, 5576.92, 52.95),
            title = 'Marihuana',
            text = 'przerobić marihuane',
            item = 'weed_pooch',
            blip = {
                sprite = 469,
                colour = 2,
                scale = 0.8,
            }
        }
    },
    coke = {
        field = {
            coords = vector3(-336.14, -2437.95, 5.1),
            title = 'Kokaina',
            text = 'zebrać kokaine',
            item = 'coke',
            blip = {
                sprite = 514,
                scale = 0.8,
            }
        },
        process = {
            coords = vector3(1500.5876, -2133.5471, 75.3660),
            title = 'Kokaina',
            text = 'przerobić kokaine',
            item = 'coke_pooch',
            blip = {
                sprite = 514,
                scale = 0.8,
            }
        }
    },
    meth = {
        field = {
            coords = vector3(4863.3613, -4627.9639, 13.8607),
            title = 'Metamfetamina',
            text = 'zebrać metamfetamine',
            item = 'meth',
            blip = {
                sprite = 499,
                colour = 47,
                scale = 0.8,
            }
        },
        process = {
            coords = vector3(4900.7778, -5344.7666, 9.2469),
            title = 'Metamfetamina',
            text = 'przerobić metamfetamine',
            item = 'meth_pooch',
            blip = {
                sprite = 499,
                colour = 47,
                scale = 0.8,
            }
        }
    },
    fentanyl = {
        field = {
            coords = vector3(1905.0831, 4924.1582, 47.9915),
            title = 'Fentanyl',
            text = 'zebrać fentanyl',
            item = 'fentanyl',
            blip = {
                sprite = 51,
                colour = 26,
                scale = 0.8,
            }
        },
        process = {
            coords = vector3(3316.1228, 5190.6221, 17.5153),
            title = 'Fentanyl',
            text = 'przerobić fentanyl',
            item = 'fentanyl_pooch',
            blip = {
                sprite = 51,
                colour = 26,
                scale = 0.8,
            }
        }
    },
    heroin = {
        field = {
            coords = vector3(1552.3999, 2234.7886, 76.5477),
            title = 'Heroina',
            text = 'zebrać heroine',
            item = 'heroin',
            blip = {
                sprite = 497,
                colour = 35,
                scale = 0.8,
            }
        },
        process = {
            coords = vector3(2435.87, 4966.84, 41.45),
            title = 'Heroina',
            text = 'przerobić heroine',
            item = 'heroin_pooch',
            blip = {
                sprite = 497,
                colour = 35,
                scale = 0.8,
            }
        }
    },
}

Config['licenses'] = {
    ['seu_pd'] = 'Licencja SEU',
    ['heli_pd'] = 'Licencja ASU',
    ['mr_pd'] = 'Licencja Motocykle',
    ['cs_pd'] = 'Licencja Zarząd',
    ['hwp_pd'] = 'Licencja HWP',
    ['cttf_pd'] = 'Licencja C.T.T.F'
}

Config['selldrugs'] = {
    requiredCops = 2,
    drugs = {
        ['weed_pooch'] = 325,
        ['coke_pooch'] = 425,
        ['meth_pooch'] = 500,
        ['fentanyl_pooch'] = 375,
        ['heroin_pooch'] = 450,
    },
    cityPoint = vector3(0.0, -500.0, 100.0),
    notify = {
        title = 'Narkotyki',
        nodrugs = 'Nie posiadasz żadnych narkotyków do sprzedania',
        cops = 'Zbyt mało policjantów',
        reject = 'Sprzedajesz gówno!',
        sold = 'Sprzedano %sx %s za %s$',
        police_notify_title = 'Zgłoszenie',
        police_notify_subtitle = 'Sprzedaż narkotyków',
        too_far_from_city = 'Znajdujesz się zbyt daleko od miasta',
    },
}

Config['announcements'] = {
    Messages = {
        'Pamiętaj, że możesz odbierać /kit start co 6 godzin',
        'Skrzynki możesz otwierać za pomocą /skrzynki',
        'Zapraszamy na nasz sklep: indrop.gg/s/wingg',
        'Użyj /top, aby sprawdzić aktualne topki',
        'Pamiętaj, aby zapoznać się z regulaminem serwera'
    }
}

Config['battleroyale'] = {
    coords = vector3(5184.1519, -5118.0093, 3.5304),
    cutZoneSize = 1500.0,
}

Config['bw-system'] = {
    Timer = 30 * 1000
}

Config['anims'] = {
    Animations = {
        {
            name = 'Wyrazy twarzy',
            label = 'Wyrazy twarzy',
            items = {
                {label = "Neutralny", type = "faceExpression", data = {anim = "mood_Normal_1", e = "neutralny"}},
                {label = "Szczęśliwy", type = "faceExpression", data = {anim = "mood_Happy_1", e = "szczesliwy"}},
                {label = "Zły", type = "faceExpression", data = {anim = "mood_Angry_1", e = "zly"}},		
                {label = "Podejrzliwy", type = "faceExpression", data = {anim = "mood_Aiming_1", e = "podejrzliwy"}},
                {label = "Ból", type = "faceExpression", data = {anim = "mood_Injured_1", e = "bol"}},
                {label = "Zdenerwowany", type = "faceExpression", data = {anim = "mood_stressed_1", e = "zdenerwowany"}},
                {label = "Zadowolony", type = "faceExpression", data = {anim = "mood_smug_1", e = "zadowolony"}},
                {label = "Podpity", type = "faceExpression", data = {anim = "mood_drunk_1", e = "podpity"}},
                {label = "Zszokowany", type = "faceExpression", data = {anim = "shocked_1", e = "zszokowany"}},
                {label = "Zamknięte oczy", type = "faceExpression", data = {anim = "mood_sleeping_1", e = "oczy"}},
                {label = "Przeżuwanie", type = "faceExpression", data = {anim = "eating_1", e = "zucie"}},
            }
        },
    
        {
            name = 'Przywitania',
            label = 'Przywitania',
            items = {
                {label = "Machanie ręką", type = "anim", data = {lib = "random@hitch_lift", anim = "come_here_idle_c", loop = 51, e = "machanie"}},
                {label = "Machanie ręką 2", type = "anim", data = {lib = "friends@fra@ig_1", anim = "over_here_idle_a", loop = 51, e = "machanie2"}},
                {label = "Machnięcie ręką 3", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello", loop = 50, e = "machanie3"}},
                {label = "Machnięcie ręką 4", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_a", loop = 50, e = "machanie4"}},
                {label = "Machnięcie rękoma", type = "anim", data = {lib = "random@mugging5", anim = "001445_01_gangintimidation_1_female_idle_b", loop = 50, e = "machanie5"}},
                {label = "Machnięcie rękoma 2", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_b", loop = 50, e = "machanie6"}},
                {label = "Machnięcie rękoma 3", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_d", loop = 50, e = "machanie7"}},
                {label = "Żółwik", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high", loop = 50, e = "zolwik"}},
                {label = "Graba", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a", loop = 1, e = "graba"}},
                {label = "Piąteczka", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "high_five_c_player_b", loop = 50, e = "piateczka"}},            
            }
        },
        
        {
            name = 'Reakcje',
            label = 'Reakcje',
            items = {
                 {label = "Facepalm 1", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm", loop = 56, e = "facepalm"}},      
                 {label = "Facepalm 2", type = "anim", data = {lib = "anim@mp_player_intupperface_palm", anim = "enter", loop = 50, e = "facepalm2"}},   
                {label = "Nie wierze", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@face_palm", anim = "face_palm", loop = 56, e = "niewierze"}},
                {label = "Złapanie się za głowę", type = "anim", data = {lib = "mini@dartsoutro", anim = "darts_outro_01_guy2", loop = 56, e = "zaglowe"}},			
                {label = "Tak", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_pleased", loop = 57, e = "tak"}},
                {label = "Nie", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_head_no", loop = 57, e = "nie"}},
                {label = "Nie 2", type = "anim", data = {lib = "anim@heists@ornate_bank@chat_manager", anim = "fail", loop = 57, e = "nie2"}},
                 {label = "Nie ma mowy", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_no_way", loop = 56, e = "niemamowy"}},
                {label = "Wzruszenie ramionami", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_shrug_hard", loop = 56, e = "wzruszenie"}},
                {label = "Wzruszenie ramionami 2", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_shrug_hard", loop = 56, e = "wzruszenie2"}},
                {label = "Chodź tu", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_come_here_soft", loop = 57, e = "chodz"}},
                {label = "Chodź tu 2", type = "anim", data = {lib = "misscommon@response", anim = "bring_it_on", loop = 57, e = "chodz2"}},
                {label = "Chodź tu 3", type = "anim", data = {lib = "mini@triathlon", anim = "want_some_of_this", loop = 57, e = "chodz3"}},
                {label = "Co?", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_what_hard", loop = 56, e = "co"}},
                {label = "Szlag!", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_damn", loop = 56, e = "szlag"}},
                {label = "Cicho!", type = "anim", data = {lib = "anim@mp_player_intuppershush", anim = "idle_a_fp", loop = 58, e = "cicho"}},	           
                {label = "Halo!", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_d", loop = 56, e = "halo"}},
                {label = "Tu jestem!", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_c", loop = 56, e = "tujestem"}},
                {label = "To nie ja", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_b_player_a", loop = 0, e = "tonieja"}},		
                {label = "Przepraszam", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "wow_a_player_b", loop = 0, e = "przepraszam"}},		  
                {label = "Kciuki w górę", type = "anim", data = {lib = "anim@mp_player_intincarthumbs_upbodhi@ps@", anim = "enter", loop = 58, e = "kciuk"}},
                {label = "Kciuk w górę", type = "anim", data = {lib = "anim@mp_player_intincarthumbs_uplow@ds@", anim = "idle_a", loop = 58, e = "kciuk2"}},
                {label = "Kciuk w dół", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "thumbs_down_a_player_b", loop = 0, e = "kciuk3"}},
                {label = "Kciuk jednak w dół", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "thumbs_down_a_player_a", loop = 0, e = "kciuk4"}},			   
                {label = "Uspokój się", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_easy_now", loop = 56, e = "spokojnie"}},   
                {label = "Brawa 1", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_a_player_a", loop = 0, e = "brawa"}},
                {label = "Brawa 2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_b_player_a", loop = 0, e = "brawa2"}},
                {label = "Brawa 3", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_b_player_b", loop = 0, e = "brawa3"}},
                {label = "Cieszynka", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_a_player_a", loop = 50, e = "cieszynka"}},
                {label = "Zwycięzca 1", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "dance_b_1st", loop = 50, e = "zwyciezca"}},
                {label = "Zwycięzca 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "make_noise_a_1st", loop = 50, e = "zwyciezca2"}},
                {label = "Głowa w dół", type = "anim", data = {lib = "mp_sleep", anim = "sleep_intro", loop = 58, e = "glowadol"}},
                {label = "Znudzenie", type = "anim", data = {lib = "friends@fra@ig_1", anim = "base_idle", loop = 56, e = "znudzenie"}},
                {label = "Ukłon", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_1st", loop = 51, e = "uklon"}},
                {label = "Ukłon 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_a_1st", loop = 51, e = "uklon2"}},
                {label = "Zmęczony", type = "anim", data = {lib = "re@construction", anim = "out_of_breath", loop = 1, e = "zmeczony"}},
                {label = "Kaszel", type = "anim", data = {lib = "timetable@gardener@smoking_joint", anim = "idle_cough", loop = 51, e = "kaszel"}},
                {label = "Śmianie się", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "laugh_a_player_b", loop = 1, e = "smianiesie"}}, 
                {label = "Śmianie się 2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "giggle_a_player_b", loop = 1, e = "smianiesie2"}},
                {label = "Przestraszony", type = "anim", data = {lib = "random@domestic", anim = "f_distressed_loop", loop = 1, e = "przestraszony"}},         
            }
        },
        
        {
            name = 'Postawa',
            label = 'Pozy',
            items = {
                {label = "Ochroniarz 1", type = "scenario", data = {anim = "WORLD_HUMAN_GUARD_STAND", loop = 0, e = "ochroniarz"}},
                {label = "Ochroniarz 2", type = "anim", data = {lib = "amb@world_human_stand_guard@male@base", anim = "base", loop = 51, e = "ochroniarz2"}},
                {label = "Ochroniarz 3", type = "anim", data = {lib = "mini@strip_club@idles@bouncer@stop", anim = "stop", loop = 56, e = "ochroniarz3"}},
                {label = "Policjant 1", type = "scenario", data = {anim = "WORLD_HUMAN_COP_IDLES", loop = 1, e = "policjant"}},
                {label = "Policjant 2", type = "anim", data = {lib = "amb@world_human_cop_idles@male@base", anim = "base", loop = 51, e = "policjant2"}},
                {label = "Policjant 3", type = "anim", data = {lib = "amb@world_human_cop_idles@female@base", anim = "base", loop = 51, e = "policjant3"}},
                {label = "Wypadek 1 - lewy bok", type = "anim", data = {lib = "missheist_jewel", anim = "gassed_npc_customer4", loop = 1, e = "wypadek"}},
                {label = "Wypadek 2 - prawy bok", type = "anim", data = {lib = "missheist_jewel", anim = "gassed_npc_guard", loop = 1, e = "wypadek2"}},
                {label = "Ręce do tyłu", type = "anim", data = {lib = "anim@miss@low@fin@vagos@", anim = "idle_ped06", loop = 49, e = "receztylu"}},
                {label = "Założone ręce 1", type = "anim", data = {lib = "mini@hookers_sp", anim = "idle_reject_loop_c", loop = 57, e = "rece"}},
                {label = "Założone ręce 2", type = "anim", data = {lib = "anim@amb@nightclub@peds@", anim = "rcmme_amanda1_stand_loop_cop", loop = 51, e = "rece2"}},
                {label = "Założone ręce 3", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base", loop =51, e = "rece3"}},
                {label = "Założone ręce 4", type = "anim", data = {lib = "anim@heists@heist_corona@single_team", anim = "single_team_loop_boss", loop = 51, e = "rece4"}},
                {label = "Założone ręce 5", type = "anim", data = {lib = "random@street_race", anim = "_car_b_lookout", loop =51, e = "rece5"}},
                {label = "Założone ręce 6", type = "anim", data = {lib = "rcmnigel1a_band_groupies", anim = "base_m2", loop = 51, e = "rece6"}},
                {label = "Ręce na biodrach", type = "anim", data = {lib = "random@shop_tattoo", anim = "_idle", loop = 50, e = "biodra"}},
                {label = "Ręce na biodrach 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_3rd", loop = 50, e = "biodra2"}},
                {label = "Ręka na biodrze", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "shrug_off_a_1st", loop = 50, e = "biodra3"}},
                {label = "Ręka na biodrze 2", type = "anim", data = {lib = "rcmnigel1cnmt_1c", anim = "base", loop = 51, e = "biodra4"}},
                {label = "Obejmowanie", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "this_guy_b_player_a", loop = 50, e = "obejmowanie"}},
                {label = "Obejmowanie 2", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "this_guy_b_player_b", loop = 50, e = "obejmowanie2"}},
                {label = "Poddanie się 1 - na kolanach", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_a", loop = 1, e = "poddanie"}},
                {label = "Poddanie się 2 ", type = "anim", data = {lib = "anim@move_hostages@male", anim = "male_idle", loop = 51, e = "poddanie2"}},
                {label = "Poddanie się 3", type = "anim", data = {lib = "anim@move_hostages@female", anim = "female_idle", loop = 51, e = "poddanie3"}},
                {label = "Niecierpliwosc", type = "anim", data = {lib = "rcmme_tracey1", anim = "nervous_loop", loop = 51, e = "niecierpliwosc"}},
                {label = "Zastanowienie", type = "anim", data = {lib = "amb@world_human_prostitute@cokehead@base", anim = "base", loop = 1, e = "zastanowienie"}},
                {label = "Drążenie butem", type = "anim", data = {lib = "anim@mp_freemode_return@f@idle", anim = "idle_c", loop = 1, e = "drazenie"}},
                {label = "Myślenie", type = "anim", data = {lib = "rcmnigel3_idles", anim = "base_nig", loop = 51, e = "myslenie"}},
                {label = "Myślenie 2", type = "anim", data = {lib = "misscarsteal4@aliens", anim = "rehearsal_base_idle_director", loop = 51, e = "myslenie2"}},
                {label = "Myślenie 3", type = "anim", data = {lib = "timetable@tracy@ig_8@base", anim = "base", loop = 51, e = "myslenie3"}},
                {label = "Myślenie 4", type = "anim", data = {lib = "missheist_jewelleadinout", anim = "jh_int_outro_loop_a", loop = 51, e = "myslenie4"}},
                {label = "Myślenie 5", type = "anim", data = {lib = "mp_cp_stolen_tut", anim = "b_think", loop = 51, e = "myslenie5"}},
                {label = "Superbohater", type = "anim", data = {lib = "rcmbarry", anim = "base", loop = 51, e = "superbohater"}},
                {label = "Znak V", type = "anim", data = {lib = "anim@mp_player_intupperpeace", anim = "idle_a", loop = 51, e = "znakv"}},
            }
        },
    
        {
            name = 'siedzenie',
            label = 'Siedzenie/Lezenie/Opieranie',
            items = {
                {label = "Siedzenie 1 - na krześle", type = "scenario", data = {anim = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", e = "siedzenie"}},	  
                {label = "Siedzenie 2 - na kanapie", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "base", loop = 1, e = "siedzenie2"}},		
                {label = "Siedzenie 3 - na ziemi", type = "anim", data = {lib = "anim@heists@fleeca_bank@ig_7_jetski_owner", anim = "owner_idle", loop = 1, e = "siedzenie3"}},
                {label = "Siedzenie 4 - na pikniku", type = "anim", data = {lib = "amb@world_human_picnic@female@base", anim = "base", loop = 1, e = "siedzenie4"}},
                {label = "Siedzenie 5", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "idle_a_jimmy", loop = 1, e = "siedzenie5"}},
                {label = "Siedzenie 6 - przecholone", type = "anim", data = {lib = "timetable@amanda@ig_7", anim = "base", loop = 1, e = "siedzenie6"}},
                {label = "Siedzenie 7 - przecholone2", type = "anim", data = {lib = "timetable@tracy@ig_14@", anim = "ig_14_base_tracy", loop = 1, e = "siedzenie7"}},
                {label = "Siedzenie 8 - noga na noge", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_amanda", loop = 1, e = "siedzenie8"}},
                {label = "Siedzenie 9 - załamany", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@lo_alone@", anim = "lowalone_base_laz", loop = 1, e = "siedzenie9"}},
                {label = "Siedzenie 10 - na luzie", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "mics3_15_base_jimmy", loop = 1, e = "siedzenie10"}},
                {label = "Siedzenie 11 - na luzie 2", type = "anim", data = {lib = "amb@world_human_stupor@male@idle_a", anim = "idle_a", loop = 1, e = "siedzenie11"}},
                {label = "Siedzenie 12 - smutny", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "sit_phone_phoneputdown_sleeping-noworkfemale", loop = 1, e = "siedzenie12"}},
                {label = "Siedzenie 13 - przestraszony", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@hit", anim = "hit_loop_ped_b", loop = 1, e = "siedzenie13"}},
                {label = "Siedzenie 14 - przestraszony 2", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@ped_c@", anim = "flinch_loop", loop = 1, e = "siedzenie14"}},
                {label = "Siedzenie 15 - dłoń na dłoni", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_jimmy", loop = 1, e = "siedzenie15"}},
                {label = "Siedzenie 16 - na krześle 2", type = "anim", data = {lib = "timetable@ron@ig_5_p3", anim = "ig_5_p3_base", loop = 1, e = "siedzenie16"}},
                {label = "Siedzenie 17 - na krześle 3", type = "anim", data = {lib = "timetable@maid@couch@", anim = "base", loop = 1, e = "siedzenie17"}}, 
                {label = "Siedzenie 18 - na krześle 4", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "mics3_15_base_tracy", loop = 1, e = "siedzenie18"}},
                {label = "Siedzenie 19 - na sofie", type = "anim", data = {lib = "timetable@trevor@smoking_meth@base", anim = "base", loop = 1, e = "siedzenie19"}},
                {label = "Siedzenie 20 - na sofie 2", type = "anim", data = {lib = "timetable@michael@on_sofabase", anim = "sit_sofa_base", loop = 1, e = "siedzenie20"}},
                {label = "Leżenie 1 - na brzuchu", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE", loop = 1, e = "lezenie"}},
                {label = "Leżenie 2 - na brzuchu 2", type = "anim", data = {lib = "missfbi3_sniping", anim = "prone_dave", loop = 1, e = "lezenie2"}},
                {label = "Leżenie 3 - na plecach", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK", loop = 0, e = "lezenie3"}},
                {label = "Leżenie 4 - na kanapie", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "laying", loop = 1, e = "lezenie4"}},
                {label = "Leżenie 5 - lewy bok", type = "anim", data = {lib = "amb@world_human_bum_slumped@male@laying_on_left_side@base", anim = "base", loop = 1, e = "lezenie5"}},
                {label = "Leżenie 6 - prawy bok", type = "anim", data = {lib = "amb@world_human_bum_slumped@male@laying_on_right_side@base", anim = "base", loop = 1, e = "lezenie6"}},
                {label = "Leżenie 6 - prawy bok 2", type = "anim", data = {lib = "switch@trevor@scares_tramp", anim = "trev_scares_tramp_idle_tramp", loop = 1, e = "lezenie7"}},
                {label = "Leżenie 7 - patrzenie w góre", type = "anim", data = {lib = "switch@trevor@annoys_sunbathers", anim = "trev_annoys_sunbathers_loop_girl", loop = 1, e = "lezenie8"}},
                {label = "Leżenie 8 - patrzenie w góre 2", type = "anim", data = {lib = "switch@trevor@annoys_sunbathers", anim = "trev_annoys_sunbathers_loop_guy", loop = 1, e = "lezenie9"}},
                {label = "Opieranie o barierkę 1 - przód", type = "anim", data = {lib = "amb@prop_human_bum_shopping_cart@male@base", anim = "base", loop = 1, e = "opieranie"}},
                {label = "Opieranie o barierkę 2 - przód", type = "anim", data = {lib = "missheistdockssetup1ig_12@base", anim = "talk_gantry_idle_base_worker2", loop = 1, e = "opieranie2"}},
                {label = "Opieranie o barierkę 3 - przód", type = "anim", data = {lib = "misshair_shop@hair_dressers", anim = "assistant_base", loop = 1, e = "opieranie3"}},
                {label = "Opieranie o barierkę 4 - z tyłu", type = "anim", data = {lib = "anim@amb@clubhouse@bar@bartender@", anim = "base_bartender", loop = 1, e = "opieranie4"}},
                {label = "Opieranie o stół 1 - przód", type = "anim", data = {lib = "anim@amb@clubhouse@bar@drink@base", anim = "idle_a", loop = 1, e = "opieranie5"}},
                {label = "Opieranie o stół 2 - przód", type = "anim", data = {lib = "anim@amb@board_room@diagram_blueprints@", anim = "base_amy_skater_01", loop = 1, e = "opieranie6"}},
                {label = "Opieranie o stół 3 - przód", type = "anim", data = {lib = "anim@amb@facility@missle_controlroom@", anim = "idle", loop = 1, e = "opieranie7"}},
                {label = "Opieranie ściana 1 - nogi na ziemi", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@hands_together@base", anim = "base", loop = 1, e = "opieranie8"}},
                {label = "Opieranie ściana 2 - noga w górze", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@foot_up@base", anim = "base", loop = 1, e = "opieranie9"}},
                {label = "Opieranie ściana 3 - nogi na krzyż", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@legs_crossed@base", anim = "base", loop = 1, e = "opieranie10"}},
                {label = "Opieranie ściana 4 - nogi na krzyż 2", type = "anim", data = {lib = "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", anim = "idle_a", loop = 1, e = "opieranie11"}},
                {label = "Opieranie ściana 5 - głowa w dół", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "stand_phone_phoneputdown_sleeping_nowork", loop = 1, e = "opieranie12"}},
                {label = "Opieranie łokciem 1", type = "anim", data = {lib = "rcmjosh2", anim = "josh_2_intp1_base", loop = 1, e = "opieranie13"}},
                {label = "Opieranie łokciem 2", type = "anim", data = {lib = "timetable@mime@01_gc", anim = "idle_a", loop = 1, e = "opieranie14"}},
                {label = "Opieranie łokciem 3", type = "anim", data = {lib = "misscarstealfinalecar_5_ig_1", anim = "waitloop_lamar", loop = 1, e = "opieranie15"}},
                {label = "Opieranie ręką", type = "anim", data = {lib = "misscarstealfinale", anim = "packer_idle_1_trevor", loop = 1, e = "opieranie16"}},
                {label = "Zimny łokieć [Kierowca]", type = "anim", data = {lib = "anim@veh@lowrider@low@front_ds@arm@base", anim = "sit", loop = 51, e = "zimnylokiec"}},
            }
        },
        
        {
            name = 'Czynności',
            label = 'Czynności',
            items = {
                {label = "Telefon 1", type = "scenario", data = {anim = "world_human_tourist_mobile", loop = 0, e = "telefon"}},
                {label = "Telefon 2", type = "scenario", data = {anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", loop = 0, e = "telefon2"}},
                {label = "Fotka - wyimaginowany aparat", type = "anim", data = {lib = "anim@mp_player_intincarphotographylow@ds@", anim = "idle_a", loop = 1, e = "fotka"}},
                {label = "Tłumaczenie", type = "anim", data = {lib = "misscarsteal4@actor", anim = "actor_berating_assistant", loop = 56, e = "tlumaczenie"}},
                {label = "Przyglądanie się broni", type = "anim", data = {lib = "mp_corona@single_team", anim = "single_team_intro_one", loop = 56, e = "bron"}},
                {label = "Zerkanie na zegarek", type = "anim", data = {lib = "oddjobs@taxi@", anim = "idle_a", loop = 56, e = "zegarek"}},
                {label = "Czyszczenie 1 - mycie ścierką", type = "scenario", data = {anim = "world_human_maid_clean", loop = 0, e = "mycie"}},
                {label = "Czyszczenie 2 - mycie maski auta", type = "anim", data = {lib = "switch@franklin@cleaning_car", anim = "001946_01_gc_fras_v2_ig_5_base", loop = 1, e = "mycie2"}},
                {label = "Branie prysznica 1", type = "anim", data = {lib = "mp_safehouseshower@female@", anim = "shower_idle_a", loop = 1, e = "prysznic"}},
                {label = "Branie prysznica 2", type = "anim", data = {lib = "mp_safehouseshower@male@", anim = "male_shower_idle_a", loop = 1, e = "prysznic2"}},
                {label = "Branie prysznica 3", type = "anim", data = {lib = "mp_safehouseshower@male@", anim = "male_shower_idle_d", loop = 1, e = "prysznic3"}},
                {label = "Sięganie do schowka w aucie [Pojazd]", type = "animschowek", data = {lib = "rcmme_amanda1", anim = "drive_mic", loop = 56, e = "schowek"}},
                {label = "Włamywanie do sejfu", type = "anim", data = {lib = "mini@safe_cracking", anim = "dial_turn_anti_normal", loop = 0, e = "sejf"}},
                {label = "Przymierzanie ubrań", type = "anim", data = {lib = "mp_clothing@female@trousers", anim = "try_trousers_neutral_a", loop = 1, e = "ubrania"}},
                {label = "Przymierzanie góry", type = "anim", data = {lib = "mp_clothing@female@shirt", anim = "try_shirt_positive_a", loop = 1, e = "ubrani2"}},
                {label = "Przymierzanie butów", type = "anim", data = {lib = "mp_clothing@female@shoes", anim = "try_shoes_positive_a", loop = 1, e = "ubrania3"}},
                {label = "Pakowanie do torby", type = "anim", data = {lib = "anim@heists@ornate_bank@grab_cash", anim = "grab", loop = 1, e = "torba"}},
                {label = "Oddawaj pieniądze", type = "anim", data = {lib = "mini@prostitutespimp_demands_money", anim = "pimp_demands_money_pimp", loop = 0, e = "oddawaj"}},
                {label = "Samobójstwo", type = "anim", data = {lib = "mp_suicide", anim = "pistol", loop = 2, e = "samobojstwo"}},
                {label = "Salutowanie", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute", loop = 51, e = "salut"}},
                {label = "Kłótnia", type = "anim", data = {lib = "sdrm_mcs_2-0", anim = "csb_bride_dual-0", loop = 56, e = "klotnia"}},
                {label = "Kucanie", type = "anim", data = {lib = "rcmextreme3", anim = "idle", loop = 1, e = "kucanie"}},
                {label = "Kucanie 2", type = "anim", data = {lib = "amb@world_human_bum_wash@male@low@idle_a", anim = "idle_a", loop = 1, e = "kucanie2"}},
                {label = "Gwizdanie", type = "anim", data = {lib = "rcmnigel1c", anim = "hailing_whistle_waive_a", loop = 51, e = "gwizdanie"}},
                {label = "Gwizdanie 2", type = "anim", data = {lib = "taxi_hail", anim = "hail_taxi", loop = 51, e = "gwizdanie2"}},
                {label = "Celowanie", type = "anim", data = {lib = "random@countryside_gang_fight", anim = "biker_02_stickup_loop", loop = 49, e = "celowanie"}},
                {label = "Celowanie 2", type = "anim", data = {lib = "random@atmrobberygen", anim = "b_atm_mugging", loop = 49, e = "celowanie2"}},
                {label = "Celowanie 3", type = "anim", data = {lib = "move_weapon@pistol@copa", anim = "idle", loop = 49, e = "celowanie3"}},
                {label = "Celowanie 4", type = "anim", data = {lib = "move_weapon@pistol@cope", anim = "idle", loop = 49, e = "celowanie4"}},
                {label = "Celowanie 5", type = "anim", data = {lib = "combat@aim_variations@1h@gang", anim = "aim_variation_b", loop = 51, e = "celowanie5"}},
                {label = "Medytacja", type = "anim", data = {lib = "rcmcollect_paperleadinout@", anim = "meditiate_idle", loop = 1, e = "medytacja"}},
                {label = "Medytacja 2", type = "anim", data = {lib = "rcmepsilonism3", anim = "ep_3_rcm_marnie_meditating", loop = 1, e = "medytacja2"}},
                {label = "Pukanie", type = "anim", data = {lib = "timetable@jimmy@doorknock@", anim = "knockdoor_idle", loop = 51, e = "pukanie"}},
                {label = "Wskazywanie", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_point", loop = 56, e = "wskazywanie"}},
                {label = "Wskazywanie 2 - Dół", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_hand_down", loop = 56, e = "wskazywanie2"}},
                {label = "Wskazywanie 3 - Prawo", type = "anim", data = {lib = "mp_gun_shop_tut", anim = "indicate_right", loop = 56, e = "wskazywanie3"}},
                {label = "Trzymanie się za kabure", type = "anim", data = {lib = "move_m@intimidation@cop@unarmed", anim = "idle", loop = 49, e = "kabura"}},
                {label = "Granie w golfa", type = "anim", data = {lib = "rcmnigel1d", anim = "swing_a_mark", loop = 51, e = "golf"}},  
            }	
        },
        
        {
            name = 'Chamskie',
            label = 'Chamskie',
            items = {
                {label = "Mów do ręki", type = "anim", data = {lib = "mini@prostitutestalk", anim = "street_argue_f_a", loop = 56, e = ""}},           
                {label = "Środkowy palec 1", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "flip_off_a_1st", loop = 56, e = "palec"}},
                {label = "Środkowy palec 2 - z kieszeni", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "flip_off_b_1st", loop = 56, e = "palec2"}},
                {label = "Środkowy palec 3", type = "anim", data = {lib = "anim@mp_player_intselfiethe_bird", anim = "idle_a", loop = 51, e = "palec3"}},
                {label = "Pokazywanie środkowych palców", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter", loop = 58, e = "palec4"}},
                {label = "Sarkastyczne klaskanie 1", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@slow_clap", anim = "slow_clap", loop = 56, e = "klaskanie"}},
                {label = "Sarkastyczne klaskanie 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@slow_clap", anim = "slow_clap", loop = 56, e = "klaskanie2"}},
                {label = "Sarkastyczne klaskanie 3", type = "anim", data = {lib = "anim@mp_player_intupperslow_clap", anim = "idle_a", loop = 57, e = "klaskanie3"}},
                {label = "Sarkastyczne klaskanie 4", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_b_3rd", loop = 0, e = "klaskanie4"}},          
                {label = "Drapanie sie po kroczu", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", loop = 57, e = "drapaniepokroczu"}},
                {label = "Dłubanie w nosie - strzał gilem", type = "anim", data = {lib = "anim@mp_player_intuppernose_pick", anim = "exit", loop = 56, e = "dlubanie"}},
                {label = "Dłubanie w nosie 2 - oscentacyjne", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@nose_pick", anim = "nose_pick", loop = 0, e = "dlubanie2"}},
                {label = "Ten z tyłu śmierdzi", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_c_player_b", loop = 0, e = "smierdzi"}},
                {label = "No dawaj!", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_bring_it_on", loop = 56, e = "dawaj"}},
                {label = "Gotowość na bójkę", type = "anim", data = {lib = "anim@mp_player_intupperknuckle_crunch", anim = "idle_a", loop = 56, e = "bojka"}},
                {label = "Gotowość na bójkę 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@knuckle_crunch", anim = "knuckle_crunch", loop = 56, e = "bojka2"}},
                {label = "Gotowość na bójkę 3", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_c", loop = 1, e = "bojka3"}},           
                {label = "Gotowość na bójkę 4", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e", loop = 1, e = "bojka4"}},           
                {label = "Spoliczkowanie", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "air_slap_a_1st", loop = 56, e = "policzek"}},
            }
        },
        
        {
            name = 'Sportowe',
            label = 'Sportowe',
            items = {
                {label = "Jogging", type = "anim", data = {lib = "move_m@jogger", anim = "run", loop = 33, e = "jogging"}},
                {label = "Jogging 2", type = "scenario", data = {anim = "WORLD_HUMAN_JOG_STANDING", loop = 0, e = "jogging2"}},
                {label = "Trucht", type = "anim", data = {lib = "move_m@jog@", anim = "run", loop = 33, e = "trucht"}},
                {label = "Powerwalk", type = "anim", data = {lib = "amb@world_human_power_walker@female@base", anim = "base", loop = 33, e = "powerwalk"}},
                {label = "Napinanie mięśni", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base", loop = 1, e = "napinanie"}},
                {label = "Pompki", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base", loop = 1, e = "pompki"}},
                {label = "Brzuszki", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base", loop = 1, e = "brzuszki"}},
                {label = "Salto w tył", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "flip_a_player_a", loop = 0, e = "salto"}},
                {label = "Capoeira", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "cap_a_player_a", loop = 0, e = "capoeira"}},
                {label = "Yoga 1 - przygotowanie", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base", loop = 1, e = "yoga"}},
                {label = "Yoga 2 - rozciąganie się", type = "anim", data = {lib = "amb@world_human_yoga@female@base", anim = "base_b", loop = 1, e = "yoga2"}},
                {label = "Yoga 3 - stanie na rękach", type = "anim", data = {lib = "amb@world_human_yoga@female@base", anim = "base_c", loop = 1, e = "yoga3"}},
                {label = "Wślizg na kolanach", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "slide_a_player_a", loop = 0, e = "wslizg"}},
                {label = "Skok przez kozła", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_b_player_a", loop = 0, e = "skok"}},
                {label = "Szpagat", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_c_player_a", loop = 0, e = "szpagat"}},
                {label = "Podskok", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_d_player_a", loop = 0, e = "podskok"}},
                {label = "Pajacyki", type = "anim", data = {lib = "timetable@reunited@ig_2", anim = "jimmy_masterbation", loop = 1, e = "pajacyki"}},
                {label = "Rozciąganie się", type = "anim", data = {lib = "mini@triathlon", anim = "idle_e", loop = 1, e = "rozciaganie"}},
                {label = "Rozciąganie się 2", type = "anim", data = {lib = "mini@triathlon", anim = "idle_f", loop = 1, e = "rozciaganie2"}},
                {label = "Rozciąganie się 3", type = "anim", data = {lib = "mini@triathlon", anim = "idle_d", loop = 1, e = "rozciaganie3"}},
                {label = "Rozciąganie się 4", type = "anim", data = {lib = "rcmfanatic1maryann_stretchidle_b", anim = "idle_e", loop = 1, e = "rozciaganie4"}}, 
                {label = "Boks", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@shadow_boxing", anim = "shadow_boxing", loop = 51, e = "boks"}},
                {label = "Boks 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@shadow_boxing", anim = "shadow_boxing", loop = 51, e = "boks2"}},
                {label = "Karate", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@karate_chops", anim = "karate_chops", loop = 1, e = "karate"}},
                {label = "Karate 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@karate_chops", anim = "karate_chops", loop = 1, e = "karate2"}},      
            }
        },
    
        {
            name = 'Czynności Pracy',
            label = 'Czynności Pracy',
            items = {
                {label = "Mechanik 1 - maska", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped", loop = 1, e = "mechanik"}},
                {label = "Mechanik 2 - maska", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_player", loop = 1, e = "mechanik2"}},
                {label = "Mechanik 3 - pod autem", type = "anim", data = {lib = "amb@world_human_vehicle_mechanic@male@base", anim = "base", loop = 1, e = "mechanik3"}},
                {label = "Mechanik 4 - wyjście spod auta", type = "anim", data = {lib = "amb@world_human_vehicle_mechanic@male@exit", anim = "exit", loop = 0, e = "mechanik4"}},
                {label = "Uderzanie młotkiem", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING", loop = 0, e = "mlotek"}},
                {label = "Spawanie", type = "scenario", data = {anim = "WORLD_HUMAN_WELDING", loop = 1, e = "spawanie"}},
                {label = "Pisanie na komputerze", type = "anim", data = {lib = "anim@heists@prison_heistig1_p1_guard_checks_bus", anim = "loop", loop = 1, e = "komputer"}},
                {label = "Ładowanie towaru", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper", loop = 0, e = "towar"}},
                {label = "Kopanie w ziemi - klękanie", type = "scenario", data = {anim = "world_human_gardener_plant", loop = 0, e = "kopanie2"}},
            }
        },
    
        {
            name = 'Służbowe',
            label = 'Służbowe',
            items = {
                {label = "Sprawdzanie stanu 1 - klękanie", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL", loop = 0, e = "stan"}},
                {label = "Sprawdzanie stanu 2 - uciskanie", type = "anim", data = {lib = "anim@heists@narcotics@funding@gang_idle", anim = "gang_chatting_idle01", loop = 1, e = "stan2"}},		
                {label = "Ból w klatce piersiowej", type = "anim", data = {lib = "anim@heists@prison_heistig_5_p1_rashkovsky_idle", anim = "idle", loop = 1, e = "klatka"}},
                {label = "Ból nogi", type = "anim", data = {lib = "missfbi5ig_0", anim = "lyinginpain_loop_steve", loop = 1, e = "noga"}},
                {label = "Ból brzucha", type = "anim", data = {lib = "combat@damage@writheidle_a", anim = "writhe_idle_a", loop = 1, e = "brzuch"}},
                {label = "Ból głowy", type = "anim", data = {lib = "combat@damage@writheidle_b", anim = "writhe_idle_f", loop = 1, e = "glowa"}},
                {label = "Ból głowy 2", type = "anim", data = {lib = "misscarsteal4@actor", anim = "dazed_idle", loop = 51, e = "glowa2"}},
                {label = "Drgawki", type = "anim", data = {lib = "missheistfbi3b_ig8_2", anim = "cpr_loop_victim", loop = 1, e = "drgawki"}},
                 {label = "Omdlenie 1 - prawy bok", type = "anim", data = {lib = "dam_ko@shot", anim = "ko_shot_head", loop = 2, e = "omdlenie"}},
                {label = "Omdlenie 2 - na plecy", type = "anim", data = {lib = "anim@gangops@hostage@", anim = "perp_success", loop = 2, e = "omdlenie2"}},
                {label = "Omdlenie 3 - leżąc", type = "anim", data = {lib = "mini@cpr@char_b@cpr_def", anim = "cpr_intro", loop = 2, e = "omdlenie3"}},
                {label = "Ocknięcie 1 - ponowne omdlenie", type = "anim", data = {lib = "missfam5_blackout", anim = "pass_out", loop = 2, e = "ockniecie"}},
                {label = "Ocknięcie 2 - wymiotowanie", type = "anim", data = {lib = "missfam5_blackout", anim = "vomit", loop = 0, e = "ockniecie2"}},
                {label = "Ocknięcie 3 - szybko", type = "anim", data = {lib = "safe@trevor@ig_8", anim = "ig_8_wake_up_front_player", loop = 0, e = "ockniecie3"}},
                {label = "Ocknięcie 4 - powoli", type = "anim", data = {lib = "safe@trevor@ig_8", anim = "ig_8_wake_up_right_player", loop = 0, e = "ockniecie4"}},
                {label = "Brak przytomności 1", type = "anim", data = {lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", loop = 1, e = "nieprzytomnosc"}},
                {label = "Brak przytomności 2", type = "anim", data = {lib = "missprologueig_6", anim = "lying_dead_brad", loop = 1, e = "nieprzytomnosc2"}},
                {label = "Brak przytomności 3", type = "anim", data = {lib = "missprologueig_6", anim = "lying_dead_player0", loop = 1, e = "nieprzytomnosc3"}},
                {label = "Brak przytomności 4", type = "anim", data = {lib = "random@mugging4", anim = "flee_backward_loop_shopkeeper", loop = 1, e = "nieprzytomnosc4"}},
                {label = "Brak przytomności 5 - na brzuchu", type = "anim", data = {lib = "missarmenian2", anim = "drunk_loop", loop = 1, e = "nieprzytomnosc5"}},
                {label = "RKO 1 - uciskanie", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", loop = 1, e = "rko"}},
                {label = "RKO 2 - wdechy", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol", loop = 1, e = "rko2"}},
                {label = "Wzywanie SOS - rękoma", type = "anim", data = {lib = "random@gang_intimidation@", anim = "001445_01_gangintimidation_1_female_wave_loop", loop = 51, e = "sos"}},
                {label = "Sprawdzanie dowodów", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f", loop = 0, e = "dowody"}},
                {label = "Sprawdzanie dowodów 2", type = "anim", data = {lib = "random@train_tracks", anim = "idle_e", loop = 0, e = "dowody2"}},
            }
        },
    
        {
            name = 'Tańce',
            label = 'Tańce',
            items = {
                {label = "Twerk", type = "anim", data = {lib = "switch@trevor@mocks_lapdance", anim = "001443_01_trvs_28_idle_stripper", loop = 1, e = "twerk"}},   
                {label = "Taniec 1", type = "anim", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao", loop = 1, e = "taniec"}},           
                {label = "Taniec 2", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^1", loop = 1, e = "taniec2"}},
                {label = "Taniec 3", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^3", loop = 1, e = "taniec3"}},
                {label = "Taniec 4", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^6", loop = 1, e = "taniec4"}},
                {label = "Taniec 5", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^1", loop = 1, e = "taniec5"}},
                {label = "Taniec 6", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^1", loop = 1, e = "taniec6"}},
                {label = "Taniec 7", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_11_turnaround_laz", loop = 1, e = "taniec7"}},
                {label = "Taniec 8", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_17_smackthat_laz", loop = 1, e = "taniec8"}},
                {label = "Taniec 9", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", loop = 1, e = "taniec9"}},
                {label = "Taniec 10", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_06_base_laz", loop = 1, e = "taniec10"}},
                {label = "Taniec 11", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@uncle_disco", anim = "uncle_disco", loop = 1, e = "taniec11"}},
                {label = "Taniec 12", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1", loop = 1, e = "taniec12"}},
                {label = "Taniec 13", type = "anim", data = {lib = "rcmnigel1bnmt_1b", anim = "dance_loop_tyler", loop = 1, e = "taniec13"}},
                {label = "Taniec 14", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "low_center", loop = 1, e = "taniec14"}},
                {label = "Taniec 15", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_15_robot_laz",  loop = 1, e = "taniec15"}},
                {label = "Taniec 16", type = "anim", data = {lib = "anim@amb@nightclub@dancers@solomun_entourage@", anim = "mi_dance_facedj_17_v1_female^1",  loop = 1, e = "taniec16"}},
                {label = "Taniec 17", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "high_center_up",  loop = 1, e = "taniec17"}},
                {label = "Taniec 18", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "low_center",  loop = 1, e = "taniec18"}},
                {label = "Taniec 19", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "med_center_up",  loop = 1, e = "taniec19"}},
                {label = "Taniec 20", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^1",  loop = 1, e = "taniec20"}},
                {label = "Taniec 21", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^3",  loop = 1, e = "taniec21"}},
                {label = "Taniec 22", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3",  loop = 1, e = "taniec22"}},
                {label = "Taniec 23", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^3",  loop = 1, e = "taniec23"}},
                {label = "Taniec 24", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@thumb_on_ears", anim = "thumb_on_ears",  loop = 1, e = "taniec24"}},
                {label = "Taniec 25", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel",  loop = 1, e = "taniec25"}},
                {label = "Taniec 26", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center",  loop = 1, e = "taniec26"}},
                {label = "Taniec 27", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center_up",  loop = 1, e = "taniec27"}},
                {label = "Taniec 28", type = "anim", data = {lib = "anim@amb@casino@mini@dance@dance_solo@female@var_b@", anim = "high_center",  loop = 1, e = "taniec28"}},
                {label = "Taniec 29", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "low_center_down",  loop = 1, e = "taniec29"}},
                {label = "Taniec 30", type = "anim", data = {lib = "timetable@tracy@ig_8@idle_b", anim = "idle_d",  loop = 1, e = "taniec30"}},
                {label = "Taniec 31", type = "anim", data = {lib = "timetable@tracy@ig_5@idle_a", anim = "idle_a",  loop = 1, e = "taniec31"}},
                {label = "Taniec 32", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_11_buttwiggle_b_laz",  loop = 1, e = "taniec32"}},
                {label = "Taniec 33", type = "anim", data = {lib = "move_clown@p_m_two_idles@", anim = "fidget_short_dance",  loop = 1, e = "taniec33"}},
                {label = "Taniec 34", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_center",  loop = 1, e = "taniec34"}},
                {label = "Taniec 35", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "high_center_down",  loop = 1, e = "taniec35"}},
                {label = "Taniec 36", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@techno_monkey@", anim = "med_center_down",  loop = 1, e = "taniec36"}},
                {label = "Taniec 37", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_single_props@", anim = "mi_dance_prop_13_v1_male^3",  loop = 1, e = "taniec37"}},
                {label = "Taniec 38", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male^1",  loop = 1, e = "taniec38"}},
                {label = "Taniec 39", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_17_v2_male^4",  loop = 1, e = "taniec39"}},
                {label = "Taniec 40", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "mi_dance_facedj_15_v2_male^4",  loop = 1, e = "taniec40"}},
                {label = "Taniec 41", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_facedj@", anim = "hi_dance_facedj_hu_15_v2_male^5",  loop = 1, e = "taniec41"}},
                {label = "Taniec 42", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_right_up",  loop = 1, e = "taniec42"}},
                {label = "Taniec 43", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "med_center",  loop = 1, e = "taniec43"}},
                {label = "Taniec 44", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_right_down",  loop = 1, e = "taniec44"}},
                {label = "Taniec 45", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male^1",  loop = 1, e = "taniec45"}},
                {label = "Taniec 46", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@shuffle@", anim = "high_left_down",  loop = 1, e = "taniec46"}},
                {label = "Taniec 47", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@", anim = "low_center",  loop = 1, e = "taniec47"}},
                {label = "Taniec 48", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_paired@dance_d@", anim = "ped_a_dance_idle",  loop = 1, e = "taniec48"}},
                {label = "Taniec 49", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_paired@dance_b@", anim = "ped_a_dance_idle",  loop = 1, e = "taniec49"}},
                {label = "Taniec 50", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_paired@dance_a@", anim = "ped_a_dance_idle",  loop = 1, e = "taniec50"}},
                {label = "Taniec 51", type = "anim", data = {lib = "anim@mp_player_intuppersalsa_roll", anim = "idle_a",  loop = 1, e = "taniec51"}},
                {label = "Taniec 52", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@uncle_disco", anim = "uncle_disco",  loop = 1, e = "taniec52"}},
                {label = "Taniec 53", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_a_f02",  loop = 1, e = "taniec53"}},
                {label = "Taniec 54", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_b_m03",  loop = 1, e = "taniec54"}},
                {label = "Taniec 55", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_b_f01",  loop = 1, e = "taniec55"}},
                {label = "Taniec 56", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m02",  loop = 1, e = "taniec56"}},
                {label = "Taniec 57", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m05",  loop = 1, e = "taniec57"}},
                {label = "Taniec 58", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@beachdance@", anim = "hi_idle_a_m03",  loop = 1, e = "taniec58"}},
                {label = "Taniec 59", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@crowddance_groups@groupd@", anim = "mi_dance_crowd_13_v2_male^1",  loop = 1, e = "taniec59"}},
                {label = "Taniec 60", type = "anim", data = {lib = "anim@amb@nightclub_island@dancers@club@", anim = "hi_idle_d_f01",  loop = 1, e = "taniec60"}},
                {label = "Klubowy 1 (Dla kobiet)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^1",  loop = 1, e = "klubowy1"}},
                {label = "Klubowy 2 (Dla mężczyzn)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^2",  loop = 1, e = "klubowy2"}},
                {label = "Klubowy 3 (Dla kobiet)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3",  loop = 1, e = "klubowy3"}},
                {label = "Klubowy 4", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_17_crotchgrab_laz",  loop = 1, e = "klubowy4"}},
            }
        }, 
    
        {
            name = 'Imprezowe',
            label = 'Imprezowe',
            items = {
                {label = "DJ", type = "anim", data = {lib = "mini@strip_club@idles@dj@idle_02", anim = "idle_02", loop = 1, e = "dj"}},
                {label = "Oglądanie występu", type = "anim", data = {lib = "amb@world_human_strip_watch_stand@male_a@base", anim = "base", loop = 1, e = "ogladanie"}},
                {label = "Gest 1 - Ręce w górze", type = "anim", data = {lib = "mp_player_int_uppergang_sign_a", anim = "mp_player_int_gang_sign_a", loop = 57, e = "gest"}},
                {label = "Gest 2 - Znak V", type = "anim", data = {lib = "mp_player_int_upperv_sign", anim = "mp_player_int_v_sign", loop = 57, e = "gest2"}},
                {label = "Gest 3 - Znak V 2", type = "anim", data = {lib = "anim@mp_player_intupperpeace", anim = "idle_a_fp", loop = 57, e = "gest2"}},
                {label = "Gest 3 - Znak V 3", type = "anim", data = {lib = "anim@mp_player_intincarpeacebodhi@ds@", anim = "idle_a", loop = 57, e = "gest2"}},
                {label = "Bycie pijanym", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a", loop = 1, e = "pijany"}},
                {label = "Udawanie gry na gitarze", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar", loop = 0, e = "udawaniegry"}},
                {label = "Rock'n roll 1", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock_enter", loop = 56, e = "rock"}},
                {label = "Rock'n roll 2", type = "anim", data = {lib = "mp_player_introck", anim = "mp_player_int_rock", loop = 56, e = "rock2"}},           
                {label = "Rzucanie hajsem", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@props@", anim = "make_it_rain_b_player_b", loop = 0, e = "hajs"}},
                {label = "Śmiech", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_e_player_b", loop = 0, e = "smiech"}},
                {label = "Pozowanie - manekin", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE", loop = 1, e = "manekin"}},
                {label = "Pozowanie - manekin 2", type = "anim", data = {lib = "fra_0_int-1", anim = "cs_lamardavis_dual-1", loop = 49, e = "manekin3"}},
                {label = "Pozowanie - manekin 3", type = "anim", data = {lib = "club_intro2-0", anim = "csb_englishdave_dual-0", loop = 0, e = "manekin3"}},
                {label = "Wymiotowanie w aucie", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside", loop = 0, e = "wymioty"}},
                {label = "Udawanie ptaka", type = "anim", data = {lib = "random@peyote@bird", anim = "wakeup", loop = 51, e = "ptak"}},
                {label = "Udawanie kurczaka", type = "anim", data = {lib = "random@peyote@chicken", anim = "wakeup", loop = 51, e = "kurczak"}},
                {label = "Udawanie królika", type = "anim", data = {lib = "random@peyote@rabbit", anim = "wakeup", loop = 1, e = "krolik"}},
                {label = "Udawanie klauna 1", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_0", loop = 1, e = "klaun"}},           
                {label = "Udawanie klauna 2", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_1", loop = 1, e = "klaun2"}},
                {label = "Udawanie klauna 3", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_2", loop = 1, e = "klaun3"}},
                {label = "Udawanie klauna 4", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_3", loop = 1, e = "klaun4"}},
                {label = "Udawanie klauna 5", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_6", loop = 1, e = "klaun5"}},
                {label = "Kontrolowanie umysłu", type = "anim", data = {lib = "rcmbarry", anim = "mind_control_b_loop", loop = 56, e = "kontrolowanie"}},
                {label = "Kontrolowanie umysłu 2", type = "anim", data = {lib = "rcmbarry", anim = "bar_1_attack_idle_aln", loop = 56, e = "kontrolowanie2"}},
            }
        },
    
        {
            name = 'Miłosne',
            label = 'Miłosne',
            items = {
                {label = "Przytul 1", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a", loop = 0, e = "przytul"}},
                {label = "Przytul 2", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_b", loop = 0, e = "przytul2"}},        	
                {label = "Całus 1", type = "anim", data = {lib = "anim@mp_player_intselfieblow_kiss", anim = "exit", loop = 56, e = "calus"}},
                {label = "Całus 2", type = "anim", data = {lib = "mini@hookers_sp", anim = "idle_a", loop = 0, e = "calus2"}},
                {label = "Całus 3", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@blow_kiss", anim = "blow_kiss", loop = 56, e = "calus3"}},
                {label = "Uroczo", type = "anim", data = {lib = "mini@hookers_spcokehead", anim = "idle_reject_loop_a", loop = 58, e = "uroczo"}},
                {label = "Zawstydzenie", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_a_3rd", loop = 0, e = "zawstydzenie"}},
                {label = "Zawstydzenie 2", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_hold_arm@idle_a", anim = "idle_a", loop = 51, e = "zawstydzenie2"}},          
                {label = "Uwodzenie", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02", loop = 1, e = "uwodzenie"}},
            }
        },
    
        {
            name  = 'Style chodzenia',
            label = 'Style chodzenia',
            items = {
                {label = "Normalny [K]", type = "attitude", data = {lib = "move_f@generic", anim = "move_f@generic", e = ""}},
                {label = "Normalny [M]", type = "attitude", data = {lib = "move_m@generic", anim = "move_m@generic", e = ""}},
                {label = "Pewniak [K]", type = "attitude", data = {lib = "move_f@heels@d", anim = "move_f@heels@d", e = ""}},
                {label = "Pewniak [M]", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident", e = ""}},
                {label = "Gruby [K]", type = "attitude", data = {lib = "move_f@fat@a", anim = "move_f@fat@a", e = ""}},
                {label = "Gruby [M]", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a", e = ""}},
                {label = "Poszkodowany [K]", type = "attitude", data = {lib = "move_f@injured", anim = "move_f@injured", e = ""}},
                {label = "Poszkodowany [M]", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured", e = ""}},
                {label = "Policjant", type = "attitude", data = {lib = "move_m@tool_belt@a", anim = "move_m@tool_belt@a", e = ""}},
                {label = "Policjantka", type = "attitude", data = {lib = "move_f@tool_belt@a", anim = "move_f@tool_belt@a", e = ""}},
                {label = "Zuchwały [K]", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy", e = ""}},
                {label = "Zuchwały [M]", type = "attitude", data = {lib = "move_m@sassy", anim = "move_m@sassy", e = ""}},
                {label = "Smutny", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a", e = ""}},
                {label = "Biznes", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a", e = ""}},
                {label = "Odważny", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a", e = ""}},
                {label = "Luzak", type = "attitude", data = {lib = "move_m@casual@e", anim = "move_m@casual@e", e = ""}},
                {label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a", e = ""}},
                {label = "Smutny", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a", e = ""}},
                {label = "Siłacz", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a", e = ""}},
                {label = "Gangster 1", type = "attitude", data = {lib = "move_m@gangster@generic", anim = "move_m@gangster@generic", e = ""}},
                {label = "Gangster 2", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money", e = ""}},
                {label = "Gangster 3", type = "attitude", data = {lib = "move_m@gangster@ng", anim = "move_m@gangster@ng", e = ""}},
                {label = "Gangster 4", type = "attitude", data = {lib = "move_m@gangster@var_e", anim = "move_m@gangster@var_e", e = ""}},
                {label = "Wspinaczka", type = "attitude", data = {lib = "move_m@hiking", anim = "move_m@hiking", e = ""}},
                {label = "Bezdomny", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a", e = ""}},
                {label = "Podpity", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed", e = ""}},
                {label = "Średnio Pijany", type = "attitude", data = {lib = "move_m@drunk@moderatedrunk", anim = "move_m@drunk@moderatedrunk", e = ""}},
                {label = "Bardzo Pijany", type = "attitude", data = {lib = "move_m@drunk@verydrunk", anim = "move_m@drunk@verydrunk", e = ""}},
                {label = "W pośpiechu 1", type = "attitude", data = {lib = "move_m@hurry_butch@b", anim = "move_m@hurry_butch@b", e = ""}},
                {label = "W pośpiechu 2", type = "attitude", data = {lib = "move_m@hurry@b", anim = "move_m@hurry@b", e = ""}},
                {label = "Szybki", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick", e = ""}},
                {label = "Dziwny", type = "attitude", data = {lib = "move_m@alien", anim = "move_m@alien", e = ""}},
                {label = "Uzbrojony", type = "attitude", data = {lib = "anim_group_move_ballistic", anim = "anim_group_move_ballistic", e = ""}},
                {label = "Arogancki", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a", e = ""}},
                {label = "Swagger", type = "attitude", data = {lib = "move_m@swagger", anim = "move_m@swagger", e = ""}},
            }
        },
        {
            name = 'porn',
            label = 'Pegi 21',
            items = {
                {label = "Dokowanie", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging", loop = 0, e = "dokowanie"}},
                {label = "Posuwanie", type = "anim", data = {lib = "timetable@trevor@skull_loving_bear", anim = "skull_loving_bear", loop = 1, e = "posuwanie"}},
                {label = "Gest walenia", type = "anim", data = {lib = "anim@mp_player_intupperdock", anim = "idle_a", loop = 57, e = "walenie"}},
                {label = "Walenie konia 1 [Pojazd]", type = "anim", data = {lib = "anim@mp_player_intincarwanklow@ps@", anim = "idle_a", loop = 1, e = "walenie2"}},
                {label = "Walenie konia 2 - na kogoś", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@wank", anim = "wank", loop = 0, e = "walenie3"}},   
                {label = "Eksponowanie wdzięków - przód", type = "anim", data = {lib = "mini@hookers_sp", anim = "ilde_b", loop = 1, e = "wdzieki"}},
                {label = "Eksponowanie wdzięków - tył", type = "anim", data = {lib = "mini@hookers_sp", anim = "ilde_c", loop = 1, e = "wdzieki2"}},
                {label = "Taniec erotyczny 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f", loop = 1, e = "erotyczny"}},
                {label = "Taniec erotyczny 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2", loop = 1, e = "erotyczny2"}},
                {label = "Taniec erotyczny 3", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3", loop = 1, e = "erotyczny3"}},
            }
        },
        {
            name = 'custom',
            label = 'Customowe',
            items = {
                {label = "Billy Bounce", type = "anim", data = {lib = "custom@billybounce", anim = "billybounce", loop = 1, e = "billybounce"}},
                {label = "Downward", type = "anim", data = {lib = "custom@downward_fortnite", anim = "downward_fortnite", loop = 1, e = "downward"}},
                {label = "Pullup", type = "anim", data = {lib = "custom@pullup", anim = "pullup", loop = 1, e = "pullup"}},
                {label = "Rollie", type = "anim", data = {lib = "custom@rollie", anim = "rollie", loop = 1, e = "rollie"}},
                {label = "Wanna see me", type = "anim", data = {lib = "custom@wanna_see_me", anim = "wanna_see_me", loop = 1, e = "wannaseeme"}},
                {label = "Arm Swirl", type = "anim", data = {lib = "custom@armswirl", anim = "armswirl", loop = 1, e = "armswirl"}},
                {label = "Arm Wave", type = "anim", data = {lib = "custom@armwave", anim = "armwave", loop = 1, e = "armwave"}},
                {label = "Circle Crunch", type = "anim", data = {lib = "custom@circle_crunch", anim = "circle_crunch", loop = 1, e = "circlecrunch"}},
                {label = "Dig", type = "anim", data = {lib = "custom@dig", anim = "dig", loop = 1, e = "dig"}},
                {label = "Gangnam Style", type = "anim", data = {lib = "custom@gangnamstyle", anim = "gangnamstyle", loop = 1, e = "gangnamstyle"}},
                {label = "Makarena", type = "anim", data = {lib = "custom@makarena", anim = "makarena", loop = 1, e = "makarena"}},
                {label = "Maraschino", type = "anim", data = {lib = "custom@maraschino", anim = "maraschino", loop = 1, e = "maraschino"}},
                {label = "Pick From Ground", type = "anim", data = {lib = "custom@pickfromground", anim = "pickfromground", loop = 1, e = "pickfromground"}},
                {label = "Salsa", type = "anim", data = {lib = "custom@salsa", anim = "salsa", loop = 1, e = "salsa"}},
                {label = "What", type = "anim", data = {lib = "custom@what_idk", anim = "what_idk", loop = 1, e = "whatidk"}},
                {label = "Taniec FN1", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance1", loop = 1, e = "fn1"}},
                {label = "Taniec FN2", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance2", loop = 1, e = "fn2"}},
                {label = "Taniec FN3", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance3", loop = 1, e = "fn3"}},
                {label = "Taniec FN4", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance4", loop = 1, e = "fn4"}},
                {label = "Taniec FN5", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance5", loop = 1, e = "fn5"}},
                {label = "Taniec FN6", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance6", loop = 1, e = "fn6"}},
                {label = "Taniec FN7", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance7", loop = 1, e = "fn7"}},
                {label = "Taniec FN8", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance8", loop = 1, e = "fn8"}},
                {label = "Taniec FN9", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance9", loop = 1, e = "fn9"}},
                {label = "Taniec FN10", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance10", loop = 1, e = "fn10"}},
                {label = "Taniec FN11", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance11", loop = 1, e = "fn11"}},
                {label = "Taniec FN12", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance12", loop = 1, e = "fn12"}},
                {label = "Taniec FN13", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance13", loop = 1, e = "fn13"}},
                {label = "Taniec FN14", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance14", loop = 1, e = "fn14"}},
                {label = "Taniec FN15", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance15", loop = 1, e = "fn15"}},
                {label = "Taniec FN16", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance16", loop = 1, e = "fn16"}},
                {label = "Taniec FN17", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance17", loop = 1, e = "fn17"}},
                {label = "Taniec FN18", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance18", loop = 1, e = "fn18"}},
                {label = "Taniec FN19", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance19", loop = 1, e = "fn19"}},
                {label = "Taniec FN20", type = "anim", data = {lib = "divined@fndances2@new", anim = "dfdance20", loop = 1, e = "fn20"}},
            }
        },
    },
    Synced = {
        {
            ['Label'] = 'Przytul',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Piątka',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.5,
                    ['yP'] = 1.25,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.9,
                    ['yR'] = 0.3,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Przytul po przyjacielsku',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.025,
                    ['yP'] = 1.15,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Żółwik',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_left', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_right', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.6,
                    ['yP'] = 0.9,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 270.0,
                }
            }
        },
        {
            ['Label'] = 'Podaj ręke (koleżeńskie)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.0,
                    ['yP'] = 1.2,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Podaj ręke (oficjalnie)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.075,
                    ['yP'] = 1.0,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Uderz',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_rear_lefthook', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_cross_r', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Uderz z liścia',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_slap', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_backslap', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Uderz z główki',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_headbutt', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_headbutt', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Gra w baseballa',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_a', ['Flags'] = 0,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_b', ['Flags'] = 0, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.5,
                    ['yP'] = 1.25,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.9,
                    ['yR'] = 0.3,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 1',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 2',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 3',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 4',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 5',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 6',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
        {
            ['Label'] = 'Wspólny taniec 7',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
    
        {
            ['Label'] = 'Wspólny taniec 8',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 1.15,
                    ['zP'] = -0.05,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
    
        {
            ['Label'] = 'Pocałuj',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'cs_lestercrest_3_dual-20', ['Flags'] = 1,
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'csb_georginacheng_dual-20', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 0,
                    ['xP'] = 0.0,
                    ['yP'] = 0.53,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            }
        },
    
        {
            ['Label'] = 'Obejmowanie',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_chad', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = -0.07,
                    ['yP'] = 0.63,
                    ['zP'] = 0.00,
    
                    ['xR'] = 0.0,
                    ['yR'] = 0.53,
                    ['zR'] = 180.0,
                    }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2chad_goodbye', ['Anim'] = 'chad_armsaround_girl', ['Flags'] = 1
            },
        },
    
        {
            ['Label'] = 'Zrób loda (na stojąco)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_hooker', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.0,
                    ['yP'] = 0.65,
                    ['zP'] = 0.0,
    
                    ['xR'] = 120.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_punter', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = 'Sex (na stojąco)',
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_hooker', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.05,
                    ['yP'] = 0.4,
                    ['zP'] = 0.0,
    
                    ['xR'] = 120.0,
                    ['yR'] = 0.0,
                    ['zR'] = 180.0,
                }
            },
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_pimp', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = 'Anal (na stojąco)', 
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_a', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_poppy', ['Flags'] = 1, ['Attach'] = {
                    ['Bone'] = 9816,
                    ['xP'] = 0.015,
                    ['yP'] = 0.35,
                    ['zP'] = 0.0,
    
                    ['xR'] = 0.9,
                    ['yR'] = 0.3,
                    ['zR'] = 0.0,
                },
            },
        },
        {
            ['Label'] = "Uprawiaj sex (pojazd)", 
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_m', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_f', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = "Uprawiaj sex 2 (pojazd)", 
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_f', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_m', ['Flags'] = 1,
            },
        },
        {
            ['Label'] = "Zrób loda (pojazd)", 
            ['Car'] = true,
            ['Requester'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'm_blow_job_loop', ['Flags'] = 1,
            }, 
            ['Accepter'] = {
                ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'f_blow_job_loop', ['Flags'] = 1,
            },
        },
    }
}

Config['airdrops'] = {
    ClaimingTime = 4, -- W minutach
    TimeToDrop = 5, -- W minutach

    Locs = {
        vec3(2065.7024, 1876.9485, 93.1064),
        vec3(2947.7107, 2747.3440, 43.4348),
        vec3(2188.4268, 3326.5425, 46.0703),
        vec3(2483.0432, 3760.6526, 41.7011),
        vec3(1093.1664, 2308.8904, 45.5128),
        vec3(108.3395, -1943.1023, 20.8037),
        vec3(89.2516, -2217.0999, 6.0574),
        vec3(-745.8962, -1468.7855, 5.0005)
    },

    DropProp = 'p_secret_weapon_02',

    AirCraft = {
        PilotModel = 's_m_m_pilot_01',
        PlaneModel = 'titan',
        Height = 450.0,
        Speed = 8.0
    },

    Loot = {
        ['vintagepistol'] = {
            count = math.random(10, 15),
            chance = 50
        },
        ['energydrink'] = {
            count = math.random(30, 50),
            chance = 60
        },
        ['pistol_ammo'] = {
            count = math.random(400, 600),
            chance = 100
        }
    },

    intervalBetweenAirdrops = 30, -- W minutach
    aircraftSpawnPoint = vec3(3562.5, 1356.43, 450.0)
}

Config['radio'] = {
    Controls = {
        Activator = { -- Open/Close Radio
            Name = "INPUT_REPLAY_START_STOP_RECORDING_SECONDARY", -- Control name
            Key = 289, -- F2
        },
        Secondary = {
            Name = "INPUT_SPRINT",
            Key = 21, -- Left Shift
            Enabled = true, -- Require secondary to be pressed to open radio with Activator
        },
        Toggle = { -- Toggle radio on/off
            Name = "INPUT_CONTEXT", -- Control name
            Key = 51, -- E
        },
        Increase = { -- Increase Frequency
            Name = "INPUT_CELLPHONE_RIGHT", -- Control name
            Key = 175, -- Right Arrow
            Pressed = false,
        },
        Decrease = { -- Decrease Frequency
            Name = "INPUT_CELLPHONE_LEFT", -- Control name
            Key = 174, -- Left Arrow
            Pressed = false,
        },
        Input = { -- Choose Frequency
            Name = "INPUT_FRONTEND_ACCEPT", -- Control name
            Key = 201, -- Enter
            Pressed = false,
        },
        Broadcast = {
            Name = "INPUT_CHARACTER_WHEEL", -- Control name
            Key = 19, -- Caps Lock
        },
        ToggleClicks = { -- Toggle radio click sounds
            Name = "INPUT_SELECT_WEAPON", -- Control name
            Key = 37, -- Tab
        }
    },
    Frequency = {
        Private = {},
        Current = 100, -- Don't touch
        CurrentIndex = 100, -- Don't touch
        Min = 1, -- Minimum frequency
        Max = 1000, -- Max number of frequencies
        List = {}, -- Frequency list, Don't touch
        Access = {}, -- List of freqencies a player has access to
    },
    Frequencyname = {},
    RestrictedOffset = 0,
    RestrictedFrequencies = {},
    AllowRadioWhenClosed = true -- Allows the radio to be used when not open (uses police radio animation) 
}

Config['carhud'] = {
	Directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N' },
    Zones = {
        ['AIRP'] = 'Los Santos Airport',
        ['ALAMO'] = 'Alamo Sea',
        ['ALTA'] = 'Alta',
        ['ARMYB'] = 'Fort Zancudo',
        ['BANHAMC'] = 'Banham Canyon Dr',
        ['BANNING'] = 'Banning',
        ['BEACH'] = 'Vespucci Beach',
        ['BHAMCA'] = 'Banham Canyon',
        ['BRADP'] = 'Braddock Pass',
        ['BRADT'] = 'Braddock Tunnel',
        ['BURTON'] = 'Burton',
        ['CALAFB'] = 'Calafia Bridge',
        ['CANNY'] = 'Raton Canyon',
        ['CCREAK'] = 'Cassidy Creek',
        ['CHAMH'] = 'Chamberlain Hills',
        ['CHIL'] = 'Vinewood Hills',
        ['CHU'] = 'Chumash',
        ['CMSW'] = 'Chiliad Mountain',
        ['CYPRE'] = 'Cypress Flats',
        ['DAVIS'] = 'Davis',
        ['DELBE'] = 'Del Perro Beach',
        ['DELPE'] = 'Del Perro',
        ['DELSOL'] = 'La Puerta',
        ['DESRT'] = 'Grand Senora Desert',
        ['DOWNT'] = 'Downtown',
        ['DTVINE'] = 'Downtown Vinewood',
        ['EAST_V'] = 'East Vinewood',
        ['EBURO'] = 'El Burro Heights',
        ['ELGORL'] = 'El Gordo Lighthouse',
        ['ELYSIAN'] = 'Elysian Island',
        ['GALFISH'] = 'Galilee',
        ['GOLF'] = 'GWC and Golfing Society',
        ['GRAPES'] = 'Grapeseed',
        ['GREATC'] = 'Great Chaparral',
        ['HARMO'] = 'Harmony',
        ['HAWICK'] = 'Hawick',
        ['HORS'] = 'Vinewood Racetrack',
        ['HUMLAB'] = 'Humane Labs and Research',
        ['JAIL'] = 'Bolingbroke Penitentiary',
        ['KOREAT'] = 'Little Seoul',
        ['LACT'] = 'Land Act Reservoir',
        ['LAGO'] = 'Lago Zancudo',
        ['LDAM'] = 'Land Act Dam',
        ['LEGSQU'] = 'Legion Square',
        ['LMESA'] = 'La Mesa',
        ['LOSPUER'] = 'La Puerta',
        ['MIRR'] = 'Mirror Park',
        ['MORN'] = 'Morningwood',
        ['MOVIE'] = 'Richards Majestic',
        ['MTCHIL'] = 'Mount Chiliad',
        ['MTGORDO'] = 'Mount Gordo',
        ['MTJOSE'] = 'Mount Josiah',
        ['MURRI'] = 'Murrieta Heights',
        ['NCHU'] = 'North Chumash',
        ['NOOSE'] = 'N.O.O.S.E',
        ['OCEANA'] = 'Pacific Ocean',
        ['PALCOV'] = 'Paleto Cove',
        ['PALETO'] = 'Paleto Bay',
        ['PALFOR'] = 'Paleto Forest',
        ['PALHIGH'] = 'Palomino Highlands',
        ['PALMPOW'] = 'Palmer-Taylor Power Station',
        ['PBLUFF'] = 'Pacific Bluffs',
        ['PBOX'] = 'Pillbox Hill',
        ['PROCOB'] = 'Procopio Beach',
        ['RANCHO'] = 'Rancho',
        ['RGLEN'] = 'Richman Glen',
        ['RICHM'] = 'Richman',
        ['ROCKF'] = 'Rockford Hills',
        ['RTRAK'] = 'Redwood Lights Track',
        ['SANAND'] = 'San Andreas',
        ['SANCHIA'] = 'San Chianski Mountain Range',
        ['SANDY'] = 'Sandy Shores',
        ['SKID'] = 'Mission Row',
        ['SLAB'] = 'Stab City',
        ['STAD'] = 'Maze Bank Arena',
        ['STRAW'] = 'Strawberry',
        ['TATAMO'] = 'Tataviam Mountains',
        ['TERMINA'] = 'Terminal',
        ['TEXTI'] = 'Textile City',
        ['TONGVAH'] = 'Tongva Hills',
        ['TONGVAV'] = 'Tongva Valley',
        ['VCANA'] = 'Vespucci Canals',
        ['VESP'] = 'Vespucci',
        ['VINE'] = 'Vinewood',
        ['WINDF'] = 'Ron Alternates Wind Farm',
        ['WVINE'] = 'West Vinewood',
        ['ZANCUDO'] = 'Zancudo River',
        ['ZP_ORT'] = 'Port of South Los Santos',
        ['ZQ_UAR'] = 'Davis Quartz'
    }
}

Config['garages'] = {
    towPrice = 2500,
    normal = {
        {
            coords = vector3(2523.5657, 2596.6631, 37.9449), -- dino
            blip = true
        },
        {
            coords = vector3(152.4143, 6613.8638, 31.8700),  -- przy sklepie na paleto
            blip = true
        },
        {
            coords = vector3(11.9025, 6332.3003, 31.2394), -- paleto (3017)
            blip = true
        },
        {
            coords = vector3(-758.0901, 5536.3569, 33.4848), -- paleto (3003)
            blip = true
        },
        {
            coords = vector3(296.6949, -606.3264, 43.2488), -- szpital pillbox
            blip = false
        },
        {
            coords = vector3(257.6767, -773.9704, 30.6708), -- glowny
            blip = true
        },
        {
            coords = vector3(30.9780, -860.9664, 30.5740), -- stary glowny
            blip = true
        },
        {
            coords = vector3(-332.4732, -745.4465, 33.9679), -- czerwony parking
            blip = true
        },
        {
            coords = vector3(129.1667, -1072.1641, 29.1927), -- za glowna flecca
            blip = false
        },
        {
            coords = vector3(328.2223, -204.9108, 54.0866), -- melina
            blip = true
        },
        {
            coords = vector3(1121.8907, 2653.5437, 37.9976), -- motel przy sandy (939)
            blip = true
        },
        {
            coords = vector3(360.2765, 2634.8787, 44.4961), -- domki przy sandy (925)
            blip = true
        },
        {
            coords = vector3(-1480.8367, -661.2910, 28.9435), -- motel w miescie (619)
            blip = false
        },
        {
            coords = vector3(-1326.7988, -926.7612, 11.2021), -- motel w miescie great rooms (312)
            blip = true
        },
        {
            coords = vector3(-358.6519, 30.0938, 47.7923), -- motel w miescie (538)
            blip = true
        },
        {
            coords = vector3(-1569.5464, -241.4055, 49.4767), -- mieszkania (633)
            blip = false
        },
        {
            coords = vector3(552.6882, -1792.9302, 29.1970), -- mieszkania (159)
            blip = false
        },
        {
            coords = vector3(-565.9255, 314.9688, 84.3990), -- za tequilala
            blip = true
        },
        {
            coords = vector3(1024.1348, -776.7465, 57.9715), -- mirror park
            blip = true
        },
        {
            coords = vector3(1369.1658, -579.8720, 74.3803), -- mirror park patelnia
            blip = true
        },
        {
            coords = vector3(1488.9847, 3743.4568, 33.8313), -- sandy shores
            blip = true
        },
        {
            coords = vector3(1865.2791, 2621.8091, 45.6726), -- więzienie
            blip = true
        },
        {
            coords = vector3(-3145.9792, 1090.2747, 20.6941), -- lewa autostrada przy sklepach (908-907)
            blip = true
        },
        {
            coords = vector3(-2204.5908, 4252.4746, 47.5080), -- lewa autostrada (2001)
            blip = true
        },
        {
            coords = vector3(609.8741, 115.9386, 92.9785), -- przy komendzie vinewood (597)
            blip = true
        },
        {
            coords = vector3(-185.5608, -1291.5195, 31.2965), -- przy benny's
            blip = true
        },
        {
            coords = vector3(-1035.2920, -2727.6099, 20.1510), -- lotnisko
            blip = true
        },
        {
            coords = vector3(-51.1986, -1116.0376, 26.6703), -- car dealer
            blip = true
        },
        {
            coords = vector3(-930.6144, -166.2110, 41.8798), -- przy life invader
            blip = true
        },
        {
            coords = vector3(274.4519, -325.3701, 44.9198), -- przy kasynie (584)
            blip = false
        },
        {
            coords = vector3(-2043.5099, -454.8793, 11.4164), -- przy plazy (604)
            blip = true
        },
        {
            coords = vector3(-1705.7944, -905.1562, 7.7361), -- przy plazy (610)
            blip = true
        },
        {
            coords = vector3(-1196.1290, -1488.5060, 4.3799), -- przy plazy (307)
            blip = true
        },
        {
            coords = vector3(-1570.4700, -1019.7047, 13.0187), -- molo
            blip = false
        },
        {
            coords = vector3(-1655.6620, -221.0213, 55.0319), -- kosciół
            blip = true
        },
        {
            coords = vector3(-969.7864, -1478.9086, 5.0189), -- przy rybaku (329)
            blip = false
        },
        {
            coords = vector3(-585.4651, -1117.5867, 22.1789), -- przy budowie (374)
            blip = false
        },
        {
            coords = vector3(1009.3659, -2331.9272, 30.5096), -- przy dokach (64)
            blip = true
        },
        {
            coords = vector3(-1524.2726, -433.5787, 35.4421), -- przy drugim mechaniku (625)
            blip = true
        },
        {
            coords = vector3(-1474.6267, -503.2925, 32.8068), -- przy drugim mechaniku (627)
            blip = false
        },
        {
            coords = vector3(386.7624, -1655.8242, 27.3099), -- garaz przy davis (627)
            blip = true
        },
        {
            coords = vector3(22.0085, -1730.8401, 29.3029), -- techniczny
            blip = true
        },
        {
            coords = vector3(-411.4605, 1212.2336, 325.6419), -- obserwatorium
            blip = true
        },
        {
            coords = vector3(639.2640, 596.9863, 128.9108), -- vinewood bowl
            blip = true
        },
        {
            coords = vector3(1709.9761, 4803.9849, 42.0644), -- grapeseed (215)
            blip = true
        },

        {
            coords = vector3(2704.5103, -381.8434, -55.3049), -- organizacyjny (presonale)
            blip = false
        },
    }
}

Config['vehicle-list'] = {

-- Motocykle

    ['faggio2'] = {
        label = 'Faggio',
        class = 'Motocykle',
        price = 30000,
    },
    ['daemon'] = {
        label = 'Daemon',
        class = 'Motocykle',
        price = 70000,
    },
    ['daemon2'] = {
        label = 'Daemon 2',
        class = 'Motocykle',
        price = 80000,
    },
    ['manchez'] = {
        label = 'Manchez',
        class = 'Motocykle',
        price = 120000,
    },
    ['enduro'] = {
        label = 'Enduro',
        class = 'Motocykle',
        price = 140000,
    },
    ['bf400'] = {
        label = 'BF 400',
        class = 'Motocykle',
        price = 180000,
    },
    ['bati2'] = {
        label = 'Bati',
        class = 'Motocykle',
        price = 200000,
    },

-- Compact

    ['caddy2'] = {
        label = 'Caddy 2',
        class = 'Compact',
        price = 40000,
        backEngine = true
    },
    ['panto'] = {
        label = 'Panto',
        class = 'Compact',
        price = 70000,
        backEngine = false
    },
    ['brioso'] = {
        label = 'brioso',
        class = 'Compact',
        price = 90000,
        backEngine = false
    },
    ['issi2'] = {
        label = 'Issi2',
        class = 'Compact',
        price = 110000,
        backEngine = false
    },
    ['blista'] = {
        label = 'Blista',
        class = 'Compact',
        price = 130000,
        backEngine = false
    },
    ['prairie'] = {
        label = 'Prairie',
        class = 'Compact',
        price = 150000,
        backEngine = false
    },
    ['issi8'] = {
        label = 'Issi 8',
        class = 'Compact',
        price = 200000,
        backEngine = false
    },

-- Muscle

    ['chino'] = {
        label = 'Chino',
        class = 'Muscle',
        price = 120000,
        backEngine = false
    },
    ['blade'] = {
        label = 'Blade',
        class = 'Muscle',
        price = 130000,
        backEngine = false
    },
    ['faction2'] = {
        label = 'Faction 2',
        class = 'Muscle',
        price = 140000,
        backEngine = false
    },
    ['tampa'] = {
        label = 'Tampa',
        class = 'Muscle',
        price = 150000,
        backEngine = false
    },
    ['sabregt'] = {
        label = 'Sabre GT',
        class = 'Muscle',
        price = 160000,
        backEngine = false
    },
    ['yosemite'] = {
        label = 'Yosemite',
        class = 'Muscle',
        price = 160000,
        backEngine = false
    },
    ['yosemite2'] = {
        label = 'Yosemite 2',
        class = 'Muscle',
        price = 170000,
        backEngine = false
    },
    ['moonbeam'] = {
        label = 'Moonbeam',
        class = 'Muscle',
        price = 190000,
        backEngine = false
    },
    ['nightshade'] = {
        label = 'Nightshade',
        class = 'Muscle',
        price = 200000,
        backEngine = false
    },
    ['dominator7'] = {
        label = 'Dominator 7',
        class = 'Muscle',
        price = 230000,
        backEngine = false
    },
    ['gauntlet'] = {
        label = 'Gauntlet',
        class = 'Muscle',
        price = 240000,
        backEngine = false
    },
    ['dominator'] = {
        label = 'Dominator',
        class = 'Muscle',
        price = 260000,
        backEngine = false
    },
    ['dominator3'] = {
        label = 'Dominator3',
        class = 'Muscle',
        price = 300000,
        backEngine = false
    },

-- Sedan

    ['warrener'] = {
        label = 'Warrener',
        class = 'Sedan',
        price = 300000,
        backEngine = false
    },
    ['primo2'] = {
        label = 'Primo 2',
        class = 'Sedan',
        price = 330000,
        backEngine = false
    },
    ['tailgater'] = {
        label = 'Tailgater',
        class = 'Sedan',
        price = 350000,
        backEngine = false
    },
    ['tailgater2'] = {
        label = 'Tailgater 2',
        class = 'Sedan',
        price = 400000,
        backEngine = false
    },
    ['fugitive'] = {
        label = 'Fugitive',
        class = 'Sedan',
        price = 430000,
        backEngine = false
    },

-- SUV

    ['habanero'] = {
        label = 'Habanero',
        class = 'SUV',
        price = 400000,
        backEngine = false
    },
    ['huntley'] = {
        label = 'Huntley',
        class = 'SUV',
        price = 420000,
        backEngine = false
    },
    ['landstalker'] = {
        label = 'Landstalker',
        class = 'SUV',
        price = 440000,
        backEngine = false
    },
    ['baller2'] = {
        label = 'Baller 2',
        class = 'SUV',
        price = 440000,
        backEngine = false
    },
    ['baller3'] = {
        label = 'Baller 3',
        class = 'SUV',
        price = 460000,
        backEngine = false
    },
    ['baller6'] = {
        label = 'Baller 6',
        class = 'SUV',
        price = 530000,
        backEngine = false
    },
    ['novak'] = {
        label = 'Novak',
        class = 'SUV',
        price = 560000,
        backEngine = false
    },
    ['toros'] = {
        label = 'Toros',
        class = 'SUV',
        price = 590000,
        backEngine = false
    },
    ['rebla'] = {
        label = 'Rebla',
        class = 'SUV',
        price = 6300000,
        backEngine = false
    },
    ['xls2'] = {
        label = 'XLS 2',
        class = 'SUV',
        price = 700000,
        backEngine = false
    },

-- Offroad

    ['bjxl'] = {
        label = 'BJXL',
        class = 'Offroad',
        price = 400000,
        backEngine = false
    },
    ['mesa'] = {
        label = 'Mesa',
        class = 'Offroad',
        price = 400000,
        backEngine = false
    },
    ['freecrawler'] = {
        label = 'Freecrawler',
        class = 'Offroad',
        price = 440000,
        backEngine = false
    },
    ['contender'] = {
        label = 'Contender',
        class = 'Offroad',
        price = 450000,
        backEngine = false
    },
    ['dubsta'] = {
        label = 'Dubsta',
        class = 'Offroad',
        price = 500000,
        backEngine = false
    },
    ['everon'] = {
        label = 'Everon',
        class = 'Offroad',
        price = 5300000,
        backEngine = false
    },
    ['brawler'] = {
        label = 'brawler',
        class = 'Offroad',
        price = 600000,
        backEngine = false
    },
    ['patriot'] = {
        label = 'Patriot',
        class = 'Offroad',
        price = 650000,
        backEngine = false
    },
    ['kamacho'] = {
        label = 'Kamacho',
        class = 'Offroad',
        price = 650000,
        backEngine = false
    },
    ['dubsta2'] = {
        label = 'Dubsta 2',
        class = 'Offroad',
        price = 700000,
        backEngine = false
    },

-- Sportowe

    ['drafter'] = {
        label = 'Drafter',
        class = 'Sportowe',
        price = 700000,
        backEngine = false
    },
    ['comet2'] = {
        label = 'Comet 2',
        class = 'Sportowe',
        price = 720000,
        backEngine = false
    },
    ['pariah'] = {
        label = 'Pariah',
        class = 'Sportowe',
        price = 740000,
        backEngine = false
    },
    ['elegy2'] = {
        label = 'Elegy 2',
        class = 'Sportowe',
        price = 770000,
        backEngine = false
    },
    ['schlagen'] = {
        label = 'Schlagen',
        class = 'Sportowe',
        price = 790000,
        backEngine = false
    },
    ['jester4'] = {
        label = 'Jester 4',
        class = 'Sportowe',
        price = 800000,
        backEngine = false
    },
    ['vstr'] = {
        label = 'VSTR',
        class = 'Sportowe',
        price = 820000,
        backEngine = false
    },
    ['sugoi'] = {
        label = 'Sugoi',
        class = 'Sportowe',
        price = 820000,
        backEngine = false
    },
    ['bestiagts'] = {
        label = 'Bestia GTS',
        class = 'Sportowe',
        price = 840000,
        backEngine = false
    },
    ['italigto'] = {
        label = 'Italigto',
        class = 'Sportowe',
        price = 860000,
        backEngine = false
    },
    ['paragon2'] = {
        label = 'Paragon 2',
        class = 'Sportowe',
        price = 880000,
        backEngine = false
    },
    ['zr350'] = {
        label = 'ZR 350',
        class = 'Sportowe',
        price = 900000,
        backEngine = false
    },
    ['buffalo'] = {
        label = 'Buffalo',
        class = 'Sportowe',
        price = 930000,
        backEngine = false
    },
    ['carbonizzare'] = {
        label = 'Carbonizzare',
        class = 'Sportowe',
        price = 950000,
        backEngine = false
    },
    ['raiden'] = {
        label = 'Raiden',
        class = 'Sportowe',
        price = 980000,
        backEngine = false
    },
    ['cypher'] = {
        label = 'Cypher',
        class = 'Sportowe',
        price = 1000000,
        backEngine = false
    },
    ['coquette4'] = {
        label = 'Coquette 4',
        class = 'Sportowe',
        price = 1100000,
        backEngine = true
    },
    ['growler'] = {
        label = 'Growler',
        class = 'Sportowe',
        price = 1100000,
        backEngine = false
    },
    ['italirsx'] = {
        label = 'Italirsx',
        class = 'Sportowe',
        price = 1200000,
        backEngine = true
    },
    ['kuruma'] = {
        label = 'Kuruma',
        class = 'Sportowe',
        price = 1500000,
        backEngine = false
    },
    ['sultan2'] = {
        label = 'Sultan 2',
        class = 'Sportowe',
        price = 1200000,
        backEngine = false
    },

-- Supersportowe

    ['vacca'] = {
        label = 'Vacca',
        class = 'Supersportowe',
        price = 1200000,
        backEngine = true
    },
    ['comet6'] = {
        label = 'Comet 6',
        class = 'Supersportowe',
        price = 1200000,
        backEngine = true
    },
    ['sultanrs'] = {
        label = 'Sultan RS',
        class = 'Supersportowe',
        price = 1400000,
        backEngine = false
    },
    ['nero'] = {
        label = 'Nero',
        class = 'Supersportowe',
        price = 1500000,
        backEngine = true
    },
    ['adder'] = {
        label = 'Adder',
        class = 'Supersportowe',
        price = 1600000,
        backEngine = true
    },
    ['xa21'] = {
        label = 'XA 21',
        class = 'Supersportowe',
        price = 1600000,
        backEngine = true
    },
    ['entity2'] = {
        label = 'Entity 2',
        class = 'Supersportowe',
        price = 1700000,
        backEngine = true
    },
    ['zorrusso'] = {
        label = 'Zorrusso',
        class = 'Supersportowe',
        price = 1800000,
        backEngine = true
    },
    ['emerus'] = {
        label = 'Emerus',
        class = 'Supersportowe',
        price = 1800000,
        backEngine = true
    },
    ['turismor'] = {
        label = 'Turismor',
        class = 'Supersportowe',
        price = 1900000,
        backEngine = true
    },
    ['zentorno'] = {
        label = 'Zentorno',
        class = 'Supersportowe',
        price = 2000000,
        backEngine = true
    },
}

Config['vehicle-shop'] = {
    places = {
        vector3(-37.0990, -1093.2637, 27.3023),
        vector3(-42.3298, -1101.4249, 27.3023),
        vector3(-47.6121, -1092.0576, 27.3023),
        vector3(-54.6330, -1096.9486, 27.3023),
        vector3(-49.9084, -1083.7484, 27.3023),
    },
    exitVeh = vector4(-23.5790, -1094.4310, 27.3052, 343.2402),
    vehicles = {
        ["Motocykle"] = {},
        ["Compact"] = {},
        ["Muscle"] = {},
        ["Sedan"] = {},
        ["SUV"] = {},
        ["Offroad"] = {},
        ["Sportowe"] = {},
        ["Supersportowe"] = {},
    }
}

for model, data in pairs(Config['vehicle-list']) do
    Config['vehicle-shop'].vehicles[data.class][#Config['vehicle-shop'].vehicles[data.class]+1] = {name = data.label, model = model, price = data.price}
end

Config['cardamage'] = {
    deformationMultiplier = 1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.2,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.3,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 5.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 5.0,					    -- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 47.0,				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.6,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 0.3,				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 7,			    -- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 5.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 500.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 300.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 100.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	compatibilityMode = true,					-- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)

	classDamageMultiplier = {
		[0] = 1.0,		--	0: Compacts
        [1] = 1.0,		--	1: Sedans
        [2] = 0.6,		--	2: SUVs
        [3] = 1.0,		--	3: Coupes
        [4] = 1.0,		--	4: Muscle
        [5] = 1.0,		--	5: Sports Classics
        [6] = 1.0,		--	6: Sports
        [7] = 1.0,		--	7: Super
        [8] = 0.25,		--	8: Motorcycles
        [9] = 0.7,		--	9: Off-road
        [10] = 0.25,	--	10: Industrial
        [11] = 1.0,		--	11: Utility
        [12] = 1.0,		--	12: Vans
        [13] = 1.0,		--	13: Cycles
        [14] = 0.5,		--	14: Boats
        [15] = 1.0,		--	15: Helicopters
        [16] = 1.0,		--	16: Planes
        [17] = 1.0,		--	17: Service
        [18] = 0.75,	--	18: Emergency
        [19] = 0.75,    --	19: Military
        [20] = 1.0,	    --	20: Commercial
        [21] = 1.0	    --	21: Trains
	}
}

Config['duels'] = {
    SearchLocs = {
        vector3(987.6542, -2548.6191, 28.3020-0.95)
    }
}