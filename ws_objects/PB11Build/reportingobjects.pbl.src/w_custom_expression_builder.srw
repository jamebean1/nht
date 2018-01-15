$PBExportHeader$w_custom_expression_builder.srw
forward
global type w_custom_expression_builder from window
end type
type cb_savetemplate from u_commandbutton within w_custom_expression_builder
end type
type sle_expressionname from singlelineedit within w_custom_expression_builder
end type
type st_expression from u_theme_strip within w_custom_expression_builder
end type
type cb_clear from u_commandbutton within w_custom_expression_builder
end type
type cb_cancel from u_commandbutton within w_custom_expression_builder
end type
type cb_ok from u_commandbutton within w_custom_expression_builder
end type
type uo_expression from u_dynamic_gui_expression within w_custom_expression_builder
end type
type ln_6 from line within w_custom_expression_builder
end type
type ln_7 from line within w_custom_expression_builder
end type
type st_4 from statictext within w_custom_expression_builder
end type
end forward

global type w_custom_expression_builder from window
integer x = 1001
integer y = 1000
integer width = 1856
integer height = 1536
boolean titlebar = true
string title = "Expression Builder"
windowtype windowtype = response!
long backcolor = 81448892
cb_savetemplate cb_savetemplate
sle_expressionname sle_expressionname
st_expression st_expression
cb_clear cb_clear
cb_cancel cb_cancel
cb_ok cb_ok
uo_expression uo_expression
ln_6 ln_6
ln_7 ln_7
st_4 st_4
end type
global w_custom_expression_builder w_custom_expression_builder

type variables
Protected:
	n_bag in_bag
	Boolean	ib_NameIsRequired = False
	Boolean	ib_NameIsNotAllowed 	= True
	Boolean	ib_DestroyBag 			= True
end variables

on w_custom_expression_builder.create
this.cb_savetemplate=create cb_savetemplate
this.sle_expressionname=create sle_expressionname
this.st_expression=create st_expression
this.cb_clear=create cb_clear
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.uo_expression=create uo_expression
this.ln_6=create ln_6
this.ln_7=create ln_7
this.st_4=create st_4
this.Control[]={this.cb_savetemplate,&
this.sle_expressionname,&
this.st_expression,&
this.cb_clear,&
this.cb_cancel,&
this.cb_ok,&
this.uo_expression,&
this.ln_6,&
this.ln_7,&
this.st_4}
end on

on w_custom_expression_builder.destroy
destroy(this.cb_savetemplate)
destroy(this.sle_expressionname)
destroy(this.st_expression)
destroy(this.cb_clear)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.uo_expression)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.st_4)
end on

event resize;st_4.Y 	= WorkspaceHeight() - st_4.Height

ln_6.BeginY 	= st_4.Y - 4
ln_6.EndY 		= ln_6.BeginY

ln_7.BeginY 	= ln_6.BeginY - 4
ln_7.EndY 		= ln_7.BeginY

cb_cancel.Y = st_4.Y + 20
cb_cancel.X = Width - cb_cancel.Width - 40
cb_ok.Y = cb_cancel.Y
cb_ok.X = cb_cancel.X - cb_ok.Width - 20
cb_clear.Y	= cb_ok.Y
cb_clear.X	= cb_ok.X - cb_clear.Width - 20
cb_savetemplate.Y	= cb_clear.Y
cb_savetemplate.X	= cb_clear.X - cb_savetemplate.Width - 20

uo_expression.Width = Width
uo_expression.Height = ln_6.BeginY - uo_expression.Y - 4
end event

event open;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Open
//	Overrides:  No
//	Arguments:	
//	Overview:   Make the window resizeable
//	Created by: Blake Doerr
//	History:    12/11/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_title
String	ls_DefaultName
String	ls_expressionlabel


If Not IsValid(Message.PowerObjectParm) Then Post Close(This)
If Not ClassName(Message.PowerObjectParm) = 'n_bag' Then Post Close(This)

//This.BackColor = gn_globals.in_theme.of_get_backcolor()

in_bag 					= Message.PowerObjectParm

If in_bag.of_exists('ExpressionType') Then
	If in_bag.of_exists('ExpressionSourceID') Then
		cb_savetemplate.Enabled = True
	End If
End If

n_win32_api_calls ln_win32_api_calls
ln_win32_api_calls = Create n_win32_api_calls
ln_win32_api_calls.of_make_response_window_resizable(This)
Destroy ln_win32_api_calls

ls_title 				= String(in_bag.of_get('title'))
ib_NameIsRequired		= Lower(Trim(String(in_bag.of_get('NameIsRequired')))) = 'yes'
ib_NameIsNotAllowed	= Lower(Trim(String(in_bag.of_get('NameIsNotAllowed')))) = 'yes'

ls_expressionlabel	= String(in_bag.of_get('ExpressionNameLabel'))
ls_DefaultName			= String(in_bag.of_get('ExpressionDefaultName'))


If Not IsNull(ls_DefaultName) And Len(Trim(ls_DefaultName)) > 0 Then
	sle_expressionname.Text = ls_DefaultName
End If

If Not IsNull(ls_expressionlabel) And Len(Trim(ls_expressionlabel)) > 0 Then
	st_expression.Text = ls_expressionlabel
End If

If Not IsNull(ls_title) And Len(Trim(ls_title)) <> 0 Then
	This.Title = ls_title
End If

sle_expressionname.Enabled = Not ib_NameIsNotAllowed

uo_expression.of_init(in_bag)

f_center_window(this)
end event

event closequery;If ib_DestroyBag Then
	Destroy in_bag
End If
end event

type cb_savetemplate from u_commandbutton within w_custom_expression_builder
integer x = 219
integer y = 1308
integer width = 462
integer height = 88
integer taborder = 82
integer weight = 400
string facename = "Tahoma"
boolean enabled = false
string text = "Save Expression..."
end type

event clicked;call super::clicked;n_dao ln_dao
String ls_gui
Window lw_window

ln_dao = Create n_dao_expressionfavorite
ln_dao.Dynamic of_new()
ln_dao.of_SetItem(1, 'Type', Left(String(in_bag.of_get('ExpressionType')), 2))
ln_dao.of_SetItem(1, 'SourceID', in_bag.of_get('ExpressionSourceID'))
ln_dao.of_SetItem(1, 'Expression', uo_expression.of_get_expression())
ln_dao.of_SetItem(1, 'ColumnName', sle_expressionname.Text)
ln_dao.of_SetItem(1, 'ColumnDescription', sle_expressionname.Text)

If in_bag.of_exists('ExpressionTypeName') Then
	ln_dao.of_SetItem(1, 'ExpressionTypeName', String(in_bag.of_get('ExpressionTypeName')))
End If	


ls_gui = ln_dao.Dynamic of_getitem(1, 'GUI')
If Len(ls_gui) > 0 Then
	OpenWithParm(lw_window, ln_dao, ls_gui, Parent)
End If
end event

type sle_expressionname from singlelineedit within w_custom_expression_builder
integer x = 777
integer y = 28
integer width = 1006
integer height = 84
integer taborder = 32
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 255
borderstyle borderstyle = stylelowered!
end type

type st_expression from u_theme_strip within w_custom_expression_builder
integer y = 40
integer width = 745
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
long textcolor = 0
long backcolor = 81448892
string text = "Name of Expression (Optional):"
alignment alignment = right!
end type

event ue_refreshtheme;//backcolor = gn_globals.in_theme.of_get_backcolor()
end event

type cb_clear from u_commandbutton within w_custom_expression_builder
integer x = 704
integer y = 1308
integer width = 411
integer height = 88
integer taborder = 72
integer weight = 400
string facename = "Tahoma"
string text = "Clear Expression"
end type

event clicked;call super::clicked;uo_expression.of_clear()

end event

type cb_cancel from u_commandbutton within w_custom_expression_builder
integer x = 1495
integer y = 1308
integer width = 325
integer height = 88
integer taborder = 62
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      clicked
// Overrides:  No
// Overview:   Close the parent window returning -1 indicating the user has cancelled the folder selection process.
// Created by: Pat Newgent
// History:    12/23/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Destroy in_bag
Close(Parent)

end event

type cb_ok from u_commandbutton within w_custom_expression_builder
integer x = 1138
integer y = 1308
integer width = 325
integer height = 88
integer taborder = 52
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

If ib_nameisrequired Then
	If Len(Trim(sle_expressionname.Text)) <= 0 Then
		sle_expressionname.SetFocus()
		sle_expressionname.SelectText(1, 255)
		gn_globals.in_messagebox.of_messagebox_validation ('You must provide a name for the expression')
		Return
	End If
End If

If uo_expression.of_validate() Then
	If Len(Trim(sle_expressionname.Text)) > 0 Then
		in_bag.of_set('expressionlabel', sle_expressionname.Text)
	End If
	
	in_bag.of_set('expression', uo_expression.of_get_expression())
	in_bag.of_set('datawindowexpression', uo_expression.of_get_expression_datawindow())
	ib_DestroyBag = False
	Close(Parent)
Else
	gn_globals.in_messagebox.of_messagebox_validation ('The expression is not valid')
End If


end event

type uo_expression from u_dynamic_gui_expression within w_custom_expression_builder
integer y = 156
integer width = 1851
integer height = 1120
integer taborder = 32
boolean border = false
end type

on uo_expression.destroy
call u_dynamic_gui_expression::destroy
end on

type ln_6 from line within w_custom_expression_builder
long linecolor = 16777215
integer linethickness = 1
integer beginy = 1280
integer endx = 32000
integer endy = 1280
end type

type ln_7 from line within w_custom_expression_builder
long linecolor = 8421504
integer linethickness = 1
integer beginy = 1276
integer endx = 32000
integer endy = 1276
end type

type st_4 from statictext within w_custom_expression_builder
integer y = 1284
integer width = 32000
integer height = 128
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

