--!strict
----Configurations------
local TIME_OPEN=2 --for how many seconds should the door stay open
local DOOR_MATERIAL="Iron" --what material is the door made out of(case sensitive string)
----Code(change at your own risk!)----
if(typeof(TIME_OPEN)~="number")then error("\n\tERROR: Configured time open is of an invalid type!") end
if(typeof(DOOR_MATERIAL)~="string")then error("\n\tERROR: Configured door material is of an invalid type!") end

local port=assert(Network:GetPort(1),"\n\tERROR: Missing Port!")
local doorState=false

local function OnTriggered()
    local connectedParts=Network:GetPartsFromPort(port)
    for i=1,#connectedParts do
        if(connectedParts[i].PartLocked~=Microcontroller.PartLocked)then continue end
        error("\n\tERROR: For security reasons, all parts that touch the Port must be locked by the owner of the Microcontroller.")
    end
    doorState=true
    task.wait(TIME_OPEN)
    doorState=false
end

port.Triggered:Connect(OnTriggered)

local doorFrame=assert(Network:GetPart(DOOR_MATERIAL),"\n\tERROR: Missing Door frame, or invalid door material!")
local door=assert(doorFrame:GetComponent("Door"),"\n\tERROR: Missing Door component!")

while task.wait(0.005) do
    local currentDoorState:boolean=table.pack(door:GetConfigurable("Switch"))[2]
    if(currentDoorState==doorState)then continue end
    door:SetConfigurable("Switch",doorState)
end