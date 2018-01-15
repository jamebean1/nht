$PBExportHeader$w_pivot_table_wizard_element_aggregate.srw
$PBExportComments$All Versions
forward
global type w_pivot_table_wizard_element_aggregate from w_pivot_table_wizard_element
end type
end forward

global type w_pivot_table_wizard_element_aggregate from w_pivot_table_wizard_element
integer width = 1801
integer height = 1268
string title = "Aggregate Properties"
end type
global w_pivot_table_wizard_element_aggregate w_pivot_table_wizard_element_aggregate

on w_pivot_table_wizard_element_aggregate.create
call super::create
end on

on w_pivot_table_wizard_element_aggregate.destroy
call super::destroy
end on

type dw_properties from w_pivot_table_wizard_element`dw_properties within w_pivot_table_wizard_element_aggregate
integer height = 996
string dataobject = "d_pivot_table_aggregate_options"
end type

type cb_cancel from w_pivot_table_wizard_element`cb_cancel within w_pivot_table_wizard_element_aggregate
integer x = 1435
integer y = 1052
end type

type cb_ok from w_pivot_table_wizard_element`cb_ok within w_pivot_table_wizard_element_aggregate
integer x = 1079
integer y = 1052
end type

type ln_6 from w_pivot_table_wizard_element`ln_6 within w_pivot_table_wizard_element_aggregate
integer beginy = 1024
integer endy = 1024
end type

type ln_7 from w_pivot_table_wizard_element`ln_7 within w_pivot_table_wizard_element_aggregate
integer beginy = 1020
integer endy = 1020
end type

type st_4 from w_pivot_table_wizard_element`st_4 within w_pivot_table_wizard_element_aggregate
integer y = 1028
end type

