$PBExportHeader$w_appeals_parms_hg.srw
$PBExportComments$Gets a date range from the user
forward
global type w_appeals_parms_hg from w_response_std
end type
type cbx_grievance from checkbox within w_appeals_parms_hg
end type
type cbx_complaint from checkbox within w_appeals_parms_hg
end type
type rb_external from radiobutton within w_appeals_parms_hg
end type
type rb_leveltwo from radiobutton within w_appeals_parms_hg
end type
type rb_levelone from radiobutton within w_appeals_parms_hg
end type
type cb_cancel from commandbutton within w_appeals_parms_hg
end type
type cb_ok from commandbutton within w_appeals_parms_hg
end type
type b_calendar_from from commandbutton within w_appeals_parms_hg
end type
type b_calendar_to from commandbutton within w_appeals_parms_hg
end type
type em_from from editmask within w_appeals_parms_hg
end type
type em_to from editmask within w_appeals_parms_hg
end type
type st_from from statictext within w_appeals_parms_hg
end type
type st_to from statictext within w_appeals_parms_hg
end type
type gb_date_range from groupbox within w_appeals_parms_hg
end type
type gb_1 from groupbox within w_appeals_parms_hg
end type
type gb_selection_criteria from groupbox within w_appeals_parms_hg
end type
end forward

global type w_appeals_parms_hg from w_response_std
integer width = 1079
integer height = 1416
string title = "Monthly Appeals Parameters"
cbx_grievance cbx_grievance
cbx_complaint cbx_complaint
rb_external rb_external
rb_leveltwo rb_leveltwo
rb_levelone rb_levelone
cb_cancel cb_cancel
cb_ok cb_ok
b_calendar_from b_calendar_from
b_calendar_to b_calendar_to
em_from em_from
em_to em_to
st_from st_from
st_to st_to
gb_date_range gb_date_range
gb_1 gb_1
gb_selection_criteria gb_selection_criteria
end type
global w_appeals_parms_hg w_appeals_parms_hg

type variables
STRING i_cDetailView
STRING i_cWindowTitle
STRING i_cDateColumn
STRING i_cResetArray[]

BOOLEAN i_bOK

LONG i_nReturn

DATE		i_dFromDate
DATE		i_dToDate
DATETIME i_dtStartDate
DATETIME i_dtEndDate

//S_REPORT_PARMS_HG	i_sReportParmsHG
S_REPORT_PARMS	i_sReportParmsHG

end variables

forward prototypes
public subroutine fw_calcdaterange ()
end prototypes

public subroutine fw_calcdaterange ();/*****************************************************************************************
   Function:   fw_calcdaterange
   Purpose:    Calculate the date range specified on the window.
   Parameters: NONE
   Returns:    NONE

   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson   Original Version
*****************************************************************************************/

DATE		l_dStartDate, l_dEndDate
TIME		l_tStartOfDay, l_tEndOfDay

//l_tStartOfDay = Time ('00:00:00.000')
//l_tEndOfDay = Time ('23:59:59.999')

em_from.GetData (l_dStartDate)
em_to.GetData (l_dEndDate)
i_dtStartDate = DATETIME (l_dStartDate)
i_dtEndDate = DATETIME (l_dEndDate)

end subroutine

on w_appeals_parms_hg.create
int iCurrent
call super::create
this.cbx_grievance=create cbx_grievance
this.cbx_complaint=create cbx_complaint
this.rb_external=create rb_external
this.rb_leveltwo=create rb_leveltwo
this.rb_levelone=create rb_levelone
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.b_calendar_from=create b_calendar_from
this.b_calendar_to=create b_calendar_to
this.em_from=create em_from
this.em_to=create em_to
this.st_from=create st_from
this.st_to=create st_to
this.gb_date_range=create gb_date_range
this.gb_1=create gb_1
this.gb_selection_criteria=create gb_selection_criteria
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_grievance
this.Control[iCurrent+2]=this.cbx_complaint
this.Control[iCurrent+3]=this.rb_external
this.Control[iCurrent+4]=this.rb_leveltwo
this.Control[iCurrent+5]=this.rb_levelone
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_ok
this.Control[iCurrent+8]=this.b_calendar_from
this.Control[iCurrent+9]=this.b_calendar_to
this.Control[iCurrent+10]=this.em_from
this.Control[iCurrent+11]=this.em_to
this.Control[iCurrent+12]=this.st_from
this.Control[iCurrent+13]=this.st_to
this.Control[iCurrent+14]=this.gb_date_range
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_selection_criteria
end on

on w_appeals_parms_hg.destroy
call super::destroy
destroy(this.cbx_grievance)
destroy(this.cbx_complaint)
destroy(this.rb_external)
destroy(this.rb_leveltwo)
destroy(this.rb_levelone)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.b_calendar_from)
destroy(this.b_calendar_to)
destroy(this.em_from)
destroy(this.em_to)
destroy(this.st_from)
destroy(this.st_to)
destroy(this.gb_date_range)
destroy(this.gb_1)
destroy(this.gb_selection_criteria)
end on

event pc_closequery;call super::pc_closequery;/*****************************************************************************************
   Event:      pc_closequery
   Purpose:    Perform final window processing and determine if Close process should
					continue.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

STRING	l_cStartDate, l_cEndDate, l_cBlankDate = '00/00/0000', l_cKeys[], l_cSelectedKeys[]
LONG     l_nIndex, l_nLastRow, l_nNumSelected, l_nSelectedRows[]

IF i_bOK THEN
	
	l_cStartDate = em_from.Text
	l_cEndDate = em_to.Text
	
	// if a custom date range is specified and either date is not set, notify the user
	IF l_cStartDate = l_cBlankDate THEN
		
		IF l_cEndDate = l_cBlankDate THEN
			MessageBox (gs_appname, 'You must specify Begin and End dates.')
		ELSE
			MessageBox (gs_appname, 'You must specify a Begin Date.')
		END IF
		Error.i_FWError = c_Fatal
		em_from.SetFocus ()
		RETURN 0
		
	ELSE
		
		IF l_cEndDate = l_cBlankDate THEN
	
			// if a custom date range is specified and either date is not set, notify the user
			MessageBox (gs_appname, 'You must specify an end date.')
			Error.i_FWError = c_Fatal
			em_to.SetFocus ()
			RETURN 0

		ELSE
		
			IF DaysAfter(Date(l_cEndDate),Date(l_cStartDate)) > 0 THEN
				messagebox(gs_AppName, 'The End Date must be greater than the Begin Date.')
				Error.i_FWError = c_Fatal
				em_to.SetFocus()
				RETURN 0
			END IF			

			
		END IF
		
	END IF
	
	IF rb_levelone.Checked THEN
		i_sReportParmsHG.appeal_level = '1'
	ELSEIF rb_leveltwo.Checked THEN
		i_sReportParmsHG.appeal_level = '2'
	ELSE
		i_sReportParmsHG.appeal_level = '3'
	END IF
	
	IF cbx_complaint.Checked THEN
		IF cbx_grievance.Checked THEN
			IF i_sReportParmsHG.appeal_level = '1' THEN
				i_sReportParmsHG.report_type = '1-Both'
			ELSE
				i_sReportParmsHG.report_type = '2-Both'			
			END IF
		ELSE
			IF i_sReportParmsHG.appeal_level = '1' THEN
				i_sReportParmsHG.report_type = '1-Complaint'
			ELSE
				i_sReportParmsHG.report_type = '2-Complaint'
			END IF
		END IF
	ELSEIF cbx_grievance.Checked THEN
		IF i_sReportParmsHG.appeal_level = '1' THEN
			i_sReportParmsHG.report_type = '1-Grievance'
		ELSE
			i_sReportParmsHG.report_type = '2-Grievance'
		END IF
		
	ELSE
		IF i_sReportParmsHG.appeal_level <> '3' THEN

			MessageBox (gs_appname, 'You must specify Complaint, Grievance or Both.')
			Error.i_FWError = c_Fatal
			cbx_Complaint.SetFocus ()
			RETURN 0
		END IF
			
			
	END IF
	
		
	// determine the specified date range
	fw_CalcDateRange ()
	

	// convert date to string to pass to stored procedure
	l_cStartDate = STRING(i_dtStartDate)
	l_cEndDate = STRING(i_dtEndDate)
	
	IF i_sReportParmsHG.appeal_level = '3' THEN
		i_sReportParmsHG.report_type = '3'
	END IF
	
	// set the return values based on the settings in the window.
	i_sReportParmsHG.start_date_string = l_cStartDate
	i_sReportParmsHG.end_date_string = l_cEndDate
	
ELSE
	
	// set blank return values
	SetNull(i_sReportParmsHG.start_date)
	SetNull(i_sReportParmsHG.end_date)
	
END IF


end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Pass the return values via Message.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

message.PowerObjectParm = i_sReportParmsHG
end event

type cbx_grievance from checkbox within w_appeals_parms_hg
integer x = 178
integer y = 972
integer width = 402
integer height = 80
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grievance"
borderstyle borderstyle = stylelowered!
end type

type cbx_complaint from checkbox within w_appeals_parms_hg
integer x = 178
integer y = 884
integer width = 402
integer height = 80
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Complaint"
borderstyle borderstyle = stylelowered!
end type

type rb_external from radiobutton within w_appeals_parms_hg
integer x = 178
integer y = 664
integer width = 535
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "External Appeals"
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To disable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************

cbx_Complaint.Checked = FALSE
cbx_Grievance.Checked = FALSE
cbx_Complaint.Enabled = FALSE
cbx_Grievance.Enabled = FALSE

end event

type rb_leveltwo from radiobutton within w_appeals_parms_hg
integer x = 178
integer y = 584
integer width = 494
integer height = 80
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Level II Appeals"
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To enable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************

cbx_Complaint.Enabled = TRUE
cbx_Grievance.Enabled = TRUE

end event

type rb_levelone from radiobutton within w_appeals_parms_hg
integer x = 178
integer y = 504
integer width = 480
integer height = 80
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Level I Appeals"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To enable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************

cbx_Complaint.Enabled = TRUE
cbx_Grievance.Enabled = TRUE

end event

type cb_cancel from commandbutton within w_appeals_parms_hg
integer x = 599
integer y = 1152
integer width = 320
integer height = 108
integer taborder = 110
integer textsize = -10
integer weight = 400
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
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

i_bOK = FALSE
Close (PARENT)
end event

type cb_ok from commandbutton within w_appeals_parms_hg
integer x = 247
integer y = 1152
integer width = 320
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 400
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
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

DATE l_dStartDate, l_dEndDate
BOOLEAN	l_bBadDate = FALSE

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
	
IF l_bBadDate THEN
	
	RETURN
	
ELSE
	
	i_bOK = TRUE
	
	CloseWithReturn (PARENT, i_sReportParmsHG)

END IF



end event

type b_calendar_from from commandbutton within w_appeals_parms_hg
integer x = 759
integer y = 116
integer width = 110
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/13/02 C. Jackson  Original Version
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
i_dToDate = date(em_to.text)

// Validate the value against the TO field
IF (em_to.Text <> '00/00/0000') AND (i_dToDate < i_dFromDate) THEN
	
	messagebox(gs_AppName,'Begin Date must be less than End Date.')
	em_from.SetFocus()
	
ELSE

	//Add the date to the datawindow
	em_from.Text = string(l_dtCalendarDate)
	
	//Move the cursor to the next field
	em_to.SetFocus()

END IF


end event

type b_calendar_to from commandbutton within w_appeals_parms_hg
integer x = 759
integer y = 228
integer width = 110
integer height = 80
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/13/02 C. Jackson  Original Version
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
	messagebox(gs_AppName,'A Begin Date is required.')
	em_from.SetFocus()
END IF
IF i_dFromDate > i_dToDate THEN
	messagebox(gs_AppName,'The End Date must be greater than the Begin Date.')
	em_to.SetFocus()
ELSE
	//Add the date to the datawindow
	em_to.Text = string(l_dtCalendarDate)
END IF

end event

type em_from from editmask within w_appeals_parms_hg
integer x = 352
integer y = 116
integer width = 389
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type em_to from editmask within w_appeals_parms_hg
integer x = 352
integer y = 228
integer width = 389
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type st_from from statictext within w_appeals_parms_hg
integer x = 160
integer y = 124
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Begin:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_to from statictext within w_appeals_parms_hg
integer x = 206
integer y = 236
integer width = 119
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "End:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_date_range from groupbox within w_appeals_parms_hg
integer x = 101
integer y = 44
integer width = 818
integer height = 324
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_appeals_parms_hg
integer x = 101
integer y = 420
integer width = 818
integer height = 348
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Level"
borderstyle borderstyle = stylelowered!
end type

type gb_selection_criteria from groupbox within w_appeals_parms_hg
integer x = 101
integer y = 796
integer width = 818
integer height = 308
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Type"
borderstyle borderstyle = stylelowered!
end type

