$PBExportHeader$u_slider_control_horizontal.sru
$PBExportComments$A horizontal bar that resizes objects above and below it when it is moved.
forward
global type u_slider_control_horizontal from statictext
end type
end forward

global type u_slider_control_horizontal from statictext
integer width = 2866
integer height = 28
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "horzsplit.cur"
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
event mousemove pbm_mousemove
event ue_init ( )
event move pbm_move
event leftbuttondown pbm_lbuttondown
event leftbuttonup pbm_lbuttonup
event ue_refreshtheme ( )
end type
global u_slider_control_horizontal u_slider_control_horizontal

type variables
protected window iw_reference
protected dragobject ido_upper[]
protected dragobject ido_lower[]
protected int ii_lower_space[]
protected int ii_upper_space[]
protected boolean ib_click = False
protected int ii_prev_ypos=0
protected u_slider_highlight vo_pane_highlight
protected boolean ib_automove_up = True
protected boolean ib_move_in_process = False
protected boolean ib_redraw_off = True

Protected:
 u_dynamic_gui iu_reference
end variables

forward prototypes
public subroutine of_set_reference (window aw_reference)
public subroutine of_add_upper_object (dragobject ado_upper)
protected subroutine of_position_lower ()
protected subroutine of_position_upper ()
protected function integer of_min_y ()
protected subroutine of_move_highlight ()
protected subroutine of_set_prev_ypos (integer ai_ypos)
protected function integer of_max_y ()
protected function integer of_get_prev_ypos ()
public subroutine of_set_turn_redraw_off (boolean ab_redraw)
public subroutine of_set_automove_up (boolean ab_up)
public subroutine of_set_reference (u_dynamic_gui au_dynamic_gui)
public subroutine of_add_lower_object (dragobject ado_lower)
public subroutine of_reset ()
end prototypes

event mousemove;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      mousemove
// Overrides:  No
// Overview:   If the mouse has been moved over the object while the left button was clicked then
//					call the function of_move().
//
// Created by: Pat Newgent
// History:    11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

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
//					of_add_upper_object(dragobject) - Adds an object to be controlled that sits above the pane control
//					of_add_lower_object(dragobject) - Adds an object to be controlled that sits below the pane control
//					of_set_upperbound(int) - Sets the upperboundary for the pane control
//					of_set_lowerbound(int) - Sets the lowerboundary for the pane control
//					of_set_doubleclick_ypos(int) - Set the Y coordinate for the pane control for when the user doulbleclicks
//															 on the pane control
// Created by: Pat Newgent
// History:    11/16/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


end event

event move;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      move
// Overrides:  No
// Overview:   When the pane control is repositioned, reposition/resize the objects it controls.
// Created by: Pat Newgent
// History:    11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If xpos = -30000 Or ypos = -30000 Then Return 1

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
This.of_position_upper()

//-----------------------------------------------------
// Reposition the objects to the right of the pane
// control
//-----------------------------------------------------
This.of_position_lower()

if ib_redraw_off then
	if isvalid( iu_reference) then
		iu_reference.SetRedraw(TRUE)
	elseif isvalid( iw_reference) then
		iw_reference.SetRedraw(TRUE)
	end if
end if

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

event leftbuttonup;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      leftbuttonup
// Overrides:  No
// Overview:   Reposition the pane control and destroy the instance of the highlight bar.
// Created by: Pat Newgent
// History:    11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

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
	This.Y = vo_pane_highlight.Y

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

event ue_refreshtheme;This.BackColor = gn_globals.in_theme.of_get_barcolor()
end event

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

public subroutine of_add_upper_object (dragobject ado_upper);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_add_upper_object
// Arguments:   ado_upper - A dragobject to be controlled by the pane control
// Overview:    Add the dragobject to the array ido_upper[].
//					 Calculate and save the space between the dragobject and the pane control in the array ii_upper_space[]
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int  i_ndx

//-----------------------------------------------------
// Determine the next available index
//-----------------------------------------------------
i_ndx = UpperBound(ido_upper) + 1

//-----------------------------------------------------
// Add the dragobject to the array ido_upper[]
//-----------------------------------------------------
ido_upper[i_ndx] = ado_upper

//-----------------------------------------------------
// Calculate the space between the pane control and
// the dragobject
//-----------------------------------------------------
ii_upper_space[i_ndx] =  This.Y - (ado_upper.Y + ado_upper.height)

Return
end subroutine

protected subroutine of_position_lower ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_position_lower()
// Arguments:   none
// Overview:    Reposition all object in the array ido_lower, maintaining there spacing with relation
//					 to the pane control.
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i, i_Y2, i_new_Y

//-----------------------------------------------------
// Loop through the array ido_lower, repositioning the
// the objects relative to the pane control.
//-----------------------------------------------------
For i = 1 to UpperBound(ido_lower)

	if isvalid(ido_lower[i]) then

		//-----------------------------------------------------
		// Determine the Y2 coordinate for the dragobject.
		// e.g.     Y1---------------------
		//            |                   |
		//            |                   |
		//          Y2---------------------
		//-----------------------------------------------------
		i_Y2 = ido_lower[i].Y + ido_lower[i].height

		//-----------------------------------------------------
		// Determine the new Y1 coordinate for the dragobject
		//-----------------------------------------------------
		i_new_Y = This.Y + ii_lower_space[i]

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
		if i_new_Y >= i_Y2 then
			ido_lower[i].Y = i_Y2
			ido_lower[i].Height = 0
		Else
			ido_lower[i].Y = i_new_Y
			ido_lower[i].Height = i_Y2 - ido_lower[i].Y
		End IF

	End IF
Next

Return
end subroutine

protected subroutine of_position_upper ();//---------------------------------------------------------------------------------------------------------------------------------
// Function:    of_position_upper
// Arguments:   none
// Overview:    Reposition/resize the objects in the array ido_upper[] relative to the pane control.
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i 

//-----------------------------------------------------
// Loop through the array ido_upper repositioning the objects
// relative to the pane control
//-----------------------------------------------------
For i = 1 to UpperBound(ido_upper)

	If isvalid(ido_upper[i]) then

		//-----------------------------------------------------
		// if the Y coordinate for the dragobject is less than
		// the Y coordinate for the pane control plus the spacing,
		// then adjust the height of the dragobject relative to the
		// position of the pane controle.
		// Else, set the height to zero.
		//-----------------------------------------------------
		if ido_upper[i].Y < (this.Y + ii_upper_space[i]) Then
			ido_upper[i].Height = This.y - ii_upper_space[i] - ido_upper[i].Y
		Else
			ido_upper[i].Height = 0
		End IF
	End IF
	
Next

Return
end subroutine

protected function integer of_min_y ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_min_y
// Arguments:   none
// Overview:    Returns the minimum Y coordinate for the Pane Control
// Created by:  Pat Newgent
// History:     11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

int i, i_min_Y

i_min_Y = 32000

//-----------------------------------------------------
// Loop through the array ido_upper and determine the
// minimum Y coordinate
//-----------------------------------------------------
For i = 1 to UpperBound(ido_upper)
	if isvalid(ido_upper[i]) then
		If ido_upper[i].Y < i_min_Y then
			i_min_Y = ido_upper[i].Y
		End If
	End If
Next

Return i_min_Y
end function

protected subroutine of_move_highlight ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_move()
// Arguments:   none
// Overview:    1) If not previously created, create an instance of the highlight bar.
//					 2) Moves the highlight bar to the position of the pointer
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
int i_new_Y, i, i_min_Y, i_max_Y

//-----------------------------------------------------
// Determine the Y coordinate in respects to the reference
// Window.
//-----------------------------------------------------
if isvalid( iu_reference) then
	i_new_Y = iu_reference.PointerY()
else
	i_new_Y = iw_reference.PointerY()
end if

//-----------------------------------------------------
// Determine if the pointer has moved beyond the boundaries
// of the controlled objects, and if so, return without
// moving the pane control.
//-----------------------------------------------------
if i_new_Y < This.Y then

	//-----------------------------------------------------
	// Check the Upper array for object boundary.  If the
	// boundary is exceeded then return without moving the
	// control.
	//-----------------------------------------------------
	If i_new_Y < of_min_Y() then
	   Return
	End IF
Else
	//-----------------------------------------------------
	// Check lower array for object boundary, if the boundary
	// is exceeded then return without moving the control.
	//-----------------------------------------------------
	If i_new_Y > of_max_Y() then
	   Return
	End IF
	
End If

//-----------------------------------------------------
// If the highlight bar has not been created, create it
// with the dimensions of the pane control, at the Y 
// coordinate of the mouse position.
// Else If the highlight bar already exists, then move
// it to the new mouse position.
//-----------------------------------------------------
if isvalid(vo_pane_highlight) then
	//-----------------------------------------------------
	// Move the highlight bar to the Y coordinate
	//-----------------------------------------------------
	vo_pane_highlight.Y = i_new_Y
Else
	//-----------------------------------------------------
	// Create an instance of the highlight bar
	//-----------------------------------------------------
	if isvalid( iu_reference) then
		vo_pane_highlight = iu_reference.of_openuserobject( 'u_slider_highlight', this.x, i_new_y)
	else
		iw_reference.OpenUserObject ( vo_pane_highlight, this.X, i_new_Y)
	end if

	//-----------------------------------------------------
	// Set the dimensions of the highlight bar to that of
	// the pane control.
	//-----------------------------------------------------
	vo_pane_highlight.Height = This.Height
	vo_pane_highlight.Width = This.Width
	vo_pane_highlight.BringToTop = True
End IF

Return
end subroutine

protected subroutine of_set_prev_ypos (integer ai_ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_prev_ypos
// Arguments:   ai_ypos - The previous Y coordinate for the pane control
// Overview:    Sets the argument ai_ypos into the variable ii_prev_ypos
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ii_prev_ypos = ai_ypos
Return
end subroutine

protected function integer of_max_y ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_max_y
// Arguments:   none
// Overview:    Returns the maximum Y coordinate for the Pane Control
// Created by:  Pat Newgent
// History:     11/18/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

int i, i_max_Y

i_max_Y = 0

//-----------------------------------------------------
// Loop through the array ido_lower and determine the
// Maximum Y coordinate
//-----------------------------------------------------
For i = 1 to UpperBound(ido_lower)
	if isvalid(ido_lower[i]) then
		If ido_lower[i].Y + ido_lower[i].height - this.height> i_max_Y then
			i_max_Y = ido_lower[i].Y + ido_lower[i].height - this.height
		End If
	End If
Next

Return i_max_Y
end function

protected function integer of_get_prev_ypos ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_prev_ypos()
// Arguments:   none
// Overview:    Returns the previous Y coordinate for the pane control prior to when it was doublclicked.
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ii_prev_ypos
end function

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

public subroutine of_set_automove_up (boolean ab_up);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_automove_up
// Arguments:   ab_up - True indicates expand up, false indicates to expand down
// Overview:    Sets the argument ab_up into the variable ib_automove_up
//
// Created by:  Pat Newgent
// History:     11/17/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_automove_up = ab_up
Return
end subroutine

public subroutine of_set_reference (u_dynamic_gui au_dynamic_gui);
iu_reference = au_dynamic_gui
iw_reference = au_dynamic_gui.of_getparentwindow()
end subroutine

public subroutine of_add_lower_object (dragobject ado_lower);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_add_lower_object()
// Arguments:   ado_lower - the dragobject to be controlled by the pane control that resides below the pane control
// Overview:    Adds the dragobject argument to the array ido_lower[].
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
i_ndx = UpperBound(ido_lower) + 1

//-----------------------------------------------------
// Add the dragobject to the array ido_lower
//-----------------------------------------------------
ido_lower[i_ndx] = ado_lower

//-----------------------------------------------------
// Determine the current spacing between the dragobject
// and the pane control, and save the spacing calculation
// in the array ii_lower_space.
//-----------------------------------------------------
ii_lower_space[i_ndx] = ado_lower.Y - This.Y

Return
end subroutine

public subroutine of_reset ();dragobject ldo_empty[]

ido_upper[]	= ldo_empty[]
ido_lower[]	= ldo_empty[]
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
// Overview:   Moves the position of the pane control to the coordinated specified in 
//					in the instance variable ib_automove_up, and then repositions/resizes
//					all objects being controlled by the pane control.
//
// Created by: Pat Newgent
// History:    11/16/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Turn the redraw off for reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(False)

//-----------------------------------------------------
// If the pane controlled has been previously doubleclicked,
// then reset the pane control to its previous position, else
// set the pane control to the position specified by
// ib_doubleclick_up.
// ib_doubleclick_up = True - Expand Up
// ib_doubleclick_up = False - Expand Down
//-----------------------------------------------------
If ib_click Then

	//-----------------------------------------------------
	// Set the Y coordinate for the pane control to the
	// previous position
	//-----------------------------------------------------
	This.Y = of_get_prev_ypos()
	ib_click = False
	
Else

	//-----------------------------------------------------
	// Store the current Y coordinate, and move the pane
	// control up or down based on the variable ib_doubleclick_up.
	// ib_doubleclick_up = True - Expand Up
	// ib_doubleclick_up = False - Expand Down
	//-----------------------------------------------------
	of_set_prev_ypos(This.Y)
	if ib_automove_up then
		This.Y = of_min_Y()
	Else
		This.Y = of_max_Y()
	End IF
	ib_click = True

End If

//-----------------------------------------------------
// Turn redraw back on for the reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(True)
 
end event

on u_slider_control_horizontal.create
end on

on u_slider_control_horizontal.destroy
end on

