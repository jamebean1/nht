$PBExportHeader$w_syserror.srw
$PBExportComments$Window to display system error messages
forward
global type w_syserror from Window
end type
type cb_print from commandbutton within w_syserror
end type
type dw_syserror from datawindow within w_syserror
end type
type cb_close from commandbutton within w_syserror
end type
type cb_continue from commandbutton within w_syserror
end type
end forward

shared variables

end variables

global type w_syserror from Window
int X=485
int Y=621
int Width=2145
int Height=1093
boolean TitleBar=true
string Title="System Error"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
cb_print cb_print
dw_syserror dw_syserror
cb_close cb_close
cb_continue cb_continue
end type
global w_syserror w_syserror

type variables
DATAWINDOW	i_DataWindow

LONG		i_CurrentRow
LONG		i_AnchorRow

STRING		i_DateFormat
STRING		i_TimeFormat

end variables

event open;//******************************************************************
//  PO Module     : w_SysError
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

STRING  l_Border, l_Modify
INTEGER l_Idx

OBJCA.WIN.i_Parm.Answer = 1

//------------------------------------------------------------------
//  Get the error from the Error Object.
//------------------------------------------------------------------

dw_syserror.InsertRow(1)
dw_syserror.SetItem(1, "object_name", Error.WindowMenu)
dw_syserror.SetItem(1, "control_name", Error.Object)
dw_syserror.SetItem(1, "event_name", Error.ObjectEvent)
dw_syserror.SetItem(1, "line_number", Error.Line)
dw_syserror.SetItem(1, "error_number", Error.Number)
dw_syserror.SetItem(1, "error_message", Error.Text)

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

IF OBJCA.WIN.i_Parm.Title <> "" THEN
   Title = OBJCA.WIN.i_Parm.Title
END IF

BackColor            = OBJCA.WIN.i_WindowColor
dw_syserror.Modify("datawindow.detail.color=" + String(BackColor))

l_Modify = ""
l_Border = ""
FOR l_Idx = 1 TO 6
   l_Modify    = l_Modify + "text_" + String(l_Idx) + &
                 ".Color='" + &
                 String(OBJCA.WIN.i_WindowTextColor) + "' "
   l_Modify    = l_Modify + "text_" + String(l_Idx) + &
                 ".Background.Color='" + &
                 String(OBJCA.WIN.i_WindowColor) + "' "
   l_Modify    = l_Modify + "text_" + String(l_Idx) + &
                 ".Font.Face='" + &
                 String(OBJCA.WIN.i_WindowTextFont) + "' "
   l_Modify    = l_Modify + "text_" + String(l_Idx) + &
                 ".Font.Height='" + &
                 String(OBJCA.WIN.i_WindowTextSize) + "' "
   l_Border    = l_Border + "#" + String(l_Idx) + ".Border='1' "
NEXT
dw_syserror.Modify(l_Modify)

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   dw_syserror.Modify(l_Border)
END IF

cb_print.FaceName    = OBJCA.WIN.i_WindowTextFont
cb_print.TextSize    = OBJCA.WIN.i_WindowTextSize

cb_continue.FaceName = OBJCA.WIN.i_WindowTextFont
cb_continue.TextSize = OBJCA.WIN.i_WindowTextSize

cb_close.FaceName    = OBJCA.WIN.i_WindowTextFont
cb_close.TextSize    = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Grab the default date and time formats.
//------------------------------------------------------------------

i_DateFormat = OBJCA.MGR.fu_GetDefault("Global", "DateFormat")
i_TimeFormat = OBJCA.MGR.fu_GetDefault("Global", "TimeFormat")

//------------------------------------------------------------------
//  Position the window in the center.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)

end event

on w_syserror.create
this.cb_print=create cb_print
this.dw_syserror=create dw_syserror
this.cb_close=create cb_close
this.cb_continue=create cb_continue
this.Control[]={ this.cb_print,&
this.dw_syserror,&
this.cb_close,&
this.cb_continue}
end on

on w_syserror.destroy
destroy(this.cb_print)
destroy(this.dw_syserror)
destroy(this.cb_close)
destroy(this.cb_continue)
end on

type cb_print from commandbutton within w_syserror
int X=531
int Y=841
int Width=362
int Height=93
int TabOrder=20
string Text=" &Print"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SysError.cb_Print
//  Event         : Clicked
//  Description   : Print the error parameters to the current 
//                  printer.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_String
LONG    l_Job

//------------------------------------------------------------------
//  Open a print job.
//------------------------------------------------------------------

l_Job = PrintOpen(Parent.Title)

//------------------------------------------------------------------
//  Print a title.
//------------------------------------------------------------------

l_String = Parent.Title + " - " + String(NOW(), &
                                         i_DateFormat + i_TimeFormat)
Print(l_Job, l_String)
Print(l_Job, " ")

//------------------------------------------------------------------
//  Print the error values.
//------------------------------------------------------------------

l_String = "Object Name   : " + &
           dw_syserror.GetItemString(1, "object_name")
Print(l_Job, l_String)

l_String = "Control Name  : " + &
           dw_syserror.GetItemString(1, "control_name")
Print(l_Job, l_String)

l_String = "Event Name    : " + &
           dw_syserror.GetItemString(1, "event_name")
Print(l_Job, l_String)

l_String = "Line Number   : " + &
           String(dw_syserror.GetItemNumber(1, "line_number"))
Print(l_Job, l_String)

l_String = "Error Number  : " + &
           String(dw_syserror.GetItemNumber(1, "error_number"))
Print(l_Job, l_String)

l_String = "Error Message : " + &
           dw_syserror.GetItemString(1, "error_message")
Print(l_Job, l_String)

//------------------------------------------------------------------
//  Close the print job and send it to the printer.
//------------------------------------------------------------------

PrintClose(l_Job)

end event

type dw_syserror from datawindow within w_syserror
int X=42
int Y=41
int Width=2030
int Height=749
string DataObject="d_syserror"
boolean Border=false
boolean LiveScroll=true
end type

type cb_close from commandbutton within w_syserror
int X=1418
int Y=841
int Width=631
int Height=93
int TabOrder=30
string Text=" Close &Application"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SysError.cb_Close
//  Event         : Clicked
//  Description   : Return flag indicating the application should
//                  halt.
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
Close(PARENT)

end event

type cb_continue from commandbutton within w_syserror
int X=974
int Y=841
int Width=362
int Height=93
int TabOrder=10
string Text=" &Continue"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SysError.cb_Continue
//  Event         : Clicked
//  Description   : Return flag indicating the application should
//                  continue.
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
Close(PARENT)

end event

