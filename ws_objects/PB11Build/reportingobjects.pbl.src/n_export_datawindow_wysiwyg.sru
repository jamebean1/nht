$PBExportHeader$n_export_datawindow_wysiwyg.sru
$PBExportComments$Export a datawindow (report) as you see it visually to excel
forward
global type n_export_datawindow_wysiwyg from nonvisualobject
end type
end forward

global type n_export_datawindow_wysiwyg from nonvisualobject
end type
global n_export_datawindow_wysiwyg n_export_datawindow_wysiwyg

type variables
Protected:
	PowerObject idw_data
	boolean 	ib_batch = FALSE
	String 	is_filename
	String	is_columnname[]
end variables

forward prototypes
public subroutine of_init (powerobject adw_data)
public subroutine of_init_batch (powerobject adw_data, string as_filename)
public function long of_export (boolean ab_useole, string as_savetype)
public function long of_export ()
public function long of_get_excel_savetype (string as_savetype)
protected function string of_export_datawindow_using_ole (datastore ads_datastore, string as_savetype)
public function string of_create_datastore (ref datastore ads_datastore)
end prototypes

public subroutine of_init (powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_findheader()
// Arguments:	 adw_data - The datawindow to export
// Overview:    Initialize the instance variable for the datawindow
// Created by:  Blake Doerr
// History:     2/28/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
idw_data = adw_data
end subroutine

public subroutine of_init_batch (powerobject adw_data, string as_filename);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_findheader()
// Arguments:	adw_data - The datawindow to export,
//					as_filename - filename to export to
// Overview:	Initialize the batch behavior attributes
// Created by:	Gary Howard
// History:		07/07/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

idw_data = adw_data
ib_batch = TRUE
is_filename = as_filename
end subroutine

public function long of_export (boolean ab_useole, string as_savetype);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_export()
// Overview:    Call this function to do a save as excel on the datawindow
// Created by:  Blake Doerr
// History:     1/31/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long			ll_return
String		ls_return
String		ls_filename
String		ls_pathname
Datastore 	lds_datastore


//----------------------------------------------------------------------------------------------------------------------------------
//	Open the file save dialog if not batch
//----------------------------------------------------------------------------------------------------------------------------------
if idw_data.dynamic rowcount() > 65500 then
	if gn_globals.is_noninteractive = "N" then
		gn_globals.in_messagebox.of_messagebox_validation("Excel can only hold 65500 rows of data and your report has more than 65500 rows.   Please try limiting the number of rows or using a different export format")
	end if
	return -1
end if


//----------------------------------------------------------------------------------------------------------------------------------
//	Get the datastore created
//----------------------------------------------------------------------------------------------------------------------------------
ls_return = This.of_create_datastore(lds_datastore)
If Not IsValid(lds_datastore) Then Return 1
If ls_return > '' Then Return -1

//----------------------------------------------------------------------------------------------------------------------------------
//	Open the file save dialog if not batch
//----------------------------------------------------------------------------------------------------------------------------------
If not ib_batch Then
	ll_return = GetFileSaveName('Enter Filename to Save Report as Excel', is_filename, ls_filename, "XLS", "Excel Files (*.XLS),*.XLS,")
Else
	ls_pathname = is_filename
	ll_return = 1
End If

//----------------------------------------------------------------------------------------------------------------------------------
//	Save the datawindow to excel with headers
//----------------------------------------------------------------------------------------------------------------------------------
If ll_return > 0 Then
	If ab_useole Then
		ls_return = of_export_datawindow_using_ole(lds_datastore, as_savetype)
		If Len(ls_return) > 0 Then
			ll_return = -1
		End If
	Else
		ll_return = lds_datastore.SaveAs(is_filename, Excel!, True)
	End If
End If

//----------------------------------------------------------------------------------------------------------------------------------
//	Destroy the objects no longer needed
//----------------------------------------------------------------------------------------------------------------------------------
Destroy lds_datastore

//----------------------------------------------------------------------------------------------------------------------------------
//	Return 1
//----------------------------------------------------------------------------------------------------------------------------------
Return ll_return
end function

public function long of_export ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_export()
// Overview:    Call this function to do a save as excel on the datawindow
// Created by:  Blake Doerr
// History:     1/31/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.of_export(False, '')
end function

public function long of_get_excel_savetype (string as_savetype);Choose Case Lower(Trim(as_savetype))
	Case 'xladdin'
		Return 18
	Case 'xlcsv'
		Return 6
	Case 'xlcsvmac'
		Return 22
	Case 'xlcsvmsdos'
		Return 24
	Case 'xlcsvwindows'
		Return 23
	Case 'xlcurrentplatformtext'
		Return -4158
	Case 'xldbf2'
		Return 7
	Case 'xldbf3'
		Return 8
	Case 'xldbf4'
		Return 11
	Case 'xldif'
		Return 9
	Case 'xlexcel2'
		Return 16
	Case 'xlexcel2fareast'
		Return 27
	Case 'xlexcel3'
		Return 29
	Case 'xlexcel4'
		Return 33
	Case 'xlexcel4workbook'
		Return 35
	Case 'xlexcel5', 'xlexcel7'
		Return 39
	Case 'xlexcel9795'
		Return 43
	Case 'xlhtml'
		Return 44
	Case 'xlhtmlcalc'
		Return 1
	Case 'xlintladdin'
		Return 26
	Case 'xlintlmacro'
		Return 25
	Case 'xlsylk'
		Return 2
	Case 'xltemplate'
		Return 17
	Case 'xltextmac'
		Return 19
	Case 'xltextmsdos'
		Return 21
	Case 'xltextprinter'
		Return 36
	Case 'xltextwindows'
		Return 20
	Case 'xlunicodetext'
		Return 42
	Case 'xlwj2wd1'
		Return 14
	Case 'xlwk1'
		Return 5
	Case 'xlwk1all'
		Return 31
	Case 'xlwk1fmt'
		Return 30
	Case 'xlwk3'
		Return 15
	Case 'xlwk4'
		Return 38
	Case 'xlwk3fm3'
		Return 32
	Case 'xlwks'
		Return 4
	Case 'xlworkbooknormal'
		Return -4143
	Case 'xlworks2fareast'
		Return 28
	Case 'xlwq1'
		Return 34
	Case 'xlwj3'
		Return 40
	Case 'xlwj3fj3'
		Return 41
End Choose 
	
Return 39

end function

protected function string of_export_datawindow_using_ole (datastore ads_datastore, string as_savetype);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_export_datawindow_using_ole()
//	Created by:	Blake Doerr
//	History: 	9/3/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_return
String	ls_filename
String	ls_format
String	ls_groups[]
Double	ldble_width
Long		ll_index
Long		ll_index2
Long		ll_width
Long		ll_numberofcolumns
Long		ll_numberofrows
Long		ll_column

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
OLEObject excel,oActiveSheet, oRange1,oRange2, oPicture
n_blob_manipulator ln_blob_manipulator
n_date_manipulator ln_date_manipulator
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datastore isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ads_datastore) Then Return 'Error:  Datastore is not valid while exporting to excel'

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the temporary file name
//-----------------------------------------------------------------------------------------------------------------------------------
ln_blob_manipulator = Create n_blob_manipulator
ls_filename = ln_blob_manipulator.of_determine_filename('Temp.xls')
Destroy ln_blob_manipulator

//-----------------------------------------------------------------------------------------------------------------------------------
// Delete the file we are going to write over
//-----------------------------------------------------------------------------------------------------------------------------------
FileDelete(is_filename)

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the number of rows and columns we are working with
//-----------------------------------------------------------------------------------------------------------------------------------
ll_numberofcolumns 	= Long(ads_datastore.Describe("Datawindow.Column.Count"))
ll_numberofrows		= ads_datastore.RowCount()

//-----------------------------------------------------------------------------------------------------------------------------------
// Save the file as text to get started
//-----------------------------------------------------------------------------------------------------------------------------------
ads_datastore.SaveAs(ls_filename, Text!, True)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the excel OLE Object
//-----------------------------------------------------------------------------------------------------------------------------------
Excel = CREATE OLEObject
If Not excel.ConnectToObject(ls_filename) = 0 Then
	Destroy Excel
	Return 'Error:  Could not connect to Excel OLE Server.  This machine may not have excel installed, or have the incorrect version'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set some options to prevent messages
//-----------------------------------------------------------------------------------------------------------------------------------
Excel.Application.DisplayAlerts = FALSE
Excel.application.workbooks(Excel.application.workbooks.Count).Parent.Windows(excel.application.workbooks(Excel.application.workbooks.Count).Name).Visible = True

//-----------------------------------------------------------------------------------------------------------------------------------
// Set some chart-wide properties
//-----------------------------------------------------------------------------------------------------------------------------------
oActiveSheet = excel.application.workbooks(Excel.application.workbooks.Count).ActiveSheet

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the entire sheet
//-----------------------------------------------------------------------------------------------------------------------------------
oActiveSheet.Cells.Select()
//Excel.Selection.MergeCells = False
//Excel.Selection.Wraptext = False
Excel.application.ActiveWindow.DisplayGridlines = False
Excel.application.Selection.Font.Name 	= 'Tahoma'
Excel.application.Selection.Font.Size			= 8
Excel.application.Selection.Columns.Autofit()

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the entire header row
//-----------------------------------------------------------------------------------------------------------------------------------
oActiveSheet.Cells(1, 1).Select()
oRange1 = Excel.application.Selection
oActiveSheet.Cells(1, ll_numberofcolumns).Select()
oRange2 = Excel.application.Selection
oActiveSheet.Range(oRange1, oRange2).Select()

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a line under the header row
//-----------------------------------------------------------------------------------------------------------------------------------
//	Excel.Application.Selection.Interior.ColorIndex = 40
//	Excel.Application.Selection.Interior.Pattern = 1
Excel.Application.Selection.Font.Bold = True
Excel.Application.Selection.Borders(5 /*xlDiagonalDown*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(6 /*xlDiagonalUp*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(7 /*xlEdgeLeft*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(8 /*xlEdgeTop*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(9 /*xlEdgeBottom*/).LineStyle = 1 /*xlContinuous*/
Excel.Application.Selection.Borders(9 /*xlEdgeBottom*/).Weight = 2 /*xlThin*/
Excel.Application.Selection.Borders(9 /*xlEdgeBottom*/).ColorIndex = -4105 /*xlAutomatic*/
Excel.Application.Selection.Borders(10 /*xlEdgeRight*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(11 /*xlInsideVertical*/).LineStyle = -4142/*xlNone*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the row right under the last row of data
//-----------------------------------------------------------------------------------------------------------------------------------
oActiveSheet.Cells(ll_numberofrows + 2, 1).Select()
oRange1 = Excel.application.Selection
oActiveSheet.Cells(ll_numberofrows + 2, ll_numberofcolumns).Select()
oRange2 = Excel.application.Selection
oActiveSheet.Range(oRange1, oRange2).Select()

//-----------------------------------------------------------------------------------------------------------------------------------
// Give it a single line on top and a double line on bottom
//-----------------------------------------------------------------------------------------------------------------------------------
Excel.Application.Selection.Borders(5 /*xlDiagonalDown*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(6 /*xlDiagonalUp*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(7 /*xlEdgeLeft*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(8 /*xlEdgeTop*/).LineStyle = 1 /*xlContinuous*/
Excel.Application.Selection.Borders(8 /*xlEdgeTop*/).Weight = 2 /*xlThin*/
Excel.Application.Selection.Borders(8 /*xlEdgeTop*/).ColorIndex = -4105 /*xlAutomatic*/
Excel.Application.Selection.Borders(9 /*xlEdgeBottom*/).LineStyle = -4119 /*xlDouble*/
Excel.Application.Selection.Borders(9 /*xlEdgeBottom*/).Weight = 4 /*xlThick*/
Excel.Application.Selection.Borders(9 /*xlEdgeBottom*/).ColorIndex = -4105 /*xlAutomatic*/
Excel.Application.Selection.Borders(10 /*xlEdgeRight*/).LineStyle = -4142/*xlNone*/
Excel.Application.Selection.Borders(11 /*xlInsideVertical*/).LineStyle = -4142/*xlNone*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the columns and apply formats when we can
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_columnname[])
	ls_format = idw_data.Dynamic Describe(is_columnname[ll_index] + ".Format")
	If Len(Trim(ls_format)) = 0 Or IsNull(ls_format) Or ls_format = '!' Or ls_format = '?' Or Pos(Lower(ls_format), '[general]') > 0 Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Do some special work around dates since excel won't recognize some of PB's macros
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Pos(Lower(ls_format), 'date]') > 0 Then
		If Pos(Lower(ls_format), '[time]') > 0 Then
			ls_format = ln_date_manipulator.of_get_client_datetimeformat()
			gn_globals.in_string_functions.of_replace_all(ls_format, 'tt', 'AM/PM')
		Else
			ls_format = ln_date_manipulator.of_get_client_dateformat()
		End If
	ElseIf Pos(Lower(ls_format), '[time]') > 0 Then
			ls_format = ln_date_manipulator.of_get_client_timeformat()
			gn_globals.in_string_functions.of_replace_all(ls_format, 'tt', 'AM/PM')
	ElseIf Lower(Left(idw_data.Dynamic Describe(is_columnname[ll_index] + ".ColType"), 4)) = 'date' Then
		gn_globals.in_string_functions.of_replace_all(ls_format, 'tt', 'AM/PM')
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Select the entire column, data only
	//-----------------------------------------------------------------------------------------------------------------------------------
	oActiveSheet.Cells(2, ll_index).Select()
	oRange1 = Excel.application.Selection
	oActiveSheet.Cells(ll_numberofrows + 1, ll_index).Select()
	oRange2 = Excel.application.Selection
	oActiveSheet.Range(oRange1, oRange2).Select()

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the format
	//-----------------------------------------------------------------------------------------------------------------------------------
	Excel.Application.Selection.NumberFormat = ls_format
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all columns and make the width in excel be the exact same width as the report
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_columnname[])
	If String(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Width")) = '!' Then Continue
	If String(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Width")) = '?' Then Continue

	ll_width = Long(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Width"))
	ll_width	= UnitsToPixels(ll_width, XUnitsToPixels!)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// This is the conversion factor that converts pixels to inches.  It was found by experimentation, could be wrong on different resolutions.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldble_width	= ll_width * 0.14165

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the width
	//-----------------------------------------------------------------------------------------------------------------------------------
	oActiveSheet.Columns(ll_index).ColumnWidth = ldble_width
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all columns and set the alignment
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_columnname[])
	Choose Case Long(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Alignment"))
		Case 0 //Left
			oActiveSheet.Columns(ll_index).HorizontalAlignment = -4131 //xlLeft
		Case 1 //Right
			oActiveSheet.Columns(ll_index).HorizontalAlignment = -4152 //xlRight
		Case 2 //Center
			oActiveSheet.Columns(ll_index).HorizontalAlignment = -4108 //xlCenter
	End Choose
	
	If String(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Width")) = '!' Then Continue
	If String(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Width")) = '?' Then Continue

	ll_width = Long(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Width"))
	ll_width	= UnitsToPixels(ll_width, XUnitsToPixels!)
	ldble_width	= ll_width * 0.14165

	If Lower(Left(idw_data.Dynamic Describe(is_columnname[ll_index] + ".ColType"), 4)) = 'date' Then
		If Pos(Lower(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Format")), '[time]') > 0 Or Pos(Lower(idw_data.Dynamic Describe(is_columnname[ll_index] + ".Format")), 'tt') > 0 Then
			ldble_width = Max(ldble_width, 17.0)
		End If
	End If

	oActiveSheet.Columns(ll_index).ColumnWidth = ldble_width
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is a footer, add it to the excel spreadsheet
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNumber(idw_data.Dynamic Describe("report_footer.X")) Then
	If idw_data.Dynamic Describe("report_footer.Type") = 'compute' Then
		oActiveSheet.Cells(ll_numberofrows + 4, 1).Value = String(idw_data.Dynamic Describe("Evaluate('report_footer', 1)"))
		oActiveSheet.Cells(ll_numberofrows + 4, 1).Select()
		Excel.Application.Selection.Font.Bold = True
		Excel.Application.Selection.HorizontalAlignment	= -4131 //xlLeft
	End If
End If

/*
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_groups(idw_data, ls_groups[])
Destroy ln_datawindow_tools

For ll_index = 1 To UpperBound(ls_groups[])
	If Not IsNumber(idw_data.Dynamic Describe("Header." + String(ll_index) + ".Height")) Then Continue

	ll_column = 0
	For ll_index2 = 1 To UpperBound(is_columnname[])
		If Lower(is_columnname[ll_index2]) = Lower(ls_groups[ll_index]) Then
			ll_column = ll_index2
		End If
	Next

	If ll_column = 0 Then Continue
	
	oActiveSheet.Cells(1, 1).Select()
	oRange1 = Excel.application.Selection
	oActiveSheet.Cells(1, ll_numberofcolumns).Select()
	oRange2 = Excel.application.Selection
	oActiveSheet.Range(oRange1, oRange2).Select()
	
	Excel.Application.Selection.Subtotal(GroupBy:=4, Function:=xlSum, TotalList:=Array(9), Replace:=True, PageBreaks:=False, SummaryBelowData:=True)
Next
*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Insert a column at the beginning and a row
//-----------------------------------------------------------------------------------------------------------------------------------
oActiveSheet.Cells(1, 1).Select()
Excel.Application.Selection.AutoFilter()
oActiveSheet.Columns("A:A").Select
Excel.Application.Selection.Insert(-4161 /* Shift:=xlToRight*/)
oActiveSheet.Rows("1:1").Select
Excel.Application.Selection.Insert(-4121 /* Shift:=xlDown*/)

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is a title, insert extra rows and add a title
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(String(idw_data.Dynamic Describe("report_title.Text"))) > 1 Then
	oActiveSheet.Rows("1:1").Select
	Excel.Application.Selection.Insert(-4121 /* Shift:=xlDown*/)
	oActiveSheet.Rows("1:1").Select
	Excel.Application.Selection.Insert(-4121 /* Shift:=xlDown*/)
	oActiveSheet.Cells(2, 2).Value = String(idw_data.Dynamic Describe("report_title.Text"))
	oActiveSheet.Cells(2, 2).Select()
	Excel.Application.Selection.Font.Bold = True
	Excel.Application.Selection.Font.Size = 12
	Excel.Application.Selection.HorizontalAlignment	= -4131 //xlLeft
End If


//If Len(String(idw_data.Dynamic Describe("report_bitmap.Filename"))) > 1 Then
//	oActiveSheet.OLEObjects.Add(String(idw_data.Dynamic Describe("report_bitmap.Filename")), False, False)
//End If

//oActiveSheet.Pictures.Insert("Small Movement Document Crude.bmp").Select()
//oPicture = Excel.application.Selection

//-----------------------------------------------------------------------------------------------------------------------------------
// Change the width of the first column that we added
//-----------------------------------------------------------------------------------------------------------------------------------
oActiveSheet.Columns("A:A").ColumnWidth = 1.43

//-----------------------------------------------------------------------------------------------------------------------------------
// Select the first row and column so it will open that way later
//-----------------------------------------------------------------------------------------------------------------------------------
oActiveSheet.Cells(1, 1).Select()

//-----------------------------------------------------------------------------------------------------------------------------------
// Save the file using the name and type specified
//-----------------------------------------------------------------------------------------------------------------------------------
excel.application.workbooks(Excel.application.workbooks.Count).SaveAs(is_filename, This.of_get_excel_savetype(as_savetype))

//-----------------------------------------------------------------------------------------------------------------------------------
// Close the worksheet
//-----------------------------------------------------------------------------------------------------------------------------------
excel.application.workbooks(Excel.application.workbooks.Count).close()

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the ole object
//-----------------------------------------------------------------------------------------------------------------------------------
DESTROY excel

Return ls_return

end function

public function string of_create_datastore (ref datastore ads_datastore);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_create_datastore()
// Overview:    Call this function to do a save as excel on the datawindow
// Created by:  Blake Doerr
// History:     1/31/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean		lb_visible[]
Boolean		lb_LookupDisplay[]
DateTime		ldt_datetime_array[]
Double		ldble_double_array[]
Long 			ll_return
Long			ll_index
String 		ls_new_syntax
String 		ls_return
String		ls_datatype
String 		ls_filename
String		ls_pathname
String		ls_columnname[]
String		ls_headername[]
String		ls_headertext[]
String		ls_columntype[]
String		ls_empty[]
String		ls_string_array[]
String		ls_new_columnname[]
String		ls_new_headername[]
String		ls_new_headertext[]
String		ls_new_columntype[]
Long			ll_upperbound
Long			ll_x_position[]
String		ls_visible


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools 	ln_datawindow_tools
Datastore				lds_sorting_datastore
//n_string_functions	ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return 'Error:  Datawindow was not valid'

//-----------------------------------------------------------------------------------------------------------------------------------
// Show the hourglass
//-----------------------------------------------------------------------------------------------------------------------------------
SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the columns with headers
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_columns(idw_data, ls_columnname[], ls_headername[], ls_headertext[], ls_columntype[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through and just get the ones that are visible and are on the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columnname[])
	If Not IsNumber(idw_data.Dynamic Describe(ls_columnname[ll_index] + '.X')) Then Continue
	ls_visible = idw_data.Dynamic Describe(ls_columnname[ll_index] + ".Visible")
	if Left(ls_visible, 1) = '0' Or Left(ls_visible, 2) = '"0' Or ls_visible = '"1~t0"' Then Continue
	
	ll_upperbound = UpperBound(ls_new_columnname[]) + 1
	
	If ls_headertext[ll_index] = '!' or ls_headertext[ll_index] = '?' Then
		ls_headertext[ll_index] = ls_columnname[ll_index]
	End If
	
	If ls_columntype[ll_index] = 'char' Then
		ls_columntype[ll_index] = 'char(4099)'
	End If
	
	ls_new_columnname[ll_upperbound]	= ls_columnname[ll_index]
	ls_new_headername[ll_upperbound]	= ls_headername[ll_index]
	ls_new_headertext[ll_upperbound]	= Trim(ls_headertext[ll_index])
	ls_new_columntype[ll_upperbound]	= ls_columntype[ll_index]
	ll_x_position[ll_upperbound]		= Long(idw_data.Dynamic Describe(ls_columnname[ll_index] + '.X'))
	
	If Left(ls_new_headertext[ll_upperbound], 1) = '"' And Right(ls_new_headertext[ll_upperbound], 1) = '"' Then
		ls_new_headertext[ll_upperbound] = Mid(ls_new_headertext[ll_upperbound], 2, Len(ls_new_headertext[ll_upperbound]) - 2)
	End If
	
	gn_globals.in_string_functions.of_replace_all(ls_new_headertext[ll_upperbound], '?', '')
	gn_globals.in_string_functions.of_replace_all(ls_new_headertext[ll_upperbound], '!', '')
	gn_globals.in_string_functions.of_replace_all(ls_new_headertext[ll_upperbound], '~~', '')
Next

If UpperBound(ls_new_columnname[]) = 0 Then Return ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore in order to sort by X position
//-----------------------------------------------------------------------------------------------------------------------------------
lds_sorting_datastore = Create Datastore
lds_sorting_datastore.DataObject = 'd_export_datawindow_wysiwyg_sort'
lds_sorting_datastore.Object.ColumnName.Primary	= ls_new_columnname[]
lds_sorting_datastore.Object.HeaderName.Primary	= ls_new_headername[]
lds_sorting_datastore.Object.HeaderText.Primary	= ls_new_headertext[]
lds_sorting_datastore.Object.Datatype.Primary		= ls_new_columntype[]
lds_sorting_datastore.Object.SortColumn.Primary	= ll_x_position[]
lds_sorting_datastore.SetSort("SortColumn A")
lds_sorting_datastore.Sort()

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty out the arrays
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columnname[]	= ls_empty[]
ls_headername[]	= ls_empty[]
ls_headertext[]	= ls_empty[]
ls_columntype[]	= ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Refill the arrays with the sorted version
//-----------------------------------------------------------------------------------------------------------------------------------
ls_columnname[]		= lds_sorting_datastore.Object.ColumnName.Primary
ls_headername[]		= lds_sorting_datastore.Object.HeaderName.Primary
ls_headertext[]		= lds_sorting_datastore.Object.HeaderText.Primary
ls_columntype[]		= lds_sorting_datastore.Object.Datatype.Primary

is_columnname[]	= ls_empty[]
is_columnname[] 	= ls_columnname[]


Destroy lds_sorting_datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and get the display type
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columnname[])
	Choose Case Lower(Trim(ln_datawindow_tools.of_get_editstyle(idw_data, ls_columnname[ll_index])))
		Case 'dddw', 'ddlb'
			ls_columntype[ll_index] = 'char(4099)'
			lb_LookupDisplay[ll_index] = True
		Case Else
			lb_LookupDisplay[ll_index] = False
	End Choose
Next

//----------------------------------------------------------------------------------------------------------------------------------
// This is the information that goes at the beginning of the syntax
//----------------------------------------------------------------------------------------------------------------------------------
ls_new_syntax = 'release 7;~r~ndatawindow(units=0 timer_interval=0 color=16777215 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )' + '~r~n' + 'header(height=73 color="536870912" )' + '~r~n' + 'summary(height=1 color="536870912" )' + '~r~n' + 'footer(height=1 color="536870912" )' + '~r~n' + 'detail(height=73 color="553648127" )' + '~r~n' + 'table('

//----------------------------------------------------------------------------------------------------------------------------------
// Now get the header text (for the dbcolumn name so it will show up in Excel)
//----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(ls_columnname[])
	ls_new_syntax = ls_new_syntax + '~r~n' + 'column=(type=' + ls_columntype[ll_index] + ' updatewhereclause=no name=column' + String(ll_index) + ' dbname="' + ls_headertext[ll_index] + '" )'
Next

//----------------------------------------------------------------------------------------------------------------------------------
// This goes at the end of the syntax
//----------------------------------------------------------------------------------------------------------------------------------
ls_new_syntax = ls_new_syntax + '~r~n )'

//----------------------------------------------------------------------------------------------------------------------------------
//	Create the datastore and the datawindow based on the new syntax
//----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ads_datastore) Then
	ads_datastore = Create Datastore
End If

ads_datastore.Create(ls_new_syntax , ls_return)

//----------------------------------------------------------------------------------------------------------------------------------
//	If there was an error, return
//----------------------------------------------------------------------------------------------------------------------------------
If Len(ls_return) > 0 and not ib_batch THEN
	If not ib_batch Then MessageBox('Datawindow Creation Error', ls_return + '~r~n' + ls_new_syntax)
	Destroy ads_datastore
	Destroy ln_datawindow_tools
	Return 'Error:  Could not create datawindow (' + ls_return + ')'
End If

//----------------------------------------------------------------------------------------------------------------------------------
//	Insert the rows in batch for performance
//----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools.of_insert_rows(ads_datastore, idw_data.Dynamic RowCount())

//----------------------------------------------------------------------------------------------------------------------------------
//	Loop through all the columns/computed fields and get the column as an array
//		We have to do the goofy 100 if statements because you can't dynamically set an array into a column without
//		hard coding the column name.
//----------------------------------------------------------------------------------------------------------------------------------
If idw_data.Dynamic RowCount() > 0 Then
	For ll_index = 1 To UpperBound(ls_columnname[])
		
		//----------------------------------------------------------------------------------------------------------------------------------
		//	Get the array from the column, if we need to do lookupdisplay, we will
		//----------------------------------------------------------------------------------------------------------------------------------
		If lb_LookupDisplay[ll_index] Then
			ln_datawindow_tools.of_get_lookupdisplay(idw_data, ls_columnname[ll_index], ls_string_array[])
			ls_datatype = 'string'
		Else
			ls_datatype = ln_datawindow_tools.of_get_array_from_column(idw_data, ls_columnname[ll_index], ls_string_array[], ldt_datetime_array[], ldble_double_array[])
		End If
	
		//----------------------------------------------------------------------------------------------------------------------------------
		//	Set the data depending on the datatype
		//----------------------------------------------------------------------------------------------------------------------------------
		Choose Case Lower(Trim(ls_datatype))
			Case 'number'
				If ll_index = 1 Then ads_datastore.Object.Column1.Primary = ldble_double_array[]
				If ll_index = 2 Then ads_datastore.Object.Column2.Primary = ldble_double_array[]
				If ll_index = 3 Then ads_datastore.Object.Column3.Primary = ldble_double_array[]
				If ll_index = 4 Then ads_datastore.Object.Column4.Primary = ldble_double_array[]
				If ll_index = 5 Then ads_datastore.Object.Column5.Primary = ldble_double_array[]
				If ll_index = 6 Then ads_datastore.Object.Column6.Primary = ldble_double_array[]
				If ll_index = 7 Then ads_datastore.Object.Column7.Primary = ldble_double_array[]
				If ll_index = 8 Then ads_datastore.Object.Column8.Primary = ldble_double_array[]
				If ll_index = 9 Then ads_datastore.Object.Column9.Primary = ldble_double_array[]
				If ll_index = 10 Then ads_datastore.Object.Column10.Primary = ldble_double_array[]
				If ll_index = 11 Then ads_datastore.Object.Column11.Primary = ldble_double_array[]
				If ll_index = 12 Then ads_datastore.Object.Column12.Primary = ldble_double_array[]
				If ll_index = 13 Then ads_datastore.Object.Column13.Primary = ldble_double_array[]
				If ll_index = 14 Then ads_datastore.Object.Column14.Primary = ldble_double_array[]
				If ll_index = 15 Then ads_datastore.Object.Column15.Primary = ldble_double_array[]
				If ll_index = 16 Then ads_datastore.Object.Column16.Primary = ldble_double_array[]
				If ll_index = 17 Then ads_datastore.Object.Column17.Primary = ldble_double_array[]
				If ll_index = 18 Then ads_datastore.Object.Column18.Primary = ldble_double_array[]
				If ll_index = 19 Then ads_datastore.Object.Column19.Primary = ldble_double_array[]
				If ll_index = 20 Then ads_datastore.Object.Column20.Primary = ldble_double_array[]
				If ll_index = 21 Then ads_datastore.Object.Column21.Primary = ldble_double_array[]
				If ll_index = 22 Then ads_datastore.Object.Column22.Primary = ldble_double_array[]
				If ll_index = 23 Then ads_datastore.Object.Column23.Primary = ldble_double_array[]
				If ll_index = 24 Then ads_datastore.Object.Column24.Primary = ldble_double_array[]
				If ll_index = 25 Then ads_datastore.Object.Column25.Primary = ldble_double_array[]
				If ll_index = 26 Then ads_datastore.Object.Column26.Primary = ldble_double_array[]
				If ll_index = 27 Then ads_datastore.Object.Column27.Primary = ldble_double_array[]
				If ll_index = 28 Then ads_datastore.Object.Column28.Primary = ldble_double_array[]
				If ll_index = 29 Then ads_datastore.Object.Column29.Primary = ldble_double_array[]
				If ll_index = 30 Then ads_datastore.Object.Column30.Primary = ldble_double_array[]
				If ll_index = 31 Then ads_datastore.Object.Column31.Primary = ldble_double_array[]
				If ll_index = 32 Then ads_datastore.Object.Column32.Primary = ldble_double_array[]
				If ll_index = 33 Then ads_datastore.Object.Column33.Primary = ldble_double_array[]
				If ll_index = 34 Then ads_datastore.Object.Column34.Primary = ldble_double_array[]
				If ll_index = 35 Then ads_datastore.Object.Column35.Primary = ldble_double_array[]
				If ll_index = 36 Then ads_datastore.Object.Column36.Primary = ldble_double_array[]
				If ll_index = 37 Then ads_datastore.Object.Column37.Primary = ldble_double_array[]
				If ll_index = 38 Then ads_datastore.Object.Column38.Primary = ldble_double_array[]
				If ll_index = 39 Then ads_datastore.Object.Column39.Primary = ldble_double_array[]
				If ll_index = 40 Then ads_datastore.Object.Column40.Primary = ldble_double_array[]
				If ll_index = 41 Then ads_datastore.Object.Column41.Primary = ldble_double_array[]
				If ll_index = 42 Then ads_datastore.Object.Column42.Primary = ldble_double_array[]
				If ll_index = 43 Then ads_datastore.Object.Column43.Primary = ldble_double_array[]
				If ll_index = 44 Then ads_datastore.Object.Column44.Primary = ldble_double_array[]
				If ll_index = 45 Then ads_datastore.Object.Column45.Primary = ldble_double_array[]
				If ll_index = 46 Then ads_datastore.Object.Column46.Primary = ldble_double_array[]
				If ll_index = 47 Then ads_datastore.Object.Column47.Primary = ldble_double_array[]
				If ll_index = 48 Then ads_datastore.Object.Column48.Primary = ldble_double_array[]
				If ll_index = 49 Then ads_datastore.Object.Column49.Primary = ldble_double_array[]
				If ll_index = 50 Then ads_datastore.Object.Column50.Primary = ldble_double_array[]
				If ll_index = 51 Then ads_datastore.Object.Column51.Primary = ldble_double_array[]
				If ll_index = 52 Then ads_datastore.Object.Column52.Primary = ldble_double_array[]
				If ll_index = 53 Then ads_datastore.Object.Column53.Primary = ldble_double_array[]
				If ll_index = 54 Then ads_datastore.Object.Column54.Primary = ldble_double_array[]
				If ll_index = 55 Then ads_datastore.Object.Column55.Primary = ldble_double_array[]
				If ll_index = 56 Then ads_datastore.Object.Column56.Primary = ldble_double_array[]
				If ll_index = 57 Then ads_datastore.Object.Column57.Primary = ldble_double_array[]
				If ll_index = 58 Then ads_datastore.Object.Column58.Primary = ldble_double_array[]
				If ll_index = 59 Then ads_datastore.Object.Column59.Primary = ldble_double_array[]
				If ll_index = 60 Then ads_datastore.Object.Column60.Primary = ldble_double_array[]
				If ll_index = 61 Then ads_datastore.Object.Column61.Primary = ldble_double_array[]
				If ll_index = 62 Then ads_datastore.Object.Column62.Primary = ldble_double_array[]
				If ll_index = 63 Then ads_datastore.Object.Column63.Primary = ldble_double_array[]
				If ll_index = 64 Then ads_datastore.Object.Column64.Primary = ldble_double_array[]
				If ll_index = 65 Then ads_datastore.Object.Column65.Primary = ldble_double_array[]
				If ll_index = 66 Then ads_datastore.Object.Column66.Primary = ldble_double_array[]
				If ll_index = 67 Then ads_datastore.Object.Column67.Primary = ldble_double_array[]
				If ll_index = 68 Then ads_datastore.Object.Column68.Primary = ldble_double_array[]
				If ll_index = 69 Then ads_datastore.Object.Column69.Primary = ldble_double_array[]
				If ll_index = 70 Then ads_datastore.Object.Column70.Primary = ldble_double_array[]
				If ll_index = 71 Then ads_datastore.Object.Column71.Primary = ldble_double_array[]
				If ll_index = 72 Then ads_datastore.Object.Column72.Primary = ldble_double_array[]
				If ll_index = 73 Then ads_datastore.Object.Column73.Primary = ldble_double_array[]
				If ll_index = 74 Then ads_datastore.Object.Column74.Primary = ldble_double_array[]
				If ll_index = 75 Then ads_datastore.Object.Column75.Primary = ldble_double_array[]
				If ll_index = 76 Then ads_datastore.Object.Column76.Primary = ldble_double_array[]
				If ll_index = 77 Then ads_datastore.Object.Column77.Primary = ldble_double_array[]
				If ll_index = 78 Then ads_datastore.Object.Column78.Primary = ldble_double_array[]
				If ll_index = 79 Then ads_datastore.Object.Column79.Primary = ldble_double_array[]
				If ll_index = 80 Then ads_datastore.Object.Column80.Primary = ldble_double_array[]
				If ll_index = 81 Then ads_datastore.Object.Column81.Primary = ldble_double_array[]
				If ll_index = 82 Then ads_datastore.Object.Column82.Primary = ldble_double_array[]
				If ll_index = 83 Then ads_datastore.Object.Column83.Primary = ldble_double_array[]
				If ll_index = 84 Then ads_datastore.Object.Column84.Primary = ldble_double_array[]
				If ll_index = 85 Then ads_datastore.Object.Column85.Primary = ldble_double_array[]
				If ll_index = 86 Then ads_datastore.Object.Column86.Primary = ldble_double_array[]
				If ll_index = 87 Then ads_datastore.Object.Column87.Primary = ldble_double_array[]
				If ll_index = 88 Then ads_datastore.Object.Column88.Primary = ldble_double_array[]
				If ll_index = 89 Then ads_datastore.Object.Column89.Primary = ldble_double_array[]
				If ll_index = 90 Then ads_datastore.Object.Column90.Primary = ldble_double_array[]
				If ll_index = 91 Then ads_datastore.Object.Column91.Primary = ldble_double_array[]
				If ll_index = 92 Then ads_datastore.Object.Column92.Primary = ldble_double_array[]
				If ll_index = 93 Then ads_datastore.Object.Column93.Primary = ldble_double_array[]
				If ll_index = 94 Then ads_datastore.Object.Column94.Primary = ldble_double_array[]
				If ll_index = 95 Then ads_datastore.Object.Column95.Primary = ldble_double_array[]
				If ll_index = 96 Then ads_datastore.Object.Column96.Primary = ldble_double_array[]
				If ll_index = 97 Then ads_datastore.Object.Column97.Primary = ldble_double_array[]
				If ll_index = 98 Then ads_datastore.Object.Column98.Primary = ldble_double_array[]
				If ll_index = 99 Then ads_datastore.Object.Column99.Primary = ldble_double_array[]
				If ll_index = 100 Then ads_datastore.Object.Column100.Primary = ldble_double_array[]
			Case 'string'
				If ll_index = 1 Then ads_datastore.Object.Column1.Primary = ls_string_array[]
				If ll_index = 2 Then ads_datastore.Object.Column2.Primary = ls_string_array[]
				If ll_index = 3 Then ads_datastore.Object.Column3.Primary = ls_string_array[]
				If ll_index = 4 Then ads_datastore.Object.Column4.Primary = ls_string_array[]
				If ll_index = 5 Then ads_datastore.Object.Column5.Primary = ls_string_array[]
				If ll_index = 6 Then ads_datastore.Object.Column6.Primary = ls_string_array[]
				If ll_index = 7 Then ads_datastore.Object.Column7.Primary = ls_string_array[]
				If ll_index = 8 Then ads_datastore.Object.Column8.Primary = ls_string_array[]
				If ll_index = 9 Then ads_datastore.Object.Column9.Primary = ls_string_array[]
				If ll_index = 10 Then ads_datastore.Object.Column10.Primary = ls_string_array[]
				If ll_index = 11 Then ads_datastore.Object.Column11.Primary = ls_string_array[]
				If ll_index = 12 Then ads_datastore.Object.Column12.Primary = ls_string_array[]
				If ll_index = 13 Then ads_datastore.Object.Column13.Primary = ls_string_array[]
				If ll_index = 14 Then ads_datastore.Object.Column14.Primary = ls_string_array[]
				If ll_index = 15 Then ads_datastore.Object.Column15.Primary = ls_string_array[]
				If ll_index = 16 Then ads_datastore.Object.Column16.Primary = ls_string_array[]
				If ll_index = 17 Then ads_datastore.Object.Column17.Primary = ls_string_array[]
				If ll_index = 18 Then ads_datastore.Object.Column18.Primary = ls_string_array[]
				If ll_index = 19 Then ads_datastore.Object.Column19.Primary = ls_string_array[]
				If ll_index = 20 Then ads_datastore.Object.Column20.Primary = ls_string_array[]
				If ll_index = 21 Then ads_datastore.Object.Column21.Primary = ls_string_array[]
				If ll_index = 22 Then ads_datastore.Object.Column22.Primary = ls_string_array[]
				If ll_index = 23 Then ads_datastore.Object.Column23.Primary = ls_string_array[]
				If ll_index = 24 Then ads_datastore.Object.Column24.Primary = ls_string_array[]
				If ll_index = 25 Then ads_datastore.Object.Column25.Primary = ls_string_array[]
				If ll_index = 26 Then ads_datastore.Object.Column26.Primary = ls_string_array[]
				If ll_index = 27 Then ads_datastore.Object.Column27.Primary = ls_string_array[]
				If ll_index = 28 Then ads_datastore.Object.Column28.Primary = ls_string_array[]
				If ll_index = 29 Then ads_datastore.Object.Column29.Primary = ls_string_array[]
				If ll_index = 30 Then ads_datastore.Object.Column30.Primary = ls_string_array[]
				If ll_index = 31 Then ads_datastore.Object.Column31.Primary = ls_string_array[]
				If ll_index = 32 Then ads_datastore.Object.Column32.Primary = ls_string_array[]
				If ll_index = 33 Then ads_datastore.Object.Column33.Primary = ls_string_array[]
				If ll_index = 34 Then ads_datastore.Object.Column34.Primary = ls_string_array[]
				If ll_index = 35 Then ads_datastore.Object.Column35.Primary = ls_string_array[]
				If ll_index = 36 Then ads_datastore.Object.Column36.Primary = ls_string_array[]
				If ll_index = 37 Then ads_datastore.Object.Column37.Primary = ls_string_array[]
				If ll_index = 38 Then ads_datastore.Object.Column38.Primary = ls_string_array[]
				If ll_index = 39 Then ads_datastore.Object.Column39.Primary = ls_string_array[]
				If ll_index = 40 Then ads_datastore.Object.Column40.Primary = ls_string_array[]
				If ll_index = 41 Then ads_datastore.Object.Column41.Primary = ls_string_array[]
				If ll_index = 42 Then ads_datastore.Object.Column42.Primary = ls_string_array[]
				If ll_index = 43 Then ads_datastore.Object.Column43.Primary = ls_string_array[]
				If ll_index = 44 Then ads_datastore.Object.Column44.Primary = ls_string_array[]
				If ll_index = 45 Then ads_datastore.Object.Column45.Primary = ls_string_array[]
				If ll_index = 46 Then ads_datastore.Object.Column46.Primary = ls_string_array[]
				If ll_index = 47 Then ads_datastore.Object.Column47.Primary = ls_string_array[]
				If ll_index = 48 Then ads_datastore.Object.Column48.Primary = ls_string_array[]
				If ll_index = 49 Then ads_datastore.Object.Column49.Primary = ls_string_array[]
				If ll_index = 50 Then ads_datastore.Object.Column50.Primary = ls_string_array[]
				If ll_index = 51 Then ads_datastore.Object.Column51.Primary = ls_string_array[]
				If ll_index = 52 Then ads_datastore.Object.Column52.Primary = ls_string_array[]
				If ll_index = 53 Then ads_datastore.Object.Column53.Primary = ls_string_array[]
				If ll_index = 54 Then ads_datastore.Object.Column54.Primary = ls_string_array[]
				If ll_index = 55 Then ads_datastore.Object.Column55.Primary = ls_string_array[]
				If ll_index = 56 Then ads_datastore.Object.Column56.Primary = ls_string_array[]
				If ll_index = 57 Then ads_datastore.Object.Column57.Primary = ls_string_array[]
				If ll_index = 58 Then ads_datastore.Object.Column58.Primary = ls_string_array[]
				If ll_index = 59 Then ads_datastore.Object.Column59.Primary = ls_string_array[]
				If ll_index = 60 Then ads_datastore.Object.Column60.Primary = ls_string_array[]
				If ll_index = 61 Then ads_datastore.Object.Column61.Primary = ls_string_array[]
				If ll_index = 62 Then ads_datastore.Object.Column62.Primary = ls_string_array[]
				If ll_index = 63 Then ads_datastore.Object.Column63.Primary = ls_string_array[]
				If ll_index = 64 Then ads_datastore.Object.Column64.Primary = ls_string_array[]
				If ll_index = 65 Then ads_datastore.Object.Column65.Primary = ls_string_array[]
				If ll_index = 66 Then ads_datastore.Object.Column66.Primary = ls_string_array[]
				If ll_index = 67 Then ads_datastore.Object.Column67.Primary = ls_string_array[]
				If ll_index = 68 Then ads_datastore.Object.Column68.Primary = ls_string_array[]
				If ll_index = 69 Then ads_datastore.Object.Column69.Primary = ls_string_array[]
				If ll_index = 70 Then ads_datastore.Object.Column70.Primary = ls_string_array[]
				If ll_index = 71 Then ads_datastore.Object.Column71.Primary = ls_string_array[]
				If ll_index = 72 Then ads_datastore.Object.Column72.Primary = ls_string_array[]
				If ll_index = 73 Then ads_datastore.Object.Column73.Primary = ls_string_array[]
				If ll_index = 74 Then ads_datastore.Object.Column74.Primary = ls_string_array[]
				If ll_index = 75 Then ads_datastore.Object.Column75.Primary = ls_string_array[]
				If ll_index = 76 Then ads_datastore.Object.Column76.Primary = ls_string_array[]
				If ll_index = 77 Then ads_datastore.Object.Column77.Primary = ls_string_array[]
				If ll_index = 78 Then ads_datastore.Object.Column78.Primary = ls_string_array[]
				If ll_index = 79 Then ads_datastore.Object.Column79.Primary = ls_string_array[]
				If ll_index = 80 Then ads_datastore.Object.Column80.Primary = ls_string_array[]
				If ll_index = 81 Then ads_datastore.Object.Column81.Primary = ls_string_array[]
				If ll_index = 82 Then ads_datastore.Object.Column82.Primary = ls_string_array[]
				If ll_index = 83 Then ads_datastore.Object.Column83.Primary = ls_string_array[]
				If ll_index = 84 Then ads_datastore.Object.Column84.Primary = ls_string_array[]
				If ll_index = 85 Then ads_datastore.Object.Column85.Primary = ls_string_array[]
				If ll_index = 86 Then ads_datastore.Object.Column86.Primary = ls_string_array[]
				If ll_index = 87 Then ads_datastore.Object.Column87.Primary = ls_string_array[]
				If ll_index = 88 Then ads_datastore.Object.Column88.Primary = ls_string_array[]
				If ll_index = 89 Then ads_datastore.Object.Column89.Primary = ls_string_array[]
				If ll_index = 90 Then ads_datastore.Object.Column90.Primary = ls_string_array[]
				If ll_index = 91 Then ads_datastore.Object.Column91.Primary = ls_string_array[]
				If ll_index = 92 Then ads_datastore.Object.Column92.Primary = ls_string_array[]
				If ll_index = 93 Then ads_datastore.Object.Column93.Primary = ls_string_array[]
				If ll_index = 94 Then ads_datastore.Object.Column94.Primary = ls_string_array[]
				If ll_index = 95 Then ads_datastore.Object.Column95.Primary = ls_string_array[]
				If ll_index = 96 Then ads_datastore.Object.Column96.Primary = ls_string_array[]
				If ll_index = 97 Then ads_datastore.Object.Column97.Primary = ls_string_array[]
				If ll_index = 98 Then ads_datastore.Object.Column98.Primary = ls_string_array[]
				If ll_index = 99 Then ads_datastore.Object.Column99.Primary = ls_string_array[]
				If ll_index = 100 Then ads_datastore.Object.Column100.Primary = ls_string_array[]
			Case 'datetime'
				If ll_index = 1 Then ads_datastore.Object.Column1.Primary = ldt_datetime_array[]
				If ll_index = 2 Then ads_datastore.Object.Column2.Primary = ldt_datetime_array[]
				If ll_index = 3 Then ads_datastore.Object.Column3.Primary = ldt_datetime_array[]
				If ll_index = 4 Then ads_datastore.Object.Column4.Primary = ldt_datetime_array[]
				If ll_index = 5 Then ads_datastore.Object.Column5.Primary = ldt_datetime_array[]
				If ll_index = 6 Then ads_datastore.Object.Column6.Primary = ldt_datetime_array[]
				If ll_index = 7 Then ads_datastore.Object.Column7.Primary = ldt_datetime_array[]
				If ll_index = 8 Then ads_datastore.Object.Column8.Primary = ldt_datetime_array[]
				If ll_index = 9 Then ads_datastore.Object.Column9.Primary = ldt_datetime_array[]
				If ll_index = 10 Then ads_datastore.Object.Column10.Primary = ldt_datetime_array[]
				If ll_index = 11 Then ads_datastore.Object.Column11.Primary = ldt_datetime_array[]
				If ll_index = 12 Then ads_datastore.Object.Column12.Primary = ldt_datetime_array[]
				If ll_index = 13 Then ads_datastore.Object.Column13.Primary = ldt_datetime_array[]
				If ll_index = 14 Then ads_datastore.Object.Column14.Primary = ldt_datetime_array[]
				If ll_index = 15 Then ads_datastore.Object.Column15.Primary = ldt_datetime_array[]
				If ll_index = 16 Then ads_datastore.Object.Column16.Primary = ldt_datetime_array[]
				If ll_index = 17 Then ads_datastore.Object.Column17.Primary = ldt_datetime_array[]
				If ll_index = 18 Then ads_datastore.Object.Column18.Primary = ldt_datetime_array[]
				If ll_index = 19 Then ads_datastore.Object.Column19.Primary = ldt_datetime_array[]
				If ll_index = 20 Then ads_datastore.Object.Column20.Primary = ldt_datetime_array[]
				If ll_index = 21 Then ads_datastore.Object.Column21.Primary = ldt_datetime_array[]
				If ll_index = 22 Then ads_datastore.Object.Column22.Primary = ldt_datetime_array[]
				If ll_index = 23 Then ads_datastore.Object.Column23.Primary = ldt_datetime_array[]
				If ll_index = 24 Then ads_datastore.Object.Column24.Primary = ldt_datetime_array[]
				If ll_index = 25 Then ads_datastore.Object.Column25.Primary = ldt_datetime_array[]
				If ll_index = 26 Then ads_datastore.Object.Column26.Primary = ldt_datetime_array[]
				If ll_index = 27 Then ads_datastore.Object.Column27.Primary = ldt_datetime_array[]
				If ll_index = 28 Then ads_datastore.Object.Column28.Primary = ldt_datetime_array[]
				If ll_index = 29 Then ads_datastore.Object.Column29.Primary = ldt_datetime_array[]
				If ll_index = 30 Then ads_datastore.Object.Column30.Primary = ldt_datetime_array[]
				If ll_index = 31 Then ads_datastore.Object.Column31.Primary = ldt_datetime_array[]
				If ll_index = 32 Then ads_datastore.Object.Column32.Primary = ldt_datetime_array[]
				If ll_index = 33 Then ads_datastore.Object.Column33.Primary = ldt_datetime_array[]
				If ll_index = 34 Then ads_datastore.Object.Column34.Primary = ldt_datetime_array[]
				If ll_index = 35 Then ads_datastore.Object.Column35.Primary = ldt_datetime_array[]
				If ll_index = 36 Then ads_datastore.Object.Column36.Primary = ldt_datetime_array[]
				If ll_index = 37 Then ads_datastore.Object.Column37.Primary = ldt_datetime_array[]
				If ll_index = 38 Then ads_datastore.Object.Column38.Primary = ldt_datetime_array[]
				If ll_index = 39 Then ads_datastore.Object.Column39.Primary = ldt_datetime_array[]
				If ll_index = 40 Then ads_datastore.Object.Column40.Primary = ldt_datetime_array[]
				If ll_index = 41 Then ads_datastore.Object.Column41.Primary = ldt_datetime_array[]
				If ll_index = 42 Then ads_datastore.Object.Column42.Primary = ldt_datetime_array[]
				If ll_index = 43 Then ads_datastore.Object.Column43.Primary = ldt_datetime_array[]
				If ll_index = 44 Then ads_datastore.Object.Column44.Primary = ldt_datetime_array[]
				If ll_index = 45 Then ads_datastore.Object.Column45.Primary = ldt_datetime_array[]
				If ll_index = 46 Then ads_datastore.Object.Column46.Primary = ldt_datetime_array[]
				If ll_index = 47 Then ads_datastore.Object.Column47.Primary = ldt_datetime_array[]
				If ll_index = 48 Then ads_datastore.Object.Column48.Primary = ldt_datetime_array[]
				If ll_index = 49 Then ads_datastore.Object.Column49.Primary = ldt_datetime_array[]
				If ll_index = 50 Then ads_datastore.Object.Column50.Primary = ldt_datetime_array[]
				If ll_index = 51 Then ads_datastore.Object.Column51.Primary = ldt_datetime_array[]
				If ll_index = 52 Then ads_datastore.Object.Column52.Primary = ldt_datetime_array[]
				If ll_index = 53 Then ads_datastore.Object.Column53.Primary = ldt_datetime_array[]
				If ll_index = 54 Then ads_datastore.Object.Column54.Primary = ldt_datetime_array[]
				If ll_index = 55 Then ads_datastore.Object.Column55.Primary = ldt_datetime_array[]
				If ll_index = 56 Then ads_datastore.Object.Column56.Primary = ldt_datetime_array[]
				If ll_index = 57 Then ads_datastore.Object.Column57.Primary = ldt_datetime_array[]
				If ll_index = 58 Then ads_datastore.Object.Column58.Primary = ldt_datetime_array[]
				If ll_index = 59 Then ads_datastore.Object.Column59.Primary = ldt_datetime_array[]
				If ll_index = 60 Then ads_datastore.Object.Column60.Primary = ldt_datetime_array[]
				If ll_index = 61 Then ads_datastore.Object.Column61.Primary = ldt_datetime_array[]
				If ll_index = 62 Then ads_datastore.Object.Column62.Primary = ldt_datetime_array[]
				If ll_index = 63 Then ads_datastore.Object.Column63.Primary = ldt_datetime_array[]
				If ll_index = 64 Then ads_datastore.Object.Column64.Primary = ldt_datetime_array[]
				If ll_index = 65 Then ads_datastore.Object.Column65.Primary = ldt_datetime_array[]
				If ll_index = 66 Then ads_datastore.Object.Column66.Primary = ldt_datetime_array[]
				If ll_index = 67 Then ads_datastore.Object.Column67.Primary = ldt_datetime_array[]
				If ll_index = 68 Then ads_datastore.Object.Column68.Primary = ldt_datetime_array[]
				If ll_index = 69 Then ads_datastore.Object.Column69.Primary = ldt_datetime_array[]
				If ll_index = 70 Then ads_datastore.Object.Column70.Primary = ldt_datetime_array[]
				If ll_index = 71 Then ads_datastore.Object.Column71.Primary = ldt_datetime_array[]
				If ll_index = 72 Then ads_datastore.Object.Column72.Primary = ldt_datetime_array[]
				If ll_index = 73 Then ads_datastore.Object.Column73.Primary = ldt_datetime_array[]
				If ll_index = 74 Then ads_datastore.Object.Column74.Primary = ldt_datetime_array[]
				If ll_index = 75 Then ads_datastore.Object.Column75.Primary = ldt_datetime_array[]
				If ll_index = 76 Then ads_datastore.Object.Column76.Primary = ldt_datetime_array[]
				If ll_index = 77 Then ads_datastore.Object.Column77.Primary = ldt_datetime_array[]
				If ll_index = 78 Then ads_datastore.Object.Column78.Primary = ldt_datetime_array[]
				If ll_index = 79 Then ads_datastore.Object.Column79.Primary = ldt_datetime_array[]
				If ll_index = 80 Then ads_datastore.Object.Column80.Primary = ldt_datetime_array[]
				If ll_index = 81 Then ads_datastore.Object.Column81.Primary = ldt_datetime_array[]
				If ll_index = 82 Then ads_datastore.Object.Column82.Primary = ldt_datetime_array[]
				If ll_index = 83 Then ads_datastore.Object.Column83.Primary = ldt_datetime_array[]
				If ll_index = 84 Then ads_datastore.Object.Column84.Primary = ldt_datetime_array[]
				If ll_index = 85 Then ads_datastore.Object.Column85.Primary = ldt_datetime_array[]
				If ll_index = 86 Then ads_datastore.Object.Column86.Primary = ldt_datetime_array[]
				If ll_index = 87 Then ads_datastore.Object.Column87.Primary = ldt_datetime_array[]
				If ll_index = 88 Then ads_datastore.Object.Column88.Primary = ldt_datetime_array[]
				If ll_index = 89 Then ads_datastore.Object.Column89.Primary = ldt_datetime_array[]
				If ll_index = 90 Then ads_datastore.Object.Column90.Primary = ldt_datetime_array[]
				If ll_index = 91 Then ads_datastore.Object.Column91.Primary = ldt_datetime_array[]
				If ll_index = 92 Then ads_datastore.Object.Column92.Primary = ldt_datetime_array[]
				If ll_index = 93 Then ads_datastore.Object.Column93.Primary = ldt_datetime_array[]
				If ll_index = 94 Then ads_datastore.Object.Column94.Primary = ldt_datetime_array[]
				If ll_index = 95 Then ads_datastore.Object.Column95.Primary = ldt_datetime_array[]
				If ll_index = 96 Then ads_datastore.Object.Column96.Primary = ldt_datetime_array[]
				If ll_index = 97 Then ads_datastore.Object.Column97.Primary = ldt_datetime_array[]
				If ll_index = 98 Then ads_datastore.Object.Column98.Primary = ldt_datetime_array[]
				If ll_index = 99 Then ads_datastore.Object.Column99.Primary = ldt_datetime_array[]
				If ll_index = 100 Then ads_datastore.Object.Column100.Primary = ldt_datetime_array[]
		End Choose		
	Next
End If

Return ''
end function

on n_export_datawindow_wysiwyg.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_export_datawindow_wysiwyg.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

