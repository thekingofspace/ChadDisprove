local module = {}
local CollideService = game:GetService("PhysicsService")

local SwapColl = {
    "Default";"PlayerParts";"MapCollisionparts";

}

function module.SetCollide()
    for _, item in ipairs(SwapColl) do
        CollideService:CollisionGroupSetCollidable("CustomizeCollisionParts", item, false)
    end
end

return module