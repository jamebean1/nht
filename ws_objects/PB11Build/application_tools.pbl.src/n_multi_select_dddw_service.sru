$PBExportHeader$n_multi_select_dddw_service.sru
forward
global type n_multi_select_dddw_service from nonvisualobject
end type
end forward

global type n_multi_select_dddw_service from nonvisualobject
event ue_insert_multi_select_item ( )
end type
global n_multi_select_dddw_service n_multi_select_dddw_service

type variables
datawindow idw_data 
string is_ignoredcolumns[]
integer ii_ignoredcount=0
string is_column_list
string is_columnlist[]
window iw_win
long 		il_multi_select_id 			= -9687
datetime	idt_multi_select_datetime
string	is_multi_select_string 		= 'multiselectstring'
//n_string_functions in_string_functions
end variables

forward prototypes
public subroutine of_init (datawindow adw_data)
public function boolean of_itemchanged (long row, dwobject dwo, string data)
public function boolean of_open_dddw (dragobject ado_cntrl, graphicobject ago_prnt)
public function long of_dropdown ()
end prototypes

event ue_insert_multi_select_item();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_insert_multi_select_item
//	Overrides:  No
//	Arguments:	none
//	Overview:   Inserts the <Multi-Select> item into the DDDW of the columns
//             controlled by this service, and sets the initial value
//             of the controlled column
//	Created by: Pat Newgent
//	History:    2/6/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long 		i, ll_row
Long		ll_null
String	ls_null
DateTime	ldt_null
string	ls_search, ls_describe, ls_data_column, ls_display_column, ls_values, ls_type
Datawindowchild ldwc

SetNull(ll_null)
SetNull(ls_null)
SetNull(ldt_null)

If Not IsValid(idw_data) Then Return

ll_row = idw_data.GetRow()
if ll_row = 0 then return

For i = 1 to UpperBound(is_columnlist)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Determine the data column & display column for the DDDW, and 
	// insert the <multi-select> item into the DDDW
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_describe = is_columnlist[i] + ".dddw.DataColumn"
	ls_data_column = idw_data.Describe(ls_describe)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// RAID #20840 - Begin
	// 5/8/2001 - RPN
	// Check to see if the column is still valid, if not go to the next column
	//-----------------------------------------------------------------------------------------------------------------------------------
	if ls_data_column = '!' then continue
	//-----------------------------------------------------------------------------------------------------------------------------------
	// RAID #20840 - End
	//-----------------------------------------------------------------------------------------------------------------------------------

	ls_describe = is_columnlist[i] + ".dddw.DisplayColumn"
	ls_display_column = idw_data.Describe(ls_describe)

	ls_describe = is_columnlist[i] + ".ColType"
	ls_type = idw_data.Describe(ls_describe)
	
	If ls_data_column = 'none' or ls_display_column = 'none' Then Continue
		
	idw_data.GetChild(is_columnlist[i], ldwc)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// RAID 21488
	// 6/07/2001 - RPN
	// Determine if the <Multi-Select> row has already been added prior to adding it
	//-----------------------------------------------------------------------------------------------------------------------------------
	if ldwc.Find (ls_display_column + " = '<multi-select>'",1, ldwc.Rowcount()) = 0 then
		ll_row = ldwc.InsertRow(0)
		
		Choose Case Lower(Left(ls_type, 4))			
			Case 'numb','deci','long'
				ldwc.SetItem(ll_row, ls_data_column, il_multi_select_id)	
			Case 'date'
				ldwc.SetItem(ll_row, ls_data_column, idt_multi_select_datetime)
			Case 'char'
				ldwc.SetItem(ll_row, ls_data_column, is_multi_select_string)
		End Choose
	
		ldwc.SetItem(ll_row, ls_display_column, '<multi-select>')
	End If 
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the appropriate value into the column containing the DDDW based 
	// on the value stored in the corresponding multi-select buffer.  i.e., if more
	// than one value is stored in the buffer set the value for the column to <multi-select>,
	// else set the value in the column to the value stored in the buffer.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_values = idw_data.GetItemString(1, is_columnlist[i]+'_multi')
	
	If Not IsNull(ls_values) Then
		Choose Case lower(left(ls_type,4))
			Case 'numb','deci','long'
				If Pos(ls_values, ',', 1) > 0 then
					idw_data.SetItem(1, is_columnlist[i], il_multi_select_id)
				Else
					If Lower(Trim(ls_values)) = 'null' Then
						idw_data.SetItem(1, is_columnlist[i], ll_null)
					Else
						idw_data.SetItem(1, is_columnlist[i], Long(ls_values))
					End If
				End IF
		
			Case 'date'
				If Pos(ls_values, ',', 1) > 0 then
					idw_data.SetItem(1, is_columnlist[i], idt_multi_select_datetime)
				Else
					If Left(ls_values, 1) = '"' Then ls_values = Mid(ls_values, 2, Len(ls_values) - 2)
					
					If Lower(Trim(ls_values)) = 'null' Then
						idw_data.SetItem(1, is_columnlist[i], ldt_null)
					Else
						idw_data.SetItem(1, is_columnlist[i], gn_globals.in_string_functions.of_convert_string_to_datetime(ls_values))
					End If
				End IF
		
			Case 'char'
				If Pos(ls_values, ',', 1) > 0 then
					idw_data.SetItem(1, is_columnlist[i], is_multi_select_string)
				Else
					If Left(ls_values, 1) = '"' Then 
						ls_values = Mid(ls_values, 2, Len(ls_values) - 2)
					End If
					If Lower(Trim(ls_values)) = 'null' Then
						idw_data.SetItem(1, is_columnlist[i], ls_null)
					Else
						idw_data.SetItem(1, is_columnlist[i], ls_values)
					End If
				End If
		End Choose
	End If
Next
end event

public subroutine of_init (datawindow adw_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_init
//	Overrides:  No
//	Arguments:	adw_data   The datawindow for which this service is attached
//
//	Overview:   Enable this service for each column that has an associated 
//             multi-select buffer.  The multi-select buffer will be a column that 
//             has the same name as another column, but has the suffix _Multi.
//	Created by: Pat Newgent
//	History:    2-06-2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long	li_cols, li_i, i
string	ls_column, ls_columntype

idw_data = adw_data

li_cols = integer( idw_data.describe( "datawindow.column.count"))
i = 1
for li_i = 1 to li_cols
	ls_column = idw_data.describe( "#" + string( li_i) + ".name")
	if upper(right(ls_column, 6)) <> '_MULTI' then Continue
	ls_column = Left(ls_column, (len(ls_column) - 6))
	ls_columntype = idw_data.describe(ls_column +  ".ColType")
//	If Not Lower(Trim(ls_columntype)) = 'long' And Not Lower(Trim(ls_columntype)) = 'number' Then Continue
	is_column_list = is_column_list + '.' + ls_column + '.'
	
	is_columnlist[i] = ls_column
	i++
	
next

//-----------------------------------------------------------------------------------------------------------------------------------
// Post this event, so that it occurs after the retrieve for the datawindow, and 
// the retrieval of the default values.
//-----------------------------------------------------------------------------------------------------------------------------------
This.PostEvent('ue_insert_multi_select_item')

end subroutine

public function boolean of_itemchanged (long row, dwobject dwo, string data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_itemchanged()
// Arguments:  row      The row currently being modified
//					dwo      The datawindow object in which data is being modified
//             data		The new data that is being entered
//
// Overview:   This function passes the data of a column being managed by the
//             this service to the columns multi-select buffer, this is required whenever
//             the user is selecting a value in a DDDW via the keyboard.
// Created by: Pat Newgent
// Created:    2/6/2001 
// History:
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_clckd_objct, ls_objct
string	ls_col

ls_col = idw_data.GetColumnName()

if Pos (is_column_list, '.' + ls_col + '.') > 0 then
	ls_col = ls_col + '_multi'
	If IsNull(data) Then
		idw_data.SetItem(row, ls_col, 'Null')
	Else
		idw_data.SetItem(row, ls_col, data)
	End If
end if

Return True
end function

public function boolean of_open_dddw (dragobject ado_cntrl, graphicobject ago_prnt);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_opn_dddw()
// Arguments:  ado_cntrl      The datawindow control for which the Multi-Select DDDW will appear
//					ago_prnt       The parent object that contains the datwindow control
// Overview:   This function opens a multi-select DDDW
// Created by: Pat Newgent
// Created:    2/6/2001 
// History:
//-----------------------------------------------------------------------------------------------------------------------------------


datawindow		ldw
string			ls_clmn,	s_object
graphicobject lgo_parent

window	lw_win
userobject	uo_object

choose case ago_prnt.typeof()
	case window!
		lw_win = ago_prnt
		iw_win = ago_prnt
	case userobject!
		uo_object = ago_prnt

		lgo_parent = uo_object.getparent()
		DO WHILE lgo_parent.TypeOf() <> Window!	
			lgo_parent = lgo_parent.GetParent()
		LOOP

		lw_win = lgo_parent
end choose


if ado_cntrl.typeof() = datawindow! then
	ldw = ado_cntrl
	ls_clmn = ldw.getcolumnname()
//	ll_x_position = ldw.X
	gn_globals.gnv_drpdwnppup_mngr.uof_set_pntrx(lw_win.pointerx())
	gn_globals.gnv_drpdwnppup_mngr.uof_set_pntry(lw_win.pointery())

	s_object = ldw.getobjectatpointer()
	gn_globals.gnv_drpdwnppup_mngr.uof_set_objct_at_pntr( ls_clmn + "~t" + mid( s_object, pos(s_object, "~t") + 1, 99999))

end if

if gn_globals.gnv_drpdwnppup_mngr.of_IsVisible (lw_win, 'w_multi_select_dddw', ls_clmn) then
	gn_globals.gnv_drpdwnppup_mngr.HideAll()
	Return True
End IF

gn_globals.gnv_drpdwnppup_mngr.uof_set_do_cntrl( ado_cntrl)
gn_globals.gnv_drpdwnppup_mngr.uof_set_prnt( lw_win)
gn_globals.gnv_drpdwnppup_mngr.uof_set_clmn( ls_clmn)
gn_globals.gnv_drpdwnppup_mngr.uof_set_drpdwnppupnme( "w_multi_select_dddw")
gn_globals.gnv_drpdwnppup_mngr.uof_set_mke_vsble( TRUE)
gn_globals.gnv_drpdwnppup_mngr.uof_set_drpdwn_is_glbl( FALSE)
gn_globals.gnv_drpdwnppup_mngr.uof_set_uo_prnt( uo_object)


gn_globals.gnv_drpdwnppup_mngr.open()

return TRUE


end function

public function long of_dropdown ();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_dropdown()
//	Overrides:  No
//	Arguments:	
//	Overview:   Determines whether or not to display the multi-select dropdown for
//             the current column
//	Created by: Pat Newgent
//	History:    2/6/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	ls_clckd_objct, ls_objct
string	ls_col

ls_col = idw_data.GetColumnName()
idw_data.AcceptText()
idw_data.SetFocus()
idw_data.SelectText(1, 10000)


if Pos (is_column_list, '.' + ls_col + '.') > 0 then
	of_open_dddw ( idw_data, idw_data.getparent())
	return 1
end if

Return 0

end function

on n_multi_select_dddw_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_multi_select_dddw_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;idt_multi_select_datetime = DateTime(Date('01/01/1900'),Time('11:34'))
end event

