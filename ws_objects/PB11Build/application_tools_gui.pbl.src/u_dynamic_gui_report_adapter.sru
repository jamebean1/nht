$PBExportHeader$u_dynamic_gui_report_adapter.sru
forward
global type u_dynamic_gui_report_adapter from u_dynamic_gui
end type
type st_placeholder from statictext within u_dynamic_gui_report_adapter
end type
end forward

global type u_dynamic_gui_report_adapter from u_dynamic_gui
integer width = 3525
string picturename = "Book - Blue.bmp"
event ue_scrollvertical pbm_vscroll
event ue_rbuttondown pbm_rbuttondown
event type long ue_retrieve ( )
event type long ue_showtasks ( )
st_placeholder st_placeholder
end type
global u_dynamic_gui_report_adapter u_dynamic_gui_report_adapter

type variables
//-----------------------------------------------------------------------------------------------------------------------------------
// All the Properties of the report
//-----------------------------------------------------------------------------------------------------------------------------------
Public ProtectedWrite n_report_composite Properties

Protected:
	//-----------------------------------------------------------------------------------------------------------------------------------
	// View Types
	//-----------------------------------------------------------------------------------------------------------------------------------
	Constant		String	Tiled 				= 'tiled'
	Constant		String	Vertical 			= 'vertical'
	Constant		String	Horizontal 			= 'horizontal'
	Constant		String	Tabbed 				= 'tabbed'

	//-----------------------------------------------------------------------------------------------------------------------------------
	// These are the variables that represent the open reports
	//-----------------------------------------------------------------------------------------------------------------------------------
	u_search		iu_zoomed_search					// The current zoomed in search object
	u_search		iu_original_search_object		// The original search object when it is not a composite report
	u_search		iu_search_that_we_are_retrieving_by_itself	//This will usually be null, but in order to retrieve one search object we use this
	Boolean		ib_ZoomButtonsAreThere		= False	//Whether or not there are zoom buttons on the reports
	Boolean		ib_MenuCoordinatesAreSpecified	= False
	Long			il_MenuPointerX
	Long			il_MenuPointerY
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// These will be instantiated when we are in certain views
	//-----------------------------------------------------------------------------------------------------------------------------------
	u_composite_report_horizontal_slider 	iu_composite_report_horizontal_slider[]		// This is an array of slider objects to resize reports
	u_dynamic_gui_tab_strip						iu_dynamic_gui_tab_strip							// This is the tab strip
	u_vscrollbar									iu_vscrollbar											// This is the vertical scroll bar
	u_title_button_bar							iu_title_button_bar									// This is the title bar
	uo_report_criteria							iu_criteria
	u_dynamic_conversion_strip 				iu_report_conversion_strip
	UserObject										iu_parent_report_adapter

	//-----------------------------------------------------------------------------------------------------------------------------------
	// These are used in conjunctino with the scroll bar object
	//-----------------------------------------------------------------------------------------------------------------------------------
	Boolean ib_recalculate_scroll_parameters 	= True			// Whether or not to recalculate the scroll parameters.  This happens when
																				//   things are added that will change the total height of the stuff.
	Long il_vertical_scroll_position 			= 0				// This is used to know where the vertical scrollbar is internally

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Variables used to customize the resize parameters
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long 	il_default_height 				= 500				// Default height for the tiled search when first added
	Long 	il_left_indent 					= 40				// Left indention for the tiled and tabbed view
	Long	il_right_indent 					= 46				// Right indention for the tiled and tabbed view
	Long 	il_top_margin 						= 40				// Top margin for the tiled and tabbed view
	Long 	il_distance_between_reports 	= 20				// Distance between reports for the tiled view
	Long 	il_collapsed_search_height 	= 69				// Height of a collapsed search for the tiled view
	Long	il_redraw_count					= 0
	Long	il_original_criteria_height	= 0
	Boolean	ib_redrawison					= True

//-----------------------------------------------------------------------------------------------------------------------------------
// Getting rid of
//-----------------------------------------------------------------------------------------------------------------------------------
Long 			il_compositereportid				// The composite report id

end variables

forward prototypes
public subroutine of_delete_button (string as_buttontext)
public function u_dynamic_conversion_strip of_get_conversion_strip ()
public function uo_report_criteria of_get_criteria ()
public subroutine of_set_parent_adapter (userobject ao_parent_adapter)
public subroutine of_set_title (string as_title)
public subroutine of_zoom (ref u_search au_search)
public function boolean of_retrieve_from_cache (u_search au_search)
public subroutine of_set_option (string as_option, string as_value)
public subroutine of_setredraw (boolean ab_trueorfalse)
public subroutine of_select (u_dynamic_gui au_dynamic_gui)
public subroutine of_allow_closing (boolean ab_allowclose)
public subroutine of_restore_defaults ()
public subroutine of_retrieve (string as_argument, u_search au_search)
public subroutine of_save_settings ()
protected subroutine of_collapse_or_expand (ref u_search au_search)
public function powerobject of_get_parent_adapter ()
public function n_report_composite of_get_properties ()
public function u_search of_get_report (long al_reportconfigid, string as_reporttype)
public function long of_get_reportconfigid ()
public function u_dynamic_gui of_create_conversion_strip ()
public subroutine of_retrieve (string as_argument)
public subroutine of_setdao (n_dao an_dao)
public function u_search of_open_report (n_report an_report)
public subroutine of_get_reports (ref powerobject au_search[])
public subroutine of_close ()
public subroutine of_set_view (string as_view)
public subroutine of_show_titlebar (boolean ab_show)
public function string of_get (string as_argument)
public subroutine of_set (string as_argument, string as_value)
public subroutine of_add_button (string as_buttontext, string as_buttonmessage, powerobject ao_buttontarget)
protected function u_search of_open_report (long al_index, n_report an_report)
public subroutine of_init (long al_reportconfigid)
public function uo_report_criteria of_create_criteria ()
end prototypes

event ue_scrollvertical;call super::ue_scrollvertical;//If IsNumber(w_frame.Title) Then
//	w_frame.Title = String(Long(w_frame.Title) + 1)
//Else
//	w_frame.Title = '1'
//End If
//
//If scrollpos > 0 Then
//	w_frame.Title = String(scrollpos) + '   code=' + string(scrollcode)
//End If
//
//il_vertical_scroll_position = scrollpos
end event

event ue_rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_rbuttondown
//	Overrides:  No
//	Arguments:	
//	Overview:   This will show the menu for this object
//	Created by: Blake Doerr
//	History:    6/9/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.Event ue_showmenu()
end event

event type long ue_retrieve();
long i, l_upperbound

l_upperbound = UpperBound(Properties.ChildReportSearchObject[])

For i = 1 to l_upperbound
	Properties.ChildReportSearchObject[i].Event ue_retrieve()
Next

Return 1
end event

event type long ue_showtasks();Window	lw_window

If UpperBound(Properties.ChildReportSearchObject[]) = 0 And Not Properties.IsCompositeReport Then Return - 1
If UpperBound(Properties.ChildReportSearchObject[]) = 1 Then
	If IsValid(Properties.ChildReportSearchObject[1]) Then
		Return Long(Properties.ChildReportSearchObject[1].Dynamic Event ue_showtasks())
	Else
		Return -1
	End If
Else
	lw_window = This.of_getparentwindow()
	
	If IsValid(lw_window) Then
		lw_window.Dynamic Event ue_commontasks_reset()
		lw_window.Dynamic Event ue_commontasks_settarget(This)
		
		If Properties.CanAddReports Then
			lw_window.Dynamic Event ue_commontasks_additem('<link>Add</link>Reports', 'button clicked', 'add report')
		End If
		
		If Len(Trim(Properties.CriteriaUserObject)) > 0 Then
			lw_window.Dynamic Event ue_commontasks_additem('<link>Retrieve</link>All Reports', 'button clicked', 'retrieve')
		End If
		
		If Properties.CanChangeView Then
			lw_window.Dynamic Event ue_commontasks_additem('<link>Show</link>Tiled View', 'change view', 'tiled')				
			lw_window.Dynamic Event ue_commontasks_additem('<link>Show</link>Tabbed View', 'change view', 'tabbed')
		End If
		
		If Properties.AllowClosing Then
			lw_window.Dynamic Event ue_commontasks_additem('<link>Close</link>Reports', 'menucommand', 'close')
		End If	

		//lw_window.Dynamic Event ue_commontasks_additem(is_menutext[ll_index], is_menumessage[ll_index], is_menuargument[ll_index])
		lw_window.Dynamic Event ue_commontasks_showmenu()
	End If
	
	Return 1
End If


end event

public subroutine of_delete_button (string as_buttontext);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_button()
//	Arguments:  as_buttontext - The text to show on the button
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(iu_title_button_bar) Then
	iu_title_button_bar.of_delete_button(as_buttontext)
End If
end subroutine

public function u_dynamic_conversion_strip of_get_conversion_strip ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_conversion_strip()
//	Overview:   Return the conversion strip
//	Created by:	Blake Doerr
//	History: 	6/8/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return iu_report_conversion_strip
end function

public function uo_report_criteria of_get_criteria ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_criteria()
// Overview:    This will return the criteria object pointer
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

return iu_criteria
end function

public subroutine of_set_parent_adapter (userobject ao_parent_adapter);iu_parent_report_adapter = ao_parent_adapter
end subroutine

public subroutine of_set_title (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_title()
//	Arguments:  as_title - the title
//	Overview:   Set the title
//	Created by:	Blake Doerr
//	History: 	6/8/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.Text = as_title

If IsValid(iu_title_button_bar) Then
	iu_title_button_bar.of_settitle(as_title)
End If
end subroutine

public subroutine of_zoom (ref u_search au_search);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_zoom()
//	Arguments:  au_search - This is the search object to zoom in or out on
//	Overview:   This will zoom in or out on a report
//	Created by:	Blake Doerr
//	History: 	3/8/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_height = 500, ll_index
Boolean lb_expanded

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
u_search lu_null_search

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the search isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Or IsNull(au_search) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the height and expanded state of the object passed in
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
		If Properties.ChildReportSearchObject[ll_index] = au_search Then
			ll_height = Properties.ChildReportHeight[ll_index]
			lb_expanded = Properties.ChildReportIsExpanded[ll_index]
			Exit
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If the zoomed search is already valid, restore the state of it
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_zoomed_search) Then
	If au_search = iu_zoomed_search Then
		If lb_expanded Then
			iu_zoomed_search.Height = ll_height
		Else
			iu_zoomed_search.Height = il_collapsed_search_height
		End If
		
		iu_zoomed_search = lu_null_search
		Return
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the zoomed search to the one passed in
//-----------------------------------------------------------------------------------------------------------------------------------
iu_zoomed_search = au_search

end subroutine

public function boolean of_retrieve_from_cache (u_search au_search);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve_from_cache()
//	Arguments:  au_search - This is the search that you are trying to cache from
//	Overview:   This will try to cache the data from already retrieved reports or data cached in memory or the hard drive
//	Created by:	Blake Doerr
//	History: 	3/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_array_location = 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools 
Datawindow ldw_source
Datawindow ldw_destination

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the object isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the search object in the array
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	If au_search = Properties.ChildReportSearchObject[ll_index] Then
		ll_array_location = ll_index
		Exit
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the array location is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_array_location = 0 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the searches and retrieve them from string
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_array_location - 1
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Continue if the search is not valid or it should not be retrieved
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
	If Not Properties.ChildReportSearchObject[ll_index].Properties.RprtCnfgID = Properties.ChildReportSearchObject[ll_array_location].Properties.RprtCnfgID Then Continue
	If Not Properties.ChildReportSearchObject[ll_index].Properties.ReportType = Properties.ChildReportSearchObject[ll_array_location].Properties.ReportType Then Continue
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the source and destination datawindows
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldw_source = Properties.ChildReportSearchObject[ll_index].of_get_report_dw()
	ldw_destination = Properties.ChildReportSearchObject[ll_array_location].of_get_report_dw()

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reset the data, copy the dropdown datawindows
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldw_destination.Reset()

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Copy the dropdowndatawindows
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_datawindow_tools = Create n_datawindow_tools
	ln_datawindow_tools.of_copy_dropdowndatawindows(ldw_source, ldw_destination)
	Destroy ln_datawindow_tools
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Emulate the retrieve starting.  The only problem with this is that we can't allow appending data.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldw_destination.Event RetrieveStart()

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set this boolean to false each time through the loop. It becomes true if we can cache the data
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ldw_source.RowsCopy(1, ldw_source.RowCount(), Primary!, ldw_destination, 1, Primary!) < 0 Then
		ldw_destination.Event RetrieveEnd(ldw_destination.RowCount())
		Return False
	End If
	
	If ldw_source.RowsCopy(1, ldw_source.FilteredCount(), Filter!, ldw_destination, ldw_destination.RowCount() + 1, Primary!) < 0 Then
		ldw_destination.Event RetrieveEnd(ldw_destination.RowCount())
		Return False
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Emulate the retrieve ending
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldw_destination.Event RetrieveEnd(ldw_destination.RowCount())

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Return that the data was used from cache
	//-----------------------------------------------------------------------------------------------------------------------------------
	Return True
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return False if the data wasn't cached
//-----------------------------------------------------------------------------------------------------------------------------------
Return False

end function

public subroutine of_set_option (string as_option, string as_value);Long	ll_index

Properties.of_set(as_option, as_value)

For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
	Properties.ChildReportSearchObject[ll_index].of_set_option(as_option, as_value)
Next
end subroutine

public subroutine of_setredraw (boolean ab_trueorfalse);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_setredraw()
// Arguments:   ab_trueorfalse - whether you want to turn it on or off
// Overview:    This will manage redraw so you can set it on and off in multiple levels of inheritance and it will only happen once
// Created by:  Blake Doerr
// History:     6/7/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index

If ab_trueorfalse = False Then
	If il_redraw_count = 0 Then
		This.SetRedraw(False)
		For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
			If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
				Properties.ChildReportSearchObject[ll_index].of_setredraw(False)
			End If
		Next
		ib_redrawison = False
	End If
	il_redraw_count = il_redraw_count + 1
End If

If ab_trueorfalse = True Then
	il_redraw_count = il_redraw_count - 1
	If il_redraw_count = 0 Then 
		For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
			If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
				Properties.ChildReportSearchObject[ll_index].of_setredraw(True)
			End If
		Next
		This.SetRedraw(True)
		ib_redrawison = True
	End If
End If


end subroutine

public subroutine of_select (u_dynamic_gui au_dynamic_gui);If IsValid(iu_dynamic_gui_tab_strip) And Properties.ViewType = Tabbed Then
	iu_dynamic_gui_tab_strip.of_select(au_dynamic_gui)
End If
end subroutine

public subroutine of_allow_closing (boolean ab_allowclose);If ab_allowclose Then
	Properties.of_set('AllowClosing', 'Y')
Else
	Properties.of_set('AllowClosing', 'N')
End If
end subroutine

public subroutine of_restore_defaults ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_restore_defaults()
//	Overview:   This will restore the last defaults for the criteria object
//	Created by:	Blake Doerr
//	History: 	9.20.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Restore the defaults if there is data relating to the defaults and there is a valid reportconfigid 
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(Properties.RprtCnfgID) And Properties.RprtCnfgID > 0 Then
	iu_criteria.of_restore_saved_criteria(Properties.RprtCnfgID, Properties.UserID)
	iu_criteria.of_post_default()
End If
end subroutine

public subroutine of_retrieve (string as_argument, u_search au_search);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve()
//	Arguments:  as_argument - The string argument to the reports
//	Overview:   This will retrieve all the reports from a string
//	Created by:	Blake Doerr
//	History: 	3/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
Long ll_null

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the criteria object if it is not created
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(iu_criteria) And Len(Trim(Properties.CriteriaUserObject)) > 0 Then
	This.of_create_criteria()
End IF

//-----------------------------------------------------------------------------------------------------------------------------------
// If one isvalid call the retrieve function on it.
//-----------------------------------------------------------------------------------------------------------------------------------
If Isvalid(iu_criteria) Then
	If iu_criteria.of_validate() Then
		//----------------------------------------------------------------------------------------------------------------------------------
		// Save their defaults for this particular report. We need to add logic to only save default if they want us to. This could be 
		//	annoying to the user since many report criterias have a set of default logic associated with the criteria.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Not IsNull(Properties.RprtCnfgID) And Properties.RprtCnfgID > 0 Then
			iu_criteria.of_save_criteria(Properties.RprtCnfgID, Properties.UserID)
		End If
	Else
		Return
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the searches and retrieve them from string
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(Properties.ChildReportSearchObject[]), UpperBound(Properties.ChildReportIsParentObject[]))
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Continue if the search is not valid or it should not be retrieved
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
	If Not Properties.ChildReportIsParentObject[ll_index] Then Continue
	If IsValid(au_search) Then
		If Properties.ChildReportSearchObject[ll_index] <> au_search Then Continue
	Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Continue if we can cached the data from another report
		//-----------------------------------------------------------------------------------------------------------------------------------
		//If This.of_retrieve_from_cache(iu_search[ll_index]) Then Continue
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Retrieve the search report
	//-----------------------------------------------------------------------------------------------------------------------------------
	Properties.ChildReportSearchObject[ll_index].of_retrieve(as_argument)
Next
end subroutine

public subroutine of_save_settings ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_settings()
//	Overview:   This will save information about the reports to the database
//	Created by:	Blake Doerr
//	History: 	3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_dtaobjctstteidnty
Long		ll_rprtcnfgpvttbleid
String	ls_parameters[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine all the parameters for the object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	ls_parameters[ll_index]	= ''
	
	If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
	
	ll_dtaobjctstteidnty = Long(Properties.ChildReportSearchObject[ll_index].Event ue_getitem('dtaobjctstteidnty', ''))
	ll_rprtcnfgpvttbleid = Long(Properties.ChildReportSearchObject[ll_index].Event ue_getitem('rprtcnfgpvttbleid', ''))
	
	If ll_dtaobjctstteidnty > 0 And Not IsNull(ll_dtaobjctstteidnty) Then
		ls_parameters[ll_index] = ls_parameters[ll_index] + 'DtaObjctStteIdnty=' + String(ll_dtaobjctstteidnty) + '||'
	End If
	
	If ll_rprtcnfgpvttbleid > 0 And Not IsNull(ll_rprtcnfgpvttbleid) Then
		ls_parameters[ll_index] = ls_parameters[ll_index] + 'RprtCnfgPvtTbleID=' + String(ll_rprtcnfgpvttbleid) + '||'
	End If
	
	Properties.of_set(ll_index, 'ChildReportParameters', ls_parameters[ll_index])
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the array is the same length as the others
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = UpperBound(ls_parameters[]) + 1 To UpperBound(Properties.ChildReportConfigID[])
	ls_parameters[ll_index] = ''
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the array of reports that are opened in the adapter
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(Properties.in_dao_compositereportconfiguser) And Properties.IsCompositeReport Then
	Properties.in_dao_compositereportconfiguser.of_set_report_properties(Properties)
	Properties.in_dao_compositereportconfiguser.of_save()
End If
end subroutine

protected subroutine of_collapse_or_expand (ref u_search au_search);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_collapse_or_expand()
//	Arguments:  au_search - The search object
//	Overview:   This will collapse or expand the object
//	Created by:	Blake Doerr
//	History: 	3/1/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the pointer is invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Or IsNull(au_search) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the search array, if it is found expand or collapse it
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
		If Properties.ChildReportSearchObject[ll_index] = au_search Then
			If Properties.ChildReportIsExpanded[ll_index] Then
				Properties.of_set(ll_index, 'ChildReportIsExpanded', 'N')
			Else
				Properties.of_set(ll_index, 'ChildReportIsExpanded', 'Y')
			End If
			
			If Not Properties.ChildReportIsExpanded[ll_index] Then
				au_search.Height = il_collapsed_search_height
			Else
				au_search.Height = Properties.ChildReportHeight[ll_index]
			End If
		End If
	End If
Next

end subroutine

public function powerobject of_get_parent_adapter ();Return iu_parent_report_adapter
end function

public function n_report_composite of_get_properties ();Return Properties
end function

public function u_search of_get_report (long al_reportconfigid, string as_reporttype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_report()
//	Arguments:  au_search[] - The array of searches passed by reference
//	Overview:   This will return an array of searches
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
u_search lu_search

//-----------------------------------------------------------------------------------------------------------------------------------
// Just get the valid searches
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
		If Properties.ChildReportSearchObject[ll_index].Properties.RprtCnfgID = al_reportconfigid And Properties.ChildReportSearchObject[ll_index].Properties.ReportType = as_reporttype Then
			Return Properties.ChildReportSearchObject[ll_index]
		End If
	End If
Next

Return lu_search
end function

public function long of_get_reportconfigid ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_reportconfigid()
// Overview:    This will set the reportconfig id
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not Properties.IsCompositeReport Then
	If UpperBound(Properties.ChildReportSearchObject[]) > 0 Then
		If IsValid(Properties.ChildReportSearchObject[1]) Then
			Return Properties.ChildReportSearchObject[1].Properties.RprtCnfgID
		End If
	End If
Else
	Return Properties.RprtCnfgID
End If

Return 0
end function

public function u_dynamic_gui of_create_conversion_strip ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_create_conversion_strip
// Overrides:  No
// Overview:   This will create the conversion strip
// Created by: Blake Doerr
// History:    06/08/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long			ll_index
UserObject	lu_report_conversion_object

If IsValid(iu_parent_report_adapter) And Not IsNull(iu_parent_report_adapter) Then
	lu_report_conversion_object = iu_parent_report_adapter.Dynamic of_create_conversion_strip()
	
	If IsValid(lu_report_conversion_object) And Not IsNull(lu_report_conversion_object) Then
		Return lu_report_conversion_object
	End If
End If
	

If Not IsValid(iu_report_conversion_strip) Then
	//-----------------------------------------------------
	// Create the conversion strip if it doesn't exist
	//-----------------------------------------------------
//	iu_report_conversion_strip = this.of_OpenUserObject('u_dynamic_conversion_strip', 10000, 10000)
	iu_report_conversion_strip.Y = This.Height - iu_report_conversion_strip.Height
	iu_report_conversion_strip.Width = Width
	iu_report_conversion_strip.X = 1
	iu_report_conversion_strip.Border = False
	#IF  defined PBDOTNET THEN
		THIS.EVENT resize(0, width, height)
	#ELSE
		THIS.TriggerEvent('Resize')
	#END IF
End If

Return iu_report_conversion_strip
end function

public subroutine of_retrieve (string as_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retreive()
//	Arguments:  as_argument - The string argument to the reports
//	Overview:   This will retrieve all the reports from a string
//	Created by:	Blake Doerr
//	History: 	3/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
u_search lu_search

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the overloaded version with a null search object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_search_that_we_are_retrieving_by_itself) And Not IsNull(iu_search_that_we_are_retrieving_by_itself) Then
	lu_search = iu_search_that_we_are_retrieving_by_itself
End If

This.of_retrieve(as_argument, lu_search)
end subroutine

public subroutine of_setdao (n_dao an_dao);n_report ln_report

If Not IsValid(an_dao) Then Return

ln_report = an_dao

If Not Properties.IsInitialized Then This.of_init(ln_report.RprtCnfgID)

If Properties.IsCompositeReport Then Return

This.of_open_report(ln_report)
end subroutine

public function u_search of_open_report (n_report an_report);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_report()
//	Overview:   This will add a report to the Composite Report
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_CmpsteRprtCnfgDtlID
String	ls_parameters
SetNull(ll_CmpsteRprtCnfgDtlID)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
u_search	lu_search

//-----------------------------------------------------------------------------------------------------------------------------------
// If this report has never beeen initialized, go ahead and do it now
//-----------------------------------------------------------------------------------------------------------------------------------
If Not Properties.IsInitialized Then
	Properties.of_init(an_report.RprtCnfgID, an_report.IsSavedReport)
	This.of_set_title(Properties.Name)
	PictureName = an_report.DisplayObjectIcon
	If an_report.IsBatchMode Then Properties.of_set('IsBatchMode', 'Y')
End If

Return This.of_open_report(Properties.of_add_report(an_report), an_report)
end function

public subroutine of_get_reports (ref powerobject au_search[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_reports()
//	Arguments:  au_search[] - The array of searches passed by reference
//	Overview:   This will return an array of searches
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Just get the valid searches
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
		au_search[UpperBound(au_search[]) + 1] = Properties.ChildReportSearchObject[ll_index]
	End If
Next

end subroutine

public subroutine of_close ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_close
// Overrides:  No
// Overview:   close thyself
// Created by: Blake Doerr
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
u_dynamic_gui lu_dynamic_gui 
Window lw_window
Any lany_temporary
Long ll_return

ll_return = This.Event ue_close()

If ll_return <> 1 Then
	If Not IsValid(io_parent) Then
		io_parent = This.of_getparentwindow()
	End If
	
	io_parent.Dynamic Event ue_notify('adapter closing', This)
	
	//Close thyself differently based on what the parent object is
	Choose Case io_parent.TypeOf()
		Case Window!
			lw_window = io_parent
			lany_temporary = This
			lw_window.CloseUserObject(This)
		Case Else
			lu_dynamic_gui = io_parent
			lany_temporary = This
			lu_dynamic_gui.of_closeuserobject(This)
	End Choose
End If
		
end subroutine

public subroutine of_set_view (string as_view);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_view()
//	Arguments:  as_view - The type of view
//	Overview:   Set the tab view on or off
//	Created by:	Blake Doerr
//	History: 	4/14/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Varibles
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
String	ls_previous_view

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that the view changed
//-----------------------------------------------------------------------------------------------------------------------------------
ls_previous_view 	= Properties.ViewType

//-----------------------------------------------------------------------------------------------------------------------------------
// Validate the view type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_view))
	Case Tiled, Tabbed, Vertical, Horizontal
	Case Else
		Return
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the previous view type and set the new view type
//-----------------------------------------------------------------------------------------------------------------------------------
Properties.of_set('ViewType', as_view)

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the slider if we need to, otherwise create them
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case as_view
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the sliders if they aren't there and initialize them
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 	Tiled
		For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
			If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
				Properties.ChildReportSearchObject[ll_index].Visible = True
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Create the slider object
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(iu_composite_report_horizontal_slider[]) >= ll_index Then
					If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
						Continue
					End If
				End If

//				iu_composite_report_horizontal_slider[ll_index] = This.of_OpenUserObject('u_composite_report_horizontal_slider', 10000, 0)
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Initialize the slider
				//-----------------------------------------------------------------------------------------------------------------------------------
				iu_composite_report_horizontal_slider[ll_index].of_set_reference(This)
				iu_composite_report_horizontal_slider[ll_index].of_add_upper_object(Properties.ChildReportSearchObject[ll_index])
			End If
		Next
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Destroy the the sliders
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case Else
		For ll_index = 1 To UpperBound(iu_composite_report_horizontal_slider[])
			If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
				This.of_closeuserobject(iu_composite_report_horizontal_slider[ll_index])
			End If
		Next
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Create or destroy the vertical scrollbar if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case as_view
	Case Tiled
		If Not IsValid(iu_vscrollbar) Then
			iu_vscrollbar = This.of_openuserobject('u_vscrollbar', 20000, 0)
			iu_vscrollbar.of_setparent(This)
		End If
	Case Else
		If IsValid(iu_vscrollbar) Then
			This.of_closeuserobject(iu_vscrollbar)
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the size of the objects if we are going to certain views
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case as_view
	Case Tiled
		For ll_index = 1 to UpperBound(Properties.ChildReportSearchObject[])
			If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
				If Properties.ChildReportIsExpanded[ll_index] Then
					Properties.ChildReportSearchObject[ll_index].Height = Properties.ChildReportHeight[ll_index]
				Else
					Properties.ChildReportSearchObject[ll_index].Height = il_collapsed_search_height
				End If
				
				If ls_previous_view <> Tiled Then
					If Properties.ChildReportIsExpanded[ll_index] Then
						Properties.ChildReportSearchObject[ll_index].of_add_button('collapsebutton', 'collapsebutton', This)
					Else
						Properties.ChildReportSearchObject[ll_index].of_add_button('expandbutton', 'expandbutton', This)
					End if
				End If
			End If
		Next
		
	Case Else
		If ls_previous_view = Tiled Then
			For ll_index = 1 to UpperBound(Properties.ChildReportSearchObject[])
				If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
					Properties.ChildReportSearchObject[ll_index].of_delete_title_button('collapsebutton')
					Properties.ChildReportSearchObject[ll_index].of_delete_title_button('expandbutton')
				End If
			Next
		End If
End Choose

#IF  defined PBDOTNET THEN
	THIS.EVENT resize(0, width, height)
#ELSE
	THIS.TriggerEvent('Resize')
#END IF

end subroutine

public subroutine of_show_titlebar (boolean ab_show);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_show_titlebar()
//	Arguments:  ab_show - true or false
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	3/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If ab_show Then
	If Not IsValid(iu_title_button_bar) Then
		iu_title_button_bar = This.of_openuserobject('u_title_button_bar', 0, 0)
		iu_title_button_bar.io_parent = This
	End If
	
	If IsValid(iu_title_button_bar) Then
		iu_title_button_bar.Height = 69
		iu_title_button_bar.Width = Width
		iu_title_button_bar.of_settitle(This.Text)
	End If

	If Properties.IsCompositeReport Then
		iu_title_button_bar.of_add_button('Retrieve', 'retrieve', This)

		If Len(Trim(Properties.CriteriaUserObject)) > 0 And Lower(Trim(Properties.CriteriaUserObject)) <> 'uo_report_criteria' And IsValid(iu_title_button_bar) Then 
			iu_title_button_bar.of_add_button('Criteria', 'criteria', This)
		Else
			iu_title_button_bar.of_delete_button('criteria')
		End If

		If Properties.CanAddReports Then
			iu_title_button_bar.of_add_button('Add Report(s)...', 'add report', This)
		End If

		If Properties.AllowClosing Then
			iu_title_button_bar.of_add_button('x', 'close', This)
		Else
			iu_title_button_bar.of_delete_button('x')
		End If
	End If


Else
	If IsValid(iu_title_button_bar) Then
		This.of_closeuserobject(iu_title_button_bar)
	End If
End If
end subroutine

public function string of_get (string as_argument);Choose Case Lower(Trim(as_argument))
	Case 'picturename'
		Return This.PictureName
	Case 'text'
		Return This.Text
End Choose
end function

public subroutine of_set (string as_argument, string as_value);Choose Case Lower(Trim(as_argument))
	Case 'picturename'
		This.PictureName = as_value
	Case 'text'
		This.Text = as_value
End Choose
end subroutine

public subroutine of_add_button (string as_buttontext, string as_buttonmessage, powerobject ao_buttontarget);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_button()
//	Arguments:  as_buttontext - The text to show on the button
//					as_buttonmessage - The message to pass to the ue_notify of ao_buttontarget
//					ao_buttontarget - The object that will receive the message
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(iu_title_button_bar) Then
	iu_title_button_bar.of_add_button(as_buttontext, as_buttonmessage, ao_buttontarget)
End If
end subroutine

protected function u_search of_open_report (long al_index, n_report an_report);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_report()
//	Overview:   This will add a report to the Composite Report
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_RprtCnfgPvtTbleID
Long	ll_DtaObjctStteIdnty

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
u_search	lu_search
//n_string_functions ln_string_functions

If al_index <= 0 Or al_index > UpperBound(Properties.ChildReportSearchObject[]) Then Return lu_search

//Properties.ChildReportSearchObject[al_index] = This.of_OpenUserObjectWithParm(an_report.DisplayUserObject, 20000, 0, an_report)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the search is not valid, return.  Set the search into the array.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(Properties.ChildReportSearchObject[al_index]) Then Return Properties.ChildReportSearchObject[al_index]

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the adapter
//-----------------------------------------------------------------------------------------------------------------------------------
//Properties.ChildReportSearchObject[al_index].of_set_adapter(This)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the search is not required, add the close button
//-----------------------------------------------------------------------------------------------------------------------------------
If Properties.ChildReportIsRequired[al_index] And Properties.IsCompositeReport Then
	Properties.ChildReportSearchObject[al_index].Properties.of_set('AllowClosing', 'N')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If this is not a parent object, remove the retrieve button
//-----------------------------------------------------------------------------------------------------------------------------------
If Not Properties.ChildReportIsParentObject[al_index] Then
	Properties.ChildReportSearchObject[al_index].Properties.of_set('AllowRetrieve', 'N')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dao on the report
//-----------------------------------------------------------------------------------------------------------------------------------
Properties.ChildReportSearchObject[al_index].of_setdao(an_report)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set all the options
//-----------------------------------------------------------------------------------------------------------------------------------
Properties.ChildReportSearchObject[al_index].Properties.of_set_options(Properties.ChildReportParameters[al_index])

//-----------------------------------------------------------------------------------------------------------------------------------
// If there are already zoom buttons, add one to this report
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_ZoomButtonsAreThere Then Properties.ChildReportSearchObject[al_index].of_add_button('Zoom In/Out', 'zoominout=' + String(Handle(Properties.ChildReportSearchObject[al_index])), This)

//-----------------------------------------------------------------------------------------------------------------------------------
// If this is a parent object, add the retrieve button
//-----------------------------------------------------------------------------------------------------------------------------------
If Properties.ChildReportIsParentObject[al_index] Then
	If Properties.IsCompositeReport Then
		If Not Properties.ChildReportAllowCriteria[al_index] Then
			Properties.ChildReportSearchObject[al_index].of_add_button('Retrieve', 'retrieve=' + String(Handle(Properties.ChildReportSearchObject[al_index])), This)
		End If
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Add the expanded button correctly and set the height
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Properties.ViewType
	//-----------------------------------------------------------------------------------------------------------------------------------
	// For the tiled view we need sliders and we need to make sure that the scroll bar is there
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case Tiled
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Add the collapse or expanded button
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Properties.ChildReportIsExpanded[al_index] Then
			Properties.ChildReportSearchObject[al_index].of_add_button('collapsebutton', 'collapsebutton', This)
			Properties.ChildReportSearchObject[al_index].Height = Properties.ChildReportHeight[al_index]
		Else
			Properties.ChildReportSearchObject[al_index].of_add_button('expandbutton', 'expandbutton', This)
			Properties.ChildReportSearchObject[al_index].Height = il_collapsed_search_height
		End if

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Create the slider if it isn't there and initialize it
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(iu_composite_report_horizontal_slider[]) < al_index Then
			iu_composite_report_horizontal_slider[al_index] = This.of_OpenUserObject('u_composite_report_horizontal_slider', 10000, 0)
		End If
		
		If Not IsValid(iu_composite_report_horizontal_slider[al_index]) Then
			iu_composite_report_horizontal_slider[al_index] = This.of_OpenUserObject('u_composite_report_horizontal_slider', 10000, 0)
		End If
		
		iu_composite_report_horizontal_slider[al_index].of_set_reference(This)
		iu_composite_report_horizontal_slider[al_index].of_add_upper_object(Properties.ChildReportSearchObject[al_index])

	//-----------------------------------------------------------------------------------------------------------------------------------
	// For the tabbed view we need to add the report as a tab
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case Tabbed
		If IsValid(iu_dynamic_gui_tab_strip) Then
			iu_dynamic_gui_tab_strip.of_add_gui(Properties.ChildReportSearchObject[al_index], False)
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Return search
//-----------------------------------------------------------------------------------------------------------------------------------
Return Properties.ChildReportSearchObject[al_index]
end function

public subroutine of_init (long al_reportconfigid);Long		ll_index

If Properties.IsInitialized Then Return

Properties.of_init(al_reportconfigid, False)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the title on the report.
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_set_title(Properties.Name)
This.of_show_titlebar(Properties.IsCompositeReport)
This.PictureName = Properties.DisplayObjectIcon

If Properties.IsDefaultShowCriteria Then
	If IsValid(This.of_create_criteria()) Then
		iu_criteria.Visible = True
		#IF  defined PBDOTNET THEN
			THIS.EVENT resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('Resize')
		#END IF
	End If
End If


This.of_set_view(Properties.ViewType)

//-----------------------------------------------------------------------------------------------------------------------------------
// Open each report
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Properties.ChildReportConfigID[])
	If Not IsValid(Properties.ChildReportProperties[ll_index]) Then
		Properties.ChildReportProperties[ll_index] = Create n_report
		Properties.ChildReportProperties[ll_index].of_init(Properties.ChildReportConfigID[ll_index])
	End If
	
	This.of_open_report(ll_index, Properties.ChildReportProperties[ll_index])
Next

#IF  defined PBDOTNET THEN
	THIS.EVENT resize(0, width, height)
#ELSE
	THIS.TriggerEvent('Resize')
#END IF

end subroutine

public function uo_report_criteria of_create_criteria ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_create_criteria
// Arguments:   None
// Overview:    Creates the criteria object for this search object
// Created by:  Scott Creed
// History:     6.21.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_y_position

if not isvalid(iu_criteria) And Len(Trim(Properties.CriteriaUserObject)) > 0 Then
	If IsValid(iu_title_button_bar) Then
		ll_y_position = iu_title_button_bar.Height + iu_title_button_bar.Y
	Else
		ll_y_position = 0
	End If
	
	iu_criteria = of_OpenUserObject(Properties.CriteriaUserObject, 10000, ll_y_position)
	iu_criteria.Width = 10000
	iu_criteria.Visible = False
	iu_criteria.X = 1
	iu_criteria.Border = False
	iu_criteria.of_set_db_transaction(SQLCA)/**/
	iu_criteria.of_init(this)
	iu_criteria.of_proc()
	This.of_restore_defaults()
	il_original_criteria_height = iu_criteria.Height
	iu_criteria.Height = 0
	io_parent.Event Dynamic ue_notify('criteria created', This)
end if

return iu_criteria
end function

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Resize
//	Overrides:  No
//	Arguments:	
//	Overview:   This will manage the organization of the reports
//	Created by: Blake Doerr
//	History:    2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 	ll_index
Long 	ll_y_position
Long 	ll_max_position
Long 	ll_valid_count
Long 	ll_titlebar_height
Long 	ll_max_height
Long 	ll_total_height
Long	ll_horizontalreportcount

UserObject lu_search

This.of_SetRedraw(False)

ll_valid_count = 0

For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
	If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
		ll_valid_count = ll_valid_count + 1
		lu_search = Properties.ChildReportSearchObject[ll_index]
	End If
Next

If Lower(Properties.ViewType) <> Tabbed Then
	If IsValid(iu_dynamic_gui_tab_strip) Then This.of_closeuserobject(iu_dynamic_gui_tab_strip)
End If

If IsValid(iu_zoomed_search) And Not IsNull(iu_zoomed_search) Then
	lu_search = iu_zoomed_search
End If

If Not Properties.IsCompositeReport Then
	If ll_valid_count = 1 And IsValid(iu_title_button_bar) Then
		This.of_show_titlebar(False)
	End If
	
	If ll_valid_count > 1 And Not IsValid(iu_title_button_bar) Then
		This.of_show_titlebar(True)
	End If
End If

If IsValid(iu_report_conversion_strip) Then
	iu_report_conversion_strip.Y = Height - iu_report_conversion_strip.Height - 10
	ll_max_height = iu_report_conversion_strip.Y + 10
	ll_total_height = ll_max_height
Else
	ll_max_height 	= This.Height
	ll_total_height = ll_max_height
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Resize the scroll bar
//-----------------------------------------------------------------------------------------------------------------------------------
ll_max_position = 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the first y position
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Properties.ViewType)
	Case Tiled
	Case Else
		il_vertical_scroll_position = 0
End Choose

If IsValid(iu_title_button_bar) Then
	If iu_title_button_bar.Visible Then
		ll_titlebar_height = iu_title_button_bar.Y + iu_title_button_bar.Height
	End If
End If

If IsValid(iu_criteria) Then
	If iu_criteria.Visible Then
		ll_titlebar_height = iu_criteria.Y + iu_criteria.Height
		If IsValid(iu_title_button_bar) Then
			iu_criteria.Y = iu_title_button_bar.Y + iu_title_button_bar.Height
		Else
			iu_criteria.Y = 0 
		End If
	End If
End If

ll_y_position = ll_titlebar_height + il_top_margin - il_vertical_scroll_position

If ll_valid_count = 0 And Properties.IsCompositeReport Then
	st_placeholder.Move(20, ll_titlebar_height + 20)
	st_placeholder.Resize(Width - 50, ll_max_height - st_placeholder.Y - 40)
	st_placeholder.Visible = True
	If IsValid(iu_dynamic_gui_tab_strip) Then	iu_dynamic_gui_tab_strip.Visible = False
Else
	st_placeholder.Visible = False
End If

For ll_index = 1 To UpperBound(iu_composite_report_horizontal_slider[])
	If UpperBound(Properties.ChildReportSearchObject[]) < ll_index Then
		If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then This.of_closeuserobject(iu_composite_report_horizontal_slider[ll_index])
	End If
			
	If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then
		If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then This.of_closeuserobject(iu_composite_report_horizontal_slider[ll_index])
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If there are more than one report, add zoom buttons
//-----------------------------------------------------------------------------------------------------------------------------------
If (ll_valid_count = 1 Or Lower(Properties.ViewType) = Tabbed) Then
	If ib_ZoomButtonsAreThere Then
		For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
			If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
				Properties.ChildReportSearchObject[ll_index].of_delete_title_button('Zoom In/Out')
			End If
		Next
		
		ib_ZoomButtonsAreThere = False
	End If
Else
	If Not ib_ZoomButtonsAreThere Then
		For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
			If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
				Properties.ChildReportSearchObject[ll_index].of_add_button('Zoom In/Out', 'zoominout=' + String(Handle(Properties.ChildReportSearchObject[ll_index])), This)
			End If
		Next
		
		ib_ZoomButtonsAreThere = True
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are zoomed in, just maintain the size of the zoomed report
//-----------------------------------------------------------------------------------------------------------------------------------
If (ll_valid_count = 1 And Lower(Properties.ViewType) = Tabbed) Or (IsValid(iu_zoomed_search) And Not IsNull(iu_zoomed_search)) Then
	If IsValid(iu_dynamic_gui_tab_strip) Then
		iu_dynamic_gui_tab_strip.Visible = False
	End If
	
	If IsValid(iu_vscrollbar) Then
		iu_vscrollbar.Visible = False
	End If
	lu_search.Visible 	= True
	lu_search.BringToTop = True
	If Len(Properties.CriteriaUserObject) > 0 And Not IsNull(Properties.CriteriaUserObject) And Properties.IsCompositeReport Then
		lu_search.Move(20, ll_titlebar_height + 20)
		lu_search.Resize(Width - 40, ll_max_height - lu_search.Y - 40)
		If Not lu_search.Border Then lu_search.Border 		= True
	Else
		lu_search.Move(0, ll_titlebar_height)
		lu_search.Resize(Width, ll_max_height - lu_search.Y)
		If lu_search.Border Then lu_search.Border 		= False
	End If
Else
	Choose Case Lower(Properties.ViewType)
		Case Tabbed
			If ll_valid_count > 0 Then
				If Not IsValid(iu_dynamic_gui_tab_strip) Then
					iu_dynamic_gui_tab_strip = This.of_openuserobject('u_dynamic_gui_tab_strip', 20000, 0)
					iu_dynamic_gui_tab_strip.Border = False
					iu_dynamic_gui_tab_strip.Height = 85
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Add the GUI's to the tab strip
					//-----------------------------------------------------------------------------------------------------------------------------------
					For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject)
						If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
							iu_dynamic_gui_tab_strip.of_add_gui(Properties.ChildReportSearchObject[ll_index], False)
						End If
					Next
					
					iu_dynamic_gui_tab_strip.of_enable(True)
				End If
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Resize the tabstrip
				//-----------------------------------------------------------------------------------------------------------------------------------
				iu_dynamic_gui_tab_strip.of_refresh()
				iu_dynamic_gui_tab_strip.Visible 	= ll_valid_count > 1
				iu_dynamic_gui_tab_strip.Width 		= Width - il_left_indent - il_right_indent
				iu_dynamic_gui_tab_strip.Move(il_left_indent, ll_max_height - iu_dynamic_gui_tab_strip.Height - 10)
			
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Resize all the searches
				//-----------------------------------------------------------------------------------------------------------------------------------
				For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
					If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
					
					lu_search = Properties.ChildReportSearchObject[ll_index]
					lu_search.Move(il_left_indent, ll_y_position)
					lu_search.Resize(Width - il_left_indent - il_right_indent, iu_dynamic_gui_tab_strip.Y - lu_search.Y + 5)

					If Not lu_search.Border Then lu_search.Border = True
				Next
				
				iu_dynamic_gui_tab_strip.BringToTop = True
			End If
			
			If IsValid(iu_vscrollbar) Then
				iu_vscrollbar.Visible 	= False
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Make all the sliders disappear
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index = 1 To UpperBound(iu_composite_report_horizontal_slider[])
				If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
					This.of_closeuserobject(iu_composite_report_horizontal_slider[ll_index])					
				End If
			Next
		Case Vertical
			For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
				If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue

				ll_horizontalreportcount = ll_horizontalreportcount + 1
				lu_search = Properties.ChildReportSearchObject[ll_index]
				If Not lu_search.Border Then lu_search.Border = True
				If Not lu_search.Visible Then lu_search.Visible = True
				lu_search.Width 	= (Width - (il_left_indent + il_right_indent) - (ll_valid_count - 1) * il_distance_between_reports) / ll_valid_count
				lu_search.X			= il_left_indent + (lu_search.Width + il_distance_between_reports) * (ll_horizontalreportcount - 1)
				lu_search.Y 		= ll_y_position
				lu_search.Height	= ll_max_height - il_top_margin - lu_search.Y
			Next
		Case Horizontal
			For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
				If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue

				ll_horizontalreportcount = ll_horizontalreportcount + 1
				lu_search = Properties.ChildReportSearchObject[ll_index]
				If Not lu_search.Border Then lu_search.Border = True
				If Not lu_search.Visible Then lu_search.Visible = True
				lu_search.Height 	= ((ll_max_height - ll_y_position) - il_top_margin - (ll_valid_count - 1) * il_distance_between_reports) / ll_valid_count
				lu_search.Y			= ll_y_position + (lu_search.Height + il_distance_between_reports) * (ll_horizontalreportcount - 1)
				lu_search.X 		= il_left_indent
				lu_search.Width	= Width - il_left_indent - il_right_indent
			Next
		Case Tiled
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Loop through the searches and set their positions.  Save the widths for later.
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
				lu_search = Properties.ChildReportSearchObject[ll_index]
				If IsValid(lu_search) Then
					lu_search.Move(il_left_indent, ll_y_position)

					If Not lu_search.Border Then lu_search.Border = True
					If Not lu_search.Visible Then lu_search.Visible = True
					
					If Properties.ChildReportIsExpanded[ll_index] Then
						Properties.ChildReportHeight[ll_index] = lu_search.Height
					End If
				
					ll_y_position = ll_y_position + lu_search.Height + il_distance_between_reports
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Position the slider
					//-----------------------------------------------------------------------------------------------------------------------------------
					If UpperBound(iu_composite_report_horizontal_slider[]) >= ll_index Then
						If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
							iu_composite_report_horizontal_slider[ll_index].Move(il_left_indent, lu_search.Y + lu_search.Height)
							iu_composite_report_horizontal_slider[ll_index].Height		= 10
						End If
					End If
					
					ll_max_position = Max(ll_max_position, lu_search.Y + lu_search.Height)
				Else
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Close the slider that got away
					//-----------------------------------------------------------------------------------------------------------------------------------
					If UpperBound(iu_composite_report_horizontal_slider[]) >= ll_index Then
						If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
							This.of_closeuserobject(iu_composite_report_horizontal_slider[ll_index])
						End If
					End If
				End If
		
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Set the visibility of the slider based on the expandedness of the report
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(iu_composite_report_horizontal_slider[]) >= ll_index Then
					If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
						iu_composite_report_horizontal_slider[ll_index].Visible = Properties.ChildReportIsExpanded[ll_index]
					End If
				End If
			Next
		
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Determine the parameters of the scroll bar
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsValid(iu_vscrollbar) Then
				If ll_max_position > ll_total_height Or il_vertical_scroll_position > 0 Then
					iu_vscrollbar.Visible = ll_valid_count > 0
					If ib_recalculate_scroll_parameters Then
						ll_max_position = ll_max_position + 200
						iu_vscrollbar.of_set_maxposition		(Max(il_vertical_scroll_position + This.Height - ll_titlebar_height, ll_max_position))
						iu_vscrollbar.of_set_scroll_increment	(Max(il_vertical_scroll_position + This.Height - ll_titlebar_height, ll_max_position) / 40)//ll_max_position / 10)
						iu_vscrollbar.of_set_position			(il_vertical_scroll_position)
					End If
				Else
					iu_vscrollbar.Visible = False
				End If
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Set the widths.  We don't really know this until we know if the scroll bar is visible or not
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
				lu_search = Properties.ChildReportSearchObject[ll_index]
				If IsValid(lu_search) Then
					If IsValid(iu_vscrollbar) Then
						If iu_vscrollbar.Visible Then
							lu_search.Width = Width - il_left_indent - il_right_indent - iu_vscrollbar.Width
						Else
							lu_search.Width = Width - il_left_indent - il_right_indent
						End If
					Else
						lu_search.Width = Width - il_left_indent - il_right_indent
					End If
					
					If UpperBound(iu_composite_report_horizontal_slider[]) >= ll_index Then
						If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
							iu_composite_report_horizontal_slider[ll_index].Width = lu_search.Width
						End If
					End If
					
				End If
			Next	
		Case Else
	End Choose
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Size the scroll bar
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_vscrollbar) Then
	If iu_vscrollbar.Visible Then
		iu_vscrollbar.Y = ll_titlebar_height
		iu_vscrollbar.Height = ll_max_height - iu_vscrollbar.Y
		iu_vscrollbar.X = This.Width - iu_vscrollbar.Width
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Size the title bar
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_title_button_bar) Then
	If iu_title_button_bar.Visible Then
		iu_title_button_bar.Width = Width
		iu_title_button_bar.BringToTop = True
	End If
End If

If IsValid(iu_criteria) Then
	iu_criteria.BringToTop = True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Size the width of the conversion strip
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_report_conversion_strip) Then
	If iu_report_conversion_strip.Visible Then
		iu_report_conversion_strip.Width = This.Width
		iu_report_conversion_strip.BringToTop = True
	End If
End If

This.of_SetRedraw(True)
end event

on u_dynamic_gui_report_adapter.create
int iCurrent
call super::create
this.st_placeholder=create st_placeholder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_placeholder
end on

on u_dynamic_gui_report_adapter.destroy
call super::destroy
destroy(this.st_placeholder)
end on

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//					aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
u_search lu_search
String ls_reportconfigid, ls_return, ls_modulename
Long ll_reportconfigid, ll_index, ll_handle, ll_validreportcount, ll_upperbound
w_select_composite_report lw_select_composite_report

//-----------------------------------------------------------------------------------------------------------------------------------
// Case Statement based on message
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_message))
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
	Case 'menucommand'
		If UpperBound(Properties.ChildReportSearchObject[]) = 1 Then
			If IsValid(Properties.ChildReportSearchObject[1]) Then
				Properties.ChildReportSearchObject[1].Event ue_notify(as_message, as_arg)
				Return
			End If
		End If
		
		Choose Case Lower(Trim(String(as_arg)))
			Case 'close'
				This.of_close()
		End Choose
		
   Case 'button clicked', 'buttonclicked'
		Choose Case Lower(String(as_arg))
			Case 'add report', 'manage reports'
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Open the window that allows you to add reports to the composite
				//-----------------------------------------------------------------------------------------------------------------------------------
				ll_upperbound = UpperBound(Properties.ChildReportSearchObject[])
				OpenWithParm(lw_select_composite_report, This)
				If UpperBound(Properties.ChildReportSearchObject[]) > ll_upperbound Then
					For ll_index = ll_upperbound + 1 To UpperBound(Properties.ChildReportSearchObject[])
						If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
						
						If Not Properties.ChildReportIsParentObject[ll_index] Then Continue
					Next 
				End If
			Case 'retrieve'
				If IsValid(This.of_create_criteria()) Then
					iu_criteria.of_retrieve()
				Else
					For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
						If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
						If Not Properties.ChildReportIsParentObject[ll_index] Then Continue
						
						Properties.ChildReportSearchObject[ll_index].Event ue_notify(as_message, as_arg)
					Next
				End If
				
			Case 'criteria'
				If IsValid(of_create_criteria()) Then
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Set the height to 0 or original
					//-----------------------------------------------------------------------------------------------------------------------------------
					If iu_criteria.Height = il_original_criteria_height Then
						iu_criteria.Height = 0
						iu_criteria.Visible = False
					Else
						iu_criteria.Height = il_original_criteria_height
						iu_criteria.Visible = True
					End If
					
//??? Will this work for .Net?
					#IF defined PBDOTNET THEN
						THIS.Event Resize(0, width, height)
					#ELSE
						THIS.TriggerEvent('Resize')
					#END IF
				End If
				
			Case	'close'
				This.of_close()
				
		End Choose
		
		Choose Case Left(Lower(Trim(String(as_arg))), 9)
			Case 'zoominout'
				ll_handle = Long(Mid(String(as_arg), Pos(String(as_arg), '=') + 1))
				
				For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
					If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
						If Handle(Properties.ChildReportSearchObject[ll_index])  = ll_handle Then
							This.of_zoom(Properties.ChildReportSearchObject[ll_index])
							Exit
						End If
					End If
				Next
				
//??? Will this work for .Net?
				#IF defined PBDOTNET THEN
					THIS.Event Resize(0, width, height)
				#ELSE
					THIS.TriggerEvent('Resize')
				#END IF
		End Choose		
		
		Choose Case Left(Lower(Trim(String(as_arg))), 8)
			Case 'retrieve'
				ll_handle = Long(Mid(String(as_arg), Pos(String(as_arg), '=') + 1))
				
				For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
					If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
						If Handle(Properties.ChildReportSearchObject[ll_index])  = ll_handle Then
							iu_search_that_we_are_retrieving_by_itself = Properties.ChildReportSearchObject[ll_index]
							If IsValid(This.of_create_criteria()) Then
								This.Event ue_notify('button clicked', 'retrieve')
							Else
							End If
							SetNull(iu_search_that_we_are_retrieving_by_itself)
							Exit
						End If
					End If
				Next
		End Choose		
	Case 'expandorcollapse'
		If Not IsNull(as_arg) And IsValid(as_arg) Then
			lu_search = as_arg
			This.of_collapse_or_expand(lu_search)
//??? Will this work for .Net?
			#IF defined PBDOTNET THEN
				THIS.Event Resize(0, width, height)
			#ELSE
				THIS.TriggerEvent('Resize')
			#END IF
		End If
	Case 'u_search closing'
		If Not IsNull(as_arg) And IsValid(as_arg) Then
			lu_search = as_arg
//??? Will this work for .Net?
			#IF defined PBDOTNET THEN
				THIS.Event Post Resize(0, width, height)
			#ELSE
				THIS.PostEvent('Resize')
			#END IF
//			For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
//				If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
//					If lu_search = Properties.ChildReportSearchObject[ll_index] Then
//						If UpperBound(iu_composite_report_horizontal_slider[]) >= ll_index Then
//							If IsValid(iu_composite_report_horizontal_slider[ll_index]) Then 
//								This.of_closeuserobject(iu_composite_report_horizontal_slider[ll_index])
//							End If
//						End If
//						
//						This.PostEvent('resize')
//					Else
//						ll_validreportcount = ll_validreportcount + 1
//					End If
//				End If
//			Next
			
			If Not Properties.IsCompositeReport Then
				For ll_index = 1 To UpperBound(Properties.ChildReportSearchObject[])
					If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
						If Properties.ChildReportSearchObject[ll_index] <> lu_search Then
							Return
						End If
					End If
				Next

				This.Post of_close()
			End If
		End If


	Case 'slider moved'
		For ll_index = 1 To Min(UpperBound(Properties.ChildReportSearchObject[]), UpperBound(iu_composite_report_horizontal_slider[]))
			If IsValid(Properties.ChildReportSearchObject[ll_index]) And IsValid(iu_composite_report_horizontal_slider[ll_index]) Then
				If iu_composite_report_horizontal_slider[ll_index].Visible Then
					Properties.ChildReportSearchObject[ll_index].Height = Max(il_collapsed_search_height + 100, iu_composite_report_horizontal_slider[ll_index].Y - Properties.ChildReportSearchObject[ll_index].Y)
				End If
			End If
		Next
		
//??? Will this work for .Net?
		#IF defined PBDOTNET THEN
			THIS.Event Resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('Resize')
		#END IF
	Case 'vscroll'
		il_vertical_scroll_position = Long(as_arg)
		ib_recalculate_scroll_parameters = False
//??? Will this work for .Net?
		#IF defined PBDOTNET THEN
			THIS.Event Resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('Resize')
		#END IF
		ib_recalculate_scroll_parameters = True
	Case 'change view'
		This.of_set_view(String(as_arg))
//??? Will this work for .Net?
		#IF defined PBDOTNET THEN
			THIS.Event Resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('Resize')
		#END IF
	Case 'add to desktop'
		Choose Case String(Lower(as_arg))
			Case 'traders desktop'
				ls_modulename = 'u_dynamic_gui_dsv_trader_desktop'
			Case 'scheduling desktop'
				ls_modulename = 'u_dynamic_gui_dsv_scheduler_desktop'
			Case 'accounting desktop'
				ls_modulename = 'u_dynamic_gui_dsv_accounting'
			Case 'config desktop'
				ls_modulename = 'u_dynamic_gui_dsv_position_desktop'
			Case 'smart search'
				ls_modulename = 'w_basewindow_rightangle_explorer'
			Case Else
				Return
		End Choose
		
		n_reporting_object_service ln_reporting_object_service 
		ln_reporting_object_service = Create n_reporting_object_service
		ln_reporting_object_service.of_add_to_desktop(ls_modulename, Properties.RprtCnfgID, Properties.UserID)
		Destroy ln_reporting_object_service
		
	Case	'unitofmeasure changed'
		gn_globals.in_subscription_service.of_message('UOM Conversion', This, This)
   Case Else
End Choose
end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Set the User ID and get the registry
//	Created by: Blake Doerr
//	History:    4/14/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Properties = Create n_report_composite

This.of_set_view(Properties.ViewType)

end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  YES!!!!!!!!  Otherwise of_closeuserobject will destroy every object
//	Arguments:	
//	Overview:   This will save settings before closing all the objects
//	Created by: Blake Doerr
//	History:    3/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


This.of_save_settings()

Call Super::Destructor

Destroy Properties
end event

event ue_showmenu;call super::ue_showmenu;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_showmenu
//	Overrides:  No
//	Arguments:	
//	Overview:   This will show the correct menu
//	Created by: Blake Doerr
//	History:    6/9/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 	ll_validcount = 0
Long 	ll_index
Long	ll_upperbound

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Window lw_window
u_search lu_search
m_dynamic lm_menu
m_dynamic lm_dynamic_menu
Menu lm_cascaded_menu
Menu	lm_return_menu
//-----------------------------------------------------------------------------------------------------------------------------------
// If we have an original search, show its menu (not a composite report)
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_original_search_object) And Not Properties.IsCompositeReport Then
	iu_original_search_object.Event ue_showmenu()
	Return
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Count the number of valid searches
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = UpperBound(Properties.ChildReportSearchObject[]) To 1 Step -1
	If IsValid(Properties.ChildReportSearchObject[ll_index]) Then
		ll_validcount = ll_validcount + 1
		lu_search = Properties.ChildReportSearchObject[ll_index]
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is only one, show its menu
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_validcount = 1 And Not Properties.IsCompositeReport Then
	lu_search.Event ue_showmenu()
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create a dynamic menu and set the target object as this object
//-----------------------------------------------------------------------------------------------------------------------------------
lm_dynamic_menu = create m_dynamic
lm_dynamic_menu.of_set_object (this)

lm_dynamic_menu.of_add_item('&Add Reports', 'button clicked', 'add report').Enabled = Properties.CanAddReports

If Len(Trim(Properties.CriteriaUserObject)) > 0 Then
	lm_dynamic_menu.of_add_item('&Retrieve', 'button clicked', 'retrieve')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the parent window
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window = This.of_getparentwindow()

//-------------------------------------------------------------------
// Add cascading menu to add reports to desktops
//-------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
// Create a new menu and set this as it's target object.  Add a spacer and the cascade menuitem.
//-----------------------------------------------------------------------------------------------------------------------------------
lm_menu = Create m_dynamic
lm_menu.of_set_object(This)
lm_menu.of_add_item('-','','')
lm_cascaded_menu = lm_menu.of_add_item('Change View', 'menucommand', '')
lm_cascaded_menu.Enabled = Properties.CanChangeView

//-----------------------------------------------------------------------------------------------------------------------------------
// Attach the new menu items to the original menu
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = UpperBound(lm_dynamic_menu.item)
lm_dynamic_menu.item[ll_upperbound + 1] = lm_menu.item[1]
lm_dynamic_menu.item[ll_upperbound + 2] = lm_menu.item[2]

//-----------------------------------------------------------------------------------------------------------------------------------
// Add options to the cascaded menu
//-----------------------------------------------------------------------------------------------------------------------------------
lm_return_menu	= lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Tabbed', 'change view', Tabbed)
lm_return_menu.Checked = (Properties.ViewType = Tabbed)

lm_return_menu	= lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Tiled', 'change view', Tiled)
lm_return_menu.Checked = (Properties.ViewType = Tiled)

lm_return_menu	= lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Vertical', 'change view',  Vertical)
lm_return_menu.Checked = (Properties.ViewType = Vertical)

lm_return_menu	= lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Horizontal', 'change view', Horizontal)
lm_return_menu.Checked = (Properties.ViewType = Horizontal)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create a new menu and set this as it's target object.  Add a spacer and the cascade menuitem.
//-----------------------------------------------------------------------------------------------------------------------------------
If Properties.AllowAddingToDesktops Then
	lm_menu = Create m_dynamic
	lm_menu.of_set_object(This)
	lm_menu.of_add_item('-','','')
	lm_cascaded_menu = lm_menu.of_add_item('Add Report to Desktop', 'menucommand', '')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Attach the new menu items to the original menu
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_upperbound = UpperBound(lm_dynamic_menu.item)
	lm_dynamic_menu.item[ll_upperbound + 1] = lm_menu.item[1]
	lm_dynamic_menu.item[ll_upperbound + 2] = lm_menu.item[2]
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add options to the cascaded menu
	//-----------------------------------------------------------------------------------------------------------------------------------
	lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Add Report to RightAngle Explorer Favorites', 'add to desktop', 'smart search')
	lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Add Report to Trader~'s Desktop', 'add to desktop', 'traders desktop')
	lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Add Report to Scheduling Workbench', 'add to desktop', 'scheduling workbench')
	lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Add Report to Accounting Desktop', 'add to desktop', 'accounting desktop')
	lm_dynamic_menu.of_add_item(lm_cascaded_menu, 'Add Report to Pricing Desktop', 'add to desktop', 'config desktop')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the close item to the desktop
//-----------------------------------------------------------------------------------------------------------------------------------
If Properties.AllowClosing Then
	lm_dynamic_menu.of_add_item('-','','')
	lm_dynamic_menu.of_add_item('&Close', 'menucommand', 'close')
End If

//----------------------------------------------------------------------------------------------------------------------------------
// display the already created menu object.
//-----------------------------------------------------------------------------------------------------------------------------------
if lw_window.windowtype = Response! Or lw_window.windowtype = Popup! then
	lm_dynamic_menu.popmenu( lw_window.pointerx(), lw_window.pointery())
else
	If ib_MenuCoordinatesAreSpecified Then
		lm_dynamic_menu.popmenu(il_MenuPointerX, il_MenuPointerY)
	Else
		lm_dynamic_menu.popmenu( w_mdi.pointerx(), w_mdi.pointery())
	End If
end if
end event

event type long ue_close();call super::ue_close;Long ll_index, ll_upperbound, ll_return

ll_upperbound = UpperBound(Properties.ChildReportSearchObject[])
FOR ll_index = 1 TO ll_upperbound 
	If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue

	//Call the ue_close message to see if he wants to close himself
	ll_return = Properties.ChildReportSearchObject[ll_index].Event ue_close()
		
	//If the object said that it didn't want to be closed, we won't close
	If ll_return = 1 Then Return 1
NEXT

return 0
end event

event dragdrop;call super::dragdrop;Long ll_index
PowerObject lo_message

lo_message = Message.PowerObjectParm

For ll_index = 1 To Min(UpperBound(Properties.ChildReportSearchObject[]), UpperBound(Properties.ChildReportIsParentObject[]))
	If Not IsValid(Properties.ChildReportSearchObject[ll_index]) Then Continue
	If Not Properties.ChildReportIsParentObject[ll_index] Then Continue
	
	Message.PowerObjectParm = lo_message
	
	Properties.ChildReportSearchObject[ll_index].Event DragDrop(source)
Next

end event

type st_placeholder from statictext within u_dynamic_gui_report_adapter
boolean visible = false
integer x = 338
integer y = 120
integer width = 1399
integer height = 460
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = " Select ~"Add Report(s)~" to view the list of available reports."
boolean border = true
boolean focusrectangle = false
end type

