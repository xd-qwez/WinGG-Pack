local BLIP_INFO_DATA = {}



function ensureBlipInfo(blip)
    if blip == nil then blip = 0 end
    SetBlipAsMissionCreatorBlip(blip, true)
    if not BLIP_INFO_DATA[blip] then BLIP_INFO_DATA[blip] = {} end
    if not BLIP_INFO_DATA[blip].title then BLIP_INFO_DATA[blip].title = "" end
    if not BLIP_INFO_DATA[blip].rockstarVerified then BLIP_INFO_DATA[blip].rockstarVerified = false end
    if not BLIP_INFO_DATA[blip].info then BLIP_INFO_DATA[blip].info = {} end
    if not BLIP_INFO_DATA[blip].money then BLIP_INFO_DATA[blip].money = "" end
    if not BLIP_INFO_DATA[blip].rp then BLIP_INFO_DATA[blip].rp = "" end
    if not BLIP_INFO_DATA[blip].dict then BLIP_INFO_DATA[blip].dict = "" end
    if not BLIP_INFO_DATA[blip].tex then BLIP_INFO_DATA[blip].tex = "" end
    return BLIP_INFO_DATA[blip]
end


function ResetBlipInfo(blip)
    BLIP_INFO_DATA[blip] = nil
end

function SetBlipInfoTitle(blip, title, rockstarVerified)
    local data = ensureBlipInfo(blip)
    data.title = title or ""
    data.rockstarVerified = rockstarVerified or false
end

function SetBlipInfoImage(blip, dict, tex)
    local data = ensureBlipInfo(blip)
    data.dict = dict or ""
    data.tex = tex or ""
end

function SetBlipInfoEconomy(blip, rp, money)
    local data = ensureBlipInfo(blip)
    data.money = tostring(money) or ""
    data.rp = tostring(rp) or ""
end

function SetBlipInfo(blip, info)
    local data = ensureBlipInfo(blip)
    data.info = info
end

function AddBlipInfoText(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    if rightText then
        table.insert(data.info, {1, leftText or "", rightText or ""})
    else
        table.insert(data.info, {5, leftText or "", ""})
    end
end

function AddBlipInfoName(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {3, leftText or "", rightText or ""})
end

function AddBlipInfoHeader(blip, leftText, rightText)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {4, leftText or "", rightText or ""})
end

function AddBlipInfoIcon(blip, leftText, rightText, iconId, iconColor, checked)
    local data = ensureBlipInfo(blip)
    table.insert(data.info, {2, leftText or "", rightText or "", iconId or 0, iconColor or 0, checked or false})
end

--[[
    All that fancy decompiled stuff I've kinda figured out
]]

local Display = 1
function UpdateDisplay()
    if BeginScaleformMovieMethodOnFrontend("DISPLAY_DATA_SLOT") then
        ScaleformMovieMethodAddParamInt(Display)
        EndScaleformMovieMethod()
    end
end

function SetColumnState(column, state)
    if BeginScaleformMovieMethodOnFrontend("SHOW_COLUMN") then
        ScaleformMovieMethodAddParamInt(column)
        ScaleformMovieMethodAddParamBool(state)
        EndScaleformMovieMethod()
    end
end

function ShowDisplay(show)
    SetColumnState(Display, show)
end

function func_36(fParam0)
    BeginTextCommandScaleformString(fParam0)
    EndTextCommandScaleformString()
end

function SetIcon(index, title, text, icon, iconColor, completed)
    if BeginScaleformMovieMethodOnFrontend("SET_DATA_SLOT") then
        ScaleformMovieMethodAddParamInt(Display)
        ScaleformMovieMethodAddParamInt(index)
        ScaleformMovieMethodAddParamInt(65)
        ScaleformMovieMethodAddParamInt(3)
        ScaleformMovieMethodAddParamInt(2)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(1)
        func_36(title)
        func_36(text)
        ScaleformMovieMethodAddParamInt(icon)
        ScaleformMovieMethodAddParamInt(iconColor)
        ScaleformMovieMethodAddParamBool(completed)
        EndScaleformMovieMethod()
    end
end

function SetText(index, title, text, textType)
    if BeginScaleformMovieMethodOnFrontend("SET_DATA_SLOT") then
        ScaleformMovieMethodAddParamInt(Display)
        ScaleformMovieMethodAddParamInt(index)
        ScaleformMovieMethodAddParamInt(65)
        ScaleformMovieMethodAddParamInt(3)
        ScaleformMovieMethodAddParamInt(textType or 0)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        func_36(title)
        func_36(text)
        EndScaleformMovieMethod()
    end
end

local _labels = 0
local _entries = 0
function ClearDisplay()
    if BeginScaleformMovieMethodOnFrontend("SET_DATA_SLOT_EMPTY") then
        ScaleformMovieMethodAddParamInt(Display)
    end
    EndScaleformMovieMethod()
    _labels = 0
    _entries = 0
end

function _label(text)
    local lbl = "LBL" .. _labels
    AddTextEntry(lbl, text)
    _labels = _labels + 1
    return lbl
end

function SetTitle(title, rockstarVerified, rp, money, dict, tex)
    if BeginScaleformMovieMethodOnFrontend("SET_COLUMN_TITLE") then
        ScaleformMovieMethodAddParamInt(Display)
        func_36("")
        func_36(_label(title))
        ScaleformMovieMethodAddParamInt(rockstarVerified)
        ScaleformMovieMethodAddParamTextureNameString(dict)
        ScaleformMovieMethodAddParamTextureNameString(tex)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        if rp == "" then
            ScaleformMovieMethodAddParamBool(false)
        else
            func_36(_label(rp))
        end
        if money == "" then
            ScaleformMovieMethodAddParamBool(false)
        else
            func_36(_label(money))
        end
    end
    EndScaleformMovieMethod()
end

function AddText(title, desc, style)
    SetText(_entries, _label(title), _label(desc), style or 1)
    _entries = _entries + 1
end

function AddIcon(title, desc, icon, color, checked)
    SetIcon(_entries, _label(title), _label(desc), icon, color, checked)
    _entries = _entries + 1
end

CreateThread(function()
    local current_blip = nil
    while true do
        Wait(50)
        if IsFrontendReadyForControl() then
            local blip = GetNewSelectedMissionCreatorBlip()
            if IsHoveringOverMissionCreatorBlip() then
                if DoesBlipExist(blip) then
                    if current_blip ~= blip then
                        current_blip = blip
                        if BLIP_INFO_DATA[blip] then
                            local data = ensureBlipInfo(blip)
                            TakeControlOfFrontend()
                            ClearDisplay()
                            SetTitle(data.title, data.rockstarVerified, data.rp, data.money, data.dict, data.tex)
                            for _, info in next, data.info do
                                if info[1] == 2 then
                                    AddIcon(info[2], info[3], info[4], info[5], info[6])
                                else
                                    AddText(info[2], info[3], info[1])
                                end
                            end
                            ShowDisplay(true)
                            UpdateDisplay()
                            ReleaseControlOfFrontend()
                        else
                            ShowDisplay(false)
                        end
                    end
                end
            else
                if current_blip then
                    current_blip = nil
                    ShowDisplay(false)
                end
            end
        else
            Wait(1000)
        end
    end
end)