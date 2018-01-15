$PBExportHeader$u_cb_resetquery.sru
$PBExportComments$Command button for resetting the query criteria
forward
global type u_cb_resetquery from u_cb_main
end type
end forward

global type u_cb_resetquery from u_cb_main
int Width=485
int Height=101
string Text="Rese&t Query"
end type
global u_cb_resetquery u_cb_resetquery

event constructor;call super::constructor;//******************************************************************
//  PC Module     : u_CB_ResetQuery
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

i_Event = "ResetQuery"
i_Type  = 19

end event

event clicked;//******************************************************************
//  PC Module     : u_CB_ResetQuery
//  Event         : Clicked
//  Description   : Reset the DataWindows query criteria.
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
		FWCA.MGR.i_WindowCurrentDW.DYNAMIC fu_QueryReset()
	END IF
ELSE
	IF IsValid(i_ButtonDW) THEN
   	i_ButtonDW.DYNAMIC fu_QueryReset()
	END IF
END IF

end event

