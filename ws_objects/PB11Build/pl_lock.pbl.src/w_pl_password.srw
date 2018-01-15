$PBExportHeader$w_pl_password.srw
$PBExportComments$Password window
forward
global type w_pl_password from window
end type
type sle_password from singlelineedit within w_pl_password
end type
type st_1 from statictext within w_pl_password
end type
type cb_cancel from commandbutton within w_pl_password
end type
type cb_ok from commandbutton within w_pl_password
end type
end forward

global type w_pl_password from window
integer x = 663
integer y = 404
integer width = 1326
integer height = 592
boolean titlebar = true
string title = "Application Login"
windowtype windowtype = response!
long backcolor = 80269524
sle_password sle_password
st_1 st_1
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_pl_password w_pl_password

type variables
SINGLELINEEDIT	i_CurrentSLE

BOOLEAN	i_NewPassword = FALSE

INTEGER	i_Attempts = 1

LONG		i_UsrKey = -1
LONG		i_DBKey = -1

STRING		i_UsrLogin
STRING		i_UsrName

end variables

event open;//******************************************************************
//  PL Module     : w_PL_Password
//  Event         : Open
//  Description   : This window used displayed when the net id
//						  is used to login and the login and password
//						  are used to connect to the database.  In this
//						  scenerio we need to obtain the password from the
//						  user since it is not returned by call to get
//						  the network id.	
//						  	
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1995.  All Rights Reserved.
//******************************************************************

INTEGER 	l_Check, l_ScreenWidth, l_ScreenHeight
ENVIRONMENT	l_Env

SetPointer(HourGlass!)

Height = 593

GetEnvironment(l_Env)

l_ScreenWidth = PixelsToUnits(l_Env.ScreenWidth, xPixelsToUnits!)
l_ScreenHeight = PixelsToUnits(l_Env.ScreenHeight, yPixelsToUnits!)

Move((l_ScreenWidth - Width ) / 2, (l_ScreenHeight - Height) / 2)

Title = SECCA.MGR.i_AppName 

IF SECCA.MGR.fu_GetNetID(i_UsrLogin) = 0 THEN
	l_Check = SECCA.MGR.fu_CheckLoginOnly(i_UsrLogin)
	IF l_Check < 0 THEN
		CloseWithReturn(this, -1)
	END IF
END IF
end event

on w_pl_password.create
this.sle_password=create sle_password
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.sle_password,&
this.st_1,&
this.cb_cancel,&
this.cb_ok}
end on

on w_pl_password.destroy
destroy(this.sle_password)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type sle_password from singlelineedit within w_pl_password
integer x = 137
integer y = 164
integer width = 1033
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean password = true
integer limit = 20
end type

event getfocus;//******************************************************************
//  PL Module     : w_PL_Password.sle_Password
//  Event         : GetFocus
//  Description   : Select the current text when this control gets
//                  focus.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SelectText(1, LEN(Text))
cb_ok.default = TRUE
end event

type st_1 from statictext within w_pl_password
integer x = 128
integer y = 68
integer width = 768
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "Please enter a password:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_pl_password
integer x = 850
integer y = 324
integer width = 311
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_Password.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel the login attempt and close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CloseWithReturn(Parent, -1)
end event

type cb_ok from commandbutton within w_pl_password
integer x = 137
integer y = 324
integer width = 311
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_Password.cb_OK
//  Event         : Clicked
//  Description   : Return the password that was entered.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
// Use the password specified in sle_password, even if empty.
//------------------------------------------------------------------

SECCA.MGR.i_UsrID = sle_password.text
CloseWithReturn(Parent, 0)
end event

