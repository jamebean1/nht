$PBExportHeader$u_datawindow.sru
$PBExportComments$This is the base datawindow.  It has one service that will enable any graphic object that is available in Right Angle.
forward
global type u_datawindow from datawindow
end type
end forward

global type u_datawindow from datawindow
integer width = 494
integer height = 360
integer taborder = 1
boolean livescroll = true
event ue_mousemove pbm_dwnmousemove
event ue_pbmmousemove pbm_mousemove
event ue_dwnkey pbm_dwnkey
event ue_lbuttondown pbm_lbuttondown
event ue_lbuttonup pbm_lbuttonup
event ue_notify ( string as_message,  any aany_argument )
event ue_refreshtheme ( )
event ue_dropdown pbm_dwndropdown
event type string ue_arewereretrieving ( )
event type long ue_rbuttondown ( integer xpos,  integer ypos,  long row,  dwobject dwo,  ref n_menu_dynamic an_menu_dynamic )
event type string ue_areweretrieving ( )
event type string ue_get_sqlpreview ( )
end type
global u_datawindow u_datawindow

type variables
Protected:
	n_datawindow_graphic_service_manager in_datawindow_graphic_service_manager
	Transaction ixctn_transaction

	Boolean	ib_append_data_on_retrieve 		= False
	Boolean	ib_SuppressErrorEvent				= False
	Boolean	ib_SuppressDBErrorEvent				= False
	Boolean	ib_DatawindowHasBeenRetrieved 	= False
	Boolean	ib_WeAreRetrieving					= False
	Boolean	ib_WeAreReretrieving					= False
	String	is_LastSQLPreview
	n_menu_dynamic	in_menu_dynamic_rightclickmenu
	Boolean	AutomaticallyPresentRightClickMenu = False

end variables

forward prototypes
public function window of_getparentwindow ()
public function integer settransobject (transaction t)
public function long insertrow (long r)
public subroutine of_suppresserrorevent (boolean ab_suppress)
public subroutine of_SuppressDBErrorEvent (boolean ab_suppress)
public subroutine of_add_service (string as_servicename)
public function long of_getselectedrow (long row)
public function long of_reretrieve ()
public function NonVisualObject of_get_service (string as_servicename)
public subroutine of_create_services ()
public subroutine of_append (boolean ab_append)
public function boolean of_isappending ()
public function n_datawindow_graphic_service_manager of_get_service_manager ()
public function transaction gettransobject ()
public subroutine of_showmenu (n_menu_dynamic an_menu_dynamic, long xpos, long ypos)
public subroutine of_showmenu (n_menu_dynamic an_menu_dynamic)
end prototypes

event ue_mousemove;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_dwnmousemove
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('pbm_dwnmousemove', xpos, ypos, row, dwo)
End If
end event

event ue_pbmmousemove;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_dwnmousemove
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('pbm_mousemove', flags, xpos, ypos)
End If
end event

event ue_dwnkey;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_dwnkey
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('pbm_dwnkey', key, keyflags)
End If
end event

event ue_lbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_lbuttondown
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('pbm_lbuttondown', flags, xpos, ypos)
End If
end event

event ue_lbuttonup;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_lbuttonup
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('pbm_lbuttonup', flags, xpos, ypos)
End If
end event

event ue_notify(string as_message, any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Window lw_window
//n_string_functions ln_string_functions
//n_recurrence ln_recurrence

Choose Case Lower(Trim(as_message))
	Case 'toggle append data'
		This.of_append(Not This.of_IsAppending())
   Case Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Pass all unknown events to the service manager.  This will allow you to send any event to the service manager to be propogated.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(in_datawindow_graphic_service_manager) Then
			in_datawindow_graphic_service_manager.Event ue_notify(as_message, aany_argument)
		End If
End Choose

end event

event ue_refreshtheme();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_refreshtheme
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('ue_refreshtheme')
End If



end event

event ue_dropdown;If IsValid(in_datawindow_graphic_service_manager) Then
	Return in_datawindow_graphic_service_manager.of_redirect_event('ue_dropdown')
End If

end event

event type string ue_arewereretrieving();If ib_WeAreReretrieving Then
	Return 'Yes'
Else
	Return 'No'
End If
end event

event type string ue_areweretrieving();If ib_WeAreRetrieving Then
	Return 'Yes'
Else
	Return 'No'
End If
end event

event type string ue_get_sqlpreview();Return is_LastSQLPreview
end event

public function window of_getparentwindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_getparentwindow()
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

graphicobject	lgo_parent
window lw_return
lgo_parent = this.getparent()

//----------------------------------------------------------------------------------------------------------------------------------
// Find the ultimate parent window and return it.
//-----------------------------------------------------------------------------------------------------------------------------------
DO WHILE lgo_parent.TypeOf() <> Window!	
	lgo_parent = lgo_parent.GetParent()
LOOP

lw_return = lgo_parent
Return lw_return
end function

public function integer settransobject (transaction t);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	SetTransObject()
//	Arguments:  transaction - The transaction
//	Overview:   Just store the transaction and let the parent happen
//	Created by:	Blake Doerr
//	History: 	2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ixctn_transaction = t
Return Super::SetTransObject(t)
end function

public function long insertrow (long r);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	InsertRow()
//	Arguments:  row
//	Overview:   redirect the events before and after the insertrow
//	Created by:	Blake Doerr
//	History: 	2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_return

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('beforeinsertrow', r)
End If

ll_return = Super::InsertRow(r)

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('afterinsertrow', r)
End If

Return ll_return
end function

public subroutine of_suppresserrorevent (boolean ab_suppress);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SuppressErrorEvent()
//	Arguments:  ab_suppress 	- Whether or not to suppress the event
//	Overview:   This will turn on the suppression of the error event
//	Created by:	Blake Doerr
//	History: 	8/22/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_SuppressErrorEvent = ab_suppress
end subroutine

public subroutine of_SuppressDBErrorEvent (boolean ab_suppress);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_SuppressDBErrorEvent()
//	Arguments:  ab_suppress 	- Whether or not to suppress the event
//	Overview:   This will turn on the suppression of the error event
//	Created by:	Blake Doerr
//	History: 	8/22/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_SuppressDBErrorEvent = ab_suppress
end subroutine

public subroutine of_add_service (string as_servicename);If Not IsValid(in_datawindow_graphic_service_manager) Then
	This.of_get_service_manager()
End If

in_datawindow_graphic_service_manager.of_add_service(as_servicename)
end subroutine

public function long of_getselectedrow (long row);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_getselectedrow()
// Arguments:   row - the row the search will start after
// Overview:    pass this function to the rowfocusservice if it exists.  If it doesn't, call the normal datawindow function
// Created by:  Blake Doerr
// History:     6/23/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

NonVisualObject ln_service

ln_service = This.of_get_service_manager().of_get_service('n_rowfocus_service')

If IsValid(ln_service) Then
	If ln_service.Dynamic of_is_selecting() Then
		Return ln_service.Dynamic of_getselectedrow(row)
	End If
End If

Return This.GetSelectedRow(row)






end function

public function long of_reretrieve ();//Declarations
any lany_temp[], lany_placeholder
String ls_syntax, ls_array[]
Long ll_position, ll_index, ll_return
//n_string_functions ln_string_functions

If Not ib_DatawindowHasBeenRetrieved Then Return -1

//-----------------------------------------------------
// Cut the arguments out of the syntax
//-----------------------------------------------------
ls_syntax = This.Describe("Datawindow.Syntax")
ll_position = Pos(ls_syntax, 'arguments')
ls_syntax = Trim(Mid(ls_syntax, ll_position, Pos(ls_syntax, '))', ll_position) - ll_position))
ls_syntax = Right(ls_syntax, Len(ls_syntax) - 10)

//-----------------------------------------------------------------------------
// Remove all the characters we don't want.  Parse the string into an array.
//-----------------------------------------------------------------------------
gn_globals.in_string_functions.of_replace_all(ls_syntax, ' ', '')
gn_globals.in_string_functions.of_replace_all(ls_syntax, '(', '')
gn_globals.in_string_functions.of_replace_all(ls_syntax, ')', '')
gn_globals.in_string_functions.of_parse_string(ls_syntax, ',', ls_array[])

//-----------------------------------------------------
// Populate the any variable with the correct datatype
//-----------------------------------------------------
For ll_index = 2 To UpperBound(ls_array) step 2
	Choose case Trim(Lower(ls_array[ll_index]))
		Case 'number', 'ulong', 'real', 'long'
			lany_placeholder = Long('0')
		Case 'date'
			lany_placeholder = Today()
		Case 'datetime'
			lany_placeholder = DateTime(Today(), Now())
		Case 'time'
			lany_placeholder = Now()
		Case 'string'
			lany_placeholder = ''
		Case Else
		End Choose			
			
	lany_temp[UpperBound(lany_temp) + 1] = lany_placeholder
Next

//-----------------------------------------------------
// Fill the array up to the 20'th position in the array
//-----------------------------------------------------
For ll_index = UpperBound(lany_temp) + 1 To 30
	lany_temp[ll_index] = lany_placeholder
Next

//-----------------------------------------------------
// Retrieve Datawindow
//-----------------------------------------------------
ib_WeAreReretrieving = True
ll_return = This.Retrieve(lany_temp[1], lany_temp[2], lany_temp[3], lany_temp[4], lany_temp[5], lany_temp[6], lany_temp[7], lany_temp[8], lany_temp[9], lany_temp[10], lany_temp[11], lany_temp[12], lany_temp[13], lany_temp[14], lany_temp[15], lany_temp[16], lany_temp[17], lany_temp[18], lany_temp[19], lany_temp[20], lany_temp[21], lany_temp[22], lany_temp[23], lany_temp[24], lany_temp[25], lany_temp[26], lany_temp[27], lany_temp[28], lany_temp[29], lany_temp[30])
ib_WeAreReretrieving = False

Return ll_return
end function

public function NonVisualObject of_get_service (string as_servicename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_service()
//	Overview:   Return the service from the manager
//	Created by:	Blake Doerr
//	History: 	8/25/01 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_get_service_manager()

Return in_datawindow_graphic_service_manager.of_get_service(as_servicename)
end function

public subroutine of_create_services ();If Not IsValid(in_datawindow_graphic_service_manager) Then Return

in_datawindow_graphic_service_manager.of_create_services()
end subroutine

public subroutine of_append (boolean ab_append);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_append()
//	Arguments:  ab_append - Append the data
//	Overview:   Set the flag to append the data rather than resetting the data
//	Created by:	Blake Doerr
//	History: 	8/18/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_append_data_on_retrieve = ab_append
end subroutine

public function boolean of_isappending ();Return ib_append_data_on_retrieve
end function

public function n_datawindow_graphic_service_manager of_get_service_manager ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_service_manager()
//	Overview:   Return the service manager
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Datawindow ldw_datawindow
ldw_datawindow = This

If Not IsValid(in_datawindow_graphic_service_manager) Then
	ldw_datawindow = This
	in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager
	in_datawindow_graphic_service_manager.of_init(ldw_datawindow)
End If

Return in_datawindow_graphic_service_manager
end function

public function transaction gettransobject ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	GetTransObject()
//	Returns:  	transaction - The transaction
//	Overview:   Just store the transaction and let the parent happen
//	Created by:	Blake Doerr
//	History: 	2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ixctn_transaction
end function

public subroutine of_showmenu (n_menu_dynamic an_menu_dynamic, long xpos, long ypos);m_dynamic lm_dynamic

//----------------------------------------------------------------------------------------------------------------------------------
// Return if the menu does not have anything
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not UpperBound(an_menu_dynamic.Item[]) > 0 Then
	Destroy an_menu_dynamic
	Return
End If

lm_dynamic = Create m_dynamic
lm_dynamic.of_set_menuobject(an_menu_dynamic)

Destroy an_menu_dynamic

//----------------------------------------------------------------------------------------------------------------------------------
// Pop the menu differently based on the window type
//-----------------------------------------------------------------------------------------------------------------------------------
lm_dynamic.popmenu(xpos, ypos)
	
//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the menu
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lm_dynamic

end subroutine

public subroutine of_showmenu (n_menu_dynamic an_menu_dynamic);//----------------------------------------------------------------------------------------------------------------------------------
// Pop the menu differently based on the window type
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_getparentwindow().windowtype = Response! Or This.of_getparentwindow().windowtype = Popup! Or Not isvalid(w_mdi.getactivesheet()) Or (w_mdi.getactivesheet() <> This.of_getparentwindow()) then
	This.of_showmenu(an_menu_dynamic, This.of_getparentwindow().PointerX(), This.of_getparentwindow().PointerY())
Else
	This.of_showmenu(an_menu_dynamic, w_mdi.pointerx(), w_mdi.pointery())
End If
end subroutine

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Create the graphic service manager
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_get_service_manager()

in_datawindow_graphic_service_manager.of_add_Service('n_datawindow_tooltp_display_column_text')
in_datawindow_graphic_service_manager.of_redirect_event('constructor')
end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Destroy the graphic service manager
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('destructor')
	Destroy in_datawindow_graphic_service_manager
End If
end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Boolean	lb_processclickedevent = True
n_menu_dynamic ln_menu_dynamic

If AutomaticallyPresentRightClickMenu Then
	If IsValid(dwo) Then
		If Lower(Trim(dwo.Type)) = 'text' Then
			If Lower(Trim(dwo.Name)) = 'report_title' Then
				lb_processclickedevent = False
			
				//-----------------------------------------------------------------------------------------------------------------------------------
				// To get the X position you just need to subtract the Datawindow EditMask's X and subtract if from the Datawindow.PointerX
				//		This gives you the Delta X from the object to the pointer.  Now you just have to subtract that from w_mdi.PointerX
				//-----------------------------------------------------------------------------------------------------------------------------------
				xpos 	= This.of_GetParentWindow().PointerX() - (This.PointerX() - Long(This.Describe(dwo.Name + ".X")))
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Y is exactly the same it is just a little more involved to find the Datawindow EditMask's Y.
				//-----------------------------------------------------------------------------------------------------------------------------------
				ypos	= Long(This.Describe(dwo.Name + ".Y")) + 50
				ypos 	= w_mdi.PointerY() - (This.PointerY() - ypos) + 5
	
				If IsValid(in_datawindow_graphic_service_manager) Then
					ln_menu_dynamic = Create n_menu_dynamic
					ln_menu_dynamic.of_set_text('Report Options')
					in_datawindow_graphic_service_manager.of_redirect_event('rbuttondown', xpos, ypos, row, dwo, ln_menu_dynamic)
					
					This.Event ue_rbuttondown(xpos, ypos, row, dwo, ln_menu_dynamic)
					
					This.of_showmenu(ln_menu_dynamic, xpos, ypos)
				End If
			End If
		End If
	End If
End If

If IsValid(in_datawindow_graphic_service_manager) And lb_processclickedevent Then
	in_datawindow_graphic_service_manager.of_redirect_event('clicked', xpos, ypos, row, dwo, ln_menu_dynamic)
End If

end event

event doubleclicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DoubleClicked
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('doubleclicked', xpos, ypos, row, dwo)
End If
end event

event itemchanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      itemchanged
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return

If IsValid(in_datawindow_graphic_service_manager) Then
	ll_return = in_datawindow_graphic_service_manager.of_redirect_event('itemchanged', row, dwo, data)
	
	If Not IsNull(ll_return) Then
		Return ll_return
	End If
End If
end event

event itemerror;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ItemError
//	Overrides:  No
//	Arguments:	
//	Overview:   We don't ever want to show a popup message from a datawindow
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// this is to avoid itemchanged validation from poping up a messagebocx.
//-----------------------------------------------------------------------------------------------------------------------------------
return 2
end event

event losefocus;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      LoseFocus
//	Overrides:  No
//	Arguments:	
//	Overview:   This ensures that the accepttext is triggered before the user clicks save or goes to another dw.
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// This ensures that the accepttext is triggered before the user clicks save or goes to another dw.
//-----------------------------------------------------------------------------------------------------------------------------------
this.accepttext()
end event

event retrieveend;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Retrieveend
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_WeAreRetrieving = True

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('retrieveend', rowcount)
End If

ib_WeAreRetrieving = False
end event

event retrievestart;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      RetrieveStart
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return

ib_WeAreRetrieving = True

If IsValid(in_datawindow_graphic_service_manager) Then
	ll_return = in_datawindow_graphic_service_manager.of_redirect_event('retrievestart')
	
	If Not IsNull(ll_return) Then
		If ll_return = 1 Then ib_WeAreRetrieving = False
		Return ll_return
	End If
End If

If ib_append_data_on_retrieve Then
	Return 2
End If
end event

event rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      RowFocusChanged
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('rowfocuschanged', currentrow)
End If
end event

event scrollhorizontal;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      scrollhorizontal
// Overrides:  No
// Overview:   Reset the positions of the filter objects as the datawindow scrolls horizontally
// Created by: Blake Doerr
// History:    12/16/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('scrollhorizontal', scrollpos, pane)
End If
end event

event dragleave;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragLeave
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('dragleave', source)
End If
end event

event dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragDrop
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('dragdrop', source, row, dwo)
End If
end event

event dragenter;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragEnter
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('dragenter', source)
End If
end event

event dragwithin;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragWithin
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('dragwithin', source, row, dwo)
End If
end event

event rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      rbuttondown
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_menu_dynamic ln_menu_dynamic

If AutomaticallyPresentRightClickMenu Then
	ln_menu_dynamic = Create n_menu_dynamic
	ln_menu_dynamic.of_set_text('Report Options')
End If

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('rbuttondown', xpos, ypos, row, dwo, ln_menu_dynamic)
End If

If AutomaticallyPresentRightClickMenu Then
	This.Event ue_rbuttondown(xpos, ypos, row, dwo, ln_menu_dynamic)
	This.of_showmenu(ln_menu_dynamic)
End If
end event

event sqlpreview;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      sqlpreview
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_return

If ib_WeAreReretrieving Then 
	This.SetSQLPreview(is_LastSQLPreview)
	sqlsyntax = is_LastSQLPreview
End If

If IsValid(in_datawindow_graphic_service_manager) Then
	ll_return = in_datawindow_graphic_service_manager.of_redirect_event('sqlpreview', request, sqltype, sqlsyntax, buffer, row)
	
	If ll_return = 99 Then
		This.SetSQLPreview(sqlsyntax)
		SetNull(ll_return)
	End If
	
	If Not IsNull(ll_return) Then
		Return ll_return
	End If
End If

If request = PreviewFunctionRetrieve! Then
	is_LastSQLPreview = sqlsyntax
	
	If Not ib_WeAreReretrieving Then
		ib_DatawindowHasBeenRetrieved = True
	End If
End If
end event

event editchanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      editchanged
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    5/09/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return

If IsValid(in_datawindow_graphic_service_manager) Then
	ll_return = in_datawindow_graphic_service_manager.of_redirect_event('editchanged', row, dwo, data)
	
	If Not IsNull(ll_return) Then
		Return ll_return
	End If
End If

Return 0
end event

on u_datawindow.create
end on

on u_datawindow.destroy
end on

event printstart;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      PrintStart
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('printstart', pagesmax)
End If
end event

event printend;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      PrintEnd
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('printend', pagesprinted)
End If
end event

event dberror;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DBError
//	Overrides:  No
//	Arguments:	
//	Overview:   
//	Created by: Blake Doerr
//	History:    8/22/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If ib_SuppressDBErrorEvent Then
	Return 1
End If
	
end event

event error;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Error
//	Overrides:  No
//	Arguments:	
//	Overview:   
//	Created by: Blake Doerr
//	History:    8/22/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If ib_SuppressErrorEvent Then
	Action = ExceptionIgnore!
End If
	
end event

event itemfocuschanged;this.post selecttext(1,9999999)
end event

