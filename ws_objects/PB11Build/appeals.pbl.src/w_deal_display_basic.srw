$PBExportHeader$w_deal_display_basic.srw
forward
global type w_deal_display_basic from window
end type
type p_1 from picture within w_deal_display_basic
end type
type st_1 from statictext within w_deal_display_basic
end type
type cb_1 from u_commandbutton within w_deal_display_basic
end type
type st_2 from statictext within w_deal_display_basic
end type
type ln_1 from line within w_deal_display_basic
end type
type ln_2 from line within w_deal_display_basic
end type
type ln_3 from line within w_deal_display_basic
end type
type ln_4 from line within w_deal_display_basic
end type
end forward

global type w_deal_display_basic from window
integer x = 1189
integer y = 552
integer width = 2491
integer height = 892
boolean titlebar = true
string title = "Other Detail Attributes"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 81517531
p_1 p_1
st_1 st_1
cb_1 cb_1
st_2 st_2
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
end type
global w_deal_display_basic w_deal_display_basic

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      open
// Overrides:  No
// Overview:   Set the background to theme color
// Created by: Jake Pratt
// History:    06.07.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//this.backcolor = gn_globals.in_theme.of_get_backcolor()
end event

on w_deal_display_basic.create
this.p_1=create p_1
this.st_1=create st_1
this.cb_1=create cb_1
this.st_2=create st_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.Control[]={this.p_1,&
this.st_1,&
this.cb_1,&
this.st_2,&
this.ln_1,&
this.ln_2,&
this.ln_3,&
this.ln_4}
end on

on w_deal_display_basic.destroy
destroy(this.p_1)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
end on

type p_1 from picture within w_deal_display_basic
integer x = 37
integer y = 32
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "module - traders desktop - large icon (white).bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within w_deal_display_basic
integer x = 201
integer y = 88
integer width = 1051
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Complete any option detail information needed."
boolean focusrectangle = false
end type

type cb_1 from u_commandbutton within w_deal_display_basic
integer x = 2034
integer y = 688
integer height = 92
integer taborder = 20
integer weight = 400
string facename = "Tahoma"
string text = "OK"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   close the window
// Created by: Jake Pratt
// History:    06.07.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

close(parent)
end event

type st_2 from statictext within w_deal_display_basic
integer width = 2505
integer height = 184
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type ln_1 from line within w_deal_display_basic
long linecolor = 16777215
integer linethickness = 5
integer beginy = 192
integer endx = 4000
integer endy = 192
end type

type ln_2 from line within w_deal_display_basic
long linecolor = 8421504
integer linethickness = 5
integer beginy = 188
integer endx = 4000
integer endy = 188
end type

type ln_3 from line within w_deal_display_basic
long linecolor = 16777215
integer linethickness = 5
integer beginy = 660
integer endx = 4000
integer endy = 660
end type

type ln_4 from line within w_deal_display_basic
long linecolor = 8421504
integer linethickness = 5
integer beginy = 656
integer endx = 4000
integer endy = 656
end type

