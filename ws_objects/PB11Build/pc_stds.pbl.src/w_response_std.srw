$PBExportHeader$w_response_std.srw
$PBExportComments$Window standards for response style windows
forward
global type w_response_std from w_response
end type
end forward

global type w_response_std from w_response
end type
global w_response_std w_response_std

forward prototypes
public function datetime fw_gettimestamp ()
end prototypes

public function datetime fw_gettimestamp ();/****************************************************************************************

			Function:	fw_gettimestamp
			Purpose:		To get a timestamp (current date and time) from the database server
			Parameters:	None
			Returns:		A datetime timestamp
			
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/10/99  M. Caruso     Changed method for obtaining timestamp from Now(*) to GetDate()
	11/27/2001 K. Claver	  Added code to accomodate for Microsoft SQL Server.

***************************************************************************************/


DATETIME l_dtTimeStamp

//
//		Determine which DBMS
//

CHOOSE CASE SQLCA.DBMS
	CASE 'SYC', 'SYB', 'MSS', 'SNC'
		SELECT getdate( ) INTO :l_dtTimeStamp FROM cusfocus.one_row;
	CASE 'OR7'
		SELECT SYSDATE INTO :l_dtTimeStamp FROM DUAL;
	CASE 'ODBC'
		SELECT GetDate() INTO :l_dtTimeStamp FROM cusfocus.one_row;
END CHOOSE

RETURN l_dtTimeStamp
end function

on w_response_std.create
call super::create
end on

on w_response_std.destroy
call super::destroy
end on

event pc_setoptions;call super::pc_setoptions;////******************************************************************
////  PC Module     : w_Response_Std
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
////------------------------------------------------------------------
////  If a popup menu other than the default (m_popup_win) needs to
////  be used, then use the fw_SetPopup() function to give the
////  popup menu.  The parameters for this function are:
////
////     MENU Menu_Name -
////        The name of the popup menu.
////------------------------------------------------------------------
//
//fw_SetPopup(m_client.Item[1])
//
end event

event pc_setcodetables;call super::pc_setcodetables;////******************************************************************
////  PC Module     : w_Response_Std
////  Event         : pc_SetCodeTables
////  Description   : Provide the opportunity for the developer
////                  to load code tables for controls on the window. 
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

event pc_setvariables;call super::pc_setvariables;////******************************************************************
////  PC Module     : w_Response_Std
////  Event         : pc_SetVariables
////  Description   : Provides the opportunity for the developer to
////                  set instance variables passed into the window
////                  prior to the openning or refreshing of the
////                  current window. 
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
////------------------------------------------------------------------
////  Sample code to save a POWEROBJECT value passed into the window.
////  Value is saved in an instance variable so it may be used in
////  other places in the window.
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
////  PC Module     : w_Response_Std
////  Event         : pc_Close
////  Description   : Provide the opportunity for the developer
////                  to do things to the window when the window
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
////  PC Module     : w_Response_Std
////  Event         : pc_CloseQuery
////  Description   : Provide the opportunity for the developer
////                  to do things to the window before a window 
////                  is allowed to close.  Setting Error.i_FWError 
////                  to c_Fatal will prevent the window from closing.
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

