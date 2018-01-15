$PBExportHeader$u_cb_modify.sru
$PBExportComments$Command button for putting a DataWindow into edit mode
forward
global type u_cb_modify from u_cb_main
end type
end forward

global type u_cb_modify from u_cb_main
string Text="&Modify"
end type
global u_cb_modify u_cb_modify

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Modify
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

i_Event = "Modify"
i_Type  = 4

end event

