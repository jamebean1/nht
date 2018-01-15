$PBExportHeader$w_pl_login_main.srw
$PBExportComments$Ancestor login window
forward
global type w_pl_login_main from window
end type
type cbx_registration from checkbox within w_pl_login_main
end type
type cbx_default from checkbox within w_pl_login_main
end type
type dw_connections from datawindow within w_pl_login_main
end type
type cb_cancel from commandbutton within w_pl_login_main
end type
type cb_pwd from commandbutton within w_pl_login_main
end type
type cb_ok from commandbutton within w_pl_login_main
end type
type p_login from picture within w_pl_login_main
end type
type st_password from statictext within w_pl_login_main
end type
type st_login from statictext within w_pl_login_main
end type
type sle_password from singlelineedit within w_pl_login_main
end type
type sle_login from singlelineedit within w_pl_login_main
end type
type gb_connections from groupbox within w_pl_login_main
end type
end forward

global type w_pl_login_main from window
integer x = 663
integer y = 404
integer width = 1573
integer height = 1116
boolean titlebar = true
string title = "Application Login"
windowtype windowtype = response!
long backcolor = 80269524
cbx_registration cbx_registration
cbx_default cbx_default
dw_connections dw_connections
cb_cancel cb_cancel
cb_pwd cb_pwd
cb_ok cb_ok
p_login p_login
st_password st_password
st_login st_login
sle_password sle_password
sle_login sle_login
gb_connections gb_connections
end type
global w_pl_login_main w_pl_login_main

type variables
SINGLELINEEDIT	i_CurrentSLE

BOOLEAN	i_NewPassword = FALSE

INTEGER	i_Attempts = 1, i_ScreenHeight

LONG		i_UsrKey = -1
LONG		i_DBKey = -1

STRING		i_UsrLogin
STRING		i_UsrName

end variables

event open;//******************************************************************
//  PL Module     : w_pl_login_main
//  Event         : Open
//  Description   : Initialize window controls.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING 	l_UsrName, l_UsrLogin
LONG   	l_Rows
INTEGER 	l_Check, l_ScreenWidth
ENVIRONMENT	l_Env

SetPointer(HourGlass!)

IF Message.StringParm <> "" THEN
   p_login.PictureName = Message.StringParm
ELSE
   p_login.visible = FALSE
END IF

//------------------------------------------------------------------
//  Size and position the window.
//------------------------------------------------------------------

Height = 669

GetEnvironment(l_Env)

l_ScreenWidth = PixelsToUnits(l_Env.ScreenWidth, xPixelsToUnits!)
i_ScreenHeight = PixelsToUnits(l_Env.ScreenHeight, yPixelsToUnits!)

Move((l_ScreenWidth - Width ) / 2, (i_ScreenHeight - Height) / 2)

Title = SECCA.MGR.i_AppName + " Login"

//-----------------------------------------------------------------
//  If registration mode is turned on either because the application
//  is being launched from the administration program, or because
//  it has been turned on in the application's profile, display
//  the registration button on the login window.  If the application
//  has been launched, check it.
//-----------------------------------------------------------------

IF SECCA.MGR.fu_CheckRegister() OR &
   SECCA.MGR.i_RegistrationMode = TRUE OR &
   Pos(CommandParm(), "Object Registration") > 0 THEN
   cbx_registration.Visible = TRUE
   IF Pos(CommandParm(), "Object Registration") > 0 THEN
      cbx_registration.Checked = TRUE
   END IF    
ELSE
   cbx_registration.Visible = FALSE  
END IF


end event

on w_pl_login_main.create
this.cbx_registration=create cbx_registration
this.cbx_default=create cbx_default
this.dw_connections=create dw_connections
this.cb_cancel=create cb_cancel
this.cb_pwd=create cb_pwd
this.cb_ok=create cb_ok
this.p_login=create p_login
this.st_password=create st_password
this.st_login=create st_login
this.sle_password=create sle_password
this.sle_login=create sle_login
this.gb_connections=create gb_connections
this.Control[]={this.cbx_registration,&
this.cbx_default,&
this.dw_connections,&
this.cb_cancel,&
this.cb_pwd,&
this.cb_ok,&
this.p_login,&
this.st_password,&
this.st_login,&
this.sle_password,&
this.sle_login,&
this.gb_connections}
end on

on w_pl_login_main.destroy
destroy(this.cbx_registration)
destroy(this.cbx_default)
destroy(this.dw_connections)
destroy(this.cb_cancel)
destroy(this.cb_pwd)
destroy(this.cb_ok)
destroy(this.p_login)
destroy(this.st_password)
destroy(this.st_login)
destroy(this.sle_password)
destroy(this.sle_login)
destroy(this.gb_connections)
end on

type cbx_registration from checkbox within w_pl_login_main
integer x = 434
integer y = 300
integer width = 453
integer height = 68
integer taborder = 30
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
string text = "Registration"
borderstyle borderstyle = stylelowered!
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_login_main.cbx_Registration
//  Event         : Clicked
//  Description   : Shift the focus back to either the login or
//                  password field after this checkbox is clicked.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SetFocus(i_CurrentSLE)
end event

type cbx_default from checkbox within w_pl_login_main
integer x = 1120
integer y = 768
integer width = 320
integer height = 52
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
string text = "Default"
borderstyle borderstyle = stylelowered!
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_login_main.cbx_Default
//  Event         : Clicked
//  Description   : Shift the focus back to either the login or
//                  password field after this checkbox is clicked.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SetFocus(i_CurrentSLE)
end event

type dw_connections from datawindow within w_pl_login_main
integer x = 110
integer y = 676
integer width = 942
integer height = 244
integer taborder = 70
string dataobject = "d_login"
boolean vscrollbar = true
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_login_main.dw_Connections
//  Event         : Clicked
//  Description   : Select a database connection.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_ClickedRow

l_ClickedRow = Row

IF l_ClickedRow > 0 THEN
   i_DBKey  = GetItemNumber(l_ClickedRow, "db_key")
	SECCA.MGR.i_DBKey = i_DBKey
   SelectRow(0, FALSE)
   SelectRow(l_ClickedRow, TRUE)
   SetFocus(i_CurrentSLE)
END IF

end event

type cb_cancel from commandbutton within w_pl_login_main
integer x = 1161
integer y = 428
integer width = 311
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_login_main.cb_Cancel
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

type cb_pwd from commandbutton within w_pl_login_main
integer x = 453
integer y = 428
integer width = 613
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change &Password"
end type

event clicked;//******************************************************************
//  PL Module     : w_pl_login_main.cb_pwd
//  Event         : Clicked
//  Description   : Open a window to enter a new password.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Login, l_PwdDate, l_Year, l_Month, l_Day, l_Object
INTEGER l_Check
DATE    l_Date
WINDOW  l_Window

//----------------------------------------------------------------
//  First check to make sure that a valid login has been entered.
//  If it has, open the new password window, passing the valid
//  login which will be displayed on the new password window.
//  If the new password passed validation, display it on the login 
//  window
//----------------------------------------------------------------

IF SECCA.MGR.i_UseLogin THEN
	IF SECCA.MGR.i_NumConnections > 1 THEN
		IF SECCA.MSG.fu_DisplayMessage("LoginSelectDB") <> 1 THEN
			RETURN
		END IF
	END IF
END IF

l_Login = TRIM(sle_login.text)
l_Check = SECCA.MGR.fu_CheckLoginOnly(l_Login)

IF l_Check >= 0 THEN
   i_NewPassword = FALSE
   IF l_Check = 1 THEN
		l_Login = l_Login + "|USER|changeme"	
	ELSE
		l_Login = l_Login + "|USER"
	END IF

   l_Object = SECCA.DEF.fu_GetDefault("Security", "NewPassword")
	IF l_Object <> "" THEN
		OpenWithParm(l_Window, l_Login, l_Object)
	ELSE
		Message.StringParm = ""
	END IF

   IF Message.StringParm <> "" THEN
      i_NewPassword = TRUE
      sle_password.text = Message.StringParm
		l_Date = Today()
		
		l_Year = String(Year(l_Date))
		
		l_Month = String(Month(l_Date))
		IF Len(l_Month) = 1 THEN
			l_Month = "0" + l_Month
		END IF
		
		l_Day = String(Day(l_Date))
		IF Len(l_Day) = 1 THEN
			l_Day = "0" + l_Day
		END IF
		
		l_PwdDate = l_Year + l_Month + l_Day
   	UPDATE pl_usr SET usr_pwd_date = :l_PwdDate WHERE usr_key = :i_usrkey
     	   USING SECCA.MGR.i_SecTrans;
		SECCA.MGR.fu_Commit()
   END IF
END IF

SetFocus(i_CurrentSLE)
end event

type cb_ok from commandbutton within w_pl_login_main
integer x = 50
integer y = 428
integer width = 311
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
//  PL Module     : w_pl_login_main.cb_OK
//  Event         : Clicked
//  Description   : Validate the login and password. Connect to the
//                  application transaction and retrieve window
//                  object restrictions into the security manager.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_UsrPassword, l_TmpPassword, l_DBInfo[], l_DBName
INTEGER l_Check
LONG    l_DBKey

SetPointer(HourGlass!)

l_UsrPassword = sle_password.text

IF SECCA.MGR.i_UseLogin THEN
	l_Check = SECCA.MGR.fu_CheckUseLogin(sle_login.text, i_Attempts)
ELSE
	l_Check = SECCA.MGR.fu_CheckLogin(sle_login.text,  & 
											   	sle_password.text, &
                                    	i_Attempts)
END IF

IF l_Check = 0 THEN

	//---------------------------------------------------------------
	//  Retrieve database connection info from the security database.
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//  If registration checkbox was checked, set flag indicating
	//  that application should be executed in registration mode.
	//---------------------------------------------------------------

   IF cbx_registration.Checked = TRUE THEN
   	SECCA.MGR.i_RegistrationMode = TRUE

		//------------------------------------------------------------
		//  Create a transaction object for generating unique keys.
		//------------------------------------------------------------

		SECCA.MGR.i_KeyTrans            = CREATE Transaction
		SECCA.MGR.i_KeyTrans.DBMS       = SECCA.MGR.i_SecTrans.DBMS
		SECCA.MGR.i_KeyTrans.Database   = SECCA.MGR.i_SecTrans.Database
		SECCA.MGR.i_KeyTrans.UserId     = SECCA.MGR.i_SecTrans.UserId
		SECCA.MGR.i_KeyTrans.DBPass     = SECCA.MGR.i_SecTrans.DBPass
		SECCA.MGR.i_KeyTrans.LogId      = SECCA.MGR.i_SecTrans.LogId
		SECCA.MGR.i_KeyTrans.LogPass    = SECCA.MGR.i_SecTrans.LogPass
		SECCA.MGR.i_KeyTrans.ServerName = SECCA.MGR.i_SecTrans.ServerName
		SECCA.MGR.i_KeyTrans.DBParm     = SECCA.MGR.i_SecTrans.DBParm

		//-----------------------------------------------------------
		//  Connect to the security database with the key generation
		//  transaction object.  Abort initialization if connection 
		//  fails.
		//-----------------------------------------------------------

		IF SECCA.MGR.fu_connect(SECCA.MGR.i_KeyTrans) = -1 THEN
   		 CloseWithReturn(Parent, -1)
		END IF
		SECCA.MGR.i_KeyTransConnected = TRUE
   ELSE
      SECCA.MGR.i_RegistrationMode = FALSE   
   END IF

	//---------------------------------------------------------------
	//  Start audit trail if opted.
	//---------------------------------------------------------------

   IF SECCA.MGR.i_UseAudit THEN
      SECCA.MGR.fu_BeginAudit()
   END IF

	IF i_DBKey > 0 THEN
      SECCA.MGR.fu_GetDBUserInfo(i_DBKey, l_DBName, l_DBInfo[], &
										 i_UsrLogin, l_UsrPassword)

      SECCA.MGR.i_AppTrans.DBMS       = l_DBInfo[1]
      SECCA.MGR.i_AppTrans.Database   = l_DBInfo[2]
      SECCA.MGR.i_AppTrans.ServerName = l_DBInfo[3]
     	SECCA.MGR.i_AppTrans.UserId     = l_DBInfo[4]
     	SECCA.MGR.i_AppTrans.DBPass	  = l_DBInfo[5]
     	SECCA.MGR.i_AppTrans.LogId		  = l_DBInfo[6]
		SECCA.MGR.i_AppTrans.LogPass	  = l_DBInfo[7]
	   SECCA.MGR.i_AppTrans.DBParm     = l_DBInfo[8]
      SECCA.MGR.i_AppTrans.Lock       = l_DBInfo[9]
      IF l_DBInfo[10] = "0" THEN
         SECCA.MGR.i_AppTrans.AutoCommit = FALSE
      ELSE
         SECCA.MGR.i_AppTrans.AutoCommit = TRUE
      END IF
      
      IF cbx_default.Checked THEN
         l_DBKey = i_DBKey
      ELSE
         l_DBKey = 0
      END IF

		//---------------------------------------------------------------
		//  Add default connection id to user table, if a default
		//  was specified on the login window.
		//---------------------------------------------------------------

      l_TmpPassword = ""
      SECCA.MGR.fu_SetUsrInfo(i_UsrKey, l_TmpPassword, &
                                l_DBKey)

      SECCA.MGR.i_UsrKey   = i_UsrKey
      SECCA.MGR.i_UsrLogin = i_UsrLogin
      SECCA.MGR.i_UsrName  = i_UsrName
      SECCA.MGR.i_DBKey    = i_DBKey
      SECCA.MGR.i_DBName   = l_DBName
		
		//---------------------------------------------------------------
		//  Combine restrictions if more than one role has been
		//  assigned to the user.
		//---------------------------------------------------------------

      SECCA.MGR.TriggerEvent("pld_retrieve")

      l_Check = 0
      IF NOT SECCA.MGR.i_SameTrans THEN
		   l_Check =  SECCA.MGR.fu_connect(SECCA.MGR.i_AppTrans)
			IF l_Check = 0 THEN
				SECCA.MGR.i_AppConnected = TRUE
			END IF
		END IF
		CHOOSE CASE l_Check
		CASE -1 
         CloseWithReturn(Parent, -1)
      CASE -2
    		IF SECCA.MGR.i_GraceAttempts = i_Attempts THEN
       		SECCA.MSG.fu_DisplayMessage("LoginExceeded")
        		SECCA.MGR.fu_SetUsrStatus(0, i_usrlogin)
       		cb_cancel.TriggerEvent(Clicked!)
     		ELSE
      		SECCA.MSG.fu_DisplayMessage("LoginInvalid")
   			i_Attempts = i_Attempts + 1
   			i_NewPassword = FALSE
   		END IF
		CASE 0 
			IF NOT SECCA.MGR.i_RegistrationMode THEN
				IF NOT SECCA.MGR.i_SameTrans THEN
   			   IF SECCA.MGR.fu_disconnect(SECCA.MGR.i_SecTrans) = 0 THEN
					   SECCA.MGR.i_SecurityConnected = FALSE
				   END IF
				END IF
			END IF
         CloseWithReturn(Parent, 0)
      END CHOOSE

   ELSEIF i_DBKey = -1 THEN
      CloseWithReturn(Parent, -1)

   ELSEIF i_DBKey = 0 THEN
      IF SECCA.MGR.i_AppTrans.DBMS = "" THEN
         SECCA.MSG.fu_DisplayMessage("LoginNoDB")  
         CloseWithReturn(Parent, -1)
      END IF
      
      SECCA.MGR.i_UsrKey   = i_UsrKey
      SECCA.MGR.i_UsrLogin = i_UsrLogin
      SECCA.MGR.i_UsrName  = i_UsrName

      SECCA.MGR.TriggerEvent("pld_retrieve")

		IF NOT SECCA.MGR.i_RegistrationMode THEN
			IF NOT SECCA.MGR.i_SameTrans THEN
   		   IF SECCA.MGR.fu_disconnect(SECCA.MGR.i_SecTrans) = 0 THEN
				   SECCA.MGR.i_SecurityConnected = FALSE
			   END IF
			END IF
		END IF

      CloseWithReturn(Parent, 0)
   END IF

ELSEIF l_Check = -1 THEN
   i_Attempts = i_Attempts + 1
   i_NewPassword = FALSE
   SetFocus(sle_login)
ELSEIF l_Check = -2 THEN
   cb_cancel.TriggerEvent(Clicked!)
ELSEIF l_Check = -3 THEN
   cb_pwd.TriggerEvent(Clicked!)
END IF
end event

type p_login from picture within w_pl_login_main
integer x = 1088
integer y = 80
integer width = 288
integer height = 256
boolean originalsize = true
boolean focusrectangle = false
end type

type st_password from statictext within w_pl_login_main
integer x = 64
integer y = 208
integer width = 320
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "Password:"
boolean focusrectangle = false
end type

type st_login from statictext within w_pl_login_main
integer x = 64
integer y = 92
integer width = 215
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "Login:"
boolean focusrectangle = false
end type

type sle_password from singlelineedit within w_pl_login_main
integer x = 407
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

on getfocus;//******************************************************************
//  PL Module     : w_pl_login_main.sle_Password
//  Event         : GetFocus
//  Description   : When this field gets focus, automatically select
//                  the current text and make the OK button the
//                  default button.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1995.  All Rights Reserved.
//******************************************************************

SelectText(THIS, 1, LEN(THIS.Text))
i_CurrentSLE = THIS
cb_ok.Default = TRUE
end on

type sle_login from singlelineedit within w_pl_login_main
event pl_keydown pbm_keydown
integer x = 407
integer y = 84
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
textcase textcase = lower!
borderstyle borderstyle = stylelowered!
end type

event pl_keydown;//******************************************************************
//  PL Module     : w_pl_login_main.sle_Login
//  Event         : pl_KeyDown
//  Description   : Allow the ENTER key to be used to change focus
//                  to the password field.
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
   SetFocus(sle_password)
END IF
end event

event modified;//******************************************************************
//  PL Module     : w_pl_login_main.sle_Login
//  Event         : Modified
//  Description   : Validate user's login.  Display list of
//                  database connections if multiple defined for the 
//                  user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Check

i_UsrLogin = text

//------------------------------------------------------------------
//  If password is "changeme", prompt the user to change it.
//------------------------------------------------------------------

l_Check = SECCA.MGR.fu_CheckLoginOnly(text)
IF l_Check = 1 THEN
   cb_pwd.TriggerEvent(Clicked!)
   IF NOT i_NewPassword THEN
   	GOTO Finished
   END IF
END IF

i_UsrKey = SECCA.MGR.fu_GetUsrKey(text, i_UsrName)
SECCA.MGR.i_NumConnections = 0

IF i_UsrKey <> -1 THEN
   IF SECCA.MGR.i_AppTrans.DBMS = "" THEN
      dw_connections.SelectRow(0, FALSE)
      dw_connections.SetTransObject(SECCA.MGR.i_SecTrans)
      l_Rows = dw_connections.Retrieve(SECCA.MGR.i_AppKey, i_UsrKey)
      IF l_Rows > 0 THEN
         cbx_default.Checked = FALSE
         i_DBKey = SECCA.MGR.fu_GetDBDefaultKey(i_UsrKey)
			SECCA.MGR.i_DBKey = i_DBKey
			FOR l_Idx = 1 TO l_Rows
				SECCA.MGR.i_DBKeys[l_Idx] = & 
							dw_connections.GetItemNumber(l_Idx, "db_key")
				SECCA.MGR.i_NumConnections++
			END FOR
         IF i_DBKey <> -1 THEN
            FOR l_Idx = 1 TO l_Rows
					IF SECCA.MGR.i_DBKeys[l_Idx] = i_DBKey THEN
                  dw_connections.SelectRow(l_Idx, TRUE)
						dw_connections.ScrollToRow(l_Idx)
                  cbx_default.Checked = TRUE
                  EXIT
               END IF
            NEXT
         ELSE
            i_DBKey = dw_connections.GetItemNumber(1, "db_key")
				SECCA.MGR.i_DBKey = i_DBKey
            dw_connections.SelectRow(1, TRUE)
         END IF
         IF l_Rows > 1 THEN
            Parent.Height = 1117
            Parent.Move(Parent.X,(i_ScreenHeight - Parent.Height) / 2)
         ELSE
            IF Parent.Height > 700 THEN
               Parent.Height = 669
               Parent.Move(Parent.X,(i_ScreenHeight - Parent.Height) / 2)
            END IF
         END IF
      ELSEIF l_Rows = 0 THEN
         i_DBKey = 0
      ELSE
         i_DBKey = -1
      END IF
   ELSE
		IF i_Attempts = 1 THEN
      	i_DBKey = 0
		END IF
   END IF
ELSE
   i_DBKey = -1
END IF

Finished:

IF l_Check = 1 AND NOT i_NewPassword THEN
   cb_cancel.PostEvent(Clicked!)
END IF
end event

event getfocus;//******************************************************************
//  PL Module     : w_pl_login_main.sle_Login
//  Event         : GetFocus
//  Description   : When this control gets focus, automatically
//                  select the current text and remove the OK button
//                  as the default.
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
i_CurrentSLE = THIS
cb_ok.Default = FALSE
end event

type gb_connections from groupbox within w_pl_login_main
integer x = 64
integer y = 588
integer width = 1417
integer height = 380
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
string text = "Database Connections"
borderstyle borderstyle = stylelowered!
end type

