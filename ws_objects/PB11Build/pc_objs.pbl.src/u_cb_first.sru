$PBExportHeader$u_cb_first.sru
$PBExportComments$Command button for scrolling to the first record
forward
global type u_cb_first from u_cb_main
end type
end forward

global type u_cb_first from u_cb_main
int Width=151
string Text="|<--"
end type
global u_cb_first u_cb_first

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_First
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

i_Event = "First"
i_Type  = 6

end event

