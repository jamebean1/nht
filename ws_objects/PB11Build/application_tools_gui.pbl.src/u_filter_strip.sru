$PBExportHeader$u_filter_strip.sru
$PBExportComments$This is the filter strip object.  It is a datawindow.
forward
global type u_filter_strip from u_datawindow
end type
end forward

global type u_filter_strip from u_datawindow
integer width = 32000
integer height = 124
boolean livescroll = false
borderstyle borderstyle = stylelowered!
event ue_refreshtheme ( )
event ue_notify ( string as_message,  any aany_argument )
event ue_itemchanged ( long row,  string column,  string data )
event ue_pbm_vscroll pbm_vscroll
end type
global u_filter_strip u_filter_strip

type variables
Protected:
	datawindow idw_data
	Boolean	ib_DistinctDropdowns	= False
	Boolean 	ib_hassubscribed = False
	Boolean	ib_FilterIsMultiSelect = False
	Boolean	ib_BatchMode = False
	Integer	ii_x_offset = 15
	Integer	ii_y_offset = 20
	Long 		il_x[]
	Long		il_width[]
	Long		il_dddw_all_data_column	= -100
	Long		il_reportconfigid
	Long		il_filterviewid
	String 	is_column_name[]
	String 	is_previous_filter[]
	String 	is_edit_style[]
	String 	is_suffix = 'srt'
	String 	is_ddlb_all_data_column = '@'
	String 	is_excluded_columns[]
	String 	is_supplemental_filter
	String 	is_supplemental_or_filter
	blob 		iblob_blankfullstate
	
	Blob		iblob_currentstate
	Boolean	ib_statestored 						= False
end variables

forward prototypes
public subroutine of_destroy ()
public function boolean of_isexcluded (string as_column)
public subroutine of_hide ()
public subroutine of_show ()
public subroutine of_set_offset (long al_xoffset, long al_yoffset)
public subroutine of_exclude (string as_columnlist)
public subroutine of_set_reportconfigid (long al_reportconfigid)
public subroutine of_reapply_filter ()
public subroutine of_retrieveend ()
public subroutine of_apply_supplemental_or_filter (string as_filter)
protected subroutine of_filter (string as_columnname, string as_filterstring)
public subroutine of_reposition ()
public subroutine of_reinitialize ()
public subroutine of_clear ()
public subroutine of_refresh ()
private subroutine of_replace_string_in_filter (string as_old_string, string as_new_string, boolean ab_clear_filter)
public function long of_get_current_view_id ()
public subroutine of_apply_supplemental_filter (string as_new_supplemental_filter)
public function string of_save_view (string as_viewname)
public subroutine of_init (ref powerobject adw_data)
public subroutine of_init (ref powerobject adw_data, string as_suffix)
protected subroutine of_create_datawindow ()
public subroutine of_refresh (boolean ab_resetcolumnvalues)
protected function string of_get_filter (string as_columnname, long al_columnnumber, string as_filterstring)
public subroutine of_set_batch_mode (boolean ab_batchmode)
public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic)
public function string of_set_data (string as_data)
public subroutine of_save_state ()
public subroutine of_restore_state ()
end prototypes

event ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This will refresh the theme
// Created by: Blake Doerr
// History:    6/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//This.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_barcolor()) +  "'")
end event

event ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This will respond to subscribed messages
// Created by: Blake Doerr
// History:    6/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_filter
String	ls_return
n_bag 	ln_bag
Window 	lw_window
w_reportconfig_manage_views lw_reportconfig_manage_views
n_report_criteria_default_engine ln_report_criteria_default_engine
GraphicObject lgo_null
Long		ll_return

This.AcceptText()

//----------------------------------------------------------------------------------------------------------------------------------
// Reposition if there is a column resize or a restoration of a view
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(as_message)
	case 'columnresize'
		This.of_reposition()
	Case 'visible columns changed', 'pivot table applied', 'after view restored'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_init(lgo_null, 0, gn_globals.il_userid, 'Filter')
		ln_report_criteria_default_engine.of_set_save(False)
		ln_report_criteria_default_engine.of_save_defaults(This)
		This.of_reinitialize()
		ln_report_criteria_default_engine.of_apply_defaults(This)
		Destroy ln_report_criteria_default_engine
		
		This.of_apply_supplemental_filter(This.GetItemString(1, 'customfilter'))
		This.of_reapply_filter()

	Case 'distinct all'
		ib_DistinctDropdowns = Not ib_DistinctDropdowns
		This.of_refresh(False)
	Case 'clear all', 'before view saved'
		This.of_clear()
	Case 'dropdowns refreshed'
		This.of_refresh(False)
	Case 'reapply filter'
		This.of_reapply_filter()
	Case 'restore view'
		This.of_clear()
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_init(This, il_reportconfigid, gn_globals.il_userid, 'Filter')
		ln_report_criteria_default_engine.Event ue_notify('restore view', aany_argument)
		il_filterviewid	= ln_report_criteria_default_engine.of_get_current_view_id()
		Destroy ln_report_criteria_default_engine
		
		This.of_apply_supplemental_filter(This.GetItemString(1, 'customfilter'))
		
		This.of_reapply_filter()
	Case 'apply filter view'
		This.of_clear()
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_init(This, il_reportconfigid, gn_globals.il_userid, 'Filter')
		ln_report_criteria_default_engine.of_restore_defaults(This, Long(aany_argument))
		il_filterviewid	= ln_report_criteria_default_engine.of_get_current_view_id()
		Destroy ln_report_criteria_default_engine
		
		This.of_apply_supplemental_filter(This.GetItemString(1, 'customfilter'))
		
		This.of_reapply_filter()

	Case 'save view as'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_init(This, il_reportconfigid, gn_globals.il_userid, 'Filter')
		ln_report_criteria_default_engine.of_ignore(String(il_dddw_all_data_column))
		ln_report_criteria_default_engine.of_ignore(is_ddlb_all_data_column)
		ln_report_criteria_default_engine.of_ignore('')
		ln_report_criteria_default_engine.Event ue_notify('save view as', aany_argument)
		il_filterviewid	= ln_report_criteria_default_engine.of_get_current_view_id()
		Destroy ln_report_criteria_default_engine
	Case 'custom filter'
		ls_filter = is_supplemental_filter
		If IsNull(ls_filter) Or ls_filter = '1=1' Or ls_filter = '1 = 1' Then ls_filter = ''

		ln_bag = Create n_bag
		ln_bag.of_set('datasource', idw_data)
		ln_bag.of_set('datatype', 'boolean')
		ln_bag.of_set('title', 'Select the Expression for the Custom Filter')
		ln_bag.of_set('expression', ls_filter)
		ln_bag.of_set('NameIsNotAllowed', 'Yes')
		
		OpenWithParm(lw_window, ln_bag, 'w_custom_expression_builder', w_mdi)
		
		If Not IsValid(ln_bag) Then Return

		ls_filter = String(ln_bag.of_get('datawindowexpression'))

		This.SetItem(1, 'customfilter_display', 	String(ln_bag.of_get('expression')))

		This.of_apply_supplemental_filter(ls_filter)

		If IsValid(ln_bag) Then
			Destroy ln_bag
		End If
	Case 'get filter view'
		If Not IsValid(Message.PowerObjectParm) Then Return
		If Not Lower(Trim(ClassName(Message.PowerObjectParm))) = 'n_bag' Then Return
		
		ln_bag = Message.PowerObjectParm

		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ln_report_criteria_default_engine.of_init(This, il_reportconfigid, gn_globals.il_userid, 'Filter')
		ln_report_criteria_default_engine.of_ignore(String(il_dddw_all_data_column))
		ln_report_criteria_default_engine.of_ignore(is_ddlb_all_data_column)
		ln_report_criteria_default_engine.of_ignore('')
		ll_return = ln_report_criteria_default_engine.of_save_defaults(This)
		Destroy ln_report_criteria_default_engine

		If Not IsNull(ll_return) And ll_return > 0 Then
			ln_bag.of_set('Filter View ID', ll_return)
		End If
	Case 'manage filter views'
		ln_bag = Create n_bag
		ln_bag.of_set('RprtCnfgID', il_reportconfigid)
		ln_bag.of_set('type', 'filter')
			
		OpenWithParm(lw_reportconfig_manage_views, ln_bag, 'w_reportconfig_manage_views', w_mdi)
	Case 'export filter'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ls_return = ln_report_criteria_default_engine.of_export_view(This, '', 'filter')
		Destroy ln_report_criteria_default_engine
	//	If Not ib_batchmode And Len(ls_return) > 0 Then gn_globals.in_messagebox.of_messagebox_validation(ls_return)
		
	Case 'import filter'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ls_return = ln_report_criteria_default_engine.of_import_view(This, '', 'filter')
		Destroy ln_report_criteria_default_engine
	//	If Not ib_batchmode And Len(ls_return) > 0 Then gn_globals.in_messagebox.of_messagebox_validation(ls_return)
		
		This.of_apply_supplemental_filter(This.GetItemString(1, 'customfilter'))
		
		This.of_reapply_filter()
	Case 'import filter public'
		ln_report_criteria_default_engine = Create n_report_criteria_default_engine
		ls_return = ln_report_criteria_default_engine.of_import_view_public(This, '', 'filter')
		Destroy ln_report_criteria_default_engine
		//If Not ib_batchmode And Len(ls_return) > 0 Then gn_globals.in_messagebox.of_messagebox_validation(ls_return)
		
		This.of_apply_supplemental_filter(This.GetItemString(1, 'customfilter'))
		
		This.of_reapply_filter()
End Choose
end event

event ue_itemchanged(long row, string column, string data);//----------------------------------------------------------------------------------------------------------------------------------
// Event:     	ue_ItemChanged
// Overrides:  No
// Overview:   Call the of_filter function if this is a dropdowndatawindow
// Created by: Blake Doerr
// History:    04/02/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_datawindow_tools ln_datawindow_tools

Choose Case Lower(idw_data.Describe(column + ".Edit.Style"))
	Case 'dddw'
		If IsNumber(This.Describe(column + '_multi.ID')) Then
			ln_datawindow_tools = Create n_datawindow_tools
			If IsNull(ln_datawindow_tools.of_getitem(This, 1, column)) Then
				ib_FilterIsMultiSelect = False
			Else
				ib_FilterIsMultiSelect = ln_datawindow_tools.of_getitem(This, 1, column) <> ln_datawindow_tools.of_getitem(This, 1, column + '_multi')
			End If
		End If
		
		This.of_filter(Lower(column), Lower(data))
		ib_FilterIsMultiSelect = False
End Choose
end event

event ue_pbm_vscroll;Message.Processed = True

end event

public subroutine of_destroy ();
end subroutine

public function boolean of_isexcluded (string as_column);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isexcluded()
//	Arguments:  as_column - a column to check to see if it is excluded
//	Overview:   This will check if the column is excluded
//	Created by:	Blake Doerr
//	History: 	8.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

For ll_index = 1 To UpperBound(is_excluded_columns)
	If Lower(Trim(is_excluded_columns[ll_index])) = Trim(Lower(as_column)) Then Return True
Next

Return False
end function

public subroutine of_hide ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_Hide()
// Arguements:  none
// Function: 	 Hide All Objects
// Created by 	 Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------
This.visible = False

end subroutine

public subroutine of_show ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_show()
// Arguements:  none
// Function: 	 Show All Objects
// Created by 	 Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

This.Visible = True
end subroutine

public subroutine of_set_offset (long al_xoffset, long al_yoffset);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_offset()
// Arguments:   al_xoffset, al_yoffset
// Overview:    This will set the x and y offset for the filter
// Created by:  Blake Doerr
// History:     04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ii_x_offset = al_xoffset
ii_y_offset = al_yoffset
end subroutine

public subroutine of_exclude (string as_columnlist);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_exclude()
//	Arguments:  as_columnlist - a comma delimted list of columns
//	Overview:   This will exclude columns from the filtering
//	Created by:	Blake Doerr
//	History: 	8.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_array[]
Long ll_index

//n_string_functions ln_string_functions 
gn_globals.in_string_functions.of_parse_string(as_columnlist, ',', ls_array[])


For ll_index = 1 To UpperBound(ls_array)
	If Not IsNull(ls_array[ll_index]) And Len(Trim(ls_array[ll_index])) > 0 Then
		is_excluded_columns[UpperBound(is_excluded_columns) + 1] = Lower(Trim(ls_array[ll_index]))
	End If
Next

end subroutine

public subroutine of_set_reportconfigid (long al_reportconfigid);il_reportconfigid = al_reportconfigid
end subroutine

public subroutine of_reapply_filter ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_reapply_filter()
// Overview:    This will reapply the filter based on what's in the datawindow
// Created by:  Blake Doerr
// History:     04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
Long 		ll_index
String	ls_filter_string
String 	ls_total_filter_string
String	ls_column_data

n_datawindow_tools ln_datawindow_tools
ln_datawindow_tools = Create n_datawindow_tools

//Loop through the columns
For ll_index = 1 To UpperBound(is_column_name)
	is_previous_filter[ll_index] = ''
		
	If IsNumber(This.Describe(is_column_name[ll_index] + '_multi.ID')) Then
		ls_column_data = ln_datawindow_tools.of_getitem(This, 1, is_column_name[ll_index] + '_multi')
		
		ib_FilterIsMultiSelect = ln_datawindow_tools.of_getitem(This, 1, is_column_name[ll_index]) <> ln_datawindow_tools.of_getitem(This, 1, is_column_name[ll_index] + '_multi')
	Else
		ls_column_data = ln_datawindow_tools.of_getitem(This, 1, is_column_name[ll_index])
		ib_FilterIsMultiSelect = False
	End If
	
	ls_filter_string = This.of_get_filter(is_column_name[ll_index], ll_index, Lower(ls_column_data))
	
	If ls_filter_string = '1=1' Or ls_filter_string = '1 = 1' Or Len(Trim(ls_filter_string)) = 0 Then Continue

	is_previous_filter[ll_index] = ls_filter_string
	
	ls_total_filter_string = ls_total_filter_string + ls_filter_string + ' And '
Next

ib_FilterIsMultiSelect = False

If Len(Trim(is_supplemental_filter)) > 0 Then
	ls_total_filter_string = ls_total_filter_string + is_supplemental_filter + ' And '
End If

ls_total_filter_string = Left(ls_total_filter_string, Len(ls_total_filter_string) - 4)

This.of_replace_string_in_filter('', ls_total_filter_string, True)

Destroy ln_datawindow_tools
end subroutine

public subroutine of_retrieveend ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieveend()
//	Overview:   This will reapply the filter
//	Created by:	Blake Doerr
//	History: 	8.10.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_refresh(False)
end subroutine

public subroutine of_apply_supplemental_or_filter (string as_filter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_supplemental_or_filter
//	Arguments:  as_filter- Non-filter strip filter to apply
//	Overview:   accessor for is_supplemental_or_filter.  Applies a filter to be OR'd
//	Created by:	Eric Wellnitz
//	History: 	10/11/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_supplemental_or_filter = as_filter
end subroutine

protected subroutine of_filter (string as_columnname, string as_filterstring);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_filter()
// Arguments:  as_columnname = the column name, as_filterstring = the data to filter on
// Overview:   Filter on the column that was changed
// Created by: Blake Doerr
// History:    04/02/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------------------------------------------------------
Long		ll_column_number
Long		ll_index
String	ls_filter

//----------------------------------------------------------------------------------------------------------------------------------
// Get the column ID and the Datawindow Filter
//----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_column_name[])
	If Lower(Trim(as_columnname)) = Lower(Trim(is_column_name[ll_index])) Then
		ll_column_number = ll_index
		Exit
	End If
Next

If UpperBound(is_previous_filter[]) >= ll_column_number Then
	If IsNull(is_previous_filter[ll_column_number]) Then is_previous_filter[ll_column_number] = ''
Else
	is_previous_filter[ll_column_number] = ''
End If

ls_filter = This.of_get_filter(as_columnname, ll_column_number, as_filterstring)

If Trim(is_previous_filter[ll_column_number]) = '' And (ls_filter = '1=1' Or ls_filter = '1 = 1') Then
	Return
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Trigger an event before the filter
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.TriggerEvent("ue_pre_fltr")

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace old filter for column with new filter for column. Then filter using new filter string
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_replace_string_in_filter(is_previous_filter[ll_column_number], ls_filter, False)

//Keep the previous filter string for later
is_previous_filter[ll_column_number] = ls_filter
end subroutine

public subroutine of_reposition ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_reposition()
// Arguments:   
// Overview:    Called from ScrollHorizontal dw events to reposition the filters
// Created by:  Blake Doerr
// History:     07/14/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_column_count, ll_horizontal_scrollposition, ll_index, ll_x, ll_width

if IsValid(idw_data) then
	This.setredraw(false)
	
	ll_horizontal_scrollposition = Long( idw_data.describe("datawindow.horizontalscrollposition"))
	
	//---------------------------------------------------------
	// Reposition the columns when scrolling
	//---------------------------------------------------------
	For ll_index = 1 to UpperBound(is_column_name)
		ll_x = Long(idw_data.describe(is_column_name[ll_index] + "_" + is_suffix + ".X"))
		ll_width = Long(idw_data.describe(is_column_name[ll_index] + "_" + is_suffix + ".Width"))	
		//---------------------------------------------------------
		// Now instead of just moving the X coordinate off the screen.
		// Move the x coordinate until the offset x coordinate is
		// reached, and then shrink the width.
		//---------------------------------------------------------

		if ll_horizontal_scrollposition > ll_x then
			ll_width 	= ll_width - ll_horizontal_scrollposition + ll_x
			ll_x 			= ii_x_offset
		Else
			ll_x 			= this.x + ii_x_offset + ll_x - ll_horizontal_scrollposition
		End IF
		This.Modify(is_column_name[ll_index] + '.X=' + String(ll_x) + '~t' + is_column_name[ll_index] + '.Width=' + String(ll_width))
	Next

	This.setredraw(true)
End If
end subroutine

public subroutine of_reinitialize ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_reinitialize()
//	Arguments:  None.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	3/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not IsValid(idw_data) Then Return

This.of_replace_string_in_filter('', '', True)
This.of_init(idw_data, is_suffix)
end subroutine

public subroutine of_clear ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_clear()
// Overview:    This will clear all the values for the filter
// Created by:  Blake Doerr
// History:     04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_index, ll_row
DatawindowChild ldwc_destination
PowerObject	lo_this
String ls_data_column, ls_display_column, ls_temp

n_datawindow_tools ln_datawindow_tools
ln_datawindow_tools = Create n_datawindow_tools

//Loop through the columns
For ll_index = 1 To UpperBound(is_column_name)
	Choose Case is_edit_style[ll_index]
		Case 'dddw'
			//Get a reference to the destination datawindow
			This.GetChild(is_column_name[ll_index], ldwc_destination)
	
			//Get the data column
			ls_data_column 	= This.Describe(is_column_name[ll_index] + ".DDDW.DataColumn")
			
			Choose Case Left(Lower(ldwc_destination.Describe(ls_data_column + ".ColType")), 4)
				Case	'char', 'stri', 'date'
					If IsNumber(ldwc_destination.Describe(ls_data_column + '.ID')) Then
						ldwc_destination.SetItem(ll_row, ls_data_column, String(il_dddw_all_data_column))
					End If
					
					This.SetItem(1, is_column_name[ll_index], String(il_dddw_all_data_column))
				Case Else 
					If IsNumber(ldwc_destination.Describe(ls_data_column + '.ID')) Then
						ldwc_destination.SetItem(ll_row, ls_data_column, il_dddw_all_data_column)
					End If
					
					This.SetItem(1, is_column_name[ll_index], il_dddw_all_data_column)
			End Choose
			
			ls_temp = This.Describe(is_column_name[ll_index] + '_multi.ID')
			
			If IsNumber(This.Describe(is_column_name[ll_index] + '_multi.ID')) Then
				This.SetItem(1, is_column_name[ll_index] + '_multi', String(il_dddw_all_data_column))
			End If
		Case 'ddlb'
			lo_this = This
			ln_datawindow_tools.of_setitem(lo_this, 1, is_column_name[ll_index], is_ddlb_all_data_column)
		Case Else
			This.SetItem(1, is_column_name[ll_index], '')
	End Choose
	
	is_previous_filter[ll_index] = ''
Next

This.SetItem(1, 'customfilter_display', '')
This.SetItem(1, 'customfilter', '')
is_supplemental_filter = ''
This.of_replace_string_in_filter('', '', True)
il_filterviewid = 0

Destroy ln_datawindow_tools
end subroutine

public subroutine of_refresh ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_refresh()
// Overview:    This will refresh the data in the dropdowndatawindows
// Created by:  Blake Doerr
// History:     04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_refresh(True)
end subroutine

private subroutine of_replace_string_in_filter (string as_old_string, string as_new_string, boolean ab_clear_filter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_string_in_filter
//	Arguments:  as_old_string - string in filter to replace, as_new_string - string with which to replace old string in 
//					filter
//	Overview:   Take second string and replace it in the filter where the first string was. Then filter using the new
//					filter string.
//	Created by:	Kristin Ferrier
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long 		ll_start_pos
string 	ls_filter, ls_filter_actual
//n_string_functions 	ln_string_functions
n_bag 					ln_bag
//----------------------------------------------------------------------------------------------------------------------------------
// Get current filter string
//----------------------------------------------------------------------------------------------------------------------------------
If Not ab_clear_filter Then
	ls_filter = Trim(idw_data.Describe("DataWindow.Table.Filter"))
	if ls_filter = '?' or ls_filter = '!' then ls_filter = ''
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Replace any tildas in current filter string
	//-----------------------------------------------------------------------------------------------------------------------------------
	gn_globals.in_string_functions.of_replace_all(ls_filter, '~~', '')
	gn_globals.in_string_functions.of_replace_all(as_old_string, '~~', '')
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Set the filter. If the old string is in the filter, replace it, else add and + to the new filter string
//-----------------------------------------------------------------------------------------------------------------------------------
if Len(ls_filter) > 0 then
	if pos( ls_filter, as_old_string) > 0 then
		ls_filter = replace( ls_filter, pos( ls_filter, as_old_string), len(as_old_string), as_new_string)
	else
		ls_filter = as_new_string + ' and ' + ls_filter 
	end if
else
	ls_filter = as_new_string
end if

//----------------------------------------------------------------------------------------------------------------------------------
// 10/11/2002 - ERW - Add 'supplemental or filter' to the filter
//-----------------------------------------------------------------------------------------------------------------------------------
If (is_supplemental_or_filter <> '') Then
	If (ls_filter <> '') Then
		If pos(ls_filter, 'OR ' + '(' + Trim(is_supplemental_or_filter) + ')') = 0 Then
			ls_filter = ls_filter + ' OR ' + '(' + Trim(is_supplemental_or_filter) + ')'
		End If
	End If
End If

ls_filter_actual = ls_filter

//----------------------------------------------------------------------------------------------------------------------------------
// Publish a message with the filter in case it needs to be modified by another service.  Get it back off the bag.
//-----------------------------------------------------------------------------------------------------------------------------------
ln_bag = Create n_bag
ln_bag.of_set('filter', ls_filter)
If IsValid(gn_globals.in_subscription_service) Then gn_globals.in_subscription_service.of_message('Before Filter', ln_bag, idw_data)

If IsValid(ln_bag) Then
	If Not IsNull(String(ln_bag.of_get('filter'))) Then ls_filter = String(ln_bag.of_get('filter'))
	Destroy ln_bag
End If
	
//----------------------------------------------------------------------------------------------------------------------------------
// Set the filter into the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.setfilter(ls_filter)
idw_data.filter()
idw_data.groupcalc()

//----------------------------------------------------------------------------------------------------------------------------------
// Trigger an event after the filter
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message('filter',ls_filter,idw_data)
end if

If ls_filter_actual <> ls_filter Then idw_data.SetFilter(ls_filter_actual)



end subroutine

public function long of_get_current_view_id ();Return il_filterviewid
end function

public subroutine of_apply_supplemental_filter (string as_new_supplemental_filter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply_supplemental_filter
//	Arguments:  as_new_supplemental_filter - Non-filter strip filter to apply
//	Overview:   Take new non-filter strip filter and add it to the existing filter. Replace the old 
//					supplemental filter if it exists.
//	Created by:	Kristin Ferrier
//	History: 	1/19/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Datastore	lds_datastore
//n_string_functions ln_string_functions
String	ls_expression

as_new_supplemental_filter = Trim(as_new_supplemental_filter)

ls_expression = as_new_supplemental_filter

lds_datastore = Create Datastore
lds_datastore.Create(idw_data.Describe("Datawindow.Syntax"))
gn_globals.in_string_functions.of_replace_all(ls_expression, '"', '~~"')

If lds_datastore.Describe("Evaluate(~"" + ls_expression + "~",1)") = '!' Then
	Destroy lds_datastore
	Return// 'Error:  The filter cannot be applied because it is not valid with the current columns on the report.  This may need to be applied to a different view'
End If

Destroy lds_datastore

as_new_supplemental_filter = Trim(as_new_supplemental_filter)

if isnull(is_supplemental_filter) then is_supplemental_filter = ''
if isnull(as_new_supplemental_filter) then as_new_supplemental_filter = ''
if as_new_supplemental_filter = '' then
	If Len(Trim(is_supplemental_filter)) = 0 Then
		Return
	Else
		as_new_supplemental_filter = "1=1"
	End If
End If

If as_new_supplemental_filter <> '' And as_new_supplemental_filter <> '1=1' And as_new_supplemental_filter <> '1 = 1' Then
	This.SetItem(1, 'customfilter', 				as_new_supplemental_filter)
	
	If Left(as_new_supplemental_filter, 1) <> '(' Then
		as_new_supplemental_filter = '(' + as_new_supplemental_filter + ')'
	End If
Else
	This.SetItem(1, 'customfilter', 				'')
	This.SetItem(1, 'customfilter_display', 	'')
End If

If as_new_supplemental_filter = is_supplemental_filter Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace old supplemental filter with new one and filter
//-----------------------------------------------------------------------------------------------------------------------------------

this.of_replace_string_in_filter(is_supplemental_filter, as_new_supplemental_filter, False)

is_supplemental_filter = as_new_supplemental_filter
end subroutine

public function string of_save_view (string as_viewname);n_report_criteria_default_engine ln_report_criteria_default_engine 
ln_report_criteria_default_engine = Create n_report_criteria_default_engine
ln_report_criteria_default_engine.of_init(This, il_reportconfigid, gn_globals.il_userid, 'Filter')
ln_report_criteria_default_engine.of_ignore(String(il_dddw_all_data_column))
ln_report_criteria_default_engine.of_ignore(is_ddlb_all_data_column)
ln_report_criteria_default_engine.of_ignore('')
ln_report_criteria_default_engine.of_save_defaults(This, il_reportconfigid, gn_globals.il_userid, as_viewname)
il_filterviewid	= ln_report_criteria_default_engine.of_get_current_view_id()
Destroy ln_report_criteria_default_engine

Return String(il_filterviewid)
end function

public subroutine of_init (ref powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_init()
// Arguements:  dw_data
// Function: 	 Initialize the filter object defaulting the suffix
// Created by:  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_init(adw_data, 'srt')
end subroutine

public subroutine of_init (ref powerobject adw_data, string as_suffix);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_init()
// Arguements:  dw_data, suffix
// Function: 	 Initialize the filter objects
// Created by:  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
Long 		ll_index, ll_array_location, ll_reset[]
String	ls_visible
String 	ls_reset[]
String	ls_columnname[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]
n_datawindow_tools ln_datawindow_tools


If adw_data.TypeOf() <> Datawindow! Then Return

idw_data = adw_data

//-----------------------------------------------------
// Reset the instance arrays.
//-----------------------------------------------------
il_x[] = ll_reset[]
il_width[] = ll_reset[]
is_column_name[] = ls_reset[]
is_previous_filter[] = ls_reset[]
is_edit_style[] = ls_reset[]

//-----------------------------------------------------
// Subscribe to the messages that affect this object
//-----------------------------------------------------
If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_subscribe(This,			'ColumnResize', 				idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 		'After View Restored', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 		'before view saved', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 		'visible columns changed', idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 		'pivot table applied', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 		'dropdowns refreshed', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 		'get filter view', 			idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 		'reapply filter', 			idw_data)
		gn_globals.in_subscription_service.of_subscribe(idw_data, 	'filter', 						idw_data)
	End If
End If

is_suffix = as_suffix
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_columns(idw_data, ls_columnname[], ls_headername[], ls_headertext[], ls_columntype[])
Destroy ln_datawindow_tools

//-----------------------------------------------------
// Loop through all visible columns looking for headers
// Save instance data and create the columns
//-----------------------------------------------------
For ll_index = 1 to UpperBound(ls_columnname[])
	ls_visible = idw_data.Describe(ls_columnname[ll_index] + ".Visible")
	if Left(ls_visible, 1) = '0' Or Left(ls_visible, 2) = '"0' Or ls_visible = '"1~t0"' Then Continue

	If Not Lower(Trim(ls_columnname[ll_index])) + '_' + as_suffix = Lower(Trim(ls_headername[ll_index])) Then Continue

	If This.of_IsExcluded(ls_columnname[ll_index]) Then Continue

	ll_array_location = UpperBound(is_column_name) + 1
	is_column_name	 		[ll_array_location] = ls_columnname[ll_index]
	il_x				 		[ll_array_location] = Long(idw_data.describe(ls_headername[ll_index] + ".x")) - 0 + ii_x_offset
	il_width			 		[ll_array_location] = Long(idw_data.describe(ls_headername[ll_index] + ".width")) - 8
	is_previous_filter	[ll_array_location] = ''
Next

//-----------------------------------------------------
// Create the datawindow and insert a row
//-----------------------------------------------------
of_create_datawindow()
this.getfullstate(iblob_blankfullstate)	//This gets the full state of the filter dw before any values are loaded
This.InsertRow(0)
This.of_refresh()
This.of_reposition()
This.Event ue_refreshtheme()
end subroutine

protected subroutine of_create_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_create_datawindow()
// Overview:    This will dynamically create the datawindow that is the filter strip
// Created by:  Blake Doerr
// History:     04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
NonVisualObject ln_multi_select_dddw_service
String ls_header_syntax = '', ls_table_syntax = '', ls_table_syntax2 = '', ls_column_syntax = '', ls_column_type, ls_error_create, ls_values, ls_dropdowndatawindow_syntax, ls_editstyle, ls_syntax, ls_result3
Long 	ll_index, ll_index2, ll_temp, ll_minimum_x_position = 10000, ll_position, ll_position2
Long	ll_level[]
Long	ll_maxlevel = 1
Long	ll_columncount
Long	ll_x[]
Long	ll_minimum_x	= 10000
Long	ll_width
Long	ll_columnnumber[]
Long	ll_count
string ls_tag
Boolean	lb_RepairWasMade

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the header syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_header_syntax = ls_header_syntax + 'release 7;~r~n'
//ls_header_syntax = ls_header_syntax + 'datawindow(units=0 timer_interval=0 color=' + String(gn_globals.in_theme.of_get_barcolor()) + ' processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no pointer="mouse.cur")~r~n'
ls_header_syntax = ls_header_syntax + 'header(height=0 color="536870912" )~r~n'
ls_header_syntax = ls_header_syntax + 'summary(height=0 color="536870912" )~r~n'
ls_header_syntax = ls_header_syntax + 'footer(height=0 color="536870912" )~r~n'
ls_header_syntax = ls_header_syntax + 'detail(height=90 color="536870912")~r~n'


//-----------------------------------------------------------------------------------------------------------------------------------
// Start the table section syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_table_syntax = ls_table_syntax + 'table('

//-----------------------------------------------------------------------------------------------------------------------------------
// Build the table syntax and the syntax for the columns
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_column_name)
	ll_minimum_x = Min(ll_minimum_x, il_x[ll_index])
	ls_editstyle = Lower(Trim(idw_data.Describe(is_column_name[ll_index] + ".Edit.Style")))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Check to see if we should change the type of filter being applied.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_tag = Lower(Trim(idw_data.Describe(is_column_name[ll_index] + ".Tag")))
	if pos(ls_tag,'useslefilter') > 0 then 
		ls_editstyle = 'sle'
	end if
		
	
	Choose Case ls_editstyle
		Case 'dddw'
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Build the table column
			//		We are working with a dropdowndatawindow, so make an exact replica of the column were are interrogating
			//-----------------------------------------------------------------------------------------------------------------------------------
			is_edit_style[ll_index] = 'dddw'
			ls_column_type = idw_data.Describe(is_column_name[ll_index] + ".ColType")
			ls_table_syntax = ls_table_syntax + 'column=(type=' + ls_column_type + ' updatewhereclause=no name=' + is_column_name[ll_index] + ' dbname="' + is_column_name[ll_index] + '" )~r~n'
			ls_table_syntax2 = ls_table_syntax2 + 'column=(type=char(4000) updatewhereclause=no name=' + is_column_name[ll_index] + '_multi dbname="' + is_column_name[ll_index] + '_multi" )~r~n'

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Build the column object with all the pertinent dropdowndatawindow properties
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_dropdowndatawindow_syntax = ''
			ls_dropdowndatawindow_syntax = ls_dropdowndatawindow_syntax + ' dddw.name=' 				+ idw_data.Describe(is_column_name[ll_index] + ".dddw.name")
			ls_dropdowndatawindow_syntax = ls_dropdowndatawindow_syntax + ' dddw.displaycolumn=' 	+ idw_data.Describe(is_column_name[ll_index] + ".dddw.displaycolumn")
			ls_dropdowndatawindow_syntax = ls_dropdowndatawindow_syntax + ' dddw.datacolumn=' 		+ idw_data.Describe(is_column_name[ll_index] + ".dddw.datacolumn")
			ls_dropdowndatawindow_syntax = ls_dropdowndatawindow_syntax + ' dddw.percentwidth=' 	+ idw_data.Describe(is_column_name[ll_index] + ".dddw.percentwidth")
			ls_dropdowndatawindow_syntax = ls_dropdowndatawindow_syntax + ' dddw.lines=' 				+ idw_data.Describe(is_column_name[ll_index] + ".dddw.lines")
	
			ls_column_syntax = ls_column_syntax + 'column(band=detail id=' + String(ll_index) + ' alignment="0" tabsequence=' + String(il_x[ll_index]) + ' border="5" color="0" x="' + String(il_x[ll_index]) + '" y="' + String(ii_y_offset) + '" height="65" width="' + String(il_width[ll_index]) + '" name=' + is_column_name[ll_index] + ls_dropdowndatawindow_syntax + ' dddw.limit=0 dddw.allowedit=yes dddw.useasborder=yes dddw.case=any dddw.vscrollbar=yes dddw.NilIsNull=yes font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" dddw.required=yes)~r~n'
		Case 'ddlb', 'checkbox'
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Build the table column
			//		We are working with a dropdowndatawindow, so make an exact replica of the column were are interrogating
			//-----------------------------------------------------------------------------------------------------------------------------------
			is_edit_style[ll_index] = 'ddlb'
			ls_column_type = idw_data.Describe(is_column_name[ll_index] + ".ColType")
			
			if ls_editstyle = 'ddlb' Then
				//-----------------------------------------------------------------------------------------------------------------------------------
				// The Values Property has all the items of the drop down defined.  Add all as a selection.
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_values = idw_data.Describe(is_column_name[ll_index] + ".Values")
				ls_values = '(All)~t' + is_ddlb_all_data_column + '/' + ls_values
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
				
				//-------------------------------------------------------------------
				// Determine the on state
				//-------------------------------------------------------------------
				ls_syntax = idw_data.Describe("Datawindow.Syntax")				
				ll_position = Pos(ls_syntax, 'column(name=' + is_column_name[ll_index])
				ll_position = Pos(ls_syntax, 'checkbox.on=', ll_position)
				ll_position = ll_position + 13
				ll_position2 = Pos(ls_syntax, '" ', ll_position)
				ls_result = Mid(ls_syntax, ll_position, ll_position2 - ll_position)

				//-------------------------------------------------------------------
				// Determine the off state
				//-------------------------------------------------------------------
				ll_position = Pos(ls_syntax, 'column(name=' + is_column_name[ll_index])
				ll_position = Pos(ls_syntax, 'checkbox.off=', ll_position)
				ll_position = ll_position + 14
				ll_position2 = Pos(ls_syntax, '" ', ll_position)
				ls_result2 = Mid(ls_syntax, ll_position, ll_position2 - ll_position)

				//-------------------------------------------------------------------
				// Create the string for the DrowDownListBox
				//-------------------------------------------------------------------
				ls_values = '(All)~t' + is_ddlb_all_data_column + '/Yes' +   '~t' + ls_result +         '/No~t' + ls_result2
	
				//-------------------------------------------------------------------
				// If there is a Third state
				//-------------------------------------------------------------------
				ll_position = Pos(ls_syntax, 'column(name=' + is_column_name[ll_index])
				ll_position = Pos(ls_syntax, 'checkbox.other=', ll_position)
				If ll_position > 0 Then
					ll_position = ll_position + 16
					ll_position2 = Pos(ls_syntax, '" ', ll_position)
					ls_result3 = Mid(ls_syntax, ll_position, ll_position2 - ll_position)
					
					ls_values = ls_values + '/Maybe~t' + ls_result3
				End If
				
			End If

			ls_table_syntax = ls_table_syntax + 'column=(type=' + ls_column_type + ' updatewhereclause=no name=' + is_column_name[ll_index] + ' dbname="' + is_column_name[ll_index] + '" values="' + ls_values + '" )~r~n'

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Build the column object with all the pertinent dropdowndatawindow properties
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_column_syntax = ls_column_syntax + 'column(band=detail id=' + String(ll_index) + ' alignment="0" tabsequence=' + String(il_x[ll_index]) + ' border="5" color="0" x="' + String(il_x[ll_index]) + '" y="' + String(ii_y_offset) + '" height="65" width="' + String(il_width[ll_index]) + '" ddlb.limit=0 ddlb.allowedit=no ddlb.case=any ddlb.vscrollbar=yes ddlb.useasborder=yes format="[general]"  name=' + is_column_name[ll_index] + ' font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" ddlb.required=yes)~r~n'
		Case Else 
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Build the table column
			//		We are not working with a dropdowndatawindow, so make strings
			//-----------------------------------------------------------------------------------------------------------------------------------
			is_edit_style[ll_index] = 'sle'
			ls_table_syntax = ls_table_syntax + 'column=(type=char(255) updatewhereclause=no name=' + is_column_name[ll_index] + ' dbname="' + is_column_name[ll_index] + '" )~r~n'
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Build the column object
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_column_syntax = ls_column_syntax + 'column(band=detail id=' + String(ll_index) + ' alignment="0" tabsequence=' + String(il_x[ll_index]) + ' border="5" color="0" x="' + String(il_x[ll_index]) + '" y="' + String(ii_y_offset) + '" height="65" width="' + String(il_width[ll_index]) + '" format="[general]"  name=' + is_column_name[ll_index] + ' edit.limit=0 edit.case=any edit.autoselect=yes edit.autohscroll=yes edit.focusrectangle=no font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" edit.required=yes)~r~n'
	End Choose
Next

ls_table_syntax 	= ls_table_syntax + 	'column=(type=char(4099) updatewhereclause=no name=customfilter_display dbname="customfilter_display" )~r~n'
ls_table_syntax 	= ls_table_syntax + 	'column=(type=char(4099) updatewhereclause=no name=customfilter dbname="customfilter" )~r~n'
//ls_column_syntax 	= ls_column_syntax + 'column(band=detail id=' + String(UpperBound(is_column_name) + 1) + ' alignment="0" tabsequence=0 border="5" color="0" x="5" y="' + String(ii_y_offset + 75) + '" height="65" width="2000" format="[general]"  name=customfilter_display edit.limit=0 edit.case=any edit.autoselect=yes edit.autohscroll=yes edit.focusrectangle=no font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="553648127" edit.required=yes)~r~n'

//-----------------------------------------------------------------------------------------------------------------------------------
// End the table syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_table_syntax = ls_table_syntax + ls_table_syntax2 + ')~r~n'

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datawindow and show a message box if there's a problem
//-----------------------------------------------------------------------------------------------------------------------------------
This.Create(ls_header_syntax + ls_table_syntax + ls_column_syntax, ls_error_create)

If Len(ls_error_create) > 0 Then
	MessageBox('Error Creating Datawindow', ls_error_create)
	Return
End If

ln_multi_select_dddw_service = in_datawindow_graphic_service_manager.of_get_service('n_multi_select_dddw_service')
If IsValid(ln_multi_select_dddw_service) Then ln_multi_select_dddw_service.Dynamic of_init(This)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through and look for overlapping columns
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_column_name)
	ll_level[ll_index] = 1	
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through and look for overlapping columns
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_column_name)
	For ll_index2 = 1 To UpperBound(is_column_name)
		If ll_index = ll_index2 Then Continue
		
		If ll_level[ll_index] <> ll_level[ll_index2] Then Continue
		
		If (il_x[ll_index] > il_x[ll_index2] + il_width[ll_index2]) Or (il_x[ll_index2] > il_x[ll_index] + il_width[ll_index]) Then Continue
		
		If il_x[ll_index] > il_x[ll_index2] Then
			ll_level[ll_index] = ll_level[ll_index] + 1
		Else
			ll_level[ll_index2] = ll_level[ll_index2] + 1
		End If
		
		ll_maxlevel = Max(ll_maxlevel, Max(ll_level[ll_index], ll_level[ll_index2]))
	Next
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no collisions
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_maxlevel <= 1 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Default this variable to get the loop going
//-----------------------------------------------------------------------------------------------------------------------------------
lb_RepairWasMade 	= True
ll_count				= 0
//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through and look for overlapping columns
//-----------------------------------------------------------------------------------------------------------------------------------
Do While lb_RepairWasMade
	lb_RepairWasMade = False
	ll_count = ll_count + 1


	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all the columns and look for out of order columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To UpperBound(is_column_name)
		For ll_index2 = 1 To UpperBound(is_column_name)
			If ll_index = ll_index2 Then Continue
			
			If ll_level[ll_index] = ll_level[ll_index2] Then Continue
			
			If (il_x[ll_index] > il_x[ll_index2] + il_width[ll_index2]) Or (il_x[ll_index2] > il_x[ll_index] + il_width[ll_index]) Then Continue
			
			If (il_x[ll_index] > il_x[ll_index2]) = (ll_level[ll_index] > ll_level[ll_index2]) Then Continue
			
			ll_temp = ll_level[ll_index]
			ll_level[ll_index] = ll_level[ll_index2]
			ll_level[ll_index2] = ll_temp
			
			lb_RepairWasMade = True
		Next
	Next
	
	If ll_count > 10 Then Exit
Loop

For ll_index = 1 To UpperBound(is_column_name)  // 40917 8/5/03 ECD  Originally looped 2 to upperbound()
	If ll_level[ll_index] = 1 Then Continue
	
	This.Modify('#' + String(ll_index) + '.Y = ' + String(ii_y_offset + 85 * (ll_level[ll_index] - 1)))
Next

This.Height = 124 + (ll_maxlevel - 1) * 90
This.Modify("Datawindow.Detail.Height='" + String(This.Height) + "'")
//??? Will this work for .Net?
idw_data.GetParent().TriggerEvent('resize')
If Long( idw_data.describe("datawindow.horizontalscrollposition")) > 0 Then
	This.of_reposition()
End If
end subroutine

public subroutine of_refresh (boolean ab_resetcolumnvalues);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_refresh()
// Overview:    This will refresh the data in the dropdowndatawindows
// Created by:  Blake Doerr
// History:     04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long		ll_index
Long		ll_row
String	ls_data_column,ls_current_filters
String	ls_display_column
String	ls_values
String	ls_filter

DatawindowChild 	ldwc_source
DatawindowChild 	ldwc_destination
NonVisualObject 	ln_service
PowerObject			lo_this
n_datawindow_tools ln_datawindow_tools
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

SetPointer(HourGlass!)
ln_datawindow_tools = Create n_datawindow_tools

this.accepttext()
ls_current_filters = this.Describe("DataWindow.Data")	//Get the current filter settings
this.setfullstate(iblob_blankfullstate)					//This reapplies the blank full state which releases the memory from the previous dw and all its child dws.
this.importstring(ls_current_filters)						//Apply the filter settings

//Loop through the column looking for datawindows
For ll_index = 1 To UpperBound(is_column_name)
	Choose Case is_edit_style[ll_index]
		Case 'dddw'
			//Get a reference to the source and destination datawindows and copy the rows
			idw_data.GetChild(is_column_name[ll_index], ldwc_source)
			This.		GetChild(is_column_name[ll_index], ldwc_destination)
	
			ldwc_destination.Reset()
			ldwc_source.RowsCopy ( 1, ldwc_source.RowCount(), Primary!, ldwc_destination, 1, Primary!)
			
			//Insert a row for the (All) selection
			ls_data_column 	= This.Describe(is_column_name[ll_index] + ".DDDW.DataColumn")
			ls_display_column	= This.Describe(is_column_name[ll_index] + ".DDDW.DisplayColumn")

			If ls_data_column = 'none' or ls_display_column = 'none' Then Continue
			
			If ib_DistinctDropdowns Then
				ls_filter = ln_datawindow_tools.of_create_distinct_filter(idw_data, is_column_name[ll_index], ls_data_column)
				
				If Len(ls_filter) > 0 Then
					ldwc_destination.SetFilter(ls_filter)
					ldwc_destination.Filter()
				End If
			End If
			
			ll_row = ldwc_destination.InsertRow(1)
	
			Choose Case Left(Lower(ldwc_destination.Describe(ls_display_column + ".ColType")), 4)
				Case	'char', 'stri'
					If IsNumber(ldwc_destination.Describe(ls_display_column + '.ID')) Then
						ldwc_destination.SetItem(ll_row, ls_display_column, '(All)')
					End If
			End Choose

			Choose Case Left(Lower(ldwc_destination.Describe(ls_data_column + ".ColType")), 4)
				Case	'char', 'stri'
					If IsNumber(ldwc_destination.Describe(ls_data_column + '.ID')) Then
						ldwc_destination.SetItem(ll_row, ls_data_column, String(il_dddw_all_data_column))
					End If
					
					If ab_resetcolumnvalues Then
					//If IsNull(This.GetItemString(1, is_column_name[ll_index])) Then
						This.SetItem(1, is_column_name[ll_index], String(il_dddw_all_data_column))
					//End If
					End If
				Case Else 
					If IsNumber(ldwc_destination.Describe(ls_data_column + '.ID')) Then						
						ldwc_destination.SetItem(ll_row, ls_data_column, il_dddw_all_data_column)
					End If
					
					If ab_resetcolumnvalues Then
					//If IsNull(This.GetItemNumber(1, is_column_name[ll_index])) Then
						This.SetItem(1, is_column_name[ll_index], il_dddw_all_data_column)
					//End If
					End If
			End Choose
			
			If ab_resetcolumnvalues Then
				If IsNumber(This.Describe(is_column_name[ll_index] + '_multi.ID')) Then
					This.SetItem(1, is_column_name[ll_index] + '_multi', String(il_dddw_all_data_column))
				End If
			End If

		Case 'ddlb'
			If ab_resetcolumnvalues Then
				lo_this = This
				If ln_datawindow_tools.of_getitem(lo_this, 1, is_column_name[ll_index]) = '' Then
					ln_datawindow_tools.of_setitem(lo_this, 1, is_column_name[ll_index], is_ddlb_all_data_column)
				End If
			End If
		Case Else
			If ab_resetcolumnvalues Then
				If IsNull(This.GetItemString(1, is_column_name[ll_index])) Then
					This.SetItem(1, is_column_name[ll_index], '')
				End If
			End If
	End Choose
Next


ln_datawindow_graphic_service_manager = This.of_get_service_manager()
ln_service = ln_datawindow_graphic_service_manager.of_get_service('n_multi_select_dddw_service')
If IsValid(ln_service) Then
	ln_service.Dynamic Event ue_insert_multi_select_item()
End If

Destroy ln_datawindow_tools

This.of_reposition()
end subroutine

protected function string of_get_filter (string as_columnname, long al_columnnumber, string as_filterstring);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_filter()
// Arguments:  as_columnname = the column name, as_filterstring = the data to filter on
// Overview:   Filter on the column that was changed
// Created by: Blake Doerr
// History:    04/02/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------------------------------------------------------
Long		ll_start_pos
Long		ll_end_pos
Long		ll_len_pos
Long		ll_filter_string_length
Long		ll_index
Long		ll_position
Long		ll_final_position
String	ls_editmask
String	ls_values[]
String	ls_filter = ''
String	ls_qute = "~""
String	ls_col_type
String	ls_prefix

String	ls_suffix
String	ls_string_mod = ''
String	ls_clause
String	ls_operator = '='
String	ls_coltype
String	ls_tag
String 	ls_column_name_filter_strip
Long		ll_actualcolumnnumber

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//----------------------------------------------------------------------------------------------------------------------------------
// Return empty string if the filter string is empty
//----------------------------------------------------------------------------------------------------------------------------------
if as_filterstring = '' then Return '1=1'

ls_column_name_filter_strip = as_columnname
ll_actualcolumnnumber	= Long(idw_data.Describe(as_columnname + '.ID'))
as_columnname 				= idw_data.Describe("#" + String(ll_actualcolumnnumber) + '.Name')
If as_columnname = '!' Or as_columnname = '?' Then as_columnname = ls_column_name_filter_strip

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the real length of the filter string
//----------------------------------------------------------------------------------------------------------------------------------
ll_filter_string_length = Len(as_filterstring)

//----------------------------------------------------------------------------------------------------------------------------------
// Replace all tilda's and double quotes
//----------------------------------------------------------------------------------------------------------------------------------
Choose Case is_edit_style[al_columnnumber]
	Case 'ddlb'
		gn_globals.in_string_functions.of_replace_all(as_filterstring, '~~', '')
		gn_globals.in_string_functions.of_replace_all(as_filterstring, '"', '')
	Case Else
		Choose Case Lower(Left( idw_data.Describe(as_columnname + ".ColType"), 4))
			Case 'char'
				gn_globals.in_string_functions.of_replace_all(as_filterstring, '~~', '~~~~')
				gn_globals.in_string_functions.of_replace_all(as_filterstring, '"', '~~~"')
			Case Else
				gn_globals.in_string_functions.of_replace_all(as_filterstring, '~~', '')
				gn_globals.in_string_functions.of_replace_all(as_filterstring, '"', '')
		End Choose
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Choose the values for the strings based on the column type
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case is_edit_style[al_columnnumber]
	Case 'dddw'
		gn_globals.in_string_functions.of_replace_all(as_filterstring, '~~', '')

		If as_filterstring = String(il_dddw_all_data_column) Or as_filterstring = '' Then 
			Choose Case Lower(Left( idw_data.Describe(as_columnname + ".ColType"), 4))
				Case "char" 
					This.SetItem(1, ls_column_name_filter_strip, String(il_dddw_all_data_column))
				Case "numb","long","real","deci"
					This.SetItem(1, ls_column_name_filter_strip, il_dddw_all_data_column)
				Case Else
			End Choose
			
			If Lower(Trim(This.GetColumnName())) = Lower(Trim(ls_column_name_filter_strip)) Then
				This.SetText(String(il_dddw_all_data_column))
			End If
			
			Return '1=1'
		End If
		
		ls_suffix= ''
		ls_prefix= ''

		Choose Case Lower(Left( idw_data.Describe(as_columnname + ".ColType"), 4))
			Case "numb","long","real","deci"
				ls_qute = ''
			Case "char" 
				ls_suffix=")"
				ls_prefix="lower("
		End Choose
		
		If Lower(Trim(as_filterstring)) = 'null' Or IsNull(as_filterstring) Then
			ls_filter = ls_filter + 'IsNull(' + as_columnname + ') '
		Else
			If Pos(as_filterstring, ',') > 0 And ib_FilterIsMultiSelect Then
				
				Choose Case Lower(Left( idw_data.Describe(as_columnname + ".ColType"), 4))
					Case "char" 
						If Left(as_filterstring, 1) = '"' Then
							as_filterstring = Right(as_filterstring, Len(as_filterstring) - 1)
						End If
						If Right(as_filterstring, 1) = '"' Then
							as_filterstring = Left(as_filterstring, Len(as_filterstring) - 1)
						End If
						
						gn_globals.in_string_functions.of_parse_string(as_filterstring, '","', ls_values[])
					Case Else
						gn_globals.in_string_functions.of_parse_string(as_filterstring, ',', ls_values[])
				End Choose
				
				For ll_index = 1 To UpperBound(ls_values[])
					If Lower(Trim(ls_values[ll_index])) = 'null' Then
						ls_filter = ls_filter + 'IsNull(' + as_columnname + ') Or '
					Else
						ls_filter = ls_filter + ls_prefix + as_columnname + ls_suffix + "=" + ls_qute + ls_values[ll_index] + ls_qute + ' Or '
					End If
				Next
				
				ls_filter = Left(ls_filter, Len(ls_filter) - 4)
				
				ls_filter = '(' + ls_filter + ')'
			Else
				gn_globals.in_string_functions.of_replace_all(as_filterstring, '"', '')
				ls_filter = ls_prefix + as_columnname + ls_suffix + "=" + ls_qute + as_filterstring + ls_qute
			End If
		End If
		

	Case 'ddlb'
		If as_filterstring = is_ddlb_all_data_column Then Return '1=1'
		ls_prefix='lower('
		ls_suffix=')'
		
		ls_filter = ls_prefix + as_columnname + ls_suffix + "=" + ls_qute + as_filterstring + ls_qute
	Case Else
		
		ls_tag = Lower(Trim(idw_data.Describe(as_columnname + ".Tag")))
		if pos(ls_tag,'useslefilter') > 0 then 
			// Custom SLE Logic for DDDW's using SLE.
			ls_suffix="),"+string(ll_filter_string_length)+"))"
			ls_prefix="lower(left(lookupdisplay("
			ls_filter = ls_prefix + as_columnname + ls_suffix + "=" + ls_qute + as_filterstring + ls_qute
			
	
		else
			// This is the standard SLE Logic
			Choose Case Lower(Left( idw_data.Describe(as_columnname + ".ColType"), 4))
				Case "char" 
					ls_suffix=","+string(ll_filter_string_length)+"))"
					ls_prefix="lower(left("
					ls_filter = ls_prefix + as_columnname + ls_suffix + "=" + ls_qute + as_filterstring + ls_qute
				Case "numb","long","real","deci"
					gn_globals.in_string_functions.of_replace_all(as_filterstring, ',', '')
					If Pos(as_filterstring, '>') > 0 Or Pos(as_filterstring, '<') > 0 Or Pos(as_filterstring, '=') > 0 Then
						ls_filter = Trim(as_filterstring)
	
						Do While Pos(ls_filter, '>') > 0 Or Pos(ls_filter, '<') > 0 Or Pos(ls_filter, '=') > 0
							If Trim(ls_filter) = '<' or Trim(ls_filter) = '<=' Or Trim(ls_filter) = '>' Or Trim(ls_filter) = '>=' Or Trim(ls_filter) = '<>' Or Trim(ls_filter) = '=' Or Right(Trim(ls_filter), 1) = '-' Then Return '1=1'
							
							ll_final_position = Len(ls_filter)
							ll_position = Pos(ls_filter, '>', 3)
							If ll_position > 0 Then ll_final_position = Min(ll_position - 1, ll_final_position)
							
							ll_position = Pos(ls_filter, '<', 3)
							If ll_position > 0 Then ll_final_position = Min(ll_position - 1, ll_final_position)
	
							ll_position = Pos(ls_filter, '=', 3)
							If ll_position > 0 Then ll_final_position = Min(ll_position - 1, ll_final_position)
	
							ls_values[UpperBound(ls_values[]) + 1] = Trim(Left(ls_filter, ll_final_position))
							ls_filter = Trim(Mid(ls_filter, ll_final_position + 1, 10000))
						Loop
						
						ls_filter = ''
						
						For ll_index = 1 To UpperBound(ls_values[])
							If Left(ls_values[ll_index], 2) = '<=' Then
								ls_operator = '<='
								ls_values[ll_index] = Trim(Mid(ls_values[ll_index], 3, 10000))
							ElseIf Left(ls_values[ll_index], 2) = '>=' Then
								ls_operator = '>='
								ls_values[ll_index] = Trim(Mid(ls_values[ll_index], 3, 10000))
							ElseIf Left(ls_values[ll_index], 2) = '<>' Then
								ls_operator = '<>'
								ls_values[ll_index] = Trim(Mid(ls_values[ll_index], 3, 10000))
							ElseIf Left(ls_values[ll_index], 1) = '>' Then
								ls_operator = '>'
								ls_values[ll_index] = Trim(Mid(ls_values[ll_index], 2, 10000))
							ElseIf Left(ls_values[ll_index], 1) = '<' Then
								ls_operator = '<'
								ls_values[ll_index] = Trim(Mid(ls_values[ll_index], 2, 10000))
							ElseIf Left(ls_values[ll_index], 1) = '=' Then
								ls_operator = '='
								ls_values[ll_index] = Trim(Mid(ls_values[ll_index], 2, 10000))
							Else
								ls_operator = '='
								ls_values[ll_index] = Trim(Mid(ls_values[ll_index], 2, 10000))
							End If
								
							If Not IsNumber(ls_values[ll_index]) Then Return ''
							
							If Pos(idw_data.Describe(as_columnname + '.Format'), '%') > 0 Then
								ls_values[ll_index] = String(Double(ls_values[ll_index]) / 100.00)
							End If
							
							ls_filter = ls_filter + ' ' + as_columnname + ls_operator + ' ' + ls_values[ll_index] + ' And '
								
						Next
						
						ls_filter = Left(ls_filter, Len(ls_filter) - 5)
					Else
						If IsNumber(as_filterstring) Then
							If Pos(idw_data.Describe(as_columnname + '.Format'), '%') > 0 Then
								as_filterstring = String(Double(as_filterstring) / 100.00)
							End If
						End If
						
						ls_prefix="lower(left(string("
						ls_suffix="),"+string(ll_filter_string_length)+"))"
						ls_filter = ls_prefix + as_columnname + ls_suffix + "=" + ls_qute + as_filterstring + ls_qute
						
						If IsNumber(as_filterstring) Then
							ls_filter = ls_filter + " Or " + as_columnname + " = " + String(Double(as_filterstring))
						End If
					End If
				Case "date"
					ls_editmask = idw_data.describe(as_columnname+".editmask.mask")
				
					If Pos(ls_editmask, '!') > 0 Or Pos(ls_editmask, '?') > 0 Then
						ls_editmask = idw_data.describe(as_columnname+".format")
					End If
					
					If Lower(Trim(ls_editmask)) = '[date]' Or Lower(Trim(ls_editmask)) = '[general]' Then
						ls_editmask = '[shortdate]'
					End If
	
					ls_string_mod =",'" + ls_editmask + "')"
	
					//----------------------------------------------------------------------------------------------------------------------------------
					// Pull the date display format from the datawindow
					//-----------------------------------------------------------------------------------------------------------------------------------
					ls_prefix="lower(left(string("
					ls_suffix= ls_string_mod + ","+string(ll_filter_string_length)+"))"
					ls_filter = ls_prefix + as_columnname + ls_suffix + "=" + ls_qute + as_filterstring + ls_qute
				Case Else
					ls_filter = as_columnname + "=" + as_filterstring
			End Choose
		end if
		
End Choose

Return '(' + ls_filter + ')'
end function

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_BatchMode = ab_BatchMode
This.of_suppressdberrorevent(ib_BatchMode)
This.of_suppresserrorevent(ib_BatchMode)

end subroutine

public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic);Long	ll_index
Long	ll_viewids[]
String ls_views[]
n_report_criteria_default_engine ln_report_criteria_default_engine

If Pos(This.Describe("Datawindow.Syntax"), 'dddw.') > 0 Then
	an_menu_dynamic.of_add_item('&Show Only Dropdown Items in Report', 'distinct all', '').Checked = ib_DistinctDropdowns
End If

//lm_dynamic_menu.of_add_item('Reapply Filter', 'reapply filter', '')
an_menu_dynamic.of_add_item('C&lear All Filters', 'clear all', '')
If Not ib_BatchMode Then an_menu_dynamic.of_add_item('Create Custom Filter Expression', 'custom filter', '')

If Not IsNull(il_reportconfigid) Then
	If Not ib_BatchMode Then an_menu_dynamic.of_add_item('-', '', '')
	If Not ib_BatchMode Then an_menu_dynamic.of_add_item('&Save Filter As...', 'save view as', '')
	If Not ib_BatchMode Then an_menu_dynamic.of_add_item('&Manage Filter Views...', 'manage filter views', '')
	If Not ib_BatchMode Then an_menu_dynamic.of_add_item('-', '', '')
	If Not ib_BatchMode Then an_menu_dynamic.of_add_item('&Export Filter View To File...', 'export filter', '')
	If Not ib_BatchMode Then an_menu_dynamic.of_add_item('&Import Filter View From File...', 'import filter', '')
	
	
	ln_report_criteria_default_engine = Create n_report_criteria_default_engine
	ln_report_criteria_default_engine.of_get_views(ls_views[], ll_viewids[], il_reportconfigid, gn_globals.il_userid, 'Filter')
	Destroy ln_report_criteria_default_engine

	If Min(UpperBound(ll_viewids[]), UpperBound(ls_views[])) > 0 Then
		an_menu_dynamic.of_add_item('-', '', '')
		
		For ll_index = 1 To UpperBound(ls_views[])
			an_menu_dynamic.of_add_item(ls_views[ll_index], 'restore view', ls_views[ll_index]).Checked = ll_viewids[ll_index] = il_filterviewid
		Next
	End If
End If
end subroutine

public function string of_set_data (string as_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_data	- The || delimited string of data for the filter
//	Overview:   This will set the data into the filter as a string, this is initially for web reporting
//	Created by:	Blake Doerr
//	History: 	10/6/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_column
Double	ldble_null
String	ls_columnname[]
String	ls_values[]
String	ls_datepart
String	ls_null
String	ls_timepart
SetNull(ldble_null)
SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Parse the arguments into a column/value string
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_arguments(as_data, '||', ls_columnname[], ls_values[])

For ll_index = 1 To Min(UpperBound(ls_columnname[]), UpperBound(ls_values[]))
	//gn_globals.in_string_functions.of_replace_all(ls_values[ll_index], '&eq;', '=')
	gn_globals.in_string_functions.of_replace_all(ls_values[ll_index], '&eq;', '=')
	
	For ll_column = 1 To UpperBound(is_column_name[])
		If Right(ls_columnname[ll_index], 2) = '_0' Then ls_columnname[ll_index] = Left(ls_columnname[ll_index], Len(ls_columnname[ll_index]) - 2)
		If Lower(Trim(ls_columnname[ll_index])) <> Lower(Trim(is_column_name[ll_column])) Then Continue
			
		//----------------------------------------------------------------------------------------------------------------------------------
		// Set the data into the column based on what the column datatype is.  If the column doesn't exist, nothing will happen.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case Lower(Left(This.Describe(ls_columnname[ll_index] + '.ColType'), 4))
			Case 'numb', 'long', 'deci'
				If Trim(ls_values[ll_index]) = '' Then
					This.SetItem(1, ls_columnname[ll_index], ldble_null)
					If IsNumber(This.Describe(ls_columnname[ll_index] + '_multi.ID')) Then This.SetItem(1, ls_columnname[ll_index] + '_multi', ls_null)
				ElseIf IsNumber(ls_values[ll_index]) Then
					This.SetItem(1, ls_columnname[ll_index], Dec(ls_values[ll_index]))
					If IsNumber(This.Describe(ls_columnname[ll_index] + '_multi.ID')) And Pos(Lower(as_data), ls_columnname[ll_index] + '_multi') = 0 Then This.SetItem(1, ls_columnname[ll_index] + '_multi', ls_values[ll_index])
				End If
			Case 'date'
				ls_datepart = Trim(Left(ls_values[ll_index], Pos(ls_values[ll_index], ' ')))
				If Pos(ls_values[ll_index], ' ') > 0 Then
					ls_timepart = Trim(Mid(ls_values[ll_index], Pos(ls_values[ll_index], ' '), 100))
				End If
				
				If IsDate(ls_datepart) Then
					If Len(ls_timepart) > 0 Then
						If IsTime(ls_timepart) Then
							This.SetItem(1, ls_columnname[ll_index], DateTime(Date(ls_datepart), Time(ls_timepart)))
						Else
							This.SetItem(1, ls_columnname[ll_index], Date(ls_datepart))
						End If
					Else
						This.SetItem(1, ls_columnname[ll_index], Date(ls_datepart))		
					End If
				End If

				If IsNumber(This.Describe(ls_columnname[ll_index] + '_multi.ID')) And Pos(Lower(as_data), ls_columnname[ll_index] + '_multi') = 0 Then This.SetItem(1, ls_columnname[ll_index] + '_multi', ls_values[ll_index])

			Case 'char'
				This.SetItem(1, ls_columnname[ll_index], ls_values[ll_index])
				If IsNumber(This.Describe(ls_columnname[ll_index] + '_multi.ID')) And Pos(Lower(as_data), ls_columnname[ll_index] + '_multi') = 0 Then This.SetItem(1, ls_columnname[ll_index] + '_multi', ls_values[ll_index])
		End Choose
	Next
Next

This.of_reapply_filter()

Return ''
end function

public subroutine of_save_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will save the state as a blob object in memory to save objects
//	Created by:	Blake Doerr
//	History: 	12/15/2003 - First Created 
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
// Get the full state into the blob object
//-----------------------------------------------------------------------------------------------------------------------------------
This.GetFullState(iblob_currentstate)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dataobject to empty string in order to clear the objects
//-----------------------------------------------------------------------------------------------------------------------------------
This.DataObject = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that the state is stored
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = True
end subroutine

public subroutine of_restore_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will restored the datawindow state from the blob object variable
//	Created by:	Blake Doerr
//	History: 	12/15/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// If the state is not stored, return
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_statestored Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the full state of the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(iblob_currentstate) > 0 Then
	This.SetFullState(iblob_currentstate)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the transaction object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(This.GetTransObject()) Then
	This.SetTransObject(This.GetTransObject())
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

event editchanged;call super::editchanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event:     	EditChanged
// Overrides:  No
// Overview:   Call the of_filter function if this is not a dropdowndatawindow
// Created by: Blake Doerr
// History:    04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String ls_dropdowndatawindow_check

//Check to see if this is a dddw.  If it is not then call of_filter()

If IsValid(dwo) Then
	If Lower(This.Describe(dwo.Name + ".Edit.Style")) = 'edit' Then
		This.of_filter(Lower(dwo.Name), Lower(data))
	End If
End If

end event

event itemchanged;call super::itemchanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event:     	ItemChanged
// Overrides:  No
// Overview:   Call the of_filter function if this is a dropdowndatawindow
// Created by: Blake Doerr
// History:    04/02/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
string ls_type

If AncestorReturnValue = 1 Or AncestorReturnValue = 2 Then Return AncestorReturnValue

//Check to see if this is a dddw.  If it is then call of_filter()
If IsValid(dwo) Then
	Choose Case Lower(this.Describe(dwo.Name + ".Edit.Style"))
		Case 'sle'
		Case 'dddw'
			Choose Case Lower(Left( idw_data.Describe(dwo.Name + ".ColType"), 4))
				Case "numb","long","real","deci"
					If Not IsNumber(data) Then Return 1
			End Choose
			
			This.of_filter(Lower(dwo.Name), Lower(data))
		Case Else		
			This.of_filter(Lower(dwo.Name), Lower(data))
	End Choose
End If


end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   This will create and initialize the autofill object
// Created by: Blake Doerr
// History:    6/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------Change Log--------------------------------------------------------------------------------------
// Date    	Initials Issue#		Where       Description
// 1/19/00	KMF		14723		   of_filter	Replacement of column's old filter with new filter is now done by calling 
//															function of_replace_string_in_filter. The actual filter call and sending of 
//															subscription message is now done in the new function, as well.
//---------------------------------------------------------------------------------------------------------------------------------------------

in_datawindow_graphic_service_manager.of_add_service('n_autofill')
in_datawindow_graphic_service_manager.of_add_service ('n_multi_select_dddw_service')
//in_datawindow_graphic_service_manager.of_create_services()
end event

event scrollhorizontal;call super::scrollhorizontal;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ScrollHorizontal
// Overrides:  No
// Overview:   Prevent the horizontal scrolling of this object due to tabbing
// Created by: Blake Doerr
// History:    6/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If scrollpos <> 0 Then
	This.Modify("DataWindow.HorizontalScrollPosition='0'")
End If
end event

on u_filter_strip.create
call super::create
end on

on u_filter_strip.destroy
call super::destroy
end on

event losefocus;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      LoseFocus
//	Overrides:  Yes
//	Arguments:	
//	Overview:   Overrides ancestor script to prevent accept text from being fired, which
//             was causing a problem when the row selection service was being utilized.
//	Created by: Pat Newgent
//	History:    8/21/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

end event

event rbuttondown;call super::rbuttondown;Window lw_window
m_dynamic lm_dynamic_menu
n_menu_dynamic ln_menu_dynamic

ln_menu_dynamic = Create n_menu_dynamic
ln_menu_dynamic.of_set_target(This)

This.of_build_menu(ln_menu_dynamic)

lm_dynamic_menu = Create m_dynamic
lm_dynamic_menu.of_set_menuobject(ln_menu_dynamic)


//----------------------------------------------------------------------------------------------------------------------------------
// Promote the datawindow to Get the parent window of the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window = This.of_getparentwindow()

//----------------------------------------------------------------------------------------------------------------------------------
// Pop the menu differently based on the window type
//-----------------------------------------------------------------------------------------------------------------------------------
if lw_window.windowtype = Response! Or lw_window.windowtype = Popup! Or Not isvalid(w_mdi.getactivesheet()) Or (w_mdi.getactivesheet() <> lw_window) then
	lm_dynamic_menu.popmenu(lw_window.pointerx(), lw_window.pointery())
else
	lm_dynamic_menu.popmenu(w_mdi.pointerx(), w_mdi.pointery())
end if

end event

event resize;call super::resize;This.of_reposition()
end event

