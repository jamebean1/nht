$PBExportHeader$w_pivot_table_wizard_element_row.srw
$PBExportComments$All Versions
forward
global type w_pivot_table_wizard_element_row from w_pivot_table_wizard_element
end type
end forward

global type w_pivot_table_wizard_element_row from w_pivot_table_wizard_element
integer height = 1228
string title = "Row Properties"
end type
global w_pivot_table_wizard_element_row w_pivot_table_wizard_element_row

on w_pivot_table_wizard_element_row.create
call super::create
end on

on w_pivot_table_wizard_element_row.destroy
call super::destroy
end on

type dw_properties from w_pivot_table_wizard_element`dw_properties within w_pivot_table_wizard_element_row
integer height = 956
string dataobject = "d_pivot_table_row_options"
end type

type cb_cancel from w_pivot_table_wizard_element`cb_cancel within w_pivot_table_wizard_element_row
integer x = 1422
integer y = 1012
end type

type cb_ok from w_pivot_table_wizard_element`cb_ok within w_pivot_table_wizard_element_row
integer x = 1065
integer y = 1012
end type

type ln_6 from w_pivot_table_wizard_element`ln_6 within w_pivot_table_wizard_element_row
integer beginy = 984
integer endy = 984
end type

type ln_7 from w_pivot_table_wizard_element`ln_7 within w_pivot_table_wizard_element_row
integer beginy = 980
integer endy = 980
end type

type st_4 from w_pivot_table_wizard_element`st_4 within w_pivot_table_wizard_element_row
integer y = 988
end type

