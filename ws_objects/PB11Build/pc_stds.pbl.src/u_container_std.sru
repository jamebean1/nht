﻿$PBExportHeader$u_container_std.sru
$PBExportComments$Container standards
forward
global type u_container_std from u_container_main
end type
end forward

global type u_container_std from u_container_main
end type
global u_container_std u_container_std

on u_container_std.create
call u_container_main::create
end on

on u_container_std.destroy
call u_container_main::destroy
end on

event pc_setcodetables;call super::pc_setcodetables;////******************************************************************
////  PC Module     : u_Container_Std
////  Event         : pc_SetCodeTables
////  Description   : Provide the opportunity for the developer
////                  to load code tables for controls on the 
////                  container. 
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Use the object-level function in each search/filter object
////  to load the code tables for the control.  Parameters for these 
////  function are:
////
////     STRING      Table_Name -
////        Table from where the column with the code values resides.
////     STRING      Column_Code -
////        Column name with the code values.
////     STRING      Column_Desc -
////        Column name with the code descriptions.
////     STRING      Where_Clause -
////        WHERE clause statement to restrict the code values.
////     STRING      All_Keyword -
////        Keyword to denote select all values (e.g. "(All)")
////------------------------------------------------------------------
//
////Error.i_FWError = <control>.fu_LoadCode("<table_name>",  &
////                                        "<column_code>", &
////                                        "<column_desc>", &
////                                        "<where_clause>", &
////                                        "<all_keyword>")
////IF Error.i_FWError <> c_Success THEN
////   RETURN
////END IF
//
end event

event pc_setoptions;call super::pc_setoptions;////******************************************************************
////  PC Module     : u_Container_Std
////  Event         : pc_SetOptions
////  Description   : Provides an opportunity for the developer to
////                  do any container setup processing before the 
////                  container becomes visible.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Use the fu_SetOptions() function to set the container behavior.
////  The parameters for this function are:
////
////     STRING Options -
////        The options requested for this container.
////------------------------------------------------------------------
//
//fu_SetOptions(<options>)
//
end event

event pc_setvariables;call super::pc_setvariables;////******************************************************************
////  PC Module     : u_Container_Std
////  Event         : pc_SetVariables
////  Description   : Provides the opportunity for the developer to
////                  set instance variables passed into the container
////                  prior to the openning of the container.
////
////  Parameters    : POWEROBJECT PowerObject_Parm -
////            	       If the container was opened with a parameter
////                     of type POWEROBJECT, then this variable
////                     contains it.  If the container was not opened
////                     with a parameter, then this value is NULL.
////                  STRING      String_Parm -
////            	        If the container was opened with a parameter
////                     of type STRING, then this variable
////                     contains it.  If the container was not opened
////                     with a parameter, then this value is NULL.
////                  DOUBLE      Numeric_Parm -
////            	        If the container was opened with a numeric
////                     parameter, then this variable
////                     contains it.  If the container was not opened
////                     with a parameter, then this value is NULL.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////------------------------------------------------------------------
////  Sample code to save a structure of variables passed into the
////  container.  Value is saved in an instance variable so it may be 
////  used in other places in the container.
////------------------------------------------------------------------
//
////S_PARMS i_Parms
//
////IF NOT IsNull(powerobject_parm) THEN
////   i_Parms = powerobject_parm
////END IF
//
////------------------------------------------------------------------
////  Sample code to save a POWEROBJECT value passed into the 
////  container.  Value is saved in an instance variable so it may be
////  used in other places in the container.
////------------------------------------------------------------------
//
////U_DEPARTMENT i_UO_Dept
//
////IF NOT IsNull(powerobject_parm) THEN
////   i_UO_Dept = powerobject_parm
////END IF
//
end event

event pc_close;call super::pc_close;////******************************************************************
////  PC Module     : u_Container_Std
////  Event         : pc_Close
////  Description   : Provide the opportunity for the developer
////                  to do things to the container when the container
////                  is closing. 
////
////  Return Value  : (None)
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
end event

event pc_closequery;call super::pc_closequery;////******************************************************************
////  PC Module     : u_Container_Std
////  Event         : pc_CloseQuery
////  Description   : Provide the opportunity for the developer
////                  to do things to the container before a container 
////                  is allowed to close.  Setting Error.i_FWError 
////                  to c_Fatal will prevent the container from closing.
////
////  Return Value  : Error.i_FWError -
////                     c_Success - the event completed succesfully.
////                     c_Fatal   - the event encountered an error.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
end event

