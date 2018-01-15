$PBExportHeader$u_cb_view.sru
$PBExportComments$Command button for putting the DataWindow into read-only mode
forward
global type u_cb_view from u_cb_main
end type
end forward

global type u_cb_view from u_cb_main
string Text="&View"
end type
global u_cb_view u_cb_view

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_View
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

i_Event = "View"
i_Type  = 3

end event

