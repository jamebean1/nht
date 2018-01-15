$PBExportHeader$u_dynamic_gui_format_datawindow_print.sru
forward
global type u_dynamic_gui_format_datawindow_print from u_dynamic_gui_format
end type
end forward

global type u_dynamic_gui_format_datawindow_print from u_dynamic_gui_format
integer width = 1696
integer height = 1416
string text = "Print Properties"
end type
global u_dynamic_gui_format_datawindow_print u_dynamic_gui_format_datawindow_print

type variables
Long	il_original_bitmapobject_x
Long	il_original_bitmapobject_y
Long	il_32by32Height
Long	il_32by32Width
Long	il_16by16Height
Long	il_16by16Width

end variables

forward prototypes
public subroutine of_init ()
end prototypes

public subroutine of_init ();Long 		ll_zoom
String	ls_range

super::of_init()

If Not dw_properties.RowCount() > 0 Then Return

ll_zoom							= Long(dw_properties.GetItemString(1, 'zoom'))

Choose Case ll_zoom
	Case 25, 50, 75, 100, 150, 200, 300
		dw_properties.SetItem(1, 'ignore_print_scale', ll_zoom)
	Case Else
		dw_properties.SetItem(1, 'ignore_print_scale', 0)
End Choose

ls_range							= dw_properties.GetItemString(1, 'print_page_range')

If Len(Trim(ls_range)) = 0 Then
	dw_properties.SetItem(1, 'ignore_pagerange', 0)
Else
	dw_properties.SetItem(1, 'ignore_pagerange', 2)
End If

dw_properties.SetItem(1, 'ignore_copies', Long(dw_properties.GetItemString(1, 'print_copies')))

end subroutine

on u_dynamic_gui_format_datawindow_print.create
call super::create
end on

on u_dynamic_gui_format_datawindow_print.destroy
call super::destroy
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_datawindow_print
integer x = 0
integer width = 1701
integer height = 1004
string dataobject = "d_format_object_datawindow_print"
end type

event dw_properties::itemchanged;call super::itemchanged;If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Or row > This.RowCount() Then Return

Choose Case Lower(Trim(dwo.Name))
	Case 'ignore_print_scale'
		Choose Case Lower(Trim(data))
			Case '0'
			Case Else
				This.SetItem(row, 'zoom', data)
		End Choose
	Case 'ignore_pagerange'
		This.SetItem(row, 'print_page_range', '')
	Case 'width'
		This.Modify("bitmapobject.Width = '" + data + "'")
	Case 'ignore_copies'
		This.SetItem(row, 'print_copies', data)
End Choose
end event

