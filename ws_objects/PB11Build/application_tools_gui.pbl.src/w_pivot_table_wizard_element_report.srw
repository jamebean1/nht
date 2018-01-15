$PBExportHeader$w_pivot_table_wizard_element_report.srw
$PBExportComments$All Versions
forward
global type w_pivot_table_wizard_element_report from w_pivot_table_wizard_element
end type
end forward

global type w_pivot_table_wizard_element_report from w_pivot_table_wizard_element
integer width = 1975
integer height = 1684
string title = "Pivot Table Chart Properties"
end type
global w_pivot_table_wizard_element_report w_pivot_table_wizard_element_report

on w_pivot_table_wizard_element_report.create
call super::create
end on

on w_pivot_table_wizard_element_report.destroy
call super::destroy
end on

event open;call super::open;dw_properties.Modify("p_bitmap.Width = '" + String(PixelsToUnits(dw_properties.GetItemNumber(1, 'BitmapWidth'), XPixelsToUnits!)) + "'")
dw_properties.Modify("p_bitmap.Height = '" + String(PixelsToUnits(dw_properties.GetItemNumber(1, 'BitmapHeight'), YPixelsToUnits!)) + "'")
dw_properties.Modify("p_bitmap.FileName = '" + dw_properties.GetItemString(1, 'BitmapFileName') + "'")
end event

type dw_properties from w_pivot_table_wizard_element`dw_properties within w_pivot_table_wizard_element_report
integer width = 1957
integer height = 1436
string dataobject = "d_pivot_table_options"
end type

event dw_properties::buttonclicked;call super::buttonclicked;n_bag ln_bag
Window	lw_window

If Not IsValid(dwo) Then Return

Choose Case Lower(Trim(dwo.Name))
	Case 'browse_filename'
		ln_bag = Create n_bag
		ln_bag.of_set('datasource', This)
		ln_bag.of_set('object', 'p_bitmap')
		ln_bag.of_set('Border Enabled', 'N')
		ln_bag.of_set('Visible Enabled', 'N')

		OpenWithParm(lw_window, ln_bag, 'w_formatting_service_response', w_mdi)
		
		dw_properties.SetItem(1, 'BitmapWidth', UnitsToPixels(Long(dw_properties.Describe("p_bitmap.Width")), XUnitsToPixels!))
		dw_properties.SetItem(1, 'BitmapHeight', UnitsToPixels(Long(dw_properties.Describe("p_bitmap.Height")), YUnitsToPixels!))
		dw_properties.SetItem(1, 'BitmapFileName', dw_properties.Describe("p_bitmap.FileName"))
		
End Choose
end event

type cb_cancel from w_pivot_table_wizard_element`cb_cancel within w_pivot_table_wizard_element_report
integer x = 1600
integer y = 1488
end type

type cb_ok from w_pivot_table_wizard_element`cb_ok within w_pivot_table_wizard_element_report
integer x = 1243
integer y = 1488
end type

type ln_6 from w_pivot_table_wizard_element`ln_6 within w_pivot_table_wizard_element_report
integer beginy = 1464
integer endy = 1464
end type

type ln_7 from w_pivot_table_wizard_element`ln_7 within w_pivot_table_wizard_element_report
integer beginy = 1460
integer endy = 1460
end type

type st_4 from w_pivot_table_wizard_element`st_4 within w_pivot_table_wizard_element_report
integer y = 1468
end type

