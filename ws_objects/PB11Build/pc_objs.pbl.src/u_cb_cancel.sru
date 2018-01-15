$PBExportHeader$u_cb_cancel.sru
$PBExportComments$Command button for cancelling an operation
forward
global type u_cb_cancel from u_cb_main
end type
end forward

global type u_cb_cancel from u_cb_main
string Text="&Cancel"
end type
global u_cb_cancel u_cb_cancel

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Cancel
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

i_Event = "Cancel"
i_Type  = 22

end event

