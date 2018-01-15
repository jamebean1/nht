$PBExportHeader$n_show_fields.sru
forward
global type n_show_fields from nonvisualobject
end type
end forward

global type n_show_fields from nonvisualobject
event ue_notify ( string as_message,  any aany_arg )
end type
global n_show_fields n_show_fields

type variables
//Information about the original datawindow
Protected:
	PowerObject idw_data
	Boolean	ib_hassubscribedtoshowfieldswindow = False
	string	is_invisible_headertexts
	
	datastore	ids_config
	
	long		il_minimum_x=0
	
	String	is_addremoveheaders = 'Y'
	String	is_excludedcolumns = ''
	
	//n_string_functions in_string_functions
	Boolean ib_header_selected
	Long	il_lbuttondown_x
	Long	il_lbuttondown_y
	String	is_header_selected
	String	is_header_name
	String	is_header_text
	StaticText 	ivo_pane_highlight
	PowerObject iw_reference
	
	Boolean	ib_RespondToMessages = True
	Boolean	ib_batchmode = False
	Boolean	ib_Initialized	= False
	String	is_excluded_object[]
end variables

forward prototypes
public subroutine of_parse_string (string s_string, string s_delimiter, ref string s_string_array[])
public subroutine of_recalculate_x_values ()
public subroutine of_set_visible_headertexts (string as_headertexts, boolean ab_visible)
public subroutine of_translate_text (ref string as_text_to_translate, boolean ab_forward)
public subroutine of_set_header_order (string as_headertexts)
public subroutine of_set_header_object_order (string as_headerobjects)
public subroutine of_load_header_order ()
private function boolean of_load_columnselectioninit ()
public subroutine of_remove_column (string as_column)
public subroutine of_remove_headertext (string as_headertext)
public subroutine of_column_deleted (string as_column)
public subroutine of_set_batchmode (boolean ab_batchmode)
public subroutine of_lbuttondown (unsignedlong flags, long xpos, long ypos)
public subroutine of_recreate_view (n_bag an_bag)
public function string of_get_visible_header_text ()
public function string of_get_visible_header_object ()
public function string of_get_invisible_headertexts ()
public function string of_get_all_header_text ()
public function string of_get_all_header_object ()
public function boolean of_lbuttonup (unsignedlong flags, long xpos, long ypos)
public function boolean of_mousemove (unsignedlong flags, long xpos, long ypos, boolean ab_create_floating_button)
public subroutine of_apply_excluded_objects (ref string as_columns[])
public function boolean of_isexcluded_object (string as_column)
public subroutine of_init (powerobject adw_data)
public subroutine of_reinitialize ()
public subroutine of_exclude_object (string as_columnlist)
protected subroutine of_interrogate_datawindow ()
public function string of_load_columns ()
public function n_bag of_get_information ()
public subroutine of_apply ()
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public subroutine of_show_headertext (string as_headertext)
end prototypes

event ue_notify(string as_message, any aany_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This will catch messages from the publish/subscribe service
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_index
Long		ll_index2
Long		ll_position
String	ls_headertexts
String	ls_columns
String	ls_headers[]
String	ls_temporary_header
NonVisualObject ln_nonvisual_window_opener
//n_string_functions ln_string_functions

Choose Case Lower(as_message)
	Case 'field selection'
		this.of_reinitialize()
		
		If Not ib_hassubscribedtoshowfieldswindow Then
			ib_hassubscribedtoshowfieldswindow = True
			gn_globals.in_subscription_service.of_subscribe( this, 'apply visible columns', idw_data)
		End If
		
		//------------------------------------------------------------------------------------
		// Open the window to name the view
		//------------------------------------------------------------------------------------
		ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
		ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_show_fields', This)
		Destroy ln_nonvisual_window_opener
		
	Case	'remove a column'
		this.of_reinitialize()
		This.of_remove_column(Trim(String(aany_arg)))
	Case	'show a column'
		this.of_reinitialize()
		This.of_show_headertext(Trim(String(aany_arg)))
	Case 'column deleted'
		If Not ib_Initialized Then this.of_reinitialize()
		This.of_column_deleted(String(aany_arg))
	Case	'after view restored', 'columnresize'
		IF ib_Initialized Then This.of_interrogate_datawindow()
		
		If ib_RespondToMessages Then
			This.of_reinitialize()
		End If
		
	Case 'apply visible columns'
		If Not ib_Initialized Then this.of_reinitialize()
		ls_headertexts = string( aany_arg)
		
		this.of_set_visible_headertexts( ls_headertexts, TRUE)
		this.of_set_header_order( ls_headertexts)
		this.of_apply( )
	
	Case 'before recreate view'
		If Not ib_Initialized Then this.of_reinitialize()
		ib_RespondToMessages = False
	Case 'recreate view - column selection'
		If Not ib_Initialized Then this.of_reinitialize()
		ib_RespondToMessages = True
		this.of_recreate_view(Message.PowerObjectParm)
		
	Case 'column added or removed'
		//If ib_RespondToMessages Then
			This.of_reinitialize()
			if Not trim(is_invisible_headertexts) > '' then This.of_apply()
		//End If
	Case Else
		//------------------------------------------------------------------------------------
		// Handle all the move column messages
		//------------------------------------------------------------------------------------
		If Left(Lower(Trim(as_message)), Len('move column')) = 'move column' Then
			aany_arg = String(aany_arg) + '_srt'
			//------------------------------------------------------------------------------------
			// Get all the visible headers
			//------------------------------------------------------------------------------------
			ls_headertexts = This.of_get_visible_header_object()
			
			//------------------------------------------------------------------------------------
			// Parse the headers into an array
			//------------------------------------------------------------------------------------
			gn_globals.in_string_functions.of_parse_string(ls_headertexts, ',', ls_headers[])
			
			//------------------------------------------------------------------------------------
			// Case based on which direction we are heading
			//------------------------------------------------------------------------------------
			Choose Case Right(Lower(Trim(as_message)), 5)
				Case 'first', 'last'
					ls_headertexts = ''
					
					//------------------------------------------------------------------------------------
					// Loop through and build a list of all the objects, except the one we're interested in
					//------------------------------------------------------------------------------------
					For ll_index = 1 To UpperBound(ls_headers[])
						If Lower(Trim(String(aany_arg))) = Lower(Trim(ls_headers[ll_index])) Then
							ls_temporary_header = ls_headers[ll_index]
							Continue
						Else
							ls_headertexts = ls_headertexts + ls_headers[ll_index] + ','
						End If
					Next
					
					//------------------------------------------------------------------------------------
					// If we actually found the object, move it
					//------------------------------------------------------------------------------------
					If ls_temporary_header <> '' Then
						ls_headertexts = Left(ls_headertexts, Len(ls_headertexts) - 1)
						
						Choose Case Right(Lower(Trim(as_message)), 5)
							Case 'first'
									ls_headertexts = ls_temporary_header + ',' + ls_headertexts
							Case ' last'
									ls_headertexts = ls_headertexts + ',' + ls_temporary_header
						End Choose
						
						This.of_set_header_object_order(ls_headertexts)
						This.of_apply()
					End If
					
				Case ' left', 'right'
					//------------------------------------------------------------------------------------
					// Loop through the headers looking for the one we're interested in
					//------------------------------------------------------------------------------------
					For ll_index = 1 To UpperBound(ls_headers[])
						If Lower(Trim(String(aany_arg))) <> Lower(Trim(ls_headers[ll_index])) Then Continue
						
						//------------------------------------------------------------------------------------
						// Move the object
						//------------------------------------------------------------------------------------
						Choose Case Right(Lower(Trim(as_message)), 5)
							Case ' left'
								If ll_index = 1 Then Return
								ls_temporary_header = ls_headers[ll_index]
								ls_headers[ll_index] = ls_headers[ll_index - 1]
								ls_headers[ll_index - 1] = ls_temporary_header
							Case 'right'
								If ll_index = UpperBound(ls_headers[]) Then Return
								ls_temporary_header = ls_headers[ll_index]
								ls_headers[ll_index] = ls_headers[ll_index + 1]
								ls_headers[ll_index + 1] = ls_temporary_header
						End Choose
						
						//------------------------------------------------------------------------------------
						// Rebuild the object list
						//------------------------------------------------------------------------------------
						ls_headertexts = ''
						
						For ll_index2 = 1 To UpperBound(ls_headers[])
							ls_headertexts = ls_headertexts + ls_headers[ll_index2] + ','
						Next

						This.of_set_header_object_order(Left(ls_headertexts, Len(ls_headertexts) - 1))
						This.of_apply()
						Exit
					Next
			End Choose
		End If
End Choose

return
end event

public subroutine of_parse_string (string s_string, string s_delimiter, ref string s_string_array[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_parse_string()
// Arguments:	s_string - string to parse
//					s_delimiter - delimter characters to parse on.

//					s_string_array[] - reference string array to fill in with the parsed values.
// Overview:	Parse the string into an array based on the specified delimiter
// Created by:	Jake Pratt
// History:		6/17/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long l_pos_delimiter,l_loop, l_pos_start=1
string s_key,s_key_remaining,s_currentkey
//-------------------------------------------------------------------
// Find the delimiter string
//-------------------------------------------------------------------
If len(trim(s_string)) = 0 or IsNull(s_string) Then RETURN

l_pos_delimiter = pos(s_string,s_delimiter)

If l_pos_delimiter = 0 Then 
	s_string_array[1] = s_string
	Return
End If

//-------------------------------------------------------------------
// Parse from left to right and put the values into the array.
//-------------------------------------------------------------------
s_key = left(s_string,l_pos_delimiter -1)
s_key_remaining = right(s_string,len(s_string) - l_pos_delimiter - len(s_delimiter) + 1 )

Do While l_pos_delimiter > 0 
	
	//-------------------------------------------------------------------
	// if the key starts with a quote (either single or double), make sure
	//	it ends in a quote of the same kind.  If not, we have found a
	// delimiter inside a quoted string.  Therefore, reassemble the string
	// and look for the next delimiter.
	//-------------------------------------------------------------------
	
	if (left( s_key, 1) = "'" and right( s_key, 1) <> "'") OR &
		(left( s_key, 1) = '"' and right( s_key, 1) <> '"') then
		s_key_remaining = s_key + s_delimiter + s_key_remaining
		l_pos_start = l_pos_delimiter + 1
	else
		if len(s_key) > 2 AND &
			(left(s_key,1) = "'" and right( s_key, 1) = "'") OR &
			(left(s_key,1) = '"' and right( s_key, 1) = '"') then
			//s_key = mid( s_key, 2, len(s_key) - 2)
		end if
		l_loop ++
		s_string_array[l_loop]	= s_key
		l_pos_start = 1
	end if	
	
	l_pos_delimiter = pos(s_key_remaining,s_delimiter, l_pos_start)

	if l_pos_delimiter = 0 then
		s_key = s_key_remaining
		if len(s_key) > 2 AND &
			(left(s_key,1) = "'" and right( s_key, 1) = "'") OR &
			(left(s_key,1) = '"' and right( s_key, 1) = '"') then
			s_key = mid( s_key, 2, len(s_key) - 2)
		end if
		l_loop ++
		s_string_array[l_loop] = s_key
	end if

	
	s_key = left(s_key_remaining,l_pos_delimiter -1)
	s_key_remaining = right(s_key_remaining,len(s_key_remaining) - l_pos_delimiter - len(s_delimiter) + 1)
Loop

if upperbound(s_string_array) = 0 then
	s_string_array[1] = s_string
end if



end subroutine

public subroutine of_recalculate_x_values ();
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_recalculate_x_values
//	Arguments:  None
//	Overview:   This function uses the current order of the columns and the current width of the columns
//					to calculate new x positions for the columns.
//	Created by:	Scott Creed
//	History: 	07.18.2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		ll_i, ll_j
long		ll_x=14
string	ls_widths, ls_width[]
string	ls_x[]

if ids_config.rowcount() = 0 then return

ids_config.sort()

ls_width[] 	= ids_config.object.width.primary
ls_x[] 		= ids_config.object.x.primary

ll_x = il_minimum_x

for ll_i = 1 to ids_config.rowcount()
	ls_x[ll_i] = string(ll_x)
	ll_x = ll_x + long(ls_width[ll_i]) + 25
next

ids_config.object.x.primary = ls_x[]

return
end subroutine

public subroutine of_set_visible_headertexts (string as_headertexts, boolean ab_visible);
long		ll_i, ll_j
string	ls_headertext[]
string	ls_visible

//n_string_functions	ln_string

as_headertexts = "," + lower(as_headertexts) + ","

ids_config.setfilter( 'pos("' + as_headertexts + '", "," + lower(text) + ",") > 0')
ids_config.filter()

if ab_visible then ls_visible = '1' else ls_visible = '0'

for ll_i = 1 to ids_config.rowcount()
	ids_config.setitem( ll_i, 'visible', ls_visible)
next

ids_config.setfilter( 'pos("' + as_headertexts + '", "," + lower(text) + ",") = 0')
ids_config.filter()

if ls_visible = '1' then ls_visible = '0' else ls_visible = '1'

for ll_i = 1 to ids_config.rowcount()
	ids_config.setitem( ll_i, 'visible', ls_visible)
next

ids_config.setfilter('')
ids_config.filter()

ids_config.sort()

return
end subroutine

public subroutine of_translate_text (ref string as_text_to_translate, boolean ab_forward);//n_string_functions ln_string_functions
If ab_forward Then
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, ',', '[comma]')
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '~~', '')
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, "'", '')
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '"', '')
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '=', '')
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '!', '')
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '?', '')
Else
	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '[comma]', ',')
//	gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '[tilda]', '~~')
	//gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '[singlequote]', "'")
	//gn_globals.in_string_functions.of_replace_all(as_text_to_translate, '[doublequote]', '"')
End If

end subroutine

public subroutine of_set_header_order (string as_headertexts);
string	ls_header_text[]
String	ls_config_header_text[]
String	ls_order[]
long		ll_i, ll_j
long		ll_x=14

//n_string_functions	ln_string

if ids_config.rowcount() = 0 then return

gn_globals.in_string_functions.of_parse_string( as_headertexts, ",", ls_header_text[])

if upperbound(ls_header_text[]) = 0 then return

ls_config_header_text[] = ids_config.object.text.primary

for ll_i = 1 to upperbound(ls_config_header_text[])
	for ll_j = 1 to upperbound( ls_header_text[])
		if lower(ls_header_text[ll_j]) = lower(ls_config_header_text[ll_i]) then
			ls_order[ll_i] = string(ll_j)
		end if
	next
next

ids_config.object.x.primary = ls_order[]

return
end subroutine

public subroutine of_set_header_object_order (string as_headerobjects);
string	ls_header_object[]
String	ls_config_header_object[]
String	ls_order[]
long		ll_i, ll_j
long		ll_x=14

//n_string_functions	ln_string

if ids_config.rowcount() = 0 then return

gn_globals.in_string_functions.of_parse_string(as_headerobjects, ",", ls_header_object[])

if upperbound(ls_header_object[]) = 0 then return

ls_config_header_object[] = ids_config.object.name.primary

for ll_i = 1 to upperbound(ls_config_header_object[])
	for ll_j = 1 to upperbound( ls_header_object[])
		if lower(ls_header_object[ll_j]) = lower(ls_config_header_object[ll_i]) then
			ls_order[ll_i] = string(ll_j)
		end if
	next
next

ids_config.object.x.primary = ls_order[]

return
end subroutine

public subroutine of_load_header_order ();
long	ll_current_x
long	ll_index, ll_index_2
long	ll_order

ids_config.setsort('visible D, long(x) A')
ids_config.sort()

return
end subroutine

private function boolean of_load_columnselectioninit ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_interrogate_datawindow()
//	Arguments:  None.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_return
string ls_expression, ls_arguments[], ls_values[], ls_array[], ls_reset[]
long ll_index, ll_loop

n_datawindow_tools	ln_data_tools

is_invisible_headertexts 	= ''
is_excludedcolumns			= ''
is_addremoveheaders			= 'Y'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression for the init column out of the datawindow if the column exists.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_data_tools) Then ln_data_tools = Create n_datawindow_tools 

If ln_data_tools.of_column_exists(idw_data, 'columnselectioninit') Then
	ls_expression = Trim(ln_data_tools.of_get_expression(idw_data, 'columnselectioninit'))
	
	If Left(ls_expression, 1) = '"' And Right(ls_expression, 1) = '"' Then
		ls_expression = Left(ls_expression, Len(ls_expression) - 1)
		ls_expression = Right(ls_expression, Len(ls_expression) - 1)
	End If
End If

If Not IsNull(ls_expression) And Len(Trim(ls_expression)) > 0 And ls_expression <> '' Then
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Use the string functions object to parse the string into an array
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_arguments(ls_expression, '||', ls_arguments[], ls_values[])
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all elements of the array
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To Min(UpperBound(ls_arguments), UpperBound(ls_values))
		Choose Case Lower(Trim(ls_arguments[ll_index]))
			Case 'invisible headers'
				If Trim(is_invisible_headertexts) 	<> Trim(ls_values[ll_index]) Or IsNull(is_invisible_headertexts) <> IsNull(ls_values[ll_index]) Then
					lb_return = True
					is_invisible_headertexts 	= ls_values[ll_index]
				End If
				
			Case	'excluded columns'
				If Trim(is_excludedcolumns) 	<> Trim(ls_values[ll_index]) Or IsNull(is_excludedcolumns) <> IsNull(ls_values[ll_index]) Then
					lb_return = True
					is_excludedcolumns			= ',' + Lower(Trim(ls_values[ll_index])) + ','
					gn_globals.in_string_functions.of_replace_all(is_excludedcolumns, ' ', '')
				End If
			Case 'add/remove headers'
				If Trim(is_addremoveheaders) 	<> Trim(ls_values[ll_index]) Or IsNull(is_addremoveheaders) <> IsNull(ls_values[ll_index]) Then
					lb_return = True
					is_addremoveheaders 			= Upper(Trim(ls_values[ll_index]))
				End If
		End Choose
	Next
End If	

Return lb_return
end function

public subroutine of_remove_column (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_remove_column()
//	Arguments:  as_headertext	- The header that is to be removed.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	3/1/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------

long	ll_index
string	ls_header, ls_header_text

long	ll_row

ll_row = ids_config.find( 'pos(lower(object_list),"' + lower(as_column) + '") > 0', 1, ids_config.rowcount())

if ll_row > 0 then
	ids_config.setitem( ll_row, 'visible', '0')
	This.of_apply()
end if
end subroutine

public subroutine of_remove_headertext (string as_headertext);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_remove_column()
//	Arguments:  as_headertext	- The header that is to be removed.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	3/1/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------

long	ll_index, ll_row
//n_string_functions ln_string_functions

gn_globals.in_string_functions.of_replace_all(as_headertext, '"', '~~"')

ll_row = ids_config.find( 'lower(text)= "' + lower(as_headertext) + '"', 1, ids_config.rowcount())

if ll_row <= 0 then RETURN

ids_config.setitem( ll_row, 'visible', '0')

ids_config.sort()

This.of_apply()
end subroutine

public subroutine of_column_deleted (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_column_deleted()
//	Created by:	Blake Doerr
//	History: 	5/25/03 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------

long	ll_index
string	ls_header, ls_header_text

long	ll_row

ll_row = ids_config.find( 'pos(lower(object_list),"' + lower(as_column) + '") > 0', 1, ids_config.rowcount())

if ll_row > 0 then
	ids_config.DeleteRow(ll_row)
	This.of_apply()
end if
end subroutine

public subroutine of_set_batchmode (boolean ab_batchmode);ib_batchmode = ab_batchmode
end subroutine

public subroutine of_lbuttondown (unsignedlong flags, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_leftbuttondown()
// Arguments:   xpos, ypos - you can figure these out
// Overview:    This will manage the grouping and ungrouping of columns using the mouse on the datawindow
//							If you drag from the column header to the datawindow, you are grouping by that coloumn
//							If you drag from the group header to the column header , you are ungrouping by that coloumn
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
String	ls_objectatpointer, ls_getbandatpointer
//n_string_functions ln_string_functions

If TypeOf(idw_data) <> Datawindow! Then Return
If Not ib_Initialized Then this.of_reinitialize()

//Check to see what object was clicked on (we care about column headers and group headers)
ls_objectatpointer = idw_data.Dynamic GetObjectAtPointer()
ls_objectatpointer = Left(ls_objectatpointer, Pos(ls_objectatpointer, '~t') - 1)

//Just to make sure these are set right.  The lbuttonup might not have registered to reset these attributes.
ib_header_selected = False

il_lbuttondown_x = xpos
il_lbuttondown_y = ypos

If Right(ls_objectatpointer, Len('_direction_srt')) = '_direction_srt' Then
	ls_objectatpointer = Left(ls_objectatpointer, Len(ls_objectatpointer) - Len('_direction_srt'))
End If

If Right(ls_objectatpointer, 4) = '_srt' Then
	If IsNumber(idw_data.Dynamic Describe(Left(ls_objectatpointer, Len(ls_objectatpointer) - 4) + '.X')) Then
		ib_header_selected = True
		is_header_selected = Left(ls_objectatpointer, Len(ls_objectatpointer) - 4)
		is_header_name = ls_objectatpointer
		is_header_text = Trim(idw_data.Dynamic Describe(is_header_name + '.Text'))
		This.of_translate_text(is_header_text, True)
	End If
End If

end subroutine

public subroutine of_recreate_view (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_recreate_view()
// Arguments:   adw_data	The datawindow to process
// Overview:    This will initialize the object
// Created by:  Blake Doerr
// History:     3/7/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
Datastore	lds_OriginalDatawindow
Datastore	lds_ViewDatawindow

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_OriginalDatawindow
String	ls_ViewDatawindow
String	ls_visible_headers
String	ls_invisible_headers

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are any problems
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_bag) Or Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datawindow tools and the three datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools 		= Create n_datawindow_tools
lds_OriginalDatawindow	= Create Datastore
lds_ViewDatawindow		= Create Datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the three versions of the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_OriginalDatawindow	= an_bag.of_get('Original Syntax')
ls_ViewDatawindow			= an_bag.of_get('View Syntax')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the syntaxes are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_OriginalDatawindow)) = 0 Or Len(Trim(ls_ViewDatawindow)) = 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the syntaxes to the datastores
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_apply_syntax(lds_OriginalDatawindow, ls_OriginalDatawindow)
ln_datawindow_tools.of_apply_syntax(lds_ViewDatawindow, ls_ViewDatawindow)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if any of the dataobjects are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lds_OriginalDatawindow.Object) Or Not IsValid(lds_ViewDatawindow.Object) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the changes to the datawindow to idw_data
//-----------------------------------------------------------------------------------------------------------------------------------
//string	ls_init

//ls_init = ln_datawindow_tools.of_get_expression( lds_ViewDatawindow, 'columnselectioninit')

//if isnull(ls_init) or ls_init = '' or ls_init = '?' or ls_init = '!' then
//	ls_init = ln_datawindow_tools.of_get_expression( lds_ViewDatawindow, 'columnselectioninit')
//end if

//If Left(ls_init, 1) = '"' And Right(ls_init, 1) = '"' Then
//	ls_init = Left(ls_init, Len(ls_init) - 1)
//	ls_init = Right(ls_init, Len(ls_init) - 1)
//End If

//if isnull(ls_init) or ls_init = '' or ls_init = '?' or ls_init = '!' Then
//Else
	//ln_datawindow_tools.of_set_expression( idw_data, 'columnselectioninit', ls_init)
	
	this.of_reinitialize()
	
	n_show_fields ln_show_fields
	ln_show_fields = Create n_show_fields
	ln_show_fields.of_init(lds_ViewDatawindow)
	//ls_visible_headers = ln_show_fields.of_get_all_header_text()
	ls_visible_headers = ln_show_fields.of_get_visible_header_text()
//	ls_invisible_headers = ln_show_fields.of_get_invisible_headertexts()
	Destroy ln_show_fields
	
	//		ls_headertexts = string( aany_arg)
		
	this.of_set_visible_headertexts(ls_visible_headers, TRUE)
	this.of_set_header_order(ls_visible_headers)
	this.of_apply( )
	
	
	//This.of_set_visible_headertexts( ls_invisible_headers, FALSE)
	//This.of_set_header_object_order(ls_visible_headers)
	//This.of_apply()
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Destroy lds_OriginalDatawindow
Destroy lds_ViewDatawindow
end subroutine

public function string of_get_visible_header_text ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_visible_headers()
//	Arguments:  None.
//	Overview:   This function gets the visible header information into a comma-delimited string.
//	Created by:	Denton Newham
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_upper
long		ll_i
string	ls_headers
String	ls_header_text[]

If Not ib_Initialized Then this.of_reinitialize()

ids_config.setfilter("visible='1'")
ids_config.filter()
ids_config.sort()

if ids_config.rowcount() = 0 then 
	ids_config.setfilter('')
	ids_config.filter()
	return ''
end if


ls_header_text[] = ids_config.object.text.primary

for ll_i = 1 to upperbound( ls_header_text[])
	ls_headers = ls_headers + ls_header_text[ll_i] + ','
next

if ls_headers > '' then ls_headers = left(ls_headers, len(ls_headers) - 1)

ids_config.setfilter("")
ids_config.filter()
ids_config.sort()

return ls_headers

////-----------------------------------------------------------------------------------------------------------------------------------
//// Loop through is_column_list.  Put the visible headers into ls_headers
////-----------------------------------------------------------------------------------------------------------------------------------
//ll_upper = UpperBound(is_header_object_text)
//If ll_upper < 1 Then Return ''
//
//For ll_index = 1 To ll_upper
//	for ll_index_2 = 1 to ll_upper
//		if il_header_order[ll_index_2] = ll_index then
//			ls_headers = ls_headers + is_header_object_text[ll_index_2] + ","
//		End If
//	next
//Next
//	
//Return Left(ls_headers, Len(ls_headers) - 1)		

	
	
	

end function

public function string of_get_visible_header_object ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_visible_header_object()
//	Arguments:  None.
//	Overview:   This function gets the visible header information into a comma-delimited string.
//	Created by:	Blake Doerr
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_upper
long		ll_i
string	ls_objects
String	ls_header_object[]

If Not ib_Initialized Then this.of_reinitialize()

ids_config.setfilter("visible='1'")
ids_config.filter()
ids_config.sort()

if ids_config.rowcount() = 0 then 
	ids_config.setfilter('')
	ids_config.filter()
	return ''
end if

ls_header_object[] = ids_config.object.name.primary

for ll_i = 1 to upperbound( ls_header_object[])
	ls_objects = ls_objects + ls_header_object[ll_i] + ','
next

if ls_objects > '' then ls_objects = left(ls_objects, len(ls_objects) - 1)

ids_config.setfilter("")
ids_config.filter()
ids_config.sort()

return ls_objects

end function

public function string of_get_invisible_headertexts ();
long		ll_i
string	ls_headertexts
String	ls_headertext[]
String	ls_visible[]

If Not ib_Initialized Then this.of_reinitialize()

ids_config.setfilter('visible="0"')
ids_config.filter()

if ids_config.rowcount() = 0 then
	ids_config.setfilter('')
	ids_config.filter()
	return ''
end if

ls_headertext[] = ids_config.object.text.primary
ls_visible[] = ids_config.object.visible.primary

for ll_i = 1 to upperbound(ls_headertext[])
	if ls_visible[ll_i] = '0' then
		ls_headertexts = ls_headertexts + ls_headertext[ll_i] + ','
	end if
next

if ls_headertexts > '' then ls_headertexts = left(ls_headertexts, len(ls_headertexts) - 1)

ids_config.setfilter('')
ids_config.filter()

ids_config.sort()

return ls_headertexts
end function

public function string of_get_all_header_text ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_visible_headers()
//	Arguments:  None.
//	Overview:   This function gets the visible header information into a comma-delimited string.
//	Created by:	Denton Newham
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_upper
long		ll_i
string	ls_headers
String	ls_header_text[]

If Not ib_Initialized Then this.of_reinitialize()

if ids_config.rowcount() = 0 then return ''

ls_header_text[] = ids_config.object.text.primary

for ll_i = 1 to upperbound(ls_header_text[])
	ls_headers = ls_headers + ls_header_text[ll_i] + ','
next

if ls_headers > '' then ls_headers = left(ls_headers, len(ls_headers) - 1)

////-----------------------------------------------------------------------------------------------------------------------------------
//// Loop through is_column_list.  Put the visible headers into ls_headers
////-----------------------------------------------------------------------------------------------------------------------------------
//ll_upper = UpperBound(is_header_object[])
//If ll_upper < 1 Then Return ''
//
//For ll_index = 1 To ll_upper
//	for ll_index_2 = 1 to ll_upper
//		if il_header_order[ll_index_2] = ll_index then
//			ls_headers = ls_headers + is_header_object_text[ll_index_2] + ","
//		end if
//	next
//Next
//	
//for ll_index = 1 to ll_upper
//	if il_header_order[ll_index] = 0 then
//		ls_headers = ls_headers + is_header_object_text[ll_index] + ","
//	end if
//next
//
//if ls_headers > '' then Return Left(ls_headers, Len(ls_headers) - 1)

return ls_headers

	
	
	

end function

public function string of_get_all_header_object ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_all_header_text()
//	Arguments:  None.
//	Overview:   This function gets the visible header information into a comma-delimited string.
//	Created by:	Blake Doerr
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_upper
long		ll_i
string	ls_headers
String	ls_header_object[]

If Not ib_Initialized Then this.of_reinitialize()

if ids_config.rowcount() = 0 then return ''

ls_header_object[] = ids_config.object.name.primary

for ll_i = 1 to upperbound(ls_header_object[])
	ls_headers = ls_headers + ls_header_object[ll_i] + ','
next

if ls_headers > '' then ls_headers = left(ls_headers, len(ls_headers) - 1)

return ls_headers

end function

public function boolean of_lbuttonup (unsignedlong flags, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_leftbuttonup()
// Arguments:   xpos, ypos, row - you can figure these out
// Overview:    This will manage the grouping and ungrouping of columns using the mouse on the datawindow
//							If you drag from the column header to the datawindow, you are grouping by that coloumn
//							If you drag from the group header to the column header , you are ungrouping by that coloumn
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String	ls_objectatpointer
String	ls_getbandatpointer
String	ls_header_selected
String	ls_header_name
String	ls_header_text
String	ls_headertexts
Boolean	lb_return = False


If TypeOf(idw_data) <> Datawindow! Then Return False
If Not ib_Initialized Then this.of_reinitialize()
		
if isvalid(ivo_pane_highlight) then
	iw_reference.Dynamic CloseUserObject(ivo_pane_highlight)
	lb_return = True
End If

If Not ib_header_selected Then Return lb_return

ib_header_selected = False

If Not (Left(idw_data.Dynamic GetBandAtPointer(), 6) = 'header' And Left(idw_data.Dynamic GetBandAtPointer(), 7) <> 'header.') Then Return lb_return

ls_objectatpointer = idw_data.Dynamic GetObjectAtPointer()
ls_objectatpointer = Left(ls_objectatpointer, Pos(ls_objectatpointer, '~t') - 1)

If Right(ls_objectatpointer, Len('_direction_srt')) = '_direction_srt' Then
	ls_objectatpointer = Left(ls_objectatpointer, Len(ls_objectatpointer) - Len('_direction_srt'))
End If

If Not Right(ls_objectatpointer, 4) = '_srt' Then Return lb_return

If Not IsNumber(idw_data.Dynamic Describe(Left(ls_objectatpointer, Len(ls_objectatpointer) - 4) + '.X')) Then Return lb_return

ls_header_selected = Left(ls_objectatpointer, Len(ls_objectatpointer) - 4)
ls_header_name = ls_objectatpointer
ls_header_text = Trim(idw_data.Dynamic Describe(ls_header_name + '.Text'))
If ls_header_name = is_header_name Then Return lb_return

this.of_reinitialize()
ls_headertexts = ',' + This.of_get_all_header_text() + ','

If Not Pos(ls_headertexts, ',' + ls_header_text + ',') > 0 Then Return lb_return
If Not Pos(ls_headertexts, ',' + is_header_text + ',') > 0 Then Return lb_return

ls_headertexts = Replace(ls_headertexts, Pos(ls_headertexts, ',' + is_header_text + ','), Len(',' + is_header_text + ','), ',')
ls_headertexts = Replace(ls_headertexts, Pos(ls_headertexts, ',' + ls_header_text + ','), 0, ',' + is_header_text + ',' + ls_header_text + ',')
ls_headertexts = Left(ls_headertexts, Len(ls_headertexts) - 1)
ls_headertexts = Right(ls_headertexts, Len(ls_headertexts) - 1)


This.of_set_header_order(ls_headertexts)
This.of_apply()

Return lb_return
end function

public function boolean of_mousemove (unsignedlong flags, long xpos, long ypos, boolean ab_create_floating_button);//----------------------------------------------------------------------------------------------------------------------------------
// Functino:      of_pbm_mousemove
// Overview:   If the mouse has been moved over the object while the left button was clicked then
//					move the highlight
//
// Created by: Blake Doerr
// History:    2/20/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean	lb_show_arrow
Long 		ll_backcolor
Long		ll_xposition
Long		ll_yposition_bottom
Long		ll_yposition_top
String	ls_modify
String	ls_objectatpointer
String	ls_header_selected
String	ls_return

If TypeOf(idw_data) <> Datawindow! Then Return False
If Not ib_Initialized Then this.of_reinitialize()
		
lb_show_arrow = ib_header_selected And flags = 1

If lb_show_arrow Then
	lb_show_arrow = (Left(idw_data.Dynamic GetBandAtPointer(), 6) = 'header' And Left(idw_data.Dynamic GetBandAtPointer(), 7) <> 'header.')
End If

If lb_show_arrow Then
	ls_objectatpointer = idw_data.Dynamic GetObjectAtPointer()
	ls_objectatpointer = Left(ls_objectatpointer, Pos(ls_objectatpointer, '~t') - 1)
	If Right(ls_objectatpointer, Len('_direction_srt')) = '_direction_srt' Then
		ls_objectatpointer = Left(ls_objectatpointer, Len(ls_objectatpointer) - Len('_direction_srt'))
	End If
	lb_show_arrow = Right(ls_objectatpointer, 4) = '_srt'
End If

If lb_show_arrow Then
	lb_show_arrow = IsNumber(idw_data.Dynamic Describe(Left(ls_objectatpointer, Len(ls_objectatpointer) - 4) + '.X'))
End If

If lb_show_arrow Then
	ls_header_selected = ls_objectatpointer//Left(ls_objectatpointer, Len(ls_objectatpointer) - 4)

	ll_xposition = Long(idw_data.Dynamic Describe(ls_header_selected + '.X')) - 64
	ll_yposition_top 		= Long(idw_data.Dynamic Describe(ls_header_selected + '.Y')) - 35
	ll_yposition_bottom	= ll_yposition_top + Long(idw_data.Dynamic Describe(ls_header_selected + '.Height')) + 35
	
	If IsNumber(idw_data.Dynamic Describe('show_fields_arrow_bottom.X')) Then
		idw_data.Dynamic Modify('show_fields_arrow_bottom.X = ' + String(ll_xposition))
		idw_data.Dynamic Modify('show_fields_arrow_bottom.Y = ' + STring(ll_yposition_bottom))
		idw_data.Dynamic Modify('show_fields_arrow_top.X = ' + String(ll_xposition))
		idw_data.Dynamic Modify('show_fields_arrow_top.Y = ' + STring(ll_yposition_top))
		
	Else
		ls_modify = "create text(band=foreground color='255' alignment='2' border='0' height.autosize=No pointer='Arrow!' moveable=0 resizeable=0  x='" + string(ll_xposition) + "' y='" + string(ll_yposition_bottom) + "' height='61' width='115' text='é' " + &
								" name=show_fields_arrow_bottom font.face='Wingdings' font.height='-6'" + &
								" font.weight='400' font.family='1' font.pitch='0' font.charset='2' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='1' background.color='553648127' visible='1')"

		
		ls_return = idw_data.Dynamic Modify(ls_modify)
		
		ls_modify = "create text(band=foreground color='255' alignment='2' border='0' height.autosize=No pointer='Arrow!' moveable=0 resizeable=0  x='" + string(ll_xposition) + "' y='" + string(ll_yposition_top) + "' height='61' width='115' text='ê' " + &
								" name=show_fields_arrow_top font.face='Wingdings' font.height='-6'" + &
								" font.weight='400' font.family='1' font.pitch='0' font.charset='2' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='1' background.color='553648127' visible='1')"

		
		ls_return = idw_data.Dynamic Modify(ls_modify)
	End If
End If

If Not lb_show_arrow Then
	idw_data.Dynamic Modify('Destroy show_fields_arrow_bottom')
	idw_data.Dynamic Modify('Destroy show_fields_arrow_top')
End If

If Not ab_create_floating_button Then Return False

//-----------------------------------------------------
// flags = 1:  Mouse Clicked
// ib_we_are_resizing = True mouse clicked while over
// object, Set to True in the leftbuttondown event.
//-----------------------------------------------------
if xpos = il_lbuttondown_x and ypos = il_lbuttondown_y then Return False

If ib_header_selected And Right(is_header_name, 14) <> '_direction_srt' Then
	//If the object doesn't exists, create it.  Else move it to the xposition
	If flags <> 1 Then
		if isvalid(ivo_pane_highlight) then
			iw_reference.Dynamic CloseUserObject(ivo_pane_highlight)
		End If
		ib_header_selected 	= False
	Else
		if isvalid(ivo_pane_highlight) then
			ivo_pane_highlight.X = iw_reference.Dynamic PointerX() + 10
			ivo_pane_highlight.Y = iw_reference.Dynamic PointerY() + 10
		Else
			//Open the statictext and copy all the properties from the column header to make it look alikce
			iw_reference.Dynamic OpenUserObject ( ivo_pane_highlight, 10000, 10000)
			ivo_pane_highlight.BringToTop 	= True
			If ib_header_selected Then
				ll_backcolor = Long(	idw_data.Dynamic Describe(is_header_name + '.Background.Color'))
				If ll_backcolor = 536870912 Or ll_backcolor = 553648127 Then ll_backcolor = 16777215
				ivo_pane_highlight.Backcolor 		= ll_backcolor
				ivo_pane_highlight.Text 			= 			idw_data.Dynamic Describe(is_header_name + '.Text')
				ivo_pane_highlight.Height 			= Long(	idw_data.Dynamic Describe(is_header_name + '.Height')) + 15
				ivo_pane_highlight.Width 			= Long(	idw_data.Dynamic Describe(is_header_name + '.Width')) + 15

				ivo_pane_highlight.FaceName		= idw_data.Dynamic Describe(is_header_name + '.Font.Face')
				ivo_pane_highlight.TextSize		= Long(idw_data.Dynamic Describe(is_header_name + '.Font.Height'))
				ivo_pane_highlight.Weight			= Long(idw_data.Dynamic Describe(is_header_name + '.Font.Weight'))
				
				ivo_pane_highlight.X = iw_reference.Dynamic PointerX() + 10
				ivo_pane_highlight.Y = iw_reference.Dynamic PointerY() + 10
				Choose 	Case	idw_data.Dynamic Describe(is_header_name + '.Border')
					Case '0'
						ivo_pane_highlight.Border 			= False
					Case '1'
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleShadowBox!
					Case '2'
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleBox!
					Case '5'
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleLowered!
					Case Else
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleRaised!
				End Choose
				
				Choose	Case idw_data.Dynamic Describe(is_header_name + '.Alignment')
					Case '1'
						ivo_pane_highlight.Alignment		= Right!
					Case '2'
						ivo_pane_highlight.Alignment		= Center!
					Case Else
						ivo_pane_highlight.Alignment		= Left!
				End Choose
			Else
				ivo_pane_highlight.Text 			= 'Ungrouping'
				ivo_pane_highlight.Height 			= 70
				ivo_pane_highlight.Width 			= 600
				ivo_pane_highlight.FaceName		= 'Tahoma'
				ivo_pane_highlight.TextSize		= - 8
				ivo_pane_highlight.X = iw_reference.Dynamic PointerX() + 10
				ivo_pane_highlight.Y = iw_reference.Dynamic PointerY() + 10
				ivo_pane_highlight.Border 			= True
				ivo_pane_highlight.BorderStyle 	= StyleRaised!
				ivo_pane_highlight.Alignment		= Left!
				ivo_pane_highlight.Backcolor		= 79741120
			End If
			
		End IF
		Return True
	End If
Else
	if isvalid(ivo_pane_highlight) then
		iw_reference.Dynamic CloseUserObject(ivo_pane_highlight)
	End If
End If

Return False
end function

public subroutine of_apply_excluded_objects (ref string as_columns[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_excluded_objects()
//	Arguments:  as_column - the column
//	Overview:   Determine if a column is excluded
//	Created by:	Blake Doerr
//	History: 	7.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_objects[]

For ll_index = 1 To UpperBound(as_columns[])
	If Not of_IsExcluded_object(as_columns[ll_index]) Then
		ls_objects[UpperBound(ls_objects) + 1] = as_columns[ll_index]
	End If
Next
as_columns[] = ls_objects
end subroutine

public function boolean of_isexcluded_object (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isexcluded_object()
//	Arguments:  as_column - the column
//	Overview:   Determine if a column is excluded
//	Created by:	Blake Doerr
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

public subroutine of_init (powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data
//	Overview:   Set the datawindow to be processed.
//	Created by:	Denton Newham
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject luo_temp
PowerObject lpo_temp
//n_string_functions	ln_string

SetPointer(HourGlass!)

if not isvalid(adw_data) then return

idw_data = adw_data

If TypeOf(idw_data) = Datawindow! Then
	if isvalid(gn_globals.in_subscription_service) then
		gn_globals.in_subscription_service.of_subscribe( this, 'before recreate view', idw_data)
		gn_globals.in_subscription_service.of_subscribe( this, 'recreate view - column selection', idw_data)
		gn_globals.in_subscription_service.of_subscribe( this, 'remove a column', idw_data)
		gn_globals.in_subscription_service.of_subscribe( this, 'column added or removed', idw_data)
		gn_globals.in_subscription_service.of_subscribe( this, 'after view restored', idw_data)
		gn_globals.in_subscription_service.of_subscribe( this, 'column deleted', idw_data)
	end if
	
	
	//Find the parentwindow to be used later as a reference for coordinate systems.
	lpo_temp = idw_data.GetParent()
	
	//Store the total classname for use in the registry
	DO WHILE lpo_temp.TypeOf() <> Window!
		lpo_temp = lpo_temp.GetParent()
	LOOP
	
	iw_reference = lpo_temp
End If

//This.of_reinitialize()

end subroutine

public subroutine of_reinitialize ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reinitialize()
//	Arguments:  None.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Scott Creed
//	History: 	3/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions	ln_string

SetPointer(HourGlass!)

If Not ib_initialized Then This.of_interrogate_datawindow()

ib_Initialized = True


//-----------------------------------------------------------------------------------------------------------------------------------
// Load the columns, headers, x and width arrays
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_load_columns()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the invisible columns out of the datawindow computed field for this object.
//-----------------------------------------------------------------------------------------------------------------------------------
If this.of_load_columnselectioninit() Then
	If Len(Trim(is_invisible_headertexts)) = 0 Or is_invisible_headertexts = '' Or IsNull(is_invisible_headertexts) Then
	Else
		This.of_set_visible_headertexts( is_invisible_headertexts, FALSE)
	End If
	
	this.of_load_header_order()
	
	if trim(is_invisible_headertexts) > '' then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Show only the visible headers.
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_apply()
	end if
Else
	this.of_load_header_order()
End If
end subroutine

public subroutine of_exclude_object (string as_columnlist);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_exclude_object()
//	Arguments:  as_columnlist - the column list
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
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

protected subroutine of_interrogate_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_interrogate_datawindow()
//	Overview:   This will pull the serviceinit off the dataobject to initialize services
//	Created by:	Blake Doerr
//	History: 	10/31/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
n_datawindow_tools ln_datawindow_tools 
String 	ls_expression
String	ls_exclude_objects
String	ls_specialexpression_objects
String	ls_empty[]

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

is_excluded_object[]		= ls_empty[]

If Len(ls_exclude_objects) > 0 				Then This.of_exclude_object(ls_exclude_objects)
end subroutine

public function string of_load_columns ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_load_columns
//	Arguments:  None
//	Overview:   This function reads the datawindow and loads the header and column lists and the association
//					between the two
//	Created by:	Scott Creed
//	History: 	07.19.2000 - First Created 
//             09.12.2000 - Added upperbound checks on arrays in final loop to handle datawindows with collapsing
//                          rows.  In that case an "Array Boundry Exceeded" error would occur. [TAD]
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declare variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_object_count
Long		ll_index, ll_index2, ll_i
Long		ll_headers
Long		ll_header_height
Long		ll_number

String	ls_header_object[]
String	ls_describe_header_object_x
String	ls_describe_header_object_width
String	ls_describe_header_object_text

String	ls_column_list[]

String	ls_describe_x

String	ls_visible_string[]
String	ls_header_object_x[]
String	ls_header_object_width[]
String	ls_header_object_text[]

String	ls_all_objects
String	ls_all_object[]
String	ls_object[]
String	ls_describe_bands
String	ls_describe_types
String	ls_bands
String	ls_types
String	ls_band[]
String	ls_type[]
String	ls_column_name
String	ls_describe_visible
String	ls_visible_strings
String	ls_column_x[]
String	ls_suffix

Boolean	lb_found

//n_string_functions	ln_string


if NOT isvalid(idw_data) then RETURN ''

il_minimum_x = 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the objects in the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_all_objects = idw_data.Dynamic describe( "datawindow.objects")
gn_globals.in_string_functions.of_parse_string( ls_all_objects, "~t", ls_all_object[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all objects and remove those that are created by other services
//-----------------------------------------------------------------------------------------------------------------------------------
ll_object_count = upperbound(ls_all_object[])

For ll_index = 1 to ll_object_count
	if NOT Match( ls_all_object[ll_index], '_direction_srt$') &
		AND NOT match(ls_all_object[ll_index], '^columnedge') &
		AND NOT Match(ls_all_object[ll_index], '^report_title') &
		AND NOT Match(ls_all_object[ll_index], '^report_footer') &
		AND NOT Match(ls_all_object[ll_index], '^report_bitmap') &
		AND NOT Match(ls_all_object[ll_index], '^ignore_') &
		then
		ll_i++
		ls_object[ll_i] = ls_all_object[ll_index]
	end if
next

This.of_apply_excluded_objects(ls_object[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all objects and build describe statements that will get the band and type of each object
//-----------------------------------------------------------------------------------------------------------------------------------
ll_object_count = upperbound(ls_object[])

FOR ll_index = 1 TO ll_object_count
	if ls_describe_bands > '' then
		ls_describe_bands = ls_describe_bands + "~t"
		ls_describe_types = ls_describe_types + "~t"
	end if
	ls_describe_bands = ls_describe_bands + ls_object[ll_index] + ".band"
	ls_describe_types = ls_describe_types + ls_object[ll_index] + ".type"
NEXT

//-----------------------------------------------------------------------------------------------------------------------------------
// Describe the bands and put them into an array
//-----------------------------------------------------------------------------------------------------------------------------------
ls_bands = idw_data.Dynamic describe( ls_describe_bands)
gn_globals.in_string_functions.of_parse_string( ls_bands, "~n", ls_band[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Describe the types and put them into an array
//-----------------------------------------------------------------------------------------------------------------------------------
ls_types = idw_data.Dynamic describe( ls_describe_types)
gn_globals.in_string_functions.of_parse_string( ls_types, "~n", ls_type[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through each object.  If it is a header text or compute, build several describes for the header.
//	If it is a detail object, build a describe for its x and visible attributes.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_i 			= 0
ll_headers 	= 0

ll_header_height = long(idw_data.Dynamic describe( 'DataWindow.Header.Height'))

for ll_index = 1 to ll_object_count
	if ls_band[ll_index] = "header" &
		and (lower(ls_type[ll_index]) = 'text' OR lower(ls_type[ll_index]) = 'compute') &
		and long(idw_data.Dynamic describe( ls_object[ll_index] + '.y')) < ll_header_height then
		ll_headers++
		ls_header_object[ll_headers] = ls_object[ll_index]
		if ls_describe_header_object_x > '' then
			ls_describe_header_object_x = ls_describe_header_object_x + "~t"
			ls_describe_header_object_width = ls_describe_header_object_width + "~t"
			ls_describe_header_object_text = ls_describe_header_object_text + "~t"
		end if
		ls_describe_header_object_x = ls_describe_header_object_x + ls_header_object[ll_headers] + ".x"
		ls_describe_header_object_width = ls_describe_header_object_width + ls_header_object[ll_headers] + ".width"
		
		if ls_type[ll_index] = 'text' then
			ls_describe_header_object_text = ls_describe_header_object_text + ls_header_object[ll_headers] + ".Text"
		else
			ls_describe_header_object_text = ls_describe_header_object_text + ls_header_object[ll_headers] + ".name"
		end if
	elseif ls_band[ll_index] = "detail" and lower(ls_type[ll_index]) <> 'line' and not match(is_excludedcolumns, ',' + lower(trim(ls_object[ll_index])) + ',') then
		ll_i++
		ls_column_list[ll_i] = ls_object[ll_index]
		ls_column_name = ls_column_list[ll_i]

		if ls_describe_x > '' then
			ls_describe_x = ls_describe_x + "~t"
			ls_describe_visible = ls_describe_visible + "~t"
		end if
		
		ls_describe_x = ls_describe_x + ls_column_name + ".x"
		ls_describe_visible = ls_describe_visible + ls_column_name + ".visible"
	end if
NEXT

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the current visible attributes for all the columns
//-----------------------------------------------------------------------------------------------------------------------------------
ls_visible_strings = idw_data.Dynamic describe( ls_describe_visible)

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace single quotes in those attributes with double quotes to prevent syntax failure on Modify
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(ls_visible_strings, "'", '"')

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse these visible attributes into the instance array
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string( ls_visible_strings, "~n", ls_visible_string[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the x values for all the columns
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_xs
ls_xs = idw_data.Dynamic describe( ls_describe_x)
gn_globals.in_string_functions.of_parse_string( ls_xs, "~n", ls_column_x[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the x values for all the headers and store it into an instance array
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_header_xs
ls_header_xs = idw_data.Dynamic describe( ls_describe_header_object_x)
gn_globals.in_string_functions.of_parse_string( ls_header_xs, "~n", ls_header_object_x[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the width values for all the headers and store it into an instance array
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_header_widths
ls_header_widths = idw_data.Dynamic describe( ls_describe_header_object_width)
gn_globals.in_string_functions.of_parse_string( ls_header_widths, "~n", ls_header_object_width[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the text for all the headers and store it into an instance array
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_header_texts
ls_header_texts = idw_data.Dynamic describe( ls_describe_header_object_text)
gn_globals.in_string_functions.of_parse_string( ls_header_texts, "~n", ls_header_object_text[])

For ll_index = 1 To UpperBound(ls_header_object_text[])
	This.of_translate_text(ls_header_object_text[ll_index], True)
	
	ll_number = 1
	ls_suffix = ''
	lb_found = True
	
	Do While lb_found
		lb_found = False
		
		For ll_index2 = 1 To ll_index - 1
			If ls_header_object_text[ll_index2] = ls_header_object_text[ll_index] + ls_suffix Then
				lb_found = True
				ll_number = ll_number + 1
				ls_suffix = ' (' + String(ll_number) + ')'
				Exit
			End If
		Next
	Loop
	
	If ls_suffix <> '' Then ls_header_object_text[ll_index] = ls_header_object_text[ll_index] + ls_suffix
Next

if isvalid(ids_config) then Destroy ids_config

ids_config = create datastore
ids_config.dataobject = 'd_show_fields_data'

for ll_i = 1 to upperbound(ls_header_object[])
	ids_config.insertrow(0)
	ids_config.setitem(ll_i,'visible','1')
next

if ids_config.rowcount() = 0 then RETURN ''

ids_config.object.name.primary 			= 	ls_header_object[]
ids_config.object.text.primary 			= 	ls_header_object_text[]
ids_config.object.x.primary				=	ls_header_object_x[]
ids_config.object.width.primary 			= 	ls_header_object_width[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the headers and associate every object in the detail band that is
// underneath it (column.x is between header.x and header.x + header.width)
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_j
string	ls_object_list, ls_object_offset_list, ls_object_visible_expression_list

for ll_i = 1 to ids_config.rowcount()
	ls_object_list 					= ''
	ls_object_offset_list 			= ''
	ls_object_visible_expression_list 	= ''
	for ll_j = 1 to upperbound( ls_column_list[])
		If (upperbound(ls_column_x) >= ll_j AND upperbound(ls_header_object_x) >= ll_i AND upperbound(ls_header_object_width) >= ll_i) Then
			if long(ls_column_x[ll_j]) >= long(ls_header_object_x[ll_i]) AND long(ls_column_x[ll_j]) <= long(ls_header_object_x[ll_i]) + long(ls_header_object_width[ll_i]) Then
				ls_object_list = ls_object_list 						+ ls_column_list[ll_j] + '||'
				ls_object_offset_list = ls_object_offset_list 	+ string(long(ls_column_x[ll_j]) - long(ls_header_object_x[ll_i])) + '||'
				ls_object_visible_expression_list = ls_object_visible_expression_list + ls_visible_string[ll_j] + '||'
			end if
	   End If
	Next
	
	if ls_object_list > '' then
		ids_config.setitem( ll_i, 'object_list', left(ls_object_list, len(ls_object_list) - 2 ))
	end if
	
	if ls_object_offset_list > '' then
		ids_config.setitem( ll_i, 'object_offset_list', left(ls_object_offset_list, len(ls_object_offset_list) - 2 ))
	end if
	
	if ls_object_visible_expression_list > '' then
		ids_config.setitem( ll_i, 'object_visible_expression_list', left(ls_object_visible_expression_list, len(ls_object_visible_expression_list) - 2 ))
	end if
			
next

if ids_config.rowcount() > 0 then
	il_minimum_x = long(ids_config.describe("evaluate('min(long(x))',1)"))
else 
	il_minimum_x = 0
end if

return ''
end function

public function n_bag of_get_information ();//Open the show fields window.

n_bag ln_bag
ln_bag = create n_bag

ln_bag.of_set('all items', this.of_get_all_header_text())
ln_bag.of_set('all objects', this.of_get_all_header_object())
ln_bag.of_set('selected items', this.of_get_visible_header_text())
ln_bag.of_set('apply message', 'apply visible columns')
ln_bag.of_set('affected datawindow', idw_data)
ln_bag.of_set('add/remove items', is_addremoveheaders)
Return ln_bag
end function

public subroutine of_apply ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply()
//	Arguments:  None
//	Overview:   Loop through the visible headers and modify the datawindow accordingly. 
//	Created by:	Denton Newham
//	History: 	1/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
//string	ls_modify
//string 	ls_spacer_x, ls_spacer_width
//string	ls_expression, ls_new_expression
//
//string	ls_values[], ls_arguments[]
//
//long 		ll_index, ll_loop, ll_loop_2
//long		ll_max_x
//
//boolean lb_argument_exists

Boolean	lb_argument_exists
Long		ll_loop
Long		ll_loop_2

String	ls_modify
String	ls_header[]
String	ls_visible[]
String	ls_x[]
String	ls_object_list[]
String	ls_object[]
String	ls_object_offset_list[]
String	ls_object_offset[]
String	ls_object_visible_expression_list[]
String	ls_object_visible_expression[]

String	ls_new_expression
String	ls_expression
String	ls_arguments[]
String	ls_values[]

String	ls_empty[]

//n_string_functions ln_string

SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the redraw for the datawindow to false.  Make all of the columns and headers invisible.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case TypeOf(idw_data)
	Case Datawindow!
		idw_data.Dynamic SetRedraw(False)
		idw_data.Dynamic post SetRedraw(TRUE)
End Choose

this.of_recalculate_x_values()
	
	If ids_config.RowCount() > 0 Then
	ls_header[] 								= ids_config.object.name.primary
	ls_visible[] 								= ids_config.object.visible.primary
	ls_x[]										= ids_config.object.x.primary
	ls_object_list[]							= ids_config.object.object_list.primary
	ls_object_offset_list[] 				= ids_config.object.object_offset_list.primary
	ls_object_visible_expression_list[] = ids_config.object.object_visible_expression_list.primary
End If

for ll_loop = 1 to UpperBound(ls_header[])
	
	ls_modify = ls_modify + ls_header[ll_loop] + ".Visible='" + ls_visible[ll_loop] + "' "
	ls_modify = ls_modify + ls_header[ll_loop] + ".x=" + ls_x[ll_loop] + " "
	
	ls_object[] 							= ls_empty[]
	ls_object_offset[]					= ls_empty[]
	ls_object_visible_expression[] 	= ls_empty[]
	
	gn_globals.in_string_functions.of_parse_string( ls_object_list[ll_loop], '||', ls_object[])
	gn_globals.in_string_functions.of_parse_string( ls_object_offset_list[ll_loop], '||', ls_object_offset[])
	gn_globals.in_string_functions.of_parse_string( ls_object_visible_expression_list[ll_loop], '||', ls_object_visible_expression[])
	
	for ll_loop_2 = 1 to UpperBound( ls_object[])
		ls_modify = ls_modify + ls_object[ll_loop_2] + '.x=' + string(long(ls_x[ll_loop]) + long(ls_object_offset[ll_loop_2])) + " "
		if ls_visible[ll_loop] = '1' then
			if left(ls_object_visible_expression[ll_loop_2], 5) = '0~t0//' then
				ls_object_visible_expression[ll_loop_2] = mid(ls_object_visible_expression[ll_loop_2],6,9999)
			end if
		else
			if left(ls_object_visible_expression[ll_loop_2], 5) <> '0~t0//' then
				ls_object_visible_expression[ll_loop_2] = '0~t0//' + ls_object_visible_expression[ll_loop_2]
			end if
		end if
		ls_modify = ls_modify + ls_object[ll_loop_2] + ".visible='" + ls_object_visible_expression[ll_loop_2] + "' "
		
		Choose Case TypeOf(idw_data)
			Case Datawindow!
				if long(idw_data.Dynamic Describe(ls_object[ll_loop_2] + '.tabsequence')) > 0 then
					idw_data.Dynamic SetTabOrder(ls_object[ll_loop_2], long(ls_x[ll_loop]) + long(ls_object_offset[ll_loop_2]))
				end if		
		End Choose
	next
			
Next

if ls_modify > '' then ls_modify = left(ls_modify, len(ls_modify) - 1)

idw_data.Dynamic modify(ls_modify)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the list of invisible columns into a comma delimited expression.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_new_expression  = this.of_get_invisible_headertexts()

n_datawindow_tools	ln_data_tools

ln_data_tools = create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the old initialization expression for the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
If ln_data_tools.of_column_exists(idw_data, 'columnselectioninit') Then
	ls_expression = ln_data_tools.of_get_expression(idw_data, 'columnselectioninit')

	If Left(ls_expression, 1) = '"' And Right(ls_expression, 1) = '"' Then
		ls_expression = Left(ls_expression, Len(ls_expression) - 1)
		ls_expression = Right(ls_expression, Len(ls_expression) - 1)
	End If
Else
	ls_expression = ''
End If
gn_globals.in_string_functions.of_parse_arguments(ls_expression, '||', ls_arguments[], ls_values[])
			
//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all elements of the array and replace the values for the invisible columns.
//-----------------------------------------------------------------------------------------------------------------------------------
lb_argument_exists = False
For ll_loop = 1 To Min(UpperBound(ls_arguments), UpperBound(ls_values))
	If Lower(Trim(ls_arguments[ll_loop])) = 'invisible headers' Then
		lb_argument_exists = True
		ls_values[ll_loop] = ls_new_expression
		Exit
	End If
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the expression.
//-----------------------------------------------------------------------------------------------------------------------------------			
ls_expression = ''
For ll_loop = 1 To Min(UpperBound(ls_arguments), UpperBound(ls_values))
	ls_expression = ls_expression + ls_arguments[ll_loop] + '=' + ls_values[ll_loop] + '||'
Next

//----------------------------------------------------------------------------------------------------------------------------------
// If the argument does not exist, then take it and the new expression on at the end of the old expression
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ls_expression) Then ls_expression = ''
If Not lb_argument_exists Then
	ls_expression = ls_expression + 'invisible headers=' + ls_new_expression
Else
	ls_expression = Left(ls_expression, Len(ls_expression) - 2)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Save off the expression to the init column of the datawindow.  If this column does not exist, it will be created.
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_expression)) > 0 Then
	ln_data_tools.of_set_expression(idw_data, 'columnselectioninit', ls_expression)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Recalculate the statistics
//-----------------------------------------------------------------------------------------------------------------------------------
ln_data_tools.of_apply_expressions(idw_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message to restore the view for all the services to respond to.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('visible columns changed', '', idw_data)
End If

destroy ln_data_tools
end subroutine

public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	Blake Doerr
//	History: 	3/1/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_index
String	ls_invisible_headers
String	ls_invisible[]

n_menu_dynamic ln_menu_dynamic
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a spacer since the menu has items already
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column selection menu items
//-----------------------------------------------------------------------------------------------------------------------------------
If (ab_IsColumn Or ab_IsComputedField) And is_addremoveheaders = 'Y' Then
	an_menu_dynamic.of_add_item('&Hide This Column', 'remove a column', as_objectname, This)
End If
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column selection menu items for nonvisual reporting
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_batchmode Then
	ls_invisible_headers = This.of_get_invisible_headertexts()
	gn_globals.in_string_functions.of_parse_string(ls_invisible_headers, ',', ls_invisible[])
	
	If UpperBound(ls_invisible[]) > 0 Then
		ln_menu_dynamic = an_menu_dynamic.of_add_item('&Show Hidden Columns', 'show a column', as_objectname, This)
		
		For ll_index = 1 To UpperBound(ls_invisible[])
			ln_menu_dynamic.of_add_item('&Show "' + ls_invisible[ll_index] + '"', 'show a column', ls_invisible[ll_index], This)
		Next
	End If
	
	ln_menu_dynamic = an_menu_dynamic.of_add_item('&Move Column', '', '', This)
	ln_menu_dynamic.of_add_item('Move Column &First', 'move column first', as_objectname, This)
	ln_menu_dynamic.of_add_item('Move Column &Left', 'move column left', as_objectname, This)
	ln_menu_dynamic.of_add_item('Move Column &Right', 'move column right', as_objectname, This)
	ln_menu_dynamic.of_add_item('Move Column L&ast', 'move column last', as_objectname, This)
Else
	an_menu_dynamic.of_add_item('&Column Selection/Formatting...', 'field selection', '', This)
End If

end subroutine

public subroutine of_show_headertext (string as_headertext);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_remove_column()
//	Arguments:  as_headertext	- The header that is to be removed.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	3/1/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------

long	ll_index, ll_row
//n_string_functions ln_string_functions

gn_globals.in_string_functions.of_replace_all(as_headertext, '"', '~~"')

ll_row = ids_config.find( 'lower(text)= "' + lower(as_headertext) + '"', 1, ids_config.rowcount())

if ll_row <= 0 then RETURN

ids_config.setitem( ll_row, 'visible', '1')

ids_config.sort()

This.of_apply()
end subroutine

on n_show_fields.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_show_fields.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

