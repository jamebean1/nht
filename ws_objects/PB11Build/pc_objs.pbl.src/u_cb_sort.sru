$PBExportHeader$u_cb_sort.sru
$PBExportComments$Command button for sorting the records
forward
global type u_cb_sort from u_cb_main
end type
end forward

global type u_cb_sort from u_cb_main
string Text="S&ort"
end type
global u_cb_sort u_cb_sort

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_Sort
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

i_Event = "Sort"
i_Type  = 13

end event

