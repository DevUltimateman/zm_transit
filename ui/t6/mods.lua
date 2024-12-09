require( "T6.Lobby" )
require( "T6.Menus.PopupMenus" )
require( "T6.ListBox" )

local ModsInfo = {}
local CurrentModInfo = {}
local modPrefix = CoD.isZombie and "zm_" or "mp_"

CoD.ModInfo = {}

CoD.ModInfo.new = function()
	local self = LUI.UIVerticalList.new()
	self.id = "ModInfo"

	self:setLeftRight( true, true, 0, 0 )
	self:setTopBottom( true, true, 0, 0 )

	local title = LUI.UIText.new()
	title:setLeftRight( true, false, 0, 0 )
	title:setTopBottom( true, false, 0, 42 )
	title:setRGB( CoD.BOIIOrange.r, CoD.BOIIOrange.g, CoD.BOIIOrange.b )
	title:setFont( CoD.fonts.Big )
	self:addElement( title )
	self.title = title

	local author = LUI.UIText.new()
	author:setLeftRight( true, false, 0, 0 )
	author:setTopBottom( true, false, 0, 26 )
	author:setFont( CoD.fonts.Big )
	self:addElement( author )
	self.author = author

	local description = LUI.UIText.new()
	description:setLeftRight( true, false, 0, 0 )
	description:setTopBottom( true, false, 0, 26 )
	description:setFont( CoD.fonts.Big )
	self:addElement( description )
	self.description = description

	local version = LUI.UIText.new()
	version:setLeftRight( true, false, 0, 0 )
	version:setTopBottom( true, false, 0, 26 )
	version:setFont( CoD.fonts.Big )
	self:addElement( version )
	self.version = version

	return self
end

local function LoadMod( self, event )
	if CurrentModInfo and CurrentModInfo.modname ~= nil then
		Engine.Exec( 0, "loadmod " .. CurrentModInfo.modname .. "\n" )
	end
end

function LUI.createMenu.LoadModModal( controller )
	local self = CoD.Menu.NewSmallPopup( "LoadModModal" )
	self.m_ownerController = controller

	self:addBackButton()
	self:addTitle( "Load Mod?" )

	self.buttonList = CoD.ButtonList.new( {
		leftAnchor = true,
		rightAnchor = false,
		left = 0,
		right = CoD.ButtonList.DefaultWidth,
		topAnchor = true,
		bottomAnchor = true,
		top = CoD.textSize.Big + 10,
		bottom = 0
	} )

	self.yesButton = self.buttonList:addButton( Engine.Localize( "YES" ) )
	self.yesButton:registerEventHandler( "button_action", LoadMod )

	self:addElement( self.buttonList )
	self.buttonList:processEvent( { name = "gain_focus" } )

	Engine.PlaySound( "cac_loadout_edit_sel" )

	return self
end

local function modListCreateButtonMutables( controller, mutables )
	local text = LUI.UIText.new()
	text:setLeftRight( true, false, 0, 0 )
	text:setTopBottom( true, true, 0, 0 )
	text:setRGB( 1, 1, 1 )
	text:setAlpha( 1 )
	mutables:addElement( text )
	mutables.text = text
end

local function modListGetButtonData( controller, index, mutables, self )
	local modInfo = ModsInfo[index]
	if modInfo ~= nil then
		mutables.text:setText( modInfo.name )
	else
		mutables.text:setText( "" )
	end
end

local function modListBackEventHandler( self, event )
	CoD.Menu.ButtonPromptBack( self, event )
end

local function modListRefreshEventHandler( self, event )
	for k in pairs( ModsInfo ) do
		ModsInfo[k] = nil
	end

	local modCount = Engine.GetModCount()
	for i = 0, modCount - 1, 1 do
		local modInfo = Engine.GetModInfo( i )
		if not modInfo then
			break
		end
		table.insert( ModsInfo, modInfo )
	end

	self.listBox:setTotalItems( modCount )
	Engine.PlaySound( "cac_grid_equip_item" )
end

local function modListUnloadEventHandler( self, event )
	if Dvar.fs_game:get() ~= "" then
		Engine.Exec( 0, "loadmod \"\"" )
	end
end

local function modListFocusChangedEventHandler( self, event )
	local focusedIndex = self.listBox:getFocussedIndex()

	local modInfo = ModsInfo[focusedIndex]
	if modInfo ~= nil then
		self.modInfo.title:setText( modInfo.name )
		self.modInfo.author:setText( "Author: " .. modInfo.author )
		self.modInfo.description:setText( "Description: " .. modInfo.description )
		self.modInfo.version:setText( "Version: " .. modInfo.version )
	end
end

local function modListSelectionClickedEventHandler( self, event )
	local focusedIndex = self.listBox:getFocussedIndex()

	local modInfo = ModsInfo[focusedIndex]
	if modInfo ~= nil then
		CurrentModInfo = modInfo
		self:openPopup( "LoadModModal", event.controller )
		return
	end

	CurrentModInfo = nil
end

local function modListInit( self )
	self.leftButtonPromptBar:removeAllChildren()
	self.rightButtonPromptBar:removeAllChildren()
	self:addLeftButtonPrompt( self.backButton )
	self:addRightButtonPrompt( self.unloadButton )
	self:addRightButtonPrompt( self.refreshButton )

	for k in pairs( ModsInfo ) do
		ModsInfo[k] = nil
	end

	local modCount = Engine.GetModCount()
	for i = 0, modCount - 1, 1 do
		local modInfo = Engine.GetModInfo( i )
		if not modInfo then
			break
		end
		table.insert( ModsInfo, modInfo )
	end

	self.listBox:setTotalItems( modCount )
	self.listBox:refresh()
end

function LUI.createMenu.Mods( controller )
	local self = CoD.Menu.New( "Mods" )
	self.controller = controller

	self:setPreviousMenu( "MainLobby" )
	self:registerEventHandler( "open_menu", CoD.Lobby.OpenMenu )
	self:addSelectButton()
	self:addBackButton()

	self:addTitle( "Mods" )

	local listBox = CoD.ListBox.new( nil, controller, 15, CoD.CoD9Button.Height, 500, modListCreateButtonMutables, modListGetButtonData, 0, 0 )
	listBox:setLeftRight( true, false, 0, 500 )
	listBox:setTopBottom( true, false, 75, 75 + 530 )
	listBox:addScrollBar( 530 + (8 * 12), 2 )
	listBox.noDataText = "No mods found for the current mode.\nMake sure mod is prefixed with \"" .. modPrefix .. "\" to be found."
	self:addElement( listBox )
	self.listBox = listBox

	local modInfo = CoD.ModInfo.new()
	modInfo:setLeftRight( true, false, 550, 550 + 500 )
	modInfo:setTopBottom( true, false, 75, 75 + 530 )
	self:addElement( modInfo )
	self.modInfo = modInfo

	self.backButton = CoD.ButtonPrompt.new( "secondary", Engine.Localize( "MENU_BACK" ), self, "button_prompt_back" )
	self.unloadButton = CoD.ButtonPrompt.new( "alt1", "Unload", self, "button_prompt_unload", false, nil, false, nil, "U" )
	self.refreshButton = CoD.ButtonPrompt.new( "alt2", Engine.Localize( "MENU_REFRESH" ), self, "button_prompt_refresh", false, nil, false, nil, "R" )

	self:registerEventHandler( "button_prompt_back", modListBackEventHandler )
	self:registerEventHandler( "button_prompt_refresh", modListRefreshEventHandler )
	self:registerEventHandler( "button_prompt_unload", modListUnloadEventHandler )
	self:registerEventHandler( "listbox_focus_changed", modListFocusChangedEventHandler )
	self:registerEventHandler( "click", modListSelectionClickedEventHandler )

	modListInit( self )

	return self
end
