$PBExportHeader$u_cb_resetsearch.sru
$PBExportComments$Command button for resetting the search criteria
forward
global type u_cb_resetsearch from u_cb_main
end type
end forward

global type u_cb_resetsearch from u_cb_main
int Width=485
int Height=101
string Text="Rese&t Search"
end type
global u_cb_resetsearch u_cb_resetsearch

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_ResetSearch
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

i_Event = "ResetSearch"
i_Type  = 25

end event

event clicked;//******************************************************************
//  PC Module     : u_CB_ResetSearch
//  Event         : Clicked
//  Description   : Reset the DataWindows search objects.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsNull(i_ButtonDW) <> FALSE THEN
	IF IsValid(FWCA.MGR.i_WindowCurrentDW) THEN
		FWCA.MGR.i_WindowCurrentDW.DYNAMIC fu_SearchReset()
	END IF
ELSE
	IF IsValid(i_ButtonDW) THEN
   	i_ButtonDW.DYNAMIC fu_SearchReset()
	END IF
END IF

end event

