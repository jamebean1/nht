$PBExportHeader$w_work_tracking_criteria.srw
forward
global type w_work_tracking_criteria from w_response
end type
type dw_header from datawindow within w_work_tracking_criteria
end type
type cb_add from commandbutton within w_work_tracking_criteria
end type
type cb_delete from commandbutton within w_work_tracking_criteria
end type
type dw_work_tracking from datawindow within w_work_tracking_criteria
end type
type st_4 from statictext within w_work_tracking_criteria
end type
type p_1 from picture within w_work_tracking_criteria
end type
type cb_okay from commandbutton within w_work_tracking_criteria
end type
type cb_cancel from commandbutton within w_work_tracking_criteria
end type
type st_5 from statictext within w_work_tracking_criteria
end type
end forward

global type w_work_tracking_criteria from w_response
integer width = 2139
integer height = 2072
string title = "Work Dashboard Criteria"
dw_header dw_header
cb_add cb_add
cb_delete cb_delete
dw_work_tracking dw_work_tracking
st_4 st_4
p_1 p_1
cb_okay cb_okay
cb_cancel cb_cancel
st_5 st_5
end type
global w_work_tracking_criteria w_work_tracking_criteria

type variables
STRING is_user_id
end variables

forward prototypes
public subroutine of_add_all ()
end prototypes

public subroutine of_add_all ();DataWindowChild ldwc_dddw
Long ll_row, ll_null, ll_return
String ls_null

SetNull(ls_null)
SetNull(ll_null)

ll_return = dw_work_tracking.GetChild("user_id", ldwc_dddw)
ll_row = ldwc_dddw.InsertRow(0) 
ll_return = ldwc_dddw.setitem(ll_row, "name", "(All)")
ll_return = ldwc_dddw.setitem(ll_row, "user_id", ls_null)

ll_return = dw_work_tracking.GetChild("user_dept_id", ldwc_dddw)
ll_row = ldwc_dddw.InsertRow(0) 
ll_return = ldwc_dddw.setitem(ll_row, "dept_desc", "(All)")
ll_return = ldwc_dddw.setitem(ll_row, "user_dept_id", ls_null)

ll_return = dw_work_tracking.GetChild("source_type", ldwc_dddw)
ll_row = ldwc_dddw.InsertRow(0) 
ll_return = ldwc_dddw.setitem(ll_row, "source_desc", "(All)")
ll_return = ldwc_dddw.setitem(ll_row, "source_type", ls_null)

ll_return = dw_work_tracking.GetChild("case_type", ldwc_dddw)
ll_row = ldwc_dddw.InsertRow(0) 
ll_return = ldwc_dddw.setitem(ll_row, "case_type_desc", "(All)")
ll_return = ldwc_dddw.setitem(ll_row, "case_type", ls_null)

ll_return = dw_work_tracking.GetChild("line_of_business_id", ldwc_dddw)
ll_row = ldwc_dddw.InsertRow(0) 
ll_return = ldwc_dddw.setitem(ll_row, "line_of_business_name", "(All)")
ll_return = ldwc_dddw.setitem(ll_row, "line_of_business_id", ls_null)


end subroutine

on w_work_tracking_criteria.create
int iCurrent
call super::create
this.dw_header=create dw_header
this.cb_add=create cb_add
this.cb_delete=create cb_delete
this.dw_work_tracking=create dw_work_tracking
this.st_4=create st_4
this.p_1=create p_1
this.cb_okay=create cb_okay
this.cb_cancel=create cb_cancel
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_header
this.Control[iCurrent+2]=this.cb_add
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.dw_work_tracking
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.p_1
this.Control[iCurrent+7]=this.cb_okay
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.st_5
end on

on w_work_tracking_criteria.destroy
call super::destroy
destroy(this.dw_header)
destroy(this.cb_add)
destroy(this.cb_delete)
destroy(this.dw_work_tracking)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.cb_okay)
destroy(this.cb_cancel)
destroy(this.st_5)
end on

event open;call super::open;LONG ll_rows

is_user_id = objca.win.fu_getlogin(sqlca)

dw_work_tracking.SetTransObject(SQLCA)
ll_rows = dw_work_tracking.Retrieve(is_user_id)
dw_work_tracking.ShareData(dw_header)
IF ll_rows > 0 THEN
	dw_header.SelectRow(1, TRUE)
	dw_work_tracking.SetRow(1)
END IF

of_add_all()


end event

event closequery;call super::closequery;Long ll_return

dw_work_tracking.AcceptText()

IF dw_work_tracking.ModifiedCount() > 0 OR dw_work_tracking.DeletedCount() > 0 THEN
	ll_return = MessageBox(gs_AppName, "Do you want to save pending changes?", Question!, YesNo!)
	IF ll_return = 1 THEN
		ll_return = dw_work_tracking.Update()
		IF ll_return < 0 THEN 
			RETURN 1 
		END IF
	END IF
END IF

RETURN 0

end event

type dw_header from datawindow within w_work_tracking_criteria
integer x = 9
integer y = 152
integer width = 2103
integer height = 428
integer taborder = 10
string title = "none"
string dataobject = "d_work_tracking_criteria_desc"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;THIS.SelectRow(0, FALSE)
THIS.SelectRow(row, TRUE)
dw_work_tracking.SetRow(row)
dw_work_tracking.ScrollToRow(row)
dw_work_tracking.SetColumn("description")

end event

type cb_add from commandbutton within w_work_tracking_criteria
integer x = 101
integer y = 1884
integer width = 402
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add"
end type

event clicked;Long ll_newrow
ll_newrow = dw_work_tracking.InsertRow(0)
dw_work_tracking.ScrollToRow(ll_newrow)	
dw_header.ScrollToRow(ll_newrow)
dw_header.SelectRow(0, FALSE)
dw_header.SelectRow(ll_newrow, TRUE)
dw_work_tracking.Object.updated_timestamp[ll_newrow] = DateTime(Today(), Now())
dw_work_tracking.Object.owner_id[ll_newrow] = is_user_id
dw_work_tracking.SetColumn("description")
dw_work_tracking.SetFocus()

end event

type cb_delete from commandbutton within w_work_tracking_criteria
integer x = 581
integer y = 1884
integer width = 402
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;Long ll_currentrow

ll_currentrow = dw_work_tracking.GetRow()
IF ll_currentrow > 0 THEN
	dw_work_tracking.DeleteRow(ll_currentrow)
END IF

dw_work_tracking.SetFocus()

end event

type dw_work_tracking from datawindow within w_work_tracking_criteria
integer x = 9
integer y = 584
integer width = 2103
integer height = 1280
integer taborder = 10
string title = "none"
string dataobject = "d_work_tracking_criteria"
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/****************************************************************************************

	Event:	buttonclicked
	Purpose:	Please see PB documentation for this event
	
	Revisions:
	Date      Developer     Description
	========  ============= ==============================================================
	2/15/2008 RAP           Added code to process the button clicked events

****************************************************************************************/
INTEGER	l_nX, l_nY, l_nHeight
DATETIME	l_dtValue
STRING	l_cValue, l_cParm, l_cX, l_cY, l_cColName, ls_null

SetNull(ls_null)

CHOOSE CASE dwo.name
//	CASE 'b_case_deadline'
//		l_cColName = 'case_deadline'
//		THIS.Object.case_deadline_operator[row] = '<'
		
	CASE 'b_appeal_due_date'
		l_cColName = 'appeal_due_date'
		THIS.Object.appeal_due_date_operator[row] = '<'
END CHOOSE

// set focus to the column associated with the selected button
SetColumn (l_cColName)

// Get the button's dimensions to position the calendar window
l_nX = Integer (dwo.X) + dw_work_tracking.X + PARENT.X
l_nY = Integer (dwo.Y) + Integer (dwo.Height) + dw_work_tracking.Y + PARENT.Y
l_cX = String (l_nX)
l_cY = String (l_nY)

// open the calendar window
AcceptText ()
l_dtValue = GetItemDateTime (row, l_cColName)
l_cParm = (String (Date (l_dtValue), "mm/dd/yyyy")+"&"+l_cX+"&"+l_cY)
FWCA.MGR.fu_OpenWindow (w_calendar, l_cParm)

// Get the date passed back
l_cValue = Message.StringParm

// If it's a date, convert to a datetime and update the field.
IF IsDate (l_cValue) THEN
	l_dtValue = DateTime (Date (l_cValue), Time ("00:00:00.000"))
	SetColumn (l_cColName)
	SetText (String(l_dtValue, "mm/dd/yyyy 00:00:00.000"))
ELSE
	SetNull( l_dtValue )
	SetColumn (l_cColName)
	SetText (ls_null)
END IF

THIS.AcceptText()
end event

event itemchanged;DatawindowChild ldwc_Appeal_Type, ldwc_service_type
Long ll_return, ll_line_of_business_id, ll_null, ll_value
SetNull(ll_null)
String ls_filter, ls_source_type

Choose Case dwo.name
	CASE "days_open"
		IF IsNull(data) THEN
			THIS.Object.days_open_operator[row] = ''
		ELSE
			THIS.Object.days_open_operator[row] = '>'
		END IF
//	CASE "case_deadline"
//		IF IsNull(data) THEN
//			THIS.Object.case_deadline_operator[row] = ''
//		ELSE
//			THIS.Object.case_deadline_operator[row] = '<'
//		END IF
	CASE "appeal_due_date"
		IF IsNull(data) THEN
			THIS.Object.appeal_due_date_operator[row] = ''
			IF IsNull(THIS.Object.appealtype[row]) AND IsNull(THIS.Object.service_type_id[row]) AND IsNull(THIS.Object.line_of_business_id[row]) THEN
				THIS.Object.appeal_exists[row] = 'N'
			ELSE
				THIS.Object.appeal_exists[row] = 'Y'
			END IF
		ELSE
			THIS.Object.appeal_due_date_operator[row] = '<'
			THIS.Object.appeal_exists[row] = 'Y'
		END IF
	Case 'service_type_id'
		IF IsNull(data) THEN
			IF IsNull(THIS.Object.appealtype[row]) AND IsNull(THIS.Object.appeal_due_date[row]) AND IsNull(THIS.Object.line_of_business_id[row]) THEN
				THIS.Object.appeal_exists[row] = 'N'
			ELSE
				THIS.Object.appeal_exists[row] = 'Y'
			END IF
		ELSE
			THIS.Object.appeal_exists[row] = 'Y'
		END IF
	CASE 'line_of_business_id'
		GetChild('appealtype', ldwc_Appeal_Type)
		IF IsNull(data) THEN
			ll_return = ldwc_Appeal_Type.SetFilter("0 = 1")
		ELSE
			ll_return = ldwc_Appeal_Type.SetFilter("line_of_business_id = " + data)
		END IF
		ll_return = ldwc_appeal_type.Filter()
		THIS.Object.appealtype[row] = ll_null
		THIS.Object.service_type_id[row] = ll_null
		IF IsNull(data) THEN
			IF IsNull(THIS.Object.appealtype[row]) AND IsNull(THIS.Object.appeal_due_date[row]) AND IsNull(THIS.Object.service_type_id[row]) THEN
				THIS.Object.appeal_exists[row] = 'N'
			ELSE
				THIS.Object.appeal_exists[row] = 'Y'
			END IF
		ELSE
			THIS.Object.appeal_exists[row] = 'Y'
		END IF
		
	CASE 'appealtype'
		GetChild('service_type_id', ldwc_Service_Type)
		ll_line_of_business_id = THIS.Object.line_of_business_id[row]
		ls_filter = "line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + String(data)
		ll_return = ldwc_service_Type.SetFilter(ls_filter)
		ll_return = ldwc_service_type.Filter()
		THIS.Object.service_type_id[row] = ll_null
		IF IsNull(data) THEN
			IF IsNull(THIS.Object.line_of_business_id[row]) AND IsNull(THIS.Object.appeal_due_date[row]) AND IsNull(THIS.Object.service_type_id[row]) THEN
				THIS.Object.appeal_exists[row] = 'N'
			ELSE
				THIS.Object.appeal_exists[row] = 'Y'
			END IF
		ELSE
			THIS.Object.appeal_exists[row] = 'Y'
		END IF
End Choose
		
end event

event scrollvertical;Long ll_firstrow
String ls_firstrow

ls_firstrow = THIS.Object.Datawindow.FirstRowOnPage
ll_firstrow = Long(ls_firstrow)
THIS.SetRow(ll_firstrow)
THIS.SetColumn("description")
dw_header.Scrolltorow(ll_firstrow)
dw_header.SelectRow(0, FALSE)
dw_header.SelectRow(ll_firstrow, TRUE)
end event

type st_4 from statictext within w_work_tracking_criteria
integer x = 215
integer y = 44
integer width = 2839
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Enter criteria for cases to be added to your Work Dashboard tab."
boolean focusrectangle = false
end type

type p_1 from picture within w_work_tracking_criteria
integer x = 27
integer y = 4
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "module - smartsearch - large icon (white).bmp"
boolean focusrectangle = false
end type

type cb_okay from commandbutton within w_work_tracking_criteria
integer x = 1074
integer y = 1884
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;Long ll_return
dw_work_tracking.AcceptText()

ll_return = dw_work_tracking.Update()
IF ll_return < 0 THEN 
	RETURN 1 
END IF
Close(PARENT)
end event

type cb_cancel from commandbutton within w_work_tracking_criteria
integer x = 1563
integer y = 1884
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;Close(PARENT)
end event

type st_5 from statictext within w_work_tracking_criteria
integer width = 3113
integer height = 144
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

