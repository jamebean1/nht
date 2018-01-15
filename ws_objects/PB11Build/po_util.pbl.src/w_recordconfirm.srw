$PBExportHeader$w_recordconfirm.srw
$PBExportComments$Window to allow the user to confirm record copy/moves
forward
global type w_recordconfirm from Window
end type
type cb_no from commandbutton within w_recordconfirm
end type
type cb_yes_to_all from commandbutton within w_recordconfirm
end type
type st_record_t from statictext within w_recordconfirm
end type
type st_record from statictext within w_recordconfirm
end type
type cb_cancel from commandbutton within w_recordconfirm
end type
type cb_yes from commandbutton within w_recordconfirm
end type
end forward

shared variables

end variables

global type w_recordconfirm from Window
int X=558
int Y=581
int Width=1687
int Height=565
boolean TitleBar=true
string Title="Confirm Record"
long BackColor=12632256
boolean ControlMenu=true
boolean ToolBarVisible=true
WindowType WindowType=response!
cb_no cb_no
cb_yes_to_all cb_yes_to_all
st_record_t st_record_t
st_record st_record
cb_cancel cb_cancel
cb_yes cb_yes
end type
global w_recordconfirm w_recordconfirm

type variables



end variables

event open;//******************************************************************
//  PO Module     : w_RecordConfirm
//  Event         : Open
//  Description   : Allows processing before window becomes visible.
//
//  Parameters    : 
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.WIN.i_Parm.Answer = 4

//------------------------------------------------------------------
//  Set the record strings.
//------------------------------------------------------------------

st_Record_t.text = OBJCA.WIN.i_Parm.label

CHOOSE CASE Upper(OBJCA.WIN.i_Parm.action)
   CASE "COPY"
      st_Record.Text = " Copy Record:"
      Title          = "Confirm Record Copy"
   CASE "MOVE"
      st_Record.Text = " Move Record:"
      Title          = "Confirm Record Move"
   CASE "DELETE"
      st_Record.Text = " Delete Record:"
      Title          = "Confirm Record Delete"
END CHOOSE

IF NOT OBJCA.WIN.i_Parm.Multiple THEN
   cb_yes_to_all.Enabled = FALSE
END IF

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

BackColor                     = OBJCA.WIN.i_WindowColor

st_Record.BackColor           = OBJCA.WIN.i_WindowColor
st_Record.TextColor           = OBJCA.WIN.i_WindowTextColor
st_Record.FaceName            = OBJCA.WIN.i_WindowTextFont
st_Record.TextSize            = OBJCA.WIN.i_WindowTextSize

st_Record_t.BackColor         = OBJCA.WIN.i_WindowColor
st_Record_t.FaceName          = OBJCA.WIN.i_WindowTextFont
st_Record_t.TextSize          = OBJCA.WIN.i_WindowTextSize

cb_yes.FaceName               = OBJCA.WIN.i_WindowTextFont
cb_yes.TextSize               = OBJCA.WIN.i_WindowTextSize

cb_yes_to_all.FaceName        = OBJCA.WIN.i_WindowTextFont
cb_yes_to_all.TextSize        = OBJCA.WIN.i_WindowTextSize

cb_no.FaceName                = OBJCA.WIN.i_WindowTextFont
cb_no.TextSize                = OBJCA.WIN.i_WindowTextSize

cb_cancel.FaceName            = OBJCA.WIN.i_WindowTextFont
cb_cancel.TextSize            = OBJCA.WIN.i_WindowTextSize


end event

on w_recordconfirm.create
this.cb_no=create cb_no
this.cb_yes_to_all=create cb_yes_to_all
this.st_record_t=create st_record_t
this.st_record=create st_record
this.cb_cancel=create cb_cancel
this.cb_yes=create cb_yes
this.Control[]={ this.cb_no,&
this.cb_yes_to_all,&
this.st_record_t,&
this.st_record,&
this.cb_cancel,&
this.cb_yes}
end on

on w_recordconfirm.destroy
destroy(this.cb_no)
destroy(this.cb_yes_to_all)
destroy(this.st_record_t)
destroy(this.st_record)
destroy(this.cb_cancel)
destroy(this.cb_yes)
end on

type cb_no from commandbutton within w_recordconfirm
int X=846
int Y=301
int Width=330
int Height=93
int TabOrder=30
string Text=" &No"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_RecordConfirm.cb_No
//  Event         : Clicked
//  Description   : Don't mark record for replacement.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.WIN.i_Parm.Answer = 3
Close(Parent)
end event

type cb_yes_to_all from commandbutton within w_recordconfirm
int X=462
int Y=301
int Width=330
int Height=93
int TabOrder=20
string Text=" Yes to &All"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_RecordConfirm.cb_Yes_To_All
//  Event         : Clicked
//  Description   : Mark all record for replacement.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.WIN.i_Parm.Answer = 2
Close(Parent)
end event

type st_record_t from statictext within w_recordconfirm
int X=572
int Y=53
int Width=988
int Height=125
boolean Enabled=false
string Text="none"
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_record from statictext within w_recordconfirm
int X=65
int Y=53
int Width=467
int Height=77
boolean Enabled=false
boolean DragAuto=true
string Text=" Copy Record:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_cancel from commandbutton within w_recordconfirm
int X=1235
int Y=301
int Width=330
int Height=93
int TabOrder=40
string Text=" &Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_RecordConfirm.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel record move/copy operations.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.WIN.i_Parm.Answer = 4
Close(Parent)
end event

type cb_yes from commandbutton within w_recordconfirm
int X=78
int Y=301
int Width=330
int Height=93
int TabOrder=10
string Text=" &Yes"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_RecordConfirm.cb_Yes
//  Event         : Clicked
//  Description   : Mark record for replacement.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.WIN.i_Parm.Answer = 1
Close(Parent)
end event

