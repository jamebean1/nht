$PBExportHeader$n_dao_appealdetail.sru
forward
global type n_dao_appealdetail from n_dao_reference_data
end type
end forward

global type n_dao_appealdetail from n_dao_reference_data
string dataobject = "d_data_appealdetail"
string is_qualifier = "appealdetail"
end type
global n_dao_appealdetail n_dao_appealdetail

type variables
string 	is_case_number
string 	is_casetype

end variables

forward prototypes
public function string of_validate ()
public function string of_delete ()
public function string of_duplicate_issue (long al_id)
public function string of_getitem_original (long ll_row, string as_column)
public function string of_retrieve_duplicate (long al_value)
public function string of_save ()
public subroutine of_log_appealdetail_changes (datetime adt_now)
public function string of_retrieve (long al_value)
public function long of_new_appealdetail (long al_appealheaderid)
public function string of_get_key_value (string table_name)
public subroutine of_delete_appealdetail (long al_appealdetailid)
public function integer of_insert_reminder (long al_appealdetailid, datetime adt_duedate, string as_reminder_desc)
public function long of_delete_reminder (long al_reminderid)
public subroutine of_delete_all ()
public subroutine of_calculate_duedates (datetime adt_startdatetime)
public subroutine of_set_case_information (string as_casenumber)
end prototypes

public function string of_validate ();long i, ll_rowcount, ll_detailorder[], ii, ll_current_order


ll_rowcount = this.RowCount()

For i = 1 to ll_rowcount 
	if isnull(this.of_getitem(i,'appealeventid')) or this.of_getitem(i,'appealeventid') = ''then 
		in_message.event ue_notify_client('Validation','appealeventid')
		return 'Please select a valid Appeal Event.'
	end if
	
	if isnull(this.of_getitem(i,'datetermid')) or this.of_getitem(i,'datetermid') = ''then 
		in_message.event ue_notify_client('Validation','datetermid')
		return 'Please select a valid Date Rule.'
	end if
	
	ll_current_order = long(this.of_getitem(i, 'detailorder'))
	
	For ii = 1 to UpperBound(ll_detailorder)
		If ll_detailorder[ii] = ll_current_order Then
			in_message.event ue_notify_client('Validation','detailorder')
			return 'Please select a unique value for each event number.'
		End If
	Next 
	
	ll_detailorder[i] = long(this.of_getitem(i, 'detailorder'))
	
Next 

return ''

end function

public function string of_delete ();long l_id,l_count
string s_useradded




return super::of_delete()
end function

public function string of_duplicate_issue (long al_id);string ls_error


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
long l_old, i, ll_reminderID, ll_appealdetailID
n_dao ln_datastores[],ln_error
n_update_tools ln_tools
n_transaction_pool ln_transaction_pool
n_appealdetail_duedate	ln_appealdetail_duedate
datetime ldt_now, ldt_duedate, ldt_reminder_due
long ll_datetermID

ln_appealdetail_duedate = Create n_appealdetail_duedate

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the modified date and find out if the in test and closed by 
//-----------------------------------------------------------------------------------------------------------------------------------
ldt_now = gn_globals.in_date_manipulator.of_now()

of_log_appealdetail_changes(ldt_now)

For i = 1 to this.RowCount()
	ll_datetermID = long(this.of_getitem(i, 'datetermid'))
	ll_appealdetailID = long(this.of_getitem(1, 'appealdetailid'))
	
//	If this.GetItemStatus(i, 0, Primary!) = NewModified! Then
//		ldt_duedate 		= 	ln_appealdetail_duedate.of_get_due_date(ll_datetermID)
//		this.of_setitem(i, 'appealeventduedate', ldt_duedate)
//	End If

	If this.of_getitem(i, 'AppealDetailReminder') = 'Y' Then
		If isnull(this.of_getitem(i, 'reminderid')) or this.of_getitem(i, 'reminderid') = '' Then
			ldt_reminder_due = this.GetItemDateTime(i, 'reminderdue')
			ll_reminderID = of_insert_reminder(ll_appealdetailID, ldt_reminder_due, 'Appeal Event Reminder')
			this.of_setitem(i, 'ReminderID', ll_reminderID)
		End If
	End If

	If this.GetItemStatus(i, 0, Primary!) <> NotModified! Then
		this.of_setitem(i, 'appealupdateddate', ldt_now)
		this.of_setitem(i, 'appealdetailupdatedby', gn_globals.is_login)
	End If
Next 

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
Destroy ln_appealdetail_duedate 


return ''
end function

public subroutine of_log_appealdetail_changes (datetime adt_now);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This Function checks for changes to the AppealDetail and logs the changes into the AppealDetail Table
//	Created by:	Joel White
//	History: 	9/19/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long 			l_column_count, i, ll_row, ll_counter
Long			ll_appealdetailID
string 		ls_new_value, ls_column_name, ls_string, ls_column_type, ls_original_value



//-----------------------------------------------------------------------------------------------------------------------------------
// Ensure something has changed on the detail before continuing
//-----------------------------------------------------------------------------------------------------------------------------------
If of_changed() = True Then

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the AppealDetailID
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_appealdetailID = 	long(this.of_getitem(1, 'AppealDetailID'))


	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the column count
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_column_count = long(this.describe("datawindow.column.count"))
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Loop on the rows and then on each column to find out what has changed.
	//-----------------------------------------------------------------------------------------------------------------------------------
	For ll_counter = 1 to this.Rowcount()
		For i = 1 to l_column_count
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Get the column name for this column number
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_column_name = lower(this.describe("#"+ string(i) +".name"))
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Get the new value and the original value
			//-----------------------------------------------------------------------------------------------------------------------------------
			ls_new_value = lower(this.of_getitem(ll_counter, ls_column_name))
			ls_original_value = lower(this.of_getitem_original(ll_counter, ls_column_name))
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// If the two values aren't the same, then log the change into the AppealDetail Table
			//-----------------------------------------------------------------------------------------------------------------------------------
			If ls_new_value <> ls_original_value Then
				If this.GetItemStatus(ll_counter, i, Primary!) = NewModified! Then
					
							  	INSERT INTO cusfocus.AppealDetailLog  
										( AppealDetailID,   
										ColumnChanged,   
									  	OldValue,   
									  	NewValue,   
									  	ChangedBy,   
									  	ChangedDateTime )  
						  		VALUES ( :ll_appealdetailID,   
									  	:ls_column_name,   
									  	'Initially Created',   
									  	:ls_new_value,   
									  	:gn_globals.is_login,   
									  	:adt_now )  
										USING SQLCA;
				Else
							  	INSERT INTO cusfocus.AppealDetailLog  
										( AppealDetailID,   
										ColumnChanged,   
									  	OldValue,   
									  	NewValue,   
									  	ChangedBy,   
									  	ChangedDateTime )  
						  		VALUES ( :ll_appealdetailID,   
									  	:ls_column_name,   
									  	:ls_original_value,   
									  	:ls_new_value,   
									  	:gn_globals.is_login,   
									  	:adt_now )  
										USING SQLCA;
				End If 
			End If
		Next
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Now that we have looped through all the columns for one row, reset the column count so the loop works correctly
		//-----------------------------------------------------------------------------------------------------------------------------------
		l_column_count = long(this.describe("datawindow.column.count"))
	Next
End If

end subroutine

public function string of_retrieve (long al_value);long i, ll_appealdetailid, ll_upperbound, ll_test

long i_i

in_update_array[1].retrieve(al_value)
in_update_array[2].retrieve(al_value,is_qualifier)
in_update_array[3].retrieve(al_value,is_qualifier)

for i_i = 4 to upperbound(in_update_array) 
	
	in_update_array[i_i].retrieve(al_value)

next

n_dao_appealdetailnotes ln_notes_dao
ln_notes_dao = Create n_dao_appealdetailnotes

For i = 1 to this.RowCount()
	ll_appealdetailID = long(this.of_getitem(i, 'appealdetailID'))
	ln_notes_dao.of_retrieve(ll_appealdetailID)
	
	If ln_notes_dao.RowCount() > 0 Then
		this.of_setitem(i, 'hasnote', 'Y')
		this.SetItemStatus(i, 'hasnote', Primary!, NotModified!)
	End If
Next

Destroy ln_notes_dao

in_checkout.of_add_tableid(is_qualifier,al_value)
if in_checkout.of_checkout( gn_globals.il_userid) = false then 
//	ib_readonly = true
	return in_checkout.of_get_messagestring()
else
	return ''
end if 


end function

public function long of_new_appealdetail (long al_appealheaderid);Long 			ll_row, ll_appealheaderID, i, ll_max_order, ll_order, ll_key
datetime		ldt_now

//-----------------------------------------------------------------------------------------------------------------------------------

// Insert a new row
//-----------------------------------------------------------------------------------------------------------------------------------

ll_row = this.insertrow(0)

//-----------------------------------------------------------------------------------------------------------------------------------

// Get the ID for this row
//-----------------------------------------------------------------------------------------------------------------------------------

//ll_key = this.of_getkey()
n_update_tools ln_update_tools
ln_update_tools = create n_update_tools
ll_key = ln_update_tools.of_get_key('appealdetail')
destroy ln_update_tools

//-----------------------------------------------------------------------------------------------------------------------------------

// Get the server time
//-----------------------------------------------------------------------------------------------------------------------------------

ldt_now 				= 	gn_globals.in_date_manipulator.of_now()

//-----------------------------------------------------------------------------------------------------------------------------------

// Set the needed values into the new row
//-----------------------------------------------------------------------------------------------------------------------------------

this.of_setitem(ll_row, 'appealdetailid', ll_key)
this.of_setitem(ll_row, 'AppealHeaderID', al_appealheaderID)
this.of_setitem(ll_row, 'AppealEventStatus', 'A')
this.of_setitem(ll_row, 'AppealDetailDate', ldt_now)
this.of_setitem(ll_row, 'AppealDetailCreatedby', gn_globals.is_login)
this.of_setitem(ll_row, 'appealdetailletter', 'N')
this.of_setitem(ll_row, 'appealdetailreminder', 'N')


//-----------------------------------------------------------------------------------------------------------------------------------

// Seed in the events in multiples of 10 to make it easier to reorder events
//-----------------------------------------------------------------------------------------------------------------------------------

ll_max_order = 10

For i = 1 to this.RowCount()
	ll_order = long(this.of_getitem(i, 'detailorder'))
	
	If ll_order >= ll_max_order Then ll_max_order = ll_order + 10
Next

//-----------------------------------------------------------------------------------------------------------------------------------

// Set the newly calculated order into the row
//-----------------------------------------------------------------------------------------------------------------------------------

this.of_setitem(ll_row, 'detailorder', ll_max_order)

Return ll_row
end function

public function string of_get_key_value (string table_name);//***********************************************************************************************
//
//  Function:	 fw_getkeyvalue
//  Purpose:    TO get a unique key from the Key Table
//  Parameters: Table_Name
//  Returns:    A string that is a unique key
//
//  Date     Developer    Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/06/00 C. Jackson  Original Version
//  11/10/00 C. Jackson  Correct error message was Messagebox(String(SQLCA.SQLDBCode), 
//                       SQLCA.SQLErrText) - too general.  Was displaying simply '3' in title bar 
//                       and no text in some cases.
//	 12/19/2002 K. Claver Modified to work with split-out key generation tables
//
//***********************************************************************************************

STRING  l_cCommand, l_cKeyTable, l_cTranName, ls_user
LONG	  l_nKeyValue, ll_tran_count
INT     l_nCounter
BOOLEAN l_bAutoCommit

// Get UserID
ls_User = OBJCA.WIN.fu_GetLogin(SQLCA)

//Determine which key table to use		
CHOOSE CASE table_name
	CASE "assigned_special_flags"
		l_cKeyTable = "cusfocus.special_flags_keygen"
		l_cTranName = "sflkey"
	CASE "carve_out_entries"
		l_cKeyTable = "cusfocus.carve_out_entries_keygen"
		l_cTranName = "coekey"
	CASE "case_forms"
		l_cKeyTable = "cusfocus.case_forms_keygen"
		l_cTranName = "cfrkey"
	CASE "case_log"
		l_cKeyTable = "cusfocus.case_log_keygen"
		l_cTranName = "clgkey"
	CASE "case_log_master_num"
		l_cKeyTable = "cusfocus.case_log_masternum_keygen"
		l_cTranName = "clmkey"
	CASE "case_notes"
		l_cKeyTable = "cusfocus.case_notes_keygen"
		l_cTranName = "cnokey"
	CASE "case_transfer"
		l_cKeyTable = "cusfocus.case_transfer_keygen"
		l_cTranName = "ctrkey"
	CASE "contact_notes"
		l_cKeyTable = "cusfocus.contact_notes_keygen"
		l_cTranName = "ctnkey"
	CASE "contact_person"
		l_cKeyTable = "cusfocus.contact_person_keygen"
		l_cTranName = "cprkey"
	CASE "correspondence"
		l_cKeyTable = "cusfocus.correspondence_keygen"
		l_cTranName = "crpkey"
	CASE "cross_reference"
		l_cKeyTable = "cusfocus.cross_reference_keygen"
		l_cTranName = "crrkey"
	CASE "other_source"
		l_cKeyTable = "cusfocus.other_source_keygen"
		l_cTranName = "otskey"
	CASE "reminders"
		l_cKeyTable = "cusfocus.reminders_keygen"
		l_cTranName = "remkey"
	CASE "reopen_log"
		l_cKeyTable = "cusfocus.reopen_log_keygen"
		l_cTranName = "reokey"
	CASE ELSE
		l_cKeyTable = "cusfocus.key_generator"
		l_cTranName = "kgnkey"
END CHOOSE


// RAP 12/18/2008 These lines will tell you how many transactions you have open
//l_cCommand =  "SELECT @@trancount"
////Prepare the staging area
//PREPARE SQLSA FROM :l_cCommand USING SQLCA;
//
////Describe staging into description area
//DESCRIBE SQLSA INTO SQLDA;
//
////Declare as cursor and fetch
//DECLARE gettrancount DYNAMIC CURSOR FOR SQLSA;
//OPEN DYNAMIC gettrancount USING DESCRIPTOR SQLDA;
//FETCH gettrancount USING DESCRIPTOR SQLDA;
//
//ll_tran_count = GetDynamicNumber( SQLDA, 1 )
//
////Close the cursor
//CLOSE gettrancount;


			// save the case components
			l_bAutoCommit = SQLCA.autocommit
			SQLCA.autocommit = FALSE

// RAP 12/18/2008 - Took this out, controlling it through the autocommit property, also added holdlocks
//l_cCommand = ( 'BEGIN TRANSACTION '+l_cTranName )
//EXECUTE IMMEDIATE :l_cCommand USING SQLCA;


//Update the key generator table
l_cCommand = "UPDATE "+l_cKeyTable+" WITH (HOLDLOCK) "+ &
				 " SET pk_id = pk_id + 1"+ &
				 " WHERE table_name = '"+table_name+"'"
				 
EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
				 

//Get the new key value.  Need to use dynamic sql as need to get a value back from
//  a generated query.
l_cCommand =  "SELECT pk_id"+ &
				  " FROM "+l_cKeyTable+" WITH (HOLDLOCK) "+ &
				  " WHERE table_name = '"+table_name+"'"
				  
//Prepare the staging area
PREPARE SQLSA FROM :l_cCommand USING SQLCA;

//Describe staging into description area
DESCRIBE SQLSA INTO SQLDA;

//Declare as cursor and fetch
DECLARE getKeyVal DYNAMIC CURSOR FOR SQLSA;
OPEN DYNAMIC getKeyVal USING DESCRIPTOR SQLDA;
FETCH getKeyVal USING DESCRIPTOR SQLDA;

l_nKeyValue = GetDynamicNumber( SQLDA, 1 )

//Close the cursor
CLOSE getKeyVal;
 

IF SQLCA.SQLCode <> 0 OR l_nKeyValue = 0 THEN
	 Messagebox(gs_appname, 'Unable to obtain primary key for '+table_name+' contact your System Administrator.')
	 l_cCommand = ( 'ROLLBACK TRANSACTION ' )
	 EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			SQLCA.autocommit = l_bAutoCommit
	 Return String(-1)
ELSE
	// RAP - 12/18/2008 took this out, controlling it though the autocommit property
//	 l_cCommand = ( 'COMMIT TRANSACTION '+l_cTranName )
//	 EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			SQLCA.autocommit = l_bAutoCommit
	 Return String(l_nKeyValue)
END IF


end function

public subroutine of_delete_appealdetail (long al_appealdetailid);long	ll_row

ll_row = this.find('appealdetailID = ' + string(al_appealdetailid), 1, this.Rowcount())

If ll_row > 0 and ll_row <= this.Rowcount() Then
	this.DeleteRow(ll_row)
End If
end subroutine

public function integer of_insert_reminder (long al_appealdetailid, datetime adt_duedate, string as_reminder_desc);long ll_reminderID, ll_casenumber
datetime ldt_now
string	ls_comment

ll_reminderID = long(of_get_key_value('reminders'))
ldt_now = gn_globals.in_date_manipulator.of_now()
ls_comment = 'This appeal event has a reminder that is due at ' + string(adt_duedate) 


INSERT cusfocus.reminders( reminder_id, 
			reminder_type_id,
			reminder_viewed,
			case_number,
			case_type,
			case_reminder,
			co_id,
			reminder_crtd_date,
			reminder_set_date,
			reminder_subject,
			reminder_comments,
			reminder_dlt_case_clsd,
			reminder_author,
			reminder_recipient )
VALUES( :ll_reminderID,
			'4',
			'N',
			:is_case_number,
			:is_casetype,
			'Y',
			null,
			:ldt_now,
			:adt_duedate,
			:as_reminder_desc,
			:ls_comment,
			'N',
			:gn_globals.is_login,
			:gn_globals.is_login )
USING SQLCA;


return ll_reminderID
end function

public function long of_delete_reminder (long al_reminderid);If al_reminderID > 0 Then
  DELETE FROM cusfocus.reminders  
   WHERE cusfocus.reminders.reminder_id = :al_reminderID   
	USING SQLCA           ;
	
	
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	// Check the SQL Return 
//	//-----------------------------------------------------------------------------------------------------------------------------------
//	CHOOSE CASE SQLCA.SQLCode
//		CASE -1
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			// Error happened, show a message box to show the user an error occurred.
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			MessageBox (gs_appname, 'Error retrieving new appeal system configuration.')
//			Return -1
//		CASE ELSE
//			//-----------------------------------------------------------------------------------------------------------------------------------
//			// Good things happened.
//			//-----------------------------------------------------------------------------------------------------------------------------------\
//			Return 1
//	End Choose	
End If

Return 1
end function

public subroutine of_delete_all ();long	i, ll_rowcount

For i = 1 to this.RowCount()
	this.DeleteRow(i)	
Next
end subroutine

public subroutine of_calculate_duedates (datetime adt_startdatetime);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  adt_startdatetime 	- This is the start datetime which the due date will be calculated from.
//	Overview:   This will calculate/recalculate the due date for all the appeal details on an appeal.
//	Created by:	Joel White
//	History: 	1/31/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_rowcount, ll_datetermID, i
string	ls_reminder
datetime	ldt_due_date, ldt_reminder_due
n_appealdetail_duedate ln_duedate

ln_duedate = Create n_appealdetail_duedate

//-----------------------------------------------------------------------------------------------------------------------------------
// Grab the rowcount and then prepare to loop on each row
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = This.RowCount()

For i = 1 to ll_rowcount
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the dateterm and if the detail has a reminder set.
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_datetermID 	= 	this.GetItemNumber(i, 'datetermID')
	ls_reminder 	= 	this.GetItemString(i, 'appealdetailreminder')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the due date using the new start datetime & set the value into the DAO
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldt_due_date 		= 	ln_duedate.of_get_due_date(ll_datetermID, adt_startdatetime)
	this.of_setitem(i, 'appealeventduedate'	, ldt_due_date)
		
	If ls_reminder = 'Y' Then 
		ldt_reminder_due 	= 	ln_duedate.of_get_reminder_due_date(ll_datetermID, ldt_due_date)
		this.of_setitem(i, 'reminderdue'			, ldt_reminder_due)
	End If
Next

Destroy ln_duedate
end subroutine

public subroutine of_set_case_information (string as_casenumber);
is_case_number = as_casenumber

  SELECT cusfocus.case_log.case_type  
    INTO :is_casetype  
    FROM cusfocus.case_log  
   WHERE cusfocus.case_log.case_number = :as_casenumber   ;



end subroutine

on n_dao_appealdetail.create
call super::create
end on

on n_dao_appealdetail.destroy
call super::destroy
end on

event constructor;call super::constructor;long i, ll_appealdetailID, ll_upperbound

n_transaction_pool ln_transaction_pool
transaction lt_transobject


ln_transaction_pool = Create n_transaction_pool

this.dataobject = 'd_data_appealdetail'
is_qualifier = 'AppealDetail'

this.of_SetTransobject(SQLCA)

is_validatecolumnarray[1] = 'appealeventid'
is_validatecolumnarray[2] = 'datetermid'


end event

