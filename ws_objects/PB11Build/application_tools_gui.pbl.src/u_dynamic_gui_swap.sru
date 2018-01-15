$PBExportHeader$u_dynamic_gui_swap.sru
forward
global type u_dynamic_gui_swap from u_dynamic_gui
end type
type st_base from u_statictext within u_dynamic_gui_swap
end type
type st_selected from u_statictext within u_dynamic_gui_swap
end type
type dw_base from u_datawindow within u_dynamic_gui_swap
end type
type dw_selected from u_datawindow within u_dynamic_gui_swap
end type
type u_swap_add from u_commandbutton within u_dynamic_gui_swap
end type
type u_swap_remove from u_commandbutton within u_dynamic_gui_swap
end type
type u_swap_moveup from u_commandbutton within u_dynamic_gui_swap
end type
type u_swap_movedown from u_commandbutton within u_dynamic_gui_swap
end type
end forward

global type u_dynamic_gui_swap from u_dynamic_gui
integer width = 1751
integer height = 752
boolean border = false
long backcolor = 79741120
event ue_lbuttonup pbm_lbuttonup
st_base st_base
st_selected st_selected
dw_base dw_base
dw_selected dw_selected
u_swap_add u_swap_add
u_swap_remove u_swap_remove
u_swap_moveup u_swap_moveup
u_swap_movedown u_swap_movedown
end type
global u_dynamic_gui_swap u_dynamic_gui_swap

type variables
Protected:
	Boolean			ib_addremoveitems
	Boolean			ib_rowsmoveitems
	String			is_origincolumn
	String			is_destinationcolumn
	
	n_swap_service 		in_swap_service
	n_rowsmove_service 	in_rowsmove_service
	//n_string_functions	in_string_functions
	n_bag						in_bag
	datawindow				idw_data
	
end variables

forward prototypes
public function string of_get_values ()
public subroutine of_init (ref powerobject an_object)
end prototypes

event ue_lbuttonup;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_lbuttonup
//	Overrides:  No
//	Arguments:	
//	Overview:   Send the event to the swap service and rowsmove service.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_swap_service) 		Then in_swap_service.of_leftbuttonup(This, 0, 0)
If IsValid(in_rowsmove_service) 	Then in_rowsmove_service.of_leftbuttonup(This, 0, 0)
end event

public function string of_get_values ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_values()
//	Arguments:  None
//	Overview:   Redirect the application of the field selection to the selection service.
//	Created by:	Denton Newham
//	History: 	1/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_count, ll_index
String 	ls_values

//-----------------------------------------------------------------------------------------------------------------------------------
// Grab the values from dw_selected.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_count = dw_selected.RowCount() 
If ll_count < 1 Then Return ''

For ll_index = 1 To ll_count
	ls_values = ls_values + dw_selected.GetItemString(ll_index, is_destinationcolumn) + ','
Next

Return Left(ls_values, Len(ls_values) - 1)


end function

public subroutine of_init (ref powerobject an_object);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  None
//	Overview:   The function is where all setup logic should be.
//	Created by:	Denton Newham
//	History: 	12/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_row
n_datawindow_graphic_service_manager ln_manager
datawindowchild ldwc_child
userobject lu_this = This

//-----------------------------------------------------------------------------------------------------------------------------------
// Take care of the pointer.
//-----------------------------------------------------------------------------------------------------------------------------------
SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Validate the bag.
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(an_object.ClassName())) <> 'n_bag' Then Return
in_bag = an_object
If Not IsValid(in_bag) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the setup information.
//-----------------------------------------------------------------------------------------------------------------------------------
is_origincolumn		= Lower(Trim(String(in_bag.of_get('origin column'))))
is_destinationcolumn	= Lower(Trim(String(in_bag.of_get('destination column'))))
ib_addremoveitems		= Upper(Trim(String(in_bag.of_get('add/remove items')))) = 'Y'
ib_rowsmoveitems		= Upper(Trim(String(in_bag.of_get('rows move items')))) = 'Y'

If IsNull(is_origincolumn) Or Len(Trim(is_origincolumn)) = 0 Or Trim(is_origincolumn) = '' Then is_origincolumn = 'as_columns'
If IsNull(is_destinationcolumn) Or Len(Trim(is_destinationcolumn)) = 0 Or Trim(is_destinationcolumn) = '' Then is_destinationcolumn = 'as_columns'

If Not ib_addremoveitems Then 
	u_swap_add.Enabled 		= False
	u_swap_remove. Enabled 	= False
End If

If Not IsValid(in_swap_service) And ib_addremoveitems Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the swap service.
	//-----------------------------------------------------------------------------------------------------------------------------------
	in_swap_service = Create n_swap_service
	in_swap_service.of_init(lu_this, dw_base, is_origincolumn, dw_selected, is_destinationcolumn, True, False)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the swap service as a component to each datawindow's service manager.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_manager = dw_base.of_get_service_manager()
	ln_manager.of_add_component(in_swap_service, 'n_swap_service')
	
	ln_manager = dw_selected.of_get_service_manager()
	ln_manager.of_add_component(in_swap_service, 'n_swap_service')	
End If

If Not IsValid(in_rowsmove_service) And ib_rowsmoveitems Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the rowsmove service.
	//-----------------------------------------------------------------------------------------------------------------------------------
	in_rowsmove_service = Create n_rowsmove_service 
	in_rowsmove_service.of_init(lu_this, dw_selected, True)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the rowsmove service as a component to dw_selected's service manager.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_manager = dw_selected.of_get_service_manager()
	ln_manager.of_add_component(in_rowsmove_service, 'n_rowsmove_service')
End If

If Not ib_rowsmoveitems Then
	u_swap_moveup.Visible = False
	u_swap_movedown.Visible = False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the data for the object.
//-----------------------------------------------------------------------------------------------------------------------------------
This.TriggerEvent('ue_getdata')



end subroutine

on u_dynamic_gui_swap.create
int iCurrent
call super::create
this.st_base=create st_base
this.st_selected=create st_selected
this.dw_base=create dw_base
this.dw_selected=create dw_selected
this.u_swap_add=create u_swap_add
this.u_swap_remove=create u_swap_remove
this.u_swap_moveup=create u_swap_moveup
this.u_swap_movedown=create u_swap_movedown
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_base
this.Control[iCurrent+2]=this.st_selected
this.Control[iCurrent+3]=this.dw_base
this.Control[iCurrent+4]=this.dw_selected
this.Control[iCurrent+5]=this.u_swap_add
this.Control[iCurrent+6]=this.u_swap_remove
this.Control[iCurrent+7]=this.u_swap_moveup
this.Control[iCurrent+8]=this.u_swap_movedown
end on

on u_dynamic_gui_swap.destroy
call super::destroy
destroy(this.st_base)
destroy(this.st_selected)
destroy(this.dw_base)
destroy(this.dw_selected)
destroy(this.u_swap_add)
destroy(this.u_swap_remove)
destroy(this.u_swap_moveup)
destroy(this.u_swap_movedown)
end on

event destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Destroy the instantiated objects.
//	Created by: Denton Newham
//	History:    1/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_swap_service) 		Then Destroy in_swap_service
If IsValid(in_rowsmove_service) 	Then Destroy in_rowsmove_service
end event

event ue_mouseover;call super::ue_mouseover;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_mouseover
//	Overrides:  No
//	Arguments:	
//	Overview:   Send the event to the swap service and rowsmove service.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

DWObject ldo_null
userobject lu_this
lu_this = This

If IsValid(in_swap_service) 		Then in_swap_service.of_mousemove(lu_this, 0, ldo_null)
If IsValid(in_rowsmove_service) 	Then in_rowsmove_service.of_mousemove(lu_this, 0, ldo_null)

end event

event ue_getdata;call super::ue_getdata;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_getdata
//	Overrides:  No
//	Arguments:	None	
//	Overview:   Original data retrieval.
//	Created by: Denton Newham
//	History:    2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_items, ls_itemarray[], ls_selecteditems, ls_selecteditemarray[], ls_selectedrows
Long 		ll_index, ll_row

dw_base.Reset()
dw_selected.Reset()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the list of all items and selected items.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_items				= in_bag.of_get('all items')
ls_selecteditems 	= in_bag.of_get('selected items')

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the items to dw_base.
//-----------------------------------------------------------------------------------------------------------------------------------		
gn_globals.in_string_functions.of_parse_string(ls_items, ',', ls_itemarray[])
For ll_index = 1 To UpperBound(ls_itemarray[])
	If ls_itemarray[ll_index] = '!' Then Continue		
	ll_row = dw_base.InsertRow(0)
	dw_base.SetItem(ll_row, is_origincolumn, Trim(ls_itemarray[ll_index]))	
Next
dw_base.Sort()
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Determine which rows in dw_base correspond to the selected items.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_selecteditems, ',', ls_selecteditemarray[])
For ll_index = 1 To UpperBound(ls_selecteditemarray[])
	ll_row = dw_base.Find(is_origincolumn + '="' + Trim(ls_selecteditemarray[ll_index]) + '"', 1, dw_base.RowCount())
	If IsNull(ll_row) Or ll_row <= 0 Then Continue	
	ls_selectedrows = ls_selectedrows + String(ll_row) + ','
Next
	
//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message to highlight the visible headers in dw_base.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('add item', Left(ls_selectedrows, Len(ls_selectedrows) - 1)	+ '~t0')

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message to highlight only the first field in dw_selected.
//-----------------------------------------------------------------------------------------------------------------------------------	
gn_globals.in_subscription_service.of_message('new destination selections', 1)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message to trigger enablement validation on the swap controls.
//-----------------------------------------------------------------------------------------------------------------------------------		
gn_globals.in_subscription_service.of_message('destination rows changed', 1)


end event

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Resize
//	Overrides:  No
//	Arguments:	
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    2/10/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the base datwindow's Height and Width.
//-----------------------------------------------------------------------------------------------------------------------------------
dw_base.Width 	= (Width/2) - (46) - 220
dw_base.Height = 0.8324 * Height

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the selected datawindow's position and dimensions.
//-----------------------------------------------------------------------------------------------------------------------------------
dw_selected.X			= dw_base.X + dw_base.Width + 402
dw_selected.Width		= dw_base.Width
dw_selected.Height	= dw_base.Height

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the static text for the selected datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
st_selected.X	= dw_selected.X

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the swap button's position.
//-----------------------------------------------------------------------------------------------------------------------------------
u_swap_add.X		= dw_base.X + dw_base.Width + 50
u_swap_add.Y		= dw_base.Y + (dw_base.Height/3) - 98 
u_swap_remove.X	= u_swap_add.X
u_swap_remove.Y	= dw_base.Y + (dw_base.Height/3) + 14

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the rows move button's position.
//-----------------------------------------------------------------------------------------------------------------------------------
u_swap_movedown.X	= dw_selected.X + (dw_selected.Width/2) - 96
u_swap_movedown.Y	= dw_selected.Y + dw_selected.Height + 28
u_swap_moveup.X	= dw_selected.X + (dw_selected.Width/2) + 12
u_swap_moveup.Y	= u_swap_movedown.Y


end event

type st_base from u_statictext within u_dynamic_gui_swap
integer x = 46
integer y = 12
integer width = 402
integer height = 60
integer weight = 400
string facename = "Tahoma"
long backcolor = 80269524
string text = "Available Items:"
alignment alignment = left!
end type

event ue_refreshtheme;call super::ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_refreshtheme
//	Overrides:  No
//	Arguments:	None
//	Overview:   Refresh the theme for the object.
//	Created by: Denton Newham
//	History:    12/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//This.BackColor = gn_globals.in_theme.of_get_backcolor()

end event

type st_selected from u_statictext within u_dynamic_gui_swap
integer x = 1074
integer y = 12
integer width = 361
integer height = 60
integer weight = 400
string facename = "Tahoma"
long backcolor = 80269524
string text = "Selected Items:"
alignment alignment = left!
end type

event ue_refreshtheme;call super::ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_refreshtheme
//	Overrides:  No
//	Arguments:	None
//	Overview:   Refresh the theme for the object.
//	Created by: Denton Newham
//	History:    12/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//This.BackColor = gn_globals.in_theme.of_get_backcolor()

end event

type dw_base from u_datawindow within u_dynamic_gui_swap
integer x = 46
integer y = 72
integer width = 626
integer height = 548
integer taborder = 60
string dataobject = "d_show_fields"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      constructor
//	Overrides:  No
//	Arguments:	None.
//	Overview:   
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_datawindow_graphic_service_manager ln_manager

ln_manager = This.of_get_service_manager()

If IsValid(ln_manager) Then
	ln_manager.of_add_service('n_rowfocus_service')
	ln_manager.of_create_services()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Subscribe to the appropriate messages for being the origin object in a swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_subscribe(This, 'swap requested - add item')
	gn_globals.in_subscription_service.of_subscribe(This, 'new origin selections')
End If
end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_notify
//	Overrides:  No.
//	Arguments:	as_message, aany_argument
//	Overview:   Respond to subsribed messages.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_row, ll_upper, ll_index
string ls_rows, ls_select_rows[]
n_datawindow_graphic_service_manager ln_manager
nonvisualobject ln_service
//n_string_functions ln_string_functions
//n_rowfocus_service ln_rowfocus_service

Choose Case Lower(Trim(as_message))
		
	Case	'swap requested - add item'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If this is a swap of type add, then get the selected rows into a comma-delimited string, followed by the startrow
		//	and publish a message to swap them.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_row = This.of_getselectedrow(0)
		
		Do While ll_row > 0
			ls_rows = ls_rows + String(ll_row) + ','
			ll_row = This.of_getselectedrow(ll_row)
		Loop
		
		ls_rows = Left(ls_rows, Len(ls_rows) - 1)	+ '~t' + String(aany_argument)		

		If IsValid(gn_globals.in_subscription_service) Then
			gn_globals.in_subscription_service.of_message('add item', ls_rows)
		End If

		
	Case	'new origin selections'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Take the string of rows passed in and make them the selected rows for the datawindow.
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_parse_string(String(aany_argument), ',', ls_select_rows[])
		ll_upper = UpperBound(ls_select_rows)
		If ll_upper < 1 Then Return
		This.ScrollToRow(Long(ls_select_rows[ll_upper]))
		
		ln_manager = This.of_get_service_manager()
		
		If IsValid(ln_manager) Then ln_service = ln_manager.of_get_service('n_rowfocus_service')
	//	If IsValid(ln_service) Then ln_rowfocus_service = ln_service
		
//		If IsValid(ln_rowfocus_service) Then
//			ln_rowfocus_service.of_retrieveend()
//			
//			For ll_index = 1 To ll_upper
//				If Len(Trim(ls_select_rows[ll_index])) <= 0 Or ls_select_rows[ll_index] = '' Or IsNull(ls_select_rows[ll_index]) Then Continue
//				ln_rowfocus_service.of_highlightrow(Long(ls_select_rows[ll_index]))
//			Next
//		End If
		
End Choose
end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_row
string ls_rows

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the selected rows into a comma-delimited string and publish a message to validate the swap controls enablement.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = This.of_getselectedrow(0)

Do While ll_row > 0
	ls_rows = ls_rows + String(ll_row) + ','
	ll_row = This.of_getselectedrow(ll_row)
Loop

ls_rows = Left(ls_rows, Len(ls_rows) - 1)				

If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('origin rows changed', ls_rows)
End If
end event

type dw_selected from u_datawindow within u_dynamic_gui_swap
integer x = 1074
integer y = 72
integer width = 626
integer height = 548
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_selected_fields"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_notify
//	Overrides:  No.
//	Arguments:	as_message, aany_argument
//	Overview:   Respond to subsribed messages.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_row, ll_upper, ll_index, ll_min_row, ll_max_row
string ls_rows, ls_select_rows[], ls_argument
nonvisualobject ln_service 
n_datawindow_graphic_service_manager ln_manager
//n_string_functions ln_string_functions
//n_rowfocus_service ln_rowfocus_service

Choose Case Lower(Trim(as_message))
		
	Case	'swap requested - remove item'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the selected rows into a comma-delimited string and the startrow and publish a message to swap.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_row = This.of_getselectedrow(0)
		
		Do While ll_row > 0
			ls_rows = ls_rows + String(ll_row) + ','
			ll_row = This.of_getselectedrow(ll_row)
		Loop
		
		ls_rows = Left(ls_rows, Len(ls_rows) - 1) + '~t' + String(aany_argument)				

		If IsValid(gn_globals.in_subscription_service) Then
			gn_globals.in_subscription_service.of_message('remove item', ls_rows)
		End If
		
		dw_base.Sort()
		
	Case	'rowsmove requested'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the selected rows into a comma-delimited string and add the startrow and publish a message to move them.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_row = This.of_getselectedrow(0)
		ll_min_row = ll_row
		
		Do While ll_row > 0
			ll_max_row = ll_row
			ls_rows = ls_rows + String(ll_row) + ','		
			ll_row = This.of_getselectedrow(ll_row)
		Loop
		
		If IsNumber(String(aany_argument)) Then
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If the startrow is less than the first selected row, then this is a move item up.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If Long(aany_argument) < ll_min_row And ll_min_row > 1 Then ls_argument = 'move item up'
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Now, if another selected row is greater than the startrow and this isn't a move item up, then we don't want to do anything.
			//-----------------------------------------------------------------------------------------------------------------------------------			
			If Long(aany_argument) >= ll_max_row Then ls_argument = 'move item down'
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If the startrow is equal to the last selected row, then make the startrow one more.  This is because the swapindicator appears at the bottom
			// of a detail row.
			//-----------------------------------------------------------------------------------------------------------------------------------				
			If Long(aany_argument) = ll_max_row Then aany_argument = String(Long(aany_argument) + 1)	
			ls_rows = Left(ls_rows, Len(ls_rows) - 1)	+ '~t' + String(aany_argument)
		Else
			ls_argument = String(aany_argument)
			ls_rows = Left(ls_rows, Len(ls_rows) - 1)	+ '~t' + '0'
		End If
		
		If IsValid(gn_globals.in_subscription_service) And Not IsNull(ls_argument) And ls_argument <> '' And Len(Trim(ls_argument)) > 0 Then
			gn_globals.in_subscription_service.of_message(ls_argument, ls_rows)
		End If
		
	Case	'new destination selections'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Take the string of rows passed in and make them the selected rows for the datawindow.
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_parse_string(String(aany_argument), ',', ls_select_rows[])
		ll_upper = UpperBound(ls_select_rows)
		If ll_upper < 1 Then Return
		This.ScrollToRow(Long(ls_select_rows[ll_upper]))
		
		ln_manager = This.of_get_service_manager()
		
		If IsValid(ln_manager) Then ln_service = ln_manager.of_get_service('n_rowfocus_service')
//		If IsValid(ln_service) Then ln_rowfocus_service = ln_service
		
//		If IsValid(ln_rowfocus_service) Then
//			ln_rowfocus_service.of_retrieveend()
//			
//			For ll_index = 1 To ll_upper
//				If Len(Trim(ls_select_rows[ll_index])) <= 0 Or ls_select_rows[ll_index] = '' Or IsNull(ls_select_rows[ll_index]) Then Continue
//				ln_rowfocus_service.of_highlightrow(Long(ls_select_rows[ll_index]))
//			Next
//		End If
		
		If IsValid(gn_globals.in_subscription_service) Then
			gn_globals.in_subscription_service.of_message('destination rows changed', String(aany_argument))	
		End If
			
End Choose
end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_datawindow_graphic_service_manager ln_manager

ln_manager = This.of_get_service_manager()

If IsValid(ln_manager) Then
	ln_manager.of_add_service('n_rowfocus_service')
	ln_manager.of_create_services()
End If


//-----------------------------------------------------------------------------------------------------------------------------------
//	Subscribe to the appropriate messages for being the origin object in a swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_subscribe(This, 'swap requested - remove item')
	gn_globals.in_subscription_service.of_subscribe(This, 'rowsmove requested')
	gn_globals.in_subscription_service.of_subscribe(This, 'new destination selections')	
End If
end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_row
string ls_rows

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the selected rows into a comma-delimited string and publish a message to validate the swap controls enablement.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = This.of_getselectedrow(0)

Do While ll_row > 0
	ls_rows = ls_rows + String(ll_row) + ','
	ll_row = This.of_getselectedrow(ll_row)
Loop

ls_rows = Left(ls_rows, Len(ls_rows) - 1)				

If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('destination rows changed', ls_rows)
End If
end event

type u_swap_add from u_commandbutton within u_dynamic_gui_swap
integer x = 722
integer y = 96
integer width = 302
integer height = 84
integer taborder = 40
integer weight = 400
string facename = "Tahoma"
string text = "&Add ->"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Play some sounds.
//-----------------------------------------------------------------------------------------------------------------------------------
//gn_globals.in_multimedia.of_play_sound('start.wav')
//gn_globals.in_multimedia.post of_play_sound('done.wav')

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('swap requested - add item', 0)

end event

type u_swap_remove from u_commandbutton within u_dynamic_gui_swap
integer x = 722
integer y = 208
integer width = 302
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "<- &Remove"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Play some sounds.
//-----------------------------------------------------------------------------------------------------------------------------------
//gn_globals.in_multimedia.of_play_sound('start.wav')
//gn_globals.in_multimedia.post of_play_sound('done.wav')

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('swap requested - remove item', 0)

end event

type u_swap_moveup from u_commandbutton within u_dynamic_gui_swap
integer x = 1074
integer y = 648
integer width = 302
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Move &Up"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Play some sounds.
//-----------------------------------------------------------------------------------------------------------------------------------
//gn_globals.in_multimedia.of_play_sound('start.wav')
//gn_globals.in_multimedia.post of_play_sound('done.wav')

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('rowsmove requested', 'move item up')

end event

type u_swap_movedown from u_commandbutton within u_dynamic_gui_swap
integer x = 1399
integer y = 648
integer width = 302
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Move &Down"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Play some sounds.
//-----------------------------------------------------------------------------------------------------------------------------------
//gn_globals.in_multimedia.of_play_sound('start.wav')
//gn_globals.in_multimedia.post of_play_sound('done.wav')

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_subscription_service.of_message('rowsmove requested', 'move item down')

end event

