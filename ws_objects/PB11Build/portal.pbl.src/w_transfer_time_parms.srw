$PBExportHeader$w_transfer_time_parms.srw
$PBExportComments$Gets start date, end date, and consumer id from the user
forward
global type w_transfer_time_parms from w_response_std
end type
type st_1 from statictext within w_transfer_time_parms
end type
type cb_ok from u_cb_close within w_transfer_time_parms
end type
type cb_cancel from u_cb_close within w_transfer_time_parms
end type
type dw_parameters from datawindow within w_transfer_time_parms
end type
end forward

global type w_transfer_time_parms from w_response_std
integer width = 1330
integer height = 1088
string title = "Transfer Time Report Parms"
boolean controlmenu = false
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
dw_parameters dw_parameters
end type
global w_transfer_time_parms w_transfer_time_parms

type variables
S_REPORT_PARMS		is_ReportParms
BOOLEAN				ib_SetValues

end variables

forward prototypes
public function integer fw_validaterow (long row_nbr)
end prototypes

public function integer fw_validaterow (long row_nbr);//**********************************************************************************************
//
//  Event:   fw_validaterow
//  Purpose: Validate the data entered.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/20/04 C. Haxel    Original Version
//**********************************************************************************************


DATE		ld_date1, ld_date2
STRING	ls_msg, ls_colname
LONG     l_nCount
BOOLEAN	lb_Continue = TRUE

IF ib_setvalues THEN

	IF IsNull (dw_parameters.GetItemString (row_nbr, 'all_cases')) THEN
		ls_msg = 'Please enter Transferred or All'
		ls_colname = 'all_cases'
		lb_Continue = FALSE
	END IF
	
	IF lb_Continue THEN
		ld_date1 = DATE(dw_parameters.GetItemDateTime (row_nbr, 'start_date'))
		IF IsNull (ld_date1) AND lb_Continue THEN
			ls_msg = 'Please enter a Start Date.'
			ls_colname = 'start_date'
			lb_Continue = FALSE
		ELSE
			IF NOT IsDate (STRING (ld_date1)) AND lb_Continue THEN
				ls_msg = 'Please enter a valid Start Date.'
				ls_colname = 'start_date'
				lb_Continue = FALSE
			END IF
		END IF
	END IF
	
	IF lb_Continue THEN
		ld_date2 = DATE(dw_parameters.GetItemDateTime (row_nbr, 'end_date'))
		IF IsNull (ld_date2) THEN
			ls_msg = 'Please enter an End Date.'
			ls_colname = 'end_date'
			lb_Continue = FALSE
		ELSE
			IF NOT IsDate (STRING (ld_date2)) THEN
				ls_msg = 'Please enter a valid End Date.'
				ls_colname = 'end_date'
				lb_Continue = FALSE
			ELSE
				IF ld_date1 > ld_date2 THEN
					ls_msg = 'The End Date must be equal to or after the Start Date.'
					ls_colname = 'end_date'
					lb_Continue = FALSE
				END IF
			END IF
		END IF
	END IF

ELSE
	
	lb_continue = TRUE
	
END IF

IF lb_Continue THEN
	RETURN 0
ELSE
	MessageBox (gs_AppName, ls_msg)
	dw_parameters.SetColumn (ls_colname)
	RETURN -1
END IF


end function

on w_transfer_time_parms.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_parameters=create dw_parameters
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_parameters
end on

on w_transfer_time_parms.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_parameters)
end on

event pc_close;call super::pc_close;//**********************************************************************************************
//  Event:   pc_Close
//  Purpose: Pass back the values set in this window.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/20/04 C. Haxel    Original Version
//  
//**********************************************************************************************

message.PowerObjectParm = is_ReportParms
end event

event pc_closequery;//*****************************************************************************************
//
//  Event:   pc_CloseQuery
//  Purpose: Determine the values to pass back from this window and prevent the window
//           from closing if the values are not valid.
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  10/20/04 C. Haxel    Original Verion
//*****************************************************************************************
STRING ls_value, ls_null
DATE l_dEndDate
BOOLEAN	lb_Close = TRUE

SetNull(ls_null)

IF ib_SetValues THEN
	
	IF fw_validaterow (1) = 0 THEN
		
		is_ReportParms.date_parm1 = DATETIME (dw_parameters.GetItemDateTime (1, 'start_date'))
		l_dEndDate = DATE(dw_parameters.GetItemDateTime(1, 'end_date'))
		is_ReportParms.date_parm2 = DATETIME (l_dEndDate, TIME ('23:59:59.999999'))
		is_ReportParms.string_parm1 = dw_parameters.GetItemString (1, 'all_cases')
		ls_value = dw_parameters.GetItemString(1, 'category')
		IF ls_value = '0' or ls_value = '-1' THEN
			is_ReportParms.string_parm2 = ls_null
		ELSE
			is_ReportParms.string_parm2 = ls_value
		END IF
		ls_value = dw_parameters.GetItemString(1, 'source')
		IF ls_value = 'X' THEN
			is_ReportParms.string_parm3 = ls_null
		ELSE
			is_ReportParms.string_parm3 = ls_value
		END IF
		ls_value = dw_parameters.GetItemString(1, 'case_type')
		IF ls_value = '0' OR ls_value = '-1' THEN
			is_ReportParms.string_parm4 = ls_null
		ELSE
			is_ReportParms.string_parm4 = ls_value
		END IF
		ls_value = dw_parameters.GetItemString(1, 'dept')
		IF ls_value = '0' OR ls_value = '-1' THEN
			is_ReportParms.string_parm5 = ls_null
		ELSE
			is_ReportParms.string_parm5 = ls_value
		END IF
		ls_value = dw_parameters.GetItemString(1, 'user')
		IF ls_value = '0' OR ls_value = '-1' THEN
			is_ReportParms.string_parm6 = ls_null
		ELSE
			is_ReportParms.string_parm6 = ls_value
		END IF
	ELSE
		
		lb_Close = FALSE
		
	END IF
	
ELSE
	
	SetNull (is_ReportParms.date_parm1)
	SetNull (is_ReportParms.date_parm2)
	SetNull (is_ReportParms.num_parm1)
	SetNull (is_ReportParms.string_parm1)
	SetNull (is_ReportParms.string_parm2)
	SetNull (is_ReportParms.string_parm3)
	SetNull (is_ReportParms.string_parm4)
	SetNull (is_ReportParms.string_parm5)
	SetNull (is_ReportParms.string_parm6)
	
END IF

IF lb_Close THEN
	Error.i_FWError = c_Success
ELSE
	Error.i_FWError = c_Fatal
	dw_parameters.SetFocus ()
END IF


end event

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//
//  Event:   pc_SetOptions
//  Purpose: Initialize the window and datawindow.
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/20/04 C. Haxel    Oringal Version
//***********************************************************************************************


DATAWINDOWCHILD	ldwc_FieldList

dw_parameters.InsertRow (0)

ldwc_FieldList.SetItem (1, 'all_cases', 'Y')

IF dw_parameters.GetChild ('category', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	IF ldwc_FieldList.Retrieve () > 0 THEN
		ldwc_FieldList.InsertRow (1)
		ldwc_FieldList.SetItem (1, 'category_id', '0')
		ldwc_FieldList.SetItem (1, 'category_name', '(All)')
		dw_parameters.SetItem (1, 'category', '0')
	ELSE
		ldwc_FieldList.InsertRow (0)
		ldwc_FieldList.SetItem (1, 'category_id', '-1')
		ldwc_FieldList.SetItem (1, 'category_name', '(None)')
		dw_parameters.SetItem (1, 'category', '-1')
	END IF
	
END IF

IF dw_parameters.GetChild ('case_type', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	IF ldwc_FieldList.Retrieve () > 0 THEN
		ldwc_FieldList.InsertRow (1)
		ldwc_FieldList.SetItem (1, 'case_type', '0')
		ldwc_FieldList.SetItem (1, 'case_type_desc', '(All)')
		dw_parameters.SetItem (1, 'case_type', '0')
	ELSE
		ldwc_FieldList.InsertRow (0)
		ldwc_FieldList.SetItem (1, 'case_type', '-1')
		ldwc_FieldList.SetItem (1, 'case_type_desc', '(None)')
		dw_parameters.SetItem (1, 'case_type', '-1')
	END IF
	
END IF

IF dw_parameters.GetChild ('source', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	IF ldwc_FieldList.Retrieve () > 0 THEN
		ldwc_FieldList.InsertRow (1)
		ldwc_FieldList.SetItem (1, 'source_type', 'X')
		ldwc_FieldList.SetItem (1, 'source_desc', '(All)')
		dw_parameters.SetItem (1, 'source', 'X')
	ELSE
		ldwc_FieldList.InsertRow (0)
		ldwc_FieldList.SetItem (1, 'source_type', 'X')
		ldwc_FieldList.SetItem (1, 'source_desc', '(None)')
		dw_parameters.SetItem (1, 'source', 'X')
	END IF
	
END IF

IF dw_parameters.GetChild ('dept', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	IF ldwc_FieldList.Retrieve () > 0 THEN
		ldwc_FieldList.InsertRow (1)
		ldwc_FieldList.SetItem (1, 'user_dept_id', '0')
		ldwc_FieldList.SetItem (1, 'dept_desc', '(All)')
		dw_parameters.SetItem (1, 'dept', '0')
	ELSE
		ldwc_FieldList.InsertRow (0)
		ldwc_FieldList.SetItem (1, 'user_dept_id', '-1')
		ldwc_FieldList.SetItem (1, 'dept_desc', '(None)')
		dw_parameters.SetItem (1, 'dept', '-1')
	END IF
	
END IF

IF dw_parameters.GetChild ('user', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	IF ldwc_FieldList.Retrieve () > 0 THEN
		ldwc_FieldList.InsertRow (1)
		ldwc_FieldList.SetItem (1, 'user_id', '0')
		ldwc_FieldList.SetItem (1, 'name', '(All)')
		dw_parameters.SetItem (1, 'user', '0')
	ELSE
		ldwc_FieldList.InsertRow (0)
		ldwc_FieldList.SetItem (1, 'user_id', '-1')
		ldwc_FieldList.SetItem (1, 'name', '(None)')
		dw_parameters.SetItem (1, 'user', '-1')
	END IF
	
END IF

// Set Window Title according to report selected
THIS.Title = Message.StringParm + ' Parameters'
end event

type st_1 from statictext within w_transfer_time_parms
integer x = 32
integer y = 32
integer width = 1134
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please enter the following information:"
boolean focusrectangle = false
end type

type cb_ok from u_cb_close within w_transfer_time_parms
integer x = 590
integer y = 912
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell the window to pass the specified parameters back to Standard Reports.
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/20/04 C. Haxel    Original Version
//***********************************************************************************************
  
DATETIME l_dtStartDate, l_dtEndDate

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	dw_parameters.AcceptText ()
	
	l_dtStartDate = dw_parameters.GetItemDateTime(1,'start_date')
	IF ISNULL(l_dtStartDate)  THEN
		messagebox(gs_AppName,'Start Date is required.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('start_date')
		RETURN
	END IF
	
	l_dtEndDate = dw_parameters.GetItemDateTime(1,'end_date')
	IF ISNULL(l_dtEndDate)  THEN
		messagebox(gs_AppName,'End Date is required')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('end_date')
		RETURN
	END IF
	
	// Validate the dates
	IF DaysAfter(DATE(l_dtStartDate), DATE(l_dtEndDate)) < 0 THEN
		messagebox(gs_AppName,'The end date must be greater than the start date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('end_date')
		dw_parameters.SetItem(dw_parameters.GetRow(),'end_date','00/00/0000')
		RETURN
	END IF
	
	IF Year( Date( l_dtStartDate ) ) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid start date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('start_date')
		dw_parameters.SetItem(dw_parameters.GetRow(),'start_date','00/00/0000')
		RETURN
	END IF

	IF Year( Date( l_dtEndDate ) ) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid end date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('end_date')
		dw_parameters.SetItem(dw_parameters.GetRow(),'end_date','00/00/0000')
		RETURN
	END IF

	ib_SetValues = TRUE
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type cb_cancel from u_cb_close within w_transfer_time_parms
integer x = 914
integer y = 912
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell the window to not pass the parameters back to Standard Reports.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/20/04 C. Haxel    Original Version
//***********************************************************************************************


IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	ib_SetValues = FALSE
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type dw_parameters from datawindow within w_transfer_time_parms
integer x = 64
integer y = 112
integer width = 1202
integer height = 768
integer taborder = 10
string title = "none"
string dataobject = "d_transfer_time_parms"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;/****************************************************************************************

	Event:	buttonclicked
	Purpose:	Please see PB documentation for this event
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	4/10/2001 K. Claver    Added code to process the button clicked events

****************************************************************************************/
INTEGER	l_nX, l_nY, l_nHeight
DATETIME	l_dtValue
STRING	l_cValue, l_cParm, l_cX, l_cY, l_cColName

CHOOSE CASE dwo.name
	CASE 'b_calendar_from'
		l_cColName = 'start_date'
		
	CASE 'b_calendar_to'
		l_cColName = 'end_date'
		
END CHOOSE

// set focus to the column associated with the selected button
SetColumn (l_cColName)

// Get the button's dimensions to position the calendar window
l_nX = Integer (dwo.X) + dw_parameters.X + PARENT.X
l_nY = Integer (dwo.Y) + Integer (dwo.Height) + dw_parameters.Y + PARENT.Y
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
	SetItem (row, l_cColName, l_dtValue)
ELSE
	SetNull( l_dtValue )
	THIS.SetItem( row, l_cColName, l_dtValue )
END IF
end event

