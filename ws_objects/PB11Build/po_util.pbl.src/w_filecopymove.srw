$PBExportHeader$w_filecopymove.srw
$PBExportComments$Window to indicate that a copy or move is processing
forward
global type w_filecopymove from Window
end type
type st_to_file_t from statictext within w_filecopymove
end type
type st_from_file_t from statictext within w_filecopymove
end type
type st_to_file from statictext within w_filecopymove
end type
type st_from_file from statictext within w_filecopymove
end type
type cb_cancel from commandbutton within w_filecopymove
end type
end forward

shared variables

end variables

global type w_filecopymove from Window
int X=485
int Y=620
int Width=1806
int Height=520
boolean TitleBar=true
string Title="Copying..."
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
event po_copymove pbm_custom75
st_to_file_t st_to_file_t
st_from_file_t st_from_file_t
st_to_file st_to_file
st_from_file st_from_file
cb_cancel cb_cancel
end type
global w_filecopymove w_filecopymove

type variables
BOOLEAN	i_CancelCopyMove = FALSE
BOOLEAN               i_CopyMoveInProcess = FALSE

end variables

event po_copymove;//******************************************************************
//  PO Module     : w_FileCopyMove
//  Event         : po_CopyMove
//  Description   : Copies/Moves files.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumFiles
STRING  l_FromFile, l_ToFile

//------------------------------------------------------------------
//  Before each loop, check to see if the user pressed the Cancel
//  button.
//------------------------------------------------------------------

l_NumFiles = UpperBound(OBJCA.WIN.i_Parm.Files[])

FOR l_Idx = 1 TO l_NumFiles
   Yield()
   IF i_CancelCopyMove THEN
      Close(THIS)
   END IF

   l_FromFile = OBJCA.WIN.i_Parm.From_Directory + &
                OBJCA.WIN.i_Parm.Files[l_Idx]
   l_ToFile   = OBJCA.WIN.i_Parm.To_Directory + &
                OBJCA.WIN.i_Parm.Files[l_Idx]
   st_From_File_t.text = UPPER(l_FromFile)
   st_To_File_t.text   = UPPER(l_ToFile)
   IF OBJCA.WIN.i_Parm.Copy_File THEN
      OBJCA.WIN.fu_FileCopy(l_FromFile, l_ToFile)
   ELSE
      OBJCA.WIN.fu_FileMove(l_FromFile, l_ToFile)
   END IF
NEXT

OBJCA.WIN.i_Parm.Answer = 0
Close(THIS)
end event

event open;//******************************************************************
//  PO Module     : w_FileCopyMove
//  Event         : Open
//  Description   : Allows processing before window becomes visible.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/7/98	Beth Byers	Moved the code to copy/move the files into the 
//								activate event.  When the window is not displayed,
//								the Open function to open this window returns an 
//								error (-1) because the window would never finish  
//								opening before it was closed
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.WIN.i_Parm.Answer = -1

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

BackColor                = OBJCA.WIN.i_WindowColor

st_From_File.BackColor   = OBJCA.WIN.i_WindowColor
st_From_File.TextColor   = OBJCA.WIN.i_WindowTextColor
st_From_File.FaceName    = OBJCA.WIN.i_WindowTextFont
st_From_File.TextSize    = OBJCA.WIN.i_WindowTextSize

st_From_File_t.BackColor = OBJCA.WIN.i_WindowColor
st_From_File_t.FaceName  = OBJCA.WIN.i_WindowTextFont
st_From_File_t.TextSize  = OBJCA.WIN.i_WindowTextSize

st_To_File.BackColor     = OBJCA.WIN.i_WindowColor
st_To_File.TextColor     = OBJCA.WIN.i_WindowTextColor
st_To_File.FaceName      = OBJCA.WIN.i_WindowTextFont
st_To_File.TextSize      = OBJCA.WIN.i_WindowTextSize

st_To_File_t.BackColor   = OBJCA.WIN.i_WindowColor
st_To_File_t.FaceName    = OBJCA.WIN.i_WindowTextFont
st_To_File_t.TextSize    = OBJCA.WIN.i_WindowTextSize

cb_cancel.FaceName       = OBJCA.WIN.i_WindowTextFont
cb_cancel.TextSize       = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Set the title and from file text to indicate a move is to be
//  done instead of a copy.
//------------------------------------------------------------------

IF NOT OBJCA.WIN.i_Parm.Copy_File THEN
   Title = "Moving..."
   st_From_File.text = " Moving:"
END IF

//------------------------------------------------------------------
//  Position the window in the center.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)


end event

on w_filecopymove.create
this.st_to_file_t=create st_to_file_t
this.st_from_file_t=create st_from_file_t
this.st_to_file=create st_to_file
this.st_from_file=create st_from_file
this.cb_cancel=create cb_cancel
this.Control[]={this.st_to_file_t,&
this.st_from_file_t,&
this.st_to_file,&
this.st_from_file,&
this.cb_cancel}
end on

on w_filecopymove.destroy
destroy(this.st_to_file_t)
destroy(this.st_from_file_t)
destroy(this.st_to_file)
destroy(this.st_from_file)
destroy(this.cb_cancel)
end on

event activate;//******************************************************************
//  PO Module     : w_FileCopyMove
//  Event         : Activate
//  Description   : Allows processing before window becomes active.
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
//  Copy/Move files.
//------------------------------------------------------------------

IF i_CopyMoveInProcess THEN RETURN

i_CopyMoveInProcess = TRUE

IF OBJCA.WIN.i_Parm.display THEN
   PostEvent("po_CopyMove")
ELSE
   TriggerEvent("po_CopyMove")
END IF
end event

type st_to_file_t from statictext within w_filecopymove
int X=411
int Y=140
int Width=1317
int Height=76
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

type st_from_file_t from statictext within w_filecopymove
int X=411
int Y=52
int Width=1317
int Height=76
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

type st_to_file from statictext within w_filecopymove
int X=64
int Y=140
int Width=338
int Height=76
boolean Enabled=false
boolean DragAuto=true
string Text=" To:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_from_file from statictext within w_filecopymove
int X=64
int Y=52
int Width=338
int Height=76
boolean Enabled=false
boolean DragAuto=true
string Text=" Copying:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_cancel from commandbutton within w_filecopymove
int X=1339
int Y=280
int Width=329
int Height=92
int TabOrder=10
string Text=" Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_FileCopyMove.cb_Cancel
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

i_CancelCopyMove = TRUE

end event

