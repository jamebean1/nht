$PBExportHeader$u_tabpage_case_details.sru
$PBExportComments$Case Details tabpage on the case screen.
forward
global type u_tabpage_case_details from u_tabpg_std
end type
type dw_case_details from u_dw_std within u_tabpage_case_details
end type
end forward

global type u_tabpage_case_details from u_tabpg_std
integer width = 3529
integer height = 784
string text = "Case Details"
dw_case_details dw_case_details
end type
global u_tabpage_case_details u_tabpage_case_details

type variables
CONSTANT	INTEGER			i_nCategoriesTab = 7

STRING						i_cOptionList
STRING                  i_cXRefSubjectID
STRING						i_cXRefCCSubject
STRING						i_cName1
STRING						i_cName2
STRING						i_cName3
STRING                  i_cXRefSourceType
STRING                  i_cHoldXRef
STRING                  i_cXRefSource
STRING                  i_cXRefProviderType
STRING                  i_cCCName
STRING                  i_cButton

W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder

BOOLEAN						i_bCrossRefSearched = FALSE
BOOLEAN                 i_bChange = FALSE
BOOLEAN                 i_bCancelled = FALSE
BOOLEAN						i_bOverwrite = TRUE
BOOLEAN                 i_bDWHasFocus
BOOLEAN                 i_bChangeType
BOOLEAN						i_bAnswered = FALSE
BOOLEAN                 i_bNoSave
BOOLEAN						i_bCancelSearch
BOOLEAN						i_bRemove
BOOLEAN						i_bRemoveCancel
BOOLEAN						i_bSaved = FALSE
BOOLEAN                 i_bInit = TRUE
BOOLEAN						i_bChanging = FALSE
BOOLEAN                 i_bClearType = FALSE
BOOLEAN						i_bExactMatch = TRUE
BOOLEAN						i_bLockedCaseMessageDisplayed = FALSE

LONG							i_nXRefSubjectID
LONG							i_nProviderKey
end variables

forward prototypes
public function integer fu_lockcase ()
public function integer fu_unlockcase ()
public function boolean fu_checklocked ()
end prototypes

public function integer fu_lockcase ();/*****************************************************************************************
   Function:   fu_LockCase
   Purpose:    Lock the case for the current user
   Parameters: NONE
   Returns:    INTEGER -	0 - Success
									-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/08/02 K. Claver    Created.
	03/28/02 M. Caruso    Added code to set i_bCaseLocked in i_uoDocMgr if it is valid.
*****************************************************************************************/
String l_cCurrentUser, lock_proc_odbc, lock_proc_native
Boolean l_bAutoCommit
Integer l_nRV = 0

l_cCurrentUser = OBJCA.WIN.fu_GetLogin( SQLCA )

l_bAutoCommit = SQLCA.AutoCommit
SQLCA.AutoCommit = FALSE

IF SQLCA.DBMS = "ODBC" THEN
	DECLARE lock_proc_odbc PROCEDURE FOR cusfocus.sp_lock_case( :THIS.i_wParentWindow.i_cCurrentCase, :l_cCurrentUser )
	USING SQLCA;
	
	EXECUTE lock_proc_odbc;
ELSE
	DECLARE lock_proc_native PROCEDURE FOR cusfocus.sp_lock_case
	@lock_case_number = :THIS.i_wParentWindow.i_cCurrentCase,
	@lock_user = :l_cCurrentUser
	USING SQLCA;
	
	EXECUTE lock_proc_native;	
END IF

IF SQLCA.SQLCode = -1 THEN
	MessageBox( gs_AppName, "Error executing case lock stored procedure.  You will not be able to edit this case.~r~n"+ &
					"Error Returned:~r~n"+SQLCA.SQLErrText, StopSign!, OK! )
	l_nRV = -1
	THIS.i_wParentWindow.i_bCaseLocked = TRUE
	SetNull( THIS.i_wParentWindow.i_cLockedBy )
ELSE
	// indicates not locked because you locked it.
	THIS.i_wParentWindow.i_bCaseLocked = FALSE
	THIS.i_wParentWindow.i_cLockedBy = l_cCurrentUser
END IF

IF IsValid (i_wParentWindow.i_uoCaseCorrespondence) THEN
	IF IsValid (i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr) THEN
		i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr.i_bCaseLocked = i_wParentWindow.i_bCaseLocked
	END IF
END IF
IF IsValid (i_wParentWindow.i_uoCaseDetails) THEN
	IF IsValid (i_wParentWindow.i_uoCaseDetails.tab_folder.tabpage_appeals) THEN
		i_wParentWindow.i_uoCaseDetails.tab_folder.tabpage_appeals.ib_Locked = i_wParentWindow.i_bCaseLocked
	END IF
END IF

SQLCA.AutoCommit = l_bAutoCommit

RETURN l_nRV
end function

public function integer fu_unlockcase ();/*****************************************************************************************
   Function:   fu_UnlockCase
   Purpose:    Unlock the current case
   Parameters: NONE
   Returns:    INTEGER -	0 - Success
									-1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/11/02 K. Claver    Created.
	03/28/02 M. Caruso    Added code to set i_bCaseLocked in i_uoDocMgr if it is valid.
*****************************************************************************************/
String unlock_proc_odbc, unlock_proc_native
Boolean l_bAutoCommit
Integer l_nRV = 0

l_bAutoCommit = SQLCA.AutoCommit
SQLCA.AutoCommit = FALSE

IF SQLCA.DBMS = "ODBC" THEN
	DECLARE unlock_proc_odbc PROCEDURE FOR cusfocus.sp_unlock_case( :THIS.i_wParentWindow.i_cCurrentCase )
	USING SQLCA;
	
	EXECUTE unlock_proc_odbc;
ELSE
	DECLARE unlock_proc_native PROCEDURE FOR cusfocus.sp_unlock_case
	@unlock_case_number = :THIS.i_wParentWindow.i_cCurrentCase
	USING SQLCA;
	
	EXECUTE unlock_proc_native;
END IF

IF SQLCA.SQLCode = -1 THEN
	MessageBox( gs_AppName, "Error executing stored procedure to remove the lock from the case.~r~n"+ &
					"Error Returned:~r~n"+SQLCA.SQLErrText, StopSign!, OK! )
	l_nRV = -1
ELSE
	THIS.i_wParentWindow.i_bCaseLocked = FALSE
	SetNull( THIS.i_wParentWindow.i_cLockedBy )
END IF

IF IsValid (i_wParentWindow.i_uoCaseCorrespondence) THEN
	IF IsValid (i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr) THEN
		i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr.i_bCaseLocked = i_wParentWindow.i_bCaseLocked
	END IF
END IF
IF IsValid (i_wParentWindow.i_uoCaseDetails) THEN
	IF IsValid (i_wParentWindow.i_uoCaseDetails.tab_folder.tabpage_appeals) THEN
		i_wParentWindow.i_uoCaseDetails.tab_folder.tabpage_appeals.ib_Locked = i_wParentWindow.i_bCaseLocked
	END IF
END IF

SQLCA.AutoCommit = l_bAutoCommit

RETURN l_nRV
end function

public function boolean fu_checklocked ();/*****************************************************************************************
   Function:   fu_CheckLocked
   Purpose:    Check if the current case is locked
   Parameters: NONE
   Returns:    BOOLEAN -	TRUE - Case Locked
									FALSE - Case not locked

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/08/02 K. Claver    Created.
	03/28/02 M. Caruso    Added code to set i_bCaseLocked in i_uoDocMgr if it is valid.
	09/02/2004 K. Claver  Modified locked case message to inform the user that they can
								 add certain things to the case, but they cannot edit.
*****************************************************************************************/
Boolean l_bRV = FALSE
DateTime l_dtLockedDate

IF NOT IsNull( THIS.i_wParentWindow.i_cCurrentCase ) AND &
	Trim( THIS.i_wParentWindow.i_cCurrentCase ) <> "" THEN
	
	SELECT locked_by, locked_timestamp
	INTO :THIS.i_wParentWindow.i_cLockedBy, :l_dtLockedDate
	FROM cusfocus.case_locks
	WHERE case_number = :THIS.i_wParentWindow.i_cCurrentCase
	USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			MessageBox( gs_AppName, "Error determining lock status for the case."+ &
							" You will not be able to edit this case", StopSign!, OK! )
			
			THIS.i_wParentWindow.i_cLockedBy = "Undetermined"
			THIS.i_wParentWindow.i_bCaseLocked = TRUE
			l_bRV = TRUE
		CASE 0
			IF Upper( Trim( THIS.i_wParentWindow.i_cLockedBy ) ) <> Upper( Trim( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
				IF NOT THIS.i_bLockedCaseMessageDisplayed THEN
					MessageBox( gs_AppName, "This case is currently in use by "+THIS.i_wParentWindow.i_cLockedBy+" since "+&
									String( l_dtLockedDate, "mm/dd/yyyy hh:mm:ss" )+".~r~n"+ &
									"You will only be able to add notes, attachments, correspondence,~r~n"+ &
									"contacts, forms and reminders to this case.  No other edits are allowed.", Information!, OK! )
					
					//Added this variable to ensure the message only displays once as this function is called
					//  multiple times to ensure the use cannot edit a locked case.
					THIS.i_bLockedCaseMessageDisplayed = TRUE
				END IF
				
				//Set on parent window flag that case is locked
				THIS.i_wParentWindow.i_bCaseLocked = TRUE
				l_bRV = TRUE
			ELSE
				THIS.i_wParentWindow.i_bCaseLocked = FALSE
				l_bRV = FALSE
			END IF
		CASE ELSE
			//SQLCA.SQLCode = 100 = No lock record found
			THIS.i_wParentWindow.i_bCaseLocked = FALSE
	END CHOOSE
	
	IF IsValid (i_wParentWindow.i_uoCaseCorrespondence) THEN
		IF IsValid (i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr) THEN
			i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr.i_bCaseLocked = i_wParentWindow.i_bCaseLocked
		END IF
	END IF
	IF IsValid (i_wParentWindow.i_uoCaseDetails) THEN
		IF IsValid (i_wParentWindow.i_uoCaseDetails.tab_folder.tabpage_appeals) THEN
			i_wParentWindow.i_uoCaseDetails.tab_folder.tabpage_appeals.ib_Locked = i_wParentWindow.i_bCaseLocked
		END IF
	END IF
	
END IF

RETURN l_bRV
end function

on u_tabpage_case_details.create
int iCurrent
call super::create
this.dw_case_details=create dw_case_details
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_case_details
end on

on u_tabpage_case_details.destroy
call super::destroy
destroy(this.dw_case_details)
end on

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    set values for instance variables

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/29/00  M. Caruso    Created.
*****************************************************************************************/

i_wparentwindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder
end event

type dw_case_details from u_dw_std within u_tabpage_case_details
integer x = 14
integer width = 3497
integer height = 772
integer taborder = 10
boolean enabled = false
string dataobject = "d_case_details"
boolean maxbox = true
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:	pcd_setoptions
	Purpose: Enable the search mechanism for the dropdown datawindows in this datawindow.
	
	Revisions:
	Date     Developer    Description
	======== ============ =================================================================
	11/28/00 M. Caruso    Added c_NoMenuButtonActivation to the options list.
	01/02/01 M. Caruso    Added c_ModifyOnOpen to the options list.
*****************************************************************************************/

i_cOptionList = c_NewOK + &
					 c_ModifyOK + &
					 c_ModifyOnOpen + &
					 c_DDDWFind + &
					 c_NoShowEmpty + &
					 c_NoRetrieveOnOpen + &
					 c_NoMenuButtonActivation

fu_SetOptions (SQLCA, c_NullDW, i_cOptionList)
end event

event itemchanged;call super::itemchanged;//**********************************************************************************************
//
//  Event:   itemchanged
//  Purpose: If the user changes the Provider from the DropDownDatawindow, then get the Provider 
//           Type also.
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  04/04/00 M. Caruso   Return Error.i_FWError to properly process error checking.
//  10/23/00 M. Caruso   Added code to handle check box processing for Proactive cases.
//  01/03/01 M. Caruso   Added code to enable/disable date field entry on proactive case detail 
//                       tab.
//  02/20/01 M. Caruso   Set provider_type to NULL if the provider ID is NULL or ''.
//  05/30/01 C. Jackson  Change to xref_subject_id
//  07/25/01 M. Caruso   Prompt the user to change a cross reference if an ID is already assigned.
//  07/26/01 M. Caruso   Check the actual Xref key value, not the computed Xref ID value, when
//                       the Xref source type field changes.
//  08/16/01 C. Jackson  Correct the query to get the provider_id.  Was looking for string on
//                       provider_key for Sybase, needs to be a long.
//  08/29/01 C. Jackson  correct error handling of select from provider_of_service and corresponding
//                       data handling.  
//  10/16/01 C. Jackson  Correct logic in blanking out Cross Reference
//  10/30/01 C. Jackson  Correct Cross Reference
//  12/15/02 C. Jackson  Add security to prevent a user with inadequate security from seeing the
//                       Cross Referenced Name.  ('Access Denied' is displayed)
//  03/06/02 C. Jackson  Correct deleting of a Cross Reference
//  03/07/02 C. Jackson  Add msg to confirm the user wants to remove the Cross Ref ID when 
//                       changing the Cross Ref Type (SCR 2706)
//  03/20/02 M. Caruso   Trap if an invalid security level is selected and prompt the user.
//  04/26/02 C. Jackson  Correct errror handling (SCR 2819)
//  05/31/02 C. Jackson  Remove code for handling case_log_xref_source_type.  this is no longer
//                       updateable on this window.  The user must change it via that search window.
//**********************************************************************************************

BOOLEAN		l_bSetTrigger, l_bPutBack
LONG			l_nSearchRow, l_nReturn, l_nProviderKey, l_nRow, l_nUserSecurity
LONG			l_nDemogSecurity, l_nPrevLevel, l_nPos
STRING		l_cXRefSubjectID, l_cProviderType, l_cCheckBox, l_cDateField, l_cNull, l_cXRefSourceType
STRING      l_cName, l_cName2, l_cName3, l_cProviderKey, l_cConsumerID, l_cMessage, l_cProviderID
STRING      l_cXRefProviderType, l_cXRefCCSubject, l_cLogin, l_cRepLevelDesc
DATETIME		l_dtNull
DatawindowChild dwc_xref_subject, l_dwcLevels
STRING l_cSourceType, l_cSearchID, l_cParm, l_cXRefSourcType 
BOOLEAN l_bPromptSourceChange

SetNull(l_cNull)
SetNull(i_nProviderKey)
SetNull(l_cName)

l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT rec_confidentiality_level 
  INTO :l_nUserSecurity
  FROM cusfocus.cusfocus_user
 WHERE user_id = :l_cLogin
 USING SQLCA;


CHOOSE CASE dataobject
	CASE 'd_case_details'
		i_bOverWrite = TRUE
		i_bCancelSearch = FALSE 
		
		// for Configurable, Inquiry and Issue/Concern cases
		CHOOSE CASE dwo.name
			CASE 'confidentiality_level'
				IF Trim (data) <> "" AND NOT IsNull (data) THEN
					IF i_wParentWindow.i_nRepConfidLevel < INTEGER (data) THEN
						IF GetChild ('confidentiality_level', l_dwcLevels) = 1 THEN
							l_nRow = l_dwcLevels.Find ('confidentiality_level = ' + STRING (i_wParentWindow.i_nRepConfidLevel), &
																1, l_dwcLevels.RowCount())
							l_cRepLevelDesc = l_dwcLevels.GetItemString (l_nRow, 'confid_desc')
							
						ELSE
							l_cRepLevelDesc = 'N/A'
						END IF
						
						MessageBox( gs_AppName, "You cannot set the security level of this case higher~r~n" + &
														"than your own, which is " + l_cRepLevelDesc, StopSign!, OK! )
						l_nPrevLevel = GetItemNumber (1, 'confidentiality_level')
						SetItem (1, 'confidentiality_level', l_nPrevLevel)
						Error.i_FWError = c_ValFixed
					END IF
				END IF
				
			Case 'case_log_rprtd_date'
				Date		ldt_reported_date

				ldt_reported_date = Date(Left(data,10))
				If ldt_reported_date < Date('1/1/1910') Then Setnull(ldt_reported_date)	
					
				If ldt_reported_date > Date(gn_globals.in_date_manipulator.of_now()) Then
						MessageBox( gs_AppName, "The reported date cannot be set in the future.", StopSign!, OK! )
						Error.i_FWError = c_Fatal
						Return 2
				End If

			//---------------------------------------------------------------------------------------------
			// JWhite Added 6.6.2006
			//---------------------------------------------------------------------------------------------
			Case 'case_log_incdnt_date'	
				String	ls_optionvalue
				Date		ldt_incident_date, ldt_dateadd

				ldt_incident_date = Date(Left(data,10))
				If ldt_incident_date < Date('1/1/1910') Then Setnull(ldt_incident_date)	
					
				If ldt_incident_date > Date(gn_globals.in_date_manipulator.of_now()) Then
						MessageBox( gs_AppName, "The incident date cannot be set in the future.", StopSign!, OK! )
						Error.i_FWError = c_Fatal
						Return 2
				End If
				  
				  SELECT cusfocus.system_options.option_value  
					 INTO :ls_optionvalue  
					 FROM cusfocus.system_options  
					WHERE cusfocus.system_options.option_name = 'incident date limit'   
							  ;
				
				If long(ls_optionvalue) > 0 and not isnull(ls_optionvalue) Then
					ldt_dateadd = gn_globals.in_date_manipulator.of_date_add('DAY', long(ls_optionvalue) * -1, gn_globals.in_date_manipulator.of_today())
					
					If ldt_incident_date < ldt_dateadd Then
						MessageBox( gs_AppName, "The incident date cannot be more than " + ls_optionvalue + ' days from the current date.', StopSign!, OK! )
						Error.i_FWError = c_Fatal
						Return 2
					End If
				End If
			//---------------------------------------------------------------------------------------------
			// JWhite End Added 6.6.2006
			//---------------------------------------------------------------------------------------------	
		END CHOOSE		
		
	CASE 'd_case_details_proactive'
		// for Proactive cases
		CHOOSE CASE dwo.name
			CASE 'case_log_case_log_cntct_made', 'case_log_case_log_ornt_cmplt', &
				  'case_log_case_log_letter_sent', 'case_log_case_log_vdo_sent', &
				  'case_log_case_log_ado_sent'
				AcceptText ()
				l_cCheckBox = dwo.Name
				IF l_cCheckBox = 'case_log_case_log_cntct_made' THEN
					l_cDateField = 'case_log_case_log_cntct_date'
				ELSE
					l_cDateField = dwo.name + '_dt'
				END IF
				
				IF data = 'Y' THEN
					SetItem (row, l_cDateField, i_wparentwindow.fw_GetTimeStamp ())
					Modify (l_cDateField + '.protect = "0"')
					Modify (l_cDateField + '.Background.Color = 16777215')
				ELSE
					SetNull (l_dtNull)
					SetItem (row, l_cDateField, l_dtNull)
					Modify (l_cDateField + '.protect = "1"')
					Modify (l_cDateField + '.Background.Color = 79741120')
				END IF
				
			CASE 'confidentiality_level'
				IF Trim (data) <> "" AND NOT IsNull (data) THEN
					IF i_wParentWindow.i_nRepConfidLevel < INTEGER (data) THEN
						IF GetChild ('confidentiality_level', l_dwcLevels) = 1 THEN
							l_nRow = l_dwcLevels.Find ('confidentiality_level = ' + STRING (i_wParentWindow.i_nRepConfidLevel), &
																1, l_dwcLevels.RowCount())
							l_cRepLevelDesc = l_dwcLevels.GetItemString (l_nRow, 'confid_desc')
							
						ELSE
							l_cRepLevelDesc = 'N/A'
						END IF
						
						MessageBox( gs_AppName, "You cannot set the security level of this case higher~r~n" + &
														"than your own, which is " + l_cRepLevelDesc, StopSign!, OK! )
						l_nPrevLevel = GetItemNumber (1, 'confidentiality_level')
						SetItem (1, 'confidentiality_level', l_nPrevLevel)
						Error.i_FWError = c_ValFixed
					END IF
				END IF
				
		END CHOOSE
		
	
END CHOOSE

								


RETURN Error.i_FWError
	

end event

event pcd_new;call super::pcd_new;//**********************************************************************************************
//  Event:   pcd_new
//  Purpose: To initialize a new Case record.
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  09/29/00 M. Caruso   Created, based on the code from the old case detail object.
//  11/15/00 M. Caruso   Removed code to initialize the datawindow object.
//  11/22/00 K. Claver   Changed the datawindow status to NotModified so doesn't attempt to save 
//                       when changing tabs and closing the window if the row hasn't been changed.
//  12/12/00 M. Caruso   Change selecttab index to 5, the new index of the category tab.
//  01/03/00 M. Caruso   Added code to reinitialize the category description datawindow.
//  01/10/01 M. Caruso   Reworked the code for creating a new record on the Case Properties tab. 
//  01/11/01 M. Caruso   Corrected display of proerties tabs by reordering tab switching 
//                       statements.
//  02/20/01 M. Caruso   Added code to insert '(None)' rows in the cross reference drop downs.
//  03/16/01 M. Caruso   Added code to disable the new and modify buttons on the carve out tab. 
//                       Also reset the carve out list datawindow.
//  03/19/01 M. Caruso   Re-retrieve the carve out data which also clears the reason field.  
//	                      Also set values for the case-related fields on the carve out tab.
//  03/23/01 K. Claver   Fixed to set the pointer to the carveout tab before attempt to access 
//                       properties on the tab.
//  05/30/01 C. Jackson  Change to xref_subject_id
//  11/27/01 M. Caruso   Removed reference to CASE_LOG.method_id
//  12/05/01 K. Claver   Added code to disable the controls on the case attachments
//								 tab.
//  01/16/02 K. Claver   Added code to disable the controls on the case forms tab.
//  03/14/02 M. Caruso   Set the incident date before setting the reported date.
//  03/22/02 K. Claver   Added code to reset the case lock variables on the create/maintain case
//								 window.
//  04/17/02 M. Caruso   Removed references to the Inquiry Properties tab.
//  04/26/02 K. Claver   Added code to disable the contact person button until the case is saved.
//  04/26/02 M. Caruso   Reset i_cXRefCCSubject to prevent displaying of previous value.
//  02/04/03 C. Jackson  Set Default Note Security based on the values set in System Options
//  07/03/03 M. Caruso   Removed a redundant setting of i_cCaseStatus.
//**********************************************************************************************


STRING							l_cNull
DATETIME							l_dtTimestamp
U_OUTLINER						l_tvCategories
U_DW_STD							l_dwNoteEntry, l_dwCategoryDesc
U_TABPAGE_CASE_PROPERTIES	l_tpCaseProps
U_TABPAGE_CARVE_OUT			l_tpCarveOut
DATAWINDOWCHILD				l_dwcOptionalGrouping, l_dwcProviderOfService, l_dwcLevels

//Unlock the current case(if there is one) before create a new
IF NOT IsNull( PARENT.i_wParentWindow.i_cCurrentCase ) AND Trim( PARENT.i_wParentWindow.i_cCurrentCase ) <> "" AND &
	NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
	PARENT.fu_UnlockCase( )
END IF

l_tvCategories = i_tabFolder.tabpage_category.dw_categories
l_dwCategoryDesc = i_tabFolder.tabpage_category.dw_category_description
l_dwNoteEntry = i_wParentWindow.i_uoCaseDetails.dw_case_note_entry

// make sure the proper detail view is visible and set default values by case type.
CHOOSE CASE i_wParentWindow.i_cCaseType
	CASE i_wParentWindow.i_cConfigCaseType, i_wParentWindow.i_cInquiry
		// set the default data items for this case type
		IF THIS.DataObject = "d_case_details" THEN
			SetItem (i_CursorRow, 'case_log_appld', 0)
			SetItem (i_CursorRow, 'case_log_case_priority', 'N')
		END IF
		
	CASE i_wParentWindow.i_cIssueConcern
		// set the default data items for this case type
		IF THIS.DataObject = "d_case_details" THEN
			// initialize incident and reported dates to the same value.
			l_dtTimestamp = i_wparentwindow.fw_gettimestamp()
			SetItem (i_CursorRow, 'case_log_incdnt_date', l_dtTimestamp)
			SetItem (i_CursorRow, 'case_log_rprtd_date', l_dtTimestamp)
			SetItem (i_CursorRow, 'case_log_appld', 0)
			SetItem (i_CursorRow, 'case_log_case_priority', 'N')
		END IF
		
	CASE i_wParentWindow.i_cProactive
		// set the default data items for this case type
		IF THIS.DataObject = "d_case_details_proactive" THEN
			SetItem (i_CursorRow, 'case_log_case_priority', 'N')
			SetItem (i_CursorRow, 'case_log_case_log_nmbr_atmpt_cnt', 1)
		END IF
		
END CHOOSE

// Set Security
SetItem (i_CursorRow, 'confidentiality_level', LONG(gs_CaseNoteSecurity))

// Clean up from any previous cases if we have already opened the container object.
i_wParentWindow.i_cCurrentCase = ''
i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory = ''
i_wParentWindow.i_uoCaseDetails.i_cRootCategoryName = ''
// reinitialize the category tab.
IF l_tvCategories.RowCount () > 0 THEN
	l_tvCategories.fU_HLClearSelectedRows()
	l_tvCategories.fu_HLCollapseAll()
	l_dwCategoryDesc.fu_Reset (c_IgnoreChanges)
	l_dwCategoryDesc.fu_New (1)
END IF

// Set some defaults like the Open Date, Reported Date, Incident Date, etc.
SetItem (i_CursorRow, 'case_log_case_type', i_wparentwindow.i_cCaseType)
SetItem (i_CursorRow, 'case_log_case_log_opnd_date', i_wparentwindow.fw_gettimestamp())
SetItem (i_CursorRow, 'case_log_case_log_taken_by', OBJCA.WIN.fu_GetLogin(SQLCA))
SetItem (i_CursorRow, 'case_log_case_log_case_rep', OBJCA.WIN.fu_GetLogin(SQLCA))
SetItem (i_CursorRow, 'case_log_case_status_id', i_wParentWindow.i_cStatusOpen)
SetItem (i_CursorRow, 'case_log_source_name', i_wParentWindow.i_cCaseSubjectName)
SetItem (i_CursorRow, 'case_log_source_type', i_wParentWindow.i_cSourceType)
SetItem (i_CursorRow, 'case_log_case_subject_id', i_wParentWindow.i_cCurrentCaseSubject)

// add a (None) entry to the cross reference drop downs if not already there
SetNull (l_cNull)
IF THIS.dataobject = 'd_case_details' THEN
	
	GetChild('case_log_xref_subject_id', l_dwcProviderOfService)
	IF l_dwcProviderOfService.Find ('cc_provider = "(None)"', 1, l_dwcProviderOfService.RowCount ()) = 0 THEN
		l_dwcProviderOfService.InsertRow (1)
		l_dwcProviderOfService.SetItem(i_CursorRow, 'provider_id', l_cNull)
		l_dwcProviderOfService.SetItem(i_CursorRow, 'cc_provider', '(None)')
	END IF
	
	// reset the xref data fields
	i_cXRefCCSubject = ''
	
END IF
	
GetChild('optional_grouping_id', l_dwcOptionalGrouping)
IF l_dwcOptionalGrouping.Find ('optional_grouping_desc = "(None)"', 1, l_dwcOptionalGrouping.RowCount ()) = 0 THEN
	l_dwcOptionalGrouping.InsertRow (1)
	l_dwcOptionalGrouping.SetItem(i_CursorRow, 'optional_grouping_id', l_cNull)
	l_dwcOptionalGrouping.SetItem(i_CursorRow, 'optional_grouping_desc', '(None)')
END IF

//	Determine the Source type to set the Relationship default.
CHOOSE CASE i_wParentWindow.i_cSourceType

	CASE i_wParentWindow.i_cSourceProvider
		SetItem(i_CursorRow, 'case_log_source_provider_type', i_wParentWindow.i_cProviderType)
		

END CHOOSE

//	If there is no Case Subject then set the NeedCaseSubject instance variable.
IF i_wParentWindow.i_cCurrentCaseSubject = '' THEN
	i_wParentWindow.i_bNeedCaseSubject = TRUE
ELSE
	i_wParentWindow.i_bNeedCaseSubject = FALSE
END IF

//	Set the Case Status instance variable to Open
i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = i_wParentWindow.i_cStatusOpen
i_wParentWindow.i_uoCaseDetails.fu_SetOpenCaseGUI ()

// Initialzation categories and notes tabs and the rest of the window.
i_tabFolder.tabpage_category.of_defineview (i_wParentWindow.i_cCaseType)
i_tabFolder.tabpage_case_notes.dw_case_notes.fu_reset (c_ignorechanges)
l_dwNoteEntry.SetRedraw (FALSE)
// set i_inDrag to FALSE so the pcd_new event script will run.
IF IsValid( l_dwNoteEntry.i_DWSRV_EDIT ) THEN
	l_dwNoteEntry.i_DWSRV_EDIT.i_InDrag = FALSE
END IF
l_dwNoteEntry.fu_Reset (c_IgnoreChanges)
l_dwNoteEntry.fu_New (1)
l_dwNoteEntry.SetRedraw (TRUE)

//	Mark the row as New!
SetItemStatus(1, 0, Primary!, NotModified!)

// finally, make the categories tabpage current and set focus to Note Entry
i_tabfolder.SelectTab (i_nCategoriesTab)
i_wParentWindow.i_uoCaseDetails.dw_case_note_entry.SetFocus ()

//	Place the Case Subject in the Window Title.
i_wParentWindow.i_uoCaseDetails.fu_SetWindowTitle ()
								
// Switch between the case notes and categories tabs so the case notes tab comes back into view(PB bug workaround).
i_tabfolder.SelectTab( 1 )

//Build the Case Properties tab datawindow
l_tpCaseProps = i_tabfolder.tabpage_case_properties
IF i_wParentWindow.i_cSourceType <> l_tpCaseProps.i_cSourceType OR &
	i_wParentWindow.i_cCaseType <> l_tpCaseProps.i_cCaseType THEN
	//Change the source type and the case type and rebuild the datawindow.
	l_tpCaseProps.i_cSourceType = i_wParentWindow.i_cSourceType
	l_tpCaseProps.i_cCaseType = i_wParentWindow.i_cCaseType
	// this code refreshes the datawindow object to accept the new field list
	l_tpCaseProps.dw_case_properties.DataObject = 'd_case_properties'
	l_tpCaseProps.fu_BuildFieldList( )
	l_tpCaseProps.fu_DisplayFields( )
	l_tpCaseProps.dw_case_properties.fu_InitOptions ()
	l_tpCaseProps.dw_case_properties.fu_SetOptions (SQLCA, c_NullDW, l_tpCaseProps.i_cCasePropsOptions)
END IF

// reset the case properties datawindow and insert a new record.
l_tpCaseProps.dw_case_properties.fu_reset (c_IgnoreChanges)
l_tpCaseProps.dw_case_properties.fu_New (1)
l_tpCaseProps.fu_SetViewAvailability ()
l_tpCaseProps.rb_Current.Checked = TRUE
l_tpCaseProps.rb_Inquiry.Checked = FALSE
l_tpCaseProps.rb_Other.Checked = FALSE

//Set the variable as a pointer to the tab
l_tpCarveOut = i_tabfolder.tabpage_carve_out

// set carve out properties
SetItem (i_CursorRow, 'case_log_mtm_exclude', 'N')
l_tpCarveOut.cbx_mtm_exclude.checked = FALSE
SetItem (i_CursorRow, 'case_log_carve_out_days', 0)
l_tpCarveOut.em_total_days.Text = '0'
SetItem( i_CursorRow, 'case_log_carve_days_override', 'N' )
l_tpCarveOut.cbx_override.Checked = FALSE
l_tpCarveOut.em_total_days.BackColor = RGB( 192, 192, 192 )
l_tpCarveOut.em_total_days.Enabled = FALSE

// reset the carve out tab
l_tpCarveOut.dw_carve_out_list.fu_retrieve (c_ignorechanges, c_noreselectrows)

//Disable the controls on the case attachments tab
i_tabfolder.tabpage_case_attachments.fu_Disable( )
i_tabfolder.tabpage_case_attachments.dw_attachment_list.fu_Retrieve( c_IgnoreChanges, c_NoReselectRows )

//Disable the controls on the case forms tab
i_tabfolder.tabpage_case_forms.fu_Disable( )
i_tabfolder.tabpage_case_forms.dw_case_form_list.fu_Retrieve( c_IgnoreChanges, c_NoReselectRows )

//Disable the contact person button as requires a case number
m_create_maintain_case.m_edit.m_contactperson.Enabled = FALSE

i_tabfolder.SelectTab (i_nCategoriesTab)


end event

event pcd_retrieve;call super::pcd_retrieve;//**********************************************************************************************
//  Event:   pcd_retrieve
//  Purpose: to retrieve data into the Case Detail Tab
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/29/00 M. Caruso   Created, based on the code from the old dw_case_detail control.
//  10/24/00 M. Caruso   Added code to clear the case notes tab when creating a new case.
//  10/27/00 M. Caruso   Added code to set the enabled status of the case note entry objects: 
//                       dw_case_note_entry, cb_save and cb_new.
//  12/11/00 K. Claver   Added code to build and retrieve the case properties tab.
//  01/02/01 M. Caruso   Moved code to retrieve the category description.
//  02/20/01 M. Caruso   Added code to insert '(None)' rows in the cross reference drop downs.
//  03/01/01 K. Claver   Added back code to populate the master case number instance variable on
//                       the create maintain case window.
//  03/08/01 M. Caruso   Added code to retrieve the carve out list when a case is retrieved.
//  03/16/01 M. Caruso   Added code to enable the new button and conditionally enable the modify 
//                       button on the carve out tab based on results of carve out retrieval.
//  03/19/01 M. Caruso   Set values for the case-related fields on the carve out tab.  Also set 
//                       dw_case_note_entry.i_inDrag to FALSE to allow for the proper firing of 
//							    the pcd_new event on that datawindow.
//  03/27/01 K. Claver   Added code to enable/disable the total days field depending on whether 
//                       the override is checked on the carve out tabpage.
//  05/30/01 C. Jackson  Change to xref_subject_id
//  06/19/01 C. Jackson  Populate the Cross Reference Name if there is one
//  07/12/01 K. Claver   Commented out code to programmatically add the (None) selection to the
//								 optional grouping drop down.  Instead, added to the drop down datawindow
//								 sql to create the selection with a null value.
//  07/23/01 M. Caruso   Corrected assignment of xref name field value when xref not defined.
//  11/30/01 K. Claver   Added call to fu_Retrieve for the case attachments tab.
//  12/15/02 C. Jackson  Add security to prevent a user with inadequate security from seeing the
//                       Cross Referenced Name.  ('Access Denied' is displayed)
//  04/17/02 M. Caruso   Removed references to the Inquiry Properties tab.
//  5/30/2002 K. Claver  Removed Xref setitemstatus and added fu_resetupdate after retrieve.
//**********************************************************************************************

DATAWINDOWCHILD	l_dwc_xref_subject
BOOLEAN				l_bUpdateClosedCase, l_bAllowEdit, l_bCommit, l_bCaseLocked = FALSE
STRING 				l_cRoleName[], l_cLastName, l_cFirstName, l_sKeys[], l_cNullArg, l_crtn
STRING				l_cCaseOwner, l_cViewed, l_cXferType = 'O', l_cCommand, l_cMsg, l_cNull
STRING            l_cXRefSubjectID, l_cXRefSourceType, l_cNewSelect, l_cLogin
INT					l_nCounter, l_nNumOfRoles, l_nIndex
LONG 					l_nReturn, l_nSearchRow, l_nRoleKey[], l_nRow, l_nKeyValue, l_nXRefSubjectID
LONG              l_nUserSecurity, l_nDemogSecurity
Integer 				l_nCurrentTab
DATAWINDOWCHILD	l_dwcLevels
U_OUTLINER			l_tvCategories
U_TABPAGE_CASE_PROPERTIES	l_tpCaseProps
U_TABPAGE_CARVE_OUT			l_tpCarveOut

SetNull (l_cNullArg)
SetNull(i_cXRefCCSubject)
SetNull(i_cName1)
SetNull(i_cName2)
SetNull(i_cName3)

l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT rec_confidentiality_level 
  INTO :l_nUserSecurity
  FROM cusfocus.cusfocus_user
 WHERE user_id = :l_cLogin
 USING SQLCA;


l_tvCategories = i_tabFolder.tabpage_category.dw_categories

// Set the i_indrag instance variable to false on the datawindow edit service
// so the pcd_new event is always fired after the note is saved
IF IsValid (i_wParentWindow.i_uoCaseDetails.dw_case_note_entry.i_DWSRV_EDIT) THEN
	i_wParentWindow.i_uoCaseDetails.dw_case_note_entry.i_DWSRV_EDIT.i_InDrag = FALSE
END IF

l_nReturn = Retrieve (i_wParentWindow.i_cSelectedCase)

CHOOSE CASE l_nReturn
	CASE IS < 0
		Error.i_FWError = c_Fatal
		
	CASE 0
		// New case processing handled in pcd_new event
		fu_New (1)
		
		//If this is a new case, need to set the inquiry case properties tab to invisible. Also need to switch between
		//  the case notes and the last selected tab so the case notes tab comes back into view(PB bug workaround).
		l_nCurrentTab = i_tabfolder.SelectedTab
		i_tabfolder.SelectTab( 1 )
		i_tabfolder.SelectTab( l_nCurrentTab )
		
	CASE ELSE
		i_wParentWindow.i_cCurrentCase = i_wParentWindow.i_cSelectedCase
		
		//Set the current case master number
		IF IsNull( i_wParentWindow.i_cCurrCaseMasterNum ) OR Trim( i_wParentWindow.i_cCurrCaseMasterNum ) = "" THEN
			i_wParentWindow.i_cCurrCaseMasterNum = THIS.Object.case_log_master_case_number[ 1 ]
		END IF
		
		// update the category tree view if necessary
		i_tabFolder.tabpage_category.of_defineview (i_wParentWindow.i_cCaseType)
	
		// Load any associated case notes into the case notes tab.
		i_tabFolder.tabpage_case_notes.dw_case_notes.fu_retrieve (c_ignorechanges, c_noreselectrows)
		
		// Load any associated case attachments into the case attachments tab
		i_tabFolder.tabpage_case_attachments.dw_attachment_list.fu_Retrieve( c_IgnoreChanges, c_NoReselectRows )
		
		// Load any associated case forms into the case forms tab
		i_tabFolder.tabpage_case_forms.dw_case_form_list.fu_Retrieve( c_IgnoreChanges, c_NoReselectRows )
	
		//----------------------------------------------------------------------------------
		//		Get the Category ID.  If NULL clear all selected rows and collapse the outliner
		//		otherwise, select that category in the outliner.
		//-----------------------------------------------------------------------------------
		i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory = GetItemString(1, 'case_log_category_id')  
	
		IF IsNull(i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory) OR &
			i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory = '' THEN
			l_tvCategories.fu_HLClearSelectedRows()
			l_tvCategories.fu_HLCollapseAll()
		ELSE
			CHOOSE CASE i_wParentWindow.i_uoCaseDetails.i_nMaxLevels
		
				//-----------------------------------------------------------------------------
				//		Depending upon the number of levels the data are dictates where to search
				//		for the category to select it.
				//-----------------------------------------------------------------------------
				CASE 1
					l_nSearchRow = l_tvCategories.Find ("key1 = '" + &
										i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + "'", 1, &
										l_tvCategories.RowCount())
				CASE 2
					l_nSearchRow = l_tvCategories.Find("key1 = '" +	&
										i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + "'OR" + &
										" key2 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
										"'", 1, l_tvCategories.RowCount())
				CASE 3
					l_nSearchRow = l_tvCategories.Find("key1 = '" +	&
										i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + "' OR" + &
										" key2 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
										"' OR key3 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
										"'", 1, l_tvCategories.RowCount())		
				CASE 4
					l_nSearchRow = l_tvCategories.Find("key1 = '" +	&
										i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + "' OR " + &
										" key2 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
										"' OR key3 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
										"' OR key4 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
										"'", 1, l_tvCategories.RowCount())		
				CASE 5
						l_nSearchRow = l_tvCategories.Find("key1 = '" +	&
											i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + "' OR" + &
											" key2 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
											"' OR key3 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
											"' OR key4 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
											"' OR key5 = '" + i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory + &
											"'", 1, l_tvCategories.RowCount())		
			END CHOOSE
		
			//--------------------------------------------------------------------------------
			//		If the category does exist, then exapnd the outliner, clear any selected rows,
			//		select the found row, and scroll to it.  Also get the category description.
			//	 	Otherwise, clear all selected rows and collapse the outliner.
			//---------------------------------------------------------------------------------
			l_tvCategories.SetRedraw (FALSE)  // prevents flicker from Hide and Show commands
			l_tvCategories.Hide ()            // prevents display of control updates in the FOR loop
			  
			l_tvCategories.fu_HLCollapseAll ()
			IF l_nSearchRow > 0 THEN
				// expand onlythose items in the outliner needed to display the selected row.
				l_tvCategories.fu_HLGetRowKey (l_nSearchRow, l_sKeys[])
				l_nIndex = UpperBound (l_sKeys[])
				FOR l_nCounter = 1 to l_nIndex
					l_nRow = l_tvCategories.fu_HLFindRow (l_sKeys[l_nCounter], l_nCounter)
					// collapse all subtrees of the current level
					IF l_nCounter > 1 THEN
						l_tvCategories.fu_HLCollapse(l_nCounter+1)
					END IF
					IF l_nCounter < l_nIndex THEN
						l_tvCategories.i_ClickedRow = l_nRow
						l_tvCategories.fu_HLExpandBranch ()
					ELSE
						l_tvCategories.fu_HLSetSelectedRow (l_nRow)
						l_tvCategories.ScrollToRow (l_nRow)
					END IF
				NEXT
				
				i_wParentWindow.i_uoCaseDetails.i_cRootCategoryName = GetItemString (1, 'case_log_root_category_name')
	
			ELSE
				l_tvCategories.fu_HLClearSelectedRows ()
				l_tvCategories.fu_HLCollapseAll ()
		
			END IF
			
			// update the category description field.
			i_tabFolder.tabpage_category.dw_category_description.Retrieve (&
								i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory)
								
			l_tvCategories.Show ()
			l_tvCategories.SetRedraw (TRUE)
			
			// set the current tabpage to Case Notes
			i_tabFolder.SelectTab (1)
	
		END IF
	
		// Load data for the Carve Out tab
		l_tpCarveOut = i_tabfolder.tabpage_carve_out
		l_tpCarveOut.dw_carve_out_list.fu_retrieve (c_IgnoreChanges, c_NoReselectRows)
		
		// set case-related fields on Carve Out tab
		IF GetItemString (1, 'case_log_mtm_exclude') = 'Y' THEN
			l_tpCarveOut.cbx_mtm_exclude.checked = TRUE
		ELSE
			l_tpCarveOut.cbx_mtm_exclude.checked = FALSE
		END IF
		l_tpCarveOut.em_total_days.Text = STRING (GetItemNumber (1, 'case_log_carve_out_days'))
		
		IF THIS.GetItemString( 1, "case_log_carve_days_override" ) = "Y" THEN
			l_tpCarveOut.cbx_override.Checked = TRUE
			l_tpCarveOut.em_total_days.Enabled = TRUE
			l_tpCarveOut.em_total_days.BackColor = RGB( 255, 255, 255 )
		ELSE
			l_tpCarveOut.cbx_override.Checked = FALSE
			l_tpCarveOut.em_total_days.Enabled = FALSE
			l_tpCarveOut.em_total_days.BackColor = RGB( 192, 192, 192 )
		END IF
		
		//-----------------------------------------------------------------------------------
		//		Set the window status based on the status of the current case.  If the case is
		//		Closed, a supervisor should still be able to edit it.
		//-----------------------------------------------------------------------------------
		i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = GetItemString(1, 'case_log_case_status_id')
		l_bCaseLocked = PARENT.fu_CheckLocked( )
		CHOOSE CASE i_wParentWindow.i_uoCaseDetails.i_cCaseStatus
			CASE i_wParentWindow.i_cStatusClosed				
				i_wParentWindow.i_uoCaseDetails.fu_SetClosedCaseGUI ()
				
			CASE i_wParentWindow.i_cStatusVoid
				i_wParentWindow.i_uoCaseDetails.fu_SetVoidedCaseGUI ()
				
			CASE i_wParentWindow.i_cStatusOpen
				//Check if the case is in use by someone else
				IF l_bCaseLocked THEN
					i_wParentWindow.i_uoCaseDetails.fu_SetLockedCaseGUI( )
				ELSE
					IF PARENT.fu_LockCase( ) = -1 THEN
						i_wParentWindow.i_uoCaseDetails.fu_SetLockedCaseGUI( )
					ELSE
						i_wParentWindow.i_uoCaseDetails.fu_SetOpenCaseGUI()
					END IF
				END IF
				
		END CHOOSE
		i_wParentWindow.i_uoCaseDetails.fu_SetWindowTitle ()
		
		// set the row status to NotModified!
		SetItemStatus (i_CursorRow, 0, Primary!, NotModified!)
		
		// If transferred case and current user is the owner, set as viewed.
		l_cCaseOwner = GetItemString (1, 'case_log_case_log_case_rep')
		IF l_cCaseOwner = OBJCA.WIN.fu_GetLogin(SQLCA) THEN
			
			l_cCommand = 'BEGIN TRANSACTION'
			
			EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			
			SELECT case_viewed INTO :l_cViewed
			  FROM cusfocus.case_transfer
			 WHERE case_number = :i_wParentWindow.i_cCurrentCase
			   AND case_transfer_type = :l_cXferType
			 USING SQLCA;
			 
			CHOOSE CASE SQLCA.SQLCode
				CASE 0
					IF IsNull (l_cViewed) OR l_cViewed = 'N' THEN
						
						l_cViewed = 'Y'
					
						UPDATE cusfocus.case_transfer 
							SET case_viewed = :l_cViewed
						 WHERE case_number = :i_wParentWindow.i_cCurrentCase
							AND case_transfer_type = :l_cXferType
						 USING SQLCA;
						 
						IF SQLCA.SQLCode = 0 THEN
							l_bCommit = TRUE
						ELSE
							l_cMsg = 'Unable to update the viewed status of this transferred case.'
							l_bCommit = FALSE
						END IF
						
					ELSE
						l_cMsg = ''
						l_bCommit = FALSE				
					END IF
				
				CASE -1
					l_cMsg = 'Unable to determine if this case was transferred.'
					l_bCommit = FALSE
					
				CASE 100
					l_cMsg = ''
					l_bCommit = FALSE
					
			END CHOOSE
				 
			IF l_bCommit THEN
				l_cCommand = 'COMMIT TRANSACTION'
				EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			ELSE
				IF l_cMsg <> '' THEN Messagebox (gs_appname, l_cMsg)
				l_cCommand = 'ROLLBACK TRANSACTION'
				EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
			END IF
			
		END IF

		// Switch betweenthe case notes and last selected tab so the case notes tab comes back into view(PB bug workaround).
		l_nCurrentTab = i_tabfolder.SelectedTab
		i_tabfolder.SelectTab( 1 )
		
		//Build the Case Properties tab datawindow
		l_tpCaseProps = i_tabfolder.tabpage_case_properties
		l_tpCaseProps.i_cCurrentView = l_tpCaseProps.c_CurrentRB
		IF i_wParentWindow.i_cSourceType <> l_tpCaseProps.i_cSourceType OR &
		   i_wParentWindow.i_cCaseType <> l_tpCaseProps.i_cCaseType THEN
			//Change the source type and the case type and rebuild the datawindow.
			l_tpCaseProps.i_cSourceType = i_wParentWindow.i_cSourceType
			l_tpCaseProps.i_cCaseType = i_wParentWindow.i_cCaseType
			
			// this code refreshes the datawindow object to accept the new field list
			l_tpCaseProps.dw_case_properties.DataObject = 'd_case_properties'
			l_tpCaseProps.fu_BuildFieldList( )
			l_tpCaseProps.fu_DisplayFields( )
			l_tpCaseProps.dw_case_properties.fu_InitOptions ()
			l_tpCaseProps.dw_case_properties.fu_SetOptions (SQLCA, c_NullDW, l_tpCaseProps.i_cCasePropsOptions)
			
		END IF
		l_tpCaseProps.dw_case_properties.fu_retrieve (c_IgnoreChanges, c_NoReselectRows)
		l_tpCaseProps.fu_SetViewAvailability ()
		l_tpCaseProps.rb_Current.Checked = TRUE
		l_tpCaseProps.rb_Inquiry.Checked = FALSE
		l_tpCaseProps.rb_Other.Checked = FALSE
		
		i_tabfolder.SelectTab (l_nCurrentTab)
		
END CHOOSE

//Only process Cross Ref if the Case Type is not Proactive
// Enables xref for proactive cases - RAP 7/26/07
//IF THIS.dataobject <> "d_case_details_proactive" THEN
	
	l_cXRefSourceType = THIS.GetItemString(1,'case_log_xref_source_type')
	IF NOT IsNull(l_cXRefSourceType) THEN
		i_cXRefSourceType = l_cXRefSourceType
	ELSE
		// reset XRef titles
		THIS.Object.xref_title_id_t.Text = 'Provider Cross Ref ID:'		
		THIS.Object.xref_title_name_t.Text = 'Provider Cross Ref Name:'

	END IF
	
	IF ISNULL(l_cXRefSourceType) OR l_cXRefSourceType = '' THEN
		
		
	ELSEIF l_cXRefSourceType = 'P' THEN
		
		// Provider Cross Reference
		
		l_cXRefSubjectID = THIS.GetItemString(1,'case_log_xref_subject_id')

      IF l_cXRefSubjectID = '0' THEN
			SetNull(l_cXRefSubjectID)
		END IF
		
		IF NOT ISNULL(l_cXRefSubjectID) THEN

			l_nXRefSubjectID = LONG(l_cXRefSubjectID)
			
			SELECT provider_id, provid_name, provid_name_2, confidentiality_level
			  INTO :i_cXRefCCSubject, :i_cName1, :i_cName2, :l_nDemogSecurity
			  FROM cusfocus.provider_of_service
			 WHERE provider_key = :l_nXRefSubjectID
			 USING SQLCA;
			 
			IF l_nDemogSecurity > l_nUserSecurity THEN
				 i_cName1 = 'Access Denied'
			 ELSE
				
				IF NOT ISNULL(i_cName2) THEN
					i_cName1 = i_cName1 + ', ' + i_cName2
				END IF
				
				IF IsNull (i_cName1) OR Trim (i_cName1) = ',' THEN
					IF NOT ISNULL(i_cName2) THEN
						i_cName1 = i_cName2
					ELSE
						i_cName1 = ''
					END IF
				END IF
			END IF
			
			THIS.SetItem(1,'cc_xref_subject_id',i_cXRefCCSubject)
			THIS.SetItem(1,'cc_xref_name',i_cName1)
			
			// Set field labels for Provider
			THIS.Object.xref_title_id_t.Text = 'Provider Cross Ref ID:'		
			THIS.Object.xref_title_name_t.Text = 'Provider Cross Ref Name:'
			
		END IF
		
	ELSEIF l_cXRefSourceType = 'C' THEN
		
		//Member Cross Reference
		
		l_cXRefSubjectID = THIS.GetItemString(1,'case_log_xref_subject_id')
		
		IF NOT ISNULL(l_cXRefSubjectID) THEN

   		i_cXRefCCSubject = l_cXRefSubjectID
		
			SELECT consum_last_name, consum_first_name, consum_mi, confidentiality_level
			 INTO :i_cName1, :i_cName2, :i_cName3, :l_nDemogSecurity
			  FROM cusfocus.consumer
			 WHERE consumer_id = :l_cXRefSubjectID
			 USING SQLCA;
			 
			IF l_nDemogSecurity > l_nUserSecurity THEN
				i_cName1 = 'Access Denied'
			ELSE
			 
				IF NOT ISNULL(i_cName2) THEN
					i_cName1 = i_cName1 + ', ' + i_cName2
				END IF
				
				IF NOT ISNULL(i_cName3) THEN
					i_cName1 = i_cName1 + ' ' + i_cName3
				END IF
				
				IF IsNull (i_cName1) OR Trim (i_cName1) = ',' THEN
					i_cName1 = ''
				END IF
			END IF

			THIS.SetItem(1,'cc_xref_subject_id',l_cXRefSubjectID)
			THIS.SetItem(1,'cc_xref_name',i_cName1)
			
			// Set field labels for Member
			THIS.Object.xref_title_id_t.Text = 'Member Cross Ref ID:'		
			THIS.Object.xref_title_name_t.Text = 'Member Cross Ref Name:'
			
		END IF
	
	ELSEIF l_cXRefSourceType = 'E' THEN
		
		//Group Cross Reference
		
		l_cXRefSubjectID = THIS.GetItemString(1,'case_log_xref_subject_id')
		
		IF NOT ISNULL(l_cXRefSubjectID) THEN

   		i_cXRefCCSubject = l_cXRefSubjectID
		
			SELECT employ_group_name, confidentiality_level
			 INTO :i_cName1, :l_nDemogSecurity
			  FROM cusfocus.employer_group
			 WHERE group_id = :l_cXRefSubjectID
			 USING SQLCA;
			 
			IF l_nDemogSecurity > l_nUserSecurity THEN
				i_cName1 = 'Access Denied'
			END IF

			THIS.SetItem(1,'cc_xref_subject_id',l_cXRefSubjectID)
			THIS.SetItem(1,'cc_xref_name',i_cName1)
			
			// Set field labels for Member
			THIS.Object.xref_title_id_t.Text = 'Group Cross Ref ID:'		
			THIS.Object.xref_title_name_t.Text = 'Group Cross Ref Name:'
			
		END IF

	ELSEIF l_cXRefSourceType = 'O' THEN
		
		//Member Cross Reference
		
		l_cXRefSubjectID = THIS.GetItemString(1,'case_log_xref_subject_id')
		
		IF NOT ISNULL(l_cXRefSubjectID) THEN

   		i_cXRefCCSubject = l_cXRefSubjectID
		
			SELECT other_last_name, other_first_name, other_mi, confidentiality_level
			 INTO :i_cName1, :i_cName2, :i_cName3, :l_nDemogSecurity
			  FROM cusfocus.other_source
			 WHERE customer_id = :l_cXRefSubjectID
			 USING SQLCA;
			 
			IF l_nDemogSecurity > l_nUserSecurity THEN
				i_cName1 = 'Access Denied'
			ELSE
			 
				IF NOT ISNULL(i_cName2) THEN
					i_cName1 = i_cName1 + ', ' + i_cName2
				END IF
				
				IF NOT ISNULL(i_cName3) THEN
					i_cName1 = i_cName1 + ' ' + i_cName3
				END IF
				
				IF IsNull (i_cName1) OR Trim (i_cName1) = ',' THEN
					i_cName1 = ''
				END IF
			END IF

			THIS.SetItem(1,'cc_xref_subject_id',l_cXRefSubjectID)
			THIS.SetItem(1,'cc_xref_name',i_cName1)
			
			// Set field labels for Member
			THIS.Object.xref_title_id_t.Text = 'Other Cross Ref ID:'		
			THIS.Object.xref_title_name_t.Text = 'Other Cross Ref Name:'
			
		END IF
	
	END IF
	
//END IF

i_cXRefSubjectID = l_cXRefSubjectID

//Reset the update flags in case any changes were made on the retrieve
THIS.fu_ResetUpdate( )


end event

event pcd_saveafter;call super::pcd_saveafter;/***************************************************************************************

		Event:	pcd_saveafter
		Purpose:	To take care of some things AFTER the case log record is updated.
		Revisions:
		Date     Developer     Description
		======== ============= ==========================================================
		06/17/99 M. Caruso     Set dw_customer_statement to readonly instead of setting
		                       the datawindow columns to Display Only.  This fixes
									  display problem after saving a case.
		03/22/00 M. Caruso     Changed the code to only set the fields in
									  dw_customer_statement to ReadOnly.
		08/18/00 M. Caruso     Commented code to change m_reassigncasesubject.Enabled
		08/22/00 M. Caruso     Reversed previous change.
		09/29/00 M. Caruso     Removed references to objects no longer in use.
		10/27/00 M. Caruso     Include the case type in the window title.
		01/09/01 M. Caruso     Removed code to save case properties datawindows.
		03/16/01 M. Caruso     Set the enabled status of the new and modify buttons on
									  the carve out tab.
		07/26/01 M. Caruso     Removed code to set the status of the category tree view.
		11/26/01 C. Jackson    Set XRef Source Type to 'P' as default if there is none.
		01/16/02 K. Claver     Added function calls to enable/disable attachments and forms
									  buttons appropriately.
		04/22/02 M. Caruso     Call fu_SetTabGUI to set carve out tab button status.
		4/26/2002 K. Claver    Added code to enable the contact person button after save.
**************************************************************************************/

STRING l_cXRefSourceType
LONG l_nRow
U_TABPAGE_CARVE_OUT	l_tpCarveOut

//Lock the case if not already locked
IF IsNull( PARENT.i_wParentWindow.i_cLockedBy ) OR Trim( PARENT.i_wParentWindow.i_cLockedBy ) = "" THEN
	PARENT.fu_LockCase( )
END IF

//------------------------------------------------------------------------------------
//		Set the instance variables on the parent window so we know to do a refresh on
//		the particular tabs/datawindows.
//------------------------------------------------------------------------------------

i_wParentWindow.i_bDemographicUpdate = TRUE
i_wParentWindow.i_bSearchCriteriaUpdate = TRUE
i_wParentWindow.i_bCaseDetailUpdate = TRUE
i_wParentWindow.i_bSaveCase = TRUE

//-----------------------------------------------------------------------------------
//		An existing case can be Transfered and MUST use the Add Case Comments to add 
//		comments so enable these menu items.
//-----------------------------------------------------------------------------------

IF NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
	m_create_maintain_case.m_file.m_transfercase.Enabled = TRUE
END IF

m_create_maintain_case.m_edit.m_financialcompensation.Enabled = TRUE

IF i_wParentWindow.i_cSourceType = i_wParentWindow.i_cSourceOther AND NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
	m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled = TRUE
END IF

//	Set the selected case to the current case.
i_wParentWIndow.i_cSelectedCase = i_wParentWindow.i_cCurrentCase

//	Enable the Correspondence and Case Reminders Tab.
i_wParentWindow.dw_folder.fu_EnableTab(7)
i_wParentWindow.dw_folder.fu_EnableTab(8)

// Set the enabled status of the new and modify buttons on the carve out tab
l_tpCarveOut = i_tabfolder.tabpage_carve_out
l_tpCarveOut.fu_SetTabGUI ()
//CHOOSE CASE i_wParentWindow.i_uoCaseDetails.i_cCaseStatus
//	CASE i_wParentWindow.i_cStatusOpen
//		IF NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
//			l_tpCarveOut.cb_new.enabled = TRUE
//		ELSE
//			l_tpCarveOut.cb_new.Enabled = FALSE
//		END IF
//		
//		IF l_tpCarveOut.dw_carve_out_list.RowCount () > 0 AND NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
//			l_tpCarveOut.cb_modify.enabled = TRUE
//		ELSE
//			l_tpCarveOut.cb_modify.enabled = FALSE
//		END IF
//		
//	
//	CASE ELSE
//		l_tpCarveOut.cb_new.enabled = FALSE
//		l_tpCarveOut.cb_modify.enabled = FALSE
//		
//END CHOOSE

//Enable/disable the controls on the case attachments and case forms tabs
i_tabfolder.tabpage_case_attachments.fu_Disable( )
i_tabfolder.tabpage_case_forms.fu_Disable( )

//Can enable the contact person button now that the case is saved and we have
//  a case number
m_create_maintain_case.m_edit.m_contactperson.Enabled = TRUE

//	Set the Window Title with the Case Subject Name and Case Number
i_wParentWindow.i_uoCaseDetails.fu_SetWindowTitle ()

//IF THIS.dataobject <> 'd_case_details_proactive' THEN
	// Set XRef Source Type default if necessary
	
	l_nRow = dw_case_details.GetRow()
	
//END IF

This.SetFocus()

end event

event pcd_savebefore;//*********************************************************************************************
//  Event:   pcd_SaveBefore
//  Purpose: To set some values in the before behind the scenes prior to updating
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  08/16/99 M. Caruso   Add insertion of case number if not already assigned.
//  09/16/99 M. Caruso   Check if a category has been assigned to the current case.  If not, 
//                       abort the save process and notify the user why.
//  01/10/00 M. Caruso   Corrected date comparison between incident date and reported date.
//  09/29/00 M. Caruso   Commented code referencing case remarks processing.
//  12/18/00 M. Caruso   Added code to switch to the Category tab if no category is selected.
//  01/09/01 M. Caruso   oved validation code to pcd_validaterow and cleaned up remaining code 
//                       to remove things that were not needed, duplicate functionality, etc.
//  04/12/01 K. Claver   Added code to check that the case isn't a proactive case before 
//                       attempting to get the provider id from the datawindow.
//  05/09/01 K. Claver   Added code to check if the category is selected before allowing to 
//                       save.  Necessary to put this code here as well as saving on close of 
//							    the window doesn't fire the pcd_validaterow event.
//  08/07/01 C. Jackson  Correct the updating of xref fields
//  10/05/01 M. Caruso   Set the optional_grouping_id to NULL if '(None)' or ''.
//  1/16/2002 K. Claver  Corrected the tab number for categories
//  01/23/02 C. Jackson  SetItemStatus to not modified for cross reference if no changes were made
//*********************************************************************************************

U_DW_STD		l_dwDetails

l_dwDetails = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details

STRING	l_cCategoryID, l_cNull, l_cXRefSubjectID, l_cOptGrp, ls_mandatory

//Check for a category before allowing to save.
IF Trim( i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory ) = "" OR &
   IsNull( i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory ) THEN
	MessageBox( gs_AppName, "You must assign a category prior to saving a case!", StopSign!, OK! )
	i_wParentWindow.i_uoCaseDetails.tab_folder.tabpage_category.dw_categories.Enabled = TRUE
	i_wParentWindow.i_uoCaseDetails.tab_folder.SelectTab( 8 )
	Error.i_FWError = c_Fatal
END IF


//-----------------------------------------------------------------------------------------------------------------------------------
// Check to see if Optional Grouping is mandatory for this source type & Case Type.
//	If it is mandatory, ensure a selection has been made else prompt the user to make a selection.
//-----------------------------------------------------------------------------------------------------------------------------------
  SELECT cusfocus.OptionalGrouping_Mandatory.IsMandatory  
    INTO :ls_mandatory  
    FROM cusfocus.OptionalGrouping_Mandatory  
   WHERE ( cusfocus.OptionalGrouping_Mandatory.source_type = :i_wparentwindow.i_csourcetype ) AND  
         ( cusfocus.OptionalGrouping_Mandatory.case_type = :i_wparentwindow.i_ccasetype )   
           ;

If	lower(ls_mandatory) = 'y'	Then
	IF Trim( dw_case_details.GetItemString(i_CursorRow, 'optional_grouping_id') ) = "" OR &
	  IsNull( dw_case_details.GetItemString(i_CursorRow, 'optional_grouping_id') ) THEN
			MessageBox( gs_AppName, "You must select an optional grouping for this case.", StopSign!, OK! )
			i_wParentWindow.i_uoCaseDetails.tab_folder.SelectTab( 2 )
			dw_case_details.SetFocus()
			dw_case_details.SetColumn('optional_grouping_id')
			Error.i_FWError = c_Fatal
	End If
End If


//--------------------------------------------------------------------------------------
//	If we are now saving a Case that was created with no Case Subject we need to get
//	the Source Information, and Relationship this time around.
//---------------------------------------------------------------------------------------
IF i_wParentWindow.i_bNeedCaseSubject THEN

	SetItem(i_CursorRow, 'case_log_case_subject_id', i_wParentWindow.i_cCurrentCaseSubject)
	SetItem(i_CursorRow, 'case_log_source_type', i_wParentWindow.i_cSourceType)

	CHOOSE CASE i_wParentWindow.i_cSourceType

		CASE i_wParentWindow.i_cSourceProvider
			SetItem(i_CursorRow, 'case_log_source_provider_type', i_wParentWindow.i_cProviderType)
	
	END CHOOSE

	SetItem(i_CursorRow, 'case_log_source_name', i_wParentWindow.i_cCaseSubjectName)

	i_wParentWindow.i_bNeedCaseSubject = FALSE
	
END IF

// ********  This could probably be removed *********
//// if the category ID is blank, set it.
//l_cCategoryID = GetItemString (i_CursorRow, 'case_log_category_id')
//IF IsNull (l_cCategoryID) OR l_cCategoryID = '' THEN
//	SetItem(i_CursorRow, 'case_log_category_id', i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory)
//	SetItem(i_CursorRow, 'case_log_root_category_name', i_wParentWindow.i_uoCaseDetails.i_cRootCategoryName)
//END IF

// Make sure that a case number is assigned before saving!
THIS.TriggerEvent ("pcd_setkey")

//	Set who updated the case record, the timestamp
SetItem(i_CursorRow, 'case_log_updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
SetItem(i_CursorRow, 'case_log_updated_timestamp', i_wParentWindow.fw_getTimeStamp())

// Verify a valid optional grouping ID or set to NULL
l_cOptGrp = GetItemString (i_CursorRow, 'optional_grouping_id')
IF l_cOptGrp = '(None)' OR l_cOptGrp = '' THEN
	SETNULL(l_cNull)
	SetItem (i_CursorRow, 'optional_grouping_id', l_cNull)
END IF


end event

event pcd_setkey;call super::pcd_setkey;//**********************************************************************************************
//
//  Event:   pcd_setkey
//  Purpose: To set the key value for the new Case Log record.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/09/00 C. Jackson  Add table name to call to fw_GetKeyValue
//  12/11/2000 K. Claver Added code to add the new case number to the case properties tab.
//  12/27/00 M. Caruso   Added code to verify that a case number needs to be assigned before
//                       actually fetching a new one.
//  6/13/2001 K. Claver  Changed to use the new begin "call", end "call" case linking.
//  12/19/2002 K. Claver Moved getting of key value for the case to the fu_savecase function
//								 before autocommit is set to false to allow the transaction to get the
//								 key value to complete as soon as possible.
//**********************************************************************************************

STRING			l_cCaseNumber, l_cCaseMasterNum
U_DW_STD			l_dwCaseProperties
DWItemStatus	l_dwisStatus

l_cCaseNumber = GetItemString (i_CursorRow, 'case_log_case_number')

IF ( IsNull (l_cCaseNumber) OR Trim (l_cCaseNumber) = '' ) AND &
	( NOT IsNull( i_wParentWindow.i_uoCaseDetails.i_cNewCaseNum ) AND &
	  Trim( i_wParentWindow.i_uoCaseDetails.i_cNewCaseNum ) <> "" ) THEN

	//Set the new case number in the case details datawindow
//	l_cCaseNumber = i_wParentWindow.fw_GetKeyValue ('case_log')
	l_cCaseNumber = i_wParentWindow.i_uoCaseDetails.i_cNewCaseNum
	SetNull( i_wParentWindow.i_uoCaseDetails.i_cNewCaseNum )
	SetItem (i_CursorRow, 'case_log_case_number', l_cCaseNumber)
	
	IF i_wParentWindow.i_bLinked THEN		
		//Only set the link master number if it hasn't already been set.
		IF ( IsNull( i_wParentWindow.i_cCurrCaseMasterNum ) OR Trim( i_wParentWindow.i_cCurrCaseMasterNum ) = "" OR Lower( i_wParentWindow.i_cCurrCaseMasterNum ) = "not linked" ) AND &
		   ( NOT IsNull( i_wParentWindow.i_cLinkMasterCase ) AND Trim( i_wParentWindow.i_cLinkMasterCase ) <> "" ) THEN
			IF IsNull( i_wParentWindow.i_uoCaseDetails.i_cNewMasterCaseNum ) OR Trim ( i_wParentWindow.i_uoCaseDetails.i_cNewMasterCaseNum ) = "" OR Lower (i_wParentWindow.i_uoCaseDetails.i_cNewMasterCaseNum ) = "not linked" THEN
				i_wParentWindow.i_cCurrCaseMasterNum = i_wParentWindow.fw_GetKeyValue( 'case_log_master_num' )
			ELSE
				i_wParentWindow.i_cCurrCaseMasterNum = i_wParentWindow.i_uoCaseDetails.i_cNewMasterCaseNum
			END IF
			SetNull( i_wParentWindow.i_uoCaseDetails.i_cNewMasterCaseNum )
		END IF
		
		IF i_wParentWindow.i_cLinkMasterCase <> l_cCaseNumber THEN
			//Ensure that the master case number variable is null if it is an empty string.
			IF IsNull ( i_wParentWindow.i_cCurrCaseMasterNum ) OR Trim( i_wParentWindow.i_cCurrCaseMasterNum ) = "" OR Lower ( i_wParentWindow.i_cCurrCaseMasterNum ) = "not linked" THEN
				SetNull( i_wParentWindow.i_cCurrCaseMasterNum )
			END IF
			
			THIS.SetItem( i_CursorRow, 'case_log_master_case_number', i_wParentWindow.i_cCurrCaseMasterNum )
			
			//Check if the link master case already has the master case number.  If not, 
			//  update the field to reflect the link
			SELECT cusfocus.case_log.master_case_number
			INTO :l_cCaseMasterNum
			FROM cusfocus.case_log
			WHERE cusfocus.case_log.case_number = :i_wParentWindow.i_cLinkMasterCase
			USING SQLCA;
			
			//If retrieves an empty string, will let update to null.
			IF IsNull( l_cCaseMasterNum ) OR Trim( l_cCaseMasterNum ) = "" OR Lower( l_cCaseMasterNum ) = "not linked" THEN
				//Update the master case
				UPDATE cusfocus.case_log
				SET cusfocus.case_log.master_case_number = :i_wParentWindow.i_cCurrCaseMasterNum
				WHERE cusfocus.case_log.case_number = :i_wParentWindow.i_cLinkMasterCase
				USING SQLCA;
			
				IF SQLCA.SQLCode <> 0 THEN
					Error.i_FWError = c_Fatal								
				END IF
			END IF		
		END IF
		
		//Reset the link master case to the case just saved.
		i_wParentWindow.i_cLinkMasterCase = l_cCaseNumber
		i_wParentWindow.i_cLinkLastSourceType = i_wParentWindow.i_cSourceType
		i_wParentWindow.i_cLinkLastCaseType = i_wParentWindow.i_cCaseType
	ELSE
		SetNull( i_wParentWindow.i_cCurrCaseMasterNum )
		SetNull( i_wParentWindow.i_cLinkMasterCase )
	END IF
	
	i_wParentWindow.i_cCurrentCase = l_cCaseNumber
	i_wParentWindow.i_uoCaseDetails.i_cKeyValue = l_cCaseNumber
END IF
end event

event pcd_validaterow;call super::pcd_validaterow;//********************************************************************************************
//  Event:   pcd_ValidateRow
//  Purpose: Validate certain values before allowing the case to be saved.
//
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  01/09/01 M. Caruso   Created.
//  02/20/01 M. Caruso   Added check of provider_type field to replace the value with
//                       NULL if it is ''.
//  03/01/01 K. Claver   Fixed to reference case_log_provider_type field.
//  03/16/01 M. Caruso   Corrected the # reference for the categories tab.
//  04/05/01 K. Claver   Added code to check if incident date and reported dates are valid
//                       before allowing to save.  Necessary to accomodate for the MS-SQL
//                       Server year limitation.
//  04/05/01 K. Claver   Added code to check if the Contact Made, Orientation, Letter,
//                       Audio and Video Sent dates are valid before allowing to save. 
//                       Necessary to accomodate for the MS-SQL Server year limitation.
//  05/09/01 K. Claver   Added code to re-enable the categories treeview if the save failed
//                       on no category selected.
//  07/05/01 C. Jackson  Only do Cross Reference stuff if this is not a proactive case (SCR 2148)
//  02/14/02 M. Caruso   Compare incident and reported dates AND times.
//********************************************************************************************

DATE		l_dCntct, l_dOrient, l_dLetter, l_dAudio, l_dVideo
DATETIME	l_dtIncDate, l_dtRecDate
STRING	l_cNull
U_DW_STD		l_dwMatchedRecords

IF NOT in_save THEN

	Error.i_FWError = c_Success
	//---------------------------------------------------------------------------------------
	//	Check to see if the there is no Case Subject and if not place the user in the Search
	//	Criteria Tab, Cancel out of the Save and Disable the PowerClass error message.  
	//---------------------------------------------------------------------------------------
	IF i_wParentWindow.i_cCurrentCaseSubject = '' THEN
	
		MessageBox(gs_AppName, 'You must select a case subject prior to saving a case!', StopSign!, OK!)
		i_wParentWindow.i_bNeedCaseSubject = TRUE
		
		l_dwMatchedRecords = i_wParentWindow.uo_search_criteria.uo_matched_records.dw_matched_records
		i_wParentWindow.dw_folder.fu_SelectTab (1)
		l_dwMatchedRecords.fu_Activate (l_dwMatchedRecords.c_NoSetFocus)
		i_wParentWindow.uo_search_criteria.dw_search_criteria.SetFocus ()
		
		Error.i_FWError = c_Fatal
		
	ELSE
		
		// If the current case does is not assigned a category, abort the save process.
		IF i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory = '' THEN
			MessageBox (gs_AppName,'You must assign a category prior to saving a case!', StopSign!, OK!)
			i_tabfolder.tabpage_category.dw_categories.Enabled = TRUE
			i_tabfolder.SelectTab (i_nCategoriesTab)
			
			Error.i_FWError = c_Fatal
			
		ELSE
			
			//	Make sure that the Incident Date occurs prior to the Report Date (for issue/concern cases only).
			IF THIS.DataObject = "d_case_details" THEN
				
				l_dtIncDate = GetItemDateTime(i_CursorRow, 'case_log_incdnt_date')
				l_dtRecDate = GetItemDateTime(i_CursorRow, 'case_log_rprtd_date')
				
				IF NOT IsNull( Date (l_dtIncDate) ) AND Year( Date (l_dtIncDate) ) < 1753 THEN
					MessageBox( gs_AppName, "Invalid date entered for Incident Date", StopSign!, OK! )
					SetColumn( "case_log_incdnt_date" )
					
					Error.i_FWError = c_Fatal
					
				ELSEIF NOT IsNull( Date (l_dtRecDate) ) AND Year( Date (l_dtRecDate) ) < 1753 THEN
					MessageBox( gs_AppName, "Invalid date entered for Reported Date", StopSign!, OK! )
					SetColumn( "case_log_rprtd_date" )
					
					Error.i_FWError = c_Fatal
				
				ELSEIF l_dtIncDate > l_dtRecDate THEN
					
					Messagebox(gs_AppName, 'The Incident Date must be earlier than the Reported Date.', StopSign!, OK!)
					SetColumn ('case_log_incdnt_date')
					
					Error.i_FWError = c_Fatal
					
					
				END IF
				
			ELSEIF THIS.DataObject = "d_case_details_proactive" THEN
				l_dCntct = Date( THIS.GetItemDateTime( i_CursorRow, 'case_log_case_log_cntct_date' ) )
				l_dOrient = Date( THIS.GetItemDateTime( i_CursorRow, 'case_log_case_log_ornt_cmplt_dt' ) )
				l_dLetter = Date( THIS.GetItemDateTime( i_CursorRow, 'case_log_case_log_letter_sent_dt' ) )
				l_dVideo = Date( THIS.GetItemDateTime( i_CursorRow, 'case_log_case_log_vdo_sent_dt' ) )
				l_dAudio = Date( THIS.GetItemDateTime( i_CursorRow, 'case_log_case_log_ado_sent_dt' ) )
				
				IF NOT IsNull( l_dCntct ) AND Year( l_dCntct ) < 1753 THEN
					MessageBox( gs_AppName, "Invalid date entered for Contact Made Date", StopSign!, OK! )
					SetColumn( "case_log_case_log_cntct_date" )
					
					Error.i_FWError = c_Fatal
				ELSEIF NOT IsNull( l_dOrient ) AND Year( l_dOrient ) < 1753 THEN
					MessageBox( gs_AppName, "Invalid date entered for Orientation Date", StopSign!, OK! )
					SetColumn( "case_log_case_log_ornt_cmplt_dt" )
					
					Error.i_FWError = c_Fatal
				ELSEIF NOT IsNull( l_dLetter ) AND Year( l_dLetter ) < 1753 THEN
					MessageBox( gs_AppName, "Invalid date entered for Letter Sent Date", StopSign!, OK! )
					SetColumn( "case_log_case_log_letter_sent_dt" )
					
					Error.i_FWError = c_Fatal
				ELSEIF NOT IsNull( l_dVideo ) AND Year( l_dVideo ) < 1753 THEN
					MessageBox( gs_AppName, "Invalid date entered for Video Sent Date", StopSign!, OK! )
					SetColumn( "case_log_case_log_vdo_sent_dt" )
					
					Error.i_FWError = c_Fatal
				ELSEIF NOT IsNull( l_dAudio ) AND Year( l_dAudio ) < 1753 THEN
					MessageBox( gs_AppName, "Invalid date entered for Audio Sent Date", StopSign!, OK! )
					SetColumn( "case_log_case_log_ado_sent_dt" )
					
					Error.i_FWError = c_Fatal
				END IF			
			END IF
			
		END IF
		
	END IF
	
END IF


end event

event buttonclicked;call super::buttonclicked;//************************************************************************************************
//
//  Event:   buttonclicked
//  Purpose: To swap and retrieve the drop down
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  06/06/01 C. Jackson  Original Version
//  10/30/01 C. Jackson  Correct Cross Reference
//  11/14/02 C. Jackson  Add code to open the Cross Reference details
//  12/15/02 C. Jackson  Add security to prevent a user with inadequate security from seeing the
//                       Cross Referenced Name.  ('Access Denied' is displayed)
//  03/06/02 C. Jackson  Set i_cButton to null after we're done with it (SCR 2814)
//  05/31/02 C. Jackson  Add Clear for Cross Reference
//************************************************************************************************

STRING l_cSourceType, l_cSearchID, l_cParm, l_cXRefSubjectId, l_cXRefSourceType, l_cXRefProviderType
STRING l_cName, l_cName2, l_cName3, l_cXRefCCSubject, l_cData, l_cParent, l_cLogin, l_cCCName, l_cType
STRING l_cProviderType, l_cNull, ls_searchType
LONG l_nReturn, l_nRow, l_nDemogSecurity, l_nUserSecurity
BOOLEAN l_bOkToChange = TRUE, l_bAsk

l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

SetNull(l_cNull)

SELECT rec_confidentiality_level 
  INTO :l_nUserSecurity
  FROM cusfocus.cusfocus_user
 WHERE user_id = :l_cLogin
 USING SQLCA;

i_cButton = string(dwo.name)

l_nRow = THIS.GetRow()
// Added xref ability to proactive cases - RAP 7/26/07
//IF THIS.dataobject <> 'd_case_details_proactive' THEN
	l_cData = THIS.GetItemString(l_nRow,'cc_xref_subject_id')
	
	CHOOSE CASE i_cButton
			
		CASE 'b_clear'
			// Check to see if there is anything to clear
			IF NOT IsNull(THIS.GetItemString(1,'case_log_xref_subject_id')) THEN
				THIS.SetItem(1,'cc_xref_subject_id',l_cNull)
				THIS.SetItem(1,'cc_xref_name',l_cNull)
				THIS.SetItemStatus(l_nRow,'cc_xref_subject_id',Primary!,NotModified!)
				THIS.SetItemStatus(l_nRow,'cc_xref_name',Primary!,NotModified!)
				THIS.SetItem(1,'case_log_xref_source_type',l_cNull)
				THIS.SetItem(1,'case_log_xref_subject_id',l_cNull)
				THIS.SetItem(1,'case_log_xref_provider_type',l_cNull)
				THIS.AcceptText()
				THIS.Object.xref_title_id_t.Text = 'Provider Cross Ref ID:'		
				THIS.Object.xref_title_name_t.Text = 'Provider Cross Ref Name:'

			END IF
			
		CASE 'b_xref_lookup'
	
		IF NOT IsNull(l_cData) AND TRIM(l_cData) <> '' THEN
			IF NOT i_bOverWrite THEN
				l_bAsk = TRUE
			END IF
			IF i_bSaved AND NOT i_bAnswered THEN
				l_bAsk = TRUE
			END IF
			IF i_bInit THEN
				l_bAsk = TRUE
			END IF
			
		
			IF l_bAsk THEN
				l_nReturn = MessageBox(gs_AppName,'There is already a Cross Reference defined, ' + &
													 'do you wish to change it?',Question!,YesNo!)
				l_bAsk = FALSE
				i_bAnswered = FALSE
			ELSE
				l_nReturn = 1
				IF IsValid(w_cross_ref) THEN
					Close(w_cross_ref)
				END IF
			END IF
													
			IF l_nReturn = 2 THEN
		
				// Put back to original
				SELECT xref_source_type, xref_subject_id, xref_provider_type
				  INTO :l_cXRefSourceType, :l_cXRefSubjectID, :l_cXRefProviderType
				  FROM cusfocus.case_log
				 WHERE case_number = :i_wParentWindow.i_cCurrentCase
				 USING SQLCA;
				 
				 IF NOT IsNull(l_cXRefSubjectID) AND TRIM(l_cXRefSubjectID) <> '' THEN
				 
					 IF l_cXRefSourceType = 'P' THEN
					 
						SELECT provider_id, provid_name, provid_name_2, confidentiality_level
						  INTO :l_cXRefCCSubject, :l_cName, :l_cName2, :l_nDemogSecurity
						  FROM cusfocus.provider_of_service
						 WHERE provider_key = CONVERT(INT,:l_cXRefSubjectId)
						 USING SQLCA;
				
						IF l_nDemogSecurity > l_nUserSecurity THEN
							l_cName = 'Access Denied'
						ELSE
							IF NOT ISNULL(l_cName2) OR TRIM(l_cName2) <> '' THEN
								l_cName = l_cName + ', ' + l_cName2
							END IF
						END IF
						
					ELSE
						// Get consumer info
						SELECT consum_last_name, consum_first_name, consum_mi, confidentiality_level
						  INTO :l_cName, :l_cName2, :l_cName3, :l_nDemogSecurity
						  FROM cusfocus.consumer
						 WHERE consumer_id = :l_cXRefSubjectID
						 USING SQLCA;
						 
						IF l_nDemogSecurity > l_nUserSecurity THEN
							l_cName = 'Access Denied'
						ELSE
							IF NOT ISNULL(l_cName2) OR TRIM(l_cName2) <> '' THEN
								l_cName = l_cName + ', ' + l_cName2
							END IF
							
							IF NOT ISNULL(l_cName3) OR TRIM(l_cName3) <> '' THEN
								l_cName = l_cName + ' ' + l_cName3
							END IF
							
						END IF
							
						l_cXRefCCSubject = l_cXRefSubjectID
						
					END IF
					
				END IF
		
				l_nRow = THIS.GetRow()
				
					IF IsNull(THIS.GetItemString(l_nRow,'case_log_xref_subject_id')) THEN
						SetItem(l_nRow,'case_log_xref_source_type',l_cXRefSourceType)
						SetItem(l_nRow,'case_log_xref_provider_type',l_cXRefProviderType)
						SetItem(l_nRow,'cc_xref_name',l_cName)
						SetItem(l_nRow,'cc_xref_subject_id',l_cXRefCCSubject)
						AcceptText()
						SetItemStatus(l_nRow,'case_log_xref_source_type',Primary!,NotModified!)
						SetItemStatus(l_nRow,'case_log_xref_subject_id',Primary!,NotModified!)
						SetItemStatus(l_nRow,'cc_xref_name',Primary!,NotModified!)
						SetItemStatus(l_nRow,'cc_xref_subject_id',Primary!,NotModified!)
						i_cXRefSubjectID = l_cXRefCCSubject
						i_cXRefSource = l_cXRefSourceType
						i_cXRefProviderType = l_cXRefProviderType
						i_cCCName = l_cName
						
						SetItemStatus(row,0,Primary!,NotModified!)
						i_bCancelled = TRUE
						THIS.AcceptText()
						RETURN Error.i_FWError
						
					ELSE
						l_bOKToChange = FALSE
		
					END IF
		ELSE
				l_bOkToChange = TRUE
			END IF
		
		END IF
			
		IF l_bOkToChange THEN
			IF NOT IsNull(i_cHoldXRef) OR TRIM(i_cHoldXRef) <> '' THEN
				l_cSearchID = i_cHoldXRef
			ELSE
				l_cSearchID = THIS.GetItemString(l_nRow,'cc_xref_subject_ID')
			END IF
			
			IF ISNULL(l_cSearchID) OR TRIM(l_cSearchID) = '' THEN
				l_cSearchID = ''
			END IF
			
			l_cParm = l_cSourceType + ',' + l_cSearchID
			
			i_bCancelled = FALSE
			
			//capture the search type before open cross ref window
			ls_searchType = gs_seachType
			FWCA.MGR.fu_OpenWindow(w_cross_ref)
			
			l_cType = MID(message.stringparm,1,1)
			l_cXRefSubjectId = MID(message.stringparm,2)
			
			//Reset global search type var
			gs_seachType = ls_searchType
			
			IF l_cType = 'P' THEN
				// Get the Provider Details
				SELECT provider_id, provider_type, provid_name, provid_name_2, confidentiality_level
				  INTO :l_cXRefCCSubject, :l_cProviderType, :l_cName, :l_cName2, :l_nDemogSecurity
				  FROM cusfocus.provider_of_service
				 WHERE provider_key = convert(int,:l_cXRefSubjectID)
				 USING SQLCA;
				 
				IF NOT ISNULL(l_cName2) AND TRIM(l_cName2) <> '' THEN
					l_cName = l_cName + ', ' + l_cName2
				END IF
				IF IsNull (l_cName) THEN
					IF NOT ISNULL(l_cName2) THEN
						l_cName = l_cName2
					ELSE
						l_cName = ''
					END IF
				END IF
				 
				THIS.SetItem(1,'case_log_xref_source_type','P')
	 			THIS.SetItem(1,'case_log_xref_subject_id',l_cXRefSubjectID)
				THIS.SetItem(1,'case_log_xref_provider_type',l_cProviderType)
				THIS.SetItem(1,'cc_xref_subject_id',l_cXRefCCSubject)
				THIS.SetItem(1,'cc_xref_name',l_cName)				 
				 
				// Set field labels for Provider
				THIS.Object.xref_title_id_t.Text = 'Provider Cross Ref ID:'		
				THIS.Object.xref_title_name_t.Text = 'Provider Cross Ref Name:'
				
				
			ELSEIF l_cType = 'C' THEN
				// Get the Member Details
				SELECT consum_last_name, consum_first_name, consum_mi, confidentiality_level
				  INTO :l_cName, :l_cName2, :l_cName3, :l_nDemogSecurity
				  FROM cusfocus.consumer
				 WHERE consumer_id = :l_cXRefSubjectID
				 USING SQLCA;

				IF NOT ISNULL(l_cName2) AND TRIM(l_cName2) <> '' THEN
					l_cName = l_cName + ', ' + l_cName2
				END IF
				
				IF NOT ISNULL(l_cName3) AND TRIM(l_cName3) <> '' THEN
					l_cName = l_cName + ' ' + l_cName3
				END IF
					
				THIS.SetItem(1,'case_log_xref_source_type','C')
	 			THIS.SetItem(1,'case_log_xref_subject_id',l_cXRefSubjectID)
				THIS.SetItem(1,'cc_xref_subject_id',l_cXRefSubjectID)
				THIS.SetItem(1,'cc_xref_name',l_cName)				 
				THIS.SetItem(1,'case_log_xref_provider_type',l_cNull)
				
				// Set field labels for Member
				THIS.Object.xref_title_id_t.Text = 'Member Cross Ref ID:'		
				THIS.Object.xref_title_name_t.Text = 'Member Cross Ref Name:'
				
			ELSEIF l_cType = 'E' THEN
				// Get Group Details
				SELECT employ_group_name, confidentiality_level
				  INTO :l_cName, :l_nDemogSecurity
				  FROM cusfocus.employer_group
				 WHERE group_id = :l_cXRefSubjectID
				 USING SQLCA;
				 
				THIS.SetItem(1,'case_log_xref_source_type','E')
				THIS.SetItem(1,'case_log_xref_subject_id',l_cXRefSubjectID)
				THIS.SetItem(1,'cc_xref_subject_id',l_cXRefSubjectID)
				THIS.SetItem(1,'cc_xref_name',l_cName)
				THIS.SetItem(1,'case_log_xref_provider_type',l_cNull)				
				
				//Set Field labels for Group
				THIS.Object.xref_title_id_t.Text = 'Group Cross Ref ID:'
				THIS.Object.xref_title_name_t.Text = 'Group Cross Ref Name:'
				 
			ELSEIF l_cType = 'O' THEN
				// Get Other Details
				SELECT other_last_name, other_first_name, other_mi, confidentiality_level
				  INTO :l_cName, :l_cName2, :l_cName3, :l_nDemogSecurity
				  FROM cusfocus.other_source
				 WHERE customer_id = :l_cXRefSubjectID
				 USING SQLCA;

				IF NOT ISNULL(l_cName2) AND TRIM(l_cName2) <> '' THEN
					l_cName = l_cName + ', ' + l_cName2
				END IF
				
				IF NOT ISNULL(l_cName3) AND TRIM(l_cName3) <> '' THEN
					l_cName = l_cName + ' ' + l_cName3
				END IF
				 
				THIS.SetItem(1,'case_log_xref_source_type','O')
				THIS.SetItem(1,'case_log_xref_subject_id',l_cXRefSubjectID)
				THIS.SetItem(1,'cc_xref_subject_id',l_cXRefSubjectID)
				THIS.SetItem(1,'cc_xref_name',l_cName)
				THIS.SetItem(1,'case_log_xref_provider_type',l_cNull)				
				
				//Set Field labels for Group
				THIS.Object.xref_title_id_t.Text = 'Other Cross Ref ID:'
				THIS.Object.xref_title_name_t.Text = 'Other Cross Ref Name:'
				 
				 
			END IF
			
		END IF
		
	CASE 'b_cross_ref_details'

		IF i_bExactMatch THEN
			THIS.AcceptText()
			i_cXRefSubjectID = THIS.GetItemString(l_nRow,'cc_xref_subject_id')
		END IF

		l_cXRefSourceType = THIS.GetItemString(1,'case_log_xref_source_type')
		l_cXRefSubjectId = THIS.GetItemString(1,'case_log_xref_subject_id')
		l_cXRefProviderType = THIS.GetItemString(1,'case_log_xref_provider_type')
		
		IF NOT IsNull(i_cXRefSubjectID) AND TRIM(i_cXRefSubjectID) <> '' THEN
			
			l_cCCName = THIS.GetItemString(l_nRow,'cc_xref_name')
			
			IF UPPER(l_cCCName) <> 'ACCESS DENIED' THEN
					
				l_cParent = 'u_tabpage_case_details'
				
				IF l_cXRefSourceType = 'P' THEN
					l_cParm = l_cParent + ',' + l_cXRefSourceType + ',' + l_cXRefSubjectId + ',' + l_cXRefProviderType
				ELSE
					l_cParm = l_cParent + ',' + l_cXRefSourceType + ',' + l_cXRefSubjectId
				END IF

				//capture the search type before open cross ref window
				ls_searchType = gs_seachType
				
				FWCA.MGR.fu_OpenWindow(w_cross_ref, l_cParm)
				
				//reset search type
				gs_seachType = ls_searchType 
				
			ELSE
				messagebox(gs_AppName,'Access Denied to the Demographic Details.')
				
			END IF
			
		ELSE
			messagebox(gs_AppName,'No Cross Reference Defined.')
			
		END IF
		
	END CHOOSE
		
//END IF

SetNull(i_cButton)

end event

event editchanged;call super::editchanged;//********************************************************************************************
//
//  Event:   editchanged
//  Purpose: Grab data user just entered for save
//
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  10/30/01 C. Jackson  Original Version
//********************************************************************************************


//IF THIS.dataobject <> 'd_case_details_proactive' THEN
	
	IF dwo.name = 'cc_xref_subject_id' THEN
		IF TRIM(data) = '' THEN
			i_cHoldXRef = ''
		ELSE
			i_cHoldXRef = data
		END IF
	END IF
//END IF
end event

event getfocus;call super::getfocus;//*************************************************************************************************
//
//  Event:   GetFocus
//  Purpose: To populate instance variable for use in setting the Cross Reference Subject Id
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------------
//  10/30/01 C. Jackson  Original Version  
//*************************************************************************************************

i_bdwhasfocus = TRUE
end event

event losefocus;call super::losefocus;////********************************************************************************************
////
////  Event:   losefocus
////  Purpose: 
////  
////  Date     Developer   Description
////  -------- ----------- ---------------------------------------------------------------------
////  01/14/02 C. Jackson  Original Version
////********************************************************************************************
//
//U_DW_STD		l_dwDetails
//
//l_dwDetails = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
//
//
//IF NOT IsNull(i_cXRefCCSubject) THEN
//	
//	IF i_wParentWindow.i_cCaseType <> 'P' THEN
//
//		THIS.SetItem(GetRow(),'cc_xref_subject_id',i_cXRefCCSubject)
//		THIS.SetItemStatus(GetRow(),'cc_xref_subject_id',Primary!,NotModified!)
//		
//	END IF
//	
//END IF
//
end event

