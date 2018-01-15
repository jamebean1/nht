$PBExportHeader$w_appealsmaint_test.srw
forward
global type w_appealsmaint_test from window
end type
type uo_1 from uo_appeals_maint within w_appealsmaint_test
end type
end forward

global type w_appealsmaint_test from window
integer width = 3081
integer height = 1912
boolean titlebar = true
string title = "Appeals Maintenance"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
uo_1 uo_1
end type
global w_appealsmaint_test w_appealsmaint_test

on w_appealsmaint_test.create
this.uo_1=create uo_1
this.Control[]={this.uo_1}
end on

on w_appealsmaint_test.destroy
destroy(this.uo_1)
end on

type uo_1 from uo_appeals_maint within w_appealsmaint_test
integer width = 3081
integer height = 2096
integer taborder = 20
end type

on uo_1.destroy
call uo_appeals_maint::destroy
end on

