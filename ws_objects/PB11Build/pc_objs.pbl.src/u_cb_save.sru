$PBExportHeader$u_cb_save.sru
$PBExportComments$Command button for saving records
forward
global type u_cb_save from u_cb_main
end type
end forward

global type u_cb_save from u_cb_main
string Text="&Save"
end type
global u_cb_save u_cb_save

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Save
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

i_Event = "Save"
i_Type  = 14

end event

