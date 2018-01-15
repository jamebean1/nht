$PBExportHeader$n_report_manager.sru
$PBExportComments$This is the report manager.  If you tell it a reportconfigurationid and a display object it will build the report for you.
forward
global type n_report_manager from nonvisualobject
end type
end forward

global type n_report_manager from nonvisualobject
end type
global n_report_manager n_report_manager

type variables
Protected:
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Other Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Boolean 	ib_IsComposite 					= False
	Long		il_compositereportconfigid
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Persistent Objects
	//-----------------------------------------------------------------------------------------------------------------------------------
	n_datastore_append 								ids_report_information
	UserObject											iu_dynamic_gui_report_adapter
	Datastore											ids_report_information_all

end variables

forward prototypes
public function long of_get_reportconfig_id (string as_reportname)
public function long of_get_reportconfig_id_from_entity (string as_to_entity)
public function string of_get_adapter_name (long al_reportconfigid, string as_reportconfigtype)
public function string of_get_display_object (long al_reportconfigid)
public function long of_get_report_folder (long al_reportconfigid, string as_reporttype)
public function string of_get_display_object (long al_reportconfigid, string as_reportconfigtype)
public subroutine of_reset ()
protected function long of_get_reportconfig (long al_reportconfigid, string as_reporttype, datastore ads_datastore)
public function string of_get_report_name (long al_reportconfigid, string as_reporttype)
public function userobject of_open_report (string as_reportname)
protected function long of_find_row (long al_reportconfigid, string as_reporttype)
public function string of_get_adapter_name (long al_reportconfigid)
public subroutine of_init (userobject au_search, long al_reportconfigid)
public function userobject of_create_report (long al_reportconfigid, boolean ab_issavedreport)
public function userobject of_create_report (userobject au_dynamic_gui_report_adapter, long al_reportconfigid, boolean ab_issavedreport)
public function userobject of_open_report (long al_reportconfigid, string as_reporttype)
public function userobject of_open_report (long al_reportconfigid, string as_reporttype, string as_reportparameters)
public function window of_get_reporting_desktop ()
protected subroutine of_create_datastore (long al_reportconfigid, string as_reportconfigtype)
public function string of_init (userobject au_search, long al_reportconfigid, string as_reporttype)
end prototypes

public function long of_get_reportconfig_id (string as_reportname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_reportconfig_id()
// Arguments:   as_reportname - The report name
// Overview:    This will return the report config id for the report name
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_reportconfigid

n_registry ln_registry
ll_reportconfigid = Long(ln_registry.of_get_registry_key('Reporting Architecture\Report Names\' + Trim(as_reportname)))


Return ll_reportconfigid
end function

public function long of_get_reportconfig_id_from_entity (string as_to_entity);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_reportconfig_id()
// Arguments:   as_reportname - The report name
// Overview:    This will return the report config id for the report name
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------
Long			ll_reportconfigid
Long			ll_row
Datastore	lds_report_information


If IsValid(gn_globals.in_cache) Then
	lds_report_information = gn_globals.in_cache.of_get_cache_reference('EntityDefaultReport')
Else
	lds_report_information = Create Datastore
	lds_report_information.DataObject = 'd_entity_default_report'
	lds_report_information.SetTransObject(SQLCA)
	lds_report_information.Retrieve()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the report we are looking for
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = lds_report_information.Find('Lower(enttynme) = ~'' + Lower(as_to_entity) + '~' And enttyrprtcnfgisdflt = ~'Y~'', 1, lds_report_information.RowCount())
	
//-----------------------------------------------------------------------------------------------------------------------------------
// If we don't find it, messagebox and return
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row <= 0 Or IsNull(ll_row) Then
	Return -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the id and the stored procedure that is used to navigate
//-----------------------------------------------------------------------------------------------------------------------------------
ll_reportconfigid = lds_report_information.GetItemNumber(ll_row, 'enttyrprtcnfgrprtcnfg')
Return ll_reportconfigid
end function

public function string of_get_adapter_name (long al_reportconfigid, string as_reportconfigtype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_get_adapter_object()
// Arguments:  al_reportconfigid - The report id
//					as_reportconfigtype - The report type
// Overview:	This will return the display object for the person to open
// Created by:	
// History:		
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_adapter_object

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the information for this report
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_create_datastore(al_reportconfigid, as_reportconfigtype)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the rowcount is greater than 0 return the first adapter object.  We have to assume row one.
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_report_information.RowCount() > 0 Then
	ls_adapter_object = ids_report_information.GetItemString(1, 'AdapterObject')
End If

Return  ls_adapter_object
end function

public function string of_get_display_object (long al_reportconfigid);Return This.of_get_display_object(al_reportconfigid, 'R')
end function

public function long of_get_report_folder (long al_reportconfigid, string as_reporttype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_report_folder()
// Arguments:   al_reportconfigid - The report id
// Overview:    This will return the folder id for the report
// Created by: 
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row 

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore using the report information
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_create_datastore(al_reportconfigid, as_reporttype)

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the correct row
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = This.of_find_row(al_reportconfigid, as_reporttype)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't find the row
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row <= 0 Or IsNull(ll_row) Then Return 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the name
//-----------------------------------------------------------------------------------------------------------------------------------
Return ids_report_information.GetItemNumber(ll_row, 'folderid')



end function

public function string of_get_display_object (long al_reportconfigid, string as_reportconfigtype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_display_object()
// Arguments:   al_reportconfigid - The report id
// Overview:    This will return the display object for the person to open
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row 

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore using the report information
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_create_datastore(al_reportconfigid, as_reportconfigtype)

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the correct row
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = This.of_find_row(al_reportconfigid, as_reportconfigtype)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't find the row
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row <= 0 Or IsNull(ll_row) Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the name
//-----------------------------------------------------------------------------------------------------------------------------------
Return ids_report_information.GetItemString(ll_row, 'DisplayObject')



end function

public subroutine of_reset ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reset()
//	Overview:   This will restore the state of this object back to when it was created
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Set this to be not a composite report
//-----------------------------------------------------------------------------------------------------------------------------------
ib_IsComposite 								= False

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the rows in the report information datastore
//-----------------------------------------------------------------------------------------------------------------------------------
ids_report_information.Reset()

end subroutine

protected function long of_get_reportconfig (long al_reportconfigid, string as_reporttype, datastore ads_datastore);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_reportconfig()
//	Arguments:  al_reportconfigid - The report config id
//					as_reporttype 		- The report type
//					ads_datastore		- The datstore to append the data to
//	Overview:   This will find the row that you are looking for
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ads_datastore) Or Not IsValid(ids_report_information_all) Or Upper(Trim(as_reporttype)) <> 'R' Then Return 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the row
//-----------------------------------------------------------------------------------------------------------------------------------
If Upper(Trim(as_reporttype)) <> 'S' Then
	ll_row = ids_report_information_all.Find('reportid = ' + String(al_reportconfigid) + ' And reporttype <> "S"', 1, ids_report_information_all.RowCount())	
	
Else
	ll_row = ids_report_information_all.Find('reportid = ' + String(al_reportconfigid) + ' And reporttype = "S"', 1, ids_report_information_all.RowCount())	
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
Return ids_report_information_all.RowsCopy(ll_row, ll_row, Primary!, ads_datastore, ads_datastore.RowCount() + 1, Primary!)
end function

public function string of_get_report_name (long al_reportconfigid, string as_reporttype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_get_report_name
// Arguments:	al_reportconfigid - ReportConfig.RprtCnfgID
// Overview:	Return the name for the argument specified report id.
// Created by:	
// History:		
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row 

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore using the report information
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_create_datastore(al_reportconfigid, as_reporttype)

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the correct row
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = This.of_find_row(al_reportconfigid, as_reporttype)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't find the row
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row <= 0 Or IsNull(ll_row) Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the name
//-----------------------------------------------------------------------------------------------------------------------------------
Return ids_report_information.GetItemString(ll_row, 'name')



end function

public function userobject of_open_report (string as_reportname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_report()
//	Arguments:  as_reportname - The report name in the registry
//	Overview:   This will get the reportconfig id and send it to another version of of_open_report()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_open_report(This.of_get_reportconfig_id(as_reportname), 'R')
end function

protected function long of_find_row (long al_reportconfigid, string as_reporttype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_find_row()
//	Arguments:  al_reportconfigid - The report config id
//					as_reporttype - The report type
//	Overview:   This will find the row that you are looking for
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ids_report_information) Then Return 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the row
//-----------------------------------------------------------------------------------------------------------------------------------
If Upper(Trim(as_reporttype)) = 'S' Then
	Return ids_report_information.Find('SavedReportID = ' + String(al_reportconfigid), 1, ids_report_information.RowCount())
Else
	Return ids_report_information.Find('ReportID = ' + String(al_reportconfigid) + ' And ReportType <> "S"', 1, ids_report_information.RowCount())	
End If
end function

public function string of_get_adapter_name (long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_adapter_object()
// Arguments:   al_reportconfigid - The report id
// Overview:    This will return the display object for the person to open
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_get_adapter_name(al_reportconfigid, 'R')
end function

public subroutine of_init (userobject au_search, long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   au_search - the search object to reference
//					 al_reportconfigid - The report id
// Overview:    Pass this on to the real of_init
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_init(au_search, al_reportconfigid, 'R')

end subroutine

public function userobject of_create_report (long al_reportconfigid, boolean ab_issavedreport);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_report()
//	Arguments:  as_reportname - The report name in the registry
//	Overview:   This will get the reportconfig id and send it to another version of of_open_report()
//	Created by: 
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject lu_dynamic_gui
Return This.of_Create_report(lu_dynamic_gui, al_reportconfigid, ab_IsSavedReport)
end function

public function userobject of_create_report (userobject au_dynamic_gui_report_adapter, long al_reportconfigid, boolean ab_issavedreport);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_report()
//	Arguments:  as_reportname - The report name in the registry
//	Overview:   This will get the reportconfig id and send it to another version of of_open_report()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
n_report ln_report
UserObject lu_search
Window lw_basewindow_rightangle_explorer
String 	ls_objectname
String	ls_reporttype	= 'R'

If ab_IsSavedReport Then ls_reporttype = 'S'

//-----------------------------------------------------------------------------------------------------------------------------------
// If the adapter is valid, open the report there
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(au_dynamic_gui_report_adapter) Then
	If Not Upper(Trim(au_dynamic_gui_report_adapter.Dynamic of_get_properties().of_get('IsInitialized'))) = 'Y' Then
		au_dynamic_gui_report_adapter.Dynamic of_init(al_reportconfigid)
	End If

	If Upper(Trim(au_dynamic_gui_report_adapter.Dynamic of_get_properties().of_get('IsCompositeReport'))) = 'Y' And Long(au_dynamic_gui_report_adapter.Dynamic of_get_properties().of_get('RprtCnfgID')) = al_reportconfigid Then
	Else
		ln_report = Create n_report
		ln_report.of_init(al_reportconfigid, Upper(Trim(ls_reporttype)) = 'S')
		Return au_dynamic_gui_report_adapter.Dynamic of_open_report(ln_report)
	End If

ElseIf al_reportconfigid > 0 And Not IsNull(al_reportconfigid) Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// Open a report in the reporting desktop
	//-----------------------------------------------------------------------------------------------------------------------------------
	lw_basewindow_rightangle_explorer = This.of_get_reporting_desktop()
	
	If IsValid(lw_basewindow_rightangle_explorer) Then
		//----------------------------------------------------------------------------------------------------------------------------------
		// If we found a Reporting Desktop window, open the report
		//-----------------------------------------------------------------------------------------------------------------------------------
		If lw_basewindow_rightangle_explorer.Dynamic of_create_report(al_reportconfigid, ls_reporttype) Then
			lu_search = lw_basewindow_rightangle_explorer.Dynamic of_get_current_report()
			#IF  defined PBDOTNET THEN
				lw_basewindow_rightangle_explorer.event resize(0, lw_basewindow_rightangle_explorer.width, lw_basewindow_rightangle_explorer.height)
			#ELSE
				lw_basewindow_rightangle_explorer.TriggerEvent('Resize')
			#END IF
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the search object
//-----------------------------------------------------------------------------------------------------------------------------------
Return lu_search
end function

public function userobject of_open_report (long al_reportconfigid, string as_reporttype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_report()
//	Arguments:  as_reportname - The report name in the registry
//	Overview:   This will get the reportconfig id and send it to another version of of_open_report()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_open_report(al_reportconfigid, as_reporttype, '')
end function

public function userobject of_open_report (long al_reportconfigid, string as_reporttype, string as_reportparameters);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_report()
//	Arguments:  as_reportname - The report name in the registry
//	Overview:   This will get the reportconfig id and send it to another version of of_open_report()
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject lu_search
n_report ln_report
Window lw_basewindow_rightangle_explorer

If al_reportconfigid <= 0 Or IsNull(al_reportconfigid) Then Return lu_search

ln_report = Create n_report
ln_report.of_init(al_reportconfigid, Upper(Trim(as_reporttype)) = "S", True)
ln_report.of_set_options(as_reportparameters)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the adapter is valid, open the report there
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_dynamic_gui_report_adapter) Then Return iu_dynamic_gui_report_adapter.Dynamic of_open_report(ln_report)

//----------------------------------------------------------------------------------------------------------------------------------
// Open a report in the reporting desktop
//-----------------------------------------------------------------------------------------------------------------------------------
lw_basewindow_rightangle_explorer = This.of_get_reporting_desktop()
	
If Not IsValid(lw_basewindow_rightangle_explorer) Then Return lu_search

//----------------------------------------------------------------------------------------------------------------------------------
// If we found a Reporting Desktop window, open the report
//-----------------------------------------------------------------------------------------------------------------------------------
lw_basewindow_rightangle_explorer.Dynamic of_open_report(ln_report)
lu_search = lw_basewindow_rightangle_explorer.Dynamic of_get_current_report()
#IF  defined PBDOTNET THEN
	lw_basewindow_rightangle_explorer.event resize(0, lw_basewindow_rightangle_explorer.width, lw_basewindow_rightangle_explorer.height)
#ELSE
	lw_basewindow_rightangle_explorer.TriggerEvent('Resize')
#END IF

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the search object
//-----------------------------------------------------------------------------------------------------------------------------------
Return lu_search
end function

public function window of_get_reporting_desktop ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_get_reporting_desktop()
// Overview:    This will look for a report window.  If there is one open (defaulting to active sheet) it will search there
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_entityID
boolean bValid, bfound = false
window  wSheet
Window wFound

//Check the active sheet first because it takes prescedence
If Not IsValid(gn_globals.of_get_frame()) Then Return wFound

wSheet = gn_globals.of_get_frame().Dynamic GetActiveSheet()
If IsValid(wSheet) Then
	If wSheet.ClassName() = 'w_basewindow_cusfocus_explorer' Then
		wFound = wSheet
		bfound = True
	End If
End If

//The following script loops through the open sheets in front-to-back order and looks for a search window
If Not bfound Then
	wSheet = gn_globals.of_get_frame().Dynamic GetFirstSheet()
	IF IsValid(wSheet) THEN
		DO
			If IsValid(wSheet) Then
					If wSheet.ClassName() = 'w_basewindow_cusfocus_explorer' Then
						wFound = wSheet
						bfound = True
						Exit
					End If
			Else
			End If
			wSheet = gn_globals.of_get_frame().Dynamic GetNextSheet(wSheet)
			bValid = IsValid (wSheet)
		LOOP WHILE bValid
	END IF
End If


// If one is found, call the navigate event, else open the window and trigger the event
If Not bfound Then
	wFound = gn_globals.Dynamic of_OpenSheet('w_basewindow_cusfocus_explorer')
End If

wFound.BringToTop = True
Return wFound




end function

protected subroutine of_create_datastore (long al_reportconfigid, string as_reportconfigtype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_create_datastore()
// Arguments:	al_reportconfigid - The report id
//					as_reportconfigtype - The report type either Runnable report or a SavedReport
// Overview:   This will return the display object for the person to open
// Created by: 
// History:		
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_row
Long		ll_reportconfigid[]
String	ls_reporttype[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the composite to false if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_report_information.RowCount() = 0 Then ib_IsComposite = False

//-----------------------------------------------------------------------------------------------------------------------------------
// See if the row is already there
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = This.of_find_row(al_reportconfigid, as_reportconfigtype)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if it is already there
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ll_row) And ll_row > 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the row into the datawindow.  This will not discard the rows before retrieving
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_get_reportconfig(al_reportconfigid,as_reportconfigtype, ids_report_information) < 1 Then
	ids_report_information.Retrieve(al_reportconfigid,as_reportconfigtype)
End If

end subroutine

public function string of_init (userobject au_search, long al_reportconfigid, string as_reporttype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_init()
// Created by:	
// History:		
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return = ''

//-----------------------------------------------------------------------------------------------------------------------------------
//	Return if the object is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Then Return 'Error:  The report object is not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
//	Initialize the report if it has not already
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = au_search.Dynamic of_get_properties().of_init(al_reportconfigid, Upper(Trim(as_reporttype)) = 'S', True)

//-----------------------------------------------------------------------------------------------------------------------------------
//	Set the picture name to be the same if it isn't a composite report
//-----------------------------------------------------------------------------------------------------------------------------------
/**///Move to u_search
If IsValid(au_search.Dynamic of_get_adapter()) Then
	If Not au_search.Dynamic of_get_adapter().of_get_properties().of_get('IsCompositeReport') = 'Y' Then
		au_search.Dynamic of_get_adapter().of_set('picturename', au_search.Dynamic of_get_properties().of_get('displayobjecticon'))
	End If
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the dao on the report
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsValid(au_search.Dynamic of_get_properties()) Then au_search.Dynamic of_setdao(au_search.Dynamic of_get_properties())
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Return
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

on n_report_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_report_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      constructor
// Overrides:  No
// Overview:   Instantiate transaction object
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

ids_report_information = Create n_datastore_append
ids_report_information.DataObject = "d_reportconfig_information_cache"
ids_report_information.SetTransObject(SQLCA)

ids_report_information_all = gn_globals.in_cache.of_get_cache_reference('reportconfig')
end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Destructor
// Overrides:  No
// Overview:   Destroy instance objects
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(ids_report_information) Then 
	Destroy ids_report_information
End If
end event

