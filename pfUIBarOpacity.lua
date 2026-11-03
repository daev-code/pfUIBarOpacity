-- pfUI Bar Opacity
--
-- Out of combat, pfUI's action bars are shown at a shared default opacity, or a per-bar one;
-- in combat, and while the mouse is over a bar (optional, on by default), they're fully
-- opaque.
--
-- Settings live in pfUI's own config (pfUI_config.bars.ooc_alpha_default,
-- pfUI_config.bars.barN.ooc_alpha = "default" or a value, pfUI_config.bars.ooc_mouseover)
-- and are edited in pfUI's config window:
-- Actionbar > OOC Opacity. Bars with pfUI's own Autohide enabled are left alone - Autohide
-- controls their opacity itself.
--
-- Registered as a pfUI module, so it loads after pfUI's gui and actionbar modules.

if not pfUI or not pfUI.RegisterModule then return end

pfUI:RegisterModule("baropacity", "vanilla:tbc", function()
	local BARS = {
		{ 1, "Main Actionbar" }, { 6, "Top Actionbar" }, { 5, "Left Actionbar" },
		{ 3, "Right Actionbar" }, { 4, "Vertical Actionbar" }, { 2, "Paging Actionbar" },
		{ 7, "Stance Bar 1" }, { 8, "Stance Bar 2" }, { 9, "Stance Bar 3" }, { 10, "Stance Bar 4" },
		{ 11, "Shapeshift Bar" }, { 12, "Pet Actionbar" },
	}

	-- One-time switch to the "Default" setting: before it existed every bar stored "1" (100%)
	-- as its default, so turn those into "default" to make them follow the new setting.
	if pfUI_config.bars and pfUI_config.bars.ooc_alpha_default == nil then
		for _, b in ipairs(BARS) do
			local cfg = pfUI_config.bars["bar" .. b[1]]
			if cfg and cfg.ooc_alpha == "1" then cfg.ooc_alpha = "default" end
		end
	end

	-- defaults (only filled in where missing)
	pfUI:UpdateConfig("bars", nil, "ooc_alpha_default", "1")
	for _, b in ipairs(BARS) do
		pfUI:UpdateConfig("bars", "bar" .. b[1], "ooc_alpha", "default")
	end
	pfUI:UpdateConfig("bars", nil, "ooc_mouseover", "1")

	local inCombat = UnitAffectingCombat("player") and true or false

	local function targetAlpha(i, bar)
		local cfg = C.bars["bar" .. i]
		if not cfg or cfg.autohide == "1" then return nil end  -- Autohide owns this bar
		if inCombat then return 1 end
		if C.bars.ooc_mouseover == "1" and MouseIsOver(bar) then return 1 end
		local a = tonumber(cfg.ooc_alpha) or tonumber(C.bars.ooc_alpha_default) or 1  -- "default" -> the shared value
		if a < 0.1 then a = 0.1 end
		if a > 1 then a = 1 end
		return a
	end

	local function apply()
		if not pfUI.bars then return end
		for _, b in ipairs(BARS) do
			local i = b[1]
			local bar = pfUI.bars[i]
			if bar and bar.SetAlpha then
				local a = targetAlpha(i, bar)
				if a and math.abs(bar:GetAlpha() - a) > 0.001 then
					bar:SetAlpha(a)
				end
			end
		end
	end

	-- Combat state, plus a light poll (10/s) for mouseover and for pfUI resetting alpha when
	-- it rebuilds a bar.
	local f = CreateFrame("Frame")
	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:RegisterEvent("PLAYER_REGEN_ENABLED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function()
		if event == "PLAYER_REGEN_DISABLED" then
			inCombat = true
		elseif event == "PLAYER_REGEN_ENABLED" then
			inCombat = false
		else
			inCombat = UnitAffectingCombat("player") and true or false
		end
		apply()
	end)
	local nextTick = 0
	f:SetScript("OnUpdate", function()
		local now = GetTime()
		if now < nextTick then return end
		nextTick = now + 0.1
		apply()
	end)

	-- Settings page: pfUI config > Actionbar > OOC Opacity
	if pfUI.gui and pfUI.gui.CreateGUIEntry and pfUI.gui.CreateConfig then
		local T = pfUI.env and pfUI.env.T or setmetatable({}, { __index = function(_, k) return k end })
		local values = {}
		for v = 10, 1, -1 do
			table.insert(values, (v == 10 and "1" or ("0." .. v)) .. ":" .. (v * 10) .. "%")
		end

		-- per bar: "Default" (follow the shared value) or its own percentage
		local barValues = { "default:Default" }
		for _, v in ipairs(values) do table.insert(barValues, v) end

		pfUI.gui.CreateGUIEntry(T["Actionbar"], "OOC Opacity", function()
			local CreateConfig = pfUI.gui.CreateConfig
			CreateConfig(nil, "Out Of Combat Opacity", nil, nil, "header")
			CreateConfig(apply, "Full Opacity On Mouseover", C.bars, "ooc_mouseover", "checkbox")
			CreateConfig(apply, "Default Opacity (All Bars)", C.bars, "ooc_alpha_default", "dropdown", values)
			CreateConfig(nil, "Per Bar (Default = Use The Value Above)", nil, nil, "header")
			for _, b in ipairs(BARS) do
				CreateConfig(apply, T[b[2]], C.bars["bar" .. b[1]], "ooc_alpha", "dropdown", barValues)
			end
		end)
	end

	apply()
end)
