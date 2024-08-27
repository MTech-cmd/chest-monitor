-- install.lua
local chestMonitorUrl = "https://raw.githubusercontent.com/MTech-cmd/chest-monitor/main/chest_monitor.lua"

-- Download the chest_monitor.lua script
print("Downloading chest_monitor.lua...")
local response = http.get(chestMonitorUrl)

if response then
    local scriptContent = response.readAll()
    response.close()

    -- Save the script to chest_monitor.lua
    local file = fs.open("chest_monitor.lua", "w")
    file.write(scriptContent)
    file.close()

    print("Downloaded and saved as chest_monitor.lua.")

    -- Define the line to add to startup.lua
    local startupLine = 'shell.run("chest_monitor.lua")'

    -- Check if startup.lua exists
    if fs.exists("startup.lua") then
        -- Open startup.lua in append mode
        local startupFile = fs.open("startup.lua", "a")

        -- Read the content of startup.lua to check if the line already exists
        local existingContent = fs.open("startup.lua", "r").readAll()
        if not string.find(existingContent, startupLine) then
            -- Append the line if it doesn't exist
            startupFile.write("\n" .. startupLine)
            print("Appended chest_monitor.lua command to existing startup.lua.")
        else
            print("Command already exists in startup.lua.")
        end

        startupFile.close()
    else
        -- Create a new startup.lua if it doesn't exist
        local startupFile = fs.open("startup.lua", "w")
        startupFile.write(startupLine)
        startupFile.close()

        print("Created new startup.lua with chest_monitor.lua command.")
    end

    -- Restart the computer to start the chest monitor
    print("Rebooting the system...")
    os.reboot()
else
    print("Failed to download chest_monitor.lua. Check your URL and try again.")
end
