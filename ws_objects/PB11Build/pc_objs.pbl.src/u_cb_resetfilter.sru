$PBExportHeader$u_cb_resetfilter.sru
$PBExportComments$Command button for resetting the filter criteria
forward
global type u_cb_resetfilter from u_cb_main
end type
end forward

global type u_cb_resetfilter from u_cb_main
int Width=485
int Height=101
string Text="Rese&t Filter"
end type
global u_cb_resetfilter u_cb_resetfilter

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_ResetFilter
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

i_Event = "ResetFilter"
i_Type  = 26

end event

event clicked;//******************************************************************
//  PC Module     : u_CB_ResetFilter
//  Event         : Clicked
//  Description   : Reset the DataWindows filter objects.
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
		FWCA.MGR.i_WindowCurrentDW.DYNAMIC fu_FilterReset()
	END IF
ELSE
	IF IsValid(i_ButtonDW) THEN
   	i_ButtonDW.DYNAMIC fu_FilterReset()
	END IF
END IF

end event

