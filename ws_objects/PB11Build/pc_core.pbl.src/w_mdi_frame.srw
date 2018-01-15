$PBExportHeader$w_mdi_frame.srw
$PBExportComments$Window ancestor for MDI windows
forward
global type w_mdi_frame from w_root
end type
type mdi_1 from mdiclient within w_mdi_frame
end type
end forward

global type w_mdi_frame from w_root
integer x = 5
integer y = 4
integer width = 4681
integer height = 3072
string title = "MDI WINDOW"
string menuname = "m_main"
windowtype windowtype = mdihelp!
windowstate windowstate = maximized!
event pc_closeall pbm_custom70
mdi_1 mdi_1
end type
global w_mdi_frame w_mdi_frame

type variables
//----------------------------------------------------------------------------------------
//  MDI Frame Constants
//----------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------
//  MDI Frame Instance Variables
//----------------------------------------------------------------------------------------

BOOLEAN	i_InMDIOpen	= TRUE
end variables

event pc_closeall;call super::pc_closeall;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : pc_CloseAll
//  Description   : Close all the open windows in the MDI Frame.
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Idx, l_NumWindows

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Display the close prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Close")
	END IF
END IF

//------------------------------------------------------------------
//  Close every open window.
//------------------------------------------------------------------

IF FWCA.MGR.i_NumWindows > FWCA.MGR.i_CloseToWindow THEN
   l_NumWindows = FWCA.MGR.i_NumWindows

	FOR l_Idx = l_NumWindows TO FWCA.MGR.i_CloseToWindow + 1 STEP -1
      IF IsValid(FWCA.MGR.i_WindowList[l_Idx]) THEN
         IF FWCA.MGR.i_MDIList[l_Idx] = THIS THEN
				Close(FWCA.MGR.i_WindowList[l_Idx])
         	IF Error.i_FWError <> c_Success THEN
            	EXIT
         	END IF
			END IF
      END IF
   NEXT
END IF

//------------------------------------------------------------------
//  Reset the microhelp prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF
end event

on w_mdi_frame.create
int iCurrent
call super::create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mdi_1
end on

on w_mdi_frame.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
end on

event activate;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : Activate
//  Description   : This event runs when all sheets have been
//                  closed.  If auto configuration for the MDI menu
//                  is on, set the standard PowerClass menu items
//                  appropriately for a MDI menu.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/22/98 Beth Byers	Count how many windows there are for this MDI.
//								FWCA.MGR.i_NumWindows counts windows for the
//								entire application, but setting toolbars and 
//								menus depends on the window count for this MDI.
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_NumFileLabels, l_NumFileItems, l_Idx, l_Jdx, l_NumControls
INTEGER l_NumEditLabels, l_NumEditItems, l_NumWindows
STRING  l_Label, l_FileLabels[], l_NextLabel, l_EditLabels[]

//------------------------------------------------------------------
//  Set the current MDI in the application manager.
//------------------------------------------------------------------

FWCA.MGR.i_MDIValid = TRUE
FWCA.MGR.i_MDIFrame = THIS

l_NumControls = UpperBound(Control[])
FOR l_Idx = 1 TO l_NumControls
	IF Control[l_Idx].TypeOf() = MDIClient! THEN
		FWCA.MGR.i_MDIClient = Control[l_Idx]
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  Find out how many windows are on this MDI
//------------------------------------------------------------------

FOR l_Idx = 1 to FWCA.MGR.i_NumWindows
	IF FWCA.MGR.i_MDIList[l_Idx] = THIS THEN
		l_NumWindows++
	END IF
NEXT


//------------------------------------------------------------------
//  Set the toolbar alignment, if neccessary.
//------------------------------------------------------------------

IF l_NumWindows = 0 THEN
	IF i_ToolbarPosition <> c_ToolbarNone THEN
		CHOOSE CASE i_ToolbarPosition
			CASE c_ToolBarTop
				ToolbarAlignment = AlignAtTop!
			CASE c_ToolBarBottom
				ToolbarAlignment = AlignAtBottom!
			CASE c_ToolBarLeft
				ToolbarAlignment = AlignAtLeft!
			CASE c_ToolBarRight
				ToolbarAlignment = AlignAtRight!
			CASE c_ToolBarFloat
				ToolbarAlignment = Floating!
		END CHOOSE
		IF NOT ToolbarVisible THEN
			ToolbarVisible = TRUE
		END IF
     	FWCA.MGR.i_ApplicationObject.ToolBarText = i_ToolbarText
      FWCA.MGR.i_ApplicationObject.ToolBarTips = i_ToolBarTips
	ELSE
		IF ToolbarVisible THEN
			ToolbarVisible = FALSE
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  See if we are to Auto-Configure the menus.
//------------------------------------------------------------------

IF i_AutoConfigMenus AND  l_NumWindows = 0 THEN
	l_NumFileLabels = FWCA.MENU.fu_GetMenuLabels("MDI Config", &
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
						i_FileMenu.Item[l_Jdx].Visible = FALSE
					ELSE
						i_FileMenu.Item[l_Jdx].Enabled = FALSE
					END IF
					EXIT
				END IF
			NEXT
		ELSE
			FOR l_Jdx = 1 TO l_NumFileItems
				IF Pos(i_FileMenu.Item[l_Jdx].Text, l_Label) = 1 THEN
					IF FWCA.MGR.i_MDIAutoConfigHide THEN
						i_FileMenu.Item[l_Jdx].Visible = FALSE
					ELSE
						i_FileMenu.Item[l_Jdx].Enabled = FALSE
					END IF
				END IF
			NEXT
		END IF
	NEXT

	IF IsValid(i_EditMenu) THEN

		//-------------------------------------------------------
		// In case the developer has given the MDI menu a toolbar,
		// disable the menu items under the EDIT and FILE menu
		// items so the toolbar items will also be disabled.
		//-------------------------------------------------------

		l_NumEditLabels = FWCA.MENU.fu_GetMenuLabels("EDIT", l_EditLabels[])
		l_NumEditItems = UpperBound(i_EditMenu.Item[])
		FOR l_Idx = 1 TO l_NumEditLabels
			FOR l_Jdx = 1 TO l_NumEditItems
				IF Pos(i_EditMenu.Item[l_Jdx].Text, l_EditLabels[l_Idx]) = 1 THEN
					i_EditMenu.Item[l_Jdx].Enabled = FALSE
				END IF
			NEXT
		NEXT

		//-------------------------------------------------------
		// Find and disable the FILE menu items that apply to only
		// windows or datawindows.
		//-------------------------------------------------------

		IF IsValid(i_FileMenu) THEN
			l_NumFileItems = UpperBound(i_FileMenu.Item[])
			FOR l_Idx = 1 TO UpperBound(l_FileLabels[])
				FOR l_Jdx = 1 TO l_NumFileItems
					IF Pos(i_FileMenu.Item[l_Jdx].Text, l_FileLabels[l_Idx]) = 1 THEN
						i_FileMenu.Item[l_Jdx].Enabled = FALSE
					END IF
				NEXT
			NEXT
		END IF
		i_EditMenu.Enabled = FALSE
	END IF

	IF i_ToolbarPosition = c_ToolbarNone AND ToolbarVisible THEN
		ToolbarVisible = FALSE
	END IF

END IF

end event

event resize;call super::resize;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : Resize
//  Description   : Handles the resize event for the MDI Frame.
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
//  Reposition the MicroHelp indicator.
//------------------------------------------------------------------

IF IsValid(OBJCA.WIN) THEN
	IF (i_ShowResources OR i_ShowClock) THEN
		OBJCA.WIN.fu_MicroHelpPosition()
	END IF
END IF

//------------------------------------------------------------------
//  If the position of the window was saved then a timming problem
//  exists if the window is not originally Normal!.  If the window
//  state that was saved is normal then we have to change to the 
//  saved state after the original maximized or minimized state is
//  set by PowerBuilder.
//------------------------------------------------------------------

IF i_SavePosition AND i_InMDIOpen THEN
	IF WindowState <> Normal! AND WindowState <> i_WindowState THEN
		WindowState = i_WindowState
	END IF
	i_InMDIOpen = FALSE
END IF

end event

event close;call super::close;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : Close
//  Description   : Cleans up and closes the window.
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
//  Save our position to the INI file, if requested by the
//  developer.
//------------------------------------------------------------------

fw_SavePosition()

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 6.17.2005
//
// Commit the user's syntax changes to the database before the application closes
//-----------------------------------------------------------------------------------------------------------------------------------
long 	ll_return
ll_return = gn_globals.ids_syntax.Update()




//------------------------------------------------------------------
//  Destroy the POPUP menu if we created it.
//------------------------------------------------------------------

IF IsValid(i_PopupID) THEN
   DESTROY i_PopupID
END IF

//------------------------------------------------------------------
//  Close the MicroHelp indicator.
//------------------------------------------------------------------

IF IsValid(OBJCA.WIN) THEN
   OBJCA.WIN.fu_MicroHelpClose()
END IF

//------------------------------------------------------------------
//  Indicate that the MDI frame is no longer there.
//------------------------------------------------------------------

fw_DeleteWindowList()

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF



end event

event closequery;call super::closequery;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : CloseQuery
//  Description   : Make sure it is OK to close.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

THIS.TriggerEvent("pc_CloseAll")

IF Error.i_FWError <> c_Success THEN
   RETURN 1
END IF
end event

event show;call super::show;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : Show
//  Description   : Set the window state and display the microhelp
//                  window if requested.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

WindowState = i_WindowState
end event

event pc_move;call super::pc_move;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : pc_Move
//  Description   : Reposition the microhelp window when the window
//                  is moved.
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
//  Reposition the MicroHelp indicator.
//------------------------------------------------------------------

IF IsValid(OBJCA.WIN) THEN
	IF (i_ShowResources OR i_ShowClock) THEN
		OBJCA.WIN.fu_MicroHelpPosition()
	END IF
END IF

end event

event open;call super::open;//******************************************************************
//  PC Module     : w_MDI_Frame
//  Event         : Open
//  Description   : Display the microhelp window if requested.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF Error.i_FWError = c_Success THEN

	//------------------------------------------------------------------
	//  Set the microhelp window if requested.
	//------------------------------------------------------------------

	IF WindowType = MDIHelp! AND &
		(i_ShowResources OR i_ShowClock) THEN
		
		IF NOT IsValid(OBJCA.WIN) THEN
			OBJCA.MGR.fu_CreateManagers(OBJCA.c_UtilityManager)
			IF NOT IsValid(OBJCA.WIN) THEN
				i_ShowResources = FALSE
				i_ShowClock = FALSE
			END IF
		END IF

		IF (i_ShowResources OR i_ShowClock) THEN
			OBJCA.WIN.fu_MicroHelp(THIS, 60, i_ShowClock, i_ShowResources)
		END IF
	END IF

END IF

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerMark("Window Open Completed")
	END IF
END IF

//------------------------------------------------------------------
//  If there was an error during initialization of this window then
//  clean up.
//------------------------------------------------------------------

IF Error.i_FWError <> c_Success THEN
	Close(THIS)
END IF
end event

type mdi_1 from mdiclient within w_mdi_frame
long BackColor=276856960
end type

