$PBExportHeader$n_navigation_options.sru
$PBExportComments$This is the nonvisual that creates m_dynamic based on entity actions.
forward
global type n_navigation_options from nonvisualobject
end type
end forward

global type n_navigation_options from nonvisualobject
event ue_notify ( string as_message,  any aany_argument )
end type
global n_navigation_options n_navigation_options

type variables
Private:
	Boolean	ib_subscribed
	Boolean	ib_batchmode = False
	string 	is_physical_columns
	String	is_columnnamephysical[]
	String	is_columnnamelogical[]
	String	is_columndescription[]
	Long		il_columnnumber[]
	
//Information objects
	PowerObject io_datasource
	PowerObject ipo_menutarget
	Transaction	ixctn_transaction
	transaction it_transaction
	n_data_mover	in_data_mover
	n_bag				in_bag
	n_bag				in_superfluous_bag[]
	
//Dynamic Menu Objects
	PowerObject	io_navigation_source_object
	PowerObject	io_navigation_detail_object

//State Data
	string is_excluded_action[]
	string is_navigationstring
	String	is_entity_adapter = ''
	String	is_navigation_parameter	= ''
	Long il_selected_rows[], il_current_row, il_rowcount
	Boolean ib_mailenabled = True, ib_multiplerowsselected = false
	Boolean ib_dragdrop_is_enabled = False
	Boolean	ib_report_detail_is_open = False
	Boolean	ib_IsDataCollection	= FALSE
	Boolean	ib_IsNavigationDestination = False
	Boolean	ib_EntityIsFullyDefinedByColumns = False

//These are for the many to many navigation keys
	Long		il_multiple_record_count
	Long 		il_key1[], il_key2[], il_key3[], il_key4[], il_key5[]
	Datetime idt_key1[]
	String 	is_key1[]
	String 	is_navigationstringmultiple[]

//Information for Dynamic Initialization (figure out entity from columns in DW)
	String 	is_navigationstring_column, is_entitydescription
	String 	is_entity_column
	Boolean 	ib_dynamic_entity_selection = False
	Boolean	ib_DynamicEntityUsesAllAvailableColumns = False
	Boolean	ib_NavigationInitOverridesEntity			= False
	Boolean	ib_AllowOpeningOfDetailReports	= False
	
//Information for Dynamic Navigation (source is not an entity)
	String	is_source_column[]

	Boolean	ib_EnttyCmplxKy
	Boolean	ib_UserAdded
	Boolean	ib_RecordHistory				= False
	Long		il_EnttyID
	Long		il_RprtDtbseID
	String	is_EnttyNme
	String	is_EnttyNvgtnStrdPrcdre
	String	is_EnttyDsplyNme
	String	is_EnttyDscrptnExprssn
	String	is_ViewerObject
	String	is_AdapterObject
	String	is_GUIObject
	String	is_GUIDataObject
	String	is_DAOObject
	String	is_DAODataObject
	String	is_KeyControllerTable
	String	is_KeyControllerColumn
	String	is_TemplateColumn
	String	is_TemplateAbbreviation
	String	is_NavigationTempTable
	String	is_EntityIconSmall
	String	is_EntityIconLarge
	String	is_OriginalEnttyNme
	
	Boolean	ib_response_window = FALSE
	
	String	is_from_entity
	String	is_action
	String	is_navigation_retrieval_argument
	Long		il_multiplerowsessionid

end variables

forward prototypes
protected subroutine of_subscribe ()
public subroutine of_addtofavorites (string as_entity[], string as_description[], string as_navigationstring[])
public subroutine of_addtohistory (string as_entity[], string as_description[], string as_navigationstring[])
public subroutine of_clicked (long xpos, long ypos, long row, ref dwobject dwo)
public function string of_deleteentityshortcut (long al_shorcutid[], string as_shortcuttype[])
public function n_entity_drag_message of_determine_selected_rows ()
public function boolean of_dragdrop (ref powerobject source, long row, ref dwobject dwo)
public subroutine of_dragleave (dragobject ao_source)
public subroutine of_exclude_action (string as_actionname)
public subroutine of_garbagecollect ()
public function boolean of_get_dragdrop ()
public function string of_get_entity ()
public function string of_get_navigation_string (long al_row)
private subroutine of_get_shortcuts (ref string as_entity[], ref string as_description[], ref string as_navigationstring[])
public function any of_getitem (powerobject adw_data, long al_row, string as_columnname)
public subroutine of_include_action (string as_actionname)
public subroutine of_interrogate_datawindow ()
public function boolean of_load_columns (powerobject a_dw)
public subroutine of_mail_enabled (boolean ab_mailenabled)
public function long of_navigate (any aany_argument)
public function long of_navigate (string as_from_entity, string as_action, string as_navigation_retrieval_argument, long al_multiplerowsessionid)
public subroutine of_pbm_mousemove (unsignedlong flags, long xpos, long ypos)
public subroutine of_rbuttondown (long xpos, long ypos, long row, ref dwobject dwo)
public function long of_renavigate ()
public subroutine of_retrieveend (long rowcount)
public function long of_retrievestart ()
public function long of_rowfocuschanging (long currentrow, long newrow)
public subroutine of_set_allow_detail_reports (powerobject ao_navigation_source_object, boolean ab_allowopeningofdetailreports)
public subroutine of_set_detail_report (powerobject ao_navigation_detail_object)
public subroutine of_set_dragdrop (boolean ab_dragdrop)
public subroutine of_set_menutarget (powerobject apo_menutarget)
public subroutine of_set_navigation_text (string as_navigationtext)
public subroutine of_set_navigationstring (string as_navigationstring, string as_entitydescription)
public subroutine of_setselecteddata (n_bag an_bag)
public subroutine of_setselectedrows (long al_rows[])
public subroutine of_retrieve_detail_report ()
public function long of_retrieve_navigated ()
public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic)
public subroutine of_set_navigationstring (string as_navigationstring)
public function boolean of_build_navigation_strings ()
public function boolean of_init (powerobject adw)
public function boolean of_init (ref transaction at_transaction, powerobject apo_source)
public function boolean of_init (ref transaction at_transaction, powerobject apo_source, string as_entity)
public subroutine of_rowfocuschanged (long row)
private function long of_insert_navigation_keys ()
private function long of_insert_navigation_keys (ref n_entity_drag_message an_entity_drag_message)
public subroutine of_doubleclicked (long xpos, long ypos, long row, dwobject dwo)
public function boolean of_load_entities ()
public subroutine of_add_parameters (long al_fromentityid, long al_toentityid, n_menu_dynamic am_menu, string as_message, any as_navigationstring, string as_parameter)
private subroutine of_set_entity (string as_entity)
public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public subroutine of_set_batch_mode (boolean ab_batchmode)
end prototypes

event ue_notify(string as_message, any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//					aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   9.5.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_description[]
String	ls_entity[]
String	ls_navigation_message[]
String	ls_action
String	ls_destination_entity
String	ls_message
String	ls_data
String	ls_parameters
String	ls_OpenWindowParam
String	ls_reportconfigid
String	ls_argument
String	ls_null
Long 		ll_index
Long		ll_reportconfigid
Long		ll_dataobjectstateid
Long		ll_pivottableid
Long		ll_RprtCnfgNstdID
Long		ll_FilterViewID

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_tickler_message 		ln_tickler_message
//n_string_functions 		ln_string_functions
n_entity_drag_message 	ln_entity_drag_message
n_bag 						ln_bag
PowerObject					lu_search[]
NonVisualObject			ln_nonvisual_window_opener
Window						lw_window

SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Case statement to decide what to do with the message
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_message))
	Case 'customize reports'
		ln_bag = Create n_bag
		ln_bag.of_set('EnttyID', il_EnttyID)
		ln_bag.of_set('UserID', gn_globals.il_userid)
		ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
		ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_navigate_customize_reports', ln_bag)
		Destroy ln_nonvisual_window_opener
	Case 'set report entity'
		ib_NavigationInitOverridesEntity = False
		This.of_init(SQLCA, io_datasource, String(aany_argument))
	Case 'filter'
		If io_datasource.Dynamic RowCount() > 0 Then
			il_rowcount = 0
			This.of_rowfocuschanged(il_current_row)
		End If
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Send a message with attachments
	//-----------------------------------------------------------------------------------------------------------------------------------
   Case 'send to mail recipient', 'add to favorites'
		This.of_get_shortcuts(ls_entity, ls_description, ls_navigation_message)
	
		Choose Case Lower(Trim(as_message))
			Case 'add to favorites'
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Add these to the EntityFavorites table
				//-----------------------------------------------------------------------------------------------------------------------------------
				SetPointer(HourGlass!)
				This.of_addtofavorites(ls_entity, ls_description, ls_navigation_message)
				
			Case 'send to mail recipient'
//				ln_tickler_message = Create n_tickler_message
//
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				// Add these attachments to the mail message
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				ln_tickler_message.of_set_attachments(ls_description[], ls_entity[], ls_navigation_message[])
//				
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				// Open the window with the ticklermessage object as a row
//				//-----------------------------------------------------------------------------------------------------------------------------------
//				OpenWithParm(lw_window, ln_tickler_message, 'w_ticklermessage_new')
		end choose
		
	Case 'reportdetailnavigation'
		
		ib_report_detail_is_open = True
		If Not IsValid(io_navigation_source_object) Or IsNull(io_navigation_source_object) Then Return
		
		ls_argument 	= String(aany_argument)
		ls_parameters 	= gn_globals.in_string_functions.of_find_argument(Lower(ls_argument), ',', 'parameter')
		
		gn_globals.in_string_functions.of_replace_all(ls_parameters, '[equals]', '=')
		gn_globals.in_string_functions.of_replace_all(ls_parameters, '[comma]', ',')
		
		ls_reportconfigid	= gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'RprtCnfgID')

		If ls_reportconfigid = '?' Then
			ls_argument = 'EnttyID=' + String(il_EnttyID) + ',' + ls_argument

			ln_bag = Create n_bag
			ln_bag.of_set('Argument', ls_argument)
			
			ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
			ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_navigate_select_report', ln_bag)
			Destroy ln_nonvisual_window_opener
			
			ls_argument			= String(ln_bag.of_get('Argument'))
			ls_reportconfigid	= gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'RprtCnfgID')
			ls_parameters 		= String(ln_bag.of_get('Parameters'))
			
			Destroy ln_bag
			
			If ls_reportconfigid = '?' Then Return
			gn_globals.in_string_functions.of_replace_all(ls_parameters, '[equals]', '=')
			gn_globals.in_string_functions.of_replace_all(ls_parameters, '[comma]', ',')
		End If
				
		//-----------------------------------------------------------------------------------------------------------------------------------
		//Find the OpenWindow string here & open that selection window
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_OpenWindowParam = gn_globals.in_string_functions.of_find_argument(ls_parameters, ',', 'openwindow')
		if ls_OpenWindowParam > '' or not(IsNull(ls_OpenWindowParam)) then

			ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
			ln_nonvisual_window_opener.Dynamic of_OpenWindow(ls_OpenWindowParam)
			Destroy ln_nonvisual_window_opener

			ls_parameters = Message.StringParm
			if ls_parameters = "" or IsNull(ls_parameters) then return
		end if
		
		io_navigation_source_object.Dynamic Event ue_notify('Open Detail Report', ls_argument)
		If Not IsValid(io_navigation_detail_object) Then Return

		ll_dataobjectstateid	= Long(gn_globals.in_string_functions.of_find_argument(ls_parameters, ',', 'dtaobjctstteidnty'))
		gn_globals.in_string_functions.of_replace_argument('dtaobjctstteidnty', ls_parameters, ',', ls_null)
		ll_pivottableid		= Long(gn_globals.in_string_functions.of_find_argument(ls_parameters, ',', 'rprtcnfgpvttbleid'))
		gn_globals.in_string_functions.of_replace_argument('rprtcnfgpvttbleid', ls_parameters, ',', ls_null)
		ll_RprtCnfgNstdID		= Long(gn_globals.in_string_functions.of_find_argument(ls_parameters, ',', 'RprtCnfgNstdID'))
		gn_globals.in_string_functions.of_replace_argument('RprtCnfgNstdID', ls_parameters, ',', ls_null)
		ll_FilterViewID		= Long(gn_globals.in_string_functions.of_find_argument(ls_parameters, ',', 'FilterViewID'))
		gn_globals.in_string_functions.of_replace_argument('FilterViewID', ls_parameters, ',', ls_null)

		io_navigation_detail_object.Dynamic of_get_reports(lu_search[])
			
		If UpperBound(lu_search[]) > 0 Then
			If Not IsNull(ll_dataobjectstateid) And ll_dataobjectstateid > 0 Then
				gn_globals.in_subscription_service.of_message('apply view id', String(ll_dataobjectstateid), lu_search[UpperBound(lu_search[])].Dynamic of_get_report_dw())
			End If
			
			If Not IsNull(ll_RprtCnfgNstdID) And ll_RprtCnfgNstdID > 0 Then
				lu_search[UpperBound(lu_search[])].Event Dynamic ue_notify('apply nested report', ll_RprtCnfgNstdID)
			End If
	
			If Not IsNull(ll_FilterViewID) And ll_FilterViewID > 0 Then
				lu_search[UpperBound(lu_search[])].Event Dynamic ue_notify('apply filter view', ll_FilterViewID)
			End If
		End If
		
		If Len(ls_parameters) > 0 And Not IsNull(ls_parameters) Then
			is_navigation_parameter = ls_parameters
		Else
			is_navigation_parameter = ''
		End If

		This.of_retrieve_detail_report()
		
		If UpperBound(lu_search[]) > 0 Then
			If Not IsNull(ll_pivottableid) And ll_pivottableid > 0 Then
				lu_search[UpperBound(lu_search[])].Dynamic Event ue_notify('pivot table view', String(ll_pivottableid))
			End If
		End If
		
	Case 'open in place', 'open in window'
		If Trim(is_ViewerObject) = '' Or IsNull(is_ViewerObject) Then Return
		
		ls_message	= 'Viewer=' + is_ViewerObject

		If Not IsNull(il_RprtDtbseID) 					And il_RprtDtbseID > 0 							Then ls_message	= ls_message + ',RprtDtbseID=' + String(il_RprtDtbseID )
		If Not Trim(is_AdapterObject) = '' 				And Not IsNull(is_AdapterObject) 			Then ls_message	= ls_message + ',Adapter=' + is_AdapterObject
		If Not Trim(is_GUIObject) = '' 					And Not IsNull(is_GUIObject) 					Then ls_message	= ls_message + ',GUIObject=' + is_GUIObject
		If Not Trim(is_GUIDataObject) = '' 				And Not IsNull(is_GUIDataObject) 			Then ls_message	= ls_message + ',GUIDataObject=' + is_GUIDataObject
		If Not Trim(is_DAOObject) = '' 					And Not IsNull(is_DAOObject) 					Then ls_message	= ls_message + ',DAO=' + is_DAOObject
		If Not Trim(is_DAODataObject) = '' 				And Not IsNull(is_DAODataObject) 			Then ls_message	= ls_message + ',DAODataObject=' + is_DAODataObject
		If Not Trim(is_EnttyNme) = '' 					And Not IsNull(is_EnttyNme) 					Then ls_message	= ls_message + ',Entity=' + is_EnttyNme
		If Not Trim(is_EnttyDsplyNme) = '' 				And Not IsNull(is_EnttyDsplyNme) 			Then ls_message	= ls_message + ',EntityDisplayName=' + is_EnttyDsplyNme
		If Not Trim(is_KeyControllerTable) = '' 		And Not IsNull(is_KeyControllerTable) 		Then ls_message	= ls_message + ',KeyControllerTable=' + is_KeyControllerTable
		If Not Trim(is_KeyControllerColumn) = '' 		And Not IsNull(is_KeyControllerColumn) 	Then ls_message	= ls_message + ',KeyControllerColumn=' + is_KeyControllerColumn
		If Not Trim(is_TemplateColumn) = '' 			And Not IsNull(is_TemplateColumn) 			Then ls_message	= ls_message + ',TemplateColumn=' + is_TemplateColumn
		If Not Trim(is_TemplateAbbreviation) = '' 	And Not IsNull(is_TemplateAbbreviation) 	Then ls_message	= ls_message + ',TemplateAbbreviation=' + is_TemplateAbbreviation
		If Not Trim(is_EntityIconSmall) = '' 			And Not IsNull(is_EntityIconSmall) 			Then ls_message	= ls_message + ',Bitmap=' + is_EntityIconSmall
		If Not Trim(is_EntityIconLarge) = '' 			And Not IsNull(is_EntityIconLarge) 			Then ls_message	= ls_message + ',BitmapLarge=' + is_EntityIconLarge

		ls_message	= ls_message + ',BestFitFirstObject=Y,CloseViewerWithAdapter=Y'

		Choose Case Lower(Trim(as_message))
			Case 'open in place'
				If Not IsValid(io_navigation_source_object) Or IsNull(io_navigation_source_object) Then Return
				
				//----------------------------------------------------------------------------------------------
				// #34615 - 8/25/2003 - Pat Newgent
				// Changed the boolean ib_report_detail_is_open from true to false to enable 
				// the detail report to change as the rowfocus changes
				//----------------------------------------------------------------------------------------------
				ib_report_detail_is_open = TRUE
			
				io_navigation_source_object.Dynamic Event ue_notify('Open Detail Object', ls_message)
				
				If Not IsValid(io_navigation_detail_object) Then Return
				
				This.of_retrieve_detail_report()
				
			Case 'open in window'
				ln_bag = Create n_bag
				ln_bag.of_set('parameters', ls_message + ',HideToolbar=Y')
				ln_bag.of_set('n_entity_drag_message', This.of_determine_selected_rows())
				
				ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
				ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_popup_reference', ln_bag)
				Destroy ln_nonvisual_window_opener

				Destroy ln_bag
		End Choose
   Case Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Pass everything else to the global navigation manager
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ib_IsDataCollection Then
			ln_bag = aany_argument
			in_bag.of_set(ln_bag)
			This.of_garbagecollect()
			If IsValid(gn_globals.of_get_object('n_navigation_manager')) Then
				gn_globals.of_get_object('n_navigation_manager').Dynamic Event ue_notify(as_message, in_bag)
			End If
			Return
		End If
		
		ls_argument 	= String(aany_argument)
		
		ls_action 					= gn_globals.in_string_functions.of_find_argument(Lower(ls_argument), ',', 'action')
		ls_parameters 				= gn_globals.in_string_functions.of_find_argument(Lower(ls_argument), ',', 'parameter')

		gn_globals.in_string_functions.of_replace_all(ls_parameters, '[equals]', '=')
		gn_globals.in_string_functions.of_replace_all(ls_parameters, '[comma]', ',')
		
		If Len(ls_parameters) > 0 And Not IsNull(ls_parameters) Then
			is_navigation_parameter = ls_parameters
			ls_parameters				= ',' + ls_parameters
		Else
			is_navigation_parameter = ''
			ls_parameters = ''
		End If
	
		Choose Case Lower(Trim(ls_action))
			Case 'search', 'reportnavigation'
				ls_reportconfigid	= gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'RprtCnfgID')
		
				If ls_reportconfigid = '?' Then
					ls_argument = 'EnttyID=' + String(il_EnttyID) + ',' + ls_argument

					ln_bag = Create n_bag
					ln_bag.of_set('Argument', ls_argument)
					
					ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
					ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_navigate_select_report', ln_bag)
					Destroy ln_nonvisual_window_opener

					ls_argument		= String(ln_bag.of_get('Argument'))
					ls_reportconfigid	= gn_globals.in_string_functions.of_find_argument(ls_argument, ',', 'RprtCnfgID')
					ls_parameters 	= String(ln_bag.of_get('Parameters'))

					Destroy ln_bag
					
					If ls_reportconfigid = '?' Then Return

					gn_globals.in_string_functions.of_replace_all(ls_parameters, '[equals]', '=')
					gn_globals.in_string_functions.of_replace_all(ls_parameters, '[comma]', ',')
					
					If Len(ls_parameters) > 0 And Not IsNull(ls_parameters) Then
						is_navigation_parameter = ls_parameters
						ls_parameters				= ',' + ls_parameters
					End If
				End If
		
				
				ls_destination_entity	= gn_globals.in_string_functions.of_find_argument(Lower(ls_argument), ',', 'entity')
				ll_reportconfigid			= Long(gn_globals.in_string_functions.of_find_argument(Lower(ls_argument), ',', 'RprtCnfgID'))

				//-----------------------------------------------------------------------------------------------------------------------------------
				//Find the OpenWindow string here & open that selection window
				//-----------------------------------------------------------------------------------------------------------------------------------
		
				if left(ls_parameters, 1) = ',' then ls_parameters = right(ls_parameters, len(ls_parameters)-1)

				If Pos(ls_argument, '[equals]') > 0 Then
					ls_argument = Replace(ls_argument, Pos(ls_argument, '[equals]'), Len('[equals]'), '=')
				End If

				ls_OpenWindowParam = gn_globals.in_string_functions.of_find_argument(ls_parameters, ',', 'openwindow')
				if ls_OpenWindowParam > '' or not(IsNull(ls_OpenWindowParam)) then
					ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
					ln_nonvisual_window_opener.Dynamic of_OpenWindow(ls_OpenWindowParam)
					Destroy ln_nonvisual_window_opener
					
					ls_parameters = Message.StringParm
					if ls_parameters = "" or IsNull(ls_parameters) then return
					ls_OpenWindowParam = 'OpenWindow=' + ls_OpenWindowParam
					ls_argument = Replace(ls_argument, Pos(ls_argument, ls_OpenWindowParam), Len(ls_OpenWindowParam), ls_parameters)
				end if
				
				//if left(ls_parameters, 1) <> ',' then ls_parameters = ',' + ls_parameters
				
				is_navigation_parameter = ls_parameters
				
				If Pos(Lower(ls_argument), 'data="') > 0 Then
					ls_data = Trim(Mid(ls_argument, Pos(Lower(ls_argument), 'data="') + 5))
					If Left(ls_data, 1) = '"' Then ls_data = Right(ls_data, Len(ls_data) - 1)
					If Right(ls_data, 1) = '"' Then ls_data = Left(ls_data, Len(ls_data) - 1)
				Else
					ls_data	= gn_globals.in_string_functions.of_find_argument(Lower(ls_argument), ',', 'data')
				End If

				
				ln_entity_drag_message = This.of_determine_selected_rows()
				If UpperBound(ln_entity_drag_message.is_key[]) = 0 Then
					If Pos(ls_data, '=') > 0 Then
						ln_entity_drag_message.of_add_item(ls_data)
					End If
				End If
		
				ln_entity_drag_message.of_set_destination_entity(ls_destination_entity)
				ln_entity_drag_message.of_set_action(ls_action)
				If Not IsNull(ll_reportconfigid) And ll_reportconfigid > 0 Then
					ln_entity_drag_message.of_set_destination_reportconfigid(ll_reportconfigid)
				End If
				Message.PowerObjectParm = ln_entity_drag_message
				If IsValid(gn_globals.of_get_object('n_navigation_manager')) Then
					gn_globals.of_get_object('n_navigation_manager').Dynamic Event ue_notify(as_message, ln_entity_drag_message)
				End If
			Case Else
				If UpperBound(il_selected_rows[]) > 1 Then
					ls_argument = Trim(ls_argument)
					
					If Lower(Right(ls_argument, 7)) = 'data=""' Then
						ls_argument = Left(ls_argument, Len(ls_argument) - 1)
					End If
					
					For ll_index = 1 To Min(UpperBound(il_selected_rows[]), UpperBound(is_navigationstringmultiple[]))
						ls_argument = ls_argument + is_navigationstringmultiple[ll_index] + '||'
					Next
					
					ls_argument = Left(ls_argument, Len(ls_argument) - 2)
					
					If Pos(Lower(ls_argument), 'data="') > 0 Then
						ls_argument = ls_argument + '"'
					End If
				End If

				If ib_recordhistory And UpperBound(il_selected_rows[]) = 1 Then
					This.of_get_shortcuts(ls_entity, ls_description, ls_navigation_message)
					This.of_addtohistory	(ls_entity, ls_description, ls_navigation_message)
				End If

				If IsValid(gn_globals.of_get_object('n_navigation_manager')) Then
					gn_globals.of_get_object('n_navigation_manager').Dynamic Event ue_notify(as_message, ls_argument)
				End If
		End Choose

//		entity=contract,source=contract,action=open,dlhdrid=12345

End Choose

This.of_garbagecollect()
end event

protected subroutine of_subscribe ();If ib_subscribed Then Return
ib_subscribed = True
gn_globals.in_subscription_service.of_subscribe(This, 'set report entity', io_datasource)
gn_globals.in_subscription_service.of_subscribe(This, 'filter', io_datasource)

end subroutine

public subroutine of_addtofavorites (string as_entity[], string as_description[], string as_navigationstring[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_addtofavorites()
//	Arguments:  as_entity[] - the array of entities
//					as_description[] - the description show on the listview items
//					as_navigationstring[] - the navigation string to the entity
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	11.1.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the arrays and add the entities
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(Min(UpperBound(as_entity[]), UpperBound(as_description[])), UpperBound(as_navigationstring[]))
	Insert	EntityFavorites
		(EnttyNme, UserID, NavigatorGroup, FavoritesText, NavigationMessage)
	Values	
		(:as_entity[ll_index], :gn_globals.il_userid, 'Favorites', :as_description[ll_index], :as_navigationstring[ll_index]);
Next
end subroutine

public subroutine of_addtohistory (string as_entity[], string as_description[], string as_navigationstring[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_addtohistory()
//	Arguments:  as_entity[] - the array of entities
//					as_description[] - the description show on the listview items
//					as_navigationstring[] - the navigation string to the entity
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	11.1.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_entityhistoryid
DateTime ldt_getdate
	
ldt_getdate = DateTime(Today(), Now())
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the arrays and add the entities
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(Min(UpperBound(as_entity[]), UpperBound(as_description[])), UpperBound(as_navigationstring[]))
	
	select 	entityhistoryid
	into 		:ll_entityhistoryid
	from 		entityhistory
	where 	EntityHistory.userid 				= :gn_globals.il_userid
	and 		EntityHistory.EnttyNme 				= :as_entity[ll_index]
	and 		EntityHistory.HistoryText 			= :as_description[ll_index] 
	and 		EntityHistory.NavigationMessage 	= :as_navigationstring[ll_index];
	
	If isnull(ll_entityhistoryid) or ll_entityhistoryid <> 0 then 
	
		Update  	EntityHistory
		set 		HistoryDateTime = :ldt_getdate
		where 	EntityHistory.userid 				= :gn_globals.il_userid
		and 		EntityHistory.EnttyNme 				= :as_entity[ll_index]
		and 		EntityHistory.HistoryText 			= :as_description[ll_index] 
		and 		EntityHistory.NavigationMessage 	= :as_navigationstring[ll_index];
	
	else 
	
		Insert	EntityHistory
			(EnttyNme, UserID, HistoryDateTime, HistoryText, NavigationMessage)
		Values	
			(:as_entity[ll_index], :gn_globals.il_userid, :ldt_getdate, :as_description[ll_index], :as_navigationstring[ll_index]);
	
	end if
	
Next
	
end subroutine

public subroutine of_clicked (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clicked()
//	Arguments:  xpos - the x position
//					ypos - the y position
//					row - The row
//					dwo - the datawindow object
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//This.of_rowfocuschanged(row)
end subroutine

public function string of_deleteentityshortcut (long al_shorcutid[], string as_shortcuttype[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_deleteentityshortcut()
//	Arguments:  al_shorcutid[]
//					as_shortcuttype[] - the type of shortcut.  We keep these in different tables
//	Overview:   This will delete entity shortcuts
//	Created by:	Blake Doerr
//	History: 	11.1.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
String ls_return = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the arrays and add the entities
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(al_shorcutid[]), UpperBound(as_shortcuttype[]))
	Choose Case Lower(Trim(as_shortcuttype[ll_index]))
		Case 'favorite'
			Delete	EntityFavorites
			Where		EntityFavoritesID		= :al_shorcutid[ll_index];
		Case 'history'
			Delete	EntityHistory
			Where		EntityHistoryID		= :al_shorcutid[ll_index];
	End Choose
	
	If SQLCA.SQLCode < 0 Then
		ls_return = SQLCA.SQLErrText
	End If
next

Return ls_return
end function

public function n_entity_drag_message of_determine_selected_rows ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_determine_selected_rows()
// Overrides:  No
// Overview:   This will put the values into a message object
// Created by: Blake Doerr
// History:    03/05/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_entity_drag_message ln_entity_drag_message

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_keyvalue
String	ls_navigation_retrieval_argument[]
String	ls_navigationstring
String	ls_entity
Long 		ll_row
Long		ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// If the datasource isn't valid or isn't a datawindow, just set the navigation string to be the instance variable
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(io_datasource) Then
	ls_navigation_retrieval_argument[1] = is_navigationstring
ElseIf io_datasource.TypeOf() <> Datawindow! Then
	ls_navigation_retrieval_argument[1] = is_navigationstring
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the first selected row
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_row = io_datasource.Dynamic of_getselectedrow(0)
	If ll_row = 0 Then ll_row = io_datasource.Dynamic GetRow()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop while there are rows selected
	//-----------------------------------------------------------------------------------------------------------------------------------
	Do While ll_row > 0 And Not IsNull(ll_row)
		ls_navigationstring = This.of_get_navigation_string(ll_row)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If this is dynamic entity selection get the information from the row, otherwise use of_get_navigation_string()
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ib_dynamic_entity_selection Then
			ls_entity				= String(in_data_mover.of_getitem(io_datasource, ll_row, is_entity_column))
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If the information isn't valid, continue
			//-----------------------------------------------------------------------------------------------------------------------------------
			If Len(ls_navigationstring) <= 0 Or IsNull(ls_navigationstring) Or Len(ls_entity) <= 0 Or IsNull(ls_entity) Then
				ls_navigationstring = ''
			Else
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Reinitialize the entity if this is the first one, otherwise continue if it isn't the same entity as the first row selected
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(ls_navigation_retrieval_argument[]) = 0 Then
					This.of_init(SQLCA, io_datasource, ls_entity)
				Else
					If Lower(Trim(ls_entity)) <> Lower(Trim(is_EnttyNme)) Then ls_navigationstring = ''
				End If
			End If
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add the retrieval argument
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ls_navigationstring <> '' Then
			ls_navigation_retrieval_argument[UpperBound(ls_navigation_retrieval_argument[]) + 1] = ls_navigationstring
		End If

		ll_row = io_datasource.Dynamic of_getselectedrow(ll_row)
	Loop
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the entity on the drag message
//-----------------------------------------------------------------------------------------------------------------------------------
ln_entity_drag_message.of_set_entity(is_EnttyNme)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through and add the navigation strings to the drag message
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_navigation_retrieval_argument)
	If Len(Trim(is_navigation_parameter)) > 0 Then
		ln_entity_drag_message.of_add_item(ls_navigation_retrieval_argument[ll_index] + ',' + is_navigation_parameter)
	Else
		ln_entity_drag_message.of_add_item(ls_navigation_retrieval_argument[ll_index])
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the navigation string when we are dynamic
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_dynamic_entity_selection Then 
	If UpperBound(ls_navigation_retrieval_argument[]) > 0 Then
		This.of_set_navigationstring(ls_navigation_retrieval_argument[1])
	Else
		This.of_set_navigationstring('')
		If IsValid(io_datasource) Then
			This.of_init(SQLCA, io_datasource)
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the entity drag message
//-----------------------------------------------------------------------------------------------------------------------------------
Return ln_entity_drag_message
end function

public function boolean of_dragdrop (ref powerobject source, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_dragdrop()
//	Arguments:  source - The source of the drag
//					row - the row the data was dropped on
//					dwo - The dwo the object was dropped on
//	Overview:   This will process the drag drop event and smart search if it can
//	Created by:	Blake Doerr
//	History: 	4/16/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean lb_ChangeEntityBack
Long ll_index, ll_multiple_record_session_id, ll_return
String ls_source_entity, ls_navigation_message = 'Multiple Records', ls_navigation_keys[], ls_syntax, ls_EntityToSetBack
n_entity_drag_message ln_entity_drag_message

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource isn't a datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(io_datasource) Then Return False
If io_datasource.TypeOf() <> Datawindow! Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the PowerObject isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(Message.PowerObjectParm) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the PowerObject is null
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(Message.PowerObjectParm) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the powerobject is not what we expected
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(ClassName(Message.PowerObjectParm))) <> 'n_entity_drag_message' Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the drag message from the message object
//-----------------------------------------------------------------------------------------------------------------------------------
ln_entity_drag_message = Message.PowerObjectParm

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the source entity from the drag message object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_source_entity = ln_entity_drag_message.of_get_entity()

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the entity is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_source_entity)) = 0 Or IsNull(ls_source_entity) Then
	ls_source_entity = is_EnttyNme
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the datawindow syntax has IsThisNavigation in it
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = Lower(io_datasource.Dynamic Describe("Datawindow.Syntax"))
//If Not Pos(ls_syntax, 'isthisnavigation') > 0 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the keys from the entity
//-----------------------------------------------------------------------------------------------------------------------------------
ln_entity_drag_message.of_get_keys(ls_navigation_keys[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Act differently based on the array of keys that come back
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case UpperBound(ls_navigation_keys[])
	Case 0
		io_datasource.Dynamic Reset()
		io_datasource.Dynamic Event RetrieveEnd(0)
		Return False
	Case 1
		SetNull(ll_multiple_record_session_id)
		ls_navigation_message = ls_navigation_keys[1]
	Case Else
		ll_multiple_record_session_id = This.of_insert_navigation_keys(ln_entity_drag_message)
		
		If IsNull(ll_multiple_record_session_id) Or ll_multiple_record_session_id <= 0 Then Return False
End Choose

//If is_OriginalEnttyNme <> is_EnttyNme Then
//	lb_ChangeEntityBack = True
//	ls_EntityToSetBack = is_EnttyNme
//	This.of_set_entity(is_OriginalEnttyNme)
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Navigate to the report based on information passed
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = of_navigate(ls_source_entity, 'search', ls_navigation_message, ll_multiple_record_session_id)

//If lb_ChangeEntityBack Then
//	This.of_set_entity(ls_EntityToSetBack)
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return true so other services know that action was taken and not ignored
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public subroutine of_dragleave (dragobject ao_source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_dragleave()
//	Created by:	Blake Doerr
//	History: 	10/5/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Message.PowerObjectParm = This.of_determine_selected_rows()

end subroutine

public subroutine of_exclude_action (string as_actionname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_exclude_action()
// Arguments:   as_actionname - the action name that you don't want to show because you are already there
// Overview:    This will eliminate an action from the menu.  If the deal is open don't show open deal of_exclude_action(open)
// Created by:  Blake Doerr
// History:     5/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_excluded_action[UpperBound(is_excluded_action) + 1] = as_actionname
end subroutine

public subroutine of_garbagecollect ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_garbagecollect()
//	Arguments:  None
//	Overview:   DocumentScriptFunctionality
//	Created by:	Kelly Stocksen
//	History: 	2/22/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
n_bag	ln_empty_bag[] 

For ll_index = 1 to UpperBound(in_superfluous_bag)
	If IsValid(in_superfluous_bag[ll_index]) Then
		Destroy in_superfluous_bag[ll_index]
	End If	
Next	

in_superfluous_bag[] = ln_empty_bag[]
end subroutine

public function boolean of_get_dragdrop ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_dragdrop()
//	Overview:   This will return the state of the dragdrop
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ib_dragdrop_is_enabled

end function

public function string of_get_entity ();Return is_EnttyNme
end function

public function string of_get_navigation_string (long al_row);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_get_navigation_string()
// Argument:	al_row - The row in idw to get the navigation string for
// Overview:   This will create a navigation string for the row in the datawindow in the form (Key1=value, Key2=Value, Etc...)
// Created by: Blake Doerr
// History:    6/25/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Variable Declarations
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_navigation_string, ls_columndata
String	ls_columntype
String	ls_source_column[]
String	ls_columnname
Long		ll_index
Long		ll_columncount
Datawindow ldw_datawindow
Datastore lds_datastore

If Not IsValid(io_datasource) Then Return ''

//----------------------------------------------------------------------------------------------------------------------------------
// Load local versions of promoted datatypes so we can do dot notation
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case io_datasource.TypeOf()
	Case Datawindow!
		ldw_datawindow = io_datasource
	Case Datastore!
		lds_datastore = io_datasource
	Case Else
		Return ''
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Get the navigation string when it's dynamic entity selection
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_dynamic_entity_selection Then
	Return String(in_data_mover.of_getitem(io_datasource, al_row, is_navigationstring_column))
End If

//----------------------------------------------------------------------------------------------------------------------------------
// If there aren't any entities in the datastores, return.
//-----------------------------------------------------------------------------------------------------------------------------------
if is_EnttyNme = '' Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set up variables
//-----------------------------------------------------------------------------------------------------------------------------------
ls_navigation_string = ''

if Trim(Lower(is_EnttyNme)) = 'dynamic' then
	If ib_DynamicEntityUsesAllAvailableColumns Then
		ll_columncount = Long(io_datasource.Dynamic Describe("Datawindow.Column.Count"))
		
		For ll_index = 1 To ll_columncount
			ls_columnname = String(io_datasource.Dynamic Describe("#" + String(ll_index) + '.Name'))
			ls_columntype = String(io_datasource.Dynamic Describe("#" + String(ll_index) + '.ColType'))
			
			Choose Case Lower(Trim(ls_columnname))
				Case 'selectrowindicator', 'rowfocusindicator', 'expanded', 'sortcolumn'
					Continue
			End Choose
			
			Choose Case Left(Lower(ls_columntype), 4)
				Case 'long'
				Case 'char'
					ls_columntype = Left(ls_columntype, Len(ls_columntype) - 1)
					ls_columntype = Mid(ls_columntype, 6)
					If IsNumber(ls_columntype) Then
						If Long(ls_columntype) < 10 Then
						Else
							Continue
						End If
					Else
						Continue
					End If
				Case Else
					Continue
			End Choose
		
			ls_source_column[UpperBound(ls_source_column[]) + 1] = ls_columnname
		Next
	Else
		ls_source_column[] = is_source_column[]
	End If
	
	for ll_index = 1 to upperbound( ls_source_column[])
		ls_columndata = string(in_data_mover.of_getitem(io_datasource, al_row, ls_source_column[ll_index]))
		if ls_columndata = '' OR isnull(ls_columndata) then
			ls_columndata = 'NULL'
		end if
		
		ls_navigation_string = ls_navigation_string + ls_source_column[ll_index] + '=' + ls_columndata + '^^^'
	Next
	if len(ls_navigation_string) > 0 then ls_navigation_string = left(ls_navigation_string, len(ls_navigation_string) - 3)
	return ls_navigation_string
end if

//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the key levels of this entity creating the entity message.  If we can't find a valid value for a key level, return ''
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(il_columnnumber[]), Min(UpperBound(is_columnnamelogical[]), UpperBound(is_columnnamephysical[])))

	//----------------------------------------------------------------------------------------------------------------------------------
	// 
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case io_datasource.TypeOf()
		Case Datawindow!
			ls_columndata = string(ldw_datawindow.object.data[al_row, il_columnnumber[ll_index]])
		Case Datastore!
			ls_columndata = string(lds_datastore.object.data[al_row, il_columnnumber[ll_index]])
	End Choose

	//----------------------------------------------------------------------------------------------------------------------------------
	// Error conditions.  If we got a null value and it is the last chance to get the value for this key level, error out.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ls_columndata = '' Or IsNull(ls_columndata) Then Return ''

	ls_navigation_string = ls_navigation_string + is_columnnamelogical[ll_index] + '='
	ls_navigation_string	= ls_navigation_string + ls_columndata + ','
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Chop off the extra comma and return the navigation string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_navigation_string = Left(ls_navigation_string, Len(ls_navigation_string) - 1)

Return ls_navigation_string
end function

private subroutine of_get_shortcuts (ref string as_entity[], ref string as_description[], ref string as_navigationstring[]);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions 
String ls_return, ls_object
String	ls_expressionelements[]
Long ll_index, ll_index2, ll_return,l_row
Any lany_return


//----------------------------------------------------------------------------------------------------------------------------------
// Load local versions of promoted datatypes so we can do dot notation
//-----------------------------------------------------------------------------------------------------------------------------------
//Choose Case io_datasource.TypeOf()
//	Case Datawindow!
//		ldw_datawindow = io_datasource
//	Case Datastore!
//		lds_datastore = io_datasource
//	Case Else
//		Return ''
//End Choose

If UpperBound(il_selected_rows[]) > 0 Then
	If IsValid(io_datasource) Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make sure that we have the navigation strings that we need
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(il_selected_rows[]) > 1 Then
			If UpperBound(is_navigationstringmultiple[]) = 0 Then
				For ll_index = 1 To UpperBound(il_selected_rows)
					is_navigationstringmultiple[ll_index] = This.of_get_navigation_string(il_selected_rows[ll_index])
				Next
				is_navigationstring = ''
			End If
		Else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// There is just one row selected.  We need to get the navigation string for the one row.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If Trim(is_navigationstring) = '' Or IsNull(is_navigationstring) Then
				If UpperBound(il_selected_rows[]) > 1 Then
					l_row = il_selected_rows[1]
				Else
					//Try to find out what row is this menu related to.
					If io_datasource.TypeOf() = Datawindow! Then
						ls_object = io_datasource.Dynamic getobjectatpointer()
						if ls_object > '' then
							l_row = long( mid( ls_object, pos( ls_object, "~t") + 1))
						else
							l_row = io_datasource.Dynamic getrow()
						end if
					Else
						l_row = 1
					End If
				End If
				
				is_navigationstring = This.of_get_navigation_string(l_row)
			Else
			End If
		End If
		
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through all the rows that are selected and put into an array
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To UpperBound(il_selected_rows)
			If ll_index = 1 And UpperBound(is_navigationstringmultiple) < 1 Then
				ls_return 								= is_navigationstring
			Else
				ls_return 								= is_navigationstringmultiple[ll_index]						
			End If
			
			as_entity[ll_index]					= is_EnttyNme
			as_navigationstring[ll_index] 	= ls_return
			as_description[ll_index]			= ''

			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Get the Description based on the expression that is stored in the entity table
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsValid(io_datasource) Then
				gn_globals.in_string_functions.of_parse_string(is_EnttyDscrptnExprssn, '+', ls_expressionelements[])
				For ll_index2 = 1 To UpperBound(ls_expressionelements[])
					ls_expressionelements[ll_index2] = Trim(ls_expressionelements[ll_index2])
					//-----------------------------------------------------------------------------------------------------------------------------------
					// If it is a column, get the column
					//-----------------------------------------------------------------------------------------------------------------------------------
					If Left(Lower(ls_expressionelements[ll_index2]), 9) = 'getcolumn' Then
						ls_expressionelements[ll_index2] = Lower(ls_expressionelements[ll_index2])
						gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], 'getcolumn', 	'')
						gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], '(', 					'')
						gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], ')', 					'')
						gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], "'", 					'')
						ls_expressionelements[ll_index2] = Trim(ls_expressionelements[ll_index2])								

						lany_return = This.of_getitem(io_datasource, il_selected_rows[ll_index], ls_expressionelements[ll_index2])
						If Not IsNull(lany_return) Then
							If Trim(String(lany_return)) <> '' Then
								as_description[ll_index] = as_description[ll_index] + String(lany_return)
							End If
						End If
					//-----------------------------------------------------------------------------------------------------------------------------------
					// If it is a LookupDisplay, Evaluate it.
					//-----------------------------------------------------------------------------------------------------------------------------------
					ElseIf 	Left(Lower(ls_expressionelements[ll_index2]), 13) = 'lookupdisplay' Then
								ls_expressionelements[ll_index2] = Lower(ls_expressionelements[ll_index2])
								gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], 'lookupdisplay', 	'')
								gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], '(', 					'')
								gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], ')', 					'')
								gn_globals.in_string_functions.of_replace_all(ls_expressionelements[ll_index2], "'", 					'')
								ls_expressionelements[ll_index2] = Trim(ls_expressionelements[ll_index2])								
								ls_return = "Evaluate('LookupDisplay(" + ls_expressionelements[ll_index2] + ")', " + String(il_selected_rows[ll_index]) + ")"
								ls_return = io_datasource.Dynamic Describe(ls_return)
								If Not IsNull(ls_return) And ls_return <> '!' And ls_return <> '?' And Trim(ls_return) <> '' Then
									as_description[ll_index] = as_description[ll_index] + String(ls_return)
								End If								
					Else
						//-----------------------------------------------------------------------------------------------------------------------------------
						// If it isn't a lookupdisplay or a column, add the text to the string
						//-----------------------------------------------------------------------------------------------------------------------------------
						ls_expressionelements[ll_index2] 	= Left(ls_expressionelements[ll_index2], Len(ls_expressionelements[ll_index2]) - 1)
						ls_expressionelements[ll_index2] 	= Right(ls_expressionelements[ll_index2], Len(ls_expressionelements[ll_index2]) - 1)
						as_description[ll_index] 				= as_description[ll_index] + ls_expressionelements[ll_index2]
					End If
				Next

				//-----------------------------------------------------------------------------------------------------------------------------------
				// If there isn't a valid expression, just use the navigation string
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(ls_expressionelements) = 0 Then as_description[ll_index] = ls_return
				
				If UpperBound(ls_expressionelements) = 1 Then
					If Trim(ls_expressionelements[1]) = '' Then as_description[ll_index]			= ls_return
				End If
				
			Else
				as_description[ll_index]			= ls_return
			End If
			
			as_description[ll_index] = is_EnttyDsplyNme + ': ' + as_description[ll_index]
		Next
		

	End If
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the current entity to the array (it does not have to be a datawindow row)
	//-----------------------------------------------------------------------------------------------------------------------------------
	as_entity[1]					= is_EnttyNme
	as_navigationstring[1] 		= is_navigationstring
	as_description[1]				= is_EnttyDsplyNme + ': '
	
	If IsNull(is_entitydescription) Or is_entitydescription = '' Then
		as_description[1]				= as_description[1] + is_navigationstring
	Else
		as_description[1]				= as_description[1] + is_entitydescription
	End If	
End If

end subroutine

public function any of_getitem (powerobject adw_data, long al_row, string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_column_value()
// Arguments:   as_colname - the column name in the datastore that you care about
//					 al_itemhandle - the handle of the listview item you care about
// Overview:    DocumentScriptFunctionality
// Created by:  Blake Doerr
// History:     5/18/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string s_find, s_describe, s_coltype, s_colval
long l_row
any  a_colval

//----------------------------------------------------------------------------------------------------------------------------------
// Find the row in the datawindow that corresponds to the handle passed in and get the column value based on the datatype
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(a_colval)
as_columnname = Trim(Lower(as_columnname))
s_coltype = adw_data.Dynamic Describe(as_columnname + ".ColType")

If IsNumber(adw_data.Dynamic Describe(as_columnname + '.ID')) Then
	Choose Case Trim(lower(s_coltype))
		Case 'datetime'
			a_colval = adw_data.Dynamic GetItemDateTime(al_row, as_columnname)
			
		Case 'number', 'long'
			a_colval = adw_data.Dynamic GetItemNumber(al_row, as_columnname)
			
		Case Else
			Choose Case Left(s_coltype,4)
				Case 'char'
					a_colval = adw_data.Dynamic GetItemString(al_row, as_columnname)
					
				Case 'date'
					a_colval = adw_data.Dynamic GetItemDate(al_row, as_columnname)
					
				Case 'deci'
					a_colval = adw_data.Dynamic GetItemDecimal(al_row, as_columnname)
					
				Case 'time'
					a_colval = adw_data.Dynamic GetItemTime(al_row, as_columnname)
			End Choose
	End Choose
End If

Return a_colval
end function

public subroutine of_include_action (string as_actionname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	 of_include_action()
// Arguments:   as_actionname - the action name that you want to show that had previously been excluded
// Overview:    This will add the action back to the menu.
// Created by:  Pat Newgent
// History:     10/27/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long i

For i = 1 to UpperBound(is_excluded_action)
	if is_excluded_action[i] = as_actionname then is_excluded_action[i] = ''
Next
	
end subroutine

public subroutine of_interrogate_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_interrogate_datawindow()
//	Overview:   This will pull initialization parameters out of the datawindow itself.
//	Created by:	Blake Doerr
//	History: 	12.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_initialization_column_name = 'navigationinit', ls_init_string, ls_return
String ls_empty[]
String ls_arguments[], ls_values[], ls_expression, ls_originalentity
Long	ll_index, ll_column_number
String	ls_entity
Boolean lb_NavigationInitOverridesEntity
n_datawindow_tools 	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Initialize these variables
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(is_entity_column)
SetNull(is_navigationstring)
ib_dynamic_entity_selection = False

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the expression from the navigationinit computed field
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(io_datasource, 'navigationinit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the expression is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ls_expression) Then 
	//----------------------------------------------------------------------------------------------------------------------------------
	// Use the string functions object to parse the string into an array
	//-----------------------------------------------------------------------------------------------------------------------------------
	//n_string_functions ln_string_functions
	gn_globals.in_string_functions.of_parse_arguments(ls_expression, '||', ls_arguments[], ls_values[])
		
	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all elements of the array.  Get the two items we care about.
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To Min(UpperBound(ls_arguments), UpperBound(ls_values))
		Choose Case Lower(Trim(ls_arguments[ll_index]))
			Case 'entitycolumn'
				ll_column_number = ln_datawindow_tools.of_get_columnid(io_datasource, ls_values[ll_index])
				If  ll_column_number > 0 Then				
					is_entity_column = ls_values[ll_index]
				End If
			
			Case 'navigationstringcolumn'
				ll_column_number = ln_datawindow_tools.of_get_columnid(io_datasource, ls_values[ll_index])
				If  ll_column_number > 0 Then				
					is_navigationstring_column = ls_values[ll_index]
				End If
				
			Case 'entity'
				ls_entity = ls_values[ll_index]
				
			Case 'originalentity'
				ls_originalentity = ls_values[ll_index]				
				
			Case 'overrideentity'
				lb_NavigationInitOverridesEntity = Upper(Trim(Left(ls_values[ll_index], 1))) = 'Y'
				
			case 'sourcecolumns'
				is_source_column[] = ls_empty[]
				
				If Lower(Trim(ls_values[ll_index])) = 'all' Then
					ib_DynamicEntityUsesAllAvailableColumns = True
				Else
					ib_DynamicEntityUsesAllAvailableColumns = False
					gn_globals.in_string_functions.of_parse_string( ls_values[ll_index], ',', is_source_column[])
				End If
			case 'actions'
//				gn_globals.in_string_functions.of_parse_string( ls_values[ll_index], ',', is_dynamic_action[])
				
		End Choose
	Next
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine if we are setting the entity dynamically based on the row
	//-----------------------------------------------------------------------------------------------------------------------------------
	ib_dynamic_entity_selection = Not IsNull(is_entity_column) And Not IsNull(is_navigationstring_column)
	if NOT ib_dynamic_entity_selection Then
		If Not IsNull(ls_originalentity) Then
			this.of_init( SQLCA, this.io_datasource, ls_originalentity)
		End If
		
		this.of_init( SQLCA, this.io_datasource, ls_entity)
		
		ib_NavigationInitOverridesEntity = lb_NavigationInitOverridesEntity
	end if
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datawindow tools
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
end subroutine

public function boolean of_load_columns (powerobject a_dw);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_load_columns()
// Arguments:   a_dw - the datawindow to interrogate
// Overview:    DocumentScriptFunctionality
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long		li_columns, li_i
String 	ls_columnname

is_physical_columns = ','

li_columns = Long(a_dw.Dynamic describe("datawindow.column.count"))

//Loop through the columns and get the dbname into an array
for li_i = 1 to li_columns
	ls_columnname = lower(a_dw.Dynamic describe("#" + string(li_i) + ".dbname"))
	IF Pos(ls_columnname, '.') > 0 Then
		ls_columnname = Mid(ls_columnname, Pos(ls_columnname, '.') + 1)
	End If
	is_physical_columns = is_physical_columns + ls_columnname + ','
next

Return True
end function

public subroutine of_mail_enabled (boolean ab_mailenabled);ib_mailenabled = ab_mailenabled
end subroutine

public function long of_navigate (any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_navigate()
// Overrides:  No
// Overview:   This will nonvisually navigate from one entity to another
// Created by: Blake Doerr
// History:    1/31/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_execute_sql
String	ls_source
String	ls_entity
String	ls_action
String	ls_key[]
String	ls_drop_table
Long 		ll_return
Long		ll_multiplerowsessionid
Transaction	lxtn_transaction

If IsValid(io_datasource) Then
	lxtn_transaction = io_datasource.Dynamic GetTransObject()
Else
	lxtn_transaction = ixctn_transaction
End If

If Not IsValid(lxtn_transaction) Then lxtn_transaction = SQLCA

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_entity_drag_message ln_entity_drag_message
n_bag	ln_bag

//----------------------------------------------------------------------------------------------------------------------------------
// Set this variable to null.  It is the error return value
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_return)

//----------------------------------------------------------------------------------------------------------------------------------
// Get the drag message object in the ways that we know how
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ClassName(aany_argument)
	Case	'n_bag'
		ln_bag = aany_argument
		ln_entity_drag_message = ln_bag.of_get('Navigation Message')
	Case 	'n_entity_drag_message'
		ln_entity_drag_message = aany_argument
	Case Else
		Return ll_return
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Get the keys from the message object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_action 		= ln_entity_drag_message.of_get_action()
ls_source 		= ln_entity_drag_message.of_get_entity()
ls_entity		= ln_entity_drag_message.of_get_destination_entity()
					  ln_entity_drag_message.of_get_keys(ls_key[])

//----------------------------------------------------------------------------------------------------------------------------------
// Set the entity if it hasn't been set already
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_entity)) > 0 And Lower(Trim(ls_entity)) <> Lower(Trim(is_EnttyNme)) Then
	This.of_set_entity(ls_entity)
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Make sure that all these variables are valid before we continue
//-----------------------------------------------------------------------------------------------------------------------------------
If Trim(is_OriginalEnttyNme) = '' Or IsNull(is_OriginalEnttyNme) Then Return ll_return
If Trim(is_EnttyNvgtnStrdPrcdre) = '' Or IsNull(is_EnttyNvgtnStrdPrcdre) Then Return ll_return
If Trim(ls_action) = '' Or IsNull(ls_action) Then Return ll_return
If Trim(ls_source) = '' Or IsNull(ls_source) Then Return ll_return

//----------------------------------------------------------------------------------------------------------------------------------
// Create the sql depending on what the number of keys is
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case UpperBound(ls_key[])
	Case Is < 1
		Return ll_return
	Case 1
		ls_execute_sql = "Exec "  + is_EnttyNvgtnStrdPrcdre + " '" + ls_source + "' , '" + ls_key[1] + "'," + "'" + ls_action + "'"
	Case Else
		ll_multiplerowsessionid = This.of_insert_navigation_keys(ln_entity_drag_message)
		
		If IsNull(ll_multiplerowsessionid) Or ll_multiplerowsessionid <= 0 Then Return ll_return
		
		ls_execute_sql = "Exec "  + is_EnttyNvgtnStrdPrcdre + " '" + ls_source + "' , 'Multiple'," + "'" + ls_action + "', " + String(ll_multiplerowsessionid)
End Choose

ls_drop_table = 'Drop Table #' + ls_entity

//----------------------------------------------------------------------------------------------------------------------------------
// Execute the store procedure to populate the navigation data
//-----------------------------------------------------------------------------------------------------------------------------------
Execute Immediate :ls_drop_table				Using lxtn_transaction;
Execute Immediate :is_NavigationTempTable Using lxtn_transaction;
Execute Immediate :ls_execute_sql			Using lxtn_transaction;

is_from_entity							= ls_source
is_action								= ls_action
If UpperBound(ls_key[]) > 0 And (ll_multiplerowsessionid <= 0 Or IsNull(ll_multiplerowsessionid)) Then
	is_navigation_retrieval_argument = ls_key[1]
Else
	is_navigation_retrieval_argument = ''
End If
il_multiplerowsessionid				= ll_multiplerowsessionid

ib_IsNavigationDestination = True

//----------------------------------------------------------------------------------------------------------------------------------
// Return the number of keys translated
//-----------------------------------------------------------------------------------------------------------------------------------
Return UpperBound(ls_key[])
end function

public function long of_navigate (string as_from_entity, string as_action, string as_navigation_retrieval_argument, long al_multiplerowsessionid);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_navigate()
// Overrides:  No
// Overview:   This will manage the navigation from one entity to another when it comes from another window
//					It will tell the datawindow to retrieve differently than normal because it is being navigated to
// Created by: Blake Doerr
// History:    4/17/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_multiplerowsargument, ls_drop_table
Long ll_return
//n_persistent_temporary_table ln_persistent_temporary_table
Transaction	lxtn_transaction

If IsValid(io_datasource) Then
	lxtn_transaction = io_datasource.Dynamic GetTransObject()
Else
	lxtn_transaction = ixctn_transaction
End If

If Not IsValid(lxtn_transaction) Then lxtn_transaction = SQLCA

//----------------------------------------------------------------------------------------------------------------------------------
// Set this variable to null.  It is the error return value
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_return)

is_from_entity							= as_from_entity
is_action								= as_action
is_navigation_retrieval_argument	= as_navigation_retrieval_argument
il_multiplerowsessionid				= al_multiplerowsessionid

//----------------------------------------------------------------------------------------------------------------------------------
// Make sure that all these variables are valid before we continue
//-----------------------------------------------------------------------------------------------------------------------------------
If Trim(as_navigation_retrieval_argument) = '' Or IsNull(as_navigation_retrieval_argument) Then Return ll_return
If Trim(as_action) = '' Or IsNull(as_action) Then Return ll_return
If Trim(as_from_entity) = '' Or IsNull(as_from_entity) Then Return ll_return
If Trim(is_OriginalEnttyNme) = '' Or IsNull(is_OriginalEnttyNme) Then Return ll_return
If Trim(is_EnttyNvgtnStrdPrcdre) = '' Or IsNull(is_EnttyNvgtnStrdPrcdre) Then Return ll_return

//----------------------------------------------------------------------------------------------------------------------------------
// Tell the Persistent Temporary Table object what transaction object to use.  It should be the same as the destination entity*******needs to do gettransobject
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_persistent_temporary_table.of_settransobject(lxtn_transaction)

//----------------------------------------------------------------------------------------------------------------------------------
// Drop the table in case it's already there
//-----------------------------------------------------------------------------------------------------------------------------------
ls_drop_table = 'Drop Table #' + is_OriginalEnttyNme
Execute Immediate :ls_drop_table Using lxtn_transaction;

//----------------------------------------------------------------------------------------------------------------------------------
// Create the temp table based on the entity name
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_persistent_temporary_table.of_create_table(is_NavigationTempTable)

//----------------------------------------------------------------------------------------------------------------------------------
// If there is a multiple row session id, add it to the execution of the stored procedure
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(al_multiplerowsessionid) And al_multiplerowsessionid > 0 Then
	ls_multiplerowsargument = ', ' + String(al_multiplerowsessionid)
Else
	ls_multiplerowsargument = ''
End IF

//----------------------------------------------------------------------------------------------------------------------------------
// Execute the store procedure to populate the navigation data
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_persistent_temporary_table.of_execute("Exec "  + is_EnttyNvgtnStrdPrcdre + " '" + as_from_entity + "' , '" + as_navigation_retrieval_argument + "'," + "'" + as_action + "'" + ls_multiplerowsargument)

//----------------------------------------------------------------------------------------------------------------------------------
// This will cause the datawindow to retrieve with no parameters except to be navigated to
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = This.of_retrieve_navigated()

//ln_persistent_temporary_table.of_drop_table()

ib_IsNavigationDestination = True


Return ll_return
end function

public subroutine of_pbm_mousemove (unsignedlong flags, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_pbm_mousemove()
//	Created by:	Blake Doerr
//	History: 	10/5/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_object

//-----------------------------------------------------------------------------------------------------------------------------------
// If drag drop is turned on, if the row is greater than zero, begin drag
//-----------------------------------------------------------------------------------------------------------------------------------
If Not flags = 1 Then Return
If Not IsValid(io_datasource) Then Return
If Not io_datasource.TypeOf() = Datawindow! Then Return

ls_object = io_datasource.Dynamic GetObjectAtPointer()

If Long(Right(ls_object, Len(ls_object) - Pos(ls_object, '~t'))) <= 0 Or Left(io_datasource.Dynamic GetBandAtPointer(), 6) <> 'detail' Then Return
If Not This.of_get_dragdrop() Then Return

io_datasource.Dynamic drag(begin!)



end subroutine

public subroutine of_rbuttondown (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rbuttondown()
//	Arguments:  xpos - the x position
//					ypos - the y position
//					row - the row number
//					dwo - the datawindow object
//	Overview:   This will change the entity dynamically if necessary
//	Created by:	Blake Doerr
//	History: 	2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_navigationstring, ls_entity

If Not IsValid(io_datasource) Then Return
If io_datasource.TypeOf() <> Datawindow! Then Return
If row <= 0 Or IsNull(row) Or Row > io_datasource.Dynamic RowCount() Then Return

This.of_rowfocuschanged(row)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are setting the entity dynamically during right click, do it.
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_dynamic_entity_selection Then This.of_determine_selected_rows()

end subroutine

public function long of_renavigate ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_renavigate()
// Overrides:  No
// Created by: Blake Doerr
// History:    4/17/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_navigate(is_from_entity, is_action, is_navigation_retrieval_argument, il_multiplerowsessionid)

end function

public subroutine of_retrieveend (long rowcount);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rowfocuschanged()
//	Arguments:  xpos - the x position
//					ypos - the y position
//					row - The row
//					dwo - the datawindow object
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	9/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the current row to zero and then call the rowfocuschanged function
//-----------------------------------------------------------------------------------------------------------------------------------
il_current_row = 0
This.of_rowfocuschanged(io_datasource.Dynamic GetRow())

//-----------------------------------------------------------------------------------------------------------------------------------
// If no rows come back retrieve the detail report
//-----------------------------------------------------------------------------------------------------------------------------------
If rowcount = 0 Then
	If ib_report_detail_is_open Then
		This.of_retrieve_detail_report()
	End If
End If
end subroutine

public function long of_retrievestart ();Long		ll_null
String	ls_return
If ib_IsNavigationDestination Then
	ls_return	= String(io_datasource.Event Dynamic ue_arewereretrieving())
	If Lower(Trim(ls_return)) = 'yes' Then
		This.Post of_renavigate()
		Return 1
	End If
End If

SetNull(ll_null)
Return ll_null
end function

public function long of_rowfocuschanging (long currentrow, long newrow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rowfocuschanging()
//	Arguments:  currentrow 	- The current row
//					newrow		- The new row
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	9/19/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(io_navigation_detail_object) Then
	Return io_navigation_detail_object.Dynamic Event ue_close()
End If

Return 0
end function

public subroutine of_set_allow_detail_reports (powerobject ao_navigation_source_object, boolean ab_allowopeningofdetailreports);ib_AllowOpeningOfDetailReports 	= ab_AllowOpeningOfDetailReports
io_navigation_source_object		= ao_navigation_source_object
end subroutine

public subroutine of_set_detail_report (powerobject ao_navigation_detail_object);io_navigation_detail_object = ao_navigation_detail_object
end subroutine

public subroutine of_set_dragdrop (boolean ab_dragdrop);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_dragdrop()
//	Arguments:  ab_dragdrop - the state of dragdrop
//	Overview:   This will store the state of the dragdrop
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_dragdrop_is_enabled = ab_dragdrop

end subroutine

public subroutine of_set_menutarget (powerobject apo_menutarget);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_menutarget()
//	Arguments:  apo_menutarget - This is the object that the menu is popped on
//	Overview:   This is only necessary when you are navigating from a nonvisual dataobject (datastore)
//	Created by:	Blake Doerr
//	History: 	5/30/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ipo_menutarget = apo_menutarget
end subroutine

public subroutine of_set_navigation_text (string as_navigationtext);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_set_navigation_text()
// Argument:	as_navigationtext - The text for the navigation entity
// Overview:   Store the navigation text
// Created by: Blake Doerr
// History:    10/31/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_entitydescription = as_navigationtext
end subroutine

public subroutine of_set_navigationstring (string as_navigationstring, string as_entitydescription);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_set_navigation_string()
// Overview:   This will set the string used for navigation (e.g.: dlhdrid=200, dldtlid=9000)
// Created by: Blake Doerr
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_navigationstring 		= as_navigationstring
is_entitydescription 	= as_entitydescription
end subroutine

public subroutine of_setselecteddata (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setselecteddata()
//	Arguments:  n_bag
//	Overview:   DocumentScriptFunctionality
//	Created by:	Kelly Stocksen
//	History: 	2/14/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the bag into the instance variable and set the datacollection variable to TRUE
//-----------------------------------------------------------------------------------------------------------------------------------
ib_IsDataCollection = TRUE
in_bag = an_bag
end subroutine

public subroutine of_setselectedrows (long al_rows[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_setselectedrows()
//	Arguments:  al_rows[] - The array of selected rows
//	Overview:   Pass in the array of selected rows - Currently only used for sending 
//	Created by:	Blake Doerr
//	History: 	9.5.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_emptylongarray[]
String ls_empty_array[]
il_selected_rows[] 				= al_rows[]
is_navigationstringmultiple[] = ls_empty_array[]
is_navigationstring 				= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty out the long arrays
//-----------------------------------------------------------------------------------------------------------------------------------
il_key1 = ll_emptylongarray[]
il_key2 = ll_emptylongarray[]
il_key3 = ll_emptylongarray[]
il_key4 = ll_emptylongarray[]
il_key5 = ll_emptylongarray[]
end subroutine

public subroutine of_retrieve_detail_report ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_retrieve_detail_report()
// Overrides:  No
// Overview:   Pass the selected rows to the detail datawindow
// Created by: Blake Doerr
// History:    03/05/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

PowerObject lo_dragsource
n_entity_drag_message ln_entity_drag_message

If Not IsValid(io_navigation_detail_object) Then Return

If IsValid(io_navigation_source_object) Then 
	lo_dragsource = io_navigation_source_object
Else
	lo_dragsource = io_navigation_detail_object
End If

ln_entity_drag_message = This.of_determine_selected_rows()

Message.PowerObjectParm = ln_entity_drag_message
io_navigation_detail_object.Event Dynamic DragDrop(lo_dragsource)
end subroutine

public function long of_retrieve_navigated ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_retrieve_navigated()
// Overrides:  No
// Overview:   This will retrieve no matter how many retrieval arguments there are.
// Created by: Blake Doerr
// History:    6/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_return

n_datawindow_tools ln_datawindow_tools
ln_datawindow_tools = Create n_datawindow_tools
ll_return = Long(ln_datawindow_tools.of_retrieve(io_datasource, 'Y', '||'))
Destroy ln_datawindow_tools

Return ll_return
end function

public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu
//	Arguments:  None
//	Overview:   This function builds the navigation menu based on the entity and entityactions defined in the database.
//	Created by:	Blake Doerr
//	History: 	6/17/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_build_menu(an_menu_dynamic, '', False, False)
end subroutine

public subroutine of_set_navigationstring (string as_navigationstring);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_set_navigation_string()
// Overview:   This will set the string used for navigation (e.g.: dlhdrid=200, dldtlid=9000)
// Created by: Blake Doerr
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_set_navigationstring(as_navigationstring, as_navigationstring)

end subroutine

public function boolean of_build_navigation_strings ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_navigation_strings
//	Arguments:  None
//	Overview:   This function calls of_get_navigation string to build one or more navigation strings
//					based on the selected rows in the datawindow.
//	Created by:	Scott Creed
//	History: 	8/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long		l_row
long		ll_index
long		ll_empty_array[]

string	ls_empty[]
string	ls_object

If Not IsValid(io_datasource) Then Return Len(Trim(is_navigationstring)) > 0

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is more than one selected row, loop through them an build an array of
// navigation strings.
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(il_selected_rows[]) > 1 Then
	For ll_index = 1 To UpperBound(il_selected_rows)
		is_navigationstringmultiple[ll_index] = This.of_get_navigation_string(il_selected_rows[ll_index])
	Next
	is_navigationstring = ''
	RETURN TRUE
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Otherwise, if the datasource is not a datawindow, return
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case io_datasource.TypeOf()
	Case Datawindow!
		ls_object = io_datasource.Dynamic getobjectatpointer()
		
		if ls_object > '' then
			l_row = long( mid( ls_object, pos( ls_object, "~t") + 1))
		else
			l_row = io_datasource.Dynamic getrow()
		end if
	Case Datastore!
		l_row = io_datasource.Dynamic getrow()
	Case Else
		Return False
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the navigation string for the row
//-----------------------------------------------------------------------------------------------------------------------------------
If io_datasource.Dynamic RowCount() = 0 Then
	is_navigationstring = ''
Else
	If l_row > 0 And Not IsNull(l_row) And l_row <= io_datasource.Dynamic RowCount() Then
		is_navigationstring = This.of_get_navigation_string(l_row)
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the navigation string is empty, return
	//-----------------------------------------------------------------------------------------------------------------------------------
	If is_navigationstring = '' Then
		SetNull(is_navigationstring)
		RETURN FALSE
	End If
End If

Return True
end function

public function boolean of_init (powerobject adw);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_init()
// Arguments:   adw - The datasource for which to initialize the navigation options service
// Overview:    This function sets up the navigation options based on the NavigationInit found in the
//						datawindow.  If no such initialization computed field exists, this function returns
//						without error, but must be initialized in another way.
// Created by:  Scott Creed
// History:     8/24/00
//-----------------------------------------------------------------------------------------------------------------------------------

if not isvalid(adw) then RETURN FALSE

this.io_datasource = adw

//-----------------------------------------------------------------------------------------------------------------------------------
// This will load the entities and determine if we should dynamically change the entity based on the row
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_subscribe()
This.of_interrogate_datawindow()

return TRUE
end function

public function boolean of_init (ref transaction at_transaction, powerobject apo_source);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_init()
// Arguments:   at_transaction - The transaction object to use
//					 apo_source - the source for the navigation.  If it is a datawindow we can interrogate it to see what entities exist.
// Overview:    This will set the transaction object and the source for navigation.  It will also load the entities
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Initialize this with an empty string
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_init(at_transaction, apo_source, '')

//-----------------------------------------------------------------------------------------------------------------------------------
// This will load the entities and determine if we should dynamically change the entity based on the row
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_interrogate_datawindow()

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
return TRUE
end function

public function boolean of_init (ref transaction at_transaction, powerobject apo_source, string as_entity);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_init()
// Arguments:   at_transaction - The transaction object to use
//					 apo_source - the source for the navigation.  If it is a datawindow we can interrogate it to see what entities exist.
//					 as_entity - The entity.  You can specify this if you don't want this service to determine what entities exist
// Overview:    This will set the transaction object and the source for navigation.  It will also load the entities.
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

PowerObject lpo_menutarget_previous

it_transaction 			= at_transaction
lpo_menutarget_previous = ipo_menutarget
ipo_menutarget 			= apo_source

This.of_subscribe()

If is_EnttyNme <> '' And ib_NavigationInitOverridesEntity Then Return True

If Trim(as_entity) > '' And Not IsNull(as_entity) Then This.of_set_entity(as_entity)

If lpo_menutarget_previous <> ipo_menutarget Then
	If IsNull(is_navigationstring) Or Trim(is_navigationstring) = '' Then
		choose case apo_source.typeof()
			case datawindow!, datastore!
				io_datasource = apo_source
				this.of_load_columns(io_datasource)
			case else
		end choose
	End If
End If

this.of_load_entities()

Window lw_window
PowerObject lpo_temp
//----------------------------------------------------------------------------------------------------------------------------------
// Loop until we find the window that it's on
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ipo_menutarget.TypeOf()
	Case Datawindow!
		lpo_temp = ipo_menutarget.GetParent()
	Case Else
		lpo_temp = gn_globals.of_get_frame()
		If Not IsValid(lpo_temp) Then Return True
//		lpo_temp = idw_destination.GetParent()
End Choose

DO WHILE lpo_temp.TypeOf() <> Window! 
	lpo_temp = lpo_temp.GetParent()
LOOP

lw_window = lpo_temp
		
If lw_window.windowtype = Response! Then
	ib_response_window = TRUE
else
	ib_response_window = FALSE
end if


Return True
end function

public subroutine of_rowfocuschanged (long row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rowfocuschanged()
//	Arguments:  xpos - the x position
//					ypos - the y position
//					row - The row
//					dwo - the datawindow object
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	9/23/00 - First Created
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row, ll_selectedrows[], ll_previously_selectedrows[], ll_previousrow, ll_previousrowcount

//-----------------------------------------------------------------------------------------------------------------------------------
// Promote the datawindow to u_datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(io_datasource) Then Return
If Not io_datasource.TypeOf() = Datawindow! Then Return

ll_previousrow = il_current_row
ll_previousrowcount = il_rowcount
il_rowcount = io_datasource.Dynamic RowCount()
il_current_row = row
//-----------------------------------------------------------------------------------------------------------------------------------
// Find the first row
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = io_datasource.Dynamic of_getselectedrow(0)
If ll_row = 0 Then ll_row = io_datasource.Dynamic GetRow()

//-----------------------------------------------------------------------------------------------------------------------------------
// While we are still finding rows, add them to the array
//-----------------------------------------------------------------------------------------------------------------------------------
Do While ll_row > 0 
	ll_selectedrows[UpperBound(ll_selectedrows) + 1] = ll_row
	ll_row = io_datasource.Dynamic of_getselectedrow(ll_row)
Loop

If il_current_row = ll_previousrow And il_selected_rows[] = ll_selectedrows[] And ll_previousrowcount = il_rowcount Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Pass the rows into this function
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_SetSelectedRows(ll_selectedrows)

If ib_report_detail_is_open Then
	This.of_retrieve_detail_report()
End If
end subroutine

private function long of_insert_navigation_keys ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_insert_navigation_keys()
//	Overview:   This will insert the keys necessary for many to many navigation
//	Created by:	Blake Doerr
//	History: 	9.17.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return, ll_index, ll_row
Datastore lds_navigation_keys
Transaction	lxtn_transaction

If IsValid(io_datasource) Then
	lxtn_transaction = io_datasource.Dynamic GetTransObject()
Else
	lxtn_transaction = ixctn_transaction
End If

If Not IsValid(lxtn_transaction) Then lxtn_transaction = SQLCA

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the next key for the NavigationKey table
//-----------------------------------------------------------------------------------------------------------------------------------
n_update_tools ln_update_tools 
ln_update_tools  = Create n_update_tools 
ll_return = ln_update_tools.of_get_key('NavigationKey')
Destroy ln_update_tools 


//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that we got a valid key
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ll_return > 0 And Not IsNull(ll_return) Then
	SetNull(ll_return)
	Return ll_return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore that will create the keys for navigation
//-----------------------------------------------------------------------------------------------------------------------------------
lds_navigation_keys = Create Datastore
lds_navigation_keys.DataObject = 'd_search_navigationkey'

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the dataobject actually exists
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lds_navigation_keys.Object) Then
	Destroy lds_navigation_keys
	SetNull(ll_return)
	Return ll_return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the transaction objet to be production
//-----------------------------------------------------------------------------------------------------------------------------------
lds_navigation_keys.SetTransObject(lxtn_transaction)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the keys and insert them into the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To il_multiple_record_count
	ll_row = lds_navigation_keys.InsertRow(0)
	lds_navigation_keys.SetItem(ll_row, 'SessionID', ll_return)

	If UpperBound(il_key1) >= ll_index Then lds_navigation_keys.SetItem(ll_row, 'key1', il_key1[ll_index])

	If UpperBound(il_key2) >= ll_index Then lds_navigation_keys.SetItem(ll_row, 'key2', il_key2[ll_index])

	If UpperBound(il_key3) >= ll_index Then lds_navigation_keys.SetItem(ll_row, 'key3', il_key3[ll_index])

	If UpperBound(il_key4) >= ll_index Then lds_navigation_keys.SetItem(ll_row, 'key4', il_key4[ll_index])

	If UpperBound(il_key5) >= ll_index Then lds_navigation_keys.SetItem(ll_row, 'key5', il_key5[ll_index])
	
	If UpperBound(idt_key1) >= ll_index Then lds_navigation_keys.SetItem(ll_row, 'datetime1', idt_key1[ll_index])	

	If UpperBound(is_key1) >= ll_index Then lds_navigation_keys.SetItem(ll_row, 'char1', is_key1[ll_index])
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that there are rows in the datastore and make sure that it updates successfully
//-----------------------------------------------------------------------------------------------------------------------------------
If lds_navigation_keys.RowCount() > 0 Then
	If Not lds_navigation_keys.Update() > 0 Then
		SetNull(ll_return)
	End IF
Else
	SetNull(ll_return)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datstore
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_navigation_keys

//-----------------------------------------------------------------------------------------------------------------------------------
// We are successful so return the result
//-----------------------------------------------------------------------------------------------------------------------------------
Return ll_return

end function

private function long of_insert_navigation_keys (ref n_entity_drag_message an_entity_drag_message);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_insert_navigation_keys()
//	Overview:   This will insert the keys necessary for many to many navigation
//	Created by:	Blake Doerr
//	History: 	9.17.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return, ll_index, ll_index2, ll_null, ll_number_key_count
String ls_keys[], ls_columns[], ls_key, ls_empty_array[]
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Set this to null because we will return it if it fails
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_entity_drag_message) Then Return ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the keys from the object
//-----------------------------------------------------------------------------------------------------------------------------------
an_entity_drag_message.of_get_keys(ls_keys[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there aren't any keys
//-----------------------------------------------------------------------------------------------------------------------------------
il_multiple_record_count = UpperBound(ls_keys[])
If il_multiple_record_count = 0 Then Return ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the keys and pull out the columns into the arrays
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To il_multiple_record_count
	ll_number_key_count = 0
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse the string into it's columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_parse_string(ls_keys[ll_index], ',', ls_columns[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the columns and get the keys
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index2 = 1 To UpperBound(ls_columns[])
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the key right after the equals
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_key = Mid(ls_columns[ll_index2], Pos(ls_columns[ll_index2], '=') + 1)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If it's valid, insert it into the correct array
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsNumber(ls_key) Then
			ll_number_key_count++
			Choose Case ll_number_key_count
				Case 1
					il_key1[ll_index] = Long(ls_key)
				Case 2
					il_key2[ll_index] = Long(ls_key)					
				Case 3
					il_key3[ll_index] = Long(ls_key)					
				Case 4
					il_key4[ll_index] = Long(ls_key)					
				Case 5
					il_key5[ll_index] = Long(ls_key)					
			End Choose
			
		ElseIf IsDate(ls_key) Or IsDate(Mid(ls_key, 1, Pos(ls_key, ' ') - 1)) Then
			idt_key1[ll_index] = gn_globals.in_string_functions.of_convert_string_to_datetime(ls_key)

		ElseIf Len(Trim(ls_key)) = 1 Then
			is_key1[ll_index] = Trim(ls_key)

		Else
			Return ll_null
		End If
	Next
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Clean out the array
		//-----------------------------------------------------------------------------------------------------------------------------------
	   ls_columns[] = ls_empty_array[]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Use these keys to insert into the database
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_insert_navigation_keys()

end function

public subroutine of_doubleclicked (long xpos, long ypos, long row, dwobject dwo);String	ls_navigation_retrieval_argument
Boolean	lb_openinplace = False

Datastore lds_entityaction_information

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datasource isn't a datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(io_datasource) Then Return
If io_datasource.TypeOf() <> Datawindow! Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// If you doubleclick and you are in a response window, ignore the event.
//-----------------------------------------------------------------------------------------------------------------------------------
if ib_response_window then RETURN

//-----------------------------------------------------------------------------------------------------------------------------------
// If you doubleclick it will trigger the open message for that entity.  Suppress this if the treeview service is alive.
//-----------------------------------------------------------------------------------------------------------------------------------
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Make this the only row that's selected
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_setselectedrows({row})

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the navigation string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_navigation_retrieval_argument = This.of_get_navigation_string(row)

lds_entityaction_information = gn_globals.in_cache.of_get_cache_reference('EntityAction')

If Not IsValid(lds_entityaction_information) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Send the message to the right place based on the action
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_navigation_retrieval_argument <> '' And Not IsNull(ls_navigation_retrieval_argument) Then
	
	If IsValid(io_navigation_detail_object) And Not ib_report_detail_is_open Then
		lb_openinplace = True
	ElseIf ib_AllowOpeningOfDetailReports And lds_entityaction_information.Find('EnttyActnEnttyID = ' + String(il_EnttyID) + ' And Lower(EnttyActnNme) = "open in place"', 1, lds_entityaction_information.RowCount()) > 0 And not lds_entityaction_information.Find('EnttyActnEnttyID = ' + String(il_EnttyID) + ' And Lower(EnttyActnNme) = "open"', 1, lds_entityaction_information.RowCount()) > 0 Then
		lb_openinplace = True
	End If
	
	If lb_openinplace Then
		This.Event ue_notify('Open In Place', 'Entity=' + is_EnttyNme + ',Source=' + is_EnttyNme + ',action=open,' + ls_navigation_retrieval_argument)
	Else
		This.Event ue_notify('Navigation', 'Entity=' + is_EnttyNme + ',Source=' + is_EnttyNme + ',action=open,' + ls_navigation_retrieval_argument)
	End If
End If

end subroutine

public function boolean of_load_entities ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_load_entities()
// Overview:    This will load all the entities and actions
// Created by:  Blake Doerr
// History:     5/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
long	l_enttyid[], l_i, l_rows, l_columns, l_entity_row, ll_index, ll_folderid
Long		ll_empty[]
Long		ll_requiredkeylevel = 1
Long		ll_row
Long		ll_rowcount
String	ls_destination_entity
String	ls_filterstring
String	ls_empty[]
String	ls_return
Datastore lds_entitycolumn_information

lds_entitycolumn_information = gn_globals.in_cache.of_get_cache_reference('EntityColumn')

//----------------------------------------------------------------------------------------------------------------------------------
// If the navigation string was passed in, we don't want to retrieve entities based on the columns in our datawindow, just based on entity.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(lds_entitycolumn_information) Then
	If (Trim(is_navigationstring) = '' Or IsNull(is_navigationstring)) AND NOT lower(is_EnttyNme) = 'dynamic' And Not ib_dynamic_entity_selection Then
		lds_entitycolumn_information.SetFilter('EnttyClmnEnttyID = ' + String(il_EnttyID))
		lds_entitycolumn_information.Filter()
		
		If lds_entitycolumn_information.RowCount() > 0 Then
			ll_requiredkeylevel = lds_entitycolumn_information.GetItemNumber(1, 'EnttyClmnKyLvl')
		
			If ll_requiredkeylevel > 0 Then
				il_columnnumber[]			= ll_empty[]
				is_columndescription[]	= ls_empty[]
				is_columnnamephysical[]	= ls_empty[]
				is_columnnamelogical[]	= ls_empty[]
				
				ls_filterstring	= 'EnttyClmnEnttyID = ' + String(il_EnttyID) + ' And If(IsNull(ClmnTrnsltnPhysclClmnNme), 0, 1) = 1 And Pos("' + is_physical_columns + '", "," + Lower(ClmnTrnsltnPhysclClmnNme) + ",") > 0'
			//	ls_filterstring	= 'Not IsNull(ClmnTrnsltnPhysclClmnNme) And Match("' + is_physical_columns + '", "," + Lower(ClmnTrnsltnPhysclClmnNme) + ",")'
				ll_rowcount = lds_entitycolumn_information.RowCount()
				lds_entitycolumn_information.SetFilter(ls_filterstring)
				ll_rowcount = lds_entitycolumn_information.Filter()
				ll_rowcount = lds_entitycolumn_information.RowCount()
				ls_return = lds_entitycolumn_information.Describe("Datawindow.Data")
					
				If lds_entitycolumn_information.RowCount() > 0 Then
					For ll_index = ll_requiredkeylevel To 1 Step -1
						ll_row = lds_entitycolumn_information.Find('EnttyClmnKyLvl = ' + String(ll_index), 1, lds_entitycolumn_information.RowCount())
						
						If ll_row > 0 Then
							is_columndescription[ll_index]	= lds_entitycolumn_information.GetItemString(ll_row, 'ClmnTrnsltnDscrptn')
							is_columnnamelogical[ll_index]	= lds_entitycolumn_information.GetItemString(ll_row, 'EnttyClmnLgclClmnNme')		
							is_columnnamephysical[ll_index]	= lds_entitycolumn_information.GetItemString(ll_row, 'ClmnTrnsltnPhysclClmnNme')
							il_columnnumber[ll_index]			= Long(io_datasource.Dynamic Describe(is_columnnamephysical[ll_index] + '.ID'))
						Else
							ib_EntityIsFullyDefinedByColumns = False
							Exit
						End If
					Next
				End If
			End If
		End If
	End If
	
	lds_entitycolumn_information.SetFilter('')
	lds_entitycolumn_information.Filter()
Else
	ib_EntityIsFullyDefinedByColumns = False
End If

ib_EntityIsFullyDefinedByColumns = True

Return True
end function

public subroutine of_add_parameters (long al_fromentityid, long al_toentityid, n_menu_dynamic am_menu, string as_message, any as_navigationstring, string as_parameter);Long		ll_index
String	ls_parameter
String	ls_description
String	ls_navigationstring
Datastore	lds_entitynavigationparameter_information

lds_entitynavigationparameter_information = gn_globals.in_cache.of_get_cache_reference('EntityParameter')

If Not IsValid(lds_entitynavigationparameter_information) Then Return

lds_entitynavigationparameter_information.SetFilter('FrmEnttyID	= ' + String(al_fromentityid) + ' And ToEnttyID = ' + String(al_toentityid))
lds_entitynavigationparameter_information.Filter()

If lds_entitynavigationparameter_information.RowCount() = 0 Or ib_IsDataCollection Or Lower(Trim(ClassName(as_navigationstring))) <> 'string' Then
	lds_entitynavigationparameter_information.SetFilter('')
	lds_entitynavigationparameter_information.Filter()
	Return
End If
If Len(Trim(as_parameter)) > 0 Then as_parameter = as_parameter + ','
If IsNull(as_parameter) Then as_parameter = ''

If Pos(as_parameter, ',') > 0 Then
		as_parameter	= Replace(as_parameter, Pos(as_parameter, ','), 1, '[comma]')
	End If

If Pos(as_parameter, '=') > 0 Then
	as_parameter	= Replace(as_parameter, Pos(as_parameter, '='), 1, '[equals]')
End If


am_menu.Tag = 'IgnoreClicked'

For ll_index = 1 To lds_entitynavigationparameter_information.RowCount()
	ls_parameter			= lds_entitynavigationparameter_information.GetItemString(ll_index, 'Parameter')
	ls_description			= lds_entitynavigationparameter_information.GetItemString(ll_index, 'Description')
	ls_navigationstring	= as_navigationstring
	
	If Pos(ls_parameter, '=') > 0 Then
		ls_parameter	= Replace(ls_parameter, Pos(ls_parameter, '='), 1, '[equals]')
	End If
	
	If Pos(ls_parameter, ',') > 0 Then
		ls_parameter	= Replace(ls_parameter, Pos(ls_parameter, ','), 1, '[comma]')
	End If
	
	If Len(Trim(ls_parameter)) > 0 Then
		ls_navigationstring = 'Parameter=' + + as_parameter + ls_parameter + ',' + ls_navigationstring
	End If
	
	//Now add the item underneath the found/created cascade...
	am_menu.of_add_item(ls_description, as_message, ls_navigationstring, This)
Next

lds_entitynavigationparameter_information.SetFilter('')
lds_entitynavigationparameter_information.Filter()
end subroutine

private subroutine of_set_entity (string as_entity);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_row

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Transaction 	lxctn_null_transaction
Datastore		lds_entity_information

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we are not changing the entity
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(as_entity)) = Lower(Trim(is_EnttyNme)) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset all variables
//-----------------------------------------------------------------------------------------------------------------------------------
ib_EnttyCmplxKy				= False
ib_RecordHistory				= False
ib_UserAdded					= False

il_EnttyID						= 0
il_RprtDtbseID					= 0

is_EnttyDsplyNme				= ''
is_EnttyDscrptnExprssn		= ''
is_ViewerObject				= ''
is_AdapterObject				= ''
is_GUIObject					= ''
is_GUIDataObject				= ''
is_DAOObject					= ''
is_DAODataObject				= ''
is_KeyControllerTable		= ''
is_KeyControllerColumn		= ''
is_TemplateColumn				= ''
is_TemplateAbbreviation		= ''
is_EntityIconSmall			= ''
is_EntityIconLarge			= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the entity information from the cache
//-----------------------------------------------------------------------------------------------------------------------------------
lds_entity_information = gn_globals.in_cache.of_get_cache_reference('Entity')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we can't get the cache
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lds_entity_information) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the entity we are setting
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = lds_entity_information.Find('Lower(enttynme) = "' + Lower(Trim(as_entity)) + '"', 1, lds_entity_information.RowCount())

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we can't find it
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ll_row) Or ll_row <= 0 Then
	is_EnttyNme						= ''
	is_EnttyNvgtnStrdPrcdre		= ''
	is_NavigationTempTable		= ''
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the original entity name
//-----------------------------------------------------------------------------------------------------------------------------------
If is_EnttyNme = '' Then is_OriginalEnttyNme = as_entity

//-----------------------------------------------------------------------------------------------------------------------------------
// Set all the instance variables
//-----------------------------------------------------------------------------------------------------------------------------------
ib_EnttyCmplxKy				= Upper(Trim(lds_entity_information.GetItemString(ll_row, 'EnttyCmplxKy'))) = 'Y'
ib_RecordHistory				= Upper(Trim(lds_entity_information.GetItemString(ll_row, 'RecordHistory'))) = 'Y'
ib_UserAdded					= Upper(Trim(lds_entity_information.GetItemString(ll_row, 'EnttyNme'))) = 'Y'

il_EnttyID						= lds_entity_information.GetItemNumber(ll_row, 'EnttyID')
il_RprtDtbseID					= lds_entity_information.GetItemNumber(ll_row, 'RprtDtbseID')

is_EnttyNme						= lds_entity_information.GetItemString(ll_row, 'EnttyNme')

If Lower(Trim(is_OriginalEnttyNme)) = Lower(Trim(as_entity)) Then
	is_EnttyNvgtnStrdPrcdre		= lds_entity_information.GetItemString(ll_row, 'EnttyNvgtnStrdPrcdre')
	is_NavigationTempTable		= lds_entity_information.GetItemString(ll_row, 'NavigationTempTable')
End If

is_EnttyDsplyNme				= lds_entity_information.GetItemString(ll_row, 'EnttyDsplyNme')
is_EnttyDscrptnExprssn		= lds_entity_information.GetItemString(ll_row, 'EnttyDscrptnExprssn')
is_ViewerObject				= lds_entity_information.GetItemString(ll_row, 'ViewerObject')
is_AdapterObject				= lds_entity_information.GetItemString(ll_row, 'AdapterObject')
is_GUIObject					= lds_entity_information.GetItemString(ll_row, 'GUIObject')
is_GUIDataObject				= lds_entity_information.GetItemString(ll_row, 'GUIDataObject')
is_DAOObject					= lds_entity_information.GetItemString(ll_row, 'DAOObject')
is_DAODataObject				= lds_entity_information.GetItemString(ll_row, 'DAODataObject')
is_KeyControllerTable		= lds_entity_information.GetItemString(ll_row, 'KeyControllerTable')
is_KeyControllerColumn		= lds_entity_information.GetItemString(ll_row, 'KeyControllerColumn')
is_TemplateColumn				= lds_entity_information.GetItemString(ll_row, 'TemplateColumn')
is_TemplateAbbreviation		= lds_entity_information.GetItemString(ll_row, 'TemplateAbbreviation')
is_EntityIconSmall			= lds_entity_information.GetItemString(ll_row, 'EnttyIcn')
is_EntityIconLarge			= lds_entity_information.GetItemString(ll_row, 'EnttyIcnLrge')
ixctn_transaction = lxctn_null_transaction

If Not IsNull(il_RprtDtbseID) And il_RprtDtbseID > 0 Then
	If IsValid(gn_globals.of_get_object('n_transaction_pool')) Then
		ixctn_transaction				= gn_globals.of_get_object('n_transaction_pool').Dynamic of_gettransactionobject(il_RprtDtbseID)
	Else
		ixctn_transaction = SQLCA
	End If
End If

If Not IsValid(ixctn_transaction) Then ixctn_transaction = SQLCA
end subroutine

public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu
//	Arguments:  None
//	Overview:   This function builds the navigation menu based on the entity and entityactions defined in the database.
//	Created by:	Blake Doerr
//	History: 	6/17/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
boolean	lb_create_item[]
boolean	lb_showmenu
long		l_enttyid
long		l_i
long		ll_index
long		ll_index2
long		ll_last_menuitem
long		ll_empty_array[]
long		ll_items
Long		ll_folderid
Long		ll_EnttyActnEnttyID[]
Long		ll_EnttyActnTrgtEnttyID[]
Long		ll_menu_EnttyActnEnttyID[]
Long		ll_menu_EnttyActnTrgtEnttyID[]
Long		ll_null
String	ls_destination_entity
string	ls_actions[]
string	ls_action_description[]
String	ls_entityname_target[]
String	ls_entitydisplayname_target[]
String	ls_array_parameter[]
string	ls_menu_text
string	ls_array_menu_text[]
String	ls_null
any		ls_array_navigation_string[]
string	ls_array_action[]
string	ls_array_entityname[]
string	ls_message[]
string	ls_allowsmultiplerows[]
string	ls_empty[]
string	ls_cascadingmenuname[]
String	ls_allowcollectiondata[]
Any		ls_temp_navigationstring
Boolean	lb_check_security[]
SetNull(ll_null)
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_menu_dynamic		ln_menu_dynamic_cascade
n_menu_dynamic		lm_return_menu
n_menu_dynamic		ln_menu_dynamic
//n_string_functions ln_string_functions
Datastore			lds_entityreportconfigfavorites

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the superfluous bags
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_garbagecollect()

Datastore lds_entityaction_information

lds_entityaction_information = gn_globals.in_cache.of_get_cache_reference('EntityAction')

If Not IsValid(lds_entityaction_information) Or Not ib_EntityIsFullyDefinedByColumns Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
//If there aren't any entities or entity actions, return
//-----------------------------------------------------------------------------------------------------------------------------------
If Trim(is_EnttyNme) = '' Then Return

If Not This.of_build_navigation_strings() Then
	il_selected_rows[] 				= ll_empty_array[]
	is_navigationstringmultiple[] = ls_empty[]
	SetNull(is_navigationstring)
	Return
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Get all the information out of the datastore into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
lds_entityaction_information.SetFilter('EnttyActnEnttyID = ' + String(il_EnttyID))
lds_entityaction_information.Filter()

If lds_entityaction_information.RowCount() > 0 Then
	ls_actions 							= lds_entityaction_information.object.EnttyActnNme.primary
	ls_action_description			= lds_entityaction_information.object.EnttyActnDscrptn.primary
	ls_allowsmultiplerows			= lds_entityaction_information.object.AllowsMultipleRows.primary
	ls_cascadingmenuname				= lds_entityaction_information.object.CascadingMenuItemName.primary
	ls_entityname_target				= lds_entityaction_information.object.EnttyNme.primary
	ls_entitydisplayname_target 	= lds_entityaction_information.object.EnttyDsplyNme.primary
	ls_allowcollectiondata			= lds_entityaction_information.object.AllowDataCollection.primary
	ll_EnttyActnEnttyID				= lds_entityaction_information.object.EnttyActnEnttyID.primary
	ll_EnttyActnTrgtEnttyID			= lds_entityaction_information.object.EnttyActnTrgtEnttyID.primary
End If

lds_entityaction_information.SetFilter('')
lds_entityaction_information.Filter()


//-----------------------------------------------------------------------------------------------------------------------------------
// Now loop through the actions and build arrays that hold the arguments for building the menu
//-----------------------------------------------------------------------------------------------------------------------------------
For l_i = 1 to upperbound(ls_actions[])
	ls_array_parameter[l_i]		= ''
	if ls_actions[l_i] = '-' then
		ls_menu_text = '-'
	else
		ls_menu_text = ls_actions[l_i]
		If UpperBound(is_columndescription[]) = 1 Then
			If Not IsNull(is_columndescription[1]) And Trim(is_columndescription[1]) <> '' Then
				ls_menu_text = ls_menu_text + ' ' + is_columndescription[1]
			End If
		End If
		
		If is_EnttyDsplyNme <> ls_entitydisplayname_target[l_i] Then
			If Right(ls_menu_text, Len(ls_entitydisplayname_target[l_i])) <> ls_entitydisplayname_target[l_i] Then
				ls_menu_text = ls_menu_text + ' ' + ls_entitydisplayname_target[l_i] 
			End If
			
			If Len(ls_action_description[l_i]) > 0 Then 
				ls_action_description[l_i] = ' ' + ls_action_description[l_i]
			Else
				ls_action_description[l_i] = ''
			End If
		Else
			ls_action_description[l_i] = ''
		End If

		ls_menu_text = ls_menu_text + ls_action_description[l_i] + '...'
	end if
			
	//----------------------------------------------------------------------------------------------------------------------------------
	// Put the menu items into an array because we want to add them conditionally based on security and gui standards for spacers
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_array_menu_text				[UpperBound(ls_array_menu_text) + 1]	= ls_menu_text
	If  ib_IsDataCollection Then
		in_superfluous_bag[UpperBound(in_superfluous_bag) + 1] = in_bag.of_copy()

		in_superfluous_bag[UpperBound(in_superfluous_bag)].of_set('Action', ls_actions[l_i])
		in_superfluous_bag[UpperBound(in_superfluous_bag)].of_set('Entity', ls_entityname_target[l_i])
		in_superfluous_bag[UpperBound(in_superfluous_bag)].of_set('Source', is_EnttyNme)
			
		ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= in_superfluous_bag[UpperBound(in_superfluous_bag)]
		
		
	Else
		ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= " Entity=" + ls_entityname_target[l_i] + ",Source=" + is_EnttyNme + ",Action=" + ls_actions[l_i] + ',Data="' +  is_navigationstring + '"'
	End If	
	ls_array_action					[UpperBound(ls_array_menu_text)] 		= ls_actions[l_i]
	ls_array_entityname				[UpperBound(ls_array_menu_text)] 		= ls_entityname_target[l_i]
	ll_menu_EnttyActnEnttyID		[UpperBound(ls_array_menu_text)]			= ll_EnttyActnEnttyID[l_i]
	ll_menu_EnttyActnTrgtEnttyID	[UpperBound(ls_array_menu_text)]			= ll_EnttyActnTrgtEnttyID[l_i]
	

			
	Choose Case Lower(Trim(ls_array_action[UpperBound(ls_array_menu_text)]))
		Case 'open in place', 'open in window'
			ls_message						[UpperBound(ls_array_menu_text)]			= ls_array_action[UpperBound(ls_array_menu_text)]
		Case Else
			ls_message						[UpperBound(ls_array_menu_text)]			= 'Navigate'
	End Choose
		

	lb_check_security				[UpperBound(ls_array_menu_text)]			= True
Next

If Not ib_IsDataCollection Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the favorite navigation paths
	//-----------------------------------------------------------------------------------------------------------------------------------
	lds_entityreportconfigfavorites = gn_globals.in_cache.of_get_cache_reference('EntityReportConfigFavorites')
	
	If IsValid(lds_entityreportconfigfavorites) Then
		lds_entityreportconfigfavorites.SetFilter('FrmEnttyID = ' + String(il_EnttyID))
		lds_entityreportconfigfavorites.Filter()
		If lds_entityreportconfigfavorites.Find('UserID = ' + String(gn_globals.il_userid), 1, lds_entityreportconfigfavorites.RowCount()) > 0 Then
			lds_entityreportconfigfavorites.SetFilter('FrmEnttyID = ' + String(il_EnttyID) + ' And UserID = ' + String(gn_globals.il_userid))
		Else
			lds_entityreportconfigfavorites.SetFilter('FrmEnttyID = ' + String(il_EnttyID) + ' And IsNull(UserID)')
		End If
		lds_entityreportconfigfavorites.Filter()
		For ll_index = lds_entityreportconfigfavorites.RowCount() To 1 Step -1
			ll_folderid = lds_entityreportconfigfavorites.GetItemNumber(ll_index, 'RprtCnfgFldrID')
			ls_destination_entity = lds_entityreportconfigfavorites.GetItemString(ll_index, 'EnttyNme')
			
//			If gn_globals.in_security.of_get_security(ls_destination_entity) < 1 Then
//				lds_entityreportconfigfavorites.RowsMove(ll_index, ll_index, Primary!, lds_entityreportconfigfavorites, lds_entityreportconfigfavorites.FilteredCount() + 1, Filter!)
//				Continue
//			End If		
//			
//			If gn_globals.in_security.of_get_folder_security(ll_folderid, 'report') < 1 Then
//				lds_entityreportconfigfavorites.RowsMove(ll_index, ll_index, Primary!, lds_entityreportconfigfavorites, lds_entityreportconfigfavorites.FilteredCount() + 1, Filter!)
//				Continue
//			End If
		Next
	
		If Not ib_response_window Then
			for l_i = 1 to lds_entityreportconfigfavorites.RowCount()
				//----------------------------------------------------------------------------------------------------------------------------------
				// Put the menu items into an array because we want to add them conditionally based on security and gui standards for spacers
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_array_menu_text				[UpperBound(ls_array_menu_text) + 1]	= 'Open ' + lds_entityreportconfigfavorites.GetItemString(l_i, 'RprtCnfgNme')
				ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= " Entity=" + lds_entityreportconfigfavorites.GetItemString(l_i, 'EnttyNme') + ",Source=" + is_EnttyNme + ",RprtCnfgID=" + String(lds_entityreportconfigfavorites.GetItemNumber(l_i, 'RprtCnfgID')) + ",Action=ReportNavigation" + ',Data="' +  is_navigationstring + '"'
				ls_array_action					[UpperBound(ls_array_menu_text)] 		= 'ReportNavigation'
				ls_array_entityname				[UpperBound(ls_array_menu_text)] 		= lds_entityreportconfigfavorites.GetItemString(l_i, 'EnttyNme')
				ls_message							[UpperBound(ls_array_menu_text)]			= 'Navigate'
				lb_check_security					[UpperBound(ls_array_menu_text)]			= False
				ls_allowsmultiplerows			[UpperBound(ls_array_menu_text)]			= 'Y'
				ls_cascadingmenuname				[UpperBound(ls_array_menu_text)]			= 'Open Report'
				ll_menu_EnttyActnEnttyID		[UpperBound(ls_array_menu_text)]			= lds_entityreportconfigfavorites.GetItemNumber(l_i, 'FrmEnttyID')
				ll_menu_EnttyActnTrgtEnttyID	[UpperBound(ls_array_menu_text)]			= lds_entityreportconfigfavorites.GetItemNumber(l_i, 'ToEnttyID')
				ls_array_parameter				[UpperBound(ls_array_menu_text)]			= lds_entityreportconfigfavorites.GetItemString(l_i, 'Parameters')
				
				If Pos(ls_array_parameter[UpperBound(ls_array_menu_text)], '=') > 0 Then
					gn_globals.in_string_functions.of_replace_all(ls_array_parameter[UpperBound(ls_array_menu_text)], '=', '[equals]')
				End If
				
				//If the next item is from a different desktop (by icon) then put in a separator bar
				if l_i +1 < lds_entityreportconfigfavorites.RowCount() then
					if lds_entityreportconfigfavorites.GetItemString(l_i + 1, 'enttyicn')<> lds_entityreportconfigfavorites.GetItemString(l_i, 'enttyicn') then
						ls_array_menu_text			[UpperBound(ls_array_menu_text) +1]		=	'-'
						ls_cascadingmenuname			[UpperBound(ls_array_menu_text)]			=	'Open Report'
					end if
				end if
			Next
			
			ls_array_menu_text			[UpperBound(ls_array_menu_text) +1]		=	'-'
			ls_cascadingmenuname			[UpperBound(ls_array_menu_text)]			=	'Open Report'
			
			ls_array_menu_text				[UpperBound(ls_array_menu_text) + 1]	= 'All Reports...'
			ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= " Entity=?,Source=" + is_EnttyNme + ",RprtCnfgID=?,Action=ReportNavigation" + ',Data="' +  is_navigationstring + '"'
			ls_array_action					[UpperBound(ls_array_menu_text)] 		= 'ReportNavigation'
			ls_array_entityname				[UpperBound(ls_array_menu_text)] 		= ''
			ls_message							[UpperBound(ls_array_menu_text)]			= 'Other Reports'
			lb_check_security					[UpperBound(ls_array_menu_text)]			= False
			ls_allowsmultiplerows			[UpperBound(ls_array_menu_text)]			= 'Y'
			ls_cascadingmenuname				[UpperBound(ls_array_menu_text)]			= 'Open Report'
			ll_menu_EnttyActnEnttyID		[UpperBound(ls_array_menu_text)]			= ll_null
			ll_menu_EnttyActnTrgtEnttyID	[UpperBound(ls_array_menu_text)]			= ll_null
			ls_array_parameter				[UpperBound(ls_array_menu_text)]			= ls_null

			ls_array_menu_text				[UpperBound(ls_array_menu_text) + 1]	= 'Customize Report Menu...'
			ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= "Customize Reports"
			ls_array_action					[UpperBound(ls_array_menu_text)] 		= ''
			ls_array_entityname				[UpperBound(ls_array_menu_text)] 		= ''
			ls_message							[UpperBound(ls_array_menu_text)]			= 'Customize Reports'
			lb_check_security					[UpperBound(ls_array_menu_text)]			= False
			ls_allowsmultiplerows			[UpperBound(ls_array_menu_text)]			= 'Y'
			ls_cascadingmenuname				[UpperBound(ls_array_menu_text)]			= 'Open Report'
			ll_menu_EnttyActnEnttyID		[UpperBound(ls_array_menu_text)]			= ll_null
			ll_menu_EnttyActnTrgtEnttyID	[UpperBound(ls_array_menu_text)]			= ll_null
			ls_array_parameter				[UpperBound(ls_array_menu_text)]			= ls_null
		End If
		
		If ib_AllowOpeningOfDetailReports Then
			for l_i = 1 to lds_entityreportconfigfavorites.RowCount()
				//----------------------------------------------------------------------------------------------------------------------------------
				// Put the menu items into an array because we want to add them conditionally based on security and gui standards for spacers
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_array_menu_text				[UpperBound(ls_array_menu_text) + 1]	= 'Open ' + lds_entityreportconfigfavorites.GetItemString(l_i, 'RprtCnfgNme')
				ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= "RprtCnfgID=" + String(lds_entityreportconfigfavorites.GetItemNumber(l_i, 'RprtCnfgID'))
				ls_array_action					[UpperBound(ls_array_menu_text)] 		= 'ReportDetailNavigation'
				ls_array_entityname				[UpperBound(ls_array_menu_text)] 		= lds_entityreportconfigfavorites.GetItemString(l_i, 'EnttyNme')
				ls_message							[UpperBound(ls_array_menu_text)]			= 'ReportDetailNavigation'
				lb_check_security					[UpperBound(ls_array_menu_text)]			= False
				ls_allowsmultiplerows			[UpperBound(ls_array_menu_text)]			= 'Y'
				ls_cascadingmenuname				[UpperBound(ls_array_menu_text)]			= 'Open Report as Detail'
				ll_menu_EnttyActnEnttyID		[UpperBound(ls_array_menu_text)]			= lds_entityreportconfigfavorites.GetItemNumber(l_i, 'FrmEnttyID')
				ll_menu_EnttyActnTrgtEnttyID	[UpperBound(ls_array_menu_text)]			= lds_entityreportconfigfavorites.GetItemNumber(l_i, 'ToEnttyID')
				ls_array_parameter				[UpperBound(ls_array_menu_text)]			= lds_entityreportconfigfavorites.GetItemString(l_i, 'Parameters')
	
				If Pos(ls_array_parameter[UpperBound(ls_array_menu_text)], '=') > 0 Then
					gn_globals.in_string_functions.of_replace_all(ls_array_parameter[UpperBound(ls_array_menu_text)], '=', '[equals]')
				End If
	
				//If the next item is from a different desktop (by icon) then put in a separator bar
				if l_i +1 < lds_entityreportconfigfavorites.RowCount() then
					if lds_entityreportconfigfavorites.GetItemString(l_i + 1, 'enttyicn')<> lds_entityreportconfigfavorites.GetItemString(l_i, 'enttyicn') then
						ls_array_menu_text			[UpperBound(ls_array_menu_text) +1]		=	'-'
						ls_cascadingmenuname			[UpperBound(ls_array_menu_text)]			=	'Open Report as Detail'
					end if
				end if
			Next
			
			ls_array_menu_text			[UpperBound(ls_array_menu_text) +1]		=	'-'
			ls_cascadingmenuname			[UpperBound(ls_array_menu_text)]			=	'Open Report as Detail'

			
			ls_array_menu_text				[UpperBound(ls_array_menu_text) + 1]	= 'All Reports...'
			ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= "RprtCnfgID=?"
			ls_array_action					[UpperBound(ls_array_menu_text)] 		= 'ReportDetailNavigation'
			ls_array_entityname				[UpperBound(ls_array_menu_text)] 		= ''
			ls_message							[UpperBound(ls_array_menu_text)]			= 'ReportDetailNavigation'
			lb_check_security					[UpperBound(ls_array_menu_text)]			= False
			ls_allowsmultiplerows			[UpperBound(ls_array_menu_text)]			= 'Y'
			ls_cascadingmenuname				[UpperBound(ls_array_menu_text)]			= 'Open Report as Detail'
			ll_menu_EnttyActnEnttyID		[UpperBound(ls_array_menu_text)]			= ll_null
			ll_menu_EnttyActnTrgtEnttyID	[UpperBound(ls_array_menu_text)]			= ll_null
			ls_array_parameter				[UpperBound(ls_array_menu_text)]			= ''

			ls_array_menu_text				[UpperBound(ls_array_menu_text) + 1]	= 'Customize Report Menu...'
			ls_array_navigation_string		[UpperBound(ls_array_menu_text)] 		= "Customize Reports"
			ls_array_action					[UpperBound(ls_array_menu_text)] 		= ''
			ls_array_entityname				[UpperBound(ls_array_menu_text)] 		= ''
			ls_message							[UpperBound(ls_array_menu_text)]			= 'Customize Reports'
			lb_check_security					[UpperBound(ls_array_menu_text)]			= False
			ls_allowsmultiplerows			[UpperBound(ls_array_menu_text)]			= 'Y'
			ls_cascadingmenuname				[UpperBound(ls_array_menu_text)]			= 'Open Report as Detail'
			ll_menu_EnttyActnEnttyID		[UpperBound(ls_array_menu_text)]			= ll_null
			ll_menu_EnttyActnTrgtEnttyID	[UpperBound(ls_array_menu_text)]			= ll_null
			ls_array_parameter				[UpperBound(ls_array_menu_text)]			= ''
		End If
	
		//----------------------------------------------------------------------------------------------------------------------------------
		// Restore the filter so we don't cause cache problems.
		//----------------------------------------------------------------------------------------------------------------------------------
		lds_entityreportconfigfavorites.SetFilter('')
		lds_entityreportconfigfavorites.Filter()
	End If
End If


//----------------------------------------------------------------------------------------------------------------------------------
// Loop through the arrays and build another array of booleans that indicates whether the item
// should be created or not.  This is determined by checking security and whether the spacers
// would look right if the item was shown.
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_array_menu_text)
	lb_create_item[ll_index] = True
	
	Choose Case Trim(ls_array_menu_text[ll_index])
		Case '-'
		Case Else
			If ib_response_window Then
				If Left(Lower(ls_array_action[ll_index]), 6) = 'search' Then
					lb_create_item[ll_index] = False
					Continue
				End If
			End If
			
			If Not ib_AllowOpeningOfDetailReports And Lower(ls_array_action[ll_index]) = 'open in place' Then
				lb_create_item[ll_index] = False
				Continue
			End If				

			If UpperBound(il_selected_rows[]) = 0 And lb_check_security[ll_index] And Len(Trim(is_navigationstring)) = 0 Then
				lb_create_item[ll_index] = False
				Continue
			End If

			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Check security before putting the item in the final array of items
			//-----------------------------------------------------------------------------------------------------------------------------------
			If UpperBound(il_selected_rows[]) > 1 And Upper(ls_allowsmultiplerows[ll_index]) <> 'Y' Then
				lb_create_item[ll_index] = False
				Continue
			End If
			
			If lb_check_security[ll_index] Then
//				If Not gn_globals.in_security.of_get_security(ls_array_action[ll_index] + ' ' + ls_array_entityname[ll_index]) > 0 Then
//					lb_create_item[ll_index] = False
//					Continue
//				End If
			End If
			
			For ll_index2 = 1 To UpperBound(is_excluded_action)
				If Lower(ls_array_action[ll_index]) = Lower(is_excluded_action[ll_index2]) And is_EnttyNme = ls_array_entityname[ll_index] Then
					lb_create_item[ll_index] = False
					Exit
				End If
			Next
			
			If UpperBound(ls_allowcollectiondata) >= ll_index Then
				If ib_IsDataCollection And Lower(Trim(ls_allowcollectiondata[ll_index])) = 'n' Then
					lb_create_item[ll_index] = False
				End If
				
				If NOT ib_IsDataCollection And Lower(Trim(ls_allowcollectiondata[ll_index])) = 'y' Then
					lb_create_item[ll_index] = False
				End If
			End If	
				
	End Choose
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we are creating the item, update the spacer boolean and indexes for the last menu item
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lb_create_item[ll_index] Then 	
		ll_last_menuitem = ll_index
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that at least one menu item is going to be created.  Set lb_showmenu to TRUE if so.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_mailenabled Or ib_IsDataCollection Then
	For ll_index = 1 To ll_last_menuitem
		If lb_create_item[ll_index] Then
			lb_showmenu = True
			Exit
		End If
	Next
	
	If Not lb_showmenu Then	Return
End If

If UpperBound(an_menu_dynamic.Item[]) > 0 And Not an_menu_dynamic.of_isappending('navigation options') Then
	ln_menu_dynamic = an_menu_dynamic.of_add_item('Navigation Options', '', '')
Else
	ln_menu_dynamic = an_menu_dynamic
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the arrays, adding menu items to the menu
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_last_menuitem
	//Make sure the item should be created
	If NOT lb_create_item[ll_index] Then CONTINUE
	
	If Len(Trim(ls_array_parameter[ll_index])) > 0 and Not ib_IsDataCollection Then
		ls_temp_navigationstring = 'Parameter=' + Trim(ls_array_parameter[ll_index]) + ',' + ls_array_navigation_string[ll_index]
	Else
		ls_temp_navigationstring = ls_array_navigation_string[ll_index]
	End If
	
	//If the item is not under a cascace, just add it
	If IsNull(ls_cascadingmenuname[ll_index]) Or Len(Trim(ls_cascadingmenuname[ll_index])) = 0 Then
		ln_menu_dynamic_cascade = ln_menu_dynamic
	Else
		// Try to find the cascade item under which to add this item
		SetNull(ln_menu_dynamic_cascade)
		For ll_index2 = 1 To UpperBound(ln_menu_dynamic.Item[])
			If Not IsValid(ln_menu_dynamic.Item[ll_index2]) Then Continue
			
			If Lower(Trim(ln_menu_dynamic.Item[ll_index2].Text)) = Lower(Trim(ls_cascadingmenuname[ll_index])) Then
				ln_menu_dynamic_cascade = ln_menu_dynamic.Item[ll_index2]
				Exit
			End If
		Next
		
		If IsNull(ln_menu_dynamic_cascade) Or Not IsValid(ln_menu_dynamic_cascade) Then
			ln_menu_dynamic_cascade = ln_menu_dynamic.of_add_item(ls_cascadingmenuname[ll_index], '', '')
		End If
	End If

	lm_return_menu = ln_menu_dynamic_cascade.of_add_item(ls_array_menu_text[ll_index], ls_message[ll_index], ls_temp_navigationstring, This)
	If Lower(Trim(ls_array_menu_text[ll_index])) = 'open...' Then lm_return_menu.Default = True
	If Lower(Trim(ls_array_menu_text[ll_index])) <> '-' And Not ib_IsDataCollection And Not IsNull(ll_menu_EnttyActnEnttyID[ll_index]) And Not IsNull(ll_menu_EnttyActnTrgtEnttyID[ll_index]) Then
		This.of_add_parameters(ll_menu_EnttyActnEnttyID[ll_index], ll_menu_EnttyActnTrgtEnttyID[ll_index], lm_return_menu, ls_message[ll_index], ls_array_navigation_string[ll_index], Trim(ls_array_parameter[ll_index]))
	End If 	
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the spacer (If necessary) and the send mail menuitem
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_IsDataCollection And ib_mailenabled And (UpperBound(il_selected_rows[]) > 0 Or Not IsValid(io_datasource)) Then
	ln_menu_dynamic.of_add_item('-', '-', '-')
	ln_menu_dynamic.of_add_item('Add To Favorites...', 'Add To Favorites', '', This)
	If Not ib_response_window Then ln_menu_dynamic.of_add_item('Send to Mail Recipient...', 'Send to Mail Recipient', '', This)
End If
end subroutine

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_batchmode = ab_batchmode
end subroutine

on n_navigation_options.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_navigation_options.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   This will create the datastores that will retrieve entities and entity actions
// Created by: Blake Doerr
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

in_data_mover = create n_data_mover

end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Destructor
// Overrides:  No
// Overview:   Destroy the datastores
// Created by: Blake Doerr
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Destroy in_data_mover

This.of_garbagecollect()
end event

