$PBExportHeader$u_cb_main.sru
$PBExportComments$Command button ancestor
forward
global type u_cb_main from commandbutton
end type
end forward

global type u_cb_main from commandbutton
int Width=311
int Height=108
int TabOrder=1
event po_identify pbm_custom75
end type
global u_cb_main u_cb_main

type variables
//----------------------------------------------------------------------------------------
//  Command Button Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName	= "Button"

//----------------------------------------------------------------------------------------
// Command Button Instance Variables
//----------------------------------------------------------------------------------------

WINDOW		i_Window
DATAWINDOW		i_ButtonDW

STRING			i_Event
INTEGER		i_Type

end variables

forward prototypes
public function string fu_getidentity ()
public function integer fu_gettype ()
public function integer fu_wiredw (datawindow dw_name)
public function integer fu_setenabled (datawindow dw_name, boolean status)
public subroutine fu_unwiredw ()
public function integer fu_setenabled (boolean status)
end prototypes

event po_identify;//******************************************************************
//  PO Module     : u_CB_Main
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

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_CB_Main
//  Function      : fu_GetIdentity
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

public function integer fu_gettype ();//******************************************************************
//  PC Module     : u_CB_Main
//  Function      : fu_GetType
//  Description   : Returns the type of button.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     Type of button.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN i_Type
end function

public function integer fu_wiredw (datawindow dw_name);//******************************************************************
//  PC Module     : u_CB_Main
//  Function      : fu_WireDW
//  Description   : Wires a DataWindow to this object.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     The DataWindow that is to be wired to
//                     this object.
//
//  Return Value  : INTEGER -
//                      0 = valid DataWindow.
//                     -1 = invalid DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = -1

//------------------------------------------------------------------
//  Make sure that we were passed a valid DataWindow to be wired.
//------------------------------------------------------------------

IF IsValid(dw_name) THEN

   i_ButtonDW       = dw_name
	i_ButtonDW.DYNAMIC fu_Wire(THIS)
   l_Return         = 0

	IF NOT IsValid(SECCA.MGR) THEN
		Enabled       = TRUE
	END IF

END IF

RETURN l_Return
end function

public function integer fu_setenabled (datawindow dw_name, boolean status);//******************************************************************
//  PC Module     : u_CB_Main
//  Function      : fu_SetEnabled
//  Description   : Determine if the button should be enabled or
//                  disabled.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     The DataWindow that is attempting to control
//                     the button.
//                  BOOLEAN    Status -
//                     Set to TRUE to enable, FALSE to disable.
//
//  Return Value  : INTEGER -
//                      0 = control successful.
//                     -1 = control failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = -1

//------------------------------------------------------------------
//  Make sure that we were passed a valid DataWindow.
//------------------------------------------------------------------

IF IsValid(dw_name) THEN

	//---------------------------------------------------------------
	//  If this button is wired directly to another DataWindow, then
	//  don't set control.
	//---------------------------------------------------------------
  
	IF IsNull(i_ButtonDW) = FALSE THEN
		IF dw_name = i_ButtonDW THEN
			Enabled  = status
			l_Return = 0
		END IF
	ELSE
		Enabled  = status
		l_Return = 0
	END IF

END IF

RETURN l_Return
end function

public subroutine fu_unwiredw ();//******************************************************************
//  PO Module     : u_CB_Main
//  Subroutine    : fu_UnwireDW
//  Description   : Un-wires a DataWindow from this object.
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
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

IF IsNull(i_ButtonDW) = FALSE THEN
	i_ButtonDW.DYNAMIC fu_Unwire(THIS)
	SetNull(i_ButtonDW)
	IF NOT IsValid(SECCA.MGR) THEN
		Enabled = FALSE
	END IF
END IF
end subroutine

public function integer fu_setenabled (boolean status);//******************************************************************
//  PC Module     : u_CB_Main
//  Function      : fu_SetEnabled
//  Description   : Determine if the button should be enabled or
//                  disabled.
//
//  Parameters    : BOOLEAN    Status -
//                     Set to TRUE to enable, FALSE to disable.
//
//  Return Value  : INTEGER -
//                      0 = control successful.
//                     -1 = control failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = -1

//------------------------------------------------------------
//  PowerBuilder 5.0 Bug
//  
//  This function sets the enable/disable status for command 
//  buttons.  It is called from the n_dwsrv_ctrl service using
//  the fu_SetControl function.  It was supposed to pass the
//  DataWindow as a parameter to this function but the
//  dynamic call causes a SHR GPF when exiting the 
//  application.  The workaround is to have fu_SetControl set
//  the DataWindow in FWCA.MGR.i_TmpServiceDW and then extract
//  it from here. If this problem is ever fixed this function 
//  can receive the DataWindow as a parameter.
//
//  Powersoft Issue Number: ?
//  Reported by           : Bill Carson
//  Report Date           : 7/15/96
//------------------------------------------------------------

//------------------------------------------------------------------
//  Make sure that we were passed a valid DataWindow.
//------------------------------------------------------------------

IF IsValid(FWCA.MGR.i_TmpServiceDW) THEN

	//---------------------------------------------------------------
	//  If this button is wired directly to another DataWindow, then
	//  don't set control.
	//---------------------------------------------------------------
  
	IF IsNull(i_ButtonDW) = FALSE THEN
		IF FWCA.MGR.i_TmpServiceDW = i_ButtonDW THEN
			Enabled  = status
			l_Return = 0
		END IF
	ELSE
		Enabled  = status
		l_Return = 0
	END IF

END IF

RETURN l_Return
end function

event destructor;//******************************************************************
//  PC Module     : u_CB_Main
//  Event         : Destructor
//  Description   : Unwire the button from the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsNull(i_ButtonDW) = FALSE THEN
	THIS.fu_UnwireDW()
END IF
end event

event constructor;//******************************************************************
//  PC Module     : u_CB_Main
//  Event         : Constructor
//  Description   : Initializes the command button.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

POWEROBJECT l_Container

//------------------------------------------------------------------
//  Get the window that this button is on.
//------------------------------------------------------------------

l_Container = GetParent()
DO 
	IF l_Container.TypeOf() = Window! THEN
		i_Window = l_Container
		EXIT
	ELSE
		l_Container = l_Container.GetParent()
	END IF
LOOP UNTIL l_Container.TypeOf() = Window!

SetNull(i_ButtonDW)
end event

event clicked;//******************************************************************
//  PC Module     : u_CB_Main
//  Event         : Clicked
//  Description   : Trigger an event on the window or, if wired to
//                  a specific DataWindow, trigger on DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Event
DATAWINDOW l_TmpDW

//------------------------------------------------------------------
//  Trigger the event on the DataWindow if the button has been
//  directly wired.
//------------------------------------------------------------------

IF IsNull(i_ButtonDW) = FALSE THEN
   IF IsValid(i_ButtonDW) THEN
		l_Event = "pcd_" + i_Event
		i_ButtonDW.TriggerEvent(l_Event)
		IF Error.i_FWError <> 0 THEN
			i_ButtonDW.SetFocus()
		END IF
	END IF

//------------------------------------------------------------------
//  If not directly wired, see if there is a current DataWindow and
//  trigger the event there.  If this button gets disabled the focus
//  will go to the lowest tab ordered control.  This might change
//  the current DataWindow.  If this occurs we will switch it
//  back (this may cause a flash).
//------------------------------------------------------------------

ELSEIF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
   l_TmpDW = FWCA.MGR.i_WindowCurrentDW
	l_Event = "pcd_" + i_Event
   FWCA.MGR.i_WindowCurrentDW.TriggerEvent(l_Event)

	IF Error.i_FWError <> 0 OR &
		(NOT Enabled AND l_TmpDW <> FWCA.MGR.i_WindowCurrentDW) THEN
		l_TmpDW.SetFocus()
	END IF

//------------------------------------------------------------------
//  If no DataWindow is current, then just trigger the event on the
//  window.
//------------------------------------------------------------------

ELSEIF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   l_Event = "pc_" + i_Event
   FWCA.MGR.i_WindowCurrent.TriggerEvent(l_Event)

END IF

end event

