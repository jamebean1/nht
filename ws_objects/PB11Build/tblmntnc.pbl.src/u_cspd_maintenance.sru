$PBExportHeader$u_cspd_maintenance.sru
$PBExportComments$Correspondence maintenance container for Table Maintenance.
forward
global type u_cspd_maintenance from u_container_std
end type
type dw_docdetails from u_dw_std within u_cspd_maintenance
end type
type dw_doclist from u_dw_std within u_cspd_maintenance
end type
type cb_delete from commandbutton within u_cspd_maintenance
end type
type cb_export from commandbutton within u_cspd_maintenance
end type
type cb_import from commandbutton within u_cspd_maintenance
end type
type st_doclist from statictext within u_cspd_maintenance
end type
type gb_docdetails from groupbox within u_cspd_maintenance
end type
end forward

global type u_cspd_maintenance from u_container_std
integer width = 3579
integer height = 1592
boolean border = false
dw_docdetails dw_docdetails
dw_doclist dw_doclist
cb_delete cb_delete
cb_export cb_export
cb_import cb_import
st_doclist st_doclist
gb_docdetails gb_docdetails
end type
global u_cspd_maintenance u_cspd_maintenance

type variables
STRING	i_cCaseTypes[]
STRING	i_cSourceTypes[]
end variables

forward prototypes
public function boolean fu_isdocumentused (string a_cletterid)
public subroutine fu_deletedoc ()
end prototypes

public function boolean fu_isdocumentused (string a_cletterid);/*****************************************************************************************
   Function:   fu_IsDocumentUsed
   Purpose:    Determine if the document is used in another part of the database.
   Parameters: None
   Returns:    BOOLEAN - TRUE:	The document is in use in the system
								 FALSE:	The document is not used in the system

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/06/01 M. Caruso    Created.
	12/09/01 M. Caruso    Updated to use Dynamic SQL.
*****************************************************************************************/

BOOLEAN	l_bFound, l_bDbError
INTEGER	l_nStatementCount, l_nIndex
LONG		l_nRowCount
STRING	l_cSQLArray[]

// define SQL for tables to check
l_cSQLArray[1] = "SELECT Count(correspondence_id) " + &
					  "FROM cusfocus.correspondence " + &
					  "WHERE letter_id = ?"
					  
l_cSQLArray[2] = "SELECT Count(case_type) " + &
					  "FROM cusfocus.case_types " + &
					  "WHERE letter_id = ?"
					  
l_cSQLArray[3] = "SELECT Count(survey_id) " + &
					  "FROM cusfocus.survey_results " + &
					  "WHERE letter_id = ?"

// perform the appropriate table checks
DECLARE l_csrTableCheck DYNAMIC CURSOR FOR SQLSA;
l_nStatementCount = UpperBound (l_cSQLArray[])
FOR l_nIndex = 1 TO l_nStatementCount
	
	PREPARE SQLSA FROM :l_cSQLArray[l_nIndex];
	OPEN DYNAMIC l_csrTableCheck USING :a_cLetterID;
	
	// if the OPEN failed, exit the check
	IF SQLCA.SQLCode <> 0 THEN
		l_bDbError = TRUE
		EXIT
	END IF
	
	FETCH l_csrTableCheck INTO :l_nRowCount;
	CLOSE l_csrTableCheck;
	
	// if the CLOSE failed, exit the check
	IF SQLCA.SQLCode <> 0 THEN
		l_bDbError = TRUE
		EXIT
	END IF
	
	IF l_nRowCount = 0 THEN
		l_bFound = FALSE
	ELSE
		l_bFound = TRUE
		EXIT
	END IF
	
NEXT

IF l_bDbError THEN

	// report error and RETURN FALSE
	MessageBox (gs_appname, 'A database error ocurred while checking the document usage.~r~n' + &
									'The requested change cannot be made at this time.')
	RETURN FALSE

ELSE
	RETURN l_bFound
END IF
end function

public subroutine fu_deletedoc ();/*****************************************************************************************
   Function:   fu_DeleteDoc
   Purpose:    Process the deletion of a record from the Letter_Types table module.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/22/02 M. Caruso    Created.
*****************************************************************************************/

BOOLEAN	l_bAllowDelete, l_bDeleteFromList
LONG		l_nRows[], l_nNumRows
STRING	l_cLetterID

// determine if the record may be deleted.
CHOOSE CASE FWCA.MGR.i_WindowCurrentDW.DataObject
	CASE 'd_doclist'
		l_cLetterID = dw_DocList.GetItemString (dw_DocList.i_CursorRow, 'letter_id')
		IF fu_IsDocumentUsed (l_cLetterID) THEN
			MessageBox (gs_appname, 'This document cannot be deleted because it is already used in the system.')
			l_bAllowDelete = FALSE
		ELSE
			l_bAllowDelete = TRUE
		END IF
		
	CASE 'd_docdetails'
		IF dw_DocDetails.GetItemStatus (1, 0, Primary!) = New! OR &
			dw_DocDetails.GetItemStatus (1, 0, Primary!) = NewModified! THEN
			// if the record has not been saved yet, it may be deleted.
			l_bAllowDelete = TRUE
		ELSE
			l_cLetterID = dw_DocList.GetItemString (dw_DocList.i_CursorRow, 'letter_id')
			IF fu_IsDocumentUsed (l_cLetterID) THEN
				MessageBox (gs_appname, 'This document cannot be deleted because it is already used in the system.')
				l_bAllowDelete = FALSE
			ELSE
				l_bAllowDelete = TRUE
			END IF
		END IF
		
END CHOOSE

// if the document is allowed to be deleted, continue deletion process.
IF l_bAllowDelete THEN
	
	l_nNumRows = dw_DocList.fu_GetSelectedRows (l_nRows[])
	IF l_nNumRows > 0 THEN
		dw_DocList.fu_Delete (l_nNumRows, l_nRows[], c_SaveChanges)
	ELSE
		// If no rows are selected, the record to delete is new so just reset focus to the list datawindow.
		l_nRows[1] = dw_DocList.i_CursorRow
		dw_DocList.fu_SetSelectedRows (1, l_nRows[], dw_DocList.c_ignorechanges, dw_DocList.c_refreshchildren)
		dw_DocDetails.SetFocus ()
	END IF
	
	// commit changes to the database.
	dw_DocList.fu_Save (dw_DocList.c_SaveChanges)
	
END IF
end subroutine

on u_cspd_maintenance.create
int iCurrent
call super::create
this.dw_docdetails=create dw_docdetails
this.dw_doclist=create dw_doclist
this.cb_delete=create cb_delete
this.cb_export=create cb_export
this.cb_import=create cb_import
this.st_doclist=create st_doclist
this.gb_docdetails=create gb_docdetails
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_docdetails
this.Control[iCurrent+2]=this.dw_doclist
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_export
this.Control[iCurrent+5]=this.cb_import
this.Control[iCurrent+6]=this.st_doclist
this.Control[iCurrent+7]=this.gb_docdetails
end on

on u_cspd_maintenance.destroy
call super::destroy
destroy(this.dw_docdetails)
destroy(this.dw_doclist)
destroy(this.cb_delete)
destroy(this.cb_export)
destroy(this.cb_import)
destroy(this.st_doclist)
destroy(this.gb_docdetails)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Initialize the container object

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/14/01 M. Caruso    Created.
*****************************************************************************************/

// set the list of case types
i_cCaseTypes[1] = 'inquiry'
i_cCaseTypes[2] = 'issue_concern'
i_cCaseTypes[3] = 'proactive'
i_cCaseTypes[4] = 'configurable'

// set the list of source types
i_cSourceTypes[1] = 'member'
i_cSourceTypes[2] = 'provider'
i_cSourceTypes[3] = 'employer_group'
i_cSourceTypes[4] = 'other'
end event

type dw_docdetails from u_dw_std within u_cspd_maintenance
integer x = 59
integer y = 880
integer width = 2821
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_docdetails"
boolean border = false
end type

event itemchanged;call super::itemchanged;/*****************************************************************************************
   Event:      itemchanged
   Purpose:    Process this code when a column value has changed.




   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/07/01 M. Caruso    Created.
	02/13/02 M. Caruso    Prevent changing of document type if the document is already used
								 in the system.
	03/05/02 M. Caruso    Added calls to fu_UpdateRowStatus ().
	04/02/02 M. Caruso    If the currentvalue for a case type or source type checkbox is
								 NULL, set the value to '*' for inclusion in l_cValue.
*****************************************************************************************/
INTEGER	l_nIndex
STRING	l_cColName, l_cLetterID, l_cValue, l_cCurrentValue

l_cColName = dwo.Name

CHOOSE CASE l_cColName
	CASE 'active'
		IF data = 'N' THEN
			
			l_cLetterID = GetItemString (row, 'letter_id')
			IF fu_IsDocumentUsed (l_cLetterID) THEN
				MessageBox (gs_appname, 'This document cannot be deactivated because it is~r~n' + &
												'already being used in the application.')
				SetItem (row, 'active', 'Y')
				SetItemStatus (row, 'active', Primary!, NotModified!)
				fu_UpdateRowStatus ()
				RETURN 1		// reject the change in value and do not allow focus to change.
			ELSE
				RETURN 0
			END IF
			
		END IF

	CASE 'inquiry','issue_concern','proactive','configurable'
		FOR l_nIndex = 1 TO 4
			IF l_cColName = i_cCaseTypes[l_nIndex] THEN
				l_cValue += data
			ELSE
				l_cCurrentValue = GetItemString (row, i_cCaseTypes[l_nIndex])
				IF IsNull (l_cCurrentValue) THEN	l_cCurrentValue = '*'
				l_cValue += l_cCurrentValue
			END IF
		NEXT
		SetItem (row, 'case_types', l_cValue)

	CASE 'member','provider','employer_group','other'	
		FOR l_nIndex = 1 TO 4
			IF l_cColName = i_cSourceTypes[l_nIndex] THEN
				l_cValue += data
			ELSE
				l_cCurrentValue = GetItemString (row, i_cSourceTypes[l_nIndex])
				IF IsNull (l_cCurrentValue) THEN	l_cCurrentValue = '*'
				l_cValue += l_cCurrentValue
			END IF
		NEXT
		SetItem (row, 'source_types', l_cValue)

	CASE 'letter_survey'
		// check if the document is already used in the system
		l_cLetterID = GetItemString (row, 'letter_id')
		IF IsNull (l_cLetterID) THEN
			// if the letter ID is null, it can't be in use therefore allow the change.
			RETURN 0
		ELSE
			IF fu_IsDocumentUsed (l_cLetterID) THEN
				MessageBox (gs_appname, 'The document type cannot be changed because this document~r~n' + &
												'is already being used in the application.')
				IF data = 'N' THEN
					SetItem (row, 'letter_survey', 'Y')
				ELSE
					SetItem (row, 'letter_survey', 'N')
				END IF
				SetItemStatus (row, 'letter_survey', Primary!, NotModified!)
				fu_UpdateRowStatus ()
				RETURN 2		// reject the change in value but allow focus to change.
			ELSE
				RETURN 0		// allow the change.
			END IF
		END IF

	CASE ELSE
		RETURN 0
		
END CHOOSE
end event

event pcd_new;call super::pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    Intialize a new record

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
	03/04/03 M. Caruso    Added SetItem statement to set the configurable case type name.
*****************************************************************************************/

// set document defaults
SetItem (1, 'letter_survey', 'N')
SetItem (1, 'active', 'N')
SetItem (1, 'inquiry', 'I')
SetItem (1, 'issue_concern', 'C')
SetItem (1, 'proactive', 'P')
SetItem (1, 'configurable', 'M')
SetItem (1, 'case_types','ICPM')
SetItem (1, 'member', 'C')
SetItem (1, 'provider', 'P')
SetItem (1, 'employer_group', 'E')
SetItem (1, 'other', 'O')
SetItem (1, 'source_types','CPEO')
SetItem (1, 'system_options_option_value', gs_configcasetype)

// update the interface
THIS.Object.active.Protect = 1
THIS.Object.active.Background.Mode = 1
cb_export.Enabled = FALSE
cb_delete.Enabled = FALSE
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Intialize the record retrieved

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/29/01 M. Caruso    Created.
	12/17/01 M. Caruso    Set item status to NotModified! after updating the interface for
								 the record.
*****************************************************************************************/
LONG		l_nRtn, ll_errorcheck, ll_null, ll_row
STRING	l_cSelected, l_cFileName, l_cValue
DATAWINDOWCHILD ldwc_lob

l_cSelected = parent_dw.GetItemString (selected_rows[1], "letter_id")

l_nRtn = Retrieve (l_cSelected)

CHOOSE CASE l_nRtn
	CASE IS < 0
   	Error.i_FWError = c_Fatal
		
	CASE 0
		THIS.Enabled = FALSE
		
	CASE ELSE
		// update the interface
		THIS.Enabled = TRUE
		l_cValue = GetItemString (1, 'case_types')
		SetItem (1, 'inquiry', Mid (l_cValue,1,1))
		SetItem (1, 'issue_concern', Mid (l_cValue,2,1))
		SetItem (1, 'proactive', Mid (l_cValue,3,1))
		SetItem (1, 'configurable', Mid (l_cValue,4,1))
		
		l_cValue = GetItemString (1, 'source_types')
		SetItem (1, 'member', Mid (l_cValue,1,1))
		SetItem (1, 'provider', Mid (l_cValue,2,1))
		SetItem (1, 'employer_group', Mid (l_cValue,3,1))
		SetItem (1, 'other', Mid (l_cValue,4,1))
		
		l_cFileName = GetItemString (1, 'letter_tmplt_filename')
		IF IsNull (l_cFileName) THEN
			
			THIS.Object.active.Protect = 1
			THIS.Object.active.Background.Mode = 1
			cb_export.Enabled = FALSE
			cb_delete.Enabled = FALSE
			
		ELSE
			
			THIS.Object.active.Protect = 0
			THIS.Object.active.Background.Mode = 0
			cb_export.Enabled = TRUE
			cb_delete.Enabled = TRUE
			
		END IF
		
		// make the record show up as unchanged.
		SetItemStatus (1, 0, Primary!, NotModified!)
		
//		// Insert a choice of (none) for line of business
		ll_errorcheck = GetChild('line_of_business_id', ldwc_lob)
		ldwc_lob.SetTransObject(SQLCA)
		ll_errorcheck = ldwc_lob.Retrieve()
		SetNull(ll_null)
		ll_row = ldwc_lob.InsertRow(0)
		ldwc_lob.SetItem(ll_row, 'line_of_business_name', '(None)')
		ldwc_lob.SetItem(ll_row, 'line_of_business_id', ll_null)
		ldwc_lob.Sort()
		
	
END CHOOSE
end event

event pcd_validatecol;call super::pcd_validatecol;/*****************************************************************************************
   Event:      pcd_validatecol
   Purpose:    Validate the current column

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
	03/26/02 M. Caruso    Moved validation of name field to pcd_validaterow.
*****************************************************************************************/
STRING	l_cMsg

IF in_save THEN
	
	// what to process if saving the record
	CHOOSE CASE col_name
		CASE "active"
			IF col_text = 'N' THEN
				IF fu_IsDocumentUsed (col_text) THEN
					SetItem (row_nbr, col_nbr, "Y")
					Error.i_FWError = c_ValFixed
				END IF
			END IF
		
	END CHOOSE
	
	// display the error message if one was generated
	IF l_cMsg <> '' THEN	MessageBox (gs_appname, l_cMsg)
			
ELSE
	
	// what to process if not saving the record
	CHOOSE CASE col_name
		CASE "active"
			IF col_text = 'N' THEN
				IF fu_IsDocumentUsed (col_text) THEN
					SetItem (row_nbr, col_nbr, "Y")
					Error.i_FWError = c_ValFixed
				END IF
			END IF
		
	END CHOOSE
	
	// display the error message if one was generated
	IF l_cMsg <> '' THEN	MessageBox (gs_appname, l_cMsg)
	
END IF
end event

event pcd_setkey;call super::pcd_setkey;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    Intialize a new record

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
*****************************************************************************************/
STRING	l_cLetterID

// only add key to new rows that have been modified.
IF GetItemStatus (1, 0, Primary!) = NewModified! THEN
	
	IF dw_doclist.RowCount () = 0 THEN
		l_cLetterID = '1'
	ELSE
		l_cLetterID = STRING (dw_doclist.GetItemNumber (1, 'max_key') + 1)
	END IF
	SetItem (1, 'letter_id', l_cLetterID)
	
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize the datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/29/01 M. Caruso    Created.
*****************************************************************************************/
fu_SetOptions (SQLCA, dw_doclist, c_DetailEdit + c_NoEnablePopup)
end event

event pcd_validaterow;call super::pcd_validaterow;/*****************************************************************************************
   Event:      pcd_validaterow
   Purpose:    Perform this record validation.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/17/01 M. Caruso    Created.
	03/22/02 M. Caruso    Prevent saving if no name is specified.
*****************************************************************************************/
STRING	l_cUserName, l_cValue, l_cLetterName, l_cLetterSurvey
DATETIME	l_dtTimeStamp
LONG ll_rowcount, ll_index, ll_doclist_row

IF in_save THEN
	
	// abort the save process if a letter type and name are not specified
	l_cLetterName = trim(GetItemString (i_CursorRow, 'letter_name'))
	IF IsNull (l_cLetterName) OR TRIM (l_cLetterName) = '' THEN
		
		MessageBox (gs_appname, 'You must specify a name for this document before saving.')
		SetColumn ('letter_name')
		Error.i_FWError = c_ValFailed
		
	ELSE
		
		ll_RowCount = dw_doclist.RowCount( )
		ll_doclist_row = dw_doclist.GetSelectedRow(0)
		
// RAP - Took this out 12/2/08 because BCBSVT unchecks all of the options for a letter and imports
// a new one with the same name.
//		// loop through the rows in the datawindow to verify that this is a valid customer satisfaction code
//		FOR ll_Index = 1 TO ll_RowCount
//			IF dw_doclist.GetItemString( ll_Index, "letter_name" ) = l_cLetterName  AND ll_Index <> ll_doclist_row  THEN
//				Messagebox( gs_AppName, "The letter name must be unique.  Please~r~n"+ &
//								"correct this value to continue.", StopSign!, OK! )
//							
//				Error.i_FWError = c_ValFailed
//				EXIT
//			END IF					
//		NEXT

		// Get and set the user ID and timestamp
		l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp ()
		l_cUserName = OBJCA.WIN.fu_GetLogin (SQLCA)
		SetItem (i_CursorRow, 'updated_by', l_cUserName)
		SetItem (i_CursorRow, 'updated_timestamp', l_dtTimeStamp)	
		
	END IF
	
END IF
end event

type dw_doclist from u_dw_std within u_cspd_maintenance
integer x = 37
integer y = 92
integer width = 3479
integer height = 696
integer taborder = 10
string dataobject = "d_doclist"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_delete;call super::pcd_delete;/*****************************************************************************************
   Event:      pcd_delete
   Purpose:    This processes before the ancestor code. 

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
	12/05/01 C. Jackson   Spelling: changed "can not" to "cannot" (SCR 2497)
	03/22/02 M. Caruso    Moved this functionality to fu_deletedoc().
*****************************************************************************************/

//LONG		l_nRowCount
//STRING	l_cKeyValue, l_cLetter
//
//l_cKeyValue = GetItemString (i_CursorRow, 'letter_id')
//// check the correspondence table
//SELECT COUNT(*) INTO :l_nRowCount
//  FROM cusfocus.correspondence
// WHERE letter_id =:l_cKeyValue USING SQLCA;
//
//CHOOSE CASE SQLCA.SQLCode
//	CASE 0, 100
//		IF l_nRowCount > 0 THEN
//			MessageBox(gs_AppName, 'You cannot delete this document since there are still records' + &
//										  ' in the Correspondence table that reference it.') 	
//			RETURN -1
//		END IF
//		
//	CASE -1
//		MessageBox(gs_AppName, 'Database error performing concurrency check. Entry cannot be deleted.') 	
//		RETURN -1
//		
//END CHOOSE
//
//// if this is a survey, check survey results, too.
//l_cLetter = GetItemString (i_CursorRow, 'letter_survey')
//IF l_cLetter = 'N' THEN
//	
//	SELECT COUNT(*) INTO :l_nRowCount
//	  FROM cusfocus.survey_results
//	 WHERE letter_id =:l_cKeyValue USING SQLCA;
//
//	CHOOSE CASE SQLCA.SQLCode
//		CASE 0, 100
//			IF l_nRowCount > 0 THEN
//				MessageBox(gs_AppName, 'You cannot delete this document since there are still records' + &
//											  ' in Survey Results that reference it.') 	
//				RETURN -1
//			END IF
//			
//		CASE -1
//			MessageBox(gs_AppName, 'Database error performing concurrency check. Entry cannot be deleted.') 	
//			RETURN -1
//		
//	END CHOOSE
//	
//END IF
//
//// if not found in either place, continue with the ancestor script
//CALL SUPER::pcd_delete
//
//// make sure changes are saved.
//IF DeletedCount () > 0 THEN fu_Save (c_SaveChanges)
	
	
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve data for this datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
*****************************************************************************************/

LONG l_nRtn

l_nRtn = Retrieve()

CHOOSE CASE l_nRtn
	CASE IS < 0
	   Error.i_FWError = c_Fatal
		
	CASE 0
		
		
	CASE ELSE
		
		
END CHOOSE
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize the datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/29/01 M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_MasterList + c_ModifyOnSelect + c_DeleteOK + &
										  c_NoEnablePopup + c_SortClickedOK)
end event

type cb_delete from commandbutton within u_cspd_maintenance
integer x = 2935
integer y = 1388
integer width = 512
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Document"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Delete the document image associated with the current correspondence entry.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
	12/12/01 M. Caruso    Set focus back to the detail datawindow.
	03/26/02 M. Caruso    Abort processing if the document name is blank.
*****************************************************************************************/

INTEGER	l_nRtn
STRING	l_cFileName, l_cLetterID, l_cMsg, l_cNull, l_cLetterName
BLOB		l_blbNull

// ensure UPDATEBLOB will run correctly
IF NOT SQLCA.AutoCommit THEN SQLCA.AutoCommit = TRUE

// abort the process if a letter name is not specified
dw_DocDetails.AcceptText ()
l_cLetterName = dw_DocDetails.GetItemString (dw_DocDetails.i_CursorRow, 'letter_name')
IF IsNull (l_cLetterName) OR TRIM (l_cLetterName) = '' THEN
	
	MessageBox (gs_appname, 'You must specify a name for this document before saving.')
	dw_DocDetails.SetColumn ('letter_name')
	dw_DocDetails.SetFocus ()
	RETURN
	
END IF

// verify that an image is stored
l_cFileName = dw_docdetails.GetItemString (1, 'letter_tmplt_filename')
IF NOT IsNull (l_cFileName) THEN
	
	l_cLetterID = dw_docdetails.GetItemString (dw_docdetails.i_Cursorrow, 'letter_id')
	IF fu_IsDocumentUsed (l_cLetterID) THEN
		MessageBox (gs_appname, 'The associated document cannot be deleted because it is~r~n' + &
										'already being used in the application.')
		RETURN 1		// reject the change in value and do not allow focus to change.
	ELSE
	
		// verify the user's desire to perform this operation
		l_cMsg = 'Are you sure you want to clear the document associated~r~n' + &
					'with this entry? This operation cannot be undone.'
		IF MessageBox (gs_appname, l_cMsg, StopSign!, YesNo!) = 2 THEN RETURN
		
		// update the image field in the database
		SetNull (l_cNull)
		UPDATE cusfocus.letter_types
			SET doc_image = :l_cNull
		 WHERE letter_id = :l_cLetterID;
			  
		CHOOSE CASE SQLCA.SQLCode
			CASE 0		
				// clear the file name
				SetNull (l_cFileName)
				dw_docdetails.SetItem (1, 'letter_tmplt_filename', l_cFileName)
				dw_docdetails.SetItem (1, 'active', 'N')
				dw_docdetails.SetItem (1, 'updated_by', OBJCA.WIN.fu_GetLogin (SQLCA))
				dw_docdetails.SetItem (1, 'updated_timestamp', w_table_maintenance.fw_GetTimeStamp ())
				CHOOSE CASE dw_docdetails.fu_Save (dw_docdetails.c_SaveChanges)
					CASE 0
						// update the interface
						dw_docdetails.Object.active.Protect = 1
						dw_docdetails.Object.active.Background.Mode = 1
						cb_export.Enabled = FALSE
						THIS.Enabled = FALSE
						
					CASE -1
						MessageBox (gs_appname, 'Unable to save the changes to the entry.')
						
					CASE -2
						MessageBox (gs_appname, 'The save service is not enabled.')
						
				END CHOOSE
			
			CASE -1
				MessageBox (gs_appname, 'Unable to delete document image from the database.')
				
			CASE 100
				MessageBox (gs_appname, 'Unable to find the document record in the database.')
		
		END CHOOSE
		
		RETURN 0
		
	END IF
	
	
END IF

dw_docdetails.SetFocus ()
end event

type cb_export from commandbutton within u_cspd_maintenance
integer x = 2935
integer y = 1240
integer width = 512
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Export to File"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Export the associated document image to a file.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
	12/12/01 M. Caruso    Set focus back to the detail datawindow.
*****************************************************************************************/

LONG		l_nFileID, l_nImageLength, l_nStart, l_nBytes
INTEGER	l_nParts, l_nCounter
STRING	l_cFullPath, l_cFileName, l_cLetterID
BLOB		l_blbFullImage, l_blbImagePart

l_cFileName = dw_docdetails.GetItemString (1, 'letter_tmplt_filename')
IF NOT IsNull (l_cFileName) THEN
	
	// get the file image from the database
	l_cLetterID = dw_docdetails.GetItemString (1, 'letter_id')
	SELECTBLOB doc_image INTO :l_blbFullImage
	      FROM cusfocus.letter_types
		  WHERE letter_id = :l_cLetterID;
		  
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			MessageBox (gs_appname, 'Unable to retrieve document image from the database.')
			RETURN
			
		CASE 100
			MessageBox (gs_appname, 'Unable to find the document image in the database.')
			RETURN
			
	END CHOOSE
			
	
	// get the file name and path to which to save.
	l_cFullPath = ''
	IF GetFileSaveName ('Export to file', l_cFullPath, l_cFileName, 'DOC') = 1 THEN
		
		IF FileExists (l_cFullPath) THEN
			IF MessageBox (gs_appname, 'Are you sure you wish to replace the existing file?', StopSign!, YesNo!) = 2 THEN
				// exit if the user does not wish to replace the file.
				RETURN
			END IF
		END IF
		
		// get the file image from the database
		l_nFileID = FileOpen (l_cFullPath, StreamMode!, Write!, LockReadWrite!, Replace!)
		IF IsNull (l_nFileID) OR l_nFileID = -1 THEN
			
			MessageBox (gs_appname, 'Unable to open the specified file.')
			RETURN
			
		ELSE
			
			l_nImageLength = Len (l_blbFullImage)
			l_nParts = Ceiling (l_nImageLength / 32765)
			l_nStart = 1
			
			// write the image to the file
			FOR l_nCounter = 1 TO l_nParts
				l_blbImagePart  = BlobMid (l_blbFullImage, l_nStart, 32765)
				l_nBytes = FileWrite(l_nFileID, l_blbImagePart)
				l_nStart = (l_nStart + 32765)
			NEXT
			
			FileClose (l_nFileID)
			
		END IF
		
	END IF
	
END IF

dw_docdetails.SetFocus ()
end event

type cb_import from commandbutton within u_cspd_maintenance
integer x = 2935
integer y = 1092
integer width = 512
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import from File"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Associate a file image with the current correspondence entry.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/01 M. Caruso    Created.
	12/12/01 M. Caruso    Set focus back to the detail datawindow.
*****************************************************************************************/

LONG		l_nFileSize, l_nFileID
INTEGER	l_nParts, l_nCounter, l_nBytes
STRING	l_cFullPath, l_cFileName, l_cLetterID, l_cMsg, l_cLetterName
BLOB		l_blbFilePart, l_blbFullFile

// ensure UPDATEBLOB will run correctly
IF NOT SQLCA.AutoCommit THEN SQLCA.AutoCommit = TRUE

// abort the process if a letter name is not specified
dw_DocDetails.AcceptText ()
l_cLetterName = dw_DocDetails.GetItemString (dw_DocDetails.i_CursorRow, 'letter_name')
IF IsNull (l_cLetterName) OR TRIM (l_cLetterName) = '' THEN
	
	MessageBox (gs_appname, 'You must specify a name for this document before saving.')
	dw_DocDetails.SetColumn ('letter_name')
	dw_DocDetails.SetFocus ()
	RETURN
	
END IF

// save the letter record first, if the record is new
l_cLetterID = dw_docdetails.GetItemString (1, 'letter_id')
IF IsNull (l_cLetterID) THEN
	IF dw_docdetails.fu_save (dw_docdetails.c_SaveChanges) = 0 THEN
		l_cLetterID = dw_docdetails.GetItemString (1, 'letter_id')
	ELSE
		MessageBox (gs_appname, 'An error occured while trying to save the document record.')
		RETURN
	END IF
END IF

// prompt to replace if a document is already associated.
l_cFileName = dw_docdetails.GetItemString (1, 'letter_tmplt_filename')
IF IsNull (l_cFileName) THEN
	l_cFileName = ''
ELSE
	
	l_cMsg = 'A document is already associated with this entry.~r~nAre you sure you want to replace it?'
	IF MessageBox (gs_appname, l_cMsg, StopSign!, YesNo!) = 2 THEN RETURN
	
END IF

// Import a new document
IF GetFileOpenName ('Select File to Import', l_cFullPath, l_cFileName, 'doc', 'Word Documents (*.doc),*.doc') = 1 THEN
			
	SetPointer(HourGlass!)
	
	// Get the File Length
	l_nFileSize = FileLength (l_cFullPath)
	IF l_nFileSize = -1 THEN
		MessageBox (gs_appname, 'The specified file was not found.')
		RETURN
	END IF
	
	// Get the File Number
	l_nFileID = FileOpen (l_cFullPath, StreamMode!)
	IF l_nFileID = -1 THEN
		messagebox(gs_AppName, 'Unable to import ' + l_cFileName + '.  Please make sure the file is not open.')
		RETURN
	END IF
	
	// Build the file image
	l_nParts = CEILING (l_nFileSize / 32765)
	FOR l_nCounter = 1 TO l_nParts
		l_nBytes = FileRead (l_nFileID, l_blbFilePart)
		l_blbFullFile = l_blbFullFile + l_blbFilePart
	NEXT
	
	// Close the file
	FileClose (l_nFileID)
	
	// Store the file image
	UPDATEBLOB cusfocus.letter_types
			 SET doc_image = :l_blbFullFile
		  WHERE letter_id = :l_cLetterID;
		  
	CHOOSE CASE SQLCA.SQLNRows
		CASE IS > 0
			// do final updates to the record then save
			dw_docdetails.SetItem (1, 'letter_tmplt_filename', l_cFileName)
			dw_docdetails.SetItem (1, 'active', 'Y')
			dw_docdetails.SetItem (1, 'updated_by', OBJCA.WIN.fu_GetLogin (SQLCA))
			dw_docdetails.SetItem (1, 'updated_timestamp', w_table_maintenance.fw_GetTimeStamp ())
			dw_docdetails.fu_Save (dw_docdetails.c_SaveChanges)
			
			// update the interface
			dw_docdetails.Object.active.Protect = 0
			dw_docdetails.Object.active.Background.Mode = 0
			cb_export.Enabled = TRUE
			cb_delete.Enabled = TRUE
		
		CASE ELSE
			MessageBox (gs_appname, 'The document import process failed.')
			
	END CHOOSE
	
END IF

dw_docdetails.SetFocus ()
end event

type st_doclist from statictext within u_cspd_maintenance
integer x = 27
integer y = 12
integer width = 763
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Correspondence Documents"
boolean focusrectangle = false
end type

type gb_docdetails from groupbox within u_cspd_maintenance
integer x = 37
integer y = 800
integer width = 3479
integer height = 748
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Correspondence Document Details"
end type

