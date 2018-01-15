$PBExportHeader$n_dwsrv_ctrl.sru
$PBExportComments$DataWindow service for menu/button activation control
forward
global type n_dwsrv_ctrl from n_dwsrv_main
end type
end forward

global type n_dwsrv_ctrl from n_dwsrv_main
end type
global n_dwsrv_ctrl n_dwsrv_ctrl

type variables
//-----------------------------------------------------------------------------------------
// Menu/Button Control Service Constants
//-----------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------
//  Menu/Button Service Instance Variables
//-----------------------------------------------------------------------------------------

MENU			i_MenuID
MENU			i_FileMenu
MENU			i_EditMenu

INTEGER		i_NumMenuItems		= 18
MENU			i_MenuItems[18]
STRING			i_MenuLocation[18]
MENU			i_PopupItems[18]
BOOLEAN		i_InitMenu		= TRUE

INTEGER		i_NumButtons		= 26
COMMANDBUTTON	i_Buttons[26]

INTEGER		i_NumEnabled		= 26
BOOLEAN		i_Enabled[26]
BOOLEAN		i_Control[26]

end variables

forward prototypes
public subroutine fu_initmenu ()
public subroutine fu_initbutton ()
public subroutine fu_setcontrol (integer control_type, boolean control_state)
public subroutine fu_securecontrols ()
public subroutine fu_unwire (powerobject control_name)
public subroutine fu_wire (powerobject control_name)
public subroutine fu_autoconfigmenu ()
public subroutine fu_allowcontrol (integer control_type, boolean control_state)
public subroutine fu_setcontrol (integer control_type)
end prototypes

public subroutine fu_initmenu ();//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_InitMenu
//  Description   : Initializes the menu.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumItems, l_NumFileItems, l_NumFileLabels, l_Jdx
INTEGER l_NumEditItems, l_NumLabels, l_NumPopupItems
STRING  l_FileLabel, l_EditLabel, l_FileLabels[], l_Label 
STRING  l_Labels[], l_NextLabel
BOOLEAN l_Found

//------------------------------------------------------------------
//  Determine if a menu is attached to this window.  If not, and
//  the window is a sheet, use the MDI menu.
//------------------------------------------------------------------

IF i_ServiceDW.i_Window.MenuName <> "" THEN
	i_MenuID = i_ServiceDW.i_Window.MenuID
ELSE
	IF i_ServiceDW.i_WindowSheet THEN
		IF FWCA.MGR.i_MDIFrame.MenuName <> "" THEN
			i_MenuID = FWCA.MGR.i_MDIFrame.MenuID
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Locate the File and Edit menu items.
//------------------------------------------------------------------

IF IsValid(i_MenuID) THEN
	l_FileLabel = FWCA.MENU.fu_GetMenuBarLabel("File")
	l_EditLabel = FWCA.MENU.fu_GetMenuBarLabel("Edit")
	l_NumItems = UpperBound(i_MenuID.Item[])
	FOR l_Idx = 1 TO l_NumItems
		CHOOSE CASE i_MenuID.Item[l_Idx].Text
			CASE l_FileLabel
				i_FileMenu = i_MenuID.Item[l_Idx]
			CASE l_EditLabel
				i_EditMenu = i_MenuID.Item[l_Idx]
		END CHOOSE
	NEXT

	//---------------------------------------------------------------
	//  Get the menu items that the DataWindow will control.
	//---------------------------------------------------------------

	IF IsValid(i_FileMenu) THEN
		l_NumFileItems = UpperBound(i_FileMenu.Item[])
	ELSE
		l_NumFileItems = 0
	END IF

	IF IsValid(i_EditMenu) THEN
		l_NumEditItems = UpperBound(i_EditMenu.Item[])
	ELSE
		l_NumEditItems = 0
	END IF

	IF IsValid(i_ServiceDW.i_PopupID) THEN
		l_NumPopupItems = UpperBound(i_ServiceDW.i_PopupID.Item[])
	ELSE
		l_NumPopupItems = 0
	END IF
	
	l_NumLabels = FWCA.MENU.fu_GetMenuLabels("DW Activate", l_Labels[])

	FOR l_Idx = 1 TO l_NumLabels
      l_Label = l_Labels[l_Idx]
		l_Found = FALSE

		FOR l_Jdx = 1 TO l_NumEditItems
			IF Pos(i_EditMenu.Item[l_Jdx].Text, l_Label) = 1 THEN
				i_MenuItems[l_Idx] = i_EditMenu.Item[l_Jdx]
				i_MenuLocation[l_Idx] = "EDIT"
				l_Found = TRUE
				EXIT
			END IF
		NEXT

		IF NOT l_Found THEN
			FOR l_Jdx = 1 TO l_NumFileItems
				IF Pos(i_FileMenu.Item[l_Jdx].Text, l_Label) = 1 THEN
					i_MenuItems[l_Idx] = i_FileMenu.Item[l_Jdx]
					i_MenuLocation[l_Idx] = "FILE"
					EXIT
				END IF
			NEXT
		END IF

		FOR l_Jdx = 1 TO l_NumPopupItems
			IF Pos(i_ServiceDW.i_PopupID.Item[l_Jdx].Text, l_Label) = 1 THEN
				i_PopupItems[l_Idx] = i_ServiceDW.i_PopupID.Item[l_Jdx]
				EXIT
			END IF
		NEXT

	NEXT		

	//---------------------------------------------------------------
	//  If auto configuration is set, then configure the menu 
	//  appropriately.
	//---------------------------------------------------------------

	fu_AutoConfigMenu()

ELSE

	//---------------------------------------------------------------
	//  Check to see if we have a valid popup menu.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_PopupID) THEN

		//------------------------------------------------------------
		//  Get the menu items that the DataWindow will control.
		//------------------------------------------------------------

		l_NumPopupItems = UpperBound(i_ServiceDW.i_PopupID.Item[])
		l_NumLabels = FWCA.MENU.fu_GetMenuLabels("DW Activate", l_Labels[])

		FOR l_Idx = 1 TO l_NumLabels
      	l_Label = l_Labels[l_Idx]

			FOR l_Jdx = 1 TO l_NumPopupItems
				IF Pos(i_ServiceDW.i_PopupID.Item[l_Jdx].Text, l_Label) = 1 THEN
					i_PopupItems[l_Idx] = i_ServiceDW.i_PopupID.Item[l_Jdx]
					EXIT
				END IF
			NEXT
		NEXT

	END IF

END IF

i_InitMenu = FALSE
end subroutine

public subroutine fu_initbutton ();//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_InitButton
//  Description   : Initializes the buttons.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

INTEGER       l_Idx, l_NumControls, l_NumUOControls, l_Type
INTEGER       l_Jdx, l_Kdx, l_NumTabControls, l_NumTabPageControls
WINDOWOBJECT  l_Control
USEROBJECT    l_UserObject, l_TabPage
COMMANDBUTTON l_Button
TAB           l_TabObject

//------------------------------------------------------------------
//  Find all the PowerClass buttons on the window, user object and
//  tab object.
//------------------------------------------------------------------

//i_NumButtons = 0

l_NumControls = UpperBound(i_ServiceDW.i_Window.Control[])
FOR l_Idx = 1 TO l_NumControls
	l_Control = i_ServiceDW.i_Window.Control[l_Idx]
	IF l_Control.TypeOf() = CommandButton! THEN
     	l_Button = i_ServiceDW.i_Window.Control[l_Idx]
		IF l_Button.TriggerEvent("po_Identify") = 1 THEN
			l_Type = l_Button.DYNAMIC fu_GetType()
			i_Buttons[l_Type] = l_Button
		END IF
	ELSEIF l_Control.TypeOf() = UserObject! THEN
		l_UserObject = i_ServiceDW.i_Window.Control[l_Idx]
		l_NumUOControls = UpperBound(l_UserObject.Control[])
		FOR l_Jdx = 1 TO l_NumUOControls
			l_Control = l_UserObject.Control[l_Jdx]
			IF l_Control.TypeOf() = CommandButton! THEN
     			l_Button = l_UserObject.Control[l_Jdx]
				IF l_Button.TriggerEvent("po_Identify") = 1 THEN
					l_Type = l_Button.DYNAMIC fu_GetType()
					i_Buttons[l_Type] = l_Button
				END IF
			END IF
		NEXT
	ELSEIF l_Control.TypeOf() = Tab! THEN
		l_TabObject = i_ServiceDW.i_Window.Control[l_Idx]
		l_NumTabControls = UpperBound(l_TabObject.Control[])
		FOR l_Jdx = 1 TO l_NumTabControls
			l_TabPage = l_TabObject.Control[l_Jdx]
			l_NumTabPageControls = UpperBound(l_TabPage.Control[])
			FOR l_Kdx = 1 TO l_NumTabPageControls
				l_Control = l_TabPage.Control[l_Kdx]
				IF l_Control.TypeOf() = CommandButton! THEN
     				l_Button = l_TabPage.Control[l_Kdx]
					IF l_Button.TriggerEvent("po_Identify") = 1 THEN
						l_Type = l_Button.DYNAMIC fu_GetType()
						i_Buttons[l_Type] = l_Button
					END IF
				END IF
			NEXT
		NEXT
	END IF
NEXT

end subroutine

public subroutine fu_setcontrol (integer control_type, boolean control_state);//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_SetControl
//  Description   : Sets a menu item and/or buttons enabled status.
//
//  Parameters    : INTEGER Control_Type -
//                     Menu and/or button to control (e.g. c_New).
//                  BOOLEAN Control_State -
//                     Enabled (TRUE) or disabled (FALSE).
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------
//  PowerBuilder 5.0 Bug
//  
//  This function sets the enable/disable status for command 
//  buttons.  It calls a function in u_CB_Main dynamically and
//  passes this service's DataWindow.  This causes a SHR GPF
//  when exiting the application.  The workaround is to set
//  the DataWindow in FWCA.MGR.i_TmpServiceDW from here and
//  have the commandbutton extract it from there instead of
//  passing it in fu_SetEnabled. If this problem is 
//  ever fixed the fu_SetEnabled function can pass the 
//  DataWindow directly.
//
//  Powersoft Issue Number: ?
//  Reported by           : Bill Carson
//  Report Date           : 7/15/96
//------------------------------------------------------------

IF control_type > 0 AND control_type <= i_NumEnabled THEN
	IF control_type <= i_NumMenuItems THEN
		IF IsNull(i_MenuItems[control_type]) = FALSE THEN
			i_MenuItems[control_type].Enabled = control_state
		END IF
		IF IsNull(i_PopupItems[control_type]) = FALSE THEN
			i_PopupItems[control_type].Enabled = control_state
		END IF
	END IF
	IF IsNull(i_Buttons[control_type]) = FALSE THEN
		FWCA.MGR.i_TmpServiceDW = i_ServiceDW
		i_Buttons[control_type].DYNAMIC fu_SetEnabled(control_state)
//		i_Buttons[control_type].DYNAMIC fu_SetEnabled(i_ServiceDW, control_state)
	END IF
END IF
end subroutine

public subroutine fu_securecontrols ();//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_SecureControls
//  Description   : If PowerLock is being used, remove PowerClass
//                  control from enabling and disabling menus and
//                  buttons.  PowerLock will be in control.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER       l_Idx
BOOLEAN       l_Visible, l_Enabled, l_DragDrop
MENU          l_Menu
COMMANDBUTTON l_Button

//------------------------------------------------------------------
//  Check for menu items.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumMenuItems
	IF IsNull(i_MenuItems[l_Idx]) = FALSE THEN
		l_Menu = i_MenuItems[l_Idx]
		
		SECCA.MGR.DYNAMIC fu_GetObjectSecurity(i_ServiceDW.i_Window, &
                                             l_Menu, l_Visible, &
                                             l_Enabled, l_DragDrop)
		IF NOT l_Visible OR NOT l_Enabled THEN
			i_Control[l_Idx] = FALSE
			IF NOT l_Visible THEN
				i_MenuItems[l_Idx].Visible = FALSE
			END IF
			IF NOT l_Enabled THEN
				i_MenuItems[l_Idx].Enabled = FALSE
			END IF
		END IF
	END IF
NEXT

//------------------------------------------------------------------
//  Check for buttons.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumButtons
	IF IsNull(i_Buttons[l_Idx]) = FALSE THEN
		l_Button = i_Buttons[l_Idx]
		
		SECCA.MGR.DYNAMIC fu_GetObjectSecurity(i_ServiceDW.i_Window, &
                                             l_Button, l_Visible, &
                                             l_Enabled, l_DragDrop)
		IF NOT l_Visible OR NOT l_Enabled THEN
			i_Control[l_Idx] = FALSE
			IF NOT l_Visible THEN
				i_Buttons[l_Idx].Visible = FALSE
			END IF
			IF NOT l_Enabled THEN
				i_Buttons[l_Idx].Enabled = FALSE
			END IF
		END IF
	END IF
NEXT

	
end subroutine

public subroutine fu_unwire (powerobject control_name);//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_Unwire
//  Description   : Unwire a button from this DataWindow service.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name to unwire.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER       l_Idx
COMMANDBUTTON l_Button

l_Button = control_name
FOR l_Idx = 1 TO i_NumButtons
	IF i_Buttons[l_Idx] = l_Button THEN
		SetNull(i_Buttons[l_Idx])
	END IF
NEXT

end subroutine

public subroutine fu_wire (powerobject control_name);//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_Wire
//  Description   : Wire a button to this DataWindow service.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name to wire.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER       l_Type
COMMANDBUTTON l_Button

l_Button = control_name
l_Type = l_Button.DYNAMIC fu_GetType()
i_Buttons[l_Type] = l_Button

end subroutine

public subroutine fu_autoconfigmenu ();//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_AutoConfigMenu
//  Description   : Determines if the menu needs to be automatically
//                  configured for this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_Idx, l_NumFileItems, l_NumFileLabels, l_Jdx
STRING     l_FileLabels[], l_Label, l_Labels[], l_NextLabel

//------------------------------------------------------------------
//  If auto configuration is set, then configure the menu 
//  appropriately if it had been configured by a sheet with no
//  DataWindow before.
//------------------------------------------------------------------

IF i_ServiceDW.i_AutoConfigMenus THEN

	IF IsValid(i_EditMenu) OR i_InitMenu THEN

		//---------------------------------------------------------
		//  Configure the menu items under "File".
		//---------------------------------------------------------

		IF IsValid(i_FileMenu) THEN
			l_NumFileLabels = FWCA.MENU.fu_GetMenuLabels("DW Config", &
                       	   l_FileLabels[])
			l_NumFileItems = UpperBound(i_FileMenu.Item[])
			FOR l_Idx = 1 TO l_NumFileLabels
      		l_Label = l_FileLabels[l_Idx]
				IF l_Label = "-" THEN
					l_NextLabel = l_FileLabels[l_Idx + 1]
					FOR l_Jdx = 1 TO l_NumFileItems - 1
						IF Pos(i_FileMenu.Item[l_Jdx].Text, l_Label) = 1 AND &
							i_FileMenu.Item[l_Jdx + 1].Text = l_NextLabel THEN
							IF FWCA.MGR.i_MDIAutoConfigHide THEN
								i_FileMenu.Item[l_Jdx].Visible = TRUE
							ELSE
								i_FileMenu.Item[l_Jdx].Enabled = TRUE
							END IF
							EXIT
						END IF
					NEXT
				ELSE
					FOR l_Jdx = 1 TO l_NumFileItems
						IF Pos(i_FileMenu.Item[l_Jdx].Text, l_Label) = 1 THEN
							IF FWCA.MGR.i_MDIAutoConfigHide THEN
								i_FileMenu.Item[l_Jdx].Visible = TRUE
							ELSE
								i_FileMenu.Item[l_Jdx].Enabled = TRUE
							END IF
							EXIT
						END IF
					NEXT
				END IF
			NEXT
		END IF

		//---------------------------------------------------------
		//  Configure the menu items under "Edit".
		//---------------------------------------------------------

		IF IsValid(i_EditMenu) THEN
			i_EditMenu.Visible = TRUE
			i_EditMenu.Enabled = TRUE

			IF FWCA.MGR.i_MDIAutoConfigHide THEN
				FOR l_Idx = 1 TO i_NumMenuItems
					IF i_MenuLocation[l_Idx] = "EDIT" THEN
						i_MenuItems[l_Idx].Visible = TRUE
					END IF
				NEXT
			END IF
		END IF

	END IF

END IF

end subroutine

public subroutine fu_allowcontrol (integer control_type, boolean control_state);//******************************************************************
//  PC Module     : u_DW_Main
//  Subroutine    : fu_AllowControl
//  Description   : Indicates whether PowerClass should control the
//                  enabling and disabling of a menu or button item.
//
//  Parameters    : INTEGER Control_Type -
//                     Menu and/or button to control (e.g. c_New).
//                  BOOLEAN Control_State -
//                     PowerClass controlled (TRUE) or not (FALSE).
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF control_type > 0 AND control_type <= i_NumEnabled THEN
	i_Control[control_type] = control_state
END IF
end subroutine

public subroutine fu_setcontrol (integer control_type);//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Subroutine    : fu_SetControl
//  Description   : Sets the controls based on the DataWindows
//                  capabilities.
//
//  Parameters    : INTEGER Control_Type -
//                     Control or control groups to set the 
//                     enable/disable status on.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  8/22/2001 K. Claver Added code to check if menu items are valid
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

U_DW_MAIN  l_ScrollDW
INTEGER    l_Idx, l_NumSearch, l_NumFilter
USEROBJECT l_Objects[]
DWITEMSTATUS l_RowStatus

//------------------------------------------------------------
//  PowerBuilder 5.0 Bug
//  
//  This function sets the enable/disable status for command 
//  buttons.  It calls a function in u_CB_Main dynamically and
//  passes this service's DataWindow.  This causes a SHR GPF
//  when exiting the application.  The workaround is to set
//  the DataWindow in FWCA.MGR.i_TmpServiceDW from here and
//  have the commandbutton extract it from there instead of
//  passing it in fu_SetEnabled. If this problem is 
//  ever fixed the fu_SetEnabled function can pass the 
//  DataWindow directly.
//
//  Powersoft Issue Number: ?
//  Reported by           : Bill Carson
//  Report Date           : 7/15/96
//------------------------------------------------------------

FWCA.MGR.i_TmpServiceDW = i_ServiceDW

//------------------------------------------------------------------
//  Set the New and Insert controls.
//------------------------------------------------------------------

IF control_type = c_New OR control_type = c_Insert OR &
	control_type = c_AllControls OR control_type = c_ModeControls OR &
	control_type = c_ScrollControls THEN

	i_Enabled[c_New] = TRUE
	IF i_ServiceDW.i_AllowNew THEN
		IF i_ServiceDW.i_CurrentMode = i_ServiceDW.c_NewMode AND &
			i_ServiceDW.i_OnlyOneNewRow AND NOT i_ServiceDW.i_IsEmpty THEN
			i_Enabled[c_New] = FALSE
		END IF
	ELSE
		IF NOT i_ServiceDW.i_EnableNewOnOpen THEN
			i_Enabled[c_New] = FALSE
		END IF
	END IF
	IF i_ServiceDW.i_IsQuery OR NOT i_ServiceDW.i_PLAllowNew THEN
		i_Enabled[c_New] = FALSE
	END IF
	i_Enabled[c_Insert] = i_Enabled[c_New]

	FOR l_Idx = c_New TO c_Insert
		IF IsNull(i_Buttons[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_Buttons[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_Enabled[l_Idx])
//				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[l_Idx])
			END IF
		END IF
		IF IsNull(i_MenuItems[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_MenuItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_MenuItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
		IF IsValid( i_PopupItems[l_Idx] ) AND NOT IsNull(i_PopupItems[l_Idx]) AND i_Control[l_Idx] THEN
			IF i_PopupItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_PopupItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
	NEXT

END IF

//------------------------------------------------------------------
//  Set the Modify and View controls.
//------------------------------------------------------------------

IF control_type = c_Modify OR control_type = c_View OR &
	control_type = c_AllControls OR control_type = c_ModeControls OR &
	control_type = c_ScrollControls THEN

	i_Enabled[c_Modify] = FALSE
	i_Enabled[c_View]   = FALSE
	IF NOT i_ServiceDW.i_IsQuery THEN
		IF i_ServiceDW.i_AllowModify OR i_ServiceDW.i_EnableModifyOnOpen THEN
			IF i_ServiceDW.i_NumSelected > 0 THEN
				i_Enabled[c_Modify] = TRUE
			END IF
		END IF
		i_Enabled[c_View] = (i_ServiceDW.i_NumSelected > 0)
	END IF
	
	FOR l_Idx = c_View TO c_Modify
		IF IsNull(i_Buttons[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_Buttons[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_Enabled[l_Idx])
//				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[l_Idx])
			END IF
		END IF
		IF IsNull(i_MenuItems[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_MenuItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_MenuItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
		IF IsValid( i_PopupItems[l_Idx] ) AND NOT IsNull(i_PopupItems[l_Idx]) AND i_Control[l_Idx] THEN
			IF i_PopupItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_PopupItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
	NEXT

END IF

//------------------------------------------------------------------
//  Set the Delete and Copy controls.
//------------------------------------------------------------------

IF control_type = c_Delete OR control_type = c_Copy OR &
	control_type = c_AllControls OR control_type = c_ModeControls OR &
	control_type = c_ScrollControls THEN

	i_Enabled[c_Delete] = FALSE
	IF NOT i_ServiceDW.i_IsEmpty AND NOT i_ServiceDW.i_IsQuery THEN
		IF i_ServiceDW.i_AllowDelete OR i_ServiceDW.i_AllowNew THEN
			IF i_ServiceDW.i_DWSRV_EDIT.i_HaveNew THEN
 				l_RowStatus = i_ServiceDW.GetItemStatus(i_ServiceDW.i_CursorRow, 0, Primary!)
				IF l_RowStatus = New! OR l_RowStatus = NewModified! THEN
					i_Enabled[c_Delete] = TRUE
				ELSE
					i_Enabled[c_Delete] = (i_ServiceDW.i_AllowDelete AND &
					              	  		  i_ServiceDW.i_NumSelected > 0)
				END IF
			ELSE
				i_Enabled[c_Delete] = (i_ServiceDW.i_AllowDelete AND &
					              	  	  i_ServiceDW.i_NumSelected > 0)
			END IF
		END IF
	END IF

	i_Enabled[c_Copy] = FALSE
	IF NOT i_ServiceDW.i_IsEmpty AND NOT i_ServiceDW.i_IsQuery THEN
		i_Enabled[c_Copy] = (i_ServiceDW.i_AllowCopy AND &
							      i_ServiceDW.i_NumSelected > 0)
	END IF

	IF NOT IsNull(i_Buttons[c_Delete]) AND i_Control[c_Delete] THEN
		IF i_Buttons[c_Delete].Enabled <> i_Enabled[c_Delete] THEN
			IF GetFocus() = i_Buttons[c_Delete] AND i_Enabled[c_Delete] = FALSE THEN
				i_ServiceDW.SetFocus()
			END IF
			i_Buttons[c_Delete].DYNAMIC fu_SetEnabled(i_Enabled[c_Delete])
//			i_Buttons[c_Delete].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[c_Delete])
		END IF
	END IF
	IF NOT IsNull(i_MenuItems[c_Delete]) AND i_Control[c_Delete] THEN
		IF i_MenuItems[c_Delete].Enabled <> i_Enabled[c_Delete] THEN
			i_MenuItems[c_Delete].Enabled = i_Enabled[c_Delete]
		END IF
	END IF
	IF IsValid( i_PopupItems[c_Delete] ) AND NOT IsNull(i_PopupItems[c_Delete]) AND i_Control[c_Delete] THEN
		IF i_PopupItems[c_Delete].Enabled <> i_Enabled[c_Delete] THEN
			i_PopupItems[c_Delete].Enabled = i_Enabled[c_Delete]
		END IF
	END IF

	IF NOT IsNull(i_Buttons[c_Copy]) AND i_Control[c_Copy] THEN
		IF i_Buttons[c_Copy].Enabled <> i_Enabled[c_Copy] THEN
			IF GetFocus() = i_Buttons[c_Copy] AND i_Enabled[c_Copy] = FALSE THEN
				i_ServiceDW.SetFocus()
			END IF
			i_Buttons[c_Copy].DYNAMIC fu_SetEnabled(i_Enabled[c_Copy])
//			i_Buttons[c_Copy].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[c_Copy])
		END IF
	END IF
	IF NOT IsNull(i_MenuItems[c_Copy]) AND i_Control[c_Copy] THEN
		IF i_MenuItems[c_Copy].Enabled <> i_Enabled[c_Copy] THEN
			i_MenuItems[c_Copy].Enabled = i_Enabled[c_Copy]
		END IF
	END IF
	IF IsValid( i_PopupItems[c_Copy] ) AND NOT IsNull(i_PopupItems[c_Copy]) AND i_Control[c_Copy] THEN
		IF i_PopupItems[c_Copy].Enabled <> i_Enabled[c_Copy] THEN
			i_PopupItems[c_Copy].Enabled = i_Enabled[c_Copy]
		END IF
	END IF

END IF

//------------------------------------------------------------------
//  Set the Scroll controls.
//------------------------------------------------------------------

IF control_type = c_First OR control_type = c_Previous OR &
	control_type = c_Next OR control_type = c_Last OR &
	control_type = c_AllControls OR control_type = c_ScrollControls THEN

	i_Enabled[c_First]    = TRUE
	i_Enabled[c_Previous] = TRUE
	i_Enabled[c_Next]     = TRUE
	i_Enabled[c_Last]     = TRUE

	l_ScrollDW = i_ServiceDW.fu_GetScrollDW()

	IF l_ScrollDW.i_IsEmpty THEN
		i_Enabled[c_First]    = FALSE
		i_Enabled[c_Previous] = FALSE
		i_Enabled[c_Next]     = FALSE
		i_Enabled[c_Last]     = FALSE
	ELSE
		i_Enabled[c_First]    = (l_ScrollDW.i_CursorRow > 1 AND &
                               NOT i_ServiceDW.i_IsQuery)
		i_Enabled[c_Previous] = i_Enabled[c_First]
		i_Enabled[c_Last]     = (l_ScrollDW.RowCount() > 1 AND &
                                          l_ScrollDW.i_CursorRow < &
                                          l_ScrollDW.RowCount() AND &
                                          NOT i_ServiceDW.i_IsQuery)
		i_Enabled[c_Next]     = i_Enabled[c_Last]
	END IF

	FOR l_Idx = c_First TO c_Last
		IF IsNull(i_Buttons[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_Buttons[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_Enabled[l_Idx])
//				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[l_Idx])
			END IF
		END IF
		IF IsNull(i_MenuItems[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_MenuItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_MenuItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
		IF IsValid( i_PopupItems[l_Idx] ) AND NOT IsNull(i_PopupItems[l_Idx]) AND i_Control[l_Idx] THEN
			IF i_PopupItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_PopupItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
	NEXT

END IF

//------------------------------------------------------------------
//  Set the Seek controls.
//------------------------------------------------------------------

IF control_type = c_Query OR control_type = c_Search OR &
	control_type = c_Filter OR &
	control_type = c_AllControls OR control_type = c_SeekControls THEN

	i_Enabled[c_Query]       = TRUE
	i_Enabled[c_Search]      = FALSE
	i_Enabled[c_Filter]      = FALSE
	IF NOT i_ServiceDW.i_AllowQuery THEN
		i_Enabled[c_Query]    = FALSE
	END IF
	
	IF IsValid(i_ServiceDW.i_DWSRV_SEEK) THEN
		l_NumSearch = i_ServiceDW.i_DWSRV_SEEK.fu_GetObjects(1, l_Objects[])
		i_Enabled[c_Search]      = (l_NumSearch > 0 OR i_ServiceDW.i_AllowQuery)
		i_Enabled[c_ResetSearch] = (l_NumSearch > 0 AND NOT i_ServiceDW.i_AllowQuery)
		l_NumFilter = i_ServiceDW.i_DWSRV_SEEK.fu_GetObjects(2, l_Objects[])	
		i_Enabled[c_Filter]      = (l_NumFilter > 0 AND NOT i_ServiceDW.i_IsQuery)
		i_Enabled[c_ResetFilter] = (l_NumFilter > 0 AND NOT i_ServiceDW.i_IsQuery)
	END IF

	FOR l_Idx = c_Query TO c_Filter
		IF IsNull(i_Buttons[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_Buttons[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_Enabled[l_Idx])
//				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[l_Idx])
			END IF
		END IF
		IF IsNull(i_MenuItems[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_MenuItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_MenuItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
		IF IsValid( i_PopupItems[l_Idx] ) AND NOT IsNull(i_PopupItems[l_Idx]) AND i_Control[l_Idx] THEN
			IF i_PopupItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_PopupItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
	NEXT
	FOR l_Idx = c_ResetSearch TO c_ResetFilter
		IF IsNull(i_Buttons[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_Enabled[l_Idx])
//			i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[l_Idx])
		END IF
	NEXT

END IF
	
//------------------------------------------------------------------
//  Set the Content controls.
//------------------------------------------------------------------

IF control_type = c_Save OR control_type = c_SaveRowsAs OR &
	control_type = c_Print OR control_type = c_Sort OR &
	control_type = c_AllControls OR control_type = c_ContentControls OR &
	control_type = c_ModeControls THEN

	i_Enabled[c_Save]    	= TRUE

	i_Enabled[c_Print]      = (NOT i_ServiceDW.i_IsEmpty AND &
                              NOT i_ServiceDW.i_IsQuery)
	i_Enabled[c_SaveRowsAs] = (NOT i_ServiceDW.i_IsEmpty AND &
                              NOT i_ServiceDW.i_IsQuery)
	i_Enabled[c_Sort]       = TRUE

	FOR l_Idx = c_Sort TO c_Print
		IF IsNull(i_Buttons[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_Buttons[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_Enabled[l_Idx])
//				i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[l_Idx])
			END IF
		END IF
		IF IsNull(i_MenuItems[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
			IF i_MenuItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_MenuItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
		IF IsValid( i_PopupItems[l_Idx] ) AND NOT IsNull(i_PopupItems[l_Idx]) AND i_Control[l_Idx] THEN
			IF i_PopupItems[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
				i_PopupItems[l_Idx].Enabled = i_Enabled[l_Idx]
			END IF
		END IF
	NEXT

END IF

//------------------------------------------------------------------
//  Set the remaining controls.
//------------------------------------------------------------------

i_Enabled[c_Close]      = TRUE
i_Enabled[c_ResetQuery] = (i_ServiceDW.i_AllowQuery AND i_ServiceDW.i_IsQuery)
i_Enabled[c_Accept]     = TRUE
i_Enabled[c_OK]         = TRUE
i_Enabled[c_Cancel]     = TRUE
i_Enabled[c_Retrieve]   = (NOT i_ServiceDW.i_IsQuery)
i_Enabled[c_Message]    = (NOT i_ServiceDW.i_IsQuery)

IF NOT IsNull(i_MenuItems[c_Close]) AND i_Control[c_Close] THEN
	IF i_MenuItems[c_Close].Enabled <> i_Enabled[c_Close] THEN
		i_MenuItems[c_Close].Enabled = i_Enabled[c_Close]
	END IF
END IF
IF IsValid( i_PopupItems[c_Close] ) AND NOT IsNull(i_PopupItems[c_Close]) AND i_Control[c_Close] THEN
	IF i_PopupItems[c_Close].Enabled <> i_Enabled[c_Close] THEN
		i_PopupItems[c_Close].Enabled = i_Enabled[c_Close]
	END IF
END IF
FOR l_Idx = c_Close TO c_Message
	IF IsNull(i_Buttons[l_Idx]) = FALSE AND i_Control[l_Idx] THEN
		IF i_Buttons[l_Idx].Enabled <> i_Enabled[l_Idx] THEN
			i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_Enabled[l_Idx])
//			i_Buttons[l_Idx].DYNAMIC fu_SetEnabled(i_ServiceDW, i_Enabled[l_Idx])
		END IF
	END IF
NEXT

i_ServiceDW.Event pcd_SetControl(control_type)
end subroutine

on n_dwsrv_ctrl.create
call super::create
end on

on n_dwsrv_ctrl.destroy
call super::destroy
end on

event constructor;call super::constructor;//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Event         : Constructor
//  Description   : Initializes service variables.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

//------------------------------------------------------------------
//  Initialize the service arrays.
//------------------------------------------------------------------

FOR l_Idx = i_NumEnabled TO 1 STEP -1
	IF l_Idx <= i_NumMenuItems THEN
		SetNull(i_MenuItems[l_Idx])
		SetNull(i_PopupItems[l_Idx])
		i_MenuLocation[l_Idx] = ""
	END IF
	SetNull(i_Buttons[l_Idx])
	i_Enabled[l_Idx] = TRUE
	i_Control[l_Idx] = TRUE
NEXT

end event

event destructor;call super::destructor;//******************************************************************
//  PC Module     : n_DWSRV_CTRL
//  Event         : Destructor
//  Description   : Unwire the controls from the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

//------------------------------------------------------------------
//  Unwire any buttons that were wired.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumButtons
	IF IsNull(i_Buttons[l_Idx]) = FALSE THEN
		IF IsValid(i_Buttons[l_Idx]) THEN
			i_Buttons[l_Idx].DYNAMIC fu_UnwireDW()
		END IF
	END IF
NEXT

end event

