$PBExportHeader$n_sort_service.sru
$PBExportComments$Datawindow Service - This is the sort service.  It will allow you to click sort the datawindow columns.
forward
global type n_sort_service from nonvisualobject
end type
end forward

global type n_sort_service from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_sort_service n_sort_service

type variables
Protected:
	PowerObject 	idw_data
	boolean 		ib_sortbykey
	boolean 		ib_hassubscribed = False
	Boolean		ib_batchmode = False
	String		is_latest_sortstring
	String		is_latest_sortstring_gui
	string 		is_suffix
	String		is_bitmap_suffix = '_direction_srt'
	String		is_ascending_character	= 'Ù'
	String		is_descending_character	= 'Ú'
	String		is_destroy_string = ''
	String		is_column_clicked
	
	String		is_ObjectLeftButtonDownOn	= ''
	n_datawindow_tools in_datawindow_tools
	string		is_ignore_dropdowns = 'dddw_logistics_schdlngprdid,dddw_search_vetradeperiod'
end variables

forward prototypes
public subroutine of_publish_message ()
public subroutine of_set_sort_by_key (boolean ab_sortbykey)
public subroutine of_retrieveend (long rowcount)
public subroutine of_printstart (long pagesmax)
public subroutine of_printend (long pagesprinted)
public function datawindow of_get_datasource ()
public subroutine of_recreate_view (n_bag an_bag)
public subroutine of_get_sort (ref string as_column[], ref string as_ascendingdescending[])
public subroutine of_reinitialize (boolean ab_setsort)
public subroutine of_reinitialize ()
public subroutine of_sort ()
public subroutine of_set_sort (string as_sort)
public subroutine of_destroy_objects ()
public subroutine of_lbuttondown (unsignedlong flags, long xpos, long ypos)
public subroutine of_get_multisort_data (ref string as_column_name[], ref string as_column_header_text[], ref string as_column_header[], ref datawindow adw_sort)
public subroutine of_init (powerobject dw_data, string s_suffix, string s_multi_column)
public subroutine of_set_sort (string as_original_sort, string as_sort)
public subroutine of_apply_sort_to_gui (string as_sort_string)
public subroutine of_set_batch_mode (boolean ab_batchmode)
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public subroutine of_clicked ()
public subroutine of_sort_object (string as_objectname, boolean ab_extendedsort, boolean ab_ascending)
end prototypes

event ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   7.21.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Window	lw_window
String	ls_columnname
String	ls_argument

Choose Case Trim(Lower(as_message))
	Case 'after view restored'
		ls_argument = String(as_arg)
		is_latest_sortstring = ''
		This.of_reinitialize(Pos(Lower(ls_argument), 'applysort=n') <= 0)
	Case 'after generate'
		This.of_reinitialize(False)
	Case 'group by happened'
		This.of_set_sort('')
//		This.of_reinitialize()
	Case 'columnresize', 'visible columns changed'
		This.of_apply_sort_to_gui(is_latest_sortstring_gui)
	Case 'sort ascending'
		This.of_sort_object(String(as_arg) + is_suffix, False, True)
	Case 'append sort ascending'
		This.of_sort_object(String(as_arg) + is_suffix, True, True)
	Case 'sort descending'
		This.of_sort_object(String(as_arg) + is_suffix, False, False)
	Case 'append sort descending'
		This.of_sort_object(String(as_arg) + is_suffix, True, False)
	Case 'sort multiple'
		OpenWithParm(lw_window, This, 'w_sort_multi')
	Case 'before view saved', 'before generate'
		This.of_destroy_objects()
	Case 'recreate view - sort'
		This.of_recreate_view(Message.PowerObjectParm)
End Choose
end event

public subroutine of_publish_message ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_publish_message()
// Overview:    This will publish a message that there has been sorting so services can respond if the want to
// Created by:  Blake Doerr
// History:     3/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Publish a message that says the columns were sorted to see if anyone needs to respond
if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message('Sort', is_latest_sortstring, idw_data)
end if

n_multimedia ln_multimedia
ln_multimedia.of_play_sound('GUI Sounds - Bestfit.wav')
end subroutine

public subroutine of_set_sort_by_key (boolean ab_sortbykey);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_sort_by_key()
// Arguments:   ab_sortbykey
// Overview:    toggle the sort by key functionality
// Created by:  Jake Pratt
// History:     07/22/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_sortbykey = ab_sortbykey
end subroutine

public subroutine of_retrieveend (long rowcount);String	ls_currentsort

If rowcount <= 0 Then Return

ls_currentsort = in_datawindow_tools.of_get_sort(idw_data)

If Left(Lower(ls_currentsort), 10) = 'sortcolumn' Then
	This.of_reinitialize()
End If
	
end subroutine

public subroutine of_printstart (long pagesmax);
end subroutine

public subroutine of_printend (long pagesprinted);This.of_apply_sort_to_gui(is_latest_sortstring_gui)
end subroutine

public function datawindow of_get_datasource ();Return idw_data
end function

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
//n_string_functions	ln_string_functions
Datastore	lds_OriginalDatawindow
Datastore	lds_ViewDatawindow

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_OriginalDatawindow
String	ls_ViewDatawindow
String	ls_original_sortinit
String	ls_view_sortinit

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are any problems
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_bag) Or Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Create two datastores
//-----------------------------------------------------------------------------------------------------------------------------------
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
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_apply_syntax(lds_OriginalDatawindow, ls_OriginalDatawindow)
ln_datawindow_tools.of_apply_syntax(lds_ViewDatawindow, ls_ViewDatawindow)

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the changes to the datawindow to idw_data
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(lds_OriginalDatawindow.Object) And IsValid(lds_ViewDatawindow.Object) Then
	If ln_datawindow_tools.of_IsComputedField(lds_ViewDatawindow, 'sortinit') Then
		ls_original_sortinit = ln_datawindow_tools.of_get_expression(lds_OriginalDatawindow, 'sortinit')
		ls_view_sortinit 		= ln_datawindow_tools.of_get_expression(lds_ViewDatawindow, 'sortinit')
		
		If IsNull(ls_original_sortinit) Then ls_original_sortinit = ''
		If IsNull(ls_view_sortinit) Then ls_view_sortinit = ''
		
		If ls_original_sortinit <> ls_view_sortinit And ls_view_sortinit <> '!' And ls_view_sortinit <> '?' Then
			gn_globals.in_string_functions.of_replace_all(ls_view_sortinit, "'", "%$#")
			ln_datawindow_tools.of_set_expression(idw_data, 'sortinit', ls_view_sortinit)
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Destroy lds_OriginalDatawindow
Destroy lds_ViewDatawindow
end subroutine

public subroutine of_get_sort (ref string as_column[], ref string as_ascendingdescending[]);in_datawindow_tools.of_get_sort(idw_data, is_latest_sortstring, as_column[], as_ascendingdescending[], True)
end subroutine

public subroutine of_reinitialize (boolean ab_setsort);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_reinitialize()
// Arguements:  none
// Function: 	 Resort
// Created by:  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_expression
//n_string_functions ln_string_functions

If in_datawindow_tools.of_IsComputedField(idw_data, 'sortinit') Then
	ls_expression = in_datawindow_tools.of_get_expression(idw_data, 'sortinit')
	
	If ls_expression <> '?' And ls_expression <> '!' Then
		gn_globals.in_string_functions.of_replace_all(ls_expression, "%$#", "'")
		is_latest_sortstring = ls_expression
	End If
End If

If Not is_latest_sortstring > '' Then
	is_latest_sortstring = in_datawindow_tools.of_get_sort(idw_data)
	If is_latest_sortstring = '?' Then is_latest_sortstring = ''
	If Lower(Left(is_latest_sortstring, 10)) <> 'sortcolumn' Then
		This.of_apply_sort_to_gui(is_latest_sortstring)
	Else
		is_latest_sortstring = ''
	End If
	
End If

If is_latest_sortstring > '' And ab_setsort Then This.of_set_sort(is_latest_sortstring)

end subroutine

public subroutine of_reinitialize ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_reinitialize()
// Arguements:  none
// Function: 	 Resort
// Created by:  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_reinitialize(True)
end subroutine

public subroutine of_sort ();This.of_reinitialize()
end subroutine

public subroutine of_set_sort (string as_sort);This.of_set_sort('', as_sort)
end subroutine

public subroutine of_destroy_objects ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_destroy_objects()
// Function: 	 Destroy all the objects on the datawindow
// Created by 	Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_modifies[], ls_return
//n_string_functions ln_string_functions

If is_destroy_string = '' Then Return

If Not IsValid(idw_data) Then Return

//If Not IsValid(idw_data.Object) Then Return

If Right(is_destroy_string, 1) = '~t' Then is_destroy_string = Left(is_destroy_string, Len(is_destroy_string) - 1)

gn_globals.in_string_functions.of_parse_string(is_destroy_string, '~t', ls_modifies[])

String	ls_syntax
ls_syntax = idw_data.Dynamic Describe("Datawindow.Syntax")

For ll_index = 1 To UpperBound(ls_modifies[])
	ls_return = idw_data.Dynamic Modify(ls_modifies[ll_index])
Next


is_destroy_string = ''

end subroutine

public subroutine of_lbuttondown (unsignedlong flags, long xpos, long ypos);If Not idw_data.TypeOf() = Datawindow! Then Return

is_ObjectLeftButtonDownOn = idw_data.Dynamic getobjectatpointer()
is_ObjectLeftButtonDownOn = left(is_ObjectLeftButtonDownOn, Pos(is_ObjectLeftButtonDownOn, '~t') - 1)

end subroutine

public subroutine of_get_multisort_data (ref string as_column_name[], ref string as_column_header_text[], ref string as_column_header[], ref datawindow adw_sort);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_multisort_data()
//	Arguments:  
//	Overview:   This will return data for the multisort service
//	Created by:	Blake Doerr
//	History: 	6/22/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_index
String	ls_objects[], ls_columnname, ls_column_header_text
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out all the objects
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(idw_data.Dynamic Describe("Datawindow.Objects"), '~t', ls_objects[])

//-----------------------------------------------------
// Determine the text of all headers
//-----------------------------------------------------
For ll_index = 1 to UpperBound(ls_objects[])
	ls_objects[ll_index] = Trim(ls_objects[ll_index])
	If Lower(Right(ls_objects[ll_index], Len(is_suffix))) <> Lower(is_suffix) Then Continue
	
	ls_columnname = Left(ls_objects[ll_index], Len(ls_objects[ll_index]) - Len(is_suffix))
	
	If Not in_datawindow_tools.of_IsColumn(idw_data, ls_columnname) Then
		If Not in_datawindow_tools.of_IsComputedField(idw_data, ls_columnname) Then
			Continue
		End If
	End If
	
	ls_column_header_text = idw_data.Dynamic describe(ls_objects[ll_index] + ".Text")
	
	if ls_column_header_text = '!' then
		ls_column_header_text = idw_data.Dynamic describe(ls_objects[ll_index] + ".expression")
		if ls_column_header_text <> '!' then
			ls_column_header_text = idw_data.Dynamic Describe( 'evaluate( "' + ls_column_header_text + '",1)')
		end if
	end if
	
	If ls_column_header_text = '!' Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add LookupDisplay() if necessary
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case in_datawindow_tools.of_get_editstyle(idw_data, ls_columnname)
		Case 'dddw', 'ddlb'
			if pos(is_ignore_dropdowns, idw_data.Dynamic Describe(ls_columnname+'.DDDW.Name')) <= 0 then &
				ls_columnname = 'LookupDisplay(' + ls_columnname + ')' //KCS 29044 Added if condition 
	End Choose
	
	as_column_name			[UpperBound(as_column_name[]) + 1] 	= ls_columnname
	as_column_header		[UpperBound(as_column_name[])] 		= ls_objects[ll_index]
	as_column_header_text[UpperBound(as_column_name[])] 		= ls_column_header_text
Next

adw_sort = idw_data
end subroutine

public subroutine of_init (powerobject dw_data, string s_suffix, string s_multi_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  idw_data - The datawindow to sort
//					s_suffix - The suffix to look for on the column headers
//					s_multi_column - 'M' or 'S' or 'N'
//	Overview:   This will initialize the service
//	Created by:	Blake Doerr
//	History: 	10/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_sortinit_expression

//-----------------------------------------------------
// Manage the pointer
//-----------------------------------------------------
SetPointer(HourGlass!)

//-----------------------------------------------------
// Initialize variables we need later
//-----------------------------------------------------
idw_data = dw_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Let the status bar know that we are initializing
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(gn_globals) then
	if isvalid(gn_globals.in_subscription_service) then
		gn_globals.in_subscription_service.of_message('bump statusbar', 'message=Initializing Sort Service||percent=5')
	end if
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy any objects that might be there
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_destroy_objects()

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure there's a suffix on the suffix
//-----------------------------------------------------------------------------------------------------------------------------------
If Not Pos(s_suffix, '_') > 0 Then
	is_suffix = "_"+s_suffix
Else
	is_suffix = s_suffix 
End If

//-----------------------------------------------------
// Subscribe to the messages that affect this object
//-----------------------------------------------------
If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_subscribe(This, 'ColumnResize', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Before View Saved', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Group By Happened', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'After View Restored', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'visible columns changed', idw_data)	//Published by the column selection service
		gn_globals.in_subscription_service.of_subscribe(This, 'before generate', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'after generate', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Recreate View - Sort', 					idw_data)
	End If
	
	is_latest_sortstring = in_datawindow_tools.of_get_sort(idw_data)
	If is_latest_sortstring = '?' Then is_latest_sortstring = ''
	If Lower(Left(is_latest_sortstring, 10)) <> 'sortcolumn' Then
		This.of_apply_sort_to_gui(is_latest_sortstring)
	End If
End If


ls_sortinit_expression = Trim(in_datawindow_tools.of_get_expression(idw_data, 'sortinit'))
If Not IsNull(ls_sortinit_expression) And Len(Trim(ls_sortinit_expression)) > 0 Then
	If Left(ls_sortinit_expression, 1) = '"' Or Left(ls_sortinit_expression, 1) = "'" Then
		ls_sortinit_expression = Left(ls_sortinit_expression, Len(ls_sortinit_expression) - 1)
	End If

	If Right(ls_sortinit_expression, 1) = '"' Or Right(ls_sortinit_expression, 1) = "'" Then
		ls_sortinit_expression = Right(ls_sortinit_expression, Len(ls_sortinit_expression) - 1)
	End If

	
	This.of_set_sort(ls_sortinit_expression)
End If


end subroutine

public subroutine of_set_sort (string as_original_sort, string as_sort);	//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_sort()
//	Arguments:  as_sort - The sort expression
//	Overview:   This will try to let n_datawindow_tools sort it if it can (performance reasons)
//	Created by:	Blake Doerr
//	History: 	10/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Local Variables
//-----------------------------------------------------
Long		ll_index
String	ls_group_by_sort = '', ls_groups[], ls_sort_string
Boolean	lb_was_the_one_clicked = False
String	ls_sort_expression
//n_string_functions ln_string_functions
String	ls_total_sort

//-----------------------------------------------------
// Make sure the datawindow is valid
//-----------------------------------------------------
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------
// Get the groups for this datawindow
//-----------------------------------------------------
in_datawindow_tools.of_get_groups(idw_data, ls_groups[])

//-----------------------------------------------------
// Loop through the groups and get the groups
//-----------------------------------------------------
For ll_index = 1 To UpperBound(ls_groups[])
	If IsNull(ls_groups[ll_index]) Or Trim(ls_groups[ll_index]) = '' Then Continue

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add LookupDisplay() if necessary
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case in_datawindow_tools.of_get_editstyle(idw_data, ls_groups[ll_index])
		Case 'dddw', 'ddlb'			
			if pos(is_ignore_dropdowns,idw_data.Dynamic describe(ls_groups[ll_index]+'.DDDW.Name')) <= 0 then 
				ls_sort_string = 'LookupDisplay(' + ls_groups[ll_index] + ')' 
			else
				ls_sort_string = ls_groups[ll_index]
			end if
		Case Else
			ls_sort_string = ls_groups[ll_index]
	End Choose
	
	If Trim(Lower(is_column_clicked)) = Trim(Lower(ls_groups[ll_index])) Then
		as_sort = ''
		
		If Match(Lower(idw_data.Dynamic Describe(ls_groups[ll_index] + is_suffix + is_bitmap_suffix + '.Text')), Lower(is_descending_character)) Then
			ls_group_by_sort = ls_group_by_sort + ls_sort_string + ' A,'
		Else
			ls_group_by_sort = ls_group_by_sort + ls_sort_string + ' D,'
		End If
	Else
		If Match(Lower(idw_data.Dynamic Describe(ls_groups[ll_index] + is_suffix + is_bitmap_suffix + '.Text')), Lower(is_descending_character)) Then
			ls_group_by_sort = ls_group_by_sort + ls_sort_string + ' D,'
		Else
			ls_group_by_sort = ls_group_by_sort + ls_sort_string + ' A,'
		End If
	End If
Next

//-----------------------------------------------------
// add the original sort to the sort
//-----------------------------------------------------
If Len(Trim(as_original_sort)) > 0 Then
	If Len(Trim(as_sort)) > 0 Then
		ls_total_sort = as_original_sort + ',' + as_sort
	Else
		ls_total_sort = as_original_sort
	End If
Else
	ls_total_sort = as_sort
End If

If Right(ls_total_sort, 1) = ',' Then ls_total_sort = Left(ls_total_sort, Len(ls_total_sort) - 1)

If Len(Trim(ls_total_sort)) = 0 Then
	If Right(ls_group_by_sort, 1) = ',' Then ls_group_by_sort = Left(ls_group_by_sort, Len(ls_group_by_sort) - 1)
End If

//-----------------------------------------------------
// Store the sort for prosperity
//-----------------------------------------------------
is_latest_sortstring = ls_total_sort

//-----------------------------------------------------
// Set the Sort
//-----------------------------------------------------
If Not in_datawindow_tools.of_sort(idw_data, ls_group_by_sort + ls_total_sort) Then
	idw_data.Dynamic setsort(ls_group_by_sort + ls_total_sort)
	idw_data.Dynamic sort()
End If

//-----------------------------------------------------
// Make sure to recalculate groups if there is a presort
//-----------------------------------------------------
If ls_group_by_sort <> '' Then idw_data.Dynamic GroupCalc()


//-----------------------------------------------------
// Save the state of the sort
//-----------------------------------------------------
idw_data.Dynamic Modify("Destroy sortinit")

If is_latest_sortstring <> '' Then
	ls_sort_expression = is_latest_sortstring
	gn_globals.in_string_functions.of_replace_all(ls_sort_expression, "'", "%$#")
	in_datawindow_tools.of_set_expression(idw_data, 'sortinit', ls_sort_expression)
End If

//-----------------------------------------------------
// Apply the sort to the gui
//-----------------------------------------------------
This.of_apply_sort_to_gui(ls_group_by_sort + ls_total_sort)

//-----------------------------------------------------
// Publish a message so other services can respond
//-----------------------------------------------------
This.of_publish_message()

//-----------------------------------------------------
// Clear the column clicked
//-----------------------------------------------------
is_column_clicked = ''
end subroutine

public subroutine of_apply_sort_to_gui (string as_sort_string);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_sort_to_gui()
//	Arguments:  as_sort_string
//	Overview:   This will make the gui respect the sort
//	Created by:	Blake Doerr
//	History: 	10/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_rightjustified
String 	ls_columnname[]
String	ls_sort_direction[]
String	ls_display_string
String	ls_modify
Long		ll_alignment
Long		ll_index
Long		ll_width
Long		ll_x
Long		ll_y

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the gui sort string
//-----------------------------------------------------------------------------------------------------------------------------------
is_latest_sortstring_gui = as_sort_string

//-----------------------------------------------------------------------------------------------------------------------------------
// Do not apply to GUI if it's a datastore
//-----------------------------------------------------------------------------------------------------------------------------------
If idw_data.TypeOf() <> Datawindow! Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects on the window
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_destroy_objects()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the sort into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
in_datawindow_tools.of_get_sort(idw_data, as_sort_string, ls_columnname[], ls_sort_direction[], True)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the elements of the sort and 
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columnname[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the column doesn't exist, continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not in_datawindow_tools.of_IsColumn(idw_data, ls_columnname[ll_index]) Then
		If Not in_datawindow_tools.of_IsComputedField(idw_data, ls_columnname[ll_index]) Then
			Continue
		End If
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the character to show for the arrow
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Upper(Trim(ls_sort_direction[ll_index])) = 'D' Then
		ls_display_string = is_descending_character
	Else
		ls_display_string = is_ascending_character
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If there are multiple columns, add a number to the sort
	//-----------------------------------------------------------------------------------------------------------------------------------
	If UpperBound(ls_columnname[]) > 1 Then
		ls_display_string = ls_display_string + Char(139 + ll_index)
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the width and continue if it isn't greater than zero
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_width	= Long(idw_data.Dynamic Describe(ls_columnname[ll_index] + is_suffix + '.Width'))
	
	// JJF Added 11/1/2002 RAID #29282
	If IsNull(ll_width) Or ll_width <= 0 Then
		ll_width = long(idw_data.Dynamic Describe(ls_columnname[ll_index] + '_1'+ is_suffix + '.Width'))
		If ll_width > 0 Then ls_columnname[ll_index] = ls_columnname[ll_index] + '_1'
	end if 
	// JJF End Added 11/1/2002 RAID #29282
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If there are multiple columns, add a number to the sort
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsNull(ll_width) Or ll_width <= 0 Then Continue
	If 1 <> Long(idw_data.Dynamic Describe(ls_columnname[ll_index] + is_suffix + '.Visible')) Then Continue
	ll_x					= Long(idw_data.Dynamic Describe(ls_columnname[ll_index] + is_suffix + '.X'))
	ll_y					= Long(idw_data.Dynamic Describe(ls_columnname[ll_index] + is_suffix + '.Y')) + 5
	lb_rightjustified	= Long(idw_data.Dynamic Describe(ls_columnname[ll_index] + is_suffix + '.alignment')) = 1

	If Not lb_rightjustified Then
		ll_alignment = 1
		ll_x = ll_x + ll_width - 117
	Else
		ll_alignment = 2
		ll_x = ll_x + 5
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the syntax for the text object
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_modify = "create text(band=header color='0' alignment='" + String(ll_alignment) + "' border='0' height.autosize=No pointer='Arrow!' moveable=0 resizeable=0  x='" + string(ll_x) + "' y='" + string(ll_y) + "' height='61' width='115' text='" + ls_display_string  + "' " + &
									" name=" + ls_columnname[ll_index] + is_suffix + is_bitmap_suffix + " font.face='Wingdings' font.height='-9'" + &
									" font.weight='400' font.family='1' font.pitch='0' font.charset='2' font.italic='0' font.strikethrough='0' font.underline='0' background.mode='1' background.color='553648127' visible='1')"
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the text object and add it to the destroy string
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_data.Dynamic Modify('Destroy ' + ls_columnname[ll_index] + is_suffix + is_bitmap_suffix)
	
	If Pos(is_destroy_string, 'Destroy ' + ls_columnname[ll_index] + is_suffix + is_bitmap_suffix + '~t') > 0 Then Continue
	idw_data.Dynamic Modify(ls_modify)
	is_destroy_string = is_destroy_string + 'Destroy ' + ls_columnname[ll_index] + is_suffix + is_bitmap_suffix + '~t'
Next
end subroutine

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_batchmode = ab_batchmode
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
// If it's a column or computed field, add the sort options for the individual column
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_IsColumn Or ab_IsComputedField Then
	an_menu_dynamic.of_add_item('Sort &Ascending', 'sort ascending', 					as_objectname, This)
	an_menu_dynamic.of_add_item('Sort &Descending', 'sort descending', 				as_objectname, This)

	If ib_batchmode Then
		an_menu_dynamic.of_add_item('-', '-', as_objectname, This)
		an_menu_dynamic.of_add_item('Append Sort &Ascending', 'append sort ascending', 					as_objectname, This)
		an_menu_dynamic.of_add_item('Append Sort &Descending', 'append sort descending', 				as_objectname, This)
	End If
End If

If Not ib_batchmode Then an_menu_dynamic.of_add_item('Sort on &Multiple/Custom Columns...', 'sort multiple', 	'', This)
end subroutine

public subroutine of_clicked ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clicked()
//	Overview:   This will sort the datawindow by the header clicked upon
//	Created by:	Blake Doerr
//	History: 	10/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Variable Declaration
//-----------------------------------------------------
String	ls_object
Boolean	lb_extended_sort		= False
String	ls_current_direction = 'A'

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't Valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the Object Name
//-----------------------------------------------------------------------------------------------------------------------------------
lb_extended_sort		= KeyDown(KeyShift!) Or KeyDown(KeyControl!)
ls_object = idw_data.Dynamic getobjectatpointer()
ls_object = left(ls_object, Pos(ls_object,'~t') - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we aren't on the same object that we lbuttondowned on then return
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(is_ObjectLeftButtonDownOn)) <> Lower(Trim(ls_object)) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// If we accidently clicked on the arrow, translate it to the column
//-----------------------------------------------------------------------------------------------------------------------------------
if Right(ls_object,14) = '_direction_srt' then
	ls_object = left(ls_object, Len(ls_object) - 14)
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// If there already exists an arrow ascending for this column, we will change it to descending
//-----------------------------------------------------------------------------------------------------------------------------------
If Match(Lower(idw_data.Dynamic Describe(ls_object + is_bitmap_suffix + '.Text')), Lower(is_ascending_character)) Then ls_current_direction = 'D'

//-----------------------------------------------------------------------------------------------------------------------------------
// Now call this function to sort by the object
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_sort_object(ls_object, lb_extended_sort, ls_current_direction = "A")

end subroutine

public subroutine of_sort_object (string as_objectname, boolean ab_extendedsort, boolean ab_ascending);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clicked()
//	Overview:   This will sort the datawindow by the header clicked upon
//	Created by:	Blake Doerr
//	History: 	10/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Variable Declaration
//-----------------------------------------------------
String	ls_db_column
String	ls_originalsort
String	ls_current_direction = 'A'

If Not ab_ascending Then ls_current_direction = 'D'

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't Valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return


//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the suffix does not match
//-----------------------------------------------------------------------------------------------------------------------------------
If Not Lower(Right(as_objectname, Len(is_suffix))) = Lower(is_suffix) then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the column/computed field name
//-----------------------------------------------------------------------------------------------------------------------------------
as_objectname 				= Left(as_objectname, Len(as_objectname) - Len(is_suffix))
is_column_clicked			= as_objectname

//-----------------------------------------------------------------------------------------------------------------------------------
// If the dbcolumnname is valid, use it because it's more precise
//-----------------------------------------------------------------------------------------------------------------------------------
ls_db_column = idw_data.Dynamic Describe(as_objectname + '.dbName')
ls_db_column = Mid(ls_db_column, Pos(as_objectname, '.') + 1)
If IsNumber(idw_data.Dynamic Describe(ls_db_column+'.id')) then as_objectname = ls_db_column

//-----------------------------------------------------------------------------------------------------------------------------------
// Add LookupDisplay() if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case in_datawindow_tools.of_get_editstyle(idw_data, as_objectname)
	Case 'dddw', 'ddlb'
		if pos(is_ignore_dropdowns, idw_data.Dynamic describe(as_objectname+'.DDDW.Name')) <= 0 Then
			as_objectname = 'LookupDisplay(' + as_objectname + ')'
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are extended sorting, make sure cut off where this column was in the sort previously and then add the previous sort
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_extendedsort Then
	If Pos(is_latest_sortstring, as_objectname) > 0 Then
		is_latest_sortstring = Trim(Left(is_latest_sortstring, Max(0, Pos(is_latest_sortstring, as_objectname) - 2)))
	End If
	
	If Len(is_latest_sortstring) > 0 Then
		ls_originalsort = is_latest_sortstring
	End If
End If

//-----------------------------------------------------
// If sorting by key then add key to the sort
//-----------------------------------------------------
if ib_sortbykey then
	This.of_set_sort(ls_originalsort, as_objectname + ' ' + ls_current_direction + ', #1 ' + ls_current_direction)
Else
	This.of_set_sort(ls_originalsort, as_objectname + ' ' + ls_current_direction)
end if
end subroutine

on n_sort_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sort_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;This.of_destroy_objects()
Destroy in_datawindow_tools
end event

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

in_datawindow_tools = Create n_datawindow_tools
end event

