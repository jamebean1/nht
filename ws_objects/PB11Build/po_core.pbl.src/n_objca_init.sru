$PBExportHeader$n_objca_init.sru
$PBExportComments$Application service to handle security initialization
forward
global type n_objca_init from datastore
end type
end forward

global type n_objca_init from datastore
string dataobject = "d_objca_init_std"
end type
global n_objca_init n_objca_init

type variables
//----------------------------------------------------------------------------------------
//  Initialization Constants
//----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_INIT_ProgramName	= 1
CONSTANT INTEGER	c_INIT_ProgramVersion	= 2
CONSTANT INTEGER	c_INIT_ProgramBMP	= 3
CONSTANT INTEGER	c_INIT_PlaqueDisplay	= 4
CONSTANT INTEGER	c_INIT_PlaqueBMP		= 5
CONSTANT INTEGER	c_INIT_Source		= 6
CONSTANT INTEGER	c_INIT_RegistryKey		= 7
CONSTANT INTEGER	c_INIT_INIFile		= 8
CONSTANT INTEGER	c_INIT_INISection		= 9
CONSTANT INTEGER	c_INIT_TO_DBMS		= 10
CONSTANT INTEGER	c_INIT_TO_Database	= 11
CONSTANT INTEGER	c_INIT_TO_UserId		= 12
CONSTANT INTEGER	c_INIT_TO_DBPass	= 13
CONSTANT INTEGER	c_INIT_TO_LogId		= 14
CONSTANT INTEGER	c_INIT_TO_LogPass	= 15
CONSTANT INTEGER	c_INIT_TO_ServerName	= 16
CONSTANT INTEGER	c_INIT_TO_DBParm	= 17
CONSTANT INTEGER	c_INIT_AdmUseLogin	= 18

//----------------------------------------------------------------------------------------
//  Initialization Instance Variables
//----------------------------------------------------------------------------------------


end variables

forward prototypes
public function string fu_getsource ()
public function string fu_getinitinfo (integer info_type)
public function integer fu_setinitinfo (integer info_type, string info_value)
end prototypes

public function string fu_getsource ();//******************************************************************
//  PO Module     : n_objca_init
//  Function      : fu_GetSource
//  Description   : Returns the source of the init info for the app.
//							F - INI File
//							R - Registry
//							D - Database
//
//  Parameters    : None
//
//  Return Value  : STRING
//                     The information about the variable.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/8/2001 K. Claver Created
//******************************************************************
RETURN Upper( THIS.GetItemString( 1, "source" ) )
end function

public function string fu_getinitinfo (integer info_type);//******************************************************************
//  PO Module     : n_objca_init
//  Function      : fu_GetInitInfo
//  Description   : Returns information about a variable 
//                  initialization.
//
//  Parameters    : INTEGER Info_Type -
//                     Enumerated value to tell the function
//                     what variable information to return.
//
//  Return Value  : STRING
//                     The information about the variable.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/5/2001 K. Claver Added code to fit with the new registry format.
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

STRING  l_Info, l_Source, l_InfoColumn, l_RegistryKey, l_INIFile
STRING  l_INISection, l_InfoDesc, l_RegDBKey = "\PowerLock Connect Info"
STRING  l_RegAppKey = "\Application Info", l_AppVersion, l_RegType

//------------------------------------------------------------------
//  Find the requested variable information.
//------------------------------------------------------------------

l_InfoColumn = ""

CHOOSE CASE Info_Type
	CASE c_INIT_ProgramName
		l_Info = GetItemString(1, "program_name")
	CASE c_INIT_ProgramVersion
		l_Info = GetItemString(1, "program_version")
	CASE c_INIT_ProgramBMP
		l_Info = GetItemString(1, "program_bmp")
	CASE c_INIT_PlaqueDisplay
		l_Info = Upper(GetItemString(1, "plaque_display"))
	CASE c_INIT_PlaqueBMP
		l_Info = GetItemString(1, "plaque_bmp")
	CASE c_INIT_Source
		l_Info = GetItemString(1, "source")
	CASE c_INIT_RegistryKey
		l_Info = GetItemString(1, "registry_key")
	CASE c_INIT_INIFile
		l_Info = GetItemString(1, "ini_file")
	CASE c_INIT_INISection
		l_Info = GetItemString(1, "ini_section")
	CASE c_INIT_TO_DBMS
		l_InfoColumn = "to_dbms"
		l_InfoDesc   = "DBMS"
		l_RegType = "D"
	CASE c_INIT_TO_Database
		l_InfoColumn = "to_database"
		l_InfoDesc   = "Database"
		l_RegType = "D"
	CASE c_INIT_TO_UserId
		l_InfoColumn = "to_userid"
		l_InfoDesc   = "UserId"
		l_RegType = "D"
	CASE c_INIT_TO_DBPass
		l_InfoColumn = "to_dbpass"
		l_InfoDesc   = "DBPass"
		l_RegType = "D"
	CASE c_INIT_TO_LogID
		l_InfoColumn = "to_logid"
		l_InfoDesc   = "LogId"
		l_RegType = "D"
	CASE c_INIT_TO_LogPass
		l_InfoColumn = "to_logpass"
		l_InfoDesc   = "LogPass"
		l_RegType = "D"
	CASE c_INIT_TO_ServerName
		l_InfoColumn = "to_servername"
		l_InfoDesc   = "ServerName"
		l_RegType = "D"
	CASE c_INIT_TO_DBParm
		l_InfoColumn = "to_dbparm"
		l_InfoDesc   = "DBParm"
		l_RegType = "D"
	CASE c_INIT_AdmUseLogin
		l_InfoColumn = "to_admuselogin"
		l_InfoDesc   = "AdmUseLogin"
		l_RegType = "A"
END CHOOSE

IF l_InfoColumn <> "" THEN
	l_Source = THIS.fu_GetSource( )
	l_AppVersion = GetItemString( 1, "program_version" )
	CHOOSE CASE l_Source
		CASE "R"
			l_RegistryKey = GetItemString(1, "registry_key")
			
			//Check if in development mode.  If so, set app version to 
			//  "development" so doesn't depend on app version.
			RegistryGet( Mid( l_RegistryKey, 1, ( Len( l_RegistryKey ) - 1 ) ), "devmode", RegString!, OBJCA.MGR.i_DevMode )
			IF Upper( OBJCA.MGR.i_DevMode ) = "ON" THEN
				l_AppVersion = "development"
			END IF
			
			CHOOSE CASE l_RegType
				CASE "D"
					l_RegistryKey = ( l_RegistryKey+l_AppVersion+l_RegDBKey )
				CASE "A"
					l_RegistryKey = ( l_RegistryKey+l_AppVersion+l_RegAppKey )		
			END CHOOSE
			
			RegistryGet(l_RegistryKey, l_InfoDesc, l_Info)
		CASE "F"
			l_INIFile = GetItemString(1, "ini_file")
			l_INISection = GetItemString(1, "ini_section")
        	l_Info = ProfileString(l_INIFile, l_INISection, l_InfoDesc, "")
		CASE "D"
			l_Info = GetItemString(1, l_InfoColumn)
	END CHOOSE

	IF l_InfoColumn = "to_admuselogin" THEN
		IF l_Info = "" THEN
			l_Info = "N"
		END IF
		l_Info = Upper(l_Info)
	END IF
END IF

RETURN l_Info
end function

public function integer fu_setinitinfo (integer info_type, string info_value);//******************************************************************
//  PO Module     : n_objca_init
//  Function      : fu_SetInitInfo
//  Description   : Sets information about the variable.
//
//  Parameters    : INTEGER Info_Type -
//                     Enumerated value to tell the function
//                     what variable information to set.
//
//                  STRING  Info_Value -
//                     The variable information to set.
//
//  Return Value  : INTEGER -
//                      0 - The variable information was set.
//                     -1 - The variable id was not found.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1997.  All Rights Reserved.
//******************************************************************

STRING l_InfoColumn, l_Source, l_RegistryKey, l_INIFile, l_INISection
STRING l_Info, l_InfoDesc, l_RegDBKey = "\PowerLock Connect Info"
STRING l_RegAppKey = "\Application Info", l_AppVersion, l_RegType

//------------------------------------------------------------------
//  Find the requested variable to set.
//------------------------------------------------------------------

CHOOSE CASE Info_Type
	CASE c_INIT_ProgramName
		SetItem(1, "program_name", info_value)
	CASE c_INIT_ProgramVersion
		SetItem(1, "program_version", info_value)
	CASE c_INIT_ProgramBMP
		SetItem(1, "program_bmp", info_value)
	CASE c_INIT_PlaqueDisplay
		SetItem(1, "plaque_display", Upper(info_value))
	CASE c_INIT_PlaqueBMP
		SetItem(1, "plaque_bmp", info_value)
	CASE c_INIT_Source
		SetItem(1, "source", info_value)
	CASE c_INIT_RegistryKey
		SetItem(1, "registry_key", info_value)
	CASE c_INIT_INIFile
		SetItem(1, "ini_file", info_value)
	CASE c_INIT_INISection
		SetItem(1, "ini_section", info_value)
	CASE c_INIT_TO_DBMS
		l_InfoColumn = "to_dbms"
		l_InfoDesc   = "DBMS"
		l_RegType = "D"
	CASE c_INIT_TO_Database
		l_InfoColumn = "to_database"
		l_InfoDesc   = "Database"
		l_RegType = "D"
	CASE c_INIT_TO_UserId
		l_InfoColumn = "to_userid"
		l_InfoDesc   = "UserId"
		l_RegType = "D"
	CASE c_INIT_TO_DBPass
		l_InfoColumn = "to_dbpass"
		l_InfoDesc   = "DBPass"
		l_RegType = "D"
	CASE c_INIT_TO_LogID
		l_InfoColumn = "to_logid"
		l_InfoDesc   = "LogId"
		l_RegType = "D"
	CASE c_INIT_TO_LogPass
		l_InfoColumn = "to_logpass"
		l_InfoDesc   = "LogPass"
		l_RegType = "D"
	CASE c_INIT_TO_ServerName
		l_InfoColumn = "to_servername"
		l_InfoDesc   = "ServerName"
		l_RegType = "D"
	CASE c_INIT_TO_DBParm
		l_InfoColumn = "to_dbparm"
		l_InfoDesc   = "DBParm"
		l_RegType = "D"
	CASE c_INIT_AdmUseLogin
		l_InfoColumn = "to_admuselogin"
		l_InfoDesc   = "AdmUseLogin"
		l_RegType = "A"
	CASE ELSE
		RETURN -1
END CHOOSE

IF l_InfoColumn <> "" THEN
	l_Source = THIS.fu_GetSource( )
	l_Info = info_value
	IF l_InfoColumn = "to_admuselogin" THEN
		l_Info = Upper(l_Info)
	END IF
	CHOOSE CASE l_Source
		CASE "R"
			l_RegistryKey = GetItemString(1, "registry_key")
			
			//Check if in development mode.  If so, set app version to 
			//  "development" so doesn't depend on app version.
			RegistryGet( Mid( l_RegistryKey, 1, ( Len( l_RegistryKey ) - 1 ) ), "devmode", RegString!, OBJCA.MGR.i_DevMode )
			IF Upper( OBJCA.MGR.i_DevMode ) = "ON" THEN
				l_AppVersion = "development"
			END IF
			
			CHOOSE CASE l_RegType
				CASE "D"
					l_RegistryKey = ( l_RegistryKey+l_AppVersion+l_RegDBKey )
				CASE "A"
					l_RegistryKey = ( l_RegistryKey+l_AppVersion+l_RegAppKey )
			END CHOOSE
			
			RegistrySet(l_RegistryKey, l_InfoDesc, l_Info)
		CASE "F"
			l_INIFile = GetItemString(1, "ini_file")
			l_INISection = GetItemString(1, "ini_section")
        	SetProfileString(l_INIFile, l_INISection, l_InfoDesc, l_Info)
		CASE "D"
			SetItem(1, l_InfoColumn, l_Info)
	END CHOOSE
END IF

RETURN 0
end function

on n_objca_init.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_objca_init.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;OBJCA.MGR.i_ProgName      = fu_GetInitInfo(c_INIT_ProgramName)
OBJCA.MGR.i_ProgVersion   = fu_GetInitInfo(c_INIT_ProgramVersion)
OBJCA.MGR.i_ProgBMP       = fu_GetInitInfo(c_INIT_ProgramBMP)
OBJCA.MGR.i_PlaqueDisplay = fu_GetInitInfo(c_INIT_PlaqueDisplay)
OBJCA.MGR.i_PlaqueBMP     = fu_GetInitInfo(c_INIT_PlaqueBMP)
OBJCA.MGR.i_ProgINI       = fu_GetInitInfo(c_INIT_INIFile)
OBJCA.MGR.i_AdmUseLogin   = fu_GetInitInfo(c_INIT_AdmUseLogin)
OBJCA.MGR.i_Source		  = fu_GetInitInfo(c_INIT_Source)
OBJCA.MGR.i_RegKey		  = fu_GetInitInfo(c_INIT_RegistryKey)
end event

