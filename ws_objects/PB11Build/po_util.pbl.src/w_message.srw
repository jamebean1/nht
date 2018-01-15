$PBExportHeader$w_message.srw
$PBExportComments$Window to edit/view a large text message or comment
forward
global type w_message from Window
end type
type cb_ok_view from commandbutton within w_message
end type
type cb_cancel from commandbutton within w_message
end type
type cb_ok_modify from commandbutton within w_message
end type
type mle_message from multilineedit within w_message
end type
end forward

shared variables

end variables

global type w_message from Window
int X=485
int Y=621
int Width=1491
int Height=865
boolean TitleBar=true
string Title="Message"
long BackColor=12632256
boolean ControlMenu=true
boolean ToolBarVisible=true
WindowType WindowType=response!
cb_ok_view cb_ok_view
cb_cancel cb_cancel
cb_ok_modify cb_ok_modify
mle_message mle_message
end type
global w_message w_message

type variables
BOOLEAN	i_Changes

end variables

event open;//******************************************************************
//  PO Module     : w_Message
//  Event         : Open
//  Description   : Allows processing before window becomes visible.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Initialize the changes flag to FALSE.
//------------------------------------------------------------------

i_Changes = FALSE

//------------------------------------------------------------------
//  Set the message text and the window title.
//------------------------------------------------------------------

Title            = OBJCA.WIN.i_Parm.Message_Title
mle_Message.Text = OBJCA.WIN.i_Parm.Message_Text

//------------------------------------------------------------------
//  If message is for display only, set the appropriate variables
//  and command buttons.
//------------------------------------------------------------------

BackColor             = OBJCA.WIN.i_WindowColor

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   mle_Message.BorderStyle    = StyleShadowBox!
END IF

mle_Message.BackColor = OBJCA.WIN.i_Parm.Back_Color
mle_Message.TextColor = OBJCA.WIN.i_Parm.Text_Color

cb_Ok_Modify.FaceName = OBJCA.WIN.i_WindowTextFont
cb_Ok_Modify.TextSize = OBJCA.WIN.i_WindowTextSize

cb_Ok_View.FaceName   = OBJCA.WIN.i_WindowTextFont
cb_Ok_View.TextSize   = OBJCA.WIN.i_WindowTextSize

cb_Cancel.FaceName    = OBJCA.WIN.i_WindowTextFont
cb_Cancel.TextSize    = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Determine if the message is for read-only.
//------------------------------------------------------------------

IF OBJCA.WIN.i_Parm.Display_Only THEN
   cb_Ok_Modify.Visible    = FALSE
   cb_Cancel.Visible       = FALSE
   mle_Message.DisplayOnly = TRUE
   cb_Ok_View.SetFocus()
ELSE
   mle_Message.TabOrder    = 0
   cb_Ok_View.Visible      = FALSE
   mle_Message.SetFocus()
END IF

//------------------------------------------------------------------
//  Position the window in the center.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)
end event

on w_message.create
this.cb_ok_view=create cb_ok_view
this.cb_cancel=create cb_cancel
this.cb_ok_modify=create cb_ok_modify
this.mle_message=create mle_message
this.Control[]={ this.cb_ok_view,&
this.cb_cancel,&
this.cb_ok_modify,&
this.mle_message}
end on

on w_message.destroy
destroy(this.cb_ok_view)
destroy(this.cb_cancel)
destroy(this.cb_ok_modify)
destroy(this.mle_message)
end on

type cb_ok_view from commandbutton within w_message
int X=554
int Y=601
int Width=330
int Height=93
int TabOrder=40
string Text=" OK"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Message.cb_Ok_View
//  Event         : Clicked
//  Description   : This button is visible when we are in view-only
//                  mode.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

Close(PARENT)
end event

type cb_cancel from commandbutton within w_message
int X=929
int Y=601
int Width=330
int Height=93
int TabOrder=30
string Text=" Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Message.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel any changes made to the message text
//                  and close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

Close(PARENT)

end event

type cb_ok_modify from commandbutton within w_message
int X=174
int Y=601
int Width=330
int Height=93
int TabOrder=20
string Text=" OK"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Message.cb_Ok_Modify
//  Event         : Clicked
//  Description   : If changes to the message text are made, return
//                  changed text and close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF i_Changes THEN
   OBJCA.WIN.i_Parm.Message_Text = mle_Message.Text
END IF

Close(PARENT)
end event

type mle_message from multilineedit within w_message
int X=60
int Y=53
int Width=1331
int Height=489
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
string Pointer="arrow!"
long BackColor=16777215
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;//******************************************************************
//  PO Module     : w_Message.mle_Message
//  Event         : Modified
//  Description   : Sets a flag indicating that a change to the
//                  message has occured.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Set the flag that changes have been made.
//------------------------------------------------------------------

i_Changes = TRUE
end event

