$PBExportHeader$w_fileconfirm.srw
$PBExportComments$Window to confirm file copies or moves
forward
global type w_fileconfirm from Window
end type
type cb_no from commandbutton within w_fileconfirm
end type
type cb_yes_to_all from commandbutton within w_fileconfirm
end type
type st_with_file_t from statictext within w_fileconfirm
end type
type st_replace_file_t from statictext within w_fileconfirm
end type
type st_with_file from statictext within w_fileconfirm
end type
type st_replace_file from statictext within w_fileconfirm
end type
type cb_cancel from commandbutton within w_fileconfirm
end type
type cb_yes from commandbutton within w_fileconfirm
end type
end forward

shared variables

end variables

global type w_fileconfirm from Window
int X=485
int Y=621
int Width=1806
int Height=765
boolean TitleBar=true
string Title="Confirm File Replace"
long BackColor=12632256
boolean ControlMenu=true
boolean ToolBarVisible=true
WindowType WindowType=response!
cb_no cb_no
cb_yes_to_all cb_yes_to_all
st_with_file_t st_with_file_t
st_replace_file_t st_replace_file_t
st_with_file st_with_file
st_replace_file st_replace_file
cb_cancel cb_cancel
cb_yes cb_yes
end type
global w_fileconfirm w_fileconfirm

type variables



end variables

event open;//******************************************************************
//  PO Module     : w_FileConfirm
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
//  Set the file strings.
//------------------------------------------------------------------

st_Replace_File_t.text = OBJCA.WIN.i_Parm.Replace_File
st_With_File_t.text    = OBJCA.WIN.i_Parm.With_File

IF NOT OBJCA.WIN.i_Parm.Multiple THEN
   cb_yes_to_all.Enabled = FALSE
END IF

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

BackColor                   = OBJCA.WIN.i_WindowColor

st_Replace_File.BackColor   = OBJCA.WIN.i_WindowColor
st_Replace_File.TextColor   = OBJCA.WIN.i_WindowTextColor
st_Replace_File.FaceName    = OBJCA.WIN.i_WindowTextFont
st_Replace_File.TextSize    = OBJCA.WIN.i_WindowTextSize

st_Replace_File_t.BackColor = OBJCA.WIN.i_WindowColor
st_Replace_File_t.FaceName  = OBJCA.WIN.i_WindowTextFont
st_Replace_File_t.TextSize  = OBJCA.WIN.i_WindowTextSize

st_With_File.BackColor      = OBJCA.WIN.i_WindowColor
st_With_File.TextColor      = OBJCA.WIN.i_WindowTextColor
st_With_File.FaceName       = OBJCA.WIN.i_WindowTextFont
st_With_File.TextSize       = OBJCA.WIN.i_WindowTextSize

st_With_File_t.BackColor    = OBJCA.WIN.i_WindowColor
st_With_File_t.FaceName     = OBJCA.WIN.i_WindowTextFont
st_With_File_t.TextSize     = OBJCA.WIN.i_WindowTextSize

cb_yes.FaceName             = OBJCA.WIN.i_WindowTextFont
cb_yes.TextSize             = OBJCA.WIN.i_WindowTextSize

cb_yes_to_all.FaceName      = OBJCA.WIN.i_WindowTextFont
cb_yes_to_all.TextSize      = OBJCA.WIN.i_WindowTextSize

cb_no.FaceName              = OBJCA.WIN.i_WindowTextFont
cb_no.TextSize              = OBJCA.WIN.i_WindowTextSize

cb_cancel.FaceName          = OBJCA.WIN.i_WindowTextFont
cb_cancel.TextSize          = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Position the window in the center.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)

end event

on w_fileconfirm.create
this.cb_no=create cb_no
this.cb_yes_to_all=create cb_yes_to_all
this.st_with_file_t=create st_with_file_t
this.st_replace_file_t=create st_replace_file_t
this.st_with_file=create st_with_file
this.st_replace_file=create st_replace_file
this.cb_cancel=create cb_cancel
this.cb_yes=create cb_yes
this.Control[]={ this.cb_no,&
this.cb_yes_to_all,&
this.st_with_file_t,&
this.st_replace_file_t,&
this.st_with_file,&
this.st_replace_file,&
this.cb_cancel,&
this.cb_yes}
end on

on w_fileconfirm.destroy
destroy(this.cb_no)
destroy(this.cb_yes_to_all)
destroy(this.st_with_file_t)
destroy(this.st_replace_file_t)
destroy(this.st_with_file)
destroy(this.st_replace_file)
destroy(this.cb_cancel)
destroy(this.cb_yes)
end on

type cb_no from commandbutton within w_fileconfirm
int X=915
int Y=497
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
//  PO Module     : w_FileConfirm.cb_No
//  Event         : Clicked
//  Description   : Don't mark file for replacement.
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

type cb_yes_to_all from commandbutton within w_fileconfirm
int X=531
int Y=497
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
//  PO Module     : w_FileConfirm.cb_Yes_To_All
//  Event         : Clicked
//  Description   : Mark all files for replacement.
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

type st_with_file_t from statictext within w_fileconfirm
int X=499
int Y=225
int Width=1194
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

type st_replace_file_t from statictext within w_fileconfirm
int X=499
int Y=53
int Width=1194
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

type st_with_file from statictext within w_fileconfirm
int X=65
int Y=225
int Width=412
int Height=77
boolean Enabled=false
boolean DragAuto=true
string Text=" With File:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_replace_file from statictext within w_fileconfirm
int X=65
int Y=53
int Width=412
int Height=77
boolean Enabled=false
boolean DragAuto=true
string Text=" Replace File:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_cancel from commandbutton within w_fileconfirm
int X=1303
int Y=497
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
//  PO Module     : w_FileConfirm.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel file move/copy operations.
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

type cb_yes from commandbutton within w_fileconfirm
int X=147
int Y=497
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
//  PO Module     : w_FileConfirm.cb_Yes
//  Event         : Clicked
//  Description   : Mark file for replacement.
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

