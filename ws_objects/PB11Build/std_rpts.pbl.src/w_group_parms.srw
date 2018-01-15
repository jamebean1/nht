$PBExportHeader$w_group_parms.srw
$PBExportComments$Case Detial History Report parameter entry window.
forward
global type w_group_parms from w_response_std
end type
type dw_parameters from datawindow within w_group_parms
end type
type cb_cancel from u_cb_close within w_group_parms
end type
type cb_ok from u_cb_close within w_group_parms
end type
type st_1 from statictext within w_group_parms
end type
end forward

global type w_group_parms from w_response_std
integer width = 1271
integer height = 648
string title = "Member Profile Report Parameters"
boolean controlmenu = false
dw_parameters dw_parameters
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
end type
global w_group_parms w_group_parms

type variables
S_REPORT_PARMS		is_ReportParms
BOOLEAN				ib_SetValues
STRING				i_cWindowTitle
end variables

on w_group_parms.create
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

on w_group_parms.destroy
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
		
		is_ReportParms.string_parm1 = dw_parameters.GetItemString (1, 'group_id')
		is_ReportParms.string_parm2 = dw_parameters.GetItemString (1, 'year')
		
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

i_cWindowTitle = Message.StringParm
THIS.Title = i_cWindowTitle + ' Parameters'

dw_parameters.InsertRow (0)

end event

type dw_parameters from datawindow within w_group_parms
integer x = 27
integer y = 132
integer width = 1216
integer height = 236
integer taborder = 10
string title = "none"
string dataobject = "d_group_parms"
boolean border = false
boolean livescroll = true
end type

type cb_cancel from u_cb_close within w_group_parms
integer x = 878
integer y = 396
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

event clicked;//*********************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell the window not not pass the parameters back to the report.
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  10/08/01 C. Jackson  Original Version
//*********************************************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	ib_SetValues = FALSE
	Close(FWCA.MGR.i_WindowCurrent)
	
END IF
end event

type cb_ok from u_cb_close within w_group_parms
integer x = 507
integer y = 396
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

event clicked;//*********************************************************************************************
//
//  Event:   clicked
//  Purpose: Tell the window to pass the specified parameters back to the report.
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  10/08/01 C. Jackson  Original Version
//  11/27/01 C. Jackson  Add data validation (SCR 2530)
//  01/28/02 C. Jackson  Do not allow reporting on a year less than 1753.  It will faill in the
//                       Query on the database side. (SCR 2612)
//*********************************************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
	
	dw_parameters.AcceptText ()
	
	IF IsNull(dw_parameters.GetItemString (1, 'year')) THEN
		messagebox(gs_AppName,'Please enter a Year to report on.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('year')
		
	ELSEIF long(dw_parameters.GetItemString (1, 'year')) < 1753 THEN
		messagebox(gs_AppName,'Please enter a valid Year.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('year')
		
	ELSEIF IsNull(dw_parameters.GetItemString (1, 'group_id')) THEN
		messagebox(gs_AppName,'Please enter a Group ID to report on.')
		dw_parameters.SetFocus()
		dw_parameters.SetColumn('group_id')
		
	ELSE
	
		ib_SetValues = TRUE
		Close(FWCA.MGR.i_WindowCurrent)
	END IF
	
END IF




end event

type st_1 from statictext within w_group_parms
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

