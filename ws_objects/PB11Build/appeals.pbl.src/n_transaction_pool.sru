$PBExportHeader$n_transaction_pool.sru
forward
global type n_transaction_pool from nonvisualobject
end type
end forward

global type n_transaction_pool from nonvisualobject
end type
global n_transaction_pool n_transaction_pool

type variables
Protected:
Transaction ixctn_transaction_pool[]
Long il_reportdatabaseid[]
String is_reportdatabasedescription[]
String is_errormessage = ''
end variables

forward prototypes
public function string of_geterrormessage ()
public function boolean of_disconnect (transaction axctn_transaction)
public function transaction of_gettransactionobject (string as_reportdatabasedescription)
public function boolean of_destroy (transaction axctn_transaction)
public function transaction of_gettransactionobject (long al_reportdatabaseid)
end prototypes

public function string of_geterrormessage ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_geterrormessage()
//	Overview:   This will return the last error message that occurred
//	Created by:	Blake Doerr
//	History: 	1/26/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the current error message
//-----------------------------------------------------------------------------------------------------------------------------------
Return is_errormessage
end function

public function boolean of_disconnect (transaction axctn_transaction);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_disconnect()
//	Arguments:  axctn_transaction - The transaction to disconnect
//	Overview:   This will disconnect a transaction for you.  It does not have to be one in the pool
//	Created by:	Blake Doerr
//	History: 	1/26/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// If it isn't valid, there is nothing to do
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(axctn_transaction) Then Return True

//-----------------------------------------------------------------------------------------------------------------------------------
// Don't let them disconnect SQLCA, they don't know what they are doing
//-----------------------------------------------------------------------------------------------------------------------------------
If axctn_transaction = SQLCA Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// If the transaction is still connected, disconnect
//-----------------------------------------------------------------------------------------------------------------------------------
If	DBHandle(axctn_transaction) > 0 Then
	Disconnect Using axctn_transaction;
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success if we are disconnected
//-----------------------------------------------------------------------------------------------------------------------------------
Return Not DBHandle(axctn_transaction) > 0

end function

public function transaction of_gettransactionobject (string as_reportdatabasedescription);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_gettransactionobject()
//	Arguments:  as_reportdatabasedescription - The name of the report database entry
//	Overview:   This will get the transaction that you need and connect to it
//	Created by:	Blake Doerr
//	History: 	1/26/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_reportdatabaseid, ll_index 
Transaction lxctn_transaction

//-----------------------------------------------------------------------------------------------------------------------------------
// First, see if it's cached.  It must be valid and connected and also must have the same reportdatabase id
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ixctn_transaction_pool[]), UpperBound(is_reportdatabasedescription[]))
	If Lower(is_reportdatabasedescription[ll_index]) = Lower(as_reportdatabasedescription) Then
		If IsValid(ixctn_transaction_pool[ll_index]) Then
			If	DBHandle(ixctn_transaction_pool[ll_index]) > 0 Then
				Return ixctn_transaction_pool[ll_index]
			End If
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the database id from the description
//-----------------------------------------------------------------------------------------------------------------------------------
Select	RprtDtbseID
Into		:ll_reportdatabaseid
From		ReportDatabase
Where		RprtDtbseDscrptn = :as_reportdatabasedescription
Using		SQLCA;

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the transaction object based on the report database id
//-----------------------------------------------------------------------------------------------------------------------------------
lxctn_transaction = This.of_gettransactionobject(ll_reportdatabaseid)

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the report database id's and set the description
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(il_reportdatabaseid[])
	If il_reportdatabaseid[ll_index] = ll_reportdatabaseid Then
		is_reportdatabasedescription[ll_index] = as_reportdatabasedescription
	End If
Next

Return lxctn_transaction
end function

public function boolean of_destroy (transaction axctn_transaction);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_destroy()
//	Arguments:  axctn_transaction - The transaction to destroy
//	Overview:   This will disconnect and destroy a transaction for you.  It does not have to be one in the pool
//	Created by:	Blake Doerr
//	History: 	1/26/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// If it isn't valid, there is nothing to do
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(axctn_transaction) Then Return True

//-----------------------------------------------------------------------------------------------------------------------------------
// If the transaction is SQLCA, do not let them destroy it
//-----------------------------------------------------------------------------------------------------------------------------------
If axctn_transaction = SQLCA Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// First disconnect the transaction if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
This.of_disconnect(axctn_transaction)

//-----------------------------------------------------------------------------------------------------------------------------------
// Destroy the transaction
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy axctn_transaction

//-----------------------------------------------------------------------------------------------------------------------------------
// Return true
//-----------------------------------------------------------------------------------------------------------------------------------
Return True
end function

public function transaction of_gettransactionobject (long al_reportdatabaseid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_gettransactionobject()
//	Arguments:  al_reportdatabaseid - The value of the report config id
//	Overview:   This will get the transaction that you need and connect to it
//	Created by:	Blake Doerr
//	History: 	1/26/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
//n_report_database ln_report_database
Transaction lxctn_null_transaction
Long ll_index, ll_upperbound

//-----------------------------------------------------------------------------------------------------------------------------------
// If the ReportDatabase ID isn't valid, return null
//-----------------------------------------------------------------------------------------------------------------------------------
If al_reportdatabaseid <= 0 Or IsNull(al_reportdatabaseid) Then
	Return lxctn_null_transaction
End If 

//-----------------------------------------------------------------------------------------------------------------------------------
// First, see if it's cached.  It must be valid and connected and also must have the same reportdatabase id
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To Min(UpperBound(ixctn_transaction_pool[]), UpperBound(il_reportdatabaseid[]))
	If il_reportdatabaseid[ll_index] = al_reportdatabaseid Then
		If IsValid(ixctn_transaction_pool[ll_index]) Then
			If	DBHandle(ixctn_transaction_pool[ll_index]) > 0 Then
				Return ixctn_transaction_pool[ll_index]
			End If
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear out the error message
//-----------------------------------------------------------------------------------------------------------------------------------
is_errormessage = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the Report Database Object
//-----------------------------------------------------------------------------------------------------------------------------------
//ln_report_database = Create n_report_database 

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the transaction object, passing in the pool
//-----------------------------------------------------------------------------------------------------------------------------------
//ll_index = ln_report_database.of_gettransactionobject(al_reportdatabaseid, ixctn_transaction_pool[])

//-----------------------------------------------------------------------------------------------------------------------------------
// If the Index isn't valid, return null
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_index <= 0 Or IsNull(ll_index) Then
	Return lxctn_null_transaction
End If 

il_reportdatabaseid[ll_index] = al_reportdatabaseid

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is a valid transaction, return it, otherwise return a null transaction and they should get the error message
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_index > 0 And Not IsNull(ll_index) Then
	//Destroy ln_report_database
	Return ixctn_transaction_pool[ll_index]
Else
	//is_errormessage = ln_report_database.of_geterrormessage()
	//Destroy ln_report_database
	Return lxctn_null_transaction
End If

end function

on n_transaction_pool.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_transaction_pool.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Disconnect from all non SQLCA transactions
//	Created by: Blake Doerr
//	History:    1/26/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Long ll_index

For ll_index = 1 To UpperBound(ixctn_transaction_pool[])
	If IsValid(ixctn_transaction_pool[ll_index]) Then
	End If
Next


end event

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   This will add SQLCA to the transaction pool first
//	Created by: Blake Doerr
//	History:    1/26/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ixctn_transaction_pool[1] = SQLCA
end event

