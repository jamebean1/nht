$PBExportHeader$n_objca_main.sru
$PBExportComments$Class controller
forward
global type n_objca_main from nonvisualobject
end type
end forward

global type n_objca_main from nonvisualobject autoinstantiate
end type

type variables
//----------------------------------------------------------------------------------------
//  Object Constants
//----------------------------------------------------------------------------------------

STRING	c_DefaultManagers		= "000|"
STRING	c_UtilityManager		= "001|"
STRING	c_TimerManager		= "002|"
STRING	c_FieldManager		= "003|"
STRING	c_DateManager		= "004|"
STRING	c_LogManager		= "005|"

//----------------------------------------------------------------------------------------
//  Object Instance Variables
//----------------------------------------------------------------------------------------

N_OBJCA_MGR		MGR
N_OBJCA_MSG		MSG
N_OBJCA_DB		DB
N_EVALCHECK		EVAL
N_OBJCA_INIT	INIT

N_OBJCA_MGR		TIMER
N_OBJCA_MGR		WIN
N_OBJCA_MGR		DATES
N_OBJCA_MGR		FIELD
N_OBJCA_MGR		LOG

end variables

forward prototypes
public function integer fu_createmanagers (string managers)
public subroutine fu_destroymanagers ()
end prototypes

public function integer fu_createmanagers (string managers);//******************************************************************
//  PO Module     : OBJCA
//  Function      : fu_CreateManagers
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

//------------------------------------------------------------------
//  Create the object manager.
//------------------------------------------------------------------

SetPointer(HourGlass!)
MGR = Create n_objca_mgr

//------------------------------------------------------------------
//  Create the init info manager.
//------------------------------------------------------------------
l_Object = MGR.fu_GetDefault("Objects", "Init")
IF l_Object <> "" THEN
	INIT = Create Using l_Object
END IF

//------------------------------------------------------------------
//  Create the message manager.
//------------------------------------------------------------------

l_Object = MGR.fu_GetDefault("Objects", "Message")
IF l_Object <> "" THEN
	MSG = Create Using l_Object
END IF

//------------------------------------------------------------------
//  Create the database manager.
//------------------------------------------------------------------

l_Object = MGR.fu_GetDefault("Objects", "Database")
IF l_Object <> "" THEN
	DB = Create Using l_Object
END IF

//------------------------------------------------------------------
//  Check to see if this is a valid evaluation copy.
//------------------------------------------------------------------

EVAL = Create n_evalcheck
IF EVAL.fu_EvalCheck() <> 0 THEN
	HALT CLOSE
END IF

//------------------------------------------------------------------
//  Check to see if the window utility manager was requested.
//------------------------------------------------------------------

IF Pos(Managers, c_UtilityManager) > 0 THEN
	l_Object = MGR.fu_GetDefault("Objects", "Utility")
	IF l_Object <> "" THEN
		WIN = Create Using l_Object
	END IF
END IF
	
//---------------------------------------------------------------
//  Check to see if the timer utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_TimerManager) > 0 THEN
	l_Object = MGR.fu_GetDefault("Objects", "Timer")
	IF l_Object <> "" THEN
		TIMER = Create Using l_Object
	END IF
END IF	

//---------------------------------------------------------------
//  Check to see if the field utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_FieldManager) > 0 THEN
	l_Object = MGR.fu_GetDefault("Objects", "Field")
	IF l_Object <> "" THEN
		FIELD = Create Using l_Object
	END IF
END IF

//---------------------------------------------------------------
//  Check to see if the date utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_DateManager) > 0 THEN
	l_Object = MGR.fu_GetDefault("Objects", "Date")
	IF l_Object <> "" THEN
		DATES = Create Using l_Object
	END IF
END IF

//---------------------------------------------------------------
//  Check to see if the log manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_LogManager) > 0 THEN
	l_Object = MGR.fu_GetDefault("Objects", "Log")
	IF l_Object <> "" THEN
		LOG = Create Using l_Object
	END IF
END IF

//------------------------------------------------------------------
//  Store the application object.
//------------------------------------------------------------------

MGR.i_ApplicationObject = GetApplication()

RETURN 0
end function

public subroutine fu_destroymanagers ();//******************************************************************
//  PO Module     : OBJCA
//  Subroutine    : fu_DestroyManagers
//  Description   : Destroys all the managers for the
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
//  Destroy the log manager.
//------------------------------------------------------------------

IF IsValid(THIS.LOG) THEN
	IF THIS.LOG.i_CurrentLog <> "" THEN
		THIS.LOG.fu_LogEnd(THIS.LOG.i_CurrentLog)
	END IF
   Destroy THIS.LOG
END IF

//------------------------------------------------------------------
//  Destroy the init info manager.
//------------------------------------------------------------------

IF IsValid(THIS.INIT) THEN
   Destroy THIS.INIT
END IF

//------------------------------------------------------------------
//  Destroy the date utility manager.
//------------------------------------------------------------------

IF IsValid(THIS.DATES) THEN
   Destroy THIS.DATES
END IF

//------------------------------------------------------------------
//  Destroy the field utility manager.
//------------------------------------------------------------------

IF IsValid(THIS.FIELD) THEN
   Destroy THIS.FIELD
END IF

//------------------------------------------------------------------
//  Destroy the timer utility manager.
//------------------------------------------------------------------

IF IsValid(THIS.TIMER) THEN
   Destroy THIS.TIMER
END IF

//------------------------------------------------------------------
//  Destroy the window utility manager.
//------------------------------------------------------------------

IF IsValid(THIS.WIN) THEN
   Destroy THIS.WIN
END IF

//------------------------------------------------------------------
//  Destroy the evaluation manager.
//------------------------------------------------------------------

IF IsValid(THIS.EVAL) THEN
	Destroy THIS.EVAL
END IF

//------------------------------------------------------------------
//  Destroy the database manager.
//------------------------------------------------------------------

IF IsValid(THIS.DB) THEN
   Destroy THIS.DB
END IF

//------------------------------------------------------------------
//  Destroy the message manager.
//------------------------------------------------------------------

IF IsValid(THIS.MSG) THEN
   Destroy THIS.MSG
END IF

//------------------------------------------------------------------
//  Destroy the object manager.
//------------------------------------------------------------------

IF IsValid(THIS.MGR) THEN
   Destroy THIS.MGR
END IF

end subroutine

on n_objca_main.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_objca_main.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

