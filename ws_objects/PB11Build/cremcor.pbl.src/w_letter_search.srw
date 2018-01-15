$PBExportHeader$w_letter_search.srw
forward
global type w_letter_search from w_response
end type
type uo_letter_search from u_search_letter within w_letter_search
end type
type cb_cancel from commandbutton within w_letter_search
end type
type cb_okay from commandbutton within w_letter_search
end type
end forward

global type w_letter_search from w_response
integer width = 3703
integer height = 2068
uo_letter_search uo_letter_search
cb_cancel cb_cancel
cb_okay cb_okay
end type
global w_letter_search w_letter_search

type variables

end variables

forward prototypes
public subroutine of_select ()
end prototypes

public subroutine of_select ();Long ll_row
String ls_letter_id

ls_letter_id = ""
ll_row = uo_letter_search.dw_report.GetRow()
IF ll_row > 0 THEN
	ls_letter_id = uo_letter_search.dw_report.object.letter_id[ll_row]
END IF

// 11/21/2006 RAP - Had to tightly couple these. Since the services use the message object, closewithreturn didn't work.
w_create_maintain_case.i_uoCaseCorrespondence.dw_correspondence_detail.Object.corspnd_type[1] = 'L'
w_create_maintain_case.i_uoCaseCorrespondence.dw_correspondence_detail.SetColumn("correspondence_letter_id")
w_create_maintain_case.i_uoCaseCorrespondence.dw_correspondence_detail.SetText(ls_letter_id)
w_create_maintain_case.i_uoCaseCorrespondence.dw_correspondence_detail.AcceptText()



Close(THIS)
end subroutine

on w_letter_search.create
int iCurrent
call super::create
this.uo_letter_search=create uo_letter_search
this.cb_cancel=create cb_cancel
this.cb_okay=create cb_okay
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_letter_search
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_okay
end on

on w_letter_search.destroy
call super::destroy
destroy(this.uo_letter_search)
destroy(this.cb_cancel)
destroy(this.cb_okay)
end on

event open;call super::open;IF IsValid (inv_resize) THEN
	
	inv_resize.of_Register (uo_letter_search, "ScaleToRight&Bottom")
	inv_resize.of_Register (cb_cancel, "ScaleToRight&Bottom")
	inv_resize.of_Register (cb_okay, "ScaleToRight&Bottom")

END IF


end event

type uo_letter_search from u_search_letter within w_letter_search
event destroy ( )
integer x = 37
integer y = 40
integer height = 1732
integer taborder = 30
end type

on uo_letter_search.destroy
call u_search_letter::destroy
end on

type cb_cancel from commandbutton within w_letter_search
integer x = 2135
integer y = 1796
integer width = 402
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;Close(PARENT)
end event

type cb_okay from commandbutton within w_letter_search
integer x = 1257
integer y = 1796
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;PARENT.of_select()
end event

