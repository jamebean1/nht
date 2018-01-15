$PBExportHeader$u_display_datawindow_reference.sru
forward
global type u_display_datawindow_reference from u_datawindow
end type
end forward

global type u_display_datawindow_reference from u_datawindow
integer width = 576
integer height = 420
borderstyle borderstyle = stylelowered!
event ue_retrieve ( )
event ue_refreshtheme ( )
event type long ue_getrow_dao ( long al_row )
event type long ue_getrow_display ( long al_dao_row )
end type
global u_display_datawindow_reference u_display_datawindow_reference

type variables
Protected:
	n_dao 							in_dao
	string 							is_critical_columnlist[]
end variables

forward prototypes
public subroutine of_lock_columns ()
protected function integer of_retrieve ()
public subroutine of_setdao (n_dao adao_object)
public subroutine of_unlock_columns ()
end prototypes

event ue_retrieve;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_retrieve
// Overrides:  No
// Overview:   This event is triggered by the developer to retrieve the data from a dao.
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Reset the datawindow
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

event ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   set the color to the currently select theme color.
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string ls_mod

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_tools ln_datawindow_tools
Datawindow ldw_this
ldw_this = This

//----------------------------------------------------------------------------------------------------------------------------------
// Return if the dataobject isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not  IsValid(This.Object) Then Return

//----------------------------------------------------------------------------------------------------------------------------------
// Set the background color to the current theme backcolor.
//-----------------------------------------------------------------------------------------------------------------------------------
//This.Object.Datawindow.Color = gn_globals.in_theme.of_get_backcolor()

//----------------------------------------------------------------------------------------------------------------------------------
// If there is an object called indicator then set it to show the barcolor when the row is selected.
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not This.Describe("indicator.Background.Color") = '!' Then
//	ls_mod = "indicator.Background.Color = '0~t" + "if(currentrow() = getrow()," + string(gn_globals.in_theme.of_get_barcolor()) + "," + string(gn_globals.in_theme.of_get_backcolor()) + ")'"
//	This.Modify(ls_mod)
//End If
//
//----------------------------------------------------------------------------------------------------------------------------------
// Set the expressions for the 
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_tools = Create n_datawindow_tools

//If ln_datawindow_tools.of_IsComputedField(ldw_this, 'backcolor') 	Then ln_datawindow_tools.of_set_expression(ldw_this, 'backcolor', String(gn_globals.in_theme.of_get_backcolor()))
//If ln_datawindow_tools.of_IsComputedField(ldw_this, 'barcolor') 	Then ln_datawindow_tools.of_set_expression(ldw_this, 'barcolor',  String(gn_globals.in_theme.of_get_barcolor()))
//
Destroy ln_datawindow_tools

end event

event ue_getrow_dao;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_getrow_dao
// Overrides:  No
// Overview:   This will return the row for the dao
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Return the row that was passed in
//-----------------------------------------------------------------------------------------------------------------------------------
return al_row
end event

event ue_getrow_display;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_getrow_display
// Overrides:  No
// Overview:   This will return the row for this datawindow
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Return the getrow()
//-----------------------------------------------------------------------------------------------------------------------------------
return this.getrow()
end event

public subroutine of_lock_columns ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_lock_columns()
// Arguments:	none
// Overview:	get a list of locked columns from teh dao and lock them down.
//	Created by:	Blake Doerr
//	History: 	9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
long 		li_i
string 	ls_critical,ls_mod
string 	ls_critical_columnlist[]

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions in_string

//----------------------------------------------------------------------------------------------------------------------------------
// Reset the instance array
//-----------------------------------------------------------------------------------------------------------------------------------
is_critical_columnlist = ls_critical_columnlist

//----------------------------------------------------------------------------------------------------------------------------------
// Get the list of locked columns
//-----------------------------------------------------------------------------------------------------------------------------------
ls_critical = in_dao.of_getitem(1,'LockedColumnList')

//----------------------------------------------------------------------------------------------------------------------------------
// Parse the string into arrays
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.of_parse_string(ls_critical, ',', is_critical_columnlist[])

//----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns and make them transparent and protected if they are on the locked column list
//-----------------------------------------------------------------------------------------------------------------------------------
For li_i = 1 to upperbound(is_critical_columnlist)
	ls_mod = is_critical_columnlist[li_i] + ".background.color=553648127"
	This.modify(ls_mod)		

	ls_mod = is_critical_columnlist[li_i] + ".protect=1"
	This.modify(ls_mod)		
Next




end subroutine

protected function integer of_retrieve ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_retrieve()
// Arguments:   none
// Overview:    retrieve data from DAO
//	Created by:	Blake Doerr
//	History: 	9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_count
Long		ll_column_count
String	ls_data
String	ls_column_array[]

//----------------------------------------------------------------------------------------------------------------------------------
// Get a list of the columns in the datawindow.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_column_count =  integer(this.Describe("DataWindow.Column.Count"))

For ll_count = 1 To ll_column_count
	ls_column_array[ll_count] = This.Describe( "#" + string(ll_count) + ".Name")
Next

//----------------------------------------------------------------------------------------------------------------------------------
// Now request the data from the dao passing it the column array.
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(in_dao) then
	ls_data = in_dao.of_getdata(ls_column_array)
end if

//----------------------------------------------------------------------------------------------------------------------------------
// The data that is returned is in the format that can be imported.
//-----------------------------------------------------------------------------------------------------------------------------------
this.importstring(ls_data)

//----------------------------------------------------------------------------------------------------------------------------------
// Return the rowcount
//-----------------------------------------------------------------------------------------------------------------------------------
return this.rowcount()
end function

public subroutine of_setdao (n_dao adao_object);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_setdao
// Overrides:  No
// Overview:   Set the dao that the dw will use into the transaction variable
//	Created by:	Blake Doerr
//	History: 	9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

in_dao = adao_object
in_dao.of_getmessageobject().of_setclientobject(this)
end subroutine

public subroutine of_unlock_columns ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_unlock_columns()
// Arguments:   none
// Overview:    Unlock all critical columns
//	Created by:	Blake Doerr
//	History: 	9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
long 		li_i
string 	ls_mod

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the columns in the critical column list and unlock then
//-----------------------------------------------------------------------------------------------------------------------------------
for li_i = 1 to upperbound(is_critical_columnlist)
	
	ls_mod = is_critical_columnlist[li_i] + ".background.color=16777215"
	this.modify(ls_mod)		

	ls_mod = is_critical_columnlist[li_i] + ".protect=0"
	this.modify(ls_mod)		

Next


end subroutine

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      constructor
// Overrides:  No
// Overview:   Initialize the themes/autofill/caching objects.
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

//----------------------------------------------------------------------------------------------------------------------------------
// Trigger the ue_refreshtheme and set the transaction object
//-----------------------------------------------------------------------------------------------------------------------------------
this.triggerevent('ue_refreshtheme')
this.settransobject(SQLCA)

//----------------------------------------------------------------------------------------------------------------------------------
// These initialize the various services that are needed on most datawindows.
//-----------------------------------------------------------------------------------------------------------------------------------
ln_datawindow_graphic_service_manager = This.of_get_service_manager()
ln_datawindow_graphic_service_manager.of_add_service('n_dropdowndatawindow_caching_service')
ln_datawindow_graphic_service_manager.of_add_service('n_autofill')
ln_datawindow_graphic_service_manager.of_add_service('n_keydown_date_defaults')
ln_datawindow_graphic_service_manager.of_add_service('n_calendar_column_service')
ln_datawindow_graphic_service_manager.of_add_service('n_reject_invalids')
ln_datawindow_graphic_service_manager.of_create_services()
end event

event itemerror;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ItemError
// Overrides:  No
// Overview:   this is to avoid itemchanged validation from poping up a messagebocx.
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// this is to avoid itemchanged validation from poping up a messagebocx.
//-----------------------------------------------------------------------------------------------------------------------------------
return 2
end event

event itemchanged;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      itemchanged
// Overrides:  No
// Overview:   Validation and Dao messaging.
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_type
Long		ll_currow
Long		ll_return

//----------------------------------------------------------------------------------------------------------------------------------
// Call the ancestor version of this function
//-----------------------------------------------------------------------------------------------------------------------------------
ll_return = super::event itemchanged(row,dwo,data)

//----------------------------------------------------------------------------------------------------------------------------------
// If the return value is not 0 then Return it
//-----------------------------------------------------------------------------------------------------------------------------------
if ll_return <> 0 then return ll_return

//----------------------------------------------------------------------------------------------------------------------------------
// This code connects the datawindow to the dao.
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(in_dao) then
	//----------------------------------------------------------------------------------------------------------------------------------
	// Get the column type of the current column
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_type = this.Describe(this.getcolumnname() + ".Coltype")
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Get the current row from the dao
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_currow = this.event ue_getrow_dao(this.getrow())
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// Set the value into the dao, using this columnname and value
	//-----------------------------------------------------------------------------------------------------------------------------------
	if NOT in_dao.of_setitem(ll_currow,this.getcolumnname(),this.gettext()) then
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Reject the data and allow the focus to change
		//-----------------------------------------------------------------------------------------------------------------------------------
		return 2
	end if
End IF
end event

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   This is the code for the clicked event
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Simple setrow logic.
//-----------------------------------------------------------------------------------------------------------------------------------
If Not row > 0 and rowcount() > 0 then row = 1
this.setrow(row)
end event

event rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      rbuttondown
// Overrides:  No
// Overview:   Trigger the event to show the menu.
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
string	ls_objectatpointer

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
u_dynamic_gui lu_gui
m_dynamic lm_menu

//----------------------------------------------------------------------------------------------------------------------------------
// If the parent object is not a window then, trigger the ue_showmenu
//-----------------------------------------------------------------------------------------------------------------------------------
if parent.typeof() <> window! then
	lu_gui = parent
	lu_gui.triggerevent('ue_showmenu')
end if 


end event

event losefocus;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      LoseFocus
// Overrides:  No
// Overview:   Manage the accepttext()
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// This ensures tha the accepttext is triggered before the user clicks save or goes to another dw.
//-----------------------------------------------------------------------------------------------------------------------------------
this.accepttext()
end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Overview:   This code keeps the dw in sync with the dao by watching for the column change 
//	Created by: Blake Doerr
//	History:    9/25/2000 - First Created 
//	04/08/2003	HMD	For case columnchange for a date, if the string is '', set the date to null so it doesn't set 01-01-1900
//-----------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Decimal 		ld_data
Datetime 	ldt_data
Long			ll_dao_row
String 		ls_type
String		ls_data
String		ls_column
String		ls_string[]

//----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions	ln_string

//----------------------------------------------------------------------------------------------------------------------------------
// Case statements for all messages
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(as_message)
		
	//----------------------------------------------------------------------------------------------------------------------------------
	// Re-retreive the header with the new status
	//-----------------------------------------------------------------------------------------------------------------------------------
	case 'columnchange'
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Parse out all the column changes that occured
		//-----------------------------------------------------------------------------------------------------------------------------------
		gn_globals.in_string_functions.of_parse_string( string(aany_argument), '||', ls_string[])

		//----------------------------------------------------------------------------------------------------------------------------------
		// The row will be the first argument, the column will be the second and the data will be the third
		//-----------------------------------------------------------------------------------------------------------------------------------
		ll_dao_row = long(ls_string[1])
		ls_column = lower(ls_string[2])
		ls_data = ls_string[3]

		//----------------------------------------------------------------------------------------------------------------------------------
		// If it is the current row and column then just return because the change was caused by this column
		//-----------------------------------------------------------------------------------------------------------------------------------
		If ls_column = lower(this.GetColumnName()) and GetFocus() = this Then Return
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Get the column type of the column
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_type = this.Describe(ls_column+".Coltype")
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Process the change based on the column type
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case lower(left(ls_type,4))
			Case 'numb','long','deci'
				ld_data = dec(ls_data)
		
				if ls_data = '' or isnull(ls_data) then 
					setnull(ld_data)
				End If

				this.setitem(this.event ue_getrow_display(ll_dao_row),string(ls_column),ld_data)
		
			Case 'date'
				If ls_data = '' Then
					SetNull(ldt_data)
				Else
					ldt_data = gn_globals.in_string_functions.of_convert_string_to_datetime( string( ls_data))
				End If
				this.setitem(this.event ue_getrow_display(ll_dao_row),string(ls_column),ldt_data)

			Case 'char'
				this.setitem(this.event ue_getrow_display(ll_dao_row),string(ls_column),ls_data)
		End Choose
		
End Choose
end event

on u_display_datawindow_reference.create
call super::create
end on

on u_display_datawindow_reference.destroy
call super::destroy
end on

