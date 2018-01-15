$PBExportHeader$u_slider_control_vertical.sru
$PBExportComments$A vertical bar that resizes objects above and below it when it is moved.
forward
global type u_slider_control_vertical from statictext
end type
end forward

global type u_slider_control_vertical from statictext
integer width = 27
integer height = 1392
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "vertsplit.cur"
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
event mousemove pbm_mousemove
event ue_init ( )
event ue_move ( )
event leftbuttonup pbm_lbuttonup
event leftbuttondown pbm_lbuttondown
event move pbm_move
event ue_refreshtheme ( )
end type
global u_slider_control_vertical u_slider_control_vertical

type variables
protected window iw_reference
protected dragobject ido_left[]
protected dragobject ido_right[]
protected int ii_right_space[]
protected int ii_left_space[]
protected boolean ib_click = False
protected int ii_prev_xpos=0
protected u_slider_highlight vo_pane_highlight
protected boolean ib_move_in_process=False
protected boolean ib_automove_left = True
protected boolean ib_redraw_off = True
Protected:
 u_dynamic_gui iu_reference
end variables

forward prototypes
protected subroutine of_position_right ()
protected subroutine of_position_left ()
public subroutine of_add_right_object (dragobject ado_right)
protected subroutine of_move_highlight ()
protected function integer of_max_x ()
protected function integer of_min_x ()
protected subroutine of_set_prev_xpos (integer ai_xpos)
public subroutine of_set_turn_redraw_off (boolean ab_redraw)
public subroutine of_set_automove_left (boolean ab_left)
public subroutine of_set_reference (window aw_reference)
public subroutine of_set_reference (u_dynamic_gui au_reference)
public subroutine of_add_left_object (dragobject ado_left)
protected function integer of_get_prev_xpos ()
public subroutine of_reset ()
end prototypes

event mousemove;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      mousemove
// Overrides:  No
// Overview:   If the mouse has been moved over the object while the left button was clicked then
//					call the function of_move_highlight().
//
// Created by: Pat Newgent
// History:    11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// flags = 1:  Mouse Clicked
// ib_move_in_process = True mouse clicked while over
// object, Set to True in the leftbuttondown event.
//-----------------------------------------------------
if flags = 1 and ib_move_in_process then 
	this.of_move_highlight()
End If



end event

event ue_init;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_init
// Overrides:  No
// Overview:   This event is were object variable setup should occur.
//					Typical functions to call from here are:
//
//					of_add_left_object(dragobject) - Adds an object to be controlled that sits above the pane control
//					of_add_right_object(dragobject) - Adds an object to be controlled that sits below the pane control
//					of_set_doubleclick_left(boolean) - True to expand Left, False to expand Right
//
// Created by: Pat Newgent
// History:    11/16/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


end event

event leftbuttonup;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      leftbuttonup
// Overrides:  No
// Overview:   Reposition the pane control and destroy the instance of the highlight bar.
// Created by: Pat Newgent
// History:    11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_new_x
PowerObject lo_object
u_dynamic_gui lu_gui

//-----------------------------------------------------
// vo_pane_highlight: highlight bar
//-----------------------------------------------------
If isvalid(vo_pane_highlight) then

	if ib_redraw_off then
		if isvalid( iu_reference) then
			iu_reference.SetRedraw(False)
		else
			iw_reference.SetRedraw(False)
		end if
	end if
	
	//-----------------------------------------------------
	// Reposition the pane control to the location of the 
	// highlight bar.
	//-----------------------------------------------------
	ll_new_x = vo_pane_highlight.X
	
	lo_object = Parent
	
	If IsValid(lo_object) Then
		DO WHILE lo_object.TypeOf() <> Window!
			lu_gui = lo_object
			ll_new_x = ll_new_x - lu_gui.X
			lo_object = lo_object.GetParent()
		LOOP
	End If
	
	If IsValid(lo_object) Then
		If lo_object.TypeOf() <> Window! Then
			lu_gui = lo_object
			This.X = vo_pane_highlight.X - (w_mdi.PointerX() - lu_gui.PointerX()) + ll_new_x
		Else
			This.X = vo_pane_highlight.X
		End If
	Else
		This.X = vo_pane_highlight.X
	End If

	

	


	//-----------------------------------------------------
	// Destroy the instance of the highlight bar
	//-----------------------------------------------------
	if isvalid( iu_reference) then
		iu_reference.of_closeuserobject( vo_pane_highlight)
	else
		iw_reference.CloseUserObject(vo_pane_highlight)
	end if

	//-----------------------------------------------------
	// Set the move_in_process variable to false indicating
	// that the move is complete.
	//-----------------------------------------------------
	ib_move_in_process = False
	if ib_redraw_off then
		if isvalid( iu_reference) then
			iu_reference.SetRedraw(TRUE)
		else
			iw_reference.SetRedraw(TRUE)
		end if
	end if
	
End IF

end event

event leftbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      leftbuttondown
// Overrides:  No
// Overview:   Set the variable ib_move_in_process to True indicating that a move has started
// Created by: Pat Newgent
// History:    11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_move_in_process = True
end event

event move;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      move
// Overrides:  No
// Overview:   When the pane control is repositioned, reposition/resize the objects it controls.
// Created by: Pat Newgent
// History:    11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

if ib_redraw_off then
	if isvalid( iu_reference) then
		iu_reference.SetRedraw(False)
	elseif isvalid( iw_reference) then
		iw_reference.SetRedraw(False)
	end if
end if

//-----------------------------------------------------
// Reposition the objects to the left of the pane
// control
//-----------------------------------------------------
This.of_position_left()

//-----------------------------------------------------
// Reposition the objects to the right of the pane
// control
//-----------------------------------------------------
This.of_position_right()

if ib_redraw_off then
	if isvalid( iu_reference) then
		iu_reference.SetRedraw(TRUE)
	elseif isvalid( iw_reference) then
		iw_reference.SetRedraw(TRUE)
	end if
end if

end event

event ue_refreshtheme;This.BackColor = gn_globals.in_theme.of_get_barcolor()
end event

protected subroutine of_position_right ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_position_right()
// Arguments:   none
// Overview:    Reposition all object in the array ido_right, maintaining there spacing with relation
//					 to the pane control.
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i, i_X2, i_new_X

//-----------------------------------------------------
// Loop through the array ido_right, repositioning the
// the objects relative to the pane control.
//-----------------------------------------------------
For i = 1 to UpperBound(ido_right)

	If Isvalid(ido_right[i]) then
		//-----------------------------------------------------
		// Determine the X2 coordinate for the dragobject.
		// e.g.     X1---------------------X2
		//            |                   |
		//            |                   |
		//            ---------------------
		//-----------------------------------------------------
		i_X2 = ido_right[i].X + ido_right[i].Width

		//-----------------------------------------------------
		// Determine the new Y1 coordinate for the dragobject
		//-----------------------------------------------------
		i_new_X = This.X + ii_right_space[i]

		//-----------------------------------------------------
		// If the new Y1 coordinate is greater than the Y2 coordinate
		// then set the the Y1 coordinate equal to the Y2 coordinate,
		// and set the height to zero.
		// Else, set the Y coordinate for the dragobject to the 
		// new Y coordinate, and the adjust the height so that 
		// the Y2 coordinate will remain the same.
		// This gives the effect that only the top of the 
		// dragobject is being adjusted.
		//-----------------------------------------------------
		if i_new_X >= i_X2 then
			ido_right[i].X = i_X2
			ido_right[i].Width = 0
		Else
			ido_right[i].X = i_new_X
			ido_right[i].Width = i_X2 - ido_right[i].X
		End IF

	End IF

Next

Return
end subroutine

protected subroutine of_position_left ();//---------------------------------------------------------------------------------------------------------------------------------
// Function:    of_position_left
// Arguments:   none
// Overview:    Reposition/resize the objects in the array ido_left[] relative to the pane control.
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i 

//-----------------------------------------------------
// Loop through the array ido_left repositioning the objects
// relative to the pane control
//-----------------------------------------------------
For i = 1 to UpperBound(ido_left)

	If isvalid(ido_left[i]) then
		//-----------------------------------------------------
		// if the X coordinate for the dragobject is less than
		// the X coordinate for the pane control plus the spacing,
		// then adjust the height of the dragobject relative to the
		// position of the pane controle.
		// Else, set the height to zero.
		//-----------------------------------------------------
		if ido_left[i].X < (this.X + ii_left_space[i]) Then
			ido_left[i].Width = This.X - ii_left_space[i] - ido_left[i].X
		Else
			ido_left[i].Width = 0
		End IF
	End if
	
Next

Return
end subroutine

public subroutine of_add_right_object (dragobject ado_right);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_add_right_object()
// Arguments:   ado_right - the dragobject to be controlled by the pane control that resides below the pane control
// Overview:    Adds the dragobject argument to the array ido_right[].
//					 Calculates the space between the dragobject and the Pane Control.  This spacing shall be maintained
//					 when reposition the pane control.
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int  i_ndx

//-----------------------------------------------------
// Determine the next avaialable index number
//-----------------------------------------------------
i_ndx = UpperBound(ido_right) + 1

//-----------------------------------------------------
// Add the dragobject to the array ido_right
//-----------------------------------------------------
ido_right[i_ndx] = ado_right

//-----------------------------------------------------
// Determine the current spacing between the dragobject
// and the pane control, and save the spacing calculation
// in the array ii_lower_space.
//-----------------------------------------------------
ii_right_space[i_ndx] = ado_right.X - This.X

Return
end subroutine

protected subroutine of_move_highlight ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_move_highlight()
// Arguments:   none
// Overview:    Reposition the pane control and resize/reposition the objects it controls.
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i_new_X, i

//-----------------------------------------------------
// Determine the Y coordinate in respects to the reference
// Window.
//-----------------------------------------------------
if isvalid( iu_reference) then
	i_new_X = iu_reference.PointerX()
else
	i_new_X = iw_reference.PointerX()
end if

//-----------------------------------------------------
// Determine if the pointer has moved beyond the boundaries
// of the controlled objects, and if so, return without
// moving the pane control.
//-----------------------------------------------------
if i_new_X < This.X then
	//-----------------------------------------------------
	// Check the Left array for object boundary.  If the
	// boundary is exceeded then return without moving the
	// control.
	//-----------------------------------------------------
	If i_new_X < of_min_X() then
	   Return
	End IF
Else
	//-----------------------------------------------------
	// Check right array for object boundary, if the boundary
	// is exceeded then return without moving the control.
	//-----------------------------------------------------
	If i_new_X > of_max_x() then
	   Return
	End IF
	
End If

if isvalid(vo_pane_highlight) then
	vo_pane_highlight.X = i_new_X
Else
	if isvalid( iu_reference) then
		vo_pane_highlight = iu_reference.of_openuserobject( 'u_slider_highlight', i_new_x, this.Y)
	else
		iw_reference.OpenUserObject ( vo_pane_highlight, i_new_x, this.Y)
	end if

	vo_pane_highlight.Height = This.Height
	vo_pane_highlight.Width = This.Width
	vo_pane_highlight.BringToTop = True
End IF

Return
end subroutine

protected function integer of_max_x ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_max_x()
// Arguments:   none
// Overview:    Loop throught the objects in the array ido_right, and determine the greatest
//					 X2 coordinate.
// Created by:  Pat Newgent
// History:     11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i, i_max_x

i_max_x = 0

//-----------------------------------------------------
// Loop through the items in the array ido_right, and determine
// the greatest value of X2.
//-----------------------------------------------------
For i = 1 to UpperBound(ido_right)
	if isvalid(ido_right[i]) then
		If ido_right[i].X + ido_right[i].Width - this.width > i_max_x then
			i_max_X = ido_right[i].X + ido_right[i].Width - this.width
		End If
	End If
Next

//-----------------------------------------------------
// Return the greatest X2 coordinate.
//-----------------------------------------------------
Return i_max_x
end function

protected function integer of_min_x ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_min_x()
// Arguments:   none
// Overview:    Loop throught the array ido_left and return the least X coordinate.
// Created by:  Pat Newgent
// History:     11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i, i_min_x

//-----------------------------------------------------
// Initialize the variable
//-----------------------------------------------------
i_min_x = 32000

//-----------------------------------------------------
// Loop through the array ido_left determining the 
// lowest X coordinate value.
//-----------------------------------------------------
For i = 1 to Upperbound(ido_left)
	if isvalid(ido_left[i]) then
		if ido_left[i].x < i_min_x then
			i_min_x = ido_left[i].x
		End If
	End If
Next

//-----------------------------------------------------
// Return the least X coordinate value.
//-----------------------------------------------------
Return i_min_x
end function

protected subroutine of_set_prev_xpos (integer ai_xpos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_prev_xpos
// Arguments:   ai_xpos - The previous X coordinate for the pane control
// Overview:    Sets the argument ai_xpos into the variable ii_prev_xpos
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ii_prev_xpos = ai_xpos
Return
end subroutine

public subroutine of_set_turn_redraw_off (boolean ab_redraw);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_turn_redraw_off()
// Arguments:   ab_redraw - This agrument is used to determine whether or not redraw is on during repositioning
//					 TRUE - Redraw is turned off
//					 FALSE - nothing happens
// Overview:    Sets ib_redraw_off to the pase agrument
// Created by:  Pat Newgent
// History:     12/19/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_redraw_off = ab_redraw
Return
end subroutine

public subroutine of_set_automove_left (boolean ab_left);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_doubleclick_left
// Arguments:   ab_left - True - Move pane control left
//								  False - Move Pane control right
// Overview:    Sets the instance variable ib_automove_left
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_automove_left = ab_left
Return
end subroutine

public subroutine of_set_reference (window aw_reference);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_reference
// Arguments:   aw_reference - The window object to use as the reference point for x, y
// Overview:    Sets the instance variable iw_reference, this object is used as the base
//					 coordinates for positioning the pane control.
// Created by:  Pat Newgent
// History:     11/15/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
iw_reference = aw_reference
Return
end subroutine

public subroutine of_set_reference (u_dynamic_gui au_reference);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_reference
// Arguments:   aw_reference - The window object to use as the reference point for x, y
// Overview:    Sets the instance variable iw_reference, this object is used as the base
//					 coordinates for positioning the pane control.
// Created by:  Pat Newgent
// History:     11/15/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
iu_reference = au_reference
iw_reference = au_reference.of_getparentwindow()
Return
end subroutine

public subroutine of_add_left_object (dragobject ado_left);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_add_left_object
// Arguments:   ado_left - A dragobject to be controlled by the pane control
// Overview:    Add the dragobject to the array ido_left[].
//					 Calculate and save the space between the dragobject and the pane control in the array ii_left_space[]
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int  i_ndx

//-----------------------------------------------------
// Determine the next available index
//-----------------------------------------------------
i_ndx = UpperBound(ido_left) + 1

//-----------------------------------------------------
// Add the dragobject to the array ido_left[]
//-----------------------------------------------------
ido_left[i_ndx] = ado_left

//-----------------------------------------------------
// Calculate the space between the pane control and
// the dragobject
//-----------------------------------------------------
ii_left_space[i_ndx] =  This.X - (ado_left.X + ado_left.width)

Return
end subroutine

protected function integer of_get_prev_xpos ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_prev_xpos()
// Arguments:   none
// Overview:    Returns the previous X coordinate for the pane control prior to when it was doublclicked.
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ii_prev_xpos

end function

public subroutine of_reset ();dragobject ldo_empty[]

ido_left[]	= ldo_empty[]
ido_right[]	= ldo_empty[]
end subroutine

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      constructor
// Overrides:  No
// Overview:   Post the event 'ue_init'.  The event ue_init is used to initialize object variables.
//					ue_init was required because the reference window could not be specified in the constructor
//					event since the constructor events occur before the window is established.
//
// Created by: Pat Newgent
// History:    11/16/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

window			lw_window
u_dynamic_gui	lu_gui

if typeof(parent) = window! then
	lw_window = parent
	this.of_set_reference(lw_window)
else
	lu_gui = parent
	this.of_set_reference(lu_gui)
end if

this.PostEvent('ue_init')
end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   Moves the position of the pane control to either the panes control maximum left or right
//					position based on the value of ib_automove_left.
//					ib_automove_left = True - Left
//					ib_automove_left = False - Right
//
// Created by: Pat Newgent
// History:    11/16/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i_min_x

//-----------------------------------------------------
// Turn the redraw off for reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(False)

//-----------------------------------------------------
// If the pane controlled has been previously doubleclicked,
// the reset the pane control to its previous position, else
// set the pane control to the position specified by
// ib_automove_left.
//-----------------------------------------------------
If ib_click Then
	This.x = of_get_prev_xpos()
	ib_click = False
Else
	of_set_prev_xpos(This.X)
	if ib_automove_left then
		This.X = of_min_x()			
	Else
		This.X = of_max_x()
	End IF
	ib_click = True
End If

//-----------------------------------------------------
// Turn redraw back on for the reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(True)

end event

on u_slider_control_vertical.create
end on

on u_slider_control_vertical.destroy
end on

