$PBExportHeader$n_dao_appealproperties.sru
forward
global type n_dao_appealproperties from n_dao_reference_data
end type
end forward

global type n_dao_appealproperties from n_dao_reference_data
string dataobject = "d_data_appeal_properties"
string is_qualifier = "AppealProperties"
end type
global n_dao_appealproperties n_dao_appealproperties

type variables
boolean ib_appeal_locked = FALSE

string	is_reqd_eventID[]
long		il_appealdetailID[]
string	is_required_columns[]
string	is_locked_columns[]

w_appeal w_parent
end variables

forward prototypes
public function string of_validate ()
public subroutine of_check_issue_changes ()
public function string of_delete ()
public function string of_duplicate_issue (long al_id)
public function string of_getitem_original (long ll_row, string as_column)
public function string of_retrieve_duplicate (long al_value)
public function string of_save ()
public function long of_new_with_return ()
public subroutine of_delete_appealprop (long al_appealdetailid)
public subroutine of_set_required (long al_appealeventid, string as_column_name, long al_appealdetailid)
public function string of_get_all_columns ()
public function string of_checkrequiredproperties ()
end prototypes

public function string of_validate ();long i, ii, ll_source_type, ll_row
string	s_string, ls_reqd_events, ls_column_name
String	ls_find_string, ls_value, ls_return

For i = 1 to this.RowCount()
	If IsNull(string(this.getitemnumber(i,'source_type'))) Or string(this.getitemnumber(i, 'source_type')) = ''  Then 
		in_message.event ue_notify_client('Validation','appealeventid')
		return 'Please select a valid appeal event for each line item.'
	End If
	
	
	
	
Next

ls_return = of_checkrequiredproperties()



//For	ii = 1 to UpperBound(is_reqd_eventID)
//	ls_column_name = is_required_columns[ii]
//
//	ls_find_string = ' source_type = ' + is_reqd_eventID[ii]
//	ll_row = this.Find(ls_find_string, 1, this.RowCount())
//
//	If ll_row > 0 Then
//		ls_value = this.getitemstring(ll_row,ls_column_name)
//		
//		If IsNull(ls_value) Or ls_value = ''  Then 
//			in_message.event ue_notify_client('Validation','appealproperty')
//			return 'There are required appeal properties that do not have values.'
//		End If
//	End If
//Next

return ls_return

end function

public subroutine of_check_issue_changes ();long l_column_count, i, ll_subscription_count, ll_row, ll_issueID, ll_employeeid, il_unreadissueID
string ls_subscription_value, ls_column_name
string ls_string, ls_column_type, ls_original_value
datastore lds_datastore


//-----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore that has all the Issue Subscriptions in it.
//-----------------------------------------------------------------------------------------------------------------------------------
lds_datastore = Create Datastore
lds_datastore.DataObject = 'd_data_issuesubscription'
lds_datastore.SetTransObject(SQLCA)
lds_datastore.Retrieve()
ll_subscription_count = lds_datastore.Rowcount()


l_column_count = long(this.describe("datawindow.column.count"))

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop Through the columns on the DAO to find out what columns are new/modified
//-----------------------------------------------------------------------------------------------------------------------------------
for i = 1 to l_column_count
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Grab the column name and get the value the column is changing to
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_column_name = lower(this.describe("#"+ string(i) +".name"))
		ls_subscription_value = lower(this.of_getitem(1, ls_column_name))
		ls_original_value = lower(this.of_getitem_original(1, ls_column_name))

		//-----------------------------------------------------------------------------------------------------------------------------------
		// Try to find a row in the Issue Subscription datastore that has the right Qualifier (Column) and Value
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_string = 'subscriptionqualifier = "' + ls_column_name + '"' + 'and (compute_subvalue = "' + lower(ls_subscription_value) + '"' + 'or compute_subvalue = "' + lower(ls_original_value) + '")'
		ll_row = lds_datastore.Find(ls_string, 1, ll_subscription_count)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If a Issue Subscription row is found, then insert a record into the UnreadIssue table
		//-----------------------------------------------------------------------------------------------------------------------------------
		If  ll_row > 0  Then
			Do While ll_row > 0
				ll_issueID = This.GetItemNumber(1, 'ID')
				ll_employeeid  = lds_datastore.GetItemNumber(ll_row, 'employeeid')
				
			  SELECT UnreadIssue.UnreadIssueID  
				INTO :il_unreadissueID  
				FROM UnreadIssue  
				WHERE ( UnreadIssue.IssueID = :ll_issueID ) AND  
						( UnreadIssue.EmployeeID = :ll_employeeid )   
				Using SQLCA;
	
				If il_unreadissueID <= 0 Then	
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Check the status to see if this is a New record or a Modified record and insert the flag accordingly
					//-----------------------------------------------------------------------------------------------------------------------------------
					If this.GetItemStatus(1, i, Primary!) = NewModified! Then
						
						  INSERT INTO UnreadIssue  
								( EmployeeID,   
								  IssueID,   
								  Status )  
						  VALUES ( 
								  :ll_employeeid,   
								  :ll_issueID,      
								  'N' )  
								  Using SQLCA;
					Else
								INSERT INTO UnreadIssue  
								( EmployeeID,   
								  IssueID,   
								  Status )  
						  VALUES ( 
								  :ll_employeeid,   
								  :ll_issueID,      
								  'U' )  
								  Using SQLCA;
					End If 
				End If
				
				long ll_start
				ll_start = ll_row + 1
				ll_row = lds_datastore.Find(ls_string, ll_start, ll_subscription_count + 1)
			Loop
		End If
next



Destroy lds_datastore



end subroutine

public function string of_delete ();long l_id,l_count
string s_useradded

s_useradded = this.getitemstring(1,'useradded')

If s_useradded <> 'Y' Then
	Return 'You may not delete this item because it is a system module'
end if

l_id = this.getitemnumber(1,'mdleid')

Select count(*)
Into :l_count
from Module a 
Where Mdleid = :l_id 
and exists (Select 'x' from Module Where  MdleParentMdleID = :l_id);

if l_count > 0 then 
	return 'You may not delete because this Module contains SubModules'
end if

return super::of_delete()
end function

public function string of_duplicate_issue (long al_id);long i, ll_count, l_column_count
string ls_error, ls_column_name
string ls_return, ls_data, ls_null

//n_string_functions ln_string_functions
//n_date_manipulator ln_date_manipulator
//n_dao_issue ln_dao
//
//ln_dao = Create n_dao_issue
//
//ln_dao.of_settransobject(SQLCA)
//ls_error = ln_dao.of_retrieve_duplicate(al_ID)
//
//l_column_count = long(ln_dao.describe("datawindow.column.count"))
//
////Ensure we have a row in the DAO
//if this.Rowcount() = 0 Then this.InsertRow(0)
//
////Start with column 2 since column 1 (ID) is an identity column it will be populated with a new key
//For i = 2 to l_column_count
//	string ls_string
//	ls_string = "datawindow.Object." + string(i) + ".name"
//	ls_string =  this.describe("#"+ string(i) +".name")
//	
//	If (ls_string <> 'status') or (ls_string <> 'versionfixed') or (ls_string <> 'versionscheduled') Then 
//		//Get the data from the original issue
//		ls_data =  string(ln_dao.of_getitem(1, ls_string))
//
//		Choose Case ls_string
//			Case 'resolution'
//				this.setitem(1, ls_string, ls_data)
//			Case 'customercommentary'
//				this.setitem(1, ls_string, ls_data)
//			Case 'description'
//				ls_data = ln_dao.GetItemString(1, ls_string)
//				ls_data = 'Duplicated From Issue #' + string(al_ID) + ' ~r~n' + ls_data
//				this.setitem(1, ls_string, ls_data)
//			Case 'loggedby'
//				this.of_setitem(1, ls_string, gn_globals.is_username)
//			Case 'intestbydatetime'
//				//this.of_setitem(1, ls_string, ls_null)
//			Case 'closedbydatetime'
//				//this.of_setitem(1, ls_string, ls_null)	
//			Case 'loggedbydatetime'
//				this.of_setitem(1, ls_string, ln_date_manipulator.of_now())
//			//Case 'orderid'
//			//	this.of_setitem(1, ls_string, ln_dao.of_getitem(1, 'ID'))
//			Case Else
//				this.of_setitem(1, ls_string, ls_data)
//		End Choose
//	End If
//Next



Return ls_error
end function

public function string of_getitem_original (long ll_row, string as_column);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_getitem()
// Arguments:   none
// Overview:    Do a getitem and if it is not found try the virtual column list.
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_type,ls_value
ls_type = this.Describe(as_column+".Coltype")
		

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','deci','long'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = string(this.getitemnumber(ll_row,as_column, Primary!, True))

	Case 'date'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = string(this.getitemdatetime(ll_row,as_column, Primary!, True),'yyyy-mm-dd hh:mm:ss') 

	Case 'char'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = this.getitemstring(ll_row,as_column, Primary!, True) 

		//----------------------------------------------------------------------------------------------------------------------------------
		// This is because the setitem function replaces the carriages returns with the literal ~r~n
		//-----------------------------------------------------------------------------------------------------------------------------------
		if pos(ls_value,'~~r~~n') > 0 then 
			gn_globals.in_string_functions.of_replace_all(ls_value,'~~r~~n','~r~n')
		end if 

	Case Else
		ls_value = this.event ue_getitem(ll_row,as_column)


End Choose

if isnull(ls_value) then ls_value = ''


return ls_value
end function

public function string of_retrieve_duplicate (long al_value);long i_i

in_update_array[1].retrieve(al_value)
in_update_array[2].retrieve(al_value,is_qualifier)
in_update_array[3].retrieve(al_value,is_qualifier)

for i_i = 4 to upperbound(in_update_array) 
	
	in_update_array[i_i].retrieve(al_value)

next



in_checkout.of_add_tableid(is_qualifier,al_value)
//if in_checkout.of_checkout( gn_globals.il_userid) = false then 
//	ib_readonly = true
//	return in_checkout.of_get_messagestring()
//else
//	return ''
//end if 

return ''


end function

public function string of_save ();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_save
//	Arguments:	none
//	Overview:   Save and Validate all dao's
//	Created by: Joel white
//	History:    8/2/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string s_return
long l_old, i
n_dao ln_datastores[],ln_error
n_update_tools ln_tools
n_transaction_pool ln_transaction_pool
datetime ldt_now

ldt_now = gn_globals.in_date_manipulator.of_now()

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the modified date
//-----------------------------------------------------------------------------------------------------------------------------------
this.SetFilter('')
this.Filter()

If of_changed() Then 
	For i = 1 to this.RowCount()
		If this.GetItemStatus(i, 0, Primary!) <> NotModified!  Then 
			this.of_setitem(i, 'updated_timestamp', ldt_now)
			this.of_setitem(i, 'updated_by', gn_globals.is_login)
		End If
	Next
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the transaction and prepare the update array
//-----------------------------------------------------------------------------------------------------------------------------------
ln_transaction_pool = Create n_transaction_pool

If ib_readonly then return 'This item is read-only and may not be saved'
	
if this.rowcount() <> 0 then 
	
	s_return = of_validate()
	if s_return <> '' then 
		return s_return
	end if 
	
//	s_return = of_setkey()
//	if s_return <> '' then 
//		return s_return
//	end if 
//	
end if


ln_datastores = in_update_array


ln_tools  = create n_update_tools
ln_tools.of_settransobject(SQLCA)

//Call the function to see what has changed and insert unread issue records
this.of_check_issue_changes()

ln_tools.of_begin_transaction()

//ln_error = ln_tools.of_manage_update(ln_datastores)
ln_error = ln_tools.of_manage_update(ln_datastores)
if isvalid(ln_error) then 
	ln_tools.of_rollback_transaction()
	destroy ln_tools
	return ln_error.is_error
end if

if not of_transaction() then 
	ln_tools.of_rollback_transaction()
	destroy ln_tools
	return this.is_error		
end if


ln_tools.of_commit_transaction()




//if this.getitemstatus(1,0,Primary!) = NewModified! Then
//	in_checkout.of_add_tableid(is_qualifier,this.getitemnumber(1,1))
//	in_checkout.of_checkout( gn_globals.il_userid) 
//end if



of_resetupdate()




destroy ln_tools
Destroy ln_transaction_pool



return ''
end function

public function long of_new_with_return ();return this.insertrow(0)

end function

public subroutine of_delete_appealprop (long al_appealdetailid);long	ll_row

ll_row = this.find('appealdetailID = ' + string(al_appealdetailid), 1, this.Rowcount())

If ll_row > 0 and ll_row <= this.Rowcount() Then
	this.DeleteRow(ll_row)
End If
end subroutine

public subroutine of_set_required (long al_appealeventid, string as_column_name, long al_appealdetailid);//long	ll_upperbound, i
//boolean ib_set = FALSE
//
//For i = 1 to UpperBound(is_reqd_eventID)
//	If il_appealdetailID[i] = al_appealdetailid Then
//		is_required_columns[i] = ''
////		is_reqd_eventID[i] = 
//		
//	End If
//Next
//
//For i = 1 to Upperbound(is_reqd_eventID)
//	If al_appealdetailid = il_appealdetailID[i] Then
//		is_reqd_eventID[i] = string(al_appealeventid)
//		is_required_columns[i] = as_column_name
//	End If
//Next
//
//
//For i = 1 to UpperBound(is_reqd_eventID)
//	If string(al_appealeventid) = is_reqd_eventID[i] Then
//		If as_column_name <> is_required_columns[i] Then
//			ib_set = TRUE
//		End If
//	End If
//Next
//
//
//If ib_set = TRUE or UpperBound(is_reqd_eventID) = 0 Then
//	ll_upperbound = UpperBound(is_reqd_eventID)
//	
//	is_reqd_eventID[ll_upperbound + 1] 		= 	string(al_appealeventid)
//	is_required_columns[ll_upperbound + 1]	=	as_column_name
//End If
end subroutine

public function string of_get_all_columns ();string 	ls_column_list
string 	ls_column_array[]
long		i

ls_column_list = this.of_getcolumnlist()

//gn_globals.in_string_functions.of_parse_string(ls_column_list, ',', ls_column_array[])
//
//For i = 1 to UpperBound(ls_column_array)
//	this.is_locked_columns[i] = ls_column_array[i]
//Next

Return ls_column_list
end function

public function string of_checkrequiredproperties ();/*****************************************************************************************
   Function:   of_CheckRequiredProperties
   Purpose:    Report an error if required appeal properties are not filled in.
   Parameters: NONE
   Returns:     0 - All required fields are filled.
					-1 - A required field was not filled.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/25/03 M. Caruso    Created.
*****************************************************************************************/
INTEGER	l_nColCount, l_nIndex, l_nOriginalCol
STRING	l_cFieldText, l_ErrorStrings[], l_cFieldName, l_cColName, ls_return
U_Datawindow	l_dwProperties

l_dwProperties = w_parent.dw_appeal_properties

// make sure all values are set.
l_dwProperties.AcceptText()

// default to ''
ls_return = ''

// get the current column in the datawindow
l_nOriginalCol = l_dwProperties.GetColumn()
l_nColCount = INTEGER (l_dwProperties.Object.DataWindow.Column.Count)
FOR l_nIndex = 1 TO l_nColCount
	IF l_dwProperties.Describe ('#' + STRING (l_nIndex) + '.Edit.Required') = 'yes' OR l_dwProperties.Describe ('#' + STRING (l_nIndex) + '.dddw.required') = 'yes' THEN
		IF l_dwProperties.Describe ('#' + STRING (l_nIndex) + '.Protect') = '0' THEN // If it is protected, the user can't change it anyhow
			l_dwProperties.SetColumn (l_nIndex)
			l_cFieldText = l_dwProperties.GetText()
			IF Len(l_cFieldText) = 0 OR IsNull (l_cFieldText) THEN
				
				l_cColName = l_dwProperties.GetColumnName()
				l_cFieldName = l_dwProperties.Describe (l_cColName + '_t.Text')
				// report the error on this field
//				MessageBox(FWCA.MGR.i_ApplicationName, l_cFieldName + ' is a required field.')
				
				// set the return value and exit this loop
				ls_return = l_cFieldName + ' is a required field.'
				EXIT
			END IF
		END IF
	END IF
	
NEXT

// restore focus to the originially selected column
l_dwProperties.SetColumn (l_nOriginalCol)

RETURN ls_return

end function

on n_dao_appealproperties.create
call super::create
end on

on n_dao_appealproperties.destroy
call super::destroy
end on

event constructor;call super::constructor;n_transaction_pool ln_transaction_pool
transaction lt_transobject


ln_transaction_pool = Create n_transaction_pool

this.dataobject = 'd_data_appeal_properties'
is_qualifier = 'AppealProperties'

//of_add_child('ReleaseNotes','d_issuereleasenotes')

//it_transobject = ln_transaction_pool.of_gettransactionobject('Heat Database')
this.of_SetTransobject(SQLCA)


end event

event itemchanged;call super::itemchanged;String ls_null

SetNull(ls_null)

If data = '(None)' Then
	this.of_setitem(row, 'appealpropertiesvalues_value', ls_null)
End If
end event

