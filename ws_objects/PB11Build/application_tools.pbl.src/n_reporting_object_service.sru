$PBExportHeader$n_reporting_object_service.sru
forward
global type n_reporting_object_service from nonvisualobject
end type
end forward

global type n_reporting_object_service from nonvisualobject
end type
global n_reporting_object_service n_reporting_object_service

forward prototypes
public function string of_schedule_batch_report (string as_processparameter)
public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid, long al_rprtcnfgnstdid)
public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid, long al_rprtcnfgnstdid, string as_argument)
public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid, string as_parameters)
public function boolean of_apply_nested_report (datastore ads_datastore, userobject au_search, long al_row)
public function boolean of_apply_nested_report (userobject au_search, long al_rprtcnfgnstdid)
public subroutine of_get_nested_reports (long al_reportconfigid, long al_userid, ref long al_id[], ref string as_names[])
protected subroutine of_get_nested_reports (ref datastore ads_datastore, userobject au_search, long al_row, boolean ab_getreportviews, boolean ab_getfilterviews, boolean ab_getpivottableviews, boolean ab_saveovercurrenviews)
public subroutine of_removed_from_desktop (graphicobject ago_module, long al_reportconfigid, long al_userid)
public function long of_save_nested_report (userobject au_search, long al_rprtcnfgid, long al_rprtcnfgnstdid, long al_userid, long al_createdbyuserid, string as_name, string as_description, boolean ab_getreportviews, boolean ab_getfilterviews, boolean ab_getpivottableviews, boolean ab_getuomcurrencyviews, boolean ab_allownavigation, boolean ab_nestedreportissavedinsidereportview, boolean ab_saveovercurrentviews)
public function string of_save_nested_report_documenttemplate (userobject au_search)
public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid)
public function string of_get_parameters (userobject au_search, boolean ab_getreportviews, boolean ab_getfilterviews, boolean ab_getpivottableviews, boolean ab_getuomcurrencyviews, boolean ab_saveovercurrentviews)
public function long of_save_nested_report (userobject au_search)
public function string of_create_report_syntax ()
public function string of_new_dynamic_report ()
public function string of_remove_from_desktop (string as_parameters_containing_mdletlrprtid)
end prototypes

public function string of_schedule_batch_report (string as_processparameter);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_key
Long		ll_processgroupid
Long		ll_procesgrouprelationid
//Long		ll_reportconfigcriteriaid
Long		ll_index
String	ls_null
String	ls_usecustomprocessname = 'N'
String	ls_Recurrence
String	ls_customprocessname
String	ls_customprocessdescription
String	ls_queue
String	ls_Name[]
String	ls_Value[]
String	ls_processgroupname 			= 'Batch Report'
String	ls_processgroupdescription	= 'Batch Report'

datetime ldt_nextrundate

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
n_update_tools ln_update_tools

SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the reportoptions into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_arguments(as_processparameter, '||', ls_Name[], ls_Value[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Pass each one into the of_set function
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ls_Name[]), UpperBound(ls_Value[]))
	Choose Case Lower(Trim(ls_Name[ll_index]))
		Case 'usecustomprocessname'
			ls_usecustomprocessname	= ls_Value[ll_index]
			gn_globals.in_string_functions.of_replace_argument('UseCustomProcessName', as_processparameter, '||', ls_null)
		Case 'customprocessname'
			ls_customprocessname	= ls_Value[ll_index]
			gn_globals.in_string_functions.of_replace_argument('CustomProcessName', as_processparameter, '||', ls_null)
		Case 'customprocessdescription'
			ls_customprocessdescription = ls_Value[ll_index]
			gn_globals.in_string_functions.of_replace_argument('CustomProcessDescription', as_processparameter, '||', ls_null)
		Case 'nextrundate'
			ldt_nextrundate = gn_globals.in_string_functions.of_convert_string_to_datetime(ls_Value[ll_index])
			gn_globals.in_string_functions.of_replace_argument('NextRunDate', as_processparameter, '||', ls_null)
		Case 'queue'
			ls_queue = ls_Value[ll_index]
			gn_globals.in_string_functions.of_replace_argument('Queue', as_processparameter, '||', ls_null)
		Case 'recurrence'
			ls_recurrence = ls_Value[ll_index]
			gn_globals.in_string_functions.of_replace_argument('Recurrence', as_processparameter, '||', ls_null)
	End Choose
Next

as_processparameter = "batch report with report defaults:" + as_processparameter

//----------------------------------------------------------------------------------------------------------------------------------
// Get the criteria default and other options
//-----------------------------------------------------------------------------------------------------------------------------------
//ll_reportconfigcriteriaid 	= Long(gn_globals.in_string_functions.of_find_argument(ls_extra_parameters, '||', 'ReportDefaultCriteriaID'))
//ls_usecustomprocessname		= gn_globals.in_string_functions.of_find_argument(ls_extra_parameters, '||', 'UseCustomProcessName')

If Upper(Trim(ls_usecustomprocessname)) = 'Y' And Not IsNull(ls_usecustomprocessname) Then
	If Len(Trim(ls_customprocessname)) = 0 Then
		ls_processgroupname 			= 'Batch Report'
		ls_processgroupdescription = ls_processgroupname
	End If
	
	If Len(Trim(ls_processgroupdescription)) = 0 Then
		ls_processgroupdescription = 'Batch Report'
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the Update Tools
//-----------------------------------------------------------------------------------------------------------------------------------
ln_update_tools = Create n_update_tools

//----------------------------------------------------------------------------------------------------------------------------------
//	Determine ProcessItem for batch reporting.
//-----------------------------------------------------------------------------------------------------------------------------------
Select 	PrcssGrpID
Into		:ll_processgroupid
From		ProcessGroup
Where 	PrcssGrpNme = :ls_processgroupname
Using		SQLCA;

//----------------------------------------------------------------------------------------------------------------------------------
//	If the process wasn't found, it needs to be created
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ll_processgroupid) Or ll_processgroupid <= 0 Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get a new key for ProcessItem
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_key = ln_update_tools.of_get_key("ProcessItem")
	
	If ll_key <= 0 Or IsNull(ll_key) Then Return "Could not get unique key to schedule process"
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the ProcessItem
	//-----------------------------------------------------------------------------------------------------------------------------------
	Insert	ProcessItem
				(
				PrcssItmID,  
				PrcssItmNme,
				PrcssItmDscrptn,
				PrcssItmCmmndLne,
				PrcssItmCmmndTpe,
				PrcssItmPrmtrDscrptn,
				PrcssItmStts 	
				)
	Values	(
				:ll_key,
				:ls_processgroupname,
				:ls_processgroupdescription,
				'n_report_batch',
				'O',
				'Parameters are too lengthy to describe.  Please consult support documentation for details.  This should not be manually created.',
				'A'
				)
	Using		SQLCA;
	
	If SQLCA.SQLCode <> 0 Then
		Return "Could not insert custom process name (" + SQLCA.SQLErrText + ')'
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the ProcessGroup Id for the item we just created
	//-----------------------------------------------------------------------------------------------------------------------------------
	Select 	PrcssGrpID
	Into		:ll_processgroupid
	From		ProcessGroup
	Where 	PrcssGrpNme = :ls_processgroupname
	Using		SQLCA;
	
	If ll_processgroupid <= 0 Or IsNull(ll_processgroupid) Then
		Return "Error:  Process Item was created, but could not create Process Group"
	End If
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Get the Process Relation ID for the Process Group
//-----------------------------------------------------------------------------------------------------------------------------------
Select 	PrcssGrpRltnID
Into		:ll_procesgrouprelationid
From		ProcessGroupRelation
Where		PrcssGrpRltnPrcssGrpID = :ll_processgroupid
Using		SQLCA;

If ll_procesgrouprelationid <= 0 Or IsNull(ll_procesgrouprelationid) Then
	Return "Error:  Process Group was created, but could not create Process Group Relation"
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get a key for the ProcessSchedulerII
//-----------------------------------------------------------------------------------------------------------------------------------
ll_key = ln_update_tools.of_get_key("ProcessSchedulerII")

If ll_key <= 0 Or IsNull(ll_key) Then
	Return "Error:  Could not get unique key for Process Schedule"
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Begin a transaction
//-----------------------------------------------------------------------------------------------------------------------------------
ln_update_tools.of_begin_transaction()

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert a ProcessSchedulerII record
//-----------------------------------------------------------------------------------------------------------------------------------
Insert	ProcessSchedulerII
			(
			PrcssSchdlrIIID,
			PrcssSchdlrIIPrcssGrpID,
			PrcssSchdlrIINxtRnDteTme,
			PrcssSchdlrStts,
			PrcssSchdlrPrd,
			PrcssQNme
			)
Values
			(
			:ll_key,	
			:ll_processgroupid,
			:ldt_nextrundate,
			"A",
			:ls_Recurrence,
			:ls_queue
			)
Using		SQLCA;

If SQLCA.SQLCode <> 0 Then
	ln_update_tools.of_rollback_transaction()
	Return "Error:  Could not insert Process Schedule record (" + SQLCA.SQLErrText + ')'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert a ProcessParameter record
//-----------------------------------------------------------------------------------------------------------------------------------
Insert	ProcessParameter
			(
			PrcssPrmtrPrcssSchdlrIIID,
			PrcssPrmtrPrcssGrpRltnID,
			PrcssPrmtrPrmtr
			)
Values
			(
			:ll_key,	
			:ll_procesgrouprelationid,
			:as_processparameter
			)
Using		SQLCA;

If SQLCA.SQLCode <> 0 Then
	ln_update_tools.of_rollback_transaction()
	Return "Error:  Could not insert Process Schedule Parameter record (" + SQLCA.SQLErrText + ')'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Commit the transaction
//-----------------------------------------------------------------------------------------------------------------------------------
ln_update_tools.of_commit_transaction()

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the Update Tools
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_update_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid, long al_rprtcnfgnstdid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_to_desktop()
//	Created by:	Blake Doerr
//	History: 	2/10/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_add_to_desktop(as_desktop_modulename, al_reportconfigid, al_userid, al_rprtcnfgnstdid, '')
end subroutine

public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid, long al_rprtcnfgnstdid, string as_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_to_desktop()
//	Arguments:  as_desktop_modulename - The name of the module
//					al_reportconfigid - The id of the reportconfig record
//					al_userid - The user to save this for
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions ln_string_functions
Long	ll_DtaObjctStteIdnty
Long	ll_RprtCnfgPvtTbleID
Long	ll_reportconfignestedID
Long ll_moduleid, ll_moduletoolid, ll_count, ll_orderid
String	ls_description

SetNull(ls_description)

If al_rprtcnfgnstdid = 0 Then SetNull(al_rprtcnfgnstdid)
If IsNull(as_argument) Then as_argument = ''

Choose Case String(Lower(as_desktop_modulename))
	Case 'traders desktop'
		as_desktop_modulename = 'u_dynamic_gui_dsv_trader_desktop'
	Case 'scheduling desktop'
		as_desktop_modulename = 'u_dynamic_gui_dsv_scheduler_desktop'
	Case 'accounting desktop'
		as_desktop_modulename = 'u_dynamic_gui_dsv_accounting'
	Case 'portfolio analysis desktop'
		as_desktop_modulename = 'u_dynamic_gui_dsv_position_desktop'
	Case 'smart search'
		as_desktop_modulename = 'w_basewindow_rightangle_explorer'
End Choose

//-------------------------------------------------------------------
// Find the module id for that desktopserviceviewer
//-------------------------------------------------------------------
Select	MdleID
Into		:ll_moduleid
From		Module
Where		MdleNme = :as_desktop_modulename;

//-------------------------------------------------------------------
// Find the module tool for that desktopserviceviewer
//-------------------------------------------------------------------
Select	MdleToolID
Into		:ll_moduletoolid
From		ModuleTool
Where		MdleID	= :ll_moduleid;

ll_DtaObjctStteIdnty		= Long(gn_globals.in_string_functions.of_find_argument(as_argument, '||', 'DtaObjctStteIdnty'))
ll_RprtCnfgPvtTbleID		= Long(gn_globals.in_string_functions.of_find_argument(as_argument, '||', 'RprtCnfgPvtTbleID'))
ll_reportconfignestedID	= Long(gn_globals.in_string_functions.of_find_argument(as_argument, '||', 'RprtCnfgNstdID'))

If Not IsNull(ll_reportconfignestedID) Then
	al_rprtcnfgnstdid = ll_reportconfignestedID
End If

If Not IsNull(ll_RprtCnfgPvtTbleID) Then
	Select	Description
	Into		:ls_description
	From		ReportConfigPivotTable	(NoLock)
	Where		ReportConfigPivotTable.RprtCnfgPvtTbleID	= :ll_RprtCnfgPvtTbleID;
ElseIf Not IsNull(ll_DtaObjctStteIdnty) Then
	Select	Name
	Into		:ls_description
	From		DataObjectState	(NoLock)
	Where		DataObjectState.Idnty	= :ll_DtaObjctStteIdnty;
End If

//-------------------------------------------------------------------
// 
//-------------------------------------------------------------------
If IsNull(al_rprtcnfgnstdid) Then
	Select	Count(*)
	Into		:ll_count
	From		ModuleToolReport
	Where		ParentMdleToolID 	= :ll_moduletoolid
	And		RprtCnfgID  		= :al_reportconfigid
	And		UserID				= :al_userid
	And		RprtCnfgNstdID		Is Null
	And		IsNull(Argument, '') = :as_argument;
Else
	Select	Count(*)
	Into		:ll_count
	From		ModuleToolReport
	Where		ParentMdleToolID 	= :ll_moduletoolid
	And		RprtCnfgID  		= :al_reportconfigid
	And		UserID				= :al_userid
	And		RprtCnfgNstdID		= :al_rprtcnfgnstdid
	And		IsNull(Argument, '') = :as_argument;
End If

//-------------------------------------------------------------------
// Determine the order
//-------------------------------------------------------------------
Select	Max(OrderID) + 10
Into		:ll_orderid
From		ModuleToolReport
Where		ParentMdleToolID 	= :ll_moduletoolid
And		UserID				= :gn_globals.il_userid;

//-------------------------------------------------------------------
// If there isn't an order start one
//-------------------------------------------------------------------
If IsNull(ll_orderid) Then ll_orderid = 10

//-------------------------------------------------------------------
// Insert the Module Tool Report
//-------------------------------------------------------------------
If ll_count = 0 And ll_moduletoolid > 0 And Not IsNull(ll_moduletoolid) And al_reportconfigid > 0 And Not IsNull(al_reportconfigid) Then
	Insert	ModuleToolReport
	(ParentMdleToolID, RprtCnfgID, UserID, OrderID, Message, Argument, RprtCnfgNstdID, Description)
	Values
	(:ll_moduletoolid, :al_reportconfigid, :al_userid, :ll_orderid, '', :as_argument, :al_rprtcnfgnstdid, :ls_description);
	
	gn_globals.in_subscription_service.of_message('tool added to desktop', '')
End If
end subroutine

public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid, string as_parameters);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_to_desktop()
//	Created by:	Blake Doerr
//	History: 	2/10/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_null
SetNull(ll_null)
This.of_add_to_desktop(as_desktop_modulename, al_reportconfigid, al_userid, ll_null, as_parameters)
end subroutine

public function boolean of_apply_nested_report (datastore ads_datastore, userobject au_search, long al_row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_nested_report()
//	Arguments:  au_search - The search object
//					al_rprtcnfgnstdid	- The rprtcnfgnstdid from the ReportConfigNested table
//	Overview:   This will apply a nested report to a search
//	Created by:	Blake Doerr
//	History: 	12/12/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
NonVisualObject ln_object
UserObject lu_dynamic_gui
UserObject lu_search[], lu_search_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_rowid
Long		ll_parentrowid
Long		ll_blobobjectid
Long		ll_RprtCnfgNstdDtlID
String	ls_parameter

//-----------------------------------------------------------------------------------------------------------------------------------
// Sort the rows to make sure that we are in the right order
//-----------------------------------------------------------------------------------------------------------------------------------
ads_datastore.SetSort('RowID A')
ads_datastore.Sort()

au_search.Dynamic of_get_properties().of_set('NestedReportRowID', String(al_row))

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the datawindow and its service manager
//-----------------------------------------------------------------------------------------------------------------------------------
ln_object = au_search.Dynamic of_get_report_dw().of_get_service('n_navigation_options')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't a service of the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_object) Then Return False

For ll_index = 1 To ads_datastore.RowCount()
	ll_parentrowid	= ads_datastore.GetItemNumber(ll_index, 'ParentRowID')
	If IsNull(ll_parentrowid) Then ll_parentrowid = 0
	If ll_parentrowid <> al_row Then Continue
	
	ll_rowid 				= ads_datastore.GetItemNumber(ll_index, 'RowID')
	ls_parameter			= ads_datastore.GetItemString(ll_index, 'Argument')
	ll_RprtCnfgNstdDtlID	= ads_datastore.GetItemNumber(ll_index, 'RprtCnfgNstdDtlID')
	ll_blobobjectid		= ads_datastore.GetItemNumber(ll_index, 'BlbObjctID')

	gn_globals.in_string_functions.of_replace_all(ls_parameter, '||', '[comma]')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Tell the object to open a detail report
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_object.Dynamic Event ue_notify('ReportDetailNavigation', ls_parameter)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the overlaying report now that it is open
	//-----------------------------------------------------------------------------------------------------------------------------------
	lu_dynamic_gui = au_search.Dynamic of_get_overlaying_report()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the adapter isn't valid return
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsValid(lu_dynamic_gui) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the child reports of the adapter
	//-----------------------------------------------------------------------------------------------------------------------------------
	lu_search[] = lu_search_empty[]
	lu_dynamic_gui.Dynamic of_get_reports(lu_search[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Return if the adapter doesn't have any searches
	//-----------------------------------------------------------------------------------------------------------------------------------
	If UpperBound(lu_search[]) <= 0 Then Continue
	
	lu_search[UpperBound(lu_search[])].Dynamic of_get_properties().of_set('WordTemplateBlobObjectID', String(ll_blobobjectid))
	lu_search[UpperBound(lu_search[])].Dynamic of_get_properties().of_set('ReportConfigNestedDetailID', String(ll_RprtCnfgNstdDtlID))
	
	This.of_apply_nested_report(ads_datastore, lu_search[UpperBound(lu_search[])], ll_rowid)
Next

Return True
end function

public function boolean of_apply_nested_report (userobject au_search, long al_rprtcnfgnstdid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_nested_report()
//	Arguments:  au_search - The search object
//					al_rprtcnfgnstdid	- The rprtcnfgnstdid from the ReportConfigNested table
//	Overview:   This will apply a nested report to a search
//	Created by:	Blake Doerr
//	History: 	12/12/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_datastore
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_DatastoreIsReference = True
Long		ll_row
Long		ll_dataobjectstateid
Long		ll_pivottableid
Long		ll_FilterViewID
Long		ll_blobobjectid
String	ls_report_title
String	ls_parameter

//lds_datastore = gn_globals.in_cache.of_get_cache_reference('NestedReportView')
If Not IsValid(lds_datastore) Then Return False

ll_row = lds_datastore.Find('RprtCnfgNstdID = ' + String(al_rprtcnfgnstdid), 1, lds_datastore.RowCount())

If ll_row <= 0 Then
	lb_DatastoreIsReference = False
	lds_datastore = Create Datastore
	lds_datastore.DataObject = 'd_reportconfignested_cache'
	lds_datastore.SetTransObject(SQLCA)
	If lds_datastore.Retrieve(al_rprtcnfgnstdid) <> 1 Then
		Destroy lds_datastore
		Return False
	End If
	
	ll_row = 1
End If

ls_parameter		= lds_datastore.GetItemString(ll_row, 'Parameter')
ls_report_title	= lds_datastore.GetItemString(ll_row, 'Name')
ll_blobobjectid	= lds_datastore.GetItemNumber(ll_row, 'BlbObjctID')

If ls_report_title <> '' And Not IsNull(ls_report_title) Then au_search.Dynamic of_settitle(ls_report_title)

If Not lb_DatastoreIsReference Then Destroy lds_datastore

ll_dataobjectstateid	= Long(gn_globals.in_string_functions.of_find_argument(ls_parameter, '||', 'dtaobjctstteidnty'))
ll_pivottableid		= Long(gn_globals.in_string_functions.of_find_argument(ls_parameter, '||', 'rprtcnfgpvttbleid'))
ll_FilterViewID		= Long(gn_globals.in_string_functions.of_find_argument(ls_parameter, '||', 'FilterViewID'))

au_search.Dynamic of_get_properties().of_set('WordTemplateBlobObjectID', String(ll_blobobjectid))
au_search.Dynamic of_get_properties().of_set('ReportConfigNestedID', String(al_rprtcnfgnstdid))

If Not IsNull(ll_dataobjectstateid) And ll_dataobjectstateid > 0 Then
	gn_globals.in_subscription_service.of_message('apply view id', String(ll_dataobjectstateid), au_search.Dynamic of_get_report_dw())
End If

If Not IsNull(ll_FilterViewID) And ll_FilterViewID > 0 Then
	au_search.Event Dynamic ue_notify('apply filter view', ll_FilterViewID)
End If

If Not IsNull(ll_pivottableid) And ll_pivottableid > 0 Then
	au_search.Dynamic Event ue_notify('pivot table view', String(ll_pivottableid))
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore and retrieve the details 
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore = Create Datastore
lds_datastore.DataObject = 'd_data_reportconfignesteddetail'
lds_datastore.SetTransObject(SQLCA)
If lds_datastore.Retrieve(al_rprtcnfgnstdid) <= 0 Then
	Destroy lds_datastore
	Return False
End If

This.of_apply_nested_report(lds_datastore, au_search, 0)

Destroy lds_datastore


Return True
end function

public subroutine of_get_nested_reports (long al_reportconfigid, long al_userid, ref long al_id[], ref string as_names[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_nested_reports()
//	Created by:	Blake Doerr
//	History: 	2/10/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Datastore	lds_datastore

//lds_datastore = gn_globals.in_cache.of_get_cache_reference('NestedReportView')
If Not IsValid(lds_datastore) Then Return

lds_datastore.SetFilter('RprtCnfgID = ' + String(al_reportconfigid))
lds_datastore.Filter()

If lds_datastore.RowCount() > 0 Then
	al_id[]		= lds_datastore.object.RprtCnfgNstdID.Primary
	as_names[]	= lds_datastore.object.Name.Primary
End If

lds_datastore.SetFilter('')
lds_datastore.Filter()

end subroutine

protected subroutine of_get_nested_reports (ref datastore ads_datastore, userobject au_search, long al_row, boolean ab_getreportviews, boolean ab_getfilterviews, boolean ab_getpivottableviews, boolean ab_saveovercurrenviews);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_nested_reports()
//	Created by:	Blake Doerr
//	History: 	2/10/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

userobject lu_search[]
userobject lu_dynamic_gui
//n_string_functions ln_string_functions
Long		ll_index
Long		ll_row
Long		ll_RprtCnfgNstdDtlID
Long		ll_deleted_index
String	ls_parameters

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the overlaying report now that it is open
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui = au_search.Dynamic of_get_overlaying_report()

If Not IsValid(lu_dynamic_gui) Then Return
If ClassName(lu_dynamic_gui) <> 'u_dynamic_gui_report_adapter' Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the child reports of the adapter
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui.Dynamic of_get_reports(lu_search[])

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(lu_search[])
	If Not IsValid(lu_search[ll_index]) Or IsNull(lu_search[ll_index]) Then Continue
	If Lower(Trim(ClassName(lu_search[ll_index]))) = 'u_search_pivot_table' Then Continue

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get other properties of the report
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_parameters = This.of_get_parameters(lu_search[ll_index], ab_getreportviews, ab_getfilterviews, ab_getpivottableviews, False, ab_saveovercurrenviews)
	gn_globals.in_string_functions.of_replace_all(ls_parameters, ',', '[comma]')
	gn_globals.in_string_functions.of_replace_all(ls_parameters, '=', '[equals]')
	
	If Len(Trim(ls_parameters)) > 0 Then
		ls_parameters = 'RprtCnfgID=' + lu_search[ll_index].Dynamic of_get_properties().of_get('RprtCnfgID') + ',parameter=' + ls_parameters
	Else
		ls_parameters = 'RprtCnfgID=' + lu_search[ll_index].Dynamic of_get_properties().of_get('RprtCnfgID')
	End If
	
	ll_RprtCnfgNstdDtlID		= Long(lu_search[ll_index].Dynamic of_get_properties().of_get('ReportConfigNestedDetailID'))
	
	ll_row = 0
	
	If ll_RprtCnfgNstdDtlID > 0 And Not IsNull(ll_RprtCnfgNstdDtlID) Then
		For ll_deleted_index = 1 To ads_datastore.DeletedCount()
			If ads_datastore.GetItemNumber(ll_deleted_index, 'RprtCnfgNstdDtlID', Delete!, False) = ll_RprtCnfgNstdDtlID Then
				ads_datastore.RowsMove(ll_deleted_index, ll_deleted_index, Delete!, ads_datastore, ads_datastore.RowCount() + 1, Primary!)
				ll_row = ads_datastore.RowCount()
				Exit
			End If
		Next
	End If
	
	If ll_row = 0 Then ll_row = ads_datastore.InsertRow(0)
	
	ads_datastore.SetItem(ll_row, 'Argument', ls_parameters)
	ads_datastore.SetItem(ll_row, 'RowID', ll_row)
	ads_datastore.SetItem(ll_row, 'ParentRowID', al_row)
	ads_datastore.SetItem(ll_row, 'Argument', ls_parameters)

	This.of_get_nested_reports(ads_datastore, lu_search[ll_index], ll_row, ab_getreportviews, ab_getfilterviews, ab_getpivottableviews, ab_saveovercurrenviews)
Next
end subroutine

public subroutine of_removed_from_desktop (graphicobject ago_module, long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_removed_from_desktop()
//	Arguments:  as_desktop_modulename - The name of the module
//					al_reportconfigid - The id of the reportconfig record
//					al_userid - The user to save this for
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	5/3/02 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_modulename
Long		ll_moduleid
Long		ll_moduletoolid

ls_modulename = ClassName(ago_module)

//-------------------------------------------------------------------
// Find the module id for that desktopserviceviewer
//-------------------------------------------------------------------
Select	MdleID
Into		:ll_moduleid
From		Module	(NoLock)
Where		MdleNme = :ls_modulename
Using		SQLCA;

//-------------------------------------------------------------------
// Find the module tool for that desktopserviceviewer
//-------------------------------------------------------------------
Select	MdleToolID
Into		:ll_moduletoolid
From		ModuleTool	(NoLock)
Where		MdleID	= :ll_moduleid
Using		SQLCA;

//-------------------------------------------------------------------
// Get rid of the ModuleToolReport
//-------------------------------------------------------------------
Delete	ModuleToolReport
Where		ParentMdleToolID 	= :ll_moduletoolid
And		RprtCnfgID  		= :al_reportconfigid
And		UserID				= :al_userid
Using		SQLCA;
end subroutine

public function long of_save_nested_report (userobject au_search, long al_rprtcnfgid, long al_rprtcnfgnstdid, long al_userid, long al_createdbyuserid, string as_name, string as_description, boolean ab_getreportviews, boolean ab_getfilterviews, boolean ab_getpivottableviews, boolean ab_getuomcurrencyviews, boolean ab_allownavigation, boolean ab_nestedreportissavedinsidereportview, boolean ab_saveovercurrentviews);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_nested_report()
//	Arguments:  au_search - The search object
//	Overview:   This will apply a nested report to a search
//	Created by:	Blake Doerr
//	History: 	12/12/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_update_tools ln_update_tools
Datastore lds_datastore
Datastore lds_datastore_detail

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_null
Long 		ll_index
Long		ll_reportconfignestedid
String	ls_parameters

SetNull(ll_null)
SetNull(ll_reportconfignestedid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get other properties of the report
//-----------------------------------------------------------------------------------------------------------------------------------
ls_parameters = This.of_get_parameters(au_search, ab_getreportviews And Not ab_nestedreportissavedinsidereportview, ab_getfilterviews, ab_getpivottableviews, ab_getuomcurrencyviews, ab_saveovercurrentviews)
///**/ab_allownavigation
//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore and retrieve the details 
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore = Create Datastore
lds_datastore.DataObject = 'd_gui_reportconfignested'
lds_datastore.SetTransObject(SQLCA)

If al_RprtCnfgNstdID > 0 And Not IsNull(al_RprtCnfgNstdID) Then
	lds_datastore.Retrieve(al_RprtCnfgNstdID)
End If

If lds_datastore.RowCount() <= 0 Then
	lds_datastore.InsertRow(0)
	lds_datastore.SetItem(1, 'RprtCnfgID', 	al_rprtcnfgid)
	lds_datastore.SetItem(1, 'UserID', 			al_userid)
	lds_datastore.SetItem(1, 'CreatedUserID', al_createdbyuserid)
End If

lds_datastore.SetItem(1, 'Name', 			as_name)
lds_datastore.SetItem(1, 'Description', 	as_description)
lds_datastore.SetItem(1, 'Parameter', 		ls_parameters)


//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore and save the details
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore_detail = Create Datastore
lds_datastore_detail.DataObject = 'd_data_reportconfignesteddetail'
lds_datastore_detail.SetTransObject(SQLCA)

If al_RprtCnfgNstdID > 0 And Not IsNull(al_RprtCnfgNstdID) Then
	lds_datastore_detail.Retrieve(al_RprtCnfgNstdID)
	For ll_index = lds_datastore_detail.RowCount() To 1 Step -1
		lds_datastore_detail.DeleteRow(ll_index)
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// This is a recursive function that will get all the details of the nested report
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_nested_reports(lds_datastore_detail, au_search, ll_null, ab_getreportviews, ab_getfilterviews, ab_getpivottableviews, ab_saveovercurrentviews)

ln_update_tools = Create n_update_tools
ln_update_tools.of_begin_transaction()

If IsValid(ln_update_tools.of_manage_update({lds_datastore})) Then
	ln_update_tools.of_rollback_transaction()
Else
	
	ll_reportconfignestedid = lds_datastore.GetItemNumber(1, 'RprtCnfgNstdID')
	
	For ll_index = 1 To lds_datastore_detail.RowCount()
		lds_datastore_detail.SetItem(ll_index, 'RprtCnfgNstdID', ll_reportconfignestedid)
	Next

	If IsValid(ln_update_tools.of_manage_update({lds_datastore_detail})) Then
		ln_update_tools.of_rollback_transaction()
		SetNull(ll_reportconfignestedid)
	Else 
		ln_update_tools.of_commit_transaction()
	End If
		
End If


Destroy lds_datastore
Destroy lds_datastore_detail
Destroy ln_update_tools

If as_name <> '' And Not IsNull(as_name) Then au_search.Dynamic of_settitle(as_name)

//gn_globals.in_cache.of_refresh_cache('NestedReportView')

Return  ll_reportconfignestedid
end function

public function string of_save_nested_report_documenttemplate (userobject au_search);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_nested_report_documenttemplate()
//	Arguments:  au_search - The search object
//	Overview:   This will apply a nested report to a search
//	Created by:	Blake Doerr
//	History: 	12/12/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_null
Long		ll_reportconfignestedid
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the search is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Then Return 'Error:  The report object is not valid'

ll_reportconfignestedid = This.of_save_nested_report(au_search, Long(au_search.Dynamic of_get_properties().of_get('RprtCnfgID')), Long(au_search.Dynamic of_get_properties().of_get('ReportConfigNestedID')), ll_null, Long(au_search.Dynamic of_get_properties().of_get('UserID')), au_search.Dynamic of_get_properties().of_get('Name'), au_search.Dynamic of_get_properties().of_get('Name'), True, True, False, True, False, False, True)

Return  String(ll_reportconfignestedid)
end function

public subroutine of_add_to_desktop (string as_desktop_modulename, long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_to_desktop()
//	Arguments:  as_desktop_modulename - The name of the module
//					al_reportconfigid - The id of the reportconfig record
//					al_userid - The user to save this for
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_null
SetNull(ll_null)

This.of_add_to_desktop(as_desktop_modulename, al_reportconfigid, al_userid, ll_null)
end subroutine

public function string of_get_parameters (userobject au_search, boolean ab_getreportviews, boolean ab_getfilterviews, boolean ab_getpivottableviews, boolean ab_getuomcurrencyviews, boolean ab_saveovercurrentviews);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_parameters()
//	Created by:	Blake Doerr
//	History: 	2/10/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_update_tools 	ln_update_tools
Datastore 			lds_datastore
Datastore 			lds_datastore_detail
NonVisualObject	ln_object
PowerObject			lu_object
UserObject			lu_dynamic_gui
UserObject			lu_search[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_IsTopLevelReport
Long		ll_currentviewid
String	ls_parameters
String	ls_name
String	ls_filter
String	ls_getuomcurrencyviews = 'N'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get other properties of the report
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Then Return ''
If Not (ab_getreportviews Or ab_getfilterviews Or ab_getpivottableviews Or ab_getuomcurrencyviews) Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Create a string for this boolean to be passed into a function
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_getuomcurrencyviews Then ls_getuomcurrencyviews = 'Y'

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the name of this report
//-----------------------------------------------------------------------------------------------------------------------------------
ls_name = au_search.Dynamic of_get_properties().of_Get('Name')

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are saving over all current views, we need to determine what the name of the top level report is
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_saveovercurrentviews Then
	lu_dynamic_gui = au_search.Dynamic of_get_adapter()
	
	If Not IsNull(lu_dynamic_gui) And IsValid(lu_dynamic_gui) Then
		lb_IsTopLevelReport = Not IsValid(lu_dynamic_gui.Dynamic of_get_parent_adapter())
	End If
	
	Do While Not IsNull(lu_dynamic_gui) And IsValid(lu_dynamic_gui)
		ls_name = au_search.Dynamic of_get_adapter().of_get_properties().of_get('Name')
		lu_dynamic_gui = lu_dynamic_gui.Dynamic of_get_parent_adapter()
	Loop
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the applied filter views
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_getfilterviews Then
	lu_object = au_search.Dynamic of_get_report_dw().of_get_service_manager().of_get_component('u_filter_strip')
	If IsValid(lu_object) Then
		lu_object.Dynamic AcceptText()
		ls_filter = au_search.Dynamic of_get_report_dw().Describe("DataWindow.Table.Filter")
		If Trim(ls_filter) <> '' And Trim(ls_filter) <> '!' And Trim(ls_filter) <> '?' Then
			If ab_saveovercurrentviews Then
				ll_currentviewid = Long(lu_object.Dynamic of_save_view(ls_name))
			Else
				ll_currentviewid = lu_object.Dynamic of_get_current_view_id()
			End If
			
			If Not IsNull(ll_currentviewid) And ll_currentviewid > 0 Then
				ls_parameters = ls_parameters + 'FilterViewID=' + String(ll_currentviewid) + '||'
			End If
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the applied report views
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_getreportviews Then
	ln_object = au_search.Dynamic of_get_report_dw().of_get_service('n_dao_dataobject_state')
	If IsValid(ln_object) Then
		If ab_saveovercurrentviews Then
			ln_object.Dynamic of_save_view(ls_name, 'N', 'Y', -1, '', 'N', 'N', 'N', 'N', 'N', 'N', ab_saveovercurrentviews)
		End If
		ll_currentviewid = ln_object.Dynamic of_get_current_view_id()
		
		If Not IsNull(ll_currentviewid) And ll_currentviewid > 0 Then
			ls_parameters = ls_parameters + 'dtaobjctstteidnty=' + String(ll_currentviewid) + '||'
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the applied pivot views
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_getpivottableviews Then
	lu_dynamic_gui = au_search.Dynamic of_get_overlaying_report()
	If Not IsValid(lu_dynamic_gui) Then Return Left(ls_parameters, Len(ls_parameters) - 2)
	Choose Case Lower(Trim(ClassName(lu_dynamic_gui)))
		Case 'u_dynamic_gui_report_adapter'
			lu_dynamic_gui.Dynamic of_get_reports(lu_search[])
			If Not UpperBound(lu_search[]) > 0 Then Return Left(ls_parameters, Len(ls_parameters) - 2)
			If Not IsValid(lu_search[1]) Then Return Left(ls_parameters, Len(ls_parameters) - 2)
			If Not Lower(Trim(ClassName(lu_search[1]))) = 'u_search_pivot_table' Then Return Left(ls_parameters, Len(ls_parameters) - 2)
			ln_object = lu_search[1].Dynamic of_get_report_dw().of_get_service('n_pivot_table_service')

		Case 'u_search_pivot_table'
			ln_object = lu_dynamic_gui.Dynamic of_get_report_dw().of_get_service('n_pivot_table_service')

		Case Else	
			Return Left(ls_parameters, Len(ls_parameters) - 2)
	End Choose

	If Not IsValid(ln_object) Then Return Left(ls_parameters, Len(ls_parameters) - 2)

	ll_currentviewid = ln_object.Dynamic of_get_current_view_id()
	If Not IsNull(ll_currentviewid) And ll_currentviewid > 0 Then
		ls_parameters = ls_parameters + 'rprtcnfgpvttbleid=' + String(ll_currentviewid) + '||'
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the UOM/Currency View if it is the top level
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_getuomcurrencyviews And lb_IsTopLevelReport Then
	lu_object = au_search.Dynamic of_get_report_dw().of_get_service_manager().of_get_component('u_dynamic_conversion_strip')
	If IsValid(lu_object) Then
		If ab_saveovercurrentviews Then
			ll_currentviewid = Long(lu_object.Dynamic of_save_view(ls_name))
		Else
			ll_currentviewid = lu_object.Dynamic of_get_current_view_id()
		End If
	
		If ll_currentviewid <> 0 And Not IsNull(ll_currentviewid) Then
			ls_parameters = ls_parameters + 'UOMCurrencyViewID=' + String(ll_currentviewid) + '||'
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove the last delimiter from the string
//-----------------------------------------------------------------------------------------------------------------------------------
Return Left(ls_parameters, Len(ls_parameters) - 2)
end function

public function long of_save_nested_report (userobject au_search);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_nested_report()
//	Arguments:  au_search - The search object
//	Overview:   This will apply a nested report to a search
//	Created by:	Blake Doerr
//	History: 	12/12/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Window lw_reportconfignested_save_view
n_bag 				ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_null
Long 		ll_index
Long		ll_userid
Long		ll_RprtCnfgNstdID
String	ls_description
String	ls_globalview
String	ls_report_title
String	ls_includereportviews
String	ls_includefilterviews
String	ls_includepivotviews
String	ls_AllowNavigation

SetNull(ll_null)
SetNull(ll_userid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the search is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Then Return ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the bag object and set all the
//-----------------------------------------------------------------------------------------------------------------------------------
ln_bag = Create n_bag
ln_bag.of_set('RprtCnfgID', 		Long(au_search.Dynamic of_get_properties().of_Get('RprtCnfgID')))
ln_bag.of_set('UserID', 			gn_globals.il_userid)
ln_bag.of_set('Name', 				au_search.Text)

OpenWithParm(lw_reportconfignested_save_view, ln_bag, 'w_reportconfignested_save_view')

If IsNull(ln_bag.of_get('OK')) Then
	Return ll_null
End If

ls_globalview 		= String(ln_bag.of_get('GlobalView'))
ls_report_title	= String(ln_bag.of_get('Name'))
ls_description 	= String(ln_bag.of_get('Description'))
ll_RprtCnfgNstdID	= Long(ln_bag.of_get('RprtCnfgNstdID'))

ls_includereportviews	= String(ln_bag.of_get('IncludeReportViews'))
ls_includefilterviews	= String(ln_bag.of_get('IncludeFilterViews'))
ls_includepivotviews		= String(ln_bag.of_get('IncludePivotViews'))
ls_AllowNavigation		= String(ln_bag.of_get('AllowNavigation'))

Destroy ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the 
//-----------------------------------------------------------------------------------------------------------------------------------
If Upper(Trim(ls_globalview)) <> 'Y' Then ll_userid = gn_globals.il_userid

Return  This.of_save_nested_report(au_search, Long(au_search.Dynamic of_get_properties().of_Get('RprtCnfgID')), ll_RprtCnfgNstdID, ll_userid, gn_globals.il_userid, ls_report_title, ls_description, Upper(Trim(ls_includereportviews)) = 'Y', Upper(Trim(ls_includefilterviews)) = 'Y', Upper(Trim(ls_includepivotviews)) = 'Y', Upper(Trim(ls_AllowNavigation)) = 'Y', False, False, False)
end function

public function string of_create_report_syntax ();String	ls_procedurename
String	ls_datawindowname
String	ls_filepath
String	ls_syntax
String	ls_return
String	ls_reporttitle
Long		ll_rprtdtbseid
Blob		lb_syntax

Transaction	lxctn_Transaction
n_transaction_pool ln_transaction_pool
n_datawindow_tools ln_datawindow_tools
//n_string_functions ln_string_functions
n_file_manipulator ln_file_manipulator
Window lw_window
Open(lw_window, 'w_popup_report_syntaxbuilder')

ls_return = Message.StringParm

If Pos(ls_return, '||') <= 0 Then Return ''

ls_procedurename 			= Trim(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'procedurename'))
ls_datawindowname			= Trim(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'datawindowname'))
ls_filepath					= Trim(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'filepath'))
ls_syntax					= Trim(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'syntax'))
ll_rprtdtbseid				= Long(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'rprtdtbseid'))
ls_reporttitle				= Trim(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'title'))

ln_transaction_pool = Create n_transaction_pool
lxctn_Transaction			= ln_transaction_pool.of_gettransactionobject(ll_rprtdtbseid)
Destroy ln_transaction_pool

ln_datawindow_tools = Create n_datawindow_tools
//ls_syntax = ln_datawindow_tools.of_Create_report_syntax(ls_procedurename, ls_reporttitle, lxctn_Transaction)
Destroy ln_datawindow_tools

If Upper(Left(Trim(ls_syntax), 5)) = 'ERROR' Then 
	//gn_globals.in_messagebox.of_messagebox_validation(ls_syntax)
	Return ls_syntax
End If

ls_syntax = '$PBExportHeader$' + ls_datawindowname + '.srd~r~n' + ls_syntax

lb_syntax = Blob(ls_syntax)
If Not ln_file_manipulator.of_build_file_from_blob(ls_filepath, 'R', lb_syntax) Then 
	//gn_globals.in_messagebox.of_messagebox_validation('ERROR:  Could not build file from syntax')
	Return 'ERROR:  Could not build file from syntax'
End If

Return ''
end function

public function string of_new_dynamic_report ();Long		ll_fldrid
Long		ll_rprtdtbseid
Long		ll_blbobjctid
Long		ll_rprtcnfgid
Long		ll_enttyid
Long		ll_clmnslctntbleid
Blob		lb_blob
String	ls_rprtcnfgnme
String	ls_procedurename
String	ls_syntax
String	ls_return
/**///Wrong DAO
n_dao ln_dao_report
n_navigation_manager ln_navigation_manager
n_datawindow_tools ln_datawindow_tools
n_blob_manipulator ln_blob_manipulator
//n_string_functions ln_string_functions
window lw_window
Transaction lxctn_Transaction
n_transaction_pool ln_transaction_pool
Open(lw_window, 'w_popup_reportbuilder')

ls_return = Message.StringParm

If Pos(ls_return, '||') <= 0 Then Return ''

ll_clmnslctntbleid 	= Long(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'clmnslctntbleidnty'))
ll_enttyid 				= Long(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'enttyid'))
ll_rprtdtbseid			= Long(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'rprtdtbseid'))
ll_fldrid				= Long(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'fldrid'))
ls_rprtcnfgnme			= Trim(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'rprtcnfgnme'))
ls_procedurename		= Trim(gn_globals.in_string_functions.of_find_argument(ls_return, '||', 'procedurename'))

ln_dao_report = Create Using 'n_dao_report'
ln_dao_report.of_settransobject(sqlca)
ln_dao_report.insertrow(0)

ln_datawindow_tools = Create n_datawindow_tools
//ls_syntax = ln_datawindow_tools.of_create_report_syntax('Execute sp_Report_Dynamic "N", Null, Null, "N", "Y"', ls_rprtcnfgnme)
If IsNull(ls_procedurename) Or Trim(ls_procedurename) = '' Then ls_procedurename = 'sp_Report_Dynamic'

ln_transaction_pool = Create n_transaction_pool
lxctn_Transaction			= ln_transaction_pool.of_gettransactionobject(ll_rprtdtbseid)
Destroy ln_transaction_pool

ls_syntax = ln_datawindow_tools.of_create_report_syntax(ls_procedurename, ls_rprtcnfgnme, lxctn_Transaction)
Destroy ln_datawindow_tools

If Upper(Left(Trim(ls_syntax), 5)) = 'ERROR' Then 
	//gn_globals.in_messagebox.of_messagebox_validation(ls_syntax)
	Return ls_syntax
End If

ln_blob_manipulator = Create n_blob_manipulator
lb_blob = Blob(ls_syntax)
ll_blbobjctid = ln_blob_manipulator.of_insert_blob(lb_blob, 'CustomReport', False)
Destroy ln_blob_manipulator

ln_dao_report.of_setitem(1, 'rprtcnfgnme',							ls_rprtcnfgnme)
ln_dao_report.of_setitem(1, 'rprtcnfgdscrptn',						ls_rprtcnfgnme)
ln_dao_report.of_setitem(1, 'rprtcnfgdtaobjct',						'custom format')
ln_dao_report.of_setitem(1, 'rprtcnfgcrtraobjct',					'u_criteria_search_dynamic')
ln_dao_report.of_setitem(1, 'rprtcnfgdsplyobjct',					'u_search_dynamic')
ln_dao_report.of_setitem(1, 'rprtcnfgfldrid',						ll_fldrid)
ln_dao_report.of_setitem(1, 'rprtcnfgsrttpe',						'M')
ln_dao_report.of_setitem(1, 'rprtcnfgfltr',							'Y')
ln_dao_report.of_setitem(1, 'rprtcnfgrprtdtbseid',					ll_rprtdtbseid)
ln_dao_report.of_setitem(1, 'rprtcnfgtpe',							'I')
ln_dao_report.of_setitem(1, 'rprtcnfgblbobjctid',					ll_blbobjctid)
ln_dao_report.of_setitem(1, 'RprtCnfgShwCrtra',						'N')
ln_dao_report.of_setitem(1, 'rprtcnfgcrtatpe',						'R')
//ln_dao_report.of_setitem(1, 'rprtcnfgcrtablbobjctid',				)
ln_dao_report.of_setitem(1, 'rprtcnfguomcnvrsn',					'Y')
ln_dao_report.of_setitem(1, 'rprtcnfgcrrncycnvrsn',				'Y')
ln_dao_report.of_setitem(1, 'rprtdcmnttypid',						1)
ln_dao_report.of_setitem(1, 'reportoptions',							'ViewSaving=Y||RowSelection=Y||ColumnResizing=Y||DynamicGrouping=Y||Formatting=Y||AggregationService=Y||DropDownCaching=Y||SortType=M||Filter=Y||UOM Conversion=Y||Currency Conversion=Y||ColumnSelection=Y||PivotTables=Y||CalendarService=N||DragDrop=Y||IsLarge=N')

If ll_enttyid > 0 Then ln_dao_report.of_setitem(1, 'enttyrprtcnfgenttyid',	ll_enttyid)

ls_return = ln_dao_report.of_save()
If ls_return <> '' Then 
//	gn_globals.in_messagebox.of_messagebox_validation(ls_return)
	Destroy ln_dao_report
	Return 'Error:  Could not save report'
End If


ll_rprtcnfgid = Long(ln_dao_report.of_getitem(1, 'rprtcnfgid'))
Destroy ln_dao_report

If ll_rprtcnfgid > 0 And Not IsNull(ll_rprtcnfgid) Then
	Insert	ReportConfigColumnSelectionTable
				(
				RprtCnfgID,
				ClmnSlctnTbleIdnty,
				AliasTableName,
				PrefixDescription,
				AllowOneToMany
				)
	Values	(
				:ll_rprtcnfgid,
				:ll_clmnslctntbleid,
				'',
				'',
				'Y'
				)
	Using	sqlca;

	gn_globals.in_subscription_service.of_message('refresh cache', 'ReportConfig')
	//gn_globals.in_security.of_refresh()
	
	ln_navigation_manager = Create n_navigation_manager
	lw_window = ln_navigation_manager.of_find_window('w_basewindow_rightangle_explorer')
	Destroy ln_navigation_manager
	
	lw_window.Dynamic of_open_report(ll_rprtcnfgid, 'R')
End If


Return ''
end function

public function string of_remove_from_desktop (string as_parameters_containing_mdletlrprtid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_removed_from_desktop()
//	Arguments:  as_modulename - The name of the module
//					al_userid - The user to save this for
//					al_reportconfigid - The id of the reportconfig record
//					ab_issavedreport - Whether or not the report is a saved report
//					as_parameters - The parameters of the report to match in the table
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	5/3/02 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_MdleToolRprtID
Long		ll_MdleToolRprtID
//n_string_functions ln_string_functions

ls_MdleToolRprtID = gn_globals.in_string_functions.of_find_argument(as_parameters_containing_mdletlrprtid, '||', 'MdleToolRprtID')

If Not IsNumber(ls_MdleToolRprtID) Or Long(ls_MdleToolRprtID) <= 0 Or IsNull(ls_MdleToolRprtID) Then Return 'Error:  Did not find a MdleToolRprtID in the parameters string (' + as_parameters_containing_mdletlrprtid + ')'

ll_MdleToolRprtID = Long(ls_MdleToolRprtID)

//-------------------------------------------------------------------
// Get rid of the ModuleToolReport
//-------------------------------------------------------------------
Delete	ModuleToolReport
Where		MdleToolRprtID		= :ll_MdleToolRprtID
Using		SQLCA;
end function

on n_reporting_object_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_reporting_object_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

