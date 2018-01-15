$PBExportHeader$n_column_sizing_service.sru
$PBExportComments$Datawindow Service - This service will allow you to have resizeable columns and double-click best fit like excel.
forward
global type n_column_sizing_service from nonvisualobject
end type
end forward

global type n_column_sizing_service from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_column_sizing_service n_column_sizing_service

type variables
Protected:
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Objects
	//-----------------------------------------------------------------------------------------------------------------------------------
	PowerObject						idw_data
//	n_string_functions 			in_string_functions
	StaticText					 	ivo_pane_highlight
	Window 							iw_reference
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// String Arrays
	//-----------------------------------------------------------------------------------------------------------------------------------
	String 	is_headers[]
	String	is_lines[]
	String	is_excluded_columns[]
	String	is_excluded_object[]
	String	is_objects[]
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Column Statistics
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long  	il_xpositions[]
	Long		il_widths[]
	Long		il_visible[]
	Long		il_displacement[]
	Long		il_heights[]
	Long		il_ypositions[]
	
	Long 		il_object_x
	Long 		il_old_x
	Long 		il_new_x
	Long 		il_maximum_y
	Long 		il_column_number
	Long 		il_datawindow_x_offset
	Long 		il_datawindow_y_offset
	Long 		il_leftshift = 0
	Long 		il_line_color = 12632256
	
	String 	is_name_of_resizer
	String 	is_header_suffix  = '_srt'
	
	Boolean 	ib_hassubscribed 		= False
	Boolean 	ib_we_are_resizing 	= False
	Boolean	ib_move_everything	= False
	Boolean	ib_RespondToMessages = True
	Boolean	ib_batchmode			= False
end variables

forward prototypes
public subroutine of_set_suffix (string as_suffix)
public subroutine of_set_linecolor (long al_line_color)
public function boolean of_lbuttonup (long al_xposition, long al_yposition)
public subroutine of_remove_duplicate_objects ()
public subroutine of_exclude_object (string as_columnlist)
public subroutine of_exclude (string as_columnlist)
public function boolean of_isexcluded (string as_column)
public subroutine of_apply_excluded_objects ()
public function boolean of_isexcluded_object (string as_column)
public subroutine of_printstart (long pagesmax)
public function long of_find_line (string as_line_name)
public subroutine of_interrogate_datawindow ()
public subroutine of_set_column_width (string as_columnname, long al_width)
public subroutine of_doubleclicked (string as_name, long al_xposition)
protected subroutine of_get_column_stats ()
public subroutine of_best_fit (string as_columnname, string as_bestfittype)
protected subroutine of_destroy_objects ()
public subroutine of_best_fit (long al_column_number, string as_bestfittype)
protected subroutine of_create_lines ()
protected subroutine of_resize_column ()
public subroutine of_set_column_width (long al_columnnumber, long al_width)
public subroutine of_set_batchmode (boolean ab_batchmode)
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public subroutine of_apply_excluded_columns (ref string as_columns[])
public subroutine of_move_everything (long al_howmuchtomove)
public subroutine of_reset_arrays ()
public subroutine of_init (ref powerobject adw_data)
protected subroutine of_hide_objects ()
public subroutine of_printend (long pagecount)
public subroutine of_recreate_view (n_bag an_bag)
public function boolean of_mousemove (long flags, long xpos, long ypos)
public subroutine of_lbuttondown (long al_xposition)
end prototypes

event ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   Catch subscriptions here
// Created by: Joel White
// History:    2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_index
String	ls_percentage

Choose Case Lower(as_message)
	Case 'best fit'
		This.of_best_fit(String(as_arg), 'C')
	Case 'best fit header'
		This.of_best_fit(String(as_arg), 'H')
	Case 'best fit header and column'
		This.of_best_fit(String(as_arg), 'CH')
	Case 'before view saved', 'before generate'	//This occurs before the dataobjectstate service restores a datawindow
		If ib_RespondToMessages Then This.of_hide_objects()
	Case 'after view restored', 'after generate'		//This occurs after the dataobjectstate service restores a datawindow
		If ib_RespondToMessages Then This.of_init(idw_data)
	Case	'visible columns changed'	//This occurs after the column selection service changes the visible column list.
		If ib_RespondToMessages Then This.of_init(idw_data)
	Case 'recreate view - column sizing'
		ib_RespondToMessages = True
		This.of_recreate_view(Message.PowerObjectParm)
	Case 'before recreate view'
		This.of_destroy_objects()
		ib_RespondToMessages = False
	Case 'group level changed'
		This.of_move_everything(Long(as_arg) * 50)
	Case 'set column zero width'
		This.of_set_column_width(String(as_arg), 0)
	Case Else
		If Left(Lower(Trim(as_message)), Len('increase width')) = 'increase width' Or Left(Lower(Trim(as_message)), Len('decrease width')) = 'decrease width' Then
			
			ls_percentage = Trim(Mid(as_message, Len('increase width') + 1))
			ls_percentage = Left(ls_percentage, Len(ls_percentage) - 1)
			
			If Right(String(as_arg), Len(is_header_suffix)) = is_header_suffix Then
				as_arg = String(as_arg) + Left(String(as_arg), Len(String(as_arg)) - Len(is_header_suffix))
			End If
			
			Choose Case Left(Lower(Trim(as_message)), Len('increase width'))
				Case 'decrease width'
					ls_percentage = '-' + ls_percentage
			End Choose
			
			For ll_index = 1 To Min(UpperBound(is_headers[]), UpperBound(il_widths[]))
				If Not Lower(Trim(String(as_arg))) = Lower(Trim(is_headers[ll_index])) Then Continue
				If il_widths[ll_index] = 0 Then Exit
				
				This.of_set_column_width(String(as_arg), il_widths[ll_index] + Long(Double(il_widths[ll_index]) * Double(ls_percentage) / 100.0))
				Exit
			Next
		End If
End Choose
end event

public subroutine of_set_suffix (string as_suffix);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_Set_suffix()
//	Arguments:  as_suffix
//	Overview:   set the extention to operate on.
//	Created by:	Joel White
//	History: 	2/7/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_header_suffix = as_suffix
end subroutine

public subroutine of_set_linecolor (long al_line_color);il_line_color = al_line_color
end subroutine

public function boolean of_lbuttonup (long al_xposition, long al_yposition);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_lbuttonup()
// Arguments:   al_xposition - The xposition
//					 al_yposition - The yposition
// Overview:    See where the column has been resized to
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------


If ib_we_are_resizing Then
	ib_we_are_resizing = False
	
	
	// Destroy the highlight bar if it exists
	If isvalid(ivo_pane_highlight) then
		iw_reference.CloseUserObject(ivo_pane_highlight)
	End IF
	
	//If the mouse hasn't moved higher than the height of the resizing bar, then go ahead and resize
	If al_yposition <= il_maximum_y Then
		//If they shrank the column too much, make it 50 wide
		If il_xpositions[il_column_number] + 50 > il_object_x + (al_xposition - il_old_x) Then
			il_new_x = il_old_x + 50 - il_widths[il_column_number]
		Else
			il_new_x = al_xposition
		End If
		
		of_resize_column()

	End IF

	Return True
Else
	Return False
End If

end function

public subroutine of_remove_duplicate_objects ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_remove_duplicate_objects()
//	Arguments:  none
//	Overview:   Recreate is_objects array removing the duplicate object names, if any
//	Created by:	Jake Pratt
//	History: 	2.9.2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string s_array_temp[]
string s_value
long i_outer,i_inner,i_count
Boolean lb_rebuild_array

lb_rebuild_array = False

// loop througth the objects in the array and if you find a duplicate null it out
For i_outer = 1 to upperbound( is_objects[])
	s_value = is_objects[i_outer]
	for i_inner = (i_outer + 1) to upperbound(is_objects[])
		If is_objects[i_inner] = s_value Then
			is_objects[i_inner] = ''
			lb_rebuild_array = True
		End If
	next
Next

// now create a new array
If lb_rebuild_array Then
	For i_outer = 1 to upperbound( is_objects[])
		if is_objects[i_outer] <> '' then 
			s_array_temp[ upperbound(s_array_temp) + 1] = is_objects[i_outer]
		end if
	next
	
	// now move the array to the main object array
	is_objects = s_array_temp
End If
end subroutine

public subroutine of_exclude_object (string as_columnlist);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_exclude_object()
//	Arguments:  as_columnlist - the column list
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_columns[]
//n_string_functions ln_string_functions 
gn_globals.in_string_functions.of_parse_string(as_columnlist, ',', ls_columns[])

For ll_index = 1 To UpperBound(ls_columns)
	If Len(ls_columns[ll_index]) > 0 Then
		is_excluded_object[UpperBound(is_excluded_object) + 1] = Trim(Lower(ls_columns[ll_index]))
	End If
Next


end subroutine

public subroutine of_exclude (string as_columnlist);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_exclude()
//	Arguments:  as_columnlist - the column list
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	7.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_columns[]
//n_string_functions ln_string_functions 
gn_globals.in_string_functions.of_parse_string(as_columnlist, ',', ls_columns[])

For ll_index = 1 To UpperBound(ls_columns)
	If Len(ls_columns[ll_index]) > 0 Then
		is_excluded_columns[UpperBound(is_excluded_columns) + 1] = Trim(Lower(ls_columns[ll_index]))
	End If
Next


end subroutine

public function boolean of_isexcluded (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isexcluded()
//	Arguments:  as_column - the column
//	Overview:   Determine if a column is excluded
//	Created by:	Joel White
//	History: 	7.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index

For ll_index = 1 To UpperBound(is_excluded_columns)
	If Trim(Lower(is_excluded_columns[ll_index])) = Trim(Lower(as_column)) Then
		Return True
	End If
Next

Return False


end function

public subroutine of_apply_excluded_objects ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_excluded_objects()
//	Arguments:  as_column - the column
//	Overview:   Determine if a column is excluded
//	Created by:	Joel White
//	History: 	7.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_objects[]

For ll_index = 1 To UpperBound(is_objects)
	If Not of_IsExcluded_object(is_objects[ll_index]) Then
		ls_objects[UpperBound(ls_objects) + 1] = is_objects[ll_index]
	End If
Next
is_objects = ls_objects
end subroutine

public function boolean of_isexcluded_object (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isexcluded_object()
//	Arguments:  as_column - the column
//	Overview:   Determine if a column is excluded
//	Created by:	Joel White
//	History: 	7.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index

If Left(Lower(Trim(as_column)), Len('ignore_')) = 'ignore_' Then Return True
If Left(Lower(Trim(as_column)), Len('report_title')) = 'report_title' Then Return True
If Left(Lower(Trim(as_column)), Len('report_bitmap')) = 'report_bitmap' Then Return True
If Left(Lower(Trim(as_column)), Len('report_header')) = 'report_header' Then Return True
If Left(Lower(Trim(as_column)), Len('report_footer')) = 'report_footer' Then Return True
If Left(Lower(Trim(as_column)), Len('line_header')) = 'line_header' Then Return True
If Left(Lower(Trim(as_column)), Len('line_detail')) = 'line_detail' Then Return True
If Left(Lower(Trim(as_column)), Len('line_footer')) = 'line_footer' Then Return True
If Left(Lower(Trim(as_column)), Len('b_plus_or_minus')) = 'b_plus_or_minus' Then Return True
If Left(Lower(Trim(as_column)), Len('c_group_header')) = 'c_group_header' Then Return True
If Left(Lower(Trim(as_column)), Len('r_highlight')) = 'r_highlight' Then Return True
If Left(Lower(Trim(as_column)), Len('r_selectrow')) = 'r_selectrow' Then Return True

For ll_index = 1 To UpperBound(is_excluded_object[])
	If Trim(Lower(is_excluded_object[ll_index])) = Trim(Lower(as_column)) Then
		Return True
	End If
Next

Return False


end function

public subroutine of_printstart (long pagesmax);This.of_hide_objects()
end subroutine

public function long of_find_line (string as_line_name);
long		ll_i

for ll_i = 1 to upperbound(is_lines)
	if is_lines[ll_i] = as_line_name then
		return ll_i
	end if
next

return 0
end function

public subroutine of_interrogate_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_interrogate_datawindow()
//	Overview:   This will pull the serviceinit off the dataobject to initialize services
//	Created by:	Joel White
//	History: 	10/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
n_datawindow_tools ln_datawindow_tools 
String 	ls_expression
String	ls_exclude_objects
String	ls_exclude_columns
String	ls_specialexpression_objects

//-----------------------------------------------------------------------------------------------------------------------------------
// if the datawindow is valid, check for services
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Pull the expression off the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'columnsizinginit')
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the string is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ls_expression) Or Len(ls_expression) = 0 Then Return

gn_globals.in_string_functions.of_replace_all(ls_expression, '~~', '')
gn_globals.in_string_functions.of_replace_all(ls_expression, '"', '')
gn_globals.in_string_functions.of_replace_all(ls_expression, '~'', '')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the include string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_exclude_objects 				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'excludeobjects'))
ls_exclude_columns 				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'excludecolumns'))

If Len(ls_exclude_objects) > 0 				Then This.of_exclude_object(ls_exclude_objects)
If Len(ls_exclude_columns) > 0 				Then This.of_exclude(ls_exclude_columns)
end subroutine

public subroutine of_set_column_width (string as_columnname, long al_width);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_column_width()
// Arguments:   al_column_number - The column number to resize
// Overview:    This will size the column based on the parameter passed in
// Created by:  Joel White
// History:     3/3/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
Long ll_column_number

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the id of the column
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_headers[])
	If Lower(Trim(as_columnname)) = is_headers[ll_index] Then
		ll_column_number = ll_index
		Exit
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the column number is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_column_number = 0 Or IsNull(ll_column_number) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the column width
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_set_column_width(ll_column_number, al_width)
end subroutine

public subroutine of_doubleclicked (string as_name, long al_xposition);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_doubleclicked()
// Arguments:   as_name - The name of the object clicked on
//					 al_xposition - the PointerX position
// Overview:    This will find the best fit for a column
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
Long ll_temp, ll_greatest_X_so_far = 0, ll_index, ll_total

//Set the pointer because this could take a while on a lot of rows
SetPointer(HourGlass!)

//Only process the double click if one of the columnedge objects was clicked and there are rows
If Lower(Left(as_name, 10)) = 'columnedge' Then
	If idw_data.Dynamic RowCount() > 0 Then
		is_name_of_resizer 	= as_name
		il_old_x 				= al_xposition
		il_object_x 			= Long(idw_data.Dynamic Describe(as_name + '.X1'))
	
		//Find out which columname is being affected by the resize
		For ll_index = 1 To UpperBound(is_headers[])
			ll_total = il_xpositions[ll_index] + il_widths[ll_index]
			If il_xpositions[ll_index] + il_widths[ll_index] <= il_object_x Then
				If (il_xpositions[ll_index] + il_widths[ll_index]) > ll_greatest_X_so_far Then
					il_column_number	= ll_index
					ll_greatest_X_so_far = il_xpositions[ll_index] + il_widths[ll_index]
				End If
			End If
		Next
		//Call the function to best fit the column
		of_best_fit(il_column_number, 'C')

	End If
End If
end subroutine

protected subroutine of_get_column_stats ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_column_stats()
// Overview:    This will repopulate the xpositions and the widths
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_upperbound

String	ls_objects, ls_object[]
String	ls_describe_x, ls_describe_y, ls_describe_width, ls_describe_height, ls_describe_visible
String	ls_columns_with_headers[]
String	ls_array_x[], ls_array_y[], ls_array_width[], ls_array_height[], ls_array_visible[]
String	ls_empty[]

String	ls_columnname[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]
n_datawindow_tools ln_datawindow_tools


//---------------------------------------------------------------------
// Get all the columns or computed fields with headers
//---------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_columns(idw_data, ls_columnname[], ls_headername[], ls_headertext[], ls_columntype[])
Destroy	ln_datawindow_tools

//---------------------------------------------------------------------
// Apply the excluded columns
//---------------------------------------------------------------------
This.of_apply_excluded_columns(ls_columnname[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the objects, the column count and initialize the describe statement
//-----------------------------------------------------------------------------------------------------------------------------------
ls_objects			= '~t' + idw_data.Dynamic Describe("DataWindow.Objects") + '~t'

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the objects and build a list of existing column edge objects
//-----------------------------------------------------------------------------------------------------------------------------------
is_lines[] = ls_empty[]
gn_globals.in_string_functions.of_parse_string( ls_objects, '~t', ls_object[])

ll_upperbound		= UpperBound(ls_object[])

for ll_index = 1 to upperbound(ls_object[])
	if match(ls_object[ll_index],'^columnedge_') then
		is_lines[upperbound(is_lines) + 1] = ls_object[ll_index]
	end if
next

ll_upperbound = UpperBound(ls_columnname[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns that have headers.  Set all the stats to zero.
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If Not ls_headername[ll_index] = ls_columnname[ll_index] + is_header_suffix Then Continue

	ls_columns_with_headers[UpperBound(ls_columns_with_headers[]) + 1] 	= ls_columnname[ll_index]
Next

//---------------------------------------------------------------------
// Get the upperbound of the arrays
//---------------------------------------------------------------------
ll_upperbound = UpperBound(ls_columns_with_headers[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the xposition, width, and visible property for the columns.
//-----------------------------------------------------------------------------------------------------------------------------------
FOR ll_index = 1 TO ll_upperbound
	ls_describe_x			= ls_describe_x 			+ ls_columns_with_headers[ll_index] + is_header_suffix + '.X~t'
	ls_describe_y			= ls_describe_y 			+ ls_columns_with_headers[ll_index] + is_header_suffix + '.Y~t'
	ls_describe_width		= ls_describe_width 		+ ls_columns_with_headers[ll_index] + is_header_suffix + '.Width~t'
	ls_describe_height	= ls_describe_height 	+ ls_columns_with_headers[ll_index] + is_header_suffix + '.Height~t'
	ls_describe_visible	= ls_describe_visible 	+ ls_columns_with_headers[ll_index] + is_header_suffix + '.Visible~t'
NEXT

//---------------------------------------------------------------------
// Describe all the properties
//---------------------------------------------------------------------
ls_describe_x 			= idw_data.Dynamic Describe(ls_describe_x)
ls_describe_y 			= idw_data.Dynamic Describe(ls_describe_y)
ls_describe_width 	= idw_data.Dynamic Describe(ls_describe_width)
ls_describe_height 	= idw_data.Dynamic Describe(ls_describe_height)
ls_describe_visible 	= idw_data.Dynamic Describe(ls_describe_visible)

//---------------------------------------------------------------------
// Parse the names into an array
//---------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_describe_x, 		'~n', ls_array_x[])
gn_globals.in_string_functions.of_parse_string(ls_describe_y, 		'~n', ls_array_y[])
gn_globals.in_string_functions.of_parse_string(ls_describe_width, 	'~n', ls_array_width[])
gn_globals.in_string_functions.of_parse_string(ls_describe_height, 	'~n', ls_array_height[])
gn_globals.in_string_functions.of_parse_string(ls_describe_visible, '~n', ls_array_visible[])

//---------------------------------------------------------------------
// Get the x, y, and width of all headers
//---------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	is_headers		[ll_index] 	= ls_columns_with_headers[ll_index]
	il_xpositions	[ll_index] 	= Long(ls_array_x[ll_index])
	il_ypositions	[ll_index] 	= Long(ls_array_y[ll_index])
	il_widths		[ll_index] 	= Long(ls_array_width[ll_index])
	il_heights		[ll_index] 	= Long(ls_array_height[ll_index])
	il_visible		[ll_index] 	= Long(ls_array_visible[ll_index])
Next
end subroutine

public subroutine of_best_fit (string as_columnname, string as_bestfittype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_best_fit()
// Arguments:   as_columnname - the name of the column to best fit
// Overview:    This will get the id for the column and call of_best_fit with the column number
// Created by:  Joel White
// History:     3/3/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long 	ll_column_number
Long	ll_line_index
Long	ll_index

//Get the ID of the column name
For ll_index = 1 To UpperBound(is_headers[])
	If Lower(Trim(as_columnname)) = Lower(Trim(is_headers[ll_index])) Then
		ll_column_number = ll_index
		Exit
	End If
Next

If ll_column_number > UpperBound(is_lines[]) Then Return

//If we are passed the columnname, we need to do this to get the information that will be missing from clicking on something
If ll_column_number > 0 Then
	ll_line_index = this.of_find_line( 'columnedge_' + string( ll_column_number))
	is_name_of_resizer 	= is_lines[ll_line_index]
	il_object_x 			= Long(idw_data.Dynamic Describe(is_name_of_resizer + '.X1'))
	il_old_x					= il_object_x 			
	
	of_best_fit(ll_column_number, as_bestfittype)
End If
end subroutine

protected subroutine of_destroy_objects ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_destroy_objects()
// Overview:    This will create the line objects on the datawindow that will be used to resize the columns
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long 		ll_index
String 	ls_modify = ''

if isvalid(idw_data) then
	for ll_index = 1 to upperbound( is_lines[])
		ls_modify = ls_modify + 'Destroy ' + is_lines[ll_index] + "~t"
	Next
	
	if ls_modify > '' then
		ls_modify = left(ls_modify, len(ls_modify) - 1)
		idw_data.Dynamic modify( ls_modify)
	end if
end if

This.of_reset_arrays()
end subroutine

public subroutine of_best_fit (long al_column_number, string as_bestfittype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_best_fit()
// Arguments:   al_column_number - The column number to best fit
// Overview:    This will to a best fit on the column that you pass
// Created by:  Joel White
// History:     3/3/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Integer 	ll_width
Integer	ll_height
Long 		ll_index
Long		ll_maximum_column_width
String	ls_lookupdisplay[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_gettextsize 			ln_gettextsize
n_datawindow_tools 	ln_datawindow_tools
StaticText 				lst_title
StaticText 				lst_title_header

//-----------------------------------------------------------------------------------------------------------------------------------
// Do nothing if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If idw_data.Dynamic RowCount() <= 0 And as_bestfittype <> 'H' Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the column number to resize
//-----------------------------------------------------------------------------------------------------------------------------------
il_column_number = al_column_number

//-----------------------------------------------------------------------------------------------------------------------------------
// Default the max column width to 100
//-----------------------------------------------------------------------------------------------------------------------------------
ll_maximum_column_width = 100

If Pos(as_bestfittype, 'C') > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the font information off the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	iw_reference.openuserobject(lst_title,-10000,-10000)
	lst_title.FaceName 	= idw_data.Dynamic Describe(is_headers[il_column_number] + ".Font.Face")
	lst_title.TextSize 	= 8//Long(idw_data.Describe(is_headers[il_column_number] + ".Font.Pitch"))
	lst_title.Weight 		= Long(idw_data.Dynamic Describe(is_headers[il_column_number] + ".Font.Weight"))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the lookupdisplay of the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_datawindow_tools = Create n_datawindow_tools
	ln_datawindow_tools.of_get_lookupdisplay(idw_data, is_headers[il_column_number], ls_lookupdisplay[])
	Destroy ln_datawindow_tools
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Initialize the get text size service with the static text object
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_gettextsize.of_set_statictext(lst_title)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// For every value in the column, determine the width
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To UpperBound(ls_lookupdisplay[])
		lst_title.text = ls_lookupdisplay[ll_index]
		ln_gettextsize.of_settext(lst_title.text, ll_height, ll_width)
		ll_maximum_column_width = Max(PixelsToUnits(ll_width, XPixelsToUnits!), ll_maximum_column_width)
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Close the static text object
	//-----------------------------------------------------------------------------------------------------------------------------------
	iw_reference.closeuserobject( lst_title )
End If

If Pos(as_bestfittype, 'H') > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the font information off the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	iw_reference.openuserobject(lst_title,-10000,-10000)
	lst_title.FaceName 	= idw_data.Dynamic Describe(is_headers[il_column_number] + is_header_suffix + ".Font.Face")
	lst_title.TextSize 	= 8//Long(idw_data.Describe(is_headers[il_column_number] + ".Font.Pitch"))
	lst_title.Weight 		= Long(idw_data.Dynamic Describe(is_headers[il_column_number] + is_header_suffix + ".Font.Weight"))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Initialize the get text size service with the static text object
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_gettextsize.of_set_statictext(lst_title)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// For every value in the column, determine the width
	//-----------------------------------------------------------------------------------------------------------------------------------
	lst_title.text = idw_data.Dynamic Describe(is_headers[il_column_number] + is_header_suffix + ".Text")
	ln_gettextsize.of_settext(lst_title.text, ll_height, ll_width)
	ll_maximum_column_width = Max(1.1 * PixelsToUnits(ll_width, XPixelsToUnits!), ll_maximum_column_width)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Close the static text object
	//-----------------------------------------------------------------------------------------------------------------------------------
	iw_reference.closeuserobject( lst_title )
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If they shrank the column too much, make it 50 wide
//-----------------------------------------------------------------------------------------------------------------------------------
ll_maximum_column_width = ll_maximum_column_width * 8 / 10
il_new_x = il_old_x + Max(ll_maximum_column_width, 50) - il_widths[il_column_number]
		
//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function to resize and move all the columns
//-----------------------------------------------------------------------------------------------------------------------------------
of_resize_column()
end subroutine

protected subroutine of_create_lines ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_create_lines()
// Overview:    This will create the line objects on the datawindow that will be used to resize the columns
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_index, ll_y, ll_height, ll_max_x_plus_width = 0, ll_x, ll_line_index
String ls_return, ls_syntax, ls_modify

ls_modify = ''

//Loop through all the column headers and put a line object to the right of it
For ll_index = 1 To UpperBound(is_headers[])
	ll_x 			= il_xpositions[ll_index] + il_widths[ll_index]
	ll_y 			= il_ypositions[ll_index]
	ll_height 	= il_heights[ll_index]
	ll_line_index = this.of_find_line( "columnedge_" + String(ll_index))
	If il_widths[ll_index] = 0 Or il_visible[ll_index] = 0 Then Continue
	if ll_line_index > 0 then
		ls_modify = ls_modify + is_lines[ll_line_index] + ".visible=1~t"
		ls_modify = ls_modify + is_lines[ll_line_index] + ".x1=" + string(ll_x) + "~t"
		ls_modify = ls_modify + is_lines[ll_line_index] + ".y1=" + string(ll_y) + "~t"
		ls_modify = ls_modify + is_lines[ll_line_index] + ".x2=" + string(ll_x) + "~t"
		ls_modify = ls_modify + is_lines[ll_line_index] + ".y2=" + string(ll_y + ll_height) + "~t"
	else
		ls_modify = ls_modify + "create line(band=header x1=~"" + String(ll_x) + "~" y1=~"" + String(ll_y) + "~" x2=~"" + String(ll_x) + "~" y2=~"" + String(ll_y + ll_height) + "~"  name=columnedge_" + String(ll_index) + " pointer=~"vertsplit.cur~" pen.style=~"0~" pen.width=~"5~" pen.color=~"" + String(il_line_color) + "~"  background.mode=~"2~" background.color=~"80263328~" "
		ls_modify = ls_modify + ")~t"
		is_lines[upperbound(is_lines) + 1] = "columnedge_" + String(ll_index)
	end if
	

	If Len(ls_modify) > 60000 Then
		ls_modify = Left(ls_modify, Len(ls_modify) - 1)
		idw_data.Dynamic Modify(ls_modify)
		ls_modify = ''
	End If
Next

idw_data.Dynamic Modify(ls_modify)

end subroutine

protected subroutine of_resize_column ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_resize_column()
// Overview:    This will resize the affected column and move everything else
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_X
Long		ll_width
Long		ll_column_x_position
String 	ls_return, ls_modify_string = ''
String	ls_other_objects_to_resize[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the x position of the column for comparison
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_move_everything Then
	ll_column_x_position = -1
Else
	ll_column_x_position = Long(idw_data.Dynamic Describe(is_headers[il_column_number] + '.X'))
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through every object.  If it is to the right of the affected column, move it by the offset
//-----------------------------------------------------------------------------------------------------------------------------------
FOR ll_index = 1 TO UpperBound(is_objects)
	//Make sure that if the object is a columnedge (line), then you need to use X1 and X2 instead of X
	If Lower(Left(is_objects[ll_index], 10)) = 'columnedge' Then
		ll_X = Long(idw_data.Dynamic Describe(is_objects[ll_index] + '.X1'))
		If ll_X > il_object_x Then
			ls_modify_string = ls_modify_string + is_objects[ll_index] + '.X1 = ' + String(ll_x + (il_new_x - il_old_x) - il_leftshift) + '~t'
			ls_modify_string = ls_modify_string + is_objects[ll_index] + '.X2 = ' + String(ll_x + (il_new_x - il_old_x) - il_leftshift) + '~t'
		End If
	Else
		ll_X = Long(idw_data.Dynamic Describe(is_objects[ll_index] + '.X'))
		
		If ll_X > il_object_x Then
			ls_modify_string = ls_modify_string + is_objects[ll_index] + '.X = ' + String(ll_x + (il_new_x - il_old_x) - il_leftshift) + '~t'
		End If
		
		If ll_X = ll_column_x_position And Not ib_move_everything Then
			ll_width = Long(idw_data.Dynamic Describe(is_objects[ll_index] + '.Width'))
			If ll_width = il_widths[il_column_number] Then
				ls_other_objects_to_resize[UpperBound(ls_other_objects_to_resize[]) + 1] = is_objects[ll_index]
			End If
		End If
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Just a check to make sure the string doesn't get over 64K
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(ls_modify_string) > 60000 Or ll_index = UpperBound(is_objects) Then
		ls_modify_string = Left(ls_modify_string, Len(ls_modify_string) - 1)
		ls_return = idw_data.Dynamic Modify(ls_modify_string)
		ls_modify_string	= ''
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
//	Make the column visible again
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_move_everything Then
	If il_widths[il_column_number] = 0 And il_widths[il_column_number] + (il_new_x - il_old_x) > 0 Then
		ls_return = idw_data.Dynamic Modify(is_headers[il_column_number] + is_header_suffix + '.Visible = ~'1~'')
	
		ll_x = Long(idw_data.Dynamic Describe(is_headers[il_column_number] + is_header_suffix + '.X'))
		ls_return = idw_data.Dynamic Modify(is_headers[il_column_number] + is_header_suffix + '.X = ' + String(ll_x + 1))
	
		ll_x = Long(idw_data.Dynamic Describe(is_headers[il_column_number] + '.X'))
		ls_return = idw_data.Dynamic Modify(is_headers[il_column_number] + '.X = ' + String(ll_x + 1))
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Make the column invisible again
	//-----------------------------------------------------------------------------------------------------------------------------------
	If il_widths[il_column_number] > 0 And il_widths[il_column_number] + (il_new_x - il_old_x) = 0 Then
		ls_return = idw_data.Dynamic Modify(is_headers[il_column_number] + is_header_suffix + '.Visible = ~'0~'')
		
		ll_x = Long(idw_data.Dynamic Describe(is_headers[il_column_number] + is_header_suffix + '.X'))
		ls_return = idw_data.Dynamic Modify(is_headers[il_column_number] + is_header_suffix + '.X = ' + String(ll_x - 1))
		
		ll_x = Long(idw_data.Dynamic Describe(is_headers[il_column_number] + '.X'))
		ls_return = idw_data.Dynamic Modify(is_headers[il_column_number] + '.X = ' + String(ll_x - 1))
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Modify the width of the header and the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_modify_string = ls_modify_string + is_headers[il_column_number] + is_header_suffix + '.Width =' + String(il_widths[il_column_number] + (il_new_x - il_old_x)) + '~t'
	ls_modify_string = ls_modify_string + is_headers[il_column_number] + '.Width =' + String(il_widths[il_column_number] + (il_new_x - il_old_x)) + '~t'
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Modify the width of all objects that are the same width and x as the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To UpperBound(ls_other_objects_to_resize[])
		ls_modify_string = ls_modify_string + ls_other_objects_to_resize[ll_index] + '.Width =' + String(il_widths[il_column_number] + (il_new_x - il_old_x)) + '~t'
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Just a check to make sure the string doesn't get over 64K
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(ls_modify_string) > 60000 Or ll_index = UpperBound(ls_other_objects_to_resize[]) Then
			ls_modify_string = Left(ls_modify_string, Len(ls_modify_string) - 1)
			ls_return = idw_data.Dynamic Modify(ls_modify_string)
			ls_modify_string	= ''
		End If
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Move the resize line
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_modify_string = ls_modify_string + is_name_of_resizer + '.X1 =' + String(il_object_x + (il_new_x - il_old_x)) + '~t'
	ls_modify_string = ls_modify_string + is_name_of_resizer + '.X2 =' + String(il_object_x + (il_new_x - il_old_x)) + '~t'

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Modify the entire modify string
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_modify_string = Left(ls_modify_string, Len(ls_modify_string) - 1)
	ls_return = idw_data.Dynamic Modify(ls_modify_string)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Recalculate the statistics
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_apply_expressions(idw_data)
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Recalculate the statistics
//-----------------------------------------------------------------------------------------------------------------------------------
of_get_column_stats()

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message that says the columns were resized to see if anyone needs to respond
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message('ColumnResize','',idw_data)
end if

//
//n_multimedia ln_multimedia
//ln_multimedia.of_play_sound('GUI Sounds - Bestfit.wav')
end subroutine

public subroutine of_set_column_width (long al_columnnumber, long al_width);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_column_width()
// Arguments:   	al_column_number - The column number to resize
//						al_width				- The new width of the column
// Overview:    This will size the column based on the parameter passed in
// Created by:  Joel White
// History:     3/3/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_line_number

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the column number is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If al_columnnumber = 0 Or IsNull(al_columnnumber) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the instance information in order to make it think that it is resizing this column
//-----------------------------------------------------------------------------------------------------------------------------------
il_column_number 		= al_columnnumber
ll_line_number			= This.of_find_line('columnedge_' + String(al_columnnumber))

If ll_line_number <= 0 Or ll_line_number > UpperBound(is_lines[]) Then Return

is_name_of_resizer 	= is_lines[ll_line_number]
il_object_x 			= Long(idw_data.Dynamic Describe(is_name_of_resizer + '.X1'))
il_old_x					= il_object_x 			

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the new x position
//-----------------------------------------------------------------------------------------------------------------------------------
il_new_x = il_old_x - il_widths[il_column_number] + al_width

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function to resize and move all the columns
//-----------------------------------------------------------------------------------------------------------------------------------
of_resize_column()
end subroutine

public subroutine of_set_batchmode (boolean ab_batchmode);ib_batchmode = ab_batchmode
end subroutine

public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	Joel White
//	History: 	3/1/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_menu_dynamic ln_menu_dynamic

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_data) Then Return
If Not ab_iscolumn And Not ab_iscomputedfield Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column sizing menu items
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)
an_menu_dynamic.of_add_item('&Best Fit This Column', 'best fit', as_objectname, This)
an_menu_dynamic.of_add_item('Best Fit This &Header', 'best fit header', as_objectname, This)
an_menu_dynamic.of_add_item('Best Fit Header/&Column', 'best fit header and column', as_objectname, This)

//If ib_BatchMode Then
	ln_menu_dynamic = an_menu_dynamic.of_add_item('&Modify Column Width', 'best fit', as_objectname, This)
	
	ln_menu_dynamic.of_add_item('Increase Width 25%', 'Increase Width 25%', as_objectname, This)
	ln_menu_dynamic.of_add_item('Increase Width 50%', 'Increase Width 50%', as_objectname, This)
	ln_menu_dynamic.of_add_item('Increase Width 75%', 'Increase Width 75%', as_objectname, This)
	ln_menu_dynamic.of_add_item('Increase Width 100%', 'Increase Width 100%', as_objectname, This)
	ln_menu_dynamic.of_add_item('-', '-', '', This)
	ln_menu_dynamic.of_add_item('Decrease Width 25%', 'Decrease Width 25%', as_objectname, This)
	ln_menu_dynamic.of_add_item('Decrease Width 50%', 'Decrease Width 50%', as_objectname, This)
	ln_menu_dynamic.of_add_item('Decrease Width 75%', 'Decrease Width 75%', as_objectname, This)
//End If
end subroutine

public subroutine of_apply_excluded_columns (ref string as_columns[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isexcluded()
//	Arguments:  as_column - the column
//	Overview:   Determine if a column is excluded
//	Created by:	Joel White
//	History: 	7.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_headers[]

For ll_index = 1 To UpperBound(as_columns[])
	If Not of_IsExcluded(as_columns[ll_index]) Then
		ls_headers[UpperBound(ls_headers) + 1] = as_columns[ll_index]
	End If
Next

as_columns[] = ls_headers
end subroutine

public subroutine of_move_everything (long al_howmuchtomove);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_move_everything()
//	Created by:	Joel White
//	History: 	10/5/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_move_everything = True

il_new_x = al_howmuchtomove
il_old_x = 0
il_object_x	= -32000

This.of_resize_column()

ib_move_everything = False
end subroutine

public subroutine of_reset_arrays ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reset_arrays()
//	Arguments:  None
//	Overview:   Reset instance arrays for re-initialization.
//	Created by:	Joel White
//	History: 	3/17/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_reset[]
long ll_reset[]

is_headers[] 					= ls_reset[]
is_objects[] 					= ls_reset[]
is_excluded_columns[]		= ls_reset[]
is_excluded_object[]			= ls_reset[]
is_lines[]						= ls_reset[]

il_displacement[]				= ll_reset[]
il_visible[]					= ll_reset[]
il_widths[]						= ll_reset[]
il_xpositions[]				= ll_reset[]

il_heights[]					= ll_reset[]
il_ypositions[]				= ll_reset[]
end subroutine

public subroutine of_init (ref powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data	The datawindow to process
// Overview:    This will initialize the object
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject luo_temp
PowerObject lpo_temp
Datastore	lds_data
Datawindow	ldw_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_objects
String	ls_reset[]
String	ls_datawindow_objects
String	ls_dataobject

SetPointer(HourGlass!)

if isvalid(gn_globals) then
	if isvalid(gn_globals.in_subscription_service) then
		gn_globals.in_subscription_service.of_message('bump statusbar', 'message=Initializing Column Sizing Service||percent=5')
	end if
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data = adw_data

Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ls_dataobject = ldw_data.DataObject
	Case Datastore!
		lds_data = idw_data
		ls_dataobject = lds_data.DataObject
End Choose

//-----------------------------------------------------
// Subscribe to the messages that affect this object
//-----------------------------------------------------
If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_subscribe(This, 'Before View Saved', 			idw_data) 	//Published by the Dataobject State service
		gn_globals.in_subscription_service.of_subscribe(This, 'After View Restored', 			idw_data) 	//Published by the Dataobject State service
		gn_globals.in_subscription_service.of_subscribe(This, 'Before Generate', 				idw_data) 	//Published by the Dataobject State service
		gn_globals.in_subscription_service.of_subscribe(This, 'After Generate', 				idw_data) 	//Published by the Dataobject State service
		gn_globals.in_subscription_service.of_subscribe(This, 'visible columns changed', 	idw_data)	//Published by the column selection service
		gn_globals.in_subscription_service.of_subscribe(This, 'Recreate View - Column Sizing', idw_data)	//Published by the pivot table service
		gn_globals.in_subscription_service.of_subscribe(This, 'Before Recreate View', 			idw_data)	//Published by the pivot table service
		gn_globals.in_subscription_service.of_subscribe(This, 'Group Level Changed', 			idw_data)	//Published by the pivot table service
		//gn_globals.in_subscription_service.of_subscribe(This, 'set column zero width', 		idw_data)	//Published by the pivot table service
	End If
End If

This.of_hide_objects()
This.of_reset_arrays()

If Not ib_batchmode Then
	This.of_interrogate_datawindow()

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the column statistics
	//-----------------------------------------------------------------------------------------------------------------------------------
	of_get_column_stats()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the lines on the datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	of_create_lines()

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get a tab delimited array of datawindow objects and put them into an array using n_string_functions
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_datawindow_objects = idw_data.Dynamic Describe("DataWindow.Objects")
	gn_globals.in_string_functions.of_parse_string(ls_datawindow_objects, '~t', is_objects[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Because dynamic dws can have duplicate objects, delete duplicates from the array.  Apply the excluded objects
	//-----------------------------------------------------------------------------------------------------------------------------------
	This.of_remove_duplicate_objects()
	This.of_apply_excluded_objects()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the parentwindow to be used later as a reference for coordinate systems.
//-----------------------------------------------------------------------------------------------------------------------------------
lpo_temp = idw_data.GetParent()

DO WHILE lpo_temp.TypeOf() <> Window!
	lpo_temp = lpo_temp.GetParent()
LOOP

iw_reference = lpo_temp

end subroutine

protected subroutine of_hide_objects ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_hide_objects()
// Overview:    This will create the line objects on the datawindow that will be used to resize the columns
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long 		ll_index
String 	ls_modify = ''

if isvalid(idw_data) then
	for ll_index = 1 to upperbound( is_lines[])
		ls_modify = ls_modify + is_lines[ll_index] + ".visible=0~t"
	Next
	
	if ls_modify > '' then
		ls_modify = left(ls_modify, len(ls_modify) - 1)
		idw_data.Dynamic modify( ls_modify)
	end if
end if
end subroutine

public subroutine of_printend (long pagecount);This.of_init(idw_data)
end subroutine

public subroutine of_recreate_view (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_recreate_view()
// Arguments:   adw_data	The datawindow to process
// Overview:    This will initialize the object
// Created by:  Joel White
// History:     3/7/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
Datastore	lds_ViewDatawindow

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_InitialWidth
Long		ll_NewWidth
String	ls_ViewDatawindow
String	ls_columnname[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are any problems
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_bag) Or Not IsValid(idw_data) Then Return
This.of_init(idw_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datawindow tools and the three datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools 		= Create n_datawindow_tools
lds_ViewDatawindow		= Create Datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the three versions of the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_ViewDatawindow			= an_bag.of_get('View Syntax')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the syntaxes are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_ViewDatawindow)) = 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the syntaxes to the datastores
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_apply_syntax(lds_ViewDatawindow, ls_ViewDatawindow)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if any of the dataobjects are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lds_ViewDatawindow.Object) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the changes to the datawindow to idw_data
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_get_columns(lds_ViewDatawindow, ls_columnname[], ls_headername[], ls_headertext[], ls_columntype[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and check to see if the column was resized
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_headername[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Make sure that the column is on the new datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not ln_datawindow_tools.of_IsColumn(idw_data, ls_columnname[ll_index]) And Not ln_datawindow_tools.of_IsComputedField(idw_data, ls_columnname[ll_index]) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the before and after width
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_InitialWidth	= Long(idw_data.Dynamic Describe(ls_headername[ll_index] + '.Width'))
	ll_NewWidth			= Long(lds_ViewDatawindow.Describe(ls_headername[ll_index] + '.Width'))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the width changed, set the new width of the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_InitialWidth <> ll_NewWidth Then This.of_set_column_width(ls_columnname[ll_index], ll_NewWidth)
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Destroy lds_ViewDatawindow

end subroutine

public function boolean of_mousemove (long flags, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Functino:      of_mousemove
// Overview:   If the mouse has been moved over the object while the left button was clicked then
//					move the highlight
//
// Created by: Joel White
// History:    2/20/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Datawindow ldw_data

Choose Case idw_data.TypeOf()
	Case Datawindow!
	Case Else
		Return False
End Choose


//-----------------------------------------------------
// flags = 1:  Mouse Clicked
// ib_we_are_resizing = True mouse clicked while over
// object, Set to True in the leftbuttondown event.
//-----------------------------------------------------
If idw_data.TypeOf() <> Datawindow! Then Return False
ldw_data = idw_data
If ib_we_are_resizing Then
	//If the object doesn't exists, create it.  Else move it to the xposition
	If flags <> 1 Then
		if isvalid(ivo_pane_highlight) then
			iw_reference.CloseUserObject(ivo_pane_highlight)
		End If
		ib_we_are_resizing = False
		
		Return False
	Else
		if isvalid(ivo_pane_highlight) then
			ivo_pane_highlight.X = iw_reference.PointerX() - 15
			ivo_pane_highlight.Visible = ypos <= il_maximum_y
			//PixelsToUnits(ypos, YPixelsToUnits! ) <= il_maximum_y
		Else
			If IsValid(gn_globals.of_get_frame()) Then
				iw_reference.OpenUserObject ( ivo_pane_highlight, 'u_statictext_drag_graphic', gn_globals.of_get_frame().Dynamic PointerX() - 15, iw_reference.PointerY() - ypos)
				//ivo_pane_highlight.Backcolor = gn_globals.in_theme.of_get_barcolor()
				ivo_pane_highlight.Height = ldw_data.Height
				ivo_pane_highlight.Width = 20
				ivo_pane_highlight.BringToTop = True
			End If
		End If
		
		Return True
	End If
End If

Return False
end function

public subroutine of_lbuttondown (long al_xposition);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_lbuttondown()
// Arguments:   as_name - The name of the object clicked on
// Overview:    This will find out what column is being resized
// Created by:  Joel White
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_temp, ll_greatest_X_so_far = 0, ll_index, ll_total
String ls_dwobject

If IsValid(idw_data) Then
	ls_dwobject = idw_data.Dynamic GetObjectAtPointer()
	ls_dwobject = Left(ls_dwobject, Pos(ls_dwobject, '~t') - 1)
	
	//Only process if the object is a columnedge
	If Lower(Left(ls_dwobject, 10)) = 'columnedge' Then
		ib_we_are_resizing = True
		is_name_of_resizer = ls_dwobject
		il_old_x = al_xposition
		il_object_x 	= Long(idw_data.Dynamic Describe(ls_dwobject + '.X1'))
		il_maximum_y 	= Long(idw_data.Dynamic Describe(ls_dwobject + '.y2'))
	
		If (Lower(Trim(idw_data.Dynamic Describe("DataWindow.Print.Preview"))) = 'yes') Then
			il_maximum_y = il_maximum_y + Long(idw_data.Dynamic Describe('datawindow.print.margin.top'))
		End If
	
		//Find the header object that is most likely to be affected
		For ll_index = 1 To UpperBound(is_headers[])
			ll_total = il_xpositions[ll_index] + il_widths[ll_index]
			If il_xpositions[ll_index] + il_widths[ll_index] <= il_object_x Then
				If (il_xpositions[ll_index] + il_widths[ll_index]) > ll_greatest_X_so_far Then
					il_column_number	= ll_index
					ll_greatest_X_so_far = il_xpositions[ll_index] + il_widths[ll_index]
				End If
			End If
		Next
	End If
End If
end subroutine

on n_column_sizing_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_column_sizing_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   If this object still exists for some reason close it
// Created by: Joel White
// History:    2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Remove objects that I made from the datawindow
This.of_destroy_objects()

If isvalid(ivo_pane_highlight) then
	iw_reference.CloseUserObject(ivo_pane_highlight)
End If

end event

