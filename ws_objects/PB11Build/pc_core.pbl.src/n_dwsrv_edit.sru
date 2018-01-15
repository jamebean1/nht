$PBExportHeader$n_dwsrv_edit.sru
$PBExportComments$DataWindow service for edit and update handling
forward
global type n_dwsrv_edit from n_dwsrv_main
end type
end forward

global type n_dwsrv_edit from n_dwsrv_main
end type
global n_dwsrv_edit n_dwsrv_edit

type variables
//-----------------------------------------------------------------------------------------
// Edit Service Constants
//-----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_ValOK			= 0
CONSTANT INTEGER	c_ValFailed		= 1
CONSTANT INTEGER	c_ValFixed		= 2
CONSTANT INTEGER	c_ValNotProcessed		= -9

CONSTANT INTEGER 	c_RejectAndShowError   	= 0
CONSTANT INTEGER 	c_RejectAndStay        	= 1
CONSTANT INTEGER 	c_AcceptAndMove       	= 2
CONSTANT INTEGER 	c_RejectAndMove        	= 3

//-----------------------------------------------------------------------------------------
//  Edit Service Instance Variables
//-----------------------------------------------------------------------------------------

LONG			i_ValidateRow
INTEGER		i_ValidateCol
BOOLEAN		i_InItemError

end variables

forward prototypes
public function integer fu_new (long start_row, long num_rows)
public function integer fu_modify ()
public function integer fu_validate ()
public function integer fu_validaterow (long row_nbr)
public function integer fu_validatecol (long row_nbr, integer col_nbr)
public function integer fu_save (integer changes)
public function integer fu_itemerror (long row_nbr, string text)
public function integer fu_displayvalerror (string id)
public function integer fu_displayvalerror ()
public subroutine fu_itemfocuschanged ()
public function integer fu_rollback ()
public function integer fu_commit ()
public function boolean fu_checkchanges ()
public function integer fu_promptchanges ()
public function boolean fu_checkrequired (integer col_nbr, string text)
public function integer fu_setupdate (string table_name, string key_names[], string update_names[])
public function integer fu_itemchanged (long row_nbr, string text)
public subroutine fu_resetupdate ()
public subroutine fu_wiredrag (string drag_columns[], integer drag_method, datawindow drop_dw)
public subroutine fu_wiredrop (string drop_columns[])
public subroutine fu_setdragindicator (string single_row, string multiple_rows, string no_drop)
public function integer fu_copy (long num_rows, long copy_rows[], integer changes)
public function integer fu_dddwfind (long row_nbr, dwobject dwo, string text)
public function integer fu_dddwsearch (long row_nbr, dwobject dwo, string text)
public function integer fu_dragwithin (dragobject drag_dw, long row_nbr)
public function integer fu_drop (dragobject drag_dw, long row_nbr)
public function integer fu_delete (long num_rows, long delete_rows[], integer changes)
public function integer fu_drag ()
public function integer fu_displayvalerror (string id, string error_message)
end prototypes

public function integer fu_new (long start_row, long num_rows);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_New
//  Description   : Add new records to the DataWindow.
//
//  Parameters    : LONG    Start_Row -
//                     Row number to insert in front of.  If it is
//                     0 then the rows are added to the end.
//                  LONG    Num_Rows-
//                     Number of rows to add.
//
//  Return Value  : INTEGER -
//                      0 - new operation successful.
//                     -1 - new operation failed or is not allowed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/26/98	 Beth Byers	Remove test if i_ServiceDw is empty before
//								clearing the ParentDW selected rows.  Getting
//								prompted to save data before adding a new 
//								record would set i_IsEmpty = TRUE, so the 
//								ParentDW selected rows would not clear when
//								the new row was displayed
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

LONG         l_Idx, l_StartRow, l_NumSelected
LONG         l_SelectedRows[], l_RequestedRows, l_SaveRow
INTEGER      l_NumChildren
BOOLEAN      l_NewProcessed, l_FoundInstances, l_Reset, l_FoundShare
BOOLEAN      l_ShareDW[], l_DoIt
U_DW_MAIN    l_ChildrenDW[]
DATAWINDOW   l_DW

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success
i_ServiceDW.i_RequestMode = i_ServiceDW.c_NewMode
l_NewProcessed  = FALSE

//------------------------------------------------------------------
//  Make sure we are not is QUERY mode.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsQuery THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Determine if we can do new records on this DataWindow.
//------------------------------------------------------------------

IF i_ServiceDW.i_AllowNew OR i_ServiceDW.i_AllowDrop THEN
	
	//---------------------------------------------------------------
	//  Check to see if we have a valid starting row and number of 
	//  rows.
	//---------------------------------------------------------------

	l_StartRow = start_row
	IF start_row > i_ServiceDW.RowCount() THEN
		l_StartRow = 0
	END IF
	IF num_rows = 0 THEN
		Error.i_FWError = c_Fatal
		GOTO Finished
	END IF

	//---------------------------------------------------------------
	//  Check the previous row/column for errors before inserting
	//  a new row.
	//---------------------------------------------------------------

	IF i_ServiceDW.AcceptText() <> 1 THEN
		Error.i_FWError = c_Fatal
		GOTO Finished
	END IF

	//---------------------------------------------------------------
	//  If only one new record is allowed at a time then prompt to 
	//  save the existing new record before continuing.
	//---------------------------------------------------------------

	i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)

	IF i_HaveNew THEN
		l_Reset = TRUE

		//------------------------------------------------------------
		//  If we have a parent and it doesn't allow multiselect and
		//  we are not in a one-to-many relationship, then we may
		//  need to reset ourselves.
		//
		//  NOTE:  We can not be 100% sure of determining a one-to-many
		//         relationship.  Our attempt compares the number
		//         selected in the parent with the number of rows in
		//         the child.  If they happen to be equal then we will
		//         quess based on whether the child is a free-form.
		//------------------------------------------------------------

		IF IsValid(i_ServiceDW.i_ParentDW) THEN
			IF i_ServiceDW.i_ParentDW.i_MultiSelect THEN
				l_Reset = FALSE
			ELSE
				IF	i_ServiceDW.i_ParentDW.i_NumSelected > 0 THEN
					IF i_ServiceDW.i_ParentDW.i_NumSelected <> i_ServiceDW.RowCount() THEN
						l_Reset = FALSE
					ELSE
						IF i_ServiceDW.i_PresentationStyle <> i_ServiceDW.c_FreeFormStyle THEN
							l_Reset = FALSE
						END IF
					END IF
				ELSE
					IF i_ServiceDW.i_ShareData THEN
						l_Reset = FALSE
					END IF
				END IF
			END IF
		ELSE
			l_Reset = FALSE
		END IF

		IF i_ServiceDW.i_OnlyOneNewRow OR l_Reset THEN
			IF i_ServiceDW.fu_Reset(i_ServiceDW.c_PromptChanges) &
				<> c_Success THEN
				Error.i_FWError = c_Fatal
				i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)
			GOTO Finished
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  If we have children, then prompt to save any changes before
	//  resetting the children.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
		IF NOT i_ServiceDW.i_DWSRV_UOW.fu_FindShare(i_ServiceDW) THEN
			IF i_ServiceDW.i_DWSRV_UOW.fu_Save(i_ServiceDW, &
													     i_ServiceDW.c_PromptChanges, &
													     i_ServiceDW.c_CheckChildren) = c_Success THEN

				//------------------------------------------------------
				//  If a parent DataWindow doesn't exist or the save 
				//  didn't prompt because the children had
				//  no changes then don't reset.  This prevents the
				//  child records from disappearing if the user cancels
				//  out of the fu_ClearSelectedRows() call below.
				//------------------------------------------------------

				l_DoIt = FALSE
				IF i_ServiceDW.fu_GetSaveStatus() > 0 THEN
					l_DoIt = TRUE
				ELSEIF IsNull(i_ServiceDW.i_ParentDW) THEN
					l_DoIt = TRUE
				ELSEIF IsNull(i_ServiceDW.i_ParentDW) = FALSE THEN
					IF NOT i_ServiceDW.i_MultiSelect AND &
						i_ServiceDW.i_ParentDW.i_MultiSelect THEN
						l_DoIt = TRUE
					END IF
				END IF

				IF l_DoIt THEN
	         	IF i_ServiceDW.i_DWSRV_UOW.fu_Refresh(i_ServiceDW, &
   	                                               i_ServiceDW.c_ResetChildren, &
      	                                            i_ServiceDW.c_SameMode) <> c_Success THEN
						Error.i_FWError = c_Fatal
						i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)
						GOTO Finished
					END IF
				END IF
			ELSE
				Error.i_FWError = c_Fatal
				i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)
				GOTO Finished
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  If we have a parent and it doesn't allow multiselect and we
	//  are not in a one-to-many relationship, then clear the 
	//  selected parent records before inserting a new.
	//
	//  NOTE:  We can not be 100% sure of determining a one-to-many
	//         relationship.  Our attempt compares the number
	//         selected in the parent with the number of rows in the
	//         child.  If they happen to be equal then we will
	//         guess based on whether the child is a free-form.
	//
	//  Removed IF i_ServiceDW.i_IsEmpty = TRUE from the hierarchy
	//	 of tests before clearing selected rows
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_ParentDW) THEN
		IF NOT i_ServiceDW.i_ParentDW.i_MultiSelect THEN
			IF	i_ServiceDW.i_ParentDW.i_NumSelected > 0 THEN
				IF i_ServiceDW.i_ParentDW.i_NumSelected = i_ServiceDW.RowCount() OR i_ServiceDW.RowCount() = 0 THEN
					IF i_ServiceDW.i_PresentationStyle = i_ServiceDW.c_FreeFormStyle THEN
						IF i_ServiceDW.i_ParentDW.fu_ClearSelectedRows(i_ServiceDW.c_PromptChanges) &
							<> c_Success THEN
							Error.i_FWError = c_Fatal
							i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)
							GOTO Finished
						END IF
					END IF
				END IF
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  Display the new prompt.
	//---------------------------------------------------------------

	IF IsValid(FWCA.MDI) THEN
		IF FWCA.MGR.i_ShowMicrohelp THEN
		   FWCA.MDI.fu_SetMicroHelp("New")
		END IF
	END IF

	//---------------------------------------------------------------
	//  Make sure no DataWindow activity happens during this process.
	//---------------------------------------------------------------

	i_ServiceDW.i_IgnoreRFC = TRUE
	i_ServiceDW.i_IgnoreVal = TRUE
	IF i_ServiceDW.i_ShareData THEN
		l_NumChildren = i_ServiceDW.i_DWSRV_UOW.fu_GetChildren(i_ServiceDW.i_ParentDW, l_ChildrenDW[], l_ShareDW[])
		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].i_IgnoreRFC = TRUE
				l_ChildrenDW[l_Idx].i_IgnoreVal = TRUE
				l_ChildrenDW[l_Idx].fu_SetRedraw(i_ServiceDW.c_Off)
			END IF
		NEXT
		i_ServiceDW.i_ParentDW.i_IgnoreRFC = TRUE
		i_ServiceDW.i_ParentDW.i_IgnoreVAL = TRUE
		i_ServiceDW.i_ParentDW.fu_SetRedraw(i_ServiceDW.c_Off)
	END IF

	//---------------------------------------------------------------
	//  If an empty row exists, remove it before the new.
	//---------------------------------------------------------------

	IF i_ServiceDW.i_IsEmpty THEN
		i_ServiceDW.RowsDiscard(1, 1, Primary!)
		i_ServiceDW.Modify(i_ServiceDW.i_NormalTextColors)
		i_ServiceDW.i_IsEmpty = FALSE
		i_ServiceDW.fu_SetIndicatorRow()
		i_ServiceDW.i_IsEmpty = TRUE
	END IF

	//---------------------------------------------------------------
	//  Set the current mode variable.
	//---------------------------------------------------------------

	i_ServiceDW.i_CurrentMode = i_ServiceDW.c_NewMode

	//---------------------------------------------------------------
	//  Insert the new record(s).
	//---------------------------------------------------------------

	i_ServiceDW.i_InProcess = TRUE
	l_RequestedRows = 0
	l_NewProcessed = TRUE
	FOR l_Idx = 1 TO num_rows
		l_StartRow = i_ServiceDW.InsertRow(l_StartRow)
		IF l_Idx = 1 THEN
			l_SaveRow = l_StartRow
		END IF
		i_ServiceDW.i_CursorRow = l_StartRow
		l_SelectedRows[l_Idx] = l_StartRow
		IF NOT i_ServiceDW.i_FromEvent AND NOT i_InDrag THEN
			i_ServiceDW.i_InProcess = TRUE
			i_ServiceDW.TriggerEvent("pcd_New")
			i_ServiceDW.i_InProcess = FALSE
			IF Error.i_FWError = c_Success THEN
				l_RequestedRows = l_RequestedRows + 1
			END IF
		ELSE
			l_RequestedRows = l_RequestedRows + 1
		END IF

		l_StartRow = l_StartRow + 1
		IF l_StartRow > i_ServiceDW.RowCount() THEN
			l_StartRow = 0
		END IF
	NEXT
	i_ServiceDW.i_InProcess = FALSE
	
	//---------------------------------------------------------------
	//  If the DataWindow was empty and no rows were inserted and
	//  the new operation failed, put the empty row back.
	//---------------------------------------------------------------

	IF Error.i_FWError = c_Fatal THEN
		IF i_ServiceDW.i_IsEmpty THEN
			i_ServiceDW.fu_SetEmpty()
		ELSE
			i_ServiceDW.i_IsEmpty = FALSE
		END IF
	ELSE
		i_ServiceDW.i_IsEmpty = FALSE
	END IF

	//---------------------------------------------------------------
	//  If we are coming out of VIEW mode make sure the columns are
	//  unprotected.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_CUES) THEN
		i_ServiceDW.i_DWSRV_CUES.fu_SetViewMode(c_Off)
	ELSE
		i_ServiceDW.Modify("datawindow.readonly=no")
	END IF

	//---------------------------------------------------------------
	//  Determine if all new rows should be selected (multi-select)
	//  or if only the first new row should be selected 
	//  (single-select).
	//---------------------------------------------------------------
	
	IF l_RequestedRows > 0 THEN
		IF i_ServiceDW.i_MultiSelect THEN
			l_NumSelected = l_RequestedRows
		ELSE
			l_NumSelected = 1
		END IF

		i_ServiceDW.fu_SetSelectedRows(l_NumSelected, l_SelectedRows[], &
										       i_ServiceDW.c_IgnoreChanges, &
                                     i_ServiceDW.c_NoRefreshChildren)
	END IF

	//---------------------------------------------------------------
	//  Set the new cursor row.
	//---------------------------------------------------------------

	i_ServiceDW.i_CursorRow = l_SaveRow
	i_ServiceDW.ScrollToRow(i_ServiceDW.i_CursorRow)

	//---------------------------------------------------------------
	//  Set the cursor to the lowest visible tab order column but
	//  make sure we are not in the opening process of a window.
	//---------------------------------------------------------------

	i_ServiceDW.i_IgnoreVal = TRUE
	i_ServiceDW.SetColumn(i_ColLowTabOrder)
	i_ServiceDW.i_CursorCol = i_ColName[i_ColLowTabOrder]
	i_ServiceDW.i_IgnoreVal = FALSE

	//---------------------------------------------------------------
	//  If this DataWindow is a share, scroll its parent to the
	//  same row as this DataWindow.  
	//---------------------------------------------------------------

	IF i_ServiceDW.i_ShareData THEN
		i_ServiceDW.i_ParentDW.i_FromClicked = FALSE
		i_ServiceDW.i_ParentDW.i_FromDoubleClicked = FALSE
		i_ServiceDW.i_ParentDW.i_IgnoreRFC = FALSE
		i_ServiceDW.i_ParentDW.i_IgnoreVAL = FALSE
		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].i_IgnoreRFC = FALSE
				l_ChildrenDW[l_Idx].i_IgnoreVal = FALSE
			END IF
		NEXT
		i_ServiceDW.i_ParentDW.ScrollToRow(i_ServiceDW.i_CursorRow)
		i_ServiceDW.i_ParentDW.fu_SetRedraw(i_ServiceDW.c_On)
		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].fu_SetRedraw(i_ServiceDW.c_On)
			END IF
		NEXT
	END IF

	//---------------------------------------------------------------
	//  If this DataWindow has children that share with it, scroll 
	//  its children to the same row as this DataWindow.  
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
		IF NOT i_ServiceDW.i_ShareData THEN
			l_NumChildren = i_ServiceDW.i_DWSRV_UOW.fu_GetChildren(i_ServiceDW, l_ChildrenDW[], l_ShareDW[])
			FOR l_Idx = 1 TO l_NumChildren
				IF l_ShareDW[l_Idx] THEN
					l_ChildrenDW[l_Idx].i_IgnoreRFC = TRUE
					l_ChildrenDW[l_Idx].i_IgnoreVal = TRUE
					l_ChildrenDW[l_Idx].ScrollToRow(i_ServiceDW.i_CursorRow)
					l_ChildrenDW[l_Idx].i_CursorRow = i_ServiceDW.i_CursorRow
					l_ChildrenDW[l_Idx].i_CurrentMode = i_ServiceDW.i_CurrentMode
					IF IsValid(l_ChildrenDW[l_Idx].i_DWSRV_CUES) THEN
						l_ChildrenDW[l_Idx].i_DWSRV_CUES.fu_SetViewMode(c_Off)
					ELSE
						l_ChildrenDW[l_Idx].Modify("datawindow.readonly=no")
					END IF
					l_ChildrenDW[l_Idx].i_IgnoreRFC = FALSE
					l_ChildrenDW[l_Idx].i_IgnoreVal = FALSE
				END IF
			NEXT
		END IF
	END IF

	//---------------------------------------------------------------
	//  Indicate that we have new records.  This flag is cleared
	//  by the save process.
	//---------------------------------------------------------------

	i_HaveNew = TRUE

	//---------------------------------------------------------------
	//  If menu/button activation is available, set the controls.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
		IF i_ServiceDW.i_IsCurrent THEN
			i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_AllControls)
		END IF
	END IF

	//---------------------------------------------------------------
	//  Restore normal DataWindow activity.
	//---------------------------------------------------------------

	i_ServiceDW.i_IgnoreVal = FALSE
	i_ServiceDW.i_IgnoreRFC = FALSE
	i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)
	i_ServiceDW.i_RequestMode = i_ServiceDW.c_SameMode

ELSE

	IF i_ServiceDW.i_PLAllowDrillDown AND i_ServiceDW.i_EnableNewOnOpen THEN

		//------------------------------------------------------------
		//  If only one selected record is possible and a record is 
		//  already selected then clear the selection, saving 
		//  changes if needed.
		//------------------------------------------------------------

		l_FoundInstances = FALSE
		l_FoundShare = FALSE
		IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
			l_FoundInstances = i_ServiceDW.i_DWSRV_UOW.fu_CheckInstance(i_ServiceDW)
			l_FoundShare = i_ServiceDW.i_DWSRV_UOW.fu_FindShare(i_ServiceDW)
			IF i_ServiceDW.i_DWSRV_UOW.i_InModeChange THEN
				GOTO Finished
			END IF
		END IF

		IF l_FoundInstances THEN
			i_ServiceDW.SelectRow(0, FALSE)
			i_ServiceDW.i_NumSelected = 0
			SetNull(l_DW)
			i_ServiceDW.i_DWSRV_UOW.fu_SetInstance(l_DW)
		ELSE
			IF NOT i_ServiceDW.i_MultiSelect AND &
				i_ServiceDW.i_NumSelected > 0 AND &
				NOT l_FoundShare THEN
				IF i_ServiceDW.fu_ClearSelectedRows(i_ServiceDW.c_PromptChanges) &
					<> c_Success THEN
					Error.i_FWError = c_Fatal
					GOTO Finished
				END IF
			END IF
		END IF
	
		//------------------------------------------------------------
		//  Trigger pcd_PickedRow to see if there are children that
		//  can add records.
		//------------------------------------------------------------

		i_ServiceDW.i_FromPickedRow = TRUE
		i_ServiceDW.Event pcd_PickedRow(i_ServiceDW.i_NumSelected, i_ServiceDW.i_SelectedRows[])

		//------------------------------------------------------------
		//  If the developer closed the window this
		//  DataWindow is on during the pcd_PickedRow
		//  event then the remaining code is not valid and
		//  should be skipped.  
		//------------------------------------------------------------
	
		IF NOT IsValid(THIS) THEN
			RETURN 0
		END IF

		i_ServiceDW.i_FromPickedRow = FALSE
		IF Error.i_FWError <> c_Success THEN
			GOTO Finished
		END IF

		//------------------------------------------------------------
		//  Now determine if a unit-of-work was created.  If so, 
		//  execute the new function in the unit-of-work to process
		//  the child DataWindows.
		//------------------------------------------------------------

		l_NewProcessed = TRUE
		IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
			IF i_ServiceDW.i_DWSRV_UOW.fu_New(i_ServiceDW, start_row, num_rows) &
				<> c_Success THEN
     			Error.i_FWError = c_Fatal
			END IF
		END IF
	END IF
END IF

Finished:

//------------------------------------------------------------------
//  If an error occurred before the new records were processed and
//  this function was not called by pcd_new, then trigger this
//  event for the developer to be consistent.
//------------------------------------------------------------------

IF NOT l_NewProcessed AND NOT i_InDrag THEN
	IF NOT i_ServiceDW.i_FromEvent THEN
		i_ServiceDW.i_InProcess = TRUE
		i_ServiceDW.TriggerEvent("pcd_New")
		i_ServiceDW.i_InProcess = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_modify ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_Modify
//  Description   : Put the DataWindow into modify mode.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - modify operation successful.
//                     -1 - modify operation failed or is not allowed.
//
//  Change History:
//
//  Date     Person     Description of Change and/or Bug Number
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

LONG    l_Idx
INTEGER l_ChildrenBefore, l_ChildrenAfter, l_RefreshMode
BOOLEAN l_FoundInstances, l_DoPickedRow
INTEGER l_UpperBound

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success
i_ServiceDW.i_RequestMode = i_ServiceDW.c_ModifyMode

//------------------------------------------------------------------
//  Make sure we are not is QUERY mode.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsQuery THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Determine if this DataWindow can modify records.
//------------------------------------------------------------------

IF i_ServiceDW.i_AllowModify THEN

	//---------------------------------------------------------------
	//  If the DataWindow is empty, just return.
	//---------------------------------------------------------------

	IF i_ServiceDW.i_IsEmpty THEN
		Error.i_FWError = c_Success
		GOTO Finished
	END IF

	//---------------------------------------------------------------
	//  Do an AcceptText before changing into MODIFY mode.  This is 
	//  necessary because when a protect attribute is set for a column
	//  it puts the original value from the buffer back into the field,
	//  wiping out a possible change.
	//---------------------------------------------------------------

	IF i_ServiceDW.AcceptText() <> 1 THEN
		Error.i_FWError = c_Fatal
		GOTO Finished
	END IF

	//---------------------------------------------------------------
	//  Display the modify prompt.
	//---------------------------------------------------------------

	IF IsValid(FWCA.MDI) THEN
		IF FWCA.MGR.i_ShowMicrohelp THEN
		   FWCA.MDI.fu_SetMicroHelp("Modify")
		END IF
	END IF

	//---------------------------------------------------------------
	//  Make sure no DataWindow activity happens during this process.
	//---------------------------------------------------------------

	i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)
	i_ServiceDW.i_IgnoreRFC = TRUE
	i_ServiceDW.i_IgnoreVal = TRUE

	//---------------------------------------------------------------
	//  If the visual cues service is avaliable and the DataWindow is
	//  in VIEW mode then change the the columns so that they will 
	//  become editable.
	//---------------------------------------------------------------

//	IF i_ServiceDW.i_CurrentMode <> i_ServiceDW.c_ModifyMode THEN
		IF IsValid(i_ServiceDW.i_DWSRV_CUES) THEN
			i_ServiceDW.i_DWSRV_CUES.fu_SetViewMode(c_Off)
		ELSE
			i_ServiceDW.Modify("datawindow.readonly=no")
		END IF
//	END IF

	//---------------------------------------------------------------
	//  Set the cursor to the lowest visible tab order column.
	//---------------------------------------------------------------

	IF NOT i_ServiceDW.i_ShareData THEN
		i_ServiceDW.SetColumn(i_ColLowTabOrder)
		i_ServiceDW.i_CursorCol = i_ColName[i_ColLowTabOrder]
	END IF

	//---------------------------------------------------------------
	//  Set the current mode variable.
	//---------------------------------------------------------------

	i_ServiceDW.i_CurrentMode = i_ServiceDW.c_ModifyMode

	//---------------------------------------------------------------
	//  Get the selected rows.
	//---------------------------------------------------------------

	i_ServiceDW.i_NumSelected = &
		i_ServiceDW.fu_GetSelectedRows(i_ServiceDW.i_SelectedRows[])

	//---------------------------------------------------------------
	//  Determine if a unit-of-work was created (i_ServiceDW has children)
	//  If so, determine if rows need to be loaded into the children and
	//  put them into modify mode.
	//---------------------------------------------------------------

	IF i_ServiceDW.i_ModeOnSelect = i_ServiceDW.c_ParentModeOnSelect THEN
		IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
			IF i_ServiceDW.i_DWSRV_UOW.fu_Modify(i_ServiceDW, &
					i_ServiceDW.c_AutoRefreshChildren) <> c_Success THEN
				Error.i_FWError = c_Fatal
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  If menu/button activation is available, set the controls.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
		IF i_ServiceDW.i_IsCurrent THEN
			i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_ModeControls)
		END IF
	END IF

	//---------------------------------------------------------------
	//  Restore normal DataWindow activity.
	//---------------------------------------------------------------

	i_ServiceDW.i_IgnoreRFC = FALSE
	i_ServiceDW.i_IgnoreVal = FALSE
	i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)
	i_ServiceDW.i_RequestMode = i_ServiceDW.c_SameMode

ELSE

	IF i_ServiceDW.i_EnableModifyOnOpen THEN

		//------------------------------------------------------------
		//  If at least one record is selected, trigger the 
		//  pcd_PickedRow event to see if we have children
		//  DataWindows that can modify records.
		//------------------------------------------------------------

		IF i_ServiceDW.i_PLAllowDrillDown AND i_ServiceDW.i_NumSelected > 0 AND &
			NOT i_ServiceDW.i_InRetrieveOnOpen THEN

			l_DoPickedRow = TRUE
			IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
				IF i_ServiceDW.i_DWSRV_UOW.i_InModeChange THEN
					GOTO Finished
				END IF

				l_ChildrenBefore = i_ServiceDW.i_DWSRV_UOW.fu_GetChildrenCnt(i_ServiceDW)
				l_FoundInstances = i_ServiceDW.i_DWSRV_UOW.fu_CheckInstance(i_ServiceDW)
				IF l_FoundInstances THEN
					IF i_ServiceDW.i_DWSRV_UOW.fu_FindInstance(i_ServiceDW, &
						i_ServiceDW.i_SelectedRows[1]) THEN
						l_DoPickedRow = FALSE
					END IF
				END IF
			END IF

			IF l_DoPickedRow THEN

				i_ServiceDW.i_FromPickedRow = TRUE
				i_ServiceDW.Event pcd_PickedRow(i_ServiceDW.i_NumSelected, i_ServiceDW.i_SelectedRows[])

				//------------------------------------------------------
				//  If the developer closed the window this
				//  DataWindow is on during the pcd_PickedRow
				//  event then the remaining code is not valid and
				//  should be skipped.  
				//------------------------------------------------------
	
				IF NOT IsValid(i_ServiceDW) THEN
					RETURN 0
				END IF

				i_ServiceDW.i_FromPickedRow = FALSE
				IF Error.i_FWError <> c_Success THEN
					Error.i_FWError = c_Fatal
					GOTO Finished
				END IF
			END IF
			
			//---------------------------------------------------------
			//  Determine if a unit-of-work was created.  If so, 
			//  determine if rows need to be loaded into the children 
			//  and put them into modify mode.
			//---------------------------------------------------------

			IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
				l_ChildrenAfter = i_ServiceDW.i_DWSRV_UOW.fu_GetChildrenCnt(i_ServiceDW)
				//------------------------------------------------------
				// If the window being opened is an instance window, and
				// it is not the first being opened, then l_RefreshMode
				// must always be set to c_RefreshChildren.
				//------------------------------------------------------
				IF l_FoundInstances THEN
					l_RefreshMode = i_ServiceDW.c_RefreshChildren
				ELSE
					IF l_ChildrenBefore <> l_ChildrenAfter THEN
						l_RefreshMode = i_ServiceDW.c_RefreshChildren
					ELSE
						l_RefreshMode = i_ServiceDW.c_AutoRefreshChildren
					END IF
				END IF	
				IF i_ServiceDW.i_DWSRV_UOW.fu_Modify(i_ServiceDW, l_RefreshMode) <> c_Success THEN
					Error.i_FWError = c_Fatal
				END IF
			END IF
		END IF
	END IF

END IF

Finished:

//------------------------------------------------------------------
//  Trigger the pcd_Modify event for the developer.
//------------------------------------------------------------------

IF NOT i_ServiceDW.i_FromEvent THEN
	i_ServiceDW.i_InProcess = TRUE
	i_ServiceDW.TriggerEvent("pcd_Modify")
	i_ServiceDW.i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_validate ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_Validate
//  Description   : Validate the DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - validation operation successful.
//                     -1 - validation operation failed.
//
//  Change History:
//
//  Date     Person     Bug # / Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER      l_SaveCol, l_Idx
STRING       l_ErrorStrings[], l_Text, l_ValMsg, l_Name, l_ID
LONG         l_Row, l_SaveRow, l_NewSelections[], l_Rows
BOOLEAN      l_Modified, l_CheckCurrent, l_Visible, l_RequiredError
DWITEMSTATUS l_RowStatus, l_ColStatus

//------------------------------------------------------------------
//  Assume no validation errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Display the validate prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Validate")
	END IF
END IF

//------------------------------------------------------------------
//  Make sure no DataWindow activity happens during this process.
//------------------------------------------------------------------

i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)
i_ServiceDW.i_IgnoreRFC = TRUE

//------------------------------------------------------------------
//  Save the current row and column.
//------------------------------------------------------------------

l_SaveRow = i_ServiceDW.GetRow()
l_SaveCol = i_ServiceDW.GetColumn()

//------------------------------------------------------------------
//  Do an AcceptText() to get any text the user typed.  If 
//  AcceptText() fails, then we have a validation error that will
//  already be reported.
//------------------------------------------------------------------

IF i_ServiceDW.AcceptText() = -1 THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
ELSE
	IF NOT i_ServiceDW.i_AlwaysCheckRequired AND l_SaveRow > 0 AND &
		l_SaveCol > 0 THEN
		l_RowStatus = i_ServiceDW.GetItemStatus(l_SaveRow, 0, Primary!)
		IF l_RowStatus <> New! OR NOT i_ServiceDW.i_IgnoreNewRows THEN
			IF fu_CheckRequired(l_SaveCol, i_ServiceDW.GetText()) THEN

	   		l_ErrorStrings[1] = "PowerClass Error"
   			l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   			l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   			l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   			l_ErrorStrings[5] = "fu_Validate"

				//-----------------------------------------------------------
				// If there is a validation message on the dataobject, display
				// it rather than "Field is a required field".
				//-----------------------------------------------------------

				IF i_ColValMsg[l_SaveCol] <> '' AND NOT IsNull(i_ColValMsg[l_SaveCol]) THEN
   				l_ErrorStrings[6] = i_ColValMsg[l_SaveCol]
					FWCA.MSG.fu_DisplayMessage("ValDWError", &
                                       6, l_ErrorStrings[])
				ELSE
					FWCA.MSG.fu_DisplayMessage("RequiredField", &
                                       5, l_ErrorStrings[])
				END IF
				Error.i_FWError = c_Fatal
				GOTO Finished
			END IF
		END IF
	END IF
	i_ItemValidated = FALSE
END IF

//------------------------------------------------------------------
//  Determine if we have modifications to check.
//------------------------------------------------------------------

l_Modified = (i_ServiceDW.ModifiedCount() > 0 OR &
              i_ServiceDW.DeletedCount() > 0)
IF NOT l_Modified THEN
	IF i_HaveNew THEN
		l_Modified = (NOT i_ServiceDW.i_IgnoreNewRows)
	END IF
END IF

IF NOT l_Modified THEN
	Error.i_FWError = c_Success
	GOTO Finished
END IF

//------------------------------------------------------------------
//  There are modifications.  Before we start checking, trigger the
//  pcd_ValidateBefore event for the developer.
//------------------------------------------------------------------

i_ServiceDW.Event pcd_ValidateBefore(i_InSave)
IF Error.i_FWError <> c_Success AND Error.i_FWError <> c_ValFixed THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
ELSE
	Error.i_FWError = c_Success
END IF

//------------------------------------------------------------------
//  Do validation for each row and column in the DataWindow that
//  has been changed.
//------------------------------------------------------------------

l_Rows = i_ServiceDW.RowCount()

FOR l_Row = 1 TO l_Rows
		l_RowStatus = i_ServiceDW.GetItemStatus(l_Row, 0, Primary!)
	IF l_RowStatus = DataModified! OR l_RowStatus = NewModified! OR &
			(l_RowStatus = New! AND NOT i_ServiceDW.i_IgnoreNewRows) THEN

		//------------------------------------------------------------
		//  Check each column.
		//------------------------------------------------------------

		FOR l_Idx = 1 TO i_NumColumns
			i_ServiceDW.i_IgnoreVal = TRUE
			IF i_ServiceDW.SetColumn(l_Idx) <> -1 THEN
				l_Text = fu_GetItem(l_Row, l_Idx, Primary!, c_CurrentValues)
				l_Visible = TRUE
			ELSE
				l_Text = fu_GetItem(l_Row, l_Idx, Primary!, c_CurrentValues)
				l_Visible = FALSE
			END IF
			i_ServiceDW.i_IgnoreVal = FALSE
			l_RequiredError = fu_CheckRequired(l_Idx, l_Text)
			l_ColStatus = i_ServiceDW.GetItemStatus(l_Row, &
                    l_Idx, Primary!)
			IF l_ColStatus <> NotModified! OR l_RequiredError THEN
				Error.i_FWError = c_ValNotProcessed
				l_ValMsg = i_ColValMsg[l_Idx]
				l_Name   = i_ColName[l_Idx]
				i_InValidation = TRUE
				i_ValidateCol = l_Idx
				i_ValidateRow = l_Row

				i_ServiceDW.Event pcd_ValidateCol(i_InSave, l_Row, &
						l_Idx, l_Name, l_Text, l_ValMsg, l_RequiredError)

				i_InValidation = FALSE
				IF l_RequiredError AND Error.i_FWError = c_ValNotProcessed THEN
					l_ErrorStrings[1] = "PowerClass Error"
					l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
					l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
					l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
					l_ErrorStrings[5] = "fu_Validate"
					IF l_Visible THEN
						l_ID = "RequiredField"
					ELSE
						l_ID = "RequiredNonVisField"
					END IF

					//-----------------------------------------------------------
					// If there is a validation message on the dataobject, display
					// it rather than "Field is a required field".
					//-----------------------------------------------------------

					IF l_ValMsg <> '' AND NOT IsNull(l_ValMsg) THEN
   					l_ErrorStrings[6] = l_ValMsg
						FWCA.MSG.fu_DisplayMessage("ValDWError", &
                                          6, l_ErrorStrings[])
					ELSE
						FWCA.MSG.fu_DisplayMessage(l_ID, &
                                          5, l_ErrorStrings[])
					END IF

					Error.i_FWError = c_Fatal
					GOTO Finished
				ELSEIF Error.i_FWError = c_ValFailed THEN
					IF l_SaveRow > 0 AND i_ServiceDW.RowCount() > 1 THEN
						i_ServiceDW.ScrollToRow(l_Row)
					END IF
					Error.i_FWError = c_Fatal
					GOTO Finished
				END IF
			END IF
		NEXT

		//------------------------------------------------------------
		//  Check the row.
		//------------------------------------------------------------

		Error.i_FWError = c_Success
		IF fu_ValidateRow(l_Row) <> c_Success THEN
			l_NewSelections[1] = l_Row
			i_ServiceDW.fu_SetSelectedRows(1, l_NewSelections[], &
                  i_ServiceDW.c_IgnoreChanges, &
                  i_ServiceDW.c_NoRefreshChildren)
				Error.i_FWError = c_Fatal
			GOTO Finished
		END IF
	END IF
NEXT
					
//------------------------------------------------------------------
//  Restore the original row and column.
//------------------------------------------------------------------

IF l_SaveRow > 0 THEN
	IF l_SaveRow <> i_ServiceDW.GetRow() THEN
		i_ServiceDW.ScrollToRow(l_SaveRow)
	END IF
END IF

IF l_SaveCol > 0 THEN
	IF l_SaveCol <> i_ServiceDW.GetColumn() THEN
		i_ServiceDW.SetColumn(l_SaveCol)
	END IF
END IF

//------------------------------------------------------------------
//  After all validation, trigger the pcd_ValidateAfter event for 
//  the developer.
//------------------------------------------------------------------

i_ServiceDW.Event pcd_ValidateAfter(i_InSave)

Finished:

//------------------------------------------------------------------
//  Restore normal DataWindow operations.
//------------------------------------------------------------------

i_ServiceDW.i_IgnoreRFC = FALSE
i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError

end function

public function integer fu_validaterow (long row_nbr);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_ValidateRow
//  Description   : Trigger the row validation event for the 
//                  developer.
//
//  Parameters    : LONG Row_Nbr -
//                     Row to validate.
//
//  Return Value  : INTEGER -
//                      0 - row validation operation successful.
//                     -1 - row validation operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Make sure we have a valid row.
//------------------------------------------------------------------

IF row_nbr <= 0 OR row_nbr > i_ServiceDW.RowCount() OR &
	i_ServiceDW.i_IsEmpty THEN
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Assume no validation errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Trigger the pcd_ValidateRow event for the developer.
//------------------------------------------------------------------

i_InValidation = TRUE
i_ValidateRow  = row_nbr

i_ServiceDW.Event pcd_ValidateRow(i_InSave, row_nbr)

i_InValidation = FALSE

RETURN Error.i_FWError

end function

public function integer fu_validatecol (long row_nbr, integer col_nbr);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_ValidateCol
//  Description   : Trigger the validate column event for the
//                  developer.
//
//  Parameters    : LONG Row_Nbr    -
//                     Row number for the column to validate.
//                  INTEGER Col_Nbr -
//                     Column number for column to validate.
//
//  Return Value  : INTEGER -
//                      0 - validation OK.
//                      1 - validation failed.
//                      2 - validation fixed.
//                     -9 - validation not processed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

STRING  l_ErrorStrings[], l_Text, l_ValMsg, l_Name, l_ID
BOOLEAN l_RequiredError

//------------------------------------------------------------------
//  Check to see if we have a valid row and column number.
//------------------------------------------------------------------

IF row_nbr <= 0 OR row_nbr > i_ServiceDW.RowCount() OR &
	col_nbr <= 0 OR col_nbr > i_NumColumns OR i_ServiceDW.i_IsEmpty THEN
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Assume no validation errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Do an AcceptText() to get any text the user typed.  If 
//  AcceptText() fails, then we have a validation error that will
//  already be reported.
//------------------------------------------------------------------

IF i_ServiceDW.AcceptText() = -1 THEN
	RETURN c_ValFailed
END IF

//------------------------------------------------------------------
//  Do validation for the column in the DataWindow.
//------------------------------------------------------------------

l_Text          = fu_GetItem(row_nbr, col_nbr, Primary!, c_CurrentValues)
l_RequiredError = fu_CheckRequired(col_nbr, l_Text)
l_ValMsg        = i_ColValMsg[col_nbr]
l_Name          = i_ColName[col_nbr]
i_InValidation  = TRUE
i_ValidateCol   = col_nbr
i_ValidateRow   = row_nbr

i_ServiceDW.Event pcd_ValidateCol(i_InSave, row_nbr, col_nbr, &
	l_Name, l_Text, l_ValMsg, l_RequiredError)

IF l_RequiredError AND &
	(Error.i_FWError = c_ValOK OR &
	Error.i_FWError = c_ValNotProcessed) THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_ValidateCol"
	IF i_ColVisible[col_nbr] THEN
		l_ID = "RequiredField"
	ELSE
		l_ID = "RequiredNonVisField"
	END IF
	
	IF l_ValMsg <> '' AND NOT IsNull(l_ValMsg) THEN
		l_ErrorStrings[6] = l_ValMsg
		FWCA.MSG.fu_DisplayMessage("ValDWError", &
                                 6, l_ErrorStrings[])
	ELSE
		FWCA.MSG.fu_DisplayMessage(l_ID, &
                                 5, l_ErrorStrings[])
	END IF

	Error.i_FWError = c_ValFailed
END IF

i_InValidation = FALSE

RETURN Error.i_FWError

end function

public function integer fu_save (integer changes);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_Save
//  Description   : Save the contents of the DataWindow.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - save operation successful.
//                     -1 - save operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER      l_Answer
STRING       l_ErrorStrings[]
BOOLEAN      l_Changes, l_Exit, l_UserCancel

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is and we are not executed from within the unit of work then
//  execute the save function in the unit-of-work service.
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
	IF NOT i_InSave THEN
		IF i_ServiceDW.i_DWSRV_UOW.fu_Save(i_ServiceDW, &
         changes, i_ServiceDW.c_CheckAll) <> c_Success THEN
      	RETURN c_Fatal
		ELSE
			RETURN c_Success
		END IF
	END IF

ELSE

	i_InSave = TRUE

	//---------------------------------------------------------------
	//  If we are not in a unit-of-work, then check for changes on
	//  this DataWindow. 
	//---------------------------------------------------------------

	l_Changes = fu_CheckChanges()

	//---------------------------------------------------------------
	//  If changes were found and c_PromptChanges is given then 
	//  prompt the user for changes. 
	//---------------------------------------------------------------

	i_SaveStatus = 1
	IF l_Changes AND changes = i_ServiceDW.c_PromptChanges THEN
		l_Answer = fu_PromptChanges()
	
		IF l_Answer = 2 THEN
 
	      //-------------------------------------------------------
         //  Since the No button was clicked, we need to 
			//  reset the datawindow and indicate that we no longer
         //  have New! records.
         //-------------------------------------------------------

			fu_ResetUpdate()

			i_SaveStatus = 2
			Error.i_FWError = c_Success
			GOTO Finished
		ELSEIF l_Answer = 3 THEN
			i_SaveStatus = 3
			Error.i_FWError = c_Fatal
			GOTO Finished
		END IF
	ELSEIF NOT l_Changes THEN
		Error.i_FWError = c_Success
		GOTO Finished
	END IF

	//---------------------------------------------------------------
	//  Validate the data before saving. 
	//---------------------------------------------------------------

	IF fu_Validate() <> c_Success THEN
		Error.i_FWError = c_Fatal
		GOTO Finished
	END IF

END IF

//------------------------------------------------------------------
//  Display the save prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Save")
	END IF
END IF

//------------------------------------------------------------------
//  Trigger the pcd_SaveBefore event for the developer.
//------------------------------------------------------------------

IF NOT IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
	i_ServiceDW.Event pcd_SaveBefore(i_ServiceDW.i_DBCA)
	IF Error.i_FWError <> c_Success THEN
		Error.i_FWError = c_Fatal
		GOTO Finished
	END IF
END IF

//------------------------------------------------------------------
//  Set up a loop just in case concurrency checking is used.
//------------------------------------------------------------------

DO

   //---------------------------------------------------------------
	//  If concurrency checking is available then reset some 
	//  varaibles.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
		i_ServiceDW.i_DWSRV_CC.fu_ResetCCStatus()
		i_ServiceDW.i_DWSRV_CC.i_CCDidRollback = FALSE
	END IF

	//---------------------------------------------------------------
	//  Trigger the pcd_SetKey event for the developer to set keys.
	//---------------------------------------------------------------

	IF i_HaveNew THEN
		i_ServiceDW.Event pcd_SetKey(i_ServiceDW.i_DBCA)
		IF Error.i_FWError <> c_Success THEN
			Error.i_FWError = c_Fatal
			GOTO Finished
		END IF
	END IF

	//---------------------------------------------------------------
	//  Initialize the maximum updates flag for concurrency handling.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
		i_ServiceDW.i_DWSRV_CC.i_CCMaxNumUpdate = 0
	END IF

	//---------------------------------------------------------------
	//  Attempt the update.
	//---------------------------------------------------------------
	
	DO 

		Error.i_FWError = c_Success
		i_RetrySave = FALSE
		l_UserCancel = FALSE

		//------------------------------------------------------------
		//  If concurrency checking is available then reset some 
		//  varaibles.
		//------------------------------------------------------------

		i_CCWhichUpdate = 0
		IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
			i_ServiceDW.i_DWSRV_CC.fu_ResetCCStatus()
		END IF

		//------------------------------------------------------------
		//  Execute the event for the devloper to update the rows
		//  to the database.  By default, this event uses the
		//  PowerBuilder UPDATE function to save the changes.  If
		//  stored procedures are used or the developer wants to do
		//  their own updating, then they will need to code this
		//  event.
		//------------------------------------------------------------

		IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
			i_ServiceDW.i_DWSRV_CC.i_InUpdate = TRUE
		END IF

		i_ServiceDW.Event pcd_Update(i_ServiceDW.i_DBCA)
		
		IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
			i_ServiceDW.i_DWSRV_CC.i_InUpdate = FALSE
		END IF

		IF Error.i_FWError <> c_Success AND &
			IsValid(i_ServiceDW.i_DWSRV_CC) THEN
			
			//---------------------------------------------------------
			//  If errors are due to collisions and concurrency
			//  checking is available, then handle the error.
			//---------------------------------------------------------
			
			IF i_ServiceDW.i_DWSRV_CC.i_CCError THEN
				Error.i_FWError = i_ServiceDW.i_DWSRV_CC.fu_ProcessCCStatus()
				IF Error.i_FWError = c_Success THEN
					l_Exit = TRUE
				ELSE
					IF Error.i_FWError = c_UserCancel THEN
						l_UserCancel = TRUE
						Error.i_FWError = c_Fatal
						i_RetrySave = FALSE
						l_Exit = TRUE
					ELSE
						l_Exit = FALSE
					END IF
				END IF
			ELSE
				l_Exit = TRUE
			END IF
		ELSE
			l_Exit = TRUE
		END IF

		//---------------------------------------------------------
		//  If a multiple table update was done by the developer
		//  then restore the original update information.
		//---------------------------------------------------------
			
		IF i_CCWhichUpdate > 1 THEN
			IF i_UpdateTable <> "" THEN
				i_ServiceDW.Modify("datawindow.table.updatetable='" + &
					i_UpdateTable + "'")
				i_ServiceDW.Modify(i_UpdateSettings)
			END IF
		END IF

	LOOP UNTIL l_Exit

	//---------------------------------------------------------------
	//  If we are not going to retry the save, reset the variables 
	//  that are used to limit the maximum number of retries.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
		i_ServiceDW.i_DWSRV_CC.fu_ResetCCRetry()
	END IF

LOOP UNTIL NOT i_RetrySave

//------------------------------------------------------------------
//  If an update error occured and it is not going to be fixed
//  then rollback the update.
//------------------------------------------------------------------

IF Error.i_FWError <> c_Success THEN
	IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
		IF NOT i_ServiceDW.i_DWSRV_CC.i_CCDidRollback THEN
			i_ServiceDW.i_DWSRV_CC.i_CCDidRollback = TRUE
			i_ServiceDW.i_DWSRV_CC.fu_ResetCCStatus()
			fu_Rollback()
		END IF
	ELSE
		fu_Rollback()
	END IF

	//---------------------------------------------------------------
	//  Display the update error message.
	//---------------------------------------------------------------

   IF NOT l_UserCancel THEN
		l_ErrorStrings[1] = "PowerClass Error"
   	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   	l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   	l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   	l_ErrorStrings[5] = "pcd_Update"

		IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
			l_ErrorStrings[6] = String(i_ServiceDW.i_DWSRV_CC.i_CCErrorCode) + &
		                       " - " + i_ServiceDW.i_DWSRV_CC.i_CCErrorMessage
		ELSE
			l_ErrorStrings[6] = String(i_ServiceDW.i_DWSRV_EDIT.i_CCErrorCode) + &
		                       " - " + i_ServiceDW.i_DWSRV_EDIT.i_CCErrorMessage
		END IF

		FWCA.MSG.fu_DisplayMessage("UpdateError", &
	                              6, l_ErrorStrings[])
	END IF

	//---------------------------------------------------------------
	//  Change the focus to this DataWindow.
	//---------------------------------------------------------------

	i_ServiceDW.fu_Activate()

ELSE

	//---------------------------------------------------------------
	//  If we are not part of a unit-of-work then commit the update.
	//---------------------------------------------------------------

	IF NOT IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
		fu_Commit()
	END IF

	//---------------------------------------------------------------
	//  If all save processing is OK, clean up a few things.
	//---------------------------------------------------------------

	IF Error.i_FWError = c_Success THEN

		//------------------------------------------------------------
		//  If menu/button activation is available, set the controls.
		//------------------------------------------------------------

		IF NOT IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
			IF i_ServiceDW.i_CurrentMode = i_ServiceDW.c_NewMode THEN
				i_ServiceDW.i_CurrentMode = i_ServiceDW.c_ModifyMode
			END IF
		END IF

		IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
			IF i_ServiceDW.i_IsCurrent THEN
				i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_AllControls)
			END IF
		END IF
	
		//------------------------------------------------------------
		//  If we are not a part of a unit-of-work, then clean up.
		//------------------------------------------------------------

		IF NOT IsValid(i_ServiceDW.i_DWSRV_UOW) THEN

			//---------------------------------------------------------
			//  Trigger the pcd_SaveAfter event for the developer.
			//---------------------------------------------------------

			i_ServiceDW.Event pcd_SaveAfter(i_ServiceDW.i_DBCA)
			IF Error.i_FWError <> c_Success THEN
				Error.i_FWError = c_Fatal
				GOTO Finished
			END IF

			//---------------------------------------------------------
			//  Reset the update flags.
			//---------------------------------------------------------

			fu_ResetUpdate()

			//---------------------------------------------------------
			//  Determine if the ViewAfterSave option is set.
			//---------------------------------------------------------

			IF i_ServiceDW.i_ViewAfterSave THEN
				i_ServiceDW.fu_View()
			END IF
		END IF
	END IF

END IF

Finished:

//------------------------------------------------------------------
//  If an error occurred before the save was processed and
//  this function was not called by pcd_save, then trigger this
//  event for the developer to be consistent.
//------------------------------------------------------------------

IF NOT i_ServiceDW.i_FromEvent THEN
	i_ServiceDW.i_InProcess = TRUE
	i_ServiceDW.TriggerEvent("pcd_Save")
	i_ServiceDW.i_InProcess = FALSE
END IF

IF NOT IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
	i_InSave = FALSE
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError

end function

public function integer fu_itemerror (long row_nbr, string text);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_ItemError
//  Description   : This function is used to disable the display
//                  of the generic PowerBuilder validation error
//                  message.
//
//  Parameters    : LONG Row_Nbr    -
//                     Row number that contains the error.
//                  STRING Text -
//                     Text that contains the error.
//
//  Return Value  : INTEGER -
//                     0 - reject value and show error.
//                     1 - reject value and stay.
//                     2 - accept value and move.
//                     3 - reject value and move.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_ColNbr, l_Return
STRING  l_Title
BOOLEAN l_Required
DWITEMSTATUS l_RowStatus

i_InItemError = TRUE

//------------------------------------------------------------------
//  Trigger the ItemChanged! event to initiate the validation
//  process only if it has not already run (i_ItemValidated tells
//  if it has already been run).  ItemChanged! can be triggered
//  before this event by ACCEPTTEXT().
//------------------------------------------------------------------

IF NOT i_ItemValidated THEN

   l_ColNbr = i_ServiceDW.GetColumn()
   
	//---------------------------------------------------------------
   //  See if we are worried about required field checking every
   //  time the user moves.  If not, then see if ItemError was
   //  triggered because of a required field error.  If so, then
   //  we don't need to do any more processing for ItemError.
   //---------------------------------------------------------------

	IF NOT i_InSave AND NOT i_ServiceDW.i_AlwaysCheckRequired THEN
      IF fu_CheckRequired(l_ColNbr, text) THEN
         i_InItemError = FALSE
			RETURN c_AcceptAndMove
      END IF
   END IF

   //---------------------------------------------------------------
   //  Trigger the item change function to allow the developer
	//  to fix the validation error.
   //---------------------------------------------------------------

   l_Return = fu_ItemChanged(row_nbr, text)

   //---------------------------------------------------------------
   //  Convert ItemChanged! action codes to ItemError! action
   //  codes.
   //---------------------------------------------------------------

   CHOOSE CASE l_Return
      CASE c_ValOk

         //---------------------------------------------------------
         //  The developer told us that the value is good.
         //  Tell PowerBuilder to accept it and move.
         //---------------------------------------------------------

         l_Return = c_AcceptAndMove

      CASE c_ValFixed

         //---------------------------------------------------------
         //  The value was bad, but it was fixed using SETITEM().  
			//  Therefore, we don't want to accept the user's text over
 			//  the correction.  Just reject the user's value and move.
         //---------------------------------------------------------

         l_Return = c_RejectAndMove

      CASE c_ValFailed

         //---------------------------------------------------------
         //  The value failed validation and the developer was
         //  unable to fix it.  Reject the value and stay put.
         //---------------------------------------------------------

         l_Return = c_RejectAndStay

      CASE c_ValNotProcessed

         //---------------------------------------------------------
         //  The developer did not do any processing in the
         //  pcd_ValidateCol event.  See if ItemError! was
         //  triggered because of a required field error.  If
         //  it was, we don't want PowerBuilder to display an
         //  error message.
         //---------------------------------------------------------

         l_Required = fu_CheckRequired(l_ColNbr, text)
			l_RowStatus = i_ServiceDW.GetItemStatus(row_nbr, 0, Primary!)
			IF l_Required AND (l_RowStatus <> New! OR &
				(l_RowStatus = New! AND i_ServiceDW.i_IgnoreNewRows)) THEN
				IF l_RowStatus = New! AND i_ServiceDW.i_IgnoreNewRows THEN
					Error.i_FWError = c_ValOK
					i_InItemError = FALSE
					RETURN c_AcceptAndMove
				ELSE
					l_Return = c_RejectAndMove
				END IF
         ELSE

            //------------------------------------------------------
            //  PowerBuilder thinks something is wrong and we
            //  now know that it is not a required field error.
            //  If there is a validation error message in the
            //  DataWindow call display message to display it.
            //------------------------------------------------------

            IF Len(Trim(i_ColValMsg[l_ColNbr])) > 0 THEN
               i_InValidation = TRUE
					fu_DisplayValError("ValDevOKError", "")
					i_InValidation = FALSE
               l_Return = c_RejectAndStay
            ELSE

               //---------------------------------------------------
               //  Nothing else to do but let PowerBuilder
               //  display the message.
               //---------------------------------------------------

               l_Return = c_RejectAndShowError
            END IF
			END IF
      CASE ELSE

         //---------------------------------------------------------
         //  If we get to here, then the developer gave us back
         //  a bad validation return.
         //---------------------------------------------------------

         l_Return = c_RejectAndShowError
   END CHOOSE

   //---------------------------------------------------------------
   //  If we're going to let PowerBuilder display the error,
   //  then build the title for PowerBuilder.
   //---------------------------------------------------------------

   IF l_Return = c_RejectAndShowError THEN
      l_Title = "DataWindow.Message.Title='" + &
                FWCA.MGR.i_ApplicationName + "'"
      i_ServiceDW.Modify(l_Title)
   ELSE

      //------------------------------------------------------------
      //  The developer said that validation errors were not to
      //  be displayed, but there is an error with the data.
      //  Reject the value and don't move.
      //------------------------------------------------------------

		IF l_return <> c_RejectAndMove THEN
	      l_Return = c_RejectAndStay
		END IF
   END IF
ELSE

   //---------------------------------------------------------------
   //  If we get here, ItemChanged! has run, but Powerbuilder
   //  thinks there is is an error with the field.  Don't display
   //  the error message from Powerbuilder, but reject the value.
   //---------------------------------------------------------------

   l_Return = c_RejectAndStay
END IF

//------------------------------------------------------------------
//  Clear the validation state flag indicating that it is Ok to
//  do validation checking.
//------------------------------------------------------------------

i_ItemValidated = FALSE
i_InItemError = FALSE

RETURN l_Return
end function

public function integer fu_displayvalerror (string id);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_DisplayValError
//  Description   : Handles the display of validation errors.
//                  This form of the function displays the error
//                  message associated with the message id.
//
//  Parameters    : STRING ID -
//                     Message ID associated with the error message.
//
//  Return Value  : INTEGER -
//                     1 or 2 - The button pressed by the user.
//                       -1   - The function was not called from
//                              pcd_ValidateCol or pcd_ValidateRow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

RETURN fu_DisplayValError(id, "")


end function

public function integer fu_displayvalerror ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_DisplayValError
//  Description   : Handles the display of validation errors.
//                  This form of the function is used with the
//                  PowerObjects validation functions.  Call this
//                  function after calling the PowerObjects
//                  validation function with suppressed message
//                  display.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     1 or 2 - The button pressed by the user.
//                       -1   - The function was not called from
//                              pcd_ValidateCol or pcd_ValidateRow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

STRING l_ID

//------------------------------------------------------------------
//  Assume that the PowerObjects function was run with display
//  error message turned off.  This will cause PowerObjects to put
//  the message id for the error into OBJCA.MGR.i_Parm.Validation_ID.
//------------------------------------------------------------------

IF OBJCA.MGR.i_Parm.Validation_ID <> "" THEN
	l_ID = OBJCA.MGR.i_Parm.Validation_ID
	OBJCA.MGR.i_Parm.Validation_ID = ""
	RETURN fu_DisplayValError(l_ID, "")
END IF

end function

public subroutine fu_itemfocuschanged ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_ItemFocusChanged
//  Description   : This function is used to Reset the validation
//                  flag to indicate that the DataWindow needs to
//                  be validated.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

i_ItemValidated = FALSE
end subroutine

public function integer fu_rollback ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_Rollback
//  Description   : Rollback any updates made to the database.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - rollback operation successful.
//                     -1 - rollback operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

STRING  l_ErrorStrings[]
INTEGER l_SaveError

//------------------------------------------------------------------
//  If concurrency checking is available, indicate that it has been
//  done.
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
	i_ServiceDW.i_DWSRV_CC.i_CCDidRollback = TRUE
END IF

//------------------------------------------------------------------
//  Trigger the pcd_Rollback event for the developer. 
//------------------------------------------------------------------

l_SaveError = Error.i_FWError
Error.i_FWError = c_Success

i_ServiceDW.Event pcd_Rollback(i_ServiceDW.i_DBCA)

IF Error.i_FWError <> c_Success THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "pcd_Rollback"

	IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
		l_ErrorStrings[6] = String(i_ServiceDW.i_DWSRV_CC.i_CCErrorCode) + &
		                    " - " + i_ServiceDW.i_DWSRV_CC.i_CCErrorMessage
	ELSE
		l_ErrorStrings[6] = String(i_ServiceDW.i_DWSRV_EDIT.i_CCErrorCode) + &
		                    " - " + i_ServiceDW.i_DWSRV_EDIT.i_CCErrorMessage
	END IF

	FWCA.MSG.fu_DisplayMessage("RollbackError", &
	                           6, l_ErrorStrings[])

	RETURN Error.i_FWError
END IF

Error.i_FWError = l_SaveError

RETURN c_Success
end function

public function integer fu_commit ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_Commit
//  Description   : Commit updates to the database.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - commit operation successful.
//                     -1 - commit operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

STRING  l_ErrorStrings[]

//------------------------------------------------------------------
//  Trigger the pcd_Commit event for the developer. 
//------------------------------------------------------------------

i_ServiceDW.Event pcd_Commit(i_ServiceDW.i_DBCA)

IF Error.i_FWError <> c_Success THEN
	fu_Rollback()

   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "pcd_Commit"

	IF IsValid(i_ServiceDW.i_DWSRV_CC) THEN
		l_ErrorStrings[6] = String(i_ServiceDW.i_DWSRV_CC.i_CCErrorCode) + &
		                    " - " + i_ServiceDW.i_DWSRV_CC.i_CCErrorMessage
	ELSE
		l_ErrorStrings[6] = String(i_ServiceDW.i_DWSRV_EDIT.i_CCErrorCode) + &
		                    " - " + i_ServiceDW.i_DWSRV_EDIT.i_CCErrorMessage
	END IF

	FWCA.MSG.fu_DisplayMessage("CommitError", &
	                           6, l_ErrorStrings[])
	
END IF

RETURN Error.i_FWError
end function

public function boolean fu_checkchanges ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_CheckChanges
//  Description   : Check this DataWindow for changes.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     TRUE  - there are changes.
//                     FALSE - there are no changes.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

LONG         l_Idx, l_RowCount
DWITEMSTATUS l_RowStatus
BOOLEAN      l_Null

//------------------------------------------------------------------
//  If the DataWindow is in Query mode then take it out before
//  checking.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsQuery THEN
	i_ServiceDW.i_DWSRV_SEEK.fu_Query(i_ServiceDW.c_Off)
END IF

//------------------------------------------------------------------
//  Check for changes with the PowerBuilder modify count command.
//------------------------------------------------------------------

IF i_ServiceDW.ModifiedCount() > 0 THEN
	RETURN TRUE
END IF

//------------------------------------------------------------------
//  Check to see if an edit change occurred that has not been
//  accepted into the buffer.
//------------------------------------------------------------------

IF i_HaveModify THEN
	RETURN TRUE
END IF

//------------------------------------------------------------------
//  Check for new records that were added.
//------------------------------------------------------------------

IF i_HaveNew THEN
	l_RowCount = i_ServiceDW.RowCount()
	FOR l_Idx = l_RowCount TO 1 STEP -1
		l_RowStatus = i_ServiceDW.GetItemStatus(l_Idx, 0, Primary!)
		IF l_RowStatus = NewModified! OR &
			(l_RowStatus = New! AND NOT i_ServiceDW.i_IgnoreNewRows) THEN
			RETURN TRUE
		END IF
	NEXT
END IF

//------------------------------------------------------------------
//  Check for changes with the PowerBuilder delete count command.
//------------------------------------------------------------------

IF i_ServiceDW.i_ShareData THEN
	IF i_ServiceDW.i_ParentDW.DeletedCount() > 0 THEN
		RETURN TRUE
	END IF	
ELSE
	IF i_ServiceDW.DeletedCount() > 0 THEN
		RETURN TRUE
	END IF
END IF

RETURN FALSE

end function

public function integer fu_promptchanges ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_PromptChanges
//  Description   : There are changes and we need to find out the 
//                  user's response (save, abort, or cancel).  To do
//                  this, we highlight the DataWindow and then 
//                  display a message box asking for the user's
//  response..
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     The button pressed by the user.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

STRING l_ID, l_PromptStrings[]

//------------------------------------------------------------------
//  Make this DataWindow the active DataWindow.  This will also
//  raise the window to the top if necessary.
//------------------------------------------------------------------

i_ServiceDW.fu_Activate()

//------------------------------------------------------------------
//  Determine what type of prompt to put up.
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_CUES) THEN
   l_ID = "ChangesOneHighlight"
ELSE
	l_ID = "ChangesOne"
END IF

l_PromptStrings[1] = "PowerClass Prompt"
l_PromptStrings[2] = FWCA.MGR.i_ApplicationName
l_PromptStrings[3] = i_ServiceDW.i_Window.ClassName()
l_PromptStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
l_PromptStrings[5] = "fu_PromptChanges"

RETURN FWCA.MSG.fu_DisplayMessage(l_ID, 5, l_PromptStrings[])

end function

public function boolean fu_checkrequired (integer col_nbr, string text);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_CheckRequired
//  Description   : Determine if a column has a required field 
//                  error.
//
//  Parameters    : INTEGER Col_Nbr -
//                     Column number to determine the required
//                     attribute for.'
//                  STRING  Text -
//                     Column text to check.
//
//  Return Value  : INTEGER -
//                     TRUE  - column has a required field error.
//                     FALSE - column does not have an error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Make sure we have a valid column.
//------------------------------------------------------------------

IF col_nbr <= 0 OR col_nbr > i_NumColumns THEN
	RETURN FALSE
END IF

//------------------------------------------------------------------
//  Determine if we have a required field error.
//------------------------------------------------------------------

IF i_ColRequired[col_nbr] THEN
	IF i_ColNilIsNull[col_nbr] THEN
		IF Len(text) = 0 OR IsNull(text) <> FALSE THEN
			RETURN TRUE
		ELSE
			RETURN FALSE
		END IF
	ELSE
		IF IsNull(text) <> FALSE THEN
			RETURN TRUE
		ELSE
			IF Len(Text) = 0 THEN

				//------------------------------------------------------
				//  If a NULL value causes an ItemError call,
				//  PowerBuilder passes an empty string in the Data
				//  argument instead of a NULL value.  This means that
				//  we can't tell the difference between the user not
				//  entering anything and the user entering a value and
				//  then clearing it.  The first one causes an ItemError
				//  the second one doesn't.  To determine if the first
				//  case is a required field error we have to look at
				//  the current value stored in the buffer.
				//------------------------------------------------------

				IF i_InItemError THEN
					IF IsNull(fu_GetItem(i_ServiceDW.GetRow(), col_nbr, Primary!, c_CurrentValues)) <> FALSE THEN
						RETURN TRUE
					ELSE
						RETURN FALSE
					END IF
				ELSE
					RETURN FALSE
				END IF
			ELSE
				RETURN FALSE
			END IF
		END IF
	END IF
ELSE
	RETURN FALSE
END IF
end function

public function integer fu_setupdate (string table_name, string key_names[], string update_names[]);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_SetUpdate
//  Description   : Set the update information prior to doing an
//                  UPDATE call.  This function is typically used
//                  by the developer to do multi-table updates.
//
//  Parameters    : STRING Table_Name -
//                     Name of the table to update.
//                  STRING Key_Names[] -
//                     Array of column names that are key columns.
//                  STRING Update_Names[] -
//                     Array of column names to update.
//
//  Return Value  : INTEGER -
//                      0 - update information set successful.
//                     -1 - update information set failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

STRING  l_UpdateSettings, l_Return
INTEGER l_Idx, l_NumKeys, l_NumUpdate

l_UpdateSettings = ""

//------------------------------------------------------------------
//  Build the string for the key columns.
//------------------------------------------------------------------

l_NumKeys = UpperBound(key_names[])
FOR l_Idx = 1 TO l_NumKeys
	l_UpdateSettings = l_UpdateSettings + key_names[l_Idx] + ".key=yes~t"
NEXT

//------------------------------------------------------------------
//  Build the string for the update columns.
//------------------------------------------------------------------

l_NumUpdate = UpperBound(update_names[])
FOR l_Idx = 1 TO l_NumUpdate
	l_UpdateSettings = l_UpdateSettings + update_names[l_Idx] + ".update=yes~t"
NEXT

//------------------------------------------------------------------
//  Set the update table.
//------------------------------------------------------------------

l_Return = i_ServiceDW.Modify("datawindow.table.updatetable='" + &
              table_name + "'")
IF l_Return = "?" OR l_Return = "!" THEN
	i_ServiceDW.Modify(i_UpdateSettings)
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Reset the key and update columns to NO.
//------------------------------------------------------------------

l_Return = i_ServiceDW.Modify(i_UpdateReset)
IF l_Return = "?" OR l_Return = "!" THEN
	i_ServiceDW.Modify(i_UpdateSettings)
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Set the new update information.
//------------------------------------------------------------------

l_Return = i_ServiceDW.Modify(l_UpdateSettings)
IF l_Return = "?" OR l_Return = "!" THEN
	i_ServiceDW.Modify(i_UpdateSettings)
	RETURN c_Fatal
END IF

RETURN c_Success
end function

public function integer fu_itemchanged (long row_nbr, string text);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_ItemChanged
//  Description   : This function is used to trigger validation
//                  checking when a field has changed.
//
//  Parameters    : LONG    Row_Nbr    -
//                     Row number that contains the error.
//                  STRING  Text -
//                     Text that contains the error.
//
//  Return Value  : INTEGER -
//                     0 - validation OK.
//                     1 - validation failed.
//                     2 - validation fixed.
//                    -9 - validation not processed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_ColNbr
STRING  l_ErrorStrings[], l_Text, l_ValMsg, l_Name, l_ID
BOOLEAN l_RequiredError
DWITEMSTATUS l_RowStatus

//------------------------------------------------------------------
//  Find the current column that needs to be validated.
//------------------------------------------------------------------

l_ColNbr      = i_ServiceDW.GetColumn()

//------------------------------------------------------------------
//  This event may be triggered by child DataWindows, in which case
//  column number may be 0.  We also check row number just to be
//  safe.  Note that we are talking about child DataWindows in the
//  PowerBuilder sense, not the PowerClass sense.
//------------------------------------------------------------------

IF row_nbr = 0 OR l_ColNbr = 0 THEN
   RETURN c_AcceptAndMove
END IF

//------------------------------------------------------------------
//  Allow the developer to validate the column by calling the 
//  pcd_ValidateCol event for the developer.
//------------------------------------------------------------------

Error.i_FWError = c_ValNotProcessed

//------------------------------------------------------------------
//  Do validation for the column in the DataWindow.
//------------------------------------------------------------------

l_Text          = i_ServiceDW.GetText()
l_RequiredError = fu_CheckRequired(l_ColNbr, l_Text)
l_ValMsg        = i_ColValMsg[l_ColNbr]
l_Name          = i_ColName[l_ColNbr]
i_InValidation  = TRUE
i_ValidateCol   = l_ColNbr
i_ValidateRow   = row_nbr

i_ServiceDW.Event pcd_ValidateCol(i_InSave, row_nbr, l_ColNbr, &
	l_Name, l_Text, l_ValMsg, l_RequiredError)

IF l_RequiredError THEN
	l_RowStatus = i_ServiceDW.GetItemStatus(row_nbr, 0, Primary!)
	IF (l_RowStatus <> New! OR &
		(l_RowStatus = New! AND (NOT i_ServiceDW.i_IgnoreNewRows OR NOT i_InSave))) AND &
		(Error.i_FWError = c_ValOK OR &
		Error.i_FWError = c_ValNotProcessed) THEN
   	l_ErrorStrings[1] = "PowerClass Error"
   	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   	l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   	l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   	l_ErrorStrings[5] = "pcd_ValidateCol"

		IF i_ColVisible[l_ColNbr] THEN
			l_ID = "RequiredField"
		ELSE
			l_ID = "RequiredNonVisField"
		END IF

		//-----------------------------------------------------------
		// If there is a validation message on the dataobject, display
		// it rather than "Field is a required field".
		//-----------------------------------------------------------

		IF l_ValMsg <> '' AND NOT IsNull(l_ValMsg) THEN
			l_ErrorStrings[6] = l_ValMsg
			FWCA.MSG.fu_DisplayMessage("ValDWError", &
                                 6, l_ErrorStrings[])
		ELSE
			FWCA.MSG.fu_DisplayMessage(l_ID, &
                                 5, l_ErrorStrings[])
		END IF
		Error.i_FWError = c_ValFailed
	END IF
END IF

i_InValidation = FALSE

//------------------------------------------------------------------
//  Indictate that the DataWindow has been through validation.
//  Since ItemError! may be called immediately, i_ItemValidated
//  tells PowerClass not to re-try the validation process (which
//  would display another validation error message box).
//------------------------------------------------------------------

i_ItemValidated = TRUE

//------------------------------------------------------------------
//  If we were not triggered by ItemError and the developer did
//  not process the error, then indicate success.
//------------------------------------------------------------------

IF NOT i_InItemError THEN
	IF Error.i_FWError = c_ValNotProcessed THEN
   	Error.i_FWError = c_ValOk
	END IF
END IF

RETURN Error.i_FWError
end function

public subroutine fu_resetupdate ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_ResetUpdate
//  Description   : Reset the update flags for this DataWindow.
//
//  Parameters    : (None)
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

LONG l_Jdx, l_Rows
BOOLEAN l_FoundNew

//------------------------------------------------------------------
//  Reset the update flags.
//------------------------------------------------------------------

i_ServiceDW.ResetUpdate()

//------------------------------------------------------------------
//  Indicate that we not longer have New! records.
//------------------------------------------------------------------

l_FoundNew = FALSE
IF i_HaveNew THEN
	l_Rows = i_ServiceDW.RowCount()
	FOR l_Jdx = l_Rows TO 1 STEP -1
		IF i_ServiceDW.GetItemStatus(l_Jdx, 0, Primary!) = New! THEN
			l_FoundNew = TRUE
			EXIT
		END IF
	NEXT
END IF
IF NOT l_FoundNew THEN
	i_HaveNew    = FALSE
END IF

i_HaveModify = FALSE

end subroutine

public subroutine fu_wiredrag (string drag_columns[], integer drag_method, datawindow drop_dw);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_WireDrag
//  Description   : Wire this DataWindow to the drop DataWindow.
//
//  Parameters    : STRING     Drag_Columns -
//                     Columns in this DataWindow to get the
//                     values from.
//                  INTEGER    Drag_Method -
//                     Method to use in the drag operation.  Values
//                     are:
//                         c_CopyRows
//                         c_MoveRows
//                  DATAWINDOW Drop_DW -
//                     DataWindow to drop the records on.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_NumColumns, l_Idx

i_NumDrag = UpperBound(drag_columns[])

FOR l_Idx = 1 TO i_NumDrag
	i_DragColumns[l_Idx] = Integer(i_ServiceDW.Describe(drag_columns[l_Idx] + ".id"))
NEXT

i_DragMethod = drag_method
i_DropDW     = drop_dw

IF drop_dw = i_ServiceDW THEN
	i_DragMethod = i_ServiceDW.c_MoveRows
END IF
	

end subroutine

public subroutine fu_wiredrop (string drop_columns[]);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_WireDrop
//  Description   : Set the drop DataWindow columns.
//
//  Parameters    : STRING     Drop_Columns -
//                     Columns in this DataWindow to set the values
//                     into from the drag DataWindow.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_NumColumns, l_Idx

i_NumDrop = UpperBound(drop_columns[])

FOR l_Idx = 1 TO i_NumDrop
	i_DropColumns[l_Idx] = Integer(i_ServiceDW.Describe(drop_columns[l_Idx] + ".id"))
NEXT

end subroutine

public subroutine fu_setdragindicator (string single_row, string multiple_rows, string no_drop);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_SetDragIndicator
//  Description   : Set the drag icons for the various drag 
//                  situations.
//
//  Parameters    : STRING Single_Row -
//                     Icon for a single row drag.
//                  STRING Multiple_Rows -
//                     Icon for dragging multiple rows.
//                  STRING No_Drop -
//                     Icon to indicate that dropping is not
//                     allowed on the current control.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

IF single_row <> i_ServiceDW.c_Default THEN
	i_DragRowIcon = single_row
ELSE
	i_DragRowIcon = "dragrow.ico"
END IF

IF multiple_rows <> i_ServiceDW.c_Default THEN
	i_DragRowsIcon = multiple_rows
ELSE
	i_DragRowsIcon = "dragrows.ico"
END IF

IF no_drop <> i_ServiceDW.c_Default THEN
	i_DragNoDropIcon = no_drop
ELSE
	i_DragNoDropIcon = "dragno.ico"
END IF

end subroutine

public function integer fu_copy (long num_rows, long copy_rows[], integer changes);//******************************************************************
//  PC Module     : u_DWSRV_EDIT
//  Function      : fu_Copy
//  Description   : Copies the records in the DataWindow.
//
//  Parameters    : LONG    Num_Rows -
//                     Number of records to copy.
//                  LONG    Copy_Rows -
//                     Row numbers to copy.
//                  INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - copy operation successful.
//                     -1 - copy operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

LONG         l_RowCount, l_Idx, l_SelectedRows[], l_Jdx
REAL         l_ErrorNumbers[]
STRING       l_ErrorStrings[]
BOOLEAN      l_CopyProcessed, l_NoRows

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError   = c_Success
l_CopyProcessed = FALSE

//------------------------------------------------------------------
//  Make sure we are not is QUERY mode.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsQuery THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Make sure there are records to copy.
//------------------------------------------------------------------

l_NoRows = FALSE
IF num_rows <= 0 OR i_ServiceDW.i_IsEmpty THEN
	l_NoRows = TRUE
ELSE
	IF i_ServiceDW.RowCount() = 0 THEN
		l_NoRows = TRUE
	END IF
END IF

IF l_NoRows THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_Copy"
	FWCA.MSG.fu_DisplayMessage("ZeroToCopy", &
                              5, l_ErrorStrings[])
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Make sure this DataWindow can copy records.
//------------------------------------------------------------------

IF NOT i_ServiceDW.i_AllowCopy THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_Copy"
	FWCA.MSG.fu_DisplayMessage("CopyNotAllowed", &
                              5, l_ErrorStrings[])
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If this
//  DataWindow has children, handle the changes first before
//  copying.
//------------------------------------------------------------------

IF changes <> i_ServiceDW.c_IgnoreChanges THEN
	IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
		IF NOT i_ServiceDW.i_DWSRV_UOW.fu_FindShare(i_ServiceDW) THEN
			IF i_ServiceDW.i_DWSRV_UOW.fu_Save(i_ServiceDW, changes, &
				i_ServiceDW.c_CheckChildren) <> c_Success THEN
  				Error.i_FWError = c_Fatal
				GOTO Finished
			END IF
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Display the copy prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Copy")
	END IF
END IF

//------------------------------------------------------------------
//  Make sure no DataWindow activity happens during this process.
//------------------------------------------------------------------

i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)
i_ServiceDW.i_IgnoreRFC = TRUE
i_ServiceDW.i_IgnoreVal = TRUE

//------------------------------------------------------------------
//  Attempt to copy the rows.
//------------------------------------------------------------------

i_ServiceDW.i_InProcess = TRUE
l_RowCount = i_ServiceDW.RowCount()
l_CopyProcessed = TRUE
FOR l_Idx = 1 TO num_rows
	IF copy_rows[l_Idx] > 0 AND copy_rows[l_Idx] <= l_RowCount THEN
		
		//------------------------------------------------------------
		//  Copy the row.
		//------------------------------------------------------------

		l_SelectedRows[l_Idx] = i_ServiceDW.RowCount() + 1
		i_ServiceDW.RowsCopy(copy_rows[l_Idx], copy_rows[l_Idx], &
		                     Primary!, i_ServiceDW, l_SelectedRows[l_Idx], Primary!)
		i_HaveNew = TRUE

		//------------------------------------------------------------
		//  Set the key column values to NULL so the developer can
		//  insert them.
		//------------------------------------------------------------

		FOR l_Jdx = 1 TO i_NumColumns
			IF i_ColKey[l_Jdx] THEN
				fu_SetItem(l_SelectedRows[l_Idx], l_Jdx, "NULL")
			END IF
		NEXT

		//------------------------------------------------------------
		//  Execute the pcd_Copy event for the developer.
		//------------------------------------------------------------

		IF NOT i_ServiceDW.i_FromEvent THEN
			i_ServiceDW.TriggerEvent("pcd_Copy")
		END IF
	END IF
NEXT
i_ServiceDW.i_InProcess = FALSE

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is, reset any child DataWindows.
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
	i_ServiceDW.i_DWSRV_UOW.fu_Refresh(i_ServiceDW, &
												  i_ServiceDW.c_ResetChildren, &
												  i_ServiceDW.c_SameMode)
END IF

//------------------------------------------------------------------
//  Determine if multiple records may be selected. If this is a 
//  free-form DataWindow and select on RFC is set then make sure the
//  current row is "selected".
//------------------------------------------------------------------

IF i_ServiceDW.i_MultiSelect THEN
	i_ServiceDW.fu_SetSelectedRows(num_rows, l_SelectedRows[], &
		                            i_ServiceDW.c_IgnoreChanges, &
                                  i_ServiceDW.c_RefreshChildren)
ELSE
	i_ServiceDW.fu_SetSelectedRows(1, l_SelectedRows[], &
		                            i_ServiceDW.c_IgnoreChanges, &
                                  i_ServiceDW.c_RefreshChildren)
END IF

//------------------------------------------------------------------
//  Restore normal DataWindow activity.
//------------------------------------------------------------------

i_ServiceDW.i_IgnoreRFC = FALSE
i_ServiceDW.i_IgnoreVal = FALSE
i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)

Finished:

//------------------------------------------------------------------
//  If menu/button activation is available, set the controls.
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
	IF i_ServiceDW.i_IsCurrent THEN
  		i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_ModeControls)
	END IF
END IF

//------------------------------------------------------------------
//  If an error occurred before the copy records were processed 
//  and this function was not called by pcd_Copy, then trigger 
//  this event for the developer to be consistent.
//------------------------------------------------------------------

IF NOT l_CopyProcessed THEN
	IF NOT i_ServiceDW.i_FromEvent THEN
		i_ServiceDW.i_InProcess = TRUE
		i_ServiceDW.TriggerEvent("pcd_Copy")
		i_ServiceDW.i_InProcess = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError
end function

public function integer fu_dddwfind (long row_nbr, dwobject dwo, string text);//******************************************************************
//  PC Module     : n_DWSRV_Edit
//  Function      : fu_DDDWFind
//  Description   : This function is used to find and select a row
//                  in the DDDW that matches the entered text.
//
//  Parameters    : LONG Row_Nbr    -
//                     Row number for the column.
//                  DWOBJECT Dwo -
//                     DataWindow object.
//                  STRING Text -
//                     Text entered in the column.
//
//  Return Value  : INTEGER -
//                      0 - row found.
//                     -1 - row not found or data type not supported.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1998.  All Rights Reserved.
//******************************************************************

STRING          l_Text, l_Search1, l_Column, l_DataColumn, l_GetText
STRING          l_DisplayColumn, l_Type, l_ChildType, l_Search2
LONG            l_Row, l_TextLen
DATAWINDOWCHILD l_ChildDW

//------------------------------------------------------------------
//  Determine if the text has changed from the previous edit.
//------------------------------------------------------------------

l_Text = Upper(Left(text, i_ServiceDW.SelectedStart() - 1))
IF l_Text = i_ServiceDW.i_DDDWFindText THEN
	IF KeyDown(KeyBack!) AND Len(l_Text) > 0 THEN
		l_Text = Left(l_Text, Len(l_Text) - 1)
	END IF
END IF

//------------------------------------------------------------------
//  Find the new selection based on the new text.
//------------------------------------------------------------------

IF l_Text <> i_ServiceDW.i_DDDWFindText THEN

	l_TextLen = Len(l_Text)

	//---------------------------------------------------------------
	//  Determine the type of column.
	//---------------------------------------------------------------

	l_Type = Upper(dwo.coltype)
	IF Left(l_Type, 4) = "CHAR" THEN
		l_Type = "CHAR"
	END IF
	IF Left(l_Type, 3) = "DEC" THEN
		l_Type = "DEC"
	END IF

	//---------------------------------------------------------------
	//  Determine the type of display column.
	//---------------------------------------------------------------

	i_ServiceDW.GetChild(dwo.Name, l_ChildDW)
	l_ChildType = Upper(l_ChildDW.Describe(dwo.dddw.displaycolumn + ".coltype"))
	IF Left(l_ChildType, 4) = "CHAR" THEN
		l_ChildType = "CHAR"
	END IF
	IF Left(l_ChildType, 3) = "DEC" THEN
		l_ChildType = "DEC"
	END IF

	//---------------------------------------------------------------
	//  Set the search string based on the data type of the display
	//  column.
	//---------------------------------------------------------------

	CHOOSE CASE l_ChildType
   	CASE "NUMBER", "LONG", "ULONG", "REAL", "DEC"
			l_Search1 = "Left(Upper(String(" + dwo.dddw.displaycolumn + ")), " + String(l_TextLen) + ") = '" + l_Text + "'"
			l_Search2 = "Left(Upper(String(" + dwo.dddw.displaycolumn + ")), " + String(Len(i_ServiceDW.i_DDDWFindText)) + ") = '" + i_ServiceDW.i_DDDWFindText + "'"
		CASE "CHAR"
			l_Search1 = "Left(Upper(" + dwo.dddw.displaycolumn + "), " + String(l_TextLen) + ") = '" + l_Text + "'"
			l_Search2 = "Left(Upper(" + dwo.dddw.displaycolumn + "), " + String(Len(i_ServiceDW.i_DDDWFindText)) + ") = '" + i_ServiceDW.i_DDDWFindText + "'"
		CASE ELSE
			RETURN -1
	END CHOOSE

	//---------------------------------------------------------------
	//  Search for the row in the DDDW that matches the beginning
	//  of the text.
	//---------------------------------------------------------------

	l_Row = l_ChildDW.Find(l_Search1, 1, l_ChildDW.RowCount())

	//---------------------------------------------------------------
	//  If its not found, search for the previously selected row.
	//---------------------------------------------------------------

	IF l_Row = 0 THEN
		l_Row = l_ChildDW.Find(l_Search2, 1, l_ChildDW.RowCount())
		l_Text = i_ServiceDW.i_DDDWFindText
		l_TextLen = Len(l_Text)
	END IF

	//---------------------------------------------------------------
	//  Select the row in the DDDW based on the data type.
	//---------------------------------------------------------------

	IF l_Row > 0 THEN
		l_DataColumn = dwo.dddw.datacolumn
		l_DisplayColumn = dwo.dddw.displaycolumn
		l_Column = dwo.Name

		IF l_Type = "CHAR" THEN
			i_ServiceDW.SetItem(row_nbr, l_Column, l_ChildDW.GetItemString(l_Row, l_DataColumn))
			IF l_ChildType = "CHAR" THEN
				l_GetText = l_ChildDW.GetItemString(l_Row, l_DisplayColumn)
			ELSE
				l_GetText = String(l_ChildDW.GetItemNumber(l_Row, l_DisplayColumn))
			END IF
   	ELSE
			i_ServiceDW.SetItem(row_nbr, l_Column, l_ChildDW.GetItemNumber(l_Row, l_DataColumn))
			IF l_ChildType = "CHAR" THEN
				l_GetText = l_ChildDW.GetItemString(l_Row, l_DisplayColumn)
			ELSE
				l_GetText = String(l_ChildDW.GetItemNumber(l_Row, l_DisplayColumn))
			END IF
		END IF

		i_ServiceDW.SelectText(l_TextLen + 1, Len(l_GetText) - l_TextLen)
		i_ServiceDW.i_DDDWFindText = l_Text
	ELSE
		i_ServiceDW.i_DDDWFindText = ""
		RETURN -1
	END IF
END IF

RETURN 0
end function

public function integer fu_dddwsearch (long row_nbr, dwobject dwo, string text);//******************************************************************
//  PC Module     : n_DWSRV_Edit
//  Function      : fu_DDDWSearch
//  Description   : This function is used to find and select a row
//                  in the DDDW that matches the entered text.  This
//                  is used in cases where the DDDW has a large number
//						  rows ( > 500 ).
//
//  Parameters    : LONG Row_Nbr    -
//                     Row number for the column.
//                  DWOBJECT Dwo -
//                     DataWindow object.
//                  STRING Text -
//                     Text entered in the column.
//
//  Return Value  : INTEGER -
//                      0 - row found.
//                     -1 - row not found or data type not supported.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  12/3/99  M. Caruso  Created.
//******************************************************************
//  Copyright ServerLogic 1992-1998.  All Rights Reserved.
//******************************************************************

STRING          l_Text, l_Search1, l_Column, l_DataColumn, l_GetText
STRING          l_DisplayColumn, l_Type, l_ChildType, l_Search2, l_cNullArg
LONG            l_Row, l_TextLen
DATAWINDOWCHILD l_ChildDW

SetNull (l_cNullArg)

//------------------------------------------------------------------
//  Determine if the text has changed from the previous edit.
//------------------------------------------------------------------

l_Text = Left(text, i_ServiceDW.SelectedStart() - 1)
IF l_Text = i_ServiceDW.i_DDDWFindText THEN
	IF KeyDown(KeyBack!) AND Len(l_Text) > 0 THEN
		l_Text = Left(l_Text, Len(l_Text) - 1)
	END IF
END IF

//------------------------------------------------------------------
//  Find the new selection based on the new text.
//------------------------------------------------------------------

IF Upper (l_Text) <> Upper (i_ServiceDW.i_DDDWFindText) THEN

	l_TextLen = Len(l_Text)

	//---------------------------------------------------------------
	//  Determine the type of column.
	//---------------------------------------------------------------

	l_Type = Upper(dwo.coltype)
	IF Left(l_Type, 4) = "CHAR" THEN
		l_Type = "CHAR"
	END IF
	IF Left(l_Type, 3) = "DEC" THEN
		l_Type = "DEC"
	END IF

	//---------------------------------------------------------------
	//  Determine the type of display column.
	//---------------------------------------------------------------

	i_ServiceDW.GetChild(dwo.Name, l_ChildDW)
	l_ChildType = Upper(l_ChildDW.Describe(dwo.dddw.displaycolumn + ".coltype"))
	IF Left(l_ChildType, 4) = "CHAR" THEN
		l_ChildType = "CHAR"
	END IF
	IF Left(l_ChildType, 3) = "DEC" THEN
		l_ChildType = "DEC"
	END IF

	//---------------------------------------------------------------
	//  Set the search string based on the data type of the display
	//  column.
	//---------------------------------------------------------------

	CHOOSE CASE l_ChildType
   	CASE "NUMBER", "LONG", "ULONG", "REAL", "DEC"
			l_Search1 = l_Text + '%'
			l_Search2 = i_ServiceDW.i_DDDWFindText + '%'
		CASE "CHAR"
			l_Search1 = l_Text + '%'
			l_Search2 = i_ServiceDW.i_DDDWFindText + '%'
		CASE ELSE
			RETURN -1
	END CHOOSE

	//---------------------------------------------------------------
	//  Search for the row in the DDDW that matches the beginning
	//  of the text.
	//---------------------------------------------------------------

	IF l_ChildDW.Retrieve(l_Search1, l_cNullArg) > 0 THEN
		l_Row = 2
	ELSE
		l_Row = 0
	END IF

	//---------------------------------------------------------------
	//  If its not found, search for the previously selected row.
	//---------------------------------------------------------------

	IF l_Row = 0 THEN
		IF l_ChildDW.Retrieve(l_Search2, l_cNullArg) > 0 THEN
			l_Row = 2
		ELSE
			l_Row = 0
		END IF
		l_Text = i_ServiceDW.i_DDDWFindText
		l_TextLen = Len(l_Text)
	END IF

	// prepare to set the default row
	l_DataColumn = dwo.dddw.datacolumn
	l_DisplayColumn = dwo.dddw.displaycolumn
	l_Column = dwo.Name
	
	// insert blank row so that the user can always choose "None"
	l_ChildDW.InsertRow (1)
	l_ChildDW.SetItem (1, l_DataColumn, '')
	l_ChildDW.SetItem (1, l_DisplayColumn, '(None)')
	
	//---------------------------------------------------------------
	//  Select the row in the DDDW based on the data type.
	//---------------------------------------------------------------
	IF l_Row > 0 THEN
		
		IF l_Type = "CHAR" THEN
			i_ServiceDW.SetItem(row_nbr, l_Column, l_ChildDW.GetItemString(l_Row, l_DataColumn))
			IF l_ChildType = "CHAR" THEN
				l_GetText = l_ChildDW.GetItemString(l_Row, l_DisplayColumn)
			ELSE
				l_GetText = String(l_ChildDW.GetItemNumber(l_Row, l_DisplayColumn))
			END IF
   	ELSE
			i_ServiceDW.SetItem(row_nbr, l_Column, l_ChildDW.GetItemNumber(l_Row, l_DataColumn))
			IF l_ChildType = "CHAR" THEN
				l_GetText = l_ChildDW.GetItemString(l_Row, l_DisplayColumn)
			ELSE
				l_GetText = String(l_ChildDW.GetItemNumber(l_Row, l_DisplayColumn))
			END IF
		END IF

		i_ServiceDW.SelectText(l_TextLen + 1, Len(l_GetText) - l_TextLen)
		i_ServiceDW.i_DDDWFindText = l_Text
	ELSE
		// set the first item in the list as current
		IF l_Type = "CHAR" THEN
			i_ServiceDW.SetItem(row_nbr, l_Column, l_ChildDW.GetItemString(1, l_DataColumn))
		ELSE
			i_ServiceDW.SetItem(row_nbr, l_Column, l_ChildDW.GetItemNumber(1, l_DataColumn))
		END IF

		i_ServiceDW.SelectText(1, Len (i_ServiceDW.GetText ()))
		i_ServiceDW.i_DDDWFindText = ""
		RETURN -1
	END IF
END IF

RETURN 0
end function

public function integer fu_dragwithin (dragobject drag_dw, long row_nbr);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_DragWithin
//  Description   : Process the dragwithin operation.
//
//  Parameters    : DRAGOBJECT Drag_DW -
//                     DataWindow that started the drag operation.
//                  INTEGER    Row_Nbr -
//                     Row number where the drag is current.
//
//  Return Value  : INTEGER -
//                      0 - dragwithin operation successful.
//                     -1 - dragwithin operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/10/2000 K. Claver  Added code to check the type of the drag 
//								  object passed to the function as the code
//								  doesn't account for a drag object of type
//								  treeview
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_DragDW

IF i_InDrag AND drag_dw.TypeOf( ) <> TreeView! THEN

	Error.i_FWError = c_Success

	//---------------------------------------------------------------
	//  Set the drag DataWindow.
	//---------------------------------------------------------------

	l_DragDW = drag_dw

	//---------------------------------------------------------------
	//  Determine if we are in a drag or drop DataWindow.
	//---------------------------------------------------------------

	IF (l_DragDW = i_ServiceDW AND &
		l_DragDW.i_DWSRV_EDIT.i_DropDW = i_ServiceDW) OR & 
		(l_DragDW = i_ServiceDW AND i_DropDW = i_ServiceDW) THEN

		//------------------------------------------------------------
		//  If the cursor is on the last row of the DataWindow, scroll
		//  to the next row.
		//------------------------------------------------------------

		IF Long(i_ServiceDW.Describe("datawindow.lastrowonpage")) = row_nbr THEN

			i_ServiceDW.ScrollNextRow()

		//------------------------------------------------------------
		//  If the cursor is on the first row of the DataWindow, scroll
		//  to the prior row.
		//------------------------------------------------------------

		ELSEIF Long(i_ServiceDW.Describe("datawindow.firstrowonpage")) = row_nbr THEN

			i_ServiceDW.ScrollPriorRow()

		END IF

	END IF
END IF

RETURN c_Success
end function

public function integer fu_drop (dragobject drag_dw, long row_nbr);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_Drop
//  Description   : Process the drop operation.
//
//  Parameters    : DRAGOBJECT Drag_DW -
//                     DataWindow that started the drag operation.
//                  INTEGER    Row_Nbr -
//                     Row number where the drop occurred.
//
//  Return Value  : INTEGER -
//                      0 - drop operation successful.
//                     -1 - drop operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/10/2000 K. Claver  Added code to check the type of the drag 
//								  object passed to the function as the code
//								  doesn't account for a drag object of type
//								  treeview
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

LONG      l_Idx, l_Jdx, l_SelectedRows[], l_DropRow, l_Row
LONG		 l_CurrentRow
INTEGER   l_DropColumns[]
U_DW_MAIN l_DragDW

IF i_InDrag AND drag_dw.TypeOf( ) <> TreeView! THEN

	Error.i_FWError = c_Success

	//---------------------------------------------------------------
	//  Set the drag DataWindow.
	//---------------------------------------------------------------

	l_DragDW = drag_dw
	
	l_CurrentRow = row_nbr
	
	//---------------------------------------------------------------
	// Reset the current row to 1 if there are no rows or the user
	// drops below the current row.
	//---------------------------------------------------------------
	
	IF row_nbr = 0 THEN
		l_CurrentRow = i_ServiceDW.RowCount()
		
	END IF
		
	//---------------------------------------------------------------
	//  Handle the drop process when the drag and drop DataWindows
	//  are not the same.
	//---------------------------------------------------------------

	IF l_DragDW <> i_ServiceDW AND &
		l_DragDW.i_DWSRV_EDIT.i_DropDW = i_ServiceDW THEN

		//------------------------------------------------------------
		//  Validate each row.
		//------------------------------------------------------------

		l_Row = l_CurrentRow

		FOR l_Idx = 1 TO l_DragDW.i_NumSelected
			//---------------------------------------------------------
			//  Determine the new row.
			//---------------------------------------------------------

			IF l_Row = i_ServiceDW.RowCount() THEN
				l_Row = i_ServiceDW.RowCount() + 1
			ELSE
				l_Row = l_Row + 1
			END IF

			//---------------------------------------------------------
			//  Validate the row.
			//---------------------------------------------------------

			i_ServiceDW.Event pcd_ValidateDrop(l_DragDW, &
			                                   l_DragDW.i_SelectedRows[l_Idx], &
			                                   l_Row)

			IF Error.i_FWError = c_Fatal THEN
				i_InDrag = FALSE
				l_DragDW.i_DWSRV_EDIT.i_InDrag = FALSE
				i_ServiceDW.Drag(End!)
				l_DragDW.SetFocus()
				RETURN c_Fatal
			END IF

		NEXT

		//------------------------------------------------------------
		//  Copy the values from the drag DataWindow to the drop
		//  DataWindow.
		//------------------------------------------------------------

		l_Row = l_CurrentRow

		FOR l_Idx = 1 TO l_DragDW.i_NumSelected

			//---------------------------------------------------------
			//  Insert the new row.
			//---------------------------------------------------------

			IF l_Row = i_ServiceDW.RowCount() THEN
				l_Row = i_ServiceDW.RowCount() + 1
				fu_New(0, 1)
			ELSE
				l_Row = l_Row + 1
				fu_New(l_Row, 1)
			END IF

			//---------------------------------------------------------
			//  Set the values.
			//---------------------------------------------------------

			FOR l_Jdx = 1 TO i_NumDrop
				fu_SetItem(l_Row, i_DropColumns[l_Jdx], &
			              l_DragDW.i_DWSRV_EDIT.fu_GetItem( &
			              l_DragDW.i_SelectedRows[l_Idx], &
			              l_DragDW.i_DWSRV_EDIT.i_DragColumns[l_Jdx], &
			              Primary!, c_CurrentValues))
			NEXT

			l_SelectedRows[l_Idx] = l_Row
		NEXT
		
		//------------------------------------------------------------
		//  Set the new rows to be the selected rows.
		//------------------------------------------------------------

		IF i_ServiceDW.i_MultiSelect THEN
			i_ServiceDW.fu_SetSelectedRows(l_DragDW.i_NumSelected, &
	                                     l_SelectedRows[], &
	                                     i_ServiceDW.c_IgnoreChanges, &
	                                     i_ServiceDW.c_NoRefreshChildren)
		ELSE
			i_ServiceDW.fu_SetSelectedRows(1, &
	                                     l_SelectedRows[], &
	                                     i_ServiceDW.c_IgnoreChanges, &
	                                     i_ServiceDW.c_NoRefreshChildren)
		END IF

		//------------------------------------------------------------
		//  If the rows are copied then clear the selected rows in the
		//  drag DataWindow.  If the rows are moved, delete the rows
		//  from the drag DataWindow.
		//------------------------------------------------------------

		IF l_DragDW.i_DWSRV_EDIT.i_DragMethod = i_ServiceDW.c_CopyRows THEN
			l_DragDW.fu_ClearSelectedRows(i_ServiceDW.c_IgnoreChanges)
		ELSE
			l_DragDW.fu_Delete(l_DragDW.i_NumSelected, &
	                         l_DragDW.i_SelectedRows[], &
	                         i_ServiceDW.c_IgnoreChanges)
		END IF
		
		//------------------------------------------------------------
		//  Turn off drag mode and set focus to the drop DataWindow.
		//------------------------------------------------------------

		i_InDrag = FALSE
		l_DragDW.i_DWSRV_EDIT.i_InDrag = FALSE
		i_ServiceDW.Drag(End!)
		i_ServiceDW.SetFocus()

	//---------------------------------------------------------------
	//  Handle the drop process when the drag and drop DataWindows
	//  are the same.
	//---------------------------------------------------------------

	ELSEIF l_DragDW = i_ServiceDW AND i_DropDW = i_ServiceDW THEN

		//------------------------------------------------------------
		//  Validate each row.
		//------------------------------------------------------------

		l_DropRow = l_CurrentRow

		FOR l_Idx = i_ServiceDW.i_NumSelected TO 1 STEP -1
			l_Row = i_ServiceDW.i_SelectedRows[l_Idx]

			//---------------------------------------------------------
			//  Validate the row.
			//---------------------------------------------------------

			i_ServiceDW.Event pcd_ValidateDrop(l_DragDW, &
			                                   l_DragDW.i_SelectedRows[l_Idx], &
			                                   l_DropRow)

			IF Error.i_FWError = c_Fatal THEN
				i_InDrag = FALSE
				l_DragDW.i_DWSRV_EDIT.i_InDrag = FALSE
				i_ServiceDW.Drag(End!)
				l_DragDW.SetFocus()
				RETURN c_Fatal
			END IF

			//---------------------------------------------------------
			//  Adjust the selected and dropped row if necessary.
			//---------------------------------------------------------

			IF l_Row < l_DropRow THEN
				l_DropRow = l_DropRow - 1
				FOR l_Jdx = l_Idx - 1 TO 1 STEP -1
					IF i_ServiceDW.i_SelectedRows[l_Idx] > l_Row AND &
						i_ServiceDW.i_SelectedRows[l_Idx] < l_DropRow THEN
						i_ServiceDW.i_SelectedRows[l_Idx] = i_ServiceDW.i_SelectedRows[l_Idx] - 1
					END IF
				NEXT
			END IF
		NEXT

		//------------------------------------------------------------
		//  Move the selected rows to below the drop row.
		//------------------------------------------------------------

		l_DropRow = l_CurrentRow
		FOR l_Idx = i_ServiceDW.i_NumSelected To 1 STEP -1
			l_Row = i_ServiceDW.i_SelectedRows[l_Idx]
			i_ServiceDW.RowsMove(l_Row, l_Row, Primary!, i_ServiceDW, l_DropRow + 1, Primary!)
			IF l_Row < l_DropRow THEN
				l_DropRow = l_DropRow - 1
				FOR l_Jdx = l_Idx - 1 TO 1 STEP -1
					IF i_ServiceDW.i_SelectedRows[l_Idx] > l_Row AND &
						i_ServiceDW.i_SelectedRows[l_Idx] < l_DropRow THEN
						i_ServiceDW.i_SelectedRows[l_Idx] = i_ServiceDW.i_SelectedRows[l_Idx] - 1
					END IF
				NEXT
			END IF
		NEXT

		//------------------------------------------------------------
		//  Set the selected rows array.
		//------------------------------------------------------------

		l_Row = l_CurrentRow
		FOR l_Idx = 1 TO i_ServiceDW.i_NumSelected
			l_Row = l_Row + 1
			i_ServiceDW.i_SelectedRows[l_Idx] = l_Row
		NEXT

		//------------------------------------------------------------
		//  Turn off drag mode.
		//------------------------------------------------------------

		i_InDrag = FALSE
		l_DragDW.i_DWSRV_EDIT.i_InDrag = FALSE
		i_ServiceDW.Drag(End!)
	ELSE
		RETURN c_Fatal
	END IF
ELSE
	RETURN c_Fatal
END IF

RETURN c_Success
end function

public function integer fu_delete (long num_rows, long delete_rows[], integer changes);//******************************************************************
//  PC Module     : u_DWSRV_EDIT
//  Function      : fu_Delete
//  Description   : Deletes records from the DataWindow.
//
//  Parameters    : LONG    Num_Rows -
//                     Number of records to delete.
//                  LONG    Delete_Rows -
//                     Row numbers to delete.
//                  INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//
//  Return Value  : INTEGER -
//                      0 - delete operation successful.
//                     -1 - delete operation failed or was cancelled.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  11/5/98	 Beth Byers	Test if the Deleted Count > 0 when checking
//								if the datawindow has been modified
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

LONG         l_RowCount, l_Idx, l_Row[]
INTEGER      l_Answer, l_NumChildren
REAL         l_ErrorNumbers[]
DWITEMSTATUS l_RowStatus
STRING       l_ErrorStrings[], l_Prompt
BOOLEAN      l_NoRows, l_DeleteOK, l_AskOK, l_Modified
BOOLEAN      l_DeleteProcessed, l_Found, l_ShareDW[]
BOOLEAN		 l_DeleteSavedOK
LONG         l_DeleteNewModifiedCount = 0
LONG         l_NewModifiedCount = 0
LONG         l_NextModifiedRow = 0
U_DW_MAIN    l_ChildrenDW[]

//------------------------------------------------------------------
//  Gather information on the status of the rows to be deleted and for
//  the datawindow in general
//------------------------------------------------------------------

FOR l_Idx = 1 TO Num_Rows
	l_RowStatus = i_ServiceDW.GetItemStatus(delete_rows[l_Idx], 0, Primary!)
	IF l_RowStatus = NewModified! THEN
		l_DeleteNewModifiedCount++
	END IF
NEXT

l_RowCount = i_ServiceDW.RowCount()

DO
	l_NextModifiedRow = i_ServiceDW.GetNextModified(l_NextModifiedRow, Primary!)
	IF l_NextModifiedRow > 0 THEN
		l_RowStatus = i_ServiceDW.GetItemStatus(l_NextModifiedRow, 0, Primary!)
		IF l_RowStatus = NewModified! THEN
			l_NewModifiedCount++
		END IF	
	END IF
LOOP UNTIL l_NextModifiedRow = 0

//------------------------------------------------------------------
//  Assume no errors.
//------------------------------------------------------------------

Error.i_FWError   = c_Success
l_DeleteProcessed = FALSE

//------------------------------------------------------------------
//  Make sure we are not is QUERY mode.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsQuery THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Make sure there are records to delete.
//------------------------------------------------------------------

l_NoRows = FALSE
IF num_rows <= 0 OR i_ServiceDW.i_IsEmpty THEN
	l_NoRows = TRUE
ELSE
	IF i_ServiceDW.RowCount() = 0 THEN
		l_NoRows = TRUE
	END IF
END IF

IF l_NoRows THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_Delete"
	FWCA.MSG.fu_DisplayMessage("ZeroToDelete", &
                              5, l_ErrorStrings[])
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Make sure this DataWindow can delete records.
//------------------------------------------------------------------

l_DeleteOK = i_ServiceDW.i_AllowDelete
l_DeleteSavedOK = i_ServiceDW.i_AllowDeleteSaved
IF i_ServiceDW.i_FromEvent THEN
	l_AskOK    = TRUE
ELSE
	l_AskOK    = FALSE
END IF

IF (i_HaveNew) OR &
	(i_ServiceDW.i_AllowDrag AND i_DragMethod = i_ServiceDW.c_MoveRows) THEN
 	l_DeleteOK = TRUE
	
	//---------------------------------------------------------------
	//  Determine if we need to prompt the user to delete the
	//  records.  If New! records have not been modified then we 
	//  won't ask the user about them.
	//---------------------------------------------------------------

	IF Len(i_ServiceDW.GetText()) = 0 OR &
		i_ServiceDW.Describe(i_ServiceDW.GetColumnName() + ".Initial") = &
		i_ServiceDW.GetText() THEN
		l_AskOK = FALSE
		FOR l_Idx = 1 TO num_rows
			l_RowStatus = i_ServiceDW.GetItemStatus(delete_rows[l_Idx], 0, Primary!)
			IF l_RowStatus <> New! THEN
				l_AskOK = TRUE
				EXIT
			END IF
		NEXT
	END IF
END IF

IF NOT l_DeleteOK THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_Delete"
	FWCA.MSG.fu_DisplayMessage("DeleteNotAllowed", &
                              5, l_ErrorStrings[])
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If this
//  DataWindow has children, handle the changes first before
//  deleting.
//------------------------------------------------------------------

IF changes <> i_ServiceDW.c_IgnoreChanges THEN
	IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
		IF NOT i_ServiceDW.i_DWSRV_UOW.fu_FindShare(i_ServiceDW) THEN

			//--------------------------------------------------------
			// If this DW's row is NEW then do not check the children,
			// just delete it.
			//--------------------------------------------------------

			l_RowStatus = i_ServiceDW.GetItemStatus(i_ServiceDW.i_CursorRow, 0, Primary!)
			IF l_RowStatus <> NewModified! AND l_RowStatus <> New! THEN
				IF i_ServiceDW.i_DWSRV_UOW.fu_Save(i_ServiceDW, changes, &
					i_ServiceDW.c_CheckChildren) <> c_Success THEN
  					Error.i_FWError = c_Fatal
					GOTO Finished
				END IF
			END IF
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Verify with the user that it is OK to delete.
//------------------------------------------------------------------

IF l_AskOK AND NOT i_InDrag THEN
	IF num_rows > 1 THEN
		l_Prompt = "DeleteOk"
	ELSE
		l_Prompt = "DeleteOkOne"
	END IF

	l_ErrorNumbers[1] = num_rows
   l_ErrorStrings[1] = "PowerClass Prompt"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_Delete"
	l_Answer = FWCA.MSG.fu_DisplayMessage(l_Prompt, &
													  1, l_ErrorNumbers[], &
                                         5, l_ErrorStrings[])
ELSE
	l_Answer = 0
END IF

//------------------------------------------------------------------
//  If the answer is 0 then we have a pure New! row.  If it is 1,
//  then the user indicated the row(s) should be deleted.  
//  Otherwise, the user doesn't want to delete the rows.
//------------------------------------------------------------------

IF l_Answer <> 0 AND l_Answer <> 1 THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Display the delete prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Delete")
	END IF
END IF

//------------------------------------------------------------------
//  Make sure no DataWindow activity happens during this process.
//------------------------------------------------------------------

i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)
i_ServiceDW.i_IgnoreRFC = TRUE
i_ServiceDW.i_IgnoreVal = TRUE

//------------------------------------------------------------------
//  If this DataWindow has children that share with it, set ignore
//  RFC and VAL because DeleteRow will cause an RFC on a shared
//  child.  
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
	IF i_ServiceDW.i_ShareData THEN
		l_NumChildren = i_ServiceDW.i_DWSRV_UOW.fu_GetChildren(i_ServiceDW.i_ParentDW, l_ChildrenDW[], l_ShareDW[])
		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].i_IgnoreRFC = TRUE
				l_ChildrenDW[l_Idx].i_IgnoreVal = TRUE
			END IF
		NEXT
		i_ServiceDW.i_ParentDW.i_IgnoreRFC = TRUE
		i_ServiceDW.i_ParentDW.i_IgnoreVAL = TRUE
	ELSE
		l_NumChildren = i_ServiceDW.i_DWSRV_UOW.fu_GetChildren(i_ServiceDW, l_ChildrenDW[], l_ShareDW[])
		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].i_IgnoreRFC = TRUE
				l_ChildrenDW[l_Idx].i_IgnoreVal = TRUE
			END IF
		NEXT
	END IF
END IF

//------------------------------------------------------------------
//  Attempt to delete the rows.
//------------------------------------------------------------------

i_ServiceDW.i_InProcess = TRUE
l_Modified = FALSE
l_RowCount = i_ServiceDW.RowCount()
l_DeleteProcessed = TRUE

FOR l_Idx = num_rows TO 1 STEP -1
	IF delete_rows[l_Idx] > 0 AND delete_rows[l_Idx] <= l_RowCount THEN

		//------------------------------------------------------------
		//  If this row is not a New! row then indicate that this 
		//  DataWindow has been modified.   Also check if the datawindow
		//	 has been modified, or any rows deleted.
		//------------------------------------------------------------

		IF i_ServiceDW.GetNextModified(0, Primary!) > 0 THEN
			l_Modified = TRUE
		ELSEIF i_ServiceDW.DeletedCount() > 0 then
			l_Modified = TRUE
		ELSE
			l_RowStatus = i_ServiceDW.GetItemStatus(delete_rows[l_Idx], 0, Primary!)
			IF l_RowStatus <> New! THEN
				l_Modified = TRUE
			END IF
		END IF

		//------------------------------------------------------------
		//  Check if can delete saved rows.  If so and is a saved row, 
		//    delete the row.  Otherwise don't.
		//------------------------------------------------------------
		IF NOT l_DeleteSavedOK THEN
			l_RowStatus = i_ServiceDW.GetItemStatus(delete_rows[l_Idx], 0, Primary!)

			IF l_RowStatus <> NotModified! AND l_RowStatus <> DataModified! THEN
				i_ServiceDW.DeleteRow(delete_rows[l_Idx])
			END IF
		ELSE
			i_ServiceDW.DeleteRow(delete_rows[l_Idx])
		END IF
		i_ServiceDW.i_NumSelected = i_ServiceDW.i_NumSelected - 1

		//------------------------------------------------------------
		//  Determine the new cursor row.
		//------------------------------------------------------------

		IF i_ServiceDW.i_CursorRow > delete_rows[l_Idx] THEN
			i_ServiceDW.i_CursorRow = i_ServiceDW.i_CursorRow - 1
		END IF

		IF i_ServiceDW.i_AnchorRow > delete_rows[l_Idx] THEN
			i_ServiceDW.i_AnchorRow = i_ServiceDW.i_AnchorRow - 1
		ELSE
			IF i_ServiceDW.i_AnchorRow = delete_rows[l_Idx] THEN
				i_ServiceDW.i_AnchorRow = 0
			END IF
		END IF

		//------------------------------------------------------------
		//  Execute the pcd_Delete event for the developer.
		//------------------------------------------------------------

		IF NOT i_ServiceDW.i_FromEvent AND NOT i_InDrag THEN
			i_ServiceDW.TriggerEvent("pcd_Delete")
		END IF
	END IF
NEXT
i_ServiceDW.i_InProcess = FALSE

IF i_ServiceDW.i_CursorRow > i_ServiceDW.RowCount() THEN
	i_ServiceDW.i_CursorRow = i_ServiceDW.RowCount()
	i_ServiceDW.i_AnchorRow = 0
END IF

//------------------------------------------------------------------
//  If this DataWindow has children that share with it, set ignore
//  RFC and VAL back.  
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
	IF i_ServiceDW.i_ShareData THEN
		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].i_IgnoreRFC = FALSE
				l_ChildrenDW[l_Idx].i_IgnoreVal = FALSE
			END IF
		NEXT
		i_ServiceDW.i_ParentDW.i_IgnoreRFC = FALSE
		i_ServiceDW.i_ParentDW.i_IgnoreVAL = FALSE
	ELSE
		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].i_IgnoreRFC = FALSE
				l_ChildrenDW[l_Idx].i_IgnoreVal = FALSE
			END IF
		NEXT
	END IF
END IF

//------------------------------------------------------------------
//  If the delete did not modify the DataWindow then reset the
//  DataWindow's update flags.
//------------------------------------------------------------------

IF Error.i_FWError = c_Success AND NOT l_Modified THEN
	i_ServiceDW.ResetUpdate()
END IF
	
//------------------------------------------------------------------
//  Determine if this DataWindow is part of a unit-of-work.  If it
//  is, reset any child DataWindows.
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
	i_ServiceDW.i_DWSRV_UOW.fu_Refresh(i_ServiceDW, &
												  i_ServiceDW.c_ResetChildren, &
												  i_ServiceDW.c_SameMode)
END IF

//------------------------------------------------------------------
//  If no records are left in the DataWindow then put in an empty
//  row.  If this is a free-form DataWindow and select on RFC
//  is set then make sure the current row is "selected".
//------------------------------------------------------------------

IF i_ServiceDW.RowCount() = 0 AND i_ServiceDW.i_ShowEmpty THEN
//	i_ServiceDW.fu_SetEmpty()
ELSE
	IF i_ServiceDW.i_ShareData THEN
		IF i_ServiceDW.i_ParentDW.i_SelectMethod = i_ServiceDW.c_SelectOnRowFocusChange THEN
			l_Row[1] = i_ServiceDW.i_CursorRow
			i_ServiceDW.i_ParentDW.fu_SetSelectedRows(1, l_Row[], &
		                                  i_ServiceDW.c_IgnoreChanges, &
                                        i_ServiceDW.c_RefreshChildren)
		END IF
	ELSE
		IF i_ServiceDW.i_SelectMethod = i_ServiceDW.c_SelectOnRowFocusChange THEN
			l_Row[1] = i_ServiceDW.i_CursorRow
			i_ServiceDW.fu_SetSelectedRows(1, l_Row[], &
		                                  i_ServiceDW.c_IgnoreChanges, &
                                        i_ServiceDW.c_RefreshChildren)
		END IF
	END IF 
END IF

//------------------------------------------------------------------
//  Determine if we have any New! records left.  If not, reset
//  i_HaveNew flag.
//------------------------------------------------------------------

l_RowCount = i_ServiceDW.RowCount()
IF l_RowCount > 0 AND NOT i_ServiceDW.i_IsEmpty THEN
	l_Found = FALSE
	FOR l_Idx = 1 TO l_RowCount
		l_RowStatus = i_ServiceDW.GetItemStatus(l_Idx, 0, Primary!)
		IF l_RowStatus = New! OR l_RowStatus = NewModified! THEN
			l_Found = TRUE
			EXIT
		END IF
	NEXT
	IF NOT l_Found THEN
		i_HaveNew = FALSE

		//------------------------------------------------------------
		// Change to either ModifyMode or ViewMode depending on the
		// capabilities of the datawindow AND if we were previously
		// in new mode.
		//------------------------------------------------------------

		IF i_ServiceDW.i_AllowModify AND &
			i_ServiceDW.i_CurrentMode = i_ServiceDW.c_NewMode THEN
			i_ServiceDW.i_CurrentMode = i_ServiceDW.c_ModifyMode
		ELSE
			i_ServiceDW.i_CurrentMode = i_ServiceDW.c_ViewMode
		END IF
	END IF
ELSE
	i_HaveNew = FALSE

	IF i_ServiceDW.i_CurrentMode = i_ServiceDW.c_NewMode THEN
		i_ServiceDW.i_CurrentMode = i_ServiceDW.c_ViewMode
	END IF
END IF

//------------------------------------------------------------------
//  Make sure that deleting NewModified! records will not mark the
//  datawindow as being modified.
//------------------------------------------------------------------

IF l_DeleteNewModifiedCount = l_NewModifiedCount THEN
	i_HaveModify = FALSE
END IF

//------------------------------------------------------------------
//  Restore normal DataWindow activity.
//------------------------------------------------------------------

i_ServiceDW.i_IgnoreRFC = FALSE
i_ServiceDW.i_IgnoreVal = FALSE
i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)

Finished:

//------------------------------------------------------------------
//  If menu/button activation is available, set the controls.
//------------------------------------------------------------------

IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
	IF i_ServiceDW.i_IsCurrent THEN
  		i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_AllControls)
	END IF
END IF

//------------------------------------------------------------------
//  If an error occurred before the delete records were processed 
//  and this function was not called by pcd_delete, then trigger 
//  this event for the developer to be consistent.
//------------------------------------------------------------------

IF NOT l_DeleteProcessed AND NOT i_InDrag THEN
	IF NOT i_ServiceDW.i_FromEvent THEN
		i_ServiceDW.i_InProcess = TRUE
		i_ServiceDW.TriggerEvent("pcd_Delete")
		i_ServiceDW.i_InProcess = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN Error.i_FWError

end function

public function integer fu_drag ();//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_Drag
//  Description   : Process the drag operation.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - drag operation successful.
//                     -1 - drag operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

IF i_ServiceDW.i_NumSelected > 0 THEN

	//---------------------------------------------------------------
	//  Set the drag icon.
	//---------------------------------------------------------------

	IF i_ServiceDW.i_NumSelected = 1 THEN
		i_ServiceDW.DragIcon = i_DragRowIcon
	ELSE
		i_ServiceDW.DragIcon = i_DragRowsIcon
	END IF

	//---------------------------------------------------------------
	//  Set drag mode on.
	//---------------------------------------------------------------

	IF NOT IsNull(i_DropDW) AND IsValid( i_DropDW ) THEN
		i_DropDW.i_DWSRV_EDIT.i_InDrag = TRUE
	END IF
	i_InDrag = TRUE
	i_ServiceDW.Drag(Begin!)

END IF

RETURN c_Success
end function

public function integer fu_displayvalerror (string id, string error_message);//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Function      : fu_DisplayValError
//  Description   : Handles the display of validation errors.
//                  The error message can be specified by the
//                  developer in the Error_Message parameter or
//                  PowerClass will attempt to get the validation
//                  message from the DataWindow.  Failing that,
//                  it will provide a default PowerClass
//                  validation message specific to the error.
//
//  Parameters    : STRING ID -
//                     The message id to determine the message to
//                     display.  If a message is given for
//                     Error_Message then the ID must be 
//                     "ValDevOKError" or "ValDevYesNoError"
//                  STRING Error_Message -
//                     An error message provided by the
//                     developer.
//
//  Return Value  : INTEGER -
//                     1 or 2 - The button pressed by the user.
//                       -1   - The function was not called from
//                              pcd_ValidateCol or pcd_ValidateRow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//	 12/22/2000 K. Claver Added code to display the validation message
//								 if it exists and doesn't have quotes surrounding
//                       it.
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN       l_InSingleQuote, l_InDoubleQuote, l_Quoted
BOOLEAN       l_NextSingleQuote, l_NextDoubleQuote, l_TermToken
BOOLEAN       l_AddToken, l_Processed
INTEGER       l_LenErrMsg, l_LenColErr, l_Idx, l_Answer, l_ColNbr
LONG          l_RowNbr
STRING        l_ValidationMsg, l_Token, l_ID, l_Char
STRING        l_UpperToken, l_ErrorStrings[]

//------------------------------------------------------------------
//  Initialize the return value.
//------------------------------------------------------------------

l_Answer = 0

//------------------------------------------------------------------
//  Make sure this function is only being called by pcd_ValidateCol
//  or pcd_ValidateRow.
//------------------------------------------------------------------

IF NOT i_InValidation THEN
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Turn validation processing off in case we have to move to a
//  the row or column that had the error.
//------------------------------------------------------------------

i_ServiceDW.i_IgnoreVal = TRUE
i_ServiceDW.i_IgnoreRFC = TRUE

//------------------------------------------------------------------
//  Move to the row that had the error.  We only want to move if
//  we have to, as RFC will foul up PowerBuilder's internal
//  validation/modified state.
//------------------------------------------------------------------

l_RowNbr = i_ServiceDW.GetRow()
IF i_ValidateRow = 0 THEN
   i_ValidateRow = l_RowNbr
END IF

IF i_ValidateRow <> l_RowNbr OR &
	i_ValidateRow <> i_ServiceDW.i_CursorRow THEN

   i_ServiceDW.ScrollToRow(i_ValidateRow)
	i_ServiceDW.i_CursorRow = i_ValidateRow
END IF

//------------------------------------------------------------------
//  Move to the column that had the error.  We only want to
//  move if we have to, as SetColumn() will foul up
//  PowerBuilder's internal validation/modified state.
//------------------------------------------------------------------

l_ColNbr = i_ServiceDW.GetColumn()
IF i_ValidateCol = 0 THEN
	i_ValidateCol = l_ColNbr
END IF

IF i_ValidateCol <> l_ColNbr THEN
   i_ServiceDW.SetColumn(i_ValidateCol)
END IF

//------------------------------------------------------------------
//  Change focus to ourselves since we have an error.  Note
//  that fu_Activate() will raise the window if necessary.
//------------------------------------------------------------------

i_ServiceDW.fu_Activate()

//------------------------------------------------------------------
//  Figure out the validation error message to display.  The
//  priority of error messages is:
//     1) If a error message was passed as a parameter, use
//        it as the developer specified.
//     2) If there is an error in i_ColValMsg[], then process
//        and use it.
//     3) Use the message ID that was passed.
//------------------------------------------------------------------

l_LenErrMsg = Len(Trim(error_message))
l_LenColErr = Len(Trim(i_ColValMsg[i_ValidateCol]))
IF l_LenErrMsg = 0 AND l_LenColErr > 0 THEN

	l_ValidationMsg   = ""
   l_Token           = ""

   l_InSingleQuote   = FALSE
   l_InDoubleQuote   = FALSE
   l_NextSingleQuote = FALSE
   l_NextDoubleQuote = FALSE
   l_Quoted          = FALSE
   l_TermToken       = FALSE
   l_AddToken        = FALSE

   //---------------------------------------------------------------
   //  We have a validation error message from the DataWindow.
   //  We need to parse and process it.
   //---------------------------------------------------------------

   FOR l_Idx = 1 TO l_LenColErr + 1

      //------------------------------------------------------------
      //  Indicate that we have not processed this character.
      //------------------------------------------------------------

      l_Processed = FALSE

      IF l_Idx > l_LenColErr THEN
         l_Char = ""
      ELSE
         l_Char = Mid(i_ColValMsg[i_ValidateCol], l_Idx, 1)
      END IF

      //------------------------------------------------------------
      //  If this is not a quoted character and it is a tilde
      //  (~), then the next character in the string is to be
      //  quoted.
      //------------------------------------------------------------

      IF NOT l_Quoted AND l_Char = "~~" THEN
         l_Processed = TRUE
         l_Quoted    = TRUE
      END IF

      //------------------------------------------------------------
      //  If the character has not been processed and it is not
      //  quoted, see if it is a single quote (') or double
      //  quote (").
      //------------------------------------------------------------

      IF NOT l_Processed AND NOT l_Quoted THEN
         IF l_Char = "'" THEN

            //------------------------------------------------------
            //  The character is a single quote.  If we are not
            //  inside of a double quoted string, then this
            //  single quote begins or ends a single quoted
            //  string.  In either case, the token we were
            //  building is complete.  Not that we do switch
            //  the state of quoting until the end of this loop.
            //  The state of quoting needs to stay the same
            //  until after the token has been added to the
            //  error message buffer.
            //------------------------------------------------------

            IF NOT l_InDoubleQuote THEN
               l_NextSingleQuote = (NOT l_InSingleQuote)
               l_Processed       = TRUE
               l_AddToken        = TRUE
            END IF
         END IF
         IF l_Char = "~"" THEN

            //------------------------------------------------------
            //  The character is a double quote.  If we are not
            //  inside of a single quoted string, then this
            //  double quote begins or ends a double quoted
            //  string.  In either case, the token we were
            //  building is complete.  Not that we do switch
            //  the state of quoting until the end of this loop.
            //  The state of quoting needs to stay the same
            //  until after the token has been added to the
            //  error message buffer.
            //------------------------------------------------------

            IF NOT l_InSingleQuote THEN
               l_NextDoubleQuote = (NOT l_InDoubleQuote)
               l_Processed       = TRUE
               l_AddToken        = TRUE
            END IF
         END IF
      END IF

      //------------------------------------------------------------
      //  If the characters still has not been processed, keep
      //  trying.
      //------------------------------------------------------------

      IF NOT l_Processed THEN

         //---------------------------------------------------------
         //  If the character has been quoted, check to see if
         //  it matches one of the PowerBuilder special
         //  characters.  If it does, then the current token we
         //  are building is complete.  If the character is not
         //---------------------------------------------------------

         IF l_Quoted THEN
            l_TermToken = (l_Char = "n"  OR &
                           l_Char = "t"  OR &
                           l_Char = "v"  OR &
                           l_Char = "r"  OR &
                           l_Char = "f"  OR &
                           l_Char = "b"  OR &
                           l_Char = "'"  OR &
                           l_Char = "~"")
         ELSE

            //------------------------------------------------------
            //  The character is not quoted.  Look for special
            //  characters which terminate tokens.
            //------------------------------------------------------

            l_TermToken = (l_Char = " "  OR &
                           l_Char = "+"  OR &
                           l_Char = ""  OR &
                           l_Char = ""  OR &
                           l_Char = "~"" OR &
                           l_Char = "~n" OR &
                           l_Char = "~t" OR &
                           l_Char = "~r")
         END IF

         //---------------------------------------------------------
         //  Since we have found a charater that says to start
         //  a new token, indicate that the current token is
         //  done.
         //---------------------------------------------------------

         IF l_TermToken THEN
            l_AddToken = TRUE
         END IF
      END IF

      //------------------------------------------------------------
      //  If the current token is done or if we are at the end
      //  of the validation message, add the token to the
      //  processed validation error message.
      //------------------------------------------------------------

      IF l_AddToken OR l_Idx > l_LenColErr THEN
         l_AddToken = FALSE

         //---------------------------------------------------------
         //  If there is not a token, then we have nothing to
         //  add.
         //---------------------------------------------------------

         IF Len(l_Token) > 0 THEN

            //------------------------------------------------------
            //  While we are inside of a quoted string, the
            //  only thing will substitue in for the developer
            //  is the column name.
            //------------------------------------------------------

            IF l_InSingleQuote OR l_InDoubleQuote THEN
               l_UpperToken = Upper(l_Token)
					CHOOSE CASE l_UpperToken
                  CASE "@COLUMNNAME", "@COLUMN", "@COL"
                     l_ValidationMsg = l_ValidationMsg + i_ColName[i_ValidateCol]
                  CASE ELSE
                     l_ValidationMsg = l_ValidationMsg + l_Token
               END CHOOSE
            ELSE

               //---------------------------------------------------
               //  If we are not inside of quoted string, then
               //  look for tokens that we can substitute for
               //  the developer.
               //---------------------------------------------------

               l_UpperToken = Upper(l_Token)
					CHOOSE CASE l_UpperToken
                  CASE "GETTEXT()"
                     l_ValidationMsg = l_ValidationMsg + &
                                       i_ServiceDW.GetText()
                  CASE "GETROW()"
                     l_ValidationMsg = l_ValidationMsg + &
                                       String(i_ServiceDW.GetRow())
                  CASE "ROWCOUNT()"
                     l_ValidationMsg = l_ValidationMsg + &
                                       String(i_ServiceDW.RowCount())
                  CASE ELSE
               END CHOOSE
            END IF

            //------------------------------------------------------
            //  Reset the token.
            //------------------------------------------------------

            l_Token = ""
         END IF
      END IF

      //------------------------------------------------------------
      //  If the character still has not been processed, keep
      //  trying.
      //------------------------------------------------------------

      IF NOT l_Processed THEN
         IF l_Quoted THEN

            //------------------------------------------------------
            //  We have a quoted character since there was a
            //  tilde (~) preceeding this character (e.g.
            //  "~n").  Look for PowerBuilder special
            //  characters and add them if they are found.
            //  Otherwise, just add the raw character.
            //------------------------------------------------------

            l_Quoted = FALSE

            CHOOSE CASE l_Char
               CASE "n"
                  l_Token = l_Token + "~n"
               CASE "t"
                  l_Token = l_Token + "~t"
               CASE "v"
                  l_Token = l_Token + "~v"
               CASE "r"
                  l_Token = l_Token + "~r"
               CASE "f"
                  l_Token = l_Token + "~f"
               CASE "b"
                  l_Token = l_Token + "~b"
               CASE ELSE
                  l_Token = l_Token + l_Char
            END CHOOSE
         ELSE

            //------------------------------------------------------
            //  We just found a normal character.  Tack it on
            //  to the current token.
            //------------------------------------------------------

            l_Token = l_Token + l_Char
         END IF
      END IF

      //------------------------------------------------------------
      //  l_TermToken is TRUE when the character that just got
      //  added was one of the PowerBuilder special characters.
      //  Because it is special, it is a complete token in and
      //  of itself.  Indicate that the token is complete and
      //  should be added to the error message buffer.
      //------------------------------------------------------------

      IF l_TermToken THEN
         l_TermToken = FALSE
         l_AddToken  = TRUE
      END IF

      //------------------------------------------------------------
      //  The state of the quoted string may have been changed
      //  at the begining of this loop.  Set the state so that
      //  it is ready for the next time through the loop.
      //------------------------------------------------------------

      l_InSingleQuote = l_NextSingleQuote
      l_InDoubleQuote = l_NextDoubleQuote
   NEXT

   //---------------------------------------------------------------
   //  Set up to display the message.
   //---------------------------------------------------------------
	
	//Check if there is a validation message.  If the validation message was
	//  programmatically added, there may not be quotes around it.  Display the message
	//  without quotes.
	IF Trim( l_ValidationMsg ) = "" AND Trim( i_ColValMsg[i_ValidateCol] ) <> "" THEN
		l_ValidationMsg = i_ColValMsg[i_ValidateCol]
	END IF

   l_ID = "ValDWError"
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_DisplayValError"
   l_ErrorStrings[6] = l_ValidationMsg
ELSE

   //----------
   //  There is not a validation error message in the
   //  DataWindow.  Use the Message ID to display the message.
   //----------

   IF Upper(id) = "VALDEVYESNOERROR" THEN
   	l_ID = "ValDevYesNoError"
	ELSEIF Upper(id) = "VALDEVOKERROR" THEN
		l_ID = "ValDevOKError"
	ELSE
		l_ID = id
	END IF
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_DisplayValError"
   l_ErrorStrings[6] = error_message
END IF

//------------------------------------------------------------------
//  Make sure that redraw is on when we display the message
//  box containing the validation error.  If it were not, the
//  message box would "eat" the DataWindow if the user were to
//  move the message box.
//------------------------------------------------------------------

//i_ServiceDW.SetRedraw(TRUE)

//------------------------------------------------------------------
//  Popup the message box with the validaton error.
//------------------------------------------------------------------

l_Answer = FWCA.MSG.fu_DisplayMessage(l_ID, 6, l_ErrorStrings[])

//------------------------------------------------------------------
//  Restore the prior state of redraw and validation processing.
//------------------------------------------------------------------

//i_ServiceDW.SetRedraw(FALSE)
i_ServiceDW.i_IgnoreVal = FALSE
i_ServiceDW.i_IgnoreRFC = FALSE

RETURN l_Answer

end function

on n_dwsrv_edit.create
call super::create
end on

on n_dwsrv_edit.destroy
call super::destroy
end on

event constructor;call super::constructor;//******************************************************************
//  PC Module     : n_DWSRV_EDIT
//  Event         : Constructor
//  Description   : Initializes service variables.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

fu_SetDragIndicator(i_ServiceDW.c_Default, &
                    i_ServiceDW.c_Default, &
                    i_ServiceDW.c_Default)
end event

