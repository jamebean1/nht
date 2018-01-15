$PBExportHeader$w_performance_parms.srw
$PBExportComments$Used to gather parameters similar to the Performance Statistics reports.
forward
global type w_performance_parms from w_response_std
end type
type cb_cancel from commandbutton within w_performance_parms
end type
type cb_ok from commandbutton within w_performance_parms
end type
type b_calendar_from from commandbutton within w_performance_parms
end type
type b_calendar_to from commandbutton within w_performance_parms
end type
type st_report_subject from statictext within w_performance_parms
end type
type rb_owner from radiobutton within w_performance_parms
end type
type rb_takenby from radiobutton within w_performance_parms
end type
type dw_user_list from u_outliner_std within w_performance_parms
end type
type gb_report_by from groupbox within w_performance_parms
end type
type em_from from editmask within w_performance_parms
end type
type em_to from editmask within w_performance_parms
end type
type st_from from statictext within w_performance_parms
end type
type st_to from statictext within w_performance_parms
end type
type ddlb_date from dropdownlistbox within w_performance_parms
end type
type gb_date_range from groupbox within w_performance_parms
end type
end forward

global type w_performance_parms from w_response_std
integer width = 2190
integer height = 1208
string title = "Report Parameters"
cb_cancel cb_cancel
cb_ok cb_ok
b_calendar_from b_calendar_from
b_calendar_to b_calendar_to
st_report_subject st_report_subject
rb_owner rb_owner
rb_takenby rb_takenby
dw_user_list dw_user_list
gb_report_by gb_report_by
em_from em_from
em_to em_to
st_from st_from
st_to st_to
ddlb_date ddlb_date
gb_date_range gb_date_range
end type
global w_performance_parms w_performance_parms

type variables
BOOLEAN	i_bOK

INTEGER	i_nListBoxIndex

DATE		i_dFromDate
DATE		i_dToDate

DATETIME i_dtStartDate
DATETIME i_dtEndDate

STRING	i_cReportBy
STRING	i_cSubjectType
STRING	i_cSubjectID
STRING	i_cWindowTitle

S_REPORT_PARMS	is_ReportParms
end variables

forward prototypes
public subroutine fw_calcdaterange ()
end prototypes

public subroutine fw_calcdaterange ();/*****************************************************************************************
   Function:   fw_calcdaterange
   Purpose:    Calculate the date range specified on the window.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/08/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nMonth, l_nYear, l_nDayNumber
DATE		l_dToday, l_dStartDate, l_dEndDate
TIME		l_tStartOfDay, l_tEndOfDay

l_dToday = Today()
l_nMonth = Month (l_dToday)
l_nYear = Year (l_dToday)
l_tStartOfDay = Time ('00:00:00.000')
l_tEndOfDay = Time ('23:59:59.999')

CHOOSE CASE i_nListBoxIndex
	CASE 1	// Year To Date
		i_dtStartDate = DATETIME (Date ('01-01-' + STRING (l_nYear)), l_tStartOfDay)
		i_dtEndDate = DATETIME (l_dToday, l_tEndOfDay)
		
	CASE 2	// Month To Date
		i_dtStartDate = DATETIME (Date (STRING (l_nMonth) + '-01-' + STRING (l_nYear)), l_tStartOfDay)
		i_dtEndDate = DATETIME (l_dToday, l_tEndOfDay)
		
	CASE 3	// This Week
		l_nDayNumber = DAYNUMBER (l_dToday)
		l_dStartDate = RelativeDate (l_dToday, (l_nDayNumber * -1))
		i_dtStartDate = DATETIME (l_dStartDate, l_tStartOfDay)
		i_dtEndDate = DATETIME (l_dToday, l_tEndOfDay)
		
	CASE 4	// Today
		i_dtStartDate = DATETIME (l_dToday, l_tStartOfDay)
		i_dtEndDate = DATETIME (l_dToday, l_tEndOfDay)
		
	CASE 5	// Custom Range
		em_from.GetData (l_dStartDate)
		em_to.GetData (l_dEndDate)
		i_dtStartDate = DATETIME (l_dStartDate, l_tStartOfDay)
		i_dtEndDate = DATETIME (l_dEndDate, l_tEndOfDay)
		
END CHOOSE
end subroutine

on w_performance_parms.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.b_calendar_from=create b_calendar_from
this.b_calendar_to=create b_calendar_to
this.st_report_subject=create st_report_subject
this.rb_owner=create rb_owner
this.rb_takenby=create rb_takenby
this.dw_user_list=create dw_user_list
this.gb_report_by=create gb_report_by
this.em_from=create em_from
this.em_to=create em_to
this.st_from=create st_from
this.st_to=create st_to
this.ddlb_date=create ddlb_date
this.gb_date_range=create gb_date_range
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.b_calendar_from
this.Control[iCurrent+4]=this.b_calendar_to
this.Control[iCurrent+5]=this.st_report_subject
this.Control[iCurrent+6]=this.rb_owner
this.Control[iCurrent+7]=this.rb_takenby
this.Control[iCurrent+8]=this.dw_user_list
this.Control[iCurrent+9]=this.gb_report_by
this.Control[iCurrent+10]=this.em_from
this.Control[iCurrent+11]=this.em_to
this.Control[iCurrent+12]=this.st_from
this.Control[iCurrent+13]=this.st_to
this.Control[iCurrent+14]=this.ddlb_date
this.Control[iCurrent+15]=this.gb_date_range
end on

on w_performance_parms.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.b_calendar_from)
destroy(this.b_calendar_to)
destroy(this.st_report_subject)
destroy(this.rb_owner)
destroy(this.rb_takenby)
destroy(this.dw_user_list)
destroy(this.gb_report_by)
destroy(this.em_from)
destroy(this.em_to)
destroy(this.st_from)
destroy(this.st_to)
destroy(this.ddlb_date)
destroy(this.gb_date_range)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//  Event:   pc_setoptions
//  Purpose: To set User Object options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  08/08/01 M. Caruso   Created.
//***********************************************************************************************

STRING l_cStringDate, l_cSuperLogin, l_cDeptID, l_cDateParm
LONG l_nDeptRow, l_nRtn, l_nRow

i_cWindowTitle = Message.StringParm
THIS.Title = i_cWindowTitle + ' Parameters'

// Set the options for dw_user_list level 1
dw_user_list.fu_HLRetrieveOptions (1, &
		"smallminus.bmp", &
		"smallplus.bmp", &
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		" ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept", & 
		"cusfocus.cusfocus_user_dept.active <> 'N'", & 
		dw_user_list.c_KeyString )

// Set the options for dw_user_list level 2
dw_user_list.fu_HLRetrieveOptions (2, &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.user_id", & 
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user", & 
		"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
		"cusfocus.cusfocus_user.active <> 'N'", & 
		dw_user_list.c_KeyString + dw_user_list.c_BMPFromColumn)
		
dw_user_list.fu_HLCreate (SQLCA, 2)

// Set default for date drop down
i_nListBoxIndex = 4
ddlb_Date.SelectItem (i_nListBoxIndex)

// Set rb_takenby to checked
rb_takenby.Checked = TRUE
rb_owner.Checked = FALSE
i_cReportBy = "T"
end event

event pc_closequery;call super::pc_closequery;/*****************************************************************************************
   Event:      pc_closequery
   Purpose:    Perform final window processing and determine if Close process should
					continue.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/08/01 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cStartDate, l_cEndDate, l_cBlankDate = '00/00/0000'

IF i_bOK THEN
	
	l_cStartDate = em_from.Text
	l_cEndDate = em_to.Text
	
	// validate subject selection
	IF i_cSubjectType = '' THEN
		
		MessageBox (gs_appname, 'You must select a subject from the list.')
		Error.i_FWError = c_Fatal
		RETURN 0
		
	END IF
	
	// validate custom date ranges
	IF i_nListBoxIndex = 5 THEN
		
		// if a custom date range is specified and either date is not set, notify the user
		IF l_cStartDate = l_cBlankDate THEN
			
			IF l_cEndDate = l_cBlankDate THEN
				MessageBox (gs_appname, 'You must specify start and end dates for a custom date range.')
			ELSE
				MessageBox (gs_appname, 'You must specify a start date for a custom date range.')
			END IF
			Error.i_FWError = c_Fatal
			em_from.SetFocus ()
			RETURN 0
			
		ELSE
			
			IF l_cEndDate = l_cBlankDate THEN
		
				// if a custom date range is specified and either date is not set, notify the user
				MessageBox (gs_appname, 'You must specify an end date for a custom date range.')
				Error.i_FWError = c_Fatal
				em_to.SetFocus ()
				RETURN 0
				
			END IF
			
		END IF
		
	END IF
		
	// determine the specified date range
	fw_CalcDateRange ()
	
	// set the return values based on the settings in the window.
	is_ReportParms.string_parm1 = i_cSubjectType
	is_ReportParms.string_parm2  = i_cSubjectID
	is_ReportParms.string_parm3    = i_cReportBy
	is_ReportParms.date_parm1   = i_dtStartDate
	is_ReportParms.date_parm2     = i_dtEndDate
	
ELSE
	
	// set blank return values
	is_ReportParms.string_parm1 = ''
	is_ReportParms.string_parm2   = ''
	is_ReportParms.string_parm2    = ''
	SetNull (is_ReportParms.date_parm1)
	SetNull (is_ReportParms.date_parm2)
	
END IF
end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Pass the return values via Message.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/08/01 M. Caruso    Created.
*****************************************************************************************/

Message.PowerObjectParm = is_ReportParms
end event

type cb_cancel from commandbutton within w_performance_parms
integer x = 1691
integer y = 964
integer width = 411
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the Cancel button

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/08/01 M. Caruso    Created.
*****************************************************************************************/

i_bOK = FALSE
Close (PARENT)
end event

type cb_ok from commandbutton within w_performance_parms
integer x = 1202
integer y = 964
integer width = 411
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the OK button

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/08/01 M. Caruso    Created.
*****************************************************************************************/

DATE l_dStartDate, l_dEndDate
BOOLEAN	l_bBadDate = FALSE

IF i_nListBoxIndex = 5 THEN // Date Range specified

	l_dStartDate = DATE(em_from.Text)
	l_dEndDate = DATE(em_to.Text)
	
	IF YEAR(l_dStartDate) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid start date.')
		em_from.SetFocus()
		l_bBadDate = TRUE
		
	ELSEIF YEAR(l_dEndDate) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid end date.')
		em_to.SetFocus()
		l_bBadDate = TRUE
		
	END IF
	
END IF

IF l_bBadDate THEN
	
	RETURN
	
ELSE
	
	i_bOK = TRUE
	Close (PARENT)

END IF


end event

type b_calendar_from from commandbutton within w_performance_parms
integer x = 1943
integer y = 632
integer width = 110
integer height = 80
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  08/08/01 M. Caruso   Created.
//  08/09/01 M. Caruso   Corrected placement of pop-up calendar.  Account for to-date not set.
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = PARENT.X + THIS.X
l_nY = PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX )
l_cY = String( l_nY + l_nHeight )

l_cCalendarDate = em_from.Text
IF l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dFromDate = l_dtCalendarDate

// Validate the value against the TO field
IF (em_to.Text <> '00/00/0000') AND (i_dToDate < i_dFromDate) THEN
	
	messagebox(gs_AppName,'From Date must be less than To Date')
	em_from.SetFocus()
	
ELSE

	//Add the date to the datawindow
	em_from.Text = string(l_dtCalendarDate)
	
	//Move the cursor to the next field
	em_to.SetFocus()

END IF


end event

type b_calendar_to from commandbutton within w_performance_parms
integer x = 1943
integer y = 740
integer width = 110
integer height = 80
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  08/08/01 M. Caruso   Created.
//  08/09/01 M. Caruso   Corrected placement of pop-up calendar.
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = PARENT.X + THIS.X
l_nY = PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX )
l_cY = String( l_nY + l_nHeight )

//Only one button(calendar) so open the calendar window
l_cCalendarDate = em_to.Text
IF l_cCalendarDate = 'none' OR l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid date set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dToDate = l_dtCalendarDate

IF em_from.Text = '00/00/0000' THEN
	messagebox(gs_AppName,'A From date is required')
	em_from.SetFocus()
END IF
IF i_dFromDate > i_dToDate THEN
	messagebox(gs_AppName,'To date must be greater than From date')
	em_to.SetFocus()
ELSE
	//Add the date to the datawindow
	em_to.Text = string(l_dtCalendarDate)
END IF

end event

type st_report_subject from statictext within w_performance_parms
integer x = 37
integer y = 24
integer width = 425
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Subject:"
boolean focusrectangle = false
end type

type rb_owner from radiobutton within w_performance_parms
integer x = 1353
integer y = 212
integer width = 462
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current Owner"
end type

event clicked;//**********************************************************************************************
//  Event:   clicked
//  Purpose: to get the report by parameter
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/08/01 M. Caruso   Created.
//**********************************************************************************************

i_cReportBy = "O"
end event

type rb_takenby from radiobutton within w_performance_parms
integer x = 1353
integer y = 124
integer width = 343
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Taken By"
end type

event clicked;//**********************************************************************************************
//  Event:   clicked
//  Purpose: to get the report by parameter
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/08/01 M. Caruso   Created.
//**********************************************************************************************

i_cReportBy = "T"
end event

type dw_user_list from u_outliner_std within w_performance_parms
integer x = 37
integer y = 96
integer width = 1102
integer height = 976
integer taborder = 10
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;call super::po_pickedrow;/*****************************************************************************************
   Event:      po_pickedrow
   Purpose:    Update the subject type and subject ID according to the current selection.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/08/01 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cKeys[]

// determine the subject type
IF clickedlevel = 1 THEN
	i_cSubjectType = 'D'
ELSE
	i_cSubjectType = 'U'
END IF

// determine the subject ID
fu_HLGetRowKey (clickedrow, l_cKeys[])
i_cSubjectID = l_cKeys[clickedlevel]
end event

type gb_report_by from groupbox within w_performance_parms
integer x = 1207
integer y = 24
integer width = 901
integer height = 320
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report By"
end type

type em_from from editmask within w_performance_parms
integer x = 1545
integer y = 624
integer width = 379
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type em_to from editmask within w_performance_parms
integer x = 1545
integer y = 732
integer width = 379
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type st_from from statictext within w_performance_parms
integer x = 1307
integer y = 640
integer width = 215
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "From:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_to from statictext within w_performance_parms
integer x = 1371
integer y = 748
integer width = 151
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "To:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_date from dropdownlistbox within w_performance_parms
integer x = 1243
integer y = 488
integer width = 814
integer height = 572
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"YTD (Year to Date)","MTD (Month to Date)","This Week (Sun-Sat)","Today (12:00 am-12:00)","Specify Date Range"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//*********************************************************************************************
//  Event:   selectionchanged
//  Purpose: Determine date for reporting
//  
//  Date     Develop     Description
//  -------- ----------- ----------------------------------------------------------------------
//  08/08/01 M. Caruso   Created.
//*********************************************************************************************

i_nListBoxIndex = Index
CHOOSE CASE Index
	CASE 1, 2, 3, 4
		// Predefined Range
		em_from.Enabled = FALSE
		b_calendar_from.Enabled = FALSE
		em_to.Enabled = FALSE
		b_calendar_TO.Enabled = FALSE
		
	CASE 5
		// Custom Range
		em_from.Enabled = TRUE
		b_calendar_from.Enabled = TRUE
		em_to.Enabled = TRUE
		b_calendar_to.Enabled = TRUE
		em_from.SetFocus()
		
END CHOOSE


end event

type gb_date_range from groupbox within w_performance_parms
integer x = 1202
integer y = 396
integer width = 901
integer height = 488
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Range"
end type

