$PBExportHeader$w_critical_parms.srw
$PBExportComments$Gets start date, end date, and consumer id from the user
forward
global type w_critical_parms from w_response_std
end type
type st_1 from statictext within w_critical_parms
end type
type cb_ok from u_cb_close within w_critical_parms
end type
type cb_cancel from u_cb_close within w_critical_parms
end type
type dw_parameters from datawindow within w_critical_parms
end type
end forward

global type w_critical_parms from w_response_std
integer width = 1198
integer height = 888
string title = "Critical X Analysis Parameters"
boolean controlmenu = false
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
dw_parameters dw_parameters
end type
global w_critical_parms w_critical_parms

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
//  07/19/01 C. Jackson  Original Version
//  12/18/01 C. Jackson  Case Count is required (SCR 2464)
//**********************************************************************************************


DATE		ld_date1, ld_date2
STRING	ls_msg, ls_colname
LONG     l_nCount
BOOLEAN	lb_Continue = TRUE

IF ib_setvalues THEN

	IF IsNull (dw_parameters.GetItemString (row_nbr, 'case_type')) THEN
		ls_msg = 'Please enter a Case Type.'
		ls_colname = 'case_type'
		lb_Continue = FALSE
	END IF
	
	IF lb_Continue THEN
		IF IsNull (dw_parameters.GetItemString (row_nbr, 'case_status')) AND lb_Continue THEN
			ls_msg = 'Please enter a Case Status.'
			ls_colname = 'case_status'
			lb_Continue = FALSE
		END IF
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

	IF lb_Continue THEN
		l_nCount = dw_parameters.GetItemNumber (row_nbr, 'case_counts')
		IF IsNull (l_nCount) THEN
			ls_msg = 'Please enter a Case Count.'
			ls_colname = 'case_counts'
			lb_Continue = FALSE
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

on w_critical_parms.create
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

on w_critical_parms.destroy
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
//  07/19/01 C. Jackson  Original Version
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
//  07/19/01 C. Jackson  Original Version
//*****************************************************************************************

DATE l_dEndDate
BOOLEAN	lb_Close = TRUE

IF ib_SetValues THEN
	
	IF fw_validaterow (1) = 0 THEN
		
		is_ReportParms.date_parm1 = DATETIME (dw_parameters.GetItemDateTime (1, 'start_date'))
		l_dEndDate = DATE(dw_parameters.GetItemDateTime(1, 'end_date'))
		is_ReportParms.date_parm2 = DATETIME (l_dEndDate, TIME ('23:59:59.999999'))
		is_ReportParms.string_parm1 = dw_parameters.GetItemString (1, 'case_type')
		IF is_ReportParms.string_parm1 = '0' THEN
			is_ReportParms.string_parm1 = '(All)'
		END IF
		is_ReportParms.num_parm1 = dw_parameters.GetItemNumber(1,'case_counts')
		is_ReportParms.string_parm2 = dw_parameters.GetItemString (1, 'case_status')
		IF is_ReportParms.string_parm2 = '0' THEN
			is_ReportParms.string_parm2 = '(All)'
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
//  07/19/01 C. Jackson  Original Version
//***********************************************************************************************


DATAWINDOWCHILD	ldwc_FieldList

dw_parameters.InsertRow (0)
IF dw_parameters.GetChild ('case_status', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	IF ldwc_FieldList.Retrieve () > 0 THEN
		ldwc_FieldList.InsertRow (1)
		ldwc_FieldList.SetItem (1, 'case_status_id', '0')
		ldwc_FieldList.SetItem (1, 'case_stat_desc', '(All)')
		dw_parameters.SetItem (1, 'case_status', '0')
	ELSE
		ldwc_FieldList.InsertRow (0)
		ldwc_FieldList.SetItem (1, 'case_status_id', '-1')
		ldwc_FieldList.SetItem (1, 'case_stat_desc', '(None)')
		dw_parameters.SetItem (1, 'case_status', '-1')
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

// Set Window Title according to report selected
THIS.Title = Message.StringParm + ' Parameters'
end event

type st_1 from statictext within w_critical_parms
integer x = 32
integer y = 32
integer width = 1134
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please enter the following information:"
boolean focusrectangle = false
end type

type cb_ok from u_cb_close within w_critical_parms
integer x = 480
integer y = 656
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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
//  07/19/01 C. Jackson  Original Version
//  01/28/02 C. Jackson  Add date validation (SCR 2612)
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

type cb_cancel from u_cb_close within w_critical_parms
integer x = 805
integer y = 656
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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
//  07/19/01 C. Jackson  Original Version
//***********************************************************************************************


IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	ib_SetValues = FALSE
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type dw_parameters from datawindow within w_critical_parms
integer x = 64
integer y = 112
integer width = 992
integer height = 524
integer taborder = 10
string title = "none"
string dataobject = "d_critical_parms"
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

