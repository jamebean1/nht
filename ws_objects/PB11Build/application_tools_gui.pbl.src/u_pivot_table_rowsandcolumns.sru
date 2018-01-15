$PBExportHeader$u_pivot_table_rowsandcolumns.sru
forward
global type u_pivot_table_rowsandcolumns from u_dynamic_gui
end type
type dw_graph_y_options from datawindow within u_pivot_table_rowsandcolumns
end type
type dw_graph_x_options from datawindow within u_pivot_table_rowsandcolumns
end type
type st_2 from statictext within u_pivot_table_rowsandcolumns
end type
type dw_available from datawindow within u_pivot_table_rowsandcolumns
end type
type dw_grandtotal from datawindow within u_pivot_table_rowsandcolumns
end type
type rb_graph from radiobutton within u_pivot_table_rowsandcolumns
end type
type rb_chart from radiobutton within u_pivot_table_rowsandcolumns
end type
type gb_1 from groupbox within u_pivot_table_rowsandcolumns
end type
type dw_aggregates from datawindow within u_pivot_table_rowsandcolumns
end type
type dw_rows from datawindow within u_pivot_table_rowsandcolumns
end type
type dw_columns from datawindow within u_pivot_table_rowsandcolumns
end type
type st_1 from statictext within u_pivot_table_rowsandcolumns
end type
type dw_graph_series_options from datawindow within u_pivot_table_rowsandcolumns
end type
end forward

global type u_pivot_table_rowsandcolumns from u_dynamic_gui
integer width = 3291
integer height = 1356
long backcolor = 79741120
long tabbackcolor = 12632256
dw_graph_y_options dw_graph_y_options
dw_graph_x_options dw_graph_x_options
st_2 st_2
dw_available dw_available
dw_grandtotal dw_grandtotal
rb_graph rb_graph
rb_chart rb_chart
gb_1 gb_1
dw_aggregates dw_aggregates
dw_rows dw_rows
dw_columns dw_columns
st_1 st_1
dw_graph_series_options dw_graph_series_options
end type
global u_pivot_table_rowsandcolumns u_pivot_table_rowsandcolumns

type variables
Protected:
  	n_pivot_table_service in_pivot_table_service
//  	Datastore ids_stored_data
	PowerObject io_datasource
		String 	is_page[]
		String 	is_columns[], is_headers[], is_datatype[]
		Boolean 	ib_there_has_been_a_change = False
		Boolean 	ib_open_in_new_window = False
		Boolean	ib_WeAreGraphingInsteadOfPivoting = False

//Validation Variables
Long il_maximum_number_of_rows = 20
Long il_maximum_number_of_columns = 1
Long il_maximum_number_of_aggregates = 20

//GUI Variables
Long il_rowrightclickedon, il_available_clickedrow, il_column_clickedrow, il_aggregate_clickedrow, il_row_clickedrow
m_dynamic im_menu
Long il_number_of_columns_selected = 0
n_datawindow_tools in_datawindow_tools
end variables

forward prototypes
protected function boolean of_is_column_used (string as_columnname)
protected function string of_get_header (string as_columnname)
public subroutine of_open_in_new_window ()
public function string of_validate ()
public function boolean of_is_modified ()
protected subroutine of_clear_error_message ()
public subroutine of_doubleclicked (datawindow adw_target, long row)
protected subroutine of_error_message (string as_error_message)
public subroutine of_filter_functions ()
protected function string of_delete_column (long al_rownumber)
public function string of_get_datatype (string as_columnname)
public subroutine of_change_occurred ()
protected subroutine of_add_row (long al_rownumber, long al_beforerow)
public subroutine of_set_graphing (boolean ab_graphing)
protected subroutine of_add_column (long al_rownumber, long al_beforerow)
public subroutine of_set_pivot_table_service (n_pivot_table_service an_pivot_table_service)
protected subroutine of_add_aggregate (long al_rownumber, long al_beforerow)
protected subroutine of_get_current_state ()
public function n_pivot_table_service of_apply ()
end prototypes

protected function boolean of_is_column_used (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_is_column_used()
//	Arguments:  as_columnname - The column name to check
//					adw_ignore - The datawindow to ignore (This is necessary when you are moving a column from one dw to another)
//	Overview:   This will check to see if the column is already used
//	Created by:	Blake Doerr
//	History: 	12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the column is already used in the columns datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_columns.RowCount() > 0 Then
	For ll_index = 1 To 4
		If Lower(Trim(dw_columns.GetItemString(1, 'databasename' + String(ll_index)))) = Lower(Trim(as_columnname)) Then
			of_error_message('You cannot have the same column twice')
			Return True
		End If
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the column is already used in the aggregates datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To dw_aggregates.RowCount()
	If Lower(Trim(dw_aggregates.GetItemString(ll_index, 'databasename'))) = Lower(Trim(as_columnname)) Then
		of_error_message('You cannot have the same aggregate twice')
		Return True
	End If
Next


//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the column is already used in the rows datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To dw_rows.RowCount()
	If Lower(Trim(dw_rows.GetItemString(ll_index, 'databasename'))) = Lower(Trim(as_columnname)) Then
		of_error_message('You cannot have the same row twice')
		Return True
	End If
Next


Return False
end function

protected function string of_get_header (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_header()
//	Arguments:  as_columnname - The name of the column
//	Overview:   This will return the stored datatype of the column from the array
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index
String ls_null
String	ls_headers[]
String	ls_return

For ll_index = 1 To UpperBound(is_columns[])
	If Lower(Trim(is_columns[ll_index])) = Lower(Trim(as_columnname)) Then
		Return is_headers[ll_index]
	End If
Next
ls_headers[] = is_headers[]

For ll_index = 1 To UpperBound(ls_headers[])
	ls_headers[ll_index] = '[' + ls_headers[ll_index] + ']'
Next

Return in_datawindow_tools.of_translate_expression(as_columnname, is_columns[], ls_headers[])
end function

public subroutine of_open_in_new_window ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_open_in_new_window()
//	Overview:   This will turn on the option to open the report in a new window
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_open_in_new_window = True
end subroutine

public function string of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate()
//	Overview:   This will determine if there is a valid set of selections for the pivot table
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_xaxis, ls_yaxis, ls_series
Boolean	lb_IsSeries
Long		ll_index

If ib_WeAreGraphingInsteadOfPivoting Then
	ls_xaxis			= dw_graph_x_options.GetItemString(1, 'databasename')
	ls_yaxis			= dw_graph_y_options.GetItemString(1, 'databasename')
	ls_series		= dw_graph_series_options.GetItemString(1, 'series')
	lb_IsSeries 	= (dw_graph_series_options.GetItemString(1, 'IsSeries') = 'Y')
	
	If IsNull(ls_xaxis) Or Trim(ls_xaxis) = '' Then
		Return 'You must select a column for the x axis (category).'
	End If

	If IsNull(ls_yaxis) Or Trim(ls_yaxis) = '' Then
		Return 'You must select a column for the y axis (value).'
	End If
	
	If lb_IsSeries And (IsNull(ls_series) Or Trim(ls_series) = '') Then
		Return 'You must select a column for the series, unless you uncheck the box.'
	End If
	
Else
	If Not dw_rows.RowCount() > 0 Then
		Return 'You must select at least one row for the grid.'
	End If
	
	For ll_index = 1 To dw_aggregates.RowCount()
		Choose Case Lower(Trim(dw_aggregates.GetItemString(ll_index, 'aggregatetype')))
			Case 'weightedaverage', 'divide'
				If Len(Trim(dw_aggregates.GetItemString(ll_index, 'columnnameweight'))) <= 0 Or Lower(Trim(dw_aggregates.GetItemString(ll_index, 'columnnameweight'))) = '(none)' Then
					Return 'You must select a column to aggregate on when using weighted average or divide.'
				End If
		End Choose
	Next
End If

Return ''
end function

public function boolean of_is_modified ();Return ib_there_has_been_a_change
end function

protected subroutine of_clear_error_message ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clear_error_message()
//	Arguments:  as_error_message - The message to present
//	Overview:   This will provide one place for error messages
//	Created by:	Blake Doerr
//	History: 	12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
end subroutine

public subroutine of_doubleclicked (datawindow adw_target, long row);//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------
Window 	lw_window
n_bag		ln_bag
String	ls_window_name

//-----------------------------------------------------
// If the row is invalid, return
//-----------------------------------------------------
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Create a bag object and set all the information
//-----------------------------------------------------
ln_bag = Create n_bag

//-----------------------------------------------------
// Handle the column datawindow differently
//-----------------------------------------------------
Choose Case adw_target
	Case dw_rows
		ln_bag.of_set('datawindow', dw_rows)
		ls_window_name = 'w_pivot_table_wizard_element_row'
	Case dw_columns
		row = 1
		ln_bag.of_set('datawindow', dw_columns)
		ln_bag.of_set('columnsuffix', String(row))
		ls_window_name = 'w_pivot_table_wizard_element_column'
	Case dw_aggregates
		ln_bag.of_set('datawindow', dw_aggregates)
		ls_window_name = 'w_pivot_table_wizard_element_aggregate'
	Case dw_available
		ln_bag.of_set('datawindow', dw_available)
		ls_window_name = 'w_pivot_table_wizard_element_available'
	Case dw_grandtotal
		ln_bag.of_set('datawindow', dw_grandtotal)
		ls_window_name = 'w_pivot_table_wizard_element_report'
	Case dw_graph_x_options
		ln_bag.of_set('datawindow', dw_graph_x_options)
		ls_window_name = 'w_pivot_table_wizard_graph'
	Case dw_graph_y_options
		ln_bag.of_set('datawindow', dw_graph_y_options)
		ls_window_name = 'w_pivot_table_wizard_graph'
End Choose

ln_bag.of_set('datasource', io_datasource)
ln_bag.of_set('u_pivot_table_rowsandcolumns', This)
ln_bag.of_set('row', row)

//-----------------------------------------------------
// Open the expression datawindow
//-----------------------------------------------------
OpenWithParm(lw_window, ln_bag, ls_window_name, Parent)

Destroy ln_bag
end subroutine

protected subroutine of_error_message (string as_error_message);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_error_message()
//	Arguments:  as_error_message - The message to present
//	Overview:   This will provide one place for error messages
//	Created by:	Blake Doerr
//	History: 	12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

gn_globals.in_messagebox.of_messagebox(as_error_message, Information!, OK!, 1)
end subroutine

public subroutine of_filter_functions ();DatawindowChild ldwc_functions, ldwc_yaxis
String	ls_columnname, ls_datatype, ls_aggregatefunction
Long		ll_row



dw_graph_y_options.GetChild('yaxis', ldwc_yaxis)
dw_graph_y_options.GetChild('aggregatetype', ldwc_functions)

ls_columnname 			= dw_graph_y_options.GetItemString(1, 'yaxis')
ls_aggregatefunction = dw_graph_y_options.GetItemString(1, 'aggregatetype')

ll_row = ldwc_yaxis.Find('databasename = "' + ls_columnname + '"', 1, ldwc_yaxis.RowCount())

If ll_row <= 0 Or ll_row > ldwc_yaxis.RowCount() Then Return

ls_datatype = ldwc_yaxis.GetItemString(ll_row, 'datatype')

If Len(Trim(ls_datatype)) = 0 Then
	ldwc_functions.SetFilter('')
Else
	ldwc_functions.SetFilter('datatype = "all" or datatype = "' + ls_datatype + '"')
End If

ldwc_functions.Filter()

If Not ldwc_functions.Find('function = "' + ls_aggregatefunction + '"',1, ldwc_functions.RowCount()) > 0 Then
	dw_graph_y_options.SetItem(1, 'aggregatetype', 'count')
End If
end subroutine

protected function string of_delete_column (long al_rownumber);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_column()
//	Arguments:  al_rownumber - The row number of the one to add
//	Overview:   This will add a column to the pivot diagram
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_null
String ls_databasename, ls_columnname, ls_null

SetNull(ls_null)
SetNull(ll_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return on error conditions
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_columns.RowCount() <= 0 Or al_rownumber < 0 Or IsNull(al_rownumber) Or al_rownumber > 4 Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column name for later
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columnname = dw_columns.GetItemString(1, 'databasename' + String(al_rownumber))

//-----------------------------------------------------------------------------------------------------------------------------------
// Decrement the number of columns used
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ls_columnname) And Len(ls_columnname) > 0 Then
	il_number_of_columns_selected = il_number_of_columns_selected - 1
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Propogate columns forward if necessary
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 3 To al_rownumber Step -1
		dw_columns.SetItem(1, 'databasename' 		+ String(ll_index), 	dw_columns.GetItemString(1, 'databasename' 		+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'columnname' 			+ String(ll_index), 	dw_columns.GetItemString(1, 'columnname' 			+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'datatype' 			+ String(ll_index), 	dw_columns.GetItemString(1, 'datatype' 			+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'iscomputedfield' 	+ String(ll_index), 	dw_columns.GetItemString(1, 'iscomputedfield'	+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'sortdirection' 		+ String(ll_index), 	dw_columns.GetItemString(1, 'sortdirection' 		+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'width' 				+ String(ll_index), 	dw_columns.GetItemNumber(1, 'width' 				+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'widthtype' 			+ String(ll_index), 	dw_columns.GetItemString(1, 'widthtype' 			+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'format' 				+ String(ll_index), 	dw_columns.GetItemString(1, 'format' 				+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'formattype' 			+ String(ll_index), 	dw_columns.GetItemString(1, 'formattype' 			+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'fillindategaps'		+ String(ll_index),	dw_columns.GetItemString(1, 'fillindategaps' 	+ String(ll_index + 1)))
		dw_columns.SetItem(1, 'dategaptype'			+ String(ll_index),	dw_columns.GetItemString(1, 'dategaptype' 		+ String(ll_index + 1)))
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the information into the last column as nulls
	//-----------------------------------------------------------------------------------------------------------------------------------
	dw_columns.SetItem(1, 'databasename4'		, 	ls_null)
	dw_columns.SetItem(1, 'columnname4' 		, 	ls_null)
	dw_columns.SetItem(1, 'datatype4' 			, 	ls_null)
	dw_columns.SetItem(1, 'iscomputedfield4' 	, 	'N')
	dw_columns.SetItem(1, 'sortdirection4' 	, 	' ')
	dw_columns.SetItem(1, 'width4' 				, 	500)
	dw_columns.SetItem(1, 'widthtype4' 			, 	'O')
	dw_columns.SetItem(1, 'format4' 				, 	'[general]')
	dw_columns.SetItem(1, 'formattype4' 		, 	'O')
	dw_columns.SetItem(1, 'fillindategaps4'	,	'N')
	dw_columns.SetItem(1, 'dategaptype4'		,	'M')
End If

Return ls_columnname
end function

public function string of_get_datatype (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_datatype()
//	Arguments:  as_columnname - The name of the column
//	Overview:   This will return the stored datatype of the column from the array
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long 		ll_index

For ll_index = 1 To UpperBound(is_columns[])
	If Lower(Trim(is_columns[ll_index])) = Lower(Trim(as_columnname)) Then
		Return is_datatype[ll_index]
	End If
Next

Return in_pivot_table_service.of_get_coltype(Lower(Trim(as_columnname)))

end function

public subroutine of_change_occurred ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_change_occurred()
//	Overview:   A change has occurred
//	Created by:	Blake Doerr
//	History: 	1/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Boolean	lb_uncheck_all	= False
Boolean	lb_check_all	= False

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure we know that there has been a change
//-----------------------------------------------------------------------------------------------------------------------------------
ib_there_has_been_a_change = True

This.Event ue_notify('Change Occurred', '')

If dw_grandtotal.RowCount() > 0 Then
	If dw_aggregates.RowCount() > 1 Then
		dw_grandtotal.SetItem(1, 'therearemultipleaggregates', 'Y')
	Else
		dw_grandtotal.SetItem(1, 'therearemultipleaggregates', 'N')
	End If
	
	If dw_aggregates.RowCount() > 0 Then
		If dw_aggregates.Find("ispivoted = 'N'", 1, dw_aggregates.RowCount()) > 0 Then
			dw_grandtotal.SetItem(1, 'therearenosinglecolumns', 'N')
		Else
			dw_grandtotal.SetItem(1, 'therearenosinglecolumns', 'Y')
		End If
	Else
		dw_grandtotal.SetItem(1, 'therearenosinglecolumns', 'Y')
	End If

	If dw_columns.RowCount() > 0 Then
		If Len(Trim(dw_columns.GetItemString(1, 'databasename1'))) > 0 Then
			dw_grandtotal.SetItem(1, 'thereisacolumn', 'Y')
		Else
			dw_grandtotal.SetItem(1, 'thereisacolumn', 'N')
		End If
	Else
		dw_grandtotal.SetItem(1, 'thereisacolumn', 'N')
	End If
End If


For ll_index = 1 To dw_rows.RowCount() - 1
	If dw_rows.GetItemString(ll_index, 'creategroup') = 'N' Then
		lb_uncheck_all = True
		Continue
	End If
	
	If lb_uncheck_all Then
		dw_rows.SetItem(ll_index, 'creategroup', 'N')
	End If
Next

For ll_index = dw_rows.RowCount() - 1 To 1 Step -1
	If dw_rows.GetItemString(ll_index, 'creategroup') = 'Y' Then
		lb_check_all = True
		Continue
	End If
	
	If lb_check_all Then
		dw_rows.SetItem(ll_index, 'creategroup', 'Y')
	End If
Next

If dw_rows.RowCount() > 0 Then
	dw_rows.SetItem(dw_rows.RowCount(), 'creategroup', 'Y')
	dw_rows.SetItem(dw_rows.RowCount(), 'suppressrepeatingvalues', 'N')
End If
end subroutine

protected subroutine of_add_row (long al_rownumber, long al_beforerow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_row()
//	Arguments:  al_rownumber - The row number of the one to add
//	Overview:   This will add a row to the pivot diagram
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row, ll_index, ll_width
String ls_databasename, ls_format

//-----------------------------------------------------------------------------------------------------------------------------------
// Store that a change has occurred
//-----------------------------------------------------------------------------------------------------------------------------------
This.Post of_change_occurred()

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the row number is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_available.RowCount() < al_rownumber Then
	of_error_message('Invalid Row Number passed to Add Row Function')
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column of interest
//-----------------------------------------------------------------------------------------------------------------------------------
ls_databasename 	= dw_available.GetItemString(al_rownumber, 'databasename')
ll_width				= dw_available.GetItemNumber(al_rownumber, 'width')
ls_format			= dw_available.GetItemString(al_rownumber, 'format')

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if we have reached a limit on columns
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_rows.RowCount() >= il_maximum_number_of_rows Then
	of_error_message('You may not have more than ' + String(il_maximum_number_of_rows) + ' row(s) in the current version of the Pivot Table Wizard.')
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the column is used
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_is_column_used(ls_databasename) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert the row into the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = dw_rows.InsertRow(al_beforerow)
dw_rows.SetItem(ll_row, 'databasename', 	ls_databasename)
dw_rows.SetItem(ll_row, 'columnname', 		This.of_get_header(ls_databasename))
dw_rows.SetItem(ll_row, 'datatype', 		This.of_get_datatype(ls_databasename))
dw_rows.SetItem(ll_row, 'sortdirection', 	' ')
dw_rows.SetItem(ll_row, 'IsComputedField', 	'N')
dw_rows.SetItem(ll_row, 'width', 			ll_width)
dw_rows.SetItem(ll_row, 'format', 			ls_format)
dw_rows.SetItem(ll_row, 'groupresetpagecount', 	'N')
dw_rows.SetItem(ll_row, 'groupnewpageongroupbreak', 	'N')
dw_rows.SetItem(ll_row, 'CreateGroup', 	'Y')
dw_rows.SetItem(ll_row, 'SuppressRepeatingValues', 	'N')



end subroutine

public subroutine of_set_graphing (boolean ab_graphing);ib_WeAreGraphingInsteadOfPivoting 	= ab_graphing
dw_aggregates.Visible 					= Not ab_graphing
dw_available.Visible 					= Not ab_graphing
dw_columns.Visible 						= Not ab_graphing
dw_grandtotal.Visible 					= Not ab_graphing
dw_graph_x_options.Visible 			= ab_graphing
dw_graph_y_options.Visible 		 	= ab_graphing
dw_graph_series_options.Visible 	 	= ab_graphing
//dw_graph_options.Visible		 		= ab_graphing
dw_rows.Visible 						 	= Not ab_graphing
st_1.Visible 							 	= Not ab_graphing
st_2.Visible 								= Not ab_graphing
rb_graph.Checked 							= ib_WeAreGraphingInsteadOfPivoting
rb_chart.Checked 							= Not ib_WeAreGraphingInsteadOfPivoting

dw_graph_series_options.BringToTop = True
dw_graph_x_options.BringToTop = True
dw_graph_y_options.BringToTop = True
gb_1.BringToTop 						   = True
rb_graph.BringToTop 					 	= True
rb_chart.BringToTop 						= True

end subroutine

protected subroutine of_add_column (long al_rownumber, long al_beforerow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_column()
//	Arguments:  al_rownumber - The row number of the one to add
//	Overview:   This will add a column to the pivot diagram
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row, ll_index, ll_row_to_insert_into, ll_width
String ls_databasename, ls_format

//-----------------------------------------------------------------------------------------------------------------------------------
// Store that a change has occurred
//-----------------------------------------------------------------------------------------------------------------------------------
This.Post of_change_occurred()

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to make sure that the row number is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_available.RowCount() < al_rownumber Then
	of_error_message('Invalid Row Number passed to Add Column Function')
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column name of interest
//-----------------------------------------------------------------------------------------------------------------------------------
ls_databasename 	= dw_available.GetItemString(al_rownumber, 'databasename')
ll_width				= dw_available.GetItemNumber(al_rownumber, 'width')
ls_format			= dw_available.GetItemString(al_rownumber, 'format')

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure we haven't reached the maximum
//-----------------------------------------------------------------------------------------------------------------------------------
If il_number_of_columns_selected >= il_maximum_number_of_columns Then
	of_error_message('You may not have more than ' + String(il_maximum_number_of_columns) + ' column(s) in the current version of the Pivot Table Wizard.')
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the column is used
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_is_column_used(ls_databasename) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Increment the number of columns used
//-----------------------------------------------------------------------------------------------------------------------------------
il_number_of_columns_selected = il_number_of_columns_selected + 1
ll_row_to_insert_into = al_beforerow

If ll_row_to_insert_into = 0 Or IsNull(ll_row_to_insert_into) Then
	ll_row_to_insert_into = il_number_of_columns_selected
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert a row if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_columns.RowCount() = 0 Then
	ll_row = dw_columns.InsertRow(0)
Else
	ll_row = 1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Propogate columns forward if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
If il_number_of_columns_selected <> ll_row_to_insert_into Then
	For ll_index = il_number_of_columns_selected To ll_row_to_insert_into + 1 Step -1
		dw_columns.SetItem(ll_row, 'databasename' + String(ll_index), 	dw_columns.GetItemString(ll_row, 'databasename' + String(ll_index - 1)))
		dw_columns.SetItem(ll_row, 'columnname' 	+ String(ll_index), 	dw_columns.GetItemString(ll_row, 'columnname' 	+ String(ll_index - 1)))
		dw_columns.SetItem(ll_row, 'datatype' 		+ String(ll_index), 	dw_columns.GetItemString(ll_row, 'datatype' 		+ String(ll_index - 1)))
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert the information into the correct column (there is only one row)
//-----------------------------------------------------------------------------------------------------------------------------------
dw_columns.SetItem(ll_row, 'databasename' 	+ String(ll_row_to_insert_into), 	ls_databasename)
dw_columns.SetItem(ll_row, 'columnname' 		+ String(ll_row_to_insert_into), 	This.of_get_header(ls_databasename))
dw_columns.SetItem(ll_row, 'datatype' 			+ String(ll_row_to_insert_into), 	This.of_get_datatype(ls_databasename))
dw_columns.SetItem(ll_row, 'sortdirection' 	+ String(ll_row_to_insert_into), 	' ')
dw_columns.SetItem(ll_row, 'iscomputedfield'	+ String(ll_row_to_insert_into), 	'N')
dw_columns.SetItem(ll_row, 'width'				+ String(ll_row_to_insert_into), 	ll_width)
dw_columns.SetItem(ll_row, 'format'				+ String(ll_row_to_insert_into), 	ls_format)
dw_columns.SetItem(ll_row, 'fillindategaps'	+ String(ll_row_to_insert_into),		'N')
dw_columns.SetItem(ll_row, 'dategaptype'		+ String(ll_row_to_insert_into),		'M')
end subroutine

public subroutine of_set_pivot_table_service (n_pivot_table_service an_pivot_table_service);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_pivot_table_service()
//	Arguments:  an_pivot_table_service - A pointer to the pivot table service
//	Overview:   This will set a pointer to the pivot table service
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

in_pivot_table_service = an_pivot_table_service

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_column_count
Long		ll_row
String 	ls_column_name
String	ls_header_name
String	ls_empty_array[]
String	ls_datatype
String	ls_columns[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]
DatawindowChild 	ldwc_xaxis
DatawindowChild	ldwc_yaxis
DatawindowChild	ldwc_seriesaxis
DatawindowChild	ldwc_aggregatedropdown
//----------------------------------------------------------------------------------------------------------------------------------
// Tell the pivot table service what the datasource is
//----------------------------------------------------------------------------------------------------------------------------------
io_datasource = in_pivot_table_service.of_get_datasource()
dw_graph_x_options.GetChild('databasename', ldwc_xaxis)
dw_graph_y_options.GetChild('databasename', ldwc_yaxis)
dw_graph_series_options.GetChild('series', ldwc_seriesaxis)
dw_aggregates.GetChild('columnnameweight', ldwc_aggregatedropdown)

If IsValid(ldwc_aggregatedropdown) Then
	ll_row = ldwc_aggregatedropdown.InsertRow(0)
	ldwc_aggregatedropdown.SetItem(ll_row, 'columnname', 		'(none)')
	ldwc_aggregatedropdown.SetItem(ll_row, 'databasename', 	'(none)')
	ldwc_aggregatedropdown.SetItem(ll_row, 'datatype', 		'(none)')
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Clear out these arrays
//----------------------------------------------------------------------------------------------------------------------------------
is_columns 	= ls_empty_array
is_headers	= ls_empty_array
is_datatype	= ls_empty_array

//----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns/computed fields and their headers with text and datatype
//----------------------------------------------------------------------------------------------------------------------------------
in_datawindow_tools.of_get_columns(io_datasource, ls_columns[], ls_headername[], ls_headertext[], ls_columntype[])
ll_column_count = Min(UpperBound(ls_columns[]), (Min(UpperBound(ls_headername[]), (Min(UpperBound(ls_headertext[]), UpperBound(ls_columntype[]))))))

//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and add them to the arrays
//----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 TO ll_column_count
	//----------------------------------------------------------------------------------------------------------------------------------
	// Get the column type translated into either string, datetime, or number
	//----------------------------------------------------------------------------------------------------------------------------------
	ls_columntype[ll_index]	= in_pivot_table_service.of_get_coltype(ls_columns[ll_index])

	//----------------------------------------------------------------------------------------------------------------------------------
	// Add these to the arrays
	//----------------------------------------------------------------------------------------------------------------------------------
	is_columns[UpperBound(is_columns) + 1] 	= ls_columns[ll_index]
	is_headers[UpperBound(is_headers) + 1] 	= ls_headertext[ll_index]
	is_datatype[UpperBound(is_datatype) + 1] 	= ls_columntype[ll_index]
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Add it to the available list
	//----------------------------------------------------------------------------------------------------------------------------------
	ll_row = dw_available.InsertRow(0)
	dw_available.SetItem(ll_row, 'columnname', 	ls_headertext[ll_index])
	dw_available.SetItem(ll_row, 'databasename', ls_columns[ll_index])
	dw_available.SetItem(ll_row, 'datatype', 		ls_columntype[ll_index])
	dw_available.SetItem(ll_row, 'width', 			Long(io_datasource.Dynamic Describe(ls_columns[ll_index] + '.Width')))
	dw_available.SetItem(ll_row, 'format', 		io_datasource.Dynamic Describe(ls_columns[ll_index] + '.Format'))

	//----------------------------------------------------------------------------------------------------------------------------------
	// Add it to the xaxis dropdown
	//----------------------------------------------------------------------------------------------------------------------------------
	ll_row = ldwc_xaxis.InsertRow(0)
	ldwc_xaxis.SetItem(ll_row, 'columnname', 		ls_headertext[ll_index])
	ldwc_xaxis.SetItem(ll_row, 'databasename', 	ls_columns[ll_index])
	ldwc_xaxis.SetItem(ll_row, 'datatype', 		ls_columntype[ll_index])

	//----------------------------------------------------------------------------------------------------------------------------------
	// Add it to the yaxis dropdown
	//----------------------------------------------------------------------------------------------------------------------------------
	ll_row = ldwc_yaxis.InsertRow(0)
	ldwc_yaxis.SetItem(ll_row, 'columnname', 		ls_headertext[ll_index])
	ldwc_yaxis.SetItem(ll_row, 'databasename', 	ls_columns[ll_index])
	ldwc_yaxis.SetItem(ll_row, 'datatype', 		ls_columntype[ll_index])

	//----------------------------------------------------------------------------------------------------------------------------------
	// Add it to the zaxis dropdown
	//----------------------------------------------------------------------------------------------------------------------------------
	ll_row = ldwc_seriesaxis.InsertRow(0)
	ldwc_seriesaxis.SetItem(ll_row, 'columnname', 	ls_headertext[ll_index])
	ldwc_seriesaxis.SetItem(ll_row, 'databasename', ls_columns[ll_index])
	ldwc_seriesaxis.SetItem(ll_row, 'datatype', 		ls_columntype[ll_index])
	
	If IsValid(ldwc_aggregatedropdown) Then
		Choose Case Lower(Left(ls_columntype[ll_index], 4))
			Case 'date', 'time', 'char', 'stri'
			Case Else
				Choose Case Lower(Trim(in_datawindow_tools.of_get_editstyle(io_datasource, ls_columns[ll_index])))
					Case 'dddw', 'ddlb'
					Case Else
						ll_row = ldwc_aggregatedropdown.InsertRow(0)
						ldwc_aggregatedropdown.SetItem(ll_row, 'columnname', 		ls_headertext[ll_index])
						ldwc_aggregatedropdown.SetItem(ll_row, 'databasename', 	ls_columns[ll_index])
						ldwc_aggregatedropdown.SetItem(ll_row, 'datatype', 		ls_columntype[ll_index])
				End Choose
		End Choose
	End If
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Sort all the dropdowns by columnname
//----------------------------------------------------------------------------------------------------------------------------------
dw_available.SetSort('columnname A')
dw_available.Sort()

ldwc_xaxis.SetSort('columnname A')
ldwc_xaxis.Sort()

ldwc_yaxis.SetSort('columnname A')
ldwc_yaxis.Sort()

ldwc_seriesaxis.SetSort('columnname A')
ldwc_seriesaxis.Sort()

ldwc_aggregatedropdown.SetSort('columnname A')
ldwc_aggregatedropdown.Sort()

//----------------------------------------------------------------------------------------------------------------------------------
// Apply the current state to the GUI
//----------------------------------------------------------------------------------------------------------------------------------
This.of_get_current_state()
end subroutine

protected subroutine of_add_aggregate (long al_rownumber, long al_beforerow);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_add_aggregate()
//	Arguments:  al_rownumber - The row number of the one to add
//	Overview:   This will add an aggregate to the pivot diagram
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_row, ll_index, ll_width
String ls_databasename, ls_datatype, ls_return, ls_format

//-----------------------------------------------------------------------------------------------------------------------------------
// Store that a change has occurred
//-----------------------------------------------------------------------------------------------------------------------------------
This.Post of_change_occurred()

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the row number is valid
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_available.RowCount() < al_rownumber Then
	of_error_message('Invalid Row Number passed to Add Aggregate Function')
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the column of interest
//-----------------------------------------------------------------------------------------------------------------------------------
ls_databasename 	= dw_available.GetItemString(al_rownumber, 'databasename')
ll_width				= dw_available.GetItemNumber(al_rownumber, 'width')
ls_format			= dw_available.GetItemString(al_rownumber, 'format')

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure we haven't reached the maximum
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_aggregates.RowCount() >= il_maximum_number_of_aggregates Then
	of_error_message('You may not have more than ' + String(il_maximum_number_of_aggregates) + ' aggregate(s) in the current version of the Pivot Table Wizard.')	
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the column is used
//-----------------------------------------------------------------------------------------------------------------------------------
If This.of_is_column_used(ls_databasename) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert the information into the aggregates datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = dw_aggregates.InsertRow(al_beforerow)
ls_datatype = This.of_get_datatype(ls_databasename)
dw_aggregates.SetItem(ll_row, 'databasename', 		ls_databasename)
dw_aggregates.SetItem(ll_row, 'columnname', 	This.of_get_header(ls_databasename))

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if it is a dropdown (if so we don't want to allow mathematical aggregations on the ID's)
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(io_datasource.Dynamic Describe(ls_databasename + '.edit.style')))
	Case 'dddw', 'ddlb', 'checkbox'
		If ls_datatype = 'number' Then ls_datatype = 'number-dddw'
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the datatype accordingly
//-----------------------------------------------------------------------------------------------------------------------------------
dw_aggregates.SetItem(ll_row, 'datatype', 		ls_datatype)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the datatype is not number the default function is count
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_datatype <> 'number' Then
	dw_aggregates.SetItem(ll_row, 'aggregatetype', 		'min')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set other default items
//-----------------------------------------------------------------------------------------------------------------------------------
dw_aggregates.SetItem(ll_row, 'pivottablerowname', '')
dw_aggregates.SetItem(ll_row, 'pivottablecolumnname', '')
dw_aggregates.SetItem(ll_row, 'IsComputedField', 'N')
dw_aggregates.SetItem(ll_row, 'width', ll_width)
dw_aggregates.SetItem(ll_row, 'format', ls_format)

end subroutine

protected subroutine of_get_current_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_current_state()
//	Overview:   This will restore the current state from the pivot table service
//	Created by:	Blake Doerr
//	History: 	12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_row
String ls_datatype
//n_string_functions ln_string_functions
il_number_of_columns_selected = 0

n_pivot_table_element		ln_pivot_table_row[]
n_pivot_table_element		ln_pivot_table_column[]
n_pivot_table_element		ln_pivot_table_aggregate[]
n_pivot_table_element		ln_pivot_table_properties

dw_rows.Reset()
dw_columns.Reset()
dw_aggregates.Reset()

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the current state from the pivot table service
//-----------------------------------------------------------------------------------------------------------------------------------
in_pivot_table_service.of_get_current_state(ln_pivot_table_row[], ln_pivot_table_column[], ln_pivot_table_aggregate[], ln_pivot_table_properties)
If Not IsValid(ln_pivot_table_properties) Then
	ln_pivot_table_properties = Create n_pivot_table_element
	ln_pivot_table_properties.ElementType = 'Properties'
End If

This.of_set_Graphing(ln_pivot_table_properties.IsGraph)

If ln_pivot_table_properties.IsGraph Then
	If UpperBound(ln_pivot_table_row[]) > 0 Then
		dw_graph_x_options.SetItem(1, 'databasename', ln_pivot_table_row[1].Column)
	End If
	
	If UpperBound(ln_pivot_table_column[]) > 0 Then
		dw_graph_series_options.SetItem(1, 'isseries', 'Y')
		dw_graph_series_options.SetItem(1, 'series', ln_pivot_table_column[1].Column)
	Else
		dw_graph_series_options.SetItem(1, 'isseries', 'N')
	End If

	If ln_pivot_table_properties.IsLegend Then
		dw_graph_series_options.SetItem(1, 'islegend', 'Y')
	Else
		dw_graph_series_options.SetItem(1, 'islegend', 'N')
	End If

	If UpperBound(ln_pivot_table_aggregate[]) > 0 Then
		dw_graph_y_options.SetItem(1, 'databasename', ln_pivot_table_aggregate[1].Column)
	End If
	
	If UpperBound(ln_pivot_table_aggregate[]) > 0 Then
		dw_graph_y_options.SetItem(1, 'aggregatetype', ln_pivot_table_aggregate[1].AggregateFunction)
	End If

	If ln_pivot_table_properties.GraphType > 0 And Not IsNull(ln_pivot_table_properties.GraphType) Then
		dw_graph_series_options.SetItem(1, 'graphtype', ln_pivot_table_properties.GraphType)
	End If
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Apply the state of the rows
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To UpperBound(ln_pivot_table_row[])
		ll_row = dw_rows.InsertRow(0)
		dw_rows.SetItem(ll_row, 'databasename', 		ln_pivot_table_row[ll_index].Column)
		If ln_pivot_table_row[ll_index].SortDirection = '' Then
			dw_rows.SetItem(ll_row, 'SortDirection', 		' ')
		Else
			dw_rows.SetItem(ll_row, 'SortDirection', 		ln_pivot_table_row[ll_index].SortDirection)
		End If
		
		If ln_pivot_table_row[ll_index].IsExpression Then
			dw_rows.SetItem(ll_row, 'columnname', 			'[' + ln_pivot_table_row[ll_index].Description + '] = ' + This.of_get_header(ln_pivot_table_row[ll_index].Expression))
		Else
			dw_rows.SetItem(ll_row, 'columnname', 			This.of_get_header(ln_pivot_table_row[ll_index].Column))
		End If
		dw_rows.SetItem(ll_row, 'datatype', 			This.of_get_datatype(ln_pivot_table_row[ll_index].Column))
		If ln_pivot_table_row[ll_index].IsExpression Then
			dw_rows.SetItem(ll_row, 'IsComputedField', 'Y')
			dw_rows.SetItem(ll_row, 'databasename', 	ln_pivot_table_row[ll_index].Expression)
		End If
		
		dw_rows.SetItem(ll_index, 'width', 			ln_pivot_table_row[ll_index].Width)
		dw_rows.SetItem(ll_index, 'widthtype', 	ln_pivot_table_row[ll_index].ColumnWidthType)
		dw_rows.SetItem(ll_index, 'format', 		ln_pivot_table_row[ll_index].Format)
		dw_rows.SetItem(ll_index, 'formattype', 	ln_pivot_table_row[ll_index].FormatType)
		dw_rows.SetItem(ll_index, 'fillindategaps', ln_pivot_table_row[ll_index].FillInDateGaps)
		dw_rows.SetItem(ll_index, 'dategaptype', 	ln_pivot_table_row[ll_index].DateGapType)

		If ln_pivot_table_row[ll_index].GroupResetPageCount Then
			dw_rows.SetItem(ll_row, 'GroupResetPageCount', 'Y')
		Else
			dw_rows.SetItem(ll_row, 'GroupResetPageCount', 'N')
		End If
		If ln_pivot_table_row[ll_index].GroupNewPageOnGroupBreak Then
			dw_rows.SetItem(ll_row, 'GroupNewPageOnGroupBreak', 'Y')
		Else
			dw_rows.SetItem(ll_row, 'GroupNewPageOnGroupBreak', 'N')
		End If
		If ln_pivot_table_row[ll_index].CreateGroup Then
			dw_rows.SetItem(ll_row, 'CreateGroup', 'Y')
		Else
			dw_rows.SetItem(ll_row, 'CreateGroup', 'N')
		End If
		If ln_pivot_table_row[ll_index].SuppressRepeatingValues Then
			dw_rows.SetItem(ll_row, 'SuppressRepeatingValues', 'Y')
		Else
			dw_rows.SetItem(ll_row, 'SuppressRepeatingValues', 'N')
		End If
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Apply the state of the columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To UpperBound(ln_pivot_table_column[])
		If dw_columns.RowCount() = 0 Then
			ll_row = dw_columns.InsertRow(0)
		End If
		il_number_of_columns_selected = il_number_of_columns_selected + 1
		dw_columns.SetItem(ll_row, 'databasename' + String(il_number_of_columns_selected), 	ln_pivot_table_column[ll_index].Column)
		If ln_pivot_table_column[ll_index].SortDirection = '' Then
			dw_columns.SetItem(ll_row, 'SortDirection' + String(il_number_of_columns_selected), ' ')
		Else
			dw_columns.SetItem(ll_row, 'SortDirection' + String(il_number_of_columns_selected), ln_pivot_table_column[ll_index].SortDirection)
		End If
		If ln_pivot_table_column[ll_index].IsExpression Then
			dw_columns.SetItem(ll_row, 'columnname' + String(il_number_of_columns_selected), 			'[' + ln_pivot_table_column[ll_index].Description + '] = ' + This.of_get_header(ln_pivot_table_column[ll_index].Expression))
		Else
			dw_columns.SetItem(ll_row, 'columnname' + String(il_number_of_columns_selected), 			This.of_get_header(ln_pivot_table_column[ll_index].Column))
		End If

		dw_columns.SetItem(ll_row, 'datatype' 		+ String(il_number_of_columns_selected), 	This.of_get_datatype(ln_pivot_table_column[ll_index].Column))	
		If ln_pivot_table_column[ll_index].IsExpression Then
			dw_columns.SetItem(ll_row, 'IsComputedField' + String(il_number_of_columns_selected), 'Y')
			dw_columns.SetItem(ll_row, 'databasename' 	+ String(il_number_of_columns_selected), 	ln_pivot_table_column[ll_index].Expression)
		End If
		
		dw_columns.SetItem(ll_index, 'width' + String(il_number_of_columns_selected), 			ln_pivot_table_column[ll_index].Width)
		dw_columns.SetItem(ll_index, 'widthtype' + String(il_number_of_columns_selected), 		ln_pivot_table_column[ll_index].ColumnWidthType)
		dw_columns.SetItem(ll_index, 'format' + String(il_number_of_columns_selected), 			ln_pivot_table_column[ll_index].Format)
		dw_columns.SetItem(ll_index, 'formattype' + String(il_number_of_columns_selected), 		ln_pivot_table_column[ll_index].FormatType)
		dw_columns.SetItem(ll_index, 'fillindategaps' + String(il_number_of_columns_selected), ln_pivot_table_column[ll_index].FillInDateGaps)
		dw_columns.SetItem(ll_index, 'dategaptype' + String(il_number_of_columns_selected), 	ln_pivot_table_column[ll_index].DateGapType)
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Apply the state of the aggregates
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To UpperBound(ln_pivot_table_aggregate[])
		ll_row = dw_aggregates.InsertRow(0)
		ls_datatype = This.of_get_datatype(ln_pivot_table_aggregate[ll_index].Column)
		dw_aggregates.SetItem(ll_row, 'databasename', 		ln_pivot_table_aggregate[ll_index].Column)

		If ln_pivot_table_aggregate[ll_index].IsExpression Then
			dw_aggregates.SetItem(ll_row, 'columnname', 			'[' + ln_pivot_table_aggregate[ll_index].Description + '] = ' + This.of_get_header(ln_pivot_table_aggregate[ll_index].Expression))
		Else
			dw_aggregates.SetItem(ll_row, 'columnname', 			This.of_get_header(ln_pivot_table_aggregate[ll_index].Column))
		End If
		
		If Len(Trim(ln_pivot_table_aggregate[ll_index].WeightedAverageColumn)) > 0 Then
			dw_aggregates.SetItem(ll_row, 'columnnameweight', 	ln_pivot_table_aggregate[ll_index].WeightedAverageColumn)
		End If
		
		If Lower(Trim(io_datasource.Dynamic Describe(ln_pivot_table_aggregate[ll_index].Column + ".Edit.Style"))) = 'dddw' And ls_datatype = 'number' Then
			ls_datatype = 'number-dddw'
		End If
	
		dw_aggregates.SetItem(ll_row, 'datatype', 		ls_datatype)	
		dw_aggregates.SetItem(ll_row, 'aggregatetype', 	ln_pivot_table_aggregate[ll_index].AggregateFunction)		
		
		If ln_pivot_table_aggregate[ll_index].ForceSingleColumn 	Then dw_aggregates.SetItem(ll_row, 'ispivoted', 		'N')		
		If ln_pivot_table_aggregate[ll_index].IsExpression 		Then
			dw_aggregates.SetItem(ll_row, 'IsComputedField', 'Y')
			dw_aggregates.SetItem(ll_row, 'databasename', ln_pivot_table_aggregate[ll_index].Expression)
		End If
		
		dw_aggregates.SetItem(ll_index, 'PivotTableRowName', 		ln_pivot_table_aggregate[ll_index].PivotTableRowName)
		dw_aggregates.SetItem(ll_index, 'PivotTableColumnName', 	ln_pivot_table_aggregate[ll_index].PivotTableColumnName)
		dw_aggregates.SetItem(ll_index, 'width', 						ln_pivot_table_aggregate[ll_index].Width)
		dw_aggregates.SetItem(ll_index, 'widthtype',					ln_pivot_table_aggregate[ll_index].ColumnWidthType)
		dw_aggregates.SetItem(ll_index, 'format', 					ln_pivot_table_aggregate[ll_index].Format)
		dw_aggregates.SetItem(ll_index, 'formattype',				ln_pivot_table_aggregate[ll_index].FormatType)

		If ln_pivot_table_aggregate[ll_index].ShowRowTotals Then
			dw_aggregates.SetItem(ll_index, 'ShowRowTotalsForThisElement',	'Y')
		Else
			dw_aggregates.SetItem(ll_index, 'ShowRowTotalsForThisElement',	'N')
		End If

		If ln_pivot_table_aggregate[ll_index].ShowColumnTotals Then
			dw_aggregates.SetItem(ll_index, 'ShowColumnTotalsForThisElement',	'Y')
		Else
			dw_aggregates.SetItem(ll_index, 'ShowColumnTotalsForThisElement',	'N')
		End If

		If ln_pivot_table_aggregate[ll_index].ShowColumnTotalsMultiple Then
			dw_aggregates.SetItem(ll_index, 'ShowColumnAllTotalsForThisElement',	'Y')
		Else
			dw_aggregates.SetItem(ll_index, 'ShowColumnAllTotalsForThisElement',	'N')
		End If

		If ln_pivot_table_aggregate[ll_index].OverrideColumnAggregateFunction Then
			dw_aggregates.SetItem(ll_index, 'OverrideColumnAggregateFunction',	'Y')
			dw_aggregates.SetItem(ll_index, 'ColumnAggregateFunction',	ln_pivot_table_aggregate[ll_index].ColumnAggregateFunction)
		Else
			dw_aggregates.SetItem(ll_index, 'OverrideColumnAggregateFunction',	'N')
		End If

		If ln_pivot_table_aggregate[ll_index].OverrideRowAggregateFunction Then
			dw_aggregates.SetItem(ll_index, 'OverrideRowAggregateFunction',	'Y')
			dw_aggregates.SetItem(ll_index, 'RowAggregateFunction',	ln_pivot_table_aggregate[ll_index].RowAggregateFunction)
		Else
			dw_aggregates.SetItem(ll_index, 'OverrideRowAggregateFunction',	'N')
		End If
	Next
End If

dw_grandtotal.SetItem(1, 'grandtotalcolumnaggregate', 	ln_pivot_table_properties.ColumnAllAggregateFunction)
dw_grandtotal.SetItem(1, 'BitmapX', 							ln_pivot_table_properties.BitmapX)
dw_grandtotal.SetItem(1, 'BitmapY', 							ln_pivot_table_properties.BitmapY)
dw_grandtotal.SetItem(1, 'BitmapWidth', 						ln_pivot_table_properties.BitmapWidth)
dw_grandtotal.SetItem(1, 'BitmapHeight', 						ln_pivot_table_properties.BitmapHeight)
dw_grandtotal.SetItem(1, 'ZoomPercentage', 					ln_pivot_table_properties.ZoomPercentage)
dw_grandtotal.SetItem(1, 'AdditionalDescription', 			ln_pivot_table_properties.AdditionalDescription)
dw_grandtotal.SetItem(1, 'BitmapFilename', 					ln_pivot_table_properties.BitmapFilename)
dw_grandtotal.SetItem(1, 'FooterExpression', 				ln_pivot_table_properties.FooterExpression)
dw_grandtotal.SetItem(1, 'FooterAggregateLabel', 			ln_pivot_table_properties.FooterAggregateLabel)
dw_grandtotal.SetItem(1, 'TitleType', 							ln_pivot_table_properties.TitleType)
dw_grandtotal.SetItem(1, 'FooterHeight', 						ln_pivot_table_properties.FooterHeight)
dw_grandtotal.SetItem(1, 'HeaderHeight', 						ln_pivot_table_properties.HeaderHeight)
dw_grandtotal.SetItem(1, 'titlefontsize', 					ln_pivot_table_properties.FontSize)
dw_grandtotal.SetItem(1, 'fontname', 							ln_pivot_table_properties.FontName)
dw_grandtotal.SetItem(1, 'description', 						ln_pivot_table_properties.Description)
dw_grandtotal.SetItem(1, 'ReportingDisplayObject', 		ln_pivot_table_properties.ReportingDisplayObject)

If ln_pivot_table_properties.ShowRowLabels Then
	dw_grandtotal.SetItem(1, 'ShowRowLabels', 		'Y')
Else
	dw_grandtotal.SetItem(1, 'ShowRowLabels', 		'N')
End If

If ln_pivot_table_properties.ShowColumnLabels Then
	dw_grandtotal.SetItem(1, 'ShowColumnLabels', 		'Y')
Else
	dw_grandtotal.SetItem(1, 'ShowColumnLabels', 		'N')
End If

If ln_pivot_table_properties.ModifyColumnHeaderHeight Then
	dw_grandtotal.SetItem(1, 'ModifyColumnHeaderHeight', 		'Y')
Else
	dw_grandtotal.SetItem(1, 'ModifyColumnHeaderHeight', 		'N')
End If

If ln_pivot_table_properties.ModifyColumnHeaderHeight Then
	dw_grandtotal.SetItem(1, 'ColumnHeaderHeight', 		ln_pivot_table_properties.ColumnHeaderHeight)
End If

If ln_pivot_table_properties.ShowFirstGroupAsSeparateReport Then
	dw_grandtotal.SetItem(1, 'ShowFirstGroupAsSeparateReport', 'Y')
Else
	dw_grandtotal.SetItem(1, 'ShowFirstGroupAsSeparateReport', 'N')
End If

If ln_pivot_table_properties.ShowColumnTotals Then
	dw_grandtotal.SetItem(1, 'grandtotalsforcolumns', 'Y')
Else
	dw_grandtotal.SetItem(1, 'grandtotalsforcolumns', 'N')
End If

If ln_pivot_table_properties.ShowRowTotals Then
	dw_grandtotal.SetItem(1, 'grandtotalsforrows', 'Y')
Else
	dw_grandtotal.SetItem(1, 'grandtotalsforrows', 'N')
End If

If ln_pivot_table_properties.ShowColumnTotalsMultiple Then
	dw_grandtotal.SetItem(1, 'grandtotalsforallcolumns', 'Y')
Else
	dw_grandtotal.SetItem(1, 'grandtotalsforallcolumns', 'N')
End If

If ln_pivot_table_properties.ExcludeZeroRows Then
	dw_grandtotal.SetItem(1, 'excludezerorows', 'Y')
Else
	dw_grandtotal.SetItem(1, 'excludezerorows', 'N')
End If

If ln_pivot_table_properties.ShowHeader Then
	dw_grandtotal.SetItem(1, 'ShowHeader', 'Y')
Else
	dw_grandtotal.SetItem(1, 'ShowHeader', 'N')
End If

If ln_pivot_table_properties.ShowFooter Then
	dw_grandtotal.SetItem(1, 'ShowFooter', 'Y')
Else
	dw_grandtotal.SetItem(1, 'ShowFooter', 'N')
End If
	
If ln_pivot_table_properties.ShowBitmap Then
	dw_grandtotal.SetItem(1, 'ShowBitmap', 'Y')
Else
	dw_grandtotal.SetItem(1, 'ShowBitmap', 'N')
End If

If ln_pivot_table_properties.ShowPageNumber Then
	dw_grandtotal.SetItem(1, 'ShowPageNumber', 'Y')
Else
	dw_grandtotal.SetItem(1, 'ShowPageNumber', 'N')
End If

If ln_pivot_table_properties.AlwaysUseGroupBySortingFirst Then
	dw_grandtotal.SetItem(1, 'AlwaysUseGroupBySortingFirst', 'Y')
Else
	dw_grandtotal.SetItem(1, 'AlwaysUseGroupBySortingFirst', 'N')
End If

If dw_aggregates.RowCount() > 1 Then
	dw_grandtotal.SetItem(1, 'therearemultipleaggregates', 'Y')
End If

If dw_aggregates.RowCount() > 0 Then
	If dw_aggregates.Find("ispivoted = 'N'", 1, dw_aggregates.RowCount()) > 0 Then
		dw_grandtotal.SetItem(1, 'therearenosinglecolumns', 'N')
	Else
		dw_grandtotal.SetItem(1, 'therearenosinglecolumns', 'Y')
	End If
Else
	dw_grandtotal.SetItem(1, 'therearenosinglecolumns', 'Y')
End If

If dw_columns.RowCount() > 0 Then
	If Len(Trim(dw_columns.GetItemString(1, 'databasename1'))) > 0 Then
		dw_grandtotal.SetItem(1, 'thereisacolumn', 'Y')
	Else
		dw_grandtotal.SetItem(1, 'thereisacolumn', 'N')
	End If
Else
	dw_grandtotal.SetItem(1, 'thereisacolumn', 'N')
End If
end subroutine

public function n_pivot_table_service of_apply ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply()
//	Overview:   This will apply the gui to the pivot table service
//	Created by:	Blake Doerr
//	History: 	2/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index
String ls_columnname
String	ls_return
n_pivot_table_service 	ln_pivot_table_service
n_pivot_table_element 	ln_pivot_table_element

//-----------------------------------------------------------------------------------------------------------------------------------
// Only apply if there is work to be done
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_there_has_been_a_change And Not ib_open_in_new_window Then Return in_pivot_table_service

If ib_open_in_new_window And IsValid(in_pivot_table_service.of_get_destination()) Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we are making a copy, we need to create another pivot table service
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_pivot_table_service = Create n_pivot_table_service
	ln_pivot_table_service.of_set_reportconfigid(in_pivot_table_service.of_get_reportconfigid())
	ln_pivot_table_service.of_set_userid(gn_globals.il_userid)
	ln_pivot_table_service.of_set_datasource(io_datasource)
	
	ln_pivot_table_service.of_set_report_object(in_pivot_table_service.of_get_report_object())
	io_datasource = ln_pivot_table_service.of_get_datasource()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// This is now our new pivot table service.  The old one can present its own gui if it wants to
	//-----------------------------------------------------------------------------------------------------------------------------------
	in_pivot_table_service = ln_pivot_table_service
End If

in_pivot_table_service.of_set_autopivot(Not ib_open_in_new_window)

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the pivot table
//-----------------------------------------------------------------------------------------------------------------------------------
in_pivot_table_service.of_reset()
ln_pivot_table_element = Create n_pivot_table_element
ln_pivot_table_element.ElementType 							= 'Properties'
ln_pivot_table_element.IsGraph 								= ib_WeAreGraphingInsteadOfPivoting
ln_pivot_table_element.IsLegend								= Upper(Trim(dw_graph_series_options.GetItemString(1, 'islegend'))) = 'Y'
ln_pivot_table_element.GraphType 							= dw_graph_series_options.GetItemNumber(1, 'graphtype')
ln_pivot_table_element.ColumnAllAggregateFunction		= dw_grandtotal.GetItemString(1, 'grandtotalcolumnaggregate')
ln_pivot_table_element.ShowColumnTotals					= dw_grandtotal.GetItemString(1, 'grandtotalsforcolumns')		= 'Y' And dw_grandtotal.GetItemString(1, 'thereisacolumn') 	= 'Y'
ln_pivot_table_element.ShowRowTotals						= dw_grandtotal.GetItemString(1, 'grandtotalsforrows')			= 'Y'
ln_pivot_table_element.ShowColumnTotalsMultiple			= dw_grandtotal.GetItemString(1, 'grandtotalsforallcolumns') 	= 'Y' And dw_grandtotal.GetItemString(1, 'therearemultipleaggregates') 	= 'Y'
ln_pivot_table_element.ExcludeZeroRows						= dw_grandtotal.GetItemString(1, 'excludezerorows') 				= 'Y'
ln_pivot_table_element.ShowHeader							= dw_grandtotal.GetItemString(1, 'ShowHeader')						= 'Y'
ln_pivot_table_element.ShowFooter							= dw_grandtotal.GetItemString(1, 'ShowFooter')						= 'Y'
ln_pivot_table_element.ShowBitmap							= dw_grandtotal.GetItemString(1, 'ShowBitmap')						= 'Y'
ln_pivot_table_element.ShowPageNumber						= dw_grandtotal.GetItemString(1, 'ShowPageNumber')					= 'Y'
ln_pivot_table_element.BitmapX								= dw_grandtotal.GetItemNumber(1, 'BitmapX')
ln_pivot_table_element.BitmapY								= dw_grandtotal.GetItemNumber(1, 'BitmapY')
ln_pivot_table_element.BitmapWidth							= dw_grandtotal.GetItemNumber(1, 'BitmapWidth')
ln_pivot_table_element.BitmapHeight							= dw_grandtotal.GetItemNumber(1, 'BitmapHeight')
ln_pivot_table_element.ZoomPercentage						= dw_grandtotal.GetItemNumber(1, 'ZoomPercentage')
ln_pivot_table_element.AdditionalDescription				= dw_grandtotal.GetItemString(1, 'AdditionalDescription')
ln_pivot_table_element.BitmapFilename						= dw_grandtotal.GetItemString(1, 'BitmapFilename')
ln_pivot_table_element.FooterExpression					= dw_grandtotal.GetItemString(1, 'FooterExpression')
ln_pivot_table_element.FooterAggregateLabel				= dw_grandtotal.GetItemString(1, 'FooterAggregateLabel')
ln_pivot_table_element.TitleType								= dw_grandtotal.GetItemString(1, 'TitleType')
ln_pivot_table_element.FooterHeight							= dw_grandtotal.GetItemNumber(1, 'FooterHeight')
ln_pivot_table_element.HeaderHeight							= dw_grandtotal.GetItemNumber(1, 'HeaderHeight')
ln_pivot_table_element.FontSize								= dw_grandtotal.GetItemNumber(1, 'titlefontsize')
ln_pivot_table_element.FontName								= dw_grandtotal.GetItemString(1, 'fontname')
ln_pivot_table_element.Description							= dw_grandtotal.GetItemString(1, 'description')
ln_pivot_table_element.ShowFirstGroupAsSeparateReport	= Upper(Trim(dw_grandtotal.GetItemString(1, 'ShowFirstGroupAsSeparateReport'))) = 'Y'
ln_pivot_table_element.ShowRowLabels						= Upper(Trim(dw_grandtotal.GetItemString(1, 'ShowRowLabels'))) = 'Y'
ln_pivot_table_element.ShowColumnLabels					= Upper(Trim(dw_grandtotal.GetItemString(1, 'ShowColumnLabels'))) = 'Y'
ln_pivot_table_element.ReportingDisplayObject			= dw_grandtotal.GetItemString(1, 'ReportingDisplayObject')
ln_pivot_table_element.AlwaysUseGroupBySortingFirst	= Upper(Trim(dw_grandtotal.GetItemString(1, 'AlwaysUseGroupBySortingFirst'))) = 'Y'


ln_pivot_table_element.ModifyColumnHeaderHeight		= Upper(Trim(dw_grandtotal.GetItemString(1, 'modifycolumnheaderheight'))) = 'Y'
If ln_pivot_table_element.ModifyColumnHeaderHeight Then
	ln_pivot_table_element.ColumnHeaderHeight = dw_grandtotal.GetItemNumber(1, 'columnheaderheight')
End If

ls_return = in_pivot_table_service.of_add_element(ln_pivot_table_element)

If ls_return <> '' Then
	gn_globals.in_messagebox.of_messagebox_validation(ls_return)
	Return in_pivot_table_service
End If

If ib_WeAreGraphingInsteadOfPivoting Then
	ln_pivot_table_element = Create n_pivot_table_element
	ln_pivot_table_element.ElementType 	= 'Row'
	//
	ln_pivot_table_element.IsExpression				= dw_graph_x_options.GetItemString(1, 'iscomputedfield') = 'Y'
		If ln_pivot_table_element.IsExpression Then
			ln_pivot_table_element.Expression 		= dw_graph_x_options.GetItemString(1, 'databasename')
			ln_pivot_table_element.Column		 		= ln_pivot_table_element.Column
			ln_pivot_table_element.Description		= ls_columnname
			If Pos(ls_columnname, '] = ') > 0 And Left(ls_columnname, 1) = '[' Then
				ln_pivot_table_element.Description 	= Left(ls_columnname, Pos(ls_columnname, '] = ') - 1)
				ln_pivot_table_element.Description 	= Right(ln_pivot_table_element.Description, Len(ln_pivot_table_element.Description) - 1)
			End If
		End If
	//
	ln_pivot_table_element.Column			= dw_graph_x_options.GetItemString(1, 'databasename')
	ls_return = in_pivot_table_service.of_add_element(ln_pivot_table_element)
	
	If ls_return <> '' Then
		gn_globals.in_messagebox.of_messagebox_validation(ls_return)
		Return in_pivot_table_service
	End If
	
	
		
	If dw_graph_series_options.GetItemString(1, 'isseries') = 'Y' Then
		ln_pivot_table_element = Create n_pivot_table_element
		ln_pivot_table_element.ElementType 	= 'Column'
		ln_pivot_table_element.Column			= dw_graph_series_options.GetItemString(1, 'series')
		ls_return = in_pivot_table_service.of_add_element(ln_pivot_table_element)
		
		If ls_return <> '' Then
			gn_globals.in_messagebox.of_messagebox_validation(ls_return)
			Return in_pivot_table_service
		End If
	End If
	
	ln_pivot_table_element = Create n_pivot_table_element
	ln_pivot_table_element.ElementType 				= 'Aggregate'
	//
	ln_pivot_table_element.IsExpression				= dw_graph_y_options.GetItemString(1, 'iscomputedfield') = 'Y'
		If ln_pivot_table_element.IsExpression Then
			ln_pivot_table_element.Expression 		= dw_graph_y_options.GetItemString(1, 'databasename')
			ln_pivot_table_element.Column		 		= ln_pivot_table_element.Column
			ln_pivot_table_element.Description		= ls_columnname
			If Pos(ls_columnname, '] = ') > 0 And Left(ls_columnname, 1) = '[' Then
				ln_pivot_table_element.Description 	= Left(ls_columnname, Pos(ls_columnname, '] = ') - 1)
				ln_pivot_table_element.Description 	= Right(ln_pivot_table_element.Description, Len(ln_pivot_table_element.Description) - 1)
			End If
		End If
	//
	ln_pivot_table_element.Column						= dw_graph_y_options.GetItemString(1, 'databasename')
	ln_pivot_table_element.AggregateFunction		= dw_graph_y_options.GetItemString(1, 'aggregatetype')
	ln_pivot_table_element.ForceSingleColumn 		= False
	ls_return = in_pivot_table_service.of_add_element(ln_pivot_table_element)
	
	If ls_return <> '' Then
		gn_globals.in_messagebox.of_messagebox_validation(ls_return)
		Return in_pivot_table_service
	End If
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the rows
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To dw_rows.RowCount()
		ln_pivot_table_element 									= Create n_pivot_table_element
		ln_pivot_table_element.ElementType 					= 'Row'
		ln_pivot_table_element.Column							= dw_rows.GetItemString(ll_index, 'databasename')
		ln_pivot_table_element.IsExpression					= dw_rows.GetItemString(ll_index, 'iscomputedfield') = 'Y'
		ln_pivot_table_element.SortDirection				= Trim(dw_rows.GetItemString(ll_index, 'SortDirection'))
		ln_pivot_table_element.Width							= dw_rows.GetItemNumber(ll_index, 'width')
		ln_pivot_table_element.ColumnWidthType				= dw_rows.GetItemString(ll_index, 'widthtype')
		ln_pivot_table_element.Format							= dw_rows.GetItemString(ll_index, 'format')
		ln_pivot_table_element.FormatType					= dw_rows.GetItemString(ll_index, 'formattype')
		ln_pivot_table_element.GroupResetPageCount		= Upper(Trim(dw_rows.GetItemString(ll_index, 'GroupResetPageCount'))) = 'Y'
		ln_pivot_table_element.GroupNewPageOnGroupBreak = Upper(Trim(dw_rows.GetItemString(ll_index, 'GroupNewPageOnGroupBreak'))) = 'Y'
		ln_pivot_table_element.CreateGroup					= Upper(Trim(dw_rows.GetItemString(ll_index, 'CreateGroup'))) = 'Y'
		ln_pivot_table_element.SuppressRepeatingValues	= Upper(Trim(dw_rows.GetItemString(ll_index, 'SuppressRepeatingValues'))) = 'Y'
		ln_pivot_table_element.FillInDateGaps				= dw_rows.GetItemString(ll_index, 'fillindategaps')
		ln_pivot_table_element.DateGapType					= dw_rows.GetItemString(ll_index, 'dategaptype')


		If ln_pivot_table_element.IsExpression Then
			ln_pivot_table_element.Expression = ln_pivot_table_element.Column
			ls_columnname = dw_rows.GetItemString(ll_index, 'columnname')
			ln_pivot_table_element.Description	= ls_columnname
			If Pos(ls_columnname, '] = ') > 0 And Left(ls_columnname, 1) = '[' Then
				ln_pivot_table_element.Description = Left(ls_columnname, Pos(ls_columnname, '] = ') - 1)
				ln_pivot_table_element.Description = Right(ln_pivot_table_element.Description, Len(ln_pivot_table_element.Description) - 1)
			End If				
		End If
		ls_return = in_pivot_table_service.of_add_element(ln_pivot_table_element)
		
		If ls_return <> '' Then
			gn_globals.in_messagebox.of_messagebox_validation(ls_return)
			Return in_pivot_table_service
		End If
	Next
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the columns
	//-----------------------------------------------------------------------------------------------------------------------------------
	If dw_columns.RowCount() > 0 Then
		For ll_index = 1 To Min(4, il_number_of_columns_selected)
			ls_columnname = dw_columns.GetItemString(1, 'databasename' + String(ll_index))
			If Len(Trim(ls_columnname)) > 0 And Not IsNull(ls_columnname) Then
				ln_pivot_table_element = Create n_pivot_table_element
				ln_pivot_table_element.ElementType 		= 'Column'
				ln_pivot_table_element.Column				= ls_columnname
				ln_pivot_table_element.IsExpression		= dw_columns.GetItemString(1, 'iscomputedfield' + String(ll_index)) = 'Y'
				ln_pivot_table_element.SortDirection	= Trim(dw_columns.GetItemString(1, 'SortDirection' + String(ll_index)))
				ln_pivot_table_element.Width				= dw_columns.GetItemNumber(1, 'width' + String(ll_index))
				ln_pivot_table_element.ColumnWidthType	= dw_columns.GetItemString(1, 'widthtype' + String(ll_index))
				ln_pivot_table_element.Format				= dw_columns.GetItemString(ll_index, 'format' + String(ll_index))
				ln_pivot_table_element.FormatType		= dw_columns.GetItemString(ll_index, 'formattype' + String(ll_index))
				ln_pivot_table_element.FillInDateGaps	= dw_columns.GetItemString(ll_index, 'fillindategaps' + String(ll_index))
				ln_pivot_table_element.DateGapType		= dw_columns.GetItemString(ll_index, 'dategaptype' + String(ll_index))

				If ln_pivot_table_element.IsExpression Then
					ln_pivot_table_element.Expression = ln_pivot_table_element.Column
					ls_columnname = dw_columns.GetItemString(1, 'columnname' + String(ll_index))
					ln_pivot_table_element.Description	= ls_columnname
					If Pos(ls_columnname, '] = ') > 0 And Left(ls_columnname, 1) = '[' Then
						ln_pivot_table_element.Description = Left(ls_columnname, Pos(ls_columnname, '] = ') - 1)
						ln_pivot_table_element.Description = Right(ln_pivot_table_element.Description, Len(ln_pivot_table_element.Description) - 1)
					End If
					
				End If
				ls_return = in_pivot_table_service.of_add_element(ln_pivot_table_element)
				
				If ls_return <> '' Then
					gn_globals.in_messagebox.of_messagebox_validation(ls_return)
					Return in_pivot_table_service
				End If
			End If
		Next
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the aggregates
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To dw_aggregates.RowCount()
		ln_pivot_table_element = Create n_pivot_table_element
		ln_pivot_table_element.ElementType 				= 'Aggregate'
		ln_pivot_table_element.Column						= dw_aggregates.GetItemString(ll_index, 'databasename')
		ln_pivot_table_element.AggregateFunction		= dw_aggregates.GetItemString(ll_index, 'aggregatetype')
		ln_pivot_table_element.ForceSingleColumn 		= dw_aggregates.GetItemString(ll_index, 'ispivoted') <> 'Y'
		ln_pivot_table_element.IsExpression				= dw_aggregates.GetItemString(ll_index, 'iscomputedfield') = 'Y'
		ln_pivot_table_element.PivotTableRowName		= dw_aggregates.GetItemString(ll_index, 'PivotTableRowName')
		ln_pivot_table_element.PivotTableColumnName	= dw_aggregates.GetItemString(ll_index, 'PivotTableColumnName')
		ln_pivot_table_element.Width						= dw_aggregates.GetItemNumber(ll_index, 'width')
		ln_pivot_table_element.ColumnWidthType			= dw_aggregates.GetItemString(ll_index, 'widthtype')
		ln_pivot_table_element.Format						= dw_aggregates.GetItemString(ll_index, 'format')
		ln_pivot_table_element.FormatType				= dw_aggregates.GetItemString(ll_index, 'formattype')
		
		ln_pivot_table_element.ShowRowTotals							= Upper(Trim(dw_aggregates.GetItemString(ll_index, 'ShowRowTotalsForThisElement'))) = 'Y'
		ln_pivot_table_element.ShowColumnTotals						= Upper(Trim(dw_aggregates.GetItemString(ll_index, 'ShowColumnTotalsForThisElement'))) = 'Y'
		ln_pivot_table_element.ShowColumnTotalsMultiple				= Upper(Trim(dw_aggregates.GetItemString(ll_index, 'ShowColumnAllTotalsForThisElement'))) = 'Y'
		ln_pivot_table_element.OverrideColumnAggregateFunction 	= Upper(Trim(dw_aggregates.GetItemString(ll_index, 'OverrideColumnAggregateFunction'))) = 'Y'
		ln_pivot_table_element.OverrideRowAggregateFunction 		= Upper(Trim(dw_aggregates.GetItemString(ll_index, 'OverrideRowAggregateFunction'))) = 'Y'
		
		If ln_pivot_table_element.OverrideColumnAggregateFunction Then
			ln_pivot_table_element.ColumnAggregateFunction = dw_aggregates.GetItemString(ll_index, 'ColumnAggregateFunction')
		End If

		If ln_pivot_table_element.OverrideRowAggregateFunction Then
			ln_pivot_table_element.RowAggregateFunction	= dw_aggregates.GetItemString(ll_index, 'RowAggregateFunction')
		End If

		Choose Case Lower(Trim(ln_pivot_table_element.AggregateFunction))
			Case 'divide', 'weightedaverage'
				ln_pivot_table_element.WeightedAverageColumn = dw_aggregates.GetItemString(ll_index, 'columnnameweight')
		End Choose
		
		If ln_pivot_table_element.IsExpression Then
			ln_pivot_table_element.Expression = ln_pivot_table_element.Column
			ls_columnname = dw_aggregates.GetItemString(ll_index, 'columnname')
			ln_pivot_table_element.Description	= ls_columnname
			If Pos(ls_columnname, '] = ') > 0 And Left(ls_columnname, 1) = '[' Then
				ln_pivot_table_element.Description = Left(ls_columnname, Pos(ls_columnname, '] = ') - 1)
				ln_pivot_table_element.Description = Right(ln_pivot_table_element.Description, Len(ln_pivot_table_element.Description) - 1)
			End If
		End If
		ls_return = in_pivot_table_service.of_add_element(ln_pivot_table_element)
		
		If ls_return <> '' Then
			gn_globals.in_messagebox.of_messagebox_validation(ls_return)
			Return in_pivot_table_service
		End If
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the changes and reset the state of this object
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = in_pivot_table_service.of_apply()

If ls_return <> '' Then
	gn_globals.in_messagebox.of_messagebox_validation(ls_return)
	Return in_pivot_table_service
End If

ib_there_has_been_a_change = False
ib_open_in_new_window 		= False

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the pivot table service, just in case it's new
//-----------------------------------------------------------------------------------------------------------------------------------
Return in_pivot_table_service
end function

on u_pivot_table_rowsandcolumns.create
int iCurrent
call super::create
this.dw_graph_y_options=create dw_graph_y_options
this.dw_graph_x_options=create dw_graph_x_options
this.st_2=create st_2
this.dw_available=create dw_available
this.dw_grandtotal=create dw_grandtotal
this.rb_graph=create rb_graph
this.rb_chart=create rb_chart
this.gb_1=create gb_1
this.dw_aggregates=create dw_aggregates
this.dw_rows=create dw_rows
this.dw_columns=create dw_columns
this.st_1=create st_1
this.dw_graph_series_options=create dw_graph_series_options
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_graph_y_options
this.Control[iCurrent+2]=this.dw_graph_x_options
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_available
this.Control[iCurrent+5]=this.dw_grandtotal
this.Control[iCurrent+6]=this.rb_graph
this.Control[iCurrent+7]=this.rb_chart
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.dw_aggregates
this.Control[iCurrent+10]=this.dw_rows
this.Control[iCurrent+11]=this.dw_columns
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.dw_graph_series_options
end on

on u_pivot_table_rowsandcolumns.destroy
call super::destroy
destroy(this.dw_graph_y_options)
destroy(this.dw_graph_x_options)
destroy(this.st_2)
destroy(this.dw_available)
destroy(this.dw_grandtotal)
destroy(this.rb_graph)
destroy(this.rb_chart)
destroy(this.gb_1)
destroy(this.dw_aggregates)
destroy(this.dw_rows)
destroy(this.dw_columns)
destroy(this.st_1)
destroy(this.dw_graph_series_options)
end on

event destructor;call super::destructor;If IsValid(im_menu) Then Destroy im_menu
Destroy in_datawindow_tools

If IsValid(in_pivot_table_service) Then
	If Not IsValid(in_pivot_table_service.of_get_destination()) Then
		Destroy in_pivot_table_service
	End If
End If
end event

event dragdrop;call super::dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      dragdrop
//	Overrides:  No
//	Arguments:	
//	Overview:   This will insert the row that is dragged
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case source
	Case dw_rows
		If il_row_clickedrow > 0 And Not IsNull(il_row_clickedrow) Then
			dw_rows.DeleteRow(il_row_clickedrow)			
			This.of_change_occurred()
		End If
	Case dw_aggregates
		If il_aggregate_clickedrow  > 0 And Not IsNull(il_aggregate_clickedrow ) Then
			dw_aggregates.DeleteRow(il_aggregate_clickedrow)
			This.of_change_occurred()
		End If
	Case dw_columns
		If il_column_clickedrow > 0 And Not IsNull(il_column_clickedrow) Then
			This.of_delete_column(il_column_clickedrow)
			This.of_change_occurred()			
		End If
End Choose
end event

event constructor;call super::constructor;in_datawindow_tools = Create n_datawindow_tools
dw_graph_series_options.BringToTop = False
dw_graph_x_options.BringToTop = True
dw_graph_y_options.BringToTop = True
This.of_set_graphing(False)

end event

event ue_refreshtheme();//
end event

type dw_graph_y_options from datawindow within u_pivot_table_rowsandcolumns
integer x = 352
integer y = 544
integer width = 2350
integer height = 176
integer taborder = 30
string dataobject = "d_pivot_table_graph_y_options"
boolean border = false
end type

event constructor;long ll_rowtodelete1, ll_rowtodelete2
Datawindowchild	ldwc_yaxis

This.InsertRow(0)

dw_graph_y_options.GetChild("aggregatetype", ldwc_yaxis)

ll_rowtodelete1 	= ldwc_yaxis.find("function = 'date' and datatype = 'datetime'", 1, ldwc_yaxis.rowcount())
ll_rowtodelete2	= ldwc_yaxis.find("function = 'time' and datatype = 'datetime'", 1, ldwc_yaxis.rowcount())

ldwc_yaxis.DeleteRow(ll_rowtodelete1)
ldwc_yaxis.DeleteRow(ll_rowtodelete2)
end event

event itemchanged;If IsValid(dwo) Then
	If dwo.Name = 'yaxis' Then Parent.Post of_filter_functions()
End If
Parent.of_change_occurred()
end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)

end event

type dw_graph_x_options from datawindow within u_pivot_table_rowsandcolumns
integer x = 352
integer y = 324
integer width = 2350
integer height = 180
integer taborder = 30
string dataobject = "d_pivot_table_graph_x_options"
boolean border = false
end type

event constructor;This.InsertRow(0)
end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)

end event

event itemchanged;Parent.of_change_occurred()
end event

type st_2 from statictext within u_pivot_table_rowsandcolumns
integer x = 2368
integer y = 36
integer width = 818
integer height = 52
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Available Columns"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_available from datawindow within u_pivot_table_rowsandcolumns
event ue_notify ( string as_message,  any aany_argument )
event ue_mousemove pbm_mousemove
event ue_lbuttondown pbm_lbuttondown
integer x = 2368
integer y = 92
integer width = 887
integer height = 1248
integer taborder = 1
string dragicon = "Dragitem.ico"
string dataobject = "d_pivot_table_available_columns"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case Lower(Trim(as_message))
   Case 'add to rows'
		Parent.of_add_row(il_rowrightclickedon, 0)
	Case 'add to columns'
		Parent.of_add_column(il_rowrightclickedon, 0)
	Case 'add to aggregate'
		Parent.of_add_aggregate(il_rowrightclickedon, 0)
   Case Else
End Choose
end event

event rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      rbuttondown
//	Overrides:  No
//	Arguments:	
//	Overview:   Present the menu to add items
//	Created by: Blake Doerr
//	History:    12.28.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Window lw_window

il_rowrightclickedon = row

If IsValid(im_menu) Then Destroy im_menu

im_menu = create m_dynamic
im_menu.of_set_object (this)
im_menu.of_add_item('Add to &Rows', 'add to rows', '')
im_menu.of_add_item('Add to &Columns', 'add to columns', '')
im_menu.of_add_item('Add to &Aggregates', 'add to aggregate', '')

//----------------------------------------------------------------------------------------------------------------------------------
// display the already created menu object.
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window = Parent.of_getparentwindow()
if lw_window.windowtype = Response! then
	im_menu.popmenu( lw_window.pointerx(), lw_window.pointery())
else
	im_menu.popmenu( w_mdi.pointerx(), w_mdi.pointery())
end if

end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragWithin
//	Overrides:  No
//	Arguments:	
//	Overview:   This will store the current row for later use
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Keep the current row
//-----------------------------------------------------------------------------------------------------------------------------------
il_available_clickedrow = row
il_rowrightclickedon = row

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if it's null and do a getrow() just in case.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(il_available_clickedrow) Then
	il_available_clickedrow = GetRow()
	il_rowrightclickedon = GetRow()
End If

This.Drag(Begin!)
end event

event dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      dragdrop
//	Overrides:  No
//	Arguments:	
//	Overview:   This will insert the row that is dragged
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case source
	Case dw_rows
		If il_row_clickedrow > 0 And Not IsNull(il_row_clickedrow) Then
			dw_rows.DeleteRow(il_row_clickedrow)
			Parent.of_change_occurred()
		End If
	Case dw_aggregates
		If il_aggregate_clickedrow  > 0 And Not IsNull(il_aggregate_clickedrow ) Then
			dw_aggregates.DeleteRow(il_aggregate_clickedrow)
			Parent.of_change_occurred()
		End If
	Case dw_columns
		If il_column_clickedrow > 0 And Not IsNull(il_column_clickedrow) Then
			Parent.of_delete_column(il_column_clickedrow)
			Parent.of_change_occurred()			
		End If
End Choose
end event

type dw_grandtotal from datawindow within u_pivot_table_rowsandcolumns
integer x = 46
integer y = 1112
integer width = 2313
integer height = 236
integer taborder = 30
string dragicon = "Dragitem.ico"
boolean bringtotop = true
string dataobject = "d_pivot_table_grand_total_aggregation"
boolean border = false
boolean livescroll = true
end type

event itemchanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ItemChanged
//	Overrides:  No
//	Arguments:	
//	Overview:   This will change the value of this column on the aggregates datawindow
//	Created by: Blake Doerr
//	History:    6/10/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Long ll_index

Parent.of_change_occurred()

/*
If IsValid(dwo) Then
	Choose Case Lower(dwo.Name)
		Case 'sumtheaggregates'
			//is_sum_the_aggregates_together = data

//			For ll_index = 1 To dw_aggregates.RowCount()
//				dw_aggregates.SetItem(ll_index, String(dwo.Name), data)
//			Next
	End Choose
End If

*/
end event

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   Initialize this object
// Created by: Blake Doerr
// History:    6/10/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.InsertRow(0)
end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)

end event

type rb_graph from radiobutton within u_pivot_table_rowsandcolumns
integer x = 87
integer y = 96
integer width = 535
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
string text = "Pivot Graph Options"
end type

event clicked;Parent.of_set_graphing(True)
Parent.of_change_occurred()
end event

event constructor;This.BringToTop = True
end event

type rb_chart from radiobutton within u_pivot_table_rowsandcolumns
integer x = 87
integer y = 40
integer width = 558
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
string text = "Pivot Chart Options"
boolean checked = true
end type

event clicked;Parent.of_set_graphing(False)
Parent.of_change_occurred()
end event

event constructor;This.BringToTop = True

end event

type gb_1 from groupbox within u_pivot_table_rowsandcolumns
boolean visible = false
integer x = 37
integer width = 718
integer height = 176
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
end type

type dw_aggregates from datawindow within u_pivot_table_rowsandcolumns
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 773
integer y = 184
integer width = 1577
integer height = 924
integer taborder = 30
string dragicon = "Dragitem.ico"
string dataobject = "d_pivot_table_selected_aggregates"
boolean livescroll = true
end type

event ue_mousemove;If flags = 1 Then
	If Left(Lower(This.GetObjectAtPointer()), Len('aggregatetype')) <> 'aggregatetype' Then
		If Left(Lower(This.GetObjectAtPointer()), Len('columnnameweight')) <> 'columnnameweight' Then
			This.Drag(Begin!)
		End If
	End If
End If
end event

event dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      dragdrop
//	Overrides:  No
//	Arguments:	
//	Overview:   This will insert the row that is dragged
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long 		ll_row
String 	ls_columnname

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case source
	Case dw_available
		If il_available_clickedrow > 0 And Not IsNull(il_available_clickedrow) Then
			If IsNull(row) Then row = 0

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			Parent.of_add_aggregate(il_available_clickedrow, row)
		End If
	Case dw_rows
		If il_row_clickedrow > 0 And Not IsNull(il_row_clickedrow) Then
			If IsNull(row) Then row = 0

			If il_row_clickedrow > 0 Then
				If dw_rows.GetItemString(il_row_clickedrow, 'IsComputedField') = 'Y' Then Return
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			If dw_rows.GetItemString(il_row_clickedrow, 'IsComputedField') = 'Y' Then Return
			
			ls_columnname 			= dw_rows.GetItemString(il_row_clickedrow, 'databasename')
			dw_rows.DeleteRow(il_row_clickedrow)
			
			ll_row = dw_available.Find("databasename = '" + ls_columnname + "'", 1, dw_available.RowCount())
			If ll_row > 0 And Not IsNull(ll_row) Then
				Parent.of_add_aggregate(ll_row, row)
			Else
				Parent.of_change_occurred()
			End If
		End If
	Case dw_columns
		If il_column_clickedrow > 0 And Not IsNull(il_column_clickedrow) Then
			If IsNull(row) Then row = 0

			If il_column_clickedrow > 0 Then
				If dw_columns.GetItemString(1, 'IsComputedField' + String(il_column_clickedrow)) = 'Y' Then Return
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_columnname = Parent.of_delete_column(il_column_clickedrow)
			ll_row = dw_available.Find("databasename = '" + ls_columnname + "'", 1, dw_available.RowCount())
			If ll_row > 0 And Not IsNull(ll_row) Then
				Parent.of_add_aggregate(ll_row, row)
			Else
				Parent.of_change_occurred()
			End If
		End If
	Case This
		If this.GetObjectAtPointer() = '' Then
			this.RowsMove(il_aggregate_clickedrow, il_aggregate_clickedrow, Primary!, this, this.RowCount() + 1, Primary!)
		Else
			this.RowsMove(il_aggregate_clickedrow, il_aggregate_clickedrow, Primary!, this, row, Primary!)
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Store that a change has occurred
		//-----------------------------------------------------------------------------------------------------------------------------------
		Parent.of_change_occurred()
End Choose

end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragWithin
//	Overrides:  No
//	Arguments:	
//	Overview:   This will store the current row for later use
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Keep the current row
//-----------------------------------------------------------------------------------------------------------------------------------
il_aggregate_clickedrow = row

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if it's null and do a getrow() just in case.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(il_aggregate_clickedrow ) Then
	il_aggregate_clickedrow  = GetRow()
End If


end event

event itemchanged;
If IsValid(dwo) And row > 0 And Not IsNull(row) And row <= This.RowCount() Then
	Choose Case dwo.Name
		Case 'aggregatetype'
			Choose Case Lower(Trim(data))
				Case 'weightedaverage', 'divide'
				Case Else
					This.SetItem(row, 'columnnameweight', '(none)')
			End Choose
	End Choose
End If

Parent.Post of_change_occurred()
end event

event doubleclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)


end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)
//
//Long ll_index
//
//If IsValid(dwo) Then
//	Choose Case Lower(dwo.Name)
//		Case 'button'
//			ib_sum_the_aggregates_together = Not ib_sum_the_aggregates_together
//			Parent.of_change_occurred()
//			For ll_index = 1 To This.RowCount()
//				If ib_sum_the_aggregates_together Then
//					This.SetItem(ll_index, String(dwo.Name), 'Y')
//				Else
//					This.SetItem(ll_index, String(dwo.Name), 'N')
//				End If
//			Next
//	End Choose
//End If
//
end event

type dw_rows from datawindow within u_pivot_table_rowsandcolumns
boolean visible = false
integer x = 37
integer y = 184
integer width = 718
integer height = 924
integer taborder = 20
string dragicon = "Dragitem.ico"
string dataobject = "d_pivot_table_selected_rows"
boolean livescroll = true
end type

event dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      dragdrop
//	Overrides:  No
//	Arguments:	
//	Overview:   This will insert the row that is dragged
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_columnname
Long ll_row

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case source
	Case dw_available
		If il_available_clickedrow > 0 And Not IsNull(il_available_clickedrow) Then
			If IsNull(row) Then row = 0

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			Parent.of_add_row(il_available_clickedrow, row)
		End If
	Case dw_aggregates
		If il_aggregate_clickedrow  > 0 And Not IsNull(il_aggregate_clickedrow ) Then
			If IsNull(row) Then row = 0

			If il_aggregate_clickedrow > 0 Then
				If dw_aggregates.GetItemString(il_aggregate_clickedrow, 'IsComputedField') = 'Y' Then Return
			End If

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_columnname = dw_aggregates.GetItemString(il_aggregate_clickedrow, 'databasename')
			dw_aggregates.DeleteRow(il_aggregate_clickedrow )

			ll_row = dw_available.Find("databasename = '" + ls_columnname + "'", 1, dw_available.RowCount())
			If ll_row > 0 And Not IsNull(ll_row) Then
				Parent.of_add_row(ll_row , row)
			Else
				Parent.of_change_occurred()
			End If
		End If
	Case dw_columns
		If il_column_clickedrow > 0 And Not IsNull(il_column_clickedrow) Then
			If IsNull(row) Then row = 0

			If il_column_clickedrow > 0 Then
				If dw_columns.GetItemString(1, 'IsComputedField' + String(il_column_clickedrow)) = 'Y' Then Return
			End If

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_columnname = Parent.of_delete_column(il_column_clickedrow)
			ll_row = dw_available.Find("databasename = '" + ls_columnname + "'", 1, dw_available.RowCount())
			If ll_row > 0 And Not IsNull(ll_row) Then
				Parent.of_add_row(ll_row, row)
			Else
				Parent.of_change_occurred()
			End If
		End If
	Case This
		If this.GetObjectAtPointer() = '' Then
			this.RowsMove(il_row_clickedrow, il_row_clickedrow, Primary!, this, this.RowCount() + 1, Primary!)
		Else
			this.RowsMove(il_row_clickedrow, il_row_clickedrow, Primary!, this, row, Primary!)
		End If
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Store that a change has occurred
		//-----------------------------------------------------------------------------------------------------------------------------------
		Parent.of_change_occurred()

End Choose
end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragWithin
//	Overrides:  No
//	Arguments:	
//	Overview:   This will store the current row for later use
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Keep the current row
//-----------------------------------------------------------------------------------------------------------------------------------
il_row_clickedrow = row

//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if it's null and do a getrow() just in case.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(il_row_clickedrow) Then
	il_row_clickedrow = GetRow()
End If

This.Drag(Begin!)
end event

event doubleclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)
end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)
//
//Long ll_index
//
//If IsValid(dwo) Then
//	Choose Case Lower(dwo.Name)
//		Case 'button'
//			ib_sum_the_aggregates_together = Not ib_sum_the_aggregates_together
//			Parent.of_change_occurred()
//			For ll_index = 1 To This.RowCount()
//				If ib_sum_the_aggregates_together Then
//					This.SetItem(ll_index, String(dwo.Name), 'Y')
//				Else
//					This.SetItem(ll_index, String(dwo.Name), 'N')
//				End If
//			Next
//	End Choose
//End If
//
end event

event itemchanged;Long	ll_index

If IsValid(dwo) Then
	Choose Case Lower(Trim(dwo.Name))
		Case 'creategroup'
			If Upper(Trim(data)) = 'Y' Then
				For ll_index = row To 1 Step -1
					This.SetItem(ll_index, 'creategroup', 'Y')
				Next
			Else
				For ll_index = row + 1 To This.RowCount() - 1
					This.SetItem(ll_index, 'creategroup', 'N')
				Next
			End If
	End Choose
End If

Parent.Post of_change_occurred()
end event

type dw_columns from datawindow within u_pivot_table_rowsandcolumns
integer x = 773
integer y = 92
integer width = 1577
integer height = 84
integer taborder = 10
string dragicon = "Dragitem.ico"
string dataobject = "d_pivot_table_selected_columns"
boolean livescroll = true
end type

event dragdrop;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      dragdrop
//	Overrides:  No
//	Arguments:	
//	Overview:   This will insert the row that is dragged
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_row
String ls_columnname

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case source
	Case dw_available
		If il_available_clickedrow > 0 And Not IsNull(il_available_clickedrow) Then
			If IsNull(row) or row = 0 Then 
				row = 0
			Else
				Choose Case Lower(Left(This.GetObjectAtPointer(), Pos(This.GetObjectAtPointer(), '~t') - 1))
					Case 'columnname1'
						row = 1
					Case 'columnname2'
						row = 2
					Case 'columnname3'
						row = 3
					Case Else
						row = 0
				End Choose
			End IF

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			Parent.of_add_column(il_available_clickedrow, row)
		End If
	Case dw_rows
		If il_row_clickedrow > 0 And Not IsNull(il_row_clickedrow) Then
			If IsNull(row) or row = 0 Then 
				row = 0
			Else
				Choose Case Lower(Left(This.GetObjectAtPointer(), Pos(This.GetObjectAtPointer(), '~t') - 1))
					Case 'columnname1'
						row = 1
					Case 'columnname2'
						row = 2
					Case 'columnname3'
						row = 3
					Case Else
						row = 0
				End Choose
			End If

			If il_row_clickedrow > 0 Then
				If dw_rows.GetItemString(il_row_clickedrow, 'IsComputedField') = 'Y' Then Return
			End If

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_columnname = dw_rows.GetItemString(il_row_clickedrow, 'databasename')
			dw_rows.DeleteRow(il_row_clickedrow)
			ll_row = dw_available.Find("databasename = '" + ls_columnname + "'", 1, dw_available.RowCount())
			If ll_row > 0 And Not IsNull(ll_row) Then
				Parent.of_add_column(ll_row, row)
			Else
				Parent.of_change_occurred()
			End If			
		End If
		
	Case dw_aggregates
		If il_aggregate_clickedrow > 0 And Not IsNull(il_aggregate_clickedrow) Then
			If IsNull(row) or row = 0 Then 
				row = 0
			Else
				Choose Case Lower(Left(This.GetObjectAtPointer(), Pos(This.GetObjectAtPointer(), '~t') - 1))
					Case 'columnname1'
						row = 1
					Case 'columnname2'
						row = 2
					Case 'columnname3'
						row = 3
					Case Else
						row = 0
				End Choose
			End If

			If il_aggregate_clickedrow > 0 Then
				If dw_aggregates.GetItemString(il_aggregate_clickedrow, 'IsComputedField') = 'Y' Then Return
			End If

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Add the column
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_columnname = dw_aggregates.GetItemString(il_aggregate_clickedrow, 'databasename')
			dw_aggregates.DeleteRow(il_aggregate_clickedrow)
			ll_row = dw_available.Find("databasename = '" + ls_columnname + "'", 1, dw_available.RowCount())
			If ll_row > 0 And Not IsNull(ll_row) Then
				Parent.of_add_column(ll_row, row)
			Else
				Parent.of_change_occurred()
			End If			
		End If
End Choose		

end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      DragWithin
//	Overrides:  No
//	Arguments:	
//	Overview:   This will store the current row for later use
//	Created by: Blake Doerr
//	History:    12.29.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Left(This.GetObjectAtPointer(), Pos(This.GetObjectAtPointer(), '~t') - 1))
	Case 'columnname1'
		row = 1
	Case 'columnname2'
		row = 2
	Case 'columnname3'
		row = 3
	Case 'columnname4'
		row = 4
	Case Else
		row = 0
End Choose

il_column_clickedrow = row

This.Drag(Begin!)


end event

event doubleclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Left(This.GetObjectAtPointer(), Pos(This.GetObjectAtPointer(), '~t') - 1))
	Case 'columnname1'
		row = 1
	Case 'columnname2'
		row = 2
	Case 'columnname3'
		row = 3
	Case 'columnname4'
		row = 4
	Case Else
		row = 0
End Choose

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)
end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event       DoubleClicked
// Overriden:  No
// Function:   
// Created by  Blake Doerr
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Return if the information isn't valid
//-----------------------------------------------------
If Not IsValid(dwo) Then Return
If row <= 0 Or IsNull(row) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Depending on the source, insert or move the row of interest
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Left(This.GetObjectAtPointer(), Pos(This.GetObjectAtPointer(), '~t') - 1))
	Case 'columnname1'
		row = 1
	Case 'columnname2'
		row = 2
	Case 'columnname3'
		row = 3
	Case 'columnname4'
		row = 4
	Case Else
		row = 1
End Choose

//-----------------------------------------------------
// Pass this to the doubleclicked function
//-----------------------------------------------------
Parent.of_doubleclicked(This, row)
end event

type st_1 from statictext within u_pivot_table_rowsandcolumns
integer x = 773
integer y = 36
integer width = 1573
integer height = 52
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Selected Column"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_graph_series_options from datawindow within u_pivot_table_rowsandcolumns
integer x = 352
integer y = 124
integer width = 2359
integer height = 960
integer taborder = 40
string dataobject = "d_pivot_table_graph_series_options"
boolean border = false
end type

event constructor;This.InsertRow(0)

end event

event itemchanged;Parent.of_change_occurred()
end event

