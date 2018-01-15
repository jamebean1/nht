$PBExportHeader$w_cross_ref.srw
forward
global type w_cross_ref from w_create_maintain_case
end type
type cb_selectsearch from commandbutton within w_cross_ref
end type
type cb_selectresult from commandbutton within w_cross_ref
end type
end forward

global type w_cross_ref from w_create_maintain_case
integer height = 1816
string title = "Cross Reference Search"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_search ( )
event ue_searchcancel ( )
event ue_selectandreturn ( integer ai_sourcetab )
cb_selectsearch cb_selectsearch
cb_selectresult cb_selectresult
end type
global w_cross_ref w_cross_ref

type variables
BOOLEAN i_bXrefDetail = FALSE

String is_passedSearchType
end variables

forward prototypes
public subroutine fw_aftersearch ()
end prototypes

event ue_search();/****************************************************************************************
	Event:	ue_search
	Purpose:	To trigger the pc_search event from PowerClass
	
	Revisions:
	Date     Developer     Description
   ======== ============= ===============================================================
	10/29/2005 K. Claver   Adapted from m_file.m_search in m_create_maintain_case
****************************************************************************************/

BOOLEAN			l_bContinue, l_bRTSearch
INTEGER			l_nTotalColumns, l_nInitialColumn, l_nIndex
LONG				l_nRow
STRING			l_cColName, l_cValue
U_DW_SEARCH		l_dwSearchCriteria
U_DW_MAIN		l_dwMatchedRecords

IF IsValid(THIS) THEN
	
	CHOOSE CASE THIS.dw_folder.i_SelectedTab
		CASE 1		// Search Tab
			// set up reference variable
			l_dwSearchCriteria = THIS.uo_search_criteria.dw_search_criteria
			
			// disable datawindow refresh
			l_dwSearchCriteria.SetRedraw (FALSE)
			
			// reset the i_SearchError instance variable
			l_dwSearchCriteria.i_SearchError = 0
			
			// prepare for validation of criteria
			THIS.i_cSelectedCase = ''
			THIS.i_cCurrentCaseSubject = ''
			THIS.i_cCaseSubjectName = ''
			l_dwSearchCriteria = THIS.uo_search_criteria.dw_search_criteria
			l_dwSearchCriteria.AcceptText ()
			l_bContinue = FALSE
			l_nTotalColumns = INTEGER (l_dwSearchCriteria.Object.Datawindow.Column.Count)
			l_nRow = l_dwSearchCriteria.GetRow ()
			l_nInitialColumn = l_dwSearchCriteria.GetColumn ()
			
			// verify that valid criteria are specified
			FOR l_nIndex = 1 TO l_nTotalColumns
				
				l_dwSearchCriteria.SetColumn (l_nIndex)
				IF (l_dwSearchCriteria.i_SearchError = l_dwSearchCriteria.c_ValOK) OR &
					(l_dwSearchCriteria.i_SearchError = l_dwSearchCriteria.c_ValFixed) THEN
					
					// this item passed validation
					l_cColName = l_dwSearchCriteria.Describe ('#' + STRING (l_nIndex) + '.Name')
					l_cValue = l_dwSearchCriteria.fu_SelectCode (l_cColName)
					
					// if value does not specify a pure wildcard search, allow to continue
					IF l_cValue <> '%' AND l_cValue <> '' THEN l_bContinue = TRUE
					
				ELSE
					
					// something failed validation, so stop processing
					l_bContinue = FALSE
					EXIT
					
				END IF
				
			NEXT
			
			// reselect the initial column
			l_dwSearchCriteria.SetColumn (l_nInitialColumn)
			
			IF l_bContinue THEN
				
				l_dwMatchedRecords = THIS.uo_search_criteria.uo_matched_records.dw_matched_records
				CHOOSE CASE l_dwMatchedRecords.DataObject
					CASE 'd_matched_consumers','d_matched_consumers_rt'
						IF gs_rt_members = 'Y' THEN
							l_bRTSearch = TRUE
						ELSE
							l_bRTSearch = FALSE
						END IF
						
					CASE 'd_matched_providers','d_matched_providers_rt'
						IF gs_rt_providers = 'Y' THEN
							l_bRTSearch = TRUE
						ELSE
							l_bRTSearch = FALSE
						END IF
						
					CASE 'd_matched_groups','d_matched_employers_rt'
						IF gs_rt_groups = 'Y' THEN
							l_bRTSearch = TRUE
						ELSE
							l_bRTSearch = FALSE
						END IF
						
					CASE ELSE
						l_bRTSearch = FALSE
						
				END CHOOSE
				
				IF l_bRTSearch THEN
					
					// Build the Search Argument List
					THIS.uo_search_criteria.fu_BuildRealTimeArgsList()
					l_dwMatchedRecords.fu_retrieve (l_dwMatchedRecords.c_IgnoreChanges, l_dwMatchedRecords.c_NoReselectRows)
					IF l_dwMatchedRecords.RowCount() > 0 THEN
						l_dwMatchedRecords.SetFocus()
					END IF
					
				ELSE
					
					// trigger the search process
					THIS.TriggerEvent ('pc_search')
					
				END IF
				
				//THIS.POST fw_AfterSearchProcess ()
				THIS.POST fw_AfterSearch( )
			ELSE
				
				// do not display message if bad data caused continue to be false
				IF (l_dwSearchCriteria.i_SearchError = l_dwSearchCriteria.c_ValOK) OR &
					(l_dwSearchCriteria.i_SearchError = l_dwSearchCriteria.c_ValFixed) THEN
					
					MessageBox ("No Search Criteria", "You must enter criteria to perform a search.")
					
				END IF
				
			END IF
			
			// restore datawindow refresh
			l_dwSearchCriteria.SetRedraw (TRUE)
			
	END CHOOSE
	
END IF
end event

event ue_searchcancel;//*********************************************************************************************
//  Event:   ue_searchcancel
//  Purpose: Cancel the current search on the search tab.
//  
//  Date     Developer   Describe
//  -------- ----------- ----------------------------------------------------------------------
//  10/29/2005 K. Claver   Created.
//*********************************************************************************************

THIS.uo_search_criteria.i_bCancelSearch = TRUE


end event

event ue_selectandreturn(integer ai_sourcetab);/****************************************************************************************
	Event:	ue_selectAndReturn
	Purpose:	Return the information back to the calling 
	
	Revisions:
	Date     Developer     Description
   ======== ============= ===============================================================
	10/29/2005 K. Claver   Created
****************************************************************************************/
String l_cXrefSubjectID
Integer l_nRow
Long l_nProviderKey

//Gather information to pass back and then close
IF NOT uo_search_criteria.i_bInSearch THEN // only process if not currently doing a search

	l_nRow = uo_search_criteria.uo_matched_records.dw_matched_records.GetRow()
	
	IF l_nRow <= 0 THEN
	
		messagebox(gs_AppName,'No record selected.')
		RETURN
	END IF
		
	IF uo_search_criteria.i_wParentWindow.i_nRepRecConfidLevel >= uo_search_criteria.i_wParentWindow.i_nRecordConfidLevel OR &
		IsNull( uo_search_criteria.i_wParentWindow.i_nRecordConfidLevel ) OR uo_search_criteria.i_cCurrUser = "cfadmin" THEN
//		9.1.2006 JWhite SQL2005 mandated change from sysadmin to cfadmin
//		IsNull( uo_search_criteria.i_wParentWindow.i_nRecordConfidLevel ) OR uo_search_criteria.i_cCurrUser = "sysadmin" THEN		
		IF NOT IsNull( uo_search_criteria.i_wParentWindow.i_nRecordConfidLevel ) THEN
			MessageBox( gs_AppName, "This Demographic is secured for internal purposes.  You have access to select it.~r~n"+ &
							"However, please remember that this information is strictly confidential." )
		END IF
	ELSE
		MessageBox( gs_AppName, "This Demographic record is secured for internal purposes.~r~n"+ &
						"You do not have access to select it.", StopSign!, Ok! )
						
		RETURN
	END IF
	
	
	CHOOSE CASE i_cSourceType
		CASE 'P'
			l_nProviderKey = uo_search_criteria.uo_matched_records.dw_matched_records.GetItemNumber(l_nRow,'provider_of_service_provider_key')
			l_cXRefSubjectID = String( l_nProviderKey )
			
		CASE 'C'
			l_cXRefSubjectID = uo_search_criteria.uo_matched_records.dw_matched_records.GetItemString(l_nRow,'consumer_id')
			
		CASE 'E'
			l_cXRefSubjectID = uo_search_criteria.uo_matched_records.dw_matched_records.GetItemString(l_nRow,'group_id')

		CASE 'O'
			l_cXRefSubjectID = uo_search_criteria.uo_matched_records.dw_matched_records.GetItemString(l_nRow,'customer_id')
			
	END CHOOSE
	
	l_cXRefSubjectID = i_cSourceType + l_cXRefSubjectID
	CloseWithReturn(THIS,l_cXRefSubjectID)
END IF
	


end event

public subroutine fw_aftersearch ();/*****************************************************************************************
   Function:   fw_AfterSearch
   Purpose:    After performing the search screen query, run this code. This code was
					taken from the pc_search event of w_create_maintain_case.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	08/19/03 M. Caruso    Created.
	12/11/03 M. Caruso    Added a separate prompt for when no matching cases are found in
								 a case search.
*****************************************************************************************/

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
		MessageBox( gs_AppName, "There are no records which meet the search criteria.", StopSign!, Ok! )
		dw_folder.fu_DisableTab (2)

	CASE IS > 0
		//---------------------------------------------------------------------------------
		//		Enable the Demographics and all the Case Detail Tabs if its not a case search
		//----------------------------------------------------------------------------------

		l_nRowsToSelect[1] = 1
		uo_search_criteria.uo_matched_records.dw_matched_records.fu_SetSelectedRows(1, l_nRowsToSelect[], &
										uo_search_criteria.uo_matched_records.dw_matched_records.c_IgnoreChanges, &
										uo_search_criteria.uo_matched_records.dw_matched_records.c_NoRefreshChildren)
	
			
		IF uo_search_criteria.uo_matched_records.dw_matched_records.RowCount() = 1 AND NOT uo_search_criteria.i_bCancelSearch THEN
			dw_folder.fu_SelectTab (2)
			
			IF i_bXrefDetail THEN
				//Disable the select buttons and the first tab
				cb_SelectSearch.Visible = FALSE
				cb_SelectResult.Visible = FALSE
				dw_folder.fu_DisableTab (1)
			END IF
		END IF
			
		
END CHOOSE

//Make sure the search and clearsearch buttons are disabled
IF IsValid( m_create_maintain_case ) THEN
	m_create_maintain_case.m_file.m_search.enabled = FALSE
	m_create_maintain_case.m_file.m_clearsearchcriteria.enabled = FALSE
END IF
end subroutine

on w_cross_ref.create
int iCurrent
call super::create
this.cb_selectsearch=create cb_selectsearch
this.cb_selectresult=create cb_selectresult
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_selectsearch
this.Control[iCurrent+2]=this.cb_selectresult
end on

on w_cross_ref.destroy
call super::destroy
destroy(this.cb_selectsearch)
destroy(this.cb_selectresult)
end on

event pc_setoptions;/*****************************************************************************************
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

STRING       l_cRoleName[], l_cUserID, l_cParm, l_cXRefSubjectID, l_cXrefSourceType, l_cXrefProvType
STRING		 l_cParent
INT          l_nNumOfRoles, l_nCounter
LONG         l_nRoleKey[], l_nPos, l_nXrefProvKey
WINDOWOBJECT l_woTabObjects1[]

//	Create some constants for Set_DW_Options
i_ulDemographicsCW 	=	uo_search_criteria.uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange
i_ulDemographicsVW  	=  uo_search_criteria.uo_matched_records.dw_matched_records.c_FreeFormStyle + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
								uo_search_criteria.uo_matched_records.dw_matched_records.c_NoInactiveRowPointer

//	Set the defaults for the folder object
dw_folder.fu_TabOptions('Arial', 9, dw_folder.c_DefaultVisual)
dw_folder.fu_TabDisableOptions('Arial', 9, dw_folder.c_TextDisableRegular)
dw_folder.fu_TabCurrentOptions('Arial', 9, dw_folder.c_DefaultVisual)

Tag = Title

//	Assign the Search user object to the window object array
l_woTabObjects1[1] = uo_search_criteria

//	Attach lables and window object array to tabs
dw_folder.fu_AssignTab(1, "Search", l_woTabObjects1[])
dw_folder.fu_AssignTab(2, "Demographics")

//	Create the tab folder
//dw_folder.fu_folderCreate(8,8)
dw_folder.fu_folderCreate(2,2)

//	Select the Search Criteria Tab and Disable Demographics, ProActive
//	Correspondence and Case Reminders tabs.
dw_folder.fu_SelectTab(1)

dw_folder.fu_DisableTab(2)

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

uo_search_criteria.dw_search_criteria.SetFocus()

// Add no records message for Document Quick Interface
OBJCA.MSG.fu_AddMessage ("docs_no_rows","<application_name>", &
								 "There are no documents for %s.", &
								 OBJCA.MSG.c_msg_none, OBJCA.MSG.c_msg_ok, &
								 1, OBJCA.MSG.c_Enabled)
								 
// initialize the resize service for this window
i_nBaseWidth = Width
i_nBaseHeight = Height   // this offset value was needed to make the sizing correct.

of_SetResize (TRUE)

IF IsValid (inv_resize) THEN
//	inv_resize.of_SetOrigSize ((Width - 30), (Height - 178))
//	inv_resize.of_SetMinSize ((Width - 30), (Height - 178))
	inv_resize.of_SetOrigSize (Width, Height)
	inv_resize.of_SetMinSize (Width, Height)
	
	inv_resize.of_Register (dw_folder, inv_resize.SCALERIGHTBOTTOM)
	inv_resize.of_Register (uo_search_criteria, inv_resize.SCALERIGHTBOTTOM)
	
END IF

//Remove the Other and Case search types for this
// Changed to keep Other, but get rid of Appeal
uo_search_criteria.ddlb_search_type.DeleteItem( 6 )
uo_search_criteria.ddlb_search_type.DeleteItem( 5 )

//Retrieve the demographics if values are passed.

l_cParm = message.StringParm

l_nPos = POS(l_cParm,',')

l_cParent = MID(l_cParm,1,l_nPos - 1 )

l_cParm = MID(l_cParm,l_nPos + 1 )

l_nPos = POS(l_cParm,',')
l_cXRefSourceType = MID(l_cParm,1,1)

l_cParm = MID(l_cParm,l_nPos + 1)

IF l_cXRefSourceType = 'P' THEN

	l_nPos = POS(l_cParm,',')
	l_nXRefProvKey = LONG(MID(l_cParm,1,l_nPos - 1))
	
	l_cXRefProvtype = Trim( Mid( l_cParm, ( l_nPos + 1 ) ) )
	
	//Get the associated provider id
	SELECT provider_id
	INTO :l_cXRefSubjectID
	FROM cusfocus.provider_of_service
	WHERE provider_key = :l_nXRefProvKey
	USING SQLCA;
	
ELSE
	
	l_cXRefSubjectID = l_cParm
	
END IF

//This even posted to ensure that the user specific search result formatting is
//  finished
IF NOT IsNull( l_cXrefSubjectID ) AND Trim( l_cXrefSubjectID ) <> "" THEN
	i_bXrefDetail = TRUE
	dw_folder.Event Post ue_demographicSearch( l_cXrefSourceType, l_cXrefSubjectID )
END IF
end event

event timer;//
end event

event pc_close;//**********************************************************************************************
//
//  Event:   pc_close
//  Purpose: Clean up
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  11/05/2005 K. Claver   Override Ancestor functionality
//
//**********************************************************************************************


end event

type uo_search_criteria from w_create_maintain_case`uo_search_criteria within w_cross_ref
end type

event uo_search_criteria::pc_setoptions;//***********************************************************************************************
// 
//  Event:   pc_setoptions
//  Purpose: To set the options for uo_dw_main, initialize the search arrays, and wire the Search 
//           Datawindow to uo_dw_main and disable the PowerClass object for no rows found via a 
//			  Search.
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  07/08/99 M. Caruso   Modified code to initialize the search window according to the default 
//                       search type.
//  07/12/99 M. Caruso   Added call to fw_buildfieldlist to set up configurable fields for the 
//                       datawindow.
//  07/16/99 M. Caruso   Moved calls to fw_buildfieldlist().
//  07/19/99 M. Caruso   Perform InsertRow after assigning datawindow object.  Call 
//                       fu_buildsearchlists.
//  07/22/99 M. Caruso   Move InsertRow after adding configured fields and the whole window 
//                       displays at one time.  Also, to prevent flicker, the default datawindow 
//							    object has been removed from the control and the control is set to 
//							    INVISIBLE.  Setting the Visible variable after the initialization was the 
//							    only was to prevent a nasty flicker.
//  07/29/99 M. Caruso   Removed call to fw_buildfieldlist for search type CASE
//  07/30/99 M. Caruso   Added c_NoMenuButtonActivation constant to all fu_swap calls to prevent 
//                       the datawindow from altering menu/toolbar settings.
//  08/12/99 M. Caruso   Removed "(All)" option from search criteria drop downs.
//  10/30/00 M. Caruso   Added resize service.
//  11/16/00 M. Caruso   Implemented the new click-sort routine on uo_matched_records.dw_matched_records.
//  01/13/01 M. Caruso   Initialize i_bInSearch.
//  04/16/01 C. Jackson  Add Source Type to Case Search (SCR 340)
//  7/3/2001 K. Claver   Modified to populate the provider type drop down using a drop
//								 a drop down datawindow.
//  10/17/2001 K. Claver Enhanced for registry.
//  07/07/03 M. Caruso   Added a call to fu_UpdateSearchResultsLabels () for each source type.
//  08/18/03 M. Caruso   Add '_rt' to the datawindow object name if Real-Time demographics is
//								 activated for the source type.
//***********************************************************************************************

STRING	l_sSearchType, l_cDataObject
LONG 		l_nReturn
DATAWINDOWCHILD l_dwcCaseRep, l_dwcProviderType

//Get the current user as will need throughout object for various tasks
THIS.i_cCurrUser = OBJCA.WIN.fu_GetLogin( SQLCA )

//Create the blob manipulator to handle the blobs for the user specific result sets
THIS.in_blob_manipulator = Create n_blob_manipulator

//Create the datastore to retrieve the information to retrieve the datawindow blob for the user
THIS.ids_syntax	= Create datastore
THIS.ids_syntax.Dataobject = 'd_data_syntaxstorage'
THIS.ids_syntax.SetTransObject(SQLCA)

//Create the datastore to contain the configurable result set fields
THIS.ids_results_fields = CREATE datastore
THIS.ids_results_fields.DataObject = 'd_tm_field_defs'
THIS.ids_results_fields.SetTransObject( SQLCA )

//Create the datastore to contain the display formats
THIS.ids_display_formats = CREATE datastore
THIS.ids_display_formats.DataObject = "dddw_display_formats"
THIS.ids_display_formats.SetTransObject( SQLCA )

SetPointer( Hourglass! )
uo_matched_records.Visible = FALSE

THIS.ids_syntax.Retrieve( THIS.i_cCurrUser )
THIS.ids_results_fields.Retrieve( )
THIS.ids_display_formats.Retrieve( )

//---------------------------------------------------------------------------------------
//		Initialize the search results datawindow.
//--------------------------------------------------------------------------------------
uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
		uo_matched_records.dw_matched_records.c_NullDW, & 
 		uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
 		uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
 		uo_matched_records.dw_matched_records.c_TabularFormStyle + &
 		uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
 		uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
		uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
		uo_matched_records.dw_matched_records.c_SortClickedOK+ &
		uo_matched_records.dw_matched_records.c_NoEnablePopup )
		
i_bInSearch = FALSE

//IF Upper(gs_seachtype) = "NONE" OR IsNull( gs_SeachType ) OR Trim( gs_SeachType ) = "" THEN
//	IF OBJCA.MGR.i_Source = "R" THEN
//		RegistrySet( ( OBJCA.MGR.i_RegKey+gs_AppFullVersion+"\Application Info\search type" ), "default", &
//						 RegString!, "MEMBER" )
//	ELSE
//		SetProfileString (OBJCA.MGR.i_ProgINI,"Search Type","default","MEMBER")
//	END IF
	gs_seachtype = "MEMBER"
//END IF



CHOOSE CASE gs_seachtype
	CASE "MEMBER"
		//------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Member",0)
		
		//------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_consumer'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('C')    // build for (C)onsumer
		fu_displayfields ('C')
		dw_search_criteria.insertrow(0)
		dw_search_criteria.Visible = TRUE
		
		//-------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//-------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_consumers'
		// use the real-time version if needed.
		IF gs_rt_members = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_NoQuery + &
											uo_matched_records.dw_matched_records.c_SortClickedOK+ &
											uo_matched_records.dw_matched_records.c_NoEnablePopup )
		
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK+ &
													uo_matched_records.dw_matched_records.c_NoEnablePopup )

		fu_UpdateSearchResultsLabels ('C')
		fu_resizeline ()
		fu_buildsearchlists('C')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time).
		//------------------------------------------------------------------------------------
		
		IF gs_rt_members = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
		
	CASE "GROUP"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Group",0)
		
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_employer'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('E')    // build for (E)mployer Group
		fu_displayfields ('E')
		dw_search_criteria.insertrow(0)   // This actually makes the datawindow visible
		dw_search_criteria.Visible = TRUE
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//-------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_employers'
		// use the real-time version if needed.
		IF gs_rt_groups = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK+ &
											uo_matched_records.dw_matched_records.c_NoEnablePopup )
		
		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK+ &
													uo_matched_records.dw_matched_records.c_NoEnablePopup )
		
		fu_UpdateSearchResultsLabels ('E')
		fu_resizeline ()
		fu_buildsearchlists('E')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time).
		//------------------------------------------------------------------------------------
		IF gs_rt_groups = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
		
	CASE "PROVIDER"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Provider",0)
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_provider'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('P')    // build for (P)rovider
		fu_displayfields ('P')
		dw_search_criteria.insertrow(0)   // This actually makes the datawindow visible
		dw_search_criteria.Visible = TRUE
		
		//-------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		l_cDataObject = 'd_matched_providers'
		// use the real-time version if needed.
		IF gs_rt_providers = 'Y' THEN l_cDataObject = l_cDataObject + '_rt'
		
		uo_matched_records.dw_matched_records.fu_Swap(l_cDataObject, uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK+ &
											uo_matched_records.dw_matched_records.c_NoEnablePopup )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( l_cDataObject )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK+ &
													uo_matched_records.dw_matched_records.c_NoEnablePopup )

		fu_UpdateSearchResultsLabels ('P')
		fu_resizeline ()
		fu_buildsearchlists('P')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main (if not real-time) and load the Provider types
		//------------------------------------------------------------------------------------
		IF gs_rt_providers = 'N' THEN
			dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
					i_cSearchTable[], i_cSearchColumn[], SQLCA)
		END IF
		
		dw_search_criteria.GetChild( "provider_type", l_dwcProviderType )
		l_dwcProviderType.SetTransObject( SQLCA )
		l_dwcProviderType.Retrieve( )
		
//		Error.i_FWError = dw_search_criteria.fu_LoadCode("provider_type", &
//												"cusfocus.provider_types", &
//												"provider_type", &
//												"provid_type_desc", &
//												"active='Y'", "")
		
	CASE "OTHER"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Other",0)
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//--------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_other'
		
		//------------------------------------------------------------------------------------
		//		Add user configurable fields.
		//------------------------------------------------------------------------------------
		i_wparentwindow.fw_buildfieldlist('O')    // Build for (O)ther
		fu_displayfields ('O')
		dw_search_criteria.insertrow(0)   // This actually makes the datawindow visible
		dw_search_criteria.Visible = TRUE
		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_others', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK+ &
											uo_matched_records.dw_matched_records.c_NoEnablePopup )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( "d_matched_others" )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK+ &
													uo_matched_records.dw_matched_records.c_NoEnablePopup )
		
		fu_UpdateSearchResultsLabels ('O')
		fu_resizeline ()
		fu_buildsearchlists('O')
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main and Load the customer types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("customer_type", &
												"cusfocus.customer_types", &
												"customer_type", &
												"cust_type_desc", &
												"active='Y'", "")
		
	CASE "CASE"
		//---------------------------------------------------------------------------------------
		//		Initialize the search type drop down list box.
		//--------------------------------------------------------------------------------------
		ddlb_search_type.SelectItem ("Case",0)
		
		//---------------------------------------------------------------------------------------
		//		Swap datawindow objects for the search datawindow control
		//---------------------------------------------------------------------------------------
		dw_search_criteria.DataObject = 'd_search_case'
		dw_search_criteria.Visible = TRUE
		dw_search_criteria.insertrow(0)

		
		//--------------------------------------------------------------------------------------
		//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
		//		record datawindow is uo_dw_main...
		//--------------------------------------------------------------------------------------
		
		
		uo_matched_records.dw_matched_records.fu_Swap('d_matched_cases', uo_matched_records.dw_matched_records.c_IgnoreChanges, &
											uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
											uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
											uo_matched_records.dw_matched_records.c_TabularFormStyle + &
											uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
											uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
											uo_matched_records.dw_matched_records.c_SortClickedOK+ &
											uo_matched_records.dw_matched_records.c_NoEnablePopup )

		//Build the datawindow from stored syntax, if it exists
		uo_matched_records.dw_matched_records.Event Trigger ue_buildDatawindow( "d_matched_cases" )
		
		//Need to call this after build the datawindow so options are reset
		uo_matched_records.dw_matched_records.fu_SetOptions( SQLCA, & 
													uo_matched_records.dw_matched_records.c_NullDW, & 
													uo_matched_records.dw_matched_records.c_SelectOnRowFocusChange + &
													uo_matched_records.dw_matched_records.c_NoRetrieveOnOpen + &
													uo_matched_records.dw_matched_records.c_TabularFormStyle + &
													uo_matched_records.dw_matched_records.c_NoActiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoInactiveRowPointer + &
													uo_matched_records.dw_matched_records.c_NoMenuButtonActivation + &
													uo_matched_records.dw_matched_records.c_SortClickedOK+ &
													uo_matched_records.dw_matched_records.c_NoEnablePopup )
		
		fu_resizeline ()
		
		i_cCriteriaColumn[1] = "case_number"
		i_cCriteriaColumn[2] = "case_log_case_rep"
		i_cCriteriaColumn[3] = "case_type"
		i_cCriteriaColumn[4] = "case_status_id"
		i_cCriteriaColumn[5] = "case_log_opnd_date"
		i_cCriteriaColumn[6] = "source_type"
		i_cCriteriaColumn[7] = "master_case_number"
		
		i_cSearchTable[1] = "cusfocus.case_log"
		i_cSearchTable[2] = "cusfocus.case_log"
		i_cSearchTable[3] = "cusfocus.case_log"
		i_cSearchTable[4] = "cusfocus.case_log"
		i_cSearchTable[5] = "cusfocus.case_log"
		i_cSearchTable[6] = "cusfocus.case_log"
		i_cSearchTable[7] = "cusfocus.case_log"
		
		i_cSearchColumn[1] = "case_number"
		i_cSearchColumn[2] = "case_log_case_rep"
		i_cSearchColumn[3] = "case_type"
		i_cSearchColumn[4] = "case_status_id"
		i_cSearchColumn[5] = "case_log_opnd_date"
		i_cSearchColumn[6] = "source_type"
		i_cSearchColumn[7] = "master_case_number"
		
		//------------------------------------------------------------------------------------
		//		Wire the Search object to uo_dw_main, load the Case Status and Case Types
		//------------------------------------------------------------------------------------
		dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], uo_matched_records.dw_matched_records, &
			i_cSearchTable[], i_cSearchColumn[], SQLCA)
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("case_type", &
												"cusfocus.case_types", &
												"case_type", &
												"case_type_desc", &
												"active = 'Y'", "")
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("case_status_id", &
												"cusfocus.case_status", &
												"case_status_id", &
												"case_stat_desc", &
												"active = 'Y'", "")
		
		Error.i_FWError = dw_search_criteria.fu_LoadCode("source_type", &
												"cusfocus.source_types", &
												"source_type", &
												"source_desc", &
												"active = 'Y'", "")
		
		l_nReturn = dw_search_criteria.GetChild('case_log_case_rep', l_dwcCaseRep)
		l_dwcCaseRep.SetTransObject(SQLCA)
		l_dwcCaseRep.Retrieve()
		
END CHOOSE

//------------------------------------------------------------------------------------
//    Complete initialization of variables and available Tabs.
//------------------------------------------------------------------------------------
i_wParentWindow.i_cCurrentCaseSubject = ''
i_wParentWindow.i_cSelectedCase = ''
i_wParentWindow.i_cCaseSubjectName = ''

i_wParentWindow.dw_folder.fu_DisableTab(3)  // remove when this tab is defined.
i_wParentWindow.dw_folder.fu_DisableTab(5)
i_wParentWindow.dw_folder.fu_DisableTab(6)
i_wParentWindow.dw_folder.fu_DisableTab(7)
i_wParentWindow.dw_folder.fu_DisableTab(8)

IF (uo_matched_records.dw_matched_records.RowCount() > 0) THEN
	i_wParentWindow.dw_folder.fu_EnableTab(2)
//	i_wParentWindow.dw_folder.fu_EnableTab(3)
	i_wParentWindow.dw_folder.fu_EnableTab(4)
ELSE
	i_wParentWindow.dw_folder.fu_DisableTab(2)
//	i_wParentWindow.dw_folder.fu_DisableTab(3)
	i_wParentWindow.dw_folder.fu_DisableTab(4)
END IF

i_wParentWindow.Title = i_wParentWindow.Tag

m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled = FALSE
m_create_maintain_case.m_file.m_printcasedetailreport.Enabled = FALSE

dw_search_criteria.SetFocus()

OBJCA.MSG.fu_SetMessage("ZeroSearchRows", OBJCA.MSG.c_MSG_Status, "0")

// initialize resize service for this container object
of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	inv_resize.of_Register (dw_search_criteria, "ScaleToRight")
	inv_resize.of_Register (uo_matched_records.dw_matched_records, "ScaleToRight&Bottom")
	inv_resize.of_Register (gb_search_criteria, "ScaleToRight")
END IF

uo_matched_records.Visible = TRUE
SetPointer( Arrow! )
end event

type dw_folder from w_create_maintain_case`dw_folder within w_cross_ref
event ue_demographicsearch ( string as_type,  string as_key )
integer height = 1712
end type

event dw_folder::ue_demographicsearch(string as_type, string as_key);/*****************************************************************************************
	Event:		ue_demographicsearch
	Purpose:		To automate the process of searching by demographic.  Called when window is
					opened to look at details of the member, provider or group
					
	Parameters: as_type - String - type of search
					as_key - String - demographic record key
					
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	10/29/2005 K. Claver   Created
*****************************************************************************************/
LONG		l_lRow
INTEGER  l_iIndex

// turn off redraw for the folder datawindow until after all processing is done
This.SetRedraw (FALSE)

// prepare the window to search by demographic.
CHOOSE CASE as_type
	CASE 'C'
		uo_search_criteria.ddlb_search_type.SelectItem ("Member",0)
		l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Member",0)		
	CASE 'P'
		uo_search_criteria.ddlb_search_type.SelectItem ("Provider",0)
		l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Provider",0)
	CASE 'E'
		uo_search_criteria.ddlb_search_type.SelectItem ("Group",0)
		l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Group",0)
	CASE 'O'
		uo_search_criteria.ddlb_search_type.SelectItem ("Other",0)
		l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Other",0)
END CHOOSE

uo_search_Criteria.ddlb_search_type.Event Trigger selectionchanged( l_iIndex )

// set the search criteria.
l_lRow = uo_search_criteria.dw_search_criteria.GetRow ()

CHOOSE CASE as_type
	CASE 'C'
		uo_search_criteria.dw_search_criteria.SetItem (l_lRow, "consumer_id", Trim(as_key))
	CASE 'P'
		uo_search_criteria.dw_search_criteria.SetItem (l_lRow, "provider_id", Trim(as_key))
	CASE 'E'
		uo_search_criteria.dw_search_criteria.SetItem (l_lRow, "group_id", Trim(as_key))
	CASE 'O'
		uo_search_criteria.dw_search_criteria.SetItem (l_lRow, "customer_id", Trim(as_key))
END CHOOSE

uo_search_criteria.dw_search_criteria.AcceptText ()

//Turn redraw back on before actually do search
This.SetRedraw (TRUE)

// Perform the search.  Added call to the Yield function as using the event
//  to open a case from the Reminders tab on the Work Desk appeared to cause
//  this event to be fired twice as a result of other processes not completing.
Yield( )
PARENT.Event Trigger ue_search( )
end event

event dw_folder::po_tabclicked;//************************************************************************************************
//
//  Event:   po_tabclicked
//  Purpose: Change the menus, enable/disable menu items and disable/enable tabs based
//           on what the user is doing.  Call the PowerLock security function after
//           changing any menu to determin if the user can update a closed case.
//
//
//  Date     Person       Description of Change
//  -------- ----------- -------------------------------------------------------------------------
//  
//************************************************************************************************

BOOLEAN	l_bAllowXferCase
LONG 		l_nSearchRow, l_nSelectedRows[], l_nRow, l_nSpecialFlags, l_nXRefCount
STRING   l_cCaseStatus, l_cUserID, l_cCaseRep, l_cGroupID, l_cTakenBy, l_cCaseType, l_cSourceDesc
STRING   l_cSourceID, l_cStatusDesc, l_cCaseMasterNum, l_cConcatSubject
U_DW_STD l_dwSpecialFlags, l_dwDemographics
Integer 	l_iIndex

IF ISVALID(i_uoDemographics) THEN
	l_dwSpecialFlags = PARENT.i_uoDemographics.dw_display_special_flags
	l_dwSpecialFlags.fu_SetOptions( SQLCA, & 
		l_dwSpecialFlags.c_NullDW, &
		l_dwSpecialFlags.c_NoMenuButtonActivation + &
		l_dwSpecialFlags.c_NoEnablePopup )
	
	
	l_dwDemographics = PARENT.i_uoDemographics.dw_demographics
	l_dwDemographics.fu_SetOptions( SQLCA, & 
		l_dwDemographics.c_NullDW, &
		l_dwDemographics.c_NoMenuButtonActivation + &
		l_dwDemographics.c_NoEnablePopup )
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

END CHOOSE



CHOOSE CASE i_SelectedTab
	CASE 1		//	Search Criteria
		//Unlock the current case, if there is a current case
		IF NOT IsNull( PARENT.i_cCurrentCase ) AND Trim( PARENT.i_cCurrentCase ) <> "" AND &
			NOT PARENT.i_bCaseLocked THEN
			IF IsValid( i_uoCaseDetails ) THEN
				i_uoCaseDetails.tab_folder.tabpage_case_details.fu_UnlockCase( )
			END IF
		END IF
		
		// Update available tabs
		IF (uo_search_criteria.uo_matched_records.dw_matched_records.RowCount() > 0) THEN  

			fu_EnableTab(2)
			
		ELSE
			
			fu_DisableTab(2)
			
		END IF
		
		
		uo_search_criteria.uo_matched_records.dw_matched_records.SetFocus()
		CHOOSE CASE i_cSourceType
			CASE 'C', ''
				uo_search_criteria.ddlb_search_type.SelectItem ("Member",0)
				l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Member",0)		
			CASE 'P'
				uo_search_criteria.ddlb_search_type.SelectItem ("Provider",0)
				l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Provider",0)
			CASE 'E'
				uo_search_criteria.ddlb_search_type.SelectItem ("Group",0)
				l_iIndex = uo_search_criteria.ddlb_search_type.FindItem ("Group",0)
		END CHOOSE

		IF uo_search_criteria.uo_matched_records.dw_matched_records.RowCount() = 0 THEN
			uo_search_Criteria.ddlb_search_type.Event Post selectionchanged( l_iIndex )
		END IF
		
		uo_search_criteria.uo_matched_records.dw_matched_records.SetFocus()
		
		// Clear out the special flags from previous search
		IF ISVALID(i_uoDemographics) THEN
			l_dwSpecialFlags = PARENT.i_uoDemographics.dw_display_special_flags
			l_nSpecialFlags = l_dwSpecialFlags.Retrieve('0','0')

		END IF
		
		// Clear out vendor id and provider id
		SETNULL(i_cProviderID)
		SETNULL(i_cVendorID)
		
		//Make visible and enable the select button for the search tab
		IF NOT i_bXrefDetail THEN
			cb_SelectSearch.Visible = TRUE
			cb_SelectResult.Visible = FALSE
		END IF
		
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
		
		i_uoDemographics.dw_display_special_flags.SetRedraw(FALSE)
		i_uoDemographics.dw_display_special_flags.Hide()
		
		l_dwSpecialFlags = PARENT.i_uoDemographics.dw_display_special_flags
		
		IF PARENT.i_cSourceType ='C' THEN
			
			// Get Group ID
			SELECT group_id INTO :l_cGroupID
			  FROM cusfocus.consumer
			 WHERE consumer_id = :PARENT.i_cCurrentCaseSubject
			 USING SQLCA;
						 
			l_dwSpecialFlags.fu_Swap('d_display_consumer_special_flags', l_dwSpecialFlags.c_Ignorechanges, l_dwSpecialFlags.c_NoMenuButtonActivation + &
											l_dwSpecialFlags.c_NoEnablePopup)
			l_dwSpecialFlags.SetTransObject(SQLCA)
			l_nSpecialFlags = l_dwSpecialFlags.Retrieve(PARENT.i_cCurrentCaseSubject, l_cGroupID)
			
		ELSE

				l_dwSpecialFlags.fu_Swap('d_display_special_flags', l_dwSpecialFlags.c_Ignorechanges, l_dwSpecialFlags.c_NoMenuButtonActivation + &
													l_dwSpecialFlags.c_NoEnablePopup)
				l_dwSpecialFlags.SetTransObject(SQLCA)
				
				IF PARENT.i_cCurrentCaseSubject <> '' THEN
					
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
		
		//Make visible and enable the select button for the search tab
		IF NOT i_bXrefDetail THEN
			cb_SelectSearch.Visible = FALSE
			cb_SelectResult.Visible = TRUE
		END IF	
END CHOOSE


end event

type cb_selectsearch from commandbutton within w_cross_ref
boolean visible = false
integer x = 1554
integer y = 16
integer width = 229
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select"
end type

event clicked;/****************************************************************************************
	Event:	Clicked
	Purpose:	Please see PB documentation for this event
	
	Revisions:
	Date     Developer     Description
   ======== ============= ===============================================================
	10/29/2005 K. Claver   Added code to trigger the event to select the record and return
								  the information to the calling object
****************************************************************************************/

PARENT.Event Trigger ue_selectAndReturn( 1 )
end event

type cb_selectresult from commandbutton within w_cross_ref
boolean visible = false
integer x = 3369
integer y = 16
integer width = 229
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select"
end type

event clicked;/****************************************************************************************
	Event:	Clicked
	Purpose:	Please see PB documentation for this event
	
	Revisions:
	Date     Developer     Description
   ======== ============= ===============================================================
	10/29/2005 K. Claver   Added code to trigger the event to select the record and return
								  the information to the calling object
****************************************************************************************/

PARENT.Event Trigger ue_selectAndReturn( 2 )
end event

