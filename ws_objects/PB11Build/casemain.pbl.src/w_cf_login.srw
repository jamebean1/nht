$PBExportHeader$w_cf_login.srw
$PBExportComments$Login window for CustomerFocus
forward
global type w_cf_login from w_pl_login_main
end type
type p_2 from picture within w_cf_login
end type
type st_connection from statictext within w_cf_login
end type
type r_1 from rectangle within w_cf_login
end type
type ln_2 from line within w_cf_login
end type
type ln_1 from line within w_cf_login
end type
type st_2 from statictext within w_cf_login
end type
end forward

global type w_cf_login from w_pl_login_main
integer x = 960
integer y = 284
integer width = 1458
integer height = 1196
string title = "CustomerFocus Login"
long backcolor = 16777215
boolean toolbarvisible = false
p_2 p_2
st_connection st_connection
r_1 r_1
ln_2 ln_2
ln_1 ln_1
st_2 st_2
end type
global w_cf_login w_cf_login

type variables
STRING i_cDBKey
string i_dbname

end variables

forward prototypes
public function integer fw_getdbkey ()
end prototypes

public function integer fw_getdbkey ();//**********************************************************************************************
//
//  Function: fw_getdbkey
//  Purpose:  To get the database key
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  02/19/01 C. Jackson  Original Version
//
//**********************************************************************************************

dw_connections.SetTransObject(SECCA.MGR.i_SecTrans)

LONG l_dbkey

select db_key into :l_dbKey from pl_db where db_name = :i_dbname using SECCA.MGR.i_SecTrans;

RETURN l_dbkey
end function

event open;//******************************************************************
//  PL Module     : w_Login
//  Event         : Open
//  Description   : Initialize window controls.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//		5/4/99	RAE		Centered window on open.  Also turned off
//								visible property of plaque window.
//	 6/2/2000 KMC		   Added code to change bitmaps depending on 
//								application-client setting in the ini file
//******************************************************************
//  Copyright ServerLogic 1994-1995.  All Rights Reserved.
//******************************************************************

LONG l_Rows

SetPointer(HourGlass!)

   IF SECCA.MGR.i_AppTrans.DBMS = "" THEN
      dw_connections.SelectRow(0, FALSE)
      dw_connections.SetTransObject(SECCA.MGR.i_SecTrans)
//      l_Rows = dw_connections.Retrieve(SECCA.MGR.i_AppKey, i_UsrKey)
	END IF


//-----------------------------------------------------------------
//  If registration mode is turned on either because the application
//  is being launched from the administration program, or because
//  it has been turned on in the application's profile, display
//  the registration button on the login window.  If the application
//  has been launched, check it.
//-----------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)  

IF SECCA.MGR.fu_CheckRegister() OR &
   SECCA.MGR.i_RegistrationMode = TRUE OR &
   Pos(CommandParm(), "Object Registration") > 0 THEN
   cbx_registration.Visible = TRUE
   IF Pos(CommandParm(), "Object Registration") > 0 THEN
      cbx_registration.Checked = TRUE
   END IF    
ELSE
   cbx_registration.Visible = FALSE  
END IF

//If installing for a client that wants their own graphics,
//  switch to the client specific graphics
IF Upper( gs_Client ) = "YES" THEN
	p_2.PictureName = "client_logo_c.jpg"
END IF

//If installing for a client that wants their own application name,
//  switch to the client specific name
IF gs_AppName <> "" THEN
	THIS.Title = gs_AppName+" Login"
END IF

IF IsValid(w_plaque) THEN w_plaque.visible = false

end event

on w_cf_login.create
int iCurrent
call super::create
this.p_2=create p_2
this.st_connection=create st_connection
this.r_1=create r_1
this.ln_2=create ln_2
this.ln_1=create ln_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_2
this.Control[iCurrent+2]=this.st_connection
this.Control[iCurrent+3]=this.r_1
this.Control[iCurrent+4]=this.ln_2
this.Control[iCurrent+5]=this.ln_1
this.Control[iCurrent+6]=this.st_2
end on

on w_cf_login.destroy
call super::destroy
destroy(this.p_2)
destroy(this.st_connection)
destroy(this.r_1)
destroy(this.ln_2)
destroy(this.ln_1)
destroy(this.st_2)
end on

type cbx_registration from w_pl_login_main`cbx_registration within w_cf_login
boolean visible = false
integer x = 1230
integer y = 436
integer width = 480
integer textsize = -9
end type

type cbx_default from w_pl_login_main`cbx_default within w_cf_login
integer x = 1161
integer y = 1460
end type

type dw_connections from w_pl_login_main`dw_connections within w_cf_login
integer x = 507
integer y = 816
integer width = 718
integer height = 88
integer taborder = 25
boolean vscrollbar = false
boolean border = false
end type

event dw_connections::itemchanged;call super::itemchanged;//************************************************************************************************
//
//  Event:   itemchanged
//  Purpose: To get the dbkey
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  02/19/01 C. Jackson  Original Version
//  7/27/2001 K. Claver  Added code to set the db key on the security manager.
//
//************************************************************************************************

THIS.AcceptText()


i_dbKey = LONG(data)

//Set security manager db key here as it is not being passed to the change
//  password window.
SECCA.MGR.i_DBKey = i_DBKey


end event

type cb_cancel from w_pl_login_main`cb_cancel within w_cf_login
integer x = 1120
integer y = 996
integer width = 288
end type

type cb_pwd from w_pl_login_main`cb_pwd within w_cf_login
integer x = 407
integer y = 996
integer width = 640
end type

type cb_ok from w_pl_login_main`cb_ok within w_cf_login
integer x = 46
integer y = 996
integer width = 288
fontcharset fontcharset = ansi!
end type

event cb_ok::clicked;//**********************************************************************************************
//
//  PL Module     : w_pl_login_main.cb_OK
//  Event         : Clicked
//  Description   : Validate the login and password. Connect to the
//                  application transaction and retrieve window
//                  object restrictions into the security manager.
//
//  Date     Developer   Description 
//  -------- ----------- -----------------------------------------------------------------------
//  08/05/99 M. Caruso   Copied ancestor script and added call to uf_CheckDBParm.  Set this 
//  							 level to override the ancestor script.
//  09/23/99 M. Caruso   Modified the CLICKED event to check for the user id in the cusfocus_user 
//                       table before permitting a valid login.
//  08/21/00 C. Jackson  Add check for current version against the Version table (SCR 774)
//  09/26/00 C. Jackson  Add check for Out of Office records
//  02/08/01 C. Jackson  Correct version messages
//  03/14/01 C. Jackson  Add code for inactive users (SCR 1498)
//  09/25/01 C. Jackson  Correct messagebox typo (SCR 2396)
//  10/19/2001 K. Claver Added application update engine initialization.
//  5/29/2002 K. Claver  Set the database name into a global variable to be displayed on the help about
//
//**********************************************************************************************


STRING  l_UsrPassword, l_TmpPassword, l_DBInfo[], l_DBName, l_cUserID, l_cAppVersion
STRING  l_cMyVersion, l_cBuildDate, l_cActive, l_cFileChar, l_cFileName = "", l_cFileWithPath
INTEGER l_Check, l_nULCount, l_nRV, l_nIndex, l_nFileIndex, l_nForceUpd
LONG    l_DBKey, l_nOutOfOffice
DataStore l_dsULFiles
n_cst_kernel32 l_nKernelFuncs
Boolean l_bUpdatesExist = FALSE
DateTime l_dtULFileDate, l_dtMachineFileDate
Date l_dDate
Time l_tTime

SetPointer(HourGlass!)

l_UsrPassword = sle_password.text

IF SECCA.MGR.i_UseLogin THEN
	l_Check = SECCA.MGR.fu_CheckUseLogin(sle_login.text, i_Attempts)
ELSE
	l_Check = SECCA.MGR.fu_CheckLogin(sle_login.text, sle_password.text, i_Attempts)
END IF

IF l_Check = 0 THEN

	//---------------------------------------------------------------
	//  Retrieve database connection info from the security database.
	//---------------------------------------------------------------

	//---------------------------------------------------------------
	//  If registration checkbox was checked, set flag indicating
	//  that application should be executed in registration mode.
	//---------------------------------------------------------------

   IF cbx_registration.Checked = TRUE THEN
   	SECCA.MGR.i_RegistrationMode = TRUE

		//------------------------------------------------------------
		//  Create a transaction object for generating unique keys.
		//------------------------------------------------------------

		SECCA.MGR.i_KeyTrans            = CREATE Transaction
		SECCA.MGR.i_KeyTrans.DBMS       = SECCA.MGR.i_SecTrans.DBMS
		SECCA.MGR.i_KeyTrans.Database   = SECCA.MGR.i_SecTrans.Database
		SECCA.MGR.i_KeyTrans.UserId     = SECCA.MGR.i_SecTrans.UserId
		SECCA.MGR.i_KeyTrans.DBPass     = SECCA.MGR.i_SecTrans.DBPass
		SECCA.MGR.i_KeyTrans.LogId      = SECCA.MGR.i_SecTrans.LogId
		SECCA.MGR.i_KeyTrans.LogPass    = SECCA.MGR.i_SecTrans.LogPass
		SECCA.MGR.i_KeyTrans.ServerName = SECCA.MGR.i_SecTrans.ServerName
		SECCA.MGR.i_KeyTrans.DBParm     = SECCA.MGR.i_SecTrans.DBParm

		//-----------------------------------------------------------
		//  Connect to the security database with the key generation
		//  transaction object.  Abort initialization if connection 
		//  fails.
		//-----------------------------------------------------------

		IF SECCA.MGR.fu_connect(SECCA.MGR.i_KeyTrans) = -1 THEN
   		 CloseWithReturn(Parent, -1)
		END IF
		SECCA.MGR.i_KeyTransConnected = TRUE
   ELSE
      SECCA.MGR.i_RegistrationMode = FALSE   
   END IF

	//---------------------------------------------------------------
	//  Start audit trail if opted.
	//---------------------------------------------------------------

   IF SECCA.MGR.i_UseAudit THEN
      SECCA.MGR.fu_BeginAudit()
   END IF

	IF i_DBKey > 0 THEN
      SECCA.MGR.fu_GetDBUserInfo(i_DBKey, l_DBName, l_DBInfo[], &
										 i_UsrLogin, l_UsrPassword)

      SECCA.MGR.i_AppTrans.DBMS       = l_DBInfo[1]
      SECCA.MGR.i_AppTrans.Database   = l_DBInfo[2]
      SECCA.MGR.i_AppTrans.ServerName = l_DBInfo[3]
     	SECCA.MGR.i_AppTrans.UserId     = l_DBInfo[4]
     	SECCA.MGR.i_AppTrans.DBPass	  = l_DBInfo[5]
     	SECCA.MGR.i_AppTrans.LogId		  = l_DBInfo[6]
		SECCA.MGR.i_AppTrans.LogPass	  = l_DBInfo[7]
	   SECCA.MGR.i_AppTrans.DBParm     = l_DBInfo[8]
      SECCA.MGR.i_AppTrans.Lock       = l_DBInfo[9]
      IF l_DBInfo[10] = "0" THEN
         SECCA.MGR.i_AppTrans.AutoCommit = FALSE
      ELSE
         SECCA.MGR.i_AppTrans.AutoCommit = TRUE
      END IF
      
      // make corrections to DBParm if necessary
		uf_CheckDBParm (SECCA.MGR.i_AppTrans)
		
		IF cbx_default.Checked THEN
         l_DBKey = i_DBKey
      ELSE
         l_DBKey = 0
      END IF
		
		//Set the database name into a global variable to be displayed on the help about
		gs_ConnectionName = l_DBName

		//---------------------------------------------------------------
		//  Add default connection id to user table, if a default
		//  was specified on the login window.
		//---------------------------------------------------------------

      l_TmpPassword = ""
      SECCA.MGR.fu_SetUsrInfo(i_UsrKey, l_TmpPassword, &
                                l_DBKey)

      SECCA.MGR.i_UsrKey   = i_UsrKey
      SECCA.MGR.i_UsrLogin = i_UsrLogin
      SECCA.MGR.i_UsrName  = i_UsrName
      SECCA.MGR.i_DBKey    = i_DBKey
      SECCA.MGR.i_DBName   = dw_connections.GetItemString(1,'db_name')
		
		
		//---------------------------------------------------------------
		//  Combine restrictions if more than one role has been
		//  assigned to the user.
		//---------------------------------------------------------------

      SECCA.MGR.TriggerEvent("pld_retrieve")

      l_Check = 0
      IF NOT SECCA.MGR.i_SameTrans THEN
		   l_Check =  SECCA.MGR.fu_connect(SECCA.MGR.i_AppTrans)
			IF l_Check = 0 THEN
				SECCA.MGR.i_AppConnected = TRUE
			END IF
		END IF
		CHOOSE CASE l_Check
//		CASE -1 
//         CloseWithReturn(Parent, -1)
//			i_NewPassword = FALSE
//			SetFocus(sle_login)
      CASE -2
			IF SECCA.MGR.i_GraceAttempts = i_Attempts THEN
       		SECCA.MSG.fu_DisplayMessage("LoginExceeded")
        		SECCA.MGR.fu_SetUsrStatus(0, i_usrlogin)
       		l_Check = -4
//     		ELSE
//      		SECCA.MSG.fu_DisplayMessage("LoginInvalid")
//   			i_Attempts = i_Attempts + 1
//   			i_NewPassword = FALSE
//				SetFocus( sle_password )
   		END IF
		CASE 0 
			// verify the user is setup in the cusfocus_user table
			SELECT user_id, active INTO :l_cUserID, :l_cActive
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :sle_login.text USING SQLCA;
			
			CHOOSE CASE SQLCA.SQLCode
				CASE -1
					MessageBox (gs_AppName,"Unable to verify an account in "+gs_AppName+".~r~n~r~n" + &
					"Possible problems include:~r~n" + &
					"1 - An account has not been set up in CustomerFocus for this user.~r~n" + &
					"2 - An account has not been set up in PowerLock for this user.~r~n" + &
					"3 - This user is either~r~n" + &
					"     a) not set up in your database~r~n" + &
					"     b) the permissions for this user to access the database tables~r~n" + &
					"         has not been turned on.")
					CloseWithReturn(Parent, -1)
					
				CASE 100
					MessageBox (gs_AppName,"You do not have an account in "+gs_AppName+".")
					CloseWithReturn(Parent, -1)
					
				CASE 0
					IF NOT SECCA.MGR.i_RegistrationMode THEN
						IF NOT SECCA.MGR.i_SameTrans THEN
							
							//Rename if file exists from prior download.
							IF FileExists( "fileupdate.exe.bak" ) THEN
								FileDelete( "fileupdate.exe" )
								l_nKernelFuncs.of_FileRename( "fileupdate.exe.bak", "fileupdate.exe" )
							END IF
							
							IF Upper( gs_AppFullVersion ) <> "DEVELOPMENT" THEN
								//Check if there are updates uploaded and download if applicable
								l_dsULFiles = CREATE DataStore
								l_dsULFiles.DataObject = "d_update_files"
								l_dsULFiles.SetTransObject( SECCA.MGR.i_SecTrans )
								l_nULCount = l_dsULFiles.Retrieve( OBJCA.MGR.i_ProgName, &
																			  gs_AppFullVersion, &
																			  l_cUserID, &
																			  i_DBKey )
																			  
								IF l_nULCount > 0 THEN
									//Check the files against the ones in the current directory.  Only
									//  update if a file uploaded does not exist on the machine or the
									//  date of a file on the machine is older than one uploaded.
									FOR l_nIndex = 1 TO l_nULCount
										l_cFileWithPath = l_dsULFiles.Object.update_file_name[ l_nIndex ]
										l_dtULFileDate = l_dsULFiles.Object.update_file_timestamp[ l_nIndex ]
										l_nForceUpd = l_dsULFiles.Object.update_file[ l_nIndex ]
										
										//Reset the file name variable
										l_cFileName = ""
										
										//Get just the file name
										FOR l_nFileIndex = Len( l_cFileWithPath ) TO 1 STEP -1
											l_cFileChar = Mid( l_cFileWithPath, l_nFileIndex, 1 )
											IF l_cFileChar <> "\" THEN
												l_cFileName = ( l_cFileChar+l_cFileName )
											ELSE
												EXIT
											END IF
										NEXT
										
										IF NOT FileExists( l_cFileName ) THEN
											l_bUpdatesExist = TRUE
										ELSE
											//Check file dates
											l_nRV = l_nKernelFuncs.of_GetLastWriteDatetime( l_cFileName, l_dDate, l_tTime )
											
											IF l_nRV = -1 THEN
												//If for some reason there was an error reading the file
												//  date and time on the machine, assume updates exist.
												l_bUpdatesExist = TRUE
											ELSE
												l_dtMachineFileDate = DateTime( l_dDate, l_tTime )
												
												//Compare the file date and time stored to the machine file date and
												//  time.
												IF ( l_dtMachineFileDate < l_dtULFileDate ) OR &
						   						( ( l_dtMachineFileDate > l_dtULFileDate ) AND ( l_nForceUpd = 1 ) ) THEN
													l_bUpdatesExist = TRUE
												END IF
											END IF
										END IF
										
										//If already determined updates exist, can exit.
										IF l_bUpdatesExist THEN
											EXIT
										END IF
									NEXT											
									
									IF l_bUpdatesExist THEN
										l_nRV = MessageBox( gs_AppName, "Updates Exist.  Would you like to update now?", &
																  Question!, YesNo! )
																  
										IF l_nRV = 2 THEN
											l_nRV = MessageBox( gs_AppName, "Are you sure? Select OK to update files, Cancel to abort.", &
																	  Question!, OKCancel! )
										END IF
										
										IF l_nRV = 1 THEN
											IF FileExists( "fileupdate.exe" ) THEN
												Run( "fileupdate.exe "+OBJCA.MGR.i_ProgName+"&"+gs_AppFullVersion+"&"+ &
													  l_cUserID+"&"+String( i_DBKey )+"&cusfocus.exe" )
												HALT CLOSE
											ELSE
												MessageBox( gs_AppName, "Unable to locate Application Update engine.~r~n"+ &
																gs_AppName+" will not be updated" )
											END IF
										END IF
									END IF
								END IF
								
								DESTROY l_dsULFiles
							END IF
							
							IF SECCA.MGR.fu_disconnect(SECCA.MGR.i_SecTrans) = 0 THEN
								
								// Do let user login of they are inactive
								IF l_cActive = 'N' THEN
									messagebox(gs_AppName,'This login is marked inactive.  Please contact your ' + &
									                       'System Administrator.')
									cb_cancel.TriggerEvent(Clicked!)
									HALT
								END IF
								
								// Make sure the application version is current
								l_cBuildDate = STRING(ld_BuildDate,'mmddyyyy')
								l_cMyVersion = gs_AppVersion + l_cBuildDate
								
								SELECT version_nbr INTO :l_cAppVersion FROM cusfocus.version USING SQLCA;
								
								IF l_cAppVersion <> '999999999' THEN
									IF l_cMyVersion < l_cAppVersion THEN
										IF l_cUserID <> 'cfadmin' THEN
//										9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//										IF l_cUserID <> 'sysadmin' THEN
											// Message for user other than System Administrator
											messagebox(gs_AppName,'This installation of '+gs_AppName+' needs to be ' + &
											           'upgraded.  Please contact your System Administrator.')
											cb_cancel.TriggerEvent(Clicked!)
											HALT
										ELSE
											// Message for System Administrator
											messagebox(gs_AppName,'This installation of '+gs_AppName+' needs to be ' + &
											           'upgraded.  Please refer to your upgrade documentation or contact support ' + &
														  'for assistance.')
										END IF
									ELSEIF l_cMyVersion > l_cAppVersion THEN
										IF l_cUserID <> 'cfadmin' THEN
//										9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//										IF l_cUserID <> 'sysadmin' THEN
											messagebox(gs_AppName,'The database needs to be updated to the current version ' + &
											           'of '+gs_AppName+'.  Please contact your System Administrator.')
											cb_cancel.TriggerEvent(Clicked!)
											HALT
										ELSE
											messagebox(gs_AppName,'The version number in the database needs to be updated to the ' + &
											           'current version of '+gs_AppName+'.  Please refer to your upgrade documentation ' + &
														  'or contact support for assistance.')
										END IF
									END IF
								END IF

								SECCA.MGR.i_SecurityConnected = FALSE
							END IF
						END IF
					END IF

					// Check to see if user is marked out of office
					SELECT count(*) INTO :l_nOutOfOffice
					  FROM cusfocus.out_of_office
					 WHERE out_user_id = :l_cUserID
					 USING SQLCA;
					 
					IF l_nOutOfOffice > 0 THEN
						messagebox(gs_AppName,'You are currently marked Out of Office')
					END IF
					
					CloseWithReturn(Parent, 0)
					
			END CHOOSE
      END CHOOSE

   ELSEIF i_DBKey = -1 THEN
      CloseWithReturn(Parent, -1)

   ELSEIF i_DBKey = 0 THEN
      IF SECCA.MGR.i_AppTrans.DBMS = "" THEN
         SECCA.MSG.fu_DisplayMessage("LoginNoDB")  
         CloseWithReturn(Parent, -1)
      END IF
      
      SECCA.MGR.i_UsrKey   = i_UsrKey
      SECCA.MGR.i_UsrLogin = i_UsrLogin
      SECCA.MGR.i_UsrName  = i_UsrName

      SECCA.MGR.TriggerEvent("pld_retrieve")

		IF NOT SECCA.MGR.i_RegistrationMode THEN
			IF NOT SECCA.MGR.i_SameTrans THEN
   		   IF SECCA.MGR.fu_disconnect(SECCA.MGR.i_SecTrans) = 0 THEN
				   SECCA.MGR.i_SecurityConnected = FALSE
			   END IF
			END IF
		END IF

      CloseWithReturn(Parent, 0)
   END IF

END IF
	
IF l_Check = -1 THEN
   i_Attempts = i_Attempts + 1
   i_NewPassword = FALSE
   SetFocus(sle_login)
ELSEIF l_Check = -2 THEN
	SECCA.MSG.fu_DisplayMessage("LoginInvalid")
	i_Attempts = i_Attempts + 1
	i_NewPassword = FALSE
	SetFocus( sle_password )
ELSEIF l_Check = -4 THEN
   cb_cancel.TriggerEvent(Clicked!)
ELSEIF l_Check = -3 THEN
   cb_pwd.TriggerEvent(Clicked!)
END IF


end event

type p_login from w_pl_login_main`p_login within w_cf_login
boolean visible = false
integer x = 1166
integer y = 212
integer width = 480
integer height = 200
end type

type st_password from w_pl_login_main`st_password within w_cf_login
integer x = 151
integer y = 736
integer width = 306
integer textsize = -9
long textcolor = 0
long backcolor = 79748288
string text = "Password"
alignment alignment = right!
end type

type st_login from w_pl_login_main`st_login within w_cf_login
integer x = 238
integer y = 644
integer width = 219
integer textsize = -9
long textcolor = 0
long backcolor = 79748288
string text = "User ID"
alignment alignment = right!
end type

type sle_password from w_pl_login_main`sle_password within w_cf_login
integer x = 503
integer y = 724
integer width = 722
integer weight = 400
fontcharset fontcharset = ansi!
textcase textcase = anycase!
end type

type sle_login from w_pl_login_main`sle_login within w_cf_login
integer x = 503
integer y = 632
integer width = 722
integer weight = 400
fontcharset fontcharset = ansi!
textcase textcase = anycase!
end type

event sle_login::modified;//******************************************************************
//  PL Module     : w_pl_login_main.sle_Login
//  Event         : Modified
//  Description   : Validate user's login.  Display list of
//                  database connections if multiple defined for the 
//                  user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  07/15/97 WBC        Added code to handle automatic change 
//								password processing.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Check, l_nRtn

DataWindowChild l_dwcConnections

i_UsrLogin = text

//------------------------------------------------------------------
//  If password is "changeme", prompt the user to change it.
//------------------------------------------------------------------

l_Check = SECCA.MGR.fu_CheckLoginOnly(text)
IF l_Check = 1 THEN
   cb_pwd.TriggerEvent(Clicked!)
   IF NOT i_NewPassword THEN
   	GOTO Finished
   END IF
END IF

i_UsrKey = SECCA.MGR.fu_GetUsrKey(text, i_UsrName)
SECCA.MGR.i_NumConnections = 0

IF i_UsrKey <> -1 THEN
   IF SECCA.MGR.i_AppTrans.DBMS = "" THEN
		
		l_nRtn = dw_connections.GetChild('db_name', l_dwcConnections)   
		l_dwcConnections.SetTransObject(SECCA.MGR.i_SecTrans)
		l_dwcConnections.Retrieve(SECCA.MGR.i_AppKey, i_UsrKey)
		
      dw_connections.SelectRow(0, FALSE)
      dw_connections.SetTransObject(SECCA.MGR.i_SecTrans)
		
		l_Rows = dw_connections.Retrieve(SECCA.MGR.i_AppKey, i_UsrKey)
		IF l_Rows > 1 THEN
			st_connection.Visible = TRUE
			dw_connections.Visible = TRUE
			dw_connections.Enabled = TRUE
		ELSE
			st_connection.Visible = FALSE
			dw_connections.Visible = FALSE
			dw_connections.Enabled = FALSE
		END IF
      IF l_Rows > 0 THEN
         cbx_default.Checked = FALSE
         i_DBKey = SECCA.MGR.fu_GetDBDefaultKey(i_UsrKey)
			SECCA.MGR.i_DBKey = i_DBKey
			FOR l_Idx = 1 TO l_Rows
				SECCA.MGR.i_DBKeys[l_Idx] = & 
							dw_connections.GetItemNumber(l_Idx, "db_key")
				SECCA.MGR.i_NumConnections++
			END FOR
         IF i_DBKey <> -1 THEN
            FOR l_Idx = 1 TO l_Rows
					IF SECCA.MGR.i_DBKeys[l_Idx] = i_DBKey THEN
                  dw_connections.SelectRow(l_Idx, TRUE)
                  cbx_default.Checked = TRUE
                  EXIT
               END IF
            NEXT
         ELSE
            i_DBKey = dw_connections.GetItemNumber(1, "db_key")
				SECCA.MGR.i_DBKey = i_DBKey
            dw_connections.SelectRow(1, TRUE)
         END IF
//         IF l_Rows > 1 THEN
//            Parent.Height = 1117
//            Parent.Move(Parent.X,(i_ScreenHeight - Parent.Height) / 2)
//         ELSE
//            IF Parent.Height > 700 THEN
//               Parent.Height = 669
//               Parent.Move(Parent.X,(i_ScreenHeight - Parent.Height) / 2)
//            END IF
//         END IF
      ELSEIF l_Rows = 0 THEN
         i_DBKey = 0
      ELSE
         i_DBKey = -1
      END IF
   ELSE
		IF i_Attempts = 1 THEN
      	i_DBKey = 0
		END IF
   END IF
ELSE
   i_DBKey = -1
	THIS.SetFocus( )
END IF

Finished:

IF l_Check = 1 AND NOT i_NewPassword THEN
   cb_cancel.PostEvent(Clicked!)
END IF


end event

type gb_connections from w_pl_login_main`gb_connections within w_cf_login
integer x = 128
integer y = 1344
end type

type p_2 from picture within w_cf_login
integer width = 1458
integer height = 604
string picturename = "NewCFLoginScreenLogo.jpg"
boolean focusrectangle = false
end type

type st_connection from statictext within w_cf_login
boolean visible = false
integer x = 165
integer y = 828
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Connection"
boolean focusrectangle = false
end type

type r_1 from rectangle within w_cf_login
long linecolor = 16777215
integer linethickness = 4
long fillcolor = 79748288
integer x = -5
integer y = 600
integer width = 1467
integer height = 540
end type

type ln_2 from line within w_cf_login
long linecolor = 8421504
integer linethickness = 4
integer beginy = 928
integer endx = 2400
integer endy = 928
end type

type ln_1 from line within w_cf_login
long linecolor = 16777215
integer linethickness = 4
integer beginy = 932
integer endx = 2400
integer endy = 932
end type

type st_2 from statictext within w_cf_login
integer x = 5
integer y = 936
integer width = 2350
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217730
boolean focusrectangle = false
end type

