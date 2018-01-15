$PBExportHeader$n_fwca_mdi.sru
$PBExportComments$Application service to handle the display of microhelp process messages
forward
global type n_fwca_mdi from n_fwca_mgr
end type
end forward

global type n_fwca_mdi from n_fwca_mgr
string DataObject="d_fwca_mdi_std"
end type
global n_fwca_mdi n_fwca_mdi

forward prototypes
public subroutine fu_setmicrohelp (string help_id, integer num_strings, string string_parms[])
public subroutine fu_setmicrohelp (string help_id)
end prototypes

public subroutine fu_setmicrohelp (string help_id, integer num_strings, string string_parms[]);//******************************************************************
//  PC Module     : n_FWCA_MDI
//  Subroutine    : fu_SetMicroHelp
//  Description   : Formats and displays the micro help specified
//                  by the id in a SetMicroHelp call.
//
//  Parameters    : STRING Help_ID -
//                     The ID of the micro help to be formatted
//                     and displayed.
//
//                  INTEGER Num_Strings -
//                     The number of string parameters to be
//                     substituted into the string.
//
//                  STRING String_Parms[] -
//                     An array containing the string parameters to
//                     be substituted into the string.
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

REAL     l_Numbers[]
INTEGER  l_HelpCnt, l_Row
STRING   l_Text
INTEGER  l_Status

//------------------------------------------------------------------
//  See if we have a blank micro help ID.
//------------------------------------------------------------------

IF help_id = "" THEN
	help_id = "Default"
END IF

//------------------------------------------------------------------
//  See if we have a valid micro help ID.
//------------------------------------------------------------------

l_HelpCnt = RowCount()
l_Row = Find("id = '" + help_id + "'", 1, l_HelpCnt)
IF l_Row > 0 THEN
	
   //---------------------------------------------------------------
   //  Get the parameters using the micro help ID.
   //---------------------------------------------------------------

   l_Text   = GetItemString(l_Row, "text")
   l_Status = GetItemNumber(l_Row, "status")

ELSE

   //---------------------------------------------------------------
   //  If the ID is not found then assume that it is a string the
   //  developer wants to display.
   //---------------------------------------------------------------

   l_Text   = help_id
	l_Status = FWCA.MGR.c_Enabled

END IF

//------------------------------------------------------------------
//  Do the formatting of the micro help text.
//------------------------------------------------------------------

IF help_id <> "Default" THEN
	l_Text = OBJCA.MGR.fu_FormatString(l_Text, 0, l_Numbers[], &
                                      num_strings, string_parms[])
END IF

//------------------------------------------------------------------
//  If the micro help is enabled, then do the SetMicroHelp call.
//------------------------------------------------------------------

IF l_Status = FWCA.MGR.c_Enabled THEN
   IF FWCA.MGR.i_MDIValid THEN
		IF FWCA.MGR.i_MDIFrame.WindowType = MDIHelp! THEN
   		FWCA.MGR.i_MDIFrame.SetMicroHelp(l_Text)
		END IF
	END IF
END IF

end subroutine

public subroutine fu_setmicrohelp (string help_id);//******************************************************************
//  PC Module     : n_FWCA_MDI
//  Subrouti      : fu_SetMicroHelp
//  Description   : Formats and displays the micro help specified
//                  by the id in a SetMicroHelp call.
//
//  Parameters    : STRING Help_ID -
//                     The ID of the micro help to be formatted
//                     and displayed.
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

STRING l_Strings[]

fu_SetMicroHelp(help_id, 0, l_Strings[])
end subroutine

on n_fwca_mdi.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_fwca_mdi.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

