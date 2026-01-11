local Aray = {
    Key = {
        Key = {

        }
    }
}

local CurrentSection = Aray.Key.Key

--------------------------------------------
local Test:Instance = nil::any

local States = {}

States[Test] = {

}

States[Test] = nil

Test.Name = CurrentSection and "Test" or "Tester"


local function Foo(Bar:Player)
    Bar.Name = ""
end

Foo(nil::any)