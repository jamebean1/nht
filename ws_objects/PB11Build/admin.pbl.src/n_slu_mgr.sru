$PBExportHeader$n_slu_mgr.sru
$PBExportComments$Simultaneous Logged User module.
forward
global type n_slu_mgr from nonvisualobject
end type
end forward

global type n_slu_mgr from nonvisualobject
end type
global n_slu_mgr n_slu_mgr

type prototypes
Function boolean GetComputerName (ref string  lpBuffer, ref ulong nSize) Library "KERNEL32.DLL" Alias for "GetComputerNameA;Ansi"
end prototypes

type variables
// instance constants for the SLU module

CONSTANT	INTEGER	c_GraceLogins = 0

// Instance variables for the SLU module

DOUBLE	idb_LicenseCount
STRING	is_UserID
STRING	is_ComputerID
end variables

forward prototypes
public function integer uf_deleteuserlogin ()
public function integer uf_getlogininformation ()
public function double uf_licensestokey (double nmbr_licenses)
public function integer uf_verifylicenseinfo ()
public function integer uf_adduserlogin ()
end prototypes

public function integer uf_deleteuserlogin ();/*****************************************************************************************
   Function:   uf_DeleteUserLogin
   Purpose:    Remove a new user login from the active logins table.
   Parameters: NONE
   Returns:    LONG	>= 0 - Success
						     -1 - Failed

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/2/00   M. Caruso    Created.
*****************************************************************************************/

BOOLEAN			lb_Success
STRING			ls_Message = ''
LONG				ll_Row
DS_LOGIN_LIST	lds_Logins

// build the datastore to hold the current login data
lds_Logins = CREATE DS_LOGIN_LIST
lds_Logins.SetTransObject (SQLCA)
IF lds_Logins.Retrieve () > 0 THEN

	// remove the login row if it exists
	ll_Row = lds_Logins.Find ('user_id = ~'' + is_userid + '~' AND computer_id = ~'' + &
										is_computerid + '~'', 1, lds_Logins.RowCount ())
	IF ll_Row > 0 THEN
			
		lds_Logins.DeleteRow (ll_Row)
		IF lds_Logins.Update () = 1 THEN
			lb_Success = TRUE
		ELSE
			ls_message = 'CustomerFocus was unable to completely log you out. ' + &
							 'Please notify your system administrator.'
			lb_Success = FALSE
		END IF
		
	ELSE
		// the login must have failed, so process as if successful.
		lb_Success = TRUE
	END IF
	
ELSE
	// there were no logins found, so process as if successful.
	lb_Success = TRUE
END IF

// destroy the datastore to free up memory
DESTROY lds_Logins

IF lb_Success THEN
	RETURN 0
ELSE
	MessageBox (gs_AppName, ls_Message)
	RETURN -1
END IF
end function

public function integer uf_getlogininformation ();/*****************************************************************************************
   Function:   uf_GetLoginInformation
   Purpose:    Get the user ID and computer ID for the current user.
   Parameters: NONE
   Returns:    INTEGER	0 - Success
							  -1 - Failed

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/2/00   M. Caruso    Created.
*****************************************************************************************/

ULONG		lul_Len = 255
BOOLEAN	lb_Success
STRING	ls_Message, ls_userid, ls_computerid

IF IsValid (SQLCA) THEN

	ls_userid = OBJCA.WIN.fu_GetLogin (SQLCA)
	ls_computerid = Space(lul_Len)
	IF GetComputerName (ls_computerid, lul_Len) THEN ls_computerid = trim (ls_computerid)
	
	IF ls_userid = "" THEN
		ls_Message = 'CustomerFocus was unable to determine your user ID.  Login cannot continue.'
		lb_Success = FALSE
	ELSE
		IF ls_computerid = "" THEN
			ls_Message = 'CustomerFocus was unable to determine your workstation ID.  Login cannot continue.'
			lb_Success = FALSE
		ELSE
			lb_Success = TRUE
		END IF
		
	END IF
	
END IF

IF lb_Success THEN
	is_userid = ls_userid
	is_computerid = ls_computerid
	RETURN 0
ELSE
	RETURN -1
END IF
end function

public function double uf_licensestokey (double nmbr_licenses);/*****************************************************************************************
   Function:   uf_LicensesToKey
   Purpose:    Convert the number of licenses to the equivalent license key.
   Parameters: LONG	nmbr_licenses - the number of licenses.
   Returns:    LONG	The license key for the specified number of licenses.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/2/00   M. Caruso    Created.
*****************************************************************************************/

RETURN (((nmbr_licenses * 100) + 1680) * 80503)
end function

public function integer uf_verifylicenseinfo ();/*****************************************************************************************
   Function:   uf_VerifyLicenseInfo
   Purpose:    Verify that the licensing information is valid
   Parameters: NONE
   Returns:    INTEGER	0 - OK
							  -1 - License information is invalid

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/2/00   M. Caruso    Created.
*****************************************************************************************/

DOUBLE	ldb_NbrLicenses, ldb_LicenseKey
BOOLEAN	lb_Verified
STRING	ls_Message

SELECT nmbr_licenses, license_key INTO :ldb_NbrLicenses, :ldb_LicenseKey
  FROM cusfocus.security WHERE security_id = 1 USING SQLCA;
  
CHOOSE CASE SQLCA.SQLCode
	CASE -1
		ls_Message = 'CustomerFocus was unable to verify user license information. Notify your system administrator.'
		lb_Verified = FALSE

	CASE 0
		// validate the information in the database.
		IF uf_LicensesToKey (ldb_NbrLicenses) = ldb_LicenseKey THEN
			// set the number of licenses verified
			idb_LicenseCount = ldb_NbrLicenses
			lb_Verified = TRUE
		ELSE
			ls_message = 'The current user license information is not valid. ' + &
				          'Notify your system administrator.'
			lb_Verified = FALSE
		END IF
		
	CASE 100
		ls_Message = 'No license information was found.  Notify your system administrator.'
		lb_Verified = FALSE
		
END CHOOSE

IF lb_Verified THEN
	RETURN 0
ELSE
	MessageBox (gs_AppName, ls_Message)
	RETURN -1
END IF
end function

public function integer uf_adduserlogin ();/*****************************************************************************************
   Function:   uf_AddUserLogin
   Purpose:    Add a new user login to the active logins table.
   Parameters: NONE
   Returns:    INTEGER	0 - Success
						     -1 - Failed

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/02/00 M. Caruso    Created.
	02/05/02 M. Caruso    Do not delete existing license records if multiple logins are
	                      made from the same machine.
	02/27/02 M. Caruso    Support multiple logins from the same machine (CITRIX)
*****************************************************************************************/

BOOLEAN			lb_Success
STRING			ls_Message = ''
LONG				ll_Row
DS_LOGIN_LIST	lds_Logins

// build the datastore to hold the current login data
lds_Logins = CREATE DS_LOGIN_LIST
lds_Logins.SetTransObject (SQLCA)
CHOOSE CASE lds_Logins.Retrieve ()
	CASE IS < idb_LicenseCount
		// licensed logins available
		lb_Success = TRUE
		
	CASE idb_LicenseCount TO (idb_LicenseCount + (c_gracelogins - 1))
		// grace login used
		ls_Message = 'Exceeded user license limit. Grace login used.'
		lb_Success = TRUE
		
	CASE ELSE
		// no logins left available
		IF c_gracelogins = 0 THEN
			ls_Message = 'Exceeded user license limit. Please contact your system administrator.'
		ELSE
			ls_Message = 'Exceeded user license limit and no more grace logins are ' + &
						 	 'available. Please contact your system administrator.'
		END IF
		lb_Success = FALSE
		
END CHOOSE

IF lb_Success THEN
	
	// check if login records already exist for this computer (application or system crashed).
	lds_Logins.SetFilter ("computer_id = '" + is_computerid + "'")
	lds_Logins.Filter ()
	CHOOSE CASE lds_Logins.RowCount ()
		CASE 0
			// insert a new login record
			ll_Row = lds_Logins.InsertRow (0)
			lds_Logins.SetItem (ll_Row, 'user_id', is_userid)
			lds_Logins.SetItem (ll_Row, 'computer_id', is_computerid)
			lds_Logins.SetItem (ll_Row, 'login_timestamp', Today ())
			
		CASE 1
			// if the record is for the same user_id, update timestamp
			IF lds_Logins.GetItemString (1, 'user_id') = is_userid THEN
				lds_Logins.SetItem (1, 'login_timestamp', Today ())
			ELSE
			// otherwise, insert a new one
				ll_Row = lds_Logins.InsertRow (0)
				lds_Logins.SetItem (ll_Row, 'user_id', is_userid)
				lds_Logins.SetItem (ll_Row, 'computer_id', is_computerid)
				lds_Logins.SetItem (ll_Row, 'login_timestamp', Today ())
			END IF
			
		CASE IS > 1
			// support multiple logins from same machine (CITRIX) by adding login record
			ll_Row = lds_Logins.InsertRow (0)
			lds_Logins.SetItem (ll_Row, 'user_id', is_userid)
			lds_Logins.SetItem (ll_Row, 'computer_id', is_computerid)
			lds_Logins.SetItem (ll_Row, 'login_timestamp', Today ())
			
		CASE ELSE
			// report an error and close the application.
			ls_Message = 'There was an error checking available licenses.  ' + &
							 'Please contact your system administrator.'
			lb_Success = FALSE
			
	END CHOOSE
	
	lds_Logins.Update ()
	
END IF

// destroy the datastore to free up memory
DESTROY lds_Logins

IF lb_Success THEN
	IF ls_Message <> '' THEN MessageBox (gs_AppName, ls_Message)
	RETURN 0
ELSE
	MessageBox (gs_AppName, ls_Message)
	RETURN -1
END IF
end function

on n_slu_mgr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_slu_mgr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

