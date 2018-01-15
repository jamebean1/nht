$PBExportHeader$u_show_fields_dynamic.sru
forward
global type u_show_fields_dynamic from u_dynamic_gui
end type
type cb_newcolumn from u_commandbutton within u_show_fields_dynamic
end type
type cb_addcolumn from u_commandbutton within u_show_fields_dynamic
end type
type u_swap_movelast from u_commandbutton within u_show_fields_dynamic
end type
type u_swap_movefirst from u_commandbutton within u_show_fields_dynamic
end type
type st_1 from u_statictext within u_show_fields_dynamic
end type
type st_3 from u_statictext within u_show_fields_dynamic
end type
type p_1 from picture within u_show_fields_dynamic
end type
type st_5 from statictext within u_show_fields_dynamic
end type
type st_4 from statictext within u_show_fields_dynamic
end type
type ln_1 from line within u_show_fields_dynamic
end type
type cb_cancel from u_commandbutton within u_show_fields_dynamic
end type
type cb_ok from u_commandbutton within u_show_fields_dynamic
end type
type dw_base from u_datawindow within u_show_fields_dynamic
end type
type dw_selected from u_datawindow within u_show_fields_dynamic
end type
type u_swap_add from u_commandbutton within u_show_fields_dynamic
end type
type u_swap_remove from u_commandbutton within u_show_fields_dynamic
end type
type u_swap_moveup from u_commandbutton within u_show_fields_dynamic
end type
type u_swap_movedown from u_commandbutton within u_show_fields_dynamic
end type
type cb_apply from u_commandbutton within u_show_fields_dynamic
end type
type ln_2 from line within u_show_fields_dynamic
end type
type ln_4 from line within u_show_fields_dynamic
end type
type ln_5 from line within u_show_fields_dynamic
end type
type st_8 from statictext within u_show_fields_dynamic
end type
end forward

global type u_show_fields_dynamic from u_dynamic_gui
integer width = 2519
integer height = 1272
boolean border = false
long backcolor = 79741120
event ue_lbuttonup pbm_lbuttonup
cb_newcolumn cb_newcolumn
cb_addcolumn cb_addcolumn
u_swap_movelast u_swap_movelast
u_swap_movefirst u_swap_movefirst
st_1 st_1
st_3 st_3
p_1 p_1
st_5 st_5
st_4 st_4
ln_1 ln_1
cb_cancel cb_cancel
cb_ok cb_ok
dw_base dw_base
dw_selected dw_selected
u_swap_add u_swap_add
u_swap_remove u_swap_remove
u_swap_moveup u_swap_moveup
u_swap_movedown u_swap_movedown
cb_apply cb_apply
ln_2 ln_2
ln_4 ln_4
ln_5 ln_5
st_8 st_8
end type
global u_show_fields_dynamic u_show_fields_dynamic

type variables
Protected:
//	n_show_fields 	in_fields_manager
	n_swap_service in_swap_service
	n_rowsmove_service in_rowsmove_service
	n_bag				in_bag
	datawindow		idw_data
	boolean			ib_addremoveitems
	String	is_header_array[]
	String	is_object_array[]
	n_show_fields in_show_fields
end variables

forward prototypes
public subroutine of_parse_string (string s_string, string s_delimiter, ref string s_string_array[])
public subroutine of_show_fields (string as_header_list, string as_object_list)
public subroutine of_apply ()
public subroutine of_init (nonvisualobject an_object)
end prototypes

event ue_lbuttonup;call super::ue_lbuttonup;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_lbuttonup
//	Overrides:  No
//	Arguments:	
//	Overview:   Send the event to the swap service and rowsmove service.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_swap_service) Then in_swap_service.of_leftbuttonup(This, 0, 0)

If IsValid(in_rowsmove_service) Then in_rowsmove_service.of_leftbuttonup(This, 0, 0)
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

public subroutine of_show_fields (string as_header_list, string as_object_list);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_show_fields()
//	Arguments:  as_header_list
//	Overview:   Insert the columns into dw_base
//	Created by:	Denton Newham
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_loop, ll_row
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the header string into an array.
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_parse_string(as_header_list, ',', is_header_array[])
This.of_parse_string(as_object_list, ',', is_object_array[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert the columns into dw_base.
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_loop = 1 To Min(UpperBound(is_header_array[]), UpperBound(is_object_array[]))
	If is_header_array[ll_loop] <> '!' Then
		gn_globals.in_string_functions.of_replace_all(is_header_array[ll_loop], '[comma]', ',')
		gn_globals.in_string_functions.of_replace_all(is_header_array[ll_loop], '[tilda]', '~~')
		gn_globals.in_string_functions.of_replace_all(is_header_array[ll_loop], '[singlequote]', "'")
		gn_globals.in_string_functions.of_replace_all(is_header_array[ll_loop], '[doublequote]', '"')
		ll_row = dw_base.InsertRow(0)
		dw_base.SetItem(ll_row, 'as_columns', Trim(is_header_array[ll_loop]))
	End If
	
Next

dw_base.Sort()
end subroutine

public subroutine of_apply ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply()
//	Arguments:  None
//	Overview:   Redirect the application of the field selection to the selection service.
//	Created by:	Denton Newham
//	History: 	1/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_count, ll_index
string ls_values
string	ls_message
string	ls_column
String	ls_original
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Grab the values from dw_selected.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_count = dw_selected.RowCount()
If ll_count < 1 Then Return

For ll_index = 1 To ll_count
	ls_original = dw_selected.GetItemString(ll_index, 'as_originalname')
	If Len(ls_original) > 0 And Not IsNull(ls_original) Then
		ls_column 	= ls_original
	Else
		ls_column 	= dw_selected.GetItemString(ll_index, 'as_columns')
	End If
	gn_globals.in_string_functions.of_replace_all(ls_column, ',', '[comma]')
	gn_globals.in_string_functions.of_replace_all(ls_column, '~~', '[tilda]')
	gn_globals.in_string_functions.of_replace_all(ls_column, "'", '[singlequote]')
	gn_globals.in_string_functions.of_replace_all(ls_column, '"', '[doublequote]')

	ls_values = ls_values + ls_column + ','
Next

ls_message = in_bag.of_get('apply message')

in_bag.of_set( 'selected items', Left(ls_values, Len(ls_values) - 1))

//gn_globals.in_subscription_service.of_message( ls_message, Left(ls_values, Len(ls_values) - 1), parent)

gn_globals.in_subscription_service.of_message( ls_message, Left(ls_values, Len(ls_values) - 1), idw_data)


end subroutine

public subroutine of_init (nonvisualobject an_object);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  None
//	Overview:   The function is where all setup logic should be.
//	Created by:	Denton Newham
//	History: 	12/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_manager
datawindowchild ldwc_child
userobject lu_this
long ll_row

SetPointer(HourGlass!)

lu_this = This
dw_base.Reset()
dw_selected.Reset()

If Lower(Trim(an_object.ClassName())) = 'n_show_fields' Then
	in_show_fields = an_object
	If IsValid(in_bag) Then Destroy in_bag
	in_bag = in_show_fields.of_get_information()
End If

If IsValid(in_bag) Then
	idw_data 			= in_bag.of_get('affected datawindow')
	ib_addremoveitems	= Upper(Trim(String(in_bag.of_get('add/remove items')))) = 'Y'
	
	cb_addcolumn.Enabled = IsValid(idw_data.Dynamic of_get_service('n_datawindow_formatting_service'))
	cb_newcolumn.Enabled = IsValid(idw_data.Dynamic of_get_service('n_datawindow_formatting_service'))
	
	If Not ib_addremoveitems Then 
		u_swap_add.Enabled 		= False
		u_swap_remove. Enabled 	= False
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the swap service.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(in_swap_service) Then
	in_swap_service = Create n_swap_service
	in_swap_service.of_init(lu_this, dw_base, 'as_columns', dw_selected, 'as_columns', True, False)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the swap service as a component to each datawindow's service manager.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_manager = dw_base.of_get_service_manager()
	If IsValid(ln_manager) Then
		ln_manager.of_add_component(in_swap_service, 'n_swap_service')
	End If
	
	ln_manager = dw_selected.of_get_service_manager()
	If IsValid(ln_manager) Then
		ln_manager.of_add_component(in_swap_service, 'n_swap_service')
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the rowsmove service.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(in_rowsmove_service) Then
	in_rowsmove_service = Create n_rowsmove_service 
	in_rowsmove_service.of_init(lu_this, dw_selected, True)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the rowsmove service as a component to dw_selected's service manager.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_manager = dw_selected.of_get_service_manager()
	If IsValid(ln_manager) Then
		ln_manager.of_add_component(in_rowsmove_service, 'n_rowsmove_service')
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Call ue_getdata for the object, which will trigger custom code for database refreshing, which must be done initially.
//-----------------------------------------------------------------------------------------------------------------------------------
This.TriggerEvent('ue_getdata')

If Not ib_addremoveitems Then Destroy in_swap_service




end subroutine

on u_show_fields_dynamic.create
int iCurrent
call super::create
this.cb_newcolumn=create cb_newcolumn
this.cb_addcolumn=create cb_addcolumn
this.u_swap_movelast=create u_swap_movelast
this.u_swap_movefirst=create u_swap_movefirst
this.st_1=create st_1
this.st_3=create st_3
this.p_1=create p_1
this.st_5=create st_5
this.st_4=create st_4
this.ln_1=create ln_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_base=create dw_base
this.dw_selected=create dw_selected
this.u_swap_add=create u_swap_add
this.u_swap_remove=create u_swap_remove
this.u_swap_moveup=create u_swap_moveup
this.u_swap_movedown=create u_swap_movedown
this.cb_apply=create cb_apply
this.ln_2=create ln_2
this.ln_4=create ln_4
this.ln_5=create ln_5
this.st_8=create st_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_newcolumn
this.Control[iCurrent+2]=this.cb_addcolumn
this.Control[iCurrent+3]=this.u_swap_movelast
this.Control[iCurrent+4]=this.u_swap_movefirst
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.p_1
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.ln_1
this.Control[iCurrent+11]=this.cb_cancel
this.Control[iCurrent+12]=this.cb_ok
this.Control[iCurrent+13]=this.dw_base
this.Control[iCurrent+14]=this.dw_selected
this.Control[iCurrent+15]=this.u_swap_add
this.Control[iCurrent+16]=this.u_swap_remove
this.Control[iCurrent+17]=this.u_swap_moveup
this.Control[iCurrent+18]=this.u_swap_movedown
this.Control[iCurrent+19]=this.cb_apply
this.Control[iCurrent+20]=this.ln_2
this.Control[iCurrent+21]=this.ln_4
this.Control[iCurrent+22]=this.ln_5
this.Control[iCurrent+23]=this.st_8
end on

on u_show_fields_dynamic.destroy
call super::destroy
destroy(this.cb_newcolumn)
destroy(this.cb_addcolumn)
destroy(this.u_swap_movelast)
destroy(this.u_swap_movefirst)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.ln_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_base)
destroy(this.dw_selected)
destroy(this.u_swap_add)
destroy(this.u_swap_remove)
destroy(this.u_swap_moveup)
destroy(this.u_swap_movedown)
destroy(this.cb_apply)
destroy(this.ln_2)
destroy(this.ln_4)
destroy(this.ln_5)
destroy(this.st_8)
end on

event destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Destroy the instantiated objects.
//	Created by: 
//	History:    1/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_swap_service) Then Destroy in_swap_service
If IsValid(in_rowsmove_service) Then Destroy in_rowsmove_service
If IsValid(in_bag) Then Destroy in_bag
end event

event ue_mouseover;call super::ue_mouseover;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_mouseover
//	Overrides:  No
//	Arguments:	
//	Overview:   Send the event to the swap service and rowsmove service.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

dwobject ldo_null
userobject lu_this
lu_this = This

If IsValid(in_swap_service) Then
	in_swap_service.of_mousemove(lu_this, 0, ldo_null)
end if

If IsValid(in_rowsmove_service) Then 
	in_rowsmove_service.of_mousemove(lu_this, 0, ldo_null)
end if
end event

event ue_getdata;call super::ue_getdata;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_getdata
//	Overrides:  No
//	Arguments:	None	
//	Overview:   Original data retrieval.
//	Created by: Joel White
//	History:    2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_visible_headers, ls_visible_header[], ls_rows, ls_header_list, ls_header_objects
long ll_index, ll_upper
string	ls_row

//n_string_functions ln_string_functions

If IsValid(in_bag) Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the list of all items
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_header_list = in_bag.of_get( 'all items')
	ls_header_objects = in_bag.of_get( 'all objects')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the headers to dw_base.
	//-----------------------------------------------------------------------------------------------------------------------------------		
	This.of_show_fields(ls_header_list, ls_header_objects)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the list of selected items
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_visible_headers = in_bag.of_get( 'selected items')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine which rows in dw_base correspond to the visible headers.
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(ls_visible_headers, ',', ls_visible_header[])
	ll_upper =  UpperBound(ls_visible_header)
	If ll_upper < 1 Then ls_rows = ''
	
	For ll_index = 1 To ll_upper
		gn_globals.in_string_functions.of_replace_all(ls_visible_header[ll_index], '[comma]', ',')
		gn_globals.in_string_functions.of_replace_all(ls_visible_header[ll_index], '[tilda]', '~~')
		gn_globals.in_string_functions.of_replace_all(ls_visible_header[ll_index], '[singlequote]', "'")
		gn_globals.in_string_functions.of_replace_all(ls_visible_header[ll_index], '[doublequote]', '"')
		ls_row = String(dw_base.Find("as_columns ='" + Trim(ls_visible_header[ll_index]) + "'", 1, dw_base.RowCount()))
	
		if long(ls_row) > 0 then
			ls_rows = ls_rows + ls_row + ","
		end if
	
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Publish a message to highlight the visible headers in dw_base.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_message('add item', Left(ls_rows, Len(ls_rows) - 1)	+ '~t0')
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Publish a message to highlight only the first field in dw_selected.
	//-----------------------------------------------------------------------------------------------------------------------------------	
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_message('new destination selections', 1)
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Publish a message to trigger enablement validation on the swap controls.
	//-----------------------------------------------------------------------------------------------------------------------------------		
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_message('destination rows changed', 1)
	End If	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	Disable cb_apply initially.
	//-----------------------------------------------------------------------------------------------------------------------------------		
	cb_apply.Enabled = False
	
End If
end event

type cb_newcolumn from u_commandbutton within u_show_fields_dynamic
integer x = 699
integer y = 768
integer width = 370
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "&New Column..."
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_rowcount

ll_rowcount = dw_selected.RowCount()

If IsValid(idw_data.Dynamic of_get_service('n_datawindow_formatting_service')) Then
	Parent.of_apply()

	in_show_fields.of_reinitialize()
	
	idw_data.Dynamic of_get_service('n_datawindow_formatting_service').Event ue_notify('create column', '')

	Parent.of_init(in_show_fields)
	
	If dw_selected.RowCount() > ll_rowcount Then
		dw_selected.SetRow(dw_selected.RowCount())
		dw_selected.ScrollToRow(dw_selected.RowCount())
	End If
End If


end event

type cb_addcolumn from u_commandbutton within u_show_fields_dynamic
integer x = 699
integer y = 668
integer width = 370
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "A&dd Column..."
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_rowcount

ll_rowcount = dw_selected.RowCount()

If IsValid(idw_data.Dynamic of_get_service('n_datawindow_formatting_service')) Then
	Parent.of_apply()

	in_show_fields.of_reinitialize()
	
	idw_data.Dynamic of_get_service('n_datawindow_formatting_service').Event ue_notify('add external column', '')

	Parent.of_init(in_show_fields)
	
	If dw_selected.RowCount() > ll_rowcount Then
		dw_selected.SetRow(dw_selected.RowCount())
		dw_selected.ScrollToRow(dw_selected.RowCount())
	End If
End If



end event

type u_swap_movelast from u_commandbutton within u_show_fields_dynamic
integer x = 2126
integer y = 984
integer width = 302
integer height = 84
integer taborder = 100
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Move &Last"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_row, ll_row_previous
If IsValid(gn_globals.in_multimedia) Then
	gn_globals.in_multimedia.of_play_sound('start.wav')
	gn_globals.in_multimedia.post of_play_sound('done.wav')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_selected.RowCount() > 0 Then
	ll_row_previous = 0
	ll_row = dw_selected.of_getselectedrow(0)
	
	Do While ll_row_previous <> ll_row And ll_row < dw_selected.RowCount()
		If IsValid(gn_globals.in_subscription_service) Then
			gn_globals.in_subscription_service.of_message('rowsmove requested', 'move item down')
		End If
		ll_row_previous = ll_row
		ll_row = dw_selected.of_getselectedrow(0)
	Loop
End If
end event

type u_swap_movefirst from u_commandbutton within u_show_fields_dynamic
integer x = 1147
integer y = 984
integer width = 306
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "Move &First"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_row, ll_row_previous
If IsValid(gn_globals.in_multimedia) Then
	gn_globals.in_multimedia.of_play_sound('start.wav')
	gn_globals.in_multimedia.post of_play_sound('done.wav')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_selected.RowCount() > 0 Then
	ll_row_previous = 0
	ll_row = dw_selected.of_getselectedrow(0)
	
	Do While ll_row_previous <> ll_row And ll_row > 1
		If IsValid(gn_globals.in_subscription_service) Then
			gn_globals.in_subscription_service.of_message('rowsmove requested', 'move item up')
		End If
		ll_row_previous = ll_row
		ll_row = dw_selected.of_getselectedrow(0)
	Loop
End If
end event

type st_1 from u_statictext within u_show_fields_dynamic
integer x = 46
integer y = 200
integer width = 402
integer height = 60
integer weight = 400
string facename = "Tahoma"
string text = "Available fields:"
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

This.BackColor = gn_globals.in_theme.of_get_backcolor()

end event

type st_3 from u_statictext within u_show_fields_dynamic
integer x = 1093
integer y = 200
integer width = 805
integer height = 60
integer weight = 400
string facename = "Tahoma"
string text = "Show these fields in this order:"
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

This.BackColor = gn_globals.in_theme.of_get_backcolor()

end event

type p_1 from picture within u_show_fields_dynamic
integer x = 37
integer y = 20
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Desk2.bmp"
boolean focusrectangle = false
end type

type st_5 from statictext within u_show_fields_dynamic
integer x = 219
integer y = 32
integer width = 2121
integer height = 112
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "Select the column order, format, and visibility for this report.  ~"Add Column~" will let you add columns from other tables, ~"New Column~" lets you create calculated columns."
boolean focusrectangle = false
end type

type st_4 from statictext within u_show_fields_dynamic
integer width = 2615
integer height = 172
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16777215
boolean enabled = false
boolean focusrectangle = false
end type

type ln_1 from line within u_show_fields_dynamic
long linecolor = 16777215
integer linethickness = 5
integer beginx = -59
integer beginy = 176
integer endx = 3941
integer endy = 176
end type

type cb_cancel from u_commandbutton within u_show_fields_dynamic
integer x = 2149
integer y = 1148
integer width = 325
integer height = 88
integer taborder = 130
integer weight = 400
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   This will apply the changes and close
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Close(Parent.GetParent())
end event

type cb_ok from u_commandbutton within u_show_fields_dynamic
integer x = 1801
integer y = 1148
integer width = 325
integer height = 88
integer taborder = 120
integer weight = 400
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   This will apply the changes and close
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Parent.of_apply()
Close(Parent.GetParent())


end event

type dw_base from u_datawindow within u_show_fields_dynamic
integer x = 46
integer y = 260
integer width = 626
integer height = 708
integer taborder = 10
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
//	Created by: 
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
n_rowfocus_service ln_rowfocus_service

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
		If IsValid(ln_service) Then ln_rowfocus_service = ln_service
		
		If IsValid(ln_rowfocus_service) Then
			ln_rowfocus_service.of_retrieveend()
			
			For ll_index = 1 To ll_upper
				If Len(Trim(ls_select_rows[ll_index])) <= 0 Or ls_select_rows[ll_index] = '' Or IsNull(ls_select_rows[ll_index]) Then Continue
				ln_rowfocus_service.of_highlightrow(Long(ls_select_rows[ll_index]))
			Next
		End If
		
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

type dw_selected from u_datawindow within u_show_fields_dynamic
integer x = 1093
integer y = 260
integer width = 1399
integer height = 708
integer taborder = 60
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
n_rowfocus_service ln_rowfocus_service

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
		If IsValid(ln_service) Then ln_rowfocus_service = ln_service
		
		If IsValid(ln_rowfocus_service) Then
			ln_rowfocus_service.of_retrieveend()
			
			For ll_index = 1 To ll_upper
				If Len(Trim(ls_select_rows[ll_index])) <= 0 Or ls_select_rows[ll_index] = '' Or IsNull(ls_select_rows[ll_index]) Then Continue
				ln_rowfocus_service.of_highlightrow(Long(ls_select_rows[ll_index]))
			Next
		End If
		
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

NonVisualObject ln_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_row, ll_index
string ls_rows, ls_columnobject, ls_columntext, ls_newtext

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

If Not IsValid(dwo) Then Return AncestorReturnValue
If Not Lower(Trim(dwo.Type)) = 'text' Then Return AncestorReturnValue
If IsNull(row) Or row <= 0 Or row > This.RowCount() Then Return AncestorReturnValue


Choose Case Lower(Trim(dwo.Name))
	Case 'button_column', 'button_header'
		ls_columntext = This.GetItemString(row, 'as_columns')
	
		For ll_index = 1 To Min(UpperBound(is_header_array[]), UpperBound(is_object_array[]))
			If Lower(Trim(is_header_array[ll_index])) = Lower(Trim(ls_columntext)) Then
				ls_columnobject 	= is_object_array[ll_index]
				Exit
			End If
		Next
			
		Choose Case Lower(Trim(dwo.Name))
			Case 'button_column'
				If IsValid(idw_data.Dynamic of_get_service('n_datawindow_formatting_service')) Then
					ls_columnobject	= Reverse(ls_columnobject)
					ls_columnobject 	= Reverse(Mid(ls_columnobject, Pos(ls_columnobject, '_') + 1))
					idw_data.Dynamic of_get_service('n_datawindow_formatting_service').Event ue_notify('format response', ls_columnobject)
				End If
			Case 'button_header'
				If IsValid(idw_data.Dynamic of_get_service('n_datawindow_formatting_service')) Then
					idw_data.Dynamic of_get_service('n_datawindow_formatting_service').Event ue_notify('format response', ls_columnobject)
					ls_newtext = idw_data.Describe(ls_columnobject + '.Text')
					If ls_newtext <> ls_columntext Then
						This.SetItem(row, 'as_columns', ls_newtext)
						This.SetItem(row, 'as_originalname', ls_columntext)
					End If
				End If
		End Choose
End Choose
end event

type u_swap_add from u_commandbutton within u_show_fields_dynamic
integer x = 699
integer y = 368
integer width = 370
integer height = 84
integer taborder = 20
integer weight = 400
string facename = "Tahoma"
string text = "&Add >>"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(gn_globals.in_multimedia) Then
	gn_globals.in_multimedia.of_play_sound('start.wav')
	gn_globals.in_multimedia.post of_play_sound('done.wav')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('swap requested - add item', 0)
End If
end event

type u_swap_remove from u_commandbutton within u_show_fields_dynamic
integer x = 699
integer y = 464
integer width = 370
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer weight = 400
string facename = "Tahoma"
string text = "<< &Remove"
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This event will publish a message that a swap was requested.
//	Created by: Denton Newham
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(gn_globals.in_multimedia) Then
	gn_globals.in_multimedia.of_play_sound('start.wav')
	gn_globals.in_multimedia.post of_play_sound('done.wav')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('swap requested - remove item', 0)
End If
end event

type u_swap_moveup from u_commandbutton within u_show_fields_dynamic
integer x = 1477
integer y = 984
integer width = 302
integer height = 84
integer taborder = 80
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

If IsValid(gn_globals.in_multimedia) Then
	gn_globals.in_multimedia.of_play_sound('start.wav')
	gn_globals.in_multimedia.post of_play_sound('done.wav')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('rowsmove requested', 'move item up')
End If
end event

type u_swap_movedown from u_commandbutton within u_show_fields_dynamic
integer x = 1801
integer y = 984
integer width = 302
integer height = 84
integer taborder = 90
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

If IsValid(gn_globals.in_multimedia) Then
	gn_globals.in_multimedia.of_play_sound('start.wav')
	gn_globals.in_multimedia.post of_play_sound('done.wav')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message the a swap was requested.  Pass the type of swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('rowsmove requested', 'move item down')
End If
end event

type cb_apply from u_commandbutton within u_show_fields_dynamic
event ue_notify ( string as_message,  any as_arg )
integer x = 1454
integer y = 1148
integer width = 325
integer height = 88
integer taborder = 110
integer weight = 400
string facename = "Tahoma"
string text = "A&pply"
end type

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   Notification.
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Choose Case Lower(Trim(as_message))
		
	Case	'swap requested - add item', 'swap requested - remove item', 'rowsmove requested'
		This.Enabled = True
		
End Choose
end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   This will apply the changes and close
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Parent.of_apply()

This.Enabled = False

end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      constructor
// Overrides:  No
// Overview:   This will apply the changes and close
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
//	Subscribe to the appropriate messages for being the origin object in a swap.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_subscribe(This, 'swap requested - add item')
	gn_globals.in_subscription_service.of_subscribe(This, 'swap requested - remove item')
	gn_globals.in_subscription_service.of_subscribe(This, 'rowsmove requested')
End If
end event

type ln_2 from line within u_show_fields_dynamic
long linecolor = 8421504
integer linethickness = 1
integer beginx = -59
integer beginy = 172
integer endx = 3941
integer endy = 172
end type

type ln_4 from line within u_show_fields_dynamic
long linecolor = 16777215
integer linethickness = 1
integer beginx = -59
integer beginy = 1116
integer endx = 3941
integer endy = 1116
end type

type ln_5 from line within u_show_fields_dynamic
long linecolor = 8421504
integer linethickness = 1
integer beginx = -59
integer beginy = 1112
integer endx = 3941
integer endy = 1112
end type

type st_8 from statictext within u_show_fields_dynamic
integer y = 1120
integer width = 2505
integer height = 172
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 79416533
boolean enabled = false
boolean focusrectangle = false
end type

