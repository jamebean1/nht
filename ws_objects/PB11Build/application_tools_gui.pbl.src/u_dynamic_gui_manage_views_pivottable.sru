$PBExportHeader$u_dynamic_gui_manage_views_pivottable.sru
forward
global type u_dynamic_gui_manage_views_pivottable from u_dynamic_gui_manage_views
end type
type st_reportview from statictext within u_dynamic_gui_manage_views_pivottable
end type
type dw_reportview from datawindow within u_dynamic_gui_manage_views_pivottable
end type
type cbx_allownavigation from checkbox within u_dynamic_gui_manage_views_pivottable
end type
end forward

global type u_dynamic_gui_manage_views_pivottable from u_dynamic_gui_manage_views
integer height = 1136
string text = "Pivot Views"
string picturename = "Module - Reporting Desktop - Pivot Table Wizard.bmp"
long il_reportconfigid = 66387904
long il_userid = 184859200
st_reportview st_reportview
dw_reportview dw_reportview
cbx_allownavigation cbx_allownavigation
end type
global u_dynamic_gui_manage_views_pivottable u_dynamic_gui_manage_views_pivottable

forward prototypes
public subroutine of_init (n_bag an_bag)
end prototypes

public subroutine of_init (n_bag an_bag);DatawindowChild ldwc_reportview

dw_reportview.SetTransObject(SQLCA)
dw_reportView.GetChild('DataObjectStateIdnty', ldwc_reportview)
ldwc_reportview.SetTransObject(SQLCA)
ldwc_reportview.InsertRow(0)
dw_reportView.InsertRow(0)

Super::of_init(an_bag)

ldwc_reportview.Retrieve(il_reportconfigid, il_userid)
ldwc_reportview.InsertRow(1)
ldwc_reportview.SetItem(1, 'Idnty', 0)
ldwc_reportview.SetItem(1, 'Name', '(None)')
If IsNull(dw_reportView.GetItemNumber(1, 1)) Then
	dw_reportView.SetItem(1, 1, 0)
End If


end subroutine

on u_dynamic_gui_manage_views_pivottable.create
int iCurrent
call super::create
this.st_reportview=create st_reportview
this.dw_reportview=create dw_reportview
this.cbx_allownavigation=create cbx_allownavigation
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_reportview
this.Control[iCurrent+2]=this.dw_reportview
this.Control[iCurrent+3]=this.cbx_allownavigation
end on

on u_dynamic_gui_manage_views_pivottable.destroy
call super::destroy
destroy(this.st_reportview)
destroy(this.dw_reportview)
destroy(this.cbx_allownavigation)
end on

event constructor;call super::constructor;ib_GloballyAvailableIsAnOption	= True
is_bitmap_column						= 'CollapsedBitmapName'
is_description_column				= 'Description'
is_username_column					= 'UserID'
is_dataobjectname						= 'd_manage_view_pivots'
is_argument_to_publish				= 'PivotTableView'
end event

event resize;call super::resize;cbx_allownavigation.Y = cbx_globallyavailable.Y - cbx_allownavigation.Height - 20
dw_reportview.Y = cbx_allownavigation.Y - dw_reportview.Height - 20
st_reportview.Y = dw_reportview.Y + 10
lv_doctypes.Height = dw_reportview.Y - 20 - lv_doctypes.Y
end event

type cbx_default_view from u_dynamic_gui_manage_views`cbx_default_view within u_dynamic_gui_manage_views_pivottable
integer y = 1036
end type

type cbx_globallyavailable from u_dynamic_gui_manage_views`cbx_globallyavailable within u_dynamic_gui_manage_views_pivottable
integer y = 1036
end type

type lv_doctypes from u_dynamic_gui_manage_views`lv_doctypes within u_dynamic_gui_manage_views_pivottable
integer height = 828
end type

event lv_doctypes::itemchanged;call super::itemchanged;Long	ll_index
Long	ll_reportviewid

If IsNull(index) or index = 0 Then
	index = lv_doctypes.SelectedIndex()
End If

If index <= 0 Or IsNull(index) Or index > ids_datastore.RowCount() Then Return

ll_reportviewid = ids_datastore.GetItemNumber(index, 'DtaObjctStteIdnty')
If IsNull(ll_reportviewid) Then
	ll_reportviewid = 0
End If

dw_reportview.SetItem(1, 1, ll_reportviewid)
cbx_allownavigation.Checked = Upper(Trim(ids_datastore.GetItemString(index, 'IsNavigationDestination'))) = 'Y'
end event

type st_reportview from statictext within u_dynamic_gui_manage_views_pivottable
integer x = 18
integer y = 868
integer width = 297
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report View:"
boolean focusrectangle = false
end type

type dw_reportview from datawindow within u_dynamic_gui_manage_views_pivottable
integer x = 306
integer y = 856
integer width = 1019
integer height = 92
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_pivot_table_view_reportview"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long 	ll_index
Long	ll_reportviewid

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Or ll_index > ids_datastore.RowCount() Then Return
ll_reportviewid = Long(data)

If ll_reportviewid = 0 Then
	SetNull(ll_reportviewid)
End If

ids_datastore.SetItem(ll_index, 'DtaObjctStteIdnty', ll_reportviewid)
cbx_allownavigation.Checked = Upper(Trim(ids_datastore.GetItemString(ll_index, 'IsNavigationDestination'))) = 'Y'
end event

type cbx_allownavigation from checkbox within u_dynamic_gui_manage_views_pivottable
integer x = 18
integer y = 964
integer width = 969
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Allow Navigation Directly to this View"
borderstyle borderstyle = stylelowered!
end type

event clicked;Long 	ll_index
Long	ll_reportviewid

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Or ll_index > ids_datastore.RowCount() Then Return
If This.Checked Then
	ids_datastore.SetItem(ll_index, 'IsNavigationDestination', 'Y')
Else
	ids_datastore.SetItem(ll_index, 'IsNavigationDestination', 'N')
End If
end event

