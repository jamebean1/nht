$PBExportHeader$u_dynamic_gui_format_datawindow_uominit.sru
forward
global type u_dynamic_gui_format_datawindow_uominit from u_dynamic_gui_format
end type
type dw_other from u_datawindow within u_dynamic_gui_format_datawindow_uominit
end type
type st_1 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_2 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_3 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_4 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_5 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_6 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_7 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_8 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_9 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_10 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_11 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_12 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_13 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_111 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_44 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_444 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_14 from statictext within u_dynamic_gui_format_datawindow_uominit
end type
type st_new from u_hover_button within u_dynamic_gui_format_datawindow_uominit
end type
type st_delete from u_hover_button within u_dynamic_gui_format_datawindow_uominit
end type
type ln_2 from line within u_dynamic_gui_format_datawindow_uominit
end type
type ln_3 from line within u_dynamic_gui_format_datawindow_uominit
end type
type ln_4 from line within u_dynamic_gui_format_datawindow_uominit
end type
type ln_5 from line within u_dynamic_gui_format_datawindow_uominit
end type
type ln_11 from line within u_dynamic_gui_format_datawindow_uominit
end type
type ln_111 from line within u_dynamic_gui_format_datawindow_uominit
end type
end forward

global type u_dynamic_gui_format_datawindow_uominit from u_dynamic_gui_format
integer width = 1847
integer height = 1196
long backcolor = 80263581
string text = "UOM/Currency Conversion"
dw_other dw_other
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
st_10 st_10
st_11 st_11
st_12 st_12
st_13 st_13
st_111 st_111
st_44 st_44
st_444 st_444
st_14 st_14
st_new st_new
st_delete st_delete
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
ln_5 ln_5
ln_11 ln_11
ln_111 ln_111
end type
global u_dynamic_gui_format_datawindow_uominit u_dynamic_gui_format_datawindow_uominit

type variables
Protected:
	Boolean	ib_ApplyUOM 		= True
	Boolean	ib_ShowOnlyNew		= False
	String	is_NewSourceColumn = ''
end variables

forward prototypes
public subroutine of_set_bag (n_bag an_bag)
public function string of_apply_property (datawindow adw_property_datawindow, string as_columnname, powerobject ao_apply_datawindow)
public subroutine of_init ()
public function boolean of_validate ()
public subroutine of_apply ()
end prototypes

public subroutine of_set_bag (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_bag()
//	Arguments:  an_bag 	- The bag object with all the data
//	Overview:   This will set the bag object
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Super::of_set_bag(an_bag)

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
Long		ll_index2
Long		ll_column_count
Long		ll_row
String	ls_columns[]
String	ls_headername[]
String	ls_headertext[]
String	ls_columntype[]
String	ls_return

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//----------------------------------------------------------------------------------------------------------------------------------
DatawindowChild 	ldwc_sourcecolumn
DatawindowChild	ldwc_destinationcolumn
n_datawindow_tools ln_datawindow_tools

//----------------------------------------------------------------------------------------------------------------------------------
// Determine settings
//----------------------------------------------------------------------------------------------------------------------------------
ls_return = String(an_bag.of_get('apply uom'))
If IsNull(ls_return) Then ls_return = ''
ib_ApplyUOM = Upper(Trim(ls_return)) <> 'N'

ls_return = String(an_bag.of_get('show only new'))
If IsNull(ls_return) Then ls_return = ''
ib_ShowOnlyNew = Upper(Trim(ls_return)) = 'Y'

st_new.Visible 	= Not ib_ShowOnlyNew
st_delete.Visible	= Not ib_ShowOnlyNew

ls_return	= String(an_bag.of_get('sourcecolumn'))

If Trim(ls_return) <> '' And Not IsNull(ls_return) Then
	is_NewSourceColumn = ls_return
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Tell the pivot table service what the datasource is
//----------------------------------------------------------------------------------------------------------------------------------
dw_properties.GetChild('sourcecolumn', ldwc_sourcecolumn)

//----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns/computed fields and their headers with text and datatype
//----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_columns_all(idw_data, ls_columns[], ls_headername[], ls_headertext[], ls_columntype[])
Destroy ln_datawindow_tools

ll_column_count = Min(UpperBound(ls_columns[]), (Min(UpperBound(ls_headername[]), (Min(UpperBound(ls_headertext[]), UpperBound(ls_columntype[]))))))

//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and add them to the arrays
//----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_column_count
	//----------------------------------------------------------------------------------------------------------------------------------
	// Add it to the available list
	//----------------------------------------------------------------------------------------------------------------------------------
	If Trim(ls_headername[ll_index]) = '' Or ls_headername[ll_index] = '!' Or ls_headername[ll_index] = '?' Then
		For ll_index2 = 1 To ll_column_count
			If ll_index2 = ll_index Then Continue
			If ls_headertext[ll_index2] = '!' Or ls_headertext[ll_index2] = '?' Or IsNull(ls_headertext[ll_index2]) Or Trim(ls_headertext[ll_index2]) = '' Then Continue

			If Lower(Trim(ls_columns[ll_index2])) = Lower(Trim(ls_columns[ll_index])) + '_display' Or Lower(Trim(ls_columns[ll_index2])) = Lower(Trim(ls_columns[ll_index])) + '_dsply' Or Lower(Trim(ls_columns[ll_index2])) = Lower(Trim(ls_columns[ll_index])) + '_dsplyuomconversion' Then
				ls_headertext[ll_index] = ls_headertext[ll_index2] + ' (Source)'
				Exit
			End If
		Next
	End If
	
	ll_row = ldwc_sourcecolumn.InsertRow(0)
	ldwc_sourcecolumn.SetItem(ll_row, 'columnname', 	ls_headertext[ll_index])
	ldwc_sourcecolumn.SetItem(ll_row, 'databasename', ls_columns[ll_index])
	ldwc_sourcecolumn.SetItem(ll_row, 'datatype', 		ls_columntype[ll_index])
Next

dw_properties.GetChild('destinationcolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "deci" Or Left(datatype, 4) = "real"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()

dw_properties.GetChild('productcolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "long" Or Left(datatype, 4) = "ulon"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('energycolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "deci" Or Left(datatype, 4) = "real"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(default)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('gravitycolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "deci" Or Left(datatype, 4) = "real"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(default)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('startdatecolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "date"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('exchangedatecolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "date"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(latest rates)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('sourcecurrencyidcolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "long"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(system default)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('destinationcurrencyidcolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "long"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(selected)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('sourceuomidcolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "long"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(system default)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_properties.GetChild('destinationuomidcolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "long"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(selected)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_other.GetChild('uomdisplaycolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "long"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

dw_other.GetChild('currencydisplaycolumn', ldwc_destinationcolumn)
ldwc_sourcecolumn.RowsCopy(1, ldwc_sourcecolumn.RowCount(), Primary!, ldwc_destinationcolumn, ldwc_destinationcolumn.Rowcount() + 1, Primary!)
ldwc_destinationcolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "long"')
ldwc_destinationcolumn.Filter()
ldwc_destinationcolumn.SetSort('columnname A')
ldwc_destinationcolumn.Sort()
ldwc_destinationcolumn.InsertRow(1)
ldwc_destinationcolumn.SetItem(1, 'columnname', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'databasename', 		'(none)')
ldwc_destinationcolumn.SetItem(1, 'datatype', 			'(none)')

ldwc_sourcecolumn.SetFilter('Left(datatype, 4) = "numb" Or Left(datatype, 4) = "deci" Or Left(datatype, 4) = "real"')
ldwc_sourcecolumn.Filter()
ldwc_sourcecolumn.SetSort('columnname A')
ldwc_sourcecolumn.Sort()

If is_NewSourceColumn <> '' Then
	ll_row = ldwc_sourcecolumn.InsertRow(0)
	ldwc_sourcecolumn.SetItem(ll_row, 'columnname', 	is_NewSourceColumn + ' (Source)')
	ldwc_sourcecolumn.SetItem(ll_row, 'databasename', '{sourcecolumn}')
	ldwc_sourcecolumn.SetItem(ll_row, 'datatype', 		'number')

	ll_row = ldwc_destinationcolumn.InsertRow(0)
	ldwc_destinationcolumn.SetItem(ll_row, 'columnname', 	is_NewSourceColumn)
	ldwc_destinationcolumn.SetItem(ll_row, 'databasename', '{destinationcolumn}')
	ldwc_destinationcolumn.SetItem(ll_row, 'datatype', 		'number')
End If
end subroutine

public function string of_apply_property (datawindow adw_property_datawindow, string as_columnname, powerobject ao_apply_datawindow);//Overridden
Return ''
end function

public subroutine of_init ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init
//	Overview:   Initializes the conversion objects from a datawindow
//	Created by:	Blake Doerr
//	History: 	9/5/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_uom_uominit ln_uom_uominit

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the UOMInit object and set the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_uom_uominit = Create n_uom_uominit

//If Not ib_ShowOnlyNew Then
//	ls_return = ln_uom_uominit.of_init(idw_data)
//End If

//ln_uom_uominit.of_apply_to_gui(dw_properties, dw_other)
//
//If ib_ShowOnlyNew Then
//	dw_properties.ScrollToRow(dw_properties.InsertRow(0))
//	dw_properties.SetItem(1, 'sourcecolumn', '{sourcecolumn}')
//	dw_properties.SetItem(1, 'destinationcolumn', '{destinationcolumn}')
//	dw_properties.SetItem(1, 'enablecolumns', 'N')
//	If Pos(Lower(is_NewSourceColumn), 'price') > 0 Or Pos(Lower(is_NewSourceColumn), 'value') > 0 Or Pos(Lower(is_NewSourceColumn), 'prce') > 0 Or Pos(Lower(is_NewSourceColumn), 'per unit') > 0 Then
//		dw_properties.SetItem(1, 'converttype', 'price')
//	Else
//		dw_properties.SetItem(1, 'enablecolumns', 'quantity')
//	End If
//	dw_properties.SetColumn('sourcecolumn')
//	dw_properties.SetFocus()
//	
//	dw_other.SetItem(1, 'enablecolumns', 'N')
//End If
//
//Destroy ln_uom_uominit
end subroutine

public function boolean of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate()
//	Overview:   This will apply the gui to the datawindow
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_row
String	ls_return
String	ls_column

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_uom_uominit ln_uom_uominit

//-----------------------------------------------------------------------------------------------------------------------------------
// Validate the GUI
//-----------------------------------------------------------------------------------------------------------------------------------
is_errormessage = ''
//ln_uom_uominit = Create n_uom_uominit
//ls_return = ln_uom_uominit.of_validate_gui(dw_properties, dw_other, ll_row, ls_column)
//Destroy ln_uom_uominit

//-----------------------------------------------------------------------------------------------------------------------------------
// If we don't get an error message return
//-----------------------------------------------------------------------------------------------------------------------------------
If ls_return = '' Then Return True

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the message so a messagebox can be presented
//-----------------------------------------------------------------------------------------------------------------------------------
is_errormessage = ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine which datawindow to set focus to
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(ls_column))
	Case 'decimals', 'userounding', 'uomlabel', 'uomdisplaycolumn', 'uomdisplaytype', 'currencydisplaycolumn', 'currencydisplaytype'
		dw_other.SetColumn(ls_column)
		dw_other.Post SetFocus()
	Case Else
		dw_properties.SetRow(ll_row)
		dw_properties.SetColumn(ls_column)
		dw_properties.ScrollToRow(ll_row)
		dw_properties.Post SetFocus()
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Return false since we have an error
//-----------------------------------------------------------------------------------------------------------------------------------
Return False

end function

public subroutine of_apply ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_apply()
//	Overview:   This will apply the gui to the datawindow
//	Created by:	Blake Doerr
//	History: 	9/6/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_uom_uominit ln_uom_uominit

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the gui to the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_uom_uominit = Create n_uom_uominit
//ln_uom_uominit.of_set_gui(dw_properties, dw_other)
//If ib_ApplyUOM Then
//	ls_return = ln_uom_uominit.of_apply(idw_data)
//Else
//	in_bag.of_set('uominit', ln_uom_uominit.of_get_expression())
//End If
//
//Destroy ln_uom_uominit
end subroutine

on u_dynamic_gui_format_datawindow_uominit.destroy
call super::destroy
destroy(this.dw_other)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.st_12)
destroy(this.st_13)
destroy(this.st_111)
destroy(this.st_44)
destroy(this.st_444)
destroy(this.st_14)
destroy(this.st_new)
destroy(this.st_delete)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.ln_5)
destroy(this.ln_11)
destroy(this.ln_111)
end on

on u_dynamic_gui_format_datawindow_uominit.create
int iCurrent
call super::create
this.dw_other=create dw_other
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
this.st_11=create st_11
this.st_12=create st_12
this.st_13=create st_13
this.st_111=create st_111
this.st_44=create st_44
this.st_444=create st_444
this.st_14=create st_14
this.st_new=create st_new
this.st_delete=create st_delete
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.ln_5=create ln_5
this.ln_11=create ln_11
this.ln_111=create ln_111
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_other
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.st_7
this.Control[iCurrent+9]=this.st_8
this.Control[iCurrent+10]=this.st_9
this.Control[iCurrent+11]=this.st_10
this.Control[iCurrent+12]=this.st_11
this.Control[iCurrent+13]=this.st_12
this.Control[iCurrent+14]=this.st_13
this.Control[iCurrent+15]=this.st_111
this.Control[iCurrent+16]=this.st_44
this.Control[iCurrent+17]=this.st_444
this.Control[iCurrent+18]=this.st_14
this.Control[iCurrent+19]=this.st_new
this.Control[iCurrent+20]=this.st_delete
this.Control[iCurrent+21]=this.ln_2
this.Control[iCurrent+22]=this.ln_3
this.Control[iCurrent+23]=this.ln_4
this.Control[iCurrent+24]=this.ln_5
this.Control[iCurrent+25]=this.ln_11
this.Control[iCurrent+26]=this.ln_111
end on

type dw_properties from u_dynamic_gui_format`dw_properties within u_dynamic_gui_format_datawindow_uominit
integer x = 9
integer y = 60
integer width = 1815
integer height = 740
string dataobject = "d_format_report_uominit"
boolean vscrollbar = true
end type

type dw_other from u_datawindow within u_dynamic_gui_format_datawindow_uominit
integer y = 848
integer width = 1833
integer height = 352
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_format_report_uominit_rounding"
boolean border = false
boolean livescroll = false
end type

event constructor;call super::constructor;This.InsertRow(0)
end event

type st_1 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 14
integer y = 796
integer width = 370
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Other Options"
boolean focusrectangle = false
end type

type st_2 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 14
integer y = 8
integer width = 535
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Conversion Columns"
boolean focusrectangle = false
end type

type st_3 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2112
integer y = 568
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Source:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2473
integer y = 568
integer width = 1449
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The source column for the conversion.  Usually not visible."
boolean focusrectangle = false
end type

type st_5 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2112
integer y = 640
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Destination:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2473
integer y = 640
integer width = 1449
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The destination column for the conversion.  Must be visible."
boolean focusrectangle = false
end type

type st_7 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2112
integer y = 712
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Gravity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2473
integer y = 712
integer width = 1449
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "(Optional) The column containing the specific gravity."
boolean focusrectangle = false
end type

type st_9 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2473
integer y = 784
integer width = 1449
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "(Optional) The column containing the energy."
boolean focusrectangle = false
end type

type st_10 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2112
integer y = 784
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Energy:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_11 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2112
integer y = 856
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_12 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2112
integer y = 928
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Product:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_13 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2112
integer y = 1000
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_111 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2121
integer y = 496
integer width = 320
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Explanation"
boolean focusrectangle = false
end type

type st_44 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2473
integer y = 856
integer width = 1449
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "The type of conversion, quantity or per unit (value)."
boolean focusrectangle = false
end type

type st_444 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2473
integer y = 928
integer width = 1449
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "(Optional) The product column to be used in the conversion."
boolean focusrectangle = false
end type

type st_14 from statictext within u_dynamic_gui_format_datawindow_uominit
integer x = 2473
integer y = 1000
integer width = 1449
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "(Optional) The date column to calculate quantity per day."
boolean focusrectangle = false
end type

type st_new from u_hover_button within u_dynamic_gui_format_datawindow_uominit
integer x = 1207
integer width = 430
boolean bringtotop = true
long backcolor = 80263581
string text = "New Conversion..."
alignment alignment = center!
end type

event ue_refreshtheme();//Overridden
end event

event clicked;call super::clicked;dw_properties.ScrollToRow(dw_properties.InsertRow(0))
dw_properties.SetColumn('sourcecolumn')
dw_properties.SetFocus()
end event

type st_delete from u_hover_button within u_dynamic_gui_format_datawindow_uominit
integer x = 1618
integer width = 229
boolean bringtotop = true
long backcolor = 80263581
string text = "Delete"
alignment alignment = center!
end type

event clicked;call super::clicked;Long	ll_row

ll_row = Long(dw_properties.Describe("Datawindow.FirstRowOnPage"))

If Not IsNull(ll_row) And ll_row > 0 And ll_row <= dw_properties.RowCount() Then dw_properties.DeleteRow(ll_row)
end event

event ue_refreshtheme();//Overridden
end event

type ln_2 from line within u_dynamic_gui_format_datawindow_uominit
long linecolor = 16777215
integer linethickness = 1
integer beginx = 375
integer beginy = 824
integer endx = 1810
integer endy = 824
end type

type ln_3 from line within u_dynamic_gui_format_datawindow_uominit
long linecolor = 8421504
integer linethickness = 1
integer beginx = 375
integer beginy = 820
integer endx = 1810
integer endy = 820
end type

type ln_4 from line within u_dynamic_gui_format_datawindow_uominit
long linecolor = 16777215
integer linethickness = 1
integer beginx = 389
integer beginy = 36
integer endx = 1824
integer endy = 36
end type

type ln_5 from line within u_dynamic_gui_format_datawindow_uominit
long linecolor = 8421504
integer linethickness = 1
integer beginx = 389
integer beginy = 32
integer endx = 1824
integer endy = 32
end type

type ln_11 from line within u_dynamic_gui_format_datawindow_uominit
long linecolor = 16777215
integer linethickness = 1
integer beginx = 2405
integer beginy = 524
integer endx = 3931
integer endy = 524
end type

type ln_111 from line within u_dynamic_gui_format_datawindow_uominit
long linecolor = 8421504
integer linethickness = 1
integer beginx = 2405
integer beginy = 520
integer endx = 3931
integer endy = 520
end type

