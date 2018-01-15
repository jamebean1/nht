$PBExportHeader$w_mdi_frame_std.srw
$PBExportComments$Window standards for MDI windows
forward
global type w_mdi_frame_std from w_mdi_frame
end type
end forward

global type w_mdi_frame_std from w_mdi_frame
end type
global w_mdi_frame_std w_mdi_frame_std

type variables
end variables

event pc_setoptions;////******************************************************************
////  PC Module     : w_MDI_Frame_Std
////  Event         : pc_SetOptions
////  Description   : Provides an opportunity for the developer to
////                  do any window setup processing before the window
////                  becomes visible.
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
////  Use the fw_SetOptions() function to set the window behavior.
////  The parameters for this function are:
////
////     STRING Options -
////        The options requested for this window.
////------------------------------------------------------------------
//
//fw_SetOptions(<options>)
//
end event

on w_mdi_frame_std.create
call w_mdi_frame::create
end on

on w_mdi_frame_std.destroy
call w_mdi_frame::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pc_setvariables;call super::pc_setvariables;////******************************************************************
////  PC Module     : w_MDI_Frame_Std
////  Event         : pc_SetVariables
////  Description   : Provides the opportunity for the developer to
////                  set instance variables passed into the window
////                  prior to the openning of the current window. 
////
////  Parameters    : POWEROBJECT PowerObject_Parm -
////            	        If the window was opened with a parameter
////                     of type POWEROBJECT, then this variable
////                     contains it.  If the window was not opened
////                     with a parameter, then this value is NULL.
////                  STRING      String_Parm -
////            	        If the window was opened with a parameter
////                     of type STRING, then this variable
////                     contains it.  If the window was not opened
////                     with a parameter, then this value is NULL.
////                  DOUBLE      Numeric_Parm -
////            	        If the window was opened with a numeric
////                     parameter, then this variable
////                     contains it.  If the window was not opened
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
////  window.  Value is saved in an instance variable so it may be 
////  used in other places in the window.
////------------------------------------------------------------------
//
////S_PARMS i_Parms
//
////IF NOT IsNull(powerobject_parm) THEN
////   i_Parms = powerobject_parm
////END IF
//
end event

