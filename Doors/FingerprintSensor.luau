--!strict
----Configurations------
local DOOR_MATERIAL="Iron" --what material is the door made out of(case sensitive string)
local TIME_OPEN=2 --for how many seconds should the door stay open
local WHITELIST={553682774,5479936506,3579843}--put whitelisted players' user ids after commas in the brackets
----Code(change at your own risk)----
if(typeof(TIME_OPEN)~="number")then error("\n\tERROR: Configured time open is of an invalid type!") end
if(typeof(DOOR_MATERIAL)~="string")then error("\n\tERROR: Configured door material is of an invalid type!") end
if(typeof(WHITELIST)~="table")then error("\n\tERROR: Configured whitelist isn't a table!") end
for i=1,#WHITELIST do if(typeof(WHITELIST[i])=="number")then continue end; error("\n\tERROR: Configured whitelist contains non-number types!") end

local touchScreens=assert(Network:GetParts("TouchScreen"),"\n\tERROR: Missing TouchScreen(s)!")
local currentDoorState=false
local debounce=false

local function OnLoop(TouchScreen:any)
    return function()
        local cursors=setmetatable(TouchScreen:GetCursors(),{__len=function(self) local entries=0; for _,_ in self do entries+=1 end; return entries end})
        if(#cursors==0)then return end
        for userid in cursors do
            if(not table.find(WHITELIST,userid))then return end
        end
        if debounce then return end
        debounce=true
        currentDoorState=true
        task.wait(TIME_OPEN)
        currentDoorState=false
        debounce=false
    end
end

for i=1,#touchScreens do
    local handPrintImage=Instance.new("ImageLabel")
    handPrintImage.Name="HandPrintImage"
    handPrintImage.Image="rbxassetid://100712106061973"
    handPrintImage.Size=UDim2.fromScale(1,1)
    handPrintImage.Parent=touchScreens[i]:GetCanvas()

    Microcontroller.Loop:Connect(OnLoop(touchScreens[i]))
end

local doorFrame=assert(Network:GetPart(DOOR_MATERIAL),"\n\tERROR: Missing Door frame, or invalid door material!")
local door=assert(doorFrame:GetComponent("Door"),"\n\tERROR: Missing Door component!")

while task.wait(0.005) do
    local doorState:boolean=table.pack(door:GetConfigurable("Switch"))[2]
    if(doorState==currentDoorState)then continue end
    door:SetConfigurable("Switch",currentDoorState)
end