$PBExportHeader$w_pl_connections.srw
$PBExportComments$Connections window
forward
global type w_pl_connections from window
end type
type st_1 from statictext within w_pl_connections
end type
type cbx_default from checkbox within w_pl_connections
end type
type dw_connections from datawindow within w_pl_connections
end type
type cb_cancel from commandbutton within w_pl_connections
end type
type cb_ok from commandbutton within w_pl_connections
end type
type gb_connections from groupbox within w_pl_connections
end type
end forward

global type w_pl_connections from window
integer x = 663
integer y = 404
integer width = 1618
integer height = 900
boolean titlebar = true
string title = "Application Login"
windowtype windowtype = response!
long backcolor = 80269524
st_1 st_1
cbx_default cbx_default
dw_connections dw_connections
cb_cancel cb_cancel
cb_ok cb_ok
gb_connections gb_connections
end type
global w_pl_connections w_pl_connections

type variables
INTEGER	i_Attempts = 1

LONG		i_UsrKey = -1
LONG		i_DBKey = -1

STRING		i_UsrLogin
STRING		i_UsrName

end variables

event open;//******************************************************************
//  PL Module     : w_PL_Connections
//  Event         : Open
//  Description   : This window is used to display a list of
//						  database connections when the network login
//						  is used to log into the application.
//						  If only one connection is defined for the
//						  user this window will not be displayed.
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_UsrName, l_UsrLogin
LONG   l_Rows
INTEGER l_Check, l_Idx, l_ScreenWidth, l_ScreenHeight
ENVIRONMENT	l_Env

SetPointer(HourGlass!)

//------------------------------------------------------------------
//  Size and position the window.
//------------------------------------------------------------------

Height = 900

GetEnvironment(l_Env)

l_ScreenWidth = PixelsToUnits(l_Env.ScreenWidth, xPixelsToUnits!)
l_ScreenHeight = PixelsToUnits(l_Env.ScreenHeight, yPixelsToUnits!)

Move((l_ScreenWidth - Width ) / 2, (l_ScreenHeight - Height) / 2)

Title = SECCA.MGR.i_AppName 

//-----------------------------------------------------------------
//  If registration mode is turned on either because the application
//  is being launched from the administration program, or because
//  it has been turned on in the application's profile, log in to
//	 the application in registration mode.
//-----------------------------------------------------------------

IF Pos(CommandParm(), "Object Registration") > 0 THEN
	SECCA.MGR.i_RegistrationMode = TRUE
END IF

//-----------------------------------------------------------------
//  If the application's profile has opted to use the current
//  user's novell login and password, we query novell to get
//  them.  If the user needs to select a database connection
//  display w_connections, otherwise bypass displaying it and
//	 log in to the application.   	
//-----------------------------------------------------------------

IF SECCA.MGR.fu_GetNetID(i_UsrLogin) = 0 THEN
	l_Check = SECCA.MGR.fu_CheckLoginOnly(i_UsrLogin)
	IF l_Check < 0 THEN
		CloseWithReturn(this, -1)
	END IF
   i_UsrKey = SECCA.MGR.fu_GetUsrKey(i_UsrLogin, i_UsrName)
	IF SECCA.MGR.i_UseLogin THEN
	END IF	
   IF i_UsrKey > 0 THEN
	   IF SECCA.MGR.i_AppTrans.DBMS = "" THEN
   	   dw_connections.SetTransObject(SECCA.MGR.i_SecTrans)
         l_Rows = dw_connections.Retrieve(SECCA.MGR.i_AppKey, i_UsrKey)
			
			CHOOSE CASE l_Rows
			CASE 1
       	   i_DBKey = dw_connections.GetItemNumber(1, "db_key")
            cb_ok.TriggerEvent(Clicked!)
         CASE IS > 1 
           	i_DBKey = SECCA.MGR.fu_GetDBDefaultKey(i_UsrKey)
				dw_connections.SelectRow(0, FALSE)
	         cbx_default.Checked = FALSE
   
	         IF i_DBKey <> -1 THEN
            	FOR l_Idx = 1 TO l_Rows
               	IF dw_connections.GetItemNumber(l_Idx, "db_key") = i_DBKey THEN
                  	dw_connections.SelectRow(l_Idx, TRUE)
                  	cbx_default.Checked = TRUE
                  	EXIT
               	END IF
            	NEXT
         	ELSE
            	i_DBKey = dw_connections.GetItemNumber(1, "db_key")
            	dw_connections.SelectRow(1, TRUE)
         	END IF

			CASE 0
				i_DBKey = 0

			CASE IS < 0
				i_DBKey = -1

         END CHOOSE
      ELSE
			i_DBKey = 0
     		cb_ok.TriggerEvent(Clicked!)
      END IF
   ELSE
		i_DBKey = -1
	END IF
END IF


end event

on w_pl_connections.create
this.st_1=create st_1
this.cbx_default=create cbx_default
this.dw_connections=create dw_connections
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.gb_connections=create gb_connections
this.Control[]={this.st_1,&
this.cbx_default,&
this.dw_connections,&
this.cb_cancel,&
this.cb_ok,&
this.gb_connections}
end on

on w_pl_connections.destroy
destroy(this.st_1)
destroy(this.cbx_default)
destroy(this.dw_connections)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.gb_connections)
end on

type st_1 from statictext within w_pl_connections
integer x = 119
integer y = 68
integer width = 1088
integer height = 84
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 80269524
boolean enabled = false
string text = "Please select a database connection:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_default from checkbox within w_pl_connections
integer x = 1134
integer y = 380
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

type dw_connections from datawindow within w_pl_connections
integer x = 128
integer y = 284
integer width = 942
integer height = 244
integer taborder = 30
string dataobject = "d_login"
boolean vscrollbar = true
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_Connections.dw_Connections
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
   SelectRow(0, FALSE)
   SelectRow(l_ClickedRow, TRUE)
END IF

cb_ok.default = TRUE
end event

type cb_cancel from commandbutton within w_pl_connections
integer x = 1184
integer y = 660
integer width = 311
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_Connections.cb_Cancel
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

type cb_ok from commandbutton within w_pl_connections
integer x = 64
integer y = 660
integer width = 311
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;//******************************************************************
//  PL Module     : w_PL_Connections.cb_OK
//  Event         : Clicked
//  Description   : Connect to the application transaction and 
//						  retrieve window object restrictions into the
//						  security manager.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_TmpPassword, l_DBInfo[], l_DBName, l_UsrPassword
INTEGER l_Check
LONG    l_DBKey

SetPointer(HourGlass!)

IF SECCA.MGR.i_UseLogin THEN
	l_UsrPassword = SECCA.MGR.i_UsrID
END IF

IF	SECCA.MGR.i_RegistrationMode THEN

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
END IF

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
   SECCA.MGR.i_AppTrans.DBPass     = l_DBInfo[5]
   SECCA.MGR.i_AppTrans.LogId      = l_DBInfo[6]
   SECCA.MGR.i_AppTrans.LogPass    = l_DBInfo[7]
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
   SECCA.MGR.fu_SetUsrInfo(i_UsrKey, l_TmpPassword, l_DBKey)

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
      l_Check = SECCA.MGR.fu_connect(SECCA.MGR.i_AppTrans)
		IF l_Check = 0 THEN
			SECCA.MGR.i_AppConnected = TRUE
		END IF
	END IF
	CHOOSE CASE l_Check
	CASE -1 
      CloseWithReturn(Parent, -1)
   CASE -2
		i_Attempts = Message.DoubleParm
   	IF SECCA.MGR.i_GraceAttempts = i_Attempts THEN
         SECCA.MSG.fu_DisplayMessage("LoginExceeded")
     		SECCA.MGR.fu_SetUsrStatus(0, i_usrlogin)
     		cb_cancel.TriggerEvent(Clicked!)
   	ELSE
         SECCA.MSG.fu_DisplayMessage("LoginInvalid")
			SECCA.MGR.i_AppTrans.DBMS = ""
      	CloseWithReturn(Parent, -2)
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


end event

type gb_connections from groupbox within w_pl_connections
integer x = 69
integer y = 196
integer width = 1431
integer height = 384
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

