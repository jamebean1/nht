$PBExportHeader$w_inquiry_sampling_vt.srw
$PBExportComments$Vermont Parameter window for Inquiry Sampling report
forward
global type w_inquiry_sampling_vt from w_response_std
end type
type dw_parameters from datawindow within w_inquiry_sampling_vt
end type
type cb_cancel from u_cb_close within w_inquiry_sampling_vt
end type
type cb_ok from u_cb_close within w_inquiry_sampling_vt
end type
type st_1 from statictext within w_inquiry_sampling_vt
end type
end forward

global type w_inquiry_sampling_vt from w_response_std
integer width = 1518
integer height = 1212
string title = "Inquiry Sampling Report Parameters"
boolean controlmenu = false
dw_parameters dw_parameters
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
end type
global w_inquiry_sampling_vt w_inquiry_sampling_vt

type variables
S_REPORT_PARMS		i_sReportParms
BOOLEAN				ib_SetValues
end variables

on w_inquiry_sampling_vt.create
int iCurrent
call super::create
this.dw_parameters=create dw_parameters
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_parameters
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.st_1
end on

on w_inquiry_sampling_vt.destroy
call super::destroy
destroy(this.dw_parameters)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
end on

event pc_close;call super::pc_close;//**********************************************************************************************
//
//  Event:   pc_close
//  Purpose: Pass back the values set in this datawindow.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/14/01 C. Jackson  Original Version
//  
//**********************************************************************************************
  
message.PowerObjectParm = i_sReportParms


end event

event open;call super::open;//***********************************************************************************************
//
//  Event:   open
//  Purpose: To build the parameters datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  05/16/01 C. Jackson  Original Version
//  
//***********************************************************************************************

DATAWINDOWCHILD	ldwc_FieldList

dw_parameters.InsertRow(0)

IF dw_parameters.GetChild ('line_of_business', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	ldwc_FieldList.Retrieve () 

END IF


IF dw_parameters.GetChild ('prnt_grp_id', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	ldwc_FieldList.Retrieve () 

END IF

IF dw_parameters.GetChild ('grp_id', ldwc_FieldList) = 1 THEN
	
	ldwc_FieldList.SetTransObject (SQLCA)
	ldwc_FieldList.Retrieve () 

END IF

end event

event pc_setoptions;call super::pc_setoptions;////************************************************************************************************
////
////  Event:   pc_setoptions
////  Purpose: to set options
////  
////  Date     Developer   Description
////  -------- ----------- ------------------------------------------------------------------------
////  05/14/01 C. Jackson  Original Version
////************************************************************************************************
//
//DATAWINDOWCHILD	ldwc_FieldList
//
//dw_parameters.InsertRow (0)
//IF dw_parameters.GetChild ('case_status', ldwc_FieldList) = 1 THEN
//	
//	ldwc_FieldList.SetTransObject (SQLCA)
//	IF ldwc_FieldList.Retrieve () > 0 THEN
//		ldwc_FieldList.InsertRow (1)
//		ldwc_FieldList.SetItem (1, 'case_status_id', '0')
//		ldwc_FieldList.SetItem (1, 'case_stat_desc', '(All)')
//		dw_parameters.SetItem (1, 'case_status', '0')
//	ELSE
//		ldwc_FieldList.InsertRow (0)
//		ldwc_FieldList.SetItem (1, 'case_status_id', '-1')
//		ldwc_FieldList.SetItem (1, 'case_stat_desc', '(None)')
//		dw_parameters.SetItem (1, 'case_status', '-1')
//	END IF
//	
//END IF
//
//IF dw_parameters.GetChild ('source_type', ldwc_FieldList) = 1 THEN
//	
//	ldwc_FieldList.SetTransObject (SQLCA)
//	IF ldwc_FieldList.Retrieve () > 0 THEN
//		ldwc_FieldList.InsertRow (1)
//		ldwc_FieldList.SetItem (1, 'source_type', '0')
//		ldwc_FieldList.SetItem (1, 'source_desc', '(All)')
//		dw_parameters.SetItem (1, 'source_type', '0')
//	ELSE
//		ldwc_FieldList.InsertRow (0)
//		ldwc_FieldList.SetItem (1, 'source_type', '-1')
//		ldwc_FieldList.SetItem (1, 'source_desc', '(None)')
//		dw_parameters.SetItem (1, 'source_type', '-1')
//	END IF
//	
//END IF
end event

event pc_closequery;call super::pc_closequery;//***********************************************************************************************
//
//  Event:   pc_closequery
//  Purpose: put values into report structure
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  05/14/01 C. Jackson  Original Version
//  
//***********************************************************************************************

IF ib_SetValues THEN
	
	
	i_sReportParms.string_parm1 = dw_parameters.GetItemString (1, 'subscriber_type')
	i_sReportParms.string_parm2 = dw_parameters.GetItemString (1, 'prnt_grp_id')
	i_sReportParms.string_parm3 = dw_parameters.GetItemString (1, 'grp_id')
	i_sReportParms.string_parm4 = dw_parameters.GetItemString (1, 'line_of_business')
	i_sReportParms.string_parm7 = dw_parameters.GetItemString (1, 'all_except_fep')
	i_sReportParms.date_parm1 = dw_parameters.GetItemDateTime (1, 'start_date')
	i_sReportParms.string_parm5 = STRING(i_sReportParms.date_parm1)
	i_sReportParms.date_parm2 = dw_parameters.GetItemDateTime (1, 'end_date')
	i_sReportParms.string_parm6 = STRING(i_sReportParms.date_parm2)
	i_sReportParms.num_parm1 = dw_parameters.GetItemNumber (1, 'number_to_sample')

ELSE
	
	i_sReportParms.string_parm1 = ''

END IF

end event

type dw_parameters from datawindow within w_inquiry_sampling_vt
integer x = 27
integer y = 100
integer width = 1445
integer height = 860
integer taborder = 10
string title = "none"
string dataobject = "d_inquiry_sampling_parms_vt"
boolean border = false
boolean livescroll = true
end type

event buttonclicked;//*********************************************************************************************
//
//   Event:   buttonclicked
//	Purpose: Set the calendar buttons
//	
//	Date     Developer   Description
//	-------- ----------- ---------------------------------------------------------------------
//	12/05/01 C. Jackson  Original Version
//*********************************************************************************************
	
INTEGER	l_nX, l_nY, l_nHeight
DATETIME l_dtValue
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

event itemchanged;//*********************************************************************************************
//
// Event:   itemchanged
//	
//	Date     Developer   Description
//	-------- ----------- ---------------------------------------------------------------------
//	11/04/02 C. Jackson  Enable/Disable Line of Business if All Except FEP is selected
//*********************************************************************************************

CONSTANT	LONG	l_nColorOn = 16777215
CONSTANT	LONG	l_nColorOff = 79741120


IF dwo.name = 'all_except_fep' THEN
	
	IF data = 'Y' THEN
	
		THIS.SetTabOrder ( 8, 0 )
		THIS.Object.line_of_business.background.color = l_nColorOff
	
	ELSE
		
		THIS.SetTabOrder ( 8 , 50 )
		THIS.Object.line_of_business.background.color = l_nColorOn
		
	END IF
	
END IF



end event

type cb_cancel from u_cb_close within w_inquiry_sampling_vt
integer x = 1134
integer y = 980
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell the window not to pass the parameters back to the report
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/14/01 C. Jackson  Original Version
//  8/2/2001 K. Claver   Added code to check if the w_supervisor_reports window is valid
//								 before attempting to modify the instance variable.
//  
//**********************************************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	IF IsValid( w_supervisor_reports ) THEN
		w_supervisor_reports.i_bReportCancel = TRUE
	END IF
	
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type cb_ok from u_cb_close within w_inquiry_sampling_vt
integer x = 763
integer y = 980
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell the window to pass the specified parameters back to Standard Reports.
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/14/01 C. Jackson  Original Version
//  12/10/01 C. Jackson  Add Date validation (SCR 2525)
//  01/28/02 C. Jackson  Error message if year is less than 1753.  It will fail in the database
//                       query (SCR 2612)  
//**********************************************************************************************

STRING l_cSubscriber
DATETIME l_dtStartDate, l_dtEndDate
LONG l_nNumToSample

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	dw_parameters.AcceptText ()
	
	l_cSubscriber = dw_parameters.GetItemString(1,'subscriber_type')
	IF ISNULL(l_cSubscriber) THEN
		messagebox(gs_AppName,'Please select a Subscriber Type.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('subscriber_type')
		RETURN
	END IF
	
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
	
	IF YEAR(DATE(l_dtStartDate)) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid start date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('start_date')
		dw_parameters.SetItem(dw_parameters.GetRow(),'start_date','00/00/0000')
		RETURN
	END IF

	IF YEAR(DATE(l_dtEndDate)) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid end date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('end_date')
		dw_parameters.SetItem(dw_parameters.GetRow(),'end_date','00/00/0000')
		RETURN
	END IF
	
	l_nNumToSample = dw_parameters.GetItemNumber(1,'number_to_sample')
	IF ISNULL(l_nNumToSample) OR STRING(l_nNumToSample) = '' OR l_nNumToSample <= 0 THEN
		messagebox(gs_AppName,'A valid Interval is required.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('number_to_sample')
		RETURN
	END IF
	
	
	ib_SetValues = TRUE
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type st_1 from statictext within w_inquiry_sampling_vt
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

