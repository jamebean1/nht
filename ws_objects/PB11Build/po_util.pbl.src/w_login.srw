$PBExportHeader$w_login.srw
$PBExportComments$Window to log in to an application
forward
global type w_login from Window
end type
type cb_cancel from commandbutton within w_login
end type
type cb_ok from commandbutton within w_login
end type
type p_login_bitmap from picture within w_login
end type
type st_password from statictext within w_login
end type
type st_login from statictext within w_login
end type
type sle_password from singlelineedit within w_login
end type
type sle_login from singlelineedit within w_login
end type
end forward

global type w_login from Window
int X=668
int Y=405
int Width=1367
int Height=589
boolean TitleBar=true
string Title="Login"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
cb_cancel cb_cancel
cb_ok cb_ok
p_login_bitmap p_login_bitmap
st_password st_password
st_login st_login
sle_password sle_password
sle_login sle_login
end type
global w_login w_login

type variables
SINGLELINEEDIT	i_CurrentSLE

INTEGER		i_Attempts = 1




end variables

event open;//******************************************************************
//  PO Module     : w_Login
//  Event         : Open
//  Description   : Initialize the login window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG    l_WindowWidth, l_WindowHeight, l_NewWidth
LONG    l_HeightAdj, l_NewHeight

SetPointer(HourGlass!)

OBJCA.WIN.i_Parm.Answer = -1

//------------------------------------------------------------------
//  Set the bitmap and resize.
//------------------------------------------------------------------

IF Len(Trim(OBJCA.WIN.i_Parm.Login_Bitmap)) = 0 THEN
   p_Login_Bitmap.Visible = FALSE
   l_NewWidth  = 0
   l_NewHeight = 0
ELSE
   p_Login_Bitmap.PictureName  = OBJCA.WIN.i_Parm.Login_Bitmap
   p_Login_Bitmap.OriginalSize = TRUE
   l_NewWidth  = p_Login_Bitmap.Width
   l_NewHeight = p_Login_Bitmap.Height
END IF

IF l_NewHeight < 393 THEN
   l_NewHeight = 393
   l_HeightAdj = 0
ELSE
   l_HeightAdj = (l_NewHeight - 393) / 2
END IF

//------------------------------------------------------------------
//  Move the static text objects based on the new bitmap size.
//------------------------------------------------------------------

l_WindowWidth  = (5 * p_Login_Bitmap.X) + l_NewWidth + 930 + 20
l_WindowHeight = (2 * p_Login_Bitmap.Y) + l_NewHeight + 120

st_Login.Move((4 * p_Login_Bitmap.X) + l_NewWidth, &
              st_Login.Y + l_HeightAdj)
sle_Login.Move((4 * p_Login_Bitmap.X) + l_NewWidth + 348, &
               sle_Login.Y + l_HeightAdj)

st_Password.Move((4 * p_Login_Bitmap.X) + l_NewWidth, &
                 st_Password.Y + l_HeightAdj)
sle_Password.Move((4 * p_Login_Bitmap.X) + l_NewWidth + 348, &
                  sle_Password.Y + l_HeightAdj)

cb_Ok.Move((4 * p_Login_Bitmap.X) + l_NewWidth, &
           cb_Ok.Y + l_HeightAdj)
cb_Cancel.Move(((4 * p_Login_Bitmap.X) + l_NewWidth + sle_Login.Width + 348) - cb_Cancel.Width, &
               cb_Cancel.Y + l_HeightAdj)

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

IF OBJCA.WIN.i_Parm.Login_Title <> "" THEN
   Title = OBJCA.WIN.i_Parm.Login_Title
END IF

BackColor             = OBJCA.WIN.i_WindowColor

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   sle_Login.BorderStyle      = StyleShadowBox!
   sle_Password.BorderStyle   = StyleShadowBox!
   p_Login_Bitmap.BorderStyle = StyleShadowBox!
END IF

st_Login.BackColor    = OBJCA.WIN.i_WindowColor
st_Login.TextColor    = OBJCA.WIN.i_WindowTextColor
st_Login.FaceName     = OBJCA.WIN.i_WindowTextFont
st_Login.TextSize     = OBJCA.WIN.i_WindowTextSize

st_Password.BackColor = OBJCA.WIN.i_WindowColor
st_Password.TextColor = OBJCA.WIN.i_WindowTextColor
st_Password.FaceName  = OBJCA.WIN.i_WindowTextFont
st_Password.TextSize  = OBJCA.WIN.i_WindowTextSize

cb_Ok.FaceName        = OBJCA.WIN.i_WindowTextFont
cb_Ok.TextSize        = OBJCA.WIN.i_WindowTextSize

cb_Cancel.FaceName    = OBJCA.WIN.i_WindowTextFont
cb_Cancel.TextSize    = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Based on the new size of the bitmap, resize the window.
//------------------------------------------------------------------

Resize(l_WindowWidth, l_WindowHeight)

//------------------------------------------------------------------
//  Reposition based on the window size.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)

//------------------------------------------------------------------
//  Get the login name from the transaction.
//------------------------------------------------------------------

sle_login.Text = OBJCA.WIN.fu_GetLogin(OBJCA.WIN.i_Parm.Trans_Object)
end event

on w_login.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.p_login_bitmap=create p_login_bitmap
this.st_password=create st_password
this.st_login=create st_login
this.sle_password=create sle_password
this.sle_login=create sle_login
this.Control[]={ this.cb_cancel,&
this.cb_ok,&
this.p_login_bitmap,&
this.st_password,&
this.st_login,&
this.sle_password,&
this.sle_login}
end on

on w_login.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.p_login_bitmap)
destroy(this.st_password)
destroy(this.st_login)
destroy(this.sle_password)
destroy(this.sle_login)
end on

type cb_cancel from commandbutton within w_login
int X=947
int Y=349
int Width=330
int Height=93
int TabOrder=40
string Text=" Cancel"
boolean Cancel=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Login.cb_Cancel
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

//------------------------------------------------------------------
//  If an attempted connection was tryed, return flag for connection
//  failed.  Otherwise, return connection not attempted.
//------------------------------------------------------------------

IF OBJCA.WIN.i_Parm.Attempt_Connection THEN
   IF i_Attempts > 1 THEN
      OBJCA.WIN.i_Parm.Answer = -2
   ELSE
      OBJCA.WIN.i_Parm.Answer = 1
   END IF
ELSE
   OBJCA.WIN.i_Parm.Answer = 1
END IF

Close(Parent)
end event

type cb_ok from commandbutton within w_login
int X=426
int Y=349
int Width=330
int Height=93
int TabOrder=30
string Text=" OK"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Login.cb_OK
//  Event         : Clicked
//  Description   : Validate the login and password. Connect to the
//                  application transaction.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

TRANSACTION l_TransObject
STRING      l_UsrPassword, l_UsrLogin, l_ErrorStrings[]
INTEGER     l_Return

SetPointer(HourGlass!)

//------------------------------------------------------------------
//  Get the login and password.
//------------------------------------------------------------------

l_UsrLogin    = sle_login.text
l_UsrPassword = sle_password.text
l_TransObject = OBJCA.WIN.i_Parm.Trans_Object

//------------------------------------------------------------------
//  Set the login and password into the appropriate location in
//  the transaction object.  This location depends on the database
//  being used.
//------------------------------------------------------------------

l_Return = OBJCA.WIN.fu_SetLogin(l_TransObject, &
                                 l_UsrLogin, l_UsrPassword)

IF l_Return <> -1 THEN

   //---------------------------------------------------------------
   //  If the developer has asked to attempt a database connection,
   //  call f_PO_Connect function to attempt a connection.
   //---------------------------------------------------------------

   IF OBJCA.WIN.i_Parm.Attempt_Connection THEN
      l_Return = OBJCA.WIN.fu_Connect(l_TransObject, FALSE)

      //------------------------------------------------------------
      //  If the connection was successful, return the transaction
      //  object containing the new login and password.
      //------------------------------------------------------------

      IF l_Return = 0 THEN
         OBJCA.WIN.i_Parm.Trans_Object = l_TransObject
         OBJCA.WIN.i_Parm.Answer = 0

      //------------------------------------------------------------
      //  If the connection failed and grace logins have NOT been
      //  exceded, let the user enter a new login/password.  If the
      //  grace logins exceded, put up error message and return.
      //------------------------------------------------------------

      ELSE
         i_Attempts = i_Attempts + 1
         IF i_Attempts <= OBJCA.WIN.i_Parm.Grace_Logins THEN
            sle_login.SetFocus()
            RETURN
         ELSE
	         l_ErrorStrings[1] = "PowerObjects Error"
	         l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	         l_ErrorStrings[3] = GetParent().ClassName()
	         l_ErrorStrings[4] = ClassName()
	         l_ErrorStrings[5] = "Clicked"
            OBJCA.MSG.fu_DisplayMessage("GraceLoginError", 5, &
				                            l_ErrorStrings[])
            OBJCA.WIN.i_Parm.Answer = -2
         END IF
      END IF
   ELSE
      OBJCA.WIN.i_Parm.Trans_Object = l_TransObject
      OBJCA.WIN.i_Parm.Answer = 1
   END IF
ELSE
   OBJCA.WIN.i_Parm.Answer = -1
END IF

Close(Parent)


end event

type p_login_bitmap from picture within w_login
int X=51
int Y=49
int Width=293
int Height=257
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
boolean FocusRectangle=false
boolean OriginalSize=true
end type

type st_password from statictext within w_login
int X=430
int Y=189
int Width=334
int Height=73
boolean Enabled=false
string Text="Password:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_login from statictext within w_login
int X=430
int Y=53
int Width=334
int Height=73
boolean Enabled=false
string Text="Login:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_password from singlelineedit within w_login
int X=778
int Y=181
int Width=499
int Height=81
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
boolean PassWord=true
TextCase TextCase=Lower!
long BackColor=16777215
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event getfocus;//******************************************************************
//  PO Module     : w_Login.sle_Password
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

SelectText(1, LEN(Text))
i_CurrentSLE = THIS
cb_ok.Default = TRUE
end event

type sle_login from singlelineedit within w_login
event pl_keydown pbm_keydown
int X=778
int Y=49
int Width=499
int Height=81
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
TextCase TextCase=Lower!
long BackColor=16777215
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event pl_keydown;//******************************************************************
//  PO Module     : w_Login.sle_Login
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
   sle_password.SetFocus()
END IF
end event

event getfocus;//******************************************************************
//  PO Module     : w_Login.sle_Login
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

