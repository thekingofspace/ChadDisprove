local Toolbox = require("./ExampleModule")
local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local IsServer = RunService:IsServer()
local Remotes:Folder & any = IsServer and ReplicatedStorage.Remotes or ReplicatedStorage:WaitForChild("Remotes", 800)
module.Events = {
    JoinServer = (IsServer and Remotes.JoinServer or Remotes:WaitForChild("JoinServer", 800))::RemoteFunction;
    PlayerEvent = (IsServer and Remotes.PlayerEvent or Remotes:WaitForChild("PlayerEvent", 800))::RemoteEvent;
    ToolState = (IsServer and Remotes.ToolState or Remotes:WaitForChild("ToolState", 800))::RemoteFunction;
}

type Module = Toolbox.Module

for I, item in pairs(Toolbox) do
    module[`Toolbox_{I}`] = item
end

local Common = {
    Idle = ""
}

module.MelleRHandgun = {
    Anim = {
        Crouch = {

        };
        Stand = {
            Idle = Common.Idle
        };
        Prone = {
            Idle = "";
        }
    }
}

function SetZoneDarkModule(Test)
    Test.["Origin_Ambient"] = Test.Ambient
    Test.Ambient = 0
end

return module::Module