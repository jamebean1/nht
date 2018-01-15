$PBExportHeader$n_navigation_manager.sru
$PBExportComments$This is the global navigation object.  It receives all the navigation messages and routes them to the correct destination.
forward
global type n_navigation_manager from nonvisualobject
end type
end forward

global type n_navigation_manager from nonvisualobject
event ue_notify ( string as_message,  any aa_arg )
end type
global n_navigation_manager n_navigation_manager

type variables
Protected:
	NonVisualObject in_client_navigation_object
end variables

forward prototypes
public subroutine of_navigate_obligation (string as_action, string as_parameters)
public subroutine of_navigate_processlog (string as_action, n_bag an_bag)
public subroutine of_get_open_reports (ref userobject au_dynamic_gui_report_adapter[])
public subroutine of_link ()
public subroutine of_navigate_integrationservices (string as_action, string as_parameters)
public subroutine of_navigate_ticklermessage (string as_action, string as_parameters)
public subroutine of_navigate_file (string as_action, string as_parameters)
public subroutine of_navigate_accounting (string as_action, string as_parameters, any an_bag)
public function window of_find_window (string as_windowname)
public subroutine of_search ()
public subroutine of_navigate_savedreport (string as_action, string as_parameters, string as_source)
end prototypes

event ue_notify(string as_message, any aa_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   this event recieves all the navigation messages from the system.
//					 it will direct the message to the correct entity navigation function.
//					 search is directed to one function for all entities because it will be common for all entities
// Created by: Blake Doerr
// History:    12/4/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
//	10/25/2001	TSB	Added the Create Invoice Functionality to the accounting navigation area.
// 02/04/2002  JJF   Added the Value Taxes functionality to get movement and financial taxes to acct.
// 08/08/2002  JJF 	Added the Book Estimates
//	07/29/2003	HMD	Added 'create sales invoice' 35194
// 09/22/2003  JJF 	Added Navigation to Saved report from NetOutArchive
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_created_locally = False
String	ls_argument
String	ls_arguments[]
String	ls_data = ''
String	ls_entity = ''
String	ls_action = ''
String	ls_entity_source = ''
String	ls_reportconfigid
Long		ll_upperbound
Long		ll_index
Long		ll_position
Long		ll_source_entity_id
Long		ll_null
Long		ll_reportconfigid
Long		ll_slsinvcelgid
Long		ll_svdrprtid

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions 		ln_string_functions
//n_entity_drag_message 	ln_entity_drag_message
n_bag							ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// Manage the Pointer
//-----------------------------------------------------------------------------------------------------------------------------------
SetPointer(hourglass!)
SetNull(ll_reportconfigid)
ls_argument = String(aa_arg)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we recieve an entity drag message, we can do nothing, otherwise we have to painstakinly parse the strings
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(ClassName(aa_arg)))
	Case 'n_bag'
		ln_bag = aa_arg
		ls_entity			= Lower(Trim(String(ln_bag.of_get('Entity'))))
		ls_action			= Lower(Trim(String(ln_bag.of_get('Action'))))
//	Case 'n_entity_drag_message'
//		ln_entity_drag_message = aa_arg
//		ls_action = ln_entity_drag_message.of_get_action()
	Case Else
		If Pos(Lower(ls_argument), 'data="') > 0 Then
			ls_entity			= Trim(gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'Entity'))
			ls_entity_source	= Trim(gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'Source'))
			ls_reportconfigid	= Trim(gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'RprtCnfgID'))
			ls_action			= Trim(gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'Action'))
			
			ls_data	= Trim(Mid(ls_argument, Pos(Lower(ls_argument), 'data="') + 5))
			
			If Left(ls_data, 1) = '"' And Right(ls_data, 1) = '"' Then
				ls_data = Left(ls_data, Len(ls_data) - 1)
				ls_data = Right(ls_data, Len(ls_data) - 1)
			End If
			
			If IsNumber(ls_reportconfigid) And Not IsNull(ls_reportconfigid) Then
				ll_reportconfigid = Long(ls_reportconfigid)
			End If
		Else
			//Get the string into an array.  The string must be comma delimited to work correctly
			gn_globals.in_string_functions.of_parse_string(ls_argument, ',', ls_arguments[])
			ll_upperbound = UpperBound(ls_arguments[])
			
			//Get the entity name
			IF ll_upperbound > 0 Then
				ll_position = Pos(ls_arguments[1], '=')
				ls_entity = Trim(Right(ls_arguments[1], Len(ls_arguments[1]) - ll_position))
			
				//Get the entity source
				IF ll_upperbound > 1 Then
					ll_position = Pos(ls_arguments[2], '=')
					ls_entity_source = Trim(Right(ls_arguments[2], Len(ls_arguments[2]) - ll_position))
					
					//If the source was passed as an id, convert it to a name
					If IsNumber(ls_entity_source) Then
						ll_source_entity_id = Long(ls_entity_source)
						Select	EnttyNme
						Into		:ls_entity_source
						From		Entity
						Where		EnttyId = :ll_source_entity_id;
					End If
					
					//Get the entity action
					If ll_upperbound > 2 Then
						ll_position = Pos(ls_arguments[3], '=')
						ls_action = Trim(Right(ls_arguments[3], Len(ls_arguments[3]) - ll_position))
				
						//Get the entity data parameters to pass
						For ll_index = 4 To UpperBound(ls_arguments[])
							ls_data = ls_data + ls_arguments[ll_index] + ',' 
						Next
				
						ls_data = Left(ls_data, Len(ls_data) - 1)
					End If
				End IF
			End If
		End If


		//-----------------------------------------------------------------------------------------------------------------------------------
		// Populate the entity drag message object

		//-----------------------------------------------------------------------------------------------------------------------------------
//		ln_entity_drag_message.of_set_entity(ls_entity_source)
//		ln_entity_drag_message.of_set_action(ls_action)
//		ln_entity_drag_message.of_set_destination_entity(ls_entity)
//		ln_entity_drag_message.of_set_destination_reportconfigid(Long(ls_reportconfigid))
//		ln_entity_drag_message.of_add_item(ls_data)
End Choose

If Not IsValid(ln_bag) Then
	ln_bag = Create n_bag
	lb_created_locally		= True
	ln_bag.of_set('Entity', 					trim(ls_entity))
	ln_bag.of_set('Action', 					trim(ls_action))
	ln_bag.of_set('Data', 						trim(ls_data))
	ln_bag.of_set('Source', 					trim(ls_entity_source))
	ln_bag.of_set('RprtCnfgID', 				Trim(ls_reportconfigid))
//	If IsValid(ln_entity_drag_message) Then
//		ln_bag.of_set('Navigation Message', 	ln_entity_drag_message)
//	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are navigating to another report, just pass the drag message to this function
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(ls_action))
	Case 'search', 'reportnavigation'
	//	This.of_search(ln_entity_drag_message)
		If lb_created_locally And IsValid(ln_bag) Then Destroy ln_bag
		Return

	//KCS Begin Added 21279
	Case 'link'
	//	This.of_link(ln_entity_drag_message)
		If lb_created_locally And IsValid(ln_bag) Then Destroy ln_bag
		Return		
	//KCS End Added 21279
End Choose






//-----------------------------------------------------------------------------------------------------------------------------------
// If it is 'Value' then let the valuation function handle it.
//-----------------------------------------------------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------------------------------------------------
// If it is 'Value taxes' then let accounting function handle it.
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(ls_action)) = 'value taxes' Then
	of_navigate_accounting (ls_action,lower("entity=" + trim(ls_entity)) + "," + Lower("action=" + Trim(ls_action)) + ',' + ls_data, ln_bag)
	If lb_created_locally And IsValid(ln_bag) Then Destroy ln_bag
	Return
End If
// JJF End Added 02/04/2002
// JJF Begin added 08/08/2002
//-----------------------------------------------------------------------------------------------------------------------------------
// If it is 'book estimates' then let accounting function handle it.
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(ls_action)) = 'book estimates' Then
	of_navigate_accounting (ls_action,lower("entity=" + trim(ls_entity)) + "," + Lower("action=" + Trim(ls_action)) + ',' + ls_data, ln_bag)
	If lb_created_locally And IsValid(ln_bag) Then Destroy ln_bag
	Return
End If
// JJF End Added 08/08/2002
//----------------------------------------------------------------------------------------------------------------------------------
//Choose the correction navigation function based on the entity.  If the entity is not valid it will return.		
//----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower (Trim(ls_entity))

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Miscellaneous
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'savedreport', 'invoicearchive', 'netoutarchive'
		of_navigate_savedreport			(ls_action, ls_data, ls_entity_source)
	Case 'file'
		of_navigate_file					(ls_action, ls_data)
	Case 'ticklermessage'
		of_navigate_ticklermessage		(ls_action, ls_data)
	Case 'processlog'
		of_navigate_processlog			(ls_action, ln_bag)
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Integration Services NWP added 8/08/2002
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'interfacedatarecord'
		of_navigate_integrationservices(ls_action, ls_data)
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// This will call the clients version of the navigation manager.  This allows them to add anything they want to the right click menus
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(in_client_navigation_object) Then
	//in_client_navigation_object.Dynamic Event ue_notify('Navigation', ln_entity_drag_message)
End If

If lb_created_locally And IsValid(ln_bag) Then Destroy ln_bag
end event

public subroutine of_navigate_obligation (string as_action, string as_parameters);
end subroutine

public subroutine of_navigate_processlog (string as_action, n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_navigate_processlog()
//	Arguments:  as_action - The action that is too occur, currently the only action that is supported is 'Search'
//					an_bag - Contains the items needed for navigation
//	Overview:   Navigates to the Search RAMQ Log report
//	Created by:	Pat Newgent
//	History: 	6/4/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_entity_drag_message ln_entity_drag_message
Long	ll_RprtCnfgID

//ln_entity_drag_message = an_bag.of_get('Navigation Message')

//-----------------------------------------------------------------------------------------------------------------------------------
//  Determine the default navigational report for the ProcessLog entity, this should be the Search RAMQ Log report
//-----------------------------------------------------------------------------------------------------------------------------------
Select 	EnttyRprtCnfgRprtCnfgID
Into		:ll_RprtCnfgID
From 		Entity
			Inner Join EntityReportconfig 
				on		Entity.EnttyID = EntityReportconfig.EnttyRprtCnfgEnttyID
Where 	EnttyNme = 'ProcessLog'
and		EnttyRprtCnfgIsDflt = 'Y';


//-----------------------------------------------------------------------------------------------------------------------------------
//  Set the Default ReportConfig ID
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_entity_drag_message.of_set_destination_reportconfigid(ll_RprtCnfgID)

//-----------------------------------------------------------------------------------------------------------------------------------
//  Insure that the action item is set to Search, when navigating from TicklerMessage the action item is always "Open"
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_entity_drag_message.of_set_Action('Search')


//-----------------------------------------------------------------------------------------------------------------------------------
//  Navigate to the report
//-----------------------------------------------------------------------------------------------------------------------------------
//this.of_search(ln_entity_drag_message)


Return
end subroutine

public subroutine of_get_open_reports (ref userobject au_dynamic_gui_report_adapter[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_open_reports()
// Arguments:   au_dynamic_gui_report_adapter[] - the reports we find
// Overview:    This will look for all reports in all windows
// Created by:  
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Window  		wSheet
Window		lw_activesheet
Window		lw_basewindow_rightangle_explorer[]
UserObject	lu_dynamic_gui_report_adapter[]
UserObject	lu_dynamic_gui_report_adapter_all[]
UserObject	lu_dynamic_gui_report_adapter_empty[]
Long			ll_index
Long			ll_index2
String		ls_windowname	= 'w_basewindow_rightangle_explorer'

//-----------------------------------------------------------------------------------------------------------------------------------
// Check the active sheet first because it takes prescedence
//-----------------------------------------------------------------------------------------------------------------------------------
wSheet = gn_globals.of_get_frame().Dynamic GetActiveSheet()
If IsValid(wSheet) Then
	lw_activesheet = wSheet
	
	If wSheet.ClassName() = ls_windowname Then
		lw_basewindow_rightangle_explorer[UpperBound(lw_basewindow_rightangle_explorer[]) + 1] = wSheet
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// The following script loops through the open sheets in front-to-back order and looks for a window
//-----------------------------------------------------------------------------------------------------------------------------------
wSheet = gn_globals.of_get_frame().Dynamic GetFirstSheet()
DO
	If IsValid(wSheet) Then
		If wSheet.ClassName() = ls_windowname And wSheet <> lw_activesheet Then lw_basewindow_rightangle_explorer[UpperBound(lw_basewindow_rightangle_explorer[]) + 1] = wSheet
	End If
	
	wSheet = gn_globals.of_get_frame().Dynamic GetNextSheet(wSheet)
Loop While IsValid(wSheet)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the adapters on all the windows
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(lw_basewindow_rightangle_explorer[])
	lw_basewindow_rightangle_explorer[ll_index].Dynamic of_get_open_reports(lu_dynamic_gui_report_adapter[])
	
	For ll_index2 = 1 To UpperBound(lu_dynamic_gui_report_adapter[])
		lu_dynamic_gui_report_adapter_all[UpperBound(lu_dynamic_gui_report_adapter_all[]) + 1] = lu_dynamic_gui_report_adapter[ll_index2]
	Next
	
	lu_dynamic_gui_report_adapter[] = lu_dynamic_gui_report_adapter_empty[]
Next

au_dynamic_gui_report_adapter[]  = lu_dynamic_gui_report_adapter_all[]
end subroutine

public subroutine of_link ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_link()
// Arguments:   an_entity_drag_message - The entity drag message that contains all the information about the message
// Overview:    Very similar to the Search except it will always open the Linking report.
// Created by:  Kyle Smith
// History:     12/4/01 - First Created 21279
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject lu_dynamic_gui
Window lw_basewindow_rightangle_explorer

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_reportconfigid
String	ls_entity

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the w_search window
//-----------------------------------------------------------------------------------------------------------------------------------
lw_basewindow_rightangle_explorer = of_find_window('w_basewindow_rightangle_explorer')

//-----------------------------------------------------------------------------------------------------------------------------------
// If the reportconfig id is valid, use that, otherwise open the default report for the destination entity
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lw_basewindow_rightangle_explorer.Dynamic of_open_report('link')) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the current adapter on the window.  It should be the one we just opened
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui = lw_basewindow_rightangle_explorer.Dynamic of_get_current_adapter()

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if it isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lu_dynamic_gui) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the drag message on the message object
//-----------------------------------------------------------------------------------------------------------------------------------
//Message.PowerObjectParm = an_entity_drag_message

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the dragdrop event on the gui
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui.Event Dragdrop(lu_dynamic_gui)
end subroutine

public subroutine of_navigate_integrationservices (string as_action, string as_parameters);// Function:  of_navigate_integrationservices()
// Arguments:   as_action - The action that will be performed (e.g. Search, Edit, Inactivate, Revalue, . . .)
//					 as_parameters - a comma delimited list of the parameters (e.g. 'HdrID = 2000, DtlID = 234')
// Overview:    This will perform all the navigation for the integration services domain
// Created by:  
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
NonVisualObject ln_navigate_integrationservices
ln_navigate_integrationservices = Create Using 'n_navigate_integrationservices'
ln_navigate_integrationservices.Dynamic Event ue_notify(as_action, as_parameters)
destroy ln_navigate_integrationservices
end subroutine

public subroutine of_navigate_ticklermessage (string as_action, string as_parameters);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_navigate_ticklermessage()
// Arguments:   as_action - The action that will be performed (e.g. Search, Edit, Inactivate, Revalue, . . .)
//					 as_parameters - a comma delimited list of the parameters (e.g. 'HdrID = 2000, DtlID = 234')
// Overview:    This will perform all the navigation for the ticklermessage entity
// Created by:  Blake Doerr
// History:     12/4/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_position
String ls_parameter
Window lw_ticklermessage_open
Window	lw_frame
lw_frame = gn_globals.of_get_frame()
//Perform the correct action based on as_action
Choose Case Lower(as_action)
	Case 'open'
		ll_position = pos(as_parameters, '=')
		ls_parameter = Right(as_parameters, Len(as_parameters) - ll_position)
		OpenWithParm(lw_ticklermessage_open, Double(ls_parameter), 'w_ticklermessage_open', lw_frame)
End Choose
end subroutine

public subroutine of_navigate_file (string as_action, string as_parameters);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_navigate_file()
// Arguments:   as_action - The action that will be performed (e.g. Search, Edit, Inactivate, Revalue, . . .)
//					 as_parameters - a comma delimited list of the parameters (e.g. 'HdrID = 2000, DtlID = 234')
// Overview:    This will perform all the navigation for the contract entity
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_position
String ls_parameter
n_win32_api_calls ln_win32_api_calls
UserObject lu_search
NonVisualObject ln_report_manager 
Datawindow ldw_data

If Not IsValid(gn_globals.of_Get_frame()) Then Return

//Perform the correct action based on as_action
Choose Case Lower(as_action)
	Case 'open'
		ll_position = pos(as_parameters, '=')
		ls_parameter = Right(as_parameters, Len(as_parameters) - ll_position)
		Choose Case Upper(Right(ls_parameter, 3))
			Case 'PSR'
				ln_report_manager = Create Using 'n_report_manager '
				lu_search = ln_report_manager.Dynamic of_open_report('SearchSavedReport')
				If IsValid(lu_search) Then
					ldw_data = lu_search.Dynamic of_get_report_dw()
					ldw_data.Dataobject = ls_parameter
					lu_search.Dynamic of_settitle('CustomerFocus File Viewer')
				End If
				Destroy ln_report_manager
			Case Else
				ln_win32_api_calls = Create n_win32_api_calls 
				ln_win32_api_calls.of_run_file_with_association(gn_globals.of_Get_frame(), 'open', ls_parameter, '', '', 0)
				
				Destroy ln_win32_api_calls 
		End Choose
End Choose
end subroutine

public subroutine of_navigate_accounting (string as_action, string as_parameters, any an_bag);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_navigate_accounting()
// Arguments:   as_action - The action that will be performed (e.g. Search, Edit, Inactivate, Revalue, . . .)
//					 as_parameters - a comma delimited list of the parameters (e.g. 'HdrID = 2000, DtlID = 234')
// Overview:    This will perform all the navigation for the accounting domain
// Created by:  Joel White
// History:     5/4/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//	10/25/2001	TSB	Added the Create Invoice Functionality
//	07/29/2003	HMD	Added 'create sales invoice' 35194
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
NonVisualObject ln_navigate_accounting
ln_navigate_accounting = Create Using 'n_navigate_accounting'

Choose Case lower(trim(as_action))
	Case 'value taxes', 'value taxes on', 'create invoice', 'book estimates', 'change net out status','create sales invoice'
		ln_navigate_accounting.Dynamic Event ue_notify(as_action, an_bag)
	Case else
		ln_navigate_accounting.Dynamic Event ue_notify(as_action, as_parameters)
end choose

destroy ln_navigate_accounting
end subroutine

public function window of_find_window (string as_windowname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_find_window()
// Arguments:   as_windowname - the window name
// Overview:    This will look for a particular window.
// Created by:  
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean 	bValid
Boolean	bfound = false
Window  	wSheet
Window 	wFound

If Not IsValid(gn_globals.of_get_frame()) Then Return wFound

//-----------------------------------------------------------------------------------------------------------------------------------
// Check the active sheet first because it takes prescedence
//-----------------------------------------------------------------------------------------------------------------------------------
wSheet = gn_globals.of_get_frame().Dynamic GetActiveSheet()
If IsValid(wSheet) Then
	If wSheet.ClassName() = as_windowname Then
		wFound = wSheet
		bfound = True
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// The following script loops through the open sheets in front-to-back order and looks for a window
//-----------------------------------------------------------------------------------------------------------------------------------
If Not bfound Then
	wSheet = gn_globals.of_get_frame().Dynamic GetFirstSheet()
	IF IsValid(wSheet) THEN
		DO
			If IsValid(wSheet) Then
					If wSheet.ClassName() = as_windowname Then
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

//-----------------------------------------------------------------------------------------------------------------------------------
// If one is found, call the navigate event, else open the window and trigger the event
//-----------------------------------------------------------------------------------------------------------------------------------
If Not bfound Then
	wFound = gn_globals.Dynamic of_OpenSheet(as_windowname)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Bring the window to the top and return
//-----------------------------------------------------------------------------------------------------------------------------------
wFound.BringToTop = True
Return wFound




end function

public subroutine of_search ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_search()
// Arguments:   an_entity_drag_message - The entity drag message that contains all the information about the message
// Overview:    This will look for a search window.  If there is one open (defaulting to active sheet) it will search there
// Created by:  
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
UserObject 	lu_dynamic_gui
UserObject 	lu_search[]
Window		lw_basewindow_rightangle_explorer


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_reportconfigid
Long	ll_dataobjectstateid
Long	ll_pivottableid
Long	ll_nestedreportid
Long	ll_FilterViewID
String	ls_entity

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the w_search window
//-----------------------------------------------------------------------------------------------------------------------------------
lw_basewindow_rightangle_explorer = of_find_window('w_basewindow_rightangle_explorer')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the reportconfig id off the drag message
//-----------------------------------------------------------------------------------------------------------------------------------
//ll_reportconfigid = an_entity_drag_message.of_get_destination_reportconfigid()

//-----------------------------------------------------------------------------------------------------------------------------------
// If the reportconfig id is valid, use that, otherwise open the default report for the destination entity
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_reportconfigid > 0 And Not IsNull(ll_reportconfigid) Then
	If Not lw_basewindow_rightangle_explorer.Dynamic of_open_report(ll_reportconfigid, 'R') Then Return
Else
//	ls_entity = an_entity_drag_message.of_get_destination_entity()
	
	If Len(Trim(ls_entity)) = 0 Then Return
	
	If Not IsValid(lw_basewindow_rightangle_explorer.Dynamic of_open_report(ls_entity)) Then Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the current adapter on the window.  It should be the one we just opened
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui = lw_basewindow_rightangle_explorer.Dynamic of_get_current_adapter()


long ll_row, ll_index
string ls_null

SetNull(ls_null)

//ll_row = Upperbound(an_entity_drag_message.is_key[])
//n_string_functions ln_string_functions


For ll_index = 1 to ll_row Step 1
//	gn_globals.in_string_functions.of_replace_all(an_entity_drag_message.is_key[ll_index], '[equals]', '=')
//	gn_globals.in_string_functions.of_replace_all(an_entity_drag_message.is_key[ll_index], '[comma]', ',')

//	ll_dataobjectstateid	= Long(gn_globals.in_string_functions.of_find_argument(an_entity_drag_message.is_key[ll_index], ',', 'dtaobjctstteidnty'))
//	gn_globals.in_string_functions.of_replace_argument('dtaobjctstteidnty', an_entity_drag_message.is_key[ll_index], ',', ls_null)
//	ll_pivottableid		= Long(gn_globals.in_string_functions.of_find_argument(an_entity_drag_message.is_key[ll_index], ',', 'rprtcnfgpvttbleid'))
//	gn_globals.in_string_functions.of_replace_argument('rprtcnfgpvttbleid', an_entity_drag_message.is_key[ll_index], ',', ls_null)
//	ll_nestedreportid		= Long(gn_globals.in_string_functions.of_find_argument(an_entity_drag_message.is_key[ll_index], ',', 'rprtcnfgnstdid'))
//	gn_globals.in_string_functions.of_replace_argument('rprtcnfgnstdid', an_entity_drag_message.is_key[ll_index], ',', ls_null)
//	ll_FilterViewID		= Long(gn_globals.in_string_functions.of_find_argument(an_entity_drag_message.is_key[ll_index], ',', 'FilterViewID'))
//	gn_globals.in_string_functions.of_replace_argument('FilterViewID', an_entity_drag_message.is_key[ll_index], ',', ls_null)
//	
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if it isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lu_dynamic_gui) Then Return

lu_dynamic_gui.Dynamic of_get_reports(lu_search[])

If UpperBound(lu_search[]) > 0 Then
	If Not IsNull(ll_dataobjectstateid) And ll_dataobjectstateid > 0 Then
		gn_globals.in_subscription_service.of_message('apply view id', String(ll_dataobjectstateid), lu_search[1].Dynamic of_get_report_dw())
	End If
	
	If Not IsNull(ll_nestedreportid) And ll_nestedreportid > 0 Then
		lu_search[1].Event Dynamic ue_notify('apply nested report', ll_nestedreportid)
	End If

	If Not IsNull(ll_FilterViewID) And ll_FilterViewID > 0 Then
		lu_search[1].Event Dynamic ue_notify('apply filter view', ll_FilterViewID)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the drag message on the message object
//-----------------------------------------------------------------------------------------------------------------------------------
//Message.PowerObjectParm = an_entity_drag_message

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the dragdrop event on the gui
//-----------------------------------------------------------------------------------------------------------------------------------
lu_dynamic_gui.Event Dragdrop(lu_dynamic_gui)

If UpperBound(lu_search[]) > 0 Then
	If Not IsNull(ll_pivottableid) And ll_pivottableid > 0 Then
		lu_search[1].Dynamic Event ue_notify('pivot table view', String(ll_pivottableid))
	End If
End If
end subroutine

public subroutine of_navigate_savedreport (string as_action, string as_parameters, string as_source);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_navigate_savedreport()
// Arguments:   as_action - The action that will be performed (e.g. Search, Edit, Inactivate, Revalue, . . .)
//					 as_parameters - a comma delimited list of the parameters (e.g. 'HdrID = 2000, DtlID = 234')
// Overview:    This will perform all the navigation for the savedreport entity
// Created by:  Blake Doerr
// History:     12/4/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

////-----------------------------------------------------------------------------------------------------------------------------------
//// Local Objects
////-----------------------------------------------------------------------------------------------------------------------------------
//Long	ll_savedreportid, ll_sourceid, ll_count
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Local Objects
////-----------------------------------------------------------------------------------------------------------------------------------
//Window	lw_basewindow_rightangle_explorer
//Window	lw_deal_archive_select_document
//
////-----------------------------------------------------------------------------------------------------------------------------------
//// Case statement for the different actions
////-----------------------------------------------------------------------------------------------------------------------------------
//Choose Case Lower(Trim(as_action))
//	Case 'compress'
//		Long	 i, ll_blbobjctid, ll_SvdRprtID
//		string ls_name[], ls_value[], ls_compression
//		blob	lb_report
//		//n_string_functions ln_string
////		n_blob_manipulator ln_blob
////		ln_blob = Create n_blob_manipulator
//		
//		gn_globals.in_string_functions.of_parse_arguments(as_parameters, ls_name, ls_value)
//		For i = 1 to Upperbound( ls_value )
//			
//			ll_SvdRprtID = long(ls_value[i])
//			
//			select SvdRprtBlbObjctID, BlbObjctCmprssnTpe
//			Into	 :ll_BlbObjctID,
//					 :ls_Compression
//			From	 SavedReport
//					 Inner Join BlobObject on (SvdRprtBlbObjctID = BlbObjctID)
//			Where	 SvdRprtID = :ll_SvdRprtID
//			;
//			
//		//	if lower(ls_compression) <> 'zli Compression' then
//	//			lb_report = ln_blob.of_retrieve_blob(ll_BlbObjctID)
//	//			if ln_blob.of_update_blob(lb_report,ll_BlbObjctID, True) = 0 then
////					gn_globals.in_subscription_service.of_message('Saved Report Compressed', 'SvdRprtID=' + ls_value[i])
//		//		end if
//			end if			
//		Next
//		
//	Case 'open'
//		Choose Case Lower(Trim(as_source))
//			Case 'contractarchive'
//				
//				ll_sourceid = Long(Mid(as_parameters, Pos(as_parameters, '=') + 1))
//				
//				Select Count(*)
//				Into :ll_count
//				From ArchivedDocument
//				Where		DlHdrArchveID			= :ll_sourceid
//				Using		SQLCA;
//				
//				If ll_count > 1 Then
//					OpenWithParm(lw_deal_archive_select_document, ll_sourceid, 'w_deal_archive_select_document', gn_globals.of_get_frame())
//					ll_savedreportid = message.doubleparm
//					if ll_savedreportid = 0 or isnull(ll_savedreportid) then 
//						return
//					end if
//				else
//				
//					Select	ArchivalID
//					Into		:ll_savedreportid
//					From		DealHeaderArchive
//					Where		DlHdrArchveID			= :ll_sourceid
//					Using		SQLCA;
//				
//				end if
//				
//			Case 'invoicearchive'
//				ll_sourceid = Long(Mid(as_parameters, Pos(as_parameters, '=') + 1))
//		
//				SELECT 	SalesInvoiceLog.SvdRprtID  
//		   	INTO 		:ll_savedreportid  
//		    	FROM 		SalesInvoiceLog  
//		   	WHERE 	SalesInvoiceLog.SlsInvceLgID = :ll_sourceid
//				Using		SQLCA;
//				
//			Case 'netoutarchive'
//				ll_sourceid = Long(Mid(as_parameters, Pos(as_parameters, '=') + 1))
//		
//				SELECT 	NetOutLog.SvdRprtID  
//		   	INTO 		:ll_savedreportid  
//		    	FROM 		NetOutLog  
//		   	WHERE 	NetOutLog.NtOtLgID = :ll_sourceid
//				Using		SQLCA;
//
//			Case 'set'
//				ll_sourceid = Long(Mid(as_parameters, Pos(as_parameters, '=') + 1))
//				
//				Select	SavedReportID
//		   	INTO 		:ll_savedreportid  
//				From	PlannedMovement	(NoLock)
//				Where	PlnndMvtID 			= :ll_sourceid
//				Using		SQLCA;
//				
//			Case 'endinginventory'
//			Case 'movementdocument'
//				
//			Case Else
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				// Determine the saved report id
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				ll_savedreportid = Long(Mid(as_parameters, Pos(as_parameters, '=') + 1))
//		End Choose
//		
//		If ll_savedreportid <= 0 Or IsNull(ll_savedreportid) Then
////			gn_globals.in_messagebox.of_messagebox_validation('Could not find a Saved Report, one may not exist for this record')
//			Return
//		End If
//
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		// Find the w_search window
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		lw_basewindow_rightangle_explorer = of_find_window('w_basewindow_rightangle_explorer')
//
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		// Open the saved report in the reporting desktop
//		//-----------------------------------------------------------------------------------------------------------------------------------
//		lw_basewindow_rightangle_explorer.Dynamic of_open_report(ll_savedreportid ,'S')
//End Choose
end subroutine

on n_navigation_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_navigation_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   Initialize this object
// Created by: Blake Doerr
// History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_class_functions ln_class_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// See if this object is valid and is not this current object (otherwise we would have an infinite loop)
//-----------------------------------------------------------------------------------------------------------------------------------
If Not Lower(Trim(ClassName(This))) = 'n_navigation_manager_client' Then
	//If ln_class_functions.of_isvalid('n_navigation_manager_client') Then
	//	in_client_navigation_object = Create Using 'n_navigation_manager_client'
	//End If
End If
end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Destructor
// Overrides:  No
// Overview:   Deinitialize this object
// Created by: Blake Doerr
// History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
  
If IsValid(in_client_navigation_object) Then Destroy in_client_navigation_object
end event

