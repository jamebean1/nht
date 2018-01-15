$PBExportHeader$u_matched_records.sru
$PBExportComments$This is the base search/reporting architecture display object.  It contains a datawindow and a title bar.  All SmartSearches are inherited from this object.
forward
global type u_matched_records from u_dynamic_gui
end type
type dw_matched_records from u_dw_gui within u_matched_records
end type
type uo_titlebar from u_title_button_bar within u_matched_records
end type
type st_separator from u_theme_strip within u_matched_records
end type
end forward

global type u_matched_records from u_dynamic_gui
integer width = 2427
integer height = 604
boolean border = false
long backcolor = 80263581
long tabbackcolor = 12632256
event ue_retrieve ( )
event ue_filters ( )
event ue_customize ( )
event ue_post_initialize ( )
event type string ue_getitem ( string as_message,  any aany_argument )
event type long ue_gethelpid ( )
event type long ue_showtasks ( )
event type string ue_get_classname ( )
event ue_post_constructor ( )
dw_matched_records dw_matched_records
uo_titlebar uo_titlebar
st_separator st_separator
end type
global u_matched_records u_matched_records

type variables
//-----------------------------------------------------------------------------------------------------------------------------------
// All the Properties of the report
//-----------------------------------------------------------------------------------------------------------------------------------
Public ProtectedWrite n_report Properties

Protected:
	//-----------------------------------------------------------------------------------------------------------------------------------
	// State Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Boolean	ib_ReportHasBeenInitialized		= False
	boolean 	ib_redrawison 							= True
	Boolean	ib_MenuCoordinatesAreSpecified 	= False
	Boolean	ib_uom_conversion_is_on_this_object	= False	
	Long		il_MenuPointerX						= 0
	Long		il_MenuPointerY						= 0
	Long 		il_redraw_count 						= 0
	String	is_overlaying_report_style 		= 'tiled'
	Blob		iblob_currentstate
	String	is_dataobjectname						= ''
	Boolean	ib_statestored 						= False

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Pointers to dynamic objects
	//-----------------------------------------------------------------------------------------------------------------------------------
	DragObject							ido_resize_object
	u_dynamic_conversion_strip 	iu_report_conversion_strip
	u_slider_control_horizontal 	iu_slider_control_horizontal
	uo_report_criteria 				iu_criteria
	u_filter_strip 					iu_filter
	u_dynamic_gui 						iu_overlaying_report
	u_dynamic_gui_report_adapter	iu_dynamic_gui_report_adapter
	
	u_search_criteria					iu_MyParent
	
	String 								is_original_syntax
	
	n_column_sizing_service in_columnsizingservice_detail
	

end variables

forward prototypes
public subroutine of_delete_title_button (string as_titletext)
public function uo_report_criteria of_get_criteria ()
public function integer of_close ()
public subroutine of_enable_button (string as_buttontext, boolean ab_enabledisable)
public function u_dynamic_gui of_get_overlaying_report ()
public subroutine of_set_adapter (u_dynamic_gui_report_adapter au_dynamic_gui_report_adapter)
public subroutine of_add_button (string as_text, string as_eventname, powerobject ao_targetobject)
public function n_report of_get_properties ()
public function u_dynamic_gui_report_adapter of_get_adapter ()
public function datawindow of_get_report_dw ()
public subroutine of_set_overlaying_report (ref u_dynamic_gui au_dynamic_gui, string as_overlaying_report_style)
public subroutine of_setredraw (boolean ab_trueorfalse)
public subroutine of_settitle (string as_title)
public subroutine of_settitle (string as_title, string as_picture)
public subroutine of_set_option (string as_optionname, string as_optionvalue)
public function uo_report_criteria of_create_criteria ()
public function string of_set_document (string as_document_name)
public function uo_report_criteria of_set_criteria (string as_criteria_object)
public subroutine of_setdao (n_dao an_dao)
public function long of_retrieve (n_bag an_bag)
public function string of_distribute (string as_distributionmethod)
public function n_entity_drag_message of_get_selected_keys ()
public function long of_getselectedrow (long row)
public function transaction of_gettransactionobject ()
public subroutine of_post_retrieve ()
public subroutine of_pre_retrieve ()
public subroutine of_restore_defaults ()
public function long of_retrieve (string as_arguments)
public subroutine of_add_button (string as_text, string as_eventname)
public subroutine of_restore_state ()
public subroutine of_save_state ()
public subroutine of_set_parent (u_search_criteria uo_parent)
end prototypes

event ue_retrieve();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_retrieve
// Overrides:  No
// Overview:   This will retrieve, but first instantiate the criteria if it has not.
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_null

//Create the criteria object if it is not created
This.of_create_criteria()

//If one isvalid call the retrieve function on it.
If Not Isvalid(iu_criteria) Then Return
	
If Properties.IsBatchMode Then
	
	iu_criteria.of_restore_saved_criteria(Properties.ReportDefaultID)/**///Move to Properties
	iu_criteria.Event Dynamic ue_notify('before retrieve', '')
	iu_criteria.of_retrieve()
	iu_criteria.Event Dynamic ue_notify('after retrieve', '')
Else
	If iu_criteria.of_validate() Then
		iu_criteria.Event Dynamic ue_notify('before retrieve', '')
		iu_criteria.of_retrieve()
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Save their defaults for this particular report. We need to add logic to only save default if they want us to. This could be 
		//	annoying to the user since many report criterias have a set of default logic associated with the criteria.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsNull(Properties.RprtCnfgID) And Properties.RprtCnfgID > 0 And Properties.UseCriteriaDefaultingService Then
			iu_criteria.of_save_criteria(Properties.RprtCnfgID, Properties.UserID)
		End If
		
		iu_criteria.Event Dynamic ue_notify('after retrieve', '')
	End If
End If
end event

event ue_filters();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_filters
// Overrides:  No
// Overview:   This is run when the user clicks the filters button
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//If the filter object is valid, toggle the visible property, else create it and initialize it.
If Not IsValid(iu_filter) Then
	iu_filter = of_OpenUserObject('u_filter_strip', 10000, 10000)
	iu_filter.of_set_batch_mode(Properties.IsBatchMode)
	iu_filter.X = 1
	iu_filter.Border = False
	iu_filter.of_set_offset(0, 20)
	iu_filter.of_set_reportconfigid(Properties.RprtCnfgID)
	
	//-----------------------------------------------------
	// Add the filter object as a component to the graphic
	// service manager.  It will handle the rest.
	//-----------------------------------------------------
	dw_matched_records.of_get_service_manager().of_add_component(iu_filter, 'u_filter_strip')
Else
	iu_filter .Visible = Not iu_filter .Visible
End If

#IF defined PBDOTNET THEN
	this.EVENT resize(0, this.width, this.height)
#ELSE
	this.TriggerEvent('resize')
#END IF



end event

event ue_customize();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_customize
// Overrides:  No
// Overview:   This event is called when the user clicks the criteria button
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//If the object is created set it to visible, if it isn't create the object
If Not IsValid(iu_criteria) Then
	of_create_criteria()
	
	If IsValid(iu_criteria) Then
		iu_criteria.Visible = True
	End IF
Else
	iu_criteria.Visible = Not iu_criteria.Visible
End If

#IF defined PBDOTNET THEN
	this.EVENT resize(0, this.width, this.height)
#ELSE
	this.TriggerEvent('resize')
#END IF

end event

event ue_post_initialize();Long		ll_DtaObjctStteIdnty
Long		ll_RprtCnfgPvtTbleID
Long		ll_ReportDefaultUOMCurrencyID

//----------------------------------------------------------------------------------------------------------------------------------
// This will initialize the criteria again since we might have applied a view before certain services were created.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_criteria) Then iu_criteria.of_init(dw_matched_records)

If IsValid(dw_matched_records.of_get_service('n_navigation_options')) Then
	dw_matched_records.of_get_service('n_navigation_options').Dynamic of_set_allow_detail_reports(This, True)
End If

//----------------------------------------------------------------------------------------------------------------------------------
// This will make sure that the criteria object gets created if we need to auto retrieve or show the criteria
//-----------------------------------------------------------------------------------------------------------------------------------
If Properties.AllowCriteria And Properties.IsAutoRetrieve Then This.of_create_criteria()
If Properties.AllowCriteria And Properties.IsDefaultShowCriteria Then This.Event ue_customize()

//------------------------------------------------------------
// If we have uom conversion turned on or currency conversion
//		turned on, trigger an event, otherwise destroy the gui
//------------------------------------------------------------
If IsValid(dw_matched_records.of_get_service('n_datawindow_conversion_service')) Then
	If Not IsValid(iu_report_conversion_strip) Then
		If IsValid(iu_dynamic_gui_report_adapter) Then
			iu_report_conversion_strip = iu_dynamic_gui_report_adapter.Dynamic of_create_conversion_strip()
			ib_uom_conversion_is_on_this_object = False
		End If
	End If
		
	//-----------------------------------------------------
	// Create the conversion strip if it doesn't exist
	//-----------------------------------------------------
	If Not IsValid(iu_report_conversion_strip) Then
		iu_report_conversion_strip = This.of_OpenUserObject('u_dynamic_conversion_strip', 10000, 10000)
		iu_report_conversion_strip.X = 1
		iu_report_conversion_strip.Border = False
		ib_uom_conversion_is_on_this_object = True
	End If
		
	//----------------------------------------------------------------------------------------------------------------------------------
	// Initialize the UOM Conversion Object
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsValid(iu_report_conversion_strip) Then iu_report_conversion_strip.of_init(dw_matched_records)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Resize the object
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ib_uom_conversion_is_on_this_object Then
		Parent.TriggerEvent('resize')
	End If
Else
	If IsValid(iu_report_conversion_strip) And ib_uom_conversion_is_on_this_object Then
		This.of_closeuserobject(iu_report_conversion_strip)
	End If
End If

//---------------------------------------------------------------------------
// Manage buttons that are determined by options
//---------------------------------------------------------------------------
If Not Properties.IsBatchMode Then
	If Properties.AllowRetrieve Then 
		uo_titlebar.of_add_button('Retrieve', 'retrieve')
	Else
		uo_titlebar.of_delete_button('retrieve')
	End If
	
	If Properties.UseFilterService Then 
		uo_titlebar.of_add_button('Filters', 'filters')
	Else
		uo_titlebar.of_delete_button('filters')
	End If
	
	If Properties.AllowCriteria Then
		uo_titlebar.of_add_button('Criteria', 'criteria')
	Else
		uo_titlebar.of_delete_button('criteria')
	End If
	
	If Not Properties.AllowClosing Then
		uo_titlebar.of_delete_button('x')
	Else
		uo_titlebar.of_add_button('x', 'close')
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Set the icon and title on the u_search object
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_settitle(Properties.Name, Properties.DisplayObjectIcon)

ib_ReportHasBeenInitialized = True

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the dataobject view if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
ll_DtaObjctStteIdnty = Long(Properties.of_get('DtaObjctStteIdnty'))
If Not IsNull(ll_DtaObjctStteIdnty) And ll_DtaObjctStteIdnty > 0 Then
	gn_globals.in_subscription_service.of_message('apply view', 'DtaObjctStteIdnty=' + String(ll_DtaObjctStteIdnty), dw_matched_records)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the uom/currency view if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
ll_ReportDefaultUOMCurrencyID = Long(Properties.of_get('UOMCurrencyID'))
If Not IsNull(ll_ReportDefaultUOMCurrencyID) And ll_ReportDefaultUOMCurrencyID > 0 Then
	gn_globals.in_subscription_service.of_message('apply uom/currency view', String(ll_ReportDefaultUOMCurrencyID), dw_matched_records)
End If

Choose Case Lower(Trim(Properties.ReportDocumentType))
	Case Lower('PowerBuilder Datawindow'), Lower('DTN Notification')
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Call the autoretrieve function if it is necessary
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not Properties.ReportType = 'S' Then
			If Properties.IsAutoRetrieve Then
				If IsValid(This.of_get_criteria()) Then
					This.of_get_criteria().of_auto_retrieve()
				Else
					This.Event ue_retrieve()
				End If
			Else
				
				If IsValid(dw_matched_records.of_get_service('n_dao_dataobject_state')) Then
					dw_matched_records.of_get_service('n_dao_dataobject_state').Dynamic of_autoretrieve()
				End If
			End If
		End If
		
		//------------------------------------------------------------
		// Make sure that the filter is refreshed
		//------------------------------------------------------------
		If IsValid(iu_filter) Then
			iu_filter.of_refresh()
		End If
End Choose



//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the pivot table view if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
ll_RprtCnfgPvtTbleID = Long(Properties.of_get('RprtCnfgPvtTbleID'))
If Not IsNull(ll_RprtCnfgPvtTbleID) And ll_RprtCnfgPvtTbleID > 0 Then
	This.Event ue_notify('Auto Pivot', 'RprtCnfgPvtTbleID=' + String(ll_RprtCnfgPvtTbleID))
	//gn_globals.in_subscription_service.of_message('apply autopivot', 'RprtCnfgPvtTbleID=' + String(ll_RprtCnfgPvtTbleID), ldw_datawindow)
End If

end event

event type string ue_getitem(string as_message, any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_getitem
//	Overrides:  No
//	Arguments:	
//	Overview:   A common event to return data since ue_notify does not return a string
//	Created by: Joel White
//	History:    
//-----------------------------------------------------------------------------------------------------------------------------------

NonVisualObject ln_service

Choose Case Lower(Trim(as_message))
	Case 'text'
		If IsValid(iu_overlaying_report) And is_overlaying_report_style = 'layered' Then
			Return iu_overlaying_report.Text
		Else
			Return This.Text
		End If
	Case 'rprtcnfgpvttbleid'
		If IsValid(This.of_get_overlaying_report()) Then
			Return String(This.of_get_overlaying_report().Event Dynamic ue_getitem(as_message, aany_argument))
		Else
			ln_service = dw_matched_records.of_get_service('n_pivot_table_service')
			If IsValid(ln_service) Then
				Return String(ln_service.Dynamic of_get_current_view_id())
			End If
		End If
		
	Case 'dtaobjctstteidnty'
		ln_service = dw_matched_records.of_get_service('n_dao_dataobject_state')
		If IsValid(ln_service) Then
			Return String(ln_service.Dynamic of_get_current_view_id())
		End If
		
End Choose

Return ''
end event

event type long ue_gethelpid();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_gethelpid
//	Overrides:  No
//	Arguments:	none
//	Overview:   Return the HelpID for this report if it exists.
//	Created by: Gary Howard
//	History:    2002-06-26 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return Properties.HelpID
end event

event type long ue_showtasks();String	ls_distribution_methods[]
Long		i
Window	lw_window
/**///Move to Properties

lw_window = This.of_getparentwindow()

If Not IsValid(lw_window) Then Return -1

lw_window.Dynamic Event ue_commontasks_reset()
lw_window.Dynamic Event ue_commontasks_settarget(This)

Properties.of_retrieve_distributionmethods(ls_distribution_methods[])
For i = 1 to UpperBound(ls_distribution_methods[])
	If Lower(Trim(ls_distribution_methods[i])) = 'print' Then
		lw_window.Dynamic Event ue_commontasks_additem('<link>Print</link>Report', 'menucommand', 'print')
		Exit
	End If
Next

If UpperBound(ls_distribution_methods[]) > 0 Then
	lw_window.Dynamic Event ue_commontasks_additem('<link>Distribute</link>Report', 'menucommand', 'distribute')
End If

Choose Case Lower(Trim(Properties.ReportDocumentType))
	Case Lower('PowerBuilder Datawindow')
		lw_window.Dynamic Event ue_commontasks_additem('<link>Help</link>On This Report', 'help', '')
//		lw_window.Dynamic Event ue_commontasks_additem('<link>Manage</link>Views...', 'manage report views', '')
		If Not Properties.IsRichTextDatawindow Then
//			lw_window.Dynamic Event ue_commontasks_additem('<link>Zoom In</link>', 'menucommand', 'ZoomIn')
//			lw_window.Dynamic Event ue_commontasks_additem('<link>Zoom Out</link>', 'menucommand', 'ZoomOut')
		End If
	Case Lower('Internet Explorer Control')
		lw_window.Dynamic Event ue_commontasks_additem('<link>Refresh</link>Data', 'refresh', '')
	Case Lower('RTF Control')
		lw_window.Dynamic Event ue_commontasks_additem('<link>Refresh</link>Page', 'refresh', '')
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the close item to the desktop
//-----------------------------------------------------------------------------------------------------------------------------------
If Properties.AllowClosing Then
	lw_window.Dynamic Event ue_commontasks_additem('<link>Close</link>Report', 'menucommand', 'close')
End If

lw_window.Dynamic Event ue_commontasks_showmenu()
Return 1


end event

event type string ue_get_classname();Return 'u_search'
end event

event ue_post_constructor();uo_titlebar.of_delete_button('Customize...')
uo_titlebar.of_add_button('Restore Original View', 'restore' )

end event

public subroutine of_delete_title_button (string as_titletext);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_delete_title_button()
// Overview:   Redirect this function call to the title bar
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

uo_titlebar.of_delete_button(as_titletext)
end subroutine

public function uo_report_criteria of_get_criteria ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_criteria()
// Overview:    This will return the criteria object pointer
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

return iu_criteria
end function

public function integer of_close ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_close
// Overrides:  No
// Overview:   Publish a message that this is closing and close thyself
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
u_dynamic_gui lu_dynamic_gui 
Window lw_window
Any lany_temporary
Long ll_return

ll_return = This.Event ue_close()

If ll_return = 0 Then
	//Close thyself differently based on what the parent object is
	Choose Case io_parent.TypeOf()
		Case Window!
			lw_window = io_parent
			lany_temporary = This
	
			//----------------------------------------------------------------------------------------------------------------------------------
			// Tell the parent object that this is closing in case something needs to be done
			//-----------------------------------------------------------------------------------------------------------------------------------
			lw_window.Event Dynamic ue_notify('u_search Closing', lany_temporary)
			Return lw_window.CloseUserObject(This)
		Case Else
			lu_dynamic_gui = io_parent
			lany_temporary = This
			
			//----------------------------------------------------------------------------------------------------------------------------------
			// Tell the parent object that this is closing in case something needs to be done
			//-----------------------------------------------------------------------------------------------------------------------------------
			lu_dynamic_gui.Event ue_notify('u_search Closing', lany_temporary)
			lu_dynamic_gui.of_closeuserobject(This)
			Return ll_return
	End Choose
Else	
	Return ll_return
End If



end function

public subroutine of_enable_button (string as_buttontext, boolean ab_enabledisable);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_enable_button()
// Arguments:   as_buttontext	-	This will be the text on the button you want to delete
//						ab_enabledisable - True or False
// Overview:    This will delete a button
// Created by:  Joel WHite
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

uo_titlebar.of_enable_button(as_buttontext, ab_enabledisable)
end subroutine

public function u_dynamic_gui of_get_overlaying_report ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_overlaying_report()
//	Overview:   This will get a pointer
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return iu_overlaying_report
end function

public subroutine of_set_adapter (u_dynamic_gui_report_adapter au_dynamic_gui_report_adapter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_adapter()
//	Overview:   Sets the adapter object for the search
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

iu_dynamic_gui_report_adapter = au_dynamic_gui_report_adapter
end subroutine

public subroutine of_add_button (string as_text, string as_eventname, powerobject ao_targetobject);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_add_button()
// Overrides:  No
// Overview:   Redirect this function to the title bar.
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

uo_titlebar.of_add_button(as_text, as_eventname, ao_targetobject)
end subroutine

public function n_report of_get_properties ();Return Properties
end function

public function u_dynamic_gui_report_adapter of_get_adapter ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_adapter()
//	Overview:   Returns the adapter for the search (This may be a null object, depending on how the object was opened)
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

Return iu_dynamic_gui_report_adapter
end function

public function datawindow of_get_report_dw ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_report_dw
// Arguments:   none
// Overview:    Returns a reference to the datawindow control.
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

Return dw_matched_records
end function

public subroutine of_set_overlaying_report (ref u_dynamic_gui au_dynamic_gui, string as_overlaying_report_style);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_overlaying_report()
//	Arguments:  au_dynamic_gui - The overlaying report object
//	Overview:   This will set a pointer to the object that has been opened on it that is an overlaying search.  This
//				is used by the pivot table service and to open detail reports but could also be used by print preview functionality.
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_overlaying_report) Then
	If iu_overlaying_report <> au_dynamic_gui Then
		This.of_closeuserobject(iu_overlaying_report)
	End If
End If

iu_overlaying_report 		= au_dynamic_gui
is_overlaying_report_style	= as_overlaying_report_style

Choose Case Lower(Trim(as_overlaying_report_style))
	Case 'tiled'
	Case 'layered'
		gn_globals.in_subscription_service.of_subscribe(This, 'Object Text Changed', au_dynamic_gui)
End Choose

/*

Style:

	Tiled	- This will create a slider in between
	Layered	- This will open the report right on top of the search
*/
end subroutine

public subroutine of_setredraw (boolean ab_trueorfalse);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_setredraw()
// Arguments:   ab_trueorfalse - whether you want to turn it on or off
// Overview:    This will manage redraw so you can set it on and off in multiple levels of inheritance and it will only happen once
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------


If ab_trueorfalse = True Then
	il_redraw_count = il_redraw_count - 1
	If il_redraw_count = 0 Then 
		This.SetRedraw(True)
		dw_matched_records.SetRedraw(True)
		ib_redrawison = True
	End If
End If

If ab_trueorfalse = False Then
	If il_redraw_count = 0 Then
		This.SetRedraw(False)
		dw_matched_records.SetRedraw(False)
		ib_redrawison = False
	End If
	il_redraw_count = il_redraw_count + 1
End If

end subroutine

public subroutine of_settitle (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_settitle()
// Arguments:   as_title - the title to put in the title bar
// Overview:    This will set the text into the title bar
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------


uo_titlebar.of_settitle(as_title)
This.Text = as_title
This.Picturename = 'redarrow.bmp'

Properties.of_set('Name', as_title)

gn_globals.in_subscription_service.of_message('Object Text Changed', This, This)
end subroutine

public subroutine of_settitle (string as_title, string as_picture);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_settitle()
// Arguments:   as_title - the title to put in the title bar
// Overview:    This will set the text into the title bar
// Created by:  Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

uo_titlebar.of_settitle(as_title)

//This picture determines what shows up in the open report dropdown
This.Text = as_title
This.Picturename = as_picture
Properties.of_set('Name', as_title)

gn_globals.in_subscription_service.of_message('Object Text Changed', This, This)
end subroutine

public subroutine of_set_option (string as_optionname, string as_optionvalue);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_option()
// Arguments:   as_optionname - The name of the option that you are setting
// 				 as_optionvalue - The value that you are setting
// Overview:    This will allow you to set various options for the search
// Created by:  Joel White
// History:      
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_IsDragDropEnabled
NonVisualObject ln_service

as_optionname = Trim(as_optionname)
as_optionvalue = Trim(as_optionvalue)

Properties.of_set(as_optionname, as_optionvalue)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the report has been initialized already, we need to do extra work when options are set
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_ReportHasBeenInitialized Then
	Choose Case Lower(as_optionname)
		Case 'filtering', 'filter'
			If (Upper(as_optionvalue) <> 'Y') Then uo_titlebar.of_delete_button('filters')
		Case 'grouping', 'dynamicgrouping'
			If Upper(as_optionvalue) <> 'N' And Not Properties.IsBatchMode Then
				dw_matched_records.of_add_service('n_group_by_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_group_by_service')
			End If
		Case 'sorting', 'sorttype'
			If Upper(as_optionvalue) <> 'N' Then
				dw_matched_records.of_add_service('n_sort_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_sort_service')
			End If
		Case 'allow retrieve'
				If (Upper(as_optionvalue) = 'N') Then uo_titlebar.of_delete_button('retrieve')
		Case 'allow criteria'
			If (Upper(as_optionvalue) = 'N') Then uo_titlebar.of_delete_button('criteria')
		
			If IsValid(iu_criteria) Then
				If iu_criteria.Visible And Not Properties.AllowCriteria Then
					This.Event ue_customize()
				End If
			End If
		Case 'allow close'
			If (Upper(as_optionvalue) = 'N') Then
				uo_titlebar.of_delete_button('x')
			Else
				uo_titlebar.of_add_button('x', 'close')
			End If
		Case 'drag drop', 'dragdrop'
			ln_service = dw_matched_records.of_get_service('n_navigation_options')
			If IsValid(ln_service) Then
				lb_IsDragDropEnabled = Properties.IsDragDropEnabled
				ln_service.Dynamic of_set_dragdrop(lb_IsDragDropEnabled)
			End If
		Case 'column sizing', 'columnresizing'
			If Upper(as_optionvalue) <> 'N' Then
				dw_matched_records.of_add_service('n_column_sizing_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_column_sizing_service')
			End If
		Case 'state saving', 'viewsaving'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_matched_records.of_get_service_manager().of_add_service('n_dao_dataobject_state')
				Else
					dw_matched_records.of_get_service_manager().of_destroy_service('n_dao_dataobject_state')
				End If
			End If
	
		Case 'column selection', 'columnselection'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_matched_records.of_get_service_manager().of_add_service('n_show_fields')
				Else
					dw_matched_records.of_get_service_manager().of_destroy_service('n_show_fields')
				End If
			End If
			
		Case 'entity'
			If Not Properties.IsBatchMode And Trim(Properties.EntityName) <> '' And Not IsNull(Properties.EntityName) Then
				dw_matched_records.of_add_service('n_navigation_options')
				ln_service = dw_matched_records.of_get_service('n_navigation_options')
				If IsValid(ln_service) Then
					ln_service.Dynamic of_init(SQLCA, dw_matched_records, Lower(Trim(as_optionvalue)))
					lb_IsDragDropEnabled = Properties.IsDragDropEnabled
					ln_service.Dynamic of_set_dragdrop(lb_IsDragDropEnabled)
					ln_service.Dynamic of_set_allow_detail_reports(This, True)
				End If
			End If
			
		Case 'aggregationservice'
			If Upper(as_optionvalue) <> 'N' Then
				dw_matched_records.of_get_service_manager().of_add_service('n_aggregation_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_aggregation_service')
			End If 
	
		Case 'calendarservice'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_matched_records.of_get_service_manager().of_add_service('n_calendar_column_service')
				Else
					dw_matched_records.of_get_service_manager().of_destroy_service('n_calendar_column_service')
				End If 
			End If
			
		Case 'dropdowncaching'
			If Upper(as_optionvalue) <> 'N' Then
				dw_matched_records.of_get_service_manager().of_add_service('n_dropdowndatawindow_caching_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_dropdowndatawindow_caching_service')
			End If 
			
		Case 'rowselection'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_matched_records.of_get_service_manager().of_add_service('n_rowfocus_service')
				Else
					dw_matched_records.of_get_service_manager().of_destroy_service('n_rowfocus_service')
				End If 
			End If
	
		Case 'formatting'
			If Upper(as_optionvalue) <> 'N' Then
				dw_matched_records.of_get_service_manager().of_add_service('n_datawindow_formatting_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_datawindow_formatting_service')
			End If 
	
		Case 'rejectred'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_matched_records.of_get_service_manager().of_add_service('n_reject_invalids')
				Else
					dw_matched_records.of_get_service_manager().of_destroy_service('n_reject_invalids')
				End If 
			End If
			
		Case 'autofill'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_matched_records.of_get_service_manager().of_add_service('n_autofill')
				Else
					dw_matched_records.of_get_service_manager().of_destroy_service('n_autofill')
				End If
			End If
	
		Case 'keyboarddefault'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_matched_records.of_get_service_manager().of_add_service('n_keydown_date_defaults')
				Else
					dw_matched_records.of_get_service_manager().of_destroy_service('n_keydown_date_defaults')
				End If
			End If
	
		Case 'treeviewservice'
			If Upper(as_optionvalue) <> 'N' Then
				dw_matched_records.of_get_service_manager().of_add_service('n_datawindow_treeview_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_datawindow_treeview_service')
			End If
	
		Case 'daoservice'
			If Upper(as_optionvalue) <> 'N' Then
				dw_matched_records.of_get_service_manager().of_add_service('n_dao_service')
			Else
				dw_matched_records.of_get_service_manager().of_destroy_service('n_dao_service')
			End If
	End Choose
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// This option needs to be applied regardless of the status of the object
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(as_optionname)
	Case 'retrieve append'
		If Upper(as_optionvalue) = 'N' Then
			uo_titlebar.of_delete_button('Append Retrieve')
		Else
			uo_titlebar.of_add_button('Append Retrieve', 'retrieve append')
		End If
End Choose

end subroutine

public function uo_report_criteria of_create_criteria ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_create_criteria
// Arguments:   None
// Overview:    Creates the criteria object for this search object
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

if not isvalid(iu_criteria) And Len(Trim(Properties.CriteriaUserObject)) > 0 Then
//	If Properties.TrackStatistics Then
//		If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent(This.Text + ' (Creating Criteria Object)', 'Reporting')
//		End If
//	End If
	
	iu_criteria = of_OpenUserObject(Properties.CriteriaUserObject, 10000, uo_titlebar.Height)
	
	If Not IsValid(iu_criteria) Then Return iu_criteria
	
	iu_criteria.Width = 10000
	iu_criteria.Visible = False
	iu_criteria.X = 1
	iu_criteria.Border = False
	
	If Properties.IsImportedCriteriaDataObject Then
		If Properties.CriteriaDataObjectBlobObjectID > 0 And Not IsNull(Properties.CriteriaDataObjectBlobObjectID) Then
			iu_criteria.Dynamic uof_create_criteria_dw(Long(Properties.CriteriaDataObjectBlobObjectID))
		End If
	End If
		
	iu_criteria.of_set_db_transaction(Properties.TransactionObject)
	iu_criteria.Dynamic of_init(dw_matched_records)
	iu_criteria.Dynamic of_init(This)
	iu_criteria.Dynamic of_proc()
	This.of_restore_defaults()
	io_parent.Event Dynamic ue_notify('criteria created', This)
	
//	If Properties.TrackStatistics Then
//		If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//			gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(This.Text + ' (Creating Criteria Object)')
//		End If
//	End If
end if

return iu_criteria
end function

public function string of_set_document (string as_document_name);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_set_document
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

ib_ReportHasBeenInitialized = False
Return ''
end function

public function uo_report_criteria of_set_criteria (string as_criteria_object);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_criteria()
// Arguments:   as_criteria_object - the name of the criteria object
// Overview:    DocumentScriptFunctionality
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//Destroy the criteria object if it already exists
if isvalid(iu_criteria) then
	of_closeuserobject(iu_criteria)
	#IF defined PBDOTNET THEN
		this.event resize(0, this.width, this.height)
	#ELSE
		this.TriggerEvent('resize')
	#END IF

end if

If Len(Trim(Properties.CriteriaUserObject)) > 0 And Lower(Trim(Properties.CriteriaUserObject)) <> 'uo_report_criteria' Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// This will make sure that the criteria object gets created if we need to auto retrieve or show the criteria
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Properties.IsDefaultShowCriteria Or Properties.IsAutoRetrieve Then
		This.of_create_criteria()
		
		If Properties.IsDefaultShowCriteria Then
			This.Event ue_customize()
		End If
	End If
Else
	uo_titlebar.of_delete_button('criteria')
End If

Return iu_criteria
end function

public subroutine of_setdao (n_dao an_dao);
If ClassName(an_dao) = 'n_report' Then
	Properties = an_dao
	Properties.of_set_object('DataSource', dw_matched_records)
Else
	Super::of_setdao(an_dao)
End If

end subroutine

public function long of_retrieve (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve()
//	Arguments:  n_bag - Object that can hold retrieval arguments
//	Overview:   Stub Function to retrieve based on an instance of n_bag which will hold the retrieval arguemnts
//	Created by:	Joel White
//	History: 	
//----------------------------------------------------------------------------------------------------------------------------------

Return -1
end function

public function string of_distribute (string as_distributionmethod);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_distribute()
//	Arguments:  as_distributionmethod - The method of distribution
//	Overview:   This will distribute the document depending on which method is passed in
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_UsingDistributionLists
Long		ll_index
Long		ll_return
Long		ll_reportconfigcriteriaid
String	ls_return
String	ls_distributionoptions
String	ls_distributionmethod[]
String	ls_batchdistributionoptions
String	ls_null
String	ls_processparameter
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_reporting_object_service ln_reporting_object_service
n_blob_manipulator 			ln_blob_manipulator
//n_string_functions 			ln_string_functions
Window 							lw_distribute_report_wizard
PowerObject						lo_nullobject

SetPointer(Hourglass!)

If Not Properties.IsBatchMode Then
	Properties.of_set('DefaultDistributionMethod', as_distributionmethod)
	OpenWithParm(lw_distribute_report_wizard, Properties, 'w_distribute_report_wizard', This.of_getparentwindow())
	ll_return = Long(Message.DoubleParm)
	as_distributionmethod 			= Properties.of_get('SelectedDistributionMethods')
	Properties.of_set('SelectedDistributionMethods', '')
	Properties.of_set('DefaultDistributionMethod', '')
	If ll_return <> 1 Then
		Return 'Cancel'
	End If
End If

lb_UsingDistributionLists = Lower(Trim(Properties.of_get('UsingDistributionList'))) = 'true' Or Upper(Trim(Properties.of_get('UsingDistributionList'))) = 'Y'

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse on the @@@ since there could be multiple methods
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_distributionmethod, "@@@", ls_distributionmethod[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the DistributionList method if it's not there.  This will give us a place holder when looping
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_UsingDistributionLists Then
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
	
	as_distributionmethod = ''
	
	For ll_index = 1 To UpperBound(ls_distributionmethod[])
		as_distributionmethod = as_distributionmethod + ls_distributionmethod[ll_index] + '@@@'
	Next
	
	as_distributionmethod = Left(as_distributionmethod, Len(as_distributionmethod) - 3)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are scheduling as a batch report, insert process records, otherwise distribute now
//-----------------------------------------------------------------------------------------------------------------------------------
If Properties.of_get('IsBatchDistribution') = 'Y' Then
	//----------------------------------------------------------------------------------------------------------------------------------
	// Change the method delimiter to commas
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_replace_all(as_distributionmethod, '@@@', ',')
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Build the parameter string with what we know so far
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_processparameter = "RprtCnfgID=" + String(Properties.RprtCnfgID) + '||UserID=' + String(Properties.UserID) + '||DistributionMethod=' + as_distributionmethod

	//----------------------------------------------------------------------------------------------------------------------------------
	// Get the batch distribution options
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_batchdistributionoptions	= Properties.of_get('BatchDistributionOptions')
	Properties.of_set('BatchDistributionOptions', '')
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the criteria id
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_reportconfigcriteriaid	= Long(gn_globals.in_string_functions.of_find_argument(ls_batchdistributionoptions, '||', 'ReportDefaultCriteriaID'))
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// If the criteria id is zero (use current criteria) save the current criteria and get the id
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_reportconfigcriteriaid = 0 Then
		//----------------------------------------------------------------------------------------------------------------------------------
		// Get the criteria object if it hasn't been created yet.  Get a unique id for the criteria.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(This.of_create_criteria()) Then
			ll_reportconfigcriteriaid = This.of_get_criteria().of_save_criteria()
			If ll_reportconfigcriteriaid > 0 And Not IsNull(ll_reportconfigcriteriaid) Then
				gn_globals.in_string_functions.of_replace_argument('ReportDefaultCriteriaID', ls_batchdistributionoptions, '||', String(ll_reportconfigcriteriaid))
			End If
		End If
	End If
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Add all the parameters together
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(ls_batchdistributionoptions) > 0 And Not IsNull(ls_batchdistributionoptions) Then
		ls_processparameter = ls_processparameter + '||' + ls_batchdistributionoptions
	End If
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// If we are using a distribution list, we could have any method run, so we should just get all distribution options
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lb_UsingDistributionLists Then
		ls_return = Properties.of_getitem(1, 'DistributionOptions')

		//----------------------------------------------------------------------------------------------------------------------------------
		// Replace all characters that might cause parsing problems
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_replace_all(ls_return, '=', '&eq;')
		gn_globals.in_string_functions.of_replace_all(ls_return, '||', '&dp;')
		gn_globals.in_string_functions.of_replace_all(ls_return, '"', '&dq;')
		gn_globals.in_string_functions.of_replace_all(ls_return, "'", '&sq;')
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Add the distribution list and the options to the argument string
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_distributionoptions = 'DistributionListIDs=' + Properties.of_get('DistributionListIDs') + '||DistributionOptions=' + ls_return
	Else
		//----------------------------------------------------------------------------------------------------------------------------------
		// Loop through all distribution methods that are specified and get the options
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To UpperBound(ls_distributionmethod[])
			ls_return = Properties.of_getitem(1, ls_distributionmethod[ll_index] + '_options')
			If Not IsNull(ls_return) And Len(Trim(ls_return)) > 0 Then
				
				//----------------------------------------------------------------------------------------------------------------------------------
				// Make sure the distribution method is added to the options string, otherwise we can't parse them back out later
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Pos(Lower('||' + ls_return + '||'), Lower(Trim('DistributionMethod=' + ls_distributionmethod[ll_index]))) <= 0 Then
					ls_return = 'DistributionMethod=' + ls_distributionmethod[ll_index] + '||' + ls_return
				End If

				//----------------------------------------------------------------------------------------------------------------------------------
				// Replace all characters that might cause parsing problems
				//-----------------------------------------------------------------------------------------------------------------------------------
				gn_globals.in_string_functions.of_replace_all(ls_return, '=', '&eq;')
				gn_globals.in_string_functions.of_replace_all(ls_return, '||', '&dp;')
				gn_globals.in_string_functions.of_replace_all(ls_return, '"', '&dq;')
				gn_globals.in_string_functions.of_replace_all(ls_return, "'", '&sq;')
				ls_distributionoptions 	= ls_distributionoptions + ls_return + '@@@'
			End If
		Next
	
		ls_distributionoptions = 'DistributionOptions=' + Left(ls_distributionoptions, Len(ls_distributionoptions) - 3)
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// If the string gets too long, we will create a blob for the string, otherwise we will just pass it on to the process scheduler table
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(ls_processparameter) + Len(ls_distributionoptions) + 2 > 2000 Then
		ln_blob_manipulator = Create n_blob_manipulator
		ls_processparameter = ls_processparameter + '||ParametersBlobObjectID=' + String(ln_blob_manipulator.of_insert_blob(Blob(ls_distributionoptions), 'Batch Report Options'))
		Destroy ln_blob_manipulator
	Else
		If Len(ls_distributionoptions) > 0 And Not IsNull(ls_distributionoptions) Then
			ls_processparameter = ls_processparameter + '||' + ls_distributionoptions
		End If
	End If
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Schedule the batch report to run on RAMQ
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_reporting_object_service = Create n_reporting_object_service
	ls_return = ln_reporting_object_service.of_schedule_batch_report(ls_processparameter)
	Destroy ln_reporting_object_service
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Show a message if it fails
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(ls_return) > 0 Then
		gn_globals.in_messagebox.of_messagebox_validation(ls_return)
	End If
Else
	//----------------------------------------------------------------------------------------------------------------------------------
	// If there is an overlaying report, set it as the AlternateDistributionDataSource
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsValid(iu_overlaying_report) And Lower(Trim(is_overlaying_report_style)) = 'layered' Then
		Properties.of_set_object('AlternateDistributionDataSource', iu_overlaying_report.Dynamic of_get_report_dw())
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// Distribute the document
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_return = Properties.of_distribute(as_distributionmethod)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Clear the AlternateDistributionDataSource variable
	//-----------------------------------------------------------------------------------------------------------------------------------
	If IsValid(iu_overlaying_report) And Lower(Trim(is_overlaying_report_style)) = 'layered' Then
		Properties.of_set_object('AlternateDistributionDataSource', lo_nullobject)
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Return the Error/Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public function n_entity_drag_message of_get_selected_keys ();Return Properties.of_get_selected_keys()
end function

public function long of_getselectedrow (long row);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_getselectedrow()
// Arguments:   row - the row the search will start after
// Overview:    pass this function to the rowfocusservice if it exists.  If it doesn't, call the normal datawindow function
// Created by:  Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

Return dw_matched_records.of_getselectedrow(row)
end function

public function transaction of_gettransactionobject ();/**///Delete this function
Return Properties.TransactionObject
end function

public subroutine of_post_retrieve ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_post_retrieve()
//	Overview:   This is a stub function that will be executed before the retrieve
//					To take advantage of this, just overload this function
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------


end subroutine

public subroutine of_pre_retrieve ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_pre_retrieve()
//	Overview:   This is a stub function that will be executed before the retrieve
//					To take advantage of this, just overload this function
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------


end subroutine

public subroutine of_restore_defaults ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_restore_defaults()
//	Overview:   This will restore the last defaults for the criteria object
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Restore the defaults if there is data relating to the defaults and there is a valid reportconfigid 
//-----------------------------------------------------------------------------------------------------------------------------------
/**///Move to Properties
If Not IsNull(Properties.RprtCnfgID) And Properties.RprtCnfgID > 0 And Properties.UseCriteriaDefaultingService Then
	iu_criteria.of_restore_saved_criteria(Properties.RprtCnfgID, Properties.UserID)
	iu_criteria.of_post_default()
End If
end subroutine

public function long of_retrieve (string as_arguments);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve()
// Arguments:	as_arguments - an argument string in the form of (argument=value, argument=value)
//	Overview:   This will retrieve the report based on an argument string
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------
/**///Move to Properties
//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_return
String	ls_dataobject
Long 		ll_return = 1
Long		ll_null
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_document_builder_microsoft_word 	ln_document_builder_microsoft_word
n_datawindow_tools 						ln_datawindow_tools
n_rtf_document_builder 					ln_rtf_document_builder
PowerObject									lo_object
PowerObject									ldw_working
Any											lany_temp
Any											lany_empty

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the pointers correctly
//-----------------------------------------------------------------------------------------------------------------------------------
SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve differently based on the type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(Properties.ReportDocumentType))
	Case Lower('PowerBuilder Datawindow'), Lower('DTN Notification')
		lany_temp	= This.Event Dynamic ue_get_richtexteditor()
		
		If Not IsNull(lany_temp) Then
			If IsValid(lany_temp) Then
				lo_object = lany_temp
			End If
		End If
		
		lany_temp = lany_empty
		
		lany_temp	= This.Event Dynamic ue_get_richtextdatawindow()
		If Not IsNull(lany_temp) Then
			If IsValid(lany_temp) Then
				ldw_working = lany_temp
			End If
		End If
		
		If IsNull(lo_object) Or Not IsValid(lo_object) Or Not IsValid(ldw_working) Then
			//-------------------------------------------------------------------
			// Retrieve the datawindow based on a string of arguments delimited by || which is the standard for reporting
			//-------------------------------------------------------------------
			dw_matched_records.Event ue_notify('before retrieve', as_arguments)
			
			ln_datawindow_tools = Create n_datawindow_tools
			ll_return = Long(ln_datawindow_tools.of_retrieve(dw_matched_records, as_arguments, '||'))
			Destroy ln_datawindow_tools
		Else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Reset the datawindow before we retrieve, just in case we're retrieving over something we've already retrieved.
			//-----------------------------------------------------------------------------------------------------------------------------------
			dw_matched_records.SetRedraw(FALSE)
			ls_dataobject			= dw_matched_records.DataObject
			dw_matched_records.DataObject = ''
			dw_matched_records.DataObject = ls_dataobject
			dw_matched_records.SetRedraw(TRUE)

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Reset the datawindow before we retrieve, just in case we're retrieving over something we've already retrieved.
			//-----------------------------------------------------------------------------------------------------------------------------------
//			dw_matched_records.SelectTextAll(Header!)
//			dw_matched_records.ReplaceText('')
//			dw_matched_records.SelectTextAll(Detail!)
//			dw_matched_records.ReplaceText('')
//			dw_matched_records.SelectTextAll(Footer!)
//			dw_matched_records.ReplaceText('')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Use the document builder to build the document.  
			//	You must have two graphic controls in order to use this service
			//		1.		Datawindow (dw_working) - This is where the object will be retrieving the individual documents.  It is invisible.
			//		2.		RichTextEditor (rte_fileopener) - This is where RTF files and Bitmaps are appended.  It is also an evaluator for input
			//																fields that are sometimes copied over from the datawindow
			//-----------------------------------------------------------------------------------------------------------------------------------
			ln_rtf_document_builder	= Create n_rtf_document_builder
			ln_rtf_document_builder.of_set_richtexteditor(lo_object)
			ln_rtf_document_builder.of_init(dw_matched_records, ldw_working, Properties.RprtCnfgID)
			ls_return = ln_rtf_document_builder.of_build_document(as_arguments)
			Properties.of_setitem(1, 'DistributionInit', ln_rtf_document_builder.of_get_distributioninit())
			Destroy ln_rtf_document_builder
			//-----------------------------------------------------------------------------------------------------------------------------------
			// 
			//-----------------------------------------------------------------------------------------------------------------------------------
			If ls_return > '' Then
				If Properties.IsBatchMode Then
					//****decide what to do here	
				Else
					gn_globals.in_messagebox.of_MessageBox('Error Creating Document:  ' + ls_return, Information!, OK!, 1)
				End If
				ll_return = -1
			End If
		End If
		
	Case Lower('Microsoft Word Document')
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Use the document builder to build the document.  
		//	You must have two graphic controls in order to use this service
		//		1.		Datawindow (dw_working) - This is where the object will be retrieving the individual documents.  It is invisible.
		//		2.		RichTextEditor (rte_fileopener) - This is where RTF files and Bitmaps are appended.  It is also an evaluator for input
		//																fields that are sometimes copied over from the datawindow
		//-----------------------------------------------------------------------------------------------------------------------------------
		ln_document_builder_microsoft_word = Create n_document_builder_microsoft_word
		ls_return = ln_document_builder_microsoft_word.of_retrieve(Properties.RprtCnfgID, as_arguments)
		Properties.of_setitem(1, 'DistributionInit', ln_document_builder_microsoft_word.of_get_distributioninit())
		Destroy ln_document_builder_microsoft_word
				
		//-----------------------------------------------------------------------------------------------------------------------------------
		// 
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Left(Lower(Trim(ls_return)), 5) = 'error' Then
			If Properties.IsBatchMode Then
			Else
				gn_globals.in_messagebox.of_MessageBox('Error Creating Document:  ' + ls_return, Information!, OK!, 1)
			End If
			ll_return = -1
		Else		
			Properties.of_set('DocumentName', ls_return)
			
			If Not Properties.IsBatchMode And Right(Upper(ls_return), 3) = 'DOC' Then
				This.Event ue_notify('Retrieve', ls_return)
				This.Event ue_notify('Retrieve', ls_return) /**/// This is temporary to fix a problem with the document not showing.
			End If
		End If
		
		ll_return = 1
End Choose

Return ll_return
end function

public subroutine of_add_button (string as_text, string as_eventname);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_add_button()
// Overrides:  No
// Overview:   Redirect this function to the title bar.
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

uo_titlebar.of_add_button(as_text, as_eventname)
end subroutine

public subroutine of_restore_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will restored the datawindow state from the blob object variable
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// If the state is not stored, return
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_statestored Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// If the dataobject name is valid, set the dataobject to preserve the variable on the control
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(is_dataobjectname) > 0 Then dw_matched_records.DataObject = is_dataobjectname

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the full state of the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(iblob_currentstate) > 0 Then
	dw_matched_records.SetFullState(iblob_currentstate)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the transaction object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(dw_matched_records.GetTransObject()) Then
	dw_matched_records.SetTransObject(dw_matched_records.GetTransObject())
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the current state blob object to null to save memory
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(iblob_currentstate)

//-----------------------------------------------------------------------------------------------------------------------------------
// Turn off the state stored boolean
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = False
end subroutine

public subroutine of_save_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will save the state as a blob object in memory to save objects
//	Created by:	Joel White
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_syntax

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the state is already stored
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_statestored Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty datawindow syntax, may be needed later
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = 'release 9;&
datawindow(units=0 timer_interval=0 color=1073741824 processing=0)&
summary(height=0 color="536870912" )&
footer(height=0 color="536870912" )&
detail(height=0 color="536870912" )&
table(column=(type=char(10) updatewhereclause=yes name=test dbname="test" )&
 )'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the full state into the blob object
//-----------------------------------------------------------------------------------------------------------------------------------
dw_matched_records.GetFullState(iblob_currentstate)

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
is_dataobjectname = dw_matched_records.DataObject

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dataobject to empty string in order to clear the objects
//-----------------------------------------------------------------------------------------------------------------------------------
dw_matched_records.DataObject = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that the state is stored
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = True
end subroutine

public subroutine of_set_parent (u_search_criteria uo_parent);iu_MyParent = uo_parent
end subroutine

on u_matched_records.create
int iCurrent
call super::create
this.dw_matched_records=create dw_matched_records
this.uo_titlebar=create uo_titlebar
this.st_separator=create st_separator
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_matched_records
this.Control[iCurrent+2]=this.uo_titlebar
this.Control[iCurrent+3]=this.st_separator
end on

on u_matched_records.destroy
call super::destroy
destroy(this.dw_matched_records)
destroy(this.uo_titlebar)
destroy(this.st_separator)
end on

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      constructor
// Overrides:  No
// Overview:   Initialize the search object
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

THIS.POST Event ue_post_constructor()

//----------------------------------------------------------------------------------------------------------------------------------
// If this was opened with Parm, get the properties object
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(Message.PowerObjectParm) Then
	If IsValid(Message.PowerObjectParm) Then
		If ClassName(Message.PowerObjectParm) = 'n_report' Then Properties = Message.PowerObjectParm
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
// This will eventually go away, but for now, I'm afraid for this object to not be valid in the constructor
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(Properties) Then
	Properties = Create n_report
End If

dw_matched_records.of_set_properties(Properties)

ido_resize_object	= dw_matched_records

//----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the resize event happens
//-----------------------------------------------------------------------------------------------------------------------------------
#IF defined PBDOTNET THEN
	this.event resize(0, this.width, this.height)
#ELSE
	this.TriggerEvent('resize')
#END IF



end event

event destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      destructor
// Overrides:  No
// Overview:   Clean Up Logic
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// This will hopefully alleviate the problem of file based nested datawindows crashing on destroy
//-----------------------------------------------------------------------------------------------------------------------------------
//If IsValid(dw_report) Then dw_report.dataobject = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the properties object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(Properties) Then Destroy Properties
end event

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      resize
// Overrides:  No
// Overview:   Resize the objects on the userobject
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean lb_criteria = False, lb_filter = False
Long		ll_width, ll_height, ll_x, ll_y, ll_overlayingreport_y

If IsValid(Properties) Then
	If Not Properties.IsBatchMode And This.Height > 0 And This.Width > 0 And IsValid(ido_resize_object) Then
		//Set redraw false
		This.of_SetRedraw(False)
		
		//See if the filter and criteria are valid.  We size differently for each case
		If IsValid(iu_criteria) 	Then lb_criteria = iu_criteria.Visible
		If IsValid(iu_filter) 		Then lb_filter = iu_filter.Visible
			
		If lb_criteria And Not lb_filter Then
			st_separator.Y			= iu_criteria .Height + iu_criteria .Y
			st_separator.Visible = True
			ido_resize_object.Y 			= st_separator .Height + st_separator .Y
		End If
		
		If Not lb_criteria And lb_filter Then
			st_separator.Visible = False
			iu_filter.Y 		= uo_titlebar.Height + uo_titlebar.Y
			ido_resize_object.Y 		= iu_filter.Height + iu_filter.Y
		End If
		
		If lb_criteria And lb_filter Then
			st_separator.Visible = False
			iu_filter.Y 			= iu_criteria.Height + iu_criteria .Y
			ido_resize_object.Y 			= iu_filter.Height + iu_filter.Y
		End If
			
		If Not lb_criteria And Not lb_filter Then
			st_separator.Visible = False
			ido_resize_object.Y 		= uo_titlebar.Height
		End If
		
		ido_resize_object.Width 		= Width - 8
		ido_resize_object.Height 	= Height - ido_resize_object.Y - 8
		
		If lb_filter Then iu_filter.Width = Width
		
		If IsValid(iu_report_conversion_strip) And ib_uom_conversion_is_on_this_object Then
			If iu_report_conversion_strip.Visible Then
				iu_report_conversion_strip.Width = This.Width
				iu_report_conversion_strip.Y = Max(This.Height - iu_report_conversion_strip.Height, ido_resize_object.Y)
				ido_resize_object.Height = iu_report_conversion_strip.Y - ido_resize_object.Y
			End If
		End If
		
		//Resize other objects that are always visible
		st_separator.Width = Width
		uo_titlebar.Width = Width
		ido_resize_object.BringToTop = True
		
		If IsValid(iu_criteria) Then
			iu_criteria.Width = Width
		End If
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the overlaying search is valid, bring it to the top and resize it correctly
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(iu_overlaying_report) Then
			Choose Case Lower(Trim(is_overlaying_report_style))
				Case 'tiled', 'tiled fixed'
					If iu_overlaying_report.Y = 0 Then
						ll_y = (Height - ido_resize_object.Y) / 2
					Else
						ll_y = iu_overlaying_report.Y
					End If
					
					iu_overlaying_report.Move(0, ll_y)
					ido_resize_object.Height = iu_overlaying_report.Y - ido_resize_object.Y - 20
					
					If Not IsValid(iu_slider_control_horizontal) Then
						iu_slider_control_horizontal = This.of_openuserobject('u_slider_control_horizontal', 10000, 0)
						iu_slider_control_horizontal.Height = 20
						iu_slider_control_horizontal.Move(0, ll_y - iu_slider_control_horizontal.Height)
						iu_slider_control_horizontal.of_set_reference(This)
						iu_slider_control_horizontal.of_set_turn_redraw_off(False)
						iu_slider_control_horizontal.Width	= 20000
						iu_slider_control_horizontal.Backcolor = gn_globals.in_theme.of_get_barcolor()
						iu_slider_control_horizontal.Border = False
						iu_slider_control_horizontal.of_add_upper_object(ido_resize_object)
						iu_overlaying_report.Y = iu_slider_control_horizontal.Y + iu_slider_control_horizontal.Height

						If IsValid(iu_report_conversion_strip) And ib_uom_conversion_is_on_this_object Then
							iu_overlaying_report.Height = iu_report_conversion_strip.Y - iu_overlaying_report.Y
						Else
							iu_overlaying_report.Height = Height - iu_overlaying_report.Y
						End If
						iu_slider_control_horizontal.of_add_lower_object(iu_overlaying_report)
					Else
						iu_slider_control_horizontal.Move(0, ll_y - iu_slider_control_horizontal.Height)
						iu_overlaying_report.Y = iu_slider_control_horizontal.Y + iu_slider_control_horizontal.Height
						If IsValid(iu_report_conversion_strip) And ib_uom_conversion_is_on_this_object Then
							iu_overlaying_report.Height = iu_report_conversion_strip.Y - iu_overlaying_report.Y
						Else
							iu_overlaying_report.Height = Height - iu_overlaying_report.Y
						End If
						
						
					End If
					iu_overlaying_report.Width = Width
				Case Else
					If IsValid(iu_slider_control_horizontal) Then 
						iu_slider_control_horizontal.of_reset()
						This.of_closeuserobject(iu_slider_control_horizontal)
					End If
					
					iu_overlaying_report.Move(0, ido_resize_object.Y)
					iu_overlaying_report.Resize(Width - iu_overlaying_report.X, Height - iu_overlaying_report.Y)
					
					If IsValid(iu_report_conversion_strip) And ib_uom_conversion_is_on_this_object Then
						If iu_report_conversion_strip.Visible Then
							iu_overlaying_report.Height = iu_report_conversion_strip.Y - iu_overlaying_report.Y
						End If
					End If
			End Choose
			
			iu_overlaying_report.BringToTop = True
		Else
			If IsValid(iu_slider_control_horizontal) Then 
				iu_slider_control_horizontal.of_reset()
				This.of_closeuserobject(iu_slider_control_horizontal)
			End If
		End If
		
		//Set the redraw back to true
		This.of_SetRedraw(True)
	End If
End If
end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This will respond to subscriptions
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_reporting_object_service ln_reporting_object_service 
NonVisualObject ln_service
//n_recurrence ln_recurrence
u_dynamic_gui lu_gui
n_bag ln_bag
n_report ln_report
//n_string_functions ln_string_functions
Window lw_window
u_search lu_search, lu_search_array[]

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_row
Long		ll_return
Long		ll_originalpivottablereportconfigid = 0
Long		ll_reportconfigid
Long		ll_rowcount
String	ls_report_title
String 	ls_return
String 	ls_count
String 	ls_plural = 's'
String 	ls_originalpivottablereporttype = 'R'
String 	ls_viewer_object
String 	ls_modulename
String 	ls_search_type

SetPointer(HourGlass!)

Choose Case Lower(as_message)
	Case 'object text changed'
		If as_arg <> This Then
			gn_globals.in_subscription_service.of_message('Object Text Changed', This, This)
		End If
	Case 'open menu'
		ib_MenuCoordinatesAreSpecified = True
		il_MenuPointerX = Long(Left(String(as_arg), Pos(String(as_arg), ',') - 1))
		il_MenuPointerY = Long(Right(String(as_arg), Len(String(as_arg)) - Pos(String(as_arg), ',')))
		This.Event ue_showmenu()
		If IsValid(This) Then
			ib_MenuCoordinatesAreSpecified = False
		Else
			Return
		End If
	Case 'retrieve'
		Choose Case ClassName(as_arg)
			Case 'any'
				//do nothing because the argument was null
			Case 'string'
				this.of_retrieve(String(as_arg))
			Case 'n_bag'
				ln_bag = as_arg
				this.of_retrieve(ln_bag)
		End Choose

	Case 'filter', 'set rowcount' /**///Move to properties and send data through message object to gui
		
		If dw_matched_records.RowCount() + dw_matched_records.FilteredCount() = 1 Then ls_plural = ''
		
		If dw_matched_records.FilteredCount() > 0 Then
			ls_count = '(' + String(dw_matched_records.RowCount()) + ' of ' + String(dw_matched_records.RowCount() + dw_matched_records.FilteredCount()) + ' row' + ls_plural
		Else
			ls_count = '(' + String(dw_matched_records.RowCount()) + ' row' + ls_plural
		End If
		
		If dw_matched_records.of_IsAppending() Then
			ls_count = ls_count + ' appended) '
		Else
			ls_count = ls_count + ') '
		End If

		If dw_matched_records.of_IsAutoRefreshOn() Then
			ls_count = ls_count + '(Refresh in ' + String(Max(0, SecondsAfter(Now(), Time(dw_matched_records.of_getrefreshtime())))) + ' seconds)'
		End If
		
		uo_titlebar.of_settitle2(ls_count)				
	//This will catch all the button commands and menu commands

	Case 'button clicked', 'menucommand'
		Choose Case Lower(String(as_arg))
			//----------------------------------------------------------------------------------------------------------------------------------
			// Title bar button messages
			//-----------------------------------------------------------------------------------------------------------------------------------
			Case 'restore'
					ll_rowcount = dw_matched_records.RowCount()
					dw_matched_records.Create(is_original_syntax)
					dw_matched_records.EVENT TRIGGER ue_refresh_services()
					//Match letter to search type
					CHOOSE CASE Upper( gs_seachType )
						CASE 'MEMBER'
							ls_search_type = 'C'
						CASE 'GROUP'
							ls_search_type = 'E'
						CASE 'PROVIDER'
							ls_search_type = 'P'
						CASE 'OTHER'
							ls_search_type = 'O'
						CASE 'CASE'
							ls_search_type = 'S'
						CASE 'APPEAL'
							ls_search_type = 'A'
					END CHOOSE
					//Add the extra results columns
					dw_matched_records.Event Trigger ue_addResultsColumns( ls_search_type )
					dw_matched_records.SetTransObject(SQLCA)
					IF ll_rowcount > 0 THEN
						m_create_maintain_case.m_file.m_search.TriggerEvent (clicked!)
					END IF
			Case 'criteria'
				This.TriggerEvent('ue_customize')
			Case 'filters'
				This.TriggerEvent('ue_filters')
			Case 'reretrieve'
				dw_matched_records.of_reretrieve()
			Case 'customize report'
				OpenWithParm(lw_window, Properties, 'w_reporting_services', w_mdi)
			Case 'retrieve'
				If IsValid(This.of_get_adapter()) Then
					If IsValid(This.of_get_adapter().of_create_criteria()) Then
						This.of_get_adapter().Event Dynamic ue_notify('button clicked', 'retrieve=' + String(Handle(This)))
					Else
						#IF defined PBDOTNET THEN
							this.EVENT resize(0, this.width, this.height)
						#ELSE
							this.TriggerEvent('resize')
						#END IF
					End If
				Else
					#IF defined PBDOTNET THEN
						this.EVENT resize(0, this.width, this.height)
					#ELSE
						this.TriggerEvent('resize')
					#END IF
				End If

			Case 'close'
				This.of_close()
			Case 'print'
				This.of_distribute('Print')
			Case 'save'
				This.of_distribute('Archive')				
			Case 'save over archive'/**/
				//-----------------------------------------------------
				// Replace the current archive with this one
				//-----------------------------------------------------
				If IsNumber(dw_matched_records.Describe("DataWindow.RichText.InputFieldBackColor")) And Properties.ReportType = 'S' Then
					
					//----------------------------------------------------------------------------------------------------------------------------------
					// Ask if they are sure they want to replace the current archived document
					//-----------------------------------------------------------------------------------------------------------------------------------
					If Not Properties.IsBatchMode Then
						If Not gn_globals.in_messagebox.of_messagebox_question ('Are you sure you want to overwrite the current saved report', YesNo!, 2) = 1 Then Return
					End If

					//----------------------------------------------------------------------------------------------------------------------------------
					// Create the saved report object and replace the current report with this one.
					//-----------------------------------------------------------------------------------------------------------------------------------
					ln_service = Create using Properties.ArchiveObject
					ls_return = ln_service.Dynamic of_replace_saved_report(dw_matched_records, Long(Properties.SavedReportID))
					If Len(Trim(ls_return)) > 0 Then
						If Not Properties.IsBatchMode Then
							gn_globals.in_messagebox.of_messagebox(ls_return, Information!, OK!, 1)
						End If
					End If
				
					Destroy ln_service
				End If
				
			Case 'send to recipient'/**/
//				ln_service = Create n_tickler_message
//				ln_service.Dynamic of_set_attachment('Saved Report:  ' + This.Text, 'SavedReport', 'svdrprtid=' + String(Properties.SavedReportID))
//				OpenWithParm(lw_window, ln_service, 'w_ticklermessage_new')
			Case 'pivottable'/**///Move to nonvisual service
				ln_service = Create n_pivot_table_service
				ln_service.Dynamic of_set_datasource(dw_matched_records)
				ln_service.Dynamic of_set_report_object(This)
				ln_service.Dynamic of_set_reportconfigid(Long(Properties.RprtCnfgID))
				ln_service.Dynamic of_set_userid(Long(Properties.UserID))
				ln_service.Dynamic of_set_batch_mode(Properties.IsBatchMode = True)
				ln_service.Dynamic of_present_gui()
			Case 'distribute'
				this.of_distribute('')
			Case 'save nested report' /**///Move to nonvisual service
				ln_reporting_object_service = Create n_reporting_object_service
				ln_reporting_object_service.of_save_nested_report(This)
				Destroy ln_reporting_object_service
		End Choose
	Case 'pivot table view', 'pivot table view new', 'auto pivot'/**///Move to nonvisual service
		ln_service = Create n_pivot_table_service
		ln_service.Dynamic of_set_datasource(dw_matched_records)
		ln_service.Dynamic of_set_report_object(This)			
		ln_service.Dynamic of_set_reportconfigid(Long(Properties.RprtCnfgID))
		ln_service.Dynamic of_set_userid(Long(Properties.UserID))
		ln_service.Dynamic of_set_autopivot(True)
		ln_service.Dynamic of_set_batch_mode(Properties.IsBatchMode = True)
		
		Choose Case Lower(Trim(as_message))
			Case 'pivot table view'
				ls_return = ln_service.Dynamic of_apply_view(Long(as_arg))
			Case 'pivot table view new'
				ln_service.Dynamic of_set_autopivot(False)
				ls_return = ln_service.Dynamic of_apply_view(Long(as_arg))
			Case 'auto pivot'
				ls_return = ln_service.Dynamic of_apply_view(Long(Mid(String(as_arg), Pos(String(as_arg), '=') + 1, 1000)))
		End Choose
		
		If ls_return <> '' Then
			If Not Properties.IsBatchMode Then
				gn_globals.in_messagebox.of_messagebox_validation(ls_return)
			End If
		End If
		
	Case 'apply filter view' /**///Move to nonvisual service
		If Not IsValid(iu_filter) Then This.Event ue_filters()
		If IsValid(iu_filter) Then	iu_filter.Event ue_notify('apply filter view', as_arg)
		
	Case 'apply criteria view' /**///Move to properties
		This.of_create_criteria()
		If IsValid(iu_criteria) Then iu_criteria.of_restore_saved_criteria(Long(as_arg))

	Case 'reapply filter'/**///Move to nonvisual service
		If IsValid(iu_filter) Then iu_filter.Event ue_notify('reapply filter', '')
	
	Case 'apply nested report' /**///Move to nonvisual service
		ln_reporting_object_service = Create n_reporting_object_service
		ln_reporting_object_service.of_apply_nested_report(This, Long(as_arg))
		Destroy ln_reporting_object_service
		
	Case 'manage nested reports', 'manage pivot table views', 'manage report views', 'manage criteria views', 'manage filter views'
		ln_bag = Create n_bag
		ln_bag.of_set('RprtCnfgID', Properties.RprtCnfgID)
		ln_bag.of_set('displaydataobjectname', dw_matched_records.dataobject)  //Chris Cole 01/06/2003
		
		Choose Case Lower(Trim(as_message))
			Case 'manage nested reports'
				ln_bag.of_set('type', 'nested report')
			Case 'manage pivot table views'
				ln_bag.of_set('type', 'pivot table')
			Case 'manage report views'
				ln_bag.of_set('type', 'datawindow')
			Case 'manage criteria views'
				ln_bag.of_set('type', 'criteria')
			Case 'manage filter views'
				ln_bag.of_set('type', 'filter')
		End Choose
				
		OpenWithParm(lw_window, ln_bag, 'w_reportconfig_manage_views', w_mdi)
						
		
	Case 'distribute'
		this.of_distribute(as_arg)

	Case 'open detail report'
		//----------------------------------------------------------------------------------------------------------------------------------
		// Get the reportconfig id from the message
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_reportconfigid = Long(gn_globals.in_string_functions.of_find_argument(Lower(String(as_arg)), ',', 'RprtCnfgID'))
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// If the reportconfig is invalid, return
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsNull(ll_reportconfigid) or ll_reportconfigid <= 0 Then Return
		
		ln_report = Create n_report
		ln_report.of_init(ll_reportconfigid)
		ln_report.of_set('IsBatchMode', Properties.of_Get('IsBatchMode'))
		ln_report.of_set('AllowRetrieve', 'N')
		ln_report.of_set('AllowCriteria', 'N')

		//----------------------------------------------------------------------------------------------------------------------------------
		// Get the adapter object to open
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(iu_overlaying_report) Then
			If Lower(Trim(ClassName(iu_overlaying_report))) <> Lower(Trim(ln_report.of_get('AdapterObject'))) Then
				ll_return = Long(iu_overlaying_report.Event Dynamic ue_close())
				
				If ll_return <> 1 Or IsNull(ll_return) Then
					This.of_closeuserobject(iu_overlaying_report)
				Else
					Return
				End If
			End If
		End IF
		
		If Not IsValid(iu_overlaying_report) Then
			
			//----------------------------------------------------------------------------------------------------------------------------------
			// Open the overlaying report
			//-----------------------------------------------------------------------------------------------------------------------------------
			iu_overlaying_report = This.of_openuserobject(ln_report.of_get('AdapterObject'), 10000, 0)
			iu_overlaying_report.Border = False
			iu_overlaying_report.Dynamic of_set_parent_adapter(This.of_get_adapter())
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Initialize the adapter using the report manager
		//-----------------------------------------------------------------------------------------------------------------------------------
		iu_overlaying_report.of_setdao(ln_report)
		iu_overlaying_report.Dynamic of_get_reports(lu_search_array[])
		iu_overlaying_report.Dynamic of_set_option('CanAddReports', 'N')

//		lu_search = iu_overlaying_report.Dynamic of_open_report(ln_report)
		
		If UpperBound(lu_search_array[]) > 0 Then
			If IsValid(lu_search_array[UpperBound(lu_search_array[])]) Then
				//----------------------------------------------------------------------------------------------------------------------------------
				// Select the newly opened report
				//-----------------------------------------------------------------------------------------------------------------------------------
				iu_overlaying_report.Dynamic of_select(lu_search_array[UpperBound(lu_search_array[])])
				lu_search_array[UpperBound(lu_search_array[])].of_add_button('Reretrieve', 'reretrieve')
			End If
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Set this as an overlaying report
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_set_overlaying_report(iu_overlaying_report, 'tiled')
		#IF defined PBDOTNET THEN
			this.EVENT resize(0, this.width, this.height)
		#ELSE
			this.TriggerEvent('resize')
		#END IF
		iu_overlaying_report.TriggerEvent('resize')
		
		//------------------------------------------------------------
		// Get the navigation options object and set the detail object
		//------------------------------------------------------------
		ln_service = dw_matched_records.of_get_service('n_navigation_options')

		//----------------------------------------------------------------------------------------------------------------------------------
		// If we can find the navigation options object, set the report as the detail report so the navigation can happen
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(ln_service) Then ln_service.Dynamic of_set_detail_report(iu_overlaying_report)
	Case 'open detail object'
		//----------------------------------------------------------------------------------------------------------------------------------
		// Get the reportconfig id from the message
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_viewer_object = gn_globals.in_string_functions.of_find_argument(Lower(String(as_arg)), ',', 'viewer')
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// If the reportconfig is invalid, return
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsNull(ls_viewer_object) or Len(Trim(ls_viewer_object)) <= 0 Then Return
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// If the overlaying report is valid, make sure it's the right report, otherwise destroy it
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(iu_overlaying_report) Then
			If Lower(Trim(ls_viewer_object)) = Lower(Trim(ClassName(iu_overlaying_report))) Then Return

			This.of_closeuserobject(iu_overlaying_report)
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Open the overlaying report
		//-----------------------------------------------------------------------------------------------------------------------------------
		iu_overlaying_report = This.of_openuserobject(ls_viewer_object, 10000, 0)
		iu_overlaying_report.Event ue_notify('Set Parameters', String(as_arg))
		iu_overlaying_report.Border = False

		//----------------------------------------------------------------------------------------------------------------------------------
		// Set this as an overlaying report
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_set_overlaying_report(iu_overlaying_report, 'tiled fixed')
		#IF defined PBDOTNET THEN
			this.event resize(0, this.width, this.height)
		#ELSE
			this.TriggerEvent('resize')
		#END IF
		
		//------------------------------------------------------------
		// Get the navigation options object and set the detail object
		//------------------------------------------------------------
		ln_service = dw_matched_records.of_get_service_manager().of_get_service('n_navigation_options')

		//----------------------------------------------------------------------------------------------------------------------------------
		// If we can find the navigation options object, set the report as the detail report so the navigation can happen
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(ln_service) Then ln_service.Dynamic of_set_detail_report(iu_overlaying_report)
	Case 'detail object best fit'
		If IsValid(iu_overlaying_report) And IsValid(iu_slider_control_horizontal) Then
			If IsValid(iu_report_conversion_strip) And ib_uom_conversion_is_on_this_object Then
				iu_slider_control_horizontal.Y = Max(st_separator.Y + 100, iu_slider_control_horizontal.Y + (iu_report_conversion_strip.Y - (iu_overlaying_report.Y + iu_overlaying_report.Height)))
			Else
				iu_slider_control_horizontal.Y = Max(st_separator.Y + 100, iu_slider_control_horizontal.Y + (Height - (iu_overlaying_report.Y + iu_overlaying_report.Height)))
			End If
		End If
		iu_overlaying_report.Y = iu_slider_control_horizontal.Y + iu_slider_control_horizontal.Height
		ll_row = dw_matched_records.of_GetSelectedRow(0)
		#IF defined PBDOTNET THEN
			this.event resize(0, this.width, this.height)
		#ELSE
			this.TriggerEvent('resize')
		#END IF

		If ll_row > 0 And Not IsNull(ll_row) And ll_row <= dw_matched_records.RowCount() Then
			dw_matched_records.ScrollToRow(ll_row)
		End If
		
	Case 'u_search closing', 'adapter closing'
		#IF defined PBDOTNET THEN
			this.event resize(0, this.width, this.height)
		#ELSE
			this.TriggerEvent('resize')
		#END IF
		gn_globals.in_subscription_service.Post of_message('Object Text Changed', This, This)
		
	Case 'close object'
		If IsValid(as_arg) Then
			lu_gui = as_arg
			If lu_gui.Dynamic Event ue_close() = 0 Then
				This.of_closeuserobject(lu_gui)
				#IF defined PBDOTNET THEN
					this.event resize(0, this.width, this.height)
				#ELSE
					this.TriggerEvent('resize')
				#END IF
			End If
		End If
End Choose
end event

event type long ue_close();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_close
// Overrides:  YES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Overview:   Publish a message that this is closing and close thyself
// Created by: Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_return = 0

If IsValid(iu_overlaying_report) Then
	ll_return = iu_overlaying_report.Event ue_close()
End If

Return ll_return
end event

event ue_showmenu;call super::ue_showmenu;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_showmenu
// Overrides:  No
// Overview:   This will show the common popup menu for this object.
//					If you want to create your own, just override this function, or destroy the im_menu objet and recreate it
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	IsMaintenanceWindow

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
m_dynamic 					lm_dynamic_menu
n_menu_dynamic				ln_menu_dynamic
n_menu_dynamic				ln_menu_dynamic_found

//-----------------------------------------------------------------------------------------------------------------------------------
// If the overlaying search is valid, call its showmenu rather than presenting this one
//-----------------------------------------------------------------------------------------------------------------------------------
/**///Move to n_report, it should get the n_report from the pivot table and use it somehow
If IsValid(iu_overlaying_report) Then
	If iu_overlaying_report.Visible And iu_overlaying_report.Y = 0 And iu_overlaying_report.X = 0 Then
		iu_overlaying_report.Event ue_showmenu()
		Return
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine some properties of the report
//-----------------------------------------------------------------------------------------------------------------------------------
IsMaintenanceWindow = Lower(Trim(String(This.Event Dynamic ue_getreporttype()))) = 'maintenance window'
If IsNull(IsMaintenanceWindow) Then IsMaintenanceWindow = False
If IsMaintenanceWindow Then Properties.of_set('IsMaintenanceWindow', 'Y')

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the menu from the nonvisual report object
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic			= Properties.of_get_menu()

//-----------------------------------------------------------------------------------------------------------------------------------
// Set autorefresh menu status based on information the Properties object does not know
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic_found 	= ln_menu_dynamic.of_find_menu('Auto-Retrieve Report')

If IsValid(ln_menu_dynamic_found) Then
	ln_menu_dynamic_found.Visible	= True
	ln_menu_dynamic_found.Checked = dw_matched_records.Dynamic of_isautorefreshon()
End If

ln_menu_dynamic_found 	= ln_menu_dynamic.of_find_menu('Set Auto-Retrieve Time')

If IsValid(ln_menu_dynamic_found) Then
	ln_menu_dynamic_found.Visible	= dw_matched_records.Dynamic of_isautorefreshon()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set Nested Report menu properties based on information not contained in Properties
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic_found 	= ln_menu_dynamic.of_find_menu('Save Nested Report')

If IsValid(ln_menu_dynamic_found) Then
	If Not ln_menu_dynamic_found.Visible Then
		ln_menu_dynamic_found.Visible	= IsValid(iu_overlaying_report) And Lower(Trim(is_overlaying_report_style)) <> 'layered'
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create a dynamic menu and set the target object as this object
//-----------------------------------------------------------------------------------------------------------------------------------
lm_dynamic_menu = create m_dynamic
lm_dynamic_menu.of_set_menuobject(ln_menu_dynamic)
Destroy ln_menu_dynamic

//----------------------------------------------------------------------------------------------------------------------------------
// display the already created menu object.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case This.of_getparentwindow().WindowType
	Case Response!, Popup!
		lm_dynamic_menu.popmenu(This.of_getparentwindow().pointerx(), This.of_getparentwindow().pointery())
	Case Else
		If ib_MenuCoordinatesAreSpecified Then
			lm_dynamic_menu.popmenu(il_MenuPointerX, il_MenuPointerY)
		Else
			lm_dynamic_menu.popmenu( w_mdi.pointerx(), w_mdi.pointery())
		End If
End Choose
end event

event dragdrop;call super::dragdrop;dwobject ldwo_nulldwobject
dw_matched_records.Event DragDrop(source, 1, ldwo_nulldwobject)
end event

type dw_matched_records from u_dw_gui within u_matched_records
event ue_post_initialize ( )
event ue_savedatawindow ( )
event ue_builddatawindow ( string as_dataobject )
event ue_addresultscolumns ( string as_searchtype )
event ue_selecttrigger pbm_dwnkey
event ue_refresh_services ( )
integer x = 14
integer y = 116
integer width = 2377
integer height = 460
integer taborder = 20
string dragicon = "arrowman.ico"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean automaticallypresentrightclickmenu = true
end type

event ue_post_initialize();Parent.Event ue_post_initialize()
end event

event ue_savedatawindow();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_dataobject 	- This is the datawindow that you are saving the syntax for
//					as_casetype		-	This is the CaseType the syntax is for
//					as_sourcetype	-	This is the SourceType that the syntax is for
//	Overview:   This function takes datawindow syntax and either inserts or updates it into the SyntaxStorage
//					object, which will then update the database with the new syntax.
//	Created by:	Joel White
//	History: 	6/23/2005 - First Created 
//  				10/25/2005 - Modified to use to save the demographics result set datawindows
//-----------------------------------------------------------------------------------------------------------------------------------


String	ls_filter_string, ls_syntax, ls_dynamiccolumn_list, ls_searchType, ls_select
long		ll_blob_ID, ll_return
Integer 	li_row, li_rowcount
Blob		lblb_datawindowSyntax

//-----------------------------------------------------------------------------------------------------------------------------------
// Don't save syntax if it doesn't have a search type
//-----------------------------------------------------------------------------------------------------------------------------------
If	IsNull(gs_seachtype) Or gs_seachtype = '' Then
	Return
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the filter string and filter the rows of the datastore to see if you already have a record for this combination
	//-----------------------------------------------------------------------------------------------------------------------------------
	//Match letter to search type and set the syntax to the syntax stored in the instance strings
	//  per search type as the instance strings contain the syntax without the search mechanism mods
	CHOOSE CASE Upper( gs_seachType )
		CASE 'MEMBER'
			ls_searchType = 'C'
			ls_select = iu_MyParent.is_MemberSyntax
		CASE 'GROUP'
			ls_searchType = 'E'
			ls_select = iu_MyParent.is_GroupSyntax
		CASE 'PROVIDER'
			ls_searchType = 'P'
			ls_select = iu_MyParent.is_ProviderSyntax
		CASE 'OTHER'
			ls_searchType = 'O'
			ls_select = iu_MyParent.is_OtherSyntax
		CASE 'CASE'
			ls_searchType = 'S'
			ls_select = iu_MyParent.is_CaseSyntax
		CASE 'APPEAL'
			ls_searchType = 'A'
			ls_select = iu_MyParent.is_AppealSyntax
	END CHOOSE
	
	//Get the datawindow syntax and convert to blob
	THIS.Object.Datawindow.Table.Select = ls_select
	ls_syntax = THIS.Object.DataWindow.Syntax
	lblb_datawindowSyntax = blob(ls_syntax)
	
	ls_filter_string =  'qualifier = "' + THIS.dataobject + '" and searchtype = "' + ls_searchType + '"'
	
	iu_MyParent.ids_syntax.SetFilter(ls_filter_string)
	iu_MyParent.ids_syntax.Filter()
			
	li_rowcount = iu_MyParent.ids_syntax.RowCount()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If a row was found, then update the row, otherwise Insert a new row.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If li_rowcount > 0 Then
		ll_blob_ID = iu_MyParent.ids_syntax.GetItemNumber(li_rowcount, 'blbobjctid')
		iu_MyParent.in_blob_manipulator.of_update_blob(lblb_datawindowSyntax, ll_blob_ID, FALSE)
		li_row = li_rowcount
	Else
		ll_blob_ID = iu_MyParent.in_blob_manipulator.of_insert_blob(lblb_datawindowSyntax, THIS.DataObject, FALSE)
		li_row = iu_MyParent.ids_syntax.InsertRow(0)
	END IF	
	
	iu_MyParent.ids_syntax.SetItem(li_row, 'qualifier', THIS.DataObject)
	iu_MyParent.ids_syntax.SetItem(li_row, 'login', iu_MyParent.i_cCurrUser)
	iu_MyParent.ids_syntax.SetItem(li_row, 'BlbObjctID', ll_blob_ID)
	iu_MyParent.ids_syntax.SetItem(li_row, 'searchtype', ls_searchType)
	iu_MyParent.ids_syntax.SetItem(li_row, 'dynamiccolumns', ls_dynamiccolumn_list)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reset the filters just in case as this instance datastore will have state throughout the application
	//-----------------------------------------------------------------------------------------------------------------------------------
	iu_MyParent.ids_syntax.SetFilter('')
	iu_MyParent.ids_syntax.Filter()
	
End If
end event

event ue_builddatawindow(string as_dataobject);/****************************************************************************************

	Event:	ue_BuildDatawindow
	Purpose:	Build the datawindow look at results to the last saved column positions and
				columns currently set to display in Field Definitions in Table Maintenance
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	10/21/2005 K. Claver   Created
****************************************************************************************/
Blob lblb_dwSyntax
String ls_filter_string, ls_column_list, ls_syntax, ls_dataObject, ls_caseType
String ls_dynamic_columns[ ], ls_searchType
Long ll_blob_ID, ll_pos
Integer li_RowCount, li_arrIdx = 0, li_commaPos

//----------------------------------------------------------------------------------------------------------------------------------
// Store the original syntax in case we want to revert to it
//-----------------------------------------------------------------------------------------------------------------------------------
is_original_syntax = THIS.Object.Datawindow.Syntax

IF IsNull( as_dataObject ) OR Trim( as_dataObject ) = "" THEN
	ls_dataObject = THIS.DataObject
ELSE
	ls_dataObject = as_dataObject
END IF

//Match letter to search type
CHOOSE CASE Upper( gs_seachType )
	CASE 'MEMBER'
		ls_searchType = 'C'
	CASE 'GROUP'
		ls_searchType = 'E'
	CASE 'PROVIDER'
		ls_searchType = 'P'
	CASE 'OTHER'
		ls_searchType = 'O'
	CASE 'CASE'
		ls_searchType = 'S'
	CASE 'APPEAL'
		ls_searchType = 'A'
END CHOOSE

//Attempt to retrieve the blob dataobject from the blobobject table
ls_filter_string =  'qualifier = "' + ls_dataObject + '" and  searchtype = "' + ls_searchType + '"'

iu_MyParent.ids_syntax.SetFilter(ls_filter_string)
iu_MyParent.ids_syntax.Filter()
		
li_RowCount = iu_MyParent.ids_syntax.RowCount()

If li_RowCount > 0 Then
	ll_blob_ID 					= 	iu_MyParent.ids_syntax.GetItemNumber(li_rowCount, 'blbobjctid')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Parse the list of dynamic columns the user had
	//-----------------------------------------------------------------------------------------------------------------------------------
	//If as_dataobject = 'd_search_contact_history' Then
//		ls_dynamic_columns[] 							= 	ls_null[]
//		i_wiu_MyParentWindow.i_sContactHistoryField[]	= 	ls_null_fieldprops[]
//		
//		ls_column_list			=	gn_globals.ids_syntax.GetItemString(ll_rowcount, 'dynamiccolumns')
//		gn_globals.in_string_functions.of_parse_string(ls_column_list, ',', is_dynamic_columns[])
	//End If
	ls_column_list			=	iu_MyParent.ids_syntax.GetItemString(li_rowCount, 'dynamiccolumns')
	
	DO WHILE Trim( ls_column_list ) <> "" AND NOT IsNull( ls_column_list ) 
		//Add another to the array
		li_arrIdx ++
		li_commaPos = Pos( ls_column_list, "," )
		
		//Check if there are any more commas.  If not, just set to the length of the remaining
		//  string so gets the last column
		IF li_commaPos = 0 THEN
			li_commaPos = ( Len( ls_column_list ) + 1 )
		END IF
		
		ls_dynamic_columns[ li_arrIdx ] = Mid( ls_column_list, 1, ( li_commaPos - 1 ) ) 
		
		//Strip off the one we just added
		ls_column_list = Trim( Mid( ls_column_list, ( li_commaPos + 1 ) ) )
	LOOP
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Retrieve the blob that contains the DW syntax and convert it into a string variable
	//-----------------------------------------------------------------------------------------------------------------------------------
	lblb_dwSyntax 	= 	iu_MyParent.in_blob_manipulator.of_retrieve_blob(ll_blob_ID)
	ls_syntax		=	string(lblb_dwSyntax)

	// Make sure we converted it correctly - RAP 11/4/08
	ll_pos = Pos( ls_syntax, "release" )
	IF ll_pos = 0 THEN
		ls_syntax = string(lblb_dwSyntax, EncodingANSI!)
	END IF
	
Else
	ls_syntax = 'none'
End If
	
iu_MyParent.ids_syntax.SetFilter('')
iu_MyParent.ids_syntax.Filter()

//If there's syntax, create using the syntax.  Otherwise, set the dataobject of the datawindow
THIS.SetRedraw( FALSE )
IF ls_syntax <> 'none' THEN
	THIS.Create( ls_syntax )
ELSE
	IF Upper( THIS.DataObject ) <> Upper( ls_DataObject ) THEN
		THIS.DataObject = ls_dataObject
	END IF
END IF

//Add the extra results columns
THIS.Event Trigger ue_addResultsColumns( ls_searchType )

//-----------------------------------------------------------------------------------------------------------------------------------
// Tell the parent to set the rowcount
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.Event ue_notify('set rowcount', This)

//Initialize the column sizing service
gn_globals.in_subscription_service.of_message("After Generate", '', THIS)


THIS.SetRedraw( TRUE )
end event

event ue_addresultscolumns(string as_searchtype);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  THIS - This is a reference to the results datawindow.
//	Overview:   This function takes a datawindow by reference, adds the text headers and columns to the datawindow
//					and recreates the datawindow with the same dynamic columns that were added to the criteria object.
//	Created by:	Joel White
//	History: 	4/13/2005 - First Created 
//					10/23/2005 - Adapted for use with demographics search results
//-----------------------------------------------------------------------------------------------------------------------------------

CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER  cellY = 4
CONSTANT INTEGER  labelY = 8


LONG		l_nColCount, l_nMaxX = 0, l_nX, l_nIndex, l_nPos, ll_largest_x, ll_fromPos
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nTabSeq, li_findRow
INTEGER  l_nNewTabSeq, l_nCellWidth
STRING	l_sColName, l_sModString, l_sMsg, l_cSyntax, l_cObjName, l_cVisible, ls_select
STRING	l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate, ls_filterString
STRING	l_cLabelName, l_cLabelText, ls_result_syntax
STRING   ls_format, ls_formatID, ls_findString, ls_tablePrefix, ls_addToSelect = ""

//Search Type 'S' is for case.  Return for now.  May need to add case properties fields later.
IF as_searchType = 'S' THEN
	iu_MyParent.is_CaseSyntax = THIS.Object.Datawindow.Table.Select
	RETURN
ELSE
	IF iu_MyParent.ids_results_fields.RowCount( ) > 0 THEN
		//Check to see if any of the fields need to be hidden
		ls_filterString = "source_type = '"+as_searchType+"' and display_in_results <> 'Y'"
		iu_MyParent.ids_results_fields.SetFilter( "" )
		iu_MyParent.ids_results_fields.Filter( )
		iu_MyParent.ids_results_fields.SetFilter( ls_filterString )
		iu_MyParent.ids_results_fields.Filter( )
		
		FOR l_nIndex = 1 to iu_MyParent.ids_results_fields.RowCount( )
			// Checks if there's a label for the column
			l_cLabelName = iu_MyParent.ids_results_fields.Object.column_name[ l_nIndex ]
			IF THIS.Describe (l_cLabelName + "_srt.Text") <> "!" THEN
	
				//Set the column to invisible
				THIS.Modify( l_cLabelName + ".Visible=0" )
	
			END IF
		NEXT
	
		ls_filterString = "source_type = '"+as_searchType+"' and display_in_results = 'Y'"
		iu_MyParent.ids_results_fields.SetFilter( ls_filterString )
		iu_MyParent.ids_results_fields.Filter( )
		
		iu_MyParent.ids_results_fields.SetSort( "updated_timestamp A" )
		iu_MyParent.ids_results_fields.Sort( )
		
		//Check to see if any hidden fields need to be shown 
		FOR l_nIndex = 1 to iu_MyParent.ids_results_fields.RowCount( )
			// Checks if there's a label for the column
			l_cLabelName = iu_MyParent.ids_results_fields.Object.column_name[ l_nIndex ]
			IF THIS.Describe (l_cLabelName + "_srt.Text") <> "!" THEN
	
				//Set the column to invisible
				THIS.Modify( l_cLabelName + ".Visible=1" )
	
			END IF
		NEXT
	END IF
END IF

//Match letter to table name for sql modification
CHOOSE CASE Upper( as_searchType )
	CASE 'C'
		ls_tablePrefix = "cusfocus.consumer"
	CASE 'E'
		ls_tablePrefix = "cusfocus.employer_group"
	CASE 'P'
		ls_tablePrefix = "cusfocus.provider_of_service"
	CASE 'O'
		ls_tablePrefix = "cusfocus.other_source"
	CASE 'S'
		ls_tablePrefix = "cusfocus.case_properties"
END CHOOSE

// determine the location of the last predefined column in the datawindow

IF iu_MyParent.ids_results_fields.RowCount( ) > 0 THEN
	l_nColCount = LONG (THIS.Object.Datawindow.Column.Count)
	
	FOR l_nIndex = 1 TO l_nColCount
		l_sColName = THIS.Describe ('#' + STRING (l_nIndex) + '.Name')
		
		//See if the column is in the results fields datastore.  If so, delete from the datastore.
		ls_findString = "Upper(Trim(column_name)) = '"+Upper( Trim( l_sColName ) )+"'"
		li_findRow = iu_MyParent.ids_results_fields.Find( ls_findString, 1, iu_MyParent.ids_results_fields.RowCount( ) )
		IF li_findRow > 0 THEN
			iu_MyParent.ids_results_fields.DeleteRow( li_findRow )
		END IF
		
		l_nX = INTEGER (THIS.Describe("#" + STRING(l_nIndex) + '.X'))

		IF l_nX > l_nMaxX THEN
			l_nMaxX = l_nX
			l_nLastCol = l_nIndex
		END IF
		
		// calculate the highest used Tab Sequence Value
		l_nNewTabSeq = INTEGER (THIS.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	NEXT
	
	//If still have columns, add them
	IF iu_MyParent.ids_results_fields.RowCount( ) > 0 THEN
	
		//Get the x for the next column
		ll_largest_x = INTEGER (THIS.Describe("#" + STRING(l_nLastCol) + '.X')) + INTEGER (THIS.Describe("#" + STRING(l_nLastCol) + '.Width'))
		
		// add the new columns to the result set of the datawindow.
		l_cSyntax = THIS.Describe("DataWindow.Syntax")
		
		// add the new fields
		FOR l_nIndex = 1 TO iu_MyParent.ids_results_fields.RowCount( )
			
				l_sColName = iu_MyParent.ids_results_fields.Object.column_name[ l_nIndex ]
				
				ls_addToSelect += ( ", "+ls_tablePrefix+"."+l_sColName )
				
				// determine the width of the field to be displayed and the next field as well
				IF iu_MyParent.ids_results_fields.Object.field_length[ l_nIndex ] = 0 THEN
					l_nCellWidth = (10 * charwidth)
				ELSE
					l_nCellWidth = (iu_MyParent.ids_results_fields.Object.field_length[ l_nIndex ] * charwidth)
				END IF
	
				l_nPos = Pos(l_cSyntax, "retrieve=")
				l_nPos = l_nPos - 2
			
				l_sModString = 'column=(type=char(50) updatewhereclause=yes ' + &
									'name='+iu_MyParent.ids_results_fields.Object.column_name[ l_nIndex ]+' ' + &
									'dbname="'+l_sColName+'" )' + l_cNewline
				
				uf_StringInsert(l_cSyntax, l_sModString, (l_nPos + 1))
		
				//IF iu_MyParent.ids_results_fields.Object.visible[ l_nIndex ] = "Y" THEN
					//Set the visible variable
					l_cVisible = "1"
					
					l_cLabelX = string(ll_largest_x + 1)
					l_cCellX = l_cLabelX
					
					// add the new column label
					l_nPos = Pos (l_cSyntax, "htmltable") - 1
					l_sModString = 'text(name='+iu_MyParent.ids_results_fields.Object.column_name[ l_nIndex ]+'_srt band=header ' + &
										'font.charset="0" font.face="Tahoma" ' + &
										'font.family="2" font.height="-8" font.pitch="2" font.weight="700" ' + &
										'background.mode="1" background.color="67108864" color="33554432" alignment="1" ' + &
										'border="0" x="'+l_cLabelX+'" y="132" height="60" ' + &
										'width="411" text="'+iu_MyParent.ids_results_fields.Object.field_label[ l_nIndex ]+'" )' + l_cNewLine
					uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
					
				//ELSE
					//l_cVisible = "0"
				//END IF
					
				// prepare to add the new column
				l_nColCount = l_nColCount + 1
				IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable
		
				// add the correct type of field to the datawindow
				l_nPos = Pos (l_cSyntax, "htmltable") - 1
				
				// determine the value for edit.limit
				ls_formatID = iu_MyParent.ids_results_fields.Object.format_id[ l_nIndex ]
				IF NOT IsNull( ls_formatID ) AND Trim( ls_formatID ) <> "" THEN
					li_findRow = iu_MyParent.ids_display_formats.Find( "format_id = '"+ls_formatID+"'", 1, iu_MyParent.ids_display_formats.RowCount( ) )
					
					IF li_findRow > 0 THEN
						ls_format = iu_MyParent.ids_display_formats.Object.edit_mask[ li_findRow ]
					END IF
				ELSE
					ls_format = "[general]"
				END IF				
				
				l_sModString = &
					'column(name='+iu_MyParent.ids_results_fields.Object.column_name[ l_nIndex ]+' band=detail ' + &
					'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
					'y="'+STRING (cellY)+'" height="76" width="'+STRING (l_nCellWidth)+'" color="33554432" ' + &
					'border="0" alignment="0" format="'+ls_format+'" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
					'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
					'edit.codetable=no edit.displayonly=no edit.hscrollbar=no ' + &
					'edit.imemode=0 edit.limit='+STRING (iu_MyParent.ids_results_fields.Object.field_length[ l_nIndex ])+' ' + &
					'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
					'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
					'background.mode="1" background.color="536870912" font.charset="0" ' + &
					'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
					'font.weight="400" tabsequence=0 )' + l_cNewLine
				
				uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
				
				//Reset the largest x to after the new field
				IF l_nCellWidth > 411 THEN
					ll_largest_x += l_nCellWidth
				ELSE
					ll_largest_x += 411 // width of column header
				END IF
		NEXT
		
		// re-initialize the datawindow
		IF THIS.Create (l_cSyntax, l_sMsg) <> 1 THEN
			MessageBox (gs_AppName, l_sMsg)
			iu_MyParent.ids_results_fields.SetFilter( "" )
			iu_MyParent.ids_results_fields.Filter( )
			RETURN 
		ELSE
			THIS.SetTransObject(SQLCA)	
		END IF
	END IF
		
	//Change field labels for fields with label changes
	//First, need to move the deleted rows back to the primary buffer, if there are any
	IF iu_MyParent.ids_results_fields.DeletedCount( ) > 0 THEN
		iu_MyParent.ids_results_fields.RowsMove( 1, iu_MyParent.ids_results_fields.DeletedCount( ), Delete!, &
														iu_MyParent.ids_results_fields, 1, Primary! )
	END IF
	
	FOR l_nIndex = 1 to iu_MyParent.ids_results_fields.RowCount( )
		// apply the new label if appropriate
		l_cLabelName = iu_MyParent.ids_results_fields.Object.column_name[ l_nIndex ] + "_srt"
		IF THIS.Describe (l_cLabelName + ".Text") <> "!" THEN

			// update the label in the preview window if the label item exists
			l_cLabelText = gf_AllowQuotesInLabels (iu_MyParent.ids_results_fields.Object.field_label[ l_nIndex ])
			THIS.Modify (l_cLabelName + ".Text='" + l_cLabelText +"'" )

		END IF
	NEXT
	
	//Don't add to the select for real time as the datawindows are stored proc based and already include all 
	//  of the fields in the result set.
	IF Pos( THIS.DataObject, "_rt" ) = 0 THEN
		//Add the new fields to the select
		ls_select = THIS.Object.Datawindow.Table.Select
		
		IF Trim( ls_select ) <> "" THEN
			ll_fromPos = Pos( Upper( ls_select ), "FROM" )
			
			IF ll_fromPos > 0 THEN
				ls_select = ( Mid( ls_select, 1, ( ll_fromPos - 1 ) )+ls_addToSelect+" "+Mid( ls_select, ll_fromPos ) )
				
				THIS.Object.Datawindow.Table.Select = ls_select
			END IF
		END IF
	END IF
		
END IF

string ls_temp
ls_temp = This.Object.Datawindow.syntax

//Store the new syntax in the instance strings so have the syntax prior to the search mechanism modifying it.
CHOOSE CASE Upper( as_searchType )
	CASE 'C'
		iu_MyParent.is_MemberSyntax = THIS.Object.Datawindow.Table.Select
	CASE 'E'
		iu_MyParent.is_GroupSyntax = THIS.Object.Datawindow.Table.Select
	CASE 'P'
		iu_MyParent.is_ProviderSyntax = THIS.Object.Datawindow.Table.Select
	CASE 'O'
		iu_MyParent.is_OtherSyntax = THIS.Object.Datawindow.Table.Select
	CASE 'A'
		iu_MyParent.is_AppealSyntax = THIS.Object.Datawindow.Table.Select
END CHOOSE

iu_MyParent.ids_results_fields.SetFilter( "" )
iu_MyParent.ids_results_fields.Filter( )
end event

event ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/24/99  M. Caruso     Created.
	9/9/99   M. Caruso     If ENTER key is pressed, RETURN 1 so that the normal ENTER key
	                       functionality does not get processed.
	11/06/00 M. Caruso     Modified to switch to Contact History if searching by case.
	01/12/01 M. Caruso     Added call to fu_opencase ().
	01/13/01 M. Caruso     Add check of i_bInSearch.
	01/16/01 M. Caruso     Added code to cancel search in progress with ESC key.
	3/2/2001 K. Claver     Enhanced to use the new Demographic Security
****************************************************************************************/

LONG		l_nRow
STRING	l_cSourceType, l_cCurrUser

IF iu_MyParent.i_bInSearch THEN
	
	IF key = KeyEscape! THEN
		m_create_maintain_case.m_file.m_cancelsearch.TriggerEvent (clicked!)
	END IF

ELSE
	
	l_nRow = THIS.GetRow()
	IF (key = KeyEnter!) AND (l_nRow > 0) THEN
		
		IF iu_MyParent.dw_search_criteria.Dataobject = "d_search_case" THEN
			l_cSourceType = THIS.GetItemString (l_nRow, "source_type")
			iu_MyParent.i_wParentWindow.fw_buildfieldlist (l_cSourceType)
		END IF
		
		l_cCurrUser = OBJCA.WIN.fu_GetLogin( SQLCA )
		
		IF THIS.dataobject = 'd_matched_cases' Or THIS.dataobject = 'd_matched_cases_caseprops' Or THIS.dataobject = 'd_matched_appeals_props' THEN			
			// Switch to the case tab if searching by case and the user has the proper security level.
			IF iu_MyParent.i_wParentWindow.i_nRepConfidLevel < iu_MyParent.i_wParentWindow.i_nCaseConfidLevel AND &
				l_cCurrUser <> "cfadmin" AND iu_MyParent.i_wParentWindow.i_cCurrCaseRep <> l_cCurrUser THEN
//				JWhite 9.1.2006 SQL2005 Mandates change from sysadmin to cfadmin
//				l_cCurrUser <> "sysadmin" AND i_wParentWindow.i_cCurrCaseRep <> l_cCurrUser THEN
				MessageBox( gs_AppName, "You do not have the proper security level to view this case.", &
								StopSign!, OK! )
								
			ELSEIF iu_MyParent.i_wParentWindow.i_nRepRecConfidLevel >= iu_MyParent.i_wParentWindow.i_nRecordConfidLevel OR &
				IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "cfadmin" THEN
//				JWhite 9.1.2006 SQL2005 Mandates change from sysadmin to cfadmin
//				IsNull( i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN				
				IF NOT IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) THEN
					MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
									"for internal purposes.  You have access to view it.  However, please~r~n"+ &
									"remember that this information is strictly confidential." )
				END IF
				
				iu_MyParent.i_wparentwindow.dw_folder.fu_SelectTab (5)
				i_IgnoreRFC = TRUE // This is set back to FALSE in the rowfocuschanged event - RAP
				iu_MyParent.i_wparentwindow.i_uoCaseDetails.POST fu_opencase ()   // new line
			ELSE
				MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
								"for internal purposes.  You do not have access to view it.", &
								StopSign!, Ok! )
			END IF
		ELSE
			IF iu_MyParent.i_wParentWindow.i_nRepRecConfidLevel >= iu_MyParent.i_wParentWindow.i_nRecordConfidLevel OR &
				IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "cfadmin" THEN
//				9.1.2006	JWhite	SQL2005 Mandates change from sysadmin to cfadmin				
//				IsNull( i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN				
				IF NOT IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) THEN
					MessageBox( gs_AppName, "This Demographic is secured for internal purposes.  You have access to view it.~r~n"+ &
									"However, please remember that this information is strictly confidential." )
				END IF
				
				i_IgnoreRFC = TRUE // This is set back to FALSE in the rowfocuschanged event - RAP
				// otherwise, switch to the Demographics tab.
				iu_MyParent.i_wparentwindow.dw_folder.fu_SelectTab (2)
			ELSE
				MessageBox( gs_AppName, "This Demographic record is secured for internal purposes.~r~n"+ &
								"You do not have access to view it.", StopSign!, Ok! )
			END IF
		END IF
		
		RETURN 1
		
	END IF
	
END IF
end event

event ue_refresh_services();in_datawindow_graphic_service_manager.of_init(dw_matched_records)

in_datawindow_graphic_service_manager.of_destroy_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_show_fields')
in_datawindow_graphic_service_manager.of_destroy_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_sort_service')


in_datawindow_graphic_service_manager.of_add_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_add_service('n_show_fields')
in_datawindow_graphic_service_manager.of_add_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_add_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_add_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_add_service('n_sort_service')

in_datawindow_graphic_service_manager.of_Create_services()




end event

event retrieveend;call super::retrieveend;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      retrievend
// Overrides:  Yes
// Overview:   Refresh the filter object and redirect the event to the rowfocusservice
// Created by: Blake Doerr
// History:    01/26/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_count
Long		ll_null
SetNull(ll_null)


ib_WeAreRetrieving = False

//-----------------------------------------------------------------------------------------------------------------------------------
// This will tell the parent that retrieveend has happened
//-----------------------------------------------------------------------------------------------------------------------------------
io_parent.Event Dynamic ue_notify('retrieveend', Parent)

//-----------------------------------------------------------------------------------------------------------------------------------
// This is an event that will allow the user to do post processing
//-----------------------------------------------------------------------------------------------------------------------------------
/**///Move to Properties should be rule objects
Parent.of_post_retrieve()

//-----------------------------------------------------------------------------------------------------------------------------------
// Tell the parent to set the rowcount
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.Event ue_notify('set rowcount', This)

Parent.of_SetRedraw(True)
end event

event retrievestart;call super::retrievestart;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      retrievestart
// Overrides:  Yes
// Overview:   Connects the datawindow to the database using the reporting transaction object.
// Created by: Joel White
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// If the ancestor rejected the retrieve, return the return value
//-----------------------------------------------------------------------------------------------------------------------------------
if AncestorReturnValue = 1 then Return AncestorReturnValue

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the redraw to false
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.of_SetRedraw(False)

//-----------------------------------------------------------------------------------------------------------------------------------
// Notify the parent that the retrievestart even has happened
//-----------------------------------------------------------------------------------------------------------------------------------
io_parent.Event Dynamic ue_notify('retrievestart', Parent)

//-----------------------------------------------------------------------------------------------------------------------------------
// This will allow the developer to write preprocessing before the retrieve
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.of_pre_retrieve()

//-----------------------------------------------------------------------------------------------------------------------------------
// If the ancestor rejected the retrieve, return the return value
//-----------------------------------------------------------------------------------------------------------------------------------
if AncestorReturnValue = 2 then Return AncestorReturnValue

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the retrieval time for statistics
//-----------------------------------------------------------------------------------------------------------------------------------
/**///Move to Properties
Properties.of_set('RetrieveStartDateTime', gn_globals.in_string_functions.of_convert_datetime_to_string(DateTime(Today(), Now())))

end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
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
long ll_return
boolean lb_current_refresh_state
string ls_RecurrenceString

Choose Case Lower(Trim(as_message))
	Case 'horizontalsplitscrolling'
		If IsValid(This.Object) Then
			This.HSplitScroll = Not This.HSplitScroll
			If This.HSplitScroll Then 
				This.Object.DataWindow.HorizontalScrollSplit = 500
			End If
		End If
		
	Case 'toggle autorefresh data', 'set autorefresh time'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Store the current refresh state so that it can be restored if the user cancels out of the window
		//-----------------------------------------------------------------------------------------------------------------------------------
		lb_current_refresh_state = ib_AutoRefreshIsOn

		If Lower(Trim(as_message)) = 'toggle autorefresh data' Then
			ib_AutoRefreshIsOn = Not ib_AutoRefreshIsOn
			If Not ib_AutoRefreshIsOn Then
				If IsValid(in_timer) Then Destroy in_timer
				Parent.Dynamic Event ue_notify('set rowcount', '')
				Return
			End If
		End If
		
		ib_AutoRefreshIsOn = True

		OpenWithParm(lw_window, is_RecurrenceString, 'w_recurrence', w_mdi)
		ls_RecurrenceString = Message.StringParm
		ll_return = Message.DoubleParm
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the user cancelled out of the window, then restore the refresh state
		//-----------------------------------------------------------------------------------------------------------------------------------
		if ll_return = -1 then 
			ib_AutoRefreshIsOn = lb_current_refresh_state
			Return
		End IF

		If IsNull(ls_RecurrenceString) Or ls_RecurrenceString = '' Then
			is_RecurrenceString = ''
			ib_AutoRefreshIsOn = False
			Parent.Dynamic Event ue_notify('set rowcount', '')
			Return
		else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Store the new recurrence pattern
			//-----------------------------------------------------------------------------------------------------------------------------------
			is_RecurrenceString = ls_RecurrenceString
		End If
		
		This.Event ue_notify('reset timer', '')
		
	Case 'reset timer'
		If IsValid(in_timer) Then Destroy in_timer
		
		If Not ib_AutoRefreshIsOn Then Return
		
		gn_globals.in_string_functions.of_replace_argument('StartDate', is_RecurrenceString, '||', String(Today()))
		gn_globals.in_string_functions.of_replace_argument('StartTime', is_RecurrenceString, '||', String(Now()))

//		ln_recurrence = Create n_recurrence
//		idt_NextRefresh = ln_recurrence.of_determine_datetime(is_RecurrenceString, True)
//		Destroy ln_recurrence
		in_timer = Create n_timer
		in_timer.of_set_event(This, 'ue_timer')
		in_timer.of_start(5)
		This.Event ue_notify('set rowcount', '')
End Choose

end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
	Event:	doubleclicked
	Purpose:	automatically switch to the Demographics tab when the user double-clicks on an
            entry in the mathced records list.
			  
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	7/29/99  M. Caruso     If search type = CASE, build the field list according to the
								  source type of the select case.
	12/20/99 M. Caruso     Only process if row > 0
	11/06/00 M. Caruso     Modified to switch to Contact History if searching by case.
	01/12/01 M. Caruso     Added call to fu_opencase ().
	01/13/01 M. Caruso     Add check of i_bInSearch.
	3/2/2001 K. Claver     Enhanced for new Demographic Security.
	08/27/03 M. Caruso     Updated to work with the real-time provider demographics.
*****************************************************************************************/

LONG l_nRow
STRING	l_cSourceType, l_cCurrUser

IF (row > 0) AND NOT iu_MyParent.i_bInSearch THEN
	IF iu_MyParent.dw_search_criteria.Dataobject = "d_search_case" THEN
		l_cSourceType = dw_matched_records.GetItemString (row, "source_type")
		iu_MyParent.i_wparentwindow.fw_buildfieldlist (l_cSourceType)
	END IF
	
	l_cCurrUser = OBJCA.WIN.fu_GetLogin( SQLCA )
	
	IF dataobject = 'd_matched_cases' or dataobject = 'd_matched_cases_caseprops' or dataobject = 'd_matched_appeals_props' THEN
		// Switch to the case tab if searching by case and the user has the proper security level.
		IF iu_MyParent.i_wParentWindow.i_nRepConfidLevel < iu_MyParent.i_wParentWindow.i_nCaseConfidLevel AND &
			l_cCurrUser <> "cfadmin" AND iu_MyParent.i_wParentWindow.i_cCurrCaseRep <> l_cCurrUser THEN
//			9.1.2006 JWhite	SQL2005 Mandates change from sysadmin to cfadmin			
//			l_cCurrUser <> "sysadmin" AND i_wParentWindow.i_cCurrCaseRep <> l_cCurrUser THEN
			MessageBox( gs_AppName, "You do not have the proper security level to view this case.", &
							StopSign!, OK! )
							
		ELSEIF iu_MyParent.i_wParentWindow.i_nRepRecConfidLevel >= iu_MyParent.i_wParentWindow.i_nRecordConfidLevel OR &
			IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "cfadmin" THEN
//			9.1.2006 JWhite	SQL2005 Mandates change from sysadmin to cfadmin
//			IsNull( i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN
			
			IF NOT IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) THEN
				MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
								"for internal purposes.  You have access to view it.  However, please~r~n"+ &
								"remember that this information is strictly confidential." )
			END IF
			
			iu_MyParent.i_wparentwindow.dw_folder.fu_SelectTab (5)
			iu_MyParent.i_wparentwindow.i_uoCaseDetails.POST fu_opencase ()   // new line
		ELSE
			MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
							"for internal purposes.  You do not have access to view it.", &
							StopSign!, OK! )
		END IF
	ELSE
		
		IF dataobject = 'd_matched_providers' OR dataobject = 'd_matched_providers_rt' THEN
			l_nRow = THIS.GetRow()
			iu_MyParent.i_wParentWindow.i_nProviderKey = GetItemNumber(l_nRow,'provider_of_service_provider_key')
		END IF
		
		IF iu_MyParent.i_wParentWindow.i_nRepRecConfidLevel >= iu_MyParent.i_wParentWindow.i_nRecordConfidLevel OR &
			IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN
//			9.1.2006 JWhite	SQL2005 Mandates change from sysadmin to cfadmin
//			IsNull( i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN
			
			IF NOT IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) THEN
				MessageBox( gs_AppName, "This Demographic record is secured for internal purposes.  You have access to view it.~r~n"+ &
								"However, please remember that this information is strictly confidential." )
			END IF
			
			// otherwise, switch to the Demographics tab.
			iu_MyParent.i_wparentwindow.dw_folder.fu_SelectTab (2)
		ELSE
			MessageBox( gs_AppName, "This Demographic record is secured for internal purposes.~r~n"+ &
							"You do not have access to view it.", StopSign!, OK! )
		END IF
	END IF
END IF
end event

event pcd_close;call super::pcd_close;//*********************************************************************************************
//
//  Event:   pcd_close
//  Purpose: To provide opportunity to do processing before the window closes
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/22/2005 K. Claver Added code to save the matched records dw syntax
//*********************************************************************************************

//Save the datawindow syntax so the user will have the same settings the next time they open
//  the window
THIS.Event Trigger ue_saveDatawindow( )
end event

event retrieverow;call super::retrieverow;/*****************************************************************************************
   Event:      retrieverow
   Purpose:    Occurs after a row has been retrieved.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/01/00 M. Caruso    Created.
*****************************************************************************************/

IF iu_MyParent.i_bcancelsearch THEN
	RETURN 1
ELSE
	RETURN 0
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize the datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/27/00 M. Caruso    Created, to set resize code.
	12/11/03 M. Caruso    Set the i_ShowZeroSearchRowsPrompt instance variable.
*****************************************************************************************/

of_SetResize (TRUE)
IF IsValid (iu_MyParent.inv_resize) THEN
	
	// make the separator line resizeable
//???	iu_MyParent.inv_resize.of_Register ("l_1", "ScaleToRight")
	iu_MyParent.fu_resizeline ()
	this.i_ShowZeroSearchRowsPrompt = FALSE
	
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;//*********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: To retrieve the data, set appropriate tabs and select appropriate 
//           rows.
//						
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  05/24/99 M. Caruso     If only one row is retrieved, automatically switch to the
//                         Demographics screen.
//  05/28/99 M. Caruso     Commented out the above change and moved it to
//                         w_create_maintain_case.pc_search()
//  04/25/00 C. Jackson    Add m_closecase.Enabled = FALSE (SCR 493)
//  07/14/00 M. Caruso     Moved the code to disable the close case menu item so that it
//									applies to all search types.
//  10/17/00 M. Caruso     Modified CASE 'd_matched_cases' to enable tab 5 only, regardless of
//									the case type.
//  01/13/01 M. Caruso     Disable search and clear search criteria menu items during a search.
//  01/14/01 M. Caruso     Disable Tabs 2-4 during search to prevent premature switching. Tabs
//									are enabled in w_create_maintain_case.pc_search based on search
//									results. Also, set the i_bInSearch varible to control other
//									functions while searching.
//  3/2/2001 K. Claver     Enhanced to use the new Demographic Security.  Commented out code to
//									automatically enable the case tab if rows are returned for a case search.
//  04/09/01 C. Jackson    Commented out the setting of the window title.  Handled in 
//                         w_create_maintain_case.dw_folder.po_tabclicked.
//  05/21/01 M. Caruso     Added code to pass rep security level as a parameter for all queries
//                         except "Search by Case".
//  07/13/01 C. Jackson    Correct embedded SQL for getting the provider_id from the 
//                         provider_of_service table (SCRs 2160, 2161).  Also, grab the vendor_id
//                         from provider_of_service if this is a provider case, and a provider_id
//                         is not returned in the SQL Select.
//  07/20/01 C. Jackson    Add convert for getting the provider key for Sybase.
//  07/24/01 M. Caruso     Turn off screen refreshing until the retrieval is complete.
//  08/29/03 M. Caruso     Added code to set i_cProviderID and i_cVendorID when the new
//								   case subject is a provider.
//*********************************************************************************************

LONG 		l_nReturn, l_nSelectedRow[1]
STRING   l_cHoldSubjectID
string 	ls_dataobject, ls_syntax

SetRedraw (FALSE)

iu_MyParent.i_bCancelSearch = FALSE
m_create_maintain_case.m_file.m_cancelsearch.enabled = TRUE
m_create_maintain_case.m_file.m_search.enabled = FALSE
m_create_maintain_case.m_file.m_clearsearchcriteria.enabled = FALSE
iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab (2)
iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab (3)
iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab (4)
iu_MyParent.i_bInSearch = TRUE

// Perform the appropriate retrieval

ls_dataobject = DataObject
THIS.SetTransObject(SQLCA)

CHOOSE CASE DataObject
//??	CASE 'd_matched_cases'
//??		l_nReturn = Retrieve()
		
	CASE 'd_matched_cases_caseprops'	, 'd_matched_cases'
		l_nReturn = iu_MyParent.of_retrieve()
			
	CASE 'd_matched_appeals_props'	
		l_nReturn = iu_MyParent.of_retrieve_appeal()
			
	CASE 'd_matched_consumers_rt'
		l_nReturn = Retrieve(iu_MyParent.i_cRealTimeArg[1], iu_MyParent.i_cRealTimeArg[2], iu_MyParent.i_cRealTimeArg[3], iu_MyParent.i_cRealTimeArg[4], &
									iu_MyParent.i_cRealTimeArg[5], iu_MyParent.i_cRealTimeArg[6], iu_MyParent.i_cRealTimeArg[7], iu_MyParent.i_cRealTimeArg[8], &
								   iu_MyParent.i_cRealTimeArg[9], iu_MyParent.i_cRealTimeArg[10], iu_MyParent.i_cRealTimeArg[11], iu_MyParent.i_cRealTimeArg[12], &
								   iu_MyParent.i_cRealTimeArg[13], iu_MyParent.i_cRealTimeArg[14], iu_MyParent.i_cRealTimeArg[15], iu_MyParent.i_cRealTimeArg[16], &
								   iu_MyParent.i_cRealTimeArg[17], iu_MyParent.i_cRealTimeArg[18], iu_MyParent.i_cRealTimeArg[19], iu_MyParent.i_cRealTimeArg[20], &
								   iu_MyParent.i_cRealTimeArg[21], iu_MyParent.i_cRealTimeArg[22], iu_MyParent.i_cRealTimeArg[23], iu_MyParent.i_cRealTimeArg[24], &
								   iu_MyParent.i_cRealTimeArg[25], iu_MyParent.i_cRealTimeArg[26], iu_MyParent.i_cRealTimeArg[27], iu_MyParent.i_cRealTimeArg[28], &
								   iu_MyParent.i_cRealTimeArg[29], iu_MyParent.i_cRealTimeArg[30], iu_MyParent.i_cRealTimeArg[31], iu_MyParent.i_cRealTimeArg[32], &
								   iu_MyParent.i_cRealTimeArg[33], iu_MyParent.i_cRealTimeArg[34], iu_MyParent.i_cRealTimeArg[35], iu_MyParent.i_cRealTimeArg[36], &
								   iu_MyParent.i_cRealTimeArg[37], iu_MyParent.i_cRealTimeArg[38])
			
	CASE 'd_matched_providers_rt'
		l_nReturn = Retrieve(iu_MyParent.i_cRealTimeArg[1], iu_MyParent.i_cRealTimeArg[2], iu_MyParent.i_cRealTimeArg[3], iu_MyParent.i_cRealTimeArg[4], &
								   iu_MyParent.i_cRealTimeArg[5], iu_MyParent.i_cRealTimeArg[6], iu_MyParent.i_cRealTimeArg[7], iu_MyParent.i_cRealTimeArg[8], &
								   iu_MyParent.i_cRealTimeArg[9], iu_MyParent.i_cRealTimeArg[10], iu_MyParent.i_cRealTimeArg[11], iu_MyParent.i_cRealTimeArg[12], &
								   iu_MyParent.i_cRealTimeArg[13], iu_MyParent.i_cRealTimeArg[14], iu_MyParent.i_cRealTimeArg[15], iu_MyParent.i_cRealTimeArg[16], &
								   iu_MyParent.i_cRealTimeArg[17], iu_MyParent.i_cRealTimeArg[18], iu_MyParent.i_cRealTimeArg[19], iu_MyParent.i_cRealTimeArg[20], &
								   iu_MyParent.i_cRealTimeArg[21], iu_MyParent.i_cRealTimeArg[22], iu_MyParent.i_cRealTimeArg[23], iu_MyParent.i_cRealTimeArg[24], &
								   iu_MyParent.i_cRealTimeArg[25], iu_MyParent.i_cRealTimeArg[26], iu_MyParent.i_cRealTimeArg[27], iu_MyParent.i_cRealTimeArg[28], &
								   iu_MyParent.i_cRealTimeArg[29], iu_MyParent.i_cRealTimeArg[30], iu_MyParent.i_cRealTimeArg[31], iu_MyParent.i_cRealTimeArg[32], &
								   iu_MyParent.i_cRealTimeArg[33], iu_MyParent.i_cRealTimeArg[34], iu_MyParent.i_cRealTimeArg[35], iu_MyParent.i_cRealTimeArg[36], &
								   iu_MyParent.i_cRealTimeArg[37], iu_MyParent.i_cRealTimeArg[38], iu_MyParent.i_cRealTimeArg[39], iu_MyParent.i_cRealTimeArg[40])
			
	CASE 'd_matched_employers_rt'
		l_nReturn = Retrieve(iu_MyParent.i_cRealTimeArg[1], iu_MyParent.i_cRealTimeArg[2], iu_MyParent.i_cRealTimeArg[3], iu_MyParent.i_cRealTimeArg[4], &
								   iu_MyParent.i_cRealTimeArg[5], iu_MyParent.i_cRealTimeArg[6], iu_MyParent.i_cRealTimeArg[7], iu_MyParent.i_cRealTimeArg[8], &
								   iu_MyParent.i_cRealTimeArg[9], iu_MyParent.i_cRealTimeArg[10], iu_MyParent.i_cRealTimeArg[11], iu_MyParent.i_cRealTimeArg[12], &
								   iu_MyParent.i_cRealTimeArg[13], iu_MyParent.i_cRealTimeArg[14], iu_MyParent.i_cRealTimeArg[15], iu_MyParent.i_cRealTimeArg[16], &
								   iu_MyParent.i_cRealTimeArg[17], iu_MyParent.i_cRealTimeArg[18], iu_MyParent.i_cRealTimeArg[19], iu_MyParent.i_cRealTimeArg[20], &
								   iu_MyParent.i_cRealTimeArg[21], iu_MyParent.i_cRealTimeArg[22], iu_MyParent.i_cRealTimeArg[23], iu_MyParent.i_cRealTimeArg[24], &
								   iu_MyParent.i_cRealTimeArg[25], iu_MyParent.i_cRealTimeArg[26], iu_MyParent.i_cRealTimeArg[27], iu_MyParent.i_cRealTimeArg[28], &
								   iu_MyParent.i_cRealTimeArg[29], iu_MyParent.i_cRealTimeArg[30], iu_MyParent.i_cRealTimeArg[31], iu_MyParent.i_cRealTimeArg[32], &
								   iu_MyParent.i_cRealTimeArg[33], iu_MyParent.i_cRealTimeArg[34], iu_MyParent.i_cRealTimeArg[35])
			
	CASE ELSE
		ls_syntax = THIS.object.datawindow.syntax
		l_nReturn = Retrieve(iu_MyParent.i_wParentWindow.i_nRepRecConfidLevel)
			
END CHOOSE

m_create_maintain_case.m_file.m_cancelsearch.enabled = FALSE
m_create_maintain_case.m_file.m_search.enabled = TRUE
m_create_maintain_case.m_file.m_clearsearchcriteria.enabled = TRUE
iu_MyParent.i_bInSearch = FALSE

m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE

CHOOSE CASE l_nReturn
	CASE IS < 0
		Error.i_FWError = c_Fatal
		
	CASE 0
		Error.i_FWError = c_Success
		
	CASE ELSE
		Error.i_FWError = c_Success
		iu_MyParent.i_wParentWindow.i_bDemographicUpdate  = TRUE
		iu_MyParent.i_wParentWindow.i_bCaseDetailUpdate   = TRUE
	
		CHOOSE CASE DataObject
			CASE 'd_matched_cases', 'd_matched_cases_caseprops'
	
				IF iu_MyParent.i_wParentWindow.i_cCurrentCase = '' OR iu_MyParent.i_wParentWIndow.i_cSelectedCase = '' THEN
					
					// If there is no current case then get the information from the first row.
					l_nSelectedRow[1] = 1
					fu_SetSelectedRows(1, l_nSelectedRow[], c_IgnoreChanges, c_NoRefreshChildren)
					iu_MyParent.i_wPArentWindow.i_cSelectedCase = GetItemSTring(1, 'case_number')		
					iu_MyParent.i_wParentWindow.i_cSourceType = GetItemSTring(1, 'source_type')
					iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemSTring(1, 'case_subject_id')

					IF iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceProvider THEN
						iu_MyParent.i_wParentWindow.i_cProviderKey = iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject
						iu_MyParent.i_wParentWindow.i_nProviderKey = Long( iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject )
						iu_MyParent.i_wParentWindow.i_cProviderType = GetItemString(1, 'source_provider_type')
						
						SELECT provider_id, vendor_id INTO :iu_MyParent.i_wParentWindow.i_cProviderId, :iu_MyParent.i_wParentWindow.i_cVendorId
						FROM   cusfocus.provider_of_service
						WHERE  provider_key = :iu_MyParent.i_wParentWindow.i_nProviderKey
						USING  SQLCA;
												
						SELECT provider_id INTO :l_cHoldSubjectID
						  FROM cusfocus.provider_of_service
						 WHERE provider_key = CONVERT(int,:iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject)
						 USING SQLCA;
						 
						IF ISNULL(l_cHoldSubjectID) OR l_cHoldSubjectID = '' THEN
							// this case subject must be a vendor, get the vendor id
							SELECT vendor_id INTO :iu_MyParent.i_wParentWindow.i_cVendorID
							  FROM cusfocus.provider_of_service
							 WHERE provider_key = CONVERT(int,:iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject)
							 USING SQLCA;
							 
							iu_MyParent.i_wParentWindow.i_bVendorCase = TRUE
							 
						ELSE 
							iu_MyParent.i_wParentWindow.i_cProviderID = l_cHoldSubjectID
							iu_MyParent.i_wParentWindow.i_bVendorCase = FALSE
							
						END IF						
						 
					END IF
					iu_MyParent.i_wParentWindow.i_cCaseType = GetItemSTring(1, 'case_type')
					iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(1, 'case_log_source_name')
	
				ELSE
					
					// Find the current case in the datawindow and select that row.  
					l_nSelectedRow[1] = Find("case_number = '" + iu_MyParent.i_wParentWindow.i_cCurrentCase + &
						"'", 1, RowCount())
					IF l_nSelectedRow[1] > 0 THEN
						fu_SetSelectedRows(1, l_nSelectedRow[], c_IgnoreChanges, c_NoRefreshChildren)
					END IF
					iu_MyParent.i_wParentWindow.i_cSelectedCase = iu_MyParent.i_wParentWindow.i_cCurrentCase
					
				END IF
	
				// Enable the Case tab
//				i_wParentWindow.dw_folder.fu_EnableTab (5)
	
			CASE 'd_matched_consumers', 'd_matched_consumers_rt'
				iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString(1, 'consumer_id')
				iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceConsumer
				iu_MyParent.i_wParentWindow.i_cSelectedCase = ''
	
				IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
					iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
				END IF
				
				iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(1, 'consumer_name')
	
			CASE 'd_matched_employers', 'd_matched_employers_rt'
				iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString(1, 'group_id')
				iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceEmployer
				iu_MyParent.i_wParentWindow.i_cSelectedCase = ''
	
				IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
					iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
				END IF
	
				iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(1, 'employ_group_name')		
	
			CASE 'd_matched_providers', 'd_matched_providers_rt'
				iu_MyParent.i_wParentWindow.i_nProviderKey = GetItemNumber(1, 'provider_of_service_provider_key')
				iu_MyParent.i_wParentWindow.i_cProviderKey = String( iu_MyParent.i_wParentWindow.i_nProviderKey )
				iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = STRING(iu_MyParent.i_wParentWindow.i_nProviderKey)
				iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceProvider
				iu_MyParent.i_wParentWindow.i_cProviderId = GetItemString(1, 'provider_id')
				iu_MyParent.i_wParentWindow.i_cVendorId = GetItemString(1, 'vendor_id')
				iu_MyParent.i_wParentWindow.i_cProviderType = GetItemString(1, 'provider_type')
				iu_MyParent.i_wParentWindow.i_cSelectedCase = ''
	
				IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
					iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
				END IF
	
				iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(1, 'provid_name')
				IF IsNull(iu_MyParent.i_wParentWindow.i_cCaseSubjectName) THEN
					iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(1, 'provid_name_2')
				END IF
				IF IsNull(iu_MyParent.i_wParentWindow.i_cCaseSubjectName) THEN
					iu_MyParent.i_wParentWindow.i_cCaseSubjectName = ''
				END IF
				
			CASE 'd_matched_others'
	
				IF NOT iu_MyParent.i_wParentWindow.i_bSearchCriteriaUpdate THEN
	
					iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString(1, 'customer_id')
					iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceOther	
					iu_MyParent.i_wParentWindow.i_cSelectedCase = ''
	
					IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
						iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
					END IF
	
					iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(1, 'other_name')
	
				ELSE

	//--------------------------------------------------------------------------------------
	//		If the user just created a new case subject and they also happen to have Other
	//		search criteria select, then select that New Case Subject.
	//--------------------------------------------------------------------------------------
					IF iu_MyParent.i_wParentWindow.i_bNewCaseSubject THEN
						l_nSelectedRow[1] = Find("customer_id = '" + &
							iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject + "'", 1, RowCount())
						IF l_nSelectedRow[1] > 0 THEN
							fu_SetSelectedRows(1, l_nSelectedRow[], c_IgnoreChanges, c_NoRefreshChildren)
						END IF
					ELSE
						l_nSelectedRow[1] = 1
						fu_SetSelectedRows(1, l_nSelectedRow[], c_IgnoreChanges, c_NoRefreshChildren)
	
						iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString(1, 'customer_id')
						iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceOther	
						iu_MyParent.i_wParentWindow.i_cSelectedCase = ''
	
						IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
							iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
						END IF
	
						iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(1, 'other_name')
						 
					END IF
	
				END IF
			
		END CHOOSE
		

END CHOOSE

SetRedraw (TRUE)
end event

event pcd_pickedrow;call super::pcd_pickedrow;//****************************************************************************************
//
//		Event:	pcd_pickedrow
//		Purpose:	To determine what row the user selected and get the appropriate info and
//					to enable/disable tabs.
//						
//	 Date     Developer    Description
//	 -------- ------------ ----------------------------------------------------------------
//	 02/23/00 C. Jackson   Added logic for refreshing the Docs Quick Interface Window if open
//  03/24/00 C. Jackson   Corrected for Consumers - need to pull group information from the 
//                        Document Ownership table.  (SCR 407)
//  03/29/00 C. Jackson   Removed case statement that caused the title to only populate with
//                        the entity's name if there were documents associated with that entity
//  03/30/00 C. Jackson   Correct retrieval so that whenever a new 'Source' is selected, the list
//                        datawindow for Documents Quick Interface is re-retrieved. (SCR 436)
//  06/29/00 C. Jackson   Comment out the enabling of tabs 3 - 6.  They should never be enabled
//								  on the search screen.  (SCR 686)
//  3/2/2001 K. Claver    Enhanced for new Demographic Security.
//  4/5/2001 K. Claver    Added code to store the case confidentiality level.
//  04/09/01 C. Jackson   Comment out the changing of the window title.  Handles in
//                        w_create_maintain_case
//  08/27/03 M. Caruso    Added references to real-time data objects in the CASE statement
//								  for setting instance variables.
//  08/29/03 M. Caruso    Added code to set i_cProviderID and i_cVendorID when the new
//								  case subject is a provider.
//**************************************************************************************/
STRING l_cSourceType, l_cCurrentCaseSubject, l_cTitle, l_cFirstName, l_cLastName, l_cEntity
STRING l_cNewSourceType, l_cGroupID, l_cNewCaseSubject, l_cCurrUser
LONG l_nReturn

iu_MyParent.i_wParentWindow.i_bDemographicUpdate = TRUE
iu_MyParent.i_wParentWindow.i_bCaseDetailUpdate = TRUE
iu_MyParent.i_wParentWIndow.dw_folder.fu_EnableTab(2)

CHOOSE CASE DataObject
	CASE 'd_matched_cases', 'd_matched_cases_caseprops'
		iu_MyParent.i_wParentWindow.i_cSelectedCase = GetItemString (i_CursorRow, 'case_number')
		iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString (i_CursorRow, 'case_subject_id')
		iu_MyParent.i_wParentWindow.i_cSourceType = GetItemString (i_CursorRow, 'source_type')
		  
		IF iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceProvider THEN
			iu_MyParent.i_wParentWindow.i_nProviderKey = Long( iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject )
			iu_MyParent.i_wParentWindow.i_cProviderKey = iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject
			iu_MyParent.i_wParentWindow.i_cProviderType = GetItemString (i_CursorRow, 'source_provider_type')
			
			SELECT provider_id, vendor_id INTO :iu_MyParent.i_wParentWindow.i_cProviderId, :iu_MyParent.i_wParentWindow.i_cVendorId
			FROM   cusfocus.provider_of_service
			WHERE  provider_key = :iu_MyParent.i_wParentWindow.i_nProviderKey
			USING  SQLCA;
			
		END IF

		iu_MyParent.i_wParentWindow.i_cCaseType = GetItemString (i_CursorRow, 'case_type')
		iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString (i_CursorRow, 'case_log_source_name')
	
		iu_MyParent.i_wParentWindow.i_nCaseConfidLevel = THIS.GetItemNumber( i_CursorRow, "confidentiality_level" )
		iu_MyParent.i_wParentWindow.i_cCurrCaseRep = THIS.GetItemString( i_CursorRow, "case_log_case_log_case_rep" )
		
		//Get the record security level
		iu_MyParent.i_wParentWindow.i_nRecordConfidLevel = iu_MyParent.fu_GetRecConfidLevel( iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject, &
																						 		  iu_MyParent.i_wParentWindow.i_cSourceType )

	CASE 'd_matched_appeals_props'
		String ls_source_name, ls_case_type, ls_case_subject_id, ls_source_provider_type, ls_source_type, ls_case_rep,  ls_case_number
		Integer li_confidentiality_level
		
		ls_case_number = GetItemString (i_CursorRow, 'case_number')

		SELECT
			cusfocus.case_log.source_name ,
			cusfocus.case_log.case_type ,
			cusfocus.case_log.case_subject_id ,
			cusfocus.case_log.source_provider_type ,
			cusfocus.case_log.source_type ,
			cusfocus.case_log.case_log_case_rep ,
			cusfocus.case_log.confidentiality_level 
		INTO
			:ls_source_name ,
			:ls_case_type ,
			:ls_case_subject_id ,
			:ls_source_provider_type ,
			:ls_source_type ,
			:ls_case_rep ,
			:li_confidentiality_level 
	    FROM 
			cusfocus.case_log
		WHERE
			cusfocus.case_log.case_number = :ls_case_number
		USING SQLCA;

		iu_MyParent.i_wParentWindow.i_cSelectedCase = ls_case_number
		iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = ls_case_subject_id
		iu_MyParent.i_wParentWindow.i_cSourceType = ls_source_type
		  
		IF iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceProvider THEN
			iu_MyParent.i_wParentWindow.i_nProviderKey = Long( iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject )
			iu_MyParent.i_wParentWindow.i_cProviderKey = iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject
			iu_MyParent.i_wParentWindow.i_cProviderType = ls_source_provider_type
			
			SELECT provider_id, vendor_id INTO :iu_MyParent.i_wParentWindow.i_cProviderId, :iu_MyParent.i_wParentWindow.i_cVendorId
			FROM   cusfocus.provider_of_service
			WHERE  provider_key = :iu_MyParent.i_wParentWindow.i_nProviderKey
			USING  SQLCA;
			
		END IF

		iu_MyParent.i_wParentWindow.i_cCaseType = ls_case_type
		iu_MyParent.i_wParentWindow.i_cCaseSubjectName = ls_source_name
	
		iu_MyParent.i_wParentWindow.i_nCaseConfidLevel = li_confidentiality_level
		iu_MyParent.i_wParentWindow.i_cCurrCaseRep = ls_case_rep
		
		//Get the record security level
		iu_MyParent.i_wParentWindow.i_nRecordConfidLevel = iu_MyParent.fu_GetRecConfidLevel( iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject, &
																						 		  iu_MyParent.i_wParentWindow.i_cSourceType )

	CASE 'd_matched_consumers', 'd_matched_consumers_rt'
		iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString(i_CursorRow, 'consumer_id')
		iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceConsumer
		iu_MyParent.i_wParentWindow.i_cSelectedCase = ''
	
		iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(i_CursorRow, 'consumer_name')
		
		IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
				iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
		END IF
		
		//Get the record security level
		iu_MyParent.i_wParentWindow.i_nRecordConfidLevel = THIS.Object.confidentiality_level[ i_CursorRow ]
	
	CASE 'd_matched_employers', 'd_matched_employers_rt'
		iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString(i_CursorRow, 'group_id')
		iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceEmployer
		iu_MyParent.i_wParentWindow.i_cSelectedCase = ''

		IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
			iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
		END IF

		iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(i_CursorRow, 'employ_group_name')
		
		//Get the record security level
		iu_MyParent.i_wParentWindow.i_nRecordConfidLevel = THIS.Object.confidentiality_level[ i_CursorRow ]

	CASE 'd_matched_providers', 'd_matched_providers_rt'
		iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = STRING(GetItemNumber(i_CursorRow, 'provider_of_service_provider_key'))
		iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceProvider				
		
		iu_MyParent.i_wParentWindow.i_nProviderKey = GetItemNumber(i_CursorRow,'provider_of_service_provider_key')
		iu_MyParent.i_wParentWindow.i_cProviderId = GetItemString(1, 'provider_id')
		iu_MyParent.i_wParentWindow.i_cVendorId = GetItemString(1, 'vendor_id')
		iu_MyParent.i_wParentWindow.i_cProviderKey = String( iu_MyParent.i_wParentWindow.i_nProviderKey )
		
		iu_MyParent.i_wParentWindow.i_cProviderType = GetItemString(i_CursorRow, 'provider_type')
		iu_MyParent.i_wParentWindow.i_cSelectedCase = ''
		
		IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
			iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
		END IF

		iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(i_CursorRow, 'provid_name')
		
		//Get the record security level
		iu_MyParent.i_wParentWindow.i_nRecordConfidLevel = THIS.Object.confidentiality_level[ i_CursorRow ]

	CASE 'd_matched_others'
		iu_MyParent.i_wParentWindow.i_cCurrentCaseSubject = GetItemString(i_CursorRow, 'customer_id')
		iu_MyParent.i_wParentWindow.i_cSourceType = iu_MyParent.i_wParentWindow.i_cSourceOther
		iu_MyParent.i_wParentWindow.i_cSelectedCase = ''

		IF NOT iu_MyParent.i_wParentWindow.i_bNeedCaseSubject THEN
			iu_MyParent.i_wParentWindow.i_cCurrentCase = ''
		END IF

		iu_MyParent.i_wParentWindow.i_cCaseSubjectName = GetItemString(i_CursorRow, 'other_name')
		
		//Get the record security level
		iu_MyParent.i_wParentWindow.i_nRecordConfidLevel = THIS.Object.confidentiality_level[ i_CursorRow ]
		
END CHOOSE

l_cCurrUser = OBJCA.WIN.fu_GetLogin( SQLCA )

IF iu_MyParent.i_wParentWindow.i_nRepRecConfidLevel >= iu_MyParent.i_wParentWindow.i_nRecordConfidLevel OR &
   IsNull( iu_MyParent.i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "cfadmin" THEN
//		JWhite 9.1.2006	SQL2005 Mandates change from sysadmin to cfadmin
//   IsNull( i_wParentWindow.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN
	//Enable the tabs as the current rep has the proper security to view the
	//  case as a result of having the proper security to view the demographic record.
	iu_MyParent.i_wParentWindow.dw_folder.fu_EnableTab( 2 )
	iu_MyParent.i_wParentWindow.dw_folder.fu_EnableTab( 3 )
	iu_MyParent.i_wParentWindow.dw_folder.fu_EnableTab( 4 )
	
	//If the user has the proper case security, enable the case tab.
	IF (THIS.DataObject = "d_matched_cases" Or THIS.DataObject = "d_matched_cases_caseprops" Or THIS.DataObject = "d_matched_appeals_props") AND &
	   ( iu_MyParent.i_wParentWindow.i_nRepConfidLevel >= iu_MyParent.i_wParentWindow.i_nCaseConfidLevel OR & 
		  iu_MyParent.i_wParentWindow.i_cCurrCaseRep = l_cCurrUser OR l_cCurrUser = "cfadmin" ) THEN
//		 JWhite 9.1.2006	SQL2005 Mandates change from sysadmin to cfadmin		  
//		  i_wParentWindow.i_cCurrCaseRep = l_cCurrUser OR l_cCurrUser = "sysadmin" ) THEN
		iu_MyParent.i_wParentWindow.dw_folder.fu_EnableTab( 5 )
	ELSEIF (THIS.DataObject = "d_matched_cases" Or THIS.DataObject = "d_matched_cases_caseprops" Or THIS.DataObject = "d_matched_appeals_props") THEN
		iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab( 5 )
	END IF
ELSE
	//Disable the tab as the current rep doesn't have the proper security to view the
	//  case as a result of not having the proper security to view the demographic record.
	iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab( 2 )
	iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab( 3 )
	iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab( 4 )
	
	IF (THIS.DataObject = "d_matched_cases" Or THIS.DataObject = "d_matched_cases_caseprops" Or THIS.DataObject = "d_matched_appeals_props") THEN
		iu_MyParent.i_wParentWindow.dw_folder.fu_DisableTab( 5 )
	END IF	
END IF

//i_wParentWindow.Title = i_wParentWindow.Tag + ' ' + i_wParentWindow.i_cCaseSubjectName

// check to see if Documents  window is opened, if so, re-retrieve
IF w_create_maintain_case.i_bDocsOpened THEN
	l_cSourceType = w_create_maintain_case.i_cSourceType
	l_cCurrentCaseSubject = w_create_maintain_case.i_cCurrentCaseSubject

	CHOOSE CASE l_cSourceType
		CASE 'C'
			l_cNewSourceType = 'E'
	
			// Get GroupID for Member
			SELECT group_id INTO :l_cGroupID
			  FROM cusfocus.consumer
			 WHERE consumer_id = :l_cCurrentCaseSubject;
			 
			//  Set Group ID to Current Case Subject since docs are stored by group and not member
			l_cNewCaseSubject = l_cGroupID
	
	END CHOOSE
	
		CHOOSE CASE l_cSourceType
			CASE 'C'
				STRING l_cMemberGroup
				l_cTitle = 'Member:  '
				SELECT consum_first_name, consum_last_name, group_id
				  INTO :l_cFirstName, :l_cLastName, :l_cMemberGroup
				  FROM cusfocus.consumer
				 WHERE consumer_id = :l_cCurrentCaseSubject;
				 l_cEntity = l_cLastName + ', ' + l_cFirstName
				 
			CASE 'P'
				l_cTitle = 'Provider:  '
				SELECT provid_name
				  INTO :l_cEntity
				  FROM cusfocus.provider_of_service
				 WHERE provider_key = convert( int, :l_cCurrentCaseSubject );
				 
			CASE 'E'
				l_cTitle = 'Group:  '
				SELECT employ_group_name 
				  INTO :l_cEntity 
				  FROM cusfocus.employer_group 
				 WHERE group_id =:l_cCurrentCaseSubject;

		END CHOOSE

		w_docs_quick_interface.Title = 'Documents Quick Interface for ' + l_cTitle + l_cEntity

		// Refresh Docs Quick Interface detail
		IF l_cSourceType = 'C' THEN
			// Handle consumers separately since the docs are stored by group
			w_docs_quick_interface.dw_docs_quick_list.Retrieve(l_cMemberGroup , 'E')		
		ELSE
			w_docs_quick_interface.dw_docs_quick_list.Retrieve(l_cCurrentCaseSubject , l_cSourceType)		
		END IF
			
END IF

// End re-retrieve of Docs Quick Interface


end event

event constructor;call super::constructor;Datawindow ldw_this
ldw_this = This
in_columnsizingservice_detail = Create n_column_sizing_service
in_columnsizingservice_detail.of_init(ldw_this)

in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager

THIS.EVENT TRIGGER ue_refresh_services()

end event

event ue_dwnkey;//this.triggerevent('ue_selecttrigger')

THIS.Event Trigger ue_selecttrigger( key, keyflags )
end event

event rowfocuschanged;call super::rowfocuschanged;// This event, combined with the statement in ue_selecttrigger that
// sets i_IgnoreRFC to TRUE, will counteract the effect that pressing
// the Enter key has causing the next row to become current (and subsequently
// causing the wrong case to be opened).
//
// 11/07/2006 Created Rick Post

LONG ll_selected_row

ll_selected_row = THIS.GetSelectedRow(0)

IF currentrow <> ll_selected_row THEN
	SetRow(ll_selected_row)
END IF

i_IgnoreRFC = FALSE

end event

type uo_titlebar from u_title_button_bar within u_matched_records
integer taborder = 10
end type

on uo_titlebar.destroy
call u_title_button_bar::destroy
end on

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   Add the standard buttons to the title bar
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------
io_parent = Parent

This.of_delete_button('criteria')
This.of_delete_button('customize')
This.of_delete_button('retrieve')


end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   Redirect this event to the parent object
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

Choose Case Lower(as_message)
	Case 'button clicked'
		Choose Case Lower(Trim(String(as_arg)))
			Case 'ellipsis'
			Case Else
				Parent.Event ue_notify(as_message, as_arg)
		End Choose

	Case 'button deleted'
		Choose Case Lower(Trim(String(as_arg)))
			Case 'retrieve'
				Properties.of_set('allow retrieve', 'N')
			Case 'criteria'
				Properties.of_set('allow criteria', 'N')
			Case 'filters'
				Properties.of_set('filter', 'N')
			Case 'x'
				Properties.of_set('allow close', 'N')
		End Choose
End Choose

end event

event rbuttondown;call super::rbuttondown;Parent.Event ue_showmenu()
end event

type st_separator from u_theme_strip within u_matched_records
integer y = 68
integer width = 4123
integer height = 40
end type

event rbuttondown;call super::rbuttondown;Parent.Event ue_showmenu()
end event

