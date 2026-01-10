local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes:Folder = ReplicatedStorage:WaitForChild("Remotes", 800)
module.GuiAction = {}

module.GuiItems = {
    Customization = {
        CustomizationFrame = (nil::any)::Frame;
        ObjectEditFrame = (nil::any)::Frame;
        RigeditFrame = (nil::any)::Frame;
        Notification = (nil::any)::Frame;
        AssetLoadingModel = ReplicatedStorage:WaitForChild("AssetLoadingModel")::Model
    }
}

module.SavedDimension = nil::any

module.Enums = {
    DraggerCleaning = {
        all = "all"
    };
    NotifyStates = {
        Ready = "Ready"
    };
    RemoteActions = {
        KitFromCode = "AddKitFromCode"
    }
}

module.Events = {
    Notification = Remotes:WaitForChild("AddKitFromCode")::RemoteFunction
}

module.States = {}

module.Debounce = {
    ActionDebounce = false
}

local function CleanDraggers(State:string)
    
end

function module.GuiAction.ActiveCharacterCustomize(self:typeof(module))
    local GuiElements:typeof(module.GuiItems.Customization) = self.GuiItems.Customization
    local ToolEditFrame:Frame & any = GuiElements.CustomizationFrame
    local ObjectEditFrame:Frame = GuiElements.ObjectEditFrame
    local RigeditFrame:Frame = GuiElements.RigeditFrame
    local StateData = {}
    ---------------------------------------------------- POST INIT
    CleanDraggers(module.Enums.DraggerCleaning)
    ToolEditFrame.Visible = true
    ObjectEditFrame.Visible  = false
    RigeditFrame.Visible = false
    ---------------------------------------------------- CLEANUP
    module.States[ToolEditFrame] = StateData
    GuiElements = nil::any;StateData = nil::any;ToolEditFrame=nil::any
    ObjectEditFrame = nil::any; RigeditFrame = nil::any;
end

function module.GuiAction.AddKit(self:typeof(module))
    local Customization = self.GuiItems.Customization
    local NotificationFrame = Customization.Notification
    local State:string = self.States[NotificationFrame]
    --------------------------------------------------------------------------------POST INIT
    if self.Debounce.ActionDebounce or State ~= self.Enums.NotifyStates then
        return --< not ideal
    end
    local Suc, ReturnValue = pcall(function()
        return self.Events.Notification:InvokeServer(self.Enums.RemoteActions.KitFromCode, nil::any, self.SavedDimension) --< nil could be comething passed idk.
    end)
    State = Suc and "Success" or "Failed"
    ---------------------------------------------------- CLEANUP
    self.States[NotificationFrame] = State
    Customization = nil::any; NotificationFrame = nil::any; State = nil::any;
    Suc = nil::any
    task.delay(0.1, function()
        self.Debounce.ActionDebounce = false
    end)
    return ReturnValue
end

local Codes = {}

local function randomizer()
    return `{math.random(0, 9)}{math.random(0, 9)}{math.random(0, 9)}{math.random(1, 9)}`
end

local function GetKitCode()
    local Code = randomizer()
    while Codes[Code] do
        Code = randomizer()
    end
    return Code
end

local function PrepareKit(Player:Player, KitData:any, NewKitCode:string)
    local Customization = module.GuiItems.Customization
    local Dimension = KitData.Dimension
    local DisplayModel = Customization.AssetLoadingModel:Clone()
    local Humanoid:Humanoid & any = DisplayModel.Humanoid;
     --------------------------------------------------------------------------------POST INIT
    (Humanoid.HeadScale::NumberValue).Value = Dimension.Height;
    (Humanoid.BodyWidthScale::NumberValue).Value = Dimension.Width;
    (Humanoid.BodyDepthScale::NumberValue).Value = Dimension.Depth
    ---------------------------------------------------- CLEANUP
    Customization = nil::any; DisplayModel = nil::any; Humanoid = nil::any
    Dimension = nil::any
    return DisplayModel
end


return module