$PBExportHeader$n_update_tools.sru
$PBExportComments$<doc>
forward
global type n_update_tools from nonvisualobject
end type
end forward

global type n_update_tools from nonvisualobject
end type
global n_update_tools n_update_tools

type variables
transaction ixctn_transaction
n_datastore in_getkey
String is_last_error
Boolean  ib_check_trancount=true
end variables

forward prototypes
public function boolean of_begin_transaction ()
public function boolean of_commit_transaction ()
public function boolean of_rollback_transaction ()
public function long of_create_new_key (string as_table, long al_numkeys)
public function long of_get_identity ()
public function long of_get_key (string s_table)
public function long of_get_key (string as_tablename, long al_numkeys, boolean ab_use_alt_transaction)
public function long of_get_key (string as_tablename, boolean ab_use_alt_transaction)
public function long of_get_key (string as_table, long al_numkeys)
public function datastore of_manage_update (datastore ads_datastore[])
public function datawindow of_manage_update (datawindow ads_datawindow[])
public subroutine of_settransobject (transaction axctn_transaction)
public function string of_get_last_error ()
public subroutine of_set_check_trancount (boolean ab_check_trancount)
end prototypes

public function boolean of_begin_transaction ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will begin a database transaction</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_sql

s_SQL="BEGIN TRANSACTION ObjectTran"

Execute Immediate :s_SQL Using ixctn_transaction;

if ixctn_transaction.SQLCode <> 0 then
	Return FALSE
else
	Return TRUE
end if

end function

public function boolean of_commit_transaction ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will commit a transaction</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_sql

s_SQL="COMMIT TRANSACTION  ObjectTran"
execute Immediate :s_SQL using ixctn_transaction;
if ixctn_transaction.SQLCode<>-1 then
	RETURN TRUE
Else
	s_SQL="ROLLBACK TRANSACTION  ObjectTran"
	execute Immediate :s_SQL using ixctn_transaction;
	RETURN FALSE
END IF
end function

public function boolean of_rollback_transaction ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will roll back a transaction</Description>
<Arguments>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_sql

s_SQL="ROLLBACK TRANSACTION  ObjectTran"
execute Immediate :s_SQL using ixctn_transaction;
RETURN FALSE

end function

public function long of_create_new_key (string as_table, long al_numkeys);Long l_count
Long l_key

setNull(l_key)

//----------------------------------------------------------------------------------------------------------------------------------
// No rows were updated so find out if table exists in this database. If so, then query the keycolumn table structures and find out what the maximum
//	key value is for this table. This will become the entry for key controller.
//-----------------------------------------------------------------------------------------------------------------------------------
Select 	Count(*)
INTO		:l_count
From		sysobjects (nolock)
Where		name = :as_table
AND		type = 'U'
Using		ixctn_transaction;
	
If l_count > 0 Then
	DECLARE 	sp_getkeycolumnvalue PROCEDURE FOR SP_GetKeyColumnMaxValue  
				@c255_table = :as_table
	Using		ixctn_transaction;
	EXECUTE 	sp_getkeycolumnvalue;
	FETCH 	sp_getkeycolumnvalue INTO :l_key;
	CLOSE 	sp_getkeycolumnvalue;
		
	If not IsNull(l_key) Then
		
		if l_key = 0 then l_key = 1
		
		INSERT INTO KeyController  
			( KyCntrllrTble,   
			  KyCntrllrMxKy,   
			  KyCntrllrFllr1,   
			  KyCntrllrFllr2,   
			  KyCntrllrFllr3,   
			  KyCntrllrFllr4,   
			  KyCntrllrFllr5,   
			  KyCntrllrFllr6 )  
		VALUES ( :as_table,   
			  :l_key + :al_numkeys,   
			  '',   
			  '',   
			  '',   
			  '',   
			  '',   
			  '' )
		Using		ixctn_transaction;
		  
		if ixctn_transaction.SQLCode <> 0 then
				SetNull(l_key)
		end if
		
	End if
End IF

Return l_key
				  
	
end function

public function long of_get_identity ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the @@identity variable from the server</Description>
<Arguments>
</Arguments>
<CreatedBy>Pat Newgent</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

long i_identity

DECLARE identity_cursor DYNAMIC CURSOR FOR SQLSA ;

PREPARE SQLSA FROM "SELECT @@identity" ;

OPEN DYNAMIC identity_cursor ;

FETCH identity_cursor INTO :i_identity ;

CLOSE identity_cursor ;

Return i_identity
end function

public function long of_get_key (string s_table);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the next key for a table</Description>
<Arguments>
	<Argument Name="as_table">The table you want a new key for</Argument>
</Arguments>
<CreatedBy>Pat Newgent</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/


Return of_get_key(s_table, 1)
end function

public function long of_get_key (string as_tablename, long al_numkeys, boolean ab_use_alt_transaction);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the next key for a table</Description>
<Arguments>
	<Argument Name="as_table">The table you want a new key for</Argument>
	<Argument Name="al_numkeys">The number of keys to obtain</Argument>
	<Argument Name="ab_use_alt_transaction">Indicates that you want to get the key via a secondary transaction object to prevent locking.</Argument>
</Arguments>
<CreatedBy>Pat Newgent</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
long ll_key

if ab_use_alt_transaction then
//	ll_key = gn_globals.it_KeyManager.of_get_key(as_tablename, al_numkeys)
//	if isnull(ll_key) then is_last_error = gn_globals.it_keyManager.of_get_last_error()
	Return ll_key
else
	Return this.of_get_key(as_tablename, al_numkeys)
end if
end function

public function long of_get_key (string as_tablename, boolean ab_use_alt_transaction);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the next key for a table</Description>
<Arguments>
	<Argument Name="as_table">The table you want a new key for</Argument>
	<Argument Name="ab_use_alt_transaction">Indicates that you want to get the key via a secondary transaction object to prevent locking.</Argument>
</Arguments>
<CreatedBy>Pat Newgent</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
long ll_key

if ab_use_alt_transaction then
//	ll_key = gn_globals.it_keyManager.of_get_key(as_tablename, 1)
//	if isnull(ll_key) then is_last_error = gn_globals.it_keyManager.of_get_last_error()
	Return ll_key
else
	Return this.of_get_key(as_tablename)
end if
end function

public function long of_get_key (string as_table, long al_numkeys);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the next key for a table</Description>
<Arguments>
	<Argument Name="as_table">The table you want a new key for</Argument>
	<Argument Name="al_numkeys">The number of keys you want, allows you to get a batch of keys for better performance.</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

long i_key, l_count, ll_row
string s_sql

SetNull(i_key)

If	lower(as_table) = 'ticklermessage' then
	Return -999
Else

	//----------------------------------------------------------------------------------------------------------------------------------
	// 4/26/2005 - If the transaction count > 1 then get the key utilizing a second SPID
	//-----------------------------------------------------------------------------------------------------------------------------------
//	Choose Case gn_globals.it_keymanager.of_get_trancount(ixctn_transaction) 
//		Case -1  // Error
//			return i_key
//		Case IS>=1 // Inside transaction
//			return this.of_get_key(as_table, al_numkeys, True)
//	End Choose
		
// RAP - This way will work in Sybase and MS SQL-Server		
	DataStore lds_nextkey
	lds_nextkey = create DataStore
	lds_nextkey.dataobject = 'd_getkey'
	lds_nextkey.SetTransObject(SQLCA)
	ll_row = lds_nextkey.Retrieve(as_table, 0, 1, 'y')
	IF ll_row > 0 THEN		
		i_key = lds_nextkey.object.nextkey[1]
	END IF
	Destroy lds_nextkey	

//	//------------------------------------------------------------------------------------------
//	// Determine the next available key
//	//------------------------------------------------------------------------------------------
//	DECLARE sp_Key procedure for dbo.SP_GetKey @vc_TbleNme = :as_table, @i_Ky = :i_key OUTPUT, @i_increment = :al_numkeys using ixctn_transaction;
//		
//	EXECUTE SP_Key;
//	
//	FETCH sp_Key INTO :i_key;
//	if isnull(i_key) then
//		is_last_error = 'DB Code: ' + string(ixctn_transaction.SQLDBCode) + ' - ' + ixctn_transaction.SQLErrText
//		setnull(i_key)
//	end if
//	CLOSE SP_Key;

	//	ll_row = in_getkey.Retrieve(as_table, i_key, al_numkeys)
	//	if ll_row = 1 then 
	//		i_key = in_getkey.GetItemNumber(1, 'nextkey')
	//	else
	//		setnull(i_key)
	//	end if

End If

/*

	s_SQL="BEGIN TRANSACTION getkey_transaction"
	Execute Immediate :s_SQL Using ixctn_transaction;
	
	if ixctn_transaction.SQLCode <> 0 then
		Return i_key
	End if


	Update 	KeyController
	set 		KyCntrllrMxKy 	= KyCntrllrMxKy + :al_numkeys
	From		KeyController
	Where 	KyCntrllrTble 	= :as_table
	Using		ixctn_transaction;

	if ixctn_transaction.SQLCode <> 0 then
		//----------------------------------------------------------------------------------------------------------------------------------
		// At this point in time the Begin Transaction succeeded, and the Update Failed.  It is a cheaper cost to 
		// issue a commit than a rollback to clear the open transaction.
		//-----------------------------------------------------------------------------------------------------------------------------------
		s_SQL="COMMIT transaction getkey_transaction"
		Execute Immediate :s_SQL Using ixctn_transaction;
		SetNull(i_key)
		Return i_key
	end if
	
	if ixctn_transaction.SQLNRows <> 1 then
		//----------------------------------------------------------------------------------------------------------------------------------
		// No rows were updated so find out if table exists in this database. If so, then query the keycolumn table structures and find out what the maximum
		//	key value is for this table. This will become the entry for key controller.
		//-----------------------------------------------------------------------------------------------------------------------------------

		//----------------------------------------------------------------------------------------------------------------------------------
		// Clear the open transaction
		//-----------------------------------------------------------------------------------------------------------------------------------
		s_SQL="Commit transaction getkey_transaction"
		Execute Immediate :s_SQL Using ixctn_transaction;
		
		if ixctn_transaction.SQLCode <> 0 then
			SetNull(i_key)
			Return i_key
		end if
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Initialize a new record in KeyController for the table
		//-----------------------------------------------------------------------------------------------------------------------------------
		Return this.of_create_new_key(as_table, al_numkeys)
		
	End IF //ixctn_transaction.SQLNRows <> 1
	

	//----------------------------------------------------------------------------------------------------------------------------------
	// Determine the new Key Value
	//-----------------------------------------------------------------------------------------------------------------------------------
	Select 	KyCntrllrMxKy - :al_numkeys + 1
	Into		:i_key
	From 		KeyController
	Where 	KyCntrllrTble 	= :as_table
	Using		ixctn_transaction;

	if ixctn_transaction.SQLCode <> 0 then
		SetNull(i_key)
		s_SQL="ROLLBACK transaction getkey_transaction"
	Else
		s_SQL="COMMIT transaction getkey_transaction"
	End If
	
	Execute Immediate :s_SQL Using ixctn_transaction;

	if ixctn_transaction.SQLCode <> 0 then
		SetNull(i_key)
	End if

End If
*/

//----------------------------------------------------------------------------------------------------------------------------------
// Return the new key value, null indicates error
//-----------------------------------------------------------------------------------------------------------------------------------

RETURN i_key
end function

public function datastore of_manage_update (datastore ads_datastore[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will update an array of datastores.  It will return the datastore if one fails.  You will need to manage ResetUpdates() yourself.</Description>
<Arguments>
	<Argument Name="ads_datastore[]">The array of datstores</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

datastore ids_data
integer i_i
for i_i  = 1 to upperbound(ads_datastore)
	if isvalid(ads_datastore[i_i]) then
		if ads_datastore[i_i].update(true,false) = -1 then 
			return ads_datastore[i_i]
		end if
	end if
next

return ids_data
end function

public function datawindow of_manage_update (datawindow ads_datawindow[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will update an array of datawindows.  It will return the datawindow if one fails.  You will need to manage ResetUpdates() yourself.</Description>
<Arguments>
	<Argument Name="ads_datastore[]">The array of datstores</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/


datawindow idw_data
integer i_i
for i_i  = 1 to upperbound(ads_datawindow)
	if isvalid(ads_datawindow[i_i]) then
		if ads_datawindow[i_i].update(true,false) = -1 then
			return ads_datawindow[i_i]
		end if
	end if
next

return idw_data
end function

public subroutine of_settransobject (transaction axctn_transaction);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will set the transaction object for all functions to use</Description>
<Arguments>
	<Argument Name="axctn_transaction">The transaction to use</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

ixctn_transaction = axctn_transaction
in_getkey.SetTransObject(ixctn_transaction)
end subroutine

public function string of_get_last_error ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the last error encountered</Description>
<Arguments>
</Arguments>
<CreatedBy>Pat Newgent</CreatedBy>
<Created>7/19/2004</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Return is_last_error
end function

public subroutine of_set_check_trancount (boolean ab_check_trancount);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Enables and Disables Transaction Count Checking</Description>
<Arguments>
	<Argument Name="ab_check_trancount">TRUE enables checking, and False disables checking</Argument>
</Arguments>
<CreatedBy>Pat Newgent</CreatedBy>
<Created>07/19/2004</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

ib_check_trancount = ab_check_trancount
end subroutine

on n_update_tools.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_update_tools.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This object will manage a database transaction for you.  It also has some functions to get a new table key and the latest identity inserted into a table.
</Abstract>----------------------------------------------------------------------------------------------------*/


ixctn_transaction = SQLCA

//??? RAP changed for .Net
in_getkey = Create n_datastore
//???in_getkey = Create Datastore
in_getkey.dataobject = 'd_getkey'
in_getkey.SetTransObject(ixctn_transaction)

end event

event destructor;if isvalid(in_getkey) then destroy in_getkey
end event

