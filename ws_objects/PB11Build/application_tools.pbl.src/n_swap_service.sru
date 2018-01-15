$PBExportHeader$n_swap_service.sru
forward
global type n_swap_service from nonvisualobject
end type
end forward

global type n_swap_service from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
event ue_refreshtheme ( ref powerobject apo_object )
end type
global n_swap_service n_swap_service

type variables
Protected:
	powerobject ipo_origin
	string is_origin_column
	
	powerobject ipo_destination
	string is_destination_column	

	userobject iu_parent
	dragobject ido_swap[]
	
	boolean ib_manage_gui
	boolean ib_createswaprectangle
	
	n_datawindow_tools in_data_tools
	boolean ib_swapping
	powerobject ipo_dragstart

	long il_last_row

	
end variables

forward prototypes
public subroutine of_set_destination_column (string as_column)
public subroutine of_set_origin_column (string as_column)
public subroutine of_set_origin_object (powerobject apo_origin)
public subroutine of_set_destination_object (powerobject apo_destination)
public function string of_swap (string as_type, long al_startrow)
public function string of_swap (string as_type, string as_rows)
public subroutine of_set_manage_gui (boolean ab_manage_gui)
public subroutine of_set_parent (ref userobject au_parent)
public subroutine of_manage_controls (string as_changed_object, string as_origin_row, string as_destination_row)
public subroutine of_leftbuttondown (powerobject apo_object, long xpos, long ypos)
public subroutine of_leftbuttonup (powerobject apo_object, long xpos, long ypos)
public function long of_filter (ref powerobject apo_object)
public function string of_swap (string as_type)
public function string of_swap (string as_type, string as_rows, long al_startrow)
public function string of_get_next_value (powerobject apo_object, string as_rows)
public subroutine of_mousemove (ref powerobject apo_object, long row, ref dwobject dwo)
public function string of_build_filter_string ()
public subroutine of_init (userobject au_parent, powerobject apo_origin, string as_origin_column, powerobject apo_destination, string as_destination_column, boolean ab_manage_gui, boolean ab_createswaprectangle)
public subroutine of_init (userobject au_parent, powerobject apo_origin, string as_origin_column, powerobject apo_destination, string as_destination_column, boolean ab_manage_gui)
end prototypes

event ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_notify
//	Overrides:  No
//	Arguments:	as_message, as_arg
//	Overview:   The event used to handle notifications.
//	Created by: Denton Newham
//	History:    12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_origin_row, ls_destination_row, ls_rows, ls_value
long ll_startrow
datawindow ldw_origin, ldw_destination

Choose Case Lower(Trim(as_message))
				
	Case 'add item', 'remove item', 'move item up', 'move item down'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw to false for the objects if they are datawindows.
		//-----------------------------------------------------------------------------------------------------------------------------------	
		If ipo_origin.TypeOf() = datawindow! Then 
			ldw_origin = ipo_origin
			ldw_origin.SetReDraw(False)
		End If
		If ipo_destination.TypeOf() = datawindow! Then 
			ldw_destination = ipo_destination
			ldw_destination.SetReDraw(False)
		End If
			
		
		Choose Case Lower(Trim(as_message))
				
			Case	'add item'
				
				If ib_manage_gui Then
					ls_value = String(This.of_get_next_value(ipo_origin, Left(String(as_arg), Pos(String(as_arg), '~t'))))
				End If
				ls_rows = Left(String(as_arg), Pos(String(as_arg), '~t'))
				ll_startrow = Long(Right(String(as_arg), Len(String(as_arg)) -  Pos(String(as_arg), '~t')))
				
				ls_destination_row = This.of_swap(as_message, ls_rows, ll_startrow)
				
				If ib_manage_gui Then
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Filter the origin object.
					//-----------------------------------------------------------------------------------------------------------------------------------
					This.of_filter(ipo_origin)
					If ls_value = '' Then
						ls_origin_row = ''
					Else
						ls_origin_row = String(in_data_tools.of_find_row(ipo_origin, is_origin_column, ls_value, 1, ipo_origin.Dynamic RowCount()))
					End If

					//-----------------------------------------------------------------------------------------------------------------------------------
					// Manage the swap controls.
					//-----------------------------------------------------------------------------------------------------------------------------------
//					This.of_manage_controls('both', ls_origin_row, ls_destination_row)		
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Publish a message to distribute the rows that need to be selected in both the origin and destination datawindows.
					//-----------------------------------------------------------------------------------------------------------------------------------
					If IsValid(gn_globals.in_subscription_service) Then						
						gn_globals.in_subscription_service.of_message('new origin selections', ls_origin_row)
						gn_globals.in_subscription_service.of_message('new destination selections', ls_destination_row)		
					End If		
				End If
				
			Case	'remove item'
				
				If ib_manage_gui Then
					ls_value = String(This.of_get_next_value(ipo_destination, Left(String(as_arg), Pos(String(as_arg), '~t'))))
				End If
				
				ls_rows = Left(String(as_arg), Pos(String(as_arg), '~t'))
				ll_startrow = Long(Right(String(as_arg), Len(String(as_arg)) -  Pos(String(as_arg), '~t')))
				
				ls_origin_row = This.of_swap(as_message, ls_rows, ll_startrow)
				
				If ib_manage_gui Then
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Filter the origin object.
					//-----------------------------------------------------------------------------------------------------------------------------------
					This.of_filter(ipo_origin)
					If ls_value = '' Then
						ls_destination_row = ''
					Else
						ls_destination_row = String(in_data_tools.of_find_row(ipo_destination, is_destination_column, ls_value, 1, ipo_destination.Dynamic RowCount()))
					End If
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Manage the swap controls.
					//-----------------------------------------------------------------------------------------------------------------------------------
//					This.of_manage_controls('both', ls_origin_row, ls_destination_row)
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Publish a message to distribute the rows that need to be selected in both the origin and destination datawindows.
					//-----------------------------------------------------------------------------------------------------------------------------------
					If IsValid(gn_globals.in_subscription_service) Then
						gn_globals.in_subscription_service.of_message('new origin selections', ls_origin_row)
						gn_globals.in_subscription_service.of_message('new destination selections', ls_destination_row)	
					End If		
				End If				
				
		End Choose
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw back to true for the objects.
		//-----------------------------------------------------------------------------------------------------------------------------------		
		If IsValid(ldw_origin) Then ldw_origin.SetReDraw(True)	
		If IsValid(ldw_destination) Then ldw_destination.SetReDraw(True)		
	
	Case	'destination rows changed'
		
//		This.of_manage_controls('destination', '', String(as_arg))
		
	Case	'origin rows changed'
		
//		This.of_manage_controls('origin', String(as_arg), '')		
			
End Choose
end event

event ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This is the response to the theme change
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datawindow ldw_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Change the color of the swap line to match the theme.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(apo_object) And apo_object.TypeOf() = datawindow! Then 
	
	ldw_data = apo_object
	//ldw_data.Modify("r_swap.Brush.Color='" + String(gn_globals.in_theme.of_get_backcolor()) + "'")
	
End If
end event

public subroutine of_set_destination_column (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_destination_column()
//	Arguments:  as_column
//	Overview:   This sets the column to be swapped from the destination datawindow.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_destination_column = as_column
end subroutine

public subroutine of_set_origin_column (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_origin_column()
//	Arguments:  as_column
//	Overview:   This sets the column to be swapped from the origin datawindow.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_origin_column = as_column
end subroutine

public subroutine of_set_origin_object (powerobject apo_origin);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_origin_object
//	Arguments:  apo_origin
//	Overview:   This script sets the origin object for the swap object.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ipo_origin = apo_origin
end subroutine

public subroutine of_set_destination_object (powerobject apo_destination);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_destination_object
//	Arguments:  apo_origin
//	Overview:   This script sets the destination object for the swap object.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ipo_destination = apo_destination
end subroutine

public function string of_swap (string as_type, long al_startrow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_swap()
//	Arguments:  as_type 			- The type of swap
//					al_startrow		- The row to start swapping into for the destination object.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_swap(as_type, '', al_startrow)
end function

public function string of_swap (string as_type, string as_rows);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_swap()
//	Arguments:  as_type 			- The type of swap
//					as_rows			- The rows to be swapped
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_swap(as_type, as_rows, 0)
end function

public subroutine of_set_manage_gui (boolean ab_manage_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_manage_gui
//	Arguments:  ab_manage_gui
//	Overview:   This script sets gui management on/off.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_manage_gui= ab_manage_gui
end subroutine

public subroutine of_set_parent (ref userobject au_parent);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_parent
//	Arguments:  au_parent
//	Overview:   This script sets the parent.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

iu_parent = au_parent
end subroutine

public subroutine of_manage_controls (string as_changed_object, string as_origin_row, string as_destination_row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_manage_controls()
//	Arguments:  as_changed_object, as_origin_row, as_destination_row
//	Overview:   Determine if the swap controls are enabled or disabled.
//	Created by:	Denton Newham
//	History: 	1/3/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index, ll_row, ll_upper
string ls_origin_rows[], ls_destination_rows[]
boolean lb_enabled
//n_string_functions ln_string_functions
commandbutton lcb_swap

If Not ib_manage_gui Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out the row strings into arrays.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_origin_row, ',', ls_origin_rows[])
gn_globals.in_string_functions.of_parse_string(as_destination_row, ',', ls_destination_rows[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Go through all of the swap objects to determine if they are enabled or disabled.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upper = UpperBound(ido_swap)

For ll_index = 1 To UpperBound(ido_swap)
	
	lb_enabled = True
			
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Choose the type of swap and validate (names of form u_swap_add, u_swap_remove, etc.).
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case Mid(ido_swap[ll_index].ClassName(), 8, Len(ido_swap[ll_index].ClassName())) + '/' + Lower(Trim(as_changed_object))
		
		Case	'add/origin', 'add/both'

			If UpperBound(ls_origin_rows) > 0 Then ll_row = Long(ls_origin_rows[1])

			If ll_row = 0 Or IsNull(ll_row) Then
				lb_enabled = False			
			End If	
			
		Case	'remove/destination', 'remove/both'
			
			If UpperBound(ls_destination_rows) > 0 Then ll_row = Long(ls_destination_rows[1])

			If ll_row = 0 Or IsNull(ll_row) Then
				lb_enabled = False			
			End If
	
	End Choose
	
	Choose Case ido_swap[ll_index].TypeOf()

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine the type of the object for promotion purposes.  More can be added here if need be.
		//-----------------------------------------------------------------------------------------------------------------------------------			
		Case	commandbutton!
			lcb_swap = ido_swap[ll_index]
			lcb_swap.Enabled = lb_enabled
		
	End Choose
	
Next





end subroutine

public subroutine of_leftbuttondown (powerobject apo_object, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_leftbuttondown()
// Arguments:   apo_object, xpos, ypos - you can figure these out
// Overview:    This will manage the beginning of a drag.
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
String	ls_objectatpointer
Long ll_row
datawindow ldw_data

ib_swapping = False
ipo_dragstart = apo_object

If apo_object.TypeOf() = datawindow! Then 
	ldw_data = apo_object

	//Check to see what object was clicked on
	ls_objectatpointer = ldw_data.GetObjectAtPointer()
	ll_row = Long(Right(ls_objectatpointer, Len(ls_objectatpointer) - Pos(ls_objectatpointer, '~t')))

	If Not IsNull(ll_row) and ll_row > 0 and ll_row <= ldw_data.RowCount() Then
		ib_swapping = True
	End If
	
End If

end subroutine

public subroutine of_leftbuttonup (powerobject apo_object, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_leftbuttondup()
// Arguments:   apo_object, xpos, ypos - you can figure these out
// Overview:    This will manage the beginning of a drag.
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_objectatpointer
long ll_row
datawindow ldw_data

If ib_swapping Then
	
	If apo_object.TypeOf() = datawindow! Then 
		ldw_data = apo_object
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine what row was clicked on.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_objectatpointer = ldw_data.GetObjectAtPointer()
		ll_row = Long(Right(ls_objectatpointer, Len(ls_objectatpointer) - Pos(ls_objectatpointer, '~t')))
		ls_objectatpointer = Left(ls_objectatpointer, Pos(ls_objectatpointer, '~t') - 1)
		
		If Left(ldw_data.GetBandAtPointer(),4) = 'head' Then ll_row = -1
		If ll_row = 0 and ls_objectatpointer <> 'r_swap' and ls_objectatpointer <> 'r_swap_header' Then ll_row = ldw_data.RowCount()
		If ll_row = 0 and ls_objectatpointer = 'r_swap' Then SetNull(ll_row)	
		If ls_objectatpointer = 'r_swap_header' Then ll_row = -1
		
		If ll_row = 0 Then SetNull(ll_row)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If there are no rows in the datawindow or we're on a row larger than the rowcount then set the startrow to be zero.
		//-----------------------------------------------------------------------------------------------------------------------------------		
		If ldw_data.RowCount() < 1 Or ll_row >= ldw_data.RowCount() Then ll_row = 0		

		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the row isn't valid then remove the swap indicators and return.
		//-----------------------------------------------------------------------------------------------------------------------------------			
		If IsNull(ll_row) Then 
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If we're in the origin then return.
		//-----------------------------------------------------------------------------------------------------------------------------------			
		If apo_object = ipo_dragstart And ipo_dragstart = ipo_origin Then 
			ib_swapping = False
			Return
		End If
		
		If apo_object <> ipo_dragstart And ipo_dragstart = ipo_origin Then 
			//-----------------------------------------------------------------------------------------------------------------------------------
			//	If we started from the origin and are no longer there, then publish a message the a swap was requested.  Pass the startrow.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsValid(gn_globals.in_subscription_service) Then
				gn_globals.in_subscription_service.of_message('swap requested - add item', ll_row)
			End If		
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return			
		End If
		
		If apo_object <> ipo_dragstart And ipo_dragstart = ipo_destination Then 
			//-----------------------------------------------------------------------------------------------------------------------------------
			//	If we started from the destination and are no longer there, then publish a message the a swap was requested.  Pass the startrow.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsValid(gn_globals.in_subscription_service) Then
				gn_globals.in_subscription_service.of_message('swap requested - remove item', ll_row)
			End If	
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return			
		End If
		
		If apo_object = ipo_dragstart And ipo_dragstart = ipo_destination Then
			//-----------------------------------------------------------------------------------------------------------------------------------
			//	If we started from the destination and are still there, then remove the swap indicators and return.
			//-----------------------------------------------------------------------------------------------------------------------------------			
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return
		End If	
		
	Else
		If IsValid(ipo_destination) And ipo_destination.TypeOf() = datawindow! Then 
			ldw_data = ipo_destination
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
		End If	
		
	End If
	
End If
end subroutine

public function long of_filter (ref powerobject apo_object);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_filter()
//	Arguments:  apo_object	- The object to filter on.
//	Overview:   Perform a filter on the given object.
//	Created by:	Denton Newham
//	History: 	1/3/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_filter
long ll_filter, ll_row


//-----------------------------------------------------------------------------------------------------------------------------------
// Build the filter string.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_filter = This.of_build_filter_string()

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the filter.
//-----------------------------------------------------------------------------------------------------------------------------------
apo_object.Dynamic SetFilter(ls_filter)
apo_object.Dynamic Filter()

//*** I'm not sure if there was special code to set the row back or not in n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Sort the object.
//-----------------------------------------------------------------------------------------------------------------------------------	
apo_object.Dynamic Sort()


Return ll_filter
end function

public function string of_swap (string as_type);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_swap()
//	Arguments:  as_type 			- The type of swap
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_swap(as_type, '', 0)
end function

public function string of_swap (string as_type, string as_rows, long al_startrow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_swap()
//	Arguments:  as_type 			- The type of swap
//					as_rows			- The rows to be swapped (comma delimited)
//					al_startrow		- The row to start the inserting after in the destination dw.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_upper, ll_index, ll_row, ll_last_row, ll_min, ll_max
string ls_values, ls_new_value[], ls_rows[], ls_return_rows, ls_value
//n_string_functions ln_string_functions

If Not IsValid(ipo_destination) Then Return ''

Choose Case Lower(Trim(as_type))
		
	Case	'add item'	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the rows into an array.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsValid(ipo_origin) Then Return ''
		If Len(Trim(as_rows)) <= 0 Or as_rows = '' Or IsNull(as_rows) Then as_rows = String(ipo_origin.Dynamic Getrow())
		gn_globals.in_string_functions.of_parse_string(as_rows, ',', ls_rows[])
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the row array and swap.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_upper = UpperBound(ls_rows)
		If ll_upper < 1 Then Return ''
		For ll_index = 1 To ll_upper
			If Long(ls_rows[ll_index]) < 1 Then Continue

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Get the value from the origin object.
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_value = in_data_tools.of_getitem(ipo_origin, Long(ls_rows[ll_index]), is_origin_column)

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Insert a row to the destination object.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If al_startrow = 0 Then
				ll_row = ipo_destination.Dynamic InsertRow(0)
			ElseIf al_startrow = -1 Then
				ll_row = ipo_destination.Dynamic InsertRow(ll_index)
			Else
				ll_row = ipo_destination.Dynamic InsertRow(al_startrow + ll_index)
			End If

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Set the item to the destination object.
			//----------------------------------------------------------------------------------------------------------------------------------
			in_data_tools.of_setitem(ipo_destination, ll_row, is_destination_column, ls_value)

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add ll_insert_row to the list of rows to be returned.
			//----------------------------------------------------------------------------------------------------------------------------------
			ls_return_rows = ls_return_rows + String(ll_row) + ','

		Next
		
		Return Left(ls_return_rows, Len(ls_return_rows) - 1)
		
	Case	'remove item'	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Unfilter the origin object.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ipo_origin.Dynamic SetFilter('')
		ipo_origin.Dynamic Filter()
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the rows into an array.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(Trim(as_rows)) <= 0 Or as_rows = '' Or IsNull(as_rows) Then as_rows = String(ipo_destination.Dynamic GetRow())
		gn_globals.in_string_functions.of_parse_string(as_rows, ',', ls_rows[])
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the row array and swap.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_upper = UpperBound(ls_rows)
		If ll_upper < 1 Then Return ''
		For ll_index = ll_upper To 1 Step -1
			If Long(ls_rows[ll_index]) < 1 Then Continue
				
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the value of the row we're on so we can find the rows to highlight in the origin object later.
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_values = ls_values + in_data_tools.of_getitem(ipo_destination, Long(ls_rows[ll_index]), is_destination_column) + ','

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Remove the item from the destination object.
			//-----------------------------------------------------------------------------------------------------------------------------------
			ipo_destination.Dynamic DeleteRow(Long(ls_rows[ll_index]))
			
		Next
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Unfilter the origin object.
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_filter(ipo_origin)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Find the rows to be highlighted for the origin object.
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_parse_string(Left(ls_values, Len(ls_values) - 1), ',', ls_new_value[])
		ll_upper = UpperBound(ls_new_value)
		If ll_upper < 1 Then ls_return_rows = ''
		For ll_index = 1 To ll_upper
//***			ll_row = in_data_tools.of_find_row(ipo_origin, is_origin_column, ls_new_value[ll_index], 1, in_data_tools.of_get_rowcount(ipo_origin))
			ls_return_rows = ls_return_rows + String(ll_row) + ','
		Next
		
		Return Left(ls_return_rows, Len(ls_return_rows) - 1)
				
End Choose

Return ''
end function

public function string of_get_next_value (powerobject apo_object, string as_rows);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_next_value()
//	Arguments:  apo_object, as_rows
//	Overview:   Determines the next row to be selected after the currently selected values are swapped.
//	Created by:	Denton Newham
//	History: 	1/17/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index, ll_last, ll_upper
string ls_rows[], ls_column
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the rows into an array.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(apo_object) Then Return ''
If Len(Trim(as_rows)) <= 0 Or as_rows = '' Or IsNull(as_rows) Then as_rows = String(apo_object.Dynamic GetRow())
gn_globals.in_string_functions.of_parse_string(as_rows, ',', ls_rows[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine which object we are looking at.
//-----------------------------------------------------------------------------------------------------------------------------------
If apo_object = ipo_origin Then ls_column = is_origin_column
If apo_object = ipo_destination Then ls_column = is_destination_column

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the row array and determine the next value.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upper = UpperBound(ls_rows)
If ll_upper < 1 Then Return ''
For ll_index = 1 To ll_upper

	If ll_index <> 1 Then
		If Long(ls_rows[ll_index]) <> ll_last + 1 Then
			//-----------------------------------------------------------------------------------------------------------------------------------
			// This row is not in sequence with the last.  The first one after ll_last should be the one.
			//-----------------------------------------------------------------------------------------------------------------------------------
			Return in_data_tools.of_getitem(apo_object, ll_last + 1, ls_column)
		End If
	End If	
	ll_last = Long(ls_rows[ll_index])
	
Next

If ll_last < apo_object.Dynamic RowCount() Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the last selected row is not the last row in the datawindow, then the next row will be the one to select. 
	//-----------------------------------------------------------------------------------------------------------------------------------
	Return in_data_tools.of_getitem(apo_object, ll_last + 1, ls_column)
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we get to here, all the rows are selected in sequence, and the last row in the datawindow is selected.  The only
	//	possibility left is to find the first row selected, and plan to select the row above it, if such a row exists.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Long(ls_rows[1]) > 1 Then
		Return in_data_tools.of_getitem(apo_object, Long(ls_rows[1]) - 1, ls_column) 
	End If
End If


Return ''
end function

public subroutine of_mousemove (ref powerobject apo_object, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_mousemove
// Overview:   If the mouse has been moved over the object while the left button was clicked then
//					move the highlight
//
// Created by: Blake Doerr
// History:    2/20/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_width, ls_rowheight, ls_rectangle, ls_error
datawindow ldw_data

If ib_swapping And keydown(keyleftbutton!) Then
	
	If apo_object <> ipo_origin Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If we are in swap mode and not in the origin object then clear the indicator for the last row.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(apo_object) And apo_object.TypeOf() = datawindow! Then 
			
			ldw_data = apo_object
			If row = 0 and dwo.Name <> 'r_swap' and dwo.Name <> 'r_swap_header' And Left(ldw_data.GetBandAtPointer(),4) <> 'head' Then row = ldw_data.RowCount()
			If row = 0 and dwo.Name = 'r_swap' Then SetNull(row)		
			
			If il_last_row > 0 and il_last_row <> row And Not IsNull(il_last_row) Then
				ldw_data.SetItem(il_last_row , 'swapindicator', '')
				il_last_row = 0
			ElseIf il_last_row = 0 Then
				ls_error = ldw_data.Modify('r_swap_header.Visible="0"')
			End If
	
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Turn the indicator on for the new row.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If row > 0 And row <> il_last_row And Not IsNull(row) Then
				
				ldw_data.SetItem(row, 'swapindicator', 'Y')
				il_last_row = row
				
			ElseIf (Left(ldw_data.GetBandAtPointer(),4) = 'head' Or dwo.Name = 'r_swap_header') Then
				//-----------------------------------------------------------------------------------------------------------------------------------
				// If we're in the header band, make the header line visible.
				//-----------------------------------------------------------------------------------------------------------------------------------				
				ls_error = ldw_data.Modify('r_swap_header.Visible="1"')	
				il_last_row = 0
				
			End If
		Else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// This will clear the highlights if you call this function from the userobject surrounding the destination datawindow.
			//-----------------------------------------------------------------------------------------------------------------------------------		
			If IsValid(ipo_destination) And ipo_destination.TypeOf() = datawindow! Then
				ldw_data = ipo_destination
				ls_error = ldw_data.Modify('r_swap_header.Visible="0"')
				ldw_data.SetItem(il_last_row , 'swapindicator', '')
			End If		
		End If
	
	Else
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// This will clear the highlights if you call this function from the userobject surrounding the destination datawindow.
		//-----------------------------------------------------------------------------------------------------------------------------------		
		If IsValid(ipo_destination) And ipo_destination.TypeOf() = datawindow! Then
			ldw_data = ipo_destination
			ls_error = ldw_data.Modify('r_swap_header.Visible="0"')
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
		End If
		
	End If
	
Else
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// This will clear the highlights if somehow the mouse button gets up without removing the highlights.
	//-----------------------------------------------------------------------------------------------------------------------------------		
	If IsValid(ipo_destination) And ipo_destination.TypeOf() = datawindow! Then
		ldw_data = ipo_destination
		ls_error = ldw_data.Modify('r_swap_header.Visible="0"')
		ldw_data.SetItem(il_last_row , 'swapindicator', '')
	End If	
	
End If
end subroutine

public function string of_build_filter_string ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_filter_string()
//	Arguments:  None
//	Overview:   This function will build the filter string for the origin datawindow.
//	Created by:	Denton Newham
//	History: 	1/13/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_filter_string, ls_prefix = '', ls_suffix = ''
long ll_loop, ll_count
string ls_type,ls_value
Datawindow ldw_data
Datastore lds_datastore

//----------------------------------------------------------------------------------------------------------------------------------
// Get the column type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ipo_origin.TypeOf()
	Case Datawindow!
		ldw_data = ipo_origin
		ls_type = ldw_data.Describe(is_origin_column + ".Coltype")
	Case Datastore!
		lds_datastore = ipo_origin
		ls_type = lds_datastore.Describe(is_origin_column + ".Coltype")
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
	Case 'date'
	Case 'char'
		ls_prefix = "'"
		ls_suffix = "'"
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Filter any row in the origin object that has a value equal to a value in the destination object. 
//-----------------------------------------------------------------------------------------------------------------------------------
ls_filter_string = ''
ll_count = ipo_destination.Dynamic RowCount()

For ll_loop = 1 To ll_count 		
	ls_filter_string = ls_filter_string + is_origin_column + " <> " + ls_prefix + in_data_tools.of_getitem(ipo_destination, ll_loop, is_destination_column) + ls_suffix + " And "
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove the last 'And'.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_filter_string = Left(ls_filter_string, Len(ls_filter_string) - 5)

Return ls_filter_string
end function

public subroutine of_init (userobject au_parent, powerobject apo_origin, string as_origin_column, powerobject apo_destination, string as_destination_column, boolean ab_manage_gui, boolean ab_createswaprectangle);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  au_parent				- The parent for the service.
//					apo_origin 				- The origin object
//					as_origin_column		- The origin column
//					apo_destination		- The destination object
//					as_destination_column- The destination column
//					ab_manage_gui			- Whether or not the service should manage the gui.
//	Overview:   This function initializes the swap object.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index
string ls_width, ls_rowheight, ls_rectangle, ls_error
datawindow ldw_data

This.of_set_parent(au_parent)
This.of_set_origin_object(apo_origin)
This.of_set_origin_column(as_origin_column)
This.of_set_destination_object(apo_destination)
This.of_set_destination_column(as_destination_column)
This.of_set_manage_gui(ab_manage_gui)

ib_createswaprectangle = ab_createswaprectangle

//-----------------------------------------------------------------------------------------------------------------------------------
// If GUI management is on, get all the dragobjects on the parent that have a classname beginning 'u_swap'.
//-----------------------------------------------------------------------------------------------------------------------------------
//If ib_manage_gui And IsValid(iu_parent) Then
//	
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	// Loop through the parent's control array and get all of the swap dragobjects into an array.
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	For ll_index = 1 To UpperBound(iu_parent.Control)
//	
//		If Lower(Left(iu_parent.Control[ll_index].ClassName(), 6)) = 'u_swap' Then	
//			ido_swap[UpperBound(ido_swap)+1] = iu_parent.Control[ll_index]
//		End If
//	
//	Next
//	
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the swap line indicators for drag/drop.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(ipo_destination) And ipo_destination.TypeOf() = datawindow! Then

	ldw_data = ipo_destination
	ls_width = String(ldw_data.Width)
	ls_rowheight = String(Long(ldw_data.Describe("DataWindow.Detail.Height")) - 3 )

	//-----------------------------------------------------------------------------------------------------------------------------------					
	//	If the column swapindicator exists, create the detail line and the header line.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsNumber(ldw_data.Describe("swapindicator.ID")) And ib_createswaprectangle Then
		
		ls_rectangle = "Create line(band=detail x1='1' y1='" + ls_rowheight + "' x2='" + ls_width + "' y2='" + ls_rowheight + "'" + &
							" visible=" + '"' + "1~tIf(swapindicator='Y',1,0)" + '"' + "name=r_swap" + &
							" pen.style='2' pen.width='8' pen.color='255'  background.mode='1' background.color='553648127')"		
							
		ls_error = ldw_data.Modify(ls_rectangle)	
		ldw_data.SetPosition("r_swap","detail",FALSE)

		ls_rectangle = "Create line(band=header x1='1' y1='8' x2='" + ls_width + "' y2='8'" + &
							" visible='0' name=r_swap_header" + &
							" pen.style='2' pen.width='8' pen.color='255'  background.mode='1' background.color='553648127')"		

		ls_error = ldw_data.Modify(ls_rectangle)	
	End If
	
	This.Event ue_refreshtheme(ldw_data)
	
End If
end subroutine

public subroutine of_init (userobject au_parent, powerobject apo_origin, string as_origin_column, powerobject apo_destination, string as_destination_column, boolean ab_manage_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  au_parent				- The parent for the service.
//					apo_origin 				- The origin object
//					as_origin_column		- The origin column
//					apo_destination		- The destination object
//					as_destination_column- The destination column
//					ab_manage_gui			- Whether or not the service should manage the gui.
//	Overview:   This function initializes the swap object.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_init(au_parent, apo_origin, as_origin_column, apo_destination, as_destination_column, ab_manage_gui, True)


end subroutine

on n_swap_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_swap_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   This object will handle the different types of swapping between datawindows.  It can handle adding, removing
//					, moving up, and moving down.  It can swap items that have the following data types: string, number, decimal, date
//					, and datetime.  The origin and destination columns must be of the same data type.
//
//					of_init()	Call this function to initialize the object, passing the following properties in the following order:
//							as_type - the type of swap object (add, remove, up, down)
//							as_text - the text to be displayed on the object
//							adw_origin_dw - the origin dw (where the item is coming from initially)				
//							adw_origin_column - the unquoted name of the origin column (eg., TrnsctnTypID)
//							adw_destination_dw - the destination dw (where the item is going to) - not necessary for up and down swaps
//							adw_destination_column - the unquoted name of the destination column - not necessary for up and down swaps
//	Created by: Denton Newham
//	History:    12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Subscribe to the appropriate messages for being the origin object in a swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_subscribe(This, 'add item')
	gn_globals.in_subscription_service.of_subscribe(This, 'remove item')
	gn_globals.in_subscription_service.of_subscribe(This, 'destination rows changed')	
	gn_globals.in_subscription_service.of_subscribe(This, 'origin rows changed')		
End If

If Not IsValid(in_data_tools) Then in_data_tools = Create n_datawindow_tools
end event

event destructor;datawindow ldw_data

If IsValid(in_data_tools) Then Destroy in_data_tools 

If IsValid(ipo_destination) And ipo_destination.TypeOf() = datawindow! And ib_createswaprectangle Then
	ldw_data = ipo_destination
	ldw_data.Modify('Destroy r_swap')
	ldw_data.Modify('Destroy r_swap_header')
End If
end event

