$PBExportHeader$u_dynamic_gui_format_bitmap.sru
forward
global type u_dynamic_gui_format_bitmap from u_dynamic_gui_format
end type
end forward

global type u_dynamic_gui_format_bitmap from u_dynamic_gui_format
integer width = 1856
integer height = 1416
string text = "Picture Properties"
end type
global u_dynamic_gui_format_bitmap u_dynamic_gui_format_bitmap

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

public subroutine of_init ();Long	ll_bitmap_width
Long	ll_bitmap_height

super::of_init()

If Not dw_properties.RowCount() > 0 Then Return

ll_bitmap_width				= Long(dw_properties.GetItemString(1, 'width'))
ll_bitmap_height				= Long(dw_properties.GetItemString(1, 'height'))
il_32by32Height				= Long(dw_properties.Describe("thirtytwobythirtytwo.Height"))
il_32by32Width					= Long(dw_properties.Describe("thirtytwobythirtytwo.Width"))
il_16by16Height				= Long(dw_properties.Describe("sixteenbysixteen.Height"))
il_16by16Width					= Long(dw_properties.Describe("sixteenbysixteen.Width"))
il_original_bitmapobject_x	= Long(dw_properties.Describe("bitmapobject.X"))
il_original_bitmapobject_y	= Long(dw_properties.Describe("bitmapobject.Y"))

dw_properties.Modify("bitmapobject.Width = '" + String(ll_bitmap_width) + "'")
dw_properties.Modify("bitmapobject.Height = '" + String(ll_bitmap_height) + "'")

If ll_bitmap_width = il_32by32Width And ll_bitmap_height = il_16by16Height Then
	dw_properties.SetItem(1, 'ignore_dimensions', '3')
End If

If ll_bitmap_width = il_16by16Width And ll_bitmap_height = il_16by16Height Then
	dw_properties.SetItem(1, 'ignore_dimensions', '2')
End If

If String(in_bag.of_get('Visible Enabled')) = 'N' Then
	dw_properties.SetItem(1, 'ignore_visibleenabled', 'N')
End If
If String(in_bag.of_get('Border Enabled')) = 'N' Then
	dw_properties.SetItem(1, 'ignore_borderenabled', 'N')
	dw_properties.SetColumn('filename')
End If
end subroutine

on u_dynamic_gui_format_bitmap.create
call super::create
end on

on u_dynamic_gui_format_bitmap.destroy
call super::destroy
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_bitmap
integer x = 0
integer width = 1856
integer height = 1424
string dataobject = "d_format_object_bitmap"
end type

event dw_properties::itemchanged;call super::itemchanged;If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Or row > This.RowCount() Then Return

Choose Case Lower(Trim(dwo.Name))
	Case 'ignore_dimensions'
		Choose Case Lower(Trim(data))
			Case '1'
			Case '2'
				dw_properties.Modify("bitmapobject.Width = '" + String(il_16by16Width) + "'")
				dw_properties.Modify("bitmapobject.Height = '" + String(il_16by16Height) + "'")
			Case '3'
				dw_properties.Modify("bitmapobject.Width = '" + String(il_32by32Width) + "'")
				dw_properties.Modify("bitmapobject.Height = '" + String(il_32by32Height) + "'")
		End Choose
	Case 'height'
		dw_properties.Modify("bitmapobject.Height = '" + data + "'")		
	Case 'width'
		dw_properties.Modify("bitmapobject.Width = '" + data + "'")
End Choose
end event

event dw_properties::ue_mousemove;call super::ue_mousemove;Long		ll_bitmapobject_x
Long		ll_bitmapobject_y
Long		ll_bitmapobject_width
Long		ll_bitmapobject_height
Long		ll_width
Long		ll_height
Long		ll_dimensions

If This.RowCount() <= 0 Then Return

ll_bitmapobject_x			= Long(dw_properties.Describe("bitmapobject.X"))
ll_bitmapobject_y			= Long(dw_properties.Describe("bitmapobject.Y"))
ll_bitmapobject_width	= Long(dw_properties.Describe("bitmapobject.Width"))
ll_bitmapobject_height	= Long(dw_properties.Describe("bitmapobject.Height"))
ll_height					= Long(This.GetItemString(1, 'height'))
ll_width						= Long(This.GetItemString(1, 'width'))
ll_dimensions				= Long(This.GetItemString(1, 'ignore_dimensions'))


If ll_height <> ll_bitmapobject_height Then
	This.SetItem(1, 'height', String(ll_bitmapobject_height))
End If

If ll_width <> ll_bitmapobject_width Then
	This.SetItem(1, 'width', String(ll_bitmapobject_width))
End If

If ll_dimensions <> 1 Then
	If Not (ll_bitmapobject_width = il_32by32Width And ll_bitmapobject_height = il_32by32Height) And Not (ll_bitmapobject_width = il_16by16Width And ll_bitmapobject_height = il_16by16Height) Then
		This.SetItem(1, 'ignore_dimensions', '1')
	End If
End If

If ll_bitmapobject_x <> il_original_bitmapobject_x Then
	This.Modify("bitmapobject.X = '" + String(il_original_bitmapobject_x) + "'")
End If

If ll_bitmapobject_y <> il_original_bitmapobject_y Then
	This.Modify("bitmapobject.Y = '" + String(il_original_bitmapobject_y) + "'")
End If

end event

