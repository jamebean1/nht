$PBExportHeader$w_appealdetail_note.srw
forward
global type w_appealdetail_note from w_deal_display_basic
end type
type st_3 from statictext within w_appealdetail_note
end type
type cb_2 from u_commandbutton within w_appealdetail_note
end type
type dw_module from u_reference_display_datawindow within w_appealdetail_note
end type
type mle_text from multilineedit within w_appealdetail_note
end type
end forward

global type w_appealdetail_note from w_deal_display_basic
integer width = 3337
integer height = 1544
string title = "Appeal Detail Note"
st_3 st_3
cb_2 cb_2
dw_module dw_module
mle_text mle_text
end type
global w_appealdetail_note w_appealdetail_note

type variables
n_dao_appealdetailnotes in_dao
long il_id
boolean ib_is_changed = FALSE
end variables

on w_appealdetail_note.create
int iCurrent
call super::create
this.st_3=create st_3
this.cb_2=create cb_2
this.dw_module=create dw_module
this.mle_text=create mle_text
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_module
this.Control[iCurrent+4]=this.mle_text
end on

on w_appealdetail_note.destroy
call super::destroy
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.dw_module)
destroy(this.mle_text)
end on

event open;call super::open;datetime ldt_now
string 	ls_text
long 		ll_id, ll_key, ll_length, ll_return
string 	s_return
boolean	lb_has_note
n_bag		ln_bag

ln_bag = Create n_bag
n_dao_appealdetailnotes ln_dao 
lb_has_note = TRUE

ln_dao = Create n_dao_appealdetailnotes

//ll_id = message.doubleparm
ln_bag = message.powerobjectparm
ll_id = long(ln_bag.of_get('appealdetailid'))

If string(ln_bag.of_get('islocked')) = 'Y' Then 
	ln_dao.ib_readonly = TRUE
	this.title = this.title + ' - Read Only'
	cb_1.Enabled = FALSE
End If

If ll_id > 0 Then
	ln_dao.of_retrieve(ll_id)
End If

If ln_dao.Rowcount() = 0 Then 
	ln_dao.of_new()
	ln_dao.SetItemStatus(1, 0, Primary!, NewModified!)
	ln_dao.of_setitem(1, 'appealdetailID', ll_id)
	lb_has_note = FALSE
End If

in_dao = ln_dao

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the note text. We are going to set the datetime & user into the field by default.
//-----------------------------------------------------------------------------------------------------------------------------------
ldt_now = gn_globals.in_date_manipulator.of_now()
ls_text = in_dao.of_getitem(1, 'textnote')

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is a row there already, put the previous text in with some returns before setting the datetime and user in.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lb_has_note
	Case FALSE 
		ls_text = String(ldt_now) + ' - ' + gn_globals.is_login + '~r~n'
	Case TRUE 
		ls_text = ls_text + '~r~n' + '~r~n' + String(ldt_now) + ' - ' + gn_globals.is_login + '~r~n'
		ib_is_changed = TRUE
End Choose

ll_length = Len(ls_text)

in_dao.of_setitem(1, 'textnote', ls_text)

This.x = 0
This.y = 0

this.height = this.height - (workspaceheight()  -  (cb_1.height + cb_1.y + 25))

dw_module.of_setdao(in_dao)
dw_module.event ue_retrieve()

dw_module.SelectText (5, 10)

mle_text.SetFocus()
mle_text.text = ls_text
mle_text.SelectText(len(ls_text) + 1, 0)
end event

event resize;call super::resize;dw_module.Width = Width - (2 * dw_module.X)
cb_2.X = Width - cb_2.Width - 60
cb_1.X = cb_2.X - cb_1.Width - 22


st_3.Y = Max(Height - st_3.Height - 100, 500)
ln_4.BeginY = st_3.Y - 4
ln_4.EndY	= st_3.Y - 4
ln_3.BeginY = st_3.Y - 8
ln_3.EndY	= st_3.Y - 8
cb_2.Y = st_3.Y + 36
cb_1.Y = cb_2.Y

//dw_module.Height = st_3.Y - 60 - dw_module.Y
dw_module.Width = this.workspacewidth() - (2 * dw_module.x)
//dw_module.Object.note.width = dw_module.Width - (2 * dw_module.Object.note.x)

end event

event close;call super::close;destroy in_dao
end event

type p_1 from w_deal_display_basic`p_1 within w_appealdetail_note
integer y = 24
string picturename = "Notepad Large Icon (White).bmp"
end type

type st_1 from w_deal_display_basic`st_1 within w_appealdetail_note
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
string text = "Appeal Detail Note"
end type

type cb_1 from w_deal_display_basic`cb_1 within w_appealdetail_note
integer x = 2368
integer y = 1324
integer weight = 700
fontcharset fontcharset = ansi!
string text = "&OK"
end type

event cb_1::clicked;string s_error, ls_return
long ll_length

if dw_module.ModifiedCount() <= 0 Then Return

ls_return = in_dao.of_getitem(1, 'textnote')
ls_return = in_dao.GetItemString(1, 'textnote')
ll_length = Len(in_dao.of_getitem(1, 'textnote'))

s_error = in_dao.of_save()
If s_error <> '' then 
	
	gn_globals.in_messagebox.of_messagebox(s_error, Exclamation!, OK!, 1)
else
	If ll_length > 0 And in_dao.ib_readonly = FALSE Then
		closeWithReturn(parent, 'Y')
	Else
		closeWithReturn(parent, 'N')
	End If
end if

end event

type st_2 from w_deal_display_basic`st_2 within w_appealdetail_note
integer width = 3616
string text = "Log a New Issue"
end type

type ln_1 from w_deal_display_basic`ln_1 within w_appealdetail_note
end type

type ln_2 from w_deal_display_basic`ln_2 within w_appealdetail_note
end type

type ln_3 from w_deal_display_basic`ln_3 within w_appealdetail_note
integer beginy = 1284
integer endy = 1284
end type

type ln_4 from w_deal_display_basic`ln_4 within w_appealdetail_note
integer beginy = 1280
integer endy = 1280
end type

type st_3 from statictext within w_appealdetail_note
integer y = 1288
integer width = 3616
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_2 from u_commandbutton within w_appealdetail_note
integer x = 2825
integer y = 1324
integer height = 92
integer taborder = 30
boolean bringtotop = true
fontcharset fontcharset = ansi!
string text = "&Cancel"
end type

event clicked;call super::clicked;dwItemStatus l_status

l_status = in_dao.GetItemStatus(1, 'textnote', Primary!) 

If ib_is_changed  Then
	closeWithReturn(parent, 'Y')
Else
	closeWithReturn(parent, 'N')
End If



end event

type dw_module from u_reference_display_datawindow within w_appealdetail_note
boolean visible = false
integer x = 1138
integer y = 212
integer width = 2167
integer height = 1044
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_gui_appealdetail_note"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event editchanged;call super::editchanged;If Len(data) > 0 Then
	ib_is_changed = TRUE
End If
end event

type mle_text from multilineedit within w_appealdetail_note
integer x = 27
integer y = 224
integer width = 3269
integer height = 988
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event modified;in_dao.of_setitem(1, 'textnote', this.text )
end event

