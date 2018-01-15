$PBExportHeader$w_pivot_table_wizard_element_column.srw
forward
global type w_pivot_table_wizard_element_column from w_pivot_table_wizard_element
end type
end forward

global type w_pivot_table_wizard_element_column from w_pivot_table_wizard_element
integer width = 1797
integer height = 924
string title = "Column Properties"
end type
global w_pivot_table_wizard_element_column w_pivot_table_wizard_element_column

on w_pivot_table_wizard_element_column.create
call super::create
end on

on w_pivot_table_wizard_element_column.destroy
call super::destroy
end on

event open;call super::open;If iu_pivot_table_rowsandcolumns.dw_aggregates.RowCount() > 0 Then
	dw_properties.SetItem(1, 'thereareaggregates', 'Y')
Else
	dw_properties.SetItem(1, 'thereareaggregates', 'N')
End If
end event

type dw_properties from w_pivot_table_wizard_element`dw_properties within w_pivot_table_wizard_element_column
integer height = 656
string dataobject = "d_pivot_table_column_options"
end type

type cb_cancel from w_pivot_table_wizard_element`cb_cancel within w_pivot_table_wizard_element_column
integer x = 1431
integer y = 708
end type

type cb_ok from w_pivot_table_wizard_element`cb_ok within w_pivot_table_wizard_element_column
integer x = 1074
integer y = 708
end type

type ln_6 from w_pivot_table_wizard_element`ln_6 within w_pivot_table_wizard_element_column
integer beginy = 680
integer endy = 680
end type

type ln_7 from w_pivot_table_wizard_element`ln_7 within w_pivot_table_wizard_element_column
integer beginy = 676
integer endy = 676
end type

type st_4 from w_pivot_table_wizard_element`st_4 within w_pivot_table_wizard_element_column
integer y = 684
end type

