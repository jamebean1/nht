$PBExportHeader$u_vscrollbar.sru
forward
global type u_vscrollbar from vscrollbar
end type
end forward

global type u_vscrollbar from vscrollbar
integer width = 73
integer height = 256
event ue_vscroll ( long al_position )
end type
global u_vscrollbar u_vscrollbar

type variables
Protected:

	long il_scroll = 50
	Boolean ib_ignore_scrolling = False
	PowerObject io_parent
end variables

forward prototypes
public subroutine of_set_position (long al_position)
public subroutine of_set_scroll_increment (long al_scroll_increment)
public subroutine of_set_maxposition (long al_maxposition)
public subroutine of_set_minposition (long al_minposition)
protected subroutine of_move (string as_type)
public subroutine of_setparent (powerobject ao_parent)
end prototypes

event ue_vscroll;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_vscroll
//	Overrides:  No
//	Arguments:	
//	Overview:   This will create an event that you can map to in order to resize correctly
//	Created by: Blake Doerr
//	History:    3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Any lany_any

If IsValid(io_parent) Then
	lany_any = al_position
	io_parent.Dynamic Event ue_notify('vscroll', lany_any)
End If
end event

public subroutine of_set_position (long al_position);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_scroll_increment()
//	Arguments:  al_scroll_increment - The scroll increment
//	Overview:   This will set the scroll increment for the scroll bar
//	Created by:	Blake Doerr
//	History: 	3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_ignore_scrolling = True
This.Position = Min(Max(al_position, MinPosition), MaxPosition)
ib_ignore_scrolling = False

end subroutine

public subroutine of_set_scroll_increment (long al_scroll_increment);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_scroll_increment()
//	Arguments:  al_scroll_increment - The scroll increment
//	Overview:   This will set the scroll increment for the scroll bar
//	Created by:	Blake Doerr
//	History: 	3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


il_scroll = al_scroll_increment
end subroutine

public subroutine of_set_maxposition (long al_maxposition);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_maxposition()
//	Arguments:  al_maxposition - The maximum position
//	Overview:   This will set the maximum position for the scroll bar
//	Created by:	Blake Doerr
//	History: 	3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_ignore_scrolling = True
MaxPosition = al_maxposition
ib_ignore_scrolling = False
end subroutine

public subroutine of_set_minposition (long al_minposition);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_maxposition()
//	Arguments:  al_maxposition - The maximum position
//	Overview:   This will set the maximum position for the scroll bar
//	Created by:	Blake Doerr
//	History: 	3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_ignore_scrolling = True
MinPosition = al_minposition
ib_ignore_scrolling = False
end subroutine

protected subroutine of_move (string as_type);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_move()
//	Arguments:  as_type - Up or Down
//	Overview:   This will move the scroll bar up or down
//	Created by:	Blake Doerr
//	History: 	3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If ib_ignore_scrolling Then Return

Choose Case Lower(Trim(as_type))
	Case 'up'
		this.position = Max(this.position - il_scroll, MinPosition)
	Case 'down'
		If This.Position = MaxPosition Then Return
		this.position = Min(this.position + il_scroll, MaxPosition)
	Case Else
		If IsNumber(as_type) Then
			this.position = Long(as_type)
		End If
End Choose

ib_ignore_scrolling = True
This.Event ue_vscroll(This.Position)
if isvalid(this) then 
	ib_ignore_scrolling = False
end if
end subroutine

public subroutine of_setparent (powerobject ao_parent);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setparent()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	6/9/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

io_parent = ao_parent
end subroutine

event linedown;of_move('down')

//uo_pricedisplay.y = -1 * this.position + st_1.height
//uo_pricedisplay.bringtotop = false
end event

event lineup;of_move('up')
	
//	uo_pricedisplay.y = -1 * this.position + st_1.height
//	uo_pricedisplay.bringtotop = false
end event

event moved;of_move(String(scrollpos))

//uo_pricedisplay.y = -1 * scrollpos + st_1.height
//uo_pricedisplay.bringtotop = false
end event

event pagedown;of_move('down')
end event

event pageup;of_move('up')
end event

on u_vscrollbar.create
end on

on u_vscrollbar.destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   This will attempt to set the parent.  This will not be correct if it is opened with of_openuserobject of u_dynamic_gui.  Use of_setparent().
//	Created by: Blake Doerr
//	History:    6/9/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

io_parent = This.GetParent()
end event

