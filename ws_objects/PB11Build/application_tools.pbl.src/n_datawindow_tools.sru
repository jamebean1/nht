$PBExportHeader$n_datawindow_tools.sru
forward
global type n_datawindow_tools from nonvisualobject
end type
end forward

global type n_datawindow_tools from nonvisualobject
end type
global n_datawindow_tools n_datawindow_tools

type variables

end variables

forward prototypes
public function boolean of_copy_attributes (powerobject ao_source, string as_sourcecolumn, powerobject ao_destination, string as_destinationcolumn)
public function string of_translate_expression (powerobject ao_datasource, string as_expression, boolean ab_translate_to_english)
public function string of_create_distinct_filter (powerobject ao_datasource, string as_columnname, string as_filter_columnname)
public function string of_translate_expression (string as_expression, string as_column[], string as_headertext[])
public function boolean of_value_exists_in_dropdowndatawindow (powerobject ao_datasource, string as_column, string as_value)
public function string of_validate_expression (powerobject ao_datasource, string as_expression, string as_datatype)
public function string of_validate_expression (powerobject ao_datasource, string as_expression)
public function long of_fix_transparent_color_number (ref string as_syntax)
public subroutine of_translate_to_english (ref string as_names[])
public function string of_translate_to_english (string as_name)
public function string of_create_initcolumn (ref powerobject ao_powerobject, string as_computedfieldname, string as_expression)
public function string of_get_array_from_column (powerobject ao_datasource, long al_columnnumber, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[], boolean ab_sorted)
public subroutine of_get_array_from_column (powerobject ao_datasource, string as_columnname, ref string as_string[])
public function string of_get_array_from_column (powerobject ao_datasource, string as_columnname, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[])
public function string of_get_array_from_column (powerobject ao_datasource, string as_columnname, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[], boolean ab_sorted)
public function string of_get_column (powerobject ao_datasource, string as_columnheadername)
public function string of_get_column_header (powerobject ao_datasource, long al_columnnumber)
public function string of_get_column_header (powerobject ao_datasource, string as_columnname)
public function string of_get_column_headername (powerobject ao_datasource, string as_columnname)
public function long of_get_columnid (powerobject ao_datasource, string as_columnname)
public function string of_get_columnname (powerobject ao_datasource, long al_columnnumber)
public function string of_get_columntype (powerobject ao_datasource, long al_columnnumber)
public function string of_get_columntype (powerobject ao_datasource, string as_columnname)
public function string of_get_editstyle (powerobject ao_datasource, long al_columnnumber)
public function string of_get_editstyle (powerobject ao_datasource, string as_columnname)
public function string of_get_expression (ref powerobject ao_powerobject, string as_computedfieldname)
public function string of_get_expression (ref powerobject ao_powerobject, string as_computedfieldname, boolean ab_isstringexpression)
public subroutine of_get_groups (powerobject ao_datasource, ref string as_groups[])
public function boolean of_get_invisible_objects (powerobject ao_datasource, ref string as_object[])
public function resultset of_get_resultset (powerobject ao_datasource)
public function string of_get_sort (powerobject ao_datasource)
public subroutine of_get_sort (powerobject ao_datasource, string as_sortstring, ref string as_column[], ref string as_ascendingdescending[], boolean ab_removeexpressions)
public function string of_getitem (powerobject ao_datasource, long al_row, long al_columnnumber)
public function string of_getitem (powerobject ao_datasource, long al_row, string as_columnname)
public subroutine of_insert_rows (powerobject ao_datasource, long al_numberofrows)
public function boolean of_iscolumn (powerobject ao_datasource, string as_columnname)
public function boolean of_iscomputedfield (powerobject ao_datasource, string as_columnname)
public function boolean of_iscomputedfieldvalid (powerobject ao_datasource, string as_columnname)
public function boolean of_isstatictext (powerobject ao_datasource, string as_columnname)
public function boolean of_isupdateable (powerobject ao_datasource)
public function string of_set_expression (ref powerobject ao_powerobject, string as_computedfieldname, string as_expression)
public function string of_set_expression (ref powerobject ao_powerobject, string as_computedfieldname, string as_expression, boolean ab_isstringexpression)
public function boolean of_setitem (ref powerobject ao_datasource, long al_row, string as_column, any as_data)
public function boolean of_share_dropdowndatawindow (ref powerobject ao_source, string as_sourcecolumn, ref powerobject ao_destination, string as_destinationcolumn)
public function string of_get_filter (powerobject ao_datasource)
public subroutine of_get_array_from_column (powerobject ao_datasource, long al_columnnumber, ref string as_string[])
public function string of_get_array_from_column (powerobject ao_datasource, long al_columnnumber, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[])
public function string of_insert_column_from_array (powerobject ao_datasource, string as_columnname, string as_stringdata[], double adble_numberdata[], datetime adt_datetimedata[])
public function string of_get_lookupdisplay (powerobject ao_datasource, long al_row, string as_columnname)
public function boolean of_share_dropdowndatawindows (ref powerobject ao_source, ref powerobject ao_destination)
public function long of_print_no_blank_pages (ref powerobject ao_datasource, powerobject au_dynamic_gui, boolean ab_show_cancel_dialog, boolean ab_fix_transparent_numbers)
public function string of_retrieve (powerobject ao_datasource, string as_arguments, string as_delimiter)
public function boolean of_get_lookupdisplay (powerobject ao_datasource, string as_columnname, ref string as_lookupdisplay[])
public function boolean of_sort_lookupdisplay (powerobject ao_datasource, string as_columnname, boolean ab_ascending)
public function boolean of_get_expression_as_array (powerobject ao_datasource, string as_expression, ref string as_string[], ref datetime adt_datetime[], ref double adble_double[])
public function boolean of_sort (powerobject ao_datasource, string as_sortstring)
public function boolean of_get_expression_as_array (powerobject ao_datasource, string as_expression, ref string as_string[], ref datetime adt_datetime[], ref double adble_double[], dwbuffer aenum_dwbuffer)
public function string of_apply_syntax (powerobject ao_datasource, string as_syntax)
public function boolean of_column_exists (ref powerobject ao_powerobject, string as_columnobjectname)
public function boolean of_copy_datawindow (ref powerobject ao_source, ref powerobject ao_destination)
public function boolean of_copy_dropdowndatawindow (ref powerobject ao_source, string as_sourcecolumn, ref powerobject ao_destination, string as_destinationcolumn)
public function boolean of_copy_dropdowndatawindows (ref powerobject ao_source, ref powerobject ao_destination)
public function string of_copy_property (ref powerobject ao_source, ref powerobject ao_destination, string as_object, string as_property)
public function string of_create_report_syntax (string as_sql, string as_title, transaction axctn_transaction)
public function long of_find_row (ref powerobject ao_datasource, string as_column, string as_value, long al_startrow, long al_endrow)
public function adoresultset of_get_adoresultset (powerobject ao_datasource)
public subroutine of_get_columns (powerobject ao_datasource, ref string as_columnname[], ref string as_headername[], ref string as_headertext[], ref string as_columntype[])
public subroutine of_get_columns_all (powerobject ao_datasource, ref string as_columnname[], ref string as_headername[], ref string as_headertext[], ref string as_columntype[])
public function boolean of_isvisible (powerobject ao_datasource, string as_objectname)
public subroutine of_apply_expressions (powerobject ao_datasource)
public function boolean of_get_objects (powerobject ao_datasource, string as_objecttype, ref string as_object[], boolean ab_visible_objects_only)
public function boolean of_get_all_object_property (powerobject ao_datasource, string as_property, ref string as_object[], ref string as_value[], boolean ab_visible_objects_only)
public function string of_modify_header_height (powerobject ao_datasource, long al_newheight)
end prototypes

public function boolean of_copy_attributes (powerobject ao_source, string as_sourcecolumn, powerobject ao_destination, string as_destinationcolumn);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_copy_attributes()
//	Arguments:  ao_source 				- Source object
//					as_sourcecolumn		- The source column
//					ao_destination			- The destination object
//					as_destinationcolumn	- The destination column
//	Overview:   This will copy all the attributes of the column from one to another
//	Created by:	Blake Doerr
//	History: 	6/21/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_editstyle_source
String	ls_editstyle_destination
String	ls_values
String	ls_syntax
String 	ls_result
String	ls_result2
String	ls_result3

Long		ll_position
Long		ll_position2

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the objects are not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_source) Or Not IsValid(ao_destination) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the columns are not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Trim(as_sourcecolumn) = '' Or IsNull(as_sourcecolumn) Then Return False
If Trim(as_destinationcolumn) = '' Or IsNull(as_destinationcolumn) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the edit styles of the two columns
//-----------------------------------------------------------------------------------------------------------------------------------
ls_editstyle_source 					= Lower(Trim(ao_source.			Dynamic Describe(as_sourcecolumn + ".Edit.Style")))
ls_editstyle_destination	= Lower(Trim(ao_destination.	Dynamic Describe(as_destinationcolumn + ".Edit.Style")))

//-----------------------------------------------------------------------------------------------------------------------------------
// If they aren't the same edit styles return
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(ls_editstyle_source)) <> Lower(Trim(ls_editstyle_destination)) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Copy the attributes based on the type of column
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(ls_editstyle_source))
	Case 'dddw'
		//----------------------------------------------------------------------------------------------------------------------------------
		// Modify all the properties of the dropdowndatawindow column to match the original datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ao_destination.Dynamic Modify(as_destinationcolumn + '.dddw.name=' 				+ ao_source.Dynamic Describe('#' + as_sourcecolumn + ".dddw.name"))
		ao_destination.Dynamic Modify(as_destinationcolumn + '.dddw.displaycolumn=' 	+ ao_source.Dynamic Describe('#' + as_sourcecolumn + ".dddw.displaycolumn"))
		ao_destination.Dynamic Modify(as_destinationcolumn + '.dddw.datacolumn=' 		+ ao_source.Dynamic Describe('#' + as_sourcecolumn + ".dddw.datacolumn"))
		ao_destination.Dynamic Modify(as_destinationcolumn + '.dddw.percentwidth=' 	+ ao_source.Dynamic Describe('#' + as_sourcecolumn + ".dddw.percentwidth"))
		ao_destination.Dynamic Modify(as_destinationcolumn + '.dddw.lines=' 				+ ao_source.Dynamic Describe('#' + as_sourcecolumn + ".dddw.lines"))

		//----------------------------------------------------------------------------------------------------------------------------------
		// Copy the dropdown data
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_copy_dropdowndatawindow(ao_source, as_sourcecolumn, ao_destination, as_destinationcolumn)
		
	Case 'editmask'
		//----------------------------------------------------------------------------------------------------------------------------------
		// Modify the editmask to be the same
		//-----------------------------------------------------------------------------------------------------------------------------------
		ao_destination.Dynamic Modify(as_destinationcolumn + '.EditMask.Mask=~'' + ao_source.Dynamic Describe('#' + as_sourcecolumn + ".EditMask.Mask") + '~'')			
		
	Case 'ddlb', 'checkbox'
		//----------------------------------------------------------------------------------------------------------------------------------
		//	Build the values list from each type differently.  When it's a checkbox, we are building a ddlb of possible values
		//-----------------------------------------------------------------------------------------------------------------------------------
		if ls_editstyle_source = 'ddlb' Then
			ls_values = ao_source.Dynamic Describe(as_sourcecolumn + ".Values")
		Else
			//-------------------------------------------------------------------
			// For some reason these describes don't work that's why we have to do the code below
			//-------------------------------------------------------------------
			//ls_result = Describe(is_column_name[ll_index] + ".CheckBox.Off") 
			//ls_result2 = Describe(is_column_name[ll_index] + ".CheckBox.On")

			//-------------------------------------------------------------------
			// Determine the on state
			//-------------------------------------------------------------------
			ls_syntax = ao_source.Dynamic Describe("Datawindow.Syntax")				
			ll_position = Pos(ls_syntax, 'column(name=' + as_sourcecolumn)
			ll_position = Pos(ls_syntax, 'checkbox.on=', ll_position)
			ll_position = ll_position + 13
			ll_position2 = Pos(ls_syntax, '" ', ll_position)
			ls_result = Mid(ls_syntax, ll_position, ll_position2 - ll_position)

			//-------------------------------------------------------------------
			// Determine the off state
			//-------------------------------------------------------------------
			ll_position = Pos(ls_syntax, 'column(name=' + as_sourcecolumn)
			ll_position = Pos(ls_syntax, 'checkbox.off=', ll_position)
			ll_position = ll_position + 14
			ll_position2 = Pos(ls_syntax, '" ', ll_position)
			ls_result2 = Mid(ls_syntax, ll_position, ll_position2 - ll_position)

			//-------------------------------------------------------------------
			// Create the string for the DrowDownListBox
			//-------------------------------------------------------------------
			ls_values = 'Yes' +   '~t' + ls_result +         '/No~t' + ls_result2

			//-------------------------------------------------------------------
			// If there is a Third state
			//-------------------------------------------------------------------
			ll_position = Pos(ls_syntax, 'column(name=' + as_sourcecolumn)
			ll_position = Pos(ls_syntax, 'checkbox.other=', ll_position)
			If ll_position > 0 Then
				ll_position = ll_position + 16
				ll_position2 = Pos(ls_syntax, '" ', ll_position)
				ls_result3 = Mid(ls_syntax, ll_position, ll_position2 - ll_position)
				
				ls_values = ls_values + '/Maybe~t' + ls_result3
			End If
			
		End If
		
		ao_destination.Dynamic Modify(as_destinationcolumn + '.values="' + ls_values + '"')	
		ao_destination.Dynamic Modify(as_destinationcolumn + '.ddlb.required=yes')
		ao_destination.Dynamic Modify(as_destinationcolumn + '.ddlb.limit=0')
		ao_destination.Dynamic Modify(as_destinationcolumn + '.ddlb.allowedit=no')
		ao_destination.Dynamic Modify(as_destinationcolumn + '.ddlb.case=any')
		ao_destination.Dynamic Modify(as_destinationcolumn + '.ddlb.vscrollbar=yes')
//			ao_destination.Dynamic Modify(as_destinationcolumn + '.ddlb.useasborder=yes ')
End Choose
end function

public function string of_translate_expression (powerobject ao_datasource, string as_expression, boolean ab_translate_to_english);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_translate_expression()
//	Arguments:  ao_datasource - The source dataobject
//					as_expression - The expression to translate
//					ab_translate_to_english	- Whether or not to translate the expression to englis
//	Overview:   This will copy the syntax from 
//	Created by:	Blake Doerr
//	History: 	6/26/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_null
String	ls_replace[]
String	ls_column[]
String	ls_header[]
String	ls_headertext[]
String	ls_columntype[]
Long		ll_index
Long		ll_upperbound
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return ls_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns available for the datasource.  Pass parameters differently based on the direction we're going
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_translate_to_english Then
	This.of_get_columns(ao_datasource, ls_column[], ls_header[], ls_headertext[], ls_columntype[])
Else
	This.of_get_columns(ao_datasource, ls_headertext[], ls_header[], ls_column[], ls_columntype[])
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Translate the expression
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_translate_expression(as_expression, ls_column[], ls_headertext[])
end function

public function string of_create_distinct_filter (powerobject ao_datasource, string as_columnname, string as_filter_columnname);String	ls_string[], ls_previous_value = 'asd;lfkj', ls_filter_string = ''
DateTime	ldt_datetime[]
Double	ldble_number[], ldble_previous_value = -3.1415926539
Long		ll_upperbound, ll_index

This.of_get_array_from_column(ao_datasource, as_columnname, ls_string[], ldt_datetime[], ldble_number[], True)

//----------------------------------------------------------------------------------------------------------------------------------
// Get the column type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Left(This.of_get_columntype(ao_datasource, as_columnname), 4))
	Case 'char'
		ll_upperbound = UpperBound(ls_string[])
		
		If ll_upperbound <= 0 Then Return '1 = 2'
		
		For ll_index = 1 To ll_upperbound
			If ls_previous_value <> ls_string[ll_index] Then
				ls_filter_string = ls_filter_string + as_filter_columnname + '="' + ls_string[ll_index] + '" Or '
				ls_previous_value = ls_string[ll_index]
			End If
		Next
		
		ls_filter_string = Left(ls_filter_string, Len(ls_filter_string) - 3)
	Case 'date'
		Return ''
	Case 'numb','deci','long', 'inte'
		ll_upperbound = UpperBound(ldble_number[])
		
		If ll_upperbound <= 0 Then Return '1 = 2'
		
		For ll_index = 1 To ll_upperbound
			If ldble_previous_value <> ldble_number[ll_index] Then
				ls_filter_string = ls_filter_string + as_filter_columnname + '=' + String(ldble_number[ll_index]) + ' Or '
				ldble_previous_value = ldble_number[ll_index]
			End If
		Next
		
		ls_filter_string = Left(ls_filter_string, Len(ls_filter_string) - 3)

End Choose

//-------------------------------------------------------
// Return the filter string
//-------------------------------------------------------
Return ls_filter_string
end function

public function string of_translate_expression (string as_expression, string as_column[], string as_headertext[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_translate_expression()
//	Arguments:  ao_datasource - The source dataobject
//					as_expression - The expression to translate
//					ab_translate_to_english	- Whether or not to translate the expression to englis
//	Overview:   This will copy the syntax from 
//	Created by:	Blake Doerr
//	History: 	6/26/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_upperbound

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the columns with their corresponding header texts.  This replace all will make sure that there isn't an alphanumeric
//		next to the string that it is replacing.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = Min(UpperBound(as_column[]), UpperBound(as_headertext[]))
For ll_index = 1 To ll_upperbound
	as_expression = gn_globals.in_string_functions.of_replace_all (as_expression, as_column[ll_index], as_headertext[ll_index], True, True)
Next


Return as_expression
end function

public function boolean of_value_exists_in_dropdowndatawindow (powerobject ao_datasource, string as_column, string as_value);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_value_exists_in_dropdowndatawindow()
//	Arguments:  ao_datasource 	- The datasource
//					as_column		- the column with the datawindow
//					as_value			- The value to search for
//	Overview:   Check to see if a value is in a dropdown
//	Created by:	Blake Doerr
//	History: 	6/5/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_columnnumber
Long		ll_return
String	ls_name
String	ls_displaycolumnname
String	ls_datacolumnname

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
DatawindowChild ldwc_source

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the datawindow is valid and has rows
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Or IsNull(ao_datasource) Then Return False
If ao_datasource.Dynamic RowCount() <= 0 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the dropdowndatawindow name
//-----------------------------------------------------------------------------------------------------------------------------------
ls_name 				= ao_datasource.Dynamic Describe(as_column + ".dddw.name"			)
If Len(Trim(ls_name)) = 0 Or IsNull(ls_name) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the datacolumn name for the dropdown
//-----------------------------------------------------------------------------------------------------------------------------------
ls_datacolumnname = ao_datasource.Dynamic Describe(as_column +  ".DDDW.DataColumn")
If ls_datacolumnname = '!' Or ls_datacolumnname = 'none' Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get a handle to the DatawindowChild
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = 	ao_datasource.	Dynamic GetChild(as_column, 		ldwc_source)
If ll_return <> 1 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get a handle to the DatawindowChild
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = ldwc_source.Find(ls_datacolumnname + ' = ' + as_value, 1, ldwc_source.RowCount())

//-----------------------------------------------------------------------------------------------------------------------------------
// Return False just in case
//-----------------------------------------------------------------------------------------------------------------------------------
Return ll_return > 0
end function

public function string of_validate_expression (powerobject ao_datasource, string as_expression, string as_datatype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate_expression()
//	Arguments:  ao_datasource 	- The datasource
//					as_expression	- The expression to validate
//					as_datatype		- The datatype
//	Overview:   This will validate that an expression is valid and the correct datatype
//	Created by:	Blake Doerr
//	History: 	6/7/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_return
String	ls_describe
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Change some of the datatypes to handle the variable length ones
//-----------------------------------------------------------------------------------------------------------------------------------
If Left(Lower(Trim(as_datatype)), 4) = 'char' 	Then as_datatype = 'string'
If Left(Lower(Trim(as_datatype)), 3) = 'dec' 	Then as_datatype = 'number'

//-----------------------------------------------------------------------------------------------------------------------------------
// Wrap the expression with the correct statement to validate the
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_datatype))
	Case 	'string'
		as_expression = 'If(' + as_expression + ' = "", 1, 0)'
	Case	'datetime', 'date'
	Case 	'time'
	Case	'number', 'long', 'real', 'int', 'integer'
		as_expression = 'If(' + as_expression + ' > 0, 1, 0)'
	Case	'boolean'
		as_expression = 'If(' + as_expression + ', 1, 0)'
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace all double quotes with ~" in the expression
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(as_expression,'"','~~"')

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the expression to describe
//-----------------------------------------------------------------------------------------------------------------------------------
ls_describe = "Evaluate(~"" + as_expression + "~",1)"

//-----------------------------------------------------------------------------------------------------------------------------------
// Evaluate the expression on the original datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ao_datasource.Dynamic Describe(ls_describe)

Return ls_return
end function

public function string of_validate_expression (powerobject ao_datasource, string as_expression);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate_expression()
//	Arguments:  ao_datasource 	- The datasource
//					as_expression	- The expression to validate
//	Overview:   This will validate that an expression is valid and the correct datatype
//	Created by:	Blake Doerr
//	History: 	6/7/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_validate_expression(ao_datasource, as_expression, '')
end function

public function long of_fix_transparent_color_number (ref string as_syntax);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_fix_transparent_color_number()
//	Arguments:  as_syntax 	- The syntax to replace
//	Overview:   This will replace the bad transparent numbers with the good
//	Created by:	Blake Doerr
//	History: 	5/15/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the bad transparent number with the good
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(as_syntax, '536870912', '553648127')

Return 1
end function

public subroutine of_translate_to_english (ref string as_names[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_translate_to_english()
//	Arguments:  
//	Overview:   This will space out names that are crammed together.
//	Created by:	Blake Doerr
//	History: 	7/25/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Long	ll_index
Long	ll_index2

For ll_index = 1 To UpperBound(as_names[])
	For ll_index2 = 2 To Len(as_names[ll_index]) - 1
		If Asc(Mid(as_names[ll_index], ll_index2, 1)) >= Asc('A') And Asc(Mid(as_names[ll_index], ll_index2, 1)) <= Asc('Z') Then
			If Mid(as_names[ll_index], ll_index2 - 1, 1) <> ' ' And Mid(as_names[ll_index], ll_index2 - 1, 1) <> '-' And Mid(as_names[ll_index], ll_index2 - 1, 1) <> '/' And Asc(Mid(as_names[ll_index], ll_index2 + 1, 1)) >= Asc('a') And Asc(Mid(as_names[ll_index], ll_index2 + 1, 1)) <= Asc('z') Then
				as_names[ll_index] = Left(as_names[ll_index], ll_index2 - 1) + ' ' + Mid(as_names[ll_index], ll_index2)
			End If
		End If
	Next
Next
end subroutine

public function string of_translate_to_english (string as_name);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_translate_to_english()
//	Arguments:  
//	Overview:   This will space out names that are crammed together.
//	Created by:	Blake Doerr
//	History: 	7/25/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_name[]

ls_name = {as_name}

This.of_translate_to_english(ls_name[])

Return ls_name[1]


end function

public function string of_create_initcolumn (ref powerobject ao_powerobject, string as_computedfieldname, string as_expression);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_create_init_column()
//	Arguments:	ao_powerobject - This is a datawindow/datastore
//					as_computedfieldname - This is the name for the computed field
//					as_expression - The new expression for the computed field.
//	Overview:   This will pull the expression off a computed field
//	Created by:	Blake Doerr
//	History: 	12.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_null, ls_modify
Datawindow ldw_datawindow
Datastore lds_datastore
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ls_null)
If Not IsValid(ao_powerobject) Or IsNull(ao_powerobject) Then Return ls_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the computed field if it's not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_IsComputedField(ao_powerobject, as_computedfieldname) And Not This.of_IsComputedFieldValid(ao_powerobject, as_computedfieldname) Then
	ao_powerobject.Dynamic Modify('Destroy ' + as_computedfieldname)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if column exists.
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_IsComputedField(ao_powerobject, as_computedfieldname) Then Return ls_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace all the " with ~"
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(as_expression, '"', '~~"')

//-----------------------------------------------------------------------------------------------------------------------------------
// Else, create the column with the expression.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = ao_powerobject.Dynamic Modify('create compute(band=Detail color="0" alignment="0" border="0"  x="1" y="1" height="0" width="0"' + &
' format="[general]" name=' + as_computedfieldname + ' expression="' + as_expression + '" visible="0" font.face="Tahoma" font.height="-8" font.weight="400" font.family="2" font.pitch="2"' + &
' font.charset="0" background.mode="2" )')

Return ls_modify


end function

public function string of_get_array_from_column (powerobject ao_datasource, long al_columnnumber, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[], boolean ab_sorted);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_array_from_column()
//	Arguments:  ao_datasource - The datasource
//					al_columnnumber - The column number
//					as_string[] - A string array by reference
//					adt_datetime[] - 
//	Overview:   This will return an array from a column in a datasource
//	Created by:	Blake Doerr
//	History: 	1/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_get_array_from_column(ao_datasource, This.of_get_columnname(ao_datasource, al_columnnumber), as_string[], adt_datetime[], adble_number[], ab_sorted)

end function

public subroutine of_get_array_from_column (powerobject ao_datasource, string as_columnname, ref string as_string[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_array_from_column()
//	Arguments:  ao_datasource - The datasource
//					ll_columnnumber - The column number
//					as_string[] - A string array by reference
//					adt_datetime[] - 
//	Overview:   This will return a string array of the column
//	Created by:	Blake Doerr
//	History: 	1/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_string_array[], ls_datatype
Double ldble_double_array[]
DateTime ldt_datetime_array[]
Long ll_index
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the array into its proper array type
//-----------------------------------------------------------------------------------------------------------------------------------
ls_datatype = This.of_get_array_from_column(ao_datasource, as_columnname, ls_string_array[], ldt_datetime_array[], ldble_double_array[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the array is a string
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ls_datatype
	Case 'number'
		For ll_index = UpperBound(ldble_double_array) To 1 Step -1
			as_string[ll_index] = String(ldble_double_array[ll_index])
		Next
	Case 'datetime'
		For ll_index = UpperBound(ldt_datetime_array) To 1 Step -1
			as_string[ll_index] = gn_globals.in_string_functions.of_convert_datetime_to_string(ldt_datetime_array[ll_index])
		Next
	Case 'string'
		as_string[] = ls_string_array[]
End Choose

end subroutine

public function string of_get_array_from_column (powerobject ao_datasource, string as_columnname, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_array_from_column()
//	Arguments:  ao_datasource - The datasource
//					ll_columnnumber - The column number
//					as_string[] - A string array by reference
//					adt_datetime[] - 
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	1/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Return This.of_get_array_from_column(ao_datasource, as_columnname, as_string[], adt_datetime[], adble_number[], False)
end function

public function string of_get_array_from_column (powerobject ao_datasource, string as_columnname, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[], boolean ab_sorted);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_array_from_column()
//	Arguments:  ao_datasource - The datasource
//					ll_columnnumber - The column number
//					as_string[] - A string array by reference
//					adt_datetime[] - 
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	1/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_rowcount, ll_index, ll_columnnumber
String ls_error,ls_syntax
Datastore lds_dummy_datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string 	ls_column_header
String	ls_columntype
object lenum_objectname
Datawindow ldw_datawindow
Datastore lds_datastore
DatawindowChild ldwc_datawindowchild
Boolean lb_destroy_datastore = False

//----------------------------------------------------------------------------------------------------------------------------------
// Get the column type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Left(This.of_get_columntype(ao_datasource, as_columnname), 4))
	Case 'char'
		ls_columntype = 'string'		
	Case 'date'
		ls_columntype = 'datetime'					
	Case 'numb','deci','long', 'inte'
		ls_columntype = 'number'
End Choose

If ao_datasource.Dynamic RowCount() <= 0 Then Return ls_columntype

//----------------------------------------------------------------------------------------------------------------------------------
// Get the column type based on the type of object passed in
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_IsComputedField(ao_datasource, as_columnname) Then
	If Not This.of_IsComputedFieldValid(ao_datasource, as_columnname) Then Return 'Error'
	
	If This.of_get_expression_as_array(ao_datasource, as_columnname,as_string[], adt_datetime[], adble_number[]) Then
		Return ls_columntype
	Else
		Return 'Error'
	End If
End If

ll_columnnumber = This.of_get_columnid(ao_datasource, as_columnname)
lenum_objectname = ao_datasource.TypeOf()

Choose Case lenum_objectname
	Case Datawindow!
		ldw_datawindow = ao_datasource
		ll_rowcount = ldw_datawindow.RowCount()
	Case Datastore!
		lds_datastore = ao_datasource
		ll_rowcount = lds_datastore.RowCount()
	Case DatawindowChild!
		ldwc_datawindowchild = ao_datasource
		lb_destroy_datastore = True
		lenum_objectname = Datastore!
		lds_datastore = Create Datastore
		lds_datastore.Create(ldwc_datawindowchild.Describe("Datawindow.Syntax"), ls_error)

		ldwc_datawindowchild.RowsCopy(1, ldwc_datawindowchild.RowCount(), Primary!, lds_datastore, 1, Primary!)
		ll_rowcount = lds_datastore.RowCount()
End Choose


//----------------------------------------------------------------------------------------------------------------------------------
// Create the dummy datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_dummy_datastore = Create Datastore

//----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore for use in creating the virtual column list
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = 'release 9;~r~ndatawindow(units=0 timer_interval=0 color=16777215 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )~r~nheader(height=69 color="536870912" )~r~nsummary(height=1 color="536870912" )~r~nfooter(height=69 color="536870912" )~r~ndetail(height=81 color="536870912" )~r~ntable('

//----------------------------------------------------------------------------------------------------------------------------------
// create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ls_syntax + 	' column=(type=char(255) updatewhereclause=no name=stringcolumn dbname="stringcolumn " ) ~r~n'
ls_syntax = ls_syntax + 	' column=(type=datetime updatewhereclause=no name=datetimecolumn dbname="datetimecolumn " ) ~r~n'
ls_syntax = ls_syntax + 	' column=(type=number updatewhereclause=no name=numbercolumn dbname="numbercolumn " ) ~r~n'
lds_dummy_datastore.create(ls_syntax + ')', ls_error)

//----------------------------------------------------------------------------------------------------------------------------------
// If there's an error, return it
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_error) > 0 Then
	Return 'Error:  ' + ls_error
	Destroy lds_dummy_datastore
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Insert the number of rows that are necessary
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_insert_rows(lds_dummy_datastore, ll_rowcount)

//For ll_index = 1 To ll_rowcount
//	lds_dummy_datastore.InsertRow(0)
//Next

//-------------------------------------------------------
// Get the data in its proper structure
//-------------------------------------------------------
Choose Case ls_columntype
	Case 'string'
		//-------------------------------------------------------
		// Pull the column into the dummy datastore, the pull the
		//   named column into the structure's array.  We have
		//   to do this because you can't take a numbered column
		//   directly to an array only a named column
		//-------------------------------------------------------
		Choose Case lenum_objectname
			Case Datawindow!
				lds_dummy_datastore.object.data[1, 1, ll_rowcount, 1] = ldw_datawindow.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]			
			Case Datastore!		
				lds_dummy_datastore.object.data[1, 1, ll_rowcount, 1] = lds_datastore.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]			
		End Choose
	
		If ab_sorted Then
			lds_dummy_datastore.SetSort('#1')
			lds_dummy_datastore.Sort()
		End If

		as_string[] 	= lds_dummy_datastore.object.stringcolumn.primary
	Case 'datetime'
		Choose Case lenum_objectname
			Case Datawindow!
				lds_dummy_datastore.object.data[1, 2, ll_rowcount, 2] = ldw_datawindow.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]
			Case Datastore!		
				lds_dummy_datastore.object.data[1, 2, ll_rowcount, 2] = lds_datastore.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]
		End Choose
		
		If ab_sorted Then
			lds_dummy_datastore.SetSort('#2')
			lds_dummy_datastore.Sort()
		End If

		adt_datetime[] = lds_dummy_datastore.object.datetimecolumn.primary
	Case 'number'
		Choose Case lenum_objectname
			Case Datawindow!
				lds_dummy_datastore.object.data[1, 3, ll_rowcount, 3] = ldw_datawindow.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]
			Case Datastore!		
				lds_dummy_datastore.object.data[1, 3, ll_rowcount, 3] = lds_datastore.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]
		End Choose

		If ab_sorted Then
			lds_dummy_datastore.SetSort('#3')
			lds_dummy_datastore.Sort()
		End If
		
		adble_number[] = lds_dummy_datastore.object.numbercolumn.primary
End Choose

If lb_destroy_datastore Then
	Destroy lds_datastore
End If

Destroy lds_dummy_datastore
Return ls_columntype
end function

public function string of_get_column (powerobject ao_datasource, string as_columnheadername);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 as_columnheadername - The column name
// Overview:    Get the header text for the column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string 	ls_column_header
String	ls_Null
SetNull(ls_Null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the data isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return ls_Null
If Len(Trim(as_columnheadername)) <= 0 Or IsNull(as_columnheadername) Then Return ls_Null
If Pos(as_columnheadername, '_') <=0 Then Return ls_Null

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove the suffix, whatever it is, it just needs an _ at the end
//-----------------------------------------------------------------------------------------------------------------------------------
as_columnheadername = Reverse(as_columnheadername)
as_columnheadername = Right(as_columnheadername, Len(as_columnheadername) - Pos(as_columnheadername, '_'))
as_columnheadername = Reverse(as_columnheadername)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the column if it's a computed field or column
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_IsColumn(ao_datasource, as_columnheadername) Then Return as_columnheadername
If This.of_IsComputedField(ao_datasource, as_columnheadername) Then Return as_columnheadername

//-----------------------------------------------------------------------------------------------------------------------------------
// Return null if we don't find anything
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_Null

end function

public function string of_get_column_header (powerobject ao_datasource, long al_columnnumber);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column_header()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 al_columnnumber - The column number
// Overview:    Get the header text for the column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_get_column_header(ao_datasource, This.of_get_columnname(ao_datasource, al_columnnumber))
end function

public function string of_get_column_header (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column_header()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 as_columnname - The column name
// Overview:    Get the header text for the column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_column_header

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column header
//-----------------------------------------------------------------------------------------------------------------------------------
ls_column_header	= ao_datasource.Dynamic Describe(as_columnname + '_srt.Text')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column header again
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_column_header = '!' or ls_column_header = '?' Then
	ls_column_header	= ao_datasource.Dynamic Describe(as_columnname + '_t.Text')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_column_header = '!' or ls_column_header = '?' Then
	ls_column_header = as_columnname
End If	

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_column_header
end function

public function string of_get_column_headername (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column_headername()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 as_columnname - The column name
// Overview:    Get the header text for the column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_column_header

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column header
//-----------------------------------------------------------------------------------------------------------------------------------
ls_column_header	= ao_datasource.Dynamic Describe(as_columnname + '_srt.Text')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column header again
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_column_header = '!' or ls_column_header = '?' Then
	ls_column_header	= ao_datasource.Dynamic Describe(as_columnname + '_t.Text')
Else
	Return as_columnname + '_srt'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_column_header = '!' or ls_column_header = '?' Then
	ls_column_header = as_columnname
Else
	Return as_columnname + '_t'
End If	

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function long of_get_columnid (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_columnid()
// Arguments:   as_columnname - The name of the column
// Overview:    Get the number of a named column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return Long(ao_datasource.Dynamic Describe(as_columnname + ".ID"))
end function

public function string of_get_columnname (powerobject ao_datasource, long al_columnnumber);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_columnname()
// Arguments:   al_columnnumber - The number of the column
// Overview:    Get the name of a numbered column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ao_datasource.Dynamic Describe('#' + String(al_columnnumber) + ".Name")
end function

public function string of_get_columntype (powerobject ao_datasource, long al_columnnumber);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_columntype()
// Arguments:   ao_datasource - The datasource
//					 al_columnnumber - The column number
// Overview:    Get the type of a numbered column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_get_columntype(ao_datasource, This.of_get_columnname(ao_datasource, al_columnnumber))
end function

public function string of_get_columntype (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_columntype()
// Arguments:   as_columnname - The name of the column
// Overview:    Get the type of a named column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ao_datasource.Dynamic Describe(as_columnname + ".ColType")
end function

public function string of_get_editstyle (powerobject ao_datasource, long al_columnnumber);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_editstyle()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 al_columnnumber - The column number
// Overview:    Get the edit style for the numbered column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_get_editstyle(ao_datasource, This.of_get_columnname(ao_datasource, al_columnnumber))

end function

public function string of_get_editstyle (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_editstyle()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 as_columnname - The column name
// Overview:    Get the edit style for the column
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return Lower(Trim(ao_datasource.Dynamic Describe(as_columnname + ".Edit.Style")))
end function

public function string of_get_expression (ref powerobject ao_powerobject, string as_computedfieldname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_expression()
//	Arguments:	ao_powerobject - This is a datawindow/datastore
//					as_computedfieldname - This is the name of a computed field
//	Overview:   This will pull the expression off a computed field
//	Created by:	Blake Doerr
//	History: 	12.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_get_expression(ao_powerobject, as_computedfieldname, True)
end function

public function string of_get_expression (ref powerobject ao_powerobject, string as_computedfieldname, boolean ab_isstringexpression);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_expression()
//	Arguments:	ao_powerobject - This is a datawindow/datastore
//					as_computedfieldname - This is the name of a computed field
//	Overview:   This will pull the expression off a computed field
//	Created by:	Blake Doerr
//	History: 	12.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_return, ls_null, ls_lookupdisplay, ls_expression

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ls_null)
If Not IsValid(ao_powerobject) Or IsNull(ao_powerobject) Then Return ls_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Find out the column type of the initialization string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ao_powerobject.Dynamic describe(as_computedfieldname + ".coltype")

//-----------------------------------------------------------------------------------------------------------------------------------
// Try to get the expression from the computed field
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = ao_powerobject.Dynamic describe(as_computedfieldname + ".expression")

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the expression is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_expression = '!' Or ls_expression = '?' Or ls_expression = '' then
	return ls_null
End If

/*
//-----------------------------------------------------------------------------------------------------------------------------------
// Try to evaluate the computed field to see if there is an expression if ls_expression is not valid.
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_expression = '!' Or ls_expression = '?' or ls_expression = '' Then
	ls_expression = ldw_datawindow.Describe("evaluate('lookupdisplay(" + as_computedfieldname + ")', 1)")
End If
*/

//-----------------------------------------------------------------------------------------------------------------------------------
// If the computed field does not exist, or is the wrong datatype, return only if it's a string expression
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_isstringexpression Then
	If Lower(Left(ls_return, 4)) <> 'char' then Return ls_null
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// When the expression is described, there will be quotes that we need to remove
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_expression = trim(ls_expression)
	If Left(ls_expression, 1) = "'" And Right(ls_expression, 1) = "'" Then
		ls_expression = mid(ls_expression, 2, len(ls_expression) - 2)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the expression
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_expression
end function

public subroutine of_get_groups (powerobject ao_datasource, ref string as_groups[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_groups()
//	Arguments:  ao_datasource - the datasource
//					as_groups[] - the groups by reference
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	10/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
Long		ll_index
Long		ll_position
Long		ll_position2
String	ls_group_by
String	ls_syntax
If Not IsValid(ao_datasource) Then Return

ls_syntax = ao_datasource.Dynamic Describe("Datawindow.Syntax")

For ll_index = 1 To 100
	ll_position = Pos(ls_syntax, 'group(level=' + String(ll_index))
	If ll_position <= 0 Then Exit
	
	ll_position = Pos(ls_syntax, 'by=(', ll_position) + 5
	ll_position2 = Pos(ls_syntax, '") sort="', ll_position)
	If ll_position2 <= 0 Then
		ll_position2 = Pos(ls_syntax, "header.", ll_position) - 4
		If ll_position2 <= 0 Then
			ll_position2 = Pos(ls_syntax, ")", ll_position) - 2
		End If
	End If
		
	If ll_position <= 5 Then Continue
	If ll_position <= 0 Then Continue
	
	ls_group_by = Trim(Mid(ls_syntax, ll_position, ll_position2 - ll_position - 1))
	//ln_string_functions.of_replace_all(ls_group_by, '"', '')
	//ln_string_functions.of_replace_all(ls_group_by, '~'', '')
	as_groups[ll_index] = ls_group_by
	
Next

//ls_syntax_addition = 'group(level=1 header.height=' + String(il_headerheight) + ' trailer.height=0 by=(' + ls_group_by + ') sort="" header.color="78682240" trailer.color="536870912" )~r~n'

end subroutine

public function boolean of_get_invisible_objects (powerobject ao_datasource, ref string as_object[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_invisible_objects()
//	Arguments:  ao_datasource 				- The source dataobject
//					as_object[]					- The Objects by reference
//	Overview:   This will get all the objects that are definitely invisible, not ones that may evaluate to invisible.
//	Created by:	Blake Doerr
//	History: 	2/28/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_upperbound
Long		ll_index
String	ls_objects
String	ls_object[]
String	ls_visible_describes[]
String	ls_describe

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the array passed by reference is empty
//-----------------------------------------------------------------------------------------------------------------------------------
as_object[] = ls_object[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the objects from the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_objects = ao_datasource.Dynamic Describe("Datawindow.Objects") + '~t'

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the objects into an array
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(Left(ls_objects, Len(ls_objects) - 1), "~t", ls_object[])	

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the tabs with .Visible so we can describe all the types in batch
//-----------------------------------------------------------------------------------------------------------------------------------
ls_describe	= ls_objects
gn_globals.in_string_functions.of_replace_all(ls_describe, '~t', '.Visible~t')
ls_describe = Lower(ao_datasource.Dynamic Describe(Left(ls_describe, Len(ls_describe) - 1)))

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the objects and the types into parallel arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_describe, "~n", ls_visible_describes[])

ll_upperbound = Min(UpperBound(ls_object[]), UpperBound(ls_visible_describes[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the objects and exclude or include certain types in the rebuilt object string
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If ls_visible_describes[ll_index] = '0' Or Mid(ls_visible_describes[ll_index], 2, 2) = '~t0' Then
	Else
		Continue
	End If
	
	as_object[UpperBound(as_object[]) + 1] = ls_object[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function resultset of_get_resultset (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_resultset()
//	Arguments:  ao_datasource 	- The datawindow/datastore/datawindowchild
//	Overview:   This will return a ResultSet from a datasource
//	Created by:	Blake Doerr
//	History: 	4/25/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


ResultSet lrs_resultset

// Generate a result set from an existing DataSource
ao_datasource.Dynamic GenerateResultSet(lrs_resultset)

Return lrs_resultset
end function

public function string of_get_sort (powerobject ao_datasource);Return Trim(ao_datasource.Dynamic Describe("Datawindow.Table.Sort"))
end function

public subroutine of_get_sort (powerobject ao_datasource, string as_sortstring, ref string as_column[], ref string as_ascendingdescending[], boolean ab_removeexpressions);//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index

as_sortstring = Trim(as_sortstring)

gn_globals.in_string_functions.of_replace_all(as_sortstring, ' A,', ' A||@@##')
gn_globals.in_string_functions.of_replace_all(as_sortstring, ' D,', ' D||@@##')

//----------------------------------------------------------------------------------------------------------------------------------
// Parse the string into the array
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_sortstring, '||@@##', as_column[])

//----------------------------------------------------------------------------------------------------------------------------------
// Create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(as_column[])
	//----------------------------------------------------------------------------------------------------------------------------------
	// Trim the column name a pull the ascending/descending off the string
	//-----------------------------------------------------------------------------------------------------------------------------------
	as_column[ll_index] = Trim(as_column[ll_index])
	Choose Case Right(Lower(as_column[ll_index]), 2)
		Case '~td', ' d'
			as_ascendingdescending[ll_index] = ' D'
			as_column[ll_index] = Trim(Left(as_column[ll_index], Len(as_column[ll_index]) - 2))
		Case '~ta', ' a'
			as_ascendingdescending[ll_index] = ''
			as_column[ll_index] = Trim(Left(as_column[ll_index], Len(as_column[ll_index]) - 2))
		Case Else
			as_ascendingdescending[ll_index] = ''
	End Choose
	
	If ab_removeexpressions Then
		If Lower(Left(Trim(as_column[ll_index]), Len('lookupdisplay'))) = 'lookupdisplay' And Right(Trim(as_column[ll_index]), 1) = ')' Then
			as_column[ll_index] = Trim(as_column[ll_index])
			as_column[ll_index] = Mid(as_column[ll_index], Pos(as_column[ll_index], 'lookupdisplay') + Len('lookupdisplay') + 1, 10000)
			as_column[ll_index] = Trim(as_column[ll_index])
			as_column[ll_index] = Right(as_column[ll_index], Len(as_column[ll_index]) - 1)
			as_column[ll_index] = Left(as_column[ll_index], Len(as_column[ll_index]) - 1)
		End If
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		// Try to clean all expressions out of the string
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		Do While Pos(as_column[ll_index], '(') > 0
//			as_column[ll_index] = Trim(Right(as_column[ll_index], Len(as_column[ll_index]) - Pos(as_column[ll_index], '(')))
//		Loop
//	
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		// Try to clean all expressions out of the string
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		Do While Pos(as_column[ll_index], ')') > 0
//			as_column[ll_index] = Trim(Left(as_column[ll_index], Pos(as_column[ll_index], ')') - 1))
//		Loop
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we have a numbered column, turn it into a column name
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Left(as_column[ll_index], 1) = '#' Then 
		as_column[ll_index] = This.of_get_columnname(ao_datasource, Long(Mid(as_column[ll_index], 2, 100)))
	End If
Next

end subroutine

public function string of_getitem (powerobject ao_datasource, long al_row, long al_columnnumber);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_getitem()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 al_row - The row number
//					 al_columnnumber - The column name
// Overview:    Do a getitem no matter what column type
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_getitem(ao_datasource, al_row, This.of_get_columnname(ao_datasource, al_columnnumber))
end function

public function string of_getitem (powerobject ao_datasource, long al_row, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_getitem()
// Arguments:   ao_datasource - The datasource (datawindow or datastore)
//					 al_row - The row number
//					 as_columnname - The column name
// Overview:    Do a getitem no matter what column type
// Created by:  Blake Doerr
// History:     01.04.00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_type, ls_value

//----------------------------------------------------------------------------------------------------------------------------------
// Get the column type based on the type of object passed in
//-----------------------------------------------------------------------------------------------------------------------------------
ls_type = ao_datasource.Dynamic Describe(as_columnname+".Coltype")		
if isnull(al_row) or al_row < 1 or al_row > ao_datasource.Dynamic rowcount() then return ''		

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
	Case 'numb','deci','long'
		ls_value = string(ao_datasource.Dynamic getitemnumber(al_row,as_columnname))
	Case 'date'
		Choose Case Lower(ls_type)
			Case 'date'
				ls_value = gn_globals.in_string_functions.of_convert_date_to_string(ao_datasource.Dynamic getitemdate(al_row, as_columnname))				
			Case 'datetime'
				ls_value = gn_globals.in_string_functions.of_convert_datetime_to_string(ao_datasource.Dynamic getitemdatetime(al_row, as_columnname))
		End Choose
	Case 'char'
		ls_value = ao_datasource.Dynamic getitemstring(al_row,as_columnname)
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// If it is null, return an empty string
//-----------------------------------------------------------------------------------------------------------------------------------
if isnull(ls_value) then ls_value = ''

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
return ls_value
end function

public subroutine of_insert_rows (powerobject ao_datasource, long al_numberofrows);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_insert_rows()
//	Arguments:  ao_datasource - 
//					al_numberofrows - 
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	7/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_begin = 1, ll_columncount, ll_index
String ls_rowimport, ls_importstring
long	l_row
long	l_rows

//-----------------------------------------------------------------------------------------------------------------------------------
// Case for the number of rows
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case al_numberofrows
	Case 0
		Return
	Case Is >= 100
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the number of columns
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_columncount = Long(ao_datasource.Dynamic Describe("Datawindow.Column.Count"))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Build the import string for one row
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To ll_columncount - 1
			ls_rowimport = ls_rowimport + '~t'
		Next

		ls_rowimport = ls_rowimport + '~r~n'

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Build the import string of 100 rows
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To 100
			ls_importstring = ls_importstring + ls_rowimport
		Next

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Import 100 rows at a time
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To (al_numberofrows / 100)
			ao_datasource.Dynamic ImportString(ls_importstring)
		Next

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine the new begin
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_begin = ao_datasource.Dynamic RowCount() + 1
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Fill in the rest of the rows
//-----------------------------------------------------------------------------------------------------------------------------------
For l_row = ll_begin To al_numberofrows
	ao_datasource.Dynamic insertrow(0)
Next

end subroutine

public function boolean of_iscolumn (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_iscolumn()
//	Arguments:  ao_powerobject, as_columnname
//	Overview:   This will determine if a named column is actually a column (not computed field)
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Or IsNull(ao_datasource) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Check the ID property for the proposed object name.  If it exists, then a number will be returned.
//-----------------------------------------------------------------------------------------------------------------------------------
Return IsNumber(ao_datasource.Dynamic Describe(as_columnname + '.ID'))

end function

public function boolean of_iscomputedfield (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_iscomputedfield()
//	Arguments:  ao_powerobject, as_columnname
//	Overview:   This will determine if a named object is actually a computed field
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_describe

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Or IsNull(ao_datasource) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return whether or not the type is compute
//-----------------------------------------------------------------------------------------------------------------------------------
Return Lower(Trim(ao_datasource.Dynamic Describe(as_columnname + '.Type'))) = 'compute'
end function

public function boolean of_iscomputedfieldvalid (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_iscomputedfieldvalid()
//	Arguments:  ao_powerobject, as_columnname
//	Overview:   This will determine if a named object is actually a computed field
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_describe

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Or IsNull(ao_datasource) Then Return False

ls_describe = ao_datasource.Dynamic Describe(as_columnname + '.Expression')

Return ls_describe <> '!' And ls_describe <> '?'
end function

public function boolean of_isstatictext (powerobject ao_datasource, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_IsStaticText()
//	Arguments:  ao_powerobject, as_columnname
//	Overview:   This will determine if a named object is a text
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Or IsNull(ao_datasource) Then Return False

Return Trim(Lower(ao_datasource.Dynamic Describe(Trim(as_columnname + '.Type')))) = 'text'
end function

public function boolean of_isupdateable (powerobject ao_datasource);Return Len(Trim(ao_datasource.Dynamic Describe("DataWindow.Table.UpdateTable"))) > 0
end function

public function string of_set_expression (ref powerobject ao_powerobject, string as_computedfieldname, string as_expression);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_expression()
//	Arguments:	ao_powerobject - This is a datawindow/datastore
//					as_computedfieldname - This is the name of a computed field
//					as_expression - The new expression for the computed field.
//	Overview:   This will pull the expression off a computed field
//	Created by:	Blake Doerr
//	History: 	12.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_set_expression(ao_powerobject, as_computedfieldname, as_expression, True)
end function

public function string of_set_expression (ref powerobject ao_powerobject, string as_computedfieldname, string as_expression, boolean ab_isstringexpression);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_expression()
//	Arguments:	ao_powerobject - This is a datawindow/datastore
//					as_computedfieldname - This is the name of a computed field
//					as_expression - The new expression for the computed field.
//					ab_isstringexpression	- Whether or not it's a string
//	Overview:   This will pull the expression off a computed field
//	Created by:	Blake Doerr
//	History: 	12.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_return, ls_null, ls_modify
boolean lb_exists
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ls_null)
If Not IsValid(ao_powerobject) Or IsNull(ao_powerobject) Then Return ls_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Surround the expression in quotes.
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_isstringexpression Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace all the ' with ~'
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_replace_all(as_expression, "'", "~~'")
	
	as_expression = "'" + as_expression + "'"
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Find out if the column exists.
//-----------------------------------------------------------------------------------------------------------------------------------
lb_exists = This.of_IsComputedField(ao_powerobject, as_computedfieldname)

If lb_exists Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace all the " with ~"
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_replace_all(as_expression, '"', '~~"')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Try and modify the expression
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_modify = ao_powerobject.Dynamic Modify(as_computedfieldname + '.expression="' + as_expression + '"')
Else
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the field and add the expression to it.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_modify = This.of_create_initcolumn(ao_powerobject, as_computedfieldname, as_expression)
End If

Return ls_modify
end function

public function boolean of_setitem (ref powerobject ao_datasource, long al_row, string as_column, any as_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_setitem()
// Arguments:   ao_datasource - datawindow/datastore
//				    al_row - row
//					 as_column -  columnname to set the value into.
//					 as_data -  data to be set	into the column
// Overview:    DocumentScriptFunctionality
// Created by:  Denton Newham
// History:     01/27/00- First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_data
decimal ld_data
datetime ldt_data
string	ls_data
string ls_type

If Not IsValid(ao_datasource) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the datawindow/datastore.
//-----------------------------------------------------------------------------------------------------------------------------------
if isnull(al_row) or al_row = 0 or al_row > ao_datasource.Dynamic rowcount() or ao_datasource.Dynamic rowcount() = 0 then return false
ls_type = ao_datasource.Dynamic Describe(as_column+".Coltype")

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','long','deci'
	
		ld_data = dec(as_data)
		
		// Added by jake to handle null numbers comming over as an empty string.
		If Classname(as_data) = 'string' then 
			if as_data = '' then 
				setnull(ld_data)
			End If
		end if

		ao_datasource.Dynamic setitem(al_row,as_column,ld_data)
	Case 'date'
		
		choose case lower(classname(as_data))
			case 'string'
				//n_string_functions	ln_string
				ldt_data = gn_globals.in_string_functions.of_convert_string_to_datetime(string(as_data))
			case 'date'
				ldt_data = datetime(as_data)
			case 'datetime'
				ldt_data = as_data
		end choose

		ao_datasource.Dynamic setitem(al_row,as_column,ldt_data)

	Case 'char'
		
		ls_data = string( as_data)
		
		ao_datasource.Dynamic setitem(al_row,as_column,ls_data)
End Choose

return true
end function

public function boolean of_share_dropdowndatawindow (ref powerobject ao_source, string as_sourcecolumn, ref powerobject ao_destination, string as_destinationcolumn);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_share_dropdowndatawindow()
//	Arguments:  ao_source 	- source
//					ao_destination - destination
//	Overview:   This will share all the dropdown data from one datawindow to another
//	Created by:	Blake Doerr
//	History: 	4/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_columnnumber
Long		ll_return
Long		ll_count1
Long		ll_count2
String 	ls_name

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
DatawindowChild 	ldwc_source
DatawindowChild 	ldwc_destination

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
ll_columnnumber 		= Long(ao_source.Dynamic Describe(as_sourcecolumn + ".ID"))
ls_name 					= ao_source.Dynamic Describe("#" + string(ll_columnnumber) + ".dddw.name")

//-----------------------------------------------------------------------------------------------------------------------------------
// If the dropdowndatawindowname is not valid, return false
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_name = '!' Or ls_name = '?' Or Trim(as_sourcecolumn) = '' Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get both datawindowchildren
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return 	= 	ao_source.		Dynamic GetChild(as_sourcecolumn, 		ldwc_source)
ll_return 	+= ao_destination.Dynamic GetChild(as_destinationcolumn, ldwc_destination)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't get both children
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_return <> 2 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return true if there is no work to do
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = ldwc_source.ShareData(ldwc_destination)

ll_count1	= ldwc_source.RowCount()
ll_count2	= ldwc_destination.RowCount()

Return ll_count1 = ll_count2

end function

public function string of_get_filter (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_filter()
//	Arguments:  ao_datasource - The datawindow to get the filter from
//	Overview:   Get the filter from a datawindow
//	Created by:	Blake Doerr
//	History: 	11/19/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_filter

//n_string_functions ln_string_functions

ls_filter = ao_datasource.Dynamic Describe("DataWindow.Table.Filter")

gn_globals.in_string_functions.of_replace_all(ls_filter, "~~", "")

If ls_filter = "?" Then ls_filter = ''

Return Trim(ls_filter)
end function

public subroutine of_get_array_from_column (powerobject ao_datasource, long al_columnnumber, ref string as_string[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_array_from_column()
//	Arguments:  ao_datasource - The datasource
//					ll_columnnumber - The column number
//					as_string[] - A string array by reference
//					adt_datetime[] - 
//	Overview:   This will return a string array of the column
//	Created by:	Blake Doerr
//	History: 	1/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_get_array_from_column(ao_datasource, This.of_get_columnname(ao_datasource, al_columnnumber), as_string[])
end subroutine

public function string of_get_array_from_column (powerobject ao_datasource, long al_columnnumber, ref string as_string[], ref datetime adt_datetime[], ref double adble_number[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_array_from_column()
//	Arguments:  ao_datasource - The datasource
//					al_columnnumber - The column number
//					as_string[] - A string array by reference
//					adt_datetime[] - 
//	Overview:   This will return an array from a column in a datasource
//	Created by:	Blake Doerr
//	History: 	1/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_get_array_from_column(ao_datasource, al_columnnumber, as_string[], adt_datetime[], adble_number[], False)

end function

public function string of_insert_column_from_array (powerobject ao_datasource, string as_columnname, string as_stringdata[], double adble_numberdata[], datetime adt_datetimedata[]);Datastore	lds_working
Datawindow	ldw_datawindow
Datastore	lds_datastore
String	ls_new_syntax
Long		ll_columnnumber
Long		ll_index
String	ls_return
String	ls_columntype

If Not IsValid(ao_datasource) Then Return ''

ls_columntype = This.of_get_columntype(ao_datasource, as_columnname)
ll_columnnumber	= This.of_get_columnid(ao_datasource, as_columnname)

If ll_columnnumber <= 0 Or IsNull(ll_columnnumber) Then Return 'Error:'

//----------------------------------------------------------------------------------------------------------------------------------
// This is the information that goes at the beginning of the syntax
//----------------------------------------------------------------------------------------------------------------------------------
ls_new_syntax = 'release 9;~r~ndatawindow(units=0 timer_interval=0 color=16777215 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )' + '~r~n' + 'header(height=73 color="536870912" )' + '~r~n' + 'summary(height=1 color="536870912" )' + '~r~n' + 'footer(height=1 color="536870912" )' + '~r~n' + 'detail(height=73 color="553648127" )' + '~r~n' + 'table('

//----------------------------------------------------------------------------------------------------------------------------------
// Now get the header text (for the dbcolumn name so it will show up in Excel)
//----------------------------------------------------------------------------------------------------------------------------------
ls_new_syntax = ls_new_syntax + '~r~n' + 'column=(type=' + ls_columntype + ' updatewhereclause=no name=column1 dbname="column1" )'

//----------------------------------------------------------------------------------------------------------------------------------
// This goes at the end of the syntax
//----------------------------------------------------------------------------------------------------------------------------------
ls_new_syntax = ls_new_syntax + '~r~n )'

//----------------------------------------------------------------------------------------------------------------------------------
//	Create the datastore and the datawindow based on the new syntax
//----------------------------------------------------------------------------------------------------------------------------------
lds_working  = Create Datastore
lds_working.Create(ls_new_syntax , ls_return)

//----------------------------------------------------------------------------------------------------------------------------------
//	If there was an error, return
//----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_return) > 0 Then
	Destroy lds_working
	Return 'Error:  ' + ls_return
End If

//----------------------------------------------------------------------------------------------------------------------------------
//	Insert the rows in batch for performance
//-----------------------------------------------------------------------------------------------------s-----------------------------
This.of_insert_rows(lds_working, ao_datasource.Dynamic RowCount())

If UpperBound(as_stringdata[]) > 0 Then
	lds_working.Object.Column1.Primary = as_stringdata[]
ElseIf UpperBound(adble_numberdata[]) > 0 Then
	lds_working.Object.Column1.Primary = adble_numberdata[]
ElseIf UpperBound(adt_datetimedata[]) > 0 Then
	lds_working.Object.Column1.Primary = adt_datetimedata[]
Else
	Destroy lds_working
	Return 'Error:'
End If

Choose Case ao_datasource.TypeOf()
	Case Datawindow!
		ldw_datawindow = ao_datasource
		ldw_datawindow.Object.Data[1, ll_columnnumber, ldw_datawindow.RowCount(), ll_columnnumber] = lds_working.Object.Data[1, 1, lds_working.RowCount(), 1]
	Case Datastore!
		lds_datastore = ao_datasource
		lds_datastore.Object.Data[1, ll_columnnumber, lds_datastore.RowCount(), ll_columnnumber] = lds_working.Object.Data[1, 1, lds_working.RowCount(), 1]
End Choose

Destroy lds_working
Return ''
end function

public function string of_get_lookupdisplay (powerobject ao_datasource, long al_row, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_lookupdisplay()
//	Created by:	Blake Doerr
//	History: 	12/22/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_return

If Not IsValid(ao_datasource) Then Return 'Error:  Datasource was not valid'

If This.of_iscolumn(ao_datasource, as_columnname) Then
	ls_return = ao_datasource.Dynamic Describe("Evaluate(~"LookupDisplay(" + as_columnname + ")~", " + String(al_row) + ")")
ElseIf This.of_IsComputedField(ao_datasource, as_columnname) Then
	ls_return = ao_datasource.Dynamic Describe("Evaluate(~"" + as_columnname + "~", " + String(al_row) + ")")
Else
	Return 'Error:  Column or Computed Field does not exist'
End If

Return ls_return

end function

public function boolean of_share_dropdowndatawindows (ref powerobject ao_source, ref powerobject ao_destination);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_share_dropdowndatawindows()
//	Arguments:  ao_source 	- source
//					ao_destination - destination
//	Overview:   This will copy all the dropdown data from one datawindow to another
//	Created by:	Blake Doerr
//	History: 	4/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_columns[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns on the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_objects(ao_source, 'column', ls_columns[], False)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and share them
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 to UpperBound(ls_columns[])
	If Not This.of_share_dropdowndatawindow(ao_source, ls_columns[ll_index], ao_destination, ls_columns[ll_index]) Then
		This.of_copy_dropdowndatawindow(ao_source, ls_columns[ll_index], ao_destination, ls_columns[ll_index])
	End If
Next

Return True
end function

public function long of_print_no_blank_pages (ref powerobject ao_datasource, powerobject au_dynamic_gui, boolean ab_show_cancel_dialog, boolean ab_fix_transparent_numbers);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_print_no_blank_pages()
//	Arguments:  ao_datasource 	- The object to print
//	Overview:   This will print a datawindow and try to not print blank pages
//	Created by:	Blake Doerr
//	History: 	5/15/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long			ll_index
Long			ll_upperbound
Long			ll_return
Long			ll_counter_low
Long			ll_counter_high
String		ls_expanded[]
String		ls_return
String		ls_syntax
String		ls_objects[]
String		ls_x_position[]
String		ls_x1_position[]
String		ls_x2_position[]
String		ls_object_nolines[]
String		ls_object_lines[]
String		ls_width[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datastore_print	lds_working_datastore
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are problems with the object passed in
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return -1
If Not IsValid(au_dynamic_gui) Then Return -1

Choose Case ao_datasource.TypeOf()
	Case Datawindow!, DatawindowChild!, Datastore!
	Case Else
		Return -1
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastores
//-----------------------------------------------------------------------------------------------------------------------------------
lds_working_datastore = Create n_datastore_print

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the datawindow's syntax into the working datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_working_datastore.Create(ao_datasource.Dynamic Describe("Datawindow.Syntax"), ls_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there's an error
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_return) > 0 Then
	Destroy lds_working_datastore
	Return -1
End If

lds_working_datastore.Modify("line_header.Pen.Color = '0'")
lds_working_datastore.Modify("line_header1.Pen.Color = '0'")
lds_working_datastore.Modify("line_header2.Pen.Color = '0'")
lds_working_datastore.Modify("line_header3.Pen.Color = '0'")
lds_working_datastore.Modify("line_header4.Pen.Color = '0'")
lds_working_datastore.Modify("line_header5.Pen.Color = '0'")
lds_working_datastore.Modify("line_detail.Pen.Color = '0'")
lds_working_datastore.Modify("line_detail1.Pen.Color = '0'")
lds_working_datastore.Modify("line_detail2.Pen.Color = '0'")
lds_working_datastore.Modify("line_detail3.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer1.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer2.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer3.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer4.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer5.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer6.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer7.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer8.Pen.Color = '0'")
lds_working_datastore.Modify("line_footer9.Pen.Color = '0'")

If Long(lds_working_datastore.Describe("report_title.Width")) > 2500 Then
	lds_working_datastore.Modify("report_title.Width = '2500'")
End If

If Long(lds_working_datastore.Describe("report_footer.Width")) > 2500 Then
	lds_working_datastore.Modify("report_footer.Width = '2500'")
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Get all invisible objects
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_invisible_objects(lds_working_datastore, ls_objects[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all X and Width properties of the invisible objects
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(ls_objects[]) > 0 Then
	ls_object_nolines[] 	= ls_objects[]
	ls_object_lines[] 	= ls_objects[]
	This.of_get_all_object_property(lds_working_datastore, 'x', ls_object_nolines[], ls_x_position[], False)
	This.of_get_all_object_property(lds_working_datastore, 'width', ls_object_nolines[], ls_width[], False)
	This.of_get_all_object_property(lds_working_datastore, 'x1', ls_object_lines[], ls_x1_position[], False)
	This.of_get_all_object_property(lds_working_datastore, 'x2', ls_object_lines[], ls_x2_position[], False)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = Min(Min(UpperBound(ls_object_nolines[]), UpperBound(ls_x_position[])), UpperBound(ls_width[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// Move and shrink all invisible objects that may be too large
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If Long(ls_x_position[ll_index]) + Long(ls_width[ll_index]) > 1000 Then
		ls_return = lds_working_datastore.Modify(ls_object_nolines[ll_index] + '.X=~'0~'')
		ls_return = lds_working_datastore.Modify(ls_object_nolines[ll_index] + '.Width=~'0~'')
	End If
Next


//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = Min(Min(UpperBound(ls_object_lines[]), UpperBound(ls_x1_position[])), UpperBound(ls_x2_position[]))

//-----------------------------------------------------------------------------------------------------------------------------------
// Move and shrink all invisible objects that may be too large
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If Left(ls_object_lines[ll_index], Len('columnedge')) = 'columnedge' Then
		ls_return = lds_working_datastore.Modify('Destroy ' + ls_object_lines[ll_index])
	Else
		If Long(ls_x1_position[ll_index]) + Long(ls_x2_position[ll_index]) > 1000 Then
			ls_return = lds_working_datastore.Modify(ls_object_lines[ll_index] + '.X1=~'0~'')
			ls_return = lds_working_datastore.Modify(ls_object_lines[ll_index] + '.X2=~'0~'')
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the datawindow's syntax into the working datastore
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = lds_working_datastore.Describe("Datawindow.Syntax")

If ab_fix_transparent_numbers Then
	This.of_fix_transparent_color_number(ls_syntax)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create a datawindow object on the gui
//-----------------------------------------------------------------------------------------------------------------------------------
lds_working_datastore.Create(ls_syntax, ls_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there's an error
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_return) > 0 Then
	Destroy lds_working_datastore
	Return -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Share the data between the two datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource.Dynamic ShareData(lds_working_datastore) < 0 Then
	Destroy lds_working_datastore
	Return -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Share the dropdowndatawindows between the two datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
If Not This.of_share_dropdowndatawindows(ao_datasource, lds_working_datastore) Then
	Destroy lds_working_datastore
	Return -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply Properties that do not get included in the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ao_datasource.Dynamic Describe('Datawindow.Print.Collate')
If ls_return <> '?' And ls_return <> '!' Then lds_working_datastore.Modify('Datawindow.Print.Collate=' + ls_return)

ls_return = ao_datasource.Dynamic Describe('Datawindow.Print.Copies')
If IsNumber(ls_return) And Long(ls_return) > 0 Then lds_working_datastore.Modify('Datawindow.Print.Copies=~'' + ls_return + '~'')

ls_return = ao_datasource.Dynamic Describe('Datawindow.Print.Page.Range')
If ls_return <> '?' And ls_return <> '!' Then lds_working_datastore.Modify('Datawindow.Print.Page.Range=~'' + ls_return + '~'')

ls_return = ao_datasource.Dynamic Describe('Datawindow.Print.Page.RangeInclude')
If IsNumber(ls_return) And Long(ls_return) > 0 Then lds_working_datastore.Modify('Datawindow.Print.Page.RangeInclude=~'' + ls_return + '~'')

ls_return = ao_datasource.Dynamic Describe('Datawindow.Zoom')
If IsNumber(ls_return) And Long(ls_return) > 0 Then lds_working_datastore.Modify('Datawindow.Zoom=~'' + ls_return + '~'')

ls_return = ao_datasource.Dynamic Describe('Datawindow.Print.Orientation')
If IsNumber(ls_return) And Long(ls_return) > 0 Then lds_working_datastore.Modify('Datawindow.Print.Orientation=~'' + ls_return + '~'')

ls_return = ao_datasource.Dynamic Describe('Datawindow.Print.Paper.Size')
If IsNumber(ls_return) And Long(ls_return) > 0 Then lds_working_datastore.Modify('Datawindow.Print.Paper.Size=~'' + ls_return + '~'')

//-----------------------------------------------------------------------------------------------------------------------------------
// Keep the collapsed rows collapsed during printing
//-----------------------------------------------------------------------------------------------------------------------------------

//Check for existence of "expanded" column
//Check that "expanded" column is character datatype
//Check that the datastore actually has rows in it

if	(lds_working_datastore.rowcount() > 0) and &
	(this.of_iscolumn(lds_working_datastore, 'expanded')) and &
	left(this.of_get_columntype(lds_working_datastore, 'expanded'), 4) = 'char' then //(existence loop)
	
	ls_expanded[] 	= lds_working_datastore.object.expanded.primary  //put expanded column into an array
		
		//we're finding a range of values that are the same (from ll_counter_low to ll_counter_high-1)

	ll_counter_low = 1						//we start with the first row
	ll_counter_high = ll_counter_low		//and set the low = high
	
	
	//if there is only 1 row, check it
	if ll_counter_high = upperbound(ls_expanded[]) and lower(ls_expanded[ll_counter_low]) = 'n' then
		lds_working_datastore.SetDetailHeight(ll_counter_low,ll_counter_high, 0)
	end if
	

	//we want to keep moving the ll_counter_high until either the "expanded" value changes (or it's null)
	//or we hit the upper bound of the array.  This sets the beginning for the next range of similar values
	do until ll_counter_high = upperbound(ls_expanded[])
		do until	(ls_expanded[ll_counter_low] <> ls_expanded[ll_counter_high]) or &
					(IsNull(ls_expanded[ll_counter_low]) <> IsNull(ls_expanded[ll_counter_high])) or &
					ll_counter_high = upperbound(ls_expanded[])					
			ll_counter_high++
		loop
		
		//if the "expanded" value for the range is "n" then we set the height for those rows to 0
		//if the last row is part of our range, we need to set it as well
		if lower(ls_expanded[ll_counter_low]) = 'n' then
			if ll_counter_high = upperbound(ls_expanded[]) then
				lds_working_datastore.SetDetailHeight(ll_counter_low,ll_counter_high, 0)
			else
				lds_working_datastore.SetDetailHeight(ll_counter_low,(ll_counter_high - 1), 0)
			end if
		end if
		//set the low = high so that we can begin a new range
		ll_counter_low = ll_counter_high
	loop

end if //(existence loop)

//-----------------------------------------------------------------------------------------------------------------------------------
// Print the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_working_datastore.GroupCalc()
ll_return = lds_working_datastore.of_print(ab_show_cancel_dialog)

String	ls_old
String	ls_new
ls_old 	= ao_datasource.Dynamic Describe("Datawindow.Syntax")
ls_new	= lds_working_datastore.Dynamic Describe("Datawindow.Syntax")

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datastores
//-----------------------------------------------------------------------------------------------------------------------------------
lds_working_datastore.ShareDataOff()
Destroy lds_working_datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the error code
//-----------------------------------------------------------------------------------------------------------------------------------
Return ll_return
end function

public function string of_retrieve (powerobject ao_datasource, string as_arguments, string as_delimiter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_determine_arguments()
//	Arguments:  ads_datastore - datastore pointer to operate on
//					as_delimiter - character(s) the argument string is delimited on.
//					ads_datastorestore - The datastore that contains the dataobject to interrogate
//					lany_variables[] - an array of any's passed by reference
//	Overview:   This will take a datastore with a dataobject and interrogate it to determine the variables
//	Created by:	Blake Doerr
//	History: 	3/7/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Date		ld_null
Time		lt_null
DateTime ldt_null
Decimal	ldec_null
string s_args[], s_data_args[], s_datetime[], s_empty[], s_null
any lany_placeholder
long l_upperbound_data_args, i, ll_position, l_upperbound, l_endpos, l_ctr, ll_null
Datastore	lds_data
Datawindow	ldw_data
DatawindowChild ldwc_datawindowchild
//n_string_functions ln_string_functions
Long ll_return
any lany_variables[]
String ls_syntax

//-------------------------------------------------------------------
//	Create null datatypes
//-------------------------------------------------------------------
SetNull(s_null)
SetNull(ll_null)
SetNull(ldt_null)
SetNull(ld_null)
SetNull(lt_null)
SetNull(ldec_null)

//-----------------------------------------------------
// Return if it isn't valid
//-----------------------------------------------------
If Not IsValid(ao_datasource) Then Return 'Error: Datasource was not valid'

//-------------------------------------------------------------------
// Get the SQL Syntax for this datawindow and determine if it's 
//	stored procedure-based or SQL-based.
//-------------------------------------------------------------------
ls_syntax = ao_datasource.Dynamic Describe("Datawindow.Syntax")

//-------------------------------------------------------------------
// Parse the retrieval argument values into an array
//-------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_arguments, as_delimiter, s_data_args[])
l_upperbound_data_args = UpperBound(s_data_args[])

//-----------------------------------------------------------------------------
// Cut the arguments out of the syntax	Arguments have the following type syntax:
//	arguments=(("al_dcmnttypid", number),("al_ruletypeid", number))
//	So, we're going to trim the string down to just the arguments piece and 
//	ensure that this dataobject does indeed have arguments.
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the position where the arguments start and end
// If the position isn't found set the syntax to empty so it will not generate an Arg array
//-----------------------------------------------------------------------------------------------------------------------------------
ll_position = Pos(ls_syntax,'arguments=')

If ll_position > 0 Then 
	
	l_endpos = Pos(ls_syntax,"))",ll_position)

	//-------------------------------------------------------------------------------------------------------
	// If the position isn't found set the syntax to empty so it will not generate an Arg array
	//-------------------------------------------------------------------------------------------------------
	If l_endpos > 0 Then 
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Cut the argument string out
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_position = ll_position + 13
		l_endpos = l_endpos - ll_position
		ls_syntax = Trim(Mid(ls_syntax,ll_position,l_endpos))

	else
	
		ls_syntax = ''
	
	end if
	
else
	
	ls_syntax = ''
		
end if


//-----------------------------------------------------------------------------
// Remove all the characters we don't want. At this point, the string should
//	contain nothing but argument,value. Then we parse the string into an array.
//-----------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(ls_syntax, ' ', '')
gn_globals.in_string_functions.of_replace_all(ls_syntax, '(', '')
gn_globals.in_string_functions.of_replace_all(ls_syntax, ')', '')
gn_globals.in_string_functions.of_parse_string(ls_syntax, ',', s_args[])

//-----------------------------------------------------------------------------
// Ensure that we haven't passed in more arguments	than exist on the datawindow. ******why are we doing this?  It seems less flexible
//-----------------------------------------------------------------------------
l_upperbound = UpperBound(s_args[])
//If (l_upperbound/2) > l_upperbound_data_args Then RETURN 'Error:  More arguments were passed than the datawindow requires'

//-----------------------------------------------------------------------------
// Populate the any variable with the correct datatype 
//-----------------------------------------------------------------------------
For i = 2 To l_upperbound STEP 2
	l_ctr ++
	
	Choose case left(Trim(Lower(s_args[i])),7)
		Case 'number', 'ulong', 'real', 'long'
			If UpperBound(s_data_args[]) >= l_ctr Then
				If Lower(Trim(s_data_args[l_ctr])) = 'null' Or Lower(Trim(s_data_args[l_ctr])) = '' Then
					lany_placeholder = ll_null
				Else
					lany_placeholder = Double(s_data_args[l_ctr])
				End If
			Else
				lany_placeholder = 0
			End If
		Case 'date'
			If UpperBound(s_data_args[]) >= l_ctr Then
				If pos(s_data_args[l_ctr],";") > 0 Then
					gn_globals.in_string_functions.of_parse_string(s_data_args[l_ctr],";",s_datetime[])
					If upperbound(s_datetime[]) = 2 Then
						lany_placeholder = gn_globals.in_string_functions.of_convert_string_to_date(s_datetime[1],s_datetime[2])
					Else
						lany_placeholder = gn_globals.in_string_functions.of_convert_string_to_date(s_datetime[1],s_null)
					End If
				Else
					If Lower(Trim(s_data_args[l_ctr])) = 'null' Or Lower(Trim(s_data_args[l_ctr])) = '' Then
						lany_placeholder = ld_null
					Else
						lany_placeholder = gn_globals.in_string_functions.of_convert_string_to_date(s_data_args[l_ctr],s_null)
					End If
				End If
				s_datetime[] = s_empty[]			
			Else
				lany_placeholder = Today()
			End If
		Case 'datetim'
			If UpperBound(s_data_args[]) >= l_ctr Then
				If pos(s_data_args[l_ctr],";") > 0 Then
					gn_globals.in_string_functions.of_parse_string(s_data_args[l_ctr],";",s_datetime[])
					If upperbound(s_datetime[]) = 2 Then
						lany_placeholder = gn_globals.in_string_functions.of_convert_string_to_datetime(s_datetime[1],s_datetime[2])
					Else
						lany_placeholder = gn_globals.in_string_functions.of_convert_string_to_datetime(s_datetime[1],s_null)
					End If
				Else
					If Lower(Trim(s_data_args[l_ctr])) = 'null' Or Lower(Trim(s_data_args[l_ctr])) = '' Then
						lany_placeholder = ldt_null
					Else
						lany_placeholder = gn_globals.in_string_functions.of_convert_string_to_datetime(s_data_args[l_ctr],s_null)
					End If
				End If
				s_datetime[] = s_empty[]
			Else
				lany_placeholder = DateTime(Today(), Now())
			End If
		Case 'time'
			If UpperBound(s_data_args[]) >= l_ctr Then
				If Lower(Trim(s_data_args[l_ctr])) = 'null' Or Lower(Trim(s_data_args[l_ctr])) = '' Then
					lany_placeholder = lt_null
				Else
					lany_placeholder = Time(s_data_args[l_ctr])
				End If
			Else
				lany_placeholder = Now()
			End If
		Case 'string'
			If UpperBound(s_data_args[]) >= l_ctr Then
				If Lower(Trim(s_data_args[l_ctr])) = 'null' Then
					lany_placeholder = s_null
				Else
					lany_placeholder = s_data_args[l_ctr]						
				End If
			Else
				lany_placeholder = ''
			End If
		Case 'decimal'
			If UpperBound(s_data_args[]) >= l_ctr Then
				If Lower(Trim(s_data_args[l_ctr])) = 'null' Or Lower(Trim(s_data_args[l_ctr])) = '' Then
					lany_placeholder = ldec_null
				Else
					lany_placeholder = Dec(s_args[i])
				End If
			Else
				lany_placeholder = 0.0
			End If
		Case Else
	End Choose
	lany_variables[UpperBound(lany_variables) + 1] = lany_placeholder
Next

//-----------------------------------------------------
// Fill the array up to the 20'th position in the array
//-----------------------------------------------------
For i = UpperBound(lany_variables) + 1 To 30
	lany_variables[i] = lany_placeholder
Next

//-----------------------------------------------------
// Retrieve Datawindow
//-----------------------------------------------------
Choose Case ao_datasource.TypeOf()
	Case Datastore!
		lds_data	= ao_datasource
		ll_return = lds_data.Retrieve(lany_variables[1], lany_variables[2], lany_variables[3], lany_variables[4], lany_variables[5], lany_variables[6], lany_variables[7], lany_variables[8], lany_variables[9], lany_variables[10], lany_variables[11], lany_variables[12], lany_variables[13], lany_variables[14], lany_variables[15], lany_variables[16], lany_variables[17], lany_variables[18], lany_variables[19], lany_variables[20], lany_variables[21], lany_variables[22], lany_variables[23], lany_variables[24], lany_variables[25], lany_variables[26], lany_variables[27], lany_variables[28], lany_variables[29], lany_variables[30])
	Case Datawindow!
		ldw_data	= ao_datasource
		ll_return = ldw_data.Retrieve(lany_variables[1], lany_variables[2], lany_variables[3], lany_variables[4], lany_variables[5], lany_variables[6], lany_variables[7], lany_variables[8], lany_variables[9], lany_variables[10], lany_variables[11], lany_variables[12], lany_variables[13], lany_variables[14], lany_variables[15], lany_variables[16], lany_variables[17], lany_variables[18], lany_variables[19], lany_variables[20], lany_variables[21], lany_variables[22], lany_variables[23], lany_variables[24], lany_variables[25], lany_variables[26], lany_variables[27], lany_variables[28], lany_variables[29], lany_variables[30])
	Case DatawindowChild!
		ldwc_datawindowchild = ao_datasource
		ldwc_datawindowchild.Retrieve(lany_variables[1], lany_variables[2], lany_variables[3], lany_variables[4], lany_variables[5], lany_variables[6], lany_variables[7], lany_variables[8], lany_variables[9], lany_variables[10], lany_variables[11], lany_variables[12], lany_variables[13], lany_variables[14], lany_variables[15], lany_variables[16], lany_variables[17], lany_variables[18], lany_variables[19], lany_variables[20], lany_variables[21], lany_variables[22], lany_variables[23], lany_variables[24], lany_variables[25], lany_variables[26], lany_variables[27], lany_variables[28], lany_variables[29], lany_variables[30])
End Choose

Return String(ll_return)
end function

public function boolean of_get_lookupdisplay (powerobject ao_datasource, string as_columnname, ref string as_lookupdisplay[]);Boolean				lb_IsComputedField = False
String				ls_format
Datawindow			ldw_datawindow
Datastore			lds_datastore
DatawindowChild	ldwc_datawindowchild

If Not IsValid(ao_datasource) Then Return False

If Not This.of_iscolumn(ao_datasource, as_columnname) Then
	If not This.of_IsComputedField(ao_datasource, as_columnname) Then
		Return False
	Else
		lb_IsComputedField = True
	End If
End If

If lb_IsComputedField Then
	If Not This.of_IsComputedFieldValid(ao_datasource, as_columnname) Then Return False

	ls_format	= ao_datasource.Dynamic Describe(as_columnname + '.Format')
	
	Choose Case Lower(Trim(ls_format))
		Case '!', '?', '[general]'
		Case Else
			as_columnname = as_columnname + ', "' + ls_format + '"'
	End Choose
	
	If ao_datasource.Dynamic Modify(&
	"create compute(band=Detail color='0' alignment='0' border='0'" + &
	" height.autosize=No pointer='Arrow!' moveable=0 resizeable=0 x='10000' y='0' height='0' width='0' format='[general]'" + &
	" name=lookupdisplay_compute tag='' expression='String(" + as_columnname + ")' font.face='Tahoma' font.height='-8' font.weight='400' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='1' background.color='0')") <> '' Then 
		Return False
	End IF
Else
	If ao_datasource.Dynamic Modify(&
	"create compute(band=Detail color='0' alignment='0' border='0'" + &
	" height.autosize=No pointer='Arrow!' moveable=0 resizeable=0 x='10000' y='0' height='0' width='0' format='[general]'" + &
	" name=lookupdisplay_compute tag='' expression='LookupDisplay(" + as_columnname + ")' font.face='Tahoma' font.height='-8' font.weight='400' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='1' background.color='0')") <> '' Then 
		Return False
	End IF
End If


If Not This.of_IsComputedField(ao_datasource, 'lookupdisplay_compute') Then Return False

If Not This.of_IsComputedFieldValid(ao_datasource, 'lookupdisplay_compute') Then
	ao_datasource.Dynamic Modify("Destroy lookupdisplay_compute")
	Return False
End If

Choose Case ao_datasource.TypeOf()
	Case Datawindow!
		ldw_datawindow = ao_datasource
		as_lookupdisplay[] = ldw_datawindow.Object.lookupdisplay_compute.Primary
	Case Datastore!
		lds_datastore	= ao_datasource
		as_lookupdisplay[] = lds_datastore.Object.lookupdisplay_compute.Primary
	Case DatawindowChild!
		ldwc_datawindowchild = ao_datasource
		//as_lookupdisplay[] = ldwc_datawindowchild.Object.lookupdisplay_compute.Primary
End Choose

ao_datasource.Dynamic Modify("Destroy lookupdisplay_compute")

Return True
end function

public function boolean of_sort_lookupdisplay (powerobject ao_datasource, string as_columnname, boolean ab_ascending);//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore	lds_lookupdisplay
Datawindow ldw_datawindow
Datastore lds_datastore

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_string[], ls_lookupdisplay[], ls_ascendingdescending = 'A'
DateTime	ldt_datetime[]
Long	ll_SortRowID[], ll_rowcount, ll_row[], ll_index, ll_columnnumber
Double ll_ID[]

//----------------------------------------------------------------------------------------------------------------------------------
// If the dataobject isn't valid, return false
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False

//----------------------------------------------------------------------------------------------------------------------------------
// If this isn't a column return false
//-----------------------------------------------------------------------------------------------------------------------------------
If Not This.of_IsColumn(ao_datasource, as_columnname) Then Return False

//----------------------------------------------------------------------------------------------------------------------------------
// Set the ascending or descending flag
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ab_ascending Then ls_ascendingdescending = 'D'

//----------------------------------------------------------------------------------------------------------------------------------
// Get the rowcount and column number of the column we are sorting
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = ao_datasource.Dynamic RowCount()
ll_columnnumber = This.of_get_columnid(ao_datasource, as_columnname)

//----------------------------------------------------------------------------------------------------------------------------------
// Create the sorting datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_lookupdisplay = Create Datastore
lds_lookupdisplay.DataObject = 'd_sort_lookupdisplay'

//----------------------------------------------------------------------------------------------------------------------------------
// Insert the necessary number of rows and create an array of row numbers
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_insert_Rows(lds_lookupdisplay, ll_rowcount)

For ll_index = ll_rowcount To 1 Step - 1
	ll_row[ll_index] = ll_index
Next

Choose Case ao_datasource.TypeOf()
	Case Datawindow!
		//----------------------------------------------------------------------------------------------------------------------------------
		// Get the data from the datasource
		//-----------------------------------------------------------------------------------------------------------------------------------
		ldw_datawindow = ao_datasource
		lds_lookupdisplay.Object.Data[1, 1, ll_rowcount, 1] = ldw_datawindow.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]
	Case Datastore!
		lds_datastore = ao_datasource
		lds_lookupdisplay.Object.Data[1, 1, ll_rowcount, 1] = lds_datastore.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber]
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Get the number array and the lookupdisplay array
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_lookupdisplay(ao_datasource, as_columnname, ls_lookupdisplay[])

//----------------------------------------------------------------------------------------------------------------------------------
// Put the ID, LookupDisplay, and the RowNumber arrays into the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_lookupdisplay.Object.lookupdisplay.Primary = ls_lookupdisplay[]
lds_lookupdisplay.Object.RowID.Primary = ll_row[]

//----------------------------------------------------------------------------------------------------------------------------------
// Sort on the lookupdisplay column, put the row array into the sortrow column, sort the
//   datawindow back by rowid and get the id's back out.  This basically creates a translation
//   of the id's before the sort and the id's after the sort.
//-----------------------------------------------------------------------------------------------------------------------------------
lds_lookupdisplay.SetSort('LookupDisplay ' + ls_ascendingdescending)
lds_lookupdisplay.Sort()
lds_lookupdisplay.Object.SortRowID.Primary = ll_row[]
ll_ID[] = lds_lookupdisplay.Object.ID.Primary
lds_lookupdisplay.SetSort('RowID A')
lds_lookupdisplay.Sort()
lds_lookupdisplay.Object.ID.Primary = ll_ID[]

//----------------------------------------------------------------------------------------------------------------------------------
// We have to promote to do the dot notation
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ao_datasource.TypeOf()
	Case Datawindow!
		//----------------------------------------------------------------------------------------------------------------------------------
		// Put the sort column into the datawindow, sort, then put the sorted id column back into the datasource
		//-----------------------------------------------------------------------------------------------------------------------------------
		ldw_datawindow = ao_datasource
		ldw_datawindow.SetRedraw(False)
		ldw_datawindow.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber] = lds_lookupdisplay.Object.Data[1, 3, ll_rowcount, 3]
		ldw_datawindow.SetSort(as_columnname)
		ldw_datawindow.Sort()
		ldw_datawindow.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber] = lds_lookupdisplay.Object.Data[1, 1, ll_rowcount, 1]

		//----------------------------------------------------------------------------------------------------------------------------------
		// Sort the datawindow by nothing so we don't get bad sorting when we filter.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ldw_datawindow.SetSort('')
		ldw_datawindow.SetRedraw(True)
	Case Datastore!
		//----------------------------------------------------------------------------------------------------------------------------------
		// Put the sort column into the datawindow, sort, then put the sorted id column back into the datasource
		//-----------------------------------------------------------------------------------------------------------------------------------
		lds_datastore = ao_datasource
		lds_datastore.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber] = lds_lookupdisplay.Object.Data[1, 3, ll_rowcount, 3]
		lds_datastore.SetSort(as_columnname)
		lds_datastore.Sort()
		lds_datastore.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber] = lds_lookupdisplay.Object.Data[1, 1, ll_rowcount, 1]

		//----------------------------------------------------------------------------------------------------------------------------------
		// Sort the datawindow by nothing so we don't get bad sorting when we filter.
		//-----------------------------------------------------------------------------------------------------------------------------------
		lds_datastore.SetSort('')
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datatstore
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_lookupdisplay

//----------------------------------------------------------------------------------------------------------------------------------
// Return True
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function boolean of_get_expression_as_array (powerobject ao_datasource, string as_expression, ref string as_string[], ref datetime adt_datetime[], ref double adble_double[]);Return This.of_get_expression_as_array(ao_datasource, as_expression, as_string[], adt_datetime[], adble_double[], Primary!)
end function

public function boolean of_sort (powerobject ao_datasource, string as_sortstring);//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore	lds_lookupdisplay
Datawindow ldw_datawindow
Datastore lds_datastore
//n_string_functions ln_string_functions
dwBuffer aenum_dwbuffer = Primary!
//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_string[]
String	ls_string_filter[]
DateTime	ldt_datetime[]
DateTime	ldt_datetime_filter[]
Double	ldble_double[]
Double	ldble_double_filter[]
Boolean	lb_WeHaveNotFoundAReasonThatRegularSortWouldNotWork = True
Long		ll_return = 1
Long		ll_rowcount
Long		ll_filteredcount
Long		ll_row[]
Long		ll_index
Long		ll_index2
Long		ll_columnnumber[]
Long		ll_buffer[]
Long		ll_SortColumn_ColumnNumber
String	ls_columnname[], ls_sort_direction[], ls_column_type[]
String 	ls_errormessage
String	ls_complete_syntax
String	ls_datatype
String	ls_sortstring = ''

//----------------------------------------------------------------------------------------------------------------------------------
// If the dataobject isn't valid, return false
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False

//----------------------------------------------------------------------------------------------------------------------------------
// If this isn't a column return false
//-----------------------------------------------------------------------------------------------------------------------------------
If Not This.of_IsColumn(ao_datasource, 'SortColumn') Then Return False

//----------------------------------------------------------------------------------------------------------------------------------
// If there are zero rows, set the sort and return true
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource.Dynamic RowCount() + ao_datasource.Dynamic FilteredCount() <= 0 Then 
	ao_datasource.Dynamic SetSort('SortColumn A')
	ao_datasource.Dynamic Sort()
	Return True
End If
ll_rowcount 		= ao_datasource.Dynamic RowCount()
ll_filteredcount	= ao_datasource.Dynamic FilteredCount()

ll_SortColumn_ColumnNumber = This.of_Get_ColumnID(ao_datasource, 'SortColumn')
If ll_SortColumn_ColumnNumber <= 0 Or IsNull(ll_SortColumn_ColumnNumber) Then Return False

//----------------------------------------------------------------------------------------------------------------------------------
// Create the header of the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_complete_syntax = 'release 9;~r~ndatawindow(units=0 timer_interval=0 color=536870912 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )~r~n' + &
							'header(height=0 color="536870912" )~r~n' + &
							'summary(height=0 color="536870912" )~r~n' + &
							'footer(height=0 color="536870912" )~r~n' + &
							'detail(height=0 color="536870912" )~r~n' + &
							'table(~r~n'
ls_complete_syntax = ls_complete_syntax + 	' column=(type=number updatewhereclause=no name=row_special dbname="row_special" ) ~r~n'
ls_complete_syntax = ls_complete_syntax + 	' column=(type=number updatewhereclause=no name=sortrow_special dbname="sortrow_special" ) ~r~n'

//----------------------------------------------------------------------------------------------------------------------------------
// Parse the string into the array
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_sortstring, ',', ls_columnname[])

//----------------------------------------------------------------------------------------------------------------------------------
// Create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columnname[])
	//----------------------------------------------------------------------------------------------------------------------------------
	// Trim the column name a pull the ascending/descending off the string
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_columnname[ll_index] = Trim(ls_columnname[ll_index])
	Choose Case Right(Lower(ls_columnname[ll_index]), 2)
		Case '~td', ' d'
			ls_sort_direction[ll_index] = ' D'
			ls_columnname[ll_index] = Trim(Left(ls_columnname[ll_index], Len(ls_columnname[ll_index]) - 2))
		Case '~ta', ' a'
			ls_sort_direction[ll_index] = ''
			ls_columnname[ll_index] = Trim(Left(ls_columnname[ll_index], Len(ls_columnname[ll_index]) - 2))
		Case Else
			ls_sort_direction[ll_index] = ''
	End Choose

	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the datatype of the column.  If it's 
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case lower(left(ao_datasource.Dynamic Describe(ls_columnname[ll_index] + '.ColType'),4))
		Case 'numb','deci','long', 'inte'
			ls_datatype = 'number'
		Case 'date'
			ls_datatype = 'datetime'
		Case Else
			ls_datatype = 'string'
	End Choose

	//----------------------------------------------------------------------------------------------------------------------------------
	// Translate the datatype down into distinct sets
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case Lower(Trim(ls_datatype))
		Case 'string'
			ls_datatype = 'string'
			ls_complete_syntax = ls_complete_syntax + 	' column=(type=char(32000) updatewhereclause=no name=column' + String(ll_index) + ' dbname="column' + String(ll_index) + ' " ) ~r~n'
		Case 'datetime'
			ls_datatype = 'datetime'
			ls_complete_syntax = ls_complete_syntax + 	' column=(type=datetime updatewhereclause=no name=column' + String(ll_index) + ' dbname="column' + String(ll_index) + ' " ) ~r~n'
		Case 'number'
			ls_datatype = 'number'
			ls_complete_syntax = ls_complete_syntax + 	' column=(type=number updatewhereclause=no name=column' + String(ll_index) + ' dbname="column' + String(ll_index) + ' " ) ~r~n'
	End Choose
	
	ll_columnnumber[ll_index] = This.of_get_columnid(ao_datasource, ls_columnname[ll_index])
	
	If lb_WeHaveNotFoundAReasonThatRegularSortWouldNotWork Then
		lb_WeHaveNotFoundAReasonThatRegularSortWouldNotWork = ll_columnnumber[ll_index] > 0 And Not IsNull(ll_columnnumber[ll_index])
	End If
	
	ls_column_type[ll_index] = ls_datatype
	
	ls_sortstring = ls_sortstring + 'column' + String(ll_index) + ls_sort_direction[ll_index] + ','
Next

If lb_WeHaveNotFoundAReasonThatRegularSortWouldNotWork Then Return False

//----------------------------------------------------------------------------------------------------------------------------------
// Add the end of the syntax and cut the extra comma off the sort string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_complete_syntax = ls_complete_syntax + 	' column=(type=number updatewhereclause=no name=buffer dbname="buffer" ) ~r~n'
ls_complete_syntax = ls_complete_syntax + ')'
ls_sortstring = Left(ls_sortstring, Len(ls_sortstring) - 1)

//----------------------------------------------------------------------------------------------------------------------------------
// Create the sorting datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_lookupdisplay = Create Datastore

//----------------------------------------------------------------------------------------------------------------------------------
// Create the dataobject dynamically
//-----------------------------------------------------------------------------------------------------------------------------------
lds_lookupdisplay.Create(ls_complete_syntax, ls_errormessage)

//----------------------------------------------------------------------------------------------------------------------------------
// Create the sorting datastore
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_errormessage) > 0 Then
	Destroy lds_lookupdisplay
	Return False
End If

//JLR and Blake commented. #48977
////----------------------------------------------------------------------------------------------------------------------------------
//// Insert the necessary number of rows
////-----------------------------------------------------------------------------------------------------------------------------------
//This.of_insert_Rows(lds_lookupdisplay, ll_rowcount)
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Create an array of rownumbers
////-----------------------------------------------------------------------------------------------------------------------------------
//For ll_index = ll_rowcount To 1 Step - 1
//	ll_row[ll_index] = ll_index
//Next


//Begin JLR and Blake #48977
//----------------------------------------------------------------------------------------------------------------------------------
// Insert the necessary number of rows
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_insert_Rows(lds_lookupdisplay, ll_rowcount + ll_filteredcount)

//----------------------------------------------------------------------------------------------------------------------------------
// Create an array of rownumbers
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = ll_filteredcount + ll_rowcount To 1 Step - 1
	ll_row[ll_index] = ll_index
Next
//End JLR and Blake #48977

//----------------------------------------------------------------------------------------------------------------------------------
// Get the data from the datasource into the dummy datastore
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columnname[])

	//----------------------------------------------------------------------------------------------------------------------------------
	// If it is a valid column, we can just dot notation it into the datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_columnnumber[ll_index] > 0 And Not IsNull(ll_columnnumber[ll_index]) Then
		Choose Case ao_datasource.TypeOf()
			Case Datawindow!
				ldw_datawindow = ao_datasource
				If ll_rowcount > 0 Then
					lds_lookupdisplay.Object.Data.Primary[1, ll_index + 2, ll_rowcount, ll_index + 2] = ldw_datawindow.Object.Data.Primary[1, ll_columnnumber[ll_index], ll_rowcount, ll_columnnumber[ll_index]]
				End If
				If ll_filteredcount > 0 Then
					lds_lookupdisplay.Object.Data.Primary[ll_rowcount + 1, ll_index + 2, ll_rowcount + ll_filteredcount, ll_index + 2] = ldw_datawindow.Object.Data.Filter[1, ll_columnnumber[ll_index], ll_filteredcount, ll_columnnumber[ll_index]]
				End If
			Case Datastore!
				lds_datastore = ao_datasource
				If ll_rowcount > 0 Then
					lds_lookupdisplay.Object.Data.Primary[1, ll_index + 2, ll_rowcount, ll_index + 2] = lds_datastore.Object.Data.Primary[1, ll_columnnumber[ll_index], ll_rowcount, ll_columnnumber[ll_index]]
				End If
				If ll_filteredcount > 0 Then
					lds_lookupdisplay.Object.Data.Primary[ll_rowcount + 1, ll_index + 2, ll_rowcount + ll_filteredcount, ll_index + 2] = lds_datastore.Object.Data.Filter[1, ll_columnnumber[ll_index], ll_filteredcount, ll_columnnumber[ll_index]]
				End If
		End Choose
		Continue
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// Otherwise, it must be a computed field or an expression.  We need to get the computed field into an array
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_rowcount > 0 Then
		If Not This.of_get_expression_as_array(ao_datasource, ls_columnname[ll_index], ls_string[], ldt_datetime[], ldble_double[], Primary!) Then
			Destroy lds_lookupdisplay
			Return False
		End If
	End If
	
	If ll_filteredcount > 0 Then
		If Not This.of_get_expression_as_array(ao_datasource, ls_columnname[ll_index], ls_string_filter[], ldt_datetime_filter[], ldble_double_filter[], Filter!) Then
			Destroy lds_lookupdisplay
			Return False
		End If
		
		Choose Case ls_column_type[ll_index]
			Case 'datetime'
				For ll_index2 = 1 To UpperBound(ldt_datetime_filter[])
					ldt_datetime[ll_rowcount + ll_index2] = ldt_datetime_filter[ll_index2]
				Next
			Case 'number'
				For ll_index2 = 1 To UpperBound(ldble_double_filter[])
					ldble_double[ll_rowcount + ll_index2] = ldble_double_filter[ll_index2]
				Next
			Case Else
				For ll_index2 = 1 To UpperBound(ls_string_filter[])
					ls_string[ll_rowcount + ll_index2] = ls_string_filter[ll_index2]
				Next
		End Choose
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// Based on the type we know which array to use
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case ls_column_type[ll_index]
		Case 'datetime'
			If UpperBound(ldt_datetime[]) <> ll_rowcount  + ll_filteredcount Then Return False

			//----------------------------------------------------------------------------------------------------------------------------------
			// Since we have to have the named column name to set into, we have to do a case statement
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case ll_index
				Case 1
					lds_lookupdisplay.Object.column1.Primary = ldt_datetime[]
				Case 2
					lds_lookupdisplay.Object.column2.Primary = ldt_datetime[]
				Case 3
					lds_lookupdisplay.Object.column3.Primary = ldt_datetime[]
				Case 4
					lds_lookupdisplay.Object.column4.Primary = ldt_datetime[]
				Case 5
					lds_lookupdisplay.Object.column5.Primary = ldt_datetime[]
				Case 6
					lds_lookupdisplay.Object.column6.Primary = ldt_datetime[]
				Case 7
					lds_lookupdisplay.Object.column7.Primary = ldt_datetime[]
				Case 8
					lds_lookupdisplay.Object.column8.Primary = ldt_datetime[]
				Case 9
					lds_lookupdisplay.Object.column9.Primary = ldt_datetime[]
				Case 10
					lds_lookupdisplay.Object.column10.Primary = ldt_datetime[]
				Case 11
					lds_lookupdisplay.Object.column11.Primary = ldt_datetime[]
				Case 12
					lds_lookupdisplay.Object.column12.Primary = ldt_datetime[]
				Case 13
					lds_lookupdisplay.Object.column13.Primary = ldt_datetime[]
				Case 14
					lds_lookupdisplay.Object.column14.Primary = ldt_datetime[]
				Case 15
					lds_lookupdisplay.Object.column15.Primary = ldt_datetime[]
				Case 16
					lds_lookupdisplay.Object.column16.Primary = ldt_datetime[]
				Case 17
					lds_lookupdisplay.Object.column17.Primary = ldt_datetime[]
				Case 18
					lds_lookupdisplay.Object.column18.Primary = ldt_datetime[]
				Case 19
					lds_lookupdisplay.Object.column19.Primary = ldt_datetime[]
				Case 20
					lds_lookupdisplay.Object.column20.Primary = ldt_datetime[]
			End Choose
			
		Case 'number'
			If UpperBound(ldble_double[]) <> ll_rowcount  + ll_filteredcount Then Return False
			
			//----------------------------------------------------------------------------------------------------------------------------------
			// Since we have to have the named column name to set into, we have to do a case statement
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case ll_index
				Case 1
					lds_lookupdisplay.Object.column1.Primary = ldble_double[]
				Case 2
					lds_lookupdisplay.Object.column2.Primary = ldble_double[]
				Case 3
					lds_lookupdisplay.Object.column3.Primary = ldble_double[]
				Case 4
					lds_lookupdisplay.Object.column4.Primary = ldble_double[]
				Case 5
					lds_lookupdisplay.Object.column5.Primary = ldble_double[]
				Case 6
					lds_lookupdisplay.Object.column6.Primary = ldble_double[]
				Case 7
					lds_lookupdisplay.Object.column7.Primary = ldble_double[]
				Case 8
					lds_lookupdisplay.Object.column8.Primary = ldble_double[]
				Case 9
					lds_lookupdisplay.Object.column9.Primary = ldble_double[]
				Case 10
					lds_lookupdisplay.Object.column10.Primary = ldble_double[]
				Case 11
					lds_lookupdisplay.Object.column11.Primary = ldble_double[]
				Case 12
					lds_lookupdisplay.Object.column12.Primary = ldble_double[]
				Case 13
					lds_lookupdisplay.Object.column13.Primary = ldble_double[]
				Case 14
					lds_lookupdisplay.Object.column14.Primary = ldble_double[]
				Case 15
					lds_lookupdisplay.Object.column15.Primary = ldble_double[]
				Case 16
					lds_lookupdisplay.Object.column16.Primary = ldble_double[]
				Case 17
					lds_lookupdisplay.Object.column17.Primary = ldble_double[]
				Case 18
					lds_lookupdisplay.Object.column18.Primary = ldble_double[]
				Case 19
					lds_lookupdisplay.Object.column19.Primary = ldble_double[]
				Case 20
					lds_lookupdisplay.Object.column20.Primary = ldble_double[]
			End Choose
		Case Else
			If UpperBound(ls_string[]) <> ll_rowcount  + ll_filteredcount Then Return False
			
			//----------------------------------------------------------------------------------------------------------------------------------
			// Since we have to have the named column name to set into, we have to do a case statement
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case ll_index
				Case 1
					lds_lookupdisplay.Object.column1.Primary = ls_string[]
				Case 2
					lds_lookupdisplay.Object.column2.Primary = ls_string[]
				Case 3
					lds_lookupdisplay.Object.column3.Primary = ls_string[]
				Case 4
					lds_lookupdisplay.Object.column4.Primary = ls_string[]
				Case 5
					lds_lookupdisplay.Object.column5.Primary = ls_string[]
				Case 6
					lds_lookupdisplay.Object.column6.Primary = ls_string[]
				Case 7
					lds_lookupdisplay.Object.column7.Primary = ls_string[]
				Case 8
					lds_lookupdisplay.Object.column8.Primary = ls_string[]
				Case 9
					lds_lookupdisplay.Object.column9.Primary = ls_string[]
				Case 10
					lds_lookupdisplay.Object.column10.Primary = ls_string[]
				Case 11
					lds_lookupdisplay.Object.column11.Primary = ls_string[]
				Case 12
					lds_lookupdisplay.Object.column12.Primary = ls_string[]
				Case 13
					lds_lookupdisplay.Object.column13.Primary = ls_string[]
				Case 14
					lds_lookupdisplay.Object.column14.Primary = ls_string[]
				Case 15
					lds_lookupdisplay.Object.column15.Primary = ls_string[]
				Case 16
					lds_lookupdisplay.Object.column16.Primary = ls_string[]
				Case 17
					lds_lookupdisplay.Object.column17.Primary = ls_string[]
				Case 18
					lds_lookupdisplay.Object.column18.Primary = ls_string[]
				Case 19
					lds_lookupdisplay.Object.column19.Primary = ls_string[]
				Case 20
					lds_lookupdisplay.Object.column20.Primary = ls_string[]
			End Choose
	End Choose
Next

For ll_index = 1 To ll_rowcount
	ll_buffer[ll_index] = 1
Next

//JLR and blake - added '+1' and if stmt.  #48630 
If ll_filteredcount > 0 then
	For ll_index = ll_rowcount + 1 To ll_rowcount + ll_filteredcount
		ll_buffer[ll_index] = 2
	Next
end if

lds_lookupdisplay.Object.buffer.Primary = ll_buffer[]

//----------------------------------------------------------------------------------------------------------------------------------
// Put the row array into the row_special column and sort by the sort string
//-----------------------------------------------------------------------------------------------------------------------------------
lds_lookupdisplay.Object.row_special.Primary = ll_row[]
ll_return = lds_lookupdisplay.SetSort(ls_sortstring)
ll_return = lds_lookupdisplay.Sort()

//----------------------------------------------------------------------------------------------------------------------------------
// Now put the row array into the sortrow_special column.  This will create a translation between row_special and sortrow_special
//-----------------------------------------------------------------------------------------------------------------------------------
lds_lookupdisplay.Object.sortrow_special.Primary = ll_row[]
ll_return = lds_lookupdisplay.SetSort('buffer, row_special')
ll_return = lds_lookupdisplay.Sort()

//----------------------------------------------------------------------------------------------------------------------------------
// Put the sort_special column into the datasource and sort by it
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ao_datasource.TypeOf()
	Case Datawindow!
		ldw_datawindow = ao_datasource
		If ll_rowcount > 0 Then
			ldw_datawindow.Object.Data.Primary[1, ll_SortColumn_ColumnNumber, ll_rowcount, ll_SortColumn_ColumnNumber] = lds_lookupdisplay.Object.Data.Primary[1, 2, ll_rowcount, 2]
		End If

		If ll_filteredcount > 0 Then
			ldw_datawindow.Object.Data.Filter[1, ll_SortColumn_ColumnNumber, ll_filteredcount, ll_SortColumn_ColumnNumber] = lds_lookupdisplay.Object.Data.Primary[ll_rowcount + 1, 2, ll_rowcount + ll_filteredcount, 2]
		End If
		
		ll_return = ldw_datawindow.SetSort('SortColumn')
		ll_return = ldw_datawindow.Sort()
		
	Case Datastore!
		lds_datastore = ao_datasource
		If ll_rowcount > 0 Then
			lds_datastore.Object.Data.Primary[1, ll_SortColumn_ColumnNumber, ll_rowcount, ll_SortColumn_ColumnNumber] = lds_lookupdisplay.Object.Data.Primary[1, 2, ll_rowcount, 2]
		End If

		If ll_filteredcount > 0 Then
			lds_datastore.Object.Data.Filter[1, ll_SortColumn_ColumnNumber, ll_filteredcount, ll_SortColumn_ColumnNumber] = lds_lookupdisplay.Object.Data.Primary[ll_rowcount + 1, 2, ll_rowcount + ll_filteredcount, 2]
		End If

		ll_return = lds_datastore.SetSort('SortColumn')
		ll_return = lds_datastore.Sort()
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datatstore
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_lookupdisplay

//----------------------------------------------------------------------------------------------------------------------------------
// Return True
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function boolean of_get_expression_as_array (powerobject ao_datasource, string as_expression, ref string as_string[], ref datetime adt_datetime[], ref double adble_double[], dwbuffer aenum_dwbuffer);//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datawindow			ldw_datawindow
Datastore			lds_datastore
Datastore			lds_copy_datastore
//n_string_functions	ln_string_functions

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_datatype
String	ls_return
String	ls_check_expression

//----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False

//----------------------------------------------------------------------------------------------------------------------------------
// Return true if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case aenum_dwbuffer
	Case Primary!
		If ao_datasource.Dynamic RowCount() <= 0 Then Return True
	Case Filter!
		If ao_datasource.Dynamic FilteredCount() <= 0 Then Return True
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the bitmap function is not used
//-----------------------------------------------------------------------------------------------------------------------------------
ls_check_expression = Trim(as_expression)
If Left(Lower(ls_check_expression), 6) = 'bitmap' Then
	ls_check_expression = Trim(Mid(ls_check_expression, 7))
	
	If Left(ls_check_expression, 1) = '(' Then
		ls_check_expression = Mid(ls_check_expression, 2)
		
		If Right(ls_check_expression, 1) = ')' Then
			ls_check_expression = Left(ls_check_expression, Len(ls_check_expression) - 1)
			as_expression = ls_check_expression
		End If
	End If
End If

gn_globals.in_string_functions.of_replace_all(as_expression, "'", "~~'")

If aenum_dwbuffer = Filter! Then
	lds_copy_datastore = Create Datastore
	ls_return = This.of_apply_syntax(lds_copy_datastore, ao_datasource.Dynamic Describe("Datawindow.Syntax"))
	ao_datasource.Dynamic RowsCopy(1, ao_datasource.Dynamic FilteredCount(), Filter!, lds_copy_datastore, 1, Primary!)
	ao_datasource = lds_copy_datastore
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Create the computed field with the expression
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource.Dynamic Modify(&
"create compute(band=Detail color='0' alignment='0' border='0'" + &
" height.autosize=No pointer='Arrow!' moveable=0 resizeable=0 x='0' y='0' height='0' width='0' format='[general]'" + &
" name=expression_compute2 tag='' expression='" + as_expression + "' font.face='Tahoma' font.height='-8' font.weight='400' font.family='0' font.pitch='0' font.charset='1' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='1' background.color='0' visible='0')") <> '' Then 
	If IsValid(lds_copy_datastore) Then Destroy lds_copy_datastore
	Return False
End If


//----------------------------------------------------------------------------------------------------------------------------------
// If the computed field doesn't exist, return false
//-----------------------------------------------------------------------------------------------------------------------------------
If Not This.of_IsComputedField(ao_datasource, 'expression_compute2') Then
	If IsValid(lds_copy_datastore) Then Destroy lds_copy_datastore
	Return False
End If

//----------------------------------------------------------------------------------------------------------------------------------
// If the computed field isn't valid, destroy it and return false
//-----------------------------------------------------------------------------------------------------------------------------------
If Not This.of_IsComputedFieldValid(ao_datasource, 'expression_compute2') Then
	ao_datasource.Dynamic Modify('Destroy expression_compute2')
	If IsValid(lds_copy_datastore) Then Destroy lds_copy_datastore
	Return False
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the datatype of the column.  If it's 
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Left(Lower(Trim(of_get_columntype(ao_datasource, 'expression_compute2'))), 4)
	Case 'numb','deci','long', 'inte'
		ls_datatype = 'number'
	Case 'date'
		ls_datatype = 'datetime'
	Case Else
		ls_datatype = 'string'
End Choose


//----------------------------------------------------------------------------------------------------------------------------------
// Process differently based on object type, we can't do dot notation without promoting
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ao_datasource.TypeOf()
	Case Datawindow!
		ldw_datawindow = ao_datasource

		//----------------------------------------------------------------------------------------------------------------------------------
		// Pull the array out based on the datatype
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case ls_datatype
			Case 'number'
				adble_double[] = ldw_datawindow.Object.expression_compute2.Primary				
			Case 'datetime'
				adt_datetime[] = ldw_datawindow.Object.expression_compute2.Primary
			Case 'string'
				as_string[] 	= ldw_datawindow.Object.expression_compute2.Primary
		End Choose

		//----------------------------------------------------------------------------------------------------------------------------------
		// Destroy the computed field on the way out
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = ldw_datawindow.Modify("Destroy expression_compute2")

	Case Datastore!
		lds_datastore	= ao_datasource

		//----------------------------------------------------------------------------------------------------------------------------------
		// Pull the array out based on the datatype
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case ls_datatype
			Case 'number'
				adble_double[] = lds_datastore.Object.expression_compute2.Primary				
			Case 'datetime'
				adt_datetime[] = lds_datastore.Object.expression_compute2.Primary
			Case 'string'
				as_string[] 	= lds_datastore.Object.expression_compute2.Primary
		End Choose
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Destroy the computed field on the way out
		//-----------------------------------------------------------------------------------------------------------------------------------
		lds_datastore.Modify("Destroy expression_compute2")
End Choose

If IsValid(lds_copy_datastore) Then Destroy lds_copy_datastore

Return True
end function

public function string of_apply_syntax (powerobject ao_datasource, string as_syntax);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This function will apply syntax to a datawindow while maintaining the data and dropdowns.</Description>
<Arguments>
	<Argument Name="ao_datasource">PowerObject - Should be a datastore or datawindow</Argument>
	<Argument Name="as_syntax">String - Should be valid datawindow syntax</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/26/2000</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Blob 		lblob_state
String	error_create
String	ls_storagepagesize
String	ls_new_storagepagesize
String	ls_error

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_copy_buffer

If Not IsValid(ao_datasource) Then Return 'Datasource was not a valid object'

ls_storagepagesize 	= ao_datasource.Dynamic Describe("Datawindow.storagepagesize")
ls_storagepagesize 	= Trim(Mid(ls_storagepagesize, Pos(ls_storagepagesize, '=') + 1))

//-----------------------------------------------------------------------------------------------------------------------------------
// Generate new DataWindow Object in the actual datawindow if there are zero rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource.Dynamic RowCount() = 0 Then
	ao_datasource.Dynamic Create(as_syntax, error_create)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the storage page size of the newly created datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_new_storagepagesize 	= ao_datasource.Dynamic Describe("Datawindow.storagepagesize")
	ls_new_storagepagesize	= Trim(Mid(ls_new_storagepagesize, Pos(ls_new_storagepagesize, '=') + 1))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If they are different, try to correct it
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ls_new_storagepagesize <> ls_storagepagesize Then
		Choose Case Long(ls_storagepagesize)
			Case Is > 60000
				ls_error = ao_datasource.Dynamic Modify("datawindow.storagepagesize='LARGE'")
			Case Is > 32000
				ls_error = ao_datasource.Dynamic Modify("datawindow.storagepagesize='MEDIUM'")
		End Choose
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If there's an error return it
	//-----------------------------------------------------------------------------------------------------------------------------------
	Return error_create
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_copy_buffer = Create Datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Generate new DataWindow Object in the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_copy_buffer.Create(as_syntax, error_create)

//-----------------------------------------------------------------------------------------------------------------------------------
// If there's an error return it
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(error_create) > 0 Then 
	Destroy lds_copy_buffer
	Return error_create
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Share the data so it will put the data into the new datawindow object
//-----------------------------------------------------------------------------------------------------------------------------------
ao_datasource.Dynamic ShareData(lds_copy_buffer)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the full state then turn off the share data
//-----------------------------------------------------------------------------------------------------------------------------------
lds_copy_buffer.GetFullState(lblob_state)
ao_datasource.Dynamic ShareDataOff()

//-----------------------------------------------------------------------------------------------------------------------------------
// Cache the dropdowns, set the full state, restore them back
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_copy_dropdowndatawindows(ao_datasource, lds_copy_buffer)
ao_datasource.Dynamic SetFullState(lblob_state)
This.of_copy_dropdowndatawindows(lds_copy_buffer, ao_datasource)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the storage page size of the newly created datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_new_storagepagesize 	= ao_datasource.Dynamic Describe("Datawindow.storagepagesize")
ls_new_storagepagesize	= Trim(Mid(ls_new_storagepagesize, Pos(ls_new_storagepagesize, '=') + 1))

//-----------------------------------------------------------------------------------------------------------------------------------
// If they are different, try to correct it
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_new_storagepagesize <> ls_storagepagesize Then
	Choose Case Long(ls_storagepagesize)
		Case Is > 60000
			ls_error = ao_datasource.Dynamic Modify("datawindow.storagepagesize='LARGE'")
		Case Is > 32000
			ls_error = ao_datasource.Dynamic Modify("datawindow.storagepagesize='MEDIUM'")
	End Choose
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects we don't need 
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_copy_buffer
Return ''
end function

public function boolean of_column_exists (ref powerobject ao_powerobject, string as_columnobjectname);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will determine if a computed field or column object exists on a datawindow/datastore.</Description>
<Arguments>
	<Argument Name="ao_powerobject">PowerObject - Should be a datastore or datawindow</Argument>
	<Argument Name="as_columnobjectname">String - Should be column or computed field name</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/26/2000</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if not isvalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_powerobject) Or IsNull(ao_powerobject) Then Return False

Return IsNumber(ao_powerobject.Dynamic Describe(as_columnobjectname + '.X'))
end function

public function boolean of_copy_datawindow (ref powerobject ao_source, ref powerobject ao_destination);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will copy the syntax and data from one datawindow/datastore to another.</Description>
<Arguments>
	<Argument Name="ao_source">PowerObject - Should be a datastore or datawindow</Argument>
	<Argument Name="ao_destination">PowerObject - Should be a datastore or datawindow</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/26/2000</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/


String ls_error, ls_syntax
String	ls_origin_pagesize
String	ls_destination_pagesize

If Not IsValid(ao_source) Or Not IsValid(ao_destination) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the destination if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_destination.Dynamic RowCount() > 0 Then
	ao_destination.Dynamic Reset()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the object from syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ao_source.Dynamic Describe("Datawindow.Syntax")

ls_error = This.of_apply_syntax(ao_destination, ls_syntax)

If ls_error <> '' Then Return False

ls_origin_pagesize 		= ao_source.Dynamic Describe("Datawindow.storagepagesize")
ls_destination_pagesize = ao_destination.Dynamic Describe("Datawindow.storagepagesize")

If ls_origin_pagesize <> ls_destination_pagesize Then
	ls_origin_pagesize = Trim(Mid(ls_origin_pagesize, Pos(ls_origin_pagesize, '=') + 1))
	
	Choose Case Long(ls_origin_pagesize)
		Case Is > 64000
			ls_error = ao_destination.Dynamic Modify("datawindow.storagepagesize='LARGE'")
		Case Is > 32000
			ls_error = ao_destination.Dynamic Modify("datawindow.storagepagesize='MEDIUM'")
	End Choose
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Import the rows
//-----------------------------------------------------------------------------------------------------------------------------------
Return ao_source.Dynamic RowsCopy(1, ao_source.Dynamic RowCount(), Primary!, ao_destination, 1, Primary!) > 0
//Return ao_destination.Dynamic ImportString(ao_source.Dynamic Describe("Datawindow.Data")) > 0

end function

public function boolean of_copy_dropdowndatawindow (ref powerobject ao_source, string as_sourcecolumn, ref powerobject ao_destination, string as_destinationcolumn);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will copy the dropdown data on a column data from one datawindow/datastore to another.</Description>
<Arguments>
	<Argument Name="ao_source">PowerObject - Should be a datastore or datawindow</Argument>
	<Argument Name="as_sourcecolumn">String - This is the from column name</Argument>
	<Argument Name="ao_destination">PowerObject - Should be a datastore or datawindow</Argument>
	<Argument Name="as_destinationcolumn">String - This is the to column name</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/26/2000</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_columnnumber
Long		ll_return 
String 	ls_name

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
DatawindowChild 	ldwc_source
DatawindowChild 	ldwc_destination

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
ll_columnnumber 	= Long(ao_source.Dynamic Describe(as_sourcecolumn + ".ID"))
ls_name 				= ao_source.Dynamic Describe("#" + string(ll_columnnumber) + ".dddw.name"			)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the dropdowndatawindowname is not valid, return false
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_name = '!' Or ls_name = '?' Or Trim(as_sourcecolumn) = '' Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get both datawindowchildren
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = 	ao_source.		Dynamic GetChild(as_sourcecolumn, 		ldwc_source)
ll_return += 	ao_destination.Dynamic GetChild(as_destinationcolumn, ldwc_destination)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't get both children
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_return <> 2 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return true if there is no work to do
//-----------------------------------------------------------------------------------------------------------------------------------
If ldwc_destination.RowCount() = ldwc_source.RowCount() And ldwc_destination.FilteredCount() = ldwc_source.FilteredCount() Then Return True

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the destination if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If ldwc_destination.RowCount() + ldwc_destination.FilteredCount() > 0 Then ldwc_destination.Reset()

//-----------------------------------------------------------------------------------------------------------------------------------
// Copy the rows from one dropdown to another
//-----------------------------------------------------------------------------------------------------------------------------------
ldwc_source.RowsCopy(1, ldwc_source.RowCount(), Primary!, ldwc_destination, 1, Primary!)
//ldwc_destination.ImportString(ldwc_source.Describe("Datawindow.Data"))
ldwc_source.RowsCopy(1, ldwc_source.FilteredCount(), Filter!, ldwc_destination, 1, Filter!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function boolean of_copy_dropdowndatawindows (ref powerobject ao_source, ref powerobject ao_destination);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will copy the dropdown data on all columns from one datawindow/datastore to another.</Description>
<Arguments>
	<Argument Name="ao_source">PowerObject - Should be a datastore or datawindow</Argument>
	<Argument Name="ao_destination">PowerObject - Should be a datastore or datawindow</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/26/2000</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_columns[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns on the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_objects(ao_source, 'column', ls_columns[], False)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and share them
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 to UpperBound(ls_columns[])
	This.of_copy_dropdowndatawindow(ao_source, ls_columns[ll_index], ao_destination, ls_columns[ll_index])
Next

Return True
end function

public function string of_copy_property (ref powerobject ao_source, ref powerobject ao_destination, string as_object, string as_property);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_copy_property()
//	Overview:   This will copy a property from one object to another
//	Created by:	Blake Doerr
//	History: 	5/15/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return
String	ls_modify

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there is a problem
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_source) Then Return 'Error:  Source Object was not valid'
If Not IsValid(ao_destination) Then Return 'Error:  Source Object was not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the original property
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = ao_source.Dynamic Describe(as_object + '.' + as_property)

//-----------------------------------------------------------------------------------------------------------------------------------
// If it's already an expression, pull the quotes off
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(ls_modify, '~t') > 0 And (Left(ls_modify, 1) = '"' And Right(ls_modify, 1) = '"') Or (Left(ls_modify, 1) = "'" And Right(ls_modify, 1) = "'") Then
	ls_modify = Left(ls_modify, Len(ls_modify) - 1)
	ls_modify = Right(ls_modify, Len(ls_modify) - 1)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the quotes
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(ls_modify, "'", "~~'")

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the entire modify string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = as_object + '.' + as_property + '=~'' + ls_modify + '~''

//-----------------------------------------------------------------------------------------------------------------------------------
// Modify the expression
//-----------------------------------------------------------------------------------------------------------------------------------
Return ao_destination.Dynamic Modify(ls_modify)
end function

public function string of_create_report_syntax (string as_sql, string as_title, transaction axctn_transaction);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_report_syntax()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
Long			ll_index
Long			ll_index2
Long			ll_upperbound
Long			ll_last_valid_column
Long			ll_pos
Long			ll_pos2
Long			ll_last_x
Long			ll_last_width
Long			ll_id
String		ls_SQL
String		ls_modify
String		ls_syntax
String		ls_error
String		ls_dbname
String		ls_column[]
String		ls_header[]
String		ls_headertext[]
String		ls_columntype[]
String		ls_argument_sql[]
String		ls_argument_datatype[]
Integer		ll_width
Integer		ll_height

datastore 								lds_report
datastore								lds_arguments
datastore								lds_datawindows
datastore								lds_formattedcolumns 	
datastore								lds_customsqltemplatedatawindow
datastore								lds_templatedatastore
datastore								lds_empty
statictext 								lst_text
n_gettextsize							ln_gettextsize
//n_string_functions					ln_string_functions
n_datastore_tools						ln_datastore_tools
n_datawindow_formatting_service	ln_datawindow_formatting_service
Window									lw_invisible

SetPointer(HourGlass!)

ls_SQL = as_SQL

If Not IsValid(axctn_transaction) Then Return 'A connection to the report database could not be established'

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the data object using the SQL.
//-----------------------------------------------------------------------------------------------------------------------------------
If Left(Lower(Trim(ls_SQL)), 6) = 'select' Then
	ls_syntax = axctn_transaction.syntaxfromsql(ls_SQL, '', ls_error)
Else
	If Lower(Trim(ls_SQL)) = 'sp_report_dynamic' Then
		ls_syntax = axctn_transaction.syntaxfromsql('execute ' + ls_SQL + ';1 @c_ForCompileOnly = "Y"', '', ls_error)		
	Else
		ls_syntax = axctn_transaction.syntaxfromsql('execute ' + ls_SQL + ';1', '', ls_error)
	End If
End If

If Not IsNull(ls_error) And Len(Trim(ls_error)) > 0 And Trim(ls_error) <> '' Then Return 'ERROR:  Could not create GUI for provision (' + ls_error + ')'

lds_report = Create datastore
lds_report.Create(ls_syntax)
lds_customsqltemplatedatawindow = Create Datastore
lds_customsqltemplatedatawindow.Create(ls_syntax)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the line header.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = ls_modify + "create line(band=header x1='78' y1='184' x2='1000' y2='184' name=line_header pen.style='0' pen.width='5' pen.color='12632256' background.mode='2' background.color='79741120')~t"

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the line footer.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = ls_modify + "create line(band=footer x1='78' y1='0' x2='1000' y2='0' name=line_footer pen.style='0' pen.width='5' pen.color='12632256' background.mode='2' background.color='79741120')~t"

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the report title.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(as_title, "'", "~~'")
ls_modify = ls_modify + "create text(band=header alignment='0' text='" + as_title + "' border='0' color='0' x='187' y='32' height='52' width='2000'  name=report_title  font.face='Tahoma' font.height='-8' font.weight='700'  font.family='2' font.pitch='2' font.charset='0' background.mode='1' background.color='553648127')~t"

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the report bitmap.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = ls_modify + "create bitmap(band=header filename='Module - SmartSearch - Small Icon (White).bmp' x='101' y='28' height='64' width='73' border='0'  name=report_bitmap)~t"

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the report footer.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = ls_modify + "create compute(band=footer alignment='0' expression='~"Created By CustomerFocus on ~" + String(DateTime(Today(), Now()), ~"mmm d, yyyy h:mm am/pm~")' border='0' color='0' x='91' y='12' height='52' width='2834' format='[GENERAL]'  name=report_footer  font.face='Tahoma' font.height='-8' font.weight='700'  font.family='2' font.pitch='2' font.charset='0' background.mode='1' background.color='536870912')~t"

//-----------------------------------------------------------------------------------------------------------------------------------
// Modify the Band heights.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_modify = ls_modify + "DataWindow.Header.Height='192'~t"
ls_modify = ls_modify + "DataWindow.Detail.Height='60'~t"
ls_modify = ls_modify + "DataWindow.Summary.Height='0'~t"
ls_modify = ls_modify + "DataWindow.Footer.Height='72'~t"
lds_report.Modify(ls_modify)
ls_modify = ''

ln_datawindow_formatting_service	= Create n_datawindow_formatting_service
ln_datawindow_formatting_service.of_init(lds_report)

lds_formattedcolumns 		= Create datastore
lds_datawindows 				= Create datastore
lds_datawindows.DataObject = 'd_columnselectiontable_dw_for_column'
lds_datawindows.SetTransObject(sqlca)

This.of_get_columns(lds_report, ls_column[], ls_header[], ls_headertext[], ls_columntype[])

For ll_index = 1 To UpperBound(ls_column[])
	ls_modify = ls_modify + "destroy " + ls_column[ll_index] + "~t"
	ls_modify = ls_modify + "destroy " + ls_header[ll_index] + "~t"
Next

lds_report.Modify(ls_modify)
ls_modify = ''
	
For ll_index = 1 To UpperBound(ls_column[])
	Choose Case Lower(Trim(ls_column[ll_index])) 
		Case	'selectrowindicator', 'rowfocusindicator', 'expanded', 'sortcolumn'
			Continue
		Case	Else
	End Choose

	lds_datawindows.Retrieve(ls_column[ll_index])
	
	lds_templatedatastore = lds_empty
	
	For ll_index2 = 1 To lds_datawindows.RowCount()
		lds_formattedcolumns.DataObject = lds_datawindows.getitemstring(ll_index2, 'datawindowobjectname')
		
		If This.of_iscolumn(lds_formattedcolumns, ls_column[ll_index]) Then
			lds_templatedatastore = lds_formattedcolumns
			Exit
		End If
	Next

	If lds_templatedatastore = lds_empty Then
		lds_templatedatastore = lds_customsqltemplatedatawindow
	End If

	ls_dbname = lds_report.Describe(ls_column[ll_index] + '.dbname')


	ln_datawindow_formatting_service.of_add_external_column(ls_column[ll_index], ls_dbname, This.of_get_column_header(lds_templatedatastore, ls_column[ll_index]), lds_templatedatastore, False, '', True)

	lds_report.Modify(ls_column[ll_index] + ".tag=''")
Next	

lds_report.Modify("Destroy additionalcolumnsinit")

n_rowfocus_service ln_rowfocus_service
ln_rowfocus_service = Create n_rowfocus_service
ln_rowfocus_service.of_init(lds_report)
ln_rowfocus_service.Event ue_notify('columnresize', '')
Destroy ln_rowfocus_service
ls_syntax 	= lds_report.Describe('DataWindow.Syntax')

Destroy lds_datawindows
Destroy lds_formattedcolumns 	
Destroy lds_customsqltemplatedatawindow
Destroy ln_datawindow_formatting_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the arguments to the procedure. 
//-----------------------------------------------------------------------------------------------------------------------------------
If Left(Lower(Trim(ls_SQL)), 6) <> 'select' Then
	
	Select ID Into :ll_id From sysobjects (NoLock) Where Type = 'p' And Name = :ls_sql Using sqlca;
	If IsNull(ll_id) Then Return 'ERROR: Could not find procedure name in list of procedures on the database'
	
	ln_datastore_tools = Create n_datastore_tools
	If Not ln_datastore_tools.of_create_datastore_object('Select Name, type_name(xusertype) datatype From syscolumns (NoLock) Where ID = ' + String(ll_id) + ' Order By colorder', lds_arguments, sqlca) Then
		Destroy ln_datastore_tools
		Return 'Could not determine procedure arguments for syntax construction'
	End If
	Destroy ln_datastore_tools
	
	This.of_get_array_from_column(lds_arguments, 'name', ls_argument_sql[])
	This.of_get_array_from_column(lds_arguments, 'datatype', ls_argument_datatype[])

	ls_SQL = 'procedure="1 execute dbo.' + ls_SQL + ';1 '

	For ll_index = 1 To UpperBound(ls_argument_sql[])
		If Lower(ls_argument_sql[ll_index]) = '@i_rprtcnfgid' 			Then Continue
		If Lower(ls_argument_sql[ll_index]) = '@vc_additionalcolumns' 	Then Continue
		If Lower(ls_argument_sql[ll_index]) = '@c_onlyshowsql' 			Then Continue
		If Lower(ls_argument_sql[ll_index]) = '@c_forcompileonly' 		Then Continue		
		ls_SQL = ls_SQL + ls_argument_sql[ll_index] + ' = :' + Mid(ls_argument_sql[ll_index], 2) + ','
	Next
	
	ls_SQL = Left(ls_SQL, Len(ls_SQL) - 1) + '" arguments=('
	For ll_index = 1 To UpperBound(ls_argument_sql[])
		
		If Lower(ls_argument_sql[ll_index]) = '@i_rprtcnfgid' 			Then Continue
		If Lower(ls_argument_sql[ll_index]) = '@vc_additionalcolumns' 	Then Continue
		If Lower(ls_argument_sql[ll_index]) = '@c_onlyshowsql' 			Then Continue
		If Lower(ls_argument_sql[ll_index]) = '@c_forcompileonly' 		Then Continue

		Choose Case Lower(Trim(ls_argument_datatype[ll_index]))
			Case	'smalldatetime', 'datetime'
				ls_SQL = ls_SQL + '("' + Mid(ls_argument_sql[ll_index], 2) + '", datetime),'
			Case	'char', 'varchar', 'text', 'nchar', 'nvarchar', 'ntext'
				ls_SQL = ls_SQL + '("' + Mid(ls_argument_sql[ll_index], 2) + '", string),'
			Case	Else
				ls_SQL = ls_SQL + '("' + Mid(ls_argument_sql[ll_index], 2) + '", number),'
		End Choose
	Next
	ls_SQL = Left(ls_SQL, Len(ls_SQL) - 1) + ')'
	
	ll_pos 		= Pos(ls_syntax, 'procedure=')
	ll_pos2		= ll_pos + Pos(Mid(ls_syntax, ll_pos), '~r~n') - 1
	ls_syntax	= Mid(ls_syntax, 1, ll_pos - 1) + ls_SQL + Mid(ls_syntax, ll_pos2)
End If

Return ls_syntax
end function

public function long of_find_row (ref powerobject ao_datasource, string as_column, string as_value, long al_startrow, long al_endrow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_findrow()
//	Arguments:  ao_datasource, as_column, as_value, al_startrow, al_endrow
//	Overview:   This script will perform a Find function on the datawindow, given the arguments.  It will handle 
//					handle various column types.
//	Created by:	Denton Newham
//	History: 	1/18/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_row
string ls_type, ls_find
datawindow ldw_data
datastore lds_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the datawindow/datastore.
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource.TypeOf() = datawindow! Then
	ldw_data = ao_datasource
	ls_type = ldw_data.Describe(as_column+".Coltype")
ElseIf ao_datasource.TypeOf() = datastore! Then
	lds_data = ao_datasource
	ls_type = lds_data.Describe(as_column+".Coltype")
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','deci','long'
		ls_find = as_column + "=" + as_value 

	Case 'char', 'date', 'stri'
		ls_find = as_column + "='" + as_value + "'"

End Choose

If IsValid(ldw_data) Then
	ll_row = ldw_data.Find(ls_find, al_startrow, al_endrow)
ElseIf IsValid(lds_data) Then
	ll_row = lds_data.Find(ls_find, al_startrow, al_endrow)
End If

Return ll_row
end function

public function adoresultset of_get_adoresultset (powerobject ao_datasource);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will get an ADOResultSet object from a datawindow/datastore.</Description>
<Arguments>
	<Argument Name="ao_datasource">PowerObject - Should be a datastore or datawindow</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>6/26/2000</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
ResultSet lrs_resultset
ADOresultset lrs_ADOresultset
OLEObject loo_ADOrecordset
n_xml ln_xml

//-----------------------------------------------------------------------------------------------------------------------------------
// Generate a result set from an existing DataSource
//-----------------------------------------------------------------------------------------------------------------------------------
lrs_resultset = This.of_get_resultset(ao_datasource)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't get a valid recordset
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lrs_resultset) Then Return lrs_ADOresultset

//-----------------------------------------------------------------------------------------------------------------------------------
// Create a new ADOResultSet object and populate it
// from the generated result set
//-----------------------------------------------------------------------------------------------------------------------------------
lrs_ADOresultset = CREATE ADOResultSet
lrs_ADOResultset.SetResultSet(lrs_resultset)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the object
//-----------------------------------------------------------------------------------------------------------------------------------
Return lrs_ADOResultset


end function

public subroutine of_get_columns (powerobject ao_datasource, ref string as_columnname[], ref string as_headername[], ref string as_headertext[], ref string as_columntype[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_columns()
//	Arguments:  ao_datasource
//					as_columnname[]
//					as_headername[]
//					as_headertext[]
//					as_columntype[]
//	Overview:   This will get all the valid columns for the datawindow
//	Created by:	Blake Doerr
//	History: 	11/20/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
Long		ll_object_count
Long		ll_index
Long		ll_upperbound
String	ls_all_objects
String	ls_object[]
String	ls_describe_types
String	ls_columnname
String	ls_headername
String	ls_headertext
String	ls_columntype
String	ls_types
String	ls_type[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Leave if the arguments aren't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the objects in the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_all_objects = ao_datasource.Dynamic Describe("Datawindow.Objects")
gn_globals.in_string_functions.of_parse_string(ls_all_objects, "~t", ls_object[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all objects and build describe statements that will get the band and type of each object
//-----------------------------------------------------------------------------------------------------------------------------------
ll_object_count = upperbound(ls_object[])

FOR ll_index = 1 TO ll_object_count
	if ls_describe_types > '' then
		ls_describe_types = ls_describe_types + "~t"
	end if
	ls_describe_types = ls_describe_types + ls_object[ll_index] + ".type"
NEXT

//-----------------------------------------------------------------------------------------------------------------------------------
// Describe the types and put them into an array
//-----------------------------------------------------------------------------------------------------------------------------------
ls_types = ao_datasource.Dynamic Describe( ls_describe_types)
gn_globals.in_string_functions.of_parse_string(ls_types, "~n", ls_type[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Describe the types and put them into an array
//-----------------------------------------------------------------------------------------------------------------------------------
ll_object_count = Min(UpperBound(ls_type[]), ll_object_count)

//-----------------------------------------------------------------------------------------------------------------------------------
// For all text types, try to find the column associated with it
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_object_count
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If this isn't a text continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Lower(Trim(ls_type[ll_index])) <> 'text' And Lower(Trim(ls_type[ll_index])) <> 'compute' Then Continue

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the column name associated with this header
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_columnname		= This.of_get_column(ao_datasource, ls_object[ll_index])

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we didn't find a column, continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsNull(ls_columnname) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the headername, text and column type
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_headername 		= ls_object[ll_index]
	ls_headertext		= ao_datasource.Dynamic Describe(ls_object[ll_index] + '.Text')
	ls_columntype		= This.of_get_columntype(ao_datasource, ls_columnname)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If all the data isn't valid continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(Trim(ls_headertext)) = 0 Or IsNull(ls_headertext) Or ls_headertext = '!' Then Continue
	If Len(Trim(ls_columntype)) = 0 Or IsNull(ls_columntype) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the information to the arrays
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_upperbound = UpperBound(as_columnname[]) + 1
	as_columnname[ll_upperbound]		= ls_columnname
	as_headername[ll_upperbound]		= ls_headername
	as_headertext[ll_upperbound]		= ls_headertext
	as_columntype[ll_upperbound]		= ls_columntype
Next



end subroutine

public subroutine of_get_columns_all (powerobject ao_datasource, ref string as_columnname[], ref string as_headername[], ref string as_headertext[], ref string as_columntype[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_columns()
//	Arguments:  ao_datasource
//					as_columnname[]
//					as_headername[]
//					as_headertext[]
//					as_columntype[]
//	Overview:   This will get all the valid columns for the datawindow
//	Created by:	Blake Doerr
//	History: 	11/20/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
Long		ll_object_count
Long		ll_index,ll_index2,ll_count
Long		ll_upperbound
String	ls_band
String	ls_all_objects
String	ls_object[]
String	ls_describe_types
String	ls_columnname
String	ls_headername
String	ls_headertext
String	ls_columntype
String	ls_types
String	ls_type[]
Boolean 	lb_sorted
String	ls_columnname_Temp

//-----------------------------------------------------------------------------------------------------------------------------------
// Leave if the arguments aren't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return

ls_all_objects = ao_datasource.Dynamic Describe("Datawindow.Objects")
gn_globals.in_string_functions.of_parse_string(ls_all_objects, "~t", ls_object[])


//-----------------------------------------------------------------------------------------------------------------------------------
// Always Sort the objects in reverse length order to avoid replaces that may duplicate a subset of the column name.
//-----------------------------------------------------------------------------------------------------------------------------------
lb_sorted = false
do while not lb_sorted
	lb_sorted = true
   for ll_index = 1 to upperbound(ls_object) - 1
       if len(ls_object [ ll_index ]) < len( ls_object[ll_index + 1] ) then
          ls_columnname_Temp = ls_object[ll_index]
          ls_object[ll_index] = ls_object[ ll_index + 1]
          ls_object[ll_index + 1] = ls_columnname_Temp
          lb_sorted = false
       end if
   next
loop




//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all objects and build describe statements that will get the band and type of each object
//-----------------------------------------------------------------------------------------------------------------------------------
ll_object_count = upperbound(ls_object[])

FOR ll_index = 1 TO ll_object_count
	if ls_describe_types > '' then
		ls_describe_types = ls_describe_types + "~t"
	end if
	ls_describe_types = ls_describe_types + ls_object[ll_index] + ".type"
NEXT

//-----------------------------------------------------------------------------------------------------------------------------------
// Describe the types and put them into an array
//-----------------------------------------------------------------------------------------------------------------------------------
ls_types = ao_datasource.Dynamic Describe( ls_describe_types)
gn_globals.in_string_functions.of_parse_string(ls_types, "~n", ls_type[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Describe the types and put them into an array
//-----------------------------------------------------------------------------------------------------------------------------------
ll_object_count = Min(UpperBound(ls_type[]), ll_object_count)

//-----------------------------------------------------------------------------------------------------------------------------------
// For all text types, try to find the column associated with it
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_object_count
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If this isn't a column or compute in the detail band, then continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Lower(Trim(ls_type[ll_index])) <> 'column' And Lower(Trim(ls_type[ll_index])) <> 'compute' Then Continue
	ls_band = Lower(Trim(ao_datasource.Dynamic Describe(ls_object[ll_index] + '.Band')))
	If Left(ls_band, Len('header')) = 'header' Or Left(ls_band, Len('footer')) = 'footer' Or Left(ls_band, Len('summary')) = 'summary' Then Continue

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the column name associated with this header
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_columnname		= ls_object[ll_index]
	ls_headername		= This.of_get_column_headername(ao_datasource, ls_columnname)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Try to get the header text
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(ls_headername) > 0 And ls_headername <> '!' And ls_headername <> '?' Then
		ls_headertext		= This.of_get_column_header(ao_datasource, ls_columnname)
	Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If we didn't get the text, do the best we can by getting the DBName if possible and translating it to english
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Lower(Trim(ls_type[ll_index])) = 'column' Then
			ls_headertext = ao_datasource.Dynamic Describe(ls_object[ll_index] + '.DBName')
			If Pos(ls_headertext, '.') > 0 Then ls_headertext = Mid(ls_headertext, Pos(ls_headertext, '.') + 1)
		Else
			ls_headertext = ls_columnname
		End If
		

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add -Hidden to the column in case a visible column has the same text description
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_headertext = This.of_translate_to_english(ls_headertext)  + "-hidden"
		
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the HeaderText is already used, lets generate a number to put on the end to make it unique.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_count = 1
	for ll_index2 = 1 to upperbound(as_headertext)
		if as_headertext[ll_index2]	 = ls_headertext then
			ll_count ++
		end if
	next
	
	if ll_count > 1 then 
		ls_headertext = ls_headertext + string(ll_count)
	end if

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the headername, text and column type
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_columntype		= This.of_get_columntype(ao_datasource, ls_columnname)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If all the data isn't valid continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(Trim(ls_columntype)) = 0 Or IsNull(ls_columntype) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the information to the arrays
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_upperbound = UpperBound(as_columnname[]) + 1
	as_columnname[ll_upperbound]		= ls_columnname
	as_headername[ll_upperbound]		= ls_headername
	as_headertext[ll_upperbound]		= ls_headertext
	as_columntype[ll_upperbound]		= ls_columntype
Next



end subroutine

public function boolean of_isvisible (powerobject ao_datasource, string as_objectname);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will determine if a datawindow object is visible</Description>
<Arguments>
	<Argument Name="ao_datasource">PowerObject - This is the valid datawindow/datastore</Argument>
	<Argument Name="as_objectname">String - The datawindow object name</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>9/18/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow is not valid or the object is not the right type
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False
Choose Case ao_datasource.TypeOf()
	Case Datawindow!, Datastore!, DatawindowChild!
	Case Else
		Return False
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there is no graphic object associated with the column
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(ao_datasource.Dynamic Describe(as_objectname + '.Type')))
	Case 'column'
		If Not IsNumber(ao_datasource.Dynamic Describe(as_objectname + '.X')) Then Return False
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the tabs with .Visible so we can describe all the types in batch
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ao_datasource.Dynamic Describe(as_objectname + '.Visible')

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace single quotes in those attributes with double quotes to prevent syntax failure
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(ls_return, "'", '"')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return whether or not the object is visible
//-----------------------------------------------------------------------------------------------------------------------------------
Return Not ls_return = '0' Or Mid(ls_return, 2, 2) = '~t0'
end function

public subroutine of_apply_expressions (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_apply_expressions()
// Overview:    This will apply special expressions to the datawindow
// Created by:  Blake Doerr
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_index2
String 	ls_return
String	ls_modify
String	ls_tag
String	ls_property[]
String	ls_attribute
String 	ls_columns[]
String 	ls_expression
String	ls_specialexpression_objects


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// if the datawindow is valid, check for services
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Pull the expression off the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = This.of_get_expression(ao_datasource, 'expressioninit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the string is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ls_expression) Or Len(ls_expression) = 0 Or ls_expression = '!' Or ls_expression = '?' Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get rid of all tildes and double quotes
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(ls_expression, '~~', '')
gn_globals.in_string_functions.of_replace_all(ls_expression, '"', '')
gn_globals.in_string_functions.of_replace_all(ls_expression, '~'', '')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the objects string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_specialexpression_objects 	= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'expressionobjects'))

If Len(Trim(ls_specialexpression_objects)) = 0 Or IsNull(ls_specialexpression_objects) Then
	ls_specialexpression_objects = ls_expression
End If

gn_globals.in_string_functions.of_parse_string(ls_specialexpression_objects, ',', ls_columns[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the expression objects and their properties and try to set them
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columns[])
	If Len(ls_columns[ll_index]) <= 0 Or IsNull(ls_columns[ll_index]) Then Continue
	
	ls_tag = ao_datasource.Dynamic Describe(ls_columns[ll_index] + '.Tag')
	
	gn_globals.in_string_functions.of_parse_string(ls_tag, '||', ls_property[])
	
	For ll_index2 = 1 To UpperBound(ls_property[])
		If Not Pos(ls_property[ll_index2], '=') > 0 Then Continue
		
		ls_attribute = Trim(Left(ls_property[ll_index2], Pos(ls_property[ll_index2], '=') - 1))
		ls_property[ll_index2] = Trim(Mid(ls_property[ll_index2], Pos(ls_property[ll_index2], '=') + 1))

		ls_return = ao_datasource.Dynamic Describe("Evaluate('" + ls_property[ll_index2] + "', 1)")
		
		If Not IsNumber(ls_return) Then Continue
		
		ls_modify = ls_columns[ll_index] + '.' + ls_attribute + "='" + ls_return + "'"
		ls_return = ao_datasource.Dynamic Modify(ls_modify)
	Next
Next
end subroutine

public function boolean of_get_objects (powerobject ao_datasource, string as_objecttype, ref string as_object[], boolean ab_visible_objects_only);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_objects()
//	Arguments:  ao_datasource 				- The source dataobject
//					as_objecttype 				- The property to get
//					as_object[]					- The Objects by reference
//					ab_visible_objects_only	- Get only Visible objects
//	Overview:   This will get all the properties in batch for datawindow objects.  It will handle objects that do not
//						have properties to prevent an error
//	Created by:	Blake Doerr
//	History: 	2/28/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_upperbound
Long		ll_index
String	ls_objects
String	ls_object[]
String	ls_property_describes[]
String	ls_type_describes[]
String	ls_visible_describes[]
String	ls_describe

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the objects from the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_objects = ao_datasource.Dynamic Describe("Datawindow.Objects")

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the objects into an array
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_objects, "~t", ls_object[])	

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the tabs with .Type so we can describe all the types in batch
//-----------------------------------------------------------------------------------------------------------------------------------
ls_describe	= ls_objects + '~t'
gn_globals.in_string_functions.of_replace_all(ls_describe, '~t', '.Type~t')
ls_describe = Left(ls_describe, Len(ls_describe) - 1)
ls_describe = Lower(ao_datasource.Dynamic Describe(ls_describe))

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the types into an array
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_describe, "~n", ls_type_describes[])
ll_upperbound = Min(UpperBound(ls_object[]), UpperBound(ls_type_describes[]))

If ab_visible_objects_only Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace the tabs with .Visible so we can describe all the types in batch
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_describe	= ls_objects + '~t'
	gn_globals.in_string_functions.of_replace_all(ls_describe, '~t', '.Visible~t')
	ls_describe = Left(ls_describe, Len(ls_describe) - 1)
	ls_describe = Lower(ao_datasource.Dynamic Describe(ls_describe))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Replace single quotes in those attributes with double quotes to prevent syntax failure
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_replace_all(ls_describe, "'", '"')

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse the objects and the types into parallel arrays
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(ls_describe, "~n", ls_visible_describes[])
	
	ll_upperbound = Min(ll_upperbound, UpperBound(ls_visible_describes[]))
End If		

ls_objects = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the objects and exclude or include certain types in the rebuilt object string
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If Pos(',' + Lower(Trim(as_objecttype)) + ',', ',' + Lower(Trim(ls_type_describes[ll_index])) + ',') <= 0 Then Continue
	
	If ab_visible_objects_only Then
		If ls_visible_describes[ll_index] = '0' Or Mid(ls_visible_describes[ll_index], 2, 2) = '~t0' Then Continue
	End If
	
	as_object[UpperBound(as_object[]) + 1] = ls_object[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Return True

end function

public function boolean of_get_all_object_property (powerobject ao_datasource, string as_property, ref string as_object[], ref string as_value[], boolean ab_visible_objects_only);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will get all the properties in batch for datawindow objects.  It will handle objects that do not have properties to prevent an error</Description>
<Arguments>
	<Argument Name="ao_datasource">PowerObject - Should be a datastore or datawindow</Argument>
	<Argument Name="as_property">String - The property to get</Argument>
	<Argument Name="as_object[]">String Array - The objects by reference, this will be populated by the function or you can pass them in</Argument>
	<Argument Name="as_value[]">String Array - The values by reference, this will be populated by the function</Argument>
	<Argument Name="ab_visible_objects_only">Boolean - If you pass in an empty object array, it will use this variable</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>2/28/2001</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_upperbound
Long		ll_index
String	ls_objects
String	ls_object[]
String	ls_property_describes[]
String	ls_type_describes[]
String	ls_visible_describes[]
String	ls_describe
String	ls_object_exclude	= ''
String	ls_object_include	= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Trim the property and make sure that it has a period
//-----------------------------------------------------------------------------------------------------------------------------------
as_property = Trim(as_property)
If Left(as_property, 1) <> '.' Then as_property = '.' + as_property

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the value array passed by reference is empty
//-----------------------------------------------------------------------------------------------------------------------------------
as_value[]	= ls_object[]

//-----------------------------------------------------------------------------------------------------------------------------------
// If objects were already supplied, use them instead
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(as_object[]) = 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get all the objects from the datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_objects = ao_datasource.Dynamic Describe("Datawindow.Objects") + '~t'
Else
	For ll_index = 1 To UpperBound(as_object[])
		ls_objects = ls_objects + as_object[ll_index] + '~t'
	Next
	
	as_object[] = ls_object[]
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Based on the property, we need to exclude or include certain object types
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(as_property)
	Case '.x', '.y', '.width', '.height'
		ls_object_exclude = 'line'
	Case '.x1', '.x2', '.y1', '.y2'
		ls_object_include	= 'line'
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are excluding or including, we must do some work to get rid of objects
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_object_exclude) > 0 Or Len(ls_object_include) > 0 Or ab_visible_objects_only Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse the objects into an array
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(Left(ls_objects, Len(ls_objects) - 1), "~t", ls_object[])	
	ll_upperbound = UpperBound(ls_object[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// 
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(ls_object_exclude) > 0 Or Len(ls_object_include) > 0 Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace the tabs with .Type so we can describe all the types in batch
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_describe	= ls_objects
		gn_globals.in_string_functions.of_replace_all(ls_describe, '~t', '.Type~t')
		ls_describe = Lower(ao_datasource.Dynamic Describe(Left(ls_describe, Len(ls_describe) - 1)))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Parse the types into an array
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_parse_string(ls_describe, "~n", ls_type_describes[])
		ll_upperbound = Min(ll_upperbound, UpperBound(ls_type_describes[]))
	End If
	
	If ab_visible_objects_only Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace the tabs with .Visible so we can describe all the types in batch
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_describe	= ls_objects
		gn_globals.in_string_functions.of_replace_all(ls_describe, '~t', '.Visible~t')
		ls_describe = Lower(ao_datasource.Dynamic Describe(Left(ls_describe, Len(ls_describe) - 1)))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Replace single quotes in those attributes with double quotes to prevent syntax failure on Modify
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_replace_all(ls_describe, "'", '"')

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Parse the objects and the types into parallel arrays
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_parse_string(ls_describe, "~n", ls_visible_describes[])
		ll_upperbound = Min(ll_upperbound, UpperBound(ls_visible_describes[]))
	End If		

	ls_objects = ''
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all the objects and exclude or include certain types in the rebuilt object string
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To ll_upperbound
		If Len(ls_object_exclude) > 0 Then
			If Pos(',' + Lower(Trim(ls_object_exclude)) + ',', ',' + Lower(Trim(ls_type_describes[ll_index])) + ',') > 0 Then Continue
		End If

		If Len(ls_object_include) > 0 Then
			If Pos(',' + Lower(Trim(ls_object_include)) + ',', ',' + Lower(Trim(ls_type_describes[ll_index])) + ',') <= 0 Then Continue
		End If
		
		If ab_visible_objects_only Then
			If ls_visible_describes[ll_index] = '0' Or Mid(ls_visible_describes[ll_index], 2, 2) = '~t0' Then Continue
		End If
		
		ls_objects = ls_objects + ls_object[ll_index] + '~t'
		as_object[UpperBound(as_object[]) + 1] = ls_object[ll_index]
	Next
Else
	gn_globals.in_string_functions.of_parse_string(Left(ls_objects, Len(ls_objects) - 1), "~t", as_object[])
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the tabs with the property to describe
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(ls_objects, '~t', as_property + '~t')

//-----------------------------------------------------------------------------------------------------------------------------------
// Describe the property in batch
//-----------------------------------------------------------------------------------------------------------------------------------
ls_describe = ao_datasource.Dynamic Describe(ls_objects)

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the result into the value array
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_describe, "~n", as_value[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function string of_modify_header_height (powerobject ao_datasource, long al_newheight);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_height
String	ls_objects[]
String	ls_bands[]
String	ls_objecttype[]
String	ls_y
String	ls_y1
String	ls_y2

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// If the header height changed, we need to move all objects down
//-----------------------------------------------------------------------------------------------------------------------------------
ll_height 		= Long(ao_datasource.Dynamic Describe('Datawindow.Header.Height'))

If al_newheight - ll_height = 0 Or al_newheight < 0 Then Return 'Error:  Invalid height passed in or no height change'

This.of_get_all_object_property(ao_datasource, 'band', ls_objects[], ls_bands[], False)
This.of_get_all_object_property(ao_datasource, 'type', ls_objects[], ls_objecttype[], False)
	
For ll_index = 1 To Min(Min(UpperBound(ls_objects[]), UpperBound(ls_bands[])), UpperBound(ls_objecttype[]))
	If Lower(Trim(ls_bands[ll_index])) <> 'header' Then Continue
	If Lower(Trim(ls_objects[ll_index])) = 'report_title' Then Continue
	If Lower(Trim(ls_objects[ll_index])) = 'report_bitmap' Then Continue
	If Lower(Trim(Left(ls_objects[ll_index], Len('ignore_')))) = 'ignore_' Then Continue
				
	Choose Case Lower(Trim(ls_objecttype[ll_index]))
		Case 'line'
			ls_y1 = ao_datasource.Dynamic Describe(ls_objects[ll_index] + '.Y1')
			ls_y2 = ao_datasource.Dynamic Describe(ls_objects[ll_index] + '.Y2')
			If Not IsNumber(ls_y1) Or Not IsNumber(ls_y2) Then Continue
			
			ao_datasource.Dynamic Modify(ls_objects[ll_index] + '.Y1=~'' + String(Long(ls_y1) + al_newheight - ll_height) + '~'')
			ao_datasource.Dynamic Modify(ls_objects[ll_index] + '.Y2=~'' + String(Long(ls_y2) + al_newheight - ll_height) + '~'')
		Case Else
			ls_y = ao_datasource.Dynamic Describe(ls_objects[ll_index] + '.Y')
			If Not IsNumber(ls_y) Then Continue
			ao_datasource.Dynamic Modify(ls_objects[ll_index] + '.Y=~'' + String(Long(ls_y) + al_newheight - ll_height) + '~'')
	End Choose
Next

Return ao_datasource.Dynamic Modify('Datawindow.Header.Height=' + String(al_newheight))
end function

on n_datawindow_tools.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datawindow_tools.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This object contains a tremendous number of functions that will do just about anything you can think of to a datawindow/datastore.  Be sure to look here before you spend time writing a generic functions like this.
</Abstract>----------------------------------------------------------------------------------------------------*/
end event

