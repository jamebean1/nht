$PBExportHeader$w_calendar_test.srw
forward
global type w_calendar_test from window
end type
type uo_1 from uo_dateterm_maint within w_calendar_test
end type
end forward

global type w_calendar_test from window
integer width = 3429
integer height = 1624
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
uo_1 uo_1
end type
global w_calendar_test w_calendar_test

on w_calendar_test.create
this.uo_1=create uo_1
this.Control[]={this.uo_1}
end on

on w_calendar_test.destroy
destroy(this.uo_1)
end on

type uo_1 from uo_dateterm_maint within w_calendar_test
integer x = 27
integer y = 32
integer taborder = 10
end type

on uo_1.destroy
call uo_dateterm_maint::destroy
end on

