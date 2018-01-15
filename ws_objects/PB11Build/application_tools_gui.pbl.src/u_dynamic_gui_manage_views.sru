$PBExportHeader$u_dynamic_gui_manage_views.sru
forward
global type u_dynamic_gui_manage_views from u_dynamic_gui
end type
type cbx_default_view from checkbox within u_dynamic_gui_manage_views
end type
type cbx_globallyavailable from checkbox within u_dynamic_gui_manage_views
end type
type lv_doctypes from listview within u_dynamic_gui_manage_views
end type
end forward

global type u_dynamic_gui_manage_views from u_dynamic_gui
integer width = 1481
integer height = 1084
boolean border = false
long backcolor = 81448892
long picturemaskcolor = 16777215
cbx_default_view cbx_default_view
cbx_globallyavailable cbx_globallyavailable
lv_doctypes lv_doctypes
end type
global u_dynamic_gui_manage_views u_dynamic_gui_manage_views

type variables
Protected:
	Datastore	ids_datastore
	Boolean		ib_deleting_in_code 					= False
	Boolean		ib_GloballyAvailableIsAnOption	= True
	Boolean		ib_DefaultIsAnOption					= False
	Boolean		ib_ThisUserIsAnAdministrator		= False
	String		is_bitmap_column						= 'CollapsedBitmapName'
	String		is_description_column				= 'Description'
	String		is_username_column					= 'UserID'
	String		is_dataobjectname						= 'dddw_pivot_table_view'
	String		is_createdbyuser_column				= 'CreatedByUserID'
	String		is_createdbyusername_column		= 'CreatedByUserName'
	String		is_default_column						= 'IsDefault'
	String		is_message_to_publish				= 'refresh cache'
	String		is_argument_to_publish				= ''
	Long			il_reportconfigid
	Long			il_userid
end variables

forward prototypes
public function boolean of_ismodified ()
public subroutine of_resetupdate ()
public function string of_save ()
public subroutine of_init (n_bag an_bag)
public subroutine of_load_listview ()
public subroutine of_delete ()
public subroutine of_rename ()
public subroutine of_apply_globally_available ()
end prototypes

public function boolean of_ismodified ();Return False
end function

public subroutine of_resetupdate ();ids_datastore.ResetUpdate()
end subroutine

public function string of_save ();If Not ids_datastore.Update(True, False) > 0 Then Return 'Error:  Could not update your views'

If is_argument_to_publish <> '' Then
	If IsValid(gn_globals) Then
		If IsValid(gn_globals.in_subscription_service) Then
			gn_globals.in_subscription_service.of_message(is_message_to_publish, is_argument_to_publish)
		End If
	End If
End If

Return ''
end function

public subroutine of_init (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_init
// Overrides:  No
// Overview:   
// Created by: Blake Doerr
// History:    				Blake Doerr	First Created
//					01/06/2003	Chris Cole	raid 30470 setting displaydataobjectname adding to retrieve
//-----------------------------------------------------------------------------------------------------------------------------------

String ls_isglobaladmin = 'Y'

//-----------------------------------------------------------------------------------
// Check security and enable or disable the checkbox for saving global views
//-----------------------------------------------------------------------------------
//n_license_crypto ln_license_crypto
string s_return

//ln_license_crypto = create n_license_crypto
//s_return  = ln_license_crypto.of_verify_license_for_userandrole(gn_globals.is_username,'PowerUser License')

if s_return  <> '' then 
		cbx_globallyavailable.enabled = FALSE
		ib_globallyavailableisanoption = FALSE
end if
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

ids_datastore.Retrieve(il_reportconfigid, il_userid,  ls_isglobaladmin)  

This.of_load_listview()
end subroutine

public subroutine of_load_listview ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_load_listview
// Overrides:  No
// Overview:   load the listview
// Created by: Blake Doerr
// History:    07.08.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index, ll_pict
listviewitem lvi_temp

lv_doctypes.SetRedraw(False)
ib_deleting_in_code = True
lv_doctypes.DeleteItems()
ib_deleting_in_code = False

for ll_index = 1 to ids_datastore.RowCount()
	ll_pict = lv_doctypes.addsmallpicture(ids_datastore.getitemstring(ll_index, is_bitmap_column))
	lv_doctypes.additem(ids_datastore.getitemstring(ll_index, is_description_column), ll_pict)
	lv_doctypes.setitem(ll_index,2,ids_datastore.getitemstring(ll_index,is_createdbyusername_column))
Next

If ids_datastore.RowCount() > 0 Then
	lv_doctypes.GetItem ( 1, lvi_temp )
	lvi_temp.Selected = True
	lv_doctypes.SetItem ( 1, lvi_temp )
End If

lv_doctypes.SetRedraw(True)
lv_doctypes.TriggerEvent('ItemChanged')
end subroutine

public subroutine of_delete ();Long ll_index

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Then Return

If Not lv_doctypes.DeleteItems Then
	gn_globals.in_messagebox.of_messagebox('You cannot delete this view because it was not created by you and you are not a System Administrator.', Information!, OK!, 1)
	Return
End If

lv_doctypes.DeleteItem(ll_index)



end subroutine

public subroutine of_rename ();Long ll_index

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Then Return

If Not lv_doctypes.EditLabels Then
	gn_globals.in_messagebox.of_messagebox('You cannot modify this view because it was not created by you and you are not a System Administrator.', Information!, OK!, 1)
	Return
End If

lv_doctypes.SetFocus()
lv_doctypes.EditLabel(ll_index)
end subroutine

public subroutine of_apply_globally_available ();Long ll_index

ll_index = lv_doctypes.SelectedIndex()

If ll_index <= 0 Or IsNull(ll_index) Or ll_index > ids_datastore.RowCount() Then Return

If ib_GloballyAvailableIsAnOption Then
	cbx_globallyavailable.Checked = IsNull(ids_datastore.GetItemNumber(ll_index, is_username_column))
	cbx_globallyavailable.Enabled = TRUE
	lv_doctypes.DeleteItems = cbx_globallyavailable.Enabled
	lv_doctypes.EditLabels = cbx_globallyavailable.Enabled
End If

If ib_DefaultIsAnOption Then
	cbx_default_view.Checked = Upper(Trim(ids_datastore.GetItemString(ll_index, is_default_column))) = 'Y'
	cbx_default_view.Enabled = Not cbx_globallyavailable.Checked Or Not ib_GloballyAvailableIsAnOption
End If

//
//Long ll_index
//Boolean lb_UserCreatedThisView
//
//ll_index = lv_doctypes.SelectedIndex()
//
//If ll_index <= 0 Or IsNull(ll_index) Or ll_index > ids_datastore.RowCount() Then Return
//
//cbx_globallyavailable.Checked = IsNull(ids_datastore.GetItemNumber(ll_index, is_username_column))
//cbx_default_view.Checked = Upper(Trim(ids_datastore.GetItemString(ll_index, is_default_column))) = 'Y'
//cbx_globallyavailable.Enabled = ib_GloballyAvailableIsAnOption
//
//
//If ib_DefaultIsAnOption Then
//	cbx_default_view.Enabled = Not cbx_globallyavailable.Checked Or Not ib_GloballyAvailableIsAnOption
//else
//	cbx_default_view.Enabled = FALSE
//End If
//
//lb_userCreatedThisView = ids_datastore.GetItemNumber(ll_index, is_createdbyuser_column) = gn_globals.il_userid
//
//lv_doctypes.DeleteItems = (cbx_globallyavailable.Enabled AND cbx_globallyavailable.Checked) OR lb_userCreatedThisView
//lv_doctypes.EditLabels = (cbx_globallyavailable.Enabled AND cbx_globallyavailable.Checked) OR lb_userCreatedThisView
//
//
end subroutine

on u_dynamic_gui_manage_views.create
int iCurrent
call super::create
this.cbx_default_view=create cbx_default_view
this.cbx_globallyavailable=create cbx_globallyavailable
this.lv_doctypes=create lv_doctypes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_default_view
this.Control[iCurrent+2]=this.cbx_globallyavailable
this.Control[iCurrent+3]=this.lv_doctypes
end on

on u_dynamic_gui_manage_views.destroy
call super::destroy
destroy(this.cbx_default_view)
destroy(this.cbx_globallyavailable)
destroy(this.lv_doctypes)
end on

event constructor;call super::constructor;ids_datastore = Create Datastore

//ib_ThisUserIsAnAdministrator = gn_globals.in_security.of_check_role(gn_globals.il_userid, 1)




end event

event destructor;call super::destructor;Destroy ids_datastore
end event

event resize;call super::resize;lv_doctypes.Width = Width - (2 * lv_doctypes.X)
//If ib_GloballyAvailableIsAnOption Or ib_DefaultIsAnOption Then
	cbx_globallyavailable.Y = Height - 65
	cbx_default_view.Y = Height - 65
//	If Not ib_GloballyAvailableIsAnOption Then cbx_default_view.X = cbx_globallyavailable.X
	lv_doctypes.Height = cbx_globallyavailable.Y - lv_doctypes.Y - 10
//Else
//	lv_doctypes.Height = Height - (2 * lv_doctypes.Y)
//End If
end event

event ue_refreshtheme;call super::ue_refreshtheme;This.Backcolor = 80263581
end event

type cbx_default_view from checkbox within u_dynamic_gui_manage_views
integer x = 1029
integer y = 972
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Default View"
end type

event clicked;Long index, ll_index, ll_return

If ib_DefaultIsAnOption Then
	index = lv_doctypes.SelectedIndex()
	
	If index > 0 And Not IsNull(index) And Not index > ids_datastore.RowCount() Then
		If This.Checked Then
			For ll_index = 1 To ids_datastore.RowCount()
				If Upper(Trim(ids_datastore.GetItemString(ll_index, is_default_column))) = 'Y' Then
					If ids_datastore.GetItemNumber(ll_index, is_createdbyuser_column) = gn_globals.il_userid then  // Make sure we only update views owned by this user
				     ids_datastore.SetItem(ll_index, is_default_column, 'N')
					end if
				End If
			Next
			
			ids_datastore.SetItem(index, is_default_column, 'Y')
			
		Else
			ids_datastore.SetItem(index, is_default_column, 'N')
		End If
	End If
End If


end event

event constructor;This.Visible = ib_DefaultIsAnOption
end event

type cbx_globallyavailable from checkbox within u_dynamic_gui_manage_views
integer x = 18
integer y = 964
integer width = 873
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Make this view available to all users"
end type

event clicked;Long index, ll_null, ll_return

If ib_GloballyAvailableIsAnOption Then
	SetNull(ll_null)
	
	index = lv_doctypes.SelectedIndex()
	
	If index > 0 And Not IsNull(index) And Not index > ids_datastore.RowCount() Then
		If This.Checked Then
			If ib_DefaultIsAnOption Then
				If Upper(Trim(ids_datastore.GetItemString(index, is_default_column))) = 'Y' Then
					//ll_return = gn_globals.in_messagebox.of_messagebox_question ('If you make this view global, it will no longer be your default view.  Continue setting this as a global view', YesNoCancel!, 1)
		
					Choose Case ll_return
						Case 1
							ids_datastore.SetItem(index, is_default_column, 'N')
							cbx_default_view.Checked = False
							cbx_default_view.Enabled = False
						Case 2, 3
							This.Checked = False
							cbx_default_view.Enabled = True
							Return
					End Choose
				End If
			End If
			
			ids_datastore.SetItem(index, is_username_column, ll_null)
		Else
			ids_datastore.SetItem(index, is_username_column, gn_globals.il_userid)
		End If
	End If
End If

cbx_default_view.Enabled = Not This.Checked
end event

event constructor;This.Visible = ib_GloballyAvailableIsAnOption
end event

type lv_doctypes from listview within u_dynamic_gui_manage_views
integer x = 18
integer y = 16
integer width = 1262
integer height = 928
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean deleteitems = true
boolean editlabels = true
boolean extendedselect = true
boolean hideselection = false
boolean trackselect = true
listviewview view = listviewlist!
string largepicturename[] = {"Custom039!"}
integer largepicturewidth = 32
integer largepictureheight = 32
long largepicturemaskcolor = 536870912
string smallpicturename[] = {"Custom039!"}
integer smallpicturewidth = 16
integer smallpictureheight = 16
long smallpicturemaskcolor = 12632256
long statepicturemaskcolor = 553648127
end type

event deleteitem;String ls_olddescription

If Not ib_deleting_in_code Then
	If IsValid(ids_datastore) Then
		If index > 0 And Not IsNull(index) And index <= ids_datastore.RowCount() Then
			ids_datastore.DeleteRow(index)
			Parent.Post of_load_listview()
		End If
	End If
End If
end event

event endlabeledit;String ls_olddescription

If Trim(newlabel) = '' Or IsNull(newlabel) Then Return 1

If index > 0 And Not IsNull(index) And index <= ids_datastore.RowCount() Then
	ls_olddescription = ids_datastore.GetItemString(index, is_description_column)
	
	If ls_olddescription <> Trim(newlabel) Then
		ids_datastore.SetItem(index, is_description_column, Trim(newlabel))
	End If
Else
	Return 1
End If
end event

event itemchanged;Parent.of_apply_globally_available()
end event

event constructor;this.View = ListViewReport!
this.Addcolumn("View", Left!,800)
this.Addcolumn("Owner",Left!,800)

end event

