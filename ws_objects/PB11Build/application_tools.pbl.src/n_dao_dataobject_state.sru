$PBExportHeader$n_dao_dataobject_state.sru
$PBExportComments$Datawindow Service - This is the dataobject state service.  It allows you to save all the properties of a datawindow to the database and restore them at will.
forward
global type n_dao_dataobject_state from nonvisualobject
end type
end forward

global type n_dao_dataobject_state from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_dao_dataobject_state n_dao_dataobject_state

type variables
Protected:
	PowerObject idw_data
	Transaction ixctn_transaction
	
	String 	is_originalsyntax
	String	is_newsyntax
	String	is_current_view
	String	is_current_isglobal
	String	is_current_isdefault
	String	is_current_parameters
	String	is_current_allownavigation
	String	is_current_autoretrieve
	
	String	is_current_identifier
	
	String	is_OldOriginalSyntax
	String	is_OldViewSyntax
	Boolean 	ib_enabled = False
	Boolean 	ib_hassubscribed = False
	Boolean	ib_AViewHasBeenAppliedThatIsNotValid = False
	Boolean	ib_datawindow_syntax_has_been_initially_verified = False
	Boolean	ib_WeAreInInitializationMode	= False
	Boolean	ib_WeAreInBatchMode	= False
	Boolean	ib_AllowReretrieve	= True
	String	is_OriginalEntityName
	Long		il_current_view
	Long 		il_user_id
	String	is_current_entity
	String	is_original_entity
	Long		il_current_entityid

end variables

forward prototypes
public subroutine of_settransactionobject (transaction axctn_transaction)
protected subroutine of_apply_syntax (string as_syntax)
public subroutine of_autoretrieve ()
protected function string of_export_public ()
public function string of_get_current_view ()
public function long of_get_current_view_id ()
public function string of_get_dataobjectname ()
public function powerobject of_get_datawindow ()
public function string of_get_syntax ()
public function long of_get_userid ()
protected function string of_import_public ()
protected subroutine of_import_view ()
public subroutine of_import_view (string as_view_syntax)
public subroutine of_init (powerobject adw_data, long al_userid)
public subroutine of_init (powerobject adw_data, long al_userid, string as_dataobject)
public subroutine of_recreate_view ()
public subroutine of_restore ()
public subroutine of_set_batchmode (boolean ab_batchmode)
public subroutine of_set_original_entity (string as_original_entity)
public function string of_apply_view (long al_dataobjectstate_idnty)
protected subroutine of_export_view ()
public subroutine of_apply_default ()
public function long of_get_default_view ()
public subroutine of_get_views (ref long al_idnty[], ref string as_views[], ref boolean ab_isglobal[], ref boolean ab_iscreatedbythisuser[])
public function long of_save_view ()
public function long of_save_view (string as_viewname, string as_isdefault, string as_isglobal, long al_entityid, string as_entityname, string as_allownavigation, string as_autoretrieve, string as_savefilters, string as_saveuomcurrency, string as_savecriteria, string as_savenestedreport, boolean ab_savecurrentviews)
public function string of_apply_view (string as_viewname)
protected subroutine of_apply_current_view ()
public function string of_get_parameters (boolean ab_savefilter, boolean ab_saveuomcurrency, boolean ab_savecriteria, boolean ab_savednestedreport, boolean ab_saveovercurrentviews, string as_defaultsavename)
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public function long of_save_view (string as_viewname, string as_isdefault, string as_isglobal, string as_parameters, long al_entityid, string as_entityname, string as_allownavigation, string as_autoretrieve)
end prototypes

event ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This will catch messages from the publish/subscribe service
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_reportconfigid
Datawindow ldw_datawindow
Window lw_window
n_bag ln_bag

Choose Case Lower(as_message)
	Case 'restore view'
		This.of_restore()
	Case 'save view'
		This.of_save_view()
	Case 'apply view'
		If Pos(String(as_arg), '=') > 0 Then
			as_arg = Mid(String(as_arg), Pos(String(as_arg), '=') + 1)
		End If
		
		If il_current_view <> Long(as_arg) Then This.of_apply_view(Long(as_arg))
	Case 'apply view id'
		If il_current_view <> Long(as_arg) Then This.of_apply_view(Long(as_arg))
	Case 'graphic services created'
		This.of_recreate_view()
	Case 'import view'
		This.of_import_view()
	Case 'import public view'
		This.of_import_public()
	Case 'export view public'
		This.of_export_public()
	Case 'export view'
		This.of_export_view()
	Case 'manage views'
		ln_bag = Create n_bag
		ll_reportconfigid = Long(idw_data.Event Dynamic ue_get_rprtcnfgid())
		If ll_reportconfigid > 0 And Not IsNull(ll_reportconfigid) Then
			ln_bag.of_set('RprtCnfgID', ll_reportconfigid)
		End If
		
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_datawindow = idw_data
				ln_bag.of_set('displaydataobjectname', ldw_datawindow.dataobject)  //Chris Cole 01/06/2003
		End Choose
	
		ln_bag.of_set('type', 'datawindow')
				
		OpenWithParm(lw_window, ln_bag, 'w_reportconfig_manage_views', w_mdi)
End Choose
end event

public subroutine of_settransactionobject (transaction axctn_transaction);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_settransactionobject()
// Arguments:   axctn_transaction - The transaction object for the datawindow target
// Overview:    DocumentScriptFunctionality
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

ixctn_transaction = axctn_transaction

end subroutine

protected subroutine of_apply_syntax (string as_syntax);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_apply_syntax()
// Overview:    This will apply the passed in syntax to the datawindow
// Created by:  Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
datastore lds_datastore
Long 		ll_rowcount
Long		ll_zoom
String	ls_old_expression
String	ls_new_expression
String	ls_error_create, ls_return, ls_expression
n_datawindow_tools ln_datawindow_tools

SetPointer(HourGlass!)

ll_rowcount			= idw_data.Dynamic RowCount()

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message before the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('Before View Restored', idw_data, idw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Use the datawindow tools to apply the new syntax without modifying the attributes of the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_old_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')
Choose Case idw_data.TypeOf()
	Case Datawindow!
		idw_data.Dynamic SetRedraw(False)
End Choose

ls_return = ln_datawindow_tools.of_apply_syntax(idw_data, as_syntax)
If IsValid(idw_data.Dynamic GetTransObject()) Then idw_data.Dynamic SetTransObject(idw_data.Dynamic GetTransObject())

Choose Case idw_data.TypeOf()
	Case Datawindow!
		idw_data.Dynamic SetRedraw(True)
End Choose


ls_new_expression = ln_datawindow_tools.of_get_expression(idw_data, 'AdditionalColumnsInit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message after the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
End If

If IsNull(ls_new_expression) Then ls_new_expression = ''
If IsNull(ls_old_expression) Then ls_old_expression = ''

If ls_new_expression <> ls_old_expression And ll_rowcount > 0 And ib_AllowReretrieve Then
	idw_data.Dynamic of_reretrieve()
End If

ls_expression = ln_datawindow_tools.of_get_expression(idw_data, "dataobjectstateinit")
If Pos(ls_expression, '=') > 0 Then
	ll_zoom = Long(Mid(ls_expression, Pos(ls_expression, '=') + 1))
	If Not IsNull(ll_zoom) And ll_zoom >= 0 Then
		idw_data.Dynamic Modify("Datawindow.Zoom='" + String(ll_zoom) + "'")
	End If
End If

Destroy ln_datawindow_tools
end subroutine

public subroutine of_autoretrieve ();PowerObject lo_parent
If Upper(Trim(is_current_autoretrieve)) = 'Y' Then
	If IsValid(idw_data) Then
		lo_parent = idw_data.GetParent()
		If IsValid(lo_parent) Then
			lo_parent.Event Dynamic ue_retrieve()
		End If
	End If
End If
end subroutine

protected function string of_export_public ();//n_string_functions	ln_string_functions
Datastore				lds_data
Datawindow				ldw_data
String					ls_filename
String					ls_description
String					ls_pathname
String					ls_data
String					ls_return
Blob						lblob_xml_document


ls_description = idw_data.Dynamic Describe("report_title.Text")

If ls_description = '?' or ls_description = '!' Then ls_description = 'Exported Report View'

gn_globals.in_string_functions.of_replace_all(ls_description, '/', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '\', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, ':', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '*', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '|', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '>', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '<', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '?', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '$', '-')

ls_pathname 			= ls_pathname + Trim(ls_description) + '.ReportView.RAIV'
ls_data 					= This.of_get_syntax()
lblob_xml_document 	= Blob(ls_data)


//If FileExists(ls_pathname) Then
//	If gn_globals.in_messagebox.of_messagebox_question ('This file already exists at this location, would you like to overwrite it', YesNoCancel!, 3) <> 1 Then Return
//End If
//

Return ''
end function

public function string of_get_current_view ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_current_view()
//	Overview:   Return the current view
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_current_view
end function

public function long of_get_current_view_id ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_current_view()
//	Overview:   Return the current view
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_current_view
end function

public function string of_get_dataobjectname ();Return is_current_identifier
end function

public function powerobject of_get_datawindow ();Return idw_data
end function

public function string of_get_syntax ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_syntax()
//	Overview:   This will return the syntax to save
//	Created by:	Joel White
//	History: 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_syntax

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message before the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('Before View Saved', '', idw_data)
End If

//------------------------------------------------------------------------------------
// Get the new syntax
//------------------------------------------------------------------------------------
ls_syntax = idw_data.Dynamic Describe("Datawindow.Syntax")

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message after the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('After View Restored', idw_data, idw_data)
End If

Return ls_syntax
end function

public function long of_get_userid ();Return il_user_id
end function

protected function string of_import_public ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_update()
// Overview:    Save the syntax and the sort to the database
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
// Local Variables
//------------------------------------------------------------------------------------
String	ls_viewname
String	ls_syntax

//------------------------------------------------------------------------------------
// Local Objects
//------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
NonVisualObject ln_nonvisual_window_opener
n_bag ln_bag
Datastore				lds_data
Datawindow				ldw_data
String					ls_filename
Any	lany_file
Blob	lblob_file

//------------------------------------------------------------------------------------
// Return if the object is not enabled
//------------------------------------------------------------------------------------
If Not ib_enabled Then Return 'Error:  This object is not enabled'

Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ls_filename = 'Report Views/' + ldw_data.DataObject
	Case Datastore!
		lds_data = idw_data
		ls_filename = 'Report Views/' + lds_data.DataObject
End Choose

ln_bag = Create n_bag
ln_bag.of_set('path', ls_filename)
ln_bag.of_set('bitmap', 'Module - Reporting Desktop - Datawindow View (Global).bmp')
ln_bag.of_set('window title', 'Download Public Report View')
ln_bag.of_set('window description', 'Select a public view to import.  You will need to save the view after downloading it.')
ln_bag.of_set('button text', 'Import')

//------------------------------------------------------------------------------------
// Open the window to name the view
//------------------------------------------------------------------------------------
ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_import_file_from_ftp', ln_bag)
Destroy ln_nonvisual_window_opener

//------------------------------------------------------------------------------------
// Get the message and see if it's valid
//------------------------------------------------------------------------------------
If Len(Trim((Message.StringParm))) > 0 Then
	Destroy ln_bag
	Return Message.StringParm
End If
If Not IsValid(ln_bag) Then Return 'Error:  Nothing came back'

ls_viewname = String(ln_bag.of_get('File Name'))
If ln_bag.of_exists('File Blob') Then
	lany_file	= ln_bag.of_get('File Blob')
	lblob_file	= lany_file
	ls_syntax	= String(lblob_file)
Else
	Return 'Error:  Nothing came back'
End If

This.of_import_view(ls_syntax)

Destroy ln_bag

Return ''
end function

protected subroutine of_import_view ();NonVisualObject ln_common_dialog
n_blob_manipulator ln_blob_manipulator
Long	ll_return
String	ls_pathname
String	ls_filename 
String	ls_data
Blob		lblob_xml_document

ln_common_dialog = Create Using 'n_common_dialog'
ll_return = ln_common_dialog.Dynamic of_GetFileOpenName('Available Report View Files', ls_pathname, ls_filename ,'RAIV', "CustomerFocus Files (*.RAIV),*.RAIV")
Destroy ln_common_dialog

if ll_return <= 0 Then Return
If len(ls_pathname) <= 0  Then Return
If Not FileExists (ls_pathname) Then Return

ln_blob_manipulator = Create n_blob_manipulator
lblob_xml_document = ln_blob_manipulator.of_build_blob_from_file(ls_pathname)
Destroy ln_blob_manipulator

ls_data = String(lblob_xml_document)

This.of_import_view(ls_data)
end subroutine

public subroutine of_import_view (string as_view_syntax);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_import_view()
//	Arguments:  as_viewname 	- The name of the view
//	Overview:   This will apply the view passed in
//	Created by:	Joel White
//	History: 	 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------
Long		ll_return
Long		ll_index
Long		ll_row
String	ls_old_original_syntax
String	ls_datawindow_data
String	ls_original_sort
String	ls_error_create
String	ls_current_view
String	ls_return
String	ls_previous_entity

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator
//n_string_functions ln_string_functions

//----------------------------------------------------------------------------------
// If this isn't enabled, return
//----------------------------------------------------------------------------------
If Not ib_enabled Then Return
If ib_WeAreInBatchMode Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Pop up a messagebox that asks a question
//-----------------------------------------------------------------------------------------------------------------------------------
If gn_globals.in_messagebox.of_messagebox_question ('This imported view will be created as closely as possible, it is possible that all elements of the view will not be applied', OKCancel!, 1) = 2 Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Make sure that we restore the original view
//-----------------------------------------------------------------------------------------------------------------------------------
ib_AllowReretrieve = False
This.of_restore()
ib_AllowReretrieve = True

ib_AViewHasBeenAppliedThatIsNotValid	= True
is_OldOriginalSyntax 						= is_originalsyntax
is_OldViewSyntax								= as_view_syntax
is_current_view 			= ''
is_current_isdefault 	= ''
is_current_isglobal 		= ''
is_current_parameters	= ''
il_current_view			= 0

This.Event ue_notify('Graphic Services Created', '')

ib_AViewHasBeenAppliedThatIsNotValid = False

If is_current_entity <> is_original_entity Then
	gn_globals.in_subscription_service.of_message('set report entity', is_original_entity, idw_data)
End If
end subroutine

public subroutine of_init (powerobject adw_data, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data - the datawindow
//					 al_user - the user id
// Overview:    Initialize the object
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

long			ll_rprtcnfgid
Datawindow	ldw_datawindow
Datastore	lds_datastore

If Not IsValid(adw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// See if we can find a Report Configuration ID.  If so, use it as the name
// with which to associate the views of the datawindow.
//
// If we don't find a RprtCnfgID, fallback to using the dataobject name.
//-----------------------------------------------------------------------------------------------------------------------------------

ll_rprtcnfgid = long(adw_data.event dynamic ue_get_rprtcnfgid())

if ll_rprtcnfgid <> 0 then
	is_current_identifier = 'RprtCnfgID=' + string(ll_rprtcnfgid)
	This.of_init(adw_data, al_userid, is_current_identifier)
Else
	Choose Case adw_data.TypeOf()
		Case Datawindow!
			ldw_datawindow = adw_data
			is_current_identifier = ldw_datawindow.DataObject
		Case Datastore!
			lds_datastore = adw_data
			is_current_identifier = lds_datastore.DataObject
	End Choose
	
	This.of_init(adw_data, al_userid, is_current_identifier)
End If

end subroutine

public subroutine of_init (powerobject adw_data, long al_userid, string as_dataobject);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data - the datawindow
//					 al_user - the user id
//					 as_dataobject_alias - the name that will uniquely identify the datawindow
// Overview:    Initialize the object
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(adw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set some instance variables
//-----------------------------------------------------------------------------------------------------------------------------------
is_current_identifier	= as_dataobject
idw_data 					= adw_data
il_user_id 					= al_userid

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the syntax from the current datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
is_originalsyntax = idw_data.Dynamic Describe("DataWindow.Syntax")

//-----------------------------------------------------------------------------------------------------------------------------------
// If the syntax is valid, retrieve and apply the default view
//-----------------------------------------------------------------------------------------------------------------------------------
If is_originalsyntax = '!' Or is_originalsyntax = '?' Or Len(Trim(is_originalsyntax)) = 0 Or IsNull(is_current_identifier) Or Trim(is_current_identifier) = '' Then
	ib_enabled = False
Else
	ib_enabled = True
	ib_WeAreInInitializationMode = True
	This.of_apply_default()
	ib_WeAreInInitializationMode = False
End If

//-----------------------------------------------------
// Subscribe to the messages that affect this object
//-----------------------------------------------------
If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_subscribe(This, 'Restore View', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Apply View', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Apply View ID', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Graphic Services Created', idw_data)
	End If
End If

end subroutine

public subroutine of_recreate_view ();n_bag ln_bag
Any	lany_any
Datastore lds_ViewDatawindow
String	ls_expression
n_datawindow_tools ln_datawindow_tools

If Not ib_AViewHasBeenAppliedThatIsNotValid Then Return

SetPointer(Hourglass!)
ln_bag = Create n_bag

ln_bag.of_set('Original Syntax', is_OldOriginalSyntax)
ln_bag.of_set('View Syntax',		is_OldViewSyntax)
ln_bag.of_set('New Syntax', 		is_originalsyntax)


//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the syntaxes are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(is_OldViewSyntax)) <> 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create two datastores
	//-----------------------------------------------------------------------------------------------------------------------------------
	lds_ViewDatawindow		= Create Datastore

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Apply the syntaxes to the datastores
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_datawindow_tools = Create n_datawindow_tools
	ln_datawindow_tools.of_apply_syntax(lds_ViewDatawindow, is_OldViewSyntax)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the init column
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_expression = ln_datawindow_tools.of_get_expression(lds_ViewDatawindow, 'DistributionOptionsInit')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the external columns that need to be added
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ls_expression <> '' And Not IsNull(ls_expression) And ls_expression <> '?' And ls_expression <> '!' Then
		ln_datawindow_tools.of_set_expression(idw_data, 'DistributionOptionsInit', ls_expression)
	End If
	
	Destroy ln_datawindow_tools
	Destroy lds_ViewDatawindow
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message before the restore happens so that other services can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	lany_any = ln_bag
	Message.PowerObjectParm = ln_bag
	gn_globals.in_subscription_service.of_message('Before Recreate View', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Formatting', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Column Selection', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Group By', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Formatting 2', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Column Sizing', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Aggregation', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Sort', '', idw_data)
	gn_globals.in_subscription_service.of_message('Recreate View - Row Focus', '', idw_data)
	gn_globals.in_subscription_service.of_message('After Recreate View', '', idw_data)
End If

If is_current_view <> '' Then
	This.of_save_view(is_current_view, is_current_isdefault, is_current_isglobal, is_current_parameters, -1, is_current_entity, is_current_allownavigation, is_current_autoretrieve)
End If

Destroy ln_bag
end subroutine

public subroutine of_restore ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_restore()
// Overview:    Restore the original syntax
// Created by:  Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
String	ls_previous_entity

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the original syntax
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_apply_syntax(is_originalsyntax)

If is_current_entity <> '' Then
	gn_globals.in_subscription_service.of_message('set report entity', is_original_entity, idw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Update the datastore and set the current view to empty string
//-----------------------------------------------------------------------------------------------------------------------------------
is_current_view 				= ''
is_current_isglobal 			= ''
is_current_isdefault 		= ''
is_current_parameters 		= ''
is_current_entity				= ''
is_current_allownavigation	= ''
is_current_autoretrieve		= ''
il_current_view				= 0
end subroutine

public subroutine of_set_batchmode (boolean ab_batchmode);ib_weareinbatchmode = ab_batchmode
end subroutine

public subroutine of_set_original_entity (string as_original_entity);is_original_entity = as_original_entity
end subroutine

public function string of_apply_view (long al_dataobjectstate_idnty);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_view()
//	Arguments:  as_viewname 	- The name of the view
//	Overview:   This will apply the view passed in
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------
Long		ll_return
Long		ll_index
Long		ll_row
String	ls_old_original_syntax
String	ls_datawindow_data
String	ls_original_sort
String	ls_error_create
String	ls_current_view
String	ls_return
String	ls_previous_entity
Boolean	lb_DatastoreIsReference = True

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
n_blob_manipulator ln_blob_manipulator
//n_string_functions ln_string_functions
Datastore lds_datastore

If al_dataobjectstate_idnty <= 0 Or IsNull(al_dataobjectstate_idnty) Then Return 'Error:  The view id was not valid'

lds_datastore = gn_globals.in_cache.of_get_cache_reference('ReportView')
If Not IsValid(lds_datastore) Then Return 'Error:  Could not get report views from the cache object'

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the view that we are trying to apply
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = lds_datastore.Find('Idnty = ' + String(al_dataobjectstate_idnty), 1, lds_datastore.RowCount())

If ll_row <= 0 Or IsNull(ll_row) Then
	lb_DatastoreIsReference	= True
	lds_datastore = Create Datastore
	lds_datastore.DataObject = 'd_dataobject_state_cache'
	lds_datastore.SetTransObject(SQLCA)
	
	If lds_datastore.Retrieve(al_dataobjectstate_idnty, 0, 'All') <> 1 Then
		Destroy lds_datastore
		Return 'Error:  The report view does not exist in the database'
	End If
	ll_row = 1
End If

//----------------------------------------------------------------------------------
// Create the blob manipulator
//----------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------
// Get the original syntax blob id for this datawindow
//----------------------------------------------------------------------------------
ll_return 			= lds_datastore.GetItemNumber(ll_row, 'OriginalSyntaxBlobID')
il_current_view	= lds_datastore.GetItemNumber(ll_row, 'Idnty')

//----------------------------------------------------------------------------------
// Convert the syntax to a string
//----------------------------------------------------------------------------------
ls_old_original_syntax 	= String(ln_blob_manipulator.of_retrieve_blob(ll_return))

//----------------------------------------------------------------------------------
// Set the current view properties
//----------------------------------------------------------------------------------
is_current_view			= lds_datastore.GetItemString(ll_row, 'Name')
is_current_isdefault		= lds_datastore.GetItemString(ll_row, 'IsDefault')
is_current_parameters	= lds_datastore.GetItemString(ll_row, 'Parameters')
is_current_allownavigation	= lds_datastore.GetItemString(ll_row, 'IsNavigationDestination')
ls_previous_entity		= is_current_entity
is_current_entity			= lds_datastore.GetItemString(ll_row, 'EnttyNme')
is_current_autoretrieve	= lds_datastore.GetItemString(ll_row, 'AutoRetrieve')
If IsNull(is_current_entity) Then is_current_entity = ''

If IsNull(lds_datastore.GetItemNumber(ll_row, 'UserID')) Then
	is_current_isglobal = 'Y'
Else
	is_current_isglobal = 'N'
End If

//----------------------------------------------------------------------------------
// Check to see if the syntax has changed over time.  This means the developer must have changed something
//		about the datawindow. We can't be confident that reapplying saved changes won't hose the thing
//		so we will just destroy the views
//----------------------------------------------------------------------------------
ll_return 			= lds_datastore.GetItemNumber(ll_row, 'SavedSyntaxBlobID')
is_newsyntax 		= String(ln_blob_manipulator.of_retrieve_blob(ll_return))

//----------------------------------------------------------------------------------
// Destroy this object
//----------------------------------------------------------------------------------
Destroy ln_blob_manipulator

//----------------------------------------------------------------------------------
// If the syntax is different we need to think
//----------------------------------------------------------------------------------
If ls_old_original_syntax <> is_originalsyntax Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// Pop up a messagebox that asks a question
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ib_WeAreInBatchMode Then
		ll_return = 1
	Else
		ll_return = gn_globals.in_messagebox.of_messagebox_question ('This view is no longer valid because the underlying report has been changed, the view will be recreated as closely as possible', OKCancel!, 1)
	End If
	
	Choose Case ll_return
		Case 1
			ib_AViewHasBeenAppliedThatIsNotValid	= True
			is_OldOriginalSyntax 						= ls_old_original_syntax
			is_OldViewSyntax								= is_newsyntax
		Case 2
			is_current_view 			= ''
			is_current_isdefault 	= ''
			is_current_isglobal 		= ''
			is_current_parameters	= ''
			il_current_view			= 0
	End Choose
Else
	ib_AViewHasBeenAppliedThatIsNotValid = False
	This.of_apply_syntax(is_newsyntax)
End If

If Not ib_WeAreInInitializationMode Then
	This.Event ue_notify('Graphic Services Created', '')
End If

ib_AViewHasBeenAppliedThatIsNotValid = False

If is_current_entity <> ls_previous_entity Then
	If is_current_entity = '' Then
		gn_globals.in_subscription_service.of_message('set report entity', is_original_entity, idw_data)
	Else
		gn_globals.in_subscription_service.of_message('set report entity', is_current_entity, idw_data)
	End If
End If

If is_current_view <> '' Then
	ls_return = gn_globals.in_string_functions.of_find_argument(is_current_parameters, '||', 'FilterViewID')
	If IsNumber(ls_return) Then
		idw_data.GetParent().Event Dynamic ue_notify('apply filter view', ls_return)
	End If
	
	ls_return = gn_globals.in_string_functions.of_find_argument(is_current_parameters, '||', 'CriteriaViewID')
	If IsNumber(ls_return) Then
		idw_data.GetParent().Event Dynamic ue_notify('apply criteria view', ls_return)
	End If
	
	ls_return = gn_globals.in_string_functions.of_find_argument(is_current_parameters, '||', 'UOMCurrencyViewID')
	If IsNumber(ls_return) Then
		gn_globals.in_subscription_service.of_message('apply uom/currency view', ls_return, idw_data)
	End If

	ls_return = gn_globals.in_string_functions.of_find_argument(is_current_parameters, '||', 'NestedReportViewID')
	If IsNumber(ls_return) Then
		idw_data.GetParent().Event Dynamic ue_notify('apply nested report', ls_return)
	End If
	
	If Not ib_WeAreInInitializationMode Then This.of_autoretrieve()
End If

Return ''
end function

protected subroutine of_export_view ();String	ls_pathname
String	ls_description
String	ls_data
Blob 		lblob_xml_document

NonVisualObject		ln_folderbrowse
//n_string_functions	ln_string_functions
n_blob_manipulator	ln_blob_manipulator

If IsValid(gn_globals.of_get_frame()) Then
	ln_folderbrowse = CREATE Using 'n_folderbrowse'
	ls_pathname = Trim(ln_folderbrowse.Dynamic of_browseforfolder(gn_globals.of_get_frame(), 'Pick the destination file folder for this saved report view.'))
	Destroy ln_folderbrowse
Else
	Return
End If
If Len(Trim(ls_pathname)) = 0 Then Return

If Right(ls_pathname, 1) <> '\' Then ls_pathname = ls_pathname + '\'

ls_description = idw_data.Dynamic Describe("report_title.Text")

If ls_description = '?' or ls_description = '!' Then ls_description = 'Exported Report View'

gn_globals.in_string_functions.of_replace_all(ls_description, '/', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '\', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, ':', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '*', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '|', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '>', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '<', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '?', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '$', '-')

ls_pathname = ls_pathname + Trim(ls_description) + '.ReportView.CF'

//If FileExists(ls_pathname) Then
//	If gn_globals.in_messagebox.of_messagebox_question ('This file already exists at this location, would you like to overwrite it', YesNoCancel!, 3) <> 1 Then Return
//End If
//
ls_data = This.of_get_syntax()

lblob_xml_document = Blob(ls_data)

ln_blob_manipulator = Create n_blob_manipulator
ln_blob_manipulator.of_build_file_from_blob(lblob_xml_document, ls_pathname)
Destroy ln_blob_manipulator
end subroutine

public subroutine of_apply_default ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_apply_default()
// Overview:    This will get the default view
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Apply the view
//----------------------------------------------------------------------------------
This.of_apply_view(of_get_default_view())

end subroutine

public function long of_get_default_view ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_default_view()
// Overview:    This will get the default view
// Created by:  Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------
Long 		ll_row
Long		ll_return

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
Datastore lds_datastore
Boolean	lb_DatastoreIsReference = True

lds_datastore = gn_globals.in_cache.of_get_cache_reference('ReportView')
If Not IsValid(lds_datastore) Then Return -1

//----------------------------------------------------------------------------------
// Find the default view
//----------------------------------------------------------------------------------
lds_datastore.SetFilter('DataObjectName = "' + is_current_identifier + '"')
lds_datastore.Filter()

lds_datastore.SetSort('If(IsNull(UserID), 1, 0)')
lds_datastore.Sort()

ll_row = lds_datastore.Find('IsDefault = "Y"', 1, lds_datastore.RowCount())

//----------------------------------------------------------------------------------
// If the row isn't valid return
//----------------------------------------------------------------------------------
If ll_row <= 0 Or ll_row > lds_datastore.RowCount() Then
	ll_return = -1
Else
	ll_return = lds_datastore.GetItemNumber(ll_row, 'Idnty')
End If

lds_datastore.SetSort('')
lds_datastore.Sort()
lds_datastore.SetFilter('')
lds_datastore.Filter()

Return ll_return

end function

public subroutine of_get_views (ref long al_idnty[], ref string as_views[], ref boolean ab_isglobal[], ref boolean ab_iscreatedbythisuser[]);Long ll_index

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
Datastore lds_datastore

lds_datastore = gn_globals.in_cache.of_get_cache_reference('ReportView')
If Not IsValid(lds_datastore) Then Return

lds_datastore.SetFilter('DataObjectName = "' + is_current_identifier + '"')
lds_datastore.Filter()
lds_datastore.SetSort('name A')
lds_datastore.Sort()

For ll_index = 1 To lds_datastore.RowCount()
	as_views[UpperBound(as_views[]) + 1] 				= lds_datastore.GetItemString(ll_index, 'Name')
	al_idnty[UpperBound(as_views[])]						= lds_datastore.GetItemNumber(ll_index, 'Idnty')
	ab_isglobal[UpperBound(as_views[])]					= IsNull(lds_datastore.GetItemNumber(ll_index, 'UserID'))
	ab_iscreatedbythisuser[UpperBound(as_views[])]	= (lds_datastore.GetItemNumber(ll_index, 'CreatedByUserID') = gn_globals.il_userid)
Next

lds_datastore.SetFilter('')
lds_datastore.Filter()

end subroutine

public function long of_save_view ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_update()
// Overview:    Save the syntax and the sort to the database
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
// Local Variables
//------------------------------------------------------------------------------------
Long		ll_null
Long		ll_entityid
String	ls_name
String	ls_isdefault
String	ls_return
String	ls_global
String	ls_parameters
String	ls_savefilters
String	ls_entityname
String	ls_AllowNavigation
String	ls_saveuomcurrency
String	ls_savecriteria
String	ls_SaveNestedReport
String	ls_autoretrieve
SetNull(ll_null)

//------------------------------------------------------------------------------------
// Local Objects
//------------------------------------------------------------------------------------
//n_string_functions 	ln_string_functions
NonVisualObject 		ln_nonvisual_window_opener

//------------------------------------------------------------------------------------
// Return if the object is not enabled
//------------------------------------------------------------------------------------
If Not ib_enabled Then Return -1

//------------------------------------------------------------------------------------
// Open the window to name the view
//------------------------------------------------------------------------------------
ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_dataobjectstate_service_select_view', This)
Destroy ln_nonvisual_window_opener

//------------------------------------------------------------------------------------
// Get the message and see if it's valid
//------------------------------------------------------------------------------------
ls_return = Message.StringParm
If Len(ls_return) = 0 Or IsNull(ls_return) Then Return -1

//------------------------------------------------------------------------------------
// Get the name and default
//------------------------------------------------------------------------------------
ls_name 					= 					gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'Name')
ls_isdefault 			= Upper(Trim(	gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'IsDefault')))
ls_global 				= Upper(Trim(	gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'Global')))
ls_savefilters			= Upper(Trim(	gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'SaveFilters')))
ls_saveuomcurrency	= Upper(Trim(	gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'SaveUOMCurrency')))
ls_savecriteria		= Upper(Trim(	gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'SaveCriteria')))
ls_SaveNestedReport	= Upper(Trim(	gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'SaveNestedReport')))
ls_autoretrieve		= Upper(Trim(	gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'AutoRetrieve')))

ll_entityid				= Long(			gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'EntityID'))
ls_entityname			= 					gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'EntityName')
ls_AllowNavigation	= 					gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'AllowNavigation')

//------------------------------------------------------------------------------------
// Return if the arguments aren't valid
//------------------------------------------------------------------------------------
If Len(ls_name) = 0 Or IsNull(ls_name) Then Return -1
If Len(ls_isdefault) = 0 Or IsNull(ls_isdefault) Then Return -1
If Upper(Trim(ls_isdefault)) <> 'N' And Upper(Trim(ls_isdefault)) <> 'Y' Then Return -1

If ll_entityid <= 0 Or IsNull(ll_entityid) Then
	SetNull(ll_entityid)
	SetNull(ls_entityname)
End If

If IsNull(ls_entityname) Then ls_entityname = ''

Return This.of_save_view(ls_name, ls_isdefault, ls_global, ll_entityid, ls_entityname, ls_AllowNavigation, ls_autoretrieve, ls_savefilters, ls_saveuomcurrency, ls_savecriteria, ls_SaveNestedReport, False)
end function

public function long of_save_view (string as_viewname, string as_isdefault, string as_isglobal, long al_entityid, string as_entityname, string as_allownavigation, string as_autoretrieve, string as_savefilters, string as_saveuomcurrency, string as_savecriteria, string as_savenestedreport, boolean ab_savecurrentviews);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_save_view()
// Overview:    Save the syntax and the sort to the database
// Created by:  Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_parameters

ls_parameters = This.of_get_parameters(Upper(Trim(as_savefilters)) = 'Y', Upper(Trim(as_saveuomcurrency)) = 'Y', Upper(Trim(as_savecriteria)) = 'Y', Upper(Trim(as_SaveNestedReport)) = 'Y', ab_savecurrentviews, as_viewname)

Return This.of_save_view(as_viewname, as_isdefault, as_isglobal, ls_parameters, al_entityid, as_entityname, as_AllowNavigation, as_autoretrieve)
end function

public function string of_apply_view (string as_viewname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_view()
//	Arguments:  as_viewname 	- The name of the view
//	Overview:   This will apply the view passed in
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------
Long		ll_idnty
Long		ll_row

//----------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------
Datastore lds_datastore

If Len(Trim(as_viewname)) <= 0 Or IsNull(as_viewname) Then Return 'Error:  The view name was not valid'

lds_datastore = gn_globals.in_cache.of_get_cache_reference('ReportView')
If Not IsValid(lds_datastore) Then Return 'Error:  Could not get report views from the cache object'

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the view that we are trying to apply
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore.SetFilter('DataObjectName = "' + is_current_identifier + '"')
lds_datastore.Filter()

ll_row = lds_datastore.Find('Lower(Name) = "' + Trim(Lower(as_viewname) + '"'), 1, lds_datastore.RowCount())

If ll_row > 0 Then
	ll_idnty = lds_datastore.GetItemNumber(ll_row, 'Idnty')
	lds_datastore.SetFilter('')
	lds_datastore.Filter()
Else
	lds_datastore.SetFilter('')
	lds_datastore.Filter()
	Return 'Error:  The requested view does not exist (' + as_viewname + ')'
End If

Return This.of_apply_view(ll_idnty)
end function

protected subroutine of_apply_current_view ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_current_view()
//	Arguments:  None.
//	Overview:   DocumentScriptFunctionality
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_apply_view(il_current_view)
end subroutine

public function string of_get_parameters (boolean ab_savefilter, boolean ab_saveuomcurrency, boolean ab_savecriteria, boolean ab_savednestedreport, boolean ab_saveovercurrentviews, string as_defaultsavename);n_bag 	ln_bag
Long		ll_return
Long		ll_null
String	ls_parameters
String	ls_null
String	ls_filter
PowerObject	lu_object
PowerObject	lu_search
n_reporting_object_service ln_reporting_object_service
SetNull(ls_null)
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the applied filter views
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_savefilter Then
	lu_object = idw_data.Dynamic of_get_service_manager().of_get_component('u_filter_strip')
	If IsValid(lu_object) Then
		ls_filter = idw_data.Dynamic Describe("DataWindow.Table.Filter")
		If Trim(ls_filter) <> '' And Trim(ls_filter) <> '!' And Trim(ls_filter) <> '?' Then
		
			If ab_saveovercurrentviews Then
				ll_return = Long(lu_object.Dynamic of_save_view(as_defaultsavename))
			Else
				ll_return = lu_object.Dynamic of_get_current_view_id()
			End If
			
			If Not IsNull(ll_return) And ll_return > 0 Then
				ls_parameters = ls_parameters + 'FilterViewID=' + String(ll_return) + '||'
			End If
		End If
	End If
End If

If ab_saveuomcurrency Then
	lu_object = idw_data.Dynamic of_get_service_manager().of_get_component('u_dynamic_conversion_strip')
	If IsValid(lu_object) Then
		If ab_saveovercurrentviews Then
			ll_return = Long(lu_object.Dynamic of_save_view(as_defaultsavename))
		Else
			ll_return = lu_object.Dynamic of_get_current_view_id()
		End If
	
		If ll_return <> 0 And Not IsNull(ll_return) Then
			ls_parameters = ls_parameters + 'UOMCurrencyViewID=' + String(ll_return) + '||'
		End If
	End If
	
	
	If ab_saveovercurrentviews Then
		lu_object = idw_data.Dynamic of_get_service_manager().of_get_component('u_filter_strip')
		If IsValid(lu_object) Then
			lu_object.Event Dynamic ue_notify('save view as', as_defaultsavename)
		End If
	End If

	ln_bag = Create n_bag
	Message.PowerObjectParm = ln_bag
	gn_globals.in_subscription_service.of_message('Get UOM/Currency View', '', idw_data)
	
	If IsValid(ln_bag) Then
		ll_return = Long(ln_bag.of_get('UOM/Currency View ID'))
		
		If ll_return <> 0 And Not IsNull(ll_return) Then
			ls_parameters = ls_parameters + 'UOMCurrencyViewID=' + String(ll_return) + '||'
		End If
	End If
End If

If idw_data.TypeOf() = Datawindow! And ab_savecriteria Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// If the criteria object is not valid, attempt to create it
	//-----------------------------------------------------------------------------------------------------------------------------------
	If String(idw_data.GetParent().Event Dynamic ue_get_classname()) = 'u_search' Then
		lu_search = idw_data.GetParent()
		
		If IsValid(lu_search.Dynamic of_create_criteria()) Then
			//----------------------------------------------------------------------------------------------------------------------------------
			// Save the arguments for the criteria object to the database.
			//-----------------------------------------------------------------------------------------------------------------------------------
			ll_return = lu_search.Dynamic of_get_criteria().of_save_criteria()
			If ll_return > 0 And Not IsNull(ll_return) Then
				ls_parameters = ls_parameters + 'CriteriaViewID=' + String(ll_return) + '||'
			End If
		End If
	End If
End If

If idw_data.TypeOf() = Datawindow! And ab_savednestedreport Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// If the criteria object is not valid, attempt to create it
	//-----------------------------------------------------------------------------------------------------------------------------------
	If String(idw_data.GetParent().Event Dynamic ue_get_classname()) = 'u_search' Then
		lu_search = idw_data.GetParent()

		ln_reporting_object_service = Create n_reporting_object_service
		ll_return = ln_reporting_object_service.of_save_nested_report(lu_search, ll_null, ll_null, gn_globals.il_userid, gn_globals.il_userid, ls_null, ls_null, False, ab_savefilter, True, False, True, True, ab_saveovercurrentviews)
		Destroy ln_reporting_object_service
		
		If ll_return > 0 And Not IsNull(ll_return) Then
			ls_parameters = ls_parameters + 'NestedReportViewID=' + String(ll_return) + '||'
		End If
		
	End If
End If
	
Return Left(ls_parameters, Len(ls_parameters) - 2)
end function

public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_default_view
String	ls_views[]
Long		ll_idnty[]
Long		ll_index
Long		ll_upperbound
Long		ll_defaultview
Boolean	lb_IsGlobal[]
Boolean	lb_IsCreatedByThisUser[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_menu_dynamic ln_menu_dynamic_cascade

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_data) Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Create a cascade menu to append to this menu
//-----------------------------------------------------------------------------------------------------------------------------------
ll_defaultview = This.of_get_default_view()

//-----------------------------------------------------------------------------------------------------------------------------------
// Add some generic items
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic_cascade = an_menu_dynamic.of_add_item('Report View Options', '', '', This)
If Not ib_WeAreInBatchMode Then ln_menu_dynamic_cascade.of_add_item('Save &This Report View...', 'save view', '', This)
ln_menu_dynamic_cascade.of_add_item('Restore Original Report &View', 'restore view', '', This)
ln_menu_dynamic_cascade.of_add_item('-', '', '', This)
If Not ib_WeAreInBatchMode Then ln_menu_dynamic_cascade.of_add_item('Export Current Report View To File...', 'export view', '', This)
If Not ib_WeAreInBatchMode Then ln_menu_dynamic_cascade.of_add_item('Import Report View From File...', 'import view', '', This)
If Not ib_WeAreInBatchMode Then ln_menu_dynamic_cascade.of_add_item('Import Report View From CustomerFocus Views...', 'import public view', '', This)
If Not ib_WeAreInBatchMode Then ln_menu_dynamic_cascade.of_add_item('-', '', '', This)
If Not ib_WeAreInBatchMode Then ln_menu_dynamic_cascade.of_add_item('Manage Report Views...', 'manage views', '', This)
//-----------------------------------------------------------------------------------------------------------------------------------
// Add the dataobject state menu items
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_views(ll_idnty[], ls_views[], lb_IsGlobal[], lb_IsCreatedByThisUser[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no views to add to the menu
//-----------------------------------------------------------------------------------------------------------------------------------
If Not UpperBound(ls_views[]) > 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add each view, checking the menu if it is the current view
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic_cascade.of_add_item('-', '', '', This)
For ll_index = 1 To UpperBound(ls_views[])
	ln_menu_dynamic_cascade.of_add_item( 'Apply Report View - ' + ls_views[ll_index], 'Apply View ID', String(ll_idnty[ll_index]), This).Checked = (il_current_view = ll_idnty[ll_index])
Next

end subroutine

public function long of_save_view (string as_viewname, string as_isdefault, string as_isglobal, string as_parameters, long al_entityid, string as_entityname, string as_allownavigation, string as_autoretrieve);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_update()
// Overview:    Save the syntax and the sort to the database
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
// Local Variables
//------------------------------------------------------------------------------------
Long ll_row, ll_return, ll_index, ll_null, ll_zoom
String ls_return, ls_previous_entity
Blob	lblob_temp
SetNull(ll_null)

//------------------------------------------------------------------------------------
// Local Objects
//------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
n_blob_manipulator 	ln_blob_manipulator
//n_string_functions 	ln_string_functions
Datastore				lds_datastore

//------------------------------------------------------------------------------------
// Create the Blob Manipulator
//------------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator
ll_row = 0

lds_datastore = Create Datastore
lds_datastore.DataObject = 'd_dataobject_state_cache'
lds_datastore.SetTransObject(SQLCA)

lds_datastore.Retrieve(0, il_user_id, is_current_identifier)

//------------------------------------------------------------------------------------
// Try to find the view name that we are looking for.  If we find it, set its 
//		default property.  If the new view is default, make all others non-default.
//------------------------------------------------------------------------------------
For ll_index = lds_datastore.RowCount() To 1 Step -1
	If Trim(Lower(as_viewname)) = Lower(Trim(lds_datastore.GetItemString(ll_index, 'Name'))) Then
		ll_row = ll_index

//		If Upper(Trim(as_isdefault)) = 'Y' And IsNull(lds_datastore.GetItemNumber(ll_index, 'UserID')) And (lds_datastore.GetItemNumber(ll_index, 'CreatedByUserID') = gn_globals.il_userid Or gn_globals.in_security.of_check_role(gn_globals.il_userid, 1)) Then
//			lds_datastore.SetItem(ll_index, 'UserID', gn_globals.il_userid)
//		End If

//		If Upper(Trim(as_isdefault)) <> lds_datastore.GetItemString(ll_index, 'IsDefault') And Upper(Trim(as_isdefault)) = 'Y' And (lds_datastore.GetItemNumber(ll_index, 'CreatedByUserID') = gn_globals.il_userid Or gn_globals.in_security.of_check_role(gn_globals.il_userid, 1)) Then
//			lds_datastore.SetItem(ll_index, 'IsDefault', Upper(Trim(as_isdefault)))
//		End If
		
		If Upper(Trim(as_allownavigation)) <> lds_datastore.GetItemString(ll_index, 'IsNavigationDestination') And Upper(Trim(as_allownavigation)) = 'Y' Then
			lds_datastore.SetItem(ll_index, 'IsNavigationDestination', Upper(Trim(as_allownavigation)))
		End If
		
		If al_entityid <> -1 And Not IsNull(al_entityid) <> IsNull(lds_datastore.GetItemNumber(ll_index, 'EnttyID')) Or (Not IsNull(al_entityid) And Not IsNull(lds_datastore.GetItemNumber(ll_index, 'EnttyID')) And al_entityid <> lds_datastore.GetItemNumber(ll_index, 'EnttyID')) Then
			lds_datastore.SetItem(ll_index, 'EnttyID', al_entityid)
		End If
	Else
		If Upper(Trim(as_isdefault)) = 'Y' Then
			If Upper(Trim(as_isdefault)) = lds_datastore.GetItemString(ll_index, 'IsDefault') Then
				if lds_datastore.GetItemNumber(ll_index, 'CreatedByUserID')  = gn_globals.il_userid then  // Only reset views owned by the current user
					lds_datastore.SetItem(ll_index, 'IsDefault', 'N')
				End If
			End If
		End If
	End If
Next


//------------------------------------------------------------------------------------
// If we find it, delete the blobs from the database
//------------------------------------------------------------------------------------
If ll_row > 0 Then
	ll_return = lds_datastore.GetItemNumber(ll_row, 'SavedSyntaxBlobID')
	
	If Not IsNull(ll_return) And ll_return > 0 Then
		ll_return = ln_blob_manipulator.of_delete_blob(ll_return)
	End If

	ll_return = lds_datastore.GetItemNumber(ll_row, 'OriginalSyntaxBlobID')
	
	If as_isglobal = 'Y' Then
		lds_datastore.SetItem(ll_row, 'UserID', 				ll_null)
	End If
	
	If Not IsNull(ll_return) And ll_return > 0 Then
		ll_return = ln_blob_manipulator.of_delete_blob(ll_return)
	End If
End If

//------------------------------------------------------------------------------------
// If there isn't already a row insert one and initialize it
//------------------------------------------------------------------------------------
If lds_datastore.RowCount() = 0 Or ll_row = 0 Then
	ll_row = lds_datastore.InsertRow(0)
	
	If as_isglobal <> 'Y' Then
		lds_datastore.SetItem(ll_row, 'UserID', 				il_user_id)
	End If
	
	If IsNull(il_user_id) Then
		lds_datastore.SetItem(ll_row, 'CreatedByUserID', 	gn_globals.il_userid)
	Else
		lds_datastore.SetItem(ll_row, 'CreatedByUserID', 	il_user_id)
	End If
	lds_datastore.SetItem(ll_row, 'DataObjectName', 			is_current_identifier)
	lds_datastore.SetItem(ll_row, 'Name', 							as_viewname)
	lds_datastore.SetItem(ll_row, 'IsDefault', 					Upper(Trim(as_isdefault)))
	If Not IsNull(al_entityid) And al_entityid > 0 Then
		lds_datastore.SetItem(ll_row, 'EnttyID', 						al_entityid)
	End If
	lds_datastore.SetItem(ll_row, 'IsNavigationDestination', Upper(Trim(as_allownavigation)))
	lds_datastore.SetItem(ll_row, 'AutoRetrieve', 				as_autoretrieve)
End If

//------------------------------------------------------------------------------------
// Insert the old syntax into database as a blob
//------------------------------------------------------------------------------------
lblob_temp = blob(is_originalsyntax)
ll_return = ln_blob_manipulator.of_insert_blob(lblob_temp, 'DataObjectState', FALSE)

//------------------------------------------------------------------------------------
// If there's an error, return
//------------------------------------------------------------------------------------
If IsNull(ll_return) Or ll_return <= 0 Then
	Destroy lds_datastore
	Destroy ln_blob_manipulator
	Return -1
End If	

//------------------------------------------------------------------------------------
// Set the original syntax id into the datastore
//------------------------------------------------------------------------------------
lds_datastore.SetItem(ll_row, 'OriginalSyntaxBlobID', ll_return)
lds_datastore.SetItem(ll_row, 'Parameters', as_parameters)

//------------------------------------------------------------------------------------
// If the zoom has been changed, let's save it to a computed field so it can be restored
//------------------------------------------------------------------------------------
ll_zoom = Long(idw_data.Dynamic Describe("Datawindow.Zoom"))
If ll_zoom <> 100 Then
	ln_datawindow_tools = Create n_datawindow_tools
	idw_data.Dynamic Describe("Destroy dataobjectstateinit")
	ln_datawindow_tools.of_set_expression(idw_data, "dataobjectstateinit", 'zoom=' + String(ll_zoom))
	Destroy ln_datawindow_tools
End If

//------------------------------------------------------------------------------------
// Get the new syntax
//------------------------------------------------------------------------------------
is_newsyntax = This.of_get_syntax()

//------------------------------------------------------------------------------------
// Return if the new syntax is invalid
//------------------------------------------------------------------------------------
If IsNull(is_newsyntax) Or is_newsyntax = '!' Or is_newsyntax = '?' Or Len(Trim(is_newsyntax)) = 0 Then
	Destroy ln_blob_manipulator
	Destroy lds_datastore
	Return -1
End If

//------------------------------------------------------------------------------------
// Insert the new syntax into database as a blob
//------------------------------------------------------------------------------------
lblob_temp = blob(is_newsyntax)
ll_return = ln_blob_manipulator.of_insert_blob(lblob_temp, 'DataObjectState', FALSE)

//------------------------------------------------------------------------------------
// Return if there's an error
//------------------------------------------------------------------------------------
If IsNull(ll_return) Or ll_return <= 0 Then
	Destroy ln_blob_manipulator
	Destroy lds_datastore
	Return -1
End If

//------------------------------------------------------------------------------------
// Insert the new syntax into database as a blob.  Add the parameters.
//------------------------------------------------------------------------------------
lds_datastore.SetItem(ll_row, 'SavedSyntaxBlobID', ll_return)

//------------------------------------------------------------------------------------
// Update the datastore
//------------------------------------------------------------------------------------
ll_return = lds_datastore.Update()
Destroy ln_blob_manipulator

//------------------------------------------------------------------------------------
// Return the result of the update
//------------------------------------------------------------------------------------
is_current_view 				= as_viewname
is_current_isglobal			= as_isglobal
is_current_isdefault			= as_isdefault
is_current_parameters		= as_parameters
il_current_view				= lds_datastore.GetItemNumber(ll_row, 'Idnty')
is_current_allownavigation	= as_allownavigation
ls_previous_entity			= is_current_entity
is_current_entity				= as_EntityName
is_current_autoretrieve		= as_autoretrieve

If is_current_entity <> ls_previous_entity Then
	If is_current_entity = '' Then
		gn_globals.in_subscription_service.of_message('set report entity', is_original_entity, idw_data)
	Else
		gn_globals.in_subscription_service.of_message('set report entity', is_current_entity, idw_data)
	End If
End If

ls_return = gn_globals.in_string_functions.of_find_argument(is_current_parameters, '||', 'FilterViewID')
If IsNumber(ls_return) Then
	idw_data.GetParent().Event Dynamic ue_notify('apply filter view', ls_return)
End If

If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('refresh cache', 'ReportView')
End If

Destroy lds_datastore
Return ll_return
end function

on n_dao_dataobject_state.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dao_dataobject_state.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

