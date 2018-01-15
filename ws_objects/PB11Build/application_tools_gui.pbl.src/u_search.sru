$PBExportHeader$u_search.sru
$PBExportComments$This is the base search/reporting architecture display object.  It contains a datawindow and a title bar.  All SmartSearches are inherited from this object.
forward
global type u_search from u_dynamic_gui
end type
type dw_report from u_datawindow_report within u_search
end type
type uo_titlebar from u_title_button_bar within u_search
end type
type st_separator from u_theme_strip within u_search
end type
end forward

global type u_search from u_dynamic_gui
integer width = 2290
integer height = 1548
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
dw_report dw_report
uo_titlebar uo_titlebar
st_separator st_separator
end type
global u_search u_search

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
	dw_report.of_get_service_manager().of_add_component(iu_filter, 'u_filter_strip')
Else
	iu_filter .Visible = Not iu_filter .Visible
	iu_filter.of_clear()
End If

#IF defined PBDOTNET THEN
	THIS.EVENT resize(0, width, height)
#ELSE
	THIS.TriggerEvent('resize')
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
	THIS.EVENT resize(0, width, height)
#ELSE
	THIS.TriggerEvent('resize')
#END IF

end event

event ue_post_initialize();Long		ll_DtaObjctStteIdnty
Long		ll_RprtCnfgPvtTbleID
Long		ll_ReportDefaultUOMCurrencyID

//----------------------------------------------------------------------------------------------------------------------------------
// This will initialize the criteria again since we might have applied a view before certain services were created.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_criteria) Then iu_criteria.of_init(dw_report)

If IsValid(dw_report.of_get_service('n_navigation_options')) Then
	dw_report.of_get_service('n_navigation_options').Dynamic of_set_allow_detail_reports(This, True)
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
If IsValid(dw_report.of_get_service('n_datawindow_conversion_service')) Then
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
	If IsValid(iu_report_conversion_strip) Then iu_report_conversion_strip.of_init(dw_report)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Resize the object
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ib_uom_conversion_is_on_this_object Then
//??? Will this work for .Net?
		parent.TriggerEvent('resize')
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
	gn_globals.in_subscription_service.of_message('apply view', 'DtaObjctStteIdnty=' + String(ll_DtaObjctStteIdnty), dw_report)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the uom/currency view if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
ll_ReportDefaultUOMCurrencyID = Long(Properties.of_get('UOMCurrencyID'))
If Not IsNull(ll_ReportDefaultUOMCurrencyID) And ll_ReportDefaultUOMCurrencyID > 0 Then
	gn_globals.in_subscription_service.of_message('apply uom/currency view', String(ll_ReportDefaultUOMCurrencyID), dw_report)
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
				
				If IsValid(dw_report.of_get_service('n_dao_dataobject_state')) Then
					dw_report.of_get_service('n_dao_dataobject_state').Dynamic of_autoretrieve()
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
			ln_service = dw_report.of_get_service('n_pivot_table_service')
			If IsValid(ln_service) Then
				Return String(ln_service.Dynamic of_get_current_view_id())
			End If
		End If
		
	Case 'dtaobjctstteidnty'
		ln_service = dw_report.of_get_service('n_dao_dataobject_state')
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

Return dw_report
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
		dw_report.SetRedraw(True)
		ib_redrawison = True
	End If
End If

If ab_trueorfalse = False Then
	If il_redraw_count = 0 Then
		This.SetRedraw(False)
		dw_report.SetRedraw(False)
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
				dw_report.of_add_service('n_group_by_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_group_by_service')
			End If
		Case 'sorting', 'sorttype'
			If Upper(as_optionvalue) <> 'N' Then
				dw_report.of_add_service('n_sort_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_sort_service')
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
			ln_service = dw_report.of_get_service('n_navigation_options')
			If IsValid(ln_service) Then
				lb_IsDragDropEnabled = Properties.IsDragDropEnabled
				ln_service.Dynamic of_set_dragdrop(lb_IsDragDropEnabled)
			End If
		Case 'column sizing', 'columnresizing'
			If Upper(as_optionvalue) <> 'N' Then
				dw_report.of_add_service('n_column_sizing_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_column_sizing_service')
			End If
		Case 'state saving', 'viewsaving'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_report.of_get_service_manager().of_add_service('n_dao_dataobject_state')
				Else
					dw_report.of_get_service_manager().of_destroy_service('n_dao_dataobject_state')
				End If
			End If
	
		Case 'column selection', 'columnselection'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_report.of_get_service_manager().of_add_service('n_show_fields')
				Else
					dw_report.of_get_service_manager().of_destroy_service('n_show_fields')
				End If
			End If
			
		Case 'entity'
			If Not Properties.IsBatchMode And Trim(Properties.EntityName) <> '' And Not IsNull(Properties.EntityName) Then
				dw_report.of_add_service('n_navigation_options')
				ln_service = dw_report.of_get_service('n_navigation_options')
				If IsValid(ln_service) Then
					ln_service.Dynamic of_init(SQLCA, dw_report, Lower(Trim(as_optionvalue)))
					lb_IsDragDropEnabled = Properties.IsDragDropEnabled
					ln_service.Dynamic of_set_dragdrop(lb_IsDragDropEnabled)
					ln_service.Dynamic of_set_allow_detail_reports(This, True)
				End If
			End If
			
		Case 'aggregationservice'
			If Upper(as_optionvalue) <> 'N' Then
				dw_report.of_get_service_manager().of_add_service('n_aggregation_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_aggregation_service')
			End If 
	
		Case 'calendarservice'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_report.of_get_service_manager().of_add_service('n_calendar_column_service')
				Else
					dw_report.of_get_service_manager().of_destroy_service('n_calendar_column_service')
				End If 
			End If
			
		Case 'dropdowncaching'
			If Upper(as_optionvalue) <> 'N' Then
				dw_report.of_get_service_manager().of_add_service('n_dropdowndatawindow_caching_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_dropdowndatawindow_caching_service')
			End If 
			
		Case 'rowselection'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_report.of_get_service_manager().of_add_service('n_rowfocus_service')
				Else
					dw_report.of_get_service_manager().of_destroy_service('n_rowfocus_service')
				End If 
			End If
	
		Case 'formatting'
			If Upper(as_optionvalue) <> 'N' Then
				dw_report.of_get_service_manager().of_add_service('n_datawindow_formatting_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_datawindow_formatting_service')
			End If 
	
		Case 'rejectred'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_report.of_get_service_manager().of_add_service('n_reject_invalids')
				Else
					dw_report.of_get_service_manager().of_destroy_service('n_reject_invalids')
				End If 
			End If
			
		Case 'autofill'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_report.of_get_service_manager().of_add_service('n_autofill')
				Else
					dw_report.of_get_service_manager().of_destroy_service('n_autofill')
				End If
			End If
	
		Case 'keyboarddefault'
			If Not Properties.IsBatchMode Then
				If Upper(as_optionvalue) <> 'N' Then
					dw_report.of_get_service_manager().of_add_service('n_keydown_date_defaults')
				Else
					dw_report.of_get_service_manager().of_destroy_service('n_keydown_date_defaults')
				End If
			End If
	
		Case 'treeviewservice'
			If Upper(as_optionvalue) <> 'N' Then
				dw_report.of_get_service_manager().of_add_service('n_datawindow_treeview_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_datawindow_treeview_service')
			End If
	
		Case 'daoservice'
			If Upper(as_optionvalue) <> 'N' Then
				dw_report.of_get_service_manager().of_add_service('n_dao_service')
			Else
				dw_report.of_get_service_manager().of_destroy_service('n_dao_service')
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
	iu_criteria.Dynamic of_init(dw_report)
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
	this.TriggerEvent('resize')
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
	Properties.of_set_object('DataSource', dw_report)
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

Return dw_report.of_getselectedrow(row)
end function

public function transaction of_gettransactionobject ();/**///Delete this function
//???RAP Migration to PB 11, this is blowing up on close - check for valid object
IF IsValid(Properties) THEN
	Return Properties.TransactionObject
ELSE
	RETURN SQLCA
END IF
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
			dw_report.Event ue_notify('before retrieve', as_arguments)
			
			ln_datawindow_tools = Create n_datawindow_tools
			ll_return = Long(ln_datawindow_tools.of_retrieve(dw_report, as_arguments, '||'))
			Destroy ln_datawindow_tools
		Else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Reset the datawindow before we retrieve, just in case we're retrieving over something we've already retrieved.
			//-----------------------------------------------------------------------------------------------------------------------------------
			dw_report.SetRedraw(FALSE)
			ls_dataobject			= dw_report.DataObject
			dw_report.DataObject = ''
			dw_report.DataObject = ls_dataobject
			dw_report.SetRedraw(TRUE)

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Reset the datawindow before we retrieve, just in case we're retrieving over something we've already retrieved.
			//-----------------------------------------------------------------------------------------------------------------------------------
//			dw_report.SelectTextAll(Header!)
//			dw_report.ReplaceText('')
//			dw_report.SelectTextAll(Detail!)
//			dw_report.ReplaceText('')
//			dw_report.SelectTextAll(Footer!)
//			dw_report.ReplaceText('')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Use the document builder to build the document.  
			//	You must have two graphic controls in order to use this service
			//		1.		Datawindow (dw_working) - This is where the object will be retrieving the individual documents.  It is invisible.
			//		2.		RichTextEditor (rte_fileopener) - This is where RTF files and Bitmaps are appended.  It is also an evaluator for input
			//																fields that are sometimes copied over from the datawindow
			//-----------------------------------------------------------------------------------------------------------------------------------
			ln_rtf_document_builder	= Create n_rtf_document_builder
			ln_rtf_document_builder.of_set_richtexteditor(lo_object)
			ln_rtf_document_builder.of_init(dw_report, ldw_working, Properties.RprtCnfgID)
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
If Len(is_dataobjectname) > 0 Then dw_report.DataObject = is_dataobjectname

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the full state of the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(iblob_currentstate) > 0 Then
	dw_report.SetFullState(iblob_currentstate)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the transaction object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(dw_report.GetTransObject()) Then
	dw_report.SetTransObject(dw_report.GetTransObject())
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
dw_report.GetFullState(iblob_currentstate)

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
is_dataobjectname = dw_report.DataObject

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dataobject to empty string in order to clear the objects
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report.DataObject = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that the state is stored
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = True
end subroutine

on u_search.create
int iCurrent
call super::create
this.dw_report=create dw_report
this.uo_titlebar=create uo_titlebar
this.st_separator=create st_separator
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.uo_titlebar
this.Control[iCurrent+3]=this.st_separator
end on

on u_search.destroy
call super::destroy
destroy(this.dw_report)
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

dw_report.of_set_properties(Properties)

ido_resize_object	= dw_report

//----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the resize event happens
//-----------------------------------------------------------------------------------------------------------------------------------
#IF defined PBDOTNET THEN
	THIS.EVENT resize(0, width, height)
#ELSE
	THIS.TriggerEvent('resize')
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
String	ls_report_title
String 	ls_return
String 	ls_count
String 	ls_plural = 's'
String 	ls_originalpivottablereporttype = 'R'
String 	ls_viewer_object
String 	ls_modulename

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
		
		If dw_report.RowCount() + dw_report.FilteredCount() = 1 Then ls_plural = ''
		
		If dw_report.FilteredCount() > 0 Then
			ls_count = '(' + String(dw_report.RowCount()) + ' of ' + String(dw_report.RowCount() + dw_report.FilteredCount()) + ' row' + ls_plural
		Else
			ls_count = '(' + String(dw_report.RowCount()) + ' row' + ls_plural
		End If
		
		If dw_report.of_IsAppending() Then
			ls_count = ls_count + ' appended) '
		Else
			ls_count = ls_count + ') '
		End If

		If dw_report.of_IsAutoRefreshOn() Then
			ls_count = ls_count + '(Refresh in ' + String(Max(0, SecondsAfter(Now(), Time(dw_report.of_getrefreshtime())))) + ' seconds)'
		End If
		
		uo_titlebar.of_settitle2(ls_count)				
	//This will catch all the button commands and menu commands
	Case 'button clicked', 'menucommand'
		Choose Case Lower(String(as_arg))
			//----------------------------------------------------------------------------------------------------------------------------------
			// Title bar button messages
			//-----------------------------------------------------------------------------------------------------------------------------------
			Case 'criteria'
				This.TriggerEvent('ue_customize')
			Case 'filters'
				This.TriggerEvent('ue_filters')
			Case 'reretrieve'
				dw_report.of_reretrieve()
			Case 'customize report'
				OpenWithParm(lw_window, Properties, 'w_reporting_services', w_mdi)
			Case 'retrieve'
				If IsValid(This.of_get_adapter()) Then
					If IsValid(This.of_get_adapter().of_create_criteria()) Then
						This.of_get_adapter().Event Dynamic ue_notify('button clicked', 'retrieve=' + String(Handle(This)))
					Else
						This.TriggerEvent('ue_retrieve')
					End If
				Else
					This.TriggerEvent('ue_retrieve')
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
				If IsNumber(dw_report.Describe("DataWindow.RichText.InputFieldBackColor")) And Properties.ReportType = 'S' Then
					
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
					ls_return = ln_service.Dynamic of_replace_saved_report(dw_report, Long(Properties.SavedReportID))
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
				ln_service.Dynamic of_set_datasource(dw_report)
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
		ln_service.Dynamic of_set_datasource(dw_report)
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
		ln_bag.of_set('displaydataobjectname', dw_report.dataobject)  //Chris Cole 01/06/2003
		
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
			THIS.EVENT resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('resize')
		#END IF
		#IF defined PBDOTNET THEN
			iu_overlaying_report.EVENT resize(0, iu_overlaying_report.width, iu_overlaying_report.height)
		#ELSE
			iu_overlaying_report.TriggerEvent('resize')
		#END IF
		
		//------------------------------------------------------------
		// Get the navigation options object and set the detail object
		//------------------------------------------------------------
		ln_service = dw_report.of_get_service('n_navigation_options')

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
			THIS.EVENT resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('resize')
		#END IF
		
		//------------------------------------------------------------
		// Get the navigation options object and set the detail object
		//------------------------------------------------------------
		ln_service = dw_report.of_get_service_manager().of_get_service('n_navigation_options')

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
		ll_row = dw_report.of_GetSelectedRow(0)
		#IF defined PBDOTNET THEN
			THIS.EVENT resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('resize')
		#END IF

		If ll_row > 0 And Not IsNull(ll_row) And ll_row <= dw_report.RowCount() Then
			dw_report.ScrollToRow(ll_row)
		End If
		
	Case 'u_search closing', 'adapter closing'
		This.PostEvent('resize')
		gn_globals.in_subscription_service.Post of_message('Object Text Changed', This, This)
		
	Case 'close object'
		If IsValid(as_arg) Then
			lu_gui = as_arg
			If lu_gui.Dynamic Event ue_close() = 0 Then
				This.of_closeuserobject(lu_gui)
				#IF defined PBDOTNET THEN
					THIS.EVENT resize(0, width, height)
				#ELSE
					THIS.TriggerEvent('resize')
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
	ln_menu_dynamic_found.Checked = dw_report.Dynamic of_isautorefreshon()
End If

ln_menu_dynamic_found 	= ln_menu_dynamic.of_find_menu('Set Auto-Retrieve Time')

If IsValid(ln_menu_dynamic_found) Then
	ln_menu_dynamic_found.Visible	= dw_report.Dynamic of_isautorefreshon()
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
dw_report.Event DragDrop(source, 1, ldwo_nulldwobject)
end event

type dw_report from u_datawindow_report within u_search
event ue_post_initialize ( )
integer y = 108
integer width = 1810
integer height = 1428
integer taborder = 20
string dragicon = "arrowman.ico"
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event ue_post_initialize();Parent.Event ue_post_initialize()
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

event retrieveend;call super::retrieveend;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      retrievend
// Overrides:  Yes
// Overview:   Refresh the filter object and redirect the event to the rowfocusservice
// Created by: Joel White
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_count
Long		ll_null
SetNull(ll_null)

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

event ue_notify(string as_message, any aany_argument);call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Joel White
// History:   
//-----------------------------------------------------------------------------------------------------------------------------------

Choose Case Lower(Trim(as_message))
	Case 'before retrieve'
		Parent.of_pre_retrieve()
	Case 'after retrieve'
		Parent.of_post_retrieve()		
	Case 'menucommand','filter', 'distribute', 'apply nested report', 'pivot table view new', 'pivot table view', 'manage report views'
		Parent.Event ue_notify(as_message, aany_argument)
End Choose
end event

type uo_titlebar from u_title_button_bar within u_search
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

This.of_add_button('Retrieve', 'retrieve')
This.of_add_button('Filters', 'filters')
This.of_add_button('Criteria', 'criteria')
This.of_add_button('Customize...', 'customize report')

long ll_temp
ll_temp = uo_titlebar.x
ll_temp = uo_titlebar.y
ll_temp = uo_titlebar.width
ll_temp = uo_titlebar.height
ll_temp++


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

type st_separator from u_theme_strip within u_search
integer y = 68
integer width = 4123
integer height = 40
end type

event rbuttondown;call super::rbuttondown;Parent.Event ue_showmenu()
end event

