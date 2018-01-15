$PBExportHeader$u_container_main.sru
$PBExportComments$Container ancestor
forward
global type u_container_main from userobject
end type
end forward

global type u_container_main from userobject
integer width = 1998
integer height = 1180
boolean border = true
long backcolor = 80269524
long tabtextcolor = 33554432
event pc_closequery pbm_custom69
event pc_open pbm_custom71
event pc_setcodetables pbm_custom73
event pc_setoptions pbm_custom75
event po_identify pbm_custom68
event pc_close pbm_custom70
event pc_setvariables ( powerobject powerobject_parm,  string string_parm,  double numeric_parm )
event pc_move pbm_move
event resize pbm_size
end type
global u_container_main u_container_main

type variables
//-----------------------------------------------------------------------------------------
//  Window Constants
//-----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName		= "Container"

CONSTANT INTEGER	c_Fatal			= -1
CONSTANT INTEGER	c_Success		= 0
CONSTANT STRING	c_Default			= "000|"

CONSTANT STRING	c_LoadCodeTable		= "001|"
CONSTANT STRING	c_NoLoadCodeTable	= "002|"

CONSTANT STRING	c_NoResizeCont		= "003|"
CONSTANT STRING	c_ResizeCont		= "004|"
CONSTANT STRING	c_ZoomCont		= "005|"

CONSTANT STRING	c_ClosePromptUser		= "006|"
CONSTANT STRING	c_CloseSave		= "007|"
CONSTANT STRING	c_CloseNoSave		= "008|"

CONSTANT STRING	c_BringToTop		= "009|"
CONSTANT STRING	c_NoBringToTop		= "010|"

CONSTANT INTEGER	c_PromptChanges		= 1
CONSTANT INTEGER	c_IgnoreChanges		= 2
CONSTANT INTEGER	c_SaveChanges		= 3

//-----------------------------------------------------------------------------------------
//  Window Instance Variables
//-----------------------------------------------------------------------------------------

BOOLEAN		i_ResizeCont		= FALSE
BOOLEAN		i_ZoomCont		= FALSE
BOOLEAN		i_LoadCodeTable		= TRUE
BOOLEAN		i_BringToTop		= TRUE
BOOLEAN		i_DoMove		= TRUE
BOOLEAN		i_IsStatic
BOOLEAN		i_CreateOnDemand

STRING			i_SaveOnClose

INTEGER		i_NumDataWindows
DATAWINDOW		i_DataWindows[]

WINDOW		i_Window
POWEROBJECT		i_WindowParm
BOOLEAN		i_WindowSheet

INTEGER		i_ControlSizes[]

INTEGER		i_ContainerHeight
INTEGER		i_ContainerWidth
INTEGER		i_ContainerX
INTEGER		i_ContainerY

n_cst_resize inv_resize

end variables

forward prototypes
public subroutine fu_resize (real scale_area)
public subroutine fu_resize (real scale_x, real scale_y)
public subroutine fu_resize ()
public function string fu_getidentity ()
public subroutine fu_deletedatawindowlist (datawindow dw_name)
public function integer fu_saveonclose ()
public subroutine fu_setoptions (string options)
public subroutine fu_finddw (userobject uo_name, ref integer index, ref datawindow dw_list[])
public function integer fu_findrootdw ()
public function boolean fu_checkondemand ()
public function boolean fu_checkchanges ()
public function integer of_setresize (boolean ab_switch)
end prototypes

event pc_closequery;//******************************************************************
//  PC Module     : u_Container_Main
//  Event         : pc_CloseQuery
//  Description   : Checks to see if it is OK to close the
//                  container.
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
//  If this window has PowerClass DataWindows then let the
//  DataWindow hierarchy determine if it is ready to close.  A call
//  to each DataWindow is necessary just in case there is no 
//  relationship between them.  If a DataWindow gets a call and it
//  has already been processed by its parent then it will just 
//  return.
//------------------------------------------------------------------

IF i_NumDataWindows > 0 THEN
	FOR l_Idx = i_NumDataWindows TO 1 STEP -1
		i_DataWindows[l_Idx].TriggerEvent("pcd_CloseQuery")
   	IF Error.i_FWError = c_Fatal THEN
			EXIT
 		END IF
	NEXT
END IF

end event

event pc_open;//******************************************************************
//  PC Module     : u_Container_Main
//  Event         : pc_Open
//  Description   : Initializes the container.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER      l_OrigWidth, l_OrigHeight, l_NewWidth, l_NewHeight
STRING       l_ErrorStrings[]
INTEGER      l_Idx, l_NumControls, l_NumLinks, l_NumTabs, l_Jdx
INTEGER      l_LowTab, l_LowIndex
BOOLEAN      l_IgnoreUO
USEROBJECT   l_TabPage, l_UO
WINDOWOBJECT l_Control
TAB          l_Tab
DATAWINDOW   l_DW, l_ParentDW, l_LinkDW[]
WINDOW       l_Window, l_LinkWindow[]

//------------------------------------------------------------------
//  If any error happens before we get to this posted event then
//  close the container.
//------------------------------------------------------------------

IF Error.i_FWError = c_Fatal THEN
	GOTO Finished
END IF

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerMark("Container Initialization")
	END IF
END IF

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerMark("pc_SetVariables")
	END IF
END IF

//------------------------------------------------------------------
//  The pc_SetOptions event is used to do any container setup
//  processing just before the container is open.  This event
//  is coded by the developer.
//------------------------------------------------------------------

TriggerEvent("pc_SetOptions")

IF Error.i_FWError <> c_Success THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_Window.ClassName()
   l_ErrorStrings[4] = ClassName()
   l_ErrorStrings[5] = "pc_SetOptions"
   FWCA.MSG.fu_DisplayMessage("ContainerOpenError", &
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
//  located in controls on the container.  If the developer specified 
//  that code tables were to be loaded upfront then trigger this 
//  event now to do it.  This event is coded by the developer.
//------------------------------------------------------------------

IF i_LoadCodeTable THEN

	TriggerEvent("pc_SetCodeTables")

	IF Error.i_FWError <> c_Success THEN
   	l_ErrorStrings[1] = "PowerClass Error"
   	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   	l_ErrorStrings[3] = i_Window.ClassName()
   	l_ErrorStrings[4] = ClassName()
   	l_ErrorStrings[5] = "pc_SetCodeTables"
  	 	FWCA.MSG.fu_DisplayMessage("ContainerOpenError", &
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
//  If the developer wanted the container on top, do it now.
//------------------------------------------------------------------

IF i_BringToTop THEN
   BringToTop = TRUE
END IF

//------------------------------------------------------------------
//  Determine if any PowerClass DataWindows are on this window.  If
//  there are, add them to the DataWindow list in this container and
//  trigger the pcd_SetOptions and pcd_SetCodeTables events for
//  the developer.  Set the lowest tab ordered DataWindow to be
//  current.
//------------------------------------------------------------------

i_WindowSheet = i_Window.DYNAMIC fw_GetWindowSheet()

i_NumDataWindows = 0

l_LowTab   = 9999
l_LowIndex = 1
l_NumControls = UpperBound(Control[])
FOR l_Idx = 1 TO l_NumControls
	l_Control = Control[l_Idx]
	IF l_Control.TypeOf() = DataWindow! THEN
     	l_DW = Control[l_Idx]
		IF l_DW.TriggerEvent("po_Identify") = 1 THEN
			IF l_DW.DYNAMIC fu_GetIdentity() = "DataWindow" THEN
				i_NumDataWindows = i_NumDataWindows + 1
				i_DataWindows[i_NumDataWindows] = l_DW
				IF l_DW.TabOrder < l_LowTab THEN
					l_LowIndex = i_NumDataWindows
					l_LowTab   = l_DW.TabOrder
				END IF
			END IF
		END IF
	ELSEIF l_Control.TypeOf() = Tab! THEN
		l_Tab = Control[l_Idx]
		l_NumTabs = UpperBound(l_Tab.Control[])
		FOR l_Jdx = 1 TO l_NumTabs
			l_TabPage = l_Tab.Control[l_Jdx]
			fu_FindDW(l_TabPage, i_NumDataWindows, i_DataWindows[])
		NEXT
	ELSEIF l_Control.TypeOf() = UserObject! THEN
		l_UO = Control[l_Idx]
		l_IgnoreUO = FALSE
		IF l_UO.TriggerEvent("po_Identify") = 1 THEN
			IF l_UO.DYNAMIC fu_GetIdentity() = "Container" THEN
				l_IgnoreUO = TRUE
			END IF
		END IF
		IF NOT l_IgnoreUO THEN
			fu_FindDW(l_UO, i_NumDataWindows, i_DataWindows[])
		END IF
	END IF
NEXT

//------------------------------------------------------------------
//  If PowerClass DataWindows exist, initialize them.
//------------------------------------------------------------------

IF i_NumDataWindows > 0 THEN
	FOR l_Idx = 1 TO i_NumDataWindows
		IF i_DataWindows[l_Idx].DYNAMIC fu_Open() <> c_Success THEN
			Error.i_FWError = c_Fatal
			GOTO Finished
		END IF
	NEXT

	//---------------------------------------------------------------
	//  Apply security restrictions to the DataWindow rows and 
	//  columns.
	//---------------------------------------------------------------

	IF IsValid(SECCA.MGR) THEN
		SECCA.MGR.DYNAMIC fu_SetRowSecurity(THIS)
	END IF
	
	//---------------------------------------------------------------
	//  Determine if any parent/child relationships exist among
	//  the DataWindows.  If they do, determine the number of 
	//  unit-of-work hierarchies and create them or update the 
	//  DataWindow list in them.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO i_NumDataWindows
		l_ParentDW = i_DataWindows[l_Idx]
		l_NumLinks = 1
		l_LinkDW[1] = l_ParentDW
		DO
			l_Window = l_ParentDW.DYNAMIC fu_GetParentWindow()
			l_ParentDW = l_ParentDW.DYNAMIC fu_GetParentDW()
			IF IsNull(l_ParentDW) = FALSE THEN
				l_NumLinks = l_NumLinks + 1
				l_LinkDW[l_NumLinks] = l_ParentDW
				l_LinkWindow[l_NumLinks] = l_Window
			END IF
		LOOP UNTIL IsNull(l_ParentDW) <> FALSE
		
		IF l_NumLinks > 1 THEN
			IF l_LinkDW[l_NumLinks].DYNAMIC fu_AddUOW(l_NumLinks, l_LinkDW[]) <> c_Success THEN
				Error.i_FWError = c_Fatal
				GOTO Finished
			END IF

			//---------------------------------------------------------
			//  Determine if a DataWindow in the unit-of-work is on
			//  another window.  Set the first one we come to as the
			//  window parent.
			//---------------------------------------------------------

			IF i_Window.DYNAMIC fw_LinkWindow(l_NumLinks, l_LinkWindow[]) <> c_Success THEN
				Error.i_FWError = c_Fatal
				GOTO Finished
			END IF
		END IF
	NEXT

	//---------------------------------------------------------------
	//  Retrieve each root-level DataWindow in the list.  If a 
	//  DataWindow is not a root-level DataWindow then it will 
	//  just return.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO i_NumDataWindows
		IF i_DataWindows[l_Idx].DYNAMIC fu_RetrieveOnOpen() <> c_Success THEN
			Error.i_FWError = c_Fatal
			GOTO Finished
		END IF
	NEXT

	//---------------------------------------------------------------
	//  Set the lowest tab ordered DataWindow to be current.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO i_NumDataWindows
		IF l_Idx = l_LowIndex THEN
			IF l_LowTab = 10 THEN
				i_DataWindows[l_Idx].DYNAMIC fu_Activate(1)
			ELSE
				i_DataWindows[l_Idx].DYNAMIC fu_Activate(2)
			END IF
		ELSE
			i_DataWindows[l_Idx].DYNAMIC fu_Deactivate()
		END IF
	NEXT			

END IF	

//------------------------------------------------------------------
//  If the timer is active, mark a time.
//------------------------------------------------------------------

IF IsValid(OBJCA.TIMER) THEN
	IF OBJCA.TIMER.i_TimerOn THEN
		OBJCA.TIMER.fu_TimerMark("DataWindows Initialized")
	END IF
END IF

//------------------------------------------------------------------
//  If the window this container is opened on has been resized then
//  we need to resize the controls on this container as well.
//------------------------------------------------------------------

IF NOT i_IsStatic THEN
	IF i_ContainerX <> X THEN
		i_ContainerX = X
	END IF
	IF i_ContainerY <> Y THEN
		i_ContainerY = Y
	END IF

	i_Window.DYNAMIC fw_GetWindowSize(l_OrigWidth, l_OrigHeight)

   l_NewWidth  = i_Window.WorkSpaceWidth()
   l_NewHeight = i_Window.WorkSpaceHeight()

   IF l_NewWidth <> l_OrigWidth OR l_NewHeight <> l_OrigHeight THEN
      fu_Resize()
   END IF

   i_Window.SetRedraw(TRUE)
END IF

Finished:

//------------------------------------------------------------------
//  If an error occured then close the container.
//------------------------------------------------------------------

IF Error.i_FWError = c_Fatal THEN
	i_Window.CloseUserObject(THIS)
END IF

end event

event po_identify;//******************************************************************
//  PC Module     : u_Container_Main
//  Event         : po_Identify
//  Description   : Identifies this object as belonging to a 
//                  ServerLogic product.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

end event

event pc_close;//******************************************************************
//  PC Module     : u_Container_Main
//  Event         : pc_Close
//  Description   : Allows the developer do to any processing before
//                  the container is closed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  12/23/98 WBC        When a window with a container on a tab 
//								opens, if the retrieve fails and the window 
//								is closed, a null object reference occurs
//								in the closequery event of the window.
//								When a container retrieve fails, the 
//								container destroys itself. Added a call to 
//								fw_DeleteContainerList.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumDataWindows

//------------------------------------------------------------------
//  If there are PowerClass DataWindows then allow the developer 
//  to code the DataWindow close.
//------------------------------------------------------------------

IF i_NumDataWindows > 0 THEN
	l_NumDataWindows = i_NumDataWindows
	FOR l_Idx = l_NumDataWindows TO 1 STEP -1
   	i_DataWindows[l_Idx].TriggerEvent("pcd_Close")
		fu_DeleteDataWindowList(i_DataWindows[l_Idx])
	NEXT
END IF

//------------------------------------------------------------------
//  Unregister the container with the window.
//------------------------------------------------------------------

i_Window.DYNAMIC fw_DeleteContainerList(THIS)

end event

event pc_move;//******************************************************************
//  PC Module     : u_Container_Main
//  Event         : pc_Move
//  Description   : Update container variables any time it
//                  moves.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996-1997.  All Rights Reserved.
//******************************************************************

IF i_DOMove THEN
	i_ContainerX = X
	i_ContainerY = Y
END IF
end event

event resize;//////////////////////////////////////////////////////////////////////////////
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
//	5.0.02   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

// Notify the resize service that the object size has changed.
If IsValid (inv_resize) Then
	inv_resize.Event pfc_resize (sizetype, This.Width, This.Height)
End If
end event

public subroutine fu_resize (real scale_area);//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_Resize
//  Description   : Resizes the container object and the controls
//                  within.
//
//  Parameters    : REAL Scale_Area -
//                     Proportion to resize by.
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

i_DoMove = FALSE
Move(scale_area * i_ContainerX, scale_area * i_ContainerY)
i_DoMove = TRUE
Resize(scale_area * i_ContainerWidth, scale_area * i_ContainerHeight)

//------------------------------------------------------------------
//  Resize the controls within the container.
//------------------------------------------------------------------

IF i_ResizeCont THEN
  	OBJCA.MGR.fu_ResizeControls(THIS, i_ControlSizes[], i_ZoomCont)
END IF
end subroutine

public subroutine fu_resize (real scale_x, real scale_y);//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_Resize
//  Description   : Resizes the container object and the controls
//                  within.
//
//  Parameters    : REAL Scale_X -
//                     X proportion to resize by.
//                  REAL Scale_Y -
//                     Y proportion to resize by.
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

i_DoMove = FALSE
Move(scale_x * i_ContainerX, scale_y * i_ContainerY)
i_DoMove = TRUE
Resize(scale_x * i_ContainerWidth, scale_y * i_ContainerHeight)

//------------------------------------------------------------------
//  Resize the controls within the container.
//------------------------------------------------------------------

IF i_ResizeCont THEN
  	OBJCA.MGR.fu_ResizeControls(THIS, i_ControlSizes[], i_ZoomCont)
END IF
end subroutine

public subroutine fu_resize ();//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_Resize
//  Description   : Resizes the controls on the container.
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

IF i_ResizeCont THEN
  	OBJCA.MGR.fu_ResizeControls(THIS, i_ControlSizes[], i_ZoomCont)
END IF
end subroutine

public function string fu_getidentity ();//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_GetIdentity
//  Description   : Returns the identity of this object.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     Identity of this object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN c_ObjectName
end function

public subroutine fu_deletedatawindowlist (datawindow dw_name);//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_DeleteDataWindowList
//  Description   : Deletes the DataWindow from the containers list
//                  of DataWindows.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     DataWindow name to delete.
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

INTEGER l_Idx, l_Jdx

//------------------------------------------------------------------
//  Remove the DataWindow from the list.
//------------------------------------------------------------------

l_Jdx = 0
FOR l_Idx = 1 TO i_NumDataWindows
	IF i_DataWindows[l_Idx] <> dw_name THEN
		l_Jdx = l_Jdx + 1
		i_DataWindows[l_Jdx] = i_DataWindows[l_Idx]
	END IF
NEXT

i_NumDataWindows = l_Jdx

end subroutine

public function integer fu_saveonclose ();//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_SaveOnClose
//  Description   : Handle any changes based on the save-on-close
//                  option.
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

INTEGER l_Idx, l_Answer, l_NumRootDW
BOOLEAN l_Changes
STRING  l_PromptStrings[]
DATAWINDOW l_RootDW[]

//------------------------------------------------------------------
//  If the save-on-close option is set to c_CloseNoSave then just
//  ignore any changes that might exist.
//------------------------------------------------------------------

IF i_SaveOnClose = c_CloseNoSave THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  this container.
//------------------------------------------------------------------

l_Changes = fu_CheckChanges()

//------------------------------------------------------------------
//  If there are changes found, determine if we should prompt for 
//  saving changes or just save.
//------------------------------------------------------------------

IF l_Changes OR IsNull(l_Changes) <> FALSE THEN
	l_Answer = 1
	IF i_SaveOnClose = c_ClosePromptUser THEN
		l_PromptStrings[1] = "PowerClass Prompt"
		l_PromptStrings[2] = FWCA.MGR.i_ApplicationName
		l_PromptStrings[3] = i_Window.ClassName()
		l_PromptStrings[4] = ClassName()
		l_PromptStrings[5] = "fu_SaveOnClose"

		l_Answer = FWCA.MSG.fu_DisplayMessage("ChangesOnClose", &
		                                      5, l_PromptStrings[])
	END IF

	CHOOSE CASE l_Answer
		CASE 2  // No
			RETURN c_Success

		CASE 3  // Cancel
			RETURN c_Fatal
	END CHOOSE

ELSE
	RETURN c_Success
END IF

//------------------------------------------------------------
//  PowerBuilder 5.0 Bug
//  
//  This function is being called without a parameter because 
//  of a PowerBuilder bug that causes problems when you call a
//  function dynamically that returns a reference variable
//  and/or an array.  If this bug is ever fixed the following
//  function may be changed to return the l_TmpDW[] array.
//
//  Powersoft Issue Number: ?
//  Reported by           : Bill Carson
//  Report Date           : 6/30/96
//------------------------------------------------------------

//------------------------------------------------------------------
//  Determine how many root-level DataWindows that are on this 
//  container.
//------------------------------------------------------------------

//l_NumRootDW = fu_FindRootDW(l_TmpDW[])
l_NumRootDW = fu_FindRootDW()
FOR l_Idx = 1 TO l_NumRootDW
	l_RootDW[l_Idx] = FWCA.MGR.i_TmpDW[l_Idx]
NEXT

//------------------------------------------------------------------
//  For each root-level DataWindow, save the changes.  Use the 
//  fu_SaveOnClose function so that we can indicate that the
//  window is closing.  This will prevent any unnecessary refreshing
//  of parent DataWindows.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_NumRootDW
	IF l_RootDW[l_Idx].DYNAMIC fu_SaveOnClose(i_Window) <> c_Success THEN
		RETURN c_Fatal
	END IF
NEXT

RETURN c_Success
end function

public subroutine fu_setoptions (string options);//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_SetOptions
//  Description   : Sets the container options.
//
//  Parameters    : ULONG VisualWord -
//                     Specifies options for how this container is
//                     to behave.
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

//------------------------------------------------------------------
//  Process the code table option.
//------------------------------------------------------------------

IF Pos(options, c_LoadCodeTable) > 0 THEN
	i_LoadCodeTable = TRUE
ELSEIF Pos(options, c_NoLoadCodeTable) > 0 THEN
	i_LoadCodeTable = FALSE
END IF

//------------------------------------------------------------------
//  Process the resize option.
//------------------------------------------------------------------

IF Pos(options, c_NoResizeCont) > 0 THEN
	i_ResizeCont = FALSE
	i_ZoomCont   = FALSE
ELSEIF Pos(options, c_ResizeCont) > 0 THEN
	i_ResizeCont = TRUE
	i_ZoomCont   = FALSE
ELSEIF Pos(options, c_ZoomCont) > 0 THEN
	i_ResizeCont = TRUE
	i_ZoomCont   = TRUE
END IF

//------------------------------------------------------------------
//  Process the close option.
//------------------------------------------------------------------

IF Pos(options, c_ClosePromptUser) > 0 THEN
	i_SaveOnClose = c_ClosePromptUser
ELSEIF Pos(options, c_CloseSave) > 0 THEN
	i_SaveOnClose = c_CloseSave
ELSEIF Pos(options, c_CloseNoSave) > 0 THEN
	i_SaveOnClose = c_CloseNoSave
END IF

//------------------------------------------------------------------
//  Process the bring to top option.
//------------------------------------------------------------------

IF Pos(options, c_BringToTop) > 0 THEN
	i_BringToTop = TRUE
ELSEIF Pos(options, c_NoBringToTop) > 0 THEN
	i_BringToTop = FALSE
END IF
end subroutine

public subroutine fu_finddw (userobject uo_name, ref integer index, ref datawindow dw_list[]);//******************************************************************
//  PC Module     : u_container_main
//  Subroutine    : fw_FindDW
//  Description   : Recursively drills through Tab! objects and 
//                  non-PowerClass user objects looking for 
//                  datawindows to add to the container's list of
//                  datawindows.
//
//  Parameters    : USEROBJECT UO_Name -
//                     Userobject or tabpage to look through for 
//                     datawindows.
//                  INTEGER    Index -
//                     Number of datawindows found.
//                  DATAWINDOW DW_List[] -
//                     Array of datawindows on the container.
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

INTEGER      l_NumControls, l_NumTabs, l_Idx, l_Jdx
BOOLEAN      l_IgnoreUO
TAB          l_Tab
USEROBJECT   l_TabPage, l_UO
DATAWINDOW   l_DW
WINDOWOBJECT l_Control

l_NumControls = UpperBound(UO_Name.Control[])
FOR l_Idx = 1 TO l_NumControls
	l_Control = UO_Name.Control[l_Idx]
	IF l_Control.TypeOf() = DataWindow! THEN
      l_DW = UO_Name.Control[l_Idx]
		IF l_DW.TriggerEvent("po_Identify") = 1 THEN
			IF l_DW.DYNAMIC fu_GetIdentity() = "DataWindow" THEN
				Index = Index + 1
				DW_List[Index] = l_DW
			END IF
		END IF
	ELSEIF l_Control.TypeOf() = Tab! THEN
		l_Tab = UO_Name.Control[l_Idx]
		l_NumTabs = UpperBound(l_Tab.Control[])
		FOR l_Jdx = 1 TO l_NumTabs
			l_TabPage = l_Tab.Control[l_Jdx]
			fu_FindDW(l_TabPage, Index, DW_List[])
		NEXT
	ELSEIF l_Control.TypeOf() = UserObject! THEN
		l_UO = l_Control
		l_IgnoreUO = FALSE
		IF l_UO.TriggerEvent("po_Identify") = 1 THEN
			IF l_UO.DYNAMIC fu_GetIdentity() = "Container" THEN
				l_IgnoreUO = TRUE
			END IF
		END IF
		IF NOT l_IgnoreUO THEN
			fu_FindDW(l_UO, i_NumDataWindows, i_DataWindows[])
		END IF
	END IF
NEXT
end subroutine

public function integer fu_findrootdw ();//******************************************************************
//  PC Module     : u_Container_Main
//  Function      : fu_FindRootDW
//  Description   : Finds the number of unique root-level
//                  DataWindows on this container.
//
//  Parameters    : DATAWINDOW root_dw[] -
//                     Array of root-level DataWindows directly 
//                     on this container.
//                     
//  Return Value  : INTEGER -
//                     Number of unique root-level DataWindows.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_Idx, l_Jdx, l_NumRootDW
BOOLEAN    l_Found
DATAWINDOW l_TmpRootDW

//------------------------------------------------------------
//  PowerBuilder 5.0 Bug
//  
//  This function needs to pass an array of DataWindows back
//  to the calling routine through FWCA.MGR.i_TmpDW[]
//  because of problems passing a parameter by reference
//  back to a function called dynamically. If this problem is 
//  ever fixed this function can return the array as a
//  reference parameter root_dw[].
//
//  Powersoft Issue Number: ?
//  Reported by           : Bill Carson
//  Report Date           : 6/30/96
//------------------------------------------------------------

//------------------------------------------------------------------
//  Determine if there are any root-level DataWindows directly on
//  this container.  Remove any duplicates.
//------------------------------------------------------------------

l_NumRootDW = 0
IF i_NumDataWindows > 0 THEN
	FOR l_Idx = 1 TO i_NumDataWindows
		l_TmpRootDW = i_DataWindows[l_Idx].DYNAMIC fu_GetRootDW()
		l_Found = FALSE
		FOR l_Jdx = 1 TO l_NumRootDW
			IF l_TmpRootDW = FWCA.MGR.i_TmpDW[l_Jdx] THEN
				l_Found = TRUE
				EXIT
			END IF
		NEXT
		IF NOT l_Found THEN
			l_NumRootDW = l_NumRootDW + 1
			FWCA.MGR.i_TmpDW[l_NumRootDW] = l_TmpRootDW
		END IF
	NEXT
END IF

RETURN l_NumRootDW
end function

public function boolean fu_checkondemand ();//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_CheckOnDemand
//  Description   : Returns whether the container is part of
//                  a tabpage that is created on demand.
//
//  Parameters    : (None)
//
//  Return Value  : BOOLEAN -
//                     TRUE  - container is on a tabpage that is 
//                             created on demand.
//                     FALSE - container is not on a tabpage that
//                             is created on demand.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN i_CreateOnDemand
end function

public function boolean fu_checkchanges ();//******************************************************************
//  PC Module     : u_Container_Main
//  Subroutine    : fu_CheckChanges
//  Description   : Check for changes on DataWindows in this
//                  containers.
//
//  Parameters    : (None)
//
//  Return Value  : BOOLEAN -
//                     TRUE  - changes were found.
//                     FALSE - changes were not found.
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
BOOLEAN l_Changes = FALSE

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  this container.
//------------------------------------------------------------------

IF i_NumDataWindows > 0 THEN
	FOR l_Idx = 1 TO i_NumDataWindows
		l_Changes = i_DataWindows[l_Idx].DYNAMIC fu_CheckChanges()
   	IF l_Changes THEN
			EXIT
 		END IF
	NEXT
END IF

RETURN l_Changes
end function

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
		inv_resize.of_SetOrigSize (this.Width, this.Height)
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

event constructor;//******************************************************************
//  PC Module     : u_Container_Main
//  Event         : Constructor
//  Description   : Initializes container instance variables.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/8/98	Beth Byers	Initialize Error.i_FWError = c_Success
//******************************************************************
//  Copyright ServerLogic 1994-1995.  All Rights Reserved.
//******************************************************************

INTEGER     l_OrigWidth, l_OrigHeight, l_NewWidth, l_NewHeight
STRING      l_Defaults, l_ErrorStrings[]
POWEROBJECT l_Container
TAB         l_Tab

//------------------------------------------------------------------
//  Initialize Error.i_FWError
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Get the window that this container is on.
//------------------------------------------------------------------

i_CreateOnDemand = FALSE
l_Container = GetParent()
DO 
	IF l_Container.TypeOf() = Window! THEN
		EXIT
	ELSE
		IF l_Container.TypeOf() = Tab! THEN
			l_Tab = l_Container
			IF l_Tab.CreateOnDemand THEN
				i_CreateOnDemand = TRUE
			END IF
		END IF
		l_Container = l_Container.GetParent()
	END IF
LOOP UNTIL l_Container.TypeOf() = Window!

i_Window = l_Container

//------------------------------------------------------------------
//  Register the container with the window.
//------------------------------------------------------------------

i_SaveOnClose  = c_ClosePromptUser
i_IsStatic     = i_Window.DYNAMIC fw_AddContainerList(THIS)

//------------------------------------------------------------------
//  If this object is dynamically created and security is available,
//  apply it to the controls.
//------------------------------------------------------------------

IF NOT i_IsStatic THEN
	IF IsValid(SECCA.MGR) THEN
		SECCA.MGR.DYNAMIC fu_SetSecurity(THIS)
	END IF
END IF

//------------------------------------------------------------------
//  Save the original position and size.
//------------------------------------------------------------------

i_ContainerX      = X
i_ContainerY      = Y
i_ContainerWidth  = Width
i_ContainerHeight = Height

//??? RAP don't resize for .Net until I get it working correctly
//???#IF not defined PBDOTNET THEN
	OBJCA.MGR.fu_ResizeControls(THIS, i_ControlSizes[], TRUE)
//???#END IF

//------------------------------------------------------------------
//  Set Redraw off if this is a dynamic container.
//------------------------------------------------------------------

IF NOT i_IsStatic THEN
	i_Window.SetRedraw(FALSE)
END IF

////------------------------------------------------------------------
////  The pc_SetVariables event is used if data sent to the container
////  needs to be extracted from the framework manager.  The data is
////  usually loaded into local or instance variables.  This event
////  is coded by the developer.
////------------------------------------------------------------------

Event pc_SetVariables(Message.PowerObjectParm, &
                      Message.StringParm, &
                      Message.DoubleParm)

IF Error.i_FWError <> c_Success THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_Window.ClassName()
   l_ErrorStrings[4] = ClassName()
   l_ErrorStrings[5] = "pc_SetVariables"
   FWCA.MSG.fu_DisplayMessage("ContainerOpenError", &
                              5, l_ErrorStrings[])
END IF

//------------------------------------------------------------------
//  Set the default values for the Container.
//------------------------------------------------------------------

l_Defaults = FWCA.MGR.fu_GetDefault("Container", "General")
IF l_Defaults <> c_Default THEN
	fu_SetOptions(l_Defaults)
END IF

//------------------------------------------------------------------
//  If the window this container is opened on has been resized then
//  we need to resize the controls on this container as well.
//------------------------------------------------------------------

IF NOT i_IsStatic THEN
   i_Window.DYNAMIC fw_GetWindowSize(l_OrigWidth, l_OrigHeight)

//???RAP added for .Net to avoid divide by zero error
	IF l_OrigWidth = 0 THEN l_OrigWidth = 1
	IF l_OrigHeight = 0 THEN l_OrigHeight = 1
	
   l_NewWidth  = i_Window.WorkSpaceWidth()
   l_NewHeight = i_Window.WorkSpaceHeight()

   IF l_NewWidth  <> l_OrigWidth OR l_NewHeight <> l_OrigHeight THEN
      Width  = Width  * (l_NewWidth / l_OrigWidth)
      Height = Height * Int((l_NewHeight / l_OrigHeight))
   END IF
END IF

//------------------------------------------------------------------
//  Need to wait for the construction of the DataWindows.
//------------------------------------------------------------------

THIS.PostEvent("pc_Open")

end event

event rbuttondown;//******************************************************************
//  PC Module     : u_Container_Main
//  Event         : RButtonDown
//  Description   : Display POPUP menu for operating on the
//                  current window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

i_Window.TriggerEvent("RButtonDown")
end event

on u_container_main.create
end on

on u_container_main.destroy
end on

event destructor;//******************************************************************
//  PC Module     : w_Root
//  Event         : Destructor
//  Description   : See PB documentation for this event
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//	 9/22/2000 K. Claver Added code to destroy the resize service if
//								it exists
//******************************************************************

//----------------------------------------------------------------
//  Destroy the resize service
//----------------------------------------------------------------
THIS.of_SetResize(False)
end event

