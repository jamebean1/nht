$PBExportHeader$w_case_housekeeping.srw
$PBExportComments$Case Housekeeping Window
forward
global type w_case_housekeeping from w_main_std
end type
type st_1 from statictext within w_case_housekeeping
end type
type p_1 from picture within w_case_housekeeping
end type
type st_2 from statictext within w_case_housekeeping
end type
type dw_case_housekeeping from u_dw_std within w_case_housekeeping
end type
type uo_case_housekeeping from u_case_housekeeping within w_case_housekeeping
end type
type gb_1 from groupbox within w_case_housekeeping
end type
type ln_3 from line within w_case_housekeeping
end type
type ln_4 from line within w_case_housekeeping
end type
end forward

global type w_case_housekeeping from w_main_std
integer width = 3653
integer height = 2084
string title = "Case Housekeeping"
string menuname = "m_case_housekeeping"
boolean maxbox = false
boolean resizable = false
long backcolor = 79748288
st_1 st_1
p_1 p_1
st_2 st_2
dw_case_housekeeping dw_case_housekeeping
uo_case_housekeeping uo_case_housekeeping
gb_1 gb_1
ln_3 ln_3
ln_4 ln_4
end type
global w_case_housekeeping w_case_housekeeping

type variables
STRING i_cCategories[]
STRING i_cSearchColumn[]
STRING i_cSearchTable[]
STRING i_cMatchedColumn[]
STRING i_cUserID

DATE i_dCutOffDate

INT i_nMaxLevels

BOOLEAN i_bStopSearch
BOOLEAN i_bOutOfOffice

end variables

forward prototypes
public subroutine fw_sortdata ()
public subroutine fw_checkoutofoffice ()
public subroutine fw_deletecases (boolean b_allcases)
public function boolean fw_checklocked (string a_ccasenumber)
public subroutine fw_clearsearch ()
end prototypes

public subroutine fw_sortdata ();INT				l_nCounter, l_nAnotherCounter, l_nColumnCount
LONG				l_nSortError
S_ColumnSort	l_sSortData
STRING 			l_cTag, l_cSortString



l_nColumnCount = LONG(dw_case_housekeeping.Describe("Datawindow.Column.Count")) 

FOR l_nCounter = 1 to l_nColumnCount

		l_cTag = dw_case_housekeeping.Describe("#" + String(l_nCounter) + ".Tag")

	   IF l_cTag <> '?' THEN
			l_nAnotherCounter ++
			l_sSortData.label_name[l_nAnotherCounter]  = l_cTag
			l_sSortData.column_name[l_nAnotherCounter] = dw_case_housekeeping.Describe(&
				"#" + String(l_nCounter) + ".Name")
			

		END IF

NEXT

//Add the computed columns for correct sorting of the case number and rep
l_nAnotherCounter ++
l_sSortData.label_name[ l_nAnotherCounter ] = " Case Number"
l_sSortData.column_name[ l_nAnotherCounter ] = "case_number_numeric"
l_nAnotherCounter ++
l_sSortData.label_name[ l_nAnotherCounter ] = " Rep"
l_sSortData.column_name[ l_nAnotherCounter ] = "case_rep"

FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)

l_cSortString = Message.StringParm

IF l_cSortString <> '' THEN
	l_nSortError = dw_case_housekeeping.SetSort(l_cSortString)
	l_nSortError = dw_case_housekeeping.Sort()
END IF

	

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
	m_case_housekeeping.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_case_housekeeping.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF







end subroutine

public subroutine fw_deletecases (boolean b_allcases);//***********************************************************************************************
//
//  Function: fw_deletecases
//  Purpose:  To clean up all 'child' tables before deleting Case_Log
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  01/04/01 C. Jackson  Add new tables
//  5/2/2001 K. Claver   Added the carve_out_entries table.
//  11/28/01 M. Caruso   Added the case link reference update code and corrected text of error
//                       messages.  Then Rewrote the function to eliminate chances for orphaned
//                       records.
//	 12/10/2001 K. Claver Added code to delete associated records from the case_attachments table.
//  2/8/2002 K. Claver   Changed deletion from dependent tables to use dynamic sql with the list
//								 of tables contained in an array.  This requires less code and avoids a
//								 possible limitation on nested if-then blocks.
//  3/7/2002 K. Claver   Changed to notify the workdesk that it is ok to refresh rather
//								 than triggering a refresh
//  5/17/2002 K. Claver  Added contact_person as the new contact_person design includes case_number
//								 and a foreign key constraint from case_log to contact_person on
//								 contact_person_id.
//***********************************************************************************************

BOOLEAN		l_bCommitState, l_bDeleteRow = TRUE, l_bAllProcessed, l_bDependError = FALSE
LONG			l_nRowsToDelete[], l_cDeletedRow[], l_nRowCount, l_nReturn, l_nMatchedCases
INT      	l_nResponse, l_nCounter, l_nTableCount
STRING   	l_cCaseNumber, l_cMasterCaseNumber, l_cDsSyntax, l_cErrMsg, l_cPrompt, l_cNull
DATASTORE	l_dsLinkedCases
String 		l_cDependTables[ ], l_cDeleteString, l_cErrorText

IF b_AllCases THEN
	
	// build the array of rows to delete.
	l_nRowCount = dw_case_housekeeping.RowCount ()
	FOR l_nCounter = 1 TO l_nRowCount
		l_nRowsToDelete[l_nCounter] = l_nCounter
	NEXT
	
	l_cPrompt = 'Are you sure you want to delete ALL the matching cases? You cannot undo this operation.'
	
ELSE
	
	// build the array of rows to delete.
	l_nRowCount = dw_case_housekeeping.fu_GetSelectedRows(l_nRowsToDelete[])
	IF l_nRowCount = 0 THEN
		
		MessageBox (gs_AppName, 'There are no cases selected to delete.')
		RETURN
		
	ELSE
		l_cPrompt = 'Are you sure you want to delete the selected cases?  You cannot undo this operation.'
	END IF
	
END IF

l_nResponse = MessageBox(gs_AppName, l_cPrompt, QUESTION!, YESNO!)

// if the user chooses no, then cancel the process.
IF l_nResponse = 2 THEN RETURN

// otherwise...
// turn off autocommit
l_bCommitState = SQLCA.AutoCommit
SQLCA.AutoCommit = FALSE

l_bAllProcessed = TRUE
dw_case_housekeeping.SetRedraw (FALSE)

//Set the list of dependent tables that need to be cleaned up before we can delete the case.
//  If a new dependent table is created, just add it to the array(as long as deleted based on 
//  the case number)!
IF l_nRowCount > 0 THEN
	l_cDependTables[ 1 ] = "carve_out_entries"
	l_cDependTables[ 2 ] = "reopen_log"
	l_cDependTables[ 3 ] = "case_properties"
	l_cDependTables[ 4 ] = "case_notes"
	l_cDependTables[ 5 ] = "survey_results"
	l_cDependTables[ 6 ] = "correspondence"
	l_cDependTables[ 7 ] = "financial_compensation"
	l_cDependTables[ 8 ] = "case_transfer"
	l_cDependTables[ 9 ] = "reminders"
	l_cDependTables[ 10 ] = "case_attachments"
	l_cDependTables[ 11 ] = "case_forms"
	l_cDependTables[ 12 ] = "contact_person"
	l_cDependTables[ 13 ] = "appeal_properties_history"
	l_cDependTables[ 14 ] = "appeal_properties"
	l_cDependTables[ 15 ] = "appealheader"
END IF

FOR l_nCounter = l_nRowCount TO 1 STEP -1  // step in reverse to maintain row references.
	
	l_cCaseNumber = dw_case_housekeeping.GetItemString (l_nRowsToDelete[l_nCounter], 'case_number')
	l_cMasterCaseNumber = dw_case_housekeeping.GetItemString (l_nRowsToDelete[l_nCounter], 'master_case_number')
	
	IF NOT THIS.fw_CheckLocked( l_cCaseNumber ) THEN
		// delete records from the related tables
		FOR l_nTableCount = 1 TO UpperBound( l_cDependTables )
			//contact_person is special as the table contains a case number and a primary contact indicator, 
			//  but case_log also contains the primary contact's id with a foreign key constraint back to
			//  the contact_person table.  So, the contact_person_id needs to be reset in the case_log table
			//  before the row can be removed from the contact_person table.
			IF Upper( l_cDependTables[ l_nTableCount ] ) = "CONTACT_PERSON" THEN
				UPDATE cusfocus.case_log
				SET contact_person_id = null
				WHERE case_number = :l_cCaseNumber
				USING SQLCA;
				
				//SQLCode less than zero = error.  Greater than or equal = success or not found.
				IF SQLCA.SQLCode < 0 THEN
					l_bDeleteRow = FALSE
					l_bDependError = TRUE
					l_cErrorText = SQLCA.SQLErrText
					EXIT
				END IF
			END IF
			
			l_cDeleteString = ( "DELETE FROM cusfocus."+l_cDependTables[ l_nTableCount ]+ &
									  " WHERE case_number = '"+l_cCaseNumber+"'" )
			
			EXECUTE IMMEDIATE :l_cDeleteString USING SQLCA;
			
			//SQLCode less than zero = error.  Greater than or equal = success or not found.
			IF SQLCA.SQLCode < 0 THEN
				l_bDeleteRow = FALSE
				l_bDependError = TRUE
				l_cErrorText = SQLCA.SQLErrText
				EXIT
			END IF
		NEXT
	ELSE
		l_bDeleteRow = FALSE
	END IF
	
	IF l_bDeleteRow THEN
		// correct linked case references
		SELECT count (case_number) INTO :l_nMatchedCases
		  FROM cusfocus.case_log
		 WHERE master_case_number = :l_cMasterCaseNumber
		   AND case_number <> :l_cCaseNumber;
		 
		CHOOSE CASE SQLCA.SQLCode
			CASE -1
				l_bDeleteRow = FALSE
				
			CASE 0
				IF l_nMatchedCases = 1 THEN
					
					// set the master case number to NULL for the other linked case.
					SetNull (l_cNull)
					UPDATE cusfocus.case_log SET master_case_number = :l_cNull
					 WHERE master_case_number = :l_cMasterCaseNumber
					   AND case_number <> :l_cCaseNumber;
					IF SQLCA.SQLCode = -1 THEN l_bDeleteRow = FALSE
					
				END IF
				
			CASE 100
				// no rows to update
				
		END CHOOSE
		
	END IF
	
	IF l_bDeleteRow THEN
		
		// delete the current case record
		l_cDeletedRow[1] = l_nRowsToDelete[l_nCounter]
		dw_case_housekeeping.fu_Delete(1, l_cDeletedRow[], dw_case_housekeeping.c_IgnoreChanges)
		dw_case_housekeeping.fu_Save (dw_case_housekeeping.c_SaveChanges)
		
		COMMIT;
		
		//Set to refresh the workdesk if open.
		IF IsValid( w_reminders ) THEN
			w_reminders.fw_SetOkRefresh( )
		END IF
		
	ELSE
		
		ROLLBACK;
		l_bAllProcessed = FALSE
		
	END IF
	
NEXT

// restore autocommit setting
SQLCA.AutoCommit = l_bCommitState
dw_case_housekeeping.SetRedraw (TRUE)

// prompt the user if any of the selected records failed to be deleted.
IF NOT l_bAllProcessed THEN
	IF l_nRowCount > 0 THEN
		IF l_bDependError THEN
			MessageBox( gs_AppName, "Failed to delete from dependent table "+l_cDependTables[ l_nTableCount ]+&
							".~r~nError Returned:~r~n"+l_cErrorText, StopSign!, OK! )
		ELSE
			MessageBox (gs_appname, "Some of the selected records could not be deleted. An error was encountered~r~n"+ &
							"during the delete, there is an open appeal, or the case is locked.~r~n" +&
							"Please try again later.")
		END IF
	END IF
END IF
end subroutine

public function boolean fw_checklocked (string a_ccasenumber);/*****************************************************************************************
   Function:   fw_CheckLocked
   Purpose:    Check if the passed case is locked BY ANYONE
   Parameters: STRING - a_cCaseNumber - Number of the case to check
   Returns:    BOOLEAN - TRUE - Case locked by anyone
								 FALSE - Case not locked by anyone

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/12/2002 K. Claver   Created.
*****************************************************************************************/
Boolean l_bRV = FALSE
String l_cLockedby, ls_status

IF NOT IsNull( a_cCaseNumber ) AND Trim( a_cCaseNumber ) <> "" THEN	
	SELECT locked_by
	INTO :l_cLockedBy
	FROM cusfocus.case_locks
	WHERE case_number = :a_cCaseNumber
	USING SQLCA;
	
	//Show locked if error or value returned
	IF SQLCA.SQLCode <> 100 THEN
		l_bRV = TRUE
	END IF
END IF

IF NOT l_bRV THEN // If not locked, check for an open appeal
	IF NOT IsNull( a_cCaseNumber ) AND Trim( a_cCaseNumber ) <> "" THEN	

		SELECT IsNull(cusfocus.appealstatus.isclose  , 'N')
		 INTO :ls_status  
		 FROM cusfocus.appealheader,   
				cusfocus.appealstatus  
		WHERE cusfocus.appealheader.case_number = :a_cCaseNumber
		and ( cusfocus.appealheader.appealheaderstatusid = cusfocus.appealstatus.id )   ;


		IF ls_status = 'N' THEN
			l_bRV = TRUE
		END IF
	END IF
END IF

RETURN l_bRV
end function

public subroutine fw_clearsearch ();/**************************************************************************************

			Function:	fw_clearsearch
			Purpose:		To clear the search criteria
			Parameters:	None
			Returns:		None

***************************************************************************************/

dw_case_housekeeping.Reset()

uo_case_housekeeping.dw_outliner.fu_HLClearSelectedRows()
uo_case_housekeeping.em_2.Text = ''
uo_case_housekeeping.em_1.Text = String( THIS.fw_GetTimeStamp( ), "mm/dd/yyyy" )
uo_case_housekeeping.lb_1.SetState(0, FALSE)



end subroutine

event pc_setoptions;call super::pc_setoptions;/****************************************************************************************
	Event:	pc_setoptions
	Purpose:	To initalize the window.
		
	Revisions:
	Developer     Date     Description
   ============= ======== ===============================================================
	M. Caruso     05/21/99 Change toolbar initialization from c_ToolbarLeft to
								  c_ToolbarTop.
	K. Claver     11/13/00 Turned on the sorting service on the case housekeeping
								  datawindow.
	M. Caruso     03/15/02 Added case type as the root level of the tree view and removed
								  the restriction of category case types being only
								  Issue/Concern.  Also removed the ACTIVE restriction from the
								  selects for each level.
****************************************************************************************/

fw_SetOptions(c_default + c_ToolBarTop)       // MPC 5/21/99

uo_case_housekeeping.i_wParentWindow = THIS

//-----------------------------------------------------------------------------------
//		Determine the maximum number of levels.
//-----------------------------------------------------------------------------------

SELECT MAX(category_level) INTO :i_nMaxLevels FROM cusfocus.categories;
i_nMaxLevels ++	// allow for the case type root level

//-----------------------------------------------------------------------------------
//		Set a dummy value for the excluded Issue/Concern categories.
//-----------------------------------------------------------------------------------

i_cCategories[1] = 'X'

//-----------------------------------------------------------------------------------
//		Set the Options for uo_dw_main.
//-----------------------------------------------------------------------------------

dw_case_housekeeping.fu_SetOptions( SQLCA, & 
 		dw_case_housekeeping.c_NullDW, & 
 		dw_case_housekeeping.c_NoRetrieveOnOpen + &
 		dw_case_housekeeping.c_SelectOnRowFocusChange + &
		dw_case_housekeeping.c_DeleteOK + &
 		dw_case_housekeeping.c_MultiSelect + &
 		dw_case_housekeeping.c_NoInactiveRowPointer + &
		dw_case_housekeeping.c_SortClickedOK ) 

//----------------------------------------------------------------------------------
//		Wire the Case Status Listbox to the uo_dw_main.
//-----------------------------------------------------------------------------------


uo_case_housekeeping.lb_1.fu_WireDW(dw_case_housekeeping, 'cusfocus.case_log', &
			'case_status_id', SQLCA)

//--------------------------------------------------------------------------------
//		Determine how many levels we are creating. 6 is MAX.
//--------------------------------------------------------------------------------
IF i_nMaxLevels > 0 THEN
	
	uo_case_housekeeping.dw_outliner.fu_HLRetrieveOptions(1, &
												"open.bmp", &
												"closed.bmp", &
												"cusfocus.case_types.case_type", &
												"", &
												"cusfocus.case_types.case_type_desc", &
												"cusfocus.case_types.case_type_desc", &
												"cusfocus.case_types", &
												"", &
												uo_case_housekeeping.dw_outliner.c_KeyString + &
												uo_case_housekeeping.dw_outliner.c_SortString)
						
END IF
		
IF i_nMaxLevels > 1 THEN

	uo_case_housekeeping.dw_outliner.fu_HLRetrieveOptions(2, &
												"open.bmp", &
												"closed.bmp", &
												"cusfocus.categories.category_id", &
												"cusfocus.categories.case_type", &
												"cusfocus.categories.category_name", &
												"cusfocus.categories.category_name", &
												"cusfocus.categories", &
												"cusfocus.categories.category_level = 1", &
												uo_case_housekeeping.dw_outliner.c_KeyString)
END IF

IF i_nMaxLevels > 2 THEN

	uo_case_housekeeping.dw_outliner.fu_HLRetrieveOptions(3, &
												"open.bmp", &
												"closed.bmp", &
												"cusfocus.category_1_vw.category_id", &			
												"cusfocus.category_1_vw.prnt_category_id", &
												"cusfocus.category_1_vw.category_name", &
												"cusfocus.category_1_vw.category_name", &
												"cusfocus.category_1_vw", &
												"", &
												uo_case_housekeeping.dw_outliner.c_KeyString)

END IF

IF i_nMaxLevels > 3 THEN
	uo_case_housekeeping.dw_outliner.fu_HLRetrieveOptions(4, &
												"open.bmp", &
												"closed.bmp", &
												"cusfocus.category_2_vw.category_id", &			
												"cusfocus.category_2_vw.prnt_category_id", &
												"cusfocus.category_2_vw.category_name", &
												"cusfocus.category_2_vw.category_name", &
												"cusfocus.category_2_vw", &
												"", &
												uo_case_housekeeping.dw_outliner.c_KeyString)
END IF

IF i_nMaxLevels > 4 THEN
	uo_case_housekeeping.dw_outliner.fu_HLRetrieveOptions(5, &
												"open.bmp", &
												"closed.bmp", &
												"cusfocus.category_3_vw.category_id", &			
												"cusfocus.category_3_vw.prnt_category_id", &
												"cusfocus.category_3_vw.category_name", &
												"cusfocus.category_3_vw.category_name", &
												"cusfocus.category_3_vw", &
												"", &
												uo_case_housekeeping.dw_outliner.c_KeyString)
END IF

IF i_nMaxLevels > 5 THEN
	uo_case_housekeeping.dw_outliner.fu_HLRetrieveOptions(6, &
												"open.bmp", &
												"closed.bmp", &
												"cusfocus.category_4_vw.category_id", &			
												"cusfocus.category_4_vw.prnt_category_id", &
												"cusfocus.category_4_vw.category_name", &
												"cusfocus.category_4_vw.category_name", &
												"cusfocus.category_4_vw", &
												"", &
												uo_case_housekeeping.dw_outliner.c_KeyString)
END IF

//--------------------------------------------------------------------------------------
//		If we have Categories, then set the Outliner options and create it.
//--------------------------------------------------------------------------------------

IF i_nMaxLevels > 0 THEN
	uo_case_housekeeping.dw_outliner.fu_HLOptions (&
								uo_case_housekeeping.dw_outliner.c_DrillDownOnLastLevel + &
								uo_case_housekeeping.dw_outliner.c_MultiSelect)
	uo_case_housekeeping.dw_outliner.fu_HLCreate (SQLCA, i_nMaxLevels)
END IF

fw_CheckOutOfOffice()
end event

event pc_setcodetables;call super::pc_setcodetables;/***************************************************************************************

		Event:	pc_setddlb
		Purpose:	Load the case status values into the list box.
		
6/26/2002  K. Claver  Added code to select all options in the Case Status listbox.

***************************************************************************************/
Integer l_nTotalItems, l_nIndex

Error.i_FWError = uo_case_housekeeping.lb_1.fu_LoadCode('cusfocus.case_status', &
												  'case_status_id', &
												  'case_stat_desc', &
													'','')

IF Error.i_FWError <> c_Success THEN 
	RETURN
ELSE
	l_nTotalItems = uo_case_housekeeping.lb_1.TotalItems( )
	IF l_nTotalItems > 0 THEN
		FOR l_nIndex = 1 TO l_nTotalItems
			uo_case_housekeeping.lb_1.SetState( l_nIndex, TRUE )
		NEXT
	END IF
END IF
end event

on w_case_housekeeping.create
int iCurrent
call super::create
if this.MenuName = "m_case_housekeeping" then this.MenuID = create m_case_housekeeping
this.st_1=create st_1
this.p_1=create p_1
this.st_2=create st_2
this.dw_case_housekeeping=create dw_case_housekeeping
this.uo_case_housekeeping=create uo_case_housekeeping
this.gb_1=create gb_1
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_case_housekeeping
this.Control[iCurrent+5]=this.uo_case_housekeeping
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.ln_3
this.Control[iCurrent+8]=this.ln_4
end on

on w_case_housekeeping.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.p_1)
destroy(this.st_2)
destroy(this.dw_case_housekeeping)
destroy(this.uo_case_housekeeping)
destroy(this.gb_1)
destroy(this.ln_3)
destroy(this.ln_4)
end on

type st_1 from statictext within w_case_housekeeping
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
string text = "Case Housekeeping"
boolean focusrectangle = false
end type

type p_1 from picture within w_case_housekeeping
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_2 from statictext within w_case_housekeeping
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

type dw_case_housekeeping from u_dw_std within w_case_housekeeping
integer x = 41
integer y = 1240
integer width = 3561
integer height = 660
integer taborder = 30
string dataobject = "d_case_housekeeping"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;/**************************************************************************************
	Event:	pcd_retrieve
	Purpose:	To retrieve the data.

	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	03/18/02 M. Caruso     Added code to determine the categories to exclude.
	03/21/02 M. Caruso     Add one bogus entry to i_cCategories prior to retrieval if it
								  is empty otherwise.
	03/25/02 M. Caruso     Set l_nLastRow based on the rowcount of the outliner.
**************************************************************************************/
LONG		l_nReturn
LONG		l_nSelectedKey[], l_nLastRow, l_nRow
STRING	l_cBlank[]
DateTime l_dtFromDate, l_dtToDate

l_nLastRow = uo_case_housekeeping.dw_outliner.RowCount()
l_nRow = 1
i_cCategories[] = l_cBlank[]  // clear any existing values in the instance array

// loop through the rows and process those that are selected
DO
   
	// get the next selected row
	l_nRow = uo_case_housekeeping.dw_outliner.fu_HLGetSelectedRow (l_nRow)
	IF l_nRow > 0 THEN
		
		// if a selected row was found, determine which categories to exclude
		uo_case_housekeeping.fu_GetAllChildKeys (l_nRow, i_cCategories[])
   	IF l_nRow = l_nLastRow THEN
			l_nRow = 0
		ELSE
			l_nRow ++
		END IF
	END IF
	
LOOP UNTIL l_nRow = 0

IF UpperBound (i_cCategories[]) = 0 THEN
	i_cCategories[1] = 'X'
END IF

// retrieve the cases that match the specified criteria
l_dtFromDate = DateTime( Date(uo_case_housekeeping.em_2.Text), Time( "00:00:00" ) )
l_dtToDate = DateTime( Date(uo_case_housekeeping.em_1.Text), Time( "23:59:59" ) )

l_nReturn = Retrieve(i_cCategories[], l_dtFromDate, l_dtToDate )

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF
end event

type uo_case_housekeeping from u_case_housekeeping within w_case_housekeeping
integer x = 87
integer y = 252
integer width = 3447
integer height = 908
integer taborder = 20
boolean border = false
end type

on uo_case_housekeeping.destroy
call u_case_housekeeping::destroy
end on

type gb_1 from groupbox within w_case_housekeeping
integer x = 37
integer y = 192
integer width = 3570
integer height = 1004
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Search Criteria"
end type

type ln_3 from line within w_case_housekeeping
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 4000
integer endy = 172
end type

type ln_4 from line within w_case_housekeeping
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 4000
integer endy = 168
end type

