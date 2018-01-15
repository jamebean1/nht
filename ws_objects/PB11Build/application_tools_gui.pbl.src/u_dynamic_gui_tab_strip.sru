$PBExportHeader$u_dynamic_gui_tab_strip.sru
forward
global type u_dynamic_gui_tab_strip from u_dynamic_gui
end type
type dw_scrollbar from datawindow within u_dynamic_gui_tab_strip
end type
type ln_line from line within u_dynamic_gui_tab_strip
end type
end forward

global type u_dynamic_gui_tab_strip from u_dynamic_gui
integer height = 100
dw_scrollbar dw_scrollbar
ln_line ln_line
end type
global u_dynamic_gui_tab_strip u_dynamic_gui_tab_strip

type variables
Protected:
	u_dynamic_gui_tab_control iu_dynamic_gui_tab_control[]
	Boolean ib_enabled = True
	u_dynamic_gui iu_dynamic_gui_currently_selected
	Long	il_ScrolledTabIndex = 0
end variables

forward prototypes
public subroutine of_select (u_dynamic_gui au_dynamic_gui)
public subroutine of_enable (boolean ab_enabled)
public subroutine of_selectfirst ()
public subroutine of_determine_valid_tabs ()
public subroutine of_reset ()
public subroutine of_refresh ()
public subroutine of_add_gui (u_dynamic_gui au_dynamic_gui)
public subroutine of_add_gui (u_dynamic_gui au_dynamic_gui, boolean ab_isvertical)
end prototypes

public subroutine of_select (u_dynamic_gui au_dynamic_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_select()
//	Arguments:  au_dynamic_gui - The object to control
//	Overview:   Select the GUI
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
u_dynamic_gui lu_dynamic_gui

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
		lu_dynamic_gui = iu_dynamic_gui_tab_control[ll_index].of_get_gui()
		If IsValid(lu_dynamic_gui) Then
			If lu_dynamic_gui = au_dynamic_gui Then
				iu_dynamic_gui_tab_control[ll_index].of_select()
			End If
		End If

	End If
Next

end subroutine

public subroutine of_enable (boolean ab_enabled);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_enable()
//	Arguments:  ab_enabled- Whether or not the tab strip is enabled
//	Overview:   Whether or not the tab strip is enabled
//	Created by:	Blake Doerr
//	History: 	4/14/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


ib_enabled = ab_enabled

If ab_enabled Then
	If IsValid(iu_dynamic_gui_currently_selected) Then
		This.Event ue_notify('tab selected', iu_dynamic_gui_currently_selected)
	End If
End If
end subroutine

public subroutine of_selectfirst ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_select()
//	Arguments:  au_dynamic_gui - The object to control
//	Overview:   Select the GUI
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
		iu_dynamic_gui_tab_control[ll_index].of_select()
		Return
	End If
Next

end subroutine

public subroutine of_determine_valid_tabs ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_determine_valid_tabs()
//	Overview:   Destroy the valid tabs
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
u_dynamic_gui lu_dynamic_gui
Boolean lb_selected = False

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the GUI, if it isn't valid close it
		//-----------------------------------------------------------------------------------------------------------------------------------
		lu_dynamic_gui = iu_dynamic_gui_tab_control[ll_index].of_get_gui()
		If Not IsValid(lu_dynamic_gui) Then
			This.of_closeuserobject(iu_dynamic_gui_tab_control[ll_index])
		Else
			lb_selected = lb_selected Or iu_dynamic_gui_tab_control[ll_index].of_IsSelected()
		End If
	End If
Next


//-----------------------------------------------------------------------------------------------------------------------------------
// Find the first one and select it
//-----------------------------------------------------------------------------------------------------------------------------------
If Not lb_selected Then
	For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
		If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
			iu_dynamic_gui_tab_control[ll_index].of_select()
			Exit
		End If
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Resize the tabs
//-----------------------------------------------------------------------------------------------------------------------------------
This.TriggerEvent('resize')
end subroutine

public subroutine of_reset ();Long ll_index
u_dynamic_gui_tab_control lu_dynamic_gui_tab_control[]
u_dynamic_gui lu_dynamic_gui_nullobject

iu_dynamic_gui_currently_selected = lu_dynamic_gui_nullobject

For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then This.of_closeuserobject(iu_dynamic_gui_tab_control[ll_index])
Next

iu_dynamic_gui_tab_control[] = lu_dynamic_gui_tab_control[]
end subroutine

public subroutine of_refresh ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_refresh()
//	Overview:   This will refresh the tabs
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Clean up the tabs
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_determine_valid_tabs()

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the one that needs to be selected
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
		If iu_dynamic_gui_tab_control[ll_index].of_IsSelected() Then
			iu_dynamic_gui_tab_control[ll_index].of_select()
			Exit
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Refresh the theme for good measure
//-----------------------------------------------------------------------------------------------------------------------------------
This.Event ue_refreshtheme()

//-----------------------------------------------------------------------------------------------------------------------------------
// Resize for good measure
//-----------------------------------------------------------------------------------------------------------------------------------
This.TriggerEvent('resize')
end subroutine

public subroutine of_add_gui (u_dynamic_gui au_dynamic_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_gui()
//	Arguments:  au_dynamic_gui - The object to control
//					ab_isvertical - The configuration boolean
//	Overview:   Add the GUI to the list
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_add_gui(au_dynamic_gui, True)
end subroutine

public subroutine of_add_gui (u_dynamic_gui au_dynamic_gui, boolean ab_isvertical);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_gui()
//	Arguments:  au_dynamic_gui - The object to control
//					ab_isvertical - The configuration boolean
//	Overview:   Add the GUI to the list
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_index
u_dynamic_gui_tab_control lu_dynamic_gui_tab_control

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_dynamic_gui) Then Return

For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If Not IsValid(iu_dynamic_gui_tab_control[ll_index]) Then Continue
	If au_dynamic_gui = iu_dynamic_gui_tab_control[ll_index].of_get_gui() Then Return
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Open the tab object
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui_tab_control = This.of_openuserobject('u_dynamic_gui_tab_control', 20000, 0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lu_dynamic_gui_tab_control) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Initialize tab control
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui_tab_control.Border = False
iu_dynamic_gui_tab_control[UpperBound(iu_dynamic_gui_tab_control) + 1] = lu_dynamic_gui_tab_control
lu_dynamic_gui_tab_control.of_init(au_dynamic_gui, ab_isvertical)

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the valid tabs
//-----------------------------------------------------------------------------------------------------------------------------------
of_refresh()
end subroutine

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Resize
//	Overrides:  No
//	Arguments:	
//	Overview:   Resize the tabs
//	Created by: Blake Doerr
//	History:    4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_x_position = 40, ll_total_width = 40, ll_scroll_x = 0
Boolean lb_there_are_tabs = False, lb_TheScrollButtonsAreVisible = False

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the total width of all the tabs added together
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
		lb_there_are_tabs = True
		ll_total_width = ll_total_width + iu_dynamic_gui_tab_control[ll_index].Width + 10
		iu_dynamic_gui_tab_control[ll_index].of_refresh()
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine how much scrolling width there is
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
		If ll_index <= il_ScrolledTabIndex Then
			ll_scroll_x = ll_scroll_x + iu_dynamic_gui_tab_control[ll_index].Width + 10
		End If
		
		If ll_total_width - ll_scroll_x + dw_scrollbar.Width < This.Width Then
			il_ScrolledTabIndex = ll_index
			Exit
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Make the line visible only if there are tabs
//-----------------------------------------------------------------------------------------------------------------------------------
ln_line.Visible = lb_there_are_tabs

//-----------------------------------------------------------------------------------------------------------------------------------
// See if the buttons are visible
//-----------------------------------------------------------------------------------------------------------------------------------
lb_TheScrollButtonsAreVisible = ll_total_width > This.Width
dw_scrollbar.Visible = lb_TheScrollButtonsAreVisible
dw_scrollbar.Y = -5
//-----------------------------------------------------------------------------------------------------------------------------------
// If the buttons are visible resize the right most buttons
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_TheScrollButtonsAreVisible Then
	ll_x_position = ll_x_position + dw_scrollbar.Width - ll_scroll_x
Else
	il_ScrolledTabIndex = 0
	ll_scroll_x = 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the tabs and resize
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
	If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
		lb_there_are_tabs = True
		iu_dynamic_gui_tab_control[ll_index].X = ll_x_position
		ll_x_position = ll_x_position + iu_dynamic_gui_tab_control[ll_index].Width + 10
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Bring the buttons to the top
//-----------------------------------------------------------------------------------------------------------------------------------
dw_scrollbar.BringToTop = True
end event

on u_dynamic_gui_tab_strip.create
int iCurrent
call super::create
this.dw_scrollbar=create dw_scrollbar
this.ln_line=create ln_line
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_scrollbar
this.Control[iCurrent+2]=this.ln_line
end on

on u_dynamic_gui_tab_strip.destroy
call super::destroy
destroy(this.dw_scrollbar)
destroy(this.ln_line)
end on

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:       ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
u_dynamic_gui lu_dynamic_gui

Choose Case Lower(Trim(as_message))
   Case 'tab selected'
		lu_dynamic_gui = as_arg
		iu_dynamic_gui_currently_selected = lu_dynamic_gui
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Select the object
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ib_enabled Then
			For ll_index = 1 To UpperBound(iu_dynamic_gui_tab_control[])
				If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then
					If iu_dynamic_gui_tab_control[ll_index] <> lu_dynamic_gui Then
						iu_dynamic_gui_tab_control[ll_index].of_deselect()
					End If
				End If
			Next
			
			This.BringToTop = True
			
			This.TriggerEvent('resize')
		End If
	Case 'forward'
		If il_ScrolledTabIndex >= UpperBound(iu_dynamic_gui_tab_control[]) Or UpperBound(iu_dynamic_gui_tab_control[]) = 0 Then
			il_ScrolledTabIndex = UpperBound(iu_dynamic_gui_tab_control[])
		Else
			For ll_index = il_ScrolledTabIndex + 1 To UpperBound(iu_dynamic_gui_tab_control[])
				il_ScrolledTabIndex = ll_index
				If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then Exit
			Next
		End If
		
		This.TriggerEvent('resize')
		
	Case 'back'
		If il_ScrolledTabIndex <= 1 Or UpperBound(iu_dynamic_gui_tab_control[]) = 0 Then
			il_ScrolledTabIndex = 0
		Else
			For ll_index = il_ScrolledTabIndex - 1 To 1 Step -1
				il_ScrolledTabIndex = ll_index
				If IsValid(iu_dynamic_gui_tab_control[ll_index]) Then Exit
			Next
		End If
		
		This.TriggerEvent('resize')
   Case Else
End Choose

end event

event constructor;call super::constructor;This.Event ue_refreshtheme()
end event

event ue_refreshtheme;call super::ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This event will refresh all the objects on the window
// Created by: Blake Doerr
// History:    1/8/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//This will set the background color of a datawindow to BackColor
dw_scrollbar.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_backcolor()) +  "'")

end event

type dw_scrollbar from datawindow within u_dynamic_gui_tab_strip
integer y = 4
integer width = 128
integer height = 164
integer taborder = 10
string title = "none"
string dataobject = "d_tab_control_scrollbar"
boolean border = false
boolean livescroll = true
end type

event clicked;If Not IsValid(dwo) Then Return

Choose Case Lower(dwo.Name)
	Case 'forward', 'back'
		Parent.Event ue_notify(dwo.Name, '')
End Choose
end event

type ln_line from line within u_dynamic_gui_tab_strip
integer linethickness = 5
integer endx = 32000
end type

