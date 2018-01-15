$PBExportHeader$w_criteriadefaultengine_save_view.srw
forward
global type w_criteriadefaultengine_save_view from window
end type
type sle_1 from singlelineedit within w_criteriadefaultengine_save_view
end type
type lv_doctypes from listview within w_criteriadefaultengine_save_view
end type
type cb_cancel from commandbutton within w_criteriadefaultengine_save_view
end type
type cb_1 from commandbutton within w_criteriadefaultengine_save_view
end type
type st_2 from statictext within w_criteriadefaultengine_save_view
end type
type cbx_1 from checkbox within w_criteriadefaultengine_save_view
end type
end forward

global type w_criteriadefaultengine_save_view from window
integer x = 1074
integer y = 484
integer width = 1568
integer height = 1072
boolean titlebar = true
string title = "Save View"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
sle_1 sle_1
lv_doctypes lv_doctypes
cb_cancel cb_cancel
cb_1 cb_1
st_2 st_2
cbx_1 cbx_1
end type
global w_criteriadefaultengine_save_view w_criteriadefaultengine_save_view

type variables
Protected:
n_report_criteria_default_engine in_report_criteria_default_engine
String	is_views[], is_views_delete[]
Boolean ib_deleting_in_code = False
String	is_viewtype
Long		il_userid
Long		il_reportconfigid
end variables

forward prototypes
protected subroutine of_load_listview ()
end prototypes

protected subroutine of_load_listview ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_load_listview
// Overrides:  No
// Overview:   load the listview
// Created by: Joel White
// History:    First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long ll_index,ll_pict
listviewitem lvi_temp

lv_doctypes.SetRedraw(False)
ib_deleting_in_code = True
lv_doctypes.DeleteItems()
ib_deleting_in_code = False

for ll_index = 1 to UpperBound(is_views[])
	ll_pict = lv_doctypes.addsmallpicture('Module - Reporting Desktop - Small Icon (White).bmp')
	lv_doctypes.additem(' ' + is_views[ll_index], ll_pict)
Next


lv_doctypes.SetRedraw(True)

end subroutine

on w_criteriadefaultengine_save_view.create
this.sle_1=create sle_1
this.lv_doctypes=create lv_doctypes
this.cb_cancel=create cb_cancel
this.cb_1=create cb_1
this.st_2=create st_2
this.cbx_1=create cbx_1
this.Control[]={this.sle_1,&
this.lv_doctypes,&
this.cb_cancel,&
this.cb_1,&
this.st_2,&
this.cbx_1}
end on

on w_criteriadefaultengine_save_view.destroy
destroy(this.sle_1)
destroy(this.lv_doctypes)
destroy(this.cb_cancel)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.cbx_1)
end on

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      open
// Overrides:  No
// Overview:   get a list of views
//	Created by: Joel White
//	History:    8/31/06 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the transaction and retrieve
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(message.PowerObjectParm) Then Post Close(This)

in_report_criteria_default_engine = message.PowerObjectParm
in_report_criteria_default_engine.of_get_views(is_views[])
il_reportconfigid	= in_report_criteria_default_engine.of_get_reportconfigid()
il_userid			= in_report_criteria_default_engine.of_get_userid()
is_viewtype			= in_report_criteria_default_engine.of_get_viewtype()

This.of_load_listview()
//sle_1.Text = in_report_criteria_default_engine.of_get_current_view()
sle_1.SelectText(1, 10000)
//is_views_delete[]
end event

type sle_1 from singlelineedit within w_criteriadefaultengine_save_view
integer x = 9
integer y = 16
integer width = 1513
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "My View"
integer limit = 100
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type lv_doctypes from listview within w_criteriadefaultengine_save_view
integer x = 23
integer y = 112
integer width = 1481
integer height = 696
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
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

event clicked;ListViewItem lvi_temp 

If index <= 0 Or IsNull(index) Then Return

lv_doctypes.GetItem (index, lvi_temp )
sle_1.Text = lvi_temp.Label
sle_1.SelectText(1, 10000)
lv_doctypes.SetItem (index, lvi_temp )
end event

type cb_cancel from commandbutton within w_criteriadefaultengine_save_view
integer x = 1179
integer y = 844
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

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   close and return nothing
//	Created by: Joel White
//	History:    8/31/06 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
ib_deleting_in_code = True
close(parent)
end event

type cb_1 from commandbutton within w_criteriadefaultengine_save_view
integer x = 832
integer y = 844
integer width = 325
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   return the templateid for the selected dealtype
//	Created by: Joel White
//	History:    8/31/06 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long 		ll_index
Long		ll_viewid
Long		ll_createdbyuserid
Long		ll_userid
String	ls_return
String	ls_name
boolean	lb_globallyavailableisanoption = TRUE

If Len(Trim(sle_1.Text)) <= 0 Then
	sle_1.SetFocus()
	sle_1.SelectText(1, 10000)
	gn_globals.in_messagebox.of_messagebox_validation('You must type a name for the view')
End If

ls_name = Trim(sle_1.Text)

//-----------------------------------------------------------------------------------
// Check security and enable or disable the checkbox for saving global views
//-----------------------------------------------------------------------------------
//n_license_crypto ln_license_crypto
string s_return

//ln_license_crypto = create n_license_crypto
//s_return  = ln_license_crypto.of_verify_license_for_userandrole(gn_globals.is_username,'PowerUser License')
//
//if s_return  <> '' then 
//		lb_globallyavailableisanoption = FALSE
//end if

Select	Min(cusfocus.reportconfigdefault.rprtdfltid)
Into		:ll_viewid
From		cusfocus.reportconfigdefault
Where		(cusfocus.reportconfigdefault.userid		= :il_userid
Or			cusfocus.reportconfigdefault.userid			Is Null)
And		cusfocus.reportconfigdefault.rprtcnfgID	= :il_reportconfigid
And		cusfocus.reportconfigdefault.type			= :is_viewtype
And		cusfocus.reportconfigdefault.name			= :ls_name
Using		SQLCA;

If ll_viewid > 0 And Not IsNull(ll_viewid) Then
	Select	createdbyuserid,
				userid
	Into		:ll_createdbyuserid,
				:ll_userid
	From		cusfocus.reportconfigdefault
	Where		cusfocus.reportconfigdefault.rprtdfltid		= :ll_viewid
	Using		SQLCA;

//	If ll_createdbyuserid = il_userid Then  //created by current user
		If IsNull(ll_userid) Then // it is a global view
			If lb_globallyavailableisanoption then
				If gn_globals.in_messagebox.of_messagebox_question ('This already exists and it is global, so it will affect all users.  Would you like to overwrite it', YesNoCancel!, 3) <> 1 Then Return
			else
				gn_globals.in_messagebox.of_messagebox_validation('This already exists and it is a global view.  You do not have the authority to overwrite it.  Please rename your view')
				Return
			end if
		Else
			If gn_globals.in_messagebox.of_messagebox_question ('This already exists, would you like to overwrite it', YesNoCancel!, 3) <> 1 Then Return
		End If
//	Else  // created by other user
//		If IsNull(ll_userid) Then
//			If gn_globals.in_security.of_check_role(gn_globals.il_userid, 1) Then
//				If gn_globals.in_messagebox.of_messagebox_question ('This already exists and it is global, so it will affect all users.  Would you like to overwrite it', YesNoCancel!, 3) <> 1 Then Return
//			Else
//				gn_globals.in_messagebox.of_messagebox_validation('This already exists and it is global that was not created by you.  Only a system administrator or the creator of this can modify it')
//				Return
//			End If
//		End If
//	End If

	ls_return = 'RprtDfltID=' + String(il_userid) + '||'
End If

ls_return = ls_return + 'Name=' + Trim(sle_1.Text)

If cbx_1.Checked Then
	ls_return = ls_return + '||IsDefault=Y||Delete='
Else
	ls_return = ls_return + '||IsDefault=N||Delete='
End If

For ll_index = 1 To UpperBound(is_views_delete[])
	ls_return = ls_return + '@@@' + is_views_delete[ll_index] + '@@@'
Next

ib_deleting_in_code = True
CloseWithReturn(Parent, ls_return)
end event

type st_2 from statictext within w_criteriadefaultengine_save_view
integer x = 9
integer y = 104
integer width = 1513
integer height = 716
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean enabled = false
string text = "none"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_criteriadefaultengine_save_view
boolean visible = false
integer x = 974
integer y = 24
integer width = 549
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
string text = "Make Default Criteria"
end type

