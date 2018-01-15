$PBExportHeader$u_dynamic_gui_format_datawindow_rows.sru
forward
global type u_dynamic_gui_format_datawindow_rows from u_dynamic_gui_format
end type
end forward

global type u_dynamic_gui_format_datawindow_rows from u_dynamic_gui_format
integer width = 1696
integer height = 1024
string text = "Row Properties"
end type
global u_dynamic_gui_format_datawindow_rows u_dynamic_gui_format_datawindow_rows

type variables
Boolean	ib_heightchanged = False
end variables

forward prototypes
public subroutine of_apply ()
end prototypes

public subroutine of_apply ();//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_height
Long		ll_newheight

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// If the header height changed, we need to move all objects down
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_heightchanged Then
	ll_height 		= Long(idw_data.Describe('Datawindow.Header.Height'))
	ll_newheight 	= Long(dw_properties.GetItemString(1, 'header_height'))
	
	If ll_newheight - ll_height <> 0 Then
		ln_datawindow_tools = Create n_datawindow_tools
		ln_datawindow_tools.of_modify_header_height(idw_data, ll_newheight)
		Destroy ln_datawindow_tools
	End If
End If	

super::of_apply()

ib_heightchanged = False
end subroutine

on u_dynamic_gui_format_datawindow_rows.destroy
call super::destroy
end on

on u_dynamic_gui_format_datawindow_rows.create
call super::create
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_datawindow_rows
integer x = 0
integer width = 1701
integer height = 1004
string dataobject = "d_format_object_datawindow_row"
end type

event dw_properties::itemchanged;call super::itemchanged;Choose Case Lower(Trim(dwo.Name))
	Case 'header_height'
		ib_heightchanged = True
End Choose
end event

