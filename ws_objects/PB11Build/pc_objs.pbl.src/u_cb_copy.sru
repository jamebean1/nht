$PBExportHeader$u_cb_copy.sru
$PBExportComments$Command button for copying the selected record(s)
forward
global type u_cb_copy from u_cb_main
end type
end forward

global type u_cb_copy from u_cb_main
string Text="&Copy"
end type
global u_cb_copy u_cb_copy

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Copy
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

i_Event = "Copy"
i_Type  = 18

end event

