$PBExportHeader$u_dynamic_gui_manage_views_uomcurrency.sru
forward
global type u_dynamic_gui_manage_views_uomcurrency from u_dynamic_gui_manage_views
end type
end forward

global type u_dynamic_gui_manage_views_uomcurrency from u_dynamic_gui_manage_views
string text = "UOM/Currency Views"
long tabbackcolor = 81448892
string picturename = "Module - Reporting Desktop - UOMCurrency View.bmp"
end type
global u_dynamic_gui_manage_views_uomcurrency u_dynamic_gui_manage_views_uomcurrency

forward prototypes
public subroutine of_delete ()
end prototypes

public subroutine of_delete ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete
//	Arguments:  
//	Overview:   Override the ancestor delete so that we can limit the user from deleting
//					a filter view that belongs to a document template
//	Created by: Teresa Kroh
//	History:    6/6/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long 		ll_index
Long		ll_rowcount
Long		ll_defaultcount
Long		ll_detailcount
Long		ll_nestedcount
Long		ll_defaultnestedcount
String	ls_RprtDfltId
String	ls_findstring
String 	ls_notfindstring

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Then Return

If Not lv_doctypes.DeleteItems Then
	gn_globals.in_messagebox.of_messagebox('You cannot delete this view because it was not created by you and you are not a System Administrator.', Information!, OK!, 1)
	Return
End If

If IsValid(ids_datastore) and ll_index <= ids_datastore.RowCount() Then
		 
	ls_RprtDfltId = trim(string(ids_datastore.GetItemNumber(ll_index,"rprtdfltid")))
	
	// Find if this dataobjectstate is used on a reportconfignested that belongs to a template
	
	ls_findstring = '%UOMCurrencyViewID=' + ls_RprtDfltId + '%'
	ls_notfindstring = '%UOMCurrencyViewID=' + ls_RprtDfltId + '[0-9]%'
	
	select	count(*) 
	into		:ll_rowcount
	from 		ReportConfig, ReportConfigNested
	where 	ReportConfig.TmplteRprtCnfgNstdID = ReportConfigNested.RprtCnfgNstdID
	and		Upper(ReportConfig.IsTmplte) = 'Y'
	and		ReportConfigNested.Parameter like :ls_findstring
	and		ReportConfigNested.Parameter not like :ls_notfindstring;
	
	// Find if this dataobjectstate is used on a reportconfignested that is the default for a domain
	
	select	count(*)
	into		:ll_defaultcount
	from		DocumentDomain, ReportConfigNested
	where 	DocumentDomain.DefaultRprtCnfgNstdID = ReportConfigNested.RprtCnfgNstdID
	and		ReportConfigNested.Parameter like :ls_findstring
	and		ReportConfigNested.Parameter not like :ls_notfindstring;
	
	// Find if this dataobjectstate is used on a reportconfignesteddetail, for a reportconfignested, that belongs to a template
	
	ls_findstring = '%UOMCurrencyViewID[[]equals]' + ls_RprtDfltId + '%'
	ls_notfindstring = '%UOMCurrencyViewID[[]equals]' + ls_RprtDfltId + '[0-9]%'
		
	select	count(*)
	into		:ll_nestedcount
	from 		ReportConfig, ReportConfigNestedDetail
	where		ReportConfig.TmplteRprtCnfgnstdID = ReportConfigNestedDetail.RprtCnfgNstdID
	and		Upper(ReportConfig.IsTmplte) = 'Y'
	and		ReportConfigNestedDetail.Argument like :ls_findstring
	and		ReportConfigNestedDetail.Argument not like :ls_notfindstring;
	
	// Find if this dataobjectstate is used on a reportconfignesteddetail, for a reportconfignested, that is the default for a domain
	
	select	count(*)
	into		:ll_defaultnestedcount
	from 		DocumentDomain, ReportConfigNestedDetail
	where		DocumentDomain.DefaultRprtCnfgNstdID = ReportConfigNestedDetail.RprtCnfgNstdID
	and		ReportConfigNestedDetail.Argument like :ls_findstring
	and		ReportConfigNestedDetail.Argument not like :ls_notfindstring;
	
	
	
	if ll_rowcount > 0  or ll_defaultcount > 0 or ll_nestedcount > 0 or ll_defaultnestedcount > 0 then
		gn_globals.in_messagebox.of_messagebox('You cannot delete this view because it is being used by a Document Template.', Information!, OK!, 1)
	else
		lv_doctypes.DeleteItem(ll_index)
	end if
	
end if





end subroutine

on u_dynamic_gui_manage_views_uomcurrency.create
call super::create
end on

on u_dynamic_gui_manage_views_uomcurrency.destroy
call super::destroy
end on

event constructor;call super::constructor;ib_GloballyAvailableIsAnOption	= True
is_bitmap_column						= 'ItemIcon'
is_description_column				= 'Name'
is_username_column					= 'UserID'
is_dataobjectname						= 'd_manage_view_uomcurrency'
is_argument_to_publish				= 'CriteriaView'
end event

type cbx_default_view from u_dynamic_gui_manage_views`cbx_default_view within u_dynamic_gui_manage_views_uomcurrency
end type

type cbx_globallyavailable from u_dynamic_gui_manage_views`cbx_globallyavailable within u_dynamic_gui_manage_views_uomcurrency
end type

type lv_doctypes from u_dynamic_gui_manage_views`lv_doctypes within u_dynamic_gui_manage_views_uomcurrency
end type

