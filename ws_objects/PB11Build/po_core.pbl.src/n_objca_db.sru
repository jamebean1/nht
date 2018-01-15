$PBExportHeader$n_objca_db.sru
$PBExportComments$Application service to handle database communication
forward
global type n_objca_db from datastore
end type
end forward

global type n_objca_db from datastore
string dataobject = "d_objca_db_std"
end type
global n_objca_db n_objca_db

type variables
//----------------------------------------------------------------------------------------
//  Database Constants
//----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_DB_Id			= 1
CONSTANT INTEGER	c_DB_Description		= 2
CONSTANT INTEGER	c_DB_InterfaceType	= 3
CONSTANT INTEGER	c_DB_LoginType		= 4
CONSTANT INTEGER	c_DB_PWDType		= 5
CONSTANT INTEGER	c_DB_CCError		= 6
CONSTANT INTEGER	c_DB_CCDuplicate		= 7
CONSTANT INTEGER	c_DB_DateString		= 8

//----------------------------------------------------------------------------------------
//  Database Instance Variables
//----------------------------------------------------------------------------------------

end variables

forward prototypes
public function integer fu_deletedatabase (string id)
public function integer fu_setdatabase (string id, integer info_type, string info_value)
public function integer fu_adddatabase (string id, string description, string interface, string login_parm, string pwd_parm, string cc_error_code, string cc_dup_code, string date_constant)
public function string fu_getdatabase (transaction trans_object, integer info_type)
end prototypes

public function integer fu_deletedatabase (string id);//******************************************************************
//  PO Module     : n_OBJCA_DB
//  Function      : fu_DeleteDatabase
//  Description   : Deletes information about a database from the
//                  database datastore.
//
//  Parameters    : STRING ID -
//                     If the database has a native driver then
//                     the ID is the three characters that identify
//                     the driver (e.g. OR6 for Oracle 6).  If an
//                     ODBC driver, ID is ODBC_xxx, where xxx is
//                     any number of characters that are contained
//                     the Data Sources description
//                     (e.g. ODBC_ANYWHERE could be 'Sybase SQL 
//                     Anywhere')
//
//  Return Value  : INTEGER -
//                      0 - The database was deleted
//                     -1 - The database was not found or deleted.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Return = -1

IF Upper(id) <> "UNKNOWN" THEN
	l_Rows = RowCount()
	FOR l_Idx = 1 TO l_Rows
		IF GetItemString(l_Idx, "id") = id THEN
			DeleteRow(l_Idx)
			l_Return = 0
			EXIT
		END IF
	NEXT
END IF
			
RETURN l_Return
end function

public function integer fu_setdatabase (string id, integer info_type, string info_value);//******************************************************************
//  PO Module     : n_OBJCA_DB
//  Function      : fu_SetDatabase
//  Description   : Sets information about the database contained
//                  in the given transaction object.
//
//  Parameters    : STRING ID -
//                     If the database has a native driver then
//                     the ID is the three characters that identify
//                     the driver (e.g. OR6 for Oracle 6).  If an
//                     ODBC driver, ID is ODBC_xxx, where xxx is
//                     any number of characters that are contained
//                     the Data Sources description
//                     (e.g. ODBC_ANYWHERE could be 'Sybase SQL 
//                     Anywhere')
//
//                  INTEGER Info_Type -
//                     Enumerated value to tell the function
//                     what information to set.
//
//                  STRING  Info_Value -
//                     The information to set.
//
//  Return Value  : INTEGER -
//                      0 - The database information was set.
//                     -1 - The database id was not found.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Return = -1

//------------------------------------------------------------------
//  Find the requested database id.
//------------------------------------------------------------------

IF Upper(id) <> "UNKNOWN" THEN
	l_Rows = RowCount()
	FOR l_Idx = 1 TO l_Rows
		IF GetItemString(l_Idx, "id") = id THEN
			CHOOSE CASE info_type
				CASE c_DB_Id
					SetItem(l_Idx, "id", info_value)
				CASE c_DB_Description
					SetItem(l_Idx, "description", info_value)
				CASE c_DB_InterfaceType
					SetItem(l_Idx, "interface", info_value)
				CASE c_DB_LoginType
					SetItem(l_Idx, "login_parm", info_value)
				CASE c_DB_PWDType
					SetItem(l_Idx, "pwd_parm", info_value)
				CASE c_DB_CCError
					SetItem(l_Idx, "cc_error_code", info_value)
				CASE c_DB_CCDuplicate
					SetItem(l_Idx, "cc_dup_code", info_value)
				CASE c_DB_DateString
					SetItem(l_Idx, "date_constant", info_value)
			END CHOOSE
			l_Return = 0
			EXIT
		END IF
	NEXT
END IF

RETURN l_Return
end function

public function integer fu_adddatabase (string id, string description, string interface, string login_parm, string pwd_parm, string cc_error_code, string cc_dup_code, string date_constant);//******************************************************************
//  PO Module     : n_OBJCA_DB
//  Function      : fu_AddDatabase
//  Description   : Adds information about a database to the
//                  database datastore.
//
//  Parameters    : STRING ID -
//                     If the database has a native driver then
//                     the ID is the three characters that identify
//                     the driver (e.g. OR6 for Oracle 6).  If an
//                     ODBC driver, ID is ODBC_xxx, where xxx is
//                     any number of characters that are contained
//                     the Data Sources description
//                     (e.g. ODBC_ANYWHERE could be 'Sybase SQL 
//                     Anywhere')
//
//                  STRING Description -
//                     Description of the database.
//
//                  STRING Interface -
//                     Is the database driver NATIVE or ODBC.
//
//                  STRING Login_Parm -
//                     Does the database use LOGID or USERID to
//                     connect with.
//
//                  STRING Pwd_Parm -
//                     Does the database use LOGPASS or DBPASS to
//                     connect with.
//
//                  STRING CC_Error_Code -
//                     Error code(s), separated by commas, that are
//                     returned by the database to indicate a
//                     concurrency error.
//
//                  STRING CC_Dup_Code -
//                     Error code(s), separated by commas, that are
//                     returned by the database to indicate a
//                     non-unique key error.
//
//                  STRING Date_Constant -
//                     Used by the Outliner object to fill in blank
//                     levels that have a date data type as a key
//                     field.
//
//  Return Value  : INTEGER -
//                      0 - The database information was added
//                     -1 - The database information already exists.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Rows, l_Idx, l_Return = -1
BOOLEAN l_Found = FALSE

//------------------------------------------------------------------
//  Make sure the database to add is not already there.
//------------------------------------------------------------------

l_Rows  = RowCount()

FOR l_Idx = 1 TO l_Rows
	IF GetItemString(l_Idx, "id") = id THEN
		l_Found = TRUE
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  If it wasn't found, add it.
//------------------------------------------------------------------

IF NOT l_Found THEN
	l_Rows   = l_Rows + 1
	InsertRow(l_Rows)

	SetItem(l_Rows, "id", id)
	SetItem(l_Rows, "description", description)
	SetItem(l_Rows, "interface", interface)
	SetItem(l_Rows, "login_parm", login_parm)
	SetItem(l_Rows, "pwd_parm", pwd_parm)
	SetItem(l_Rows, "cc_error_code", cc_error_code)
	SetItem(l_Rows, "cc_dup_code", cc_dup_code)
	SetItem(l_Rows, "date_constant", date_constant)
	l_Return = 0
END IF

RETURN l_Return
end function

public function string fu_getdatabase (transaction trans_object, integer info_type);/****************************************************************************************
  PO Module     : n_OBJCA_DB
  Function      : fu_GetDatabase
  Description   : Returns information about the database contained
                  in the given transaction object.

  Parameters    : TRANSACTION  Trans_Object -
                     The transaction object used to connect
                     the database.

                  INTEGER      Info_Type -
                     Enumerated value to tell the function
                     what information to return.

  Return Value  : STRING
                     The information about the database.  An
                     unknown database or unkown information about
                     a database is returned as "".

  Change History:

	Date     Person     Description of Change
	-------- ---------- ------------------------------------------------------------------
	11/1/99  M. Caruso  Added check of System DSNs from the registry as well.
*****************************************************************************************
  Copyright ServerLogic 1994-1997.  All Rights Reserved.
****************************************************************************************/

STRING  l_DBMS, l_ODBC, l_Source, l_Parm, l_Type, l_Info
INTEGER l_Pos, l_Rows, l_Idx
STRING  l_Value, l_RegValue
BOOLEAN l_BackAny, l_BackRDB

//------------------------------------------------------------------
//  Find the database we are connected to from the transaction
//  object.
//------------------------------------------------------------------

l_DBMS = Upper(Trans_Object.DBMS)
IF Left(l_DBMS, 6) = "TRACE " THEN
	l_DBMS = LeftTrim(Mid(l_DBMS, 7))
END IF

//------------------------------------------------------------------
//  If we are connected to some sort of ODBC database, look in the
//  "Data Sources" section of the ODBC INI file to determine what
//  database we are actually connected to.
//------------------------------------------------------------------

IF l_DBMS = "ODBC" THEN

   l_Parm = Trans_Object.DBParm
   l_Pos  = Pos(Upper(l_Parm), "DSN=")
   IF l_Pos > 0 THEN
      l_Parm = Mid(l_Parm, l_Pos + 4)
      l_Pos  = Pos(l_Parm, ";")
      IF l_Pos > 0 THEN
         l_Source = Mid(l_Parm, 1, l_Pos - 1)
      ELSE
         l_Pos = Pos(l_Parm, "'")
         IF l_Pos > 0 THEN
            l_Source = Mid(l_Parm, 1, l_Pos - 1)
         ELSE
            l_Source = l_Parm
         END IF
      END IF
   ELSE
      l_Source = Trans_Object.Database
   END IF

   l_ODBC = (ProfileString(OBJCA.MGR.i_ODBCFile, "ODBC 32 bit Data Sources", &
                           l_Source, "[NO_ODBC_DSN]"))
	IF l_ODBC = "[NO_ODBC_DSN]" THEN
      l_ODBC = (ProfileString(OBJCA.MGR.i_ODBCFile, &
		                        "ODBC Data Sources", &
                              l_Source, "[NO_ODBC_DSN]"))
		//-----------------------------------------------------------
		// Check the registry then do a backward compatibility check.
		//-----------------------------------------------------------
		IF l_ODBC = "[NO_ODBC_DSN]" OR l_ODBC = "" THEN
			IF RegistryGet(&
					"HKEY_CURRENT_USER\Software\ODBC\ODBC.INI\ODBC Data Sources",&
					l_Source, l_regvalue) = 1 THEN
				l_ODBC = Trim(Upper(l_regvalue))
			ELSE  // added 11/1/99, MPC
				IF RegistryGet(&
						"HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\odbc.ini\ODBC Data Sources",&
						l_Source, l_regvalue) = 1 THEN
					l_ODBC = Trim(Upper(l_regvalue))
				ELSE
					l_ODBC = ""
				END IF
			END IF
		END IF
	END IF

   //---------------------------------------------------------------
   //  ODBC Databases.
   //---------------------------------------------------------------
	//  Do a backward compatibility check
   //---------------------------------------------------------------
	l_BackAny = FALSE
	l_BackRDB = FALSE
	l_ODBC = Upper(l_ODBC)

	IF l_ODBC <> "[NO_ODBC_DSN]" AND l_ODBC <> "" THEN
		IF l_ODBC = Upper("Sybase SQL Anywhere 5.0") OR &
			l_ODBC = Upper("Sybase SQL Anywhere 5.0 (32 bit)") THEN
			l_BackAny = TRUE
		ELSEIF l_ODBC = Upper("Adaptive Server Anywhere 6.0") OR &
			l_ODBC = Upper("Adaptive Server Anywhere 6.0 (32 bit)") THEN
			l_BackAny = TRUE
		ELSEIF Pos(Upper(l_ODBC), "DEC") > 0 OR &
			Pos(Upper(l_ODBC),"RDB") > 0 THEN
			l_BackRDB = TRUE
		END IF
		l_Type = l_ODBC
	ELSE
		l_Type = "Unknown"
	END IF
ELSE

   //---------------------------------------------------------------
   //  Now that we know that this is not an ODBC database, we can
   //  set type to the description of the database.
   //---------------------------------------------------------------

   l_Type = Left(l_DBMS, 3)
 
END IF

//------------------------------------------------------------------
//  Find the requested database information.
//------------------------------------------------------------------

IF l_Type <> "Unknown" THEN
		l_Rows = RowCount()
	FOR l_Idx = 1 TO l_Rows
		l_Value = Upper(GetItemString(l_Idx, "id"))

		//---------------------------------------------
		// Do a backward compatibility check
		//---------------------------------------------
		IF l_BackAny THEN
			IF l_Value = "ODBC_ANYWHERE" THEN
				l_Type = "ODBC_ANYWHERE"
			ELSEIF l_Value = Upper("Sybase SQL Anywhere 5.0") OR &
				l_Value = Upper("Sybase SQL Anywhere 5.0 (32 bit)") THEN
				l_Type = "Sybase SQL Anywhere 5.0"
			ELSEIF l_Value = Upper("Adaptive Server Anywhere 6.0") OR &
				l_Value = Upper("Adaptive Server Anywhere 6.0 (32 bit)") THEN
				l_Type = "Adaptive Server Anywhere 6.0"
			END IF
		ELSEIF l_BackRDB THEN
			IF l_Value = "ODBC_RDB" THEN
				l_Type = "ODBC_RDB"
			END IF
		END IF

		IF l_Value = Upper(l_Type) THEN
			CHOOSE CASE Info_Type
				CASE c_DB_Id
					l_Info = GetItemString(l_Idx, "id")
				CASE c_DB_Description
					l_Info = GetItemString(l_Idx, "description")
				CASE c_DB_InterfaceType
					l_Info = GetItemString(l_Idx, "interface")
				CASE c_DB_LoginType
					l_Info = GetItemString(l_Idx, "login_parm")
				CASE c_DB_PWDType
					l_Info = GetItemString(l_Idx, "pwd_parm")
				CASE c_DB_CCError
					l_Info = GetItemString(l_Idx, "cc_error_code")
				CASE c_DB_CCDuplicate
					l_Info = GetItemString(l_Idx, "cc_dup_code")
				CASE c_DB_DateString
					l_Info = GetItemString(l_Idx, "date_constant")
			END CHOOSE
			IF IsNull(l_Info) <> FALSE THEN
				l_Info = ""
			END IF
			EXIT
		END IF
	NEXT
ELSE
	l_Info = ""
END IF

RETURN l_Info
end function

on n_objca_db.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_objca_db.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

