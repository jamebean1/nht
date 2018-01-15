$PBExportHeader$u_dynamic_gui_format_column.sru
forward
global type u_dynamic_gui_format_column from u_dynamic_gui_format
end type
end forward

global type u_dynamic_gui_format_column from u_dynamic_gui_format
integer width = 1838
integer height = 664
string text = "Column Properties"
end type
global u_dynamic_gui_format_column u_dynamic_gui_format_column

on u_dynamic_gui_format_column.create
call super::create
end on

on u_dynamic_gui_format_column.destroy
call super::destroy
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_column
integer x = 0
integer width = 1838
integer height = 668
string dataobject = "d_format_object_column"
end type

