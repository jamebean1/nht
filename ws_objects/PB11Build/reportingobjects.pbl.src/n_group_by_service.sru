$PBExportHeader$n_group_by_service.sru
$PBExportComments$Datawindow Service - This will do dynamic group by's in any datawindow
forward
global type n_group_by_service from nonvisualobject
end type
end forward

global type n_group_by_service from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_group_by_service n_group_by_service

type variables
protected:

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Instance Variables
	//-----------------------------------------------------------------------------------------------------------------------------------
	Boolean 	ib_header_selected
	Boolean	ib_ungrouping
	Boolean	ib_doubleclicked 			= False
	Boolean 	ib_hassubscribed 			= False
	Boolean	ib_ExpandedColumnExists	= False
	Boolean	ib_UseFlatReportStyle	= False
	Boolean	ib_BatchMode				= False
	Long		il_previous_x_position	= 0
	Long		il_headerheight	= 60
	Long		il_offset 			= 69
	String 	is_group_by_column[]
	String	is_header_selected
	String	is_header_name
	String 	is_exclude[]
	
	Long		il_lbuttondown_x
	Long		il_lbuttondown_y

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Instance Objects
	//-----------------------------------------------------------------------------------------------------------------------------------
	PowerObject 	idw_data
	StaticText 	ivo_pane_highlight
	Window 		iw_reference

end variables

forward prototypes
public subroutine of_exclude_column (string as_columnname)
public function boolean of_isexcluded (string as_columnname)
public subroutine of_reinitialize ()
protected subroutine of_drop_group ()
protected subroutine of_drop_group (long al_grouplevel)
public subroutine of_doubleclicked (long xpos, long ypos, long row, ref dwobject dwo)
public function string of_get_group_by (powerobject ao_datasource)
public subroutine of_recreate_view (n_bag an_bag)
public subroutine of_expandall ()
public subroutine of_collapseall ()
public function boolean of_mousemove (long flags, long xpos, long ypos)
public function boolean of_leftbuttonup (long xpos, long ypos)
public subroutine of_leftbuttondown (long xpos, long ypos)
public subroutine of_init (powerobject adw_data)
public subroutine of_group_by (string as_group_by_column)
public subroutine of_clicked (long xpos, long ypos, long row, ref dwobject dwo)
public subroutine of_set_batch_mode (boolean ab_batchmode)
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public function powerobject of_get_datasource ()
end prototypes

event ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overview:   This will receive messages from the publish/subscribe object
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

n_bag ln_bag
Long	ll_bitmap_x
String	ls_current_group_by
String	ls_expression
NonVisualObject ln_nonvisual_window_opener
Window lw_window

//catch the group by message.
Choose Case Lower(as_message)
	Case 'group by window'
		OpenWithParm(lw_window, This, 'w_group_by_service')
	Case 'group by'
		ls_current_group_by = This.of_get_group_by(idw_data)
		
		If Len(Trim(ls_current_group_by)) > 0 Then
			as_arg = ls_current_group_by + '||' + String(as_arg)
		End If
		
		This.of_group_by(String(as_arg))
	Case 'create custom'
		ln_bag = Create n_bag
		ln_bag.of_set('datasource', idw_data)
		ln_bag.of_set('title', 'Select the Expression for the Custom Group By')
		ln_bag.of_set('expression', string(as_arg))
		ln_bag.of_set('NameIsRequired', 'No')

		ln_nonvisual_window_opener = Create Using 'n_nonvisual_window_opener'
		ln_nonvisual_window_opener.Dynamic of_OpenWindowWithParm('w_custom_expression_builder', ln_bag)
		Destroy ln_nonvisual_window_opener
		
		If Not IsValid(ln_bag) Then Return

		ls_expression 			= String(ln_bag.of_get('datawindowexpression'))
		
		This.Event ue_notify('group by', ls_expression)

		If IsValid(ln_bag) Then
			Destroy ln_bag
		End If
	Case 'before generate'
		If UpperBound(is_group_by_column[]) <= 0 Then Return
		If Len(is_group_by_column[1]) <= 0 Then Return
		If Not IsNumber(idw_data.Dynamic Describe("b_plus_or_minus" + String(UpperBound(is_group_by_column[])) + ".X")) Then Return
		
		idw_data.Dynamic Modify("b_plus_or_minus" + String(UpperBound(is_group_by_column[])) + ".Visible = '0~t0'")
		ll_bitmap_x					= Long(idw_data.Dynamic Describe("b_plus_or_minus" + String(UpperBound(is_group_by_column[])) + ".X"))
		il_previous_x_position 	= Long(idw_data.Dynamic Describe("c_group_header" + String(UpperBound(is_group_by_column[])) + ".X"))
		idw_data.Dynamic Modify("c_group_header" + String(UpperBound(is_group_by_column[])) + ".X = '" + String(ll_bitmap_x) + "'")
				
	Case 'after generate'
		If UpperBound(is_group_by_column[]) <= 0 Then Return
		If Len(is_group_by_column[1]) <= 0 Then Return
		If Not IsNumber(idw_data.Dynamic Describe("b_plus_or_minus" + String(UpperBound(is_group_by_column[])) + ".X")) Then Return
		
		idw_data.Dynamic Modify("b_plus_or_minus" + String(UpperBound(is_group_by_column[])) + ".Visible = '1~t1'")
		idw_data.Dynamic Modify("c_group_header" + String(UpperBound(is_group_by_column[])) + ".X = '" + String(il_previous_x_position) + "'")
		
	Case 'after view restored'
		This.of_init(idw_data)
		
	Case 'drop group'
		This.of_drop_group(Long(as_arg))
		
	Case 'drop all groups'
		This.of_group_by('')
		
	Case 'expand all'
		This.of_expandall()
		
	Case 'collapse all'
		This.of_collapseall()
		
	Case 'recreate view - group by'
		This.of_recreate_view(Message.PowerObjectParm)

End Choose
end event

public subroutine of_exclude_column (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_exclude_column()
// Arguments:   as_columnname - the column name that you want the service to ignore
// Overview:    This will add a column for the service to ignore
// Created by:  Blake Doerr
// History:     6/8/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_exclude[UpperBound(is_exclude[]) + 1] = Trim(as_columnname)
end subroutine

public function boolean of_isexcluded (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_isexcluded()
// Arguments:   as_columnname - The column name to check
// Overview:    Check to see if a column is excluded
// Created by:  Blake Doerr
// History:     6/8/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index


//----------------------------------------------------------------------------------------------------------------------------------
// Loop through the columns and check for existence
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_exclude[])
	If Lower(Trim(as_columnname)) = Lower(Trim(is_exclude[ll_index])) Then Return True
Next

Return False
end function

public subroutine of_reinitialize ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_reinitialize()
// Overview:    This will just reinitialize the service
// Created by:  Blake Doerr
// History:     3/3/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_init(idw_data)
end subroutine

protected subroutine of_drop_group ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_drop_group()
// Overview:    This will drop the last grouping of this datawindow
// Created by:  Blake Doerr
// History:     3/1/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_drop_group(UpperBound(is_group_by_column[]))

end subroutine

protected subroutine of_drop_group (long al_grouplevel);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_drop_group()
// Overview:    This will drop the last grouping of this datawindow
// Created by:  Blake Doerr
// History:     3/1/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index
String 	ls_group_by
String	ls_empty_array[]
String	ls_new_group_by[]

//-----------------------------------------------------------------------------------------------------------------------------------
// If the group level isn't valid, return
//-----------------------------------------------------------------------------------------------------------------------------------
If al_grouplevel <= 0 Or al_grouplevel > UpperBound(is_group_by_column[]) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the group level we are getting rid of
//-----------------------------------------------------------------------------------------------------------------------------------
is_group_by_column[al_grouplevel] = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the array and build the group by string
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_group_by_column)
	If Trim(is_group_by_column[ll_index]) <> '' Then
		ls_new_group_by[UpperBound(ls_new_group_by[]) + 1] = is_group_by_column[ll_index]
		ls_group_by = ls_group_by + is_group_by_column[ll_index] + '||'
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the array
//-----------------------------------------------------------------------------------------------------------------------------------
is_group_by_column[] = ls_empty_array[]
is_group_by_column[] = ls_new_group_by[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Group by the group by string
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_group_by(Left(ls_group_by, Len(ls_group_by) - 2))
end subroutine

public subroutine of_doubleclicked (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_doubleclicked()
// Overview:    This will set a boolean to know that we are double clicked and the call of_clicked
//						This is necessary to expand or collapse the group of rows
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_doubleclicked = True
of_clicked(xpos, ypos, row, dwo)
ib_doubleclicked = False
end subroutine

public function string of_get_group_by (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_group_by()
// Overview:    This will concatenate the group by columns with commas
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_index	
String 	ls_group_by
String	ls_group_by_column[]
String	ls_group_by_column_final[]
String	ls_empty[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the groups from the datasource
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_get_groups(ao_datasource, ls_group_by_column[])
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the array of expressions and concatenate them with commas
//-----------------------------------------------------------------------------------------------------------------------------------
FOR ll_index = 1 TO UpperBound(ls_group_by_column)
	If Trim(ls_group_by_column[ll_index]) <> '' Then
		ls_group_by_column_final[UpperBound(ls_group_by_column_final[]) + 1] = Trim(ls_group_by_column[ll_index])
		ls_group_by = ls_group_by + Trim(ls_group_by_column[ll_index]) + '||'
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Remove the last delimiter
//-----------------------------------------------------------------------------------------------------------------------------------
ls_group_by = Left(ls_group_by, Len(ls_group_by) - 2)

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure we aren't just a delimiter
//-----------------------------------------------------------------------------------------------------------------------------------
If Trim(ls_group_by) = '||' Then ls_group_by = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are getting the groups for the target datawindow, set the instance variable
//-----------------------------------------------------------------------------------------------------------------------------------
If ao_datasource = idw_data Then
	is_group_by_column[] = ls_empty[]
	is_group_by_column[] = ls_group_by_column_final[]
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the group by string
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_group_by
end function

public subroutine of_recreate_view (n_bag an_bag);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_recreate_view()
// Created by:  Blake Doerr
// History:     10/10/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
//n_string_functions	ln_string_functions
Datastore	lds_OriginalDatawindow
Datastore	lds_ViewDatawindow

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_OriginalDatawindow
String	ls_ViewDatawindow
String	ls_original_groupby
String	ls_view_groupby

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are any problems
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_bag) Or Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Create two datastores
//-----------------------------------------------------------------------------------------------------------------------------------
lds_OriginalDatawindow	= Create Datastore
lds_ViewDatawindow		= Create Datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the three versions of the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ls_OriginalDatawindow	= an_bag.of_get('Original Syntax')
ls_ViewDatawindow			= an_bag.of_get('View Syntax')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the syntaxes are invalid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_OriginalDatawindow)) = 0 Or Len(Trim(ls_ViewDatawindow)) = 0 Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the syntaxes to the datastores
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ln_datawindow_tools.of_apply_syntax(lds_OriginalDatawindow, ls_OriginalDatawindow)
ln_datawindow_tools.of_apply_syntax(lds_ViewDatawindow, ls_ViewDatawindow)

//-----------------------------------------------------------------------------------------------------------------------------------
// Apply the changes to the datawindow to idw_data
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(lds_OriginalDatawindow.Object) And IsValid(lds_ViewDatawindow.Object) Then
	ls_original_groupby 	= This.of_get_group_by(lds_OriginalDatawindow)
	ls_view_groupby 		= This.of_get_group_by(lds_ViewDatawindow)
	
	If IsNull(ls_original_groupby) Then ls_original_groupby = ''
	If IsNull(ls_view_groupby) Then ls_view_groupby = ''
	
	If ls_original_groupby <> ls_view_groupby And ls_view_groupby <> '!' And ls_view_groupby <> '?' Then
		This.of_group_by(ls_view_groupby)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy ln_datawindow_tools
Destroy lds_OriginalDatawindow
Destroy lds_ViewDatawindow
end subroutine

public subroutine of_expandall ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_expand_all()
// Overview:    This will expand all the groups
// Created by:  Blake Doerr
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Datastore	lds_data
Datawindow	ldw_data
String ls_expanded[]
Long ll_index, ll_rowcount

If Not ib_ExpandedColumnExists Then Return

ll_rowcount = idw_data.Dynamic RowCount()

If ll_rowcount <= 0 Then Return

//Build an array of Yes's and apply it to the entire column using dot notation
Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ls_expanded = ldw_data.object.expanded.primary
	Case Datastore!
		lds_data = idw_data
		ls_expanded = lds_data.object.expanded.primary
End Choose

For ll_index = 1 To UpperBound(ls_expanded)
	ls_expanded[ll_index] = 'Y'
Next

Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ldw_data.object.expanded.primary = ls_expanded
	Case Datastore!
		lds_data = idw_data
		lds_data.object.expanded.primary = ls_expanded
End Choose

idw_data.Dynamic SetDetailHeight(1, ll_rowcount, Long(idw_data.Dynamic Describe("DataWindow.Detail.Height")))


end subroutine

public subroutine of_collapseall ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_collapseall()
// Overview:   This will collapse all the groups
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
String ls_expanded[]
Long ll_index, ll_rowcount
Datastore	lds_data
Datawindow	ldw_data

If Not ib_ExpandedColumnExists Then Return

ll_rowcount = idw_data.Dynamic RowCount()

If ll_rowcount <= 0 Then Return

Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ls_expanded = ldw_data.object.expanded.primary
	Case Datastore!
		lds_data = idw_data
		ls_expanded = lds_data.object.expanded.primary
End Choose

For ll_index = 1 To UpperBound(ls_expanded)
	ls_expanded[ll_index] = 'N'
Next

Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ldw_data.object.expanded.primary = ls_expanded
	Case Datastore!
		lds_data = idw_data
		lds_data .object.expanded.primary = ls_expanded
End Choose

idw_data.Dynamic SetDetailHeight(1, ll_rowcount, 0)

end subroutine

public function boolean of_mousemove (long flags, long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Functino:      of_mousemove
// Overview:   If the mouse has been moved over the object while the left button was clicked then
//					move the highlight
//
// Created by: Blake Doerr
// History:    2/20/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_backcolor

//If UpperBound(is_group_by_column[]) <= 0 Then Return False
//If Len(is_group_by_column[1]) <= 0 Then Return False


//-----------------------------------------------------
// flags = 1:  Mouse Clicked
// ib_we_are_resizing = True mouse clicked while over
// object, Set to True in the leftbuttondown event.
//-----------------------------------------------------
if xpos = il_lbuttondown_x and ypos = il_lbuttondown_y then Return False

If ib_ungrouping Or ib_header_selected And Right(is_header_name, 14) <> '_direction_srt' Then
	//If the object doesn't exists, create it.  Else move it to the xposition
	If flags <> 1 Then
		if isvalid(ivo_pane_highlight) then
			iw_reference.CloseUserObject(ivo_pane_highlight)
		End If
		ib_ungrouping 			= False
		ib_header_selected 	= False
	Else
		if isvalid(ivo_pane_highlight) then
			ivo_pane_highlight.X = iw_reference.PointerX() + 10
			ivo_pane_highlight.Y = iw_reference.PointerY() + 10
		Else
			//Open the statictext and copy all the properties from the column header to make it look alikce
			iw_reference.OpenUserObject ( ivo_pane_highlight, 10000, 10000)
			ivo_pane_highlight.BringToTop 	= True
			If ib_header_selected Then
				ll_backcolor = Long(idw_data.Dynamic Describe(is_header_name + '.Background.Color'))
				If ll_backcolor = 536870912 Or ll_backcolor = 553648127 Then ll_backcolor = 16777215
				ivo_pane_highlight.Backcolor 		= ll_backcolor
				ivo_pane_highlight.Text 			= 			idw_data.Dynamic Describe(is_header_name + '.Text')
				ivo_pane_highlight.Height 			= Long(	idw_data.Dynamic Describe(is_header_name + '.Height')) + 15
				ivo_pane_highlight.Width 			= Long(	idw_data.Dynamic Describe(is_header_name + '.Width')) + 15

				ivo_pane_highlight.FaceName		= idw_data.Dynamic Describe(is_header_name + '.Font.Face')
				ivo_pane_highlight.TextSize		= Long(idw_data.Dynamic Describe(is_header_name + '.Font.Height'))
				ivo_pane_highlight.Weight			= Long(idw_data.Dynamic Describe(is_header_name + '.Font.Weight'))
				
				ivo_pane_highlight.X = iw_reference.PointerX() + 10
				ivo_pane_highlight.Y = iw_reference.PointerY() + 10
				Choose 	Case	idw_data.Dynamic Describe(is_header_name + '.Border')
					Case '0'
						ivo_pane_highlight.Border 			= False
					Case '1'
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleShadowBox!
					Case '2'
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleBox!
					Case '5'
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleLowered!
					Case Else
						ivo_pane_highlight.Border 			= True
						ivo_pane_highlight.BorderStyle 	= StyleRaised!
				End Choose
				
				Choose	Case idw_data.Dynamic Describe(is_header_name + '.Alignment')
					Case '1'
						ivo_pane_highlight.Alignment		= Right!
					Case '2'
						ivo_pane_highlight.Alignment		= Center!
					Case Else
						ivo_pane_highlight.Alignment		= Left!
				End Choose
			Else
				ivo_pane_highlight.Text 			= 'Ungrouping'
				ivo_pane_highlight.Height 			= 70
				ivo_pane_highlight.Width 			= 600
				ivo_pane_highlight.FaceName		= 'Tahoma'
				ivo_pane_highlight.TextSize		= - 8
				ivo_pane_highlight.X = iw_reference.PointerX() + 10
				ivo_pane_highlight.Y = iw_reference.PointerY() + 10
				ivo_pane_highlight.Border 			= True
				ivo_pane_highlight.BorderStyle 	= StyleRaised!
				ivo_pane_highlight.Alignment		= Left!
				ivo_pane_highlight.Backcolor		= 79741120
				If ib_UseFlatReportStyle Then
					ivo_pane_highlight.Weight 			= 700
					ivo_pane_highlight.Backcolor		= 16777215
				End If
			End If
			
		End IF
		Return True
	End If
Else
	if isvalid(ivo_pane_highlight) then
		iw_reference.CloseUserObject(ivo_pane_highlight)
	End If
End If

Return False
end function

public function boolean of_leftbuttonup (long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_leftbuttonup()
// Arguments:   xpos, ypos, row - you can figure these out
// Overview:    This will manage the grouping and ungrouping of columns using the mouse on the datawindow
//							If you drag from the column header to the datawindow, you are grouping by that coloumn
//							If you drag from the group header to the column header , you are ungrouping by that coloumn
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Boolean	lb_return = False
String	ls_objectatpointer
String	ls_getbandatpointer
String	ls_current_group_by
	
If ib_header_selected Then
	If Left(idw_data.Dynamic GetBandAtPointer(), 6) = 'detail' Then
		ls_current_group_by = This.of_get_group_by(idw_data)
		
		If Len(Trim(ls_current_group_by)) > 0 Then
			ls_current_group_by = ls_current_group_by + '||' + String(is_header_selected)
		Else
			ls_current_group_by = is_header_selected
		End If
		
		This.of_group_by(ls_current_group_by)
		ib_header_selected = False
		lb_return = True
	End If
ElseIf ib_ungrouping Then
	If Left(idw_data.Dynamic GetBandAtPointer(), 7) = 'header~t' Then
		This.of_drop_group()
		ib_ungrouping = False
		lb_return = True
	End If
End If

if isvalid(ivo_pane_highlight) then
	iw_reference.CloseUserObject(ivo_pane_highlight)
End If


Return lb_return
end function

public subroutine of_leftbuttondown (long xpos, long ypos);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_leftbuttondown()
// Arguments:   xpos, ypos - you can figure these out
// Overview:    This will manage the grouping and ungrouping of columns using the mouse on the datawindow
//							If you drag from the column header to the datawindow, you are grouping by that coloumn
//							If you drag from the group header to the column header , you are ungrouping by that coloumn
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
String	ls_objectatpointer, ls_getbandatpointer

//Check to see what object was clicked on (we care about column headers and group headers)
ls_objectatpointer = idw_data.Dynamic GetObjectAtPointer()
ls_objectatpointer = Left(ls_objectatpointer, Pos(ls_objectatpointer, '~t') - 1)

//Just to make sure these are set right.  The lbuttonup might not have registered to reset these attributes.
ib_ungrouping = False
ib_header_selected = False

il_lbuttondown_x = xpos
il_lbuttondown_y = ypos

If Right(ls_objectatpointer, Len('_direction_srt')) = '_direction_srt' Then
	ls_objectatpointer = Left(ls_objectatpointer, Len(ls_objectatpointer) - Len('_direction_srt'))
End If

If Right(ls_objectatpointer, 4) = '_srt' Then
	If IsNumber(idw_data.Dynamic Describe(Left(ls_objectatpointer, Len(ls_objectatpointer) - 4) + '.X')) Then
		ib_header_selected = True
		is_header_selected = Left(ls_objectatpointer, Len(ls_objectatpointer) - 4)
		is_header_name = ls_objectatpointer
	End If
End If

If Left(idw_data.Dynamic GetBandAtPointer(), 7) = 'header.' Then
	ib_ungrouping = True
End If

end subroutine

public subroutine of_init (powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_init()
// Arguments:   adw_data - the datawindow target
// Overview:    This will set the datawindow instance variable, store the syntax, and store the original rowheight
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_groupbyinit_expression
//n_string_functions ln_string_functions
n_datawindow_tools ln_datawindow_tools
UserObject luo_temp
PowerObject lpo_temp

String ls_columns[], ls_string, ls_empty_array[]
Long ll_position, ll_length, ll_index

idw_data = adw_data

//-----------------------------------------------------
// Test to see if the Expanded Column Exists
//-----------------------------------------------------
ib_ExpandedColumnExists = IsNumber(idw_data.Dynamic Describe("Expanded.ID")) And Lower(idw_data.Dynamic Describe("Datawindow.Detail.Height.AutoSize")) <> 'yes'
ib_UseFlatReportStyle	= IsNumber(idw_data.Dynamic Describe("line_header.X1"))

//-----------------------------------------------------
// Subscribe to the messages that affect this object
//-----------------------------------------------------
If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_subscribe(This, 'Group By', 				idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Before Generate', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'After Generate', 		idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'Recreate View - Group By', 	idw_data)
		gn_globals.in_subscription_service.of_subscribe(This, 'After View Restored', 	idw_data)
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the parentwindow to be used later as a reference for coordinate systems.
//-----------------------------------------------------------------------------------------------------------------------------------
lpo_temp = idw_data.GetParent()

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the total classname for use in the registry
//-----------------------------------------------------------------------------------------------------------------------------------
DO WHILE lpo_temp.TypeOf() <> Window!
	lpo_temp = lpo_temp.GetParent()
LOOP

iw_reference = lpo_temp

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the group by init computed column
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools
ls_groupbyinit_expression = Trim(ln_datawindow_tools.of_get_expression(idw_data, 'groupbyinit'))
Destroy ln_datawindow_tools

//-----------------------------------------------------------------------------------------------------------------------------------
// Get rid of the group by init since we are going to apply it
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(ls_groupbyinit_expression)) > 0 Then
	idw_data.Dynamic Modify("Destroy groupbyinit")
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// Get the group by init expression
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsNull(ls_groupbyinit_expression) And Len(Trim(ls_groupbyinit_expression)) > 0 Then
	If Left(ls_groupbyinit_expression, 1) = '"' Or Left(ls_groupbyinit_expression, 1) = "'" Then
		ls_groupbyinit_expression = Left(ls_groupbyinit_expression, Len(ls_groupbyinit_expression) - 1)
	End If

	If Right(ls_groupbyinit_expression, 1) = '"' Or Right(ls_groupbyinit_expression, 1) = "'" Then
		ls_groupbyinit_expression = Right(ls_groupbyinit_expression, Len(ls_groupbyinit_expression) - 1)
	End If

	ls_string = Trim(gn_globals.in_string_functions.of_find_argument(ls_groupbyinit_expression, '||', 'groupby'))
	If IsNull(ls_string) Then ls_string = ''

	If Len(Trim(ls_string)) > 0 Then
		This.of_group_by(ls_string)
	End If
Else
	If ls_string = '' Then
		ls_string = This.of_get_group_by(idw_data)
	End If
End If
end subroutine

public subroutine of_group_by (string as_group_by_column);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_group_by()
// Arguments:	as_group_by_column - the columns to group by (comma delimited list)
// Overview:    This will take a column and group the datawindow by it.  It must export the datawindow
//						syntax and reimport it because PB does not expose the create group method to the Modify function.
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string
n_multimedia ln_multimedia
n_datawindow_tools ln_datawindow_tools
Datastore lds_snowballschanceinhell

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Blob lblob_state
Boolean lb_apply_heirarchy
Long ll_group_by_start, ll_group_by_end, ll_pos, ll_x, ll_index, ll_possible_group_by_start, ll_position2
Long	ll_x1, ll_x2, ll_x_position
Long	ll_position
Long	ll_current_number_of_groups = 0
String ls_syntax, error_create, ls_objects, ls_modify, ls_object, ls_object_list[], ls_syntax_addition, ls_columns[], ls_order[], ls_original_sort, ls_sort
String ls_exists_already
String	ls_group_by_expression
String	ls_editstyle
String	ls_return
String	ls_empty_array[]
String	ls_group_by_column[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Show the HourGlass
//-----------------------------------------------------------------------------------------------------------------------------------
SetPointer(HourGlass!)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we aren't allowed to group by this column, return
//-----------------------------------------------------------------------------------------------------------------------------------
//If IsNull(as_group_by_column) Or This.of_IsExcluded(as_group_by_column) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the group by columns/expressions
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(as_group_by_column, '||', ls_group_by_column[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message that says the group by happened to see if anyone needs to respond
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message('Before Group By Happened', as_group_by_column, idw_data)
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// 	Make sure any previous group related objects are destroyed
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = idw_data.Dynamic Modify("Destroy b_plus_or_minus")
ls_return = idw_data.Dynamic Modify("Destroy c_group_header")

For ll_index = 1 To 100
	If idw_data.Dynamic Modify("Destroy c_group_header" + String(ll_index)) <> '' Then Exit
Next
For ll_index = 1 To 100
	If idw_data.Dynamic Modify("Destroy b_plus_or_minus" + String(ll_index)) <> '' Then Exit
Next

If ib_UseFlatReportStyle Then
	For ll_index = 1 To 100
		If idw_data.Dynamic Modify("Destroy line_header" + String(ll_index)) <> '' Then Exit
	Next

	For ll_index = 1 To 100
		If idw_data.Dynamic Modify("Destroy line_footer" + String(ll_index)) <> '' Then Exit
	Next
End If

idw_data.Dynamic Modify("Destroy line_header5")
idw_data.Dynamic Modify("Destroy line_footer9")

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure any previous group related objects are destroyed
//-----------------------------------------------------------------------------------------------------------------------------------
ls_syntax = idw_data.Dynamic Describe("Datawindow.Syntax")

//-----------------------------------------------------------------------------------------------------------------------------------
// We need to splice out the group information if it is already there
//-----------------------------------------------------------------------------------------------------------------------------------
ll_group_by_start = Pos(ls_syntax, 'group(level=1 header.height=')
ll_group_by_end = Pos(ls_syntax, 'trailer.color="', ll_group_by_start)
ll_group_by_end = Pos(ls_syntax, '~r~n', ll_group_by_end)

If ll_group_by_start > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Make sure that it's not an old group by
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not IsNumber(idw_data.Dynamic Describe("c_group_header.X")) Then
		ll_current_number_of_groups = 1
	End If
	
	For ll_index = 2 To 100
		ll_position = Pos(ls_syntax, 'group(level=' + String(ll_index) + ' header.height=', ll_group_by_end)
		If ll_position = 0 Or ll_position < ll_group_by_end Then Exit
		ll_current_number_of_groups = ll_index
		
		ll_group_by_end = Max(ll_group_by_end, ll_position)
		ll_group_by_end = Pos(ls_syntax, 'trailer.color="', 	ll_group_by_end)
		ll_group_by_end = Pos(ls_syntax, '~r~n', 					ll_group_by_end)
	Next
	
	
	If ll_group_by_end > ll_group_by_start Then
		ls_syntax = Replace(ls_syntax, ll_group_by_start, ll_group_by_end - ll_group_by_start + 2, '')
		This.of_expandall()
	Else
		Return
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the very first object, if we didn't already have a group
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_group_by_start <= 0 Then
	ll_group_by_start = 				Pos(ls_syntax, 'text(')
	ll_possible_group_by_start = 	Pos(ls_syntax, 'column(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'compute(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'line(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'bitmap(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'ole(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'ellipse(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'rectangle(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'report(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'roundrectangle(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
	ll_possible_group_by_start = 	Pos(ls_syntax, 'tableblob(')
	If ll_possible_group_by_start > 0 Then ll_group_by_start = Min(ll_possible_group_by_start, ll_group_by_start)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the group by columns adding the group to the syntax
//-----------------------------------------------------------------------------------------------------------------------------------
FOR ll_index = 1 TO UpperBound(ls_group_by_column[])
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Trim the column names
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_group_by_column[ll_index] = Trim(ls_group_by_column[ll_index])
	
	If ls_group_by_column[ll_index] = '' Then Continue
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the sort order of the groups
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Lower(Right(ls_group_by_column[ll_index], 2)) = ' d' Then
		ls_order[UpperBound(ls_order[]) + 1] = 'D'
		ls_group_by_column[ll_index] = Trim(Left(ls_group_by_column[ll_index], Len(ls_group_by_column[ll_index]) - 2))
	ElseIf Lower(Right(ls_group_by_column[ll_index], 2)) = ' a' Then
		ls_order[UpperBound(ls_order[]) + 1] = 'A'
		ls_group_by_column[ll_index] = Trim(Left(ls_group_by_column[ll_index], Len(ls_group_by_column[ll_index]) - 2))
	Else
		ls_order[UpperBound(ls_order[]) + 1] = 'A'
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the column to the group by clause
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_columns[UpperBound(ls_columns[]) + 1] = ls_group_by_column[ll_index]
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the order to the column
	//-----------------------------------------------------------------------------------------------------------------------------------
	//ls_columns[ll_index] = ls_columns[ll_index] + ' ' + ls_order[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// This will add three objects to the datawindow
//		1.		The group header	
//		2.		The plus/minus button.  It has an expression to determine whethere it is a plus/minus.bmp
//		3.		The text value for the group.  It does a lookupdisplay to make sure we get the display value
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(ls_columns[]) > 0 Then
	ln_datawindow_tools = Create n_datawindow_tools

	For ll_index = 1 To UpperBound(ls_columns[])
		If ln_datawindow_tools.of_IsColumn(idw_data, ls_columns[ll_index]) Then
			ls_group_by_expression = 'LookupDisplay(' + ls_columns[ll_index] + ')'
		Else
			ls_group_by_expression = ls_columns[ll_index]
		End If

		
		If ib_UseFlatReportStyle Then
			ls_syntax_addition = ls_syntax_addition + 'group(level=' + String(ll_index) + ' header.height=' + String(il_headerheight) + ' trailer.height=0 by=("' + ls_columns[ll_index] + '") sort="" header.color="536870912" trailer.color="536870912" )~r~n'
		
			ll_x1 = Long(idw_data.Dynamic Describe('line_header.X1')) + (ll_index - 1) * 50
			ll_x2 = Long(idw_data.Dynamic Describe('line_header.X2'))
			
			ls_syntax_addition = ls_syntax_addition + 'line(band=header.' + String(ll_index) + ' x1="' + String(ll_x1) + '" y1="' + String(il_headerheight - 10) + '" x2="' + String(ll_x2) + '" y2="' + String(il_headerheight - 10) + '"  name=line_header' + String(ll_index) + ' pen.style="0" pen.width="5" pen.color="12632256"  background.mode="2" background.color="12632256" )'
			ls_syntax_addition = ls_syntax_addition + 'line(band=Trailer.' + String(ll_index) + ' x1="' + String(ll_x1) + '" y1="0" x2="' + String(ll_x2) + '" y2="0"  name=line_footer' + String(ll_index * 2 - 1) + ' pen.style="0" pen.width="5" pen.color="12632256"  background.mode="2" background.color="12632256" )'
			ls_syntax_addition = ls_syntax_addition + 'line(band=Trailer.' + String(ll_index) + ' x1="' + String(ll_x1) + '" y1="0" x2="' + String(ll_x2) + '" y2="0"  name=line_footer' + String(ll_index * 2) + ' pen.style="0" pen.width="5" pen.color="12632256"  background.mode="2" background.color="12632256" )'
			
			If ib_ExpandedColumnExists And ll_index = UpperBound(ls_columns[]) Then
				ls_syntax_addition = ls_syntax_addition + 'compute(band=header.' + String(ll_index) + ' alignment="0" expression=" bitmap( If( expanded  = ~'Y~', ~'Treeview Icon - Small Minus.bmp~',~'Treeview Icon - Small Plus.bmp~'))" border="0" color="0" x="' + String(ll_x1) + '" y="' + String(il_headerheight - 57) + '" height="49" width="55" format=""  name=b_plus_or_minus font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )' + '~r~n'
				If ll_index = UpperBound(ls_columns[]) Then
					ll_x1 = ll_x1 + 72
				End If
			End If
			
			ls_syntax_addition = ls_syntax_addition + 'compute(band=header.' + String(ll_index) + ' alignment="0" expression="' + ls_group_by_expression + '" border="0" color="0" x="' + String(ll_x1) + '" y="' + String(il_headerheight - 57) + '" height="57" width="1898" format="[general]"  name=c_group_header' + String(ll_index) + ' font.face="Tahoma" font.height="-8" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )' + '~r~n'

		Else
			ll_x1 = 5 + (ll_index - 1) * 50

			ls_syntax_addition = ls_syntax_addition + 'group(level=' + String(ll_index) + ' header.height=' + String(il_headerheight) + ' trailer.height=0 by=("' + ls_columns[ll_index] + '") sort="" header.color="78682240" trailer.color="536870912" )~r~n'
			
			If ib_ExpandedColumnExists Then
//			If ib_ExpandedColumnExists And ll_index = UpperBound(ls_columns[]) Then
				ls_syntax_addition = ls_syntax_addition + 'compute(band=header.' + String(ll_index) + ' alignment="0" expression=" bitmap( If( expanded  = ~'Y~', ~'Group By - minus.bmp~',~'Group By - plus.bmp~'))" border="0" color="0" x="' + String(ll_x1) + '" y="3" height="49" width="55" format=""  name=b_plus_or_minus'  + String(ll_index) + ' font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )' + '~r~n'	
//				If ll_index = UpperBound(ls_columns[]) Then
					ll_x1 = ll_x1 + 96
//				End If
			End If
			
			ls_syntax_addition = ls_syntax_addition + 'compute(band=header.' + String(ll_index) + ' alignment="0" expression="' + ls_group_by_expression + '" border="0" color="0" x="' + String(ll_x1) + '" y="0" height="57" width="1898" format="[general]"  name=c_group_header' + String(ll_index) + ' font.face="Tahoma" font.height="-8" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )' + '~r~n'		
		End If
	Next

	Destroy ln_datawindow_tools
	
	//Insert the new syntax into the old syntax
	ls_syntax = Replace(ls_syntax, ll_group_by_start, 0, ls_syntax_addition)
End If

//Store the columns in an array for use later

ln_datawindow_tools = Create n_datawindow_tools
ls_return = ln_datawindow_tools.of_apply_syntax(idw_data, ls_syntax)
Destroy ln_datawindow_tools

If ls_return <> '' Then Return

This.of_get_group_by(idw_data)


// Hide the GreyLine so it doesn't show
idw_data.dynamic Modify("DataWindow.HideGrayLine=Yes")

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message that says the group by happened to see if anyone needs to respond
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message('Group By Happened', as_group_by_column, idw_data)
	If ib_UseFlatReportStyle Then
		gn_globals.in_subscription_service.of_message('Group Level Changed', String(UpperBound(is_group_by_column[]) - ll_current_number_of_groups), idw_data)
	End If
end if

// RAP - initialize the "expanded" data column so the correct bitmap shows up to begin with
If NOT ib_UseFlatReportStyle Then
	of_expandall()
END IF

//-----------------------------------------------------------------------------------------------------------------------------------
// Play a sound
//-----------------------------------------------------------------------------------------------------------------------------------
ln_multimedia.of_play_sound('GUI Sounds - Bestfit.wav')

end subroutine

public subroutine of_clicked (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_clicked()
// Overview:    This will receive the clicked event from the datawindow.  
//						This is necessary to expand or collapse the group of rows
// Created by:  Blake Doerr
// History:     12/2/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------
// Local Variables
//---------------------------------------------------------------------
String 	ls_bandstring
String	ls_yes_or_no = 'N'
String	ls_dwo_name
String	ls_expanded[]
String	ls_objectatpointer
String	ls_bitmap_name
Long 		l_row
Long		l_row_begin
Long		l_group_level = 1
Long		ll_pointerx
Long		l_index
Long		l_row_temporary
Long		l_row_new_begin
Long		ll_bitmap_x1
Long		ll_bitmap_x2
Datawindow	ldw_data
//---------------------------------------------------------------------
// Return if expand/contract is not enabled or we didn't click in the header
//---------------------------------------------------------------------
If UpperBound(is_group_by_column[]) <= 0 Then Return
If Len(is_group_by_column[1]) <= 0 Then Return
If Not ib_ExpandedColumnExists Then Return

//---------------------------------------------------------------------
// Return if expand/contract is not enabled
//---------------------------------------------------------------------
ls_bandstring 			= idw_data.Dynamic GetBandAtPointer()
ls_objectatpointer 	= idw_data.Dynamic GetObjectAtPointer()
If Left(Lower(Trim(ls_bandstring)), 7) <> 'header.' Then Return
If idw_data.Dynamic RowCount() <= 0 Then Return

//------------------------------------------------------------------------------------------------------------------------------------------
// Check the band that was clicked, get the grouping level, x position, and the row is after the group header
//------------------------------------------------------------------------------------------------------------------------------------------
l_group_level 	= Long(Mid(ls_bandstring, 8,1))
l_row 			= Long(Right(ls_bandstring,Len(ls_bandstring) - Pos(ls_bandstring, '~t')))

//------------------------------------------------------------------------------------------------------------------------------------------
// Return if there isn't a row
//------------------------------------------------------------------------------------------------------------------------------------------
If l_row <= 0 Then Return

//------------------------------------------------------------------------------------------------------------------------------------------
// Get dimensions for the objects
//------------------------------------------------------------------------------------------------------------------------------------------
If IsValid(dwo) Then ls_dwo_name = dwo.Name
IF Left(ls_dwo_name, 15)  = 'b_plus_or_minus' THEN
	ls_bitmap_name = ls_dwo_name
ELSE
	ls_bitmap_name = ''
END IF
ll_pointerx 	= idw_data.Dynamic PointerX()
ll_bitmap_x1	= Long(idw_data.Dynamic Describe(ls_bitmap_name + '.X'))
ll_bitmap_x2	= Long(idw_data.Dynamic Describe(ls_bitmap_name + '.Width')) + ll_bitmap_x1

//------------------------------------------------------------------------------------------------------------------------------------------
// If we are in a header group (a group by header), and there was a double click or the plus/minus was clicked on we should collapse
//------------------------------------------------------------------------------------------------------------------------------------------
If Not (ib_doubleclicked Or Left(ls_dwo_name, 15) = 'b_plus_or_minus' Or (ll_pointerx >= ll_bitmap_x1 And ll_pointerx <= ll_bitmap_x2)) Then Return
	
//------------------------------------------------------------------------------------------------------------------------------------------
// This will find the affected rows and set their expanded attribute to the opposite of its current value
//------------------------------------------------------------------------------------------------------------------------------------------
l_row_begin = l_row 
l_row 		= idw_data.Dynamic FindGroupChange(l_row_begin + 1, l_group_level)

//------------------------------------------------------------------------------------------------------------------------------------------
// Modify the l_begin_row to find where the group really started rather than collapsing from this row on
//------------------------------------------------------------------------------------------------------------------------------------------
l_row_temporary = 1
l_row_new_begin = 1

//------------------------------------------------------------------------------------------------------------------------------------------
// Loop until we find a group change
//------------------------------------------------------------------------------------------------------------------------------------------
DO UNTIL l_row_temporary <= 0 Or l_row_temporary > l_row_begin
	l_row_temporary = idw_data.Dynamic FindGroupChange(l_row_temporary, l_group_level)
	If l_row_temporary <= l_row_begin And l_row_temporary > 0 Then
		l_row_new_begin = l_row_temporary
	End If
	If l_row_temporary > 0 Then l_row_temporary = l_row_temporary + 1
LOOP

//------------------------------------------------------------------------------------------------------------------------------------------
// Set the new row begin
//------------------------------------------------------------------------------------------------------------------------------------------
l_row_begin = l_row_new_begin

//------------------------------------------------------------------------------------------------------------------------------------------
// If we are at the end of the datawindow, set it to rowcount + 1
//------------------------------------------------------------------------------------------------------------------------------------------
If l_row <= 0 Then
	l_row = idw_data.Dynamic RowCount() + 1
End If

//------------------------------------------------------------------------------------------------------------------------------------------
//	Check to see what the expanded value is for the first row in the group, if it's expanded collapse it
//		it is collapsed by setting the detail height of a range of rows to zero.
//		the initial row height is stored in an instance variable for expanding
//------------------------------------------------------------------------------------------------------------------------------------------
//idw_data.SetRedraw(False)

//------------------------------------------------------------------------------------------------------------------------------------------
// Get the entire expanded column
//------------------------------------------------------------------------------------------------------------------------------------------
Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ls_expanded[] = ldw_data.Object.Expanded.Primary
End Choose

//------------------------------------------------------------------------------------------------------------------------------------------
// Set the height appropriately
//------------------------------------------------------------------------------------------------------------------------------------------
If ls_expanded[l_row_begin] <> 'Y' Then
	ls_yes_or_no = 'Y'
	idw_data.Dynamic SetDetailHeight ( l_row_begin, l_row - 1, Long(idw_data.Dynamic Describe("DataWindow.Detail.Height")))
Else
	idw_data.Dynamic SetDetailHeight ( l_row_begin, l_row - 1, 0)		
End If 

//------------------------------------------------------------------------------------------------------------------------------------------
// Now set the expanded column to the right value so the expressions can respond
//------------------------------------------------------------------------------------------------------------------------------------------
FOR l_index = l_row_begin TO l_row - 1
	ls_expanded[l_index] = ls_yes_or_no
NEXT

//------------------------------------------------------------------------------------------------------------------------------------------
// Set the expanded column back into the datawindow
//------------------------------------------------------------------------------------------------------------------------------------------
Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		l_row = ldw_data.GetRow()
		ldw_data.Object.Expanded.Primary = ls_expanded[]
		If ldw_data.GetRow() <> l_row Then ldw_data.SetRow(l_row)
End Choose

end subroutine

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_BatchMode = ab_BatchMode
end subroutine

public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	Blake Doerr
//	History: 	3/1/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long	ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the group by menu items
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)
If ab_iscolumn Then
	an_menu_dynamic.of_add_item('&Group By This Field', 'group by', as_objectname, This)
Else
	as_objectname = ''
End If

If Not ib_BatchMode Then an_menu_dynamic.of_add_item('&Create Custom Group By...', 'create custom', as_objectname, This)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the Remove and Expand/Collapse All
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(is_group_by_column[]) > 0 Then
	If Len(is_group_by_column[1]) > 0 Then
		an_menu_dynamic.of_add_item('&Remove All Groups', 'drop all groups', '', This)
		
		If UpperBound(is_group_by_column[]) > 1 Then
			For ll_index = UpperBound(is_group_by_column[]) To 1 Step -1
				an_menu_dynamic.of_add_item('Remove Group &' + String(ll_index), 'drop group', String(ll_index), This)
			Next
		End If
		
		If ib_ExpandedColumnExists And Not ib_BatchMode Then
			an_menu_dynamic.of_add_item('-', '', '', This)
			an_menu_dynamic.of_add_item('&Expand All', 'expand all', '', This)
			an_menu_dynamic.of_add_item('&Collapse All', 'collapse all', '', This)
		End If
	End If
End If
end subroutine

public function powerobject of_get_datasource ();Return idw_data
end function

on n_group_by_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_group_by_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

