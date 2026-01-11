local PlayerRigging = require("@self/PlayerRigging")

local Switch = {
    ["items_Morph"] = function(Item:Model & any, OldColor:Color3)
        return Color3.new(), Color3.new()
    end;
    default = function(Item:Model & any)
        
    end
}

local Color, Color2 = Switch.items_Morph(nil::any, Color3.new(0,0,0))
Color = Color or Color3.new();Color2 = Color2 or Color3.new()
local starcount = 0
local item = nil::any

(item::any).Color = starcount > 5 and Color3.new(0,0,0) or Color3.new(1,1,1)