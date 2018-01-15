$PBExportHeader$w_table_maintenance.srw
$PBExportComments$Table Maintenance Window
forward
global type w_table_maintenance from w_main_std
end type
type uo_document_registration from u_document_registration within w_table_maintenance
end type
type uo_table_list from u_table_list within w_table_maintenance
end type
type uo_cspd_maintenance from u_cspd_maintenance within w_table_maintenance
end type
type uo_document_administration from u_document_administration within w_table_maintenance
end type
type uo_table_maintenance from u_table_maintenance within w_table_maintenance
end type
type uo_category_maintenance from u_category_maintenance within w_table_maintenance
end type
type dw_folder from u_folder within w_table_maintenance
end type
type uo_iim_config from u_iim_config within w_table_maintenance
end type
type uo_bookmark_maintenance from u_bookmark_maintenance within w_table_maintenance
end type
type uo_forms_maintenance from u_forms_maintenance within w_table_maintenance
end type
type uo_field_label_maintenance from u_field_label_maintenance within w_table_maintenance
end type
type uo_optional_grouping from u_optional_grouping2 within w_table_maintenance
end type
type uo_dateterm from uo_dateterm_maint within w_table_maintenance
end type
type uo_search_report_templates from u_search_report_templates within w_table_maintenance
end type
end forward

global type w_table_maintenance from w_main_std
integer width = 3680
integer height = 1932
string title = "Table Maintenance"
string menuname = "m_table_maintenance"
long backcolor = 79748288
event ue_newsibling pbm_custom75
event ue_deletecategory ( )
event ue_newchild ( )
event ue_save ( )
event ue_deletefromtreeview ( )
event ue_newdocument ( )
event ue_import ( )
event ue_deleteform ( )
event ue_saveform ( )
event ue_saveoptgrouping ( )
event ue_new_opt_group ( )
event ue_delete_optgroup ( )
event ue_save_dateterm ( )
event ue_new_dateterm ( )
event ue_delete_dateterm ( )
uo_document_registration uo_document_registration
uo_table_list uo_table_list
uo_cspd_maintenance uo_cspd_maintenance
uo_document_administration uo_document_administration
uo_table_maintenance uo_table_maintenance
uo_category_maintenance uo_category_maintenance
dw_folder dw_folder
uo_iim_config uo_iim_config
uo_bookmark_maintenance uo_bookmark_maintenance
uo_forms_maintenance uo_forms_maintenance
uo_field_label_maintenance uo_field_label_maintenance
uo_optional_grouping uo_optional_grouping
uo_dateterm uo_dateterm
uo_search_report_templates uo_search_report_templates
end type
global w_table_maintenance w_table_maintenance

type variables
BOOLEAN						i_bNewCaseSubject
BOOLEAN						i_bDemographicUpdate
BOOLEAN						i_bCaseDetailUpdate
BOOLEAN						i_bSaveDemographics
BOOLEAN						i_bSaveCase
BOOLEAN						i_bSearchCriteriaUpdate
BOOLEAN						i_bNeedCaseSubject 
BOOLEAN						i_bSupervisorRole
BOOLEAN						i_bDocsOpened
BOOLEAN						i_bNewDoc
BOOLEAN						i_bNewDocSaved
BOOLEAN						i_bNewSubCategory
BOOLEAN 						i_bOutOfOffice
BOOLEAN						i_bDocReg
BOOLEAN                 i_bAddDocCancel = FALSE

INT							i_nRepConfidLevel
INT							i_nNonIssueConfidLevel = 0
INT							i_nDefIssueConfidLevel = 1
INT							i_nNumConfigFields

LONG							i_lPreviousSelectedRow

STRING						i_ulDemographicsCW  
STRING						i_ulDemographicsVW
STRING						i_ulCaseHistoryCW
STRING						i_ulCaseHistoryVW
STRING						i_ulCaseDetailCW
STRING						i_ulCaseDetailVW
STRING						i_cDocID
STRING						i_cUserID

STRING						i_cDataWindowName
STRING						i_cDisplayTableName
STRING						i_cKeyColumnName
STRING						i_cTableName

STRING						i_cSupervisorRole 

STRING						i_cPreviousCaseSubject
STRING						i_cPreviousCaseSubjectName
STRING						i_cPreviousSourceType

STRING						i_cProviderType      
STRING						i_cSelectedCase
STRING						i_cCurrentCase
STRING						i_cCurrentCaseSubject
STRING						i_cCaseSubjectName
STRING						i_cSourceType
STRING						i_cCaseType
STRING						i_cUserLastName
STRING						i_cContactPerson
STRING						i_cRelationship

STRING						i_cStatusOpen   = 'O'
STRING						i_cStatusClosed = 'C'
STRING						i_cStatusVoid   = 'V'

STRING						i_cInquiry      = 'I'
STRING						i_cIssueConcern = 'C'
STRING                  i_cConfigurable = 'M'
STRING						i_cProActive    = 'P'

STRING						i_cDefConsumerRelationship = '1'
STRING						i_cDefEmployerRelationship = '2'
STRING						i_cDefProviderRelationship = '3'
STRING						i_cDefOtherRelationship    = '4'

STRING						i_cDefMethod = '1'

STRING						i_cSourceConsumer = 'C'
STRING						i_cSourceEmployer = 'E'
STRING						i_cSourceProvider = 'P'
STRING						i_cSourceOther    = 'O'
STRING						i_cLastSource

STRING i_cSaveChangesMessage = 'Would you like to save the changes to the '
STRING i_cDeletedrowmessage = 'Do you really want to delete the selected row from the '
STRING i_cSaveCaseChanges = 'Would you like to save your changes to the Case?'
STRING i_cSaveDemographicChanges = 'Would you like to save your changes to the Case Subject?'
STRING i_cSaveMessage

STRING						i_cWORDExe

U_TABLE_MAINTENANCE			i_uTableMaintenance
U_CATEGORY_MAINTENANCE		i_uCategoryMaintenance
U_DOCUMENT_REGISTRATION    i_uoDocumentRegistration

S_DOCFIELDPROPERTIES			i_sConfigurableField[]

U_CASE_DETAILS					i_uoCaseDetails
U_CASE_REMINDERS				i_uoCaseReminders
U_CASE_CORRESPONDENCE		i_uoCaseCorrespondence

WINDOWOBJECT     i_woTabObjects[]

STRING i_cOpenDocs[]
LONG i_nDocCounter
end variables

forward prototypes
public subroutine fw_newsearch ()
public subroutine fw_clearsearch ()
public subroutine fw_checkoutofoffice ()
public subroutine fw_sortdata ()
public function integer fw_buildfieldlist (string doc_type_id)
end prototypes

event ue_newsibling;//***********************************************************************************************
//
//  Event:   ue_newsibling
//  Purpose: Create a new record at the same level in the tree as the currently selected record
//				
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  08/27/99 M. Caruso   Created
//  08/31/99 M. Caruso   Reworked the code to define the new lineage value in a "fill-the-gaps" 
//                       method, reusing lineage values freed up by category deletion where 
//                       appropriate.
//  09/09/99 M. Caruso   Added call to ue_save before anything else.
//  11/04/99 M. Caruso   Now uses system fw_GetTimStamp to retrieve the current date/time from 
//                       the host system.
//  08/25/00 C. Jackson  Changed embedded SQL insert to SetItems
//
//***********************************************************************************************

S_CATEGORY_INFO	l_sNewCategory
DATASTORE			l_dsCategoryList
LONG		l_nRow
INTEGER	l_nIndex, l_nCount
DATETIME	l_dTimestamp
STRING	l_cLineage, l_cUserID, l_cActive
STRING	l_cDefaultName = "New Category"

TriggerEvent("ue_save")

uo_category_maintenance.i_bNewCategory = TRUE
uo_category_maintenance.i_bNewSubCategory = FALSE

uo_category_maintenance.dw_category_details.fu_retrieve(uo_category_maintenance.dw_category_details.c_promptchanges, &
   uo_category_maintenance.dw_category_details.c_noreselectrows)

uo_category_maintenance.TriggerEvent('ue_setFocus')


end event

event ue_deletecategory;//*********************************************************************************************
//
//  Event:   ue_DeleteCategory
//  Purpose: Remove the selected category from the database.  This function will delete a
//           category with children, but only if the user chooses to do so.
//				
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  08/27/99 M. Caruso   Created.
//  08/31/99 M. Caruso   Reworked the code.  The new version only allows deletion of top-level 
//                       categories that are not in use, and prevents deletion of the last 
//							    category for the specified case type.
//  09/01/99 M. Caruso   Added code to set the new category as current.
//  08/23/00 C. Jackson  Add retrieve on dw_category_details to display the selected category
//                       on the outliner datawindow
//  08/28/00 M. Caruso   Corrected the method for determining the next category to select.
//  12/04/01 C. Jackson  Correct spelling error in Delete message box (SCR 2489)
//  12/05/01 C. Jackson  Spelling: changed "can not" to "cannot" (SCR 2497)
//  5/29/2002 K. Claver  Changed to get the new row to be selected BEFORE deleting the current row.
//*********************************************************************************************

U_OUTLINER_STD		l_dwTreeView
S_CATEGORY_INFO	l_sCategory
LONG					l_nCount, l_nRow, l_nRtn, l_nNewRow
STRING				l_cLineageParm, l_cPrompt, l_cCompare, l_cQuestion, l_cKeys[], l_cNewKey
BOOLEAN				l_bDone

l_cPrompt = ""
l_dwTreeView = uo_category_maintenance.dw_category_org
l_sCategory = uo_category_maintenance.i_sCurrentCategory

// If there is more than 1 category available, allow deletion
IF l_dwTreeView.RowCount() > 1 THEN
	// If the category is not in use, allow deletion
	SELECT count(*) INTO :l_nCount
	  FROM cusfocus.case_log
	 WHERE case_type = :l_sCategory.case_type AND category_id = :l_sCategory.category_id
	 USING SQLCA;
	 
	IF SQLCA.SQLCode = 0 THEN
		CHOOSE CASE l_nCount
			CASE 0
				l_nCount = 0
				l_nRow = l_dwTreeView.fu_HLFindRow (l_sCategory.category_id, l_sCategory.level)
				l_cLineageParm = l_sCategory.lineage + "%"
				
				// Determine if the selected category has any children and handle appropriately
				SELECT count(*) INTO :l_nCount
				  FROM cusfocus.categories
				 WHERE category_lineage LIKE :l_cLineageParm
				 USING SQLCA;
				  
				IF SQLCA.SQLCode = 0 THEN
					CHOOSE CASE l_nCount
						CASE 1
							l_cQuestion = "Are you sure you want to delete this category?"
							IF MessageBox (gs_AppName, l_cQuestion, StopSign!, YesNo!) = 1 THEN
								
								DELETE FROM cusfocus.categories
								 WHERE category_id = :l_sCategory.category_id
								 USING SQLCA;
								 
								IF SQLCA.SQLCode = 0 THEN
									// Finish the deletion process
									l_dwTreeView.SetRedraw (FALSE)
									COMMIT USING SQLCA;
									
									IF l_nRow = 1 THEN
										l_nNewRow = ( l_nRow + 1 )
									ELSE
										l_nNewRow = ( l_nRow - 1 )
									END IF
									
									l_nCount = l_dwTreeView.fu_HLGetRowKey (l_nNewRow, l_cKeys[])
									
									l_dwTreeView.fu_HLDeleteRow(l_nRow)
									
									IF l_nCount > 0 AND UpperBound( l_cKeys ) > 0 THEN
										l_cNewKey = l_cKeys[l_nCount]
										
										// gather the info to populate i_sCurrentCategory
										SELECT category_id, case_type, prnt_category_id, category_level, category_lineage
										  INTO :l_sCategory.category_id, :l_sCategory.case_type, :l_sCategory.parent_id,
												 :l_sCategory.level, :l_sCategory.lineage
										  FROM cusfocus.categories
										 WHERE category_id = :l_cNewKey
										 USING SQLCA;
										
										uo_category_maintenance.uf_updatedisplay (l_sCategory.category_id, l_sCategory.level)
										uo_category_maintenance.i_sCurrentCategory = l_sCategory
									END IF
								ELSE
									l_cPrompt = "Deletion process failed.~r~n" + SQLCA.SQLErrText
								END IF 
							END IF
							
						CASE IS > 1
							l_cPrompt = "The selected category cannot be deleted because~r~n" + &
							 			   "there are sub-categories beneath it. The sub-categories~r~n" + &
											"must be deleted before this category can be removed."
							
					END CHOOSE
					
				ELSE
					l_cPrompt = "Error accessing database:~r~n" + SQLCA.SQLErrText
				END IF
				
			CASE ELSE
				l_cPrompt = "You cannot delete this row since there are still records~r~n" + &
								"in the Case Log table that reference this row."
		END CHOOSE
		
	ELSE
		l_cPrompt = "Error accessing database:~r~n" + SQLCA.SQLErrText
	END IF
	
ELSE
	l_cPrompt = gs_AppName+" requires at least one category be assigned per~r~n" + &
					"case type.  You must enter another category to delete this one."
END IF

IF l_cPrompt <> "" THEN
	MessageBox (gs_AppName, l_cPrompt)
END IF

// Retrieve detail datawindow to match selected category
l_nRtn = uo_category_maintenance.dw_category_details.retrieve(l_sCategory.category_id)


end event

event ue_newchild;//***********************************************************************************************
//
//  Event:   ue_newchild
//  Purpose: Create a child record at the level below the current record.
//				
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  08/30/99  M. Caruso  Created.
//  08/31/99 M. Caruso   Reworked the code to define the new lineage value in a "fill-the-gaps" 
//                       method, reusing lineage values freed up by category deletion where 
//                       appropriate.
//  09/09/99 M. Caruso   Added call to ue_save before anything else.
//  11/04/99 M. Caruso   Now uses fw_GetTimeStamp to get the current date/time from the host
//  08/25/00 C. Jackson  Changed embedded SQL insert to SetItems
//  
//***********************************************************************************************

S_CATEGORY_INFO	l_sNewCategory
DATASTORE			l_dsCategoryList
LONG		l_nRow
INTEGER	l_nIndex, l_nCount
DATETIME	l_dTimestamp
STRING	l_cLineage, l_cUserID, l_cActive
STRING	l_cDefaultName = "New Category"

TriggerEvent("ue_save")

// expand level
uo_category_maintenance.dw_category_org.fu_HLExpandLevel()

uo_category_maintenance.i_bNewCategory = TRUE
uo_category_maintenance.i_bNewSubCategory = TRUE

uo_category_maintenance.dw_category_details.fu_retrieve (uo_category_maintenance.dw_category_details.c_promptchanges, uo_category_maintenance.dw_category_details.c_noreselectrows)

uo_category_maintenance.TriggerEvent('ue_setFocus')


end event

event ue_save;//*********************************************************************************************
//
//  Event:   ue_save
//  Purpose: Save category information and update the tree display.
//	
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  08/30/99 M. Caruso   Created.
//  08/23/00 C. Jackson  Added logic to prevent the user from saving a category without entering
//                       a category name
//  08/28/00 C. Jackson  Prompt user for changes only if they have not clicked the save button
//  08/28/00 M. Caruso   Added code to update the current category information before updating
//                       the tree view display.
//  02/20/01 M. Caruso   Modified the script so it would not prompt the user to save changes.
//								 Also Moved the code to enable the New Child menu item into an ELSE
//								 clause for	the IF statement checking the success of the save.
//  02/11/03 M. Caruso   Commented out the code to reset the status of m_insertchildrecord. This
//								 is handled in the tree view control.
//*********************************************************************************************

LONG		l_nRow, l_nReturn
STRING 	l_cNewCatName
U_DW_STD	l_dwDetails

// Make sure all changes are set.
uo_category_maintenance.dw_category_details.AcceptText ()

// save it.
IF uo_category_maintenance.dw_category_details.fu_Save (c_SaveChanges) < 0 THEN
	uo_category_maintenance.dw_category_details.SetFocus ()
//ELSE
//	
//	// enable the New Child menu item if it is disabled.
//	IF m_table_maintenance.m_edit.m_insertchildrecord.Enabled = FALSE THEN
//		m_table_maintenance.m_edit.m_insertchildrecord.Enabled = TRUE
//	END IF
	
END IF
end event

event ue_deletefromtreeview;/*****************************************************************************************
   Event:      ue_deletefromtreeview
   Purpose:    Launch the delete process when the main datawindow is based on U_OUTLINER

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/8/00   M. Caruso    Created.
	6/22/2001 K. Claver   Commented out references to IIM table object for InfoMaker enhancement.
*****************************************************************************************/

CHOOSE CASE i_ctablename
	CASE "categories"
		// This will be moved here from ue_deletecategory, eventually
		
//	CASE "iim_tables"
//		uo_iim_table_info.fu_deleteentry ()
		
END CHOOSE
end event

event ue_newdocument;//**********************************************************************************************
//
//  Event:   ue_newdocument
//  Purpose: Open the Add Document window
//  
//  Date     Developer    Description
//  -------- ------------ ----------------------------------------------------------------------
//  04/04/01 C. Jackson   Original Version
//  04/10/01 C. Jackson   If user had cancelled out last window and there are no docs to 
//                        retrieve, then don't.  (SCR 1627)
//  06/04/01 C. Jackson   Add fu_clearfields
//  06/26/01 C. Jackson   Removed fw_getkeyvalue.  Shouldn't get getting the PK until getting
//                        ready to save.  Moved to cb_save of w_doc_reg_detail (SCR 2117)
//
//**********************************************************************************************

STRING l_cDocTypeID, l_cDocID
S_DOCFIELDPROPERTIES l_sParms

IF ISVALID(w_doc_reg_detail) THEN
	w_doc_reg_detail.fu_clearfields()
END IF

l_sParms.window_state = 'NEW'

// Open w_doc_detail
i_bNewDoc = TRUE
FWCA.MGR.fu_OpenWindow(w_doc_reg_detail,l_sParms)

l_cDocTypeID = message.stringparm

IF NOT i_bAddDocCancel THEN
	m_table_maintenance.m_file.m_clearsearchcriteria.TriggerEvent(clicked!)
	w_table_maintenance.uo_document_registration.dw_doc_reg_type.SetItem(1,'doc_type_id',l_cDocTypeID)
	w_table_maintenance.uo_document_registration.dw_doc_reg_type.TriggerEvent(ItemChanged!)
	m_table_maintenance.m_file.m_search.TriggerEvent(clicked!)
END IF
w_table_maintenance.uo_document_registration.dw_search_criteria.SetFocus()
w_table_maintenance.uo_document_registration.dw_search_criteria.SetColumn('doc_name')

end event

event ue_import;/*****************************************************************************************
	Event:	ue_import
	Purpose: To import a form template
		
	Revisions:
	Developer     Date     Description
	============= ======== ==================================================
	K. Claver	  1/14/2002 Created
******************************************************************************************/
IF IsValid( uo_forms_maintenance ) THEN
	uo_forms_maintenance.Event Trigger ue_import( )
END IF
end event

event ue_deleteform;/*****************************************************************************************
	Event:	ue_deleteform
	Purpose: To delete a form template
		
	Revisions:
	Developer     Date     Description
	============= ======== ==================================================
	K. Claver	  1/14/2002 Created
******************************************************************************************/
IF IsValid( uo_forms_maintenance ) THEN
	uo_forms_maintenance.Event Trigger ue_delete( )
END IF
end event

event ue_saveform;/*****************************************************************************************
	Event:	ue_saveform
	Purpose: To save changes in the form template maintenance object
		
	Revisions:
	Developer     Date     Description
	============= ======== ==================================================
	K. Claver	  2/1/2002 Created
******************************************************************************************/
IF IsValid( uo_forms_maintenance ) THEN
	uo_forms_maintenance.Event Trigger ue_save( )
END IF
end event

event ue_saveoptgrouping;//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   Call the save for the Optional Grouping Window
//	Created by: Joel White
//	History:    10/19/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

IF IsValid( uo_optional_grouping ) THEN
	uo_optional_grouping.Event Trigger ue_save( )
END IF
end event

event ue_new_opt_group;uo_optional_grouping.TriggerEvent('ue_new')
end event

event ue_delete_optgroup;uo_optional_grouping.TriggerEvent('ue_delete')
end event

event ue_save_dateterm();//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   Call the save for the Optional Grouping Window
//	Created by: Joel White
//	History:    10/19/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

IF IsValid( uo_optional_grouping ) THEN
	uo_dateterm.Event Trigger ue_save( )
END IF
end event

event ue_new_dateterm();uo_dateterm.TriggerEvent('ue_new')
end event

event ue_delete_dateterm();uo_dateterm.TriggerEvent('ue_delete')
end event

public subroutine fw_newsearch ();
end subroutine

public subroutine fw_clearsearch ();/**************************************************************************************

				Function:		fw_clearsearch
				Purpose:			To clear the search criteria for a new search
				Parameters:		None
				Returns:			None
	
*************************************************************************************/

////------------------------------------------------------------------------------------
////		
////		Make sure the current tab is the Search criteria.
////
////------------------------------------------------------------------------------------
//
//i_cCurrentCaseSubject = ''
//i_cCaseSubjectName = ''
//i_cCurrentCase = ''
//i_cSelectedCase = ''
//Title = Tag

//-------------------------------------------------------------------------------------
//
//		Clear the Search Criteria
//
//-------------------------------------------------------------------------------------

uo_document_registration.dw_matched_records.Reset()
uo_document_registration.dw_search_criteria.fu_Reset()

uo_document_registration.dw_search_criteria.SetFocus()



end subroutine

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
	m_table_maintenance.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_table_maintenance.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
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
	1/24/2001 K. Claver   Adapted from the same named function on object w_create_maintain_case.
**************************************************************************************/

u_dw_main		l_dwSortDW
INT				l_nCounter, l_nAnotherCounter, l_nColumnCount, l_nTabNum
LONG				l_nSortError
S_ColumnSort	l_sSortData
STRING 			l_cTag, l_cSortString, l_cColName
U_IIM_TAB_PAGE	l_uPage

IF dw_folder.i_SelectedTab = 2 AND IsValid( uo_table_maintenance ) THEN
	//Sort by table maintenance datawindow
	l_dwSortDW = uo_table_maintenance.dw_table_maintenance
	
	CHOOSE CASE l_dwSortDW.DataObject	
		CASE "d_tm_case_prop_field_defs"
			l_sSortData.label_name[1] = l_dwSortDW.Describe("def_id_num.Tag")
			l_sSortData.column_name[1] = 'def_id_num'
			l_nAnotherCounter = 1
			
		CASE ELSE
			l_nAnotherCounter = 0
	END CHOOSE
END IF

l_nColumnCount = LONG(l_dwSortDW.Describe("Datawindow.Column.Count")) 

FOR l_nCounter = 1 to l_nColumnCount

		l_cTag = l_dwSortDW.Describe("#" + String(l_nCounter) + ".Tag")

	   IF l_cTag <> '?' THEN
			l_nAnotherCounter ++
			l_sSortData.label_name[l_nAnotherCounter]  = l_cTag
			l_sSortData.column_name[l_nAnotherCounter] = l_dwSortDW.Describe("#" + String(l_nCounter) + ".Name")
		END IF
NEXT
	
FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)
l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = l_dwSortDW.SetSort(l_cSortString)
	l_nSortError = l_dwSortDW.Sort()
END IF

end subroutine

public function integer fw_buildfieldlist (string doc_type_id);/*****************************************************************************************
	Function:	fw_buildfieldlist
	Purpose:		Add defined configurable fields to the field list for the selected source
	            type.
	Parameters:	STRING	doc_type_id 
	Returns:		LONG ->	 0 - success
								-1 - failure
								
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	7/12/99  M. Caruso     Created.
	
	7/15/99  M. Caruso     Removed code to add fields to i_cCriteriaColumn[],
	                       i_cSearchColumn[] and i_cSearchTable[]
*****************************************************************************************/
U_DS_DOC_FIELD_LIST	l_dsFields
LONG					l_nCount, l_nColIndex

// retrieve the list of fields for document_type from the database.
l_dsFields = CREATE u_ds_doc_field_list
l_dsFields.SetTransObject(SQLCA)
i_nNumConfigFields = l_dsFields.Retrieve(doc_type_id)

// process the list of fields.
IF i_nNumConfigFields > 0 THEN
	FOR l_nCount = 1 to i_nNumConfigFields
		// get the column name associated with this field
		i_sConfigurableField[l_nCount].doc_column_name = l_dsFields.GetItemString(l_nCount, &
					"document_fields_doc_column_name")
		IF IsNull (i_sConfigurableField[l_nCount].doc_column_name) OR &
			(Trim (i_sConfigurableField[l_nCount].doc_column_name) = "") THEN
			i_sConfigurableField[l_nCount].doc_column_name = ""
		END IF
		
		// get the column label associated with this field
		i_sConfigurableField[l_nCount].doc_field_label = l_dsFields.GetItemString(l_nCount, &
					"document_fields_doc_field_label")
		IF IsNull (i_sConfigurableField[l_nCount].doc_field_label) OR &
			(Trim (i_sConfigurableField[l_nCount].doc_field_label) = "") THEN
			i_sConfigurableField[l_nCount].doc_field_label = ""
		END IF
		
		// get the field width associated with this field
		i_sConfigurableField[l_nCount].doc_field_length = l_dsFields.GetItemNumber(l_nCount, &
					"document_fields_doc_field_length")
		IF IsNull (i_sConfigurableField[l_nCount].doc_field_length) THEN
			i_sConfigurableField[l_nCount].doc_field_length = 50
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

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
	Event:	pc_setoptions
	Purpose: To create the tab folder object and assign user objects to each tab
		
	Revisions:
	Developer     Date     Description
	============= ======== ==================================================
	M. Caruso     05/21/99	Change toolbar initialization from c_ToolbarLeft
					            to c_ToolbarTop
	M. Caruso     8/26/99	Modified the function to handle the new category
					            maintenance container object.
	K. Claver	  8/18/2000 Added the iim tab conversion user object to the
									window object array.  Can be removed once all
									clients are converted to 3.01 version of 
									CustomerFocus
	M. Caruso     01/03/01  Posted the call to fu_SelectTab ().
	K. Claver     6/22/2001 Commented out references to IIM table object for InfoMaker
	                        enhancement.
	M. Caruso     11/30/01  Added the new correspondence maintenance container.
	K. Claver 	  01/10/2002 Added forms maintenance container.
******************************************************************************************/

WINDOWOBJECT l_woTabObjects1[]
WINDOWOBJECT l_woTabObjects2[]

fw_SetOptions(c_default + c_ToolbarTop)		// RAE 4/5/99;  MPC   5/21/99

//---------------------------------------------------------------------------------------
//
//		Set the defaults for the folder object
//
//---------------------------------------------------------------------------------------

Tag = Title

dw_folder.fu_TabOptions('Arial', 9, dw_folder.c_DefaultVisual)
dw_folder.fu_TabDisableOptions('Arial', 9, dw_folder.c_TextDisableRegular)
dw_folder.fu_TabCurrentOptions('Arial', 9, dw_folder.c_DefaultVisual)

l_woTabObjects1[1] = uo_table_list
l_woTabObjects2[1] = uo_table_maintenance
l_woTabObjects2[2] = uo_category_maintenance
l_woTabObjects2[3] = uo_iim_config
l_woTabObjects2[4] = uo_document_registration
l_woTabObjects2[5] = uo_document_administration
l_woTabObjects2[6] = uo_bookmark_maintenance
l_woTabObjects2[7] = uo_cspd_maintenance
l_woTabObjects2[8] = uo_forms_maintenance
l_woTabObjects2[9] = uo_optional_grouping
l_woTabObjects2[10] = uo_dateterm
l_woTabObjects2[11] = uo_search_report_templates

dw_folder.fu_AssignTab(1, "Table Selection", l_woTabObjects1[])
dw_folder.fu_AssignTab(2, "Table Maintenance",  l_woTabObjects2[])
dw_folder.fu_FolderCreate(2,2)

dw_folder.post fu_SelectTab(1)

THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_SetOrigSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
	THIS.inv_resize.of_SetMinSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
	
	THIS.inv_resize.of_Register( uo_table_list, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_table_maintenance, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_category_maintenance, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_iim_config, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_document_registration, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_document_administration, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_bookmark_maintenance, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_cspd_maintenance, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_forms_maintenance, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_optional_grouping, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_dateterm, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_search_report_templates, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( dw_folder, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF

//-------------------------------------------------------------------------------------
//
// Assign userobject an instance of uo_dw_main_std
//
//--------------------------------------------------------------------------------------

uo_table_maintenance.i_wParentWindow = THIS

fw_CheckOutOfOffice()
end event

event pc_new;call super::pc_new;/***************************************************************************************
	Event:	pc_new
	Purpose:	To increment the Maximum value instance varaible that is used to generate
					keys for User Maintainable tables.
					
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	1/17/00  M. Caruso     Modified the event to handle other container objects.
***************************************************************************************/

CHOOSE CASE i_cTableName
	CASE "iim_tabs"
		uo_iim_config.i_nMaxValue ++
		
//	CASE "document_ownership"
//		uo_document_registration.fu_newdoc()
		
	CASE ELSE
		uo_table_maintenance.i_nMaxValue ++
		
END CHOOSE
end event

on w_table_maintenance.create
int iCurrent
call super::create
if this.MenuName = "m_table_maintenance" then this.MenuID = create m_table_maintenance
this.uo_document_registration=create uo_document_registration
this.uo_table_list=create uo_table_list
this.uo_cspd_maintenance=create uo_cspd_maintenance
this.uo_document_administration=create uo_document_administration
this.uo_table_maintenance=create uo_table_maintenance
this.uo_category_maintenance=create uo_category_maintenance
this.dw_folder=create dw_folder
this.uo_iim_config=create uo_iim_config
this.uo_bookmark_maintenance=create uo_bookmark_maintenance
this.uo_forms_maintenance=create uo_forms_maintenance
this.uo_field_label_maintenance=create uo_field_label_maintenance
this.uo_optional_grouping=create uo_optional_grouping
this.uo_dateterm=create uo_dateterm
this.uo_search_report_templates=create uo_search_report_templates
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_document_registration
this.Control[iCurrent+2]=this.uo_table_list
this.Control[iCurrent+3]=this.uo_cspd_maintenance
this.Control[iCurrent+4]=this.uo_document_administration
this.Control[iCurrent+5]=this.uo_table_maintenance
this.Control[iCurrent+6]=this.uo_category_maintenance
this.Control[iCurrent+7]=this.dw_folder
this.Control[iCurrent+8]=this.uo_iim_config
this.Control[iCurrent+9]=this.uo_bookmark_maintenance
this.Control[iCurrent+10]=this.uo_forms_maintenance
this.Control[iCurrent+11]=this.uo_field_label_maintenance
this.Control[iCurrent+12]=this.uo_optional_grouping
this.Control[iCurrent+13]=this.uo_dateterm
this.Control[iCurrent+14]=this.uo_search_report_templates
end on

on w_table_maintenance.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_document_registration)
destroy(this.uo_table_list)
destroy(this.uo_cspd_maintenance)
destroy(this.uo_document_administration)
destroy(this.uo_table_maintenance)
destroy(this.uo_category_maintenance)
destroy(this.dw_folder)
destroy(this.uo_iim_config)
destroy(this.uo_bookmark_maintenance)
destroy(this.uo_forms_maintenance)
destroy(this.uo_field_label_maintenance)
destroy(this.uo_optional_grouping)
destroy(this.uo_dateterm)
destroy(this.uo_search_report_templates)
end on

event activate;call super::activate;FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, &
					i_cSaveChangesMessage + i_cDisplayTableName + " table?")
FWCA.MSG.fu_SetMessage("DeleteOKOne", FWCA.MSG.c_MSG_Text, &
					i_cDeletedrowmessage + i_cDisplayTableName + " table?")
end event

type uo_document_registration from u_document_registration within w_table_maintenance
boolean visible = false
integer x = 23
integer y = 104
integer taborder = 30
end type

on uo_document_registration.destroy
call u_document_registration::destroy
end on

type uo_table_list from u_table_list within w_table_maintenance
integer x = 23
integer y = 104
boolean border = false
end type

event pc_setoptions;call super::pc_setoptions;uo_table_list.dw_table_list.SetFocus()
end event

on uo_table_list.destroy
call u_table_list::destroy
end on

type uo_cspd_maintenance from u_cspd_maintenance within w_table_maintenance
integer x = 23
integer y = 104
integer width = 3570
integer taborder = 20
end type

on uo_cspd_maintenance.destroy
call u_cspd_maintenance::destroy
end on

type uo_document_administration from u_document_administration within w_table_maintenance
integer x = 23
integer y = 104
integer taborder = 30
end type

on uo_document_administration.destroy
call u_document_administration::destroy
end on

type uo_table_maintenance from u_table_maintenance within w_table_maintenance
integer x = 23
integer y = 104
boolean i_bringtotop = false
end type

on uo_table_maintenance.destroy
call u_table_maintenance::destroy
end on

type uo_category_maintenance from u_category_maintenance within w_table_maintenance
integer x = 23
integer y = 104
integer taborder = 20
boolean i_bringtotop = false
end type

on uo_category_maintenance.destroy
call u_category_maintenance::destroy
end on

type dw_folder from u_folder within w_table_maintenance
integer y = 4
integer width = 3634
integer height = 1720
integer taborder = 0
end type

event po_tabclicked;call super::po_tabclicked;//**********************************************************************************************
//
//  Event:   po_tabclicked
//  Purpose: To change the menu items. 
//
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  8/27/99  M. Caruso     Added code to manipulate the Insert Child Record menu item.
//  1/17/00  M. Caruso     Added code to handle the IIM Config screen.
//  3/6/00   M. Caruso     Added code to handle the IIM Table Config screen.
//  03/25/00 C. Jackson    Made insert and delete disabled on for document administration
//  04/24/00 C. Jackson    Disable delete and insert for CaseType (SCR 500)
//  08/07/00 C. Jackson    Set the group radiobutton in document administration to default to
//                         selected.
//  8/18/2000 K. Claver    Added code to handle the iim conversion object.  Can be removed
//									after all clients are converted to 3.01 version.
//  01/03/01 M. Caruso     Modified how the code determines how to set the menu items and added
//									code to enable/disable the SAVE menu item.
//  11/30/01 M. Caruso     Added case for Correspondence Maintenance.
//  12/12/01 M. Caruso     Set focus to the list dw on the letter_types tab.
//  1/14/2002 K. Claver    Added case for the form_templates tab.
//  4/11/2002 K. Claver    Uncommented call to fu_retrievedocreg function for documents so would
//									refresh the type and status drop-downs each time switch to the detail tab.
//  06/17/03 M. Caruso     Added code to link the visiblity of a menu separator to the m_editdocument
//									menu item to avoid having two separators disply with no menu items
//									between them.
//**********************************************************************************************

LONG l_nCount


CHOOSE CASE SelectedTab
	CASE 1			// Process for Table List tab.
		//	Disable the New and Delete menu items when the Table Select tab is current.
		m_table_maintenance.m_file.m_save.Enabled = FALSE
		m_table_maintenance.m_file.m_search.visible = FALSE
		m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
		m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
		m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
		m_table_maintenance.m_edit.m_new.Enabled = FALSE
		m_table_maintenance.m_edit.m_delete.Enabled = FALSE
		m_table_maintenance.m_edit.m_sort.Enabled = FALSE
		m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
		m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
		m_table_maintenance.m_file.m_viewdetails.visible = FALSE
		m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
		m_table_maintenance.m_file.m_editdocument.visible = FALSE
		m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
		uo_table_list.dw_table_list.SetFocus()
		
	CASE 2			// Process for Table Maintenance tab.
		// If the user doesn't have access to any tables
		IF uo_table_list.dw_table_list.RowCount() < 1 THEN 
			THIS.fu_SelectTab(1)
			RETURN
		END IF
		m_table_maintenance.m_file.m_save.Enabled = TRUE
		CHOOSE CASE i_cTableName
			CASE "categories"
				m_table_maintenance.m_edit.m_new.text = '&Insert New Record~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New'
				m_table_maintenance.m_edit.m_insertchildrecord.text = 'Insert Child Record~tCtrl+Shft+N'
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemtext = 'New Child'
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = TRUE
				m_table_maintenance.m_edit.m_delete.Enabled = TRUE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.visible = TRUE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = TRUE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				
			CASE "letter_types"
				m_table_maintenance.m_edit.m_new.text = '&Insert New Document~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New Document'
				m_table_maintenance.m_edit.m_insertchildrecord.text = 'Insert Child Record~tCtrl+Shft+N'
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemtext = 'New Child'
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = TRUE
				m_table_maintenance.m_edit.m_delete.Enabled = TRUE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				uo_cspd_maintenance.dw_doclist.SetFocus()
				
			CASE "lookup_info"
				m_table_maintenance.m_edit.m_new.Enabled = FALSE
				m_table_maintenance.m_edit.m_new.text = '&Insert New Record~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New'
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.text = 'Insert Child Record~tCtrl+Shft+N'
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemtext = 'New Child'
				m_table_maintenance.m_edit.m_delete.Enabled = FALSE
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
			
			CASE "iim_tabs"
				m_table_maintenance.m_edit.m_new.text = '&Insert New Record~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New'
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = TRUE
				m_table_maintenance.m_edit.m_delete.Enabled = TRUE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				uo_iim_config.dw_tab_list.SetFocus()
				
			CASE "form_templates"
				m_table_maintenance.m_edit.m_new.text = 'Import~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'Import'
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = TRUE
				m_table_maintenance.m_edit.m_delete.Enabled = TRUE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				
			CASE "optional_grouping"
				uo_optional_grouping.of_retrieve()
				m_table_maintenance.m_edit.m_new.text = 'Import~tCtrl+N'
//				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'Import'
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = TRUE
				m_table_maintenance.m_edit.m_delete.Enabled = TRUE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				
			CASE "dateterm"
				m_table_maintenance.m_edit.m_new.text = '&New Date Term~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New'
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = TRUE
				m_table_maintenance.m_edit.m_delete.Enabled = TRUE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				
			CASE "documents"
				uo_document_registration.fu_RetrieveDocReg()
				uo_document_registration.dw_doc_reg_type.TriggerEvent("ItemChanged")
				m_table_maintenance.m_edit.m_new.text = '&New Document~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New'
				m_table_maintenance.m_file.m_search.visible = TRUE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = TRUE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = TRUE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = TRUE
				m_table_maintenance.m_edit.m_new.Enabled = TRUE
				m_table_maintenance.m_edit.m_delete.Enabled = FALSE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = TRUE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = TRUE
				m_table_maintenance.m_file.m_viewdetails.Enabled = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = TRUE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = TRUE
				m_table_maintenance.m_file.m_editdocument.Enabled = FALSE
				uo_document_registration.dw_search_criteria.SetFocus()
				
			CASE "document_ownership"
				SetPointer(HourGlass!)
				uo_document_administration.fu_RetrieveDoc()
				uo_document_administration.rb_groups.Checked = TRUE
				m_table_maintenance.m_edit.m_new.text = '&Insert New Record~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New'
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = FALSE
				m_table_maintenance.m_edit.m_delete.Enabled = FALSE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = TRUE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = TRUE
				m_table_maintenance.m_file.m_viewdetails.Enabled = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = TRUE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = TRUE
				m_table_maintenance.m_file.m_editdocument.Enabled = FALSE

				SetPointer(Arrow!)
				
			CASE "case_types"
				m_table_maintenance.m_edit.m_delete.Enabled = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = FALSE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				
			CASE "iim_conv"
				//Can be removed after all clients are converted to 3.01 version
				
				//iim tab text to blob conversion
				m_table_maintenance.m_edit.m_delete.Enabled = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = FALSE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				
			CASE "table_security"
				
				m_table_maintenance.m_edit.m_delete.Enabled = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = FALSE
				m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				
			CASE "savedreport"
				m_table_maintenance.m_file.m_save.Enabled = FALSE
				m_table_maintenance.m_edit.m_new.Enabled = FALSE

			CASE ELSE
				//	If the user is modify the Case Type table, they can not Insert new rows so disable
				//	the menu items. Otherwise enable the menu items.
				m_table_maintenance.m_edit.m_new.text = '&Insert New Record~tCtrl+N'
				m_table_maintenance.m_edit.m_new.toolbaritemtext = 'New'
				IF uo_table_maintenance.dw_table_maintenance.DataObject = 'd_tm_case_types' OR &
					uo_table_maintenance.dw_table_maintenance.DataObject = 'd_tm_reporting_fields' OR & 
					uo_table_maintenance.dw_table_maintenance.DataObject = 'd_tm_hotkeys' OR & 
					uo_table_maintenance.dw_table_maintenance.DataObject = 'd_tm_contacthistory_fields' THEN
					m_table_maintenance.m_edit.m_new.Enabled = FALSE
					m_table_maintenance.m_edit.m_delete.Enabled = FALSE
					m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				ELSEIF uo_table_maintenance.dw_table_maintenance.DataObject = 'd_tm_case_prop_field_defs' THEN
					m_table_maintenance.m_edit.m_sort.Enabled = TRUE
				ELSE
					m_table_maintenance.m_edit.m_new.Enabled = TRUE
					m_table_maintenance.m_edit.m_delete.Enabled = TRUE
					m_table_maintenance.m_edit.m_sort.Enabled = FALSE
				END IF
				m_table_maintenance.m_file.m_search.visible = FALSE
				m_table_maintenance.m_file.m_search.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.visible = FALSE
				m_table_maintenance.m_file.m_clearsearchcriteria.toolbaritemvisible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.visible = FALSE
				m_table_maintenance.m_edit.m_insertchildrecord.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_viewdetails.visible = FALSE
				m_table_maintenance.m_file.m_viewdetails.toolbaritemvisible = FALSE
				m_table_maintenance.m_file.m_editdocument.visible = FALSE
				m_table_maintenance.m_file.m_editdocument.toolbaritemvisible = FALSE
				uo_table_maintenance.dw_table_maintenance.SetFocus()
				
		END CHOOSE

END CHOOSE

// ensure that this separator is hidden whenever this menu item is hidden.
m_table_maintenance.m_file.m_filesep1.visible = m_table_maintenance.m_file.m_editdocument.visible
end event

event po_tabvalidate;call super::po_tabvalidate;//****************************************************************************************
//	Event:	po_tabvalidate
//	Purpose:	To determine which datawindow to use to allow the user to maintain the 
//				selected table.
//				
//	Date     Developer     Description
//	======== ============= ===============================================================
//	08/26/99 M. Caruso     Altered event to handle the new category maintenance screen.
//	08/31/99 M. Caruso     Re-assigning the tab objects with the required object assigned
//								  second solves the tab switching issue.
//	10/18/99 M. Caruso	  Only assign the tab object that will be visible on the Table
//								  Maintenance tab.
//	01/17/00 M. Caruso     Removed references to i_bCategoryMaintenance and updated code
//								  handle other "non-standard" table maintenance screens.
//	03/06/00 M. Caruso     Added code to handle the new IIM modules.
//	03/24/00 C. Jackson    Added fu_HLCreate for both Document Administration outliner 
//                        datawindows.  
// 08/18/00 K. Claver     Added code to handle the iim conversion object.  Can be removed
//								  after all clients are converted to 3.01 version
// 12/29/00 M. Caruso	  Moved the code to set i_cDisplayTableName to the beginning of the
//								  script and moved the fu_SetMessage function calls to outside of
//								  the case statement.
// 01/05/01 C. Jackson    Corrected the window names for Categories, IIM Tables and 
//                        IIM Tabs (SCR 1232)
// 02/20/01 M. Caruso     Removed code to reinitialize the category tab from CASE 2.
// 06/22/01 K. Claver     Commented out references to IIM table object for InfoMaker enhancement.
// 11/30/01 M. Caruso     Added a case for Correspondence.
// 12/12/01 M. Caruso     Prompt for save of letter_types when leaving the Maintenance tab.
// 01/10/02 K. Claver     Added the cases for the Forms Maintenance object.
// 03/04/03 M. Caruso     Only call fu_UpdateDetailsGUI for the form templates module if the
//								  user chose Yes or No to saving changes.  Do NOT run the function
//								  if Cancel was chosen.
// 06/10/03 M. Caruso     Added code to include processing of Field Label Maintenance module.
//****************************************************************************************/

INT				l_nReturnValue
LONG				l_lRow, l_nCount
STRING			l_cWindowName
WINDOWOBJECT	l_wTabObjects[]
U_DW_STD			l_dwObject


IF i_ClickedTab= 2 THEN
	// If the user doesn't have access to any tables
	IF uo_table_list.dw_table_list.RowCount() < 1 THEN 
		THIS.fu_SelectTab(1)
		RETURN
	END IF
	
	// Determine which table has been chosen
	i_cTableName = uo_table_list.dw_table_list.GetItemString(&
				uo_table_list.dw_table_list.i_SelectedRows[1], 'db_table_name')
	i_cDisplayTableName = uo_table_list.dw_table_list.GetItemString( &
						uo_table_list.dw_table_list.i_SelectedRows[1], 'display_table_name')
				
	CHOOSE CASE i_cTableName
		CASE "categories"
			// open the tab with the category maintenance screen visible
			l_wTabObjects[1] = uo_category_maintenance
			fu_AssignTab (2, l_wTabObjects[])
			
			uo_category_maintenance.dw_category_org.TriggerEvent ("po_pickedRow")
			
			PARENT.Title = PARENT.Tag + ' - Categories'
			
		CASE "letter_types"
			// open the tab with the category maintenance screen visible
			l_wTabObjects[1] = uo_cspd_maintenance
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - Letter Types'
		
		CASE "lookup_info"
			// open the tab with the bookmark maintenance screen visible
			l_wTabObjects[1] = uo_bookmark_maintenance
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - Bookmarks'
		
		CASE "iim_tabs"
			// open the tab with the iim configuration screen visible
			l_wTabObjects[1] = uo_iim_config
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - IIM Tabs'
			
		CASE "documents"
			// First determine if Document Types need to be added before going to Document Registration
			SELECT COUNT(*) INTO :l_nCount
			  FROM cusfocus.document_types
			 USING SQLCA;
			 
			IF l_nCount > 0 THEN
				
				// Determine if there are rows in Document Status
				SELECT COUNT (*) INTO :l_nCount
				  FROM cusfocus.document_status
				 USING SQLCA;
				
				IF l_nCount > 0 THEN
			 
					// open the tab with the document registration screen visible
					l_wTabObjects[1] = uo_document_registration
					i_bDocReg = TRUE
					fu_AssignTab (2, l_wTabObjects[])
					
					PARENT.Title = PARENT.Tag + ' - Document Registration'
				ELSE
					messagebox(gs_AppName,"Please Add Document Statuses before accessing Document Registration.")
					i_TabError = -1
					RETURN
				END IF
			ELSE
				messagebox(gs_AppName,'Please add Document Types before accessing Document Registration.')
				i_TabError = -1
				RETURN
			END IF
			
		CASE "document_ownership"
			// Set redraw off - will be set back on in u_document_administration.fu_RetrieveDocs
			uo_document_administration.Hide()
			uo_document_administration.SetReDraw(FALSE)
			// open the tab with the document administration screen visible
			l_wTabObjects[1] = uo_document_administration
			fu_AssignTab (2, l_wTabObjects[])
			
			// retrieve outliner windows
			// Set the options for dw_outliner_doc_types level 1
			uo_document_administration.dw_outliner_doc_types.fu_HLRetrieveOptions(1, &
							"open.bmp", &
							"closed.bmp", &
							"cusfocus.document_types.doc_type_id", &
							" ", &
							"doc_type_desc", &
							"doc_type_desc", &
							"cusfocus.document_types", &
							"active='Y'" , &
							uo_document_administration.dw_outliner_doc_types.c_KeyString)
			
			// Set the options for dw_outliner_doc_types level 2
			uo_document_administration.dw_outliner_doc_types.fu_HLRetrieveOptions(2, &
							"", &
							"", &
							"cusfocus.documents.doc_id", &
							"cusfocus.document_types.doc_type_id", &
							"doc_name", &
							"doc_name", &
							"cusfocus.documents", &
							"cusfocus.documents.doc_type_id=cusfocus.document_types.doc_type_id", &
							uo_document_administration.dw_outliner_doc_types.c_KeyString)
							
							
			uo_document_administration.dw_outliner_doc_types.fu_HLOptions (uo_document_administration.dw_outliner_doc_types.c_DrillDownOnClick + &
						uo_document_administration.dw_outliner_doc_types.c_HideBoxes)
			
			uo_document_administration.dw_outliner_doc_types.fu_HLCreate(SQLCA,2)	
				
			PARENT.Title = PARENT.Tag + ' - Document Administration'

		CASE "form_templates"
			// open the tab with the form maintenance screen visible
			l_wTabObjects[1] = uo_forms_maintenance
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - Form Templates'
			
		CASE "optional_grouping"
			// open the tab with the form maintenance screen visible
			l_wTabObjects[1] = uo_optional_grouping
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - Optional Grouping'	
			
		CASE "dateterm"
			// open the tab with the form maintenance screen visible
			l_wTabObjects[1] = uo_dateterm
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - Date Term'	
			
			uo_dateterm.TriggerEvent ("ue_refresh")
			
		CASE "field_definitions (labels)"
			// open the tab for changing demographic field labels.
			l_wTabObjects[1] = uo_field_label_maintenance
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - Update Field Labels'
			
		CASE "savedreport"
			// open the tab for configuring user report templates
			l_wTabObjects[1] = uo_search_report_templates
			fu_AssignTab (2, l_wTabObjects[])
			
			PARENT.Title = PARENT.Tag + ' - Configure User Report Templates'
			
		CASE ELSE
			// open the tab with the standard table maintenance screen visible
			l_wTabObjects[1] = uo_table_maintenance
			fu_AssignTab (2, l_wTabObjects[])
			
			// Get the datawindow name, the Display table name, the key column name. 
			i_cDataWindowName = uo_table_list.dw_table_list.GetItemString(&
					uo_table_list.dw_table_list.i_SelectedRows[1], 'datawindow_name')	
	
//			i_cDisplayTableName = uo_table_list.dw_table_list.GetItemString( &
//						uo_table_list.dw_table_list.i_SelectedRows[1], 'display_table_name')	
	
			i_cKeyColumnName = uo_table_list.dw_table_list.GetItemString( &
						uo_table_list.dw_table_list.i_SelectedRows[1], 'key_column_name')
			
			// Swap the datawindow object and set the PowerClass message object text.
			uo_table_maintenance.dw_table_maintenance.fu_Swap(i_cDataWindowName, &
				uo_table_maintenance.dw_table_maintenance.c_PromptChanges, &
				uo_table_maintenance.dw_table_maintenance.c_SelectOnRowFocusChange + &
				uo_table_maintenance.dw_table_maintenance.c_ModifyOnOpen + &
				uo_table_maintenance.dw_table_maintenance.c_ModifyOK + &
				uo_table_maintenance.dw_table_maintenance.c_NewOK + &
				uo_table_maintenance.dw_table_maintenance.c_DeleteOK + &
				uo_table_maintenance.dw_table_maintenance.c_ShowHighlight + &
				uo_table_maintenance.dw_table_maintenance.c_ActiveRowPointer + &
				uo_table_maintenance.dw_table_maintenance.c_NoInactiveRowPointer + &
				uo_table_maintenance.dw_table_maintenance.c_TabularFormStyle + &
				uo_table_maintenance.dw_table_maintenance.c_SortClickedOK)
	
			PARENT.Title = PARENT.Tag + ' - ' + i_cDisplayTableName
			
	END CHOOSE
	
	FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, &
							i_cSaveChangesMessage + i_cDisplayTableName + " table?")
							
	FWCA.MSG.fu_SetMessage("DeleteOKOne", FWCA.MSG.c_MSG_Text, &
							i_cDeletedrowmessage + i_cDisplayTableName + " table?")
	
ELSE
	//	Check the Status of the datawindow and prompt the user if necessary.
	CHOOSE CASE i_cTableName
		CASE "categories"
			// close the category maintenance screen
			l_dwObject = uo_category_maintenance.dw_category_details
			l_nReturnValue = l_dwObject.fu_Save(l_dwObject.c_PromptChanges)

		CASE "iim_tabs"
			// add code to save changes on the iim_config tab
			l_dwObject = uo_iim_config.dw_tab_details
			l_nReturnValue = l_dwObject.fu_Save (l_dwObject.c_PromptChanges)
			
		CASE "letter_types"
			// add code to save changes on the letter_types tab
			l_dwObject = uo_cspd_maintenance.dw_docdetails
			l_nReturnValue = l_dwObject.fu_Save (l_dwObject.c_PromptChanges)
			
		CASE "field_definitions (labels)"
			// add code to save changes on the letter_types tab
			l_dwObject = uo_field_label_maintenance.dw_label_assignment
			l_nReturnValue = l_dwObject.fu_Save (l_dwObject.c_PromptChanges)
			// if the tab is changing but the data changes were not saved, reload the last save data.
			IF l_dwObject.i_DWSRV_EDIT.i_SaveStatus = 2 THEN
				uo_field_label_maintenance.fu_UpdateContainerOnSourceChange (uo_field_label_maintenance.i_nPreviousIndex)
			END IF
		
		CASE "form_templates"
			// add code to save changes on the form templates tab
			l_dwObject = uo_forms_maintenance.dw_template_properties
			l_nReturnValue = l_dwObject.fu_Save (l_dwObject.c_PromptChanges)
			IF l_nReturnValue = l_dwObject.c_Success THEN
				uo_forms_maintenance.fu_UpdateDetailsGUI ()
			END IF
			
		CASE ELSE  // close standard table maintenance screens
			l_dwObject = uo_table_maintenance.dw_table_maintenance
			l_nReturnValue = l_dwObject.fu_Save (l_dwObject.c_PromptChanges)
								
	END CHOOSE
	IF l_nReturnValue = l_dwObject.c_Fatal THEN
		i_TabError = -1 
		RETURN
	END IF
	PARENT.Title = PARENT.Tag
END IF


end event

type uo_iim_config from u_iim_config within w_table_maintenance
integer x = 23
integer y = 104
integer taborder = 20
boolean border = false
end type

on uo_iim_config.destroy
call u_iim_config::destroy
end on

type uo_bookmark_maintenance from u_bookmark_maintenance within w_table_maintenance
integer x = 23
integer y = 104
integer taborder = 30
end type

on uo_bookmark_maintenance.destroy
call u_bookmark_maintenance::destroy
end on

type uo_forms_maintenance from u_forms_maintenance within w_table_maintenance
integer x = 23
integer y = 104
integer taborder = 20
boolean border = false
end type

on uo_forms_maintenance.destroy
call u_forms_maintenance::destroy
end on

type uo_field_label_maintenance from u_field_label_maintenance within w_table_maintenance
integer x = 23
integer y = 104
integer taborder = 30
boolean border = false
end type

on uo_field_label_maintenance.destroy
call u_field_label_maintenance::destroy
end on

type uo_optional_grouping from u_optional_grouping2 within w_table_maintenance
integer x = 18
integer y = 108
integer height = 1616
integer taborder = 20
boolean border = false
end type

on uo_optional_grouping.destroy
call u_optional_grouping2::destroy
end on

event constructor;call super::constructor;this. width = uo_forms_maintenance. width
this. height = uo_forms_maintenance. height
end event

type uo_dateterm from uo_dateterm_maint within w_table_maintenance
integer x = 23
integer y = 104
integer width = 3570
integer height = 1592
integer taborder = 20
end type

on uo_dateterm.destroy
call uo_dateterm_maint::destroy
end on

type uo_search_report_templates from u_search_report_templates within w_table_maintenance
integer x = 50
integer y = 104
integer width = 3529
integer height = 1588
integer taborder = 50
end type

on uo_search_report_templates.destroy
call u_search_report_templates::destroy
end on

