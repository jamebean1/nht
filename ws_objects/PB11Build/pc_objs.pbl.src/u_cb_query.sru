$PBExportHeader$u_cb_query.sru
$PBExportComments$Command button for putting the DataWindow into query mode
forward
global type u_cb_query from u_cb_main
end type
end forward

global type u_cb_query from u_cb_main
string Text="&Query"
end type
global u_cb_query u_cb_query

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Query
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

i_Event = "Query"
i_Type  = 10

end event

