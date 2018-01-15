$PBExportHeader$u_cb_next.sru
$PBExportComments$Command button for scrolling to the next record
forward
global type u_cb_next from u_cb_main
end type
end forward

global type u_cb_next from u_cb_main
int Width=151
string Text="-->"
end type
global u_cb_next u_cb_next

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Next
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

i_Event = "Next"
i_Type  = 8

end event

