$PBExportHeader$u_reassign_cases.sru
$PBExportComments$Re-Assign Cases User Object
forward
global type u_reassign_cases from u_container_std
end type
type uo_search_reassigncases from u_search_reassigncases within u_reassign_cases
end type
type cb_selectall from commandbutton within u_reassign_cases
end type
type cb_transfer from commandbutton within u_reassign_cases
end type
type dw_csrlist_to from u_outliner_std within u_reassign_cases
end type
type st_2 from statictext within u_reassign_cases
end type
type st_1 from statictext within u_reassign_cases
end type
type dw_csrlist_from from u_outliner_std within u_reassign_cases
end type
type dw_case_detail_report from datawindow within u_reassign_cases
end type
end forward

global type u_reassign_cases from u_container_std
integer width = 3150
integer height = 2184
uo_search_reassigncases uo_search_reassigncases
cb_selectall cb_selectall
cb_transfer cb_transfer
dw_csrlist_to dw_csrlist_to
st_2 st_2
st_1 st_1
dw_csrlist_from dw_csrlist_from
dw_case_detail_report dw_case_detail_report
end type
global u_reassign_cases u_reassign_cases

type variables
STRING		i_cToUserID = ''
STRING		i_cFromUserID = ''
STRING      i_cLoginID

STRING      i_cToLastName = ''
STRING      i_cToFirstName = ''

STRING		i_cFromLastName = ''
STRING      i_cFromFirstName = ''

STRING		i_cToFullName = ''
STRING		i_cFromFullName = ''

LONG        i_nNumCases = 0

W_SUPERVISOR_PORTAL i_wParentWindow
end variables

forward prototypes
public subroutine fu_refresh ()
public subroutine fu_clearoutliner ()
public function boolean fu_checklocked (string a_ccasenumber)
end prototypes

public subroutine fu_refresh ();//**********************************************************************************************
//
//  Function: fu_refresh
//  Purpose:  To refresh the outliners
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  10/24/00 C. Jackson  Original Version
//
//**********************************************************************************************

LONG l_nSelectedRow[], l_nLastRow, l_nIndex, l_nNumSelected, l_nLevel

dw_csrlist_from.Hide()
dw_csrlist_from.SetRedraw(FALSE)
	
l_nLastRow = dw_csrlist_from.RowCount()
l_nIndex = 1
DO
  l_nIndex = dw_csrlist_from.fu_HLGetSelectedRow(l_nIndex)
  IF l_nIndex > 0 THEN
    l_nNumSelected = l_nNumSelected + 1
    l_nSelectedRow[l_nNumSelected] = l_nIndex
    l_nIndex = l_nIndex + 1
    IF l_nIndex > l_nLastRow THEN
      l_nIndex = 0
    END IF
  END IF
LOOP UNTIL l_nIndex = 0

IF l_nNumSelected <> 0 THEN

	l_nLevel = dw_csrlist_from.fu_HLGetRowLevel(l_nSelectedRow[1])
	
	IF l_nLevel = 1 THEN
		// Refresh and expand
		dw_csrlist_from.fu_HLRefresh(2, dw_csrlist_from.c_ReselectRows)
		dw_csrlist_from.fu_HLExpandBranch()
	ELSE
		// Just refresh
		dw_csrlist_from.fu_HLRefresh(2, dw_csrlist_from.c_ReselectRows)
	END IF
	
END IF

dw_csrlist_from.SetRedraw(TRUE)
dw_csrlist_from.Show()


dw_csrlist_to.Hide()
dw_csrlist_to.SetRedraw(FALSE)
	
l_nLastRow = dw_csrlist_to.RowCount()
l_nIndex = 1
DO
  l_nIndex = dw_csrlist_to.fu_HLGetSelectedRow(l_nIndex)
  IF l_nIndex > 0 THEN
    l_nNumSelected = l_nNumSelected + 1
    l_nSelectedRow[l_nNumSelected] = l_nIndex
    l_nIndex = l_nIndex + 1
    IF l_nIndex > l_nLastRow THEN
      l_nIndex = 0
    END IF
  END IF
LOOP UNTIL l_nIndex = 0

IF l_nNumSelected <> 0 THEN

	l_nLevel = dw_csrlist_to.fu_HLGetRowLevel(l_nSelectedRow[1])
	
	IF l_nLevel = 1 THEN
		// Refresh and expand
		dw_csrlist_to.fu_HLRefresh(2, dw_csrlist_to.c_ReselectRows)
		dw_csrlist_to.fu_HLExpandBranch()
	ELSE
		// Just refresh
		dw_csrlist_to.fu_HLRefresh(2, dw_csrlist_to.c_ReselectRows)
	END IF
	
END IF

dw_csrlist_to.SetRedraw(TRUE)
dw_csrlist_to.Show()


end subroutine

public subroutine fu_clearoutliner ();//******************************************************************************************
//
//  Function: fu_clearoutliner
//  Purpose:  to clear out previously retrieved rows
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------
//  12/19/00 cjackson    Original Version
//
//******************************************************************************************

//tab_details.tabpage_preview.Enabled = FALSE
//tab_details.SelectTab(1)


end subroutine

public function boolean fu_checklocked (string a_ccasenumber);/*****************************************************************************************
   Function:   fu_CheckLocked
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
String l_cLockedby

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

RETURN l_bRV
end function

on u_reassign_cases.create
int iCurrent
call super::create
this.uo_search_reassigncases=create uo_search_reassigncases
this.cb_selectall=create cb_selectall
this.cb_transfer=create cb_transfer
this.dw_csrlist_to=create dw_csrlist_to
this.st_2=create st_2
this.st_1=create st_1
this.dw_csrlist_from=create dw_csrlist_from
this.dw_case_detail_report=create dw_case_detail_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search_reassigncases
this.Control[iCurrent+2]=this.cb_selectall
this.Control[iCurrent+3]=this.cb_transfer
this.Control[iCurrent+4]=this.dw_csrlist_to
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_csrlist_from
this.Control[iCurrent+8]=this.dw_case_detail_report
end on

on u_reassign_cases.destroy
call super::destroy
destroy(this.uo_search_reassigncases)
destroy(this.cb_selectall)
destroy(this.cb_transfer)
destroy(this.dw_csrlist_to)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_csrlist_from)
destroy(this.dw_case_detail_report)
end on

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To initialize the outliner datawindows
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/14/00 C. Jackson  Original Version
//
//**********************************************************************************************

STRING l_cDeptID
LONG l_nDeptRow

// get the supervisor dept
i_cLoginID = OBJCA.WIN.fu_GetLogin(SQLCA)
SELECT user_dept_id INTO :l_cDeptID
  FROM cusfocus.cusfocus_user
 WHERE user_id = :i_cLoginID
 USING SQLCA;
 
// Initialize reassign From Outliner Datawindow
dw_csrlist_from.fu_HLOptions (dw_csrlist_from.c_DrillDownOnClick)

// Set the options for dw_csrlist_from level 1
dw_csrlist_from.fu_HLRetrieveOptions(1, &
		"smallminus.bmp", &
		"smallplus.bmp", &
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		" ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept", & 
		"cusfocus.cusfocus_user_dept.active <> 'N'", & 
		dw_csrlist_from.c_KeyString)

// Set the options for dw_csrlist_from level 2
dw_csrlist_from.fu_HLRetrieveOptions(2, &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.user_id", & 
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user", & 
		"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
		"cusfocus.cusfocus_user.active <> 'N'", & 
		dw_csrlist_from.c_KeyString + dw_csrlist_from.c_BMPFromColumn)
		
dw_csrlist_from.fu_HLCreate(SQLCA,2)							

// Initialize reassign To Outliner Datawindow
dw_csrlist_to.fu_HLOptions (dw_csrlist_to.c_DrillDownOnClick)

// Set the options for dw_csrlist_to level 1
dw_csrlist_to.fu_HLRetrieveOptions(1, &
		"smallminus.bmp", &
		"smallplus.bmp", &
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		" ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept", & 
		"cusfocus.cusfocus_user_dept.active <> 'N'", & 
		dw_csrlist_to.c_KeyString)

// Set the options for dw_csrlist_to level 2
dw_csrlist_to.fu_HLRetrieveOptions(2, &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.user_id", & 
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user", & 
		"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
		"cusfocus.cusfocus_user.active <> 'N'", & 
		dw_csrlist_to.c_KeyString + dw_csrlist_to.c_BMPFromColumn)
		
dw_csrlist_to.fu_HLCreate(SQLCA,2)		

// Scroll each outliner to supervisor department as default
l_nDeptRow = dw_csrlist_from.fu_HLFindRow(l_cDeptID, 1)

dw_csrlist_from.fu_HLSetSelectedRow(l_nDeptRow)

IF NOT ISNULL(l_cDeptID) OR l_cDeptID <> '' THEN
	dw_csrlist_from.fu_HLExpandBranch()
END IF

l_nDeptRow = dw_csrlist_to.fu_HLFindRow(l_cDeptID, 1)

dw_csrlist_to.fu_HLSetSelectedRow(l_nDeptRow)

IF NOT ISNULL(l_cDeptID) OR l_cDeptID <> '' THEN
	dw_csrlist_to.fu_HLExpandBranch()
END IF


//Initialize the resize service
THIS.of_SetResize( TRUE )

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
//	THIS.inv_resize.of_Register( cb_selectall, THIS.inv_resize. .FIXEDRIGHTBOTTOM )
//	THIS.inv_resize.of_Register( cb_transfer, THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_search_reassigncases, THIS.inv_resize.SCALERIGHTBOTTOM )

END IF

end event

type uo_search_reassigncases from u_search_reassigncases within u_reassign_cases
integer x = 18
integer y = 740
integer width = 2981
integer taborder = 60
end type

on uo_search_reassigncases.destroy
call u_search_reassigncases::destroy
end on

type cb_selectall from commandbutton within u_reassign_cases
integer x = 1307
integer y = 544
integer width = 402
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select &All"
end type

event clicked;//**********************************************************************************************
//
//  Event: clicked
//  Purpose: Select all rows in the list datawindow
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/15/00 C. Jackson  Original Version
//  04/11/01 C. Jackson  Disable preview tab if all are selected. (SCR 2004)
//
//**********************************************************************************************

LONG l_nIndex, i_nRowNums[]

IF i_nNumCases = 0 THEN
	messagebox(gs_AppName,'There are no Cases to select')
ELSE
	FOR l_nIndex = 1 TO i_nNumCases
		uo_search_reassigncases.dw_report.object.selected[l_nIndex] = 'y'
	NEXT
END IF

end event

type cb_transfer from commandbutton within u_reassign_cases
integer x = 1307
integer y = 640
integer width = 402
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transfer"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To write records to the Case_Transfer table
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/15/00 C. Jackson  Original Version
//  09/19/00 C. Jackson  Add Security
//  10/06/00 C. Jackson  Add table name to call to fw_getkeyvalue
//  11/20/00 C. Jackson  Add insert into reminders table for CSR whose cases were just 
//                       reassigned
//  11/29/00 C. Jackson  Change reminder type from 1 (case) to 3 (system)
//  01/04/01 C. Jackson  Correct security (SCR 1196)
//  3/6/2001 K. Claver   Added code to check demographic level security.
//  04/11/01 C. Jackson  Disable preview tab if all rows have been transferred (SCR 2004)
//  3/14/2002 K. Claver  Added code to check if the cases are locked before allowing to transfer.
//
//**********************************************************************************************

LONG l_nNumSelected, l_nSelectedRows[], l_nRowCount, l_nIndex, l_nFindRow, l_nRow, l_nConfirm
LONG l_nSuperConfid, l_nCaseConfid[], l_nAnotherIndex, l_nCSRConfidLevel, l_nOkToProceed, l_nBadCount
LONG l_nGoodRowArray[], l_nGoodRowCntr, l_nOutCount, l_nRtn, l_nRowArray[]
INTEGER l_nRecConfid, l_nSuperRecConfid, l_nCSRRecConfidLevel
STRING l_cCaseNumber[], l_cNewKey, l_cXFerNotes, l_cInvalidCases[], l_cBadCaseList
STRING l_cAssignFirst, l_cAssignLast, l_cAssignID, l_cCaseTransferID, l_cGoodcaseList, l_cComments
STRING l_cSubjectID, l_cSourceType
BOOLEAN l_bSuperFailed, l_bCSRFailed, l_bCaseLockFailed
DATETIME l_dtTransferDate
U_DW_STD l_dwResults
POINTER OldPointer 
string	ls_fromdeptID, ls_todeptID, ls_case_number_arg
long ll_rowcount, ll_row, ll_selected_index
long ll_selected_row[]

SETNULL(l_cAssignID)

// Make sure reassign From and reassign To have been selected

IF i_cFromUserID <> '' THEN
	IF i_cToUserID <> '' THEN
		IF i_cFromUserID <> i_cToUserID THEN
			IF i_nNumCases > 0 THEN
				// OK to Transfer
				ll_rowcount = uo_search_reassigncases.dw_report.Rowcount()
				FOR ll_row = 1 to ll_rowcount
					IF uo_search_reassigncases.dw_report.object.selected[ll_row] = 'y' THEN
						ll_selected_index++
						ll_selected_row[ll_selected_index] = ll_row
					END IF
				NEXT
				l_nNumSelected = Upperbound(ll_selected_row)
						
				
				IF l_nNumSelected > 0 THEN
					
					// Get the Super confid levels
					SELECT confidentiality_level,
							 rec_confidentiality_level
					  INTO :l_nSuperConfid,
							 :l_nSuperRecConfid
					  FROM cusfocus.cusfocus_user
					 WHERE user_id = :i_cLoginID
					 USING SQLCA;
							
					// Get the reassign To Security
					SELECT confidentiality_level, 
							 rec_confidentiality_level
					  INTO :l_nCSRConfidLevel,
					  	    :l_nCSRRecConfidLevel
					  FROM cusfocus.cusfocus_user
					 WHERE user_id = :i_cToUserID
					 USING SQLCA;
					
					// Make sure the Supervisor has the authority to reassign all selected cases
					l_nGoodRowCntr = 0
					l_nOkToProceed = 1

					FOR l_nIndex = 1 TO l_nNumSelected
						 
						//Get the demographic record confidentiality level 
						l_cSubjectID = uo_search_reassigncases.dw_report.object.case_subject_id[ll_selected_row[l_nIndex]]
						l_cSourceType = uo_search_reassigncases.dw_report.object.source_type[ll_selected_row[l_nIndex]] 
						l_nRecConfid = w_supervisor_portal.fw_GetRecConfidLevel( l_cSubjectID, l_cSourceType )
						 
					
						IF l_nSuperConfid <  uo_search_reassigncases.dw_report.object.case_log_confidentiality_level[ll_selected_row[l_nIndex]] OR &
						   ( l_nSuperRecConfid < l_nRecConfid AND NOT IsNull( l_nRecConfid ) ) THEN
							l_bSuperFailed = TRUE
							
							// Add Case number to list of bad
							IF ISNULL(l_cBadCaseList) OR (l_cBadCaseList = '') THEN
								l_cBadCaseList =  uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							ELSE
								l_cBadCaseList = l_cBadCaseList + ', ' + uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							END IF
							// Unselect this row and remove it from the selected array
							uo_search_reassigncases.dw_report.object.selected[ll_selected_row[l_nIndex]] = 'n'
							ll_selected_row[l_nIndex] = 0
							
						ELSE 
							// Add row to list of good
							l_nGoodRowCntr++
							l_nGoodRowArray[l_nGoodRowCntr] = ll_Selected_Row[l_nIndex]

							// Add to list of good
							IF ISNULL(l_cGoodCaseList) OR (l_cGoodCaseList = '') THEN
								l_cGoodCaseList = uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							ELSE
								l_cGoodCaseList = l_cGoodCaseList + ', ' + uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							END IF
							
						END IF
						 
					NEXT
					
					IF l_bSuperFailed THEN
						IF l_nGoodRowCntr > 0 THEN
							// Supervisor does not have authority to transfer *some* of the selected cases.
							// Specify those cases in the error message.
							l_nOkToProceed = messagebox(gs_AppName,'You do not have the authority to reassign '+ &
										'the following case(s):  '+string(l_cBadCaseList)+'.~r~nWould you like to ' + &
										'reassign the remaining selected cases from '+i_cFromFullName+' to '+ & 
										i_cToFullName+'?',Question!,YesNo!,2)
							IF l_nOKToProceed = 2 THEN RETURN
						ELSE
							// Supervisor does not have authority to transfer *all* of the selected cases.
							messagebox(gs_AppName,'You do not have the authority to reassign the selected ' + &
										'cases.')
							RETURN
						END IF
						
					END IF
					
					// The good row array has all of the still selected rows
					ll_selected_row = l_nGoodRowArray
					l_nNumSelected = l_nGoodRowCntr

					// Make sure the selected CSR has the authority to receive all selected cases
					l_nGoodRowCntr = 0
					l_cBadCaseList = ''
					
					FOR l_nIndex = 1 TO l_nNumSelected
						 
						//Get the demographic record confidentiality level 
						l_cSubjectID = uo_search_reassigncases.dw_report.object.case_subject_id[ll_selected_row[l_nIndex]]
						l_cSourceType = uo_search_reassigncases.dw_report.object.source_type[ll_selected_row[l_nIndex]] 
						l_nRecConfid = w_supervisor_portal.fw_GetRecConfidLevel( l_cSubjectID, l_cSourceType ) 
						 
						// Does the CSR have access to this case?
						IF l_nCSRConfidLevel < uo_search_reassigncases.dw_report.object.case_log_confidentiality_level[ll_selected_row[l_nIndex]] OR &
						( l_nCSRRecConfidLevel < l_nRecConfid AND NOT IsNull( l_nRecConfid ) ) THEN
							l_bCSRFailed = TRUE
							
							// Add Case number to list of bad
							IF ISNULL(l_cBadCaseList) OR (l_cBadCaseList = '') THEN
								l_cBadCaseList =  uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							ELSE
								l_cBadCaseList = l_cBadCaseList + ', ' + uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							END IF
							// Unselect this row and remove it from the selected array
							uo_search_reassigncases.dw_report.object.selected[ll_selected_row[l_nIndex]] = 'n'
							ll_selected_row[l_nIndex] = 0
							
						ELSE 
							// Add row to list of good
							l_nGoodRowCntr++
							l_nGoodRowArray[l_nGoodRowCntr] = ll_selected_row[l_nIndex]
							
						END IF
						 
					NEXT

					IF l_bCSRFailed THEN
						IF l_nGoodRowCntr > 0 THEN
							l_nOkToProceed = messagebox(gs_AppName,i_cToFullName+' does not have the authority to ' + &
										'receive the following case(s):  '+string(l_cBadCaseList)+'.  Would you like to ' + &
										'reassign the remaining selected cases from '+i_cFromFullName+' to '+i_cToFullName &
										+'?', Question!,YesNo!,2)
							IF l_nOKToProceed = 2 THEN RETURN
						ELSE
							messagebox(gs_AppName,i_cToFullName+' does not have the authority to receive the selected ' + &
										'cases.')
							RETURN
						END IF
						
					END IF
					
					// The good row array has all of the still selected rows
					ll_selected_row = l_nGoodRowArray
					l_nNumSelected = l_nGoodRowCntr

					//Make sure that all the cases are unlocked
					l_nGoodRowCntr = 0
					l_cBadCaseList = ''
					
					FOR l_nIndex = 1 TO l_nNumSelected

						// Is the case unlocked
						IF PARENT.fu_CheckLocked(uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]] ) THEN
							l_bCaseLockFailed = TRUE
							
							// Add Case number to list of bad
							IF ISNULL(l_cBadCaseList) OR (l_cBadCaseList = '') THEN
								l_cBadCaseList = uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							ELSE
								l_cBadCaseList = l_cBadCaseList + ', ' + uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							END IF
							// Unselect this row and remove it from the selected array
							uo_search_reassigncases.dw_report.object.selected[ll_selected_row[l_nIndex]] = 'n'
							ll_selected_row[l_nIndex] = 0
							
						ELSE 
							// Add row to list of good
							l_nGoodRowCntr++
							l_nGoodRowArray[l_nGoodRowCntr] = ll_selected_row[l_nIndex]
							
						END IF						 
					NEXT
					
					IF l_bCaseLockFailed THEN
						IF l_nGoodRowCntr > 0 THEN
							l_nOkToProceed = messagebox(gs_AppName,'The following cases are currently in use and ' + &
										'cannot be transferred:  '+string(l_cBadCaseList)+'.  Would you like to ' + &
										'reassign the remaining selected cases from '+i_cFromFullName+' to '+i_cToFullName &
										+'?', Question!, YesNo!,2)
						ELSE
							messagebox(gs_AppName,'The selected cases are currently in use and cannot be transferred')
							RETURN
						END IF						
					END IF
					
					IF l_nOkToProceed = 1 THEN
						
						// Check to see if Reassign User is Out of Office...
						SELECT count(*) INTO :l_nOutCount
						  FROM cusfocus.out_of_office
						 WHERE out_user_id = :i_cToUserID
						 USING SQLCA;
						 
						IF l_nOutCount > 0 THEN 
							// Check to see if this CSR's calls are being route elsewhere
							SELECT assigned_to_user_id INTO :l_cAssignID
							  FROM cusfocus.out_of_office
							 WHERE out_user_id = :i_cToUserID
							 USING SQLCA;
							 
							IF NOT ISNULL(l_cAssignID) THEN
								// Get Full Name
								SELECT user_first_name, user_last_name INTO :l_cAssignFirst, :l_cAssignLast
								  FROM cusfocus.cusfocus_user
								 WHERE user_id = :l_cAssignID
								 USING SQLCA;
								 
								// Prompt the user to reassign to 'backup'
								l_nRtn = messagebox(gs_AppName,i_cToFullName+' is marked out of office.  ' + &
								                'Cases are being routed to '+l_cAssignFirst+' '+ &
													  l_cAssignLast+'.  Transfer selected case(s) to '+&
													  l_cAssignFirst+' '+l_cAssignLast+'?',Question!,YesNoCancel!)
								CHOOSE CASE l_nRtn
									CASE 3
										RETURN
									CASE 2
										messagebox(gs_AppName,'Transfer cases to '+i_cToFullName+'?')
									CASE ELSE
										i_cToFullName = l_cAssignFirst+' '+l_cAssignLast
										i_cToUserID = l_cAssignID
								END CHOOSE
								
								
							ELSE
								// Prompt user to transfer to out of office
								l_nRtn = messagebox(gs_AppName,i_cToFullName+' is marked out of office.  ' + &
								                 'Do you wish to reassign cases anyway?',Question!,YesNo!)
								IF l_nRtn <> 1 THEN
									RETURN
								END IF
								
							END IF
							 
						END IF
						 
						// The good row array has all of the still selected rows
						ll_selected_row = l_nGoodRowArray
						l_nNumSelected = l_nGoodRowCntr

						OldPointer = SetPointer(HourGlass!)
									
						FOR l_nIndex = 1 TO l_nNumSelected
							ls_case_number_arg = uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							// Update the Case_Log table with the new CSR
							UPDATE cusfocus.case_log
								SET case_log_case_rep = :i_cToUserID,
									 updated_by = :i_cLoginID
							 WHERE case_number = :ls_case_number_arg
							 USING SQLCA;

							// Update the Case_Transfer table with a report of this re-assign
							l_cNewKey = w_supervisor_portal.fw_getkeyvalue('case_transfer')
							
							l_cXFerNotes = 'Case Re-Assigned by '+i_cLoginID					
							
							l_dtTransferDate = w_supervisor_portal.fw_gettimestamp()
							
							ls_case_number_arg = uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
							// Check to see if there is already a record in the case transfer table...
							SELECT case_transfer_id INTO :l_cCaseTransferID
							  FROM cusfocus.case_transfer
							 WHERE case_number = :ls_case_number_arg
							   AND case_transfer_type = 'O'
							 USING SQLCA;
							 
							 //JWhite Added 8.1.2006
							SELECT cusfocus.cusfocus_user.user_dept_id  
						     INTO :ls_fromdeptID  
						     FROM cusfocus.cusfocus_user  
						    WHERE cusfocus.cusfocus_user.user_id = :i_cFromUserID   ;
							 
						   SELECT cusfocus.cusfocus_user.user_dept_id  
						     INTO :ls_todeptID  
						     FROM cusfocus.cusfocus_user  
						     WHERE cusfocus.cusfocus_user.user_id = :i_cToUserID   ;
					 		//End JWhite Added 8.1.2006
							 
							IF ISNULL(l_cCaseTransferID) OR l_cCaseTransferID = '' THEN
							
								ls_case_number_arg = uo_search_reassigncases.dw_report.object.case_number[ll_selected_row[l_nIndex]]
								INSERT INTO cusfocus.case_transfer (case_transfer_id, &
									case_number, case_transfer_to, case_transfer_from, &
									case_transfer_date, case_transfer_notes, case_transfer_type, transfer_from_dept, transfer_to_dept, return_for_close ) 
								VALUES (:l_cNewKey, :ls_case_number_arg, :i_cToUserID, &
								:i_cFromUserID, :l_dtTransferDate, :l_cXferNotes, 'O', :ls_fromdeptID, :ls_todeptID, 0) 
								USING SQLCA;
								
								IF sqlca.sqlcode <> 0 THEN
									messagebox(gs_AppName,'Unable to Transfer Case.  Please see your sysadmin administrator.')
									RETURN
								END IF
							ELSE
								UPDATE cusfocus.case_transfer
								   SET case_transfer_to = :i_cToUserID,
									case_transfer_from = :i_cFromUserID,
									case_transfer_date = :l_dtTransferDate,
									case_transfer_notes = :l_cXferNotes,
									transfer_from_dept = :ls_fromdeptID,
									transfer_to_dept	=	:ls_todeptID,
									case_viewed = 'N',
									return_for_close = 0
								 WHERE case_transfer_id = :l_cCaseTransferID
									USING SQLCA;
							END IF
								
							l_cCaseTransferID = ''
						NEXT
						
						IF SQLCA.SQLCODE <> 0 THEN
							MessageBox(gs_AppName, 'Unable to complete the transfer.  Please see your sysadmin administrator.')
							ROLLBACK;
						ELSE
							COMMIT;
							l_cNewKey = w_supervisor_portal.fw_getkeyvalue('reminders')
							l_cComments = 'The following cases have been reassigned to: '+i_cToUserID+': '+l_cGoodCaseList
							
							INSERT INTO cusfocus.reminders (reminder_id, reminder_type_id, reminder_viewed, case_reminder, 
                         reminder_crtd_date, reminder_set_date, reminder_subject, reminder_comments, reminder_author,
                         reminder_recipient)
							VALUES
                         (:l_cNewKey, '2', 'N', 'N', getdate(), getdate(), 'Cases Reassigned', :l_cComments,
                         :i_cLoginID, :i_cFromUserID) USING SQLCA;
							
							
						END IF
						
						
						messagebox(gs_AppName,string(l_nNumSelected) +' cases were successfully transferred to '+ &
							i_cToFullName )
							
						i_nNumCases = uo_search_reassigncases.of_retrieve(i_cFromUserID)

					ELSE
							RETURN
						
						END IF
						
						SetPointer(OldPointer)
					
				ELSE
					messagebox(gs_AppName,'There are no cases selected to be reassigned')
				END IF
				
			ELSE
				messagebox(gs_AppName,'There are no cases for '+i_cFromFullName)
			END IF
			
		ELSE
			messagebox(gs_AppName,'Cannot reassign cases to the same CSR')
		END IF
	
	ELSE
		messagebox(gs_AppName,'Please select a CSR to reassign cases to')
	END IF
	
ELSE
	messagebox(gs_AppName,'Please select a CSR to reassign cases from')
END IF



end event

type dw_csrlist_to from u_outliner_std within u_reassign_cases
integer x = 1870
integer y = 64
integer width = 1029
integer height = 660
integer taborder = 20
borderstyle borderstyle = stylelowered!
integer i_bmpheight = 12
integer i_bmpwidth = 12
end type

event po_pickedrow;call super::po_pickedrow;//***********************************************************************************************
//
//  Event:   po_PickedRow
//  Purpose: Get the row key of the selected row to process the Case reassign
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/14/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING	l_cKeys[], l_cRowDesc
LONG		l_nLevel, l_nRow, l_nPos1, l_nReturn
S_CSR_INFO l_csr_info

// If this event was trigger by another function/event then set defaults.
IF clickedlevel = 2 THEN
	l_nRow = clickedrow

	// Get the key of the Picked Row and view it's details
	
	l_cRowDesc = fu_HLGetRowDesc(l_nRow)
	l_csr_info = w_supervisor_portal.fw_GetCSRInfo(l_cRowDesc)
	i_cToFirstName = l_csr_info.user_first_name
	i_cToLastName = l_csr_info.user_last_name
	i_cToFullName = l_csr_info.user_full_name
	i_cToUserID = l_csr_info.user_id
	
ELSE
	i_cToUserID = ''
	 
END IF


end event

type st_2 from statictext within u_reassign_cases
integer x = 1765
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reassign To:"
boolean focusrectangle = false
end type

type st_1 from statictext within u_reassign_cases
integer x = 23
integer width = 462
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reassign From:"
boolean focusrectangle = false
end type

type dw_csrlist_from from u_outliner_std within u_reassign_cases
integer x = 128
integer y = 64
integer width = 1029
integer height = 660
integer taborder = 10
borderstyle borderstyle = stylelowered!
integer i_bmpheight = 12
integer i_bmpwidth = 12
end type

event po_pickedrow;call super::po_pickedrow;//***********************************************************************************************
//
//  Event:   po_PickedRow
//  Purpose: Get the row key of the selected row to process the Case reassign
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/14/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING	l_cKeys[], l_cRowDesc
LONG		l_nLevel, l_nRow, l_nPos1, l_nReturn
S_CSR_INFO l_csr_info
U_DW_STD l_dwResults


// If this event was trigger by another function/event then set defaults.
IF clickedlevel = 2 THEN
	l_nRow = clickedrow

	// Get the key of the Picked Row and view it's details
	
	l_cRowDesc = fu_HLGetRowDesc(l_nRow)
	
	l_csr_info = w_supervisor_portal.fw_GetCSRInfo(l_cRowDesc)
	i_cFromFirstName = l_csr_info.user_first_name
	i_cFromLastName = l_csr_info.user_last_name
	i_cFromFullName = l_csr_info.user_full_name
	i_cFromUserID = l_csr_info.user_id
	
ELSE
	i_cFromUserID = ''
	SETNULL(i_nNumCases)
	 
END IF

// New stuff - RAP
i_nNumCases = uo_search_reassigncases.of_retrieve(i_cFromUserID)

IF i_nNumCases = 0 THEN
	m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
	m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
END IF




end event

type dw_case_detail_report from datawindow within u_reassign_cases
boolean visible = false
integer x = 9
integer y = 16
integer width = 3301
integer height = 1704
integer taborder = 10
string dataobject = "d_case_detail_history_report"
boolean livescroll = true
end type

event constructor;//********************************************************************************************
//
//  Event:   constructor
//  Purpose: Set the application name in the header of the report
//  
//  date
//  -------- ----------- ---------------------------------------------------------------------
//  01/13/01 cjackson    Original Version
//
//********************************************************************************************

Object.appname_t.Text = gs_appname
end event

