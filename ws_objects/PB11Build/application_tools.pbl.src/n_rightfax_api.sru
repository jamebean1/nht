$PBExportHeader$n_rightfax_api.sru
forward
global type n_rightfax_api from nonvisualobject
end type
end forward

global type n_rightfax_api from nonvisualobject
end type
global n_rightfax_api n_rightfax_api

type prototypes
//-----------------------------------------------------------------------------------------------------------------------------------
// These are the Right Fax General Server Functions that are needed for the RF API
//-----------------------------------------------------------------------------------------------------------------------------------
FUNCTION LONG	RFaxCreateServerHandle(String lpServerName, UInt COMMPROTOCOL_TCPIP, ulong lpdwError)	LIBRARY "rfwin32.dll" alias for "RFaxCreateServerHandle;Ansi"
FUNCTION LONG	RFaxCloseServerHandle(ulong hServer) LIBRARY "rfwin32.dll"
FUNCTION LONG	RFaxGetServerInfo(ulong hServer, Ref str_pserverinfo pServerInfo)	LIBRARY "rfwin32.dll" alias for "RFaxGetServerInfo;Ansi"

FUNCTION LONG	RFaxGetFileList2(ulong hServer, uint usLogicalServerDir, string pszFileSpec, uint sInfoLevel, ulong lpLH) LIBRARY "rfwin32.dll" alias for "RFaxGetFileList2;Ansi"
FUNCTION LONG	RFaxGetFaxList(ulong hServer, REF string lpUserID, ulong usInfoLevel, ulong usFolder, ulong usFaxFilter, REF long lpLH) LIBRARY "rfwin32.dll" alias for "RFaxGetFaxList;Ansi"
FUNCTION	LONG	RFaxGetNextFax2(ulong hServer, REF string lpUserID, REF str_faxinfo_10 lpFI10)	LIBRARY "rfwin32.dll" alias for "RFaxGetNextFax2;Ansi"
FUNCTION LONG	RFaxGetNewFax(ulong hServer, REF string lpUserID, REF string lpDestDir, REF str_faxinfo_10 lpFI10)  LIBRARY "rfwin32.dll" alias for "RFaxGetNewFax;Ansi"

FUNCTION LONG	RFaxFileRead(ulong hServer, uint usLogicalServerDir, string pszSourceFile, string pszDestinationDir) LIBRARY "rfwin32.dll" alias for "RFaxFileRead;Ansi"
FUNCTION Long	RFaxFileWrite(ulong hServer, uint usLogicalServerDir, string pszDestinationFile, string pszLocalFileSpec) LIBRARY "rfwin32.dll" alias for "RFaxFileWrite;Ansi"
FUNCTION Long	RFaxFileCopy(ulong hServer, uint usLogServerSrcDir, string pszSrcFile, uint usLogServerDstDir, string pszDstFile) LIBRARY "rfwin32.dll" alias for "RFaxFileCopy;Ansi"
FUNCTION LONG	RFaxFileDelete(ulong hServer, uint usLogServerSrcDir, string pszSrcFile) LIBRARY "rfwin32.dll" alias for "RFaxFileDelete;Ansi"


//-----------------------------------------------------------------------------------------------------------------------------------
// Right Fax Fax Handling Functions
//-----------------------------------------------------------------------------------------------------------------------------------
FUNCTION LONG	RFaxLoadFax(ulong hServer, ulong hFax, string pszLocalDir, long lpReserved1, REF str_faxinfo_10 lpFI10)	LIBRARY "rfwin32.dll" alias for "RFaxLoadFax;Ansi"
FUNCTION LONG 	RFaxLoadFax2(ulong hServer, ulong hFax, string pszLocalDir, uint usLoadImageOpts, REF string lpReserved1, REF str_faxinfo_10 lpFI10)  LIBRARY "rfwin32.dll" alias for "RFaxLoadFax2;Ansi"
FUNCTION LONG 	RFaxDeleteFax(ulong hServer, ulong hFax)	LIBRARY "rfwin32.dll"

FUNCTION LONG 	RFaxCloseListHandle(ulong hList) LIBRARY "rfwin32.dll"


//-----------------------------------------------------------------------------------------------------------------------------------
// Right Fax User Functions 
//-----------------------------------------------------------------------------------------------------------------------------------
FUNCTION	LONG 	RFaxGetUserList(ulong hServer, int sInfoLevel, REF ulong lpLH) LIBRARY "rfwin32.dll"
FUNCTION LONG  RFaxVerifyUser(ulong hServer, REF string lpUserID, REF string lpPassword, boolean bAdminLogin) LIBRARY "rfwin32.dll" alias for "RFaxVerifyUser;Ansi"
FUNCTION LONG  RFaxLoadUser(ulong hServer, ulong hUser, REF string lpUserID, REF string lpRouteInfo, REF string lpDSName, REF str_userinfo_10 lpUl10) LIBRARY "rfwin32.dll" alias for "RFaxLoadUser;Ansi"

//-----------------------------------------------------------------------------------------------------------------------------------
// Right Fax Group Functions
//-----------------------------------------------------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------------------------------------------------
// Right Fax Printer Functions
//-----------------------------------------------------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------------------------------------------------
// Right Fax Library Document Functions
//-----------------------------------------------------------------------------------------------------------------------------------




//-----------------------------------------------------------------------------------------------------------------------------------
// Right Fax Folder Functions
//-----------------------------------------------------------------------------------------------------------------------------------




end prototypes

type variables
/*
type str_blendfunction from structure
character blendop
character blendflags
character sourceconstantapp
character alphaformat
end type

Probable external function declaration:

function long AlphaBlend (ulong hdcDest, ulong xDest, ulong yDest, ulong
widthDest, ulong heightDest, ulong hdcSource, ulong xSource, ulong
ySource, ulong widthSource, ulong heightSource, str_blendfunction
str_blend) library "msimg32.dll"
*/


end variables

forward prototypes
public subroutine of_close_server_handle (long al_handle)
public subroutine of_get_configuration (ref string as_servername, ref long al_commprotocol)
public function long of_get_file_list (long al_handle, long al_logdir, string as_pszfilespec)
public function long of_get_server_handle (string as_servername, long al_commprotocol, ref string as_errormsg)
public function long of_get_user_fax_list (long al_serverhandle, string as_userid, long al_infolevel, long al_folder, long al_faxfilter)
public subroutine of_close_faxlist_handle (long al_handle)
public subroutine of_get_server_info (long al_handle, str_pserverinfo astr_serverinfo)
public function long of_get_fax_info (long al_server_handle, long al_fax_handle, string as_local_directory, integer ai_load_image_options, string as_null, str_faxinfo_10 astr_faxinfo_10)
public function long of_get_new_fax (long al_handle, string as_userid, string as_dest_dir, str_faxinfo_10 astr_faxinfo_10)
public function long of_get_next_fax (long al_server_handle, ref string as_userid, str_faxinfo_10 astr_faxinfo_10)
end prototypes

public subroutine of_close_server_handle (long al_handle);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  al_handle 	- Handle to the RightFax Server
//	Overview:   Closes the handle to the RightFax server.
//	Created by:	Joel White
//	History: 	2/23/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Close the connection with the server and release the memory
//-----------------------------------------------------------------------------------------------------------------------------------
RFaxCloseServerHandle(al_handle)
end subroutine

public subroutine of_get_configuration (ref string as_servername, ref long al_commprotocol);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  ref 	as_servernanme 	- This is a reference variable that will get set to the server name that is retrieved
//					ref	al_commprotocol	-	Reference variable that tells us what communications protocol to use (TCP/IP, SPX, etc)
//	Overview:   Retrieves the RightFax configuration variables from the cusfocus.system_options table
//	Created by:	Joel White
//	History: 	2/23/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Get the value for the server name
//-----------------------------------------------------------------------------------------------------------------------------------
  SELECT cusfocus.system_options.option_value  
    INTO :as_servername  
    FROM cusfocus.system_options  
   WHERE cusfocus.system_options.option_name = 'rightfax_server'   
				;

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the value for the Communications Protocol, but currently we will only use TCP/IP
//-----------------------------------------------------------------------------------------------------------------------------------
  SELECT Convert(int, cusfocus.system_options.option_value)
    INTO :al_commprotocol  
    FROM cusfocus.system_options  
   WHERE cusfocus.system_options.option_name = 'rightfax_commprotocol'   
           ;


//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if the values are populated correctly
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_servername) or as_servername = '' Then
	gn_globals.in_messagebox.of_messagebox('There was a problem determining the RightFax server name. Please contact your system administrator.', Exclamation!, OK!, 1)
End If

If IsNull(al_commprotocol) or al_commprotocol < 1 Or al_commprotocol > 5 Then
	gn_globals.in_messagebox.of_messagebox('There was a problem determining the RightFax communication protocol. Please contact your system administrator.', Exclamation!, OK!, 1)
End If
end subroutine

public function long of_get_file_list (long al_handle, long al_logdir, string as_pszfilespec);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  al_handle 	- Handle to the RightFax server
//					al_logdir	-	Constant that tells us what RF directory to look in for faxes
//					as_pszfilespec - 
//	Overview:   Gets a handle to a structure that contains a list of faxes for a directory and information about the fax.
//	Created by:	Joel White
//	History: 	2/23/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
CONSTANT UInt LOGDIR_NONE = 0
ulong		ll_handle, ll_lpLH_handle
long		ll_structure_handle

ll_handle = al_handle

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function that gets the file list on the server. This returns a handle to the structure of the file list.
//-----------------------------------------------------------------------------------------------------------------------------------
//FUNCTION LONG	RFaxGetFileList2(ulong hServer, uint usLogicalServerDir, string pszFileSpec, uint sInfoLevel) LIBRARY "rfwin32.dll"
ll_structure_handle = RFaxGetFileList2(ll_handle, al_logdir, as_pszFileSpec, 0, ll_lpLH_handle)


Return ll_structure_handle
end function

public function long of_get_server_handle (string as_servername, long al_commprotocol, ref string as_errormsg);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_servername - The RightFax server you want to connect to
//					al_commprotocol - The Communications protocol to use to connect with the RightFax server
//	Overview:   This script is used to get a handle to the RightFax server object. This handle will be needed for pretty
//					much every function call, so it should be done up front and stored into a variable.
//
//					Also the handle uses memory so be sure to call the handle release function or the application will leak
//					memory.
//	Created by:	Joel White
//	History: 	2/23/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long		ll_serverhandle
ulong		ll_error
long		ll_return = 0
string	ls_servername
CONSTANT uint		COMMPROTOCOL_TCPIP = 4


//-----------------------------------------------------------------------------------------------------------------------------------
// Check to ensure valid arguments were passed in.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_servername) or as_servername = '' Then
	as_errormsg = 'A blank servername was used. Please ensure you have a value in the System Options for the RightFax server.'
	ll_return = -1
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Call the external function that gets a handle to the RightFax server
//-----------------------------------------------------------------------------------------------------------------------------------
If	ll_return >= 0 Then
	ll_serverhandle = RFaxCreateServerHandle(as_servername, al_commprotocol, ll_error)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Catch the return error code and analyze it to see what happened.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose case ll_error
	Case 0 
		ll_return = ll_serverhandle
	Case 2
		as_errormsg = 'File or object not found'
		ll_return = -1
	Case 3
		as_errormsg = 'Path not found'
		ll_return = -1
	Case 87
		as_errormsg = 'Invalid argument was passed to the function'
		ll_return = -1
	Case 10012
		as_errormsg = 'The API call made is not supported on the current platform'
		ll_return = -1
	Case -1
		//Do Nothing, just don't overwrite the error message from above
	Case Else
		as_errormsg = 'RightFax returned error code ' + String(ll_error)
		ll_return = -1
End Choose


Return ll_return
end function

public function long of_get_user_fax_list (long al_serverhandle, string as_userid, long al_infolevel, long al_folder, long al_faxfilter);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	2/23/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


str_userinfo_10 lstr_userinfo_10

//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declaration 
//-----------------------------------------------------------------------------------------------------------------------------------
ulong		ll_serverhandle
long		ll_return, ll_listhandle
string	ls_password, ls_username, ls_emptystring

ls_password = '1113out76'
ls_username	= 'Administrator'
ls_emptystring = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert the long to a ulong just in case
//-----------------------------------------------------------------------------------------------------------------------------------
ll_serverhandle = al_serverhandle


//FUNCTION ULONG RFaxVerifyUser(ulong hServer, string lpUserID, string lpPassword, boolean bAdminLogin) LIBRARY "rfwin32.dll"
ll_return = RFaxVerifyUser(ll_serverhandle, as_userid,ls_password , FALSE)

//FUNCTION ULONG RFaxLoadUser(ulong hServer, ulong hUser, string lpUserID, string lpRouteInfo, string lpDSName, REF str_userinfo_10 lpUl10) LIBRARY "rfwin32.dll"
ll_return = RFaxLoadUser(ll_serverhandle, 0, ls_username, ls_emptystring, ls_emptystring, lstr_userinfo_10)


//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function taht will return a handle to the fax list structure
//-----------------------------------------------------------------------------------------------------------------------------------
//FUNCTION LONG	RFaxGetFaxList(ulong hServer, string lpUserID, ulong usInfoLevel, ulong usFolder, ulong usFaxFilter, ulong lpLH) LIBRARY "rfwin32.dll"
ll_return = RFaxGetFaxList(ll_serverhandle, as_userID, 0, 0, 0, ll_listhandle)


//-----------------------------------------------------------------------------------------------------------------------------------
// Check the handle returned to see if the function call succeeded or not. If not return an error.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case ll_return
	Case 0
		//Success
	Case Else
		Return -1
End Choose


//-----------------------------------------------------------------------------------------------------------------------------------
// Return the handle
//-----------------------------------------------------------------------------------------------------------------------------------
Return ll_listhandle
end function

public subroutine of_close_faxlist_handle (long al_handle);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  al_handle	- handle to the Right Fax Server
//	Overview:   Closes the handle to the filelist structure and frees the memory it was using up.
//	Created by:	Joel White
//	History: 	2/23/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function that will close the handle and release the memory
//-----------------------------------------------------------------------------------------------------------------------------------
RFaxCloseListHandle(al_handle)
end subroutine

public subroutine of_get_server_info (long al_handle, str_pserverinfo astr_serverinfo);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  i_arg 	- ReasonForArgument
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	2/23/2006 - First Created   
//-----------------------------------------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
ulong	ll_handle, ll_return
str_pserverinfo lstr_pserverinfo


ll_handle = al_handle

//-----------------------------------------------------------------------------------------------------------------------------------
// This function calls takes a reference to the server info structure and populates it for the given server handle.
//-----------------------------------------------------------------------------------------------------------------------------------
//FUNCTION LONG	RFaxGetServerInfo(ulong hServer, Ref str_pserverinfo pServerInfo)	LIBRARY "rfwin32.dll"
ll_return = RFaxGetServerInfo(ll_handle, astr_serverinfo)






end subroutine

public function long of_get_fax_info (long al_server_handle, long al_fax_handle, string as_local_directory, integer ai_load_image_options, string as_null, str_faxinfo_10 astr_faxinfo_10);string	ls_null, ls_owner
ulong		ll_serverhandle, ll_faxhandle
uint		ll_numpages
long		ll_return

If al_server_handle = -1 Then
	Return -1
End If

ll_serverhandle = al_server_handle
ll_faxhandle = al_fax_handle

SetNull(ls_null)

//FUNCTION ULONG RFaxLoadFax2(ulong hServer, ulong hFax, string pszLocalDir, uint usLoadImageOpts, string lpReserved1, REF str_faxinfo_10 lpFI10)  LIBRARY "rfwin32.dll"
ll_return = RFaxLoadFax2(ll_serverhandle, ll_faxhandle, as_local_directory, ai_load_image_options, ls_null, astr_faxinfo_10)

ls_owner = astr_faxinfo_10.owner_id[22]
ll_numpages = astr_faxinfo_10.numpages


Choose Case ll_return
	Case	0
		Return ll_return
	Case Else
		Return -1
End Choose





end function

public function long of_get_new_fax (long al_handle, string as_userid, string as_dest_dir, str_faxinfo_10 astr_faxinfo_10);//FUNCTION ULONG RFGetNewFax(ulong hServer, string lpUserID, string lpDestDir, REF str_faxinfo_10 lpFI10)

ulong	lul_return, lul_faxhandle

lul_return = RFaxGetNewFax(al_handle, as_userid, as_dest_dir, astr_faxinfo_10)


Return astr_faxinfo_10.handle

end function

public function long of_get_next_fax (long al_server_handle, ref string as_userid, str_faxinfo_10 astr_faxinfo_10);

//-----------------------------------------------------------------------------------------------------------------------------------
// Variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long					ll_fax_handle, ll_number_pages
ulong					ll_return, ll_server_handle
str_faxinfo_10		lstr_faxinfo_10

ll_server_handle = al_server_handle




//-----------------------------------------------------------------------------------------------------------------------------------
// Call the function that will return a structure that contains the handle to the fax
//-----------------------------------------------------------------------------------------------------------------------------------
//FUNCTION	ULONG	RFGetNextFax2(ulong hServer, string lpUserID, REF structure lpFI10)	LIBRARY "rfwin32.dll"
ll_return = RFaxGetNextFax2(ll_server_handle, as_userid, lstr_faxinfo_10)

//ll_fax_handle = astr_faxinfo_10.handle
//ll_number_pages = astr_faxinfo_10.numpages

Return ll_return
end function

on n_rightfax_api.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_rightfax_api.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

