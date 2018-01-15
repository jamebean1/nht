$PBExportHeader$n_dao_appealdetailnotes.sru
forward
global type n_dao_appealdetailnotes from n_dao_reference_data
end type
end forward

global type n_dao_appealdetailnotes from n_dao_reference_data
string dataobject = "d_data_appealdetailnote"
string is_qualifier = "AppealDetailNote"
end type
global n_dao_appealdetailnotes n_dao_appealdetailnotes

type variables

end variables

forward prototypes
public function string of_validate ()
public subroutine of_check_issue_changes ()
public function string of_delete ()
public function string of_duplicate_issue (long al_id)
public function string of_getitem_original (long ll_row, string as_column)
public function string of_retrieve_duplicate (long al_value)
public function string of_save ()
public function boolean of_setitem (long al_row, string as_column, any as_data)
public function string of_getitem (long ll_row, string as_column)
end prototypes

public function string of_validate ();//n_dao ln_dao


//if isnull(this.getitemstring(1,'employeename')) or this.getitemstring(1,'employeename') = ''then 
//	in_message.event ue_notify_client('Validation','employeename')
//	return 'Please select a valid employee'
//end if
//
//if isnull(this.getitemstring(1,'customer_name')) or this.getitemstring(1,'customer_name') = '' then 
//	in_message.event ue_notify_client('Validation','customer_name')
//	return 'Please select a valid customer.'
//end if
//
//if isnull(this.getitemstring(1,'module')) or this.getitemstring(1,'module') = '' then 
//	in_message.event ue_notify_client('Validation','module')
//	return 'Please select a valid module.'
//end if
//
//if isnull(this.getitemstring(1,'calltype')) or this.getitemstring(1,'calltype') = '' then 
//	in_message.event ue_notify_client('Validation','calltype')
//	return 'Please select a valid issue type.'
//end if
//
//if isnull(this.getitemstring(1,'versionfound')) or this.getitemstring(1,'versionfound') = '' then 
//	in_message.event ue_notify_client('Validation','versionfound')
//	return 'Please select a valid version found.'
//end if
//
//if isnull(this.getitemstring(1,'assignee')) or this.getitemstring(1,'assignee') = '' then 
//	in_message.event ue_notify_client('Validation','assignee')
//	return 'Please select a valid assignee.'
//end if
//
//
//if isnull(this.getitemstring(1,'description')) or this.getitemstring(1,'description') = '' then 
//	in_message.event ue_notify_client('Validation','description')
//	return 'Please provide a valid description.'
//end if
//
//If lower(this.getitemstring(1, 'calltype')) = 'engineering' Then
//	if (lower(this.getitemstring(1,'status')) = 'closed' or lower(this.getitemstring(1,'status')) = 'in test') Then 
//		If this.getitemstring(1,'versionfixed') = '' or IsNull(this.getitemstring(1,'versionfixed')) then 
//			in_message.event ue_notify_client('Validation','versionfixed')
//			return 'When an issue is marked In Test or Closed, a version fixed must be selected.'
//		End If
//	end if
//	
//	if (lower(this.getitemstring(1,'status')) = 'closed' or lower(this.getitemstring(1,'status')) = 'in test') Then
//		If this.getitemstring(1,'releasenotes') = '' or IsNull(this.getitemstring(1,'releasenotes')) then 
//			in_message.event ue_notify_client('Validation','releasenotes')
//			return 'When an issue is marked In Test or Closed, a value must be selected for release notes.'
//		End If
//	end if
//End If
//
//If lower(this.getitemstring(1, 'calltype')) = 'support' Then
//	if (lower(this.getitemstring(1,'status')) = 'closed' or lower(this.getitemstring(1,'status')) = 'in test') Then 
//		If this.getitemnumber(1,'eventtype') = 14 or IsNull(this.getitemnumber(1,'eventtype')) then 
//			in_message.event ue_notify_client('Validation','eventtype')
//			return 'When a support issue is marked In Test or Closed, an event type must be selected.'
//		End If
//	end if
//End If

return ''

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

public function string of_delete ();long ll_appealdetailID

ll_appealdetailID = long(this.of_getitem(1, 'appealdetailid'))


  UPDATE cusfocus.AppealDetail  
     SET HasNote = 'N'  
   WHERE cusfocus.AppealDetail.AppealDetailID = :ll_appealdetailID   
           ;


return super::of_delete()
end function

public function string of_duplicate_issue (long al_id);long i, ll_count, l_column_count
string ls_error, ls_column_name
string ls_return, ls_data, ls_null

////n_string_functions ln_string_functions
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
//


Return ls_error
end function

public function string of_getitem_original (long ll_row, string as_column);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_getitem()
// Arguments:   none
// Overview:    Do a getitem and if it is not found try the virtual column list.
// Created by:  Joel White
// History:     09.04.05 - First Created 
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
long l_old
n_dao ln_datastores[],ln_error
n_update_tools ln_tools
n_transaction_pool ln_transaction_pool


//-----------------------------------------------------------------------------------------------------------------------------------
// Set the modified date and find out if the in test and closed by 
//-----------------------------------------------------------------------------------------------------------------------------------
this.of_setitem(1, 'ModifiedByDateTime', gn_globals.in_date_manipulator.of_now())
this.of_setitem(1, 'ModifiedBy', gn_globals.is_login)

If this.of_getitem(1, 'textnote') = '' or IsNull(this.of_getitem(1, 'textnote')) Then
	this.of_delete()
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




if this.getitemstatus(1,0,Primary!) = NewModified! Then
	in_checkout.of_add_tableid(is_qualifier,this.getitemnumber(1,1))
	in_checkout.of_checkout( gn_globals.il_userid) 
end if



of_resetupdate()




destroy ln_tools
Destroy ln_transaction_pool



return ''
end function

public function boolean of_setitem (long al_row, string as_column, any as_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_setitem()
// Arguments:   al_row - row
//					 as_column -  columnname to set the value into.
//					 as_data -  data to be set	into the column
// Overview:    DocumentScriptFunctionality
// Created by:  Jake Pratt
// History:     12/1/98 - First Created 
//	05/21/2001	HMD	18997	Add a case for date columns with variable = null
//-----------------------------------------------------------------------------------------------------------------------------------

decimal ld_data
datetime ldt_data
string ls_type
string	ls_data


ia_newvalue = as_data
is_currentcolumn = as_column

ls_type = this.Describe(as_column+".Coltype")


if isnull(al_row) or al_row = 0 or al_row > rowcount()  or rowcount() = 0 then return false

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','long','deci'
	
		// Added by jake to handle null numbers comming over as an empty string.
		ld_data = dec(as_data)

		IF Classname(as_data) = 'string' then 
			if as_data = '' then 
				setnull(ld_data)
			End If
		end if
		
		ia_oldvalue = this.getitemnumber(al_row,as_column)
		this.setitem(al_row,as_column,ld_data)

		
	Case 'date'
		
		choose case lower(classname( as_data))
			case 'string'
				ldt_data = gn_globals.in_string_functions.of_convert_string_to_datetime( string( as_data))
			case 'date'
				ldt_data = datetime(as_data)
			case 'datetime'
				ldt_data = as_data
			//-----------------------------------------------------------------------------------------------------------------------------------
			// BEGIN ADDED HMD 05/21/2001 18997 - When passing in a null datetime, the classname was getting 'null'
			// so the column was getting set to the the variable default of '1900-01-01' instead of null
			//-----------------------------------------------------------------------------------------------------------------------------------
			case else
				SetNull(ldt_data)
			//-----------------------------------------------------------------------------------------------------------------------------------
			// END ADDED HMD 05/21/2001 18997
			//-----------------------------------------------------------------------------------------------------------------------------------

		end choose

		ia_oldvalue = this.getitemdatetime(al_row,as_column)
		this.setitem(al_row,as_column,ldt_data)


	Case 'char'
		
		ls_data = string( as_data)

		//----------------------------------------------------------------------------------------------------------------------------------
		// This is because the setitem function replaces the carriages returns with the literal ~r~n
		//-----------------------------------------------------------------------------------------------------------------------------------
		if pos(ls_data,'~r~n') > 0 then 
			gn_globals.in_string_functions.of_replace_all(ls_data,'~r~n','~~r~~n')
		end if 



		ia_oldvalue = this.getitemstring(al_row,as_column)
		this.setitem(al_row,as_column,ls_data)


	Case Else

		
		if not this.event ue_setitem(al_row,lower(as_column),as_data) then return false
		
End Choose


//----------------------------------------------------------------------------------------------------------------------------------
// This is an event fur use in writing itemchanged code on the dao instead of on the client.
//-----------------------------------------------------------------------------------------------------------------------------------
if not this.event ue_setitemvalidate(al_row,lower(as_column),as_data) then return false

		
		
if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message(lower(as_column),as_data,this)
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is a valid message object, notify it that a column has changed and pass it the
//	row number and column name
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(in_message) then
//	in_message.event ue_notify_client('ColumnChange',lower(as_column))
	ls_data = string(as_data)
	if isnull(ls_data) then ls_data = ''
	in_message.event ue_notify_client('ColumnChange',string(al_row) + '||' + lower(as_column) + '||' + string(ls_data))
end if

ia_newvalue = gn_globals.il_nullnumber
ia_oldvalue =  gn_globals.il_nullnumber
is_currentcolumn = ''



return true
end function

public function string of_getitem (long ll_row, string as_column);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_getitem()
// Arguments:   none
// Overview:    Do a getitem and if it is not found try the virtual column list.
// Created by:  Joel White
// History:     09.04.05 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_type,ls_value
ls_type = this.Describe(as_column+".Coltype")
		

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','deci','long'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = string(this.getitemnumber(ll_row,as_column))

	Case 'date'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = string(this.getitemdatetime(ll_row,as_column),'yyyy-mm-dd hh:mm:ss') 

	Case 'char'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = this.getitemstring(ll_row,as_column) 

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

on n_dao_appealdetailnotes.create
call super::create
end on

on n_dao_appealdetailnotes.destroy
call super::destroy
end on

event constructor;call super::constructor;n_transaction_pool ln_transaction_pool
transaction lt_transobject


ln_transaction_pool = Create n_transaction_pool

this.dataobject = 'd_data_appealdetailnote'
is_qualifier = 'AppealDetailNote'

//of_add_child('ReleaseNotes','d_issuereleasenotes')

//it_transobject = ln_transaction_pool.of_gettransactionobject('Heat Database')
this.of_SetTransobject(SQLCA)

end event

