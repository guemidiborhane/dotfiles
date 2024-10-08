local action = require("wezterm").action
function tmuxMapping(mapping)
	local prefix = action.SendKey({ mods = "CTRL", key = "a" })

	return action.Multiple({
		prefix,
		action.SendKey(mapping),
	})
end

return {
	tmuxMapping = tmuxMapping,

	tmuxWindowMappings = function()
		local mappings = {}

		for i = 1, 9 do
			table.insert(mappings, {
				key = tostring(i),
				mods = "CTRL",
				action = tmuxMapping({ key = tostring(i) }),
			})
		end

		return mappings
	end,

	mergeTables = function(src, dest)
		for _, v in ipairs(src) do
			table.insert(dest, v)
		end
	end,
}
