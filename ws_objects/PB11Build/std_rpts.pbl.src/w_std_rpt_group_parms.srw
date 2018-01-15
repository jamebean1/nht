$PBExportHeader$w_std_rpt_group_parms.srw
$PBExportComments$Gets start date, end date, and consumer id from the user
forward
global type w_std_rpt_group_parms from window
end type
type st_3 from statictext within w_std_rpt_group_parms
end type
type sle_id from singlelineedit within w_std_rpt_group_parms
end type
type st_2 from statictext within w_std_rpt_group_parms
end type
type cb_cancel from commandbutton within w_std_rpt_group_parms
end type
type cb_ok from commandbutton within w_std_rpt_group_parms
end type
type st_1 from statictext within w_std_rpt_group_parms
end type
type em_year from editmask within w_std_rpt_group_parms
end type
end forward

global type w_std_rpt_group_parms from window
integer x = 832
integer y = 356
integer width = 1257
integer height = 716
boolean titlebar = true
string title = "Parameter Required"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79748288
st_3 st_3
sle_id sle_id
st_2 st_2
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
em_year em_year
end type
global w_std_rpt_group_parms w_std_rpt_group_parms

on w_std_rpt_group_parms.create
this.st_3=create st_3
this.sle_id=create sle_id
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.em_year=create em_year
this.Control[]={this.st_3,&
this.sle_id,&
this.st_2,&
this.cb_cancel,&
this.cb_ok,&
this.st_1,&
this.em_year}
end on

on w_std_rpt_group_parms.destroy
destroy(this.st_3)
destroy(this.sle_id)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.em_year)
end on

type st_3 from statictext within w_std_rpt_group_parms
integer x = 14
integer y = 204
integer width = 512
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Year to report on:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_id from singlelineedit within w_std_rpt_group_parms
integer x = 539
integer y = 300
integer width = 667
integer height = 84
integer taborder = 30
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

type st_2 from statictext within w_std_rpt_group_parms
integer x = 251
integer y = 304
integer width = 274
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Group ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_std_rpt_group_parms
integer x = 887
integer y = 480
integer width = 279
integer height = 108
integer taborder = 50
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

type cb_ok from commandbutton within w_std_rpt_group_parms
integer x = 567
integer y = 480
integer width = 279
integer height = 108
integer taborder = 40
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
//  -------- ------------- --------------------------------------------------------------------
//  1/10/00  M. Caruso     Update script to handle the ID parameter as well.
//  04/19/00 C. Jackson    Verify that the ending date is not more than 12 months after the 
//                         beginning date (SCR 537)
//  07/11/00 C. Jackson    Removed end_date (SCR 711)
//  04/05/01 C. Jackson    Add end date parameter
//		
//**********************************************************************************************

STRING	ls_start_date, ls_end_date, ls_id, ls_return, ls_year

ls_year = em_year.text
ls_start_date = '01/01/'+ls_year
ls_end_date = '12/31/'+ls_year
ls_id = sle_id.text

// Verify group id
IF len (ls_id) = 0 THEN
	MessageBox(FWCA.MGR.i_ApplicationName,"Please enter a valid Group ID before continuing.",Stopsign!)
	sle_id.SetFocus()
	RETURN
END IF

ls_return = ls_start_date + "," + ls_end_date + ","+ls_id

CloseWithReturn(PARENT,ls_return)


end event

type st_1 from statictext within w_std_rpt_group_parms
integer x = 55
integer y = 36
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

type em_year from editmask within w_std_rpt_group_parms
integer x = 539
integer y = 196
integer width = 411
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
maskdatatype maskdatatype = stringmask!
end type

on getfocus;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			em_year
		Event:			getfocus
		Abstract:		Select the text when this edit gets focus
----------------------------------------------------------------------------------------*/

THIS.SelectText(1,Len(THIS.Text))
end on

