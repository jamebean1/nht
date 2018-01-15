$PBExportHeader$n_datawindow_syntax.sru
forward
global type n_datawindow_syntax from nonvisualobject
end type
end forward

global type n_datawindow_syntax from nonvisualobject
end type
global n_datawindow_syntax n_datawindow_syntax

type variables
PowerObject io_datasource
String	Release
String	Datawindow
String	Header
String	Summary
String	Footer
String	Detail
String	SQLStatement
String	Column[]
String	Objects
String	HTMLTable
String	HTMLGen

n_string_functions in_string_functions

long		il_new_ID
end variables

forward prototypes
public function string of_trim (string as_syntax)
public function string of_get_syntax ()
public function long of_find (string as_whattofind, string as_syntax)
public subroutine of_set_datasource (powerobject ao_datasource)
public function long of_add_column (string as_type, ref string as_name, string as_values, string as_default)
public function long of_add_column (string as_type, ref string as_name, string as_values)
public function long of_delete_column (string as_name)
public function integer of_determine_x_cord (datawindow adw_datawindow)
public function integer of_get_column_id (integer as_index)
public function long of_add_column (string as_type, ref string as_name, string as_values, string as_default, string as_display_name, boolean ab_last_column, boolean ab_add_to_gui)
end prototypes

public function string of_trim (string as_syntax);as_syntax = Trim(as_syntax)

If Right(as_syntax, 2) = '~r~n' Then
	as_syntax = Left(as_syntax, Len(as_syntax) - 2)
End If

If IsNull(as_syntax) Then as_syntax = ''

Return as_syntax
end function

public function string of_get_syntax ();String 	ls_new_syntax
Long		ll_index

ls_new_syntax = Release + '~r~n'
ls_new_syntax = ls_new_syntax + Datawindow + '~r~n'
ls_new_syntax = ls_new_syntax + Header + '~r~n'
ls_new_syntax = ls_new_syntax + Summary + '~r~n'
ls_new_syntax = ls_new_syntax + Footer + '~r~n'
ls_new_syntax = ls_new_syntax + Detail + '~r~ntable('

For ll_index = 1 To UpperBound(Column[])
	If ll_index <> 1 Then
		ls_new_syntax = ls_new_syntax
	End If

	ls_new_syntax = ls_new_syntax + Column[ll_index] + '~r~n'
Next

ls_new_syntax = ls_new_syntax + ' ' + SQLStatement + ')~r~n'
ls_new_syntax = ls_new_syntax + Objects

Return ls_new_syntax
end function

public function long of_find (string as_whattofind, string as_syntax);Long	ll_position, ll_possible_position


Choose Case Lower(Trim(as_whattofind))
	Case 'table'
		Return Pos(as_syntax, 'table(column')
	Case 'detail'
		Return Pos(as_syntax, 'detail(height')
	Case 'footer'
		Return Pos(as_syntax, 'footer(height')
	Case 'summary'
		Return Pos(as_syntax, 'summary(height')
	Case 'header'
		Return Pos(as_syntax, 'header(height')
	Case 'datawindow'
		Return Pos(as_syntax, 'datawindow(units')
	Case 'sqlstatement'
		ll_position = Pos(as_syntax, 'retrieve="')
		If ll_position = 0 Then
			ll_position = Len(as_syntax)
		End If
		
		Return Min(ll_position, Pos(as_syntax, 'procedure="'))
	Case 'column'
		Return Pos(as_syntax, 'column=(type')
	Case 'text'
		Return Pos(as_syntax, 'text(')
	Case 'column display'
		Return Pos(as_syntax, 'column(')
End Choose

//Find the very first object.
ll_position = 				Pos(as_syntax, 'text(')
ll_possible_position = 	Pos(as_syntax, 'column(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'compute(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'line(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'bitmap(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'ole(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'ellipse(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'rectangle(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'report(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'roundrectangle(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'tableblob(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)

ll_possible_position = 	Pos(as_syntax, 'group(')
If ll_possible_position > 0 Then ll_position = Min(ll_possible_position, ll_position)


Return ll_position
end function

public subroutine of_set_datasource (powerobject ao_datasource);Long	ll_position
Long	ll_index
String	Table
String	DatawindowSyntax
String	ls_columns[]
String	ls_empty[]
String	ls_old_syntax
String	ls_new_syntax

//n_string_functions ln_string_functions

io_datasource = ao_datasource

If Not IsValid(io_datasource) Then Return

Column[] = ls_empty[]

DatawindowSyntax 	= io_datasource.Dynamic Describe("Datawindow.Syntax")
ls_old_syntax		= DatawindowSyntax

ll_position = of_find('firstobject', DatawindowSyntax)
Objects 				= of_trim(Mid(DatawindowSyntax, ll_position))
DatawindowSyntax 	= Left(DatawindowSyntax, ll_position - 1)

ll_position = of_find('table', DatawindowSyntax)
Table 				= of_trim(Mid(DatawindowSyntax, ll_position))
DatawindowSyntax 	= Left(DatawindowSyntax, ll_position - 1)

ll_position = of_find('detail', DatawindowSyntax)
Detail 				= of_trim(Mid(DatawindowSyntax, ll_position))
DatawindowSyntax 	= Left(DatawindowSyntax, ll_position - 1)

ll_position = of_find('footer', DatawindowSyntax)
Footer 				= of_trim(Mid(DatawindowSyntax, ll_position))
DatawindowSyntax 	= Left(DatawindowSyntax, ll_position - 1)

ll_position = of_find('summary', DatawindowSyntax)
Summary 				= of_trim(Mid(DatawindowSyntax, ll_position))
DatawindowSyntax 	= Left(DatawindowSyntax, ll_position - 1)

ll_position = of_find('header', DatawindowSyntax)
Header 				= of_trim(Mid(DatawindowSyntax, ll_position))
DatawindowSyntax 	= Left(DatawindowSyntax, ll_position - 1)

ll_position = of_find('datawindow', DatawindowSyntax)
Datawindow 				= of_trim(Mid(DatawindowSyntax, ll_position))
DatawindowSyntax 	= Left(DatawindowSyntax, ll_position - 1)

Release = of_trim(DatawindowSyntax)

ll_position 	= of_find('sqlstatement', Table)
If ll_position > 0 Then
	SQLStatement 	= of_trim(Mid(Table, ll_position))
	SQLStatement 	= Reverse(Mid(Reverse(SQLStatement), Pos(Reverse(SQLStatement), ')') + 1))
	Table = of_trim(Left(Table, ll_position - 1))
Else
	Table = Left(Table, Len(Table) - 1)
	SQLStatement = ''
End If


Table = Mid(Table, Pos(Table, 'table(') + Len('table('))

gn_globals.in_string_functions.of_parse_string(Table, 'column=(', ls_columns[])

For ll_index = 1 To UpperBound(ls_columns[])
	ls_columns[ll_index] = Trim(ls_columns[ll_index])
	
	If Len(ls_columns[ll_index]) = 0 Then Continue
	
	Column[UpperBound(Column[]) + 1] = of_trim('column=(' + ls_columns[ll_index])
Next

table = table
end subroutine

public function long of_add_column (string as_type, ref string as_name, string as_values, string as_default);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Boolean 	lb_KeepGoing = True

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the column name since there could possibly be duplicates
//-----------------------------------------------------------------------------------------------------------------------------------
Do While lb_KeepGoing
	lb_KeepGoing = False
	
	For ll_index = 1 To UpperBound(Column[])
		If Pos(Lower(Column[ll_index]), "name=" + as_name + " ") > 0 Then
			as_name = as_name + '1'
			lb_KeepGoing = True
			Exit
		End If
	Next
Loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column
//-----------------------------------------------------------------------------------------------------------------------------------
Column[UpperBound(Column[]) + 1] = 'column=(type=' + Trim(Lower(as_Type)) + ' update=no updatewhereclause=no name=' + Lower(Trim(as_name)) + ' dbname="' + Trim(as_name) + '" '

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the values property if it's valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(as_default)) > 0 And Not IsNull(as_default) And as_default <> '?' And as_default <> '!' Then
	If Lower(Trim(as_default)) = 'empty' Then as_default = ''
	Column[UpperBound(Column[])] = Column[UpperBound(Column[])] + '~r~n initial="' + Trim(as_default) + '" '
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the values property if it's valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(Trim(as_values)) > 0 And Not IsNull(as_Values) And as_values <> '?' And as_values <> '!' Then
	Column[UpperBound(Column[])] = Column[UpperBound(Column[])] + '~r~n values="' + Trim(as_values) + '"  )'
Else
	Column[UpperBound(Column[])] = Column[UpperBound(Column[])] + ' )'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the new column ID
//-----------------------------------------------------------------------------------------------------------------------------------
Return UpperBound(Column[])
end function

public function long of_add_column (string as_type, ref string as_name, string as_values);Return This.of_add_column(as_type, as_name, as_values, '')
end function

public function long of_delete_column (string as_name);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Long		ll_found
String	ll_empty[]
String	ll_new_column[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Local objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the column to be deleted
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(Column[])
	If Pos(Lower(Column[ll_index]), "name=" + as_name + " ") > 0 Then
		ll_found = ll_index
		Exit
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if we don't find anything
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_found = 0 Or IsNull(ll_found) Then Return -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Set its syntax to empty string
//-----------------------------------------------------------------------------------------------------------------------------------
Column[ll_found] = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace the ID's since the column numbers will change for all subsequent columns
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = ll_found + 1 To UpperBound(Column[])
	Objects = gn_globals.in_string_functions.of_replace_all(Objects, ' ID=' + String(ll_index) + ' ', ' ID=' + String(ll_index - 1) + ' ', True)
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Rebuild the column array
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Upperbound(Column[])
	If Column[ll_index] = '' Then Continue
	ll_new_column[UpperBound(ll_new_column) + 1] = Column[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Empty the column array, then reset
//-----------------------------------------------------------------------------------------------------------------------------------
Column[] = ll_empty[]
Column[] = ll_new_column[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the new upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
Return UpperBound(Column[])
end function

public function integer of_determine_x_cord (datawindow adw_datawindow);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  adw_datawindow	 	- This is the datawindow in which you want to find the biggest x cordinate
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	3/22/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long ll_count, l_nIndex, l_nX, l_nY, l_nMaxY, l_nMaxX, ll_new_x
Long l_nWidth, l_nMaxWidth, l_nLastCol, l_nNewTabSeq, l_nTabSeq
string l_sColName

ll_count = LONG (adw_datawindow.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO ll_count
	IF adw_datawindow.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = adw_datawindow.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX 		= INTEGER (adw_datawindow.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY 		= INTEGER (adw_datawindow.Describe("#" + STRING(l_nIndex) + '.Y'))
		l_nWidth = INTEGER (adw_datawindow.Describe("#" + STRING(l_nIndex) + '.Width'))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxX = l_nX
			l_nMaxY = l_nY
			l_nMaxWidth = l_nWidth
			l_nLastCol = l_nIndex
		ELSEIF (l_nY = l_nMaxY) THEN
			IF l_nX > l_nMaxX THEN
				l_nMaxX = l_nX
				l_nMaxWidth = l_nWidth
				l_nLastCol = l_nIndex
			END IF
		END IF
	END IF
NEXT

ll_new_x = l_nMaxX + l_nWidth

Return ll_new_x

end function

public function integer of_get_column_id (integer as_index);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_index 	- A number that will be used to determine the new ID. Usually for a for next loop index number
//	Overview:   Gets the 
//	Created by:	Joel White
//	History: 	3/30/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long	i, ll_pos, ll_next_pos, ll_ID, ll_max_id
string	ls_ID

//ll_max_id = 0
//
//For i = 1 to UpperBound(Column[])
//	ll_pos = Pos(string(Column[i]), 'id=') + 4
//	ll_next_pos = Pos(string(Column[i]), ' ', ll_pos) - 1
//	
//	ls_id = Mid(string(Column[i]), ll_pos, ll_next_pos - ll_pos)
//	ll_id	=	Long(ls_id)
//	
//	If ll_id > ll_max_id Then
//		ll_max_id = ll_id
//	End If
//Next

ll_max_id = UpperBound(Column[]) + as_index

Return ll_max_id
end function

public function long of_add_column (string as_type, ref string as_name, string as_values, string as_default, string as_display_name, boolean ab_last_column, boolean ab_add_to_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_type 	- column type
//					as_name	- column database name
//					as_values - the ID for the column, needs to be dynamically created from the calling code
//					as_default - x position for the new column
//					as_display_name - display name for the text column
//					ab_add_to_gui - If you want the new column to be added to the GUI
//	Overview:   This overloaded function lets you create a new database column, text label, and display column
//					and add it into a datawindow.
//	Created by:	Joel White
//	History: 	3/29/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
Boolean 	lb_KeepGoing = True
boolean 	lb_continue

//-----------------------------------------------------------------------------------------------------------------------------------
// Determine the column name since there could possibly be duplicates
//-----------------------------------------------------------------------------------------------------------------------------------
Do While lb_KeepGoing
	lb_KeepGoing = False
	
	For ll_index = 1 To UpperBound(Column[])
		
		If Pos(Lower(Column[ll_index]), "name=" + as_name + " ") > 0 Then
			as_name = as_name + '1'
			lb_KeepGoing = True
			Exit
		End If
		
	Next
Loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the column
//-----------------------------------------------------------------------------------------------------------------------------------
Column[UpperBound(Column[]) + 1] = 'column=(type=' + Trim(Lower(as_Type)) + ' updatewhereclause=no name=' + Lower(Trim(as_name)) + ' dbname="' + Trim(as_name) + '" '


//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	Added	3/15/2005
//-----------------------------------------------------------------------------------------------------------------------------------
If	ab_add_to_gui Then
	string	ls_labels[]
	string	ls_display_columns[]
	Long		ll_pos, ll_next_pos, ll_array_count
	string	ls_header_template, ls_column_template
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the beginning and end of the first column header then store it in ls_header_template for manipulation
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_pos	= 	Pos(Objects, 'text(')
	ll_next_pos = Pos(Objects, ')', ll_pos) + 1
	
	ls_header_template = Mid(Objects, ll_pos, ll_next_pos - ll_pos)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the position of the name of the header, delete it then insert the new display name
	//-----------------------------------------------------------------------------------------------------------------------------------
	//text(name=case_log_opnd_date_t visible="1" band=header font.charset="0" font.face="Arial" font.family="2" font.height="-10" font.pitch="2" font.weight="400" background.mode="2" background.color="67108864" color="33554432" alignment="2" border="6" x="914" y="8" height="64" width="411" text="Date Opened" )
	ll_pos = Pos(ls_header_template, 'name=')
	ll_next_pos = Pos(ls_header_template, ' ', ll_pos + 1)
	
	ls_header_template = Replace(ls_header_template, ll_pos, ll_next_pos - ll_pos, '')
	ls_header_template = Replace(ls_header_template, ll_pos, 0, 'name=' + as_name + '_t')

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the text that is displayed on the header, delete it, then insert the new display name
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_pos = Pos(ls_header_template, 'text="')
	ll_next_pos = Pos(ls_header_template, '"', ll_pos + 6) + 1
	
	ls_header_template = Replace(ls_header_template, ll_pos, ll_next_pos - ll_pos, '')
	ls_header_template = Replace(ls_header_template, ll_pos, 0, 'text="' + as_display_name + '"')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the new x cordinate for the label into the syntax
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_pos = Pos(ls_header_template, 'x="')
	ll_next_pos = Pos(ls_header_template, '"', ll_pos + 3) + 1
	
	ls_header_template = Replace(ls_header_template, ll_pos, ll_next_pos - ll_pos, '')
	ls_header_template = Replace(ls_header_template, ll_pos, 0, 'x="' + as_default + '"')
	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the beginning and end of the first column header then store it in ls_header_template for manipulation
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_pos	= 	Pos(Objects, 'column(')
	ll_next_pos = Pos(Objects, ')', ll_pos) + 1
	
	ls_column_template = Mid(Objects, ll_pos, ll_next_pos - ll_pos)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the position of the name of the column, delete it then insert the new column name
	//-----------------------------------------------------------------------------------------------------------------------------------
	//column(name=case_log_opnd_date visible="1" band=detail id=1 x="914" y="8" height="76" width="411" color="33554432" border="0" alignment="0" format="mm/dd/yyyy" edit.focusrectangle=no edit.autohscroll=yes edit.autoselect=yes edit.autovscroll=no edit.case=any edit.codetable=no edit.displayonly=no edit.hscrollbar=no edit.imemode=0 edit.limit=0 edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=no edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no background.mode="1" background.color="536870912" font.charset="0" font.face="Arial" font.family="2" font.height="-10" font.pitch="2" font.weight="400" tabsequence=0 )
	ll_pos = Pos(ls_column_template, 'name=')
	ll_next_pos = Pos(ls_column_template, ' ', ll_pos)
	
	ls_column_template = Replace(ls_column_template, ll_pos, ll_next_pos - ll_pos, '')
	ls_column_template = Replace(ls_column_template, ll_pos, 0, 'name=' + as_name)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find the position of the name of the column, delete it then insert the new column name
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_pos = Pos(ls_column_template, 'id=')
	ll_next_pos = Pos(ls_column_template, ' ', ll_pos)
	
	ls_column_template = Replace(ls_column_template, ll_pos, ll_next_pos - ll_pos, '')
	ls_column_template = Replace(ls_column_template, ll_pos, 0, 'id=' + as_values)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the new x cordinate for the label into the syntax
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_pos = Pos(ls_column_template, 'x="')
	ll_next_pos = Pos(ls_column_template, '"', ll_pos + 3) + 1
	
	ls_column_template = Replace(ls_column_template, ll_pos, ll_next_pos - ll_pos, '')
	ls_column_template = Replace(ls_column_template, ll_pos, 0, 'x="' + as_default + '"')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Insert the new x cordinate for the label into the syntax
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_pos = Pos(ls_column_template, 'format="') 	
	ll_next_pos = Pos(ls_column_template, '"', ll_pos + 8) + 1
	
	ls_column_template = Replace(ls_column_template, ll_pos, ll_next_pos - ll_pos, '')
	ls_column_template = Replace(ls_column_template, ll_pos, 0, 'format="[general]"')

	//-----------------------------------------------------------------------------------------------------------------------------------
	// The last text header needs to be put after the columns and just before the htmltable, if not last then just put
	// at the end of the text columns.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If Not ab_last_column	Then
		
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Find the end of the Text column section and then insert the header template
			//-----------------------------------------------------------------------------------------------------------------------------------
			lb_continue = TRUE
		
			ll_pos 		= 	0
			ll_next_pos = 	0
			ll_pos	= 	Pos(Objects, 'text(')
			
			DO WHILE lb_continue    
				ll_next_pos = Pos(Objects, 'text(', ll_pos + 5)
				If ll_next_pos > ll_pos Then 
					ll_pos = ll_next_pos
				Else
					lb_continue = FALSE
				End If
			LOOP
			
			ll_next_pos = Pos(Objects, ')', ll_pos) + 1
		
			Objects = Replace(Objects, ll_pos - 1, 0, '')
			Objects = Replace(Objects, ll_pos - 1, 0, '~r~n' + ls_header_template + '~r~n')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Find the end of the column section and then insert the header template
			//-----------------------------------------------------------------------------------------------------------------------------------
			lb_continue = TRUE
		
			ll_pos 		= 	0
			ll_next_pos = 	0
			ll_pos	= 	Pos(Objects, 'column(') + 7
			
			DO WHILE lb_continue    
				ll_next_pos = Pos(Objects, 'column(', ll_pos + 7)
				If ll_next_pos > ll_pos Then 
					ll_pos = ll_next_pos
				Else
					lb_continue = FALSE
				End If
			LOOP
			
			ll_next_pos = Pos(Objects, ')', ll_pos) + 1
		
			Objects = Replace(Objects, ll_pos - 1, 0, '')
			Objects = Replace(Objects, ll_pos - 1, 0, '~r~n' + ls_column_template + '~r~n' )	

			
			ll_next_pos = Pos(Objects, ')', ll_next_pos) + 1
	Else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Find the end of the Text column section and then insert the header template
			//-----------------------------------------------------------------------------------------------------------------------------------
			lb_continue = TRUE
		
			ll_pos 		= 	0
			ll_next_pos = 	0
			ll_pos	= 	Pos(Objects, 'htmltable(')
			
			Objects = Replace(Objects, ll_pos - 1, 0, '')
			Objects = Replace(Objects, ll_pos - 1, 0, ls_header_template + '~r~n' )	
				
			Objects = Replace(Objects, ll_pos - 1, 0, '')
			Objects = Replace(Objects, ll_pos - 1, 0, '~r~n' + ls_column_template + '~r~n')
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Find the end of the column section and then insert the header template
			//-----------------------------------------------------------------------------------------------------------------------------------
		End If
		
		
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	End Added 3/15/2005
//-----------------------------------------------------------------------------------------------------------------------------------

Column[UpperBound(Column[])] = Column[UpperBound(Column[])] + ' )'

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the new column ID
//-----------------------------------------------------------------------------------------------------------------------------------
Return UpperBound(Column[])
end function

on n_datawindow_syntax.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datawindow_syntax.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;in_string_functions = Create n_string_functions
end event

event destructor;Destroy in_string_functions
end event

