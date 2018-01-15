$PBExportHeader$w_std_rpt_date_range.srw
$PBExportComments$Gets a date range from the user
forward
global type w_std_rpt_date_range from window
end type
type st_4 from statictext within w_std_rpt_date_range
end type
type em_end_date from editmask within w_std_rpt_date_range
end type
type st_2 from statictext within w_std_rpt_date_range
end type
type cb_cancel from commandbutton within w_std_rpt_date_range
end type
type cb_ok from commandbutton within w_std_rpt_date_range
end type
type st_1 from statictext within w_std_rpt_date_range
end type
type em_start_date from editmask within w_std_rpt_date_range
end type
end forward

global type w_std_rpt_date_range from window
integer x = 832
integer y = 356
integer width = 1207
integer height = 672
boolean titlebar = true
string title = "Parameter Required"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79748288
st_4 st_4
em_end_date em_end_date
st_2 st_2
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
em_start_date em_start_date
end type
global w_std_rpt_date_range w_std_rpt_date_range

type variables
S_REPORT_PARMS	is_Parms
end variables

on w_std_rpt_date_range.create
this.st_4=create st_4
this.em_end_date=create em_end_date
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.em_start_date=create em_start_date
this.Control[]={this.st_4,&
this.em_end_date,&
this.st_2,&
this.cb_cancel,&
this.cb_ok,&
this.st_1,&
this.em_start_date}
end on

on w_std_rpt_date_range.destroy
destroy(this.st_4)
destroy(this.em_end_date)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.em_start_date)
end on

event close;/*****************************************************************************************
   Event:      pc_Close
   Purpose:    Pass back the values set in this window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/17/00  M. Caruso    Created.
*****************************************************************************************/

message.PowerObjectParm = is_Parms
end event

type st_4 from statictext within w_std_rpt_date_range
integer x = 50
integer y = 48
integer width = 1015
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Please enter the following information:"
boolean focusrectangle = false
end type

type em_end_date from editmask within w_std_rpt_date_range
integer x = 608
integer y = 252
integer width = 430
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

on getfocus;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			em_year
		Event:			getfocus
		Abstract:		Select the text when this edit gets focus
----------------------------------------------------------------------------------------*/

THIS.SelectText(1,Len(THIS.Text))
end on

type st_2 from statictext within w_std_rpt_date_range
integer x = 224
integer y = 260
integer width = 334
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "End Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_std_rpt_date_range
integer x = 759
integer y = 404
integer width = 279
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: Close Parent window
//  
//  Date     Developer    Description
//  -------- ------------ ------------------------------------------------------------------------
//  04/05/01 C. Jackson   Add setting of cancelled flag
//
//************************************************************************************************

DATETIME ldt_Null

SetNull (ldt_Null)

is_Parms.date_parm1 = ldt_Null
is_Parms.date_parm2 = ldt_Null
Close (PARENT)
end event

type cb_ok from commandbutton within w_std_rpt_date_range
integer x = 443
integer y = 404
integer width = 279
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;/*----------------------------------------------------------------------------------------
		Application:	Customer Focus 2.6

		Object:			cb_ok
		Event:			clicked
		Abstract:		Close the parent window and return the formatted date string
		
		Revisions:
		Date     Developer     Description
		======== ============= =============================================================
		1/1/00   M. Caruso     Modified function to work with two date fields.  Returns the
		                       start and end dates in a comma-delimited string.
----------------------------------------------------------------------------------------*/
STRING	ls_start_date, ls_end_date, ls_return, ls_msg
BOOLEAN	lb_success

ls_start_date = em_start_date.text
ls_end_date = em_end_date.text

IF IsDate(ls_start_date) THEN
	IF IsDate(ls_end_date) THEN
		lb_Success = TRUE
	ELSE
		ls_msg = "Please enter a valid end date before continuing."
		em_end_date.SetFocus()
		lb_Success = FALSE
	END IF
ELSE
	ls_msg = "Please enter a valid start date before continuing."
	em_start_date.SetFocus()
	lb_Success = FALSE
END IF

//IF NOT IsDate(ls_start_date) THEN
// 	MessageBox(FWCA.MGR.i_ApplicationName,"Please enter a valid date before continuing.",Stopsign!)
//	em_start_date.SetFocus()
//	RETURN
//ELSE
//	IF NOT IsDate(ls_end_date) THEN
//		MessageBox(FWCA.MGR.i_ApplicationName,"Please enter a valid date before continuing.",Stopsign!)
//		em_end_date.SetFocus()
//		RETURN
//	END IF
//END IF

IF lb_success THEN
	is_Parms.date_parm1 = DATETIME (DATE (ls_start_date))
	is_Parms.date_parm2 = DATETIME (DATE (ls_end_date), TIME ("23:59:59.999999"))
	Close (PARENT)
ELSE
	MessageBox(gs_AppName, ls_msg, Stopsign!)
END IF

end event

type st_1 from statictext within w_std_rpt_date_range
integer x = 224
integer y = 148
integer width = 334
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Start Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_start_date from editmask within w_std_rpt_date_range
integer x = 608
integer y = 136
integer width = 430
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

on getfocus;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			em_year
		Event:			getfocus
		Abstract:		Select the text when this edit gets focus
----------------------------------------------------------------------------------------*/

THIS.SelectText(1,Len(THIS.Text))
end on

