$PBExportHeader$u_dynamic_gui_filter_functions.sru
forward
global type u_dynamic_gui_filter_functions from u_dynamic_gui
end type
type st_help from statictext within u_dynamic_gui_filter_functions
end type
type st_syntax from statictext within u_dynamic_gui_filter_functions
end type
type dw_function from u_datawindow within u_dynamic_gui_filter_functions
end type
type dw_functioncategory from u_datawindow within u_dynamic_gui_filter_functions
end type
end forward

global type u_dynamic_gui_filter_functions from u_dynamic_gui
integer width = 1856
integer height = 740
long backcolor = 81448892
string text = "Functions"
st_help st_help
st_syntax st_syntax
dw_function dw_function
dw_functioncategory dw_functioncategory
end type
global u_dynamic_gui_filter_functions u_dynamic_gui_filter_functions

type variables
Protected:
MultiLineEdit imle_destination

PowerObject io_datasource

String	is_columns[]
String	is_headers[]
String	is_headertext[]
String	is_columntype[]

String	is_prefix	= ''
String	is_suffix	= ''
String	is_filter	= ''
n_bag in_bag
end variables

forward prototypes
public subroutine of_set_destination (multilineedit amle_destination)
public function string of_get_helptext (string as_column, string as_headertext)
public subroutine of_init (powerobject ao_datasource)
end prototypes

public subroutine of_set_destination (multilineedit amle_destination);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_destination()
//	Arguments:  amle_destination - The destination
//	Overview:   This will set the destination
//	Created by:	Blake Doerr
//	History: 	4/25/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

imle_destination = amle_destination
end subroutine

public function string of_get_helptext (string as_column, string as_headertext);//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_columntype, ls_helptext

If Not IsValid(io_datasource) Then Return ''

n_datawindow_tools ln_datawindow_tools
ln_datawindow_tools = Create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column type.
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(Left(is_prefix, 13))) = 'lookupdisplay' Then
	ls_columntype = 'char(4099)'
Else
	ls_columntype = ln_datawindow_tools.of_get_columntype(io_datasource, as_column)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the main help text.
//-----------------------------------------------------------------------------------------------------------------------------------
If ln_datawindow_tools.of_IsColumn(io_datasource, as_column) Then
	ls_helptext = 'A column named ' + as_headertext + ' that has an actual column name of ' + as_column + '.  It has a datatype of ' + ls_columntype + '.'
ElseIf ln_datawindow_tools.of_IsComputedField(io_datasource, as_column) Then
	ls_helptext = 'A computed field named ' + as_headertext + ' that has an actual name of ' + as_column + '.  It has a datatype of ' + ls_columntype + '.~r~nThe expression is:  ' + ln_datawindow_tools.of_get_expression(io_datasource, as_column) + '.'
End If
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Build the additional help text.
//-----------------------------------------------------------------------------------------------------------------------------------
If is_prefix <> '' Then
	ls_helptext = ls_helptext + '  The column has been defaulted to have a prefix of ' + is_prefix
	If is_suffix <> '' Then
		ls_helptext = ls_helptext + '  and a suffix of ' + is_suffix
	End If
	ls_helptext = ls_helptext + '.'
End If

Destroy ln_datawindow_tools
Return ls_helptext
end function

public subroutine of_init (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_index2
Long		ll_row
Long		ll_next_functioncategoryrow = 2
Long		ll_sourceid
String	ls_type
String	ls_empty[]
String	ls_columntype
String	ls_helptext[]
String	ls_category
Boolean	lb_ColumnsDefinedOnTheBag
Boolean	lb_HelpTextOnBag
Datastore lds_datastore
n_datawindow_tools ln_datawindow_tools
str_expressionbuilder_category lstr_expressionbuilder_category[]
in_bag = ao_datasource

//-----------------------------------------------------------------------------------------------------------------------------------
// Get some values off the bag.
//-----------------------------------------------------------------------------------------------------------------------------------
lb_HelpTextOnBag				= in_bag.of_exists('helptext')
lb_ColumnsDefinedOnTheBag 	= Upper(Trim(String(in_bag.of_get('columnsonbag')))) = 'Y'
If IsNull(lb_ColumnsDefinedOnTheBag) Then lb_ColumnsDefinedOnTheBag = False

If lb_HelpTextOnBag 					Then ls_helptext[] = in_bag.of_get('helptext')
If Not lb_ColumnsDefinedOnTheBag Then io_datasource = in_bag.of_get('datasource')

//-----------------------------------------------------------------------------------------------------------------------------------
// Column prefixes and suffixes.
//-----------------------------------------------------------------------------------------------------------------------------------
is_prefix						= String(in_bag.of_get('columnprefix'))
is_suffix						= String(in_bag.of_get('columnsuffix'))
If IsNull(is_prefix) Then is_prefix = ''
If IsNull(is_suffix) Then is_suffix = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Change out the category datawindow if one is on the bag.
//-----------------------------------------------------------------------------------------------------------------------------------
If in_bag.of_exists('category datawindow') Then 
	dw_functioncategory.DataObject = String(in_bag.of_get('category datawindow'))	
	gn_globals.in_subscription_service.of_message('After View Restored', '', dw_functioncategory)
End If
ls_category = dw_functioncategory.GetItemString(1, 'category')

//-----------------------------------------------------------------------------------------------------------------------------------
// Change out the function datawindow if one is on the bag.
//-----------------------------------------------------------------------------------------------------------------------------------
If in_bag.of_exists('function datawindow') Then 
	dw_function.DataObject = String(in_bag.of_get('function datawindow'))	
	gn_globals.in_subscription_service.of_message('After View Restored', '', dw_function)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Filter out any columns.
//-----------------------------------------------------------------------------------------------------------------------------------
dw_function.SetFilter('category <> "' + ls_category + '"')
dw_function.Filter()	
If dw_function.FilteredCount() > 0 Then dw_function.RowsDiscard(1, dw_function.FilteredCount(), Filter!)

dw_function.SetFilter(is_filter)
dw_function.Filter()	

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the columns.
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_ColumnsDefinedOnTheBag Then 
	is_columns[]		= in_bag.of_get('columns')
	is_headers[]		= in_bag.of_get('headers')
	is_headertext[]	= in_bag.of_get('headertexts')
	is_columntype[]	= in_bag.of_get('columntypes')	
Else
	is_columns[]		= ls_empty[]
	is_headers[]		= ls_empty[]
	is_headertext[]	= ls_empty[]
	is_columntype[]	= ls_empty[]
	
	ln_datawindow_tools 	= Create n_datawindow_tools
	ln_datawindow_tools.of_get_columns_all(io_datasource, is_columns[], is_headers[], is_headertext[], is_columntype[])
	Destroy ln_datawindow_tools
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Fill out the function datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_columns[])
	If Len(is_headers[ll_index]) <= 0 Or is_headers[ll_index] = '!' Or is_headers[ll_index] = '?' Then Continue
	
	ll_row = dw_function.InsertRow(0)
	dw_function.SetItem(ll_row, 'category', ls_category)
	dw_function.SetItem(ll_row, 'functionname', '[' + is_headertext[ll_index] + ']')
	dw_function.SetItem(ll_row, 'syntax', '[' + is_headertext[ll_index] + ']')	
	
	If lb_HelpTextOnBag Then 
		dw_function.SetItem(ll_row, 'help', ls_helptext[ll_index])
	Else
		dw_function.SetItem(ll_row, 'help', This.of_get_helptext(is_columns[ll_index], is_headertext[ll_index]))
	End If
	
	If Not lb_ColumnsDefinedOnTheBag Then is_columns[ll_index] = is_prefix + is_columns[ll_index] + is_suffix
Next

ll_row = 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Fill out the function datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_columns[])
	If Not (Len(is_headers[ll_index]) <= 0 Or is_headers[ll_index] = '!' Or is_headers[ll_index] = '?') Then Continue

	ll_row = dw_function.InsertRow(0)
	dw_function.SetItem(ll_row, 'category', ls_category + ' (Hidden)')
	dw_function.SetItem(ll_row, 'functionname', '[' + is_headertext[ll_index] + ']')
	dw_function.SetItem(ll_row, 'syntax', '[' + is_headertext[ll_index] + ']')	
	
	If lb_HelpTextOnBag Then 
		dw_function.SetItem(ll_row, 'help', ls_helptext[ll_index])
	Else
		dw_function.SetItem(ll_row, 'help', This.of_get_helptext(is_columns[ll_index], is_headertext[ll_index]))
	End If
	
	If Not lb_ColumnsDefinedOnTheBag Then is_columns[ll_index] = is_prefix + is_columns[ll_index] + is_suffix
Next

IF ll_row > 0 Then
	If dw_functioncategory.Find('category = "' + ls_category + ' (Hidden)' + '"', 1, dw_functioncategory.RowCount()) <= 0 Then
		ll_row = dw_functioncategory.InsertRow(ll_next_functioncategoryrow)
		ll_next_functioncategoryrow = ll_next_functioncategoryrow + 1
		dw_functioncategory.SetItem(ll_row, 'grouptype', 'Report')
		dw_functioncategory.SetItem(ll_row, 'category', ls_category + ' (Hidden)')
	End If
End If


If in_bag.of_exists('category structure array') Then
	lstr_expressionbuilder_category[] = in_bag.of_get('category structure array')
End If

If in_bag.of_exists('category structure') Then
	lstr_expressionbuilder_category[UpperBound(lstr_expressionbuilder_category[]) + 1] = in_bag.of_get('category structure')
End If

If in_bag.of_exists('ExpressionType') Then
	ls_type = String(in_bag.of_get('ExpressionType'))

	If in_bag.of_exists('ExpressionSourceID') Then
		ll_sourceid = Long(in_bag.of_get('ExpressionSourceID'))
	Else
		SetNull(ll_sourceid)
	End If
	
	lds_datastore = Create Datastore
	lds_datastore.DataObject = 'dddw_expressionfavorite'
	lds_datastore.SetTransObject(SQLCA)
	lds_datastore.Retrieve(ls_type, ll_sourceid, gn_globals.il_userid)

	If lds_datastore.RowCount() > 0 Then
		lstr_expressionbuilder_category[UpperBound(lstr_expressionbuilder_category[]) + 1].category = 'Report'
		lstr_expressionbuilder_category[UpperBound(lstr_expressionbuilder_category[])].category = 'Favorite Expressions'
		lstr_expressionbuilder_category[UpperBound(lstr_expressionbuilder_category[])].columnname[] = lds_datastore.Object.ColumnName.Primary
		lstr_expressionbuilder_category[UpperBound(lstr_expressionbuilder_category[])].columndescription[] = lds_datastore.Object.ColumnDescription.Primary
		lstr_expressionbuilder_category[UpperBound(lstr_expressionbuilder_category[])].columndisplay[] = lds_datastore.Object.Expression.Primary
		lstr_expressionbuilder_category[UpperBound(lstr_expressionbuilder_category[])].sourceid[] = lds_datastore.Object.Idnty.Primary
	End If
	
	Destroy lds_datastore
End If

ll_row = 0

For ll_index = 1 To UpperBound(lstr_expressionbuilder_category[])
	If dw_functioncategory.Find('category = "' + lstr_expressionbuilder_category[ll_index].category + '"', 1, dw_functioncategory.RowCount()) <= 0 Then
		ll_row = dw_functioncategory.InsertRow(ll_next_functioncategoryrow)
		ll_next_functioncategoryrow = ll_next_functioncategoryrow + 1
		dw_functioncategory.SetItem(ll_row, 'grouptype', 'Report')
		dw_functioncategory.SetItem(ll_row, 'category', lstr_expressionbuilder_category[ll_index].category)
	End If

	For ll_index2 = 1 To UpperBound(lstr_expressionbuilder_category[ll_index].columnname[])
		ll_row = dw_function.InsertRow(0)
		dw_function.SetItem(ll_row, 'category', lstr_expressionbuilder_category[ll_index].category)
		dw_function.SetItem(ll_row, 'functionname', lstr_expressionbuilder_category[ll_index].columnname[ll_index2])

		If UpperBound(lstr_expressionbuilder_category[ll_index].columndisplay[]) >= ll_index2 Then
			dw_function.SetItem(ll_row, 'syntax', lstr_expressionbuilder_category[ll_index].columndisplay[ll_index2])	
		End If
		
		If UpperBound(lstr_expressionbuilder_category[ll_index].columndescription[]) >= ll_index2 Then
			dw_function.SetItem(ll_row, 'help', lstr_expressionbuilder_category[ll_index].columndescription[ll_index2])
		End If
		
		If UpperBound(lstr_expressionbuilder_category[ll_index].SourceID[]) >= ll_index2 Then
			dw_function.SetItem(ll_row, 'SourceID', lstr_expressionbuilder_category[ll_index].SourceID[ll_index2])
		End If
	Next
Next


dw_function.Sort()
dw_function.Filter()
dw_functioncategory.SetRow(2)
dw_functioncategory.SetRow(1)

//	dw_function.SetRow(2)
//	dw_function.SetRow(1)

If dw_function.RowCount() > 0 Then
	If dw_function.of_getselectedrow(0) = 0 Then
		dw_function.SetRow(0)		
		dw_function.SetRow(1)
	Else
		dw_function.SetRow(dw_function.of_getselectedrow(0))
	End If
End If

If Not lb_ColumnsDefinedOnTheBag Then
	in_bag.of_set('columns', 		is_columns[])
	in_bag.of_set('headers', 		is_headers[])
	in_bag.of_set('headertexts', 	is_headertext[])
	in_bag.of_set('columntypes', 	is_columntype[])
End If
end subroutine

on u_dynamic_gui_filter_functions.create
int iCurrent
call super::create
this.st_help=create st_help
this.st_syntax=create st_syntax
this.dw_function=create dw_function
this.dw_functioncategory=create dw_functioncategory
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_help
this.Control[iCurrent+2]=this.st_syntax
this.Control[iCurrent+3]=this.dw_function
this.Control[iCurrent+4]=this.dw_functioncategory
end on

on u_dynamic_gui_filter_functions.destroy
call super::destroy
destroy(this.st_help)
destroy(this.st_syntax)
destroy(this.dw_function)
destroy(this.dw_functioncategory)
end on

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Resize
//	Overrides:  No
//	Arguments:	
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    2/10/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the position and dimensions for the syntax and help text.
//-----------------------------------------------------------------------------------------------------------------------------------
st_help.Y 			= Height - 190
st_syntax.Y 		= st_help.Y - 60
st_help.Width 		= Width - (2 * st_help.X) - 10
st_syntax.Width 	= st_help.Width

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dimensions of the category datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
dw_functioncategory.Width	= 0.3524 * Width
dw_functioncategory.Height	= (st_syntax.Y - 24) - dw_function.Y

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the position and dimensions of the functions datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
dw_function.X					= dw_functioncategory.X + dw_functioncategory.Width + 40
dw_function.Width				= Width - dw_function.X - (2 * dw_functioncategory.X)
dw_function.Height			= dw_functioncategory.Height


end event

event ue_refreshtheme;//
end event

type st_help from statictext within u_dynamic_gui_filter_functions
integer x = 23
integer y = 528
integer width = 1769
integer height = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 80263581
boolean focusrectangle = false
end type

type st_syntax from statictext within u_dynamic_gui_filter_functions
integer x = 23
integer y = 452
integer width = 1774
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
boolean focusrectangle = false
end type

type dw_function from u_datawindow within u_dynamic_gui_filter_functions
integer x = 718
integer y = 16
integer width = 1115
integer height = 412
integer taborder = 22
string title = "none"
string dataobject = "d_dwfunction"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;call super::rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	ls_syntax
string	ls_help

If This.RowCount() > 0 And currentrow > 0 And Not IsNull(currentrow) Then
	If currentrow > This.RowCount() Then
		currentrow = Min(This.GetRow(), This.RowCount())
	End If
	
	if currentrow > 0 then
		ls_syntax = this.GetItemString (currentrow, "syntax")
		ls_help = this.GetItemString (currentrow, "help")
	
		st_syntax.text = ls_syntax
		st_help.text = ls_help
	End If
End If
end event

event doubleclicked;call super::doubleclicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


integer	li_position
long		ll_pos
long		ll_pos2
string		ls_syntax

if row > 0 then
	ls_syntax = this.object.syntax[row]
	li_position = imle_destination.Position()
	imle_destination.ReplaceText (ls_syntax)

	// Select expression between parenthesis
	if li_position > 0 then
		ll_pos = Pos (imle_destination.text, "(", li_position)
		if ll_pos > 0 then
			ll_pos2 = Pos (imle_destination.text, ")", li_position)
			if ll_pos2 > 0 then
				imle_destination.SelectText (ll_pos + 1, ll_pos2 - ll_pos - 1)
			end if
		end if
	end if	
end if

imle_destination.SetFocus()
end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
in_datawindow_graphic_service_manager.of_add_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_create_services()
end event

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


If 60 * This.RowCount() + 18 < This.Height Then
	This.Modify("t_edit.X = '" + String(This.Width - 340) + "'")
	This.Modify("t_delete.X = '" + String(This.Width - 170) + "'")
	This.Modify("functionname.Width = '" + String(This.Width - 340) + "'")
	This.Modify("t_color.X = '" + String(This.Width - 110) + "'")
Else
	This.Modify("t_edit.X = '" + String(This.Width - 400) + "'")
	This.Modify("t_delete.X = '" + String(This.Width - 250) + "'")
	This.Modify("functionname.Width = '" + String(This.Width - 400) + "'")
	This.Modify("t_color.X = '" + String(This.Width - 185) + "'")
End If

end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_dao 	ln_dao
Long		ll_SourceID
String	ls_gui
String	ls_return
Window	lw_window


If row <= 0 Or IsNull(row) Or row > This.RowCount() Then Return

If IsValid(dwo) Then	
	Choose Case Lower(Trim(dwo.Name))
		Case 't_edit'
			ll_SourceID = This.GetItemNumber(row, 'SourceID')
			If ll_SourceID > 0 And Not IsNull(ll_SourceID) Then
				ln_dao = Create n_dao_expressionfavorite
				ln_dao.SetTransObject(SQLCA)
				ln_dao.Retrieve(ll_SourceID)
				
				If in_bag.of_exists('ExpressionTypeName') Then
					ln_dao.of_SetItem(1, 'ExpressionTypeName', String(in_bag.of_get('ExpressionTypeName')))
				End If
				
				ls_gui = ln_dao.Dynamic of_getitem(1, 'GUI')
				If Len(ls_gui) > 0 Then
					OpenWithParm(lw_window, ln_dao, ls_gui, Parent.of_getparentwindow())
				End If				
			End If
		Case 't_delete'
			ll_SourceID = This.GetItemNumber(row, 'SourceID')
			If ll_SourceID > 0 And Not IsNull(ll_SourceID) Then
				ln_dao = Create n_dao_expressionfavorite
				ln_dao.SetTransObject(SQLCA)
				ln_dao.Retrieve(ll_SourceID)
				
				ls_return = ln_dao.of_getitem(1, 'security')
				
				If ls_return = '' Then
					If gn_globals.in_messagebox.of_messagebox_question ('Are you sure you would like to delete this expression?', YesNoCancel!, 3) <> 1 Then Return
					
					ln_dao.DeleteRow(1)
					ls_return = ln_dao.of_save()
					
					If ls_return <> '' Then
						gn_globals.in_messagebox.of_messagebox_validation(ls_return)
					Else					
						DeleteRow(row)
						This.Event RetrieveEnd(This.RowCount())
					End If
					
					Destroy ln_dao
				Else
					gn_globals.in_messagebox.of_messagebox_validation(ls_return)
				End If
			End If			
	End Choose
End If
		
end event

type dw_functioncategory from u_datawindow within u_dynamic_gui_filter_functions
integer x = 27
integer y = 16
integer width = 654
integer height = 412
integer taborder = 22
string title = "none"
string dataobject = "d_dwfunctioncategory"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;call super::rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_category, ls_columncategory

if currentrow > 0 then
	ls_category 		= GetItemString (currentrow, "category")
	ls_columncategory	= GetItemString (1, "category")
	If Lower(Trim(ls_category)) = '(all functions)' Then
		is_filter = "Match(category, 'Functions')"
	Else
		is_filter = "category = '" + ls_category + "'"
	End If

	dw_function.SetFilter(is_filter)
	dw_function.Filter()
	dw_function.Event RetrieveEnd(dw_function.RowCount())
	If dw_function.RowCount() > 0 Then
		dw_function.Event RowFocusChanged(1)
	End If
	/*
//	if dw_function.RowCount() > 0 then
//		dw_function.SetRow (2)
//		dw_function.SetRow (1)
//	end if

	If dw_function.of_getselectedrow(0) = 0 Then
		dw_function.SetRow(0)
		dw_function.SetRow(1)
	Else
		dw_function.SetRow(dw_function.of_getselectedrow(0))
	End If
	*/
end if
end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
in_datawindow_graphic_service_manager.of_add_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_create_services()
end event

