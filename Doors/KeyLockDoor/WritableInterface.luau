--!strict
local disk=assert(GetPart("Disk"),"\n\tERROR: Failed to write interface code to the Disk, missing Disk!")
disk:Write("Interface",[[
--!strict
local backgroundFrame=Instance.new("Frame")
backgroundFrame.Name="BackgroundFrame"
backgroundFrame.Size=UDim2.fromScale(1,1)
backgroundFrame.Parent=nil

local numPadFrame=Instance.new("Frame")
numPadFrame.Name="NumPadFrame"
numPadFrame.Size=UDim2.fromScale(0.58125,0.775)
numPadFrame.Position=UDim2.fromScale(0.209375,0.225)
numPadFrame.Parent=backgroundFrame

local uiListLayout=Instance.new("UIListLayout")
uiListLayout.FillDirection=Enum.FillDirection.Horizontal
uiListLayout.HorizontalFlex=Enum.UIFlexAlignment.SpaceEvenly
uiListLayout.Wraps=true
uiListLayout.SortOrder=Enum.SortOrder.LayoutOrder
uiListLayout.Parent=numPadFrame

local numberDisplay=Instance.new("TextLabel")
numberDisplay.Name="NumberDisplay"
numberDisplay.Text=""
numberDisplay.Size=UDim2.fromScale(0.35,0.225)
numberDisplay.Position=UDim2.fromScale(0.325,0)
numberDisplay.Parent=backgroundFrame

local numberButtonTable={}

for i=1,10 do
    local text:any=i==10 and 0 or i
    local numberButton=Instance.new("TextButton")
    numberButton.Name=text
    numberButton.Text=text
    numberButton.Size=UDim2.fromScale(0.333,1)
    numberButton.LayoutOrder=i
    numberButton.Parent=numPadFrame

    local uiAspectRatioConstant=Instance.new("UIAspectRatioConstraint")
    uiAspectRatioConstant.AspectRatio=1
    uiAspectRatioConstant.DominantAxis=Enum.DominantAxis.Width
    uiAspectRatioConstant.Parent=numberButton

    table.insert(numberButtonTable,numberButton)
end

local display={
    Background=backgroundFrame,
    NumberDisplay=numberDisplay,
    NumberButtons=numberButtonTable
}

return table.freeze(display)
]])
Microcontroller.Code=""
Microcontroller.StartOnSpawn=false
Beep(1)