$PBExportHeader$u_dynamic_gui_expression.sru
forward
global type u_dynamic_gui_expression from u_dynamic_gui
end type
type st_isvalid from statictext within u_dynamic_gui_expression
end type
type uo_functions from u_dynamic_gui_filter_functions within u_dynamic_gui_expression
end type
type mle_expression from multilineedit within u_dynamic_gui_expression
end type
end forward

global type u_dynamic_gui_expression from u_dynamic_gui
long backcolor = 81448892
st_isvalid st_isvalid
uo_functions uo_functions
mle_expression mle_expression
end type
global u_dynamic_gui_expression u_dynamic_gui_expression

type variables
Protected:
	String	is_expressiontype = '' //'boolean', number, datetime, string, '' {meaning anything valid}
	n_bag in_bag
	PowerObject io_Datasource
	Datastore	ids_expression_validation
	Boolean		ib_canbeempty 	= True
	Boolean		ib_addcolors	= True
end variables

forward prototypes
public subroutine of_clear ()
public function boolean of_validate ()
public subroutine of_init (powerobject ao_datasource)
public function string of_get_expression ()
public subroutine of_add_colors (ref string as_colors[], ref string as_displayname[], boolean ab_addblack)
public subroutine of_set_expression (string as_expression)
public function string of_get_expression_datawindow ()
end prototypes

public subroutine of_clear ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
mle_expression.Text = ''
end subroutine

public function boolean of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_position
Long		ll_position2
String	ls_datatype
String	ls_expression
String	ls_return
String	ls_describe
n_datawindow_tools ln_datawindow_tools
//n_string_functions ln_string_functions

If Trim(mle_expression.Text) = '' And ib_canbeempty Then Return True

ls_expression = of_get_expression_datawindow()
ln_datawindow_tools = Create n_datawindow_tools
ls_return = ln_datawindow_tools.of_validate_expression(ids_expression_validation, ls_expression, is_expressiontype)
Destroy ln_datawindow_tools
If ls_return <> '!' Then
	st_isvalid.Text = 'The expression is currently valid.'
	st_isvalid.TextColor = 0
Else
	st_isvalid.Text = 'The expression is not currently valid.'
	st_isvalid.TextColor = 255
	If Pos(ls_expression, '[') > 0 Then
		ll_position = Pos(ls_expression, '[')
		ll_position2 = Pos(ls_expression, ']', ll_position)
		
		If ll_position2 > ll_position Then
			st_isvalid.Text = st_isvalid.Text + '  ' + Mid(ls_expression, ll_position, ll_position2 - ll_position + 1) + ' may not be valid.'
		End If
	End If
End If

Return ls_return <> '!'
end function

public subroutine of_init (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_datatype
String	ls_expression
String	ls_canbeempty = ''
String	ls_AddColors = ''
String	ls_object[]
DatawindowChild ldwc_childreport
n_datawindow_tools ln_datawindow_tools

in_bag 			= ao_datasource
io_Datasource 	= in_bag.of_get('datasource')
ls_datatype 	= Lower(Trim(String(in_bag.of_get('datatype'))))
ls_expression 	= String(in_bag.of_get('expression'))
ls_canbeempty	= String(in_bag.of_get('canbeempty'))
ls_AddColors	= String(in_bag.of_get('AddColors'))

If ls_canbeempty = 'no' and Not IsNull(ls_canbeempty) Then
	ib_canbeempty = True
End If

If ls_AddColors = 'no' and Not IsNull(ls_canbeempty) Then
	ib_AddColors = False
End If

Choose Case Lower(Trim(ls_datatype))
	Case 'string', 'datetime', 'number', '', 'boolean'
		is_expressiontype = ls_datatype
End Choose

If Long(io_datasource.Dynamic describe("DataWindow.Processing")) = 5 Then
	ln_datawindow_tools = Create n_datawindow_tools
	ln_datawindow_tools.of_get_objects(io_datasource, 'report', ls_object[], False)
	Destroy ln_datawindow_tools
	
	If UpperBound(ls_object[]) > 0 Then
		io_datasource.Dynamic GetChild(ls_object[1], ldwc_childreport)
		If IsValid(ldwc_childreport) Then
			io_datasource = ldwc_childreport
			in_bag.of_set('datasource', io_Datasource)
		End If
	End If
End If

uo_functions.of_init(in_bag)

This.of_set_expression(ls_expression)

ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_apply_syntax(ids_expression_validation, io_datasource.Dynamic Describe("Datawindow.Syntax"))
ids_expression_validation.InsertRow(0)
Destroy ln_datawindow_tools

end subroutine

public function string of_get_expression ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Return mle_expression.Text
end function

public subroutine of_add_colors (ref string as_colors[], ref string as_displayname[], boolean ab_addblack);//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Transparent]'
as_colors		[UpperBound(as_colors[]) + 1]			= '536870912'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Transparent - 2]'
as_colors		[UpperBound(as_colors[]) + 1]			= '553648127'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[White]'
as_colors		[UpperBound(as_colors[]) + 1]			= '16777215'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Button Face]'
as_colors		[UpperBound(as_colors[]) + 1]			= '79741120'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Button Face - 2]'
as_colors		[UpperBound(as_colors[]) + 1]			= '80263581'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Datawindow Background]'
as_colors		[UpperBound(as_colors[]) + 1]			= 'Long(Describe("Datawindow.Color"))'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Windows Background]'
as_colors		[UpperBound(as_colors[]) + 1]			= '1090519039'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Windows Background]'
as_colors		[UpperBound(as_colors[]) + 1]			= '1090519039'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Windows Text]'
as_colors		[UpperBound(as_colors[]) + 1]			= '33554432'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Application Workspace]'
as_colors		[UpperBound(as_colors[]) + 1]			= '272777794'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Grey]'
as_colors		[UpperBound(as_colors[]) + 1]			= '12632256'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Grey - Dark]'
as_colors		[UpperBound(as_colors[]) + 1]			= '8421504'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Red]'
as_colors		[UpperBound(as_colors[]) + 1]			= '255'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Red - Dark]'
as_colors		[UpperBound(as_colors[]) + 1]			= '128'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Green]'
as_colors		[UpperBound(as_colors[]) + 1]			= '65280'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Green - Dark]'
as_colors		[UpperBound(as_colors[]) + 1]			= '32768'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Blue]'
as_colors		[UpperBound(as_colors[]) + 1]			= '16711680'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Blue - Dark]'
as_colors		[UpperBound(as_colors[]) + 1]			= '8388608'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Magenta]'
as_colors		[UpperBound(as_colors[]) + 1]			= '16711935'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Magenta - Dark]'
as_colors		[UpperBound(as_colors[]) + 1]			= '8388736'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Cyan]'
as_colors		[UpperBound(as_colors[]) + 1]			= '16776960'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Cyan - Dark]'
as_colors		[UpperBound(as_colors[]) + 1]			= '8421376'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Yellow]'
as_colors		[UpperBound(as_colors[]) + 1]			= '65535'
as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Brown]'
as_colors		[UpperBound(as_colors[]) + 1]			= '32896'
If ab_addblack Then
	as_displayname	[UpperBound(as_displayname[]) + 1]	= '[Black]'
	as_colors		[UpperBound(as_colors[]) + 1]			= '0'
End If
end subroutine

public subroutine of_set_expression (string as_expression);//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_columns[]
String	ls_headertext[]

n_datawindow_tools ln_datawindow_tools
ln_datawindow_tools = Create n_datawindow_tools

ls_columns[]		= in_bag.of_get('columns')
ls_headertext[]	= in_bag.of_get('headertexts')

For ll_index = 1 To UpperBound(ls_headertext[])
	ls_headertext[ll_index] = '[' + ls_headertext[ll_index] + ']'
Next

If ib_AddColors Then
	This.of_add_colors(ls_columns[], ls_headertext[], False)
End If

as_expression = ln_datawindow_tools.of_translate_expression(as_expression, ls_columns[], ls_headertext[])

Destroy ln_datawindow_tools

mle_expression.Text = as_expression
end subroutine

public function string of_get_expression_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_columns[]
String	ls_headertext[]
String	ls_expression

n_datawindow_tools ln_datawindow_tools
ln_datawindow_tools = Create n_datawindow_tools

ls_columns[]		= in_bag.of_get('columns')
ls_headertext[]	= in_bag.of_get('headertexts')

For ll_index = 1 To UpperBound(ls_headertext[])
	ls_headertext[ll_index] = '[' + ls_headertext[ll_index] + ']'
Next

This.of_add_colors(ls_columns[], ls_headertext[], True)

ls_expression = ln_datawindow_tools.of_translate_expression(This.of_get_expression(), ls_headertext[], ls_columns[])

Destroy ln_datawindow_tools

Return ls_expression
end function

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
mle_expression.Width = Width - (2 * mle_expression.X) - 30
uo_functions.Width = This.Width
uo_functions.Height = Max(730, This.Height / 2.2)
uo_functions.Y = This.Height - uo_functions.Height
mle_expression.Height = uo_functions.Y - mle_expression.Y - 8
//uo_functions.Height = This.Height - uo_functions.Y

end event

on u_dynamic_gui_expression.create
int iCurrent
call super::create
this.st_isvalid=create st_isvalid
this.uo_functions=create uo_functions
this.mle_expression=create mle_expression
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_isvalid
this.Control[iCurrent+2]=this.uo_functions
this.Control[iCurrent+3]=this.mle_expression
end on

on u_dynamic_gui_expression.destroy
call super::destroy
destroy(this.st_isvalid)
destroy(this.uo_functions)
destroy(this.mle_expression)
end on

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
ids_expression_validation = Create Datastore
end event

event destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ids_expression_validation
end event

event ue_refreshtheme;//
end event

type st_isvalid from statictext within u_dynamic_gui_expression
integer x = 27
integer y = 4
integer width = 1874
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The expression is currently valid."
boolean focusrectangle = false
end type

type uo_functions from u_dynamic_gui_filter_functions within u_dynamic_gui_expression
integer y = 384
integer height = 668
integer taborder = 42
boolean border = false
end type

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_set_destination(mle_expression)
end event

on uo_functions.destroy
call u_dynamic_gui_filter_functions::destroy
end on

type mle_expression from multilineedit within u_dynamic_gui_expression
event ue_pbm_enchange pbm_enchange
integer x = 27
integer y = 64
integer width = 1792
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
integer tabstop[] = {5,10,15,20,25,30,35,40}
borderstyle borderstyle = stylelowered!
boolean hideselection = false
boolean ignoredefaultbutton = true
end type

event ue_pbm_enchange;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.of_validate()
end event

event modified;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.of_validate()
end event

