$PBExportHeader$u_dynamic_gui_manage_views_dataobject.sru
forward
global type u_dynamic_gui_manage_views_dataobject from u_dynamic_gui_manage_views
end type
type dw_reportview from datawindow within u_dynamic_gui_manage_views_dataobject
end type
type st_reportview from statictext within u_dynamic_gui_manage_views_dataobject
end type
type cbx_allownavigation from checkbox within u_dynamic_gui_manage_views_dataobject
end type
type cbx_autoretrieve from cbx_default_view within u_dynamic_gui_manage_views_dataobject
end type
end forward

global type u_dynamic_gui_manage_views_dataobject from u_dynamic_gui_manage_views
integer height = 1604
string text = "Report Views"
long tabbackcolor = 81448892
string picturename = "Module - Reporting Desktop - Datawindow View.bmp"
dw_reportview dw_reportview
st_reportview st_reportview
cbx_allownavigation cbx_allownavigation
cbx_autoretrieve cbx_autoretrieve
end type
global u_dynamic_gui_manage_views_dataobject u_dynamic_gui_manage_views_dataobject

forward prototypes
public subroutine of_delete ()
public subroutine of_apply_globally_available ()
public subroutine of_init (n_bag an_bag)
end prototypes

public subroutine of_delete ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_delete
//	Arguments:  
//	Overview:   Override the ancestor delete so that we can limit the user from deleting
//					a report view that belongs to a document template
//	Created by: Teresa Kroh
//	History:    6/6/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long 		ll_index
Long		ll_rowcount
Long		ll_defaultcount
Long		ll_detailcount
Long		ll_nestedcount
Long		ll_defaultnestedcount
String	ls_DOStateID
String	ls_findstring
String 	ls_notfindstring

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Then Return

If Not lv_doctypes.DeleteItems Then
	gn_globals.in_messagebox.of_messagebox('You cannot delete this view because it was not created by you and you are not a System Administrator.', Information!, OK!, 1)
	Return
End If

If IsValid(ids_datastore) and ll_index <= ids_datastore.RowCount() Then
		 
	ls_DOStateID = trim(string(ids_datastore.GetItemNumber(ll_index,"idnty")))
	
	// Find if this dataobjectstate is used on a reportconfignested that belongs to a template
	
	ls_findstring = '%dtaobjctstteidnty=' + ls_DOStateID + '%'
	ls_notfindstring = '%dtaobjctstteidnty=' + ls_DOStateID + '[0-9]%'
	
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
	
	ls_findstring = '%dtaobjctstteidnty[[]equals]' + ls_DOStateID + '%'
	ls_notfindstring = '%dtaobjctstteidnty[[]equals]' + ls_DOStateID + '[0-9]%'
		
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

public subroutine of_apply_globally_available ();Long ll_index

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Or ll_index > ids_datastore.RowCount() Then Return

If ib_GloballyAvailableIsAnOption Then
	cbx_globallyavailable.Checked = IsNull(ids_datastore.GetItemNumber(ll_index, is_username_column))
	cbx_globallyavailable.Enabled = ids_datastore.GetItemNumber(ll_index, is_createdbyuser_column) = gn_globals.il_userid or ib_ThisUserIsAnAdministrator
	lv_doctypes.DeleteItems = cbx_globallyavailable.Enabled
	lv_doctypes.EditLabels = cbx_globallyavailable.Enabled
End If

If ib_DefaultIsAnOption Then
	cbx_default_view.Checked = Upper(Trim(ids_datastore.GetItemString(ll_index, is_default_column))) = 'Y'
	cbx_default_view.Enabled = Not cbx_globallyavailable.Checked Or Not ib_GloballyAvailableIsAnOption Or ib_ThisUserIsAnAdministrator
End If

cbx_autoretrieve.Enabled = ids_datastore.GetItemNumber(ll_index, is_createdbyuser_column) = gn_globals.il_userid or ib_ThisUserIsAnAdministrator
cbx_allownavigation.Enabled = ids_datastore.GetItemNumber(ll_index, is_createdbyuser_column) = gn_globals.il_userid or ib_ThisUserIsAnAdministrator
If ids_datastore.GetItemNumber(ll_index, is_createdbyuser_column) = gn_globals.il_userid or ib_ThisUserIsAnAdministrator Then
	dw_reportview.Modify("Datawindow.ReadOnly=No")
Else
	dw_reportview.Modify("Datawindow.ReadOnly=Yes")
End If

end subroutine

public subroutine of_init (n_bag an_bag);DatawindowChild ldwc_reportview

dw_reportview.SetTransObject(SQLCA)
dw_reportView.GetChild('EntityID', ldwc_reportview)
ldwc_reportview.SetTransObject(SQLCA)
ldwc_reportview.InsertRow(0)
dw_reportView.InsertRow(0)

//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_init
// Overrides:  No
// Overview:   
// Created by: Blake Doerr
// History:    				Blake Doerr	First Created
//					01/06/2003	Chris Cole	raid 30470 setting displaydataobjectname adding to retrieve
//-----------------------------------------------------------------------------------------------------------------------------------

//Chris Cole
String ls_displaydataobjectname, ls_isglobaladmin = 'Y'

if isnull(an_bag.of_get('displaydataobjectname')) then 
	ls_displaydataobjectname = 'None' 
else
	ls_displaydataobjectname	= an_bag.of_get('displaydataobjectname')
end if 
//Chris Cole

//-----------------------------------------------------------------------------------
// Check security and enable or disable the checkbox for saving global views
//-----------------------------------------------------------------------------------
//n_license_crypto ln_license_crypto
//string s_return
//
//ln_license_crypto = create n_license_crypto
//s_return  = ln_license_crypto.of_verify_license_for_userandrole(gn_globals.is_username,'PowerUser License')
//
//if s_return  <> '' then 
//		cbx_globallyavailable.enabled = FALSE
//		ib_globallyavailableisanoption = FALSE
//end if
//destroy ln_license_crypto

//-----------------------------------------------------------------------------------
// Check security and see if the user has the authority to manage other people's views
//-----------------------------------------------------------------------------------
//if gn_globals.in_security.of_get_security('u_dynamic_gui_manage_views') < 2 then
//		ls_isglobaladmin = 'N'
//end if

il_reportconfigid = Long(an_bag.of_get('RprtCnfgID'))
il_userid			= gn_globals.il_userid
ids_datastore.DataObject = is_dataobjectname
ids_datastore.SetTransObject(SQLCA)

ids_datastore.Retrieve(il_reportconfigid, il_userid, ls_displaydataobjectname, ls_isglobaladmin)  //Chris Cole 01/06/2003


This.of_load_listview()
//-----------------------------------------------------------------------------------

ldwc_reportview.Retrieve()
ldwc_reportview.InsertRow(1)
ldwc_reportview.SetItem(1, 'EnttyID', 0)
ldwc_reportview.SetItem(1, 'EnttyDsplyNme', '(Original Report Entity)')
If IsNull(dw_reportView.GetItemNumber(1, 1)) Then
	dw_reportView.SetItem(1, 1, 0)
End If


end subroutine

on u_dynamic_gui_manage_views_dataobject.create
int iCurrent
call super::create
this.dw_reportview=create dw_reportview
this.st_reportview=create st_reportview
this.cbx_allownavigation=create cbx_allownavigation
this.cbx_autoretrieve=create cbx_autoretrieve
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_reportview
this.Control[iCurrent+2]=this.st_reportview
this.Control[iCurrent+3]=this.cbx_allownavigation
this.Control[iCurrent+4]=this.cbx_autoretrieve
end on

on u_dynamic_gui_manage_views_dataobject.destroy
call super::destroy
destroy(this.dw_reportview)
destroy(this.st_reportview)
destroy(this.cbx_allownavigation)
destroy(this.cbx_autoretrieve)
end on

event constructor;call super::constructor;ib_GloballyAvailableIsAnOption	= True
is_bitmap_column						= 'ItemIcon'
is_description_column				= 'Name'
is_username_column					= 'UserID'
is_dataobjectname						= 'd_manage_view_dataobjectstate'
ib_defaultisanoption					= True
is_argument_to_publish				= 'ReportView'
end event

event resize;call super::resize;cbx_allownavigation.Y = cbx_globallyavailable.Y - cbx_allownavigation.Height - 20
cbx_autoretrieve.Y = cbx_globallyavailable.Y - cbx_autoretrieve.Height - 20
dw_reportview.Y = cbx_allownavigation.Y - dw_reportview.Height - 20
st_reportview.Y = dw_reportview.Y + 10
lv_doctypes.Height = dw_reportview.Y - 20 - lv_doctypes.Y
end event

type cbx_default_view from u_dynamic_gui_manage_views`cbx_default_view within u_dynamic_gui_manage_views_dataobject
integer x = 1006
integer y = 1008
end type

event cbx_default_view::clicked;Long index, ll_index, ll_return

If Not ib_DefaultIsAnOption Then Return

index = lv_doctypes.SelectedIndex()
	
If index <= 0 Or IsNull(index) Or index > ids_datastore.RowCount() Then Return

If This.Checked Then
	If IsNull(ids_datastore.GetItemNumber(index, is_username_column)) Then
		If Not ib_ThisUserIsAnAdministrator Then
			gn_globals.in_messagebox.of_messagebox('You cannot set this view as default because it is a global view and you are not a System Administrator', Information!, OK!, 1)
			This.Checked = False
			Return
		Else
			For ll_index = 1 To ids_datastore.RowCount()
				If index = ll_index Then Continue
				
				If Upper(Trim(ids_datastore.GetItemString(ll_index, is_default_column))) = 'Y' And IsNull(ids_datastore.GetItemNumber(ll_index, is_username_column)) Then
					gn_globals.in_messagebox.of_messagebox('You cannot set this view as default because the view "' + ids_datastore.GetItemString(ll_index, is_description_column) + '" is already a global default', Information!, OK!, 1)
					This.Checked = False
					Return
				End If
			Next
		End If
	Else
		For ll_index = 1 To ids_datastore.RowCount()
			If Upper(Trim(ids_datastore.GetItemString(ll_index, is_default_column))) = 'Y' And Not IsNull(ids_datastore.GetItemNumber(ll_index, is_username_column)) Then
				If index = ll_index Then Continue
				ids_datastore.SetItem(ll_index, is_default_column, 'N')
			End If
		Next
	End If
	
	ids_datastore.SetItem(index, is_default_column, 'Y')
	
Else
	ids_datastore.SetItem(index, is_default_column, 'N')
End If
end event

type cbx_globallyavailable from u_dynamic_gui_manage_views`cbx_globallyavailable within u_dynamic_gui_manage_views_dataobject
integer y = 1000
end type

event cbx_globallyavailable::clicked;Long index, ll_null, ll_return

If Not ib_GloballyAvailableIsAnOption Then Return
SetNull(ll_null)

index = lv_doctypes.SelectedIndex()

If index <= 0 Or IsNull(index) Or index > ids_datastore.RowCount() Then Return

If This.Checked Then
	If Upper(Trim(ids_datastore.GetItemString(index, is_default_column))) = 'Y' Then
		//ll_return = gn_globals.in_messagebox.of_messagebox_question ('If you make this view global, it will no longer be your default view.  Continue setting this as a global view', YesNoCancel!, 1)

		Choose Case ll_return
			Case 1
				ids_datastore.SetItem(index, is_default_column, 'N')
				cbx_default_view.Checked = False
			Case 2, 3
				This.Checked = False
				cbx_default_view.Enabled = ib_ThisUserIsAnAdministrator
				Return
		End Choose
	End If
	
	ids_datastore.SetItem(index, is_username_column, ll_null)
Else
	If Not ids_datastore.GetItemNumber(index, 'CreatedByUserID') = gn_globals.il_userid Then
		If Not ib_ThisUserIsAnAdministrator Then
			gn_globals.in_messagebox.of_messagebox('You cannot set this view as non-global because you are not a System Administrator and you did not create this view', Information!, OK!, 1)
			This.Checked = True
			Return
		Else
			ids_datastore.SetItem(index, is_username_column, gn_globals.il_userid)
		End If
	Else
		ids_datastore.SetItem(index, is_username_column, gn_globals.il_userid)
	End If

	ids_datastore.SetItem(index, is_default_column, 'N')
	cbx_default_view.Checked = False
End If

cbx_default_view.Enabled = Not This.Checked Or ib_ThisUserIsAnAdministrator
end event

type lv_doctypes from u_dynamic_gui_manage_views`lv_doctypes within u_dynamic_gui_manage_views_dataobject
integer height = 776
end type

event lv_doctypes::itemchanged;call super::itemchanged;Long	ll_index
Long	ll_reportviewid

If IsNull(index) or index = 0 Then
	index = lv_doctypes.SelectedIndex()
End If

If index <= 0 Or IsNull(index) Or index > ids_datastore.RowCount() Then Return

ll_reportviewid = ids_datastore.GetItemNumber(index, 'EnttyID')
If IsNull(ll_reportviewid) Then
	ll_reportviewid = 0
End If

dw_reportview.SetItem(1, 1, ll_reportviewid)
cbx_allownavigation.Checked = Upper(Trim(ids_datastore.GetItemString(index, 'IsNavigationDestination'))) = 'Y'
cbx_autoretrieve.Checked = Upper(Trim(ids_datastore.GetItemString(index, 'AutoRetrieve'))) = 'Y'
end event

type dw_reportview from datawindow within u_dynamic_gui_manage_views_dataobject
integer x = 329
integer y = 812
integer width = 960
integer height = 92
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_dataobjectstate_view_entity"
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

ids_datastore.SetItem(ll_index, 'EnttyID', ll_reportviewid)
cbx_allownavigation.Checked = Upper(Trim(ids_datastore.GetItemString(ll_index, 'IsNavigationDestination'))) = 'Y'
end event

type st_reportview from statictext within u_dynamic_gui_manage_views_dataobject
integer x = 18
integer y = 824
integer width = 320
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
string text = "Report Entity:"
boolean focusrectangle = false
end type

type cbx_allownavigation from checkbox within u_dynamic_gui_manage_views_dataobject
integer x = 18
integer y = 916
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

type cbx_autoretrieve from cbx_default_view within u_dynamic_gui_manage_views_dataobject
integer x = 1001
integer y = 920
integer width = 398
boolean bringtotop = true
string text = "Auto Retrieve"
end type

event clicked;call super::clicked;Long 	ll_index
Long	ll_reportviewid

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Or ll_index > ids_datastore.RowCount() Then Return
If This.Checked Then
	ids_datastore.SetItem(ll_index, 'AutoRetrieve', 'Y')
Else
	ids_datastore.SetItem(ll_index, 'AutoRetrieve', 'N')
End If
end event

