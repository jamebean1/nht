$PBExportHeader$w_connect.srw
$PBExportComments$Window to enter or correct connection information
forward
global type w_connect from Window
end type
type cb_cancel from commandbutton within w_connect
end type
type cb_ok from commandbutton within w_connect
end type
type sle_user_id from singlelineedit within w_connect
end type
type sle_db_parmeter from singlelineedit within w_connect
end type
type sle_server_name from singlelineedit within w_connect
end type
type sle_logon_password from singlelineedit within w_connect
end type
type sle_logon_id from singlelineedit within w_connect
end type
type sle_db_password from singlelineedit within w_connect
end type
type sle_database from singlelineedit within w_connect
end type
type sle_dbms from singlelineedit within w_connect
end type
type st_db_parameter from statictext within w_connect
end type
type st_server_name from statictext within w_connect
end type
type st_logon_password from statictext within w_connect
end type
type st_logon_id from statictext within w_connect
end type
type st_db_password from statictext within w_connect
end type
type st_user_id from statictext within w_connect
end type
type st_database from statictext within w_connect
end type
type st_dbms from statictext within w_connect
end type
end forward

global type w_connect from Window
int X=33
int Y=49
int Width=1381
int Height=1133
boolean TitleBar=true
string Title="Database Connection Setup"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
cb_cancel cb_cancel
cb_ok cb_ok
sle_user_id sle_user_id
sle_db_parmeter sle_db_parmeter
sle_server_name sle_server_name
sle_logon_password sle_logon_password
sle_logon_id sle_logon_id
sle_db_password sle_db_password
sle_database sle_database
sle_dbms sle_dbms
st_db_parameter st_db_parameter
st_server_name st_server_name
st_logon_password st_logon_password
st_logon_id st_logon_id
st_db_password st_db_password
st_user_id st_user_id
st_database st_database
st_dbms st_dbms
end type
global w_connect w_connect

type variables
TRANSACTION	i_TransObject
SINGLELINEEDIT	i_CurrentSLE

end variables

event open;//******************************************************************
//  PO Module     : w_Connect
//  Event         : Open
//  Description   : Set the information from the Transaction
//                  Object into the SLE fields.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_TransObject            = Message.PowerObjectParm
i_TransObject.SQLCode    = -1

sle_DBMS.Text            = i_TransObject.DBMS
sle_Database.Text        = i_TransObject.DataBase
sle_User_Id.Text         = i_TransObject.UserId
sle_DB_Password.Text     = i_TransObject.DBPass
sle_Logon_Id.Text        = i_TransObject.LogId
sle_Logon_Password.Text  = i_TransObject.LogPass
sle_Server_Name.Text     = i_TransObject.ServerName
sle_DB_Parmeter.Text     = i_TransObject.DBParm

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

BackColor                   = OBJCA.WIN.i_WindowColor

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   sle_DBMS.BorderStyle            = StyleShadowBox!
   sle_Database.BorderStyle        = StyleShadowBox!
   sle_User_Id.BorderStyle         = StyleShadowBox!
   sle_DB_Password.BorderStyle     = StyleShadowBox!
   sle_Logon_Id.BorderStyle        = StyleShadowBox!
   sle_Logon_Password.BorderStyle  = StyleShadowBox!
   sle_Server_Name.BorderStyle     = StyleShadowBox!
   sle_DB_Parmeter.BorderStyle     = StyleShadowBox!
END IF

st_DBMS.BackColor           = OBJCA.WIN.i_WindowColor
st_DBMS.TextColor           = OBJCA.WIN.i_WindowTextColor
st_DBMS.FaceName            = OBJCA.WIN.i_WindowTextFont
st_DBMS.TextSize            = OBJCA.WIN.i_WindowTextSize

st_Database.BackColor       = OBJCA.WIN.i_WindowColor
st_Database.TextColor       = OBJCA.WIN.i_WindowTextColor
st_Database.FaceName        = OBJCA.WIN.i_WindowTextFont
st_Database.TextSize        = OBJCA.WIN.i_WindowTextSize

st_User_Id.BackColor        = OBJCA.WIN.i_WindowColor
st_User_Id.TextColor        = OBJCA.WIN.i_WindowTextColor
st_User_Id.FaceName         = OBJCA.WIN.i_WindowTextFont
st_User_Id.TextSize         = OBJCA.WIN.i_WindowTextSize

st_DB_Password.BackColor    = OBJCA.WIN.i_WindowColor
st_DB_Password.TextColor    = OBJCA.WIN.i_WindowTextColor
st_DB_Password.FaceName     = OBJCA.WIN.i_WindowTextFont
st_DB_Password.TextSize     = OBJCA.WIN.i_WindowTextSize

st_Logon_Id.BackColor       = OBJCA.WIN.i_WindowColor
st_Logon_Id.TextColor       = OBJCA.WIN.i_WindowTextColor
st_Logon_Id.FaceName        = OBJCA.WIN.i_WindowTextFont
st_Logon_Id.TextSize        = OBJCA.WIN.i_WindowTextSize

st_Logon_Password.BackColor = OBJCA.WIN.i_WindowColor
st_Logon_Password.TextColor = OBJCA.WIN.i_WindowTextColor
st_Logon_Password.FaceName  = OBJCA.WIN.i_WindowTextFont
st_Logon_Password.TextSize  = OBJCA.WIN.i_WindowTextSize

st_Server_Name.BackColor    = OBJCA.WIN.i_WindowColor
st_Server_Name.TextColor    = OBJCA.WIN.i_WindowTextColor
st_Server_Name.FaceName     = OBJCA.WIN.i_WindowTextFont
st_Server_Name.TextSize     = OBJCA.WIN.i_WindowTextSize

st_DB_Parameter.BackColor   = OBJCA.WIN.i_WindowColor
st_DB_Parameter.TextColor   = OBJCA.WIN.i_WindowTextColor
st_DB_Parameter.FaceName    = OBJCA.WIN.i_WindowTextFont
st_DB_Parameter.TextSize    = OBJCA.WIN.i_WindowTextSize

cb_Ok.FaceName              = OBJCA.WIN.i_WindowTextFont
cb_Ok.TextSize              = OBJCA.WIN.i_WindowTextSize

cb_Cancel.FaceName          = OBJCA.WIN.i_WindowTextFont
cb_Cancel.TextSize          = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Reposition based on the window size.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)
end event

on w_connect.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_user_id=create sle_user_id
this.sle_db_parmeter=create sle_db_parmeter
this.sle_server_name=create sle_server_name
this.sle_logon_password=create sle_logon_password
this.sle_logon_id=create sle_logon_id
this.sle_db_password=create sle_db_password
this.sle_database=create sle_database
this.sle_dbms=create sle_dbms
this.st_db_parameter=create st_db_parameter
this.st_server_name=create st_server_name
this.st_logon_password=create st_logon_password
this.st_logon_id=create st_logon_id
this.st_db_password=create st_db_password
this.st_user_id=create st_user_id
this.st_database=create st_database
this.st_dbms=create st_dbms
this.Control[]={ this.cb_cancel,&
this.cb_ok,&
this.sle_user_id,&
this.sle_db_parmeter,&
this.sle_server_name,&
this.sle_logon_password,&
this.sle_logon_id,&
this.sle_db_password,&
this.sle_database,&
this.sle_dbms,&
this.st_db_parameter,&
this.st_server_name,&
this.st_logon_password,&
this.st_logon_id,&
this.st_db_password,&
this.st_user_id,&
this.st_database,&
this.st_dbms}
end on

on w_connect.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_user_id)
destroy(this.sle_db_parmeter)
destroy(this.sle_server_name)
destroy(this.sle_logon_password)
destroy(this.sle_logon_id)
destroy(this.sle_db_password)
destroy(this.sle_database)
destroy(this.sle_dbms)
destroy(this.st_db_parameter)
destroy(this.st_server_name)
destroy(this.st_logon_password)
destroy(this.st_logon_id)
destroy(this.st_db_password)
destroy(this.st_user_id)
destroy(this.st_database)
destroy(this.st_dbms)
end on

type cb_cancel from commandbutton within w_connect
int X=814
int Y=893
int Width=330
int Height=93
int TabOrder=100
string Text=" Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Connect.cb_Cancel
//  Event         : Clicked
//  Description   : Abort the connection processing.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_TransObject.SQLCode = -1
Close(PARENT)
end event

type cb_ok from commandbutton within w_connect
int X=229
int Y=893
int Width=330
int Height=93
int TabOrder=90
string Text=" OK"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Connect.cb_OK
//  Event         : Clicked
//  Description   : Get the information from the SLE fields into
//                  the Transaction Object.  Verify the
//                  information and do the CONNECT.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_ErrorStrings[]

i_TransObject.DBMS       = sle_DBMS.Text
i_TransObject.DataBase   = sle_DataBase.Text
i_TransObject.UserId     = sle_User_Id.Text
i_TransObject.DBPass     = sle_DB_Password.Text
i_TransObject.LogId      = sle_Logon_Id.Text
i_TransObject.LogPass    = sle_Logon_Password.Text
i_TransObject.ServerName = sle_Server_Name.Text
i_TransObject.DBParm     = sle_DB_Parmeter.Text

//-------------------------------------------------------------------
//  Attempt a connection.
//-------------------------------------------------------------------

CONNECT USING i_TransObject;

//-------------------------------------------------------------------
//  Check for errors during the CONNECT.
//-------------------------------------------------------------------

IF i_TransObject.SQLCode <> 0 THEN

   //----------------------------------------------------------------
   //  The CONNECT failed.  Put up a MessageBox error.
   //----------------------------------------------------------------

	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = GetParent().ClassName()
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "Clicked"
   l_ErrorStrings[6] = i_TransObject.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("DBConnectError", &
                               6, l_ErrorStrings[])
   i_CurrentSLE.SetFocus()
ELSE
   //----------------------------------------------------------------
   //  The CONNECT was successful.
   //----------------------------------------------------------------

   i_TransObject.SQLCode = 0
   Close(PARENT)
END IF

end event

type sle_user_id from singlelineedit within w_connect
int X=545
int Y=253
int Width=732
int Height=81
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_User_Id
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type sle_db_parmeter from singlelineedit within w_connect
int X=545
int Y=753
int Width=732
int Height=81
int TabOrder=80
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_DB_Parameter
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type sle_server_name from singlelineedit within w_connect
int X=545
int Y=653
int Width=732
int Height=81
int TabOrder=70
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_Server_Name
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type sle_logon_password from singlelineedit within w_connect
int X=545
int Y=553
int Width=732
int Height=81
int TabOrder=60
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_Logon_Password
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type sle_logon_id from singlelineedit within w_connect
int X=545
int Y=453
int Width=732
int Height=81
int TabOrder=50
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_Logon_Id
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type sle_db_password from singlelineedit within w_connect
int X=545
int Y=353
int Width=732
int Height=81
int TabOrder=40
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_DB_Password
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type sle_database from singlelineedit within w_connect
int X=545
int Y=153
int Width=732
int Height=81
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_Database
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type sle_dbms from singlelineedit within w_connect
int X=545
int Y=53
int Width=732
int Height=81
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Connect.sle_DBMS
//  Event         : GetFocus
//  Description   : Make this SLE current and highlight the text.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CurrentSLE = THIS
SelectText(1, LEN(Text))
end event

type st_db_parameter from statictext within w_connect
int X=42
int Y=765
int Width=385
int Height=73
string Text="DB Parameter:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_server_name from statictext within w_connect
int X=42
int Y=665
int Width=371
int Height=73
string Text="Server Name:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_logon_password from statictext within w_connect
int X=42
int Y=565
int Width=462
int Height=73
string Text="Logon Password:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_logon_id from statictext within w_connect
int X=42
int Y=465
int Width=279
int Height=73
string Text="Logon ID:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_db_password from statictext within w_connect
int X=42
int Y=365
int Width=371
int Height=73
string Text="DB Password:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_user_id from statictext within w_connect
int X=42
int Y=265
int Width=238
int Height=73
string Text="User ID:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_database from statictext within w_connect
int X=42
int Y=165
int Width=298
int Height=73
string Text="Database:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_dbms from statictext within w_connect
int X=42
int Y=65
int Width=490
int Height=73
string Text="Database Vendor:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

