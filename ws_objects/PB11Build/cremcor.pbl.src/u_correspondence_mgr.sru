$PBExportHeader$u_correspondence_mgr.sru
$PBExportComments$Correspondence printing/editing manager.
forward
global type u_correspondence_mgr from nonvisualobject
end type
end forward

global type u_correspondence_mgr from nonvisualobject
end type
global u_correspondence_mgr u_correspondence_mgr

type prototypes
Function boolean SetForegroundWindow (ulong hWnd) Library "USER32.DLL"

end prototypes

type variables
// constants
CONSTANT	STRING	i_cSurveyType = 'S'
CONSTANT	STRING	i_cLetterType = 'L'
CONSTANT	STRING	i_cSourceConsumer = 'C'
CONSTANT	STRING	i_cSourceEmployer = 'E'
CONSTANT	STRING	i_cSourceProvider = 'P'
CONSTANT	STRING	i_cSourceOther = 'O'

// variables
BOOLEAN		i_bDisplayWindow
BOOLEAN		i_bBatchMode
BOOLEAN		i_bDocFilled
BOOLEAN		i_bCaseLocked

STRING		i_cSourceType
STRING		i_cCaseSubjectId
STRING		i_cXrefSourceType
STRING		i_cXrefSubjectId
STRING		i_cDocName

S_DOC_INFO	i_sCurrentDocInfo

DATASTORE	i_dsLookUp
DATASTORE	i_dsDemographics
DATASTORE	i_dsXrefDemographics
DATASTORE	i_dsCaseDetails
DATASTORE	i_dsCaseProperties
DATASTORE	i_dsDocumentInfo
DATASTORE	i_dsAppeal
DATASTORE 	i_dsCSR
DATASTORE 	i_dsCaseNotes

W_WORD_WINDOW	i_wDocWindow

U_DW_STD		i_dwRefreshDW
OLEOBJECT	i_oleDocument


end variables

forward prototypes
public subroutine uf_refreshlist ()
public subroutine uf_processresponserqrd ()
public subroutine uf_getdocimage (boolean a_bmasterdoc, string a_cdocid, ref blob a_blbdocimage)
public subroutine uf_savecorrespondence (boolean a_bpromptuser)
public function integer uf_savecorrespondence (u_dw_std a_dwcorrespondence, blob a_blbdocimage)
public subroutine uf_validatedocument ()
public subroutine uf_closedocwindow ()
public subroutine uf_fillfield (ref datastore a_dssource, string a_cfieldname)
public subroutine uf_fillfield (ref u_dw_std a_dwsource, string a_cfieldname)
public subroutine uf_processdocs (s_doc_info a_sdocinfo[], boolean a_bprintdoc, boolean a_bbatchmode)
public subroutine uf_deletecorrespondence (string a_ccorrespondenceid)
public subroutine uf_createcorrespondence (string a_ccasenumber, string a_ccasetype)
public subroutine uf_filldocument ()
public subroutine uf_loaddocinfo ()
public function integer uf_opendocwindow (boolean a_bvisible)
public subroutine uf_applyfieldformats (string a_csourcetype, string a_ccasetype, string a_cfieldtype)
public function integer uf_loadinfo ()
public function integer uf_opendoc ()
public subroutine uf_printdoc (integer a_ncopycount)
public function boolean uf_iscaselocked (string a_ccasenumber)
public function string of_get_appeal_prop_value (long al_case_number, long al_source_type, string as_column_name)
public subroutine uf_fillfield (datastore a_dssource, string a_cfieldname, boolean ab_consumerid)
public function boolean of_modified ()
public function integer of_load_signature ()
public function string of_write_file (string as_file_name, long al_blob_id)
public function integer of_load_lob_logo ()
public subroutine of_load_case_notes (string as_note_type)
public subroutine of_filldoc ()
end prototypes

public subroutine uf_refreshlist ();/*****************************************************************************************
   Function:   uf_refreshlist
   Purpose:    If processing is based on a source datawindow, like the correspondence tab
	            or batch processing, this function will refresh that datawindow and it's
					parent if one exists.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/12/02 M. Caruso    Created.
*****************************************************************************************/

U_DW_STD	l_dwParentDW

IF IsValid (i_dwRefreshDW) THEN
	i_dwRefreshDW.fu_retrieve (i_dwRefreshDW.c_SaveChanges, i_dwRefreshDW.c_ReselectRows)
	l_dwParentDW = i_dwRefreshDW.fu_GetParentDW ()
	IF NOT IsNull (l_dwParentDW) THEN
		l_dwParentDW.fu_retrieve (i_dwRefreshDW.c_savechanges, i_dwRefreshDW.c_reselectrows)
	END IF
END IF


end subroutine

public subroutine uf_processresponserqrd ();/*****************************************************************************************
   Function:   uf_ProcessResponseRqrd
   Purpose:    Create a reminder for a required response.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/07/02 M. Caruso    Created.
	02/12/02 M. Caruso    Set "Delete When Case Closed" to 'N' by default.
	02/12/02 M. Caruso    Set Reminder Date to created date + 7 days when batch processing.
*****************************************************************************************/

STRING	l_cReminderComments, l_cReminderID, l_cUserID
DATE		l_dCreateDate, l_dReminderDate

IF i_bBatchMode THEN
	PCCA.Parm[1] = '*'
	PCCA.Parm[2] = ''
ELSE
	// prompt the user to set the reminder date
	FWCA.MGR.fu_OpenWindow(w_set_reminder_date, 0)
END IF

IF PCCA.Parm[1] = '' THEN
	
	// if the return value is ''. uncheck Response Rqrd
	i_dsDocumentInfo.SetItem (1, 'corspnd_response_rqrd', 'N')
	
ELSE
	
	// otherwise, create the reminder
	l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)
	IF IsValid (i_wDocWindow) THEN
		l_dCreateDate = Date (i_wDocWindow.fw_GetTimeStamp ())
		l_cReminderID = i_wDocWindow.fw_getkeyvalue('reminders')
	ELSEIF IsValid (w_create_maintain_case) THEN
		l_dCreateDate = Date (w_create_maintain_case.fw_GetTimeStamp ())
		l_cReminderID = w_create_maintain_case.fw_getkeyvalue('reminders')
	ELSEIF IsValid (w_batch_correspondence) THEN
		l_dCreateDate = Date (w_batch_correspondence.fw_GetTimeStamp ())
		l_cReminderID = w_batch_correspondence.fw_getkeyvalue('reminders')
	END IF
	IF PCCA.Parm[1] = '*' THEN
		l_dReminderDate = RelativeDate (l_dCreateDate, 7)
	ELSE
		l_dReminderDate = Date (PCCA.Parm[1])
	END IF
	l_cReminderComments = PCCA.Parm[2]
	
	// insert the reminder record
	INSERT INTO cusfocus.reminders (reminder_id, reminder_type_id, reminder_viewed, case_number, case_type,
			case_reminder, reminder_crtd_date, reminder_set_date, reminder_subject, 
			reminder_comments, reminder_dlt_case_clsd, reminder_author, reminder_recipient)
	VALUES (:l_cReminderID, '1', 'N', :i_sCurrentDocInfo.a_cCaseNumber, 
			:i_sCurrentDocInfo.a_cCaseType, 'Y', :l_dCreateDate, :l_dReminderDate, 
			'Response Rqrd Correspondence', :l_cReminderComments, 'N', :l_cUserID, 
 			:l_cUserID);
			 
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox(gs_AppName, 'Unable to create Reminder.')
		MessageBox(STRING(SQLCA.SQLDBCOde), SQLCA.SQLErrText)
	END IF
	
END IF
end subroutine

public subroutine uf_getdocimage (boolean a_bmasterdoc, string a_cdocid, ref blob a_blbdocimage);/*****************************************************************************************
   Function:   uf_GetDocImage
   Purpose:    To retrieve a master document image from the database.
   Parameters: BOOLEAN	a_bMasterDoc - is this a master document?
					STRING	a_cDocID - the letter_type ID or correspondence_id.
					BLOB		a_blbDocImage - used to return the document image, or NULL if an error
	                                     occurs.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/02/02 M. Caruso    Created.
	02/11/02 M. Caruso    Modified to get doc image from Correspondence table.
*****************************************************************************************/
LONG ll_hist_key

IF a_bMasterDoc THEN

	SELECTBLOB doc_image INTO :a_blbDocImage
	FROM cusfocus.letter_types
	WHERE letter_id = :a_cDocID;

ELSEIF Left(a_cDocID, 9) = "History: " THEN

	ll_hist_key = Long(MID(a_cDocID, 10))
	
	SELECTBLOB corspnd_doc_image INTO :a_blbDocImage
	FROM cusfocus.correspondence_history
	WHERE correspondence_hist_key = :ll_hist_key;
	
ELSE
	
	SELECTBLOB corspnd_doc_image INTO :a_blbDocImage
	FROM cusfocus.correspondence
	WHERE correspondence_id = :a_cDocID;
	
END IF

IF SQLCA.SQLNRows < 1 THEN
	SetNull (a_blbDocImage)
END IF
end subroutine

public subroutine uf_savecorrespondence (boolean a_bpromptuser);/*****************************************************************************************
   Function:   uf_SaveCorrespondence
   Purpose:    Save the document back to the database. This is used for saving a document
					open in the editing window.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/24/02 M. Caruso    Created.
	02/11/02 M. Caruso    Removed call to uf_SaveCorrespondenceDoc and added replacement
								 code here.
	02/12/02 M. Caruso    Do not refresh source datawindow if in Batch Mode.
*****************************************************************************************/

INTEGER	l_nRtn, l_nStatus
U_DW_STD	l_dwParentDW
String ls_title

IF a_bPromptUser THEN
	ls_title = i_wDocWindow.title
	i_wDocWindow.SetFocus()
	l_nRtn = MessageBox (gs_appname, 'Would you like to save the changes to ' + ls_title + '?', Question!, YesNo!)
	IF l_nRtn = 2 THEN 
		i_wDocWindow.i_bDocModified = FALSE
		RETURN
	END IF
	
END IF

// if we're still here, save the changes
IF i_bDocFilled THEN
	
	// update the "filled" property
	IF NOT i_sCurrentDocInfo.a_bFilled THEN
		i_dsDocumentInfo.SetItem (1, 'correspondence_corspnd_doc_filled', 'Y')
		i_dsDocumentInfo.Update ()
		IF NOT i_bBatchMode THEN
			uf_RefreshList ()
		END IF
	END IF
	
END IF

// save changes to the document itself
//i_sCurrentDocInfo.a_blbDocImage = i_wDocWindow.ole_worddoc.ObjectData
i_sCurrentDocInfo.a_blbDocImage = i_wDocWindow.i_blbDocImage
//i_sCurrentDocInfo.a_lCharacter_count = i_wDocWindow.ole_worddoc.Object.Characters.Count

IF i_wDocWindow.i_bDocModified THEN
	
	UPDATEBLOB cusfocus.correspondence SET corspnd_doc_image = :i_sCurrentDocInfo.a_blbDocImage
	WHERE correspondence_id = :i_sCurrentDocInfo.a_cDocID;
	
	CHOOSE CASE SQLCA.SQLNRows
		CASE 0
			MessageBox (gs_appname, 'Unable to save the document changes.')
			
		CASE IS > 1
			MessageBox (gs_appname, 'The document changes were applied to multiple records.')
			
	END CHOOSE
	
	i_wDocWindow.i_bDocModified = FALSE
	
END IF

end subroutine

public function integer uf_savecorrespondence (u_dw_std a_dwcorrespondence, blob a_blbdocimage);/**************************************************************************************
	Function:	uf_SaveCorrespondence
	Purpose:		To save a record in the correspondence table. This version is used to
					update a document record on the correspondence tab of Case Maintenance.
	Parameters:	U_DW_STD	a_dwCorrespondence - The related correspondence datawindow.
	Returns:		INTEGER - 0: success
	                     -1: failure

	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	01/02/02 M. Caruso     Created.
	01/03/02 M. Caruso     Only call uf_savecorrespondencedoc if the doc image is not NULL.
	02/11/02 M. Caruso     Removed call to uf_SaveCorrespondenceDoc and added replacement
								  code here.
	03/29/02 M. Caruso     Do not save the document image if it is blank.
**************************************************************************************/

INTEGER	l_nStatus
STRING	l_cCorrespondenceID

// update the record in the CORRESPONDENCE table
l_nStatus = a_dwCorrespondence.fu_Save (a_dwCorrespondence.c_SaveChanges)
IF l_nStatus = 0 THEN
	
	// save the current doc image if not NULL.
	IF IsNull (a_blbDocImage) THEN
		
		l_nStatus = -1
		
	ELSE
		
		l_cCorrespondenceID = a_dwCorrespondence.GetItemString (1, 'correspondence_id')
		UPDATEBLOB cusfocus.correspondence SET corspnd_doc_image = :a_blbDocImage
		WHERE correspondence_id = :l_cCorrespondenceID;
	
		CHOOSE CASE SQLCA.SQLNRows
			CASE 0
				MessageBox (gs_appname, 'Unable to save the document changes.')
				l_nStatus = -1
				
			CASE 1
				l_nStatus = 0
				
			CASE IS > 1
				MessageBox (gs_appname, 'The document changes were applied to multiple records.')
				l_nStatus = 0
				
		END CHOOSE
		
	END IF
	
END IF

RETURN l_nStatus
end function

public subroutine uf_validatedocument ();/*****************************************************************************************
   Function:   uf_validatedocument
   Purpose:    Determine if the current document has changed and pause processing if it
					has.  When the user clicks OK to clear the prompt, reactivate the correct
					document before proceeding.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/05/02 M. Caruso    Created.
*****************************************************************************************/


CONSTANT	STRING	l_cPrompt = 'Correspondence processing has paused because the current document has~r~n' + &
										'changed.  Click OK to resume processing on the original document.'
CONSTANT STRING	l_cDefDocName = 'Document in Document'
//CONSTANT STRING	l_cDefDocName = 'Document in Correspondence Editor'
INTEGER	l_nDocCount, l_nIndex
STRING	l_cDocName

//l_cDocName = i_wDocWindow.ole_worddoc.Object.Application.ActiveDocument.Name
//
//// the correspondence window has a caption of ''
//IF l_cDocName <> l_cDefDocName THEN
//	
//	// if the document name is not l_cDefDocName, the window changed so pause processing.
//	MessageBox (gs_appname, l_cPrompt)
//	l_nDocCount = i_wDocWindow.ole_worddoc.Object.Application.Documents.Count
//	FOR l_nIndex = 1 TO l_nDocCount
//		
//		// activate the document in the ole control
//		IF i_wDocWindow.ole_worddoc.Object.Application.Documents[l_nIndex].Name = l_cDefDocName THEN
//			i_wDocWindow.ole_worddoc.Object.Application.Documents[l_nIndex].Activate
//			EXIT
//		END IF
//		
//	NEXT
//	
//END IF
end subroutine

public subroutine uf_closedocwindow ();/*****************************************************************************************
   Function:   uf_CloseDocWindow
   Purpose:    Close the window for processing correspondence.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/08/02 M. Caruso    Created.
*****************************************************************************************/

IF IsValid (i_wDocWindow) THEN
	
	IF NOT i_bCaseLocked THEN
		IF i_wDocWindow.i_bAllowSave THEN
			// if the document has been modified, begin the save process
			IF of_modified() THEN
				i_wDocWindow.i_bDocModified = TRUE
				i_wDocWindow.fw_SaveDoc (i_wDocWindow.c_promptsavedoc)
			ELSEIF i_wDocWindow.i_bDocModified THEN
				i_wDocWindow.fw_SaveDoc (i_wDocWindow.c_savedoc)
			END IF
		END IF
	END IF
	CLOSE (i_wDocWindow)
	SetNull (i_wDocWindow)
	
END IF
end subroutine

public subroutine uf_fillfield (ref datastore a_dssource, string a_cfieldname);/*****************************************************************************************
   Function:   uf_FillField
   Purpose:    Put the specified data into the current bookmark.  This version is based on
					a temporary datastore.
   Parameters: DATASTORE	a_dsSource - The datastore to get the data from.
					STRING		a_cFieldName - The field to get data from.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/07/01 M. Caruso    Created.
	08/07/01 M. Caruso    Only process if the data source contains 1 row
	04/05/02 M. Caruso    Added a call to uf_validatedocument to prevent crashing if the
								 user switches to another Word document during processing.
*****************************************************************************************/

STRING	l_cValue, l_cFormat

IF a_dsSource.RowCount () = 1 THEN

	CHOOSE CASE UPPER (Left (a_dsSource.Describe (a_cFieldName + '.ColType'), 5))
		CASE 'CHAR(', 'CHAR'    // 'CHAR' is used to trap computed columns
			l_cValue = a_dsSource.GetItemString (1, a_cFieldName)
			l_cFormat = a_dsSource.GetFormat (a_cFieldName)
			IF l_cFormat <> '!' AND l_cFormat <> '?' THEN
				l_cValue = STRING (l_cValue, l_cFormat)
			END IF
			
		CASE 'DATE'
			l_cValue = STRING (a_dsSource.GetItemDate (1, a_cFieldName), 'mm/dd/yyyy')
			
		CASE 'DATET', 'TIMES'
			l_cValue = STRING (a_dsSource.GetItemDateTime (1, a_cFieldName), 'mm/dd/yyyy hh:mm:ss AM/PM')
			
		CASE 'DECIM'
			l_cValue = STRING (a_dsSource.GetItemDecimal (1, a_cFieldName))
			
		CASE 'INT', 'LONG', 'NUMBE', 'ULONG'
			l_cValue = STRING (a_dsSource.GetItemNumber (1, a_cFieldName))
			
		CASE 'TIME'
			l_cValue = STRING (a_dsSource.GetItemTime (1, a_cFieldName), 'hh:mm:ss AM/PM')
			
	END CHOOSE

	IF IsNull (l_cValue) THEN l_cValue = ''
	uf_ValidateDocument ()
	
	// Conversion for 9-digit zip codes
	IF a_cFieldName = 'other_source_other_zip' OR &
	    a_cFieldName = 'provider_of_service_provid_zip' OR &
	    a_cFieldName = 'consumer_consum_zip' OR &
	    a_cFieldName = 'corspnd_zip' OR &
	    a_cFieldName = 'employ_zip' THEN
		 IF LEN(l_cValue) = 9 THEN
			l_cValue = MID(l_cValue, 1, 5) + "-" + MID(l_cValue, 6, 4)
		ELSEIF LEN(l_cValue) = 6 THEN
			l_cValue = MID(l_cValue, 1, 5)
		END IF
	END IF

	//??? trying the new control
//	i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
	#IF defined PBDOTNET THEN
		i_oleDocument.selection.TypeText (l_cValue)
	#ELSE
		i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
//		i_wDocWindow.ole_worddoc.Object.Application.selection.TypeText (l_cValue)
	#END IF
	
END IF
end subroutine

public subroutine uf_fillfield (ref u_dw_std a_dwsource, string a_cfieldname);/*****************************************************************************************
   Function:   uf_FillField
   Purpose:    Put the specified data into the current bookmark.  This version is based on
					an existing datawindow in the application.
   Parameters: U_DW_STD	a_dwSource - The datastore to get the data from.
					STRING	a_cFieldName - The field to get data from.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/28/01 M. Caruso    Created.
	04/05/02 M. Caruso    Added a call to uf_validatedocument to prevent crashing if the
								 user switches to another Word document during processing.
*****************************************************************************************/

STRING	l_cValue, l_cFormat

CHOOSE CASE UPPER (Left (a_dwsource.Describe (a_cFieldName + '.ColType'), 5))
	CASE 'CHAR(', 'CHAR'
		l_cValue = a_dwsource.GetItemString (1, a_cFieldName)
		l_cFormat = a_dwsource.GetFormat (a_cFieldName)
		IF l_cFormat <> '!' AND l_cFormat <> '?' THEN
			l_cValue = STRING (l_cValue, l_cFormat)
		END IF
			
	CASE 'DATE'
		l_cValue = STRING (a_dwsource.GetItemDate (1, a_cFieldName), 'mm/dd/yyyy')
		
	CASE 'DATET', 'TIMES'
		l_cValue = STRING (a_dwsource.GetItemDateTime (1, a_cFieldName), 'mm/dd/yyyy hh:mm:ss AM/PM')
		
	CASE 'DECIM'
		l_cValue = STRING (a_dwsource.GetItemDecimal (1, a_cFieldName))
		
	CASE 'INT', 'LONG', 'NUMBE', 'ULONG'
		l_cValue = STRING (a_dwsource.GetItemNumber (1, a_cFieldName))
		
	CASE 'TIME'
		l_cValue = STRING (a_dwsource.GetItemTime (1, a_cFieldName), 'hh:mm:ss AM/PM')
		
END CHOOSE

IF IsNull (l_cValue) THEN l_cValue = ''
uf_ValidateDocument ()

	// Conversion for 9-digit zip codes
	IF a_cFieldName = 'other_source_other_zip' OR &
	    a_cFieldName = 'provider_of_service_provid_zip' OR &
	    a_cFieldName = 'consumer_consum_zip' OR &
	    a_cFieldName = 'corspnd_zip' OR &
	    a_cFieldName = 'employ_zip' THEN
		 IF LEN(l_cValue) = 9 THEN
			l_cValue = MID(l_cValue, 1, 5) + "-" + MID(l_cValue, 6, 4)
		ELSEIF LEN(l_cValue) = 6 THEN
			l_cValue = MID(l_cValue, 1, 5)
		END IF
	END IF

	//??? trying the new control
//	i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
#IF defined PBDOTNET THEN
	i_oleDocument.selection.TypeText (l_cValue)
#ELSE
		i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
//	i_wDocWindow.ole_worddoc.Object.Application.selection.TypeText (l_cValue)
#END IF

end subroutine

public subroutine uf_processdocs (s_doc_info a_sdocinfo[], boolean a_bprintdoc, boolean a_bbatchmode);/*****************************************************************************************
   Function:   uf_processdocs
   Purpose:    Process the specified correspondence entries.
   Parameters: S_DOC_INFO	a_sDocInfo[] - An array of correspondence IDs to process
					BOOLEAN		a_bPrintDoc - Whether the documents are to be printed or not
					BOOLEAN		a_bBatchMode - Whether the documents are being printed in batch
   Returns:    INTEGER -  0: success
	                      -1: failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/08/02 M. Caruso    Created.
	03/27/02 M. Caruso    Corrected count of skipped documents in issue prompt.
	05/17/02 M. Caruso    Added l_nCopyCount, code to set the value, and pass it on to
								 uf_PrintDoc ().
	05/24/02 M. Caruso    POST a call to SetFocus for the doc window if it remains open.
*****************************************************************************************/

BOOLEAN	l_bPrintDoc, l_bCloseWindow
INTEGER	l_nCopyCount, l_nTemp
LONG		l_nDocCount, l_nIndex, l_nSkipCount

SetPointer (Hourglass!)

l_nDocCount = UpperBound (a_sDocInfo[])

IF l_nDocCount > 0 THEN
	
	l_bCloseWindow = TRUE
//	// If they currently have the corr open for editing, keep it open
//	IF l_nDocCount = 1 THEN
//		IF IsValid(i_wDocWindow) THEN
//			IF i_sCurrentDocInfo.a_cCaseNumber = a_sDocInfo[1].a_cCaseNumber AND i_sCurrentDocInfo.a_cDocID = a_sDocInfo[1].a_cDocID THEN
//				l_bCloseWindow = FALSE
//			END IF
//		END IF
//	END IF
	IF l_bCloseWindow THEN		
		THIS.uf_closedocwindow() // Need to open a different corr for printing
	END IF

	// if more than one document was specified, this must be a batch print process.
	IF a_bBatchMode THEN
		l_bPrintDoc = TRUE
		l_nCopyCount = 1
	ELSE
		l_bPrintDoc = a_bPrintDoc
		IF l_bPrintDoc THEN
			
			// prompt the user for print critiera
			FWCA.MGR.fu_OpenWindow (w_correspondenceprintdialog)
			IF PCCA.Parm[1] = '-1' THEN
				l_nCopyCount = INTEGER (PCCA.Parm[2])
			ELSE
				// if the user cancelled the copy count dialog, abort processing.
				RETURN
			END IF
			
		ELSE
			// indicate that prompting should occur at print time.
			l_nCopyCount = 0
		END IF
	END IF
	i_bBatchMode = a_bBatchMode

	IF l_bCloseWindow = FALSE THEN // The correct corr is already open
		IF l_bPrintDoc THEN
			uf_PrintDoc (l_nCopyCount)
		END IF
		i_wDocWindow.POST SetFocus ()
	ELSE
		// open the document window.
		IF uf_OpenDocWindow (NOT l_bPrintDoc) = 0 THEN
			
			l_nSkipCount = 0
			
			// process all documents specified.
			FOR l_nIndex = 1 TO l_nDocCount
	
				i_sCurrentDocInfo = a_sDocInfo[l_nIndex]
				
				// load the document information datastore for saving changes made in the editing window
				uf_loaddocinfo ()
				
				// get the document image to process
				uf_GetDocImage (FALSE, i_sCurrentDocInfo.a_cDocID, i_sCurrentDocInfo.a_blbDocImage)
				
				IF IsNull (i_sCurrentDocInfo.a_blbDocImage) THEN
					IF NOT i_bBatchMode THEN
						MessageBox (gs_appname, 'There is no document to edit for this correspondence entry.')
					ELSE
						l_nSkipCount ++
					END IF
					CONTINUE
				END IF
				
				IF Left(i_sCurrentDocInfo.a_cDocID, 9) <> "History: " THEN
					// check if the current case is locked
					THIS.i_bCaseLocked = uf_IsCaseLocked (i_sCurrentDocInfo.a_cCaseNumber)
					IF i_bCaseLocked THEN
						IF i_bBatchMode THEN
							l_nSkipCount ++
							CONTINUE
						ELSE
							IF l_bPrintDoc THEN
								MessageBox (gs_appname, 'This document cannot be printed because the related~r~n' + &
																'case is currently locked by another user.')
								CONTINUE
							END IF
						END IF
					END IF
				END IF
	
				// open the document for processing
				uf_OpenDoc ()
				
				// Fill in the bookmarks if necessary
				IF NOT i_sCurrentDocInfo.a_bFilled THEN
					i_bDocFilled = FALSE
					uf_FillDocument ()
				ELSE
					i_bDocFilled = TRUE
				END IF
				
				IF l_bPrintDoc THEN
					
					// for print-specific documents, call the print routine then close the document
					uf_PrintDoc (l_nCopyCount)
					uf_SaveCorrespondence (FALSE)
					
				END IF
				
			NEXT
		
			IF l_bPrintDoc THEN
				// close the window
				uf_CloseDocWindow ()
			ELSE
				i_wDocWindow.POST SetFocus ()
			END IF
			
			// if a batch was printed, inform the user if some of the documents did not print
			CHOOSE CASE l_nSkipCount
				CASE 1
					MessageBox (gs_appname, STRING (l_nSkipCount) + &
						' of the documents did not print because it was either blank or locked.')
					
				CASE IS > 1
					MessageBox (gs_appname, STRING (l_nSkipCount) + &
					' of the documents did not print because they were either blank or locked.')
			
			END CHOOSE
		END IF
		
	END IF
	
END IF
end subroutine

public subroutine uf_deletecorrespondence (string a_ccorrespondenceid);/*****************************************************************************************
   Function:   uf_deletecorrespondence
   Purpose:    Delete a correspondence entry from the database.
   Parameters: STRING	a_cCorrespondenceID - the ID of the correspondence to be deleted.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/05/02 M. Caruso    Created.
	02/11/02 M. Caruso    Removed reference to the correspondence_docs table.
	09/26/02 M. Caruso    Removed condition related to resetting autocommit. Now it always
								 resets.
*****************************************************************************************/

BOOLEAN	l_bFailed, l_bAutoCommit
STRING	l_cMsg

l_bAutoCommit = SQLCA.AutoCommit
SQLCA.AutoCommit = FALSE

// delete the correspondence record.
DELETE FROM cusfocus.correspondence
WHERE correspondence_id = :a_cCorrespondenceID;

IF SQLCA.SQLNRows > 0 AND SQLCA.SQLCode = 0 THEN
	l_bFailed = FALSE
ELSE
	l_cMsg = 'Unable to delete the correspondence entry.'
	l_bFailed = TRUE
END IF

IF l_bFailed THEN
	ROLLBACK;
	MessageBox (gs_appname, l_cMsg)
ELSE
	COMMIT;
END IF

SQLCA.AutoCommit = l_bAutoCommit


end subroutine

public subroutine uf_createcorrespondence (string a_ccasenumber, string a_ccasetype);/**************************************************************************************
	Function:	uf_createcorrespondence
	Purpose:		To initialize the new correspondence record in the Doc Info datastore.
	Parameters:	STRING	a_cCaseNumber - The ID of the current case.
					STRING	a_cCaseType - The type of the current case.
	Returns:		NONE

	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	07/16/01 M. Caruso     Created.
	01/30/02 M. Caruso     Updated to work with the modified manager functionality.
	02/04/02 M. Caruso     Added code to get the document name.
	02/06/02 M. Caruso     Corrected the code for gathering provider information.
	02/11/02 M. Caruso     Store doc image in the correspondence table.
	04/16/02 M. Caruso     Added owner prefix to the table name in the UPDATEBLOB stmt.
**************************************************************************************/

LONG		l_nRow, l_nProvKey
DATETIME	l_dtDate, l_dtNullDate
STRING	l_cAddress1, l_cAddress2, l_cCity, l_cState, l_cZip, l_cCountry
STRING	l_cFirstName, l_cLastName, l_cMI, l_cName, l_cKeyValue, l_cUserID
STRING	l_cDefaultSurvey, l_cDocName
BLOB		l_blbDocImage

l_nRow = i_dsDocumentInfo.InsertRow (0)

// get the survey ID
SELECT letter_id INTO :l_cDefaultSurvey FROM cusfocus.case_types
 WHERE case_type = :a_cCaseType;
 
SELECT letter_name INTO :l_cDocName FROM cusfocus.letter_types
 WHERE letter_id = :l_cDefaultSurvey;
 
SELECT source_type, case_subject_id INTO :i_cSourceType, :i_ccasesubjectid
  FROM cusfocus.case_log
 WHERE case_number = :a_cCaseNumber;

//---------------------------------------------------------------------------------------
//		Set the Provider Type and determine the Source in order to know where to get the
//		Address information.
//---------------------------------------------------------------------------------------

CHOOSE CASE i_cSourceType

	CASE i_cSourceConsumer
		SELECT consum_first_name, consum_last_name, consum_mi, consum_address_1, 
			consum_address_2, consum_city, consum_state, consum_zip, consum_country 
			INTO :l_cFirstName, :l_cLastName, :l_cMI, :l_cAddress1, :l_cAddress2,
			:l_cCity, :l_cState, :l_cZip, :l_cCountry 
		FROM cusfocus.consumer
		WHERE consumer_id = :i_ccasesubjectid;
		
		IF ISNull(l_cMI) THEN
			l_cMI = ''
		ELSE
			l_cMI = ' ' + l_cMI
		END IF
		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_salutation_name', &
											l_cFirstName + l_cMI + ' ' + l_cLastName)
		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_address_name', &
											l_cFirstName + l_cMI + ' ' + l_cLastName) 

	CASE i_cSourceEmployer
		SELECT employ_group_name, employ_address_1, employ_address_2, employ_city,
			employ_state, employ_zip, employ_country INTO :l_cName, :l_cAddress1,
			:l_cAddress2, :l_cCity, :l_cState, :l_cZip, :l_cCountry
		FROM cusfocus.employer_group
		WHERE group_id = :i_ccasesubjectid;

		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_salutation_name', l_cName)
		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_address_name', l_cName) 

	CASE i_cSourceProvider
		l_nProvKey = LONG (i_ccasesubjectid)
		SELECT provid_name, provid_name_2, provid_address_1, provid_address_2, provid_city,
			provid_state, provid_zip, provid_country INTO :l_cFirstName, :l_cLastName,
			:l_cAddress1, :l_cAddress2, :l_cCity, :l_cState, :l_cZip, :l_cCountry
		FROM cusfocus.provider_of_service 
		WHERE provider_key = :l_nProvKey;
		
		// determine how to set the provider name
		IF IsNull (l_cFirstName) THEN l_cFirstName = ''
		IF IsNull (l_cLastName) THEN l_cLastName = ''
		IF l_cFirstName = '' AND l_cLastName = '' THEN
			l_cName = ''
		ELSEIF l_cLastName = '' THEN
			l_cName = l_cFirstName
		ELSE
			l_cName = l_cLastName + ', ' + l_cFirstName
		END IF

		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_salutation_name', l_cName)
		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_address_name', l_cName) 
	
	CASE i_cSourceOther
		SELECT other_first_name, other_last_name, other_mi, other_address_1, 
			other_address_2, other_city, other_state, other_zip, other_country 
			INTO :l_cFirstName, :l_cLastName, :l_cMI, :l_cAddress1, 
			:l_cAddress2, :l_cCity, :l_cState, :l_cZip, :l_cCountry
		FROM cusfocus.other_source
		WHERE customer_id = :i_ccasesubjectid;

		IF ISNull(l_cMI) THEN
			l_cMI = ''
		ELSE
			l_cMI = ' ' + l_cMI
		END IF
		
		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_salutation_name', &
											l_cFirstName + l_cMI + ' ' + l_cLastName)
		i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_address_name', &
											l_cFirstName + l_cMI + ' ' + l_cLastName) 

END CHOOSE

//-------------------------------------------------------------------------------------
//		Initialize the new record with the appropriate address information, case number,
//		case type, create date and who created the record.
//--------------------------------------------------------------------------------------

IF IsValid (i_wDocWindow) THEN
	l_cKeyValue = i_wDocWindow.fw_getkeyvalue('correspondence')
	l_dtDate = i_wDocWindow.fw_gettimestamp ()
ELSEIF IsValid (w_create_maintain_case) THEN
	l_cKeyValue = w_create_maintain_case.fw_getkeyvalue('correspondence')
	l_dtDate = w_create_maintain_case.fw_gettimestamp ()
ELSEIF IsValid (w_batch_correspondence) THEN
	l_cKeyValue = w_batch_correspondence.fw_getkeyvalue('correspondence')
	l_dtDate = w_batch_correspondence.fw_gettimestamp ()
END IF
l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)
SetNull (l_dtNullDate)

i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_id', l_cKeyValue)
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_case_number', a_cCaseNumber)
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_case_type', a_cCaseType)
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_letter_id', l_cDefaultSurvey)
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_corspnd_create_date', l_dtDate)
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_corspnd_prnt_date', l_dtNullDate)
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_corspnd_prnt_flag', 'N')
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_hrd_cpy_filed', 'N')
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_desc', 'Survey printed when Case Closed')
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_response_rqrd', 'N')
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_corspnd_edit_type', 'S')
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_address_to_type', 'S')
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_type', 'S')
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_print_label_envelope', 'N')
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_created_by', l_cUserID)
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_address_1', l_cAddress1)
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_address_2', l_cAddress2)
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_city', l_cCity)
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_state', l_cState)
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_zip', l_cZip)
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_country', l_cCountry)
i_dsDocumentInfo.SetItem (l_nRow, 'corspnd_salutation', '')
i_dsDocumentInfo.SetItem (l_nRow, 'letter_tmplt_filename', '')
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_corspnd_sent', 'N')
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_corspnd_batch', 'N')
i_dsDocumentInfo.SetItem (l_nRow, 'correspondence_corspnd_doc_filled', 'N')

// save the new correspondence record.
i_dsDocumentInfo.Update ()

// add the document image to the correspondence record
uf_GetDocImage (TRUE, l_cDefaultSurvey, l_blbDocImage)
UPDATEBLOB cusfocus.correspondence SET corspnd_doc_image = :l_blbDocImage
WHERE correspondence_id = :l_cKeyValue;

// update the information for the current document
i_sCurrentDocInfo.a_cDocID = l_cKeyValue
i_sCurrentDocInfo.a_cDocName = l_cDocName
i_sCurrentDocInfo.a_blbDocImage = l_blbDocImage

end subroutine

public subroutine uf_filldocument ();/*****************************************************************************************
   Function:   uf_filldocument
   Purpose:    Populate the bookmarks in a document
   Parameters: STRING	a_cCaseType - Used to retrieve the proper case details.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/07/01 M. Caruso    Created.
	06/28/01 M. Caruso    Added code to access Case Details and Case Properties.
	04/05/02 M. Caruso    For General Information, added code to set l_cValue to '' if it
								 is NULL before applying value to the bookmark.  Also added calls
								 to uf_validatedocument to prevent crashing if the user switches
								 to another Word document during processing.
*****************************************************************************************/

BOOLEAN	l_bCSInfoValid, l_bXRefInfoValid, l_bIsXref, l_bAllFound = TRUE, lb_return
INTEGER	l_nBookmarkCount, l_nIndex, l_nLength, l_nBreakPos, l_nSuffixLength, li_return
LONG		l_nRow, l_nRowCount, l_nRow2, ll_story_type
STRING	l_cCaseSubjectID, l_cSourceType, l_cXrefID, l_cXrefType, l_cBookmarkName
STRING	l_cSourceID, l_cFieldName, l_cAddress1, l_cAddress2, l_cValue, l_cCaseType
DATASTORE	l_dsInfo
String ls_filename
Boolean lb_continue
LONG ll_bookmark_count, ll_bookmark_index, ll_bookmark_total

i_wDocWindow.SetRedraw(FALSE)


//i_wDocWindow.ole_wordocx.object.close() 
////i_wDocWindow.ole_worddoc.ConnectToNewObject("word.application")
////i_wDocWindow.ole_worddoc.Documents.open(i_wDocWindow.is_write_file_name)
//#IF defined PBDOTNET THEN
//	i_oleDocument = create oleobject
//	i_oleDocument.connecttonewobject( "word.application.8")
//	i_oleDocument.Documents.Open(i_wDocWindow.is_write_file_name)
//	lb_continue = TRUE
//#ELSE
//	i_wDocWindow.ole_wordocx.Object.ActiveDocumentData = i_sCurrentDocInfo.a_blbDocImage 
//	i_wDocWindow.ole_worddoc.Activate (InPlace!) 
//	IF IsValid (i_wDocWindow.ole_worddoc) THEN
		lb_continue = TRUE
//	END IF
//#END IF
//
IF lb_continue THEN
	
	// get the case subject and cross reference subject information
	uf_loadinfo ()
	
	l_bCSInfoValid = (i_dsDemographics.RowCount () > 0)
	l_bXrefInfoValid = (i_dsXrefDemographics.RowCount () > 0)
	
	l_cSourceType = i_dsCaseDetails.GetItemString (1, 'case_log_source_type')
	IF i_sCurrentDocInfo.a_cCaseType = 'P' THEN
		l_cXrefType = ''
	ELSE
		l_cXrefType = i_dsCaseDetails.GetItemString (1, 'case_log_xref_source_type')
	END IF
	
	// now loop through the bookmarks and populate the information
	l_nRowCount = i_dsLookup.RowCount ()
	uf_ValidateDocument ()
	#IF defined PBDOTNET THEN
		l_nBookmarkCount = i_oleDocument.ActiveDocument.Bookmarks.Count
	#ELSE
		l_nBookmarkCount = i_wDocWindow.ole_wordocx.Object.ActiveDocument.Bookmarks.Count
//		l_nBookmarkCount = i_wDocWindow.ole_wordocx.Object.ActiveDocument.Bookmarks.Count
	#END IF
		

	FOR l_nIndex = l_nBookmarkCount TO 1 STEP -1
	
		// populate the bookmark
		uf_ValidateDocument ()
		#IF defined PBDOTNET THEN
			l_cBookmarkName = i_oleDocument.ActiveDocument.Bookmarks(l_nIndex).Name
		#ELSE
			l_cBookmarkName = i_wDocWindow.ole_wordocx.Object.ActiveDocument.Bookmarks[l_nIndex].Name
//			l_cBookmarkName = i_wDocWindow.ole_wordocx.Object.ActiveDocument.Bookmarks[l_nIndex].Name
			// header footer test the story type
			// 1=main  
			// 6,7,9 are footers
			// 8,9,11 are headers
			ll_story_type = i_wDocWindow.ole_wordocx.Object.ActiveDocument.Bookmarks[l_nIndex].StoryType
//			ll_story_type = i_wDocWindow.ole_wordocx.Object.ActiveDocument.Bookmarks[l_nIndex].StoryType
		#END IF
		
		l_nBreakPos = Pos (l_cBookmarkName, '_')
		IF l_nBreakPos = 0 THEN
			
			IF Upper (Left (l_cBookmarkName, 4)) = 'XREF' THEN
				l_bIsXref = TRUE
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + Mid (l_cBookmarkName, 5) + '"', 1, l_nRowCount)
			ELSE
				l_bIsXref = FALSE
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + l_cBookmarkName + '"', 1, l_nRowCount)
			END IF
			
		ELSE
			
			l_nSuffixLength = (len (l_cBookmarkName) - l_nBreakPos) + 1
			IF Upper (Left (l_cBookmarkName, 4)) = 'XREF' THEN
				l_bIsXref = TRUE
				l_nLength = Len (l_cBookmarkName) - (l_nSuffixLength + 4)
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + Mid (l_cBookmarkName, 5, l_nLength) + '"', 1, l_nRowCount)
			ELSE
				l_bIsXref = FALSE
				l_nLength = Len (l_cBookmarkName) - (l_nSuffixLength)
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + Left (l_cBookmarkName, l_nLength) + '"', 1, l_nRowCount)
			END IF
			
		END IF
		
		IF l_nRow > 0 THEN
			
			l_cValue = ''
			l_cSourceID = i_dsLookup.GetItemString (l_nRow, 'source_id')
			l_cFieldName = i_dsLookup.GetItemString (l_nRow, 'field_name')
			// translate Source ID to Source Type when necessary
			uf_ValidateDocument ()
			#IF defined PBDOTNET THEN
				i_oleDocument.selection.GoTo (TRUE, 0, 0, l_cBookmarkName)
			#ELSE
				// Testing for header and footer bookmarks
				IF ll_story_type = 1 THEN
					i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.GoTo (TRUE, 0, 0, l_cBookmarkName)
				ELSE
					CHOOSE CASE ll_story_type
						CASE 7 // Bookmark in primary header
							i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 1 // seek primary header
						CASE 9 // Bookmark in primary footer
							i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 4 // seek primary footer
						CASE 6 // Bookmark in even page header
							i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 3 // seek even page header
						CASE 8 // Bookmark in even page footer
							i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 6 // seek even page footer
						CASE 10 // Bookmark in first page header
							i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 2 // seek first page header
						CASE 11 // Bookmark in first page footer
							i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 5 // seek first page footer
					END CHOOSE
							
					IF i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks.Exists(l_cBookmarkName) THEN
						// Find which header bookmark matches the one we are looking for
						ll_bookmark_total = i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks.Count
						ll_bookmark_index = -1
						FOR ll_bookmark_count = 1 TO ll_bookmark_total
							IF i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks[ll_bookmark_count].name = l_cBookmarkName THEN
								ll_bookmark_index = ll_bookmark_count
								EXIT
							END IF
						NEXT
						IF ll_bookmark_index > 0 THEN
							// found the bookmark, select it
							i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges.Item[ll_story_type].Bookmarks[ll_bookmark_index].Select()
						END IF
					END IF
				END IF
			#END IF
			CHOOSE CASE	l_cSourceID
				CASE 'General Information'
					IF l_cBookmarkName = 'SIG' THEN
						of_load_signature()
					ELSE
						
						CHOOSE CASE l_cFieldName
							CASE 'computed_currentdate'
								l_cValue = STRING (Today(), 'mmmm dd, yyyy')
								uf_ValidateDocument ()
								#IF defined PBDOTNET THEN
									i_oleDocument.selection.TypeText (l_cValue)
								#ELSE
									i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
								#END IF
								
							CASE 'computed_repname'
								l_cValue = SECCA.MGR.i_UsrName
								IF IsNull (l_cValue) THEN l_cValue = ''
								uf_ValidateDocument ()
								#IF defined PBDOTNET THEN
									i_oleDocument.selection.TypeText (l_cValue)
								#ELSE
									i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
								#END IF
								
							CASE 'corspnd_salutation'
								l_cValue = i_dsDocumentInfo.GetItemString (1, l_cFieldName)
								IF Trim (l_cValue) = '' OR l_cValue = '(None)' OR IsNull (l_cValue) THEN
									l_cValue = ''
								END IF
								IF IsNull (l_cValue) THEN l_cValue = ''
								uf_ValidateDocument ()
								#IF defined PBDOTNET THEN
									i_oleDocument.selection.TypeText (l_cValue)
								#ELSE
									i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
								#END IF
								
							CASE 'corspnd_salutation_name'
								l_cValue = i_dsDocumentInfo.GetItemString (1, l_cFieldName)
								IF IsNull (l_cValue) THEN l_cValue = ''
								uf_ValidateDocument ()
								#IF defined PBDOTNET THEN
									i_oleDocument.selection.TypeText (l_cValue)
								#ELSE
									i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
								#END IF
								
							CASE ELSE
								uf_FillField (i_dsCSR, l_cFieldName)
							
						END CHOOSE
					END IF
					
				CASE 'Mailing Information'
					CHOOSE CASE l_cFieldName
						CASE 'computed_address'
							l_cAddress1 = i_dsDocumentInfo.GetItemString (1, 'corspnd_address_1')
							l_cAddress2 = i_dsDocumentInfo.GetItemString (1, 'corspnd_address_2')
							IF l_cAddress2 = '' OR IsNull (l_cAddress2) THEN
								l_cValue = l_cAddress1
							ELSE
								l_cValue = l_cAddress1 + CHAR (13) + l_cAddress2
							END IF
							
						CASE 'corspnd_zip'
							l_cValue = i_dsDocumentInfo.GetItemString (1, l_cFieldName)
							 IF LEN(l_cValue) = 9 THEN
								l_cValue = MID(l_cValue, 1, 5) + "-" + MID(l_cValue, 6, 4)
							END IF
							
						CASE ELSE
							l_cValue = i_dsDocumentInfo.GetItemString (1, l_cFieldName)
					END CHOOSE
					IF IsNull (l_cValue) THEN l_cValue = ''
					uf_ValidateDocument ()
					#IF defined PBDOTNET THEN
						i_oleDocument.selection.TypeText (l_cValue)
					#ELSE
						i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
					#END IF
					
				CASE 'Employer Groups'
					IF l_bIsXref THEN
						IF l_bXrefInfoValid AND l_cXrefType = i_cSourceEmployer THEN
							uf_FillField (i_dsXrefDemographics, l_cFieldName)
						END IF
					ELSE
						IF l_bCSInfoValid AND l_cSourceType = i_cSourceEmployer THEN
							uf_FillField (i_dsDemographics, l_cFieldName)
						END IF
					END IF
					
				CASE 'Members'
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Begin Code for BCBSVT custom bookmark Lookup
					//-----------------------------------------------------------------------------------------------------------------------------------


					Datastore	lds_bcbsvt
					string 		ls_find, ls_optionvalue, ls_value, ls_companyfield, ls_USIDcolumn, ls_company_string
					string		ls_companyID, ls_company_blank
					long			ll_row, ll_rowcount
					
					lds_bcbsvt = Create datastore
					
					lds_bcbsvt.DataObject = 'd_bcbsvt_setup'
					lds_bcbsvt.SetTransObject(SQLCA)
					ll_rowcount = lds_bcbsvt.Retrieve()

					ll_row = lds_bcbsvt.Find('optionname="BCBSVTCustomOn"', 1, ll_rowcount)
					
					If ll_row > 0 Then
						ls_optionvalue = lower(lds_bcbsvt.GetItemString(ll_row, 'optionvalue'))
					End If
					

					//-----------------------------------------------------------------------------------------------------------------------------------
					// Check the system setting to see if they are using the custom USID Bookmark
					//-----------------------------------------------------------------------------------------------------------------------------------

					If ls_optionvalue = 'y' And l_cFieldName = 'consumer_consumer_id' Then
						ll_row  			= 	lds_bcbsvt.Find(' optionname = "USIDColumn"', 1, lds_bcbsvt.RowCount())
						ls_USIDcolumn 	=	lds_bcbsvt.GetItemString(ll_row, 'optionvalue')
						
						ll_row				=	lds_bcbsvt.Find(' optionname = "CompanyField"', 1, lds_bcbsvt.RowCount())
						ls_companyfield	=	lds_bcbsvt.GetItemString(ll_row, 'optionvalue')
						
						ll_row				=	lds_bcbsvt.Find(' optionname = "USIDCompanies"', 1, lds_bcbsvt.RowCount())
						ls_company_string	=	',' + lds_bcbsvt.GetItemString(ll_row, 'optionvalue') + ','
						
//							ll_row				=	lds_bcbsvt.Find(' optionname = "USIDBlankCompanies"', 1, lds_bcbsvt.RowCount())
//							ls_company_blank	=	lds_bcbsvt.GetItemString(ll_row, 'optionvalue')
						
						
						IF l_bIsXref THEN
							IF l_bXrefInfoValid AND l_cXrefType = i_cSourceConsumer THEN
								//-----------------------------------------------------------------------------------------------------------------------------------
								// If the USID is null or '' then check the company field. If it is 01, 06, 09, 21 or 22 then print a blank space
								//-----------------------------------------------------------------------------------------------------------------------------------
								ls_companyID = i_dsXrefDemographics.GetItemString(1, ls_companyfield)
								
								If Pos(ls_company_string, ',' + ls_companyID + ',') > 0 Then
									uf_FillField (i_dsXrefDemographics, ls_USIDcolumn, TRUE)
								Else
									uf_FillField (i_dsXrefDemographics, l_cFieldName)
								End If
							END IF
						ELSE
							IF l_bCSInfoValid AND l_cSourceType = i_cSourceConsumer THEN
								//-----------------------------------------------------------------------------------------------------------------------------------
								// If the USID is null or '' then check the company field. If it is 01, 06, 09, 21 or 22 then print a blank space
								//-----------------------------------------------------------------------------------------------------------------------------------
								ls_companyID = i_dsDemographics.GetItemString(1, ls_companyfield)

								If Pos(ls_company_string, ',' + ls_companyID + ',') > 0 Then
									uf_FillField (i_dsDemographics, ls_USIDcolumn, TRUE)
								Else
									uf_FillField (i_dsDemographics, l_cFieldName)
								End If
							END IF
						END IF
					Else
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Do the normal stuff
					//-----------------------------------------------------------------------------------------------------------------------------------
						IF l_bIsXref THEN
							IF l_bXrefInfoValid AND l_cXrefType = i_cSourceConsumer THEN
								uf_FillField (i_dsXrefDemographics, l_cFieldName)
							END IF
						ELSE
							IF l_bCSInfoValid AND l_cSourceType = i_cSourceConsumer THEN
								uf_FillField (i_dsDemographics, l_cFieldName)
							END IF
						END IF
					End If
				
					//-----------------------------------------------------------------------------------------------------------------------------------
					// End Code for BCBSVT custom bookmark Lookup
					//-----------------------------------------------------------------------------------------------------------------------------------

					
				CASE 'Other Sources'
					IF l_bIsXref THEN
						IF l_bXrefInfoValid THEN
							uf_FillField (i_dsXrefDemographics, l_cFieldName)
						END IF
					ELSE
						IF l_bCSInfoValid THEN
							uf_FillField (i_dsDemographics, l_cFieldName)
						END IF
					END IF
					
				CASE 'Providers'
					IF l_bIsXref THEN
						IF l_bXrefInfoValid AND l_cXrefType = i_cSourceProvider THEN
							uf_FillField (i_dsXrefDemographics, l_cFieldName)
						END IF
					ELSE
						IF l_bCSInfoValid AND l_cSourceType = i_cSourceProvider THEN
							uf_FillField (i_dsDemographics, l_cFieldName)
						END IF
					END IF
					
				CASE 'Case Details'
					uf_FillField (i_dsCaseDetails, l_cFieldName)
					
				CASE 'Case Notes'
					of_load_case_notes (l_cFieldName)
					
				CASE 'Case Properties'
					uf_FillField (i_dsCaseProperties, l_cFieldName)
					
				CASE 'Appeal'
					IF l_cFieldName = 'lob_logo_blbobjctid'  THEN
						of_load_lob_logo()
					ELSE
						uf_FillField (i_dsAppeal, l_cFieldName)
					END IF
					
			END CHOOSE
			
		ELSE
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Catch the appeal events and appeal event property bookmarks that don't fit the "normal" bookmark checks
			//-----------------------------------------------------------------------------------------------------------------------------------

			
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Check to see if this bookmark is an appeal property
			//-----------------------------------------------------------------------------------------------------------------------------------

			Datastore 	lds_appealprops, lds_appealevents
			long			ll_find_row
			long			ll_source_type
			string			ls_format_id
			string		ls_column
			string 	ls_display_format
			long			ll_case_number
			boolean		lb_found = FALSE
			date	ldt_date
			time lt_time

			lds_appealprops = Create datastore
			lds_appealprops.DataObject = 'd_tm_appeal_prop_field_defs'
			lds_appealprops.SetTransObject(SQLCA)
			
			lds_appealprops.Retrieve()
			
			l_nBreakPos = Pos (l_cBookmarkName, '_')
			IF l_nBreakPos = 0 THEN
				ll_find_row = lds_appealprops.Find('bookmark_name="' + l_cBookmarkName + '"', 1, lds_appealprops.RowCount())
				
			ELSE
				
				l_nSuffixLength = (len (l_cBookmarkName) - l_nBreakPos) + 1
				l_nLength = Len (l_cBookmarkName) - (l_nSuffixLength)
				ll_find_row = lds_appealprops.Find('bookmark_name="' + Left (l_cBookmarkName, l_nLength) + '"', 1, lds_appealprops.RowCount())
				
			END IF
			
			If ll_find_row > 0 Then
				ll_source_type =	lds_appealprops.GetItemNumber(ll_find_row, 'source_type')
				ls_column		=	lds_appealprops.GetItemString(ll_find_row, 'column_name')
				ls_value = of_get_appeal_prop_value(long(i_sCurrentDocInfo.a_cCaseNumber), ll_source_type, ls_column)
				// See if there is a display format for this property
				ls_format_id 	= lds_appealprops.GetItemString(ll_find_row, 'format_id')
				IF NOT IsNull(ls_format_id) THEN
					SELECT IsNull(display_format, 'XXX')
					INTO :ls_display_format
					FROM cusfocus.display_formats
					WHERE format_id = :ls_format_id
					USING SQLCA;
					
					IF SQLCA.SQLCode = 0 AND ls_display_format <> 'XXX' THEN
						CHOOSE CASE ls_display_format
							CASE '@@/@@/@@@@ @@:@@'
								ldt_date = date(mid(ls_value,1,2) + '/' + mid(ls_value,3,2) + '/' + mid(ls_value,5,4))
								lt_time = time(mid(ls_value,9,2) + ':' + mid(ls_value,11,2))
								ls_value = String(datetime(ldt_date, lt_time), 'mm/dd/yyyy hh:mm AM/PM')
							CASE '@@/@@/@@@@ @@:@@:@@'
								ldt_date = date(mid(ls_value,1,2) + '/' + mid(ls_value,3,2) + '/' + mid(ls_value,5,4))
								lt_time = time(mid(ls_value,9,2) + ':' + mid(ls_value,11,2) + ':' + mid(ls_value,13,2))
								ls_value = String(datetime(ldt_date, lt_time), 'mm/dd/yyyy hh:mm:ss AM/PM')
							CASE '@@:@@'
								lt_time = time(mid(ls_value,1,2) + ':' + mid(ls_value,3,2))
								ls_value = String(lt_time, 'hh:mm AM/PM')
							CASE '@@:@@:@@'
								lt_time = time(mid(ls_value,1,2) + ':' + mid(ls_value,3,2) + ':' + mid(ls_value,5,2))
								ls_value = String(lt_time, 'hh:mm:ss AM/PM')
							CASE ELSE
								ls_value = RightTrim(String(ls_value, ls_display_format))
						END CHOOSE
					END IF
				END IF

				lb_found = TRUE
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------

			// Check to see if this bookmark is an appeal event
			//-----------------------------------------------------------------------------------------------------------------------------------

			If lb_found <> TRUE Then
				lds_appealevents = Create datastore
				lds_appealevents.DataObject = 'd_tm_appeal_event'
				lds_appealevents.SetTransObject(SQLCA)
				
				lds_appealevents.Retrieve()
				
				ll_find_row = lds_appealevents.Find('bookmark_name="' + l_cBookmarkName + '"', 1, lds_appealevents.RowCount())
			
				If ll_find_row > 0 Then
					ls_value		=	lds_appealevents.GetItemString(ll_find_row, 'eventname')
					lb_found 	= 	TRUE
				End If
			End If

			If lb_found = TRUE Then 
				IF IsNull (ls_value) THEN ls_value = ''
				uf_ValidateDocument ()
				#IF defined PBDOTNET THEN
					i_oleDocument.selection.GoTo (TRUE, 0, 0, l_cBookmarkName)
					i_oleDocument.selection.TypeText (ls_Value)
				#ELSE
					// Testing for header and footer bookmarks
					IF ll_story_type = 1 THEN
						i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.GoTo (TRUE, 0, 0, l_cBookmarkName)
					ELSEIF ll_story_type = 7 THEN // Bookmark in header
						i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 1 // seek primary header
						IF i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks.Exists(l_cBookmarkName) THEN
							// Find which header bookmark matches the one we are looking for
							ll_bookmark_total = i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks.Count
							ll_bookmark_index = -1
							FOR ll_bookmark_count = 1 TO ll_bookmark_total
								IF i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks[ll_bookmark_count].name = l_cBookmarkName THEN
									ll_bookmark_index = ll_bookmark_count
									EXIT
								END IF
							NEXT
							IF ll_bookmark_index > 0 THEN
								// found the bookmark, select it
								i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges.Item[ll_story_type].Bookmarks[ll_bookmark_index].Select()
							END IF
						END IF
					ELSEIF ll_story_type = 9 THEN // Bookmark in footer
						i_wDocWindow.ole_wordocx.Object.ActiveDocument.ActiveWindow.ActivePane.View.SeekView = 4 // seek primary footer
						IF i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks.Exists(l_cBookmarkName) THEN
							// Find which footer bookmark matches the one we are looking for
							ll_bookmark_total = i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks.Count
							ll_bookmark_index = -1
							FOR ll_bookmark_count = 1 TO ll_bookmark_total
								IF i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges[ll_story_type].Bookmarks[ll_bookmark_count].name = l_cBookmarkName THEN
									ll_bookmark_index = ll_bookmark_count
									EXIT
								END IF
							NEXT
							IF ll_bookmark_index > 0 THEN
								// found the bookmark, select it
								i_wDocWindow.ole_wordocx.Object.ActiveDocument.StoryRanges.Item[ll_story_type].Bookmarks[ll_bookmark_index].Select()
							END IF
						END IF
					END IF
					i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (ls_Value)
				#END IF
			End If

			If lb_found = FALSE Then
				l_bAllFound = FALSE
			End If		
			
		END IF
		
	NEXT
	
	// Set document as changed, since it is new.
	i_bDocFilled = TRUE
	i_wDocWindow.i_bDocModified = TRUE
	
	i_cDocName = ''
END IF

//i_wDocWindow.ole_worddoc.ActiveDocument.save
//li_return = ole_worddoc.DisConnectObject()
//i_wDocWindow.ole_worddoc.ActiveDocument.close

#IF defined PBDOTNET THEN
	i_oleDocument.Documents.Save()
	i_oleDocument.Documents.Close()
	i_oleDocument.Documents.Application.Quit()
	li_return = i_oleDocument.disconnectobject( )
	DESTROY i_oleDocument
#ELSE
//???	i_wDocWindow.ole_worddoc.saveas(i_wDocWindow.is_write_file_name) 
//???	i_wDocWindow.ole_worddoc.Clear() 
//???	i_wDocWindow.ole_worddoc.Hide() 
#END IF
//i_wDocWindow.of_word_ocx()
//???lb_return = i_wDocWindow.ole_wordocx.Object.Open(i_wDocWindow.is_write_file_name) 
//??IF lb_return THEN 
//??	i_wDocWindow.ole_wordocx.Object.Toolbars = TRUE
//	i_wDocWindow.ole_wordocx.Object.ShowToolbars(TRUE)
//??ELSE
//??	MessageBox( gs_AppName, "Could not open the correspondence for editing", StopSign!, OK! )
//??END IF
i_wDocWindow.SetRedraw(TRUE)

// For Geisinger, they can't cut and paste until the doc is saved, so force a save here.
//???i_wDocWindow.fw_SaveDoc (i_wDocWindow.c_SaveDoc)

//??i_wDocWindow.ole_worddoc.Documents.save(i_wDocWindow.is_write_file_name)
//??i_wDocWindow.ole_worddoc.Documents.close()
//??i_wDocWindow.of_word_ocx()

Destroy lds_appealprops
Destroy lds_appealevents

end subroutine

public subroutine uf_loaddocinfo ();/*****************************************************************************************
   Function:   uf_loaddocinfo
   Purpose:    Initialize the Document Information datastore.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/24/02 M. Caruso    Created.
*****************************************************************************************/

i_dsdocumentinfo.DataObject = 'd_correspondence_detail'
i_dsdocumentinfo.SetTransObject (SQLCA)
IF i_sCurrentDocInfo.a_cDocId = '' THEN
	uf_CreateCorrespondence (i_sCurrentDocInfo.a_cCaseNumber, i_sCurrentDocInfo.a_cCaseType)
ELSE
	i_dsdocumentinfo.Retrieve (i_sCurrentDocInfo.a_cDocId)
END IF


end subroutine

public function integer uf_opendocwindow (boolean a_bvisible);/*****************************************************************************************
   Function:   uf_OpenDocWindow
   Purpose:    Open the window for processing correspondence.
   Parameters: BOOLEAN	a_bVisible - should the window be initially visible.
   Returns:    INTEGER	0 - success
							  -1 - failed

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/08/02 M. Caruso    Created.
	01/28/02 M. Caruso    Added code to reuse an existing instance of the window.
*****************************************************************************************/

INTEGER	l_nStatus

IF a_bVisible THEN
	i_bDisplayWindow = TRUE
ELSE
	i_bDisplayWindow = FALSE
END IF

//RAP commented out so that only one document can be opened at one time
//RAP SetNull (i_wDocWindow)

IF IsNull (i_wDocWindow) THEN
	
	// open the window, passing a reference to this Doc Mgr.
	i_wDocWindow = w_word_window
	RETURN FWCA.MGR.fu_OpenWindow (i_wDocWindow, THIS)
	
ELSE

	// the window is already open, so bring it to the foreground and reuse it.
	i_wDocWindow.BringToTop = TRUE
	i_wDocWindow.WindowState = Normal!
	RETURN 0
	
END IF
end function

public subroutine uf_applyfieldformats (string a_csourcetype, string a_ccasetype, string a_cfieldtype);/*****************************************************************************************
   Function:   uf_ApplyFieldFormats
   Purpose:    Apply field formats for configurable fields in the demographics datastore.
   Parameters: STRING	a_cSourceType - used to retrieve the appropriate field formats
													 from the database.
					STRING	a_cCaseType   - used to retrieve the appropriate field formats
													 from the database.
					STRING	a_cFieldType  - determine if loading demographics or case
													 properties.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/24/02 M. Caruso    Created.
*****************************************************************************************/

INTEGER		l_nRtn
LONG			l_nRowCount, l_nIndex
STRING		l_cSQLSelect, l_cDSSyntax, l_cErrors, l_cTablePrefix
STRING		l_cFieldName, l_cEditMask, l_cDisplayFormat
DATASTORE	l_dsFieldList

// build the select statement to use
CHOOSE CASE a_cFieldType
	CASE 'demographics'
		l_cSQLSelect = 'SELECT column_name, display_format ' + &
							'FROM cusfocus.field_definitions, cusfocus.display_formats ' + &
							'WHERE cusfocus.display_formats.format_id = cusfocus.field_definitions.format_id ' + &
							'AND cusfocus.field_definitions.source_type = ~'' + a_cSourceType + '~''
		// this is required because of how the datawindows are defined
		CHOOSE CASE a_cSourceType
			CASE 'C'
				l_cTablePrefix = 'consumer_'
				
			CASE 'P'
				l_cTablePrefix = 'provider_of_service_'
				
			CASE 'E'
				l_cTablePrefix = ''
				
			CASE 'O'
				l_cTablePrefix = 'other_source_'
				
		END CHOOSE
							
	CASE 'case properties'
		l_cSQLSelect = 'SELECT column_name, display_format ' + &
							'FROM cusfocus.case_properties_field_def, cusfocus.display_formats ' + &
							'WHERE cusfocus.display_formats.format_id = cusfocus.case_properties_field_def.format_id ' + &
							'AND cusfocus.case_properties_field_def.source_type = ~'' + a_cSourceType + '~' ' + &
							'AND cusfocus.case_properties_field_def.case_type = ~'' + a_cCaseType + '~''
		l_cTablePrefix = ''
							
END CHOOSE

// convert the SQL to datastore syntax
l_cDSSyntax = SQLCA.SyntaxFromSQL (l_cSQLSelect, '', l_cErrors)
IF l_cErrors = '' THEN
	
	// build the datastore to retrieve field format information
	l_dsFieldList = CREATE DATASTORE
	l_dsFieldList.Create (l_cDSSyntax, l_cErrors)
	IF l_cErrors = '' THEN
		
		// retrieve the corresponding field info and apply to the demographics datastore
		l_dsFieldList.SetTransObject (SQLCA)
		l_nRowCount = l_dsFieldList.Retrieve ()
		FOR l_nIndex = 1 TO l_nRowCount
			
			l_cFieldName = l_cTablePrefix + l_dsFieldList.GetItemString (l_nIndex, 1)  // column_name
			l_cDisplayFormat = l_dsFieldList.GetItemString (l_nIndex, 2)  // display_format
			
			CHOOSE CASE a_cFieldType
				CASE 'demographics'
					l_nRtn = i_dsDemographics.SetFormat (l_cFieldName, l_cDisplayFormat)
					
				CASE 'case properties'
					l_nRtn = i_dsCaseProperties.SetFormat (l_cFieldName, l_cDisplayFormat)
					
			END CHOOSE
			
		NEXT
		
	END IF
	
END IF
end subroutine

public function integer uf_loadinfo ();/*****************************************************************************************
   Function:   uf_loadinfo
   Purpose:    Initialize the case subject and cross reference datastores
   Parameters: NONE
   Returns:    INTEGER	 0 - Success
								-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/04/01 M. Caruso    Created.
	07/05/01 M. Caruso    Added code to load case details, case properties and doc info
								 datastores as well.
	08/07/01 M. Caruso    Set the i_cCaseType instance variable and account for proactive
								 case types by not loading xref info.
	01/24/02 M. Caruso    Moved the code to load the document information to its own
								 function.
	04/24/02 M. Caruso    Corrected to retrieve only one record for case properties.
*****************************************************************************************/

BOOLEAN	l_bConvert, l_bXrefConvert
STRING	l_cDataObject, l_cXrefDataObject, l_cSubjectID, l_cXrefSubjectID, l_cSourceType
long		ll_return
string ls_current_user

// load the case notes
i_dsCaseNotes.DataObject = 'd_case_notes'
i_dsCaseNotes.SetTransObject(SQLCA)
i_dsCaseNotes.Retrieve(i_sCurrentDocInfo.a_cCaseNumber, 1)

// load info for the current CSR
ls_current_user = gn_globals.is_login
i_dsCSR.DataObject = 'd_edit_my_info'
i_dsCSR.SetTransObject(SQLCA)
i_dsCSR.Retrieve(ls_current_user)

// load the case details information
CHOOSE CASE i_sCurrentDocInfo.a_cCaseType
	CASE 'P'
		i_dscasedetails.DataObject = 'd_case_details_proactive'
		
	CASE ELSE
		i_dscasedetails.DataObject = 'd_case_details'
		
END CHOOSE
i_dscasedetails.SetTransObject (SQLCA)
IF i_dscasedetails.Retrieve (i_sCurrentDocInfo.a_cCaseNumber) > 0 THEN
	i_cCaseSubjectID = i_dsCaseDetails.GetItemString (1, 'case_log_case_subject_id')
	i_cSourceType = i_dsCaseDetails.GetItemString (1, 'case_log_source_type')
END IF

l_cSourceType = i_dscasedetails.GetItemString (1, 'case_log_source_type')

// load the case properties information
i_dscaseproperties.DataObject = 'd_correspondence_case_props'
i_dscaseproperties.SetTransObject (SQLCA)
uf_ApplyFieldFormats (l_cSourceType, i_sCurrentDocInfo.a_cCaseType, 'case properties')
i_dscaseproperties.Retrieve (i_sCurrentDocInfo.a_cCaseNumber, &
									  i_sCurrentDocInfo.a_cCaseType, &
									  l_cSourceType)
									  
//-----------------------------------------------------------------------------------------------------------------------------------

// Begin Added JWhite 11.21.05
//-----------------------------------------------------------------------------------------------------------------------------------

i_dsAppeal.DataObject = 'd_correspondence_appeal'
i_dsAppeal.SetTransObject (SQLCA)
//uf_ApplyFieldFormats (l_cSourceType, i_sCurrentDocInfo.a_cCaseType, 'case properties')
ll_return = i_dsAppeal.Retrieve (long(i_sCurrentDocInfo.a_cCaseNumber))

//-----------------------------------------------------------------------------------------------------------------------------------

// End JWhite 11.21.05
//-----------------------------------------------------------------------------------------------------------------------------------



// Choose the dataobject for the case subject demographics
CHOOSE CASE l_cSourceType
	CASE 'C'
		l_cDataObject = 'd_correspondence_memdem'
		l_bConvert = FALSE
		
	CASE 'E'
		l_cDataObject = 'd_correspondence_grpdem'
		l_bConvert = FALSE
		
	CASE 'P'
		l_cDataObject = 'd_correspondence_prvdem'
		l_bConvert = TRUE
		
	CASE 'O'
		l_cDataObject = 'd_correspondence_otherdem'
		l_bConvert = FALSE
		
END CHOOSE

// Choose the dataobject for the cross-reference demographics
IF i_sCurrentDocInfo.a_cCaseType = 'P' THEN
	
	// use member demogrpahics as default for proactive cases
	l_cXrefDataObject = 'd_correspondence_memdem'
	l_bXrefConvert = FALSE
	
ELSE
	
	CHOOSE CASE i_dscasedetails.GetItemString (1, 'case_log_xref_source_type')
		CASE 'C'
			l_cXrefDataObject = 'd_correspondence_memdem'
			l_bXrefConvert = FALSE
			
		CASE 'E'
			l_cXrefDataObject = 'd_correspondence_grpdem'
			l_bXrefConvert = FALSE
			
		CASE 'P'
			l_cXrefDataObject = 'd_correspondence_prvdem'
			l_bXrefConvert = TRUE
			
		CASE 'O'
			l_cDataObject = 'd_correspondence_otherdem'
			l_bXrefConvert = FALSE
			
	END CHOOSE
	
END IF

// load the case subject demographics - i_dsDemographics
l_cSubjectID = i_dscasedetails.GetItemString (1, 'case_log_case_subject_id')
i_dsDemographics.DataObject = l_cDataObject
i_dsDemographics.SetTransObject (SQLCA)
uf_ApplyFieldFormats (l_cSourceType, i_sCurrentDocInfo.a_cCaseType, 'demographics')
IF l_bConvert THEN
	i_dsDemographics.Retrieve (LONG (l_cSubjectID))
ELSE
	i_dsDemographics.Retrieve (l_cSubjectID)
END IF

// load the Cross-Reference demographics - i_dsXrefDemographics
IF i_sCurrentDocInfo.a_cCaseType = 'P' THEN
	l_cXrefSubjectID = ''
ELSE
	l_cXrefSubjectID = i_dscasedetails.GetItemString (1, 'case_log_xref_subject_id')
END IF
i_dsXrefDemographics.DataObject = l_cXrefDataObject
i_dsXrefDemographics.SetTransObject (SQLCA)
IF l_bXrefConvert THEN
	i_dsXrefDemographics.Retrieve (LONG (l_cXrefSubjectID))
ELSE
	i_dsXrefDemographics.Retrieve (l_cXrefSubjectID)
END IF

RETURN 0
end function

public function integer uf_opendoc ();/*****************************************************************************************
   Function:   uf_OpenDoc
   Purpose:    Open the document for editing or printing
   Parameters: NONE
   Returns:    INTEGER -  0: success
	                      -1: failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/08/02 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nRtn

//i_wDocWindow.ole_worddoc.SetRedraw (FALSE)

l_nRtn = i_wDocWindow.fw_OpenDoc (i_sCurrentDocInfo)
// In order to get the sizes right
//???i_sCurrentDocInfo.a_lCharacter_count = i_wDocWindow.ole_worddoc.Object.Characters.Count

//i_wDocWindow.ole_worddoc.SetRedraw (TRUE)

RETURN l_nRtn
end function

public subroutine uf_printdoc (integer a_ncopycount);/*****************************************************************************************
   Function:   uf_PrintDoc
   Purpose:    Open the document for editing or printing
   Parameters: INTEGER	a_nCopyCount - the number of copies to print
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/08/02 M. Caruso    Created.
	02/08/02 M. Caruso    Added code to process Response Required.
	02/12/02 M. Caruso    Do not refresh source datawindow if in Batch Mode.
	03/06/02 M. Caruso    Do not set a default value for date entered when created a survey
								 result record.
	05/17/02 M. Caruso    Added a_nCopyCount parameter and pass it on to fw_PrintDoc ().
*****************************************************************************************/

BOOLEAN	l_bUpdated, l_bCreateSurveyRecord
STRING	l_cSurveyID, l_cLetterID, l_cUserLogin, l_cSourceID
DATETIME	l_dtTimeStamp
U_DW_STD	l_dwParentDW
string	ls_edit_sent_corrspndnce

l_bUpdated = FALSE

i_wDocWindow.fw_PrintDoc (a_nCopyCount)

IF LEFT(i_sCurrentDocInfo.a_cDocID, 9) = "History: " THEN // just printing an old copy
	RETURN
END IF
IF IsValid (i_wDocWindow) THEN
	l_dtTimeStamp = i_wDocWindow.fw_GetTimeStamp ()
ELSEIF IsValid (w_create_maintain_case) THEN
	l_dtTimeStamp = w_create_maintain_case.fw_GetTimeStamp ()
ELSEIF IsValid (w_batch_correspondence) THEN
	l_dtTimeStamp = w_batch_correspondence.fw_GetTimeStamp ()
END IF

// if the document was printed, update the printed timestamp
IF i_wDocWindow.i_bDocPrinted THEN
	i_dsDocumentInfo.SetItem (1, 'correspondence_corspnd_prnt_date', l_dtTimeStamp)
	i_dsDocumentInfo.SetItem (1, 'correspondence_corspnd_prnt_flag', 'Y')
	i_wDocWindow.i_bDocPrinted = FALSE
	l_bUpdated = TRUE
	
END IF

// if the document was sent, update the sent timestamp
IF i_wDocWindow.i_bDocSent THEN
	i_dsDocumentInfo.SetItem (1, 'correspondence_corspnd_sent', l_dtTimeStamp)
	IF i_dsDocumentInfo.GetItemString (1, 'corspnd_type') = 'S' THEN
			l_bCreateSurveyRecord = TRUE
			i_wDocWindow.i_bAllowSave = FALSE
	ELSE
		l_bCreateSurveyRecord = FALSE
		i_wDocWindow.i_bAllowSave = TRUE
	END IF
	l_bUpdated = TRUE
END IF

// if either change was made, save it.
IF l_bUpdated THEN
	i_dsDocumentInfo.Update ()
	IF NOT i_bBatchMode THEN
		uf_RefreshList ()
	END IF
	
	// create a reminder if Response Required.
	IF i_dsDocumentInfo.GetItemString (1, 'corspnd_response_rqrd') = 'Y' THEN
		IF i_wDocWindow.i_bDocSent THEN
			uf_ProcessResponseRqrd ()
		END IF
	END IF
	
	// create a Survey Result record if required
	IF l_bCreateSurveyRecord THEN
		
		// insert a blank record in the survey results table for surveys
		IF IsValid (i_wDocWindow) THEN
			l_cSurveyID = i_wDocWindow.fw_GetKeyValue ('survey_results')
		ELSEIF IsValid (w_create_maintain_case) THEN
			l_cSurveyID = w_create_maintain_case.fw_GetKeyValue ('survey_results')
		ELSEIF IsValid (w_batch_correspondence) THEN
			l_cSurveyID = w_batch_correspondence.fw_GetKeyValue ('survey_results')
		END IF
		l_cLetterID = i_dsDocumentInfo.GetItemString (1, 'correspondence_letter_id')
		l_cUserLogin = OBJCA.WIN.fu_GetLogin (SQLCA)
		
		// get the current case subject ID
		SELECT case_subject_id INTO :l_cSourceID
		  FROM cusfocus.case_log
		 WHERE case_number = :i_sCurrentDocInfo.a_cCaseNumber
		 USING SQLCA;
		 
		IF SQLCA.SQLCode <> 0 THEN
			MessageBox (gs_appname, 'Unable to prepare an entry for this survey in Survey Results~r~n' + &
											'because the case subject could not be determined.')
		ELSE
		
			// create the survey results record
			INSERT INTO cusfocus.survey_results	(survey_id, user_id, letter_id, &
							case_number, survey_prtcpnt_id)
			VALUES (:l_cSurveyID, :l_cUserLogin, :l_cLetterID, :i_sCurrentDocInfo.a_cCaseNumber, &
							:l_cSourceID)
			USING SQLCA;
			
			IF SQLCA.SQLCode <> 0 THEN
				MessageBox (gs_appname, 'Unable to create an entry for this survey in Survey Results.')
			END IF
			
		END IF
		
	END IF
	
END IF

end subroutine

public function boolean uf_iscaselocked (string a_ccasenumber);/*****************************************************************************************
   Function:   uf_IsCaseLocked
   Purpose:    Check if the specified case is locked
   Parameters: STRING - a_cCaseNumber - Number of the case to check
   Returns:    BOOLEAN - TRUE - Case locked by someone else
								 FALSE - Case not locked by someone else

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/26/02 M. Caruso    Created, based on fu_CheckLocked from Contact History.
	10/8/04  JWhite		 Added a section of code to check to see if the user has rights to 
								    edit sent correspondence. If so, then let the user have edit rights
*****************************************************************************************/

BOOLEAN	l_bRV = FALSE
DATETIME	l_dtLockedDate, ldt_sentdate
STRING	l_cLockedBy
string	ls_cUserLogin, ls_edit_sent_corrspndnce

// process if the case number is valid
IF NOT IsNull (a_cCaseNumber) AND Trim (a_cCaseNumber) <> "" THEN	
	
	SELECT locked_by, locked_timestamp
	INTO :l_cLockedBy, :l_dtLockedDate
	FROM cusfocus.case_locks
	WHERE case_number = :a_cCaseNumber
	USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			// consider the case locked if an error occurs
			l_bRV = TRUE
			
		CASE 0
			// if the user locking the case is not the current user, set as locked
			IF Upper (Trim (l_cLockedBy)) <> Upper (Trim (OBJCA.WIN.fu_GetLogin (SQLCA))) THEN
				l_bRV = TRUE
			ELSE
				//-----------------------------------------------------------------------------------------------------------------------------------
				// JWhite	Added 10.7.2004	Added check to see if the user has rights to edit sent correspondence.
				//-----------------------------------------------------------------------------------------------------------------------------------
				ls_cUserLogin = OBJCA.WIN.fu_GetLogin (SQLCA)
			  
			  SELECT cusfocus.cusfocus_user.edit_sent_crrspndnce  
				 INTO :ls_edit_sent_corrspndnce
				 FROM cusfocus.cusfocus_user  
				WHERE cusfocus.cusfocus_user.user_id =  :ls_cUserLogin  
				  ;
				  
				  
				 //-----------------------------------------------------------------------------------------------------------------------------------
				// JWhite Added 7.22.2005 - Make sure that sysadmin has the rights to edit sent correspondence
				//-----------------------------------------------------------------------------------------------------------------------------------
 				If	lower(ls_cUserLogin) = 'cfadmin' Then ls_edit_sent_corrspndnce = 'Y'
//				9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//				If	lower(ls_cUserLogin) = 'sysadmin' Then ls_edit_sent_corrspndnce = 'Y'
				//-----------------------------------------------------------------------------------------------------------------------------------
				// End Added JWhite 7.22.2005
				//-----------------------------------------------------------------------------------------------------------------------------------

				ldt_sentdate = i_dsDocumentInfo.GetItemDateTime (1, 'correspondence_corspnd_sent')  
				
				If Not IsNull(ldt_sentdate) Then
					If	lower(ls_edit_sent_corrspndnce) = 'y' Then
// RAP - Why was this being set to TRUE? Seems silly to me, I'm changing it.
//			Why does the sent date have anything to do with it being locked?
//						l_bRV = TRUE 
						i_sCurrentDocInfo.a_allow_edit_sent = 'Y'
//					Else
//						l_bRV = FALSE
					End If
				End If
				l_bRV = FALSE

				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// JWhite End Added 10.7.2004
				//-----------------------------------------------------------------------------------------------------------------------------------
			END IF
			
		CASE ELSE
			//SQLCA.SQLCode = 100 = No lock record found
			l_bRV = FALSE
			
	END CHOOSE
	
END IF

RETURN l_bRV
end function

public function string of_get_appeal_prop_value (long al_case_number, long al_source_type, string as_column_name);string		ls_value
Datastore	lds_appealprops

lds_appealprops = Create datastore
lds_appealprops.DataObject = 'd_correspondence_appeal_props'
lds_appealprops.SetTransObject(SQLCA)

lds_appealprops.Retrieve(al_case_number, al_source_type)

If lds_appealprops.RowCount() > 0 Then
	ls_value = lds_appealprops.GetItemString(1, as_column_name)
End If

Destroy	lds_appealprops

Return ls_value
end function

public subroutine uf_fillfield (datastore a_dssource, string a_cfieldname, boolean ab_consumerid);/*****************************************************************************************
   Function:   uf_FillField
   Purpose:    Put the specified data into the current bookmark.  This version is based on
					a temporary datastore.
   Parameters: DATASTORE	a_dsSource - The datastore to get the data from.
					STRING		a_cFieldName - The field to get data from.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/07/01 M. Caruso    Created.
	08/07/01 M. Caruso    Only process if the data source contains 1 row
	04/05/02 M. Caruso    Added a call to uf_validatedocument to prevent crashing if the
								 user switches to another Word document during processing.
*****************************************************************************************/

STRING	l_cValue, l_cFormat

IF a_dsSource.RowCount () = 1 THEN

	CHOOSE CASE UPPER (Left (a_dsSource.Describe (a_cFieldName + '.ColType'), 5))
		CASE 'CHAR(', 'CHAR'    // 'CHAR' is used to trap computed columns
			l_cValue = a_dsSource.GetItemString (1, a_cFieldName)
			l_cFormat = a_dsSource.GetFormat (a_cFieldName)
			IF l_cFormat <> '!' AND l_cFormat <> '?' THEN
				l_cValue = STRING (l_cValue, l_cFormat)
			END IF
		
		CASE 'DATE'
			l_cValue = STRING (a_dsSource.GetItemDate (1, a_cFieldName), 'mm/dd/yyyy')
			
		CASE 'DATET', 'TIMES'
			l_cValue = STRING (a_dsSource.GetItemDateTime (1, a_cFieldName), 'mm/dd/yyyy hh:mm:ss AM/PM')
			
		CASE 'DECIM'
			l_cValue = STRING (a_dsSource.GetItemDecimal (1, a_cFieldName))
			
		CASE 'INT', 'LONG', 'NUMBE', 'ULONG'
			l_cValue = STRING (a_dsSource.GetItemNumber (1, a_cFieldName))
			
		CASE 'TIME'
			l_cValue = STRING (a_dsSource.GetItemTime (1, a_cFieldName), 'hh:mm:ss AM/PM')
			
	END CHOOSE

	IF IsNull(l_cValue) Or l_cValue = '' THEN 
		l_cValue = ' '
	End If
	
	uf_ValidateDocument ()
	
	// Conversion for 9-digit zip codes
	IF a_cFieldName = 'other_source_other_zip' OR &
	    a_cFieldName = 'provider_of_service_provid_zip' OR &
	    a_cFieldName = 'consumer_consum_zip' OR &
	    a_cFieldName = 'corspnd_zip' OR &
	    a_cFieldName = 'employ_zip' THEN
		 IF LEN(l_cValue) = 9 THEN
			l_cValue = MID(l_cValue, 1, 5) + "-" + MID(l_cValue, 6, 4)
		ELSEIF LEN(l_cValue) = 6 THEN
			l_cValue = MID(l_cValue, 1, 5)
		END IF
	END IF
		 
	//??? trying the new control
//	i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
	#IF defined PBDOTNET THEN
		i_oleDocument.selection.TypeText (l_cValue)
	#ELSE
		i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (l_cValue)
//		i_wDocWindow.ole_worddoc.Object.Application.selection.TypeText (l_cValue)
	#END IF
	
END IF
end subroutine

public function boolean of_modified ();// Function to determine if the user has made changes to the correspondence
// This is done by counting characters (not including spaces), it is the best
// thing I could come up with...
Boolean lb_return
LONG ll_current, ll_new

IF IsValid( i_wDocWindow.ole_wordocx) THEN
	lb_return =  i_wDocWindow.ole_wordocx.Object.IsDirty 
END IF

IF lb_return OR i_wDocWindow.i_bDocModified THEN lb_return = TRUE

IF lb_return THEN
//	i_wDocWindow.ole_wordocx.Object.Save( i_wDocWindow.is_write_file_name )
	i_wDocWindow.ole_wordocx.object.Save( )
	i_wDocWindow.of_load_word()
END IF 

//IF IsValid(i_wDocWindow.ole_worddoc.Object.Characters) THEN 
//	ll_current = i_wDocWindow.ole_worddoc.Object.Characters.Count
//	lb_return =  i_wDocWindow.ole_worddoc.Object.IsModified
//	IF ll_current <> i_sCurrentDocInfo.a_lCharacter_count THEN
//		lb_return = TRUE
//	ELSE
//		lb_return = FALSE
//	END IF
//ELSE
//	// If I can't tell if it has changed, play it safe
//	lb_return = TRUE
//END IF 

RETURN lb_return

end function

public function integer of_load_signature ();string ls_current_user, ls_signature, ls_file_name
long ll_blob_id

ls_current_user = gn_globals.is_login

SELECT isnull(signature_blbobjctid, 0), blbobjctqlfr
INTO :ll_blob_id, :ls_file_name
FROM cusfocus.cusfocus_user, dbo.blobobject
WHERE user_id = :ls_current_user
AND cusfocus.cusfocus_user.signature_blbobjctid = dbo.blobobject.blbobjctid
USING SQLCA;

IF ll_blob_id = 0 THEN
	RETURN -1
END IF

ls_file_name = 'signature_' + ls_file_name

ls_signature = of_write_file(ls_file_name, ll_blob_id)

	//??? trying the new control
//	i_wDocWindow.ole_wordocx.object.Application.selection.InlineShapes.AddPicture(ls_signature)
#IF defined PBDOTNET THEN
	i_oleDocument.selection.InlineShapes.AddPicture(ls_signature)
#ELSE
	i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.Selection.InlineShapes.AddPicture(ls_signature)
//	i_wDocWindow.ole_worddoc.Object.Application.Selection.InlineShapes.AddPicture(ls_signature)
#END IF
return 1

end function

public function string of_write_file (string as_file_name, long al_blob_id);/*****************************************************************************************
   Event:      of_write_file
   Purpose:    This function will take a filename and a blob id as input.
	            It will write the blob out to the file and return the
					full path of the file.

   Revisions:
   Date       Developer    Description
   ========   ============ =================================================================
	12/18/2006 R. Post      Created
*****************************************************************************************/
Long l_nFileNum, l_nAttachmentKey, l_nAttachFileNum, ll_blob_id
Integer l_nIndex, l_nLoop, l_nWriteRV, l_nRV
Blob l_blFile, l_blFilePart
Double l_dblFileSize
ContextKeyword l_ckTemp
String l_cTemp[ ], l_cFileName, l_cWriteFileName, l_cAttachFileLog
n_cst_kernel32 l_uoKernelFuncs
n_blob_manipulator ln_blob_manipulator

ln_blob_manipulator = CREATE n_blob_manipulator

//Get the file name
l_cFileName = as_file_name
ll_blob_id = al_blob_id
l_blFile = ln_blob_manipulator.of_retrieve_blob(ll_blob_id)

IF Trim( l_cFileName ) <> "" THEN
	//Prepare to open the document.
	// Get the Temp Path from Environment Variables to write the file
	// out before attempt to open.
	#IF defined PBDOTNET THEN
		l_cTemp[1] = 'C:\Temp'

//			l_cTemp[1] = System.IO.Path.GetTempPath()
	#ELSE
		l_ckTemp = CREATE ContextKeyword
		l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
		
		//Have the needed info.  Destroy the object.
		DESTROY l_ckTemp
	#END IF
	
	//If temp Path is not available, use Root drive.
	IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cTemp[ 1 ] ) THEN 
		l_cTemp[ 1 ] = 'C:\'
	END IF
	
	//Get rid of any potential white space.
	l_cTemp[ 1 ] = Trim( l_cTemp[ 1 ] )
	
	//Add the directory to the file name.
	IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
		l_cWriteFileName = ( l_cTemp[ 1 ]+l_cFileName )
	ELSE
		l_cWriteFileName = ( l_cTemp[ 1 ]+"\"+l_cFileName )
	END IF
	
	//Write the file out.
	l_nFileNum = FileOpen( l_cWriteFileName, StreamMode!, Write!, LockReadWrite!, Replace! )
		
	IF l_nFileNum > 0 THEN
		//Find out how many reads to make on the image
		l_dblFileSize = Len( l_blFile )
		
		IF l_dblFileSize <= 32765 THEN
			l_nLoop = 1
		ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
			l_nLoop = ( l_dblFileSize / 32765 )
		ELSE
			l_nLoop = Ceiling( l_dblFileSize / 32765 )
		END IF
		
		//Write the file.
		IF l_nLoop = 1 THEN
			l_nWriteRV = FileWrite( l_nFileNum, l_blFile )
		ELSE
			l_blFilePart = BlobMid( l_blFile, 1, 32765 )
			FOR l_nIndex = 1 TO l_nLoop				
				l_nWriteRV = FileWrite( l_nFileNum, l_blFilePart )
				
				IF l_nWriteRV = -1 THEN					
					EXIT
				ELSE
					l_blFilePart = BlobMid( l_blFile, ( ( 32765 * l_nIndex ) + 1 ), 32765 )
				END IF							
			NEXT
		END IF
		
		IF l_nWriteRV = -1 THEN
			FileClose( l_nFileNum )
			FileDelete( l_cFileName )
						
			MessageBox( gs_AppName, "Unable to write to file "+l_cWriteFileName+".", &
							StopSign!, OK! )									
			RETURN ''
		ELSE
			FileClose( l_nFileNum )
			
		END IF
	ELSE
		MessageBox( gs_AppName, "Could not open the file for write", StopSign!, OK! )
	END IF						
ELSE
	MessageBox( gs_AppName, "File name not populated.  Could not open file", StopSign!, OK! )
END IF

Destroy ln_blob_manipulator
//SetPointer( Arrow! )

RETURN l_cWriteFileName
end function

public function integer of_load_lob_logo ();string ls_current_user, ls_lob_logo, ls_file_name
long ll_blob_id, ll_lob_id

IF i_dsAppeal.RowCount () = 1 THEN
	ll_lob_id = i_dsAppeal.object.line_of_business_id[1]
	

	SELECT isnull(lob_logo_blbobjctid, 0), blbobjctqlfr
	INTO :ll_blob_id, :ls_file_name
	FROM cusfocus.line_of_business, dbo.blobobject
	WHERE line_of_business_id = :ll_lob_id
	AND cusfocus.line_of_business.lob_logo_blbobjctid = dbo.blobobject.blbobjctid
	USING SQLCA;

	IF ll_blob_id = 0 THEN
		RETURN -1
	END IF

	ls_file_name = 'lob_logo_' + ls_file_name

	ls_lob_logo = of_write_file(ls_file_name, ll_blob_id)

	//??? trying the new control
//	i_wDocWindow.ole_wordocx.object.Application.selection.InlineShapes.AddPicture(ls_lob_logo)
	#IF defined PBDOTNET THEN
		i_oleDocument.selection.InlineShapes.AddPicture(ls_lob_logo)
	#ELSE
		i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.Selection.InlineShapes.AddPicture(ls_lob_logo)
//		i_wDocWindow.ole_worddoc.Object.Application.Selection.InlineShapes.AddPicture(ls_lob_logo)
	#END IF
END IF

return 1

end function

public subroutine of_load_case_notes (string as_note_type);LONG ll_row, ll_rowcount
INTEGER li_note_security, li_user_security
STRING ls_user_id, ls_note

//	Determine the Confidentiality level for the User
ls_user_id = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT confidentiality_level
INTO :li_user_security
FROM cusfocus.cusfocus_user WHERE user_id = :ls_user_id; 

ll_rowcount = i_dsCaseNotes.Rowcount()
ll_row = 1
ll_row = i_dsCaseNotes.Find("note_desc='" + as_note_type + "'", ll_row, ll_rowcount)

DO WHILE ll_row > 0
	li_note_security = i_dsCaseNotes.object.case_notes_note_security_level[ll_row]
	IF li_note_security <= li_user_security THEN
		ls_note = i_dsCaseNotes.object.note_text[ll_row]
		IF IsNull(ls_note) OR ls_note = '' THEN
			ls_note = ' '
		END IF
		
		//??? trying the new control
//		i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (ls_note)
		#IF defined PBDOTNET THEN
			i_oleDocument.selection.TypeText (ls_note)
		#ELSE
			i_wDocWindow.ole_wordocx.Object.ActiveDocument.Application.selection.TypeText (ls_note)
//			i_wDocWindow.ole_worddoc.Object.Application.selection.TypeText (ls_note)
		#END IF
	END IF
	ll_row++
	IF ll_row > ll_rowcount THEN EXIT
	ll_row = i_dsCaseNotes.Find("case_desc='Case Bookmark'", ll_row, ll_rowcount)
LOOP


end subroutine

public subroutine of_filldoc ();/*****************************************************************************************
This function is for the version 5.6 of the office viewer control. I had problems getting the window
to appear closed and the resize was weird, etc. The menu didn't seem to fire off events. So I rolled
back to the old version. 11/5/08 RAP
*****************************************************************************************/

BOOLEAN	l_bCSInfoValid, l_bXRefInfoValid, l_bIsXref, l_bAllFound = TRUE, lb_return
INTEGER	l_nBookmarkCount, l_nIndex, l_nLength, l_nBreakPos, l_nSuffixLength, li_return
LONG		l_nRow, l_nRowCount, l_nRow2
STRING	l_cCaseSubjectID, l_cSourceType, l_cXrefID, l_cXrefType, l_cBookmarkName
STRING	l_cSourceID, l_cFieldName, l_cAddress1, l_cAddress2, l_cValue, l_cCaseType
DATASTORE	l_dsInfo
String ls_filename
Boolean lb_continue

i_wDocWindow.SetRedraw(FALSE)


	
	// get the case subject and cross reference subject information
	uf_loadinfo ()
	
	l_bCSInfoValid = (i_dsDemographics.RowCount () > 0)
	l_bXrefInfoValid = (i_dsXrefDemographics.RowCount () > 0)
	
	l_cSourceType = i_dsCaseDetails.GetItemString (1, 'case_log_source_type')
	IF i_sCurrentDocInfo.a_cCaseType = 'P' THEN
		l_cXrefType = ''
	ELSE
		l_cXrefType = i_dsCaseDetails.GetItemString (1, 'case_log_xref_source_type')
	END IF
	
	// now loop through the bookmarks and populate the information
	l_nRowCount = i_dsLookup.RowCount ()
	uf_ValidateDocument ()

l_nBookmarkCount = i_wDocWindow.ole_wordocx.object.ActiveDocument.Bookmarks.Count
		

	FOR l_nIndex = l_nBookmarkCount TO 1 STEP -1
	
		// populate the bookmark
		uf_ValidateDocument ()
		l_cBookmarkName =i_wDocWindow.ole_wordocx.object.ActiveDocument.Bookmarks[l_nIndex].Name
		
		l_nBreakPos = Pos (l_cBookmarkName, '_')
		IF l_nBreakPos = 0 THEN
			
			IF Upper (Left (l_cBookmarkName, 4)) = 'XREF' THEN
				l_bIsXref = TRUE
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + Mid (l_cBookmarkName, 5) + '"', 1, l_nRowCount)
			ELSE
				l_bIsXref = FALSE
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + l_cBookmarkName + '"', 1, l_nRowCount)
			END IF
			
		ELSE
			
			l_nSuffixLength = (len (l_cBookmarkName) - l_nBreakPos) + 1
			IF Upper (Left (l_cBookmarkName, 4)) = 'XREF' THEN
				l_bIsXref = TRUE
				l_nLength = Len (l_cBookmarkName) - (l_nSuffixLength + 4)
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + Mid (l_cBookmarkName, 5, l_nLength) + '"', 1, l_nRowCount)
			ELSE
				l_bIsXref = FALSE
				l_nLength = Len (l_cBookmarkName) - (l_nSuffixLength)
				l_nRow = i_dsLookup.Find ('bookmark_name = "' + Left (l_cBookmarkName, l_nLength) + '"', 1, l_nRowCount)
			END IF
			
		END IF
		
		IF l_nRow > 0 THEN
			
			l_cValue = ''
			l_cSourceID = i_dsLookup.GetItemString (l_nRow, 'source_id')
			l_cFieldName = i_dsLookup.GetItemString (l_nRow, 'field_name')
			// translate Source ID to Source Type when necessary
			uf_ValidateDocument ()
			i_wDocWindow.ole_wordocx.object.Application.selection.GoTo (TRUE, 0, 0, l_cBookmarkName)
//				i_wDocWindow.ole_worddoc.Object.Application.selection.GoTo (TRUE, 0, 0, l_cBookmarkName)
			CHOOSE CASE	l_cSourceID
				CASE 'General Information'
					IF l_cBookmarkName = 'SIG' THEN
						of_load_signature()
					ELSE
						
						CHOOSE CASE l_cFieldName
							CASE 'computed_currentdate'
								l_cValue = STRING (Today(), 'mmmm dd, yyyy')
								uf_ValidateDocument ()
								i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
								
							CASE 'computed_repname'
								l_cValue = SECCA.MGR.i_UsrName
								IF IsNull (l_cValue) THEN l_cValue = ''
								uf_ValidateDocument ()
								i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
								
							CASE 'corspnd_salutation'
								l_cValue = i_dsDocumentInfo.GetItemString (1, l_cFieldName)
								IF Trim (l_cValue) = '' OR l_cValue = '(None)' OR IsNull (l_cValue) THEN
									l_cValue = ''
								END IF
								IF IsNull (l_cValue) THEN l_cValue = ''
								uf_ValidateDocument ()
								i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
								
							CASE 'corspnd_salutation_name'
								l_cValue = i_dsDocumentInfo.GetItemString (1, l_cFieldName)
								IF IsNull (l_cValue) THEN l_cValue = ''
								uf_ValidateDocument ()
								i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
								
							CASE ELSE
								uf_FillField (i_dsCSR, l_cFieldName)
							
						END CHOOSE
					END IF
					
				CASE 'Mailing Information'
					CHOOSE CASE l_cFieldName
						CASE 'computed_address'
							l_cAddress1 = i_dsDocumentInfo.GetItemString (1, 'corspnd_address_1')
							l_cAddress2 = i_dsDocumentInfo.GetItemString (1, 'corspnd_address_2')
							IF l_cAddress2 = '' OR IsNull (l_cAddress2) THEN
								l_cValue = l_cAddress1
							ELSE
								l_cValue = l_cAddress1 + CHAR (13) + l_cAddress2
							END IF
							
						CASE ELSE
							l_cValue = i_dsDocumentInfo.GetItemString (1, l_cFieldName)
							
					END CHOOSE
					IF IsNull (l_cValue) THEN l_cValue = ''
					uf_ValidateDocument ()
					i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (l_cValue)
					
				CASE 'Employer Groups'
					IF l_bIsXref THEN
						IF l_bXrefInfoValid AND l_cXrefType = i_cSourceEmployer THEN
							uf_FillField (i_dsXrefDemographics, l_cFieldName)
						END IF
					ELSE
						IF l_bCSInfoValid AND l_cSourceType = i_cSourceEmployer THEN
							uf_FillField (i_dsDemographics, l_cFieldName)
						END IF
					END IF
					
				CASE 'Members'
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Begin Code for BCBSVT custom bookmark Lookup
					//-----------------------------------------------------------------------------------------------------------------------------------


					Datastore	lds_bcbsvt
					string 		ls_find, ls_optionvalue, ls_value, ls_companyfield, ls_USIDcolumn, ls_company_string
					string		ls_companyID, ls_company_blank
					long			ll_row, ll_rowcount
					
					lds_bcbsvt = Create datastore
					
					lds_bcbsvt.DataObject = 'd_bcbsvt_setup'
					lds_bcbsvt.SetTransObject(SQLCA)
					ll_rowcount = lds_bcbsvt.Retrieve()

					ll_row = lds_bcbsvt.Find('optionname="BCBSVTCustomOn"', 1, ll_rowcount)
					
					If ll_row > 0 Then
						ls_optionvalue = lower(lds_bcbsvt.GetItemString(ll_row, 'optionvalue'))
					End If
					

					//-----------------------------------------------------------------------------------------------------------------------------------
					// Check the system setting to see if they are using the custom USID Bookmark
					//-----------------------------------------------------------------------------------------------------------------------------------

					If ls_optionvalue = 'y' And l_cFieldName = 'consumer_consumer_id' Then
						ll_row  			= 	lds_bcbsvt.Find(' optionname = "USIDColumn"', 1, lds_bcbsvt.RowCount())
						ls_USIDcolumn 	=	lds_bcbsvt.GetItemString(ll_row, 'optionvalue')
						
						ll_row				=	lds_bcbsvt.Find(' optionname = "CompanyField"', 1, lds_bcbsvt.RowCount())
						ls_companyfield	=	lds_bcbsvt.GetItemString(ll_row, 'optionvalue')
						
						ll_row				=	lds_bcbsvt.Find(' optionname = "USIDCompanies"', 1, lds_bcbsvt.RowCount())
						ls_company_string	=	',' + lds_bcbsvt.GetItemString(ll_row, 'optionvalue') + ','
						
//							ll_row				=	lds_bcbsvt.Find(' optionname = "USIDBlankCompanies"', 1, lds_bcbsvt.RowCount())
//							ls_company_blank	=	lds_bcbsvt.GetItemString(ll_row, 'optionvalue')
						
						
						IF l_bIsXref THEN
							IF l_bXrefInfoValid AND l_cXrefType = i_cSourceConsumer THEN
								//-----------------------------------------------------------------------------------------------------------------------------------
								// If the USID is null or '' then check the company field. If it is 01, 06, 09, 21 or 22 then print a blank space
								//-----------------------------------------------------------------------------------------------------------------------------------
								ls_companyID = i_dsXrefDemographics.GetItemString(1, ls_companyfield)
								
								If Pos(ls_company_string, ',' + ls_companyID + ',') > 0 Then
									uf_FillField (i_dsXrefDemographics, ls_USIDcolumn, TRUE)
								Else
									uf_FillField (i_dsXrefDemographics, l_cFieldName)
								End If
							END IF
						ELSE
							IF l_bCSInfoValid AND l_cSourceType = i_cSourceConsumer THEN
								//-----------------------------------------------------------------------------------------------------------------------------------
								// If the USID is null or '' then check the company field. If it is 01, 06, 09, 21 or 22 then print a blank space
								//-----------------------------------------------------------------------------------------------------------------------------------
								ls_companyID = i_dsDemographics.GetItemString(1, ls_companyfield)

								If Pos(ls_company_string, ',' + ls_companyID + ',') > 0 Then
									uf_FillField (i_dsDemographics, ls_USIDcolumn, TRUE)
								Else
									uf_FillField (i_dsDemographics, l_cFieldName)
								End If
							END IF
						END IF
					Else
					//-----------------------------------------------------------------------------------------------------------------------------------
					// Do the normal stuff
					//-----------------------------------------------------------------------------------------------------------------------------------
						IF l_bIsXref THEN
							IF l_bXrefInfoValid AND l_cXrefType = i_cSourceConsumer THEN
								uf_FillField (i_dsXrefDemographics, l_cFieldName)
							END IF
						ELSE
							IF l_bCSInfoValid AND l_cSourceType = i_cSourceConsumer THEN
								uf_FillField (i_dsDemographics, l_cFieldName)
							END IF
						END IF
					End If
				
					//-----------------------------------------------------------------------------------------------------------------------------------
					// End Code for BCBSVT custom bookmark Lookup
					//-----------------------------------------------------------------------------------------------------------------------------------

					
				CASE 'Other Sources'
					IF l_bIsXref THEN
						IF l_bXrefInfoValid THEN
							uf_FillField (i_dsXrefDemographics, l_cFieldName)
						END IF
					ELSE
						IF l_bCSInfoValid THEN
							uf_FillField (i_dsDemographics, l_cFieldName)
						END IF
					END IF
					
				CASE 'Providers'
					IF l_bIsXref THEN
						IF l_bXrefInfoValid AND l_cXrefType = i_cSourceProvider THEN
							uf_FillField (i_dsXrefDemographics, l_cFieldName)
						END IF
					ELSE
						IF l_bCSInfoValid AND l_cSourceType = i_cSourceProvider THEN
							uf_FillField (i_dsDemographics, l_cFieldName)
						END IF
					END IF
					
				CASE 'Case Details'
					uf_FillField (i_dsCaseDetails, l_cFieldName)
					
				CASE 'Case Notes'
					of_load_case_notes (l_cFieldName)
					
				CASE 'Case Properties'
					uf_FillField (i_dsCaseProperties, l_cFieldName)
					
				CASE 'Appeal'
					IF l_cFieldName = 'lob_logo_blbobjctid'  THEN
						of_load_lob_logo()
					ELSE
						uf_FillField (i_dsAppeal, l_cFieldName)
					END IF
					
			END CHOOSE
			
		ELSE
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Catch the appeal events and appeal event property bookmarks that don't fit the "normal" bookmark checks
			//-----------------------------------------------------------------------------------------------------------------------------------

			
			
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Check to see if this bookmark is an appeal property
			//-----------------------------------------------------------------------------------------------------------------------------------

			Datastore 	lds_appealprops, lds_appealevents
			long			ll_find_row
			long			ll_source_type
			string		ls_column
			long			ll_case_number
			boolean		lb_found = FALSE

			lds_appealprops = Create datastore
			lds_appealprops.DataObject = 'd_tm_appeal_prop_field_defs'
			lds_appealprops.SetTransObject(SQLCA)
			
			lds_appealprops.Retrieve()
			
			ll_find_row = lds_appealprops.Find('bookmark_name="' + l_cBookmarkName + '"', 1, lds_appealprops.RowCount())
			
			If ll_find_row > 0 Then
				ll_source_type =	lds_appealprops.GetItemNumber(ll_find_row, 'source_type')
				ls_column		=	lds_appealprops.GetItemString(ll_find_row, 'column_name')
				
				ls_value = of_get_appeal_prop_value(long(i_sCurrentDocInfo.a_cCaseNumber), ll_source_type, ls_column)
				lb_found = TRUE
			End If
			
			//-----------------------------------------------------------------------------------------------------------------------------------

			// Check to see if this bookmark is an appeal event
			//-----------------------------------------------------------------------------------------------------------------------------------

			If lb_found <> TRUE Then
				lds_appealevents = Create datastore
				lds_appealevents.DataObject = 'd_tm_appeal_event'
				lds_appealevents.SetTransObject(SQLCA)
				
				lds_appealevents.Retrieve()
				
				ll_find_row = lds_appealevents.Find('bookmark_name="' + l_cBookmarkName + '"', 1, lds_appealevents.RowCount())
			
				If ll_find_row > 0 Then
					ls_value		=	lds_appealevents.GetItemString(ll_find_row, 'eventname')
					lb_found 	= 	TRUE
				End If
			End If

			If lb_found = TRUE Then 
				IF IsNull (ls_value) THEN ls_value = ''
				uf_ValidateDocument ()
				i_wDocWindow.ole_wordocx.object.Application.selection.GoTo (TRUE, 0, 0, l_cBookmarkName)
				i_wDocWindow.ole_wordocx.object.Application.selection.TypeText (ls_Value)
			End If

			If lb_found = FALSE Then
				l_bAllFound = FALSE
			End If		
			
		END IF
		
	NEXT
	
	// Set document as changed, since it is new.
	i_bDocFilled = TRUE
	i_wDocWindow.i_bDocModified = TRUE
	
	i_cDocName = ''

//i_wDocWindow.ole_worddoc.ActiveDocument.save
//li_return = ole_worddoc.DisConnectObject()
//i_wDocWindow.ole_worddoc.ActiveDocument.close

i_wDocWindow.SetRedraw(TRUE)
//??i_wDocWindow.ole_worddoc.Documents.save(i_wDocWindow.is_write_file_name)
//??i_wDocWindow.ole_worddoc.Documents.close()
//??i_wDocWindow.of_word_ocx()

Destroy lds_appealprops
Destroy lds_appealevents

end subroutine

on u_correspondence_mgr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_correspondence_mgr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    Initialize the Correspondence Manager

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/07/01 M. Caruso    Created.
*****************************************************************************************/

// load the lookup table - i_dsLookUp
i_dsLookUp = CREATE DATASTORE
i_dsLookUp.DataObject = 'd_correspondence_lookup'
i_dsLookUp.SetTransObject (SQLCA)
i_dsLookUp.Retrieve ()

// create the case subject and cross reference datastores
i_dsDemographics = CREATE DATASTORE
i_dsXrefDemographics = CREATE DATASTORE
i_dsCaseDetails = CREATE DATASTORE
i_dsCaseProperties = CREATE DATASTORE
i_dsDocumentInfo = CREATE DATASTORE
i_dsappeal = Create DATASTORE
i_dsCSR = Create DATASTORE
i_dsCaseNotes = Create DATASTORE

// initialize i_wDocWindow
SetNull (i_wDocWindow)
end event

event destructor;/*****************************************************************************************
   Event:      destructor
   Purpose:    Clean up after the Correspondence Manager

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/07/01 M. Caruso    Created.
	03/28/02 M. Caruso    Added call to uf_CloseDocWindow.
*****************************************************************************************/

// ensure the document window gets closed before this manager is closed.
uf_CloseDocWindow ()

IF IsValid (i_dsLookUp) THEN DESTROY i_dsLookUp
IF IsValid (i_dsDemographics) THEN DESTROY i_dsDemographics
IF IsValid (i_dsXrefDemographics) THEN DESTROY i_dsXrefDemographics
IF IsValid (i_dsCaseDetails) THEN DESTROY i_dsCaseDetails
IF IsValid (i_dsCaseProperties) THEN DESTROY i_dsCaseProperties
IF IsValid (i_dsDocumentInfo) THEN DESTROY i_dsDocumentInfo
IF IsValid (i_dsappeal) THEN DESTROY i_dsappeal
IF IsValid (i_dsCSR) THEN DESTROY i_dsCSR
IF IsValid (i_dsCaseNotes) THEN DESTROY i_dsCaseNotes

end event

