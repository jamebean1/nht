$PBExportHeader$n_fwca_main.sru
$PBExportComments$Framework controller
forward
global type n_fwca_main from nonvisualobject
end type
end forward

global type n_fwca_main from nonvisualobject autoinstantiate
end type

type variables
//----------------------------------------------------------------------------------------
//  Framework Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_DefaultManagers		= "000|"
CONSTANT STRING	c_MicrohelpManager	= "001|"
CONSTANT STRING	c_MenuManager		= "002|"

//----------------------------------------------------------------------------------------
//  Framework Instance Variables
//----------------------------------------------------------------------------------------

N_FWCA_MGR		MGR
N_FWCA_MSG		MSG

N_FWCA_MGR		MDI
N_FWCA_MGR		MENU

end variables

forward prototypes
public subroutine fu_destroymanagers ()
public function integer fu_createmanagers (string managers)
end prototypes

public subroutine fu_destroymanagers ();//******************************************************************
//  PC Module     : FWCA
//  Subroutine    : fu_DestroyManagers
//  Description   : Terminates all the managers for the
//                  application.
//
//  Parameters    : (None)
// 
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Destroy the menu manager.
//------------------------------------------------------------------

IF IsValid(FWCA.MENU) THEN
   Destroy FWCA.MENU
END IF

//------------------------------------------------------------------
//  Destroy the microhelp manager.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
   Destroy FWCA.MDI
END IF

//------------------------------------------------------------------
//  Destroy the message manager.
//------------------------------------------------------------------

IF IsValid(FWCA.MSG) THEN
   Destroy FWCA.MSG
END IF

//------------------------------------------------------------------
//  Destroy the framework manager.
//------------------------------------------------------------------

IF IsValid(FWCA.MGR) THEN
   Destroy FWCA.MGR
END IF

end subroutine

public function integer fu_createmanagers (string managers);//******************************************************************
//  PC Module     : FWCA
//  Subroutine    : fu_CreateManagers
//  Description   : Create required and optional managers.
//
//  Parameters    : STRING Managers -
//                     Managers to be created.
//
//  Return Value  : INTEGER
//                      0 = manager created successfully
//                     -1 = manager creation failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING l_Object

SetPointer(HourGlass!)

//------------------------------------------------------------------
//  Create the framework manager.
//------------------------------------------------------------------

MGR = Create n_fwca_mgr
IF NOT IsValid(FWCA.MGR) THEN
	RETURN -1
END IF

//------------------------------------------------------------------
//  Create the message manager.
//------------------------------------------------------------------

l_Object = FWCA.MGR.fu_GetDefault("Framework", "Message")
IF l_Object <> "" THEN
	MSG = Create Using l_Object
	IF NOT IsValid(FWCA.MSG) THEN
		RETURN -1
	END IF
ELSE
	RETURN -1
END IF

//------------------------------------------------------------------
//  Create the microhelp manager.
//------------------------------------------------------------------

IF Pos(managers, c_MicrohelpManager) > 0 THEN
	l_Object = FWCA.MGR.fu_GetDefault("Framework", "Microhelp")
	IF l_Object <> "" THEN
		MDI = Create Using l_Object
		IF NOT IsValid(FWCA.MDI) THEN
			RETURN -1
		END IF
	ELSE
		RETURN -1
	END IF
END IF

//------------------------------------------------------------------
//  Create the menu manager.
//------------------------------------------------------------------

IF Pos(managers, c_MenuManager) > 0 THEN
	l_Object = FWCA.MGR.fu_GetDefault("Framework", "Menu")
	IF l_Object <> "" THEN
		MENU = Create Using l_Object
		IF NOT IsValid(FWCA.MENU) THEN
			RETURN -1
		END IF
	ELSE
		RETURN -1
	END IF
END IF

//------------------------------------------------------------------
//  Store the application object.
//------------------------------------------------------------------

MGR.i_ApplicationObject = GetApplication()

RETURN 0
end function

on n_fwca_main.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_fwca_main.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

