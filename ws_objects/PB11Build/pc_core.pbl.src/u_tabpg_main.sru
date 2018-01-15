$PBExportHeader$u_tabpg_main.sru
$PBExportComments$Base tabpage object with resize service
forward
global type u_tabpg_main from userobject
end type
end forward

global type u_tabpg_main from userobject
integer width = 411
integer height = 432
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event resize pbm_size
end type
global u_tabpg_main u_tabpg_main

type variables
//resize service
n_cst_resize	inv_resize
end variables

forward prototypes
public function integer of_setresize (boolean ab_switch)
public function datetime fu_gettimestamp ()
public function string fu_getkeyvalue (string table_name)
end prototypes

event resize;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  resize
//
//	Description:
//	Send resize notification to services
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0.02   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

// Notify the resize service that the object size has changed.
If IsValid (inv_resize) Then
	inv_resize.Event pfc_resize (sizetype, This.Width, This.Height)
End If
end event

public function integer of_setresize (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetResize
//
//	Access:  public
//
//	Arguments:		
//	ab_switch   starts/stops the window resize service
//
//	Returns:  integer
//	 1 = success
//	 0 = no action necessary
//	-1 = error
//
//	Description:
//	Starts or stops the window resize service
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	6.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Integer	li_rc

// Check arguments
If IsNull (ab_switch) Then
	Return -1
End If

If ab_Switch Then
	If Not IsValid (inv_resize) Then
		inv_resize = Create n_cst_resize
		inv_resize.of_SetOrigSize (This.Width, This.Height)
		li_rc = 1
	End If
Else
	If IsValid (inv_resize) Then
		Destroy inv_resize
		li_rc = 1
	End If
End If

Return li_rc

end function

public function datetime fu_gettimestamp ();/****************************************************************************************

			Function:	fu_gettimestamp
			Purpose:		To get a timestamp (current date and time) from the database server
			Parameters:	None
			Returns:		A datetime timestamp

	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/9/99   M. Caruso     Corrected ODBC method for obtaining a timestamp using GetDate()
	11/27/2001 K. Claver   Added code to accomodate for Microsoft SQL Server.
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

public function string fu_getkeyvalue (string table_name);//***********************************************************************************************
//
//  Function:	 fw_getkeyvalue
//  Purpose:    TO get a unique key from the Key Table
//  Parameters: Table_Name
//  Returns:    A string that is a unique key
//
//  Date     Developer    Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/06/00 C. Jackson  Original Version
//  11/10/00 C. Jackson  Correct error message was Messagebox(String(SQLCA.SQLDBCode), 
//                       SQLCA.SQLErrText) - too general.  Was displaying simply '3' in title bar 
//                       and no text in some cases.
//	 12/19/2002 K. Claver Modified to work with split-out key generation tables
//
//***********************************************************************************************

STRING  l_cCommand, l_cKeyTable, l_cTranName, ls_user
LONG	  l_nKeyValue, ll_tran_count
INT     l_nCounter
BOOLEAN l_bAutoCommit

// Get UserID
ls_User = OBJCA.WIN.fu_GetLogin(SQLCA)

//Determine which key table to use		
CHOOSE CASE table_name
	CASE "assigned_special_flags"
		l_cKeyTable = "cusfocus.special_flags_keygen"
		l_cTranName = "sflkey"
	CASE "carve_out_entries"
		l_cKeyTable = "cusfocus.carve_out_entries_keygen"
		l_cTranName = "coekey"
	CASE "case_forms"
		l_cKeyTable = "cusfocus.case_forms_keygen"
		l_cTranName = "cfrkey"
	CASE "case_log"
		l_cKeyTable = "cusfocus.case_log_keygen"
		l_cTranName = "clgkey"
	CASE "case_log_master_num"
		l_cKeyTable = "cusfocus.case_log_masternum_keygen"
		l_cTranName = "clmkey"
	CASE "case_notes"
		l_cKeyTable = "cusfocus.case_notes_keygen"
		l_cTranName = "cnokey"
	CASE "case_transfer"
		l_cKeyTable = "cusfocus.case_transfer_keygen"
		l_cTranName = "ctrkey"
	CASE "contact_notes"
		l_cKeyTable = "cusfocus.contact_notes_keygen"
		l_cTranName = "ctnkey"
	CASE "contact_person"
		l_cKeyTable = "cusfocus.contact_person_keygen"
		l_cTranName = "cprkey"
	CASE "correspondence"
		l_cKeyTable = "cusfocus.correspondence_keygen"
		l_cTranName = "crpkey"
	CASE "cross_reference"
		l_cKeyTable = "cusfocus.cross_reference_keygen"
		l_cTranName = "crrkey"
	CASE "other_source"
		l_cKeyTable = "cusfocus.other_source_keygen"
		l_cTranName = "otskey"
	CASE "reminders"
		l_cKeyTable = "cusfocus.reminders_keygen"
		l_cTranName = "remkey"
	CASE "reopen_log"
		l_cKeyTable = "cusfocus.reopen_log_keygen"
		l_cTranName = "reokey"
	CASE ELSE
		l_cKeyTable = "cusfocus.key_generator"
		l_cTranName = "kgnkey"
END CHOOSE


// RAP 12/18/2008 These lines will tell you how many transactions you have open
//l_cCommand =  "SELECT @@trancount"
////Prepare the staging area
//PREPARE SQLSA FROM :l_cCommand USING SQLCA;
//
////Describe staging into description area
//DESCRIBE SQLSA INTO SQLDA;
//
////Declare as cursor and fetch
//DECLARE gettrancount DYNAMIC CURSOR FOR SQLSA;
//OPEN DYNAMIC gettrancount USING DESCRIPTOR SQLDA;
//FETCH gettrancount USING DESCRIPTOR SQLDA;
//
//ll_tran_count = GetDynamicNumber( SQLDA, 1 )
//
////Close the cursor
//CLOSE gettrancount;


			// save the case components
			l_bAutoCommit = SQLCA.autocommit
			SQLCA.autocommit = FALSE

// RAP 12/18/2008 - Took this out, controlling it through the autocommit property, also added holdlocks
//l_cCommand = ( 'BEGIN TRANSACTION '+l_cTranName )
//EXECUTE IMMEDIATE :l_cCommand USING SQLCA;


//Update the key generator table
l_cCommand = "UPDATE "+l_cKeyTable+" WITH (HOLDLOCK) "+ &
				 " SET pk_id = pk_id + 1"+ &
				 " WHERE table_name = '"+table_name+"'"
				 
EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
				 

//Get the new key value.  Need to use dynamic sql as need to get a value back from
//  a generated query.
l_cCommand =  "SELECT pk_id"+ &
				  " FROM "+l_cKeyTable+" WITH (HOLDLOCK) "+ &
				  " WHERE table_name = '"+table_name+"'"
				  
//Prepare the staging area
PREPARE SQLSA FROM :l_cCommand USING SQLCA;

//Describe staging into description area
DESCRIBE SQLSA INTO SQLDA;

//Declare as cursor and fetch
DECLARE getKeyVal DYNAMIC CURSOR FOR SQLSA;
OPEN DYNAMIC getKeyVal USING DESCRIPTOR SQLDA;
FETCH getKeyVal USING DESCRIPTOR SQLDA;

l_nKeyValue = GetDynamicNumber( SQLDA, 1 )

//Close the cursor
CLOSE getKeyVal;
 

IF SQLCA.SQLCode <> 0 OR l_nKeyValue = 0 THEN
	 Messagebox(gs_appname, 'Unable to obtain primary key for '+table_name+' contact your System Administrator.')
	 l_cCommand = ( 'ROLLBACK TRANSACTION ' )
	 EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			SQLCA.autocommit = l_bAutoCommit
	 Return String(-1)
ELSE
	// RAP - 12/18/2008 took this out, controlling it though the autocommit property
//	 l_cCommand = ( 'COMMIT TRANSACTION '+l_cTranName )
//	 EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			SQLCA.autocommit = l_bAutoCommit
	 Return String(l_nKeyValue)
END IF


end function

on u_tabpg_main.create
end on

on u_tabpg_main.destroy
end on

event destructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  destructor
//
//	Description:
//	Perform cleanup.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	6.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

// Destroy instantiated services
of_SetResize(False)
end event

