local ELEMENTS_PER_ROW = 2
local bins = GetParts("Bin")
local tanks = GetParts("Tank")
local screen = GetPart("Screen")
local canvas:Frame = screen:GetCanvas("2D")
local resourceVolumes = {}
local resourceAmounts = {}

if bins then
    for i=1,#bins do
        local resource = bins[i].Resource
        if resourceVolumes[resource] then
            resourceVolumes[resource] += bins[i].Size.X*bins[i].Size.Y*bins[i].Size.Z
        else    
            resourceVolumes[resource] = bins[i].Size.X*bins[i].Size.Y*bins[i].Size.Z
            resourceAmounts[resource] = 0
        end
    end
    
end

if tanks then
    for i=1,#tanks do
        local resource = tanks[i].Resource
        if resourceVolumes[resource] then
            resourceVolumes[resource] += (tanks[i].Size.X*tanks[i].Size.Y*tanks[i].Size.Z)*10
        else
            resourceVolumes[resource] = (tanks[i].Size.X*tanks[i].Size.Y*tanks[i].Size.Z)*10
            resourceAmounts[resource] = 0
        end
    end
end

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.fromOffset(canvas.AbsoluteSize.X,canvas.AbsoluteSize.Y)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
scrollingFrame.ZIndex = 0
scrollingFrame.Parent = canvas

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0,scrollingFrame.AbsoluteCanvasSize.X*0.025)
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.Wraps = true
uiListLayout.Parent = scrollingFrame

local smaller = canvas.AbsoluteSize.X > canvas.AbsoluteSize.Y and canvas.AbsoluteSize.Y or canvas.AbsoluteSize.X
local maxSize = math.floor(scrollingFrame.AbsoluteWindowSize.X/ELEMENTS_PER_ROW)-scrollingFrame.AbsoluteWindowSize.X*0.0125

local exists = false
for key,value in resourceVolumes do
    local titleCard = Instance.new("TextButton")
    titleCard.Text = key
    titleCard.TextScaled = true
    titleCard.TextColor3 = Color3.fromRGB(189,189,189)
    titleCard.Size = UDim2.fromOffset(maxSize,maxSize)
    titleCard.BackgroundColor3 = Color3.fromRGB(55,55,55)
    titleCard.ZIndex = 1
    titleCard.Parent = scrollingFrame
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0,titleCard.AbsoluteSize.X*0.05)
    uiCorner.Parent = titleCard

    local incomeIndicator = Instance.new("ImageLabel")
    incomeIndicator.Size = UDim2.fromScale(0.2,0.2)
    incomeIndicator.Position = UDim2.fromScale(0.8,0.8)
    incomeIndicator.BackgroundColor3 = Color3.fromRGB(70,70,70)
    incomeIndicator.ZIndex = 2
    incomeIndicator.Parent = titleCard

    uiCorner:Clone().Parent = incomeIndicator

    task.spawn(function()
        while task.wait(0) do
            local previousAmount = resourceAmounts[key]
            task.wait(1)
            local currentAmount = resourceAmounts[key]
            local income = currentAmount-previousAmount
            if income > 0 then
                incomeIndicator.Image = "rbxassetid://112050049980266"
            elseif income < 0 then
                incomeIndicator.Image = "rbxassetid://86023238174894"
            else
                incomeIndicator.Image = "rbxassetid://100363615717612"
            end
        end
    end)

    titleCard.MouseButton1Down:Connect(function()
        if exists then return end
        exists = true
        local infoBackground = Instance.new("Frame")
        infoBackground.Size = UDim2.fromOffset(smaller/2,smaller/2)
        infoBackground.Position = UDim2.fromOffset((canvas.AbsoluteSize.X-infoBackground.AbsoluteSize.X)/2,(canvas.AbsoluteSize.Y-infoBackground.AbsoluteSize.Y)/2)
        infoBackground.BackgroundColor3 = Color3.fromRGB(55,55,55)
        infoBackground.ZIndex = 3
        infoBackground.Parent = canvas

        uiCorner:Clone().Parent = infoBackground

        local uiStroke = Instance.new("UIStroke")
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Color = Color3.fromRGB(45,45,45)
        uiStroke.Thickness = infoBackground.AbsoluteSize.X*0.025
        uiStroke.Parent = infoBackground
        
        local resourceName = Instance.new("TextLabel")
        resourceName.Text = key
        resourceName.TextScaled = true
        resourceName.TextColor3 = Color3.fromRGB(189,189,189)
        resourceName.BackgroundTransparency = 1
        resourceName.Position = UDim2.fromScale(0,0.05)
        resourceName.Size = UDim2.fromScale(1,0.3)
        resourceName.ZIndex = 4
        resourceName.Parent = infoBackground

        local resourceAmount = Instance.new("TextLabel")
        resourceAmount.Text = 0
        resourceAmount.TextScaled = true
        resourceAmount.TextXAlignment = Enum.TextXAlignment.Right
        resourceAmount.TextColor3 = Color3.fromRGB(189,189,189)
        resourceAmount.BackgroundTransparency = 1
        resourceAmount.Position = UDim2.fromScale(0,0.35)
        resourceAmount.Size = UDim2.fromScale(0.45,0.3)
        resourceAmount.ZIndex = 4
        resourceAmount.Parent = infoBackground

        local divisionSymbol = Instance.new("TextLabel")
        divisionSymbol.Text = "/"
        divisionSymbol.TextScaled = true
        divisionSymbol.TextColor3 = Color3.fromRGB(189,189,189)
        divisionSymbol.BackgroundTransparency = 1
        divisionSymbol.Position = UDim2.fromScale(0.45,0.35)
        divisionSymbol.Size = UDim2.fromScale(0.1,0.3)
        divisionSymbol.ZIndex = 4
        divisionSymbol.Parent = infoBackground

        local resourceCap = Instance.new("TextLabel")
        resourceCap.Text = value
        resourceCap.TextScaled = true
        resourceCap.TextXAlignment = Enum.TextXAlignment.Left
        resourceCap.TextColor3 = Color3.fromRGB(189,189,189)
        resourceCap.BackgroundTransparency = 1
        resourceCap.Position = UDim2.fromScale(0.55,0.35)
        resourceCap.Size = UDim2.fromScale(0.45,0.3)
        resourceCap.ZIndex = 4
        resourceCap.Parent = infoBackground

        local netLabel = Instance.new("TextLabel")
        netLabel.Text = "Net income:"
        netLabel.TextScaled = true
        netLabel.TextXAlignment = Enum.TextXAlignment.Right
        netLabel.TextColor3 = Color3.fromRGB(189,189,189)
        netLabel.BackgroundTransparency = 1
        netLabel.Position = UDim2.fromScale(0,0.7)
        netLabel.Size = UDim2.fromScale(0.5,0.2)
        netLabel.ZIndex = 4
        netLabel.Parent = infoBackground

        local netIncome = Instance.new("TextLabel")
        netIncome.Text = "0"
        netIncome.TextScaled = true
        netIncome.TextXAlignment = Enum.TextXAlignment.Right
        netIncome.TextColor3 = Color3.fromRGB(189,189,189)
        netIncome.BackgroundTransparency = 1
        netIncome.Position = UDim2.fromScale(0.5,0.7)
        netIncome.Size = UDim2.fromScale(0.2,0.2)
        netIncome.ZIndex = 4
        netIncome.Parent = infoBackground

        local netMeasurement = Instance.new("TextLabel")
        netMeasurement.Text = "/s"
        netMeasurement.TextScaled = true
        netMeasurement.TextXAlignment = Enum.TextXAlignment.Left
        netMeasurement.TextColor3 = Color3.fromRGB(189,189,189)
        netMeasurement.BackgroundTransparency = 1
        netMeasurement.Position = UDim2.fromScale(0.7,0.7)
        netMeasurement.Size = UDim2.fromScale(0.3,0.2)
        netMeasurement.ZIndex = 4
        netMeasurement.Parent = infoBackground

        local update = coroutine.create(function()
            while task.wait(0) do
                local previousAmount = resourceAmounts[key]
                task.wait(1)
                local currentAmount = resourceAmounts[key]
                netIncome.Text = currentAmount-previousAmount
                resourceAmount.Text = currentAmount
            end
        end)

        coroutine.resume(update)

        local exitButton = Instance.new("TextButton")
        exitButton.Text = "X"
        exitButton.TextScaled = true
        exitButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
        exitButton.TextColor3 = Color3.fromRGB(189,189,189)
        exitButton.Size = UDim2.fromScale(0.1,0.1)
        exitButton.Position = UDim2.fromScale(0.9,0)
        exitButton.ZIndex = 5
        exitButton.Parent = infoBackground

        uiCorner:Clone().Parent = exitButton

        exitButton.MouseButton1Down:Connect(function()
            infoBackground:Destroy()
            exists = false
            coroutine.close(update)
        end)
    end)
end

while task.wait(1) do
    for key in resourceAmounts do
        resourceAmounts[key] = 0
    end

    if bins then
        for i = 1, #bins do
            local resource = bins[i].Resource
            resourceAmounts[resource] += bins[i]:GetResourceAmount()
        end
    end
    
    if tanks then
        for i = 1, #tanks do
            local resource = tanks[i].Resource
            resourceAmounts[resource] += tanks[i]:GetResourceAmount()
        end
    end
end
