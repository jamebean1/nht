$PBExportHeader$w_date_parms.srw
$PBExportComments$Case Detial History Report parameter entry window.
forward
global type w_date_parms from w_response_std
end type
type dw_parameters from datawindow within w_date_parms
end type
type cb_cancel from u_cb_close within w_date_parms
end type
type cb_ok from u_cb_close within w_date_parms
end type
type st_1 from statictext within w_date_parms
end type
end forward

global type w_date_parms from w_response_std
integer width = 1307
integer height = 660
string title = ""
boolean controlmenu = false
dw_parameters dw_parameters
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
end type
global w_date_parms w_date_parms

type variables
S_REPORT_PARMS		is_ReportParms
BOOLEAN				ib_SetValues
STRING				i_cWindowTitle
end variables

on w_date_parms.create
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

on w_date_parms.destroy
call super::destroy
destroy(this.dw_parameters)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
end on

event pc_close;call super::pc_close;//**********************************************************************************************
//
//  Event:   pc_close
//  Purpose: Pass back the values set in this window
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/03/01 C. Jackson  Original Version
//**********************************************************************************************
  
message.PowerObjectParm = is_ReportParms
end event

event pc_closequery;//**********************************************************************************************
//
//  Event:   pc_closequery
//  Purpose: Determine the values to pass back from this window and prevent the window from
//           closing if the values are not valid.
//			  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------			  
//  10/03/01 C. Jackson  Original Version
//**********************************************************************************************

IF ib_SetValues THEN
	
		is_ReportParms.date_parm1 = dw_parameters.GetItemDateTime (1, 'start_date')
		is_ReportParms.date_parm2 = dw_parameters.GetItemDateTime (1, 'end_date')

ELSE
	
	setnull(is_ReportParms.date_parm1)

END IF


end event

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: Initialize the window and datawindow.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/03/01 C. Jackson  Original Version
//**********************************************************************************************

i_cWindowTitle = Message.StringParm
THIS.Title = i_cWindowTitle + ' Parameters'

dw_parameters.InsertRow (0)

end event

type dw_parameters from datawindow within w_date_parms
integer x = 233
integer y = 144
integer width = 1024
integer height = 236
integer taborder = 10
string title = "none"
string dataobject = "d_date_parms"
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
//	10/05/01 C. Jackson  Original Version
// 11/07/01 C. Jackson  Correct datatype for date columns
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

type cb_cancel from u_cb_close within w_date_parms
integer x = 910
integer y = 412
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//********************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell window to not pass parameters back to standard reports
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  10/08/01 C. Jackson  Original Version
//********************************************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	ib_SetValues = FALSE
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type cb_ok from u_cb_close within w_date_parms
integer x = 539
integer y = 412
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

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Pass back specified parameters
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/05/01 C. Jackson  Original Version
//  01/28/02 C. Jackson  Make sure the year is not before 1753.  It will fail in the SQL Query
//                       (SCR 2612)
//***********************************************************************************************

DATETIME l_dStartDate, l_dEndDate

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	dw_parameters.AcceptText ()
	
	// Validate the dates
	l_dStartDate = dw_parameters.GetItemDateTime(dw_parameters.GetRow(),'start_date')
	l_dEndDate = dw_parameters.GetItemDateTime(dw_parameters.GetRow(),'end_date')
	
	IF ISNULL(l_dStartDate)  THEN
		messagebox(gs_AppName,'Start Date is required.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('start_date')
		RETURN
	END IF
	
	IF ISNULL(l_dEndDate)  THEN
		messagebox(gs_AppName,'End Date is required')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('end_date')
		RETURN
	END IF

	IF DaysAfter(DATE(l_dStartDate), DATE(l_dEndDate)) < 0 THEN
		messagebox(gs_AppName,'The end date must be equal to or after the start date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('end_date')
		dw_parameters.SetItem(dw_parameters.GetRow(),'end_date','00/00/0000')
		RETURN
	END IF
	
	// Make sure the year is valid
	IF Year( Date( l_dStartDate ) ) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid start date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('start_date')
		dw_parameters.SetItem(dw_parameters.GetRow(),'start_date','00/00/0000')
		RETURN
	END IF
	
	IF Year( Date( l_dEndDate ) ) < 1753 THEN
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

type st_1 from statictext within w_date_parms
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

