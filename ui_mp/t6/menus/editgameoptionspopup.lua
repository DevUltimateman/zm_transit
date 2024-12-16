require("T6.GameOptions")
local CheckTeamPresetClasses, CloseEditGameOptionsPopup, OpenGamemodeSpecificSettings, OpenGeneralSettings, OpenHealthAndDamageSettings, OpenSpawnSettings, OpenCustomClasses, OpenPresetClasses, ResetOptions, SaveOptions, UpdateStarIcon, UpdateCustomClassesStarIcon, UpdatePresetClassesStarIcon = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil

local AlwaysShow = function()
	return true
end

local GameOptionsDvars = {
	allowAimAssist = {
		name = "Aim Assist",
		setting = "sv_allowAimAssist",
		hintText = "Allow aim assist option for all controller players.",
		labels = CoD.GameOptions.AllowedDisallowedLabels,
		values = CoD.GameOptions.AllowedDisallowedValues,
		shouldShow = AlwaysShow
	}
}

local GameOptionsDvarsNames = {
	"allowAimAssist"
}

local addDvarSetting = function (EditGameOptionsPopup, LocalClientIndex, Setting, f18_arg3)
	local GametypeSetting = GameOptionsDvars[Setting]
	if not f18_arg3 and GametypeSetting.shouldShow and not GametypeSetting.shouldShow() then
		return 
	elseif GametypeSetting.setting then
		Setting = GametypeSetting.setting
	end
	local HintText = GametypeSetting.hintText
	if HintText then
		HintText = Engine.Localize(HintText)
	end
	local f18_local2 = EditGameOptionsPopup.buttonList:addDvarLeftRightSelector(LocalClientIndex, Engine.Localize(GametypeSetting.name), Setting, HintText)
	for f18_local7, DvarValue in ipairs(GametypeSetting.values) do
		local DvarName = DvarValue
		if GametypeSetting.labels then
			DvarName = GametypeSetting.labels[f18_local7]
			if not DvarName then
				DvarName = GametypeSetting.labels[#GametypeSetting.labels]
			end
			DvarName = Engine.Localize(DvarName, DvarValue)
		end
		f18_local2:addChoice(LocalClientIndex, DvarName, DvarValue, nil)
	end
	return f18_local2
end

LUI.createMenu.EditGameOptions = function (LocalClientIndex)
	local EditGameOptionsPopup = CoD.GameOptionsMenu.New(LocalClientIndex, "EditGameOptions")
	local Gametype = Dvar.ui_gametype:get()
	local f1_local2 = UIExpression.TableLookup(LocalClientIndex, CoD.gametypesTable, 0, 0, 1, Gametype, 2)
	EditGameOptionsPopup:addTitle(Engine.Localize("MPUI_RULES_CAPS", Engine.Localize(f1_local2)))
	EditGameOptionsPopup.resetToDefaultButton = CoD.ButtonPrompt.new("select", Engine.Localize("MENU_RESET_TO_DEFAULT"), EditGameOptionsPopup, "button_prompt_reset_to_default", false, false, false, false, "R")
	EditGameOptionsPopup:addRightButtonPrompt(EditGameOptionsPopup.resetToDefaultButton)
	EditGameOptionsPopup.saveButton = CoD.ButtonPrompt.new("alt1", Engine.Localize("MENU_SAVE"), EditGameOptionsPopup, "button_prompt_reset_to_default", false, false, false, false, "S")
	if Engine.SessionModeIsMode(CoD.SESSIONMODE_ONLINE) then
		EditGameOptionsPopup:addRightButtonPrompt(EditGameOptionsPopup.saveButton)
	end
	EditGameOptionsPopup:registerEventHandler("button_prompt_back", CloseEditGameOptionsPopup)
	EditGameOptionsPopup:registerEventHandler("button_prompt_reset_to_default", ResetOptions)
	EditGameOptionsPopup:registerEventHandler("button_prompt_save_game_settings", SaveOptions)
	EditGameOptionsPopup:registerEventHandler("open_game_mode_specific_settings", OpenGamemodeSpecificSettings)
	EditGameOptionsPopup:registerEventHandler("open_general_settings", OpenGeneralSettings)
	EditGameOptionsPopup:registerEventHandler("open_health_and_damage_settings", OpenHealthAndDamageSettings)
	EditGameOptionsPopup:registerEventHandler("open_spawn_settings", OpenSpawnSettings)
	EditGameOptionsPopup:registerEventHandler("open_custom_classes", OpenCustomClasses)
	EditGameOptionsPopup:registerEventHandler("open_default_classes", OpenPresetClasses)
	if CoD.GameOptions.TopLevelGametypeSettings[Gametype] and #CoD.GameOptions.TopLevelGametypeSettings[Gametype] > 0 then
		for Key, GametypeSetting in ipairs(CoD.GameOptions.TopLevelGametypeSettings[Gametype]) do
			EditGameOptionsPopup:addGametypeSetting(LocalClientIndex, GametypeSetting)
		end
	end
	if CoD.GameOptions.GlobalTopLevelGametypeSettings and #CoD.GameOptions.GlobalTopLevelGametypeSettings > 0 then
		for Key, GametypeSetting in ipairs(CoD.GameOptions.GlobalTopLevelGametypeSettings) do
			EditGameOptionsPopup:addGametypeSetting(LocalClientIndex, GametypeSetting)
		end
	end
	if GameOptionsDvarsNames and #GameOptionsDvarsNames > 0 then
		for Key, DvarSetting in ipairs(GameOptionsDvarsNames) do
			addDvarSetting(EditGameOptionsPopup, LocalClientIndex, DvarSetting)
		end
	end
	if not (not CoD.GameOptions.TopLevelGametypeSettings[Gametype] or #CoD.GameOptions.TopLevelGametypeSettings[Gametype] <= 0) or CoD.GameOptions.GlobalTopLevelGametypeSettings and #CoD.GameOptions.GlobalTopLevelGametypeSettings > 0 then
		EditGameOptionsPopup.buttonList:addSpacer(CoD.CoD9Button.Height / 2)
	end
	if CoD.GameOptions.SubLevelGametypeSettings[Gametype] and #CoD.GameOptions.SubLevelGametypeSettings[Gametype] > 0 then
		local GamemodeSettingsButton = EditGameOptionsPopup.buttonList:addButton(Engine.Localize("MPUI_GAME_MODE_SETTINGS_CAPS", Engine.Localize(f1_local2)))
		GamemodeSettingsButton:setActionEventName("open_game_mode_specific_settings")
		GamemodeSettingsButton:registerEventHandler("button_update", UpdateStarIcon)
		GamemodeSettingsButton.gametypeSettings = CoD.GameOptions.SubLevelGametypeSettings[Gametype]
		CoD.GameOptions.ShowStarForGametypeSettings(GamemodeSettingsButton, CoD.GameOptions.SubLevelGametypeSettings[Gametype])
	end
	local GeneralSettingsButton = EditGameOptionsPopup.buttonList:addButton(Engine.Localize("MPUI_GENERAL_SETTINGS_CAPS"))
	GeneralSettingsButton.gametypeSettings = CoD.GameOptions.GeneralSettings
	GeneralSettingsButton:setActionEventName("open_general_settings")
	GeneralSettingsButton:registerEventHandler("button_update", UpdateStarIcon)
	CoD.GameOptions.ShowStarForGametypeSettings(GeneralSettingsButton, CoD.GameOptions.GeneralSettings)
	local SpawnSettingsButton = EditGameOptionsPopup.buttonList:addButton(Engine.Localize("MENU_SPAWN_SETTINGS_CAPS"))
	SpawnSettingsButton.gametypeSettings = CoD.GameOptions.SpawnSettings
	SpawnSettingsButton:setActionEventName("open_spawn_settings")
	SpawnSettingsButton:registerEventHandler("button_update", UpdateStarIcon)
	CoD.GameOptions.ShowStarForGametypeSettings(SpawnSettingsButton, CoD.GameOptions.SpawnSettings)
	local HealthAndDamageSettingsButton = EditGameOptionsPopup.buttonList:addButton(Engine.Localize("MENU_HEALTH_AND_DAMAGE_SETTINGS_CAPS"))
	HealthAndDamageSettingsButton.gametypeSettings = CoD.GameOptions.HealthAndDamageSettings
	HealthAndDamageSettingsButton:setActionEventName("open_health_and_damage_settings")
	HealthAndDamageSettingsButton:registerEventHandler("button_update", UpdateStarIcon)
	CoD.GameOptions.ShowStarForGametypeSettings(HealthAndDamageSettingsButton, CoD.GameOptions.HealthAndDamageSettings)
	EditGameOptionsPopup.buttonList:addSpacer(CoD.CoD9Button.Height / 2)
	if Engine.GetGametypeSetting("disableClassSelection", true) == 0 then
		local CustomizeClassesButton = EditGameOptionsPopup.buttonList:addButton(Engine.Localize("MENU_CUSTOM_CLASSES_CAPS"))
		CustomizeClassesButton:setActionEventName("open_custom_classes")
		CustomizeClassesButton:registerEventHandler("button_update", UpdateCustomClassesStarIcon)
		CustomizeClassesButton.gametypeSettings = CoD.GameOptions.CustomClassSettings
		UpdateCustomClassesStarIcon(CustomizeClassesButton)
		local CustomizePresetClassesButton = EditGameOptionsPopup.buttonList:addButton(Engine.Localize("MENU_PRESET_CLASSES_CAPS"))
		CustomizePresetClassesButton:setActionEventName("open_default_classes")
		CustomizePresetClassesButton:registerEventHandler("button_update", UpdatePresetClassesStarIcon)
		CustomizePresetClassesButton.gametypeSettings = CoD.GameOptions.PresetClassSettings
		UpdatePresetClassesStarIcon(CustomizePresetClassesButton)
	end
	if not EditGameOptionsPopup.buttonList:restoreState() then
		EditGameOptionsPopup.buttonList:processEvent({
			name = "gain_focus"
		})
	end
	return EditGameOptionsPopup
end

CloseEditGameOptionsPopup = function (EditGameOptionsPopup, ClientInstance)
	Engine.PartyHostClearUIState()
	CoD.GameOptionsMenu.ButtonPromptBack(EditGameOptionsPopup, ClientInstance)
end

OpenGamemodeSpecificSettings = function (EditGameOptionsPopup, ClientInstance)
	EditGameOptionsPopup.buttonList:saveState()
	EditGameOptionsPopup:openMenu("EditModeSpecificOptions", ClientInstance.controller)
	EditGameOptionsPopup:close()
end

OpenGeneralSettings = function (EditGameOptionsPopup, ClientInstance)
	EditGameOptionsPopup.buttonList:saveState()
	EditGameOptionsPopup:openMenu("EditGeneralOptions", ClientInstance.controller)
	EditGameOptionsPopup:close()
end

OpenCustomClasses = function (EditGameOptionsPopup, ClientInstance)
	EditGameOptionsPopup.buttonList:saveState()
	EditGameOptionsPopup:openMenu("CustomClassGameOptions", ClientInstance.controller)
	EditGameOptionsPopup:close()
end

OpenPresetClasses = function (EditGameOptionsPopup, ClientInstance)
	EditGameOptionsPopup.buttonList:saveState()
	EditGameOptionsPopup:openMenu("EditDefaultClasses", ClientInstance.controller)
	EditGameOptionsPopup:close()
end

OpenHealthAndDamageSettings = function (EditGameOptionsPopup, ClientInstance)
	EditGameOptionsPopup.buttonList:saveState()
	EditGameOptionsPopup:openMenu("HealthAndDamageSettings", ClientInstance.controller)
	EditGameOptionsPopup:close()
end

OpenSpawnSettings = function (EditGameOptionsPopup, ClientInstance)
	EditGameOptionsPopup.buttonList:saveState()
	EditGameOptionsPopup:openMenu("SpawnSettings", ClientInstance.controller)
	EditGameOptionsPopup:close()
end

ResetOptions = function (EditGameOptionsPopup, ClientInstance)
	Engine.SetGametype(Dvar.ui_gametype:get())
	EditGameOptionsPopup:processEvent({
		name = "button_update"
	})
end

SaveOptions = function (EditGameOptionsPopup, ClientInstance)
	if Engine.CanViewContent() == false then
		EditGameOptionsPopup:openPopup("popup_contentrestricted", ClientInstance.controller)
		return 
	else
		Engine.Exec(ClientInstance.controller, "gamesettings_clearuploadinfo")
		local f10_local0 = UIExpression.TableLookup(ClientInstance.controller, CoD.gametypesTable, 0, 0, 1, Dvar.ui_gametype:get(), 2)
		CoD.perController[ClientInstance.controller].fileshareSaveCategory = "customgame"
		CoD.perController[ClientInstance.controller].fileshareSaveIsCopy = false
		CoD.perController[ClientInstance.controller].fileshareSaveIsPooled = false
		CoD.perController[ClientInstance.controller].fileshareSaveName = Engine.Localize(f10_local0)
		CoD.perController[ClientInstance.controller].fileshareSaveDescription = ""
		EditGameOptionsPopup:openPopup("FileshareSave", ClientInstance.controller)
	end
end

LUI.createMenu.HealthAndDamageSettings = function (LocalClientIndex)
	local HealthAndDamageSettingsPopup = CoD.GameOptionsMenu.New(LocalClientIndex, "HealthAndDamageSettings")
	HealthAndDamageSettingsPopup:addTitle(Engine.Localize("MENU_HEALTH_AND_DAMAGE_SETTINGS_CAPS"))
	for Key, Setting in ipairs(CoD.GameOptions.HealthAndDamageSettings) do
		HealthAndDamageSettingsPopup:addGametypeSetting(LocalClientIndex, Setting)
	end
	if not HealthAndDamageSettingsPopup.buttonList:restoreState() then
		HealthAndDamageSettingsPopup.buttonList:processEvent({
			name = "gain_focus"
		})
	end
	return HealthAndDamageSettingsPopup
end

LUI.createMenu.SpawnSettings = function (LocalClientIndex)
	local SpawnSettingsPopup = CoD.GameOptionsMenu.New(LocalClientIndex, "SpawnSettings")
	SpawnSettingsPopup:addTitle(Engine.Localize("MENU_SPAWN_SETTINGS_CAPS"))
	for Key, Setting in ipairs(CoD.GameOptions.SpawnSettings) do
		SpawnSettingsPopup:addGametypeSetting(LocalClientIndex, Setting)
	end
	if not SpawnSettingsPopup.buttonList:restoreState() then
		SpawnSettingsPopup.buttonList:processEvent({
			name = "gain_focus"
		})
	end
	return SpawnSettingsPopup
end

CheckTeamPresetClasses = function (TeamEnum)
	for Index = 0, 4, 1 do
		if not Engine.IsPresetClassDefault(TeamEnum, Index) then
			return false
		end
	end
	return true
end

UpdateStarIcon = function (Button, ClientInstance)
	CoD.GameOptions.ShowStarForGametypeSettings(Button, Button.gametypeSettings)
end

UpdateCustomClassesStarIcon = function (CustomizeClassesButton, ClientInstance)
	if CoD.GameOptions.ShowStarForGametypeSettings(CustomizeClassesButton, CustomizeClassesButton.gametypeSettings) then
		return 
	end
	for f15_local0 = 0, 255, 1 do
		if Engine.IsItemIndexRestricted(f15_local0) ~= Engine.IsItemIndexRestricted(f15_local0, true) then
			CustomizeClassesButton:showStarIcon(true)
			return 
		end
	end
	if CoD.GameOptions.AreAnyAttachmentsRestricted() then
		CustomizeClassesButton:showStarIcon(true)
		return 
	end
	CustomizeClassesButton:showStarIcon(false)
end

UpdatePresetClassesStarIcon = function (CustomizePresetClassesButton, ClientInstance)
	if CoD.GameOptions.ShowStarForGametypeSettings(CustomizePresetClassesButton, CustomizePresetClassesButton.gametypeSettings) then
		return 
	elseif Engine.GetGametypeSetting("presetClassesPerTeam") == 0 then
		if not CheckTeamPresetClasses(CoD.TEAM_FREE) then
			CustomizePresetClassesButton:showStarIcon(true)
			return 
		end
	else
		local TeamCount = Engine.GetGametypeSetting("teamCount")
		for TeamIndex = 0, TeamCount - 1, 1 do
			if not CheckTeamPresetClasses(CoD.TEAM_FIRST_PLAYING_TEAM + TeamIndex) then
				CustomizePresetClassesButton:showStarIcon(true)
				return 
			end
		end
	end
	CustomizePresetClassesButton:showStarIcon(false)
end

