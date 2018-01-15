$PBExportHeader$w_std_rpt_n_parms.srw
$PBExportComments$Gets a start date, end date, and group id from the user
forward
global type w_std_rpt_n_parms from window
end type
type st_5 from statictext within w_std_rpt_n_parms
end type
type st_3 from statictext within w_std_rpt_n_parms
end type
type sle_num from singlelineedit within w_std_rpt_n_parms
end type
type st_2 from statictext within w_std_rpt_n_parms
end type
type cb_cancel from commandbutton within w_std_rpt_n_parms
end type
type cb_ok from commandbutton within w_std_rpt_n_parms
end type
type st_1 from statictext within w_std_rpt_n_parms
end type
type em_start_date from editmask within w_std_rpt_n_parms
end type
end forward

global type w_std_rpt_n_parms from window
integer x = 832
integer y = 356
integer width = 1257
integer height = 716
boolean titlebar = true
string title = "Parameter Required"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79748288
st_5 st_5
st_3 st_3
sle_num sle_num
st_2 st_2
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
em_start_date em_start_date
end type
global w_std_rpt_n_parms w_std_rpt_n_parms

on w_std_rpt_n_parms.create
this.st_5=create st_5
this.st_3=create st_3
this.sle_num=create sle_num
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.em_start_date=create em_start_date
this.Control[]={this.st_5,&
this.st_3,&
this.sle_num,&
this.st_2,&
this.cb_cancel,&
this.cb_ok,&
this.st_1,&
this.em_start_date}
end on

on w_std_rpt_n_parms.destroy
destroy(this.st_5)
destroy(this.st_3)
destroy(this.sle_num)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.em_start_date)
end on

type st_5 from statictext within w_std_rpt_n_parms
integer x = 87
integer y = 336
integer width = 375
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
string text = "report on:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_std_rpt_n_parms
integer x = 87
integer y = 176
integer width = 512
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Beginning Date:"
boolean focusrectangle = false
end type

type sle_num from singlelineedit within w_std_rpt_n_parms
integer x = 498
integer y = 304
integer width = 667
integer height = 84
integer taborder = 3
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_std_rpt_n_parms
integer x = 87
integer y = 280
integer width = 274
integer height = 68
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Number to"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_std_rpt_n_parms
integer x = 887
integer y = 480
integer width = 279
integer height = 108
integer taborder = 5
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

CloseWithReturn(PARENT,"")
end event

type cb_ok from commandbutton within w_std_rpt_n_parms
integer x = 567
integer y = 480
integer width = 279
integer height = 108
integer taborder = 4
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
//  Purpose: Close the parent window and return the formatted date string
//		
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  1/10/00  M. Caruso     Update script to handle the ID parameter as well.
//  04/19/00 C. Jackson    Add logic to verify that ending date is not more than 12 months after
//                         beginning date.  (SCR 537)
//  07/11/00 C. Jackson    Removed end_date (SCR 711)
//		
//**********************************************************************************************
STRING	ls_start_date, ls_return, ls_num

ls_start_date = em_start_date.text
ls_num = sle_num.text

// Verify that beginning date is valid
IF NOT IsDate(ls_start_date) THEN
 	MessageBox(FWCA.MGR.i_ApplicationName,"Please enter a valid start date before continuing.",Stopsign!)
	em_start_date.SetFocus()
	RETURN
END IF

IF len (ls_num) = 0 THEN
	MessageBox(FWCA.MGR.i_ApplicationName,"Please enter a number to report on before continuing.",Stopsign!)
	sle_num.SetFocus()
	RETURN
END IF

ls_return = ls_start_date + "," + ls_num

CloseWithReturn(PARENT,ls_return)
end event

type st_1 from statictext within w_std_rpt_n_parms
integer x = 55
integer y = 68
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

type em_start_date from editmask within w_std_rpt_n_parms
integer x = 754
integer y = 168
integer width = 411
integer height = 84
integer taborder = 1
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

