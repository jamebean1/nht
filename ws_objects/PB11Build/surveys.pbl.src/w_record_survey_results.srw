$PBExportHeader$w_record_survey_results.srw
$PBExportComments$Record Survey Results Window
forward
global type w_record_survey_results from w_main_std
end type
type st_4 from statictext within w_record_survey_results
end type
type p_1 from picture within w_record_survey_results
end type
type st_2 from statictext within w_record_survey_results
end type
type uo_survey_results from u_survey_results within w_record_survey_results
end type
type ln_3 from line within w_record_survey_results
end type
type ln_4 from line within w_record_survey_results
end type
type dw_folder from u_folder within w_record_survey_results
end type
type uo_search_survey from u_search_survey within w_record_survey_results
end type
end forward

global type w_record_survey_results from w_main_std
integer width = 3689
integer height = 2100
string title = "Record Survey Results"
string menuname = "m_record_survey_results"
boolean maxbox = false
boolean resizable = false
long backcolor = 79748288
st_4 st_4
p_1 p_1
st_2 st_2
uo_survey_results uo_survey_results
ln_3 ln_3
ln_4 ln_4
dw_folder dw_folder
uo_search_survey uo_search_survey
end type
global w_record_survey_results w_record_survey_results

type variables
STRING i_cSearchColumns[]
STRING i_cSearchTable[]
STRING i_cMatchedColumns[]
STRING i_cSurveyID
STRING i_cSaveMessage = 'Do you want to Save the Survey Result changes?'
STRING i_cUserID

BOOLEAN i_bOutOfOffice
BOOLEAN i_bNewSurvey
end variables

forward prototypes
public subroutine fw_sortdata ()
public subroutine fw_clearsearch ()
public subroutine fw_checkoutofoffice ()
public function integer fw_popcustid ()
end prototypes

public subroutine fw_sortdata ();INT				l_nCounter, l_nAnotherCounter, l_nColumnCount
LONG				l_nSortError
S_ColumnSort	l_sSortData
STRING 			l_cTag, l_cSortString

l_nAnotherCounter = 1
l_sSortData.label_name[l_nAnotherCounter] = uo_search_survey.dw_matched_survey_results.Describe(&
		"sort_case_number.Tag")
l_sSortData.column_name[l_nAnotherCounter] = 'sort_case_number'

l_nColumnCount = LONG(uo_search_survey.dw_matched_survey_results.Describe("Datawindow.Column.Count")) 

FOR l_nCounter = 1 to l_nColumnCount

		l_cTag = uo_search_survey.dw_matched_survey_results.Describe("#" + String(l_nCounter) + ".Tag")

	   IF l_cTag <> '?' THEN
			l_nAnotherCounter ++
			l_sSortData.label_name[l_nAnotherCounter]  = l_cTag
			l_sSortData.column_name[l_nAnotherCounter] = uo_search_survey.dw_matched_survey_results.Describe(&
				"#" + String(l_nCounter) + ".Name")
		END IF
NEXT

FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)

l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = uo_Search_survey.dw_matched_survey_results.SetSort(l_cSortString)
	l_nSortError = uo_Search_survey.dw_matched_survey_results.Sort()
END IF

	

end subroutine

public subroutine fw_clearsearch ();/**************************************************************************************

				Function:		fw_clearsearch
				Purpose:			To clear the search criteria for a new search
				Parameters:		None
				Returns:			None
	
*************************************************************************************/

 i_cSurveyID = ''

//-------------------------------------------------------------------------------------
//		Clear the Search Criteria
//-------------------------------------------------------------------------------------

uo_search_survey.dw_matched_survey_results.Reset()
uo_search_survey.dw_search_criteria.fu_Reset()
uo_survey_results.dw_survey_results.Reset()

IF dw_folder.i_SelectedTab <> 1 THEN
	dw_folder.fu_SelectTab(1)
END IF

uo_search_survey.dw_search_criteria.SetFocus()
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
	m_record_survey_results.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_record_survey_results.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF


end subroutine

public function integer fw_popcustid ();String l_cCaseNumber, l_cSourceID

IF uo_survey_results.dw_survey_results.RowCount( ) > 0 THEN
	uo_survey_results.dw_survey_results.AcceptText( )
	
	IF NOT IsNull( uo_survey_results.dw_survey_results.Object.case_number[ 1 ] ) THEN
		l_cCaseNumber = uo_survey_results.dw_survey_results.Object.case_number[ 1 ]
		
		SELECT cusfocus.case_log.case_subject_id
		INTO :l_cSourceID
		FROM cusfocus.case_log
		WHERE cusfocus.case_log.case_number = :l_cCaseNumber
		USING SQLCA;
		
		IF NOT IsNull( l_cSourceID ) AND Trim( l_cSourceID ) <> "" THEN
			uo_survey_results.dw_survey_results.Object.survey_prtcpnt_id[ 1 ] = l_cSourceID
		ELSE
			MessageBox( gs_AppName, "The case does not exist.  Please enter a valid case number", &
							StopSign!, OK! )
			
			Error.i_FWError = c_Fatal
			RETURN -1
		END IF
	END IF
END IF

RETURN 0
end function

event pc_setoptions;call super::pc_setoptions;/***************************************************************************************

	Event:	pc_setoptions
	Purpose:	To initialize the window.
		
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	05/21/99 M. Caruso     Change toolbar initialization from c_ToolbarLeft to
					           c_ToolbarTop
								  
	08/04/99 M. Caruso     Added c_NoMenuButtonActivation to the fu_setoptions() calls
	                       for both datawindows on this screen.
									
	08/18/99 M. Caruso     Added c_ModifyOnSelect to the fu_setoptions() call for
								  dw_matched_survey_results.

	04/24/00 M. Caruso     Updated display option for tab folder labels
	04/30/01 K. Claver     Added the c_RefreshParent constant back to the options list for
								  dw_survey_results.
	03/25/02 M. Caruso     Removed the c_RefreshParent constant from the options list for
								  dw_survey_results.  It was causing problems.
***************************************************************************************/
WINDOWOBJECT 	 l_woTabObject1[]
WINDOWOBJECT 	 l_woTabObject2[]
DATAWINDOWCHILD l_dwcUserRep

fw_SetOptions(c_default + c_ToolBarTop)		// RAE	4/5/99;  MPC   5/21/99

//---------------------------------------------------------------------------------------
//
//		Set the instance variables for the user objects.
//
//---------------------------------------------------------------------------------------

uo_search_survey.i_wParentWindow = THIS
uo_survey_results.i_wParentWindow = THIS

//---------------------------------------------------------------------------------------
//
//		Initalize the Search arrays.
//
//---------------------------------------------------------------------------------------

i_cSearchColumns[1] = 'letter_id'
i_cSearchColumns[2] = 'case_number'
i_cSearchColumns[3] = 'user_id'
i_cSearchColumns[4] = 'survey_create_date'
i_cSearchColumns[5] = 'survey_rcvd_date'

i_cSearchTable[1] = 'cusfocus.survey_results'
i_cSearchTable[2] = 'cusfocus.survey_results'
i_cSearchTable[3] = 'cusfocus.survey_results'
i_cSearchTable[4] = 'cusfocus.survey_results'
i_cSearchTable[5] = 'cusfocus.survey_results'

i_cMatchedColumns[1] = 'letter_id'
i_cMatchedColumns[2] = 'case_number'
i_cMatchedColumns[3] = 'user_id'
i_cMatchedColumns[4] = 'survey_create_date'
i_cMatchedColumns[5] = 'survey_rcvd_date'

//-------------------------------------------------------------------------------------
//
//		Insert a dummy row into the Rep DropDownDataWindow to perform an ALL search.
//
//-------------------------------------------------------------------------------------

uo_search_survey.dw_search_criteria.GetChild('user_id', l_dwcUserRep)
l_dwcUserRep.SetTransObject(SQLCA)
l_dwcUserRep.Retrieve()
l_dwcUserRep.InsertRow(1)
l_dwcUserRep.SetItem(1, 'user_id', '^')
l_dwcUserRep.SetItem(1, 'user_last_name', '(All)')

//------------------------------------------------------------------------------------
//
//		Set the Key and Options for uo_dw_main.
//
//------------------------------------------------------------------------------------

uo_search_survey.dw_matched_survey_results.fu_SetKey("survey_id")
uo_search_survey.dw_matched_survey_results.fu_SetOptions( SQLCA, & 
 		uo_search_survey.dw_matched_survey_results.c_NullDW, & 
 		uo_search_survey.dw_matched_survey_results.c_NoRetrieveOnOpen + &
		uo_search_survey.dw_matched_survey_results.c_ModifyOnSelect + &
 		uo_search_survey.dw_matched_survey_results.c_SelectOnRowFocusChange + &
 		uo_search_survey.dw_matched_survey_results.c_NoInactiveRowPointer + &
 		uo_search_survey.dw_matched_survey_results.c_TabularFormStyle + &
		uo_search_survey.dw_matched_survey_results.c_NoMenuButtonActivation + &
		uo_search_survey.dw_matched_survey_results.c_SortClickedOK ) 

uo_survey_results.dw_survey_results.fu_SetOptions( SQLCA, & 
 		uo_search_survey.dw_matched_survey_results, & 
 		uo_survey_results.dw_survey_results.c_ModifyOK + &
 		uo_survey_results.dw_survey_results.c_ModifyOnOpen + &
		uo_survey_results.dw_survey_results.c_NoRetrieveOnOpen + &
 		uo_survey_results.dw_survey_results.c_NewOK + &
 		uo_survey_results.dw_survey_results.c_FreeFormStyle + &
		uo_survey_results.dw_survey_results.c_NoMenuButtonActivation) 
			

//--------------------------------------------------------------------------------------
//
//		Wire the Search object to uo_dw_main.
//
//--------------------------------------------------------------------------------------

uo_search_survey.dw_search_criteria.fu_WireDW(i_cSearchColumns[], &
	uo_search_survey.dw_matched_survey_results, i_cSearchTable[], i_cMatchedColumns[], SQLCA)

//------------------------------------------------------------------------------------
//
//		Assign the two user objects to the WindowObject arrays.
//
//-------------------------------------------------------------------------------------
l_woTabObject1[1] = uo_search_survey
l_woTabObject2[1] = uo_survey_results

//-------------------------------------------------------------------------------------
//
//		Set all the Tab Options, assign the WindowObject arrays to the tab objects and 
//		create the Folder object.  Select the first tab.
//
//--------------------------------------------------------------------------------------

dw_folder.fu_TabOptions('Arial', 9, dw_folder.c_DefaultVisual)
dw_folder.fu_TabDisableOptions('Arial', 9, dw_folder.c_TextDisableRegular)
dw_folder.fu_TabCurrentOptions('Arial', 9, dw_folder.c_DefaultVisual)

dw_folder.fu_AssignTab(1, 'Search for Survey Results', l_woTabObject1[])
dw_folder.fu_AssignTab(2, 'Record Survey Results', l_woTabObject2[])

dw_folder.fu_FolderCreate(2, 2)

dw_folder.fu_SelectTab(1)

// Disable Survey Results until as case is selected
dw_folder.fu_DisableTab(2)

//------------------------------------------------------------------------------------
//
//		Save the PC Message object Text for later.
//
//------------------------------------------------------------------------------------

FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)

fw_CheckOutOfOffice()
end event

event pc_print;//*********************************************************************************************
//
//  Event:   pc_print
//  Purpose:To determine if there is a selected survey to print.  If so, print it.
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  04/27/01 C. Jackson  Check to see which tab we're on to get the correct survey id
//  
//*********************************************************************************************

STRING l_cSurveyID
BOOLEAN l_bPrintFailed = FALSE


IF dw_folder.i_SelectedTab = 1 THEN
	
	l_cSurveyId = i_cSurveyID
	IF l_cSurveyID = '' THEN
		messagebox(gs_AppName, "There is no survey selected to print.")
		l_bPrintFailed = TRUE
	END IF

	
ELSE
	
	uo_survey_results.dw_survey_results.fu_Save( uo_survey_results.dw_survey_results.c_SaveChanges )
	l_cSurveyID = i_cSurveyID
	
//	l_cSurveyID = uo_survey_results.dw_survey_results.GetItemString(1,'survey_id')
//	IF ISNULL(l_cSurveyID) THEN
//		messagebox(gs_AppName,'The survey must be saved before it can be printed.')
//		l_bPrintFailed = TRUE
//	END IF
	
END IF

IF NOT l_bPrintFailed THEN
		SetPointer(HOURGLASS!)
		uo_survey_results.dw_survey_report.SetTransObject(SQLCA)
		uo_survey_results.dw_survey_report.Retrieve(l_cSurveyId)
		uo_survey_results.dw_survey_report.Print()
		
END IF
end event

event pc_setcodetables;call super::pc_setcodetables;/***********************************************************************************
	Event:	pc_setcodetables
	Purpose:	Populate the Survey Type DropDown List Box
	
	Revisions:
	Date     Developer     Description
	======== ============= ==========================================================
	8/16/99  M. Caruso     Removed "(All)" entry from code list.

***********************************************************************************/

Error.i_FWError = uo_search_survey.dw_search_criteria.fu_LoadCode("letter_id", &
														"cusfocus.letter_types", &
														"letter_id", &
														"letter_name", &
														"letter_survey = 'Y'", "")



end event

on w_record_survey_results.create
int iCurrent
call super::create
if this.MenuName = "m_record_survey_results" then this.MenuID = create m_record_survey_results
this.st_4=create st_4
this.p_1=create p_1
this.st_2=create st_2
this.uo_survey_results=create uo_survey_results
this.ln_3=create ln_3
this.ln_4=create ln_4
this.dw_folder=create dw_folder
this.uo_search_survey=create uo_search_survey
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.uo_survey_results
this.Control[iCurrent+5]=this.ln_3
this.Control[iCurrent+6]=this.ln_4
this.Control[iCurrent+7]=this.dw_folder
this.Control[iCurrent+8]=this.uo_search_survey
end on

on w_record_survey_results.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.uo_survey_results)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.dw_folder)
destroy(this.uo_search_survey)
end on

event activate;call super::activate;FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cSaveMessage)
end event

type st_4 from statictext within w_record_survey_results
integer x = 201
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Record Survey Results"
boolean focusrectangle = false
end type

type p_1 from picture within w_record_survey_results
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_2 from statictext within w_record_survey_results
integer width = 3863
integer height = 168
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type uo_survey_results from u_survey_results within w_record_survey_results
integer x = 23
integer y = 292
integer taborder = 30
boolean border = false
end type

on uo_survey_results.destroy
call u_survey_results::destroy
end on

type ln_3 from line within w_record_survey_results
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type ln_4 from line within w_record_survey_results
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 4000
integer endy = 168
end type

type dw_folder from u_folder within w_record_survey_results
integer y = 192
integer width = 3634
integer height = 1720
integer taborder = 10
end type

event po_tabvalidate;//*********************************************************************************************
//  Event:   po_tabvalidate
//  Purpose: To check for changes on the record survey datawindow before we leave.
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  04/26/01 C. Jackson  Add confirmation message before trying to save
//  04/30/01 K. Claver   Added code to populate the participant id from the case prior to saving.
//  02/27/02 M. Caruso   Use system prompt if unsaved data exists.
//  03/25/02 M. Caruso   Refresh the search list datawindow if the current survey is in the list.
//  05/24/02 M. Caruso   RETURN after setting i_TabError to prevent tab from switching if an
//								 error occurs during the save process.
//*********************************************************************************************

LONG				l_nReturn, l_nRowCount, l_nRow
DWItemStatus	l_Status
STRING			l_cSourceID, l_cCaseNumber, l_cSurveyID
U_DW_STD			l_dwResults, l_dwSearch

CHOOSE CASE i_SelectedTab
	CASE 1	// survey results search tab

	CASE 2	// survey results entry tab
		l_dwSearch = uo_search_survey.dw_matched_survey_results
		l_dwResults = uo_survey_results.dw_survey_results
		l_dwResults.AcceptText( )
		
		l_status = l_dwResults.GetItemStatus(1,0,Primary!)
		
		CHOOSE CASE l_status
			CASE DataModified!, NewModified!
				l_nReturn = l_dwResults.fu_Save (l_dwResults.c_PromptChanges)
			
				IF l_nReturn = -1 THEN
					
					// a problem occured, so prevent the tab from switching
					i_TabError = -1
					RETURN
					
				END IF
	
		END CHOOSE
		
		// refresh the search results datawindow if the current survey is in the list.
		l_nRowCount = l_dwSearch.RowCount ()
		IF l_nRowCount > 0 THEN
			
			l_dwSearch.SetRedraw (FALSE)
			l_cSurveyID = l_dwResults.GetItemString (1, 'survey_id')
			l_nRow = l_dwSearch.Find ('survey_id = ~'' + l_cSurveyID + '~'', 1, l_nRowCount)
			IF l_nRow > 0 THEN
				
				// refresh the search results list.
				l_dwSearch.fu_Retrieve (l_dwSearch.c_PromptChanges, l_dwSearch.c_ReselectRows)
				
			END IF
			l_dwSearch.SetRedraw (TRUE)
			
		END IF

END CHOOSE




end event

event po_tabclicked;call super::po_tabclicked;//**********************************************************************************************
//
//  Event:   po_tabclicked
//  Purpose: Enable/disable menu items based on what the user is doing.
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  08/4/99  M. Caruso   Created.
//  04/26/01 C. Jackson  remove disabling of m_addsurvey_results when on tab it.  Should always
//                       be enabled. (SCR 2044)
//  4/30/2001 K. Claver  Moved population of the participant id to the po_tabvalidate event as
//								 the code being in here changed the id every time switched to tab 2.
//
//**********************************************************************************************

STRING l_cNull
DWItemStatus l_Status

SETNULL(l_cNull)

// set the menu items according to the Tab that was selected.
CHOOSE CASE selectedtab
	CASE 1		
		m_record_survey_results.m_file.m_savesurveyresults.Enabled 	= FALSE
		m_record_survey_results.m_file.m_clearsearch.Enabled 			= TRUE
		m_record_survey_results.m_file.m_search.Enabled 				= TRUE
		m_record_survey_results.m_file.m_printsurvey.Enabled 			= TRUE
		m_record_survey_results.m_edit.m_sort1.Enabled 					= TRUE
		
		
	CASE 2
		m_record_survey_results.m_file.m_savesurveyresults.Enabled 	= TRUE
		m_record_survey_results.m_file.m_clearsearch.Enabled 			= FALSE
		m_record_survey_results.m_file.m_search.Enabled 				= FALSE
		m_record_survey_results.m_file.m_printsurvey.Enabled 			= TRUE
		m_record_survey_results.m_edit.m_sort1.Enabled 					= FALSE
//		uo_survey_results.dw_survey_results.SetItem(1,'survey_prtcpnt_id',uo_search_survey.i_cSubjectID)
//		uo_survey_results.dw_survey_results.SetItemStatus(1,0,Primary!,NotModified!)
//		uo_survey_results.dw_survey_results.fu_ResetUpdate()

END CHOOSE
end event

type uo_search_survey from u_search_survey within w_record_survey_results
integer x = 23
integer y = 292
integer taborder = 20
boolean border = false
end type

on uo_search_survey.destroy
call u_search_survey::destroy
end on

