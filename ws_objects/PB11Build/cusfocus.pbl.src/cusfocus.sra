$PBExportHeader$cusfocus.sra
$PBExportComments$CustomerFocus Application Object
forward
global type cusfocus from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global n_fwca_error error
global message message
end forward

global variables
CONSTANT	INTEGER	gn_sleepmin = 1		// should be set to 5 for production release 
CONSTANT	INTEGER	gn_sleepmax = 180

STR_PCCA 		PCCA
N_OBJCA_MAIN	OBJCA
N_SECCA_MAIN	SECCA
N_FWCA_MAIN		FWCA

INTEGER		gn_sleeptime

STRING 		gs_owner
STRING 		gs_SeachType
STRING      gs_ConfigCaseType
STRING      gs_CaseNoteSecurity
STRING 		gs_Client = "no"
STRING 		gs_AppName = "CustomerFocus"
STRING 		gs_AppVersion
STRING		gs_AppFullVersion
STRING		gs_ConnectionName
//STRING		gs_IIMLoc
STRING		gs_rt_members
STRING		gs_rt_providers
STRING		gs_rt_groups
N_SLU_MGR	gnv_LicenseMgr
CONSTANT DATE ld_BuildDate = Today()

WindowState g_wsWindowState = Normal!

//-----------------------------------------------------------------------------------------------------------------------------------
// Keep a global copy of this object. It holds variables and objects that are used across the system.
//-----------------------------------------------------------------------------------------------------------------------------------
n_globals 	gn_globals
end variables
global type cusfocus from application
string appname = "cusfocus"
event ue_clearcaselocks ( )
end type
global cusfocus cusfocus

type prototypes
FUNCTION ULONG GetModuleHandleA(STRING lpModuleName) LIBRARY "KERNEL32.DLL" alias for "GetModuleHandleA;Ansi"
FUNCTION INT GetModuleUsageA (INT hModule) LIBRARY "KERNEL32.DLL"
FUNCTION INT WinExec  (STRING lpCmdLine, INT nCmdShow) LIBRARY "KERNEL32.DLL" alias for "WinExec;Ansi"
FUNCTION ULONG FindWindowA (long lpClassName, String lpWindowName)  LIBRARY "USER32.DLL" alias for "FindWindowA;Ansi"
FUNCTION INT SetFocus (INT hWndr) LIBRARY "USER32.DLL"
FUNCTION INT SetActiveWindow (UINT hWnd) LIBRARY "USER32.DLL"
FUNCTION INT GetClassName (UINT hWnd, REF STRING Buf, INT MaxLen) LIBRARY "USER32.DLL" alias for "GetClassName;Ansi"
FUNCTION INT ShowWindow(INT hWnd, INT nCmdShow) LIBRARY "USER32.DLL"
end prototypes

forward prototypes
public function string af_getiimloc ()
public subroutine af_initializertsettings ()
end prototypes

event ue_clearcaselocks;/*****************************************************************************************
   Function:   ue_ClearCaseLocks
   Purpose:    Unlock all cases for the current user
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/11/2002 K. Claver    Created.
*****************************************************************************************/
String unlock_proc_odbc, unlock_proc_native, l_cTest
Boolean l_bAutoCommit
String l_cCurrentUser

//Simple but reliable test to make sure the transaction is connected.
SELECT row_id
INTO :l_cTest
FROM cusfocus.one_row
USING SQLCA;

IF SQLCA.SQLCode <> -1 THEN
	l_cCurrentUser = OBJCA.WIN.fu_GetLogin( SQLCA )
	
	l_bAutoCommit = SQLCA.AutoCommit
	SQLCA.AutoCommit = FALSE
	
	IF SQLCA.DBMS = "ODBC" THEN
		DECLARE unlock_proc_odbc PROCEDURE FOR cusfocus.sp_clear_case_locks( :l_cCurrentUser )
		USING SQLCA;
		
		EXECUTE unlock_proc_odbc;
	ELSE
		DECLARE unlock_proc_native PROCEDURE FOR cusfocus.sp_clear_case_locks
		@unlock_user_id = :l_cCurrentUser
		USING SQLCA;
		
		EXECUTE unlock_proc_native;
	END IF
	
	IF SQLCA.SQLCode = -1 THEN
		MessageBox( gs_AppName, "Error executing stored procedure to remove case locks for the user.~r~n"+ &
						"Error Returned:~r~n"+SQLCA.SQLErrText, StopSign!, OK! )
	END IF
	
	SQLCA.AutoCommit = l_bAutoCommit
END IF
end event

public function string af_getiimloc ();//******************************************************************
//  Module    	 : cusfocus
//  Function     : af_GetIIMLoc
//  Parameters   : None
//  Returns      : The path and/or name of the uncompiled pbl
//  Description   : Retrieves the location of the IIM uncompiled PBL
//
//  Date     Developer   Description 
//  -------- ----------- --------------------------------------------
//  5/25/2001 K. Claver  Created
//******************************************************************/
Integer l_nCount
String l_cIIMLoc

SELECT Count( * )
INTO :l_nCount
FROM cusfocus.system_options
WHERE cusfocus.system_options.option_name = 'IIM_PBL_LOCATION'
USING SQLCA;

IF l_nCount > 0 THEN
	SELECT cusfocus.system_options.option_value
	INTO :l_cIIMLoc
	FROM cusfocus.system_options
	WHERE cusfocus.system_options.option_name = 'IIM_PBL_LOCATION'
	USING SQLCA;
END IF

RETURN l_cIIMLoc
end function

public subroutine af_initializertsettings ();//******************************************************************
//  Module    	  : cusfocus
//  Function     : af_InitializeRTSettings
//  Parameters   : None
//  Returns      : None
//  Description  : Retrieves the Real-Time demographics settings
//						 for Members, Providers and Groups and sets the
//						 appropriate global variables.
//
//  Date     Developer   Description 
//  -------- ----------- --------------------------------------------
//  08/18/03 M. Caruso   Created.
//******************************************************************/

// set the Member Real-Time option
SELECT option_value INTO :gs_rt_members
  FROM cusfocus.system_options
 WHERE option_name = 'realtime_members'
 USING SQLCA;
 
// default the option to 'N' if it can not be retrieved from the database.
IF SQLCA.SQLCode <> 0 THEN gs_rt_members = 'N'

// set the Provider Real-Time option
SELECT option_value INTO :gs_rt_providers
  FROM cusfocus.system_options
 WHERE option_name = 'realtime_providers'
 USING SQLCA;
 
// default the option to 'N' if it can not be retrieved from the database.
IF SQLCA.SQLCode <> 0 THEN gs_rt_providers = 'N'

// set the Group Real-Time option
SELECT option_value INTO :gs_rt_groups
  FROM cusfocus.system_options
 WHERE option_name = 'realtime_groups'
 USING SQLCA;
 
// default the option to 'N' if it can not be retrieved from the database.
IF SQLCA.SQLCode <> 0 THEN gs_rt_groups = 'N'
end subroutine

event open;/******************************************************************
  Module    		: cusfocus
  Event         : Open
  Description   : Initializes cusfocus app.

  Change History:

  Date     Person     Description of Change
  -------- ---------- --------------------------------------------
  5/4/99   RAE			 Changed external function call to new 32 bit name

  6/14/99  M. Caruso  Use the FindWindowA function to determine if the
                      application is running instead of GetModuleHandleA.

  6/15/99  M. Caruso  Remove l_nInstanceCount check since it will never be
                      set above 0.

  7/8/99   M. Caruso  Read default search type into global variable
  
  9/13/99  M. Caruso  If app running, close app with HALT instead of HALT CLOSE.
  
  6/2/2000 K. Claver  Added gs_Client and gs_AppName and code to set the gs_AppVersion
  							 and set l_cBitmap depending on the value stored in gs_Client
  05/25/01 K. Claver  Added code to set the library list if there are uncompiled IIM 
  							 datawindows.
  10/16/01 K. Claver  Enhanced to use the registry.
  03/11/02 K. Claver  Added call to event to clear case locks.
  04/04/02 M. Caruso  Commented out code to detect other instances of the application.
  01/22/03 C. Jackson Add Configurable Case Type
  12/01/03 M. Caruso  Added call to af_InitializeRTSettings.
******************************************************************/

INT 				l_nReturn, l_nInstanceCount, l_nRV
ULONG 			l_nAppHandle, l_nClass
LONG           l_nUserKey
STRING 			l_cBitmap, l_cUserName, l_cUserID, l_cLibraryList, l_cIIMLoc
STRING 			l_PC_Managers, l_cRegString, l_cINIFile, l_cUserSecurity
BOOLEAN			l_bSuccess
TRANSACTION    l_tPLTO

SetPointer (HOURGLASS!)

//-------------------------------------------------------------------------------------
//
//		Determine if there is already an instance of this application running.
//
//------------------------------------------------------------------------------------
//l_nAppHandle = GetModuleHandleA("cusfocus.exe")

gnv_LicenseMgr = CREATE n_slu_mgr
gn_globals = Create n_globals

l_PC_Managers = OBJCA.c_UtilityManager + OBJCA.c_TimerManager
l_PC_Managers = l_PC_Managers + OBJCA.c_DateManager
l_PC_Managers = l_PC_Managers + OBJCA.c_FieldManager
OBJCA.fu_CreateManagers (l_PC_Managers)
FWCA.fu_CreateManagers (FWCA.c_MicrohelpManager)

//Moved app version to the d_objca_init_std datawindow to be consistent with PowerLock.
//  Since PowerLock resides over CustomerFocus, needed to put the information into the
//  object manager as the security manager should have its own values.
gs_AppVersion = OBJCA.MGR.i_ProgVersion

//If in development mode, set global app full version variable to "development"
IF Upper( OBJCA.MGR.i_DevMode ) <> "ON" THEN
	gs_AppFullVersion = ( gs_AppVersion+String( ld_BuildDate, "mmddyyyy" ) )
ELSE
	gs_AppFullVersion = "development"
END IF

//Determine if using ini or registry and populate global vars accordingly
IF OBJCA.MGR.i_Source = "R" THEN
	l_cRegString = ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info" )
	
	RegistryGet( ( l_cRegString+"\license" ), "license", RegString!, gs_Owner )
	RegistryGet( l_cRegString, "client", RegString!, gs_Client )
	RegistryGet( l_cRegString, "name", RegString!, gs_AppName )
	RegistryGet( ( l_cRegString+"\search type" ), "default", RegString!, gs_SeachType )
	
	FWCA.MGR.fu_SetApplication ( gs_AppName, gs_AppVersion, l_cBitmap, "", "" )
ELSE
	gs_Owner = ProfileString( OBJCA.MGR.i_ProgINI, "license","license","")
	gs_Client = ProfileString( OBJCA.MGR.i_ProgINI, "application", "client", "" )
	gs_AppName = Trim( ProfileString( OBJCA.MGR.i_ProgINI, "application", "name", "" ) )
	gs_SeachType = ProfileString( OBJCA.MGR.i_ProgINI, "Search Type","default","None" )
	
	FWCA.MGR.fu_SetApplication ( gs_AppName, gs_AppVersion, l_cBitmap, OBJCA.MGR.i_ProgINI, "" )
END IF

//l_nAppHandle = FindWindowA (l_nClass, gs_AppName)
//
//IF l_nAppHandle > 0 THEN
//	MessageBox (gs_AppName, 'The '+gs_AppName+' application is already running.')
//	HALT
//END IF

//------------------------------------------------------------------
//  Set window and DataWindow defaults.
//------------------------------------------------------------------

ToolbarText        = TRUE
ToolbarUserControl = FALSE

FWCA.MGR.fu_SetDefault ("Window", "General", w_main_std.c_ToolbarShowTips)

//If installing for a client that wants their own graphics,
//  switch to the client specific graphics
IF Upper ( gs_Client ) = "YES" THEN
	l_cBitmap = "client_logo_c.jpg"
ELSE
	l_cBitmap = "logo_c.jpg"
END IF
 
//------------------------------------------------------------------
//  Display the plaque window.
//------------------------------------------------------------------

Open(w_cf_plaque)

l_tPLTO = CREATE Transaction

IF OBJCA.MGR.i_Source = "R" THEN
	l_nReturn = OBJCA.WIN.fu_GetConnectInfo( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\PowerLock Connect Info" ), l_tPLTO )
ELSE
	l_nReturn = OBJCA.WIN.fu_GetConnectInfo( OBJCA.MGR.i_ProgINI,'PowerLock', l_tPLTO)
END IF

IF l_nReturn = 0 THEN
	SECCA.fu_CreateManagers ()

// close the splash screen
	Close(w_cf_plaque)

	IF SECCA.MGR.fu_Login (THIS,  l_tPLTO, SQLCA, l_cBitmap) <> -1 THEN
		SECCA.MGR.fu_GetUsrInfo (l_nUserKey, l_cUserID, l_cUserName)
//		JWhite	Changed 9.1.2006 - SQL2005 mandates changing from sysadmin
//		IF UPPER (l_cUserID) = 'SYSADMIN' THEN
		IF UPPER (l_cUserID) = 'CFADMIN' THEN
			l_bSuccess = TRUE
		ELSE
			// only allow the login if licenses are available.
			IF gnv_LicenseMgr.uf_VerifyLicenseInfo () = 0 THEN
				IF gnv_LicenseMgr.uf_GetLoginInformation () = 0 THEN
					IF gnv_LicenseMgr.uf_AddUserLogin () = 0 THEN
						l_bSuccess = TRUE								
						
						//Clear all case locks for the current user
						THIS.Event Trigger ue_ClearCaseLocks( )
					ELSE
						l_bSuccess = FALSE
					END IF
				ELSE
					l_bSuccess = FALSE
				END IF
			ELSE
				l_bSuccess = FALSE
			END IF
		END IF
		
//		//If login successful, add the reports library(if the value is set).
//		IF l_bSuccess THEN
//			//Get the location of the IIM report library and add it to the
//			//  library list.
//			gs_IIMLoc = af_GetIIMLoc( )
//			IF NOT IsNull( gs_IIMLoc ) AND Trim( gs_IIMLoc ) <> "" THEN
//				//Set the library list variable
//				l_cLibraryList = GetLibraryList( )
//				//Need to parse off the exe
//				l_cLibraryList = Mid( l_cLibraryList, ( Pos( l_cLibraryList, "," ) + 1 ) )
//				//Set the library list with the iim reports uncompiled pbl
//				l_nRV = SetLibraryList( l_cLibraryList+","+gs_IIMLoc )
//				IF l_nRV = -2 THEN
//					MessageBox( gs_AppName, "Library list incorrect or incomplete" )
//					l_bSuccess = FALSE
//				END IF
//			END IF
//		END IF

		// Get Configurable Case Type
		SELECT option_value INTO :gs_ConfigCaseType 
		  FROM cusfocus.system_options
		 WHERE option_name = 'configurable case type'
		 USING SQLCA;
		 
		// Get Default Security
		SELECT option_value INTO :gs_CaseNoteSecurity
		  FROM cusfocus.system_options
		 WHERE option_name = 'case note security'
		 USING SQLCA;
		 
		SELECT confidentiality_level INTO :l_cUserSecurity
		  FROM cusfocus.cusfocus_user
		 WHERE user_id = :l_cUserId
		 USING SQLCA;
		 
		IF gs_CaseNoteSecurity = 'user' or LONG(gs_CaseNoteSecurity) > LONG(l_cUserSecurity) THEN
			
			gs_CaseNoteSecurity = l_cUserSecurity
			
		END IF
		
		// Get Real-Time Demographics Settings
		af_InitializeRTSettings ()
	 
	ELSE
		l_bSuccess = FALSE
	END IF
ELSE
	l_bSuccess = FALSE
END IF

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite	Added 10.6.2004	Creating a global variable object that will house 
//											global variables and objects.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.of_init()

pcca.parm[1] = ''

// close the splash screen
IF IsValid(w_cf_plaque) THEN
	Close(w_cf_plaque)
END IF

// open the application window if login is successful
IF l_bSuccess THEN
	SetPointer(HOURGLASS!)	
	Open(w_MDI)
ELSE
	HALT CLOSE
END IF


end event

event systemerror;//*********************************************************************************************
//
//  Event:  SystemError 
//  Purpose: Attempt to trap an OLE error with Word 6.0
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  09/25/01 C. Jackson  Correct messagebox typos (SCR 2391)
//  01/25/02 M. Caruso   Removed referenced to i_olecorrespondence. It is no longer used.
//*********************************************************************************************


CHOOSE CASE Error.Number
	CASE 35

		CHOOSE CASE Error.Object

			CASE 'u_case_correspondence', 'w_batch_correspondence'

				CHOOSE CASE Error.ObjectEvent

					CASE 'fu_printcorrespondence', 'fu_editcorrespondence','fw_printcorrespondence'

//						IF Error.Object = 'u_case_correspondence' THEN
//							w_create_maintain_case.i_uoCaseCorrespondence.i_oleCorrespondence.DisconnectObject() 
//							DESTROY w_create_maintain_case.i_uoCaseCorrespondence.i_oleCorrespondence
//						ELSE
//							w_batch_correspondence.i_oleCorrespondence.DisconnectObject() 
//							DESTROY w_batch_correspondence.i_oleCorrespondence
//						END IF

						MessageBox(gs_AppName, 'An error has occurred while trying to ' + &
		'create correspondence.  Contact your system administrator to make sure that the ' + &
		'template you are tying to access exists, or is located in the correct directory.' + &
		'  Also have your system administrator check the Bookmark names in the template.')

					CASE ELSE

						MessageBox('PowerBuilder Application Execution Error ' + String(Error.Number), &
							Error.Text + ' in ' + Error.Object + ' in ' + Error.ObjectEvent + 'at line ' + String(Error.Line))

				END CHOOSE
				
			CASE ELSE

				MessageBox('PowerBuilder Application Execution Error ' + String(Error.Number), &
							Error.Text + ' in ' + Error.Object + ' in ' + Error.ObjectEvent + 'at line ' + STring(Error.Line))
				
		END CHOOSE

	CASE ELSE

		MessageBox('PowerBuilder Application Execution Error ' + String(Error.Number), &
							Error.Text + ' in ' + Error.Object + ' in ' + Error.ObjectEvent + 'at line ' + STring(Error.Line))
		
END CHOOSE

MessageBox(gs_AppName, 'An error has occurred which is causing '+gs_AppName+' to exit.  It is highly recommended that you exit Windows, then restart Windows and '+gs_AppName+'.  Sorry for the inconvenience!')

IF IsValid(w_mdi) THEN
	m_mdi.m_file.m_exit.TriggerEvent(Clicked!)
END IF

end event

on cusfocus.create
appname="cusfocus"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create n_fwca_error
end on

on cusfocus.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event idle;/*****************************************************************************************
   Event:      idle
   Purpose:    Place the application into sleep mode

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	05/25/01 M. Caruso    Created.
*****************************************************************************************/

w_mdi.fw_Sleep ()
end event

event close;//******************************************************************
//  Module    	 : cusfocus
//  Event         : Close
//  Description   : Closes the cusfocus app.
//
//  Date     Developer   Description 
//  -------- ----------- --------------------------------------------
//  7/8/99   M. Caruso   Save default search type to INI file.
//  03/30/00 C. Jackson  Updated Constact gs_AppVersion to 3.0 (SCR 479)
//  10/16/2001 K. Claver Enhanced for use of registry.
//  3/11/2002 K. Claver  Added call to event to clear case locks.
//******************************************************************/

String l_cRegString
ULong l_nConnect

//-----------------------------------------------------------------------------------------------------------------------------------
// JDW	Added 10.6.2004	Destroy the n_globals object
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy n_globals

// Save the default Search Type
IF OBJCA.MGR.i_Source = "R" THEN
	l_cRegString = ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\search type" )
	RegistrySet( l_cRegString, "default", RegString!, gs_seachtype )
ELSE
	SetProfileString(OBJCA.MGR.i_ProgINI, "Search Type", "default", gs_seachtype)
END IF

//Clear all case locks for the current user
THIS.Event Trigger ue_ClearCaseLocks( )

gnv_LicenseMgr.uf_DeleteUserLogin ()

SECCA.fu_DestroyManagers()

FWCA.fu_DestroyManagers()

OBJCA.fu_DestroyManagers()
end event

