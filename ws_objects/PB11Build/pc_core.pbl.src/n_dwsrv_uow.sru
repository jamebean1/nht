$PBExportHeader$n_dwsrv_uow.sru
$PBExportComments$DataWindow service for unit-of-work management
forward
global type n_dwsrv_uow from n_dwsrv_main
end type
end forward

global type n_dwsrv_uow from n_dwsrv_main
end type
global n_dwsrv_uow n_dwsrv_uow

type variables
//-----------------------------------------------------------------------------------------
//  Unit-of-Work Service Constants
//-----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_PromptChanges		= 1
CONSTANT INTEGER	c_IgnoreChanges		= 2
CONSTANT INTEGER	c_SaveChanges		= 3

//-----------------------------------------------------------------------------------------
//  Unit-of-Work Service Instance Variables
//-----------------------------------------------------------------------------------------

U_DW_MAIN		i_RefreshParentDW

DATAWINDOW		i_CurrentInstanceDW

BOOLEAN		i_ShareDW[]

STRING			i_DateFormat = "yyyy/mm/dd"
STRING			i_TimeFormat = "hh:mm"
end variables

forward prototypes
public subroutine fu_adduow (integer number_links, datawindow link_dw[])
public subroutine fu_deleteuow (datawindow link_dw)
public function integer fu_new (datawindow current_dw, long start_row, long num_rows)
public function integer fu_refreshparent (integer current_index)
public function integer fu_refresh (datawindow current_dw, integer refresh, string mode)
public function long fu_getinstancerow (datawindow current_dw)
public subroutine fu_setinstance (datawindow current_dw)
public function boolean fu_checkinstance (datawindow current_dw)
public function boolean fu_mapkeys (u_dw_main parent_dw, u_dw_main child_dw, ref integer map_keys[])
public function boolean fu_findinstance (datawindow current_dw, long row_nbr)
public function integer fu_getchildren (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[])
public function integer fu_getchildrencnt (datawindow current_dw)
public function integer fu_save (datawindow current_dw, integer changes, integer check_who)
public function integer fu_view (datawindow current_dw, integer refresh)
public function integer fu_modify (datawindow current_dw, integer refresh)
public function boolean fu_findshare (datawindow current_dw)
public function integer fu_getchildrenlist (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[])
public function string fu_buildfind (u_dw_main parent_dw, u_dw_main dw_name, integer index, integer map_key[])
public function boolean fu_checkchangesuow ()
public subroutine fu_resetupdateuow ()
public function integer fu_validateuow ()
end prototypes

public subroutine fu_adduow (integer number_links, datawindow link_dw[]);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Subroutine    : fu_AddUOW
//  Description   : Adds DataWindows to the unit-of-work service.
//
//  Parameters    : INTEGER Number_Links -
//                     The number of DataWindows to add.
//                  DATAWINDOW Link_DW[] -
//                     The DataWindows to add.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_Idx, l_Jdx, l_NumDW
DATAWINDOW l_ParentDW, l_DW, l_TmpParentDW[], l_TmpDW[], l_NullDW
BOOLEAN    l_Found
STRING     l_ErrorStrings[]

SetNull(l_NullDW)

//------------------------------------------------------------------
//  Determine if the Root DataWindow needs to be added.
//------------------------------------------------------------------

l_Found = FALSE
FOR l_Idx = 1 TO i_NumDW
	IF i_DW[l_Idx] = link_dw[number_links] THEN
		l_Found = TRUE
		EXIT
	END IF
NEXT

IF NOT l_Found THEN
	i_NumDW = i_NumDW + 1
	i_DW[i_NumDW] = link_dw[number_links]
	i_ParentDW[i_NumDW] = l_NullDW
END IF

//------------------------------------------------------------------
//  Determine if the DataWindows need to be added.
//------------------------------------------------------------------

l_NumDW = i_NumDW
FOR l_Idx = 1 TO number_links - 1
	l_DW = link_dw[l_Idx]
	l_ParentDW = link_dw[l_Idx + 1]
	l_Found = FALSE
	FOR l_Jdx = 1 TO l_NumDW
		IF i_DW[l_Jdx] = l_DW AND i_ParentDW[l_Jdx] = l_ParentDW THEN
			l_Found = TRUE
			EXIT
		END IF
	NEXT

	IF NOT l_Found THEN
		i_NumDW = i_NumDW + 1
		i_DW[i_NumDW] = l_DW
		i_ParentDW[i_NumDW] = l_ParentDW
		i_ShareDW[i_NumDW] = FALSE
	END IF
NEXT

//------------------------------------------------------------------
//  Sort the array of DataWindows so that they are in a parent/child
//  order starting with the root.
//------------------------------------------------------------------

l_TmpDW[] = i_DW[]
l_TmpParentDW[] = i_ParentDW[]

l_NumDW = 0
FOR l_Idx = 1 TO i_NumDW
	IF l_Idx = 1 THEN
		FOR l_Jdx = 1 TO i_NumDW
			IF IsNull(l_TmpParentDW[l_Jdx]) <> FALSE THEN
				l_NumDW = l_NumDW + 1
				i_DW[l_NumDW] = l_TmpDW[l_Jdx]
				i_ParentDW[l_NumDW] = l_TmpParentDW[l_Jdx]
				EXIT
			END IF
		NEXT
	ELSE
		l_ParentDW = i_DW[l_Idx - 1]
		FOR l_Jdx = 1 TO i_NumDW
			IF l_TmpParentDW[l_Jdx] = l_ParentDW THEN
				l_NumDW = l_NumDW + 1
				i_DW[l_NumDW] = l_TmpDW[l_Jdx]
				i_ParentDW[l_NumDW] = l_TmpParentDW[l_Jdx]
			END IF
		NEXT
	END IF
NEXT

//------------------------------------------------------------------
//  Make sure that each DataWindow in the unit-of-work knows about
//  this service.  Also, indicate if the DataWindow is part of a 
//  share with its parent.
//------------------------------------------------------------------

i_ShareDW[1] = FALSE
FOR l_Idx = 2 TO i_NumDW
	IF NOT IsValid(i_DW[l_Idx].i_DWSRV_UOW) THEN
		i_DW[l_Idx].i_DWSRV_UOW = THIS
	END IF
	IF i_DW[l_Idx].i_ShareData THEN
		IF NOT i_ShareDW[l_Idx] THEN
			i_DW[l_Idx].i_IgnoreRFC = TRUE
			IF i_ParentDW[l_Idx].ShareData(i_DW[l_Idx]) = c_Fatal THEN
  				l_ErrorStrings[1] = "PowerClass Error"
  				l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  				l_ErrorStrings[3] = i_DW[l_Idx].i_Window.ClassName()
  				l_ErrorStrings[4] = i_DW[l_Idx].ClassName() + " - " + ClassName()
  				l_ErrorStrings[5] = "fu_AddUOW"

				FWCA.MSG.fu_DisplayMessage("ShareError", &
	                                    5, l_ErrorStrings[])
			END IF
			i_ShareDW[l_Idx] = TRUE
			i_DW[l_Idx].i_IgnoreRFC = FALSE
		END IF
	ELSE
		i_ShareDW[l_Idx] = FALSE
	END IF
NEXT
end subroutine

public subroutine fu_deleteuow (datawindow link_dw);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Subroutine    : fu_DeleteUOW
//  Description   : Deletes a DataWindow from the unit-of-work 
//                  service.
//
//  Parameters    : DATAWINDOW Link_DW -
//                     The DataWindow to remove.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Bug # / Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_Idx, l_Jdx

//------------------------------------------------------------------
//  Delete the DataWindow from the unit-of-work.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF i_ShareDW[l_Idx] THEN
		i_DW[l_Idx].i_IgnoreRFC = TRUE
	END IF
NEXT

l_Jdx = 0
FOR l_Idx = 1 TO i_NumDW
	IF i_DW[l_Idx] <> link_dw THEN
		l_Jdx = l_Jdx + 1
		i_DW[l_Jdx] = i_DW[l_Idx]
		i_ParentDW[l_Jdx] = i_ParentDW[l_Idx]
		i_ShareDW[l_Jdx] = i_ShareDW[l_Idx]
	ELSE
		IF NOT i_ShareDW[l_Idx] THEN
			i_DW[l_Idx].ShareDataOff()
		END IF
		IF i_DW[l_Idx] = i_CurrentInstanceDW THEN
			SetNull(i_CurrentInstanceDW)
		END IF
	END IF
NEXT

i_NumDW = l_Jdx

FOR l_Idx = 1 TO i_NumDW
	IF i_ShareDW[l_Idx] THEN
		i_DW[l_Idx].i_IgnoreRFC = FALSE
	END IF
NEXT

end subroutine

public function integer fu_new (datawindow current_dw, long start_row, long num_rows);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_New
//  Description   : Add new records to the children DataWindows of
//                  the given DataWindow.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     DataWindow that has children DataWindows.
//                  LONG       Start_Row -
//                     Row number to insert in front of.  If it is
//                     0 then the rows are added to the end.
//                  LONG       Num_Rows-
//                     Number of rows to add.
//
//  Return Value  : INTEGER -
//                      0 - new operation successful.
//                     -1 - new operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_ChildrenDW[], l_ParentDW
INTEGER   l_NumChildren, l_Idx, l_ActivateIndex
BOOLEAN   l_ShareDW[], l_Found, l_ShareFirst
WINDOW    l_Window

IF i_InModeChange THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Get the immediate children to the given DataWindow.
//------------------------------------------------------------------

i_InModeChange = TRUE
l_NumChildren = fu_GetChildren(current_dw, l_ChildrenDW[], l_ShareDW[])
l_ParentDW = current_dw

//------------------------------------------------------------------
//  If there are any children, determine if we can add new records
//  to them.  If any of the children are on the same window as the 
//  parent then determine which one to activate.  If multiple 
//  children are on the same window, we don't know which one to 
//  activate so we will leave it on the parent and let the developer
//  decide.  If we have multiple children in a share situation make
//  sure a new is done on only one of them.
//------------------------------------------------------------------

l_Window = current_dw.DYNAMIC fu_GetWindow()
l_Found = FALSE
l_ActivateIndex = 0
l_ShareFirst = FALSE
FOR l_Idx = 1 TO l_NumChildren
	IF l_ChildrenDW[l_Idx].i_AllowNew THEN
		IF l_ShareDW[l_Idx] THEN
			IF NOT l_ShareFirst THEN
				IF l_ChildrenDW[l_Idx].i_DWSRV_EDIT.fu_New(start_row, num_rows) &
					<> c_Success THEN
					i_InModeChange = FALSE
					RETURN c_Fatal
				END IF
				l_ShareFirst = TRUE
				IF IsValid(l_ParentDW.i_DWSRV_EDIT) THEN
					l_ParentDW.i_DWSRV_EDIT.i_HaveNew = TRUE
				END IF
			ELSE
				l_ChildrenDW[l_Idx].i_DWSRV_EDIT.i_HaveNew = TRUE
			END IF
		ELSE
			IF l_ChildrenDW[l_Idx].i_DWSRV_EDIT.fu_New(start_row, num_rows) &
				<> c_Success THEN
				i_InModeChange = FALSE
				RETURN c_Fatal
			END IF
		END IF
		IF l_ChildrenDW[l_Idx].i_Window = l_Window THEN
			IF NOT l_Found THEN
				l_ActivateIndex = l_Idx
				l_Found = TRUE
			ELSE
				l_ActivateIndex = 0
			END IF
		END IF
	END IF
NEXT

IF l_ActivateIndex > 0 THEN
	l_ChildrenDW[l_ActivateIndex].fu_Activate()
END IF

i_InModeChange = FALSE

RETURN c_Success
end function

public function integer fu_refreshparent (integer current_index);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_RefreshParent
//  Description   : Refreshes the given DataWindow's parent.  An 
//                  attempt will be made to refresh by just 
//                  retieving the rows that have changed.  If that
//                  can't be done, then the DataWindow will be
//                  retrieved and the selected rows will be 
//                  reselected.
//
//  Parameters    : INTEGER Current_Index -
//                     Index into i_DW for the DataWindow that has
//                     a parent to refresh.
//
//  Return Value  : INTEGER -
//                      0 - refresh parent operation successful.
//                     -1 - refresh parent operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  10/8/98	Beth Byers	Fixed assignment of variable l_Table to come
//								from l_DBName in case the database attaches
//								the database owner to the table name
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_DW, l_ParentDW
BOOLEAN   l_UseReselect, l_Found, l_Update, l_ReselectWithNew
INTEGER   l_Idx, l_Jdx, l_NumColumns, l_Pos, l_MapKey[]
LONG      l_Row, l_RowCount, l_NumSelected, l_SelectedRows[]
STRING    l_FindRow, l_UpdateTable, l_Col, l_DBName, l_Table
STRING    l_ErrorStrings[], l_Owner
DWITEMSTATUS l_RowStatus

//------------------------------------------------------------------
//  Get the given DataWindows parent.
//------------------------------------------------------------------

l_DW       = i_DW[current_index]
l_ParentDW = i_ParentDW[current_index]

//------------------------------------------------------------------
//  Determine if we can refresh our parent by using the PowerBuilder
//  RESELECTROW() function.  All columns in the parent must
//  have their update attribute set on and be from one table.
//------------------------------------------------------------------

l_UseReselect = TRUE
l_ReselectWithNew = FALSE

//------------------------------------------------------------------
// Determine if the user specified that they want all of the data
// retrieved on refresh, not just a reselect
//------------------------------------------------------------------
IF l_DW.i_RefreshParentRetrieve = TRUE THEN
	l_UseReselect = FALSE
ELSE
	l_UpdateTable = l_ParentDW.Describe("datawindow.table.updatetable")
	
	IF l_UpdateTable <> "?" AND l_UpdateTable <> "!" THEN
		l_NumColumns  = Integer(l_ParentDW.Describe("datawindow.column.count"))

		FOR l_Idx = 1 TO l_NumColumns
			l_Col = "#" + String(l_Idx)
			l_Update = (Upper(l_ParentDW.Describe(l_Col + ".update")) = "YES")
			IF l_Update THEN
				l_DBName = l_ParentDW.Describe(l_Col + ".dbname")
				l_Pos = Pos(l_DBName, ".")
				IF l_Pos > 0 THEN
					l_Owner = MID(l_DBName, 1, l_Pos - 1)
					l_DBName = MID(l_DBName, l_Pos + 1)
					l_Pos = Pos(l_DBName, ".")
					IF l_Pos > 0 THEN
//------------------------------------------------------------------
//	Replace old assignment l_Table = MID(l_Table, 1, l_Pos - 1) with
// the new one below
//------------------------------------------------------------------
						l_Table = MID(l_DBName, 1, l_Pos - 1)
					ELSE
						l_Table = l_Owner
					END IF
					IF l_Table <> l_UpdateTable THEN
						l_UseReselect = FALSE
						EXIT
					END IF
				END IF
			ELSE
				l_UseReselect = FALSE
				EXIT
			END IF
		NEXT
	ELSE
		l_UseReselect = FALSE
	END IF
END IF

//------------------------------------------------------------------
//  If able to reselect rows in the parent we need to map the 
//  keys in the parent with the keys in the child DataWindow.
//------------------------------------------------------------------

IF NOT l_DW.i_GotKeys THEN
	l_DW.fu_GetKeys()
END IF
IF NOT l_ParentDW.i_GotKeys THEN
	l_ParentDW.fu_GetKeys()
END IF

//------------------------------------------------------------------
//  If this DataWindow and its parent don't have the same number
//  of keys then we can't refresh the parent.
//------------------------------------------------------------------

IF l_ParentDW.i_NumKeys = 0 THEN
  	l_ErrorStrings[1] = "PowerClass Error"
  	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  	l_ErrorStrings[3] = l_DW.i_Window.ClassName()
  	l_ErrorStrings[4] = l_DW.ClassName() + " - " + ClassName()
  	l_ErrorStrings[5] = "fu_RefreshParent"

	FWCA.MSG.fu_DisplayMessage("KeysInDWError", &
	                           5, l_ErrorStrings[])
	RETURN c_Fatal
END IF

IF l_ParentDW.i_NumKeys > l_DW.i_NumKeys THEN
  	l_ErrorStrings[1] = "PowerClass Error"
  	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  	l_ErrorStrings[3] = l_DW.i_Window.ClassName()
  	l_ErrorStrings[4] = l_DW.ClassName() + " - " + ClassName()
  	l_ErrorStrings[5] = "fu_RefreshParent"

	FWCA.MSG.fu_DisplayMessage("KeysMismatchError", &
                              5, l_ErrorStrings[])
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Attempt to map the keys.
//------------------------------------------------------------------

l_Found = fu_MapKeys(l_ParentDW, l_DW, l_MapKey[])

//------------------------------------------------------------------
//  No map of the key could be found.
//------------------------------------------------------------------

IF NOT l_Found THEN
	l_UseReselect = FALSE
  	IF UpperBound(l_MapKey[]) = 0 THEN
		l_ErrorStrings[1] = "PowerClass Error"
  		l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  		l_ErrorStrings[3] = l_DW.i_Window.ClassName()
  		l_ErrorStrings[4] = l_DW.ClassName() + " - " + ClassName()
  		l_ErrorStrings[5] = "fu_RefreshParent"

		FWCA.MSG.fu_DisplayMessage("KeysMismatchError", &
                                 5, l_ErrorStrings[])
		RETURN c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  Refresh the parent DataWindow with the modified rows in this
//  DataWindow.
//------------------------------------------------------------------

l_ParentDW.fu_SetRedraw(l_ParentDW.c_Off)

IF l_UseReselect THEN

	l_NumSelected = 0

	//---------------------------------------------------------------
	//  Use RESELECTROW() function to refresh the modified rows in
	//  the parent DataWindow.
	//---------------------------------------------------------------

	IF l_ParentDW.RowCount() > 0 AND NOT l_ParentDW.i_IsEmpty THEN
		l_RowCount = l_DW.RowCount()
		FOR l_Idx = 1 TO l_RowCount
			l_RowStatus = l_DW.GetItemStatus(l_Idx, 0, Primary!)
			IF l_RowStatus <> NewModified! AND l_RowStatus <> New! THEN
				l_FindRow = fu_BuildFind(l_ParentDW, l_DW, l_Idx, l_MapKey[])

				l_Row = l_ParentDW.Find(l_FindRow, 1, l_ParentDW.RowCount())
				IF l_Row > 0 THEN
					IF l_ParentDW.ReselectRow(l_Row) = c_Fatal THEN
						l_UseReselect = FALSE
						EXIT
					ELSE
					   l_NumSelected = l_NumSelected + 1
						l_SelectedRows[l_NumSelected] = l_Row
					END IF
				END IF
			END IF
	   NEXT
	END IF

	//---------------------------------------------------------------
	//  Determine if any new rows have been added to this DataWindow.
	//  If so, determine if the row already exists in the parent
	//  (e.g. one-to-many it will), and if not, get the keys from 
	//  the key mapping to find the new rows in the parent.
	//---------------------------------------------------------------

	IF l_UseReselect AND l_DW.i_DWSRV_EDIT.i_HaveNew THEN
		l_RowCount = l_DW.RowCount()
		FOR l_Idx = 1 TO l_RowCount
			l_RowStatus = l_DW.GetItemStatus(l_Idx, 0, Primary!)
			IF l_RowStatus = NewModified! THEN
				IF l_ParentDW.RowCount() > 0 AND NOT l_ParentDW.i_IsEmpty THEN
					l_FindRow = fu_BuildFind(l_ParentDW, l_DW, l_Idx, l_MapKey[])
					l_Row = l_ParentDW.Find(l_FindRow, 1, l_ParentDW.RowCount())
				ELSE
					l_Row = 0
				END IF
				IF l_Row = 0 THEN
					l_Row = l_ParentDW.InsertRow(0)
					FOR l_Jdx = 1 TO l_ParentDW.i_NumKeys
						CHOOSE CASE l_ParentDW.i_KeyTypes[l_Jdx]
							CASE "CHAR"
								l_ParentDW.SetItem(l_Row, l_ParentDW.i_KeyColumns[l_Jdx], &
									l_DW.GetItemString(l_Idx, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
							CASE "DATE"
								l_ParentDW.SetItem(l_Row, l_ParentDW.i_KeyColumns[l_Jdx], &
									l_DW.GetItemDate(l_Idx, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
	      				CASE "DATETIME"
								l_ParentDW.SetItem(l_Row, l_ParentDW.i_KeyColumns[l_Jdx], &
									l_DW.GetItemDateTime(l_Idx, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
							CASE "TIME", "TIMESTAMP"
								l_ParentDW.SetItem(l_Row, l_ParentDW.i_KeyColumns[l_Jdx], &
									l_DW.GetItemTime(l_Idx, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
							CASE "DEC"
								l_ParentDW.SetItem(l_Row, l_ParentDW.i_KeyColumns[l_Jdx], &
									l_DW.GetItemDecimal(l_Idx, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
							CASE ELSE
								l_ParentDW.SetItem(l_Row, l_ParentDW.i_KeyColumns[l_Jdx], &
									l_DW.GetItemNumber(l_Idx, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
						END CHOOSE
					NEXT
				END IF

				IF l_ParentDW.ReselectRow(l_Row) = c_Fatal THEN
					l_ReselectWithNew = FALSE
					l_UseReselect = FALSE
					EXIT
				ELSE
					l_ReselectWithNew = TRUE
					l_NumSelected = l_NumSelected + 1
					l_SelectedRows[l_NumSelected] = l_Row
			   	l_ParentDW.SetItemStatus(l_Row, 0, Primary!, DataModified!)
			   	l_ParentDW.SetItemStatus(l_Row, 0, Primary!, NotModified!)
				END IF
			END IF
		NEXT
	END IF			
END IF

//------------------------------------------------------------------
//  If RESELECTROW() could not be used or using it failed in the
//  above code, then refresh the parent DataWindow by retrieving
//  and reselecting the previously selected rows.
//------------------------------------------------------------------

i_InRefreshParent = TRUE
IF NOT l_UseReselect THEN

	//---------------------------------------------------------------
	//  Refresh the parent DataWindow by retrieving and reselecting
	//  the previously selected rows.
	//---------------------------------------------------------------

	IF l_ParentDW.fu_Retrieve(l_ParentDW.c_IgnoreChanges, &
		l_ParentDW.c_ReselectRows) <> c_Success THEN
		l_ParentDW.fu_SetRedraw(l_ParentDW.c_On)
		RETURN c_Fatal
	END IF

	//---------------------------------------------------------------
	//  For each row in the child DataWindow, find the matching
	//  record in the parent DataWindow using the key columns.
	//---------------------------------------------------------------

	IF l_DW.i_DWSRV_EDIT.i_HaveNew THEN
		l_NumSelected = l_ParentDW.fu_GetSelectedRows(l_SelectedRows[])
		l_RowCount = l_DW.RowCount()
		FOR l_Idx = 1 TO l_RowCount
			l_RowStatus = l_DW.GetItemStatus(l_Idx, 0, Primary!)
			IF l_RowStatus = NewModified! THEN
				l_FindRow = fu_BuildFind(l_ParentDW, l_DW, l_Idx, l_MapKey[])

				l_Row = l_ParentDW.Find(l_FindRow, 1, l_ParentDW.RowCount())
				IF l_Row > 0 THEN
					IF NOT l_ParentDW.i_MultiSelect THEN
						l_NumSelected = 1
						l_SelectedRows[1] = l_Row
					ELSE
						l_NumSelected = l_NumSelected + 1
						l_SelectedRows[l_NumSelected] = l_Row
					END IF
				END IF
			END IF
		NEXT
	END IF
END IF

//------------------------------------------------------------------
//  Reselect the records in the parent DataWindow.  If the parent 
//  DataWindow has other children, check to see if the other
//  children should be refreshed (e.g. c_RefreshChild).
//------------------------------------------------------------------

i_RefreshParentDW = l_DW
IF l_UseReselect OR (NOT l_UseReselect AND l_DW.i_DWSRV_EDIT.i_HaveNew) THEN
	l_ParentDW.fu_SetSelectedRows(l_NumSelected, l_SelectedRows[], &
		                           l_ParentDW.c_IgnoreChanges, &
                                 l_ParentDW.c_RefreshChildren)
ELSEIF NOT l_UseReselect AND NOT l_DW.i_DWSRV_EDIT.i_HaveNew THEN
	fu_Refresh(l_ParentDW, l_ParentDW.c_RefreshChildren, &
              l_ParentDW.c_SameMode)
END IF

//------------------------------------------------------------------
//  If new records were inserted in the parent using RESELECTROW()
//  then see if the DataWindow has sort criteria and sort the
//  DataWindow so the new record is put into the correct order.
//------------------------------------------------------------------

IF l_ReselectWithNew THEN
	IF l_ParentDW.Describe("datawindow.table.sort") <> "?" THEN
		l_ParentDW.Sort()
		l_ParentDW.i_NumSelected = l_ParentDW.fu_GetSelectedRows(l_ParentDW.i_SelectedRows[])
		l_ParentDW.i_IgnoreRFC = TRUE
		l_ParentDW.i_CursorRow = l_ParentDW.i_SelectedRows[1]
		l_ParentDW.i_AnchorRow = l_ParentDW.i_SelectedRows[1]
		l_ParentDW.ScrollToRow(l_ParentDW.i_CursorRow)
		l_ParentDW.i_IgnoreRFC = FALSE
	END IF

	//---------------------------------------------------------------
	//  If the menu/button activation service has been requested then
	//  set the menu/button status based on the parent DataWindow. 
	//---------------------------------------------------------------

	IF l_ParentDW.i_IsCurrent THEN
		IF IsValid(l_ParentDW.i_DWSRV_CTRL) THEN
			l_ParentDW.i_DWSRV_CTRL.fu_SetControl(l_ParentDW.c_AllControls)
		END IF
	END IF
END IF

i_InRefreshParent = FALSE
l_ParentDW.fu_SetRedraw(l_ParentDW.c_On)

RETURN c_Success
end function

public function integer fu_refresh (datawindow current_dw, integer refresh, string mode);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_Refresh
//  Description   : Refresh the children DataWindows of the given 
//                  DataWindow.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     DataWindow that has children DataWindows.
//                  INTEGER    Refresh -
//                     Determines how the refresh is to be done.
//                     Values are:
//                        c_RefreshChildren
//                        c_ResetChildren
//                        c_AutoRefreshChildren
//                        c_RefreshOnOpenChildren
//                        c_NoRefreshChildren
//                  STRING    Mode -
//                     Determines what mode the refresh is to put
//                     the children DataWindows in.  Values are:
//                        c_SameMode
//                        c_ModifyMode
//                        c_ViewMode
//
//  Return Value  : INTEGER -
//                      0 - refresh operation successful.
//                     -1 - refresh operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_ChildrenDW[], l_CurrentDW
INTEGER   l_NumChildren, l_Idx, l_RefreshMode
BOOLEAN   l_ShareDW[], l_OnOpenOnly
STRING    l_Mode, l_ModeOnSelect

//------------------------------------------------------------------
//  Get the immediate children to the given DataWindow.
//------------------------------------------------------------------

l_RefreshMode = refresh
l_OnOpenOnly = FALSE

IF refresh <> i_ServiceDW.c_NoRefreshChildren THEN
	IF refresh <> i_ServiceDW.c_ResetChildren THEN
		l_NumChildren = fu_GetChildren(current_dw, l_ChildrenDW[], l_ShareDW[])
		IF l_RefreshMode = i_ServiceDW.c_RefreshOnOpenChildren THEN
			l_RefreshMode = i_ServiceDW.c_RefreshChildren
			l_OnOpenOnly = TRUE
		END IF
	ELSE
		l_NumChildren = fu_GetChildrenList(current_dw, l_ChildrenDW[], l_ShareDW[])	
	END IF
END IF

//------------------------------------------------------------------
//  If there are any children, refresh them based on the refresh
//  option.
//------------------------------------------------------------------

CHOOSE CASE l_RefreshMode

	CASE i_ServiceDW.c_RefreshChildren

		IF i_InRefreshParent THEN
			FOR l_Idx = 1 TO l_NumChildren
				IF l_ChildrenDW[l_Idx] <> i_RefreshParentDW AND &
					l_ChildrenDW[l_Idx].i_RefreshChild THEN
					IF l_ChildrenDW[l_Idx].fu_Retrieve(i_ServiceDW.c_IgnoreChanges, &
						i_ServiceDW.c_ReselectRows) <> c_Success THEN
						RETURN c_Fatal
					END IF
				END IF
			NEXT
		ELSE
			l_CurrentDW = current_dw		
			FOR l_Idx = 1 TO l_NumChildren
				IF l_OnOpenOnly THEN
					IF NOT l_ChildrenDW[l_Idx].i_RefreshOnOpen THEN
						CONTINUE
					ELSE
						l_ChildrenDW[l_Idx].i_RefreshOnOpen = FALSE
					END IF
				ELSE
					l_ChildrenDW[l_Idx].i_RefreshOnOpen = FALSE
				END IF

				l_Mode = mode
				IF mode = i_ServiceDW.c_SameMode THEN
					IF l_CurrentDW.i_RequestMode = i_ServiceDW.c_ModifyMode THEN
						l_Mode = i_ServiceDW.c_ModifyMode
					ELSEIF l_CurrentDW.i_RequestMode = i_ServiceDW.c_ViewMode THEN
						l_Mode = i_ServiceDW.c_ViewMode
					ELSE
						l_ModeOnSelect = l_CurrentDW.i_ModeOnSelect
						IF l_ModeOnSelect = i_ServiceDW.c_ModifyOnSelect THEN
							IF l_ChildrenDW[l_Idx].i_AllowModify THEN
								l_Mode = i_ServiceDW.c_ModifyMode
							ELSE
								l_Mode = i_ServiceDW.c_ViewMode
							END IF
						ELSEIF l_ModeOnSelect = i_ServiceDW.c_ViewOnSelect THEN
							l_Mode = i_ServiceDW.c_ViewMode
						ELSEIF l_ModeOnSelect = i_ServiceDW.c_ParentModeOnSelect THEN
							l_Mode = l_CurrentDW.i_CurrentMode
							IF l_Mode = "" THEN
								l_Mode = i_ServiceDW.c_ViewMode
							END IF
						ELSEIF l_ModeOnSelect = i_ServiceDW.c_SameModeOnSelect THEN
							l_Mode = l_ChildrenDW[l_Idx].i_CurrentMode
							IF l_Mode = "" THEN
								l_Mode = i_ServiceDW.c_ViewMode
							END IF
						END IF
					END IF
				END IF

				IF l_Mode = i_ServiceDW.c_ViewMode THEN
					l_ChildrenDW[l_Idx].fu_SetRedraw(i_ServiceDW.c_Off)
				END IF

				IF l_ShareDW[l_Idx] THEN
					l_ChildrenDW[l_Idx].i_IgnoreRFC = TRUE
					l_ChildrenDW[l_Idx].i_IgnoreVal = TRUE
					l_ChildrenDW[l_Idx].ScrollToRow(l_ChildrenDW[l_Idx].i_ParentDW.i_CursorRow)
					l_ChildrenDW[l_Idx].i_CursorRow = l_ChildrenDW[l_Idx].i_ParentDW.i_CursorRow
					l_ChildrenDW[l_Idx].i_IgnoreRFC = FALSE
					l_ChildrenDW[l_Idx].i_IgnoreVal = FALSE
				ELSE
					IF l_ChildrenDW[l_Idx].fu_Retrieve(i_ServiceDW.c_IgnoreChanges, &
						i_ServiceDW.c_NoReselectRows) <> c_Success THEN
						RETURN c_Fatal
					END IF
				END IF

				IF l_Mode = i_ServiceDW.c_ModifyMode THEN
					IF l_ChildrenDW[l_Idx].fu_Modify() <> c_Success THEN
						RETURN c_Fatal
					END IF
				ELSEIF l_Mode = i_ServiceDW.c_ViewMode THEN
					IF l_ChildrenDW[l_Idx].fu_View() <> c_Success THEN
						RETURN c_Fatal
					END IF
				END IF

				IF l_Mode = i_ServiceDW.c_ViewMode THEN
					l_ChildrenDW[l_Idx].fu_SetRedraw(i_ServiceDW.c_On)
				END IF

			NEXT

		END IF

	CASE i_ServiceDW.c_ResetChildren

		FOR l_Idx = 1 TO l_NumChildren
			IF NOT l_ShareDW[l_Idx] THEN
				IF l_ChildrenDW[l_Idx].i_IsInstance THEN
					Close(l_ChildrenDW[l_Idx].i_Window)
				ELSE
					IF l_ChildrenDW[l_Idx].fu_Reset(i_ServiceDW.c_IgnoreChanges) &
						<> c_Success THEN
						RETURN c_Fatal
					END IF
				END IF
			END IF
		NEXT

	CASE i_ServiceDW.c_NoRefreshChildren

		FOR l_Idx = 1 TO l_NumChildren
			IF l_ShareDW[l_Idx] THEN
				l_ChildrenDW[l_Idx].i_IgnoreRFC = TRUE
				l_ChildrenDW[l_Idx].i_IgnoreVal = TRUE
				l_ChildrenDW[l_Idx].ScrollToRow(l_ChildrenDW[l_Idx].i_ParentDW.i_CursorRow)
				l_ChildrenDW[l_Idx].i_IgnoreRFC = FALSE
				l_ChildrenDW[l_Idx].i_IgnoreVal = FALSE
		
				IF l_ChildrenDW[l_Idx].i_AllowNew THEN
					IF l_ChildrenDW[l_Idx].i_DWSRV_EDIT.fu_Modify() <> c_Success THEN
						RETURN c_Fatal
					END IF
				END IF
			END IF
		NEXT

END CHOOSE

RETURN c_Success
end function

public function long fu_getinstancerow (datawindow current_dw);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_GetInstanceRow
//  Description   : Find the row in the parent DataWindow that
//                  corresponds to this instance DataWindow.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The current instance DataWindow.
//
//  Return Value  : LONG -
//                     Row number in the parent DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_DW, l_ParentDW
BOOLEAN   l_Found
INTEGER   l_Idx, l_Jdx, l_MapKey[]
STRING    l_And, l_FindRow
STRING    l_ErrorStrings[]

//------------------------------------------------------------------
//  Get the current DataWindow and its parent.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF i_DW[l_Idx] = current_dw THEN
		l_DW = i_DW[l_Idx]
		l_ParentDW = i_ParentDW[l_Idx]
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  If this function is executed before there is data, just return.
//------------------------------------------------------------------

IF l_DW.RowCount() = 0 OR l_DW.i_IsEmpty THEN
	RETURN 0
END IF

//------------------------------------------------------------------
//  Make sure both this DataWindow and its parent have got their
//  columns.
//------------------------------------------------------------------

IF NOT l_DW.i_GotKeys THEN
	l_DW.fu_GetKeys()
END IF
IF NOT l_ParentDW.i_GotKeys THEN
	l_ParentDW.fu_GetKeys()
END IF

//------------------------------------------------------------------
//  Attempt to map the keys.
//------------------------------------------------------------------

l_Found = fu_MapKeys(l_ParentDW, l_DW, l_MapKey[])

//------------------------------------------------------------------
//  No map of the key could be found.
//------------------------------------------------------------------

IF NOT l_Found THEN
  	l_ErrorStrings[1] = "PowerClass Error"
  	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
  	l_ErrorStrings[3] = l_DW.i_Window.ClassName()
  	l_ErrorStrings[4] = l_DW.ClassName() + " - " + ClassName()
  	l_ErrorStrings[5] = "fu_GetInstanceRow"
	FWCA.MSG.fu_DisplayMessage("KeysInParentError", &
                              5, l_ErrorStrings[])
	RETURN c_Fatal
END IF

//------------------------------------------------------------------
//  Build the syntax for the FIND command.
//------------------------------------------------------------------

l_FindRow = ""
l_And = ""
FOR l_Jdx = 1 TO l_ParentDW.i_NumKeys
	CHOOSE CASE l_ParentDW.i_KeyTypes[l_Jdx]
		CASE "CHAR"
			l_FindRow = l_FindRow + l_And + &
							l_ParentDW.i_KeyColumns[l_Jdx] + " = '" + &
							l_DW.GetItemString(l_DW.i_CursorRow, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]) + "'"
		CASE "DATE"
			l_FindRow = l_FindRow + l_And + &
				         "Date(String(" + l_ParentDW.i_KeyColumns[l_Jdx] + ", '" + i_DateFormat + "')) = Date('" + &
				         String(l_DW.GetItemDate(l_DW.i_CursorRow, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]), i_DateFormat) + "')"
  		CASE "DATETIME"
			l_FindRow = l_FindRow + l_And + &
				         "DateTime(String(" + l_ParentDW.i_KeyColumns[l_Jdx] + ", '" + i_DateFormat + " " + i_TimeFormat + "')) = DateTime('" + &
				         String(l_DW.GetItemDateTime(l_DW.i_CursorRow, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]), i_DateFormat + " " + i_TimeFormat) + "')"
		CASE "TIME", "TIMESTAMP"
			l_FindRow = l_FindRow + l_And + &
				         "Time(String(" + l_ParentDW.i_KeyColumns[l_Jdx] + ", '" + i_TimeFormat + "')) = Time('" + &
				         String(l_DW.GetItemTime(l_DW.i_CursorRow, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]), i_TimeFormat) + "')"
		CASE "DEC"
			l_FindRow = l_FindRow + l_And + &
							l_ParentDW.i_KeyColumns[l_Jdx] + " = " + &
							String(l_DW.GetItemDecimal(l_DW.i_CursorRow, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
		CASE ELSE
			l_FindRow = l_FindRow + l_And + &
							l_ParentDW.i_KeyColumns[l_Jdx] + " = " + &
							String(l_DW.GetItemNumber(l_DW.i_CursorRow, l_DW.i_KeyColumns[l_MapKey[l_Jdx]]))
	END CHOOSE
	l_And = " AND "
NEXT

//------------------------------------------------------------------
//  Attempt to find the row in the parent that corresponds to the
//  key values.
//------------------------------------------------------------------

RETURN l_ParentDW.Find(l_FindRow, 1, l_ParentDW.RowCount())

end function

public subroutine fu_setinstance (datawindow current_dw);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_SetInstance
//  Description   : Set the given DataWindow as the current instance
//                  DataWindow.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The DataWindow to set as the current 
//                     instance.
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

i_CurrentInstanceDW = current_dw
end subroutine

public function boolean fu_checkinstance (datawindow current_dw);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_CheckInstance
//  Description   : Determine if the given DataWindow has any
//                  instance DataWindow children.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The parent DataWindow.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - children instance DataWindows exist.
//                     FALSE - children instance DataWindows don't
//                             exist.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

FOR l_Idx = 1 TO i_NumDW
	IF i_ParentDW[l_Idx] = current_dw THEN
		IF i_DW[l_Idx].i_IsInstance THEN
			RETURN TRUE
		END IF
	END IF
NEXT

RETURN FALSE
end function

public function boolean fu_mapkeys (u_dw_main parent_dw, u_dw_main child_dw, ref integer map_keys[]);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_MapKeys
//  Description   : Determine if the key columns between a parent
//                  and child DataWindow match.
//
//  Parameters    : DATAWINDOW Parent_DW -
//                     The parent DataWindow.
//                  DATAWINDOW Child_DW -
//                     The child DataWindow.
//                  INTEGER    Map_Keys[] -
//                     The map of the keys between the parent and
//                     child DataWindow.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - a complete map of the keys was found.
//                     FALSE - the map was incomplete.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Jdx, l_Pos
BOOLEAN l_Found
STRING  l_ParentKeyColumn

FOR l_Idx = 1 TO parent_dw.i_NumKeys

	//---------------------------------------------------------------
	//  Attempt the map with the column name first.
	//---------------------------------------------------------------

	l_ParentKeyColumn = parent_dw.i_KeyColumns[l_Idx]
	l_Found = FALSE
	FOR l_Jdx = 1 TO child_dw.i_NumKeys
		IF child_dw.i_KeyColumns[l_Jdx] = l_ParentKeyColumn THEN
			map_keys[l_Idx] = l_Jdx
			l_Found = TRUE
			EXIT
		END IF
	NEXT
	
	//---------------------------------------------------------------
	//  If not found with the column name, attempt the map with 
	//  the database "table.column" name
	//---------------------------------------------------------------

	IF NOT l_Found THEN
		l_ParentKeyColumn = parent_dw.i_KeyDBColumns[l_Idx]
		FOR l_Jdx = 1 TO child_dw.i_NumKeys
			IF child_dw.i_KeyDBColumns[l_Jdx] = l_ParentKeyColumn THEN
				map_keys[l_Idx] = l_Jdx
				l_Found = TRUE
				EXIT
			END IF
		NEXT
	END IF
	
	//------------------------------------------------------------
	//  If not found with the database column name, attempt the 
	//  map with only the database column name
	//------------------------------------------------------------

	IF NOT l_Found THEN
		l_Pos = POS(parent_dw.i_KeyDBColumns[l_Idx], ".")
		IF l_Pos > 0 THEN
			l_ParentKeyColumn = Mid(parent_dw.i_KeyDBColumns[l_Idx], l_Pos + 1)
			FOR l_Jdx = 1 TO child_dw.i_NumKeys
				l_Pos = POS(child_dw.i_KeyDBColumns[l_Jdx], ".")
				IF l_Pos > 0 THEN
					IF Mid(child_dw.i_KeyDBColumns[l_Jdx], l_Pos + 1) = l_ParentKeyColumn THEN
						map_keys[l_Idx] = l_Jdx
						l_Found = TRUE
						EXIT
					END IF
				END IF
			NEXT
		END IF
	END IF

	IF NOT l_Found THEN
		RETURN FALSE
	END IF
NEXT

RETURN TRUE
end function

public function boolean fu_findinstance (datawindow current_dw, long row_nbr);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_FindInstance
//  Description   : Determine if there is a child DataWindow
//                  instance that is already open for the given row.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The parent DataWindow.
//                  LONG       Row_Nbr -
//                     The selected row in the parent DataWindow.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - child instance DataWindow open.
//                     FALSE - child instance DataWindow not found.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_DW, l_ParentDW
BOOLEAN   l_Found
INTEGER   l_Idx, l_Jdx, l_MapKey[]
STRING    l_And, l_FindRow
LONG      l_Row

//------------------------------------------------------------------
//  Get the current DataWindow.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF i_DW[l_Idx] = current_dw THEN
		l_ParentDW = i_DW[l_Idx]
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  Make sure this DataWindow has its key columns.
//------------------------------------------------------------------

IF NOT l_ParentDW.i_GotKeys THEN
	l_ParentDW.fu_GetKeys()
END IF

//------------------------------------------------------------------
//  For each child DataWindow, attempt to map the keys and see if
//  the key values match with this DataWindows.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF i_ParentDW[l_Idx] = l_ParentDW THEN
		l_DW = i_DW[l_Idx]
		IF NOT l_DW.i_IsInstance THEN
			CONTINUE
		END IF

		//------------------------------------------------------------
		//  Make sure this DataWindow has its key columns.
		//------------------------------------------------------------

		IF NOT l_DW.i_GotKeys THEN
			l_DW.fu_GetKeys()
		END IF

		//------------------------------------------------------------
		//  Attempt to map the keys with the parent.
		//------------------------------------------------------------

		l_Found = fu_MapKeys(l_ParentDW, l_DW, l_MapKey[])

		IF NOT l_Found THEN
			RETURN FALSE
		END IF

		//------------------------------------------------------------
		//  Build the syntax for the FIND command.
		//------------------------------------------------------------

		l_FindRow = ""
		l_And = ""
		FOR l_Jdx = 1 TO l_ParentDW.i_NumKeys
			CHOOSE CASE l_ParentDW.i_KeyTypes[l_Jdx]
				CASE "CHAR"
					l_FindRow = l_FindRow + l_And + &
									l_DW.i_KeyColumns[l_MapKey[l_Jdx]] + " = '" + &
									l_ParentDW.GetItemString(row_nbr, l_ParentDW.i_KeyColumns[l_Jdx]) + "'"
				CASE "DATE"
					l_FindRow = l_FindRow + l_And + &
									"Date(String(" + l_DW.i_KeyColumns[l_MapKey[l_Jdx]] + ", '" + i_DateFormat + "')) = Date('" + &
									String(l_ParentDW.GetItemDate(row_nbr, l_ParentDW.i_KeyColumns[l_Jdx]), i_DateFormat) + "')"
				CASE "DATETIME"
					l_FindRow = l_FindRow + l_And + &
									"DateTime(String(" + l_DW.i_KeyColumns[l_MapKey[l_Jdx]] + ", '" + i_DateFormat + " " + i_TimeFormat + "')) = DateTime('" + &
									String(l_ParentDW.GetItemDateTime(row_nbr, l_ParentDW.i_KeyColumns[l_Jdx]), i_DateFormat + " " + i_TimeFormat) + "')"
				CASE "TIME", "TIMESTAMP"
					l_FindRow = l_FindRow + l_And + &
									"Time(String(" + l_DW.i_KeyColumns[l_MapKey[l_Jdx]] + ", '" + i_TimeFormat + "')) = Time('" + &
									String(l_ParentDW.GetItemTime(row_nbr, l_ParentDW.i_KeyColumns[l_Jdx]), i_TimeFormat) + "')"
				CASE "DEC"
					l_FindRow = l_FindRow + l_And + &
									l_DW.i_KeyColumns[l_MapKey[l_Jdx]] + " = " + &
									String(l_ParentDW.GetItemDecimal(row_nbr, l_ParentDW.i_KeyColumns[l_Jdx]))
				CASE ELSE
					l_FindRow = l_FindRow + l_And + &
									l_DW.i_KeyColumns[l_MapKey[l_Jdx]] + " = " + &
									String(l_ParentDW.GetItemNumber(row_nbr, l_ParentDW.i_KeyColumns[l_Jdx]))
			END CHOOSE
			l_And = " AND "
		NEXT

		//------------------------------------------------------------
		//  Attempt to find the child row.
		//------------------------------------------------------------

		l_Row = l_DW.Find(l_FindRow, 1, 1)
		IF l_Row > 0 THEN
			l_DW.fu_Activate()
			RETURN TRUE
		END IF
	END IF
NEXT

RETURN FALSE
end function

public function integer fu_getchildren (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[]);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_GetChildren
//  Description   : Returns the DataWindows in the unit-of-work
//                  that are the immediate children of the given
//                  DataWindow.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The starting DataWindow in the list of
//                     DataWindows.
//                  U_DW_MAIN  Children_DW[] -
//                     The DataWindows immediately below the 
//                     current DataWindow.
//                  BOOLEAN    Share_DW[] -
//                     Is the DataWindow a share?
//
//  Return Value  : INTEGER -
//                     The number of children DataWindows.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER   l_Idx, l_NumChildren
U_DW_MAIN l_CurrentInstanceDW

//------------------------------------------------------------------
//  Find out if the current DataWindow has instance DataWindow
//  children.  If it does, just return the instance DataWindow that
//  is current.  We don't want to refresh other instances unless
//  they are on the same window.
//------------------------------------------------------------------

l_NumChildren = 0
IF fu_CheckInstance(current_dw) THEN
	IF IsValid(i_CurrentInstanceDW) THEN
		l_CurrentInstanceDW = i_CurrentInstanceDW
		FOR l_Idx = 1 TO i_NumDW
			IF i_ParentDW[l_Idx] = current_dw AND &
				(i_DW[l_Idx] = l_CurrentInstanceDW OR &
				i_DW[l_Idx].i_Window = l_CurrentInstanceDW.i_Window) THEN
				l_NumChildren = l_NumChildren + 1
				children_dw[l_NumChildren] = i_DW[l_Idx]
         	share_dw[l_NumChildren] = i_ShareDW[l_Idx]
			END IF
		NEXT
	END IF
ELSE
	FOR l_Idx = 1 TO i_NumDW
		IF i_ParentDW[l_Idx] = current_dw THEN
			l_NumChildren = l_NumChildren + 1
			children_dw[l_NumChildren] = i_DW[l_Idx]
         share_dw[l_NumChildren] = i_ShareDW[l_Idx]
		END IF
	NEXT
END IF

RETURN l_NumChildren
end function

public function integer fu_getchildrencnt (datawindow current_dw);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_GetChildrenCnt
//  Description   : Returns the number of DataWindows in the 
//                  unit-of-work that are the immediate children of
//                  the given DataWindow.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The starting DataWindow in the list of
//                     DataWindows.
//
//  Return Value  : INTEGER -
//                     The number of children DataWindows.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER   l_Idx, l_NumChildren
U_DW_MAIN l_CurrentInstanceDW

//------------------------------------------------------------------
//  Find out if the current DataWindow has instance DataWindow
//  children.  If it does, just return the instance DataWindow that
//  is current unless others are on the same window.
//------------------------------------------------------------------

l_NumChildren = 0
IF fu_CheckInstance(current_dw) THEN
	IF IsValid(i_CurrentInstanceDW) THEN
		l_CurrentInstanceDW = i_CurrentInstanceDW
		FOR l_Idx = 1 TO i_NumDW
			IF i_ParentDW[l_Idx] = current_dw AND &
				(i_DW[l_Idx] = l_CurrentInstanceDW OR &
				i_DW[l_Idx].i_Window = l_CurrentInstanceDW.i_Window) THEN
				l_NumChildren = l_NumChildren + 1
			END IF
		NEXT
	END IF
ELSE
	FOR l_Idx = 1 TO i_NumDW
		IF i_ParentDW[l_Idx] = current_dw THEN
			l_NumChildren = l_NumChildren + 1
		END IF
	NEXT
END IF

RETURN l_NumChildren
end function

public function integer fu_save (datawindow current_dw, integer changes, integer check_who);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_Save
//  Description   : Updates all the DataWindows in the unit-of-work
//                  to the database.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The DataWindow that fu_Save was called from.
//                  INTEGER    Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_PromptChanges
//                        c_SaveChanges
//                  INTEGER    Check_Who -
//                     Determine the DataWindows to check.
//                     Values are:
//                        c_CheckAll
//                        c_CheckChildren
//
//  Return Value  : INTEGER -
//                      0 - save operation successful.
//                     -1 - save operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change / Number
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER      l_Answer, l_NumChangeWindows, l_Idx, l_Jdx, l_Return
INTEGER      l_CurrentIdx, l_CloseIndex, l_RefreshIndex, l_Kdx
LONG         l_Row
REAL         l_PromptNumbers[]
STRING       l_PromptStrings[], l_ID
BOOLEAN      l_Changes, l_Found, l_ChangeDW[], l_Highlight
BOOLEAN      l_WindowMinimized[], l_CheckDW[], l_Finished
WINDOW       l_Window, l_ChangeWindows[]
DATAWINDOW   l_FindDW, l_RefreshedDW[]

//------------------------------------------------------------------
//  Determine if the calling routine requires all DataWindows 
//  to be checked for changes or just the children of the calling
//  DataWindow. 
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF IsValid(i_DW[l_Idx].i_DWSRV_EDIT) THEN
		i_DW[l_Idx].i_DWSRV_EDIT.i_InSave = TRUE
	END IF

	IF check_who <> i_ServiceDW.c_CheckChildren THEN
		l_CheckDW[l_Idx] = TRUE
	ELSE
		l_CheckDW[l_Idx] = FALSE
	END IF

	IF i_DW[l_Idx] = current_dw THEN
		l_CurrentIdx = l_Idx
	END IF
NEXT

IF check_who = i_ServiceDW.c_CheckChildren THEN
	IF l_CurrentIdx <> i_NumDW THEN
		l_CurrentIdx = l_CurrentIdx + 1
		l_FindDW     = current_dw
		l_Finished   = FALSE
		DO
			FOR l_Idx = l_CurrentIdx TO i_NumDW
				IF i_ParentDW[l_Idx] = l_FindDW THEN
					l_CheckDW[l_Idx] = TRUE
				END IF
			NEXT
			
			l_Finished = TRUE
			IF l_CurrentIdx < i_NumDW THEN
				FOR l_Idx = l_CurrentIdx TO i_NumDW
					IF l_CheckDW[l_Idx] THEN
						l_FindDW = i_DW[l_Idx]
						l_CurrentIdx = l_CurrentIdx + 1
						l_Finished = FALSE
						EXIT
					END IF
				NEXT
			END IF
		LOOP UNTIL l_Finished
	END IF
END IF

//------------------------------------------------------------------
//  Check for changes in the unit-of-work.  Determine how many
//  DataWindows and windows are involved. 
//------------------------------------------------------------------

l_NumChangeWindows = 0
FOR l_Idx = 1 TO i_NumDW
	l_Changes = FALSE
	l_ChangeDW[l_Idx] = FALSE
	IF l_CheckDW[l_Idx] THEN
		l_Changes = i_DW[l_Idx].fu_CheckChanges()
	END IF

	IF l_Changes THEN
		l_ChangeDW[l_Idx] = TRUE
		l_Window = i_DW[l_Idx].i_Window
		l_Found = FALSE
		FOR l_Jdx = 1 TO l_NumChangeWindows
			IF l_ChangeWindows[l_Jdx] = l_Window THEN
				l_Found = TRUE
				EXIT
			END IF
		NEXT
		IF NOT l_Found THEN
			l_NumChangeWindows = l_NumChangeWindows + 1
			l_ChangeWindows[l_NumChangeWindows] = l_Window
		END IF

		//------------------------------------------------------------
		//  If the parent DataWindow is to be refreshed then
		//  make sure it is set to be checked too. 
		//------------------------------------------------------------

		IF check_who = i_ServiceDW.c_CheckChildren THEN
			l_Changes = FALSE
			IF i_ParentDW[l_Idx] = current_dw AND &
				i_DW[l_Idx].i_RefreshParent THEN
				FOR l_Jdx = 1 TO l_Idx
					IF i_DW[l_Jdx] = current_dw THEN
						l_CheckDW[l_Jdx] = TRUE
						IF i_DW[l_Jdx].fu_CheckChanges() THEN
							l_ChangeDW[l_Jdx] = TRUE
							l_Window = i_DW[l_Jdx].i_Window
							l_Found = FALSE
							FOR l_Kdx = 1 TO l_NumChangeWindows
								IF l_ChangeWindows[l_Kdx] = l_Window THEN
									l_Found = TRUE
									EXIT
								END IF
							NEXT
							IF NOT l_Found THEN
								l_NumChangeWindows = l_NumChangeWindows + 1
								l_ChangeWindows[l_NumChangeWindows] = l_Window
							END IF
						END IF
						EXIT
					END IF
				NEXT
			END IF
		END IF
	END IF
NEXT

//------------------------------------------------------------------
//  If changes were found and c_PromptChanges is given then 
//  prompt the user for changes. 
//------------------------------------------------------------------

i_SaveStatus = 1

IF l_NumChangeWindows > 0 AND changes = c_PromptChanges THEN

	//---------------------------------------------------------------
	//  If the inactive color option has been requested for any of
	//  the modified DataWindows then return the color of all text 
	//  in the DataWindow to its original color.
	//---------------------------------------------------------------

	l_Highlight = FALSE
	FOR l_Idx = 1 TO i_NumDW
		IF IsValid(i_DW[l_Idx].i_DWSRV_CUES) THEN
			IF IsNull(i_DW[l_Idx].i_InactiveColor) = FALSE THEN
				IF l_ChangeDW[l_Idx] THEN
   				l_Highlight = TRUE
					i_DW[l_Idx].i_DWSRV_CUES.fu_SetInactiveMode(c_No)
				ELSE
   				l_Highlight = TRUE
					i_DW[l_Idx].i_DWSRV_CUES.fu_SetInactiveMode(c_Yes)
				END IF
			END IF
		END IF
	NEXT

	//---------------------------------------------------------------
	//  If the window that has changes in it is minimized then make 
	//  it normal.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO l_NumChangeWindows
		IF l_ChangeWindows[l_Idx].WindowState = Minimized! THEN
			l_WindowMinimized[l_Idx] = TRUE
			l_ChangeWindows[l_Idx].WindowState = Normal!
		ELSE
			l_WindowMinimized[l_Idx] = FALSE
		END IF
	NEXT

	//---------------------------------------------------------------
	//  Determine what type of prompt to put up.
	//---------------------------------------------------------------

	IF l_NumChangeWindows > 1 THEN
		IF l_Highlight THEN
			l_ID = "ChangesHighlight"
		ELSE
			l_ID = "Changes"
		END IF
	ELSE
		IF l_Highlight THEN
			l_ID = "ChangesOneHighlight"
		ELSE
			l_ID = "ChangesOne"
		END IF
	END IF

	l_PromptNumbers[1] = l_NumChangeWindows
	l_PromptStrings[1] = "PowerClass Prompt"
	l_PromptStrings[2] = FWCA.MGR.i_ApplicationName
	l_PromptStrings[3] = i_DW[1].i_Window.ClassName()
	l_PromptStrings[4] = i_DW[1].ClassName() + " - " + ClassName()
	l_PromptStrings[5] = "fu_Save"

	l_Answer = FWCA.MSG.fu_DisplayMessage(l_ID, 1, l_PromptNumbers[], &
                                         5, l_PromptStrings[])


	//---------------------------------------------------------------
	//  If the inactive color was changed for prompting, change it
	//  back now.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO i_NumDW
		IF IsValid(i_DW[l_Idx].i_DWSRV_CUES) THEN
			IF IsNull(i_DW[l_Idx].i_InactiveColor) = FALSE THEN
				IF l_ChangeDW[l_Idx] THEN
					IF i_DW[l_Idx].i_IsCurrent THEN
   					i_DW[l_Idx].i_DWSRV_CUES.fu_SetInactiveMode(c_No)
					ELSE
   					i_DW[l_Idx].i_DWSRV_CUES.fu_SetInactiveMode(c_Yes)
					END IF
				ELSE
					IF i_DW[l_Idx].i_IsCurrent THEN
   					i_DW[l_Idx].i_DWSRV_CUES.fu_SetInactiveMode(c_No)
					ELSE
   					i_DW[l_Idx].i_DWSRV_CUES.fu_SetInactiveMode(c_Yes)
					END IF
				END IF
			END IF
		END IF
	NEXT

	//---------------------------------------------------------------
	//  If the window that has changes was minimized before the 
	//  prompt then change it back to minimized.
	//---------------------------------------------------------------

	FOR l_Idx = 1 TO l_NumChangeWindows
		IF l_WindowMinimized[l_Idx] THEN
			l_ChangeWindows[l_Idx].WindowState = Minimized!
		END IF
	NEXT

	//---------------------------------------------------------------
	//  Process the answer.
	//---------------------------------------------------------------

	IF l_Answer = 2 THEN

		//------------------------------------------------------------
		//  Since "NO" was clicked, we need to reset the datwindow(s).
		//------------------------------------------------------------

		fu_ResetUpdateUOW()
		i_SaveStatus = 2
		l_Return = c_Success
		GOTO Finished
	ELSEIF l_Answer = 3 THEN
		i_SaveStatus = 3
		l_Return = c_Fatal
		GOTO Finished
	END IF
ELSEIF l_NumChangeWindows = 0 THEN
	i_SaveStatus = 0
	l_Return = c_Success
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Validate the changed DataWindows. 
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF l_ChangeDW[l_Idx] THEN
		IF i_DW[l_Idx].fu_Validate() <> c_Success THEN
			i_DW[l_Idx].fu_Activate()
			l_Return = c_Fatal
			GOTO Finished
		END IF
	//---------------------------------------------------------------
	//  If the datawindow is not changed, trigger the 
	//  pcd_ValidateBefore and pcd_ValidateAfter events for the 
	//  developer so outside objects associated with the datawindow
	//  may be validated. 
	//---------------------------------------------------------------

	ELSE
		IF IsValid(i_DW[l_Idx].i_DWSRV_EDIT) THEN
			Error.i_FWError = c_Success

			IF IsValid(FWCA.MDI) THEN
				IF FWCA.MGR.i_ShowMicrohelp THEN
	   			FWCA.MDI.fu_SetMicroHelp("Validate")
				END IF
			END IF

			//---------------------------------------------------------
			//  Process the pcd_ValidateBefore event. 
			//---------------------------------------------------------

			i_DW[l_Idx].Event pcd_ValidateBefore(i_DW[l_Idx].i_DWSRV_EDIT.i_InSave)
			IF Error.i_FWError <> c_Success THEN
				l_Return = c_Fatal
				GOTO Finished
			ELSE
				Error.i_FWError = c_Success
			END IF

			//---------------------------------------------------------
			//  Process the pcd_ValidateAfter event. 
			//---------------------------------------------------------

			i_DW[l_Idx].Event pcd_ValidateAfter(i_DW[l_Idx].i_DWSRV_EDIT.i_InSave)
			IF Error.i_FWError <> c_Success THEN
				l_Return = c_Fatal
				GOTO Finished
			ELSE
				Error.i_FWError = c_Success
			END IF

			//---------------------------------------------------------
			//  Check for changes to the datawindow after the
			//  validation.  If the validate events changed the
			//  datawindow, mark it for update.
			//---------------------------------------------------------

			l_ChangeDW[l_Idx] = i_DW[l_Idx].fu_CheckChanges()

		END IF
	END IF
NEXT

//------------------------------------------------------------------
//  If any of the changed DataWindows are shared, then mark the
//  parent DataWindow as changed instead of the child.  This 
//  prevents multiple saves on the same buffer of data.
//------------------------------------------------------------------

FOR l_Idx = i_NumDW TO 1 STEP -1
	IF i_DW[l_Idx].i_ShareData AND l_ChangeDW[l_Idx] THEN
		l_ChangeDW[l_Idx] = FALSE
		FOR l_Jdx = l_Idx TO 1 STEP -1
			IF i_DW[l_Jdx] = i_ParentDW[l_Idx] THEN
				l_ChangeDW[l_Jdx] = TRUE
				IF IsValid(i_DW[l_Idx].i_DWSRV_EDIT) THEN
					IF i_DW[l_Idx].i_DWSRV_EDIT.i_HaveNew THEN
						i_DW[l_Idx].i_DWSRV_EDIT.i_HaveNew    = FALSE
						i_DW[l_Jdx].i_DWSRV_EDIT.i_HaveNew    = TRUE
						i_DW[l_Idx].i_DWSRV_EDIT.i_HaveModify = FALSE
						i_DW[l_Jdx].i_DWSRV_EDIT.i_HaveModify = TRUE
					END IF
				END IF
			END IF
		NEXT
	END IF
NEXT

//------------------------------------------------------------------
//  Trigger the pcd_SaveBefore event for the developer on the root
//  level DataWindow.
//------------------------------------------------------------------

i_RootDW.Event pcd_SaveBefore(i_RootDW.i_DBCA)
IF Error.i_FWError <> c_Success THEN
	l_Return = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Attempt to save the changed DataWindows.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF l_ChangeDW[l_Idx] THEN
		IF i_DW[l_Idx] = current_dw THEN
			l_CurrentIdx = l_Idx
		END IF
		IF i_DW[l_Idx].fu_Save(c_SaveChanges) <> c_Success THEN
			l_Return = c_Fatal
			GOTO Finished
		END IF
	END IF
NEXT

//------------------------------------------------------------------
//  If the unit-of-work save was successful, commit the changes.
//------------------------------------------------------------------

FOR l_Idx = 1 to i_NumDW
	IF l_ChangeDW[l_Idx] THEN
		IF i_DW[l_Idx].fu_Commit() <> c_Success THEN
			l_Return = c_Fatal
			GOTO Finished
		ELSE
			EXIT
		END IF
	END IF
NEXT

//------------------------------------------------------------------
//  Trigger the pcd_SaveAfter event for the developer on the root
//  level DataWindow.
//------------------------------------------------------------------

i_RootDW.Event pcd_SaveAfter(i_RootDW.i_DBCA)
IF Error.i_FWError <> c_Success THEN
	l_Return = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  Refresh any parent DataWindows.  If we are in a window closing
//  situation then only refresh parent DataWindows that are not
//  on windows that are closing.
//------------------------------------------------------------------

IF i_InClose THEN

	l_CloseIndex = 1
	FOR l_Idx = 1 TO i_NumDW
		IF i_DW[l_Idx].i_Window = i_CloseWindow THEN
			l_CloseIndex = l_Idx
			EXIT
		END IF
	NEXT

	IF l_CloseIndex > 1 THEN
		l_Kdx = 0
		FOR l_Idx = i_NumDW TO l_CloseIndex STEP -1
			IF l_ChangeDW[l_Idx] AND i_DW[l_Idx].i_RefreshParent THEN
				FOR l_Jdx = 1 TO l_CloseIndex
					IF i_ParentDW[l_Idx] = i_DW[l_Jdx] THEN
						l_RefreshIndex = l_Jdx
						EXIT
					END IF
				NEXT
				IF l_RefreshIndex < l_CloseIndex THEN
					l_Found = FALSE
					FOR l_Jdx = 1 TO l_Kdx
						IF i_ParentDW[l_Idx] = l_RefreshedDW[l_Jdx] THEN
							l_Found = TRUE
							EXIT
						END IF
					NEXT
					IF NOT l_Found THEN
						IF fu_RefreshParent(l_Idx) <> c_Success THEN
							l_Return = c_Fatal
							GOTO Finished
						ELSE
							l_Kdx = l_Kdx + 1
							l_RefreshedDW[l_Kdx] = i_ParentDW[l_Idx]
						END IF
					END IF
				END IF
			END IF
		NEXT
	END IF

ELSE

	l_Kdx = 0
	FOR l_Idx = i_NumDW TO 2 STEP -1
		IF l_ChangeDW[l_Idx] OR fu_GetChildrenCnt(i_DW[l_Idx]) > 0 THEN
			IF i_DW[l_Idx].i_RefreshParent THEN
				l_Found = FALSE
				FOR l_Jdx = 1 TO l_Kdx
					IF i_ParentDW[l_Idx] = l_RefreshedDW[l_Jdx] THEN
						l_Found = TRUE
						EXIT
					END IF
				NEXT
				IF NOT l_Found THEN
					IF fu_RefreshParent(l_Idx) <> c_Success THEN
						l_Return = c_Fatal
						GOTO Finished
					ELSE
						l_Kdx = l_Kdx + 1
						l_RefreshedDW[l_Kdx] = i_ParentDW[l_Idx]
					END IF
				END IF
			END IF
		END IF
	NEXT

	//---------------------------------------------------------------
	//  If the current DataWindow is in this UOW and it is an
	//  instance then make sure the parent row is in sync with the
	//  instance row.
	//---------------------------------------------------------------

	FOR l_Idx = i_NumDW TO 2 STEP -1
		IF i_DW[l_Idx] = FWCA.MGR.i_WindowCurrentDW THEN
			IF i_DW[l_Idx].i_IsInstance THEN
   			l_Row = fu_GetInstanceRow(i_DW[l_Idx])
			   IF l_Row >  0 THEN
					i_ParentDW[l_Idx].fu_Select(i_ServiceDW.c_SelectOnScroll, l_Row, &
						                         "", FALSE, FALSE)
				END IF
			END IF
			EXIT
		END IF
	NEXT				

END IF

//------------------------------------------------------------------
//  Reset the update flags.
//------------------------------------------------------------------

fu_ResetUpdateUOW()

FOR l_Idx = 1 TO i_NumDW
	IF i_DW[l_Idx].i_ViewAfterSave THEN
		i_DW[l_Idx].fu_View()
	END IF
NEXT

l_Return = c_Success

Finished:

//------------------------------------------------------------------
//  Reset the InSave and InClose flags.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF IsValid(i_DW[l_Idx].i_DWSRV_EDIT) THEN
		i_DW[l_Idx].i_DWSRV_EDIT.i_InSave = FALSE
	END IF
NEXT

i_InClose = FALSE

//------------------------------------------------------------------
//  Display the default prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("")
	END IF
END IF

RETURN l_Return

end function

public function integer fu_view (datawindow current_dw, integer refresh);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_View
//  Description   : Put children DataWindows into View mode.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     DataWindow that has children DataWindows.
//                  INTEGER    Refresh    -
//                     Determines if a refresh should occur before
//                     the mode is set.  Values are:
//                        c_AutoRefreshChildren
//                        c_RefreshChildren
//
//  Return Value  : INTEGER -
//                      0 - view operation successful.
//                     -1 - view operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_ChildrenDW[], l_CurrentDW
INTEGER   l_NumChildren, l_Idx, l_ActivateIndex, l_RefreshChildren
BOOLEAN   l_Found, l_ShareDW[]
WINDOW    l_Window

IF i_InModeChange THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Get the immediate children to the given DataWindow.
//------------------------------------------------------------------

i_InModeChange = TRUE
l_NumChildren = fu_GetChildrenList(current_dw, l_ChildrenDW[], l_ShareDW[])

//------------------------------------------------------------------
//  Determine if we can just put the children into view mode or
//  if rows need to be loaded first.
//------------------------------------------------------------------

l_CurrentDW = current_dw
l_RefreshChildren = refresh
IF l_RefreshChildren = l_CurrentDW.c_AutoRefreshChildren THEN
	l_RefreshChildren = l_CurrentDW.c_RefreshChildren
	IF NOT l_CurrentDW.i_MultiSelect OR &
		(l_CurrentDW.i_MultiSelect AND &
	 	l_CurrentDW.i_MultiSelectMethod = l_CurrentDW.c_RefreshOnMultiSelect) OR &
		(l_CurrentDW.i_MultiSelect AND l_CurrentDW.i_NumSelected = 1 AND &
	 	l_CurrentDW.i_MultiSelectMethod <> l_CurrentDW.c_RefreshOnMultiSelect) THEN
		l_RefreshChildren = l_CurrentDW.c_NoRefreshChildren
	END IF
END IF

//------------------------------------------------------------------
//  Refresh the children if we have to.
//------------------------------------------------------------------

IF l_RefreshChildren = l_CurrentDW.c_RefreshChildren THEN
	IF fu_Refresh(current_dw, l_RefreshChildren, &
                 l_CurrentDW.c_ViewMode) <> c_Success THEN
		i_InModeChange = FALSE
		RETURN c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  If a refresh was not done then put each child into view mode.
//  If any of the children are on the same window as the 
//  parent then determine which one to activate.  If multiple 
//  children are on the same window, we don't know which one to 
//  activate so we will leave it on the parent and let the developer
//  decide.
//------------------------------------------------------------------

l_Window = current_dw.DYNAMIC fu_GetWindow()
l_Found = FALSE
l_ActivateIndex = 0
FOR l_Idx = 1 TO l_NumChildren
	IF NOT l_ChildrenDW[l_Idx].i_IsEmpty THEN
		IF l_RefreshChildren <> l_CurrentDW.c_RefreshChildren AND &
         l_CurrentDW.i_ModeOnSelect <> l_CurrentDW.c_ModifyOnSelect THEN
			IF l_ChildrenDW[l_Idx].fu_View() <> c_Success THEN
				i_InModeChange = FALSE
				RETURN c_Fatal
			END IF
		END IF
		IF l_ChildrenDW[l_Idx].i_Window = l_Window THEN
			IF NOT l_Found THEN
				l_ActivateIndex = l_Idx
				l_Found = TRUE
			ELSE
				l_ActivateIndex = 0
			END IF
		ELSE
			l_ActivateIndex = 0
			l_Found = TRUE
		END IF
	END IF
NEXT

IF l_ActivateIndex > 0 THEN
	l_ChildrenDW[l_ActivateIndex].fu_Activate()
END IF

i_InModeChange = FALSE

RETURN c_Success
end function

public function integer fu_modify (datawindow current_dw, integer refresh);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_Modify
//  Description   : Put children DataWindows into Modify mode.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     DataWindow that has children DataWindows.
//                  INTEGER    Refresh    -
//                     Determines if a refresh should occur before
//                     the mode is set.  Values are:
//                        c_AutoRefreshChildren
//                        c_RefreshChildren
//
//  Return Value  : INTEGER -
//                      0 - modify operation successful.
//                     -1 - modify operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

U_DW_MAIN l_ChildrenDW[], l_CurrentDW
INTEGER   l_NumChildren, l_Idx, l_ActivateIndex, l_RefreshChildren
BOOLEAN   l_Found, l_ShareDW[]
WINDOW    l_Window

IF i_InModeChange THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Get the immediate children to the given DataWindow.
//------------------------------------------------------------------

i_InModeChange = TRUE
l_NumChildren = fu_GetChildrenList(current_dw, l_ChildrenDW[], l_ShareDW[])

//------------------------------------------------------------------
//  Determine if we can just put the children into modify mode or
//  if rows need to be loaded first.
//------------------------------------------------------------------

l_CurrentDW = current_dw
l_RefreshChildren = refresh
IF l_RefreshChildren = l_CurrentDW.c_AutoRefreshChildren THEN
	l_RefreshChildren = l_CurrentDW.c_RefreshChildren
	IF NOT l_CurrentDW.i_MultiSelect OR &
		(l_CurrentDW.i_MultiSelect AND &
		l_CurrentDW.i_MultiSelectMethod = l_CurrentDW.c_RefreshOnMultiSelect) OR &
		(l_CurrentDW.i_MultiSelect AND l_CurrentDW.i_NumSelected = 1 AND &
	 	l_CurrentDW.i_MultiSelectMethod <> l_CurrentDW.c_RefreshOnMultiSelect) THEN
		l_RefreshChildren = l_CurrentDW.c_NoRefreshChildren
	END IF
END IF

//------------------------------------------------------------------
//  Refresh the children if we have to.
//------------------------------------------------------------------

IF l_RefreshChildren = l_CurrentDW.c_RefreshChildren THEN
	IF fu_Refresh(current_dw, l_RefreshChildren, &
                 l_CurrentDW.c_ModifyMode) <> c_Success THEN
		i_InModeChange = FALSE
		RETURN c_Fatal
	END IF
END IF

//------------------------------------------------------------------
//  If a refresh was not done then put each child into modify mode.
//  If any of the children are on the same window as the 
//  parent then determine which one to activate.  If multiple 
//  children are on the same window, we don't know which one to 
//  activate so we will leave it on the parent and let the developer
//  decide.
//------------------------------------------------------------------

l_Window = current_dw.DYNAMIC fu_GetWindow()
l_Found = FALSE
l_ActivateIndex = 0
FOR l_Idx = 1 TO l_NumChildren
	IF NOT l_ChildrenDW[l_Idx].i_IsEmpty THEN
		IF l_RefreshChildren <> l_CurrentDW.c_RefreshChildren THEN
			IF l_ChildrenDW[l_Idx].i_AllowModify THEN
				IF l_ChildrenDW[l_Idx].fu_Modify() <> c_Success THEN
					i_InModeChange = FALSE
					RETURN c_Fatal
				END IF
			END IF
		END IF
		IF l_ChildrenDW[l_Idx].i_AllowModify THEN
			IF l_ChildrenDW[l_Idx].i_Window = l_Window THEN
				IF NOT l_Found THEN
					l_ActivateIndex = l_Idx
					l_Found = TRUE
				ELSE
					l_ActivateIndex = 0
				END IF
			ELSE
				l_ActivateIndex = 0
				l_Found = TRUE
			END IF
		END IF
	END IF
NEXT

IF l_ActivateIndex > 0 THEN
	l_ChildrenDW[l_ActivateIndex].fu_Activate()
END IF

i_InModeChange = FALSE

RETURN c_Success
end function

public function boolean fu_findshare (datawindow current_dw);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_FindShare
//  Description   : Determines if all children DataWindows are
//                  sharing with the parent.  If any one DataWindow
//                  is not a share then return FALSE.  Used to
//                  determine if a Save should be done when the
//                  parent's DataWindow record is changed.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The starting DataWindow in the list of
//                     DataWindows.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - all children are shares
//                     FALSE - at least one child is not a share
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

FOR l_Idx = 1 TO i_NumDW
	IF i_ParentDW[l_Idx] = current_dw THEN
		IF NOT i_ShareDW[l_Idx] THEN
			RETURN FALSE
		ELSE
			RETURN TRUE
		END IF
	END IF
NEXT

RETURN FALSE
end function

public function integer fu_getchildrenlist (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[]);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_GetChildrenList
//  Description   : Returns the DataWindows in the unit-of-work
//                  that are in the chain of the given DataWindow.
//
//  Parameters    : DATAWINDOW Current_DW -
//                     The starting DataWindow in the list of
//                     DataWindows.
//                  U_DW_MAIN  Children_DW[] -
//                     The DataWindows below the current
//                     DataWindow.
//                  BOOLEAN    Share_DW[] -
//                     Is the DataWindow a share?
//
//  Return Value  : INTEGER -
//                     The number of children DataWindows.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_Idx, l_NumChildren, l_StartIndex, l_CurrentIndex
BOOLEAN    l_Finished
DATAWINDOW l_FindDW

//------------------------------------------------------------------
//  Find the given DataWindow in the list.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumDW
	IF current_dw = i_DW[l_Idx] THEN
		l_StartIndex = l_Idx
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  If the given DataWindow is last in the list then it can't have
//  any children.  If not, start searching for children at the next
//  DataWindow in the list.
//------------------------------------------------------------------

IF l_StartIndex <> i_NumDW THEN
	l_StartIndex = l_StartIndex + 1
ELSE
	RETURN 0
END IF

//------------------------------------------------------------------
//  Find each child DataWindow in the current DataWindow's chain.
//  As DataWindows are added, use them to find their children.
//------------------------------------------------------------------

l_FindDW       = current_dw
l_CurrentIndex = 0
l_NumChildren  = 0
l_Finished     = FALSE

DO
	FOR l_Idx = l_StartIndex TO i_NumDW
		IF i_ParentDW[l_Idx] = l_FindDW THEN
			l_NumChildren = l_NumChildren + 1
			children_dw[l_NumChildren] = i_DW[l_Idx]
         share_dw[l_NumChildren] = i_ShareDW[l_Idx]
		END IF
	NEXT
	IF l_CurrentIndex < l_NumChildren THEN
		l_CurrentIndex = l_CurrentIndex + 1
		l_FindDW = children_dw[l_CurrentIndex]
	ELSE
		l_Finished = TRUE
	END IF
LOOP UNTIL l_Finished

RETURN l_NumChildren
end function

public function string fu_buildfind (u_dw_main parent_dw, u_dw_main dw_name, integer index, integer map_key[]);//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_BuildFind
//  Description   : Build a FIND syntax using key columns.
//
//  Parameters    : U_DW_MAIN Parent_DW -
//                     Parent DataWindow.
//                  U_DW_MAIN DW_Name -
//                    Current DataWindow.
//                  INTEGER   Index -
//                     Index into the current DataWindow key array.
//                  INTEGER   Map_Key[]
//                     Maps to the key column on the parent dw.
//
//  Return Value  : STRING -
//                      FIND syntax.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER   l_Idx, l_MapKey[], l_Pos
STRING    l_FindRow, l_And, l_DateStr
LONG		 l_Maploop

l_MapKey[] = Map_Key[]
l_FindRow = ""
l_And = ""

IF parent_dw.i_NumKeys > UpperBound(l_MapKey[]) THEN
	l_Maploop = UpperBound(l_MapKey[])
ELSE
	l_Maploop = parent_dw.i_NumKeys	
END IF
	
FOR l_Idx = 1 TO l_Maploop
	CHOOSE CASE parent_dw.i_KeyTypes[l_Idx]
		CASE "CHAR"
			l_FindRow = l_FindRow + l_And + &
				parent_dw.i_KeyColumns[l_Idx] + " = '" + &
				dw_name.GetItemString(index, dw_name.i_KeyColumns[l_MapKey[l_Idx]]) + "'"
		CASE "DATE"
			l_FindRow = l_FindRow + l_And + &
				"Date(String(" + parent_dw.i_KeyColumns[l_Idx] + ", '" + i_DateFormat + "')) = Date('" + &
				String(dw_name.GetItemDate(index, dw_name.i_KeyColumns[l_MapKey[l_Idx]]), i_DateFormat) + "')"
  		CASE "DATETIME"
			l_FindRow = l_FindRow + l_And + &
				"DateTime(String(" + parent_dw.i_KeyColumns[l_Idx] + ", '" + i_DateFormat + " " + i_TimeFormat + "')) = DateTime('" + &
				String(dw_name.GetItemDateTime(index, dw_name.i_KeyColumns[l_MapKey[l_Idx]]), i_DateFormat + " " + i_TimeFormat) + "')"
		CASE "TIME", "TIMESTAMP"
			l_FindRow = l_FindRow + l_And + &
				"Time(String(" + parent_dw.i_KeyColumns[l_Idx] + ", '" + i_TimeFormat + "')) = Time('" + &
				String(dw_name.GetItemTime(index, dw_name.i_KeyColumns[l_MapKey[l_Idx]]), i_TimeFormat) + "')"
		CASE "DEC"
			l_FindRow = l_FindRow + l_And + &
				parent_dw.i_KeyColumns[l_Idx] + " = " + &
				String(dw_name.GetItemDecimal(index, dw_name.i_KeyColumns[l_MapKey[l_Idx]]))
		CASE ELSE
			l_FindRow = l_FindRow + l_And + &
				parent_dw.i_KeyColumns[l_Idx] + " = " + &
				String(dw_name.GetItemNumber(index, dw_name.i_KeyColumns[l_MapKey[l_Idx]]))
	END CHOOSE
	l_And = " AND "
NEXT

RETURN l_FindRow
end function

public function boolean fu_checkchangesuow ();//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_CheckChangesUOW
//  Description   : Check for changes in all of the DataWindows in
//                  the unit of work.
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

BOOLEAN l_Changes = FALSE
INTEGER l_Idx

FOR l_Idx = 1 TO i_NumDW
	l_Changes = i_DW[l_Idx].fu_CheckChanges()
	IF l_Changes THEN
		EXIT
	END IF
NEXT

RETURN l_Changes
end function

public subroutine fu_resetupdateuow ();//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_ResetUpdateUOW
//  Description   : Reset update flags in all of the DataWindows in
//                  the unit of work.
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

INTEGER l_Idx
LONG    l_Jdx, l_Rows
BOOLEAN l_FoundNew

FOR l_Idx = 1 TO i_NumDW

	l_FoundNew = FALSE
	IF IsValid(i_DW[l_Idx].i_DWSRV_EDIT) THEN
		IF i_DW[l_Idx].i_CurrentMode = i_ServiceDW.c_NewMode THEN
			i_DW[l_Idx].i_CurrentMode = i_ServiceDW.c_ModifyMode
			IF IsValid(i_DW[l_Idx].i_DWSRV_CTRL) THEN
				i_DW[l_Idx].i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_New)
			END IF
		END IF
		IF i_DW[l_Idx].i_DWSRV_EDIT.i_HaveNew THEN
			l_Rows = i_DW[l_Idx].RowCount()
			FOR l_Jdx = l_Rows TO 1 STEP -1
				IF i_DW[l_Idx].GetItemStatus(l_Jdx, 0, Primary!) = New! THEN
					l_FoundNew = TRUE
					EXIT
				END IF
			NEXT
		END IF
		IF NOT l_FoundNew THEN
			i_DW[l_Idx].i_DWSRV_EDIT.i_HaveNew    = FALSE
		END IF
		i_DW[l_Idx].i_DWSRV_EDIT.i_HaveModify = FALSE
	END IF
	i_DW[l_Idx].ResetUpdate()

NEXT

end subroutine

public function integer fu_validateuow ();//******************************************************************
//  PC Module     : n_DWSRV_UOW
//  Function      : fu_ValidateUOW
//  Description   : Validate any DataWindows in the unit-of-work
//                  that have changed.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - validation operation successful.
//                     -1 - validation operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

FOR l_Idx = 1 TO i_NumDW
	IF i_DW[l_Idx].fu_CheckChanges() THEN
		IF i_DW[l_Idx].fu_Validate() <> c_Success THEN
			i_DW[l_Idx].fu_Activate()
			RETURN c_Fatal
		END IF
	END IF
NEXT

RETURN c_Success
end function

on n_dwsrv_uow.create
TriggerEvent( this, "constructor" )
end on

on n_dwsrv_uow.destroy
TriggerEvent( this, "destructor" )
end on

