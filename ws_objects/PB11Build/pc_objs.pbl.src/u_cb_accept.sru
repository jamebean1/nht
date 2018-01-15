$PBExportHeader$u_cb_accept.sru
$PBExportComments$Command button for accepting an operation
forward
global type u_cb_accept from u_cb_main
end type
end forward

global type u_cb_accept from u_cb_main
string Text="&Accept"
end type
global u_cb_accept u_cb_accept

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Accept
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

i_Event = "Accept"
i_Type  = 20

end event

