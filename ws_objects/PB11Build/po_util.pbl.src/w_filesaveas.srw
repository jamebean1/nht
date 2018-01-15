$PBExportHeader$w_filesaveas.srw
$PBExportComments$Window to save the contents of a DataWindow to a file
forward
global type w_filesaveas from Window
end type
type rb_psreport from radiobutton within w_filesaveas
end type
type rb_html from radiobutton within w_filesaveas
end type
type lb_directory from listbox within w_filesaveas
end type
type st_current_directory from statictext within w_filesaveas
end type
type cb_cancel from commandbutton within w_filesaveas
end type
type rb_dbase3 from radiobutton within w_filesaveas
end type
type rb_wks from radiobutton within w_filesaveas
end type
type rb_dbase2 from radiobutton within w_filesaveas
end type
type rb_csv from radiobutton within w_filesaveas
end type
type rb_excel from radiobutton within w_filesaveas
end type
type rb_dif from radiobutton within w_filesaveas
end type
type rb_text from radiobutton within w_filesaveas
end type
type rb_wk1 from radiobutton within w_filesaveas
end type
type rb_clipboard from radiobutton within w_filesaveas
end type
type ddlb_drive from dropdownlistbox within w_filesaveas
end type
type cbx_header from checkbox within w_filesaveas
end type
type st_filename from statictext within w_filesaveas
end type
type sle_datawindow from singlelineedit within w_filesaveas
end type
type cb_ok from commandbutton within w_filesaveas
end type
type gb_fileformat from groupbox within w_filesaveas
end type
end forward

global type w_filesaveas from Window
int X=270
int Y=284
int Width=2359
int Height=1320
boolean TitleBar=true
string Title="File Save As"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
rb_psreport rb_psreport
rb_html rb_html
lb_directory lb_directory
st_current_directory st_current_directory
cb_cancel cb_cancel
rb_dbase3 rb_dbase3
rb_wks rb_wks
rb_dbase2 rb_dbase2
rb_csv rb_csv
rb_excel rb_excel
rb_dif rb_dif
rb_text rb_text
rb_wk1 rb_wk1
rb_clipboard rb_clipboard
ddlb_drive ddlb_drive
cbx_header cbx_header
st_filename st_filename
sle_datawindow sle_datawindow
cb_ok cb_ok
gb_fileformat gb_fileformat
end type
global w_filesaveas w_filesaveas

type variables
DATAWINDOW	i_DataWindow

DATASTORE          i_DataStore

BOOLEAN	i_IncludeHeader
STRING		i_CurrentDrive
STRING		i_CurrentDirectory
end variables

event open;//******************************************************************
//  PO Module     : w_SaveRowsAs
//  Event         : Open
//  Description   : Do window processing before the window becomes
//                  visible.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/7/98	Beth Byers	Added i_DataStore as an instance variable and
//								assign the datastore parameter to it.
//  10/7/98 Beth Byers	Use the trim() function when testing if 
//								i_CurrentDirectory is empty to prevent the 
//								DirList function from appending \ to  
//								ST_Current_Directory
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

OBJCA.WIN.i_Parm.Answer    = -1
i_DataWindow       = OBJCA.WIN.i_Parm.DW_Name
i_CurrentDirectory = OBJCA.WIN.i_Parm.Current_Directory
//------------------------------------------------------------------
//  Added the feature for a user to use FileSaveAs with a datastore
//------------------------------------------------------------------
i_DataStore        = OBJCA.WIN.i_Parm.DS_Name

//------------------------------------------------------------------
//  If a directory has not been saved before then use the current
//  working directory.
//------------------------------------------------------------------

IF trim(i_CurrentDirectory) = "" THEN
   i_CurrentDirectory = "*"
END IF

//------------------------------------------------------------------
//  Fill the directory list box with a list of subdirectories in the
//  selected working directory.  Fill the drive drop down list box
//  with available hard drive letters (c:, d:, etc.).
// "i_CurrentDrive" set to null will get all of them.
//------------------------------------------------------------------

LB_Directory.DirList(i_CurrentDirectory, &
                     32784+16, ST_Current_Directory)
DDLB_Drive.DirList(i_CurrentDrive, 16384)
DDLB_Drive.DirSelect(i_CurrentDrive)
LB_Directory.DirList(i_CurrentDirectory, &
                     32784, ST_Current_Directory)

//------------------------------------------------------------------
//  Save off the current drive from current directory text string.
//------------------------------------------------------------------

i_CurrentDrive  = "[-" + Mid(ST_Current_Directory.Text, 1, 1) + "-]"
DDLB_Drive.Text = i_CurrentDrive

//------------------------------------------------------------------
//  Set focus to the file name field and cleanup.
//------------------------------------------------------------------

sle_DataWindow.SetFocus()

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

BackColor = OBJCA.WIN.i_WindowColor

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   sle_DataWindow.BorderStyle = StyleShadowBox!
   ddlb_drive.BorderStyle     = StyleShadowBox!
   lb_directory.BorderStyle   = StyleShadowBox!
   rb_clipboard.BorderStyle   = StyleBox!
   rb_csv.BorderStyle         = StyleBox!
   rb_dbase2.BorderStyle      = StyleBox!
   rb_dbase3.BorderStyle      = StyleBox!
   rb_dif.BorderStyle         = StyleBox!
   rb_excel.BorderStyle       = StyleBox!
   rb_text.BorderStyle        = StyleBox!
   rb_wk1.BorderStyle         = StyleBox!
   rb_wks.BorderStyle         = StyleBox!
	rb_html.BorderStyle        = StyleBox!
	rb_psreport.BorderStyle    = StyleBox!
   cbx_header.BorderStyle     = StyleBox!
   gb_FileFormat.BorderStyle  = StyleBox!
END IF

st_FileName.BackColor         = OBJCA.WIN.i_WindowColor
st_FileName.TextColor         = OBJCA.WIN.i_WindowTextColor
st_FileName.FaceName          = OBJCA.WIN.i_WindowTextFont
st_FileName.TextSize          = OBJCA.WIN.i_WindowTextSize

st_Current_Directory.BackColor= OBJCA.WIN.i_WindowColor
st_Current_Directory.TextColor= OBJCA.WIN.i_WindowTextColor
st_Current_Directory.FaceName = OBJCA.WIN.i_WindowTextFont

gb_FileFormat.BackColor       = OBJCA.WIN.i_WindowColor
gb_FileFormat.TextColor       = OBJCA.WIN.i_WindowTextColor
gb_FileFormat.FaceName        = OBJCA.WIN.i_WindowTextFont
gb_FileFormat.TextSize        = OBJCA.WIN.i_WindowTextSize

rb_clipboard.BackColor        = OBJCA.WIN.i_WindowColor
rb_clipboard.TextColor        = OBJCA.WIN.i_WindowTextColor
rb_clipboard.FaceName         = OBJCA.WIN.i_WindowTextFont
rb_clipboard.TextSize         = OBJCA.WIN.i_WindowTextSize

rb_csv.BackColor              = OBJCA.WIN.i_WindowColor
rb_csv.TextColor              = OBJCA.WIN.i_WindowTextColor
rb_csv.FaceName               = OBJCA.WIN.i_WindowTextFont
rb_csv.TextSize               = OBJCA.WIN.i_WindowTextSize

rb_dbase2.BackColor           = OBJCA.WIN.i_WindowColor
rb_dbase2.TextColor           = OBJCA.WIN.i_WindowTextColor
rb_dbase2.FaceName            = OBJCA.WIN.i_WindowTextFont
rb_dbase2.TextSize            = OBJCA.WIN.i_WindowTextSize

rb_dbase3.BackColor            = OBJCA.WIN.i_WindowColor
rb_dbase3.TextColor            = OBJCA.WIN.i_WindowTextColor
rb_dbase3.FaceName             = OBJCA.WIN.i_WindowTextFont
rb_dbase3.TextSize             = OBJCA.WIN.i_WindowTextSize

rb_dif.BackColor               = OBJCA.WIN.i_WindowColor
rb_dif.TextColor               = OBJCA.WIN.i_WindowTextColor
rb_dif.FaceName                = OBJCA.WIN.i_WindowTextFont
rb_dif.TextSize                = OBJCA.WIN.i_WindowTextSize

rb_excel.BackColor             = OBJCA.WIN.i_WindowColor
rb_excel.TextColor             = OBJCA.WIN.i_WindowTextColor
rb_excel.FaceName              = OBJCA.WIN.i_WindowTextFont
rb_excel.TextSize              = OBJCA.WIN.i_WindowTextSize

rb_text.BackColor              = OBJCA.WIN.i_WindowColor
rb_text.TextColor              = OBJCA.WIN.i_WindowTextColor
rb_text.FaceName               = OBJCA.WIN.i_WindowTextFont
rb_text.TextSize               = OBJCA.WIN.i_WindowTextSize

rb_wk1.BackColor               = OBJCA.WIN.i_WindowColor
rb_wk1.TextColor               = OBJCA.WIN.i_WindowTextColor
rb_wk1.FaceName                = OBJCA.WIN.i_WindowTextFont
rb_wk1.TextSize                = OBJCA.WIN.i_WindowTextSize

rb_wks.BackColor               = OBJCA.WIN.i_WindowColor
rb_wks.TextColor               = OBJCA.WIN.i_WindowTextColor
rb_wks.FaceName                = OBJCA.WIN.i_WindowTextFont
rb_wks.TextSize                = OBJCA.WIN.i_WindowTextSize

rb_html.BackColor              = OBJCA.WIN.i_WindowColor
rb_html.TextColor              = OBJCA.WIN.i_WindowTextColor
rb_html.FaceName               = OBJCA.WIN.i_WindowTextFont
rb_html.TextSize               = OBJCA.WIN.i_WindowTextSize

rb_psreport.BackColor          = OBJCA.WIN.i_WindowColor
rb_psreport.TextColor          = OBJCA.WIN.i_WindowTextColor
rb_psreport.FaceName           = OBJCA.WIN.i_WindowTextFont
rb_psreport.TextSize           = OBJCA.WIN.i_WindowTextSize

cbx_header.BackColor           = OBJCA.WIN.i_WindowColor
cbx_header.TextColor           = OBJCA.WIN.i_WindowTextColor
cbx_header.FaceName            = OBJCA.WIN.i_WindowTextFont
cbx_header.TextSize            = OBJCA.WIN.i_WindowTextSize

cb_Ok.FaceName                 = OBJCA.WIN.i_WindowTextFont
cb_Ok.TextSize                 = OBJCA.WIN.i_WindowTextSize

cb_Cancel.FaceName             = OBJCA.WIN.i_WindowTextFont
cb_Cancel.TextSize             = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Center the window in the middle of the screen.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)
end event

on w_filesaveas.create
this.rb_psreport=create rb_psreport
this.rb_html=create rb_html
this.lb_directory=create lb_directory
this.st_current_directory=create st_current_directory
this.cb_cancel=create cb_cancel
this.rb_dbase3=create rb_dbase3
this.rb_wks=create rb_wks
this.rb_dbase2=create rb_dbase2
this.rb_csv=create rb_csv
this.rb_excel=create rb_excel
this.rb_dif=create rb_dif
this.rb_text=create rb_text
this.rb_wk1=create rb_wk1
this.rb_clipboard=create rb_clipboard
this.ddlb_drive=create ddlb_drive
this.cbx_header=create cbx_header
this.st_filename=create st_filename
this.sle_datawindow=create sle_datawindow
this.cb_ok=create cb_ok
this.gb_fileformat=create gb_fileformat
this.Control[]={this.rb_psreport,&
this.rb_html,&
this.lb_directory,&
this.st_current_directory,&
this.cb_cancel,&
this.rb_dbase3,&
this.rb_wks,&
this.rb_dbase2,&
this.rb_csv,&
this.rb_excel,&
this.rb_dif,&
this.rb_text,&
this.rb_wk1,&
this.rb_clipboard,&
this.ddlb_drive,&
this.cbx_header,&
this.st_filename,&
this.sle_datawindow,&
this.cb_ok,&
this.gb_fileformat}
end on

on w_filesaveas.destroy
destroy(this.rb_psreport)
destroy(this.rb_html)
destroy(this.lb_directory)
destroy(this.st_current_directory)
destroy(this.cb_cancel)
destroy(this.rb_dbase3)
destroy(this.rb_wks)
destroy(this.rb_dbase2)
destroy(this.rb_csv)
destroy(this.rb_excel)
destroy(this.rb_dif)
destroy(this.rb_text)
destroy(this.rb_wk1)
destroy(this.rb_clipboard)
destroy(this.ddlb_drive)
destroy(this.cbx_header)
destroy(this.st_filename)
destroy(this.sle_datawindow)
destroy(this.cb_ok)
destroy(this.gb_fileformat)
end on

type rb_psreport from radiobutton within w_filesaveas
int X=608
int Y=696
int Width=384
int Height=72
string Text="&PS Report"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_PSReport
//  Event         : Clicked
//  Description   : Process PSReport type.
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
//  Save the datawindow rows as a PSReport file.  If a file name
//  already exists in the field, use the current name with a new
//  extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".psr"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "psr"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.psr"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_html from radiobutton within w_filesaveas
int X=101
int Y=696
int Width=457
int Height=72
string Text="&HTML Table"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_HTML
//  Event         : Clicked
//  Description   : Process HTML table type.
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
//  Save the datawindow rows as an HTML table file.  If a file
//  name already exists in the field, use the current name with a
//  new extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".htm"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "htm"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.htm"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type lb_directory from listbox within w_filesaveas
int X=1321
int Y=112
int Width=919
int Height=776
int TabOrder=120
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long BackColor=16777215
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event selectionchanged;//******************************************************************
//  PO Module     : w_SaveRowsAs.LB_Directory
//  Event         : SelectionChanged
//  Description   : Fill the list box with files from the current
//                  working directory.
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
//  Use the newly selected directory to refill the directory list
//  box with new subdirectories.
//------------------------------------------------------------------

LB_Directory.DirSelect(i_CurrentDirectory)
LB_Directory.DirList(i_CurrentDirectory, &
                     32784, ST_Current_Directory)

sle_DataWindow.SetFocus()
end event

type st_current_directory from statictext within w_filesaveas
int X=1349
int Y=44
int Width=901
int Height=64
boolean Enabled=false
string Text="<Current Directory>"
long TextColor=8388608
long BackColor=12632256
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_cancel from commandbutton within w_filesaveas
int X=1911
int Y=1068
int Width=329
int Height=92
int TabOrder=150
string Text=" Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel the save as operation.
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

type rb_dbase3 from radiobutton within w_filesaveas
int X=608
int Y=608
int Width=393
int Height=72
int TabOrder=100
string Text="dBASE &3"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_DBase3
//  Event         : Clicked
//  Description   : Process DBase 3 type.
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
//  Save the datawindow rows as a Dbase 3 file.  If a file name
//  already exists in the field, use the current name with a new
//  extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".dbf"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "dbf"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.dbf"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_wks from radiobutton within w_filesaveas
int X=608
int Y=416
int Width=603
int Height=72
int TabOrder=80
string Text="Lotus 1-2-3 WK&S"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_WKS
//  Event         : Clicked
//  Description   : Process WKS type.
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
//  Save the datawindow rows as a Lotus 1-2-3 WKS spreadsheet file.  If
//  a file name already exists in the field, use the current name
//  with a new extension.
//------------------------------------------------------------------

IF sle_Datawindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".wks"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "wks"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.wks"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_dbase2 from radiobutton within w_filesaveas
int X=608
int Y=512
int Width=393
int Height=72
int TabOrder=90
string Text="dBASE &2"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_DBase2
//  Event         : Clicked
//  Description   : Process DBase 2 type.
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
//  Save the datawindow rows as a Dbase 2 file.  If a file name
//  already exists in the field, use the current name with a new
//  extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".dbf"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "dbf"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.dbf"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_csv from radiobutton within w_filesaveas
int X=101
int Y=784
int Width=901
int Height=72
int TabOrder=60
string Text="Comma Separated &Values"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_CSV
//  Event         : Clicked
//  Description   : Process CSV type.
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
//  Save the datawindow rows as a comma separated text file.  If a
//  file name already exists in the field, use the current name with
//  a new extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".csv"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "csv"
   END IF
ELSE
   sle_Datawindow.Text = "untitled.csv"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_excel from radiobutton within w_filesaveas
int X=101
int Y=608
int Width=379
int Height=72
int TabOrder=50
string Text="&Excel"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_Excel
//  Event         : Clicked
//  Description   : Process EXCEL type.
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
//  Save the datawindow rows as an Excel spreadsheet file.  If a
//  file name already exists in the field, use the current name with
//  a new extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".xls"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "xls"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.xls"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_dif from radiobutton within w_filesaveas
int X=101
int Y=512
int Width=379
int Height=72
int TabOrder=40
string Text="&DIF"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_DIF
//  Event         : Clicked
//  Description   : Process DIF type.
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
//  Save the DataWindow rows as a DIF file.  If a file name already
//  exists in the field, use the current name with a new extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".dif"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "dif"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.dif"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_text from radiobutton within w_filesaveas
int X=101
int Y=416
int Width=379
int Height=72
int TabOrder=30
string Text="&Text"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_Text
//  Event         : Clicked
//  Description   : Process FILE type.
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
//  Save the DataWindow rows as a text file.  If a file name already
//  exists in the field, use the current name with a new extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".txt"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "txt"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.txt"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_wk1 from radiobutton within w_filesaveas
int X=608
int Y=328
int Width=594
int Height=72
int TabOrder=70
string Text="Lotus 1-2-3 WK&1"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_WK1
//  Event         : Clicked
//  Description   : Process WK1 type.
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
//  Save the datawindow rows as a Lotus 1-2-3 WK1 spreadsheet
//  file.  If  a file name already exists in the field, use the
//  current name with a new extension.
//------------------------------------------------------------------

IF sle_DataWindow.Text <> "" THEN
   IF POS(sle_DataWindow.Text, ".") = 0 THEN
      sle_DataWindow.Text = sle_DataWindow.Text + ".wk1"
   ELSE
      sle_DataWindow.Text = Mid(sle_DataWindow.Text, 1, &
                            Pos(sle_DataWindow.Text, ".")) + "wk1"
   END IF
ELSE
   sle_DataWindow.Text = "untitled.wk1"
   sle_DataWindow.SelectText(1, 8)
END IF

sle_DataWindow.SetFocus()
end event

type rb_clipboard from radiobutton within w_filesaveas
int X=101
int Y=324
int Width=421
int Height=72
int TabOrder=20
string Text="C&lipboard"
BorderStyle BorderStyle=StyleLowered!
boolean Checked=true
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.RB_ClipBoard
//  Event         : Clicked
//  Description   : Process CLIPBOARD type.
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
//  Save the datawindow rows to the clipboard.  Since there is no
//  file involved, blank the file name field.
//------------------------------------------------------------------

sle_DataWindow.Text = ""
sle_DataWindow.SetFocus()
end event

type ddlb_drive from dropdownlistbox within w_filesaveas
int X=1326
int Y=920
int Width=910
int Height=280
int TabOrder=130
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
long BackColor=16777215
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event selectionchanged;//******************************************************************
//  PO Module     : w_SaveRowsAs.DDLB_Drive
//  Event         : SelectionChanged
//  Description   : Select a new drive.
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
//  Use the newly selected drive to refill the directory list box.
//------------------------------------------------------------------

DDLB_Drive.DirSelect(i_CurrentDrive)

i_CurrentDirectory = i_CurrentDrive + "*"
LB_Directory.DirList(i_CurrentDirectory, &
                     32784, ST_Current_Directory)

sle_DataWindow.SetFocus()
end event

type cbx_header from checkbox within w_filesaveas
int X=101
int Y=932
int Width=1129
int Height=72
int TabOrder=110
string Text="Include Column Labels"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.CBX_Header
//  Event         : Clicked
//  Description   : If marked, save the column headers with the
//                  data.
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
//  Check the box for saving the headers.
//------------------------------------------------------------------

i_IncludeHeader = CBX_Header.Checked

sle_DataWindow.SetFocus()
end event

type st_filename from statictext within w_filesaveas
int X=69
int Y=48
int Width=1166
int Height=60
boolean Enabled=false
string Text="File Name:"
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_datawindow from singlelineedit within w_filesaveas
int X=59
int Y=116
int Width=1175
int Height=84
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
long BackColor=16777215
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_ok from commandbutton within w_filesaveas
int X=1321
int Y=1068
int Width=329
int Height=92
int TabOrder=140
string Text=" OK"
boolean Default=true
boolean Cancel=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_SaveRowsAs.cb_OK
//  Event         : Clicked
//  Description   : Save the datawindow contents in the selected
//                  file format.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Answer
STRING  l_File, l_ErrorStrings[]

IF sle_DataWindow.Text = "" AND NOT RB_ClipBoard.Checked THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = GetParent().ClassName()
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "Clicked"
   OBJCA.MSG.fu_DisplayMessage("FileMissingError", 5, l_ErrorStrings[])
   RETURN
END IF

//------------------------------------------------------------------
//  If a file name is given then save the DataWindow rows in the
//  selected file format.
//------------------------------------------------------------------

IF Mid(ST_Current_Directory.Text, &
       Len(ST_Current_Directory.Text), 1) = "\" THEN
   l_File = ST_Current_Directory.Text + sle_DataWindow.Text
ELSE
   l_File = ST_Current_Directory.Text + "\" + sle_DataWindow.Text
END IF

IF FileExists(l_File) AND NOT RB_ClipBoard.Checked THEN
	l_ErrorStrings[1] = "PowerObjects Prompt"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = GetParent().ClassName()
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "Clicked"
   l_ErrorStrings[6] = l_File
   l_Answer =  OBJCA.MSG.fu_DisplayMessage("FileExists", 6, &
	                                        l_ErrorStrings[])
   IF l_Answer = 2 THEN
      RETURN
   END IF
END IF

IF IsValid(i_DataWindow) THEN
	IF RB_ClipBoard.Checked THEN
   	l_Answer = i_DataWindow.SaveAs("", Clipboard!, i_IncludeHeader)
	ELSEIF RB_Text.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, Text!, i_IncludeHeader)
	ELSEIF RB_DIF.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, DIF!, i_IncludeHeader)
	ELSEIF RB_Excel.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, Excel!, i_IncludeHeader)
	ELSEIF RB_CSV.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, CSV!, i_IncludeHeader)
	ELSEIF RB_WK1.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, WK1!, i_IncludeHeader)
	ELSEIF RB_WKS.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, WKS!, i_IncludeHeader)
	ELSEIF RB_DBase2.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, dBASE2!, i_IncludeHeader)
	ELSEIF RB_DBase3.Checked THEN
	   l_Answer = i_DataWindow.SaveAs(l_File, dBASE3!, i_IncludeHeader)
	ELSEIF RB_HTML.Checked THEN
		l_Answer = i_DataWindow.SaveAs(l_File, HTMLTable!, i_IncludeHeader)
	ELSEIF RB_PSReport.Checked THEN
		l_Answer = i_DataWindow.SaveAs(l_File, PSReport!, i_IncludeHeader)
	END IF
END IF

IF IsValid(i_DataStore) THEN
	IF RB_ClipBoard.Checked THEN
   	l_Answer = i_DataStore.SaveAs("", Clipboard!, i_IncludeHeader)
	ELSEIF RB_Text.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, Text!, i_IncludeHeader)
	ELSEIF RB_DIF.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, DIF!, i_IncludeHeader)
	ELSEIF RB_Excel.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, Excel!, i_IncludeHeader)
	ELSEIF RB_CSV.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, CSV!, i_IncludeHeader)
	ELSEIF RB_WK1.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, WK1!, i_IncludeHeader)
	ELSEIF RB_WKS.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, WKS!, i_IncludeHeader)
	ELSEIF RB_DBase2.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, dBASE2!, i_IncludeHeader)
	ELSEIF RB_DBase3.Checked THEN
	   l_Answer = i_DataStore.SaveAs(l_File, dBASE3!, i_IncludeHeader)
	ELSEIF RB_HTML.Checked THEN
		l_Answer = i_DataStore.SaveAs(l_File, HTMLTable!, i_IncludeHeader)
	ELSEIF RB_PSReport.Checked THEN
		l_Answer = i_DataStore.SaveAs(l_File, PSReport!, i_IncludeHeader)
	END IF
END IF

//---------------------------------------------------------------
//  Save the current directory in the PCCA structure for the next
//  time this window is opened.
//---------------------------------------------------------------

IF l_Answer = 1 THEN
   OBJCA.WIN.i_Parm.Answer = 0
END IF

OBJCA.WIN.i_Parm.Current_Directory = ST_Current_Directory.Text
Close(PARENT)

end event

type gb_fileformat from groupbox within w_filesaveas
int X=59
int Y=240
int Width=1175
int Height=648
string Text="File Format"
BorderStyle BorderStyle=StyleLowered!
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

