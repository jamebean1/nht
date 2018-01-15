$PBExportHeader$u_cb_filter.sru
$PBExportComments$Command button for filtering records
forward
global type u_cb_filter from u_cb_main
end type
end forward

global type u_cb_filter from u_cb_main
string Text="Fil&ter"
end type
global u_cb_filter u_cb_filter

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Filter
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

i_Event = "Filter"
i_Type  = 12

end event

