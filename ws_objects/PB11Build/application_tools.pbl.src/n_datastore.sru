$PBExportHeader$n_datastore.sru
forward
global type n_datastore from datastore
end type
end forward

global type n_datastore from datastore
event type long dragdrop ( dragobject source,  long row,  dwobject dwo )
event type string ue_arewereretrieving ( )
event ue_notify ( string as_message,  any aany_argument )
end type
global n_datastore n_datastore

type variables
Protected:
	n_datawindow_graphic_service_manager in_datawindow_graphic_service_manager
	Transaction ixctn_transaction
	Boolean ib_append_data_on_retrieve 	= False
	Boolean	ib_DatawindowHasBeenRetrieved 	= False
	Boolean	ib_WeAreReretrieving					= False
	String	is_LastSQLPreview

end variables

forward prototypes
public function long insertrow (long r)
public function integer settransobject (transaction t)
public subroutine of_add_service (string as_servicename)
public subroutine of_append (boolean ab_append)
public subroutine of_create_services ()
public function nonvisualobject of_get_service (string as_servicename)
public function n_datawindow_graphic_service_manager of_get_service_manager ()
public function long of_getselectedrow (long row)
public function boolean of_isappending ()
public function long of_reretrieve ()
public function transaction gettransobject ()
end prototypes

event type long dragdrop(dragobject source, long row, dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
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

Return 0
end event

event type string ue_arewereretrieving();If ib_WeAreReretrieving Then
	Return 'Yes'
Else
	Return 'No'
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

public subroutine of_add_service (string as_servicename);If Not IsValid(in_datawindow_graphic_service_manager) Then
	This.of_get_service_manager()
End If

in_datawindow_graphic_service_manager.of_add_service(as_servicename)
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

public subroutine of_create_services ();If Not IsValid(in_datawindow_graphic_service_manager) Then Return

in_datawindow_graphic_service_manager.of_create_services()
end subroutine

public function nonvisualobject of_get_service (string as_servicename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_service()
//	Overview:   Return the service from the manager
//	Created by:	Blake Doerr
//	History: 	8/25/01 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_get_service_manager()

Return in_datawindow_graphic_service_manager.of_get_service(as_servicename)
end function

public function n_datawindow_graphic_service_manager of_get_service_manager ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_service_manager()
//	Overview:   Return the service manager
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_datastore
lds_datastore = This

If Not IsValid(in_datawindow_graphic_service_manager) Then
	lds_datastore = This
	in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager
	in_datawindow_graphic_service_manager.of_init(lds_datastore)
End If

Return in_datawindow_graphic_service_manager
end function

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

public function boolean of_isappending ();Return ib_append_data_on_retrieve
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

public function transaction gettransobject ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	GetTransObject()
//	Returns:  	transaction - The transaction
//	Overview:   Just store the transaction and let the parent happen
//	Created by:	Blake Doerr
//	History: 	2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ixctn_transaction
end function

on n_datastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Create the graphic service manager
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_get_service_manager()

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

event retrieveend;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Retrieveend
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the event just in case some service want to respond
//	Created by: Blake Doerr
//	History:    2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(in_datawindow_graphic_service_manager) Then
	in_datawindow_graphic_service_manager.of_redirect_event('retrieveend', rowcount)
End If
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

If IsValid(in_datawindow_graphic_service_manager) Then
	ll_return = in_datawindow_graphic_service_manager.of_redirect_event('retrievestart')
	
	If Not IsNull(ll_return) Then
		Return ll_return
	End If
End If

If ib_append_data_on_retrieve Then
	Return 2
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

