$PBExportHeader$u_dynamic_gui_format_format.sru
forward
global type u_dynamic_gui_format_format from u_dynamic_gui_format
end type
type dw_1 from u_datawindow within u_dynamic_gui_format_format
end type
end forward

global type u_dynamic_gui_format_format from u_dynamic_gui_format
integer width = 1669
integer height = 1328
string text = "Format"
dw_1 dw_1
end type
global u_dynamic_gui_format_format u_dynamic_gui_format_format

on u_dynamic_gui_format_format.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on u_dynamic_gui_format_format.destroy
call super::destroy
destroy(this.dw_1)
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_format
integer x = 27
integer y = 12
integer width = 1641
integer height = 76
string dataobject = "d_format_object_format"
end type

type dw_1 from u_datawindow within u_dynamic_gui_format_format
integer x = 5
integer y = 92
integer width = 1627
integer height = 1216
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_format_object_format_legend"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

