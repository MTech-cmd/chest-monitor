local function getCenteredPosition(monitor, text)
    local monitorWidth = monitor.getSize()
    local textLength = #text
    local centeredX = math.floor((monitorWidth - textLength) / 2) + 1
    return centeredX
end

local function getStartingY(monitor, totalLines)
    local _, monitorHeight = monitor.getSize()
    local startingY = math.floor((monitorHeight - totalLines) / 2) + 1
    return startingY
end

-- chest_monitor.lua
function print_inventory_on_monitor(chest, monitor)
    monitor.clear()
    
    -- Calculate the total lines needed for the display (each item takes 3 lines: name, count, and a blank line)
    local totalLines = (#chest.list() * 3) - 1
    local startingY = getStartingY(monitor, totalLines)
    monitor.setCursorPos(1, startingY)

    for slot, item in pairs(chest.list()) do
        -- Render the item name
        local itemName = string.sub(item.name, 11, -1)
        local centeredXName = getCenteredPosition(monitor, itemName)
        monitor.setCursorPos(centeredXName, select(2, monitor.getCursorPos()))
        monitor.write(itemName)
        
        -- Move to the next line for the count
        local _, y = monitor.getCursorPos()
        monitor.setCursorPos(1, y + 1)

        -- Render the item count in gray
        local itemCount = tostring(item.count) .. "x"
        local centeredXCount = getCenteredPosition(monitor, itemCount)
        monitor.setCursorPos(centeredXCount, select(2, monitor.getCursorPos()))
        monitor.setTextColor(colors.gray)
        monitor.write(itemCount)
        monitor.setTextColor(colors.white)  -- Reset to default color

        -- Move to the next line (blank line)
        local _, y = monitor.getCursorPos()
        monitor.setCursorPos(1, y + 2)
    end
end

-- The while loop to update the monitor every 10 seconds
while true do
    local monitor = peripheral.find("monitor")
    local chest = peripheral.find("minecraft:chest")

    print_inventory_on_monitor(chest, monitor)

    sleep(10)
end
