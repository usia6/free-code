--!strict
----Configuration----
local PASSWORD="000"--three digit password string
local TIME_OPEN=2 --for how many seconds should the door stay open
local DOOR_MATERIAL="Iron" --what material is the door made out of(case sensitive string)
----Code(change at your own risk!)----
if(#PASSWORD>3 or typeof(PASSWORD)~="string")then error("\n\tERROR: Configured password has an invalid length or isn't a string!") end
if(typeof(TIME_OPEN)~="number")then error("\n\tERROR: Configured time open is of an invalid type!") end
if(typeof(DOOR_MATERIAL)~="string")then error("\n\tERROR: Configured door material is of an invalid type!") end

local disk=assert(Network:GetPart("Disk"),"\n\tERROR: Missing disk with interface code!")
local interfaceScript=disk:Read("Interface")
while(not interfaceScript)do
    warn("\n\tWARNING: Awaiting for interface code. If this takes too long, make sure that you correctly assigned the included interface code under an \"Interface\" key in the attached Disk.")
    interfaceScript=disk:Read("Interface")
    task.wait(1)
end
local InterfaceCreator=assert(loadstring(interfaceScript),"\n\tERROR: Given interface script has encountered an error!")
local touchScreens=assert(Network:GetParts("TouchScreen"),"\n\tERROR:Missing TouchScreen(s)!")
local currentDoorState=false

local function CreateKeyLock(TouchScreen:TouchScreen)
    local interfaceInstance:typeof(require("./Interface"))=InterfaceCreator()
    interfaceInstance.Background.Parent=TouchScreen:GetCanvas()
    local numberButtons=interfaceInstance.NumberButtons
    local inputtedPassword=""
    local debounce=false
    local function OnClick(NumberButton:TextButton)
        return function()
            if debounce then return end
            debounce=true
            inputtedPassword..=NumberButton.Text
            interfaceInstance.NumberDisplay.Text..="*"
            if(#inputtedPassword<3)then 
                debounce=false
                return 
            elseif(PASSWORD~=inputtedPassword)then
                task.wait(1)
                inputtedPassword,interfaceInstance.NumberDisplay.Text="",""
                debounce=false
                return
            end
            currentDoorState=true
            task.wait(TIME_OPEN)
            debounce,currentDoorState=false,false
            inputtedPassword,interfaceInstance.NumberDisplay.Text="",""
        end
    end

    for i=1,#numberButtons do
        numberButtons[i].MouseButton1Down:Connect(OnClick(numberButtons[i]))
    end
end

for i=1,#touchScreens do
    CreateKeyLock(touchScreens[i])
end

local doorFrame=assert(Network:GetPart(DOOR_MATERIAL),"\n\tERROR: Missing Door frame, or invalid door material!")
local door=assert(doorFrame:GetComponent("Door"),"\n\tERROR: Missing Door component!")

while task.wait(0.005) do
    local doorState:boolean=table.pack(door:GetConfigurable("Switch"))[2]
    if(doorState==currentDoorState)then continue end
    door:SetConfigurable("Switch",currentDoorState)
end
