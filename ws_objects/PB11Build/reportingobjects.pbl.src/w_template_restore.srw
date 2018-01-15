$PBExportHeader$w_template_restore.srw
forward
global type w_template_restore from window
end type
type st_6 from statictext within w_template_restore
end type
type ln_2 from line within w_template_restore
end type
type ln_1 from line within w_template_restore
end type
type dw_pick from datawindow within w_template_restore
end type
type p_1 from picture within w_template_restore
end type
type st_4 from statictext within w_template_restore
end type
type st_5 from statictext within w_template_restore
end type
type ln_6 from line within w_template_restore
end type
type ln_7 from line within w_template_restore
end type
type cb_ok from commandbutton within w_template_restore
end type
type cb_cancel2 from commandbutton within w_template_restore
end type
end forward

global type w_template_restore from window
integer x = 361
integer y = 736
integer width = 3173
integer height = 1236
boolean titlebar = true
string title = "Restore Template"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
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
cb_cancel2 cb_cancel2
end type
global w_template_restore w_template_restore

type variables
Long il_reportconfigid
end variables

event open;long ll_rows
il_reportconfigid = Message.DoubleParm

dw_pick.SetTransObject(SQLCA)
ll_rows = dw_pick.Retrieve(gn_globals.il_userid, il_reportconfigid)

f_center_window(this)

end event

on w_template_restore.create
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
this.cb_cancel2=create cb_cancel2
this.Control[]={this.st_6,&
this.ln_2,&
this.ln_1,&
this.dw_pick,&
this.p_1,&
this.st_4,&
this.st_5,&
this.ln_6,&
this.ln_7,&
this.cb_ok,&
this.cb_cancel2}
end on

on w_template_restore.destroy
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
destroy(this.cb_cancel2)
end on

type st_6 from statictext within w_template_restore
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

type ln_2 from line within w_template_restore
long linecolor = 8421504
integer linethickness = 5
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type ln_1 from line within w_template_restore
long linecolor = 16777215
integer linethickness = 5
integer beginy = 176
integer endx = 4000
integer endy = 176
end type

type dw_pick from datawindow within w_template_restore
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

event clicked;this.setrow(row)

end event

type p_1 from picture within w_template_restore
integer x = 27
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "module - smartsearch - large icon (white).bmp"
boolean focusrectangle = false
end type

type st_4 from statictext within w_template_restore
integer x = 215
integer y = 64
integer width = 2839
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Select one of your existing templates to restore."
boolean focusrectangle = false
end type

type st_5 from statictext within w_template_restore
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

type ln_6 from line within w_template_restore
long linecolor = 8421504
integer linethickness = 5
integer beginy = 976
integer endx = 4000
integer endy = 976
end type

type ln_7 from line within w_template_restore
long linecolor = 16777215
integer linethickness = 5
integer beginy = 980
integer endx = 4000
integer endy = 980
end type

type cb_ok from commandbutton within w_template_restore
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

event clicked;Long ll_blob_id, ll_row

ll_blob_id = 0
ll_row = dw_pick.GetRow()
ll_row = dw_pick.GetSelectedRow(0)

IF ll_row > 0 THEN
	ll_blob_id = dw_pick.object.svdrprtblbobjctid[ll_row]
END IF

ClosewithReturn(Parent,ll_blob_id)



end event

type cb_cancel2 from commandbutton within w_template_restore
integer x = 2619
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
string text = "&Cancel"
boolean cancel = true
end type

event clicked;//-----------------------------------------------------
// Close with 0 = False
//-----------------------------------------------------
ClosewithREturn(Parent,0)
end event

