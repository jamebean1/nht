$PBExportHeader$w_pl_newpwd_main.srw
$PBExportComments$Ancestor new password window
forward
global type w_pl_newpwd_main from window
end type
type sle_newpassword2 from singlelineedit within w_pl_newpwd_main
end type
type sle_newpassword1 from singlelineedit within w_pl_newpwd_main
end type
type st_2 from statictext within w_pl_newpwd_main
end type
type st_1 from statictext within w_pl_newpwd_main
end type
type cb_cancel from commandbutton within w_pl_newpwd_main
end type
type cb_ok from commandbutton within w_pl_newpwd_main
end type
type st_password from statictext within w_pl_newpwd_main
end type
type sle_oldpassword from singlelineedit within w_pl_newpwd_main
end type
end forward

global type w_pl_newpwd_main from window
integer x = 864
integer y = 404
integer width = 1193
integer height = 772
boolean titlebar = true
string title = "Change Password"
windowtype windowtype = response!
long backcolor = 80269524
event type boolean pl_changepwd ( string userlogin,  string oldpassword,  string newpassword,  ref transaction pwdtrans,  ref boolean pwdchanged )
sle_newpassword2 sle_newpassword2
sle_newpassword1 sle_newpassword1
st_2 st_2
st_1 st_1
cb_cancel cb_cancel
cb_ok cb_ok
st_password st_password
sle_oldpassword sle_oldpassword
end type
global w_pl_newpwd_main w_pl_newpwd_main

type variables

TRANSACTION	PWDCA
STRING 		i_Login, i_LoginType
BOOLEAN	i_pwdchanged = FALSE
BOOLEAN	i_pwderror = FALSE	



end variables

event pl_changepwd;//******************************************************************
//  PL Module     : w_pl_newpwd_main
//  Event         : pl_changepwd
//  Description   : User coded event to allow passwords to be
//						  changed in application databases when the user's
//						  login and password are used to connect.  Prior
//						  to performing the password change a connection
//						  must be made to the database.
//
//	 Parameters    : UserLogin - the user's login ID.
//
//                  OldPassword - the old password.
//
//                  NewPassword - the new password.
//
//                  PwdTrans - transaction object needed to connect to
//									    an application database.  The parameters
//									    are those that were defined in the
//									    connections profile in the Security
//									    Administration program.
//
//						  PwdChanged - this indicator must be set to
//									      TRUE if this event has been coded 
//									      to perform the password change,
//								         otherwise a message box will be
//									      presented to the user telling them
//									      that the password change event has
//                               not been implemented.
//
//  Return        : BOOLEAN - TRUE if an error occurs,
//                            FALSE if OK
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//******************************************************************
// The following sample code illustrates how this event can
// be used to change a user's password for a Watcom database.
//******************************************************************
//
//STRING l_SQLString
//
////----------------------------------------------------------------
////  Set the flag to tell PowerLock that this event has been coded.
////----------------------------------------------------------------
//
//PwdChanged = TRUE
//
////----------------------------------------------------------------
////  Connect to the database and change the password.
////----------------------------------------------------------------
//
//CONNECT USING PwdTrans;
//
//l_SQLString = "GRANT CONNECT TO " + UserLogin + &
//                  " IDENTIFIED BY " + NewPassword
//EXECUTE IMMEDIATE :l_SQLString USING PwdTrans;
//
////----------------------------------------------------------------
////  Return TRUE if an error occured, else return FALSE.
////----------------------------------------------------------------
//
//IF PwdTrans.SQLCode < 0 THEN
//   DISCONNECT USING PwdTrans;
//   RETURN TRUE
//ELSE
//   DISCONNECT USING PwdTrans;
//   RETURN FALSE
//END IF
//******************************************************************

RETURN FALSE	
end event

event open;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main
//  Event         : Open
//  Description   : Get the current user's login name.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING   l_Temp
INTEGER 	l_Check, l_ScreenWidth, l_ScreenHeight
ENVIRONMENT	l_Env

SetPointer(HourGlass!)

//------------------------------------------------------------------
//  Size and position the window.
//------------------------------------------------------------------

Height = 772

GetEnvironment(l_Env)

l_ScreenWidth = PixelsToUnits(l_Env.ScreenWidth, xPixelsToUnits!)
l_ScreenHeight = PixelsToUnits(l_Env.ScreenHeight, yPixelsToUnits!)

Move((l_ScreenWidth - Width ) / 2, (l_ScreenHeight - Height) / 2)

l_Temp = Message.StringParm
i_Login = MID(l_Temp, 1, POS(l_Temp, "|") - 1)
i_LoginType = MID(l_Temp, POS(l_Temp, "|") + 1)
IF Pos(i_LoginType, "|") > 0 THEN
	l_Temp = i_LoginType
	i_LoginType = MID(l_Temp, 1, POS(l_Temp, "|") - 1)
	sle_oldpassword.Text = MID(l_Temp, POS(l_Temp, "|") + 1)
	sle_newpassword1.SetFocus()
END IF
end event

on w_pl_newpwd_main.create
this.sle_newpassword2=create sle_newpassword2
this.sle_newpassword1=create sle_newpassword1
this.st_2=create st_2
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_password=create st_password
this.sle_oldpassword=create sle_oldpassword
this.Control[]={this.sle_newpassword2,&
this.sle_newpassword1,&
this.st_2,&
this.st_1,&
this.cb_cancel,&
this.cb_ok,&
this.st_password,&
this.sle_oldpassword}
end on

on w_pl_newpwd_main.destroy
destroy(this.sle_newpassword2)
destroy(this.sle_newpassword1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_password)
destroy(this.sle_oldpassword)
end on

type sle_newpassword2 from singlelineedit within w_pl_newpwd_main
integer x = 558
integer y = 324
integer width = 494
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

event getfocus;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main.sle_NewPassword2
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

type sle_newpassword1 from singlelineedit within w_pl_newpwd_main
event pl_keydown pbm_keydown
integer x = 558
integer y = 196
integer width = 494
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

event pl_keydown;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main
//  Event         : sle_newpassword1.pl_keyword
//  Description   : User event to change focus to the second new
//						  password edit field after text has been entered
//					     into the old password field.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF KeyDown(KeyEnter!) THEN
   SetFocus(sle_newpassword2)
END IF
end event

event getfocus;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main.sle_NewPassword1
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
cb_ok.default = FALSE
end event

type st_2 from statictext within w_pl_newpwd_main
integer x = 64
integer y = 324
integer width = 453
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "New Password:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pl_newpwd_main
integer x = 64
integer y = 196
integer width = 453
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "New Password:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_pl_newpwd_main
integer x = 681
integer y = 508
integer width = 265
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel the password change and close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CloseWithReturn(Parent, "")
end event

type cb_ok from commandbutton within w_pl_newpwd_main
integer x = 169
integer y = 516
integer width = 265
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main.cb_OK
//  Event         : Clicked
//  Description   : Validate the old and new password.  If OK, close
//                  the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/6/98	Beth Byers	Added a call to the function f_pl_pwd_restrictions
//								to test for any special restrictions for the new
//								password (i.e. must be minimum of 8 characters).
//								The function will display an appropriate message.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER	l_Idx	
STRING	l_DBInfo[], l_DBName, l_MsgStrings[]

SetPointer(HourGlass!)

IF sle_oldpassword.text = "" THEN
   SECCA.MSG.fu_DisplayMessage("PwdOld")
   sle_oldpassword.SetFocus()
   RETURN
END IF

IF sle_newpassword1.text = "" THEN
   SECCA.MSG.fu_DisplayMessage("PwdNew1")
   sle_newpassword1.SetFocus()
   RETURN
END IF

IF sle_newpassword2.text = "" THEN
   SECCA.MSG.fu_DisplayMessage("PwdNew2")
   sle_newpassword2.SetFocus()
   RETURN
END IF

IF NOT f_pl_pwd_restrictions(sle_newpassword1.text) THEN
	sle_newpassword1.SetFocus()
	RETURN
END IF
//-------------------------------------------------------------------
//  If an Administrator is logging in to the security administration
//  program check their old password to make sure it is valid,
//  make sure that the new password "entered twice" match, then 
//  update the new password in the admin table.
//-------------------------------------------------------------------
 
IF i_LoginType = "ADMIN" THEN
   IF SECCA.MGR.fu_CheckAdminOldPwd(i_Login, sle_oldpassword.text) = 0 THEN
      IF sle_newpassword1.text = sle_newpassword2.text THEN
         IF SECCA.MGR.fu_SetAdmInfo(SECCA.MGR.i_AdmKey, sle_newpassword1.text) = 0 THEN
            CloseWithReturn(PARENT, sle_newpassword2.text)
         ELSE
            CloseWithReturn(PARENT, "")
         END IF
      ELSE
         SECCA.MSG.fu_DisplayMessage("PwdMismatch")
         sle_newpassword2.SetFocus()
      END IF
   ELSE
      sle_oldpassword.SetFocus()
   END IF
ELSE

	//-------------------------------------------------------------------
	//  If an end user is logging in to an application, check their 
	//  old password to make sure it is valid,
	//  make sure that the new password "entered twice" match, then 
	//  update the new password in the user table.
	//-------------------------------------------------------------------

   IF SECCA.MGR.fu_CheckOldPwd(i_Login, sle_oldpassword.text) = 0 THEN
      IF sle_newpassword1.text = sle_newpassword2.text THEN
			IF SECCA.MGR.i_UseLogin THEN
				PWDCA = CREATE Transaction
				FOR l_Idx = 1 TO SECCA.MGR.i_NumConnections
 					SECCA.MGR.fu_GetDBUserInfo(SECCA.MGR.i_DBKey, &
										 l_DBName, l_DBInfo[], &
										 i_Login, sle_oldpassword.text)

      			PWDCA.DBMS       = l_DBInfo[1]
     				PWDCA.Database   = l_DBInfo[2]
      			PWDCA.ServerName = l_DBInfo[3]
     				PWDCA.UserId     = l_DBInfo[4]
     				PWDCA.DBPass	  = l_DBInfo[5]
     				PWDCA.LogId		  = l_DBInfo[6]
					PWDCA.LogPass	  = l_DBInfo[7]
	   			PWDCA.DBParm     = l_DBInfo[8]
      			PWDCA.Lock       = l_DBInfo[9]
      			IF l_DBInfo[10] = "0" THEN
         			PWDCA.AutoCommit = FALSE
      			ELSE
         			PWDCA.AutoCommit = TRUE
      			END IF
					i_PwdChanged = FALSE
					IF Event pl_ChangePwd(i_Login, sle_oldpassword.Text, &
					                      sle_newpassword1.Text, PWDCA, &
												 i_PwdChanged) THEN
						l_MsgStrings[1] = PWDCA.SQLErrText
 						SECCA.MSG.fu_DisplayMessage("PwdUpdateFailed", &
						                            1, l_MsgStrings[])
						CloseWithReturn(PARENT, "")
						EXIT
					END IF   
					IF i_PwdChanged THEN
            		CloseWithReturn(PARENT, sle_newpassword2.text)
						EXIT
   				ELSE
   					SECCA.MSG.fu_DisplayMessage("PwdNotImplemented")
   					CloseWithReturn(PARENT, "")
					END IF
   
         	END FOR

			ELSE
         	IF SECCA.MGR.fu_SetUsrPwd(i_Login, sle_newpassword1.text) = 0 THEN
            	CloseWithReturn(PARENT, sle_newpassword2.text)
         	ELSE
            	CloseWithReturn(PARENT, "")       
         	END IF
			END IF
		
      ELSE
         SECCA.MSG.fu_DisplayMessage("PwdMismatch")
         sle_newpassword2.SetFocus()
      END IF
   ELSE
      sle_oldpassword.SetFocus()
   END IF
END IF
end event

type st_password from statictext within w_pl_newpwd_main
integer x = 64
integer y = 80
integer width = 453
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "Old Password:"
boolean focusrectangle = false
end type

type sle_oldpassword from singlelineedit within w_pl_newpwd_main
event pl_keydown pbm_keydown
integer x = 558
integer y = 76
integer width = 494
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean password = true
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

event pl_keydown;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main
//  Event         : sle_oldpassword.pl_keyword
//  Description   : User event to change focus to the new password
//                  edit field after text has been entered into
//						  the old password field.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF KeyDown(KeyEnter!) THEN
   SetFocus(sle_newpassword1)
END IF
end event

event getfocus;//******************************************************************
//  PL Module     : w_PL_NewPwd_Main.sle_OldPassword
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
cb_ok.default = FALSE
end event

