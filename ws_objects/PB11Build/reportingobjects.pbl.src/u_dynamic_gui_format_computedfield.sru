$PBExportHeader$u_dynamic_gui_format_computedfield.sru
forward
global type u_dynamic_gui_format_computedfield from u_dynamic_gui_format
end type
end forward

global type u_dynamic_gui_format_computedfield from u_dynamic_gui_format
integer width = 1829
integer height = 920
string text = "Computed Column Properties"
end type
global u_dynamic_gui_format_computedfield u_dynamic_gui_format_computedfield

type variables
Boolean	ib_heightchanged = False
end variables

forward prototypes
public subroutine of_apply ()
public subroutine of_init ()
end prototypes

public subroutine of_apply ();Long		ll_rowheight
Long		ll_rowcount
Long		ll_y
Long		ll_height
String	ls_name

If ib_heightchanged Then
	ls_name 		= dw_properties.GetItemString(1, 'name')
	ll_y 			= Long(dw_properties.GetItemString(1, 'y'))
	ll_height 	= Long(dw_properties.GetItemString(1, 'height'))
	ll_rowcount = Long(dw_properties.GetItemString(1, 'ignore_height'))
	
	If Mod(ll_height, 60) = 0 Then
		ll_rowheight = 60
	ElseIf Mod(ll_height, 56) = 0 Then
		ll_rowheight = 56
	ElseIf Mod(ll_height, 52) = 0 Then
		ll_rowheight = 52
	End If
	
	dw_properties.SetItem(1, 'height', String(ll_rowcount * ll_rowheight))
	If Right(Lower(ls_name), Len('_srt')) = '_srt' Then
		dw_properties.SetItem(1, 'y', String(ll_y - (ll_rowcount * ll_rowheight - ll_height)))
	End If
End If	

super::of_apply()

ib_heightchanged = False
end subroutine

public subroutine of_init ();Long		ll_y
Long		ll_height
String	ls_name

super::of_init()

ls_name 		= dw_properties.GetItemString(1, 'name')
ll_y 			= Long(dw_properties.GetItemString(1, 'y'))
ll_height 	= Long(dw_properties.GetItemString(1, 'height'))

If ll_height = 52 * 3 Or ll_height = 52 * 3 Or ll_height = 52 * 3 Or ll_height = 56 * 3 Or ll_height = 56 * 3 Or ll_height = 56 * 3 Or ll_height = 60 * 3 Or ll_height = 60 * 3 Or ll_height = 60 * 3 Then
	dw_properties.SetItem(1, 'ignore_height', '3')
ElseIf 	ll_height = 52 * 2 Or ll_height = 52 * 2 Or ll_height = 52 * 2 Or ll_height = 56 * 2 Or ll_height = 56 * 2 Or ll_height = 56 * 2 Or ll_height = 60 * 2 Or ll_height = 60 * 2 Or ll_height = 60 * 2 Then
	dw_properties.SetItem(1, 'ignore_height', '2')
ElseIf 	ll_height = 52 * 1 Or ll_height = 52 * 1 Or ll_height = 52 * 1 Or ll_height = 56 * 1 Or ll_height = 56 * 1 Or ll_height = 56 * 1 Or ll_height = 60 * 1 Or ll_height = 60 * 1 Or ll_height = 60 * 1 Then
	dw_properties.SetItem(1, 'ignore_height', '1')
Else
	dw_properties.SetItem(1, 'ignore_height', 0)
End If
end subroutine

on u_dynamic_gui_format_computedfield.create
call super::create
end on

on u_dynamic_gui_format_computedfield.destroy
call super::destroy
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_computedfield
integer x = 0
integer width = 1838
integer height = 928
string dataobject = "d_format_object_computedfield"
end type

event dw_properties::itemchanged;call super::itemchanged;Choose Case Lower(Trim(dwo.Name))
	Case 'ignore_height'
		ib_heightchanged = True
End Choose
end event

