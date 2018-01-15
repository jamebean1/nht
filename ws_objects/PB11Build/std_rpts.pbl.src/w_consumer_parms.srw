$PBExportHeader$w_consumer_parms.srw
$PBExportComments$Case Detial History Report parameter entry window.
forward
global type w_consumer_parms from w_response_std
end type
type dw_parameters from datawindow within w_consumer_parms
end type
type cb_cancel from u_cb_close within w_consumer_parms
end type
type cb_ok from u_cb_close within w_consumer_parms
end type
type st_1 from statictext within w_consumer_parms
end type
end forward

global type w_consumer_parms from w_response_std
integer width = 1481
integer height = 692
string title = "Member Profile Report Parameters"
boolean controlmenu = false
dw_parameters dw_parameters
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
end type
global w_consumer_parms w_consumer_parms

type variables
S_REPORT_PARMS		is_ReportParms
BOOLEAN				ib_SetValues
end variables

forward prototypes
public function integer fw_validaterow (long row_nbr)
end prototypes

public function integer fw_validaterow (long row_nbr);//*******************************************************************************************
//
//  Event:   fw_validaterow
//  Purpose: Validate data
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------
//  10/08/01 C. Jackson  Original Version
//*******************************************************************************************

DATE		ld_date1, ld_date2
STRING	ls_msg, ls_colname
BOOLEAN	lb_Continue = TRUE

IF ib_setvalues THEN

	IF IsNull (dw_parameters.GetItemString (row_nbr, 'case_status')) THEN
		ls_msg = 'You need to select a case status.'
		ls_colname = 'case_status'
		lb_Continue = FALSE
	END IF
	
	IF lb_Continue THEN
		IF IsNull (dw_parameters.GetItemString (row_nbr, 'source_type')) AND lb_Continue THEN
			ls_msg = 'You need to select a source type.'
			ls_colname = 'source_type'
			lb_Continue = FALSE
		END IF
	END IF
	
	IF lb_Continue THEN
		ld_date1 = dw_parameters.GetItemDate (row_nbr, 'start_date')
		IF IsNull (ld_date1) AND lb_Continue THEN
			ls_msg = 'You need to specify a start date.'
			ls_colname = 'start_date'
			lb_Continue = FALSE
		ELSE
			IF NOT IsDate (STRING (ld_date1)) AND lb_Continue THEN
				ls_msg = 'Please enter a valid start date.'
				ls_colname = 'start_date'
				lb_Continue = FALSE
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

on w_consumer_parms.create
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

on w_consumer_parms.destroy
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
////**********************************************************************************************

IF ib_SetValues THEN
		
		is_ReportParms.date_parm1 = dw_parameters.GetItemDateTime (1, 'start_date')
		is_ReportParms.string_parm1 = dw_parameters.GetItemString (1, 'member_id')
		
ELSE
	
	is_ReportParms.string_parm1 = ''

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

dw_parameters.InsertRow (0)

end event

type dw_parameters from datawindow within w_consumer_parms
integer x = 233
integer y = 144
integer width = 1093
integer height = 236
integer taborder = 10
string title = "none"
string dataobject = "d_consumer_parms"
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
//	12/04/01 C. Jackson  Original Version
//*********************************************************************************************
	
INTEGER	l_nX, l_nY, l_nHeight
DATETIME	l_dtValue
STRING	l_cValue, l_cParm, l_cX, l_cY

// set focus to the column associated with the selected button
SetColumn ('start_date')

// Get the button's dimensions to position the calendar window
l_nX = Integer (dwo.X) + dw_parameters.X + PARENT.X
l_nY = Integer (dwo.Y) + Integer (dwo.Height) + dw_parameters.Y + PARENT.Y
l_cX = String (l_nX)
l_cY = String (l_nY)

// open the calendar window
AcceptText ()
l_dtValue = GetItemDateTime (row, 'start_date')
l_cParm = (String (Date (l_dtValue), "mm/dd/yyyy")+"&"+l_cX+"&"+l_cY)
FWCA.MGR.fu_OpenWindow (w_calendar, l_cParm)

// Get the date passed back
l_cValue = Message.StringParm

// If it's a date, convert to a datetime and update the field.
IF IsDate (l_cValue) THEN
	l_dtValue = DateTime (Date (l_cValue), Time ("00:00:00.000"))
	SetItem (row, 'start_date', l_dtValue)
ELSE
	SetNull( l_dtValue )
	THIS.SetItem( row, 'start_date', l_dtValue )
END IF
end event

type cb_cancel from u_cb_close within w_consumer_parms
integer x = 1102
integer y = 440
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

event clicked;//*******************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell window to not pass the parameters back to the Standard Reports
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------
//  10/08/01 C. Jackson  Original Version
//*******************************************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	ib_SetValues = FALSE
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type cb_ok from u_cb_close within w_consumer_parms
integer x = 731
integer y = 440
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

event clicked;//*******************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell window to pass the specified parameters back to the standard reports
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------
//  10/08/01 C. Jackson  Original Version
//  11/30/01 C. Jackson  Add data validation (SCR 2535)
//  01/28/02 C. Jackson  Make sure the year is not before 1753.  It will fail in the SQL Query 
//                       SCR 2612)
//  4/11/2002 K. Claver  Moved the value assignment to l_dStartDate outside of the if-then
//								 construct to ensure that the value is assigned.
//*******************************************************************************************

DATETIME	 l_dtStartDate
DATE   l_dStartDate
LONG   l_nRow

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	dw_parameters.AcceptText ()
	
	l_nRow = dw_parameters.GetRow()
	
	l_dtStartDate = dw_parameters.GetItemDateTime(l_nRow,'start_date')
	l_dStartDate = DATE(l_dtStartDate)
	
	IF IsNull(l_dtStartDate) THEN
		messagebox(gs_AppName,'Please enter a Start Date to report on.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('start_date')
	
	ELSEIF YEAR(l_dStartDate) < 1753 THEN
		messagebox(gs_AppName,'Year cannot be prior to 1753.  Please enter a valid Start Date.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('start_date')
		
	ELSEIF IsNull(dw_parameters.GetItemString (1, 'member_id')) THEN
		messagebox(gs_AppName,'Please enter a Member ID to report on.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('member_id')
		
	ELSE
	
		ib_SetValues = TRUE
		Close(FWCA.MGR.i_WindowCurrent)
	END IF
	
END IF


end event

type st_1 from statictext within w_consumer_parms
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

