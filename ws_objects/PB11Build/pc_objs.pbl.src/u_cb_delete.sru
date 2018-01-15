$PBExportHeader$u_cb_delete.sru
$PBExportComments$Command button for deleting the selected record(s)
forward
global type u_cb_delete from u_cb_main
end type
end forward

global type u_cb_delete from u_cb_main
string Text="&Delete"
end type
global u_cb_delete u_cb_delete

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Delete
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

i_Event = "Delete"
i_Type  = 5

end event

