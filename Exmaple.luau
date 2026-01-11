local playerInfo = {}
local player = nil
local PropPackData = {
    ["oldwar"] = {
        propIncrease = 50,
        propBitshift = bit32.lshift(1, 1),
    },

    ["signeditorExpansion"] = {
        propIncrease = 10,
        propBitshift = bit32.lshift(1, 2),
    },

    ["tunnelsCavernsExpansion"] = {
        propIncrease = 25,
        propBitshift = bit32.lshift(1, 3),
    },

    ["forgottenSewerSubzone"] = {
        propIncrease = 5,
        propBitshift = bit32.lshift(1, 4),
    },

    ["halloweenHarvestExpansion"] = {
        propIncrease = 40,
        propBitshift = bit32.lshift(1, 5),
    },

    ["scrapOutpostsExpansion"] = {
        propIncrease = 25,
        propBitshift = bit32.lshift(1, 6),
    },

    ["limitedRunBCExpansion"] = {
        propIncrease = 25,
        propBitshift = bit32.lshift(1, 7),
    },

    ["militaryExpansion"] = {
        propIncrease = 50,
        propBitshift = bit32.lshift(1, 8),
    },

    ["haloContainmentExpansion"] = {
        propIncrease = 40,
        propBitshift = bit32.lshift(1, 9),
    },

    ["medicalExpansion"] = {
        propIncrease = 25,
        propBitshift = bit32.lshift(1, 10),
    },
}

--------------------------------------------A
local newCountLimit = 0
local PlayerPacks = playerInfo[player].storeData.Data.ownedPropPacks
if PlayerPacks["oldwar"] then
    newCountLimit += 50
end
if PlayerPacks["signeditorExpansion"] then
    newCountLimit += 10
end
if PlayerPacks["tunnelsCavernsExpansion"] then
    newCountLimit += 25
end
if PlayerPacks["forgottenSewerSubzone"] then
    newCountLimit += 5
end
if PlayerPacks["halloweenHarvestExpansion"] then
    newCountLimit += 40
end
if PlayerPacks["scrapOutpostsExpansion"] then
    newCountLimit += 25
end
if PlayerPacks["limitedRunBCExpansion"] then
    newCountLimit += 25
end
if PlayerPacks["militaryExpansion"] then
    newCountLimit += 50
end
if PlayerPacks["haloContainmentExpansion"] then
    newCountLimit += 40
end
if PlayerPacks["medicalExpansion"] then
    newCountLimit += 25
end
PlayerPacks = nil

local function SetPlayerPacks(PlayerObject)
    local OwnedPacks = PlayerObject.storeData.Data.ownedPropPacks
    for I, item in pairs(PropPackData) do
        PlayerObject.PropCount += (OwnedPacks[I] and OwnedPacks[I].Enabled == true) and item.propIncrease or 0
    end
    OwnedPacks = nil::any
end


SetPlayerPacks()

--[[
{
save_name = name,
count = propCount
prop_data = { --many props
  {
    pid = prop.id
    cfr = {
        pos = {X = pos.X, Y = pos.Y, Z = pos.Z},
        rX = {X = rVec.X, Y = rVec.Y, Z = rVec.Z},
        rY = {X = uVec.X, Y = uVec.Y, Z = uVec.Z},
        rZ = {X = lVec.X, Y = lVec.Y, Z = lVec.Z}
      }
    clr = {} --indexed as CustomColor_..[number] = {R = r, G = g, B = b}
    }
  }
rmi_data = {--[[items chosen to be removed, index number, value is RMI ID

]]

type PropData = {
    pid:number;
    cfr:string;
    clr:string
}

type PlayerData = {
    save_name:string;
    count:number;
    rmi_data:{number};
    prop_data:{
        PropData
    }
}

local A = CFrame.new():GetComponents()

local B = CFrame.new(unpack(string.split(A, " ")))

local C = Color3.new(0,0,0):ToHex()

local D = Color3.fromHex(C)

local SaveData = {
    save_name = "save 1";
    count = 1;
    rmi_data = {};

    prop_data = {
        {
            pid = 1;
            CFR = CFrame.new():GetComponents();
            Color3.new(0,0,0):ToHex()
        }
    }
}