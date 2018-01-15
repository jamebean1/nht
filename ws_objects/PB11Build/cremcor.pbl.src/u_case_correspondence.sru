$PBExportHeader$u_case_correspondence.sru
$PBExportComments$Case Correspondence User Object
forward
global type u_case_correspondence from u_container_std
end type
type cb_view_history from commandbutton within u_case_correspondence
end type
type cbx_hrd_cpy_filed from checkbox within u_case_correspondence
end type
type dw_correspondence_list from u_dw_std within u_case_correspondence
end type
type dw_correspondence_detail from u_dw_std within u_case_correspondence
end type
end forward

global type u_case_correspondence from u_container_std
integer width = 3575
integer height = 1592
long backcolor = 79748288
boolean i_loadcodetable = false
boolean i_bringtotop = false
cb_view_history cb_view_history
cbx_hrd_cpy_filed cbx_hrd_cpy_filed
dw_correspondence_list dw_correspondence_list
dw_correspondence_detail dw_correspondence_detail
end type
global u_case_correspondence u_case_correspondence

type variables
BOOLEAN					i_bCreateReminder
BOOLEAN					i_bPrintSurvey
BOOLEAN					i_bUpdateDocImage
BOOLEAN 					i_bDetailSaved = FALSE

BLOB						i_blbDocImage

STRING					i_cCorrespondenceID

STRING					i_cToCaseSubject = 'S'
STRING					i_cToContactPerson = 'C'
STRING					i_cToOther = 'O'

STRING					i_cEditStandard = 'S'
STRING					i_cEditManual = 'M'

STRING					i_cSurveyType = 'S'
STRING					i_cLetterType = 'L'

STRING					i_cReminderDate
STRING					i_cReminderComments
STRING					i_cCaseReminderType = '1'

STRING					i_cTemplateFile

DATASTORE				i_dsContacts

U_CORRESPONDENCE_MGR	i_uoDocMgr

W_CREATE_MAINTAIN_CASE	i_wParentWindow
end variables

forward prototypes
public subroutine fu_setaddresstolist ()
public subroutine fu_addresseditable (boolean a_beditable)
public subroutine fu_activateinterface ()
public function integer fu_setlettersfilter (datawindowchild a_dwclist, string a_clettersurvey, string a_cletterid, string a_ccasetype, string a_csourcetype)
end prototypes

public subroutine fu_setaddresstolist ();/*****************************************************************************************
   Function:   fu_SetAddressToList
   Purpose:  	Define which options are allowed in the Address To dropdown listbox.
   Parameters: None
   Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/06/01 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nIndex
LONG		l_nRowCount, l_nRow
STRING	l_cSQLSyntax, l_cDWSyntax, l_cErrorMsg, l_cContactID
STRING	l_cFullName, l_cLName, l_cFName, l_cMI

// clear the current value list for the Address To field
dw_correspondence_detail.ClearValues ('corspnd_address_to_type')

// determine if there are contacts assigned to case and prepare to add them to the dropdown list
IF NOT IsValid (i_dsContacts) THEN
	i_dsContacts = CREATE DATASTORE
END IF
l_cSQLSyntax = 'SELECT contact_person_id, contact_last_name, contact_first_name, contact_mi, ' + &
								'contact_address_1, contact_address_2, contact_city, contact_state, ' + &
								'contact_zip, contact_country, contact_primary_yn ' + &
					'FROM cusfocus.contact_person ' + &
					'WHERE case_number = ~'' + i_wParentWindow.i_cCurrentCase + '~' ' + &
					'ORDER BY contact_primary_yn DESC, contact_last_name ASC, contact_first_name ASC'

l_cDWSyntax = SQLCA.SyntaxFromSQL (l_cSQLSyntax, '', l_cErrorMsg)
IF Len (l_cErrorMsg) = 0 THEN

	i_dsContacts.Create (l_cDWSyntax, l_cErrorMsg)
	
	IF Len (l_cErrorMsg) = 0 THEN
		i_dsContacts.SetTransObject (SQLCA)
		l_nRowCount = i_dsContacts.Retrieve ()
	ELSE
		l_nRowCount = 0
	END IF
	
ELSE
	l_nRowCount = 0
END IF

// add the values back as needed
l_nIndex = 1
dw_correspondence_detail.SetValue ('corspnd_address_to_type', l_nIndex, 'Case Subject~tS')

FOR l_nRow = 1 TO l_nRowCount
	
	// Add contact person entry
	l_nIndex ++
	l_cContactID = i_dsContacts.GetItemString (l_nRow, 'contact_person_id')
	l_cLName = i_dsContacts.GetItemString (l_nRow, 'contact_last_name')
		IF IsNull (l_cLName) THEN l_cLName = ''
	l_cFName = i_dsContacts.GetItemString (l_nRow, 'contact_first_name')
		IF IsNull (l_cFName) THEN l_cFName = ''
	l_cMI = i_dsContacts.GetItemString (l_nRow, 'contact_mi')
		IF IsNull (l_cMI) THEN l_cMI = ''
		
	l_cFullName = l_cLName + ', ' + l_cFName + ' ' + l_cMI
	IF l_nRow = 1 THEN
		l_cFullName = l_cFullName + ' (Primary Contact)'
	ELSE
		l_cFullName = l_cFullName + ' (Contact Person)'
	END IF
	
	dw_correspondence_detail.SetValue ('corspnd_address_to_type', l_nIndex, l_cFullName + '~t' + l_cContactID)
	
NEXT

l_nIndex ++
dw_correspondence_detail.SetValue ('corspnd_address_to_type', l_nIndex, 'Other~tO')
end subroutine

public subroutine fu_addresseditable (boolean a_beditable);/*****************************************************************************************
   Function:   fu_AddressEditable
   Purpose:    Enable or disable the address fields of the correspondence detail view.
   Parameters: BOOLEAN	a_editable - TRUE (fields are editable)
												 FALSE (fields are locked)
   Returns:    None

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/06/01 M. Caruso    Created.
	04/04/02 M. Caruso    Changed method of color control from Transparent/Opaque to
								 changing the background color to correct display issues.
*****************************************************************************************/

CONSTANT	LONG	l_nColorOn = 16777215
CONSTANT	LONG	l_nColorOff = 79741120
CONSTANT	INTEGER	l_nUnprotected = 0
CONSTANT	INTEGER	l_nProtected = 1

LONG	l_nProtection, l_nColor

IF a_bEditable THEN
	
	l_nProtection = l_nUnprotected
	l_nColor = l_nColorOn
	
ELSE
	
	l_nProtection = l_nProtected
	l_nColor = l_nColorOff
	
END IF

dw_correspondence_detail.Object.corspnd_address_name.Protect = l_nProtection
dw_correspondence_detail.Object.corspnd_address_name.background.color = l_nColor
dw_correspondence_detail.Object.corspnd_address_1.Protect = l_nProtection
dw_correspondence_detail.Object.corspnd_address_1.background.color = l_nColor
dw_correspondence_detail.Object.corspnd_address_2.Protect = l_nProtection
dw_correspondence_detail.Object.corspnd_address_2.background.color = l_nColor
dw_correspondence_detail.Object.corspnd_city.Protect = l_nProtection
dw_correspondence_detail.Object.corspnd_city.background.color = l_nColor
dw_correspondence_detail.Object.corspnd_state.Protect = l_nProtection
dw_correspondence_detail.Object.corspnd_state.background.color = l_nColor
dw_correspondence_detail.Object.corspnd_zip.Protect = l_nProtection
dw_correspondence_detail.Object.corspnd_zip.background.color = l_nColor
dw_correspondence_detail.Object.corspnd_country.Protect = l_nProtection
dw_correspondence_detail.Object.corspnd_country.background.color = l_nColor
end subroutine

public subroutine fu_activateinterface ();/*****************************************************************************************
   Function:   fu_activateinterface
   Purpose:    Enable or disable reminder manipulation based on case status
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/09/01 M. Caruso    Created.
	05/31/01 M. Caruso    Added code to disable the datawindow if the document has already
								 been printed.
	06/08/01 M. Caruso    Corrected when some of the menu items are available.
	07/09/01 M. Caruso    Coded the status control of m_deletecasereminders.
	12/19/01 M. Caruso    Updated to work with the new interface.
	12/20/01 M. Caruso    Call fu_AddressEditable to set status of address info fields.
	01/30/02 M. Caruso    Corrected enabling of "edit correspondence" menu item.
	02/06/02 M. Caruso    Enable/Diable Hard Copy Filed checkbox and View History button.
	02/07/02 M. Caruso    If the case is open, set ENABLED to FALSE if detail rows = 0.
	                      Otherwise, set ENABLED based on Sent value.
	02/28/02 M. Caruso    Enable the Hard Copy Filed check box if list items exist and the
								 current list item has been printed.
	03/01/02 M. Caruso    Corrected the logic for enabling the Hard Copy Filed check box.
	03/05/02 M. Caruso    Base Printed check on Last Printed field of the list datawindow.
	03/13/02 K. Claver    Added conditions to enable/disable edit/delete controls depending
								 on the case lock status.
	03/21/02 M. Caruso    Disable all of the address information fields once a document is
								 filled.
	04/02/02 M. Caruso    Modified the code to leave the edit correspondence button enabled
								 for surveys.
	04/04/02 M. Caruso    Removed code to manipulate status of Sent and Print date fields.
								 Also removed code to set the color of the Batch and Response
								 Req'd check box fields.  Then changed method of color control
								 from Transparent/Opaque to changing the background color to
								 correct display issues.
	05/23/02 M. Caruso    Corrected menu item settings for voided cases.
	02/26/03 M. Caruso    Set the Save menu item as enabled for all case statuses.
*****************************************************************************************/

CONSTANT	LONG	l_nColorOn = 16777215
CONSTANT	LONG	l_nColorOff = 79741120
CONSTANT LONG	l_nUnprotected = 0
CONSTANT LONG	l_nProtected = 1

BOOLEAN	l_bEnabled, l_bAllowAddrChange
LONG		l_nStatus, l_nStatus2, l_nStatus3, l_nColor, l_nColor2, l_nColor3, l_nDetailRows, l_nListRows, l_nBGMode, l_nBGMode2
STRING	l_cAddressTo, l_cFilled, ls_cUserLogin, ls_edit_sent_corrspndnce
DATETIME	l_dtSent, l_dtPrinted

l_nDetailRows = dw_correspondence_detail.RowCount ()
l_nListRows = dw_correspondence_list.GetRow ()

// set the status and color values based on case status
CHOOSE CASE i_wParentWindow.i_uoCaseDetails.i_cCaseStatus
	CASE i_wParentWindow.i_cStatusOpen
		IF l_nDetailRows = 0 THEN
			//-----------------------------------------------------------------------------------------------------------------------------------
			// JWhite 1/3/06 - Adding a check to enable the button if the user is in the "Edit Closed Case" role in the registry.
			//-----------------------------------------------------------------------------------------------------------------------------------
			If i_wParentWindow.i_bSupervisorRole = TRUE Then 
				l_bEnabled = TRUE
			Else
				l_bEnabled = FALSE
			End If
			cbx_hrd_cpy_filed.Enabled = FALSE
		ELSE
			l_dtSent = dw_correspondence_detail.GetItemDateTime (1, 'correspondence_corspnd_sent')
			l_bEnabled = IsNull (l_dtSent)
			//Check if the record is a new record before locking the record down if the case is locked
			IF THIS.i_bDetailSaved AND THIS.i_wParentWindow.i_bCaseLocked THEN
				l_bEnabled = FALSE
			END IF
			l_dtPrinted = dw_correspondence_detail.GetItemDateTime (1, 'correspondence_corspnd_prnt_date')
			IF IsNull (l_dtPrinted) THEN
				cbx_hrd_cpy_filed.Enabled = FALSE
			ELSE
				cbx_hrd_cpy_filed.Enabled = TRUE
			END IF
		END IF
		
		IF l_bEnabled THEN
			// enable the datawindow if the document has not been sent.
			l_nStatus3 = l_nUnprotected
			l_nColor3 = l_nColorOn
			
			// disable the datawindow if the document has been saved.
			IF THIS.i_bDetailSaved THEN
				l_nStatus = l_nProtected
				l_nColor = l_nColorOff
			ELSE
				l_nStatus = l_nUnprotected
				l_nColor = l_nColorOn
			END IF
			
			// determine if certain fields should be locked based on the filled status.
			If l_nDetailRows > 0 AND l_nListRows > 0 Then 
				l_cFilled = dw_correspondence_detail.GetItemString (1, 'correspondence_corspnd_doc_filled')
			End If
			
			IF l_cFilled = 'Y' THEN
				l_bAllowAddrChange = FALSE
			ELSE
				l_bAllowAddrChange = TRUE
			END IF
			
			IF l_bAllowAddrChange THEN
				l_nStatus2 = l_nUnprotected
				l_nColor2 = l_nColorOn
			ELSE
				l_nStatus2 = l_nProtected
				l_nColor2 = l_nColorOff
			END IF
		ELSE
			// disable the datawindow if the document has been sent.
			l_nStatus = l_nProtected
			l_nColor = l_nColorOff
			l_nStatus2 = l_nProtected
			l_nColor2 = l_nColorOff
			l_nStatus3 = l_nProtected
			l_nColor3 = l_nColorOff
			l_bAllowAddrChange = FALSE
		END IF
//		IF THIS.i_wParentWindow.i_bCaseLocked AND NOT i_wParentWindow.i_bSupervisorRole Then 
//			m_create_maintain_case.m_file.m_new.enabled = FALSE
//		ELSE
//			m_create_maintain_case.m_file.m_new.enabled = TRUE
//		END IF
		m_create_maintain_case.m_file.m_new.enabled = TRUE
		m_create_maintain_case.m_file.m_save.enabled = TRUE
		
	CASE ELSE  // closed or voided
		//-----------------------------------------------------------------------------------------------------------------------------------
		// JWhite 1/3/06 - Adding a check to enable the button if the user is in the "Edit Closed Case" role in the registry.
		//-----------------------------------------------------------------------------------------------------------------------------------
		If i_wParentWindow.i_bSupervisorRole = TRUE Then 
			l_bEnabled = TRUE
			l_nStatus = l_nUnprotected
			l_nColor = l_nColorOn
			l_nStatus2 = l_nUnprotected
			l_nColor2 = l_nColorOn
			l_nStatus3 = l_nUnprotected
			l_nColor3 = l_nColorOn
			l_bAllowAddrChange = TRUE
			m_create_maintain_case.m_file.m_new.enabled = TRUE
			m_create_maintain_case.m_file.m_save.enabled = TRUE
			IF l_nDetailRows > 0 AND l_nListRows > 0 Then 
				l_dtPrinted = dw_correspondence_detail.GetItemDateTime (1, 'correspondence_corspnd_prnt_date')
			ELSE
				SetNull(l_dtPrinted)
			END IF
			IF IsNull (l_dtPrinted) THEN
				cbx_hrd_cpy_filed.Enabled = FALSE
			ELSE
				cbx_hrd_cpy_filed.Enabled = TRUE
			END IF
		Else
			l_bEnabled = FALSE
			l_nStatus = l_nProtected
			l_nColor = l_nColorOff
			l_nStatus2 = l_nProtected
			l_nColor2 = l_nColorOff
			l_nStatus3 = l_nProtected
			l_nColor3 = l_nColorOff
			l_bAllowAddrChange = FALSE
			m_create_maintain_case.m_file.m_new.enabled = FALSE
			m_create_maintain_case.m_file.m_save.enabled = TRUE
			cbx_hrd_cpy_filed.Enabled = FALSE
		End If

END CHOOSE

// turn off display updating until all changes are made.
SetRedraw (FALSE)

// update the status of the datawindow fields.
dw_correspondence_detail.Object.corspnd_type.protect = l_nStatus
dw_correspondence_detail.Object.corspnd_type.background.color = l_nColor
dw_correspondence_detail.Object.correspondence_letter_id.protect = l_nStatus
dw_correspondence_detail.Object.correspondence_letter_id.background.color = l_nColor
dw_correspondence_detail.Object.corspnd_desc.protect = l_nStatus3
dw_correspondence_detail.Object.corspnd_desc.background.color = l_nColor3
dw_correspondence_detail.Object.corspnd_address_to_type.protect = l_nStatus2
dw_correspondence_detail.Object.corspnd_address_to_type.background.color = l_nColor2
dw_correspondence_detail.Object.corspnd_salutation.protect = l_nStatus2
dw_correspondence_detail.Object.corspnd_salutation.background.color = l_nColor2
dw_correspondence_detail.Object.corspnd_salutation_name.protect = l_nStatus2
dw_correspondence_detail.Object.corspnd_salutation_name.background.color = l_nColor2

// only adjust the protection status of check box fields.
dw_correspondence_detail.Object.correspondence_corspnd_batch.protect = l_nStatus3
dw_correspondence_detail.Object.corspnd_response_rqrd.protect = l_nStatus3

// set the status of the address information fields
IF l_nDetailRows > 0 AND l_nListRows > 0 THEN
	
	l_cAddressTo = dw_correspondence_detail.GetItemString (1, 'corspnd_address_to_type')
	IF l_bEnabled AND l_cAddressTo = 'O' AND l_bAllowAddrChange THEN
		//Don't allow edit if case locked
		IF THIS.i_wParentWindow.i_bCaseLocked THEN
			fu_AddressEditable (FALSE)
		ELSE
			fu_AddressEditable (TRUE)
		END IF
	ELSE
		fu_AddressEditable (FALSE)
	END IF
	
END IF

// update the status of the menu items
IF l_bEnabled THEN
	IF l_nListRows = 0 THEN
		m_create_maintain_case.m_file.m_print.Enabled = FALSE
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = FALSE
		cb_view_history.Enabled = FALSE
	ELSE
		//Don't allow to print or delete if the case is locked
		IF THIS.i_wParentWindow.i_bCaseLocked THEN
			m_create_maintain_case.m_file.m_print.Enabled = FALSE
			m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
		ELSE
			m_create_maintain_case.m_file.m_print.Enabled = TRUE
			m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = TRUE
		END IF	
			
		m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = TRUE
		cb_view_history.Enabled = TRUE
	END IF
ELSE
	IF l_nListRows = 0 THEN
		m_create_maintain_case.m_file.m_print.Enabled = FALSE
		cb_view_history.Enabled = FALSE
	ELSE
		IF i_wParentWindow.i_uoCaseDetails.i_cCaseStatus = i_wParentWindow.i_cStatusVoid THEN
			// for voided cases, these options should be turned off.
			m_create_maintain_case.m_file.m_print.Enabled = FALSE
			m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = FALSE
			m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
			cb_view_history.Enabled = TRUE
		ELSE
			IF i_wParentWindow.i_bCaseLocked THEN
				m_create_maintain_case.m_file.m_print.Enabled = FALSE
			ELSE
				m_create_maintain_case.m_file.m_print.Enabled = TRUE
			END IF
			cb_view_history.Enabled = TRUE
			// edit menu item should still be available to review the document without printing.
			m_create_maintain_case.m_edit.m_editcorrespondence.Enabled = TRUE
			m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
		END IF
	END IF
	
END IF

//IF l_nDetailRows > 0 THEN
//	ls_cUserLogin = OBJCA.WIN.fu_GetLogin (SQLCA)
//  
//	If	lower(ls_cUserLogin) = 'cfadmin' Then 
//		ls_edit_sent_corrspndnce = 'Y'
//	ELSE
//	  SELECT cusfocus.cusfocus_user.edit_sent_crrspndnce  
//		 INTO :ls_edit_sent_corrspndnce
//		 FROM cusfocus.cusfocus_user  
//		WHERE cusfocus.cusfocus_user.user_id =  :ls_cUserLogin  
//		  ;
//	END IF	  
//	
//	l_dtPrinted = dw_correspondence_detail.GetItemDateTime (1, 'correspondence_corspnd_prnt_date')
//	IF IsNull (l_dtPrinted) THEN
//		cbx_hrd_cpy_filed.Enabled = FALSE
//	ELSE
//		//Don't allow to check if case locked
//		IF i_wParentWindow.i_bCaseLocked THEN
//			cbx_hrd_cpy_filed.Enabled = FALSE
//		ELSE
//			IF ls_edit_sent_corrspndnce = 'Y' THEN
//				cbx_hrd_cpy_filed.Enabled = TRUE
//			ELSE
//				cbx_hrd_cpy_filed.Enabled = FALSE
//			END IF
//		END IF
//	END IF
//ELSE
//	cbx_hrd_cpy_filed.Enabled = FALSE
//END IF

// update the display
SetRedraw (TRUE)
end subroutine

public function integer fu_setlettersfilter (datawindowchild a_dwclist, string a_clettersurvey, string a_cletterid, string a_ccasetype, string a_csourcetype);/*****************************************************************************************
   Function:   fu_SetLettersFilter
   Purpose:    Filter the letters drop down list
   Parameters: DATAWINDOWCHILD	a_dwcList - The dropdown datawindow to filter.
					STRING	a_cLetterSurvey - (Y/N) Is the correspondence a survey?
					STRING	a_cLetterID - The ID of the current correspondence.
					STRING	a_cCaseType	- The type of case this correspondence is associated with.
					STRING	a_cSourceType - The type of member this case is opened for.
   Returns:    INTEGER	1 - Filter applied successfully.
							  -1 - An error occured applying the filter.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/06/02 M. Caruso    Created.
	04/22/02 M. Caruso    Modified to display the name of a letter that was set even though
								 it no longer passes the regular selection criteria.
	02/28/03 M. Caruso    Added new filter for use when a_cLetterID = '' (the doc is new).
*****************************************************************************************/
INTEGER l_nReturn

IF a_cLetterID = '' THEN
	l_nReturn = a_dwcList.SetFilter("((letter_survey = '" + a_cLetterSurvey + "') AND (active = 'Y') AND " + &
									"(case_types LIKE '%" + a_cCaseType + "%') AND " + &
									"(source_types LIKE '%" + a_cSourceType + "%'))")
ELSE
	l_nReturn = a_dwcList.SetFilter("((letter_survey = '" + a_cLetterSurvey + "') AND (active = 'Y') AND " + &
									"(case_types LIKE '%" + a_cCaseType + "%') AND " + &
									"(source_types LIKE '%" + a_cSourceType + "%')) OR " + &
									"(letter_id = '" + a_cLetterID + "')")
END IF

RETURN l_nReturn
end function

on u_case_correspondence.create
int iCurrent
call super::create
this.cb_view_history=create cb_view_history
this.cbx_hrd_cpy_filed=create cbx_hrd_cpy_filed
this.dw_correspondence_list=create dw_correspondence_list
this.dw_correspondence_detail=create dw_correspondence_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_view_history
this.Control[iCurrent+2]=this.cbx_hrd_cpy_filed
this.Control[iCurrent+3]=this.dw_correspondence_list
this.Control[iCurrent+4]=this.dw_correspondence_detail
end on

on u_case_correspondence.destroy
call super::destroy
destroy(this.cb_view_history)
destroy(this.cbx_hrd_cpy_filed)
destroy(this.dw_correspondence_list)
destroy(this.dw_correspondence_detail)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    initialize the options for this container object

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/22/00 M. Caruso    Created to initialize the resize service.
	04/13/01 K. Claver    Fixed the resize code.
	12/28/01 M. Caruso    Initialize i_bUpdateDocImage.
	03/28/02 M. Caruso    Added code to set i_bCaseLocked in l_uoDocMgr based on
								 i_bCaseLocked in this window.
	6/4/2002 K. Claver    Added resize code for the detail datawindow, view history button and
								 hard copy filed checkbox.
*****************************************************************************************/

INTEGER	l_nNewHeight, l_nNewWidth, l_nNewX, l_nNewY
DECIMAL	l_nHeightOffset, l_nWidthOffset

// instantiate the correspondence manager, if not already done
IF NOT IsValid( i_uoDocMgr ) THEN
	i_uoDocMgr = CREATE U_CORRESPONDENCE_MGR
END IF

i_uoDocMgr.i_bCaseLocked = i_wParentWindow.i_bCaseLocked
i_uoDocMgr.i_dwRefreshDW = dw_correspondence_detail

of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	
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
	
	//Register this control with the resize service
	i_wParentWindow.inv_resize.of_Register (THIS, "ScaleToRight&Bottom")
	// initialize the container and register it with the parent window.
	l_nNewHeight = 1600 + l_nHeightOffset
	l_nNewWidth = 3579 + l_nWidthOffSet
	Resize (l_nNewWidth, l_nNewHeight)
	
	// initialize the reminder history datawindow.
	inv_resize.of_Register (dw_correspondence_list, "ScaleToRight&Bottom")
	l_nNewHeight = dw_correspondence_list.Height + l_nHeightOffset
	l_nNewWidth = dw_correspondence_list.Width + l_nWidthOffset
	dw_correspondence_list.resize (l_nNewWidth, l_nNewHeight)
	
	//Initialize the rest of the controls
	i_wParentWindow.inv_resize.of_Register (dw_correspondence_detail, i_wParentWindow.inv_resize.FIXEDBOTTOM_SCALERIGHT)
	l_nNewX = dw_correspondence_detail.X
	l_nNewY = dw_correspondence_detail.Y + l_nHeightOffset
	dw_correspondence_detail.Move (l_nNewX, l_nNewY)
		
	i_wParentWindow.inv_resize.of_Register (cb_view_history, i_wParentWindow.inv_resize.FIXEDRIGHTBOTTOM)
	l_nNewX = cb_view_history.X + l_nWidthOffset
	l_nNewY = cb_view_history.Y + l_nHeightOffset
	cb_view_history.Move (l_nNewX, l_nNewY)
	
	i_wParentWindow.inv_resize.of_Register (cbx_hrd_cpy_filed, i_wParentWindow.inv_resize.FIXEDBOTTOM)
	l_nNewX = cbx_hrd_cpy_filed.X
	l_nNewY = cbx_hrd_cpy_filed.Y + l_nHeightOffset
	cbx_hrd_cpy_filed.Move (l_nNewX, l_nNewY)	
END IF

i_bUpdateDocImage = FALSE

end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_Close
   Purpose:    Perform clean up.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/08/01 M. Caruso    Created.
*****************************************************************************************/

IF IsValid (i_uoDocMgr) THEN DESTROY i_uoDocMgr

end event

type cb_view_history from commandbutton within u_case_correspondence
integer x = 3081
integer y = 1456
integer width = 448
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "View History"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the user clicking the button.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/04/02 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cCorrespondenceID

l_cCorrespondenceID = dw_correspondence_detail.GetItemString (1, 'correspondence_id')
FWCA.MGR.fu_OpenWindow (w_correspondence_history, l_cCorrespondenceID)
end event

type cbx_hrd_cpy_filed from checkbox within u_case_correspondence
integer x = 101
integer y = 1448
integer width = 526
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hard Copy Filed:"
boolean lefttext = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the user clicking the check box.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/04/02 M. Caruso    Created.
*****************************************************************************************/

// set the Hard Copy Filed field of the detail datawindow according to the new state.
IF Checked THEN
	dw_correspondence_detail.SetItem (1, 'corspnd_hrd_cpy_filed', 'Y')
ELSE
	dw_correspondence_detail.SetItem (1, 'corspnd_hrd_cpy_filed', 'N')
END IF
end event

type dw_correspondence_list from u_dw_std within u_case_correspondence
event ue_edittrigger pbm_dwnkey
event ue_destroy_manager ( )
integer x = 27
integer y = 12
integer width = 3506
integer height = 572
integer taborder = 10
string dataobject = "d_correspondence_history"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_edittrigger;/**************************************************************************************
	Event:	ue_edittrigger
	Purpose:	When ENTER is pressed, open the document for editing if it is a manual edit
				letter.

	Revisions:
	Date     Developer     Description
	======== ============= ============================================================
	08/24/01 M. Caruso     Created.
	08/31/01 M. Caruso     Added code to prevent editing of already printed docs.
	11/26/01 M. Caruso     Do not process ENTER if no rows exist.
	12/09/01 M. Caruso     Do not process ENTER if no row is selected.
	05/24/02 M. Caruso     Only process if the menu item is enabled.
*************************************************************************************/

LONG	l_nRow
STRING	l_cEditType, ls_DocID
DATETIME	l_dtPrintDate

CHOOSE CASE key
	CASE KeyEnter!
		IF RowCount () > 0 THEN
		
			l_nRow = GetRow ()
			IF l_nRow > 0 THEN
			
				IF m_create_maintain_case.m_edit.m_editcorrespondence.enabled THEN
					IF IsValid(i_uoDocMgr) THEN
						IF IsValid(i_uoDocMgr.i_wDocWindow) THEN
							ls_DocID = i_uoDocMgr.i_sCurrentDocInfo.a_cDocID
							IF ls_DocID <> THIS.Object.correspondence_id[THIS.Getrow()] THEN
								THIS.EVENT ue_destroy_manager()
							END IF
						END IF
					END IF
					
					m_create_maintain_case.m_edit.m_editcorrespondence.TriggerEvent (clicked!)
					
				END IF
				
			END IF
		
		END IF
		
		// prevent row change due to ENTER key press.
		RETURN 1
	
END CHOOSE
end event

event ue_destroy_manager();IF IsValid(i_uoDocMgr) THEN
	DESTROY i_uoDocMgr
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/**************************************************************************************
	Event:	pcd_retrieve
	Purpose:	To retrieve the data 

	Revisions:
	Date     Developer     Description
	======== ============= ============================================================
	02/06/02 M. Caruso     Call fu_activateinterface if no rows are retrieved.
	03/05/02 M. Caruso     Call fu_activateinterface if retrieval is successful,
								  regardless of the record count.
	6/4/2002 K. Claver     Moved resize code here to ensure that the line is resized
								  if the create maintain case window is maximized before the
								  parent object is initialized.
*************************************************************************************/

LONG l_nReturn, ll_row
String ls_DocID

l_nReturn = Retrieve(i_wParentWIndow.i_cSelectedCase)

CHOOSE CASE l_nReturn
	CASE IS < 0
	 	Error.i_FWError = c_Fatal
		 
	CASE ELSE
		fu_activateinterface ()
		 
END CHOOSE

of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	inv_resize.of_Register( "l_2", inv_resize.SCALERIGHT )
END IF

//IF l_nReturn > 0 THEN
//	// If there is an open correspondence, try to find the row it goes to
//	IF IsValid(i_uoDocMgr) THEN
//		IF IsValid(i_uoDocMgr.i_wDocWindow) THEN
//			ls_DocID = i_uoDocMgr.i_sCurrentDocInfo.a_cDocID
//			IF ls_DocID <> THIS.Object.correspondence_id[1] THEN
//				ll_row = THIS.Find("correspondence_id = '" + ls_DocID + "'", 1, THIS.RowCount()) 
//				IF ll_row > 0 THEN
//					THIS.Scrolltorow(ll_row)
//				ELSE
//					THIS.EVENT ue_destroy_manager()
//				END IF
//			END IF
//		END IF
//	END IF
//END IF


end event

event pcd_savebefore;/***************************************************************************************
	Event:	pcd_savebefore
	Purpose:	To check the Correspondence record prior to updating.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	07/10/01 M. Caruso     Only process this code is a detail row exists.
	02/08/02 M. Caruso     Moved Response Required implementation to u_correspondence_mgr.
***************************************************************************************/

STRING	l_cValue

IF dw_correspondence_detail.RowCount () > 0 THEN
	
	//-------------------------------------------------------------------------------------
	//
	//		Check to make sure the user entered a Letter Category prior to Saving.  If not,
	//		inform them of this and jet out of saving the record.
	//
	//-------------------------------------------------------------------------------------
	
	l_cValue = dw_correspondence_detail.GetItemString (dw_correspondence_detail.i_CursorRow, 'correspondence_letter_id')
	IF IsNull(l_cValue) OR l_cValue = '' THEN
		MessageBox(gs_AppName, 'You must specify the Document prior to saving.')
		Error.i_FWError = c_Fatal
		RETURN
	END IF
	
	//---------------------------------------------------------------------------------------
	//
	//		If the user has set the Response Required flag, then prompt them for a Remidner 
	//		date.  If they do not supply a reminder date, then un-set the Response Required
	//		flag and save the record.
	//
	//--------------------------------------------------------------------------------------
	
//	IF dw_correspondence_detail.GetItemString(dw_correspondence_detail.i_CursorRow, &
//		'corspnd_response_rqrd') = 'Y' THEN
//		FWCA.MGR.fu_OpenWindow(w_set_reminder_date, 0)
//	
//		IF PCCA.Parm[1] = '' THEN
//			dw_correspondence_detail.SEtItem(dw_correspondence_detail.i_CursorRow, &
//				'corspnd_response_rqrd', 'N')
//		ELSE
//			i_cReminderDate = PCCA.Parm[1]
//			i_cReminderComments = PCCA.Parm[2]
//			i_bCreateReminder = TRUE
//		END IF
//	END IF
	
END IF
end event

event pcd_saveafter;//********************************************************************************************
//
//  Event:		pcd_saveafter
//  Purpose:  To create a Reminder if the Response Requried flag is set.
//			
//  Date     Developer     Description
//  -------- ------------ -----------------------------------------------------------------
//  8/3/99   M. Caruso    Corrected the INSERT statement by adding a ')' to the end of it.
//  04/12/00 C. Jackson   Add column into insert to set default for reminder_viewed column
//                        (SCR 513)
//  10/06/00 C. Jackson   Changed call to fw_getkeyvalue to add table name.
//  02/08/02 M. Caruso    Moved implementation to u_correspondence_mgr
//********************************************************************************************

//STRING l_cReminderID, l_cUserID
//DATE   l_dCreateDate, l_dReminderDate
//
//l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)
//
//IF i_bCreateReminder THEN
//	i_bCreateReminder = FALSE
//	l_cReminderID = i_wParentWindow.fw_getkeyvalue('reminders')
//	l_dCreateDate = Date(i_wParentWindow.fw_gettimestamp())
//	l_dReminderDate = Date(i_cReminderDate)
//	INSERT INTO cusfocus.reminders (reminder_id, reminder_type_id, reminder_viewed, case_number, case_type,
//			case_reminder, reminder_crtd_date, reminder_set_date, reminder_subject, 
//			reminder_comments, reminder_dlt_case_clsd, reminder_author, reminder_recipient)
//			VALUES (:l_cReminderID, :i_cCaseReminderType, 'N', :i_wParentWIndow.i_cSelectedCase, 
//			:i_wParentWindow.i_cCaseType, 'Y', :l_dCreateDate, :l_dReminderDate, 
//			'Response Rqrd Correspondence', :i_cReminderComments, 'Y', :l_cUserID, 
// 			:l_cUserID);
//	IF SQLCA.SQLCode <> 0 THEN
//		MessageBox(gs_AppName, 'Unable to create Reminder.')
//		MessageBox(STRING(SQLCA.SQLDBCOde), SQLCA.SQLErrText)
//		ROLLBACK;
//	ELSE
//		COMMIT;
//	END IF
//END IF		
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize the datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/22/00 M. Caruso    Created to add resizing code.
	6/4/2002 K. Claver    Moved resize code to the pcd_retrieve event of this datawindow
								 to ensure that the datawindow is fully initialized before resize the
								 line.
*****************************************************************************************/

// enable resizing of separator line
//of_SetResize (TRUE)
//IF IsValid (inv_resize) THEN
//	inv_resize.of_Register( "l_2", inv_resize.SCALERIGHT )
//END IF
end event

event doubleclicked;call super::doubleclicked;/**************************************************************************************
	Event:	doubleclicked
	Purpose:	Open the document for editing if it is a manual edit letter.

	Revisions:
	Date     Developer     Description
	======== ============= ============================================================
	08/24/01 M. Caruso     Created.
	08/31/01 M. Caruso     Added code to prevent editing of already printed docs.
	11/26/01 M. Caruso     Do not process if no rows exist.
	12/09/01 M. Caruso     Do not process if the user did not click on a row.
	05/24/02 M. Caruso     Only process if the menu item is enabled.
*************************************************************************************/

STRING	l_cEditType, ls_DocID
DATETIME	l_dtPrintDate

IF (RowCount () > 0) AND (row > 0) THEN
	IF m_create_maintain_case.m_edit.m_editcorrespondence.Enabled THEN		
		IF IsValid(i_uoDocMgr) THEN
			IF IsValid(i_uoDocMgr.i_wDocWindow) THEN
				ls_DocID = i_uoDocMgr.i_sCurrentDocInfo.a_cDocID
				IF ls_DocID <> THIS.Object.correspondence_id[row] THEN
					THIS.EVENT ue_destroy_manager()
				END IF
			END IF
		END IF
		m_create_maintain_case.m_edit.m_editcorrespondence.PostEvent (clicked!)
	END IF
END IF
end event

type dw_correspondence_detail from u_dw_std within u_case_correspondence
integer x = 23
integer y = 588
integer width = 3515
integer height = 828
integer taborder = 20
string dataobject = "d_correspondence_detail"
boolean maxbox = true
boolean border = false
end type

event itemchanged;call super::itemchanged;/****************************************************************************************
	Event:	itemchanged
	Purpose:	To set values for particular fields if other fields are changed.

	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	04/10/01 M. Caruso     Modified code to set print menu item active regardless of edit
								  type.
	06/04/01 M. Caruso     Corrected filtering of letter_id DropDown Datawindow.
	10/15/01 M. Caruso     If contact person does not apply, prevent selection of that option.
	12/19/01 M. Caruso     Updated processing for corspnd_type field to work in new interface.
	01/02/02 M. Caruso     Loads the master document image when the letter_id field changes.
	01/03/02 M. Caruso     Updated dddw filter syntax to include case_types and source_types.
	01/09/02 M. Caruso     Update document edit type based on document type.
	02/06/02 M. Caruso     Call fu_SetLettersFilter to filter the Letters DropDown.
	02/12/02 M. Caruso     Set letter_id to NULL if document type changes.
****************************************************************************************/

STRING 				l_cAddress1, l_cAddress2, l_cCity, l_cState, l_cZip, l_cCountry
STRING 				l_cSalutationName, l_cProviderType, l_cFirstName, l_cLastName, l_cMI
STRING				l_cAddressName, l_cLetterID, l_cLetterSurvey
LONG   				l_nSearchRow, l_nRow
DATETIME				l_dtNull
DATAWINDOWCHILD	l_dwcLetterTypes
String ls_doc_title
Integer li_return

CHOOSE CASE GetColumnName() 
	CASE 'corspnd_address_to_type' 
		// Determine what the Address To is to determine where to get the Address Information.
		CHOOSE CASE GetText()
			CASE i_cToCaseSubject
				CHOOSE CASE i_wParentWindow.i_cSourceType
					CASE i_wParentWIndow.i_cSourceConsumer
	
					SELECT consum_first_name, consum_last_name, consum_mi, consum_address_1, 
						consum_address_2, consum_city, consum_state, consum_zip, consum_country 
						INTO :l_cFirstName, :l_cLastName, :l_cMI, 
						:l_cAddress1, :l_cAddress2, :l_cCity, :l_cState, :l_cZip, :l_cCountry FROM 
						cusfocus.consumer WHERE consumer_id = :i_wParentWindow.i_cCurrentCaseSubject;

					IF IsNull(l_cMI) THEN
						l_cMI = ''
					ELSE
						l_cMI = ' ' + l_cMI
					END IF
			
					l_cSalutationName = l_cFirstName + l_cMI + ' ' + l_cLastName
					l_cAddressName = l_cSalutationName

					CASE i_wParentWindow.i_cSourceEmployer
	
						SELECT employ_address_1, employ_address_2, employ_city, employ_state, 
							employ_zip, employ_country INTO :l_cAddress1, :l_cAddress2, :l_cCity, 
							:l_cState, :l_cZip, :l_cCountry FROM cusfocus.employer_group WHERE 
							group_id = :i_wParentWindow.i_cCurrentCaseSubject;

							l_cSalutationName = i_wParentWindow.i_cCaseSubjectName
							l_cAddressName = l_cSalutationName

					CASE i_wParentWIndow.i_cSourceProvider

						SELECT provid_address_1, provid_address_2, provid_city, provid_state, 
							provid_zip, provid_country INTO :l_cAddress1, :l_cAddress2, :l_cCity, 
							:l_cState, :l_cZip, :l_cCountry FROM cusfocus.provider_of_service WHERE 
							provider_key = CONVERT(int,:i_wParentWindow.i_cCurrentCaseSubject) AND 
							provider_type = :i_wParentWindow.i_cProviderType;
						
							l_cSalutationName = i_wParentWindow.i_cCaseSubjectName
							l_cAddressName = l_cSalutationName
	
					CASE i_wParentWIndow.i_cSourceOther
						SELECT other_first_name, other_last_name, other_mi, other_address_1, 
						other_address_2, other_city, other_state, other_zip, other_country 
						INTO :l_cFirstName, :l_cLastName, :l_cMI, :l_cAddress1, 
						:l_cAddress2, :l_cCity, :l_cState, :l_cZip, :l_cCountry FROM 
						cusfocus.other_source WHERE customer_id = :i_wParentWindow.i_cCurrentCaseSubject;

						IF ISNull(l_cMI) THEN
							l_cMI = ''
						ELSE
							l_cMI = ' ' + l_cMI
						END IF
			
						l_cSalutationName = l_cFirstName + l_cMI + ' ' + l_cLastName
						l_cAddressName = l_cSalutationName

				END CHOOSE
				
				// update the interface
				fu_AddressEditable (FALSE)

			CASE i_cToOther
				l_cSalutationName = ''
				l_cAddressName = ''
				l_cAddress1 = ''
				l_cAddress2 = ''
				l_cCity = ''
				l_cState = ''	
				l_cZip = ''
				l_cCountry = ''
				
				// update the interface
				fu_AddressEditable (TRUE)
		
			CASE ELSE
				// determine which contact to use
				l_nRow = i_dsContacts.Find ('contact_person_id = ~'' + data + '~'', 1, i_dsContacts.RowCount())
				
				// gather the information for the selected contact
				l_cLastName = i_dsContacts.GetItemString (l_nRow, 'contact_last_name')
					IF IsNull (l_cLastName) THEN l_cLastName = ''
				l_cFirstName = i_dsContacts.GetItemString (l_nRow, 'contact_first_name')
					IF IsNull (l_cFirstName) THEN l_cFirstName = ''
				l_cMI = i_dsContacts.GetItemString (l_nRow, 'contact_mi')
					IF IsNull(l_cMI) THEN 
						l_cMI = ''
					ELSE
						l_cMI = ' ' + l_cMI
					END IF
				l_cAddress1 = i_dsContacts.GetItemString (l_nRow, 'contact_address_1')
					IF IsNull (l_cAddress1) THEN l_cAddress1 = ''
				l_cAddress2 = i_dsContacts.GetItemString (l_nRow, 'contact_address_2')
					IF IsNull (l_cAddress2) THEN l_cAddress2 = ''
				l_cCity = i_dsContacts.GetItemString (l_nRow, 'contact_city')
					IF IsNull (l_cCity) THEN l_cCity = ''
				l_cState = i_dsContacts.GetItemString (l_nRow, 'contact_state')
					IF IsNull (l_cState) THEN l_cState = ''
				l_cZip = i_dsContacts.GetItemString (l_nRow, 'contact_zip')
					IF IsNull (l_cZip) THEN l_cZip = ''
				l_cCountry = i_dsContacts.GetItemString (l_nRow, 'contact_country')
					IF IsNull (l_cCountry) THEN l_cCountry = ''
				
				// calculate the salutation and address name values
				l_cSalutationName = l_cFirstName + l_cMI + ' ' + l_cLastName
				l_cAddressName = l_cSalutationName
				
				// update the interface
				fu_AddressEditable (FALSE)
	
		END CHOOSE
		SetItem(i_CursorRow, 'corspnd_salutation_name', l_cSalutationName)
		SetItem(i_CursorRow, 'corspnd_address_name', l_cAddressName)
		SetItem(i_CursorRow, 'corspnd_address_1', l_cAddress1)
		SetItem(i_CursorRow, 'corspnd_address_2', l_cAddress2)
		SetItem(i_CursorRow, 'corspnd_city', l_cCity)
		SetItem(i_CursorRow, 'corspnd_state', l_cState)
		SetItem(i_CursorRow, 'corspnd_zip', l_cZip)
		SetItem(i_CursorRow, 'corspnd_country', l_cCountry)

	CASE 'corspnd_type'

		IF IsValid(i_uoDocMgr) THEN
			IF IsValid(i_uoDocMgr.i_wDocWindow) THEN
				Destroy i_uoDocMgr
			END IF
		END IF
		
		// Determine the Correspondence Type to Filter the Letter Category DropDownDataWindow.
		GetChild('correspondence_letter_id', l_dwcLetterTypes)
		l_dwcLetterTypes.SetTransObject (SQLCA)
		// clear the current filter on the list
		l_dwcLetterTypes.SetFilter ('')
		l_dwcLetterTypes.Filter ()
		l_dwcLetterTypes.Retrieve ()
				
		CHOOSE CASE GetText()
			CASE i_cLetterType
				
				w_create_maintain_case.i_bPrintSurvey = FALSE
				l_cLetterSurvey = 'N'
				SetItem (i_CursorRow, 'correspondence_corspnd_edit_type', 'M')
				
			CASE i_cSurveyType
				w_create_maintain_case.i_bPrintSurvey = TRUE
				l_cLetterSurvey = 'Y'
				SetItem (i_CursorRow, 'correspondence_corspnd_edit_type', 'S')
				
		END CHOOSE
		
		// apply new filter
		fu_SetLettersFilter (l_dwcLetterTypes, l_cLetterSurvey, l_cLetterID, &
									i_wParentWindow.i_cCaseType, i_wParentWindow.i_cSourceType)
		l_dwcLetterTypes.Filter()

		SetNull (l_cLetterID)
		SetItem(i_CursorRow, 'correspondence_letter_id', l_cLetterID)
		SetItem(i_CursorRow, 'letter_tmplt_filename', '')
	
	CASE 'correspondence_letter_id'
		IF IsValid(i_uoDocMgr) THEN
			IF IsValid(i_uoDocMgr.i_wDocWindow) THEN
				Destroy i_uoDocMgr
			END IF
		END IF
		
		//	Populate the the filename field with the selected Letter
		THIS.AcceptText()		
		GetChild('correspondence_letter_id', l_dwcLetterTypes)
		l_nSearchRow = l_dwcLetterTypes.Find("letter_id = '" + GetText() + "'", 1, &
			l_dwcLetterTypes.RowCount())
		IF l_nSearchRow > 0 THEN
			SetItem(i_CursorRow, 'letter_tmplt_filename', &
				l_dwcLetterTypes.GetItemString(l_nSearchRow, 'letter_tmplt_filename'))
		END IF
		
		l_cLetterID = THIS.GetItemString(i_CursorRow,'correspondence_letter_id')
		
		// load the associated document image and prep to save the changes
		IF Not IsValid(i_uoDocMgr) THEN
			i_uoDocMgr = CREATE U_CORRESPONDENCE_MGR
		END IF
		i_uoDocMgr.uf_GetDocImage (TRUE, l_cLetterID, i_blbDocImage)
		i_bupdatedocimage = TRUE
		
END CHOOSE
end event

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
	Event:	pcd_retrieve
	Purpose:	To retrieve the data, Filter the Letter Categories based on the value
				of the letter_survey field, and to change the Edit and Print menus
				based on the edit_type field.
				
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	04/10/01 M. Caruso     Added calls to fu_activateinterface ().
	06/04/01 M. Caruso     Corrected filtering of letter_id DropDown Datawindow.
	12/28/01 M. Caruso     Set i_bUpdateDocImage to FALSE.
	01/02/02 M. Caruso     Load associated document image for the current entry.
	01/03/02 M. Caruso     Updated dddw filter syntax to include case_types and source_types.
	01/04/02 M. Caruso     Set the status of the 'hard copy filed' checkbox.
	02/06/02 M. Caruso     Call fu_SetLettersFilter to filter the Letters DropDown.
*****************************************************************************************/
LONG l_nReturn
STRING          l_cLetterID, l_cReturn, l_cHardCopy
DATAWINDOWCHILD l_dwcLetterTypes

THIS.SetRedraw(FALSE)

SetNull (i_blbDocImage)

// instantiate the correspondence manager, if not already done
IF NOT IsValid( i_uoDocMgr ) THEN
	i_uoDocMgr = CREATE U_CORRESPONDENCE_MGR
END IF

i_cCorrespondenceID = Parent_DW.GetItemString(Selected_Rows[1], 'correspondence_id')

GetChild('correspondence_letter_id', l_dwcLetterTypes)
l_dwcLetterTypes.SetTransObject (SQLCA)
l_dwcLetterTypes.SetFilter ("")
l_dwcLetterTypes.Filter ()
l_dwcLetterTypes.Retrieve ()

l_nReturn = Retrieve(i_cCorrespondenceID)

CHOOSE CASE l_nReturn
	CASE IS < 0
	 	Error.i_FWError = c_Fatal
		i_bUpdateDocImage = FALSE
		
	CASE 0
		//Set the saved boolean.
		PARENT.i_bDetailSaved = FALSE
		
		fu_activateinterface ()
		i_bUpdateDocImage = FALSE
		
	CASE IS > 0
		//	Filter the Letter Category DropDownDataWindow based on the LetterSurvey field.
		l_cLetterID = GetItemSTring(1, 'correspondence_letter_id')
		
		IF GetItemString(1, 'corspnd_type') = i_cLetterType THEN
			w_create_maintain_case.i_bPrintSurvey  = FALSE
			fu_SetLettersFilter (l_dwcLetterTypes, 'N', l_cLetterID, &
										i_wParentWindow.i_cCaseType, i_wParentWindow.i_cSourceType)
		ELSE
			w_create_maintain_case.i_bPrintSurvey = TRUE
			fu_SetLettersFilter (l_dwcLetterTypes, 'Y', l_cLetterID, &
										i_wParentWindow.i_cCaseType, i_wParentWindow.i_cSourceType)
		END IF
		l_dwcLetterTypes.Filter()
		
		// retrieve the document image for the current entry
		IF IsValid (i_uoDocMgr) THEN
			i_uoDocMgr.uf_GetDocImage (FALSE, i_cCorrespondenceID, i_blbDocImage)
			IF IsNull (i_blbDocImage) THEN
				i_uoDocMgr.uf_GetDocImage (TRUE, l_cLetterID, i_blbDocImage)
				i_bUpdateDocImage = TRUE
			ELSE
				i_bUpdateDocImage = FALSE
			END IF
		END IF
	
		// set 'hard copy filed' checkbox.
		l_cHardCopy = GetItemString (1, 'corspnd_hrd_cpy_filed')
		IF l_cHardCopy = 'N' THEN
			cbx_hrd_cpy_filed.checked = FALSE
		ELSE
			cbx_hrd_cpy_filed.checked = TRUE
		END IF

		SetItem (1, 'correspondence_letter_id', l_cLetterID)
		SetItemStatus (1, 0, PRIMARY!, NOTMODIFIED!)
		
		// update the "address to" list
		fu_SetAddressToList ()
		
		//Set the saved boolean.
		PARENT.i_bDetailSaved = TRUE
		
		fu_activateinterface ()
		
END CHOOSE

THIS.SetRedraw(TRUE)

end event

event pcd_validatecol;call super::pcd_validatecol;/****************************************************************************************

			Event:	pcd_validatecol
			Purpose:	To verify the date entered is a valid date and to add the /'s if the
						user has not by calling the Validate_Date PowerClass function.

***************************************************************************************/

CHOOSE CASE col_name
	CASE 'case_log_prnt_date'
		Error.i_FWError = OBJCA.FIELD.fu_ValidateDate(col_text, 'm/d/yyyy', TRUE)
END CHOOSE
end event

event pcd_new;call super::pcd_new;/**************************************************************************************
	Event:	pcd_new
	Purpose:	To initialize the new correspondence record.

	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	06/04/01 M. Caruso     Corrected filtering of letter_id DropDown Datawindow.
	12/28/01 M. Caruso     Set i_bUpdateDocImage to TRUE.
	01/02/02 M. Caruso     Set i_blbDocImage to NULL.
	01/03/02 M. Caruso     Updated dddw filter syntax to include case_types and source_types.
	01/04/02 M. Caruso     Set default values for 'hard copy filed'.
	01/09/02 M. Caruso     Set default edit type to 'M'
	02/06/02 M. Caruso     Call fu_SetLettersFilter to filter the Letters DropDown. Also
	                       include the time in the created timestamp.
**************************************************************************************/

STRING          l_cAddress1, l_cAddress2, l_cCity, l_cState, l_cZip, l_cCountry
STRING          l_cProviderType, l_cFirstName, l_cLastName, l_cMI, ls_salutation
DATAWINDOWCHILD l_dwcLetterTypes

//---------------------------------------------------------------------------------------
//		Set the Provider Type and determine the Source in order to know where to get the
//		Address information.
//---------------------------------------------------------------------------------------
l_cProviderType = i_wParentWindow.i_cProviderType

// Get the last salutation that was used on this case
SELECT corspnd_salutation
INTO :ls_salutation
FROM cusfocus.correspondence
WHERE correspondence_id =
	(SELECT MAX(CONVERT(int, c.correspondence_id))
	FROM cusfocus.correspondence c
	WHERE c.case_number = :i_wParentWindow.i_cCurrentCase)
	USING SQLCA;
SetItem(i_CursorRow, 'corspnd_salutation', ls_salutation)
	
CHOOSE CASE i_wParentWindow.i_cSourceType

	CASE i_wParentWindow.i_cSourceConsumer
		SELECT consum_first_name, consum_last_name, consum_mi, consum_address_1, 
			consum_address_2, consum_city, consum_state, consum_zip, consum_country 
			INTO :l_cFirstName, :l_cLastName, :l_cMI, 
			:l_cAddress1, :l_cAddress2, :l_cCity, :l_cState, :l_cZip, :l_cCountry FROM 
			cusfocus.consumer WHERE consumer_id = :i_wParentWindow.i_cCurrentCaseSubject;
		IF ISNull(l_cMI) THEN
			l_cMI = ''
		ELSE
			l_cMI = ' ' + l_cMI
		END IF
		SetItem(i_CursorRow, 'corspnd_salutation_name', l_cFirstName + l_cMI + ' ' + &
			 l_cLastName)
		SetItem(i_CursorRow, 'corspnd_address_name', l_cFirstName + l_cMI + ' ' + &
			 l_cLastName) 

	CASE i_wParentWindow.i_cSourceEmployer
		SELECT employ_address_1, employ_address_2, employ_city, employ_state, employ_zip,
			employ_country INTO :l_cAddress1, :l_cAddress2, :l_cCity, 
			:l_cState, :l_cZip, :l_cCountry FROM cusfocus.employer_group WHERE 
			group_id = :i_wParentWindow.i_cCurrentCaseSubject;

		SetItem(i_CursorRow, 'corspnd_salutation_name', i_wParentWindow.i_cCaseSubjectName)
		SetItem(i_CursorRow, 'corspnd_address_name', i_wParentWindow.i_cCaseSubjectName) 

	CASE i_wParentWIndow.i_cSourceProvider
		SELECT provid_address_1, provid_address_2, provid_city, provid_state, 
			provid_zip, provid_country INTO :l_cAddress1, :l_cAddress2, :l_cCity, 
			:l_cState, :l_cZip, :l_cCountry FROM cusfocus.provider_of_service WHERE 
			provider_key = CONVERT(int,:i_wParentWindow.i_cCurrentCaseSubject) AND 
			provider_type = :i_wParentWindow.i_cProviderType;

		SetItem(i_CursorRow, 'corspnd_salutation_name', i_wParentWindow.i_cCaseSubjectName)
		SetItem(i_CursorRow, 'corspnd_address_name', i_wParentWindow.i_cCaseSubjectName) 
	
	CASE i_wParentWIndow.i_cSourceOther
		SELECT other_first_name, other_last_name, other_mi, other_address_1, 
			other_address_2, other_city, other_state, other_zip, other_country 
			INTO :l_cFirstName, :l_cLastName, :l_cMI, :l_cAddress1, 
			:l_cAddress2, :l_cCity, :l_cState, :l_cZip, :l_cCountry FROM 
			cusfocus.other_source WHERE customer_id = :i_wParentWindow.i_cCurrentCaseSubject;

			IF ISNull(l_cMI) THEN
				l_cMI = ''
			ELSE
				l_cMI = ' ' + l_cMI
			END IF
			
			SetItem(i_CursorRow, 'corspnd_salutation_name', l_cFirstName + l_cMI + ' ' + &
				l_cLastName)
			SetItem(i_CursorRow, 'corspnd_address_name', l_cFirstName + l_cMI + ' ' + &
				l_cLastName) 

END CHOOSE

//-------------------------------------------------------------------------------------
//		Initialize the new record with the appropriate default values.
//--------------------------------------------------------------------------------------
SetItem(i_CursorRow, 'corspnd_address_1', l_cAddress1)
SetItem(i_CursorRow, 'corspnd_address_2', l_cAddress2)
SetItem(i_CursorRow, 'corspnd_city', l_cCity)
SetItem(i_CursorRow, 'corspnd_state', l_cState)
SetItem(i_CursorRow, 'corspnd_zip', l_cZip)
SetItem(i_CursorRow, 'corspnd_country', l_cCountry)
SetItem(i_CursorRow, 'correspondence_case_number', i_wParentWindow.i_cSelectedCase)
SetItem(i_CursorRow, 'correspondence_case_type', i_wParentWindow.i_cCaseType)
SetItem(i_CursorRow, 'correspondence_corspnd_prnt_flag', 'N')
SetItem(i_CursorRow, 'correspondence_corspnd_edit_type', 'M')
SetItem(i_CursorRow, 'correspondence_corspnd_doc_filled', 'N')

// set 'hard copy filed' default.
SetItem(i_CursorRow, 'corspnd_hrd_cpy_filed', 'N')
cbx_hrd_cpy_filed.checked = FALSE

SetItem (i_CursorRow, 'correspondence_corspnd_create_date', i_wParentWindow.fw_gettimestamp())
SetItem (i_CursorRow, 'corspnd_created_by', OBJCA.WIN.fu_GetLogin(SQLCA))

w_create_maintain_case.i_bPrintSurvey = FALSE

// update the "address to" list
fu_SetAddressToList ()

//Set the saved boolean.  Put in place as PB doesn't appear to update the item status
//  when it should.
PARENT.i_bDetailSaved = FALSE

//--------------------------------------------------------------------------------------
//		A new correspondence record defaults to a Standard Letter edit type, so set the
//		menu items appropriately.
//--------------------------------------------------------------------------------------
fu_activateinterface ()

//// disable the address info interface since the default addressee is Case Subject.
//fu_AddressEditable (FALSE)

//--------------------------------------------------------------------------------------
//		A new correspondence record defaults to a non-survey letter category.  Filter the
//		the DropDownDataWindow appropriately.
//--------------------------------------------------------------------------------------
dw_correspondence_detail.GetChild('correspondence_letter_id', l_dwcLetterTypes)
l_dwcLetterTypes.SetTransObject (SQLCA)
l_dwcLetterTypes.Retrieve ()
fu_SetLettersFilter (l_dwcLetterTypes, 'N', '', i_wParentWindow.i_cCaseType, i_wParentWindow.i_cSourceType)
l_dwcLetterTypes.Filter()

//---------------------------------------------------------------------------------------
//		Mark the row as New!
//---------------------------------------------------------------------------------------
SetItemStatus(i_CursorRow, 0, PRIMARY!, NOTMODIFIED!)

SetNull (i_blbDocImage)
i_bUpdateDocImage = TRUE
end event

event pcd_setkey;call super::pcd_setkey;//**********************************************************************************************
//
//  Event:   pcd_setkey
//  Purpose: to set the key value for a new Correspondence record.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/06/00 C. Jackson  Add table name to call to fw_getkeyvalue
//
//**********************************************************************************************

i_cCorrespondenceID = i_wParentWindow.fw_getkeyvalue('correspondence')
SetItem(i_CursorRow, 'correspondence_id', i_cCorrespondenceID)


end event

event pcd_save;call super::pcd_save;/*****************************************************************************************
   Event:      pcd_save
   Purpose:    Perform this functionality when this datawindow is saved.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/09/01 M. Caruso    Created.
	12/28/01 M. Caruso    Update i_bUpdateDocImage based on the status of the save.
	3/26/2002 K. Claver   Added condition to check if the case is locked before allow to 
								 activate delete menu item.
*****************************************************************************************/

IF NOT m_create_maintain_case.m_file.m_print.enabled THEN
	m_create_maintain_case.m_file.m_print.enabled = TRUE
END IF

IF NOT m_create_maintain_case.m_edit.m_deletecasereminder.enabled AND &
	NOT PARENT.i_wParentWindow.i_bCaseLocked THEN
	m_create_maintain_case.m_edit.m_deletecasereminder.enabled = TRUE
END IF

// update the doc image update variable.
IF Error.i_FWError = c_Success THEN
	//Set the saved boolean.  Put in place as PB doesn't appear to update the item status
	//  when it should.
	PARENT.i_bDetailSaved = TRUE
	
	i_bUpdateDocImage = FALSE
	
	//Check if the interface should be locked down for a locked case.
	PARENT.fu_ActivateInterface( )
END IF
	
end event

event buttonclicked;call super::buttonclicked;// Bring up letter search window
String ls_letter_id, ls_parm, ls_letter_type

IF THIS.Object.correspondence_letter_id.protect = '1' THEN RETURN

ls_letter_type = THIS.Object.corspnd_type[row]
IF ls_letter_type = 'L' THEN
	IF dwo.name = "b_ellipsis" THEN
	
		ls_parm = i_wParentWindow.i_cCaseType + "/" + i_wParentWindow.i_cSourceType
		OpenWithParm(w_letter_search, ls_parm)
		THIS.SetColumn("correspondence_letter_id")
		
	END IF
END IF
end event

