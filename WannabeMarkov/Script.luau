--!strict
local microphone=assert(Network:GetPart("Microphone"),"\n\tERROR: Missing microphone!")
local speaker=assert(Network:GetPart("Speaker"),"\n\tERROR: Missing speaker!")
local disk=assert(Network:GetPart("Disk"),"\n\tERROR: Missing disk!")

if not disk:Read("Beginning") then
    disk:Clear()
    disk:Write("Beginning",{})
end

local function OnChatted(UserID,Message)
    local messageComponents=string.split(Message," ")
    local beginning:{string}=disk:Read("Beginning")
    if not table.find(beginning,messageComponents[1]) then
        table.insert(beginning,messageComponents[1])
        disk:Write("Beginning",beginning)
    end
    for i=1,#messageComponents do
        local words:{string}=disk:Read(messageComponents[i])
        if not words then
            disk:Write(messageComponents[i],{"End"})
            if not messageComponents[i+1] then disk:Write(messageComponents[i],{messageComponents[i+1]}) end
            words=disk:Read(messageComponents[i])
        end     
        if messageComponents[i+1] then
            if not table.find(words,messageComponents[i+1]) then table.insert(words,messageComponents[i+1]) end
        else
            if not table.find(words,"End") then table.insert(words,"End") end
        end
        disk:Write(messageComponents[i],words)
    end
    local dictionary=disk:ReadAll()
    local currentWord=beginning[math.random(1,#beginning)]
    local response=currentWord
    while true do
        currentWord=dictionary[currentWord][math.random(1,#dictionary[currentWord])]
        if currentWord=="End" then break end
        response..=" "..currentWord
    end
    response=#response>200 and "balls" or response
    speaker:Chat(response)
end

microphone.Chatted:Connect(OnChatted)
