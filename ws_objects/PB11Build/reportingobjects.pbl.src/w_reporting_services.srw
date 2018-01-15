$PBExportHeader$w_reporting_services.srw
forward
global type w_reporting_services from window
end type
type cb_grouping from commandbutton within w_reporting_services
end type
type st_8 from statictext within w_reporting_services
end type
type st_5 from statictext within w_reporting_services
end type
type cb_pivot from commandbutton within w_reporting_services
end type
type cb_restoreview from commandbutton within w_reporting_services
end type
type cb_saveview from commandbutton within w_reporting_services
end type
type st_3 from statictext within w_reporting_services
end type
type st_7 from statictext within w_reporting_services
end type
type st_6 from statictext within w_reporting_services
end type
type st_4 from statictext within w_reporting_services
end type
type st_2 from statictext within w_reporting_services
end type
type cb_manageviews from commandbutton within w_reporting_services
end type
type cb_formatreport from commandbutton within w_reporting_services
end type
type cb_sorting from commandbutton within w_reporting_services
end type
type cb_modifycolumns from commandbutton within w_reporting_services
end type
type st_1 from statictext within w_reporting_services
end type
type cb_ok from u_commandbutton within w_reporting_services
end type
type st_buttonbar from statictext within w_reporting_services
end type
type p_bitmap from picture within w_reporting_services
end type
type st_description from statictext within w_reporting_services
end type
type ln_top2 from line within w_reporting_services
end type
type ln_top1 from line within w_reporting_services
end type
type ln_bottom2 from line within w_reporting_services
end type
type ln_bottom1 from line within w_reporting_services
end type
type st_10 from statictext within w_reporting_services
end type
type ln_1 from line within w_reporting_services
end type
type ln_2 from line within w_reporting_services
end type
end forward

global type w_reporting_services from window
integer width = 1865
integer height = 1360
boolean titlebar = true
string title = "Customize Current Report"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
boolean toolbarvisible = false
cb_grouping cb_grouping
st_8 st_8
st_5 st_5
cb_pivot cb_pivot
cb_restoreview cb_restoreview
cb_saveview cb_saveview
st_3 st_3
st_7 st_7
st_6 st_6
st_4 st_4
st_2 st_2
cb_manageviews cb_manageviews
cb_formatreport cb_formatreport
cb_sorting cb_sorting
cb_modifycolumns cb_modifycolumns
st_1 st_1
cb_ok cb_ok
st_buttonbar st_buttonbar
p_bitmap p_bitmap
st_description st_description
ln_top2 ln_top2
ln_top1 ln_top1
ln_bottom2 ln_bottom2
ln_bottom1 ln_bottom1
st_10 st_10
ln_1 ln_1
ln_2 ln_2
end type
global w_reporting_services w_reporting_services

type variables
Protected:
	n_report in_report
end variables

on w_reporting_services.create
this.cb_grouping=create cb_grouping
this.st_8=create st_8
this.st_5=create st_5
this.cb_pivot=create cb_pivot
this.cb_restoreview=create cb_restoreview
this.cb_saveview=create cb_saveview
this.st_3=create st_3
this.st_7=create st_7
this.st_6=create st_6
this.st_4=create st_4
this.st_2=create st_2
this.cb_manageviews=create cb_manageviews
this.cb_formatreport=create cb_formatreport
this.cb_sorting=create cb_sorting
this.cb_modifycolumns=create cb_modifycolumns
this.st_1=create st_1
this.cb_ok=create cb_ok
this.st_buttonbar=create st_buttonbar
this.p_bitmap=create p_bitmap
this.st_description=create st_description
this.ln_top2=create ln_top2
this.ln_top1=create ln_top1
this.ln_bottom2=create ln_bottom2
this.ln_bottom1=create ln_bottom1
this.st_10=create st_10
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.cb_grouping,&
this.st_8,&
this.st_5,&
this.cb_pivot,&
this.cb_restoreview,&
this.cb_saveview,&
this.st_3,&
this.st_7,&
this.st_6,&
this.st_4,&
this.st_2,&
this.cb_manageviews,&
this.cb_formatreport,&
this.cb_sorting,&
this.cb_modifycolumns,&
this.st_1,&
this.cb_ok,&
this.st_buttonbar,&
this.p_bitmap,&
this.st_description,&
this.ln_top2,&
this.ln_top1,&
this.ln_bottom2,&
this.ln_bottom1,&
this.st_10,&
this.ln_1,&
this.ln_2}
end on

on w_reporting_services.destroy
destroy(this.cb_grouping)
destroy(this.st_8)
destroy(this.st_5)
destroy(this.cb_pivot)
destroy(this.cb_restoreview)
destroy(this.cb_saveview)
destroy(this.st_3)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.cb_manageviews)
destroy(this.cb_formatreport)
destroy(this.cb_sorting)
destroy(this.cb_modifycolumns)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.st_buttonbar)
destroy(this.p_bitmap)
destroy(this.st_description)
destroy(this.ln_top2)
destroy(this.ln_top1)
destroy(this.ln_bottom2)
destroy(this.ln_bottom1)
destroy(this.st_10)
destroy(this.ln_1)
destroy(this.ln_2)
end on

event open;f_center_window(this)

in_report = Message.PowerObjectParm

If Not IsValid(in_report) Then Return
If Not IsValid(in_report.of_get_object('Datasource')) Then Return
If Not in_report.of_get_object('Datasource').TypeOf() = Datawindow! Then Return

cb_modifycolumns.Enabled = IsValid(in_report.of_get_object('Datasource').Dynamic of_get_service('n_show_fields'))
cb_sorting.Enabled = IsValid(in_report.of_get_object('Datasource').Dynamic of_get_service('n_sort_service'))
cb_grouping.Enabled = IsValid(in_report.of_get_object('Datasource').Dynamic of_get_service('n_group_by_service'))
cb_formatreport.Enabled = IsValid(in_report.of_get_object('Datasource').Dynamic of_get_service('n_datawindow_formatting_service'))
cb_pivot.Enabled = Upper(Trim(in_report.of_get('UsePivotService'))) = 'Y'
cb_saveview.Enabled = IsValid(in_report.of_get_object('Datasource').Dynamic of_get_service('n_dao_dataobject_state'))
cb_restoreview.Enabled = IsValid(in_report.of_get_object('Datasource').Dynamic of_get_service('n_dao_dataobject_state'))
cb_manageviews.Enabled = True

this.backcolor = gn_globals.in_theme.of_get_backcolor()
st_2.backcolor = This.backcolor
st_3.backcolor = This.backcolor
st_4.backcolor = This.backcolor
st_5.backcolor = This.backcolor
st_6.backcolor = This.backcolor
st_7.backcolor = This.backcolor
st_8.backcolor = This.backcolor

end event

type cb_grouping from commandbutton within w_reporting_services
integer x = 55
integer y = 476
integer width = 439
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Grouping..."
end type

event clicked;NonVisualObject ln_service
ln_service = in_report.of_get_object('Datasource').Dynamic of_get_service('n_group_by_service')

If IsValid(ln_service) Then
	ln_service.Event Dynamic ue_notify('group by window', '')
End If
end event

type st_8 from statictext within w_reporting_services
integer x = 562
integer y = 492
integer width = 1248
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Change grouping, create a custom group by expression."
boolean focusrectangle = false
end type

type st_5 from statictext within w_reporting_services
integer x = 562
integer y = 740
integer width = 1138
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Create a Pivot Chart/Graph of this report."
boolean focusrectangle = false
end type

type cb_pivot from commandbutton within w_reporting_services
integer x = 55
integer y = 724
integer width = 439
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Create Pivot..."
end type

event clicked;in_report.Dynamic of_get_object('Datasource').GetParent(). Event ue_notify('menucommand', 'pivottable')
end event

type cb_restoreview from commandbutton within w_reporting_services
integer x = 55
integer y = 1148
integer width = 439
integer height = 88
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Restore View"
end type

event clicked;NonVisualObject ln_service
ln_service = in_report.of_get_object('Datasource').Dynamic of_get_service('n_dao_dataobject_state')

If gn_globals.in_messagebox.of_messagebox_question ('Are you sure you would like to restore the original view?  All formatting changes will be lost.', YesNoCancel!, 3) <> 1 Then Return

If IsValid(ln_service) Then
	ln_service.Event Dynamic ue_notify('restore view', '')
End If
end event

type cb_saveview from commandbutton within w_reporting_services
integer x = 55
integer y = 992
integer width = 439
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Save View..."
end type

event clicked;NonVisualObject ln_service
ln_service = in_report.of_get_object('Datasource').Dynamic of_get_service('n_dao_dataobject_state')

If IsValid(ln_service) Then
	ln_service.Event Dynamic ue_notify('save view', '')
End If
end event

type st_3 from statictext within w_reporting_services
integer x = 562
integer y = 1008
integer width = 1138
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Save this view of the report."
boolean focusrectangle = false
end type

type st_7 from statictext within w_reporting_services
integer x = 562
integer y = 888
integer width = 1358
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Manage Views:  Report/Criteria/Pivot/Nested/Etc."
boolean focusrectangle = false
end type

type st_6 from statictext within w_reporting_services
integer x = 562
integer y = 616
integer width = 1138
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Change formatting options for the report."
boolean focusrectangle = false
end type

type st_4 from statictext within w_reporting_services
integer x = 562
integer y = 368
integer width = 1138
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Change sorting, create a custom sort expression."
boolean focusrectangle = false
end type

type st_2 from statictext within w_reporting_services
integer x = 562
integer y = 244
integer width = 1202
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Add/Create/Rearrange/Format columns on the report."
boolean focusrectangle = false
end type

type cb_manageviews from commandbutton within w_reporting_services
integer x = 55
integer y = 872
integer width = 439
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Manage Views..."
end type

event clicked;in_report.Dynamic of_get_object('Datasource').GetParent(). Event ue_notify('manage report views', '')
end event

type cb_formatreport from commandbutton within w_reporting_services
integer x = 55
integer y = 600
integer width = 439
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Report Settings..."
end type

event clicked;NonVisualObject ln_service
ln_service = in_report.of_get_object('Datasource').Dynamic of_get_service('n_datawindow_formatting_service')

If IsValid(ln_service) Then
	ln_service.Event Dynamic ue_notify('format', 'datawindow')
End If
end event

type cb_sorting from commandbutton within w_reporting_services
integer x = 55
integer y = 352
integer width = 439
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Sorting..."
end type

event clicked;NonVisualObject ln_service
ln_service = in_report.of_get_object('Datasource').Dynamic of_get_service('n_sort_service')

If IsValid(ln_service) Then
	ln_service.Event Dynamic ue_notify('sort multiple', '')
End If
end event

type cb_modifycolumns from commandbutton within w_reporting_services
integer x = 55
integer y = 228
integer width = 439
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Modify Columns..."
end type

event clicked;NonVisualObject ln_service
ln_service = in_report.of_get_object('Datasource').Dynamic of_get_service('n_show_fields')

If IsValid(ln_service) Then
	ln_service.Event Dynamic ue_notify('field selection', '')
End If
end event

type st_1 from statictext within w_reporting_services
integer x = 219
integer y = 52
integer width = 1326
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "This will allow you to customize the report in many ways."
boolean focusrectangle = false
end type

type cb_ok from u_commandbutton within w_reporting_services
integer x = 1422
integer y = 1148
integer width = 384
integer height = 88
integer taborder = 20
integer weight = 400
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;Close(Parent)
end event

type st_buttonbar from statictext within w_reporting_services
integer y = 1116
integer width = 32000
integer height = 152
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 79741120
boolean enabled = false
boolean focusrectangle = false
end type

type p_bitmap from picture within w_reporting_services
integer x = 37
integer y = 20
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Module - SmartSearch - Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_description from statictext within w_reporting_services
integer x = 219
integer y = 56
integer width = 2217
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type ln_top2 from line within w_reporting_services
long linecolor = 16777215
integer linethickness = 1
integer beginy = 176
integer endx = 32000
integer endy = 176
end type

type ln_top1 from line within w_reporting_services
long linecolor = 8421504
integer linethickness = 1
integer beginy = 172
integer endx = 32000
integer endy = 172
end type

type ln_bottom2 from line within w_reporting_services
long linecolor = 16777215
integer linethickness = 1
integer beginx = -59
integer beginy = 1112
integer endx = 31941
integer endy = 1112
end type

type ln_bottom1 from line within w_reporting_services
long linecolor = 8421504
integer linethickness = 1
integer beginy = 1108
integer endx = 31936
integer endy = 1108
end type

type st_10 from statictext within w_reporting_services
integer width = 32000
integer height = 172
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type ln_1 from line within w_reporting_services
long linecolor = 16777215
integer linethickness = 1
integer beginx = 114
integer beginy = 844
integer endx = 1733
integer endy = 844
end type

type ln_2 from line within w_reporting_services
long linecolor = 8421504
integer linethickness = 1
integer beginx = 119
integer beginy = 840
integer endx = 1733
integer endy = 840
end type

