$PBExportHeader$u_cb_print.sru
$PBExportComments$Command button for printing the DataWindow
forward
global type u_cb_print from u_cb_main
end type
end forward

global type u_cb_print from u_cb_main
string Text="&Print"
end type
global u_cb_print u_cb_print

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Print
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

i_Event = "Print"
i_Type  = 16

end event

