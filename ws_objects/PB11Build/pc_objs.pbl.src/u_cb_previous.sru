$PBExportHeader$u_cb_previous.sru
$PBExportComments$Command button for scrolling to the previous record
forward
global type u_cb_previous from u_cb_main
end type
end forward

global type u_cb_previous from u_cb_main
int Width=151
string Text="<--"
end type
global u_cb_previous u_cb_previous

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Previous
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

i_Event = "Previous"
i_Type  = 7

end event

