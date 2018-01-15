$PBExportHeader$u_reference_display_datawindow.sru
$PBExportComments$Basic DAO aware datawindow for deal capture. -  Done
forward
global type u_reference_display_datawindow from u_datawindow
end type
end forward

global type u_reference_display_datawindow from u_datawindow
integer width = 576
integer height = 420
borderstyle borderstyle = stylelowered!
event ue_retrieve ( )
event ue_refreshtheme ( )
event ue_notify ( string as_message,  any aany_argument )
end type
global u_reference_display_datawindow u_reference_display_datawindow

type variables
n_dao idao_transaction
string is_critical_columnlist[]
string is_clientlocked[]
n_daomessage in_message

string is_locked_columnlist[]
end variables

forward prototypes
public subroutine of_lock_columns ()
public subroutine of_unlock_columns ()
protected function integer of_retrieve ()
public subroutine of_setdao (n_dao adao_object)
public subroutine of_set_locked_columns (string as_locked_column_list)
end prototypes

event ue_retrieve;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_retrieve
// Overrides:  No
// Overview:   This event is triggered by the developer to retrieve the data from a dao.
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
reset()

//----------------------------------------------------------------------------------------------------------------------------------
// Load any Dropdowns that are using the CLIENT SQLCA
//-----------------------------------------------------------------------------------------------------------------------------------
this.insertrow(0)
this.deleterow(1)


//----------------------------------------------------------------------------------------------------------------------------------
// Now get the data from the dao.
//-----------------------------------------------------------------------------------------------------------------------------------
of_retrieve()
end event

event ue_refreshtheme;call super::ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   set the color to the currently select theme color.
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_mod
if not  isvalid(this.object) then return

//----------------------------------------------------------------------------------------------------------------------------------
// Set the background color to the current theme backcolor.
//-----------------------------------------------------------------------------------------------------------------------------------
//this.object.datawindow.color = gn_globals.in_theme.of_get_backcolor()

//----------------------------------------------------------------------------------------------------------------------------------
// If there is an object called indicator then set it to show the barcolor when the row is selected.
//-----------------------------------------------------------------------------------------------------------------------------------
if this.describe("indicator.Background.Color") = '!' then return
//ls_mod = "indicator.Background.Color = '0~t" + "if(currentrow() = getrow()," + string(gn_globals.in_theme.of_get_barcolor()) + "," + string(gn_globals.in_theme.of_get_backcolor()) + ")'"
this.modify(ls_mod)
/////
end event

event ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify

// Overrides:  No
// Overview:   This code keeps the dw in sync with the dao by watching for the column change 
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
decimal ld_data
datetime ldt_data
string ls_type
string	ls_data

string	ls_string[]
long		ll_row
string	ls_column


Choose Case lower(as_message)
		
	//----------------------------------------------------------------------------------------------------------------------------------
	// Re-retreive the header with the new status
	//-----------------------------------------------------------------------------------------------------------------------------------
	case 'columnchange'
		
		ls_column = lower(this.getcolumnname())
		
		if pos(lower(string(aany_argument)),ls_column) > 0 and GetFocus() = this then return
		
		gn_globals.in_string_functions.of_parse_string( string(aany_argument), '||', ls_string[])

		ll_row = long(ls_string[1])
		ls_column = lower(ls_string[2])
		ls_data = ls_string[3]

		ls_type = this.Describe(ls_column+".Coltype")
		
		Choose Case lower(left(ls_type,4))
				
			Case 'numb','long','deci'
			
				ld_data = dec(ls_data)
		
				if ls_data = '' or isnull(ls_data) then 
					setnull(ld_data)
				End If

				this.setitem(ll_row, ls_column, ld_data)
		
				
			Case 'date'
				
				if ls_data = '' then 
					setnull(ldt_data)
				else
					ldt_data = gn_globals.in_string_functions.of_convert_string_to_datetime( string( ls_data))
				end if
				this.setitem(ll_row, ls_column, ldt_data)
		
		
			Case 'char'
				
				this.setitem(ll_row, ls_column, ls_data)
		
	End Choose
	
		

end choose

end event

public subroutine of_lock_columns ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  		of_lock_columns()
// Arguments:   none
// Overview:    get a list of locked columns from teh dao and lock them down.
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long li_i
string ls_critical,ls_mod,ls_disable,ls_data, ls_Return
string ls_critical_columnlist[]
n_string_functions in_string
datawindowchild dddw_child

//----------------------------------------------------------------------------------------------------------------------------------
// Reset the instance array
//-----------------------------------------------------------------------------------------------------------------------------------
is_critical_columnlist = ls_critical_columnlist

is_critical_columnlist = is_locked_columnlist


for li_i = 1 to upperbound(is_critical_columnlist)
	ls_mod = is_critical_columnlist[li_i] + ".background.color=553648127"
	ls_Return = this.modify(ls_mod)		

	ls_mod = is_critical_columnlist[li_i] + ".protect=1"
	ls_Return = this.modify(ls_mod)		

Next

for li_i = 1 to upperbound(is_clientlocked)
	
	ls_mod = is_clientlocked[li_i] + ".background.color=553648127"
	this.modify(ls_mod)		

	ls_mod = is_clientlocked[li_i] + ".protect=1"
	this.modify(ls_mod)		

Next

end subroutine

public subroutine of_unlock_columns ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  		of_lock_columns()
// Arguments:   none
// Overview:    get a list of locked columns from teh dao and lock them down.
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datawindowchild dddw_child
long li_i
string ls_mod,ls_data

is_critical_columnlist = is_locked_columnlist

for li_i = 1 to upperbound(is_critical_columnlist)
	
	//ls_mod = is_critical_columnlist[li_i] + ".color=0"
//	
//	if getchild(is_critical_columnlist[li_i] ,dddw_child) = 1 then 
//		
//		ls_data = dddw_child.Describe("Datawindow.Data")
//		ls_mod = is_critical_columnlist[li_i] + ".background.color=16777215"
//		this.modify(ls_mod)			
//		dddw_child.rowsdiscard(1,dddw_child.rowcount(),primary!)
//		dddw_child.importstring(ls_data)
//	else
//
		ls_mod = is_critical_columnlist[li_i] + ".background.color=16777215"
		this.modify(ls_mod)		
		
	//end if
	


	ls_mod = is_critical_columnlist[li_i] + ".protect=0"
	this.modify(ls_mod)		

Next


for li_i = 1 to upperbound(is_clientlocked)
	
	//ls_mod = is_clientlocked[li_i] + ".color=0"
//	if getchild(is_clientlocked[li_i] ,dddw_child) = 1 then 
//		
//		ls_data = dddw_child.Describe("Datawindow.Data")
//		ls_mod = is_clientlocked[li_i] + ".background.color=16777215"
//		this.modify(ls_mod)			
//		dddw_child.rowsdiscard(1,dddw_child.rowcount(),primary!)
//		dddw_child.importstring(ls_data)
//	else

		ls_mod = is_clientlocked[li_i] + ".background.color=16777215"
		this.modify(ls_mod)		
		
	//end if
	

	ls_mod = is_clientlocked[li_i] + ".protect=0"
	this.modify(ls_mod)		

Next



end subroutine

protected function integer of_retrieve ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_retrieve()
// Arguments:   none
// Overview:    retrieve data from DAO
// Created by:  Jake Pratt
// History:     9/9/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long ll_count,ll_column_count
string ls_data
string ls_column_array[]


//----------------------------------------------------------------------------------------------------------------------------------
// Get a list of the columns in the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_column_count =  integer(this.Describe("DataWindow.Column.Count"))

for ll_count = 1 to ll_column_count
	
	ls_column_array[ll_count] = this.Describe( "#" + string(ll_count) + ".Name")
	
NExt


//----------------------------------------------------------------------------------------------------------------------------------
// Now request the data from the dao passing it the column array.
//-----------------------------------------------------------------------------------------------------------------------------------

if isvalid(idao_transaction) then
	ls_data = idao_transaction.of_getdata(ls_column_array)
end if

//----------------------------------------------------------------------------------------------------------------------------------
// The data that is returned is in the format that can be imported.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_count = this.importstring(ls_data)

ll_count = THIS.RowCount()

return this.rowcount()
end function

public subroutine of_setdao (n_dao adao_object);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_setdao
// Overrides:  No
// Overview:   Set the dao that the dw will use into the transaction variable
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

idao_transaction = adao_object

if isvalid(in_message) then
	in_message.of_resetclientobject(this)
end if

in_message = idao_transaction.of_getmessageobject()
in_message.of_setclientobject(this)
end subroutine

public subroutine of_set_locked_columns (string as_locked_column_list);string	ls_locked_columnlist[]

gn_globals.in_string_functions.of_parse_string(as_locked_column_list, ',', ls_locked_columnlist[])

is_locked_columnlist[] = ls_locked_columnlist[]
end subroutine

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor of Datawindow
// Overrides:  No
// Overview:   Initialize the services and Set The Transaction Object
// Created by: Jake Pratt
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

this.settransobject(sqlca)
this.triggerevent('ue_refreshtheme')

n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

ln_datawindow_graphic_service_manager = this.of_get_service_manager()
ln_datawindow_graphic_service_manager.of_add_service('n_autofill')
ln_datawindow_graphic_service_manager.of_add_service('n_keydown_date_defaults')
ln_datawindow_graphic_service_manager.of_add_service('n_calendar_column_service')
ln_datawindow_graphic_service_manager.of_add_service('n_reject_invalids')
ln_datawindow_graphic_service_manager.of_create_services()
end event

event itemchanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      itemchanged
// Overrides:  No
// Overview:   Validation and Dao messaging.
// Created by: Jake Pratt
// History:    06.02.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_type

		
if super::event itemchanged(row,dwo,data) = 2 then return 2

//----------------------------------------------------------------------------------------------------------------------------------
// This code connects the datawindow to the dao.
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(idao_transaction) then
	ls_type = this.Describe(this.getcolumnname()+".Coltype")
		idao_transaction.of_setitem(this.getrow(),this.getcolumnname(),this.gettext())
End IF
end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Simple setrow logic.
//-----------------------------------------------------------------------------------------------------------------------------------
if not row > 0 and rowcount() > 0 then row = 1
this.setrow(row)
end event

on u_reference_display_datawindow.create
call super::create
end on

on u_reference_display_datawindow.destroy
call super::destroy
end on

