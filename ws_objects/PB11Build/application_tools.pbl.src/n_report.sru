$PBExportHeader$n_report.sru
forward
global type n_report from n_dao_reference_data
end type
end forward

global type n_report from n_dao_reference_data
string dataobject = "d_report_dao"
string is_qualifier = "ReportConfig"
event ue_notify ( string as_message,  any aany_argument )
end type
global n_report n_report

type variables
	Public ProtectedWrite	Boolean	IsInitialized

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Long		RprtCnfgID
	Public ProtectedWrite	Long		FolderID
	Public ProtectedWrite	Long		ReportDatabaseID
	Public ProtectedWrite	Long		DataObjectBlobObjectID
	Public ProtectedWrite	Long		CriteriaDataObjectBlobObjectID
	Public ProtectedWrite	Long		ReportDocumentTypeID
	Public ProtectedWrite	Long		HelpID
	Public ProtectedWrite	Long		UserID
	Public ProtectedWrite	Long		ReportDefaultID
	Public ProtectedWrite	Long		DefaultDocumentArchiveTypeID
	Public ProtectedWrite	String	ReportDocumentType
	Public ProtectedWrite	String	Name
	Public ProtectedWrite	String	Description
	Public ProtectedWrite	String	EntityName
	Public ProtectedWrite	String	BlobType
	Public ProtectedWrite	String	FileType
	Public ProtectedWrite	String	DisplayObjectIcon
	Public ProtectedWrite	String	DocumentName
	Public ProtectedWrite	String	BookmarkName
	Public ProtectedWrite	String	DefaultDocumentArchiveTypeFileExtension

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Document Generation Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Long		WordTemplateBlobObjectID
	Public ProtectedWrite	Long		NestedReportRowID
	Public ProtectedWrite	String	DistributionInit

	Public ProtectedWrite	Boolean	TrackStatistics
	Public ProtectedWrite	Long		ReportConfigNestedID
	Public ProtectedWrite	Long		ReportConfigNestedDetailID
	Public ProtectedWrite	DateTime RetrieveStartDateTime

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Object Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	String	DataObjectName
	Public ProtectedWrite	String	DataDAOObject
	Public ProtectedWrite	String	CriteriaUserObject
	Public ProtectedWrite	String	CriteriaDAOObject
	Public ProtectedWrite	String	DisplayUserObject
	Public ProtectedWrite	String	AdapterObject
	Public ProtectedWrite	String	ReportType
	Public ProtectedWrite	String	CriteriaType
	Public ProtectedWrite	String	ReportingServicesOptions
	Public ProtectedWrite	String	ArchiveObject
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Miscellaneous Reporting Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Boolean	IsRichTextDatawindow
	Public ProtectedWrite	Boolean	IsDefaultShowCriteria
	Public ProtectedWrite	Boolean	IsAutoRetrieve
	Public ProtectedWrite	Boolean	IsSavedReport
	Public ProtectedWrite	Boolean	IsImportedCriteriaDataObject
	Public ProtectedWrite	Boolean	IsImportedDataObject
	Public ProtectedWrite	Boolean	IsLargeReport
	Public ProtectedWrite	Boolean	IsDragDropEnabled
	Public ProtectedWrite	Boolean	IsBatchMode
	Public ProtectedWrite	Boolean	IsFavoriteReport
	Public ProtectedWrite	Boolean	AllowAddingToDesktops
	Public ProtectedWrite	Boolean	AllowClosing
	Public ProtectedWrite	Boolean	AllowRetrieve
	Public ProtectedWrite	Boolean	AllowCriteria

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Service Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Boolean	UseCriteriaDefaultingService
	Public ProtectedWrite	Boolean	UseReportViewService
	Public ProtectedWrite	Boolean	UseRowFocusService
	Public ProtectedWrite	Boolean	UseColumnResizingService
	Public ProtectedWrite	Boolean	UseDynamicGroupingService
	Public ProtectedWrite	Boolean	UseFormattingService
	Public ProtectedWrite	Boolean	UseAggregationService
	Public ProtectedWrite	Boolean	UseDropDownCachingService
	Public ProtectedWrite	Boolean	UseSortingService
	Public ProtectedWrite	Boolean	UseFilterService
	Public ProtectedWrite	Boolean	UseConversionService
	Public ProtectedWrite	Boolean	UseColumnSelectionService
	Public ProtectedWrite	Boolean	UsePivotService
	Public ProtectedWrite	Boolean	UseCalendarService
	Public ProtectedWrite	Boolean	UseRejectRedService
	Public ProtectedWrite	Boolean	UseAutofillService
	Public ProtectedWrite	Boolean	UseKeyboardDefaultService
	Public ProtectedWrite	Boolean	UseTreeviewService
	Public ProtectedWrite	Boolean	UseDAOService

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Saved Report Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	Public ProtectedWrite	Long		SavedReportBlobObjectID
	Public ProtectedWrite	Long		SavedReportID
	Public ProtectedWrite	Long		SavedReportUserID
	Public ProtectedWrite	Long		SavedReportRevisionUserID
	Public ProtectedWrite	Long		SavedReportRevisionLevel
	Public ProtectedWrite	Long		SavedReportDocumentArchiveTypeID
	Public ProtectedWrite	Long		SavedReportApprovalUserID
	Public ProtectedWrite	Long		SavedReportDocumentTypeID
	Public ProtectedWrite	String	SavedReportType
	Public ProtectedWrite	String	SavedReportDistributionMethod
	Public ProtectedWrite	String	SavedReportFileName
	Public ProtectedWrite	Boolean	IsSavedReportDistributed
	Public ProtectedWrite	DateTime	SavedReportRevisionDate
	Public ProtectedWrite	DateTime	SavedReportDistributionDate
	Public ProtectedWrite	DateTime	SavedReportApprovalDate
	
	Public ProtectedWrite	PowerObject	DataSource
	Public ProtectedWrite	PowerObject	AlternateDistributionDataSource
	Public ProtectedWrite	Transaction	TransactionObject
	
	Protected:
		String	OverrideOptionName[]
		String	OverrideOptionValue[]
		String	CustomOptionName[]
		String	CustomOptionValue[]
		Boolean	UsingUOMConversion
		Boolean	UsingCurrencyConversion
		Boolean	OpenedInReferenceDataMode
		Boolean	RunningNonvisually
		
//		n_dao_reporting_data in_dao_reporting_data
//		n_dao_reporting_criteria in_dao_reporting_criteria

//		n_string_functions in_string_functions
//		DataStore lds_datasource
end variables

forward prototypes
public function string of_get_savedreportfilename (ref string s_filename, long al_blobobjectid)
public function n_entity_drag_message of_get_selected_keys ()
public function long of_redirect_event (string as_eventname)
public function long of_redirect_event (string as_eventname, keycode key, unsignedlong keyflags)
public function long of_redirect_event (string as_eventname, long row, ref dwobject dwo, string data)
public function long of_redirect_event (string as_eventname, long rowcount)
public function long of_redirect_event (string as_eventname, long scrollpos, long pane)
public function long of_redirect_event (string as_eventname, long xpos, long ypos, long row, ref dwobject dwo)
public function long of_redirect_event (string as_eventname, ref dragobject source)
public function long of_redirect_event (string as_eventname, ref dragobject source, long row, ref dwobject dwo)
public function long of_redirect_event (string as_eventname, sqlpreviewfunction request, sqlpreviewtype sqltype, ref string sqlsyntax, dwbuffer buffer, long row)
public function long of_redirect_event (string as_eventname, unsignedlong flags, long xpos, long ypos)
public function string of_retrieve (long al_value)
public function long of_retrieve (string as_retrievalarguments)
public subroutine of_retrieve_distributionmethods (ref string s_distribution_methods[])
public function string of_retrieveusingregistryvalue (string as_reportregistryvalue)
public subroutine of_set_nonvisual (boolean ab_nonvisual)
public function string of_set_object (string as_name, powerobject ao_object)
public subroutine of_set_options (string as_options)
public function string of_init (string as_reportregistryvalue)
protected function string of_init_datasource (powerobject ao_datasource)
public subroutine of_settransobject (transaction axctn_transaction)
public function string of_save ()
public subroutine of_apply_overrides ()
public function string of_distribute (string as_distributionmethod)
public function string of_distribute (string as_distributionmethod, string as_distributionoptions)
public function string of_get (string as_name)
public function n_menu_dynamic of_get_menu ()
public function string of_init (long al_reportconfigid)
public function string of_init (long al_reportconfigid, boolean ab_issavedreport)
public subroutine of_reset ()
public function string of_set (string as_name, string as_value)
public function string of_validate ()
public subroutine of_new ()
public function powerobject of_get_object (string as_name)
public function string of_init (long al_reportconfigid, boolean ab_issavedreport, boolean ab_openinreportmode)
end prototypes

event ue_notify(string as_message, any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	4/18/03 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_return
n_distributioninit ln_distributioninit
n_reporting_object_service ln_reporting_object_service

Choose Case Lower(Trim(as_message))
   Case 'before view saved'
		If IsValid(DataSource) Then
			Choose Case DataSource.TypeOf()
				Case Datawindow!, Datastore!
					ln_distributioninit = Create n_distributioninit
					ln_distributioninit.of_init(DistributionInit)
					ls_return = ln_distributioninit.of_save_options(DataSource)
					Destroy ln_distributioninit
				Case Else
			End Choose
		End If
		
	Case 'after view restored'
		If IsValid(DataSource) Then
			Choose Case DataSource.TypeOf()
				Case Datawindow!, Datastore!
					ln_distributioninit = Create n_distributioninit
					ls_return = ln_distributioninit.of_restore_options(DataSource)
					If Left(Lower(Trim(ls_Return)), 6) <> 'error:' Then
						DistributionInit = ls_return
					End If
					Destroy ln_distributioninit
				Case Else
			End Choose
		End If
	Case 'set report entity'
		//------------------------------------------------------------
		// Modify the entity based on the message
		//------------------------------------------------------------
		This.of_set('EntityName', String(aany_argument))

	Case 'add to desktop'
		ln_reporting_object_service = Create n_reporting_object_service
		ln_reporting_object_service.of_add_to_desktop(String(Lower(aany_argument)), RprtCnfgID, UserID, ReportConfigNestedID)
		Destroy ln_reporting_object_service

	Case 'menucommand', 'distribute'
		Choose Case Lower(Trim(String(aany_argument)))
			Case 'large report'
				IsLargeReport = Not IsLargeReport
			Case Else
				If IsValid(DataSource) Then
					DataSource.Event Dynamic ue_notify(as_message, aany_argument)
				End If
		End Choose
   Case Else
End Choose

end event

public function string of_get_savedreportfilename (ref string s_filename, long al_blobobjectid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_savedreportfilename()
//	Arguments:  ab_blobath - blob path,
//					an_blob_manipulator - Pointer the the blob manipulator to avoid reinstantiating a big object
//					al_blobobjectid - the blobobjectid of the saved report.
//	Overview:   Return correct file path for a saved report or a string that starts with the word "ERROR" 
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
long 		l_return
blob 		blob_blobobject
string 	s_path_components[]
String	s_pathname
String	ls_originalfilename

n_blob_manipulator ln_blob_manipulator
//n_string_functions ln_string_functions
n_common_dialog ln_common_dialog 

If FileExists(s_filename) Then Return ''

If IsBatchMode Then Return 'Error:  The file ' + s_filename + ' no longer exists'

ls_originalfilename = s_filename

//----------------------------------------------------------------------------------------------------------------------------------
// If file isn't available, ask if they want to find the file.
//-----------------------------------------------------------------------------------------------------------------------------------
l_return = gn_globals.in_messagebox.of_messagebox_question( 'The file "' + s_filename + '" was not found.~r~nWould you like you specify its location', YesNo!, 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// If they choose to locate the file themselves, parse out the path into its file and path components.
//-----------------------------------------------------------------------------------------------------------------------------------
If l_return <> 1 Then Return 'Error:  The file ' + s_filename + ' no longer exists'

gn_globals.in_string_functions.of_parse_string(s_filename, "\", s_path_components[])

If UpperBound(s_path_components[]) > 1 Then
	s_filename = s_path_components[UpperBound(s_path_components[])]
	s_pathname = Left(s_filename,Pos(s_filename,s_filename) - 1)
Else
	s_filename = s_filename
	s_pathname = ''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Pop the windows open file dialog, set the current directory
//-----------------------------------------------------------------------------------------------------------------------------------
s_pathname = ''
ln_common_dialog = Create n_common_dialog
ln_common_dialog.of_setcurrentdirectory(s_pathname)
ln_common_dialog.of_getfileopenname("Find the file" + s_filename, s_pathname, s_filename, Right(s_filename,3), Right(s_filename,3) + " Files (*." + Right(s_filename,3) + "),*." + Right(s_filename,3))						
Destroy ln_common_dialog

//-----------------------------------------------------------------------------------------------------------------------------------
// If they still haven't found the file, it's time to say goodnight... Otherwise, update the blob accordingly to the new file.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(s_filename) Or Len(Trim(s_filename)) = 0 Then Return "Error: The file " + ls_originalfilename + "no longer exists"

//-----------------------------------------------------------------------------------------------------------------------------------
//	Ensure the file types match between what was originally saved and what they're trying to replace it with.
//-----------------------------------------------------------------------------------------------------------------------------------
If Upper(Right(s_filename, 3)) <> Upper(Right(ls_originalfilename, 3)) Then
	gn_globals.in_messagebox.of_messagebox_validation( 'The file extension for the selected file, "' + s_filename + '" does not match the report type')
	Return "Error: The file type selected did not match the report type."
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Update the blob path to the newly specified blob path.
//-----------------------------------------------------------------------------------------------------------------------------------
blob_blobobject = blob(s_pathname)

ln_blob_manipulator = Create n_blob_manipulator
If ln_blob_manipulator.of_update_blob(blob_blobobject,al_blobobjectid,FALSE) = -1 Then
	Destroy ln_blob_manipulator
	Return "Error: The file path ~"" + s_pathname + "~" was unable to be saved to the database."
End If

Destroy ln_blob_manipulator

Return ''
end function

public function n_entity_drag_message of_get_selected_keys ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_get_selected_keys()
// Overrides:  No
// Overview:   This will put the values into a message object
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------
NonVisualObject ln_service
n_entity_drag_message ln_entity_drag_message

If IsValid(DataSource) Then
	Choose Case Datasource.TypeOf()
		Case Datawindow!, Datastore!
			ln_service = DataSource.Dynamic of_get_service_manager().of_get_service('n_navigation_options')
			If IsValid(ln_service) Then ln_entity_drag_message = ln_service.Dynamic of_determine_selected_rows()
	End Choose
End If

Return ln_entity_drag_message
end function

public function long of_redirect_event (string as_eventname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, keycode key, unsignedlong keyflags);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, key, keyflags)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, long row, ref dwobject dwo, string data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, row, dwo, data)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, long rowcount);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, rowcount)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, long scrollpos, long pane);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, scrollpos, pane)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, xpos, ypos, row, dwo)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, ref dragobject source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, source)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, ref dragobject source, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, source, row, dwo)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, sqlpreviewfunction request, sqlpreviewtype sqltype, ref string sqlsyntax, dwbuffer buffer, long row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, request, sqltype, sqlsyntax, buffer, row)
		End If
	End If
End If

Return ll_return
end function

public function long of_redirect_event (string as_eventname, unsignedlong flags, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_return
SetNull(ll_return)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Redirect the event to the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(DataSource) Then
	If Lower(Trim(ReportDocumentType)) = 'powerbuilder datawindow' Then
		ln_datawindow_graphic_service_manager 	= DataSource.Dynamic of_get_service_manager()
		If IsValid(ln_datawindow_graphic_service_manager) Then
			ll_return = ln_datawindow_graphic_service_manager.of_redirect_event(as_eventname, flags, xpos, ypos)
		End If
	End If
End If

Return ll_return
end function

public function string of_retrieve (long al_value);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will retrieve the report dao</Description>
<Arguments>
	<Argument Name="al_value">The Report Config ID</Argument>
</Arguments>
<CreatedBy></CreatedBy>
<Created></Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

String	ls_return, ls_notreferencedatamode = 'N'
long i_i

This.SetTransObject(SQLCA)

in_update_array[1].retrieve(al_value)
in_update_array[2].retrieve(al_value,is_qualifier)
in_update_array[3].retrieve(al_value,is_qualifier)

OpenedInReferenceDataMode = Not IsInitialized Or (IsInitialized And OpenedInReferenceDataMode)

for i_i = 4 to upperbound(in_update_array) 
	in_update_array[i_i].retrieve(al_value)
next

If OpenedInReferenceDataMode Then
	in_checkout.of_add_tableid(is_qualifier, al_value)
	if Not in_checkout.of_checkout(gn_globals.il_userid) Then
		ib_readonly = true
		ls_return = in_checkout.of_get_messagestring()
	end if 
End If

If ls_return <> '' Then
	This.of_init(al_value, False, False)
Else
	ls_return = This.of_init(al_value, False, False)
End If

Return ls_return
end function

public function long of_retrieve (string as_retrievalarguments);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will retrieve the report using a double-pipe (||) delimited string</Description>
<Arguments>
	<Argument Name="as_retrievalarguments">The retrieval arguments</Argument>
</Arguments>
<CreatedBy></CreatedBy>
<Created></Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Long	ll_return

n_datawindow_tools ln_datawindow_tools

ln_datawindow_tools = Create n_datawindow_tools
ll_return = Long(ln_datawindow_tools.of_retrieve(This, as_retrievalarguments, '||'))
Destroy ln_datawindow_tools

Return ll_return
end function

public subroutine of_retrieve_distributionmethods (ref string s_distribution_methods[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve_distributionmethods()
//	Created by:	
//	History: 	 First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_dao ln_dao
Long	ll_index

ln_dao = of_get_child('DistributionOptions')

For ll_index = 1 To ln_dao.rowcount()
	s_distribution_methods[UpperBound(s_distribution_methods[]) + 1] = ln_dao.GetItemString(ll_index, 'DistributionMethod')
Next
end subroutine

public function string of_retrieveusingregistryvalue (string as_reportregistryvalue);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_reportconfig_id()
// Arguments:   as_reportname - The report name
// Overview:    This will return the report config id for the report name
// Created by:  
// History:     First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_reportconfigid

n_registry ln_registry

ll_reportconfigid = Long(ln_registry.of_get_registry_key('Reporting Architecture\Report Names\' + Trim(as_reportregistryvalue)))

Return This.of_retrieve(ll_reportconfigid)
end function

public subroutine of_set_nonvisual (boolean ab_nonvisual);Datastore ln_datastore
If IsValid(Datasource) Then Return

RunningNonvisually = ab_nonvisual

If IsInitialized Then
	ln_datastore = Create n_datastore
	This.of_set_object('Datasource', ln_datastore)
End If
end subroutine

public function string of_set_object (string as_name, powerobject ao_object);String	ls_return

Choose Case Lower(Trim(as_name))
	Case 'datasource'
		If Not IsValid(DataSource) Then
			This.of_init_datasource(ao_object)
		End If
	Case 'transactionobject'
		TransactionObject = ao_object
	Case 'alternatedistributiondatasource'
		AlternateDistributionDataSource	= ao_object
End Choose

Return ls_return
end function

public subroutine of_set_options (string as_options);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_options()
//	Arguments:  as_options	- an options list in argument=value format with || separating them
//	Overview:   This will apply a list of options
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_return
String	ls_Name[]
String	ls_Value[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the reportoptions into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_arguments(as_options, '||', ls_Name[], ls_Value[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Pass each one into the of_set function
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_Name[]), UpperBound(ls_Value[]))
	This.of_set(Trim(ls_Name[ll_index]), Trim(ls_Value[ll_index]))
Next
end subroutine

public function string of_init (string as_reportregistryvalue);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_reportconfig_id()
// Arguments:   as_reportname - The report name
// Overview:    This will return the report config id for the report name
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_reportconfigid

n_registry ln_registry

ll_reportconfigid = Long(ln_registry.of_get_registry_key('Reporting Architecture\Report Names\' + Trim(as_reportregistryvalue)))

Return This.of_init(ll_reportconfigid)
end function

protected function string of_init_datasource (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  al_reportconfigid	- The reportconfig id or the saved report id depending on the second variable
//					ab_issavedreport	- Whether or not the report is a saved report
//	Overview:   This will initialize all the variables on this object
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_return
Boolean	lb_DatObjectIsValid
Long		ll_row
String	ls_qualifier
String	ls_filename
String	ls_return
String	ls_text
Blob		lblob_blobobject

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore	lds_report_information
Datawindow	ldw_datawindow
Datastore	lds_datastore
//n_rtf_document_builder ln_rtf_document_builder
n_blob_manipulator ln_blob_manipulator
//n_class_functions ln_class_functions
NonVisualObject	ln_service

If Not IsValid(ao_datasource) Then Return ''

//If TrackStatistics Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent(Name + ' (Initialize Datawindow and Services)', 'Reporting')
//	End If
//End If

If ao_datasource <> DataSource Then
	gn_globals.in_subscription_service.of_subscribe(This, 'Before View Saved', ao_datasource)
	gn_globals.in_subscription_service.of_subscribe(This, 'After View Restored', ao_datasource)
	gn_globals.in_subscription_service.of_subscribe(This, 'set report entity', ao_datasource)
End If

DataSource = ao_datasource

//-----------------------------------------------------------------------------------------------------------------------------------
// Suppress error events if we are in batch mode
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Datasource.TypeOf()
	Case Datawindow!
		ldw_datawindow = DataSource
		If IsBatchMode Then
			DataSource.Dynamic of_suppressdberrorevent(IsBatchMode)
			DataSource.Dynamic of_suppresserrorevent(IsBatchMode)
		End If
	Case Datastore!
		lds_datastore = DataSource
	Case OLEObject!
	Case Else
End Choose

Choose Case Lower(Trim(ReportDocumentType))
	Case Lower('PowerBuilder Datawindow'), Lower('DTN Notification')
		//---------------------------------------------------------------------------
		// Set the batch mode on the service manager so all the services will know
		//---------------------------------------------------------------------------
		DataSource.Dynamic of_get_service_manager().of_set_batchmode(IsBatchMode)

		Choose Case ReportType
			Case 'R'
				If (Trim(DocumentName) <> '' And Not IsNull(DocumentName)) Or (Trim(DataObjectName) <> '' And Not IsNull(DataObjectName)) Then
					Choose Case Datasource.TypeOf()
						Case Datawindow!
							If Len(Trim(DocumentName)) > 0 And Not IsNull(DocumentName) Then
								ldw_datawindow.DataObject = DocumentName
							Else
								ldw_datawindow.DataObject = DataObjectName
							End If
						Case Datastore!
							If Len(Trim(DocumentName)) > 0 And Not IsNull(DocumentName) Then
								lds_datastore.DataObject = DocumentName
							Else
								lds_datastore.DataObject = DataObjectName
							End If
					End Choose
				End If

			Case 'S'
				If Not FileExists(DocumentName) Then
//					If TrackStatistics Then
//						If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//							gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Datawindow and Services)')
//						End If
//					End If
					Return "ERROR: The specified file does not exist."
				End If

				Choose Case Upper(Trim(FileType))
					Case 'RAD'
						Choose Case Datasource.TypeOf()
							Case Datawindow!
								ldw_datawindow.DataObject = 'd_dummy_rtfcontainer'
							Case Datastore!
								lds_datastore.DataObject = 'd_dummy_rtfcontainer'
						End Choose
						
						ln_blob_manipulator = Create n_blob_manipulator
						ls_text = String(ln_blob_manipulator.of_build_blob_from_file(DocumentName))
						Destroy ln_blob_manipulator

	//					ln_rtf_document_builder = Create n_rtf_document_builder
	//					ln_rtf_document_builder.of_build_rightangledocument(DataSource, ls_text)
	//					Destroy ln_rtf_document_builder
						
					Case "TEXT,FALSE", "TEXT", "TXT", "CSV,FALSE", "CSV"
						Choose Case Datasource.TypeOf()
							Case Datawindow!
								ldw_datawindow.DataObject = 'd_container_text'
							Case Datastore!
								lds_datastore.DataObject = 'd_container_text'
						End Choose
						
						ln_blob_manipulator = Create n_blob_manipulator
						ls_text = String(ln_blob_manipulator.of_build_blob_from_file(DocumentName))
						Destroy ln_blob_manipulator
		
						Datasource.Dynamic SelectText(1, 1, 1, 1000)
						Datasource.Dynamic ReplaceText(ls_text)

					Case Else
						If Trim(DocumentName) <> '' And Not IsNull(DocumentName) Then
							Choose Case Datasource.TypeOf()
								Case Datawindow!
									ldw_datawindow.DataObject = DocumentName
								Case Datastore!
									lds_datastore.DataObject = DocumentName
							End Choose
						End If
				End Choose

			Case 'I'
				If Trim(DataObjectName) <> '' And Not IsNull(DataObjectName) Then
					If DataSource.Dynamic Create(DataObjectName) < 0 Then
//						If TrackStatistics Then
//							If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//								gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Datawindow and Services)')
//							End If
//						End If
						Return 'ERROR:  Could not create report from imported syntax'
					End If
				Else
//					If TrackStatistics Then
//						If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//							gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Datawindow and Services)')
//						End If
//					End If
					Return 'ERROR:  Could not create report from imported syntax'
				End If
		End Choose

		Choose Case Datasource.TypeOf()
			Case Datawindow!
				lb_DatObjectIsValid = IsValid(ldw_datawindow.Object)
			Case Datastore!
				lb_DatObjectIsValid = IsValid(lds_datastore.Object)
		End Choose

		If Not lb_DatObjectIsValid Then
			If Trim(DataObjectName) <> '' Or Trim(DataObjectName) <> '' Then
//				If TrackStatistics Then
//					If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//						gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Datawindow and Services)')
//					End If
//				End If

				If IsSavedReport Then
					Return 'Error:  The file (' + DocumentName + ') is not valid for this report (SvdRprtID = ' + String(SavedReportID) + ')'
				Else
					If ReportType = 'I' Then
						Return 'Error:  The imported report does not have valid syntax (RprtCnfgID = ' + String(RprtCnfgID) + ')'
					Else
						Return 'Error:  Dataobject (' + DataObjectName + ') was not valid for this report (RprtCnfgID = ' + String(RprtCnfgID) + ')'
					End If
				End If
			End If
		Else
			//-----------------------------------------------------
			// Set whether or not this is a rich text datawindow
			//-----------------------------------------------------
			If IsNumber(DataSource.Dynamic Describe("DataWindow.RichText.Backcolor")) Then
				of_set('IsRichTextDatawindow', 'Y')
			Else
				of_set('IsRichTextDatawindow', 'N')
			End If
			
			//------------------------------------------------------------
			// Secure the document if they don't have modify rights
			//------------------------------------------------------------
			If IsRichTextDatawindow Then
//				If Not gn_globals.in_security.of_get_folder_security(FolderID, 'Report') > 1 Then DataSource.Dynamic Modify("DataWindow.RichText.ReadOnly=Yes")
			End If
			
			//-----------------------------------------------------
			// Set the transaction object
			//-----------------------------------------------------
			DataSource.Dynamic SetTransObject(TransactionObject)
	
			//------------------------------------------------------------
			// This will actually create the services in memory
			//------------------------------------------------------------
			If IsBatchMode Then DataSource.Dynamic of_get_service_manager().of_set_batchmode(True)
			If of_get('UseReportViewService')	= 'Y'		Then DataSource.Dynamic of_add_service('n_dao_dataobject_state')
			If of_get('UseRowFocusService') = 'Y'			Then DataSource.Dynamic of_add_service('n_rowfocus_service')
			If of_get('UseColumnResizingService') = 'Y'	Then DataSource.Dynamic of_add_service('n_column_sizing_service')
			If of_get('UseDynamicGroupingService') = 'Y'	Then DataSource.Dynamic of_add_service('n_group_by_service')
			If of_get('UseFormattingService') = 'Y'		Then DataSource.Dynamic of_add_service('n_datawindow_formatting_service')
			If of_get('UseAggregationService') = 'Y'		Then DataSource.Dynamic of_add_service('n_aggregation_service')
			If of_get('UseDropDownCachingService') = 'Y'	Then DataSource.Dynamic of_add_service('n_dropdowndatawindow_caching_service')
			If of_get('UseSortingService') = 'Y'			Then DataSource.Dynamic of_add_service('n_sort_service')
			If of_get('UseConversionService') = 'Y'		Then DataSource.Dynamic of_add_service('n_datawindow_conversion_service')
			If of_get('UseColumnSelectionService') = 'Y'	Then DataSource.Dynamic of_add_service('n_show_fields')
			If of_get('UseCalendarService') = 'Y'			Then DataSource.Dynamic of_add_service('n_calendar_column_service')
			If of_get('UseRejectRedService') = 'Y'			Then DataSource.Dynamic of_add_service('n_reject_invalids')
			If of_get('UseAutofillService') = 'Y'			Then DataSource.Dynamic of_add_service('n_autofill')
			If of_get('UseKeyboardDefaultService') = 'Y'	Then DataSource.Dynamic of_add_service('n_keydown_date_defaults')
			If of_get('UseTreeviewService') = 'Y'			Then DataSource.Dynamic of_add_service('n_datawindow_treeview_service')
			If of_get('UseDAOService') = 'Y'					Then DataSource.Dynamic of_add_service('n_dao_service')
			If Len(Trim(EntityName)) > 0 	Then DataSource.Dynamic of_add_service('n_navigation_options')
			
			DataSource.Dynamic of_create_services()
		End If
		
		ln_service = DataSource.Dynamic of_get_service('n_dao_dataobject_state')
		If IsValid(ln_service) Then
			ln_service.Dynamic of_set_original_entity(String(EntityName))
			ln_service.Dynamic of_apply_default()
		End If
		
		//------------------------------------------------------------
		// Initialize the navigation options service
		//------------------------------------------------------------
		ln_service = DataSource.Dynamic of_get_service('n_navigation_options')
		If IsValid(ln_service) Then
			ln_service.Dynamic of_init(SQLCA, DataSource, String(EntityName))
			ln_service.Dynamic of_set_dragdrop(IsDragDropEnabled)
		End If
	Case Else
		If Trim(DocumentName) <> '' Then
			If Not FileExists(DocumentName) And Pos(Lower(DocumentName), 'http:') = 0 And Pos(Lower(DocumentName), 'ftp:') = 0 Then
//				If TrackStatistics Then
//					If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//						gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Datawindow and Services)')
//					End If
//				End If

				Return "ERROR: The specified file does not exist (" + DocumentName + ')'
			End If
			
			DataSource.Event Dynamic ue_notify("Retrieve", DocumentName)
		End If
End Choose

/**///Figure out the entity thing, this code got messed up at some time in the past

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the return string
//-----------------------------------------------------------------------------------------------------------------------------------
DataSource.Event Dynamic ue_post_initialize()

Choose Case Lower(Trim(ReportDocumentType))
	Case Lower('PowerBuilder Datawindow')
		If ReportType = 'S' Then
			DataSource.Event Dynamic RetrieveEnd(DataSource.Dynamic RowCount())
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Simulate a view being restored so the DistributionInit field will be materialized
//-----------------------------------------------------------------------------------------------------------------------------------
This.Event ue_notify('After View Restored', '')

//If TrackStatistics Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Datawindow and Services)')
//	End If
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the return string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public subroutine of_settransobject (transaction axctn_transaction);Super::of_settransobject(axctn_transaction)
it_transobject = axctn_transaction
This.of_set_object('TransactionObject', axctn_transaction)
end subroutine

public function string of_save ();String	ls_return
ls_return = Super::of_save()

gn_globals.in_subscription_service.of_message('Refresh Cache', 'ReportConfig')
gn_globals.in_subscription_service.of_message('Refresh Cache', 'NestedReportView')
gn_globals.in_subscription_service.of_message('Refresh Cache', 'ReportView')
gn_globals.in_subscription_service.of_message('Refresh Cache', 'ReportConfigDistributionMethod')

return ls_return
end function

public subroutine of_apply_overrides ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_overrides()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_empty[]
Long		ll_index

For ll_index = 1 To Min(UpperBound(OverrideOptionName[]), UpperBound(OverrideOptionValue[]))
	This.of_set(OverrideOptionName[ll_index], OverrideOptionValue[ll_index])
Next

OverrideOptionName[]		= ls_empty[]
OverrideOptionValue[]	= ls_empty[]


end subroutine

public function string of_distribute (string as_distributionmethod);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_distribute()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_UsingDistributionList
Long		ll_index
Long		ll_index2
Long		ll_index3
String	ls_return
String	ls_return_append
String	ls_distributionoptions
String	ls_distributionmethod[]
String	ls_distributionmethod_distributionlist[]
String	ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
n_distributioninit ln_distributioninit_distributionlist

SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine if we are using distribution lists
//-----------------------------------------------------------------------------------------------------------------------------------
lb_UsingDistributionList = Lower(Trim(This.of_get('UsingDistributionList'))) = 'true' Or Upper(Trim(This.of_get('UsingDistributionList'))) = 'Y'

//-----------------------------------------------------------------------------------------------------------------------------------
// Set this flag so the object knows that it's in distribution mode and certain things are ignored
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_set('WeAreDistributing', 'Y')

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse on the @@@ since there could be multiple methods
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(as_distributionmethod, '@@@') > 0 Then
	gn_globals.in_string_functions.of_parse_string(as_distributionmethod, "@@@", ls_distributionmethod[])	
Else
	gn_globals.in_string_functions.of_parse_string(as_distributionmethod, ",", ls_distributionmethod[])
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the DistributionList method if it's not there.  This will give us a place holder when looping
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_UsingDistributionList Then
	For ll_index = 1 To UpperBound(ls_distributionmethod[])
		If Lower(Trim(ls_distributionmethod[ll_index])) = 'distributionlist' Then Exit

		If ll_index = UpperBound(ls_distributionmethod[]) Then
			ls_distributionmethod[UpperBound(ls_distributionmethod[]) + 1] = 'DistributionList'
			Exit
		End If
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If there were no distribution methods, add DistributionList
	//-----------------------------------------------------------------------------------------------------------------------------------
	If UpperBound(ls_distributionmethod[]) = 0 Then
		ls_distributionmethod[UpperBound(ls_distributionmethod[]) + 1] = 'DistributionList'
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the distribution methods and process the string and distribute
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_distributionmethod[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse on the @@@ so we can look at the distribution method.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(Trim(ls_distributionmethod[ll_index])) = 0 Or Upper(Trim(ls_distributionmethod[ll_index])) = 'N' Then Continue

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If this is a distribution list, we need to distribute differently
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lb_UsingDistributionList And Lower(Trim(ls_distributionmethod[ll_index])) = 'distributionlist' Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// This will load the distribution object with the contact information
		//-----------------------------------------------------------------------------------------------------------------------------------
		ln_distributioninit_distributionlist = Create n_distributioninit
		ln_distributioninit_distributionlist.of_set_distributionlists(This.of_get('DistributionListIDs'))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through all the contacts that will be receiving this document
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index2 = 1 To UpperBound(ln_distributioninit_distributionlist.DistributionListContactID[])
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Parse the distribution methods for the contact into an array
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_distributionmethod_distributionlist[] = ls_empty[]
			gn_globals.in_string_functions.of_parse_string(ln_distributioninit_distributionlist.DistributionListDistributionMethod[ll_index2], '||', ls_distributionmethod_distributionlist[])

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Load the distribution options into the distribution object
			//-----------------------------------------------------------------------------------------------------------------------------------
			ln_distributioninit_distributionlist.of_init(ln_distributioninit_distributionlist.DistributionListDistributionOptions[ll_index2])
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Loop through the distribution methods and distribute the document
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index3 = 1 To UpperBound(ls_distributionmethod_distributionlist[])
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Continue if the distributiom method is none or invalid
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Len(Trim(ls_distributionmethod_distributionlist[ll_index3])) = 0 Or Upper(Trim(ls_distributionmethod_distributionlist[ll_index3])) = 'N' Then Continue

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Get the options for this distribution method, then append the contact's options
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_distributionoptions = This.of_getitem(1, ls_distributionmethod_distributionlist[ll_index3] + '_options')
				If Len(Trim(ls_distributionoptions)) > 0 Then ls_distributionoptions = Trim(ls_distributionoptions) + '||'
				ls_distributionoptions = Trim(ls_distributionoptions) + Trim(ln_distributioninit_distributionlist.of_get_expression(ls_distributionmethod_distributionlist[ll_index3]))
				If Right(ls_distributionoptions, 2) = '||' Then ls_distributionoptions = Left(ls_distributionoptions, Len(ls_distributionoptions) - 2)
					
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Distribute the document
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_return = This.of_distribute(ls_distributionmethod_distributionlist[ll_index3], ls_distributionoptions)
	
				If Len(ls_return) > 0 Then
					If Len(ls_return_append) > 0 Then
						ls_return_append	= ls_return_append + '~r~n' + ls_return
					Else
						ls_return_append	= ls_return
					End If
				End If
			Next
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Reset the distribution options for the next contact
			//-----------------------------------------------------------------------------------------------------------------------------------
			ln_distributioninit_distributionlist.of_reset()
		Next
		
		Destroy ln_distributioninit_distributionlist			
	Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Distribute the document using the distribution method specified, while getting the corresponding options
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = This.of_distribute(ls_distributionmethod[ll_index], This.of_getitem(1, ls_distributionmethod[ll_index] + '_options'))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add the return to the string
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Len(ls_return) > 0 Then
			If Len(ls_return_append) > 0 Then
				ls_return_append	= ls_return_append + '~r~n' + ls_return
			Else
				ls_return_append	= ls_return
			End If
		End If
	End If
Next
	
This.of_set('WeAreDistributing', '')

Return ls_return_append
end function

public function string of_distribute (string as_distributionmethod, string as_distributionoptions);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_distribute()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	b_PrintPreviewWasTurnedOn = False
Long 		ll_row
Long		ll_return
String	ls_return
String 	ls_objectname

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_dao 						ln_dao
nonvisualobject 			ln_distribution
//n_rtf_document_builder 	ln_rtf_document_builder
n_registry					ln_registry

//-----------------------------------------------------------------------------------------------------------------------------------
// Return empty string if we are not distributing
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(as_distributionmethod)) = 'none' Or Upper(Trim(as_distributionmethod)) = 'N' Then Return ''

If Not IsValid(This.of_get_object('DistributionDataSource')) Then Return 'Error:  Datasource is not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the distribution options dao
//-----------------------------------------------------------------------------------------------------------------------------------
ln_dao = This.of_get_child('DistributionOptions')

//-----------------------------------------------------------------------------------------------------------------------------------
// If the row is greater than zero, get the information
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_dao) Then Return 'Error:  The distribution method dao was not available for this report'

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the distribution method in the dao
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = ln_dao.find('Lower(distributionmethod) = "' + string(Trim(Lower(as_distributionmethod))) + '"', 1, ln_dao.rowcount())
	
//-----------------------------------------------------------------------------------------------------------------------------------
// If the row is greater than zero, get the information
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row > 0 Then ls_objectname = ln_dao.GetItemString(ll_row, "distributionobject")

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we have any errors
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row <= 0 Or IsNull(ls_objectname) Or Trim(ls_objectname) = '' Then Return 'Error:  The distribution method was not valid for this report or the distribution object was not able to be found'

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the object specified for this distribution method
//-----------------------------------------------------------------------------------------------------------------------------------
ln_distribution = Create Using ls_objectname

//-----------------------------------------------------------------------------------------------------------------------------------
// If the object isn't valid return
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_distribution) Then Return 'Error:  Could not create distribution object (' + ls_objectname + ')'

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message before the generation of the document.  This is so the graphic services can do what they need to.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('before generate', '', This.of_get_object('DistributionDataSource'))
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Make the spacer go away.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case This.of_get_object('DistributionDataSource').TypeOf()
	Case Datawindow!, Datastore!
		This.of_get_object('DistributionDataSource').Dynamic Modify("spacer.Visible='0'")

		//-----------------------------------------------------------------------------------------------------------------------------------
		//	If it's an RTF datwindow, flip it into Print Preview mode because we have experienced margin problems when we don't do this.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsNumber(This.of_get_object('DistributionDataSource').Dynamic Describe("DataWindow.RichText.InputFieldBackColor")) Then
			If Lower(Trim(This.of_get_object('DistributionDataSource').Dynamic Describe("DataWindow.Print.Preview"))) <> 'yes' Then
				If Lower(Trim(ln_registry.of_get_registry_key('Reporting Architecture\RichText Format\PreviewBeforePrint'))) = 'yes' Then
					b_PrintPreviewWasTurnedOn = TRUE
					This.of_get_object('DistributionDataSource').Dynamic Modify("DataWindow.Print.Preview=Yes")
					//ln_rtf_document_builder = Create n_rtf_document_builder
					//ln_rtf_document_builder.of_determine_margins(This.of_get_object('DistributionDataSource'))
					//ln_rtf_document_builder.of_apply_margins(This.of_get_object('DistributionDataSource'))
					//Destroy ln_rtf_document_builder
				End If
			End If
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the polymorphic function to distribute the report
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_set('WeAreDistributing', 'Y')
ls_return = ln_distribution.Dynamic Function of_distribute(This, as_distributionoptions, '')
This.of_set('WeAreDistributing', '')

If Not IsBatchMode And Len(ls_return) > 0 Then/**///Move to u_search
	gn_globals.in_messageBox.of_messagebox_validation(ls_return)
End If

Choose Case This.of_get_object('DistributionDataSource').TypeOf()
	Case Datawindow!, Datastore!
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	Turn PrintPreview off if we're the ones who turned it on.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If b_PrintPreviewWasTurnedOn Then
			This.of_get_object('DistributionDataSource').Dynamic Modify("DataWindow.Print.Preview=No")
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	Change the spacer back to visible after printing
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_get_object('DistributionDataSource').Dynamic Modify("spacer.Visible='1'")
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
//	Publish a message after the generation of the document.  This is so the graphic services can do what they need to.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('after generate', '', This.of_get_object('DistributionDataSource'))
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the message
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public function string of_get (string as_name);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get()
//	Arguments:  as_name - The name of the variable that you want
//	Overview:   This will return any variable on the object
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// If this object is not yet initialized, we need to return the overridden value first
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsInitialized Then
	For ll_index = 1 To Min(UpperBound(OverrideOptionName[]), UpperBound(OverrideOptionValue[]))
		If Lower(Trim(as_name)) = Lower(Trim(OverrideOptionName[ll_index])) Then Return OverrideOptionValue[ll_index]
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Case for all variables
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_name))
	Case 'openedinreferencedatamode'
		If OpenedInReferenceDataMode Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isrichtextdatawindow'
		If IsRichTextDatawindow Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isbatchmode'
		If IsBatchMode Then 
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'issavedreport'
		If IsSavedReport Then 
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isimportedcriteriadataobject'
		If IsImportedCriteriaDataObject Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isimporteddataobject'
		If IsImportedDataObject Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'allowaddingtodesktops'
		If AllowAddingToDesktops Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'allowclosing'
		If AllowClosing Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'allowcriteria'
		If AllowCriteria Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'allowretrieve'
		If AllowRetrieve Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'rprtcnfgid'
		Return String(RprtCnfgID)
	Case 'folderid'
		Return String(FolderID)
	Case 'reportdatabaseid'
		Return String(ReportDatabaseID)
	Case 'documenttemplateid'
		Return String(RprtCnfgID)
	Case 'dataobjectblobobjectid'
		Return String(DataObjectBlobObjectID)
	Case 'criteriadataobjectblobobjectid'
		Return String(CriteriaDataObjectBlobObjectID)
	Case 'reportdocumenttypeid'
		Return String(ReportDocumentTypeID)
	Case 'helpid'
		Return String(HelpID)
	Case 'wordtemplateblobobjectid'
		Return String(WordTemplateBlobObjectID)
	Case 'nestedreportrowid'
		Return String(NestedReportRowID)
	Case 'name'
		Return Name
	Case 'description'
		Return Description
	Case 'dataobject', 'dataobjectname'
		Return DataObjectName
	Case 'datadaoobject'
		Return DataDAOObject
	Case 'criteriadaoobject'
		Return CriteriaDAOObject
	Case 'criteriauserobject'
		Return CriteriaUserObject
	Case 'displayuserobject'
		Return DisplayUserObject
	Case 'adapterobject'
		Return AdapterObject
	Case 'reporttype'
		Return ReportType
	Case 'criteriatype'
		Return CriteriaType
	Case 'reportingservicesoptions'
		Return ReportingServicesOptions
	Case 'entityname'
		Return EntityName
	Case 'blobtype'
		Return BlobType
	Case 'filetype'
		Return FileType
	Case 'archiveobject'
		Return ArchiveObject
	Case 'displayobjecticon'
		Return DisplayObjectIcon
	Case 'savedreportblobobjectid'
		Return String(savedreportblobobjectid)
	Case 'savedreportid'
		Return String(savedreportid)
	Case 'savedreportuserid'
		Return String(savedreportuserid)
	Case 'savedreportrevisionuserid'
		Return String(savedreportrevisionuserid)
	Case 'savedreportrevisionlevel'
		Return String(savedreportrevisionlevel)
	Case 'savedreportdocumentarchivetypeid'
		Return String(savedreportdocumentarchivetypeid)
	Case 'savedreportapprovaluserid'
		Return String(savedreportapprovaluserid)
	Case 'savedreportdocumenttypeid'
		Return String(savedreportdocumenttypeid)
	Case 'savedreporttype'
		Return SavedReportType
	Case 'savedreportdistributionmethod'
		Return SavedReportDistributionMethod
	Case 'savedreportfilename'
		Return SavedReportFileName
	Case 'issavedreportdistributed'
		If IsSavedReportDistributed Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'savedreportrevisiondate'
		Return gn_globals.in_string_functions.of_convert_datetime_to_string(SavedReportRevisionDate)
	Case 'savedreportdistributiondate'
		Return gn_globals.in_string_functions.of_convert_datetime_to_string(SavedReportDistributionDate)
	Case 'savedreportapprovaldate'
		Return gn_globals.in_string_functions.of_convert_datetime_to_string(SavedReportApprovalDate)
	Case 'usecriteriadefaultingservice'
		If UseCriteriaDefaultingService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usefilterservice'
		If UseFilterService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usedynamicgroupingservice'
		If UseDynamicGroupingService Then
			Return 'Y'
		Else
			Return 'N'
		End If
 	Case 'useconversionservice'
		If UseConversionService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usesortingservice'
		If UseSortingService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isdefaultshowcriteria'
		If IsDefaultShowCriteria Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isautoretrieve'
		If IsAutoRetrieve Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isdragdropenabled'
		If IsDragDropEnabled Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usecolumnresizingservice'
		If UseColumnResizingService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usereportviewservice'
		If UseReportViewService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usecolumnselectionservice'
		If UseColumnSelectionService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'entityname'
		Return EntityName
	Case 'documentname'
		Return DocumentName
	Case 'usepivotservice'
		If UsePivotService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'useaggregationservice'
		If UseAggregationService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usecalendarservice'
		If UseCalendarService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usedropdowncachingservice'
		If UseDropDownCachingService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'userowfocusservice'
		If UseRowFocusService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'useformattingservice'
		If UseFormattingService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'userejectredservice'
		If UseRejectRedService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'useautofillservice'
		If UseAutofillService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usekeyboarddefaultservice'
		If UseKeyboardDefaultService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usetreeviewservice'
		If UseTreeviewService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'usedaoservice'
		If UseDAOService Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'islargereport'
		If IsLargeReport Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'isfavoritereport'
		If IsFavoriteReport Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'userid'
		Return String(UserID)
	Case 'reportdefaultid'
		Return String(ReportDefaultID)
	Case 'trackstatistics'
		If TrackStatistics Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'reportconfignestedid'
		Return String(ReportConfigNestedID)
	Case 'retrievestartdatetime'
		Return gn_globals.in_string_functions.of_convert_datetime_to_string(SavedReportApprovalDate)
	Case 'reportdocumenttype'
		Return ReportDocumentType
	Case 'reportconfignesteddetailid'
		Return String(ReportConfigNestedDetailID)
	Case 'bookmarkname'
		Return BookmarkName
	Case 'defaultdocumentarchivetypefileextension'
		Return DefaultDocumentArchiveTypeFileExtension
	Case 'defaultdocumentarchivetypeid'
		Return String(DefaultDocumentArchiveTypeID)
	Case 'distributioninit'
		Return DistributionInit
	Case Else
		For ll_index = 1 To Min(UpperBound(CustomOptionName[]), UpperBound(CustomOptionValue[]))
			If Lower(Trim(as_name)) = Lower(Trim(CustomOptionName[ll_index])) Then Return CustomOptionValue[ll_index]
		Next
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the return string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function n_menu_dynamic of_get_menu ();//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_printpreview
Boolean	IsMaintenanceWindow			= False
Boolean	lb_IsGlobal[]
Boolean	lb_IsCreatedByThisUser[]
Long		ll_index, i
Long		ll_ids[]
Long		ll_empty[]
Long		ll_idnty[]
String 	ls_descriptions[]
String	ls_empty[]
String	s_distribution_methods[]
String	ls_views[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_menu_dynamic				ln_menu_dynamic
n_menu_dynamic				ln_menu_dynamic_return
n_menu_dynamic				ln_menu_dynamic_cascade
NonVisualObject 			ln_object
n_reporting_object_service	ln_reporting_object_service
n_pivot_table_view_service ln_pivot_table_view_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Create a dynamic menu and set the target object as this object
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic = create n_menu_dynamic
ln_menu_dynamic.of_set_target(this)

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine some properties of the report
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_retrieve_distributionmethods(s_distribution_methods[])

IsMaintenanceWindow = Upper(Trim(This.of_get('IsMaintenanceWindow'))) = 'Y'

Choose Case Lower(Trim(ReportDocumentType))
	Case Lower('PowerBuilder Datawindow'), Lower('DTN Notification')
		If DataSource.TypeOf() = Datawindow! Then
			ln_menu_dynamic.of_add_item('&Customize This Report...', 'menucommand', 'customize report', DataSource.GetParent())/**/
			ln_menu_dynamic.of_add_item('-', '', '')
		End If
		
		lb_printpreview = (Lower(Trim(Datasource.Dynamic Describe("DataWindow.Print.Preview"))) = 'yes')

		If IsMaintenanceWindow Then
			ln_menu_dynamic.of_add_item('&Print Selection List', 'distribute', 'print', DataSource)/**/
		End If

		If Not ReportType = 'S' And AllowRetrieve Then
			ln_menu_dynamic.of_add_item('&Retrieve', 'menucommand', 'retrieve', Datasource)/**/
			ln_menu_dynamic.of_add_item('-', '', '')
		End If
	Case Else
		ln_menu_dynamic.of_add_item('Refresh', 'refresh', '', Datasource)/**/
End Choose

If UpperBound(s_distribution_methods[]) > 0 And Not IsMaintenanceWindow Then
	For i = 1 to UpperBound(s_distribution_methods[])
		If Lower(Trim(s_distribution_methods[i])) = 'print' Then
			ln_menu_dynamic.of_add_item("Print Report", 'distribute', 'print', DataSource)/**/
			Exit
		End If
	Next

	ln_menu_dynamic.of_add_item('Distribute Report (Save, Fax, Email, etc.)...', 'distribute', '', DataSource)/**/
End If

Choose Case Lower(Trim(ReportDocumentType))
	Case Lower('DTN Notification')
		If IsValid(Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')) Then
			ln_menu_dynamic.of_add_item('Print Preview', 'print preview', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')).Checked = lb_printpreview
			ln_menu_dynamic.of_add_item('-', '', '')
			ln_menu_dynamic.of_add_item('Undo Last Change', 'undolastchange', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')).Enabled = Datasource.Dynamic CanUndo()
		End If
	Case Lower('PowerBuilder Datawindow')
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Treat saved reports differently
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsMaintenanceWindow Then
			If Not ReportType = 'S' Then
				If AllowRetrieve Then
					ln_menu_dynamic.of_add_item('&Append Data on Retrieve', 'toggle append data', '', DataSource).Checked = Datasource.Dynamic of_IsAppending()
					If Datasource.TypeOf() = Datawindow! Then
						ln_menu_dynamic.of_add_item('Auto-Retrieve Report', 'toggle autorefresh data', '', DataSource).Visible = False
						ln_menu_dynamic.of_add_item('Set Auto-Retrieve Time', 'set autorefresh time', '', DataSource).Visible = False
					End If
					ln_menu_dynamic.of_add_item('-', '', '')
				End If
				
				ln_menu_dynamic.of_add_item('Is &Large Report', 'menucommand', 'large report', This).Checked = IsLargeReport
			Else
				ln_menu_dynamic.of_add_item('-', '', '')
			End If
		End If
		
		If Not IsMaintenanceWindow Then
			If IsValid(Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')) Then
				ln_menu_dynamic.of_add_item('Print Preview', 'print preview', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')).Checked = lb_printpreview
			End If
			
			If Not IsRichTextDatawindow And Datasource.TypeOf() = Datawindow! Then
				ln_menu_dynamic.of_add_item('Freeze Columns (Split Scrolling)', 'horizontalsplitscrolling', '', Datasource).Checked = DataSource.Dynamic of_HSplitScroll()
			End If
			
			If IsValid(Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')) Then
				ln_menu_dynamic.of_add_item('-', '', '')
				
				If IsRichTextDatawindow And ReportType = 'S' Then
					ln_menu_dynamic.of_add_item('Save Over Archive', 'menucommand', 'save over archive', Datasource)/**/
				End If
	
				If Not IsRichTextDatawindow Then
					ln_menu_dynamic.of_add_item('Zoom &In', 'zoomin', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service'))
					ln_menu_dynamic.of_add_item('Zoom &Out', 'zoomout', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service'))
				End If
				
				If lb_printpreview And Not IsRichTextDatawindow Then
					ln_menu_dynamic.of_add_item('-', '', '')
					ln_menu_dynamic.of_add_item('Show R&ulers', 'rulers', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')).Checked = (Lower(Trim(Datasource.Dynamic Describe("DataWindow.Print.Preview.Rulers"))) = 'yes')
					ln_menu_dynamic.of_add_item('-', '', '')
					ln_menu_dynamic.of_add_item('First Page', 'firstpage', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service'))
					ln_menu_dynamic.of_add_item('Previous Page', 'previouspage', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service'))
					ln_menu_dynamic.of_add_item('Next Page', 'nextpage', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service'))
					ln_menu_dynamic.of_add_item('Last Page', 'lastpage', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service'))
				End If
			
				If IsRichTextDatawindow Then
					If lb_printpreview Then ln_menu_dynamic.of_add_item('-', '', '')
					ln_menu_dynamic.of_add_item('Show Toolbar', 'showtoolbar', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')).Checked = (Lower(Trim(Datasource.Dynamic Describe("DataWindow.RichText.Toolbar"))) = 'yes')
					If lb_printpreview Then
						ln_menu_dynamic.of_add_item('Show Header/Footer', 'showheaderfooter', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service'))
					End If
					ln_menu_dynamic.of_add_item('Show Tab Bar', 'showtabbar', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')).Checked = (Lower(Trim(Datasource.Dynamic Describe("DataWindow.RichText.Tabbar"))) = 'yes')
					If Datasource.TypeOf() = Datawindow! Then
						ln_menu_dynamic.of_add_item('Undo Last Change', 'undolastchange', '', Datasource.Dynamic of_get_service_manager().of_get_service('n_datawindow_formatting_service')).Enabled = Datasource.Dynamic CanUndo()
					End If
				End If
			End If
		End If
End Choose


ln_menu_dynamic.of_add_item('-', '', '')

If Not IsMaintenanceWindow Then
	Choose Case Lower(Trim(ReportDocumentType))
		Case Lower('PowerBuilder Datawindow')
			If IsValid(Datasource.Dynamic of_get_service('n_dao_dataobject_state')) Then

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Create another menu that will be attached as a cascaded menu
				//-----------------------------------------------------------------------------------------------------------------------------------
				ln_menu_dynamic_cascade = ln_menu_dynamic.of_add_item('Report Views', '', '')

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Add some generic items
				//-----------------------------------------------------------------------------------------------------------------------------------
				ln_menu_dynamic_cascade.of_add_item('Save &This Report View...', 'save view', '', Datasource.Dynamic of_get_service('n_dao_dataobject_state'))
				ln_menu_dynamic_cascade.of_add_item('Restore Original Report &View', 'restore view', '', Datasource.Dynamic of_get_service('n_dao_dataobject_state'))
				ln_menu_dynamic_cascade.of_add_item('-', '', '', This)
				ln_menu_dynamic_cascade.of_add_item('Export Current Report View To File...', 'export view', '', Datasource.Dynamic of_get_service('n_dao_dataobject_state'))
				ln_menu_dynamic_cascade.of_add_item('Import Report View From File...', 'import view', '', Datasource.Dynamic of_get_service('n_dao_dataobject_state'))
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Add the dataobject state menu items
				//-----------------------------------------------------------------------------------------------------------------------------------
				Datasource.Dynamic of_get_service('n_dao_dataobject_state').of_get_views(ll_idnty[], ls_views[], lb_IsGlobal[], lb_IsCreatedByThisUser[])
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Return if there are no views to add to the menu
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(ls_views[]) > 0 Then
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Add each view, checking the menu if it is the current view
					//-----------------------------------------------------------------------------------------------------------------------------------
					ln_menu_dynamic_cascade.of_add_item('-', '', '', Datasource.Dynamic of_get_service('n_dao_dataobject_state'))
					For ll_index = 1 To UpperBound(ls_views[])
						ln_menu_dynamic_cascade.of_add_item('Apply Report View - ' + ls_views[ll_index], 'Apply View ID', String(ll_idnty[ll_index]), Datasource.Dynamic of_get_service('n_dao_dataobject_state')).Checked = (Datasource.Dynamic of_get_service('n_dao_dataobject_state').of_get_current_view_id() = ll_idnty[ll_index])
					Next
				End If			
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Create another menu that will be attached as a cascaded menu
			//-----------------------------------------------------------------------------------------------------------------------------------
			ln_reporting_object_service = Create n_reporting_object_service
			ll_ids[]				= ll_empty[]
			ls_descriptions[] = ls_empty[]
			ln_reporting_object_service.of_get_nested_reports(RprtCnfgID, UserID, ll_ids[], ls_descriptions[])
			Destroy ln_reporting_object_service

			ln_menu_dynamic_cascade = ln_menu_dynamic.of_add_item('Nested Reports', '', '')
			ln_menu_dynamic_cascade.Visible = UpperBound(ls_descriptions[]) > 0
			ln_menu_dynamic_cascade.of_add_item('Save Nested Report', 'menucommand', 'save nested report').Visible = False
			ln_menu_dynamic_cascade.of_add_item('-', '', '')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add all the views
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index = 1 To UpperBound(ls_descriptions[])
				ln_menu_dynamic_cascade.of_add_item(ls_descriptions[ll_index] + '...', 'apply nested report', String(ll_ids[ll_index]), DataSource)/**/
			Next

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add Pivot table Menu Items
			//-----------------------------------------------------------------------------------------------------------------------------------
			If UsePivotService Then
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Get the views from the pivot table service
				//-----------------------------------------------------------------------------------------------------------------------------------
				ln_pivot_table_view_service = Create n_pivot_table_view_service
				ln_pivot_table_view_service.of_set_userid(UserID)
				ln_pivot_table_view_service.of_set_reportconfigid(RprtCnfgID)
				ll_ids[]				= ll_empty[]
				ls_descriptions[] = ls_empty[]
				ln_pivot_table_view_service.of_get_views(ll_ids[], ls_descriptions[])
				Destroy ln_pivot_table_view_service

				//-----------------------------------------------------------------------------------------------------------------------------------
				// Create another menu that will be attached as a cascaded menu
				//-----------------------------------------------------------------------------------------------------------------------------------
				ln_menu_dynamic_cascade = ln_menu_dynamic.of_add_item('Pivot Reports', '', '')
				ln_menu_dynamic_cascade.of_add_item('New Pivot...', 'menucommand', 'pivottable', Datasource)/**/
				ln_menu_dynamic_cascade.of_add_item('-', '-', '')
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Add these views to the menu as cascaded items
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(ls_descriptions[]) > 0 Then
					If UpperBound(ls_descriptions[]) > 0 Then
	
						//-----------------------------------------------------------------------------------------------------------------------------------
						// Add all the views
						//-----------------------------------------------------------------------------------------------------------------------------------
						For ll_index = 1 To UpperBound(ls_descriptions[])
							ln_menu_dynamic_cascade.of_add_item(ls_descriptions[ll_index] + '...', 'pivot table view', String(ll_ids[ll_index]), Datasource)/**/
						Next

						ln_menu_dynamic_cascade.of_add_item('-', '-', '')
						
						For ll_index = 1 To UpperBound(ls_descriptions[])
							ln_menu_dynamic_cascade.of_add_item(ls_descriptions[ll_index] + ' (Open as New Report)...', 'pivot table view new', String(ll_ids[ll_index]), Datasource)/**/
						Next
					End If
				End If
			End If
	End Choose
End If

//-------------------------------------------------------------------
// Add cascading menu to add reports to desktops
//-------------------------------------------------------------------
//If ReportType <> 'S' And AllowAddingToDesktops Then
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	// Create a new menu and set this as it's target object.  Add a spacer and the cascade menuitem.
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	ln_menu_dynamic_cascade = ln_menu_dynamic.of_add_item('Add Report to Desktop', '', '')
//	
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	// Add options to the cascaded menu
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	ln_menu_dynamic_cascade.of_add_item('Add Report to RightAngle Explorer Favorites', 'add to desktop', 'smart search', This)
//	ln_menu_dynamic_cascade.of_add_item('Add Report to Trader~'s Desktop', 'add to desktop', 'traders desktop', This)
//	ln_menu_dynamic_cascade.of_add_item('Add Report to Scheduling Desktop', 'add to desktop', 'scheduling desktop', This)
//	ln_menu_dynamic_cascade.of_add_item('Add Report to Accounting Desktop', 'add to desktop', 'accounting desktop', This)
//	ln_menu_dynamic_cascade.of_add_item('Add Report to Pricing Desktop', 'add to desktop', 'portfolio analysis desktop', This)
//End if

If Not IsMaintenanceWindow Then
	ln_menu_dynamic.of_add_item('-', '', '')
	ln_menu_dynamic.of_add_item('Manage All Views...', 'manage report views', '', Datasource)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the close item to the desktop
//-----------------------------------------------------------------------------------------------------------------------------------
If AllowClosing Then
	ln_menu_dynamic.of_add_item('-', '', '')
	ln_menu_dynamic.of_add_item('&Close Report', 'menucommand', 'close', Datasource)
End If

Return ln_menu_dynamic
end function

public function string of_init (long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  al_reportconfigid	- The reportconfig id or the saved report id depending on the second variable
//	Overview:   This will initialize all the variables on this object
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_init(al_reportconfigid, False, True)
end function

public function string of_init (long al_reportconfigid, boolean ab_issavedreport);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  al_reportconfigid	- The reportconfig id or the saved report id depending on the second variable
//					ab_issavedreport	- Whether or not the report is a saved report
//	Overview:   This will initialize all the variables on this object
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_init(al_reportconfigid, ab_issavedreport, True)
end function

public subroutine of_reset ();	String	ls_empty[]

	IsInitialized 					= False
	OpenedInReferenceDataMode	= False

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	SetNull(RprtCnfgID)
	SetNull(FolderID)
	SetNull(ReportDatabaseID)
	SetNull(DataObjectBlobObjectID)
	SetNull(CriteriaDataObjectBlobObjectID)
	SetNull(ReportDocumentTypeID)
	SetNull(HelpID)
	SetNull(ReportDefaultID)
	SetNull(WordTemplateBlobObjectID)
	SetNull(NestedReportRowID)
	SetNull(ReportConfigNestedID)
	SetNull(ReportConfigNestedDetailID)
	SetNull(RetrieveStartDateTime)
	SetNull(DefaultDocumentArchiveTypeID)
//	SetNull(DocumentTemplateID)

	TransactionObject									= SQLCA
	UserID 												= gn_globals.il_userid
	Name 													= ''
	Description 										= ''
	EntityName 											= ''
	BlobType 											= ''
	FileType 											= ''
	DisplayObjectIcon 								= ''
	DocumentName										= ''
	ReportDocumentType								= ''
	BookmarkName										= ''
	DefaultDocumentArchiveTypeFileExtension	= ''
	DistributionInit									= ''
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Object Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	SetNull(DataObjectName)
	DataDAOObject					= ''
	CriteriaDAOObject 			= ''
	CriteriaUserObject 			= ''
	DisplayUserObject 			= ''
	AdapterObject 					= ''
	ReportType 						= ''
	CriteriaType 					= ''
	ReportingServicesOptions 	= ''
	ArchiveObject 					= 'n_save_report'
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Miscellaneous Reporting Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	IsDefaultShowCriteria			= False
	IsAutoRetrieve						= False
	IsSavedReport						= False
	IsImportedCriteriaDataObject	= False
	IsImportedDataObject				= False
	IsLargeReport						= False
	IsDragDropEnabled					= False
	IsBatchMode							= False
	IsFavoriteReport					= False
	IsRichTextDatawindow				= False
	AllowAddingToDesktops			= True
	AllowClosing						= True
	AllowRetrieve						= True
	AllowCriteria						= True
	TrackStatistics					= True
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Service Options/**/These should be deleted because they are custom
	//-----------------------------------------------------------------------------------------------------------------------------------
	UseCriteriaDefaultingService	= True
	UseReportViewService				= False
	UseRowFocusService				= False
	UseColumnResizingService		= False
	UseDynamicGroupingService		= False
	UseFormattingService				= False
	UseAggregationService			= False
	UseDropDownCachingService		= False
	UseSortingService					= False
	UseFilterService					= False
	UseConversionService				= False
	UseColumnSelectionService		= False
	UsePivotService					= False
	UseCalendarService				= False
	UseRejectRedService				= False
	UseAutofillService				= False
	UseKeyboardDefaultService		= False
	UseTreeviewService				= False
	UseDAOService						= False
	
	UsingUOMConversion				= False
	UsingCurrencyConversion			= False

	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Saved Report Options
	//-----------------------------------------------------------------------------------------------------------------------------------
	SetNull(SavedReportBlobObjectID)
	SetNull(SavedReportID)
	SetNull(SavedReportUserID)
	SetNull(SavedReportRevisionUserID)
	SetNull(SavedReportRevisionLevel)
	SetNull(SavedReportDocumentArchiveTypeID)
	SetNull(SavedReportApprovalUserID)
	SetNull(SavedReportDocumentTypeID)
	SavedReportType 									= ''
	SavedReportDistributionMethod 				= ''
	SavedReportFileName 								= ''
	IsSavedReportDistributed						= False
	SavedReportRevisionDate 						= DateTime(1900-01-01, Time('00:00:00'))
	SavedReportDistributionDate 					= DateTime(1900-01-01, Time('00:00:00'))
	SavedReportApprovalDate 						= DateTime(1900-01-01, Time('00:00:00'))
	
	CustomOptionName[]		= ls_empty[]
	CustomOptionValue[]		= ls_empty[]
	
	If IsInitialized Then
		OverrideOptionName[]		= ls_empty[]
		OverrideOptionValue[]	= ls_empty[]
	End If
end subroutine

public function string of_set (string as_name, string as_value);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return
Long		ll_index

If Not IsInitialized Then
	OverrideOptionName[UpperBound(OverrideOptionName[]) + 1]		= as_name
	OverrideOptionValue[UpperBound(OverrideOptionName[])]			= as_value
	Return ''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Case for all variables
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_name))
	Case 'reportdocumenttypeid'
		ReportDocumentTypeID = Long(as_value)
		
		Select	Name
		Into		:ReportDocumentType
		From		ReportDocumentType
		Where		RprtDcmntTypID = :ReportDocumentTypeID
		Using		SQLCA;
		
	Case 'isrichtextdatawindow'
		IsRichTextDatawindow = Upper(Trim(as_value)) = 'Y'
		
		If IsRichTextDatawindow Then
			IsLargeReport					= False
			IsDragDropEnabled				= False
			UseReportViewService			= False
			UseRowFocusService			= False
			UseColumnResizingService	= False
			UseDynamicGroupingService	= False
			UseFormattingService			= True
			UseAggregationService		= False
			UseDropDownCachingService	= False
			UseSortingService				= False
			UseFilterService				= False
			UseConversionService			= False
			UseColumnSelectionService	= False
			UsePivotService				= False
			UseCalendarService			= False
			UseRejectRedService			= False
			UseAutofillService			= False
			UseKeyboardDefaultService	= False
			UseTreeviewService			= False
		End If
	Case 'isbatchmode'
		IsBatchMode	= Upper(Trim(as_value)) = 'Y'
		
		If IsBatchMode Then
			IsDefaultShowCriteria 			= False
			IsDragDropEnabled					= False

//			If gb_runningvisually Then
//				IsAutoRetrieve						= False
//				UseDynamicGroupingService		= False
//				UseColumnResizingService		= False
//				UseColumnSelectionService		= False
//				UseCriteriaDefaultingService	= False
//				UseFilterService					= False
//			End If
		End If

	Case 'isdefaultshowcriteria', 'show criteria'
		IsDefaultShowCriteria	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode And Not IsSavedReport And AllowCriteria
	Case 'isautoretrieve', 'autoretrieve'
		IsAutoRetrieve	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode And Not IsSavedReport And AllowRetrieve
	Case 'isdragdropenabled', 'drag drop', 'dragdrop'
		IsDragDropEnabled	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'allowaddingtodesktops', 'allow adding to other desktops'
		AllowAddingToDesktops = Upper(Trim(as_value)) = 'Y' And Not IsSavedReport
	Case 'allowclosing', 'allow close'
		AllowClosing = Upper(Trim(as_value)) = 'Y'
	Case 'allowretrieve', 'allow retrieve'
		AllowRetrieve = Upper(Trim(as_value)) = 'Y' And Not IsSavedReport And Not IsBatchMode
		If Not AllowRetrieve Then IsAutoRetrieve = False
	Case 'allowcriteria', 'allow criteria'
		AllowCriteria = Upper(Trim(as_value)) = 'Y' And Not IsSavedReport
		If Not AllowCriteria Then IsDefaultShowCriteria = False
	Case 'islargereport', 'islargereport', 'islarge'
		IsLargeReport	= Upper(Trim(as_value)) = 'Y'
	Case 'isfavoritereport'
		IsFavoriteReport	= Upper(Trim(as_value)) = 'Y'
	Case 'entityname', 'entity'
		EntityName	= as_value

	Case 'usefilterservice', 'filtering', 'filter'
		UseFilterService	= Upper(Trim(as_value)) = 'Y'
	Case 'usedynamicgroupingservice', 'grouping', 'dynamicgrouping'
		UseDynamicGroupingService	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'useconversionservice'
		UseConversionService	= Upper(Trim(as_value)) = 'Y'
	Case 'currency conversion'
		UsingCurrencyConversion			= Upper(Trim(as_value)) = 'Y'
		UseConversionService				= UsingCurrencyConversion Or UsingUOMConversion
	Case 'uom conversion'
		UsingUOMConversion				= Upper(Trim(as_value)) = 'Y'
		UseConversionService				= UsingCurrencyConversion Or UsingUOMConversion
	Case 'usesortingservice', 'sorting', 'sorttype'
		UseSortingService	= Upper(Trim(as_value)) = 'Y' Or Upper(Trim(as_value)) = 'S' Or Upper(Trim(as_value)) = 'M'
	Case 'usecolumnresizingservice', 'column sizing', 'columnresizing'
		UseColumnResizingService	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'usereportviewservice', 'state saving', 'viewsaving'
		UseReportViewService	= Upper(Trim(as_value)) = 'Y' And Not IsSavedReport
	Case 'usecolumnselectionservice', 'column selection', 'columnselection'
		UseColumnSelectionService	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'usecriteriadefaultingservice', 'default criteria'
		UseCriteriaDefaultingService	= Upper(Trim(as_value)) = 'Y' Or IsBatchMode
	Case 'usepivotservice', 'pivottables'
		UsePivotService	= Upper(Trim(as_value)) = 'Y'
	Case 'useaggregationservice', 'aggregationservice'
		UseAggregationService	= Upper(Trim(as_value)) = 'Y'
	Case 'usecalendarservice', 'calendarservice'
		UseCalendarService	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'usedropdowncachingservice', 'dropdowncaching'
		UseDropDownCachingService	= Upper(Trim(as_value)) = 'Y'
	Case 'userowfocusservice', 'rowselection'
		UseRowFocusService	= Upper(Trim(as_value)) = 'Y'
	Case 'useformattingservice', 'formatting'
		UseFormattingService	= Upper(Trim(as_value)) = 'Y'
	Case 'userejectredservice', 'rejectred'
		UseRejectRedService	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'useautofillservice', 'autofill'
		UseAutofillService	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'usekeyboarddefaultservice', 'keyboarddefault'
		UseKeyboardDefaultService	= Upper(Trim(as_value)) = 'Y' And Not IsBatchMode
	Case 'usetreeviewservice', 'treeviewservice'
		UseTreeviewService	= Upper(Trim(as_value)) = 'Y'
	Case 'usedaoservice', 'daoservice'
		UseDAOService	= Upper(Trim(as_value)) = 'Y' And Not IsSavedReport
	Case 'archiveobject'
		ArchiveObject = Trim(as_value)
	Case 'datadaoobject'
		DataDAOObject = Trim(as_value)
	Case 'criteriadaoobject'
		CriteriaDAOObject = Trim(as_value)
	Case 'userid'
		UserID = Long(as_value)
	Case 'reportdefaultid'
		ReportDefaultID = Long(as_value)
	Case 'rprtcnfgid'
		RprtCnfgID		= Long(as_value)
//	Case 'documenttemplateid'
//		DocumentTemplateID = Long(as_value)
	Case 'savedreportid'
		SavedReportID	= Long(as_value)
	Case 'reportdatabaseid'
		ReportDatabaseID	= Long(as_value)
		TransactionObject	= SQLCA
	Case 'wordtemplateblobobjectid'
		WordTemplateBlobObjectID	= Long(as_value)
		If Not IsNull(WordTemplateBlobObjectID) Then
			BookmarkName 	= 'ObjectID=' + String(WordTemplateBlobObjectID)
		Else
			BookmarkName	= ''
		End If
	Case 'nestedreportrowid'
		NestedReportRowID	= Long(as_value)
	Case 'dataobjectname'
		DataObjectName = Trim(as_value)
	Case 'documentname'
		DocumentName		= as_value
	Case 'name'
		Name	= as_value
	Case 'reportingservicesoptions'
		ReportingServicesOptions = as_value
		This.of_set_options(ReportingServicesOptions)
	Case 'trackstatistics'
		TrackStatistics	= Upper(Trim(as_value)) = 'Y'
	Case 'reportconfignestedid'
		ReportConfigNestedID = Long(as_value)
	Case 'reportconfignesteddetailid'
		ReportConfigNestedDetailID = Long(as_value)
	Case 'retrievestartdatetime'
		RetrieveStartDateTime = gn_globals.in_string_functions.of_convert_string_to_datetime(as_value)
	Case 'bookmarkname'
		BookmarkName = as_value
	Case 'defaultdocumentarchivetypefileextension'
		DefaultDocumentArchiveTypeFileExtension	= as_value
	Case 'defaultdocumentarchivetypeid'
		DefaultDocumentArchiveTypeID = Long(as_value)
	Case 'reporttype'
		ReportType = Trim(Upper(as_value))
	Case 'distributioninit'
		DistributionInit = as_value
	Case Else
		For ll_index = 1 To UpperBound(CustomOptionName[])
			If Lower(Trim(CustomOptionName[ll_index])) = Lower(Trim(as_name)) Then
				CustomOptionValue[ll_index] = as_value
				Return ls_return
			End If
		Next
		
		CustomOptionName[UpperBound(CustomOptionName[]) + 1]	= as_name
		CustomOptionValue[UpperBound(CustomOptionName[])]		= as_value
End Choose

Return ls_return
end function

public function string of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate
//	Arguments:  NONE
//	Overview:   Validation ported from wf_validate_context
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
boolean b_FileSystem, b_ReportFolder
long ll_doctype, ll_reportfolderid, l_rprtcnfgid, l_return
string ls_dataobj, ls_options, ls_savetype, ls_requiresreview, ls_istmplte
long i, l_upperbound
string s_args[], s_values[]
//n_string_functions ln_string_functions


this.accepttext()


If this.of_GetItem(1,"rprtcnfgnme") = '' Then 
	of_send_validation_message(1,'Header','rprtcnfgnme')	
	return 'You must enter a document name'
End If

If this.of_GetItem(1,"rprtcnfgdscrptn") = '' Then 
	of_send_validation_message(1,'Template','rprtcnfgdscrptn')	
	return 'You must enter a document description'
End If

If this.of_GetItem(1,"rprtdcmnttypid") = '' Then 
	of_send_validation_message(1,'Header','rprtdcmnttypid')	
	return 'You must choose a document type' 
End If


ls_istmplte = upper(this.GetitemString(1,'istmplte'))
if IsNull(ls_istmplte) then ls_istmplte = 'N'

choose case ls_istmplte
	case 'Y'
		// if template type is powerbuilder - they must enter a data object
		ll_doctype = long(this.of_getItem(1,"rprtdcmnttypid"))
		ls_dataobj = trim(this.of_getitem(1,"rprtcnfgdtaobjct"))
		if ll_doctype = 1 then // PowerBuilder Report
			if ls_dataobj = ''  then
				of_send_validation_message(1,'Template','rprtcnfgdtaobjct')	
				return 'You must enter a data object for PowerBuilder documents' 
			end if
		else
			if this.of_getitem(1,"rprtcnfgdtaobjct") = '' then
				this.of_setitem(1,"rprtcnfgdtaobjct", ' ')
			end if
		end if
		
		if this.of_getitem(1,'rprtcnfgcrtraobjct') = '' then
			this.of_setitem(1,'rprtcnfgcrtraobjct',' ')
		end if
		
		//-----------------------------------------------------------------------------
		// Check to see if the domain for this template requires review.
		// If so - they must have chosen to archive this template on the distribution
		// options wizard.  On the archive options, they must choose to 
		// 'Save to Database'.
		//-----------------------------------------------------------------------------
		ls_requiresreview = this.of_getitem(1,'requiresreview')
		if lower(trim(ls_requiresreview))  = 'y' then
			ls_options = this.of_getitem(1,'Archive_options')
			//fill in all the options based on the argument string...
			gn_globals.in_string_functions.of_parse_arguments(ls_options,"||",s_args[],s_values[])
			l_upperbound = Min(UpperBound(s_args[]),UpperBound(s_values[]))
			For i = 1 to l_upperbound
				choose case Lower(s_args[i])
					Case 'savetype' 
						ls_savetype = Lower(Trim(s_values[i]))
					Case 'reportfolderid'
						ll_reportfolderid = Long(s_values[i])
				end choose
			next
			if ls_savetype = 'save to file' or ls_savetype = 'none' or IsNull(ll_reportfolderid) or ll_reportfolderid = 0 then
				return 'This Template belongs to a Document Domain that Requires Review.  You must use the Distribution Options Wizard to set up Archiving Options for saving to a database folder'
			end if
		end if
	case else
		If IsNull(this.GetItemNumber(1,'rprtcnfgfldrid')) Then
			of_send_validation_message(1,'Template','rprtcnfgfldrid')	
			return 'You must choose a destination folder for this report'
		End If
		If IsNull(this.GetItemNumber(1,'rprtcnfgrprtdtbseid')) Then
			of_send_validation_message(1,'Template','rprtcnfgrprtdtbseid')	
			return 'You must choose reporting database'
		End If
		//---------------------------------------------------------
		// If the data object has been left blank notify the user
		//---------------------------------------------------------
		//verify not a composite report
		l_rprtcnfgid = this.getitemnumber(1,'RprtCnfgID')
		select RprtCnfgID into :l_return from compositereportconfig where RprtCnfgID = :l_rprtcnfgid;
		if l_return <> l_rprtcnfgid then
			If IsNull(this.GetItemString(1,'rprtcnfgdtaobjct')) Then
				of_send_validation_message(1,'Template','rprtcnfgdtaobjct')	
				return 'You must enter a data object name'
			End If
		end if

		//---------------------------------------------------------
		// If the document type is powerbuilder, they must enter a display object
		//---------------------------------------------------------
		ll_doctype = long(this.of_getItem(1,"rprtdcmnttypid"))
		if ll_doctype = 1 then // PowerBuilder Report
			If IsNull(this.GetItemString(1,'rprtcnfgdsplyobjct')) Then
				of_send_validation_message(1,'Template','rprtcnfgdsplyobjct')	
				return 'You must choose a display object for this report'
			End If
		end if

end choose


Return ''

end function

public subroutine of_new ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_new()
//	Arguments:  
//	Overview:   This will initialize a new template
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------

n_update_tools ln_tools
long ll_fldrid

ln_tools = create n_update_tools

this.insertrow(0)

of_setitem(1,"RprtCnfgID",ln_tools.of_get_key("ReportConfig"))

of_setitem(1,'rprtcnfgshwcrtra','N')
of_setitem(1,'rprtcnfgautortrve','N')
of_setitem(1,'rprtcnfgtpe','R')
of_setitem(1,'rprtcnfgcrtratpe','R')
of_setitem(1,'rprtcnfgcrtraobjct','')
of_setitem(1,'rprtdcmnttypid',1)
of_setitem(1,'istmplte','Y')
OpenedInReferenceDataMode = TRUE

select fldrid
into :ll_fldrid
from folder
where fldrnme like 'Document Template%';

If isnull(ll_fldrid) Or ll_fldrid = 0 then
	select fldrid
	into :ll_fldrid
	from folder
	where fldrnme = 'Architectural Reports';
end if

of_setitem(1,'rprtcnfgfldrid',ll_fldrid)

destroy n_update_tools
end subroutine

public function powerobject of_get_object (string as_name);PowerObject lo_return
Datastore	lds_datasource
long			ll_rprtcnfgnstdid
long			l_reportconfigid
long			ll_dataobjectstateid
long			l_blobid
string		s_argument
string		ls_dataobject
string		ls_error
n_blob_manipulator ln_blob
//n_string_functions ln_string_functions

Choose Case Lower(Trim(as_name))
	Case 'datasource'
		If Not IsValid(DataSource) Then
			If OpenedInReferenceDataMode Then
				Choose Case Lower(Trim(ReportDocumentType))
					Case Lower('PowerBuilder Datawindow'), Lower('DTN Notification')
						lds_datasource = Create Datastore
						if len(DataObjectName) > 40 then //this must be a syntax based datawindow
							lds_datasource.Create(DataObjectName)
						else
							lds_datasource.DataObject	= DataObjectName
						end if
						Return lds_datasource					
					Case Lower('Microsoft Word Document')
						ll_rprtcnfgnstdid = long(this.of_getitem(1,"tmplterprtcnfgnstdid"))
						
						if ll_rprtcnfgnstdid > 0 then
											
							select reportconfignested.RprtCnfgID,Parameter
							into :l_reportconfigid,:s_argument
							from reportconfignested
							Where reportconfignested.RprtcnfgNstdID = :ll_rprtcnfgnstdid;
		
							ll_dataobjectstateid	= Long(gn_globals.in_string_functions.of_find_argument(s_argument, '||', 'dtaobjctstteidnty'))
							
							if ll_dataobjectstateid > 0 then 
		
								Select SavedSyntaxBlobID
								Into :l_blobid
								From DataObjectState 
								Where Idnty = :ll_dataobjectstateid;
								
								ln_blob = create n_blob_manipulator
								ls_dataobject =  string(ln_blob.of_retrieve_blob ( l_blobid ))
								destroy ln_blob
								
								lds_datasource = Create Datastore
								lds_datasource.create(ls_dataobject,ls_error)
								
							else
										
								select RprtCnfgDtaObjct
								Into :ls_dataobject
								from reportconfig
								Where RprtCnfgID = :l_reportconfigid;
								
								lds_datasource = Create Datastore
								lds_datasource.DataObject = ls_dataobject
						
							end if
							
							Return lds_datasource
						end if

				End Choose
			End If
		Else
			Return DataSource
		End If
		
	Case 'transactionobject'
		Return TransactionObject
	Case 'distributiondatasource'
		If IsValid(AlternateDistributionDataSource) Then
			Return AlternateDistributionDataSource
		Else
			Return DataSource
		End If
End Choose

Return lo_return
end function

public function string of_init (long al_reportconfigid, boolean ab_issavedreport, boolean ab_openinreportmode);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  al_reportconfigid	- The reportconfig id or the saved report id depending on the second variable
//					ab_issavedreport	- Whether or not the report is a saved report
//	Overview:   This will initialize all the variables on this object
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_return
Boolean	lb_DatObjectIsValid
Boolean 	lb_error
Long		ll_row
String	ls_qualifier
String	ls_filename
String	ls_return
String	ls_text
Blob		lblob_blobobject

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore ln_datastore
Datastore	lds_report_information
n_blob_manipulator ln_blob_manipulator
n_date_manipulator ln_date_manipulator
NonVisualObject	ln_service

If This.IsInitialized Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the readonly flag
//-----------------------------------------------------------------------------------------------------------------------------------
ib_readonly = ib_readonly Or ab_openinreportmode

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the second argument to the retrieval procedure
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_IsSavedReport Then
	lds_report_information = Create Datastore
	lds_report_information.DataObject = 'd_reportconfig_information_cache'
	lds_report_information.SetTransObject(SQLCA)

	ll_row = lds_report_information.Retrieve(al_reportconfigid, 'S')
//	ll_row = 1
Else
	lds_report_information = gn_globals.in_cache.of_get_cache_reference('ReportConfig')

	If IsValid(lds_report_information) Then
		ll_row = lds_report_information.Find('ReportID = ' + String(al_reportconfigid) + ' And ReportType <> "S"', 1, lds_report_information.RowCount())
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If we didn't get the right number of rows back or got an error, return an error
//-----------------------------------------------------------------------------------------------------------------------------------
lb_error = FALSE

IF IsNull(ll_row) OR Not IsValid(lds_report_information) THEN lb_error = TRUE
IF NOT lb_error THEN
	If ll_row <= 0 Or lds_report_information.RowCount() = 0 THEN lb_error = TRUE
END IF

IF lb_error THEN
	Destroy lds_report_information
	ls_return = 'Error:  Could not retrieve report information for '
	
	If ab_IsSavedReport Then
		ls_return = ls_return + 'saved report '
		Destroy lds_report_information
	Else
		ls_return = ls_return + 'report '
	End If
	
	ls_return = ls_return + String(al_reportconfigid)
	Return ls_return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all variables from the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
RprtCnfgID											= lds_report_information.GetItemNumber(ll_row, 'reportid')
FolderID												= lds_report_information.GetItemNumber(ll_row, 'folderid')
Name													= lds_report_information.GetItemString(ll_row, 'name')
Description											= lds_report_information.GetItemString(ll_row, 'description')
CriteriaUserObject								= lds_report_information.GetItemString(ll_row, 'criteriaobject')
DataObjectName										= lds_report_information.GetItemString(ll_row, 'dataobject')
DisplayUserObject									= lds_report_information.GetItemString(ll_row, 'displayobject')
ReportType											= lds_report_information.GetItemString(ll_row, 'reporttype')
DisplayObjectIcon									= lds_report_information.GetItemString(ll_row, 'reporticon')
IsAutoRetrieve										= Upper(Trim(lds_report_information.GetItemString(ll_row, 'autoretrieve'))) = 'Y'
IsDefaultShowCriteria 							= Upper(Trim(lds_report_information.GetItemString(ll_row, 'showcriteria'))) = 'Y'
ReportDatabaseID									= lds_report_information.GetItemNumber(ll_row, 'reportdbid')
This.of_set('ReportDatabaseID', String(lds_report_information.GetItemNumber(ll_row, 'reportdbid')))
IsImportedCriteriaDataObject					= Upper(Trim(lds_report_information.GetItemString(ll_row, 'criteriatype'))) = "I"
CriteriaDataObjectBlobObjectID				= lds_report_information.GetItemNumber(ll_row, 'criteriablobobjectid')
EntityName											= lds_report_information.GetItemString(ll_row, 'entity')
BlobType												= lds_report_information.GetItemString(ll_row, 'blobtype')
FileType												= lds_report_information.GetItemString(ll_row, 'filetype')
SavedReportID										= lds_report_information.GetItemNumber(ll_row, 'savedreportid')
ArchiveObject										= lds_report_information.GetItemString(ll_row, 'defaultarchiveobject')
ReportingServicesOptions						= lds_report_information.GetItemString(ll_row, 'reportoptions')
AdapterObject										= lds_report_information.GetItemString(ll_row, 'adapterobject')
ReportDocumentTypeID								= lds_report_information.GetItemNumber(ll_row, 'rprtdcmnttypid')
ReportDocumentType								= lds_report_information.GetItemString(ll_row, 'RprtDcmntTypName')
//DocumentTemplateID								= lds_report_information.GetItemNumber(ll_row, 'DcmntTmplteID')
HelpID												= lds_report_information.GetItemNumber(ll_row, 'helpid')
IsImportedDataObject								= Upper(Trim(ReportType)) = "I"
DefaultDocumentArchiveTypeID					= lds_report_information.GetItemNumber(ll_row, 'DefaultDcmntArchvTypID')
DefaultDocumentArchiveTypeFileExtension	= lds_report_information.GetItemString(ll_row, 'DefaultDcmntArchvTypFileExtension')

// Set the ISRichTextDatawindow variable
if left(lower(DisplayUserObject ), 12) = 'u_search_rtf' then
	ISRichTextDatawindow = TRUE
else
	IsRichTextDatawindow = FALSE
end if

// If this is an internet explorer document, then set the document name
If lower(trim(ReportDocumentType)) = 'internet explorer control' then DocumentName = dataobjectname

//If TrackStatistics Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent(Name + ' (Initialize Report)', 'Reporting')
//	End If
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that we are initialized because the next line calls an of_set()
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_openinreportmode Then OpenedInReferenceDataMode = False

IsInitialized							= True

If This.RowCount() = 0 Then This.of_retrieve(RprtCnfgID)


If IsImportedCriteriaDataObject Then
	CriteriaUserObject = 'uo_report_criteria_ud'
End If

If Len(Trim(CriteriaUserObject)) <= 0 Or Lower(Trim(CriteriaUserObject)) = 'uo_report_criteria' Or IsNull(CriteriaUserObject) Then
	AllowCriteria	= False
End If

IsSavedReport							= ab_IsSavedReport

If IsNull(DataObjectName) Then DataObjectName = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set options for when it is a saved report
//-----------------------------------------------------------------------------------------------------------------------------------
If IsSavedReport Then
	SavedReportBlobObjectID	= lds_report_information.GetItemNumber(ll_row, 'reportblobobjectid')

	SavedReportFileName	= DataObjectName
	IsDefaultShowCriteria	= False
	IsAutoRetrieve				= False
	AllowAddingToDesktops	= False
	AllowRetrieve				= False
	AllowCriteria				= False
	UseReportViewService		= False
Else
	DataObjectBlobObjectID	= lds_report_information.GetItemNumber(ll_row, 'reportblobobjectid')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the options for reporting services
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_set('ReportingServicesOptions', ReportingServicesOptions)

//-----------------------------------------------------------------------------------------------------------------------------------
// Process properties based on the report type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Upper(Trim(ReportType))
	Case 'R'
	Case 'S'
		//-----------------------------------------------------------------------------------------------------------------------------------
		//	Retrieve the Binary Object from the database
		//-----------------------------------------------------------------------------------------------------------------------------------
		ln_blob_manipulator = Create n_blob_manipulator
		lblob_blobobject 	= ln_blob_manipulator.of_retrieve_blob(SavedReportBlobObjectID)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If there is a problem return an error
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsNull(lblob_blobobject) Then
			ls_return = ln_blob_manipulator.of_get_error_message()
		Else
			//-----------------------------------------------------------------------------------------------------------------------------------
			//	Based on the type of archive (report or a path) create the filename
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case Lower(Trim(ln_blob_manipulator.of_get_blob_qualifier()))
				Case 'report'
					ls_filename = ln_blob_manipulator.of_determine_filename('TemporarySavedReportFile (' + String(ln_date_manipulator.of_now(), "mm-dd-yyyy hh.mm.ss.fff") + ').' + FileType)
					If Not ln_blob_manipulator.of_build_file_from_blob(lblob_blobobject, ls_filename) Then
						ls_return = 'Error:  Could not build a file from the object stored on the database'
					End If
				Case 'report path'
					ls_filename	= String(lblob_blobobject)
					//ls_return = this.of_get_savedreportfilename(ls_filename, SavedReportBlobObjectID)
			End Choose
		End If
		
		If FileExists(ls_filename) Then
			DocumentName = ls_filename
		End If
		
		Destroy ln_blob_manipulator
		Destroy lds_report_information
	Case 'I'
		//-----------------------------------------------------
		// Get syntax from database for creating dw from syntax
		//-----------------------------------------------------
		ln_blob_manipulator = CREATE n_blob_manipulator
		DataObjectName = String(ln_blob_manipulator.of_retrieve_blob(DataObjectBlobObjectID))
		DESTROY ln_blob_manipulator
		
		//-----------------------------------------------------
		// Validate for returning syntax and create datawindow
		//-----------------------------------------------------
		If Trim(DataObjectName) = '' Or IsNull(DataObjectName) Then
			ls_return = 'ERROR:  Could not import syntax from the database'
		End If
End Choose

This.of_apply_overrides()

If IsNull(DataObjectName) Then DataObjectName = ''
If IsNull(DocumentName) Then DocumentName = ''

If Not IsValid(Datasource) Then
//	If TrackStatistics Then
//		If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Report)')
//		End If
//	End If

	Return ls_return
End If

ls_return = This.of_init_datasource(DataSource)

//If TrackStatistics Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Name + ' (Initialize Report)')
//	End If
//End If

If RunningNonvisually Then
	ln_datastore = Create n_datastore
	This.of_set_object('Datasource', ln_datastore)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the return string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

on n_report.create
call super::create
end on

on n_report.destroy
call super::destroy
end on

event constructor;call super::constructor;This.of_settransobject(SQLCA)
This.of_reset()

of_add_child('EntityConfig','d_report_entityconfig_dao')
of_add_child('DistributionOptions','d_dao_reportconfigdistributionmethod')




end event

event ue_getitem;call super::ue_getitem;n_distributioninit ln_distributioninit
n_dao ln_dao
string s_defaults, s_report, s_value, ls_distributionmethod, ls_distributionoptions, ls_distributionoptionscomputedfield
long l_find, i_i

Choose Case lower(as_column)

	Case 'openedinreferencedatamode'
		if OpenedInReferenceDataMode then
			return 'Y'
		else
			return 'N'
		end if

	Case 'enttyrprtcnfgenttyid'
		ln_dao = of_get_child('EntityConfig')
		If ln_dao.rowcount() > 0 then 
			return ln_dao.of_getitem(1,'EnttyRprtCnfgEnttyID')
		else
			return ''
		end if

	Case 'isnavigationdestination'
		ln_dao = of_get_child('EntityConfig')
		If ln_dao.rowcount() > 0 then 
			return ln_dao.of_getitem(1,'isnavigationdestination')
		else
			return ''
		end if

	Case 'isvisibleinsmartsearchtreeview'
		ln_dao = of_get_child('EntityConfig')
		If ln_dao.rowcount() > 0 then 
			return ln_dao.of_getitem(1,'isvisibleinsmartsearchtreeview')
		else
			return ''
		end if
		
	case 'distributioninitoverrides'
		Return DistributionInit
		
	case 'distributionoptions', 'distributioninit'
		ln_dao = of_get_child('DistributionOptions')
		For i_i = 1 To ln_dao.rowcount()
			ls_distributionmethod	= ln_dao.getitemstring(i_i,'DistributionMethod')
			ls_distributionoptions	= This.Event ue_getitem(1, ls_distributionmethod + '_options')
			
			If Len(ls_distributionoptions) > 0 Then
				ls_distributionoptions = 'DistributionMethod=' + ls_distributionmethod + '||' + ls_distributionoptions
				s_value 	= s_value + ls_distributionoptions + '@@@'
			End If
		Next
		
		return left(s_value,len(s_value) - 3)
		
	Case Else
		if Lower(Trim(Right(as_column, 8))) = '_options' then 

			ln_dao = of_get_child('DistributionOptions')

			ls_distributionmethod 	= left(as_column,len(as_column) - 8)
			l_find 						= ln_dao.find('Lower(distributionmethod) = "' + string(Lower(Trim(ls_distributionmethod))) + '"', 1, ln_dao.rowcount())
			
			If l_find > 0 Then
				s_defaults 					= ln_dao.getitemstring(l_find, 'defaultdistributionoptions')
				s_report 					= ln_dao.getitemstring(l_find, 'reportdistributionmethodoptions')
			End If
			
			
			If Not OpenedInReferenceDataMode Then
				ln_distributioninit = Create n_distributioninit
				ln_distributioninit.of_init(DistributionInit)
				
				If IsValid(DataSource) And Upper(Trim(This.of_get('WeAreDistributing'))) = 'Y' Then
					Choose Case DataSource.TypeOf()
						Case Datawindow!, Datastore!
							ln_distributioninit.of_append(ln_distributioninit.of_get_evaluated_distributioninit(DataSource))
					End Choose
				End If
				
				ls_distributionoptions = ln_distributioninit.of_get_expression(ls_distributionmethod)

				Destroy ln_distributioninit
			End If
			
			if IsNull(s_defaults) then s_defaults = ''
			if IsNull(s_report) then s_report = ''
			If IsNull(ls_distributionoptions) Then ls_distributionoptions = ''
			
			if Trim(s_defaults) <> '' then 
				s_value = s_defaults
			end if
			
			if Trim(s_report) <> '' then 
				If Len(s_value) > 0 Then
					s_value = s_value + '||' + s_report 
				Else
					s_value = s_report 
				End If
			end if
			
			If Len(Trim(ls_distributionoptions)) > 0 Then
				If Len(s_value) > 0 Then
					s_value = s_value + '||' + ls_distributionoptions
				Else
					s_value = ls_distributionoptions
				End If
			End If
			
			If Len(Trim(s_value)) > 0 Then
				s_value = 'DistributionMethod=' + ls_distributionmethod + '||' + s_value
			End If
		

			If Not OpenedInReferenceDataMode Then
				If IsValid(This.of_get_object('DistributionDataSource')) And Upper(Trim(This.of_get('WeAreDistributing'))) = 'Y' Then
					ln_distributioninit = Create n_distributioninit
					ln_distributioninit.of_init(s_value)
					ln_distributioninit.of_evaluate(This.of_get_object('DistributionDataSource'))
					s_value = ln_distributioninit.of_get_expression(ls_distributionmethod)
					Destroy ln_distributioninit
				End If
			End If

			Return s_value
		end if
End Choose

return AncestorReturnValue
end event

event ue_setitem;call super::ue_setitem;n_dao ln_dao
string ls_name[],ls_value[],s_newstring,s_method,s_defaults,ls_newvalue,ls_null, ls_empty[]
long ll_index,l_find
n_distributioninit ln_distributioninit
//n_string_functions ln_string_functions
setnull(ls_null)

Choose Case lower(as_column)
		
	Case 'enttyrprtcnfgenttyid'
		
		
		ln_dao = of_get_child('EntityConfig')
		if long(as_data) > 0 and not ISNULL(as_data)then 
				
			If ln_dao.rowcount() > 0 then 
				ln_dao.of_setitem(1,'EnttyRprtCnfgEnttyID',long(as_data))
			else
				ln_dao.insertrow(0)
				ln_dao.of_setitem(1,'EnttyRprtCnfgEnttyID',long(as_data))		
			end if		

		else	
			if ln_dao.rowcount() > 0 then 
				ln_dao.deleterow(1)
			end if
		end if 
		
	Case 'isnavigationdestination'
		ln_dao = of_get_child('EntityConfig')
		if  not ISNULL(as_data) then 
				
			If ln_dao.rowcount() > 0 then 
				ln_dao.of_setitem(1,'isnavigationdestination',trim(as_data))
			else
				ln_dao.insertrow(0)
				ln_dao.of_setitem(1,'isnavigationdestination',trim(as_data))		
			end if		
		end if 

	Case 'isvisibleinsmartsearchtreeview'
		ln_dao = of_get_child('EntityConfig')
		if ISNULL(as_data) then 
				
			If ln_dao.rowcount() > 0 then 
				ln_dao.of_setitem(1,'isvisibleinsmartsearchtreeview',trim(as_data))
			else
				ln_dao.insertrow(0)
				ln_dao.of_setitem(1,'isvisibleinsmartsearchtreeview',trim(as_data))		
			end if		
		end if 
		
	
	Case 'distributioninit'
		If Not OpenedInReferenceDataMode Then
			ln_distributioninit = Create n_distributioninit
			ln_distributioninit.of_init(as_data)
			For ll_index = 1 To Min(UpperBound(ln_distributioninit.DistributionMethod[]), UpperBound(ln_distributioninit.DistributionOptions[]))
				This.Event ue_setitem(ll_row, ln_distributioninit.DistributionMethod[ll_index] + '_options', ln_distributioninit.DistributionOptions[ll_index])
			Next
			Destroy ln_distributioninit
		End If
	case else
		if lower(right(as_column,8)) = '_options' then 
			s_method = left(as_column,len(as_column) - 8)
			ln_dao = of_get_child('DistributionOptions')
			l_find = ln_dao.find('lower(distributionmethod) = "' + string(Trim(Lower(s_method))) + '"', 1, ln_dao.rowcount())
			s_newstring = string(as_data)

			//-----------------------------------------------------------------------------------------------------------------------------------
			// If we find a row then we must replace any values that are the same as the defaults so they don't override teh default value.
			//-----------------------------------------------------------------------------------------------------------------------------------
			if l_find > 0 then 
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Get the options at the report document type level
				//-----------------------------------------------------------------------------------------------------------------------------------
				s_defaults = ln_dao.getitemstring(l_find, 'defaultdistributionoptions')
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Parse the default options so we can remove them from the string if they haven't changed
				//-----------------------------------------------------------------------------------------------------------------------------------
				gn_globals.in_string_functions.of_parse_arguments(s_defaults, '||', ls_name[], ls_value[])
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Compare the new arguments to the defaults and remove ones that are the same
				//-----------------------------------------------------------------------------------------------------------------------------------
				For ll_index = 1 To UpperBound(ls_name[])
					ls_newvalue	= gn_globals.in_string_functions.of_find_argument(s_newstring, '||', ls_name[ll_index])
					If Lower(Trim(ls_newvalue)) = Lower(Trim(ls_value[ll_index])) Then
						gn_globals.in_string_functions.of_replace_argument(ls_name[ll_index], s_newstring, '||', ls_null)
					End If
				Next
	
				If OpenedInReferenceDataMode Then
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Set the new distribution init field into the column
					//-----------------------------------------------------------------------------------------------------------------------------------
					ln_dao.SetItem(l_find, "ReportDistributionMethodOptions", s_newstring)
				Else
					ls_name[]		= ls_empty[]
					ls_value[]		= ls_empty[]
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Get the options at the report config level
					//-----------------------------------------------------------------------------------------------------------------------------------
					s_defaults = ln_dao.getitemstring(l_find, 'ReportDistributionMethodOptions')
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Parse the default options so we can remove them from the string if they haven't changed
					//-----------------------------------------------------------------------------------------------------------------------------------
					gn_globals.in_string_functions.of_parse_arguments(s_defaults, '||', ls_name[], ls_value[])
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Compare the new arguments to the defaults and remove ones that are the same
					//-----------------------------------------------------------------------------------------------------------------------------------
					For ll_index = 1 To UpperBound(ls_name[])
						ls_newvalue	= gn_globals.in_string_functions.of_find_argument(s_newstring, '||', ls_name[ll_index])
						If Lower(Trim(ls_newvalue)) = Lower(Trim(ls_value[ll_index])) Then
							gn_globals.in_string_functions.of_replace_argument(ls_name[ll_index], s_newstring, '||', ls_null)
						End If
					Next
				End If
			End If
			
			If Not OpenedInReferenceDataMode Then
				If Len(Trim(s_newstring)) = 0 Then
					s_newstring = ''
				ElseIf Pos('||' + Lower(Trim(s_newstring)), '||' + Lower(Trim(s_method)) + '=') <= 0 Then
					s_newstring = 'DistributionMethod=' + s_method + '||' + s_newstring
				End If
				ln_distributioninit = Create n_distributioninit
				ln_distributioninit.of_init(DistributionInit)
				ln_distributioninit.of_delete_options(s_method)
				ln_distributioninit.of_append(s_newstring)
				DistributionInit = ln_distributioninit.of_get_expression()
				Destroy ln_distributioninit
			End If
		End if

End Choose

Return True
end event

event ue_setitemvalidate;call super::ue_setitemvalidate;datastore	ln_datastore
n_dao 		ln_dao
long 			i_i,l_row
string		ls_FileExtension,ls_defaultviewerobject,ls_reportoptiongui, ls_reportoptions
long			ll_defaultdcmntarchvtypid,ll_rprtdcmnttypid


choose case lower(as_column)
	CASE 'rprtcnfgdtaobjct'   //TLK - want the datastore to be available while editing.  Added this and rprtdcmnttypid.  #48931
		DataObjectName =  as_data 

	CASE "rprtcnfgdsplyobjct"
		if left(lower(as_data ), 12) = 'u_search_rtf' then
			IsRichTextDatawindow = TRUE
		else
			IsRichTextDatawindow = FALSE
		end if
		
	CASE "rprtcnfgnme"
		this.of_setitem(1,"rprtcnfgdscrptn",as_data)
		
	case 'rprtdcmnttypid'
		This.of_set('ReportDocumentTypeID', String(as_data))
		
		ll_RprtDcmntTypId = long(as_data)
		
		
		select	defaultreportoptions, Name
		into		:ls_reportoptions, :ReportDocumentType
		from		ReportDocumentType
		where		RprtDcmntTypId = :ll_rprtdcmnttypid;
									
		of_setitem(1,"reportoptions",ls_reportoptions)
		
		if this.rowcount() = 1 then 
			select FileExtension,defaultviewerobject,
			reportoptiongui,defaultdcmntarchvtypid
			into :ls_FileExtension,:ls_defaultviewerobject,
			:ls_reportoptiongui,:ll_defaultdcmntarchvtypid
			from ReportDocumentType
			where RprtDcmntTypId = :ll_RprtDcmntTypId;

			this.of_setitem(1,'RprtCnfgDsplyObjct',ls_defaultviewerobject)
			this.of_setitem(1,'RprtCnfgDtaObjct',' ')
			this.of_setitem(1,'RprtCnfgCrtraObjct',' ')
		end if				

		ln_dao = of_get_child('DistributionOptions')
		
		for i_i = ln_dao.rowcount() to 1 step -1
			ln_dao.deleterow(i_i)
		next
		
		ln_datastore = create datastore
		ln_datastore.dataobject = 'd_distribution_method_wizard_select'
		ln_datastore.settransobject(it_transobject)
		ln_datastore.retrieve(long(as_data))
		for i_i = 1 to ln_datastore.rowcount()
			
			if ln_datastore.getitemstring(i_i,'isdefaultoption') = 'Y' then 
				l_row = ln_dao.InsertRow(0)
				ln_dao.SetItem(l_row,"id",ln_datastore.GetItemNumber(i_i,"id"))
				ln_dao.SetItem(l_row,"rprtcnfgid",long(this.getitemnumber(1,"rprtcnfgid")))
				ln_dao.SetItem(l_row,"distributionmethod",ln_datastore.GetItemString(i_i,"distributionmethod"))
				ln_dao.SetItem(l_row,"defaultdistributionoptions",ln_datastore.GetItemString(i_i,"defaultdistributionoptions"))
			end if
			
		next
		
		destroy ln_datastore
	
	
end choose

return true

end event

