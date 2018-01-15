$PBExportHeader$n_rowfocus_service.sru
$PBExportComments$Datawindow Service - This will handle the mousemove hightlight and the theme selectrow for any datawindow.  It defaults to multiselect.
forward
global type n_rowfocus_service from nonvisualobject
end type
end forward

global type n_rowfocus_service from nonvisualobject
event ue_notify ( string as_string,  any aany_any )
event ue_refreshtheme ( )
end type
global n_rowfocus_service n_rowfocus_service

type variables
Protected:
	Long il_last_row, il_last_selected, il_last_shift_selected, il_rows_selected = 0
	PowerObject idw_data
	Boolean ib_highlight = True, ib_select = True
	boolean ib_multi = true
	Boolean ib_hassubscribed = False
	Boolean ib_rightclicked = false
	Transaction ixctn_transaction
	Long	il_redraw_count
	Boolean	ib_redrawison = True
	Boolean	ib_ApplyGUIRules	= False
	String	is_LastObjectThatIChangedTheBorderOn = ''
	Boolean	ib_ignorerowfocuschanged = False
		
	Boolean	ib_RespondToMessages = True
end variables

forward prototypes
public subroutine of_retrieveend ()
public subroutine of_set_multiselect (boolean ab_multiselect)
public subroutine of_get_dimensions (ref long al_x, ref long al_width)
public function boolean of_is_selecting ()
public subroutine of_destroy_objects ()
public subroutine of_reinitialize ()
public function long of_getselectedrow (long al_start)
protected subroutine of_clear_selectrow ()
public subroutine of_highlightrow (long row)
public subroutine of_selectall ()
public subroutine of_rbuttondown (long row)
public subroutine of_printstart (long pagesmax)
public subroutine of_printend (long pagesprinted)
public subroutine of_clicked (long row)
public subroutine of_mousemove (long xpos, long ypos, long row, dwobject dwo)
protected subroutine of_resize_objects ()
public subroutine of_init (ref powerobject adw_data)
public subroutine of_setredraw (boolean ab_trueorfalse)
public subroutine of_reset ()
public subroutine of_rowfocuschanged (long row)
public subroutine of_setrow (long row)
protected subroutine of_clear_indicator ()
protected subroutine of_create_rowfocusinidicator ()
end prototypes

event ue_notify(string as_string, any aany_any);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This will respond to the theme change subscription
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long 	ll_width, ll_index
Long	ll_x, ll_pagenumber_width

Choose Case Lower(as_string)
	Case 'sort', 'group by happened', 'filter'
		This.of_reset()
	Case 'themechange' 
		TriggerEvent('ue_refreshtheme')
	Case 'before view saved', 'before generate'
		If ib_RespondToMessages Then This.of_destroy_objects()
	Case 'after view restored', 'after generate'
		If ib_RespondToMessages Then This.of_reinitialize()
	Case 'columnresize', 'visible columns changed'
		If ib_RespondToMessages Then
			This.of_resize_objects()
			This.of_reinitialize()
		End If
	Case 'before recreate view'
		ib_RespondToMessages = False
	Case 'recreate view - row focus'
		ib_RespondToMessages = True
		This.of_resize_objects()
		This.of_reinitialize()
End Choose
end event

event ue_refreshtheme();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Event Name
// Overrides:  No
// Overview:   This is the response to the theme change
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Change the color of the selectrow rectangle to match the theme
If IsValid(idw_data) Then
	If IsValid(gn_globals.of_get_object('n_theme')) Then
		idw_data.Dynamic Modify("r_selectrow.Brush.Color='" + String(gn_globals.of_get_object('n_theme').Dynamic of_get_backcolor()) + "'")
	End If
End If
end event

public subroutine of_retrieveend ();This.of_reset()
end subroutine

public subroutine of_set_multiselect (boolean ab_multiselect);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_multiselect()
// Arguments:   ab_multiselect - Whether or not to use multiselect
// Overview:    This will set the multiselect attribute
// Created by:  Blake Doerr
// History:     6/24/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_multi = ab_multiselect
end subroutine

public subroutine of_get_dimensions (ref long al_x, ref long al_width);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_object[]
String	ls_x[]
String	ls_width[]
Long		ll_upperbound
Long		ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools	ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// If the datawindow isn't valid, return a number
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then
	al_x = 1
	al_width = 20000
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the x's and widths into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_all_object_property(idw_data, '.X', ls_object[], ls_x[], True)
ln_datawindow_tools.of_get_all_object_property(idw_data, '.Width', ls_object[], ls_width[], True)
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the upperbound of the two arrays
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = Min(UpperBound(ls_x[]), UpperBound(ls_width[]))
al_x = 20000
al_width = 0

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all stats and find the max
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = ll_upperbound To 1 Step -1
	If Match(Lower(ls_object[ll_index]), 'report_title') Then Continue
	If Match(Lower(ls_object[ll_index]), 'report_footer') Then Continue
	If Match(Lower(ls_object[ll_index]), 'report_bitmap') Then Continue
	If Match(Lower(ls_object[ll_index]), 'report_pagenumber') Then Continue
	If Match(Lower(ls_object[ll_index]), '_direction_srt') Then Continue
	If Not IsNumber(ls_x[ll_index]) Or Not IsNumber(ls_width[ll_index]) Then Continue
	al_width 	= Max(al_width, Long(ls_x[ll_index]) + Long(ls_width[ll_index]))
	al_x 			= Min(al_x, Long(ls_x[ll_index]))
Next

al_width = al_width - al_x + 50
end subroutine

public function boolean of_is_selecting ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_is_selecting()
//	Overview:   This will return whether or not we are selecting rows
//	Created by:	Blake Doerr
//	History: 	2/4/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ib_select
end function

public subroutine of_destroy_objects ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_destroy_objects()
// Overview:    This will create the line objects on the datawindow that will be used to resize the columns
// Created by:  Blake Doerr
// History:     2/20/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


If IsValid(idw_data) Then
	idw_data.Dynamic Modify('Destroy r_selectrow')
	idw_data.Dynamic Modify('Destroy r_highlight')
End If
end subroutine

public subroutine of_reinitialize ();This.of_init(idw_data)
end subroutine

public function long of_getselectedrow (long al_start);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_getselectedrow()
// Arguments:   al_start - the row to start on
// Overview:    This will find the next row that is selected
// Created by:  Blake Doerr
// History:     6/13/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long ll_row

//Return null if it is null
If IsNull(al_start) Then Return al_start

//Return if there is not selectrowindicator
If Not ib_select Then Return 0

//If it is greater than or equal to rowcount, return 0
If al_start >= idw_data.Dynamic RowCount() Then
	ll_row = 0
Else
	ll_row = idw_data.Dynamic Find("selectrowindicator = 'Y'", al_start + 1, idw_data.Dynamic RowCount())
End If

//Return 0 if there was an error
If ll_row < 0 Then ll_row = 0	

return ll_row
end function

protected subroutine of_clear_selectrow ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_clear_indicator()
// Arguments:   
// Overview:    This will clear the selectrow indicator for the previously selected row
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Set the selectrow indicator column to empty string

If il_last_selected > 0 And Not IsNull(il_last_selected) And ib_select Then
	idw_data.Dynamic SetItem(il_last_selected , 'selectrowindicator', '')
End If

SetNull(il_last_selected)
end subroutine

public subroutine of_highlightrow (long row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_highlightrow()
//	Arguments:  row - 
//	Overview:   Highlight a row
//	Created by:	Blake Doerr
//	History: 	2/23/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

idw_data.Dynamic SetItem(row, 'selectrowindicator', 'Y')
end subroutine

public subroutine of_selectall ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_selectall()
//	Overview:   This will select all the rows
//	Created by:	Blake Doerr
//	History: 	7.16.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Long ll_index, ll_rowcount
If ib_select And IsValid(idw_data) Then
	This.of_setredraw(False)
	ll_rowcount = idw_data.Dynamic RowCount()
	For ll_index = 1 To ll_rowcount
		idw_data.Dynamic SetItem(ll_index, 'selectrowindicator', 'Y')
	Next
	This.of_setredraw(True)
End If
end subroutine

public subroutine of_rbuttondown (long row);If IsNull(row) Or row < 0 Or row > idw_data.Dynamic RowCount() Then Return

ib_rightclicked = True
This.of_setrow(row)
ib_rightclicked = False
end subroutine

public subroutine of_printstart (long pagesmax);idw_data.Dynamic Modify("line_header.Pen.Color = '0'")
idw_data.Dynamic Modify("line_header1.Pen.Color = '0'")
idw_data.Dynamic Modify("line_header2.Pen.Color = '0'")
idw_data.Dynamic Modify("line_header3.Pen.Color = '0'")
idw_data.Dynamic Modify("line_header4.Pen.Color = '0'")
idw_data.Dynamic Modify("line_header5.Pen.Color = '0'")
idw_data.Dynamic Modify("line_detail.Pen.Color = '0'")
idw_data.Dynamic Modify("line_detail1.Pen.Color = '0'")
idw_data.Dynamic Modify("line_detail2.Pen.Color = '0'")
idw_data.Dynamic Modify("line_detail3.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer1.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer2.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer3.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer4.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer5.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer6.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer7.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer8.Pen.Color = '0'")
idw_data.Dynamic Modify("line_footer9.Pen.Color = '0'")
end subroutine

public subroutine of_printend (long pagesprinted);//This.of_reinitialize()
idw_data.Dynamic Modify("line_header.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_header1.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_header2.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_header3.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_header4.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_header5.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_detail.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_detail1.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_detail2.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_detail3.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer1.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer2.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer3.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer4.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer5.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer6.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer7.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer8.Pen.Color = '12632256'")
idw_data.Dynamic Modify("line_footer9.Pen.Color = '12632256'")
end subroutine

public subroutine of_clicked (long row);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   This is the code for the clicked event
// Created by: Blake Doerr
// History:    6/24/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

 
n_multimedia ln_multimedia

If IsNull(row) Or row < 0 Or row > idw_data.Dynamic RowCount() Then Return

ln_multimedia.of_play_sound('Module - SmartSearch - SelectRow.wav')

if len(String(idw_data.Dynamic getcolumnname())) > 0 then 
	This.of_setrow(row)
end if

end subroutine

public subroutine of_mousemove (long xpos, long ypos, long row, dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_mousemove()
// Arguments:   row - the row
// Overview:    This will move the rowfocusindicator with the mouse
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean lb_underlined
String	ls_datawindow_object_name

//Clear the indicator from the last row
If Not IsValid(idw_data) Or Not ib_highlight Then Return

If il_last_row > 0 and il_last_row <> row then	
	of_clear_indicator()	
End If

//Turn the indicator on for the new row
If row <> il_last_row Then
	If row > 0 And Not IsNull(row) Then
		idw_data.Dynamic SetItem(row, 'rowfocusindicator', 'Y')
		il_last_row = row
	End If
End If

If Not ib_ApplyGUIRules Then Return

If IsValid(dwo) Then
	ls_datawindow_object_name = dwo.Name
	If Right(ls_datawindow_object_name, 14) = '_direction_srt' Then
		ls_datawindow_object_name = Left(ls_datawindow_object_name, Len(ls_datawindow_object_name) - 14)
	End If
End If

If Len(is_LastObjectThatIChangedTheBorderOn) > 0 Then
	If is_LastObjectThatIChangedTheBorderOn = ls_datawindow_object_name Then Return
	
	Choose Case is_LastObjectThatIChangedTheBorderOn
		Case 'report_title'
			idw_data.Dynamic Modify('report_title.Font.Underline=~'0~'')
		Case Else
			idw_data.Dynamic Modify(is_LastObjectThatIChangedTheBorderOn + '.Border=~'0~'')
	End Choose
	
	is_LastObjectThatIChangedTheBorderOn = ''
End If

If Not IsValid(dwo) Then Return
If is_LastObjectThatIChangedTheBorderOn = ls_datawindow_object_name Then Return

Choose Case dwo.Type
	Case 'text'
		Choose Case ls_datawindow_object_name
			Case 'report_title'
				idw_data.Dynamic Modify(ls_datawindow_object_name + '.Font.Underline=~'1~'')
			Case Else
				If Right(ls_datawindow_object_name, 2) <> '_t' And Right(ls_datawindow_object_name, 4) <> '_srt' Then Return
				
				idw_data.Dynamic Modify(ls_datawindow_object_name + '.Border=~'6~'')
		End Choose
		
		is_LastObjectThatIChangedTheBorderOn = ls_datawindow_object_name
End Choose
end subroutine

protected subroutine of_resize_objects ();Long	ll_index
Long	ll_x
Long	ll_width
Long	ll_pagenumber_width

If Not IsValid(idw_data) Then Return

idw_data.Dynamic Modify("r_selectrow.Width = '0'")
idw_data.Dynamic Modify("r_highlight.Width = '0'")

This.of_get_dimensions(ll_x, ll_width)

idw_data.Dynamic Modify("r_selectrow.X = '" + String(ll_x) + "'")
idw_data.Dynamic Modify("r_highlight.X = '" + String(ll_x) + "'")
idw_data.Dynamic Modify("r_selectrow.Width = '" + String(ll_width) + "'")
idw_data.Dynamic Modify("r_highlight.Width = '" + String(ll_width) + "'")
	
idw_data.Dynamic Modify("r_highlight.Width = '" + String(ll_width) + "'")

idw_data.Dynamic Modify("line_detail.X2 = '" + String(ll_width + ll_x) + "'")
idw_data.Dynamic Modify("line_header.X2 = '" + String(ll_width + ll_x) + "'")
idw_data.Dynamic Modify("line_footer.X2 = '" + String(ll_width + ll_x) + "'")

For ll_index = 1 To 100
	If idw_data.Dynamic Modify("line_header" + String(ll_index) + ".X2 = '" + String(ll_width + ll_x) + "'") <> '' Then Exit
Next

For ll_index = 1 To 100
	If idw_data.Dynamic Modify("line_detail" + String(ll_index) + ".X2 = '" + String(ll_width + ll_x) + "'") <> '' Then Exit
Next

For ll_index = 1 To 100
	If idw_data.Dynamic Modify("line_footer" + String(ll_index) + ".X2 = '" + String(ll_width + ll_x) + "'") <> '' Then Exit
Next

idw_data.Dynamic Modify("line_footer_total1.X2 = '" + String(ll_width + ll_x) + "'")
idw_data.Dynamic Modify("line_footer_total2.X2 = '" + String(ll_width + ll_x) + "'")

If IsNumber(idw_data.Dynamic Describe('report_pagenumber.X')) Then
	ll_pagenumber_width = Long(idw_data.Dynamic Describe('report_pagenumber.Width'))
	idw_data.Dynamic Modify("report_pagenumber.X = '" + String(ll_width + ll_x - ll_pagenumber_width) + "'")
End If
end subroutine

public subroutine of_init (ref powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data - the datawindow target
// Overview:    This will initialize the datawindow and create the rowfocus indicators
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_expression
String	ls_multiselect

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools 
//n_string_functions ln_string_functions

idw_data = adw_data

If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_subscribe(This, 'Sort', 						idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Group By Happened', 	idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Filter', 					idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Before View Saved', 	idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'After View Restored', 	idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Before Generate', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'After Generate', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'ColumnResize', 			idw_data)	//Published by the column sizing service
		gn_globals.in_subscription_service.of_subscribe(This, 'Visible Columns Changed', 			idw_data)	//Published by the column sizing service
		gn_globals.in_subscription_service.of_subscribe(This, 'Before Recreate View', 			idw_data)	//Published by the column sizing service
		gn_globals.in_subscription_service.of_subscribe(This, 'Recreate View - Row Focus', 			idw_data)
	End If
End If

of_create_rowfocusinidicator()
This.of_reset()
This.Event ue_refreshtheme()


//-----------------------------------------------------------------------------------------------------------------------------------
// if the datawindow is valid, check for services
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Pull the expression off the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_expression = ln_datawindow_tools.of_get_expression(idw_data, 'rowfocusinit')
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the string is not valid
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(ls_expression) Or Len(ls_expression) = 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the include string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_multiselect 				= Trim(gn_globals.in_string_functions.of_find_argument	(Lower(ls_expression), '||', 'multiselect'))

Choose Case Lower(Trim(ls_multiselect))
	Case 'no', 'false'
		This.of_set_multiselect(False)
	Case Else
		This.of_set_multiselect(True)
End Choose
end subroutine

public subroutine of_setredraw (boolean ab_trueorfalse);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_setredraw()
// Arguments:   ab_trueorfalse - whether you want to turn it on or off
// Overview:    This will manage redraw so you can set it on and off in multiple levels of inheritance and it will only happen once
// Created by:  Blake Doerr
// History:     6/7/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If idw_data.TypeOf() <> Datawindow! Then Return

If ab_trueorfalse = True Then
	il_redraw_count = il_redraw_count - 1
	If il_redraw_count = 0 Then 
		idw_data.Dynamic SetRedraw(True)
		ib_redrawison = True
	End If
End If

If ab_trueorfalse = False Then
	If il_redraw_count = 0 Then 
		idw_data.Dynamic SetRedraw(False)
		ib_redrawison = False
	End If
	il_redraw_count = il_redraw_count + 1
End If
end subroutine

public subroutine of_reset ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_reset()
// Arguments:   
// Overview:    This will clear all the indicators and find the current row to highlight
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_row, ll_upperbound, ll_index
Boolean	lb_redraw_changed = False
String	ll_selectrowindicator[]
Datawindow	ldw_data

//Clear the selectrowindicator and find the current row
If Not IsValid(idw_data) Then Return

If il_rows_selected > 1 Then
	This.of_setredraw(False)
	lb_redraw_changed = True
End If

If ib_select Then
	of_clear_selectrow()
	If il_rows_selected > 100 Then
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ll_upperbound = ldw_data.RowCount()
				For ll_index = 1 To ll_upperbound
					ll_selectrowindicator[ll_index] = ''
				Next
				
				ll_row = ldw_data.GetRow()
				If ll_row > 0 And Not IsNull(ll_row) Then
					il_rows_selected = 1
					ll_selectrowindicator[ll_row] = 'Y'
					il_last_selected = ll_row
				Else
					il_rows_selected = 0
				End If
				
				If ll_upperbound > 0 Then
					ib_ignorerowfocuschanged = True
					ldw_data.Object.SelectRowIndicator.Primary = ll_selectrowindicator[]
					If ll_row <> ldw_data.GetRow() Then ldw_data.SetRow(ll_row)
					ib_ignorerowfocuschanged = False
				End If
		End Choose
	Else
		ll_row = idw_data.Dynamic Find("selectrowindicator = 'Y'", 1, idw_data.Dynamic RowCount())
		DO WHILE ll_row > 0
			idw_data.Dynamic SetItem(ll_row, 'selectrowindicator', '')
			ll_row = idw_data.Dynamic Find("selectrowindicator = 'Y'", ll_row, idw_data.Dynamic RowCount())
		LOOP
		
		ll_row = idw_data.Dynamic GetRow()
		If ll_row > 0 And Not IsNull(ll_row) Then
			il_rows_selected = 1
			idw_data.Dynamic SetItem(ll_row, 'selectrowindicator', 'Y')
			il_last_selected = ll_row
		Else
			il_rows_selected = 0
		End If
	End If
	
End If

//Clear all the rowfocusindicators
If ib_highlight Then
	of_clear_indicator()
	
	ll_row = idw_data.Dynamic Find("rowfocusindicator = 'Y'", 1, idw_data.Dynamic RowCount())
	DO WHILE ll_row > 0
		idw_data.Dynamic SetItem(ll_row, 'rowfocusindicator', '')
		ll_row = idw_data.Dynamic Find("rowfocusindicator = 'Y'", ll_row, idw_data.Dynamic RowCount())
	LOOP
End If

If lb_redraw_changed Then
	This.of_setredraw(True)
End If

end subroutine

public subroutine of_rowfocuschanged (long row);If Not ib_ignorerowfocuschanged Then This.of_setrow(row)
end subroutine

public subroutine of_setrow (long row);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_setrow()
// Arguments:   row - the current row in the datawindow
// Overview:    This will respond to the rowfocuschanged event and move the selectrowindicator
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
// 02/05/2002	21594	KCS	Removed the line which was preventing the first row from being selected
//-----------------------------------------------------------------------------------------------------------------------------------

long ll_index, ll_return, ll_row, ll_upperbound
String ls_data
String	ll_selectrowindicator[]
Boolean KeyShift, KeyControl
Datawindow ldw_data

If Not IsValid(idw_data) Then Return

if row <= 0 Or IsNull(row) Or idw_data.Dynamic RowCount() < row then return 

If row <> idw_data.Dynamic GetRow() Then 
	idw_data.Dynamic SetRow(row)
	Return
End If
 
//Turn the selectrow indicator on for the current row
If ib_select Then
	KeyShift		= keydown(keyshift!) And Not KeyDown(KeyTab!)
	KeyControl	= (keydown(keycontrol!) Or (ib_rightclicked And idw_data.Dynamic GetItemString(row, 'selectrowindicator') = 'Y')) And Not KeyDown(KeyHome!) And Not KeyDown(KeyEnd!) And Not KeyDown(KeyPageUp!) And Not KeyDown(KeyPageDown!)
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// if ib_multi is false then simply select and return
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not ib_multi Or (Not KeyControl And Not KeyShift) Then
		//If row = il_last_selected Then Return					//KCS 21594 Removed -- this was what was preventing the first row from being selcted
		ll_row = idw_data.Dynamic GetRow()
		
		If row <> ll_row Then idw_data.Dynamic SetRow(row)
		
		of_reset()
		idw_data.Dynamic SetItem(row, 'selectrowindicator', 'Y')
		il_rows_selected = 1
		il_last_selected = row
		SetNull(il_last_shift_selected)
		return
	End If

	//----------------------------------------------------------------------------------------------------------------------------------
	// if ib_multi is true continue and do multi row proccessing
	//-----------------------------------------------------------------------------------------------------------------------------------
	if KeyShift then
		This.of_SetRedraw(False)
		If IsNull(il_last_shift_selected) Then il_last_shift_selected = il_last_selected

		This.of_reset()
		
		If Abs(il_last_shift_selected - row) > 10 Then
			Choose Case idw_data.TypeOf()
				Case Datawindow!
					ldw_data = idw_data
					ll_upperbound = ldw_data.RowCount()
					If ll_upperbound > 0 Then
						For ll_index = ll_upperbound To 1 Step -1
							if row >= il_last_shift_selected then
								If ll_index >= il_last_shift_selected And ll_index <= row Then
									ll_selectrowindicator[ll_index] = 'Y'
								Else
									ll_selectrowindicator[ll_index] = ''
								End If
							Else
								If ll_index <= il_last_shift_selected And ll_index >= row Then
									ll_selectrowindicator[ll_index] = 'Y'
								Else
									ll_selectrowindicator[ll_index] = ''
								End If
							End If
						Next
		
						ll_row = ldw_data.GetRow()
						ib_ignorerowfocuschanged = True
						ldw_data.Object.SelectRowIndicator.Primary = ll_selectrowindicator[]
						If ll_row <> ldw_data.GetRow() Then ldw_data.SetRow(ll_row)
						ib_ignorerowfocuschanged = False
					End If
			End Choose
		Else
			if row >= il_last_shift_selected then
				for ll_index = il_last_shift_selected  to row
					idw_data.Dynamic SetItem(ll_index, 'selectrowindicator', 'Y')
				next
			else
				for ll_index = il_last_shift_selected to row step -1
					idw_data.Dynamic SetItem(ll_index, 'selectrowindicator', 'Y')
				next
			End If
		End If
		
		il_rows_selected = Abs(row - il_last_shift_selected)		
		This.of_SetRedraw(True)		
	Else
		ls_data = idw_data.Dynamic GetItemString(row, 'selectrowindicator')
		If ls_data = 'Y' And Not ib_rightclicked Then
			il_rows_selected = il_rows_selected - 1
			idw_data.Dynamic SetItem(row, 'selectrowindicator', 'N')
		Else
			il_rows_selected = il_rows_selected + 1
			idw_data.Dynamic SetItem(row, 'selectrowindicator', 'Y')
		End If
		SetNull(il_last_shift_selected)
	End If
End If
end subroutine

protected subroutine of_clear_indicator ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_clear_indicator()
// Arguments:   
// Overview:    This will clear the indicator for the previously selected row
// Created by:  Blake Doerr
// History:     12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Set the rowfocusindicator column to empty string
If il_last_row > 0 And Not IsNull(il_last_row) and ib_highlight Then
	If idw_data.Dynamic RowCount() >= il_last_row Then
		idw_data.Dynamic SetItem(il_last_row , 'rowfocusindicator', '')
	End If
//	idw_data.SetRedraw(True)
//	idw_data.Width = idw_data.Width
End If
il_last_row = 0
//SetNull(il_last_row)
end subroutine

protected subroutine of_create_rowfocusinidicator ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_create_rowfocusindicator()
// Arguments:  NONE 
// Overview:	This will create the two rectangles necessary for row highlight and rowfocus
// Created by:	Gary Howard
// History:    10/25/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String	ls_syntax, ls_rectangle, error_create
Long ll_rowheight, ll_width = 20000, ll_position, ll_x

//-----------------------------------------------------------------------------------------------------------------------------------
//	Destroy the objects if they exist
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_destroy_objects()

If IsNumber(idw_data.Dynamic Describe('line_header.X2')) Then
	ll_x 		= Long(idw_data.Dynamic Describe('line_header.X1'))
	ll_width	= Long(idw_data.Dynamic Describe('line_header.X2')) - ll_x
ElseIf IsNumber(idw_data.Dynamic Describe('spacer.X')) Then
	ll_x 		= 1
	ll_width	= Long(idw_data.Dynamic Describe('spacer.X')) + Long(idw_data.Dynamic Describe('spacer.Width'))
Else
	This.of_get_dimensions(ll_x, ll_width)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
//	Store the rowheight to calculate the height of the rectangles
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowheight = Long(idw_data.Dynamic Describe("Datawindow.Detail.Height"))

//-----------------------------------------------------------------------------------------------------------------------------------					
//	If the column, rowfocusindicator exists, create the rectangle
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNumber(idw_data.Dynamic Describe("rowfocusindicator.ID")) Then
	If idw_data.TypeOf() = Datawindow! Then
		ls_rectangle = "Create rectangle(band=Detail x='" + String(ll_x) + "' y='1' height='" + String(ll_rowheight - 2) + "' width='" + String(ll_width) + & 
							"' name=r_highlight visible=" + '"' + "1~tIf(  rowfocusindicator = 'Y', 1, 0)" + '"' + " brush.hatch='7'" + &
							" brush.color='553648127' pen.style='0' pen.width='5' pen.color='12632256' background.mode='2' background.color='0')"
		error_create = idw_data.Dynamic Modify(ls_rectangle)
		If error_create <> '' Then 
			ib_highlight = False
		Else
			idw_data.Dynamic SetPosition("r_highlight","detail",FALSE)
			ib_highlight = True
		End If
	End If
Else
	ib_highlight = False
End If

/*
//-----------------------------------------------------------------------------------------------------------------------------------
//	If the column, selectrowindicator exists, create the rectangle
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNumber(idw_data.Describe("selectrowindicator.ID")) Then
	ls_rectangle = "Create rectangle(band=Detail x='" + String(ll_x) + "' y='1' height='" + String(ll_rowheight - 2) + "' width='" + String(ll_width) + & 
						"' name=r_selectrow visible=" + '"' + "1~tIf(  selectrowindicator = 'Y', 1, 0)" + '"' + " brush.hatch='7'" + &
						" brush.color='553648127' pen.style='0' pen.width='5' pen.color='" + String(gn_globals.in_theme.of_get_barcolor()) + "' background.mode='2' background.color='0')"
	error_create = idw_data.Modify(ls_rectangle)
	If error_create <> '' Then
		ib_select = False
	Else
		idw_data.SetPosition("r_selectrow","detail",FALSE)
		ib_select = True
	End If
Else
	ib_select = False						
End If
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//	If the column, selectrowindicator exists, create the rectangle
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNumber(idw_data.Dynamic Describe("selectrowindicator.ID")) Then
	If idw_data.TypeOf() = Datawindow! Then
		If IsValid(gn_globals.of_get_object('n_theme')) Then
			ls_rectangle = "Create rectangle(band=Detail x='" + String(ll_x) + "' y='2' height='" + String(ll_rowheight - 2) + "' width='" + String(ll_width) + & 
								"' name=r_selectrow visible=" + '"' + "1~tIf(  selectrowindicator = 'Y', 1, 0)" + '"' + " brush.hatch='6'" + &
								" brush.color='" + String(gn_globals.of_get_object('n_theme').Dynamic of_get_backcolor()) + "' pen.style='5' pen.width='5' pen.color='0' background.mode='2' background.color='0')"
			error_create = idw_data.Dynamic Modify(ls_rectangle)

			If error_create <> '' Then
				ib_select = False
			Else
				idw_data.Dynamic SetPosition("r_selectrow","detail",FALSE)
				ib_select = True
			End If
		End If
	End If
Else
	ib_select = False						
End If


//-----------------------------------------------------------------------------------------------------------------------------------
//	Redraw the datawindow and force the rectange to pick up the theme colors.
//-----------------------------------------------------------------------------------------------------------------------------------
TriggerEvent('ue_refreshtheme')
This.of_SetRedraw(True)

ib_ApplyGUIRules = IsNumber(idw_data.Dynamic Describe('report_title.X')) Or IsNumber(idw_data.Dynamic Describe('line_header.X1'))
end subroutine

on n_rowfocus_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_rowfocus_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   This will subscribe to the theme change subscription
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_subscribe(This,'ThemeChange')
End If


end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Destructor
// Overrides:  No
// Overview:   This will destroy the objects that it created on the datawindow
// Created by: Blake Doerr
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_destroy_objects()
end event

