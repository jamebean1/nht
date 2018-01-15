$PBExportHeader$u_column_selection_external.sru
$PBExportComments$This is the object that lets you select columns to add/remove from the datawindow.  It is on w_column_selection_service which is opened from n_column_selection_service.
forward
global type u_column_selection_external from u_dynamic_gui
end type
type dw_aggregate from u_datawindow within u_column_selection_external
end type
type dw_uomconversion from datawindow within u_column_selection_external
end type
type dw_criteria_style from datawindow within u_column_selection_external
end type
type st_3 from statictext within u_column_selection_external
end type
type st_2 from statictext within u_column_selection_external
end type
type dw_available from u_datawindow within u_column_selection_external
end type
type dw_warning from datawindow within u_column_selection_external
end type
type dw_table from u_datawindow within u_column_selection_external
end type
end forward

global type u_column_selection_external from u_dynamic_gui
integer width = 2341
integer height = 1408
boolean border = false
long backcolor = 80263581
long tabbackcolor = 67108864
long picturemaskcolor = 25166016
event ue_refreshtheme ( )
event ue_column_selected ( )
dw_aggregate dw_aggregate
dw_uomconversion dw_uomconversion
dw_criteria_style dw_criteria_style
st_3 st_3
st_2 st_2
dw_available dw_available
dw_warning dw_warning
dw_table dw_table
end type
global u_column_selection_external u_column_selection_external

type variables
Protected:
	Boolean	ib_IgnoreRowFocusChange
	Boolean	ib_IgnoreRowFocusChangeColumns
	Boolean	ib_ShowOneToManyWarning			= False
	Boolean	ib_CanWeDoToMany					= False
	Boolean	ib_WeAreAddingCriteriaColumns = False
	String 	is_column[]
	String 	is_header[]
	String 	is_headertext[]
	String 	is_columntype[]
	String	is_prefix
	String	is_sourcetable
	String	is_destinationtable
	String	is_last_column_added
	String	is_uominit_expression
	Long		il_SourceTableID
	Long		il_DestinationTableID
	Long		il_reportconfigid
	
	Datawindow 								idw_data
	Datastore								ids_availablecolumns
	n_datawindow_formatting_service 	in_datawindow_formatting_service
	n_datawindow_tools 					in_datawindow_tools
	Datastore								ids_favorite_external_columns
end variables

forward prototypes
public subroutine of_get_columns ()
public subroutine of_init (n_datawindow_formatting_service an_datawindow_formatting_service)
public function string of_apply (boolean ab_reretrieve)
public subroutine of_column_selected ()
public function string of_add_to_favorites ()
public subroutine of_set_datawindowobject (string as_sourcetable, string as_destinationtable, string as_dataobject)
public function boolean of_areweaddingcriteria ()
end prototypes

public subroutine of_get_columns ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_columns()
// Arguments:   
// Overview:    This will get all the columns in a datawindow and it's header text into arrays.
//						They will most likely be used for dropdowns in datawindow services.
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_row
String	ls_empty[]
String	ls_SelectRowIndicator[]
String	ls_dbname

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear the Arrays
//-----------------------------------------------------------------------------------------------------------------------------------
is_column[]			= ls_empty[]
is_header[]			= ls_empty[]
is_headertext[]	= ls_empty[]
is_columntype[]	= ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Turn off GUI response
//-----------------------------------------------------------------------------------------------------------------------------------
ib_IgnoreRowFocusChangeColumns = True

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the columns in the selection datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
dw_available.Reset()

//-----------------------------------------------------------------------------------------------------------------------------------
// Treat Favorites different than regular tables
//-----------------------------------------------------------------------------------------------------------------------------------
If Left(Lower(Trim(is_SourceTable)), Len('FavoriteColumns')) = Lower('FavoriteColumns') Then
	For ll_index = 1 To ids_favorite_external_columns.RowCount()
		ll_row = dw_available.InsertRow(0)
		dw_available.SetItem(ll_row, 'name', ids_favorite_external_columns.GetItemString(ll_row, 'ColumnName'))
		dw_available.SetItem(ll_row, 'dbname', ids_favorite_external_columns.GetItemString(ll_row, 'TablePath'))
		dw_available.SetItem(ll_row, 'displayname', ids_favorite_external_columns.GetItemString(ll_row, 'ColumnText'))	
	Next
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the columns and translate them into English
	//-----------------------------------------------------------------------------------------------------------------------------------
	in_datawindow_tools.of_get_columns(ids_availablecolumns, is_column[], is_header[], is_headertext[], is_columntype[])
	in_datawindow_tools.of_translate_to_english(is_headertext[])
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all the available columns and insert a row into the selection datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To UpperBound(is_column[])
		ll_row = dw_available.InsertRow(0)
		dw_available.SetItem(ll_row, 'name', is_column[ll_index])
		ls_dbname = ids_availablecolumns.Describe(is_column[ll_index] + '.dbname')
		dw_available.SetItem(ll_row, 'dbname', ls_dbname)
		dw_available.SetItem(ll_row, 'displayname', is_headertext[ll_index])	
	Next

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Sort the data
	//-----------------------------------------------------------------------------------------------------------------------------------
	dw_available.Sort()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Turn on GUI response
//-----------------------------------------------------------------------------------------------------------------------------------
ib_IgnoreRowFocusChangeColumns = False

//-----------------------------------------------------------------------------------------------------------------------------------
// Trigger a retrieve end so the services react appropriately
//-----------------------------------------------------------------------------------------------------------------------------------
If dw_available.RowCount() > 0 Then
	dw_available.SetRow(1)
	dw_available.Event RetrieveEnd(dw_available.RowCount())
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Trigger column selected to prepare the GUI
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_column_selected()
end subroutine

public subroutine of_init (n_datawindow_formatting_service an_datawindow_formatting_service);//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
DatawindowChild ldwc_child
Long	ll_null
SetNull(ll_null)

in_datawindow_formatting_service = an_datawindow_formatting_service

idw_data = in_datawindow_formatting_service.of_get_datawindow()

If Not IsValid(idw_data) Then Return

il_reportconfigid = Long(idw_data.Dynamic Event ue_get_rprtcnfgid())

If il_reportconfigid <= 0 Or IsNull(il_reportconfigid) Then Return

ib_WeAreAddingCriteriaColumns = in_datawindow_formatting_service.of_get_isdynamiccriteria()

dw_table.Reset()
dw_table.SetTransObject(SQLCA)
dw_table.Retrieve(0, '', il_reportconfigid, ll_null, 'N', 'N')
dw_criteria_style.Visible 	= ib_WeAreAddingCriteriaColumns
dw_aggregate.Visible 		= Not ib_WeAreAddingCriteriaColumns

If ib_WeAreAddingCriteriaColumns Then
	dw_warning.DataObject = 'd_show_fields_external_columns_warning2'
	ib_ShowOneToManyWarning = True
	#IF defined PBDOTNET THEN
		THIS.EVENT resize(0, width, height)
	#ELSE
		THIS.TriggerEvent('resize')
	#END IF
End If

If dw_table.rowcount() > 0 Then ib_CanWeDoToMany = Upper(Trim(dw_table.getitemstring(1, 'canwedoonetomany'))) = 'Y'

end subroutine

public function string of_apply (boolean ab_reretrieve);//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_row
Long		ll_index
String	ls_style
String	ls_sourcetable
String	ls_dbname
String	ls_displayname
String	ls_tablename
String	ls_aggregatefunction
String	ls_prefix_text
String	ls_return
String	ls_SelectRowIndicator[]
String	ls_allowuomconversion
String	ls_adduomconversion

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the selected row
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = dw_available.of_getselectedrow(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row <= 0 Or IsNull(ll_row) Then Return 'Error:  There was not a row selected'

//-----------------------------------------------------------------------------------------------------------------------------------
// ???
//-----------------------------------------------------------------------------------------------------------------------------------
If is_last_column_added = dw_available.GetItemString(ll_row, 'name') Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// This will prevent any GUI responses while manipulating the datawindows
//-----------------------------------------------------------------------------------------------------------------------------------
ib_IgnoreRowFocusChangeColumns = True

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a space if there is a prefix
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(is_prefix)) > 0 Then ls_prefix_text = Trim(is_prefix) + ' '

//-----------------------------------------------------------------------------------------------------------------------------------
// Load variables needed to add the column
//-----------------------------------------------------------------------------------------------------------------------------------
is_last_column_added = dw_available.GetItemString(ll_row, 'name')
ls_displayname = ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the path to the column
//-----------------------------------------------------------------------------------------------------------------------------------
ls_dbname = dw_available.GetItemString(ll_row, 'dbname')
If Pos(ls_dbname, '.') <= 0 Then ls_dbname = is_destinationtable + '.' + ls_dbname
ls_dbname 		= is_sourcetable + ls_dbname

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are adding criteria, we need to determine the style and call the formatting service
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_WeAreAddingCriteriaColumns Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the style from the style datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_style = dw_criteria_style.GetItemString(1, 'datatype') + '.' + dw_criteria_style.GetItemString(1, 'editstyle')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Depending on the edit style, we will get the additional style parameters
	//-----------------------------------------------------------------------------------------------------------------------------------
	Choose Case Lower(Trim(dw_criteria_style.GetItemString(1, 'editstyle')))
		Case 'dddw', 'ddlb'
			ls_style = ls_style + '.' + dw_criteria_style.GetItemString(1, 'criteriatype_dddw') + '.' + dw_criteria_style.GetItemString(1, 'allowmultiselect')
		Case Else
			Choose Case Left(Lower(Trim(dw_criteria_style.GetItemString(1, 'datatype'))), 4)
				Case 'long', 'numb', 'ulon', 'deci', 'inte'
					ls_style = ls_style + '.' + dw_criteria_style.GetItemString(1, 'criteriatype_number')
				Case 'date'
					ls_style = ls_style + '.' + dw_criteria_style.GetItemString(1, 'criteriatype_date') + '.' + dw_criteria_style.GetItemString(1, 'showtimecomponent')
				Case Else
					ls_style = ls_style + '.' + dw_criteria_style.GetItemString(1, 'criteriatype_string')
			End Choose
	End Choose
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the column to the criteria datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_return = in_datawindow_formatting_service.of_add_criteria_column(dw_available.GetItemString(ll_row, 'name'), ls_dbname, ls_displayname, ids_availablecolumns, ls_style)
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// We need to treat favorite columns differently when adding them to the datawindow
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Left(Lower(Trim(is_SourceTable)), Len('FavoriteColumns')) = Lower('FavoriteColumns') Then
		If ll_row <= ids_favorite_external_columns.RowCount() Then
			//-----------------------------------------------------------------------------------------------------------------------------------
			// We need to treat favorite columns differently when adding them to the datawindow
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_dbname								= ids_favorite_external_columns.GetItemString(ll_row, 'TablePath')
			ls_displayname							= ids_favorite_external_columns.GetItemString(ll_row, 'ColumnText')
			ls_adduomconversion 					= ids_favorite_external_columns.GetItemString(ll_row, 'AddUOMConversion')
			ls_tablename							= ids_favorite_external_columns.GetItemString(ll_row, 'TableName')
			If Upper(Trim(ls_adduomconversion)) = 'Y' Then
				is_uominit_expression 			= ids_favorite_external_columns.GetItemString(ll_row, 'UOMExpression')
			End If
			
			Choose Case Lower(Trim(ls_tablename))
				Case 'generalconfiguration'
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Parse the GeneralConfiguration table out of the syntax so we can know what attributes to load
					//-----------------------------------------------------------------------------------------------------------------------------------
					ls_sourcetable = Reverse(ls_dbname)
					ls_sourcetable = Mid(ls_sourcetable, Pos(ls_sourcetable, '.') + 1)
					
					If Left(ls_sourcetable, 1) = '.' Then ls_sourcetable = Mid(ls_sourcetable, 2)
					If Left(ls_sourcetable, 1) = '.' Then ls_sourcetable = Mid(ls_sourcetable, 2)
					
					ls_sourcetable = Mid(ls_sourcetable, Pos(ls_sourcetable, '.') + 1)
					
					If Left(ls_sourcetable, 1) = '.' Then ls_sourcetable = Mid(ls_sourcetable, 2)
					If Left(ls_sourcetable, 1) = '.' Then ls_sourcetable = Mid(ls_sourcetable, 2)
					
					If Pos(ls_sourcetable, '.') > 0 Then ls_sourcetable = Left(ls_sourcetable, Pos(ls_sourcetable, '.') - 1)
					If Pos(ls_sourcetable, ')') > 0 Then ls_sourcetable = Trim(Left(ls_sourcetable, Pos(ls_sourcetable, ')') - 1))

					ls_sourcetable = Reverse(ls_sourcetable)
				Case Else
					ls_sourcetable = is_SourceTable
			End Choose
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Set the datawindow object
			//-----------------------------------------------------------------------------------------------------------------------------------
			This.of_set_datawindowobject(ls_sourcetable, ls_tablename, ids_favorite_external_columns.GetItemString(ll_row, 'TableDatawindow'))
		End If
	Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine the conversion information
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_allowuomconversion	= dw_uomconversion.GetItemString(1, 'uomconversion')
		ls_adduomconversion		= dw_uomconversion.GetItemString(1, 'allowconversion')
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Determine the UOMInit expression if it has not been done
		//-----------------------------------------------------------------------------------------------------------------------------------
		If Upper(Trim(ls_allowuomconversion)) = 'Y' And Upper(Trim(ls_adduomconversion)) = 'Y' Then
			If is_uominit_expression = '' Or IsNull(is_uominit_expression) Then
				is_uominit_expression = 'sourcecolumn1={sourcecolumn},destinationcolumn1={destinationcolumn},converttype='
				
				If Pos(Lower(is_last_column_added), 'val') > 0 Or Pos(Lower(is_last_column_added), 'vle') > 0 Then
					is_uominit_expression = is_uominit_expression + 'price'
				Else
					is_uominit_expression = is_uominit_expression + 'quantity'
				End If
			End If
		End If
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If we are aggregating, we need to modify the display string accordingly
		//-----------------------------------------------------------------------------------------------------------------------------------
		If dw_aggregate.rowcount() > 0 Then
			If dw_aggregate.getitemstring(1, 'aggregate') = 'Y' Then
				ls_aggregatefunction	= dw_aggregate.getitemstring(1, 'aggregatefunction')
				ls_dbname 				= ls_dbname + ls_aggregatefunction
				
				Choose Case ls_aggregatefunction
					Case '[Sum]'
						ls_displayname = 'Sum of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname') 
					Case '[Count]'
						ls_displayname = 'Count of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
					Case '[CountDistinct]'
						ls_displayname = 'Distinct Count of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
					Case '[Avg]'
						ls_displayname = 'Average of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
					Case '[Min]'
						ls_displayname = 'Minimum of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
					Case '[Max]'
						ls_displayname = 'Maximum of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
					Case '[STDev]'
						ls_displayname = 'Std Dev of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
					Case '[Var]'
						ls_displayname = 'Stat Var of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
				End Choose
			End If
		End If
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the column to the formatting service
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_return = in_datawindow_formatting_service.of_add_external_column(dw_available.GetItemString(ll_row, 'name'), ls_dbname, ls_displayname, ids_availablecolumns, Upper(Trim(ls_allowuomconversion)) = 'Y' And Upper(Trim(ls_adduomconversion)) = 'Y', is_uominit_expression)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the UOM expression and turn on the variable that allows the GUI to respond
//-----------------------------------------------------------------------------------------------------------------------------------
is_uominit_expression = ''
ib_IgnoreRowFocusChangeColumns = False

//-----------------------------------------------------------------------------------------------------------------------------------
// If we need to reretrieve, we will call the reretrieve function on the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
If ab_reretrieve And Not ib_WeAreAddingCriteriaColumns Then in_datawindow_formatting_service.of_reretrieve()

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the results
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_return
end function

public subroutine of_column_selected ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_row
Long		ll_table_row
String	ls_columnname
String	ls_coltype
String	ls_editstyle

ll_row = dw_available.of_getselectedrow(0)
is_uominit_expression = ''

If ib_WeAreAddingCriteriaColumns Then
	If dw_aggregate.Height <> 0 Then
		dw_aggregate.Height = 0
		#IF defined PBDOTNET THEN
			THIS.EVENT resize(0, width, height)
		#ELSE
			THIS.TriggerEvent('resize')
		#END IF
	End If

	dw_criteria_style.Reset()
	dw_criteria_style.InsertRow(0)
	
	If IsValid(ids_availablecolumns) Then
		If ll_row > 0 And ll_row <= dw_available.RowCount() And Not IsNull(ll_row) Then
			ls_columnname 	= dw_available.GetItemString(ll_row, 'name')
			ls_coltype 		= ids_availablecolumns.Describe(ls_columnname + '.ColType')
			ls_editstyle	= ids_availablecolumns.Describe(ls_columnname + '.Edit.Style')
			
			dw_criteria_style.SetItem(1, 'datatype', ls_coltype)
			dw_criteria_style.SetItem(1, 'editstyle', ls_editstyle)
		End If
	End If
Else
	dw_aggregate.Reset()
	
	ll_table_row = dw_table.of_getselectedrow(0)
	
	If Not IsNull(ll_table_row) And ll_table_row > 0 And ll_table_row <= dw_table.rowcount() Then
		If Upper(Trim(dw_table.getitemstring(ll_table_row, 'onetomanyjoinfrombasetable'))) = 'Y' Then
			dw_aggregate.InsertRow(0)
			dw_aggregate.setitem(1, 'aggregatefunction', '[Sum]')
			dw_aggregate.setitem(1, 'aggregate', 'Y')
			
			If Not ib_CanWeDoToMany Then
				dw_aggregate.setitem(1, 'allowonetomany', 'N')
			Else
				dw_aggregate.setitem(1, 'allowonetomany', 'Y')
				dw_aggregate.setitem(1, 'aggregate', 'Y')
				dw_aggregate.setitem(1, 'aggregatefunction', '[Sum]')
			End If
			
			If ll_row > 0 And ll_row <= dw_available.RowCount() And Not IsNull(ll_row) Then
				ls_columnname 	= dw_available.GetItemString(ll_row, 'name')
				ls_coltype 		= ids_availablecolumns.Describe(ls_columnname + '.ColType')
				ls_editstyle	= ids_availablecolumns.Describe(ls_columnname + '.Edit.Style')
				
				Choose Case Lower(Trim(Left(ls_editstyle, 4)))
					Case 'dddw', 'ddlb'
						dw_aggregate.setitem(1, 'aggregatefunction', '[Min]')
				End Choose
				
				Choose Case Lower(Trim(Left(ls_coltype, 4)))
					Case 'numb', 'long', 'real', 'deci', 'inte'
					Case Else
						dw_aggregate.setitem(1, 'aggregatefunction', '[Min]')
				End Choose
			End If
			
			If dw_aggregate.Height <> 88 Then
				dw_aggregate.Height = 88
				#IF defined PBDOTNET THEN
					THIS.EVENT resize(0, width, height)
				#ELSE
					THIS.TriggerEvent('resize')
				#END IF
			End If
		Else
			If dw_aggregate.Height <> 0 Then
				dw_aggregate.Height = 0
				#IF defined PBDOTNET THEN
					THIS.EVENT resize(0, width, height)
				#ELSE
					THIS.TriggerEvent('resize')
				#END IF
			End If
		End If
	Else
		If dw_aggregate.Height <> 0 Then
			dw_aggregate.Height = 0
			#IF defined PBDOTNET THEN
				THIS.EVENT resize(0, width, height)
			#ELSE
				THIS.TriggerEvent('resize')
			#END IF
		End If
	End If
	
	If ll_row > 0 And ll_row <= dw_available.RowCount() And Not IsNull(ll_row) Then
		ls_columnname 	= dw_available.GetItemString(ll_row, 'name')
		ls_coltype 		= ids_availablecolumns.Describe(ls_columnname + '.ColType')
		
		Choose Case Lower(Left(ls_coltype, 4))
			Case 'numb', 'deci', 'real'
				dw_uomconversion.SetItem(1, 'allowconversion', 'Y')
			Case Else
				dw_uomconversion.SetItem(1, 'allowconversion', 'N')
		End Choose
		
		dw_uomconversion.SetItem(1, 'uomconversion', 'N')
	End If
End If

end subroutine

public function string of_add_to_favorites ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_dao ln_dao
Long		ll_row
Long		ll_index
String	ls_gui
String	ls_dbname
String	ls_displayname
String	ls_aggregatefunction
String	ls_prefix_text
String	ls_return
String	ls_SelectRowIndicator[]
String	ls_allowuomconversion
String	ls_adduomconversion
Window	lw_window

ll_row = dw_available.of_getselectedrow(0)

If ll_row <= 0 Or IsNull(ll_row) Then Return 'Error:  There was not a row selected'
If il_reportconfigid <= 0 Or IsNull(il_reportconfigid) Then Return 'Error:  There was not a valid report config id'
If il_SourceTableID <= 0 Or IsNull(il_SourceTableID) Then Return 'Error:  There was not a valid source table'


If Len(Trim(is_prefix)) > 0 Then ls_prefix_text = Trim(is_prefix) + ' '
	
ls_displayname = ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')

ls_dbname = dw_available.GetItemString(ll_row, 'dbname')
If Pos(ls_dbname, '.') <= 0 Then ls_dbname = is_destinationtable + '.' + ls_dbname

ls_dbname 		= is_sourcetable + ls_dbname

If dw_aggregate.rowcount() > 0 Then
	If dw_aggregate.getitemstring(1, 'aggregate') = 'Y' Then
		ls_aggregatefunction	= dw_aggregate.getitemstring(1, 'aggregatefunction')
		ls_dbname 				= ls_dbname + ls_aggregatefunction
		
		Choose Case ls_aggregatefunction
			Case '[Sum]'
				ls_displayname = 'Sum of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname') 
			Case '[Count]'
				ls_displayname = 'Count of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
			Case '[CountDistinct]'
				ls_displayname = 'Distinct Count of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
			Case '[Avg]'
				ls_displayname = 'Average of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
			Case '[Min]'
				ls_displayname = 'Minimum of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
			Case '[Max]'
				ls_displayname = 'Maximum of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
			Case '[STDev]'
				ls_displayname = 'Std Dev of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
			Case '[Var]'
				ls_displayname = 'Stat Var of ' + ls_prefix_text + dw_available.GetItemString(ll_row, 'displayname')
		End Choose
	End If
End If
	
ln_dao = Create n_dao_columnselectiontablefavorite
ln_dao.SetTransObject(SQLCA)
ln_dao.Dynamic of_new()

ln_dao.of_SetItem(1, 'FrmClmnSlctnTbleIdnty', il_SourceTableID)
ln_dao.of_SetItem(1, 'RprtCnfgID', il_reportconfigid)
ln_dao.of_SetItem(1, 'ToClmnSlctnTbleIdnty', il_DestinationTableID)
ln_dao.of_SetItem(1, 'ColumnName', dw_available.GetItemString(ll_row, 'name'))
ln_dao.of_SetItem(1, 'ColumnText', ls_displayname)
ln_dao.of_SetItem(1, 'ColumnDescription', ls_displayname)
ln_dao.of_SetItem(1, 'TablePath', ls_dbname)
ln_dao.of_SetItem(1, 'RprtCnfgID', il_ReportConfigID)

If dw_uomconversion.GetItemString(1, 'uomconversion') = 'Y' And dw_uomconversion.GetItemString(1, 'allowconversion') = 'Y' Then
	ln_dao.of_SetItem(1, 'AddUOMConversion', 'Y')
	ln_dao.of_SetItem(1, 'UOMExpression', is_uominit_expression)
Else
	ln_dao.of_SetItem(1, 'AddUOMConversion', 'N')
End If

ls_gui = ln_dao.Dynamic of_getitem(1, 'GUI')
If Len(ls_gui) > 0 Then
	OpenWithParm(lw_window, ln_dao, ls_gui, Parent)
End If

Return ''
end function

public subroutine of_set_datawindowobject (string as_sourcetable, string as_destinationtable, string as_dataobject);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_datawindowobject()
//	Created by:	Blake Doerr
//	History: 	1/22/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_position
Long		ll_index
String	ls_generalconfig_tablename
String	ls_error
String	ls_datawindow_syntax
String	ls_select
String	ls_columname
String	ls_dbname

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_formatting_service ln_datawindow_formatting_service
//n_string_functions	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Handle General Configuration differently
//-----------------------------------------------------------------------------------------------------------------------------------
If Trim(Lower(as_destinationtable)) = 'generalconfiguration' Then
	ls_generalconfig_tablename = as_sourcetable
	If Right(ls_generalconfig_tablename, 1) = '.' Then ls_generalconfig_tablename = Left(ls_generalconfig_tablename, Len(ls_generalconfig_tablename) - 1)
	ls_generalconfig_tablename = Reverse(ls_generalconfig_tablename)
	If Pos(ls_generalconfig_tablename, '.') > 0 Then ls_generalconfig_tablename = Left(ls_generalconfig_tablename, Pos(ls_generalconfig_tablename, '.') - 1)
	ls_generalconfig_tablename = Reverse(ls_generalconfig_tablename)

	If Pos(ls_generalconfig_tablename, ')') > 0 Then ls_generalconfig_tablename = Mid(ls_generalconfig_tablename, Pos(ls_generalconfig_tablename, ')') + 1)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the datawindow syntax using the formatting service
	//-----------------------------------------------------------------------------------------------------------------------------------
	ln_datawindow_formatting_service = Create n_datawindow_formatting_service
	ls_datawindow_syntax = ln_datawindow_formatting_service.of_get_datawindow_syntax(as_destinationtable, ls_generalconfig_tablename)
	Destroy ln_datawindow_formatting_service
	
	ids_availablecolumns.DataObject = ''
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create the datawindow from the syntax
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Len(Trim(ls_datawindow_syntax)) > 0 And ls_datawindow_syntax <> '?' And ls_datawindow_syntax <> '!' Then
		ids_availablecolumns.Create(ls_datawindow_syntax, ls_error)
	End If
ElseIf Trim(as_dataobject) = 'dddw_columnselectiontablefavorite' Then
	ids_availablecolumns.DataObject = ''
	ids_favorite_external_columns.Retrieve(il_reportconfigid, gn_globals.il_userid)
ElseIf Trim(as_dataobject) = '' Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Create a syntax that we can use to display the column information when there is no dataobject
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_select = 'Select * From ' + as_destinationtable + ' Where 1 = 2'
	ls_datawindow_syntax = SQLCA.SyntaxFromSQL(ls_select, "", ls_error)
	ll_position = Pos(ls_datawindow_syntax, 'dbname="') + Len('dbname="') + 1
	
	If Pos(ls_datawindow_syntax, '.', ll_position) > 0 And Pos(ls_datawindow_syntax, '.', ll_position) < Pos(ls_datawindow_syntax, '"', ll_position) Then
	Else
		gn_globals.in_string_functions.of_replace_all(ls_datawindow_syntax, 'dbname="', 'dbname="' + Trim(as_destinationtable) + '.')
	End If
		
	If Len(Trim(ls_datawindow_syntax)) > 0 And ls_datawindow_syntax <> '?' And ls_datawindow_syntax <> '!' Then
		ids_availablecolumns.Create(ls_datawindow_syntax, ls_error)
	Else
		ids_availablecolumns.DataObject = ''
	End If
	
	For ll_index = 1 To Long(ids_availablecolumns.Describe("Datawindow.Column.Count"))
		ls_columname 	= ids_availablecolumns.Describe("#" + String(ll_index) + ".Name")
		ls_dbname		= ids_availablecolumns.Describe("#" + String(ll_index) + ".DBName")
		
		If Pos(ls_dbname, '.') > 0 Then ls_dbname = Mid(ls_dbname, Pos(ls_dbname, '.') + 1)
		
		ids_availablecolumns.Modify(ls_columname + '_t.Text="' + ls_dbname + '"')
	Next
Else
	ids_availablecolumns.DataObject = as_dataobject
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// This section adds support for Product Specs so they show as english instead of a column names
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_value
n_datawindow_tools ln_data_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Now while we are here, let's see if this dw needs to be transposed
//-----------------------------------------------------------------------------------------------------------------------------------
if ids_availablecolumns.dataobject <> '' then
	
	ln_data_tools = Create n_datawindow_tools
	ls_Value = ln_data_tools.of_get_expression(ids_availablecolumns, 'transposeinit')
	if not isnull(ls_value) then
	
			
		ln_datawindow_formatting_service = Create n_datawindow_formatting_service
		ls_datawindow_syntax = ln_datawindow_formatting_service.of_transpose_datawindow_syntax(ids_availablecolumns, ls_value)
		if isvalid(ln_datawindow_formatting_service) then Destroy ln_datawindow_formatting_service
		
		if Len(Trim(ls_datawindow_syntax)) > 0 And ls_datawindow_syntax <> '?' And ls_datawindow_syntax <> '!' Then
			ids_availablecolumns.Create(ls_datawindow_syntax, ls_error)
		Else
			ids_availablecolumns.DataObject = ''
		End If
	
	end if
	if isvalid(ln_data_tools) then destroy ln_data_tools

end if		

end subroutine

public function boolean of_areweaddingcriteria ();Return ib_WeAreAddingCriteriaColumns
end function

on u_column_selection_external.create
int iCurrent
call super::create
this.dw_aggregate=create dw_aggregate
this.dw_uomconversion=create dw_uomconversion
this.dw_criteria_style=create dw_criteria_style
this.st_3=create st_3
this.st_2=create st_2
this.dw_available=create dw_available
this.dw_warning=create dw_warning
this.dw_table=create dw_table
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_aggregate
this.Control[iCurrent+2]=this.dw_uomconversion
this.Control[iCurrent+3]=this.dw_criteria_style
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.dw_available
this.Control[iCurrent+7]=this.dw_warning
this.Control[iCurrent+8]=this.dw_table
end on

on u_column_selection_external.destroy
call super::destroy
destroy(this.dw_aggregate)
destroy(this.dw_uomconversion)
destroy(this.dw_criteria_style)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_available)
destroy(this.dw_warning)
destroy(this.dw_table)
end on

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
in_datawindow_tools = Create n_datawindow_tools
ids_availablecolumns = Create Datastore
ids_favorite_external_columns = Create Datastore
ids_favorite_external_columns.DataObject = 'dddw_columnselectiontablefavorite'
ids_favorite_external_columns.SetTransObject(SQLCA)
#IF defined PBDOTNET THEN
	THIS.EVENT resize(0, width, height)
#ELSE
	THIS.TriggerEvent('resize')
#END IF

end event

event destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy in_datawindow_tools
Destroy ids_availablecolumns
Destroy ids_favorite_external_columns
end event

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_ShowOneToManyWarning Then
	dw_warning.Y = This.Height - dw_warning.Height
	If ib_WeAreAddingCriteriaColumns Then
		dw_criteria_style.Y = dw_warning.Y - 8 - dw_criteria_style.Height
		dw_table.Height = dw_criteria_style.Y - 8 - dw_table.Y
		dw_criteria_style.Visible 	= True
		dw_uomconversion.Visible 	= False
		dw_aggregate.Visible			= False
	Else
		dw_aggregate.Y = dw_warning.Y - 8 - dw_aggregate.Height
		dw_uomconversion.Y = dw_aggregate.Y - 8 - dw_uomconversion.Height 
		dw_table.Height = dw_uomconversion.Y - 8 - dw_table.Y
		dw_criteria_style.Visible 	= False
		dw_uomconversion.Visible 	= True
		dw_aggregate.Visible 		= True
	End If

	dw_available.Height = dw_table.Height
	dw_warning.Visible = True
	This.SetRedraw(True)
Else
	dw_uomconversion.Y = This.Height - dw_uomconversion.Height
	dw_table.Height 		= dw_uomconversion.Y - 20 - dw_table.Y
	dw_available.Height 	= dw_table.Height
	dw_warning.Visible = False
	dw_criteria_style.Visible 	= False
	dw_uomconversion.Visible 	= True
	dw_aggregate.Visible			= False
End If
end event

type dw_aggregate from u_datawindow within u_column_selection_external
integer x = 46
integer y = 1128
integer width = 2208
integer height = 88
integer taborder = 40
string dataobject = "d_show_fields_external_columns_aggregate"
boolean border = false
boolean livescroll = false
end type

type dw_uomconversion from datawindow within u_column_selection_external
boolean visible = false
integer x = 1280
integer y = 1040
integer width = 1051
integer height = 96
integer taborder = 50
string title = "none"
string dataobject = "d_show_fields_external_columns_uominit"
boolean border = false
end type

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
This.InsertRow(0)
end event

event buttonclicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_row
n_bag		ln_bag
Window	lw_window

If IsValid(dwo) Then
	Choose Case Lower(Trim(dwo.Name))
		Case 'button_uomconversion'
			
			ln_bag = Create n_bag
			ln_bag.of_set('datasource', idw_data)
			ln_bag.of_set('n_datawindow_formatting_service', This)
			ln_bag.of_set('object', 'uominit')
			
			ll_row = dw_available.of_getselectedrow(0)
			
			If ll_row <= 0 Or ll_row > dw_available.RowCount() Or IsNull(ll_row) Then
				Destroy ln_bag
				Return
			End If
			
			ln_bag.of_set('apply uom', 'N')
			ln_bag.of_set('show only new', 'Y')
			ln_bag.of_set('sourcecolumn', Trim(Trim(is_prefix) + ' ' + dw_available.GetItemString(ll_row, 'displayname')))
			
			OpenWithParm(lw_window, ln_bag, 'w_formatting_service_response', w_mdi)
			
			If IsValid(ln_bag) Then
				is_uominit_expression = String(ln_bag.of_get('uominit'))
				Destroy ln_bag
			End If
	End Choose
End If
end event

type dw_criteria_style from datawindow within u_column_selection_external
boolean visible = false
integer x = 123
integer y = 1128
integer width = 1943
integer height = 96
integer taborder = 40
string title = "none"
string dataobject = "d_show_fields_external_columns_criteria"
boolean border = false
end type

type st_3 from statictext within u_column_selection_external
integer x = 1358
integer y = 4
integer width = 919
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selected External Column:"
boolean focusrectangle = false
end type

type st_2 from statictext within u_column_selection_external
integer x = 18
integer y = 4
integer width = 576
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selected External Table:"
boolean focusrectangle = false
end type

type dw_available from u_datawindow within u_column_selection_external
integer x = 1358
integer y = 64
integer width = 951
integer height = 956
integer taborder = 20
string dataobject = "d_show_fields_external_columns"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      constructor
//	Overrides:  No
//	Arguments:	None.
//	Overview:   
//	Created by: Blake Doerr
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_datawindow_graphic_service_manager ln_manager

ln_manager = This.of_get_service_manager()

If IsValid(ln_manager) Then
	ln_manager.of_add_service('n_rowfocus_service')
	ln_manager.of_create_services()
End If
end event

event doubleclicked;call super::doubleclicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Parent.Event ue_column_selected()
end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_dao 	ln_dao
Long		ll_SourceID
String	ls_gui
String	ls_return
Window	lw_window

If row > 0 And Not IsNull(row) And row <= This.RowCount() And row = GetRow() Then
	If This.GetItemString(row, 'SelectRowIndicator') <> 'Y' Or IsNull(This.GetItemString(row, 'SelectRowIndicator')) Then
		This.SetItem(row, 'SelectRowIndicator', 'Y')
	End If
End If

If row <= 0 Or IsNull(row) Or row > This.RowCount() Then Return

If Left(Lower(Trim(is_SourceTable)), Len('FavoriteColumns')) = Lower('FavoriteColumns') Then
	If row <= ids_favorite_external_columns.RowCount() Then
		ll_SourceID = ids_favorite_external_columns.GetItemNumber(row, 'Idnty')

		If ll_SourceID > 0 And Not IsNull(ll_SourceID) And IsValid(dwo) Then
			Choose Case Lower(Trim(dwo.Name))
				Case 't_edit'
					
					If ll_SourceID > 0 And Not IsNull(ll_SourceID) Then
						ln_dao = Create n_dao_columnselectiontablefavorite
						ln_dao.SetTransObject(SQLCA)
						ln_dao.Retrieve(ll_SourceID)
						
						ls_gui = ln_dao.Dynamic of_getitem(1, 'GUI')
						If Len(ls_gui) > 0 Then
							OpenWithParm(lw_window, ln_dao, ls_gui, Parent.of_getparentwindow())
						End If				
					End If
				Case 't_delete'
					ln_dao = Create n_dao_columnselectiontablefavorite
					ln_dao.SetTransObject(SQLCA)
					ln_dao.Retrieve(ll_SourceID)
					
					ls_return = ln_dao.of_getitem(1, 'security')
					
					If ls_return = '' Then
						If gn_globals.in_messagebox.of_messagebox_question ('Are you sure you would like to delete this column favorite?', YesNoCancel!, 3) <> 1 Then Return
						
						ln_dao.DeleteRow(1)
						ls_return = ln_dao.of_save()
						
						If ls_return <> '' Then
							gn_globals.in_messagebox.of_messagebox_validation(ls_return)
						Else					
							DeleteRow(row)
							ids_favorite_external_columns.DeleteRow(row)
							This.Event RetrieveEnd(This.RowCount())
						End If
						
						Destroy ln_dao
					Else
						gn_globals.in_messagebox.of_messagebox_validation(ls_return)
					End If
			End Choose
		End If
	End If
End If
				
end event

event rowfocuschanged;call super::rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_IgnoreRowFocusChangeColumns Then
	Call Super::RowFocusChanged
	Parent.of_column_selected()
End If
end event

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


If Left(Lower(Trim(is_SourceTable)), Len('FavoriteColumns')) = Lower('FavoriteColumns') Then
//	If 60 * This.RowCount() + 18 < This.Height Then
//		This.Modify("t_edit.X = '" + String(This.Width - 340) + "'")
//		This.Modify("t_delete.X = '" + String(This.Width - 170) + "'")
//		This.Modify("displayname.Width = '" + String(This.Width - 340) + "'")
//	Else
		This.Modify("t_edit.X = '" + String(This.Width - 400) + "'")
		This.Modify("t_delete.X = '" + String(This.Width - 250) + "'")
		This.Modify("displayname.Width = '" + String(This.Width - 400) + "'")
//	End If
End If
end event

type dw_warning from datawindow within u_column_selection_external
boolean visible = false
integer x = 151
integer y = 1244
integer width = 2016
integer height = 156
integer taborder = 30
string title = "none"
string dataobject = "d_show_fields_external_columns_warning"
boolean border = false
boolean livescroll = true
end type

type dw_table from u_datawindow within u_column_selection_external
integer x = 18
integer y = 64
integer width = 1330
integer height = 956
integer taborder = 10
boolean bringtotop = true
string dataobject = "dddw_additional_columns_available_tables"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;call super::rowfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   RowFocusChanged
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_row
Long		ll_treelevel
Long		ll_parentrow
Long		ll_find_row
String	ls_datawindowobject
String	ls_tablename

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we are ignoring GUI changes
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_IgnoreRowFocusChange Then Return AncestorReturnValue

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the selected row from the tables datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = dw_table.of_GetSelectedRow(0)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we don't find anything, reset and return
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row <= 0 Or IsNull(ll_row) Then Return AncestorReturnValue

//-----------------------------------------------------------------------------------------------------------------------------------
// Get information from the row about the table
//-----------------------------------------------------------------------------------------------------------------------------------
ll_treelevel 				= dw_table.GetItemNumber(ll_row, 'treelevel')
ls_tablename 				= dw_table.GetItemString(ll_row, 'tablename')
ls_datawindowobject 		= dw_table.GetItemString(ll_row, 'datawindowname')
is_sourcetable				= Trim(dw_table.GetItemString(ll_row, 'tablename'))
is_destinationtable		= dw_table.GetItemString(ll_row, 'destinationtablename')
is_prefix					= dw_table.GetItemString(ll_row, 'prefix')
il_DestinationTableID	= dw_table.GetItemNumber(ll_row, 'TableID')

If Lower(Trim(ls_tablename)) = Lower('FavoriteColumns') Then
	dw_available.Modify('t_edit.Visible=~'1~t1~'')
	dw_available.Modify('t_delete.Visible=~'1~t1~'')
	#IF defined PBDOTNET THEN
		dw_available.EVENT resize(0, dw_available.width, dw_available.height)
	#ELSE
		dw_available.TriggerEvent('resize')
	#END IF
Else
	dw_available.Modify('t_edit.Visible=~'1~t0~'')
	dw_available.Modify('t_delete.Visible=~'1~t0~'')
	dw_available.Modify('displayname.Width=~'1500~'')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the original source table
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row = 1 Or dw_table.GetItemNumber(ll_row, 'TreeLevel') = 1 Then
	il_SourceTableID = il_DestinationTableID
Else
	ll_find_row = dw_table.Find('treelevel = 1', ll_row, 1)
	
	If ll_find_row > 0 And Not IsNull(ll_find_row) Then
		il_SourceTableID	= dw_table.GetItemNumber(ll_find_row, 'TableID')
	Else
		il_SourceTableID = 0
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we already have those columns selected
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_availablecolumns.DataObject = ls_datawindowobject And Trim(ls_datawindowobject) <> '' Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Handle General Configuration differently
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.of_set_datawindowobject(is_sourcetable, is_destinationtable, ls_datawindowobject)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a period to the source table
//-----------------------------------------------------------------------------------------------------------------------------------
If is_sourcetable <> '' Then is_sourcetable = is_sourcetable + '.'

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the columns loaded into the selection datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
Parent.of_get_columns()

end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      constructor
//	Overrides:  No
//	Arguments:	None.
//	Overview:   
//	Created by: Blake Doerr
//	History:    2/28/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_datawindow_graphic_service_manager ln_manager

ln_manager = This.of_get_service_manager()

If IsValid(ln_manager) Then
	ln_manager.of_add_service('n_datawindow_treeview_service')
	ln_manager.of_add_service('n_rowfocus_service')
	ln_manager.of_create_services()
End If
end event

event ue_notify(string as_message, any aany_argument);call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	8/15/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case Lower(Trim(as_message))
   Case 'n_datawindow_treeview_service'
		Choose Case Lower(Trim(String(aany_argument)))
			Case 'begin expand'
				ib_IgnoreRowFocusChange = True
			Case 'end expand'
				ib_IgnoreRowFocusChange = False
		End Choose
   Case Else
End Choose
end event

event retrieveend;call super::retrieveend;//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   
//	Created by:	Blake Doerr
//	History: 	2/24/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_ShowOneToManyWarning Then
	If This.Find("Icon = 'Position Reporting - Blue Exclamation.bmp'", 1, This.RowCount()) > 0 Then
		ib_ShowOneToManyWarning = True
		#IF defined PBDOTNET THEN
			parent.EVENT resize(0, parent.width, parent.height)
		#ELSE
			parent.TriggerEvent('resize')
		#END IF
	End If
End IF
end event

