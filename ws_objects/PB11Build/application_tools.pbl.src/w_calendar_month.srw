$PBExportHeader$w_calendar_month.srw
forward
global type w_calendar_month from w_calendar
end type
end forward

global type w_calendar_month from w_calendar
integer width = 654
integer height = 220
end type
global w_calendar_month w_calendar_month

on w_calendar_month.create
int iCurrent
call super::create
end on

on w_calendar_month.destroy
call super::destroy
end on

type uo_calendar from w_calendar_new`uo_calendar within w_calendar_month
integer width = 782
integer height = 224
string is_dataobject = "d_clndr_month"
end type

event uo_calendar::constructor;call super::constructor;//This.dw_1.DataObject = 'd_clndr_month'

If ISValid(gn_globals) Then
//	If IsValid(gn_globals.in_theme) Then
//		This.BackColor = gn_globals.in_theme.of_get_barcolor()
//		dw_1.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_barcolor()) + "'")
//	End If
End If
end event

