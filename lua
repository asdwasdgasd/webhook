--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--

local webhookLibrary = {}
local HttpService = cloneref(game:GetService("HttpService"))
local request = request or httprequest or http_request

function webhookLibrary.createMessage(properties)
    assert(properties.Url, "Url required")
    assert(properties.username, "username required")
    assert(properties.content, "content required")

    local requestTable = {
        Url = properties.Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = {
            ["username"] = properties.username,
            ["content"] = properties.content or "",
            ["embeds"] = {}
        }
    }
    local webhookFunctions = {}
    local EmbedIndex = 0
    function webhookFunctions.addEmbed(title: string, color: number, description: string, imageUrl: string, footerText: string, footerIconUrl: string)
        assert(title, "title required")
        assert(description, "description required")
        assert(color, "color required")
    
        EmbedIndex += 1
        local privateIndex = EmbedIndex
    
        -- Prepare the embed table
        local embed = {
            ["title"] = title,
            ["color"] = tonumber(color),
            ["description"] = description,
            ["fields"] = {}
        }
    
        -- Add the image if provided
        if imageUrl and imageUrl ~= "" then
            embed["image"] = {["url"] = imageUrl}
        end
    
        -- Add the footer if provided
        if footerText and footerText ~= "" then
            embed["footer"] = {
                ["text"] = footerText,
                ["icon_url"] = footerIconUrl or nil  -- Add the footer icon URL if provided
            }
        end
    
        -- Insert the embed into the requestTable
        table.insert(requestTable.Body.embeds, embed)
    
        local embedFunctions = {}
    
        -- Function to add fields to the embed
        function embedFunctions.addField(name, value)
            assert(name, "name required")
            assert(value, "value required")
            table.insert(requestTable.Body.embeds[privateIndex].fields, {
                ["name"] = name,
                ["value"] = value
            })
        end
    
        return embedFunctions
    end

    function webhookFunctions.sendMessage()
        requestTable.Body = HttpService:JSONEncode(requestTable.Body)
        local response = request(requestTable)
        return response
    end
    return webhookFunctions
end
return webhookLibrary
