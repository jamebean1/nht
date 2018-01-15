$PBExportHeader$w_tot_contact_parms.srw
$PBExportComments$Gets a date range from the user
forward
global type w_tot_contact_parms from window
end type
type st_4 from statictext within w_tot_contact_parms
end type
type em_end_date from editmask within w_tot_contact_parms
end type
type st_2 from statictext within w_tot_contact_parms
end type
type cb_cancel from commandbutton within w_tot_contact_parms
end type
type cb_ok from commandbutton within w_tot_contact_parms
end type
type st_1 from statictext within w_tot_contact_parms
end type
type em_start_date from editmask within w_tot_contact_parms
end type
end forward

global type w_tot_contact_parms from window
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
global w_tot_contact_parms w_tot_contact_parms

type variables
S_REPORT_PARMS	is_Parms
end variables

on w_tot_contact_parms.create
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

on w_tot_contact_parms.destroy
destroy(this.st_4)
destroy(this.em_end_date)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.em_start_date)
end on

event close;//********************************************************************************************
//
//  Event:   close
//  Purpose: put parms into message object
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  11/20/02 C. Jackson  Original Vesion
//********************************************************************************************

message.PowerObjectParm = is_Parms
end event

type st_4 from statictext within w_tot_contact_parms
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

type em_end_date from editmask within w_tot_contact_parms
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

type st_2 from statictext within w_tot_contact_parms
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

type cb_cancel from commandbutton within w_tot_contact_parms
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

type cb_ok from commandbutton within w_tot_contact_parms
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

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: validation of arguments
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  11/20/02 C. Jackson  Original Version
//************************************************************************************************

STRING	ls_start_date, ls_end_date, ls_return, ls_msg
DATETIME     ld_start_date, ld_end_date
BOOLEAN	lb_success

ls_start_date = em_start_date.text
ls_end_date = em_end_date.text

ld_start_date = DateTime (Date (ls_start_date), Time ("00:00:00.000"))
ld_end_date = DateTime (Date (ls_end_date), Time ("23:59:59.999"))


IF IsDate(ls_start_date) THEN
	IF IsDate(ls_end_date) THEN
		// Make sure the date range is no more than 6 months
		IF DaysAfter(DATE(ld_start_date), DATE(ld_end_date)) > 180 THEN
			ls_msg = "Date range cannot be greater than 180 days."
			em_end_date.SetFocus()
			lb_Success = FALSE
		ELSE
 			lb_Success = TRUE
		END IF
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

IF lb_success THEN
	is_Parms.date_parm1 = ld_start_date
	is_Parms.date_parm2 = ld_end_date
	Close (PARENT)
ELSE
	MessageBox(gs_AppName, ls_msg, Stopsign!)
END IF

end event

type st_1 from statictext within w_tot_contact_parms
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

type em_start_date from editmask within w_tot_contact_parms
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

