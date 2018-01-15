$PBExportHeader$n_datawindow_graphic_service_manager.sru
forward
global type n_datawindow_graphic_service_manager from nonvisualobject
end type
end forward

global type n_datawindow_graphic_service_manager from nonvisualobject
event type string ue_notify ( string as_message,  any aany_arg )
event ue_refreshtheme ( )
event ue_drag_scroll ( )
end type
global n_datawindow_graphic_service_manager n_datawindow_graphic_service_manager

type variables
Protected:
//Service Objects
	PowerObject idw_data
	Nonvisualobject in_services[]
	Nonvisualobject in_rowfocus_service
	Nonvisualobject in_column_sizing_service
	Nonvisualobject in_sort_service
	Nonvisualobject in_dao_dataobject_state
	Nonvisualobject in_group_by_service
	Nonvisualobject in_navigation_options
	Nonvisualobject in_datawindow_formatting_service
	Nonvisualobject in_dropdowndatawindow_caching_service

	Nonvisualobject in_reject_invalids
	Nonvisualobject in_autofill_service
	Nonvisualobject in_keydates_service
	Nonvisualobject in_calendar_column_service
	Nonvisualobject in_multi_select_dddw_service
	Nonvisualobject in_datawindow_tooltp_display_column_text
	
	Nonvisualobject in_datawindow_treeview_service
	Nonvisualobject in_show_fields

	Nonvisualobject in_pivot_table_service

	Nonvisualobject in_aggregation_service
	Nonvisualobject in_dao_service
	Nonvisualobject in_swap_service
	Nonvisualobject in_rowsmove_service
	
	Nonvisualobject in_rows_discard_service
	NonVisualObject in_datawindow_conversion_service
	Nonvisualobject	in_drag_scroll_timer
	powerobject			ipo_drag_scroll_source

//Component Objects
	PowerObject ipo_components[]
	
	PowerObject	iu_filter_strip

//State Variables
	String 	is_service_name[]
	String 	is_component_name[]
	Boolean 	ib_objects_have_been_created = False
	Boolean 	ib_datawindow_has_been_interrogated = False
	String	is_default_list_of_services = ''
	Boolean	ib_We_Are_Drag_Scrolling = False
	Boolean	ib_Drag_Scroll_Direction_Up = False
	Boolean	ib_RunningInBatchMode	= False
end variables

forward prototypes
public function nonvisualobject of_add_service (ref nonvisualobject ao_service)
public subroutine of_destroy_service (string as_servicename)
public function powerobject of_get_component (string as_componentname)
public function nonvisualobject of_get_service (string as_servicename)
public function boolean of_arethereservices ()
public subroutine of_create_services ()
public function long of_redirect_event (string as_eventname, sqlpreviewfunction request, sqlpreviewtype sqltype, ref string sqlsyntax, dwbuffer buffer, long row)
public function long of_redirect_event (string as_eventname, unsignedlong flags, long xpos, long ypos)
public subroutine of_init (ref powerobject adw_datawindow)
public subroutine of_add_service (string as_servicename)
public subroutine of_set_batchmode (boolean ab_runninginbatch)
public function long of_redirect_event (string as_eventname)
public function long of_redirect_event (string as_eventname, keycode key, unsignedlong keyflags)
public function long of_redirect_event (string as_eventname, long row, ref dwobject dwo, string data)
public function long of_redirect_event (string as_eventname, long scrollpos, long pane)
public function long of_redirect_event (string as_eventname, ref dragobject source)
public function long of_redirect_event (string as_eventname, long rowcount)
public function long of_redirect_event (string as_eventname, long xpos, long ypos, long row, ref dwobject dwo)
public function long of_redirect_event (string as_eventname, ref dragobject source, long row, ref dwobject dwo)
public subroutine of_add_component (ref powerobject au_component, string as_component_type)
public subroutine of_get_menu_xml (string as_type, ref n_menu_dynamic an_menu_dynamic)
public function nonvisualobject of_create_object (string as_objectname, ref nonvisualobject an_object)
public function long of_redirect_event (string as_eventname, long xpos, long ypos, long row, ref dwobject dwo, ref n_menu_dynamic an_menu_dynamic)
public subroutine of_interrogate_datawindow ()
end prototypes

event type string ue_notify(string as_message, any aany_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//					aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Joel White
// History:   2/23/05 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return
n_export_datawindow_wysiwyg ln_export_datawindow_wysiwyg
Datastore				lds_datastore

String 	ls_columnname, ls_array[], ls_resultset, ls_data, ls_clipboard
String	ls_lookupdisplay[]
Long 		ll_index
Long		ll_row
n_datawindow_tools ln_datawindow_tools
n_nonvisual_window_opener ln_nonvisual_window_opener
n_bag ln_bag

Choose Case Lower(Trim(as_message))
	Case 'copy column'
		If idw_data.Dynamic RowCount() = 0 Then Return ''
		
		ls_columnname = String(aany_arg)

		ln_datawindow_tools = Create n_datawindow_tools
		ls_resultset = ln_datawindow_tools.of_get_column_header(idw_data, ls_columnname) + '~r~n'
		ln_datawindow_tools.of_get_lookupdisplay(idw_data, ls_columnname, ls_lookupdisplay[])
		Destroy ln_datawindow_tools
		
		For ll_index = 1 To UpperBound(ls_lookupdisplay[])
			If Not IsNull(ls_lookupdisplay[ll_index]) Then
				ls_resultset = ls_resultset + ls_lookupdisplay[ll_index] + '~r~n'
			Else
				ls_resultset = ls_resultset + 'Null~r~n'
			End If
		Next
		
		ls_resultset = Left(ls_resultset, Len(ls_resultset) - 2)
		ClipBoard(ls_resultset)
		

	Case 'copy field'
		ll_row = idw_data.Dynamic of_getselectedrow(0)
		
		ln_datawindow_tools = Create n_datawindow_tools
		
		Do While ll_row > 0 And Not IsNull(ll_row) And ll_row <= idw_data.Dynamic RowCount()
			If ln_datawindow_tools.of_IsComputedField(idw_data, String(aany_arg)) Then
				ls_resultset = ls_resultset + idw_data.Dynamic Describe("Evaluate(~"" + String(aany_arg) + "~", " + String(ll_row) + ")") + '~r~n'
			Else
				ls_resultset = ls_resultset + idw_data.Dynamic Describe("Evaluate(~"LookupDisplay(" + String(aany_arg) + ")~", " + String(ll_row) + ")") + '~r~n'
			End If
			
			ll_row = idw_data.Dynamic of_getselectedrow(ll_row)
		Loop
		
		Destroy ln_datawindow_tools

		ClipBoard(Left(ls_resultset, Len(ls_resultset) - 2))
	Case 'copy report'
		ln_export_datawindow_wysiwyg = Create n_export_datawindow_wysiwyg
		ln_export_datawindow_wysiwyg.of_init(idw_data)
		ls_return = ln_export_datawindow_wysiwyg.of_create_datastore(lds_datastore)
		Destroy ln_export_datawindow_wysiwyg
		
		If IsValid(lds_datastore) Then
			ls_return = '~r~n' + lds_datastore.Describe("DataWindow.Data")
			
			For ll_index = Long(lds_datastore.Describe("Datawindow.Column.Count")) to 1 Step -1
				ls_return = '~t' + lds_datastore.Describe("#" + String(ll_index) + '.DBName') + ls_return
			Next
			
			ls_return = Mid(ls_return, 2)
			
			ClipBoard(ls_return)
		Else
			ClipBoard(idw_data.Dynamic Describe("DataWindow.Data.HTMLTable"))
		End If
	Case 'view text'
		ll_row = idw_data.Dynamic of_getselectedrow(0)
		
		ln_datawindow_tools = Create n_datawindow_tools
		
		Do While ll_row > 0 And Not IsNull(ll_row) And ll_row <= idw_data.Dynamic RowCount()
			If ln_datawindow_tools.of_IsComputedField(idw_data, String(aany_arg)) Then
				ls_resultset = ls_resultset + idw_data.Dynamic Describe("Evaluate(~"" + String(aany_arg) + "~", " + String(ll_row) + ")") + '~r~n'
			Else
				ls_resultset = ls_resultset + idw_data.Dynamic Describe("Evaluate(~"LookupDisplay(" + String(aany_arg) + ")~", " + String(ll_row) + ")") + '~r~n'
			End If
			
			ll_row = idw_data.Dynamic of_getselectedrow(ll_row)
		Loop
		
		Destroy ln_datawindow_tools

		ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
		ln_bag = Create n_bag
		ln_bag.of_set('text', ls_resultset)
		ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_popup_view_all_text', ln_bag)
		Destroy ln_nonvisual_window_opener
		


	Case 'export to word'
//		Datawindow ldw_data
//		u_search lu_searches[], lu_search
//		u_dynamic_gui lu_dynamic_gui
//		n_microsoft_word ln_microsoft_word
//		
//		ln_microsoft_word = Create n_microsoft_word
//		lu_search = idw_data.GetParent()
//		lu_dynamic_gui = lu_search.of_get_overlaying_report()
//		
//		If IsValid(lu_dynamic_gui) Then
//			lu_dynamic_gui.Dynamic of_get_reports(lu_searches[])
//			If UpperBound(lu_searches[]) > 0 Then
//				If IsValid(lu_searches[1]) Then
//					ldw_data = lu_searches[1].dw_report
//				End If
//			End If
//		End If
//		
//		Run(ln_microsoft_word.of_export_to_word(idw_data, ldw_data, '', ''))
//
//		Destroy ln_microsoft_word
	Case Else
		If IsValid(in_datawindow_formatting_service) Then
			Return in_datawindow_formatting_service.Dynamic Event ue_notify(as_message, aany_arg)
		Else
			Return '1'
		End If
End Choose

Return ''
end event

event ue_drag_scroll();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:		ue_drag_scroll
//	Arguments:  
//	Overview:   Timer-fired event to scroll the screen up/down while dragging
//	Created by:	Joel White
//	History: 	06/07/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

if ib_We_Are_Drag_Scrolling = true then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Scrolling up.  Set the row to the top row on the page (to eliminate delay) and start scrolling
		//-----------------------------------------------------------------------------------------------------------------------------------

	if ib_Drag_Scroll_Direction_Up = true then
		ipo_Drag_Scroll_Source.dynamic setrow(long(ipo_Drag_Scroll_Source.dynamic describe("datawindow.firstrowonpage")))
		ipo_Drag_Scroll_Source.dynamic scrollpriorrow()
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Scrolling down.  Set the row to the last row on the page (to eliminate delay) and start scrolling
		//-----------------------------------------------------------------------------------------------------------------------------------
	else
		ipo_Drag_Scroll_Source.dynamic setrow(long(ipo_Drag_Scroll_Source.dynamic describe("datawindow.lastrowonpage")))
		ipo_Drag_Scroll_Source.dynamic scrollnextrow()
	end if
end if
end event

public function nonvisualobject of_add_service (ref nonvisualobject ao_service);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_service()
//	Arguments:  ao_service - The created service
//	Overview:   This will add the service to the array
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
String ls_objectname
NonVisualObject ln_nullobject

If Not IsValid(ao_service) Or IsNull(ao_service) Then Return ln_nullobject

Return This.of_create_object(ao_service.ClassName(), ao_service)
end function

public subroutine of_destroy_service (string as_servicename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_destroy_service()
//	Arguments:  as_servicename - The name of the service
//	Overview:   This will destroy a service that you want
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the service is not already in the array
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_services[])
	If IsValid(in_services[ll_index]) Then
		If Lower(Trim(in_services[ll_index].ClassName())) = Lower(Trim(as_servicename)) Then

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Here is where you put custom pre destroy logic
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case Lower(Trim(as_servicename))
				Case 'n_group_by_service'
			End Choose
			
			Destroy in_services[ll_index]
			Return
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If it is in the queue to be created, clear it out
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_service_name[])
	If Lower(Trim(as_servicename)) = Lower(Trim(is_service_name[ll_index])) Then is_service_name[ll_index] = ''
Next
end subroutine

public function powerobject of_get_component (string as_componentname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_component()
//	Arguments:  as_componentname - The name of the component
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
powerobject lpo_null_object

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the components
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_component_name)
	If is_component_name[ll_index] = as_componentname And IsValid(ipo_components[ll_index]) Then Return ipo_components[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return a null object instead
//-----------------------------------------------------------------------------------------------------------------------------------
Return lpo_null_object
end function

public function nonvisualobject of_get_service (string as_servicename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_service()
//	Arguments:  as_servicename - The name of the service
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
NonVisualObject ln_null_object

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the servicesw
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_services)
	If IsValid(in_services[ll_index]) Then 
		If Lower(Trim(in_services[ll_index].ClassName())) = Lower(Trim(as_servicename)) Then Return in_services[ll_index]
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return a null object instead
//-----------------------------------------------------------------------------------------------------------------------------------
Return ln_null_object
end function

public function boolean of_arethereservices ();Return UpperBound(is_service_name[]) > 0
end function

public subroutine of_create_services ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_create_services()
//	Overview:   Create all the services in the array
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_index2
Boolean lb_continue = False
graphicobject	lgo_parent
window lw_return
NonVisualObject ln_service, ln_nullobject

//If IsValid(gn_globals.in_performance_statistics_manager) Then
//	If gn_globals.in_performance_statistics_manager.of_currently_logging() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent('Creating Graphic Services')
//	End If
//End If

If Not ib_datawindow_has_been_interrogated Then
	This.of_interrogate_datawindow()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Case to see what service to instantiate
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_service_name[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Check to see if the object is already instantiated
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index2 = 1 To UpperBound(in_services[])
		If IsValid(in_services[ll_index2]) Then
			If Lower(Trim(is_service_name[ll_index])) = Lower(Trim(in_services[ll_index2].ClassName())) Then
				lb_continue = True
				Exit
			End If
		End If
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we need to continue, do so
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lb_continue Then 
		lb_continue = False
		Continue
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Based on the name of the service, create it and initialize it
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If IsValid(gn_globals.in_performance_statistics_manager) Then
//		If gn_globals.in_performance_statistics_manager.of_currently_logging() Then
//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin('Creating ' + is_service_name[ll_index])
//		End If
//	End If

	ln_service = This.of_create_object(is_service_name[ll_index], ln_nullobject)
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set this to true to know that we have created the services
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(is_service_name[]) > 0 Then
	ib_objects_have_been_created = True
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Publish a message that the services were created
	//-----------------------------------------------------------------------------------------------------------------------------------
	if isvalid(gn_globals.in_subscription_service) then
		gn_globals.in_subscription_service.of_message('Graphic Services Created', idw_data, idw_data)
	end if
End If

//If IsValid(gn_globals.in_performance_statistics_manager) Then
//	If gn_globals.in_performance_statistics_manager.of_currently_logging() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent('Creating Graphic Services')
//	End If
//End If
end subroutine

public function long of_redirect_event (string as_eventname, sqlpreviewfunction request, sqlpreviewtype sqltype, ref string sqlsyntax, dwbuffer buffer, long row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					row				- The row number
//					dwo				- The datawindow object
//					data				- The string data in the column
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_return

SetNull(ll_return)

Choose Case Lower(Trim(as_eventname))
	CASE 'sqlpreview'
		If IsValid(in_datawindow_formatting_service) Then ll_return = in_datawindow_formatting_service.Dynamic of_sqlpreview(request, sqltype, sqlsyntax, buffer, row)
End Choose

Return ll_return
end function

public function long of_redirect_event (string as_eventname, unsignedlong flags, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					flags				- stuff
//					xpos				- The x position
//					ypos				- The y position
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_null
Boolean lb_event_is_begin_used = False

//-----------------------------------------------------------------------------------------------------------------------------------
// Case statement based on events
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE Lower(Trim(as_eventname))
	Case 'pbm_mousemove'
		ib_We_Are_Drag_Scrolling = false
		If IsValid(in_column_sizing_service) Then 
			lb_event_is_begin_used = lb_event_is_begin_used  Or in_column_sizing_service.Dynamic of_mousemove(flags, xpos, ypos)
		End If
		
		If IsValid(in_group_by_service) Then 
			lb_event_is_begin_used = lb_event_is_begin_used  Or in_group_by_service.Dynamic of_mousemove(flags, xpos, ypos)
		End If

		If IsValid(in_show_fields) Then 
			lb_event_is_begin_used = lb_event_is_begin_used  Or in_show_fields.Dynamic of_mousemove(flags, xpos, ypos, lb_event_is_begin_used = False)
		End If

		If IsValid(in_navigation_options) And Not lb_event_is_begin_used Then
			in_navigation_options.Dynamic of_pbm_mousemove(flags, xpos, ypos)
		End If
		
	Case 'pbm_lbuttondown'
		If IsValid(in_column_sizing_service) 	Then in_column_sizing_service.Dynamic of_lbuttondown(idw_data.Dynamic PointerX())
		If IsValid(in_group_by_service) 			Then in_group_by_service.Dynamic of_leftbuttondown(xpos, ypos)
		If IsValid(in_show_fields) 				Then in_show_fields.Dynamic of_lbuttondown(flags, xpos, ypos)
		If IsValid(in_swap_service) Then in_swap_service.Dynamic of_leftbuttondown(idw_data, xpos, ypos)
		If IsValid(in_rowsmove_service) Then in_rowsmove_service.Dynamic of_leftbuttondown(idw_data, xpos, ypos)
		If IsValid(in_sort_service) Then in_sort_service.Dynamic of_lbuttondown(flags, xpos, ypos)

	Case 'pbm_lbuttonup'
		ib_We_Are_Drag_Scrolling = false
		If IsValid(in_column_sizing_service) Then 
			lb_event_is_begin_used = in_column_sizing_service.Dynamic of_lbuttonup(idw_data.Dynamic PointerX(), idw_data.Dynamic PointerY())
		End If

		If IsValid(in_group_by_service) And Not lb_event_is_begin_used Then
			lb_event_is_begin_used = in_group_by_service.Dynamic of_leftbuttonup(xpos, ypos)
		End If

		If IsValid(in_show_fields) And Not lb_event_is_begin_used Then 
			lb_event_is_begin_used = in_show_fields.Dynamic of_lbuttonup(flags, xpos, ypos)
		End If

		if IsValid(in_sort_service) And Not lb_event_is_begin_used then in_sort_service.Dynamic of_clicked()
		If IsValid(in_swap_service) Then in_swap_service.Dynamic of_leftbuttonup(idw_data, xpos, ypos)	
		If IsValid(in_rowsmove_service) Then in_rowsmove_service.Dynamic of_leftbuttonup(idw_data, xpos, ypos)		
END CHOOSE

SetNull(ll_null)
Return ll_null
end function

public subroutine of_init (ref powerobject adw_datawindow);idw_data = adw_datawindow

end subroutine

public subroutine of_add_service (string as_servicename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_service()
//	Arguments:  as_servicename - The name of the object
//	Overview:   This will add the service to the array
//	Created by:	Joel White
//	History: 	2/23/05 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// If we still have services in the default list, we need to just add it to the list
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(is_default_list_of_services) > 0 Then
	is_default_list_of_services = is_default_list_of_services + ',' + Trim(as_servicename)
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the service is not already in the array
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_service_name[])
	If Lower(Trim(is_service_name[ll_index])) = Lower(Trim(as_servicename)) Then Return 
Next

is_service_name	[UpperBound(is_service_name) 		+ 1] = as_servicename

If ib_objects_have_been_created = True Then This.of_create_services()
end subroutine

public subroutine of_set_batchmode (boolean ab_runninginbatch);Long	ll_index

ib_RunningInBatchMode = ab_runninginbatch

If Not ab_runninginbatch Then Return

For ll_index = 1 To UpperBound(in_services[])
	If Not IsValid(in_services[ll_index]) Then Continue
	Choose Case Lower(Trim(ClassName(in_services[ll_index])))
		Case 'n_dao_dataobjectstate', 'n_datawindow_conversion_service', 'n_show_fields', 'n_column_sizing_service'
			in_services[ll_index].Dynamic of_set_batchmode(ab_runninginbatch)
	End Choose
	
	Choose Case Lower(Trim(ClassName(in_services[ll_index])))
		Case 'n_sort_service', 'n_group_by_service', 'n_navigation_options', 'n_datawindow_formatting_service', 'n_datawindow_treeview_service', 'n_pivot_table_service', 'n_aggregation_service'
			in_services[ll_index].Dynamic of_set_batch_mode(ab_runninginbatch)
	End Choose
Next
end subroutine

public function long of_redirect_event (string as_eventname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					row				- The row number
//					dwo				- The datawindow object
//					data				- The string data in the column
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_null
Long	ll_return

CHOOSE CASE Lower(Trim(as_eventname))
	CASE 'retrievestart'
		If IsValid(in_datawindow_treeview_service) Then in_datawindow_treeview_service.Dynamic of_retrievestart()
		
		if IsValid(in_dao_service) Then
			ll_return = in_dao_service.Dynamic of_retrievestart()
			if ll_return <> 0 then RETURN ll_return
		end if
		
		If IsValid(in_dropdowndatawindow_caching_service) Then in_dropdowndatawindow_caching_service.Dynamic of_retrievestart()
		If IsValid(in_rows_discard_service) Then in_rows_discard_service.Dynamic of_retrievestart()
		if IsValid(in_navigation_options) Then
			ll_return = in_navigation_options.Dynamic of_retrievestart()
			If Not IsNull(ll_return) Then Return ll_return
		end if
	Case 'constructor'
	Case 'destructor'
	Case 'ue_refreshtheme'
		If IsValid(in_swap_service) Then in_swap_service.Dynamic Event ue_refreshtheme(idw_data)
		If IsValid (in_rowsmove_service) Then in_rowsmove_service.Dynamic Event ue_refreshtheme()
		If IsValid(iu_filter_strip) Then iu_filter_strip.Dynamic Event ue_refreshtheme()
		If IsValid(in_rowfocus_service) Then in_rowfocus_service.Dynamic Event ue_refreshtheme()
	Case 'ue_dropdown'
		If IsValid(in_multi_select_dddw_service) Then 
			ll_return = in_multi_select_dddw_service.Dynamic of_dropdown()
			Return ll_return
		End If

END CHOOSE

SetNull(ll_null)
Return ll_null
end function

public function long of_redirect_event (string as_eventname, keycode key, unsignedlong keyflags);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					row				- The row number
//					dwo				- The datawindow object
//					data				- The string data in the column
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_null

CHOOSE CASE Lower(Trim(as_eventname))
	CASE 'pbm_dwnkey'
		If isvalid(in_autofill_service) then in_autofill_service.Dynamic of_dwnkey()
		If isvalid(in_keydates_service) then in_keydates_service.Dynamic of_dwnkey()
END CHOOSE

SetNull(ll_null)
Return ll_null
end function

public function long of_redirect_event (string as_eventname, long row, ref dwobject dwo, string data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					row				- The row number
//					dwo				- The datawindow object
//					data				- The string data in the column
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_null

CHOOSE CASE Lower(Trim(as_eventname))
	CASE 'itemchanged'
		//----------------------------------------------------------------------------------------------------------------------------------
		// Trigger the autofill object
		//-----------------------------------------------------------------------------------------------------------------------------------
		if isvalid(in_autofill_service) then
			if not in_autofill_service.Dynamic of_itemchanged() then return 2
		end if
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// reject invalid values
		//-----------------------------------------------------------------------------------------------------------------------------------
		if isvalid(in_reject_invalids) then
			if not in_reject_invalids.Dynamic of_itemchanged() then return 2
		end if

		//----------------------------------------------------------------------------------------------------------------------------------
		// Push the change to the Multi-Select Buffer
		//-----------------------------------------------------------------------------------------------------------------------------------
		if isvalid(in_multi_select_dddw_service) then
			if not in_multi_select_dddw_service.Dynamic of_itemchanged(row, dwo, data) then return 2
		end if

		//----------------------------------------------------------------------------------------------------------------------------------
		// Notify the update service
		//-----------------------------------------------------------------------------------------------------------------------------------
		if isvalid(in_dao_service) then
			//-----------------------------------------------------------------------------------------------------------------------------------
			// BEGIN MODIFIED HMD 11/13/2000
			// If the dao service's of_itemchanged returned a 1 or 2, they were getting lost
			// and null was being returned instead
			// Changed the logic to return the 1 or 2 if itemchanged is rejecting the value
			//-----------------------------------------------------------------------------------------------------------------------------------
			//in_dao_service.of_itemchanged(row, dwo, data)
			Choose Case in_dao_service.Dynamic of_itemchanged(row, dwo, data)
				Case 1
					Return 1
				Case 2
					Return 2
			End Choose
			//-----------------------------------------------------------------------------------------------------------------------------------
			// END MODIFIED HMD 11/13/2000
			//-----------------------------------------------------------------------------------------------------------------------------------
			
		end if
		
//		If IsValid(in_datawindow_conversion_service) Then
//			If Not in_datawindow_conversion_service.Dynamic of_itemchanged(row, dwo, data) then return 2
//		End If
CASE 'editchanged'
		//----------------------------------------------------------------------------------------------------------------------------------
		// Trigger the autofill object when users are typeing in an editable dddw
		//-----------------------------------------------------------------------------------------------------------------------------------
		If isvalid(in_autofill_service) Then
			in_autofill_service.Dynamic POST of_autofill(data)
		End If		
END CHOOSE

SetNull(ll_null)
Return ll_null
end function

public function long of_redirect_event (string as_eventname, long scrollpos, long pane);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					row				- The row number
//					dwo				- The datawindow object
//					data				- The string data in the column
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_null

CHOOSE CASE Lower(Trim(as_eventname))
	CASE 'scrollhorizontal'
		if IsValid(iu_filter_strip) then iu_filter_strip.Dynamic of_reposition()
END CHOOSE

SetNull(ll_null)
Return ll_null
end function

public function long of_redirect_event (string as_eventname, ref dragobject source);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					flags				- stuff
//					xpos				- The x position
//					ypos				- The y position
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Case based on the event name
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE Lower(Trim(as_eventname))
	Case 'dragleave'
		ib_We_Are_Drag_Scrolling = false
		If IsValid(in_navigation_options) Then in_navigation_options.Dynamic of_dragleave(source)

	Case 'dragenter'
END CHOOSE

SetNull(ll_null)
Return ll_null
end function

public function long of_redirect_event (string as_eventname, long rowcount);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					rowcount, row				- The row number or the rowcount
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_null
Datawindow	ldw_datawindow

CHOOSE CASE Lower(Trim(as_eventname))
	CASE 'retrieveend'
		If IsValid(in_datawindow_conversion_service) Then in_datawindow_conversion_service.Dynamic of_retrieveend(rowcount)
		If IsValid(in_sort_service) Then in_sort_service.Dynamic of_retrieveend(rowcount)
		If IsValid(in_rowfocus_service) Then in_rowfocus_service.Dynamic of_retrieveend()
		If IsValid(iu_filter_strip) Then iu_filter_strip.Dynamic of_retrieveend()
		If IsValid(in_datawindow_treeview_service) Then in_datawindow_treeview_service.Dynamic of_retrieveend(rowcount)
		If IsValid(in_dropdowndatawindow_caching_service) Then in_dropdowndatawindow_caching_service.Dynamic of_retrieveend(rowcount)
		If IsValid(in_navigation_options) Then in_navigation_options.Dynamic of_retrieveend(rowcount)
		//IF IsValid(in_multi_select_dddw_service) then in_multi_select_dddw_service.Dynamic of_retrieveend()
	Case 'rowfocuschanged'
		If IsValid(in_rowfocus_service) Then in_rowfocus_service.Dynamic of_rowfocuschanged(rowcount)
		If IsValid(in_navigation_options) Then in_navigation_options.Dynamic of_rowfocuschanged(rowcount)
	Case 'beforeinsertrow'
		If IsValid(in_dropdowndatawindow_caching_service) Then in_dropdowndatawindow_caching_service.Dynamic of_beforeinsertrow()
	Case 'afterinsertrow'
		If IsValid(in_dropdowndatawindow_caching_service) Then in_dropdowndatawindow_caching_service.Dynamic of_afterinsertrow()
	Case 'printstart'
		If IsValid(in_rowfocus_service) Then in_rowfocus_service.Dynamic of_printstart(rowcount)
	Case 'printend'
		If IsValid(in_rowfocus_service) Then in_rowfocus_service.Dynamic of_printend(rowcount)
END CHOOSE

SetNull(ll_null)
Return ll_null
end function

public function long of_redirect_event (string as_eventname, long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					xpos				- The x position
//					ypos				- The y position
//					row				- The row argument
//					dwo				- The datawindow (not control) object
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Case statement based on event name
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE Lower(Trim(as_eventname))
	Case 'pbm_dwnmousemove'
		ib_We_Are_Drag_Scrolling = false
		If IsValid(in_rowfocus_service) 		Then in_rowfocus_service.Dynamic of_mousemove(xpos, ypos, row, dwo)
		If IsValid(in_rowsmove_service) 		Then in_rowsmove_service.Dynamic of_mousemove(idw_data, row, dwo)	
		If IsValid(in_swap_service) 			Then in_swap_service.Dynamic of_mousemove(idw_data, row, dwo)	
		If IsValid(in_datawindow_tooltp_display_column_text) 			Then in_datawindow_tooltp_display_column_text.Dynamic of_mousemove( xpos,ypos,row, dwo)	

	Case 'doubleclicked'
		If IsValid(in_column_sizing_service) And IsValid(dwo) Then in_column_sizing_service.Dynamic of_doubleclicked(dwo.Name, idw_data.Dynamic PointerX())
		If IsValid(in_group_by_service) Then in_group_by_service.Dynamic of_doubleclicked(xpos, ypos, row, dwo)

		//-----------------------------------------------------------------------------------------------------------------------------------
		// If you doubleclick it will trigger the open message for that entity.  Suppress this if the treeview service is alive.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(in_navigation_options) And Not IsValid(in_datawindow_treeview_service) Then in_navigation_options.Dynamic of_doubleclicked(xpos, ypos, row, dwo)
		If IsValid(in_datawindow_treeview_service) Then in_datawindow_treeview_service.Dynamic of_doubleclicked(xpos, ypos, row, dwo)
		If IsValid(in_pivot_table_service) Then in_pivot_table_service.Dynamic of_doubleclicked(xpos, ypos, row, dwo)
End Choose

SetNull(ll_null)
Return ll_null
end function

public function long of_redirect_event (string as_eventname, ref dragobject source, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					flags				- stuff
//					xpos				- The x position
//					ypos				- The y position
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_null
PowerObject lpo_temp
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Case statement based on events
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE Lower(Trim(as_eventname))
	Case 'dragdrop', 'drag drop'
		ib_We_Are_Drag_Scrolling = false
		If source = idw_data Then Return ll_null
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Pass dragdrop to the navigation options object so it can do dragdrop navigation
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(in_navigation_options) Then in_navigation_options.Dynamic of_dragdrop(source, row, dwo)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the object that is dropped onto the datawindow into a local variable
		//-----------------------------------------------------------------------------------------------------------------------------------
		lpo_temp = Message.PowerObjectParm

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Notify the parent that something has been dragdropped onto the datawindow and it will handle it
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(lpo_temp) Then idw_data.Dynamic Event ue_notify('dragdrop', lpo_temp)

		//-----------------------------------------------------------------------------------------------------------------------------------
		// End the dragdrop event and set the object to null on the message object.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If idw_data.TypeOf() = Datawindow! Then
			idw_data.Dynamic Drag(end!)
		End If
		SetNull(Message.PowerObjectParm)
		
	Case 'dragwithin'
		/*
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If source is a valid datawindow then turn drag-scrolling on (and create/set the timer, if it's not been done)
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(source) then
			if typeof(source) = Datawindow! then
				if not IsValid(in_drag_scroll_timer) then
					ipo_drag_scroll_source = source
					in_drag_scroll_timer = create n_timer
					in_drag_scroll_timer.dynamic of_set_event(this, "ue_drag_scroll")
				end if
				ib_We_Are_Drag_Scrolling = true

		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the pointer is within the header/footer & not on first/last row, start the timer & give a direction
		//-----------------------------------------------------------------------------------------------------------------------------------
				
				if (source.pointery() < long(source.dynamic describe("datawindow.header.height"))) and &
					(long(source.dynamic describe("datawindow.firstrowonpage")) > 1) then
					ib_Drag_Scroll_Direction_Up = true
					in_drag_scroll_timer.dynamic of_start(.05)
				elseif ((source.pointery() > (source.height - long(source.dynamic describe("datawindow.footer.height")) - 80 )) and &
					(long(source.dynamic describe("datawindow.lastrowonpage")) < source.dynamic rowcount())) then
					ib_Drag_Scroll_Direction_Up = false
					in_drag_scroll_timer.dynamic of_start(.05)

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Otherwise turn drag-scrolling off & stop the timer
		//-----------------------------------------------------------------------------------------------------------------------------------

				else
					ib_We_Are_Drag_Scrolling = false
					in_drag_scroll_timer.dynamic of_stop()
				end if
			end if
		end if
		*/
END CHOOSE

Return ll_null
end function

public subroutine of_add_component (ref powerobject au_component, string as_component_type);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_component()
//	Arguments:  au_component - The pointer to the component
//					as_component_type - The name of the component.  This is necessary because ClassName will be whatever you named it
//												when you dropped in on the object that contains it.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	2/23/05 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the component is not already added.
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_component_name)
	If Lower(Trim(is_component_name[ll_index])) = Lower(Trim(as_component_type)) Then Return 
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the component and component type to the arrays.
//-----------------------------------------------------------------------------------------------------------------------------------
is_component_name	[UpperBound(is_component_name) 		+ 1] = as_component_type
ipo_components		[UpperBound(ipo_components) 			+ 1] = au_component

//-----------------------------------------------------------------------------------------------------------------------------------
// Initialize the component.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_component_type))
	Case 'u_filter_strip'
		If IsValid(au_component) Then
			iu_filter_strip = au_component
			
			iu_filter_strip.Dynamic of_init(idw_data)
			iu_filter_strip.Dynamic of_show()
		End If
		
	Case	'n_swap_service'
		If IsValid(au_component) Then
			in_swap_service = au_component
		End If

	Case	'n_rowsmove_service'
		If IsValid(au_component) Then
			in_rowsmove_service = au_component
		End If
End Choose

end subroutine

public subroutine of_get_menu_xml (string as_type, ref n_menu_dynamic an_menu_dynamic);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_type 	- The type of menu to generate {Column, Row, Report}
//	Overview:   This will generate a menu that will work nonvisually, meaning that all services will only expression actions that don't need a gui
//	Created by:	Blake Doerr
//	History: 	10/6/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_object
n_menu_dynamic ln_menu_dynamic
ln_menu_dynamic = an_menu_dynamic

Choose Case Lower(Trim(as_type))
	Case 'column'
		ls_object = '@@Column'
		If IsValid(in_sort_service) 								Then in_sort_service.Dynamic 								of_build_menu(ln_menu_dynamic, ls_object, True, True)
		If IsValid(in_column_sizing_service) 					Then in_column_sizing_service.Dynamic 					of_build_menu(ln_menu_dynamic, ls_object, True, True)
		If IsValid(in_show_fields)									Then in_show_fields.Dynamic 								of_build_menu(ln_menu_dynamic, ls_object, True, True)
		If IsValid(in_group_by_service) 							Then in_group_by_service.Dynamic 						of_build_menu(ln_menu_dynamic, ls_object, True, True)
		If IsValid(in_aggregation_service)						Then in_aggregation_service.Dynamic						of_build_menu(ln_menu_dynamic, ls_object, True, True)
		
	Case 'report'
		ls_object = '@@Report'
		If IsValid(in_dropdowndatawindow_caching_service)	Then in_dropdowndatawindow_caching_service.Dynamic	of_build_menu(ln_menu_dynamic, ls_object, False, False)
		If IsValid(in_dao_dataobject_state)						Then in_dao_dataobject_state.Dynamic 					of_build_menu(ln_menu_dynamic, ls_object, False, False)

	Case 'row'
		ls_object = '@@Row'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// This will come later when we enable navigation
		//-----------------------------------------------------------------------------------------------------------------------------------
		//If IsValid(in_navigation_options) Then
		//	in_navigation_options.Dynamic of_build_menu(an_menu_dynamic, ls_object, True, True)
		//End If

		If UpperBound(an_menu_dynamic.Item[]) > 0 And Not an_menu_dynamic.of_isappending('report options') Then
			an_menu_dynamic.of_add_item("-", '', '')
			ln_menu_dynamic = an_menu_dynamic.of_add_item("Report Options", '', '')
		Else
			ln_menu_dynamic = an_menu_dynamic
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Let each service add its own menu items
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(in_datawindow_treeview_service) 			Then in_datawindow_treeview_service.Dynamic			of_build_menu(ln_menu_dynamic, ls_object, True, True)
If IsValid(in_datawindow_formatting_service)			Then in_datawindow_formatting_service.Dynamic		of_build_menu(ln_menu_dynamic, ls_object, ls_object, True, True)
If IsValid(in_pivot_table_service)						Then in_pivot_table_service.Dynamic						of_build_menu(ln_menu_dynamic, ls_object, True, True)
end subroutine

public function nonvisualobject of_create_object (string as_objectname, ref nonvisualobject an_object);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_create_object()
//	Arguments:  as_objectname - The name of the object
//					an_object - The pointer to the object
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	2/28/05 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
NonVisualObject ln_service
Long ll_index


//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy it if it already exists
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(an_object) And Not IsNull(an_object) Then This.of_destroy_service(as_objectname)

//-----------------------------------------------------------------------------------------------------------------------------------
// Based on the name of the service, create it and initialize it
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case as_objectname
	Case 'n_rowfocus_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_rowfocus_service = Create Using 'n_rowfocus_service'
		Else
			in_rowfocus_service = an_object
		End If

		ln_service = in_rowfocus_service
		in_rowfocus_service.Dynamic of_init(idw_data)

	Case 'n_column_sizing_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_column_sizing_service = Create Using 'n_column_sizing_service'
		Else
			in_column_sizing_service = an_object
		End If
		
		in_column_sizing_service.Dynamic of_set_batchmode(ib_RunningInBatchMode)
		in_column_sizing_service.Dynamic of_init(idw_data)
		ln_service = in_column_sizing_service
		
	Case 'n_sort_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_sort_service = Create Using 'n_sort_service'
		Else
			in_sort_service = an_object
		End If
		
		in_sort_service.Dynamic of_set_batch_mode(ib_RunningInBatchMode)
		in_sort_service.Dynamic of_init(idw_data, 'srt', "multi")
		ln_service = in_sort_service

	Case 'n_dao_dataobject_state'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_dao_dataobject_state = Create Using 'n_dao_dataobject_state'
		Else
			in_dao_dataobject_state = an_object
		End If
		
		If ib_RunningInBatchMode Then in_dao_dataobject_state.Dynamic of_set_batchmode(ib_RunningInBatchMode)
		in_dao_dataobject_state.Dynamic of_setTransactionObject(SQLCA)
		in_dao_dataobject_state.Dynamic of_init(idw_data, gn_globals.il_userid)
		ln_service = in_dao_dataobject_state
		
	Case 'n_group_by_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_group_by_service = Create Using 'n_group_by_service'
		Else
			in_group_by_service = an_object
		End If
		
		in_group_by_service.Dynamic of_set_batch_mode(ib_RunningInBatchMode)
		in_group_by_service.Dynamic of_init(idw_data)
		ln_service = in_group_by_service

	Case 'n_navigation_options'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_navigation_options = Create Using 'n_navigation_options'
		Else
			in_navigation_options = an_object
		End If
		
		in_navigation_options.Dynamic of_set_batch_mode(ib_RunningInBatchMode)
		in_navigation_options.Dynamic of_init(idw_data)
		ln_service = in_navigation_options
		
	
	Case 'n_datawindow_formatting_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_datawindow_formatting_service = Create Using 'n_datawindow_formatting_service'
		Else
			in_datawindow_formatting_service = an_object
		End If
		
		in_datawindow_formatting_service.Dynamic of_set_batch_mode(ib_RunningInBatchMode)
		in_datawindow_formatting_service.Dynamic of_init(idw_data)
		ln_service = in_datawindow_formatting_service
		
	Case 'n_datawindow_treeview_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_datawindow_treeview_service = Create Using 'n_datawindow_treeview_service'
		Else
			in_datawindow_treeview_service = an_object
		End If
		
		in_datawindow_treeview_service.Dynamic of_set_batch_mode(ib_RunningInBatchMode)
		in_datawindow_treeview_service.Dynamic of_init(idw_data)
		ln_service = in_datawindow_treeview_service
		
	Case	'n_show_fields'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_show_fields = Create Using 'n_show_fields'
		Else
			in_show_fields = an_object
		End If
		in_show_fields.Dynamic of_set_batchmode(ib_RunningInBatchMode)
		in_show_fields.Dynamic of_init(idw_data)
		ln_service = in_show_fields
	Case 'n_pivot_table_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_pivot_table_service = Create Using 'n_pivot_table_service'
		Else
			in_pivot_table_service = an_object
		End If

		in_pivot_table_service.Dynamic of_set_batch_mode(ib_RunningInBatchMode)
		ln_service = in_pivot_table_service
		
	Case 'n_aggregation_service'
		If Not IsValid(an_object) or IsNull(an_object) Then
			in_aggregation_service = Create Using 'n_aggregation_service'
		Else
			in_aggregation_service = an_object
		end if
		
		in_aggregation_service.Dynamic of_set_batch_mode(ib_RunningInBatchMode)
		in_aggregation_service.Dynamic of_init(idw_data)
		ln_service = in_aggregation_service
		
	Case 'n_dropdowndatawindow_caching_service'
		if Not IsValid(an_object) or IsNull(an_object) then
			in_dropdowndatawindow_caching_service = Create Using 'n_dropdowndatawindow_caching_service'
		else
			in_dropdowndatawindow_caching_service = an_object
		end if
		
		in_dropdowndatawindow_caching_service.Dynamic of_init(idw_data)
		ln_service = in_dropdowndatawindow_caching_service

		
	Case	'n_rows_discard_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_rows_discard_service = Create Using 'n_rows_discard_service'
		Else
			in_rows_discard_service = an_object
		End If
		
		in_rows_discard_service.Dynamic of_init(idw_data)
		ln_service = in_rows_discard_service
		
	Case	'n_datawindow_conversion_service'
		If Not IsValid(an_object) Or IsNull(an_object) Then
			in_datawindow_conversion_service = Create Using 'n_datawindow_conversion_service'
		Else
			in_datawindow_conversion_service = an_object
		End If
		
		in_datawindow_conversion_service.Dynamic of_set_batchmode(ib_RunningInBatchMode)
		in_datawindow_conversion_service.Dynamic of_init(idw_data)
		ln_service = in_datawindow_conversion_service
	Case Else
		If idw_data.TypeOf() = Datawindow! Then
			Choose Case as_objectname
				Case 'n_autofill'
					If Not IsValid(an_object) Or IsNull(an_object) Then
						in_autofill_service = create Using 'n_autofill'
					Else
						in_autofill_service = an_object
					End If
					
					in_autofill_service.Dynamic of_init(idw_data)
					ln_service = in_autofill_service
					
				Case 'n_keydown_date_defaults'
					If Not IsValid(an_object) Or IsNull(an_object) Then
						in_keydates_service = create Using 'n_keydown_date_defaults'
					Else
						in_keydates_service = an_object
					End If
					
					in_keydates_service.Dynamic of_init(idw_data)
					ln_service = in_keydates_service
					
				Case 'n_calendar_column_service'
					If Not IsValid(an_object) Or IsNull(an_object) Then
						in_calendar_column_service = Create Using 'n_calendar_column_service'
					Else
						in_calendar_column_service = an_object
					End If
					
					in_calendar_column_service.Dynamic of_init(idw_data)
					ln_service = in_calendar_column_service
					
				Case 'n_reject_invalids'
					If Not IsValid(an_object) Or IsNull(an_object) Then
						in_reject_invalids = Create Using 'n_reject_invalids'
					Else
						in_reject_invalids = an_object
					End If
					
					in_reject_invalids.Dynamic of_init(idw_data)
					ln_service = in_reject_invalids
			
				Case 'n_dao_service'
					if Not IsValid(an_object) or IsNull(an_object) then
						in_dao_service = Create Using 'n_dao_service'
					else
						in_dao_service = an_object
					end if
					
					in_dao_service.Dynamic of_init(idw_data)
					ln_service = in_dao_service
			
				Case 'n_multi_select_dddw_service'
					If Not IsValid(an_object) Or IsNull(an_object) Then
						in_multi_select_dddw_service = Create Using 'n_multi_select_dddw_service'
					Else
						in_multi_select_dddw_service = an_object
					End If
					
					in_multi_select_dddw_service.Dynamic of_init(idw_data)
					ln_service = in_multi_select_dddw_service
					
				Case 'n_datawindow_tooltp_display_column_text'
					If Not IsValid(an_object) Or IsNull(an_object) Then
						in_datawindow_tooltp_display_column_text = Create Using 'n_datawindow_tooltp_display_column_text'
					Else
						in_datawindow_tooltp_display_column_text = an_object
					End If
					
					in_datawindow_tooltp_display_column_text.Dynamic Post of_init(idw_data)
					ln_service = in_datawindow_tooltp_display_column_text

					
				Case Else
					Return ln_service
			End Choose
		End If
End Choose
//-----------------------------------------------------------------------------------------------------------------------------------
// Add the service to the array
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_service_name[])
	If Lower(Trim(as_objectname)) = Lower(Trim(is_service_name[ll_index])) Then
		in_services[ll_index] = ln_service
		Return ln_service
	End If
Next

is_service_name[UpperBound(is_service_name[]) + 1] = as_objectname
in_services[UpperBound(is_service_name[])] 			= ln_service

Return ln_service
end function

public function long of_redirect_event (string as_eventname, long xpos, long ypos, long row, ref dwobject dwo, ref n_menu_dynamic an_menu_dynamic);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_redirect_event()
//	Arguments:  as_eventname 	- The name of the event
//					xpos				- The x position
//					ypos				- The y position
//					row				- The row argument
//					dwo				- The datawindow (not control) object
//	Overview:   This will redirect this event to the services that want to know
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_IsComputedField 	= False
Boolean	lb_IsColumn 			= False
Long 		ll_xposition
Long		ll_objecty
Long		ll_yposition
Long 		ll_null
Long		l_item
Long		l_items
String	ls_columnname
String	ls_ObjectAtPointer
String	ls_BandAtPointer
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_menu_dynamic			ln_menu_dynamic
n_datawindow_tools 	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Case statement based on event name
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE Lower(Trim(as_eventname))
	CASE 'clicked'
		If IsValid(in_rowfocus_service) Then in_rowfocus_service.Dynamic of_clicked(row)
		If IsValid(in_group_by_service) Then in_group_by_service.Dynamic of_clicked(xpos, ypos, row, dwo)
		If IsValid(in_navigation_options) Then in_navigation_options.Dynamic of_clicked(xpos, ypos, row, dwo)
		If IsValid(in_calendar_column_service) Then in_calendar_column_service.Dynamic of_clicked()
		If IsValid(in_datawindow_treeview_service) Then in_datawindow_treeview_service.Dynamic of_clicked(xpos, ypos, row, dwo)

Case 'rbuttondown'
		ib_We_Are_Drag_Scrolling = false
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Pass the event to the all services that care
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(in_rowfocus_service) 					Then	in_rowfocus_service.Dynamic of_rbuttondown(row)
		If IsValid(in_pivot_table_service) 				Then 	in_pivot_table_service.Dynamic of_rbuttondown(xpos, ypos, row, dwo)
		If IsValid(in_navigation_options) 				Then	in_navigation_options.Dynamic of_rbuttondown(xpos, ypos, row, dwo)

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Return if there aren't any services
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(in_services[]) = 0 Then Return ll_null
		If Not IsValid(an_menu_dynamic) Then Return ll_null
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Pass the event on to the various services if we are not on a valid row.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_ObjectAtPointer 	= idw_data.Dynamic GetObjectAtPointer()
		ls_ObjectAtPointer 	= Lower(Left(ls_ObjectAtPointer, Pos(ls_ObjectAtPointer, '~t') - 1))
		ls_BandAtPointer		= idw_data.Dynamic GetBandAtPointer()
		ls_BandAtPointer		= Lower(Left(ls_BandAtPointer, Pos(ls_BandAtPointer, '~t') - 1))
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If this is the sort header, make it the column
		//-----------------------------------------------------------------------------------------------------------------------------------
		if Right(ls_ObjectAtPointer,14) = '_direction_srt' then ls_ObjectAtPointer = left(ls_ObjectAtPointer, Len(ls_ObjectAtPointer) - 14)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the column name from datawindow tools
		//-----------------------------------------------------------------------------------------------------------------------------------
		ln_datawindow_tools = Create n_datawindow_tools
		
		lb_IsColumn 			= ln_datawindow_tools.of_IsColumn(idw_data, ls_ObjectAtPointer)
		lb_IsComputedField	= ln_datawindow_tools.of_IsComputedField(idw_data, ls_ObjectAtPointer)
		
		If Not lb_IsColumn Then 
			ls_columnname = ln_datawindow_tools.of_get_column(idw_data, ls_ObjectAtPointer)
		Else
			ls_columnname = ls_ObjectAtPointer
		End If
		
		If Not IsNull(ls_columnname) Then
			lb_IsColumn 			= ln_datawindow_tools.of_IsColumn(idw_data, ls_columnname)
			lb_IsComputedField	= ln_datawindow_tools.of_IsComputedField(idw_data, ls_columnname)
		ElseIf lb_IsComputedField And Lower(Trim(Left(ls_BandAtPointer, Len('header')))) <> 'header' Then
			ls_columnname = ls_ObjectAtPointer
		Else
			lb_IsComputedField = False
		End If
		
		Destroy ln_datawindow_tools
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// 
		//-----------------------------------------------------------------------------------------------------------------------------------
		If (row > 0 And Not IsNull(row) and Row <= idw_data.Dynamic RowCount()) Or (idw_data.Dynamic RowCount() = 0 And Lower(Trim(ls_BandAtPointer)) <> 'header' And Lower(Trim(ls_BandAtPointer)) <> 'footer') Then
			If IsValid(in_navigation_options) Then
				in_navigation_options.Dynamic of_build_menu(an_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
			End If
		End If
		
		If UpperBound(an_menu_dynamic.Item[]) > 0 And Not an_menu_dynamic.of_isappending('report options') Then
			an_menu_dynamic.of_add_item("-", '', '')
			ln_menu_dynamic = an_menu_dynamic.of_add_item("Report Options", '', '')
		Else
			ln_menu_dynamic = an_menu_dynamic
		End If
		
		If (lb_IsColumn Or lb_IsComputedField) And row > 0 And Not IsNull(row) And row <= idw_data.Dynamic RowCount() Then
			ln_menu_dynamic.of_add_item('&Copy Field', 'copy field', ls_columnname, This)
		End If
		
		If (lb_IsColumn Or lb_IsComputedField) Then
			ln_menu_dynamic.of_add_item('&Copy Column', 'copy column', ls_columnname, This)
		End If
		
		ln_menu_dynamic.of_add_item('&Copy Report (Can Paste in Excel)', 'copy report', '', This)
		
		//Added JDW 9.19.03 RAID #26163
//		If (lb_IsColumn Or lb_IsComputedField) and IsValid(dwo) Then
//			If dwo.Type = 'column' Then
//				string ls_length
//				ls_length = idw_data.Dynamic Describe(ls_columnname + '.Coltype')
//				If left(ls_length, 4) = 'char' Then 
//					ls_length =  Mid(ls_length, Pos(ls_length, '(' ) + 1)
//					If Long(Left(ls_length, Len(ls_length) - 1)) > 100 Then
//						ln_menu_dynamic.of_add_item('&View All Text...', 'view text', ls_columnname, This)
//					End If
//				End If
//			End If
//		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Let each service add its own menu items
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(in_datawindow_treeview_service) 			Then in_datawindow_treeview_service.Dynamic			of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_rows_discard_service)						Then in_rows_discard_service.Dynamic					of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField, row)
		If IsValid(in_datawindow_formatting_service)			Then in_datawindow_formatting_service.Dynamic		of_build_menu(ln_menu_dynamic, ls_ObjectAtPointer, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_sort_service) 								Then in_sort_service.Dynamic 								of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_column_sizing_service) 					Then in_column_sizing_service.Dynamic 					of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_show_fields)									Then in_show_fields.Dynamic 								of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_group_by_service) 							Then in_group_by_service.Dynamic 						of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_dao_dataobject_state)						Then in_dao_dataobject_state.Dynamic 					of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_dropdowndatawindow_caching_service)	Then in_dropdowndatawindow_caching_service.Dynamic	of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_aggregation_service)						Then in_aggregation_service.Dynamic						of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_pivot_table_service)						Then in_pivot_table_service.Dynamic						of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
		If IsValid(in_datawindow_conversion_service)			Then in_datawindow_conversion_service.Dynamic		of_build_menu(ln_menu_dynamic, ls_columnname, lb_IsColumn, lb_IsComputedField)
END CHOOSE

Return ll_null
end function

public subroutine of_interrogate_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_interrogate_datawindow()
//	Overview:   This will pull the serviceinit off the dataobject to initialize services
//	Created by:	Blake Doerr
//	History: 	3/3/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
n_datawindow_tools ln_datawindow_tools 
String ls_services_to_include[], ls_services_to_exclude[], ls_expression, ls_override, ls_extend, ls_services_list, ls_exclude
Long ll_index, ll_loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that we know that this has been interrogated
//-----------------------------------------------------------------------------------------------------------------------------------
ib_datawindow_has_been_interrogated = True

//-----------------------------------------------------------------------------------------------------------------------------------
// if the datawindow is valid, check for services
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return
If IsNull(is_default_list_of_services) Then is_default_list_of_services = ''

ln_datawindow_tools = Create n_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Pull the expression off the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'serviceinit')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the string is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ls_expression) Or Len(ls_expression) = 0 Then
	ls_services_list = is_default_list_of_services
	ls_exclude = ''
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the include string
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_override = gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'override')
	ls_extend = gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'extend')
	ls_exclude = gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'exclude')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the list of services, we can either add to the default or override it completely
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(Trim(ls_override)) > 0 And Not IsNull(ls_override) Then
		ls_services_list = ls_override
	ElseIf Len(Trim(ls_extend)) > 0 And Not IsNull(ls_extend) Then
		ls_services_list = ls_extend + ',' + is_default_list_of_services
	Else
		ls_services_list = is_default_list_of_services
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse out the services
//-----------------------------------------------------------------------------------------------------------------------------------
is_default_list_of_services = ''
gn_globals.in_string_functions.of_parse_string(ls_services_list, ',', ls_services_to_include[])
gn_globals.in_string_functions.of_parse_string(ls_exclude, ',', ls_services_to_exclude[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the services that are there and are not to be excluded
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_services_to_include[])
	
	For ll_loop = 1 To UpperBound(ls_services_to_exclude)
		If Lower(Trim(ls_services_to_exclude[ll_loop])) = Lower(Trim(ls_services_to_include[ll_index])) Then
			ls_services_to_include[ll_index] = ''
			Exit
		End If
	Next
	
	If ls_services_to_include[ll_index] <> '' Then
		This.of_add_service(Trim(Lower(ls_services_to_include[ll_index])))
	End If
	
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the tools
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
end subroutine

on n_datawindow_graphic_service_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datawindow_graphic_service_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   This will destroy all the services
//	Created by: Joel White
//	History:    2/23/05 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy all the services
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_services[])
	If IsValid(in_services[ll_index]) Then
		Choose Case Lower(Trim(ClassName(in_services[ll_index])))
			Case 'n_pivot_table_service'
				If Not in_services[ll_index].Dynamic of_should_destroy() Then Continue
		End Choose
		
		This.of_destroy_service(in_services[ll_index].ClassName())		
	End If
Next
end event

