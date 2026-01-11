local module = {}

--[[
    Litter
    -----
    A "managed unit" owned by a Maid.

    A Litter:
    - Belongs to exactly one Maid (Host)
    - Tracks arbitrary origin objects (Instances, connections, etc.)
    - Can listen for named signals
    - Can receive orders (signals) from its Maid
    - Cleans up its owned resources when destroyed
]]
export type Litter = {
    -- The Maid that owns and tracks this Litter
    Host: Maid;

    -- the position in the trashbin
    Index:number;

    -- Objects associated with this Litter (usually Instances or resources to clean)
    Origin: { any };

    -- Map of signal name → callback
    -- Callbacks are invoked when GiveOrder is called with the same signal
    Listeners: { [string]: (self: Litter, ...any) -> nil };

    -- Cleans up this Litter:
    -- - Removes itself from the Maid
    -- - Fires "Destroying" signal
    -- - Clears internal tables
    CleanUp: (self: Litter) -> ();

    -- Registers a callback for a named signal on this Litter
    Listen: (self: Litter, Signal: string, Callback: (self: Litter, ...any) -> ...any) -> ();

    -- Invokes a signal callback on this Litter if it exists
    GiveOrder: (self: Litter, Signal: string, ...any) -> ...any;
}

--[[
    Maid
    ----
    A lifecycle manager for multiple Litters.

    A Maid:
    - Owns and tracks many Litters
    - Can broadcast orders to all Litters
    - Can insert new Litters using an optional constructor
    - Can clean up all tracked Litters at once
]]
export type Maid = {
    -- Optional constructor used to transform InsertInto arguments
    -- If present, InsertInto(...) will call this instead of using raw args
    Constructor: ((self: Maid, ...any) -> ...any)?;

    -- Optional callback fired whenever a new Litter is created
    LitterCreated: ((self: Maid, Litter: Litter) -> ...any)?;

    -- Active Litter registry
    -- Value is a timestamp
    TrashBin: { [number]: Litter };

    -- Creates and inserts a new Litter into the Maid
    InsertInto: (self: Maid, ...any) -> Litter;

    -- Sends a signal to all Litters and collects their return values
    GiveOrders: (self: Maid, Signal: string, ...any) -> { [Litter]: { any } };

    -- Registers the same signal callback on all existing Litters
    DisperseOrder: (self: Maid, Signal: string, Callback: (self: Litter, ...any) -> ...any) -> Maid;

    -- Cleans up all Litters owned by this Maid
    CleanUp: (self: Maid) -> Maid;
}

local Litter = {}
Litter.__index = Litter

function Litter.Listen(self:Litter, Signal:string, Callback:(self:Litter, ...any) -> ...any)
    self.Listeners[Signal] = Callback
end

function Litter.GiveOrder(self:Litter, Signal:string, ...:any)
    return self.Listeners[Signal] and self.Listeners[Signal](self, ...) or nil
end

function Litter.CleanUp(self:Litter)
    self.Host.TrashBin[self.Index] = nil
    self:GiveOrder("Destroying")
    table.clear(self.Origin)
    table.clear(self.Listeners)
end

local function GenerateLitter(Maid:Maid, ...:any):Litter
    return setmetatable({
        Host = Maid;
        Origin = {...};
        Listeners = {}
    }, Litter)::any
end

local Maid = {}
Maid.__index = Maid

function Maid.CleanUp(self:Maid)
    for _, LitteredItem in pairs(self.TrashBin) do
        LitteredItem:CleanUp()
    end
    table.clear(self.TrashBin)
    return self
end

function Maid.GiveOrders(self:Maid, Signal:string, ...:any)
    local ReturnArgs = {}
    for _, LitteredItem in pairs(self.TrashBin) do
        ReturnArgs[LitteredItem] = {LitteredItem:GiveOrder(Signal, ...)}
    end
    return ReturnArgs
end

function Maid.DisperseOrder(self:Maid, Signal:string, Callback:(self:Litter, ...any) -> ...any)
    for _, LitteredItem in pairs(self.TrashBin) do
        LitteredItem:Listen(Signal, Callback)
    end
    return self
end

function Maid.InsertInto(self:Maid, ...:any):Litter
    local Args:{any} = nil::any
    if self.Constructor then Args = {(self.Constructor::any)(self, ...)} end
    local NewLitter:Litter = GenerateLitter(self, Args and unpack(Args) or ...)
    local nextIndex:number = 1
    while self.TrashBin[nextIndex] do
        nextIndex = nextIndex + 1
    end
    self.TrashBin[nextIndex] = NewLitter
    NewLitter.Index = nextIndex
    Args = nil::any;nextIndex = nil::any
    if self.LitterCreated then (self.LitterCreated::any)(self, NewLitter) end
    return NewLitter::Litter
end

function module.new():Maid
    return setmetatable({
        TrashBin = {}
    }, Maid)::any
end

return module