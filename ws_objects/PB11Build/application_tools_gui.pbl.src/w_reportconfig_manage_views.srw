$PBExportHeader$w_reportconfig_manage_views.srw
forward
global type w_reportconfig_manage_views from window
end type
type cb_delete from commandbutton within w_reportconfig_manage_views
end type
type cb_rename from commandbutton within w_reportconfig_manage_views
end type
type cb_cancel from commandbutton within w_reportconfig_manage_views
end type
type cb_ok from commandbutton within w_reportconfig_manage_views
end type
type tab_control from tab within w_reportconfig_manage_views
end type
type tabpage_3 from u_dynamic_gui_manage_views_dataobject within tab_control
end type
type tabpage_3 from u_dynamic_gui_manage_views_dataobject within tab_control
end type
type tabpage_2 from u_dynamic_gui_manage_views_nestedreports within tab_control
end type
type tabpage_2 from u_dynamic_gui_manage_views_nestedreports within tab_control
end type
type tabpage_1 from u_dynamic_gui_manage_views_pivottable within tab_control
end type
type tabpage_1 from u_dynamic_gui_manage_views_pivottable within tab_control
end type
type tabpage_4 from u_dynamic_gui_manage_views_criteria within tab_control
end type
type tabpage_4 from u_dynamic_gui_manage_views_criteria within tab_control
end type
type tabpage_5 from u_dynamic_gui_manage_views_filters within tab_control
end type
type tabpage_5 from u_dynamic_gui_manage_views_filters within tab_control
end type
type tabpage_6 from u_dynamic_gui_manage_views_uomcurrency within tab_control
end type
type tabpage_6 from u_dynamic_gui_manage_views_uomcurrency within tab_control
end type
type tab_control from tab within w_reportconfig_manage_views
tabpage_3 tabpage_3
tabpage_2 tabpage_2
tabpage_1 tabpage_1
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
end forward

global type w_reportconfig_manage_views from window
integer x = 1074
integer y = 484
integer width = 1833
integer height = 1636
boolean titlebar = true
string title = "Manage All Reporting Views"
boolean controlmenu = true
boolean minbox = true
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 79741120
cb_delete cb_delete
cb_rename cb_rename
cb_cancel cb_cancel
cb_ok cb_ok
tab_control tab_control
end type
global w_reportconfig_manage_views w_reportconfig_manage_views

type variables
Protected:
	n_bag in_bag
	n_update_tools in_update_tools
end variables

on w_reportconfig_manage_views.create
this.cb_delete=create cb_delete
this.cb_rename=create cb_rename
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.tab_control=create tab_control
this.Control[]={this.cb_delete,&
this.cb_rename,&
this.cb_cancel,&
this.cb_ok,&
this.tab_control}
end on

on w_reportconfig_manage_views.destroy
destroy(this.cb_delete)
destroy(this.cb_rename)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.tab_control)
end on

event resize;tab_control.Width = This.Width - (2 * tab_control.X) - 36
tab_control.Height = This.Height - (2 * tab_control.Y) - 248

cb_cancel.Y = Height - 240
cb_ok.Y 		= cb_cancel.Y
cb_rename.Y = cb_cancel.Y
cb_delete.Y = cb_cancel.Y

cb_cancel.X 	= Width - cb_cancel.Width - 68
cb_ok.X 			= cb_cancel.X - cb_ok.Width - 20
cb_rename.X 	= cb_ok.X - cb_rename.Width - 20
cb_delete.X 	= cb_rename.X - cb_delete.Width - 20
end event

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Open
// Overrides:  No
// Overview:   Initialize this object
// Created by: Blake Doerr
// History:    12/14/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String	ls_tab

in_update_tools = Create n_update_tools

If Not IsValid(Message.PowerObjectParm) Then Post Close(This)

in_bag	= Message.PowerObjectParm

f_center_window(this)

For ll_index = 1 To UpperBound(tab_control.Control[])
	If Not IsValid(tab_control.Control[ll_index]) Then Continue
	
	tab_control.Control[ll_index].Dynamic of_init(in_bag)
Next

ls_tab = Lower(Trim(String(in_bag.of_get('type'))))

Choose Case ls_tab
	Case	'datawindow'
		tab_control.Post SelectTab(1)
	Case 	'nested report'
		tab_control.Post SelectTab(2)		
	Case	'pivot table'
		tab_control.Post SelectTab(3)
	Case 	'criteria'
		tab_control.Post SelectTab(4)
	Case 	'filter'
		tab_control.Post SelectTab(5)
	Case 'uom/currency'
		tab_control.Post SelectTab(6)
End Choose
		
		
end event

event close;Destroy in_bag
end event

type cb_delete from commandbutton within w_reportconfig_manage_views
integer x = 407
integer y = 1412
integer width = 325
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;Long ll_index

ll_index = tab_control.SelectedTab

If IsNull(ll_index) Or ll_index <= 0 Then Return

If ll_index > UpperBound(tab_control.Control[]) Then Return

If Not IsValid(tab_control.Control[ll_index]) Then Return


tab_control.Control[ll_index].Dynamic of_delete()
end event

type cb_rename from commandbutton within w_reportconfig_manage_views
integer x = 745
integer y = 1412
integer width = 325
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Rename"
end type

event clicked;Long ll_index

ll_index = tab_control.SelectedTab

If IsNull(ll_index) Or ll_index <= 0 Then Return

If ll_index > UpperBound(tab_control.Control[]) Then Return

If Not IsValid(tab_control.Control[ll_index]) Then Return


tab_control.Control[ll_index].Dynamic of_rename()
end event

type cb_cancel from commandbutton within w_reportconfig_manage_views
integer x = 1440
integer y = 1412
integer width = 325
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_ok from commandbutton within w_reportconfig_manage_views
integer x = 1093
integer y = 1412
integer width = 325
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Open
// Overrides:  No
// Overview:   Initialize this object
// Created by: Blake Doerr
// History:    12/14/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_return

in_update_tools.of_begin_transaction()

For ll_index = 1 To UpperBound(tab_control.Control[])
	If Not IsValid(tab_control.Control[ll_index]) Then Continue
	
	ls_return = tab_control.Control[ll_index].Dynamic of_save()
Next

For ll_index = 1 To UpperBound(tab_control.Control[])
	If Not IsValid(tab_control.Control[ll_index]) Then Continue
	
	tab_control.Control[ll_index].Dynamic of_resetupdate()
Next

in_update_tools.of_commit_transaction()

//gn_globals.in_cache.of_refresh_cache('EntityNavigation')
//gn_globals.in_cache.of_refresh_cache('PivotTableView')
//gn_globals.in_cache.of_refresh_cache('NestedReportView')
//gn_globals.in_cache.of_refresh_cache('ReportView')

Close(Parent)
end event

type tab_control from tab within w_reportconfig_manage_views
integer x = 14
integer y = 20
integer width = 1769
integer height = 1364
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean multiline = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
boolean pictureonright = true
integer selectedtab = 1
tabpage_3 tabpage_3
tabpage_2 tabpage_2
tabpage_1 tabpage_1
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_control.create
this.tabpage_3=create tabpage_3
this.tabpage_2=create tabpage_2
this.tabpage_1=create tabpage_1
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_3,&
this.tabpage_2,&
this.tabpage_1,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_control.destroy
destroy(this.tabpage_3)
destroy(this.tabpage_2)
destroy(this.tabpage_1)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

type tabpage_3 from u_dynamic_gui_manage_views_dataobject within tab_control
integer x = 18
integer y = 208
integer width = 1733
integer height = 1140
end type

type tabpage_2 from u_dynamic_gui_manage_views_nestedreports within tab_control
integer x = 18
integer y = 208
integer width = 1733
integer height = 1140
string text = "Nested Report Views"
long tabbackcolor = 81448892
string picturename = "Module - Reporting - Nested Report.bmp"
end type

type tabpage_1 from u_dynamic_gui_manage_views_pivottable within tab_control
integer x = 18
integer y = 208
integer width = 1733
integer height = 1140
long tabbackcolor = 81448892
long picturemaskcolor = 553648127
end type

type tabpage_4 from u_dynamic_gui_manage_views_criteria within tab_control
integer x = 18
integer y = 208
integer width = 1733
integer height = 1140
end type

type tabpage_5 from u_dynamic_gui_manage_views_filters within tab_control
integer x = 18
integer y = 208
integer width = 1733
integer height = 1140
string text = "Filter Views"
string picturename = "Module - Reporting Desktop - Filter View.bmp"
end type

type tabpage_6 from u_dynamic_gui_manage_views_uomcurrency within tab_control
boolean visible = false
integer x = 18
integer y = 208
integer width = 1733
integer height = 1140
boolean enabled = false
end type

