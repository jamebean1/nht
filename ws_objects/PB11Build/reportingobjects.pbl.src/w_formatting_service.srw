$PBExportHeader$w_formatting_service.srw
forward
global type w_formatting_service from window
end type
type cb_apply from u_commandbutton within w_formatting_service
end type
type tab_control from tab within w_formatting_service
end type
type tab_control from tab within w_formatting_service
end type
type cb_restoreoriginal from u_commandbutton within w_formatting_service
end type
type cb_cancel from u_commandbutton within w_formatting_service
end type
type cb_ok from u_commandbutton within w_formatting_service
end type
type ln_6 from line within w_formatting_service
end type
type ln_7 from line within w_formatting_service
end type
type st_4 from statictext within w_formatting_service
end type
end forward

global type w_formatting_service from window
integer x = 1001
integer y = 1000
integer width = 1920
integer height = 1620
boolean titlebar = true
string title = "Format Report Element"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 81448892
cb_apply cb_apply
tab_control tab_control
cb_restoreoriginal cb_restoreoriginal
cb_cancel cb_cancel
cb_ok cb_ok
ln_6 ln_6
ln_7 ln_7
st_4 st_4
end type
global w_formatting_service w_formatting_service

type variables
Protected:
	Datawindow 				idw_data
	n_bag						in_bag
	String					is_objectname
	String					is_objecttype
	UserObject				iuo_property_sheets[]
	
end variables

on w_formatting_service.create
this.cb_apply=create cb_apply
this.tab_control=create tab_control
this.cb_restoreoriginal=create cb_restoreoriginal
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.ln_6=create ln_6
this.ln_7=create ln_7
this.st_4=create st_4
this.Control[]={this.cb_apply,&
this.tab_control,&
this.cb_restoreoriginal,&
this.cb_cancel,&
this.cb_ok,&
this.ln_6,&
this.ln_7,&
this.st_4}
end on

on w_formatting_service.destroy
destroy(this.cb_apply)
destroy(this.tab_control)
destroy(this.cb_restoreoriginal)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.st_4)
end on

event resize;//st_4.Y 	= Height - st_4.Height
//
//ln_6.BeginY 	= st_4.Y - 4
//ln_6.EndY 		= ln_6.BeginY
//
//ln_7.BeginY 	= ln_6.BeginY - 4
//ln_7.EndY 	= ln_7.BeginY
//
//cb_cancel.Y = st_4.Y + 20
//cb_cancel.X = Width - cb_cancel.Width - 40
//cb_ok.Y = cb_cancel.Y
//cb_ok.X = cb_cancel.X - cb_ok.Width - 20
//cb_clear.Y	= cb_ok.Y
//cb_clear.X	= cb_ok.X - cb_clear.Width - 20
//
//uo_expression.Width = Width
//uo_expression.Height = ln_6.BeginY - uo_expression.Y - 4
end event

event open;Boolean	lb_RichTextDatawindow
Long		ll_index
String	ls_title
String	ls_DefaultName
String	ls_expressionlabel

If Not IsValid(Message.PowerObjectParm) Then Post Close(This)
If Not ClassName(Message.PowerObjectParm) = 'n_bag' Then Post Close(This)

f_center_window(this)

in_bag 					= Message.PowerObjectParm

ls_title 				= String(in_bag.of_get('title'))

If Not IsNull(ls_title) And Len(Trim(ls_title)) <> 0 Then
	This.Title = ls_title
End If

idw_data									= in_bag.of_get('datasource')
lb_RichTextDatawindow				= IsNumber(idw_data.Describe("DataWindow.RichText.Backcolor"))
is_objectname							= String(in_bag.of_get('object'))
If Lower(Trim(is_objectname)) = 'datawindow' Then
	is_objecttype = 'datawindow'
ElseIf Lower(Trim(is_objectname)) = 'uominit' Then
	is_objecttype = 'uom conversion'
Else
	is_objecttype							= idw_data.Describe(is_objectname + '.Type')
End If

in_bag.of_set('objecttype', is_objecttype)

Choose Case Lower(Trim(is_objecttype))
	Case 'text'
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_text", 0)
	Case 'column'
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_column", 0)
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_format", 0)
	Case 'compute', 'computedfield'
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_computedfield", 0)
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_format", 0)
	Case 'bitmap'
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_bitmap", 0)
	Case 'datawindow'
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_datawindow_print", 0)
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_datawindow_rows", 0)
		//tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_datawindow_uominit", 0)
		If Not lb_RichTextDatawindow Then
			tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_datawindow_distinit", 0)
		End If
	Case 'print dialog'
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_datawindow_print", 0)
	Case 'uom conversion'
		tab_control.OpenTabWithParm(iuo_property_sheets[UpperBound(iuo_property_sheets[]) + 1], in_bag, "u_dynamic_gui_format_datawindow_uominit", 0)
	Case Else
End Choose

For ll_index = 1 To UpperBound(iuo_property_sheets[])
	iuo_property_sheets[ll_index].Dynamic of_init()
Next
end event

type cb_apply from u_commandbutton within w_formatting_service
integer x = 859
integer y = 1396
integer width = 325
integer height = 88
integer taborder = 82
integer weight = 400
string facename = "Tahoma"
string text = "&Apply"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   If wf_validate_context() is successful, close the window returning the selected report folder id
// Created by: Pat Newgent
// History:    12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index

If IsValid(idw_data) Then
	For ll_index = 1 To UpperBound(iuo_property_sheets[])
		If Not iuo_property_sheets[ll_index].Dynamic of_validate() Then
			tab_control.SelectTab(ll_index)
			SetFocus(iuo_property_sheets[ll_index])
			gn_globals.in_messagebox.of_messagebox_validation ('The expression is not valid')
			Return
		End If
	Next

	For ll_index = 1 To UpperBound(iuo_property_sheets[])
		iuo_property_sheets[ll_index].Dynamic of_apply()
	Next
End If
end event

type tab_control from tab within w_formatting_service
integer x = 14
integer width = 1870
integer height = 1352
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81448892
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
end type

type cb_restoreoriginal from u_commandbutton within w_formatting_service
integer x = 174
integer y = 1396
integer width = 667
integer height = 88
integer taborder = 72
integer weight = 400
string facename = "Tahoma"
boolean enabled = false
string text = "&Restore Original Properties"
end type

type cb_cancel from u_commandbutton within w_formatting_service
integer x = 1545
integer y = 1396
integer width = 325
integer height = 88
integer taborder = 62
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   Close the parent window returning -1 indicating the user has cancelled the folder selection process.
// Created by: Pat Newgent
// History:    12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Destroy in_bag
Close(Parent)

end event

type cb_ok from u_commandbutton within w_formatting_service
integer x = 1202
integer y = 1396
integer width = 325
integer height = 88
integer taborder = 52
integer weight = 400
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   If wf_validate_context() is successful, close the window returning the selected report folder id
// Created by: Pat Newgent
// History:    12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_index
String	ls_message

If IsValid(idw_data) Then
	For ll_index = 1 To UpperBound(iuo_property_sheets[])
		If Not iuo_property_sheets[ll_index].Dynamic of_validate() Then
			tab_control.SelectTab(ll_index)
			SetFocus(iuo_property_sheets[ll_index])
			ls_message = String(iuo_property_sheets[ll_index].Dynamic of_get_errormessage())
			gn_globals.in_messagebox.of_messagebox_validation (ls_message)
			Return
		End If
	Next
	
	For ll_index = 1 To UpperBound(iuo_property_sheets[])
		iuo_property_sheets[ll_index].Dynamic of_apply()
	Next
End If

Close(Parent)
end event

type ln_6 from line within w_formatting_service
long linecolor = 16777215
integer linethickness = 1
integer beginy = 1368
integer endx = 32000
integer endy = 1368
end type

type ln_7 from line within w_formatting_service
long linecolor = 8421504
integer linethickness = 1
integer beginy = 1364
integer endx = 32000
integer endy = 1364
end type

type st_4 from statictext within w_formatting_service
integer y = 1372
integer width = 32000
integer height = 140
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 81517531
long backcolor = 81517531
boolean enabled = false
boolean focusrectangle = false
end type

