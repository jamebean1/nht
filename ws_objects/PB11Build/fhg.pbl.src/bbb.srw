$PBExportHeader$bbb.srw
forward
global type bbb from window
end type
type cb_1 from commandbutton within bbb
end type
end forward

global type bbb from window
integer width = 3566
integer height = 1648
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
end type
global bbb bbb

on bbb.create
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on bbb.destroy
destroy(this.cb_1)
end on

type cb_1 from commandbutton within bbb
integer x = 805
integer y = 316
integer width = 457
integer height = 132
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "none"
end type

