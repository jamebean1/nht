$PBExportHeader$n_datawindow_treeview_service.sru
forward
global type n_datawindow_treeview_service from nonvisualobject
end type
end forward

global type n_datawindow_treeview_service from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_datawindow_treeview_service n_datawindow_treeview_service

type variables
Protected:

PowerObject idw_data
Datastore ids_data
n_datawindow_tools in_datawindow_tools
Transaction ixctn_transaction
Long il_dragrow
Long il_first_ran_level
Long il_redraw_count = 0
Boolean ib_redrawison = True
Boolean ib_hassubscribed
Boolean	ib_batchmode = False

 
//Here are the column specifications.  These can be overridden with functions
String is_id_column = 'id', is_parent_id_column = 'parentid'
String is_icon_column = 'icon'
String is_indented_columns[]
String is_bold_columns[]
String is_sort_delimiter = '@@@' 
String is_filterqualifier

//Here are the retrieve as needed specifications.
Boolean ib_retrieve_as_needed = false
Boolean	ib_ignore_doubleclicked = False
Boolean	ib_ignore_retrieveend	= False
String is_treelevel[]
String is_dataobject[]
String is_ignore_levels[]

//Here are the navigation specifications
String is_navigation_string_column = 'navigationstring'
String is_treelevel_entity[]
String is_entity[]

Long il_tab_size = 74, il_minimum_x = 100
Long il_rowheight
Long il_bitmap_width = 13, il_bitmap_height = 13



end variables

forward prototypes
public function boolean of_get_retrieve_as_needed ()
public subroutine of_retrievestart ()
protected function boolean of_ignore_level (long al_level)
public subroutine of_init (powerobject adw_data)
public subroutine of_settransobject (transaction axctn_transaction)
public function string of_get_entity (long al_row)
public function string of_get_navigationstring (long al_row)
public subroutine of_refresh (string as_type, long al_argument)
public subroutine of_clicked (long xpos, long ypos, long row, ref dwobject dwo)
public subroutine of_doubleclicked (long xpos, long ypos, long row, ref dwobject dwo)
public subroutine of_contract (string as_type, long al_argument)
public subroutine of_setredraw (boolean ab_trueorfalse)
public subroutine of_interrogate_datawindow ()
public function boolean of_modify_filter (ref string as_filter)
public subroutine of_retrieveend (long al_rowcount)
protected subroutine of_retrieve_as_needed (long al_row)
public subroutine of_expand (string as_type, long al_argument)
public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic, string as_columnname, boolean ab_iscolumn, boolean ab_iscomputedfield)
public subroutine of_set_batch_mode (boolean ab_batchmode)
end prototypes

event ue_notify(string as_message, any as_arg);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_notify
//	Overrides:  No
//	Arguments:	as_message, as_arg
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    2/16/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String	ls_filter
n_bag 	ln_bag


Choose Case Lower(Trim(as_message))
		
	Case	'expand all'
		This.of_expand('all', 1)

	Case	'contract all'
		This.of_contract('all', 1)
		
	Case	'expand section'
		This.of_expand('section', Long(as_arg))

	Case	'contract section'
		This.of_contract('section', Long(as_arg))
		
	Case	'expand/contract to level'
		This.of_expand('level', Long(as_arg))
		
	Case	'refresh section'
		This.of_refresh('section', Long(as_arg))
		
	Case	'retrieve as needed'
		This.of_retrieve_as_needed(Long(as_arg))
		
	Case	'before filter'
		If Not IsValid(as_arg) 						Then Return
		If Lower(ClassName(as_arg)) <> 'n_bag' Then Return
		
		ln_bag 		= as_arg
		ls_filter 	= ln_bag.of_get('filter')
		If This.of_modify_filter(ls_filter)	Then ln_bag.of_set('filter', ls_filter)
End Choose
end event

public function boolean of_get_retrieve_as_needed ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_retrieve_as_needed()
//	Arguments:  None
//	Overview:   Get whether the datawindow is retrieve as needed or not.
//	Created by:	Denton Newham
//	History: 	2/22/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return ib_retrieve_as_needed
end function

public subroutine of_retrievestart ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrievestart()
//	Overview:   This will turn redraw off
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


end subroutine

protected function boolean of_ignore_level (long al_level);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_ignore_level()
//	Arguments:  al_level
//	Overview:   This function will determine if level should be ignored.
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
boolean lb_ignore_level
long ll_upper, ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the ignored levels and determine if this level is one of them.
//-----------------------------------------------------------------------------------------------------------------------------------
lb_ignore_level = False
ll_upper = UpperBound(is_ignore_levels)

If ll_upper > 0 Then
	For ll_index = 1 To ll_upper
		If al_level = Long(is_ignore_levels[ll_index]) Then
			lb_ignore_level = True
			Exit
		End If
	Next
Else 
	lb_ignore_level = False
End If

Return lb_ignore_level 
end function

public subroutine of_init (powerobject adw_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  adw_data - The datawindow that will be the treeview
//	Overview:   This will initialize the object
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_width, ll_height, ll_upper
String ls_x_expression, ls_string, ls_retrieve_beneath
String 	ls_x_position, ls_test 
Long	ll_index, ll_y, ll_rowheight

//-----------------------------------------------------------------------------------------------------------------------------------
// Store a pointer to the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data = adw_data

//-----------------------------------------------------
// Subscribe to the messages that affect this object
//-----------------------------------------------------
If Not ib_hassubscribed Then
	ib_hassubscribed = True
	If IsValid(gn_globals.in_subscription_service) Then gn_globals.in_subscription_service.of_subscribe(This, 'Before Filter', idw_data)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get all the parameters for creating the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_interrogate_datawindow()

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the height in PBU's
//-----------------------------------------------------------------------------------------------------------------------------------
ll_width 	= PixelsToUnits(il_bitmap_width, 	XPixelsToUnits!)
ll_height 	= PixelsToUnits(il_bitmap_height, 	YPixelsToUnits!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the plus minus bitmap.  If this is not retrieve as needed, then change the visible expression slightly.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_x_expression = ' + ' + String(il_tab_size) + ' * (treelevel - 1)'
ls_retrieve_beneath = idw_data.Dynamic Describe('retrievebeneath.ID')


ll_rowheight = Long(idw_data.Dynamic Describe("Datawindow.Detail.Height"))
ll_y = (ll_rowheight - ll_height) / 2

If ib_retrieve_as_needed And ls_retrieve_beneath <> '!' And ls_retrieve_beneath <> '?' And ls_retrieve_beneath <> '' Then
	ls_string = idw_data.Dynamic Modify('create bitmap(band=detail filename="Treeview Icon - Small Plus.bmp" x="5~t' + String(Max(il_minimum_x - ll_width - 10, 5)) + ls_x_expression + '" y="' + String(ll_y) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" border="0"  name=pc_plus visible="1~tif( treeexpanded =~'N~' and treelevel[1] > treelevel,1,if( treeexpanded =~'N~' and retrievebeneath =~'Y~', 1, 0))" )')
	ls_string = idw_data.Dynamic Modify('create bitmap(band=detail filename="Treeview Icon - Small Minus.bmp" x="5~t' + String(Max(il_minimum_x - ll_width - 10, 5)) + ls_x_expression + '" y="' + String(ll_y) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" border="0"  name=pc_minus visible="1~tif( treeexpanded =~'Y~' and treelevel[1] > treelevel,1,0)" )')
Else
	ls_string = idw_data.Dynamic Modify('create bitmap(band=detail filename="Treeview Icon - Small Plus.bmp" x="5~t' + String(Max(il_minimum_x - ll_width - 10, 5)) + ls_x_expression + '" y="' + String(ll_y) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" border="0"  name=pc_plus visible="1~tif( treeexpanded =~'N~' and treelevel[1] > treelevel,1,0)" )')
	ls_string = idw_data.Dynamic Modify('create bitmap(band=detail filename="Treeview Icon - Small Minus.bmp" x="5~t' + String(Max(il_minimum_x - ll_width - 10, 5)) + ls_x_expression + '" y="' + String(ll_y) + '" height="' + String(ll_height) + '" width="' + String(ll_width) + '" border="0"  name=pc_minus visible="1~tif( treeexpanded =~'Y~' and treelevel[1] > treelevel,1,0)" )')
End If	

//-----------------------------------------------------------------------------------------------------------------------------------
// Add expressions to the columns that are indented as we drill down
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_indented_columns[])
	ls_x_position = idw_data.Dynamic Describe(Lower(Trim(is_indented_columns[ll_index])) + '.X')
	ls_string = idw_data.Dynamic Modify(is_indented_columns[ll_index] + '.x="' + ls_x_position + '~t' + ls_x_position + ls_x_expression + '"')
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Make the text column bold as we move the mouse over it
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_bold_columns[])
	ls_test = idw_data.Dynamic Modify(Lower(Trim(is_bold_columns[ll_index])) + '.font.weight="400~tif(RowFocusIndicator = ~'Y~', 700, 400)"')
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the retrieve as needed datastore and the retrieve from string object.
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_retrieve_as_needed Then
	ids_data = Create datastore
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the first level where retrive as needed is specified.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upper = UpperBound(is_treelevel)
If Not ib_retrieve_as_needed Or ll_upper <= 0 Then
	SetNull(il_first_ran_level)
Else
	SetNull(il_first_ran_level)
	For ll_index = 1 To ll_upper
		If Long(is_treelevel[ll_index]) < il_first_ran_level Or IsNull(il_first_ran_level) Then
			il_first_ran_level = Long(is_treelevel[ll_index])
		End If
	Next
End If
end subroutine

public subroutine of_settransobject (transaction axctn_transaction);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_settransobject()
//	Arguments:  axctn_transaction
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	2/18/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ixctn_transaction = axctn_transaction
end subroutine

public function string of_get_entity (long al_row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_entity()
//	Arguments:  al_row
//	Overview:   This function will determine the entity for al_row based on the initialization arguments.
//	Created by:	Denton Newham
//	History: 	2/18/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_level, ll_upper, ll_index 
string ls_entity

ls_entity = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the level for al_row.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_level = idw_data.Dynamic GetItemNumber(al_row, 'treelevel')

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the level entities specified on initialization and determine the entity for the level.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upper = Min(UpperBound(is_treelevel_entity[]), UpperBound(is_entity[]))
If ll_upper < 1 Then Return ''

For ll_index = 1 To ll_upper
	
	If is_treelevel_entity[ll_index] = String(ll_level) Then
		
		ls_entity = is_entity[ll_index]
		Exit
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the entity.
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_entity
end function

public function string of_get_navigationstring (long al_row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_navigationstring()
//	Arguments:  al_row
//	Overview:   This function will determine the navigation string for al_row.
//	Created by:	Denton Newham
//	History: 	2/18/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_navigationstring, ls_describe

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the navigation string column exists first.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_describe = idw_data.Dynamic Describe(is_navigation_string_column + '.ID')

If ls_describe <> '!' and ls_describe <> '?' and ls_describe <> '' Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the column exists, get the navigation string for al_row.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_navigationstring = idw_data.Dynamic GetItemString(al_row, is_navigation_string_column)
Else
	
	ls_navigationstring = ''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the navigation string.
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_navigationstring
end function

public subroutine of_refresh (string as_type, long al_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_refresh()
//	Arguments:  as_type - The type of refresh
//					al_argument - The row to start on or the level to refresh
//	Overview:   This will refresh the datawindow.
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_row, ll_rowcount, ll_endrow, ll_upper
Long	ll_index, ll_level, ll_levels[], ll_startrow, ll_max, ll_loop
String ls_expanded[], ls_retrievebeneath[], ls_argument[], ls_start_argument
Boolean lb_ignore_level
Datawindow ldw_data
Datastore	lds_data

SetPointer(Hourglass!)

If al_argument <= 0 Or IsNull(al_argument) Then Return 

Choose Case Lower(Trim(as_type))
	
	Case	'section'
		
		This.of_setredraw(False)
		ll_rowcount = idw_data.Dynamic RowCount()
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the level and find the next row that is at the same or higher level.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_level = idw_data.Dynamic GetItemNumber(al_argument, 'treelevel')
		If al_argument = ll_rowcount Then
			//-----------------------------------------------------------------------------------------------------------------------------------
			// BEGIN ADDED HMD 10/03/2000 17314
			//-----------------------------------------------------------------------------------------------------------------------------------
			This.of_setredraw(True)
			//-----------------------------------------------------------------------------------------------------------------------------------
			// END ADDED HMD 10/03/2000 17314
			//-----------------------------------------------------------------------------------------------------------------------------------
			
			Return
		Else
			ll_endrow = idw_data.Dynamic Find('treelevel' + ' <= ' + String(ll_level), al_argument + 1, ll_rowcount)
		End If
			
		If ll_endrow <= 0 Or IsNull(ll_endrow) Then ll_endrow = ll_rowcount	
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the treeexpanded, level, and argument column values for this range.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ls_expanded = ldw_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
				ls_retrievebeneath = ldw_data.Object.retrievebeneath.Primary[al_argument, ll_endrow]
				ll_levels = ldw_data.Object.treelevel.Primary[al_argument, ll_endrow]
				ls_argument = ldw_data.Object.argument.Primary[al_argument, ll_endrow]		
			Case Datastore!
				lds_data = idw_data
				ls_expanded = lds_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
				ls_retrievebeneath = lds_data.Object.retrievebeneath.Primary[al_argument, ll_endrow]
				ll_levels = lds_data.Object.treelevel.Primary[al_argument, ll_endrow]
				ls_argument = lds_data.Object.argument.Primary[al_argument, ll_endrow]		
		End Choose
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the level of the row is greater than or equal to the level where retrive as needed started, then discard rows until we reach
		//	either a row above the retrieve as needed or ll_endrow.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_startrow = al_argument + 1
		
		Do While ll_startrow <> 0 And ll_startrow <= ll_endrow
			
//			ll_row = idw_data.Dynamic Find('treelevel' + ' < ' + String(il_first_ran_level), ll_startrow, ll_endrow)
			ll_row = idw_data.Dynamic Find('treelevel' + ' <= ' + String(il_first_ran_level), ll_startrow, ll_endrow)
			
			If ll_row <=0 Or IsNull(ll_row) Then 
//				idw_data.Dynamic RowsDiscard(ll_startrow, ll_endrow - 1, Primary!)
				idw_data.Dynamic RowsDiscard(ll_startrow, ll_endrow, Primary!)
				ll_endrow = ll_startrow
				ll_startrow = 0
			ElseIf ll_row > 0 And Not IsNull(ll_row) And ll_row <> ll_startrow Then
				idw_data.Dynamic RowsDiscard(ll_startrow, ll_row - 1, Primary!)
				ll_endrow = ll_endrow - (ll_row - ll_startrow)
			Else 
				ll_startrow = ll_startrow + 1
			End If
			
		Loop			
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Build out the treeview in the datawindow again, starting with the first row (al_argument).
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_upper = Min( UpperBound(ls_expanded), Min( Upperbound(ll_levels), UpperBound(ls_argument)) )
		ls_start_argument = ls_argument[1]
		ll_index = 1
		ll_row = al_argument
		
		Do While ls_start_argument <> ls_argument[ll_upper] 
			
			ll_row = idw_data.Dynamic Find('argument' + " = '" + ls_start_argument + "'", ll_row, ll_endrow)
			
			If ll_row <=0 Or IsNull(ll_row) Then
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// The row is not in the datawindow anymore, go on to the next one.
				//-----------------------------------------------------------------------------------------------------------------------------------
				
			Else
								
				//-----------------------------------------------------------------------------------------------------------------------------------
				// The row exists.
				// If it is below the retrieve as needed level, was expanded, 
				//	and not a level to be ignored, then retrieve as needed for it.
				//-----------------------------------------------------------------------------------------------------------------------------------
				If ll_levels[ll_index] >= il_first_ran_level And ls_expanded[ll_index] = 'Y' Then
					
					If Not This.of_ignore_level(ll_levels[ll_index]) Then
						This.of_retrieve_as_needed(ll_row)
						
						ll_rowcount = idw_data.Dynamic RowCount()
						ll_endrow = idw_data.Dynamic Find('treelevel' + ' <= ' + String(ll_levels[ll_upper]), ll_row + 1, ll_rowcount)
						If ll_endrow <= 0 Or IsNull(ll_endrow) Then ll_endrow = ll_rowcount	
						
					Else 
						This.of_expand('single', ll_row)
					End If
					
				//-----------------------------------------------------------------------------------------------------------------------------------
				// The row exists.
				// If it is below the retrieve as needed level, was not expanded, was retrieved previously,
				//	and not a level to be ignored, then retrieve as needed for it. 
				//-----------------------------------------------------------------------------------------------------------------------------------	
				ElseIf ll_levels[ll_index] >= il_first_ran_level And ls_expanded[ll_index] = 'N' And ls_retrievebeneath[ll_index] = 'N' Then
					
					If Not This.of_ignore_level(ll_levels[ll_index]) Then
						This.of_retrieve_as_needed(ll_row)
						
						ll_rowcount = idw_data.Dynamic RowCount()
						ll_endrow = idw_data.Dynamic Find('treelevel' + ' <= ' + String(ll_levels[ll_upper]), ll_row + 1, ll_rowcount)
						If ll_endrow <= 0 Or IsNull(ll_endrow) Then ll_endrow = ll_rowcount
						
					Else 
						This.of_expand('single', ll_row)
					End If						
					
				//-----------------------------------------------------------------------------------------------------------------------------------
				// The row exists.
				// If it is below the retrieve as needed level, was not expanded, was NOT retrieved previously,
				//	and not a level to be ignored, then set its RetrieveBeneath flag to yes.				
				//-----------------------------------------------------------------------------------------------------------------------------------	
				ElseIf ll_levels[ll_index] >= il_first_ran_level And ls_expanded[ll_index] = 'N' And ls_retrievebeneath[ll_index] = 'Y' Then
					
					If Not This.of_ignore_level(ll_levels[ll_index]) Then
						idw_data.Dynamic SetItem(ll_row, 'RetrieveBeneath', 'Y')
					End If
					
				End If
				
				ll_index = ll_index + 1
				ls_start_argument = ls_argument[ll_index]
				ll_row = ll_row + 1
				
			End If
		Loop

		This.of_setredraw(True)
End Choose


end subroutine

public subroutine of_clicked (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clicked()
//	Arguments:  xpos	- the x position
//					ypos	- the y position
//					row	- the row in the datawindow clicked on
//					dwo	- A pointer to the datawindow object
//	Overview:   This will ??????
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_name

if row = 0 Or IsNull(row) Or row > idw_data.Dynamic RowCount() then return

il_dragrow = row
ls_name = lower(dwo.name)

Choose Case Lower(ls_name)
		
	Case 'pc_plus'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw off
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(False)	
		
		This.of_expand('single', row)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw on
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(True)	
		
	Case 'pc_minus'
		This.of_contract('single', row)

End Choose
end subroutine

public subroutine of_doubleclicked (long xpos, long ypos, long row, ref dwobject dwo);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_doubleclicked()
//	Arguments:  xpos	- the x position
//					ypos	- the y position
//					row	- the row in the datawindow clicked on
//					dwo	- A pointer to the datawindow object
//	Overview:   This will ??????
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_name
long ll_rowcount, ll_level, ll_row

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we are ignoring the doubleclicked event
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_ignore_doubleclicked Then Return

if row = 0 Or IsNull(row) then return

ll_rowcount = idw_data.Dynamic RowCount()
ll_level = idw_data.Dynamic GetItemNumber(row, 'treelevel')
//ll_row = idw_data.Dynamic Find('treelevel' + ' = ' + String(ll_level + 1), row + 1, ll_rowcount)

If idw_data.Dynamic GetItemString(row, 'treeexpanded') = 'N' Then //And ll_row > 0 And Not IsNull(ll_row) Then
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the redraw off
	//-----------------------------------------------------------------------------------------------------------------------------------
	This.of_setredraw(False)	
		
	This.of_expand('single', row)
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the redraw on
	//-----------------------------------------------------------------------------------------------------------------------------------
	This.of_setredraw(True)		
Else
	This.of_contract('single', row)
End If

end subroutine

public subroutine of_contract (string as_type, long al_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_contract()
//	Arguments:  as_type - The type of contraction
//					al_argument - The row to start on
//	Overview:   This will contract a level starting from a row
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_row, ll_rowcount, ll_endrow, ll_upper
Long	ll_index, ll_level
String ls_expanded[]
Datawindow	ldw_data
Datastore	lds_data

SetPointer(Hourglass!)

ll_rowcount = idw_data.Dynamic RowCount()
If al_argument <= 0 Or IsNull(al_argument) Then Return 
If ll_rowcount <= 0 Or IsNull(ll_rowcount) Then Return 

Choose Case Lower(Trim(as_type))
	
	Case	'single'

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the level and find the next row that is at the same or higher level.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_level = idw_data.Dynamic GetItemNumber(al_argument, 'treelevel')
		If al_argument = ll_rowcount Then
			Return
		Else
			ll_endrow = idw_data.Dynamic Find('treelevel' + ' <= ' + String(ll_level), al_argument + 1, ll_rowcount) - 1
		End If
			
		If ll_endrow <= 0 Or IsNull(ll_endrow) Then ll_endrow = ll_rowcount

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw off
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(False)			

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the Detail Height of the rows
		//-----------------------------------------------------------------------------------------------------------------------------------
		idw_data.Dynamic SetDetailHeight(al_argument + 1, ll_endrow, 0)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the expanded column to 'N' to show the proper bitmap
		//-----------------------------------------------------------------------------------------------------------------------------------
		idw_data.Dynamic SetItem(al_argument, 'treeexpanded', 'N')
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw on
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(True)	

	Case	'section'	
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the level and find the next row that is at the same or higher level.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_level = idw_data.Dynamic GetItemNumber(al_argument, 'treelevel')
		If al_argument = ll_rowcount Then
			Return
		Else
			ll_endrow = idw_data.Dynamic Find('treelevel' + ' <= ' + String(ll_level), al_argument + 1, ll_rowcount) - 1
		End If
			
		If ll_endrow <= 0 Or IsNull(ll_endrow) Then ll_endrow = ll_rowcount

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the Detail Height of the rows (except the first one) to zero.
		//-----------------------------------------------------------------------------------------------------------------------------------
		idw_data.Dynamic SetDetailHeight(al_argument + 1, ll_endrow, 0)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the expanded data for the boundary.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ls_expanded = ldw_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
			Case Datastore!
				lds_data = idw_data
				ls_expanded = lds_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
		End Choose
		
		ll_upper = UpperBound(ls_expanded)
		For ll_index = 1 To ll_upper

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Update the expanded column to 'N' for all rows in the section.
			//-----------------------------------------------------------------------------------------------------------------------------------			
			ls_expanded[ll_index] = 'N'
		Next 
		
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ldw_data.Object.treeexpanded.Primary[al_argument, ll_endrow] = ls_expanded		
			Case Datastore!
				lds_data = idw_data
				lds_data.Object.treeexpanded.Primary[al_argument, ll_endrow] = ls_expanded		
		End Choose
		
	Case	'all'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw off
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(False)			
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make every row in the section have zero height
		//-----------------------------------------------------------------------------------------------------------------------------------
		idw_data.Dynamic SetDetailHeight(al_argument, ll_rowcount, 0)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop on the rows and set the height of level 1 rows, to the row height
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_row = idw_data.Dynamic Find('treelevel' + ' = 1', al_argument, ll_rowcount)
		
		Do While ll_row > 0 And Not IsNull(ll_row)
			idw_data.Dynamic SetDetailHeight(ll_row, ll_row, il_rowheight)
		
			If ll_row = ll_rowcount Then
				ll_row = 0
			Else
				ll_row = idw_data.Dynamic Find('treelevel' + ' = 1', ll_row + 1, ll_rowcount)
			End If
		Loop
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the expanded data for the boundary.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ls_expanded = ldw_data.Object.treeexpanded.Primary[al_argument, ll_rowcount]
			Case Datastore!
				lds_data = idw_data
				ls_expanded = lds_data.Object.treeexpanded.Primary[al_argument, ll_rowcount]
		End Choose
		
		ll_upper = UpperBound(ls_expanded)
		For ll_index = 1 To ll_upper

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Update the expanded column to 'N' for all rows in the section.
			//-----------------------------------------------------------------------------------------------------------------------------------			
			ls_expanded[ll_index] = 'N'

		Next 
		
		Choose Case idw_data.TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ldw_data.Object.treeexpanded.Primary[al_argument, ll_rowcount] = ls_expanded		
			Case Datastore!
				lds_data = idw_data
				lds_data.Object.treeexpanded.Primary[al_argument, ll_rowcount] = ls_expanded		
		End Choose
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw on
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(True)	
				
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

public subroutine of_interrogate_datawindow ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_interrogate_datawindow()
//	Overview:   This will pull initialization parameters out of the datawindow itself.  This allows you to create a treeview
//						style report without writing code.
//	Created by:	Blake Doerr
//	History: 	12.14.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_initialization_column_name = 'treeviewinit', ls_init_string, ls_return, ls_level_entity[]
String ls_arguments[], ls_values[], ls_array[], ls_x_position, ls_reset[], ls_level_retrieval[]
Long	ll_index, ll_temporary_x, ll_loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Find out the column type of the initialization string
//-----------------------------------------------------------------------------------------------------------------------------------
ls_return = idw_data.Dynamic describe(ls_initialization_column_name + ".coltype")

//-----------------------------------------------------------------------------------------------------------------------------------
// If the computed field does not exist, or is the wrong datatype, it will return
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Left(ls_return, 4)) = 'char' then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Try to get the expression from the computed field
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_init_string = idw_data.Dynamic describe(ls_initialization_column_name + ".expression")
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If the string is not valid, try to get the expression another way
	//-----------------------------------------------------------------------------------------------------------------------------------
	if ls_init_string = '!' or ls_init_string = '?' or ls_init_string = '' then
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Try to evaluate the computed field to see if there is an expression
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_init_string = idw_data.Dynamic describe("evaluate( 'lookupdisplay(" + ls_initialization_column_name + ")', 1)")
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Return if the expression is not valid
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ls_init_string = '!' Or ls_init_string = '?' Or ls_init_string = '' then
			return
		End If
	else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// When the expression is described, there will be quotes that we need to remove
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_init_string = trim(ls_init_string)
		ls_init_string = mid(ls_init_string, 2, len(ls_init_string) - 2)
	end if
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Use the string functions object to parse the string into an array
	//-----------------------------------------------------------------------------------------------------------------------------------
	//n_string_functions ln_string_functions 
	gn_globals.in_string_functions.of_parse_arguments(ls_init_string, '||', ls_arguments[], ls_values[])
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Loop through all elements of the array
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_index = 1 To Min(UpperBound(ls_arguments), UpperBound(ls_values))
		Choose Case Lower(Trim(ls_arguments[ll_index]))
			Case 'indention'
				If IsNumber(ls_values[ll_index]) Then il_tab_size = Long(ls_values[ll_index])
			
			Case 'indented columns'
				ls_array[] = ls_reset[]
				gn_globals.in_string_functions.of_parse_string( ls_values[ll_index], ',', ls_array[])
				For ll_loop = 1 To UpperBound(ls_array)
					is_indented_columns[ll_loop] = Lower(Trim(ls_array[ll_loop]))
				Next
			
			Case 'level retrieval'
				ls_array[] = ls_reset[]
				gn_globals.in_string_functions.of_parse_string( ls_values[ll_index], '@@', ls_array[])
				For ll_loop = 1 To UpperBound(ls_array)
					
					ls_level_retrieval[] = ls_reset
					gn_globals.in_string_functions.of_parse_string( ls_array[ll_loop], ';', ls_level_retrieval[])
					
					is_treelevel[ll_loop] = Lower(Trim(ls_level_retrieval[1]))				
					is_dataobject[ll_loop] = Lower(Trim(ls_level_retrieval[2]))
				Next
				
			Case 'id column'
				is_id_column = ls_values[ll_index]

			Case 'parent column'
				is_parent_id_column = ls_values[ll_index]
			
			Case 'retrieve as needed'
				ib_retrieve_as_needed = Lower(Trim(ls_values[ll_index])) = 'yes'

			Case 'bold columns'
				ls_array[] = ls_reset[]
				gn_globals.in_string_functions.of_parse_string( ls_values[ll_index], ',', ls_array[])
				For ll_loop = 1 To UpperBound(ls_array)
					is_bold_columns[ll_loop] = Lower(Trim(ls_array[ll_loop]))				
				Next
				
			Case 'level entity'
				ls_array = ls_reset[]
				gn_globals.in_string_functions.of_parse_string( ls_values[ll_index], '@@', ls_array[])
				For ll_loop = 1 To UpperBound(ls_array)
					
					ls_level_entity[] = ls_reset
					gn_globals.in_string_functions.of_parse_string( ls_array[ll_loop], ';', ls_level_entity[])
					
					is_treelevel_entity[ll_loop] = Lower(Trim(ls_level_entity[1]))
					is_entity[ll_loop] = Lower(Trim(ls_level_entity[2]))
				Next
				
			Case 'levels to ignore'
				ls_array = ls_reset[]
				gn_globals.in_string_functions.of_parse_string( ls_values[ll_index], ',', ls_array[])
				For ll_loop = 1 To UpperBound(ls_array)
					is_ignore_levels[ll_loop] = Lower(Trim(ls_array[ll_loop]))
				Next
			Case 'ignore doubleclicked'
				ib_ignore_doubleclicked = Lower(Trim(ls_values[ll_index])) = 'yes'

			Case	'filterqualifier'
				is_filterqualifier = Lower(Trim(ls_values[ll_index]))
			Case	'filterlevel'
				is_filterqualifier = 'treelevel = ' + Trim(ls_values[ll_index])
		End Choose
	Next
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Keep the default in a temporary variable
//-----------------------------------------------------------------------------------------------------------------------------------
ll_temporary_x = il_minimum_x
il_minimum_x = 100000

//----------------------------------------------------------------------------------------------------------------------------------
// Check the X position of each object
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_indented_columns[])
	ls_x_position = idw_data.Dynamic Describe(is_indented_columns[ll_index] + '.X')
	If IsNumber(ls_x_position) Then
		il_minimum_x = Min(il_minimum_x, Long(ls_x_position))
	End If
Next

//----------------------------------------------------------------------------------------------------------------------------------
// If we didn't find a valid value, set it back to the default
//-----------------------------------------------------------------------------------------------------------------------------------
If il_minimum_x = 100000 Or il_minimum_x < 100 Or IsNull(il_minimum_x) Or il_minimum_x > 32700 Then
	il_minimum_x = ll_temporary_x
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Determine the row height
//-----------------------------------------------------------------------------------------------------------------------------------
il_rowheight = Long(idw_data.Dynamic Describe("Datawindow.Detail.Height"))
end subroutine

public function boolean of_modify_filter (ref string as_filter);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_modify_filter()
//	Arguments:  as_filter - The existing filter expression.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	12/12/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
Long			ll_index, ll_index2, ll_rowcount, ll_previous_treelevel, ll_filtersortcolumn[], ll_treelevel[], ll_sort[]
String		ls_filter, ls_filtered[], ls_filteredreset[], ls_qualifies[]
Boolean		lb_thisbranchhasaqualifyingrecord
Double		ldbl_double[]
DateTime		ldt_datetime[]
DataStore 	lds_data
Datastore	lds_datastore
Datawindow	ldw_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify that we have information about the idw_data to proceed.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not in_datawindow_tools.of_iscolumn(idw_data, 'filtersortcolumn') Then Return False 
If Not in_datawindow_tools.of_iscolumn(idw_data, 'filtered') 			Then Return False 
If Not in_datawindow_tools.of_iscolumn(idw_data, 'treelevel') 			Then Return False 

//-----------------------------------------------------------------------------------------------------------------------------------
// Take care of the redraw.
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_setredraw(False)
This.Post of_setredraw(True)

//-----------------------------------------------------------------------------------------------------------------------------------
// Unfilter and sort the data.
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic setfilter('')
idw_data.Dynamic filter()
idw_data.Dynamic sort()

If idw_data.Dynamic rowcount() <= 0 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Copy the datawindow into a datastore.  Grab its data and its dropdowndatawindows if needed.
//-----------------------------------------------------------------------------------------------------------------------------------
lds_data = Create DataStore
in_datawindow_tools.of_copy_datawindow(idw_data, lds_data)
If Match(Lower(Trim(as_filter)), 'lookupdisplay') Then in_datawindow_tools.of_copy_dropdowndatawindows(idw_data, lds_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the values for the filter sort column.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = lds_data.rowcount()
For ll_index = ll_rowcount To 1 Step -1
	ll_filtersortcolumn[ll_index] = ll_index
	ls_filtered[ll_index] 			= 'Y'
	ls_filteredreset[ll_index]		= 'N'
Next
lds_data.object.filtersortcolumn.primary[] 	= ll_filtersortcolumn[]
lds_data.object.filtered.primary[]				= ls_filteredreset[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Filter all the qualifying rows that don't match the filter string and move them to the deleted buffer so they won't reappear.
//-----------------------------------------------------------------------------------------------------------------------------------
lds_data.setfilter('((' + as_filter + ') And ' + is_filterqualifier + ') Or Not ' + is_filterqualifier)
lds_data.filter()
lds_data.rowsdiscard(1, lds_data.filteredcount(), Filter!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get out if no rows qualify
//-----------------------------------------------------------------------------------------------------------------------------------
If lds_data.find(is_filterqualifier, 1, lds_data.RowCount()) <= 0 Then 
	Destroy lds_data
	
	Choose Case idw_data.TypeOf()
		Case Datawindow!
			ldw_data = idw_data
			ldw_data.object.filtered.primary[] = ls_filtered[]
		Case Datastore!
			lds_datastore = idw_data
			lds_datastore.object.filtered.primary[] = ls_filtered[]
	End Choose
	
	as_filter = 'Upper(Trim(Filtered)) = "N"'
	This.Post Event ue_notify('expand all', '')
	Return True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get some information about the remaining rows.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount 			= lds_data.rowcount()
ll_treelevel[]			= lds_data.object.treelevel.primary[]	
in_datawindow_tools.of_get_expression_as_array(lds_data, 'If(' + is_filterqualifier + ', "Y", "N")', ls_qualifies[], ldt_datetime[], ldbl_double[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop backwards through the rows and get rid of parent level rows that don't have a qualifying child that made it through the filter.
//----------------------------------------------------------------------------------------------------------------------------------
For ll_index = ll_rowcount To 1 Step -1
	
	If ls_qualifies[ll_index] 	= 'Y' Then 
		lb_thisbranchhasaqualifyingrecord = True
		ll_previous_treelevel = ll_treelevel[ll_index]
		Continue	
	End If
	
	If Not lb_thisbranchhasaqualifyingrecord Then
		lds_data.rowsdiscard(ll_index, ll_index, Primary!)
		Continue
	End If
	
	If ll_previous_treelevel <= ll_treelevel[ll_index] Then
		lds_data.rowsdiscard(ll_index, ll_index, Primary!)
		Continue
	End If
	
	ll_previous_treelevel =  ll_treelevel[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure we still have rows.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = lds_data.rowcount()
If ll_rowcount = 0 Then
	Destroy lds_data

	Choose Case idw_data.TypeOf()
		Case Datawindow!
			ldw_data = idw_data
			ldw_data.object.filtered.primary[] = ls_filtered[]
		Case Datastore!
			lds_datastore = idw_data
			lds_datastore.object.filtered.primary[] = ls_filtered[]
	End Choose
	Return True
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the filtered column to 'N' for the data that is left.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_sort[] = lds_data.object.filtersortcolumn.primary[]

For ll_index = 1 To ll_rowcount	
	If UpperBound(ls_filtered[]) >= ll_sort[ll_index] Then ls_filtered[ll_sort[ll_index]] = 'N'
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Put the filtered array into the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case idw_data.TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ldw_data.object.filtered.primary[] = ls_filtered[]
	Case Datastore!
		lds_datastore = idw_data
		lds_datastore.object.filtered.primary[] = ls_filtered[]
End Choose

as_filter = 'Upper(Trim(Filtered)) = "N"'
This.Post Event ue_notify('expand all', '')
Destroy lds_data
//-----------------------------------------------------------------------------------------------------------------------------------
// Return Success
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public subroutine of_retrieveend (long al_rowcount);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieveend()
//	Arguments:  al_rowcount - The rowcount argument from the retrieve end function of the datawindow
//	Overview:   This will initialize the row heights for the first retrieval
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_row, ll_index, ll_upper
String ls_expanded[]
Datastore lds_datastore
Datawindow	ldw_data

If IsValid(gn_globals.in_subscription_service) Then gn_globals.in_subscription_service.Post of_message('reapply filter', '', idw_data)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we triggered this ourselves, return
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_ignore_retrieveend Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the redraw off
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_setredraw(False)

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the rowcount is right
//-----------------------------------------------------------------------------------------------------------------------------------
al_rowcount = idw_data.Dynamic RowCount()

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are zero rows
//-----------------------------------------------------------------------------------------------------------------------------------
If al_rowcount = 0 Then 
	This.of_setredraw(True)
	Return
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Make every row have zero height
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic SetDetailHeight(1, idw_data.Dynamic RowCount(), 0)

//-----------------------------------------------------------------------------------------------------------------------------------
// Get expanded value for all rows 
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case idw_data.Dynamic TypeOf()
	Case Datawindow!
		ldw_data = idw_data
		ls_expanded = ldw_data.Object.treeexpanded.Primary[1, idw_data.Dynamic RowCount()]
	Case Datastore!
		lds_datastore	= idw_data
		ls_expanded = lds_datastore.Object.treeexpanded.Primary[1, idw_data.Dynamic RowCount()]
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop on the rows and set the height of level 1 rows, to the row height
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = idw_data.Dynamic Find('treelevel' + ' = 1', 1, al_rowcount)

Do While ll_row > 0 And Not IsNull(ll_row)
	idw_data.Dynamic SetDetailHeight(ll_row, ll_row, il_rowheight)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// BEGIN ADDED HMD 10/03/2000 17317
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ls_expanded[ll_row] = "Y" Then
		this.of_expand("single", ll_row)
	End If
	//-----------------------------------------------------------------------------------------------------------------------------------
	// END ADDED HMD 10/03/2000 17317
	//-----------------------------------------------------------------------------------------------------------------------------------

	
	If ll_row = al_rowcount Then
		ll_row = 0
	Else
		ll_row = idw_data.Dynamic Find('treelevel' + ' = 1', ll_row + 1, al_rowcount)
	End If
Loop

//-----------------------------------------------------------------------------------------------------------------------------------
// BEGIN COMMENTED OUT HMD 10/03/2000 17317
//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the rows and expand them if treeexpanded is 'Y'.
//-----------------------------------------------------------------------------------------------------------------------------------
/*ls_expanded = idw_data.Dynamic Object.treeexpanded.Primary[1, al_rowcount]
ll_upper = Min( al_rowcount, UpperBound(ls_expanded))

For ll_index = 1 To ll_upper
	
	If ls_expanded[ll_index] = 'Y' Then
		This.of_expand('single', ll_index)
		al_rowcount = idw_data.Dynamic RowCount()
		ls_expanded = idw_data.Dynamic Object.treeexpanded.Primary[1, al_rowcount]
		ll_upper = Min( al_rowcount, UpperBound(ls_expanded))		
	End If
Next*/
//-----------------------------------------------------------------------------------------------------------------------------------
// END COMMENTED OUT HMD 10/03/2000 17317
//-----------------------------------------------------------------------------------------------------------------------------------
		
//-----------------------------------------------------------------------------------------------------------------------------------
// Set the redraw on because it was turned off in of_retrievestart()
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_setredraw(True)
end subroutine

protected subroutine of_retrieve_as_needed (long al_row);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve_as_needed()
//	Arguments:  al_row - The row to retrieve for.
//	Overview:   This function will take a row and retrieve its children for it based on its level, and the dataobject and required
//					argument columns specified in the initialization.
//	Created by:	Denton Newham
//	History: 	2/17/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_level, ll_upper, ll_index, ll_return, ll_count
string ls_argument, ls_dataobject, ls_sort[], ls_parent_sort, ls_values
boolean lb_rows_retrieved = False
Datawindow ldw_data
Datastore	lds_datastore

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the level for al_row.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_level = idw_data.Dynamic GetItemNumber(al_row, 'treelevel')

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the level retrievals specified on initialization and determine the dataobject for the level.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upper = Min(UpperBound(is_treelevel), UpperBound(is_dataobject))
If ll_upper < 1 Then Return

For ll_index = 1 To ll_upper
	
	If is_treelevel[ll_index] = String(ll_level) Then
		
		ls_dataobject = is_dataobject[ll_index]
		Exit
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Now get the argument for the row and attach the level at the front.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_argument = idw_data.Dynamic GetItemString(al_row, 'argument')

ls_values = String(ll_level) + '@@@' + ls_argument

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the temporary datastore and the retrieve from string object.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ids_data) Then
	ids_data = Create datastore
Else
	ids_data.DataObject = ''
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dataobject for the datastore.
//-----------------------------------------------------------------------------------------------------------------------------------
ids_data.Dataobject = ls_dataobject
ids_data.SetTransObject(ixctn_transaction)
	
//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve for the datastore from the string of ls_values.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = Long(in_datawindow_tools.of_retrieve(ids_data, ls_values, '@@@'))

//-----------------------------------------------------------------------------------------------------------------------------------
// RowsCopy from ids_data to idw_data, right below al_row.
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_return > 0 Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Publish a message so the datawindow can know to ignore all the events that are getting ready to happen
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_data.Dynamic Event ue_notify('n_datawindow_treeview_service', 'begin expand')
	
	ll_count = ids_data.RowCount()

	Choose Case idw_Data.TypeOf()
		Case Datawindow!
			ldw_data = idw_data
			ll_return = ids_data.RowsCopy(1, ll_count, Primary!, ldw_data, al_row + 1, Primary!)
		Case Datastore!
			lds_datastore	= idw_data
			ll_return = ids_data.RowsCopy(1, ll_count, Primary!, lds_datastore, al_row + 1, Primary!)
	End Choose

	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the sort for the added rows.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_parent_sort = idw_data.Dynamic GetItemString(al_row, 'sort')
	
	Choose Case idw_Data.TypeOf()
		Case Datawindow!
			ldw_data = idw_data
			ls_sort = ldw_data.Object.sort.Primary[al_row + 1, al_row + ll_count]
		Case Datastore!
			lds_datastore	= idw_data
			ls_sort = lds_datastore.Object.sort.Primary[al_row + 1, al_row + ll_count]
	End Choose

	ll_upper = UpperBound(ls_sort)

	For ll_index = 1 To ll_upper
		ls_sort[ll_index] = ls_parent_sort + is_sort_delimiter + ls_sort[ll_index] 
	Next

	Choose Case idw_data.Dynamic TypeOf()
		Case Datawindow!
			ldw_data = idw_data
			ldw_data.Object.sort.Primary[al_row + 1, al_row + ll_count] = ls_sort
		Case Datastore!
			lds_datastore	= idw_data
			lds_datastore.Object.sort.Primary[al_row + 1, al_row + ll_count] = ls_sort
	End Choose
	
	idw_data.Dynamic Sort()
	
	lb_rows_retrieved = True

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Publish a message so the datawindow can know to no longer ignore all the events that are getting ready to happen
	//-----------------------------------------------------------------------------------------------------------------------------------
	idw_data.Dynamic Event ue_notify('n_datawindow_treeview_service', 'end expand')
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Update the treeexpanded to 'Y' for al_row.
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic SetItem(al_row, 'treeexpanded', 'Y')

//-----------------------------------------------------------------------------------------------------------------------------------
// Update the retrieve beneath column to 'N' for al_row.
//-----------------------------------------------------------------------------------------------------------------------------------
idw_data.Dynamic SetItem(al_row, 'retrievebeneath', 'N')

idw_data.Dynamic SetRow(al_row)
//-----------------------------------------------------------------------------------------------------------------------------------
// Trigger the RetrieveEnd event for the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
If lb_rows_retrieved Then
	ib_ignore_retrieveend = True
	idw_data.Dynamic Event RetrieveEnd(idw_data.Dynamic RowCount())
	ib_ignore_retrieveend = False
End If

idw_data.Dynamic ScrollToRow(al_row)
end subroutine

public subroutine of_expand (string as_type, long al_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_expand()
//	Arguments:  as_type - The type of expansion
//					al_argument - The row to start on or the level to expand/contract to
//	Overview:   This will expand a level starting from a row
//	Created by:	Blake Doerr
//	History: 	12.13.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Boolean lb_columnschanged
Long	ll_row, ll_rowcount, ll_endrow, ll_upper
Long	ll_index, ll_level, ll_levels[]
String ls_expanded[], ls_retrieve_beneath[]
Datawindow ldw_data
Datastore	lds_data
SetPointer(Hourglass!)

ll_rowcount = idw_data.Dynamic RowCount()
If al_argument <= 0 Or IsNull(al_argument) Then Return 
If ll_rowcount <= 0 Or IsNull(ll_rowcount) Then Return 

Choose Case Lower(Trim(as_type))
	
	Case	'single'

		ll_level = idw_data.Dynamic GetItemNumber(al_argument, 'treelevel')
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Check if this is a retrieve as needed datawindow.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ib_retrieve_as_needed Then
			
			If idw_data.Dynamic GetItemString(al_argument, 'retrievebeneath') = 'Y' Then 

				//-----------------------------------------------------------------------------------------------------------------------------------
				// If so, make sure it is not one to ignore before retrieving.
				//-----------------------------------------------------------------------------------------------------------------------------------
				If Not This.of_ignore_level(ll_level) Then
					This.of_retrieve_as_needed(al_argument)
					Return
				End If
			End If
		End If

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Find the next row that is at the same or higher level.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If al_argument = ll_rowcount Then
			Return
		Else
			ll_endrow = idw_data.Dynamic Find('treelevel' + ' <= ' + String(ll_level), al_argument + 1, ll_rowcount) - 1
		End If
			
		If ll_endrow <= 0 Or IsNull(ll_endrow) Then ll_endrow = ll_rowcount		

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the expanded column to 'Y' to show the proper bitmap
		//-----------------------------------------------------------------------------------------------------------------------------------
		idw_data.Dynamic SetItem(al_argument, 'treeexpanded', 'Y')
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop on the rows and set the height of level 1 rows, to the row height
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case idw_data.Dynamic TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ll_levels = ldw_data.Object.treelevel.Primary[al_argument, ll_endrow]
				ls_expanded = ldw_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
			Case Datastore!
				lds_data = idw_data
				ll_levels = lds_data.Object.treelevel.Primary[al_argument, ll_endrow]
				ls_expanded = lds_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
		End Choose
		
		ll_upper = Min(UpperBound(ll_levels), UpperBound(ls_expanded))
		ll_row = al_argument
		For ll_index = 1 To ll_upper
			
			If ll_levels[ll_index] = ll_level + 1 Then
				idw_data.Dynamic SetDetailHeight(ll_row, ll_row, il_rowheight)
				
				If ls_expanded[ll_index] = 'Y' Then
					This.of_expand('single', ll_row)
				End If
			End If
			
			ll_row++
		Next

//	An Alternate way to do single expansion.  May be superior if data set is large.  Just uncomment this and comment out the code from the 'Loop on rows' comment to here.
//		ll_row = idw_data.Dynamic Find('treelevel' + ' = ' + String(ll_level + 1), al_argument + 1, ll_endrow)
//		
//		Do While ll_row > 0 And Not IsNull(ll_row)
//			idw_data.Dynamic SetDetailHeight(ll_row, ll_row, il_rowheight)
//			
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			// This will recurse and expand ones that were previously expanded
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			If idw_data.Dynamic GetItemString(ll_row, 'treeexpanded') = 'Y' Then
//				This.of_expand('single', ll_row)
//			End If
//			
//			If ll_row = ll_endrow Then
//				ll_row = 0
//			Else
//				ll_row = idw_data.Dynamic Find('treelevel' + ' = ' + String(ll_level + 1), ll_row + 1, ll_endrow)
//			End If
//		Loop
		
	Case	'section'	
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the level and find the next row that is at the same or higher level.
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_level = idw_data.Dynamic GetItemNumber(al_argument, 'treelevel')
		If al_argument = ll_rowcount Then
			Return
		Else
			ll_endrow = idw_data.Dynamic Find('treelevel' + ' <= ' + String(ll_level), al_argument + 1, ll_rowcount) - 1
		End If
			
		If ll_endrow <= 0 Or IsNull(ll_endrow) Then ll_endrow = ll_rowcount

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make every row in the section have normal height
		//-----------------------------------------------------------------------------------------------------------------------------------
		idw_data.Dynamic SetDetailHeight(al_argument, ll_endrow, il_rowheight)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the level, expanded, and retrieve beneath data for the boundary.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case idw_data.Dynamic TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ll_levels = ldw_data.Object.treelevel.Primary[al_argument, ll_endrow]
				ls_expanded = ldw_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
			Case Datastore!
				lds_data = idw_data
				ll_levels = lds_data.Object.treelevel.Primary[al_argument, ll_endrow]
				ls_expanded = lds_data.Object.treeexpanded.Primary[al_argument, ll_endrow]
		End Choose
		
		If ib_retrieve_as_needed Then
			Choose Case idw_data.Dynamic TypeOf()
				Case Datawindow!
					ldw_data = idw_data
					ls_retrieve_beneath = ldw_data.Object.retrievebeneath.Primary[al_argument, ll_endrow]
				Case Datastore!
					lds_data = idw_data
					ls_retrieve_beneath = lds_data.Object.retrievebeneath.Primary[al_argument, ll_endrow]
			End Choose

			ll_upper = Min( Min( UpperBound(ll_levels), UpperBound(ls_retrieve_beneath)), UpperBound(ls_expanded))
		Else
			ll_upper = Min( UpperBound(ll_levels), UpperBound(ls_expanded))
		End If
			
		For ll_index = 1 To ll_upper - 1

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Update the expanded column to 'Y' for all but the lowest level rows in the section (if their children have been retrieved).
			//-----------------------------------------------------------------------------------------------------------------------------------			
			If ib_retrieve_as_needed Then
				If ll_levels[ll_index + 1] > ll_levels[ll_index] And ls_retrieve_beneath[ll_index] = 'N' Then
					ls_expanded[ll_index] = 'Y'
				End If
				
			Else
				If ll_levels[ll_index + 1] > ll_levels[ll_index] Then
					ls_expanded[ll_index] = 'Y'
				End If

			End If
		Next 
		
		Choose Case idw_data.Dynamic TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ldw_data.Object.treeexpanded.Primary[al_argument, ll_endrow] = ls_expanded		
			Case Datastore!
				lds_data = idw_data
				lds_data .Object.treeexpanded.Primary[al_argument, ll_endrow] = ls_expanded		
		End Choose
		
	Case	'all'
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make every row in the section have normal height
		//-----------------------------------------------------------------------------------------------------------------------------------
		idw_data.Dynamic SetDetailHeight(al_argument, ll_rowcount, il_rowheight)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Get the level, expanded, and retrieve beneath data for the boundary.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case idw_data.Dynamic TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ls_expanded = ldw_data.Object.treeexpanded.Primary[al_argument, ll_rowcount]
				ll_levels = ldw_data.Object.treelevel.Primary[al_argument, ll_rowcount]
			Case Datastore!
				lds_data = idw_data
				ls_expanded = lds_data.Object.treeexpanded.Primary[al_argument, ll_rowcount]
				ll_levels = lds_data.Object.treelevel.Primary[al_argument, ll_rowcount]
		End Choose
		
		If ib_retrieve_as_needed Then
			Choose Case idw_data.Dynamic TypeOf()
				Case Datawindow!
					ldw_data = idw_data
					ls_retrieve_beneath = ldw_data.Object.retrievebeneath.Primary[al_argument, ll_rowcount]
				Case Datastore!
					lds_data = idw_data
					ls_retrieve_beneath = lds_data.Object.retrievebeneath.Primary[al_argument, ll_rowcount]
			End Choose
			
			ll_upper = Min( Min( UpperBound(ll_levels), UpperBound(ls_retrieve_beneath)), UpperBound(ls_expanded))
		Else
			ll_upper = Min( UpperBound(ll_levels), UpperBound(ls_expanded))
		End If
		
		For ll_index = 1 To ll_upper - 1

			//-----------------------------------------------------------------------------------------------------------------------------------
			// Update the expanded column to 'Y' for all but the lowest level rows in the section (if the row's children have been retrieved).
			//-----------------------------------------------------------------------------------------------------------------------------------			
			If ib_retrieve_as_needed Then
				If ll_levels[ll_index + 1] > ll_levels[ll_index] And ls_retrieve_beneath[ll_index] = 'N' Then
					ls_expanded[ll_index] = 'Y'
				End If
				
			Else
				If ll_levels[ll_index + 1] > ll_levels[ll_index] Then
					ls_expanded[ll_index] = 'Y'
				End If

			End If
		Next 
		
		Choose Case idw_data.Dynamic TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ldw_data.Object.treeexpanded.Primary[al_argument, ll_rowcount] = ls_expanded		
			Case Datastore!
				lds_data = idw_data
				lds_data.Object.treeexpanded.Primary[al_argument, ll_rowcount] = ls_expanded		
		End Choose
		
	Case	'level'		
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw off
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(False)			
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop on the rows and set the height and expansion of rows depending on their level.
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case idw_data.Dynamic TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ll_levels = ldw_data.Object.treelevel.Primary[1, ll_rowcount]
				ls_expanded = ldw_data.Object.treeexpanded.Primary[1, ll_rowcount]
				If ib_retrieve_as_needed Then
					ls_retrieve_beneath = ldw_data.Object.retrievebeneath.Primary[al_argument, ll_rowcount]
				End If
			Case Datastore!
				lds_data = idw_data
				ll_levels = lds_data.Object.treelevel.Primary[1, ll_rowcount]
				ls_expanded = lds_data.Object.treeexpanded.Primary[1, ll_rowcount]
				If ib_retrieve_as_needed Then
					ls_retrieve_beneath = lds_data.Object.retrievebeneath.Primary[al_argument, ll_rowcount]
				End If
		End Choose

		If ib_retrieve_as_needed Then
			ll_upper = Min( Min( UpperBound(ll_levels), UpperBound(ls_retrieve_beneath)), UpperBound(ls_expanded))
		Else
			ll_upper = Min( UpperBound(ll_levels), UpperBound(ls_expanded))
		End If
		
		For ll_index = 1 To ll_upper

			Choose Case ll_levels[ll_index]
					
				Case Is < al_argument
					
					If Not ib_retrieve_as_needed Then
						
						//-----------------------------------------------------------------------------------------------------------------------------------
						// Expand all levels higher than al_argument (if they have been retrieved for) and make their height the normal height.
						//-----------------------------------------------------------------------------------------------------------------------------------			
						ls_expanded[ll_index] = 'Y'
						idw_data.Dynamic SetDetailHeight(ll_index, ll_index, il_rowheight)
					Else
						If ls_retrieve_beneath[ll_index] = 'N' Then
							
							//-----------------------------------------------------------------------------------------------------------------------------------
							// Expand all levels higher than al_argument (if they have been retrieved for) and make their height the normal height.
							//-----------------------------------------------------------------------------------------------------------------------------------			
							ls_expanded[ll_index] = 'Y'
							idw_data.Dynamic SetDetailHeight(ll_index, ll_index, il_rowheight)	
						End If
					End If
					
				Case al_argument
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Contract all levels equal to al_argument and make their height the normal height.
					//-----------------------------------------------------------------------------------------------------------------------------------			
					ls_expanded[ll_index] = 'N'
					idw_data.Dynamic SetDetailHeight(ll_index, ll_index, il_rowheight)
					
				Case Is > al_argument

					//-----------------------------------------------------------------------------------------------------------------------------------
					// Contract all levels lower than al_argument and make their height zero.
					//-----------------------------------------------------------------------------------------------------------------------------------			
					ls_expanded[ll_index] = 'N'
					idw_data.Dynamic SetDetailHeight(ll_index, ll_index, 0)		
					
			End Choose

		Next 
		
		Choose Case idw_data.Dynamic TypeOf()
			Case Datawindow!
				ldw_data = idw_data
				ldw_data.Object.treeexpanded.Primary[1, ll_rowcount] = ls_expanded	
			Case Datastore!
				lds_data = idw_data
				lds_data.Object.treeexpanded.Primary[1, ll_rowcount] = ls_expanded	
		End Choose
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Set the redraw off
		//-----------------------------------------------------------------------------------------------------------------------------------
		This.of_setredraw(True)			

End Choose
end subroutine

public subroutine of_build_menu (n_menu_dynamic an_menu_dynamic, string as_columnname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	Blake Doerr
//	History: 	3/1/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long		ll_row
String	ls_BandAtPointer

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(idw_data) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a spacer since the menu has items already
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)

If ib_retrieve_as_needed Then
	an_menu_dynamic.of_add_item('&Expand All Retrieved Rows', 'expand all', '', This)
	an_menu_dynamic.of_add_item('&Contract All Retrieved Rows', 'contract all', '', This)
Else
	an_menu_dynamic.of_add_item('&Expand All', 'expand all', '', This)
	an_menu_dynamic.of_add_item('&Contract All', 'contract all', '', This)
End If

ls_BandAtPointer		= idw_data.Dynamic GetBandAtPointer()
ll_row					= Long(Mid(ls_BandAtPointer, Pos(ls_BandAtPointer, '~t') + 1))
ls_BandAtPointer		= Trim(Lower(Left(ls_BandAtPointer, Pos(ls_BandAtPointer, '~t') - 1)))

If ll_row > 0 And Not IsNull(ll_row) And ll_row <= idw_data.Dynamic RowCount() And ls_BandAtPointer = 'detail' Then
	an_menu_dynamic.of_add_item('-', '', '', This)
	an_menu_dynamic.of_add_item('E&xpand Section From This Level', 'expand section', string(ll_row), This)
	an_menu_dynamic.of_add_item('C&ontract Section To This Level', 'contract section', string(ll_row), This)
	an_menu_dynamic.of_add_item('-', '', '', This)
	an_menu_dynamic.of_add_item('Ex&pand/Contract All To This Level', 'expand/contract to level', String(idw_data.Dynamic GetItemNumber(ll_row, 'treelevel')), This)

	If This.of_get_retrieve_as_needed() Then
		an_menu_dynamic.of_add_item('&Refresh Section From This Level', 'refresh section', string(ll_row), This)
	End If
End If
end subroutine

public subroutine of_set_batch_mode (boolean ab_batchmode);ib_batchmode = ab_batchmode
end subroutine

on n_datawindow_treeview_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datawindow_treeview_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   DocumentScriptFunctionality
//	Created by: Denton Newham
//	History:    12/12/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(ids_data) 						Then Destroy ids_data
If IsValid(in_datawindow_tools) 			Then Destroy in_datawindow_tools


end event

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	None
//	Overview:   This object is a datawindow treeview service.  It can take your data and present it in a way consistent with a treeview if you use it
//					in conjunction with a u_search object that has this service set up.  The data must be returned to the datawindow in the correct order
//					and must have a sort column that will order the datawindow correctly when needed.
//					The following columns are required by this service and must be named the same as below:
//
//					TreeExpanded - A char(1) column used to determine if a row is expanded or collapsed.
//					TreeLevel - A long that holds the level in a treeview for a row.
//					Sort - A varchar column that holds the sort string for a row
//					TreeViewInit - A computed column whose expression is a quoted list of all the specification you want to modify for the service.
//					Argument - A varchar column that holds the retrieve as needed retrieval criteria for a row.
//					RetrieveBeneath A char(1) column used to determine if a row needs to be retrieve as needed.  Only required when retrieve as needed is yes.
//
//					The following is a list of the attributes you can modify using a || delimited string in the TreeViewInit computed column:
//
//					indention = Number 				- The number of PowerBuilder units to indent the indented columns per TreeLevel.
//					indented columns = column,..	- A comma delimited list of the columns to indent.
//					retrieve as needed = yes/no	- Whether or not the datawindow will retrieve rows as the user expands downward in the treeview.
//					level retrieval = level;dataobject @@ level;dataobject
//															- The retrieval requirements for retrieving rows by level. 
//															Think of it as what dataobject is needed to retrieve rows that will go in the next level
//															down, i.e., the children of row being expanded.
//					bold colums = column,..			- A comma delimited list of the columns to bold as pointer is moved over them.  This requires the 
//															RowFocusIndicator service to be initialized.
//					level entity = level;entity @@ level;entity
//															- The entity for a level.  This will be used to determine the correct navigation options.
//					navigation string column = column 	- The column in the datawindow that holds the navigation string for any row.
//					ignore levels = level,level,	- An array of levels for retrieve as needed functionality to ignore.  This is relevant
//															when one retrive as needed brings back more than just the next level.  You would want to
//															make those middle levels ignored so the object will not try and retrieve for them.
//
//	Created by: Denton Newham
//	History:    2/18/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ixctn_transaction 	= SQLCA
in_datawindow_tools 	= Create n_datawindow_tools
end event

