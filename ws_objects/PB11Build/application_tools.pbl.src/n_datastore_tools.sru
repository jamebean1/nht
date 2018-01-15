$PBExportHeader$n_datastore_tools.sru
forward
global type n_datastore_tools from nonvisualobject
end type
end forward

global type n_datastore_tools from nonvisualobject
end type
global n_datastore_tools n_datastore_tools

type variables
string is_errormessage
end variables

forward prototypes
public function boolean of_get_values (string as_select, ref long al_keys[], ref long al_column[])
public function string of_get_error_message ()
public function boolean of_create_datastore_object (string as_select, ref datastore ads_datastore)
public function boolean of_create_datastore_object (string as_select, ref datastore ads_datastore, transaction axctn_db)
public function string of_convert_array_to_string (long al_array[])
public function boolean of_get_values (string as_select, ref string as_values[])
public function boolean of_get_values (string as_select, ref long al_keys[])
public function boolean of_add_values (string as_select, ref long al_keys[])
end prototypes

public function boolean of_get_values (string as_select, ref long al_keys[], ref long al_column[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column
// Arguments:   as_select - Select Statement used to get the column
//					 al_keys[] - Array of key values passed by reference
// Overview:    Create a Datawindow from the Select Statement to get column values into a array
//              *** This Function should be usefull for getting an array value
// Created by:  Jake Pratt
// History:     08/01/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datastore lds_create_datastore
long ll_rows
long ll_current_row

//-----------------------------------------------------
// Crete DataStore for of_get_rows to use
//-----------------------------------------------------
lds_create_datastore = Create DataStore


//-----------------------------------------------------
// This function gets the rows.
//-----------------------------------------------------
if NOT of_create_datastore_object(as_select,lds_create_datastore) Then 
	Destroy lds_create_datastore
	Return False	
End If

ll_rows = lds_create_datastore.rowcount()

//-----------------------------------------------------
// Prepare the Values to Be returned
//-----------------------------------------------------
For ll_current_row = 1 to ll_rows
	al_keys[ll_current_row] = lds_create_datastore.Object.Data[ll_current_row,1]
Next

//-----------------------------------------------------
// Prepare the Values to Be returned
//-----------------------------------------------------
For ll_current_row = 1 to ll_rows
	al_column[ll_current_row] = lds_create_datastore.Object.Data[ll_current_row,2]
Next


Destroy lds_create_datastore


Return True







end function

public function string of_get_error_message ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_get_error_message()
// Arguments:	None
// Overview:	Return the internal error message
// Created by:	Gary Howard
// History:		07/08/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_errormessage
end function

public function boolean of_create_datastore_object (string as_select, ref datastore ads_datastore);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_creat_datastore_object
// Arguments:   as_select - Select Statement to Execute
// Overview:    Create a datawindow and select the rows
// Created by:  Jake Pratt
// History:     08/01/1997 - First Created 
// Date		By		Modification
// -------- ----- --------------------------------------------------------------------------------
// 10/17/97	RPN	Made function public. was able to make use of this code in the RAMacro Conversion Process
//	07/08/00	GLH	Made function redirect to function which supports setting the transaction object as well as messaging.
//-----------------------------------------------------------------------------------------------------------------------------------

Return this.of_create_datastore_object(as_select,ads_datastore,SQLCA)
end function

public function boolean of_create_datastore_object (string as_select, ref datastore ads_datastore, transaction axctn_db);//----------------------------------------------------------------------------------------------------------------------------------
// Function:	of_creat_datastore_object
// Arguments:	as_select - Select Statement to Execute
//					ads_datastore - datastore by reference to create the object in
//					transaction - transaction object to create the datastore against
// Overview:	Create a datastore and select the rows
// Created by:	Jake Pratt
// History:		08/01/1997 - First Created 
// Date		By		Modification
// -------- ----- --------------------------------------------------------------------------------
// 10/17/97	RPN	Made function public. was able to make use of this code in the RAMacro Conversion Process
//-----------------------------------------------------------------------------------------------------------------------------------

string s_error_message
string s_dwsyntax

//-----------------------------------------------------
// Ensure the database connection is valid.
//-----------------------------------------------------
If Not IsValid(axctn_db) Then
	is_errormessage = "The transaction that was specified for this operation is invalid"
	Return False
ElseIf DBHandle(axctn_db) <= 0 or IsNull(DBHandle(axctn_db)) Then
	is_errormessage = "The transaction that was specified for this operation does not have a valid database connection"	
	Return False
End If

//-----------------------------------------------------
// Ensure the sql select argument exists
//-----------------------------------------------------
as_select = Trim(as_select)
If IsNull(as_select) or len(as_select) = 0 Then
	is_errormessage = "The sql argument was an empty string"
	Return False
End If
	
s_dwsyntax = axctn_db.SyntaxFromSQL(as_select,  "", s_error_message)
If Len(s_error_message) > 0 Then
	is_errormessage = "Creating the datastore from the SQL statement:~r~n~t" + as_select + " returned the following error message:~r~n" + &
							Trim(s_error_message)
	Return FALSE
End If

//-----------------------------------------------------
// Create the DataWindow in the dataStore
//-----------------------------------------------------
If Not IsValid(ads_datastore) Then
	ads_datastore = Create Datastore
End If
ads_datastore.Create(s_dwsyntax,s_error_message)

If Len(s_error_message) > 0 Then
	is_errormessage = "Creating the datastore from the syntax:~r~n~t" + s_dwsyntax + " returned the following error message:~r~n" + &
							Trim(s_error_message)
	Return FALSE
End If

//-----------------------------------------------------
// Retrueve the Values
//-----------------------------------------------------
ads_datastore.SetTransObject(axctn_db)
ads_datastore.Retrieve()

Return TRUE



end function

public function string of_convert_array_to_string (long al_array[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_convert_array_to_string()
// Arguments:   al_array[] - Array of long to be convered
// Overview:    Converts an array to a comma delimited string
// Created by:  Jake Pratt
// History:     08/01/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long ll_Count
long ll_Current
string  s_string

//-----------------------------------------------------
// Get the Amount in teh Array
//-----------------------------------------------------
ll_count = Upperbound(al_array)

//-----------------------------------------------------
// If array is empty then set s_string = '' and return
//-----------------------------------------------------
if ll_count = 0 then 
	s_string = ''
	return s_string
end if


//-----------------------------------------------------
// Get the first value from the array
//-----------------------------------------------------
s_string = string(al_array[1])

//-----------------------------------------------------
// Loop through the array creating teh comma delimited
// string
//-----------------------------------------------------
For ll_current = 2 to ll_count
	s_string = s_string + ',' + string(al_array[ll_current])
Next


return s_string
end function

public function boolean of_get_values (string as_select, ref string as_values[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column
// Arguments:   as_select - Select Statement used to get the column
//					 al_keys[] - Array of key values passed by reference
// Overview:    Create a Datawindow from the Select Statement to get column values into a array
//              *** This Function should be usefull for getting an array value
// Created by:  Jake Pratt
// History:     08/01/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datastore lds_create_datastore
long ll_rows
long ll_current_row

//-----------------------------------------------------
// Create DataStore for of_get_rows to use
//-----------------------------------------------------
lds_create_datastore = Create DataStore


//-----------------------------------------------------
// This function gets the rows.
//-----------------------------------------------------
if NOT of_create_datastore_object(as_select,lds_create_datastore) Then 
	Destroy lds_create_datastore
	Return False	
End If

ll_rows = lds_create_datastore.rowcount()

//-----------------------------------------------------
// Prepare the Values to Be returned
//-----------------------------------------------------
For ll_current_row = 1 to ll_rows
	as_values[ll_current_row] = lds_create_datastore.Object.Data[ll_current_row,1]
Next


Destroy lds_create_datastore


Return True







end function

public function boolean of_get_values (string as_select, ref long al_keys[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column
// Arguments:   as_select - Select Statement used to get the column
//					 al_keys[] - Array of key values passed by reference
// Overview:    Create a Datawindow from the Select Statement to get column values into a array
//              *** This Function should be usefull for getting an array value
// Created by:  Jake Pratt
// History:     08/01/1997 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datastore lds_create_datastore
long ll_rows
long ll_current_row

//-----------------------------------------------------
// Crete DataStore for of_get_rows to use
//-----------------------------------------------------
lds_create_datastore = Create DataStore


//-----------------------------------------------------
// This function gets the rows.
//-----------------------------------------------------
if NOT of_create_datastore_object(as_select,lds_create_datastore) Then 
	Destroy lds_create_datastore
	Return False	
End If

ll_rows = lds_create_datastore.rowcount()

//-----------------------------------------------------
// Prepare the Values to Be returned
//-----------------------------------------------------
For ll_current_row = 1 to ll_rows
	al_keys[ll_current_row] = lds_create_datastore.Object.Data[ll_current_row,1]
Next


Destroy lds_create_datastore


Return True







end function

public function boolean of_add_values (string as_select, ref long al_keys[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_get_column
// Arguments:   as_select - Select Statement used to get the column
//					 al_keys[] - Array of key values passed by reference
// Overview:    Create a Datawindow from the Select Statement and add the values to the array
// Created by:  Kyle Smith from of_get_values
// History:     04/08/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datastore lds_create_datastore
long ll_rows
long ll_current_row

//-----------------------------------------------------
// Crete DataStore for of_get_rows to use
//-----------------------------------------------------
lds_create_datastore = Create DataStore

//-----------------------------------------------------
// This function gets the rows.
//-----------------------------------------------------
if NOT of_create_datastore_object(as_select,lds_create_datastore) Then 
	Destroy lds_create_datastore
	Return False	
End If

ll_rows = lds_create_datastore.rowcount()

//-----------------------------------------------------
// Prepare the Values to Be returned
//-----------------------------------------------------
For ll_current_row = 1 to ll_rows
	al_keys[upperbound(al_keys)+1] = lds_create_datastore.Object.Data[ll_current_row,1]
Next

Destroy lds_create_datastore

Return True

end function

on n_datastore_tools.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datastore_tools.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

