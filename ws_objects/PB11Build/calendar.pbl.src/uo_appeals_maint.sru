$PBExportHeader$uo_appeals_maint.sru
forward
global type uo_appeals_maint from userobject
end type
type st_3 from statictext within uo_appeals_maint
end type
type dw_appealevents from datawindow within uo_appeals_maint
end type
type st_2 from statictext within uo_appeals_maint
end type
type dw_appealtype_selection from datawindow within uo_appeals_maint
end type
type st_1 from statictext within uo_appeals_maint
end type
type ln_1 from line within uo_appeals_maint
end type
type ln_2 from line within uo_appeals_maint
end type
end forward

global type uo_appeals_maint from userobject
integer width = 3022
integer height = 1596
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_3 st_3
dw_appealevents dw_appealevents
st_2 st_2
dw_appealtype_selection dw_appealtype_selection
st_1 st_1
ln_1 ln_1
ln_2 ln_2
end type
global uo_appeals_maint uo_appeals_maint

type variables
n_dao_appealdetail in_dao

//w_appeal_maint	iw_parent_window
end variables

on uo_appeals_maint.create
this.st_3=create st_3
this.dw_appealevents=create dw_appealevents
this.st_2=create st_2
this.dw_appealtype_selection=create dw_appealtype_selection
this.st_1=create st_1
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.st_3,&
this.dw_appealevents,&
this.st_2,&
this.dw_appealtype_selection,&
this.st_1,&
this.ln_1,&
this.ln_2}
end on

on uo_appeals_maint.destroy
destroy(this.st_3)
destroy(this.dw_appealevents)
destroy(this.st_2)
destroy(this.dw_appealtype_selection)
destroy(this.st_1)
destroy(this.ln_1)
destroy(this.ln_2)
end on

type st_3 from statictext within uo_appeals_maint
integer x = 41
integer y = 32
integer width = 969
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Information for Case Number "
boolean focusrectangle = false
end type

type dw_appealevents from datawindow within uo_appeals_maint
integer x = 169
integer y = 348
integer width = 2779
integer height = 280
integer taborder = 20
string title = "none"
string dataobject = "d_gui_appealevents"
boolean border = false
boolean livescroll = true
end type

type st_2 from statictext within uo_appeals_maint
integer x = 32
integer y = 276
integer width = 366
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Events"
boolean focusrectangle = false
end type

type dw_appealtype_selection from datawindow within uo_appeals_maint
integer x = 379
integer y = 128
integer width = 1211
integer height = 92
integer taborder = 10
string title = "none"
string dataobject = "d_gui_appealtype_selection"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within uo_appeals_maint
integer x = 32
integer y = 128
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Type:"
boolean focusrectangle = false
end type

type ln_1 from line within uo_appeals_maint
integer linethickness = 4
integer beginx = 425
integer beginy = 300
integer endx = 2949
integer endy = 300
end type

type ln_2 from line within uo_appeals_maint
long linecolor = 16777215
integer linethickness = 4
integer beginx = 425
integer beginy = 304
integer endx = 2949
integer endy = 304
end type

