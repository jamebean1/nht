$PBExportHeader$w_pivot_table_service_save_view.srw
forward
global type w_pivot_table_service_save_view from window
end type
type cbx_allownavigation from checkbox within w_pivot_table_service_save_view
end type
type st_6 from statictext within w_pivot_table_service_save_view
end type
type p_1 from picture within w_pivot_table_service_save_view
end type
type st_4 from statictext within w_pivot_table_service_save_view
end type
type st_1 from statictext within w_pivot_table_service_save_view
end type
type dw_reportview from datawindow within w_pivot_table_service_save_view
end type
type sle_1 from singlelineedit within w_pivot_table_service_save_view
end type
type lv_doctypes from listview within w_pivot_table_service_save_view
end type
type st_2 from statictext within w_pivot_table_service_save_view
end type
type ln_1 from line within w_pivot_table_service_save_view
end type
type ln_2 from line within w_pivot_table_service_save_view
end type
type st_5 from statictext within w_pivot_table_service_save_view
end type
type ln_6 from line within w_pivot_table_service_save_view
end type
type ln_7 from line within w_pivot_table_service_save_view
end type
type cbx_globallyavailable from checkbox within w_pivot_table_service_save_view
end type
type cb_cancel from commandbutton within w_pivot_table_service_save_view
end type
type cb_1 from commandbutton within w_pivot_table_service_save_view
end type
end forward

global type w_pivot_table_service_save_view from window
integer x = 1074
integer y = 484
integer width = 1669
integer height = 1496
boolean titlebar = true
string title = "Save Pivot View"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
cbx_allownavigation cbx_allownavigation
st_6 st_6
p_1 p_1
st_4 st_4
st_1 st_1
dw_reportview dw_reportview
sle_1 sle_1
lv_doctypes lv_doctypes
st_2 st_2
ln_1 ln_1
ln_2 ln_2
st_5 st_5
ln_6 ln_6
ln_7 ln_7
cbx_globallyavailable cbx_globallyavailable
cb_cancel cb_cancel
cb_1 cb_1
end type
global w_pivot_table_service_save_view w_pivot_table_service_save_view

type variables
Protected:
n_pivot_table_service in_pivot_table_service
Long il_userid, il_reportconfigid
Boolean ib_deleting_in_code = False
Datastore ids_pivot_table_views
Boolean ib_isgloballyavailableanoption = TRUE
end variables

forward prototypes
public function boolean of_validate ()
protected subroutine of_load_listview ()
public subroutine of_set_options (string as_pivottablename)
end prototypes

public function boolean of_validate ();Long ll_row, ll_userid, ll_createdbyuserid

If Trim(sle_1.Text) = '' Then
	gn_globals.in_messagebox.of_messagebox_validation('You must type a description')
	Return False
End If

ll_row = ids_pivot_table_views.Find('Lower(Description) = "' + Lower(Trim(sle_1.Text)) + '"', 1, ids_pivot_table_views.RowCount())

If ll_row < 0 Or IsNull(ll_row) Then
	gn_globals.in_messagebox.of_messagebox_validation('The description is not valid')
	Return False
End If

If ll_row = 0 Or ll_row > ids_pivot_table_views.RowCount() Then Return True

ll_userid 				= ids_pivot_table_views.GetItemNumber(ll_row, 'userid')
ll_createdbyuserid	= ids_pivot_table_views.GetItemNumber(ll_row, 'createdbyuserid')

If IsNull(ll_userid) then
	If ib_isgloballyavailableanoption then
		If Not gn_globals.in_messagebox.of_messagebox_question('This will affect all users because it is a global view.  Are you sure you want to overwrite this view', YesNoCancel!, 3) = 1 Then Return False
	else
		gn_globals.in_messagebox.of_messagebox_validation('A global view by this name already exists.  You do not have the authority to save global views.  Please rename your view')
		Return False
	end if
else
		If Not gn_globals.in_messagebox.of_messagebox_question('Are you sure you want to overwrite this view', YesNoCancel!, 3) = 1 Then Return False
End If

Return True
end function

protected subroutine of_load_listview ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_load_listview
// Overrides:  No
// Overview:   load the listview
// Created by: Blake Doerr
// History:    07.08.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_LC,ll_pict
listviewitem lvi_temp

lv_doctypes.SetRedraw(False)
ib_deleting_in_code = True
lv_doctypes.DeleteItems()
ib_deleting_in_code = False

for ll_LC = 1 to ids_pivot_table_views.RowCount()
	ll_pict = lv_doctypes.addsmallpicture(ids_pivot_table_views.getitemstring(ll_LC,'collapsedbitmapname'))
	lv_doctypes.additem(ids_pivot_table_views.getitemstring(ll_LC,'description'),ll_pict)
Next


lv_doctypes.GetItem ( 1, lvi_temp )

lvi_temp.Selected = true
lv_doctypes.SetItem ( 1, lvi_temp )

lv_doctypes.SetRedraw(True)
end subroutine

public subroutine of_set_options (string as_pivottablename);//n_string_functions ln_string_functions
Long		ll_row
Long		ll_reportid
Long		ll_userid
String	ls_IsThisNavigation

gn_globals.in_string_functions.of_replace_all(as_pivottablename, "'", "~~'")
ll_row = ids_pivot_table_views.Find("Description = '" + as_pivottablename + "'", 1, ids_pivot_table_views.RowCount())

If ll_row > 0 And ll_row <= ids_pivot_table_views.RowCount() And Not IsNull(ll_row) Then
	ll_reportid = ids_pivot_table_views.GetItemNumber(ll_row, 'dtaobjctstteidnty')
	If IsNull(ll_reportid) Then ll_reportid = 0
	ls_IsThisNavigation 	= ids_pivot_table_views.GetItemString(ll_row, 'isnavigationdestination')
	ll_userid				= ids_pivot_table_views.GetItemNumber(ll_row, 'userid')
	
	dw_reportview.SetItem(1, 'dataobjectstateidnty', ll_reportid)
	cbx_globallyavailable.Checked = IsNull(ll_userid)
	cbx_allownavigation.Checked	= Upper(Trim(ls_IsThisNavigation)) = 'Y' And Not IsNull(ls_IsThisNavigation)

	listviewitem lvi_temp
	lv_doctypes.GetItem ( ll_row, lvi_temp )
	If IsValid(lvi_temp) Then
		lvi_temp.Selected = true
		lv_doctypes.SetItem ( ll_row, lvi_temp )
	End If


Else
	dw_reportview.SetItem(1, 'dataobjectstateidnty', 0)
	cbx_allownavigation.Checked 		= False
	cbx_globallyavailable.Checked 	= False
End If


//-----------------------------------------------------------------------------------
// Check security and enable or disable the checkbox for saving global views
//-----------------------------------------------------------------------------------
//n_license_crypto ln_license_crypto
string s_return

//ln_license_crypto = create n_license_crypto
//s_return  = ln_license_crypto.of_verify_license_for_userandrole(gn_globals.is_username,'PowerUser License')

//if s_return  <> '' then 
//	cbx_globallyavailable.enabled = FALSE
//	cbx_globallyavailable.Checked = False
//	ib_isgloballyavailableanoption = FALSE
//end if

end subroutine

on w_pivot_table_service_save_view.create
this.cbx_allownavigation=create cbx_allownavigation
this.st_6=create st_6
this.p_1=create p_1
this.st_4=create st_4
this.st_1=create st_1
this.dw_reportview=create dw_reportview
this.sle_1=create sle_1
this.lv_doctypes=create lv_doctypes
this.st_2=create st_2
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_5=create st_5
this.ln_6=create ln_6
this.ln_7=create ln_7
this.cbx_globallyavailable=create cbx_globallyavailable
this.cb_cancel=create cb_cancel
this.cb_1=create cb_1
this.Control[]={this.cbx_allownavigation,&
this.st_6,&
this.p_1,&
this.st_4,&
this.st_1,&
this.dw_reportview,&
this.sle_1,&
this.lv_doctypes,&
this.st_2,&
this.ln_1,&
this.ln_2,&
this.st_5,&
this.ln_6,&
this.ln_7,&
this.cbx_globallyavailable,&
this.cb_cancel,&
this.cb_1}
end on

on w_pivot_table_service_save_view.destroy
destroy(this.cbx_allownavigation)
destroy(this.st_6)
destroy(this.p_1)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.dw_reportview)
destroy(this.sle_1)
destroy(this.lv_doctypes)
destroy(this.st_2)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_5)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.cbx_globallyavailable)
destroy(this.cb_cancel)
destroy(this.cb_1)
end on

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      open
// Overrides:  No
// Overview:   get a list of views
//	Created by: Blake Doerr
//	History:    1/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

DatawindowChild ldwc_reportview

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the transaction and retrieve
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(message.PowerObjectParm) Then
	in_pivot_table_service = message.PowerObjectParm
	il_userid			= in_pivot_table_service.of_get_userid()
	il_reportconfigid	= in_pivot_table_service.of_get_reportconfigid()
End If


ids_pivot_table_views = Create Datastore
ids_pivot_table_views.DataObject = 'dddw_pivot_table_view'
ids_pivot_table_views.settransobject(SQLCA)
ids_pivot_table_views.post retrieve(il_reportconfigid, il_userid)
This.Post of_load_listview()
sle_1.Text = in_pivot_table_service.of_get_title()

dw_reportview.SetTransObject(SQLCA)
dw_reportView.GetChild('DataObjectStateIdnty', ldwc_reportview)
ldwc_reportview.SetTransObject(SQLCA)
ldwc_reportview.Retrieve(il_reportconfigid, il_userid)
ldwc_reportview.InsertRow(1)
ldwc_reportview.SetItem(1, 'Idnty', 0)
ldwc_reportview.SetItem(1, 'Name', '(None)')
dw_reportView.InsertRow(0)

dw_reportView.SetItem(1, 1, 0)

This.Post of_set_options(sle_1.Text)
end event

event close;Destroy ids_pivot_table_views
end event

type cbx_allownavigation from checkbox within w_pivot_table_service_save_view
integer x = 658
integer y = 1156
integer width = 923
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
string text = "Allow Navigation Directly to This View"
end type

type st_6 from statictext within w_pivot_table_service_save_view
integer y = 1252
integer width = 2889
integer height = 160
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

type p_1 from picture within w_pivot_table_service_save_view
integer x = 27
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "module - reporting desktop - large icon (white).bmp"
boolean focusrectangle = false
end type

type st_4 from statictext within w_pivot_table_service_save_view
integer x = 215
integer y = 64
integer width = 1088
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Enter a name for the Pivot View."
end type

type st_1 from statictext within w_pivot_table_service_save_view
integer x = 32
integer y = 1064
integer width = 599
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Requires This Report View:"
boolean focusrectangle = false
end type

type dw_reportview from datawindow within w_pivot_table_service_save_view
integer x = 626
integer y = 1052
integer width = 1019
integer height = 92
integer taborder = 20
string title = "none"
string dataobject = "d_pivot_table_view_reportview"
boolean border = false
boolean livescroll = true
end type

type sle_1 from singlelineedit within w_pivot_table_service_save_view
integer x = 18
integer y = 196
integer width = 1609
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "(Default View)"
integer limit = 255
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event modified;long 		ll_index
Boolean	lb_found = FALSE

// Look for a view with the same name, if it isn't found that set defaults for a new view

For ll_index = 1 To ids_pivot_table_views.RowCount()
	If Lower(Trim(ids_pivot_table_views.GetItemString(ll_index, 'Description'))) <> Lower(Trim(sle_1.Text)) Then Continue
	lb_found = TRUE
Next

if Not lb_found then
		cbx_globallyavailable.checked = FALSE
end if



end event

type lv_doctypes from listview within w_pivot_table_service_save_view
integer x = 32
integer y = 296
integer width = 1577
integer height = 736
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean hideselection = false
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

event doubleclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      doubleclicked
// Overrides:  No
// Overview:   trigger the selection and close
//	Created by: Blake Doerr
//	History:    1/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
cb_1.triggerevent('clicked')
end event

event clicked;ListViewItem llvi_temp

If index <= 0 Or IsNull(index) Then Return

This.GetItem(index, llvi_temp)

If Not IsValid(llvi_temp) Then Return

sle_1.Text = llvi_temp.Label
Parent.of_set_options(sle_1.Text)
end event

type st_2 from statictext within w_pivot_table_service_save_view
integer x = 18
integer y = 288
integer width = 1609
integer height = 752
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

type ln_1 from line within w_pivot_table_service_save_view
long linecolor = 16777215
integer linethickness = 1
integer beginy = 176
integer endx = 4000
integer endy = 176
end type

type ln_2 from line within w_pivot_table_service_save_view
long linecolor = 8421504
integer linethickness = 1
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type st_5 from statictext within w_pivot_table_service_save_view
integer width = 2505
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

type ln_6 from line within w_pivot_table_service_save_view
long linecolor = 8421504
integer linethickness = 1
integer beginy = 1244
integer endx = 4000
integer endy = 1244
end type

type ln_7 from line within w_pivot_table_service_save_view
long linecolor = 16777215
integer linethickness = 1
integer beginx = 5
integer beginy = 1248
integer endx = 4005
integer endy = 1248
end type

type cbx_globallyavailable from checkbox within w_pivot_table_service_save_view
integer x = 32
integer y = 1156
integer width = 585
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
string text = "Make This View Global"
end type

type cb_cancel from commandbutton within w_pivot_table_service_save_view
integer x = 1312
integer y = 1272
integer width = 325
integer height = 88
integer taborder = 50
boolean bringtotop = true
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
//	Created by: Blake Doerr
//	History:    1/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(Message.PowerObjectParm)
close(parent)
end event

type cb_1 from commandbutton within w_pivot_table_service_save_view
integer x = 965
integer y = 1272
integer width = 325
integer height = 88
integer taborder = 30
boolean bringtotop = true
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
//	Created by: Blake Doerr
//	History:    1/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_reportviewid
n_bag ln_bag

If Parent.of_validate() Then
	ln_bag = Create n_bag
	ln_bag.of_set('Description', Trim(sle_1.Text))
	If cbx_globallyavailable.Checked Then
		ln_bag.of_set('GlobalView', 'Y')
	Else
		ln_bag.of_set('GlobalView', 'N')
	End If
	
	If cbx_allownavigation.Checked Then
		ln_bag.of_set('AllowNavigation', 'Y')
	Else
		ln_bag.of_set('AllowNavigation', 'N')
	End If
	ll_reportviewid = dw_reportview.GetItemNumber(1, 'DataObjectStateIdnty')
	
	If Not IsNull(ll_reportviewid) And ll_reportviewid <> 0 Then
		ln_bag.of_set('DataObjectStateIdnty', ll_reportviewid)
	End If
	
	CloseWithReturn(Parent, ln_bag)
End If
end event

