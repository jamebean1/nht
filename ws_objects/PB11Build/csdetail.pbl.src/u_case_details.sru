$PBExportHeader$u_case_details.sru
$PBExportComments$Case detail container for Compliment, Inquiry and Issue/Concern cases.
forward
global type u_case_details from u_container_std
end type
type cb_default_note from commandbutton within u_case_details
end type
type cb_spell_check from commandbutton within u_case_details
end type
type cb_edit from commandbutton within u_case_details
end type
type cb_new from commandbutton within u_case_details
end type
type cb_save from commandbutton within u_case_details
end type
type tab_folder from u_tab_case_details within u_case_details
end type
type tab_folder from u_tab_case_details within u_case_details
end type
type dw_case_note_entry from u_dw_std within u_case_details
end type
type gb_note_entry from groupbox within u_case_details
end type
end forward

global type u_case_details from u_container_std
integer width = 3579
integer height = 1600
cb_default_note cb_default_note
cb_spell_check cb_spell_check
cb_edit cb_edit
cb_new cb_new
cb_save cb_save
tab_folder tab_folder
dw_case_note_entry dw_case_note_entry
gb_note_entry gb_note_entry
end type
global u_case_details u_case_details

type variables
BOOLEAN						i_bClearPreviousValues
BOOLEAN						i_bCloseByOwner
BOOLEAN						i_bExternalNote
BOOLEAN						i_bChangeCaseType = FALSE
BOOLEAN						i_bCopyProperties

LONG							i_nReopenLimit
LONG							i_nMaxLevels

STRING						i_cCaseStatus
STRING						i_cKeyValue
STRING						i_cSelectedCategory
STRING						i_cRootCategoryName
STRING						i_cDefaultNoteType
STRING						i_cDefaultContactMethod
STRING						i_cNewCaseNum
STRING						i_cNewCaseNoteID
STRING						i_cNewMasterCaseNum

STRING						i_cCarveOutEnabled
STRING						i_cCarveOutConfigCaseType
STRING						i_cCarveOutInquiry
STRING						i_cCarveOutIssueConcern
STRING						i_cCarveOutProactive


W_CREATE_MAINTAIN_CASE	i_wParentWindow

boolean						ib_converted_casetype = FALSE

string						is_using_new_appeals
string						is_using_eligibility
//STRING						i_cAppealsEnabled
STRING						i_cAppealsConfigCaseType
STRING						i_cAppealsInquiry
STRING						i_cAppealsIssueConcern
STRING						i_cAppealsProactive
boolean						ib_shown_note_msg
n_spell_checking			in_spell_checking
ULONG							iul_handle

INTEGER						ii_spelling_sid
STRING						is_default_note_text

end variables

forward prototypes
public subroutine fu_getcarveoutavailability (ref string a_enabled, ref string a_configcasetype, ref string a_inquiry, ref string a_issue, ref string a_proactive)
public subroutine fu_enablenoteentry (boolean enable_notes)
public function boolean fu_allowedtoclose ()
public function integer fu_savecase (integer changes)
public subroutine fu_copyprops (string a_clastcasenum, string a_clastcasetype, string a_clastsourcetype)
public subroutine fu_enablecarveout ()
public subroutine fu_setcasedetailgui (boolean active)
public subroutine fu_setwindowtitle ()
public subroutine fu_reopencase ()
public subroutine fu_copyxref (string a_clastcasenum)
public subroutine fu_setlockedcasegui ()
public subroutine fu_setclosedcasegui ()
public subroutine fu_setopencasegui ()
public function integer fu_newcase ()
public subroutine fu_setvoidedcasegui ()
public function integer fu_opencase ()
public subroutine fu_changecasetype ()
public function integer fu_checkrequiredproperties ()
public function integer fu_addcustomerstmt (u_dw_std a_dwsource)
public function integer fu_savecase (integer changes, boolean validate)
public subroutine of_enable_appeals ()
public subroutine of_check_appeal_setting ()
public subroutine of_get_appeal_availability (ref string a_configcasetype, ref string a_inquiry, ref string a_issue, ref string a_proactive)
public subroutine of_enable_eligibility ()
public subroutine of_check_eligibility_setting ()
end prototypes

public subroutine fu_getcarveoutavailability (ref string a_enabled, ref string a_configcasetype, ref string a_inquiry, ref string a_issue, ref string a_proactive);/*****************************************************************************************
   Function:   fu_GetCarveOutAvailability
   Purpose:    Gather the availability settings for the carve out functionality.
   Parameters: REF STRING a_enabled - is carve out enabled (Y/N)
					REF STRING a_configcasetype - is it available for configurable case type (MPEO)
					REF STRING a_inquiry - is it available for inquiry cases (MPEO)
					REF STRING a_issue - is it available for issue/concern cases (MPEO)
					REF STRING a_proactive - is it available for proactive cases (MPEO)
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/23/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nIndex
STRING	l_cOption, l_cValue[5]

FOR l_nIndex = 1 TO 5
	
	CHOOSE CASE l_nIndex
		CASE 1
			l_cOption = 'carveout enabled'
			
		CASE 2
			l_cOption = 'carveout configurable'
		
		CASE 3
			l_cOption = 'carveout inquiry'
		
		CASE 4
			l_cOption = 'carveout issue'
		
		CASE 5
			l_cOption = 'carveout proactive'
			
	END CHOOSE
	
	SELECT option_value
	  INTO :l_cValue[l_nIndex]
	  FROM cusfocus.system_options
	 WHERE option_name = :l_cOption
	 USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			// abort on error setting default values for all options
			MessageBox (gs_appname, 'Error retrieving Carve Out configuration.')
			l_cValue[1] = 'N'
			l_cValue[2] = ''
			l_cValue[3] = ''
			l_cValue[4] = ''
			l_cValue[5] = ''
			EXIT
			
		CASE 0
			// all went well
			
		CASE 100
			// set default value for the current option
			IF l_nIndex = 1 THEN
				l_cValue[l_nIndex] = 'N'
			ELSE
				l_cValue[l_nIndex] = ''
			END IF
			
	END CHOOSE
		
NEXT

a_enabled = l_cValue[1]
a_configcasetype = l_cValue[2]
a_inquiry = l_cValue[3]
a_issue = l_cValue[4]
a_proactive = l_cValue[5]
end subroutine

public subroutine fu_enablenoteentry (boolean enable_notes);/*****************************************************************************************
   Function:   fu_EnableNoteEntry
   Purpose:    This function enables or disables the note entry interface as needed.
   Parameters: NONE
   Returns:    INTEGER - 0 Success
								-1 Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/8/00  M. Caruso    Created.
	01/02/01 M. Caruso    Added code to set note type status based on whether the default
								 note type is external.
*****************************************************************************************/

LONG		l_nStatus, l_nColor
STRING	l_nExternal
DATAWINDOWCHILD	l_dwcList

IF enable_notes THEN
	
	l_nStatus = 0
	l_nColor = 16777215
	
ELSE
	
	l_nStatus = 1
	l_nColor = 79741120
	
END IF

dw_case_note_entry.object.note_text.protect = l_nStatus
dw_case_note_entry.object.note_text.background.color = l_nColor
dw_case_note_entry.object.note_type.protect = l_nStatus
	dw_case_note_entry.object.note_type.background.color = l_nColor
IF i_bExternalNote THEN
	// for external note types, set the status of the field as appropriate.
	dw_case_note_entry.object.method_id.protect = l_nStatus
	dw_case_note_entry.object.method_id.background.color = l_nColor	
ELSE
	// for internal note types, this should always be disabled.
	dw_case_note_entry.object.method_id.protect = 1
	dw_case_note_entry.object.method_id.background.color = 79741120	
END IF
dw_case_note_entry.object.note_security_level.protect = l_nStatus
dw_case_note_entry.object.note_security_level.background.color = l_nColor
dw_case_note_entry.object.note_importance.protect = l_nStatus
dw_case_note_entry.object.note_importance.background.color = l_nColor

// set the status of the control buttons
i_wParentWindow.i_uoCaseDetails.cb_save.Enabled = enable_notes
i_wParentWindow.i_uoCaseDetails.cb_new.Enabled = enable_notes
i_wParentWindow.i_uoCaseDetails.cb_edit.Enabled = enable_notes
i_wParentWindow.i_uoCaseDetails.cb_spell_check.Enabled = enable_notes

end subroutine

public function boolean fu_allowedtoclose ();/*****************************************************************************************
   Function:   fu_AllowedToClose
   Purpose:    determine if the current user is allowed to close the case.
   Parameters: NONE
   Returns:    BOOLEAN -	TRUE: the user is allowed access to the close case feature
									FALSE: the user is not allowed access to the close case feature

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/14/00 M. Caruso    Created.
	01/28/02 C. Jackson   convert all user_id's to UPPER in case the data in the database
	                      is upper case (SCR 2636)
*****************************************************************************************/

BOOLEAN	l_bReturnForClose
INTEGER	l_nRFC, l_nNotifyOnClose, l_nSecurityLevel
STRING	l_cOwner, l_cTakenBy, l_cCurrentUser, l_cXferTo, l_cXferFrom, l_cXferType = 'O'
LONG ll_history_count

U_DW_STD	l_dwCaseDetails

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details

IF l_dwCaseDetails.RowCount( ) > 0 THEN
	// determine who is what when related to this case
	l_cOwner = UPPER(l_dwCaseDetails.GetItemString (1, 'case_log_case_log_case_rep'))
	l_cTakenBy = UPPER(l_dwCaseDetails.GetItemString (1, 'case_log_case_log_taken_by'))
	l_cCurrentUser = OBJCA.WIN.fu_GetLogin (SQLCA)
	
	// determine if this case has been marked return for close
	SELECT return_for_close, UPPER(case_transfer_to), UPPER(case_transfer_from)
	  INTO :l_nRFC, :l_cXferTo, :l_cXferFrom
	  FROM cusfocus.case_transfer
	 WHERE case_number = :i_wParentWindow.i_cCurrentCase AND case_transfer_type = :l_cXferType
	 USING SQLCA;
	 
	// check history to determine if this case has been marked return for close
	IF IsNull (l_nRFC) OR l_nRFC = 0 THEN
		SELECT count(*) INTO :ll_history_count
		  FROM cusfocus.case_transfer_history
		 WHERE case_number = :i_wParentWindow.i_cCurrentCase 
		 AND case_transfer_type = :l_cXferType
		 AND return_for_close = 1
		 USING SQLCA;
		 
		 IF ll_history_count > 0 THEN
			SELECT return_for_close, UPPER(case_transfer_to), UPPER(case_transfer_from)
			  INTO :l_nRFC, :l_cXferTo, :l_cXferFrom
			  FROM cusfocus.case_transfer_history
			 WHERE case_number = :i_wParentWindow.i_cCurrentCase AND case_transfer_type = :l_cXferType
			 USING SQLCA;
		END IF
	END IF
	 
	CHOOSE CASE SQLCA.SQLCode
		CASE 0
			IF IsNull (l_nRFC) THEN l_nRFC = 0
			IF l_nRFC = 1 THEN
				l_bReturnForClose = TRUE
			ELSE
				l_bReturnForClose = FALSE
			END IF
			
		CASE ELSE
			l_bReturnForClose = FALSE
			
	END CHOOSE
	
	// determine if the user has access to the close case button for this case
	IF l_bReturnForClose THEN
		
		IF UPPER(l_cOwner) <> UPPER(l_cTakenBy) THEN
			// if the case has not yet been transferred back to the owner, allow access
			RETURN TRUE
		ELSE
		
			IF i_bCloseByOwner THEN
				
				IF UPPER(l_cCurrentUser) = UPPER(l_cTakenBy) THEN
					// only the owner can close the case
					RETURN TRUE
				ELSE
					RETURN FALSE
				END IF
			
			ELSE
				
				l_nSecurityLevel = l_dwCaseDetails.GetItemNumber (1, 'confidentiality_level')
				IF i_wParentWindow.i_nRepConfidLevel >= l_nSecurityLevel THEN
					// any user with equal or higher security can close the case
					RETURN TRUE
				ELSE
					RETURN FALSE
				END IF
				
			END IF
			
		END IF
		
	ELSE
		RETURN TRUE
	END IF
ELSE
	//Case details weren't retrieved.  Return false.
	RETURN FALSE
END IF
end function

public function integer fu_savecase (integer changes);/*****************************************************************************************
   Function:   fu_SaveCase
   Purpose:    Provide one function for saving the elements of a case.  Assumes validation
					should be performed.
   Parameters: INTEGER	changes - c_PromptChanges: prompt the user
											 c_IgnoreChanges: ignore changes
											 c_SaveChanges:	save changes without prompting
   Returns:    INTEGER -	c_Success:	save process was successful
									c_Fatal:		save process failed
									c_Cancel:	save process cancelled by the user.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/11/01 M. Caruso    Created.
*****************************************************************************************/

RETURN fu_savecase (changes, TRUE)
end function

public subroutine fu_copyprops (string a_clastcasenum, string a_clastcasetype, string a_clastsourcetype);/*****************************************************************************************
   Function:   fu_CopyProps
   Purpose:    This function copies the current case properties to the next linked case
   Parameters: a_cLastCaseNum - The last case number saved
					a_cLastCaseType - Case type of the last case
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/13/2001 K. Claver   Initial Version
*****************************************************************************************/
String l_cNull
DateTime l_dtNull
u_dw_std l_dwCaseProperties
Integer l_nRowCount

IF NOT IsNull( a_cLastCaseNum ) AND Trim( a_cLastCaseNum ) <> "" THEN
	l_dwCaseProperties = tab_folder.tabpage_case_properties.dw_case_properties
			
	SetNull( l_cNull )
	SetNull( l_dtNull )
	
	l_nRowCount = l_dwCaseProperties.Retrieve( a_cLastCaseNum, a_cLastCaseType, a_cLastSourceType )
	
	IF l_nRowCount > 0 THEN
		l_dwCaseProperties.Object.case_number[ 1 ] = l_cNull
		l_dwCaseProperties.Object.updated_by[ 1 ] = l_cNull
		l_dwCaseProperties.Object.updated_timestamp[ 1 ] = l_dtNull
		l_dwCaseProperties.SetItemStatus( 1, 0, Primary!, NewModified! )
	ELSEIF l_nRowCount = 0 THEN
		l_dwCaseProperties.fu_New (1)		
	END IF
END IF
end subroutine

public subroutine fu_enablecarveout ();/*****************************************************************************************
   Function:   fu_EnableCarveOut
   Purpose:    determine whether or not to show and enable/disable the carve out tab
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/23/01 M. Caruso    Created.
	04/22/02 M. Caruso    Enable the tab if carve out entries exist for the case,
								 regardless of source type or case type restrictions.
*****************************************************************************************/

LONG		l_nCount
STRING	l_cSources

// determine whether or not to show the carve out tab
IF i_cCarveOutEnabled = 'Y' THEN
	
	tab_folder.tabpage_carve_out.visible = TRUE
	CHOOSE CASE i_wParentWindow.i_cCaseType
		CASE i_wParentWindow.i_cConfigCaseType
			l_cSources = i_cCarveOutConfigCaseType
			
		CASE i_wParentWindow.i_cInquiry
			l_cSources = i_cCarveOutInquiry
			
		CASE i_wParentWindow.i_cIssueConcern
			l_cSources = i_cCarveOutIssueConcern
			
		CASE i_wParentWindow.i_cProactive
			l_cSources = i_cCarveOutProactive
			
	END CHOOSE
	
	IF Pos (l_cSources, i_wParentWindow.i_cSourceType) = 0 THEN
		
		SELECT count(*) INTO :l_nCount
		  FROM cusfocus.carve_out_entries
		 WHERE case_number = :i_wParentWindow.i_cCurrentCase
		 USING SQLCA;
		 
		CHOOSE CASE SQLCA.SQLCode
			CASE -1		// error, so disable the tab
				MessageBox (gs_appname, 'Unable to determine if carve out entries exist for~r~n' + &
												'this case, so the carve out tab is being disabled.')
				tab_folder.tabpage_carve_out.enabled = FALSE
				
			CASE 0		// records exist, so enable the tab
				IF l_nCount = 0 THEN
					tab_folder.tabpage_carve_out.enabled = FALSE
				ELSE
					tab_folder.tabpage_carve_out.enabled = TRUE
				END IF
				
			CASE 100		// no records found, so disable the tab
				tab_folder.tabpage_carve_out.enabled = FALSE
				
		END CHOOSE
		
	ELSE
		tab_folder.tabpage_carve_out.enabled = TRUE
	END IF
	
ELSE
	tab_folder.tabpage_carve_out.visible = FALSE
END IF
end subroutine

public subroutine fu_setcasedetailgui (boolean active);//***********************************************************************************************
//
//  Function: fu_SetCaseDetailGUI
//  Purpose:  Set the case detail GUI active or inactive as appropriate
//  Parameters: BOOLEANactive - Determine the state to set.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  11/21/00 M. Caruso   Created.
//  11/27/00 M. Caruso   Removed code to change the background color of the checkbox fields for 
//                       proactive cases.
//  11/30/00 M. Caruso   Expanded this function to set the state of all editable fields on the 
//                       different case detail views.
//  01/03/01 M. Caruso   Added code to set the status of the data fields on the proactive case 
//                       detail tab.
//  01/13/01 M. Caruso   Set send default survey field according to the status of Inquiry or 
//                       Compliment case.
//  05/30/01 C. Jackson  Change to xref_subject_id
//  07/16/01 M. Caruso   Set Inquiry cases like Issue/Concern cases.
//  07/30/01 M. Caruso   Set Compliment cases like Issue/Concern cases.
//  03/05/02 M. Caruso   Do not enable Print Survey on Close if no default survey is specified.
//***********************************************************************************************


CONSTANT	LONG	l_nColorOn = 16777215
CONSTANT	LONG	l_nColorOff = 79741120
CONSTANT	INTEGER	l_nUnprotected = 0
CONSTANT	INTEGER	l_nProtected = 1

LONG		l_nColor
INTEGER	l_nStatus
STRING	l_cValue, l_cLetterID
U_DW_STD	l_dwCaseDetails

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details


IF active THEN
	l_nStatus = l_nUnprotected
	l_nColor = l_nColorOn
ELSE
	l_nStatus = l_nProtected
	l_nColor = l_nColorOff
END IF
		
CHOOSE CASE i_wParentWindow.i_cCaseType
	CASE i_wParentWindow.i_cInquiry, i_wParentWindow.i_cIssueConcern, i_wParentWindow.i_cConfigCaseType
		IF l_dwCaseDetails.DataObject = "d_case_details" THEN
			l_dwCaseDetails.Object.case_log_case_priority.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_case_priority.Background.Color = l_nColor
			l_dwCaseDetails.Object.confidentiality_level.protect = l_nStatus
			l_dwCaseDetails.Object.confidentiality_level.Background.Color = l_nColor
			l_dwCaseDetails.Object.case_log_appld.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_appld.Background.Color = l_nColor
			l_dwCaseDetails.Object.case_log_incdnt_date.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_incdnt_date.Background.Color = l_nColor
			l_dwCaseDetails.Object.case_log_rprtd_date.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_rprtd_date.Background.Color = l_nColor
			l_dwCaseDetails.Object.optional_grouping_id.protect = l_nStatus
			l_dwCaseDetails.Object.optional_grouping_id.Background.Color = l_nColor
				
			// get the letter ID for the current case type
			SELECT letter_id INTO :l_cLetterID FROM cusfocus.case_types WHERE case_type = :i_wParentWindow.i_cCaseType;
	
			IF (SQLCA.SQLCode <> 0) OR (IsNull (l_cLetterID)) OR (l_cLetterID = '') OR (NOT active) THEN
				// Disable the print survey check box.
				l_dwCaseDetails.Object.case_log_snd_srvy_clsd.protect = l_nProtected
				l_dwCaseDetails.Object.case_log_snd_srvy_clsd.Background.Color = l_nColorOff
			ELSE	
				// Set the print survey check box based on the active status of the case.
				l_dwCaseDetails.Object.case_log_snd_srvy_clsd.protect = l_nStatus
				l_dwCaseDetails.Object.case_log_snd_srvy_clsd.Background.Color = l_nColor
			END IF
		END IF
		
	CASE i_wParentWindow.i_cProactive
		IF l_dwCaseDetails.DataObject = "d_case_details_proactive" THEN
			l_dwCaseDetails.Object.case_log_case_priority.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_case_priority.Background.Color = l_nColor
			l_dwCaseDetails.Object.case_log_case_log_cntct_made.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_case_log_nmbr_atmpt_cnt.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_case_log_nmbr_atmpt_cnt.Background.Color = l_nColor
			l_dwCaseDetails.Object.case_log_case_log_ornt_cmplt.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_case_log_letter_sent.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_case_log_vdo_sent.protect = l_nStatus
			l_dwCaseDetails.Object.case_log_case_log_ado_sent.protect = l_nStatus
			l_dwCaseDetails.Object.optional_grouping_id.protect = l_nStatus
			l_dwCaseDetails.Object.optional_grouping_id.Background.Color = l_nColor
			l_dwCaseDetails.Object.case_log_case_log_dmgrphcs_vrfd.protect = l_nStatus
			l_dwCaseDetails.Object.confidentiality_level.protect = l_nStatus
			l_dwCaseDetails.Object.confidentiality_level.Background.Color = l_nColor
			
			// set contact made date field
			l_cValue = l_dwCaseDetails.GetItemString (1, "case_log_case_log_cntct_made")
			IF Upper (l_cValue) = 'Y' AND active THEN
				l_dwCaseDetails.Object.case_log_case_log_cntct_date.protect = l_nUnprotected
				l_dwCaseDetails.Object.case_log_case_log_cntct_date.Background.Color = l_nColorOn
			ELSE
				l_dwCaseDetails.Object.case_log_case_log_cntct_date.protect = l_nProtected
				l_dwCaseDetails.Object.case_log_case_log_cntct_date.Background.Color = l_nColorOff
			END IF
			
			// set orientation complete date field
			l_cValue = l_dwCaseDetails.GetItemString (1, "case_log_case_log_ornt_cmplt")
			IF Upper (l_cValue) = 'Y' AND active THEN
				l_dwCaseDetails.Object.case_log_case_log_ornt_cmplt_dt.protect = l_nUnprotected
				l_dwCaseDetails.Object.case_log_case_log_ornt_cmplt_dt.Background.Color = l_nColorOn
			ELSE
				l_dwCaseDetails.Object.case_log_case_log_ornt_cmplt_dt.protect = l_nProtected
				l_dwCaseDetails.Object.case_log_case_log_ornt_cmplt_dt.Background.Color = l_nColorOff
			END IF
			
			// set letter sent date field
			l_cValue = l_dwCaseDetails.GetItemString (1, "case_log_case_log_letter_sent")
			IF Upper (l_cValue) = 'Y' AND active THEN
				l_dwCaseDetails.Object.case_log_case_log_letter_sent_dt.protect = l_nUnprotected
				l_dwCaseDetails.Object.case_log_case_log_letter_sent_dt.Background.Color = l_nColorOn
			ELSE
				l_dwCaseDetails.Object.case_log_case_log_letter_sent_dt.protect = l_nProtected
				l_dwCaseDetails.Object.case_log_case_log_letter_sent_dt.Background.Color = l_nColorOff
			END IF
			
			// set audio sent date field
			l_cValue = l_dwCaseDetails.GetItemString (1, "case_log_case_log_ado_sent")
			IF Upper (l_cValue) = 'Y' AND active THEN
				l_dwCaseDetails.Object.case_log_case_log_ado_sent_dt.protect = l_nUnprotected
				l_dwCaseDetails.Object.case_log_case_log_ado_sent_dt.Background.Color = l_nColorOn
			ELSE
				l_dwCaseDetails.Object.case_log_case_log_ado_sent_dt.protect = l_nProtected
				l_dwCaseDetails.Object.case_log_case_log_ado_sent_dt.Background.Color = l_nColorOff
			END IF
			
			// set video sent date field
			l_cValue = l_dwCaseDetails.GetItemString (1, "case_log_case_log_vdo_sent")
			IF Upper (l_cValue) = 'Y' AND active THEN
				l_dwCaseDetails.Object.case_log_case_log_vdo_sent_dt.protect = l_nUnprotected
				l_dwCaseDetails.Object.case_log_case_log_vdo_sent_dt.Background.Color = l_nColorOn
			ELSE
				l_dwCaseDetails.Object.case_log_case_log_vdo_sent_dt.protect = l_nProtected
				l_dwCaseDetails.Object.case_log_case_log_vdo_sent_dt.Background.Color = l_nColorOff
			END IF
		END IF
		
END CHOOSE
end subroutine

public subroutine fu_setwindowtitle ();//*********************************************************************************************
//
//  Function: fu_SetWindowTitle
//  Purpose:  Update the window title while on the case tab
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/20/00 M. Caruso   Created.
//  04/09/01 C. Jackson  Correct window title
//  5/30/2002 K. Claver  Added code to add locked info to window title after save form, etc.
//  1/2/2003 K. Claver   Changed code to get the case status id from the datawindow rather than
//								 attempt to select from the case_log table as was causing blocks.
//	
//*********************************************************************************************

STRING	l_cCaseType, l_cSourceTypeDesc, l_cCaseStatus, l_cStatusDesc
STRING   l_cConcatSubject
TIME	lt_start_time

CHOOSE CASE i_wParentWindow.i_cSourceType
		CASE 'C'
			l_cSourceTypeDesc = 'Member'
		CASE 'E'
			l_cSourceTypeDesc = 'Group'
		CASE 'P'
			l_cSourceTypeDesc = 'Provider'
		CASE 'O'
			l_cSourceTypeDesc = 'Other'
	END CHOOSE

CHOOSE CASE i_wParentWindow.i_cCaseType
	CASE i_wParentWindow.i_cConfigCaseType
		l_cCaseType = gs_ConfigCaseType
		
	CASE i_wParentWindow.i_cInquiry
		l_cCaseType = 'Inquiry'
		
	CASE i_wParentWindow.i_cIssueConcern
		l_cCaseType = 'Issue/Concern'
		
	CASE i_wParentWindow.i_cProactive
		l_cCaseType = 'Proactive'
		
END CHOOSE

IF i_wParentWindow.i_cCurrentCase = '' THEN

	IF l_cSourceTypeDesc = 'Provider' THEN
		SELECT provider_id, vendor_id INTO :i_wParentWindow.i_cProviderID, :i_wParentWindow.i_cVendorID
		  FROM cusfocus.provider_of_service
		 WHERE provider_key = :i_wParentWindow.i_nProviderKey
		 USING SQLCA;
		 
		 IF ISNULL(i_wParentWindow.i_cProviderID) THEN
			IF NOT ISNULL(i_wParentWindow.i_cVendorID) THEN
				l_cConcatSubject = 'Vendor ID: '+i_wParentWindow.i_cVendorID
			END IF
		ELSE
			l_cConcatSubject = 'Provider ID: '+i_wParentWindow.i_cProviderID
			IF NOT ISNULL(i_wParentWindow.i_cVendorID) THEN
				l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_wParentWindow.i_cVendorID
			END IF
		END IF
		
		i_wParentWindow.Title = l_cSourceTypeDesc + ' - ' + l_cConcatSubject + ' - ' + &
			i_wParentWindow.i_cCaseSubjectName 
			
		ELSE
			
		i_wParentWindow.Title = l_cSourceTypeDesc + ' - ' + i_wParentWindow.i_cCurrentCaseSubject + ' - ' + &
			i_wParentWindow.i_cCaseSubjectName
			
		END IF
	
	
ELSE

	IF l_cSourceTypeDesc = 'Provider' THEN
		SELECT provider_id, vendor_id INTO :i_wParentWindow.i_cProviderID, :i_wParentWindow.i_cVendorID
		  FROM cusfocus.provider_of_service
		 WHERE provider_key = :i_wParentWindow.i_nProviderKey
		 USING SQLCA;
		 
		 IF ISNULL(i_wParentWindow.i_cProviderID) THEN
			IF NOT ISNULL(i_wParentWindow.i_cVendorID) THEN
				l_cConcatSubject = 'Vendor ID: '+i_wParentWindow.i_cVendorID
			END IF
		ELSE
			l_cConcatSubject = 'Provider ID: '+i_wParentWindow.i_cProviderID
			IF NOT ISNULL(i_wParentWindow.i_cVendorID) THEN
				l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_wParentWindow.i_cVendorID
			END IF
		END IF

			i_wParentWindow.Title = l_cSourceTypeDesc + ' - ' + l_cConcatSubject + ' - ' + &
				i_wParentWindow.i_cCaseSubjectName + ' - ' + i_wParentWindow.i_cCurrentCase 
										
		ELSE

			i_wParentWindow.Title = l_cSourceTypeDesc + ' - ' + i_wParentWindow.i_cCurrentCaseSubject + ' - ' + &
				i_wParentWindow.i_cCaseSubjectName + ' - ' + i_wParentWindow.i_cCurrentCase 
				
		END IF
			
	
//	SELECT case_status_id INTO :l_cCaseStatus FROM cusfocus.case_log 
//	WHERE case_number = :i_wParentWindow.i_cCurrentCase;

	//Get the case status from the case details datawindow.
	l_cCaseStatus = tab_folder.tabpage_case_details.dw_case_details.Object.case_log_case_status_id[ 1 ]
	
	CHOOSE CASE l_cCaseStatus
		CASE 'O'
			l_cStatusDesc = 'Open'
		CASE 'C'
			l_cStatusDesc = 'Closed'
		CASE 'V'
			l_cStatusDesc = 'Void'
	END CHOOSE
								
	IF l_cSourceTypeDesc = 'Provider' THEN
		SELECT provider_id, vendor_id INTO :i_wParentWindow.i_cProviderID, :i_wParentWindow.i_cVendorID
		  FROM cusfocus.provider_of_service
		 WHERE provider_key = :i_wParentWindow.i_nProviderKey
		 USING SQLCA;
		 
		 IF ISNULL(i_wParentWindow.i_cProviderID) THEN
			IF NOT ISNULL(i_wParentWindow.i_cVendorID) THEN
				l_cConcatSubject = 'Vendor ID: '+i_wParentWindow.i_cVendorID
			END IF
		ELSE
			l_cConcatSubject = 'Provider ID: '+i_wParentWindow.i_cProviderID
			IF NOT ISNULL(i_wParentWindow.i_cVendorID) THEN
				l_cConcatSubject = l_cConcatSubject + ' - ' + 'Vendor ID: '+i_wParentWindow.i_cVendorID
			END IF
		END IF

		i_wParentWindow.Title = l_cSourceTypeDesc + ' - ' + l_cConcatSubject + ' - ' + &
			i_wParentWindow.i_cCaseSubjectName + ' - ' + l_cCaseType + ' - ' + i_wParentWindow.i_cCurrentCase + &
			' - ' + l_cStatusDesc
			
	ELSE
			
		i_wParentWindow.Title = l_cSourceTypeDesc + ' - ' + i_wParentWindow.i_cCurrentCaseSubject + ' - ' + &
			i_wParentWindow.i_cCaseSubjectName + ' - ' + l_cCaseType + ' - ' + i_wParentWindow.i_cCurrentCase + &
			' - ' + l_cStatusDesc
			
	END IF
	
	IF THIS.i_wParentWindow.i_bCaseLocked THEN
		IF Pos( Upper( THIS.i_wParentWindow.Title ), "LOCKED BY" ) = 0 THEN
			//Add the locked by info to the window title
			THIS.i_wParentWindow.Title += " - Locked By "+THIS.i_wParentWindow.i_cLockedBy
		END IF
	END IF
END IF


end subroutine

public subroutine fu_reopencase ();//***********************************************************************************************
//
//  Function:   fu_reopencase
//  Purpose:    Reopen a closed case
//  Parameters: NONE
//  Returns:    NONE
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/05/00 M. Caruso   Created.
//  12/08/00 M. Caruso   Added code to set the current user as the case owner and to refresh the 
//                       Work Desk if it is open.
//  12/19/00 M. Caruso   Added last_closed_by parameter to l_sParms.
//  01/10/01 M. Caruso   Updated to use fu_savecase ().
//  01/14/01 M. Caruso   Added code to create a new case note after fu_savecase but before the 
//                       interface status is updated.
//  01/15/01 M. Caruso   Set validation parameter to FALSE in call to fu_savecase (). Also set 
//                       i_cCaseStatus to Open after case is saved.
//  04/25/01 C. Jackson  Set OtherCloseCode to null if re-opening
//  3/7/2002 K. Claver   Changed to notify the workdesk that it is ok to refresh rather
//								 than triggering a refresh
//***********************************************************************************************

STRING			l_cCommand, l_cKeyValue, l_cUserName, l_cNull
INT				l_nCounter
DATETIME			l_dtClosedDate
U_DW_STD			l_dwCaseDetails
S_REOPEN_PARMS	l_sParms

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details

l_sParms.case_number = l_dwCaseDetails.GetItemString (l_dwCaseDetails.i_CursorRow, &
															'case_log_case_number')
l_sParms.last_closed_by = l_dwCaseDetails.GetItemString (l_dwCaseDetails.i_CursorRow, &
															'case_log_updated_by')
l_sParms.last_closed = l_dwCaseDetails.GetItemDateTime (l_dwCaseDetails.i_CursorRow, &
															'case_log_case_log_clsd_date')

// log the reopen action and reason for reopening the case.
FWCA.MGR.fu_OpenWindow (w_reopen_case, l_sParms)

l_sParms = message.PowerObjectParm

// if the process was not cancelled/failed then continue
IF l_sParms.reopen = 'Y' THEN
	
	l_cKeyValue = l_sParms.log_id
	l_cUserName = OBJCA.WIN.fu_GetLogin (SQLCA)
	SetNull (l_dtClosedDate)
	SetNull (l_cNull)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'case_log_case_log_clsd_date', l_dtClosedDate)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'case_log_case_status_id', i_wParentWindow.i_cStatusOpen)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_case_log_case_rep', l_cUserName)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_updated_by', l_cUserName)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'case_log_updated_timestamp', i_wParentWindow.fw_GetTimeStamp ())
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'case_log_customer_sat_code_id', l_cNull)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'case_log_resolution_code_id', l_cNull)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'case_log_other_close_code_id', l_cNull)
	//Clear these even though they won't be saved
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'customer_sat_codes_customer_sat_desc', l_cNull)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'resolution_codes_resolution_desc', l_cNull)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, &
									 'other_close_codes_other_close_desc', l_cNull)
									 
	// now that the required information has been updated, save the changes.
	IF fu_savecase (l_dwCaseDetails.c_savechanges, FALSE) = 0 THEN
		
		i_cCaseStatus = i_wParentWindow.i_cStatusOpen
		fu_SetOpenCaseGUI ()
		dw_case_note_entry.fu_Reset (dw_case_note_entry.c_ignorechanges)
		dw_case_note_entry.fu_New (1)
		
		// Set to refresh the workdesk if it is open.
		IF IsValid (w_reminders) THEN	
			w_reminders.fw_SetOkRefresh( )
		END IF
		
	ELSE
		MessageBox (gs_appname, 'CustomerFocus was unable to update the status of the case.')
		
		// remove the log entry since the reopen failed.
		l_cCommand = 'BEGIN TRANSACTION'
		
		EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
		
		DELETE FROM cusfocus.reopen_log 
		 WHERE reopen_log_id = :l_cKeyValue
		 USING SQLCA;
		 
		IF SQLCA.SQLCode <> 0 THEN
			Messagebox(gs_appname, 'Unable to remove the reopen log entry. Contact your System Administrator.')
			l_cCommand = 'ROLLBACK TRANSACTION'
			EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
		ELSE
			l_cCommand = 'COMMIT TRANSACTION'
			EXECUTE IMMEDIATE :l_cCommand USING SQLCA;
		END IF

	END IF
	
END IF
end subroutine

public subroutine fu_copyxref (string a_clastcasenum);/*****************************************************************************************
   Function:   fu_CopyXref
   Purpose:    This function copies the current case cross ref to the next linked case
   Parameters: a_cLastCaseNum - The last case number saved
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	6/14/2001 K. Claver   Initial Version
	5/23/2002 K. Claver   Fixed to not attempt to copy the xref if a xref subject id is not
								 defined.
	05/31/02 C. Jackson   Corrected Xref code
*****************************************************************************************/
String l_cXrefSource, l_cXrefID, l_cXrefProviderType, l_cXrefCCSubject, l_cName, l_cName2
String l_cName3
Integer l_nCount
Long l_nXrefID
u_dw_std l_dwCaseDetails

IF NOT IsNull( a_cLastCaseNum ) AND Trim( a_cLastCaseNum ) <> "" THEN
	SELECT Count( * )
	INTO :l_nCount
	FROM cusfocus.case_log
	WHERE cusfocus.case_log.case_number = :a_cLastCaseNum
	USING SQLCA;
	
	IF l_nCount > 0 THEN
		//Get a reference to the case details datawindow
		l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details
		
		SELECT cusfocus.case_log.xref_source_type,
				 cusfocus.case_log.xref_subject_id,
				 cusfocus.case_log.xref_provider_type
		INTO :l_cXrefSource,
			  :l_cXrefID,
			  :l_cXrefProviderType
		FROM cusfocus.case_log
		WHERE cusfocus.case_log.case_number = :a_cLastCaseNum
		USING SQLCA;
		
		IF NOT IsNull( l_cXrefID ) AND Trim( l_cXrefID ) <> "" THEN
			IF l_dwCaseDetails.RowCount( ) > 0 THEN
				IF l_cXrefSource = 'P' THEN
				
					l_nXrefID = Long( l_cXrefID )
				
					SELECT provider_id, provid_name, provid_name_2 INTO :l_cXRefCCSubject, :l_cName, :l_cName2
					  FROM cusfocus.provider_of_service
					 WHERE provider_key = :l_nXRefID
					 USING SQLCA;
			
					 
					IF NOT ISNULL(l_cName2) AND Trim( l_cName2 ) <> "" THEN
						l_cName = l_cName + ', ' + l_cName2
						
					END IF
					
					l_dwCaseDetails.Object.cc_xref_subject_id[ 1 ] = l_cXRefCCSubject
					l_dwCaseDetails.Object.cc_xref_name[ 1 ] = l_cName
					
				ELSEIF l_cXrefSource = 'C' THEN
							
					SELECT consum_last_name, consum_first_name, consum_mi INTO :l_cName, :l_cName2, :l_cName3
					  FROM cusfocus.consumer
					 WHERE consumer_id = :l_cXRefID
					 USING SQLCA;
					 
					IF NOT ISNULL(l_cName2) AND Trim( l_cName2 ) <> "" THEN
						l_cName = l_cName + ', ' + l_cName2
					END IF
					
					IF NOT ISNULL(l_cName3) AND Trim( l_cName3 ) <> "" THEN
						l_cName = l_cName + ' ' + l_cName3
					END IF
					
					l_dwCaseDetails.Object.cc_xref_subject_id[ 1 ] = l_cXRefID
					l_dwCaseDetails.Object.cc_xref_name[ 1 ] = l_cName
					
				ELSEIF l_cXrefSource = 'E' THEN
					
					SELECT employ_group_name
					 INTO :l_cName
					  FROM cusfocus.employer_group
					 WHERE group_id = :l_cXRefID
					 USING SQLCA;
					 
					l_dwCaseDetails.Object.cc_xref_subject_id[ 1 ] = l_cXRefID
					l_dwCaseDetails.Object.cc_xref_name[ 1 ] = l_cName
				END IF
			


				l_dwCaseDetails.Object.case_log_xref_subject_id[ 1 ] = l_cXrefID
				l_dwCaseDetails.Object.case_log_xref_provider_type[ 1 ] = l_cXrefProviderType
				l_dwCaseDetails.Object.case_log_xref_source_type[ 1 ] = l_cXrefSource
			END IF
		END IF
	END IF
END IF


end subroutine

public subroutine fu_setlockedcasegui ();/*****************************************************************************************
   Function:   fu_SetLockedCaseGUI
   Purpose:    This function will set all GUI attributes for a locked case
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/8/2002 K. Claver    Created.
	04/17/02 M. Caruso    Removed references to the Inquiry Properties tab.
	04/22/02 M. Caruso    Call fu_SetTabGUI to set carve out tab button status.
	02/18/03 M. Caruso    Updated code to disable Note entry and category editing when the
								 case is locked.
	02/24/03 M. Caruso    Removed locking of Note entry.  This should be allowed.
*****************************************************************************************/

DATE					l_dClosed, l_dCurrent
U_DW_STD				l_dwCaseDetails, l_dwCaseProperties

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details
l_dwCaseProperties = tab_folder.tabpage_case_properties.dw_case_properties

// for all users the interface is locked down with the exception of adding notes, forms, attachments, etc.
l_dwCaseDetails.Enabled = FALSE
l_dwCaseDetails.ModifY("DataWindow.ReadOnly = Yes")
fu_SetCaseDetailGUI (FALSE)

l_dwCaseProperties.TriggerEvent( "ue_disable" )

// Disable the category tree view
tab_folder.tabpage_category.dw_categories.Enabled = FALSE

//Disable the carve out tabpage controls
IF IsValid( tab_folder.tabpage_carve_out ) THEN
	tab_folder.tabpage_carve_out.fu_SetTabGUI ()
END IF

//Disable the carve out tabpage controls
IF IsValid( tab_folder.tabpage_appeals ) THEN
	tab_folder.tabpage_appeals.of_set_locked_gui()
END IF

//Disable the case attachments controls
IF IsValid( tab_folder.tabpage_case_attachments ) THEN
	tab_folder.tabpage_case_attachments.fu_Disable( )
END IF

//Disable the case forms controls
IF IsValid( tab_folder.tabpage_case_forms ) THEN
	tab_folder.tabpage_case_forms.fu_Disable( )
END IF

m_create_maintain_case.m_file.m_save.Enabled 							= FALSE
m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 		= FALSE
m_create_maintain_case.m_edit.m_closecase.Enabled 						= FALSE
m_create_maintain_case.m_edit.m_voidcase.Enabled 						= FALSE
m_create_maintain_case.m_edit.m_changecasetype.Enabled 				= FALSE
m_create_maintain_case.m_file.m_transfercase.Enabled 					= FALSE
m_create_maintain_case.m_edit.m_financialcompensation.Enabled 		= FALSE
m_create_maintain_case.m_edit.m_reopencase.Enabled 					= FALSE

m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 		= TRUE
m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 		= TRUE
m_create_maintain_case.m_edit.m_contactperson.Enabled 				= TRUE

//Only allow to begin linking if the case isn't locked
m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 		= FALSE

IF Pos( Upper( THIS.i_wParentWindow.Title ), "LOCKED BY" ) = 0 THEN
	//Add the locked by info to the window title
	THIS.i_wParentWindow.Title += " - Locked By "+THIS.i_wParentWindow.i_cLockedBy
END IF
end subroutine

public subroutine fu_setclosedcasegui ();/*****************************************************************************************
   Function:   fu_SetClosedCaseGUI
   Purpose:    This function will set all GUI attributes for a closed case
   Parameters: NONE
   Returns:    INTEGER - 0 Success
								-1 Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/16/00 M. Caruso    Created.
	01/14/01 M. Caruso    Added code to set the status of view and print case detail
								 report menu items.
	07/26/01 M. Caruso    Removed code to control access to the category tree view.
	03/22/02 K. Claver    Added conditions to check if the case is locked by another user
								 before allowing controls to be enabled.
	04/17/02 M. Caruso    Removed references to the Inquiry Properties tab.
	04/22/02 M. Caruso    Call fu_SetTabGUI to set carve out tab button status.
	06/06/03 M. Caruso    Updated conditions for enabling the reopen case menu item.
*****************************************************************************************/

DATE								l_dClosed, l_dCurrent
U_DW_STD							l_dwCaseDetails, l_dwCaseProperties
U_TABPAGE_CASE_PROPERTIES	l_tpCaseProperties

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details
l_dwCaseProperties = tab_folder.tabpage_case_properties.dw_case_properties

//Enable fields if the user is a supervisor and the case isn't locked by another user
IF i_wParentWindow.i_bSupervisorRole AND NOT i_wParentWindow.i_bCaseLocked THEN
	// the supervisor role allows editing of closed cases.
	l_dwCaseDetails.Enabled = TRUE
	l_dwCaseDetails.ModifY ("DataWindow.ReadOnly = No")
	fu_SetCaseDetailGUI (TRUE)
	fu_EnableNoteEntry (TRUE)
	
	//-----------------------------------------------------------------------------------------------------------------------------------

	// JWhite 1/3/06 - Adding a check to enable the button if the user is in the "Edit Closed Case" role in the registry.
	//-----------------------------------------------------------------------------------------------------------------------------------

	If i_wParentWindow.i_bSupervisorRole = TRUE Then 
		tab_folder.tabpage_category.dw_categories.Enabled = TRUE
	Else 
		// disable the category tree view
		tab_folder.tabpage_category.dw_categories.Enabled = FALSE
	End If
	

	
	// determine if the case properties tab should be enabled
	l_tpCaseProperties = tab_folder.tabpage_case_properties
	IF l_tpCaseProperties.i_cCurrentView = l_tpCaseProperties.c_CurrentRB THEN
		l_dwCaseProperties.TriggerEvent( "ue_enable" )
	ELSE
		l_dwCaseProperties.TriggerEvent( "ue_disable" )
	END IF
	
	//Enable the carve out tabpage controls
	IF IsValid( tab_folder.tabpage_carve_out ) THEN
		tab_folder.tabpage_carve_out.fu_SetTabGUI ()
	END IF
	
	//Enable the case attachments controls
	IF IsValid( tab_folder.tabpage_case_attachments ) THEN
		tab_folder.tabpage_case_attachments.fu_Disable( )
	END IF
	
	//Enable the case forms controls
	IF IsValid( tab_folder.tabpage_case_forms ) THEN
		tab_folder.tabpage_case_forms.fu_Disable( )
	END IF
	
	m_create_maintain_case.m_file.m_save.Enabled 						= TRUE
	m_create_maintain_case.m_edit.m_contactperson.Enabled 			= TRUE
	m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 	= TRUE
	
ELSE
	// for all other users the interface is locked down.
	l_dwCaseDetails.Enabled = FALSE
	l_dwCaseDetails.ModifY("DataWindow.ReadOnly = Yes")

	fu_SetCaseDetailGUI (FALSE)
	
	// disable the category tree view
	tab_folder.tabpage_category.dw_categories.Enabled = FALSE
	
	// disable note entry
	fu_EnableNoteEntry (FALSE)
	
	// disable case properties editing
	l_dwCaseProperties.TriggerEvent( "ue_disable" )
	
	//Disable the carve out tabpage controls
	IF IsValid( tab_folder.tabpage_carve_out ) THEN
		tab_folder.tabpage_carve_out.fu_SetTabGUI ()
	END IF
	
	//Disable the case attachments controls
	IF IsValid( tab_folder.tabpage_case_attachments ) THEN
		tab_folder.tabpage_case_attachments.fu_Disable( )
	END IF
	
	//Disable the case forms controls
	IF IsValid( tab_folder.tabpage_case_forms ) THEN
		tab_folder.tabpage_case_forms.fu_Disable( )
	END IF
	
	m_create_maintain_case.m_file.m_save.Enabled 						= FALSE
	m_create_maintain_case.m_edit.m_contactperson.Enabled 			= FALSE
	m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 	= FALSE
	
END IF

m_create_maintain_case.m_edit.m_closecase.Enabled 						= FALSE
m_create_maintain_case.m_edit.m_voidcase.Enabled 						= FALSE
m_create_maintain_case.m_edit.m_changecasetype.Enabled 				= FALSE
m_create_maintain_case.m_file.m_transfercase.Enabled 					= FALSE
m_create_maintain_case.m_edit.m_financialcompensation.Enabled 		= FALSE

// set the reopen case button status
l_dClosed = DATE (l_dwCaseDetails.GetItemDateTime (1, 'case_log_case_log_clsd_date'))
l_dCurrent = DATE (i_wParentWindow.fw_GetTimeStamp ())

// Enable if after the reopen limit and the reopen limit > 0 or the case isn't locked by another user
IF ((i_nreopenlimit > 0 ) AND (DaysAfter (l_dClosed, l_dCurrent) > i_nreopenlimit)) OR i_wParentWindow.i_bCaseLocked THEN
	m_create_maintain_case.m_edit.m_reopencase.Enabled 				= FALSE
ELSE
	m_create_maintain_case.m_edit.m_reopencase.Enabled 				= TRUE
END IF

m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 		= TRUE
m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 		= TRUE

//Only allow to begin linking if the case isn't locked
IF i_wParentWindow.i_bCaseLocked THEN
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 		= FALSE
ELSE
	m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 		= TRUE
END IF

end subroutine

public subroutine fu_setopencasegui ();/*****************************************************************************************
   Function:   fu_SetOpenCaseGUI
   Purpose:    This function will set the application interface for an open case.
   Parameters: NONE
   Returns:    INTEGER - 0 Success
								-1 Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/16/00 M. Caruso    Created.
	11/22/2000 K. Claver  Added code to disable the case transfer option if the current user
								 isn't the current owner of the case.
	01/14/01 M. Caruso    Enable the change case type menu item if this is a saved Inquiry
								 case.  Added code for setting status of view and print case detail
								 report menu items.
	01/15/01 M. Caruso    If i_cSelectedCase <> '' THEN enable casedetailreport menu items.
	07/26/01 M. Caruso    Removed code to control access to the category tree view.
	04/17/02 M. Caruso    Removed references to the Inquiry Properties tab.  Also set the
								 enabled status of the Case Properties tab based on the selected
								 view.
	04/22/02 M. Caruso    Call fu_SetTabGUI to set carve out tab button status.
	02/14/03 M. Caruso    Added code to enable the category tree view control.
*****************************************************************************************/

STRING							l_cCaseRep, l_cUserID, l_cTakenBy
U_DW_STD							l_dwCaseDetails, l_dwCaseProperties
U_TABPAGE_CASE_PROPERTIES	l_tpCaseProperties

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details
l_dwCaseProperties = tab_folder.tabpage_case_properties.dw_case_properties
//l_tvCategories = tab_folder.tabpage_category.dw_categories
l_cUserID = OBJCA.WIN.fu_GetLogin( SQLCA )

l_dwCaseDetails.Enabled = TRUE
l_dwCaseDetails.ModifY("DataWindow.ReadOnly = No")
fu_SetCaseDetailGUI (TRUE)

// enable the category tree view if the case is new
CHOOSE CASE l_dwCaseDetails.GetItemStatus (l_dwCaseDetails.i_CursorRow, 0, Primary!)
	CASE New!, NewModified!
		//If it's new, current user is the case rep
		l_cCaseRep = l_cUserID
		l_cTakenBy = l_cUserID	
	CASE ELSE
				
		IF l_dwCaseDetails.RowCount( ) > 0 THEN
			//Only get the case rep if the case has been saved
			l_cCaseRep = l_dwCaseDetails.GetItemString( 1, 'case_log_case_log_case_rep' )
			l_cTakenBy = l_dwCaseDetails.GetItemString( 1, 'case_log_case_log_taken_by' )
			
		END IF
		
		//New case...case rep is the current user
		IF IsNull( l_cCaseRep ) OR Trim( l_cCaseRep ) = "" THEN
			l_cCaseRep = l_cUserID
		END IF
			
END CHOOSE

fu_EnableNoteEntry (TRUE)

// determine if the case properties tab should be enabled
l_tpCaseProperties = tab_folder.tabpage_case_properties
IF l_tpCaseProperties.i_cCurrentView = l_tpCaseProperties.c_CurrentRB THEN
	l_dwCaseProperties.TriggerEvent( "ue_enable" )
ELSE
	l_dwCaseProperties.TriggerEvent( "ue_disable" )
END IF

//Enable the categories tree view control
IF IsValid( tab_folder.tabpage_category) THEN
	tab_folder.tabpage_category.dw_categories.enabled = TRUE
END IF

//Enable the carve out tabpage controls
IF IsValid( tab_folder.tabpage_carve_out ) THEN
	tab_folder.tabpage_carve_out.fu_SetTabGUI ()
END IF

//Enable the case attachments controls
IF IsValid( tab_folder.tabpage_case_attachments ) THEN
	tab_folder.tabpage_case_attachments.fu_Disable( )
END IF

//Enable the case forms controls
IF IsValid( tab_folder.tabpage_case_forms ) THEN
	tab_folder.tabpage_case_forms.fu_Disable( )
END IF

// set the status of the close case menu item
IF fu_AllowedToClose () THEN
	m_create_maintain_case.m_edit.m_closecase.Enabled 					= TRUE
ELSE
	m_create_maintain_case.m_edit.m_closecase.Enabled 					= FALSE
END IF

m_create_maintain_case.m_edit.m_reopencase.Enabled 					= FALSE
m_create_maintain_case.m_edit.m_voidcase.Enabled 						= TRUE
m_create_maintain_case.m_file.m_save.Enabled 							= TRUE

// If this is an existing Inquiry case, enable the m_changecasetype menu item.
IF i_wParentWindow.i_cCaseType = i_wParentWindow.i_cInquiry AND i_wParentWindow.i_cSelectedCase <> '' THEN
	m_create_maintain_case.m_edit.m_changecasetype.Enabled = TRUE
ELSE
	m_create_maintain_case.m_edit.m_changecasetype.Enabled = FALSE
END IF

// If there is No Case Subject or the case hasn't been saved, there can not be a Contact Person.
IF Trim( i_wParentWindow.i_cCurrentCaseSubject ) = '' OR IsNull( i_wParentWindow.i_cCurrentCase ) OR &
	Trim( i_wParentWindow.i_cCurrentCase ) = "" THEN
	m_create_maintain_case.m_edit.m_contactperson.Enabled 			= FALSE
ELSE
	m_create_maintain_case.m_edit.m_contactperson.Enabled 			= TRUE
END IF

//------------------------------------------------------------------------
//    Only existing cases can be transfered and can have Case Reminders 
//		and Correspondence and can only append comments.
//------------------------------------------------------------------------
IF i_wParentWindow.i_cSelectedCase <> '' THEN
	
	IF i_wParentWindow.i_cSourceType = i_wParentWindow.i_cSourceOther THEN
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled = TRUE
	ELSE
		m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled = FALSE
	END IF
	
	//If the current user isn't the case owner, disable the case transfer button
	//Added logic to enable it if the case is in a work queue
	STRING ls_work_queue

	SELECT cusfocus.cusfocus_user_dept.work_queue
	INTO :ls_work_queue
	FROM cusfocus.cusfocus_user_dept, cusfocus.cusfocus_user
	WHERE cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id
	AND cusfocus.cusfocus_user.user_id = :l_cCaseRep
	USING SQLCA;
	
	IF Upper( l_cCaseRep ) <> Upper( l_cUserID ) AND &
	   Upper( l_cTakenBy ) <> Upper( l_cUserID ) AND &
	   ls_work_queue <> 'Y' THEN
		m_create_maintain_case.m_file.m_transfercase.Enabled 				= FALSE
	ELSE
		m_create_maintain_case.m_file.m_transfercase.Enabled 				= TRUE
	END IF
	
	m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 		= TRUE
	m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 		= TRUE
	
ELSE
	
	m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 		= FALSE
	m_create_maintain_case.m_file.m_transfercase.Enabled 					= FALSE
	m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 		= FALSE
	m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 		= FALSE
	
END IF

// this functionality is currently not in use, so this stays disabled.
m_create_maintain_case.m_edit.m_financialcompensation.Enabled 		= FALSE

m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled 		= TRUE
end subroutine

public function integer fu_newcase ();/*****************************************************************************************
   Function:   fu_NewCase
   Purpose:    Provide a standard function call for creating a new case.
   Parameters: NONE
   Returns:    INTEGER -	c_Success:	The function succeeded.
									c_Fatal:		The function failed.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/12/01 M. Caruso    Created.
	01/13/01 M. Caruso    Disable view- and printcasedetailreport menu items.
	01/14/01 M. Caruso    Call fu_setOpenCaseGUI to update the interface.
	02/23/01 M. Caruso    Call fu_EnableCarveOut () to manage the carve out tab.
	6/13/2001 K. Claver   Added code to store the prior source type and case type to determine
								 if should copy the properties from the prior case to the new case
								 for case linking.
	6/25/2001 K. Claver   Commented code that set the link master case number prior to creating
								 a new case.
	06/17/03 M. Caruso    Added check of the option setting before copying case properties
								 for a new linked case.
*****************************************************************************************/

INTEGER						l_nStatus, l_nReturn
U_TABPAGE_CASE_DETAILS	l_tpCaseDetails
U_DW_STD						l_dwCaseDetails
String						l_cLinkLastCaseType, l_cLinkLastSourceType, l_cLinkLastCase

// create a reference to the case details datawindow
l_tpCaseDetails = tab_folder.tabpage_case_details
l_dwCaseDetails = l_tpCaseDetails.dw_case_details

// try to save the case, prompting the user if changes exist.
IF l_dwCaseDetails.RowCount () > 0 THEN	
//	If there is an open correspondence, don't let them change cases
//	IF IsValid (i_wParentWindow.i_uoCaseCorrespondence) THEN
//		IF IsValid(i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr) THEN
//			IF IsValid(i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr.i_wDocWindow) THEN
//				MessageBox (gs_appname, 'Cannot open a new case while a correspondence document is being edited.')
//				RETURN l_dwCaseDetails.c_fatal
//			END IF
//		END IF
//	END IF
	l_nReturn = fu_SaveCase (l_dwCaseDetails.c_PromptChanges)
	
ELSE
	l_nReturn = l_dwCaseDetails.c_Success
END IF

// if the save process fails, abort further new case processing.
IF l_nReturn = l_dwCaseDetails.c_Fatal THEN RETURN l_nReturn

//Set the change case type indicator to false as this is a new case
THIS.i_bChangeCaseType = FALSE

// otherwise, prep for a new case
CHOOSE CASE i_wParentWindow.i_cCaseType
	CASE i_wParentWindow.i_cInquiry, i_wParentWindow.i_cIssueConcern, i_wParentWindow.i_cConfigCaseType
		IF l_dwCaseDetails.dataobject <> "d_case_details" THEN
			l_dwCaseDetails.fu_swap ("d_case_details", &
											l_dwCaseDetails.c_ignorechanges, &
											l_tpCaseDetails.i_cOptionList )
		END IF
		
	CASE i_wParentWindow.i_cProactive
		IF l_dwCaseDetails.dataobject <> "d_case_details_proactive" THEN
			l_dwCaseDetails.fu_swap ("d_case_details_proactive", &
											l_dwCaseDetails.c_ignorechanges, &
											l_tpCaseDetails.i_cOptionList )
		END IF
		
END CHOOSE

l_dwCaseDetails.fu_Reset (l_dwCaseDetails.c_IgnoreChanges)
IF l_dwCaseDetails.fu_New (1) = 0 THEN
	
	// Reset the Cross Reference instance variable, if it was populated from a previous case
	SetNull(l_tpCaseDetails.i_cXRefCCSubject)

	fu_SetOpenCaseGUI ()
	
	//Disable the close case button for new cases.
	m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
	
	fu_EnableCarveOut ()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 9.2.2004 - Added the call the check to see if the Appeals tab should be shown.
	//-----------------------------------------------------------------------------------------------------------------------------------
	of_enable_appeals()
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// RAP Added 10.27.2008 - Added the call the check to see if the Eligibility tab should be shown.
	//-----------------------------------------------------------------------------------------------------------------------------------
	of_enable_eligibility()
	
	i_wParentWindow.dw_folder.fu_DisableTab(7)
	i_wParentWindow.dw_folder.fu_DisableTab(8)
	
	//Only copy case properties if same case type and source type.
	IF ( NOT IsNull( i_wParentWindow.i_cLinkLastSourceType ) AND Trim( i_wParentWindow.i_cLinkLastSourceType ) <> "" AND &
		i_wParentWindow.i_cLinkLastSourceType = i_wParentWindow.i_cSourceType ) AND &
		( NOT IsNull( i_wParentWindow.i_cLinkLastCaseType ) AND Trim( i_wParentWindow.i_cLinkLastCaseType ) <> "" AND &
		i_wParentWindow.i_cLinkLastCaseType = i_wParentWindow.i_cCaseType ) AND &
		i_wParentWindow.i_bLinked THEN
		
		IF i_bCopyProperties THEN
			// Copy the case properties if the option is set.
			THIS.fu_CopyProps( i_wParentWindow.i_cLinkMasterCase, i_wParentWindow.i_cLinkLastCaseType, i_wParentWindow.i_cLinkLastSourceType )
		END IF
		
	END IF
	
	//Span case types but not source types for inheritance of xref values
	IF ( NOT IsNull( i_wParentWindow.i_cLinkLastSourceType ) AND Trim( i_wParentWindow.i_cLinkLastSourceType ) <> "" AND &
		i_wParentWindow.i_cLinkLastSourceType = i_wParentWindow.i_cSourceType ) AND &
		i_wParentWindow.i_cCaseType <> i_wParentWindow.i_cProactive AND &
		i_wParentWindow.i_bLinked THEN
		
		//Copy the cross ref values
		THIS.fu_CopyXref( i_wParentWindow.i_cLinkMasterCase )		
	END IF
	
	dw_case_note_entry.SetFocus ()
	
	//Refresh the workdesk if open
	IF IsValid( w_reminders ) THEN
		w_reminders.fw_SetOkRefresh( )
	END IF

	RETURN c_Success
	
ELSE
	
	RETURN c_Fatal
	
END IF
end function

public subroutine fu_setvoidedcasegui ();/*****************************************************************************************
   Function:   fu_SetVoidedCaseGUI
   Purpose:    this function will set the application interface for a voided case.
   Parameters: NONE
   Returns:    INTEGER - 0 Success
								-1 Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/16/00 M. Caruso    Created.
	01/14/00 M. Caruso    Added code to enable the view and print case detail report menu
								 items.
	4/27/2001 K. Claver   Added function call to disable the carve out entry controls.
	07/26/01 M. Caruso    Removed code to control access to the category tree view.
	04/17/02 M. Caruso    Removed references to Inquiry Properties tab.
	04/22/02 M. Caruso    Call fu_SetTabGUI to set carve out tab button status.
	06/16/03 M. Caruso    Disable the category tree view when the case is voided.
*****************************************************************************************/

U_DW_STD				l_dwCaseDetails, l_dwCaseProperties
//U_OUTLINER			l_tvCategories

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details
l_dwCaseProperties = tab_folder.tabpage_case_properties.dw_case_properties
//l_tvCategories = tab_folder.tabpage_category.dw_categories

l_dwCaseDetails.Enabled = FALSE
l_dwCaseDetails.ModifY("DataWindow.ReadOnly = Yes")
fu_SetCaseDetailGUI (FALSE)
fu_EnableNoteEntry (FALSE)

l_dwCaseProperties.TriggerEvent( "ue_disable" )

//Disable the carve out tabpage controls
IF IsValid( tab_folder.tabpage_carve_out ) THEN
	tab_folder.tabpage_carve_out.fu_SetTabGUI ()
END IF

//Disable the case attachments controls
IF IsValid( tab_folder.tabpage_case_attachments ) THEN
	tab_folder.tabpage_case_attachments.fu_Disable( )
END IF

//Disable the case forms controls
IF IsValid( tab_folder.tabpage_case_forms ) THEN
	tab_folder.tabpage_case_forms.fu_Disable( )
END IF

//Disable the category tree view
tab_folder.tabpage_category.dw_categories.Enabled = FALSE

m_create_maintain_case.m_edit.m_closecase.Enabled 						= FALSE
m_create_maintain_case.m_edit.m_reopencase.Enabled 					= FALSE
m_create_maintain_case.m_edit.m_voidcase.Enabled 						= FALSE
m_create_maintain_case.m_edit.m_changecasetype.Enabled 				= FALSE
m_create_maintain_case.m_file.m_save.Enabled 							= FALSE
m_create_maintain_case.m_edit.m_contactperson.Enabled 				= FALSE
m_create_maintain_case.m_edit.m_reassigncasesubject.Enabled 		= FALSE
m_create_maintain_case.m_file.m_transfercase.Enabled 					= FALSE
m_create_maintain_case.m_file.m_newcase.m_linkedcase.Enabled      = FALSE
m_create_maintain_case.m_edit.m_financialcompensation.Enabled 		= FALSE
m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled 		= TRUE
m_create_maintain_case.m_file.m_printcasedetailreport.Enabled 		= TRUE
end subroutine

public function integer fu_opencase ();/*****************************************************************************************
   Function:   fu_OpenCase
   Purpose:    PRovide a single function for loading existing cases
   Parameters: NONE
   Returns:    INTEGER -	c_Success:	Process succeeded.
									c_Fatal:		Process failed.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/12/01 M. Caruso    Created.
	01/13/01 M. Caruso    Corrected check of fu_retrieve status so case note entry refresh
								 would work.  Enable or disable the casedetailreport menu items
								 based on the result of the case retrieval.
	01/14/01 M. Caruso    Only retrieve a case is the current case has changed and call the
								 fu_Set<Status>CaseGUI functions to update the interface.
	01/18/01 M. Caruso    Call fu_SetWindowTitle () if the current case has not changed.
	03/23/01 M. Caruso    Call fu_EnableCarveOut () to manage the carve out tab.
	04/17/01 K. Claver    Added code to set the change case type indicator back to false
								 as this is a new case.
	03/12/02 K. Claver    Added code to lock down the gui or set the lock on the case.
	04/24/02 M. Caruso    SetFocus to the case_priority column whether a new case is loaded
								 or not.
	09/01/2004 K. Claver  Added code to rebuild the case properties tabpage datawindow when
								 a case is opened, even if it is not a new case.  This allows for
								 an Inquiry changed to Issue/Concern, but not saved when switch from
								 Case tab to Case History tab and back.
	09/02/2004 K. Claver  Added line of code to reset the boolean instance variable that allows
								 or disallows the case locked message to appear.
*****************************************************************************************/

STRING						l_cPreviousCase
U_TABPAGE_CASE_DETAILS	l_tpCaseDetails
U_TABPAGE_CATEGORY		l_tpCategories
U_TABPAGE_CASE_PROPERTIES l_tpCaseProps
U_DW_STD						l_dwCaseDetails

// set tab page references
l_tpCaseDetails = tab_folder.tabpage_case_details
l_tpCategories = tab_folder.tabpage_category
l_dwCaseDetails = l_tpCaseDetails.dw_case_details

IF i_wParentWindow.i_cSelectedCase <> i_wParentWindow.i_cCurrentCase THEN
//	If there is an open correspondence, don't let them change cases
//	IF IsValid (i_wParentWindow.i_uoCaseCorrespondence) THEN
//		IF IsValid(i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr) THEN
//			IF IsValid(i_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr.i_wDocWindow) THEN
//				MessageBox (gs_appname, 'Cannot switch to a different case while a correspondence document is being edited.')
//				RETURN c_fatal
//			END IF
//		END IF
//	END IF
	//Reset the locked message flag so will show message if case is locked
	l_tpCaseDetails.i_bLockedCaseMessageDisplayed = FALSE

	// set the case details datawindow according to the case type
	CHOOSE CASE i_wParentWindow.i_cCaseType
		CASE i_wParentWindow.i_cConfigCaseType, i_wParentWindow.i_cInquiry, i_wParentWindow.i_cIssueConcern
			IF l_dwCaseDetails.dataobject = "d_case_details_proactive" THEN
				l_dwCaseDetails.fu_swap ("d_case_details", l_dwCaseDetails.c_IgnoreChanges, &
													l_tpCaseDetails.i_cOptionList )
			END IF
			
		CASE i_wParentWindow.i_cProactive
			IF l_dwCaseDetails.dataobject = "d_case_details" THEN
				l_dwCaseDetails.fu_swap ("d_case_details_proactive", l_dwCaseDetails.c_IgnoreChanges, &
													l_tpCaseDetails.i_cOptionList )
			END IF
			
	END CHOOSE
	
	l_dwCaseDetails.fu_retrieve (l_dwCaseDetails.c_IgnoreChanges, l_dwCaseDetails.c_NoReselectRows)
	
	dw_case_note_entry.fu_reset (dw_case_note_entry.c_ignorechanges)
	dw_case_note_entry.fu_New (1)
	
ELSE
	fu_SetWindowTitle ()
END IF

l_dwCaseDetails.SetColumn ('case_log_case_priority')

//Lock the current case, if there is a current case
IF NOT IsNull( THIS.i_wParentWindow.i_cCurrentCase ) AND Trim( THIS.i_wParentWindow.i_cCurrentCase ) <> "" THEN
	IF NOT THIS.i_wParentWindow.i_bCaseLocked THEN
		tab_folder.tabpage_case_details.fu_LockCase( )
	ELSE
		//If locked by someone else, lock down the datawindows and controls
		THIS.fu_SetLockedCaseGUI( )
	END IF
END IF

CHOOSE CASE i_cCaseStatus
	CASE i_wParentWindow.i_cStatusOpen
		IF NOT i_wParentWindow.i_bCaseLocked THEN
			fu_SetOpenCaseGUI ()
		END IF
		
	CASE i_wParentWindow.i_cStatusClosed
		fu_SetClosedCaseGUI ()
		
	CASE i_wParentWindow.i_cStatusVoid
		fu_SetVoidedCaseGUI ()
		
END CHOOSE

//Build the Case Properties tab datawindow
l_tpCaseProps = tab_folder.tabpage_case_properties
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
	l_tpCaseProps.dw_case_properties.fu_SetOptions (SQLCA, l_tpCaseProps.dw_case_properties.c_NullDW, l_tpCaseProps.i_cCasePropsOptions)
	
END IF
l_tpCaseProps.dw_case_properties.fu_retrieve (l_tpCaseProps.dw_case_properties.c_IgnoreChanges, l_tpCaseProps.dw_case_properties.c_NoReselectRows)
l_tpCaseProps.fu_SetViewAvailability ()
l_tpCaseProps.rb_Current.Checked = TRUE
l_tpCaseProps.rb_Inquiry.Checked = FALSE
l_tpCaseProps.rb_Other.Checked = FALSE

fu_EnableCarveOut ()

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 9.2.2004 - Added the call the check to see if the Appeals tab should be shown.
//-----------------------------------------------------------------------------------------------------------------------------------
of_enable_appeals()

//-----------------------------------------------------------------------------------------------------------------------------------
// RAP Added 10.27.2008 - Added the call the check to see if the Eligibility tab should be shown.
//-----------------------------------------------------------------------------------------------------------------------------------
of_enable_eligibility()
	
//Ensure that the change case type indicator is set back to false as we're on a different
//  case
THIS.i_bChangeCaseType = FALSE

RETURN c_Success
end function

public subroutine fu_changecasetype ();/*****************************************************************************************
   Function:   fu_ChangeCaseType
   Purpose:    Change an the case type for the open case.
   Parameters: NONE
	Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/06/00 M. Caruso    Created.
	12/12/00 M. Caruso    Removed the save function.  Added code to clear the current
								 selected category info and prompt to set a new category.  Also
								 update the category tab to display the categories of the new case
								 type.
	12/28/00 M. Caruso    Added call to fu_SetWindowTitle.
	01/12/01 M. Caruso    Be sure to DISABLE the change type button when the type changes!
								 Also, display the Inquiry Properties tab when done.
	04/13/01 K. Claver    Fixed to switch to tab six for categories.
	01/15/02 K. Claver    Fixed to switch to tab eight for categories.
	03/18/02 M. Caruso    Set the incident date before setting the reported date.
	04/17/02 M. Caruso    Removed references to the Inquiry Properties tab.  Activate the
								 Inquiry view radio button.
*****************************************************************************************/

INTEGER	l_nRtn
STRING	l_cTitle, l_cPrompt, l_cNull
U_DW_STD	l_dwCaseDetails, l_dwCaseProperties
U_TABPAGE_CASE_PROPERTIES	l_tpCaseProps, l_tpInqCaseProps

l_cTitle = 'Change Inquiry to Issue/Concern'
l_cPrompt = 'Are you sure you wish to make this an Issue/Concern case? You ' + &
				'must enter a new category if you continue.'

SetNull (l_cNull)

l_nRtn = MessageBox (l_cTitle, l_cPrompt, StopSign!, YesNo!)
IF l_nRtn = 1 THEN
	
	m_create_maintain_case.m_edit.m_changecasetype.enabled = FALSE
	
	l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details
	
	l_dwCaseDetails.SetRedraw (FALSE)
	
	// update the datawindow fields
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_case_type', &
									 i_wParentWindow.i_cIssueConcern)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_incdnt_date', &
									 i_wparentwindow.fw_gettimestamp())
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_rprtd_date', &
									 i_wparentwindow.fw_gettimestamp())
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'confidentiality_level', 1)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_root_category_name', l_cNull)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'categories_category_name', l_cNull)
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_category_id', l_cNull)
	
	// reset the selected category variable to make sure validation picks this up later.
	i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory = ''
	
	// change the case type
	i_wParentWindow.i_cCaseType = i_wParentWindow.i_cIssueConcern
	
	// update the category list for the new case type and prompt for reselection
	tab_folder.tabpage_category.of_defineview (i_wParentWindow.i_cCaseType)
	tab_folder.tabpage_category.dw_categories.Enabled = TRUE
	tab_folder.SelectTab (8)
	
	//Change the case type and re-retrieve the case properties datawindow.  If 
	//  there are changes, will prompt to save first.
	l_tpCaseProps = tab_folder.tabpage_case_properties
	l_dwCaseProperties = l_tpCaseProps.dw_case_properties
	l_tpCaseProps.i_cSourceType = i_wParentWindow.i_cSourceType
	l_tpCaseProps.i_cCaseType = i_wParentWindow.i_cIssueConcern
	// this code refreshes the datawindow object to accept the new field list
	l_dwCaseProperties.DataObject = 'd_case_properties'
	l_tpCaseProps.fu_BuildFieldList ()
	l_tpCaseProps.fu_DisplayFields ()
	l_dwCaseProperties.fu_InitOptions ()
	l_dwCaseProperties.fu_SetOptions (SQLCA, l_dwCaseProperties.c_NullDW, l_tpCaseProps.i_cCasePropsOptions)
	l_dwCaseProperties.fu_Reset (l_dwCaseProperties.c_IgnoreChanges)
	l_dwCaseProperties.fu_New (1)
	
	// update the interface
	l_tpCaseProps.rb_Inquiry.Enabled = TRUE
	fu_SetCaseDetailGUI (TRUE)
	fu_SetWindowTitle ()
	
	l_dwCaseDetails.SetRedraw (TRUE)
	
	//Set the change case type indicator for updates to carve out entries later
	THIS.i_bChangeCaseType = TRUE

	//tab_folder.SelectTab (8)
	long ll_return
	ll_return = tab_folder.SelectTab(tab_folder.tabpage_category)
	tab_folder.tabpage_category.dw_categories.SetFocus( )
	
	ib_converted_casetype = TRUE

END IF
end subroutine

public function integer fu_checkrequiredproperties ();/*****************************************************************************************
   Function:   fu_CheckRequiredProperties
   Purpose:    Report an error if required case properties are not filled in.
   Parameters: NONE
   Returns:     0 - All required fields are filled.
					-1 - A required field was not filled.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/25/03 M. Caruso    Created.
*****************************************************************************************/
INTEGER	l_nColCount, l_nIndex, l_nOriginalCol, l_nRtn
STRING	l_cFieldText, l_ErrorStrings[], l_cFieldName, l_cColName, ls_return
U_DW_STD	l_dwProperties

l_dwProperties = tab_folder.tabpage_case_properties.dw_case_properties

// make sure all values are set.
l_dwProperties.AcceptText()

// default to 0
l_nRtn = 0

// get the current column in the datawindow
l_nOriginalCol = l_dwProperties.GetColumn()
l_nColCount = INTEGER (l_dwProperties.Object.DataWindow.Column.Count)
FOR l_nIndex = 1 TO l_nColCount
	IF l_dwProperties.Describe ('#' + STRING (l_nIndex) + '.Edit.Required') = 'yes' OR l_dwProperties.Describe ('#' + STRING (l_nIndex) + '.dddw.required') = 'yes' THEN
		IF l_dwProperties.Describe ('#' + STRING (l_nIndex) + '.Protect') = '0' THEN // If it is protected, the user can't change it anyhow
			l_dwProperties.SetColumn (l_nIndex)
			l_cFieldText = l_dwProperties.GetText()
			IF Len(l_cFieldText) = 0 OR IsNull (l_cFieldText) THEN
				
				l_cColName = l_dwProperties.GetColumnName()
				l_cFieldName = l_dwProperties.Describe (l_cColName + '_t.Text')
				// report the error on this field
				MessageBox(FWCA.MGR.i_ApplicationName, l_cFieldName + ' is a required field.')
				
				// set the return value and exit this loop
				l_nRtn = -1
				EXIT
			END IF
		END IF
	END IF
	
NEXT

// restore focus to the originially selected column
l_dwProperties.SetColumn (l_nOriginalCol)

RETURN l_nRtn
end function

public function integer fu_addcustomerstmt (u_dw_std a_dwsource);/*****************************************************************************************
   Function:   fu_addcustomerstmt
   Purpose:    Add a case remark with date, time and user stamps
   Parameters: U_DW_STD	a_dwSource - The source datawindow
	Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/24/00  M. Caruso    Created.
	5/2/2001 K. Claver    Enhanced to use the field formats defined for the IIM tab.
	5/29/2001 K. Claver   Changed to not add fields that are invisible.  Also added code to
								 use the column name in place of the label if there is no label.
	12/14/2001 K. Claver  Fixed to make sure all of the datatypes in the choose-case for the
								 column type are limited to four characters in length.  This is
								 necessary as CHAR and DECIMAL incorporate a precision property
								 (ie. char(10)).
*****************************************************************************************/

STRING			l_cRemarks, l_cOldComments, l_cNewComments, l_cTitle
STRING			l_cColName, l_cLabel, l_cNewText, l_cFormat, l_cVisible
LONG				l_nRow
INTEGER			l_nCol, l_nColCount, l_nRV = -1, l_nNewText, l_nCommentLen
DATETIME			l_dtTimeStamp, l_dtNewText
Date				l_dNewText
Decimal			l_dcNewText
Time				l_tNewText
U_IIM_TAB_PAGE	l_uPage

IF a_dwSource.RowCount( ) > 0 THEN
	// build the text of the new case remark to be added
	IF dw_case_note_entry.Object.note_text.Protect = "0" THEN
		IF IsValid( w_iim_tabs ) THEN
			l_uPage = w_iim_tabs.tab_folder.Control[w_iim_tabs.tab_folder.SelectedTab]
			l_cNewComments = "[" + l_uPage.text + " Reference]~r~n"
			l_nCommentLen = Len( l_cNewComments )
			l_nRow = a_dwSource.GetRow ()
			l_nColCount = INTEGER (a_dwSource.Object.Datawindow.Column.Count)
			FOR l_nCol = 1 TO l_nColCount
				l_cVisible = a_dwSource.Describe ("#" + STRING (l_nCol) + ".Visible")
				IF l_cVisible = "1" THEN
					l_cColName = a_dwSource.Describe ("#" + STRING (l_nCol) + ".name")
					l_cLabel = a_dwSource.Describe (l_cColName + "_t.Text")
					
					IF l_cLabel = "!" THEN
						//Set the label to the column
						l_cLabel = l_cColName
						//Replace "." with " "
						f_StringReplaceAll( l_cLabel, ".", " " )
						//Replace "_" with " "
						f_StringReplaceAll( l_cLabel, "_", " " )
						//Capitalize the first letter of each word
						l_cLabel = f_WordCap( l_cLabel )
					END IF
					
					IF l_nCol > 1 THEN l_cNewComments += ", "
					
					//Need to check the first four characters of the column type as CHAR and DECIMAL both
					//  incorporate a precision property(ie. char(10)).
					CHOOSE CASE Trim( Upper( Left( a_dwSource.Describe( "#"+String( l_nCol )+".ColType" ), 4 ) ) )
						CASE "CHAR"
							l_cNewText = a_dwSource.GetItemString (l_nRow, l_nCol)
							
							l_cFormat = Upper( a_dwSource.Describe( "#"+String( l_nCol )+".Format" ) )
							IF l_cFormat <> "[GENERAL]" THEN
								l_cNewText = String( l_cNewText, l_cFormat )
							END IF
							
						CASE "DATE"
							//Date and datetime
							IF Upper (a_dwSource.Describe ("#" + STRING (l_nCol) + ".ColType")) = "DATE" THEN
								l_dNewText = a_dwSource.GetItemDate (l_nRow, l_nCol)
								
								l_cFormat = Upper( a_dwSource.Describe( "#"+String( l_nCol )+".Format" ) )
								IF l_cFormat <> "[GENERAL]" THEN
									l_cNewText = String( l_dNewText, l_cFormat )
								ELSE
									l_cNewText = String( l_dNewText, "mm/dd/yyyy" )
								END IF
							ELSE
								l_dtNewText = a_dwSource.GetItemDateTime (l_nRow, l_nCol)
								
								l_cFormat = Upper( a_dwSource.Describe( "#"+String( l_nCol )+".Format" ) )
								IF l_cFormat <> "[GENERAL]" THEN
									l_cNewText = String( l_dtNewText, l_cFormat )
								ELSE
									l_cNewText = String( l_dtNewText, "mm/dd/yyyy hh:mm:ss" )
								END IF							
							END IF
							
						CASE "DECI"
							l_dcNewText = a_dwSource.GetItemDecimal (l_nRow, l_nCol)
							
							l_cFormat = Upper( a_dwSource.Describe( "#"+String( l_nCol )+".Format" ) )
							IF l_cFormat <> "[GENERAL]" THEN
								l_cNewText = String( l_dcNewText, l_cFormat )
							ELSE
								l_cNewText = String( l_dcNewText )
							END IF
							
						CASE "INT","LONG","NUMB","REAL","ULON"
							//All numbers but decimal
							l_nNewText = a_dwSource.GetItemNumber (l_nRow, l_nCol)
							
							l_cFormat = Upper( a_dwSource.Describe( "#"+String( l_nCol )+".Format" ) )
							IF l_cFormat <> "[GENERAL]" THEN
								l_cNewText = String( l_nNewText, l_cFormat )
							ELSE
								l_cNewText = String( l_nNewText )
							END IF
							
						CASE "TIME"
							// use for time and timestamp
							l_tNewText = a_dwSource.GetItemTime (l_nRow, l_nCol)
							
							l_cFormat = Upper( a_dwSource.Describe( "#"+String( l_nCol )+".Format" ) )
							IF l_cFormat <> "[GENERAL]" THEN
								l_cNewText = String( l_tNewText, l_cFormat )
							ELSE
								l_cNewText = String( l_tNewText )
							END IF
							
					END CHOOSE
					
					IF IsNull (l_cNewText) THEN l_cNewText = "N/A"
					
					IF Pos( l_cLabel, ":" ) > 0 THEN
						l_cNewComments += (l_cLabel + " " + l_cNewText)
					ELSE
						l_cNewComments += (l_cLabel + ": " + l_cNewText)
					END IF
					
					l_cNewText = ""
				END IF
			NEXT
			
			//If no new comments, return -1
			IF IsNull( l_cNewComments ) OR Trim( l_cNewComments ) = "" OR &
			   Len( l_cNewComments ) = l_nCommentLen THEN
				RETURN -1
			END IF
			
			l_dtTimeStamp = i_wparentwindow.fw_gettimestamp ()
			
			// get any existing comments and add the new item to it.
			dw_case_note_entry.AcceptText( )
			l_cOldComments = dw_case_note_entry.GetItemString (dw_case_note_entry.GetRow( ), "note_text")
			IF IsNull (l_cOldComments) OR (l_cOldComments = "") THEN
				l_cRemarks = STRING(DATE (l_dtTimeStamp), "m/d/yyyy") + ' - ' + &
								 STRING(TIME (l_dtTimeStamp), "hh:mm:ss AM/PM") + &
								 " Comments Added by " + OBJCA.WIN.fu_GetLogin(SQLCA) + &
								 ":" + "~r~n" + l_cNewComments
			ELSE
				l_cRemarks = l_cOldComments + "~r~n~r~n" + &
								 STRING(DATE (l_dtTimeStamp), "m/d/yyyy") + ' - ' + &
								 STRING(TIME (l_dtTimeStamp), "hh:mm:ss AM/PM") + " Comments Added by " + &
								 OBJCA.WIN.fu_GetLogin(SQLCA) + ":" + "~r~n" + l_cNewComments
			END IF
			
			// update the case remarks field
			l_nRV = dw_case_note_entry.SetItem (dw_case_note_entry.GetRow( ), "note_text", l_cRemarks)
		END IF
	END IF
END IF

RETURN l_nRV
end function

public function integer fu_savecase (integer changes, boolean validate);//**********************************************************************************************
//
//   Function:   fu_SaveCase
//   Purpose:    provide one function for saving the elements of a case.
//   Parameters: INTEGER	changes - c_PromptChanges: prompt the user
//											 	 c_IgnoreChanges: ignore changes
//											 	 c_SaveChanges:	save changes without prompting
//					  BOOLEAN	validate -	TRUE:	validate the components before saving
//											 		FALSE: skip validation
//   Returns:    INTEGER -	c_Success:	save process was successful
//									c_Fatal:		save process failed
//									c_Cancel:	save process cancelled by the user.
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  01/09/01 M. Caruso   Created.
//  01/10/01 M. Caruso   Added code to set the status of case details to modified if changes
//                       were found in note entry or case properties.
//  01/11/01 M. Caruso   Added prompt for save before beginning save processing.
//  01/12/01 M. Caruso   If case properties fails validation, set that tab as current.
//  01/14/01 M. Caruso   Enable the change case type menu item if this is an Inquiry case.
//  03/20/01 M. Caruso   Set focus to case properties tab before validation.
//  04/17/01 K. Claver   Update the carve out entries with the new case type if they exist and 
//                       the case type has changed.
//  06/27/01 C. Jackson  Set case_log_xref_source_type back to DataModified! if there is a 
//                       xref_subject_id to save.  (SCR 2140)
//  07/05/01 C. Jackson  Only do Cross Reference stuff if this is not a proactive case (SCR 2148)
//  11/14/01 C. Jackson  Corrected to not process Cross Reference if this is a proactive case.
//  02/14/02 M. Caruso   Commented out some of the cross-reference related code to restore the
//                       integrity of the save process.  The cross-reference code will need to
//								 be revisited.
//  03/04/02 M. Caruso   Uncommented fu_resetUpdate calls at the end of the no-save section.
//  03/06/02 C. Jackson  Correct Cross Reference
//  03/06/02 C. Jackson  Change reference to i_wParentWindow.i_cCaseType to l_dwDetails.dataobject
//  03/11/02 K. Claver   Added code to check if the case is still locked by the current user before
//								 allowing them to save changes to the case.
//  04/09/02 K. Claver   Added code to set the properties datawindow to NewModified! just for validation
//								 on required fields and set back to New! if was switched just for validation.
//  05/23/02 K. Claver   Added code to check if the case detail local datawindow variable is valid
//								 before processing xref code.  Please see SCR #3107
//  05/24/02 M. Caruso   If the user chooses not to save changes, the case details and case
//								 properties datawindows are re-retrieved to restore that last saved
//								 state of the data.
//  05/29/02 C. Jackson  Removed references to case_log_xref_source_type
//  05/30/02 K. Claver   Removed cross ref code as is no longer necessary.  Also reset the update
//								 flags on details, properties and notes if the user chooses not to save
//								 the changes to the case.
//  09/26/02 K. Claver   Added code to reset the autocommit value after lock the case and before return.
//	 12/19/02 K. Claver   Move getting key values outside of the save case transaction to release
//  							 the key_generator table as soon as possible.
//  02/20/02 M. Caruso   Moved the setting of l_dwisDetailStatus out of the check-changes IF
//								 statement to ensure it gets set each time through.
//  02/26/03 M. Caruso   Added calls to fu_CheckRequiredFields to prevent processing from continuing
//								 if the required case properties fields are not filled in.  This only applies
//								 if the case had been saved before.
//  03/04/03 M. Caruso   Removed code that changes status of menu items.  This should be handled
//								 in fu_SetClosedCaseGUI, fu_SetLockedCaseGUI and fu_SetOpenCaseGUI.
//  03/26/03 M. Caruso   Added in code to enable or disable the Close Case menu item after
//								 successfully saving a new case.
//  06/16/03 M. Caruso   Modified code to call the appropriate fu_Set<Status>CaseGUI function
//								 based on the value of the case status field. Also added a condition to only
//								 process case properties required field checking if the case is not Open and
//								 not locked.
//  07/03/03 M. Caruso   Use i_cCaseStatus in condition for calling fu_CheckRequiredProperties.
//  07/08/03 M. Caruso   Set i_cCaseStatus just before calling fu_Set<Status>CaseGUI but after the
//								 the save has been committed. Also, set the case_status_id field back to
//								 the current case status if the save of the case fails.
//**********************************************************************************************

BOOLEAN		l_bChanges, l_bAutoCommit, l_bSave, l_bValidated, l_bLockOrError = FALSE
BOOLEAN		l_bNewCase, l_bForValidation = FALSE, l_bCaseLocked
LONG	      l_nRow
INTEGER		l_nReturn, l_nChoice, l_nCurrentTab, l_nCount, l_nDisable, iReturn
STRING		l_cCommand, l_cXRefSubjectID, l_cNull, l_cXRefSourceType, l_cXRefProviderType
STRING      l_cName, l_cName2, l_cName3, l_cXRefCCSubject, l_cData, l_cLockedBy
DATETIME    l_dtLockedDate
U_DW_STD		l_dwDetails, l_dwProperties, l_dwNotes
U_TABPAGE_CASE_DETAILS l_tpCaseDetails
DWItemStatus l_dwisDetailStatus
Datawindow		ldw_appeal
string		ls_return

SetNull(l_cNull)

//Create tabpage ref
l_tpCaseDetails = tab_folder.tabpage_case_details

// create datawindow references
l_dwDetails = l_tpCaseDetails.dw_case_details
l_dwProperties = tab_folder.tabpage_case_properties.dw_case_properties
l_dwNotes = dw_case_note_entry
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 9.6.2005	Added a reference to the appeal tab datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
ldw_appeal	=	tab_folder.tabpage_appeals.dw_detail

// If there is an appeal window open, try to close it
IF IsValid (tab_folder.tabpage_appeals.iw_appeal) THEN
	iReturn = close(tab_folder.tabpage_appeals.iw_appeal)
	IF iReturn = -1 THEN
		// If it didn't close, they probably said they wanted to save changes, so bring it to the front
		IF IsValid (tab_folder.tabpage_appeals.iw_appeal) THEN
			tab_folder.tabpage_appeals.iw_appeal.BringToTop = TRUE
			tab_folder.tabpage_appeals.iw_appeal.WindowState = Normal!
		END IF
		RETURN c_Fatal
	END IF
END IF

// first make sure any changes are acknowleged in the datawindows
l_dwDetails.AcceptText ()
l_dwProperties.AcceptText ()
l_dwNotes.AcceptText ()

l_nRow = l_dwDetails.GetRow()

// verify that all required case properties are filled in if the case has been saved before.
If l_dwDetails.RowCount() > 0 Then
	IF NOT IsNull (l_dwDetails.GetItemString (1, 'case_log_case_number')) THEN
		l_bCaseLocked = l_tpCaseDetails.fu_CheckLocked()
		IF i_cCaseStatus = 'O' AND NOT l_bCaseLocked THEN
			/********************************************************************************************
				Only check required fields if the case is open and not locked.  Any other situation would
				indicate a field was made required after the case was last saved and therefore could not
				meet the required field conditions (reopening a case, viewing a voided case, etc.)
			********************************************************************************************/
			If ib_converted_casetype <> TRUE Then 
				IF fu_CheckRequiredProperties() = -1 THEN
					l_dwDetails.SetItem (l_dwDetails.i_CursorRow, 'case_log_case_status_id', i_wParentWindow.i_uoCaseDetails.i_cCaseStatus)
					RETURN c_Fatal
				END IF
			End If
		END IF
		l_bNewCase = FALSE
	ELSE
		l_bNewCase = TRUE
	END IF


	// now check for changes, performing validation where necessary
	l_bChanges = FALSE
	l_dwisDetailStatus = l_dwDetails.GetItemStatus (1, 0, Primary!)
	IF l_dwProperties.fu_CheckChanges () OR l_dwNotes.fu_CheckChanges () THEN
		
		l_bChanges = TRUE
		// update the status of the case record to ensure that it saves.
		CHOOSE CASE l_dwisDetailStatus
			CASE New!
				l_dwDetails.SetItemStatus (1, 0, Primary!, NewModified!)
				l_dwisDetailStatus = NewModified!
					
			CASE NotModified!
				l_dwDetails.SetItemStatus (1, 0, Primary!, DataModified!)
				l_dwisDetailStatus = DataModified!
					
		END CHOOSE
	ELSE
		
		IF l_dwDetails.fu_CheckChanges () THEN
			l_bChanges = TRUE
		END IF
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// JWhite	added 9.6.2005		Added a call to check if there were changes to the Appeal tab
		//-----------------------------------------------------------------------------------------------------------------------------------
		IF tab_folder.tabpage_appeals.of_check_appeal_changes() = TRUE THEN
			l_bChanges = TRUE
		END IF
		
		
	END IF
End If

// process changes if they exist
IF l_bChanges THEN
	
	// prompt to save changes if necessary
	CHOOSE CASE changes
		CASE c_PromptChanges
			l_nChoice = MessageBox (gs_appname, 'Do you want to save the changes to the current case?', Question!, YesNo!)

			CHOOSE CASE l_nChoice
				CASE 1
					l_bSave = TRUE
					tab_folder.tabpage_case_details.i_bSaved = TRUE
				
				CASE 2
					l_bSave = FALSE
					tab_folder.tabpage_case_details.i_bSaved = FALSE

					//Clear the changes by re-retrieving the datawindows.  fu_ResetUpdate is called
					//  at the end of each pcd_retrieve event.  Just reset the notes.
					l_dwDetails.fu_Retrieve (l_dwDetails.c_IgnoreChanges, l_dwDetails.c_NoReselectRows)
					l_dwProperties.fu_Retrieve (l_dwProperties.c_IgnoreChanges, l_dwProperties.c_NoReselectRows)
					l_dwNotes.fu_ResetUpdate ()
					
					// if a required field has become unfilled and the case has never been saved, cancel the process.
					IF NOT IsNull (l_dwDetails.GetItemString (1, 'case_log_case_number')) THEN
						If ib_converted_casetype <> TRUE Then 
							IF fu_CheckRequiredProperties() = -1 THEN
								l_dwDetails.SetItem (l_dwDetails.i_CursorRow, 'case_log_case_status_id', i_wParentWindow.i_uoCaseDetails.i_cCaseStatus)
								RETURN c_Fatal
							END IF
						End If
					END IF
					
			END CHOOSE
			
		CASE c_SaveChanges
			l_bSave = TRUE
			
		CASE c_IgnoreChanges
			l_bSave = FALSE
			
	END CHOOSE
	
	// process save as required
	IF l_bSave THEN
		
		IF validate THEN
			// disable redraw and switch focus to case properties tab before validation
			tab_folder.SetRedraw (FALSE)
			l_nCurrentTab = tab_folder.SelectedTab
			tab_folder.SelectTab (3)
			l_dwProperties.SetFocus ()
			
			//Set the status of the properties datawindow to NewModified! so will perform
			//  validation for required fields.
			IF l_dwProperties.RowCount( ) > 0 THEN
				IF l_dwProperties.GetItemStatus( 1, 0, Primary! ) = New! THEN
					l_dwProperties.SetItemStatus( 1, 0, Primary!, NewModified! )
					l_bForValidation = TRUE
				END IF
			END IF
			
			// perform validation before allowing save
			IF l_dwProperties.fu_Validate () = 0 THEN
				//If set to NewModified! for validation only, don't want to insert a blank row
				IF l_bForValidation THEN
					l_dwProperties.SetItemStatus( 1, 0, Primary!, NotModified! )
				END IF
				
				IF l_nCurrentTab <> 3 THEN tab_folder.SelectTab (l_nCurrentTab)
				IF l_dwNotes.fu_Validate () = 0 THEN
					IF l_dwDetails.fu_Validate () = 0 THEN
						l_bValidated = TRUE
					ELSE
						l_bValidated = FALSE
					END IF
				ELSE
					l_bValidated = FALSE
				END IF
				
			ELSE
				l_bValidated = FALSE
			END IF
			tab_folder.SetRedraw (TRUE)
						
		ELSE
			l_bValidated = TRUE
		END IF
		
		IF l_bValidated THEN
			//Move getting key values outside of the save case transaction to release
			//  the key_generator table as soon as possible.
			IF ( IsNull( THIS.i_cNewCaseNum ) OR Trim( THIS.i_cNewCaseNum ) = "" ) AND &
				( IsNull( THIS.i_wParentWindow.i_cCurrentCase ) OR Trim( THIS.i_wParentWindow.i_cCurrentCase ) = "" ) THEN
				THIS.i_cNewCaseNum = i_wParentWindow.fw_GetKeyValue( 'case_log' )
			END IF
			
			IF ( IsNull( THIS.i_cNewMasterCaseNum ) OR Trim( THIS.i_cNewMasterCaseNum ) = "" ) AND &
				THIS.i_wParentWindow.i_bLinked AND &
				( IsNull( THIS.i_wParentWindow.i_cCurrCaseMasterNum ) OR Trim( THIS.i_wParentWindow.i_cCurrCaseMasterNum ) = "" ) THEN
				THIS.i_cNewMasterCaseNum = i_wParentWindow.fw_GetKeyValue( 'case_log_master_num' )
			END IF
			
			IF IsNull( THIS.i_cNewCaseNoteID ) OR Trim( THIS.i_cNewCaseNoteID ) = "" THEN
				THIS.i_cNewCaseNoteID = i_wParentWindow.fw_GetKeyValue( 'case_notes' )			
			END IF
			
			// save the case components
			l_bAutoCommit = SQLCA.autocommit
			SQLCA.autocommit = FALSE
			
			//Check if the case is still locked by the current user before allowing to save
			//  details and properties.  If not locked by the current user, probably cleared
			//  by someone with access to the clear locks admin module.  Can still save notes
			//  even if not locked by the current user.
			IF ( NOT IsNull( THIS.i_wParentWindow.i_cCurrentCase ) AND Trim( THIS.i_wParentWindow.i_cCurrentCase ) <> "" ) AND &
				( Upper( Trim( THIS.i_wParentWindow.i_cLockedBy ) ) = Upper( Trim( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) OR &
				  IsNull( THIS.i_wParentWindow.i_cLockedBy ) ) THEN
				l_bLockOrError = l_tpCaseDetails.fu_CheckLocked( )
				
				//If not locked by the current user or encounter an error determining the lock
				//  status, save the notes and lock the case.
				IF l_bLockOrError THEN
					l_dwDetails.fu_ResetUpdate( )
					l_dwProperties.fu_ResetUpdate( )
					
					IF l_dwNotes.fu_save( c_savechanges ) = 0 THEN
						l_nReturn = c_Success
					ELSE
						l_nReturn = c_Fatal
					END IF

					THIS.fu_SetLockedCaseGUI( )
					
					//Reset the autocommit value before return
					SQLCA.autocommit = l_bAutoCommit
					RETURN l_nReturn
				END IF
			END IF
			
			IF l_dwDetails.fu_save (c_savechanges) = 0 THEN
			
				IF l_dwProperties.fu_save (c_savechanges) = 0 THEN
					
					IF l_dwNotes.fu_save (c_savechanges) = 0 THEN
						l_nReturn = c_Success
					ELSE
						l_nReturn = c_Fatal
					END IF
					
					//-----------------------------------------------------------------------------------------------------------------------------------
					// JWhite Added 9.6.2005 	Call the function to save the appeal information
					//-----------------------------------------------------------------------------------------------------------------------------------
					If tab_folder.tabpage_appeals.in_dao_header.RowCount() > 0 Then 
						ls_return = tab_folder.tabpage_appeals.of_save_appeal()
					End If
					
					If ls_return <> '' Then
						gn_globals.in_messagebox.of_messagebox(ls_return, Information!, OK!, 1)
						l_nReturn = c_Fatal
					End If
					
				ELSE
					l_nReturn = c_Fatal
				END IF
				
			ELSE
				l_nReturn = c_Fatal
			END IF
			
			//Change the case type in the carve out entries if they exist and the case
			//  type has changed
			IF THIS.i_bChangeCaseType AND l_nReturn = c_Success THEN
				//Update the carve out entries if they exist
				SELECT Count( * )
				INTO :l_nCount
				FROM cusfocus.carve_out_entries
				WHERE cusfocus.carve_out_entries.case_number = :i_wParentWindow.i_cCurrentCase
				USING SQLCA;
				
				IF l_nCount > 0 THEN
					UPDATE cusfocus.carve_out_entries
					SET cusfocus.carve_out_entries.case_type = :i_wParentWindow.i_cIssueConcern
					WHERE cusfocus.carve_out_entries.case_number = :i_wParentWindow.i_cCurrentCase
					USING SQLCA;
					
					IF SQLCA.SQLCode < 0 THEN
						l_nReturn = c_Fatal
					ELSE
						THIS.i_bChangeCaseType = FALSE
					END IF
				END IF
			END IF			
			
			// commit or rollback as required
			IF l_nReturn = c_Success THEN
				COMMIT USING SQLCA;
				
				//Check to see if the cases linked is greater than the maximum set.  If so
				//  display a message for the user.
				//Increment the case counter if case link warning is enabled and the case details
				//  are being saved for the first time.
				IF i_wParentWindow.i_bLinked AND l_dwisDetailStatus = NewModified! THEN
					IF i_wParentWindow.i_cLinkWarnEnabled = "Y" THEN
						i_wParentWindow.i_nCaseLinkCount ++ 
						
						IF i_wParentWindow.i_nCaseLinkMax > 0 AND i_wParentWindow.i_nCaseLinkMax <= i_wParentWindow.i_nCaseLinkCount THEN
							l_nDisable = MessageBox( gs_AppName, "You have linked "+String( i_wParentWindow.i_nCaseLinkCount )+" cases.~r~n"+ &
															 "Continue linking?", Question!, YesNo! )
															 
							IF l_nDisable = 2 THEN
								i_wParentWindow.fw_ToggleLinking( )
							END IF
						END IF
					END IF
				END IF
				
//				// enable the change case type menu item if this is an Inquiry case.
//				IF i_wParentWindow.i_cCaseType = i_wParentWindow.i_cInquiry THEN
//					m_create_maintain_case.m_edit.m_changecasetype.enabled = TRUE
//				END IF
//				// enable the view, print case detail report and linked case menu items.
//				m_create_maintain_case.m_file.m_viewcasedetailreport.enabled = TRUE
//				m_create_maintain_case.m_file.m_printcasedetailreport.enabled = TRUE
//				
//				// If successful save, allow to close
//				IF l_bNewCase THEN
//					m_create_maintain_case.m_edit.m_closecase.Enabled = TRUE
//				END IF

				// Update the interface to reflect the new status of the case
				CHOOSE CASE l_dwDetails.GetItemString (l_dwDetails.i_CursorRow, 'case_log_case_status_id')
					CASE 'O'
						i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = i_wParentWindow.i_cStatusOpen
						IF l_tpCaseDetails.fu_CheckLocked() THEN
							fu_SetLockedCaseGUI ()
						ELSE
							fu_SetOpenCaseGUI ()
						END IF
						
					CASE 'C'
						i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = i_wParentWindow.i_cStatusClosed
						fu_SetClosedCaseGUI ()
						
					CASE 'V'
						i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = i_wParentWindow.i_cStatusVoid
						fu_SetVoidedCaseGUI ()
						
				END CHOOSE
				
			ELSE
				l_dwDetails.SetItem (l_dwDetails.i_CursorRow, 'case_log_case_status_id', i_wParentWindow.i_uoCaseDetails.i_cCaseStatus)
				ROLLBACK USING SQLCA;
				
//				//Unsuccessful save, don't allow to close
//				IF l_bNewCase THEN
//					m_create_maintain_case.m_edit.m_closecase.Enabled = FALSE
//				END IF
			END IF
			
			SQLCA.autocommit = l_bAutoCommit
			
		ELSE
			l_nReturn = c_Fatal
		END IF
		
	ELSE
		l_nReturn = c_Success
	END IF
	
END IF

tab_folder.tabpage_case_details.i_bOverWrite = TRUE
tab_folder.tabpage_case_details.i_bCancelSearch = FALSE 


// send return code
RETURN l_nReturn






end function

public subroutine of_enable_appeals ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   Determines if the Appeals tab should be enabled based on the setting in the Systems_options table.
//	Created by:	Joel White
//	History: 	9/1/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	ls_return, ls_modstring, ls_describe, l_cSources
long		l_ncount, ll_rowcount

IF is_using_new_appeals = 'Y' THEN
	CHOOSE CASE i_wParentWindow.i_cCaseType
		CASE i_wParentWindow.i_cConfigCaseType
			l_cSources = i_cAppealsConfigCaseType
			
		CASE i_wParentWindow.i_cInquiry
			l_cSources = i_cAppealsInquiry
			
		CASE i_wParentWindow.i_cIssueConcern
			l_cSources = i_cAppealsIssueConcern
			
		CASE i_wParentWindow.i_cProactive
			l_cSources = i_cAppealsProactive
			
	END CHOOSE
	
	IF Pos (l_cSources, i_wParentWindow.i_cSourceType) = 0 THEN
		tab_folder.tabpage_appeals.enabled = FALSE
		
	ELSE
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Enable the tab and then re-retrieve the AppealDetails for the selected case
		//-----------------------------------------------------------------------------------------------------------------------------------
		tab_folder.tabpage_appeals.enabled = TRUE
		tab_folder.tabpage_appeals.of_init()
		tab_folder.tabpage_appeals.of_retrieve(i_wParentWindow.i_cSelectedCase)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Disable the Appeal Level column on the case detail if we are using the New Appeal System
		//-----------------------------------------------------------------------------------------------------------------------------------
		ls_return = tab_folder.tabpage_case_details.dw_case_details.Modify('case_log_appld.TabSequence = 0')
		
		ls_describe 	= 	tab_folder.tabpage_case_details.dw_case_details.Describe("cc_xref_subject_id.Background.Color")
		ls_modstring 	= 	'case_log_appld.background.color = ' + ls_describe
		ls_return 		= 	tab_folder.tabpage_case_details.dw_case_details.Modify(ls_modstring)
	END IF
	

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the Appeal Tab visible and enlarge the parent window slightly so it will fit properly
	//-----------------------------------------------------------------------------------------------------------------------------------
	tab_folder.tabpage_appeals.visible = TRUE
	i_wParentWindow.width = 3743
ELSE
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Ensure the tab page isn't visible
	//-----------------------------------------------------------------------------------------------------------------------------------
	tab_folder.tabpage_appeals.visible = FALSE
END IF




end subroutine

public subroutine of_check_appeal_setting ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function gets the value from System_Options for the New Appeal System.
//	Created by:	Joel White
//	History: 	9/2/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


string ls_using_new_appeals

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the value for the 'new appeal system' from the System_Options table
//-----------------------------------------------------------------------------------------------------------------------------------
SELECT option_value
  INTO :is_using_new_appeals
  FROM cusfocus.system_options
 WHERE option_name = 'new appeal system'
 USING SQLCA;


//-----------------------------------------------------------------------------------------------------------------------------------
// Check the SQL Return 
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE SQLCA.SQLCode
	CASE -1
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Error happened, show a message box to show the user an error occurred.
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'Error retrieving new appeal system configuration.')
		is_using_new_appeals = 'N'
	CASE 0
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Good things happened.
		//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 100
		//-----------------------------------------------------------------------------------------------------------------------------------
		// No value was found for the 'new appeal system' record in the System_Options table
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'The configuration record for new appeal system was not found.')
		is_using_new_appeals = 'N'
End Choose
end subroutine

public subroutine of_get_appeal_availability (ref string a_configcasetype, ref string a_inquiry, ref string a_issue, ref string a_proactive);/*****************************************************************************************
   Function:   of_get_appeal_availability
   Purpose:    Gather the availability settings for the carve out functionality.
   Parameters: REF STRING a_enabled - is carve out enabled (Y/N)
					REF STRING a_configcasetype - is it available for configurable case type (MPEO)
					REF STRING a_inquiry - is it available for inquiry cases (MPEO)
					REF STRING a_issue - is it available for issue/concern cases (MPEO)
					REF STRING a_proactive - is it available for proactive cases (MPEO)
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/23/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nIndex
STRING	l_cOption, l_cValue[4]

FOR l_nIndex = 1 TO 4
	
	CHOOSE CASE l_nIndex
		CASE 1
			l_cOption = 'appeal configurable'
		
		CASE 2
			l_cOption = 'appeal inquiry'
		
		CASE 3
			l_cOption = 'appeal issue'
		
		CASE 4
			l_cOption = 'appeal proactive'
			
	END CHOOSE
	
	SELECT option_value
	  INTO :l_cValue[l_nIndex]
	  FROM cusfocus.system_options
	 WHERE option_name = :l_cOption
	 USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			// abort on error setting default values for all options
			MessageBox (gs_appname, 'Error retrieving Appeal System configuration.')
			l_cValue[1] = ''
			l_cValue[2] = ''
			l_cValue[3] = ''
			l_cValue[4] = ''
			EXIT
			
		CASE 0
			// all went well
			
		CASE 100
			// set default value for the current option
				l_cValue[l_nIndex] = ''
	END CHOOSE
		
NEXT

a_configcasetype = l_cValue[1]
a_inquiry = l_cValue[2]
a_issue = l_cValue[3]
a_proactive = l_cValue[4]
end subroutine

public subroutine of_enable_eligibility ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   Determines if the Eligibility tab should be enabled based on the setting in the Systems_options table.
//	Created by:	Rick Post
//	History: 	10/27/2008 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	ls_return, ls_modstring, ls_describe, l_cSources
long		l_ncount, ll_rowcount
// Eligibility tab is only for member cases

IF is_using_eligibility = 'Y' AND  i_wParentWindow.i_cSourceType = 'C' THEN
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Enable the tab and then re-retrieve the AppealDetails for the selected case
	//-----------------------------------------------------------------------------------------------------------------------------------
	tab_folder.tabpage_eligibility.enabled = TRUE
//	tab_folder.tabpage_eligibility.of_init()
	tab_folder.tabpage_eligibility.of_retrieve(i_wParentWindow.i_cSelectedCase)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the Appeal Tab visible and enlarge the parent window slightly so it will fit properly
	//-----------------------------------------------------------------------------------------------------------------------------------
	tab_folder.tabpage_eligibility.visible = TRUE
	i_wParentWindow.width = 3743
ELSE
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Ensure the tab page isn't visible
	//-----------------------------------------------------------------------------------------------------------------------------------
	tab_folder.tabpage_eligibility.visible = FALSE
END IF




end subroutine

public subroutine of_check_eligibility_setting ();	
	SELECT option_value
	  INTO :is_using_eligibility
	  FROM cusfocus.system_options
	 WHERE option_name = 'eligibility_tabenabled'
	 USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			is_using_eligibility = 'N'
			
		CASE 0
			// all went well
			
		CASE 100
			// set default value for the current option
			is_using_eligibility = 'N'
	END CHOOSE


end subroutine

on u_case_details.create
int iCurrent
call super::create
this.cb_default_note=create cb_default_note
this.cb_spell_check=create cb_spell_check
this.cb_edit=create cb_edit
this.cb_new=create cb_new
this.cb_save=create cb_save
this.tab_folder=create tab_folder
this.dw_case_note_entry=create dw_case_note_entry
this.gb_note_entry=create gb_note_entry
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_default_note
this.Control[iCurrent+2]=this.cb_spell_check
this.Control[iCurrent+3]=this.cb_edit
this.Control[iCurrent+4]=this.cb_new
this.Control[iCurrent+5]=this.cb_save
this.Control[iCurrent+6]=this.tab_folder
this.Control[iCurrent+7]=this.dw_case_note_entry
this.Control[iCurrent+8]=this.gb_note_entry
end on

on u_case_details.destroy
call super::destroy
destroy(this.cb_default_note)
destroy(this.cb_spell_check)
destroy(this.cb_edit)
destroy(this.cb_new)
destroy(this.cb_save)
destroy(this.tab_folder)
destroy(this.dw_case_note_entry)
destroy(this.gb_note_entry)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    initialize the window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	09/28/00 M. Caruso    Created.
	10/30/00 M. Caruso    Added resizing code.
	12/14/00 M. Caruso    Added code to set instance variables based on global options.
	01/02/01 M. Caruso    Added code to set instance variable i_bExternalNote
	01/10/01 M. Caruso    Added code to initialize the Case Properties and Inquiry Case
								 Properties tabs.
	4/13/2001 K. Claver   Fixed the resize code.
	04/17/02 M. Caruso    Removed references to Inquiry Properties tab.
	06/17/03 M. Caruso    Added initialization of the setting to copy properties on linked
								 new cases.
*****************************************************************************************/

BOOLEAN	l_bOptionsNotSet, lb_return
INTEGER	l_nNewWidth, l_nNewHeight
DECIMAL	l_nWidthOffSet, l_nHeightOffSet
LONG		l_nRow
STRING	l_cDSSQL, l_cDSSyntax, l_cErrors, l_cOption, l_cValue, l_cExternal
DATASTORE	l_dsOptions
U_DW_STD	l_dwCaseProps, l_dwCasePropsInq
U_TABPAGE_CASE_PROPERTIES	l_tpCaseProps

fu_SetOptions (c_ClosePromptUser)

of_SetResize (TRUE)
IF IsValid (i_wParentWindow.inv_resize) THEN
	// calculate the resize ratio of the parent window from when it was created.
	IF i_wParentWindow.Width < 3579 THEN
		l_nWidthOffSet = 0
	ELSE
		l_nWidthOffSet = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
	END IF
	
	IF i_wParentWindow.Height < 1600 THEN
		l_nHeightOffSet = 0
	ELSE
		l_nHeightOffSet = i_wParentWindow.Height - i_wParentWindow.i_nBaseHeight
	END IF
	
	// adjust the size/position of this container in case the window has been resized.
	l_nNewHeight = 1600 + l_nHeightOffSet
	l_nNewWidth = 3579 + l_nWidthOffSet
	Resize (l_nNewWidth, l_nNewHeight)
	
	// adjust the size/position of gb_note_entry
	l_nNewWidth = gb_note_entry.Width + l_nWidthOffSet
	gb_note_entry.Resize (l_nNewWidth, gb_note_entry.Height)
	inv_resize.of_Register (gb_note_entry, "ScaleToRight")
	
	// adjust the size/position of cb_new
	inv_resize.of_Register (cb_new, "FixedToRight")
	cb_new.X = (cb_new.X + l_nWidthOffSet)
		
	// adjust the size/position of cb_save
	inv_resize.of_Register (cb_save, "FixedToRight")
	cb_save.X = (cb_save.X + l_nWidthOffSet)
	
	// adjust the size/position of cb_edit
	inv_resize.of_Register (cb_edit, "FixedToRight")
	cb_edit.X = (cb_edit.X + l_nWidthOffSet)
	
	// adjust the size/position of cb_edit
	inv_resize.of_Register (cb_spell_check, "FixedToRight")
	cb_spell_check.X = (cb_spell_check.X + l_nWidthOffSet)
	
	// adjust the size/position of cb_default_note
	inv_resize.of_Register (cb_default_note, "FixedToRight")
	cb_default_note.X = (cb_default_note.X + l_nWidthOffSet)
	
	// initialize the tab_folder
	inv_resize.of_Register (tab_folder, "ScaleToRight&Bottom")
	l_nNewWidth = tab_folder.Width + l_nWidthOffSet
	l_nNewHeight = tab_folder.Height + l_nHeightOffSet
	tab_folder.Resize (l_nNewWidth, l_nNewHeight)
	
	// dw_case_note_entry does not get resized.
	
	//Register this object with the window resize service.	
	i_wParentWindow.inv_resize.of_Register (THIS, "ScaleToRight&Bottom")
	
END IF

// set system options related to this window.
i_nReopenLimit = 30
i_bCloseByOwner = TRUE
i_cdefaultnotetype = ''
i_cdefaultcontactmethod = ''
i_bCopyProperties = TRUE

l_dsOptions = CREATE DATASTORE
l_cDSSQL = 'SELECT option_name, option_value FROM cusfocus.system_options ' + &
 			  'WHERE option_name IN (~'reopen limit~', ~'return for close~', ' + &
											'~'default note type~', ~'default method id~', ' + &
											'~'link_copy_properties~')' 
l_cDSSyntax = SQLCA.SyntaxFromSQL (l_cDSSQL, '', l_cErrors)
IF l_cDSSyntax = '' THEN
	MessageBox (gs_appname, l_cErrors)
ELSE
	
	l_dsOptions.Create (l_cDSSyntax, l_cErrors)
	IF Len (l_cErrors) = 0 THEN
		
		l_dsOptions.SetTransObject (SQLCA)
		IF l_dsOptions.Retrieve () > 0 THEN
			
			FOR l_nRow = 1 TO l_dsOptions.RowCount ()
				
				l_cOption = Upper (l_dsOptions.GetItemString (l_nRow, 'option_name'))
				l_cValue = l_dsOptions.GetItemString (l_nRow, 'option_value')
				CHOOSE CASE l_cOption
					CASE 'REOPEN LIMIT'
						i_nReopenLimit = LONG (l_cValue)
						
					CASE 'RETURN FOR CLOSE'
						CHOOSE CASE l_cValue
							CASE 'owner'
								i_bCloseByOwner = TRUE
								
							CASE 'any'
								i_bCloseByOwner = FALSE
								
						END CHOOSE
						
					CASE 'DEFAULT NOTE TYPE'
						i_cdefaultnotetype = l_cValue
						
					CASE 'DEFAULT METHOD ID'
						i_cdefaultcontactmethod = l_cValue
					
					CASE 'LINK_COPY_PROPERTIES'
						IF l_cValue = 'Y' THEN
							i_bCopyProperties = TRUE
						ELSE
							i_bCopyProperties = FALSE
						END IF
					
				END CHOOSE
				
			NEXT
			
		ELSE
			MessageBox (gs_appname, 'Unable to set system options.  Using default values.')
		END IF
		
	ELSE
		MessageBox (gs_appname, l_cErrors)
	END IF
	
END IF
DESTROY l_dsOptions

SELECT is_external INTO :l_cExternal FROM cusfocus.case_note_types
 WHERE note_type = :i_cdefaultnotetype USING SQLCA;
 
IF upper (l_cExternal) = 'Y' THEN
	i_bExternalNote = TRUE
ELSE
	i_bExternalNote = FALSE
END IF

// initialize the Case Properties tab
l_tpCaseProps = tab_folder.tabpage_case_properties
l_dwCaseProps = l_tpCaseProps.dw_case_properties
l_dwCaseProps.fu_setoptions (SQLCA, l_dwCaseProps.c_NUllDW, &
											l_tpCaseProps.i_cCasePropsOptions )
											
											

end event

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    initialize the window variables

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/23/01 M. Caruso    Created.
*****************************************************************************************/

fu_GetCarveOutAvailability (i_cCarveOutEnabled, &
									 i_cCarveOutConfigCaseType, &
									 i_cCarveOutInquiry, &
									 i_cCarveOutIssueConcern, &
									 i_cCarveOutProactive)

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 9.2.2005 - Call the function that will check to see if they are using the new appeal system.
//-----------------------------------------------------------------------------------------------------------------------------------
of_check_appeal_setting()

of_get_appeal_availability( i_cAppealsConfigCaseType, i_cAppealsInquiry, i_cAppealsIssueConcern, i_cAppealsProactive)

of_check_eligibility_setting()


end event

event constructor;call super::constructor;INTEGER li_return, li_test
Long ll_key
ll_key = 1358974423
in_spell_checking = create n_spell_checking
li_return = in_spell_checking.SSCE_SetKey(ll_key)
//li_return = in_spell_checking.SSCE_SetIniFile("C:\Program Files\Outlaw Technologies\CustomerFocus Desktop\ssce.ini")
li_return = in_spell_checking.SSCE_SetMainLexPath("C:\SpellChecker")
li_return = in_spell_checking.SSCE_SetUserLexPath("C:\SpellChecker")
li_return = in_spell_checking.SSCE_SetMainLexFiles("ssceam.tlx,ssceam2.clx,medlex.clx")
li_return = in_spell_checking.SSCE_SetUserLexFiles("userdic.tlx,correct.tlx")
li_return = in_spell_checking.SSCE_SetHelpFile("C:\SpellChecker\ssce.hlp")
li_test = li_return


//MainLexPath=C:\Program Files\Outlaw Technologies\CustomerFocus Desktop
//MainLexFiles=ssceam.tlx,ssceam2.clx,medlex.clx
//HelpFile=C:\Program Files\Outlaw Technologies\CustomerFocus Desktop\ssce.hlp
//UserLexPath=C:\Program Files\Outlaw Technologies\CustomerFocus Desktop
//UserLexFiles=userdic.tlx,correct.tlx

end event

event destructor;call super::destructor;
destroy in_spell_checking


end event

type cb_default_note from commandbutton within u_case_details
boolean visible = false
integer x = 3086
integer y = 80
integer width = 421
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Default Note"
end type

event clicked;String ls_hotkey_text, ls_column_name, ls_first, ls_last, ls_text
Long ll_selected_start, ll_selected_length, ll_insertion_point, ll_pos, ll_row

ls_column_name = dw_case_note_entry.GetColumnName()
ll_row = dw_case_note_entry.GetRow()
IF ls_column_name = 'note_text' THEN
	ls_text =  dw_case_note_entry.GetText()
	IF IsNull(ls_text) THEN ls_text = ''
	IF LEN(ls_text) = 0 THEN
		ls_first = ''
		ls_last = ''
	ELSE
		ll_selected_start = dw_case_note_entry.SelectedStart()
		ll_selected_length = dw_case_note_entry.SelectedLength()
		ll_insertion_point = dw_case_note_entry.Position()
		IF ll_selected_length = 0 THEN // Nothing selected, insert text at insertion point
			ls_first = MID(ls_text, 1, ll_selected_start - 1)
			ls_last = MID(ls_text, ll_selected_start)
		ELSE // Replace selected text with hotkey text
			ls_first = MID(ls_text, 1, ll_selected_start - 1)
			ls_last = MID(ls_text, ll_selected_start + ll_selected_length)
		END IF
	END IF
ELSE // Default to adding hotkey to end
	ls_first = dw_case_note_entry.object.note_text[ll_row]
	IF IsNull(ls_first) THEN ls_first = ''
	ls_last = ''
END IF

dw_case_note_entry.object.note_text[ll_row] = ls_first + is_default_note_text + ls_last

end event

event constructor;string ls_nuthin
ls_nuthin = ''
end event

type cb_spell_check from commandbutton within u_case_details
integer x = 3086
integer y = 184
integer width = 421
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Spell &Check"
end type

event clicked;String ls_original, ls_checked, ls_environment
LONG ll_row, ll_len, ll_null, ll_return
INT	li_return
BOOLEAN lb_return
n_spell_checking ln_spell_checking


dw_case_note_entry.AcceptText()
ls_original = dw_case_note_entry.object.note_text[1]
IF NOT IsNull(ls_original) THEN
	ls_checked = ls_original
	ll_len = LEN(ls_original)
	SetNull(ll_null)
	ll_return = in_spell_checking.SSCE_CheckBlockDlg(Handle(i_wParentWindow), ls_checked, ll_len, 10000, 1)
	IF LEN(ls_checked) > 1 THEN
		IF ls_checked = ls_original THEN
			MessageBox(gs_AppName, "Spell checking completed.")
		ELSE
			dw_case_note_entry.object.note_text[1] = ls_checked
		END IF
	END IF
END IF

end event

event constructor;string ls_nuthin
ls_nuthin = ''
end event

type cb_edit from commandbutton within u_case_details
integer x = 3086
integer y = 288
integer width = 421
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Edit Note"
end type

event clicked;Long ll_note_id, ll_rowcount, ll_row, ll_modified, ll_edit_row, ll_current_note_id, ll_note_security
String ls_updatable, ls_text

dw_case_note_entry.AcceptText()
ll_modified = dw_case_note_entry.ModifiedCount()
IF ll_modified > 0 THEN
	ls_text = dw_case_note_entry.object.note_text[1]
	IF LEN(TRIM(ls_text)) > 0 THEN
		Messagebox(gs_appname, "The current note has not been saved.")
		RETURN
	END IF
END IF

ll_rowcount = tab_folder.tabpage_case_notes.dw_case_notes.RowCount()
IF ll_rowcount > 0 THEN

	ll_row =  tab_folder.tabpage_case_notes.dw_case_notes.GetSelectedRow(0)
	ll_note_id =  tab_folder.tabpage_case_notes.dw_case_notes.object.note_id[ll_row]
	ls_updatable =  tab_folder.tabpage_case_notes.dw_case_notes.object.case_note_types_updatable[ll_row]
	IF IsNull(ls_updatable) THEN ls_updatable = 'N'
	IF ls_updatable = 'N' THEN
		ll_edit_row = dw_case_note_entry.RowCount()
		IF ll_edit_row > 0 THEN
			ll_current_note_id =  dw_case_note_entry.object.note_id[1]
			IF IsNull(ll_current_note_id) THEN
				Messagebox(gs_appname, "The selected note type does not allow updates.")
			ELSE
				IF ll_current_note_id <> ll_note_id THEN
					Messagebox(gs_appname, "The selected note type does not allow updates.")
					ll_row = tab_folder.tabpage_case_notes.dw_case_notes.Find("note_id = " + String(ll_current_note_id),1,ll_rowcount)
					IF ll_row > 0 AND ll_row <= ll_rowcount THEN
						tab_folder.tabpage_case_notes.dw_case_notes.i_ignoreRFC = FALSE
						tab_folder.tabpage_case_notes.dw_case_notes.i_fromclicked = FALSE
						tab_folder.tabpage_case_notes.dw_case_notes.SetRow(ll_row)
						tab_folder.tabpage_case_notes.dw_case_notes.ScrollToRow(ll_row)
					END IF
				END IF
			END IF
		END IF
	ELSE
		ll_note_security =  tab_folder.tabpage_case_notes.dw_case_notes.object.case_notes_note_security_level[ll_row]
		IF i_wParentWindow.i_nRepConfidLevel < ll_note_security THEN
			ll_edit_row = dw_case_note_entry.RowCount()
			IF ll_edit_row > 0 THEN
				ll_current_note_id =  dw_case_note_entry.object.note_id[1]
				IF IsNull(ll_current_note_id) THEN
					MessageBox( gs_AppName, "The security level for this case note is higher than your current security.~r~n" + &
												"You are not permitted to access this record.", StopSign!, OK! )
				ELSE
					IF ll_current_note_id <> ll_note_id THEN
						MessageBox( gs_AppName, "The security level for this case note is higher than your current security.~r~n" + &
												"You are not permitted to access this record.", StopSign!, OK! )
						ll_row = tab_folder.tabpage_case_notes.dw_case_notes.Find("note_id = " + String(ll_current_note_id),1,ll_rowcount)
						IF ll_row > 0 AND ll_row <= ll_rowcount THEN
							tab_folder.tabpage_case_notes.dw_case_notes.i_ignoreRFC = FALSE
							tab_folder.tabpage_case_notes.dw_case_notes.i_fromclicked = FALSE
							tab_folder.tabpage_case_notes.dw_case_notes.SetRow(ll_row)
							tab_folder.tabpage_case_notes.dw_case_notes.ScrollToRow(ll_row)
						END IF
					END IF
				END IF
			END IF
		ELSE
			dw_case_note_entry.Retrieve(ll_note_id)
			dw_case_note_entry.SetFocus()
		END IF
	END IF
END IF
end event

event constructor;string ls_nuthin
ls_nuthin = ''
end event

type cb_new from commandbutton within u_case_details
integer x = 3086
integer y = 496
integer width = 421
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New Note"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Clear the current case note and set up for a new note.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/18/00 M. Caruso    Created.
	11/08/00 M. Caruso    Added code to handle blank or NULL case note text.
	11/13/00 M. Caruso    Updated new note code to use refresh and new, instead of retrieve
	11/28/2000 K. Claver  Added code to set the i_indrag instance variable to false on the 
								 datawindow edit service so the pcd_new event is fired every time
								 regardless of whether the user dragged and dropped or added a case
								 comment via a button.
	12/20/00 M. Caruso    Set focus back to dw_casenote_entry.
*****************************************************************************************/

BOOLEAN		l_bCreateNew
INTEGER		l_nRtn
U_DW_STD		l_dwCaseDetails

dw_case_note_entry.AcceptText ()

dw_case_note_entry.SetRedraw (FALSE)

// determine if the user needs to be prompted about the save.
CHOOSE CASE dw_case_note_entry.GetItemStatus (dw_case_note_entry.i_CursorRow, 0, Primary!)
	CASE New!, NotModified!
		//  the case note has not been modified, so ignore it.
		dw_case_note_entry.fu_reset (dw_case_note_entry.c_IgnoreChanges)
		
		//Set the i_indrag instance variable to false on the datawindow edit service
		//  so the pcd_new event is always fired after the note is saved
		IF IsValid( dw_case_note_entry.i_DWSRV_EDIT ) THEN
			dw_case_note_entry.i_DWSRV_EDIT.i_InDrag = FALSE
		END IF
		
		dw_case_note_entry.fu_New (1)
		
	CASE NewModified!, DataModified!
		// ask the user whether to save this note or not.
		l_nRtn = MessageBox (gs_appname, "Would you like to save this case note?", Question!, YesNoCancel!)
		CHOOSE CASE l_nRtn
			CASE 1
				IF fu_savecase (c_SaveChanges) = 0 THEN
					l_bCreateNew = TRUE
				ELSE
					l_bCreateNew = FALSE
				END IF
				
			CASE 2
				l_bCreateNew = TRUE
				
			CASE 3
				l_bCreateNew = FALSE
				
		END CHOOSE
		
		// create the new note if appropriate
		IF l_bCreateNew THEN
			
			//Set the i_indrag instance variable to false on the datawindow edit service
			//  so the pcd_new event is always fired after the note is saved
			IF IsValid( dw_case_note_entry.i_DWSRV_EDIT ) THEN
				dw_case_note_entry.i_DWSRV_EDIT.i_InDrag = FALSE
			END IF
			
			dw_case_note_entry.fu_reset (c_IgnoreChanges)
			dw_case_note_entry.fu_New (1)
			
		END IF
		
END CHOOSE

dw_case_note_entry.SetFocus ()
dw_case_note_entry.SetRedraw (TRUE)
end event

event constructor;string ls_nuthin
ls_nuthin = ''
end event

type cb_save from commandbutton within u_case_details
integer x = 3086
integer y = 392
integer width = 421
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save Note"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Trigger the save process of the current case note.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/18/00 M. Caruso    Created.
	11/08/00 M. Caruso    Added code to ensure that note text is entered before allowing
								 a note to be saved.
	11/13/00 M. Caruso    Updated new note functionality to use refresh then new, instead
								 of a retrieve.
	11/27/00 M. Caruso    Commented out the code to reset the datawindow after saving.
	11/28/00 M. Caruso    Removed case saving code.  It has been moved to the
								 pcd_savebefore event script of dw_case_note_entry.
	12/20/00 M. Caruso    Set focus back to dw_casenote_entry.
	01/09/01 M. Caruso    Modified to work with fu_savecase ()
	4/12/2001 K. Claver   Changed to check the return from the save case function before
								 setting the focus back to the notes datawindow.
*****************************************************************************************/
Long ll_rowcount, ll_row, ll_edit_row, ll_note_id

IF fu_savecase (c_savechanges) <> c_Fatal THEN
	dw_case_note_entry.SetFocus ()
	//Deselect the currently selected text and move the cursor to the end.
	dw_case_note_entry.SelectText( ( Len( dw_case_note_entry.GetText( ) ) + 1 ), 0 )
	ll_edit_row = dw_case_note_entry.RowCount()
	ll_rowcount = tab_folder.tabpage_case_notes.dw_case_notes.RowCount()
	IF ll_edit_row > 0 THEN
		ll_note_id =  dw_case_note_entry.object.note_id[1]
		ll_row = tab_folder.tabpage_case_notes.dw_case_notes.Find("note_id = " + String(ll_note_id),1,ll_rowcount)
		IF ll_row > 0 AND ll_row <= ll_rowcount THEN
			tab_folder.tabpage_case_notes.dw_case_notes.i_ignoreRFC = FALSE
			tab_folder.tabpage_case_notes.dw_case_notes.i_fromclicked = FALSE
			tab_folder.tabpage_case_notes.dw_case_notes.SetRow(ll_row)
			tab_folder.tabpage_case_notes.dw_case_notes.ScrollToRow(ll_row)
		END IF
	END IF
END IF
end event

event constructor;string ls_nuthin
ls_nuthin = ''
end event

type tab_folder from u_tab_case_details within u_case_details
integer x = 14
integer y = 688
integer taborder = 40
end type

event constructor;call super::constructor;string ls_nuthin
ls_nuthin = ''
end event

type dw_case_note_entry from u_dw_std within u_case_details
event keydown pbm_dwnkey
integer x = 59
integer y = 72
integer width = 2949
integer height = 580
integer taborder = 60
string dataobject = "d_case_note_entry"
boolean border = false
end type

event keydown;/*****************************************************************************************
   Event:      KeyDown
   Purpose:    Allow processing for each key as it is pressed.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
   10/5/01  M. Caruso    Created.
*****************************************************************************************/
String ls_hotkey_text, ls_column_name, ls_first, ls_last, ls_text
Long ll_selected_start, ll_selected_length, ll_insertion_point, ll_pos, ll_row

ls_column_name = THIS.GetColumnName()
ll_row = THIS.GetRow()
IF ls_column_name = 'note_text' THEN
	ls_text =  THIS.GetText()
	IF IsNull(ls_text) THEN ls_text = ''
	IF LEN(ls_text) = 0 THEN
		ls_first = ''
		ls_last = ''
	ELSE
		ll_selected_start = THIS.SelectedStart()
		ll_selected_length = THIS.SelectedLength()
		ll_insertion_point = THIS.Position()
		IF ll_selected_length = 0 THEN // Nothing selected, insert text at insertion point
			ls_first = MID(ls_text, 1, ll_selected_start - 1)
			ls_last = MID(ls_text, ll_selected_start)
		ELSE // Replace selected text with hotkey text
			ls_first = MID(ls_text, 1, ll_selected_start - 1)
			ls_last = MID(ls_text, ll_selected_start + ll_selected_length)
		END IF
	END IF
ELSE // Default to adding hotkey to end
	ls_first = THIS.object.note_text[ll_row]
	IF IsNull(ls_first) THEN ls_first = ''
	ls_last = ''
END IF

CHOOSE CASE Key
	CASE KeyEscape!
		RETURN 1
		
	CASE KeyF1!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F1'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F1'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF2!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F2'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F2'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF3!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F3'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F3'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF4!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F4'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F4'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF5!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F5'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F5'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF6!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F6'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F6'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF7!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F7'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F7'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF8!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F8'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F8'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF9!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F9'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F9'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF10!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F10'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F10'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF11!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F11'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F11'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
	CASE KeyF12!
		IF KeyFlags = 0 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'F12'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		ELSEIF KeyFlags = 1 THEN
			SELECT hotkey_text
			INTO :ls_hotkey_text
			FROM cusfocus.hotkeys
			WHERE hotkey_id = 'Shift-F12'
			USING SQLCA;
			IF Len(ls_hotkey_text) > 0 THEN
				THIS.object.note_text[ll_row] = ls_first + ls_hotkey_text + ls_last
			END IF
		END IF
END CHOOSE
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize the Note Entry datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/02/00 M. Caruso    Created.
	11/28/00 M. Caruso    Added c_NoMenuButtonActivation to the datawindow options list.
*****************************************************************************************/
String l_cCols[ ]

fu_setoptions (SQLCA, c_NullDW, c_NewOK + &
										  c_NewOnOpen + &
										  c_NewModeOnEmpty + &
										  c_DDDWFind + &
										  c_FreeFormStyle + &
										  c_DropOK + &
										  c_NoRetrieveOnOpen + &
										  c_NoMenuButtonActivation)
								
//Set up the drop service
l_cCols[ 1 ] = "note_text"
fu_WireDrop( l_cCols[ ] )
end event

event pcd_savebefore;call super::pcd_savebefore;/*****************************************************************************************
   Event:      pcd_savebefore
   Purpose:    Set the entered by and timestamp information before saving.  Save the
					current case as well.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/02/00 M. Caruso    Created.
	10/19/00 M. Caruso    Modified to always save the case detail to reflect that the case
								 changed by adding another case note.
	10/27/00 M. Caruso    Moved the code to save the current case to the Save button.
	11/28/00 M. Caruso    Added code to ensure that all new cases get saved.
	01/09/01 M. Caruso    Modified to work with fu_savecase ().
	01/03/2003 K. Claver  Added code to check if the case number for the note is populated
								 before attempting to set.
	06/13/03 M. Caruso    Only set the case_number, entered_by and entered_timestamp values
								 if the case_number needs to be set.
*****************************************************************************************/

INTEGER	l_nrtn, l_nNoteConfidLevel
STRING	l_cNewKey, l_cCaseNumber, l_cNoteCaseNum
U_DW_STD	l_dwCaseDetails

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details

// make certain that the case gets saved if it has not already been saved.
l_cCaseNumber = l_dwCaseDetails.GetItemString (l_dwCaseDetails.i_CursorRow, "case_log_case_number")

IF IsNull (l_cCaseNumber) OR Trim (l_cCaseNumber) = '' THEN
	
	MessageBox (gs_appname, 'The current case note cannot be saved until this case is assigned a case number.')
	Error.i_FWError = c_Fatal
	
ELSE

	// Only set these values if the case number is empty or different than the current case number
	l_cNoteCaseNum = THIS.GetItemString( i_CursorRow, "case_number" )
	IF IsNull( l_cNoteCaseNum ) OR Trim( l_cNoteCaseNum ) = "" 	OR &
	   ( NOT IsNull( l_cNoteCaseNum ) AND l_cNoteCaseNum <> l_cCaseNumber ) THEN
		SetItem (i_CursorRow, "case_number", l_cCaseNumber)
		SetItem (i_CursorRow, "entered_by", OBJCA.WIN.fu_GetLogin(SQLCA))
		SetItem (i_CursorRow, "entered_timestamp", i_wParentWindow.fw_GetTimeStamp())
	END IF
	Error.i_FWError = c_Success

END IF
end event

event pcd_new;call super::pcd_new;//*********************************************************************************************
//
//  Event:   pcd_new
//  Purpose: Set default values for some of the fields.
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  10/02/00 M. Caruso   Created.
//  10/25/00 M. Caruso   Reset the status of the row to NEW! after setting default values.
//  11/15/00 M. Caruso   Removed code that attempts to set the case number.  This is set in 
//                       pcd_savebefore.
//  12/21/00 M. Caruso   Check the case status before enabling/disabling the contact method 
//                       field for an 'external' note type.
//  04/11/01 K. Claver   Added code to correctly set the external note boolean instance 
//                       variable.
//  02/04/03 C. Jackson  Set Default Note Security based on the values set in System Options
//*********************************************************************************************

INTEGER				l_nFilterStatus
LONG					l_nRow
STRING				l_cCaseNumber
U_DW_STD				l_dwCaseDetails, l_cNull
DATAWINDOWCHILD	l_dwcList

l_dwCaseDetails = tab_folder.tabpage_case_details.dw_case_details

// set default values for the case note
SetItem (i_CursorRow, 'note_type', i_cdefaultnotetype)
SetItem (i_CursorRow, 'note_importance', 'N')

// determine if the default note type is external and adjust interface accordingly
IF GetChild ("note_type", l_dwcList) = 1 THEN 
			
	l_nRow = l_dwcList.Find ('note_type = "' + i_cdefaultnotetype + '"', 1, l_dwcList.RowCount ())
	IF l_dwcList.GetItemString (l_nRow, 'external') = 'Y' THEN
		
		i_bExternalNote = TRUE
		
		SetItem (i_CursorRow, 'method_id', i_cdefaultcontactmethod)
		CHOOSE CASE i_cCaseStatus
			CASE i_wParentWindow.i_cStatusOpen
				Object.method_id.Protect = 0
				Modify ("method_id.Background.Color='16777215'")
				
			CASE ELSE
				Object.method_id.Protect = 1
				Modify ("method_id.Background.Color='79741120'")
				
		END CHOOSE
		
	ELSE
		
		i_bExternalNote = FALSE
		
		SetNull (l_cNull)
		SetItem (i_CursorRow, 'method_id', l_cNull)
		Object.method_id.Protect = 1
		Modify ("method_id.Background.Color='79741120'")
		
	END IF
	
END IF

// set the default note security level
SetItem (i_CursorRow, 'note_security_level', LONG(gs_CaseNoteSecurity))

// this results in resetting the row status to New! (See PB HELP)
SetItemStatus (i_CursorRow, 0, Primary!, NotModified!)
end event

event pcd_setkey;call super::pcd_setkey;/*****************************************************************************************
   Event:      pcd_setkey
   Purpose:    Set the note ID for the new note.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/02/00 M. Caruso    Created.
	10/17/00 M. Caruso    Rewrote to call fw_GetKeyValue from the parent window.
   12/19/2002 K. Claver  Moved getting of key value for the case to the fu_savecase function
								 before autocommit is set to false to allow the transaction to get the
								 key value to complete as soon as possible.
*****************************************************************************************/

STRING	l_cNewKey

//l_cNewKey = i_wparentwindow.fw_GetKeyValue ('case_notes')
l_cNewKey = PARENT.i_cNewCaseNoteID
SetNull( PARENT.i_cNewCaseNoteID )
CHOOSE CASE l_cNewKey
	CASE '-1'
		MessageBox (gs_appname, 'CustomerFocus was unable to retrieve a unqiue ID for this case note.')
		
	CASE ELSE
		// set the key for this note
//		SetItem (1, 'note_id', LONG (l_cNewKey))
		SetItem (i_CursorRow, 'note_id', LONG (l_cNewKey))
		
	 
END CHOOSE


end event

event pcd_saveafter;call super::pcd_saveafter;/*****************************************************************************************
   Event:      pcd_saveafter
   Purpose:    Update the Case Notes tab.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/02/00 M. Caruso    Created.
*****************************************************************************************/

// refresh the Case Notes tab
tab_folder.tabpage_case_notes.dw_case_notes.fu_retrieve (c_ignorechanges, c_noreselectrows)
end event

event itemchanged;call super::itemchanged;/*****************************************************************************************
   Event:      itemchanged
   Purpose:    Update dw_note_entry if the column selected is iim_source_id and the
					enable/disable the contact method field as appropriate.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	09/26/00 M. Caruso    Created.
	11/08/00 M. Caruso    Added code to change the status and color of the method_id field
								 based on the value of the note_type field.
	11/29/00 M. Caruso    Modified to set the status based on whether the selected item is
								 "external" or not.
	12/20/00 M. Caruso    If new note type is "external", set default contact method
								 defined in system options instead of just '1'.
	04/06/01 K. Claver    Added code to correctly set the i_bExternalNote instance variable
								 so the field is correctly set in the fu_EnableNoteEntry function.
	02/14/02 M. Caruso    Only reset the contact method if the previous note type was
								 INTERNAL.
	03/20/02 M. Caruso    Trap if an invalid security level is selected and prompt the user.
*****************************************************************************************/

LONG					l_nRow, l_nPrevLevel
STRING				l_cNull, l_cRepLevelDesc, ls_text, ls_default_text
DATAWINDOWCHILD	l_dwcList, l_dwcLevels

CHOOSE CASE dwo.Name
	CASE "note_type"
		AcceptText ()
		IF GetChild ("note_type", l_dwcList) = 1 THEN 
			
			l_nRow = l_dwcList.GetRow ()
			IF l_dwcList.GetItemString (l_nRow, 'external') = 'Y' THEN
				
				IF NOT PARENT.i_bExternalNote THEN
					
					// if the previous note type was not external, set the default.
					SetItem (i_CursorRow, 'method_id', i_cDefaultContactMethod)
					Object.method_id.Protect = 0
					Modify ("method_id.Background.Color='16777215'")
					
					PARENT.i_bExternalNote = TRUE
					
				END IF
				
			ELSE
				
				SetNull (l_cNull)
				SetItem (i_CursorRow, 'method_id', l_cNull)
				Object.method_id.Protect = 1
				Modify ("method_id.Background.Color='79741120'")
				
				PARENT.i_bExternalNote = FALSE
				
			END IF
			
		END IF
		
		// Check for default note text
		is_default_note_text = ''
		SELECT default_text
		INTO :is_default_note_text
		FROM cusfocus.case_note_types
		WHERE note_type = :data
		USING SQLCA;
		IF LEN(is_default_note_text) > 0 THEN
			cb_default_note.enabled = TRUE
			cb_default_note.visible = TRUE
		ELSE
			cb_default_note.enabled = FALSE
			cb_default_note.visible = FALSE
		END IF
		
	CASE 'note_security_level'
		IF Trim (data) <> "" AND NOT IsNull (data) THEN
			IF i_wParentWindow.i_nRepConfidLevel < INTEGER (data) THEN
				IF GetChild ('note_security_level', l_dwcLevels) = 1 THEN
					l_nRow = l_dwcLevels.Find ('confidentiality_level = ' + STRING (i_wParentWindow.i_nRepConfidLevel), &
														1, l_dwcLevels.RowCount())
					l_cRepLevelDesc = l_dwcLevels.GetItemString (l_nRow, 'confid_desc')
					
				ELSE
					l_cRepLevelDesc = 'N/A'
				END IF
				
				MessageBox( gs_AppName, "You cannot set the security level of this case note higher~r~n" + &
												"than your own, which is " + l_cRepLevelDesc, StopSign!, OK! )
				l_nPrevLevel = GetItemNumber (1, 'note_security_level')
				SetItem (1, 'note_security_level', l_nPrevLevel)
				RETURN 2
			END IF
		END IF

END CHOOSE
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Clear the datawindow and prep for a new case note

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/19/00 M. Caruso    Created.
*****************************************************************************************/

LONG	ll_NoteID

ll_NoteID = LONG (PCCA.Parm[1])

// retrieve the specified note
CHOOSE CASE retrieve (ll_NoteID)
	CASE -1
		// report the error
		MessageBox (gs_appname, 'An error occurred retrieving the specified case note.')
		
	CASE 0
		// code only if needed in the future...
		
	CASE ELSE
		// code only if needed in the future...
		
END CHOOSE
end event

event dragdrop;//******************************************************************
//  PC Module     : u_DW_Main
//  Event         : DragDrop
//  Description   : Process the drop action for the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF i_AllowDrop THEN
	AcceptText ()
	Error.i_FWError = i_DWSRV_EDIT.fu_Drop(source, row)
END IF
end event

event pcd_validatedrop;call super::pcd_validatedrop;/*****************************************************************************************
   Event:      pcd_ValidateDrop
   Purpose:    Provides the opportunity for the developer to write code to validate a row
					that is dragged and dropped in the DataWindow before it is inserted.
					
   Parameters: U_DW_MAIN Drag_DW -
            	      The DataWindow that initiated the drag operation.
               LONG      Drag_Row -
                     The row that is being dragged.
               LONG      Drop_Row -
                     The row number where the dragged row will be dropped.  This row
							may not exist if it is being dropped after the last row.
							  
   Returns:    Error.i_FWError -
                     c_Success - the event completed succesfully.
                     c_Fatal   - the event encountered an error.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/25/00  M. Caruso    Created.
	11/10/2000 K. Claver  Added code to check the return value from the add customer statement
								 function and display a message if it failed.
*****************************************************************************************/
Integer l_nRV

l_nRV = fu_AddCustomerStmt (Drag_DW)

IF l_nRV < 1 THEN
	MessageBox( gs_AppName, "Unable to add the case note to the note field" )
END IF

// return error to prevent the rest of the default Drag/Drop processing.
Error.i_FWError = c_Fatal
end event

event pcd_validaterow;call super::pcd_validaterow;/*****************************************************************************************
   Event:      pcd_validaterow
   Purpose:    validate the datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/09/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nNoteConfidLevel, l_nRtn
STRING	l_cNoteText

IF NOT in_save THEN
	
	l_cNoteText = GetItemString (row_nbr, 'note_text')
	IF IsNull (l_cNoteText) OR l_cNoteText = '' THEN
		
		MessageBox (gs_appname, 'You must specify text to save the current case note.')
		THIS.SetColumn( "note_text" )
		THIS.SetFocus( )
		Error.i_FWError = c_Fatal
		
	ELSE
		
		l_nNoteConfidLevel = GetItemNumber (i_CursorRow, 'note_security_level')
		IF i_wParentWindow.i_nRepConfidLevel < l_nNoteConfidLevel THEN
			l_nRtn = MessageBox (gs_appname, &
							'The security level for this case note will be higher than your current~r~n'+ &
							'security - you will not be permitted to access this record.  Are you~r~n'+ &
							'sure you want to do this?', Question!, YesNo!)
			IF l_nRtn = 1 THEN
				Error.i_FWError = c_Success
			ELSE
				Error.i_FWError = c_Fatal
			END IF
		ELSE
			Error.i_FWError = c_Success
		END IF

	END IF
	
END IF
end event

event editchanged;call super::editchanged;// 1/30/2009 - RAP, took this out because the note is now a text field, so there is no longer a real limit on its size
// 4/28 2009 - RAP, put back in because of the problems with the case detail history report
long ll_length

ll_length = Len(data)

If ll_length > 3099 and ib_shown_note_msg = FALSE Then
	gn_globals.in_messagebox.of_messagebox('You have entered a note that is ' + string(ll_length) + ' characters long. This is larger than the recommended maximum number of characters (3100). You can save the case note, but you may experience problems when viewing the note or when printing the Case Detail History Report.', Information!, OK!, 1)
	ib_shown_note_msg = TRUE
End If
end event

event constructor;call super::constructor;string ls_nuthin
ls_nuthin = ''
end event

type gb_note_entry from groupbox within u_case_details
integer x = 23
integer y = 8
integer width = 3534
integer height = 668
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Note Entry"
end type

event constructor;string ls_nuthin
ls_nuthin = ''
end event

