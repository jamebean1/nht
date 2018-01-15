$PBExportHeader$w_pivot_table_wizard_graph.srw
forward
global type w_pivot_table_wizard_graph from w_pivot_table_wizard_element
end type
end forward

global type w_pivot_table_wizard_graph from w_pivot_table_wizard_element
integer width = 1801
integer height = 604
string title = "Graph Properties"
end type
global w_pivot_table_wizard_graph w_pivot_table_wizard_graph

on w_pivot_table_wizard_graph.create
call super::create
end on

on w_pivot_table_wizard_graph.destroy
call super::destroy
end on

type dw_properties from w_pivot_table_wizard_element`dw_properties within w_pivot_table_wizard_graph
integer height = 352
string dataobject = "d_pivot_table_graph_xy_options"
end type

type cb_cancel from w_pivot_table_wizard_element`cb_cancel within w_pivot_table_wizard_graph
integer x = 1435
integer y = 392
end type

type cb_ok from w_pivot_table_wizard_element`cb_ok within w_pivot_table_wizard_graph
integer x = 1079
integer y = 392
end type

type ln_6 from w_pivot_table_wizard_element`ln_6 within w_pivot_table_wizard_graph
integer beginy = 368
integer endy = 368
end type

type ln_7 from w_pivot_table_wizard_element`ln_7 within w_pivot_table_wizard_graph
integer beginy = 364
integer endy = 364
end type

type st_4 from w_pivot_table_wizard_element`st_4 within w_pivot_table_wizard_graph
integer y = 372
end type

