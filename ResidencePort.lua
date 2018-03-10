ResidencePort = {}
ResidencePort.name = "ResidencePort"

local function CloseDialog()
	ZO_Dialogs_ReleaseDialog("ResidencePortDialog", false)
end

local function CustomDialog(titleText,mainText)

	local confirmDialog = {
		title = { text = titleText },
		mainText = { text = mainText },
	 	buttons = {
			{
				text = SI_DIALOG_ACCEPT,
				function()

        end,
		 	}
	 }
}

ZO_Dialogs_RegisterCustomDialog("ResidencePortDialog", confirmDialog )
CloseDialog()
ZO_Dialogs_ShowDialog("ResidencePortDialog")
end

function ResidencePort.OnAddOnLoaded(event, addonName)
  if addonName == ResidencePort.name then
  end
end


function ResidencePort.PlayerLoaded(_, initial)

  local primaryContainer = CHAT_SYSTEM.primaryContainer
  local chatWindow = primaryContainer.control

  primaryHouseID = GetHousingPrimaryHouse()
	if primaryHouseID == 0 then
		CustomDialog(ResidencePort.name,"No residence detected")
		return true
	end

  local hString, hDescription, hIcon = GetCollectibleInfo(GetCollectibleIdForHouse(primaryHouseID))

  local button = chatWindow:CreateControl("ResidencePortButton", CT_BUTTON)
  button:SetDimensions(32, 32)
  button:SetNormalTexture(hIcon)
  button:SetPressedOffset(2, 2)
  button:SetClickSound("Click")
  button:SetAnchor(RIGHT, chatWindow:GetNamedChild("Options"), LEFT, 0, 0)
  button:SetHandler("OnMouseEnter", function()
      InitializeTooltip(InformationTooltip, button, BOTTOMLEFT, 0, -2, TOPLEFT)
      SetTooltipText(InformationTooltip, "Port to '" .. hString .. "'")
  end)
  button:SetHandler("OnMouseExit", function()
      ClearTooltip(InformationTooltip)
  end)
  button:SetHandler("OnClicked", function()
      portMainHouse()
  end)
end

  function ResidencePort.updateHouse()

	  primaryHouseID = GetHousingPrimaryHouse()
	  local hString, hDescription, hIcon = GetCollectibleInfo(GetCollectibleIdForHouse(primaryHouseID))

	  ResidencePortButton:SetDimensions(32, 32)
	  ResidencePortButton:SetNormalTexture(hIcon)
		ResidencePortButton:SetHandler("OnMouseEnter", function()
				InitializeTooltip(InformationTooltip, ResidencePortButton, BOTTOMLEFT, 0, -2, TOPLEFT)
				SetTooltipText(InformationTooltip, "Port to '" .. hString .. "'")
		end)

  end

  function portMainHouse()
    primaryHouseID = GetHousingPrimaryHouse()
    RequestJumpToHouse(primaryHouseID)
  end

EVENT_MANAGER:RegisterForEvent(ResidencePort.name, EVENT_ADD_ON_LOADED, ResidencePort.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(ResidencePort.name, EVENT_PLAYER_ACTIVATED, ResidencePort.PlayerLoaded)
EVENT_MANAGER:RegisterForEvent(ResidencePort.name, EVENT_HOUSING_PRIMARY_RESIDENCE_SET, ResidencePort.updateHouse)
