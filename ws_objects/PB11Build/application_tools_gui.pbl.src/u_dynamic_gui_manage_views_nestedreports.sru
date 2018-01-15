$PBExportHeader$u_dynamic_gui_manage_views_nestedreports.sru
forward
global type u_dynamic_gui_manage_views_nestedreports from u_dynamic_gui_manage_views
end type
type cbx_allownavigation from checkbox within u_dynamic_gui_manage_views_nestedreports
end type
end forward

global type u_dynamic_gui_manage_views_nestedreports from u_dynamic_gui_manage_views
integer height = 1244
string text = "Pivot Table Views"
string picturename = "Module - Reporting Desktop - Pivot Table Wizard.bmp"
long il_reportconfigid = 36794096
cbx_allownavigation cbx_allownavigation
end type
global u_dynamic_gui_manage_views_nestedreports u_dynamic_gui_manage_views_nestedreports

forward prototypes
public subroutine of_delete ()
end prototypes

public subroutine of_delete ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete
//	Arguments:  
//	Overview:   Override the ancestor delete so that we can limit the user from deleting
//					a nested report that belongs to a document template
//	Created by: Teresa Kroh
//	History:    6/6/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
  
  
long	ll_nestid
long	ll_rowcount
Long	ll_defaultcount
Long	ll_index

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Then Return

If Not lv_doctypes.DeleteItems Then
	gn_globals.in_messagebox.of_messagebox('You cannot delete this view because it was not created by you and you are not a System Administrator.', Information!, OK!, 1)
	Return
End If


If IsValid(ids_datastore) and ll_index <= ids_datastore.RowCount() Then
		 
	ll_nestid = ids_datastore.GetItemNumber(ll_index,"RprtCnfgNstdID")
	
	select	count(*) 
	into		:ll_rowcount
	from 		ReportConfig
	where 	ReportConfig.TmplteRprtCnfgNstdID = :ll_nestid
	and		upper(ReportConfig.IsTmplte) = 'Y';
	
	select	count(*)
	into		:ll_defaultcount
	from		DocumentDomain
	where 	DocumentDomain.DefaultRprtCnfgNstdID = :ll_nestid;
	
	if ll_rowcount > 0  or ll_defaultcount > 0 then
		gn_globals.in_messagebox.of_messagebox('You cannot delete this view because it is being used by a Document Template.', Information!, OK!, 1)
	else
		lv_doctypes.DeleteItem(ll_index)
	end if
	
end if

end subroutine

on u_dynamic_gui_manage_views_nestedreports.create
int iCurrent
call super::create
this.cbx_allownavigation=create cbx_allownavigation
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_allownavigation
end on

on u_dynamic_gui_manage_views_nestedreports.destroy
call super::destroy
destroy(this.cbx_allownavigation)
end on

event constructor;call super::constructor;ib_GloballyAvailableIsAnOption	= True
is_bitmap_column						= 'ItemIcon'
is_description_column				= 'Name'
is_username_column					= 'UserID'
is_createdbyuser_column				= 'CreatedUserID'
is_dataobjectname						= 'd_reportconfignested_available'
is_argument_to_publish				= 'NestedReportView'
end event

event resize;call super::resize;cbx_allownavigation.Y = cbx_globallyavailable.Y - cbx_allownavigation.Height - 20
lv_doctypes.Height = cbx_allownavigation.Y - 20 - lv_doctypes.Y
end event

type cbx_default_view from u_dynamic_gui_manage_views`cbx_default_view within u_dynamic_gui_manage_views_nestedreports
end type

type cbx_globallyavailable from u_dynamic_gui_manage_views`cbx_globallyavailable within u_dynamic_gui_manage_views_nestedreports
integer y = 1048
end type

type lv_doctypes from u_dynamic_gui_manage_views`lv_doctypes within u_dynamic_gui_manage_views_nestedreports
end type

event lv_doctypes::itemchanged;call super::itemchanged;Long	ll_index
Long	ll_reportviewid

If IsNull(index) or index = 0 Then
	index = lv_doctypes.SelectedIndex()
End If

If index <= 0 Or IsNull(index) Or index > ids_datastore.RowCount() Then Return

cbx_allownavigation.Checked = Upper(Trim(ids_datastore.GetItemString(index, 'AllowNavigation'))) = 'Y'
end event

type cbx_allownavigation from checkbox within u_dynamic_gui_manage_views_nestedreports
integer x = 18
integer y = 968
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
	ids_datastore.SetItem(ll_index, 'AllowNavigation', 'Y')
Else
	ids_datastore.SetItem(ll_index, 'AllowNavigation', 'N')
End If
end event

