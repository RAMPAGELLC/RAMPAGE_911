# RAMPAGE_911
Advanced 911 system with a Rich API for external scripts. With this system you are able to have 911 location marked for emergency personnel & directions.

# Server Exports
```lua
exports.RAMPAGE_911.GetCalls() -- Returns array of all calls.
exports.RAMPAGE_911.DeleteCall(CallId) -- Delete Call
exports.RAMPAGE_911.CreateCall(PlayerId, Reason) -- Returns CallId
exports.RAMPAGE_911.RegisterResponder(PlayerId) -- Adds player to list to be alerted of calls
exports.RAMPAGE_911.RemoveResponder(PlayerId) -- Removes play from list to be alerted of calls
exports.RAMPAGE_911.GetResponders() -- Returns active first responders
```

# Client Exports
```lua
exports["kimi_callbacks"]:Trigger("RAMPAGE_911:GetResponders")
exports["kimi_callbacks"]:Trigger("RAMPAGE_911:GetCalls")
exports["kimi_callbacks"]:Trigger("RAMPAGE_911:CreateCall", Reason)
```

# Dependencies
ox_lib (https://github.com/overextended/ox_lib)
kimi_callbacks (https://github.com/Kiminaze/kimi_callbacks)