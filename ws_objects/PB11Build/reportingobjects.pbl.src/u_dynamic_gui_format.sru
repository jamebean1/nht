$PBExportHeader$u_dynamic_gui_format.sru
forward
global type u_dynamic_gui_format from userobject
end type
type dw_properties from u_datawindow within u_dynamic_gui_format
end type
end forward

global type u_dynamic_gui_format from userobject
integer width = 1934
integer height = 984
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_properties dw_properties
end type
global u_dynamic_gui_format u_dynamic_gui_format

type variables
Protected:
	//n_string_functions					in_string_functions
	Datawindow 				idw_data
	n_bag						in_bag
	String					is_objectname
	String					is_objecttype
	String					is_errormessage
	Datastore				ids_TestDatastore
	Datawindow				idw_properties[]
end variables

forward prototypes
public function boolean of_validate ()
public subroutine of_apply ()
public subroutine of_set_bag (n_bag an_bag)
public function string of_get_errormessage ()
public function string of_apply_property (datawindow adw_property_datawindow, string as_columnname, powerobject ao_apply_datawindow)
public subroutine of_init ()
end prototypes

public function boolean of_validate ();Long	ll_columncount
Long	ll_index
Long	ll_index2
String	ls_columnname
String	ls_return
n_datawindow_tools ln_datawindow_tools

ln_datawindow_tools = Create n_datawindow_tools
ids_TestDatastore = Create Datastore

ln_datawindow_tools.of_apply_syntax(ids_TestDatastore, idw_data.Describe("Datawindow.Syntax"))

Destroy ln_datawindow_tools

For ll_index = 1 To UpperBound(idw_properties[])
	ll_columncount = Long(idw_properties[ll_index].Describe("Datawindow.Column.Count"))
	
	For ll_index2 = 1 To ll_columncount
		ls_columnname = idw_properties[ll_index].Describe("#" + String(ll_index2) + '.Name')
		
		ls_return = This.of_apply_property(idw_properties[ll_index], ls_columnname, ids_TestDatastore)
		
		If ls_return <> '' Then
			Destroy ids_TestDatastore
			idw_properties[ll_index].SetFocus()
			idw_properties[ll_index].SetColumn(ls_columnname)
			gn_globals.in_messagebox.of_messagebox_validation ('This property is not valid')
			Return False
		End If
	Next
Next

Return True
end function

public subroutine of_apply ();Long	ll_columncount
Long	ll_index
Long	ll_index2
String	ls_columnname
String	ls_return

For ll_index = 1 To UpperBound(idw_properties[])
	idw_properties[ll_index].AcceptText()
	
	ll_columncount = Long(idw_properties[ll_index].Describe("Datawindow.Column.Count"))
	
	For ll_index2 = 1 To ll_columncount
		ls_columnname = idw_properties[ll_index].Describe("#" + String(ll_index2) + '.Name')

		ls_return = This.of_apply_property(idw_properties[ll_index], ls_columnname, idw_data)
	Next
Next

end subroutine

public subroutine of_set_bag (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_bag()
//	Arguments:  an_bag 	- The bag object with all the data
//	Overview:   This will set the bag object
//	Created by:	Blake Doerr
//	History: 	7/12/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

in_bag 									= an_bag
idw_data									= in_bag.of_get('datasource')
is_objectname							= String(in_bag.of_get('object'))
is_objecttype							= String(in_bag.of_get('objecttype'))

idw_properties[UpperBound(idw_properties[]) + 1] = dw_properties
end subroutine

public function string of_get_errormessage ();String	ls_errormessage

If is_errormessage = '' Then
	Return 'The expression is not valid'
Else
	ls_errormessage 	= is_errormessage
	is_errormessage	= ''
	Return ls_errormessage
End If
end function

public function string of_apply_property (datawindow adw_property_datawindow, string as_columnname, powerobject ao_apply_datawindow);String	ls_property, ls_original
String	ls_modify_string
String	ls_return

If Left(as_columnname, Len('ignore_')) = 'ignore_' Then Return ''

Choose Case Lower(Trim(as_columnname))
	Case 'name'
		Return ''
End Choose

If adw_property_datawindow.GetItemStatus(1, as_columnname, Primary!) = New! Then Return ''

ls_property = adw_property_datawindow.GetItemString(1, as_columnname)

gn_globals.in_string_functions.of_replace_all(as_columnname, '__', ' ')
gn_globals.in_string_functions.of_replace_all(as_columnname, '_', '.')

gn_globals.in_string_functions.of_replace_all(ls_property,'"','~~"')

///If IsNumber(adw_property_datawindow.Describe('button_' + as_columnname + '.X')) Or IsNumber(adw_property_datawindow.Describe('browse_' + as_columnname + '.X')) Then
	ls_property = '"' + ls_property + '"'
//End If

ls_modify_string	= is_objectname + '.' + as_columnname + " = " + ls_property

ls_return = ao_apply_datawindow.Dynamic Modify(ls_modify_string)

Return ls_return
end function

public subroutine of_init ();Long		ll_index
Long		ll_index2
Long		ll_columncount
Long		ll_row
String	ls_property
String	ls_describe
String	ls_return
//n_string_functions ln_string_functions

For ll_index = 1 To UpperBound(idw_properties[])
	idw_properties[ll_index].Reset()
	ll_row = idw_properties[ll_index].InsertRow(0)
	
	ll_columncount = Long(idw_properties[ll_index].Describe("Datawindow.Column.Count"))
	For ll_index2 = 1 To ll_columncount
		ls_property = idw_properties[ll_index].Describe("#" + String(ll_index2) + ".Name")
		
		gn_globals.in_string_functions.of_replace_all(ls_property, '_', '.')
		ls_describe = is_objectname + '.' + ls_property
		
		ls_return = idw_data.Describe(ls_describe)
		
		If ls_return = '?' Or ls_return = '!' Then Continue
		
		If (Pos(ls_return, '~t') > 0 Or Pos(ls_return, '	') > 0 Or Pos(ls_return, '~~"') > 0) And Left(ls_return, 1) = '"' And Right(ls_return, 1) = '"' Then
			ls_return = Mid(ls_return, 2, Len(ls_return) - 2)
		End If
		
		gn_globals.in_string_functions.of_replace_all(ls_return, '~~"', '"')
		
		If Lower(Trim(ls_property)) = 'expression' Then
			If Pos(ls_return, '~n') > 0 And Pos(ls_return, "'") > 0 Then
				If Left(ls_return, 1) = '"' And Right(ls_return, 1) = '"' Then
					ls_return = Mid(ls_return, 2, Len(ls_return) - 2)
				End If
			End If
		End If
 		
		idw_properties[ll_index].SetItem(ll_row, ll_index2, ls_return)
		idw_properties[ll_index].SetItemStatus(ll_row, ll_index2, Primary!, NotModified!)
	Next
	
	idw_properties[ll_index].SetItemStatus(ll_row, 0, Primary!, NotModified!)
Next
end subroutine

on u_dynamic_gui_format.create
this.dw_properties=create dw_properties
this.Control[]={this.dw_properties}
end on

on u_dynamic_gui_format.destroy
destroy(this.dw_properties)
end on

event constructor;If Not IsValid(Message.PowerObjectParm) Then Return
If Not ClassName(Message.PowerObjectParm) = 'n_bag' Then Return

in_bag 									= Message.PowerObjectParm
This.of_set_bag(in_bag)

end event

type dw_properties from u_datawindow within u_dynamic_gui_format
integer x = 18
integer width = 1755
integer height = 904
integer taborder = 10
boolean border = false
end type

event buttonclicked;call super::buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	buttonclicked()
//	Overview:   This will pop the expression window if necessary
//	Created by:	Blake Doerr
//	History: 	6/5/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_columnname
String	ls_tag
String	ls_expression
String	ls_columns[]
String	ls_values[]
String	ls_default = '0'
Long		ll_index
String 	ls_pathname
String	ls_filename
Int 		i_rtn

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_bag		ln_bag
Window	lw_window
//n_string_functions ln_string_functions
n_datawindow_tools ln_datawindow_tools
n_common_dialog ln_common_dialog

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the row or dwo isn't valid.  Return if this isn't a correctly named button
//-----------------------------------------------------------------------------------------------------------------------------------
If row <= 0 Or IsNull(row) Then Return
If Not IsValid(dwo) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column name from the button name.  Retur if it isn't a valid column
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columnname = Right(dwo.Name, Len(String(dwo.Name)) - Len('button_'))
If Not IsNumber(This.Describe(ls_columnname + '.ID')) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Left(Lower(Trim(dwo.Name)), Len('button'))
	Case 'button'
	Case 'browse'
		ln_common_dialog = Create n_common_dialog
		i_rtn = ln_common_dialog.of_GetFileOpenName('Available Bitmap Files', ls_pathname, ls_filename ,'bmp', "Bitmap Files (*.bmp),*.bmp" )
		Destroy ln_common_dialog

		if i_rtn <= 0 Then Return
		If len(ls_pathname) <= 0 Then Return
		If Not FileExists (ls_pathname ) Then Return
		
		This.SetItem(row, ls_columnname, ls_pathname)
		Return
	Case Else
		Return
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the tag of the column because it has information we need to build the expression1
//-----------------------------------------------------------------------------------------------------------------------------------
ls_tag 		= This.Describe(ls_columnname + '.Tag')
gn_globals.in_string_functions.of_parse_arguments(ls_tag, ls_columns[], ls_values[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the arguments and set them into variables
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_columns[]), UpperBound(ls_values[]))
	Choose Case Lower(Trim(ls_columns[ll_index]))
		Case 'default'
			ls_default	= ls_values[ll_index]
	End Choose
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression and cut off the default if it's there
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = This.GetItemString(row, ls_columnname)
If Lower(Trim(ls_default)) <> 'none' Then
	If Pos(ls_expression, '~t') > 0 Then ls_expression = Mid(ls_expression, Pos(ls_expression, '~t') + 1, 10000)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the information on the bag to configure the expression builder datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_bag = Create n_bag
ln_bag.of_set('datasource', idw_data)
ln_bag.of_set('title', 'Select the Expression for the Report Element Property')
ln_bag.of_set('expression', ls_expression)
ln_bag.of_set('NameIsNotAllowed', 'yes')
If Pos(ls_columnname, 'color') <= 0 Then
	ln_bag.of_set('AddColors', 'no')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Open the window with the parameter
//-----------------------------------------------------------------------------------------------------------------------------------
OpenWithParm(lw_window, ln_bag, 'w_custom_expression_builder', w_mdi)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the bag is not valid.  That means they canceled out of the window.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_bag) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression returned from the window.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = String(ln_bag.of_get('datawindowexpression'))

//-----------------------------------------------------------------------------------------------------------------------------------
// If the expression is not in the dropdown, we have to assume that it came from the expression builder.  We must add the default.
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
If Not ln_datawindow_tools.of_value_exists_in_dropdowndatawindow(This, ls_columnname, '"' + ls_expression + '"') Then
	If Trim(ls_expression) = '' Then
		ls_expression = ls_default
	Else
		If Lower(Trim(ls_default)) <> 'none' Then
			ls_expression = ls_default + '~t' + ls_expression
		End If
	End If
End If
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the expression into the datawindow.  The expressions on the objects will take care of the rest
//-----------------------------------------------------------------------------------------------------------------------------------
This.SetItem(row, ls_columnname, ls_expression)

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the bag object if it's valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ln_bag) Then Destroy ln_bag

end event

