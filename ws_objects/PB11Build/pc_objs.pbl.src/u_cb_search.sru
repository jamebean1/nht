$PBExportHeader$u_cb_search.sru
$PBExportComments$Command button for searching for records
forward
global type u_cb_search from u_cb_main
end type
end forward

global type u_cb_search from u_cb_main
string Text="S&earch"
end type
global u_cb_search u_cb_search

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Search
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

i_Event = "Search"
i_Type  = 11

end event

