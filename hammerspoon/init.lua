require("hs.ipc")

local function launchOrFocus(bundleID)
    hs.application.launchOrFocusByBundleID(bundleID)
end

hs.hotkey.bind({"alt"}, "1", function()
    launchOrFocus("com.mitchellh.ghostty")
end)
hs.hotkey.bind({"alt"}, "2", function()
    launchOrFocus("com.microsoft.VSCode")
end)
hs.hotkey.bind({"alt"}, "3", function()
    launchOrFocus("com.google.Chrome")
end)
hs.hotkey.bind({"alt"}, "4", function()
    launchOrFocus("com.tinyspeck.slackmacgap")
end)

local vscodeBundleIDs = {
    ["com.microsoft.VSCode"] = true,
    ["com.microsoft.VSCodeInsiders"] = true,
}

local function nativeTabsIn(window)
    for _, child in ipairs(window:attributeValue("AXChildren") or {}) do
        if child:attributeValue("AXRole") == "AXTabGroup" then
            local tabs = child:attributeValue("AXTabs")
            if tabs then
                return tabs
            end
        end
    end
end

local function selectVSCodeTab(index)
    local app = hs.application.frontmostApplication()
    if not app or not vscodeBundleIDs[app:bundleID()] then
        return false
    end

    local axApp = hs.axuielement.applicationElement(app)
    local window = axApp:attributeValue("AXFocusedWindow")
    local tabs = window and nativeTabsIn(window)
    local tab = tabs and tabs[index]
    if not tab then
        return false
    end

    tab:performAction("AXPress")
    return true
end

vscodeTabListener = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    local flags = event:getFlags()
    if not flags.cmd or flags.alt or flags.ctrl or flags.shift or flags.fn then
        return false
    end

    local index = tonumber(hs.keycodes.map[event:getKeyCode()])
    if index and selectVSCodeTab(index) then
        return true
    end

    return false
end)
vscodeTabListener:start()
