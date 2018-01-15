$PBExportHeader$n_pivot_table_service.sru
$PBExportComments$This will create a crosstab/pivot table style report from a datawindow that already has retrieved data.
forward
global type n_pivot_table_service from nonvisualobject
end type
type str_string_array from structure within n_pivot_table_service
end type
type str_datetime_array from structure within n_pivot_table_service
end type
type str_number_array from structure within n_pivot_table_service
end type
type str_columndata from structure within n_pivot_table_service
end type
end forward

type str_string_array from structure
	string		data[]
end type

type str_datetime_array from structure
	datetime		data[]
end type

type str_number_array from structure
	double		data[]
end type

type str_columndata from structure
	string		display[]
	string		stringdata[]
	datetime		datetimedata[]
	double		numberdata[]
	long		order[]
end type

global type n_pivot_table_service from nonvisualobject
event type string ue_notify ( string as_message,  any as_arg )
end type
global n_pivot_table_service n_pivot_table_service

type variables
//-----------------------------------------------------------------------------------------------------------------------------------
// Structures to hold the data pulled out of the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
Private	str_string_array 		lstr_rowstring[20]
Private	str_string_array 		lstr_columnstring[20]
Private	str_string_array 		lstr_aggregatestring[20]

Private	str_datetime_array 	lstr_rowdatetime[20]
Private	str_datetime_array 	lstr_columndatetime[20]
Private	str_datetime_array 	lstr_aggregatedatetime[20]

Private	str_number_array 		lstr_rownumber[20]
Private	str_number_array 		lstr_columnnumber[20]
Private	str_number_array 		lstr_aggregatenumber[20]
Private	str_number_array 		lstr_aggregateweightednumber[20]

Private	str_columndata 		istr_columndata[20]

Protected:
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Objects to hold the makeup of the pivot table
	//-----------------------------------------------------------------------------------------------------------------------------------
	n_pivot_table_element		in_pivot_table_row[]
	n_pivot_table_element		in_pivot_table_column[]
	n_pivot_table_element		in_pivot_table_aggregate[]
	n_pivot_table_element		in_pivot_table_properties

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Filtering Information
	//-----------------------------------------------------------------------------------------------------------------------------------
	Double 	idble_selected_quantity
	String 	is_filter_string
	String	is_grid_columnname[]

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reporting Information
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long 		il_reportconfigid
	Long		il_userid
	Long		il_current_reportconfigpivottableid
	String 	is_entity
	String	is_DestroyStringForComputedFieldsWhenAutoPivot
	String	is_OriginalDatawindowObjectName

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Datastores, Datawindows, Transactions, and other objects
	//-----------------------------------------------------------------------------------------------------------------------------------
	PowerObject 			io_datasource
	PowerObject 			io_subscribed_dataobjects[]
	Transaction 			ixctn_transaction
	n_datawindow_tools 	in_datawindow_tools
	n_navigation_options in_navigation_options
	Datastore 				ids_data_creation
	Datastore 				ids_grid_creation
	Datastore 				ids_data_storage
	Datastore 				ids_dummy_datastore
	Datawindow 				idw_destination
	u_search 				iu_search
	u_search 				iu_original_search
	u_search 				iu_search_detail

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Report Building Information
	//-----------------------------------------------------------------------------------------------------------------------------------
	Boolean	ib_we_need_to_sort_the_column_headers 	= False
	Boolean	ib_we_have_stacked_headers					= False
	Boolean	ib_we_are_applying_a_view 					= False
	Boolean 	ib_autopivoting 								= False
	Boolean	ib_batchmode 									= False
	Boolean	ib_ReportHasBeenFiltered					= False
	Boolean	ib_IgnoreUOMConversion						= False
	Long 		il_number_of_columns
	Long		il_number_of_groups
	String	is_grand_total_line
	String	is_rightmost_object

//-----------------------------------------------------------------------------------------------------------------------------------
// Datawindow Syntax Variables
//-----------------------------------------------------------------------------------------------------------------------------------
	Long 		il_computed_field_count 			= 0
	Long		il_line_count 							= 0
	Long		il_line_count_header					= 0
	Long		il_line_count_detail					= 0
	Long		il_line_count_footer					= 0
	Long 		il_bitmap_count 						= 0
	Long		il_column_widths[]
	String 	is_complete_syntax					= ''
	String 	is_gui_columns 						= ''
	String 	is_gui_computed_fields 				= ''
	String 	is_gui_lines 							= ''
	String 	is_gui_groupings 						= ''
	String 	is_gui_statictext 					= ''
	String 	is_gui_bitmaps 						= ''
	String	is_gui_suppressrepeatingvalues	= ''
	String	is_special_expression_objects[]
	String	is_special_expression[]

	
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Style Sheet Variables
//-----------------------------------------------------------------------------------------------------------------------------------

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Datawindow Style Sheet Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long		il_left_margin									= 78
	Long 		il_datawindow_backcolor 					= 16777215
	Long 		il_fontsize 									= -8

	Long 		il_header_height 								= 210
	Long 		il_additional_header_height 				= 0

	Long 		il_grouping_header_height 					= 60
	Long 		il_grouping_trailer_height 				= 100
	Long 		il_grouping_additional_trailer_height 	= 0

	Long 		il_detailheight 								= 60
	Long 		il_additional_detail_height				= 0

	Long 		il_summary_height 							= 0

	Long 		il_footerheight 								= 192
	Long 		il_additional_footer_height 				= 0

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Row Style Sheet Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long 	il_row_alignment 		= 0
	Long 	il_row_indention 		= 50
	Long	il_row_fontweight		= 700
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Static Text Style Sheet Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long 		il_statictext_color 			= 0
	Long 		il_statictext_fontweight 	= 400
	Long 		il_statictext_fontsize 		= -8
	String 	is_statictext_fontface 		= 'Tahoma'
	

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Column Style Sheet Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long 		il_alignment 			= 1
	Long 		il_column_color 		= 0
	Long 		il_column_height 		= 55
	Long 		il_column_width 		= 375
	Long 		il_column_spacing 	= 30
	Long 		il_aggregate_spacing = 10
	Long 		il_column_fontweight = 400
	Long 		il_column_fontsize 	= -8
	String 	is_column_fontface 	= 'Tahoma'
	String 	is_column_pointer 	= 'point.cur'

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Computed Field Style Sheet Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long 		il_computed_field_color 		= 0
	Long 		il_computed_field_height 		= 53
	Long 		il_computed_field_width 		= 200
	Long 		il_computed_field_fontweight 	= 700
	Long 		il_computed_field_fontsize 	= -8
	String 	is_computed_field_fontface 	= 'Tahoma'
	String 	is_computed_field_pointer 		= 'point.cur'
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Line Style Sheet Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Long 	il_line_color = 12632256
	Long 	il_line_style = 0
	Long 	il_line_width = 5
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Bitmap Style Sheet Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	String	is_expanded_bitmap	= 'smallminus.bmp'
	String	is_contracted_bitmap	= 'smallplus.bmp'

end variables

forward prototypes
public function datawindow of_get_destination ()
public function long of_get_reportconfigid ()
public function long of_get_userid ()
public subroutine of_set_userid (long al_userid)
public function u_search of_get_report_object ()
public subroutine of_get_views (ref long al_reportconfigpivottableid[], ref string as_viewname[])
public function string of_get_xml_state ()
public function boolean of_get_graphing ()
private subroutine of_build_report_title_graph ()
public function string of_get_title ()
private subroutine of_build_column (string as_columnname, string as_datawindow_band, long al_x_position, long al_y_position, long al_column_width, string as_column_format)
public subroutine of_set_autopivot (boolean ab_autopivot)
public subroutine of_set_batch_mode (boolean as_batchmode)
public subroutine of_set_destination (datawindow adw_destination)
public subroutine of_set_reportconfigid (long al_reportconfigid)
public function boolean of_will_open_new_window ()
public function string of_create_dummy_datastore ()
public function boolean of_should_destroy ()
private function string of_build_line (string as_datawindow_band, long al_x1_position, long al_x2_position, long al_y_position, boolean ab_usenamingstandard)
public function string of_copy_datasource ()
public function string of_refresh ()
public function string of_get_reporttype ()
public function long of_save_view ()
private subroutine of_build_computed_field (string as_expression, string as_datawindow_band, long al_x_position, long al_y_position, long al_column_width, string as_column_format, long al_alignment)
private subroutine of_build_grouping (long al_level, string as_column_list, long al_grouping_header_height, long al_grouping_trailer_height, boolean ab_groupresetpagecount, boolean ab_groupnewpageongroupbreak)
private subroutine of_build_computed_field (string as_expression, string as_datawindow_band, long al_x_position, long al_y_position, long al_column_width, string as_column_format, long al_alignment, string as_name)
public function string of_insert_data_graph ()
public function string of_set_datasource (ref powerobject apo_datasource)
public function string of_determine_column (long xpos)
public function string of_export_public ()
public subroutine of_get_current_state (ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties)
public function powerobject of_get_datasource ()
public subroutine of_present_gui ()
private subroutine of_build_statictext (string as_name, string as_text, string as_band, long al_x_position, long al_y_position, long al_height, long al_width, long al_alignment, long al_fontsize, long al_fontweight)
public function string of_build_gui_datawindow_modifies ()
public function string of_sort_columns ()
public subroutine of_reset ()
public function string of_get_coltype (string as_columnname)
public function string of_validate ()
public function string of_import_public ()
private subroutine of_build_bitmap (string as_bitmapname, string as_band, long al_x_position, long al_y_position, long al_width, long al_height)
public function long of_filter (long xpos, long ypos, long row, dwobject dwo)
public subroutine of_rbuttondown (long xpos, long ypos, long row, ref dwobject dwo)
public function long of_get_current_view_id ()
public subroutine of_set_report_object (u_search au_search)
public function long of_filter (string as_filterstring)
public function string of_open_pivottable_report ()
public subroutine of_doubleclicked (long xpos, long ypos, long row, ref dwobject dwo)
protected function string of_get_column_display_value (n_pivot_table_element an_pivot_table_element, long al_index)
public function string of_create_grid_dataobject_graph ()
public function string of_build_gui_datawindow_graph ()
public subroutine of_add_expression (string as_object, string as_property, string as_expression)
public function string of_apply ()
public function string of_apply_view (long al_reportconfigpivottableid)
public function string of_apply_view (string as_xml_document)
public function string of_build_gui_datawindow_column_totals_all (ref long al_ending_x_position_of_last_object, string as_total_computed_field_for_all[])
public function string of_build_gui_datawindow_row (ref long al_ending_x_position_of_last_object)
public function string of_create_grid_dataobject ()
public subroutine of_show_detail (long row)
public subroutine of_arrange_pivot_elements ()
public function string of_insert_data ()
public function string of_add_element (n_pivot_table_element an_pivot_table_element)
public function string of_build_gui_datawindow ()
public function string of_build_gui_datawindow_column (ref long al_ending_x_position_of_last_object)
public function string of_get_data ()
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public function string of_build_gui_datawindow_column_totals (ref long al_ending_x_position_of_last_object, string as_total_computed_field[])
end prototypes

event type string ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	6/10/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_return
String	ls_description
String	ls_xml_document
String	ls_pathname
String	ls_filename
String	ls_original_filter
Long		ll_viewid
Long		ll_return
Long		ll_current_reportconfigpivottableid
Blob		lblob_xml_document

w_reportconfig_manage_views lw_reportconfig_manage_views
n_bag ln_bag
n_blob_manipulator ln_blob_manipulator
n_pivot_table_view_service ln_pivot_table_view_service
n_common_dialog ln_common_dialog 
n_folderbrowse ln_folderbrowse
//n_string_functions ln_string_functions

Choose Case Lower(Trim(as_message))
	case 'pivot table applied'
	Case 'manage pivot table views'
		ln_bag = Create n_bag
		ln_bag.of_set('RprtCnfgID', il_reportconfigid)
		ln_bag.of_set('type', 'pivot table')
			
		OpenWithParm(lw_reportconfig_manage_views, ln_bag, 'w_reportconfig_manage_views', w_mdi_frame)
	Case 'pivot table view'
		Return This.of_apply_view(Long(as_arg))

	Case 'pivot table view menu'
		ls_return = This.of_apply_view(Long(as_arg))
		
		If ls_return <> '' Then
			If Not ib_batchmode Then
				gn_globals.in_messagebox.of_messagebox_validation(ls_return)
			End If
		End If
	Case 'save view'
		Return String(This.of_save_view())

	Case 'retrieveend', 'refresh pivot table', 'uom conversion'
		Choose Case Lower(Trim(as_message))
			Case 'uom conversion'
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Ignore the conversion if we are retrieving
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Lower(Trim(String(io_datasource.Event Dynamic ue_areweretrieving()))) = 'yes' Then Return ls_return
		End Choose

		ll_current_reportconfigpivottableid = il_current_reportconfigpivottableid
		
		If il_current_reportconfigpivottableid > 0 And Not IsNull(il_current_reportconfigpivottableid) Then
			ib_we_are_applying_a_view = True
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Reset the datasource
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = This.of_copy_datasource()
		If ls_return <> '' Then
			ib_we_are_applying_a_view = False
			Return ls_return
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Refresh the pivot information
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_refresh()
		If ls_return <> '' Then
			ib_we_are_applying_a_view = False
			Return ls_return
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Apply the pivot table
		//-----------------------------------------------------------------------------------------------------------------------------------
		il_current_reportconfigpivottableid = ll_current_reportconfigpivottableid
		This.of_apply()
		If ls_return <> '' Then
			ib_we_are_applying_a_view = False
			Return ls_return
		End If

		ib_we_are_applying_a_view = False
		
		If Not IsValid(iu_search_detail) Or IsNull(is_filter_string) Then Return ''
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the filter on the storage object, return if the filter wasn't valid
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_filter(is_filter_string)
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Show the detail report
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_show_detail(0)
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Filter the datastore back
		//-----------------------------------------------------------------------------------------------------------------------------------
		ids_data_storage.SetFilter('')
		ids_data_storage.Filter()
	Case 'present gui'
		This.of_present_gui()
		
	Case 'export view public'
		//This.of_export_public()
	Case 'import public view'
		This.of_import_public()
	Case 'export view'
		ln_folderbrowse = CREATE n_folderbrowse
		ls_pathname = Trim(ln_folderbrowse.of_browseforfolder(w_mdi_frame, 'Pick the destination file folder for this saved pivot view.'))
		Destroy ln_folderbrowse
		
		If Len(Trim(ls_pathname)) = 0 Then Return ''
		
		If Right(ls_pathname, 1) <> '\' Then ls_pathname = ls_pathname + '\'
		
		ls_description = in_pivot_table_properties.Description
		
		gn_globals.in_string_functions.of_replace_all(ls_description, '/', '-')
		gn_globals.in_string_functions.of_replace_all(ls_description, '\', '-')
		gn_globals.in_string_functions.of_replace_all(ls_description, ':', '-')
		gn_globals.in_string_functions.of_replace_all(ls_description, '*', '-')
		gn_globals.in_string_functions.of_replace_all(ls_description, '|', '-')
		gn_globals.in_string_functions.of_replace_all(ls_description, '>', '-')
		gn_globals.in_string_functions.of_replace_all(ls_description, '<', '-')
		gn_globals.in_string_functions.of_replace_all(ls_description, '?', '-')

		ls_pathname = ls_pathname + Trim(ls_description) + '.PivotView.RAIV'

		If FileExists(ls_pathname) Then
			If gn_globals.in_messagebox.of_messagebox_question ('This file already exists at this location, would you like to overwrite it', YesNoCancel!, 3) <> 1 Then Return ''
		End If

		ln_pivot_table_view_service = Create n_pivot_table_view_service
		ls_xml_document = ln_pivot_table_view_service.of_get_xml(in_pivot_table_row[], in_pivot_table_column[], in_pivot_table_aggregate[], in_pivot_table_properties)
		Destroy ln_pivot_table_view_service
		
		lblob_xml_document = Blob(ls_xml_document)
		
		ln_blob_manipulator = Create n_blob_manipulator
		ln_blob_manipulator.of_build_file_from_blob(lblob_xml_document, ls_pathname)
		Destroy ln_blob_manipulator
		
	Case 'import view'
		ln_common_dialog = Create n_common_dialog
		ll_return = ln_common_dialog.of_GetFileOpenName('Available Pivot View Files', ls_pathname, ls_filename ,'RAIV', "CustomerFocus Files (*.RAIV),*.RAIV")
		Destroy ln_common_dialog
		
		if ll_return <= 0 Then Return ''
		If len(ls_pathname) <= 0  Then Return ''
		If Not FileExists (ls_pathname) Then Return ''
		
		ln_blob_manipulator = Create n_blob_manipulator 
		lblob_xml_document = ln_blob_manipulator.of_build_blob_from_file(ls_pathname)
		Destroy ln_blob_manipulator
		
		ls_xml_document = String(lblob_xml_document)
		
		ls_return = This.of_apply_view(ls_xml_document)

		If ls_return <> '' Then
			If Not ib_batchmode Then
				gn_globals.in_messagebox.of_messagebox_validation(ls_return)
				This.Post of_present_gui()
			End If
		End If

End Choose

Return ls_return
end event

public function datawindow of_get_destination ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_destination()
//	Overview:   This will return the destination datawindow
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return idw_destination
end function

public function long of_get_reportconfigid ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_reportconfigid()
//	Overview:   Returns the report config id
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_reportconfigid
end function

public function long of_get_userid ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_userid()
//	Overview:   Returns the user id
//	Created by:	Blake Doerr
//	History: 	2/7/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_userid
end function

public subroutine of_set_userid (long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_userid()
//	Overview:   Sets the user id
//	Created by:	Blake Doerr
//	History: 	2/7/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_userid = al_userid
end subroutine

public function u_search of_get_report_object ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_report_object()
//	Overview:   Return the search object
//	Created by:	Blake Doerr
//	History: 	6/8/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


If IsValid(iu_original_search) Then
	Return iu_original_search
Else
	Return iu_search
End If
end function

public subroutine of_get_views (ref long al_reportconfigpivottableid[], ref string as_viewname[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_views()
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	Blake Doerr
//	History: 	6/10/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_pivot_table_view_service ln_pivot_table_view_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the views from the pivot table service
//-----------------------------------------------------------------------------------------------------------------------------------
ln_pivot_table_view_service = Create n_pivot_table_view_service
ln_pivot_table_view_service.of_set_userid(il_userid)
ln_pivot_table_view_service.of_set_reportconfigid(il_reportconfigid)
ln_pivot_table_view_service.of_get_views(al_reportconfigpivottableid[], as_viewname[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the service
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_pivot_table_view_service

end subroutine

public function string of_get_xml_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_xml_state()
//	Overview:   This will return an xml document that is the state of this pivot table
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_xmldocument
Long ll_index

n_pivot_table_view_service ln_pivot_table_view_service
ln_pivot_table_view_service = Create n_pivot_table_view_service
ls_xmldocument = ln_pivot_table_view_service.of_get_xml(in_pivot_table_row[], in_pivot_table_column[], in_pivot_table_aggregate[], in_pivot_table_properties)
Destroy ln_pivot_table_view_service

Return ls_xmldocument
end function

public function boolean of_get_graphing ();Return in_pivot_table_properties.IsGraph
end function

private subroutine of_build_report_title_graph ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_build_report_title_graph()
// Overview:   This will build a title based on the data used it will be in the format 
//  "Sum of the <Set Volume> Shown in a <Product> vs. <Origin Location and Set Name> Grid"
// Created by: Blake Doerr
// History:    12/23/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//------------------------------------------------------------------
// Local Variables
//------------------------------------------------------------------
Long ll_index
String ls_aggregateheader, ls_aggregatefunction

//------------------------------------------------------------------
// Empty the report title
//------------------------------------------------------------------
in_pivot_table_properties.Description = ''

//------------------------------------------------------------------
// Create a string of the aggregates show
//------------------------------------------------------------------
For ll_index = 1 To Max(UpperBound(in_pivot_table_aggregate[]), 1)
	If UpperBound(in_pivot_table_aggregate[]) = 0 Then
		ls_aggregateheader 	= 'Rows'
		ls_aggregatefunction = 'count'
	Else
		ls_aggregateheader 	= in_pivot_table_aggregate[ll_index].Description
		ls_aggregatefunction	= in_pivot_table_aggregate[ll_index].AggregateFunction
	End If
	
	Choose Case Lower(Trim(ls_aggregatefunction))
		Case 'sum'
			in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' Sum of the ' + ls_aggregateheader + ','
		Case 'min'
			in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' Minimum of the ' + ls_aggregateheader + ','
		Case 'max'
			in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' Maximum of the ' + ls_aggregateheader + ','			
		Case 'avg'
			in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' Average of the ' + ls_aggregateheader + ','						
		Case 'count'
			in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' Count of the ' + ls_aggregateheader + ','						
		Case Else
			in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' ' + ls_aggregateheader + ','						
	End Choose
Next

//------------------------------------------------------------------
// Add some verbiage
//------------------------------------------------------------------
in_pivot_table_properties.Description = Trim(Left(in_pivot_table_properties.Description, Len(in_pivot_table_properties.Description) - 1)) + ' vs. '

//------------------------------------------------------------------
// Create a string of the rows show
//------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row[])
	in_pivot_table_properties.Description = in_pivot_table_properties.Description + in_pivot_table_row[ll_index].Description
Next

//------------------------------------------------------------------
// Create a string of the columns show if there are some
//------------------------------------------------------------------
If UpperBound(in_pivot_table_column[]) > 0 Then
	in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' by ' + in_pivot_table_column[1].Description
End If

//------------------------------------------------------------------
// Add some verbiage
//------------------------------------------------------------------
in_pivot_table_properties.Description = in_pivot_table_properties.Description + ' Graph'
end subroutine

public function string of_get_title ();If IsValid(in_pivot_table_properties) Then
	Return in_pivot_table_properties.Description
Else
	Return ''
End If
end function

private subroutine of_build_column (string as_columnname, string as_datawindow_band, long al_x_position, long al_y_position, long al_column_width, string as_column_format);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  Function Name()
// Arguments:  as_columnname - The name of the column to apply the gui column to
//					as_datawindow_band - The band of the datawindow
//					al_x_position - The x position in the band
//					al_y_position - the y position for the band
//					as_column_format - The format of the column ([general], etc.)
// Overview:    DocumentScriptFunctionality
// Created by:  Blake Doerr
// History:     12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_id

ll_id = Long(ids_data_creation.Describe(as_columnname + '.ID'))

is_gui_columns = is_gui_columns + 'column(band=' + as_datawindow_band + &
' id=' + String(ll_id) + ' alignment="' + String(il_alignment) + '" 	tabsequence=32766 border="0" color="' + &
String(il_column_color) + '" 		x="' + String(al_x_position) + '" 	y="' + String(al_y_position) + &
'" 		height="' + String(il_column_height) + '" 			width="' + String(al_column_width) + &
'" format="' + as_column_format +'"  name=' + as_columnname + ' 	pointer="' + is_column_pointer + &
'" 	edit.limit=0 	edit.case=any 	edit.autoselect=yes 	edit.autohscroll=yes  	font.face="' + &
in_pivot_table_properties.FontName/*is_column_fontface*/  +'" font.height="' + String(il_column_fontsize) + '" font.weight="' + &
String(il_column_fontweight) + ' "  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="536870912" )~r~n'

If ll_id > 0 And Not IsNull(ll_id) Then
	is_grid_columnname[ll_id] = as_columnname
End If
end subroutine

public subroutine of_set_autopivot (boolean ab_autopivot);ib_autopivoting = ab_autopivot
end subroutine

public subroutine of_set_batch_mode (boolean as_batchmode);ib_batchmode = as_batchmode
end subroutine

public subroutine of_set_destination (datawindow adw_destination);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_destination()
//	Arguments:  adw_destination - The datawindow to stick the grid into
//	Overview:   This will store a pointer to the datawindow that the grid will be created in
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
idw_destination = adw_destination

end subroutine

public subroutine of_set_reportconfigid (long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_reportconfigid()
//	Arguments:  al_reportconfigid - The report config id
//	Overview:   This will store the report config id
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_reportconfigid = al_reportconfigid
end subroutine

public function boolean of_will_open_new_window ();Return Not IsValid(iu_search)
end function

public function string of_create_dummy_datastore ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_create_dummy_datastore()
//	Overview:   This will create a dummy datastore that will facilitate getting data from a numbered column into an array
//	Created by:	Blake Doerr
//	History: 	12.22.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_error,ls_syntax

//----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore for use in creating the virtual column list
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = 'release 7;~r~ndatawindow(units=0 timer_interval=0 color=16777215 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )~r~nheader(height=69 color="536870912" )~r~nsummary(height=1 color="536870912" )~r~nfooter(height=69 color="536870912" )~r~ndetail(height=81 color="536870912" )~r~ntable('

//----------------------------------------------------------------------------------------------------------------------------------
// create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = ls_syntax + 	' column=(type=char(255) updatewhereclause=no name=stringcolumn dbname="stringcolumn " ) ~r~n'
ls_syntax = ls_syntax + 	' column=(type=datetime updatewhereclause=no name=datetimecolumn dbname="datetimecolumn " ) ~r~n'
ls_syntax = ls_syntax + 	' column=(type=number updatewhereclause=no name=numbercolumn dbname="numbercolumn " ) ~r~n'
ids_dummy_datastore.create(ls_syntax + ')', ls_error)
If Len(ls_error) > 0 Then
	Return 'Error:  Could not create template datastore (' + ls_error + ')'
End If


Return ''
end function

public function boolean of_should_destroy ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_should_destroy()
//	Overview:   Returns whether or not this should be destroyed
//	Created by:	Blake Doerr
//	History: 	6/13/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//If IsValid(iu_search) And IsValid(iu_original_search) Then
//	If iu_search <> iu_original_search Then
//		Return False
//	End If
//End If

Return True
end function

private function string of_build_line (string as_datawindow_band, long al_x1_position, long al_x2_position, long al_y_position, boolean ab_usenamingstandard);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_build_line()
// Arguments:  as_datawindow_band - The band of the datawindow
//					al_x1_position - The x1 position in the band
//					al_x2_position - The x2 position in the band
//					al_y_position - the y position for the band
// Overview:    This will create a line based on parameters
// Created by:  Blake Doerr
// History:     12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String ls_name
If ab_usenamingstandard Then
	Choose Case Left(Trim(Lower(as_datawindow_band)), 6)
		Case 'header'
			il_line_count_header	= il_line_count_header + 1
			
			If il_line_count_header = 1 Then
				ls_name = 'line_header'
			Else
				ls_name = 'line_header' + String(il_line_count_header - 1)
			End If
		Case 'footer', 'traile'
			il_line_count_footer	= il_line_count_footer + 1
			
			If il_line_count_footer = 1 Then
				ls_name = 'line_footer'
			Else
				ls_name = 'line_footer' + String(il_line_count_footer - 1)
			End If
		Case Else
			il_line_count_detail	= il_line_count_detail + 1
			
			If il_line_count_detail = 1 Then
				ls_name = 'line_detail'
			Else
				ls_name = 'line_detail' + String(il_line_count_detail - 1)
			End If		
	End Choose
Else
	il_line_count = il_line_count + 1
	ls_name = 'line' + String(il_line_count)
End If	

is_gui_lines  = is_gui_lines  + 'line(band=' + as_datawindow_band +' name=' + ls_name + ' x1="' + String(al_x1_position) + '" y1="' + String(al_y_position) +'" x2="' + String(al_x2_position) + '" y2="' + String(al_y_position) + '" pen.style="' + String(il_line_style) + '" pen.width="' + String(il_line_width) + '" pen.color="' + String(il_line_color) + '"  background.mode="2" background.color="0" )~r~n'

Return ls_name
end function

public function string of_copy_datasource ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_datasource()
//	Arguments:  apo_datasource - The datawindow/datastore/?
//	Overview:   This will add get a pointer to the source of the data
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------------------------------------------------------
String	ls_error
Long	ll_return

//----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't valid
//----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(io_datasource) Then Return 'Error:  The data source is not valid'

If ib_autopivoting Then
	ids_data_storage.Dynamic Create(io_datasource.Dynamic Describe("Datawindow.Syntax"), ls_error)
	
	If Len(ls_error) > 0 Then Return 'Error:  Could not share report with pivot table (' + ls_error + ')'

	ll_return = io_datasource.Dynamic ShareData(ids_data_storage)

	If ll_return <= 0 Then Return 'Error:  Could not share data'

	//----------------------------------------------------------------------------------------------------------------------------------
	// We need to get all the dropdowndatawindow data also
	//----------------------------------------------------------------------------------------------------------------------------------
	in_datawindow_tools.of_share_dropdowndatawindows(io_datasource, ids_data_storage)
	
	If ib_ReportHasBeenFiltered And IsValid(iu_original_search) Then
		iu_original_search.Event ue_notify('reapply filter', '')
		ib_ReportHasBeenFiltered = False
	End If
Else
	in_datawindow_tools.of_copy_datawindow(io_datasource, ids_data_storage)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// We need to get all the dropdowndatawindow data also
	//----------------------------------------------------------------------------------------------------------------------------------
	in_datawindow_tools.of_copy_dropdowndatawindows(io_datasource, ids_data_storage)

End If

Return ''
end function

public function string of_refresh ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_refresh()
// Arguments:	rowcount - The rowcount
//	Overview:   This will reset the dataobject if necessary
//	Created by:	Blake Doerr
//	History: 	3/3/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long 		ll_index
String	ls_return

n_pivot_table_element		ln_pivot_table_row[]
n_pivot_table_element		ln_pivot_table_column[]
n_pivot_table_element		ln_pivot_table_aggregate[]
n_pivot_table_element		ln_pivot_table_properties

If Not IsValid(in_pivot_table_properties) Then Return ''

For ll_index = 1 To UpperBound(in_pivot_table_row[])
	ln_pivot_table_row[ll_index] = in_pivot_table_row[ll_index].of_clone()
Next

For ll_index = 1 To UpperBound(in_pivot_table_column[])
	ln_pivot_table_column[ll_index] = in_pivot_table_column[ll_index].of_clone()
Next

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	ln_pivot_table_aggregate[ll_index] = in_pivot_table_aggregate[ll_index].of_clone()
Next

ln_pivot_table_properties = in_pivot_table_properties.of_clone()

This.of_reset()

ls_return = This.of_add_element(ln_pivot_table_properties)

If ls_return <> '' Then Return ls_return

For ll_index = 1 To UpperBound(ln_pivot_table_row[])
	ls_return = This.of_add_element(ln_pivot_table_row[ll_index])
	If ls_return <> '' Then Return ls_return
Next

For ll_index = 1 To UpperBound(ln_pivot_table_column[])
	ls_return = This.of_add_element(ln_pivot_table_column[ll_index])
	If ls_return <> '' Then Return ls_return
Next

For ll_index = 1 To UpperBound(ln_pivot_table_aggregate[])
	ls_return = This.of_add_element(ln_pivot_table_aggregate[ll_index])
	If ls_return <> '' Then Return ls_return
Next

Return ''

end function

public function string of_get_reporttype ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_reporttype()
//	Overview:   Returns the report config id
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return 'R'
end function

public function long of_save_view ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save_view()
//	Overview:   This will save the view to the database
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean 	lb_globallyavailable, lb_AllowNavigation
Long 		ll_return
Long		ll_DataObjectStateIdnty
String 	ls_xml_document
String	ls_return
String	ls_description

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_bag 	ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the xml document
//-----------------------------------------------------------------------------------------------------------------------------------
ls_xml_document = This.of_get_xml_state()

//-----------------------------------------------------------------------------------------------------------------------------------
// Use the view service to save the view to the database
//-----------------------------------------------------------------------------------------------------------------------------------
n_pivot_table_view_service ln_pivot_table_view_service
ln_pivot_table_view_service = Create n_pivot_table_view_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Check the validity of the xml document
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = ln_pivot_table_view_service.of_isvaliddocument(ls_xml_document)

If ls_return <> '' Then
	gn_globals.in_messagebox.of_messagebox_validation(ls_return)
	Destroy ln_pivot_table_view_service
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Open the save view window
//-----------------------------------------------------------------------------------------------------------------------------------
OpenWithParm(w_pivot_table_service_save_view, This)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the view isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(Message.PowerObjectParm) Then
	Destroy ln_pivot_table_view_service
	Return 0
End If

If Not IsValid(Message.PowerObjectParm) Then
	Destroy ln_pivot_table_view_service
	Return 0
End If

If Not ClassName(Message.PowerObjectParm) = 'n_bag' Then
	Destroy ln_pivot_table_view_service
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the bag with the view information
//-----------------------------------------------------------------------------------------------------------------------------------
ln_bag = Message.PowerObjectParm

ls_description = String(ln_bag.of_get('Description'))
lb_globallyavailable = Upper(Trim(String(ln_bag.of_get('GlobalView')))) = 'Y'
lb_AllowNavigation = Upper(Trim(String(ln_bag.of_get('AllowNavigation')))) = 'Y'

If ln_bag.of_exists('DataObjectStateIdnty') Then
	ll_DataObjectStateIdnty = Long(ln_bag.of_Get('DataObjectStateIdnty'))
	If ll_DataObjectStateIdnty <= 0 Then
		SetNull(ll_DataObjectStateIdnty)
	End If
Else
	SetNull(ll_DataObjectStateIdnty)
End If
Destroy ln_bag

//-----------------------------------------------------------------------------------------------------------------------------------
// If the description isn't valid, return
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_description)) = 0 Or IsNull(ls_description) Then
	Destroy ln_pivot_table_view_service
	Return 0
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the description and modify the title
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.TitleType = 'O' Then
	in_pivot_table_properties.Description = ls_description
	idw_destination.Modify('report_title.Text = "' + ls_description + '"')
End If

If IsValid(iu_search) Then
	iu_search.Text = in_pivot_table_properties.Description
	iu_search.of_settitle(in_pivot_table_properties.Description)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Pass these variables on to the service
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = ln_pivot_table_view_service.of_new_view(il_reportconfigid, il_userid, ls_description, ls_xml_document, lb_globallyavailable, ll_DataObjectStateIdnty, lb_AllowNavigation)
Destroy ln_pivot_table_view_service

il_current_reportconfigpivottableid = ll_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the id of the new view
//-----------------------------------------------------------------------------------------------------------------------------------
Return ll_return


end function

private subroutine of_build_computed_field (string as_expression, string as_datawindow_band, long al_x_position, long al_y_position, long al_column_width, string as_column_format, long al_alignment);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_build_computed_field()
// Arguments:  as_expression - The name of the column to apply the gui column to
//					as_datawindow_band - The band of the datawindow
//					al_x_position - The x position in the band
//					al_y_position - the y position for the band
//					as_column_format - The format of the column ([general], etc.)
// Overview:    This will add a computed field to the datawindow syntax
// Created by:  Blake Doerr
// History:     12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Computed Fields
il_computed_field_count = il_computed_field_count + 1

This.of_build_computed_field(as_expression, as_datawindow_band, al_x_position, al_y_position, al_column_width, as_column_format, al_alignment, 'total_column' + String(il_computed_field_count))
end subroutine

private subroutine of_build_grouping (long al_level, string as_column_list, long al_grouping_header_height, long al_grouping_trailer_height, boolean ab_groupresetpagecount, boolean ab_groupnewpageongroupbreak);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_build_grouping()
// Arguments:   al_level - The grouping level
//					 as_column_list - the group by column list
//					 al_grouping_header_height - The group header height
//					 al_grouping_trailer_height - The group trailer height
// Overview:    This will build the syntax for a group by
// Created by:  Blake Doerr
// History:     12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If in_pivot_table_properties.ShowFirstGroupAsSeparateReport And al_level = 1 Then
	al_grouping_trailer_height = 0
End If

is_gui_groupings = is_gui_groupings + 'group(level=' + String(al_level) + ' header.height=' + String(al_grouping_header_height) + ' trailer.height=' + String(al_grouping_trailer_height) + ' by=("' + as_column_list +'" ) '

If ab_GroupResetPageCount Then
	is_gui_groupings = is_gui_groupings + 'resetpagecount=yes '
End If

If ab_GroupNewPageOnGroupBreak Then
	is_gui_groupings = is_gui_groupings + 'newpage=yes '
End If

is_gui_groupings = is_gui_groupings + 'header.color="536870912" trailer.color="536870912" )~r~n'

end subroutine

private subroutine of_build_computed_field (string as_expression, string as_datawindow_band, long al_x_position, long al_y_position, long al_column_width, string as_column_format, long al_alignment, string as_name);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_build_computed_field()
// Arguments:  as_expression - The name of the column to apply the gui column to
//					as_datawindow_band - The band of the datawindow
//					al_x_position - The x position in the band
//					al_y_position - the y position for the band
//					as_column_format - The format of the column ([general], etc.)
// Overview:    This will add a computed field to the datawindow syntax
// Created by:  Blake Doerr
// History:     12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions ln_string_functions

If in_pivot_table_properties.ShowFirstGroupAsSeparateReport And UpperBound(in_pivot_table_row[]) > 1 Then
	If as_datawindow_band = 'footer' Then
		as_expression = gn_globals.in_string_functions.of_replace_all(as_expression, 'for all)', 'for group 1)', True)
	End If
End If

//Computed Fields
is_gui_computed_fields = is_gui_computed_fields + 'compute(band=' + as_datawindow_band + ' alignment="' + String(al_alignment) + ' " expression="' + as_expression + &
'"  border="0" color="' + String(il_computed_field_color) + '" x="' + String(al_x_position) + '" 	y="' + String(al_y_position) + &
'" height="' + String(il_computed_field_height) + '" width="' + String(al_column_width) + '" format="' + as_column_format + &
'"  name=' + as_name + ' font.face="' + in_pivot_table_properties.FontName/*is_computed_field_fontface*/ + &
'" font.height="' + String(il_computed_field_fontsize) + '" font.weight="' + String(il_computed_field_fontweight) + &
'"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" pointer="' + is_computed_field_pointer + '")~r~n'
end subroutine

public function string of_insert_data_graph ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_insert_data_graph()
//	Overview:   Insert the data into the grid
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
// Local Variables
//---------------------------------------------------------------------------------
Long		ll_rowcount

//-------------------------------------------------------
// Put empty rows into the dummy datastore
//-------------------------------------------------------
ll_rowcount = ids_data_storage.RowCount()

//-------------------------------------------------------
// If there is no data Return
//-------------------------------------------------------
If ll_rowcount <= 0 Then 
	Return ''
End If

//-------------------------------------------------------
// Insert the number of rows that will be necessary
//-------------------------------------------------------
in_datawindow_tools.of_insert_rows(ids_dummy_datastore, ll_rowcount)

//-------------------------------------------------------
// Loop through all the rows and get the data into it's
//   proper structure
//-------------------------------------------------------
If UpperBound(in_pivot_table_row[]) > 0 Then
	Choose Case Lower(Trim(in_pivot_table_row[1].Datatype))
		Case 'string'
			ids_data_creation.object.column1.primary = lstr_rowstring[1].data
		Case 'datetime'
			ids_data_creation.object.column1.primary = lstr_rowdatetime[1].data			
		Case 'number'
			ids_data_creation.object.column1.primary = lstr_rownumber[1].data
	End Choose
End If

//-------------------------------------------------------
// Loop through all the columns and get the data into it's
//   proper structure
//-------------------------------------------------------
If UpperBound(in_pivot_table_column[]) > 0 Then
	Choose Case Lower(Trim(in_pivot_table_column[1].Datatype))
		Case 'string'
			ids_data_creation.object.column3.primary = lstr_columnstring[1].data
		Case 'datetime'
			ids_data_creation.object.column3.primary = lstr_columndatetime[1].data
		Case 'number'
			ids_data_creation.object.column3.primary = lstr_columnnumber[1].data			
	End Choose
End If

//-------------------------------------------------------
// Loop through all the aggregates and get the data into it's
//   proper structure
//-------------------------------------------------------
If UpperBound(in_pivot_table_aggregate[]) > 0 Then
	Choose Case Lower(Trim(in_pivot_table_aggregate[1].Datatype))
		Case 'string'
			ids_data_creation.object.column2.primary = lstr_aggregatestring[1].data
		Case 'datetime'
			ids_data_creation.object.column2.primary = lstr_aggregatedatetime[1].data
		Case 'number'
			ids_data_creation.object.column2.primary = lstr_aggregatenumber[1].data
	End Choose
End If

Return ''
end function

public function string of_set_datasource (ref powerobject apo_datasource);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_datasource()
//	Arguments:  apo_datasource - The datawindow/datastore/?
//	Overview:   This will add get a pointer to the source of the data
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
Boolean lb_object_is_subscribed = False
String	ls_error

Datawindow	ldw_datawindow
Datastore	lds_datastore

//----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't valud
//----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(apo_datasource) Then Return 'Error:  The data source is not valid'

//----------------------------------------------------------------------------------------------------------------------------------
// Store the datasource for later
//----------------------------------------------------------------------------------------------------------------------------------
io_datasource = apo_datasource

//----------------------------------------------------------------------------------------------------------------------------------
// Get the syntax into the data storage object so it can be interrogated
//----------------------------------------------------------------------------------------------------------------------------------
Choose Case io_datasource.TypeOf()
	Case Datawindow!
		ldw_datawindow							= io_datasource
		is_OriginalDatawindowObjectName = ldw_datawindow.DataObject
	Case Datastore!
		lds_datastore							= io_datasource
		is_OriginalDatawindowObjectName	= lds_datastore.DataObject
End Choose
 
ids_data_storage.Dynamic Create(io_datasource.Dynamic Describe("Datawindow.Syntax"), ls_error)

If Len(ls_error) > 0 Then Return 'Error:  Could not share report with pivot table (' + ls_error + ')'
	

//----------------------------------------------------------------------------------------------------------------------------------
// Subscribe to the appropriate messages
//----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	For ll_index = 1 To UpperBound(io_subscribed_dataobjects[])
		If io_subscribed_dataobjects[ll_index] = io_datasource Then
			lb_object_is_subscribed = True
			Exit
		End If
	Next
	
	If Not lb_object_is_subscribed Then
		io_subscribed_dataobjects[UpperBound(io_subscribed_dataobjects[]) + 1] = io_datasource
		gn_globals.in_subscription_service.of_subscribe(This, 'UOM Conversion', 	apo_datasource)	//Published by the dwservicemananger right click
		gn_globals.in_subscription_service.of_subscribe(This, 'retrieveend', 		apo_datasource)	//Published by the dwservicemananger right click
		gn_globals.in_subscription_service.of_subscribe(This, 'Apply Autopivot', 	apo_datasource)	//Published by the dwservicemananger right click				
	End If
End If

Return ''
end function

public function string of_determine_column (long xpos);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_determine_column()
//	Arguments:  xpos - the x position in the pivot table
//	Overview:   This will determine what column we are on in the pivot table
//	Created by:	Blake Doerr
//	History: 	4/4/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_column_count, ll_index, ll_width, ll_x_position, ll_max_x = 0
String ls_x_position, ls_width

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_destination) Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the number of columns
//-----------------------------------------------------------------------------------------------------------------------------------
ll_column_count = Long(idw_destination.Describe("Datawindow.Column.Count"))


//-----------------------------------------------------------------------------------------------------------------------------------
// Loop until we find the column with the correct coordinates
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_column_count
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the x and width for the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_x_position 	= idw_destination.Describe("#" + String(ll_index) + ".X")
	ls_width			= idw_destination.Describe("#" + String(ll_index) + ".Width")
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Return if we didn't get valid values back
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ls_x_position = '!' Or ls_x_position = '?' Or ls_width = '!' Or ls_width = '?' Or Not IsNumber(ls_x_position) Or Not IsNumber(ls_width) Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the long values
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_x_position 	= Long(ls_x_position)
	ll_width			= Long(ls_width)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Store the max, because we may determine that we are in the grand total column
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_max_x			= Max(ll_max_x, ll_width + ll_x_position)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we have found a winner return the column name
	//-----------------------------------------------------------------------------------------------------------------------------------
	If xpos >= ll_x_position And xpos <= ll_x_position + ll_width Then
		Return idw_destination.Describe("#" + String(ll_index) + ".Name")
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If the max is less than the xpos return that we are in the grand total column
//-----------------------------------------------------------------------------------------------------------------------------------
//If ll_max_x < xpos Then Return 'grand total'

//-----------------------------------------------------------------------------------------------------------------------------------
// Return empty string if we didn't find anything
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function string of_export_public ();n_pivot_table_view_service	ln_pivot_table_view_service

String					ls_description
String					ls_pathname
String					ls_xml_document
String					ls_return
Blob						lblob_xml_document


ls_description = idw_destination.Describe("report_title.Text")

If ls_description = '?' or ls_description = '!' Then ls_description = 'Exported Report View'

gn_globals.in_string_functions.of_replace_all(ls_description, '/', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '\', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, ':', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '*', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '|', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '>', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '<', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '?', '-')
gn_globals.in_string_functions.of_replace_all(ls_description, '$', '-')

ls_pathname 			= ls_pathname + Trim(ls_description) + '.PivotView.RAIV'

ln_pivot_table_view_service = Create n_pivot_table_view_service
ls_xml_document = ln_pivot_table_view_service.of_get_xml(in_pivot_table_row[], in_pivot_table_column[], in_pivot_table_aggregate[], in_pivot_table_properties)
Destroy ln_pivot_table_view_service
		
lblob_xml_document = Blob(ls_xml_document)

Return ''
end function

public subroutine of_get_current_state (ref n_pivot_table_element an_pivot_table_row[], ref n_pivot_table_element an_pivot_table_column[], ref n_pivot_table_element an_pivot_table_aggregate[], ref n_pivot_table_element an_pivot_table_properties);an_pivot_table_row[]				= in_pivot_table_row[]
an_pivot_table_column[]			= in_pivot_table_column[]
an_pivot_table_aggregate[]		= in_pivot_table_aggregate[]
an_pivot_table_properties		= in_pivot_table_properties
end subroutine

public function powerobject of_get_datasource ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_datasource()
//	Overview:   This will return the stored data for use
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(io_datasource) Then
	Return io_datasource
Else
	Return ids_data_storage
End If
end function

public subroutine of_present_gui ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_present_gui()
//	Overview:   This will show the window so the pivot table can be customized
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Window lw_reference_window
PowerObject lo_object

w_pivot_table_wizard lw_pivot_table_wizard

If IsValid(idw_destination) Then
	lo_object = idw_destination
	Do While lo_object.TypeOf() <> Window!
		lo_object = lo_object.GetParent()
	Loop
	
	lw_reference_window = lo_object
ElseIf IsValid(io_datasource) Then
	lo_object = io_datasource
	Do While lo_object.TypeOf() <> Window!
		lo_object = lo_object.GetParent()
	Loop
	
	lw_reference_window = lo_object
End If

If Not IsValid(lw_reference_window) Then lw_reference_window = w_mdi_frame

OpenWithParm(lw_pivot_table_wizard, This, lw_reference_window)
end subroutine

private subroutine of_build_statictext (string as_name, string as_text, string as_band, long al_x_position, long al_y_position, long al_height, long al_width, long al_alignment, long al_fontsize, long al_fontweight);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_build_statictext()
// Arguments:   as_name - The name of the static text
//					 as_text - The text to show
//					 as_band - The band the statictext goes in
//					 al_x_position - The x position of the statictext
//					 al_y_position - The y position of the statictext
//					 al_height - The height of the statictext
//					 al_width - The width of the statictext
//					 al_alignment - The alignment of the statictext
//					 al_fontsize - The font size
//					 al_fontweight - The font weight
// Overview:    This will create the syntax for a static text control
// Created by:  Blake Doerr
// History:     12/23/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_gui_statictext  = is_gui_statictext  + 'text(band=' + as_band + ' alignment="' + String(al_alignment) + &
						'" text="' + as_text + '" border="0" color="' + String(il_statictext_color) + &
						'" x="' + String(al_x_position) + '" y="' + String(al_y_position) + &
						'" height="' + String(al_height) + '" width="' + String(al_width) + &
						'"  name=' + as_name + ' pointer="' + is_column_pointer + '" font.face="' + &
						/*is_statictext_fontface*/ in_pivot_table_properties.FontName  + '" font.height="' + String(al_fontsize) + &
						'" font.weight="' + String(al_fontweight) + '" font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )~r~n'


end subroutine

public function string of_build_gui_datawindow_modifies ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_gui_datawindow_modifies()
//	Overview:   This will build the GUI for the datawindow
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
DatawindowChild ldwc_source
DatawindowChild ldwc_destination

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_index
Long	ll_position
Long	ll_position2
String	ls_columnname
String	ls_values
String	ls_original_columnname
String	ls_syntax
String	ls_return
String	ls_result3
String	ls_columnsizinginit_objects

//----------------------------------------------------------------------------------------------------------------------------------
// Modify the header height if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If il_additional_header_height > 0 Then
	ids_grid_creation.Modify('Datawindow.Header.Height = ~'' + String(il_header_height + il_additional_header_height) + '~'')
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Modify the detail height if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If il_additional_detail_height > 0 Then
	ids_grid_creation.Modify('Datawindow.Detail.Height = ~'' + String(il_detailheight + il_additional_detail_height) + '~'')
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Modify the footer height if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If il_additional_footer_height > 0 Then
	ids_grid_creation.Modify('Datawindow.Footer.Height = ~'' + String(il_footerheight + il_additional_footer_height) + '~'')
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Modify the header.# height if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If Not in_pivot_table_properties.ShowRowTotals Then
	For ll_index = 1 To il_number_of_groups
		ids_grid_creation.Modify('Datawindow.Trailer.' + String(ll_index) + '.Height = ~'0~'')
	Next
ElseIf il_grouping_additional_trailer_height > 0 Then
	If in_pivot_table_properties.ShowFirstGroupAsSeparateReport Then
		ids_grid_creation.Modify('Datawindow.Trailer.1.Height = ~'0~'')
	Else
		ids_grid_creation.Modify('Datawindow.Trailer.1.Height = ~'' + String(il_grouping_trailer_height + il_grouping_additional_trailer_height) + '~'')
	End If

	For ll_index = 2 To il_number_of_groups
		ids_grid_creation.Modify('Datawindow.Trailer.' + String(ll_index) + '.Height = ~'' + String(il_grouping_trailer_height + il_grouping_additional_trailer_height) + '~'')
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the rows and create columns
//    Apply all the attributes from the original datawindow to these columns (dropdowns, editmask, etc.)
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row[])
	ls_columnname = 'row' + String(ll_index)

	Choose Case in_pivot_table_row[ll_index].EditStyle
		Case 'dddw'
			//----------------------------------------------------------------------------------------------------------------------------------
			// Modify all the properties of the dropdowndatawindow column to match the original datawinodw
			//-----------------------------------------------------------------------------------------------------------------------------------
			ids_grid_creation.Modify(ls_columnname + '.dddw.name=' 				+ ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".dddw.name"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.displaycolumn=' 	+ ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".dddw.displaycolumn"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.datacolumn=' 		+ ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".dddw.datacolumn"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.percentwidth=' 	+ ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".dddw.percentwidth"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.lines=' 				+ ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".dddw.lines"))

			ids_data_storage.GetChild(in_pivot_table_row[ll_index].Column, ldwc_source)
			ids_grid_creation.GetChild(ls_columnname, ldwc_destination)
			ldwc_source.RowsCopy(1, ldwc_source.RowCount(), Primary!, ldwc_destination, 1, Primary!)
		Case 'editmask'
			ids_grid_creation.Modify(ls_columnname + '.EditMask.Mask=~'' + ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".EditMask.Mask") + '~'')			
		Case 'ddlb', 'checkbox'
			//Build the table column
			//		We are working with a dropdowndatawindow, so make an exact replica of the column were are interrogating
			
			if in_pivot_table_row[ll_index].EditStyle = 'ddlb' Then
				//The Values Property has all the items of the drop down defined.  Add all as a selection.
				ls_values = ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".Values")
			Else
				String ls_result, ls_result2

				//-------------------------------------------------------------------
				// For some reason these describes don't work that's why we have to do the code below
				//-------------------------------------------------------------------
				//ls_result = Describe(is_column_name[ll_index] + ".CheckBox.Off") 
				//ls_result2 = Describe(is_column_name[ll_index] + ".CheckBox.On")

				//-------------------------------------------------------------------
				// Determine the states of the checkbox
				//-------------------------------------------------------------------
				ls_original_columnname = Lower(Trim(ids_data_storage.Describe('#' + String(in_pivot_table_row[ll_index].ColumnID) + ".Name")))
				
				//-------------------------------------------------------------------
				// Determine the on state
				//-------------------------------------------------------------------
				ls_syntax = ids_data_storage.Describe("Datawindow.Syntax")				
				ll_position = Pos(ls_syntax, 'column(name=' + ls_original_columnname)
				ll_position = Pos(ls_syntax, 'checkbox.on=', ll_position)
				ll_position = ll_position + 13
				ll_position2 = Pos(ls_syntax, '" ', ll_position)
				ls_result = Mid(ls_syntax, ll_position, ll_position2 - ll_position)

				//-------------------------------------------------------------------
				// Determine the off state
				//-------------------------------------------------------------------
				ll_position = Pos(ls_syntax, 'column(name=' + ls_original_columnname)
				ll_position = Pos(ls_syntax, 'checkbox.off=', ll_position)
				ll_position = ll_position + 14
				ll_position2 = Pos(ls_syntax, '" ', ll_position)
				ls_result2 = Mid(ls_syntax, ll_position, ll_position2 - ll_position)

				//-------------------------------------------------------------------
				// Create the string for the DrowDownListBox
				//-------------------------------------------------------------------
				ls_values = 'Yes' +   '~t' + ls_result +         '/No~t' + ls_result2
	
				//-------------------------------------------------------------------
				// If there is a Third state
				//-------------------------------------------------------------------
				ll_position = Pos(ls_syntax, 'column(name=' + ls_original_columnname)
				ll_position = Pos(ls_syntax, 'checkbox.other=', ll_position)
				If ll_position > 0 Then
					ll_position = ll_position + 16
					ll_position2 = Pos(ls_syntax, '" ', ll_position)
					ls_result3 = Mid(ls_syntax, ll_position, ll_position2 - ll_position)
					
					ls_values = ls_values + '/Maybe~t' + ls_result3
				End If
				
			End If
			
			ids_grid_creation.Modify(ls_columnname + '.values="' + ls_values + '"')	
			ids_grid_creation.Modify(ls_columnname + '.ddlb.required=yes')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.limit=0')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.allowedit=no')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.case=any')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.vscrollbar=yes')
//			ids_grid_creation.Modify(ls_columnname + '.ddlb.useasborder=yes ')
	End Choose
	
	ids_grid_creation.Modify(ls_columnname + '.alignment=' + String(il_row_alignment))	
Next

For ll_index = 1 To UpperBound(is_special_expression_objects[])
	ls_columnsizinginit_objects = ls_columnsizinginit_objects + is_special_expression_objects[ll_index] + ','
	
	ls_return = ids_grid_creation.Modify(is_special_expression_objects[ll_index] + ".Tag='" + is_special_expression[ll_index] + "'")
Next

in_datawindow_tools.of_set_expression(ids_grid_creation, 'expressioninit', 'expressionobjects=' + ls_columnsizinginit_objects)
in_datawindow_tools.of_apply_expressions(ids_grid_creation)

Return ''
end function

public function string of_sort_columns ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_sort_columns()
//	Overview:   This will determine the sort order of the column headers
//	Created by:	Blake Doerr
//	History: 	6/27/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Datastore lds_datastore
Long		ll_index
Long		ll_column
Long		ll_row

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore = Create Datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the dataobject that contains a string column for sorting
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore.DataObject = 'd_pivottable_column_sorting'

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the sets of columns and sort each column list
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(istr_columndata[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add every column to the datastore
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_column = 1 To UpperBound(istr_columndata[ll_index].display[])
		ll_row = lds_datastore.InsertRow(0)
	Next

	For ll_column = 1 To lds_datastore.RowCount()
		lds_datastore.SetItem(ll_column, 'StringData', istr_columndata[ll_index].display[ll_column])
		lds_datastore.SetItem(ll_column, 'RowID', ll_column)
	Next

	lds_datastore.SetSort('StringData A')
	
	If UpperBound(in_pivot_table_column[]) > 0 Then
		If IsValid(in_pivot_table_column[1]) Then
			If Upper(Trim(in_pivot_table_column[1].SortDirection)) = 'D' Then
				lds_datastore.SetSort('StringData D')
			End If
		End If
	End If
				
	lds_datastore.Sort()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add every column to the datastore
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_column = 1 To Min(UpperBound(istr_columndata[ll_index].display[]), lds_datastore.RowCount())
		
		istr_columndata[ll_index].order[lds_datastore.GetItemNumber(ll_column, 'RowID')] = ll_column
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Clear the datastore for the next set
	//-----------------------------------------------------------------------------------------------------------------------------------
	lds_datastore.Reset()
	lds_datastore.SetSort('')
	lds_datastore.Sort()
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_datastore

Return ''
end function

public subroutine of_reset ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reset()
//	Overview:   Reset all the values in the state variables
//	Created by:	Blake Doerr
//	History: 	12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Varibles - All empty
//-----------------------------------------------------------------------------------------------------------------------------------
str_columndata lstr_columndata_dummy[]
Long		ll_index
Long ll_dummy
String ls_dummy
n_pivot_table_element ln_pivot_table_element[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty out the variables
//-----------------------------------------------------------------------------------------------------------------------------------
il_bitmap_count						= ll_dummy
il_computed_field_count				= ll_dummy
il_number_of_columns					= ll_dummy
is_gui_bitmaps							= ls_dummy
is_gui_columns							= ls_dummy
is_gui_computed_fields				= ls_dummy
is_gui_groupings						= ls_dummy
is_gui_lines							= ls_dummy
is_gui_statictext						= ls_dummy
istr_columndata[] 					= lstr_columndata_dummy[]
is_gui_suppressrepeatingvalues	= ''
il_number_of_groups					= 0

is_DestroyStringForComputedFieldsWhenAutoPivot	= ''

For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If IsValid(in_pivot_table_row[ll_index]) Then Destroy in_pivot_table_row[ll_index]
Next

For ll_index = 1 To UpperBound(in_pivot_table_column[])
	If IsValid(in_pivot_table_column[ll_index]) Then Destroy in_pivot_table_column[ll_index]
Next

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If IsValid(in_pivot_table_aggregate[ll_index]) Then Destroy in_pivot_table_aggregate[ll_index]
Next

If IsValid(in_pivot_table_properties) Then Destroy in_pivot_table_properties

If Not ib_we_are_applying_a_view Then
	il_current_reportconfigpivottableid = 0
End If

in_pivot_table_row[] 		= ln_pivot_table_element[]
in_pivot_table_column[] 	= ln_pivot_table_element[]
in_pivot_table_aggregate[] = ln_pivot_table_element[]
in_pivot_table_properties	= Create n_pivot_table_element
in_pivot_table_properties.ElementType = 'Properties'
end subroutine

public function string of_get_coltype (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_coltype()
//	Overview:   This will get the column type for a column in a datawindow
//	Created by:	Blake Doerr
//	History: 	12.22.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------
// Local Variables
//-------------------------------------------------------
Datastore lds_datastore
String	ls_datatype

ls_datatype = lower(left(ids_data_storage.Describe(as_columnname + '.ColType'),4))
//-------------------------------------------------------
// Determine the column type for the 
//-------------------------------------------------------
Choose Case lower(left(ids_data_storage.Describe(as_columnname + '.ColType'),4))
	Case 'numb','deci','long', 'inte'
		Return 'number'
	Case 'date'
		Return 'datetime'
	Case 'char'
		Return 'string'
End Choose

Return ''
end function

public function string of_validate ();Long	ll_index

If UpperBound(in_pivot_table_row[]) <= 0 Then
	Return 'Error:  The pivot table must have at least one "Selected Row", the report may have changed to invalidate the row that you selected'
End If

For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If in_pivot_table_row[ll_index].DataType = '?' Or in_pivot_table_row[ll_index].Datatype = '!' Or in_pivot_table_row[ll_index].Datatype = '' Then
		Return 'Error:  ' + in_pivot_table_row[ll_index].Description + ' is not a valid expression, please correct the expression'
	End If
Next

For ll_index = 1 To UpperBound(in_pivot_table_column[])
	If in_pivot_table_column[ll_index].DataType = '?' Or in_pivot_table_column[ll_index].Datatype = '!' Or in_pivot_table_column[ll_index].Datatype = '' Then
		Return 'Error:  ' + in_pivot_table_column[ll_index].Description + ' is not a valid expression, please correct the expression'
	End If
Next

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If in_pivot_table_aggregate[ll_index].DataType = '?' Or in_pivot_table_aggregate[ll_index].Datatype = '!' Or in_pivot_table_aggregate[ll_index].Datatype = '' Then
		Return 'Error:  ' + in_pivot_table_aggregate[ll_index].Description + ' is not a valid expression, please correct the expression'
	End If
Next

Return ''
end function

public function string of_import_public ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_update()
// Overview:    Save the syntax and the sort to the database
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------
// Local Variables
//------------------------------------------------------------------------------------
String	ls_viewname
String	ls_xml_document
String	ls_return

//------------------------------------------------------------------------------------
// Local Objects
//------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
//w_import_file_from_ftp	lw_import_file_from_ftp
n_bag ln_bag
Any	lany_file
Blob	lblob_file

ln_bag = Create n_bag
ln_bag.of_set('path', 'Pivot Views/' + is_OriginalDatawindowObjectName)
ln_bag.of_set('bitmap', 'Module - Reporting Desktop - Pivot Table View (Global).bmp')
ln_bag.of_set('window title', 'Download Public Pivot View')
ln_bag.of_set('window description', 'Select a public view to import.  You will need to save the view after downloading it.')
ln_bag.of_set('button text', 'Import')

//------------------------------------------------------------------------------------
// Open the window to name the view
//------------------------------------------------------------------------------------
//OpenWithParm(w_import_file_from_ftp, ln_bag)

//------------------------------------------------------------------------------------
// Get the message and see if it's valid
//------------------------------------------------------------------------------------
If Len(Trim((Message.StringParm))) > 0 Then
	Destroy ln_bag
	Return Message.StringParm
End If
If Not IsValid(ln_bag) Then Return 'Error:  Nothing came back'

ls_viewname = String(ln_bag.of_get('File Name'))
If ln_bag.of_exists('File Blob') Then
	lany_file	= ln_bag.of_get('File Blob')
	lblob_file	= lany_file
	ls_xml_document	= String(lblob_file)
Else
	Return 'Error:  Nothing came back'
End If

ls_return = This.of_apply_view(ls_xml_document)

If ls_return <> '' Then
	If Not ib_batchmode Then
		gn_globals.in_messagebox.of_messagebox_validation(ls_return)
		This.Post of_present_gui()
	End If
End If

Destroy ln_bag

Return ''

end function

private subroutine of_build_bitmap (string as_bitmapname, string as_band, long al_x_position, long al_y_position, long al_width, long al_height);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_build_bitmap()
// Arguments:  as_bitmapname - The filename of the bitmap
//					as_band - The band of the datawindow
//					al_x_position - The x position in the band
//					al_y_position - the y position for the band
//					al_height - The height of the bitmap (in Pixels)
//					al_width - The width of the bitmap (in Pixels)
// Overview:    DocumentScriptFunctionality
// Created by:  Blake Doerr
// History:     12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


il_bitmap_count = il_bitmap_count + 1
al_height = PixelsToUnits(al_height, YPixelsToUnits!)
al_width = PixelsToUnits(al_width, XPixelsToUnits!)

is_gui_bitmaps = is_gui_bitmaps + 'bitmap(band=' + as_band + ' filename="' + as_bitmapname + &
						'" x="' + String(al_x_position) + '" y="' + String(al_y_position) + &
						'" height="' + String(al_height) + '" width="' + String(al_width) + '" border="0"  name=report_bitmap' + String(il_bitmap_count) + ')'


end subroutine

public function long of_filter (long xpos, long ypos, long row, dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_filter()
//	Arguments:  row
//					xpos
//					ypos
//					dwo
//	Overview:   This will filter the data based on the region clicked on
//	Created by:	Blake Doerr
//	History: 	4/4/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_object = '', ls_band = '', ls_bandatpointer, ls_navigation_string = '', ls_columnname = '', ls_filterstring, ls_return
Long ll_grouplevel = 0, ll_index, ll_selected_rows[], ll_column_number, ll_object_position, ll_upperbound

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the object and band at pointer
//-----------------------------------------------------------------------------------------------------------------------------------
//ls_objectatpointer 	= idw_destination.GetObjectAtPointer()
ls_bandatpointer		= idw_destination.GetBandAtPointer()

//w_mdi_frame.Title = idw_destination.GetObjectAtPointer() + '               ' + idw_destination.GetBandAtPointer()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the row off the objectatpointer string if not valid yet
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(row) or row <= 0 Then
	row = Long(Mid(idw_destination.GetObjectAtPointer(), Pos(idw_destination.GetObjectAtPointer(), '~t') + 1, 10000))
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the row off the bandatpointer value if it isn't valid yet
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(row) or row <= 0 Then
	row = Long(Mid(ls_bandatpointer, Pos(ls_bandatpointer, '~t') + 1, 10000))
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the object name off the dwobject if it is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(dwo) Then
	ls_object = dwo.Name
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If we don't have a valid row, return
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(row) or row <= 0 Then ls_object = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the band of the datawindow.  Determine the grouping level if there is one
//-----------------------------------------------------------------------------------------------------------------------------------
ls_band	= Left(ls_bandatpointer, Pos(ls_bandatpointer, '~t') - 1)

If Lower(Trim(ls_band)) = 'header' Then Return -1

If Pos(ls_band, '.') > 0 Then
	ll_grouplevel = Long(Mid(ls_band, Pos(ls_band, '.') + 1, 10000))
	ls_band = 'group ' + Left(ls_band, Pos(ls_band, '.') - 1)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get object at pointer and determine the x in the middle of the object
//-----------------------------------------------------------------------------------------------------------------------------------
//ls_objectatpointer = Left(ls_objectatpointer, Pos(ls_objectatpointer, '~t') - 1)
ll_object_position = Long(idw_destination.Describe(ls_object + '.X'))
ll_object_position = ll_object_position + Long(idw_destination.Describe(ls_object + '.Width')) / 2

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are on a column, get the number out of the column, If we are on a computed field, evaluate the quantity for the computed field
//-----------------------------------------------------------------------------------------------------------------------------------
If in_datawindow_tools.of_IsColumn(idw_destination, ls_object) Then
	ls_columnname = ls_object
	idble_selected_quantity = Double(in_datawindow_tools.of_getitem(idw_destination, row, ls_object))
ElseIf in_datawindow_tools.of_IsComputedField(idw_destination, ls_object) Then
	idble_selected_quantity = Double(idw_destination.Describe("Evaluate('" + ls_object + "', " + String(row) + ")"))
	ls_columnname = Lower(Trim(This.of_determine_column(ll_object_position)))
ElseIf in_datawindow_tools.of_IsStaticText(idw_destination, ls_object) Then
	If ls_object = 'grand_total_label' or ls_object = 'row_total_column' Then
	ElseIf Right(Trim(ls_object), 4) = '_srt' Then
		ls_columnname = Lower(Trim(This.of_determine_column(ll_object_position)))
	Else
		ls_object = ''
	End If
Else
	ls_object = ''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If the object isn't valid, show zero rows and return
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_object)) <= 0 Then Return This.of_filter('1 = 2')

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the filter string for the row that we are on.  This will handle the group level also.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Left(ls_band, 5))
	Case 'group', 'trail', 'detai'
		If ll_grouplevel = 0 Then
			ll_upperbound = UpperBound(in_pivot_table_row[])
		Else
			ll_upperbound = ll_grouplevel
		End If
		
		For ll_index = 1 To ll_upperbound
			Choose Case Left(Trim(lower(idw_destination.Describe('row' + String(ll_index) + ".ColType"))), 4)
				Case 'numb', 'long', 'deci'
					ls_return = String(in_datawindow_tools.of_getitem(idw_destination, row, 'row' + String(ll_index)))
					If ls_return = '' Or IsNull(ls_return) Then					
						ls_filterstring = ls_filterstring + ' IsNull(' + in_pivot_table_row[ll_index].Column + ')'
					Else
						ls_filterstring = ls_filterstring + ' ' + in_pivot_table_row[ll_index].Column + ' = ' + ls_return
					End If
				Case 'date'
					ls_return = String(in_datawindow_tools.of_getitem(idw_destination, row, 'row' + String(ll_index)))
	
					If ls_return = '' Or IsNull(ls_return) Then
						ls_filterstring = ls_filterstring + ' IsNull(' + in_pivot_table_row[ll_index].Column + ')'
					Else
						ls_filterstring = ls_filterstring + ' ' + in_pivot_table_row[ll_index].Column + ' = DateTime("' + ls_return + '")'
					End If
				Case Else
					ls_return = String(in_datawindow_tools.of_getitem(idw_destination, row, 'row' + String(ll_index)))
					If IsNull(ls_return) Then
						ls_filterstring = ls_filterstring + ' IsNull(' + in_pivot_table_row[ll_index].Column + ')'
					Else
						ls_filterstring = ls_filterstring + ' (' + in_pivot_table_row[ll_index].Column + ' = "' + ls_return + '" Or IsNull(' + in_pivot_table_row[ll_index].Column + '))'
					End If
			End Choose
			
			ls_filterstring = ls_filterstring + ' And '
		Next
	Case Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// There should not be a row involved
		//-----------------------------------------------------------------------------------------------------------------------------------
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the filter string for the column that we are on
//-----------------------------------------------------------------------------------------------------------------------------------
//ls_columnname = istr_columndata[10]
Choose Case Lower(Left(ls_columnname, 3))
	Case 'row', 'agg'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// There should not be a column involved in this case
		//-----------------------------------------------------------------------------------------------------------------------------------
		
	Case Else
		If UpperBound(in_pivot_table_column[]) > 0 Then
			//-----------------------------------------------------------------------------------------------------------------------------------
			// There column will be something like column2_1 and we want the two from the string
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_columnname = Right(ls_columnname, Len(ls_columnname) - Len('column'))
			If Pos(ls_columnname, '_') > 0 Then
				ls_columnname = Left(ls_columnname, Pos(ls_columnname, '_') - 1)
			End If
			ll_column_number = Long(ls_columnname)

			/*
			For ll_index = 1 To UpperBound(is_grid_columnname[])
				If Lower(Trim(is_grid_columnname[ll_index])) = Lower(Trim(ls_columnname)) Then
					ll_column_number = ll_index - UpperBound(il_row[])
					Exit
				End If
			Next
			*/

			If ll_column_number > 0 And Not IsNull(ll_column_number) Then
				For ll_index = 1 To UpperBound(istr_columndata[1].order[])
					If istr_columndata[1].order[ll_index] = ll_column_number Then
						ll_column_number = ll_index
						Exit
					End If
				Next
				
				//ll_column_number = ?
				
				Choose Case Lower(Trim(in_pivot_table_column[1].Datatype))
					Case 'string'
						ls_return = istr_columndata[1].stringdata[ll_column_number]
						If IsNull(ls_return) Then
							ls_filterstring = ls_filterstring + 'IsNull(' + in_pivot_table_column[1].Column + ')'
						Else
							ls_filterstring = ls_filterstring + in_pivot_table_column[1].Column + ' = ' + '"' + ls_return + '"'							
						End If
					Case 'number'
						ls_return = String(istr_columndata[1].numberdata[ll_column_number])
						If IsNull(ls_return) Or Trim(ls_return) = '' Then
							ls_filterstring = ls_filterstring + 'IsNull(' + in_pivot_table_column[1].Column + ')'
						Else
							ls_filterstring = ls_filterstring + in_pivot_table_column[1].Column + ' = ' + ls_return
						End If
					Case 'datetime'
						ls_return = gn_globals.in_string_functions.of_convert_datetime_to_string(istr_columndata[1].datetimedata[ll_column_number])
						If IsNull(ls_return) Or Trim(ls_return) = '' Then
							ls_filterstring = ls_filterstring + 'IsNull(' + in_pivot_table_column[1].Column + ')'
						Else
							ls_filterstring = ls_filterstring + in_pivot_table_column[1].Column + ' = ' + 'DateTime("' + ls_return + '")'
							/*
							ls_return = gn_globals.in_string_functions.of_convert_date_to_string(Date(istr_columndata[1].datetimedata[ll_column_number]))
							ls_filterstring = ls_filterstring + 'DateTime(Date("' + ls_return + '"), '
							ls_return = String(Time(istr_columndata[1].datetimedata[ll_column_number]))
							ls_filterstring = ls_filterstring + 'Time("' + ls_return + '"))'
							*/
						End If
				End Choose
				
				ls_filterstring = ls_filterstring + ' And '
			End If
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut off the last "and"
//-----------------------------------------------------------------------------------------------------------------------------------
ls_filterstring = Left(ls_filterstring, Len(ls_filterstring) - 4)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the filter
//-----------------------------------------------------------------------------------------------------------------------------------
Return This.of_filter(ls_filterstring)
end function

public subroutine of_rbuttondown (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_rbuttondown()
//	Arguments:  row
//					xpos
//					ypos
//					dwo
//	Overview:   This will hopefully present a navigation menu
//	Created by:	Blake Doerr
//	History: 	4/4/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_selected_rows[], ll_return, ll_quantity, ll_uom
String	ls_column
String	ls_original_filter
Datawindow	lu_datawindow
n_bag			ln_bag
powerobject ln_uomconversionobject
NonVisualObject ln_service
n_datawindow_tools	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there is not destination yet
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_destination) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the search isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(iu_search) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the search does not contain a datacollection column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
If Not ln_datawindow_tools.of_iscomputedfield(ids_data_storage, 'datacollectioninit') Then Return
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the navigation options object
//-----------------------------------------------------------------------------------------------------------------------------------
ln_service = idw_destination.Dynamic of_get_service_manager().of_get_service('n_navigation_options')

//-----------------------------------------------------------------------------------------------------------------------------------
// If it isn't valid, create it and intialize it
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_service) Then
	idw_destination.Dynamic of_get_service_manager().of_add_service('n_navigation_options')
	ln_service = idw_destination.Dynamic of_get_service_manager().of_get_service('n_navigation_options')
	
	If Not IsValid(ln_service) Then Return
	
	ln_service.Dynamic of_init(SQLCA, ids_data_storage, is_entity)
	ln_service.Dynamic of_set_menutarget(idw_destination)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the filter on the storage object, return if the filter wasn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = This.of_filter(xpos, ypos, row, dwo)
If IsNull(ll_return) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the uom from the conversion object		
//-----------------------------------------------------------------------------------------------------------------------------------
lu_datawindow = This.of_get_report_object().Dynamic of_get_report_dw()
ln_uomconversionobject = lu_datawindow.Dynamic of_get_service_manager().of_get_component('u_dynamic_conversion_strip')

If IsValid(ln_uomconversionobject) Then
	ll_uom = Long(ln_uomconversionobject.Dynamic of_getitem("uomid"))
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the bag; add the datastore, the quantity, and information about the entity
//-----------------------------------------------------------------------------------------------------------------------------------
ln_bag	= Create n_bag
ll_quantity = 1000
ln_bag.of_set('dataset', ids_data_storage)
ln_bag.of_set('report', iu_search)
ln_bag.of_set('quantity', idble_selected_quantity)
ln_bag.of_set('uom', ll_uom)// Store the quantity they clicked on in an instance variable /****/
ln_bag.of_set('row', row)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set selected rows and show the menu
//-----------------------------------------------------------------------------------------------------------------------------------
ln_service.Dynamic of_setselecteddata(ln_bag)
end subroutine

public function long of_get_current_view_id ();Return il_current_reportconfigpivottableid
end function

public subroutine of_set_report_object (u_search au_search);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_report_object()
//	Arguments:  au_search - the search object
//	Overview:   This will set the report object origin
//	Created by:	Blake Doerr
//	History: 	6/1/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// return if the search isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(au_search) Then Return
If Not IsValid(au_search.of_get_report_dw()) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Store a pointer to the search
//-----------------------------------------------------------------------------------------------------------------------------------
iu_search = au_search
il_reportconfigid = iu_search.Properties.RprtCnfgID

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the entity from the navigation options object
//-----------------------------------------------------------------------------------------------------------------------------------
is_entity = iu_search.Properties.EntityName

end subroutine

public function long of_filter (string as_filterstring);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_filter()
//	Arguments:  row
//					xpos
//					ypos
//					dwo
//	Overview:   This will filter the data based on the region clicked on
//	Created by:	Blake Doerr
//	History: 	4/4/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ids_data_storage.SetFilter(as_filterstring)
ids_data_storage.Filter()
is_filter_string = as_filterstring

ib_ReportHasBeenFiltered = ib_autopivoting

Return ids_data_storage.RowCount()
end function

public function string of_open_pivottable_report ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_pivottable_report()
//	Overview:   This will open the pivot table report.
//	Created by:	Blake Doerr
//	History: 	9/5/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the current search as the original search
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_reportconfigid, ll_null
String	ls_display_object

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
u_search 			lu_empty_search
n_report_manager	ln_report_manager
NonVisualObject	ln_pivot_table_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the current search as the original search
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
iu_original_search 	= iu_search
iu_search 				= lu_empty_search

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the report manager
//-----------------------------------------------------------------------------------------------------------------------------------
ln_report_manager = Create n_report_manager

ll_reportconfigid = ln_report_manager.of_get_reportconfig_id('PivotTableViewer')

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are autopivoting, we will open the search ourselves and set it on the search.  Otherwise, tell the report manager to open it.
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_autopivoting And IsValid(iu_original_search) Then
	ls_display_object = ln_report_manager.of_get_display_object(ll_reportconfigid, 'R')
	iu_search = iu_original_search.of_openuserobject(ls_display_object, 10000, 0)
	If ib_batchmode Then
		iu_search.of_set_option('IsBatchMode', 'Y')
	End If
	ln_report_manager.of_init(iu_search, ll_reportconfigid, 'R')
	iu_search.of_set_adapter(iu_original_search.of_get_adapter())
	iu_original_search.of_set_overlaying_report(iu_search, 'layered')
	iu_original_search.TriggerEvent('resize')
Else
	iu_search = ln_report_manager.of_create_report(iu_original_search.of_get_adapter(), ll_reportconfigid, False)
	If ib_batchmode Then
		iu_search.of_set_option('IsBatchMode', 'Y')
	End If
	ln_report_manager.of_init(iu_search, ll_reportconfigid, 'R')
	
	If IsValid(iu_search.of_get_adapter()) Then
		iu_search.of_get_adapter().TriggerEvent('resize')
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the report manager if we are the ones that created it
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_report_manager

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the search is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(iu_search) Then Return 'Error:  Could not open report object for the pivot table'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get a pointer to the datawindow and the graphic service manager
//-----------------------------------------------------------------------------------------------------------------------------------
ln_pivot_table_service = This
idw_destination = iu_search.of_get_report_dw()
iu_search.of_get_report_dw().Dynamic of_get_service_manager().of_add_service(ln_pivot_table_service)

Return ''
end function

public subroutine of_doubleclicked (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_doubleclicked()
//	Arguments:  row
//					xpos
//					ypos
//					dwo
//	Overview:   This will hopefully show the details of the pivot table
//	Created by:	Blake Doerr
//	History: 	4/4/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_original_filter

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we are in graph mode
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.IsGraph Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the location of the mouse pointer is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Left(idw_destination.GetBandAtPointer(), 6) = 'header' and Left(idw_destination.GetBandAtPointer(), 7) <> 'header.' Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the filter on the storage object, return if the filter wasn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(This.of_filter(xpos, ypos, row, dwo)) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Show the detail report
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_show_detail(row)

//-----------------------------------------------------------------------------------------------------------------------------------
// Filter the datastore back
//-----------------------------------------------------------------------------------------------------------------------------------
ids_data_storage.SetFilter('')
ids_data_storage.Filter()
end subroutine

protected function string of_get_column_display_value (n_pivot_table_element an_pivot_table_element, long al_index);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_column_display_value()
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	5/2/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Handle Checkboxes differently
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(an_pivot_table_element.EditStyle))
	Case 'checkbox'
		Choose Case an_pivot_table_element.Datatype
			Case 'string'
				ls_return = String(lstr_columnstring[1].data[al_index])
			Case 'datetime'
				ls_return = String(lstr_columndatetime[1].data[al_index])
			Case 'number'
				ls_return = String(lstr_columnnumber[1].data[al_index])
		End Choose
		
		Choose Case Lower(Trim(ls_return))
			Case Lower(Trim(ids_data_storage.Describe(an_pivot_table_element.Column + '.CheckBox.Off')))
				ls_return = 'No'
			Case Lower(Trim(ids_data_storage.Describe(an_pivot_table_element.Column + '.CheckBox.On')))
				ls_return = 'Yes'
			Case Lower(Trim(ids_data_storage.Describe(an_pivot_table_element.Column + '.CheckBox.Other')))
				ls_return = 'Maybe'
		End Choose
		
		Return ls_return
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Handle Certain Dates Differently
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(an_pivot_table_element.Datatype)) = 'datetime' Then
	If Date(lstr_columndatetime[1].data[al_index]) = 2050-12-31 Then Return 'Forward'
	If Date(lstr_columndatetime[1].data[al_index]) = 1950-01-01 Then Return 'Start of Time'
	If Date(lstr_columndatetime[1].data[al_index]) = 1900-01-01 Then Return 'No Date'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Do a lookupdisplay if the haven't specified the format and it's not an expression
//-----------------------------------------------------------------------------------------------------------------------------------
If Not an_pivot_table_element.IsExpression And Not (Upper(Trim(an_pivot_table_element.FormatType)) = 'C' And Lower(Trim(an_pivot_table_element.Format)) <> '[general]' And Trim(an_pivot_table_element.Format) <> '') Then
	If Not in_datawindow_tools.of_IsComputedField(ids_data_storage, an_pivot_table_element.Column) Then
		Return ids_data_storage.Describe("Evaluate('LookupDisplay(" + an_pivot_table_element.Column + ")', " + String(al_index) + ")")
	Else
		Return ids_data_storage.Describe("Evaluate('" + an_pivot_table_element.Column + "', " + String(al_index) + ")")
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the data from the array, applying a format if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case an_pivot_table_element.Datatype
	Case 'string'
		If an_pivot_table_element.FormatType = 'C' And Lower(Trim(an_pivot_table_element.Format)) <> '[general]' And Trim(an_pivot_table_element.Format) <> '' Then
			Return String(lstr_columnstring[1].data[al_index], an_pivot_table_element.Format)
		Else
			Return String(lstr_columnstring[1].data[al_index])
		End If
	Case 'datetime'
		If an_pivot_table_element.FormatType = 'C' And Lower(Trim(an_pivot_table_element.Format)) <> '[general]' And Trim(an_pivot_table_element.Format) <> '' Then
			Return String(lstr_columndatetime[1].data[al_index], an_pivot_table_element.Format)
		Else
			Return String(lstr_columndatetime[1].data[al_index])
		End If
	Case 'number'
		If an_pivot_table_element.FormatType = 'C' And Lower(Trim(an_pivot_table_element.Format)) <> '[general]' And Trim(an_pivot_table_element.Format) <> '' Then
			Return String(lstr_columnnumber[1].data[al_index], an_pivot_table_element.Format)
		Else
			Return String(lstr_columnnumber[1].data[al_index])
		End If
End Choose


Return 'No Data'
end function

public function string of_create_grid_dataobject_graph ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_create_grid_dataobject_graph()
//	Overview:   Create the grid dataobject
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
// Local Variables
//---------------------------------------------------------------------------------
String ls_error

//----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore for use in creating the virtual column list
//-----------------------------------------------------------------------------------------------------------------------------------
is_complete_syntax = 'release 7;~r~ndatawindow(units=0 timer_interval=0 color=' + String(il_datawindow_backcolor) + ' processing=3 HTMLDW=no print.documentname="" print.orientation = 1 print.margin.left = 110 print.margin.right = 110 print.margin.top = 96 print.margin.bottom = 96 print.paper.source = 0 print.paper.size = 0 print.prompt=no print.buttons=no print.preview.buttons=no )~r~n' + &
							'summary(height=0 color="536870912")~r~n' + &
							'footer(height=0 color="536870912" )~r~n' + &
							'detail(height=0 color="536870912" )~r~n' + &
							'table(~r~n'

If UpperBound(in_pivot_table_row[]) > 0 Then
	Choose Case in_pivot_table_row[1].Datatype
		Case 'string', 'lookupdisplay'
			is_complete_syntax = is_complete_syntax + 	' column=(type=char(4099) updatewhereclause=no name=column1 dbname="column1" ) ~r~n'
		Case 'datetime'
			is_complete_syntax = is_complete_syntax + 	' column=(type=datetime updatewhereclause=no name=column1 dbname="column1" ) ~r~n'
		Case 'number'
			is_complete_syntax = is_complete_syntax + 	' column=(type=number updatewhereclause=no name=column1 dbname="column1" ) ~r~n'
	End Choose
End If

If UpperBound(in_pivot_table_aggregate[]) > 0 Then
	Choose Case in_pivot_table_aggregate[1].Datatype
		Case 'string', 'lookupdisplay'
			is_complete_syntax = is_complete_syntax + 	' column=(type=char(4099) updatewhereclause=no name=column2 dbname="column2" ) ~r~n'
		Case 'datetime'
			is_complete_syntax = is_complete_syntax + 	' column=(type=datetime updatewhereclause=no name=column2 dbname="column2" ) ~r~n'
		Case 'number'
			is_complete_syntax = is_complete_syntax + 	' column=(type=number updatewhereclause=no name=column2 dbname="column2" ) ~r~n'
	End Choose
End If

If UpperBound(in_pivot_table_column[]) > 0 Then
	Choose Case in_pivot_table_column[1].Datatype
		Case 'string', 'lookupdisplay'
			is_complete_syntax = is_complete_syntax + 	' column=(type=char(4099) updatewhereclause=no name=column3 dbname="column3" ) ~r~n'
		Case 'datetime'
			is_complete_syntax = is_complete_syntax + 	' column=(type=datetime updatewhereclause=no name=column3 dbname="column3" ) ~r~n'
		Case 'number'
			is_complete_syntax = is_complete_syntax + 	' column=(type=number updatewhereclause=no name=column3 dbname="column3" ) ~r~n'
	End Choose
End If
is_complete_syntax = is_complete_syntax + ')'

ids_data_creation.Create(is_complete_syntax, ls_error)

If Len(ls_error) > 0 Then
	Return 'Error:  Could not create pivot data object (' + ls_error + ')'
End If

Return ''
end function

public function string of_build_gui_datawindow_graph ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_gui_datawindow_graph()
//	Overview:   This will build the GUI for the datawindow
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_index2, ll_index3, ll_ending_x_position_of_last_object = 50, ll_left_margin = 50, ll_spacing, ll_position, ll_position2, ll_maximum_offset = 0, ll_starting_position, ll_translated_column_number, ll_order
Long ll_temporary_color, ll_temporary_weight, ll_rowwidth, ll_aggregatewidth, ll_originalcolumnnumber
String ls_columnname, ls_datawindow_syntax, ls_error_create, ls_editstyle, ls_values, ls_syntax, ls_original_columnname, ls_result3, ls_total_computed_field[], ls_band, ls_row_header = '', ls_computed_field_expression, ls_legendvalue
String ls_aggregateformat, ls_headertext, ls_aggregatewidth
String ls_row_total_header = 'Total for Row'
String	ls_category_title = 'Category'
String	ls_values_title	= 'Values'
String	ls_series_title	= 'Series'
String	ls_originalcolumname
String	ls_legendexpression
Boolean lb_create_column
DatawindowChild ldwc_source, ldwc_destination

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset object counts
//-----------------------------------------------------------------------------------------------------------------------------------
il_line_count_header	= 0
il_line_count_detail	= 0
il_line_count_footer	= 0
il_bitmap_count			= 0
il_computed_field_count	= 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the report title and footer
//-----------------------------------------------------------------------------------------------------------------------------------
If Not in_pivot_table_properties.TitleIsOverridden Then This.of_build_report_title_graph()
This.of_build_statictext('report_title', in_pivot_table_properties.Description, 'foreground', 150, 27, 50, 3000, 3, -8, 700)

This.of_build_bitmap('Module - Reporting Desktop - Pivot Chart.bmp', 'foreground', 50, 25, 16, 16)

This.of_build_column('column1', 'detail', 0, 0, 0, in_pivot_table_row[1].Format)
This.of_build_column('column2', 'detail', 0, 0, 0, in_pivot_table_aggregate[1].Format)

If UpperBound(in_pivot_table_column[]) > 0 Then
	This.of_build_column('column3', 'detail', 0, 0, 0, '[general]')
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Create the complete syntax
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.GraphType = 0 Then in_pivot_table_properties.GraphType = 8
ls_datawindow_syntax = is_complete_syntax + '~r~n' + is_gui_columns + is_gui_bitmaps + is_gui_statictext +  'graph(band=background height="2588" width="5193" graphtype="' + String(in_pivot_table_properties.GraphType) + '" perspective="2" rotation="-20" color="80269524" backcolor="' + String(il_datawindow_backcolor) + '" shadecolor="8355711" range= 0 border="3" overlappercent="0" spacing="100" elevation="20" depth="100" x="0" y="0" height="2588" width="5193" name=gr_1  sizetodisplay=1~r~n'

If UpperBound(in_pivot_table_row[]) > 0 Then
	ls_datawindow_syntax = ls_datawindow_syntax + 'category="column1"~r~n'
	ls_category_title = in_pivot_table_row[1].Description
	ls_legendexpression = 'lookupdisplay(category)'
End If

If UpperBound(in_pivot_table_aggregate[]) > 0 Then
	Choose Case Lower(Trim(in_pivot_table_aggregate[1].AggregateFunction))
		Case 'none', '(none)', ''
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="column2"~r~n'
		Case 'count distinct'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="count(distinct column2 for graph)"~r~n'
		Case 'round0'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 0)"~r~n'
		Case 'round0'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 0)"~r~n'
		Case 'round1'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 1)"~r~n'
		Case 'round2'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 2)"~r~n'
		Case 'round3'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 3)"~r~n'
		Case 'round4'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 4)"~r~n'
		Case 'round5'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 5)"~r~n'
		Case 'round6'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="round(column2, 6)"~r~n'
		Case 'daysafter'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="daysafter(today(), column2)"~r~n'
		Case 'secondsafter'
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="24 * 3600 * daysafter(today(), column2) + secondsafter(Time(today()), Time(column2))"~r~n'
		Case Else
			ls_datawindow_syntax = ls_datawindow_syntax + 'values="' + in_pivot_table_aggregate[1].AggregateFunction + '(column2 for graph)"~r~n'
	End Choose
	ls_values_title	= in_pivot_table_aggregate[1].Description
End If

If UpperBound(in_pivot_table_column[]) > 0 Then
	ls_datawindow_syntax = ls_datawindow_syntax + 'series="column3"~r~n'
	ls_series_title	= in_pivot_table_column[1].Description
	ls_legendexpression = 'lookupdisplay(series)'
End If

If in_pivot_table_properties.IsLegend = true Then
	ls_legendvalue	= 	'legend="1"'
Else
	ls_legendvalue	=	'legend="0"'
End If

ls_datawindow_syntax = ls_datawindow_syntax + 'title=""~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'title.dispattr.backcolor="553648127"  title.dispattr.alignment="2"  title.dispattr.autosize="0"  title.dispattr.font.charset="0"  title.dispattr.font.escapement="0"  title.dispattr.font.face="Tahoma"  title.dispattr.font.family="2"  title.dispattr.font.height="-10"  title.dispattr.font.italic="0"  title.dispattr.font.orientation="0"  title.dispattr.font.pitch="2"  title.dispattr.font.strikethrough="0"  title.dispattr.font.underline="0"  title.dispattr.font.weight="700"  title.dispattr.format="[general]"~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'title.dispattr.textcolor="' + String(il_statictext_color) + '"~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'title.dispattr.displayexpression="~~~"~~~""  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + ls_legendvalue + ' legend.dispattr.backcolor="553648127"  legend.dispattr.alignment="0"  legend.dispattr.autosize="0"  legend.dispattr.font.charset="0"  legend.dispattr.font.escapement="0"  legend.dispattr.font.face="Tahoma"  legend.dispattr.font.family="2"  legend.dispattr.font.height="-6"  legend.dispattr.font.italic="0"  legend.dispattr.font.orientation="0"  legend.dispattr.font.pitch="2"  legend.dispattr.font.strikethrough="0"  legend.dispattr.font.underline="0"  legend.dispattr.font.weight="400"  legend.dispattr.format="[general]"  legend.dispattr.textcolor="0"  legend.dispattr.displayexpression="' + ls_legendexpression + '" ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.autoscale="1"~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.displayeverynlabels="0"  series.droplines="0"  series.frame="1"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.label="' + ls_series_title + '"  series.majordivisions="0"  series.majorgridline="0"  series.majortic="3"  series.maximumvalue="0"  series.minimumvalue="0"  series.minordivisions="0"  series.minorgridline="0"  series.minortic="1"  series.originline="1"  series.primaryline="1"  series.roundto="0"  series.roundtounit="0"  series.scaletype="1"  series.scalevalue="1"  series.secondaryline="0"  series.shadebackedge="0"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.dispattr.backcolor="553648127"  series.dispattr.alignment="0"  series.dispattr.autosize="0"  series.dispattr.font.charset="0"  series.dispattr.font.escapement="0"  series.dispattr.font.face="Tahoma"  series.dispattr.font.family="2"  series.dispattr.font.height="-8"  series.dispattr.font.italic="0"  series.dispattr.font.orientation="0"  series.dispattr.font.pitch="2"  series.dispattr.font.strikethrough="0"  series.dispattr.font.underline="0"  series.dispattr.font.weight="400"  series.dispattr.format="[general]"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.dispattr.textcolor="0"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.dispattr.displayexpression="series"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.labeldispattr.backcolor="553648127"  series.labeldispattr.alignment="2"  series.labeldispattr.autosize="0"  series.labeldispattr.font.charset="0"  series.labeldispattr.font.escapement="0" series.labeldispattr.font.face="Tahoma"  series.labeldispattr.font.family="2"  series.labeldispattr.font.height="-8"  series.labeldispattr.font.italic="0"  series.labeldispattr.font.orientation="0"  series.labeldispattr.font.pitch="2"  series.labeldispattr.font.strikethrough="0"  series.labeldispattr.font.underline="0"  series.labeldispattr.font.weight="1000"  series.labeldispattr.format="[general]"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.labeldispattr.textcolor="0"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'series.labeldispattr.displayexpression="seriesaxislabel"  series.sort="1" category.autoscale="1" category.displayeverynlabels="0"  category.droplines="1"  category.frame="1"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'category.label="' + ls_category_title + '"  category.majordivisions="0"  category.majorgridline="0"  category.majortic="3"  category.maximumvalue="0"  category.minimumvalue="0"  category.minordivisions="0"  category.minorgridline="0"  category.minortic="1"  category.originline="1"  category.primaryline="1"  category.roundto="0"  category.roundtounit="0"  category.scaletype="1"  category.scalevalue="1"  category.secondaryline="0"  category.shadebackedge="1"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'category.dispattr.backcolor="553648127"  category.dispattr.alignment="2"  category.dispattr.autosize="0"  category.dispattr.font.charset="0"  category.dispattr.font.escapement="450"  category.dispattr.font.face="Tahoma"  category.dispattr.font.family="2"  category.dispattr.font.height="-8"  category.dispattr.font.italic="0"  category.dispattr.font.orientation="450"  category.dispattr.font.pitch="2"  category.dispattr.font.strikethrough="0"  category.dispattr.font.underline="0"  category.dispattr.font.weight="400"  category.dispattr.format="[General]"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'category.dispattr.textcolor="0"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'category.dispattr.displayexpression="category"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'category.labeldispattr.backcolor="553648127"  category.labeldispattr.alignment="2"  category.labeldispattr.autosize="0"  category.labeldispattr.font.charset="0"  category.labeldispattr.font.escapement="0"  category.labeldispattr.font.face="Tahoma"  category.labeldispattr.font.family="2"  category.labeldispattr.font.height="-8"  category.labeldispattr.font.italic="0"  category.labeldispattr.font.orientation="0"  category.labeldispattr.font.pitch="2"  category.labeldispattr.font.strikethrough="0"  category.labeldispattr.font.underline="0"  category.labeldispattr.font.weight="700"  category.labeldispattr.format="[general]"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'category.labeldispattr.textcolor="8388608"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'category.labeldispattr.displayexpression="categoryaxislabel"  category.sort="1" ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.autoscale="1" ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.displayeverynlabels="0"  values.droplines="0"  values.frame="1"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.label="' + ls_values_title + '"  values.majordivisions="0"  values.majorgridline="0"  values.majortic="3"  values.maximumvalue="250"  values.minimumvalue="0"  values.minordivisions="0"  values.minorgridline="0"  values.minortic="1"  values.originline="1"  values.primaryline="1"  values.roundto="0"  values.roundtounit="0"  values.scaletype="1"  values.scalevalue="1"  values.secondaryline="0"  values.shadebackedge="0"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.dispattr.backcolor="553648127"  values.dispattr.alignment="1"  values.dispattr.autosize="0"  values.dispattr.font.charset="0"  values.dispattr.font.escapement="0"  values.dispattr.font.face="Tahoma"  values.dispattr.font.family="2"  values.dispattr.font.height="-8"  values.dispattr.font.italic="0"  values.dispattr.font.orientation="0"  values.dispattr.font.pitch="2"  values.dispattr.font.strikethrough="0"  values.dispattr.font.underline="0"  values.dispattr.font.weight="400"  values.dispattr.format="[General]"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.dispattr.textcolor="0"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.dispattr.displayexpression="value"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.labeldispattr.backcolor="553648127"  values.labeldispattr.alignment="2"  values.labeldispattr.autosize="0"  values.labeldispattr.font.charset="0"  values.labeldispattr.font.escapement="900"  values.labeldispattr.font.face="Tahoma"  values.labeldispattr.font.family="2"  values.labeldispattr.font.height="-8"  values.labeldispattr.font.italic="0"  values.labeldispattr.font.orientation="900"  values.labeldispattr.font.pitch="2"  values.labeldispattr.font.strikethrough="0"  values.labeldispattr.font.underline="0"  values.labeldispattr.font.weight="700"  values.labeldispattr.format="[general]"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.labeldispattr.textcolor="8388608"  ~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'values.labeldispattr.displayexpression="column2" )~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'htmltable(border="0" )~r~n'
ls_datawindow_syntax = ls_datawindow_syntax + 'htmlgen(clientevents="1" clientvalidation="1" clientcomputedfields="1" clientformatting="0" clientscriptable="0" generatejavascript="1" )~r~n'

//----------------------------------------------------------------------------------------------------------------------------------
// Create the gui datawindow and copy the data to there
//-----------------------------------------------------------------------------------------------------------------------------------
ids_grid_creation.Create(ls_datawindow_syntax, ls_error_create)

If Len(ls_error_create) > 0 Then
	Return 'Error:  Could not create pivot table graph datawindow (' + ls_error_create + ')'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the rows and create columns
//    Apply all the attributes from the original datawindow to these columns (dropdowns, editmask, etc.)
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To 3
	If ll_index = 3 And UpperBound(in_pivot_table_column[]) <= 0 Then Continue
	
	ls_columnname = 'column' + String(ll_index)
	Choose Case ll_index
		Case 1
			ll_originalcolumnnumber = in_pivot_table_row[1].ColumnID
			ls_originalcolumname		= in_pivot_table_row[1].Column
			ls_editstyle				= in_pivot_table_row[1].EditStyle
		Case 2
			ll_originalcolumnnumber = in_pivot_table_aggregate[1].ColumnID
			ls_originalcolumname		= in_pivot_table_aggregate[1].Column
			ls_editstyle				= in_pivot_table_aggregate[1].EditStyle
		Case 3
			ll_originalcolumnnumber = in_pivot_table_column[1].ColumnID
			ls_originalcolumname		= in_pivot_table_column[1].Column
			ls_editstyle				= in_pivot_table_column[1].EditStyle			
	End Choose

	Choose Case ls_editstyle
		Case 'dddw'
			//----------------------------------------------------------------------------------------------------------------------------------
			// Modify all the properties of the dropdowndatawindow column to match the original datawinodw
			//-----------------------------------------------------------------------------------------------------------------------------------
			ids_grid_creation.Modify(ls_columnname + '.dddw.name=' 				+ ids_data_storage.Describe('#' + String(ll_originalcolumnnumber) + ".dddw.name"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.displaycolumn=' 	+ ids_data_storage.Describe('#' + String(ll_originalcolumnnumber) + ".dddw.displaycolumn"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.datacolumn=' 		+ ids_data_storage.Describe('#' + String(ll_originalcolumnnumber) + ".dddw.datacolumn"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.percentwidth=' 	+ ids_data_storage.Describe('#' + String(ll_originalcolumnnumber) + ".dddw.percentwidth"))
			ids_grid_creation.Modify(ls_columnname + '.dddw.lines=' 				+ ids_data_storage.Describe('#' + String(ll_originalcolumnnumber) + ".dddw.lines"))
	
			ids_data_storage.GetChild(ls_originalcolumname, ldwc_source)
			ids_grid_creation.GetChild(ls_columnname, ldwc_destination)
			ldwc_source.RowsCopy(1, ldwc_source.RowCount(), Primary!, ldwc_destination, 1, Primary!)			
		Case 'editmask'
			ids_grid_creation.Modify(ls_columnname + '.EditMask.Mask=~'' + ids_data_storage.Describe('#' + String(ll_originalcolumnnumber) + ".EditMask.Mask") + '~'')			
		Case 'ddlb'
			//The Values Property has all the items of the drop down defined.  Add all as a selection.
			ls_values = ids_data_storage.Describe('#' + String(ll_originalcolumnnumber) + ".Values")
			
			ids_grid_creation.Modify(ls_columnname + '.values="' + ls_values + '"')	
			ids_grid_creation.Modify(ls_columnname + '.ddlb.required=yes')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.limit=0')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.allowedit=no')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.case=any')
			ids_grid_creation.Modify(ls_columnname + '.ddlb.vscrollbar=yes')
//			ids_grid_creation.Modify(ls_columnname + '.ddlb.useasborder=yes ')
	End Choose
Next


ids_data_creation.RowsCopy(1, ids_data_creation.RowCount(), Primary!, ids_grid_creation, 1, Primary!)
ids_data_creation.DataObject = ''

Return ''
end function

public subroutine of_add_expression (string as_object, string as_property, string as_expression);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_expression()
//	Overview:   This will add the row to the result set
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
// Local Objects
//---------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//---------------------------------------------------------------------------------
// Local Variables
//---------------------------------------------------------------------------------
String	ls_expression_name
String	ls_return
Long		ll_index

//---------------------------------------------------------------------------------
// Find the object to add the expression for
//---------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_special_expression_objects[])
	If is_special_expression_objects[ll_index] = as_object Then
		Exit
	End If
Next

//---------------------------------------------------------------------------------
// Add to the array if it's new
//---------------------------------------------------------------------------------
If ll_index > UpperBound(is_special_expression_objects[]) Then
	is_special_expression_objects[ll_index]	= as_object
	is_special_expression[ll_index]				= ''
End If

//---------------------------------------------------------------------------------
// Add the expression to the expression that's already there.
//---------------------------------------------------------------------------------
If Len(is_special_expression[ll_index]) > 0 Then
	is_special_expression[ll_index] = is_special_expression[ll_index] + '||' + as_property + "=" + as_expression
Else
	is_special_expression[ll_index] = as_property + "=" + as_expression
End If
end subroutine

public function string of_apply ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply()
//	Overview:   This will apply the parameters to create the pivot table
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_return
String 	ls_columnname
String	ls_sort = ''
String	ls_return
String	ls_sort_direction
//n_string_functions ln_string_functions
str_string_array 		lstr_string_empty[20]
str_datetime_array 	lstr_datetime_empty[20]
str_number_array 		lstr_number_empty[20]

//-----------------------------------------------------------------------------------------------------------------------------------
// Show the user we are doing stuff
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not gb_runningasaservice Then
//	Post SetPointer(SetPointer(HourGlass!))
//	w_mdi_frame.of_position_statusbar('Creating Pivot Table 0%',0)
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// This will get the data again if the number of rows has changed
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(io_datasource) Then
	If ids_data_storage.RowCount() <> io_datasource.Dynamic RowCount() Or ib_autopivoting Then
		//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Refreshing Stored Data 5%', 10)
		ls_return = This.of_copy_datasource()

		If ls_return <> '' Then
			//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('', 100)
			Return ls_return
		End If

		ls_return = This.of_refresh()

		If ls_return <> '' Then
			//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('', 100)
			Return ls_return
		End If
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Validate the pivot table
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Validating Pivot Table 10%',2)
ls_return = This.of_validate()

If ls_return <> '' Then
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('', 100)
	Return ls_return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the functions to build the pivot table in memory
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Processing Columns From Original Report 20%', 20)

//-----------------------------------------------------------------------------------------------------------------------------------
// Sort the pivot table elements to handle force single column aggregates
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_arrange_pivot_elements()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the data
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_get_data()

If ls_return <> '' Then
	//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
	Return ls_return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Take two different routes depending on whether or not we are graphing
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.IsGraph Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the data object that contains the result data
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Graph Dataset 25%', 25)
	ls_return = This.of_create_grid_dataobject_graph()
	
	If ls_return <> '' Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
		Return ls_return
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the data into the graph datastore
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Inserting Data Into Graph 30%', 30)
	ls_return = This.of_insert_data_graph()

	If ls_return <> '' Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
		Return ls_return
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Build the graph with the gui
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Graph GUI 85%', 85)
	ls_return = This.of_build_gui_datawindow_graph()
	
	If ls_return <> '' Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
		Return ls_return
	End If
Else
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the data object that contains the result data
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart Dataset 25%', 25)
	ls_return = This.of_create_grid_dataobject()
	
	If ls_return <> '' Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
		Return ls_return
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the data into the chart
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Inserting Data Into Chart 30%', 30)
	ls_return = This.of_insert_data()
	
	If ls_return <> '' Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
		Return ls_return
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Build the gui for the chart
	//-----------------------------------------------------------------------------------------------------------------------------------
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 85%', 85)
	ls_return = This.of_build_gui_datawindow()
	
	If ls_return <> '' Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
		Return ls_return
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Open a report if there isn't a valid destination
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_destination) Then
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Opening Pivot Table Report 90%', 15)
	ls_return = of_open_pivottable_report()

	If ls_return <> '' Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
		Return ls_return
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the title on the report
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_search) Then
	iu_search.Text = in_pivot_table_properties.Description
	iu_search.of_settitle(in_pivot_table_properties.Description)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the search object if possible
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_search) Then
	If IsValid(iu_search.of_get_adapter()) Then	iu_search.of_get_adapter().Dynamic of_select(iu_search)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If the destination datawindow isn't valid, return
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_destination) Then
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
	Return 'Error:  Could not open pivot table report'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the redraw false and build the datawindow from the syntax of the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
idw_destination.SetRedraw(False)
idw_destination.Create(ids_grid_creation.Describe("Datawindow.Syntax"), ls_return)

If Len(ls_return) <> 0 Then
//	If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)
	Return 'Error:  Could not create pivot table report (' + ls_return + ')'
End If	

//----------------------------------------------------------------------------------------------------------------------------------
// We need to get all the dropdowndatawindow data also
//----------------------------------------------------------------------------------------------------------------------------------
If Not in_pivot_table_properties.IsGraph Then
	For ll_index = 1 To UpperBound(in_pivot_table_row[])
		ls_sort_direction = Upper(Trim(in_pivot_table_row[ll_index].SortDirection))
		
		If Len(Trim(ls_sort_direction)) = 0 Then ls_sort_direction = 'A'
		
		Choose Case Lower(Trim(in_pivot_table_row[ll_index].EditStyle))
			Case 'dddw'
				ls_columnname = 'row' + String(ll_index)
				If Not in_datawindow_tools.of_share_dropdowndatawindow(ids_data_storage, in_pivot_table_row[ll_index].Column, idw_destination, ls_columnname) Then
					in_datawindow_tools.of_copy_dropdowndatawindow(ids_data_storage, in_pivot_table_row[ll_index].Column, idw_destination, ls_columnname)
				End If

				ls_sort = ls_sort + 'LookUpDisplay(row' + String(ll_index) + ') ' + ls_sort_direction + ','
			Case 'ddlb'
				ls_sort = ls_sort + 'LookUpDisplay(row' + String(ll_index) + ') ' + ls_sort_direction + ','
			Case Else
				ls_sort = ls_sort + 'row' + String(ll_index) + ' ' + ls_sort_direction + ','
		End Choose
	Next

	//----------------------------------------------------------------------------------------------------------------------------------
	// Cut off the extra information
	//----------------------------------------------------------------------------------------------------------------------------------
	ls_sort = Left(ls_sort, Len(ls_sort) - 1)
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Sort the datawindow, recalculate groups, and copy the rows into the datawindow
//----------------------------------------------------------------------------------------------------------------------------------
ids_grid_creation.RowsCopy(1, ids_grid_creation.RowCount(), Primary!, idw_destination, 1, Primary!)
ids_grid_creation.DataObject = ''

If Not in_pivot_table_properties.IsGraph Then
	If Not in_datawindow_tools.of_sort(idw_Destination, ls_sort) Then
		idw_destination.SetSort(ls_sort)
		idw_destination.Sort()
	End If
	
	gn_globals.in_string_functions.of_replace_all(ls_sort, "'", "%$#")
	in_datawindow_tools.of_set_expression(idw_destination, 'sortinit', ls_sort)
End If

idw_destination.GroupCalc()

//----------------------------------------------------------------------------------------------------------------------------------
// Modify the zoom percentage
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.ZoomPercentage <> 100 Then
	idw_destination.Modify('Datawindow.Zoom = ~'' + String(in_pivot_table_properties.ZoomPercentage) + '~'')
End If

idw_destination.SetRedraw(True)


//----------------------------------------------------------------------------------------------------------------------------------
// Set the current pivot table id to zero for some damn reason
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(il_current_reportconfigpivottableid) Then il_current_reportconfigpivottableid = 0

//----------------------------------------------------------------------------------------------------------------------------------
// Publish a message that says the columns were resized to see if anyone needs to respond
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(gn_globals.in_subscription_service) then
	If ib_we_are_applying_a_view Then
		gn_globals.in_subscription_service.of_message('Pivot Table Applied', 'RprtCnfgPvtTbleID=' + String(il_current_reportconfigpivottableid), idw_destination)
	End If
	
	gn_globals.in_subscription_service.of_message('After View Restored', 'ApplySort=N', idw_destination)
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Clear out all the data arrays to save memory
//-----------------------------------------------------------------------------------------------------------------------------------
lstr_rowstring[]						= lstr_string_empty[]
lstr_columnstring[]					= lstr_string_empty[]
lstr_aggregatestring[]				= lstr_string_empty[]
lstr_rowdatetime[]					= lstr_datetime_empty[]
lstr_columndatetime[]				= lstr_datetime_empty[]
lstr_aggregatedatetime[]			= lstr_datetime_empty[]
lstr_rownumber[]						= lstr_number_empty[]
lstr_columnnumber[]					= lstr_number_empty[]
lstr_aggregatenumber[]				= lstr_number_empty[]
lstr_aggregateweightednumber[]	= lstr_number_empty[]

ids_dummy_datastore.Reset()

//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Creating Chart GUI 100%', 100)

//----------------------------------------------------------------------------------------------------------------------------------
// Clear out the detail datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_search_detail) Then iu_search_detail.of_get_report_dw().Reset()

Return ''
end function

public function string of_apply_view (long al_reportconfigpivottableid);/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_view()
//	Arguments:  al_reportconfigpivottableid - the id of the view
//	Overview:   This will apply a view stored in the database
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_row[], ls_column[], ls_aggregate[], ls_aggregatefunction[], ls_title, ls_sum_aggregates
String	ls_return	= ''
String	ls_errormessage	= ''
Long 		ll_index
Long		ll_graphtype
Long		ll_reportviewid
Long		ll_current_viewid
Boolean lb_is_aggregate_pivoted[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions
n_pivot_table_element ln_pivot_table_properties
n_pivot_table_element ln_pivot_table_row[]
n_pivot_table_element ln_pivot_table_column[]
n_pivot_table_element ln_pivot_table_aggregate[]
n_pivot_table_view_service ln_pivot_table_view_service
NonVisualObject ln_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Show the user we are doing stuff
//-----------------------------------------------------------------------------------------------------------------------------------
SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the view information for the view id
//-----------------------------------------------------------------------------------------------------------------------------------
ln_pivot_table_view_service = Create n_pivot_table_view_service
ln_pivot_table_view_service.of_get_view(al_reportconfigpivottableid, ln_pivot_table_row[], ln_pivot_table_column[], ln_pivot_table_aggregate[], ln_pivot_table_properties, ll_reportviewid)
Destroy ln_pivot_table_view_service

If ll_reportviewid > 0 And Not IsNull(ll_reportviewid) Then
	If Not IsValid(io_datasource) Then
		ls_return = 'This pivot view requires a report view that cannot be applied because this pivot was opened as a new report.  Apply this pivot to the original report'
		Return ls_return
	End If

	Choose Case io_datasource.TypeOf()
		Case Datastore!
			ls_return = 'This pivot view requires a report view that cannot be applied because this pivot was opened as a new report.  Apply this pivot to the original report'
			Return ls_return
		Case Datawindow!
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Get the datawindow report view service
			//-----------------------------------------------------------------------------------------------------------------------------------
			ln_service = io_datasource.Dynamic of_get_service_manager().of_get_service('n_dao_dataobject_state')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If the service is valid, get the current view id
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsValid(ln_service) Then
				ll_current_viewid = Long(ln_service.Dynamic of_get_current_view_id())

				//-----------------------------------------------------------------------------------------------------------------------------------
				// If the current view is not equal to the required report view, apply the report view
				//-----------------------------------------------------------------------------------------------------------------------------------
				If ll_current_viewid <> ll_reportviewid Then
					gn_globals.in_subscription_service.of_message('Apply View ID', String(ll_reportviewid), io_datasource)
			
					//-----------------------------------------------------------------------------------------------------------------------------------
					// If the view was applied, reretrieve the report
					//-----------------------------------------------------------------------------------------------------------------------------------
					If Not IsValid(iu_original_search) Then
						If IsValid(iu_search) Then iu_search.dw_report.of_reretrieve()
					Else
						iu_original_search.dw_report.of_reretrieve()
					End If

					//-----------------------------------------------------------------------------------------------------------------------------------
					// Reapply the datasource
					//-----------------------------------------------------------------------------------------------------------------------------------
					This.of_set_datasource(io_datasource)
				End If
			End If
	End Choose
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset this pivot table
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_reset()

/**/ls_return = This.of_add_element(ln_pivot_table_properties)
If ls_return <> '' Then
	ls_errormessage = ls_return + '~r~n'
End If/**/

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the rows into this object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ln_pivot_table_row[])
	ls_return = This.of_add_element(ln_pivot_table_row[ll_index])
	If ls_return <> '' Then
		ls_errormessage = ls_return + '~r~n'
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the columns into this object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ln_pivot_table_column[])
	ls_return = This.of_add_element(ln_pivot_table_column[ll_index])
	If ls_return <> '' Then
		ls_errormessage = ls_return + '~r~n'
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the aggregates into this object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ln_pivot_table_aggregate[])
	ls_return = This.of_add_element(ln_pivot_table_aggregate[ll_index])
	If ls_return <> '' Then
		ls_errormessage = ls_return + '~r~n'
	End If
Next

If ls_errormessage <> '' Then
	If Not ib_batchmode Then
		This.Post of_present_gui()
	End If
	Return Left(ls_errormessage, Len(ls_errormessage) - 2)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the view id
//-----------------------------------------------------------------------------------------------------------------------------------
il_current_reportconfigpivottableid = al_reportconfigpivottableid

ib_we_are_applying_a_view = True
ls_return = This.of_apply()
ib_we_are_applying_a_view = False

Return ls_return
end function

public function string of_apply_view (string as_xml_document);/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_view()
//	Arguments:  al_reportconfigpivottableid - the id of the view
//	Overview:   This will apply a view stored in the database
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
String	ls_return	= ''
String	ls_errormessage	= ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_pivot_table_element ln_pivot_table_row[]
n_pivot_table_element ln_pivot_table_column[]
n_pivot_table_element ln_pivot_table_aggregate[]
n_pivot_table_element ln_pivot_table_properties/**/
n_pivot_table_view_service ln_pivot_table_view_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Show the user we are doing stuff
//-----------------------------------------------------------------------------------------------------------------------------------
SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset this pivot table
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_reset()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the view information for the view id
//-----------------------------------------------------------------------------------------------------------------------------------
ln_pivot_table_view_service = Create n_pivot_table_view_service

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the xml document onto this object
//-----------------------------------------------------------------------------------------------------------------------------------
If Pos(as_xml_document, '<Columns>') > 0 And Pos(as_xml_document, '</Columns>') > 0 Then
	ln_pivot_table_view_service.of_set_state_xml_old(as_xml_document)
Else
	ln_pivot_table_view_service.of_set_state_xml(as_xml_document)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the elements
//-----------------------------------------------------------------------------------------------------------------------------------
ln_pivot_table_view_service.of_get_elements(ln_pivot_table_row[], ln_pivot_table_column[], ln_pivot_table_aggregate[], ln_pivot_table_properties)
Destroy ln_pivot_table_view_service

/**/ls_return = This.of_add_element(ln_pivot_table_properties)
If ls_return <> '' Then
	ls_errormessage = ls_return + '~r~n'
End If/**/

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the rows into this object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ln_pivot_table_row[])
	ls_return = This.of_add_element(ln_pivot_table_row[ll_index])
	If ls_return <> '' Then
		ls_errormessage = ls_return + '~r~n'
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the columns into this object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ln_pivot_table_column[])
	ls_return = This.of_add_element(ln_pivot_table_column[ll_index])
	If ls_return <> '' Then
		ls_errormessage = ls_return + '~r~n'
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the aggregates into this object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ln_pivot_table_aggregate[])
	ls_return = This.of_add_element(ln_pivot_table_aggregate[ll_index])
	If ls_return <> '' Then
		ls_errormessage = ls_return + '~r~n'
	End If
Next

If ls_errormessage <> '' Then
	If Not ib_batchmode Then
		This.Post of_present_gui()
	End If
	Return Left(ls_errormessage, Len(ls_errormessage) - 2)
End If

ls_return = This.of_apply()

Return ls_return
end function

public function string of_build_gui_datawindow_column_totals_all (ref long al_ending_x_position_of_last_object, string as_total_computed_field_for_all[]);/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_gui_datawindow_column_totals_all()
//	Overview:   This will build the GUI for the datawindow
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//Boolean	lb_move_next_column = True
Long 		ll_index
Long 		ll_index2
Long		ll_temp
Long		ll_spacing
Long		ll_y_position
Long		ll_aggregate_header_alignment
Long		ll_aggregatewidth
String	ls_description
String 	ls_row_total_header	= 'Total'
String 	ls_aggregateformat = '[general]'
String	ls_total_expression
String	ls_total_expression_group
//n_string_functions ln_string_functions

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the width
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(il_column_widths[])
	ll_aggregatewidth = Max(ll_aggregatewidth, il_column_widths[ll_index])
Next

ll_aggregatewidth = Long(Double(ll_aggregatewidth) * 1.20)

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the alignment of the headers
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_we_have_stacked_headers Then
	ll_aggregate_header_alignment = 2
Else
	ll_aggregate_header_alignment		= il_alignment
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the spacing
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_we_have_stacked_headers And in_pivot_table_properties.ShowColumnTotals Then
	ll_spacing = il_aggregate_spacing
Else
	ll_spacing = il_column_spacing
End If
	
//----------------------------------------------------------------------------------------------------------------------------------
// Determine what the total header says
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(in_pivot_table_properties.ColumnAllAggregateFunction))
	Case 'difference'
		ls_row_total_header = 'Difference'
	Case 'average', 'avg'
		ls_row_total_header = 'Average'
	Case 'min'
		ls_row_total_header = 'Minimum'
	Case 'max'
		ls_row_total_header = 'Maximum'
	Case Else
		ls_row_total_header = 'Total'
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Build the header text
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_we_have_stacked_headers And Not in_pivot_table_properties.ShowColumnLabels Then ls_row_total_header = ''

This.of_build_statictext('total_column' + String(il_computed_field_count + 1) + '_srt', ls_row_total_header, 'header', al_ending_x_position_of_last_object + ll_spacing, il_header_height - 60 + il_additional_header_height, 52, ll_aggregatewidth, ll_aggregate_header_alignment, -8, 700)

For ll_index = 1 To UpperBound(as_total_computed_field_for_all[])
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the y position
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_y_position = (5 * ll_index) + ((ll_index - 1) * il_detailheight)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Try to find the best format to use in this situation
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_aggregateformat = '[general]'
	
	For ll_index2 = UpperBound(in_pivot_table_aggregate[]) To 1 Step -1
		If Lower(Trim(in_pivot_table_aggregate[ll_index2].Datatype)) <> 'number' Then Continue/**/
		If in_pivot_table_aggregate[ll_index2].PivotTableRowID <> ll_index Then Continue
		
		If Len(ls_aggregateformat) < Len(in_pivot_table_aggregate[ll_index2].Format) Then
			ls_aggregateformat 	= in_pivot_table_aggregate[ll_index2].Format
		End If
	Next
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Build the computed field
	//-----------------------------------------------------------------------------------------------------------------------------------
	This.of_build_computed_field(as_total_computed_field_for_all[ll_index], 'detail', 	al_ending_x_position_of_last_object  + ll_spacing, ll_y_position, ll_aggregatewidth, ls_aggregateformat, 1)
	is_rightmost_object = 'total_column' + String(il_computed_field_count)
		
	//----------------------------------------------------------------------------------------------------------------------------------
	// Store the computed field count, so we can create total columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_temp = il_computed_field_count
	
	If in_pivot_table_properties.ShowColumnTotals And UpperBound(in_pivot_table_column[]) > 0 And il_number_of_columns > 1 Then
		This.of_add_expression(is_grand_total_line, 'X2', 'Long(Describe("total_column' + String(ll_temp) + '.X")) + Long(Describe("total_column' + String(ll_temp) + '.Width"))')
		This.of_add_expression('aggregatetotal_srt_header', 'Width', 'Long(Describe("total_column' + String(ll_temp) + '.X")) + Long(Describe("total_column' + String(ll_temp) + '.Width")) - Long(Describe("aggregatetotal_srt_header.X"))')
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// If we are showing row totals, create computed fields in the footer and trailer bands
	//-----------------------------------------------------------------------------------------------------------------------------------
	If in_pivot_table_properties.ShowRowTotals Then
		Choose Case Lower(Trim(in_pivot_table_properties.ColumnAllAggregateFunction))
			Case 'average', 'avg'
				ls_total_expression = 'Avg(total_column' + String(ll_temp) + ' For All)'
			Case 'min', 'max'
				ls_total_expression = in_pivot_table_properties.ColumnAllAggregateFunction + '(total_column' + String(ll_temp) + ' For All)'
			Case Else
				ls_total_expression = 'Sum(total_column' + String(ll_temp) + ' For All)'
		End Choose
		
		This.of_build_computed_field(ls_total_expression, 'footer', al_ending_x_position_of_last_object + ll_spacing, ll_y_position, ll_aggregatewidth, ls_aggregateformat, 1)
	
		//----------------------------------------------------------------------------------------------------------------------------------
		// Create computed fields for the grouping row total
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index2 = 1 To il_number_of_groups
			If ll_index2 <> UpperBound(in_pivot_table_row[]) Then
				ls_total_expression_group = ls_total_expression
				gn_globals.in_string_functions.of_replace_all(ls_total_expression_group, 'For All', 'For Group ' + String(ll_index2))
				This.of_build_computed_field(ls_total_expression_group, 	'trailer.' + String(ll_index2), 	al_ending_x_position_of_last_object  + ll_spacing, ll_y_position - 5, ll_aggregatewidth, ls_aggregateformat, 1)
			End If
		Next
	End If
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Change the ending position of the last object
//-----------------------------------------------------------------------------------------------------------------------------------
al_ending_x_position_of_last_object = al_ending_x_position_of_last_object + ll_aggregatewidth + il_column_spacing

Return ''
end function

public function string of_build_gui_datawindow_row (ref long al_ending_x_position_of_last_object);/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_gui_datawindow_row()
//	Overview:   This will build the GUI for the datawindow
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_label_created[]
Boolean	lb_header_label_created = False
Long		ll_index
Long		ll_index2
Long		ll_first_column_width
Long		ll_computed_field_fontweight
Long		ll_numberofgroups 				= 0
Long		ll_numberofnongroupedcolumns	= 0
Long		ll_y_position_header[]
Long		ll_x_position[]
Long		ll_width[]
String	ls_first_column_header
String	ls_band

For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If ll_index > 1 Then
		If in_pivot_table_row[ll_index - 1].CreateGroup Then
			ll_first_column_width = Max(ll_first_column_width, in_pivot_table_row[ll_index].Width)
			ls_first_column_header = 'row' + String(ll_index) + '_srt'
		End If
	Else
		ls_first_column_header = 'row' + String(ll_index) + '_srt'
		ll_first_column_width = Max(ll_first_column_width, in_pivot_table_row[ll_index].Width)
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the parameters for all the row objects
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If in_pivot_table_row[ll_index].CreateGroup Then
		If ll_index <> UpperBound(in_pivot_table_row[]) Then
			ll_numberofgroups = ll_numberofgroups + 1
		Else
			ll_numberofnongroupedcolumns = ll_numberofnongroupedcolumns + 1
		End If
	Else
		If ll_index <> UpperBound(in_pivot_table_row[]) Then
			ll_numberofnongroupedcolumns = ll_numberofnongroupedcolumns + 1
			If in_pivot_table_row[ll_index].SuppressRepeatingValues Then
				If Len(is_gui_suppressrepeatingvalues) = 0 Then
					is_gui_suppressrepeatingvalues = 'sparse(names="row' + String(ll_index) + '")~r~n'
				Else
					is_gui_suppressrepeatingvalues = Left(is_gui_suppressrepeatingvalues, Len(is_gui_suppressrepeatingvalues) - 4)
					is_gui_suppressrepeatingvalues = is_gui_suppressrepeatingvalues + '~trow' + String(ll_index) + '")~r~n'
				End If
			End If
		End If
	End If
	
	If Not in_pivot_table_row[ll_index].CreateGroup Or ll_index = UpperBound(in_pivot_table_row[]) Then
		ll_y_position_header[ll_index] = il_header_height - 60 + il_additional_header_height
	Else
		ll_y_position_header[ll_index] = 500
	End If
	
	If ll_numberofnongroupedcolumns <= 1 Then
		ll_x_position[ll_index] 	= ((ll_index - 1) * il_row_indention) + al_ending_x_position_of_last_object
		ll_width[ll_index]			= ll_first_column_width - ((ll_index - 1) * il_row_indention)
	Else
		ll_x_position[ll_index] 	= ll_x_position[ll_index - 1] + ll_width[ll_index - 1] + il_column_spacing
		ll_width[ll_index] = in_pivot_table_row[ll_index].Width
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the rows and create columns
//    Apply all the attributes from the original datawindow to these columns (dropdowns, editmask, etc.)
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Treat a grouping and a detail separately
	//-----------------------------------------------------------------------------------------------------------------------------------
	If UpperBound(in_pivot_table_row[]) = ll_index Or Not in_pivot_table_row[ll_index].CreateGroup Then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Create the column in the detail band
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_band = 'detail'
		il_column_fontweight = 400
	Else
		il_number_of_groups = il_number_of_groups + 1
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Create the column in a group band
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_band = 'header.' + String(ll_index)

		This.of_build_grouping(ll_index, 'row' + String(ll_index), il_grouping_header_height, il_grouping_trailer_height, in_pivot_table_row[ll_index].GroupResetPageCount, in_pivot_table_row[ll_index].GroupNewPageOnGroupBreak)

		If in_pivot_table_properties.ShowRowTotals Then
			This.of_build_computed_field("'Total for ' + LookupDisplay(" + 'row' + String(ll_index) + ")", 'trailer.' + String(ll_index), ll_x_position[ll_index] + 50, 0, ll_x_position[UpperBound(in_pivot_table_row[])] + ll_width[UpperBound(in_pivot_table_row[])] - ll_x_position[ll_index] - 50, '[general]', 0, 'row' + String(ll_index) + '_grouptotal')
			This.of_add_expression('row' + String(ll_index) + '_grouptotal', 'Width', 'Long(Describe("row' + String(UpperBound(in_pivot_table_row[])) + '.X")) + Long(Describe("row' + String(UpperBound(in_pivot_table_row[])) + '.Width")) - Long(Describe("row' + String(ll_index) + '_grouptotal' + '.X"))')
		End If

		il_column_fontweight = 700
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	This.of_build_column('row' + String(ll_index), ls_band, ll_x_position[ll_index], 0, ll_width[ll_index], in_pivot_table_row[ll_index].Format)
	
	If ll_y_position_header[ll_index] = 500 Then
		This.of_add_expression('row' + String(ll_index), 'Width', 'Long(Describe("' + ls_first_column_header + '.X")) + Long(Describe("' + ls_first_column_header + '.Width")) - Long(Describe("' + 'row' + String(ll_index) + '.X"))')
	End If
	
	If ls_band = 'detail' Then ls_band = 'header'
	
	This.of_build_statictext('row' + String(ll_index) + '_srt', in_pivot_table_row[ll_index].Description, ls_band, ll_x_position[ll_index], ll_y_position_header[ll_index], 52, ll_width[ll_index], 0, -8, 700)

	If ll_y_position_header[ll_index] = 500 Then
		This.of_add_expression('row' + String(ll_index) + '_srt', 'Width', 'Long(Describe("' + ls_first_column_header + '.X")) + Long(Describe("' + ls_first_column_header + '.Width")) - Long(Describe("row' + String(ll_index) + '_srt.X"))')
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the header label
//-----------------------------------------------------------------------------------------------------------------------------------
//If UpperBound(in_pivot_table_row[]) > 0 Then
//	This.of_build_computed_field("'" + in_pivot_table_row[UpperBound(in_pivot_table_row[])].Description + "'", 'header', il_left_margin, il_header_height - 60 + il_additional_header_height, ll_rowwidth, '[general]', 0, 'row1_srt')
//End If

//----------------------------------------------------------------------------------------------------------------------------------
// Create the grand total static text
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.ShowRowTotals Then
	//This.of_build_statictext('grand_total_label', 'Total for All', 'footer', ll_left_margin, 5, 55, 1000, 0, -8, 700)
	This.of_build_computed_field("'Total for All'", 'footer', il_left_margin, 5, 1000, '[general]', 0, 'grand_total_label')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Modify the ending position of last object
//-----------------------------------------------------------------------------------------------------------------------------------
al_ending_x_position_of_last_object = al_ending_x_position_of_last_object + ll_x_position[UpperBound(in_pivot_table_row[])] + ll_width[UpperBound(in_pivot_table_row[])] + il_column_spacing

ll_computed_field_fontweight = il_computed_field_fontweight
il_computed_field_fontweight = 400

//----------------------------------------------------------------------------------------------------------------------------------
// Create the Row Label Columns if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.ShowRowLabels Then
	For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
		//----------------------------------------------------------------------------------------------------------------------------------
		// Make sure the array is large enough and default it
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(lb_label_created[]) < in_pivot_table_aggregate[ll_index].PivotTableRowID Then lb_label_created[in_pivot_table_aggregate[ll_index].PivotTableRowID] = False
	
		//----------------------------------------------------------------------------------------------------------------------------------
		// If we've already created a label for this level, continue
		//-----------------------------------------------------------------------------------------------------------------------------------
		If lb_label_created[in_pivot_table_aggregate[ll_index].PivotTableRowID] Then Continue
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Set the boolean to true
		//-----------------------------------------------------------------------------------------------------------------------------------
		lb_label_created[in_pivot_table_aggregate[ll_index].PivotTableRowID] = True
	
		//----------------------------------------------------------------------------------------------------------------------------------
		// If there is no name, continue
		//-----------------------------------------------------------------------------------------------------------------------------------
		If in_pivot_table_aggregate[ll_index].PivotTableRowName = '' Then Continue
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Build the static text on the header
		//-----------------------------------------------------------------------------------------------------------------------------------
		//This.of_build_statictext('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID), in_pivot_table_aggregate[ll_index].PivotTableRowName, 'detail', al_ending_x_position_of_last_object + il_column_spacing, (il_detailheight * (in_pivot_table_aggregate[ll_index].PivotTableRowID - 1)) + (5 * in_pivot_table_aggregate[ll_index].PivotTableRowID), 52, il_column_width, 1, -8, 400)
		This.of_build_computed_field("'" + in_pivot_table_aggregate[ll_index].PivotTableRowName + "'", 'detail', al_ending_x_position_of_last_object + il_column_spacing, (il_detailheight * (in_pivot_table_aggregate[ll_index].PivotTableRowID - 1)) + (5 * in_pivot_table_aggregate[ll_index].PivotTableRowID), il_column_width, '[general]', 1, 'rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID))
	
		//----------------------------------------------------------------------------------------------------------------------------------
		// Build the expression to keep them in line
		//-----------------------------------------------------------------------------------------------------------------------------------
		//If in_pivot_table_aggregate[ll_index].PivotTableRowID > 1 Then
		This.of_add_expression('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID), 'Width', 'Long(Describe("rowlabel1_srt.Width"))')
		This.of_add_expression('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID), 'X', 'Long(Describe("rowlabel1_srt.X"))')
		//End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Build the static text on the footer
		//-----------------------------------------------------------------------------------------------------------------------------------
		If in_pivot_table_properties.ShowRowTotals Then
			This.of_build_computed_field("'" + in_pivot_table_aggregate[ll_index].PivotTableRowName + "'", 'footer', al_ending_x_position_of_last_object + il_column_spacing, (il_detailheight * (in_pivot_table_aggregate[ll_index].PivotTableRowID - 1)) + (5 * in_pivot_table_aggregate[ll_index].PivotTableRowID), il_column_width, '[general]', 1, 'rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID) + '_footer')
			This.of_add_expression('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID) + '_footer', 'Width', 'Long(Describe("rowlabel1_srt.Width"))')
			This.of_add_expression('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID) + '_footer', 'X', 'Long(Describe("rowlabel1_srt.X"))')
	
			//This.of_build_statictext(ls_columnname + '_footer', in_pivot_table_aggregate[ll_index].PivotTableRowName, 'footer', al_ending_x_position_of_last_object + il_column_spacing, (il_detailheight * (in_pivot_table_aggregate[ll_index].PivotTableRowID - 1)) + (5 * in_pivot_table_aggregate[ll_index].PivotTableRowID), 52, il_column_width, 1, -8, 400)
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Build the static text on the group trailers
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index2 = 1 To il_number_of_groups
			//This.of_build_statictext('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID) + '_' + String(ll_index2), in_pivot_table_aggregate[ll_index].PivotTableRowName, 'trailer.' + String(ll_index2), al_ending_x_position_of_last_object + il_column_spacing, (il_detailheight * (in_pivot_table_aggregate[ll_index].PivotTableRowID - 1)) + (5 * in_pivot_table_aggregate[ll_index].PivotTableRowID) - 5, 52, il_column_width, 1, -8, 400)
			This.of_build_computed_field("'" + in_pivot_table_aggregate[ll_index].PivotTableRowName + "'", 'trailer.' + String(ll_index2), al_ending_x_position_of_last_object + il_column_spacing, (il_detailheight * (in_pivot_table_aggregate[ll_index].PivotTableRowID - 1)) + (5 * in_pivot_table_aggregate[ll_index].PivotTableRowID), il_column_width, '[general]', 1, 'rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID) + '_trailer' + String(ll_index2))
			This.of_add_expression('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID) + '_trailer', 'Width', 'Long(Describe("rowlabel1_srt.Width"))')
			This.of_add_expression('rowlabel' + String(in_pivot_table_aggregate[ll_index].PivotTableRowID) + '_trailer', 'X', 'Long(Describe("rowlabel1_srt.X"))')
		Next
	
		//----------------------------------------------------------------------------------------------------------------------------------
		// If we've already created the header for the labels continue
		//-----------------------------------------------------------------------------------------------------------------------------------
		If lb_header_label_created Then Continue
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// If we've already created the header for the labels continue
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_build_statictext('rowlabel1_srt', '.                                                                                                     ', 'header', al_ending_x_position_of_last_object + il_column_spacing, il_header_height - 60 + il_additional_header_height, 52, il_column_width, 1, -8, 700)
		lb_header_label_created = True
	Next
	
	If lb_header_label_created Then
		al_ending_x_position_of_last_object = al_ending_x_position_of_last_object + il_column_width + il_column_spacing
	End If
End If

il_computed_field_fontweight = ll_computed_field_fontweight

Return ''
end function

public function string of_create_grid_dataobject ();/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_create_grid_dataobject()
//	Overview:   Create the grid dataobject
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
// Local Variables
//---------------------------------------------------------------------------------
Boolean lb_equality, lb_we_need_to_determine_lookupdisplay = False
Boolean	lb_WeAreFillingInADateGap
DateTime	ldt_DateGapValue
String ls_error, ls_columnname, ls_additional_columns = ''
String	ls_aggregate_datatype
Long ll_index, ll_index2, ll_upperbound

//---------------------------------------------------------------------------------
// Local Objects
//---------------------------------------------------------------------------------
n_date_manipulator ln_date_manipulator

//---------------------------------------------------------------------------------
// Check to see if it is necessary to do the lookupdisplays for the column headers
//---------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If Not in_pivot_table_aggregate[ll_index].ForceSingleColumn Then
		lb_we_need_to_determine_lookupdisplay = True
		Exit
	End If
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore for use in creating the virtual column list
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(in_pivot_table_column[]) > 0 Then lb_we_need_to_determine_lookupdisplay = True

//---------------------------------------------------------------------------------
// Initialize the number of columns
//---------------------------------------------------------------------------------
il_number_of_columns = 1

is_complete_syntax = 'release 7;~r~ndatawindow(units=0 timer_interval=0 color=' + String(il_datawindow_backcolor) + ' processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )~r~n' + &
							'header(height=' + String(il_header_height) + ' color="536870912" )~r~n' + &
							'summary(height=' + String(il_summary_height) + ' color="536870912" )~r~n' + &
							'footer(height=' + String(il_footerheight) + ' color="536870912" )~r~n' + &
							'detail(height=' + String(il_detailheight) + ' color="536870912" )~r~n' + &
							'table('

//----------------------------------------------------------------------------------------------------------------------------------
// create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row[])
	Choose Case in_pivot_table_row[ll_index].Datatype
		Case 'string'
			is_complete_syntax = is_complete_syntax + 	' column=(type=char(4099) updatewhereclause=no name=row' + String(ll_index) + ' dbname="row' + String(ll_index) + '" ) ~r~n'
		Case 'datetime'
			is_complete_syntax = is_complete_syntax + 	' column=(type=datetime updatewhereclause=no name=row' + String(ll_index) + ' dbname="row' + String(ll_index) + '" ) ~r~n'			
		Case 'number'
			is_complete_syntax = is_complete_syntax + 	' column=(type=number updatewhereclause=no name=row' + String(ll_index) + ' dbname="row' + String(ll_index) + '" ) ~r~n'			
	End Choose
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Count the number of columns needed
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(in_pivot_table_column) > 0 Then

	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the upperbound of the data based on the datatype
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case in_pivot_table_column[1].Datatype
		Case 'string'
			ll_upperbound = UpperBound(lstr_columnstring[1].data[])
		Case 'datetime'
			ll_upperbound = UpperBound(lstr_columndatetime[1].data[])
		Case 'number'
			ll_upperbound = UpperBound(lstr_columnnumber[1].data[])
	End Choose
	
	ll_index = 1
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the display value
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lb_we_need_to_determine_lookupdisplay Then
		If ll_upperbound > 0 Then
			istr_columndata[1].display[il_number_of_columns] = This.of_get_column_display_value(in_pivot_table_column[1], ll_index)
		Else
			istr_columndata[1].display[il_number_of_columns] = 'No Data'
		End If
	End If
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all the data looking for data changes in the column values.  This will cause the number of colunmns to increment.
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 2 To ll_upperbound
		Choose Case in_pivot_table_column[1].Datatype
			Case 'string'
				If IsNull(lstr_columnstring[1].data[ll_index]) Or IsNull(lstr_columnstring[1].data[ll_index - 1]) Then
					lb_equality = (IsNull(lstr_columnstring[1].data[ll_index]) = IsNull(lstr_columnstring[1].data[ll_index - 1]))
				Else
					lb_equality = (lstr_columnstring[1].data[ll_index] = lstr_columnstring[1].data[ll_index - 1])
				End If
			Case 'datetime'
				If IsNull(lstr_columndatetime[1].data[ll_index]) Or IsNull(lstr_columndatetime[1].data[ll_index - 1]) Then
					lb_equality = (IsNull(lstr_columndatetime[1].data[ll_index]) = IsNull(lstr_columndatetime[1].data[ll_index - 1]))
				Else
					lb_equality = (lstr_columndatetime[1].data[ll_index] = lstr_columndatetime[1].data[ll_index - 1])
					
					If Not lb_equality Then
						//-----------------------------------------------------------------------------------------------------------------------------------
						// If we are filling in date gaps, we will need to do some special logic
						//-----------------------------------------------------------------------------------------------------------------------------------
						If Upper(Trim(in_pivot_table_column[1].FillInDateGaps)) = 'Y' Then
							//-----------------------------------------------------------------------------------------------------------------------------------
							// Make sure we're not filling in for any special dates
							//-----------------------------------------------------------------------------------------------------------------------------------
							If Date(lstr_columndatetime[1].data[ll_index]) <> 2050-12-31 And Date(lstr_columndatetime[1].data[ll_index]) <> 1950-01-01 And Date(lstr_columndatetime[1].data[ll_index]) <> 1900-01-01 And Date(lstr_columndatetime[1].data[ll_index - 1]) <> 2050-12-31 And Date(lstr_columndatetime[1].data[ll_index - 1]) <> 1950-01-01 And Date(lstr_columndatetime[1].data[ll_index - 1]) <> 1900-01-01 Then
								Choose Case Upper(Trim(in_pivot_table_column[1].DateGapType))
									Case 'M'
										ldt_DateGapValue = lstr_columndatetime[1].data[ll_index - 1]
										
										Do While DaysAfter(Date(ldt_DateGapValue), Date(lstr_columndatetime[1].data[ll_index])) > 31
											ldt_DateGapValue = ln_date_manipulator.of_get_last_of_month(ldt_DateGapValue)
											ldt_DateGapValue = DateTime(RelativeDate(Date(ldt_DateGapValue), 1))
											
											il_number_of_columns = il_number_of_columns + 1
											
											If lb_we_need_to_determine_lookupdisplay Then
												istr_columndata[1].display[il_number_of_columns] = String(ldt_DateGapValue, in_pivot_table_column[1].Format)
											End If
										Loop
										
									Case 'D'
										ldt_DateGapValue = lstr_columndatetime[1].data[ll_index - 1]
										
										Do While DaysAfter(Date(ldt_DateGapValue), Date(lstr_columndatetime[1].data[ll_index])) > 1
											ldt_DateGapValue = DateTime(RelativeDate(Date(ldt_DateGapValue), 1))
											
											il_number_of_columns = il_number_of_columns + 1
											
											If lb_we_need_to_determine_lookupdisplay Then
												istr_columndata[1].display[il_number_of_columns] = String(ldt_DateGapValue, in_pivot_table_column[1].Format)
											End If
										Loop
								End Choose
							End If
						End If
					End If

				End If
			Case 'number'
				If IsNull(lstr_columnnumber[1].data[ll_index]) Or IsNull(lstr_columnnumber[1].data[ll_index - 1]) Then
					lb_equality = (IsNull(lstr_columnnumber[1].data[ll_index]) = IsNull(lstr_columnnumber[1].data[ll_index - 1]))
				Else
					lb_equality = (lstr_columnnumber[1].data[ll_index] = lstr_columnnumber[1].data[ll_index - 1])
				End If
		End Choose
		
		If Not lb_equality Then 
			il_number_of_columns = il_number_of_columns + 1
			
			If lb_we_need_to_determine_lookupdisplay Then
				istr_columndata[1].display[il_number_of_columns] = This.of_get_column_display_value(in_pivot_table_column[1], ll_index)
			End If
		End If
	Next
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Add the columns to the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To il_number_of_columns
	For ll_index2 = 1 To Max(UpperBound(in_pivot_table_aggregate[]), 1)
		ls_columnname = 'column' + String(ll_index) + '_' + String(ll_index2)

		//----------------------------------------------------------------------------------------------------------------------------------
		// There is special logic for non-pivoted aggregates.  We only create one column instead of il_number_of_columns columns
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(in_pivot_table_aggregate[]) > 0 Then
			ls_aggregate_datatype = in_pivot_table_aggregate[ll_index2].DataType
			If in_pivot_table_aggregate[ll_index2].ForceSingleColumn Then
				If ll_index > 1 Then Continue
				
				ls_columnname = 'aggregate' + String(ll_index2)
			End If

			Choose Case Lower(Trim(in_pivot_table_aggregate[ll_index2].AggregateFunction))
				Case 'weightedaverage'
					ls_additional_columns = ls_additional_columns + 	' column=(type=number updatewhereclause=no name=weight' + ls_columnname + ' dbname="weight' + ls_columnname + '"  initial="0") ~r~n'
				Case 'divide'
					ls_additional_columns = ls_additional_columns + 	' column=(type=number updatewhereclause=no name=weight' + ls_columnname + ' dbname="weight' + ls_columnname + '"  initial="0") ~r~n'
					ls_additional_columns = ls_additional_columns + 	' column=(type=number updatewhereclause=no name=weight2' + ls_columnname + ' dbname="weight2' + ls_columnname + '"  initial="0") ~r~n'
				Case 'count'
					ls_aggregate_datatype = 'number'
			End Choose
		Else
			ls_aggregate_datatype = 'number'
		End If

		Choose Case ls_aggregate_datatype/**/
			Case 'string'/**/
				is_complete_syntax = is_complete_syntax + 	' column=(type=char(4099) updatewhereclause=no name=' + ls_columnname + ' dbname="' + ls_columnname + '" ) ~r~n'
			Case 'datetime'/**/
				is_complete_syntax = is_complete_syntax + 	' column=(type=datetime updatewhereclause=no name=' + ls_columnname + ' dbname="' + ls_columnname + '") ~r~n'
			Case 'number'
				is_complete_syntax = is_complete_syntax + 	' column=(type=number updatewhereclause=no name=' + ls_columnname + ' dbname="' + ls_columnname + '"  initial="0") ~r~n'
		End Choose
	Next
Next

is_complete_syntax = is_complete_syntax + ls_additional_columns
is_complete_syntax = is_complete_syntax + ' column=(type=char(1) updatewhereclause=no name=rowfocusindicator dbname="rowfocusindicator" ) ~r~n'
is_complete_syntax = is_complete_syntax + ' column=(type=number updatewhereclause=no name=sortcolumn dbname="sortcolumn" ) ~r~n'
is_complete_syntax = is_complete_syntax + ' column=(type=char(1) updatewhereclause=no name=expanded dbname="expanded" ) ~r~n'

//is_complete_syntax = is_complete_syntax + ' column=(type=char(1) updatewhereclause=no name=selectrowindicator dbname="selectrowindicator" ) ~r~n'

is_complete_syntax = is_complete_syntax + ')'

ids_data_creation.Create(is_complete_syntax, ls_error)

If Len(ls_error) > 0 Then
	Return 'Error:  Could not create pivot data object (' + ls_error + ')'
End If

If ib_we_need_to_sort_the_column_headers Then
	This.of_sort_columns()
End If

Return ''
end function

public subroutine of_show_detail (long row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_doubleclicked()
//	Arguments:  row
//					xpos
//					ypos
//					dwo
//	Overview:   This will hopefully show the details of the pivot table
//	Created by:	Blake Doerr
//	History: 	4/4/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_selected_rows[], ll_viewID
String ls_display_object, ls_error
n_report ln_report
NonVisualObject ln_service
Boolean	lb_scrolltorow = False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there is not destination yet
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_destination) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the search isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(iu_search) Then Return


If Not IsValid(iu_search_detail) Then

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Open a report if there isn't a valid destination
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_report = Create n_report
	ln_report.of_init(il_reportconfigid)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Open the new search on the search and set the overlaying report
	//-----------------------------------------------------------------------------------------------------------------------------------
	iu_search_detail = iu_search.of_OpenUserObject(ln_report.DisplayUserObject, 20000, 0)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// If the iu_search isn't valid, return
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsValid(iu_search_detail) Then
		Destroy 	ln_report
		Return
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// set the detail search to be the search that we just opened.  Delete buttons that are not needed
	//-----------------------------------------------------------------------------------------------------------------------------------
	iu_search.Dynamic of_set_pivottable_detail(iu_search_detail)
	iu_search_detail.of_set_option('allow retrieve', 'N')
	iu_search_detail.of_set_option('allow criteria', 'N')

	//----------------------------------------------------------------------------------------------------------------------------------
	// Initialize the report and resize
	//-----------------------------------------------------------------------------------------------------------------------------------
	iu_search_detail.of_set_adapter(iu_search.of_get_adapter())
	iu_search_detail.of_setdao(ln_report)
	iu_search.TriggerEvent('resize')
	lb_scrolltorow = True

	If IsValid(iu_original_search) Then
		ln_service = iu_original_search.of_get_report_dw().Dynamic of_get_service('n_dao_dataobject_state')
		If IsValid(ln_service) Then ll_viewID = ln_service.Dynamic of_get_current_view_id()
	End If
	
	ib_IgnoreUOMConversion = True

	If Not IsNull(ll_viewID) And ll_viewID > 0 Then
		gn_globals.in_subscription_service.of_message('apply view id', String(ll_viewID), iu_search_detail.of_get_report_dw())
	End If
	
	iu_search_detail.of_get_report_dw().Dynamic Create(ids_data_storage.Describe("Datawindow.Syntax"), ls_error)
	gn_globals.in_subscription_service.of_message('After View Restored', '', iu_search_detail.of_get_report_dw())
	
	ib_IgnoreUOMConversion = False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Copy the dropdowndatawindow data
//-----------------------------------------------------------------------------------------------------------------------------------
If iu_search_detail.of_get_report_dw().Event RetrieveStart() = 1 Then Return
iu_search_detail.of_get_report_dw().Reset()
in_datawindow_tools.of_share_dropdowndatawindows(ids_data_storage, iu_search_detail.dw_report)

//-----------------------------------------------------------------------------------------------------------------------------------
// Copy the data from one primary buffer to the other
//-----------------------------------------------------------------------------------------------------------------------------------
ids_data_storage.RowsCopy(1, ids_data_storage.RowCount(), Primary!, iu_search_detail.of_get_report_dw(), 1, Primary!)
iu_search_detail.of_get_report_dw().Event RetrieveEnd(iu_search_detail.of_get_report_dw().RowCount())

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the status for the rows.  RowsCopy starts them all out as NewModified!.
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To iu_original_search.dw_report.RowCount()
	If iu_original_search.dw_report.getitemstatus(ll_index, 0, Primary!) = NotModified! Then
		iu_search_detail.of_get_report_dw().setitemstatus(ll_index, 0, Primary!, DataModified!)
		iu_search_detail.of_get_report_dw().setitemstatus(ll_index, 0, Primary!, NotModified!)
	Else
		iu_search_detail.of_get_report_dw().setitemstatus(ll_index, 0, Primary!, iu_original_search.dw_report.getitemstatus(ll_index, 0, Primary!))
	End If
Next
If lb_scrolltorow And row > 0 And Not IsNull(row) Then idw_destination.ScrollToRow(row)

end subroutine

public subroutine of_arrange_pivot_elements ();/**/
Boolean	lb_ShowColumnTotalsMultiple	= False
Boolean	lb_ShowColumnTotals				= False
Boolean	lb_ShowRowTotals					= False
Boolean	lb_WeAreNoLongerCreatingGroups
String	ls_ForceSingleColumn[]
String	ls_PivotTableRowName[]
String	ls_PivotTableColumnName[]
String	ls_rowname[]
String	ls_columnname[]
Long		ll_index, ll_index2
Long		ll_id[]
Long		ll_sortedid[]
Long		ll_PivotTableColumnID[]
Long		ll_PivotTableRowID[]

n_pivot_table_element ln_new_pivot_table_element_array[]
n_pivot_table_element ln_empty_pivot_table_element_array[]
n_pivot_table_element ln_pivot_table_element_placeholder

Datastore	lds_datastore

If UpperBound(in_pivot_table_aggregate[]) = 0 Then
	lb_ShowColumnTotalsMultiple	= False
	lb_ShowColumnTotals				= UpperBound(in_pivot_table_column[]) > 0
	lb_ShowRowTotals					= True
End If

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If in_pivot_table_aggregate[ll_index].ShowColumnTotalsMultiple And (in_pivot_table_aggregate[ll_index].Datatype = 'number' Or in_pivot_table_aggregate[ll_index].AggregateFunction = 'count') Then
		lb_ShowColumnTotalsMultiple = True
	End If

	If in_pivot_table_aggregate[ll_index].ShowColumnTotals And (in_pivot_table_aggregate[ll_index].Datatype = 'number' Or in_pivot_table_aggregate[ll_index].AggregateFunction = 'count') Then
		lb_ShowColumnTotals = True
	End If
	
	If in_pivot_table_aggregate[ll_index].ShowRowTotals And (in_pivot_table_aggregate[ll_index].Datatype = 'number' Or in_pivot_table_aggregate[ll_index].AggregateFunction = 'count') Then
		lb_ShowRowTotals = True
	End If
Next

If Not lb_ShowColumnTotalsMultiple Then
	in_pivot_table_properties.ShowColumnTotalsMultiple = False
End If

If Not lb_ShowColumnTotals Then
	in_pivot_table_properties.ShowColumnTotals = False
End If

If Not lb_ShowRowTotals Then
	in_pivot_table_properties.ShowRowTotals = False
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that after the first row that's selected is no longer creating groups, none others do
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If Not in_pivot_table_row[ll_index].CreateGroup Then
		lb_WeAreNoLongerCreatingGroups = True
	Else
		If lb_WeAreNoLongerCreatingGroups And ll_index <> UpperBound(in_pivot_table_row[]) Then
			in_pivot_table_row[ll_index].CreateGroup = False
		End If
	End If
Next

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	in_pivot_table_aggregate[ll_index].PivotTableColumnID = 1
	in_pivot_table_aggregate[ll_index].PivotTableRowID		= 1
Next

If UpperBound(in_pivot_table_aggregate[]) < 2 Then Return

lds_datastore = Create Datastore

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	lds_datastore.InsertRow(0)
Next



For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	ll_id[ll_index] 						= ll_index

	For ll_index2 = 1 To UpperBound(ls_PivotTableRowName[])
		If ls_PivotTableRowName[ll_index2] = in_pivot_table_aggregate[ll_index].PivotTableRowName Then
			Exit
		End If
	Next
	
	ls_PivotTableRowName[ll_index2] = in_pivot_table_aggregate[ll_index].PivotTableRowName
	ll_PivotTableRowID[ll_index] = ll_index2

	For ll_index2 = 1 To UpperBound(ls_PivotTableColumnName[])
		If ls_PivotTableColumnName[ll_index2] = in_pivot_table_aggregate[ll_index].PivotTableColumnName Then
			Exit
		End If
	Next

	ls_PivotTableColumnName[ll_index2] = in_pivot_table_aggregate[ll_index].PivotTableColumnName
	ll_PivotTableColumnID[ll_index] = ll_index2
	
	If in_pivot_table_aggregate[ll_index].ForceSingleColumn Then
		ls_ForceSingleColumn[ll_index] = 'Y'
	Else
		ls_ForceSingleColumn[ll_index] = 'N'
	End If
Next

lds_datastore = Create Datastore
lds_datastore.DataObject = 'd_pivot_table_sort_elements'
lds_datastore.Object.ID.Primary 						= ll_id[]
lds_datastore.Object.RowID.Primary 					= ll_PivotTableRowID[]
lds_datastore.Object.ColumnID.Primary 				= ll_PivotTableColumnID[]
lds_datastore.Object.ForceSingleColumn.Primary 	= ls_ForceSingleColumn[]
lds_datastore.SetSort('ForceSingleColumn D, ColumnID, RowID, ID')
lds_datastore.Sort()

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	ln_new_pivot_table_element_array[ll_index] 							= in_pivot_table_aggregate[lds_datastore.GetItemNumber(ll_index, 'ID')]
	ln_new_pivot_table_element_array[ll_index].PivotTableRowID		= lds_datastore.GetItemNumber(ll_index, 'RowID')
	ln_new_pivot_table_element_array[ll_index].PivotTableColumnID	= lds_datastore.GetItemNumber(ll_index, 'ColumnID')
Next

Destroy lds_datastore

in_pivot_table_aggregate[] = ln_new_pivot_table_element_array[]


end subroutine

public function string of_insert_data ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_insert_data()
//	Overview:   Insert the data into the grid
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
// Local Variables
//---------------------------------------------------------------------------------
Boolean 	lb_changed
Boolean 	lb_column_changed
Boolean 	lb_find_string_was_cached
Boolean	lb_insert_data = True
Long 		ll_index
Long 		ll_index2
Long 		ll_upperbound
Long 		ll_findstring_index
Long 		ll_columncount
Long 		ll_aggregate_count[]
Long 		ll_column_index
Long 		ll_row
Long 		ll_column_upperbound
Long 		ll_row_upperbound
Long 		ll_aggregate_upperbound
Long 		ll_aggregate_upperbound_max
DateTime	ldt_DateGapValue
DateTime	ldt_FromDateGapValue
DateTime	ldt_ToDateGapValue
DateTime	ldt_row_fillingaps[]
DateTime	ldt_row_fillingaps_new[]
Double 	ldble_aggregate_sum[]
Double 	ldble_aggregateweight_sum[]
Double 	ldble_result[]
Double 	ldble_row_value[]
Double 	ldble_empty[]
Double 	ldble_temporary
Double	ldble_temporary_weight
Double	ldble_temporary_weight2
Double	ldble_dummy[]
String	ls_aggregate_datatype
String	ls_find_prefix[]
String	ls_find_suffix[]
String	ls_find_prefix_null[]
String	ls_find_null[]
String	ls_find_string
String	ls_display_string
String	ls_aggregate_function
String	ls_columnname
String 	ls_column_value[]
String	ls_row_value[]
String	ls_aggregate_value[]
String	ls_previous_column_value[]
String	ls_previous_row_value[]
String	ls_filterstring
String	ls_result[]
String	ls_temporary
String	ls_empty[]
String	ls_null
String	ls_dummy[]
DateTime	ldt_result[]
DateTime	ldt_temporary
DateTime	ldt_empty[]
DateTime	ldt_null
SetNull(ldt_null)
SetNull(ls_null)

//---------------------------------------------------------------------------------
// Local Objects
//---------------------------------------------------------------------------------
//n_string_functions ln_string_functions
n_date_manipulator ln_date_manipulator

ll_column_upperbound		= UpperBound(in_pivot_table_column[])
ll_row_upperbound			= UpperBound(in_pivot_table_row[])
ll_aggregate_upperbound	= UpperBound(in_pivot_table_aggregate[])
ll_aggregate_upperbound_max	= Max(ll_aggregate_upperbound, 1)

//---------------------------------------------------------------------------------
// Create find prefixes and suffixes so we can easily build the find string
//---------------------------------------------------------------------------------
For ll_index = 1 To ll_row_upperbound
	Choose Case in_pivot_table_row[ll_index].Datatype
		Case 'string'
			ls_find_prefix[ll_index] 	= 'row' + String(ll_index) + ' = "'
			ls_find_suffix[ll_index] 	= '"'
		Case 'datetime'
			ls_find_prefix[ll_index] = 'row' + String(ll_index) + ' = DateTime("'
			ls_find_suffix[ll_index] = '")'
		Case 'number'
			ls_find_prefix[ll_index] = 'row' + String(ll_index) + ' = '
			ls_find_suffix[ll_index] = ''
	End Choose
	
	ls_find_null[ll_index]		= 'IsNull(row' + String(ll_index) + ')'

	If ll_index < ll_row_upperbound Then ls_find_suffix[ll_index] = ls_find_suffix[ll_index] + ' and '
	If ll_index < ll_row_upperbound Then ls_find_null[ll_index] = ls_find_null[ll_index] + ' and '
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(in_pivot_table_row[]) > 0 Then
	Choose Case in_pivot_table_row[1].Datatype
		Case 'string'
			ll_upperbound = UpperBound(lstr_rowstring[1].data[])
		Case 'datetime'
			ll_upperbound = UpperBound(lstr_rowdatetime[1].data[])
		Case 'number'
			ll_upperbound = UpperBound(lstr_rownumber[1].data[])
	End Choose
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Count the number of columns needed
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Inserting Data (Calculating) 30%', 30)

//----------------------------------------------------------------------------------------------------------------------------------
// Count the number of columns needed
//-----------------------------------------------------------------------------------------------------------------------------------
lb_changed = False
lb_column_changed = False
ll_column_index = 1

For ll_index = 1 To ll_upperbound
	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the aggregates, maintaining the data
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index2 = 1 To ll_aggregate_upperbound_max/**/
		ls_result[ll_index2] = ls_null/**/
		ldt_result[ll_index2] = ldt_null/**/
	Next/**/

	If Mod(ll_index, Max(1, Long(ll_upperbound / 50))) = 0 Then
//		If Not gb_runningasaservice Then w_mdi_frame.of_position_statusbar('Inserting Data (Calculating) ' + String(31 + Long(Double(ll_index * 50) / Double(ll_upperbound))) + '%', 31 + Long(Double(ll_index * 50) / Double(ll_upperbound)))
	End If
	
	If ll_index < ll_upperbound Then
		//----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the columns and get the new values while checking for changes
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index2 = 1 To ll_column_upperbound
			Choose Case in_pivot_table_column[ll_index2].Datatype
				Case 'string'
					lb_changed 			= (lb_changed 			Or (lstr_columnstring[ll_index2].data[ll_index] <> lstr_columnstring[ll_index2].data[ll_index + 1]))
					lb_column_changed = (lb_column_changed Or (lstr_columnstring[ll_index2].data[ll_index] <> lstr_columnstring[ll_index2].data[ll_index + 1]))
					lb_column_changed = (lb_column_changed Or (IsNull(lstr_columnstring[ll_index2].data[ll_index]) <> IsNull(lstr_columnstring[ll_index2].data[ll_index + 1])))
				Case 'datetime'
					lb_changed 			= (lb_changed 			Or (lstr_columndatetime[ll_index2].data[ll_index] <> lstr_columndatetime[ll_index2].data[ll_index + 1]))
					lb_column_changed = (lb_column_changed Or (lstr_columndatetime[ll_index2].data[ll_index] <> lstr_columndatetime[ll_index2].data[ll_index + 1]))
					lb_column_changed = (lb_column_changed Or (IsNull(lstr_columndatetime[ll_index2].data[ll_index]) <> IsNull(lstr_columndatetime[ll_index2].data[ll_index + 1])))
				Case 'number'
					lb_changed 			= (lb_changed 			Or (lstr_columnnumber[ll_index2].data[ll_index] <> lstr_columnnumber[ll_index2].data[ll_index + 1]))
					lb_column_changed = (lb_column_changed Or (lstr_columnnumber[ll_index2].data[ll_index] <> lstr_columnnumber[ll_index2].data[ll_index + 1]))					
					lb_column_changed = (lb_column_changed Or (IsNull(lstr_columnnumber[ll_index2].data[ll_index]) <> IsNull(lstr_columnnumber[ll_index2].data[ll_index + 1])))
			End Choose
		Next

		//----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the rows and get the new values while checking for changes
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index2 = 1 To ll_row_upperbound
			Choose Case in_pivot_table_row[ll_index2].Datatype
				Case 'string'
					lb_changed = (lb_changed Or (lstr_rowstring[ll_index2].data[ll_index] <> lstr_rowstring[ll_index2].data[ll_index + 1]) Or (IsNull(lstr_rowstring[ll_index2].data[ll_index]) <> IsNull(lstr_rowstring[ll_index2].data[ll_index + 1])))
				Case 'datetime'
					// JWP - Added String around DateTime since the values sometimes would come back <> when they were in fact =
					lb_changed = (lb_changed Or (string(lstr_rowdatetime[ll_index2].data[ll_index]) <> string(lstr_rowdatetime[ll_index2].data[ll_index + 1])) Or (IsNull(lstr_rowdatetime[ll_index2].data[ll_index]) <> IsNull(lstr_rowdatetime[ll_index2].data[ll_index + 1])))
				Case 'number'
					lb_changed = (lb_changed Or (lstr_rownumber[ll_index2].data[ll_index] <> lstr_rownumber[ll_index2].data[ll_index + 1]) Or (IsNull(lstr_rownumber[ll_index2].data[ll_index]) <> IsNull(lstr_rownumber[ll_index2].data[ll_index + 1])))
			End Choose
		Next
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through the aggregates, maintaining the data
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index2 = 1 To ll_aggregate_upperbound_max
		ll_aggregate_count[ll_index2] = ll_aggregate_count[ll_index2] + 1

		//----------------------------------------------------------------------------------------------------------------------------------
		// This will allow the user to not pick an aggregate and it will count automatically
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(in_pivot_table_aggregate[]) > 0 Then
			ls_aggregate_function = in_pivot_table_aggregate[ll_index2].AggregateFunction
			ls_aggregate_datatype = in_pivot_table_aggregate[ll_index2].Datatype/**/
			
			If ls_aggregate_function = 'count' Then
				ls_aggregate_datatype = 'number'
			End If
		Else
			ls_aggregate_function = 'count'
			ls_aggregate_datatype = 'number'/**/
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Aggregate the data according to function type
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case ls_aggregate_datatype/**/
			Case 'string'
				Choose Case ls_aggregate_function
					Case 'max'
						If Not IsNull(lstr_aggregatestring[ll_index2].data[ll_index]) Then
							If lstr_aggregatestring[ll_index2].data[ll_index] > ls_result[ll_index2] Or IsNull(ls_result[ll_index2]) Then
								ls_result[ll_index2] = lstr_aggregatestring[ll_index2].data[ll_index]
							End If
						Else
							If IsNull(ls_result[ll_index2]) Then ls_result[ll_index2] = ''
						End If
					Case 'min'
						If Not IsNull(lstr_aggregatestring[ll_index2].data[ll_index]) Then
							If lstr_aggregatestring[ll_index2].data[ll_index] < ls_result[ll_index2] Or IsNull(ls_result[ll_index2]) Then
								ls_result[ll_index2] = lstr_aggregatestring[ll_index2].data[ll_index]
							End If
						Else
							If IsNull(ls_result[ll_index2]) Then ls_result[ll_index2] = ''
						End If
				End Choose
			Case 'datetime'
				Choose Case ls_aggregate_function
					Case 'max'
						If Not IsNull(lstr_aggregatedatetime[ll_index2].data[ll_index]) Then
							If lstr_aggregatedatetime[ll_index2].data[ll_index] > ldt_result[ll_index2] Or IsNull(ldt_result[ll_index2]) Then
								ldt_result[ll_index2] = lstr_aggregatedatetime[ll_index2].data[ll_index]
							End If
						End If
					Case 'min'
						If Not IsNull(lstr_aggregatedatetime[ll_index2].data[ll_index]) Then
							If lstr_aggregatedatetime[ll_index2].data[ll_index] < ldt_result[ll_index2] Or IsNull(ldt_result[ll_index2]) Then
								ldt_result[ll_index2] = lstr_aggregatedatetime[ll_index2].data[ll_index]
							End If
						End If
				End Choose
			Case 'number'/**/
				//----------------------------------------------------------------------------------------------------------------------------------
				// Aggregate the data according to function type
				//-----------------------------------------------------------------------------------------------------------------------------------
				Choose Case ls_aggregate_function
					Case 'max'
						If Not IsNull(lstr_aggregatenumber[ll_index2].data[ll_index]) Then
							If ll_index2 > UpperBound(ldble_result[]) Then
								ldble_result[ll_index2] 	= lstr_aggregatenumber[ll_index2].data[ll_index]
							Else
								ldble_result[ll_index2] 	= Max(ldble_result[ll_index2], lstr_aggregatenumber[ll_index2].data[ll_index])
							End If
						Else
							ldble_result[ll_index2] 	= Max(ldble_result[ll_index2], 0.0)
						End If
					Case 'min'
						If Not IsNull(lstr_aggregatenumber[ll_index2].data[ll_index]) Then
							If ll_index2 > UpperBound(ldble_result[]) Then
								ldble_result[ll_index2] = lstr_aggregatenumber[ll_index2].data[ll_index]
							Else
								ldble_result[ll_index2] 	= Min(ldble_result[ll_index2], lstr_aggregatenumber[ll_index2].data[ll_index])
							End If
						Else
							ldble_result[ll_index2] 	= Min(ldble_result[ll_index2], 0.0)
						End If
					Case 'sum'
						If Not IsNull(lstr_aggregatenumber[ll_index2].data[ll_index]) Then
							ldble_result[ll_index2] 	= ldble_result[ll_index2] + lstr_aggregatenumber[ll_index2].data[ll_index]
						Else
							ldble_result[ll_index2] 	= ldble_result[ll_index2] + 0.0
						End If
					Case 'avg', 'average'
						If Not IsNull(lstr_aggregatenumber[ll_index2].data[ll_index]) Then
							ldble_aggregate_sum[ll_index2] 	= ldble_aggregate_sum[ll_index2] + lstr_aggregatenumber[ll_index2].data[ll_index]
						Else
							ldble_aggregate_sum[ll_index2] 	= ldble_aggregate_sum[ll_index2] + 0.0
						End If
						ldble_result[ll_index2] 			= ldble_aggregate_sum[ll_index2]	/ Double(ll_aggregate_count[ll_index2])
					Case 'weightedaverage'
						If Not IsNull(lstr_aggregatenumber[ll_index2].data[ll_index]) And Not IsNull(lstr_aggregateweightednumber[ll_index2].data[ll_index]) Then
							ldble_aggregate_sum[ll_index2] 			= ldble_aggregate_sum[ll_index2] + (lstr_aggregatenumber[ll_index2].data[ll_index] * Abs(lstr_aggregateweightednumber[ll_index2].data[ll_index]))
							ldble_aggregateweight_sum[ll_index2]	= ldble_aggregateweight_sum[ll_index2] + Abs(lstr_aggregateweightednumber[ll_index2].data[ll_index])
							If ldble_aggregateweight_sum[ll_index2] = 0.0 Then
								ldble_result[ll_index2] = 0.0
							Else
								ldble_result[ll_index2] 					= ldble_aggregate_sum[ll_index2]	/ ldble_aggregateweight_sum[ll_index2]
							End If
						Else
							ldble_aggregate_sum[ll_index2] 			= ldble_aggregate_sum[ll_index2] + 0.0
							If IsNull(lstr_aggregateweightednumber[ll_index2].data[ll_index]) Then
								ldble_aggregateweight_sum[ll_index2]	= ldble_aggregateweight_sum[ll_index2] + 0.0
							Else
								ldble_aggregateweight_sum[ll_index2]	= ldble_aggregateweight_sum[ll_index2] + Abs(lstr_aggregateweightednumber[ll_index2].data[ll_index])
							End If
							
							If ldble_aggregateweight_sum[ll_index2] = 0.0 Then
								ldble_result[ll_index2] = 0.0
							Else
								ldble_result[ll_index2] 					= ldble_aggregate_sum[ll_index2]	/ ldble_aggregateweight_sum[ll_index2]
							End If
						End If
					Case 'divide'
						If Not IsNull(lstr_aggregateweightednumber[ll_index2].data[ll_index]) And Not IsNull(lstr_aggregatenumber[ll_index2].data[ll_index]) Then
							ldble_aggregateweight_sum[ll_index2]	= ldble_aggregateweight_sum[ll_index2] + lstr_aggregateweightednumber[ll_index2].data[ll_index]
							ldble_aggregate_sum[ll_index2] 			= ldble_aggregate_sum[ll_index2] + lstr_aggregatenumber[ll_index2].data[ll_index]
						
							If ldble_aggregateweight_sum[ll_index2] = 0.0 Then
								ldble_result[ll_index2] = 0.0
							Else
								ldble_result[ll_index2] 					= ldble_aggregate_sum[ll_index2]	/ ldble_aggregateweight_sum[ll_index2]
							End If
						Else
							If IsNull(lstr_aggregateweightednumber[ll_index2].data[ll_index]) Then
								ldble_aggregateweight_sum[ll_index2]	= ldble_aggregateweight_sum[ll_index2] + 0.0
							Else
								ldble_aggregateweight_sum[ll_index2]	= ldble_aggregateweight_sum[ll_index2] + lstr_aggregateweightednumber[ll_index2].data[ll_index]
							End If
		
							If IsNull(lstr_aggregatenumber[ll_index2].data[ll_index]) Then
								ldble_aggregate_sum[ll_index2] 			= ldble_aggregate_sum[ll_index2] + 0.0
							Else
								ldble_aggregate_sum[ll_index2] 			= ldble_aggregate_sum[ll_index2] + lstr_aggregatenumber[ll_index2].data[ll_index]
							End If
						
							If ldble_aggregateweight_sum[ll_index2] = 0.0 Then
								ldble_result[ll_index2] = 0.0
							Else
								ldble_result[ll_index2] 					= ldble_aggregate_sum[ll_index2]	/ ldble_aggregateweight_sum[ll_index2]
							End If
						End If
					Case 'count'
						ldble_result[ll_index2]				= ll_aggregate_count[ll_index2]
				End Choose
		End Choose
	Next


	//----------------------------------------------------------------------------------------------------------------------------------
	// When we need to insert the data, process this logic
	//-----------------------------------------------------------------------------------------------------------------------------------
	If (ll_index = ll_upperbound) Or lb_changed Then
		ls_find_string = ''

//		lb_insert_data = False
//		If in_pivot_table_properties.ExcludeZeroRows Then
//			For ll_index2 = 1 To UpperBound(in_pivot_table_aggregate[])
//				If in_pivot_table_aggregate[ll_index2].ForceSingleColumn Then
//					lb_insert_data = True
//					Exit
//				End If
//				
//				If ldble_result[ll_index2] <> 0.0 Then
//					lb_insert_data = True
//					Exit
//				End If
//			Next
//		Else
			lb_insert_data = True
//		End If

		If lb_insert_data Then
			//----------------------------------------------------------------------------------------------------------------------------------
			// Build the complete find string for the row
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index2 = 1 To ll_row_upperbound
				Choose Case in_pivot_table_row[ll_index2].Datatype
					Case 'string'
						If IsNull(lstr_rowstring[ll_index2].data[ll_index]) Then
							ls_find_string = ls_find_string + ls_find_null[ll_index2]
						Else
							ls_find_string = ls_find_string + ls_find_prefix[ll_index2] + lstr_rowstring[ll_index2].data[ll_index] + ls_find_suffix[ll_index2]
						End If
					Case 'datetime'
						If IsNull(lstr_rowdatetime[ll_index2].data[ll_index]) Then
							ls_find_string = ls_find_string + ls_find_null[ll_index2]
						Else
							ls_find_string = ls_find_string + ls_find_prefix[ll_index2] + gn_globals.in_string_functions.of_convert_datetime_to_string(lstr_rowdatetime[ll_index2].data[ll_index]) + ls_find_suffix[ll_index2]
						End If
					Case 'number'
						If IsNull(lstr_rownumber[ll_index2].data[ll_index]) Then
							ls_find_string = ls_find_string + ls_find_null[ll_index2]
						Else
							ls_find_string = ls_find_string + ls_find_prefix[ll_index2] + String(lstr_rownumber[ll_index2].data[ll_index]) + ls_find_suffix[ll_index2]
						End If
				End Choose
			Next
	
			//----------------------------------------------------------------------------------------------------------------------------------
			// See if the row is already there in the datawindow.
			//-----------------------------------------------------------------------------------------------------------------------------------
			ll_row = ids_data_creation.Find(ls_find_string, 1, ids_data_creation.RowCount())
			
			//----------------------------------------------------------------------------------------------------------------------------------
			// If it isn't, we need to populate the row information
			//-----------------------------------------------------------------------------------------------------------------------------------
			If IsNull(ll_row) Or ll_row <= 0 Then
				ll_row = ids_data_creation.InsertRow(0)
	
				For ll_index2 = 1 To ll_row_upperbound
					Choose Case in_pivot_table_row[ll_index2].Datatype
						Case 'string'
							ids_data_creation.SetItem(ll_row, 'row' + String(ll_index2), lstr_rowstring[ll_index2].data[ll_index])
						Case 'datetime'
							ids_data_creation.SetItem(ll_row, 'row' + String(ll_index2), lstr_rowdatetime[ll_index2].data[ll_index])
						Case 'number'
							ids_data_creation.SetItem(ll_row, 'row' + String(ll_index2), lstr_rownumber[ll_index2].data[ll_index])
					End Choose
				Next
			End If
			
	
			//----------------------------------------------------------------------------------------------------------------------------------
			// When we have found the cell, set the data into it **** need to handle multiple columns per column
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index2 = 1 To Max(ll_aggregate_upperbound, 1)
				//----------------------------------------------------------------------------------------------------------------------------------
				// This will allow the user to not pick an aggregate and it will count automatically
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(in_pivot_table_aggregate[]) > 0 Then/**/
					ls_aggregate_datatype = in_pivot_table_aggregate[ll_index2].Datatype/**/

					If in_pivot_table_aggregate[ll_index2].AggregateFunction = 'count' Then
						ls_aggregate_datatype = 'number'
					End If
				Else/**/
					ls_aggregate_datatype = 'number'/**/
				End If/**/

				//----------------------------------------------------------------------------------------------------------------------------------
				// This looks weird, but what we are doing here is determining the column.  Since I couldn't use the correct sorting
				//		because of the lookupdisplay performance problem,  we have a translation (order[]) that will effectively
				//		sort the column headers.
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(istr_columndata[]) > 0 Then
					If UpperBound(istr_columndata[1].order[]) >= ll_column_index Then
						ls_columnname = 'column' + String(istr_columndata[1].order[ll_column_index]) + '_' + String(ll_index2)
					Else
						ls_columnname = 'column' + String(ll_column_index) + '_' + String(ll_index2)					
					End If
				Else
					ls_columnname = 'column' + String(ll_column_index) + '_' + String(ll_index2)									
				End If
	
				//----------------------------------------------------------------------------------------------------------------------------------
				// We need to check to see if the aggregate is pivoted, if not we must add?*** the new value to the one that may already be there
				//-----------------------------------------------------------------------------------------------------------------------------------
				If ll_aggregate_upperbound > 0 Then
					If in_pivot_table_aggregate[ll_index2].ForceSingleColumn Then
						ls_columnname = 'aggregate' + String(ll_index2)
						
						//----------------------------------------------------------------------------------------------------------------------------------
						// Get the value that is there and add it (if necessary) to the result
						//-----------------------------------------------------------------------------------------------------------------------------------
						Choose Case ls_aggregate_datatype
							Case 'number'
								ldble_temporary = ids_data_creation.GetItemNumber(ll_row, ls_columnname)
								
								Choose Case Lower(Trim(in_pivot_table_aggregate[ll_index2].AggregateFunction))
									Case 'sum'
										If Not IsNull(ldble_temporary) Then
											ldble_result[ll_index2] = ldble_result[ll_index2] + ldble_temporary
										End If
									Case 'min'
										If Not IsNull(ldble_temporary) Then
											ldble_result[ll_index2] = Min(ldble_result[ll_index2], ldble_temporary)
										End If
									Case 'max'
										If Not IsNull(ldble_temporary) Then
											ldble_result[ll_index2] = Max(ldble_result[ll_index2], ldble_temporary)
										End If
									Case 'avg', 'average'
										If Not IsNull(ldble_temporary) Then
											ldble_result[ll_index2] = (ldble_result[ll_index2] + ldble_temporary) / 2
										End If
									Case 'weightedaverage'
										ldble_temporary_weight = ids_data_creation.GetItemNumber(ll_row, 'weight' + ls_columnname)
		
										If Not IsNull(ldble_temporary_weight) And Not IsNull(ldble_temporary) Then
											ldble_temporary = ldble_temporary * ldble_temporary_weight + ldble_result[ll_index2] * ldble_aggregateweight_sum[ll_index2]
		
											If ldble_temporary_weight + ldble_aggregateweight_sum[ll_index2] <> 0 And Not IsNull(ldble_temporary_weight + ldble_aggregateweight_sum[ll_index2]) Then
												ldble_aggregateweight_sum[ll_index2] = ldble_aggregateweight_sum[ll_index2] + ldble_temporary_weight
												ldble_result[ll_index2] = ldble_temporary / ldble_aggregateweight_sum[ll_index2]
											End If
										End If
										
										ids_data_creation.SetItem(ll_row, 'weight' + ls_columnname, ldble_aggregateweight_sum[ll_index2])
									Case 'divide'
										ldble_temporary_weight 	= ids_data_creation.GetItemNumber(ll_row, 'weight' + ls_columnname)
										ldble_temporary_weight2 = ids_data_creation.GetItemNumber(ll_row, 'weight2' + ls_columnname)
										
										If Not IsNull(ldble_temporary_weight) Then
											ldble_aggregateweight_sum[ll_index2] = ldble_aggregateweight_sum[ll_index2] + ldble_temporary_weight
										End If
		
										If Not IsNull(ldble_temporary_weight2) Then
											ldble_aggregate_sum[ll_index2] = ldble_aggregate_sum[ll_index2] + ldble_temporary_weight2
										End If
		
										ids_data_creation.SetItem(ll_row, 'weight' + ls_columnname, ldble_aggregateweight_sum[ll_index2])
										ids_data_creation.SetItem(ll_row, 'weight2' + ls_columnname, ldble_aggregate_sum[ll_index2])
								End Choose
							Case 'string'
								ls_temporary = ids_data_creation.GetItemString(ll_row, ls_columnname)

								Choose Case Lower(Trim(in_pivot_table_aggregate[ll_index2].AggregateFunction))
									Case 'min'
										If Not IsNull(ls_temporary) Then
											If ls_temporary < ls_result[ll_index2] Or IsNull(ls_result[ll_index2]) Then
												ls_result[ll_index2] = ls_temporary
											End If
										End If
									Case 'max'
										If Not IsNull(ls_temporary) Then
											If ls_temporary > ls_result[ll_index2] Or IsNull(ls_result[ll_index2]) Then
												ls_result[ll_index2] = ls_temporary
											End If
										End If								
								End Choose
							Case 'datetime'
								ldt_temporary = ids_data_creation.GetItemDateTime(ll_row, ls_columnname)
								
								Choose Case Lower(Trim(in_pivot_table_aggregate[ll_index2].AggregateFunction))
									Case 'min'
										If Not IsNull(ldt_temporary) Then
											If ldt_temporary < ldt_result[ll_index2] Or IsNull(ldt_result[ll_index2]) Then
												ldt_result[ll_index2] = ldt_temporary
											End If
										End If
									Case 'max'
										If Not IsNull(ldt_temporary) Then
											If ldt_temporary > ldt_result[ll_index2] Or IsNull(ldt_result[ll_index2]) Then
												ldt_result[ll_index2] = ldt_temporary
											End If
										End If								
								End Choose
						End Choose
					End If
							
					Choose Case Lower(Trim(in_pivot_table_aggregate[ll_index2].AggregateFunction))
						Case 'weightedaverage'
							ids_data_creation.SetItem(ll_row, 'weight' + ls_columnname, ldble_aggregateweight_sum[ll_index2])
						Case 'divide'
							ids_data_creation.SetItem(ll_row, 'weight' + ls_columnname, ldble_aggregateweight_sum[ll_index2])
							ids_data_creation.SetItem(ll_row, 'weight2' + ls_columnname, ldble_aggregate_sum[ll_index2])
					End Choose
				End If
		
				Choose Case ls_aggregate_datatype
					Case 'number'
						ids_data_creation.SetItem(ll_row, ls_columnname, ldble_result[ll_index2])
					Case 'string'
						ids_data_creation.SetItem(ll_row, ls_columnname, ls_result[ll_index2])
					Case 'datetime'
						ids_data_creation.SetItem(ll_row, ls_columnname, ldt_result[ll_index2])
				End Choose

				ll_aggregate_count[ll_index2] = 0
			Next
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Reset some variables
		//-----------------------------------------------------------------------------------------------------------------------------------
		ldble_result 					= ldble_empty
		ldble_aggregate_sum			= ldble_empty
		ldble_aggregateweight_sum	= ldble_empty
		ldt_result						= ldt_empty
		ls_result						= ls_empty

		//----------------------------------------------------------------------------------------------------------------------------------
		// Store the column data so we can create the GUI and reference these values later
		//-----------------------------------------------------------------------------------------------------------------------------------
		If lb_column_changed Or (ll_index = ll_upperbound) And UpperBound(in_pivot_table_column[]) > 0 Then
			//----------------------------------------------------------------------------------------------------------------------------------
			// Pull the data into an array of column information
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case in_pivot_table_column[1].Datatype
				Case 'string'
					istr_columndata[1].stringdata[ll_column_index] = lstr_columnstring[1].data[ll_index]
				Case 'datetime'
					istr_columndata[1].datetimedata[ll_column_index] = lstr_columndatetime[1].data[ll_index]
				
					//-----------------------------------------------------------------------------------------------------------------------------------
					// If we are filling in date gaps, we will need to do some special logic
					//-----------------------------------------------------------------------------------------------------------------------------------
					If Upper(Trim(in_pivot_table_column[1].FillInDateGaps)) = 'Y' And ll_index < ll_upperbound Then
						//-----------------------------------------------------------------------------------------------------------------------------------
						// Make sure we're not filling in for any special dates
						//-----------------------------------------------------------------------------------------------------------------------------------
						If Date(lstr_columndatetime[1].data[ll_index]) <> 2050-12-31 And Date(lstr_columndatetime[1].data[ll_index]) <> 1950-01-01 And Date(lstr_columndatetime[1].data[ll_index]) <> 1900-01-01 And Date(lstr_columndatetime[1].data[ll_index + 1]) <> 2050-12-31 And Date(lstr_columndatetime[1].data[ll_index + 1]) <> 1950-01-01 And Date(lstr_columndatetime[1].data[ll_index + 1]) <> 1900-01-01 Then
							Choose Case Upper(Trim(in_pivot_table_column[1].DateGapType))
								Case 'M'
									ldt_DateGapValue = lstr_columndatetime[1].data[ll_index]
									
									Do While DaysAfter(Date(ldt_DateGapValue), Date(lstr_columndatetime[1].data[ll_index + 1])) > 31
										ldt_DateGapValue = ln_date_manipulator.of_get_last_of_month(ldt_DateGapValue)
										ldt_DateGapValue = DateTime(RelativeDate(Date(ldt_DateGapValue), 1))
										
										ll_column_index = ll_column_index + 1
										
										istr_columndata[1].datetimedata[ll_column_index] = ldt_DateGapValue
									Loop
									
								Case 'D'
									ldt_DateGapValue = lstr_columndatetime[1].data[ll_index]
									
									Do While DaysAfter(Date(ldt_DateGapValue), Date(lstr_columndatetime[1].data[ll_index + 1])) > 1
										ldt_DateGapValue = DateTime(RelativeDate(Date(ldt_DateGapValue), 1))
										
										ll_column_index = ll_column_index + 1
										
										istr_columndata[1].datetimedata[ll_column_index] = ldt_DateGapValue
									Loop
							End Choose
						End If
					End If

				Case 'number'
					istr_columndata[1].numberdata[ll_column_index] = lstr_columnnumber[1].data[ll_index]
			End Choose

			ll_column_index = ll_column_index + 1
		End If

		lb_changed = False
		lb_column_changed = False
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are filling in date gaps, we will need to do some special logic
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If in_pivot_table_row[ll_index].Datatype <> 'datetime' Then Continue
	If Not Upper(Trim(in_pivot_table_row[ll_index].FillInDateGaps)) = 'Y' Then Continue

	ids_data_creation.SetFilter('Not IsNull(row' + String(ll_index) + ')')
	ids_data_creation.Filter()
	ids_data_creation.SetSort('row' + String(ll_index))
	ids_data_creation.Sort()
	
	in_datawindow_tools.of_get_array_from_column(ids_data_creation, 'row' + String(ll_index), ls_dummy[], ldt_row_fillingaps[], ldble_dummy[])

	ids_data_creation.SetFilter('')
	ids_data_creation.Filter()
	ids_data_creation.SetSort('')
	ids_data_creation.Sort()


	For ll_index2 = 1 To UpperBound(ldt_row_fillingaps[]) - 1
		ldt_FromDateGapValue = ldt_row_fillingaps[ll_index2]
		ldt_ToDateGapValue 	= ldt_row_fillingaps[ll_index2 + 1]

		If IsNull(ldt_ToDateGapValue) Then Exit

		Choose Case Upper(Trim(in_pivot_table_row[ll_index].DateGapType))
			Case 'M'
				Do While DaysAfter(Date(ldt_FromDateGapValue), Date(ldt_ToDateGapValue)) > 31
					ldt_FromDateGapValue = ln_date_manipulator.of_get_last_of_month(ldt_FromDateGapValue)
					ldt_FromDateGapValue = DateTime(RelativeDate(Date(ldt_FromDateGapValue), 1))
					ldt_row_fillingaps_new[UpperBound(ldt_row_fillingaps_new[]) + 1] = ldt_FromDateGapValue
				Loop
				
			Case 'D'
				Do While DaysAfter(Date(ldt_FromDateGapValue), Date(ldt_ToDateGapValue)) > 1
					ldt_FromDateGapValue = DateTime(RelativeDate(Date(ldt_FromDateGapValue), 1))
					ldt_row_fillingaps_new[UpperBound(ldt_row_fillingaps_new[]) + 1] = ldt_FromDateGapValue
				Loop
		End Choose
		
	Next
	
	For ll_index2 = 1 To UpperBound(ldt_row_fillingaps_new[])
		ll_row = ids_data_creation.InsertRow(0)
		ids_data_creation.SetItem(ll_row, 'row' + String(ll_index), ldt_row_fillingaps_new[ll_index2])
	Next
	
	Exit		
Next

If in_pivot_table_properties.ExcludeZeroRows Then
	ll_columncount = Long(ids_data_creation.Describe("Datawindow.Column.Count"))
	
	For ll_index = UpperBound(in_pivot_table_row[]) + 1 To ll_columncount
		ls_columnname = ids_data_creation.Describe('#' + String(ll_index) + '.Name')
		
		If Pos(Lower(Trim(ls_columnname)), 'weight') > 0 Then Continue
		
		Choose Case Lower(Trim(ls_columnname))
			Case 'sortcolumn', 'rowfocusindicator', 'selectrowindicator', 'expanded'
				Continue
		End Choose

		If Lower(Trim(ids_data_creation.Describe("#" + String(ll_index) + '.ColType'))) = 'number' Then
			ls_filterstring = ls_filterstring + ls_columnname + ' <> 0 Or '
		End If
	Next
	
	If Len(ls_filterstring) > 0 Then
		ls_filterstring = Left(ls_filterstring, Len(ls_filterstring) - 4)
		ids_data_creation.SetFilter(ls_filterstring)
		ids_data_creation.Filter()
		ids_data_creation.RowsDiscard(1, ids_data_creation.FilteredCount(), Filter!)
	End If
End If

Return ''

end function

public function string of_add_element (n_pivot_table_element an_pivot_table_element);/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_element()
//	Arguments:  as_row - The name of the row to add
//	Overview:   This will add the row to the result set
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------
// Local Objects
//---------------------------------------------------------------------------------
//n_string_functions ln_string_functions
String	ls_expression_name
String	ls_return
Long		ll_index
Long		ll_width

//---------------------------------------------------------------------------------
// Make sure the column exists and find it's column id for later use
//---------------------------------------------------------------------------------
If Not IsValid(ids_data_storage) Then
	Return 'Error:  The copy of the report data was not valid, could not add element'
End If

//---------------------------------------------------------------------------------
// Add the object to the array
//---------------------------------------------------------------------------------
Choose Case Lower(Trim(an_pivot_table_element.ElementType))
	Case 'row'
		in_pivot_table_row[UpperBound(in_pivot_table_row) + 1]					= an_pivot_table_element
		ll_index	= UpperBound(in_pivot_table_row[])
	Case 'column'
		in_pivot_table_column[UpperBound(in_pivot_table_column) + 1]			= an_pivot_table_element
		ll_index	= UpperBound(in_pivot_table_column[])
	Case 'aggregate'
		in_pivot_table_aggregate[UpperBound(in_pivot_table_aggregate) + 1]	= an_pivot_table_element
		ll_index	= UpperBound(in_pivot_table_aggregate[])

		If Not an_pivot_table_element.OverrideRowAggregateFunction Or Len(Trim(an_pivot_table_element.RowAggregateFunction)) = 0 Or IsNull(an_pivot_table_element.RowAggregateFunction) Then
			an_pivot_table_element.RowAggregateFunction	= an_pivot_table_element.AggregateFunction
		End If

		If Not an_pivot_table_element.OverrideColumnAggregateFunction Or Len(Trim(an_pivot_table_element.ColumnAggregateFunction)) = 0 Or IsNull(an_pivot_table_element.ColumnAggregateFunction) Then
			an_pivot_table_element.ColumnAggregateFunction	= an_pivot_table_element.AggregateFunction
		End If
	Case 'properties'
		If IsValid(in_pivot_table_properties) Then
			Destroy in_pivot_table_properties
		End If
		in_pivot_table_properties = an_pivot_table_element

		If in_pivot_table_properties.ShowHeader Then
			il_header_height = in_pivot_table_properties.HeaderHeight
		Else
			il_header_height = 70
		End If

		If in_pivot_table_properties.ShowFooter Then
			il_footerheight = in_pivot_table_properties.FooterHeight
		Else
			il_footerheight = 90
		End If
		
		Return ''
End Choose

If an_pivot_table_element.IsExpression Then
	an_pivot_table_element.Column	= "Expression" + an_pivot_table_element.ElementType + String(ll_index)
	ls_return = ids_data_storage.Modify("Destroy " + an_pivot_table_element.Column)

	If ib_AutoPivoting And IsValid(io_datasource) Then
		ls_return = io_datasource.Dynamic Modify("Destroy " + an_pivot_table_element.Column)
		in_datawindow_tools.of_set_expression(io_datasource, an_pivot_table_element.Column, an_pivot_table_element.Expression, False)
		
		If Not in_datawindow_tools.of_IsComputedField(io_datasource, an_pivot_table_element.Column) Then
			Return 'Error:  The ' + an_pivot_table_element.Description + ' column could not be created on the original datawindow'
		End If
		
		is_DestroyStringForComputedFieldsWhenAutoPivot = is_DestroyStringForComputedFieldsWhenAutoPivot + 'Destroy ' + an_pivot_table_element.Column + '~t'
	End If
	
	in_datawindow_tools.of_set_expression(ids_data_storage, an_pivot_table_element.Column, an_pivot_table_element.Expression, False)		
	
	If Not in_datawindow_tools.of_IsComputedField(ids_data_storage, an_pivot_table_element.Column) Then
		Return 'Error:  The ' + an_pivot_table_element.Description + ' column could not be created on the pivot datastore'
	End If
End If

//---------------------------------------------------------------------------------
// Get information about the column
//---------------------------------------------------------------------------------
an_pivot_table_element.ColumnID 		= in_datawindow_tools.of_get_columnid(ids_data_storage, an_pivot_table_element.Column)
an_pivot_table_element.EditStyle		= Lower(Trim(in_datawindow_tools.of_get_editstyle(ids_data_storage, an_pivot_table_element.Column)))

If Len(Trim(an_pivot_table_element.WeightedAverageColumn)) > 0 Then
	an_pivot_table_element.WeightedAverageColumnID 	= in_datawindow_tools.of_get_columnid(ids_data_storage, an_pivot_table_element.WeightedAverageColumn)
End If

//---------------------------------------------------------------------------------
// Make sure that the object exists on the datawindow
//---------------------------------------------------------------------------------
If IsNull(an_pivot_table_element.ColumnID) Or an_pivot_table_element.ColumnID <= 0 Then
	an_pivot_table_element.ColumnID = 0
	If Not an_pivot_table_element.IsExpression Then
		If Not in_datawindow_tools.of_IsComputedField(ids_data_storage, an_pivot_table_element.Column) Then
			Return 'Error:  The ' + an_pivot_table_element.Description + ' column is not valid'
		End If
	End If
End If

//---------------------------------------------------------------------------------
// Make sure that the object exists on the datawindow
//---------------------------------------------------------------------------------
If IsNull(an_pivot_table_element.WeightedAverageColumnID) Or an_pivot_table_element.WeightedAverageColumnID <= 0 And Len(Trim(an_pivot_table_element.WeightedAverageColumn)) > 0 Then
	an_pivot_table_element.WeightedAverageColumnID = 0
	If Not in_datawindow_tools.of_IsComputedField(ids_data_storage, an_pivot_table_element.WeightedAverageColumn) Then 
		Return 'Error:  The ' + an_pivot_table_element.Description + ' column is not valid'
	End If
End If

//---------------------------------------------------------------------------------
// If the width has not been overridden, set it
//---------------------------------------------------------------------------------
If an_pivot_table_element.ColumnWidthType <> 'C' Or an_pivot_table_element.Width <= 0 Or IsNull(an_pivot_table_element.Width) Then
	ll_width = an_pivot_table_element.Width
	
	If IsValid(io_datasource) And Not IsNull(io_datasource) Then
		an_pivot_table_element.Width			= Long(io_datasource.Dynamic Describe(Trim(Lower(an_pivot_table_element.Column)) + '.Width'))
	Else
		an_pivot_table_element.Width			= Long(ids_data_storage.Describe(Trim(Lower(an_pivot_table_element.Column)) + '.Width'))		
	End If
	
	If an_pivot_table_element.Width <= 0 Or IsNull(an_pivot_table_element.Width) Then
		an_pivot_table_element.Width = ll_width
	End If
End If

//---------------------------------------------------------------------------------
// If the format has not been overridden, set it
//---------------------------------------------------------------------------------
If an_pivot_table_element.FormatType = 'O' Then
	If IsValid(io_datasource) And Not IsNull(io_datasource) Then
		an_pivot_table_element.Format			= io_datasource.Dynamic Describe(Trim(Lower(an_pivot_table_element.Column)) + '.Format')
	Else
		an_pivot_table_element.Format			= ids_data_storage.Describe(Trim(Lower(an_pivot_table_element.Column)) + '.Format')
	End If
	
	If an_pivot_table_element.Format = '?' Or an_pivot_table_element.Format = '!' Then an_pivot_table_element.Format = '[General]'

	If Lower(Trim(an_pivot_table_element.AggregateFunction)) = 'divide' Then
		gn_globals.in_string_functions.of_replace_all(an_pivot_table_element.Format, '.', '.000')
	End If
End If

//---------------------------------------------------------------------------------
// If the decription has not been overridden, set it
//---------------------------------------------------------------------------------
If Len(an_pivot_table_element.Description) = 0 Or IsNull(an_pivot_table_element.Description) Then
	an_pivot_table_element.Description	= in_datawindow_tools.of_get_column_header(ids_data_storage, an_pivot_table_element.Column)
End If

//---------------------------------------------------------------------------------
// If we are graphing, check to see what the datatype is
//---------------------------------------------------------------------------------
If in_pivot_table_properties.IsGraph Then
	Choose Case an_pivot_table_element.EditStyle
		Case 'dddw', 'ddlb'
			an_pivot_table_element.Datatype	= 'lookupdisplay'
		Case Else
			an_pivot_table_element.Datatype	= This.of_get_coltype(an_pivot_table_element.Column)
	End Choose
Else
	an_pivot_table_element.Datatype	= This.of_get_coltype(an_pivot_table_element.Column)
End If

Return ''
end function

public function string of_build_gui_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_gui_datawindow()
//	Overview:   This will build the GUI for the datawindow
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long 		ll_ending_x_position_of_last_object
Long		ll_CountOfNonForceSingleColumn
Long		ll_current_row_level
String 	ls_datawindow_syntax
String 	ls_error_create
String	ls_empty[]
String	ls_title
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset object counts
//-----------------------------------------------------------------------------------------------------------------------------------
il_line_count_header							= 0
il_line_count_detail							= 0
il_line_count_footer							= 0
il_bitmap_count								= 0
il_computed_field_count						= 0
il_additional_header_height 				= 0
il_grouping_additional_trailer_height	= 0
il_additional_footer_height				= 0
il_additional_detail_height				= 0
ll_ending_x_position_of_last_object		= il_left_margin
ib_we_have_stacked_headers					= False
is_special_expression_objects[]			= ls_empty[]
is_special_expression[]						= ls_empty[]
is_grand_total_line							= ''
	
	

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine if we will have stacked headers
//-----------------------------------------------------------------------------------------------------------------------------------
ll_CountOfNonForceSingleColumn = 0

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If in_pivot_table_aggregate[ll_index].ForceSingleColumn Then Continue
	ll_CountOfNonForceSingleColumn = ll_CountOfNonForceSingleColumn + 1
Next

ib_we_have_stacked_headers = ll_CountOfNonForceSingleColumn > 1 And UpperBound(in_pivot_table_column[]) > 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine how much additional header height we will need
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_we_have_stacked_headers Then
	il_additional_header_height = 60
End If

ll_current_row_level = 0
For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	ll_current_row_level = Max(ll_current_row_level, in_pivot_table_aggregate[ll_index].PivotTableRowID)
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Determine if we need additional detail height and group footer height
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_current_row_level > 1 Then
	il_additional_detail_height 				= 60 * (ll_current_row_level - 1) + (5 * ll_current_row_level)
	il_additional_footer_height 				= 60 * (ll_current_row_level - 1) + (5 * ll_current_row_level)
	il_grouping_additional_trailer_height	= 60 * (ll_current_row_level - 1) + (5 * ll_current_row_level)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the report title and footer
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_we_are_applying_a_view Or in_pivot_table_properties.TitleType = 'R' Then
	//---------------------------------------------------------------------------------
	// If the decription has not been overridden, set it
	//---------------------------------------------------------------------------------
	Choose Case in_pivot_table_properties.TitleType
		Case 'R', 'O'
			If IsValid(ids_data_storage) Then
				If IsNumber(ids_data_storage.Describe("report_title.X")) Then
					ls_title = ids_data_storage.Describe("report_title.Text")
					If Left(ls_title, 1) = '"' And Right(ls_title, 1) = '"' And Pos(ls_title, '~t') > 0 Then
						If (Left(ls_title, 1) = '"' And Right(ls_title, 1) = '"') Then
							ls_title = Mid(ls_title, 2, Len(ls_title) - 2)
						End If
						If Pos(ls_title, '~t') > 0 Then
							ls_title = Mid(ls_title, Pos(ls_title, '~t') + 1)
						End If
						gn_globals.in_string_functions.of_replace_all(ls_title, "'", "~~~'")
						ls_title = ids_data_storage.Describe("Evaluate('" + ls_title + "', 1)")
					End If
					gn_globals.in_string_functions.of_replace_all(ls_title, '"', '~"')
					in_pivot_table_properties.Description = ls_title
				ElseIf IsValid(iu_original_search) Then
					in_pivot_table_properties.Description = iu_original_search.Text
				ElseIf IsValid(iu_search) Then
					in_pivot_table_properties.Description = iu_search.Text
				End If
			End If
	End Choose
End If

If in_pivot_table_properties.ShowFooter Then
	This.of_build_statictext('report_footer', 'Created by CustomerFocus on ' + String(Today(), 'mmmm d, yyyy h:mm am/pm'), 'footer', il_left_margin, il_footerheight - 92 + il_additional_footer_height, 60, 2000, 0, -8, 700)
End If

If in_pivot_table_properties.ShowHeader And in_pivot_table_properties.ShowBitmap Then
	This.of_build_bitmap(in_pivot_table_properties.BitmapFileName, 'header', il_left_margin + in_pivot_table_properties.BitmapX, in_pivot_table_properties.BitmapY, in_pivot_table_properties.BitmapWidth, in_pivot_table_properties.BitmapHeight)
End If

If in_pivot_table_properties.ShowHeader And in_pivot_table_properties.TitleType <> 'N' Then
	If in_pivot_table_properties.ShowBitmap Then
		This.of_build_statictext('report_title', in_pivot_table_properties.Description, 'header', il_left_margin + 25 + in_pivot_table_properties.BitmapX + PixelsToUnits(in_pivot_table_properties.BitmapWidth, XPixelsToUnits!), 27, 110, 2500, 0, in_pivot_table_properties.FontSize, 700)
	Else
		This.of_build_statictext('report_title', in_pivot_table_properties.Description, 'header', il_left_margin, 27, 110, 2500, 0, in_pivot_table_properties.FontSize, 700)		
	End If
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Build the row objects
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_build_gui_datawindow_row(ll_ending_x_position_of_last_object)

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the column objects
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_build_gui_datawindow_column(ll_ending_x_position_of_last_object)

//----------------------------------------------------------------------------------------------------------------------------------
// Build lines for the header and summary band
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_build_line('footer', il_left_margin, ll_ending_x_position_of_last_object, 5, True)

If in_pivot_table_properties.ShowRowTotals Then
	This.of_build_line('footer', il_left_margin, ll_ending_x_position_of_last_object, 62 + il_additional_footer_height, True)
	This.of_build_line('footer', il_left_margin, ll_ending_x_position_of_last_object, 70 + il_additional_footer_height, True)
End If

This.of_build_line('header', il_left_margin, ll_ending_x_position_of_last_object, il_header_height - 7 + il_additional_header_height, True)

//----------------------------------------------------------------------------------------------------------------------------------
// Build lines for all the group headers
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To il_number_of_groups
	This.of_build_line('header.' + String(ll_index), il_left_margin + ((ll_index - 1) * il_row_indention), ll_ending_x_position_of_last_object, 50, True)
	
	If in_pivot_table_properties.ShowRowTotals Then
		This.of_build_line('trailer.' + String(ll_index), il_left_margin + ((ll_index - 1) * il_row_indention), ll_ending_x_position_of_last_object, 55 + il_grouping_additional_trailer_height, True)
		This.of_build_line('trailer.' + String(ll_index), il_left_margin + ((ll_index - 1) * il_row_indention), ll_ending_x_position_of_last_object, 0, True)
	End If
Next

If il_additional_detail_height > 60 Then
	This.of_build_line('detail', il_left_margin, ll_ending_x_position_of_last_object, il_detailheight + il_additional_detail_height - 5, True)
End If


//----------------------------------------------------------------------------------------------------------------------------------
// Create the complete syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_datawindow_syntax = is_complete_syntax + '~r~n' + is_gui_groupings + is_gui_computed_fields + is_gui_columns + is_gui_lines + is_gui_bitmaps + is_gui_statictext + is_gui_suppressrepeatingvalues

//----------------------------------------------------------------------------------------------------------------------------------
// Create the gui datawindow and copy the data to there
//-----------------------------------------------------------------------------------------------------------------------------------
ids_grid_creation.Create(ls_datawindow_syntax, ls_error_create)
If Len(ls_error_create) > 0 Then
	Return  'Error:  Could not create pivot table datawindow (' + ls_error_create + ')'
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Apply all the modifies that need to happen to the gui
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_build_gui_datawindow_modifies()

//----------------------------------------------------------------------------------------------------------------------------------
// Copy the data to the destination datastore
//-----------------------------------------------------------------------------------------------------------------------------------
ids_data_creation.RowsCopy(1, ids_data_creation.RowCount(), Primary!, ids_grid_creation, 1, Primary!)
ids_data_creation.DataObject = ''

Return ''
end function

public function string of_build_gui_datawindow_column (ref long al_ending_x_position_of_last_object);/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_gui_datawindow_column()
//	Overview:   This will build the GUI for the datawindow
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_move_next_column = True
Boolean	lb_ThisIsFirstColumnOnRow	= True
Boolean	lb_ThisIsLastColumnOnRow	= True
Boolean	lb_showrowtotals
Long		ll_index
Long		ll_index2
Long		ll_index3
Long		ll_spacing
Long		ll_rowid
Long		ll_count[]
Long		ll_column_group_header_width
Long		ll_y_position
Long		ll_aggregatewidth
Long		ll_translated_column_number
Long		ll_order
Long		ll_column_group_header_x
Long		ll_aggregate_header_alignment
Long		ll_empty[]
Long		ll_ColumnsToIncludeInColumnTotalsAll
Long		ll_height
Long		ll_y
Long		i
String	ls_aggregate_datatype
String	ls_column_aggregate_function
String	ls_aggregateformat
String	ls_columnname
String	ls_headertext
String	ls_return
String	ls_expression
String	ls_total_computed_field_for_all[]
String	ls_total_computed_field[]
String	ls_column_group_first_column
String	ls_column_group_last_column
String	ls_aggregate_function

ll_aggregate_header_alignment		= il_alignment

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the alignment of the group headers
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_we_have_stacked_headers Then
	ll_aggregate_header_alignment = 2
End If

il_column_widths[] = ll_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the width of each column
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If UpperBound(il_column_widths[]) < in_pivot_table_aggregate[ll_index].PivotTableColumnID Then
		SetNull(il_column_widths[in_pivot_table_aggregate[ll_index].PivotTableColumnID])
	ElseIf il_column_widths[in_pivot_table_aggregate[ll_index].PivotTableColumnID] = 0 Then
		SetNull(il_column_widths[in_pivot_table_aggregate[ll_index].PivotTableColumnID])
	End If
	
	If Not IsNull(il_column_widths[in_pivot_table_aggregate[ll_index].PivotTableColumnID]) Then Continue
	
	il_column_widths[in_pivot_table_aggregate[ll_index].PivotTableColumnID] = in_pivot_table_aggregate[ll_index].Width
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If there are no aggregates or there are no columns, account for it here
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(il_column_widths[]) = 0 Then
	If UpperBound(in_pivot_table_column[]) > 0 Then
		il_column_widths[1] = in_pivot_table_column[1].Width
	Else
		il_column_widths[1] = il_column_width
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and create columns
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To il_number_of_columns
	ll_column_group_header_width = 0
	
	If ib_we_have_stacked_headers Then
		al_ending_x_position_of_last_object = al_ending_x_position_of_last_object + 2 * il_column_spacing
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// Default the spacing to column spacing
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_spacing = il_column_spacing
		
	For ll_index2 = 1 To Max(UpperBound(in_pivot_table_aggregate[]), 1)
		//----------------------------------------------------------------------------------------------------------------------------------
		// If it's force single column, then continue
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(in_pivot_table_aggregate[]) > 0 Then
			If in_pivot_table_aggregate[ll_index2].ForceSingleColumn And ll_index > 1 Then Continue
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Default the format as general
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_aggregateformat 	= '[general]'
		ll_y_position			= 5
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Determine the width, because we want to make sure there is room to see the headers
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(in_pivot_table_aggregate[]) > 0 Then
			If Len(Trim(in_pivot_table_aggregate[ll_index2].PivotTableColumnName)) = 0 Then
				ll_aggregatewidth = in_pivot_table_aggregate[ll_index2].Width
			Else
				ll_aggregatewidth = il_column_widths[in_pivot_table_aggregate[ll_index2].PivotTableColumnID]
			End If
		Else
			ll_aggregatewidth = il_column_widths[1]
		End If

		//----------------------------------------------------------------------------------------------------------------------------------
		// Determine the column name
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_columnname = 'column' + String(ll_index) + '_' + String(ll_index2)
		
		ll_translated_column_number = ll_index
		
		If UpperBound(istr_columndata[]) > 0 Then
			For ll_order = 1 To UpperBound(istr_columndata[1].order[])
				If istr_columndata[1].order[ll_order] = ll_index Then
					ll_translated_column_number = ll_order
					Exit
				End If
			Next
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Determine the column header text
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(istr_columndata[1].display) = 0 Then
			ls_headertext = ''
		Else
			ls_headertext = istr_columndata[1].display[ll_translated_column_number]
		End If

		//----------------------------------------------------------------------------------------------------------------------------------
		// This will allow the user to not pick an aggregate.  It will count as the aggregate automatically
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(in_pivot_table_aggregate[]) > 0 Then
			ll_y_position = (5 * in_pivot_table_aggregate[ll_index2].PivotTableRowID) + ((in_pivot_table_aggregate[ll_index2].PivotTableRowID - 1) * il_detailheight)
			If Lower(Trim(in_pivot_table_aggregate[ll_index2].AggregateFunction)) <> 'count' Then
				ls_aggregateformat = in_pivot_table_aggregate[ll_index2].Format
			End If

			//----------------------------------------------------------------------------------------------------------------------------------
			// 
			//-----------------------------------------------------------------------------------------------------------------------------------
			If in_pivot_table_aggregate[ll_index2].ForceSingleColumn Then
				If in_pivot_table_aggregate[ll_index2].PivotTableColumnName <> '' Then
					ls_headertext = Trim(in_pivot_table_aggregate[ll_index2].PivotTableColumnName)
				Else
					ls_headertext = in_pivot_table_aggregate[ll_index2].Description
				End If

				ls_columnname = 'aggregate' + String(ll_index2)
			Else
				If ib_we_have_stacked_headers Then
					ll_spacing = il_aggregate_spacing
					
					If ll_index2 = 1 Then
						ll_column_group_header_x = al_ending_x_position_of_last_object + ll_spacing
						ls_column_group_first_column	= ls_columnname
					Else
						If in_pivot_table_aggregate[ll_index2 - 1].ForceSingleColumn Then
							ll_column_group_header_x 		= al_ending_x_position_of_last_object + ll_spacing
							ls_column_group_first_column	= ls_columnname
						End If
					End If
					
					If lb_move_next_column Then
						ls_column_group_last_column	= ls_columnname
						ll_column_group_header_width = ll_column_group_header_width + ll_aggregatewidth + ll_spacing
					End If

					//----------------------------------------------------------------------------------------------------------------------------------
					// Create a column header above the others
					//----------------------------------------------------------------------------------------------------------------------------------
					If ll_index2 = UpperBound(in_pivot_table_aggregate[]) Then
						ll_y			= il_header_height - 60/**/
						ll_height 	= 52

						If in_pivot_table_properties.ModifyColumnHeaderHeight Then
							ll_y 				=  ll_y - (in_pivot_table_properties.ColumnHeaderHeight - ll_height)
							ll_height		= in_pivot_table_properties.ColumnHeaderHeight
						End If

						This.of_build_statictext(ls_columnname + '_srt_header', ls_headertext, 'header', ll_column_group_header_x, ll_y, ll_height, ll_column_group_header_width - ll_spacing, ll_aggregate_header_alignment, -8, 700)

						ls_return = This.of_build_line('header', ll_column_group_header_x - ll_spacing, ll_column_group_header_x - ll_spacing + ll_column_group_header_width, il_header_height - 8, False)
						This.of_add_expression(ls_return, 'X1', 'Long(Describe("' + ls_column_group_first_column + '.X"))')
						This.of_add_expression(ls_return, 'X2', 'Long(Describe("' + ls_column_group_last_column + '.X")) + Long(Describe("' + ls_column_group_last_column + '.Width"))')
						This.of_add_expression(ls_columnname + '_srt_header', 'X', 'Long(Describe("' + ls_column_group_first_column + '.X"))')
						This.of_add_expression(ls_columnname + '_srt_header', 'Width', 'Long(Describe("' + ls_column_group_last_column + '.X")) + Long(Describe("' + ls_column_group_last_column + '.Width")) - Long(Describe("' + ls_column_group_first_column + '.X"))')
					End If

					If in_pivot_table_aggregate[ll_index2].PivotTableColumnName <> '' Then
						ls_headertext = Trim(in_pivot_table_aggregate[ll_index2].PivotTableColumnName)
					Else
						ls_headertext = in_pivot_table_aggregate[ll_index2].Description
					End If
					
					//----------------------------------------------------------------------------------------------------------------------------------
					// Determine the spacing between the aggregates or the different columns
					//-----------------------------------------------------------------------------------------------------------------------------------
				Else
					ll_spacing = il_column_spacing
					
					If UpperBound(in_pivot_table_column[]) = 0 Then
						If in_pivot_table_aggregate[ll_index2].PivotTableColumnName <> '' Then
							ls_headertext = Trim(in_pivot_table_aggregate[ll_index2].PivotTableColumnName)
						Else
							ls_headertext = in_pivot_table_aggregate[ll_index2].Description
						End If
					End If
				End If
			End If
		Else
			If UpperBound(istr_columndata[1].display) = 0 Then
				ls_headertext	= 'Count'
			End If
		End If

		//----------------------------------------------------------------------------------------------------------------------------------
		// Build the static text for the column header
		//-----------------------------------------------------------------------------------------------------------------------------------
		If lb_move_next_column Then
			/**/ll_y	= il_header_height - 60 + il_additional_header_height
			ll_height 		= 52

			If UpperBound(in_pivot_table_aggregate[]) > 0 Then
				If Not ib_we_have_stacked_headers And in_pivot_table_properties.ModifyColumnHeaderHeight And Not in_pivot_table_aggregate[ll_index2].ForceSingleColumn Then
					ll_y 	=  ll_y - (in_pivot_table_properties.ColumnHeaderHeight - ll_height)
					ll_height		= in_pivot_table_properties.ColumnHeaderHeight
				End If
				
				If ib_we_have_stacked_headers And Not in_pivot_table_properties.ShowColumnLabels And Not in_pivot_table_aggregate[ll_index2].ForceSingleColumn Then
					ls_headertext = ''
				End If
			End If
			
			This.of_build_statictext(ls_columnname + '_srt', ls_headertext, 'header', al_ending_x_position_of_last_object + ll_spacing, ll_y, ll_height, ll_aggregatewidth, ll_aggregate_header_alignment, -8, 700)				
			/**/
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Build the column
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_build_column(ls_columnname, 'detail', al_ending_x_position_of_last_object + ll_spacing, ll_y_position, ll_aggregatewidth, ls_aggregateformat)
		is_rightmost_object = ls_columnname
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// This will allow the user to not pick an aggregate and it will count automatically
		//-----------------------------------------------------------------------------------------------------------------------------------
		If UpperBound(in_pivot_table_aggregate[]) > 0 Then/**/
			ls_aggregate_datatype 			= in_pivot_table_aggregate[ll_index2].Datatype
			lb_showrowtotals 					= in_pivot_table_aggregate[ll_index2].ShowRowTotals And in_pivot_table_properties.ShowRowTotals And (in_pivot_table_aggregate[ll_index2].Datatype = 'number' Or in_pivot_table_aggregate[ll_index2].AggregateFunction = 'count')
			ls_aggregate_function			= in_pivot_table_aggregate[ll_index2].RowAggregateFunction
			ls_column_aggregate_function	= in_pivot_table_aggregate[ll_index2].ColumnAggregateFunction
			If ls_aggregate_function 	= 'count' Then
				ls_aggregate_function 	= 'sum'
				ls_aggregate_datatype	= 'number'
			End If
		Else
			ls_aggregate_datatype 			= 'number'
			lb_showrowtotals 					= in_pivot_table_properties.ShowRowTotals
			ls_aggregate_function			= 'sum'
			ls_column_aggregate_function	= 'sum'
		End If/**/

		If lb_showrowtotals  Then
			//----------------------------------------------------------------------------------------------------------------------------------
			// Create the computed field expression for the end of the column and maintain the expression for the total
			//-----------------------------------------------------------------------------------------------------------------------------------
			Choose Case Lower(Trim(ls_aggregate_function))
				Case 'weightedaverage'
					ls_expression = 'sum(' + ls_columnname + ' * ' + 'weight' + ls_columnname + ' for all) / sum(weight' + ls_columnname + ' for all)'
				Case 'divide'
					ls_expression = 'sum(weight2' + ls_columnname + ' for all) / sum(weight' + ls_columnname + ' for all)'
				Case 'avg', 'average'
					ls_expression = 'avg(' +  ls_columnname + ' for all)'
				Case 'count'
					ls_expression = 'sum(' +  ls_columnname + ' for all)'
				Case Else
					ls_expression = ls_aggregate_function + '(' +  ls_columnname + ' for all)'
			End Choose
			
			This.of_build_computed_field(ls_expression, 'footer', al_ending_x_position_of_last_object  + ll_spacing, ll_y_position, ll_aggregatewidth, ls_aggregateformat, 1, ls_columnname + '_rowtotal')

			For ll_index3 = 1 To il_number_of_groups
				ls_expression = ls_aggregate_function + '(' + ls_columnname + ' for group ' + String(ll_index3) + ')'

				If UpperBound(in_pivot_table_aggregate[]) > 0 Then
					Choose Case Lower(Trim(ls_aggregate_function))
						Case 'weightedaverage'
							ls_expression = 'sum(' + ls_columnname + ' * ' + 'weight' + ls_columnname + ' for group ' + String(ll_index3) + ') / sum(weight' + ls_columnname + ' for group ' + String(ll_index3) + ')'
						Case 'divide'
							ls_expression = 'sum(weight2' + ls_columnname + ' for group ' + String(ll_index3) + ') / sum(weight' + ls_columnname + ' for group ' + String(ll_index3) + ')'
						Case 'avg', 'average'
							ls_expression = 'avg(' +  ls_columnname + ' for group ' + String(ll_index3) + ')'
					End Choose
				End If
				
				This.of_build_computed_field(ls_expression, 'trailer.' + String(ll_index3), al_ending_x_position_of_last_object  + ll_spacing, ll_y_position - 5, ll_aggregatewidth, ls_aggregateformat, 1, ls_columnname + '_rowtotal_' + String(ll_index3))
			Next
		End If

		lb_move_next_column = True
		
		If UpperBound(in_pivot_table_aggregate[]) > 1 Then
			If ll_index2 < UpperBound(in_pivot_table_aggregate[]) Then
				If in_pivot_table_aggregate[ll_index2].PivotTableColumnName = in_pivot_table_aggregate[ll_index2 + 1].PivotTableColumnName And in_pivot_table_aggregate[ll_index2].PivotTableColumnID = in_pivot_table_aggregate[ll_index2 + 1].PivotTableColumnID And in_pivot_table_aggregate[ll_index2].PivotTableColumnName <> '' Then
					lb_move_next_column = False
				End If
			End If
		End If

		If lb_move_next_column Then
			If ll_index2 = UpperBound(in_pivot_table_aggregate[]) Then
				ll_spacing = il_column_spacing
			Else
				If UpperBound(in_pivot_table_aggregate[]) > 0 Then
					If in_pivot_table_aggregate[ll_index2].ForceSingleColumn Then
						ll_spacing = il_column_spacing
					End If
				End If
			End If

			al_ending_x_position_of_last_object = al_ending_x_position_of_last_object + ll_aggregatewidth + ll_spacing
		End If

		Choose Case ls_aggregate_datatype/**/
			Case 'number'
				//----------------------------------------------------------------------------------------------------------------------------------
				// Use different operaters based on what aggregation method was picked for adding aggregates together
				//-----------------------------------------------------------------------------------------------------------------------------------
				Choose Case Lower(Trim(ls_column_aggregate_function))
					Case 'average', 'avg'
						If ll_index = il_number_of_columns Then
							ls_total_computed_field[ll_index2] = '(' + ls_total_computed_field[ll_index2] + ls_columnname + ' ) / ' + String(il_number_of_columns)
						Else
							ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + ls_columnname + ' + '
						End If
					Case 'difference'
						If ll_index = il_number_of_columns Then
							ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + ls_columnname + '/**/'
						Else
							ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + ls_columnname + '/**/ - '
						End If
					Case 'min'
						If ll_index = 1 Then
							ls_total_computed_field[ll_index2] = ls_columnname
						Else
							ls_total_computed_field[ll_index2] = 'If(' + ls_columnname + ' <= ' + ls_total_computed_field[ll_index2] + ',' + ls_columnname + ',' + ls_total_computed_field[ll_index2] + ')'
						End If
					Case 'max'
						If ll_index = 1 Then
							ls_total_computed_field[ll_index2] = ls_columnname
						Else			
							ls_total_computed_field[ll_index2] = 'If(' + ls_columnname + ' >= ' + ls_total_computed_field[ll_index2] + ',' + ls_columnname + ',' + ls_total_computed_field[ll_index2] + ')'
						End If
					Case 'weightedaverage'
						If ll_index = il_number_of_columns Then
							ls_total_computed_field[ll_index2] = ''
							
							For i = 1 To il_number_of_columns
								ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + 'column' + String(i) + '_' + String(ll_index2) + ' * ' + 'weightcolumn' + String(i) + '_' + String(ll_index2) + ' + '
							Next
							
							ls_total_computed_field[ll_index2] = '(' + Left(ls_total_computed_field[ll_index2], Len(ls_total_computed_field[ll_index2]) - 3) + ') / ('
							
							For i = 1 To il_number_of_columns
								ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + 'weightcolumn' + String(i) + '_' + String(ll_index2) + ' + '
							Next

							ls_total_computed_field[ll_index2] = Left(ls_total_computed_field[ll_index2], Len(ls_total_computed_field[ll_index2]) - 3) + ')'
						End If
					Case 'divide'
						If ll_index = il_number_of_columns Then
							ls_total_computed_field[ll_index2] = ''
							
							For i = 1 To il_number_of_columns
								ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + 'weight2column' + String(i) + '_' + String(ll_index2) + ' + '
							Next
							
							ls_total_computed_field[ll_index2] = '(' + Left(ls_total_computed_field[ll_index2], Len(ls_total_computed_field[ll_index2]) - 3) + ') / ('
							
							For i = 1 To il_number_of_columns
								ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + 'weightcolumn' + String(i) + '_' + String(ll_index2) + ' + '
							Next

							ls_total_computed_field[ll_index2] = Left(ls_total_computed_field[ll_index2], Len(ls_total_computed_field[ll_index2]) - 3) + ')'
						End If
					Case Else
						If ll_index = il_number_of_columns Then
							ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + ls_columnname
						Else
							ls_total_computed_field[ll_index2] = ls_total_computed_field[ll_index2] + ls_columnname + ' + ' 
						End If
				End Choose
		
				//----------------------------------------------------------------------------------------------------------------------------------
				// Use different operaters based on what aggregation method was picked for adding aggregates together
				//-----------------------------------------------------------------------------------------------------------------------------------
				If UpperBound(in_pivot_table_aggregate[]) > 1 And in_pivot_table_properties.ShowColumnTotalsMultiple Then
					If in_pivot_table_aggregate[ll_index2].ShowColumnTotalsMultiple Then
						ll_rowid = in_pivot_table_aggregate[ll_index2].PivotTableRowID
			
						lb_ThisIsFirstColumnOnRow	= True
						lb_ThisIsLastColumnOnRow	= True
			
						For ll_index3 = ll_index2 + 1 To UpperBound(in_pivot_table_aggregate[])
							/**/If in_pivot_table_aggregate[ll_index3].Datatype = 'number' And in_pivot_table_aggregate[ll_index3].ShowColumnTotalsMultiple And in_pivot_table_aggregate[ll_index3].PivotTableRowID = in_pivot_table_aggregate[ll_index2].PivotTableRowID Then
								lb_ThisIsLastColumnOnRow = False
								Exit
							End If
						Next
						
						For ll_index3 = ll_index2 - 1 To 1 Step -1
							/**/If in_pivot_table_aggregate[ll_index3].Datatype = 'number' And in_pivot_table_aggregate[ll_index3].ShowColumnTotalsMultiple And in_pivot_table_aggregate[ll_index3].PivotTableRowID = in_pivot_table_aggregate[ll_index2].PivotTableRowID Then
								lb_ThisIsFirstColumnOnRow = False
								Exit
							End If
						Next
			
						If UpperBound(ll_count[]) < ll_rowid Then ll_count[ll_rowid] = 0
						If UpperBound(ls_total_computed_field_for_all[]) < ll_rowid Then ls_total_computed_field_for_all[ll_rowid] = ''
						
						Choose Case Lower(Trim(in_pivot_table_properties.ColumnAllAggregateFunction))
							Case 'difference'
								If ll_index = 1 And lb_ThisIsFirstColumnOnRow Then
									ls_total_computed_field_for_all[ll_rowid] = ls_columnname
								Else
									If lb_ThisIsFirstColumnOnRow Then
										ls_total_computed_field_for_all[ll_rowid] = ls_total_computed_field_for_all[ll_rowid] + ' + ' + ls_columnname
									Else
										ls_total_computed_field_for_all[ll_rowid] = ls_total_computed_field_for_all[ll_rowid] + ' - ' + ls_columnname
									End If
								End If					
							Case 'average', 'avg'
								ll_count[ll_rowid] = ll_count[ll_rowid] + 1
								If (ll_index = il_number_of_columns Or in_pivot_table_aggregate[ll_index2].ForceSingleColumn) And lb_ThisIsLastColumnOnRow Then
									ls_total_computed_field_for_all[ll_rowid] = '  (' + ls_total_computed_field_for_all[ll_rowid] + ls_columnname + ' ) / ' + String(ll_count[ll_rowid])
								Else
									ls_total_computed_field_for_all[ll_rowid] = ls_total_computed_field_for_all[ll_rowid] + ls_columnname + ' + '
								End If
							Case 'min'
								If ll_index = 1 And lb_ThisIsFirstColumnOnRow Then
									ls_total_computed_field_for_all[ll_rowid] = ls_columnname
								Else
									ls_total_computed_field_for_all[ll_rowid] = 'If(' + ls_columnname + ' <= ' + ls_total_computed_field_for_all[ll_rowid] + ',' + ls_columnname + ',' + ls_total_computed_field_for_all[ll_rowid] + ')'
								End If
							Case 'max'
								If ll_index = 1 And lb_ThisIsFirstColumnOnRow Then
									ls_total_computed_field_for_all[ll_rowid] = ls_columnname
								Else
									ls_total_computed_field_for_all[ll_rowid] = 'If(' + ls_columnname + ' >= ' + ls_total_computed_field_for_all[ll_rowid] + ',' + ls_columnname + ',' + ls_total_computed_field_for_all[ll_rowid] + ')'
								End If
							Case 'divide'
								If ll_index = il_number_of_columns And (ll_index2 = UpperBound(in_pivot_table_aggregate[]) Or in_pivot_table_aggregate[ll_index2].ForceSingleColumn) Then
									For ll_index3 = 1 To UpperBound(ls_total_computed_field[])
										ls_total_computed_field_for_all[in_pivot_table_aggregate[ll_index3].PivotTableRowID] = ls_total_computed_field_for_all[in_pivot_table_aggregate[ll_index3].PivotTableRowID] + '(' + ls_total_computed_field[ll_index3] + ') / '
									Next
									
									For ll_index3 = 1 To UpperBound(ls_total_computed_field_for_all[])
										ls_total_computed_field_for_all[ll_index3] = Left(ls_total_computed_field_for_all[ll_index3], Len(ls_total_computed_field_for_all[ll_index3]) - 3)
									Next
								End If
							Case 'multiply'
								If ll_index = il_number_of_columns And (ll_index2 = UpperBound(in_pivot_table_aggregate[]) Or in_pivot_table_aggregate[ll_index2].ForceSingleColumn) Then
									For ll_index3 = 1 To UpperBound(ls_total_computed_field[])
										ls_total_computed_field_for_all[in_pivot_table_aggregate[ll_index3].PivotTableRowID] = ls_total_computed_field_for_all[in_pivot_table_aggregate[ll_index3].PivotTableRowID] + '(' + ls_total_computed_field[ll_index3] + ') * '
									Next
									
									For ll_index3 = 1 To UpperBound(ls_total_computed_field_for_all[])
										ls_total_computed_field_for_all[ll_index3] = Left(ls_total_computed_field_for_all[ll_index3], Len(ls_total_computed_field_for_all[ll_index3]) - 3)
									Next
								End If
							Case Else
								If ll_index = 1 And lb_ThisIsFirstColumnOnRow Then
									ls_total_computed_field_for_all[ll_rowid] = ls_columnname
								Else
									ls_total_computed_field_for_all[ll_rowid] = ls_total_computed_field_for_all[ll_rowid] + ' + ' + ls_columnname
								End If
						End Choose
					End If
				End If
		End Choose
	Next
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Create the total for each column
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.ShowColumnTotals And UpperBound(in_pivot_table_column[]) > 0 And il_number_of_columns > 1 Then
	This.of_build_gui_datawindow_column_totals(al_ending_x_position_of_last_object, ls_total_computed_field[])
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Create the column that will aggregate everything together
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.ShowColumnTotalsMultiple Then
	For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
		If in_pivot_table_aggregate[ll_index].DataType <> 'number' Then Continue
		If Not in_pivot_table_aggregate[ll_index].ShowColumnTotalsMultiple Then Continue
		
		ll_ColumnsToIncludeInColumnTotalsAll = ll_ColumnsToIncludeInColumnTotalsAll + 1
	Next

	If UpperBound(in_pivot_table_aggregate[]) > 1 And ll_ColumnsToIncludeInColumnTotalsAll > 1 Then
		of_build_gui_datawindow_column_totals_all(al_ending_x_position_of_last_object, ls_total_computed_field_for_all)
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Create the page computed field if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If in_pivot_table_properties.ShowPageNumber And in_pivot_table_properties.ShowFooter And al_ending_x_position_of_last_object > 1800 Then
	This.of_build_computed_field("'Page ' + page() + ' of ' + pageCount()", 'footer', Max(al_ending_x_position_of_last_object - 1000, 0), il_footerheight - 92 + il_additional_footer_height, Min(1000, al_ending_x_position_of_last_object), '[general]', 1, 'report_pagenumber')
	This.of_add_expression('report_pagenumber', 'X', 'Long(Describe("' + is_rightmost_object + '.X")) + Long(Describe("' + is_rightmost_object + '.Width")) - Long(Describe("report_pagenumber.Width"))')
End If

Return ''
end function

public function string of_get_data ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_data()
//	Overview:   This will get the data from the datastore into the structures
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-------------------------------------------------------
// Local Variables
//-------------------------------------------------------
Long ll_index, ll_rowcount, ll_stringcolumn = 1, ll_datetimecolumn = 2, ll_numbercolumn = 3
String	ls_string_array[], ls_empty[]
DateTime	ldt_datetime_array[], ldt_empty[]
Double	ldble_double_array[], ldble_empty[]
String ls_sort_string, ls_groups[]
Any lany_test

str_string_array 		lstr_emptystring[20]
str_datetime_array 	lstr_emptydatetime[20]
str_number_array 		lstr_emptynumber[20]
str_columndata 		lstr_columndata[20]


//-------------------------------------------------------
// Clear out all arrays of data
//-------------------------------------------------------
lstr_rowstring[] 			= lstr_emptystring[]
lstr_columnstring[]		= lstr_emptystring[]
lstr_aggregatestring[]	= lstr_emptystring[]

lstr_rowdatetime[] 			= lstr_emptydatetime[]
lstr_columndatetime[] 		= lstr_emptydatetime[]
lstr_aggregatedatetime[] 	= lstr_emptydatetime[]

lstr_rownumber[] 						= lstr_emptynumber[]
lstr_columnnumber[] 					= lstr_emptynumber[]
lstr_aggregatenumber[] 				= lstr_emptynumber[]
lstr_aggregateweightednumber[]	= lstr_emptynumber[]

istr_columndata[]			= lstr_columndata[]


//-------------------------------------------------------
// Sort the data according to the groups
//-------------------------------------------------------
ls_sort_string = ''

If in_pivot_table_properties.AlwaysUseGroupBySortingFirst Then
	in_datawindow_tools.of_get_groups(ids_data_storage, ls_groups[])
	
	For ll_index = 1 To UpperBound(ls_groups[])
		ls_sort_string = ls_sort_string + Trim(ls_groups[ll_index]) + ','
	Next
End If

ib_we_need_to_sort_the_column_headers = False

For ll_index = 1 To UpperBound(in_pivot_table_column[])
	ls_sort_string = ls_sort_string +  in_pivot_table_column[ll_index].Column + ' ' + in_pivot_table_column[ll_index].SortDirection + ','
	
	Choose Case in_pivot_table_column[ll_index].EditStyle
		Case 'dddw', 'ddlb'
			ib_we_need_to_sort_the_column_headers = True
	End Choose
Next

For ll_index = 1 To UpperBound(in_pivot_table_row[])
	ls_sort_string = ls_sort_string +  in_pivot_table_row[ll_index].Column + ' A,'
Next

//-------------------------------------------------------
// Cut off the extra comma
//-------------------------------------------------------
ls_sort_string = Left(ls_sort_string, Len(ls_sort_string) - 1)

//-------------------------------------------------------
// Sort the datastore
//-------------------------------------------------------
If Not in_datawindow_tools.of_sort(ids_data_storage, ls_sort_string) Then
	ids_data_storage.SetSort(ls_sort_string)
	ids_data_storage.Sort()
End If

//-------------------------------------------------------
// Put empty rows into the dummy datastore
//-------------------------------------------------------
ll_rowcount = ids_data_storage.RowCount()
ids_dummy_datastore.Reset()

//-------------------------------------------------------
// If there is no data Return
//-------------------------------------------------------
If ll_rowcount <= 0 Then
	Return ''
End If

//-------------------------------------------------------
// Insert the number of rows that will be necessary
//-------------------------------------------------------
in_datawindow_tools.of_insert_rows(ids_dummy_datastore, ll_rowcount)

//-------------------------------------------------------
// Loop through all the rows and get the data into it's
//   proper structure
//-------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_row)
	If in_datawindow_tools.of_IsComputedField(ids_data_storage, in_pivot_table_row[ll_index].Column) Then
		in_datawindow_tools.of_get_expression_as_array(ids_data_storage, in_pivot_table_row[ll_index].Column, ls_string_array[], ldt_datetime_array[], ldble_double_array[])
		
		Choose Case Lower(Trim(in_pivot_table_row[ll_index].Datatype))
			Case 'lookupdisplay', 'string'
				If UpperBound(ls_string_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_row[ll_index].Description + ' is invalid and cannot be evaluated'

				lstr_rowstring[ll_index].data = ls_string_array[]
				ls_string_array[]					= ls_empty[]
				in_pivot_table_row[ll_index].Datatype = 'string'
				
			Case 'datetime'
				If UpperBound(ldt_datetime_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_row[ll_index].Description + ' is invalid and cannot be evaluated'

				lstr_rowdatetime[ll_index].data 	= ldt_datetime_array[]
				ldt_datetime_array[]					= ldt_empty[]

			Case 'number'
				If UpperBound(ldble_double_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_row[ll_index].Description + ' is invalid and cannot be evaluated'

				lstr_rownumber[ll_index].data = ldble_double_array[]
				ldble_double_array[]				= ldble_empty[]
		End Choose
	Else
		Choose Case Lower(Trim(in_pivot_table_row[ll_index].Datatype))
			Case 'lookupdisplay'
				in_datawindow_tools.of_get_lookupdisplay(ids_data_storage, in_pivot_table_row[ll_index].Column, lstr_rowstring[ll_index].data)
				in_pivot_table_row[ll_index].Datatype = 'string'
				
				If UpperBound(lstr_rowstring[ll_index].data) = 0 Then Return 'Error:  ' + in_pivot_table_row[ll_index].Description + ' is invalid and cannot be evaluated'
			Case 'string'
				ids_dummy_datastore.object.data[1, ll_stringcolumn, ll_rowcount, ll_stringcolumn] = ids_data_storage.Object.Data[1, in_pivot_table_row[ll_index].ColumnID, ll_rowcount, in_pivot_table_row[ll_index].ColumnID]
				lstr_rowstring[ll_index].data = ids_dummy_datastore.object.stringcolumn.primary
			Case 'datetime'
				ids_dummy_datastore.object.data[1, ll_datetimecolumn, ll_rowcount, ll_datetimecolumn] = ids_data_storage.Object.Data[1, in_pivot_table_row[ll_index].ColumnID, ll_rowcount, in_pivot_table_row[ll_index].ColumnID]
				lstr_rowdatetime[ll_index].data = ids_dummy_datastore.object.datetimecolumn.primary
			Case 'number'
				ids_dummy_datastore.object.data[1, ll_numbercolumn, ll_rowcount, ll_numbercolumn] = ids_data_storage.Object.Data[1, in_pivot_table_row[ll_index].ColumnID, ll_rowcount, in_pivot_table_row[ll_index].ColumnID]
				lstr_rownumber[ll_index].data = ids_dummy_datastore.object.numbercolumn.primary
		End Choose
	End If
Next

//-------------------------------------------------------
// Loop through all the columns and get the data into it's
//   proper structure
//-------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_column)
	If in_datawindow_tools.of_IsComputedField(ids_data_storage, in_pivot_table_column[ll_index].Column) Then
		in_datawindow_tools.of_get_expression_as_array(ids_data_storage, in_pivot_table_column[ll_index].Column, ls_string_array[], ldt_datetime_array[], ldble_double_array[])
		
		Choose Case Lower(Trim(in_pivot_table_column[ll_index].Datatype))
			Case 'lookupdisplay', 'string'
				If UpperBound(ls_string_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_column[ll_index].Description + ' is invalid and cannot be evaluated'
					
				lstr_columnstring[ll_index].data 			= ls_string_array[]
				ls_string_array[]									= ls_empty[]
				in_pivot_table_column[ll_index].Datatype 	= 'string'
				
			Case 'datetime'
				If UpperBound(ldt_datetime_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_column[ll_index].Description + ' is invalid and cannot be evaluated'
			
				lstr_columndatetime[ll_index].data 			= ldt_datetime_array[]
				ldt_datetime_array[]								= ldt_empty[]

			Case 'number'
				If UpperBound(ldble_double_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_column[ll_index].Description + ' is invalid and cannot be evaluated'

				lstr_columnnumber[ll_index].data 			= ldble_double_array[]
				ldble_double_array[]								= ldble_empty[]
		End Choose
	Else
		Choose Case Lower(Trim(in_pivot_table_column[ll_index].Datatype))
			Case 'lookupdisplay'
				in_datawindow_tools.of_get_lookupdisplay(ids_data_storage, in_pivot_table_column[ll_index].Column, lstr_columnstring[ll_index].data)
				in_pivot_table_column[ll_index].Datatype = 'string'
				
				If UpperBound(lstr_columnstring[ll_index].data) = 0 Then Return 'Error:  ' + in_pivot_table_column[ll_index].Description + ' is invalid and cannot be evaluated'
			Case 'string'
				//-------------------------------------------------------
				// Pull the column into the dummy datastore, the pull the
				//   named column into the structure's array.  We have
				//   to do this because you can't take a numbered column
				//   directly to an array only a named column
				//-------------------------------------------------------
				ids_dummy_datastore.object.data[1, ll_stringcolumn, ll_rowcount, ll_stringcolumn] = ids_data_storage.Object.Data[1, in_pivot_table_column[ll_index].ColumnID, ll_rowcount, in_pivot_table_column[ll_index].ColumnID]
				lstr_columnstring[ll_index].data = ids_dummy_datastore.object.stringcolumn.primary
			Case 'datetime'
				ids_dummy_datastore.object.data[1, ll_datetimecolumn, ll_rowcount, ll_datetimecolumn] = ids_data_storage.Object.Data[1, in_pivot_table_column[ll_index].ColumnID, ll_rowcount, in_pivot_table_column[ll_index].ColumnID]
				lstr_columndatetime[ll_index].data = ids_dummy_datastore.object.datetimecolumn.primary
			Case 'number'
				ids_dummy_datastore.object.data[1, ll_numbercolumn, ll_rowcount, ll_numbercolumn] = ids_data_storage.Object.Data[1, in_pivot_table_column[ll_index].ColumnID, ll_rowcount, in_pivot_table_column[ll_index].ColumnID]
				lstr_columnnumber[ll_index].data = ids_dummy_datastore.object.numbercolumn.primary
		End Choose
	End If
Next


//-------------------------------------------------------
// Loop through all the aggregates and get the data into it's
//   proper structure
//-------------------------------------------------------
For ll_index = 1 To UpperBound(in_pivot_table_aggregate)
	If in_datawindow_tools.of_IsComputedField(ids_data_storage, in_pivot_table_aggregate[ll_index].Column) Then
		in_datawindow_tools.of_get_expression_as_array(ids_data_storage, in_pivot_table_aggregate[ll_index].Column, ls_string_array[], ldt_datetime_array[], ldble_double_array[])
		
		Choose Case Lower(Trim(in_pivot_table_aggregate[ll_index].Datatype))
			Case 'lookupdisplay', 'string'
				If UpperBound(ls_string_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_aggregate[ll_index].Description + ' is invalid and cannot be evaluated'

				lstr_aggregatestring[ll_index].data = ls_string_array[]
				ls_string_array[]					= ls_empty[]
				in_pivot_table_aggregate[ll_index].Datatype = 'string'
				
			Case 'datetime'
				If UpperBound(ldt_datetime_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_aggregate[ll_index].Description + ' is invalid and cannot be evaluated'

				lstr_aggregatedatetime[ll_index].data 	= ldt_datetime_array[]
				ldt_datetime_array[]							= ldt_empty[]

			Case 'number'
				If UpperBound(ldble_double_array[]) = 0 Then Return 'Error:  ' + in_pivot_table_aggregate[ll_index].Description + ' is invalid and cannot be evaluated'

				lstr_aggregatenumber[ll_index].data = ldble_double_array[]
				ldble_double_array[]				= ldble_empty[]
		End Choose
	Else
		Choose Case Lower(Trim(in_pivot_table_aggregate[ll_index].Datatype))
			Case 'lookupdisplay'
				in_datawindow_tools.of_get_lookupdisplay(ids_data_storage, in_pivot_table_aggregate[ll_index].Column, lstr_aggregatestring[ll_index].data)
				in_pivot_table_aggregate[ll_index].Datatype = 'string'

				If UpperBound(lstr_aggregatestring[ll_index].data) = 0 Then Return 'Error:  ' + in_pivot_table_aggregate[ll_index].Description + ' is invalid and cannot be evaluated'
			Case 'string'
				ids_dummy_datastore.object.data[1, ll_stringcolumn, ll_rowcount, ll_stringcolumn] = ids_data_storage.Object.Data[1, in_pivot_table_aggregate[ll_index].ColumnID, ll_rowcount, in_pivot_table_aggregate[ll_index].ColumnID]
				lstr_aggregatestring[ll_index].data = ids_dummy_datastore.object.stringcolumn.primary
			Case 'datetime'
				ids_dummy_datastore.object.data[1, ll_datetimecolumn, ll_rowcount, ll_datetimecolumn] = ids_data_storage.Object.Data[1, in_pivot_table_aggregate[ll_index].ColumnID, ll_rowcount, in_pivot_table_aggregate[ll_index].ColumnID]
				lstr_aggregatedatetime[ll_index].data = ids_dummy_datastore.object.datetimecolumn.primary
			Case 'number'
				ids_dummy_datastore.object.data[1, ll_numbercolumn, ll_rowcount, ll_numbercolumn] = ids_data_storage.Object.Data[1, in_pivot_table_aggregate[ll_index].ColumnID, ll_rowcount, in_pivot_table_aggregate[ll_index].ColumnID]
				lstr_aggregatenumber[ll_index].data = ids_dummy_datastore.object.numbercolumn.primary
		End Choose
	End If
	
	//--------------------------------------------------------------------------------------------------------------
	// If the datatype isn't a number, we can only use count.  We need to leave otherwise.
	//--------------------------------------------------------------------------------------------------------------
///**/	If Lower(Trim(in_pivot_table_aggregate[ll_index].AggregateFunction)) <> 'count' And Lower(Trim(in_pivot_table_aggregate[ll_index].Datatype)) <> 'number' Then
//		Return 'Error:  ' + in_pivot_table_aggregate[ll_index].Column + ' is an invalid datatype for the ' + in_pivot_table_aggregate[ll_index].AggregateFunction + ' function'
//	End If
	
	If Len(Trim(in_pivot_table_aggregate[ll_index].WeightedAverageColumn)) > 0 Then
		If in_datawindow_tools.of_IsComputedField(ids_data_storage, in_pivot_table_aggregate[ll_index].WeightedAverageColumn) Then
			in_datawindow_tools.of_get_expression_as_array(ids_data_storage, in_pivot_table_aggregate[ll_index].WeightedAverageColumn, ls_string_array[], ldt_datetime_array[], ldble_double_array[])
			If UpperBound(ldble_double_array[]) <= 0 Then Return 'Error:  ' + in_pivot_table_aggregate[ll_index].WeightedAverageColumn + ' is invalid and cannot be evaluated'

			lstr_aggregateweightednumber[ll_index].data = ldble_double_array[]
			ldble_double_array[]				= ldble_empty[]
		Else
			If in_pivot_table_aggregate[ll_index].WeightedAverageColumnID > 0 Then
				ids_dummy_datastore.object.data[1, ll_numbercolumn, ll_rowcount, ll_numbercolumn] = ids_data_storage.Object.Data[1, in_pivot_table_aggregate[ll_index].WeightedAverageColumnID, ll_rowcount, in_pivot_table_aggregate[ll_index].WeightedAverageColumnID]
				lstr_aggregateweightednumber[ll_index].data = ids_dummy_datastore.object.numbercolumn.primary
			End If
		End If
	End If
Next

Return ''
end function

public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	
//	History: 	
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_descriptions[]
Long 		ll_ids[]
Long		ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_destination) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a spacer since the menu has items already
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the views for this report
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_get_views(ll_ids[], ls_descriptions[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Add all the views
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_descriptions[])
	an_menu_dynamic.of_add_item(ls_descriptions[ll_index], 'pivot table view menu', String(ll_ids[ll_index]), This)
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a spacer and an item for Managing Pivot Table Views
//-----------------------------------------------------------------------------------------------------------------------------------
If Min(UpperBound(ll_ids[]), UpperBound(ls_descriptions[])) > 0 And Not ib_batchmode Then
	an_menu_dynamic.of_add_item('-', '', '', This)
	an_menu_dynamic.of_add_item('Manage Pivot Views...', 'manage pivot table views', '',  This)
	an_menu_dynamic.of_add_item('-', '', '', This)
End If

If Not ib_batchmode Then an_menu_dynamic.of_add_item('Export Current Pivot To File...', 'export view', '', This)
If Not ib_batchmode Then an_menu_dynamic.of_add_item('Import Pivot View From File...', 'import view', '', This)
If Not ib_batchmode Then an_menu_dynamic.of_add_item('-', '', '', This)
If Not ib_batchmode Then an_menu_dynamic.of_add_item('Save Pivot View...', 'save view', '', This)
If Not ib_batchmode Then an_menu_dynamic.of_add_item('Modify Pivot...', 'present gui', '', This)
end subroutine

public function string of_build_gui_datawindow_column_totals (ref long al_ending_x_position_of_last_object, string as_total_computed_field[]);/**/
//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_gui_datawindow_column_totals()
//	Overview:   This will build the GUI for the datawindow
//	Created by:	Blake Doerr
//	History: 	12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean	lb_move_next_column = True
Long		i
Long 		ll_index
Long 		ll_index2
Long		ll_temp
Long		ll_spacing
Long		ll_y_position = 5	
Long		ll_column_group_header_x
Long		ll_column_group_header_width
Long		ll_aggregate_header_alignment
Long		ll_aggregatewidth
Long		ll_y
String	ls_description
String	ls_aggregate_function
String 	ls_aggregateformat
String	ls_return
String	ls_column_group_first_column
String	ls_column_group_last_column
String	ls_total_computed_field[]/**/
String	ls_aggregate_function_group
n_pivot_table_element ln_pivot_table_aggregate[]/**/
//n_string_functions ln_string_functions
ll_aggregate_header_alignment		= il_alignment

If ib_we_have_stacked_headers Then
	ll_aggregate_header_alignment = 2
	al_ending_x_position_of_last_object = al_ending_x_position_of_last_object + 2 * il_column_spacing
End If

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])/**/
	If in_pivot_table_aggregate[ll_index].Datatype <> 'number' And in_pivot_table_aggregate[ll_index].AggregateFunction <> 'count' Then Continue
	If in_pivot_table_aggregate[ll_index].ForceSingleColumn Then Continue
	If Not in_pivot_table_aggregate[ll_index].ShowColumnTotals Then Continue
	ln_pivot_table_aggregate[UpperBound(ln_pivot_table_aggregate[]) + 1] = in_pivot_table_aggregate[ll_index]
	ls_total_computed_field[UpperBound(ls_total_computed_field[]) + 1]	= as_total_computed_field[ll_index]
Next/**/

/**/If UpperBound(ln_pivot_table_aggregate[]) = 0 And UpperBound(in_pivot_table_aggregate[]) > 0 Then Return ''

If UpperBound(in_pivot_table_aggregate[]) = 0 Then ls_total_computed_field[] = as_total_computed_field[]


//----------------------------------------------------------------------------------------------------------------------------------
// Create the total for each column
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Max(UpperBound(ln_pivot_table_aggregate[]), 1)
	//----------------------------------------------------------------------------------------------------------------------------------
	// Default the spacing to column spacing
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_spacing = il_column_spacing

	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the width, because we want to make sure there is room to see the headers
	//-----------------------------------------------------------------------------------------------------------------------------------
	If UpperBound(in_pivot_table_column[]) > 0 Then
		If UpperBound(ln_pivot_table_aggregate[]) > 0 Then
			ll_aggregatewidth = il_column_widths[ln_pivot_table_aggregate[ll_index].PivotTableColumnID]
		Else
			ll_aggregatewidth = il_column_widths[1]
		End If
	Else
		ll_aggregatewidth = il_column_widths[1]
	End If

	ll_aggregatewidth = Long(Double(ll_aggregatewidth) * 1.20)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// 
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_description = 'Total for '

	//----------------------------------------------------------------------------------------------------------------------------------
	// This will allow the user to not pick an aggregate.  It will count as the aggregate automatically
	//-----------------------------------------------------------------------------------------------------------------------------------
	If UpperBound(ln_pivot_table_aggregate[]) = 0 Then
		ls_aggregateformat = '[general]'
		ls_description			= 'Total Count'
	Else
		//----------------------------------------------------------------------------------------------------------------------------------
		// Calculate the y position
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_y_position = (5 * ln_pivot_table_aggregate[ll_index].PivotTableRowID) + ((ln_pivot_table_aggregate[ll_index].PivotTableRowID - 1) * il_detailheight)

		//----------------------------------------------------------------------------------------------------------------------------------
		// 
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Lower(Trim(ln_pivot_table_aggregate[ll_index].AggregateFunction)) <> 'count' Then
			ls_aggregateformat 	= ln_pivot_table_aggregate[ll_index].Format
		Else
			ls_aggregateformat 	= '[general]'
		End If
		
		If ib_we_have_stacked_headers Then
			//----------------------------------------------------------------------------------------------------------------------------------
			// Determine the spacing between the aggregates or the different columns
			//-----------------------------------------------------------------------------------------------------------------------------------
			ll_spacing = il_aggregate_spacing

			If ll_index = 1 Then
				ll_column_group_header_x = al_ending_x_position_of_last_object + ll_spacing
				ls_column_group_first_column	= 'total_column' + String(il_computed_field_count + 1)
			Else
				If ln_pivot_table_aggregate[ll_index - 1].ForceSingleColumn = True Then
					ll_column_group_header_x = al_ending_x_position_of_last_object + ll_spacing
					ls_column_group_first_column	= 'total_column' + String(il_computed_field_count + 1)
				End If
			End If
			
			If lb_move_next_column Then
				ls_column_group_last_column	= 'total_column' + String(il_computed_field_count + 1)
				ll_column_group_header_width = ll_column_group_header_width + ll_aggregatewidth + ll_spacing
			End If

			//----------------------------------------------------------------------------------------------------------------------------------
			// Create a column header above the others
			//----------------------------------------------------------------------------------------------------------------------------------
			If ll_index = UpperBound(ln_pivot_table_aggregate[]) Then
				If in_pivot_table_properties.ShowColumnTotalsMultiple Then
					ll_column_group_header_width = ll_column_group_header_width + ll_aggregatewidth + ll_spacing
				End If

				ll_y			= il_header_height - 60

				This.of_build_statictext('aggregatetotal_srt_header', 'Total', 'header', ll_column_group_header_x, ll_y, 52, ll_column_group_header_width - ll_spacing, ll_aggregate_header_alignment, -8, 700)

				is_grand_total_line = This.of_build_line('header', ll_column_group_header_x, ll_column_group_header_x + ll_column_group_header_width - ll_spacing, il_header_height - 8, False)
				This.of_add_expression(is_grand_total_line, 'X1', 'Long(Describe("' + ls_column_group_first_column + '.X"))')
				This.of_add_expression(is_grand_total_line, 'X2', 'Long(Describe("' + ls_column_group_last_column + '.X")) + Long(Describe("' + ls_column_group_last_column + '.Width"))')
				This.of_add_expression('aggregatetotal_srt_header', 'X', 'Long(Describe("' + ls_column_group_first_column + '.X"))')
				This.of_add_expression('aggregatetotal_srt_header', 'Width', 'Long(Describe("' + ls_column_group_last_column + '.X")) + Long(Describe("' + ls_column_group_last_column + '.Width")) - Long(Describe("' + ls_column_group_first_column + '.X"))')
			End If

			If ln_pivot_table_aggregate[ll_index].PivotTableColumnName <> '' Then
				ls_description = Trim(ln_pivot_table_aggregate[ll_index].PivotTableColumnName)
			Else
				ls_description = ln_pivot_table_aggregate[ll_index].Description
			End If
		Else
			If ln_pivot_table_aggregate[ll_index].PivotTableColumnName <> '' Then
				ls_description = Trim(ln_pivot_table_aggregate[ll_index].PivotTableColumnName)
			Else
				ls_description	= ls_description + ln_pivot_table_aggregate[ll_index].Description
			End If
		End If
	End If

	This.of_build_computed_field(ls_total_computed_field[ll_index], 'detail', 	al_ending_x_position_of_last_object  + ll_spacing, ll_y_position, ll_aggregatewidth, ls_aggregateformat, 1)
	is_rightmost_object = 'total_column' + String(il_computed_field_count)

	If lb_move_next_column Then
		ll_y	= il_header_height - 60 + il_additional_header_height

		If ib_we_have_stacked_headers And Not in_pivot_table_properties.ShowColumnLabels Then
			ls_description = ''
		End If

		This.of_build_statictext('total_column' + String(il_computed_field_count) + '_srt', ls_description, 'header', al_ending_x_position_of_last_object + ll_spacing, ll_y, 52, ll_aggregatewidth, ll_aggregate_header_alignment, -8, 700)
		/**/
	End If
	
	ll_temp = il_computed_field_count

	If in_pivot_table_properties.ShowRowTotals Then
		If UpperBound(ln_pivot_table_aggregate[]) > 0 Then
			If Not ln_pivot_table_aggregate[ll_index].ShowRowTotals Then
				ls_aggregate_function = '(None)'
			Else
				Choose Case ln_pivot_table_aggregate[ll_index].ColumnAggregateFunction
					Case 'weightedaverage', 'divide'
							For i = 1 To il_number_of_columns
								ls_aggregate_function = ls_aggregate_function + 'weightcolumn' + String(i) + '_' + String(ll_index) + ' + '
							Next
							
							ls_aggregate_function	= Left(ls_aggregate_function, Len(ls_aggregate_function) - 3)
							ls_aggregate_function	= 'Sum(' + ls_aggregate_function	+ ') * total_column' + String(ll_temp) + ' For All) / Sum(' + ls_aggregate_function + ' For All)'
					Case 'count'
						ls_aggregate_function = 'sum(total_column' + String(ll_temp) + ' For All)'
					Case 'difference'
						ls_aggregate_function = ls_total_computed_field[ll_index]
						gn_globals.in_string_functions.of_replace_all(ls_aggregate_function, '/**/', '_rowtotal')
					Case Else
						ls_aggregate_function = ln_pivot_table_aggregate[ll_index].ColumnAggregateFunction + '(total_column' + String(ll_temp) + ' For All)'
				End Choose
			End If
		Else
			ls_aggregate_function = 'sum(total_column' + String(ll_temp) + ' For All)'
		End If

		If Lower(Trim(ls_aggregate_function)) <> '(none)' Then
			//----------------------------------------------------------------------------------------------------------------------------------
			// Create computed fields for the grouping row total
			//-----------------------------------------------------------------------------------------------------------------------------------
			For ll_index2 = 1 To il_number_of_groups
				If ll_index2 <> UpperBound(in_pivot_table_row[]) Then
					ls_aggregate_function_group = ls_aggregate_function

					If UpperBound(ln_pivot_table_aggregate[]) >= ll_index Then
						Choose Case ln_pivot_table_aggregate[ll_index].ColumnAggregateFunction
							Case 'difference'
								gn_globals.in_string_functions.of_replace_all(ls_aggregate_function_group, '_rowtotal', '_rowtotal_' + String(ll_index2))
						End Choose
					End If

					gn_globals.in_string_functions.of_replace_all(ls_aggregate_function_group, 'For All', 'For Group ' + String(ll_index2))
					This.of_build_computed_field(ls_aggregate_function_group, 	'trailer.' + String(ll_index2), 	al_ending_x_position_of_last_object  + ll_spacing, ll_y_position - 5, ll_aggregatewidth, ls_aggregateformat, 1)
				End If
			Next
	
			This.of_build_computed_field(ls_aggregate_function, 'footer', al_ending_x_position_of_last_object + ll_spacing, ll_y_position, ll_aggregatewidth, ls_aggregateformat, 1)
		End If
	End If
	
	lb_move_next_column = True
	
	If UpperBound(ln_pivot_table_aggregate[]) > 1 Then
		If ll_index < UpperBound(ln_pivot_table_aggregate[]) Then
			If ln_pivot_table_aggregate[ll_index].PivotTableColumnName = ln_pivot_table_aggregate[ll_index + 1].PivotTableColumnName And ln_pivot_table_aggregate[ll_index].PivotTableColumnID = ln_pivot_table_aggregate[ll_index + 1].PivotTableColumnID And ln_pivot_table_aggregate[ll_index].PivotTableColumnName <> '' Then
				lb_move_next_column = False
			End If
		End If
	End If

	If lb_move_next_column Then
		al_ending_x_position_of_last_object = al_ending_x_position_of_last_object + ll_aggregatewidth + ll_spacing
	End If
Next

Return ''
end function

on n_pivot_table_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_pivot_table_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Create any objects
//	Created by: 
//	History:    
//-----------------------------------------------------------------------------------------------------------------------------------

in_datawindow_tools 	= Create n_datawindow_tools
ids_data_storage 		= Create Datastore
ids_dummy_datastore 	= Create datastore
ids_grid_creation		= Create Datastore
ids_data_creation		= Create Datastore
ixctn_transaction 	= SQLCA
This.of_create_dummy_datastore()
end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Destroy any objects
//	Created by: Blake Doerr
//	History:    12/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_return

Destroy ids_data_storage
Destroy ids_dummy_datastore
Destroy ids_grid_creation
Destroy ids_data_creation

If IsValid(in_navigation_options) Then
	Destroy in_navigation_options
End If
Destroy in_datawindow_tools

For ll_index = 1 To UpperBound(in_pivot_table_row[])
	If IsValid(in_pivot_table_row[ll_index]) Then Destroy in_pivot_table_row[ll_index]
Next

For ll_index = 1 To UpperBound(in_pivot_table_column[])
	If IsValid(in_pivot_table_column[ll_index]) Then Destroy in_pivot_table_column[ll_index]
Next

For ll_index = 1 To UpperBound(in_pivot_table_aggregate[])
	If IsValid(in_pivot_table_aggregate[ll_index]) Then Destroy in_pivot_table_aggregate[ll_index]
Next

If IsValid(in_pivot_table_properties) Then Destroy in_pivot_table_properties

//----------------------------------------------------------------------------------------------------------------------------------
// Destroy computed fields on the datawindows if we need to
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_AutoPivoting And IsValid(io_datasource) And is_DestroyStringForComputedFieldsWhenAutoPivot <> '' Then
	ls_return = io_datasource.Dynamic Modify(is_DestroyStringForComputedFieldsWhenAutoPivot)
	is_DestroyStringForComputedFieldsWhenAutoPivot = ''
End If

If IsValid(iu_original_search) And ib_ReportHasBeenFiltered Then
	iu_original_search.Event ue_notify('reapply filter', '')
End If
end event

