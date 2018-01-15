$PBExportHeader$w_template_save.srw
forward
global type w_template_save from window
end type
type cb_delete from commandbutton within w_template_save
end type
type cb_1 from commandbutton within w_template_save
end type
type st_6 from statictext within w_template_save
end type
type ln_2 from line within w_template_save
end type
type ln_1 from line within w_template_save
end type
type dw_pick from datawindow within w_template_save
end type
type p_1 from picture within w_template_save
end type
type st_4 from statictext within w_template_save
end type
type st_5 from statictext within w_template_save
end type
type ln_6 from line within w_template_save
end type
type ln_7 from line within w_template_save
end type
type cb_ok from commandbutton within w_template_save
end type
type cb_new from commandbutton within w_template_save
end type
end forward

global type w_template_save from window
integer x = 361
integer y = 736
integer width = 3173
integer height = 1228
boolean titlebar = true
string title = "Manage Templates"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_delete cb_delete
cb_1 cb_1
st_6 st_6
ln_2 ln_2
ln_1 ln_1
dw_pick dw_pick
p_1 p_1
st_4 st_4
st_5 st_5
ln_6 ln_6
ln_7 ln_7
cb_ok cb_ok
cb_new cb_new
end type
global w_template_save w_template_save

type variables
Long il_reportconfigid
Long il_new_row = 0
String is_syntax, is_dataobject, is_area
BOOLEAN ib_changes_made = FALSE
end variables

event open;Long ll_pos, ll_rows

is_syntax = Message.StringParm

ll_pos = Pos(is_syntax, '/')
il_reportconfigid = Long(MID(is_syntax, 1, ll_pos - 1))
is_syntax = MID(is_syntax, ll_pos + 1)
dw_pick.SetTransObject(SQLCA)
ll_rows = dw_pick.Retrieve(gn_globals.il_userid, il_reportconfigid)
IF ll_rows > 0 THEN
	is_dataobject = dw_pick.object.rprtcnfgdtaobjct[1]
	is_area = dw_pick.object.rprtcnfgdscrptn[1]
	// Allow users to modify descriptions
	dw_pick.SetTabOrder('svdrprtdscrptn', 10)
	dw_pick.object.svdrprtdscrptn.Background.Color = RGB(255,255,255)
ELSE
	SELECT
		cusfocus.reportconfig.rprtcnfgdscrptn, 
		cusfocus.reportconfig.rprtcnfgdtaobjct 
	INTO
		:is_area,
		:is_dataobject
	FROM cusfocus.reportconfig      
	WHERE cusfocus.reportconfig.rprtcnfgid = :il_reportconfigid 
	USING SQLCA;
END IF

f_center_window(this)

end event

on w_template_save.create
this.cb_delete=create cb_delete
this.cb_1=create cb_1
this.st_6=create st_6
this.ln_2=create ln_2
this.ln_1=create ln_1
this.dw_pick=create dw_pick
this.p_1=create p_1
this.st_4=create st_4
this.st_5=create st_5
this.ln_6=create ln_6
this.ln_7=create ln_7
this.cb_ok=create cb_ok
this.cb_new=create cb_new
this.Control[]={this.cb_delete,&
this.cb_1,&
this.st_6,&
this.ln_2,&
this.ln_1,&
this.dw_pick,&
this.p_1,&
this.st_4,&
this.st_5,&
this.ln_6,&
this.ln_7,&
this.cb_ok,&
this.cb_new}
end on

on w_template_save.destroy
destroy(this.cb_delete)
destroy(this.cb_1)
destroy(this.st_6)
destroy(this.ln_2)
destroy(this.ln_1)
destroy(this.dw_pick)
destroy(this.p_1)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.cb_ok)
destroy(this.cb_new)
end on

event closequery;LONG ll_mod, ll_del, ll_return

ll_mod = dw_pick.ModifiedCount()
ll_del = dw_pick.DeletedCount()
ll_return = 0

IF ll_mod > 0 OR ll_del > 0 THEN
	ll_return = MessageBox("Pending Changes", "Updates are pending, do you really wish to exit?", Question!, YesNo!)
END IF

IF ll_return = 2 THEN 
	RETURN 1
ELSE
	RETURN 0
END IF

end event

type cb_delete from commandbutton within w_template_save
integer x = 571
integer y = 1016
integer width = 325
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
boolean cancel = true
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_return, ll_row, ll_blobID, ll_null
string	ls_description

ll_row = dw_pick.GetRow()
IF ll_row < 1 THEN RETURN

ls_description = dw_pick.object.svdrprtdscrptn[ll_row]
ll_return = MessageBox("Delete Template", "Do you wish to delete template: " + ls_description + "?", Question!, YesNo!)
IF ll_return <> 1 THEN RETURN
dw_pick.DeleteRow(ll_row)
IF ll_row = il_new_row THEN il_new_row = 0
ib_changes_made = TRUE
end event

type cb_1 from commandbutton within w_template_save
integer x = 2619
integer y = 1016
integer width = 325
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type st_6 from statictext within w_template_save
integer y = 984
integer width = 3090
integer height = 156
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

type ln_2 from line within w_template_save
long linecolor = 8421504
integer linethickness = 5
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type ln_1 from line within w_template_save
long linecolor = 16777215
integer linethickness = 5
integer beginy = 176
integer endx = 4000
integer endy = 176
end type

type dw_pick from datawindow within w_template_save
integer x = 14
integer y = 196
integer width = 3095
integer height = 760
integer taborder = 10
string dragicon = "DRAGITEM.ICO"
string dataobject = "d_saved_templates"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

on constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event       Constructor
// Overriden:  No
// Function:   Set RowfocusIndicator
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

this.setrowfocusindicator(FocusRect!)
end on

on rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event       RowFocusChanged
// Overriden:  No
// Function:   Select the Row
// Created by  Jake Pratt 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_rw
l_rw = This.GetRow()
//-----------------------------------------------------
// Select the Row
//-----------------------------------------------------
if l_rw > 0 then
	This.SelectRow(0, FALSE)
	This.SelectRow(l_rw, TRUE)
end if

end on

event clicked;
this.setrow(row)

end event

event itemchanged;ib_changes_made = TRUE
end event

type p_1 from picture within w_template_save
integer x = 27
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "module - smartsearch - large icon (white).bmp"
boolean focusrectangle = false
end type

type st_4 from statictext within w_template_save
integer x = 215
integer y = 32
integer width = 1701
integer height = 104
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Select one of your existing templates to replace, or create a new template. You may also modify descriptions and delete templates from here."
boolean focusrectangle = false
end type

type st_5 from statictext within w_template_save
integer width = 3113
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

type ln_6 from line within w_template_save
long linecolor = 8421504
integer linethickness = 5
integer beginy = 976
integer endx = 4000
integer endy = 976
end type

type ln_7 from line within w_template_save
long linecolor = 16777215
integer linethickness = 5
integer beginy = 980
integer endx = 4000
integer endy = 980
end type

type cb_ok from commandbutton within w_template_save
integer x = 2272
integer y = 1016
integer width = 325
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_row, ll_blobID, ll_null
Long ll_return
string	ls_null, ls_description
blob		lb_syntax

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

dw_pick.AcceptText()
	
IF il_new_row > 0 THEN // new template
	lb_syntax = Blob(is_syntax)
	ls_description = dw_pick.object.svdrprtdscrptn[il_new_row]
	IF IsNull(ls_description) THEN
		MessageBox("New Template Error", "Please enter a description for this template.")
		dw_pick.SetFocus()
		RETURN
	END IF
	ll_blobID = ln_blob_manipulator.of_insert_blob(lb_syntax, is_dataobject)
	dw_pick.object.svdrprtblbobjctid[il_new_row] = ll_blobID
Else
	
	ll_row = dw_pick.GetRow()
	IF ll_row > 0 THEN
	
		ll_blobid = dw_pick.object.svdrprtblbobjctid[ll_row]
		IF ib_changes_made THEN // Make sure they want to save the template if they made other changes
			ls_description = dw_pick.object.svdrprtdscrptn[ll_row]
			ll_return = MessageBox("Changes Made", "Do you wish to save the current view in template: " + ls_description + "?", Question!, YesNo!)
			IF ll_return = 1 THEN
				lb_syntax = Blob(is_syntax)
				ln_blob_manipulator.of_update_blob(lb_syntax, ll_blobID, FALSE)
			END IF
		ELSE
			lb_syntax = Blob(is_syntax)
			ln_blob_manipulator.of_update_blob(lb_syntax, ll_blobID, FALSE)
		END IF
	End If
END IF

ll_return = dw_pick.Update()

Destroy	ln_blob_manipulator

IF ll_return <> 1 THEN 
	MessageBox("Update Error", "Error saving changes.")
ELSE
	Close(Parent)
END IF


end event

type cb_new from commandbutton within w_template_save
integer x = 146
integer y = 1016
integer width = 325
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
boolean cancel = true
end type

event clicked;Long ll_row, ll_null
String ls_null

SetNull(ls_null)
SetNull(ll_null)

il_new_row = dw_pick.InsertRow(0)
IF il_new_row > 0 THEN
	
	dw_pick.SetRow(il_new_row)
	dw_pick.SetTabOrder('svdrprtdscrptn', 10)
	dw_pick.object.svdrprtdscrptn.Background.Color = RGB(255,255,255)
	dw_pick.SetColumn('svdrprtdscrptn')
	dw_pick.SetFocus()
		
	dw_pick.SetItem(il_new_row, 'svdrprtfldrid', ls_null)
	dw_pick.SetItem(il_new_row, 'svdrprtblbobjctid', 0) // Zero means a new row
	dw_pick.SetItem(il_new_row, 'svdrprtrprtcnfgid', il_reportconfigid)
	dw_pick.SetItem(il_new_row, 'svdrprttpe', 'T')
	dw_pick.SetItem(il_new_row, 'svdrprtdstrbtnmthd', ls_null)	
	dw_pick.SetItem(il_new_row, 'svdrprtuserid', gn_globals.il_userid)
	dw_pick.SetItem(il_new_row, 'svdrprtrvsnusrid', ll_null)
	dw_pick.SetItem(il_new_row, 'svdrprtrvsnlvl', 1)
	dw_pick.SetItem(il_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
	dw_pick.SetItem(il_new_row, 'rprtcnfgdscrptn', is_area)

	THIS.Enabled = FALSE
END IF


end event

