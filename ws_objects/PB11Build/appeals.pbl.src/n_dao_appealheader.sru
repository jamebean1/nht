$PBExportHeader$n_dao_appealheader.sru
forward
global type n_dao_appealheader from n_dao_reference_data
end type
end forward

global type n_dao_appealheader from n_dao_reference_data
string dataobject = "d_data_appealheader"
string is_qualifier = "Product"
end type
global n_dao_appealheader n_dao_appealheader

type variables
string is_use_case_time
datetime	idt_case_time
end variables

forward prototypes
public function string of_validate ()
public subroutine of_check_issue_changes ()
public function string of_delete ()
public function string of_duplicate_issue (long al_id)
public function string of_getitem_original (long ll_row, string as_column)
public function string of_retrieve_duplicate (long al_value)
public function string of_save ()
public function string of_check_timer_setting ()
public function datetime of_get_caselog_time ()
end prototypes

public function string of_validate ();//n_dao ln_dao


if isnull(this.of_getitem(1,'appealtype')) or this.of_getitem(1,'appealtype') = ''then 
	in_message.event ue_notify_client('Validation','appealtype')
	return 'Please select a valid Appeal Type.'
end if

if isnull(this.of_getitem(1,'service_type_id')) or this.of_getitem(1,'service_type_id') = ''then 
	in_message.event ue_notify_client('Validation','service_type_id')
	return 'Please select a valid Service Type.'
end if

if isnull(this.of_getitem(1,'datetermid')) or this.of_getitem(1,'datetermid') = ''then 
	in_message.event ue_notify_client('Validation','datetermid')
	return 'Please select a valid Appeal Term.'
end if

//string ls_test
//ls_test = string(this.GetitemDateTime(1, 'duedate'))
//if isnull(this.of_getitem(1,'duedate')) or this.of_getitem(1,'duedate') = ''then 
//	in_message.event ue_notify_client('Validation','duedate')
//	return 'The Appeal due date failed to calculate. Please enter a valid due date.'
//end if


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
n_date_manipulator ln_date_manipulator
n_dao_appealheader ln_dao

ln_dao = Create n_dao_appealheader

ln_dao.of_settransobject(SQLCA)
ls_error = ln_dao.of_retrieve_duplicate(al_ID)

l_column_count = long(ln_dao.describe("datawindow.column.count"))

//Ensure we have a row in the DAO
if this.Rowcount() = 0 Then this.InsertRow(0)

//Start with column 2 since column 1 (ID) is an identity column it will be populated with a new key
For i = 2 to l_column_count
	string ls_string
	ls_string = "datawindow.Object." + string(i) + ".name"
	ls_string =  this.describe("#"+ string(i) +".name")
	
	If (ls_string <> 'status') or (ls_string <> 'versionfixed') or (ls_string <> 'versionscheduled') Then 
		//Get the data from the original issue
		ls_data =  string(ln_dao.of_getitem(1, ls_string))

		Choose Case ls_string
			Case 'resolution'
				this.setitem(1, ls_string, ls_data)
			Case 'customercommentary'
				this.setitem(1, ls_string, ls_data)
			Case 'description'
				ls_data = ln_dao.GetItemString(1, ls_string)
				ls_data = 'Duplicated From Issue #' + string(al_ID) + ' ~r~n' + ls_data
				this.setitem(1, ls_string, ls_data)
			Case 'loggedby'
				this.of_setitem(1, ls_string, gn_globals.is_username)
			Case 'intestbydatetime'
				//this.of_setitem(1, ls_string, ls_null)
			Case 'closedbydatetime'
				//this.of_setitem(1, ls_string, ls_null)	
			Case 'loggedbydatetime'
				this.of_setitem(1, ls_string, ln_date_manipulator.of_now())
			//Case 'orderid'
			//	this.of_setitem(1, ls_string, ln_dao.of_getitem(1, 'ID'))
			Case Else
				this.of_setitem(1, ls_string, ls_data)
		End Choose
	End If
Next



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

string s_return, ls_timer_setting
long l_old, ll_datetermID
n_dao ln_datastores[],ln_error
n_update_tools ln_tools
n_transaction_pool ln_transaction_pool
n_appealdetail_duedate	ln_duedate
datetime	ldt_headertime, ldt_duedate

//ln_duedate = Create n_appealdetail_duedate
//
//ll_datetermID = long(this.of_getitem(1,'datetermID'))
//ls_timer_setting = of_check_timer_setting()
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Check the system setting on what time the appeal due date calculations use.
//-----------------------------------------------------------------------------------------------------------------------------------
//If ls_timer_setting = 'Y' Then
//	ldt_headertime = of_get_caselog_time()
//Else
//	ldt_headertime	=	this.getitemdatetime(1, 'AppealCreatedDate')
//End If
//
//If IsNull(ldt_headertime) Then
//	ldt_headertime = gn_globals.in_date_manipulator.of_now()
//End If
//
//ldt_duedate = ln_duedate.of_get_due_date(ll_datetermID, ldt_headertime)
//
//this.setitem(1, 'duedate', ldt_duedate)		
//Destroy ln_duedate

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

public function string of_check_timer_setting ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function gets the value from System_Options for the New Appeal System.
//	Created by:	Joel White
//	History: 	9/2/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


string ls_use_case_time

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the value for the 'new appeal system' from the System_Options table
//-----------------------------------------------------------------------------------------------------------------------------------
SELECT option_value
  INTO :ls_use_case_time
  FROM cusfocus.system_options
 WHERE option_name = 'appeal timer'
 USING SQLCA;


//-----------------------------------------------------------------------------------------------------------------------------------
// Check the SQL Return 
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE SQLCA.SQLCode
	CASE -1
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Error happened, show a message box to show the user an error occurred.
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'Error retrieving new appeal system configuration.')
		Return 'N'
	CASE 0
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Good things happened.
		//-----------------------------------------------------------------------------------------------------------------------------------\
		Return ls_use_case_time
	CASE 100
		//-----------------------------------------------------------------------------------------------------------------------------------
		// No value was found for the 'new appeal system' record in the System_Options table
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'The configuration record for new appeal system was not found.')
		Return 'N'
End Choose
end function

public function datetime of_get_caselog_time ();long ll_casenumber
datetime ldt_start_time

If this.RowCount() > 0 Then 
	ll_casenumber = long(this.of_getitem(1, 'case_number'))
	
	If of_check_timer_setting() = 'Y' Then
	
	  SELECT cusfocus.case_log.case_log_opnd_date  
		 INTO :ldt_start_time  
		 FROM cusfocus.case_log  
		WHERE convert(int, cusfocus.case_log.case_number) = :ll_casenumber   
				  ;
	
	Else
		ldt_start_time = this.GetItemDateTime(1, 'appealcreateddate')
	End If
End If	

Return ldt_start_time

end function

on n_dao_appealheader.create
call super::create
end on

on n_dao_appealheader.destroy
call super::destroy
end on

event constructor;call super::constructor;n_transaction_pool ln_transaction_pool
transaction lt_transobject


ln_transaction_pool = Create n_transaction_pool

this.dataobject = 'd_data_appealheader'
is_qualifier = 'AppealHeader'

//of_add_child('ReleaseNotes','d_issuereleasenotes')

//it_transobject = ln_transaction_pool.of_gettransactionobject('Heat Database')
this.of_SetTransobject(SQLCA)


end event

