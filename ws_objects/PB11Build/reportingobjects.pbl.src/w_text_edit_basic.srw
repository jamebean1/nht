$PBExportHeader$w_text_edit_basic.srw
forward
global type w_text_edit_basic from w_deal_display_basic
end type
type st_3 from statictext within w_text_edit_basic
end type
type cb_2 from u_commandbutton within w_text_edit_basic
end type
type st_4 from statictext within w_text_edit_basic
end type
type sle_1 from singlelineedit within w_text_edit_basic
end type
end forward

global type w_text_edit_basic from w_deal_display_basic
integer width = 1911
integer height = 740
string title = "Edit Text Value"
st_3 st_3
cb_2 cb_2
st_4 st_4
sle_1 sle_1
end type
global w_text_edit_basic w_text_edit_basic

type variables
long il_key 
end variables

on w_text_edit_basic.create
int iCurrent
call super::create
this.st_3=create st_3
this.cb_2=create cb_2
this.st_4=create st_4
this.sle_1=create sle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.sle_1
end on

on w_text_edit_basic.destroy
call super::destroy
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.st_4)
destroy(this.sle_1)
end on

event open;call super::open;
sle_1.text = message.stringparm





st_4.backcolor = gn_globals.in_theme.of_get_backcolor()
end event

type p_1 from w_deal_display_basic`p_1 within w_text_edit_basic
integer y = 24
end type

type st_1 from w_deal_display_basic`st_1 within w_text_edit_basic
integer width = 1691
string text = "Edit the text value"
end type

type cb_1 from w_deal_display_basic`cb_1 within w_text_edit_basic
integer x = 978
integer y = 524
end type

event cb_1::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   Update the Data and Close the window.
// Created by: Jake Pratt
// History:    7/31/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
closewithreturn(parent,sle_1.text)
end event

type st_2 from w_deal_display_basic`st_2 within w_text_edit_basic
integer width = 3616
end type

type ln_1 from w_deal_display_basic`ln_1 within w_text_edit_basic
end type

type ln_2 from w_deal_display_basic`ln_2 within w_text_edit_basic
end type

type ln_3 from w_deal_display_basic`ln_3 within w_text_edit_basic
integer beginy = 496
integer endy = 496
end type

type ln_4 from w_deal_display_basic`ln_4 within w_text_edit_basic
integer beginy = 492
integer endy = 492
end type

type st_3 from statictext within w_text_edit_basic
integer y = 500
integer width = 3616
integer height = 296
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_2 from u_commandbutton within w_text_edit_basic
integer x = 1435
integer y = 524
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string text = "Cancel"
end type

event clicked;call super::clicked;closewithreturn(parent,'')
end event

type st_4 from statictext within w_text_edit_basic
integer x = 27
integer y = 300
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 81324524
string text = "Value:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_text_edit_basic
integer x = 389
integer y = 284
integer width = 1248
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

