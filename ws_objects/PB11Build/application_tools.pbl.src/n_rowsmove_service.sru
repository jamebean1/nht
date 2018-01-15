$PBExportHeader$n_rowsmove_service.sru
forward
global type n_rowsmove_service from nonvisualobject
end type
end forward

global type n_rowsmove_service from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
event ue_refreshtheme ( )
end type
global n_rowsmove_service n_rowsmove_service

type variables
Protected:
	userobject iu_parent
	powerobject ipo_object

	n_datawindow_tools in_data_tools
	boolean ib_manage_gui

	dragobject ido_swap[]
	boolean ib_swapping
	powerobject ipo_dragstart

	long il_last_row
	long il_clicked_row
	long il_ypos
	
end variables

forward prototypes
public subroutine of_set_parent (userobject au_parent)
public subroutine of_set_object (powerobject apo_object)
public subroutine of_set_manage_gui (boolean ab_manage_gui)
public subroutine of_init (ref userobject au_parent, ref powerobject apo_object, boolean ab_manage_gui)
public function string of_rowsmove (string as_type)
public function string of_rowsmove (string as_type, long al_startrow)
public function string of_rowsmove (string as_type, string as_rows)
public subroutine of_leftbuttondown (powerobject apo_object, long xpos, long ypos)
public subroutine of_leftbuttonup (powerobject apo_object, long xpos, long ypos)
public subroutine of_manage_controls (string as_rows)
public subroutine of_mousemove (powerobject apo_object, long row, dwobject dwo)
public function string of_getselectedrows (string as_type, string as_rows, long al_startrow)
public function string of_rowsmove (string as_type, string as_rows, long al_startrow)
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
string ls_rows, ls_old_rows
long ll_startrow

Choose Case Lower(Trim(as_message))
				
	Case 'move item up', 'move item down'
		
		ls_old_rows = Left(String(as_arg), Pos(String(as_arg), '~t') - 1)
		ll_startrow = Long(Right(String(as_arg), Len(String(as_arg)) - Pos(String(as_arg), '~t')))
		ls_rows = This.of_rowsmove(as_message, ls_old_rows, ll_startrow)
				
		If ib_manage_gui Then
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Manage the swap controls.
			//-----------------------------------------------------------------------------------------------------------------------------------
//			This.of_manage_controls(ls_rows)
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Publish a message to distribute the rows that need to be selected in the destination datawindows.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsValid(gn_globals.in_subscription_service) Then						
				gn_globals.in_subscription_service.of_message('new destination selections', ls_rows)		
			End If				
				
		End If
	
	Case	'destination rows changed'
		
		If ib_manage_gui Then
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Manage the swap controls.
			//-----------------------------------------------------------------------------------------------------------------------------------
//			This.of_manage_controls(String(as_arg))
				
		End If
	
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
If IsValid(ipo_object) And ipo_object.TypeOf() = datawindow! Then 
	
	ldw_data = ipo_object
//	ldw_data.Modify("r_swap.Brush.Color='" + String(gn_globals.in_theme.of_get_backcolor()) + "'")
	
End If
end event

public subroutine of_set_parent (userobject au_parent);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_parent
//	Arguments:  au_parent
//	Overview:   This script sets the parent.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

iu_parent = au_parent
end subroutine

public subroutine of_set_object (powerobject apo_object);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set__object
//	Arguments:  apo_origin
//	Overview:   This script sets the destination object for the swap object.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ipo_object = apo_object
end subroutine

public subroutine of_set_manage_gui (boolean ab_manage_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_manage_gui
//	Arguments:  ab_manage_gui
//	Overview:   This script sets gui management on/off.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_manage_gui= ab_manage_gui
end subroutine

public subroutine of_init (ref userobject au_parent, ref powerobject apo_object, boolean ab_manage_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  au_parent				-  The parent for the service.
//					ab_manage_gui			-  Whether or not the service should manage the gui.
//	Overview:   This function initializes the swap object.
//	Created by:	Denton Newham
//	History: 	12/27/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index
string ls_rectangle, ls_error, ls_width, ls_rowheight
datawindow ldw_data

This.of_set_parent(au_parent)
This.of_set_object(apo_object)
This.of_set_manage_gui(ab_manage_gui)

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
If IsValid(ipo_object) And ipo_object.TypeOf() = datawindow! Then

	ldw_data = ipo_object
	ls_width = String(ldw_data.Width)
	ls_rowheight = String(Long(ldw_data.Describe("DataWindow.Detail.Height")) - 3 )

	//-----------------------------------------------------------------------------------------------------------------------------------					
	//	If the column swapindicator exists, create the detail line and the header line.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsNumber(ldw_data.Describe("swapindicator.ID")) Then
		
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
	
	This.Event ue_refreshtheme()
	
End If


end subroutine

public function string of_rowsmove (string as_type);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rowsmove()
//	Arguments:  as_type 			- The type of swap
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_rowsmove(as_type, '', 0)
end function

public function string of_rowsmove (string as_type, long al_startrow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rowsmove()
//	Arguments:  as_type 			- The type of swap
//					al_startrow		- The row to start swapping into for the destination object.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_rowsmove(as_type, '', al_startrow)
end function

public function string of_rowsmove (string as_type, string as_rows);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rowsmove()
//	Arguments:  as_type 			- The type of swap
//					as_rows			- The rows to be swapped
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_rowsmove(as_type, as_rows, 0)
end function

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
		il_clicked_row = ll_row
		il_ypos = ypos
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
		// If there are no rows in the datawindow then set the startrow to be null.
		//-----------------------------------------------------------------------------------------------------------------------------------		
		If ldw_data.RowCount() < 1 Then SetNull(ll_row)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If il_clicked_row is the same as the current row, and the pointer is no farther south than it was at click time, then don't do anything.
		//-----------------------------------------------------------------------------------------------------------------------------------			
		If ll_row = il_clicked_row and ypos <= il_ypos Then
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the row isn't valid then remove the swap indicators and return.
		//-----------------------------------------------------------------------------------------------------------------------------------			
		If IsNull(ll_row) Then
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return
		End If
		
		If apo_object = ipo_dragstart And ipo_dragstart = ipo_object Then 
			//-----------------------------------------------------------------------------------------------------------------------------------
			//	If we started and are still in ipo_object, then publish a message that a rowsmove is requested.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsValid(gn_globals.in_subscription_service) Then
				gn_globals.in_subscription_service.of_message('rowsmove requested', ll_row)
			End If		
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return
		Else
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
			Return			
		End If
		
	Else
		If IsValid(ipo_object) And ipo_object.TypeOf() = datawindow! Then 
			ldw_data = ipo_object
			ldw_data.SetItem(il_last_row , 'swapindicator', '')
			ldw_data.Modify('r_swap_header.Visible="0"')
			ib_swapping = False
		End If
	End If
	
End If





		
	
	


end subroutine

public subroutine of_manage_controls (string as_rows);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_manage_controls()
//	Arguments:  as_rows
//	Overview:   Determine if the swap controls are enabled or disabled.
//	Created by:	Denton Newham
//	History: 	1/3/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_index, ll_row, ll_loop, ll_upper
string ls_rows[]
boolean lb_enabled
//n_string_functions ln_string_functions
commandbutton lcb_swap

If Not ib_manage_gui Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out the row string into an array.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_rows, ',', ls_rows[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Go through all of the swap objects to determine if they are enabled or disabled.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upper = UpperBound(ido_swap)

For ll_index = 1 To UpperBound(ido_swap)
	
	lb_enabled = True
			
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Choose the type of swap and validate (names of form u_swap_add, u_swap_remove, etc.).
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case Mid(ido_swap[ll_index].ClassName(), 8, Len(ido_swap[ll_index].ClassName()))

		Case	'moveup', 'movedown'

			//-----------------------------------------------------------------------------------------------------------------------------------
			// If there are no rows in the object, then these controls are disabled.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If ipo_object.Dynamic RowCount() < 1 Then 
				lb_enabled = False
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If no row is selected, then these controls are disabled.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If UpperBound(ls_rows) < 1 Then 
				lb_enabled = False
			End If
				
			For ll_loop = 1 To UpperBound(ls_rows)
				//-----------------------------------------------------------------------------------------------------------------------------------
				// If the selected rows in the destination object are not in sequential order, then an up/down swap cannot be performed.
				//-----------------------------------------------------------------------------------------------------------------------------------
				If ll_loop <> 1 Then
					If Long(ls_rows[ll_loop]) <> Long(ls_rows[ll_loop - 1]) + 1 Then 
						lb_enabled = False				
					End If
				End If
			Next
	
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Specific up/down validation.
			//----------------------------------------------------------------------------------------------------------------------------------
			Choose Case Mid(ido_swap[ll_index].ClassName(), 8, Len(ido_swap[ll_index].ClassName())) 
								
				Case	'moveup'
					//-----------------------------------------------------------------------------------------------------------------------------------
					// If the first row is selected, moving up is not possible.
					//-----------------------------------------------------------------------------------------------------------------------------------
					If UpperBound(ls_rows) > 0 Then ll_row = Long(ls_rows[1])

					If ll_row <= 1 Or IsNull(ll_row) Then
						lb_enabled = False			
					End If
			
				Case	'movedown'
					//-----------------------------------------------------------------------------------------------------------------------------------
					// If the last row is selected, moving down is not possible.
					//-----------------------------------------------------------------------------------------------------------------------------------
					If UpperBound(ls_rows) > 0 Then ll_row = Long(ls_rows[UpperBound(ls_rows)])
		
					If ll_row = ipo_object.Dynamic RowCount() Or IsNull(ll_row) Then
						lb_enabled = False				
					End If
	
			End Choose
	
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

public subroutine of_mousemove (powerobject apo_object, long row, dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
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
	
	If apo_object = ipo_object And ipo_dragstart = ipo_object Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If we are in swap mode and only dealing with the destination object then clear the indicator for the last row.
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
		End If
	
	Else
	
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		// This will clear the highlights if you call this function from the userobject surrounding ipo_object.
//		//-----------------------------------------------------------------------------------------------------------------------------------		
//		If IsValid(ipo_object) And ipo_object.TypeOf() = datawindow! Then
//			ldw_data = ipo_object
//			ls_error = ldw_data.Modify('r_swap_header.Visible="0"')
//			ldw_data.SetItem(il_last_row , 'swapindicator', '')
//		End If
		
	End If
	
Else
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// This will clear the highlights if somehow the mouse button gets up without removing the highlights.
	//-----------------------------------------------------------------------------------------------------------------------------------		
	If IsValid(ipo_object) And ipo_object.TypeOf() = datawindow! Then
		ldw_data = ipo_object
		ls_error = ldw_data.Modify('r_swap_header.Visible="0"')
		ldw_data.SetItem(il_last_row , 'swapindicator', '')
	End If

End If
end subroutine

public function string of_getselectedrows (string as_type, string as_rows, long al_startrow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getselectedrows()
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
long ll_upper, ll_index, ll_row, ll_min, ll_max, ll_adjustment
string ls_rows[], ls_new_rows
//n_string_functions ln_string_functions

If Not IsValid(ipo_object) Then Return ''

Choose Case Lower(Trim(as_type))
		
	Case	'move item up', 'move item down'			
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the rows into an array.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(Trim(as_rows)) <= 0 Or as_rows = '' Or IsNull(as_rows) Then as_rows = String(ipo_object.Dynamic GetRow())
		gn_globals.in_string_functions.of_parse_string(as_rows, ',', ls_rows[])
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the row array and validate that they are sequential.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_upper = UpperBound(ls_rows)
		If ll_upper < 1 Then Return ''
		
		ll_min = Long(ls_rows[1])
		ll_max = Long(ls_rows[UpperBound(ls_rows)])				

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine the new position of the rows based on the movement type and the value of al_startrow.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Lower(Trim(as_type)) = 'move item up' Then
			
			If al_startrow = 0 Then
				ll_adjustment = -1
			ElseIf al_startrow > 0 Then
				ll_adjustment = (al_startrow + 1) - ll_min
			ElseIf al_startrow = -1 Then
				ll_adjustment = 1 - ll_min
			End If
			
		ElseIf Lower(Trim(as_type)) = 'move item down' Then
			
			If al_startrow = 0 Then
				ll_adjustment = 1
			ElseIf al_startrow > 0 Then
				ll_adjustment = al_startrow - ll_max
			End If
			
		End If
			
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the array and adjust the row position.  Build the new row string.
		//-----------------------------------------------------------------------------------------------------------------------------------		
		For ll_index = 1 To ll_upper
			ls_rows[ll_index] = String(Long(ls_rows[ll_index]) + ll_adjustment)
			ls_new_rows = ls_new_rows + ls_rows[ll_index] + ','
		Next
		
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the new row list.
//-----------------------------------------------------------------------------------------------------------------------------------	
Return Left(ls_new_rows, Len(ls_new_rows) - 1)
end function

public function string of_rowsmove (string as_type, string as_rows, long al_startrow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rowsmove()
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
string ls_rows[], ls_new_rows
//n_string_functions ln_string_functions

datawindow	ldw
datastore	lds

If Not IsValid(ipo_object) Then Return ''

If TypeOf(ipo_object) = DataWindow! then
	ldw = ipo_object
else
	lds = ipo_object
end if

Choose Case Lower(Trim(as_type))
		
	Case	'move item up', 'move item down'			
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the rows into an array.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(Trim(as_rows)) <= 0 Or as_rows = '' Or IsNull(as_rows) Then
			if isvalid(ldw) then
				as_rows = String(ldw.GetRow())
			else
				as_rows = String(lds.GetRow())
			end if
		end if
		gn_globals.in_string_functions.of_parse_string(as_rows, ',', ls_rows[])
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the row array and validate that they are sequential.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_upper = UpperBound(ls_rows)
		If ll_upper < 1 Then Return ''
		For ll_index = 1 To ll_upper
			If ll_index <> 1 Then
				If Long(ls_rows[ll_index]) <> ll_last_row + 1 Then Return ''
			End If
			
			ll_last_row = Long(ls_rows[ll_index])
		Next
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the maximum and minimum row to be moved.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_min = Long(ls_rows[1])
		ll_max = Long(ls_rows[UpperBound(ls_rows)])				

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine the position the rows are to be moved to and move them.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If al_startrow = 0 Then		
			
			If Lower(Trim(as_type)) = 'move item up' Then
				ll_row = ll_min - 1
				If ll_row <= 0 Then Return ''
				
			ElseIf Lower(Trim(as_type)) = 'move item down' Then
				ll_row = ll_min
				ll_min = ll_max + 1
				ll_max = ll_min
				If ll_min > ipo_object.Dynamic RowCount() Then Return ''
				
			End If
			
		ElseIf al_startrow > 0 And Not IsNull(al_startrow) Then

			If Lower(Trim(as_type)) = 'move item up' Then
				ll_row = al_startrow + 1
				If ll_row < 0 Or ll_row >= ll_min Then Return ''
				
			ElseIf Lower(Trim(as_type)) = 'move item down' Then
				ll_row = ll_min
				ll_min = ll_max + 1
				ll_max = al_startrow
				If ll_min > ll_max Or ll_row >= ll_max Then Return ''
				
			End If
			
		ElseIf al_startrow = -1 And ll_min > 1 Then
			ll_row = 1				
			
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Move the rows to their new position.
		//-----------------------------------------------------------------------------------------------------------------------------------		
		if isvalid(ldw) then
			ldw.RowsMove(ll_min, ll_max, Primary!, ldw, ll_row, Primary!)
		else
			lds.RowsMove(ll_min, ll_max, Primary!, lds, ll_row, Primary!)
		end if			
			
//		ipo_object.Dynamic RowsMove(ll_min, ll_max, Primary!, ipo_object, ll_row, Primary!)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the rows selected into a string
		//-----------------------------------------------------------------------------------------------------------------------------------	
		ls_new_rows = This.of_getselectedrows(as_type, as_rows, al_startrow)
		
				
End Choose

Return ls_new_rows
end function

on n_rowsmove_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_rowsmove_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not IsValid(in_data_tools) Then in_data_tools = Create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
//	Subscribe to the appropriate messages for being the origin object in a swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_subscribe(This, 'move item up')
	gn_globals.in_subscription_service.of_subscribe(This, 'move item down')
	gn_globals.in_subscription_service.of_subscribe(This, 'destination rows changed')	
End If
end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datawindow ldw_data

If IsValid(in_data_tools) Then Destroy in_data_tools

If IsValid(ipo_object) And ipo_object.TypeOf() = datawindow! Then
	ldw_data = ipo_object
	ldw_data.Modify('Destroy r_swap')
	ldw_data.Modify('Destroy r_swap_header')
End If
end event

