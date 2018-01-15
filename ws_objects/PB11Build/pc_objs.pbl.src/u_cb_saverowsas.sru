$PBExportHeader$u_cb_saverowsas.sru
$PBExportComments$Command button for saving the contents of the DataWindow in different file formats
forward
global type u_cb_saverowsas from u_cb_main
end type
end forward

global type u_cb_saverowsas from u_cb_main
int Width=485
int Height=100
string Text="Save Ro&ws As"
end type
global u_cb_saverowsas u_cb_saverowsas

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_SaveRowsAs
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

i_Event = "SaveRowsAs"
i_Type  = 15

end event

