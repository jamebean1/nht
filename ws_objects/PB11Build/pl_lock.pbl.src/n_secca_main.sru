$PBExportHeader$n_secca_main.sru
$PBExportComments$Security controller
forward
global type n_secca_main from nonvisualobject
end type
end forward

global type n_secca_main from nonvisualobject autoinstantiate
end type

type variables
N_SECCA_MGR	MGR
N_SECCA_MSG	MSG
N_SECCA_INIT	INIT
N_SECCA_DEF	DEF
end variables

forward prototypes
public subroutine fu_createmanagers ()
public subroutine fu_destroymanagers ()
end prototypes

public subroutine fu_createmanagers ();//******************************************************************
//  PL Module     : SECCA
//  Subroutine    : fu_CreateManagers
//  Description   : Creates the security managers.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996.  All Rights Reserved.
//******************************************************************

STRING l_Object

//------------------------------------------------------------------
//  Create the security default manager.
//------------------------------------------------------------------

DEF = Create n_secca_def

//------------------------------------------------------------------
//  Create the security manager.
//------------------------------------------------------------------

l_Object = DEF.fu_GetDefault("Security", "Security")
IF l_Object <> "" THEN
	MGR = Create Using l_Object
END IF

//------------------------------------------------------------------
//  Create the security initialization manager.
//------------------------------------------------------------------

l_Object = DEF.fu_GetDefault("Security", "Initialization")
IF l_Object <> "" THEN
	INIT = Create Using l_Object
END IF

//------------------------------------------------------------------
//  Create the message manager.
//------------------------------------------------------------------

l_Object = DEF.fu_GetDefault("Security", "Message")
IF l_Object <> "" THEN
	MSG = Create Using l_Object
END IF


end subroutine

public subroutine fu_destroymanagers ();//******************************************************************
//  PL Module     : SECCA
//  Subroutine    : fu_DestroyManagers
//  Description   : Destroys the security managers.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Destroy the message manager.
//------------------------------------------------------------------

Destroy MSG

//------------------------------------------------------------------
//  Destroy the security initialization manager.
//------------------------------------------------------------------

Destroy INIT

//------------------------------------------------------------------
//  Destroy the security manager.
//------------------------------------------------------------------

Destroy MGR

//------------------------------------------------------------------
//  Destroy the security defaults manager.
//------------------------------------------------------------------

Destroy DEF

end subroutine

on n_secca_main.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_secca_main.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

