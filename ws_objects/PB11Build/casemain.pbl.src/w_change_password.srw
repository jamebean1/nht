$PBExportHeader$w_change_password.srw
$PBExportComments$Change Password window based on w_pl_newowd_main
forward
global type w_change_password from w_pl_newpwd_main
end type
end forward

global type w_change_password from w_pl_newpwd_main
end type
global w_change_password w_change_password

forward prototypes
public function integer fw_checkoldpwd (string usr_login, string usr_pwd)
end prototypes

public function integer fw_checkoldpwd (string usr_login, string usr_pwd);/****************************************************************************************
  Function      : fw_CheckOldPwd
  Description   : Validates the old password when a user is
                  attempting to change to a new password.

  Return        :  0 = old password correct
                  -1 = old password entered incorrectly

  Change History:

  Date     Person     Description of Change
  -------- ---------- -------------------------------------------------------------------
  8/24/99  M. Caruso  Created, based on SECCA.MGR.fu_CheckOldPwd.  Added call to
                      uf_CheckDbParm to handle extended parameters in the connect string.

****************************************************************************************/

STRING  l_Pwd, l_Password, l_DBInfo[], l_DBName

//------------------------------------------------------------------
//  If the user login and password are being used to login to the
//	 database, connect to the database to verify that the old 
//  password is correct.
//------------------------------------------------------------------

IF SECCA.MGR.i_UseLogin THEN
	IF SECCA.MGR.i_DBKey > 0 THEN
      SECCA.MGR.fu_GetDBUserInfo(SECCA.MGR.i_DBKey, l_DBName, l_DBInfo[], &
										 	usr_login, usr_pwd)

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
		
		uf_CheckDBParm (SECCA.MGR.i_AppTrans)
		      	
      IF SECCA.MGR.fu_connect(SECCA.MGR.i_AppTrans) <> 0 THEN
         SECCA.MSG.fu_DisplayMessage("PwdOldIncorrect")
   		RETURN -1
		ELSE
   		SECCA.MGR.fu_disconnect(SECCA.MGR.i_AppTrans)
			RETURN 0
		END IF
	END IF
ELSE
	IF SECCA.MGR.i_UseEncrypt THEN
		l_Password = SECCA.MGR.fu_EncryptPWD(usr_pwd)
	ELSE
		l_Password = usr_pwd
	END IF

	SELECT usr_pwd INTO :l_Pwd
   	FROM pl_usr WHERE usr_login = :usr_login AND usr_pwd = :l_Password
   	USING SECCA.MGR.i_SecTrans;

	IF SECCA.MGR.i_SecTrans.SQLCode <> 0 THEN
      SECCA.MSG.fu_DisplayMessage("PwdOldIncorrect")
   	RETURN -1
	END IF
END IF

RETURN 0
end function

on w_change_password.create
call super::create
end on

on w_change_password.destroy
call super::destroy
end on

event pl_changepwd;/****************************************************************************************
  Event         : pl_changepwd
  Description   : User coded event to allow passwords to be
						  changed in application databases when the user's
						  login and password are used to connect.  Prior
						  to performing the password change a connection
						  must be made to the database.

	 Parameters    : UserLogin - the user's login ID.

                  OldPassword - the old password.

                  NewPassword - the new password.

                  PwdTrans - transaction object needed to connect to
									    an application database.  The parameters
									    are those that were defined in the
									    connections profile in the Security
									    Administration program.

						  PwdChanged - this indicator must be set to
									      TRUE if this event has been coded 
									      to perform the password change,
								         otherwise a message box will be
									      presented to the user telling them
									      that the password change event has
                               not been implemented.

  Return        : BOOLEAN - TRUE if an error occurs,
                            FALSE if OK

  Change History:

  Date     Person     Description of Change
  -------- ---------- -------------------------------------------------------------------
  8/24/99  M. Caruso  Created, based on the ancestor script which this overrides.
  7/27/2001 K. Claver Added condition by MS SQL Server(SQL Server) for Sybase System 11.
  7/31/2001 K. Claver Commented out disconnects of PwdTrans as the disconnect clears
  							 the error messages returned from the server if a password change
							 fails.  Moved the disconnect to the clicked event of the ok button.
****************************************************************************************/

STRING l_SQLString

//----------------------------------------------------------------
//  Set the flag to tell PowerLock that this event has been coded.
//----------------------------------------------------------------

PwdChanged = TRUE

//----------------------------------------------------------------
//  Connect to the database and change the password.
//----------------------------------------------------------------

CONNECT USING PwdTrans;

//CHOOSE CASE PwdTrans.SQLReturnData
//	CASE "Microsoft SQL Server", "SQL Server"
//		l_SQLString = "sp_password '" + OldPassword + "','" + NewPassword + "'"
//		
//	CASE "ORACLE 8.x"
//		l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + NewPassword
//		
//	CASE "Sybase"
//		l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + NewPassword
//		
//END CHOOSE

CHOOSE CASE PwdTrans.DBMS
	CASE 'SYC', 'MSS', 'SNC'
		l_SQLString = "sp_password '" + OldPassword + "','" + NewPassword + "'"
	CASE 'OR7'
		l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + NewPassword
	CASE 'SYB'
		l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + NewPassword
	CASE 'ODBC'
		CHOOSE CASE PwdTrans.SQLReturnData
			CASE "Microsoft SQL Server", "SQL Server"
				l_SQLString = "sp_password '" + OldPassword + "','" + NewPassword + "'"
				
			CASE "ORACLE 8.x"
				l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + NewPassword
				
			CASE "Sybase"
				l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + NewPassword
				
		END CHOOSE
END CHOOSE

EXECUTE IMMEDIATE :l_SQLString USING PwdTrans;

//----------------------------------------------------------------
//  Return TRUE if an error occured, else update the password in the security database.
//----------------------------------------------------------------

IF PwdTrans.SQLCode < 0 THEN
// DISCONNECT USING PwdTrans;
   RETURN TRUE
ELSE
//	DISCONNECT USING PwdTrans;
   	
//	UPDATE pl_usr SET usr_pwd = :NewPassword
//		WHERE usr_login = :UserLogin USING SECCA.MGR.i_SecTrans;

// RAP  10/27/08 Do not store the password in the powerlock database
	UPDATE pl_usr SET usr_pwd = ''
		WHERE usr_login = :UserLogin USING SECCA.MGR.i_SecTrans;
		
	IF SECCA.MGR.i_SecTrans.SQLCode < 0 THEN
//		CHOOSE CASE PwdTrans.SQLReturnData
//			CASE "Microsoft SQL Server", "SQL Server"
//				l_SQLString = "sp_password '" + NewPassword + "','" + OldPassword + "'"
//		
//			CASE "ORACLE 8.x"
//				l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + OldPassword
//		
//			CASE "Sybase"
//				l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + OldPassword
//		
//		END CHOOSE
		
		CHOOSE CASE PwdTrans.DBMS
			CASE 'SYC', 'MSS'
				l_SQLString = "sp_password '" + NewPassword + "','" + OldPassword + "'"
			CASE 'OR7'
				l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + OldPassword
			CASE 'SYB'
				l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + OldPassword
			CASE 'ODBC'
				CHOOSE CASE PwdTrans.SQLReturnData
					CASE "Microsoft SQL Server", "SQL Server"
						l_SQLString = "sp_password '" + NewPassword + "','" + OldPassword + "'"
						
					CASE "ORACLE 8.x"
						l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + OldPassword
						
					CASE "Sybase"
						l_SQLString = "GRANT CONNECT TO " + UserLogin + " IDENTIFIED BY " + OldPassword
						
				END CHOOSE
		END CHOOSE
		
		EXECUTE IMMEDIATE :l_SQLString USING PwdTrans;
		
		RETURN TRUE
	ELSE
		RETURN FALSE
	END IF
END IF
end event

event close;call super::close;/****************************************************************************************
  Event         : Close
  Description   : Please see PB documentation for this event

  Change History:

  Date     Person     Description of Change
  -------- ---------- -------------------------------------------------------------------
  2/28/2002 K. Claver Moved the disconnect for PWDCA to this event in case the user
  							 cancels.
****************************************************************************************/
IF IsValid( PWDCA ) THEN
	DISCONNECT USING PWDCA;
END IF
end event

type sle_newpassword2 from w_pl_newpwd_main`sle_newpassword2 within w_change_password
textcase textcase = anycase!
end type

type sle_newpassword1 from w_pl_newpwd_main`sle_newpassword1 within w_change_password
textcase textcase = anycase!
end type

type st_2 from w_pl_newpwd_main`st_2 within w_change_password
end type

type st_1 from w_pl_newpwd_main`st_1 within w_change_password
end type

type cb_cancel from w_pl_newpwd_main`cb_cancel within w_change_password
end type

type cb_ok from w_pl_newpwd_main`cb_ok within w_change_password
integer y = 512
end type

event cb_ok::clicked;/****************************************************************************************
  Event         : Clicked
  Description   : Validate the old and new password.  If OK, close
                  the window.

  Change History:

  Date     Person     Description of Change
  -------- ---------- -------------------------------------------------------------------
  10/6/98  M. Caruso  Created, based on ancestor clicked event.  Overrides the ancestor
                      script and calls fw_CheckOldPwd and fw_CheckAdminOldPwd to verify
							 passwords instead of the functions in SECCA.MGR.  Also added call
							 to uf_CheckDbParm for PWDCA to verify that the connect string is
							 valid.
  7/31/2001 K. Claver Moved the disconnect for PWDCA to this script as can't report on the
  							 error returned when changing the password if disconnect before reported.
  2/28/2002 K. Claver Moved the disconnect for PWDCA to the close event in case the user
  							 cancels.
****************************************************************************************/

INTEGER	l_Idx	
STRING	l_DBInfo[], l_DBName, l_MsgStrings[]

SetPointer(HourGlass!)

IF sle_oldpassword.text = "" THEN
   SECCA.MSG.fu_DisplayMessage("PwdOld")
   sle_oldpassword.SetFocus()
   RETURN
END IF

IF sle_newpassword1.text = "" THEN
   SECCA.MSG.fu_DisplayMessage("PwdNew1")
   sle_newpassword1.SetFocus()
   RETURN
END IF

IF sle_newpassword2.text = "" THEN
   SECCA.MSG.fu_DisplayMessage("PwdNew2")
   sle_newpassword2.SetFocus()
   RETURN
END IF

IF NOT f_pl_pwd_restrictions(sle_newpassword1.text) THEN
	sle_newpassword1.SetFocus()
	RETURN
END IF
//-------------------------------------------------------------------
//  If an Administrator is logging in to the security administration
//  program check their old password to make sure it is valid,
//  make sure that the new password "entered twice" match, then 
//  update the new password in the admin table.
//-------------------------------------------------------------------
 
IF i_LoginType = "ADMIN" THEN
   IF SECCA.MGR.fu_CheckAdminOldPwd(i_Login, sle_oldpassword.text) = 0 THEN
      IF sle_newpassword1.text = sle_newpassword2.text THEN
         IF SECCA.MGR.fu_SetAdmInfo(SECCA.MGR.i_AdmKey, sle_newpassword1.text) = 0 THEN
            CloseWithReturn(PARENT, sle_newpassword2.text)
         ELSE
            CloseWithReturn(PARENT, "")
         END IF
      ELSE
         SECCA.MSG.fu_DisplayMessage("PwdMismatch")
         sle_newpassword2.SetFocus()
      END IF
   ELSE
      sle_oldpassword.SetFocus()
   END IF
ELSE

	//-------------------------------------------------------------------
	//  If an end user is logging in to an application, check their 
	//  old password to make sure it is valid,
	//  make sure that the new password "entered twice" match, then 
	//  update the new password in the user table.
	//-------------------------------------------------------------------

   IF fw_CheckOldPwd(i_Login, sle_oldpassword.text) = 0 THEN
      IF sle_newpassword1.text = sle_newpassword2.text THEN
			IF SECCA.MGR.i_UseLogin THEN
				PWDCA = CREATE Transaction
				FOR l_Idx = 1 TO SECCA.MGR.i_NumConnections
 					SECCA.MGR.fu_GetDBUserInfo(SECCA.MGR.i_DBKey, &
										 l_DBName, l_DBInfo[], &
										 i_Login, sle_oldpassword.text)

      			PWDCA.DBMS       = l_DBInfo[1]
     				PWDCA.Database   = l_DBInfo[2]
      			PWDCA.ServerName = l_DBInfo[3]
     				PWDCA.UserId     = l_DBInfo[4]
     				PWDCA.DBPass	  = l_DBInfo[5]
     				PWDCA.LogId		  = l_DBInfo[6]
					PWDCA.LogPass	  = l_DBInfo[7]
	   			PWDCA.DBParm     = l_DBInfo[8]
      			PWDCA.Lock       = l_DBInfo[9]
      			IF l_DBInfo[10] = "0" THEN
         			PWDCA.AutoCommit = FALSE
      			ELSE
         			PWDCA.AutoCommit = TRUE
      			END IF
					
					uf_CheckDbParm (PWDCA)
					
					i_PwdChanged = FALSE
					IF Event pl_ChangePwd(i_Login, sle_oldpassword.Text, &
					                      sle_newpassword1.Text, PWDCA, &
												 i_PwdChanged) THEN
						l_MsgStrings[1] = PWDCA.SQLErrText
						SECCA.MSG.fu_DisplayMessage("PwdUpdateFailed", &
						                            1, l_MsgStrings[])
						CloseWithReturn(PARENT, "")
						EXIT
					END IF   
					IF i_PwdChanged THEN
            		CloseWithReturn(PARENT, sle_newpassword2.text)
						EXIT
   				ELSE
   					SECCA.MSG.fu_DisplayMessage("PwdNotImplemented")
   					CloseWithReturn(PARENT, "")
					END IF
   
         	END FOR

			ELSE
         	IF SECCA.MGR.fu_SetUsrPwd(i_Login, sle_newpassword1.text) = 0 THEN
            	CloseWithReturn(PARENT, sle_newpassword2.text)
         	ELSE
            	CloseWithReturn(PARENT, "")       
         	END IF
			END IF
		
      ELSE
         SECCA.MSG.fu_DisplayMessage("PwdMismatch")
         sle_newpassword2.SetFocus()
      END IF
   ELSE
      sle_oldpassword.SetFocus()
   END IF
END IF
end event

type st_password from w_pl_newpwd_main`st_password within w_change_password
end type

type sle_oldpassword from w_pl_newpwd_main`sle_oldpassword within w_change_password
textcase textcase = anycase!
end type

