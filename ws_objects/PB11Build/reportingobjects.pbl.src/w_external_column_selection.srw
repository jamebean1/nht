$PBExportHeader$w_external_column_selection.srw
forward
global type w_external_column_selection from w_basewindow
end type
type cb_savetemplate from u_commandbutton within w_external_column_selection
end type
type cbx_reretrieve from checkbox within w_external_column_selection
end type
type ln_1 from line within w_external_column_selection
end type
type ln_2 from line within w_external_column_selection
end type
type cb_cancel from u_commandbutton within w_external_column_selection
end type
type ln_6 from line within w_external_column_selection
end type
type ln_7 from line within w_external_column_selection
end type
type st_title from statictext within w_external_column_selection
end type
type p_1 from picture within w_external_column_selection
end type
type st_22 from statictext within w_external_column_selection
end type
type cb_apply from u_commandbutton within w_external_column_selection
end type
type cb_ok from u_commandbutton within w_external_column_selection
end type
type st_4 from statictext within w_external_column_selection
end type
type uo_columnselection from u_column_selection_external within w_external_column_selection
end type
end forward

global type w_external_column_selection from w_basewindow
integer width = 2368
integer height = 1848
string title = "Select External Column"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 79741120
cb_savetemplate cb_savetemplate
cbx_reretrieve cbx_reretrieve
ln_1 ln_1
ln_2 ln_2
cb_cancel cb_cancel
ln_6 ln_6
ln_7 ln_7
st_title st_title
p_1 p_1
st_22 st_22
cb_apply cb_apply
cb_ok cb_ok
st_4 st_4
uo_columnselection uo_columnselection
end type
global w_external_column_selection w_external_column_selection

type variables

end variables

forward prototypes
protected function boolean of_validate ()
end prototypes

protected function boolean of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate()
//	Overview:   This will return false if there are any problems with validation
//	Created by:	Blake Doerr
//	History: 	8.3.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------------------------------------------
// Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

on w_external_column_selection.create
int iCurrent
call super::create
this.cb_savetemplate=create cb_savetemplate
this.cbx_reretrieve=create cbx_reretrieve
this.ln_1=create ln_1
this.ln_2=create ln_2
this.cb_cancel=create cb_cancel
this.ln_6=create ln_6
this.ln_7=create ln_7
this.st_title=create st_title
this.p_1=create p_1
this.st_22=create st_22
this.cb_apply=create cb_apply
this.cb_ok=create cb_ok
this.st_4=create st_4
this.uo_columnselection=create uo_columnselection
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_savetemplate
this.Control[iCurrent+2]=this.cbx_reretrieve
this.Control[iCurrent+3]=this.ln_1
this.Control[iCurrent+4]=this.ln_2
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.ln_6
this.Control[iCurrent+7]=this.ln_7
this.Control[iCurrent+8]=this.st_title
this.Control[iCurrent+9]=this.p_1
this.Control[iCurrent+10]=this.st_22
this.Control[iCurrent+11]=this.cb_apply
this.Control[iCurrent+12]=this.cb_ok
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.uo_columnselection
end on

on w_external_column_selection.destroy
call super::destroy
destroy(this.cb_savetemplate)
destroy(this.cbx_reretrieve)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.cb_cancel)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.st_title)
destroy(this.p_1)
destroy(this.st_22)
destroy(this.cb_apply)
destroy(this.cb_ok)
destroy(this.st_4)
destroy(this.uo_columnselection)
end on

event open;call super::open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      open
// Overrides:  No
// Overview:   Initialize the wizard
// Created by: Blake Doerr
// History:    12/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(Message.PowerObjectParm) Then
	cbx_reretrieve.Visible = Not Message.PowerObjectParm.Dynamic of_get_isdynamiccriteria()
	If Not cbx_reretrieve.Visible Then
		This.Title = 'Select Custom Criteria Columns'
		st_title.Text = 'Select columns to be used as custom criteria for your report.'
	End If
End If

If IsValid(Message.PowerObjectParm) Then
	uo_columnselection.of_init(Message.PowerObjectParm)
	cb_savetemplate.Visible = Not uo_columnselection.of_areweaddingcriteria()
Else
	Post Close(This)
End If

f_center_window(this)

This.Event ue_refreshtheme()
end event

type cb_savetemplate from u_commandbutton within w_external_column_selection
boolean visible = false
integer x = 777
integer y = 1624
integer width = 462
integer height = 88
integer taborder = 50
integer weight = 400
string facename = "Tahoma"
string text = "A&dd to Favorites"
end type

event clicked;call super::clicked;String	ls_return
ls_return = uo_columnselection.of_add_to_favorites()

If ls_return <> '' Then
	gn_globals.in_messagebox.of_messagebox_validation (ls_return)
End If
end event

type cbx_reretrieve from checkbox within w_external_column_selection
integer x = 41
integer y = 1628
integer width = 576
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81517531
string text = "Retrieve After Adding"
boolean checked = true
end type

type ln_1 from line within w_external_column_selection
long linecolor = 8421504
integer linethickness = 5
integer beginy = 172
integer endx = 3899
integer endy = 172
end type

type ln_2 from line within w_external_column_selection
long linecolor = 16777215
integer linethickness = 5
integer beginy = 176
integer endx = 3899
integer endy = 176
end type

type cb_cancel from u_commandbutton within w_external_column_selection
integer x = 1984
integer y = 1624
integer width = 325
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   Close the parent window returning -1 indicating the user has cancelled
// Created by: Blake Doerr
// History:    12/28/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

CloseWithReturn(Parent, -1)
end event

type ln_6 from line within w_external_column_selection
long linecolor = 16777215
integer linethickness = 5
integer beginx = 5
integer beginy = 1600
integer endx = 4005
integer endy = 1600
end type

type ln_7 from line within w_external_column_selection
long linecolor = 8421504
integer linethickness = 5
integer beginx = 5
integer beginy = 1596
integer endx = 4005
integer endy = 1596
end type

type st_title from statictext within w_external_column_selection
integer x = 238
integer y = 52
integer width = 1632
integer height = 56
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Select external columns to add to the report"
boolean focusrectangle = false
end type

type p_1 from picture within w_external_column_selection
integer x = 46
integer y = 24
integer width = 178
integer height = 132
string picturename = "inhouserule_prvsn.bmp"
boolean focusrectangle = false
end type

type st_22 from statictext within w_external_column_selection
integer width = 3995
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

type cb_apply from u_commandbutton within w_external_column_selection
integer x = 1271
integer y = 1624
integer width = 325
integer height = 88
integer taborder = 10
integer weight = 400
string facename = "Tahoma"
string text = "&Apply"
end type

event clicked;call super::clicked;if Not Parent.of_validate() then	Return

uo_columnselection.of_apply(False)

end event

type cb_ok from u_commandbutton within w_external_column_selection
integer x = 1627
integer y = 1624
integer width = 325
integer height = 88
integer taborder = 30
integer weight = 400
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   If wf_validate_context() is successful, close the window returning the selected report folder id
// Created by: Pat Newgent
// History:    12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_return

if Not Parent.of_validate() then	Return

uo_columnselection.of_apply(cbx_reretrieve.Checked)

CloseWithReturn(Parent, 1)

end event

type st_4 from statictext within w_external_column_selection
integer y = 1604
integer width = 3442
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

type uo_columnselection from u_column_selection_external within w_external_column_selection
event destroy ( )
integer x = 9
integer y = 184
integer width = 2377
integer height = 1400
integer taborder = 30
boolean bringtotop = true
end type

on uo_columnselection.destroy
call u_column_selection_external::destroy
end on

event ue_column_selected();call super::ue_column_selected;cb_ok.Event Clicked()
end event

