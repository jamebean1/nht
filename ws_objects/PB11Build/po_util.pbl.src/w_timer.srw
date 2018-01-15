$PBExportHeader$w_timer.srw
$PBExportComments$Window to display the results of a timing session
forward
global type w_timer from Window
end type
type cb_printtimes from commandbutton within w_timer
end type
type rb_calls from radiobutton within w_timer
end type
type rb_seq from radiobutton within w_timer
end type
type cb_savetimes from commandbutton within w_timer
end type
type cb_close from commandbutton within w_timer
end type
type dw_calls from datawindow within w_timer
end type
type dw_seq from datawindow within w_timer
end type
type gb_summary from groupbox within w_timer
end type
end forward

global type w_timer from Window
int X=567
int Y=301
int Width=1788
int Height=1309
boolean TitleBar=true
string Title="Timer Report"
long BackColor=12632256
WindowType WindowType=response!
cb_printtimes cb_printtimes
rb_calls rb_calls
rb_seq rb_seq
cb_savetimes cb_savetimes
cb_close cb_close
dw_calls dw_calls
dw_seq dw_seq
gb_summary gb_summary
end type
global w_timer w_timer

type variables
STRING	i_Directory = ""

STRING	i_DateFormat
end variables

event open;//******************************************************************
//  PO Module     : w_Timer
//  Event         : Open
//  Description   : Displays timing information.
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
//  Set the title for the window.
//------------------------------------------------------------------

IF Message.StringParm <> "" THEN
   Title = Message.StringParm
END IF

//------------------------------------------------------------------
//  Grab the default date format.
//------------------------------------------------------------------

i_DateFormat = OBJCA.MGR.fu_GetDefault("Global", "DateFormat")

//------------------------------------------------------------------
//  Loop through the timer values and calculate the intervals and
//  sub-intervals.  Then load the datawindows with the timings.
//------------------------------------------------------------------

OBJCA.TIMER.fu_TimerCalc(dw_seq, dw_calls)

//------------------------------------------------------------------
//  Reposition the window in the center of the screen.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)
end event

on w_timer.create
this.cb_printtimes=create cb_printtimes
this.rb_calls=create rb_calls
this.rb_seq=create rb_seq
this.cb_savetimes=create cb_savetimes
this.cb_close=create cb_close
this.dw_calls=create dw_calls
this.dw_seq=create dw_seq
this.gb_summary=create gb_summary
this.Control[]={ this.cb_printtimes,&
this.rb_calls,&
this.rb_seq,&
this.cb_savetimes,&
this.cb_close,&
this.dw_calls,&
this.dw_seq,&
this.gb_summary}
end on

on w_timer.destroy
destroy(this.cb_printtimes)
destroy(this.rb_calls)
destroy(this.rb_seq)
destroy(this.cb_savetimes)
destroy(this.cb_close)
destroy(this.dw_calls)
destroy(this.dw_seq)
destroy(this.gb_summary)
end on

type cb_printtimes from commandbutton within w_timer
int X=901
int Y=1065
int Width=366
int Height=93
int TabOrder=50
string Text=" &Print Timing"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Timer.cb_PrintTimes
//  Event         : Clicked
//  Description   : Print the timings to the current printer.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF rb_seq.Checked THEN
   dw_seq.SetReDraw(FALSE)
   dw_seq.TitleBar = TRUE
   dw_seq.Title = Parent.Title + " - " + String(Today(), i_DateFormat)
   dw_seq.Print()
   dw_seq.TitleBar = FALSE
   dw_seq.SetReDraw(TRUE)
ELSE
   dw_calls.SetReDraw(FALSE)
   dw_calls.TitleBar = TRUE
   dw_calls.Title = Parent.Title + " - " + String(Today(), i_DateFormat)
   dw_calls.Print()
   dw_calls.TitleBar = FALSE
   dw_calls.SetReDraw(TRUE)
END IF
end event

type rb_calls from radiobutton within w_timer
int X=540
int Y=1025
int Width=261
int Height=73
string Text="By Call"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Timer.rb_Calls
//  Event         : Clicked
//  Description   : Display timing information by the number of
//                  times an interval was called.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

dw_calls.Show()
dw_seq.Hide()
Parent.Width = 1926
end event

type rb_seq from radiobutton within w_timer
int X=83
int Y=1025
int Width=435
int Height=73
string Text="By Sequence"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Timer.rb_Seq
//  Event         : Clicked
//  Description   : Display timing information by sequence.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

dw_seq.Show()
dw_calls.Hide()
Parent.Width = 1788
end event

type cb_savetimes from commandbutton within w_timer
int X=901
int Y=957
int Width=366
int Height=93
int TabOrder=40
string Text=" &Save Timing"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Timer.cb_SaveTimes
//  Event         : Clicked
//  Description   : Save the timings into a file.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF rb_seq.Checked THEN
	dw_seq.SaveAs()
ELSE
	dw_calls.SaveAs()
END IF
end event

type cb_close from commandbutton within w_timer
int X=1335
int Y=1009
int Width=366
int Height=93
int TabOrder=30
string Text="&Close"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Timer.cb_Close
//  Event         : Clicked
//  Description   : Closes the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

Close(PARENT)
end event

type dw_calls from datawindow within w_timer
int X=42
int Y=33
int Width=1802
int Height=841
int TabOrder=10
boolean Visible=false
string DataObject="d_timer_call"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_seq from datawindow within w_timer
int X=42
int Y=33
int Width=1655
int Height=841
int TabOrder=20
string DataObject="d_timer_seq"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean LiveScroll=true
end type

type gb_summary from groupbox within w_timer
int X=37
int Y=929
int Width=810
int Height=229
int TabOrder=60
string Text="Summary"
BorderStyle BorderStyle=StyleLowered!
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

