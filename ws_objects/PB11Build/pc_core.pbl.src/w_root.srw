$PBExportHeader$w_root.srw
$PBExportComments$Window ancestor for w_mdi_frame, w_main, w_response
forward
global type w_root from window
end type
end forward

global type w_root from window
integer x = 398
integer y = 288
integer width = 2048
integer height = 1348
boolean titlebar = true
string title = "ROOT WINDOW"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 80269524
boolean toolbarvisible = false
event pc_setoptions pbm_custom75
event pc_move pbm_move
event pc_setvariables ( powerobject powerobject_parm,  string string_parm,  double numeric_parm )
end type
global w_root w_root

type variables
//-----------------------------------------------------------------------------------------
//  Window Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "Window"

CONSTANT INTEGER	c_Fatal			= -1
CONSTANT INTEGER	c_Success		= 0
CONSTANT STRING	c_Default			= "000|"

CONSTANT STRING	c_LoadCodeTable		= "001|"
CONSTANT STRING	c_NoLoadCodeTable	= "002|"

CONSTANT STRING	c_EnablePopup		= "003|"
CONSTANT STRING	c_NoEnablePopup		= "004|"

CONSTANT STRING	c_NoResizeWin		= "005|"
CONSTANT STRING	c_ResizeWin		= "006|"
CONSTANT STRING	c_ZoomWin		= "007|"

CONSTANT STRING	c_NoAutoMinimize		= "008|"
CONSTANT STRING	c_AutoMinimize		= "009|"

CONSTANT STRING	c_NoAutoPosition		= "010|"
CONSTANT STRING	c_AutoPosition		= "011|"

CONSTANT STRING	c_NoSavePosition		= "012|"
CONSTANT STRING	c_SavePosition		= "013|"

CONSTANT STRING	c_ClosePromptUser		= "014|"
CONSTANT STRING	c_CloseSave		= "015|"
CONSTANT STRING	c_CloseNoSave		= "016|"

CONSTANT STRING	c_ToolBarNone		= "017|"
CONSTANT STRING	c_ToolBarTop		= "018|"
CONSTANT STRING	c_ToolBarBottom		= "019|"
CONSTANT STRING	c_ToolBarLeft		= "020|"
CONSTANT STRING	c_ToolBarRight		= "021|"
CONSTANT STRING	c_ToolBarFloat		= "022|"

CONSTANT STRING	c_ToolBarHideText		= "023|"
CONSTANT STRING	c_ToolBarShowText	= "024|"

CONSTANT STRING	c_ToolBarHideTips		= "025|"
CONSTANT STRING	c_ToolBarShowTips	= "026|"

CONSTANT STRING	c_NoShowResources	= "027|"
CONSTANT STRING	c_ShowResources		= "028|"

CONSTANT STRING	c_NoShowClock		= "029|"
CONSTANT STRING	c_ShowClock		= "030|"

CONSTANT STRING	c_NoAutoConfigMenus	= "031|"
CONSTANT STRING	c_AutoConfigMenus	= "032|"

CONSTANT STRING	c_ShowMicrohelp		= "033|"
CONSTANT STRING	c_NoShowMicrohelp	= "034|"

//-----------------------------------------------------------------------------------------
//  Window Instance Variables
//-----------------------------------------------------------------------------------------

BOOLEAN		i_EnablePopup		= TRUE
BOOLEAN		i_AutoMinimize		= FALSE
BOOLEAN		i_AutoPosition		= FALSE
BOOLEAN		i_SavePosition		= FALSE
BOOLEAN		i_ResizeWin		= FALSE
BOOLEAN		i_ZoomWin		= FALSE
BOOLEAN		i_LoadCodeTable		= TRUE
BOOLEAN		i_ToolbarText		= FALSE
BOOLEAN		i_ToolbarTips		= FALSE
BOOLEAN		i_ShowResources		= FALSE
BOOLEAN		i_ShowClock		= FALSE
BOOLEAN		i_AutoConfigMenus		= FALSE
BOOLEAN		i_ShowMicrohelp		= FALSE

STRING			i_ToolbarPosition
STRING			i_SaveOnClose

MENU			i_MenuID
MENU			i_PopupID
MENU			i_FileMenu
MENU			i_EditMenu
BOOLEAN		i_ToolbarFromMDI		= FALSE

INTEGER		i_WindowX
INTEGER		i_WindowY
INTEGER		i_WindowWidth
INTEGER		i_WindowHeight
INTEGER		i_ControlSizes[]

WINDOWSTATE		i_WindowState
BOOLEAN		i_WindowSheet

n_cst_resize inv_resize
end variables

forward prototypes
public subroutine fw_deletewindowlist ()
public subroutine fw_initmenu ()
public function integer fw_setpopup (menu menu_name)
public subroutine fw_initpopup ()
public subroutine fw_setoptions (string options)
public function integer of_setresize (boolean ab_switch)
public function string fw_getkeyvalue (string table_name)
public subroutine fw_addwindowlist ()
public subroutine fw_setposition ()
public subroutine fw_saveposition ()
end prototypes

event pc_move;//******************************************************************
//  PC Module     : w_Root
//  Event         : pc_Move
//  Description   : Executes when the window is moved.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the save position option is on, save the position to the
//  INI file.
//------------------------------------------------------------------

//IF i_SavePosition THEN
//	fw_SavePosition()
//END IF
end event

public subroutine fw_deletewindowlist ();//******************************************************************
//  PC Module     : w_Root
//  Subroutine    : fw_DeleteWindowList
//  Description   : Deletes the window from the window list.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/22/98  Beth Byers	If all of the windows on the current MDI are
//								closed, not just FWCA.MGR.i_NumWindows = 
//								FWCA.MGR.i_CloseToWindow, then trigger the 
//								Activate event on the MDI frame
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Jdx, l_NumWindows

//------------------------------------------------------------------
//  Check to see if this window is an MDI Frame.
//------------------------------------------------------------------

IF WindowType = MDI! OR &
   WindowType = MDIHelp! THEN
	FWCA.MGR.i_MDIValid = FALSE
	SetNull(FWCA.MGR.i_MDIFrame)
	SetNull(FWCA.MGR.i_MDIClient)

   //---------------------------------------------------------------
   //  If the MDI window has a microhelp line then destroy the
   //  microhelp manager.
   //---------------------------------------------------------------

	IF WindowType = MDIHelp! THEN
		IF IsValid(FWCA.MDI) THEN
			FWCA.MGR.fu_DestroyManagers(FWCA.c_MicrohelpManager)
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  If window is not an MDI window, remove the window from the list.
//------------------------------------------------------------------

l_Jdx = 0
FOR l_Idx = 1 TO FWCA.MGR.i_NumWindows
	IF FWCA.MGR.i_WindowList[l_Idx] <> THIS THEN
		l_Jdx = l_Jdx + 1
		FWCA.MGR.i_WindowList[l_Jdx] = FWCA.MGR.i_WindowList[l_Idx]
		FWCA.MGR.i_MDIList[l_Jdx] = FWCA.MGR.i_MDIList[l_Idx]
	END IF
NEXT

FWCA.MGR.i_NumWindows = l_Jdx

//------------------------------------------------------------------
//  Find out how many windows are on this MDI.
//  If all windows are closed except an MDI window, execute the
//  activate event on the MDI because PowerBuilder doesn't do it.
//------------------------------------------------------------------

FOR l_Idx = 1 to FWCA.MGR.i_NumWindows
	IF FWCA.MGR.i_MDIList[l_Idx] = FWCA.MGR.i_MDIFrame THEN
		l_NumWindows++
	END IF
NEXT

IF l_NumWindows = 0 AND IsNull(FWCA.MGR.i_MDIFrame) = FALSE THEN
	IF IsValid(FWCA.MGR.i_MDIFrame) THEN
		FWCA.MGR.i_MDIFrame.TriggerEvent("Activate")
	END IF
END IF

//------------------------------------------------------------------
//  If all windows are closed then exit the application.
//------------------------------------------------------------------

IF FWCA.MGR.i_NumWindows = 0 AND IsNull(FWCA.MGR.i_MDIFrame) <> FALSE THEN
	HALT CLOSE
END IF
end subroutine

public subroutine fw_initmenu ();//******************************************************************
//  PC Module     : w_Root
//  Subroutine    : fw_InitMenu
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumItems, l_NumFileItems, l_NumFileLabels, l_Jdx
STRING  l_FileLabel, l_EditLabel, l_FileLabels[], l_Label, l_NextLabel

//------------------------------------------------------------------
//  Determine if a menu is attached to this window.  If not, and
//  the window is a sheet, use the MDI menu.
//------------------------------------------------------------------

IF MenuName <> "" THEN
	i_MenuID = MenuID
ELSE
	IF i_WindowSheet THEN
		IF FWCA.MGR.i_MDIFrame.MenuName <> "" THEN
			i_MenuID = FWCA.MGR.i_MDIFrame.MenuID
			i_ToolbarFromMDI = TRUE
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  If this is a MDI window and auto configuration is set, then
//  configure the menu appropriately.
//------------------------------------------------------------------

IF IsValid(i_MenuID) THEN
	IF FWCA.MGR.i_MDIFrame = THIS AND i_AutoConfigMenus THEN
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

		l_NumFileLabels = FWCA.MENU.fu_GetMenuLabels("MDI Config", &
                        l_FileLabels[])
		l_NumFileItems = UpperBound(i_FileMenu.Item[])
		FOR l_Idx = 1 TO l_NumFileLabels
      	l_Label = l_FileLabels[l_Idx]
			IF l_Label = "-" THEN
				l_NextLabel = l_FileLabels[l_Idx + 1]
				FOR l_Jdx = 1 TO l_NumFileItems - 1
					IF i_FileMenu.Item[l_Jdx].Text = l_Label AND &
						i_FileMenu.Item[l_Jdx + 1].Text = l_NextLabel THEN
						IF FWCA.MGR.i_MDIAutoConfigHide THEN
							i_FileMenu.Item[l_Jdx].Visible = FALSE
						ELSE
							i_FileMenu.Item[l_Jdx].Enabled = FALSE
						END IF
						EXIT
					END IF
				NEXT
			ELSE
				FOR l_Jdx = 1 TO l_NumFileItems
					IF i_FileMenu.Item[l_Jdx].Text = l_Label THEN
						IF FWCA.MGR.i_MDIAutoConfigHide THEN
							i_FileMenu.Item[l_Jdx].Visible = FALSE
						ELSE
							i_FileMenu.Item[l_Jdx].Enabled = FALSE
						END IF
						EXIT
					END IF
				NEXT
			END IF
		NEXT

		IF IsValid(i_EditMenu) THEN
			i_EditMenu.Enabled = FALSE
		END IF

	ELSEIF i_WindowSheet AND FWCA.MGR.i_MDIAutoConfigMenus THEN

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

	END IF

END IF
end subroutine

public function integer fw_setpopup (menu menu_name);//******************************************************************
//  PC Module     : w_Root
//  Function      : fw_SetPopup
//  Description   : Specifies a menu to be used as a popup menu.
//
//  Parameters    : MENU Menu_Name -
//                     The POPUP menu that is to be used by the 
//                     window.  
//
//  Return Value  : INTEGER -
//                      0 = popup created.
//                     -1 = popup creation failed or not found.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = c_Fatal

//------------------------------------------------------------------
//  If the passed POPUP menu is valid, then just remember it.
//------------------------------------------------------------------

IF IsValid(Menu_Name) THEN
   i_PopupID = Menu_Name
	l_Return = c_Success
END IF

RETURN l_Return
end function

public subroutine fw_initpopup ();//******************************************************************
//  PC Module     : w_Root
//  Subroutine    : fw_InitPopup
//  Description   : Initializes the popup menu, if requested.
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

//------------------------------------------------------------------
//  If the popup menu is requested but has not been created by the
//  developer using fu_SetPopup, then create it now.
//------------------------------------------------------------------

IF i_EnablePopup THEN
   
	IF NOT IsValid(i_PopupID) THEN
		IF FWCA.MGR.i_MDIFrame = THIS THEN
			i_PopupID = CREATE Using "m_popup_mdi"
		ELSE
			i_PopupID = CREATE Using "m_popup_win"
		END IF
		i_PopupID = i_PopupID.Item[1]
	END IF

END IF

end subroutine

public subroutine fw_setoptions (string options);//******************************************************************
//  PC Module     : w_Root
//  Subroutine    : fw_SetOptions
//  Description   : Sets the window options.
//
//  Parameters    : STRING Options -
//                     Specifies options for how this window is to 
//                     behave.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

TOOLBARALIGNMENT l_ToolbarAlignment
BOOLEAN l_SetVisible, l_ToolbarVisible, l_SetAlignment

//------------------------------------------------------------------
//  Process the code table option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame <> THIS THEN
	IF Pos(options, c_LoadCodeTable) > 0 THEN
		i_LoadCodeTable = TRUE
	ELSEIF Pos(options, c_NoLoadCodeTable) > 0 THEN
		i_LoadCodeTable = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  Process the menu popup option.
//------------------------------------------------------------------

IF Pos(options, c_EnablePopup) > 0 THEN
	i_EnablePopup = TRUE
ELSEIF Pos(options, c_NoEnablePopup) > 0 THEN
	i_EnablePopup = FALSE
END IF

//------------------------------------------------------------------
//  Process the resize option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame <> THIS THEN
	IF Pos(options, c_NoResizeWin) > 0 THEN
		i_ResizeWin = FALSE
		i_ZoomWin   = FALSE
	ELSEIF Pos(options, c_ResizeWin) > 0 THEN
		i_ResizeWin = TRUE
		i_ZoomWin   = FALSE
	ELSEIF Pos(options, c_ZoomWin) > 0 THEN
		i_ResizeWin = TRUE
		i_ZoomWin   = TRUE
	END IF
END IF

//------------------------------------------------------------------
//  Process the auto minimize option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame <> THIS THEN
	IF Pos(options, c_NoAutoMinimize) > 0 THEN
		i_AutoMinimize = FALSE
	ELSEIF Pos(options, c_AutoMinimize) > 0 THEN
		i_AutoMinimize = TRUE
	END IF
END IF

//------------------------------------------------------------------
//  Process the auto position option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame <> THIS THEN
	IF Pos(options, c_NoAutoPosition) > 0 THEN
		i_AutoPosition = FALSE
	ELSEIF Pos(options, c_AutoPosition) > 0 THEN
		i_AutoPosition = TRUE
	END IF
END IF

//------------------------------------------------------------------
//  Process the save position option.
//------------------------------------------------------------------

IF Pos(options, c_NoSavePosition) > 0 THEN
	i_SavePosition = FALSE
ELSEIF Pos(options, c_SavePosition) > 0 THEN
	i_SavePosition = TRUE
END IF

//------------------------------------------------------------------
//  Process the close option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame <> THIS THEN
	IF Pos(options, c_ClosePromptUser) > 0 THEN
		i_SaveOnClose = c_ClosePromptUser
	ELSEIF Pos(options, c_CloseSave) > 0 THEN
		i_SaveOnClose = c_CloseSave
	ELSEIF Pos(options, c_CloseNoSave) > 0 THEN
		i_SaveOnClose = c_CloseNoSave
	END IF
END IF

//------------------------------------------------------------------
//  Process the toolbar position option.
//------------------------------------------------------------------

IF Pos(options, c_ToolbarNone) > 0 THEN
	i_ToolbarPosition  = c_ToolbarNone
	l_ToolbarVisible   = FALSE
ELSEIF Pos(options, c_ToolbarTop) > 0 OR i_ToolbarPosition = c_ToolbarTop THEN
	i_ToolbarPosition  = c_ToolbarTop
	l_ToolbarAlignment = AlignAtTop!
	l_ToolbarVisible   = TRUE
ELSEIF Pos(options, c_ToolbarBottom) > 0 OR i_ToolbarPosition = c_ToolbarBottom THEN
	i_ToolbarPosition  = c_ToolbarBottom
	l_ToolbarAlignment = AlignAtBottom!
	l_ToolbarVisible   = TRUE
ELSEIF Pos(options, c_ToolbarLeft) > 0 OR i_ToolbarPosition = c_ToolbarLeft THEN
	i_ToolbarPosition  = c_ToolbarLeft
	l_ToolbarAlignment = AlignAtLeft!
	l_ToolbarVisible   = TRUE
ELSEIF Pos(options, c_ToolbarRight) > 0 OR i_ToolbarPosition = c_ToolbarRight THEN
	i_ToolbarPosition  = c_ToolbarRight
	l_ToolbarAlignment = AlignAtRight!
	l_ToolbarVisible   = TRUE
ELSEIF Pos(options, c_ToolbarFloat) > 0 OR i_ToolbarPosition = c_ToolbarFloat THEN
	i_ToolbarPosition  = c_ToolbarFloat
	l_ToolbarAlignment = Floating!
	l_ToolbarVisible   = TRUE
END IF

//------------------------------------------------------------------
//  Process the toolbar text option.
//------------------------------------------------------------------

IF Pos(options, c_ToolbarHideText) > 0 THEN
	i_ToolbarText = FALSE
ELSEIF Pos(options, c_ToolbarShowText) > 0 THEN
	i_ToolbarText = TRUE
END IF

//------------------------------------------------------------------
//  Process the toolbar tips option.
//------------------------------------------------------------------

IF Pos(options, c_ToolbarHideTips) > 0 THEN
	i_ToolbarTips = FALSE
ELSEIF Pos(options, c_ToolbarShowTips) > 0 THEN
	i_ToolbarTips = TRUE
END IF

//------------------------------------------------------------------
//  Process the resources option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame = THIS THEN
	IF Pos(options, c_NoShowResources) > 0 THEN
		i_ShowResources = FALSE
	ELSEIF Pos(options, c_ShowResources) > 0 THEN
		i_ShowResources = TRUE
	END IF
END IF

//------------------------------------------------------------------
//  Process the clock option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame = THIS THEN
	IF Pos(options, c_NoShowClock) > 0 THEN
		i_ShowClock = FALSE
	ELSEIF Pos(options, c_ShowClock) > 0 THEN
		i_ShowClock = TRUE
	END IF
END IF

//------------------------------------------------------------------
//  Process the auto config menus option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame = THIS THEN
	IF Pos(options, c_NoAutoConfigMenus) > 0 THEN
		i_AutoConfigMenus = FALSE
		FWCA.MGR.i_MDIAutoConfigMenus = FALSE
	ELSEIF Pos(options, c_AutoConfigMenus) > 0 THEN
		i_AutoConfigMenus = TRUE
		FWCA.MGR.i_MDIAutoConfigMenus = TRUE
		FWCA.MGR.fu_CreateManagers(FWCA.c_MenuManager)
	END IF
END IF

//------------------------------------------------------------------
//  Process the microhelp option.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame = THIS THEN
	IF Pos(options, c_ShowMicroHelp) > 0 THEN
		i_ShowMicrohelp = TRUE
		FWCA.MGR.i_ShowMicrohelp = TRUE
		IF WindowType = MDIHelp! THEN
			FWCA.MGR.fu_CreateManagers(FWCA.c_MicroHelpManager)
		END IF
	ELSEIF Pos(options, c_NoShowMicroHelp) > 0 THEN
		i_ShowMicrohelp = FALSE
      FWCA.MGR.i_ShowMicrohelp = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  Process how the PowerBuilder Toolbar will be handled.
//------------------------------------------------------------------

IF WindowType <> Response! THEN
	l_SetVisible = TRUE
	l_SetAlignment = TRUE
	IF i_WindowSheet THEN
		IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
			IF FWCA.MGR.i_WindowCurrent <> THIS THEN
				IF FWCA.MGR.i_WindowCurrent.ToolbarVisible = l_ToolbarVisible THEN
					l_SetVisible = FALSE
				END IF
				IF l_ToolbarVisible THEN
					IF FWCA.MGR.i_WindowCurrent.ToolbarAlignment = l_ToolbarAlignment THEN
						l_SetAlignment = FALSE
					END IF
				END IF
			END IF
		END IF
	END IF				

	IF l_SetVisible THEN
		IF MenuName = "" THEN
			IF i_WindowSheet THEN
				IF FWCA.MGR.i_MDIFrame.MenuName <> "" THEN
					FWCA.MGR.i_MDIFrame.ToolBarVisible = l_ToolbarVisible
				END IF
			END IF
		ELSE
			ToolBarVisible = l_ToolbarVisible
		END IF
	END IF

	IF l_SetAlignment THEN
		IF MenuName = "" THEN
			IF i_WindowSheet THEN
				IF FWCA.MGR.i_MDIFrame.MenuName <> "" THEN
					FWCA.MGR.i_MDIFrame.ToolBarAlignment = l_ToolbarAlignment
				END IF
			END IF
		ELSE
			ToolBarAlignment = l_ToolbarAlignment
		END IF
	END IF

   //---------------------------------------------------------------
   //  Process how the PowerBuilder Toolbar Text will be handled.
   //---------------------------------------------------------------

   IF FWCA.MGR.i_ApplicationObject.ToolBarText <> i_ToolBarText THEN
      FWCA.MGR.i_ApplicationObject.ToolBarText = i_ToolBarText
   END IF

   //---------------------------------------------------------------
   //  Process how the PowerBuilder Toolbar Tips will be handled.
   //---------------------------------------------------------------

   IF FWCA.MGR.i_ApplicationObject.ToolBarTips <> i_ToolBarTips THEN
      FWCA.MGR.i_ApplicationObject.ToolBarTips = i_ToolBarTips
   END IF

END IF

end subroutine

public function integer of_setresize (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetResize
//
//	Access:  public
//
//	Arguments:		
//	ab_switch   starts/stops the window resize service
//
//	Returns:  integer
//	 1 = success
//	 0 = no action necessary
//	-1 = error
//
//	Description:
//	Starts or stops the window resize service
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

integer	li_rc

// Check arguments
if IsNull (ab_switch) then
	return -1
end if

if ab_Switch then
	if IsNull(inv_resize) Or not IsValid (inv_resize) then
		inv_resize = create n_cst_resize
		inv_resize.of_SetOrigSize (this.WorkSpaceWidth(), this.WorkSpaceHeight())
		li_rc = 1
	end if
else
	if IsValid (inv_resize) then
		destroy inv_resize
		li_rc = 1
	end if
end If

return li_rc

end function

public function string fw_getkeyvalue (string table_name);//***********************************************************************************************
//
//  Function:	 fw_getkeyvalue
//  Purpose:    TO get a unique key from the Key Table
//  Parameters: Table_Name
//  Returns:    A string that is a unique key
//
//  Date     Developer    Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/06/00 C. Jackson  Original Version
//  11/10/00 C. Jackson  Correct error message was Messagebox(String(SQLCA.SQLDBCode), 
//                       SQLCA.SQLErrText) - too general.  Was displaying simply '3' in title bar 
//                       and no text in some cases.
//	 12/19/2002 K. Claver Modified to work with split-out key generation tables
//
//***********************************************************************************************

STRING  l_cCommand, l_cKeyTable, l_cTranName, ls_user
LONG	  l_nKeyValue, ll_tran_count
INT     l_nCounter
BOOLEAN l_bAutoCommit

// Get UserID
ls_User = OBJCA.WIN.fu_GetLogin(SQLCA)

//Determine which key table to use		
CHOOSE CASE table_name
	CASE "assigned_special_flags"
		l_cKeyTable = "cusfocus.special_flags_keygen"
		l_cTranName = "sflkey"
	CASE "carve_out_entries"
		l_cKeyTable = "cusfocus.carve_out_entries_keygen"
		l_cTranName = "coekey"
	CASE "case_forms"
		l_cKeyTable = "cusfocus.case_forms_keygen"
		l_cTranName = "cfrkey"
	CASE "case_log"
		l_cKeyTable = "cusfocus.case_log_keygen"
		l_cTranName = "clgkey"
	CASE "case_log_master_num"
		l_cKeyTable = "cusfocus.case_log_masternum_keygen"
		l_cTranName = "clmkey"
	CASE "case_notes"
		l_cKeyTable = "cusfocus.case_notes_keygen"
		l_cTranName = "cnokey"
	CASE "case_transfer"
		l_cKeyTable = "cusfocus.case_transfer_keygen"
		l_cTranName = "ctrkey"
	CASE "contact_notes"
		l_cKeyTable = "cusfocus.contact_notes_keygen"
		l_cTranName = "ctnkey"
	CASE "contact_person"
		l_cKeyTable = "cusfocus.contact_person_keygen"
		l_cTranName = "cprkey"
	CASE "correspondence"
		l_cKeyTable = "cusfocus.correspondence_keygen"
		l_cTranName = "crpkey"
	CASE "cross_reference"
		l_cKeyTable = "cusfocus.cross_reference_keygen"
		l_cTranName = "crrkey"
	CASE "other_source"
		l_cKeyTable = "cusfocus.other_source_keygen"
		l_cTranName = "otskey"
	CASE "reminders"
		l_cKeyTable = "cusfocus.reminders_keygen"
		l_cTranName = "remkey"
	CASE "reopen_log"
		l_cKeyTable = "cusfocus.reopen_log_keygen"
		l_cTranName = "reokey"
	CASE ELSE
		l_cKeyTable = "cusfocus.key_generator"
		l_cTranName = "kgnkey"
END CHOOSE


// RAP 12/18/2008 These lines will tell you how many transactions you have open
//l_cCommand =  "SELECT @@trancount"
////Prepare the staging area
//PREPARE SQLSA FROM :l_cCommand USING SQLCA;
//
////Describe staging into description area
//DESCRIBE SQLSA INTO SQLDA;
//
////Declare as cursor and fetch
//DECLARE gettrancount DYNAMIC CURSOR FOR SQLSA;
//OPEN DYNAMIC gettrancount USING DESCRIPTOR SQLDA;
//FETCH gettrancount USING DESCRIPTOR SQLDA;
//
//ll_tran_count = GetDynamicNumber( SQLDA, 1 )
//
////Close the cursor
//CLOSE gettrancount;


			// save the case components
			l_bAutoCommit = SQLCA.autocommit
			SQLCA.autocommit = FALSE

// RAP 12/18/2008 - Took this out, controlling it through the autocommit property, also added holdlocks
//l_cCommand = ( 'BEGIN TRANSACTION '+l_cTranName )
//EXECUTE IMMEDIATE :l_cCommand USING SQLCA;


//Update the key generator table
l_cCommand = "UPDATE "+l_cKeyTable+" WITH (HOLDLOCK) "+ &
				 " SET pk_id = pk_id + 1"+ &
				 " WHERE table_name = '"+table_name+"'"
				 
EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
				 

//Get the new key value.  Need to use dynamic sql as need to get a value back from
//  a generated query.
l_cCommand =  "SELECT pk_id"+ &
				  " FROM "+l_cKeyTable+" WITH (HOLDLOCK) "+ &
				  " WHERE table_name = '"+table_name+"'"
				  
//Prepare the staging area
PREPARE SQLSA FROM :l_cCommand USING SQLCA;

//Describe staging into description area
DESCRIBE SQLSA INTO SQLDA;

//Declare as cursor and fetch
DECLARE getKeyVal DYNAMIC CURSOR FOR SQLSA;
OPEN DYNAMIC getKeyVal USING DESCRIPTOR SQLDA;
FETCH getKeyVal USING DESCRIPTOR SQLDA;

l_nKeyValue = GetDynamicNumber( SQLDA, 1 )

//Close the cursor
CLOSE getKeyVal;
 

IF SQLCA.SQLCode <> 0 OR l_nKeyValue = 0 THEN
	 Messagebox(gs_appname, 'Unable to obtain primary key for '+table_name+' contact your System Administrator.')
	 l_cCommand = ( 'ROLLBACK TRANSACTION ')
	 EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			SQLCA.autocommit = l_bAutoCommit
	 Return String(-1)
ELSE
	// RAP - 12/18/2008 took this out, controlling it though the autocommit property
//	 l_cCommand = ( 'COMMIT TRANSACTION '+l_cTranName )
//	 EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			SQLCA.autocommit = l_bAutoCommit
	 Return String(l_nKeyValue)
END IF


end function

public subroutine fw_addwindowlist ();//***********************************************************************************************
//  PC Module     : w_Root
//  Subroutine    : fw_AddWindowList
//  Description   : Adds the window to the window list.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------------
//  10/22/98 Beth Byers  Find out if an MDI frame was already open before setting 
//                       FWCA.MGR.i_CloseToOpen when opening an MDI
//  09/26/00 C. Jackson  Add 'Out of Office' to windwo title if the user is marked as Out of Office
//  09/27/00 C. Jackson  Remove reference to active flag in out_of_office, this is no longer used.
//  
//***********************************************************************************************

STRING  l_cUserID
LONG    l_nCount
BOOLEAN l_Found = FALSE, l_MDIOpen = FALSE
INTEGER l_Idx, l_NumControls
WINDOW  l_NullMDI

//------------------------------------------------------------------
//  Check to see if an MDI Frame is already open.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIValid THEN l_MDIOpen = TRUE

//------------------------------------------------------------------
//  Check to see if this window is an MDI Frame.
//------------------------------------------------------------------

IF WindowType = MDI! OR &
   WindowType = MDIHelp! THEN
	FWCA.MGR.i_MDIValid = TRUE
	FWCA.MGR.i_MDIFrame = THIS

   //---------------------------------------------------------------
   //  Set the MDI client area variable.
   //---------------------------------------------------------------

	l_NumControls = UpperBound(FWCA.MGR.i_MDIFrame.Control[])
	FOR l_Idx = 1 TO l_NumControls
		IF FWCA.MGR.i_MDIFrame.Control[l_Idx].TypeOf() = MDIClient! THEN
			FWCA.MGR.i_MDIClient = FWCA.MGR.i_MDIFrame.Control[l_Idx]
			EXIT
		END IF
	NEXT
   
	//---------------------------------------------------------------
   //  If the title has not been changed by the developer then set
   //  it to the application name.
   //---------------------------------------------------------------

	IF Title = "MDI WINDOW" THEN
		
		// Get UserID
		l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)
		
		// Check to see if this user is marked Out of Office
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.out_of_office
		 WHERE out_user_id = :l_cUserID
		 USING SQLCA;
		 
		IF l_nCount > 0 THEN
			Title = FWCA.MGR.i_ApplicationName+' *** Out of Office'
		ELSE
			Title = FWCA.MGR.i_ApplicationName
		END IF
	END IF

	//---------------------------------------------------------------
   //  If any windows were open before the MDI, set the 
	//  i_CloseToWindow variable so that when the MDI is closed it
	//  doesn't close the windows that were opened before it.
	//
	//  Only do this for the first MDI that is opened. 
   //---------------------------------------------------------------

	IF NOT l_MDIOpen THEN
		FWCA.MGR.i_CloseToWindow = FWCA.MGR.i_NumWindows
	END IF
	
	RETURN
END IF

//------------------------------------------------------------------
//  If window is not an MDI window, check to see if the window 
//  already exists.
//------------------------------------------------------------------

FOR l_Idx = 1 TO FWCA.MGR.i_NumWindows
	IF FWCA.MGR.i_WindowList[l_Idx] = THIS THEN
		l_Found = TRUE
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  If the window was not found, add it to the list.
//------------------------------------------------------------------

IF NOT l_Found THEN
	FWCA.MGR.i_NumWindows = FWCA.MGR.i_NumWindows + 1
   FWCA.MGR.i_WindowList[FWCA.MGR.i_NumWindows] = THIS
	IF FWCA.MGR.i_MDIValid = TRUE THEN
		FWCA.MGR.i_MDIList[FWCA.MGR.i_NumWindows] = FWCA.MGR.i_MDIFrame
	ELSE
		SetNull(l_NullMDI)
		FWCA.MGR.i_MDIList[FWCA.MGR.i_NumWindows] = l_NullMDI
	END IF
END IF
	
//------------------------------------------------------------------
//  If the title has not been changed by the developer then set
//  it to the application name.
//------------------------------------------------------------------

IF Title = "MAIN WINDOW" OR Title = "RESPONSE WINDOW" THEN
	Title = FWCA.MGR.i_ApplicationName
END IF

end subroutine

public subroutine fw_setposition ();//******************************************************************
//  PC Module     : w_Root
//  Subroutine    : fw_SetPosition
//  Description   : Position and sizes the window if the developer
//                  doesn't.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/8/2001 K. Claver Added code to accomodate for information stored
//								in the registry rather than an INI file.
//  8/22/2004 K. Claver Changed Reference to Quovadx to OutlawTech
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_DevSized, l_DevMoved, l_Found
STRING  l_X, l_Y, l_Width, l_Height, l_State, l_INIFile, l_INISection
STRING  l_RegString
INTEGER l_CascadeX, l_CascadeY, l_ScreenWidth
INTEGER l_MDIWidth, l_MDIHeight, l_ScreenHeight

//------------------------------------------------------------------
//  See if the developer moved or resized the window.  If set to save
//  size and position, err on the side of the stored values.
//------------------------------------------------------------------
IF NOT i_SavePosition THEN	
	l_DevMoved = (i_WindowX <> X OR i_WindowY <> Y)
	l_DevSized = (i_WindowWidth  <> WorkSpaceWidth() OR &
					  i_WindowHeight <> WorkSpaceHeight())
END IF

l_ScreenWidth  = PixelsToUnits(OBJCA.MGR.i_Env.ScreenWidth, XPixelsToUnits!)
l_ScreenHeight = PixelsToUnits(OBJCA.MGR.i_Env.ScreenHeight, YPixelsToUnits!)

//------------------------------------------------------------------
//  If the developer did not size or position the window, then we 
//  will se if the positioning/sizing information was saved in the
//  INI file.
//------------------------------------------------------------------

IF NOT l_DevSized AND NOT l_DevMoved THEN
	
	//---------------------------------------------------------------
	//  See if the developer told us to get the size and position
	//  information from the INI file.
	//---------------------------------------------------------------
	
	IF i_SavePosition THEN
		IF OBJCA.MGR.i_Source = "F" THEN
			//------------------------------------------------------------
			//  Determine if we have a valid INI file.
			//------------------------------------------------------------
	
			IF FileExists(OBJCA.MGR.i_ProgINI) THEN
	
				l_INIFile    = OBJCA.MGR.i_ProgINI
				l_INISection = OBJCA.MGR.i_ProgName + "/" + &
									ClassName()
	
				//---------------------------------------------------------
				//  Get the window position from the INI file.
				//---------------------------------------------------------
	
				l_X      = ProfileString(l_INIFile, l_INISection, "X", "")
				l_Y      = ProfileString(l_INIFile, l_INISection, "Y", "")
				l_Width  = ProfileString(l_INIFile, l_INISection, "Width", "")
				l_Height = ProfileString(l_INIFile, l_INISection, "Height", "")
				l_State  = ProfileString(l_INIFile, l_INISection, "State", "")
			END IF
		ELSEIF OBJCA.MGR.i_Source = "R" THEN
			//Set from the registry.
			l_RegString = "HKEY_LOCAL_MACHINE\Software\OutlawTech\"+OBJCA.MGR.i_ProgName+"\"+ &
							  gs_AppFullVersion+"\Application Info\window position\"+ClassName( )
							  
			RegistryGet( l_RegString, "x", RegString!, l_X )
			RegistryGet( l_RegString, "y", RegString!, l_Y )
			RegistryGet( l_RegString, "width", RegString!, l_Width )
			RegistryGet( l_RegString, "height", RegString!, l_Height )
			RegistryGet( l_RegString, "state", RegString!, l_State )		
		END IF
		
		//Check if found some values.
		l_Found  = (l_X <> "" AND l_Y <> "" AND l_Width <> "" AND &
						l_Height <> "" AND l_State <> "")
			
		//---------------------------------------------------------
		//  If all the INI information was found, then set the 
		//  position and the window state.
		//---------------------------------------------------------

		IF l_Found THEN
			i_WindowX      = Integer(l_X)
			i_WindowY      = Integer(l_Y)
			i_WindowWidth  = Integer(l_Width)
			i_WindowHeight = Integer(l_Height)

			//------------------------------------------------------
			//  Make sure that the window is not an unreasonable 
			//  size and at least a corner of it is on the display.
			//------------------------------------------------------

			IF i_WindowWidth < 25 THEN
				i_WindowWidth = 25
			END IF

			IF i_WindowHeight < 25 THEN
				i_WindowHeight = 25
			END IF

			IF i_WindowX > l_ScreenWidth THEN
				i_WindowX = l_ScreenWidth - 25
			END IF
			IF i_WindowX + i_WindowWidth < 1 THEN
				i_WindowX = 25 - i_WindowWidth
			END IF

			IF i_WindowY > l_ScreenHeight THEN
				i_WindowY = l_ScreenHeight - 25
			END IF
			IF i_WindowY + i_WindowHeight < 1 THEN
				i_WindowY = 25 - i_WindowHeight
			END IF

			//------------------------------------------------------
			//  Set for window state.
			//------------------------------------------------------

			CHOOSE CASE l_State
				CASE "Maximized"
					i_WindowState = Maximized!
				CASE "Minimized"
					i_WindowState = Minimized!
				CASE ELSE
					i_WindowState = Normal!
			END CHOOSE

			//------------------------------------------------------
			//  Position and resize the window.
			//------------------------------------------------------

			Move(i_WindowX, i_WindowY)
			Resize(i_WindowWidth, i_WindowHeight)
			l_DevMoved = TRUE
			l_DevSized = TRUE
			
			FWCA.MGR.i_WindowLastX = i_WindowX
			FWCA.MGR.i_WindowLastY = i_WindowY
		END IF
	END IF

	//---------------------------------------------------------------
	//  See if the developer wants us to center the window.
	//---------------------------------------------------------------

	IF i_AutoPosition THEN
   	IF FWCA.MGR.i_MDIValid THEN
      	l_MDIWidth  = FWCA.MGR.i_MDIFrame.WorkSpaceWidth()
      	l_MDIHeight = FWCA.MGR.i_MDIFrame.WorkSpaceHeight()
      	i_WindowX   = (l_MDIWidth  - Width)  / 2
      	i_WindowY   = (l_MDIHeight - Height) / 2

   		IF i_WindowX < 1 THEN
      		i_WindowX = 1
   		END IF
   		IF i_WindowY < 1 THEN
   	   	i_WindowY = 1
   		END IF

   		IF i_WindowX + Width > l_ScreenWidth THEN
   		   i_WindowX = l_ScreenWidth - Width
   		END IF
   		IF i_WindowY + Height > l_ScreenHeight THEN
   		   i_WindowY = l_ScreenHeight - Height
   		END IF

   		Move(i_WindowX, i_WindowY)
   	ELSE
      	OBJCA.MGR.fu_CenterWindow(THIS)
			i_WindowX = X
			i_WindowY = Y
		END IF
      l_DevMoved = TRUE
		FWCA.MGR.i_WindowLastX = i_WindowX
		FWCA.MGR.i_WindowLastY = i_WindowY
	END IF

END IF

//------------------------------------------------------------------
//  If the window was not positioned/sized by the developer or from
//  INI file information, then do it now.
//------------------------------------------------------------------

IF NOT l_DevMoved THEN

	//---------------------------------------------------------------
	//  Determine if we should cascade the window.  It should be
	//  cascaded if:
	//     a) It is is not a response window AND
	//     b) An MDI frame exists
	//---------------------------------------------------------------

	IF FWCA.MGR.i_MDIValid THEN
		IF i_WindowSheet THEN
        	IF FWCA.MGR.i_NumWindows = FWCA.MGR.i_CloseToWindow + 1 THEN
            i_WindowX = 1
            i_WindowY = 1
         ELSE

				//---------------------------------------------------
				//  Get the title and menu heights.
				//---------------------------------------------------

				OBJCA.MGR.fu_GetCascadeSize(l_CascadeY, l_CascadeX)

            //------------------------------------------------------
            //  Use the postion of the last cascaded window to
            //  position this window.
            //------------------------------------------------------

            i_WindowX = FWCA.MGR.i_WindowLastX + l_CascadeX
            i_WindowY = FWCA.MGR.i_WindowLastY + l_CascadeY
            IF i_WindowX + Width  > FWCA.MGR.i_MDIClient.Width OR &
					i_WindowY + Height  > FWCA.MGR.i_MDIClient.Height THEN
               i_WindowX = 1
               i_WindowY = 1
            END IF
         END IF

         //---------------------------------------------------------
         //  Move to the cascaded position.
         //---------------------------------------------------------

         Move(i_WindowX, i_WindowY)
			FWCA.MGR.i_WindowLastX = i_WindowX
			FWCA.MGR.i_WindowLastY = i_WindowY
      END IF
   END IF
END IF

end subroutine

public subroutine fw_saveposition ();//******************************************************************
//  PC Module     : w_Root
//  Subroutine    : fw_SavePosition
//  Description   : Save the position and state of the window if 
//                  requested by the developer.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/8/2001 K. Claver Added code to accomodate for information stored
//								in the registry rather than an INI file.
//  8/22/2004 K. Claver Changed reference to Quovadx to OutlawTech
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_State, l_INIFile, l_INISection
STRING  l_RegString

//------------------------------------------------------------------
//  See if the developer told us to save the position and state
//  information to the INI file.
//------------------------------------------------------------------

IF i_SavePosition THEN
	//Get the window state
	CHOOSE CASE WindowState
		CASE Maximized!
			l_State = "Maximized"
		CASE Minimized!
			l_State = "Minimized"
		CASE ELSE
			l_State = "Normal"
	END CHOOSE
	
	//Check if using INI file or registry
	IF OBJCA.MGR.i_Source = "F" THEN
		//------------------------------------------------------------
		//  Determine if we have a valid INI file.
		//------------------------------------------------------------
	
		IF FileExists(OBJCA.MGR.i_ProgINI) THEN
	
			l_INIFile    = OBJCA.MGR.i_ProgINI
			l_INISection = OBJCA.MGR.i_ProgName + "/" + &
								ClassName()
	
			//---------------------------------------------------------
			//  Set the window position to the INI file.
			//---------------------------------------------------------
			
			SetProfileString(l_INIFile, l_INISection, "X", String(X))
			SetProfileString(l_INIFile, l_INISection, "Y", String(Y))
			SetProfileString(l_INIFile, l_INISection, "Width", String(Width))
			SetProfileString(l_INIFile, l_INISection, "Height", String(Height))
			SetProfileString(l_INIFile, l_INISection, "State", l_State)
	
		END IF
	ELSEIF OBJCA.MGR.i_Source = "R" THEN
		//Save into the registry.  If the registry functions can't find the current
		//  window, will create a new entry.
		l_RegString = "HKEY_LOCAL_MACHINE\Software\OutlawTech\"+OBJCA.MGR.i_ProgName+"\"+ &
						  gs_AppFullVersion+"\Application Info\window position\"+ClassName( )
						  
		RegistrySet( l_RegString, "x", RegString!, String( THIS.X ) )
		RegistrySet( l_RegString, "y", RegString!, String( THIS.Y ) )
		RegistrySet( l_RegString, "width", RegString!, String( THIS.Width ) )
		RegistrySet( l_RegString, "height", RegString!, String( THIS.Height ) )
		RegistrySet( l_RegString, "state", RegString!, l_State )
	END IF
END IF

end subroutine

on w_root.create
end on

on w_root.destroy
end on

event open;//******************************************************************
//  PC Module     : w_Root
//  Event         : Open
//  Description   : Opens the window and does window processing
//                  before the window is visible.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Defaults, l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerMark("Menu/Toolbar/Control Creation")
	END IF
END IF

//------------------------------------------------------------------
//  Initialize some window variables.
//------------------------------------------------------------------

i_WindowSheet  = OBJCA.MGR.i_Parm.Window_Sheet
i_WindowX      = X
i_WindowY      = Y
i_WindowWidth  = WorkSpaceWidth()
i_WindowHeight = WorkSpaceHeight()
i_WindowState  = WindowState
i_SaveOnClose  = c_ClosePromptUser
i_ToolbarPosition = c_ToolbarNone

//???RAP commented out for .net, uncommented for straight PB
#IF NOT defined PBDOTNET THEN
	OBJCA.MGR.fu_ResizeControls(THIS, i_ControlSizes[], TRUE)
#END IF

//------------------------------------------------------------------
//  Even if WindowState says Maximized!, the window may not have
//  been maximized yet.
//------------------------------------------------------------------

IF i_WindowState = Maximized! THEN
   i_WindowState = Normal!
END IF

//------------------------------------------------------------------
//  Register the window with the framework manager.
//------------------------------------------------------------------

fw_AddWindowList()

//------------------------------------------------------------------
//  Set the default values for the window.
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIFrame <> THIS THEN
   l_Defaults = FWCA.MGR.fu_GetDefault("Window", "General")
ELSE
   i_EnablePopup = FALSE
	l_Defaults = FWCA.MGR.fu_GetDefault("MDIFrame", "General")
END IF
IF l_Defaults <> c_Default THEN
	fw_SetOptions(l_Defaults)
END IF

//------------------------------------------------------------------
//  The pc_SetVariables event is used if data sent to the window
//  needs to be extracted from the framework manager.  The data is
//  usually loaded into local or instance variables.  This event
//  is coded by the developer.
//------------------------------------------------------------------

Event pc_SetVariables(Message.PowerObjectParm, &
                      Message.StringParm, &
                      Message.DoubleParm)

IF Error.i_FWError <> c_Success THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = ClassName()
   l_ErrorStrings[4] = ""
   l_ErrorStrings[5] = "pc_SetVariables"
   FWCA.MSG.fu_DisplayMessage("WindowOpenError", &
                               5, l_ErrorStrings[])
   GOTO Finished
END IF

//------------------------------------------------------------------
//  If security is available, apply it to the menu and controls.
//------------------------------------------------------------------

IF IsValid(SECCA.MGR) THEN
	SECCA.MGR.DYNAMIC fu_SetSecurity(THIS)
END IF

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerMark("Window Initialization")
	END IF
END IF

//------------------------------------------------------------------
//  The pc_SetOptions event is used to do any window setup
//  processing just before the window is open.  This event
//  is coded by the developer.
//------------------------------------------------------------------

TriggerEvent("pc_SetOptions")

IF Error.i_FWError <> c_Success THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = ClassName()
   l_ErrorStrings[4] = ""
   l_ErrorStrings[5] = "pc_SetOptions"
   FWCA.MSG.fu_DisplayMessage("WindowOpenError", &
                               5, l_ErrorStrings[])
   GOTO Finished
END IF

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerMark("pc_SetOptions")
	END IF
END IF

//------------------------------------------------------------------
//  The pc_SetCodeTables event is used to load any code tables 
//  located in controls on the window.  If the developer specified 
//  that code tables were to be loaded upfront then trigger this 
//  event now to do it.  This event is coded by the developer.
//------------------------------------------------------------------

IF i_LoadCodeTable AND FWCA.MGR.i_MDIFrame <> THIS THEN

	TriggerEvent("pc_SetCodeTables")

	IF Error.i_FWError <> c_Success THEN
   	l_ErrorStrings[1] = "PowerClass Error"
   	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   	l_ErrorStrings[3] = ClassName()
   	l_ErrorStrings[4] = ""
  	 	l_ErrorStrings[5] = "pc_SetCodeTables"
  	 	FWCA.MSG.fu_DisplayMessage("WindowOpenError", &
                                  5, l_ErrorStrings[])
   	GOTO Finished
	END IF


	//---------------------------------------------------------------
	//  If the timer is active, mark a time.
	//---------------------------------------------------------------

	IF IsValid(OBJCA.TIMER) THEN
		IF OBJCA.TIMER.i_TimerOn THEN
			OBJCA.TIMER.fu_TimerMark("pc_SetCodeTables")
		END IF
	END IF

END IF

//------------------------------------------------------------------
//  Position the window for the developer.  If it was done by the
//  developer then leave it alone.
//------------------------------------------------------------------

fw_SetPosition()

//------------------------------------------------------------------
//  Initialize the menu.  If this window is a sheet and no menu is
//  attached then use the MDI menu.
//------------------------------------------------------------------

fw_InitMenu()

//------------------------------------------------------------------
//  Initialize the popup menu based on the options set by the 
//  developer.  
//------------------------------------------------------------------

fw_InitPopup()

IF FWCA.MGR.i_MDIFrame = THIS THEN

	//---------------------------------------------------------------
	//  If the timer is active, mark a time.
	//---------------------------------------------------------------

	IF IsValid(OBJCA.TIMER) THEN
		IF OBJCA.TIMER.i_TimerOn THEN
			OBJCA.TIMER.fu_TimerMark("Menu/Popup/Position Initialization")
		END IF
	END IF
END IF

Finished:


end event

event rbuttondown;//******************************************************************
//  PC Module     : w_Root
//  Event         : RButtonDown
//  Description   : Display POPUP menu for the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the POPUP menu was requested, put it up if it exists.
//------------------------------------------------------------------

IF i_EnablePopup THEN

	SetFocus()

	IF IsValid(i_PopupID) THEN
      IF FWCA.MGR.i_MDIValid AND WindowType <> Response! THEN
			IF IsValid(SECCA.MGR) THEN
				SECCA.MGR.DYNAMIC fu_SetPopupSecurity(THIS, i_PopupID, &
										FWCA.MGR.i_MDIFrame.PointerX(), &
										FWCA.MGR.i_MDIFrame.PointerY())
			ELSE
				i_PopupID.PopMenu(FWCA.MGR.i_MDIFrame.PointerX(), &
                              FWCA.MGR.i_MDIFrame.PointerY())
			END IF
		ELSE
			IF IsValid(SECCA.MGR) THEN
				SECCA.MGR.DYNAMIC fu_SetPopupSecurity(THIS, i_PopupID, &
										PointerX(), PointerY())
			ELSE
				i_PopupID.PopMenu(PointerX(), PointerY())
			END IF
		END IF
   END IF

END IF

end event

event resize;//******************************************************************
//  PC Module     : w_Root
//  Event         : Resize
//  Description   : If save position is on, save the position of the
//                  window to the INI file.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the save position option is on, save the position to the
//  INI file.
//------------------------------------------------------------------

//IF i_SavePosition THEN
//	fw_SavePosition()
//END IF

//////////////////////////////////////////////////////////////////////////////
//
//	Event:  resize
//
//	Description:
//	Send resize notification to services
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//	7.0   Change to not resize when window is being restored from a minimized state
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

//// Notify the resize service that the window size has changed.
If IsValid (inv_resize) and This.windowstate <> minimized! Then
	inv_resize.Event pfc_Resize (sizetype, This.WorkSpaceWidth(), This.WorkSpaceHeight())
End If

// Store the position and size on the preference service.
// With this information the service knows the normal size of the 
// window even when the window is closed as maximized/minimized.	
//If IsValid (inv_preference) And This.windowstate = normal! Then
//	inv_preference.Post of_SetPosSize()
//End If
end event

event close;//******************************************************************
//  PC Module     : w_Root
//  Event         : Close
//  Description   : See PB documentation for this event
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//	 9/22/2000 K. Claver Added code to destroy the resize service if
//								it exists
//	 10/19/2001 K. Claver Added save code in case save position
//								 functionality is turned on.
//******************************************************************

IF i_SavePosition THEN
	fw_SavePosition()
END IF

//----------------------------------------------------------------
//  Destroy the resize service
//----------------------------------------------------------------
THIS.of_SetResize(False)
end event

event activate;integer li_int	
li_int = 1
end event

