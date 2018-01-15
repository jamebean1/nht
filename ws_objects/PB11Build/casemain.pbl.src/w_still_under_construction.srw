$PBExportHeader$w_still_under_construction.srw
$PBExportComments$Still Under Construction Response Window
forward
global type w_still_under_construction from w_response_std
end type
type cb_1 from commandbutton within w_still_under_construction
end type
type p_1 from picture within w_still_under_construction
end type
type mle_1 from multilineedit within w_still_under_construction
end type
end forward

global type w_still_under_construction from w_response_std
integer width = 1317
integer height = 672
string title = "Still Under Construction"
cb_1 cb_1
p_1 p_1
mle_1 mle_1
end type
global w_still_under_construction w_still_under_construction

on w_still_under_construction.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.p_1=create p_1
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.mle_1
end on

on w_still_under_construction.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.mle_1)
end on

type cb_1 from commandbutton within w_still_under_construction
integer x = 535
integer y = 408
integer width = 302
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

on clicked;Close(PArent)
end on

type p_1 from picture within w_still_under_construction
integer x = 59
integer y = 264
integer width = 293
integer height = 256
string picturename = "undrcon1.bmp"
boolean focusrectangle = false
end type

type mle_1 from multilineedit within w_still_under_construction
integer x = 133
integer y = 44
integer width = 1029
integer height = 248
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "This option is still under construction.  Sorry for the inconvenience!"
boolean border = false
alignment alignment = center!
boolean displayonly = true
end type

