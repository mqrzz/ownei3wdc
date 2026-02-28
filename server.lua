-- NektoChat Server Script for Roblox

-- Create RemoteEvents for communication
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local chatEvent = Instance.new("RemoteEvent")
chatEvent.Name = "ChatEvent"
chatEvent.Parent = ReplicatedStorage

-- Define a table to hold users
local users = {}

-- Function to match users and create a chat group
local function matchUsers(user1, user2)
    -- Matching logic can be enhanced based on user criteria
    return user1, user2
end

-- Function to handle incoming chat messages
local function onChatMessage(player, message)
    -- Age filtering can be applied here
    local age = players[player.UserId].age -- Example where player details are stored
    if age >= 13 then
        -- Process message
        for _, user in ipairs(users) do
            if user ~= player then
                chatEvent:FireClient(user, message)
            end
        end
    else
        player:Kick("You must be at least 13 years old to chat")
    end
end

-- Function to handle player joining the game
game.Players.PlayerAdded:Connect(function(player)
    -- Initialize player age and other variables here
    users[player.UserId] = { age = 0 } -- Default age (should be set properly)
    
    -- Setup receiving messages
    chatEvent.OnServerEvent:Connect(function(player, message)
        onChatMessage(player, message)
    end)

    player.Leaving:Connect(function()
        users[player.UserId] = nil -- Cleanup on player leave
    end)
end)

-- Initialization message
print("NektoChat server script running...")
