$PBExportHeader$w_attach.srw
forward
global type w_attach from w_response
end type
type st_1 from statictext within w_attach
end type
type sle_description from singlelineedit within w_attach
end type
type rb_combined from radiobutton within w_attach
end type
type rb_single from radiobutton within w_attach
end type
type cb_okay from commandbutton within w_attach
end type
type cb_cancel from commandbutton within w_attach
end type
type gb_1 from groupbox within w_attach
end type
end forward

global type w_attach from w_response
integer width = 2139
integer height = 836
string title = "Attach Image"
st_1 st_1
sle_description sle_description
rb_combined rb_combined
rb_single rb_single
cb_okay cb_okay
cb_cancel cb_cancel
gb_1 gb_1
end type
global w_attach w_attach

on w_attach.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_description=create sle_description
this.rb_combined=create rb_combined
this.rb_single=create rb_single
this.cb_okay=create cb_okay
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_description
this.Control[iCurrent+3]=this.rb_combined
this.Control[iCurrent+4]=this.rb_single
this.Control[iCurrent+5]=this.cb_okay
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.gb_1
end on

on w_attach.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_description)
destroy(this.rb_combined)
destroy(this.rb_single)
destroy(this.cb_okay)
destroy(this.cb_cancel)
destroy(this.gb_1)
end on

event open;call super::open;LONG ll_parm

ll_parm = Message.Doubleparm

IF ll_parm = 1 THEN // Single image selected
	gb_1.visible = false
	rb_combined.visible = false
	rb_single.visible = false
END IF

sle_description.SetFocus()
end event

type st_1 from statictext within w_attach
integer x = 165
integer y = 64
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Description:"
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_attach
integer x = 160
integer y = 132
integer width = 1824
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 255
borderstyle borderstyle = stylelowered!
end type

type rb_combined from radiobutton within w_attach
integer x = 229
integer y = 340
integer width = 1001
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Combined into a single document"
boolean checked = true
end type

type rb_single from radiobutton within w_attach
integer x = 229
integer y = 412
integer width = 649
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "As individual pages"
end type

type cb_okay from commandbutton within w_attach
integer x = 389
integer y = 608
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

event clicked;String ls_attach, ls_description

IF rb_combined.checked THEN
	ls_attach = 'c'
ELSE
	ls_attach = 'i'
END IF

ls_description = sle_description.text

CloseWithReturn(PARENT, ls_attach + '/' + ls_description)
end event

type cb_cancel from commandbutton within w_attach
integer x = 1266
integer y = 608
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;CloseWithReturn(PARENT, '')
end event

type gb_1 from groupbox within w_attach
integer x = 155
integer y = 256
integer width = 1097
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Attach selected images:"
end type

