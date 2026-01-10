local RunService = game:GetService("RunService")

local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IsServer = RunService:IsServer()
local Remotes:Folder & any = IsServer and ReplicatedStorage.Remotes or ReplicatedStorage:WaitForChild("Remotes", 800)
local Players = {}
local Events = {
    JoinServer = (IsServer and Remotes.JoinServer or Remotes:WaitForChild("JoinServer", 800))::RemoteFunction;
    PlayerEvent = (IsServer and Remotes.PlayerEvent or Remotes:WaitForChild("PlayerEvent", 800))::RemoteEvent
}
local Switch = {
    ["randomscenario"] = function(...)
        print(...)
    end;
    default = function(...)
        
    end
}

function module.DoAction(Action:string, ...)
    local Returns = Switch[Action] and {Switch[Action](...)} or {Switch.default()}
    Events.JoinServer:InvokeServer("EventName", "Random")
    print(Players[nil::any].Data)
end

Events.PlayerEvent.OnClientEvent:Connect(function(UserID:string, Stats)
    Players[UserID] = Stats
end)
require("./ExampleModule")