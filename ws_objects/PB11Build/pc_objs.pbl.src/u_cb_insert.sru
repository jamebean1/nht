$PBExportHeader$u_cb_insert.sru
$PBExportComments$Command button for inserting a record(s)
forward
global type u_cb_insert from u_cb_main
end type
end forward

global type u_cb_insert from u_cb_main
string Text="&Insert"
end type
global u_cb_insert u_cb_insert

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Insert
//  Event         : Constructor
//  Description   : Sets up the command button.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

i_Event = "New"
i_Type  = 2

end event

event clicked;//******************************************************************
//  PC Module     : u_CB_Insert
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

STRING     l_Event
DATAWINDOW l_TmpDW

//------------------------------------------------------------------
//  Trigger the event on the DataWindow if the button has been
//  directly wired.
//------------------------------------------------------------------

IF IsNull(i_ButtonDW) = FALSE THEN
   IF IsValid(i_ButtonDW) THEN
		i_ButtonDW.DYNAMIC Event pcd_New(2, 0)
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
   FWCA.MGR.i_WindowCurrentDW.DYNAMIC Event pcd_New(2, 0)

	IF NOT Enabled AND l_TmpDW <> FWCA.MGR.i_WindowCurrentDW THEN
		l_TmpDW.SetFocus()
	END IF

//------------------------------------------------------------------
//  If no DataWindow is current, then just trigger the event on the
//  window.
//------------------------------------------------------------------

ELSEIF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   FWCA.MGR.i_WindowCurrent.DYNAMIC Event pc_New(2, 0)

END IF
end event

