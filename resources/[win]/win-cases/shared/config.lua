Config = {}

Config.DiscordServerID = 748183374241464330 --dsc clwns

Config.Categories = {
    chances = {
        ["common"] = 60,
        ["rare"] = 32,
        ["mythical"] = 6,
        ["legendary"] = 2
    },
}

Config.premium = {
    {
        label = "SMG Case",
        CaseImage = "cases/pinky.png",
        ItemImageAboveCaseImage = "cases/pinky-item.png",
        price = 200,
        inBanner = true,
        drop = {
            ["common"] = {
                {itemName = "vest_light", label = "Kamizelka lekka x50", sellCredit = 50, itemCount = 50, giveItemType = "item", image = "items/vest_light.png"},
                {itemName = "smg_ammo", label = "Amunicja do SMG x200", sellCredit = 50, itemCount = 200, giveItemType = "item", image = "items/smg_ammo.png"},
                {itemName = "energydrink", label = "Redbull x60", sellCredit = 50, itemCount = 60, giveItemType = "item", image = "items/energydrink.png"},
                {itemName = "money", label = "200 000$", sellCredit = 50, itemCount = 200000, giveItemType = "money", image = "items/money-1.png"},
            },
            ["rare"] = {
                {itemName = "codeine_pooch", label = "Kodeina x50", sellCredit = 80, itemCount = 50, giveItemType = "item", image = "items/codeine_pooch.png"},
                {itemName = "scope", label = "Mały celownik", sellCredit = 100, itemCount = 1, giveItemType = "item", image = "items/scope.png"},
                {itemName = "suppressor2", label = "Tłumik V2", sellCredit = 100, itemCount = 1, giveItemType = "item", image = "items/suppressor2.png"},
                {itemName = "extendedclip2", label = "Powiększony magazynek V2", sellCredit = 100, itemCount = 1, giveItemType = "item", image = "items/extendedclip2.png"},
                {itemName = "vest_medium", label = "Kamizelka średnia x40", sellCredit = 80, itemCount = 40, giveItemType = "item", image = "items/vest_medium.png"},
            },
            ["mythical"] = {
                {itemName = "vest_heavy", label = "Kamizelka ciężka x30", sellCredit = 200, itemCount = 30, giveItemType = "item", image = "items/vest_heavy.png"},
                {itemName = "minismg", label = "Mini SMG", sellCredit = 400, itemCount = 1, giveItemType = "item", image = "items/minismg.png"},
                {itemName = "scope2", label = "Duży celownik", sellCredit = 200, itemCount = 1, giveItemType = "item", image = "items/scope.png"},
            },
            ["legendary"] = {
                {itemName = "microsmg", label = "Micro SMG", sellCredit = 600, itemCount = 1, giveItemType = "item", image = "items/microsmg.png"},
                {itemName = "smg_mk2", label = "SMG (MK II)", sellCredit = 600, itemCount = 1, giveItemType = "item", image = "items/smg_mk2.png"},
            }
        }
    },
    {
        label = "Crime Case",
        CaseImage = "cases/crime.png",
        ItemImageAboveCaseImage = "cases/crime-item.png",
        price = 150,
        inBanner = false,
        drop = {
            ["common"] = {
                {itemName = "energydrink", label = "Redbull x50", sellCredit = 50, itemCount = 50, giveItemType = "item", image = "items/energydrink.png"},
                {itemName = "repairkit", label = "Naprawka x10", sellCredit = 50, itemCount = 10, giveItemType = "item", image = "items/repairkit.png" },
                {itemName = "radiocrime", label = "Radio x15", sellCredit = 50, itemCount = 15, giveItemType = "item", image = "items/radiocrime.png" },
                {itemName = "rob_laptop", label = "Laptop do hackowania x5", sellCredit = 50, itemCount = 5, giveItemType = "item", image = "items/rob_laptop.png" },
                {itemName = "rob_lifeinvader", label = "Łom do napadu x3", sellCredit = 50, itemCount = 3, giveItemType = "item", image = "items/rob_lifeinvader.png" },
                {itemName = "handcuffs", label = "Kajdanki x5", sellCredit = 50, itemCount = 5, giveItemType = "item", image = "items/handcuffs.png" },
                {itemName = "weed_pooch", label = "Marihuana x750", sellCredit = 50, itemCount = 750, giveItemType = "item", image = "items/weed_pooch.png"},
                {itemName = "panto", label = "Panto", sellCredit = 70, itemCount = 1, giveItemType = "vehicle", image = "items/panto.png"},
                {itemName = "cheburek", label = "Cheburek", sellCredit = 70, itemCount = 1, giveItemType = "vehicle", image = "items/cheburek.png"},
            },
            ["rare"] = {
                {itemName = "handcuffs", label = "Kajdanki x25", sellCredit = 80, itemCount = 25, giveItemType = "item", image = "items/handcuffs.png"},
                {itemName = "pistol_ammo", label = "Ammunicja x250", sellCredit = 80, itemCount = 250, giveItemType = "item", image = "items/pistol_ammo.png"},
                {itemName = "codeine_pooch", label = "Kodeina x50", sellCredit = 80, itemCount = 50, giveItemType = "item", image = "items/codeine_pooch.png"},
                {itemName = "heroin_pooch", label = "Heroina x1750", sellCredit = 80, itemCount = 1750, giveItemType = "item", image = "items/heroin_pooch.png"},
                --{itemName = "meth_pooch", label = "Meta x2000", sellCredit = 80, itemCount = 2000, giveItemType = "item", image = "items/meth_pooch.png"},
                {itemName = "coke_pooch", label = "Kokaina x2500", sellCredit = 80, itemCount = 2500, giveItemType = "item", image = "items/coke_pooch.png"},
                {itemName = "vest_light", label = "Kamizelka lekka x75", sellCredit = 80, itemCount = 75, giveItemType = "item", image = "items/vest_light.png"},
                {itemName = "vest_medium", label = "Kamizelka średnia x50", sellCredit = 80, itemCount = 50, giveItemType = "item", image = "items/vest_medium.png"},
                {itemName = "vest_heavy", label = "Kamizelka ciężka x10", sellCredit = 80, itemCount = 10, giveItemType = "item", image = "items/vest_heavy.png"},
                {itemName = "kamacho", label = "Kamacho", sellCredit = 80, itemCount = 1, giveItemType = "vehicle", image = "items/kamacho.png"},
            },
            ["mythical"] = {
                {itemName = "money", label = "2 750 000$", sellCredit = 150, itemCount = 2750000, giveItemType = "money", image = "items/money-3.png"},
                {itemName = "ceramicpistol", label = "Pistolet Ceramiczny x20", sellCredit = 150, itemCount = 20, giveItemType = "item", image = "items/ceramicpistol.png"},
                {itemName = "vintagepistol", label = "Pistolet Vintage x20", sellCredit = 150, itemCount = 20, giveItemType = "item", image = "items/vintagepistol.png"},
                {itemName = "vest_heavy", label = "Kamizelka ciężka x30", sellCredit = 150, itemCount = 30, giveItemType = "item", image = "items/vest_heavy.png"},
            },
            ["legendary"] = {
                {itemName = "h1v2", label = "Hummer H1", sellCredit = 300, itemCount = 1, giveItemType = "vehicle", image = "items/h1v2.png"},
                {itemName = "money", label = "6 000 000$", sellCredit = 300, itemCount = 6000000, giveItemType = "money", image = "items/money-4.png"},
            }
        }
    },
    {
        label = "Pistol Case",
        CaseImage = "cases/pistol.png",
        ItemImageAboveCaseImage = "cases/pistol-item.png",
        price = 50,
        inBanner = false,
        drop = {
            ["common"] = {
                {itemName = "pistol", label = "Pistolet x8", sellCredit = 15, itemCount = 8, giveItemType = "item", image = "items/pistol.png"},
                {itemName = "snspistol", label = "Pistolet SNS x5", sellCredit = 15, itemCount = 5, giveItemType = "item", image = "items/snspistol.png"},
                {itemName = "pistol_ammo", label = "Amunicja x200", sellCredit = 15, itemCount = 200, giveItemType = "item", image = "items/pistol_ammo.png"},
                {itemName = "flashlight", label = "Latarka x5", sellCredit = 15, itemCount = 5, giveItemType = "item", image = "items/flashlight.png"},
            },
            ["rare"] = {
                {itemName = "pistol_mk2", label = "Pistolet MK II x15", sellCredit = 30, itemCount = 15, giveItemType = "item", image = "items/pistol_mk2.png"},
                {itemName = "snspistol_mk2", label = "Pistolet SNS MK II x5", sellCredit = 30, itemCount = 5, giveItemType = "item", image = "items/snspistol_mk2.png"},
                {itemName = "vintagepistol", label = "Pistolet Vintage x5", sellCredit = 30, itemCount = 5, giveItemType = "item", image = "items/vintagepistol.png"},
                {itemName = "ceramicpistol", label = "Pistolet Ceramiczny x7", sellCredit = 30, itemCount = 7, giveItemType = "item", image = "items/ceramicpistol.png"},
                {itemName = "pistol_ammo_box", label = "Pudełko amunicji x20", sellCredit = 30, itemCount = 20, giveItemType = "item", image = "items/pistol_ammo_box.png"},
                {itemName = "flashlight", label = "Latarka x15", sellCredit = 30, itemCount = 15, giveItemType = "item", image = "items/flashlight.png"},
                {itemName = "suppressor", label = "Tłumik x5", sellCredit = 30, itemCount = 5, giveItemType = "item", image = "items/suppressor.png"},
                {itemName = "extendedclip", label = "Powiększony magazynek x3", sellCredit = 30, itemCount = 3, giveItemType = "item", image = "items/extendedclip.png"},
            },
            ["mythical"] = {
                {itemName = "ceramicpistol", label = "Pistolet Ceramiczny x20", sellCredit = 50, itemCount = 20, giveItemType = "item", image = "items/ceramicpistol.png"},
                {itemName = "suppressor", label = "Tłumik x10", sellCredit = 50, itemCount = 10, giveItemType = "item", image = "items/suppressor.png"},
                {itemName = "extendedclip", label = "Powiększony magazynek x6", sellCredit = 50, itemCount = 6, giveItemType = "item", image = "items/extendedclip.png"},
            },
            ["legendary"] = {
                {itemName = "heavypistol", label = "Pistolet Heavy x10", sellCredit = 75, itemCount = 10, giveItemType = "item", image = "items/heavypistol.png"},
                {itemName = "vintagepistol", label = "Pistolet Vintage x30", sellCredit = 75, itemCount = 30, giveItemType = "item", image = "items/vintagepistol.png"},
                {itemName = "snspistol_mk2", label = "Pistolet SNS MK II x30", sellCredit = 75, itemCount = 30, giveItemType = "item", image = "items/snspistol_mk2.png"},
                {itemName = "extendedclip", label = "Powiększony magazynek x10", sellCredit = 75, itemCount = 10, giveItemType = "item", image = "items/extendedclip.png"},
            }
        }
    },
    {
        label = "Car Case",
        CaseImage = "cases/car-premium.png",
        ItemImageAboveCaseImage = "cases/car-premium-item.png",
        price = 500,
        inBanner = false,
        drop = {
            ["common"] = {
                {itemName = "lcdefender", label = "Land Rover Defender 110 Urban", sellCredit = 325, itemCount = 1, giveItemType = "vehicle", image = "items/lcdefender.png"},
                {itemName = "lcvenomcharger", label = "Dodge Charger Venom", sellCredit = 325, itemCount = 1, giveItemType = "vehicle", image = "items/lcvenomcharger.png"},
            },
            ["rare"] = {
                {itemName = "c63s", label = "Mercedes C63S", sellCredit = 400, itemCount = 1, giveItemType = "vehicle", image = "items/c63s.png"},
                {itemName = "20xb7", label = "BMW Alpina XB7 ", sellCredit = 400, itemCount = 1, giveItemType = "vehicle", image = "items/20xb7.png"},
                {itemName = "18mh5", label = "BMW M5 MANHART", sellCredit = 400, itemCount = 1, giveItemType = "vehicle", image = "items/18mh5.png"},
                {itemName = "2024zl1e", label = "Chevrolet Camaro Zl1 1l-E", sellCredit = 400, itemCount = 1, giveItemType = "vehicle", image = "items/2024zl1e.png"},
            },
            ["mythical"] = {
                {itemName = "458j", label = "Ferrari 458", sellCredit = 500, itemCount = 1, giveItemType = "vehicle", image = "items/458j.png"},
                {itemName = "bmwm2v", label = "BMW M2 KOZ", sellCredit = 500, itemCount = 1, giveItemType = "vehicle", image = "items/bmwm2v.png"},
                {itemName = "m3g80c", label = "BMW M3 Hamann", sellCredit = 500, itemCount = 1, giveItemType = "vehicle", image = "items/m3g80c.png"},
                {itemName = "m5e60wb1", label = "BMW M5 E60 Widebody", sellCredit = 500, itemCount = 1, giveItemType = "vehicle", image = "items/m5e60wb1.png"},
                {itemName = "m8keyvany", label = "BMW M8 Keyvany Edition", sellCredit = 500, itemCount = 1, giveItemType = "vehicle", image = "items/m8keyvany.png"},
                {itemName = "humvee1", label = "Humvee", sellCredit = 500, itemCount = 1, giveItemType = "vehicle", image = "items/humvee1.png"},
            },
            ["legendary"] = {
                {itemName = "fxx", label = "Ferrari FXX Evo", sellCredit = 800, itemCount = 1, giveItemType = "vehicle", image = "items/fxx.png"},
                {itemName = "sf12", label = "Ferrari F12", sellCredit = 775, itemCount = 1, giveItemType = "vehicle", image = "items/sf12.png"},
                {itemName = "forgt50020", label = "Ford GT Shelby", sellCredit = 750, itemCount = 1, giveItemType = "vehicle", image = "items/forgt50020.png"},
                {itemName = "xxxev2", label = "Mercedes X Class EV", sellCredit = 850, itemCount = 1, giveItemType = "vehicle", image = "items/xxxev2.png"},
            }
        }
    },
    {
        label = "Premium Case",
        CaseImage = "cases/premium.png",
        ItemImageAboveCaseImage = "cases/premium-item.png",
        price = 100,
        inBanner = false,
        drop = {
            ["common"] = {
                {itemName = "money", label = "1 000 000$", sellCredit = 50, itemCount = 1000000, giveItemType = "money", image = "items/money-1.png"},
                {itemName = "energydrink", label = "Redbull x60", sellCredit = 60, itemCount = 60, giveItemType = "item", image = "items/energydrink.png"},
                {itemName = "weed_pooch", label = "Marihuana x1000", sellCredit = 65, itemCount = 1000, giveItemType = "item", image = "items/weed_pooch.png"},
            },
            ["rare"] = {
                {itemName = "money", label = "1 500 000$", sellCredit = 75, itemCount = 1500000, giveItemType = "money", image = "items/money-2.png"},
                --{itemName = "meth_pooch", label = "Meta x2750", sellCredit = 75, itemCount = 2750, giveItemType = "item", image = "items/meth_pooch.png"},
                {itemName = "fentanyl_pooch", label = "Fentanyl x2250", sellCredit = 75, itemCount = 2250, giveItemType = "item", image = "items/fentanyl_pooch.png"},
                {itemName = "zlay_g37", label = "Infinity G37", sellCredit = 75, itemCount = 1, giveItemType = "vehicle", image = "items/zlay_g37.png"},
            },
            ["mythical"] = {
                {itemName = "money", label = "2 000 000$", sellCredit = 100, itemCount = 2000000, giveItemType = "money", image = "items/money-3.png"},
                {itemName = "heroin_pooch", label = "Heroina x3000", sellCredit = 100, itemCount = 3000, giveItemType = "item", image = "items/heroin_pooch.png"},
                {itemName = "coke_pooch", label = "Kokaina x3750", sellCredit = 100, itemCount = 3750, giveItemType = "item", image = "items/coke_pooch.png"},
                {itemName = "m5e60wb", label = "BMW M5 WB", sellCredit = 100, itemCount = 1, giveItemType = "vehicle", image = "items/m5e60wb.png" },
                {itemName = "rs3", label = "Audi RS3", sellCredit = 100, itemCount = 1, giveItemType = "vehicle", image = "items/rs3.png"},
            },
            ["legendary"] = {
                {itemName = "money", label = "3 500 000$", sellCredit = 175, itemCount = 3500000, giveItemType = "money", image = "items/money-3.png"},
                {itemName = "money", label = "5 000 000$", sellCredit = 250, itemCount = 5000000, giveItemType = "money", image = "items/money-4.png"},
            }
        }
    },
}

Config.nonPremium = {
    {
        label = "Stone Case",
        CaseImage = "cases/stone.png",
        ItemImageAboveCaseImage = "cases/stone-item.png",
        price = 10,
        inBanner = false,
        drop = {
            ["common"] = {
                {itemName = "weed_pooch", label = "Marihuana x400", sellCredit = 3, itemCount = 400, giveItemType = "item", image = "items/weed_pooch.png"},
                {itemName = "pistol_ammo", label = "Ammunicja x100", sellCredit = 3, itemCount = 100, giveItemType = "item", image = "items/pistol_ammo.png"},
                {itemName = "energydrink", label = "Redbull x10", sellCredit = 3, itemCount = 10, giveItemType = "item", image = "items/energydrink.png" },
                {itemName = "radiocrime", label = "Radio x3", sellCredit = 3, itemCount = 3, giveItemType = "item", image = "items/radiocrime.png"},
            },
            ["rare"] = {
                {itemName = "pistol_ammo_box", label = "Pudełko amunicji x5", sellCredit = 5, itemCount = 5, giveItemType = "item", image = "items/pistol_ammo_box.png"},
                {itemName = "snspistol_mk2", label = "Pistolet SNS MK II x1", sellCredit = 8, itemCount = 1, giveItemType = "item", image = "items/snspistol_mk2.png" },
                {itemName = "pistol_mk2", label = "Pistolet MK II x1", sellCredit = 8, itemCount = 1, giveItemType = "item", image = "items/pistol_mk2.png" },
                {itemName = "ceramicpistol", label = "Pistolet Ceramiczny x1", sellCredit = 8, itemCount = 1, giveItemType = "item", image = "items/ceramicpistol.png" },
            },
            ["mythical"] = {
                {itemName = "money", label = "250 000$", sellCredit = 25, itemCount = 250000, giveItemType = "money", image = "items/money-1.png"},
                --{itemName = "meth_pooch", label = "Meta x700", sellCredit = 25, itemCount = 700, giveItemType = "item", image = "items/meth_pooch.png"},
                {itemName = "fentanyl_pooch", label = "Fentanyl x850", sellCredit = 25, itemCount = 850, giveItemType = "item", image = "items/fentanyl_pooch.png"},
            },
            ["legendary"] = {
                {itemName = "money", label = "500 000$", sellCredit = 50, itemCount = 500000, giveItemType = "money", image = "items/money-2.png"},
            }
        }
    },
    {
        label = "Rivals Case",
        CaseImage = "cases/rivals.png",
        ItemImageAboveCaseImage = "cases/rivals-item.png",
        price = 50,
        inBanner = false,
        drop = {
            ["common"] = {
                {itemName = "handcuffs", label = "Kajdanki x4", sellCredit = 10, itemCount = 4, giveItemType = "item", image = "items/handcuffs.png"},
                {itemName = "pistol_ammo", label = "Ammunicja x500", sellCredit = 15, itemCount = 500, giveItemType = "item", image = "items/pistol_ammo.png"},
                {itemName = "energydrink", label = "Redbull x20", sellCredit = 10, itemCount = 20, giveItemType = "item", image = "items/energydrink.png"},
                {itemName = "radiocrime", label = "Radio x15", sellCredit = 15, itemCount = 15, giveItemType = "item", image = "items/radiocrime.png"},
            },
            ["rare"] = {
                {itemName = "pistol_mk2", label = "Pistolet MK II x3", sellCredit = 30, itemCount = 3, giveItemType = "item", image = "items/pistol_mk2.png" },
                --{itemName = "meth_pooch", label = "Meta x700", sellCredit = 25, itemCount = 700, giveItemType = "item", image = "items/meth_pooch.png"},
                {itemName = "fentanyl_pooch", label = "Fentanyl x850", sellCredit = 25, itemCount = 850, giveItemType = "item", image = "items/fentanyl_pooch.png"},   
            },
            ["mythical"] = {
                {itemName = "money", label = "650 000$", sellCredit = 65, itemCount = 650000, giveItemType = "money", image = "items/money-2.png"},
                {itemName = "flashlight", label = "Latarka x2", sellCredit = 40, itemCount = 2, giveItemType = "item", image = "items/flashlight.png"},
                {itemName = "vintagepistol", label = "Vintage x5", sellCredit = 40, itemCount = 5, giveItemType = "item", image = "items/vintagepistol.png" },
                {itemName = "snspistol_mk2", label = "Pistolet SNS MK II x5", sellCredit = 40, itemCount = 5, giveItemType = "item", image = "items/snspistol_mk2.png" },
                {itemName = "ceramicpistol", label = "Pistolet Ceramiczny x5", sellCredit = 40, itemCount = 5, giveItemType = "item", image = "items/ceramicpistol.png" },
            },
            ["legendary"] = {
                {itemName = "money", label = "1 500 000$", sellCredit = 150, itemCount = 1500000, giveItemType = "money", image = "items/money-3.png"},
                {itemName = "suppressor", label = "Tłumik x3", sellCredit = 100, itemCount = 3, giveItemType = "item", image = "items/suppressor.png"},
                {itemName = "extendedclip", label = "Powiększony magazynek x2", sellCredit = 100, itemCount = 2, giveItemType = "item", image = "items/extendedclip.png"},
            }
        }
    },
    {
        label = "Car Case",
        CaseImage = "cases/car.png",
        ItemImageAboveCaseImage = "cases/car-item.png",
        price = 100,
        inBanner = false,
        drop = {
            ["common"] = {
                {itemName = "cheburek", label = "Cheburek", sellCredit = 25, itemCount = 1, giveItemType = "vehicle", image = "items/cheburek.png"},
                {itemName = "kamacho", label = "Kamacho", sellCredit = 25, itemCount = 1, giveItemType = "vehicle", image = "items/kamacho.png"},
                {itemName = "t20", label = "T20", sellCredit = 25, itemCount = 1, giveItemType = "vehicle", image = "items/t20.png"},
                {itemName = "gp1", label = "GP1", sellCredit = 25, itemCount = 1, giveItemType = "vehicle", image = "items/gp1.png"},
                {itemName = "pfister811", label = "811", sellCredit = 25, itemCount = 1, giveItemType = "vehicle", image = "items/pfister811.png"},
            },
            ["rare"] = {
                {itemName = "ignus", label = "Ignus", sellCredit = 50, itemCount = 1, giveItemType = "vehicle", image = "items/ignus.png"},
                {itemName = "emerus", label = "Emerus", sellCredit = 50, itemCount = 1, giveItemType = "vehicle", image = "items/emerus.png"},
                {itemName = "tezeract", label = "Tezeract", sellCredit = 50, itemCount = 1, giveItemType = "vehicle", image = "items/tezeract.png"},
            },
            ["mythical"] = {
                { itemName = "abhawk", label = "Jeep Cherokee", sellCredit = 100, itemCount = 1, giveItemType = "vehicle", image = "items/abhawk.png" },
                { itemName = "1500ghoul", label = "RAM Ghoul", sellCredit = 100, itemCount = 1, giveItemType = "vehicle", image = "items/1500ghoul.png" },
            },
            ["legendary"] = {
                {itemName = "x6mf96lbwk", label = "BMW X6 LB", sellCredit = 200, itemCount = 1, giveItemType = "vehicle", image = "items/x6mf96lbwk.png" },
                {itemName = "m5e60wb", label = "BMW M5 WB", sellCredit = 200, itemCount = 1, giveItemType = "vehicle", image = "items/m5e60wb.png" },
                {itemName = "rs3", label = "Audi RS3", sellCredit = 200, itemCount = 1, giveItemType = "vehicle", image = "items/rs3.png"},
                {itemName = "hyclambo", label = "Lamborghini Hycade", sellCredit = 200, itemCount = 1, giveItemType = "vehicle", image = "items/hyclambo.png"},
            }
        }
    },
}