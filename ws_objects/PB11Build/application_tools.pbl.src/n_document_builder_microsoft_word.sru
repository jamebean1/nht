$PBExportHeader$n_document_builder_microsoft_word.sru
forward
global type n_document_builder_microsoft_word from nonvisualobject
end type
end forward

global type n_document_builder_microsoft_word from nonvisualobject
end type
global n_document_builder_microsoft_word n_document_builder_microsoft_word

type variables
Protected:
	Window iw_report
	UserObject 	iu_dynamic_gui_report_adapter
	UserObject	iu_search
	Boolean			ib_Testing	= True
	String DistributionInit
end variables

forward prototypes
public function string of_get_distributioninit ()
public function n_reportconfignested_document of_get_heirarchy (userobject au_adapter)
public function string of_add_children (ref n_reportconfignested_document an_reportconfignested_document, ref userobject au_dynamic_gui)
public function string of_retrieve (long al_reportconfigid, string as_retrievalarguments)
end prototypes

public function string of_get_distributioninit ();Return DistributionInit
end function

public function n_reportconfignested_document of_get_heirarchy (userobject au_adapter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_heirarchy()
//	Created by:	Blake Doerr
//	History: 	2/14/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject lu_search[]
n_reportconfignested_document ln_reportconfignested_document

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the adapter is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_adapter) Then Return ln_reportconfignested_document
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Get the reports from the adapter
//-----------------------------------------------------------------------------------------------------------------------------------
au_adapter.Dynamic of_get_reports(lu_search[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there's not at least one report
//-----------------------------------------------------------------------------------------------------------------------------------
If Not UpperBound(lu_search[]) > 0 Then Return ln_reportconfignested_document

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the document object and set the variables
//-----------------------------------------------------------------------------------------------------------------------------------
ln_reportconfignested_document = Create n_reportconfignested_document
If IsNull(ln_reportconfignested_document.il_rowid) Then ln_reportconfignested_document.il_rowid = 0
ln_reportconfignested_document.iu_search_datasource	= lu_search[1]
ln_reportconfignested_document.il_blobobjectid			= Long(lu_search[1].Dynamic of_get_properties().of_Get('WordTemplateBlobObjectID'))
ln_reportconfignested_document.il_rowid					= 0
ln_reportconfignested_document.il_parentrowid			= 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the recursive function that will add all the children to the document object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_add_children(ln_reportconfignested_document, lu_search[1])

Return ln_reportconfignested_document
end function

public function string of_add_children (ref n_reportconfignested_document an_reportconfignested_document, ref userobject au_dynamic_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_children()
//	Overview:   Add all the children documents to the object structure
//	Created by:	Blake Doerr
//	History: 	2/4/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_reportconfignested_document ln_reportconfignested_document
n_blob_manipulator ln_blob_manipulator
UserObject lu_search[], lu_search_passedin
UserObject lu_dynamic_gui

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the report objects are not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_dynamic_gui) Then Return 'Error:  Invalid report object'
lu_dynamic_gui = au_dynamic_gui.Dynamic of_get_overlaying_report()
If Not IsValid(lu_dynamic_gui) Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the reports that are opened
//-----------------------------------------------------------------------------------------------------------------------------------
lu_search_passedin		= au_dynamic_gui
lu_dynamic_gui.Dynamic of_get_reports(lu_search[])
ln_blob_manipulator = Create n_blob_manipulator
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the nested report details and merge them with the open reports
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(lu_search[])
	If Not IsValid(lu_search[ll_index]) Then Continue
	
	ln_reportconfignested_document = Create n_reportconfignested_document
	an_reportconfignested_document.in_child_reportconfignested_document[UpperBound(an_reportconfignested_document.in_child_reportconfignested_document[]) + 1] = ln_reportconfignested_document
	ln_reportconfignested_document.il_blobobjectid			= Long(lu_search[ll_index].Dynamic of_get_properties().of_Get('WordTemplateBlobObjectID'))
	ln_reportconfignested_document.il_rowid					= Long(lu_search[ll_index].Dynamic of_get_properties().of_Get('NestedReportRowID'))
	ln_reportconfignested_document.il_parentrowid			= Long(lu_search[ll_index].Dynamic of_get_properties().of_Get('NestedReportRowID'))
	ln_reportconfignested_document.is_bookmarkname			= 'DocumentID' + String(Long(lu_search[ll_index].Dynamic of_get_properties().of_Get('WordTemplateBlobObjectID')))
	ln_reportconfignested_document.iu_search_datasource	= lu_search[ll_index]
	
	ls_return = This.of_add_children(ln_reportconfignested_document, ln_reportconfignested_document.iu_search_datasource)
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the error messsage if there were any
//-----------------------------------------------------------------------------------------------------------------------------------
Return Left(ls_return, Len(ls_return) - 2)
end function

public function string of_retrieve (long al_reportconfigid, string as_retrievalarguments);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_retrieve
// Overview:	open invisible window and create appropriate report controls.
// Created by:	Blake Doerr
// History:		2/3/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_reportconfignestedid
Long		ll_originalreportconfigid
String	ls_report_object
String	ls_return
String	ls_adapter_object
String	ls_options

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_distributioninit ln_distributioninit
n_report ln_report
UserObject lu_search
n_reportconfignested_document ln_reportconfignested_document
n_microsoft_word_tools ln_microsoft_word_tools

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Retrieving Microsoft Word Document', 'Reporting')
//End If
//
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin('Creating Report')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the nested report
//-----------------------------------------------------------------------------------------------------------------------------------
ll_reportconfignestedid		= Long(gn_globals.in_cache.of_get_value('ReportConfig', 'TmplteRprtCnfgNstdID', 'reportid', al_reportconfigid))
ll_originalreportconfigid	= Long(gn_globals.in_cache.of_get_value('ReportConfig', 'RprtCnfgNstdRprtCnfgID', 'reportid', al_reportconfigid))

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the adapter object name if it exists.
//-----------------------------------------------------------------------------------------------------------------------------------
ln_report = Create n_report
ln_report.of_init(ll_originalreportconfigid)
ln_report.of_set('IsBatchMode', 'Y')
ln_report.of_set('UserID', String(gn_globals.il_userid))

//-----------------------------------------------------------------------------------------------------------------------------------
// Open invisible window and create the appropriate adapter object
//-----------------------------------------------------------------------------------------------------------------------------------
open(iw_report, 'w_invisible')
iw_report.Visible = FALSE
iw_report.OpenUserObject(iu_dynamic_gui_report_adapter, ln_report.of_get('AdapterObject'), 0, 0)

//----------------------------------------------------------------------------------------------------------------------------------
// Ensure we got a valid handle to the adapter object.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(iu_dynamic_gui_report_adapter) Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Retrieving Microsoft Word Document')
//	End If

	RETURN 'Error:  Could not create adapter object'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Use the report manager to initialize the adapter (The adapter will destroy the report manager when it's closed)
//	Set the batch options on the report manager object so it will know whether to create the criteria and what database it should
//	be attached to when retrieving.
//-----------------------------------------------------------------------------------------------------------------------------------
lu_search = iu_dynamic_gui_report_adapter.Dynamic of_open_report(ln_report)

If Not IsValid(lu_search) Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Retrieving Microsoft Word Document')
//	End If

	Return 'Error:  There were no valid report objects open on the adapter'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the first u_search, since this is the top level document, there should only be one
//-----------------------------------------------------------------------------------------------------------------------------------
iu_search = lu_search

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin('Applying Nested Report')
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the nested report
//-----------------------------------------------------------------------------------------------------------------------------------
lu_search.Dynamic Event ue_notify('Apply Nested Report', ll_reportconfignestedid)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin('Getting Nested Report Heirarchy')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the heirarchy of document objects
//-----------------------------------------------------------------------------------------------------------------------------------
ln_reportconfignested_document = This.of_get_heirarchy(iu_dynamic_gui_report_adapter)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return an error if the document object is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_reportconfignested_document) Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Retrieving Microsoft Word Document')
//	End If

	Return 'Error:  There was an error getting the document heirarchy'
End If

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin('Creating Templates')
//End If
//
ln_microsoft_word_tools = Create n_microsoft_word_tools
ln_reportconfignested_document.of_set_n_microsoft_word_tools(ln_microsoft_word_tools)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create all the templates on the objects
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ln_reportconfignested_document.of_create_template()

//-----------------------------------------------------------------------------------------------------------------------------------
// If there was an error create templates, return
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then
	Destroy ln_reportconfignested_document
	Destroy ln_microsoft_word_tools
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Retrieving Microsoft Word Document')
//	End If
//
	Return ls_return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the parameters as an entity message
//-----------------------------------------------------------------------------------------------------------------------------------
n_entity_drag_message ln_entity_drag_message
If Pos(as_retrievalarguments, '=') <= 0 Then as_retrievalarguments = 'ID=' + as_retrievalarguments

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin('Retrieving Report')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the document using the parameters
//-----------------------------------------------------------------------------------------------------------------------------------
ln_entity_drag_message.of_add_item(as_retrievalarguments)
Message.PowerObjectParm = ln_entity_drag_message
iu_dynamic_gui_report_adapter.Event DragDrop(iu_dynamic_gui_report_adapter)

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Replacing Bookmarks')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace all the bookmarks.  This function is also recursive.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ln_reportconfignested_document.of_replace_bookmarks()

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Replacing Bookmarks')
//End If
//
//
//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin('Getting Distribution Information')
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the distribution init field out of the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
ln_distributioninit = Create n_distributioninit
ln_distributioninit.of_init(lu_search.Dynamic of_get_properties().of_getitem(1, 'distributioninit'))
ln_distributioninit.of_append(ln_distributioninit.of_get_evaluated_distributioninit(lu_search.Dynamic of_get_properties().of_get_object('DataSource')))
DistributionInit = ln_distributioninit.of_get_expression()
Destroy ln_distributioninit

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we could not correctly replace all bookmarks and create the document
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return <> '' Then
	Destroy ln_reportconfignested_document
	Destroy ln_microsoft_word_tools
	
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Retrieving Microsoft Word Document')
//	End If

	Return ls_return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the document path to return
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ln_reportconfignested_document.is_document_path

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the document object
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_reportconfignested_document
Destroy ln_microsoft_word_tools

//If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//	gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Retrieving Microsoft Word Document')
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Return the file name or an error message if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

on n_document_builder_microsoft_word.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_document_builder_microsoft_word.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//-----------------------------------------------------------------------------------------------------------------------------------
// Close u_search and then close the invisible window we instantiated it on.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iw_report) Then
	If IsValid(iu_search) Then
		iw_report.CloseUserObject(iu_search)
	End If
	Close(iw_report)
End If

end event

