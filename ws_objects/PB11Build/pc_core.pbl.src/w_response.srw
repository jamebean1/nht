$PBExportHeader$w_response.srw
$PBExportComments$Window ancestor for response style windows
forward
global type w_response from w_root
end type
end forward

global type w_response from w_root
int X=439
int Y=300
int Width=2057
int Height=1356
WindowType WindowType=response!
boolean TitleBar=true
string Title="RESPONSE WINDOW"
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
event pc_close pbm_custom52
event pc_delete pbm_custom53
event pc_filter pbm_custom54
event pc_first pbm_custom55
event pc_last pbm_custom57
event pc_modify pbm_custom58
event pc_new pbm_custom59
event pc_next pbm_custom60
event pc_previous pbm_custom61
event pc_print pbm_custom62
event pc_query pbm_custom63
event pc_retrieve pbm_custom64
event pc_save pbm_custom65
event pc_saverowsas pbm_custom66
event pc_search pbm_custom67
event pc_setcodetables pbm_custom68
event pc_sort pbm_custom69
event pc_view pbm_custom70
event pc_closequery pbm_custom51
event pc_copy pbm_custom71
end type
global w_response w_response

type variables
//-----------------------------------------------------------------------------------------
//  Response Window Constants
//-----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_PromptChanges		= 1
CONSTANT INTEGER	c_IgnoreChanges		= 2
CONSTANT INTEGER	c_SaveChanges		= 3

//-----------------------------------------------------------------------------------------
//  Response Window Instance Variables
//-----------------------------------------------------------------------------------------

INTEGER		i_NumWindowChildren
WINDOW		i_WindowChildren[]
WINDOW		i_WindowParent

INTEGER		i_NumContainers
USEROBJECT		i_Containers[]
BOOLEAN		i_ContainerStatic[]

INTEGER		i_NumDataWindows
DATAWINDOW		i_DataWindows[]

WINDOWSTATE		i_WindowPrevState
BOOLEAN		i_IgnoreWindowState
end variables

forward prototypes
public subroutine fw_deletechildrenlist (window window_name)
public subroutine fw_addchildrenlist (window window_name)
public subroutine fw_cascadestate ()
public function boolean fw_addcontainerlist (userobject container_name)
public subroutine fw_deletecontainerlist (userobject container_name)
public function integer fw_closecontainer (userobject container_name)
public function userobject fw_opencontainer (string container_name, integer container_x, integer container_y)
public function userobject fw_opencontainer (string container_name)
public function userobject fw_opencontainer (string container_name, powerobject container_parm, integer container_x, integer container_y)
public function userobject fw_opencontainer (string container_name, powerobject container_parm)
public function userobject fw_opencontainer (string container_name, string container_parm)
public function userobject fw_opencontainer (string container_name, double container_parm)
public function userobject fw_opencontainer (string container_name, string container_parm, integer container_x, integer container_y)
public function userobject fw_opencontainer (string container_name, double container_parm, integer container_x, integer container_y)
public subroutine fw_getwindowsize (ref integer orig_width, ref integer orig_height)
public subroutine fw_deletedatawindowlist (datawindow dw_name)
public function integer fw_linkwindow (integer number_links, window link_window[])
public function boolean fw_getwindowsheet ()
public function integer fw_saveonclose ()
public function boolean fw_checkchanges ()
public subroutine fw_setoptions (window window_name, string options)
public subroutine fw_finddw (userobject uo_name, ref integer index, ref datawindow dw_list[])
public function integer fw_findrootdw ()
public subroutine fw_setnosaveonclose ()
end prototypes

event pc_delete;call super::pc_delete;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Delete
//  Description   : Delete the selected rows.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Delete")
END IF

end event

event pc_filter;call super::pc_filter;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Filter
//  Description   : Apply a filter to the DataWindow that was
//                  built using filter object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Filter")
END IF

end event

event pc_first;call super::pc_first;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_First
//  Description   : Scroll to the first record.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_First")
END IF

end event

event pc_last;call super::pc_last;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Last
//  Description   : Scroll to the last row.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Last")
END IF

end event

event pc_modify;call super::pc_modify;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Modify
//  Description   : Put the DataWindow into modify mode.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Modify")
END IF

end event

event pc_new;call super::pc_new;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_New
//  Description   : Add a new record to the end of the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
	FWCA.MGR.i_WindowCurrentDW.DYNAMIC Event pcd_New(wparam, 0)
END IF

end event

event pc_next;call super::pc_next;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Next
//  Description   : Scroll to the next record.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Next")
END IF

end event

event pc_previous;call super::pc_previous;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Previous
//  Description   : Scroll to the previous record.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Previous")
END IF

end event

event pc_print;call super::pc_print;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Print
//  Description   : Print the contents of the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Print")
END IF

end event

event pc_query;call super::pc_query;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Query
//  Description   : Puts the DataWindow into query mode.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Query")
END IF

end event

event pc_retrieve;call super::pc_retrieve;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Retrieve
//  Description   : Retrieve data from the database for the
//                  current DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
    FWCA.MGR.i_WindowCurrentDW.DYNAMIC fu_Retrieve(1, 2)
END IF

end event

event pc_save;call super::pc_save;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Save
//  Description   : Saves the contents of the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Save")
END IF

end event

event pc_saverowsas;call super::pc_saverowsas;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_SaveRowsAs
//  Description   : Saves the contents of the DataWindow to a file.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_SaveRowsAs")
END IF

end event

event pc_search;call super::pc_search;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Search
//  Description   : Apply a search to the DataWindow that was
//                  built using search object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Search")
END IF

end event

event pc_sort;call super::pc_sort;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Sort
//  Description   : Sort the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Sort")
END IF

end event

event pc_view;call super::pc_view;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_View
//  Description   : Put the DataWindow into read-only mode.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_View")
END IF

end event

event pc_copy;call super::pc_copy;//******************************************************************
//  PC Module     : w_Response
//  Event         : pc_Copy
//  Description   : Copy the selected rows.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent("pcd_Copy")
END IF

end event

public subroutine fw_deletechildrenlist (window window_name);//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_DeleteChildrenList
//  Description   : Deletes the window from its parent's list
//                  of child windows.
//
//  Parameters    : WINDOW Window_Name -
//                     Window to delete from the parent's list.
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
//  Remove the window from the list.
//------------------------------------------------------------------

l_Jdx = 0
FOR l_Idx = 1 TO i_NumWindowChildren
	IF i_WindowChildren[l_Idx] <> window_name THEN
		l_Jdx = l_Jdx + 1
		i_WindowChildren[l_Jdx] = i_WindowChildren[l_Idx]
	END IF
NEXT

i_NumWindowChildren = l_Jdx

end subroutine

public subroutine fw_addchildrenlist (window window_name);//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_AddChildrenList
//  Description   : Adds the window to its parent's list
//                  of child windows.
//
//  Parameters    : WINDOW Window_Name -
//                     Window to add to the parent's list.
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

INTEGER l_Idx
BOOLEAN l_Found = FALSE

//------------------------------------------------------------------
//  Add the window to the list.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumWindowChildren
	IF i_WindowChildren[l_Idx] = window_name THEN
		l_Found = TRUE
		EXIT
	END IF
NEXT

IF NOT l_Found THEN
	i_NumWindowChildren = i_NumWindowChildren + 1
	i_WindowChildren[i_NumWindowChildren] = window_name
END IF

end subroutine

public subroutine fw_cascadestate ();//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_CascadeState
//  Description   : Cascades the state of this window to its
//                  children windows.
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

INTEGER l_Idx

//------------------------------------------------------------------
//  Cascade the window state to this windows children.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumWindowChildren
	i_WindowChildren[l_Idx].DYNAMIC fw_CascadeState()
NEXT

//------------------------------------------------------------------
//  Set this windows state.
//------------------------------------------------------------------

i_IgnoreWindowState = TRUE
IF i_WindowState <> Minimized! THEN
	WindowState = Minimized!
ELSE
	WindowState = i_WindowPrevState
END IF
i_WindowState = WindowState
i_IgnoreWindowState = FALSE
	
end subroutine

public function boolean fw_addcontainerlist (userobject container_name);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_AddContainerList
//  Description   : Adds the container to the windows container
//                  list.
//
//  Parameters    : USEROBJECT Container_Name -
//                     The name of the container to register.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - container is statically created.
//                     FALSE - container is dynamically created.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_Found = FALSE, l_CreateOnDemand
INTEGER l_Idx

//------------------------------------------------------------------
//  Check to see if the container already exists.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumContainers
	IF i_Containers[l_Idx] = container_name THEN
		l_Found = TRUE
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  If the container was not found, add it to the list.
//------------------------------------------------------------------

IF NOT l_Found THEN
	i_NumContainers = i_NumContainers + 1
   i_Containers[i_NumContainers] = container_name

	//---------------------------------------------------------------
	//  Determine if the container is static or dynamic.
	//---------------------------------------------------------------

	l_CreateOnDemand = container_name.DYNAMIC fu_CheckOnDemand()

	IF (i_WindowWidth = 0 AND i_WindowHeight = 0) OR l_CreateOnDemand THEN
   	i_ContainerStatic[i_NumContainers] = TRUE
		RETURN TRUE
	ELSE
		i_ContainerStatic[i_NumContainers] = FALSE
   	RETURN FALSE
	END IF

END IF

RETURN FALSE
end function

public subroutine fw_deletecontainerlist (userobject container_name);//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_DeleteContainerList
//  Description   : Deletes the container from the windows list
//                  of containers.
//
//  Parameters    : USEROBJECT Container_Name -
//                     Container name to delete.
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
//  Remove the container from the list.
//------------------------------------------------------------------

l_Jdx = 0
FOR l_Idx = 1 TO i_NumContainers
	IF i_Containers[l_Idx] <> container_name THEN
		l_Jdx = l_Jdx + 1
		i_Containers[l_Jdx] = i_Containers[l_Idx]
		i_ContainerStatic[l_Jdx] = i_ContainerStatic[l_Idx]
	END IF
NEXT

i_NumContainers = l_Jdx

end subroutine

public function integer fw_closecontainer (userobject container_name);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_CloseContainer
//  Description   : Closes a container and removes it from the
//                  windows list.
//
//  Parameters    : USEROBJECT Container_Name -
//                     The name of the container to close.
//
//  Return Value  : INTEGER -
//                      0 - container close successfully.
//                     -1 - container close failed.
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
//  Check to see if any changes exist in the DataWindows on the 
//  containers.  If changes exist, handle them according to the 
//  save-on-close option for the container.
//------------------------------------------------------------------

IF container_name.DYNAMIC fu_SaveOnClose() <> c_Success THEN
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Attempt to close the container.
//------------------------------------------------------------------

container_name.TriggerEvent("pc_CloseQuery")
IF Error.i_FWError = c_Fatal THEN
   RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  IF the container is not static then close it.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumContainers
	IF i_Containers[l_Idx] = container_name THEN
		i_Containers[l_Idx].TriggerEvent("pc_Close")
		IF NOT i_ContainerStatic[l_Idx] THEN
			CloseUserObject(i_Containers[l_Idx])
		END IF
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  Remove the container from the windows list.
//------------------------------------------------------------------

fw_DeleteContainerList(container_name)

RETURN c_Success
end function

public function userobject fw_opencontainer (string container_name, integer container_x, integer container_y);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING  Container_Name -
//                     The name of the container to open.
//                  INTEGER Container_X -
//                     X position on the window to create the 
//                     container.
//                  INTEGER Container_Y -
//                     Y position on the window to create the 
//                     container.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_X, l_Y, l_Return
BOOLEAN    l_DoMove
USEROBJECT l_UserObject

//------------------------------------------------------------------
//  Determine the position the container should be opened in.
//------------------------------------------------------------------

IF container_x = 0 AND container_y = 0 THEN
	l_DoMove = TRUE
	l_X = 1
	l_Y = 1
ELSE
	l_X = container_x
	l_Y = container_y
END IF

//------------------------------------------------------------------
//  Attempt to open the container.
//------------------------------------------------------------------

IF IsNull(OBJCA.MGR.i_Parm.PowerObject_Parm) = FALSE THEN
	l_Return = OpenUserObjectWithParm(l_UserObject, &
                             OBJCA.MGR.i_Parm.PowerObject_Parm, &
                             container_name, l_X, l_Y)

	SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)

ELSEIF IsNull(OBJCA.MGR.i_Parm.String_Parm) = FALSE THEN
	l_Return = OpenUserObjectWithParm(l_UserObject, &
                             OBJCA.MGR.i_Parm.String_Parm, &
                             container_name, l_X, l_Y)
	SetNull(OBJCA.MGR.i_Parm.String_Parm)

ELSEIF IsNull(OBJCA.MGR.i_Parm.Double_Parm) = FALSE THEN
	l_Return = OpenUserObjectWithParm(l_UserObject, &
                             OBJCA.MGR.i_Parm.Double_Parm, &
                             container_name, l_X, l_Y)
	SetNull(OBJCA.MGR.i_Parm.Double_Parm)

ELSE
	l_Return = OpenUserObject(l_UserObject, container_name, l_X, l_Y)

END IF

//------------------------------------------------------------------
//  Center the container if no X,Y position is given.
//------------------------------------------------------------------

IF l_Return <> -1 THEN
	IF l_DoMove THEN
		l_X = (WorkSpaceWidth() - l_UserObject.Width) / 2
		l_Y = (WorkSpaceHeight() - l_UserObject.Height) / 2
		l_UserObject.Move(l_X, l_Y)
	END IF
ELSE
   SetNull(l_UserObject)
END IF

RETURN l_UserObject
end function

public function userobject fw_opencontainer (string container_name);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING  Container_Name -
//                     The name of the container to open.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
// Set to null certain elements in OBJCA.MGR.i_Parm[]
//------------------------------------------------------------------
SetNull(OBJCA.MGR.i_Parm.Double_Parm)
SetNull(OBJCA.MGR.i_Parm.String_Parm)
SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)

RETURN fw_OpenContainer(container_name, 0, 0)
end function

public function userobject fw_opencontainer (string container_name, powerobject container_parm, integer container_x, integer container_y);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING      Container_Name -
//                     The name of the container to open.
//                  POWEROBJECT Container_Parm -
//                     Parameter to pass into the container.
//                  INTEGER     Container_X -
//                     X position on the window to create the 
//                     container.
//                  INTEGER     Container_Y -
//                     Y position on the window to create the 
//                     container.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
// Set to null certain elements in OBJCA.MGR.i_Parm[]
//------------------------------------------------------------------
SetNull(OBJCA.MGR.i_Parm.Double_Parm)
SetNull(OBJCA.MGR.i_Parm.String_Parm)

OBJCA.MGR.i_Parm.PowerObject_Parm = container_parm

RETURN fw_OpenContainer(container_name, container_x, container_y)

end function

public function userobject fw_opencontainer (string container_name, powerobject container_parm);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING      Container_Name -
//                     The name of the container to open.
//                  POWEROBJECT Container_Parm -
//                     Parameter to pass into the container.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN fw_OpenContainer(container_name, container_parm, 0, 0)
end function

public function userobject fw_opencontainer (string container_name, string container_parm);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING      Container_Name -
//                     The name of the container to open.
//                  STRING      Container_Parm -
//                     Parameter to pass into the container.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
// Set to null certain elements in OBJCA.MGR.i_Parm[]
//------------------------------------------------------------------
SetNull(OBJCA.MGR.i_Parm.Double_Parm)
SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)

OBJCA.MGR.i_Parm.String_Parm = container_parm

RETURN fw_OpenContainer(container_name, 0, 0)

end function

public function userobject fw_opencontainer (string container_name, double container_parm);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING      Container_Name -
//                     The name of the container to open.
//                  DOUBLE      Container_Parm -
//                     Parameter to pass into the container.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
// Set to null certain elements in OBJCA.MGR.i_Parm[]
//------------------------------------------------------------------
SetNull(OBJCA.MGR.i_Parm.String_Parm)
SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)

OBJCA.MGR.i_Parm.Double_Parm = container_parm

RETURN fw_OpenContainer(container_name, 0, 0)

end function

public function userobject fw_opencontainer (string container_name, string container_parm, integer container_x, integer container_y);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING      Container_Name -
//                     The name of the container to open.
//                  STRING Container_Parm -
//                     Parameter to pass into the container.
//                  INTEGER     Container_X -
//                     X position on the window to create the 
//                     container.
//                  INTEGER     Container_Y -
//                     Y position on the window to create the 
//                     container.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
// Set to null certain elements in OBJCA.MGR.i_Parm[]
//------------------------------------------------------------------
SetNull(OBJCA.MGR.i_Parm.Double_Parm)
SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)

OBJCA.MGR.i_Parm.String_Parm = container_parm

RETURN fw_OpenContainer(container_name, container_x, container_y)

end function

public function userobject fw_opencontainer (string container_name, double container_parm, integer container_x, integer container_y);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_OpenContainer
//  Description   : Opens a container.
//
//  Parameters    : STRING      Container_Name -
//                     The name of the container to open.
//                  DOUBLE      Container_Parm -
//                     Parameter to pass into the container.
//                  INTEGER     Container_X -
//                     X position on the window to create the 
//                     container.
//                  INTEGER     Container_Y -
//                     Y position on the window to create the 
//                     container.
//
//  Return Value  : USEROBJECT -
//                     The name of the user object.  Should be
//                     stored in a variable of type 
//                     "CONTAINER_NAME".
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
// Set to null certain elements in OBJCA.MGR.i_Parm[]
//------------------------------------------------------------------
SetNull(OBJCA.MGR.i_Parm.String_Parm)
SetNull(OBJCA.MGR.i_Parm.PowerObject_Parm)

OBJCA.MGR.i_Parm.Double_Parm = container_parm

RETURN fw_OpenContainer(container_name, container_x, container_y)

end function

public subroutine fw_getwindowsize (ref integer orig_width, ref integer orig_height);//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_GetWindowSize
//  Description   : Returns the original window width and height.
//
//  Parameters    : INTEGER Orig_Width -
//                     Original width of the window.
//                  INTEGER Orig_Height -
//                     Original height of the window.
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

orig_width  = Abs(i_ControlSizes[1])
orig_height = Abs(i_ControlSizes[2])

end subroutine

public subroutine fw_deletedatawindowlist (datawindow dw_name);//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_DeleteDataWindowList
//  Description   : Deletes the DataWindow from the windows list
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

public function integer fw_linkwindow (integer number_links, window link_window[]);//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_LinkWindow
//  Description   : Determines if part of the DataWindow link
//                  extends to another window.
//
//  Parameters    : INTEGER Number_Links -
//                     The number of DataWindow links.
//                  WINDOW  Link_Window[] -
//                     The windows involved in the link.
//
//  Return Value  : INTEGER -
//                      0 - parent window link successful.
//                     -1 - parent window link failed.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

WINDOW  l_WindowParent, l_this
STRING  l_ErrorStrings[]
INTEGER l_Idx

l_WindowParent = THIS
FOR l_Idx = 2 TO number_links
	IF link_window[l_Idx] <> THIS THEN
		l_WindowParent = link_window[l_Idx]
		EXIT
	END IF
NEXT

IF l_WindowParent <> THIS THEN
	IF IsValid(i_WindowParent) THEN
		IF i_WindowParent <> l_WindowParent THEN
   		l_ErrorStrings[1] = "PowerClass Error"
   		l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   		l_ErrorStrings[3] = i_WindowParent.ClassName()
   		l_ErrorStrings[4] = ""
   		l_ErrorStrings[5] = "fw_LinkWindow"
			FWCA.MSG.fu_DisplayMessage("SameParentWindow", &
		                              5, l_ErrorStrings[])
			RETURN c_Fatal
		END IF
	END IF

	i_WindowParent = l_WindowParent

	//---------------------------------------------------
	//  Add this window to its parent's list of children 
	//  windows.  If it has already been added then this
	//  function will ignore it.
	//---------------------------------------------------

	l_this = THIS
	i_WindowParent.DYNAMIC fw_AddChildrenList(l_this)
END IF

RETURN c_Success

end function

public function boolean fw_getwindowsheet ();//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_GetWindowSheet
//  Description   : Returns whether this window is an MDI sheet.
//
//  Parameters    : (None)
//
//  Return Value  : BOOLEAN -
//                     TRUE  - window is a sheet.
//                     FALSE - window is not a sheet.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

RETURN i_WindowSheet
end function

public function integer fw_saveonclose ();//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_SaveOnClose
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

INTEGER l_Idx, l_Answer, l_NumRootDW, l_NumTmpDW, l_Jdx, l_Kdx
BOOLEAN l_Changes, l_Found
STRING  l_PromptStrings[]
DATAWINDOW l_RootDW[], l_TmpDW[]
WINDOW l_this

//------------------------------------------------------------------
//  If the save-on-close option is set to c_CloseNoSave then just
//  ignore any changes that might exist.
//------------------------------------------------------------------

IF i_SaveOnClose = c_CloseNoSave THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  this window.
//------------------------------------------------------------------

l_Changes = fw_CheckChanges()

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  any of the child windows.
//------------------------------------------------------------------

IF NOT l_Changes THEN
	IF i_NumWindowChildren > 0 THEN
		FOR l_Idx = 1 TO i_NumWindowChildren
			l_Changes = i_WindowChildren[l_Idx].DYNAMIC fw_CheckChanges()
  			IF l_Changes THEN
				EXIT
			END IF
		NEXT
	END IF
END IF

//------------------------------------------------------------------
//  If there are changes found, determine if we should prompt for 
//  saving changes or just save.
//------------------------------------------------------------------

IF l_Changes OR IsNull(l_Changes) <> FALSE THEN
	l_Answer = 1
	IF i_SaveOnClose = c_ClosePromptUser THEN
		l_PromptStrings[1] = "PowerClass Prompt"
		l_PromptStrings[2] = FWCA.MGR.i_ApplicationName
		l_PromptStrings[3] = ClassName()
		l_PromptStrings[4] = ""
		l_PromptStrings[5] = "fw_SaveOnClose"

		l_Answer = FWCA.MSG.fu_DisplayMessage("ChangesOnClose", &
		                                      5, l_PromptStrings[])
	END IF

	CHOOSE CASE l_Answer
		CASE 2  // No
			IF i_NumWindowChildren > 0 THEN
				FOR l_Idx = 1 TO i_NumWindowChildren
					i_WindowChildren[l_Idx].DYNAMIC fw_SetNoSaveOnClose()
				NEXT
			END IF
			RETURN c_Success

		CASE 3  // Cancel
			RETURN c_Fatal
	END CHOOSE

ELSE
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Determine how many root-level DataWindows that are on this 
//  window.
//------------------------------------------------------------------

l_NumRootDW = fw_FindRootDW()
FOR l_Idx = 1 TO l_NumRootDW
	l_RootDW[l_Idx] = FWCA.MGR.i_TmpDW[l_Idx]
NEXT

//------------------------------------------------------------------
//  Determine how many root-level DataWindows that are on the child
//  windows.  After each call to a child window, make sure the root
//  DataWindows are not already in l_RootDW[].
//------------------------------------------------------------------

IF i_NumWindowChildren > 0 THEN
	FOR l_Idx = 1 TO i_NumWindowChildren

      //------------------------------------------------------------
      //  PowerBuilder 5.0 Bug
		//  
		//  This function is being called statically because of a 
      //  PowerBuilder bug that causes problems when you call a
      //  function dynamically that returns a reference variable
		//  and/or an array.  If this problem is ever fixed this 
		//  function can become dynamic and l_TmpDW[] may be used
		//  as a parameter.
      //
      //  Powersoft Issue Number: ?
      //  Reported by           : Bill Carson
      //  Report Date           : 6/30/96
      //------------------------------------------------------------

//		l_NumTmpDW = i_WindowChildren[l_Idx].DYNAMIC fw_FindRootDW(l_TmpDW[])

		l_NumTmpDW = i_WindowChildren[l_Idx].DYNAMIC fw_FindRootDW()
	
		FOR l_Jdx = 1 TO l_NumTmpDW
			l_TmpDW[l_Jdx] = FWCA.MGR.i_TmpDW[l_Jdx]
			l_Found = FALSE
			FOR l_Kdx = 1 TO l_NumRootDW
				IF l_TmpDW[l_Jdx] = l_RootDW[l_Kdx] THEN
					l_Found = TRUE
					EXIT
				END IF
			NEXT
			IF NOT l_Found THEN
				l_NumRootDW = l_NumRootDW + 1
				l_RootDW[l_NumRootDW] = l_TmpDW[l_Jdx]
			END IF
		NEXT
	NEXT
END IF

//------------------------------------------------------------------
//  For each root-level DataWindow, save the changes.  Use the 
//  fu_SaveOnClose function so that we can indicate that the
//  window is closing.  This will prevent any unnecessary refreshing
//  of parent DataWindows.
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_NumRootDW
	l_this = THIS
	IF l_RootDW[l_Idx].DYNAMIC fu_SaveOnClose(l_this) = c_Fatal THEN
		RETURN c_Fatal
	END IF
NEXT

RETURN c_Success
end function

public function boolean fw_checkchanges ();//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_CheckChanges
//  Description   : Check for changes on DataWindows in containers
//                  or directly on this window.
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
BOOLEAN l_Changes

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  any of the containers on this window.
//------------------------------------------------------------------

IF i_NumContainers > 0 THEN
	FOR l_Idx = 1 TO i_NumContainers
		l_Changes = i_Containers[l_Idx].DYNAMIC fu_CheckChanges()
   	IF l_Changes THEN
			EXIT
 		END IF
	NEXT
END IF

//------------------------------------------------------------------
//  Determine if there are any changes on any of the DataWindows in
//  this window.
//------------------------------------------------------------------

IF NOT l_Changes AND i_NumDataWindows > 0 THEN
	FOR l_Idx = 1 TO i_NumDataWindows
		l_Changes = i_DataWindows[l_Idx].DYNAMIC fu_CheckChanges()
   	IF l_Changes THEN
			EXIT
 		END IF
	NEXT
END IF

RETURN l_Changes
end function

public subroutine fw_setoptions (window window_name, string options);//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_SetOptions
//  Description   : Sets the window options.
//
//  Parameters    : WINDOW Window_Name -
//                     The window name for this windows parent.
//                  STRING Options -
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
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

WINDOW l_this
i_WindowParent = window_name

//------------------------------------------------------------------
//  Add this window to its parent's list of children windows.
//------------------------------------------------------------------

l_this = THIS
i_WindowParent.DYNAMIC fw_AddChildrenList(l_this)

//------------------------------------------------------------------
//  Set the window options.
//------------------------------------------------------------------

fw_SetOptions(options)
end subroutine

public subroutine fw_finddw (userobject uo_name, ref integer index, ref datawindow dw_list[]);//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_FindDW
//  Description   : Recursively drills through Tab! objects and 
//                  non-PowerClass user objects looking for 
//                  datawindows to add to the window's list of
//                  datawindows.
//
//  Parameters    : USEROBJECT UO_Name -
//                     Userobject or tabpage to look through for 
//                     datawindows.
//                  INTEGER    Index -
//                     Number of datawindows found.
//                  DATAWINDOW DW_List[] -
//                     Array of datawindows on the window.
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
			fw_FindDW(l_TabPage, Index, DW_List[])
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
			fw_FindDW(l_UO, i_NumDataWindows, i_DataWindows[])
		END IF
	END IF
NEXT
end subroutine

public function integer fw_findrootdw ();//******************************************************************
//  PC Module     : w_Response
//  Function      : fw_FindRootDW
//  Description   : Finds the number of unique root-level
//                  DataWindows on the window and in the
//                  containers.
//
//  Parameters    : DATAWINDOW root_dw[] -
//                     Array of root-level DataWindows directly 
//                     on this window or on containers.
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

INTEGER    l_Idx, l_Jdx, l_Kdx, l_NumTmpDW, l_NumRootDW
BOOLEAN    l_Found
DATAWINDOW l_TmpDW[], l_TmpRootDW, l_RootDW[]

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
//  Determine if there are any root-level DataWindows in any of the
//  containers on this window.
//------------------------------------------------------------------

l_NumRootDW = 0
IF i_NumContainers > 0 THEN
	FOR l_Idx = 1 TO i_NumContainers
		l_NumTmpDW = i_Containers[l_Idx].DYNAMIC fu_FindRootDW()
		FOR l_Jdx = 1 TO l_NumTmpDW
			l_TmpDW[l_Jdx] = FWCA.MGR.i_TmpDW[l_Jdx]
		NEXT
		FOR l_Jdx = 1 TO l_NumTmpDW
			l_Found = FALSE
			FOR l_Kdx = 1 TO l_NumRootDW
				IF l_TmpDW[l_Jdx] = l_RootDW[l_Kdx] THEN
					l_Found = TRUE
					EXIT
				END IF
			NEXT
			IF NOT l_Found THEN
				l_NumRootDW = l_NumRootDW + 1
				l_RootDW[l_NumRootDW] = l_TmpDW[l_Jdx]
			END IF
		NEXT
	NEXT
END IF

//------------------------------------------------------------------
//  Determine if there are any root-level DataWindows directly on
//  this window.
//------------------------------------------------------------------

IF i_NumDataWindows > 0 THEN
	FOR l_Idx = 1 TO i_NumDataWindows
		l_TmpRootDW = i_DataWindows[l_Idx].DYNAMIC fu_GetRootDW()
		l_Found = FALSE
		FOR l_Jdx = 1 TO l_NumRootDW
			IF l_TmpRootDW = l_RootDW[l_Jdx] THEN
				l_Found = TRUE
				EXIT
			END IF
		NEXT
		IF NOT l_Found THEN
			l_NumRootDW = l_NumRootDW + 1
			l_RootDW[l_NumRootDW] = l_TmpRootDW
		END IF
	NEXT
END IF

FOR l_Idx = 1 TO l_NumRootDW
	FWCA.MGR.i_TmpDW[l_Idx] = l_RootDW[l_Idx]
NEXT

RETURN l_NumRootDW
end function

public subroutine fw_setnosaveonclose ();//******************************************************************
//  PC Module     : w_Response
//  Subroutine    : fw_SetNoSaveOnClose
//  Description   : Set the children windows to not save on close.
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

INTEGER l_Idx

i_SaveOnClose = c_CloseNoSave

IF i_NumWindowChildren > 0 THEN
	FOR l_Idx = 1 TO i_NumWindowChildren
		i_WindowChildren[l_Idx].DYNAMIC fw_SetNoSaveOnClose()
	NEXT
END IF

end subroutine

on w_response.create
call w_root::create
end on

on w_response.destroy
call w_root::destroy
end on

event show;call super::show;//******************************************************************
//  PC Module     : w_Response
//  Event         : Show
//  Description   : Set the window state.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

WindowState       = i_WindowState
i_WindowPrevState = i_WindowState

end event

event close;call super::close;//******************************************************************
//  PC Module     : w_Response
//  Event         : Close
//  Description   : Closes the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

WINDOW l_this
INTEGER l_Idx, l_NumContainers, l_NumDataWindows

//------------------------------------------------------------------
//  Save our position to the INI file, if requested by the
//  developer.
//------------------------------------------------------------------

fw_SavePosition()

//------------------------------------------------------------------
//  Just to be safe, make sure the containers go away.
//------------------------------------------------------------------

l_NumContainers = i_NumContainers
FOR l_Idx = l_NumContainers TO 1 STEP -1
   i_Containers[l_Idx].TriggerEvent("pc_Close")
	IF NOT i_ContainerStatic[l_Idx] THEN
		IF IsValid(i_Containers[l_Idx]) THEN CloseUserObject(i_Containers[l_Idx])
	END IF
	fw_DeleteContainerList(i_Containers[l_Idx])
NEXT

//------------------------------------------------------------------
//  Allow the developer to code the DataWindow close.
//------------------------------------------------------------------

l_NumDataWindows = i_NumDataWindows
FOR l_Idx = l_NumDataWindows TO 1 STEP -1
   i_DataWindows[l_Idx].TriggerEvent("pcd_Close")
	fw_DeleteDataWindowList(i_DataWindows[l_Idx])
NEXT

//------------------------------------------------------------------
//  Allow the developer to code the window close.
//------------------------------------------------------------------

THIS.TriggerEvent("pc_Close")

//------------------------------------------------------------------
//  Destroy the POPUP menu if we created it.
//------------------------------------------------------------------

IF IsValid(i_PopupID) THEN
   DESTROY i_PopupID
END IF

//------------------------------------------------------------------
//  Remove this window from its parent's list of windows.  Reset the
//  window parent variable.
//------------------------------------------------------------------

IF IsValid(i_WindowParent) THEN
	l_this = THIS
	i_WindowParent.DYNAMIC fw_DeleteChildrenList(l_this)
	SetNull(i_WindowParent)
END IF

//------------------------------------------------------------------
//  Remove this window from the list of windows.
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

event resize;call super::resize;//******************************************************************
//  PC Module     : w_Response
//  Event         : Resize
//  Description   : Resize the controls when the window is
//                  resized by the user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_Control
INTEGER l_Idx
REAL    l_NewScaleX, l_NewScaleY, l_AspectRatio
REAL    l_NewScaleArea, l_TmpNewWidth, l_TmpNewHeight

//------------------------------------------------------------------
//  If this event is fired before the Open event (e.g. SDI) then
//  ignore the resize.
//------------------------------------------------------------------

IF i_WindowWidth = 0 THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Was the control key used to minimize all the windows involved
//  in the unit of work.
//------------------------------------------------------------------

l_Control = KeyDown(keyControl!)

//------------------------------------------------------------------
//  If we are minimized, then resizing the controls will not
//  make a difference.
//------------------------------------------------------------------

IF WindowState <> Minimized! THEN

   IF NOT (i_WindowState = Minimized! AND &
           i_WindowPrevState = WindowState) THEN

		i_WindowPrevState = WindowState
		l_NewScaleX   = WorkSpaceWidth()  / i_WindowWidth
   	l_NewScaleY   = WorkSpaceHeight() / i_WindowHeight
   	l_AspectRatio = i_WindowWidth / i_WindowHeight

   	IF WorkSpaceWidth()/WorkSpaceHeight() <= l_AspectRatio THEN
   	   l_TmpNewWidth  = WorkSpaceWidth()
   	   l_TmpNewHeight = WorkSpaceWidth() / l_AspectRatio
   	ELSE
   	   l_TmpNewHeight = WorkSpaceHeight()
      	l_TmpNewWidth  = WorkSpaceHeight() * l_AspectRatio
   	END IF

   	l_NewScaleArea = SQRT ((l_TmpNewWidth * l_TmpNewHeight) / &
                          (i_WindowWidth * i_WindowHeight))

   	IF i_ResizeWin THEN

      	//---------------------------------------------------------
      	//  Do any containers on the window.
      	//---------------------------------------------------------

      	IF i_NumContainers > 0 THEN
      	   SetReDraw(FALSE)
      	END IF

      	FOR l_Idx = 1 TO i_NumContainers
           	IF i_ZoomWin THEN
           	  	i_Containers[l_Idx].DYNAMIC fu_Resize(l_NewScaleArea)
           	ELSE
              	i_Containers[l_Idx].DYNAMIC fu_Resize(l_NewScaleX, l_NewScaleY)
           	END IF
      	NEXT

      	//---------------------------------------------------------
      	//  Do all other controls.
      	//---------------------------------------------------------

      	OBJCA.MGR.fu_ResizeControls(THIS, i_ControlSizes[], i_ZoomWin)

   	END IF
	END IF
END IF

//------------------------------------------------------------------
//  See if the window state changed.
//------------------------------------------------------------------

IF WindowState <> i_WindowState AND NOT i_IgnoreWindowState THEN

   //---------------------------------------------------------------
   //  See if the window state show cascade change to the children
   //  windows.
   //---------------------------------------------------------------

   IF l_Control THEN

      fw_CascadeState()

   ELSE
   
	   i_WindowState = WindowState

	END IF

END IF

end event

event closequery;call super::closequery;//******************************************************************
//  PC Module     : w_Response
//  Event         : CloseQuery
//  Description   : Verifies that it is Okay to close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumWindowChildren

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Check to see if any changes exist in the DataWindows on this 
//  window or any containers.  If changes exist, handle them 
//  according to the save-on-close option.
//------------------------------------------------------------------

IF fw_SaveOnClose() <> c_Success THEN
	Error.i_FWError = c_Fatal
	RETURN 1
END IF

//------------------------------------------------------------------
//  If this window has children then cascade to the bottom of the
//  window hierarchy before attempting to close this window.
//------------------------------------------------------------------

IF i_NumWindowChildren > 0 THEN
	l_NumWindowChildren = i_NumWindowChildren
	FOR l_Idx = l_NumWindowChildren TO 1 STEP -1
		Close(i_WindowChildren[l_Idx])
		IF Error.i_FWError = c_Fatal THEN
   		RETURN 1
		END IF
	NEXT
END IF

//------------------------------------------------------------------
//  If this window has PowerClass Containers then let the
//  DataWindow hierarchy on the container determine if it is ready
//  to close.  A call to each Container is necessary just in case 
//  there is no relationship between DataWindows.  If a Container
//  gets a call and its DataWindows have already been processed by 
//  its parent then it will just return.
//------------------------------------------------------------------

IF i_NumContainers > 0 THEN
	FOR l_Idx = i_NumContainers TO 1 STEP -1
		i_Containers[l_Idx].TriggerEvent("pc_CloseQuery")
   	IF Error.i_FWError = c_Fatal THEN
			RETURN 1
 		END IF
	NEXT
END IF

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
			RETURN 1
 		END IF
	NEXT
END IF

//------------------------------------------------------------------
//  Allow the developer to do processing before attempting to close.
//  This could include processing non-PowerClass DataWindows and
//  objects.
//------------------------------------------------------------------

THIS.TriggerEvent("pc_CloseQuery")
IF Error.i_FWError = c_Fatal THEN
  	RETURN 1
END IF

RETURN 0
end event

event activate;call super::activate;//******************************************************************
//  PC Module     : w_Response
//  Event         : Activate
//  Description   : Sets up for a window that gets focus.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

//------------------------------------------------------------------
//  If there are PowerClass DataWindow(s) on this window, we need 
//  to tell them that we just got activated so that one of them can
//  make itself the current DataWindow.
//------------------------------------------------------------------

IF i_NumDataWindows > 0 THEN
	FOR l_Idx = 1 TO i_NumDataWindows
		IF i_DataWindows[l_Idx].DYNAMIC fu_CheckCurrent() THEN
			IF GetFocus() = i_DataWindows[l_Idx] THEN
				i_DataWindows[l_Idx].DYNAMIC fu_Activate(1)
			ELSE
				i_DataWindows[l_Idx].DYNAMIC fu_Activate(2)
			END IF
			EXIT
		END IF
	NEXT
END IF

//------------------------------------------------------------------
//  Set this window as the current window.
//------------------------------------------------------------------

FWCA.MGR.i_WindowCurrent = THIS
end event

event deactivate;call super::deactivate;//******************************************************************
//  PC Module     : w_Response
//  Event         : Deactivate
//  Description   : Sets up for a window that loses focus.
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
//  If we are supposed to minimize when the window gets
//  deactivated, then do it.
//------------------------------------------------------------------

IF i_AutoMinimize AND NOT FWCA.MSG.i_MessageDisplaying THEN
   WindowState = Minimized!
END IF

end event

event open;call super::open;//******************************************************************
//  PC Module     : w_Response
//  Event         : Open
//  Description   : Initializes the DataWindows.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

INTEGER      l_Idx, l_NumControls, l_NumLinks, l_NumTabs, l_Jdx
INTEGER      l_LowTab, l_LowIndex
BOOLEAN      l_IgnoreUO
USEROBJECT   l_TabPage, l_UO
WINDOWOBJECT l_Control
TAB          l_Tab
DATAWINDOW   l_DW, l_ParentDW, l_LinkDW[]
WINDOW       l_Window, l_LinkWindow[]

//------------------------------------------------------------------
//  Determine if any PowerClass DataWindows are on this window.  If
//  there are, add them to the DataWindow list in this window and
//  trigger the pcd_SetOptions and pcd_SetCodeTables events for
//  the developer.  Set the lowest tab ordered DataWindow to be
//  current.
//------------------------------------------------------------------

IF Error.i_FWError = c_Success THEN

	i_NumDataWindows = 0

	l_LowTab = 9999
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
			IF NOT l_tab.CreateOnDemand THEN
				l_NumTabs = UpperBound(l_Tab.Control[])
				FOR l_Jdx = 1 TO l_NumTabs
					l_TabPage = l_Tab.Control[l_Jdx]
					fw_FindDW(l_TabPage, i_NumDataWindows, i_DataWindows[])
				NEXT
			END IF
		ELSEIF l_Control.TypeOf() = UserObject! THEN
			l_UO = Control[l_Idx]
			l_IgnoreUO = FALSE
			IF l_UO.TriggerEvent("po_Identify") = 1 THEN
				IF l_UO.DYNAMIC fu_GetIdentity() = "Container" THEN
					l_IgnoreUO = TRUE
				END IF
			END IF
			IF NOT l_IgnoreUO THEN
				fw_FindDW(l_UO, i_NumDataWindows, i_DataWindows[])
			END IF
		END IF
	NEXT

	//---------------------------------------------------------------
	//  If the timer is active, mark a time.
	//---------------------------------------------------------------

	IF IsValid(OBJCA.TIMER) THEN
		IF OBJCA.TIMER.i_TimerOn THEN
			OBJCA.TIMER.fu_TimerMark("Menu/Popup/Position Initialization")
		END IF
	END IF

	//---------------------------------------------------------------
	//  If PowerClass DataWindows exist, initialize them.
	//---------------------------------------------------------------

	IF i_NumDataWindows > 0 THEN
		FOR l_Idx = 1 TO i_NumDataWindows
			IF i_DataWindows[l_Idx].DYNAMIC fu_Open() <> c_Success THEN
				Error.i_FWError = c_Fatal
				GOTO Finished
			END IF
		NEXT

		//------------------------------------------------------------
		//  Apply security restrictions to the DataWindow rows and 
		//  columns.
		//------------------------------------------------------------

		IF IsValid(SECCA.MGR) THEN
			SECCA.MGR.DYNAMIC fu_SetRowSecurity(THIS)
		END IF
		
		//------------------------------------------------------------
		//  Determine if any parent/child relationships exist among
		//  the DataWindows.  If they do, determine the number of 
		//  unit-of-work hierarchies and create them or update the 
		//  DataWindow list in them.
		//------------------------------------------------------------

		FOR l_Idx = 1 TO i_NumDataWindows
			l_ParentDW = i_DataWindows[l_Idx]
			l_NumLinks = 1
			l_LinkDW[1] = l_ParentDW
			DO
				l_Window = l_ParentDW.DYNAMIC fu_GetParentWindow()
				l_ParentDW = l_ParentDW.DYNAMIC fu_GetParentDW()
				IF IsNull(l_ParentDW) = FALSE THEN
					l_NumLinks = l_NumLinks + 1
					l_LinkWindow[l_NumLinks] = l_Window
					l_LinkDW[l_NumLinks] = l_ParentDW
				END IF
			LOOP UNTIL IsNull(l_ParentDW) <> FALSE
		
			IF l_NumLinks > 1 THEN
				IF l_LinkDW[l_NumLinks].DYNAMIC fu_AddUOW(l_NumLinks, l_LinkDW[]) <> c_Success THEN
					Error.i_FWError = c_Fatal
					GOTO Finished
				END IF

				//------------------------------------------------------
				//  Determine if a DataWindow in the unit-of-work is on
				//  another window.  Set the first one we come to as the
				//  window parent.
				//------------------------------------------------------

				IF fw_LinkWindow(l_NumLinks, l_LinkWindow[]) <> c_Success THEN
					Error.i_FWError = c_Fatal
					GOTO Finished
				END IF
			END IF
		NEXT

		//------------------------------------------------------------
		//  Retrieve each root-level DataWindow in the list.  If a 
		//  DataWindow is not a root-level DataWindow then it will 
		//  just return.
		//------------------------------------------------------------

		FOR l_Idx = 1 TO i_NumDataWindows
			IF i_DataWindows[l_Idx].DYNAMIC fu_RetrieveOnOpen() <> c_Success THEN
				Error.i_FWError = c_Fatal
				GOTO Finished
			END IF
		NEXT

		//------------------------------------------------------------
		//  Set this window as the current window.
		//------------------------------------------------------------

		FWCA.MGR.i_WindowCurrent = THIS

		//------------------------------------------------------------
		//  Set the lowest tab ordered DataWindow to be current.
		//------------------------------------------------------------

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

END IF

Finished:

//------------------------------------------------------------------
//  If this is the first sheet to open, turn on redraw on the
//  MDI to prevent toolbar flashing.  
//------------------------------------------------------------------

IF FWCA.MGR.i_MDIValid THEN
	IF OBJCA.MGR.i_Parm.Window_Redraw THEN
		OBJCA.MGR.i_Parm.Window_Redraw = FALSE
		FWCA.MGR.i_MDIFrame.SetRedraw(TRUE)
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
//  If there was an error during initialization of this window,
//  then clean up.
//------------------------------------------------------------------

IF Error.i_FWError <> c_Success THEN
   Close(THIS)
END IF

end event

