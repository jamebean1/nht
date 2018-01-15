$PBExportHeader$w_create_maintain_case.srw
$PBExportComments$Create/Maintain Case Window
forward
global type w_create_maintain_case from w_main_std
end type
type uo_search_criteria from u_search_criteria within w_create_maintain_case
end type
type dw_folder from u_folder within w_create_maintain_case
end type
end forward

global type w_create_maintain_case from w_main_std
integer width = 3653
integer height = 1908
string title = "Create and Maintain Case"
string menuname = "m_create_maintain_case"
long backcolor = 79748288
uo_search_criteria uo_search_criteria
dw_folder dw_folder
end type
global w_create_maintain_case w_create_maintain_case

type variables
//Case Linking Variables
BOOLEAN						i_bLinked = FALSE
INT							i_nCaseLinkCount = 0
INT							i_nCaseLinkMax = 0
STRING						i_cCurrCaseMasterNum
STRING					   i_cLinkMasterCase
STRING						i_cLinkWarnEnabled
STRING					   i_cLinkLastCaseType
STRING						i_cLinkLastSourceType
/////////////////////////

BOOLEAN						i_bNewCaseSubject
BOOLEAN						i_bDemographicUpdate
BOOLEAN						i_bCaseDetailUpdate
BOOLEAN						i_bSaveDemographics
BOOLEAN						i_bSaveCase
BOOLEAN						i_bSearchCriteriaUpdate
BOOLEAN						i_bNeedCaseSubject 
BOOLEAN						i_bSupervisorRole
BOOLEAN						i_bDocsOpened
BOOLEAN						i_bPrintSurvey
BOOLEAN						i_bCloseCase
BOOLEAN						i_bNewProactive
BOOLEAN                 i_bOutOfOffice
BOOLEAN                 i_bNew
BOOLEAN                 i_bVendorCase = FALSE

INT							i_nRepConfidLevel			// case confid. level of the current case rep
INT							i_nCaseConfidLevel		// confid. level of the current case
INT							i_nRecordConfidLevel		// current demographic confid. level
INT							i_nRepRecConfidLevel		// demographic confid. level of the current case rep
INT							i_nNonIssueConfidLevel = 0
INT							i_nDefIssueConfidLevel = 1
INT							i_nNumConfigFields = 0

LONG                    i_nProviderKey

INT							i_nBaseWidth
INT							i_nBaseHeight

STRING						i_cSupervisorRole 

STRING                  i_cUserID

STRING						i_cPreviousCaseSubject
STRING						i_cPreviousCaseSubjectName
STRING						i_cPreviousSourceType

STRING						i_cSourceConsumer  = 'C'
STRING						i_cSourceEmployer  = 'E'
STRING						i_cSourceProvider  = 'P'
STRING						i_cSourceOther     = 'O'
STRING						i_cLastSource
STRING                  i_cProviderKey
STRING                  i_cProviderId
STRING                  i_cVendorID

STRING						i_cProviderType      
STRING						i_cSelectedCase
STRING						i_cCurrentCase
STRING						i_cCurrCaseRep
STRING						i_cCurrentCaseSubject
STRING						i_cCaseSubjectName
STRING						i_cSourceType
STRING						i_cCaseType
STRING						i_cUserLastName
STRING						i_cContactPerson
STRING    					i_cConsumerGroupID
STRING                  i_cConsumerID

STRING						i_cStatusOpen   = 'O'
STRING						i_cStatusClosed = 'C'
STRING						i_cStatusVoid   = 'V'
STRING						i_cCusSatCodeID
STRING						i_cResCodeID
STRING						i_cOtherCloseCodeID

STRING						i_cInquiry			= 'I'
STRING						i_cIssueConcern	= 'C'
STRING						i_cConfigCaseType		= 'M'
STRING						i_cProActive		= 'P'

STRING						i_cDefConsumerRelationship = '1'
STRING						i_cDefEmployerRelationship = '2'
STRING						i_cDefProviderRelationship = '3'
STRING						i_cDefOtherRelationship = '4'

STRING						i_cDefMethod = '1'

STRING						i_cSaveCaseChanges = 'Would you like to save your changes to the Case?'
STRING						i_cSaveDemographicChanges = 'Would you like to save your changes to the Case Subject?'
STRING						i_cSaveContactNoteChanges = 'Would you like to save your changes to the Contact Note?'
STRING						i_cSaveMessage

STRING						i_cWORDExe

STRING						i_cSetRecordSecurity
STRING						i_cApplyToMembers

string						is_contacthistory_casetype

//For use when determining if the current user can close the case rather than have
//  CustomerFocus route it back to the person who originally took the case.
STRING						i_cCloseBy

S_FIELDPROPERTIES			i_sConfigurableField[]
S_FIELDPROPERTIES			i_sContactHistoryField[]
S_FIELDPROPERTIES			i_sSearchableCaseProps[]

U_DEMOGRAPHICS				i_uoDemographics
U_CONTACT_NOTES			i_uoContactNotes
U_CONTACT_HISTORY			i_uoContactHistory
U_CASE_DETAILS				i_uoCaseDetails
U_CROSS_REFERENCE			i_uoCrossReference
U_CASE_CORRESPONDENCE	i_uoCaseCorrespondence
U_CASE_REMINDERS			i_uoCaseReminders

STRING						i_ulDemographicsCW  
STRING						i_ulDemographicsVW
STRING						i_ulCaseHistoryCW
STRING						i_ulCaseHistoryVW
STRING						i_ulCaseDetailCW
STRING						i_ulCaseDetailVW

WINDOWOBJECT				i_woTabObjects[]

//Case Lock instance variables
BOOLEAN 						i_bCaseLocked = FALSE  //Indicates if the case is locked by someone else
STRING						i_cLockedBy //Who the case is currently locked by, if at all

Boolean						ib_contacthistory_firstopen = TRUE
end variables

forward prototypes
public subroutine fw_checkoutofoffice ()
public function long fw_buildfieldlist (string source_type)
public subroutine fw_removelink ()
public subroutine fw_caselinkwarning ()
public subroutine fw_closeby ()
public subroutine fw_sortdata ()
public function integer fw_checkothertabs ()
public subroutine fw_contactperson ()
public subroutine fw_clearcaselocks ()
public function integer fw_linkcase ()
public subroutine fw_togglelinking ()
public subroutine fw_newsearch ()
public subroutine fw_reassigncasesubject ()
public subroutine fw_validatedemographics ()
public subroutine fw_voidcase ()
public subroutine fw_closecase ()
public subroutine fw_updatedemographicsrt ()
public subroutine fw_aftersearchprocess ()
public subroutine fw_transfercase ()
public function long of_build_contacthistory_fields (string source_type)
public function string of_add_case_properties ()
public function integer of_get_caseprops (string source_type)
public function string of_add_appeal_properties ()
public function integer of_get_appealprops (long source_type)
end prototypes

public subroutine fw_checkoutofoffice ();//********************************************************************************************
//
//  Function: fw_checkoutofoffice
//  Purpose:  To mark the out of office menu item
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/15/00 cjackson    Original Verison
//
//********************************************************************************************

LONG l_nCount

// Get userid
i_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

// If the user is currently mark as out of the office, setting the Check on the menu item
SELECT count(*) INTO :l_nCount
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cUserID
 USING SQLCA;
 
// Update the clicked property based on whether not the user if Out of Office 
IF l_nCount > 0 THEN
	m_create_maintain_case.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_create_maintain_case.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF







end subroutine

public function long fw_buildfieldlist (string source_type);/*****************************************************************************************
	Function:	fw_buildfieldlist
	Purpose:		Add defined configurable fields to the field list for the selected source
	            type.
	Parameters:	STRING	source_type -> determine which set of configurable fields to add.
	Returns:		LONG ->	 0 - success
								-1 - failure
								
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	7/12/99  M. Caruso     Created.
	
	7/15/99  M. Caruso     Removed code to add fields to i_cCriteriaColumn[],
	                       i_cSearchColumn[] and i_cSearchTable[]
	5/3/2001 K. Claver     Enhanced to set invisible property for fields so are added to the
								  demographics configurable datawindow so can use as arguments for 
								  IIM tabs

*****************************************************************************************/
U_DS_FIELD_LIST	l_dsFields
LONG					l_nCount, l_nColIndex

// retrieve the list of fields for source_type from the database.
l_dsFields = CREATE u_ds_field_list
l_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = l_dsFields.Retrieve(source_type)

// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sConfigurableField[l_nCount].column_name = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_column_name")
		IF IsNull (i_sConfigurableField[l_nCount].column_name) OR &
			(Trim (i_sConfigurableField[l_nCount].column_name) = "") THEN
			i_sConfigurableField[l_nCount].column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sConfigurableField[l_nCount].field_label = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_field_label")
		IF IsNull (i_sConfigurableField[l_nCount].field_label) OR &
			(Trim (i_sConfigurableField[l_nCount].field_label) = "") THEN
			i_sConfigurableField[l_nCount].field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sConfigurableField[l_nCount].field_length = l_dsFields.GetItemNumber(l_nCount, &
					"field_definitions_field_length")
		IF IsNull (i_sConfigurableField[l_nCount].field_length) THEN
			i_sConfigurableField[l_nCount].field_length = 50
		END IF
		
		// get the "locked" parameter associated with this field
		i_sConfigurableField[l_nCount].locked = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_locked")
		IF IsNull (i_sConfigurableField[l_nCount].locked) OR &
			(Trim (i_sConfigurableField[l_nCount].locked) = "") THEN
			i_sConfigurableField[l_nCount].locked = "N"
		END IF
		
		// Get the "searchable" parameter associated with this field
		i_sConfigurableField[l_nCount].searchable = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_searchable")
		IF IsNull (i_sConfigurableField[l_nCount].searchable) OR &
			(Trim (i_sConfigurableField[l_nCount].searchable) = "") THEN
			i_sConfigurableField[l_nCount].searchable = "N"
		END IF
		
		// get the "display only" parameter associated with this field
		i_sConfigurableField[l_nCount].display_only = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_display_only")
		IF IsNull (i_sConfigurableField[l_nCount].display_only) OR &
			(Trim (i_sConfigurableField[l_nCount].display_only) = "") THEN
			i_sConfigurableField[l_nCount].display_only = "N"
		END IF
		
		// get the edit mask associated with this field
		i_sConfigurableField[l_nCount].edit_mask = l_dsFields.GetItemString(l_nCount, &
					"display_formats_edit_mask")
		IF IsNull (i_sConfigurableField[l_nCount].edit_mask) OR &
			(Trim (i_sConfigurableField[l_nCount].edit_mask) = "") THEN
			i_sConfigurableField[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sConfigurableField[l_nCount].display_format = l_dsFields.GetItemString(l_nCount, &
					"display_formats_display_format")
		IF IsNull (i_sConfigurableField[l_nCount].display_format) OR &
			(Trim (i_sConfigurableField[l_nCount].display_format) = "") THEN
			i_sConfigurableField[l_nCount].display_format = '[general]'
		END IF
		
		// get the display name associated with this field
		i_sConfigurableField[l_nCount].format_name = l_dsFields.GetItemString(l_nCount, &
					"display_formats_format_name")
		IF IsNull (i_sConfigurableField[l_nCount].format_name) OR &
			(Trim (i_sConfigurableField[l_nCount].format_name) = "") THEN
			i_sConfigurableField[l_nCount].format_name = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sConfigurableField[l_nCount].validation_rule = l_dsFields.GetItemString(l_nCount, &
					"display_formats_validation_rule")
		IF IsNull (i_sConfigurableField[l_nCount].validation_rule) OR &
			(Trim (i_sConfigurableField[l_nCount].validation_rule) = "") THEN
			i_sConfigurableField[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sConfigurableField[l_nCount].error_msg = l_dsFields.GetItemString(l_nCount, &
					"display_formats_error_msg")
		IF IsNull (i_sConfigurableField[l_nCount].error_msg) OR &
			(Trim (i_sConfigurableField[l_nCount].error_msg) = "") THEN
			i_sConfigurableField[l_nCount].error_msg = ''
		END IF
		
		// get the visible setting associated with this field
		i_sConfigurableField[l_nCount].visible = l_dsFields.GetItemString(l_nCount, &
					"field_definitions_visible")
		IF IsNull (i_sConfigurableField[l_nCount].visible) OR &
			(Trim (i_sConfigurableField[l_nCount].visible) = "") THEN
			i_sConfigurableField[l_nCount].visible = ''
		END IF

//		// add any searchable fields to the related search window instance variables.
//		IF i_sConfigurableField[l_nCount].searchable = 'Y' THEN
//			l_nColIndex = UpperBound(uo_search_criteria.i_cCriteriaColumn) + 1
//			uo_search_criteria.i_cCriteriaColumn[l_nColIndex] = i_sConfigurableField[l_nCount].column_name
//			uo_search_criteria.i_cSearchColumn[l_nColIndex] = i_sConfigurableField[l_nCount].column_name
//			// set the search table = to the table of the previous column
//			uo_search_criteria.i_cSearchTable[l_nColIndex] = uo_search_criteria.i_cSearchTable[l_nColIndex - 1]
//		END IF
	NEXT
END IF

// remove the datastore from memory
DESTROY l_dsFields

RETURN 0
end function

public subroutine fw_removelink ();/***************************************************************************************
Function:	fw_removelink
	Purpose:		To remove the link from the selected case and the associated cases(if they
					exist).
	Parameters:	None
	Returns:		None
	
	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	6/11/2001 K. Claver    Created.
**************************************************************************************/
//u_dw_std l_dwCaseHistory
u_datawindow l_dwCaseHistory
Integer l_nRow, l_nReturn = 0, l_nLinkCount, l_nLevel, ll_casenumber
String l_cNull, l_cMasterNum, l_cCaseRep
Boolean l_bAutoCommit
string ls_casenumber

SetNull( l_cNull )

IF IsValid( i_uoContactHistory ) THEN
	l_dwCaseHistory = i_uoContactHistory.uo_search_contact_history.dw_report
	l_nRow = i_uoContactHistory.uo_search_contact_history.il_row
	
	IF l_nRow > 0 THEN
		//Check security
		l_nLevel = l_dwCaseHistory.Object.confidentiality_level[ l_nRow ]
		l_cCaseRep = l_dwCaseHistory.Object.case_log_case_log_case_rep[ l_nRow ]
		IF (l_nLevel <= THIS.i_nRepConfidLevel) OR &
			(l_cCaseRep = OBJCA.WIN.fu_GetLogin(SQLCA)) THEN	
	
			l_cMasterNum = l_dwCaseHistory.Object.case_log_master_case_number[ l_nRow ]
			ls_casenumber = l_dwCaseHistory.Object.case_number[ l_nRow ]
		
			IF NOT IsNull( l_cMasterNum ) AND Trim( l_cMasterNum ) <> "" THEN
				l_bAutoCommit = SQLCA.autocommit
				SQLCA.autocommit = FALSE

				//-----------------------------------------------------------------------------------------------------------------------------------
				// JWhite 5.17.2005 	Changed the call to fu_save to be an embedded Update as the DW has changed
				//-----------------------------------------------------------------------------------------------------------------------------------
				l_dwCaseHistory.Object.case_log_master_case_number[ l_nRow ] = l_cNull
				//l_nReturn = l_dwCaseHistory.fu_Save( l_dwCaseHistory.c_SaveChanges )
				
				Update	cusfocus.case_log
				Set		master_case_number = :l_cNull
				Where		master_case_number = :l_cMasterNum
				and		case_number 		= :ls_casenumber
				Using		SQLCA;
				
				IF SQLCA.SQLCode <> 0 THEN 
			      MessageBox('Debug Code', 'Error: The Update statement is failing. The SQLCA ErrTxt is: ' + SQLCA.SQLErrText)
				END IF
				
				IF SQLCA.SQLCode = 0 THEN

					//Remove the link if there is only one case left with the master case number
					SELECT Count( * )
					INTO :l_nLinkCount
					FROM cusfocus.case_log
					WHERE cusfocus.case_log.master_case_number = :l_cMasterNum
					USING SQLCA;
					
					IF SQLCA.SQLCode <> 0 THEN
						ROLLBACK USING SQLCA;
						MessageBox( gs_AppName, "Error determining number of associated cases.", StopSign!, OK! )
					ELSEIF l_nLinkCount = 1 THEN
						//Remove the link from the last associated case
						UPDATE cusfocus.case_log
						SET cusfocus.case_log.master_case_number = NULL
						WHERE cusfocus.case_log.master_case_number = :l_cMasterNum
						USING SQLCA;
						
						IF SQLCA.SQLCode <> 0 THEN
							ROLLBACK USING SQLCA;
							MessageBox( gs_AppName, "Error removing link from the last associated case", StopSign!, OK! )
						ELSE
							COMMIT USING SQLCA;
						END IF
					ELSE
						COMMIT USING SQLCA;
					END IF
				ELSE
					ROLLBACK USING SQLCA;
					MessageBox( gs_AppName, "Error removing link from the case", StopSign!, OK! )
				END IF
				
				//Reset the autocommit value
				SQLCA.AutoCommit = l_bAutoCommit
				
				//Re-retrieve the case history datawindow in case changes were made to other cases.
				i_uoContactHistory.of_retrieve()
				//l_dwCaseHistory.fu_Retrieve( l_dwCaseHistory.c_IgnoreChanges, l_dwCaseHistory.c_ReselectRows )
			ELSE
				MessageBox( gs_AppName, "This case does not have a master case number", StopSign!, OK! )
			END IF
		ELSE
			//Not the right security level
			MessageBox( gs_AppName,'You do not have the necessary permissions to edit this case.', StopSign!, OK! )
		END IF
	END IF
END IF
end subroutine

public subroutine fw_caselinkwarning ();//*********************************************************************************************
//
//  Function: fw_CaseLinkWarning
//  Purpose:  To determine if a warning should be displayed after n linked cases.
//
//  Parameters: None
//  Returns: None
//							
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  6/8/2001 K. Claver   Created
//*********************************************************************************************
String l_cCaseLinkMax

//Check if the link cases warning is enabled.  If so, get the value.
SELECT cusfocus.system_options.option_value
INTO :THIS.i_cLinkWarnEnabled
FROM cusfocus.system_options
WHERE cusfocus.system_options.option_name = 'link_warning_enabled'
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox( gs_AppName, "Unable to determine Case Link Warning settings.", StopSign!, OK! )
	THIS.i_cLinkWarnEnabled = "N"
ELSE
	//Get the value for the number of cases to link before the warning is displayed
	SELECT cusfocus.system_options.option_value
	INTO :l_cCaseLinkMax
	FROM cusfocus.system_options
	WHERE cusfocus.system_options.option_name = 'link_warning_case_count'
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Unable to determine Case Link Warning settings.", StopSign!, OK! )
		THIS.i_nCaseLinkMax = 0
	ELSE
		THIS.i_nCaseLinkMax = Integer( l_cCaseLinkMax )
	END IF
END IF
end subroutine

public subroutine fw_closeby ();//*********************************************************************************************
//
//  Function: fw_CloseBy
//  Purpose:  To determine who is allowed to close a transferred case
//
//  Parameters: None
//  Returns: None
//							
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  2/21/2002 K. Claver  Created
//*********************************************************************************************
SELECT option_value
INTO :THIS.i_cCloseBy
FROM cusfocus.system_options
WHERE Upper( option_name ) = 'RETURN FOR CLOSE'
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox( gs_AppName, "Error determining return for closure settings" )
	SetNull( THIS.i_cCloseBy )
ELSE
	THIS.i_cCloseBy = Trim( Upper( THIS.i_cCloseBy ) )
	
	IF THIS.i_cCloseBy = "" THEN
		SetNull( THIS.i_cCloseBy )
	END IF
END IF
end subroutine

public subroutine fw_sortdata ();/**************************************************************************************
	Function:	fw_sortdata
	Purpose:		To get the available fields on that datawindow to be sorted and
						sort them.
	Parameters:	None
	Returns:		None

	Revisions:
	Date     Developer    Description
	======== ============ ==============================================================
	6/13/00  M. Caruso    Modified the code to work with the IIM Tabs by defining
								 l_dwSortDW for the Inquiry Tab and processing column names
								 properly in that instance.
	9/21/00  M. Caruso    Set the sort datawindow to NULL on the demographics tab.
	10/17/00 M. Caruso    Removed entries for the Demographics and Inquiry tabs and
								 added an entry for the Contact History tab.
	12/04/2000 K. Claver	 Added entry for Contact Notes and commented out code specific to
								 tab 3 when reading tag values from the datawindow to sort.
	01/16/01 M. Caruso    Modified the name of the dataobject for prompting to sort
								 matched cases on the Search Tab.  Also updated the dataobject
								 CASE statement to initialize the arrays properly for each type
								 based on the dataobject in question.
	3/19/2001 K. Claver   Added code to exit the function if on the case tab(for example)
								 to prevent a null object reference.  
**************************************************************************************/

INT				l_nFieldIndex, l_nColumnIndex, l_nColumnCount
LONG				l_nSortError
STRING 			l_cSortString, l_cColumnName, l_cColumnLabel
S_ColumnSort	l_sSortData
U_DW_STD			l_dwSortDW
U_IIM_TAB_PAGE	l_uPage

CHOOSE CASE dw_folder.i_SelectedTab

	CASE 1 // Search Criteria
		l_dwSortDW = uo_search_criteria.uo_matched_records.dw_matched_records
		
	CASE 3 // Contact Notes
		l_dwSortDW = i_uoContactNotes.dw_contact_note_list	

	CASE 4 // Contact History Tab
//RAP		l_dwSortDW = i_uoContactHistory.dw_case_history
		RETURN
	CASE 6 // Cross Reference
		l_dwSortDW = i_uoCrossReference.dw_cross_reference

	CASE 7 // Case Correspondence
		l_dwSortDw = i_uoCaseCorrespondence.dw_correspondence_list

	CASE 8 // Case Reminders
		l_dwSortDW = i_uOCaseReminders.dw_case_reminder_history
	
	CASE ELSE
		RETURN

END CHOOSE

CHOOSE CASE l_dwSortDW.DataObject
	CASE 'd_matched_cases'
		l_sSortData.label_name[1] = l_dwSortDW.Describe ("sort_case_number_t.Text")
		l_sSortData.column_name[1] = 'sort_case_number'
		l_sSortData.label_name[2] = l_dwSortDW.Describe ("sort_master_case_number_t.Text")
		l_sSortData.column_name[2] = 'sort_master_case_number'
		l_nFieldIndex = 2
		
	CASE 'd_case_history'
		l_sSortData.label_name[1] = l_dwSortDW.Describe ("master_case_numeric_t.Text")
		l_sSortData.column_name[1] = 'master_case_numeric'
		l_sSortData.label_name[2] = l_dwSortDW.Describe ("sort_case_number_t.Text")
		l_sSortData.column_name[2] = 'sort_case_number'
		l_nFieldIndex = 2
		
	CASE ELSE
		l_nFieldIndex = 0
		
END CHOOSE

// Get the column names and labels to display to the user.
l_nColumnCount = LONG(l_dwSortDW.Describe("Datawindow.Column.Count")) 
FOR l_nColumnIndex = 1 to l_nColumnCount

	l_cColumnName = l_dwSortDW.Describe ("#" + String(l_nColumnIndex) + ".Name")
	l_cColumnLabel = l_dwSortDW.Describe (l_cColumnName + "_t.Text")
	CHOOSE CASE l_cColumnLabel
		CASE '!', '?'
			// do nothing because the label is invalid.
			
		CASE ELSE
			l_nFieldIndex ++
			l_sSortData.label_name[l_nFieldIndex] = l_cColumnLabel
			l_sSortData.column_name[l_nFieldIndex] = l_cColumnName
			
	END CHOOSE
		
NEXT

//Want Note Summary to be at the end of the sort list for contact notes
IF l_dwSortDW.DataObject = 'd_contact_note_list' THEN
	l_nFieldIndex ++
	l_sSortData.label_name[l_nFieldIndex] = l_dwSortDW.Describe("note_summary.Tag")
	l_sSortData.column_name[l_nFieldIndex] = 'note_summary'
END IF	

IF l_dwSortDW.DataObject = 'd_cross_reference' THEN
	l_nFieldIndex ++
	l_sSortData.label_name[l_nFieldIndex] = l_dwSortDW.Describe("cc_vendor_t.Text")
	l_sSortData.column_name[l_nFieldIndex] = 'cc_vendor'
END IF	
	
FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)
l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = l_dwSortDW.SetSort(l_cSortString)
	l_nSortError = l_dwSortDW.Sort()
END IF

end subroutine

public function integer fw_checkothertabs ();//*********************************************************************************************
//
//  Function: fw_checkothertabs
//  Purpose:  To determine if we need to save whats on the current tab prior to allowing the 
//            user to proceed to the tab they selected.
//							
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  6/21/99  M. Caruso   Added code in Cases 3-6 to verify a case number exists for a case 
//                       before the save is attempted.  For new cases, a case number is 
//								 assigned, before the call to fu_save().  Also added a prompt to 
//								 allow the user to save changes or discard them.
//  6/22/99  M. Caruso   Modified code to trigger save prompt only if datawindow status is 
//                       New!, NewModified! or DataModified!. The code checks the status of 
//								 the dw_case_detail and dw_customer_statement where appropriate.  
//								 Applies to Tabs 3-6. 
//  8/24/99  M. Caruso   Modified code for tabs 7 and 8 so that the user is prompted to save 
//                       data if necessary.
//  9/9/99   M. Caruso   If the user decides not to save a case, correspondence item or 
//                       reminder, that row is deleted if it was new and marked as NotModified! 
//								 if it already existed.
//  04/18/00 C. Jackson  Add instance variable to reset the case status as new when clicking 
//                       on the Proactive toolbar item (SCR 525)
//  08/14/00 C. Jackson  Comment out the setting of i_bNewProActive to TRUE (SCR 754)
//  10/17/00 M. Caruso   Modified to work with the new Case Detail setup.
//  11/28/00 M. Caruso   Changed the conditions for prompting to save on tabs 7 & 8 to not
//								 include New!.
//  11/29/2000 K. Claver Added condition for the contact note tab
//  12/27/00 M. Caruso   Added code to CASE 1 to verify that there are rows in
//								 dw_matched_records before assigning a case number.
//  01/10/01 M. Caruso   Modified CASE 1 and 5 to call fu_savecase ()
//  11/15/01 M. Caruso   Changed CASE 2 to prompt on changes instead of auto-saving.
//  03/06/02 M. Caruso   Changed Case 7 to call fu_ResetUpdateUOW for NewModified! records
//								 instead of fu_Delete.
//  03/15/02 M. Caruso   Added code to refresh the data in the case details and case properties
//								 datawindows on the case tab after a save.
//  04/02/02 M. Caruso   Added code to refresh the data in the case note entry datawindow on
//								 the case tab after a save.
//*********************************************************************************************

BOOLEAN			l_bRefreshDetails, l_bRefreshNotes, l_bRefreshProperties
INT				l_nReturn, l_nTest, l_nSaveStatus
LONG				l_nRow, l_nRows[], l_nCaseNoteID
STRING			l_nCaseType, l_sCaseNumber, l_sMessage
DWITEMSTATUS	l_Status
U_DW_STD			l_dwCaseDetails, l_dwCaseNoteEntry, l_dwCaseProperties, l_dwMatchedRecords
U_DW_STD			l_dwContactNote, l_dwDocDetails, l_dwSearch

l_nCaseType = i_cCaseType
l_nTest = dw_folder.i_SelectedTab
CHOOSE CASE dw_folder.i_SelectedTab 
	
	CASE 1
		// set the Selected case value if a case search was performed
		l_dwSearch = uo_search_criteria.uo_matched_records.dw_matched_records
		IF l_dwSearch.Dataobject = 'd_matched_cases' THEN
			
			IF l_dwSearch.RowCount () > 0 THEN
				i_cSelectedCase = l_dwSearch.GetItemString (l_dwSearch.i_CursorRow, 'case_number')
			END IF
			
		END IF
		
		IF i_bNeedCaseSubject AND NOT i_bNewCaseSubject THEN
			CHOOSE CASE i_cCaseType
				CASE i_cConfigCaseType, i_cInquiry, i_cIssueConcern
					l_nReturn = i_uoCaseDetails.fu_SaveCase (i_uoCaseDetails.c_SaveChanges)	
					IF l_nReturn = i_uoCaseDetails.c_Fatal THEN
						RETURN -1 
					ELSE
						RETURN 0
					END IF

				CASE ELSE
					RETURN 0

			END CHOOSE
		ELSE
			RETURN 0
		END IF

	CASE 2

		IF i_uoDemographics.dw_demographics.DataObject = 'd_demographics_other' THEN
			l_nReturn = i_uoDemographics.dw_demographics.fu_Save(c_PromptChanges)
// CJ don't want to set to TRUE here.  SCR 754)				
//				i_bNewProactive = TRUE	

			IF l_nReturn = i_uoDemographics.dw_demographics.c_Fatal THEN
				RETURN -1 
			ELSE
				RETURN 0
			END IF
		ELSE
			RETURN 0
		END IF

	CASE 3					// Notes Tab
		IF IsValid( i_uoContactNotes ) THEN
			// check if a contact note needs to be saved.
			l_dwContactNote = i_uoContactNotes.dw_contact_note
			l_dwContactNote.AcceptText( )
			l_Status = l_dwContactNote.GetItemStatus( 1, 0, Primary! )
			CHOOSE CASE l_status
				CASE NewModified!, DataModified!
					// prompt to save the current note.
					l_nReturn = MessageBox( gs_appname, &
													'The current contact note has unsaved changes.  Save it now?', &
													Question!, YesNoCancel! )
					CHOOSE CASE l_nReturn
						CASE 1
							// save the note
							i_uoContactNotes.cb_save.Event Trigger clicked( )
							
							IF dw_folder.i_TabError = -1 THEN
								RETURN -1
							ELSE
								RETURN 0
							END IF
							
						CASE 2
							// ignore the changes and continue
							l_dwContactNote.fu_ResetUpdate( )
							RETURN 0
							
						CASE 3
							// cancel the tab switch
							RETURN -1
							
					END CHOOSE
				CASE ELSE
					RETURN 0
					
			END CHOOSE
		END IF
		
	CASE 4					// Contact History Tab
		// nothing needs to be done because no editing is allowed on this screen.
		RETURN 0
		
	CASE 5					// Case Tab
		// determine which of the datawindows has changed, if any, ingoring case note entry
		l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
		l_dwCaseProperties = i_uoCaseDetails.tab_folder.tabpage_case_properties.dw_case_properties
		l_dwCaseNoteEntry = i_uoCaseDetails.dw_case_note_entry
		
		l_dwCaseDetails.AcceptText ()
		l_Status = l_dwCaseDetails.GetItemStatus (l_dwCaseDetails.i_CursorRow, 0, Primary!)
		IF l_Status = DataModified! THEN
			l_bRefreshDetails = TRUE
		ELSE
			l_bRefreshDetails = FALSE
		END IF
		
		l_dwCaseProperties.AcceptText ()
		l_Status = l_dwCaseProperties.GetItemStatus (l_dwCaseProperties.i_CursorRow, 0, Primary!)
		IF l_Status = DataModified! THEN
			l_bRefreshProperties = TRUE
		ELSE
			l_bRefreshProperties = FALSE
		END IF
		
		l_dwCaseNoteEntry.AcceptText ()
		l_Status = l_dwCaseNoteEntry.GetItemStatus (l_dwCaseNoteEntry.i_CursorRow, 0, Primary!)
		IF l_Status = NewModified! OR l_Status = DataModified! THEN
			l_bRefreshNotes = TRUE
		ELSE
			l_bRefreshNotes = FALSE
		END IF
		
		// process the saving of any changes
		l_nSaveStatus = i_uoCaseDetails.fu_SaveCase (i_uoCaseDetails.c_PromptChanges)
		
		IF l_nSaveStatus = 0 THEN
			
			i_uoCaseDetails.SetRedraw (FALSE)
			
			// refresh any datawindow that had been updated
			IF l_bRefreshDetails THEN
				l_dwCaseDetails.fu_retrieve (l_dwCaseDetails.c_ignorechanges, l_dwCaseDetails.c_noreselectrows)
			END IF
			IF l_bRefreshProperties THEN
				l_dwCaseProperties.fu_retrieve (l_dwCaseProperties.c_ignorechanges, l_dwCaseProperties.c_noreselectrows)
			END IF
			IF l_bRefreshNotes THEN
				l_nCaseNoteID = l_dwCaseNoteEntry.GetItemNumber (l_dwCaseNoteEntry.i_CursorRow, 'note_id')
				IF IsNull (l_nCaseNoteID) THEN
					PCCA.Parm[1] = '-1'
				ELSE
					PCCA.Parm[1] = STRING (l_nCaseNoteID)
				END IF
				l_dwCaseNoteEntry.fu_retrieve (l_dwCaseNoteEntry.c_ignorechanges, l_dwCaseNoteEntry.c_noreselectrows)
			END IF
			
			i_uoCaseDetails.SetRedraw (TRUE)
			
		END IF
		
		RETURN l_nSaveStatus
		
	CASE 6					// Cross Reference Tab
		// to be coded when this screen is defined...
		RETURN 0

	CASE 7				// Correspondence Tab

		l_dwDocDetails = i_uocasecorrespondence.dw_correspondence_detail
		l_dwDocDetails.AcceptText ()
		l_nRow = l_dwDocDetails.GetRow()
		l_Status = l_dwDocDetails.GetItemStatus(l_nRow, 0, Primary!)
		CHOOSE CASE l_Status
			CASE NewModified!
				l_sMessage = "This new correspondence item has not been saved.~r~n" + &
								 "Do you wish to save this item before continuing?"
								 
			CASE DataModified!
				l_sMessage = "Do you want to save your changes before continuing?"
				
			CASE ELSE
				l_sMessage = ""
				
		END CHOOSE
		
		IF l_sMessage = "" THEN       // The  Do does not need to be saved.
			RETURN 0
		ELSE                          // Prompt the user to save changes.
			l_nReturn = MessageBox (gs_AppName, l_sMessage, Information!,YesNoCancel!)
			CHOOSE CASE l_nReturn
				CASE 1
					// save the case as requested			
					l_nReturn = l_dwDocDetails.fu_Save (l_dwDocDetails.c_SaveChanges)
					i_bNewProactive = TRUE				
		
					IF l_nReturn = l_dwDocDetails.c_Fatal THEN
						RETURN -1 
					ELSE
						RETURN 0
					END IF
					
				CASE 2
					CHOOSE CASE l_Status
						CASE New!
							l_nRows[1] = l_nRow
							l_dwDocDetails.fu_Delete (1, l_nRows[], c_IgnoreChanges)
					
						CASE NewModified!, DataModified!
							l_dwDocDetails.fu_ResetUpdateUOW ()
					END CHOOSE
					RETURN 0
					
				CASE 3
					RETURN -1
					
			END CHOOSE
		END IF
		
	CASE 8					// Reminders Tab
		i_uoCaseReminders.dw_case_reminder.AcceptText ()
		l_nRow = i_uoCaseReminders.dw_case_reminder.GetRow ()
		l_Status = i_uoCaseReminders.dw_case_reminder.GetItemStatus (l_nRow, 0, Primary!)
		CHOOSE CASE l_Status
			CASE NewModified!
				l_sMessage = "This new reminder has not been saved. Do you~r~n" + &
								 "wish to save this reminder before continuing?"
								 
			CASE DataModified!
				l_sMessage = "Do you want to save your changes before continuing?"
				
			CASE ELSE
				l_sMessage = ""
				
		END CHOOSE
		
		IF l_sMessage = "" THEN       // The  Do does not need to be saved.
			RETURN 0
		ELSE                          // Prompt the user to save changes.
			l_nReturn = MessageBox (gs_AppName,l_sMessage, Information!,YesNoCancel!)
			CHOOSE CASE l_nReturn
				CASE 1
					// save the case as requested			
					l_nReturn = i_uoCaseReminders.dw_case_reminder.fu_Save ( &
									i_uoCaseReminders.dw_case_reminder.c_SaveChanges)
					i_bNewProactive = TRUE				
		
					IF l_nReturn = i_uoCaseReminders.dw_case_reminder.c_Fatal THEN
						RETURN -1 
					ELSE
						RETURN 0
					END IF
					
				CASE 2
					CHOOSE CASE l_Status
						CASE New!, NewModified!
							l_nRows[1] = l_nRow
							i_uoCaseReminders.dw_case_reminder.fu_Delete (1, l_nRows[], c_IgnoreChanges)
					
						CASE DataModified!
							i_uoCaseReminders.dw_case_reminder.fu_ResetUpdateUOW ()
					END CHOOSE
					RETURN 0
					
				CASE 3
					RETURN -1
					
			END CHOOSE
			
		END IF

END CHOOSE
 
end function

public subroutine fw_contactperson ();//*******************************************************************************************
//
//	 Function:	fw_contactperson
//	 Purpose:		To establish a contact person for a case subject.
//	 Parameters:	None
//	 Returns:		None
//	
//	 Date     Developer     Description
//	 ======== ============= =============================================================
//	 10/17/00 M. Caruso     Modified to work with the new Case Detail setup.
//	 02/27/02 C. Jackson    Change logic for opening w_contact_person to work with new design
//  03/04/02 C. Jackson    Only disply error message if there are *no* relationships, not
//                         if there is one.  (SCR 2789)
//  4/16/2002 K. Claver    Removed the -1 parameter from call to fu_OpenWindow as the contact
//									person window is a response window.
//  5/20/2002 K. Claver    Moved update to case log to the contact person window.
//*******************************************************************************************

INT		l_nRowCount
STRING	l_cSourceDesc, l_cContactPerson, l_cRelationship, l_cFirstName, l_cLastName
String   l_cContactID, l_cCurrContact, l_cUpdateUser, l_cChangeFlag
u_dw_std l_dwCaseDetails
Boolean  l_bUpdateContact = FALSE
DateTime l_dtUpdateDate

SetPointer (HOURGLASS!)
l_dtUpdateDate = THIS.fw_GetTimeStamp( )
l_cUpdateUser = OBJCA.WIN.fu_GetLogin( SQLCA )

CHOOSE CASE i_cSourceType
	CASE i_cSourceConsumer
		l_cSourceDesc = 'Consumer'
	CASE i_cSourceEmployer
		l_cSourceDesc = 'Employer'
	CASE i_cSourceProvider
		l_cSourceDesc = 'Provider'
	CASE i_cSourceOther
		l_cSourceDesc = 'Other'
END CHOOSE

SELECT Count(*) INTO :l_nRowCount FROM cusfocus.relationships WHERE 
		source_type =:i_cSourceType AND active = 'Y';

IF l_nRowCount = 0 THEN
	CHOOSE CASE l_cSourceDesc
		CASE 'Other', 'Employer'
			MessageBox(gs_AppName, 'There are no Relationships established for an ' + l_cSourceDesc + ' Source Type.  Contact your System' + &
				' Administrator to add additional Relationships.')
		CASE 'Consumer', 'Provider'
			MessageBox(gs_AppName, 'There are no Relationships established except for a ' + l_cSourceDesc + ' Source Type.  Contact your System' + &
				' Administrator to add additional Relationships.')
	END CHOOSE
	RETURN
END IF

PCCA.Parm[1] = i_cCurrentCase
PCCA.Parm[2] = i_cSourceType

FWCA.MGR.fu_OpenWindow(w_contact_person)

l_cChangeFlag = Message.StringParm

//If the primary contact has changed or has been deleted, need to refresh the case
//  details datawindow.
IF l_cChangeFlag = "CHANGED" THEN
	l_dwCaseDetails = THIS.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
	l_dwCaseDetails.fu_Retrieve( l_dwCaseDetails.c_SaveChanges, l_dwCaseDetails.c_NoReselectRows )		
END IF
end subroutine

public subroutine fw_clearcaselocks ();/*****************************************************************************************
   Function:   fw_ClearCaseLocks
   Purpose:    Unlock all cases for the current user
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/11/2002 K. Claver    Created.
*****************************************************************************************/
String unlock_proc_odbc, unlock_proc_native
Boolean l_bAutoCommit
String l_cCurrentUser

l_cCurrentUser = OBJCA.WIN.fu_GetLogin( SQLCA )

l_bAutoCommit = SQLCA.AutoCommit
SQLCA.AutoCommit = FALSE

IF SQLCA.DBMS = "ODBC" THEN
	DECLARE unlock_proc_odbc PROCEDURE FOR cusfocus.sp_clear_case_locks( :l_cCurrentUser )
	USING SQLCA;
	
	EXECUTE unlock_proc_odbc;
ELSE
	DECLARE unlock_proc_native PROCEDURE FOR cusfocus.sp_clear_case_locks
	@unlock_user_id = :l_cCurrentUser
	USING SQLCA;
	
	EXECUTE unlock_proc_native;
END IF

IF SQLCA.SQLCode = -1 THEN
	MessageBox( gs_AppName, "Error executing stored procedure to remove case locks for the user.~r~n"+ &
					"Error Returned:~r~n"+SQLCA.SQLErrText, StopSign!, OK! )
END IF

SQLCA.AutoCommit = l_bAutoCommit
end subroutine

public function integer fw_linkcase ();/**************************************************************************************
	Function:	fw_linkcase
	Purpose:		To link a case to another on the case history tab.
	Parameters:	None
	Returns:		l_nReturn - Result of the save operation.  0 - Success.  -1 - Failure.
	
	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	6/11/2001 K. Claver    Changed to use new begin "call" and end "call" rules.
	3/12/2002 K. Claver    Added code to check if the case is locked before allowing to link
	9/26/2002 K. Claver    Moved resetting of autocommit value to inside the if-then that
								  sets it to false to ensure that it is only reset if initially
								  set.
**************************************************************************************/

Integer l_nReturn = 0, l_nRow, l_nDisable, l_nLevel
//u_dw_std l_dwCaseHistory
u_datawindow l_dwCaseHistory
Boolean l_bAutoCommit
String l_cCaseMasterNum, l_cCaseNum, l_cCaseRep

//If linking is enabled, set the master case number and save.
IF THIS.i_bLinked THEN
	IF IsValid( i_uoContactHistory ) THEN
		l_dwCaseHistory = i_uoContactHistory.uo_search_contact_history.dw_report
		l_nRow = i_uoContactHistory.uo_search_contact_history.il_row
		
		IF l_nRow > 0 THEN
			//Check security
			l_nLevel = l_dwCaseHistory.Object.confidentiality_level[ l_nRow ]
			l_cCaseRep = l_dwCaseHistory.Object.case_log_case_log_case_rep[ l_nRow ]
			IF (l_nLevel <= THIS.i_nRepConfidLevel) OR &
				(l_cCaseRep = OBJCA.WIN.fu_GetLogin(SQLCA)) THEN			
			
				l_cCaseNum = l_dwCaseHistory.Object.case_number[ l_nRow ]
				
				//Check if the case is currently locked
				IF i_uoContactHistory.fu_CheckLocked( l_cCaseNum ) THEN
					RETURN -1
				END IF
				
				IF IsNull( THIS.i_cLinkMasterCase ) OR Trim( THIS.i_cLinkMasterCase ) = "" THEN
					//This is the link master case
					THIS.i_cLinkMasterCase = l_cCaseNum
					RETURN l_nReturn
				END IF
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// JWhite 5.17.2005 Set the Master Case to null if it is "Not Linked"
				//-----------------------------------------------------------------------------------------------------------------------------------
				If lower(this.i_cCurrCaseMasterNum) = 'not linked' Then SetNull(this.i_cCurrCaseMasterNum)
				
				//Only process if on a new case.
				IF l_cCaseNum <> THIS.i_cLinkMasterCase THEN			
					IF IsNull( THIS.i_cCurrCaseMasterNum ) OR Trim( THIS.i_cCurrCaseMasterNum ) = "" OR Lower( THIS.i_cCurrCaseMasterNum ) = "not linked" THEN
						THIS.i_cCurrCaseMasterNum = THIS.fw_GetKeyValue( 'case_log_master_num' )
					END IF
					
					//Save the current autocommit value
					l_bAutoCommit = SQLCA.AutoCommit
					SQLCA.AutoCommit = FALSE
					
					//Set the master case number and save.
					l_dwCaseHistory.Object.case_log_master_case_number[ l_nRow ] = THIS.i_cCurrCaseMasterNum			
					//l_nReturn = l_dwCaseHistory.fu_Save( l_dwCaseHistory.c_SaveChanges )
	
					Update	cusfocus.case_log				
					SET cusfocus.case_log.master_case_number = :THIS.i_cCurrCaseMasterNum
					WHERE cusfocus.case_log.case_number = :l_cCaseNum
					USING SQLCA;
					
					
					IF l_nReturn = 0 THEN
						//Increment the case counter if case link warning is enabled
						IF THIS.i_cLinkWarnEnabled = "Y" THEN
							THIS.i_nCaseLinkCount ++
						END IF
						
						//Check if the link master case already has the master case number.  If not, 
						//  update the field to reflect the link
						SELECT cusfocus.case_log.master_case_number
						INTO :l_cCaseMasterNum
						FROM cusfocus.case_log
						WHERE cusfocus.case_log.case_number = :THIS.i_cLinkMasterCase
						USING SQLCA;
						
						IF IsNull( l_cCaseMasterNum ) OR Trim( l_cCaseMasterNum ) = "" OR Lower( l_cCaseMasterNum ) = "not linked" THEN
							UPDATE cusfocus.case_log
							SET cusfocus.case_log.master_case_number = :THIS.i_cCurrCaseMasterNum
							WHERE cusfocus.case_log.case_number = :THIS.i_cLinkMasterCase
							USING SQLCA;
							
							IF SQLCA.SQLCode <> 0 THEN
								ROLLBACK USING SQLCA;
								MessageBox( gs_AppName, "Unable to set the link for the first case number in the link", StopSign!, OK! )
								l_nReturn = -1
							ELSE
								
								//Copy xref and case properties if the source and case types are the same.
								
								/**** It was decided to only copy xref and case properties when linking ****/
								/****	newly created cases 															   ****/
								
							END IF
						ELSE
							IF l_cCaseMasterNum <> THIS.i_cCurrCaseMasterNum THEN
								ROLLBACK USING SQLCA;
								MessageBox( gs_AppName, "Case already linked to master case number "+l_cCaseMasterNum, StopSign!, OK! )
								l_nReturn = -1
							END IF
						END IF
						
						IF l_nReturn = 0 THEN
							//Commit the changes
							COMMIT USING SQLCA;
						END IF
					ELSE
						ROLLBACK USING SQLCA;
						MessageBox( gs_AppName, "Error setting the master case number for this case", StopSign!, OK! )
						l_nReturn = -1
					END IF
				
					IF l_nReturn = 0 THEN
						//Enable the remove link menu item
						m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
					END IF
					
					//Reset the autocommit value
					SQLCA.AutoCommit = l_bAutoCommit		
				ELSE
					MessageBox( gs_AppName, "Case Number "+l_cCaseNum+" is the first linked case.~r~n"+ &
									"Please choose a case to link it to.", StopSign!, OK! )
									
					l_nReturn = -1
				END IF
			ELSE
				//Not the right security level
				MessageBox( gs_AppName,'You do not have the necessary permissions to edit this case.', StopSign!, OK! )
				l_nReturn = -1
			END IF
		END IF
		
		//Re-retrieve the case history datawindow as changes may have been made to another
		//  case in the datawindow.
		//l_dwCaseHistory.fu_Retrieve( l_dwCaseHistory.c_IgnoreChanges, l_dwCaseHistory.c_ReselectRows )
		i_uoContactHistory.of_retrieve()
	END IF
END IF

//Check to see if the cases linked is greater than the maximum set.  If so
//  display a message for the user.
IF THIS.i_cLinkWarnEnabled = "Y" THEN
	IF THIS.i_nCaseLinkMax > 0 AND THIS.i_nCaseLinkMax <= THIS.i_nCaseLinkCount THEN
		l_nDisable = MessageBox( gs_AppName, "You have linked "+String( THIS.i_nCaseLinkCount )+" cases.~r~n"+ &
		                         "Continue linking?", Question!, YesNo! )
										 
		IF l_nDisable = 2 THEN
			THIS.fw_ToggleLinking( )
		END IF
	END IF
END IF

RETURN l_nReturn
end function

public subroutine fw_togglelinking ();/**************************************************************************************
	Function:	fw_ToggleLinking
	Purpose:		To begin or end the case linking.
	Parameters:	None
	Returns:		None
	
	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	6/11/2001 K. Claver    Original Version.
**************************************************************************************/

Integer			l_nLevel, l_nRow
U_DW_STD			l_dwCaseDetails
u_datawindow	l_dwCaseHistory
String   		l_cCaseRep, l_cCaseNumber

//Toggle the icons
IF NOT THIS.i_bLinked THEN
	//Begin linking
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.ToolBarItemName = "linkcase green.ico"
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.Text = "End &Link"
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.MicroHelp = "End Case Linking"
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.ToolBarItemText = "End Case Linking" 
	m_create_maintain_case.m_file.m_newcase.m_inquiry.ToolBarItemName = "green q.ico"
	m_create_maintain_case.m_file.m_newcase.m_issueconcern.ToolBarItemName = "green i.ico"
	m_create_maintain_case.m_file.m_newcase.m_configcasetype.ToolBarItemName = "green c.ico"
	m_create_maintain_case.m_file.m_newcase.m_proactive.ToolBarItemName = "green p.ico"
	
	//Set the variable to show linking has started
	THIS.i_bLinked = TRUE
	
	//Check for a current case master number
	IF dw_folder.i_SelectedTab = 4 THEN
		IF IsValid( i_uoContactHistory ) THEN
			//Get the selected row
			l_dwCaseHistory = i_uoContactHistory.uo_search_contact_history.dw_report		
			l_nRow = i_uoContactHistory.uo_search_contact_history.il_row
			
			IF l_nRow > 0 THEN
				//Check rep security
				l_nLevel = l_dwCaseHistory.Object.confidentiality_level[ l_nRow ]
				l_cCaseRep = l_dwCaseHistory.Object.case_log_case_log_case_rep[ l_nRow ]
				l_cCaseNumber = l_dwCaseHistory.Object.case_number[ l_nRow ]
				IF ((l_nLevel <= THIS.i_nRepConfidLevel) OR &
					(l_cCaseRep = OBJCA.WIN.fu_GetLogin(SQLCA))) AND &
					NOT i_uoContactHistory.fu_CheckLocked( l_cCaseNumber ) THEN
				
					//Set the current case master number and other instance variables.
					THIS.i_cCurrCaseMasterNum = l_dwCaseHistory.Object.case_log_master_case_number[ l_nRow ]
					THIS.i_cLinkMasterCase = l_cCaseNumber
					THIS.i_cSelectedCase = l_dwCaseHistory.Object.case_number[ l_nRow ]
					THIS.i_cCaseType = l_dwCaseHistory.Object.case_type[ l_nRow ]
					THIS.i_cLinkLastCaseType = THIS.i_cCaseType
					THIS.i_cLinkLastSourceType = THIS.i_cSourceType
					
					//Enable the link case popup menu item.
					m_create_maintain_case.m_edit.m_linkcase.Enabled = TRUE
					
					//Increment the case counter if case link warning is enabled
					IF THIS.i_cLinkWarnEnabled = "Y" THEN
						THIS.i_nCaseLinkCount ++
					END IF
				ELSE
					IF NOT THIS.i_bCaseLocked THEN
						//Disable the link case popup menu item.
						m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
						
						messagebox( gs_AppName,'You do not have the necessary permissions to edit this case.', StopSign!, OK! )
					END IF
					
					RETURN
				END IF
			END IF
		END IF
	ELSEIF dw_folder.i_SelectedTab = 5 THEN
		IF IsValid( i_uoCaseDetails ) THEN
			l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details	
			
			IF l_dwCaseDetails.RowCount( ) > 0 THEN
				IF NOT i_uoCaseDetails.tab_folder.tabpage_case_details.fu_CheckLocked( ) THEN 
					THIS.i_cLinkMasterCase = l_dwCaseDetails.Object.case_log_case_number[ 1 ]
					THIS.i_cCurrCaseMasterNum = l_dwCaseDetails.Object.case_log_master_case_number[ 1 ]
					THIS.i_cLinkLastCaseType = THIS.i_cCaseType
					THIS.i_cLinkLastSourceType = THIS.i_cSourceType
					
					//Increment the case counter if case link warning is enabled
					IF THIS.i_cLinkWarnEnabled = "Y" THEN
						THIS.i_nCaseLinkCount ++
					END IF
				END IF
			END IF
		END IF
	END IF	
ELSE
	//End linking
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.ToolBarItemName = "linkcase red.ico"
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.Text = "Begin &Link"
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.MicroHelp = "Begin Case Linking"
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.ToolBarItemText = "Begin Case Linking" 
	m_create_maintain_case.m_file.m_newcase.m_inquiry.ToolBarItemName = "red q.ico"
	m_create_maintain_case.m_file.m_newcase.m_issueconcern.ToolBarItemName = "red i.ico"
	m_create_maintain_case.m_file.m_newcase.m_configcasetype.ToolBarItemName = "red c.ico"
	m_create_maintain_case.m_file.m_newcase.m_proactive.ToolBarItemName = "red p.ico"
	
	IF IsValid( i_uoContactHistory ) THEN
		//Disable the link case menu item
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
	END IF
	
	//Reset the counter instance variable
	THIS.i_nCaseLinkCount = 0
	
	//Reset the linking variables
	SetNull( THIS.i_cLinkMasterCase )
	SetNull( THIS.i_cCurrCaseMasterNum )
	
	//Set the variable to show linking has ended
	THIS.i_bLinked = FALSE	
END IF

i_blinked = i_bLinked
end subroutine

public subroutine fw_newsearch ();/**************************************************************************************
	Function:		fw_newsearch
	Purpose:			To clear the search criteria for a new search
	Parameters:		None
	Returns:			None
	
	Revisions:
	Date     Developer     Description
	======== ============= ============================================================
	01/13/01 M. Caruso     Added disable commands for all tabs except Tab 1.
*************************************************************************************/

//------------------------------------------------------------------------------------
//		
//		Make sure the current tab is the Search criteria.
//
//------------------------------------------------------------------------------------

i_cCurrentCaseSubject = ''
i_cCaseSubjectName = ''
i_cCurrentCase = ''
i_cSelectedCase = ''
Title = Tag

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 2.15.2005	Reset the Search to the original syntax and insert a row
//-----------------------------------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------------------------------
// RAP Taken out 4.9.07
// RAP Why? Put back in 8/3/07, the case properties have to be removed
//-----------------------------------------------------------------------------------------------------------------------------------
If gs_seachtype = "CASE" Then 
	uo_search_criteria.of_reset_criteria()
End If
//-----------------------------------------------------------------------------------------------------------------------------------
// RAP Put in 7/24/07 to handle hierarchical dddws
//-----------------------------------------------------------------------------------------------------------------------------------
If gs_seachtype = "APPEAL" Then 
	uo_search_criteria.of_reset_criteria()
End If

//-------------------------------------------------------------------------------------
//
//		Clear the Search Criteria
//
//-------------------------------------------------------------------------------------


uo_search_criteria.uo_matched_records.dw_matched_records.Reset()
uo_search_criteria.dw_search_criteria.fu_Reset()

IF dw_folder.i_SelectedTab <> 1 THEN
	dw_folder.fu_SelectTab(1)
END IF

dw_folder.fu_DisableTab(2)
dw_folder.fu_DisableTab(3)
dw_folder.fu_DisableTab(4)
dw_folder.fu_DisableTab(5)
dw_folder.fu_DisableTab(6)
dw_folder.fu_DisableTab(7)
dw_folder.fu_DisableTab(8)

uo_search_criteria.dw_search_criteria.SetFocus()


end subroutine

public subroutine fw_reassigncasesubject ();/****************************************************************************************
	Function:	fw_reassigncasesubject
	Purpose:		To reassing an "Other Source" type to a Consumer, Employer or 
					Provider.
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	12/28/00 M. Caruso     Modified the code that determines what happens based on the
								  selected tab.  It now propts to move all on tab 4
								  (Contact History) and prompts to move the selected case on tab
								  5 (Case Details).
	01/10/01 M. Caruso     Modified to call fu_savecase ().
	07/27/01 M. Caruso     Pass i_nRepRecConfidLevel to the Reassign window. 
	08/01/01 K. Claver     Changed the provider_of_service query to search on provider_key
								  and convert the value in the current case subject variable to
								  an int.
	05/20/02 M. Caruso     Validate case notes, case details and case properties before
								  allowing the reassignment process to start.
	05/23/02 M. Caruso     Ensure that New! case properties records are validated before
								  allowing the reassignment process to start.
	06/26/02 M. Caruso     Allow for the removal of the Other Source record if the case
								  being reassigned from the Case tab is the only case for that
								  subject.
	06/27/02 M. Caruso     Added code to set focus to the properties tab before validation.
	02/04/03 M. Caruso     Modified code to check before deleting the Other source record.
	02/13/03 M. Caruso     Utilized existing local variables to track return values from
								  the Reassignment window in subsequent code.
****************************************************************************************/	

CONSTANT	INTEGER	l_nCasePropertiesTab = 3

BOOLEAN 	l_bAllCases, l_bContinue
INTEGER	l_nCaseCount, l_nCurrentTab, l_nIndex
LONG		l_nRow
STRING 	l_cOldCaseSubject, l_cNewCaseSubject, l_cNewSourceType, l_cProviderType
STRING	l_cCaseType, l_cCasePropsOptions, l_cDeleteOther, l_cSearchType, l_cKeyField
STRING	l_cSubjectID, l_cVendorID
U_DW_STD	l_dwCaseDetails, l_dwCaseProperties, l_dwCaseNotes

l_cOldCaseSubject = i_cCurrentCaseSubject
SetPointer(HOURGLASS!)

CHOOSE CASE dw_folder.i_SelectedTab
	CASE 4		//	Contact History Tab
		l_bAllCases = TRUE
		PCCA.Parm[1] = 'Y'
		
	CASE 5	//	Case Detail Tab
		// create datawindow references
		l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
		l_dwCaseProperties = i_uoCaseDetails.tab_folder.tabpage_case_properties.dw_case_properties
		l_dwCaseNotes = i_uoCaseDetails.dw_case_note_entry
		
		l_cCasePropsOptions = i_uoCaseDetails.tab_folder.tabpage_case_properties.i_cCasePropsOptions
		
		// ensure the current case is valid before continuing.
//RAP - took out the validations here because the case has
//			to be saved before this option is available and these validations
//			check the text attribute of the DW, so they aren't valid at this point
//		l_bContinue = FALSE
//		IF l_dwCaseDetails.fu_validate () = 0 THEN
		l_bContinue = TRUE
//		IF l_dwCaseDetails.fu_validate () = 0 THEN
			// do not ignore new rows for this validation
			l_dwCaseProperties.fu_ChangeOptions (l_cCasePropsOptions + l_dwCaseProperties.c_NoIgnoreNewRows)
			
			// switch to the case properties tab to ensure proper validation of required fields
			i_uoCaseDetails.tab_folder.SetRedraw (FALSE)
			l_nCurrentTab = i_uoCaseDetails.tab_folder.SelectedTab
			IF l_nCurrentTab <> l_nCasePropertiesTab THEN
				i_uoCaseDetails.tab_folder.SelectTab (l_nCasePropertiesTab)
				l_dwCaseProperties.SetFocus ()
			END IF
//			IF l_dwCaseProperties.fu_validate () = 0 THEN
//				IF l_dwCaseNotes.fu_validate () = 0 THEN
					
					SELECT count(case_number) INTO :l_nCaseCount
					  FROM cusfocus.case_log
					 WHERE case_subject_id = :l_cOldCaseSubject AND source_type =:i_cSourceOther
					 USING SQLCA;
					
					IF SQLCA.SQLCODE = 0 THEN
					
						// process based on the number of records assigned to this subject.
//?? make it do this regardless?						IF l_nCaseCount = 1 THEN
						IF l_nCaseCount > 0 THEN
							
							l_bAllCases = TRUE
							PCCA.Parm[1] = 'Y'
							
						ELSE
						
							l_bAllCases = FALSE
							PCCA.Parm[1] = 'N'
							
						END IF
						
					ELSE
						
						// assume more than one case is assigned to this subject.
						l_bAllCases = FALSE
						PCCA.Parm[1] = 'N'
						
					END IF
						
					l_bContinue = TRUE
					
//				END IF
//			END IF
			// resume ignoring new rows for this datawindow
			l_dwCaseProperties.fu_ChangeOptions (l_cCasePropsOptions + l_dwCaseProperties.c_IgnoreNewRows)
			IF i_uoCaseDetails.tab_folder.SelectedTab <> l_nCurrentTab THEN
				i_uoCaseDetails.tab_folder.SelectTab (l_nCurrentTab)
			END IF
			i_uoCaseDetails.tab_folder.SetRedraw (TRUE)
			
//		END IF
		
		// cancel processing if the case is not complete.
		IF NOT l_bContinue THEN RETURN
		
	CASE ELSE
		RETURN
		
END CHOOSE

PCCA.Parm[2] = STRING (i_nRepRecConfidLevel)

// display the selection window.
FWCA.MGR.fu_OpenWindow(w_reassign_case_subject, 0)

// get the values returned from the selection window.
l_cNewCaseSubject = PCCA.Parm[1] 
l_cNewSourceType = PCCA.Parm[2]
l_cProviderType = PCCA.Parm[3]
l_cDeleteOther = PCCA.Parm[4]

// if either of the values are blank, the user chose cancel.
IF l_cNewCaseSubject = '' OR l_cNewSourceType = '' THEN
	RETURN 
END IF

// update instance variables.
i_cCurrentCaseSubject = l_cNewCaseSubject
i_cSourceType = l_cNewSourceType
	
CHOOSE CASE i_cSourceType

	CASE i_cSourceConsumer
		STRING l_cFirstName, l_cLastName

		SetNull (l_cProviderType)
		SELECT consum_first_name, consum_last_name INTO :l_cFirstName, :l_cLastName FROM
			cusfocus.consumer WHERE consumer_id =:i_cCurrentCaseSubject;

		i_cCaseSubjectName = l_cLastName + ', ' + l_cFirstName	
		
	CASE i_cSourceEmployer
		SetNull (l_cProviderType)	
		SELECT employ_group_name INTO :i_cCaseSubjectName FROM cusfocus.employer_group WHERE
			group_id =:i_cCurrentCaseSubject;
		
	CASE i_cSourceProvider
		SELECT IsNull(provid_name, provid_name_2) INTO :i_cCaseSubjectName FROM cusfocus.provider_of_service WHERE
				provider_key = Convert( int, :i_cCurrentCaseSubject );

END CHOOSE

IF l_bAllCases THEN
	// update all related cases
	UPDATE cusfocus.case_log 
		SET case_subject_id = :i_cCurrentCaseSubject,
			 source_type = :i_cSourceType,
			 source_name = :i_cCaseSubjectName,
			 source_provider_type = :l_cProviderType
		WHERE case_subject_id =:l_cOldCaseSubject AND source_type =:i_cSourceOther;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox(String(SQLCA.SQLDBCode), SQLCA.SQLERRText)
		ROLLBACK;
	ELSE
		// update all cases cross-referencing the other source
		UPDATE cusfocus.case_log 
			SET xref_subject_id = :i_cCurrentCaseSubject,
				 xref_source_type = :i_cSourceType,
				 xref_provider_type = :l_cProviderType
			WHERE xref_subject_id =:l_cOldCaseSubject AND xref_source_type =:i_cSourceOther;
			
		IF SQLCA.SQLCODE <> 0 THEN
			MessageBox(String(SQLCA.SQLDBCode), SQLCA.SQLERRText)
			ROLLBACK;
		ELSE
			IF l_cDeleteOther = 'T' THEN
				// delete the Other source if specified
				DELETE FROM cusfocus.other_source WHERE customer_id =:l_cOldCaseSubject;
				
				IF SQLCA.SQLCode <> 0 THEN
					MessageBox (String (SQLCA.SQLDBCode), SQLCA.SQLErrText)
					ROLLBACK;
				ELSE
					COMMIT;
				END IF
			ELSE
				// commit without deleting the Other source record.
				COMMIT;
			END IF
		END IF

	END IF
	
ELSE
	// update the selected case
	IF IsValid (i_uoCaseDetails) THEN
		l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_case_subject_id', i_cCurrentCaseSubject)
		l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_source_type', i_cSourceType)
		l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_source_name', i_cCaseSubjectName)
		IF i_cSourceType = i_cSourceProvider THEN
			l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_source_provider_type', l_cProviderType)
		END IF
		
		i_uoCaseDetails.fu_SaveCase (i_uoCaseDetails.c_SaveChanges)
		
		// update the window title
		CHOOSE CASE i_cCaseType
			CASE i_cConfigCaseType
				l_cCaseType = gs_ConfigCaseType
				
			CASE i_cInquiry
				l_cCaseType = 'Inquiry'
				
			CASE i_cIssueConcern
				l_cCaseType = 'Issue/Concern'
				
			CASE i_cProactive
				l_cCaseType = 'Proactive'
				
		END CHOOSE
		
	END IF

END IF
i_bSearchCriteriaUpdate = FALSE

// store the selected subject ID

// finally, retrieve the demographics of the new case subject
// Switch to and reset the Search tab
fw_newsearch()

// Turn redraw off while reinitializing the Search tab
This.SetRedraw (TRUE)

CHOOSE CASE l_cNewSourceType
	CASE i_cSourceConsumer
		l_cSearchType = "Member"
		l_cKeyField = "consumer_id"
		l_cSubjectID = l_cNewCaseSubject
		
	CASE i_cSourceEmployer
		l_cSearchType = "Group"
		l_cKeyField = "group_id"
		l_cSubjectID = l_cNewCaseSubject
		
	CASE i_cSourceProvider
		l_cSearchType = "Provider"
		l_cKeyField = "provider_id"
		// retrieve the selected subject ID parts for searching
		SELECT provider_id, vendor_id
		  INTO :l_cSubjectID, :l_cVendorID
		  FROM cusfocus.provider_of_service
		 WHERE provider_key = convert(int, :l_cNewCaseSubject)
		 USING SQLCA;
		 
END CHOOSE

// Set up the search tab
uo_search_criteria.ddlb_search_type.SelectItem (l_cSearchType,0)
l_nIndex = uo_search_criteria.ddlb_search_type.FindItem (l_cSearchType,0)

uo_search_criteria.ddlb_search_type.Event Trigger selectionchanged( l_nIndex )

// Set the search criteria.
l_nRow = uo_search_criteria.dw_search_criteria.GetRow ()
uo_search_criteria.dw_search_criteria.SetItem (l_nRow, l_cKeyField, l_cSubjectID)
IF l_cSearchType = "Provider" THEN
	uo_search_criteria.dw_search_criteria.SetItem (l_nRow, "vendor_id", l_cVendorID)
	uo_search_criteria.dw_search_criteria.SetItem (l_nRow, "provider_type", l_cProviderType)
END IF
uo_search_criteria.dw_search_criteria.AcceptText ()

//l_cTempValue = uo_search_criteria.dw_search_criteria.GetItemString (l_nRow, l_cKeyField)

// Turn redraw back on before actually do search
This.SetRedraw (TRUE)

// Perform the search.  Added call to the Yield function as using the event
// to open a case from the Reminders tab on the Work Desk appeared to cause
// this event to be fired twice as a result of other processes not completing.
Yield()
m_create_maintain_case.m_file.m_search.Event Trigger clicked( )
end subroutine

public subroutine fw_validatedemographics ();//******************************************************************************************
//
//  Function: fw_validatedemographics
//  Purpose:  To swap datawindow and retrieve data
//
//  Date     Developer  Description 
//  -------- ---------- ------------------------------------------------------------------
//  05/04/99 RAE		   Made demographics dw retrieve upon creation.
//  07/16/99 M. Caruso  Added calls to i_uoDemographics.fu_displayfields().
//  07/30/99 M. Caruso  Added the c_NoMenuButtonActivation to all fu_setoptions calls to
//                      ensure that the datawindows do not alter the menu/toolbar settings.
//  04/04/00 M. Caruso  The code no longer tries to reselect previous rows after loading
//  							the case history data.  Also set focus to the case history screen
//							   each time this script runs.
//  04/24/00 M. Caruso  Adjusted the placement of the u_demographics on the folder.
//  07/06/00 C. Jackson Add c_ModifyOK and c_ModifyOnOpen for each of the datawindows for 
//                      Provider, Member, and Group to allow for copy and paste (SCR 689)
//  08/15/00 M. Caruso  The code updates the configurable fields list when it needs to
//                      change the dataobject of dw_demographics.
//	 09/28/00 M. Caruso  Removed all references to dw_case_history on uo_demographics. 
//  2/12/2002 K. Claver Removed code to set the boolean variable on the iim tab window to
//								indicate that the source has changed.
//******************************************************************************************

U_DW_STD		l_dwDemographics

CHOOSE CASE i_cSourceType
		
	//-------------------------------------------------------------------------------------		
	// Source Consumer --
	//-------------------------------------------------------------------------------------	
	CASE i_cSourceConsumer
		IF NOT IsValid(i_uoDemographics) THEN
			SetPointer(HOURGLASS!)
			SetRedraw(FALSE)
			OPENUSEROBJECT(i_uoDemographics,'u_demographics',	23, 104)
			i_uoDemographics.i_wParentWindow = THIS
			i_uoDemographics.BringToTop = TRUE
			i_uoDemographics.Border = FALSE
			i_woTabObjects[1] = i_uoDemographics
		   dw_folder.fu_assignTab(dw_folder.i_clickedtab, i_woTabObjects[])

			l_dwDemographics = i_uoDemographics.dw_demographics
			l_dwDemographics.fu_SetOptions( SQLCA, l_dwDemographics.c_NullDW, & 
 				i_ulDemographicsCW + i_ulDemographicsVW + &
				l_dwDemographics.c_ModifyOK + &
				l_dwDemographics.c_ModifyOnOpen + &
				l_dwDemographics.c_NoMenuButtonActivation ) 

			l_dwDemographics.SetRedraw (FALSE)
			IF l_dwDemographics.DataObject <> 'd_demographics_consumer' THEN
				fw_buildfieldlist ('C')
				l_dwDemographics.fu_Swap('d_demographics_consumer', &
					l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + i_ulDemographicsVW + &
					l_dwDemographics.c_ModifyOK + &
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NoMenuButtonActivation)
			END IF
			i_uoDemographics.fu_displayfields()
			l_dwDemographics.SetRedraw (TRUE)

 			// RAE  4/5/99				 
			l_dwDemographics.fu_Retrieve(l_dwDemographics.c_IgnoreChanges, l_dwDemographics.c_NoReselectRows)
		
			SetRedraw(TRUE)
		ELSE
			l_dwDemographics = i_uoDemographics.dw_demographics
			IF l_dwDemographics.DataObject <> 'd_demographics_consumer' THEN
				l_dwDemographics.SetRedraw (FALSE)
				fw_buildfieldlist ('C')
				l_dwDemographics.fu_Swap('d_demographics_consumer', &
	     			l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + i_ulDemographicsVW + &
					l_dwDemographics.c_ModifyOK + & 
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NoMenuButtonActivation)
				i_uoDemographics.fu_displayfields()
				l_dwDemographics.SetRedraw (TRUE)
			END IF
			
			// RAE 4/5/99  retrieve
			l_dwDemographics.fu_Retrieve(&
				l_dwDemographics.c_IgnoreChanges, &
				l_dwDemographics.c_ReselectRows)

		END IF
		
	//-------------------------------------------------------------------------------------		
	// Source Employer --		
	//-------------------------------------------------------------------------------------	
	CASE i_cSourceEmployer
		IF NOT IsValid(i_uoDemographics) THEN
			SetPointer(HOURGLASS!)
			SetRedraw(FALSE)
			OPENUSEROBJECT(i_uoDemographics, "u_demographics", 23, 104)
			i_uoDemographics.i_wParentWindow = THIS
			i_uoDemographics.BringToTop = TRUE
			i_uoDemographics.Border = FALSE

			i_woTabObjects[1] = i_uoDemographics
			dw_folder.fu_assignTab(dw_folder.i_clickedtab, i_woTabObjects[])

			l_dwDemographics = i_uoDemographics.dw_demographics
			l_dwDemographics.fu_SetOptions( SQLCA, & 
 				l_dwDemographics.c_NullDW, & 
 				i_ulDemographicsCW + i_ulDemographicsVW + &
				l_dwDemographics.c_ModifyOK + &
				l_dwDemographics.c_ModifyOnOpen + &
				l_dwDemographics.c_NoMenuButtonActivation ) 

			l_dwDemographics.SetRedraw (FALSE)
			IF l_dwDemographics.DataObject <> 'd_demographics_employer' THEN
				fw_buildfieldlist ('E')
				l_dwDemographics.fu_Swap('d_demographics_employer', &
				   l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + i_ulDemographicsVW + &
					l_dwDemographics.c_ModifyOK + &
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NoMenuButtonActivation)
			END IF
			i_uoDemographics.fu_displayfields()
			l_dwDemographics.SetRedraw (TRUE)

			// RAE 4/5/99
			l_dwDemographics.fu_Retrieve(&
				l_dwDemographics.c_IgnoreChanges, &
				l_dwDemographics.c_NoReselectRows)

			SetRedraw(TRUE)
		ELSE
			l_dwDemographics = i_uoDemographics.dw_demographics
			IF l_dwDemographics.DataObject <> 'd_demographics_employer' THEN
				l_dwDemographics.SetRedraw (FALSE)
				fw_buildfieldlist ('E')
				l_dwDemographics.fu_Swap('d_demographics_employer', &
				   l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + i_ulDemographicsVW + &
					l_dwDemographics.c_ModifyOK + & 
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NoMenuButtonActivation)
				i_uoDemographics.fu_displayfields()
				l_dwDemographics.SetRedraw (TRUE)
			END IF
			
			// RAE 4/5/99			
			l_dwDemographics.fu_Retrieve(&
				l_dwDemographics.c_IgnoreChanges, &
				l_dwDemographics.c_ReselectRows)
				
		END IF
		
	//-------------------------------------------------------------------------------------		
	// Source Provider --		
	//-------------------------------------------------------------------------------------	
	CASE i_cSourceProvider
		IF NOT IsValid(i_uoDemographics) THEN
			SetPointer(HOURGLASS!)
			SetRedraw(FALSE)
				
			OPENUSEROBJECT(i_uoDemographics, 'u_demographics', 23, 104)

			i_uoDemographics.i_wParentWindow = THIS
			i_uoDemographics.BringToTop = TRUE
			i_uoDemographics.Border = FALSE
			i_woTabObjects[1] = i_uoDemographics
	   	dw_folder.fu_assignTab(dw_folder.i_clickedtab, i_woTabObjects[])

			l_dwDemographics = i_uoDemographics.dw_demographics
			l_dwDemographics.fu_SetOptions( SQLCA, & 
 				l_dwDemographics.c_NullDW, & 
 				i_ulDemographicsCW + l_dwDemographics.c_NoRetrieveOnOpen + &
 				i_ulDemographicsVW + &
				l_dwDemographics.c_ModifyOK + & 
				l_dwDemographics.c_ModifyOnOpen + &
				l_dwDemographics.c_NoMenuButtonActivation) 

			l_dwDemographics.SetRedraw (FALSE)
			IF l_dwDemographics.DataObject <> 'd_demographics_provider' THEN
				fw_buildfieldlist ('P')
				l_dwDemographics.fu_Swap('d_demographics_provider', &
				   l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + i_ulDemographicsVW + &
					l_dwDemographics.c_ModifyOK + & 
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NoMenuButtonActivation)
			END IF
			i_uoDemographics.fu_displayfields()
			l_dwDemographics.SetRedraw (TRUE)
			
			
			// RAE 4/5/99			
			l_dwDemographics.fu_Retrieve(&
				l_dwDemographics.c_IgnoreChanges, &
				l_dwDemographics.c_NoReselectRows)

			SetRedraw(TRUE)

		ELSE
			l_dwDemographics = i_uoDemographics.dw_demographics
			IF l_dwDemographics.DataObject <> 'd_demographics_provider' THEN
				l_dwDemographics.SetRedraw (FALSE)
				fw_buildfieldlist ('P')
				l_dwDemographics.fu_Swap('d_demographics_provider', &
				   l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + i_ulDemographicsVW + &
					l_dwDemographics.c_ModifyOK + & 
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NoMenuButtonActivation)
				i_uoDemographics.fu_displayfields()
				l_dwDemographics.SetRedraw (TRUE)
			END IF
			
			// RAE 4/5/99			
			l_dwDemographics.fu_Retrieve(l_dwDemographics.c_IgnoreChanges, l_dwDemographics.c_ReselectRows)

		END IF
		
	//-------------------------------------------------------------------------------------
	// Source Other --		
	//-------------------------------------------------------------------------------------	
	CASE i_cSourceOther
		FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveDemographicChanges)

		IF NOT IsValid(i_uoDemographics) THEN
			SetPointer(HOURGLASS!)
			SetRedraw(FALSE)
				
			OPENUSEROBJECT(i_uoDemographics, 'u_demographics', 23, 104)
			i_uoDemographics.i_wParentWindow = THIS
			i_uoDemographics.BringToTop = TRUE
			i_uoDemographics.Border = FALSE
			i_woTabObjects[1] = i_uoDemographics
		   dw_folder.fu_assignTab(dw_folder.i_clickedtab, i_woTabObjects[])

			l_dwDemographics = i_uoDemographics.dw_demographics
			l_dwDemographics.fu_SetOptions( SQLCA, & 
 				l_dwDemographics.c_NullDW, & 
 				i_ulDemographicsCW + &
 				l_dwDemographics.c_ModifyOK + &
 				l_dwDemographics.c_ModifyOnOpen + &
 				l_dwDemographics.c_NewOK + &
 				l_dwDemographics.c_NewModeOnEmpty + &
				l_dwDemographics.c_NoMenuButtonActivation + &
 				i_ulDemographicsVW ) 

			l_dwDemographics.SetRedraw (FALSE)
			IF l_dwDemographics.DataObject <> 'd_demographics_other' THEN
				fw_buildfieldlist ('O')
				l_dwDemographics.fu_Swap('d_demographics_other', &
				   l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + &
					l_dwDemographics.c_ModifyOK + &
					l_dwDemographics.c_NewOK + &
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NewModeOnEmpty + &
					l_dwDemographics.c_NoMenuButtonActivation + &
					i_ulDemographicsVW )
			END IF
			i_uoDemographics.fu_displayfields()
			l_dwDemographics.SetRedraw (TRUE)
			

			// RAE 4/5/99
			l_dwDemographics.fu_Retrieve(&
				l_dwDemographics.c_IgnoreChanges, &
				l_dwDemographics.c_NoReselectRows)

			SetRedraw(TRUE)
		ELSE
			l_dwDemographics = i_uoDemographics.dw_demographics
			IF l_dwDemographics.DataObject <> 'd_demographics_other' THEN
				l_dwDemographics.SetRedraw (FALSE)
				fw_buildfieldlist ('O')
				l_dwDemographics.fu_Swap('d_demographics_other', &
				   l_dwDemographics.c_IgnoreChanges, &
					i_ulDemographicsCW + &
					l_dwDemographics.c_ModifyOK + &
					l_dwDemographics.c_NewOK + &
					l_dwDemographics.c_ModifyOnOpen + &
					l_dwDemographics.c_NewModeOnEmpty + &
					l_dwDemographics.c_NoMenuButtonActivation + &
					i_ulDemographicsVW )
				i_uoDemographics.fu_displayfields()
				l_dwDemographics.SetRedraw (TRUE)
			END IF
			
			// RAE 4/5/99
			l_dwDemographics.fu_Retrieve(&
				l_dwDemographics.c_IgnoreChanges, &
				l_dwDemographics.c_ReselectRows)

		END IF
		
END CHOOSE 
end subroutine

public subroutine fw_voidcase ();/***************************************************************************************

		Function:	fw_voidcase
		Purpose:		To change a case status to VOID.
		Parameters:	None
		Returns:		None
		
		Revisions:
		Date     Developer     Description
		======== ============= ===========================================================
		8/6/99   M. Caruso     Update the case status and related datawindow settings to
		                       prevent users from continuing to edit the case.
		8/20/99  M. Caruso     Update the menu item availability as the status changes.
		3/22/00  M. Caruso     The script now sets the fields within dw_customer_statement
									  to ReadOnly instead of enabling or disabling the object.
		8/29/00  M. Caruso     Changed all ReadOnly settings to DisplayOnly.  This is the
		                       more correct method for preventing user access.
		10/27/00 M. Caruso     Added code to disable the case note entry objects.
		10/30/00 M. Caruso     Removed reference to m_addcasecomments.
		11/28/00 M. Caruso     Added code to prompt for the saving of modified case notes,
									  including that in the save process of the case.
		12/21/00 M. Caruso     Added code to save the case properties as well.
		12/27/2000 K. Claver   Added code to refresh the workdesk if open.
		12/29/2000 K. Claver   Moved the code to save the case properties to the pcd_saveafter
								  	  event of the case details tab as the case properties shouldn't
								  	  be saved until after the case has been saved.
		1/8/2001   K. Claver   Changed to simply validate case properties rather than save
									  as the save is handled with the save of case details
		01/10/01 M. Caruso     Replaced code for saving the case with a call to fu_savecase ().
		01/11/01 M. Caruso     Only complete processing if fu_savecase succeeds.
		01/13/01 M. Caruso     Verify that a category has been assigned before allowing the
									  case to be voided.  Removed validation of case properties.
	   4/13/2001 K. Claver    Changed to select tab 6 if encounter a category error to
									  accomodate for the addition of the carve out tab.
		1/15/2002 K. Claver    Switched call to selecttab to reference categories as tab 8
		3/7/2002  K. Claver    Changed to notify the workdesk that it is ok to refresh rather
									  than triggering a refresh
      06/13/03 M. Caruso     Removed call to fu_SetVoidedCaseGUI.  Moved it to fu_SaveCase.
***************************************************************************************/

INT			l_nReturn
U_DW_STD		l_dwCaseDetails, l_dwNoteEntry, l_dwCaseProperties
U_OUTLINER	l_dwCategories
String		l_cCaseNumber, l_cCategory, ls_status

l_cCategory = i_uoCaseDetails.i_cSelectedCategory
IF IsNull (l_cCategory) OR Trim (l_cCategory) = '' THEN
	MessageBox (gs_appname, 'A category must be assigned for all cases.')
	i_uoCaseDetails.tab_folder.SelectTab (8)
ELSE
	// Check for an open appeal
	SELECT IsNull(cusfocus.appealstatus.isclose  , 'N')
	INTO :ls_status  
	FROM cusfocus.appealheader,   
			cusfocus.appealstatus  
	WHERE cusfocus.appealheader.case_number = :i_cCurrentCase
	and ( cusfocus.appealheader.appealheaderstatusid = cusfocus.appealstatus.id )   ;


	CHOOSE CASE SQLCA.SQLCode
		CASE 0
			IF ls_status <> 'Y' THEN
				//-----------------------------------------------------------------------------------------------------------------------------------
				// If the user is in the Supervisor role, then let them close a case with an open appeal.
				//-----------------------------------------------------------------------------------------------------------------------------------
				If i_bSupervisorRole <> TRUE Then 
					MessageBox( gs_AppName, "Cannot void a case with an open appeal", StopSign!, OK! )
							
					RETURN
				End If
			END IF
		CASE -1
			MessageBox( gs_AppName, "Error determining the status of appeal entries for the current case", StopSign!, OK! )
						
			RETURN
	END CHOOSE

	l_nReturn = MessageBox (gs_AppName, 'Are you sure you want to Void this Case?' + &
			'  You will not be able to UNDO this.', QUESTION!, YESNO!)
	
	IF l_nReturn = 1 THEN
		
		IF ISVALID(i_uoCaseDetails) THEN
			
			l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
			l_dwCaseProperties = i_uoCaseDetails.tab_folder.tabpage_case_properties.dw_case_properties
			l_dwCategories = i_uoCaseDetails.tab_folder.tabpage_category.dw_categories
			
			// prevent validation checking of case properties.
			l_dwCaseProperties.SetItemStatus (1, 0, Primary!, NotModified!)
			
			IF Error.i_FWError <> c_Fatal THEN
				l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_case_status_id', i_cStatusVoid )
				IF i_uoCaseDetails.fu_saveCase (i_uoCaseDetails.c_SaveChanges, FALSE) = c_Success THEN
				
					// since the case is voided, update the status and the window settings.
					i_uoCaseDetails.i_cCaseStatus = i_cStatusVoid
					
					//Set to refresh the workdesk if open
					IF IsValid( w_reminders ) THEN
						w_reminders.fw_SetOkRefresh( )
					END IF
					
				END IF
				
			END IF
			
		END IF
		
	END IF
	
END IF
end subroutine

public subroutine fw_closecase ();//*****************************************************************************************
//
//  Function:   fw_closecase
//  Purpose:    To change the case status to closed.
//  Parameters: None
//  Returns:    None
//    
//  Date     Developer    Description
//  -------- ------------ ------------------------------------------------------------------
//  6/21/99  M. Caruso    Added code to check for a valid case number before saving
//                        the case.  A case number is assigned if necessary before
//                        the fu_Save() is called.
//  8/6/99   M. Caruso    Once case is succesfully closed, update the case status and
//                        related window settings to prevent the user from further
//                        updating the case.
//  8/17/99  M. Caruso    Corrected the print survey prompt for Pro-Active Other cases.
//  8/20/99  M. Caruso    Update the menu avaiability when the status changes.
//  1/10/00  M. Caruso    Fixed an invalid object reference in CASE 5 from
//                        i_uoCaseDetailIssueConcern to i_uoCaseDetailCompliment.
//  3/22/00  M. Caruso    The script now sets the fields within dw_customer_statement
//                        to ReadOnly instead of enabling or disabling the object.
//  4/14/00  C. Jackson   Add functionality to open the Close Case Window. 
//  4/28/00  M. Caruso    Added code to enable the View Case Detail Report menu item when
//								  case is successfully closed.  Also moved Close Case window
//								  after the validation checking of each case type.
//  8/18/00  M. Caruso    For each case type, set the values required by the "Close"
//                        window into an instance variable and pass it to the window when
//                        it is opened.  When the window is closed, check the instance
//                        variable for the values set on the window and process accordingly.
//  10/17/00 M. Caruso    Modified the function to work with the new Case Detail setup.
//  10/27/00 M. Caruso    Added code to enable/disable the case note entry objects based on
//                        the user priviliges.
//  10/30/00 M. Caruso    Removed reference to m_addcasecomments.
//  11/07/00 M. Caruso    Added code to handle conditions of the new case transfer module.
//  11/09/00 K. Claver    Fixed code to properly update the case log table with the case rep if
//								  the case has return for close set.  Also added code to delete from
//								  the case transfer table when the case is closed.
//	 11/27/00 K. Claver    Added code to set the case_viewed field in the case_transfer table
//								  back to null so will show bold in the inbox on the workdesk for the
//								  originator.
//  11/28/00 M. Caruso    Added code to prompt for the saving of modified case notes,
//                        including that in the save process of the case.
//  11/30/00 K. Claver    Added code to disable the close and void case buttons after a 
//								  successful return for close.
//  12/06/00 K. Claver    Added code to accomodate for routing on return for close.  Also
//								  added code to insert a reminder for the originator if they had
//								  routing set up with return for close.
//  12/07/00 K. Claver    Added code to refresh the workdesk(if open) after a successful
//								  return for close or closure.
//  12/18/00 M. Caruso    Corrected the reference for the tab to select if no category is
//                        chosen.
//  12/21/00 M. Caruso    Added code to save case properties as well.
//  12/29/00 K. Claver    Moved the code to save the case properties to the pcd_saveafter
//								  event of the case details tab as the case properties shouldn't
//								  be saved until after the case has been saved.
//	 01/08/01 K. Claver    Changed to simply validate case properties rather than save
//								  as the save is handled with the save of case details
//  01/10/01 M. Caruso    Replaced code for saving the case with a call to fu_savecase ().
//								  Also removed code to validate case properties tabs.  This is
//								  handled in fu_savecase ().
//  01/11/01 M. Caruso    Perform validation of case components before continuing.
//  01/13/01 M. Caruso    After close, reload the case detail information and reset the
//								  case note entry datawindow.
//  01/14/01 M. Caruso    Changed the way validation is done.  Each item is validated
//								  separately.  If Case Properties fails, switch to that tab.
//  04/02/01 K. Claver    Added code to check carve out before allowing to close the case.
//  04/25/01 C. Jackson   setitem on the datawindow with the other_close_code
//  07/06/01 M. Caruso    Utilize the correspondence manager to print surveys on close.
//  12/05/01 C. Jackson   Spelling: changed "can not" to "cannot" (SCR 2497)
//  01/15/02 K. Claver    Changed categories to be tab 8 in call to selecttab.
//  03/07/02 K. Claver    Changed to notify the workdesk that it is ok to refresh rather
//								  than triggering a refresh.
//  03/28/02 M. Caruso    Added code to set i_bCaseLocked in l_uoDocMgr based on
//								  i_bCaseLocked in this window.
//  01/30/03 C. Jackson   Set return for close back to null when returning to original owner.
//  06/13/03 M. Caruso    Removed call to fu_SetClosedCaseGUI.  Moved it to fu_SaveCase.
//*****************************************************************************************
INT		l_nReturn, l_nReturnForClose, l_nNotifyOnClose, l_nTransCount, l_nRouteCount = 0
INT      l_nCarveCount, l_nCurrentTab
LONG		l_nRow, ll_history_count
BOOLEAN	l_bUpdateSurveyField, l_bCaseXferd, l_bCloseCase, l_bReturnForClose, l_bNotifyOnClose
BOOLEAN  l_bRouting = FALSE, l_bValidated
STRING	l_cDefaultSurvey, l_cXferID, l_cXferTo, l_cXferFrom, l_cXferType = 'O', l_cTakenBy
STRING	l_cReminderID, l_cReminderType, l_cReminderViewed, l_cCaseReminder, l_cReminderSubj
STRING	l_cReminderText, l_cDeleteOnClosed, l_cUserID, l_sCaseNumber, l_sSendSurvey, l_cNotifyID
STRING   l_cRouteTo = "", l_cCaseNumber, ls_status
STRING	l_cNeedReportDate = 'You cannot close this case until you have entered a Reported Date'
STRING	l_cNeedIncidentDate = 'You cannot close this case until you have entered an Incident Date'
STRING	l_cXferNotes = 'Returned for closure. All processing is complete.'
STRING	l_cNeedCategory = 'You MUST first assign a Category to the Case before you can change its status to Closed.'
DATETIME	l_dtTimestamp
S_CLOSE_PARMS	l_sCloseParms
S_DOC_INFO		l_sDocInfo[]
U_DW_STD			l_dwCaseDetails, l_dwNoteEntry, l_dwCaseProperties
U_OUTLINER		l_dwCategories
U_CORRESPONDENCE_MGR	l_uoDocMgr


CHOOSE CASE dw_folder.i_SelectedTab
	CASE 5
		l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
		l_dwCaseProperties = i_uoCaseDetails.tab_folder.tabpage_case_properties.dw_case_properties
		l_dwNoteEntry = i_uoCaseDetails.dw_case_note_entry
		l_dwCategories = i_uoCaseDetails.tab_folder.tabpage_category.dw_categories
		
		// make certain all case components pass validation before continuing...
		l_bValidated = FALSE
		IF l_dwCaseDetails.fu_validate () = 0 THEN
			// disable redraw and switch focus to case properties tab before validation
			i_uoCaseDetails.tab_folder.SetRedraw (FALSE)
			l_nCurrentTab = i_uoCaseDetails.tab_folder.SelectedTab
			i_uoCaseDetails.tab_folder.SelectTab (3)
			l_dwCaseProperties.SetFocus ()
			
			IF l_dwCaseProperties.fu_validate () = 0 THEN
				IF l_nCurrentTab <> 3 THEN i_uoCaseDetails.tab_folder.SelectTab (l_nCurrentTab)
				IF l_dwNoteEntry.fu_validate () = 0 THEN
					l_bValidated = TRUE
				END IF
			ELSE
				i_uoCaseDetails.tab_folder.SelectTab (3)
			END IF
			i_uoCaseDetails.tab_folder.SetRedraw( TRUE )
		END IF
		
		IF l_bValidated THEN
		
			IF Error.i_FWError <> c_Fatal THEN
				//Determine if has started carve out entries
				SELECT Count( * ) 
				  INTO :l_nCarveCount
				  FROM cusfocus.carve_out_entries
				 WHERE cusfocus.carve_out_entries.case_number = :i_cCurrentCase AND
				 		 cusfocus.carve_out_entries.start_date IS NOT NULL AND
						 cusfocus.carve_out_entries.end_date IS NULL
				 USING SQLCA;
				 
				CHOOSE CASE SQLCA.SQLCode
					CASE 0
						IF l_nCarveCount > 0 THEN
							MessageBox( gs_AppName, "Cannot close a case with incomplete carve out entries", StopSign!, OK! )
							
							RETURN
						END IF
					CASE ELSE
						MessageBox( gs_AppName, "Error determining the status of carve out entries for the current case. " + SQLCA.sqlerrtext, StopSign!, OK! )
						
						RETURN
				END CHOOSE
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// Begin JWhite Added 10.26.2005
				//-----------------------------------------------------------------------------------------------------------------------------------
//				  SELECT cusfocus.AppealHeader.AppealHeaderStatus  
//					 INTO :ls_status  
//					 FROM cusfocus.AppealHeader  
//					WHERE cusfocus.AppealHeader.CaseNumber = :i_cCurrentCase   
//					USING SQLCA;
					
				//-----------------------------------------------------------------------------------------------------------------------------------

				// Had to change this embedded select after making the Appeal Status configurable.
				//-----------------------------------------------------------------------------------------------------------------------------------

				  SELECT IsNull(cusfocus.appealstatus.isclose  , 'N')
					 INTO :ls_status  
					 FROM cusfocus.appealheader,   
							cusfocus.appealstatus  
					WHERE cusfocus.appealheader.case_number = :i_cCurrentCase
					and ( cusfocus.appealheader.appealheaderstatusid = cusfocus.appealstatus.id )   ;


				CHOOSE CASE SQLCA.SQLCode
					CASE 0
						IF ls_status <> 'Y' THEN
							//-----------------------------------------------------------------------------------------------------------------------------------

							// If the user is in the Supervisor role, then let them close a case with an open appeal.
							//-----------------------------------------------------------------------------------------------------------------------------------

							If i_bSupervisorRole <> TRUE Then 
								MessageBox( gs_AppName, "Cannot close a case with an open appeal", StopSign!, OK! )
							
								RETURN
							End If
						END IF
					CASE -1
						MessageBox( gs_AppName, "Error determining the status of appeal entries for the current case. " + SQLCA.sqlerrtext , StopSign!, OK! )
						
						RETURN
				END CHOOSE
				//-----------------------------------------------------------------------------------------------------------------------------------
				// End JWhite Added 10.26.2005
				//-----------------------------------------------------------------------------------------------------------------------------------

				
				
				// Determine the status of return for close and notify on close.
				SELECT case_transfer_id, return_for_close, notify_originator_close, case_transfer_from,
						 case_transfer_from
				  INTO :l_cXferID, :l_nReturnForClose, :l_nNotifyOnClose, :l_cXferTo, :l_cNotifyID
				  FROM cusfocus.case_transfer
				 WHERE case_number = :i_cCurrentCase AND case_transfer_type = :l_cXferType
				 USING SQLCA;
				 
				 IF SQLCA.SQLCode < 0 THEN
					// If the retrieval fails, notify the user.
					MessageBox (gs_appname, 'There was an error while attempting to retrieve transfer settings ' + &
													'for this case.  Please notify your system administrator. '  + SQLCA.sqlerrtext)
					RETURN
				END IF
					
				 // Check history for return for close
				IF IsNull (l_nReturnForClose) OR l_nReturnForClose = 0 THEN
					SELECT count(*) INTO :ll_history_count
					  FROM cusfocus.case_transfer_history
					 WHERE case_number = :i_cCurrentCase
					 AND case_transfer_type = :l_cXferType
					 AND return_for_close = 1
					 USING SQLCA;
					 
					 IF ll_history_count > 0 THEN
						SELECT return_for_close, notify_originator_close, case_transfer_from,
								 case_transfer_from
						  INTO :l_nReturnForClose, :l_nNotifyOnClose, :l_cXferTo, :l_cNotifyID
						  FROM cusfocus.case_transfer_history
						 WHERE case_number = :i_cCurrentCase AND case_transfer_type = :l_cXferType
						AND return_for_close = 1
						AND case_transfer_date = 
						(select min(ch2.case_transfer_date)
						  FROM cusfocus.case_transfer_history ch2
						 WHERE ch2.case_number = :i_cCurrentCase AND ch2.case_transfer_type = :l_cXferType
							and ch2.return_for_close = 1)
						 USING SQLCA;
					END IF
				END IF
				
				//Only process this part if Return For Close settings in system options is set to "OWNER".
				//  Put after the select from case transfer as the Notify Originator Close setting
				//  is retrieved in the select.  Close by "OWNER" is considered the default setting.
				IF THIS.i_cCloseBy = "OWNER" OR IsNull( THIS.i_cCloseBy ) THEN								
					//Get the current user and use as the transfer from id 
					l_cXferFrom = OBJCA.WIN.fu_GetLogin( SQLCA )
					 
					CHOOSE CASE SQLCA.SQLCode
						CASE 0
							// Get the original owner ID if a return for close has not been set
							IF IsNull(l_cXferTo) or l_cXferTo = '' THEN
								l_cXferTo = l_dwCaseDetails.GetItemString (l_dwCaseDetails.i_CursorRow, 'case_log_case_log_taken_by')
							END IF
							l_cTakenBy = l_dwCaseDetails.GetItemString (l_dwCaseDetails.i_CursorRow, 'case_log_case_log_taken_by')
							
							//First check routing before do the transfer
							SELECT Count( * )
							  INTO :l_nRouteCount
							  FROM cusfocus.out_of_office
							 WHERE cusfocus.out_of_office.out_user_id = :l_cXferTo
							 USING SQLCA;
							 
							IF l_nRouteCount > 0 THEN
								SELECT cusfocus.out_of_office.assigned_to_user_id
								  INTO :l_cRouteTo
								  FROM cusfocus.out_of_office
								 WHERE cusfocus.out_of_office.out_user_id = :l_cXferTo
								 USING SQLCA;
								 
								IF IsNull( l_cRouteTo ) THEN
									l_cRouteTo = ""
								END IF
							END IF
							
							// If the current user is the same as the route to, then the routing has already
							//   happened...allow to close.  If the current user is the same as the user who
							//   took the case, allow to close.  Otherwise, if marked Return for Close, notify the 
							//   user and transfer the case.
							IF l_nReturnForClose = 1  AND &
								( Upper( l_cRouteTo ) <> Upper( l_cXferFrom ) ) AND &
								( Upper( l_cXferFrom ) <> Upper( l_cXferTo ) ) THEN
								MessageBox (gs_appname, 'This case has been set as Return for Close and will~r~n' + &
																'now be transferred to that user for closure.')
								l_dtTimestamp = fw_GetTimeStamp ()
								
								IF l_nRouteCount > 0 THEN
									IF NOT IsNull( l_cRouteTo ) AND Trim( l_cRouteTo ) <> "" THEN
										//Set values for reminder
										l_cReminderID = fw_GetKeyValue ('reminders')
										l_cReminderType = '1'
										l_cReminderViewed = 'N'
										l_cCaseReminder = 'Y'
										l_cReminderSubj = 'Case Routed'
										l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)
										l_cReminderText = 'Case #' + i_cCurrentCase + ' was returned for closure but '+ &
																'was routed to ' + l_cRouteTo + ' as you were out of the office.'
										l_cDeleteOnClosed = 'N'
										l_dtTimestamp = fw_GetTimeStamp ()
										
										//Insert a new reminder record so the originator knows that the
										//  case was routed
										INSERT INTO cusfocus.reminders
												 (reminder_id, reminder_type_id, reminder_viewed, case_number, case_type,
												  case_reminder, reminder_crtd_date, reminder_set_date, reminder_subject,
												  reminder_comments, reminder_dlt_case_clsd, reminder_author, reminder_recipient)
										VALUES (:l_cReminderID, :l_cReminderType, :l_cReminderViewed, :i_cCurrentCase, :i_cCaseType,
												  :l_cCaseReminder, :l_dtTimestamp, :l_dtTimestamp, :l_cReminderSubj,
												  :l_cReminderText, :l_cDeleteOnClosed, :l_cUserID, :l_cXferTo)
										USING SQLCA;
										
										//Notify if the insert failed
										CHOOSE CASE SQLCA.SQLCode
											CASE IS < 0
												ROLLBACK USING SQLCA;
												MessageBox (gs_appname, 'The case routing notification failed for this case. ' + &
																				'Please notify your system administrator. ' + SQLCA.sqlerrtext)
												RETURN
												
											CASE 100
												ROLLBACK USING SQLCA;
												MessageBox (gs_appname, gs_appname + ' was unable send a routing notice for this case. ' + &
																				'Please notify your system administrator .' + SQLCA.sqlerrtext)
												RETURN
											
										END CHOOSE
										
										//Change the transfer to ID
										l_cXferTo = l_cRouteTo							
									END IF
								END IF					
								
								UPDATE cusfocus.case_transfer  
									SET case_transfer_to = :l_cXferTo, case_transfer_from = :l_cXferFrom,
										 case_transfer_date = :l_dtTimestamp, case_transfer_notes = :l_cXferNotes, 
										 case_viewed = null, return_for_close = NULL
								 WHERE case_transfer_id = :l_cXferID AND 
										 case_transfer_type = :l_cXferType
								 USING SQLCA;
								 
								CHOOSE CASE SQLCA.SQLCode
									CASE IS < 0
										ROLLBACK USING SQLCA;
										MessageBox (gs_appname, 'The transfer for closure has failed for this case. ' + &
																		'Please notify your system administrator. ' + SQLCA.sqlerrtext)
										RETURN
										
									CASE 100
										ROLLBACK USING SQLCA;
										MessageBox (gs_appname, gs_appname + ' was unable transfer this case for closure. ' + &
																		'Please notify your system administrator. ' + SQLCA.sqlerrtext)
										RETURN
																		
								END CHOOSE
								
								//Need to update the case rep field in case log for a proper transfer
								UPDATE cusfocus.case_log 
									SET cusfocus.case_log.case_log_case_rep = :l_cXferTo
								 WHERE cusfocus.case_log.case_number = :i_cCurrentCase
								 USING SQLCA;
								 
								CHOOSE CASE SQLCA.SQLCode
									CASE IS < 0
										ROLLBACK USING SQLCA;
										MessageBox (gs_appname, 'The transfer for closure has failed for this case. ' + &
																		'Please notify your system administrator. ' + SQLCA.sqlerrtext)
										RETURN
										
									CASE 100
										ROLLBACK USING SQLCA;
										MessageBox (gs_appname, gs_appname + ' was unable transfer this case for closure. ' + &
																		'Please notify your system administrator. ' + SQLCA.sqlerrtext)
										RETURN
																		
									CASE 0
										COMMIT USING SQLCA;
										
										//Need to temporarily disable the close and void case buttons after successful
										//  return for close
										m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
										m_create_maintain_case.m_edit.m_voidcase.Enabled = FALSE
										
										//Refresh the workdesk if open
										IF IsValid( w_reminders ) THEN
											w_reminders.fw_SetOkRefresh( )
										END IF
								END CHOOSE
								 
								RETURN
							END IF
							
						CASE IS < 0
							// If the retrieval fails, notify the user.
							MessageBox (gs_appname, 'There was an error while attempting to retrieve transfer settings ' + &
															'for this case.  Please notify your system administrator. ' + SQLCA.sqlerrtext)
							RETURN
							
					END CHOOSE
				END IF
				
				// Continue with the Close process.
				IF l_dwCaseDetails.AcceptText() = 1 THEN
					IF i_uoCaseDetails.i_cSelectedCategory = '' THEN
						MessageBox(gs_appname, l_cNeedCategory)
						i_uoCaseDetails.tab_folder.SelectTab (8)
						l_dwCategories.SetFocus ()
						RETURN
					ELSE
						
						// perform further completion checking if Issue/Concern
						IF i_cCaseType = i_cIssueConcern THEN
							IF ISNULL (l_dwCaseDetails.GetItemDateTime (l_dwCaseDetails.i_CursorRow, 'case_log_rprtd_date')) THEN
								MessageBox (gs_appname, l_cNeedReportDate)
								i_uoCaseDetails.tab_folder.SelectTab (2)
								l_dwCaseDetails.SetFocus ()
								l_dwCaseDetails.SetColumn ('case_log_rprtd_date')
								RETURN
							END IF
							IF ISNULL (l_dwCaseDetails.GetItemDateTime (l_dwCaseDetails.i_CursorRow, 'case_log_incdnt_date')) THEN
								MessageBox (gs_appname, l_cNeedIncidentDate)
								i_uoCaseDetails.tab_folder.SelectTab (2)
								l_dwCaseDetails.SetFocus ()
								l_dwCaseDetails.SetColumn('case_log_incdnt_date')
								RETURN
							END IF
						END IF
						
						// set parameters for the "Close" window
						l_sCloseParms.case_type = i_cCaseType
						CHOOSE CASE i_cCaseType
							CASE i_cConfigCaseType, i_cInquiry, i_cIssueConcern
								l_bUpdateSurveyField = TRUE
								IF l_dwCaseDetails.GetItemString (l_dwCaseDetails.i_CursorRow, "case_log_snd_srvy_clsd") = 'Y' THEN
									l_sCloseParms.print_survey = TRUE
								ELSE
									l_sCloseParms.print_survey = FALSE
								END IF
								
							CASE ELSE
								l_bUpdateSurveyField = FALSE
								l_sCloseParms.print_survey = FALSE
								
						END CHOOSE
						
						// process the "close" window
						FWCA.MGR.fu_openwindow (w_close_case, l_sCloseParms)
						l_sCloseParms = message.powerobjectparm
						i_bclosecase = l_sCloseParms.close_case
						
						IF i_bclosecase THEN
						
							// set values assigned in "close" window
							i_bprintsurvey = l_sCloseParms.print_survey
							i_cCusSatCodeID = l_sCloseParms.sat_code
							i_cResCodeID = l_sCloseParms.res_code
							i_cOtherCloseCodeID = l_sCloseParms.other_close_code
							
							IF i_bprintsurvey THEN
								l_sSendSurvey = 'Y'
							ELSE
								l_sSendSurvey = 'N'
							END IF
							IF l_bUpdateSurveyField THEN
								l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_snd_srvy_clsd', l_sSendSurvey)
							END IF
							l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_case_status_id', i_cStatusClosed)
							l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_case_log_clsd_date', fw_gettimestamp())
							l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_customer_sat_code_id', i_cCusSatCodeID)
							l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_resolution_code_id', i_cResCodeID)
							l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_other_close_code_id', i_cOtherCloseCodeID)
								
							l_nRow = l_dwCaseDetails.GetRow ()
							l_sCaseNumber = l_dwCaseDetails.GetItemString (l_nRow, "case_log_case_number")
							IF IsNull (l_sCaseNumber) OR (l_sCaseNumber = "") THEN
								l_dwCaseDetails.Event pcd_SetKey (SQLCA)
							END IF
							
							IF i_uoCaseDetails.fu_SaveCase (i_uoCaseDetails.c_savechanges) = c_Success THEN
							
								// since the case is closed, update the status and the window settings.
								i_uoCaseDetails.i_cCaseStatus = i_cStatusClosed
								l_dwCaseDetails.fu_retrieve (l_dwCaseDetails.c_ignorechanges, l_dwCaseDetails.c_noreselectrows)
								i_uoCaseDetails.dw_case_note_entry.fu_reset (l_dwCaseDetails.c_ignorechanges)
								i_uoCaseDetails.dw_case_note_entry.fu_New (1)
								
								// print the defined survey if appropriate
								IF i_bprintsurvey THEN
									
									l_uoDocMgr = CREATE U_CORRESPONDENCE_MGR
									l_uoDocMgr.i_bCaseLocked = i_bCaseLocked
									SetNull (l_uoDocMgr.i_dwRefreshDW)
									
									// set new document information
									l_sDocInfo[1].a_cDocID = ''
									l_sDocInfo[1].a_bFilled = FALSE
									l_sDocInfo[1].a_cCaseNumber = i_cCurrentCase
									l_sDocInfo[1].a_cCaseType = i_cCaseType
									SetNull (l_sDocInfo[1].a_blbDocImage)
									SetNUll (l_sDocInfo[1].a_dtSent)
									
									// process the survey - send as BATCH to prevent sending prompt
									l_uoDocMgr.uf_processDocs (l_sDocInfo[], TRUE, TRUE)

									// close the document manager
									DESTROY l_uoDocMgr
									
								END IF
									
								
								// if indicated, notify the previous owner.
								IF l_nNotifyOnClose = 1 THEN
									// set values for reminder
									l_cReminderID = fw_GetKeyValue ('reminders')
									l_cReminderType = '1'
									l_cReminderViewed = 'N'
									l_cCaseReminder = 'Y'
									l_cReminderSubj = 'Case Closure'
									l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)
									l_cReminderText = 'Case #' + i_cCurrentCase + ' has been closed by ' + l_cUserID + '.'
									l_cDeleteOnClosed = 'N'
									l_dtTimestamp = fw_GetTimeStamp ()
									
									// insert the new reminder record
									INSERT INTO cusfocus.reminders
											 (reminder_id, reminder_type_id, reminder_viewed, case_number, case_type,
											  case_reminder, reminder_crtd_date, reminder_set_date, reminder_subject,
											  reminder_comments, reminder_dlt_case_clsd, reminder_author, reminder_recipient)
									VALUES (:l_cReminderID, :l_cReminderType, :l_cReminderViewed, :i_cCurrentCase, :i_cCaseType,
											  :l_cCaseReminder, :l_dtTimestamp, :l_dtTimestamp, :l_cReminderSubj,
											  :l_cReminderText, :l_cDeleteOnClosed, :l_cUserID, :l_cNotifyID)
									USING SQLCA;
									
									// Notify if the insert failed
									CHOOSE CASE SQLCA.SQLCode
										CASE IS < 0
											ROLLBACK USING SQLCA;
											MessageBox (gs_appname, 'The case closure notification failed for this case. ' + &
																			'Please notify your system administrator. ' + SQLCA.sqlerrtext)
											RETURN
											
										CASE 100
											ROLLBACK USING SQLCA;
											MessageBox (gs_appname, gs_appname + ' was unable send a closure notice for this case. ' + &
																			'Please notify your system administrator. ' + SQLCA.sqlerrtext)
											RETURN
										
									END CHOOSE
									
								END IF
								
								//Delete records from the case transfer table if they exist.
								SELECT Count( * )
								INTO :l_nTransCount
								FROM cusfocus.case_transfer
								WHERE cusfocus.case_transfer.case_number = :i_cCurrentCase
								USING SQLCA;
								
								IF l_nTransCount > 0 THEN
									//If there are records, delete them.
									DELETE cusfocus.case_transfer
									WHERE cusfocus.case_transfer.case_number = :i_cCurrentCase
									USING SQLCA;
									
									IF SQLCA.SQLCode < 0 OR SQLCA.SQLCode = 100 THEN
										ROLLBACK USING SQLCA;
										MessageBox (gs_appname, 'Failed to close the case in the case tranfer table' + &
																		'Please notify your system administrator. ' + SQLCA.sqlerrtext)
										RETURN
									ELSE
										COMMIT USING SQLCA;
										
										
									END IF
								END IF
								
								// remove related case reminders as appropriate
								DELETE FROM cusfocus.reminders WHERE case_number =:i_cCurrentCase
									AND reminder_dlt_case_clsd = 'Y';
										
							END IF 
								
						ELSE
							RETURN
						END IF
		
					END IF
					
					//Refresh the workdesk if open
					IF IsValid( w_reminders ) THEN
						w_reminders.fw_SetOkRefresh( )
					END IF			
				ELSE
					RETURN
				END IF
			END IF
			
		END IF
		
	CASE ELSE
		RETURN
				
END CHOOSE
end subroutine

public subroutine fw_updatedemographicsrt ();/*****************************************************************************************
   Function:   fw_UpdateDemographicsRT
   Purpose:    Called as part of the Real-Time Demographics functionality, this function
					executes the stored procedure responsible for updating the demographics
					information in the CustomerFocus database with the current information from
					the host system.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/27/03 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cSearchParm[3], tempStr

IF IsNull (i_cProviderID) THEN
	tempStr = "NULL"
ELSE
	tempStr = i_cProviderID
END IF

// initialize the arguments
CHOOSE CASE i_cSourceType
	CASE 'C'
		l_cSearchParm[1] = i_cCurrentCaseSubject
		SetNull (l_cSearchParm[2])
		SetNull (l_cSearchParm[3])
	
	CASE 'P'
		l_cSearchParm[1] = i_cProviderID
		l_cSearchParm[2] = i_cVendorId
		l_cSearchParm[3] = i_cProviderType

	
	CASE 'E'
		l_cSearchParm[1] = i_cCurrentCaseSubject
		SetNull (l_cSearchParm[2])
		SetNull (l_cSearchParm[3])

END CHOOSE

// prep the stored procedure
DECLARE infoUpdateRT PROCEDURE FOR sp_retrieve_full_demographic
	@source_type = :i_cSourceType,
	@search_crit_1 = :l_cSearchParm[1],
	@search_crit_2 = :l_cSearchParm[2],
	@search_crit_3 = :l_cSearchParm[3];
	
// run it
EXECUTE infoUpdateRT;


end subroutine

public subroutine fw_aftersearchprocess ();///*****************************************************************************************
//   Function:   fw_AfterSearchProcess
//   Purpose:    After performing the search screen query, run this code. This code was
//					taken from the pc_search event of w_create_maintain_case.
//   Parameters: NONE
//   Returns:    NONE
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	08/19/03 M. Caruso    Created.
//	12/11/03 M. Caruso    Added a separate prompt for when no matching cases are found in
//								 a case search.
//*****************************************************************************************/

LONG 		l_nRowsToSelect[]
STRING 	l_cNoRowsFound, l_cSourceType, l_cCurrUser
INT 		l_nResponse

IF Error.i_FWError = c_Fatal THEN RETURN

CHOOSE CASE uo_search_criteria.uo_matched_records.dw_matched_records.RowCount()
	CASE 0
		//-------------------------------------------------------------------------------------
		//		If no records were found, prompt the user if they wish to create a new Other
		//		Source record if we are not searching by case.  Otherwise just inform the user
		//		there are no cases that meet the search criteria.
		//-------------------------------------------------------------------------------------
		IF uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> 'd_matched_cases' THEN
			
			l_cNoRowsFound = "There are no records which meet the search criteria.~r~n" + &
								  "Would you like to create a New Case Subject?"
			l_nResponse = MessageBox (gs_AppName, l_cNoRowsFound, QUESTION!, YESNO!)

			//	If they wish to create a new record go and do it!
			IF l_nResponse = 1 THEN

				fw_buildfieldlist('O')   //  MPC 7/29/99
				IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
					TriggerEvent(FWCA.MGR.i_WindowCurrent, "pc_New")
				END IF
				dw_folder.fu_EnableTab (2)
				dw_folder.fu_DisableTab (3)
				dw_folder.fu_DisableTab (4)
				dw_folder.fu_DisableTab (5)
				dw_folder.fu_DisableTab (6)
				dw_folder.fu_DisableTab (7)
				dw_folder.fu_DisableTab (8)
				
				//Disable the new case type menu items
				m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled = FALSE
				m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled = FALSE
				m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled = FALSE
				m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled = FALSE
				
			ELSE
				
				dw_folder.fu_DisableTab (2)
				dw_folder.fu_DisableTab (3)
				dw_folder.fu_DisableTab (4)
				dw_folder.fu_DisableTab (5)
				dw_folder.fu_DisableTab (6)
				dw_folder.fu_DisableTab (7)
				dw_folder.fu_DisableTab (8)
				
			END IF
			
		ELSE
			
			l_cNoRowsFound = "There are no records which meet the search criteria."
			l_nResponse = MessageBox (gs_AppName, l_cNoRowsFound, INFORMATION!, OK!)
			
			dw_folder.fu_DisableTab (2)
			dw_folder.fu_DisableTab (3)
			dw_folder.fu_DisableTab (4)
			dw_folder.fu_DisableTab (5)
			dw_folder.fu_DisableTab (6)
			dw_folder.fu_DisableTab (7)
			dw_folder.fu_DisableTab (8)
				
		END IF

	CASE IS > 0
		//---------------------------------------------------------------------------------
		//		Enable the Demographics and all the Case Detail Tabs if its not a case search
		//----------------------------------------------------------------------------------

		l_nRowsToSelect[1] = 1
		uo_search_criteria.uo_matched_records.dw_matched_records.fu_SetSelectedRows(1, l_nRowsToSelect[], &
										uo_search_criteria.uo_matched_records.dw_matched_records.c_IgnoreChanges, &
										uo_search_criteria.uo_matched_records.dw_matched_records.c_NoRefreshChildren)
	
		dw_folder.fu_DisableTab (6)
		dw_folder.fu_DisableTab (7)
		dw_folder.fu_DisableTab (8)
			
		IF (uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> 'd_matched_cases') And (uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> 'd_matched_cases_caseprops') THEN
	
			
			IF uo_search_criteria.uo_matched_records.dw_matched_records.RowCount() = 1 AND NOT uo_search_criteria.i_bCancelSearch THEN
				IF uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> "d_matched_appeals_props" THEN
					m_create_maintain_case.m_file.m_printsetup.Enabled = FALSE
					m_create_maintain_case.m_file.m_documentquickinterface.Enabled = FALSE
					dw_folder.fu_DisableTab (5)
					dw_folder.fu_SelectTab (2)
				ELSE
					l_cCurrUser = OBJCA.WIN.fu_GetLogin( SQLCA )
					
					IF THIS.i_nRepConfidLevel < THIS.i_nCaseConfidLevel AND &
						l_cCurrUser <> "cfadmin" AND THIS.i_cCurrCaseRep <> l_cCurrUser THEN
	//					9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin					
	//					l_cCurrUser <> "sysadmin" AND THIS.i_cCurrCaseRep <> l_cCurrUser THEN
						dw_folder.fu_DisableTab (5)
						MessageBox( gs_AppName, "You do not have the proper security level to view this case.", &
										StopSign!, OK! )
					
					ELSEIF THIS.i_nRepRecConfidLevel >= THIS.i_nRecordConfidLevel OR &
							 IsNull( THIS.i_nRecordConfidLevel ) OR l_cCurrUser = "cfadmin" THEN
	//							9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
	//						 IsNull( THIS.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN
	
						IF NOT IsNull( THIS.i_nRecordConfidLevel ) THEN
							MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
											"for internal purposes.  You have access to view it.  However, please~r~n"+ &
											"remember that this information is strictly confidential." )
						END IF
						
						THIS.dw_folder.fu_SelectTab (5)
						THIS.i_uoCaseDetails.POST fu_opencase ()   // new line
					ELSE
						MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
										"for internal purposes.  You do not have access to view it.", &
										StopSign!, Ok! )
					END IF
				END IF
			END IF
			
		ELSE
			
			m_create_maintain_case.m_file.m_printsetup.Enabled = TRUE
			m_create_maintain_case.m_file.m_documentquickinterface.Enabled = TRUE
			
			l_cSourceType = uo_search_criteria.uo_matched_records.dw_matched_records.GetItemString (1, "source_type")
			fw_buildfieldlist (l_cSourceType)
			
			l_cCurrUser = OBJCA.WIN.fu_GetLogin( SQLCA )
			
			IF uo_search_criteria.uo_matched_records.dw_matched_records.RowCount() = 1 AND NOT uo_search_criteria.i_bCancelSearch THEN
				IF THIS.i_nRepConfidLevel < THIS.i_nCaseConfidLevel AND &
					l_cCurrUser <> "cfadmin" AND THIS.i_cCurrCaseRep <> l_cCurrUser THEN
//					9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin					
//					l_cCurrUser <> "sysadmin" AND THIS.i_cCurrCaseRep <> l_cCurrUser THEN
					dw_folder.fu_DisableTab (5)
					MessageBox( gs_AppName, "You do not have the proper security level to view this case.", &
									StopSign!, OK! )
				
				ELSEIF THIS.i_nRepRecConfidLevel >= THIS.i_nRecordConfidLevel OR &
						 IsNull( THIS.i_nRecordConfidLevel ) OR l_cCurrUser = "cfadmin" THEN
//							9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//						 IsNull( THIS.i_nRecordConfidLevel ) OR l_cCurrUser = "sysadmin" THEN

					IF NOT IsNull( THIS.i_nRecordConfidLevel ) THEN
						MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
										"for internal purposes.  You have access to view it.  However, please~r~n"+ &
										"remember that this information is strictly confidential." )
					END IF
					
					THIS.dw_folder.fu_SelectTab (5)
					THIS.i_uoCaseDetails.POST fu_opencase ()   // new line
				ELSE
					MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
									"for internal purposes.  You do not have access to view it.", &
									StopSign!, Ok! )
				END IF

			END IF
	
		END IF
		
END CHOOSE
end subroutine

public subroutine fw_transfercase ();/**************************************************************************************
	Function:	fw_transfercase
	Purpose:		To transfer a case from one user to another
	Parameters:	None
	Returns:		None
	
	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	10/17/00 M. Caruso     Modified to work with the new Case Detail window setup.
	11/3/2000 K. Claver    Added code to allow the case transfer window to function from 
								  the contact history tab
	12/8/2000 K. Claver    Added code to refresh the workdesk(if open) after a transfer.
	01/10/01 M. Caruso     Modified to call fu_savecase ().
	2/15/2001 K. Claver    Changed back to using fu_Save( ) for case details after the transfer.
	3/7/2002  K. Claver    Changed to notify the workdesk that it is ok to refresh rather
								  than triggering a refresh
	3/7/2002  K. Claver    Moved update to case log case rep to the transfer window as
								  it is part of a successful transfer and should be rolled
								  back if the transfer fails.
	10/3/2002 K. Claver    Added call to the function to unlock the case before switch
								  to the search tab for a case transferred with a higher 
								  security level than the current user.
**************************************************************************************/

STRING	l_cTransferOk, l_cCaseNumber
INT		l_nCaseConfidLevel, l_nReturn, li_row
U_DW_STD	l_dwCaseDetails, l_dwCaseHistory

SetPointer (HOURGLASS!)

FWCA.MSG.fu_SetMessage ("ChangesOne", FWCA.MSG.c_MSG_Text, &
		'Do you want to save your changes to the Case prior to Transfer/Copy the Case?')
FWCA.MSG.fu_SetMessage ("Changes", FWCA.MSG.c_MSG_Text, &
		'Do you want to save your changes to the Case prior to Transfer/Copy the Case?')
		
IF dw_folder.i_SelectedTab = 4 THEN
	IF IsValid( i_uoContactHistory ) THEN

		li_row = i_uoContactHistory.uo_search_contact_history.dw_report.GetRow()
		l_nCaseConfidLevel = i_uoContactHistory.uo_search_contact_history.dw_report.GetItemNumber(li_row, "confidentiality_level")
		l_cCaseNumber = i_uoContactHistory.uo_search_contact_history.dw_report.Object.case_number[ li_row ]
		
		//If the case is locked by another user, don't allow to continue
		IF i_uoContactHistory.fu_CheckLocked( l_cCaseNumber ) THEN
			RETURN
		END IF
	
		PCCA.Parm[1] = i_cSelectedCase
		PCCA.Parm[2] = i_cCaseType
		PCCA.Parm[3] = STRING (l_nCaseConfidLevel)
		PCCA.Parm[4] = i_cUserLastName
		PCCA.Parm[5] = STRING (i_nRepConfidLevel)
	
		FWCA.MGR.fu_OpenWindow (w_transfer_case, 0)
	
		l_cTransferOk = PCCA.Parm[1]
	
		IF Upper( Trim( l_cTransferOk ) ) = "SUCCESS" THEN
			//Set to refresh the workdesk if open
			IF IsValid( w_reminders ) THEN
				w_reminders.fw_SetOkRefresh( )
			END IF
			
		ELSE
			RETURN
		END IF
		
	END IF
ELSEIF dw_folder.i_SelectedTab = 5 THEN

	IF IsValid(i_uoCaseDetails) THEN
		l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
		l_nReturn = i_uoCaseDetails.fu_SaveCase (i_uoCaseDetails.c_PromptChanges)
	
		IF l_nReturn = c_Fatal THEN
			RETURN
		END IF
	
		l_nCaseConfidLevel = l_dwCaseDetails.GetItemNumber (&
											l_dwCaseDetails.i_CursorRow, "confidentiality_level")
	
		PCCA.Parm[1] = i_cCurrentCase
		PCCA.Parm[2] = i_cCaseType
		PCCA.Parm[3] = STRING (l_nCaseConfidLevel)
		PCCA.Parm[4] = i_cUserLastName
		PCCA.Parm[5] = STRING (i_nRepConfidLevel)
	
		FWCA.MGR.fu_OpenWindow (w_transfer_case, 0)
	
		l_cTransferOK = PCCA.Parm[1]
	
		IF Upper( Trim( l_cTransferOK ) ) = "SUCCESS" THEN
			//Successful transfer. Set to refresh the workdesk if open
			IF IsValid( w_reminders ) THEN
				w_reminders.fw_SetOKRefresh( )
			END IF	
			
			//Refresh the case details datawindow to reflect the change
			l_dwCaseDetails.fu_Retrieve( l_dwCaseDetails.c_IgnoreChanges, l_dwCaseDetails.c_NoReselectRows )
		ELSE 
			RETURN
		END IF
	END IF
END IF

FWCA.MSG.fu_SetMessage ("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveCaseChanges)
FWCA.MSG.fu_SetMessage ("Changes", FWCA.MSG.c_MSG_Text, i_cSaveCaseChanges)
	

//-----------------------------------------------------------------------------------------------------------------------------------
// After the case is transfered, unlock the case and send the user 
// back to the search window
//-----------------------------------------------------------------------------------------------------------------------------------
i_uoCaseDetails.tab_folder.tabpage_case_details.fu_UnlockCase( )
i_bSearchCriteriaUpdate = FALSE
fw_newsearch()
	

end subroutine

public function long of_build_contacthistory_fields (string source_type);/*****************************************************************************************
	Function:	fw_buildfieldlist
	Purpose:		Add defined configurable fields to the field list for the selected source
	            type.
	Parameters:	STRING	source_type -> determine which set of configurable fields to add.
	Returns:		LONG ->	 0 - success
								-1 - failure
								
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	7/12/99  M. Caruso     Created.
	
	7/15/99  M. Caruso     Removed code to add fields to i_cCriteriaColumn[],
	                       i_cSearchColumn[] and i_cSearchTable[]
	5/3/2001 K. Claver     Enhanced to set invisible property for fields so are added to the
								  demographics configurable datawindow so can use as arguments for 
								  IIM tabs

*****************************************************************************************/
U_ContactHistory_FIELD_LIST	l_dsFields
LONG					l_nCount, l_nColIndex
S_FIELDPROPERTIES ls_null[]

// retrieve the list of fields for source_type from the database.
l_dsFields = CREATE u_contacthistory_field_list
l_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = 0

i_sContactHistoryField[] = ls_null[] 

i_nNumConfigFields = l_dsFields.Retrieve(source_type, is_contacthistory_casetype)

// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sContactHistoryField[l_nCount].column_name = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_column_name")
		IF IsNull (i_sContactHistoryField[l_nCount].column_name) OR &
			(Trim (i_sContactHistoryField[l_nCount].column_name) = "") THEN
			i_sContactHistoryField[l_nCount].column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sContactHistoryField[l_nCount].field_label = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_field_label")
		IF IsNull (i_sContactHistoryField[l_nCount].field_label) OR &
			(Trim (i_sContactHistoryField[l_nCount].field_label) = "") THEN
			i_sContactHistoryField[l_nCount].field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sContactHistoryField[l_nCount].field_length = l_dsFields.GetItemNumber(l_nCount, &
					"case_properties_field_def_field_length")
		IF IsNull (i_sContactHistoryField[l_nCount].field_length) THEN
			i_sContactHistoryField[l_nCount].field_length = 50
		END IF
		
		// get the "locked" parameter associated with this field
		i_sContactHistoryField[l_nCount].locked = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_locked")
		IF IsNull (i_sContactHistoryField[l_nCount].locked) OR &
			(Trim (i_sContactHistoryField[l_nCount].locked) = "") THEN
			i_sContactHistoryField[l_nCount].locked = "N"
		END IF
/*		
		// Get the "searchable" parameter associated with this field
		i_sContactHistoryField[l_nCount].searchable = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_searchable_contacthistory")
		IF IsNull (i_sContactHistoryField[l_nCount].searchable) OR &
			(Trim (i_sContactHistoryField[l_nCount].searchable) = "") THEN
			i_sContactHistoryField[l_nCount].searchable = "N"
		END IF
*/		
		// get the "display only" parameter associated with this field
		i_sContactHistoryField[l_nCount].display_only = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_display_only")
		IF IsNull (i_sContactHistoryField[l_nCount].display_only) OR &
			(Trim (i_sContactHistoryField[l_nCount].display_only) = "") THEN
			i_sContactHistoryField[l_nCount].display_only = "N"
		END IF
		
		// get the edit mask associated with this field
		i_sContactHistoryField[l_nCount].edit_mask = l_dsFields.GetItemString(l_nCount, &
					"display_formats_edit_mask")
		IF IsNull (i_sContactHistoryField[l_nCount].edit_mask) OR &
			(Trim (i_sContactHistoryField[l_nCount].edit_mask) = "") THEN
			i_sContactHistoryField[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sContactHistoryField[l_nCount].display_format = l_dsFields.GetItemString(l_nCount, &
					"display_formats_display_format")
		IF IsNull (i_sContactHistoryField[l_nCount].display_format) OR &
			(Trim (i_sContactHistoryField[l_nCount].display_format) = "") THEN
			i_sContactHistoryField[l_nCount].display_format = '[general]'
		END IF
		
		// get the display name associated with this field
		i_sContactHistoryField[l_nCount].format_name = l_dsFields.GetItemString(l_nCount, &
					"display_formats_format_name")
		IF IsNull (i_sContactHistoryField[l_nCount].format_name) OR &
			(Trim (i_sContactHistoryField[l_nCount].format_name) = "") THEN
			i_sContactHistoryField[l_nCount].format_name = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sContactHistoryField[l_nCount].validation_rule = l_dsFields.GetItemString(l_nCount, &
					"display_formats_validation_rule")
		IF IsNull (i_sContactHistoryField[l_nCount].validation_rule) OR &
			(Trim (i_sContactHistoryField[l_nCount].validation_rule) = "") THEN
			i_sContactHistoryField[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sContactHistoryField[l_nCount].error_msg = l_dsFields.GetItemString(l_nCount, &
					"display_formats_error_msg")
		IF IsNull (i_sContactHistoryField[l_nCount].error_msg) OR &
			(Trim (i_sContactHistoryField[l_nCount].error_msg) = "") THEN
			i_sContactHistoryField[l_nCount].error_msg = ''
		END IF
		
		// get the visible setting associated with this field
		i_sContactHistoryField[l_nCount].visible = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_visible")
		IF IsNull (i_sContactHistoryField[l_nCount].visible) OR &
			(Trim (i_sContactHistoryField[l_nCount].visible) = "") THEN
			i_sContactHistoryField[l_nCount].visible = ''
		END IF
		
		// get the visible setting associated with this field
		i_sContactHistoryField[l_nCount].dropdown = l_dsFields.GetItemString(l_nCount, &
					"dropdown")
		IF IsNull (i_sContactHistoryField[l_nCount].dropdown) OR &
			(Trim (i_sContactHistoryField[l_nCount].dropdown) = "") THEN
			i_sContactHistoryField[l_nCount].dropdown = ''
		END IF


//		// add any searchable fields to the related search window instance variables.
//		IF i_sContactHistoryField[l_nCount].searchable = 'Y' THEN
//			l_nColIndex = UpperBound(uo_search_criteria.i_cCriteriaColumn) + 1
//			uo_search_criteria.i_cCriteriaColumn[l_nColIndex] = i_sContactHistoryField[l_nCount].column_name
//			uo_search_criteria.i_cSearchColumn[l_nColIndex] = i_sContactHistoryField[l_nCount].column_name
//			// set the search table = to the table of the previous column
//			uo_search_criteria.i_cSearchTable[l_nColIndex] = uo_search_criteria.i_cSearchTable[l_nColIndex - 1]
//		END IF
	NEXT
END IF

// remove the datastore from memory
DESTROY l_dsFields

RETURN 0
end function

public function string of_add_case_properties ();//CONSTANT	INTEGER	col1labelX = 27
//CONSTANT	INTEGER	col2labelX = 1010
//CONSTANT	INTEGER	col3labelX = 1993
//CONSTANT	INTEGER	col1cellX = 554
//CONSTANT	INTEGER	col2cellX = 1537
//CONSTANT	INTEGER	col3cellX = 2520
//CONSTANT INTEGER  rightmargin = 3164
//CONSTANT INTEGER	colwidth1 = 429
//CONSTANT INTEGER	colwidth2 = 1412
//CONSTANT INTEGER	colwidth3 = 2395
//CONSTANT STRING	labelwidth = '500'
//CONSTANT STRING	cellheight = '64'
//CONSTANT INTEGER	charwidth = 40
//CONSTANT INTEGER	y_offset = 92

CONSTANT	INTEGER	col1labelX = 25		//These move the added labels left/right
CONSTANT	INTEGER	col2labelX = 1100 
CONSTANT	INTEGER	col3labelX = 2175

CONSTANT	INTEGER	col1cellX = 459		//These move the added columns left/right
CONSTANT	INTEGER	col2cellX = 1539
CONSTANT	INTEGER	col3cellX = 2612

CONSTANT INTEGER  rightmargin = 5500

CONSTANT INTEGER	colwidth1 = 407
CONSTANT INTEGER	colwidth2 = 407
CONSTANT INTEGER	colwidth3 = 407

CONSTANT STRING	labelwidth = '425'
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92



LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth
STRING	l_sColName, l_sModString, l_sMsg, l_cSyntax, l_cObjName, l_cVisible
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate
STRING	l_cLabelName, l_cLabelText, l_cCity, l_cState, l_cZip

//Recreate the datawindow to make sure the columns don't just keep getting added on
uo_search_criteria.dw_search_criteria.Create(uo_search_criteria.is_origingal_search_syntax)

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (uo_search_criteria.dw_search_criteria.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF uo_search_criteria.dw_search_criteria.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = uo_search_criteria.dw_search_criteria.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.Y'))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxX = l_nX
			l_nMaxY = l_nY
			l_nLastCol = l_nIndex
		ELSEIF (l_nY = l_nMaxY) THEN
			IF l_nX > l_nMaxX THEN
				l_nMaxX = l_nX
				l_nLastCol = l_nIndex
			END IF
		END IF
		
		// calculate the highest used Tab Sequence Value
		l_nNewTabSeq = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_sMsg = uo_search_criteria.dw_search_criteria.Describe ("DataWindow.Objects")
l_nPos = 0
DO
	l_nIndex = l_nPos + 1
	l_nPos = pos (l_sMsg, "~t", l_nIndex)
	IF l_nPos > 0 THEN
		l_cObjName = Mid (l_sMsg, l_nIndex, (l_nPos - l_nIndex))
	ELSE
		l_cObjName = Mid (l_sMsg, l_nIndex)
	END IF
	IF pos (l_cObjName, "gb_") > 0 THEN
		l_nX = INTEGER (uo_search_criteria.dw_search_criteria.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (uo_search_criteria.dw_search_criteria.Describe (l_cObjName + ".Y")) + &
				 INTEGER (uo_search_criteria.dw_search_criteria.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP WHILE pos (l_sMsg, "~t", l_nIndex) > 0

// determine location of first field to add
IF l_nLastCol = -1 THEN  // if the last field was in a group box
	l_nColNum = 1
ELSE
	l_nX = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.X'))
	l_nY = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.Y'))
	l_nWidth = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.Width'))
	CHOOSE CASE (l_nX + l_nWidth)
		CASE IS > (col3labelX - 27)
			l_nColNum = 1
		CASE IS > (col2labelX - 27)
			l_nColNum = 3
		CASE ELSE
			l_nColNum = 2
	END CHOOSE
END IF

// add the new columns to the result set of the datawindow.
l_cSyntax = uo_search_criteria.dw_search_criteria.Describe("DataWindow.Syntax")
// add the new fields
FOR l_nIndex = 1 TO this.i_nNumConfigFields
	
	IF this.i_sSearchableCaseProps[l_nIndex].field_length = 0 THEN
		
		// skip over entries with field_length = 0 because they are for re-labeling only.
		CONTINUE
	
	ELSE
		// build the dbname parameter by combining the table and column names in dot notation.
		CHOOSE CASE this.i_cSourceType
			CASE 'C'
				l_sColName = 'consumer.'+this.i_sSearchableCaseProps[l_nIndex].column_name
			CASE 'E'
				l_sColName = 'employer_group.'+this.i_sSearchableCaseProps[l_nIndex].column_name
			CASE 'P'
				l_sColName = 'provider_of_service.'+this.i_sSearchableCaseProps[l_nIndex].column_name
			CASE 'O'
				l_sColName = 'other_source.'+this.i_sSearchableCaseProps[l_nIndex].column_name
		END CHOOSE
		
		// determine the width of the field to be displayed and the next field as well
		CHOOSE CASE (this.i_sSearchableCaseProps[l_nIndex].field_length * charwidth)
			CASE IS <= colwidth1
				l_nCellWidth = colwidth1
			CASE IS <= colwidth2
				l_nCellWidth = colwidth2
			CASE ELSE
				l_nCellWidth = colwidth3
		END CHOOSE
		
		IF (l_nIndex < this.i_nNumConfigFields) THEN
			CHOOSE CASE (this.i_sSearchableCaseProps[l_nIndex + 1].field_length * charwidth)
				CASE IS <= colwidth1
					l_nNextCellWidth = colwidth1
				CASE IS <= colwidth2
					l_nNextCellWidth = colwidth2
				CASE ELSE
					l_nNextCellWidth = colwidth3
			END CHOOSE
		ELSE
			l_nNextCellWidth = 0
		END IF
		
		// build the column definition and insert it into the syntax of the datawindow
//		l_nPos = Pos (l_cSyntax, "~r~ntable(")
//		DO WHILE Pos (l_cSyntax, "column=(", l_nPos + 1) > 0
//			l_nPos = Pos (l_cSyntax, "column=(", l_nPos + 1)
//		LOOP
//		l_nPos = Pos (l_cSyntax, "~r~n", l_nPos + 1)
//		l_cNewLine = "~r~n"
		
		l_nPos = Pos(l_cSyntax, "retrieve=")
		l_nPos = l_nPos - 1
	
		// For Other Source Types, allow database updates
		IF this.i_sSearchableCaseProps[l_nIndex].edit_mask = '##/##/####' THEN
			l_sModString = 'column=(type=date updatewhereclause=yes ' + &
								'name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSEIF this.i_sSearchableCaseProps[l_nIndex].edit_mask = '##/##/#### ##.##' THEN
			l_sModString = 'column=(type=datetime updatewhereclause=yes ' + &
								'name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSE 
			l_sModString = 'column=(type=char(50) updatewhereclause=yes ' + &
								'name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		END IF
		
		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)

/*		

JWhite Removed 12.20.2004
		// update the SQL SELECT portion of the datawindow
		l_nPos = Pos (l_cSyntax, 'retrieve="')
		DO WHILE Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1) > 0
			l_nPos = Pos (l_cSyntax, "COLUMN(NAME", l_nPos + 1)
		LOOP
		l_nPos = Pos (l_cSyntax, ')', l_nPos + 1)
		l_sModString = ' COLUMN(NAME=~~"cusfocus.'+l_sColName+'~~")'
		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
*/	
	
		IF this.i_sSearchableCaseProps[l_nIndex].visible = "Y" THEN
			//Set the visible variable
			l_cVisible = "1"
			
			// determine location of new objects
			CHOOSE CASE l_nColNum
				CASE 1
					l_cLabelX = STRING (col1labelX)
					l_cCellX = STRING (col1cellX)
					IF l_nLastCol = -1 THEN
						l_nMaxY = l_nMaxY + 28    // adjust for group box
						l_nLastCol = 0
					ELSE
						l_nMaxY = l_nMaxY + y_offset
					END IF
					
					// determine which column is next
					CHOOSE CASE (col1cellX + l_nCellWidth)
						CASE IS <= (col2labelX - 27)
							IF (col2cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 2
							ELSE
								l_nColNum = 1
							END IF
							
						CASE IS <= (col3labelX - 27)
							IF (col3cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 3
							ELSE
								l_nColNum = 1
							END IF
							
						CASE ELSE
							l_nColNum = 1
							
					END CHOOSE
					
				CASE 2	// column 2 of 3-column display
					l_cLabelX = STRING (col2labelX)
					l_cCellX = STRING (col2cellX)
					
					// If col 2 overlaps col 3, set next column to be col 1
					CHOOSE CASE (col2cellX + l_nCellWidth)
						CASE IS <= (col3labelX - 27)
							IF (col3cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 3
							ELSE
								l_nColNum = 1
							END IF
							
						CASE ELSE
							l_nColNum = 1
							
					END CHOOSE
					
				CASE 3
					l_cLabelX = STRING (col3labelX)
					l_cCellX = STRING (col3cellX)
					l_nColNum = 1
					
			END CHOOSE
			
			// add the new column label
			l_nPos = Pos (l_cSyntax, "htmltable") - 1
			l_sModString = 'text(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+'_t band=detail ' + &
								'font.charset="0" font.face="Tahoma" ' + &
								'font.family="2" font.height="-8" font.pitch="2" font.weight="700" ' + &
								'background.mode="1" background.color="536870912" color="0" alignment="0" ' + &
								'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" ' + &
								'width="'+labelwidth+'" text="'+this.i_sSearchableCaseProps[l_nIndex].field_label+':" )' + l_cNewLine
			uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
			
		ELSE
			l_cVisible = "0"
		END IF
			
		// prepare to add the new column
		l_nColCount = l_nColCount + 1
		IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable

/*		
		IF this.i_sSearchableCaseProps[l_nIndex].display_only = 'Y' THEN
			l_cDisplayOnly = 'yes'
		ELSE
			l_cDisplayOnly = 'no'
		END IF	
*/		
		// add the correct type of field to the datawindow
		l_nPos = Pos (l_cSyntax, "htmltable") - 1

// RAP - What's up with the Other type? I took this out so that edit masks would work		
//		IF IsNull(this.i_sSearchableCaseProps[l_nIndex].edit_mask) OR this.i_cSourceType <> 'O' THEN
		IF IsNull(this.i_sSearchableCaseProps[l_nIndex].edit_mask) THEN
			l_sModString = &
				'column(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=no edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (this.i_sSearchableCaseProps[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
		ELSE
			IF left(this.i_sSearchableCaseProps[l_nIndex].edit_mask, 10) = '##/##/####' THEN
				l_sModString = &
					'column(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' band=detail ' + &
					'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
					'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
					'border="5" alignment="0" format="'+this.i_sSearchableCaseProps[l_nIndex].display_format+'" ' + &
					'visible="'+l_cVisible+'" editmask.focusrectangle=no  ' + &
					'editmask.mask="'+this.i_sSearchableCaseProps[l_nIndex].edit_mask+'" editmask.ddcalendar=yes ' + &
					'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
					'background.mode="0" background.color="16777215" font.charset="0" ' + &
					'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
					'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
			ELSE
				l_sModString = &
					'column(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' band=detail ' + &
					'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
					'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
					'border="5" alignment="0" format="'+this.i_sSearchableCaseProps[l_nIndex].display_format+'" ' + &
					'visible="'+l_cVisible+'" editmask.focusrectangle=no editmask.autoskip=no editmask.required=no ' + &
					'editmask.readonly=no editmask.codetable=no editmask.spin=no ' + &
					'editmask.mask="'+this.i_sSearchableCaseProps[l_nIndex].edit_mask+'" editmask.imemode=0 ' + &
					'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
					'background.mode="0" background.color="16777215" font.charset="0" ' + &
					'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
					'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
			END IF
		END IF
		
		If lower(this.i_sSearchableCaseProps[l_nIndex].dropdown) = 'y' Then
			l_sModString = &
				'column(band=detail id='+STRING (l_nColCount)+' alignment="0" tabsequence=' + STRING (l_nTabSeq) + & 
				' border="5" color="0" x="' + l_cCellX + '" y="'+STRING (l_nMaxY)+'" ' + & 
				'height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" format="[general]" html.valueishtml="0"  name='+this.i_sSearchableCaseProps[l_nIndex].column_name + ' ' + & 
				'visible="1" dddw.name=dddw_caseprops_generic dddw.displaycolumn=casepropertiesvalues_value ' + & 
				'dddw.datacolumn=casepropertiesvalues_value dddw.percentwidth=0 dddw.lines=0 dddw.limit=0 ' + & 
				'dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.nilisnull=yes dddw.imemode=0 ' + &
				'dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" ' + & 
				'font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'

		End If
		

		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
		
	END IF
	
NEXT

// resize the detail band if necessary
IF (l_nMaxY + 64) > LONG (uo_search_criteria.dw_search_criteria.Object.Datawindow.Detail.Height) THEN

	l_nPos = Pos (l_cSyntax, "detail(height=") + 14
	l_nNumChars = Pos (l_cSyntax, " ", l_nPos) - l_nPos
	l_cSyntax = Replace (l_cSyntax, l_nPos, l_nNumChars, STRING (l_nMaxY + 76))
	
END IF

// re-initialize the datawindow
IF uo_search_criteria.dw_search_criteria.Create (l_cSyntax, l_sMsg) <> 1 THEN
	MessageBox (gs_AppName, 'An error has occurred trying to create the datawindow. The datawindow will be reset to the standard configuration.')
	RETURN 'error'
ELSE
	uo_search_criteria.dw_search_criteria.SetTransObject(SQLCA)

	// add any validation rules and error messages that are defined for the columns and re-label fields as needed.
	FOR l_nIndex = 1 to this.i_nNumConfigFields
		IF this.i_sSearchableCaseProps[l_nIndex].field_length = 0 THEN
		
			// apply the new label if appropriate
			l_cLabelName = this.i_sSearchableCaseProps[l_nIndex].column_name + "_t"
			IF uo_search_criteria.dw_search_criteria.Describe (l_cLabelName + ".Text") <> "!" THEN
	
				// update the label in the preview window if the label item exists
				l_cLabelText = gf_AllowQuotesInLabels (this.i_sSearchableCaseProps[l_nIndex].field_label)
				uo_search_criteria.dw_search_criteria.Modify (l_cLabelName + ".Text='" + l_cLabelText + ":'")
	
			END IF
			
			// get the parts of the combined label text
			IF Pos (l_cLabelName, '_city_t', 1) > 0 THEN l_cCity = l_cLabelText
			IF Pos (l_cLabelName, '_state_t', 1) > 0 THEN l_cState = l_cLabelText
			IF Pos (l_cLabelName, '_zip_t', 1) > 0 THEN l_cZip = l_cLabelText
			
		ELSEIF this.i_cSourceType = 'O' THEN
			
			// apply other changes as needed
			l_sColName = this.i_sSearchableCaseProps[l_nIndex].column_name
			IF uo_search_criteria.dw_search_criteria.Describe (l_sColName + ".EditMask.Mask") <> "" THEN
				IF this.i_sSearchableCaseProps[l_nIndex].validation_rule <> "" THEN
					l_sModString =  this.i_sSearchableCaseProps[l_nIndex].column_name + &
										'.Validation="'+this.i_sSearchableCaseProps[l_nIndex].validation_rule+'" '
					l_sMsg = uo_search_criteria.dw_search_criteria.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
					END IF
				END IF
				IF this.i_sSearchableCaseProps[l_nIndex].error_msg <> "" THEN
					l_sModString = l_sModString + this.i_sSearchableCaseProps[l_nIndex].column_name + &
										'.ValidationMsg="'+this.i_sSearchableCaseProps[l_nIndex].error_msg+'" '
					l_sMsg = uo_search_criteria.dw_search_criteria.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
					END IF
				END IF
			END IF
		END IF
		
	NEXT
	
	// update the combined City, State, Zip label if it exists
	IF uo_search_criteria.dw_search_criteria.Describe ("city_state_zip_t.Text") <> "!" THEN
		uo_search_criteria.dw_search_criteria.Modify ("city_state_zip_t.Text='" + l_cCity + ', ' + l_cState + ', ' + l_cZip + ":'")
	END IF
	
	RETURN ''
END IF


Return ''

end function

public function integer of_get_caseprops (string source_type);/*****************************************************************************************
	Function:	fw_buildfieldlist
	Purpose:		Add defined configurable fields to the field list for the selected source
	            type.
	Parameters:	STRING	source_type -> determine which set of configurable fields to add.
	Returns:		LONG ->	 0 - success
								-1 - failure
								
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	7/12/99  M. Caruso     Created.
	
	7/15/99  M. Caruso     Removed code to add fields to i_cCriteriaColumn[],
	                       i_cSearchColumn[] and i_cSearchTable[]
	5/3/2001 K. Claver     Enhanced to set invisible property for fields so are added to the
								  demographics configurable datawindow so can use as arguments for 
								  IIM tabs

*****************************************************************************************/
U_ContactHistory_FIELD_LIST	l_dsFields
LONG					l_nCount, l_nColIndex
S_FIELDPROPERTIES ls_null[]

// retrieve the list of fields for source_type from the database.
l_dsFields = CREATE u_contacthistory_field_list
l_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = 0

i_sSearchableCaseProps[] = ls_null[] 

i_nNumConfigFields = l_dsFields.Retrieve(source_type, is_contacthistory_casetype)
// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sSearchableCaseProps[l_nCount].column_name = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_column_name")
		IF IsNull (i_sSearchableCaseProps[l_nCount].column_name) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].column_name) = "") THEN
			i_sSearchableCaseProps[l_nCount].column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sSearchableCaseProps[l_nCount].field_label = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_field_label")
		IF IsNull (i_sSearchableCaseProps[l_nCount].field_label) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].field_label) = "") THEN
			i_sSearchableCaseProps[l_nCount].field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sSearchableCaseProps[l_nCount].field_length = l_dsFields.GetItemNumber(l_nCount, &
					"case_properties_field_def_field_length")
		IF IsNull (i_sSearchableCaseProps[l_nCount].field_length) THEN
			i_sSearchableCaseProps[l_nCount].field_length = 50
		END IF
		
		// get the "locked" parameter associated with this field
		i_sSearchableCaseProps[l_nCount].locked = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_locked")
		IF IsNull (i_sSearchableCaseProps[l_nCount].locked) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].locked) = "") THEN
			i_sSearchableCaseProps[l_nCount].locked = "N"
		END IF
/*		
		// Get the "searchable" parameter associated with this field
		i_sSearchableCaseProps[l_nCount].searchable = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_searchable_contacthistory")
		IF IsNull (i_sSearchableCaseProps[l_nCount].searchable) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].searchable) = "") THEN
			i_sSearchableCaseProps[l_nCount].searchable = "N"
		END IF
*/		
		// get the "display only" parameter associated with this field
		i_sSearchableCaseProps[l_nCount].display_only = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_display_only")
		IF IsNull (i_sSearchableCaseProps[l_nCount].display_only) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].display_only) = "") THEN
			i_sSearchableCaseProps[l_nCount].display_only = "N"
		END IF
		
		// get the edit mask associated with this field
		i_sSearchableCaseProps[l_nCount].edit_mask = l_dsFields.GetItemString(l_nCount, &
					"display_formats_edit_mask")
		IF IsNull (i_sSearchableCaseProps[l_nCount].edit_mask) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].edit_mask) = "") THEN
			i_sSearchableCaseProps[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sSearchableCaseProps[l_nCount].display_format = l_dsFields.GetItemString(l_nCount, &
					"display_formats_display_format")
		IF IsNull (i_sSearchableCaseProps[l_nCount].display_format) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].display_format) = "") THEN
			i_sSearchableCaseProps[l_nCount].display_format = '[general]'
		END IF
		
		// get the display name associated with this field
		i_sSearchableCaseProps[l_nCount].format_name = l_dsFields.GetItemString(l_nCount, &
					"display_formats_format_name")
		IF IsNull (i_sSearchableCaseProps[l_nCount].format_name) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].format_name) = "") THEN
			i_sSearchableCaseProps[l_nCount].format_name = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sSearchableCaseProps[l_nCount].validation_rule = l_dsFields.GetItemString(l_nCount, &
					"display_formats_validation_rule")
		IF IsNull (i_sSearchableCaseProps[l_nCount].validation_rule) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].validation_rule) = "") THEN
			i_sSearchableCaseProps[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sSearchableCaseProps[l_nCount].error_msg = l_dsFields.GetItemString(l_nCount, &
					"display_formats_error_msg")
		IF IsNull (i_sSearchableCaseProps[l_nCount].error_msg) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].error_msg) = "") THEN
			i_sSearchableCaseProps[l_nCount].error_msg = ''
		END IF
		
		// get the visible setting associated with this field
		i_sSearchableCaseProps[l_nCount].visible = l_dsFields.GetItemString(l_nCount, &
					"case_properties_field_def_visible")
		IF IsNull (i_sSearchableCaseProps[l_nCount].visible) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].visible) = "") THEN
			i_sSearchableCaseProps[l_nCount].visible = ''
		END IF
		
		// get the visible setting associated with this field
		i_sSearchableCaseProps[l_nCount].dropdown = l_dsFields.GetItemString(l_nCount, &
					"dropdown")
		IF IsNull (i_sSearchableCaseProps[l_nCount].dropdown) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].dropdown) = "") THEN
			i_sSearchableCaseProps[l_nCount].dropdown = ''
		END IF


//		// add any searchable fields to the related search window instance variables.
//		IF i_sSearchableCaseProps[l_nCount].searchable = 'Y' THEN
//			l_nColIndex = UpperBound(uo_search_criteria.i_cCriteriaColumn) + 1
//			uo_search_criteria.i_cCriteriaColumn[l_nColIndex] = i_sSearchableCaseProps[l_nCount].column_name
//			uo_search_criteria.i_cSearchColumn[l_nColIndex] = i_sSearchableCaseProps[l_nCount].column_name
//			// set the search table = to the table of the previous column
//			uo_search_criteria.i_cSearchTable[l_nColIndex] = uo_search_criteria.i_cSearchTable[l_nColIndex - 1]
//		END IF
	NEXT
END IF

// remove the datastore from memory
DESTROY l_dsFields

RETURN 0
end function

public function string of_add_appeal_properties ();//CONSTANT	INTEGER	col1labelX = 27
//CONSTANT	INTEGER	col2labelX = 1010
//CONSTANT	INTEGER	col3labelX = 1993
//CONSTANT	INTEGER	col1cellX = 554
//CONSTANT	INTEGER	col2cellX = 1537
//CONSTANT	INTEGER	col3cellX = 2520
//CONSTANT INTEGER  rightmargin = 3164
//CONSTANT INTEGER	colwidth1 = 429
//CONSTANT INTEGER	colwidth2 = 1412
//CONSTANT INTEGER	colwidth3 = 2395
//CONSTANT STRING	labelwidth = '500'
//CONSTANT STRING	cellheight = '64'
//CONSTANT INTEGER	charwidth = 40
//CONSTANT INTEGER	y_offset = 92

CONSTANT	INTEGER	col1labelX = 25		//These move the added labels left/right
CONSTANT	INTEGER	col2labelX = 1100 
CONSTANT	INTEGER	col3labelX = 2175

CONSTANT	INTEGER	col1cellX = 459		//These move the added columns left/right
CONSTANT	INTEGER	col2cellX = 1539
CONSTANT	INTEGER	col3cellX = 2612

CONSTANT INTEGER  rightmargin = 5500

CONSTANT INTEGER	colwidth1 = 407
CONSTANT INTEGER	colwidth2 = 407
CONSTANT INTEGER	colwidth3 = 407

CONSTANT STRING	labelwidth = '425'
CONSTANT STRING	cellheight = '64'
CONSTANT INTEGER	charwidth = 40
CONSTANT INTEGER	y_offset = 92



LONG		l_nColCount, l_nMaxX, l_nMaxY, l_nX, l_nY, l_nIndex, l_nPos
INTEGER	l_nColNum, l_nLastCol, l_nWidth, l_nNewColId, l_nTabSeq
INTEGER  l_nNewTabSeq, l_nNumChars, l_nCellWidth, l_nNextCellWidth
STRING	l_sColName, l_sModString, l_sMsg, l_cSyntax, l_cObjName, l_cVisible
STRING	l_cDisplayOnly, l_cNewLine, l_cLabelX, l_cCellX, l_cUpdate
STRING	l_cLabelName, l_cLabelText, l_cCity, l_cState, l_cZip
INTEGER li_return
STRING ls_error

//Recreate the datawindow to make sure the columns don't just keep getting added on
li_return = uo_search_criteria.dw_search_criteria.Create(uo_search_criteria.is_origingal_search_syntax, ls_error)

// determine the location of the last predefined column in the datawindow
l_nColCount = LONG (uo_search_criteria.dw_search_criteria.Object.Datawindow.Column.Count)

FOR l_nIndex = 1 TO l_nColCount
	IF uo_search_criteria.dw_search_criteria.Describe ('#' + STRING (l_nIndex) + '.Visible') = '1' THEN
		l_sColName = uo_search_criteria.dw_search_criteria.Describe ('#' + STRING (l_nIndex) + '.Name')
		l_nX = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.X'))
		l_nY = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.Y'))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxX = l_nX
			l_nMaxY = l_nY
			l_nLastCol = l_nIndex
		ELSEIF (l_nY = l_nMaxY) THEN
			IF l_nX > l_nMaxX THEN
				l_nMaxX = l_nX
				l_nLastCol = l_nIndex
			END IF
		END IF
		
		// calculate the highest used Tab Sequence Value
		l_nNewTabSeq = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nIndex) + '.tabsequence'))
		IF l_nTabSeq < l_nNewTabSeq THEN
			l_nTabSeq = l_nNewTabSeq
		END IF
	END IF
NEXT

// determine if last field is in a group box and prep accordingly
l_sMsg = uo_search_criteria.dw_search_criteria.Describe ("DataWindow.Objects")
l_nPos = 0
DO
	l_nIndex = l_nPos + 1
	l_nPos = pos (l_sMsg, "~t", l_nIndex)
	IF l_nPos > 0 THEN
		l_cObjName = Mid (l_sMsg, l_nIndex, (l_nPos - l_nIndex))
	ELSE
		l_cObjName = Mid (l_sMsg, l_nIndex)
	END IF
	IF pos (l_cObjName, "gb_") > 0 THEN
		l_nX = INTEGER (uo_search_criteria.dw_search_criteria.Describe (l_cObjName + ".X"))
		l_nY = INTEGER (uo_search_criteria.dw_search_criteria.Describe (l_cObjName + ".Y")) + &
				 INTEGER (uo_search_criteria.dw_search_criteria.Describe (l_cObjName + ".Height"))
		IF (l_nY > l_nMaxY) THEN
			l_nMaxY = l_nY
			l_nMaxX = col1cellX
			l_nLastCol = -1
		END IF
	END IF
LOOP WHILE pos (l_sMsg, "~t", l_nIndex) > 0

// determine location of first field to add
IF l_nLastCol = -1 THEN  // if the last field was in a group box
	l_nColNum = 1
ELSE
	l_nX = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.X'))
	l_nY = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.Y'))
	l_nWidth = INTEGER (uo_search_criteria.dw_search_criteria.Describe("#" + STRING(l_nLastCol) + '.Width'))
	CHOOSE CASE (l_nX + l_nWidth)
		CASE IS > (col3labelX - 27)
			l_nColNum = 1
		CASE IS > (col2labelX - 27)
			l_nColNum = 3
		CASE ELSE
			l_nColNum = 2
	END CHOOSE
END IF

// add the new columns to the result set of the datawindow.
l_cSyntax = uo_search_criteria.dw_search_criteria.Describe("DataWindow.Syntax")
// add the new fields
FOR l_nIndex = 1 TO this.i_nNumConfigFields
	
	IF this.i_sSearchableCaseProps[l_nIndex].field_length = 0 THEN
		
		// skip over entries with field_length = 0 because they are for re-labeling only.
		CONTINUE
	
	ELSE
		l_sColName = this.i_sSearchableCaseProps[l_nIndex].column_name
		
		// determine the width of the field to be displayed and the next field as well
		CHOOSE CASE (this.i_sSearchableCaseProps[l_nIndex].field_length * charwidth)
			CASE IS <= colwidth1
				l_nCellWidth = colwidth1
			CASE IS <= colwidth2
				l_nCellWidth = colwidth2
			CASE ELSE
				l_nCellWidth = colwidth3
		END CHOOSE
		
		IF (l_nIndex < this.i_nNumConfigFields) THEN
			CHOOSE CASE (this.i_sSearchableCaseProps[l_nIndex + 1].field_length * charwidth)
				CASE IS <= colwidth1
					l_nNextCellWidth = colwidth1
				CASE IS <= colwidth2
					l_nNextCellWidth = colwidth2
				CASE ELSE
					l_nNextCellWidth = colwidth3
			END CHOOSE
		ELSE
			l_nNextCellWidth = 0
		END IF
		
		
		l_nPos = Pos(l_cSyntax, "retrieve=")
		l_nPos = l_nPos - 1
	
		// For date properties, make it a date field so that the dropdown calendar works
		IF this.i_sSearchableCaseProps[l_nIndex].edit_mask = '##/##/####' THEN
			l_sModString = 'column=(type=date updatewhereclause=yes ' + &
								'name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSEIF this.i_sSearchableCaseProps[l_nIndex].edit_mask = '##/##/#### ##.##' THEN
			l_sModString = 'column=(type=datetime updatewhereclause=yes ' + &
								'name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		ELSE 
			l_sModString = 'column=(type=char(50) updatewhereclause=yes ' + &
								'name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' ' + &
								'dbname="'+l_sColName+'" )' + l_cNewline
		END IF
		
		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)

		IF this.i_sSearchableCaseProps[l_nIndex].visible = "Y" THEN
			//Set the visible variable
			l_cVisible = "1"
			
			// determine location of new objects
			CHOOSE CASE l_nColNum
				CASE 1
					l_cLabelX = STRING (col1labelX)
					l_cCellX = STRING (col1cellX)
					IF l_nLastCol = -1 THEN
						l_nMaxY = l_nMaxY + 28    // adjust for group box
						l_nLastCol = 0
					ELSE
						l_nMaxY = l_nMaxY + y_offset
					END IF
					
					// determine which column is next
					CHOOSE CASE (col1cellX + l_nCellWidth)
						CASE IS <= (col2labelX - 27)
							IF (col2cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 2
							ELSE
								l_nColNum = 1
							END IF
							
						CASE IS <= (col3labelX - 27)
							IF (col3cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 3
							ELSE
								l_nColNum = 1
							END IF
							
						CASE ELSE
							l_nColNum = 1
							
					END CHOOSE
					
				CASE 2	// column 2 of 3-column display
					l_cLabelX = STRING (col2labelX)
					l_cCellX = STRING (col2cellX)
					
					// If col 2 overlaps col 3, set next column to be col 1
					CHOOSE CASE (col2cellX + l_nCellWidth)
						CASE IS <= (col3labelX - 27)
							IF (col3cellX + l_nNextCellWidth) <= rightmargin THEN
								l_nColNum = 3
							ELSE
								l_nColNum = 1
							END IF
							
						CASE ELSE
							l_nColNum = 1
							
					END CHOOSE
					
				CASE 3
					l_cLabelX = STRING (col3labelX)
					l_cCellX = STRING (col3cellX)
					l_nColNum = 1
					
			END CHOOSE
			
			// add the new column label
			l_nPos = Pos (l_cSyntax, "htmltable") - 1
			l_sModString = 'text(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+'_t band=detail ' + &
								'font.charset="0" font.face="Tahoma" ' + &
								'font.family="2" font.height="-8" font.pitch="2" font.weight="700" ' + &
								'background.mode="1" background.color="536870912" color="0" alignment="0" ' + &
								'border="0" x="'+l_cLabelX+'" y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" ' + &
								'width="'+labelwidth+'" text="'+this.i_sSearchableCaseProps[l_nIndex].field_label+':" )' + l_cNewLine
			uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
			
		ELSE
			l_cVisible = "0"
		END IF
			
		// prepare to add the new column
		l_nColCount = l_nColCount + 1
		IF l_nTabSeq > 0 THEN l_nTabSeq = l_nTabSeq + 10  // prevent if datawindow not updateable

		// add the correct type of field to the datawindow
		l_nPos = Pos (l_cSyntax, "htmltable") - 1
		
		IF IsNull(this.i_sSearchableCaseProps[l_nIndex].edit_mask) OR LEN(this.i_sSearchableCaseProps[l_nIndex].edit_mask) = 0  THEN
			// determine the value for edit.limit
			l_sModString = &
				'column(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' band=detail ' + &
				'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
				'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
				'border="5" alignment="0" format="[general]" visible="'+l_cVisible+'" edit.focusrectangle=no ' + &
				'edit.autohscroll=no edit.autoselect=yes edit.autovscroll=no edit.case=any ' + &
				'edit.codetable=no edit.displayonly=no edit.hscrollbar=no ' + &
				'edit.imemode=0 edit.limit='+STRING (this.i_sSearchableCaseProps[l_nIndex].field_length)+' ' + &
				'edit.password=no edit.vscrollbar=no edit.validatecode=no edit.nilisnull=yes ' + &
				'edit.required=no criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
				'background.mode="0" background.color="16777215" font.charset="0" ' + &
				'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
				'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
		ELSE
			IF left(this.i_sSearchableCaseProps[l_nIndex].edit_mask, 10) = '##/##/####' THEN
				l_sModString = &
					'column(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' band=detail ' + &
					'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
					'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
					'border="5" alignment="0" format="'+this.i_sSearchableCaseProps[l_nIndex].display_format+'" ' + &
					'visible="'+l_cVisible+'" editmask.focusrectangle=no  ' + &
					'editmask.mask="'+this.i_sSearchableCaseProps[l_nIndex].edit_mask+'" editmask.ddcalendar=yes ' + &
					'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
					'background.mode="0" background.color="16777215" font.charset="0" ' + &
					'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
					'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
			ELSE
				l_sModString = &
					'column(name='+this.i_sSearchableCaseProps[l_nIndex].column_name+' band=detail ' + &
					'id='+STRING (l_nColCount)+' x="'+l_cCellX+'" ' + &
					'y="'+STRING (l_nMaxY)+'" height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" color="0" ' + &
					'border="5" alignment="0" format="'+this.i_sSearchableCaseProps[l_nIndex].display_format+'" ' + &
					'visible="'+l_cVisible+'" editmask.focusrectangle=no editmask.autoskip=no editmask.required=no ' + &
					'editmask.readonly=no editmask.codetable=no editmask.spin=no ' + &
					'editmask.mask="'+this.i_sSearchableCaseProps[l_nIndex].edit_mask+'" editmask.imemode=0 ' + &
					'criteria.required=no criteria.override_edit=no crosstab.repeat=no ' + &
					'background.mode="0" background.color="16777215" font.charset="0" ' + &
					'font.face="Tahoma" font.family="2" font.height="-8" font.pitch="2" ' + &
					'font.weight="400" tabsequence='+STRING (l_nTabSeq)+' )' + l_cNewLine
				END IF
		END IF
		
		If lower(this.i_sSearchableCaseProps[l_nIndex].dropdown) = 'y' Then
			l_sModString = &
				'column(band=detail id='+STRING (l_nColCount)+' alignment="0" tabsequence=' + STRING (l_nTabSeq) + & 
				' border="5" color="0" x="' + l_cCellX + '" y="'+STRING (l_nMaxY)+'" ' + & 
				'height="'+cellheight+'" width="'+STRING (l_nCellWidth)+'" format="[general]" html.valueishtml="0"  name='+this.i_sSearchableCaseProps[l_nIndex].column_name + ' ' + & 
				'visible="1" dddw.name=dddw_appealprops_generic dddw.displaycolumn=appealpropertiesvalues_value ' + & 
				'dddw.datacolumn=appealpropertiesvalues_value dddw.percentwidth=0 dddw.lines=0 dddw.limit=0 ' + & 
				'dddw.allowedit=no dddw.useasborder=yes dddw.case=any dddw.nilisnull=yes dddw.imemode=0 ' + &
				'dddw.vscrollbar=yes  font.face="Tahoma" font.height="-8" font.weight="400"  font.family="2" ' + & 
				'font.pitch="2" font.charset="0" background.mode="2" background.color="16777215" )'

		End If
		

		uf_StringInsert(l_cSyntax, l_sModString, l_nPos)
		
	END IF
	
NEXT

// resize the detail band if necessary
IF (l_nMaxY + 64) > LONG (uo_search_criteria.dw_search_criteria.Object.Datawindow.Detail.Height) THEN

	l_nPos = Pos (l_cSyntax, "detail(height=") + 14
	l_nNumChars = Pos (l_cSyntax, " ", l_nPos) - l_nPos
	l_cSyntax = Replace (l_cSyntax, l_nPos, l_nNumChars, STRING (l_nMaxY + 76))
	
END IF

// re-initialize the datawindow
IF uo_search_criteria.dw_search_criteria.Create (l_cSyntax, l_sMsg) <> 1 THEN
	MessageBox (gs_AppName, 'An error has occurred trying to create the datawindow. The datawindow will be reset to the standard configuration.')
	RETURN 'error'
ELSE
	uo_search_criteria.dw_search_criteria.SetTransObject(SQLCA)

	// add any validation rules and error messages that are defined for the columns and re-label fields as needed.
	FOR l_nIndex = 1 to this.i_nNumConfigFields
		IF this.i_sSearchableCaseProps[l_nIndex].field_length = 0 THEN
		
			// apply the new label if appropriate
			l_cLabelName = this.i_sSearchableCaseProps[l_nIndex].column_name + "_t"
			IF uo_search_criteria.dw_search_criteria.Describe (l_cLabelName + ".Text") <> "!" THEN
	
				// update the label in the preview window if the label item exists
				l_cLabelText = gf_AllowQuotesInLabels (this.i_sSearchableCaseProps[l_nIndex].field_label)
				uo_search_criteria.dw_search_criteria.Modify (l_cLabelName + ".Text='" + l_cLabelText + ":'")
	
			END IF
			
			// get the parts of the combined label text
			IF Pos (l_cLabelName, '_city_t', 1) > 0 THEN l_cCity = l_cLabelText
			IF Pos (l_cLabelName, '_state_t', 1) > 0 THEN l_cState = l_cLabelText
			IF Pos (l_cLabelName, '_zip_t', 1) > 0 THEN l_cZip = l_cLabelText
			
		ELSEIF this.i_cSourceType = 'O' THEN
			
			// apply other changes as needed
			l_sColName = this.i_sSearchableCaseProps[l_nIndex].column_name
			IF uo_search_criteria.dw_search_criteria.Describe (l_sColName + ".EditMask.Mask") <> "" THEN
				IF this.i_sSearchableCaseProps[l_nIndex].validation_rule <> "" THEN
					l_sModString =  this.i_sSearchableCaseProps[l_nIndex].column_name + &
										'.Validation="'+this.i_sSearchableCaseProps[l_nIndex].validation_rule+'" '
					l_sMsg = uo_search_criteria.dw_search_criteria.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation message for the current column.")
					END IF
				END IF
				IF this.i_sSearchableCaseProps[l_nIndex].error_msg <> "" THEN
					l_sModString = l_sModString + this.i_sSearchableCaseProps[l_nIndex].column_name + &
										'.ValidationMsg="'+this.i_sSearchableCaseProps[l_nIndex].error_msg+'" '
					l_sMsg = uo_search_criteria.dw_search_criteria.Modify(l_sModString)
					IF l_sMsg <> "" THEN
						MessageBox (gs_AppName,"Unable to define the validation error message for the current column.")
					END IF
				END IF
			END IF
		END IF
		
	NEXT
	

	// update the combined City, State, Zip label if it exists
	IF uo_search_criteria.dw_search_criteria.Describe ("city_state_zip_t.Text") <> "!" THEN
		uo_search_criteria.dw_search_criteria.Modify ("city_state_zip_t.Text='" + l_cCity + ', ' + l_cState + ', ' + l_cZip + ":'")
	END IF
	
	RETURN ''
END IF


Return ''

end function

public function integer of_get_appealprops (long source_type);datastore	l_dsFields
LONG					l_nCount, l_nColIndex
S_FIELDPROPERTIES ls_null[]

// retrieve the list of fields for source_type from the database.
l_dsFields = CREATE datastore
l_dsFields.dataobject = "d_appeal_props"
l_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = 0

i_sSearchableCaseProps[] = ls_null[] 

i_nNumConfigFields = l_dsFields.Retrieve(source_type)
// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sSearchableCaseProps[l_nCount].column_name = l_dsFields.GetItemString(l_nCount, &
					"column_name")
		IF IsNull (i_sSearchableCaseProps[l_nCount].column_name) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].column_name) = "") THEN
			i_sSearchableCaseProps[l_nCount].column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sSearchableCaseProps[l_nCount].field_label = l_dsFields.GetItemString(l_nCount, &
					"field_label")
		IF IsNull (i_sSearchableCaseProps[l_nCount].field_label) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].field_label) = "") THEN
			i_sSearchableCaseProps[l_nCount].field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sSearchableCaseProps[l_nCount].field_length = l_dsFields.GetItemNumber(l_nCount, &
					"field_length")
		IF IsNull (i_sSearchableCaseProps[l_nCount].field_length) THEN
			i_sSearchableCaseProps[l_nCount].field_length = 50
		END IF
		
		// get the "locked" parameter associated with this field
		i_sSearchableCaseProps[l_nCount].locked = l_dsFields.GetItemString(l_nCount, &
					"locked")
		IF IsNull (i_sSearchableCaseProps[l_nCount].locked) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].locked) = "") THEN
			i_sSearchableCaseProps[l_nCount].locked = "N"
		END IF
		
		// get the "display only" parameter associated with this field
		i_sSearchableCaseProps[l_nCount].display_only = l_dsFields.GetItemString(l_nCount, &
					"display_only")
		IF IsNull (i_sSearchableCaseProps[l_nCount].display_only) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].display_only) = "") THEN
			i_sSearchableCaseProps[l_nCount].display_only = "N"
		END IF
		
		// get the edit mask associated with this field
		i_sSearchableCaseProps[l_nCount].edit_mask = l_dsFields.GetItemString(l_nCount, &
					"edit_mask")
		IF IsNull (i_sSearchableCaseProps[l_nCount].edit_mask) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].edit_mask) = "") THEN
			i_sSearchableCaseProps[l_nCount].edit_mask = ""
		END IF
		
		// get the display format associated with this field
		i_sSearchableCaseProps[l_nCount].display_format = l_dsFields.GetItemString(l_nCount, &
					"display_format")
		IF IsNull (i_sSearchableCaseProps[l_nCount].display_format) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].display_format) = "") THEN
			i_sSearchableCaseProps[l_nCount].display_format = '[general]'
		END IF
		
		// get the display name associated with this field
		i_sSearchableCaseProps[l_nCount].format_name = l_dsFields.GetItemString(l_nCount, &
					"format_name")
		IF IsNull (i_sSearchableCaseProps[l_nCount].format_name) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].format_name) = "") THEN
			i_sSearchableCaseProps[l_nCount].format_name = '[general]'
		END IF
		
		// get the validation rule associated with this field
		i_sSearchableCaseProps[l_nCount].validation_rule = l_dsFields.GetItemString(l_nCount, &
					"validation_rule")
		IF IsNull (i_sSearchableCaseProps[l_nCount].validation_rule) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].validation_rule) = "") THEN
			i_sSearchableCaseProps[l_nCount].validation_rule = ''
		END IF
		
		// get the error message associated with this field
		i_sSearchableCaseProps[l_nCount].error_msg = l_dsFields.GetItemString(l_nCount, &
					"error_msg")
		IF IsNull (i_sSearchableCaseProps[l_nCount].error_msg) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].error_msg) = "") THEN
			i_sSearchableCaseProps[l_nCount].error_msg = ''
		END IF
		
		// get the visible setting associated with this field
		i_sSearchableCaseProps[l_nCount].visible = l_dsFields.GetItemString(l_nCount, &
					"visible")
		IF IsNull (i_sSearchableCaseProps[l_nCount].visible) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].visible) = "") THEN
			i_sSearchableCaseProps[l_nCount].visible = ''
		END IF
		
		// get the visible setting associated with this field
		i_sSearchableCaseProps[l_nCount].dropdown = l_dsFields.GetItemString(l_nCount, &
					"dropdown")
		IF IsNull (i_sSearchableCaseProps[l_nCount].dropdown) OR &
			(Trim (i_sSearchableCaseProps[l_nCount].dropdown) = "") THEN
			i_sSearchableCaseProps[l_nCount].dropdown = ''
		END IF

	NEXT
END IF

// remove the datastore from memory
DESTROY l_dsFields

RETURN 0
end function

event pc_save;//**********************************************************************************************
//
//  Event:   pc_save
//  Purpose: To save the modifications to the current process: Case Subject, Case Detail (Inquiry, 
//           Issue/Concern, Configurable, Pro-Active), Case Correspondence, and Case Reminders.
//              
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  06/10/99 M. Caruso   for cases 3-6, set the ket values before continuing the save process.  
//                       This should be done in the underlying code, but it is no longer 
//							    functioning properly that way.
//  06/11/99 M. Caruso   checks for an existing case number before assigning a new one in tabs 
//                       3-6.
//  09/30/99 M. Caruso   Enabled the m_viewcasedetailreport menu item when saving a case.
//  10/17/00 M. Caruso   Modified to work with the new Case Detail setup.
//  11/28/00 M. Caruso   Added code to prompt for the saving of modified case notes, including 
//                       that in the save process of the case.
//  12/11/00 K. Claver   Added code to save the case properties tab.
//  12/21/00 M. Caruso   Added code to verify that note text exists before trying to save a case 
//                       note.
//  12/29/00 K. Claver   Added code to check the save of the case properties inquiry tab and 
//                       rollback the save of the case properties if it fails.
//  01/10/01 M. Caruso   Removed current code for saving a case and replaced it with a call to 
//                       fu_savecase ().
//  01/13/01 M. Caruso   Created a separate CASE statement for CASE 3.  This handles contact note 
//                       saving alone.
//  03/27/01 C. Jackson  Enable the Special Flags button after successful save of Other Case Type
//                       SCR  1443.
//  06/26/01 C. Jackson  Set the case_log_xref_source_type to null if there is no case_log_xref
//                       subject_id.  Set it back to default of Provider after the save.
//  07/05/01 C. Jackson  Only look at Cross Reference stuff if this is not a pro-active case 
//                       (SCR 2048)
//  01/03/02 M. Caruso   In Case 7, set the docimage parameter of the uf_SaveCorrespondence call
//                       as NULL to prevent upating when appropriate.
//  01/23/02 C. Jackson  Add security to prevent a user with inadequate security from seeing the
//                       Cross Referenced Name.  ('Access Denied' is displayed)
//  03/29/02 M. Caruso   Abort the save process for correspondence if the doc image is NULL.
//  05/30/02 C. Jackson  Remove Cross Reference - processed in u_tabpage_case_details
//  5/30/2002 K. Claver  Removed code that depended on the i_bNoChange variable(used to be
//								 on the case details tabpage) to decide whether to save the changes
//								 to the case as it was interfering with saving changes to case properties.
//  9/26/2002 K. Claver  Removed l_bAutoCommit boolean variable.
//**********************************************************************************************

LONG				l_nReturn, l_nRow, l_nPos, l_nDemogSecurity
STRING			l_sCaseNumber, l_cNoteText, l_cXRefSubjectID,l_cNull, l_cProviderKey
STRING         l_cXRefCCSubject, l_cProviderType, l_cName, l_cName2, l_cName3, l_cSavedXRef
STRING         l_cSavedXRefSource
U_DW_STD			l_dwCaseDetails, l_dwNoteEntry, l_dwCaseProperties, l_dwCasePropInq
U_DW_STD			l_dwCorrDetails
BOOLEAN 			l_bNoSave
DWItemStatus   l_dwisStatus
BLOB				l_blbDocImage

SETNULL(l_cNull)
//--------------------------------------------------------------------------------------
// Determine which tab is active in order to determine what process we are dealing with.
//--------------------------------------------------------------------------------------
CHOOSE CASE dw_folder.i_SelectedTab
	CASE 1, 4, 6	//	Search, Contact History, Cross Reference --> Save the current Case Detail
		//-------------------------------------------------------------------------------------
		//		Determine the Case Type, save the Case, and place the user back in the case tab.
		//--------------------------------------------------------------------------------------
		IF ISVALID (i_uoCaseDetails) THEN
//			l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
//			l_dwCaseDetails.fu_Save (l_dwCaseDetails.c_SaveChanges)
			
			i_uoCaseDetails.fu_SaveCase (i_uoCaseDetails.c_SaveChanges)
			
			dw_folder.fu_EnableTab(5)
			dw_folder.fu_SelectTab(5)
			i_bNeedCaseSubject = FALSE
		END IF
		
	CASE 2	//	Demographics	--> Save Case Subject AND Case Detail if required.

		//------------------------------------------------------------------------------------
		// If the Window and User Object are Valid, and the Source Type is Other THEN
		// check to see if there are any modifications.  If there are, save them, otherwise
		// inform the user they have not made any changes to save.
		//-------------------------------------------------------------------------------------
		IF IsValid(i_uoDemographics) THEN
			
			IF i_uoDemographics.dw_demographics.DataObject = 'd_demographics_other' THEN
				l_nReturn = i_uoDemographics.dw_demographics.fu_Save(&
									i_uoDemographics.dw_demographics.c_SaveChanges)
	
				IF i_bNeedCaseSubject AND l_nReturn = c_Success THEN
					
					IF ISVALID(i_uoCaseDetails) THEN
//						l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
//						l_dwCaseDetails.fu_Save (l_dwCaseDetails.c_SaveChanges)
						
						//-----------------------------------------------------------------------------------------------------------------------------------
						// Added ib_converted_casetype to FALSE line to try and only
						// check required fields on save, not on tab switch alone.
						//-----------------------------------------------------------------------------------------------------------------------------------
						i_uoCaseDetails.ib_converted_casetype = FALSE
						i_uoCaseDetails.fu_SaveCase (i_uoCaseDetails.c_SaveChanges)
						
						dw_folder.fu_EnableTab(5)
						dw_folder.fu_SelectTab(5)
						i_bNeedCaseSubject = FALSE
					END IF
					
				END IF
				
					m_create_maintain_case.m_edit.m_addspecialflags.Enabled = TRUE
				
			END IF
			
		END IF
		
	CASE 3	// Contact Notes tab --> save the current contact note.
		//Contact Notes tab
		IF IsValid( i_uoContactNotes ) THEN
			i_uoContactNotes.cb_save.Event Trigger clicked( )
		END IF

	CASE 5	//	Case Tab	-->	Save the current case
		IF ISVALID (i_uoCaseDetails) THEN
		
			l_dwCaseDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
			l_dwNoteEntry = i_uoCaseDetails.dw_case_note_entry
			l_dwCaseProperties = i_uoCaseDetails.tab_folder.tabpage_case_properties.dw_case_properties
			
			l_nRow = l_dwCaseDetails.GetRow ()
			l_sCaseNumber = l_dwCaseDetails.GetItemString (l_nRow, "case_log_case_number")
			IF IsNull (l_sCaseNumber) OR (l_sCaseNumber = "") THEN
				l_dwCaseDetails.Event pcd_SetKey (SQLCA)
			END IF
			
			i_uoCaseDetails.fu_SaveCase(i_uoCaseDetails.c_savechanges)
		END IF

	CASE 7	//	Case Correspondence	-->	 Save the Case Correspondence

		IF IsValid(i_uoCaseCorrespondence) THEN
			
			l_dwCorrDetails = i_uoCaseCorrespondence.dw_correspondence_detail
			IF IsNull (i_uoCaseCorrespondence.i_blbDocImage) THEN
				MessageBox (gs_appname, 'The specified document is blank.  Please notify your system administrator.')
			ELSE
				
				IF i_uoCaseCorrespondence.i_bUpdateDocImage THEN
					// allow updating of the current doc image stored in the database
					l_blbDocImage = i_uoCaseCorrespondence.i_blbDocImage
				ELSE
					// prevent updating of the current image.
					SetNull (l_blbDocImage)
				END IF
				i_uoCaseCorrespondence.i_uoDocMgr.uf_SaveCorrespondence (l_dwCorrDetails, l_blbDocImage)
				
			END IF
			
		END IF

	CASE 8	//	Case Reminders	-->	Save the Case Reminders

		IF ISValid(i_uoCaseReminders) THEN
				i_uoCaseReminders.dw_case_reminder.fu_Save(&
							i_uoCaseReminders.dw_case_reminder.c_SaveChanges)
	 	END IF
		 
END CHOOSE

end event

event pc_new;//*********************************************************************************************
//
//  Event:   pc_new
//  Purpose: To create a New Other Source record.
//  
//  Date
//  -------- ----------- ----------------------------------------------------------------------
//  08/10/99 M. Caruso   If the current tab is 1 or 2, build the list of configurable fields for 
//                       Other Source types.  Also perform InsertRow if dw_demographics needs to 
//				   			 be updated with the configurable fields.
//  08/23/99 M. Caruso   Add the CTRL+S shortcut notation to the updated name for m_save.
//  09/21/00 M. Caruso   Commented out references to dw_case_history onuo_demographics.
//  01/18/01 M. Caruso   Changed save condition for correspondence and reminders to 
//                       c_PromptChanges from c_SaveChanges.
//  03/06/01 C. Jackson  Make dw_display_special_flags not visible (SCR 1443)
//  03/19/01 K. Claver   Moved code to make dw_display_special_flags invisible to after the code
//								 that instantiates the demographics user object.
//  04/10/02 K. Claver   Added call to fu_Reset on the special flags datawindow on the demographics
//								 tab when adding new other case subject.
//*********************************************************************************************

LONG 				l_nReturn
WINDOWOBJECT 	l_woTabObject[]
DATAWINDOWCHILD	l_dwcLetterTypes

//-------------------------------------------------------------------------------------
//		Determine which tab is active to know what to do...
//------------------------------------------------------------------------------------

CHOOSE CASE dw_folder.i_SelectedTab

	CASE 1, 2  	//  	Search or Demographics --> New Case Subject

		IF dw_folder.i_SelectedTab = 2 THEN // In case you just added one and haven't saved it yet
			l_nReturn = THIS.fw_checkothertabs()
			IF l_nReturn = -1 THEN RETURN
		END IF
		//-------------------------------------------------------------------------------------
		//		Get the current Source Type, CaseSubjectID and CaseSubjectName prior to
		//		creating a New Case subject in the event the Search Criteria is NOT an Other Source
		//		and this way we will be able to keep the above in sync.
		//--------------------------------------------------------------------------------------

		i_cPreviousSourceType = i_cSourceType
		i_cPreviousCaseSubject = i_cCurrentCaseSubject
		i_cPreviousCaseSubjectName = i_cCaseSubjectName

		i_cCurrentCaseSubject = ''
		i_cCaseSubjectName = ''
		i_cSourceType = 'O'
		IF NOT i_bNeedCaseSubject THEN
			i_cSelectedCase = ''
			i_cCaseType = ''
		END IF

		i_bNewCaseSubject = TRUE

		// Load the configurable fields for "Other Source" types and prepare them for display.
		fw_buildfieldlist(i_cSourceType)
		uo_search_criteria.fu_buildsearchlists(i_cSourceType)
		
		//--------------------------------------------------------------------------------------
		//		If we are not on the Demographics tab make it current. Otherwise, check to make 
		//		sure the correct DataObject is loaded and if not load it.
		//--------------------------------------------------------------------------------------

		dw_folder.fu_EnableTab(2)
		IF dw_folder.i_SelectedTab <> 2 THEN
			dw_folder.fu_SelectTab(2)
		ELSE

			Title = Tag
			IF i_uoDemographics.dw_demographics.DataObject <> 'd_demographics_other' THEN
				i_uoDemographics.dw_demographics.SetRedraw (FALSE)
				i_uoDemographics.dw_demographics.fu_Swap('d_demographics_other', &
					i_uoDemographics.dw_demographics.c_IgnoreChanges, &
					i_ulDemographicsCW + &
					i_uoDemographics.dw_demographics.c_ModifyOK + &
					i_uoDemographics.dw_demographics.c_NewOK + &	
					i_uoDemographics.dw_demographics.c_ModifyOnOpen + &
					i_uoDemographics.dw_demographics.c_NewModeOnEmpty + &
					i_ulDemographicsVW )
				i_uoDemographics.fu_displayfields()
				i_uoDemographics.dw_demographics.InsertRow(0)
				i_uoDemographics.dw_demographics.SetRedraw (TRUE)
			ELSE
				i_uoDemographics.dw_demographics.fu_Retrieve(&
					i_uoDemographics.dw_demographics.c_IgnoreChanges, &
					i_uoDemographics.dw_demographics.c_NoReselectRows)
			END IF
//			i_uoDemographics.dw_case_history.Reset()
	
		END IF

		dw_folder.fu_DisableTab(3)
		dw_folder.fu_DisableTab(4)
		dw_folder.fu_DisableTab(5)
		dw_folder.fu_DisableTab(6)
		dw_folder.fu_DisableTab(7)
		dw_folder.fu_DisableTab(8)			
		//--------------------------------------------------------------------------------------
		//		Enable the Save menu item.
		//--------------------------------------------------------------------------------------

		m_create_maintain_case.m_file.m_save.Enabled = TRUE
		m_create_maintain_case.m_file.m_save.text = 'Sa&ve Case Subject~tCtrl+S'
		m_create_maintain_case.m_file.m_save.MicroHelp = 'Save Case Subject'
		m_create_maintain_case.m_file.m_save.ToolBarItemText = 'Save Case Subject'
		
		//Clear the demographic security level variables
		SetNull( THIS.i_nRecordConfidLevel )
		SetNull( THIS.i_cApplyToMembers )
		
		// Disable the Special Flags menu item and reset the datawindow
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled = FALSE
		i_uoDemographics.dw_display_special_flags.fu_Reset( i_uoDemographics.dw_display_special_flags.c_IgnoreChanges )
		
	CASE 3  //Contact Notes
		IF IsValid( i_uoContactNotes ) THEN
			i_uoContactNotes.cb_new.Event Trigger clicked( )
		END IF
		
	
	CASE 7		//		Case Correspondence --> New Correspondence Record
		IF ISValid(i_uoCaseCorrespondence) THEN
			IF IsValid(i_uoCaseCorrespondence.i_uoDocMgr) THEN
				DESTROY i_uoCaseCorrespondence.i_uoDocMgr
			END IF
			l_nReturn = i_uoCaseCorrespondence.dw_correspondence_detail.fu_Save(&
								i_uoCaseCorrespondence.dw_correspondence_detail.c_PromptChanges)

			IF l_nReturn = i_uoCaseCorrespondence.dw_correspondence_detail.c_Fatal THEN
				RETURN
			END IF
   		SetRedraw(FALSE)
   		i_uoCaseCorrespondence.dw_correspondence_detail.fu_New(1)
			SetRedraw(TRUE)
			
		END IF

	CASE 8		//		Case Reminders	--> New Case Reminders

		IF ISValid(i_uoCaseReminders) THEN
			l_nReturn = i_uoCaseReminders.dw_case_reminder.fu_Save(&
		                  i_uoCaseReminders.dw_case_reminder.c_PromptChanges)
			IF l_nReturn = i_uoCaseReminders.dw_case_reminder.c_Fatal THEN
				RETURN
			END IF
     		i_uoCaseReminders.dw_case_reminder.fu_New(1)
		END IF

END CHOOSE




end event

event pc_print;//**********************************************************************************************
//
//  Event:   pc_print 
//  Purpose: To print the Case Detail and History Report
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/11/01 C. Jackson  Add code for getting the case number if the report is requested from
//                       the Cross Reference tab.  (SCR 1632)
//
//**********************************************************************************************

LONG			l_nRowCount, l_nRow
STRING		l_cCaseNumber
DATAWINDOW	l_dwCDHR

SetPointer(HOURGLASS!)

l_dwCDHR = uo_search_criteria.dw_case_detail_report

CHOOSE CASE dw_folder.i_CurrentTab
	CASE 4
		l_cCaseNumber = i_cSelectedCase
		
	CASE 6
		l_nRow = i_uoCrossReference.dw_cross_reference.GetRow()
		l_cCaseNumber = i_uoCrossReference.dw_cross_reference.GetItemString(l_nRow,'case_number')
		
	CASE 5 , 7, 8
		l_cCaseNumber = i_cCurrentCase
		
	CASE ELSE
		l_cCaseNumber = ''
		
END CHOOSE

IF l_cCaseNumber = '' THEN
	MessageBox (gs_appname, 'You cannot run this report from here.')
	RETURN
END IF

// if we're still here, continue running the report.
l_dwCDHR.SetTransObject(SQLCA)
l_dwCDHR.Retrieve (l_cCaseNumber, i_nRepConfidLevel)

l_dwCDHR.Print ()
l_dwCDHR.Reset ()


//IF i_cSelectedCase = '' THEN
//	MessageBox(gs_AppName, 'You have not selected a Case to report on.  Please ' + &
//		'select a Case.')
//	RETURN
//END IF
//
////------------------------------------------------------------------------------------
////		Set the Transaction Object for the report datawindow control
////------------------------------------------------------------------------------------
//
//uo_search_criteria.dw_case_detail_report.SetTransObject(SQLCA)
//
////------------------------------------------------------------------------------------
////		Determine which datawindow object should be associated with the case_subject 
////		nested report and what the Nested Argument should be.
////------------------------------------------------------------------------------------
//
//// string l_cTest
//CHOOSE CASE i_cSourceType
//
//	CASE i_cSourceConsumer
//
////		l_cTest = uo_search_criteria.dw_case_detail_report.Modify(&
////			"r_case_subject.Nest_Arguments = ((~"case_log_case_subject_id~")) r_case_subject.DataObject= 'd_report_consumer' ")		
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.Nest_Arguments = ((~"case_log_case_subject_id~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.DataObject" + &
//		   "='d_report_consumer'")
//		
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_history.Nest_Arguments = ((~"case_log_case_subject_id~"),(~"case_log_source_type~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_history.DataObject" + &
//			"='d_report_case_history'")
//		
//
//	CASE i_cSourceEmployer
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.Nest_Arguments = ((~"case_log_case_subject_id~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.DataObject" + &
//			 	"= 'd_report_employer'")
//				uo_search_criteria.dw_case_detail_report.Modify("r_case_history.Nest_Arguments = ((~"case_log_case_subject_id~"),(~"case_log_source_type~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_history.DataObject" + &
//			"='d_report_case_history'")
//
//
//	CASE i_cSourceProvider
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.Nest_Arguments = ((~"case_log_case_subject_id~"),(~"case_log_source_provider_type~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.DataObject" + &
//			 	"= 'd_report_provider' ")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_history.Nest_Arguments = ((~"case_log_case_subject_id~"),(~"case_log_source_type~"),(~"case_log_source_provider_type~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_history.DataObject" + &
//			"='d_report_case_history_provid'")
//		
//
//	CASE i_cSourceOther
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.Nest_Arguments = ((~"case_log_case_subject_id~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_subject.DataObject" + &
//				"= 'd_report_other'")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_history.Nest_Arguments = ((~"case_log_case_subject_id~"),(~"case_log_source_type~"))")
//		uo_search_criteria.dw_case_detail_report.Modify("r_case_history.DataObject" + &
//			"='d_report_case_history'")
//
//			
//END CHOOSE
//	
////-------------------------------------------------------------------------------------
////		Determine if there is a record in the Case Comments.  If not change the report
////		datawindow that contains a dummy row.
////------------------------------------------------------------------------------------
//
//SELECT count(*) INTO :l_nRowCount FROM cusfocus.case_comments WHERE
//			 case_number =:i_cSelectedCase;
//	
//IF l_nRowCount <> 0 THEN
//	uo_search_criteria.dw_case_detail_report.ModifY("customer_statement.DataObject" + & 
//			"= 'd_report_customer_statement'")
//
//	uo_search_criteria.dw_case_detail_report.Modify("customer_expectations.DataObject" + &
//			"= 'd_report_customer_expectations'")
//
//	uo_search_criteria.dw_case_detail_report.Modify("steps_to_resolve.DataObject" + &
//			"= 'd_report_steps_to_resolve'")
//	
//	uo_search_criteria.dw_case_detail_report.Modify("resolution.DataObject" + &
//			"= 'd_report_resolution'")
//ELSE
//	uo_search_criteria.dw_case_detail_report.Modify("customer_statement.DataObject" + &
//			"= 'd_report_customer_statement_empty'")
//	
//	uo_search_criteria.dw_case_detail_report.Modify("customer_expectations.DataObject" + &
//			"= 'd_report_customer_expectations_empty'")
//
//	uo_search_criteria.dw_case_detail_report.Modify("steps_to_resolve.DataObject" + &
//			"= 'd_report_steps_to_resolve_empty'")
//	
//	uo_search_criteria.dw_case_detail_report.Modify("resolution.DataObject" + &
//			"= 'd_report_resolution_empty'")	
//
//END IF
//
//uo_search_criteria.dw_case_detail_report.Retrieve(i_cSelectedCase)
//
//uo_search_criteria.dw_case_detail_report.Print()
//SetPointer(HOURGLASS!)
//
end event

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
	Event:	pc_setoptions
	Purpose:	Define the characteristics for the current window, including toolbar,
            datawindows, tabs, and MS Word location.

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	05/21/99 M. Caruso      Changed toolbar initialization from c_ToolbarLeft to c_ToolbarTop.
	05/24/99 M. Caruso      Added hot key identifiers to the Tab labels.
	06/10/99 M. Caruso      Removed c_NewModeOnEmpty from the declaration of i_ulCaseDetailCW.
	02/17/00 C. Jackson     Add no records message for documents quick interface.
	10/30/00 M. Caruso      Added resize code.
	10/17/2001 K. Claver    Enhanced for registry.
******************************************************************************************/

STRING       l_cRoleName[], l_cUserID
INT          l_nNumOfRoles, l_nCounter
LONG         l_nRoleKey[]
WINDOWOBJECT l_woTabObjects1[]

fw_SetOptions(c_Default + c_ToolbarTop)			// RAE 4/5/99; MPC 5/21/99

//	Create some constants for Set_DW_Options
i_ulDemographicsCW 	=	uo_search_criteria.uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange
i_ulDemographicsVW  	=  uo_search_criteria.uo_matched_records.dw_matched_records.c_FreeFormStyle + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_NoInactiveRowPointer
i_ulCaseHistoryCW    =  uo_search_criteria.uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange
i_ulCaseHistoryVW    =  uo_search_criteria.uo_matched_records.dw_matched_records.c_TabularFormStyle + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_NoInactiveRowPointer
i_ulCaseDetailCW 		= 	uo_search_criteria.uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_ModifyOk + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_ModifyOnOpen + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_NewOk

//	Set the defaults for the folder object
dw_folder.fu_TabOptions('Tahoma', 8, dw_folder.c_DefaultVisual)
dw_folder.fu_TabDisableOptions('Tahoma', 8, dw_folder.c_TextDisableRegular)
dw_folder.fu_TabCurrentOptions('Tahoma', 8, dw_folder.c_DefaultVisual)

Tag = Title

//	Assign the Search user object to the window object array
l_woTabObjects1[1] = uo_search_criteria

//	Attach lables and window object array to tabs
dw_folder.fu_AssignTab(1, "Search", l_woTabObjects1[])
dw_folder.fu_AssignTab(2, "Demographics")
dw_folder.fu_AssignTab(3, "Contact Notes")
dw_folder.fu_AssignTab(4, "Contact History")
dw_folder.fu_AssignTab(5, "Case")
dw_folder.fu_AssignTab(6, "Cross Ref.")
dw_folder.fu_AssignTab(7, "Correspondence")
dw_folder.fu_AssignTab(8, "Reminders")

//	Create the tab folder
dw_folder.fu_folderCreate(8,8)

//	Select the Search Criteria Tab and Disable Demographics, ProActive
//	Correspondence and Case Reminders tabs.
dw_folder.fu_SelectTab(1)

dw_folder.fu_DisableTab(2)
dw_folder.fu_DisableTab(6)
dw_folder.fu_DisableTab(7)
dw_folder.fu_DisableTab(8)

i_bCaseDetailUpdate = TRUE

uo_search_criteria.i_wParentWindow = THIS

//	Determine the Confidentiality level for the User
l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT confidentiality_level, rec_confidentiality_level, set_record_security, user_last_name 
INTO :i_nRepConfidLevel, :i_nRepRecConfidLevel, :i_cSetRecordSecurity, :i_cUserLastname
FROM cusfocus.cusfocus_user WHERE user_id = :l_cUserID; 

//	Get the Role Info from PowerLock and determine if the user has the Supervisor
//	Role which the Name will be stored in the application INI file or the registry.
IF OBJCA.MGR.i_Source = "R" THEN
	RegistryGet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\roles" ), "modifyclosedcase", &
					 RegString!, i_cSupervisorRole )
ELSE
	i_cSupervisorRole = ProfileString(OBJCA.MGR.i_ProgINI, 'Roles', 'modifyclosedcase','')
END IF

IF i_cSupervisorRole <> '' AND NOT IsNull( i_cSupervisorRole ) THEN
 	SECCA.MGR.fu_GetRoleInfo(l_nRoleKey[], l_cRoleName[])
	l_nNumofRoles = UPPERBOUND(l_nRoleKey[])

	FOR l_nCounter = 1 to l_nNumofRoles
		IF l_cRoleName[l_nCounter] = i_cSupervisorRole THEN
			i_bSupervisorRole = TRUE
			EXIT
		END IF
	NEXT
END IF

//	Find out where the WINWORD.EXE is located.
IF OBJCA.MGR.i_Source = "R" THEN
	RegistryGet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\winword" ), "exeloc", RegString!, i_cWORDExe )
ELSE
	i_cWORDExe = ProfileString(OBJCA.MGR.i_ProgINI, 'WINWORD','EXELOC', '')
END IF

uo_search_criteria.dw_search_criteria.SetFocus()

// Add no records message for Document Quick Interface
OBJCA.MSG.fu_AddMessage ("docs_no_rows","<application_name>", &
								 "There are no documents for %s.", &
								 OBJCA.MSG.c_msg_none, OBJCA.MSG.c_msg_ok, &
								 1, OBJCA.MSG.c_Enabled)
								 
// initialize the resize service for this window
i_nBaseWidth = Width
i_nBaseHeight = Height - 76   // this offset value was needed to make the sizing correct.

of_SetResize (TRUE)

IF IsValid (inv_resize) THEN
	inv_resize.of_SetOrigSize ((Width - 30), (Height - 178))
	inv_resize.of_SetMinSize ((Width - 30), (Height - 178))
	
	inv_resize.of_Register (dw_folder, inv_resize.SCALERIGHTBOTTOM)
	inv_resize.of_Register (uo_search_criteria, inv_resize.SCALERIGHTBOTTOM)
	
END IF

fw_CheckOutOfOffice()

//Check if should display a case link warning after n linked cases.
fw_CaseLinkWarning( )

//Set who is allowed to close a transferred case
fw_CloseBy( )


end event

on w_create_maintain_case.create
int iCurrent
call super::create
if this.MenuName = "m_create_maintain_case" then this.MenuID = create m_create_maintain_case
this.uo_search_criteria=create uo_search_criteria
this.dw_folder=create dw_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search_criteria
this.Control[iCurrent+2]=this.dw_folder
end on

on w_create_maintain_case.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search_criteria)
destroy(this.dw_folder)
end on

event pc_close;call super::pc_close;//**********************************************************************************************
//
//  Event:   pc_close
//  Purpose: Clean up
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  02/17/00 C. Jackson    Original Version
//  04/24/00 C. Jackson    Add logic to refresh the reminders window if it is open
//  11/2/2000 K. Claver    Added code to close the IIM tab page if open
//  3/14/2002 K. Claver    Added function call to clear all case locks for the current user.
//
//**********************************************************************************************

OBJCA.MSG.fu_DeleteMessage("docs_no_rows")


IF IsValid( w_docs_quick_interface ) THEN
	Close(w_docs_quick_interface)
END IF

//Close IIM tabs window if open
IF IsValid( w_iim_tabs ) THEN
	Close( w_iim_tabs )
END IF

//Clear all case locks for the current user
THIS.fw_ClearCaseLocks( )
end event

event timer;call super::timer;/***************************************************************************************
	Event:	timer
	Purpose:	Please see PB documentation for this event
							
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	11/30/2000 K. Claver   Added code to show the first contact note as viewed by the current
								  user after three seconds.
***************************************************************************************/
IF IsValid( i_uoContactNotes ) THEN
	i_uoContactNotes.dw_contact_note_list.Event Trigger ue_save( 1 )
END IF
end event

event pc_closequery;call super::pc_closequery;//**********************************************************************************************
//
//  Event:   pc_closequery
//  Purpose: Please see PowerClass documentation for this event
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  2/21/2001 K. Claver    Added code to prevent the window from closing if in the middle of a search
//
//**********************************************************************************************

IF IsValid( THIS.uo_search_criteria ) THEN
	IF THIS.uo_search_criteria.i_bInSearch THEN
		Error.i_FWError = c_Fatal
	END IF
END IF
end event

event closequery;/*****************************************************************************************
   Event:      closequery
   Purpose:    Override the ancestor to determine if case changes exist and save them.
					Then continue with the normal closequery processing in the ancestor.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/20/01 M. Caruso    Created. 
	05/07/02 C. Jackson   Set Item Status to not modified on XRef Source Type if there is
	                      no Cross Reference defined
	05/14/02 K. Claver    Added condition to check the case type before executing the fix
								 mentioned above as the xref source type field will not exist for
								 a proactive case.
	05/23/02 M. Caruso    Moved saving code for the Correspondence tab here for when the
								 window is closing.
	05/31/02 C. Jackson   Removed reference to 'case_log_xref_source_type'
	06/17/03 M. Caruso    Added code to check if the correspondence editing window is open.
								 If it is, a message is displayed and the window is not allowed to
								 close.
*****************************************************************************************/

INTEGER	l_nReturn
LONG		l_nColCount, l_nColIndex, l_nRow
STRING	l_cColName, l_cMessage
U_DW_STD	l_dwDetails
DWITEMSTATUS	l_status
U_TABPAGE_CASE_DETAILS	l_tpCaseDetails

IF IsValid (i_uoCaseCorrespondence) THEN
	IF IsValid(i_uoCaseCorrespondence.i_uoDocMgr) THEN
		IF IsValid(i_uoCaseCorrespondence.i_uoDocMgr.i_wDocWindow) THEN
			MessageBox (gs_appname, 'This window cannot be closed while a correspondence document is being edited.')
			RETURN 1
		END IF
	END IF
END IF

CHOOSE CASE dw_folder.i_CurrentTab
	CASE 5		// case tab

		// define datawindow reference variable
		l_dwDetails = i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
	
		l_nColCount = INTEGER (l_dwDetails.Object.Datawindow.Column.Count)
		// get the column ID for column_name
		FOR l_nColIndex = 1 to l_nColCount
		
			CHOOSE CASE l_dwDetails.GetItemStatus( 1, l_nColIndex, Primary! )
				CASE DataModified!
					l_cColName = l_dwDetails.Describe ('#'+STRING (l_nColIndex)+'.Name')
	
				CASE NewModified!
					l_cColName = l_dwDetails.Describe ('#'+STRING (l_nColIndex)+'.Name')
		
			END CHOOSE
		
		NEXT
		
		IF i_uoCaseDetails.fu_SaveCase (c_PromptChanges) = c_Fatal THEN RETURN 1
		
	CASE 7		// correspondence tab
		l_dwDetails = i_uoCaseCorrespondence.dw_correspondence_detail
		l_dwDetails.AcceptText ()
		l_nRow = l_dwDetails.GetRow()
		l_Status = l_dwDetails.GetItemStatus(l_nRow, 0, Primary!)
		CHOOSE CASE l_Status
			CASE NewModified!
				l_cMessage = "This new correspondence item has not been saved.~r~n" + &
								 "Do you wish to save this item before continuing?"
								 
			CASE DataModified!
				l_cMessage = "Do you want to save your changes before continuing?"
				
			CASE ELSE
				l_cMessage = ""
				
		END CHOOSE
		
		IF l_cMessage = "" THEN       // The record does not need to be saved.
			RETURN 0
		ELSE                          // Prompt the user to save changes.
			l_nReturn = MessageBox (gs_AppName, l_cMessage, Information!, YesNoCancel!)
			CHOOSE CASE l_nReturn
				CASE 1
					// save the case as requested			
					l_nReturn = l_dwDetails.fu_Save (l_dwDetails.c_SaveChanges)
					
					IF l_nReturn = l_dwDetails.c_Fatal THEN
						RETURN 1 
					ELSE
						RETURN 0
					END IF
					
				CASE 2
					// reset the update status of the record and skip further processing
					l_dwDetails.fu_ResetUpdateUOW ()
					RETURN 0
					
				CASE 3
					// retuen to the current tab.
					RETURN 1
					
			END CHOOSE
		END IF
		
END CHOOSE

// now return to the normal window processing
CALL SUPER::closequery


end event

type uo_search_criteria from u_search_criteria within w_create_maintain_case
integer x = 23
integer y = 104
integer width = 3579
integer height = 1600
integer taborder = 10
boolean border = false
end type

on uo_search_criteria.destroy
call u_search_criteria::destroy
end on

type dw_folder from u_folder within w_create_maintain_case
event ue_casesearch ( string a_ccasenumber )
integer y = 4
integer width = 3639
integer height = 1720
integer taborder = 20
end type

event ue_casesearch(string a_ccasenumber);/*****************************************************************************************
	Event:		ue_casesearch
	Purpose:		To automate the process of searching by case.  Called by double-clicking
					on a reminder in the Reminders screen.
					
	Parameters: a_cCaseNumber - String - Case number to search for
					
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	6/28/99  M. Caruso     Created.
	7/7/99   M. Caruso     Replaced code for selecting a search type from manipulating
	                       radio buttons to manipulating the selection list box.
	9/21/00  M. Caruso     Commented out sedtion of code for tab switching because it
								  references dw_case_history on the demographics tab which is no
								  longer there.
	3/4/2002 K. Claver     Changed to use a string parameter for searching on the case rather
								  than using the value set in the Message.LongParm property.
	3/5/2002 K. Claver     Added call to Yield function.  Explanation below.
*****************************************************************************************/
LONG		l_lRow
INTEGER  l_iIndex
String ls_casenumber

// If there is an open correspondence, don't let them change cases
//IF IsValid(i_uoCaseCorrespondence) THEN
//	IF IsValid(i_uoCaseCorrespondence.i_uoDocMgr) THEN
//		IF IsValid(i_uoCaseCorrespondence.i_uoDocMgr.i_wDocWindow) THEN
//			ls_casenumber = i_uoCaseCorrespondence.i_uoDocMgr.i_sCurrentDocInfo.a_cCaseNumber
////				IF a_ccasenumber <> i_cCurrentCase THEN
//			IF a_cCaseNumber <> ls_casenumber THEN
//				MessageBox (gs_appname, 'Cannot switch to a different case while a correspondence document is being edited.')
//				RETURN
//			END IF
//		END IF
//	END IF
//END IF

// turn off redraw for the folder datawindow until after all processing is done
This.SetRedraw (FALSE)

// prepare the window to search by case.
uo_search_criteria.ddlb_search_type.SelectItem ("Case",0)
l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Case",0)
uo_search_Criteria.ddlb_search_type.Event Trigger selectionchanged( l_iIndex )

// set the search criteria.
l_lRow = uo_search_criteria.dw_search_criteria.GetRow ()
uo_search_criteria.dw_search_criteria.SetItem (l_lRow, "case_number", Trim(a_cCaseNumber))
uo_search_criteria.dw_search_criteria.AcceptText ()

//Turn redraw back on before actually do search
This.SetRedraw (TRUE)

// Perform the search.  Added call to the Yield function as using the event
//  to open a case from the Reminders tab on the Work Desk appeared to cause
//  this event to be fired twice as a result of other processes not completing.
Yield( )
m_create_maintain_case.m_file.m_search.Event Trigger clicked( )
end event

event po_tabvalidate;call super::po_tabvalidate;/****************************************************************************************

	Event:	po_tabvalidate
	Purpose:	To create the dynamic user obejcts for the associated tabs and set
				the various options.

	Revisions:
	Date     Person     Description of Change
	-------- ---------- ------------------------------------------------------------------
	9/29/00  M. Caruso  Created, based on the code from the previous window version.
	11/20/00 M. Caruso  Modified code of CASE 4 to manually retrieve the data for that tab
							  and set the selected case based on appropriate criteria.
	11/28/00 M. Caruso  Added code to determine whether or not to reset the case note
							  entry datawindow on the case tab.  Also set focus to the case note
							  entry datawindow when that tab is selected.
	11/30/00 M. Caruso  Added code to call fu_setoptions for the preview pane before
							  calling fu_retrieve for the case list on the contact history tab.
							  Also, improved initial displaying of Case tab by removing the
							  SetRedraw statements from the code.
	12/08/00 M. Caruso  The Contact History tab now triggers pcd_pickedrow whenever the
							  case list datawindow is refreshed.  Also changed the code to reset
							  the case note entry datawindow when the Case tab is selected.
	12/20/00 M. Caruso  Modified code in CASE 5 (Case tab) to not set i_cCurrentCase and
							  only reset the case note entry datawindow if i_cSelectedCase and
							  i_cCurrentCase do not match.
	01/02/01 M. Caruso  Call fu_swap to change the case details dataobject in CASE 5.
	01/12/01 M. Caruso  Rewrote CASE 5.  All functionality removed except to initialize
							  the tab object if needed.
	02/16/01 M. Caruso  Moved code to check the category count from CASE 5 to the new case
							  menu items.
	4/27/2001 K. Claver Moved the code to set the save message for Contact Notes outside
							  of the "IF IsValid" code block so the message is reset each time
							  the user switches to the tab.
	06/01/01 M. Caruso  When the Correspondence tab is selected, added code to explicitly
							  retrieve dw_correspondence_detail.
	6/27/2001 K. Claver Removed constant c_modifyok from the options list for dw_case_reminder
							  as we do not want the pcd_modify event to fire upon retrieval of the
							  datawindow.
	2/15/2002 K. Claver Removed calls to fu_Modify on the reminder datawindow as was putting
							  the datawindow into modify mode when switching to the reminder tab.
							  Should only be in modify mode if no reminders exist or if the user
							  manually clicks the button to modify the reminder.
****************************************************************************************/


BOOLEAN			l_bNewDW, l_bSetOptions
STRING 			l_cSourceType
STRING 			l_cKeyValue
LONG 				l_nSearchRow, l_nCatCount, l_nSelectedRows[], l_nRowCount, l_nBlankArray[]
INT  				l_nReturn, l_nMaxLevels
U_DW_STD			l_dwCaseList, l_dwSearchResults, l_dwCasePreview, l_dwCaseDetails
U_DW_STD       l_dwCrossRefList
U_TABPAGE_CASE_DETAILS	l_tpCaseDetails
U_TABPAGE_CATEGORY		l_tpCategories


//--------------------------------------------------------------------------------------
//
//		We need to check to see if the current tab has any changes to save.  However, if
//		we need a Case Subject we will not check as long as they are clicking on the
//		Search Criteria Tab.
//
//---------------------------------------------------------------------------------------

IF i_ClickedTab <> 1 OR NOT i_bNeedCaseSubject THEN
	l_nReturn = fw_checkothertabs()
	IF l_nReturn = -1 THEN
		i_TabError = -1
		RETURN
	END IF
END IF

CHOOSE CASE i_ClickedTab
	CASE 1					//	Search Criteria Tab
		
		i_TabError = 0

//--------------------------------------------------------------------------------------
//
//		IF we need to update the Search criteria based on a change to an Other source type
//		we need to determine if the user created a new Case subject so we can retreive the
//		data BUT not select the prior Case Subject, otherwise retrive and DO select the 
//		prior Case Subject.
//
//--------------------------------------------------------------------------------------
		IF i_bSearchCriteriaUpdate AND uo_search_criteria.uo_matched_records.dw_matched_records.DataObject &
			= 'd_matched_others' THEN
			IF i_bNewCaseSubject THEN
				uo_search_criteria.uo_matched_records.dw_matched_records.fu_Retrieve(&
					uo_search_criteria.uo_matched_records.dw_matched_records.c_IgnoreChanges, &
					uo_search_criteria.uo_matched_records.dw_matched_records.c_NoReselectRows)
			ELSE	
 				uo_search_criteria.uo_matched_records.dw_matched_records.fu_SetKey('customer_id')
				uo_search_criteria.uo_matched_records.dw_matched_records.fu_Retrieve(&
					uo_search_criteria.uo_matched_records.dw_matched_records.c_IgnoreChanges, &
					uo_search_criteria.uo_matched_records.dw_matched_records.c_NoReselectRows)
			END IF
		END IF

//-------------------------------------------------------------------------------------
//		If we need to update the Search Criteria based on a Case Log record change then
//-------------------------------------------------------------------------------------

		IF i_bSearchCriteriaUpdate AND uo_search_criteria.uo_matched_records.dw_matched_records.DataObject &
					= 'd_matched_cases' THEN
			i_bSearchCriteriaUpdate = FALSE
 			uo_search_criteria.uo_matched_records.dw_matched_records.fu_SetKey('case_number')
			uo_search_criteria.uo_matched_records.dw_matched_records.fu_Retrieve(&
				uo_search_criteria.uo_matched_records.dw_matched_records.c_IgnoreChanges, &
				uo_search_criteria.uo_matched_records.dw_matched_records.c_NoReselectRows)
		END IF

		IF (uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> 'd_matched_cases') And (uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> 'd_matched_cases_caseprops')THEN
			i_cSelectedCase = ''
		END IF
		uo_search_criteria.dw_search_criteria.SetFocus()
	
	CASE 2				// Demographics Tab
		i_TabError = 0
		i_cSaveMessage = i_cSaveDemographicChanges
      FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		FWCA.MSG.fu_SetMessage("Changes", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		
		CHOOSE CASE i_cSourceType
			CASE 'C'
				IF gs_rt_members = 'Y' THEN fw_UpdateDemographicsRT ()
				
			CASE 'P'
				IF gs_rt_providers = 'Y' THEN fw_UpdateDemographicsRT ()
				
			CASE 'E'
				IF gs_rt_groups = 'Y' THEN fw_UpdateDemographicsRT ()
				
		END CHOOSE
		
		fw_validatedemographics()
		
	CASE 3				// Contact Notes Tab
		
		i_TabError = 0
		
		IF NOT IsValid( i_uoContactNotes ) THEN
			
			SetPointer ( HOURGLASS! )
			PARENT.SetRedraw ( FALSE )
			OpenUserObject( i_uoContactNotes, 'u_contact_notes', 23, 104 )
			i_woTabObjects[1] = i_uoContactNotes
			fu_assignTab (i_ClickedTab, i_woTabObjects[])
			
			i_uoContactNotes.i_wParentWindow = PARENT
			i_uoContactNotes.BringToTop = TRUE
			i_uoContactNotes.Border = FALSE
			
			PARENT.SetRedraw( TRUE )
		END IF
		
		i_cSaveMessage = i_cSaveContactNoteChanges
		FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		FWCA.MSG.fu_SetMessage("Changes", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		
	CASE 4				// Contact History Tab
		i_TabError = 0
		
		IF NOT IsValid(i_uoContactHistory) THEN
			
			SetPointer(HOURGLASS!)
			Parent.SetRedraw (FALSE)
			OPENUSEROBJECT(i_uoContactHistory, 'u_contact_history', 23, 104)
			i_uoContactHistory.i_wParentWindow 	= PARENT
			i_uoContactHistory.BringToTop 		= TRUE
			i_uoContactHistory.Border 				= FALSE
			PARENT.SetRedraw (TRUE)
			l_bSetOptions = TRUE
			
		ELSE
			l_bSetOptions = FALSE
		END IF
			
//		l_dwCaseList = i_uoContactHistory.uo_search_contact_history.dw_report
//RAP		l_dwCasePreview = i_uoContactHistory.dw_case_preview
		l_dwSearchResults = uo_search_criteria.uo_matched_records.dw_matched_records
		
//		IF l_bSetOptions THEN
//			l_dwCaseList.fu_SetOptions (SQLCA, l_dwCaseList.c_NullDW, &
//												l_dwCaseList.c_SelectOnRowFocusChange + &
//												l_dwCaseList.c_NoMenuButtonActivation + &
//												l_dwCaseList.c_ModifyOK + &
//												l_dwCaseList.c_SortClickedOK + &
//												l_dwCaseList.c_NoRetrieveOnOpen )
//												
//			l_dwCasePreview.fu_SetOptions (SQLCA, l_dwCaseList, &
//												l_dwCasePreview.c_DetailEdit + &
//												l_dwCasePreview.c_HideHighlight + &
//												l_dwCasePreview.c_NoShowEmpty + &
//												l_dwCasePreview.c_NoMenuButtonActivation)
//		END IF
			
//		l_dwCaseList.fu_Retrieve (l_dwCaseList.c_IgnoreChanges, l_dwCaseList.c_NoReselectRows)
		i_uoContactHistory.of_retrieve()
		i_uoContactHistory.uo_search_contact_history.dw_report.SetFocus()
		
		// If a case has just been worked, make it current.
		CHOOSE CASE selectedtab
			CASE 1
				IF l_dwSearchResults.dataobject = 'd_matched_cases' THEN
					i_cSelectedCase = l_dwSearchResults.GetItemString (l_dwSearchResults.i_CursorRow, 'case_number')
				END IF
				
			CASE ELSE
				i_cSelectedCase = i_cCurrentCase
				
		END CHOOSE
		
		// highlight the selected case in the case list if one is defined
		IF i_cSelectedCase <> '' THEN
			
			l_nRowCount = i_uoContactHistory.uo_search_contact_history.dw_report.RowCount ()
			l_nSelectedRows[1] = i_uoContactHistory.uo_search_contact_history.dw_report.Find ("sort_case_number = " + i_cSelectedCase, 1, l_nRowCount)
			IF l_nSelectedRows[1] > 0 THEN
				i_uoContactHistory.uo_search_contact_history.dw_report.SetRow(l_nSelectedRows[1])
//				l_dwCaseList.fu_SetSelectedRows (1, l_nSelectedRows[], l_dwCaseList.c_IgnoreChanges, l_dwCaseList.c_RefreshChildren)
			ELSE
				l_nSelectedRows[1] = 1
			END IF
		ELSE
			l_nSelectedRows[1] = 1
		END IF
//		IF l_dwCaseList.RowCount () > 0 THEN
//			// only specify a picked row if rows exist in the datawindow
//			l_dwCaseList.Event pcd_PickedRow (1, l_nSelectedRows[])
//		END IF
//		
		// activate the Case tabs if cases are retrieved for the current case subject.
//		IF i_uoContactHistory.dw_case_history.RowCount () > 0 THEN
//			fu_EnableTab (5)
//			fu_DisableTab (6)
//		ELSE
//			fu_DisableTab (5)
//			fu_DisableTab (6)
//		END IF
		
	CASE 5				// Case Tab
		i_TabError = 0
		i_cSaveMessage = i_cSaveCaseChanges
		FWCA.MSG.fu_SetMessage ("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		FWCA.MSG.fu_SetMessage ("Changes", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		
		IF NOT IsValid (i_uoCaseDetails) THEN
			
			SetPointer (HOURGLASS!)
			OPENUSEROBJECT (i_uoCaseDetails, 'u_case_details', 23, 104)
			
			i_uoCaseDetails.i_wParentWindow 	= PARENT
			i_uoCaseDetails.BringToTop 		= TRUE
			i_uoCaseDetails.Border 				= FALSE

			i_woTabObjects[1] = i_uoCaseDetails
			fu_assignTab (i_ClickedTab, i_woTabObjects[])
			
		END IF

	CASE 6				// Cross Reference Tab
		i_TabError = 0
		
		IF NOT IsValid( i_uoCrossReference ) THEN
			
			SetPointer ( HOURGLASS! )
			PARENT.SetRedraw ( FALSE )
			OpenUserObject( i_uoCrossReference, 'u_cross_reference', 23, 104 )
			i_woTabObjects[1] = i_uoCrossReference
			fu_assignTab (i_ClickedTab, i_woTabObjects[])
			
			i_uoCrossReference.i_wParentWindow = PARENT
			i_uoCrossReference.BringToTop = TRUE
			i_uoCrossReference.Border = FALSE
			
			PARENT.SetRedraw( TRUE )
			l_bSetOptions = TRUE
			
		ELSE
			l_bSetOptions = FALSE
		END IF
		
		l_dwCrossRefList = i_uoCrossReference.dw_cross_reference
		l_dwCasePreview = i_uoCrossReference.dw_case_preview
		
		IF l_bSetOptions THEN
			l_dwCrossRefList.fu_SetOptions (SQLCA, l_dwCrossRefList.c_NullDW, &
			l_dwCrossRefList.c_SelectOnRowFocusChange + &
			l_dwCrossRefList.c_NoMenuButtonActivation + &
			l_dwCrossRefList.c_NoModify + &
			l_dwCrossRefList.c_SortClickedOK + &
			l_dwCrossRefList.c_NoRetrieveOnOpen )
												
			l_dwCasePreview.fu_SetOptions (SQLCA, l_dwCrossRefList, &
			l_dwCasePreview.c_DetailEdit + &
			l_dwCasePreview.c_HideHighlight + &
			l_dwCasePreview.c_NoShowEmpty + &
			l_dwCasePreview.c_NoMenuButtonActivation)
		END IF
		
		l_dwCrossRefList.fu_Retrieve (l_dwCrossRefList.c_IgnoreChanges, l_dwCrossRefList.c_NoReselectRows)
	
		l_dwCrossRefList.SetFocus()
		
	CASE 7				// Correspondence Tab
		i_TabError = 0
		i_cSaveMessage = 'Would you like to Save the Case Correspondence?'
      FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		FWCA.MSG.fu_SetMessage("Changes", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		i_cCurrentCase = i_cSelectedCase
	   IF NOT ISValid(i_uoCaseCorrespondence) THEN
			SetPointer(HOURGLASS!)
			Parent.SetRedraw(FALSE)
			OPENUSEROBJECT(i_uoCaseCorrespondence, 'u_case_correspondence', 23, 104)
			i_uoCaseCorrespondence.i_wParentWindow 	= PARENT
			i_uoCaseCorrespondence.BringToTop 		 	= TRUE
			i_uoCaseCorrespondence.Border 				= FALSE
			i_woTabObjects[1] = i_uoCaseCorrespondence
	   	fu_assignTab(i_ClickedTab, i_woTabObjects[])

 			i_uoCaseCorrespondence.dw_correspondence_list.fu_SetKey('correspondence_id')

			i_uoCaseCorrespondence.dw_correspondence_list.fu_SetOptions(SQLCA, &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NullDW, &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NewModeOnEmpty + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_ModifyOnSelect + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_SelectOnRowFocusChange + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_TabularFormStyle + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NoActiveRowPointer + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NoInactiveRowPointer + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NoRetrieveOnOpen + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NoMenuButtonActivation + &
				i_uoCaseCorrespondence.dw_correspondence_list.c_SortClickedOK )

			i_uoCaseCorrespondence.dw_correspondence_detail.fu_SetOptions( SQLCA, & 
 				i_uoCaseCorrespondence.dw_correspondence_list, & 
				i_uoCaseCorrespondence.dw_correspondence_detail.c_ModifyOK + &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_ModifyOnSelect + &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_SelectOnRowFocusChange + &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_NewOK + &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_DeleteOK + &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_RefreshParent + &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_FreeFormStyle + &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_NoMenuButtonActivation )
				
			//RAE 4/5/99	
			i_uoCaseCorrespondence.dw_correspondence_list.fu_Retrieve(&
				i_uoCaseCorrespondence.dw_correspondence_list.c_IgnoreChanges, &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NoReselectRows)
				
			i_uoCaseCorrespondence.dw_correspondence_detail.fu_Retrieve(&
				i_uoCaseCorrespondence.dw_correspondence_detail.c_IgnoreChanges, &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_NoReselectRows)
 
			IF i_uoCaseCorrespondence.dw_correspondence_list.RowCount() > 0 THEN
				i_uoCaseCorrespondence.dw_correspondence_detail.fu_Modify()
			END IF
			Parent.SetRedraw(TRUE)
		ELSE
			i_uoCaseCorrespondence.dw_correspondence_list.fu_Retrieve(&
				i_uoCaseCorrespondence.dw_correspondence_list.c_IgnoreChanges, &
				i_uoCaseCorrespondence.dw_correspondence_list.c_NoReselectRows)
				
			i_uoCaseCorrespondence.dw_correspondence_detail.fu_Retrieve(&
				i_uoCaseCorrespondence.dw_correspondence_detail.c_IgnoreChanges, &
				i_uoCaseCorrespondence.dw_correspondence_detail.c_NoReselectRows)
				
			IF i_uoCaseCorrespondence.dw_correspondence_list.RowCount() > 0 THEN
				i_uoCaseCorrespondence.dw_correspondence_detail.fu_Modify()
			END IF
			i_uoCaseCorrespondence.dw_correspondence_list.SetFocus()
		END IF

	CASE 8				// Reminders Tab
		i_TabError = 0
		i_cSaveMessage = 'Would you like to Save the Case Reminders?'
      FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		FWCA.MSG.fu_SetMessage("Changes", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
		i_cCurrentCase = i_cSelectedCase
		IF NOT IsValid(i_uoCaseReminders) THEN
			SetPointer(HOURGLASS!)
			Parent.SetRedraw(FALSE)
			OPENUSEROBJECT(i_uoCaseReminders, 'u_case_reminders', 23, 104)
			i_uoCaseReminders.i_wParentWindow 	= PARENT
			i_uoCaseReminders.BringToTop 		 	= TRUE
			i_uoCaseReminders.Border 				= FALSE
			i_woTabObjects[1] = i_uoCaseReminders
	   	fu_assignTab(i_ClickedTab, i_woTabObjects[])
			i_uoCaseReminders.dw_calendar.fu_CalCreate()
 			i_uoCaseReminders.dw_case_reminder_history.fu_SetKey('reminder_id')

			i_uoCaseReminders.dw_case_reminder_history.fu_SetOptions( SQLCA, & 
				i_uoCaseReminders.dw_case_reminder_history.c_NullDW, & 
				i_uoCaseReminders.dw_case_reminder_history.c_NewModeOnEmpty + &
				i_uoCaseReminders.dw_case_reminder_history.c_SelectOnRowFocusChange + &
				i_uoCaseReminders.dw_case_reminder_history.c_TabularFormStyle + &
				i_uoCaseReminders.dw_case_reminder_history.c_NoActiveRowPointer + &
				i_uoCaseReminders.dw_case_reminder_history.c_NoInactiveRowPointer + &
				i_uoCaseReminders.dw_case_reminder_history.c_ShowHighlight + &
				i_uoCaseReminders.dw_case_reminder_history.c_NoRetrieveOnOpen + &
				i_uoCaseReminders.dw_case_reminder_history.c_NoMenuButtonActivation + &
				i_uoCaseReminders.dw_case_reminder_history.c_SortClickedOK ) 

			i_uoCaseReminders.dw_case_reminder.fu_SetOptions( SQLCA, & 
 				i_uoCaseReminders.dw_case_reminder_history, & 
				i_uoCaseReminders.dw_case_reminder.c_NewOK + &
				i_uoCaseReminders.dw_case_reminder.c_ViewOnSelect + &
				i_uoCaseReminders.dw_case_reminder.c_DeleteOK + &
				i_uoCaseReminders.dw_case_reminder.c_ViewAfterSave + &
				i_uoCaseReminders.dw_case_reminder.c_RefreshParent + &
				i_uoCaseReminders.dw_case_reminder.c_FreeFormStyle + &
				i_uoCaseReminders.dw_case_reminder.c_NoMenuButtonActivation  ) 

			//RAE 4/5/99
			i_uoCaseReminders.dw_case_reminder_history.fu_Retrieve(&
				i_uoCaseReminders.dw_case_reminder_history.c_IgnoreChanges, &
				i_uoCaseReminders.dw_case_reminder_history.c_NoReselectRows)

			//RAE 4/5/99   ====  MPC 6/17/99
			i_uoCaseReminders.dw_case_reminder.fu_Retrieve(&
				i_uoCaseReminders.dw_case_reminder.c_IgnoreChanges, &
				i_uoCaseReminders.dw_case_reminder.c_NoReselectRows)
				
			//RAE  4/5/99
			IF i_uoCaseReminders.dw_case_reminder_history.RowCount() > 0 THEN
//				i_uoCaseReminders.dw_case_reminder.fu_Modify()
				i_uoCaseReminders.dw_case_reminder.SetFocus()
			END IF

			Parent.SetRedraw(TRUE)
		ELSE
			
			//RAE 4/5/99
			i_uoCaseReminders.dw_case_reminder_history.fu_Retrieve(&
				i_uoCaseReminders.dw_case_reminder_history.c_IgnoreChanges, &
				i_uoCaseReminders.dw_case_reminder_history.c_NoReselectRows)
			
			i_uoCaseReminders.dw_case_reminder.fu_Retrieve(&
				i_uoCaseReminders.dw_case_reminder.c_IgnoreChanges, &
				i_uoCaseReminders.dw_case_reminder.c_NoReselectRows)

			//RAE  4/5/99
			IF i_uoCaseReminders.dw_case_reminder_history.RowCount() > 0 THEN
//				i_uoCaseReminders.dw_case_reminder.fu_Modify()
				i_uoCaseReminders.dw_case_reminder.SetFocus()
			END IF
		END IF

END CHOOSE 


end event

event po_tabclicked;call super::po_tabclicked;//************************************************************************************************
//
//  Event:   po_tabclicked
//  Purpose: Change the menus, enable/disable menu items and disable/enable tabs based
//           on what the user is doing.  Call the PowerLock security function after
//           changing any menu to determin if the user can update a closed case.
//
//
//  Date     Person       Description of Change
//  -------- ----------- -------------------------------------------------------------------------
//  04/05/99 RAE         Commented out some code for click of tab 7.  This code was being executed 
//                       in the retrieve of the dw anyway.
//  05/25/99 M. Caruso   Disable tabs 3-5 when the search screen is active, unless there are records 
//                       retrieved.
//  06/25/99 M. Caruso   For Tabs 7 & 8, if no rows are retrieved the system creates a new letter 
//                       or reminder automatically.
//  08/13/99 M. Caruso   For Tab 1, the window redraw was being turned off for the Case search 
//                       screen in a particular instance and was not being turned back on.  This 
//                       was corrected by moving the call to setredraw(TRUE).
//  08/20/99 M. Caruso   If the case status is void (on tabs 3-6) set the Enabled property of the 
//                       save menu item and toolbar button to FALSE.
//  08/23/99 M. Caruso   Modified updates to menu item text to include the shortcut key notation 
//                       where appropriate.
//  09/24/99 M. Caruso   Added code to control the enabling/disabling of the m_viewcasedetailreport 
//                       menu item.
//  10/18/99 M. Caruso   Added code to manage the availability of the New Case menu items based on 
//                       the tab selected.
//  01/12/00 M. Caruso   In CASE 1, rebuild the configurable field list if the source type has changed.
//  02/17/00 C. Jackson  Enable/Disable m_documentquickinterface as necessary
//  04/15/00 M. Caruso   Set m_file.m_search to Enabled for Case 3 - Inquiry Tab
//  05/04/00 M. Caruso   Corrected the setting of the enalbed property for the Search menu item on 
//                       the Inquiry Tab.  Also corrected the setting of the enabled status for the 
//							    View and Print Case Detail Report menu items on the various case entry tabs.
//  06/29/00 C. Jackson  Comment out the enabling of tabs 3 - 6.  They should never be enabled
//                       on the search screen.  (SCR 686)
//  08/18/00 M. Caruso   Modified the code so that m_reassigncasesubject is only enabled when the
//                       user is on the dmographics screen and the case subject type is "Other".
//	 08/22/00 M. Caruso   Reversed previous change.
//  09/21/00 M. Caruso   Commented out all references to dw_case_history on uo_demographics.
//  09/28/00 M. Caruso   Rearranged code to always update available tabs first, then menu items.
//								 Also cleaned up old code and comments.
//  10/30/00 M. Caruso   Removed reference to m_addcasecomments.
//  11/20/00 C. Jackson  Enable 
//  11/22/2000 K. Claver Added code to disable the case transfer option if the current user
//								 isn't the current owner of the case.
//  11/30/00 M. Caruso   Updated the code for enabling/disabling the transfer case menu item.
//  12/08/00 M. Caruso   Enable Case tab from Demographics and Contact Notes tabs if
//								 i_cSelectedCase is set.
//  12/12/00 M. Caruso   Removed code from CASE 5 (Case tab) that sets the GUI based on the case
//                       status.  This functionality is handled by the tab.
//  12/20/00 M. Caruso   Removed code from CASE 5 that updates the window title.  This has been
//								 moved to the case details datawindow on the case details tab.
//  12/20/00 C. Jackson  Removed retrieval of Special Flags, moved to m_search (SCR 1134)
//  12/20/00 M. Caruso   Added code to disable m_changecasetype and m_reopencase on all tabs
//								 except the Case tab (#5).
//  12/28/00 M. Caruso   Updated the code to only enable m_reassigncasesubject on tab 4 and tab 5.
//  01/14/01 M. Caruso   Updated the name setting of m_save for each tab.
//  03/05/01 C. Jackson  Enable Cross Reference tab
//  04/09/01 C. Jackson  Correct window title
//  04/11/01 C. Jackson  Enable Contact Notes and Contact History when on the Cross Ref tab (SCR 1633)'
//  04/12/01 C. Jackson  Disabled New Other Case Subject, disabled Save Cross Reference (SCR 1639)
//  06/04/01 C. Jackson  If source_type = 'P' then use i_cProviderKey rather than i_cCurrentCaseSubject
//  6/13/2001 K. Claver  Added code to enable/disable the linking edit menu items.
//  07/09/01 M. Caruso   On the correspondence tab, rename the Delete menu item "Delete Correspondence"
//  07/10/01 C. Jackson  Add code to set the title appropriate if this is a vendor and provider
//  09/06/01 M. Caruso   Removed initial in-line SELECT statement for retrieving provider ID and vendor ID.
//  12/04/01 M. Caruso   Added check of security level before enabling Case Tab from other Tabs.
//  12/17/01 C. Jackson  Disable Documents Quick Interface if on the Search tab.  (SCR 2585)
//  2/15/2002 K. Claver  Changed to call the RowCount function on the reminders history datawindow
//								 rather than the GetRow function to determine if reminders exist for the case.
//  3/13/2002 K. Claver  Added calls to locking functions to lock the case details and/or menu
//								 items to prevent the user from modifying a case that is locked by someone else.
//	 3/13/2002 K. Claver  Added code to add the locked by information to the title if switched to
//								 the correspondence or reminders tab.
//  4/11/2002 K. Claver  Added code to disable the close case button when switch to the cross ref tab
//  07/03/03 M. Caruso   Removed setting of i_cCaseStatus to Open on switch to the Case Tab.
//************************************************************************************************

BOOLEAN	l_bAllowXferCase
LONG 		l_nSearchRow, l_nSelectedRows[], l_nRow, l_nSpecialFlags, l_nXRefCount
STRING   l_cCaseStatus, l_cUserID, l_cCaseRep, l_cGroupID, l_cTakenBy, l_cCaseType, l_cSourceDesc
STRING   l_cSourceID, l_cStatusDesc, l_cCaseMasterNum, l_cConcatSubject
U_DW_STD l_dwSpecialFlags

long ll_contacthistory_row
string ls_case_number

IF ISVALID(i_uoDemographics) THEN
	l_dwSpecialFlags = w_create_maintain_case.i_uoDemographics.dw_display_special_flags
END IF

l_cUserID = OBJCA.WIN.fu_GetLogin( SQLCA )

// Get the source type description for display on the window title bar
CHOOSE CASE i_cSourceType
	CASE 'C'
		l_cSourceDesc = 'Member'
	CASE 'E'
		l_cSourceDesc = 'Group'
	CASE 'O'
		l_cSourceDesc = 'Other'
	CASE 'P'
		l_cSourceDesc = 'Provider'

// commented out on 9/6/01, MPC
//		SELECT provider_key, provider_id, vendor_id INTO :i_nProviderKey, :i_cProviderID, :i_cVendorID
//		  FROM cusfocus.provider_of_service
//		 WHERE provider_id = :i_cCurrentCaseSubject
//		 USING SQLCA;
//		 
//		i_cProviderKey = STRING(i_nProviderKey)
		
END CHOOSE

CHOOSE CASE i_cCaseType
	CASE i_cConfigCaseType
		l_cCaseType = gs_ConfigCaseType
		
	CASE i_cInquiry
		l_cCaseType = 'Inquiry'
		
	CASE i_cIssueConcern
		l_cCaseType = 'Issue/Concern'
		
	CASE i_cProactive
		l_cCaseType = 'Proactive'
		
END CHOOSE

SELECT case_status_id INTO :l_cCaseStatus FROM cusfocus.case_log 
WHERE case_number = :Parent.i_cCurrentCase;

IF SQLCA.SQLCode = 0 THEN
	CHOOSE CASE l_cCaseStatus
		CASE 'C'
			i_uoCaseDetails.i_cCaseStatus = i_cStatusClosed
			l_cStatusDesc = 'Closed'
			
		CASE 'V'
			i_uoCaseDetails.i_cCaseStatus = i_cStatusVoid
			l_cStatusDesc = 'Void'
			
		CASE 'O'
			i_uoCaseDetails.i_cCaseStatus = i_cStatusOpen
			l_cStatusDesc = 'Open'
			
	END CHOOSE
END IF


CHOOSE CASE i_SelectedTab
	CASE 1		//	Search Criteria
		//Unlock the current case, if there is a current case
		IF NOT IsNull( PARENT.i_cCurrentCase ) AND Trim( PARENT.i_cCurrentCase ) <> "" AND &
			NOT PARENT.i_bCaseLocked THEN
			IF IsValid( i_uoCaseDetails ) THEN
				i_uoCaseDetails.tab_folder.tabpage_case_details.fu_UnlockCase( )
			END IF
		END IF
		
		IF NOT IsValid( i_uoCaseDetails ) THEN
			// RAP - initialize case details to ensure that the
			//			transobject is set in case they go to the
			//			contact history and select a case as the first action
			PARENT.SetRedraw(FALSE)
			fu_enabletab(5)
			fu_SelectTab (5)
			fu_disabletab(5)
			THIS.POST fu_SelectTab(1)
			RETURN
		ELSE
			Parent.SetRedraw(TRUE)
			uo_search_criteria.dw_search_criteria.POST SetFocus()
		END IF
		
		// Update available tabs
		IF (uo_search_criteria.uo_matched_records.dw_matched_records.RowCount() > 0) THEN  

			fu_EnableTab(2)
			fu_EnableTab(3)
			fu_EnableTab(4)
			//-----------------------------------------------------------------------------------------------------------------------------------
			// JWhite Added 6.6.2005	The case tab wasn't disabled even when you had rows in the result set.
			//-----------------------------------------------------------------------------------------------------------------------------------
//			fu_EnableTab(5)
			
		ELSE
			
			fu_DisableTab(2)
			fu_DisableTab(3)
			fu_DisableTab(4)

			//-----------------------------------------------------------------------------------------------------------------------------------
			// JWhite Added 6.6.2005	The case tab wasn't disabled even when you had rows in the result set.
			//-----------------------------------------------------------------------------------------------------------------------------------
			fu_DisableTab(5)			
		END IF
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// JWhite Removed 6.6.2005	The case tab wasn't disabled even when you had rows in the result set.
		//-----------------------------------------------------------------------------------------------------------------------------------
		fu_DisableTab(5)
		
		fu_DisableTab(6)
		fu_DisableTab(7)
		fu_DisableTab(8)
		
		// now update the menu items
		string ls_dataobject
		ls_dataobject = uo_search_criteria.uo_matched_records.dw_matched_records.DataObject
		IF (uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> 'd_matched_cases') And (uo_search_criteria.uo_matched_records.dw_matched_records.DataObject <> 'd_matched_cases_caseprops')THEN
			m_create_maintain_case.m_file.m_printsetup.Enabled 				= FALSE
			m_create_maintain_case.m_file.m_documentquickinterface.Enabled = FALSE

		ELSE

			m_create_maintain_case.m_file.m_printsetup.Enabled 				= TRUE
			m_create_maintain_case.m_file.m_documentquickinterface.Enabled	= TRUE

			//	If the there is a SelectedCase then we need to make sure that we selected
			// if there	were not changes to cause a retrieve on the datawindow.
			IF NOT i_bSearchCriteriaUpdate THEN
				IF i_cSelectedCase <> '' THEN
					Parent.SetRedraw(FALSE)
					l_nSearchRow = uo_search_criteria.uo_matched_records.dw_matched_records.Find(&
						"case_number = '" + i_cSelectedCase + "'", 1, &
						uo_search_criteria.uo_matched_records.dw_matched_records.RowCount())

					IF l_nSearchRow > 0 THEN
						l_nSelectedRows[1] = l_nSearchRow
						uo_search_criteria.uo_matched_records.dw_matched_records.SelectRow(0, FALSE)
						uo_search_criteria.uo_matched_records.dw_matched_records.fu_SetSelectedRows(&
							1, l_nSelectedRows[], &
							uo_search_criteria.uo_matched_records.dw_matched_records.c_IgnoreChanges, &
							uo_search_criteria.uo_matched_records.dw_matched_records.c_NoRefreshChildren)
							uo_search_criteria.uo_matched_records.dw_matched_records.fu_View()	
					END IF
					Parent.SetRedraw(TRUE)
				END IF
			END IF
		END IF
		
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled			= FALSE
		m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled = FALSE
		m_create_maintain_case.m_file.m_clearsearchcriteria.Enabled 	= TRUE
		m_create_maintain_case.m_file.m_search.Enabled 						= TRUE
		m_create_maintain_case.m_file.m_new.Enabled 							= TRUE
		m_create_maintain_case.m_file.m_new.Text								= '&New "Other" Case Subject~tCtrl+N'
		m_create_maintain_case.m_file.MicroHelp								= 'New "Other" Case Subject'
		m_create_maintain_case.m_file.ToolBarItemText						= 'New "Other" Case Subject'
		m_create_maintain_case.m_file.m_newcase.Enabled 					= FALSE
		m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled 		= FALSE
		m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled = FALSE
		m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled 	= FALSE
		m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled 	= FALSE
//		m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 	= FALSE
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 	= FALSE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 	= FALSE
		m_create_maintain_case.m_file.m_documentquickinterface.Enabled = FALSE

		// If we need a CaseSubject then enable the Save Case menu item.
		m_create_maintain_case.m_file.m_save.Text								= 'Sa&ve Case~tCtrl+S'
		m_create_maintain_case.m_file.m_save.MicroHelp						= 'Save Case'
		m_create_maintain_case.m_file.m_save.ToolBarItemText				= 'Save Case'
		IF i_bNeedCaseSubject THEN
			m_create_maintain_case.m_file.m_save.Enabled 					= TRUE
		ELSE
			m_create_maintain_case.m_file.m_save.Enabled 					= FALSE
		END IF
	
		m_create_maintain_case.m_edit.m_sort.Enabled 						= TRUE 

		m_create_maintain_case.m_file.m_transfercase.Enabled 				= FALSE
		
		m_create_maintain_case.m_file.m_print.Enabled 						= FALSE
		m_create_maintain_case.m_file.m_print.Text							= '&Print'
		m_create_maintain_case.m_file.m_print.MicroHelp						= 'Print'
		m_create_maintain_case.m_file.m_print.ToolBarItemText				= 'Print'

		m_create_maintain_case.m_edit.m_modifycasereminder.Enabled 		= FALSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled 		= FAlSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Text					= '&Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.MicroHelp			= 'Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.ToolBarItemText	= 'Edit Correspondence'		
		
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 		= FALSE
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'
		
		m_create_maintain_case.m_edit.m_closecase.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_voidcase.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 	= FALSE
		m_create_maintain_case.m_edit.m_contactperson.Enabled 			= FALSE
		m_create_maintain_case.m_edit.m_changecasetype.Enabled 			= FALSE
		m_create_maintain_case.m_edit.m_reopencase.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_financialcompensation.Enabled 	= FALSE
		
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
		
		//	If we have created a New Case Subject and the user has the search criteria set
		//	for anything but Other, we will be out of sync.  If this is the case, get the
		//	Previous values for the SourceType, CaseSubjectID and CaseSubject Name and 
		//	restore them.
		IF i_bNewCaseSubject THEN
			IF i_cPreviousSourceType <> i_cSourceType THEN
				i_cCaseSubjectName = i_cPreviousCaseSubjectName
				i_cCurrentCaseSubject = i_cPreviousCaseSubject
				IF i_cPreviousSourceType = 'P' THEN
					i_cProviderKey = i_cPreviousCaseSubject
					i_nProviderKey = Long( i_cPreviousCaseSubject )
				ELSE
					SetNull( i_cProviderKey )
					SetNull( i_nProviderKey )
				END IF
				i_cSourceType = i_cPreviousSourceType
				fw_buildfieldlist (i_cSourceType)		// MPC - 1/12/00
			END IF
			i_bNewCaseSubject = FALSE
		END IF
//		PARENT.Title = PARENT.TAG + ' ' + i_cCaseSubjectName
		uo_search_criteria.uo_matched_records.dw_matched_records.SetFocus()
		
		//Disable the iim option
		m_create_maintain_case.m_features.m_iim.Enabled								   = FALSE
		
		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			
			w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
		END IF
		
		// Clear out the special flags from previous search
		IF ISVALID(i_uoDemographics) THEN
			l_dwSpecialFlags = w_create_maintain_case.i_uoDemographics.dw_display_special_flags
			l_nSpecialFlags = l_dwSpecialFlags.Retrieve('0','0')

		END IF
		
		// Clear out vendor id and provider id
		SETNULL(i_cProviderID)
		SETNULL(i_cVendorID)
		
		PARENT.Title = 'Create and Maintain Case'
		
	CASE 2		// Demographics
		//Unlock the current case, if there is a current case
		IF NOT IsNull( PARENT.i_cCurrentCase ) AND Trim( PARENT.i_cCurrentCase ) <> "" AND &
			NOT PARENT.i_bCaseLocked THEN
			IF IsValid( i_uoCaseDetails ) THEN
				i_uoCaseDetails.tab_folder.tabpage_case_details.fu_UnlockCase( )
			END IF
		END IF		

		// Update available tabs
		fu_EnableTab(2)
		fu_EnableTab(3)
		fu_EnableTab(4)
		IF i_cSelectedCase = '' THEN
			fu_DisableTab(5)
		ELSE
			IF (i_nRepConfidLevel >= i_nCaseConfidLevel) OR (i_cCurrCaseRep = i_cUserID) THEN
				fu_EnableTab(5)
			ELSE
				fu_DisableTab(5)
			END IF
		END IF
		
		IF PARENT.i_cSourceType = 'P' THEN
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cProviderKey AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
			 
		ELSE

			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cCurrentCaseSubject AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
			 
		END IF
			
		IF l_nXRefCount > 0 THEN
			fu_EnableTab(6)
		ELSE 
			fu_DisableTab(6)
		END IF

		fu_DisableTab(7)
		fu_DisableTab(8)
		
		// now update the menu items
		m_create_maintain_case.m_file.m_clearsearchcriteria.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_search.Enabled 								= FALSE
		
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled					= TRUE
		
		//Set record security
//		9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin		
//		IF i_cSetRecordSecurity = "Y" OR OBJCA.WIN.fu_GetLogin( SQLCA ) = "sysadmin" THEN
		IF i_cSetRecordSecurity = "Y" OR OBJCA.WIN.fu_GetLogin( SQLCA ) = "cfadmin" THEN
			m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 		= TRUE
		ELSE
			m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 		= FALSE
		END IF
		
		m_create_maintain_case.m_file.m_new.Enabled 									= TRUE
		m_create_maintain_case.m_file.m_new.Text										= '&New "Other" Case Subject~tCtrl+N'
		m_create_maintain_case.m_file.m_new.MicroHelp								= 'New "Other" Case Subject'
		m_create_maintain_case.m_file.m_new.ToolBarItemText						= 'New "Other" Case Subject'	
		m_create_maintain_case.m_file.m_newcase.Enabled 							= TRUE
		m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled 				= TRUE
		m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled 		= TRUE
		m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled 			= TRUE
//		m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 			= TRUE
		
		m_create_maintain_case.m_file.m_printsetup.Enabled 						= TRUE
		m_create_maintain_case.m_file.m_documentquickinterface.Enabled			= TRUE
		m_create_maintain_case.m_edit.m_sort.Enabled 								= FALSE
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= FALSE

		IF i_cSourceType = i_cSourceOther THEN
			
			IF i_bNeedCaseSubject AND i_bNewCaseSubject THEN
				m_create_maintain_case.m_file.m_save.Text								= 'Sa&ve Case Subject and Case~tCtrl+S'
				m_create_maintain_case.m_file.m_save.MicroHelp						= 'Save Case Subject and Case'
				m_create_maintain_case.m_file.m_save.ToolBarItemText				= 'Save Case Subject and Case'
			ELSE
				m_create_maintain_case.m_file.m_save.Text								= 'Sa&ve Case Subject~tCtrl+S'
				m_create_maintain_case.m_file.m_save.MicroHelp						= 'Save Case Subject'
				m_create_maintain_case.m_file.m_save.ToolBarItemText				= 'Save Case Subject'
			END IF
			m_create_maintain_case.m_file.m_save.Enabled 							= TRUE
			
		ELSE
			
			m_create_maintain_case.m_file.m_save.Enabled 							= FALSE
			m_create_maintain_case.m_file.m_save.Text									= 'Sa&ve~tCtrl+S' 
			m_create_maintain_case.m_file.m_save.MicroHelp							= 'Save'
			m_create_maintain_case.m_file.m_save.ToolBarItemText					= 'Save'

		END IF
		  
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 		= FALSE
		m_create_maintain_case.m_file.m_transfercase.Enabled 						= FALSE
		m_create_maintain_case.m_file.m_print.Enabled 								= FALSE
		m_create_maintain_case.m_file.m_print.Text									= '&Print'	
		m_create_maintain_case.m_file.m_print.MicroHelp								= 'Print'
		m_create_maintain_case.m_file.m_print.ToolBarItemText						= 'Print'

		m_create_maintain_case.m_edit.m_modifycasereminder.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled 				= FAlSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Text					= '&Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.MicroHelp			= 'Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.ToolBarItemText	= 'Edit Correspondence'
		
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'
		
		m_create_maintain_case.m_edit.m_closecase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_voidcase.Enabled 							= FALSE

		m_create_maintain_case.m_edit.m_contactperson.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_changecasetype.Enabled 			= FALSE
		m_create_maintain_case.m_edit.m_reopencase.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_financialcompensation.Enabled 			= FALSE
		
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE

		IF i_cSourceType = 'P' THEN
			SELECT provider_id, vendor_id INTO :i_cProviderID, :i_cVendorID
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = :i_nProviderKey
			 USING SQLCA;
			 
			IF ISNULL(i_cProviderID) THEN
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = 'Vendor ID: '+i_cVendorID
				END IF
			ELSE
				l_cConcatSubject = 'Provider ID: '+i_cProviderID
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_cVendorID
				END IF
			END IF

			 PARENT.Title = l_cSourceDesc + ' - ' + l_cConcatSubject + ' - ' + i_cCaseSubjectName
			 
		ELSE
			PARENT.Title = l_cSourceDesc + ' - ' + i_cCurrentCaseSubject + ' - ' + i_cCaseSubjectName
			 
		END IF
		
		//Enable the iim option
		m_create_maintain_case.m_features.m_iim.Enabled								   = TRUE

		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			
			w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
		END IF

		// Retrieve special flags if necessary
		
		i_uoDemographics.dw_display_special_flags.SetRedraw(FALSE)
		i_uoDemographics.dw_display_special_flags.Hide()
		
		l_dwSpecialFlags = w_create_maintain_case.i_uoDemographics.dw_display_special_flags
		
		IF w_create_maintain_case.i_cSourceType ='C' THEN
			
			// Get Group ID
			SELECT group_id INTO :l_cGroupID
			  FROM cusfocus.consumer
			 WHERE consumer_id = :w_create_maintain_case.i_cCurrentCaseSubject
			 USING SQLCA;
						 
			l_dwSpecialFlags.fu_Swap('d_display_consumer_special_flags', l_dwSpecialFlags.c_Ignorechanges, l_dwSpecialFlags.c_NoMenuButtonActivation)
			l_dwSpecialFlags.SetTransObject(SQLCA)
			l_nSpecialFlags = l_dwSpecialFlags.Retrieve(w_create_maintain_case.i_cCurrentCaseSubject, l_cGroupID)
			
		ELSE

				l_dwSpecialFlags.fu_Swap('d_display_special_flags', l_dwSpecialFlags.c_Ignorechanges, l_dwSpecialFlags.c_NoMenuButtonActivation)
				l_dwSpecialFlags.SetTransObject(SQLCA)
				
				IF w_create_maintain_case.i_cCurrentCaseSubject <> '' THEN
					
					IF i_cSourceType = 'P' THEN
						l_nSpecialFlags = l_dwSpecialFlags.Retrieve(i_cProviderKey, &
							i_cSourceType)
					ELSE
						l_nSpecialFlags = l_dwSpecialFlags.Retrieve(i_cCurrentCaseSubject, &
							i_cSourceType)
					END IF
				ELSE
					l_nSpecialFlags = l_dwSpecialFlags.Retrieve('0','0')

				END IF
				
		END IF

		i_uoDemographics.dw_display_special_flags.Show()
		i_uoDemographics.dw_display_special_flags.SetReDraw(TRUE)

		INSERT INTO cusfocus.demographics_view_log
			(user_id,
			subject_id,
			subject_name,
			source_desc,
			viewed_timestamp)
		values
			(:l_cUserID,
			:i_cCurrentCaseSubject,
			:i_cCaseSubjectName,
			:l_cSourceDesc,
			getdate())
		USING SQLCA;
			
	CASE 3		//		Contact Notes Tab
		
		//Unlock the current case, if there is a current case
		IF NOT IsNull( PARENT.i_cCurrentCase ) AND Trim( PARENT.i_cCurrentCase ) <> "" AND &
			NOT PARENT.i_bCaseLocked THEN
			IF IsValid( i_uoCaseDetails ) THEN
				i_uoCaseDetails.tab_folder.tabpage_case_details.fu_UnlockCase( )
			END IF
		END IF
		
		// Update available tabs
		fu_EnableTab(2)
		fu_EnableTab(3)
		fu_EnableTab(4)
		IF i_cSelectedCase = '' THEN
			fu_DisableTab(5)
		ELSE
			IF (i_nRepConfidLevel >= i_nCaseConfidLevel) OR (i_cCurrCaseRep = i_cUserID) THEN
				fu_EnableTab(5)
			ELSE
				fu_DisableTab(5)
			END IF
		END IF
		IF PARENT.i_cSourceType = 'P' THEN
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cProviderKey AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		ELSE
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cCurrentCaseSubject AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		END IF

		IF l_nXRefCount > 0 THEN
			fu_EnableTab(6)
		ELSE 
			fu_DisableTab(6)
		END IF

		fu_DisableTab(7)
		fu_DisableTab(8)
		
		// now update the menu items
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled              = FALSE
		m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 		= FALSE
		m_create_maintain_case.m_file.m_clearsearchcriteria.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_search.Enabled 								= FALSE

		m_create_maintain_case.m_file.m_new.Enabled 									= TRUE
		m_create_maintain_case.m_file.m_new.Text										= '&New Contact Note~tCtrl+N'
		m_create_maintain_case.m_file.m_new.MicroHelp								= 'New Contact Note'
		m_create_maintain_case.m_file.m_new.ToolBarItemText						= 'New Contact Note'
		
		m_create_maintain_case.m_file.m_newcase.Enabled 							= TRUE
		m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled 				= TRUE
		m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled 		= TRUE
		m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled 			= TRUE
//		m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 			= TRUE
		
		m_create_maintain_case.m_file.m_printsetup.Enabled 						= TRUE
		m_create_maintain_case.m_file.m_documentquickinterface.Enabled			= TRUE
		m_create_maintain_case.m_edit.m_sort.Enabled 								= TRUE
		
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= FALSE
	
		m_create_maintain_case.m_file.m_transfercase.Enabled 						= FALSE
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 			= FALSE
		
		m_create_maintain_case.m_file.m_save.Text										= 'Sa&ve Contact Note~tCtrl+S'
		m_create_maintain_case.m_file.m_save.MicroHelp								= 'Save Contact Note'
		m_create_maintain_case.m_file.m_save.ToolBarItemText						= 'Save Contact Note'
		m_create_maintain_case.m_file.m_save.Enabled 								= TRUE
			
		m_create_maintain_case.m_file.m_print.Enabled 								= FALSE
		m_create_maintain_case.m_file.m_print.Text									= '&Print'	
		m_create_maintain_case.m_file.m_print.MicroHelp								= 'Print'
		m_create_maintain_case.m_file.m_print.ToolBarItemText						= 'Print'

		m_create_maintain_case.m_edit.m_modifycasereminder.Enabled 				= FALSE
		
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled 				= TRUE
		m_create_maintain_case.m_edit.m_editcorrespondence.Text					= '&Edit Contact Note'
		m_create_maintain_case.m_edit.m_editcorrespondence.MicroHelp			= 'Edit Contact Note'
		m_create_maintain_case.m_edit.m_editcorrespondence.ToolBarItemText	= 'Edit Contact Note'
		
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 				= TRUE
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Contact Note'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Contact Note'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Contact Note'
		
		m_create_maintain_case.m_edit.m_closecase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_voidcase.Enabled 							= FALSE

		m_create_maintain_case.m_edit.m_contactperson.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_changecasetype.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_reopencase.Enabled 						= FALSE
		m_create_maintain_case.m_edit.m_financialcompensation.Enabled 			= FALSE
		
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
		
		IF i_cSourceType = 'P' THEN
			SELECT provider_id, vendor_id INTO :i_cProviderID, :i_cVendorID
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = :i_nProviderKey
			 USING SQLCA;
			 
			 
			 IF ISNULL(i_cProviderID) THEN
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = 'Vendor ID: '+i_cVendorID
				END IF
			ELSE
				l_cConcatSubject = 'Provider ID: '+i_cProviderID
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_cVendorID
				END IF
			END IF

			 PARENT.Title = l_cSourceDesc + ' - ' + l_cConcatSubject + ' - ' + i_cCaseSubjectName
			 
		ELSE
			PARENT.Title = l_cSourceDesc + ' - ' + i_cCurrentCaseSubject + ' - ' + i_cCaseSubjectName
			 
		END IF
		
		//Re-retrieve the contact notes for this case subject name
		IF IsValid( i_uoContactNotes ) THEN
			IF i_cCurrentCaseSubject <> i_uoContactNotes.i_cKeyValue OR i_cSourceType <> i_uoContactNotes.i_cLastSourceType THEN
				i_uoContactNotes.dw_contact_note_list.SetTransObject( SQLCA )
				i_uoContactNotes.dw_contact_note_list.fu_Retrieve( i_uoContactNotes.dw_contact_note_list.c_IgnoreChanges, &
																					i_uoContactNotes.dw_contact_note_list.c_NoReselectRows )
			END IF
		END IF
		
		//Enable the iim option
		m_create_maintain_case.m_features.m_iim.Enabled								   = TRUE
		
		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			
			w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
		END IF

	CASE 4		//		Contact History Tab
		//Unlock the current case, if there is a current case
		IF NOT IsNull( PARENT.i_cCurrentCase ) AND Trim( PARENT.i_cCurrentCase ) <> "" AND NOT PARENT.i_bCaseLocked THEN
			IF IsValid( i_uoCaseDetails ) THEN
				i_uoCaseDetails.tab_folder.tabpage_case_details.fu_UnlockCase( )
			END IF
		END IF
		

		ll_contacthistory_row = i_uoContactHistory.uo_search_contact_history.dw_report.GetRow()
		If ll_contacthistory_row > 0 and ll_contacthistory_row <= i_uoContactHistory.uo_search_contact_history.dw_report.RowCount() Then
			i_cSelectedCase = i_uoContactHistory.uo_search_contact_history.dw_report.GetItemString(ll_contacthistory_row, 'case_number')			
		End If

		
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// JWhite Added 6.27.2005
		//
		// If this isn't the first time we've opened the window, then build the case properties.
		//-----------------------------------------------------------------------------------------------------------------------------------
//		If	ib_contacthistory_firstopen <> TRUE Then
//			i_uoContactHistory.of_build_case_properties()
//			i_uoContactHistory.of_retrieve()
//		End If
		
		// Update available tabs
		fu_EnableTab(2)
		fu_EnableTab(3)
		fu_EnableTab(4)
//		IF i_uoContactHistory.dw_case_history.RowCount () > 0 THEN
//			IF (i_nRepConfidLevel >= i_nCaseConfidLevel) OR (i_cCurrCaseRep = i_cUserID) THEN
//				fu_EnableTab(5)
//			ELSE
//				fu_DisableTab(5)
//			END IF
//		ELSE
//			fu_DisableTab(5)
//		END IF
		IF PARENT.i_cSourceType = 'P' THEN
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cProviderKey AND 
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		ELSE
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cCurrentCaseSubject AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		END IF
			
		IF l_nXRefCount > 0 THEN
			fu_EnableTab(6)
		ELSE 
			fu_DisableTab(6)
		END IF

		fu_DisableTab(7)
		fu_DisableTab(8)
		
		// now update the menu items
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled              = FALSE
		m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 		= FALSE
		m_create_maintain_case.m_file.m_clearsearchcriteria.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_search.Enabled 								= TRUE

		m_create_maintain_case.m_file.m_new.Enabled 									= FALSE
		m_create_maintain_case.m_file.m_new.Text										= '&New "Other" Case Subject~tCtrl+N'
		m_create_maintain_case.m_file.m_new.MicroHelp								= 'New "Other" Case Subject'
		m_create_maintain_case.m_file.m_new.ToolBarItemText						= 'New "Other" Case Subject'	
		m_create_maintain_case.m_file.m_newcase.Enabled 							= TRUE
		m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled 				= TRUE
		m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled 		= TRUE
		m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 			= TRUE
		
		m_create_maintain_case.m_file.m_printsetup.Enabled 						= TRUE
		m_create_maintain_case.m_file.m_documentquickinterface.Enabled			= TRUE
		m_create_maintain_case.m_edit.m_sort.Enabled 								= TRUE
		
		// Enable/Disable Transfer Case depending on status and if a row is highlighted
		l_bAllowXferCase = FALSE
		IF IsValid( i_uoContactHistory ) THEN
			l_nRow = i_uoContactHistory.uo_search_contact_history.dw_report.GetRow ( )
//RAP			l_nRow = i_uoContactHistory.dw_case_history.GetSelectedRow ( 0 )
			IF l_nRow > 0 THEN
				l_cCaseMasterNum = i_uoContactHistory.uo_search_contact_history.dw_report.Object.case_log_master_case_number[ l_nRow ]
				
				//-----------------------------------------------------------------------------------------------------------------------------------
				// JWhite 5.17.05		Set the Master Case Number to null if the case isn't linked.
				//-----------------------------------------------------------------------------------------------------------------------------------
				If lower(l_cCaseMasterNum) = 'not linked' Then SetNull(l_cCaseMasterNum)
				
				CHOOSE CASE Upper( i_uoContactHistory.uo_search_contact_history.dw_report.GetItemString( l_nRow, 'case_stat_desc' ) )
					CASE 'OPEN'
						// Also disable the button if the current user isn't the owner of the case
						l_cCaseRep = i_uoContactHistory.uo_search_contact_history.dw_report.GetItemString ( l_nRow, 'case_log_case_log_case_rep' )
						l_cTakenBy = i_uoContactHistory.uo_search_contact_history.dw_report.GetItemString ( l_nRow, 'case_log_case_log_taken_by' )
						IF Upper( l_cCaseRep ) = Upper( l_cUserID ) OR &
							Upper( l_cTakenBy ) = Upper( l_cUserID ) THEN 
							l_bAllowXferCase = TRUE
						END IF
						
						IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
							m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
							m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
						ELSE
							m_create_maintain_case.m_edit.m_linkcase.Enabled = PARENT.i_bLinked
							m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
						END IF
					CASE 'CLOSED'
						IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
							m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
							m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
						ELSE
							m_create_maintain_case.m_edit.m_linkcase.Enabled = PARENT.i_bLinked
							m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
						END IF
					CASE ELSE
						IF NOT IsNull( l_cCaseMasterNum ) AND Trim( l_cCaseMasterNum ) <> "" THEN
							m_create_maintain_case.m_edit.m_removelink.Enabled = TRUE
						ELSE
							m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
						END IF
						
						m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
				END CHOOSE
			END IF
		END IF
		m_create_maintain_case.m_file.m_transfercase.Enabled 						= l_bAllowXferCase
		
		IF i_cSourceType = i_cSourceOther THEN
			
			IF i_uoContactHistory.uo_search_contact_history.dw_report.RowCount () > 0 AND NOT PARENT.i_bCaseLocked THEN
				m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 		= TRUE
			ELSE
				m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 		= FALSE
			END IF
			m_create_maintain_case.m_file.m_save.Enabled 							= TRUE
			IF i_bNeedCaseSubject AND i_bNewCaseSubject THEN
				m_create_maintain_case.m_file.m_save.Text								= 'Sa&ve Case Subject and Case~tCtrl+S'
				m_create_maintain_case.m_file.m_save.MicroHelp						= 'Save Case Subject and Case'
				m_create_maintain_case.m_file.m_save.ToolBarItemText				= 'Save Case Subject and Case'
			ELSE
				m_create_maintain_case.m_file.m_save.Text								= 'Sa&ve Case Subject~tCtrl+S'
				m_create_maintain_case.m_file.m_save.MicroHelp						= 'Save Case Subject'
				m_create_maintain_case.m_file.m_save.ToolBarItemText				= 'Save Case Subject'

			END IF
			
		ELSE
			
			m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 		= FALSE
			m_create_maintain_case.m_file.m_save.Enabled 							= FALSE
			m_create_maintain_case.m_file.m_save.Text									= 'Sa&ve~tCtrl+S' 
			m_create_maintain_case.m_file.m_save.MicroHelp							= 'Save'
			m_create_maintain_case.m_file.m_save.ToolBarItemText					= 'Save'

		END IF
		  
		m_create_maintain_case.m_file.m_print.Enabled 								= FALSE
		m_create_maintain_case.m_file.m_print.Text									= '&Print'	
		m_create_maintain_case.m_file.m_print.MicroHelp								= 'Print'
		m_create_maintain_case.m_file.m_print.ToolBarItemText						= 'Print'

		m_create_maintain_case.m_edit.m_modifycasereminder.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled 				= FAlSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Text					= '&Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.MicroHelp			= 'Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.ToolBarItemText	= 'Edit Correspondence'
		
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'
				
		m_create_maintain_case.m_edit.m_closecase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_voidcase.Enabled 							= FALSE

		m_create_maintain_case.m_edit.m_contactperson.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_changecasetype.Enabled 			= FALSE
		m_create_maintain_case.m_edit.m_reopencase.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_financialcompensation.Enabled 			= FALSE
		
		IF i_cSourceType = 'P' THEN
			SELECT provider_id, vendor_id INTO :i_cProviderID, :i_cVendorID
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = :i_nProviderKey
			 USING SQLCA;
			 
			 
			 IF ISNULL(i_cProviderID) THEN
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = 'Vendor ID: '+i_cVendorID
				END IF
			ELSE
				l_cConcatSubject = 'Provider ID: '+i_cProviderID
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_cVendorID
				END IF
			END IF

			 PARENT.Title = l_cSourceDesc + ' - ' + l_cConcatSubject + ' - ' + i_cCaseSubjectName
			 
		ELSE
			PARENT.Title = l_cSourceDesc + ' - ' + i_cCurrentCaseSubject + ' - ' + i_cCaseSubjectName
			 
		END IF
		
		//Enable the iim option
		m_create_maintain_case.m_features.m_iim.Enabled								   = TRUE
		
		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			
			w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
		END IF

	CASE 5		//		Case Tab
		// Update available tabs
		fu_EnableTab(2)
		fu_EnableTab(3)
		fu_EnableTab(4)
		fu_EnableTab(5)
		IF PARENT.i_cSourceType = 'P' THEN
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cProviderKey AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		ELSE
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cCurrentCaseSubject AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		END IF			

		IF l_nXRefCount > 0 THEN
			fu_EnableTab(6)
		ELSE 
			fu_DisableTab(6)
		END IF

		// you cannot add correspondece or reminders until the case has been saved.
		IF i_cSelectedCase <> '' THEN
			fu_EnableTab(7)
			fu_EnableTab(8)
		ELSE
			fu_DisableTab(7)
			fu_DisableTab(8)
		END IF
		
		// now update the menu items
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled                 = FALSE
		m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_newcase.Enabled 								= TRUE
		m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled 					= TRUE
		m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled 				= TRUE
		m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled 				= TRUE
		
		//Taken care of in the fu_setcasegui functions in u_case_details.
//		m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 				= TRUE
		
		m_create_maintain_case.m_file.m_printsetup.Enabled 							= TRUE
		m_create_maintain_case.m_file.m_documentquickinterface.Enabled				= TRUE
		m_create_maintain_case.m_file.m_clearsearchcriteria.Enabled					= FALSE
		m_create_maintain_case.m_file.m_search.Enabled 									= FALSE
		m_create_maintain_case.m_file.m_new.Enabled 										= FALSE
		m_create_maintain_case.m_file.m_new.Text											= '&New~tCtrl+N'
		m_create_maintain_case.m_file.m_new.MicroHelp									= 'New'

		m_create_maintain_case.m_file.m_new.ToolBarItemText							= 'New'
		m_create_maintain_case.m_file.m_print.Enabled 									= FALSE
		m_create_maintain_case.m_file.m_print.Text										='&Print'
		m_create_maintain_case.m_file.m_print.MicroHelp									= 'Print'
		m_create_maintain_case.m_file.m_print.ToolBarItemText							= 'Print'
	
		m_create_maintain_case.m_edit.m_modifycasereminder.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled 					= FAlSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Text					= '&Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.MicroHelp			= 'Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.ToolBarItemText	= 'Edit Correspondence'
		
		IF IsValid( PARENT.i_uoCaseDetails ) THEN
			IF PARENT.i_uoCaseDetails.tab_folder.SelectedTab = 5 THEN 
				IF PARENT.i_uoCaseDetails.tab_folder.tabpage_carve_out.dw_carve_out_list.RowCount( ) > 0 AND &
					NOT PARENT.i_bCaseLocked THEN
					m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 				= TRUE
				ELSE
					m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 				= FALSE
				END IF
				
				m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Carve Out'
				m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Carve Out'
				m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Carve Out'	
			ELSE
				m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 					= FALSE
				m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
				m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
				m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'
			END IF
		ELSE
			m_create_maintain_case.m_edit.m_deletecasereminder.Enabled 					= FALSE
			m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
			m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
			m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'	
		END IF
			
		
		m_create_maintain_case.m_edit.m_financialcompensation.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_sort.Enabled 									= FALSE

		m_create_maintain_case.m_file.m_save.Text											='Sa&ve Case~tCtrl+S'
		m_create_maintain_case.m_file.m_save.MicroHelp									='Save Case'
		m_create_maintain_case.m_file.m_save.ToolBarItemText							='Save Case'

		//--------------------------------------------------------------------------------------
		//		get the status of the current case, or set status to open if no case number exists.
		//---------------------------------------------------------------------------------------
		IF Parent.i_cCurrentCase = '' THEN
			
			//i_uoCaseDetails.i_cCaseStatus = i_cStatusOpen
			m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 			= FALSE
			m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 			= FALSE
			
		ELSE
			
			m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 			= TRUE
			m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 			= TRUE
			
			
		END IF
		
		m_create_maintain_case.m_features.m_iim.Enabled								   = TRUE
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
		
		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			IF i_uoCaseDetails.i_cCaseStatus = i_cStatusOpen THEN
				m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = TRUE
				
				w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( TRUE )
			ELSE
				m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
				
				w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
			END IF
		END IF
		
	CASE 6		//		Cross Reference Tab
		//Unlock the current case, if there is a current case
		IF NOT IsNull( PARENT.i_cCurrentCase ) AND Trim( PARENT.i_cCurrentCase ) <> "" AND &
			NOT PARENT.i_bCaseLocked THEN
			IF IsValid( i_uoCaseDetails ) THEN
				i_uoCaseDetails.tab_folder.tabpage_case_details.fu_UnlockCase( )
			END IF
		END IF
		
		// Update available tabs
		fu_EnableTab(2)
		fu_EnableTab(3)
		fu_EnableTab(4)
		fu_DisableTab(5)
		fu_EnableTab(6)
		fu_DisableTab(7)
		fu_DisableTab(8)
		
		// now update the menu items
		m_create_maintain_case.m_features.m_iim.Enabled								= TRUE
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled					= FALSE
		m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 		= FALSE
		m_create_maintain_case.m_edit.m_changecasetype.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_reopencase.Enabled 						= FALSE
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled			= TRUE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= TRUE
		m_create_maintain_case.m_file.m_save.Enabled									= FALSE
		m_create_maintain_case.m_file.m_new.Enabled 									= FALSE
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE
		m_create_maintain_case.m_edit.m_sort.Enabled 						= TRUE 
		m_create_maintain_case.m_edit.m_closecase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_voidcase.Enabled 							= FALSE
		m_create_maintain_case.m_file.m_transfercase.Enabled 						= FALSE
		
		// update the window title
		
		//Enable the iim option
		m_create_maintain_case.m_features.m_iim.Enabled								   = TRUE
		
		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			
			w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
		END IF
		
		IF i_cSourceType = 'P' THEN
			SELECT provider_id, vendor_id INTO :i_cProviderID, :i_cVendorID
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = :i_nProviderKey
			 USING SQLCA;
			 
			 
			 IF ISNULL(i_cProviderID) THEN
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = 'Vendor ID: '+i_cVendorID
				END IF
			ELSE
				l_cConcatSubject = 'Provider ID: '+i_cProviderID
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_cVendorID
				END IF
			END IF

			 PARENT.Title = l_cSourceDesc + ' - ' + l_cConcatSubject + ' - ' + i_cCaseSubjectName
			 
		ELSE
			PARENT.Title = l_cSourceDesc + ' - ' + i_cCurrentCaseSubject + ' - ' + i_cCaseSubjectName
			 
		END IF


	CASE 7		//		Case Correspondence
		// Update available tabs
		fu_EnableTab(2)
		fu_EnableTab(3)
		fu_EnableTab(4)
		fu_EnableTab(5)
		IF PARENT.i_cSourceType = 'P' THEN
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cProviderKey AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		ELSE
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cCurrentCaseSubject AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		END IF

		IF l_nXRefCount > 0 THEN
			fu_EnableTab(6)
		ELSE 
			fu_DisableTab(6)
		END IF

		fu_EnableTab(7)
		fu_EnableTab(8)
		
		// now update the menu items
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled              = FALSE
		m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 		= FALSE
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 			= TRUE
//		m_create_maintain_case.m_file.m_new.Enabled 									= TRUE
		m_create_maintain_case.m_file.m_new.Text										= '&New Correspondence~tCtrl+N'
		m_create_maintain_case.m_file.m_new.MicroHelp								= 'New Correspondence'
		m_create_maintain_case.m_file.m_new.ToolBarItemText						= 'New Correspondence'
		m_create_maintain_case.m_file.m_save.Enabled 								= TRUE
		m_create_maintain_case.m_file.m_save.Text										='Sa&ve Correspondence~tCtrl+S'
		m_create_maintain_case.m_file.m_save.MicroHelp								='Save Correspondence'
		m_create_maintain_case.m_file.m_save.ToolBarItemText						='Save Correspondence'

		m_create_maintain_case.m_file.m_printsetup.Enabled 						= TRUE
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled			= TRUE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= TRUE
		m_create_maintain_case.m_file.m_documentquickinterface.Enabled			= TRUE


		m_create_maintain_case.m_edit.m_sort.Enabled 								= TRUE 

		m_create_maintain_case.m_file.m_clearsearchcriteria.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_search.Enabled 								= FALSE
		m_create_maintain_case.m_file.m_transfercase.Enabled 						= FALSE
		m_create_maintain_case.m_file.m_newcase.Enabled 							= TRUE
		m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled 				= TRUE
		m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled 		= TRUE
		m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled 			= TRUE
		
		m_create_maintain_case.m_edit.m_modifycasereminder.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Correspondence'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Correspondence'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Correspondence'
		
		
		m_create_maintain_case.m_edit.m_closecase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_voidcase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 			= FALSE
		m_create_maintain_case.m_edit.m_contactperson.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_changecasetype.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_reopencase.Enabled 						= FALSE
		m_create_maintain_case.m_edit.m_financialcompensation.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_print.Text									='&Print Correspondence'
		m_create_maintain_case.m_file.m_print.MicroHelp								= 'Print Correspondence'
		m_create_maintain_case.m_file.m_print.ToolBarItemText						= 'Print Correspondence'
		
		m_create_maintain_case.m_edit.m_linkcase.Enabled = FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled = FALSE

		// if no correspondence exist for an open case, create a new one.       MPC  6/25/99
		IF i_uoCaseDetails.i_cCaseStatus = i_cStatusOpen THEN
			IF i_uoCaseCorrespondence.dw_correspondence_list.GetRow() = 0 THEN
				TriggerEvent (w_create_maintain_case, "pc_new")
			END IF
		END IF
		
		IF i_cSourceType = 'P' THEN
			SELECT provider_id, vendor_id INTO :i_cProviderID, :i_cVendorID
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = :i_nProviderKey
			 USING SQLCA;
			 
			 
			 IF ISNULL(i_cProviderID) THEN
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = 'Vendor ID: '+i_cVendorID
				END IF
			ELSE
				l_cConcatSubject = 'Provider ID: '+i_cProviderID
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_cVendorID
				END IF
			END IF

			PARENT.Title = l_cSourceDesc + ' - ' + l_cConcatSubject + ' - ' + i_cCaseSubjectName + &
				' - ' + l_cCaseType + ' - ' + i_cCurrentCase + ' - ' + l_cStatusDesc

			 
		ELSE
			PARENT.Title = l_cSourceDesc + ' - ' + i_cCurrentCaseSubject + ' - ' + i_cCaseSubjectName + &
			' - ' + l_cCaseType + ' - ' + i_cCurrentCase + ' - ' + l_cStatusDesc
			 
		END IF
		
		//Add locked by information if the case is locked
		IF PARENT.i_bCaseLocked THEN
			PARENT.Title += " - Locked By "+PARENT.i_cLockedBy
		END IF

		//Enable the iim option
		m_create_maintain_case.m_features.m_iim.Enabled								   = TRUE
		
		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			
			w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
		END IF

	CASE 8		//		Case Reminders
		// Update available tabs
		fu_EnableTab(2)
		fu_EnableTab(3)
		fu_EnableTab(4)
		fu_EnableTab(5)
		IF PARENT.i_cSourceType = 'P' THEN
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cProviderKey AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		ELSE
			SELECT count(*) INTO :l_nXRefCount
			  FROM cusfocus.case_log
			 WHERE xref_subject_id = :PARENT.i_cCurrentCaseSubject AND
			 		 xref_source_type = :PARENT.i_cSourceType
			 USING SQLCA;
		END IF

		IF l_nXRefCount > 0 THEN
			fu_EnableTab(6)
		ELSE 
			fu_DisableTab(6)
		END IF

		fu_EnableTab(7)
		fu_EnableTab(8)
		
		// now update the menu items
		m_create_maintain_case.m_edit.m_addspecialflags.Enabled              = FALSE
		m_create_maintain_case.m_edit.m_setrecordsecuritylevel.Enabled 		= FALSE
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_new.Text										= '&New Case Reminder~tCtrl+N'
		m_create_maintain_case.m_file.m_new.MicroHelp								= 'New Case Reminder'
		m_create_maintain_case.m_file.m_new.ToolBarItemText						= 'New Case Reminder'
		m_create_maintain_case.m_file.m_save.Enabled 								= TRUE
		m_create_maintain_case.m_file.m_save.Text										= 'Sa&ve Case Reminder~tCtrl+S'
		m_create_maintain_case.m_file.m_save.MicroHelp								= 'Save Case Reminder'
		m_create_maintain_case.m_file.m_save.ToolBarItemText						= 'Save Case Reminder'
		m_create_maintain_case.m_file.m_printsetup.Enabled 						= TRUE
		m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled			= TRUE
		m_create_maintain_case.m_file.m_printcasedetailreport.Enabled			= TRUE
		m_create_maintain_case.m_file.m_documentquickinterface.Enabled			= TRUE
		m_create_maintain_case.m_file.m_print.Enabled 								= TRUE
		m_create_maintain_case.m_file.m_print.Text									='&Print Case Reminder'
		m_create_maintain_case.m_file.m_print.MicroHelp								= 'Print Case Reminder'
		m_create_maintain_case.m_file.m_print.ToolBarItemText						= 'Print Case Reminder'

		m_create_maintain_case.m_edit.m_sort.Enabled 								= TRUE 
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'
		

		m_create_maintain_case.m_file.m_clearsearchcriteria.Enabled 			= FALSE
		m_create_maintain_case.m_file.m_search.Enabled 								= FALSE
		m_create_maintain_case.m_file.m_transfercase.Enabled 						= FALSE
		m_create_maintain_case.m_file.m_newcase.Enabled 							= TRUE
		m_create_maintain_case.m_file.m_newcase.m_inquiry.Enabled 				= TRUE
		m_create_maintain_case.m_file.m_newcase.m_issueconcern.Enabled 		= TRUE
		m_create_maintain_case.m_file.m_newcase.m_configcasetype.Enabled 			= TRUE
		m_create_maintain_case.m_file.m_newcase.m_proactive.Enabled 			= TRUE
		
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled 				= FALSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Text					= '&Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.MicroHelp			= 'Edit Correspondence'
		m_create_maintain_case.m_edit.m_editcorrespondence.ToolBarItemText	= 'Edit Correspondence'
		
		m_create_maintain_case.m_edit.m_closecase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_voidcase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 			= FALSE
		m_create_maintain_case.m_edit.m_contactperson.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_changecasetype.Enabled 					= FALSE
		m_create_maintain_case.m_edit.m_reopencase.Enabled 						= FALSE
		m_create_maintain_case.m_edit.m_financialcompensation.Enabled 			= FALSE
		
		m_create_maintain_case.m_edit.m_linkcase.Enabled 							= FALSE
		m_create_maintain_case.m_edit.m_removelink.Enabled 						= FALSE
		
		// if no reminders exist for an open case, create one.           MPC   6/25/99
		IF i_uoCaseDetails.i_cCaseStatus = i_cStatusOpen THEN
			IF i_uoCaseReminders.dw_case_reminder_history.RowCount() = 0 THEN
				TriggerEvent (w_create_maintain_case, "pc_new")
			END IF
		END IF
		
		IF i_cSourceType = 'P' THEN
			SELECT provider_id, vendor_id INTO :i_cProviderID, :i_cVendorID
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = :i_nProviderKey
			 USING SQLCA;
			 
			 
			 IF ISNULL(i_cProviderID) THEN
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = 'Vendor ID: '+i_cVendorID
				END IF
			ELSE
				l_cConcatSubject = 'Provider ID: '+i_cProviderID
				IF NOT ISNULL(i_cVendorID) THEN
					l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_cVendorID
				END IF
			END IF

			PARENT.Title = l_cSourceDesc + ' - ' + l_cConcatSubject + ' - ' + i_cCaseSubjectName + ' - ' + &
			l_cCaseType + ' - ' + i_cCurrentCase + ' - ' + l_cStatusDesc
			 
			 
		ELSE
			PARENT.Title = l_cSourceDesc + ' - ' + i_cCurrentCaseSubject + ' - ' + i_cCaseSubjectName + ' - ' + &
			l_cCaseType + ' - ' + i_cCurrentCase + ' - ' + l_cStatusDesc
			
			 
		END IF
		
		//Add locked by information if the case is locked
		IF PARENT.i_bCaseLocked THEN
			PARENT.Title += " - Locked By "+PARENT.i_cLockedBy
		END IF

		
		//Enable the iim option
		m_create_maintain_case.m_features.m_iim.Enabled								   = TRUE
		
		//If the IIM tab window is open, disable the add note button.
		IF IsValid( w_iim_tabs ) THEN
			m_iim_tabs.m_edit.m_addcustomerstatement.Enabled = FALSE
			
			w_iim_tabs.tab_folder.Event Trigger ue_SetDragDrop( FALSE )
		END IF
END CHOOSE


end event

event clicked;call super::clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Allow fucntionality only related to the user clicking the tab header.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/12/01 M. Caruso    Created.
	01/13/01 M. Caruso    Only reload if the selected case has changed.
	01/14/01 M. Caruso    Reversed last changed.  This condition taken of in fu_OpenCase ().
*****************************************************************************************/

CHOOSE CASE i_SelectedTab
	CASE 5
		i_uoCaseDetails.POST fu_opencase ()
		
END CHOOSE
end event

event resize;//******************************************************************
//  PO Module     : u_Folder
//  Event         : Resize
//  Description   : Resize the folder control.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  4/13/2001 K. Claver Overrode ancestry and commented out code to
//								resize the user object tabs as want to resize
//								the user objects with the new resize service.
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_FolderX, l_FolderY, l_FolderWidth, l_FolderHeight
INTEGER    l_ObjectWidth, l_ObjectHeight, l_X, l_Y, l_Idx, l_Jdx
DRAGOBJECT l_Object

//------------------------------------------------------------------
//  If the resize option is on, resize the folder object when 
//  the control has been resized by its parent.
//------------------------------------------------------------------

IF GetItemString(1, "f_resize") = "Y" AND i_FolderResize THEN
   THIS.fu_FolderResize()
	
	THIS.fu_FolderWorkSpace(l_FolderX, l_FolderY, &
                           l_FolderWidth, l_FolderHeight)

   //---------------------------------------------------------------
   //  If any of the objects have been centered before, re-center
   //  them after the resize.
   //---------------------------------------------------------------

//   FOR l_Idx = 1 TO i_Tabs
//      IF i_TabArray[l_Idx].TabNumObjects > 0 THEN
//         FOR l_Jdx = 1 TO i_TabArray[l_Idx].TabNumObjects
//            IF i_TabArray[l_Idx].TabObjectCentered[l_Jdx] THEN
//               l_Object = i_TabArray[l_Idx].TabObjects[l_Jdx]
//					IF IsValid(l_Object) THEN
//	               l_ObjectWidth  = l_Object.Width
//   	            l_ObjectHeight = l_Object.Height
//
//      	         IF l_ObjectWidth > l_FolderWidth THEN
//         	         l_X = l_FolderX
//            	   ELSE
//               	   l_X = ((l_FolderWidth - l_ObjectWidth) / 2) + l_FolderX
//	               END IF
//
//	               IF l_ObjectHeight > l_FolderHeight THEN
//   	               l_Y = l_FolderY
//      	         ELSE
//         	         l_Y = ((l_FolderHeight - l_ObjectHeight) / 2) + l_FolderY
//            	   END IF
//
//               	l_Object.Move(l_X, l_Y)
//					END IF
//            END IF
//         NEXT
//      END IF
//   NEXT
END IF
end event

