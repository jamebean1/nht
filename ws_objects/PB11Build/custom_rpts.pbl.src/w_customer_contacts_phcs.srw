$PBExportHeader$w_customer_contacts_phcs.srw
$PBExportComments$PHCS Customer Contact Report parameter window.
forward
global type w_customer_contacts_phcs from w_response_std
end type
type cb_select_all from commandbutton within w_customer_contacts_phcs
end type
type cb_cancel from commandbutton within w_customer_contacts_phcs
end type
type cb_ok from commandbutton within w_customer_contacts_phcs
end type
type cbx_summary_report from checkbox within w_customer_contacts_phcs
end type
type cb_calendar_to from commandbutton within w_customer_contacts_phcs
end type
type cb_calendar_from from commandbutton within w_customer_contacts_phcs
end type
type em_end_date from editmask within w_customer_contacts_phcs
end type
type em_start_date from editmask within w_customer_contacts_phcs
end type
type st_end_date from statictext within w_customer_contacts_phcs
end type
type st_start_date from statictext within w_customer_contacts_phcs
end type
type dw_customer_list from u_dw_std within w_customer_contacts_phcs
end type
type gb_date_range from groupbox within w_customer_contacts_phcs
end type
type gb_select_customers from groupbox within w_customer_contacts_phcs
end type
end forward

global type w_customer_contacts_phcs from w_response_std
integer width = 2432
integer height = 1444
string title = "Customer Contact Activity Report"
cb_select_all cb_select_all
cb_cancel cb_cancel
cb_ok cb_ok
cbx_summary_report cbx_summary_report
cb_calendar_to cb_calendar_to
cb_calendar_from cb_calendar_from
em_end_date em_end_date
em_start_date em_start_date
st_end_date st_end_date
st_start_date st_start_date
dw_customer_list dw_customer_list
gb_date_range gb_date_range
gb_select_customers gb_select_customers
end type
global w_customer_contacts_phcs w_customer_contacts_phcs

type variables
DATE		i_dFromDate
DATE		i_dToDate

S_REPORT_PARMS	i_sParameters
end variables

on w_customer_contacts_phcs.create
int iCurrent
call super::create
this.cb_select_all=create cb_select_all
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cbx_summary_report=create cbx_summary_report
this.cb_calendar_to=create cb_calendar_to
this.cb_calendar_from=create cb_calendar_from
this.em_end_date=create em_end_date
this.em_start_date=create em_start_date
this.st_end_date=create st_end_date
this.st_start_date=create st_start_date
this.dw_customer_list=create dw_customer_list
this.gb_date_range=create gb_date_range
this.gb_select_customers=create gb_select_customers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_select_all
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cbx_summary_report
this.Control[iCurrent+5]=this.cb_calendar_to
this.Control[iCurrent+6]=this.cb_calendar_from
this.Control[iCurrent+7]=this.em_end_date
this.Control[iCurrent+8]=this.em_start_date
this.Control[iCurrent+9]=this.st_end_date
this.Control[iCurrent+10]=this.st_start_date
this.Control[iCurrent+11]=this.dw_customer_list
this.Control[iCurrent+12]=this.gb_date_range
this.Control[iCurrent+13]=this.gb_select_customers
end on

on w_customer_contacts_phcs.destroy
call super::destroy
destroy(this.cb_select_all)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cbx_summary_report)
destroy(this.cb_calendar_to)
destroy(this.cb_calendar_from)
destroy(this.em_end_date)
destroy(this.em_start_date)
destroy(this.st_end_date)
destroy(this.st_start_date)
destroy(this.dw_customer_list)
destroy(this.gb_date_range)
destroy(this.gb_select_customers)
end on

event open;call super::open;/*****************************************************************************************
   Event:      pc_view
   Purpose:    Initialize the state of the controls on the window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/20/03 M. Caruso    Original Version
*****************************************************************************************/

LONG 	l_nRowCount

l_nRowCount = dw_customer_list.retrieve()
IF l_nRowCount = 0 THEN
	// notify the user that no customers exist
	MessageBox (gs_appName, 'The report cannot be run because no customers are available.')
	
	// disable all but the Cancel button
	cb_ok.enabled = FALSE
	cb_select_all.enabled = FALSE
	cb_calendar_from.enabled = FALSE
	cb_calendar_to.enabled = FALSE
	cbx_summary_report.enabled = FALSE
	em_start_date.enabled = FALSE
	em_end_date.enabled = FALSE
	dw_customer_list.enabled = FALSE
	
	// end processing of this event
	RETURN
END IF
end event

type cb_select_all from commandbutton within w_customer_contacts_phcs
integer x = 1413
integer y = 448
integer width = 896
integer height = 108
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Select All Customers"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the selection of this button.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/20/03 M. Caruso    Original Version
*****************************************************************************************/

LONG	l_nRow, l_nRowCount, l_nSelectedRows[]

l_nRowCount = dw_customer_list.RowCount()
IF dw_customer_list.i_numselected < l_nRowCount THEN
	FOR l_nRow = 1 TO l_nRowCount
		l_nSelectedRows[l_nRow] = l_nRow
	NEXT
	dw_customer_list.fu_SetSelectedRows(l_nRowCount, l_nSelectedRows[], dw_customer_list.c_IgnoreChanges, dw_customer_list.c_NoRefreshChildren)
END IF
end event

type cb_cancel from commandbutton within w_customer_contacts_phcs
integer x = 1902
integer y = 1176
integer width = 411
integer height = 108
integer taborder = 90
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
	11/20/03 M. Caruso    Original Version
*****************************************************************************************/

i_sParameters.string_parm1 = ''
	
CloseWithReturn (PARENT, i_sParameters)
end event

type cb_ok from commandbutton within w_customer_contacts_phcs
integer x = 1449
integer y = 1176
integer width = 411
integer height = 108
integer taborder = 80
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
   Purpose:    Process the Cancel button

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/20/03 M. Caruso    Original Version
*****************************************************************************************/

DATE	l_dStartDate, l_dEndDate
LONG	l_nIdx, l_nRow

l_dStartDate = DATE(em_start_date.Text)
l_dEndDate = DATE(em_end_date.Text)

IF YEAR(l_dStartDate) < 1753 THEN
	messagebox(gs_AppName,'Please enter a valid start date.')
	em_start_date.SetFocus()
	RETURN
ELSE
	i_sParameters.start_date = DateTime(Date(em_start_date.text))
END IF

IF YEAR(l_dEndDate) < 1753 THEN
	messagebox(gs_AppName,'Please enter a valid end date.')
	em_end_date.SetFocus()
	RETURN
ELSE
	i_sParameters.end_date = DateTime(Date(em_end_date.text), Time('23:59:59.999'))
END IF

IF dw_customer_list.i_numselected = 0 THEN
	messageBox (gs_appName,'You must select at least one customer to run this report.')
	dw_customer_list.SetFocus()
	RETURN
ELSE
	// populate customer_list array
	l_nIdx = 1
	l_nRow = 0
	DO 
		l_nRow = dw_customer_list.GetSelectedRow(l_nRow)
		IF l_nRow > 0 THEN
			i_sParameters.user_array[l_nIdx] = dw_customer_list.GetItemString (l_nRow, 'customer_id')
			l_nIdx++
		END IF
	LOOP UNTIL l_nRow = 0
END IF

IF cbx_summary_report.checked THEN
	i_sParameters.string_parm1 = 'Y'
ELSE
	i_sParameters.string_parm1 = 'N'
END IF
	
CloseWithReturn (PARENT, i_sParameters)


end event

type cbx_summary_report from checkbox within w_customer_contacts_phcs
integer x = 96
integer y = 1188
integer width = 1065
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Run Summary Report (all customers)"
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the clicking of the checkbox

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/20/03 M. Caruso    Original Version
*****************************************************************************************/

IF this.checked THEN
	dw_customer_list.enabled = FALSE
	// select all of the customers
	cb_select_all.triggerevent ('clicked')
ELSE
	dw_customer_list.enabled = TRUE
END IF
end event

type cb_calendar_to from commandbutton within w_customer_contacts_phcs
integer x = 2121
integer y = 272
integer width = 101
integer height = 84
integer taborder = 60
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
//  11/20/03 M. Caruso   Original Version
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
l_cCalendarDate = em_end_date.Text
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

IF (em_start_date.Text = '00/00/0000') OR &
	(em_start_date.Text = '') THEN
	messagebox(gs_AppName,'A Begin Date is required.')
	em_start_date.SetFocus()
END IF

IF i_dFromDate > i_dToDate THEN
	messagebox(gs_AppName,'The End Date must be greater than the Begin Date.')
	em_end_date.SetFocus()
ELSE
	//Add the date to the datawindow
	em_end_date.Text = string(l_dtCalendarDate)
END IF

end event

type cb_calendar_from from commandbutton within w_customer_contacts_phcs
integer x = 2121
integer y = 144
integer width = 101
integer height = 84
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
//  11/20/03 M. Caruso   Original Version
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

l_cCalendarDate = em_start_date.Text
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
i_dToDate = date(em_end_date.text)

// Validate the value against the TO field
IF (em_end_date.Text <> '00/00/0000') AND &
	(em_end_date.text <> '') AND &
	(i_dToDate < i_dFromDate) THEN
	
	messagebox(gs_AppName,'Begin Date must be less than End Date.')
	em_start_date.SetFocus()
	
ELSE

	//Add the date to the datawindow
	em_start_date.Text = string(l_dtCalendarDate)
	//Move the cursor to the next field
	em_end_date.SetFocus()

END IF
end event

type em_end_date from editmask within w_customer_contacts_phcs
integer x = 1682
integer y = 272
integer width = 389
integer height = 84
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type em_start_date from editmask within w_customer_contacts_phcs
integer x = 1682
integer y = 144
integer width = 389
integer height = 84
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type st_end_date from statictext within w_customer_contacts_phcs
integer x = 1467
integer y = 280
integer width = 187
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To:"
boolean focusrectangle = false
end type

type st_start_date from statictext within w_customer_contacts_phcs
integer x = 1467
integer y = 152
integer width = 187
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From:"
boolean focusrectangle = false
end type

type dw_customer_list from u_dw_std within w_customer_contacts_phcs
integer x = 91
integer y = 148
integer width = 1211
integer height = 1028
integer taborder = 10
string dataobject = "d_customer_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
boolean i_multiselect = true
boolean i_retrieveonopen = true
boolean i_showempty = true
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize the datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/20/03 M. Caruso    Original Version
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_MultiSelect + c_selectOnClick)
end event

type gb_date_range from groupbox within w_customer_contacts_phcs
integer x = 1413
integer y = 32
integer width = 901
integer height = 384
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Range"
borderstyle borderstyle = stylelowered!
end type

type gb_select_customers from groupbox within w_customer_contacts_phcs
integer x = 41
integer y = 32
integer width = 1312
integer height = 1272
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Customers"
borderstyle borderstyle = stylelowered!
end type

