$PBExportHeader$u_cb_last.sru
$PBExportComments$Command button for scrolling to the last record
forward
global type u_cb_last from u_cb_main
end type
end forward

global type u_cb_last from u_cb_main
int Width=151
string Text="-->|"
end type
global u_cb_last u_cb_last

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Last
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

i_Event = "Last"
i_Type  = 9

end event

