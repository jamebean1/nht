$PBExportHeader$u_cb_close.sru
$PBExportComments$Command button for closing a window
forward
global type u_cb_close from u_cb_main
end type
end forward

global type u_cb_close from u_cb_main
string Text="&Close"
end type
global u_cb_close u_cb_close

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Close
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

i_Event = "Close"
i_Type  = 17

end event

event clicked;//******************************************************************
//  PC Module     : u_CB_Close
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

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   Close(FWCA.MGR.i_WindowCurrent)
END IF

end event

