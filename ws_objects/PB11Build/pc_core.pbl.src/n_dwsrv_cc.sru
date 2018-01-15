$PBExportHeader$n_dwsrv_cc.sru
$PBExportComments$DataWindow service for concurrency error handling
forward
global type n_dwsrv_cc from n_dwsrv_main
end type
end forward

global type n_dwsrv_cc from n_dwsrv_main
end type
global n_dwsrv_cc n_dwsrv_cc

type variables
//-----------------------------------------------------------------------------------------
//  Concurrency Checking Service Constants
//-----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_CCErrorNone		= 1
CONSTANT INTEGER	c_CCErrorNonOverlap	= 2
CONSTANT INTEGER	c_CCErrorOverlap		= 3
CONSTANT INTEGER	c_CCErrorOverlapMatch	= 4
CONSTANT INTEGER	c_CCErrorNonExistent	= 5
CONSTANT INTEGER	c_CCErrorDeleteModified	= 6
CONSTANT INTEGER	c_CCErrorDeleteNonExistent	= 7
CONSTANT INTEGER	c_CCErrorKeyConflict	= 8

CONSTANT INTEGER	c_CCUseOldDB		= 1
CONSTANT INTEGER	c_CCUseNewDB		= 2
CONSTANT INTEGER	c_CCUseDWValue		= 3
CONSTANT INTEGER	c_CCUseSpecial		= 4

CONSTANT INTEGER	c_CCMethodNone		= 1
CONSTANT INTEGER	c_CCMethodSpecify	= 2

CONSTANT INTEGER	c_CCValidateNone		= 1
CONSTANT INTEGER	c_CCValidateRow		= 2
CONSTANT INTEGER	c_CCValidateAll		= 3

CONSTANT INTEGER	c_CCUserCancel		= 1
CONSTANT INTEGER	c_CCUserOK		= 2

CONSTANT INTEGER	c_CCMaxNumRetry		= 5

//-----------------------------------------------------------------------------------------
//  Concurrency Checking Instance Variables
//-----------------------------------------------------------------------------------------

INTEGER		i_NumCCErrorCodes
LONG			i_CCErrorCodes[]

INTEGER		i_NumCCDupCodes
LONG			i_CCDupCodes[]

STRING			i_CCDevErrorMessage
LONG			i_CCErrorRow
DWBUFFER		i_CCErrorBuffer

ULONG			i_CCErrorColor
LONG			i_CCLastBadRow[]
LONG			i_CCNumRetry[]
LONG			i_CCSkipDeleteRows[]
LONG			i_CCSkipFilterRows[]
LONG			i_CCSkipPrimaryRows[]

LONG			i_CCNumErrors
LONG			i_CCNumRows
INTEGER		i_CCNumColumns
DWITEMSTATUS		i_CCRowStatus
STRING			i_CCColumnName[]
BOOLEAN		i_CCColumnUpdateable[]
INTEGER		i_CCColumnErrorCode[]
DWITEMSTATUS		i_CCColumnStatus[]
STRING			i_CCOldDBValue[]
STRING			i_CCNewDBValue[]
STRING			i_CCDWValue[]

STRING			i_CCUser
INTEGER		i_CCRowMethod
INTEGER		i_CCRowValue
INTEGER		i_CCValidate
INTEGER		i_CCColumnMethod[]
INTEGER		i_CCColumnValue[]
STRING			i_CCSpecialValue[]

LONG			i_CCUserRow
INTEGER		i_CCUserStatus
end variables

forward prototypes
public subroutine fu_updateccstatus (long error_row, dwbuffer error_buffer)
public subroutine fu_initccstatus ()
public subroutine fu_resetccstatus ()
public function integer fu_setccrollback ()
public subroutine fu_setccrow (long error_row, boolean force)
public function integer fu_getkeys (ref string key_columns[], ref string key_types[])
public function integer fu_checkccstatus (long error_code, string error_message)
public subroutine fu_resetccretry ()
public function integer fu_processccstatus ()
public subroutine fu_initcc ()
end prototypes

public subroutine fu_updateccstatus (long error_row, dwbuffer error_buffer);//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_UpdateCCStatus
//  Description   : Save the row and buffer deing updated to the
//                  database.
//
//  Parameters    : LONG   Error_Row -
//                     The DataWindow row from the SQLPreview
//                     event.
//                  STRING Error_Buffer -
//                     The DataWindow buffer being updated.
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

i_CCErrorRow    = error_row
i_CCErrorBuffer = error_buffer
end subroutine

public subroutine fu_initccstatus ();//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_InitCCStatus
//  Description   : Initializes variables for concurrency checking
//                  before updating begins.
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Bump up the update attempt variable.
//------------------------------------------------------------------

i_CCWhichUpdate = i_CCWhichUpdate + 1

//------------------------------------------------------------------
//  See if we are starting a new UPDATE() or if this is the
//  second (or greater) attempt to perform the update.
//------------------------------------------------------------------

IF i_CCMaxNumUpdate < i_CCWhichUpdate THEN

   //---------------------------------------------------------------
   //  New UPDATE().  Initialize the appropriate instance
   //  variables.
   //---------------------------------------------------------------

   i_CCMaxNumUpdate                     = i_CCWhichUpdate
   i_CCSkipDeleteRows[i_CCWhichUpdate]  = 0
   i_CCSkipFilterRows[i_CCWhichUpdate]  = 0
   i_CCSkipPrimaryRows[i_CCWhichUpdate] = 0

   IF i_CCWhichUpdate > 1 THEN

      //------------------------------------------------------------
      //  Since we successfully made it through the previous
      //  UPDATE() for the DataWindow, reset the instance
      //  variables used to limit the maximum number of retries
      //  for concurrency errors.
      //------------------------------------------------------------

      i_CCLastBadRow[i_CCWhichUpdate - 1] = 0
      i_CCNumRetry[i_CCWhichUpdate - 1]   = 0
   END IF

   //---------------------------------------------------------------
   //  If i_CCLastBadRow[] and i_CCNumRetry[] have not been
   //  initialized, initialize them now.
   //---------------------------------------------------------------

   IF UpperBound(i_CCLastBadRow[]) < i_CCWhichUpdate THEN
		fu_ResetCCRetry()
   END IF
END IF

end subroutine

public subroutine fu_resetccstatus ();//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_ResetCCStatus
//  Description   : Resets the concurrency checking variables.
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_CCError           = FALSE
i_CCErrorCode       = 0
i_CCErrorRow        = 0
i_CCErrorMessage    = ""
i_CCDevErrorMessage = ""

end subroutine

public function integer fu_setccrollback ();//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_SetCCRollback
//  Description   : Performs a rollback for concurrency errors.
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Initialize variables for use by the developer.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Make sure that the rollback has not already been done.
//------------------------------------------------------------------

IF NOT i_CCDidRollback THEN

   //---------------------------------------------------------------
   //  Call the function to rollback the database.
   //---------------------------------------------------------------

   i_CCDidRollback = TRUE
   IF i_ServiceDW.i_DWSRV_EDIT.fu_Rollback() <> c_Success THEN
      Error.i_FWError = c_Fatal
   END IF

END IF

RETURN Error.i_FWError
end function

public subroutine fu_setccrow (long error_row, boolean force);//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_SetCCRow
//  Description   : Fills in the column values for a row in
//                  the DataWindow based on the state of
//                  concurrency error processing.
//
//  Parameters    : LONG    Error_Row -
//                     The row that is to be updated with 
//                     concurrency recovery values.
//
//                  BOOLEAN Force -
//                     Indicates if every column is to be
//                     filled in (TRUE) or only those which have
//                     been changed (FALSE).
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

BOOLEAN  l_DisableKey, l_KeyColumns[], l_Doit
INTEGER  l_Idx
STRING   l_NewValue, l_Result

//------------------------------------------------------------------
//  Get the key columns from the DataWindow.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
   l_Result            = Upper(i_ServiceDW.Describe("#" + String(l_Idx) + ".Key"))
   l_KeyColumns[l_Idx] = (l_Result = "YES")
NEXT

//------------------------------------------------------------------
//  For the columns that the developer processed, stuff the
//  values into the DataWindow so that UPDATE() will get
//  them on the next pass.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
   CHOOSE CASE i_CCColumnValue[l_Idx]

      //------------------------------------------------------------
      //  We are to use the original value from the database.
      //------------------------------------------------------------

      CASE c_CCUseOldDB
         l_NewValue = i_CCOldDBValue[l_Idx]

      //------------------------------------------------------------
      //  We are to use the new updated value in the database.
      //------------------------------------------------------------

      CASE c_CCUseNewDB
         l_NewValue = i_CCNewDBValue[l_Idx]

      //------------------------------------------------------------
      //  We are to use the value entered by the user into the
      //  DataWindow.
      //------------------------------------------------------------

      CASE c_CCUseDWValue
         l_NewValue = i_CCDWValue[l_Idx]

      //------------------------------------------------------------
      //  We are to use the value generated by the developer.
      //------------------------------------------------------------

      CASE c_CCUseSpecial
         l_NewValue = i_CCSpecialValue[l_Idx]

      //------------------------------------------------------------
      //  Shouldn't get to here...
      //------------------------------------------------------------

      CASE ELSE
         SetNull(l_NewValue)

   END CHOOSE

   //---------------------------------------------------------------
   //  If the new requested value always needs to be placed into
   //  the column (i.e. force is TRUE) or doesn't match the
   //  current value in the database, stuff the new value into the 
	//  column.  This will mark the row and column as being updated.
   //---------------------------------------------------------------

   l_Doit = FALSE
   IF force THEN
      l_Doit = TRUE
   ELSE
      l_Doit = TRUE
      IF i_CCNewDBValue[l_Idx] = l_NewValue THEN
         l_Doit = FALSE
      ELSE
         IF IsNull(i_CCNewDBValue[l_Idx]) <> FALSE THEN
         	IF IsNull(l_NewValue) <> FALSE THEN

            	//---------------------------------------------------
            	//  Both are NULL and therefore equal.  Don't
            	//  stuff the value
            	//---------------------------------------------------

            	l_Doit = FALSE
         	END IF
         END IF
      END IF
   END IF

   IF l_Doit THEN

      //------------------------------------------------------------
      //  If this is a key column and the key values have not
      //  changed, we need to turn the key off.  If we do not
      //  and the DataWindow has been requested to do DELETE/INSERT
      //  for key columns (instead of UPDATE), PowerBuilder will
      //  attempt to delete the row and reinsert, even though
      //  the key value has not changed.
      //------------------------------------------------------------

      l_DisableKey = FALSE
      IF l_KeyColumns[l_Idx] THEN
         IF i_CCNewDBValue[l_Idx] = l_NewValue THEN
            l_DisableKey = TRUE
            i_ServiceDW.Modify("#" + String(l_Idx) + ".Key=No")
         END IF
      END IF

      //------------------------------------------------------------
      //  Set the new value into the column
      //------------------------------------------------------------

		fu_SetItem(error_row, l_Idx, l_NewValue)

      //------------------------------------------------------------
      //  If we disabled a key column, then we need to reenable it.
      //------------------------------------------------------------

      IF l_DisableKey THEN
         i_ServiceDW.Modify("#" + String(l_Idx) + ".Key=Yes")
      END IF
   END IF
NEXT

end subroutine

public function integer fu_getkeys (ref string key_columns[], ref string key_types[]);//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Function      : fu_GetKeys
//  Description   : Get the key columns for the DataWindow.
//
//  Parameters    : STRING Key_Column[] -
//                     Array of key columns returned.
//                  STRING Key_Type[] -
//                     Array of key types returned.
//
//  Return Value  : INTEGER -
//                     Number of key columns.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumKeys
STRING  l_Type

l_NumKeys = 0
FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
	IF Upper(i_ServiceDW.Describe("#" + String(l_Idx) + ".key")) = "YES" THEN
		l_Type = Upper(i_ServiceDW.Describe("#" + String(l_Idx) + ".coltype"))
		IF Left(l_Type, 4) = "CHAR" THEN
			l_Type = "CHAR"
		END IF
		IF Left(l_Type, 3) = "DEC" THEN
			l_Type = "DEC"
		END IF
		l_NumKeys = l_NumKeys + 1
		key_columns[l_NumKeys] = i_ServiceDW.Describe("#" + String(l_Idx) + ".name")
		key_types[l_NumKeys] = l_Type
	END IF
NEXT

RETURN l_NumKeys
end function

public function integer fu_checkccstatus (long error_code, string error_message);//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Function      : fu_CheckCCStatus
//  Description   : Checks the error code to see if it is a
//                  concurrency error.
//
//  Parameters    : LONG   Error_Code -
//                     The database error code from the DBError
//                     event.
//                  STRING Error_Message -
//                     The database error message text.
//
//  Return Value  : INTEGER -
//                     0 - display database error message.
//                     1 - don't display database error message.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Idx, l_Return = 0

//------------------------------------------------------------------
//  If the error reported by the database matches the
//  database-dependent error code for concurrency errors,
//  then we have a concurrency error.  Set i_CCError to
//  TRUE to indicate that we do have a concurrency error.
//------------------------------------------------------------------

IF i_InUpdate THEN

	FOR l_Idx = 1 TO i_NumCCErrorCodes
   	IF i_CCErrorCodes[l_Idx] = error_code THEN
      	i_CCError        = TRUE
			i_CCErrorCode    = error_code
			i_CCErrorMessage = error_message
      	l_Return = 1
			EXIT
   	END IF
	NEXT

	IF NOT i_CCError THEN
		FOR l_Idx = 1 TO i_NumCCDupCodes
   		IF i_CCDupCodes[l_Idx] = error_code THEN
      		i_CCError        = TRUE
				i_CCErrorCode    = error_code
				i_CCErrorMessage = error_message
      		l_Return = 1
				EXIT
   		END IF
		NEXT
	END IF

ELSE

	//---------------------------------------------------------------
	//  If PowerClass is doing a RESELECTROW() during concurrency
	//  error processing, we don't want PowerBuilder displaying
	//  an error message.
	//---------------------------------------------------------------

	IF i_InReselect THEN
		l_Return = 1
	END IF

END IF

RETURN l_Return

end function

public subroutine fu_resetccretry ();//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_ResetCCRetry
//  Description   : Reset variables used to limit the maximum
//                  number of retries` for concurrency errors.
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

IF i_CCWhichUpdate > 0 THEN
   i_CCLastBadRow[i_CCWhichUpdate] = 0
   i_CCNumRetry[i_CCWhichUpdate]   = 0
	i_CCNumErrors = 0
	i_CCNumRows = 0
END IF

end subroutine

public function integer fu_processccstatus ();//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_ProcessCCStatus
//  Description   : Processes concurrency checking errors.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 - concurrency handling was successful.
//                     -1 - concurrency handling failed.
//                     -2 - user cancelled concurrency handling.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN       l_Found, l_IsSame, l_CCError
BOOLEAN       l_RetrySave, l_Rollback
INTEGER       l_SaveColumn, l_Return, l_Check, l_NumKeys
LONG          l_SaveRow, l_FixRow, l_RowCount, l_ReselectedRow[]
LONG          l_TmpRow, l_Idx, l_Jdx, l_NumReselected, l_Row
LONG          l_CCErrorCode, l_CCErrorRow
STRING        l_CCErrorMessage, l_CCDevErrorMessage, l_And
STRING        l_ReselectRow[], l_NullString, l_WindowType
STRING        l_ErrorStrings[], l_KeyTypes[], l_KeyColumns[]
DWBUFFER      l_CCErrorBuffer
DWITEMSTATUS  l_RowStatus
WINDOWSTATE   l_WinState
DATAWINDOW    l_CurrentDW
WINDOW        l_Window

//------------------------------------------------------------------
//  If we don't have a concurrency error after an update attempt
//  then just return.
//------------------------------------------------------------------

IF NOT i_CCError THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  PowerBuilder can't skip statements with SQL bind variables.
//  Therefore, we always have to rollback the entire transaction
//  and start again.
//------------------------------------------------------------------

IF fu_SetCCRollback() <> c_Success THEN
	RETURN c_Success
END IF

//------------------------------------------------------------------
//  Bump the concurrency error counts.  These are for
//  informational purposes only.
//------------------------------------------------------------------

IF i_CCLastBadRow[i_CCWhichUpdate] = 0 THEN
   i_CCNumErrors = i_CCNumErrors + 1
END IF
IF i_CCLastBadRow[i_CCWhichUpdate] <> i_CCErrorRow THEN
   i_CCNumRows = i_CCNumRows + 1
END IF

//------------------------------------------------------------------
//  Initialize l_RetrySave to indicate that this DataWindow
//  is not forcing a rollback and retrying the save of the
//  entire hierarchy of DataWindows.
//------------------------------------------------------------------

l_RetrySave = FALSE

//------------------------------------------------------------------
//  Make sure redraw is off while we mess with the fields on the
//  DataWindow.
//------------------------------------------------------------------

i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)

//------------------------------------------------------------------
//  Get the key columns from the DataWindow.
//------------------------------------------------------------------

l_NumKeys = fu_GetKeys(l_KeyColumns[], l_KeyTypes[])

//----------
//  Remember the currently selected rows because things may get
//  a little shuffled.
//----------

FOR l_Idx = 1 TO i_ServiceDW.i_NumSelected
	l_ReselectRow[l_Idx] = ""
	l_And = ""
	FOR l_Jdx = 1 TO l_NumKeys
		CHOOSE CASE l_KeyTypes[l_Jdx]
			CASE "CHAR"
				l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
					l_KeyColumns[l_Jdx] + " = '" + &
					i_ServiceDW.GetItemString(i_ServiceDW.i_SelectedRows[l_Idx], l_KeyColumns[l_Jdx]) + "'"
			CASE "DATE"
				l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
					l_KeyColumns[l_Jdx] + " = Date('" + &
					String(i_ServiceDW.GetItemDate(i_ServiceDW.i_SelectedRows[l_Idx], l_KeyColumns[l_Jdx])) + "')"
     		CASE "DATETIME"
				l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
					l_KeyColumns[l_Jdx] + " = DateTime('" + &
					String(i_ServiceDW.GetItemDateTime(i_ServiceDW.i_SelectedRows[l_Idx], l_KeyColumns[l_Jdx])) + "')"
			CASE "TIME", "TIMESTAMP"
				l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
					l_KeyColumns[l_Jdx] + " = Time('" + &
					String(i_ServiceDW.GetItemTime(i_ServiceDW.i_SelectedRows[l_Idx], l_KeyColumns[l_Jdx])) + "')"
			CASE "DEC"
				l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
					l_KeyColumns[l_Jdx] + " = " + &
					String(i_ServiceDW.GetItemDecimal(i_ServiceDW.i_SelectedRows[l_Idx], l_KeyColumns[l_Jdx]))
			CASE ELSE
				l_ReselectRow[l_Idx] = l_ReselectRow[l_Idx] + l_And + &
					l_KeyColumns[l_Jdx] + " = " + &
					String(i_ServiceDW.GetItemNumber(i_ServiceDW.i_SelectedRows[l_Idx], l_KeyColumns[l_Jdx]))
		END CHOOSE
		l_And = " AND "
	NEXT
NEXT

//------------------------------------------------------------------
//  Save the current row and column.  Turn off RFC processing 
//  because we may be moving rows between buffers and/or inserting
//  and deleting rows.  Turn off validation processing because we 
//  may be stuffing data values into the DataWindow.
//------------------------------------------------------------------

l_SaveRow    = i_ServiceDW.i_CursorRow
l_SaveColumn = i_ServiceDW.GetColumn()
i_ServiceDW.i_IgnoreRFC  = TRUE
i_ServiceDW.i_IgnoreVal  = TRUE

//------------------------------------------------------------------
//  Get the status of the row with the update error.
//------------------------------------------------------------------

l_RowStatus = i_ServiceDW.GetItemStatus(i_CCErrorRow, 0, i_CCErrorBuffer)

//------------------------------------------------------------------
//  Stuff the variables used by the developer with the necessary 
//  information to deal with the concurrency error.  Also,
//  set up default actions in the status variables in case
//  the developer does not code the pcd_Concurrency event.
//------------------------------------------------------------------

i_CCRowStatus    = l_RowStatus
i_CCNumColumns   = 0
SetNull(l_NullString)

FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
   i_CCColumnName[l_Idx]      = i_ServiceDW.i_DWSRV_EDIT.i_ColName[l_Idx]
   i_CCColumnUpdateable[l_Idx] = i_ServiceDW.i_DWSRV_EDIT.i_ColUpdate[l_Idx]
   i_CCColumnStatus[l_Idx]    = i_ServiceDW.GetItemStatus(i_CCErrorRow, l_Idx, i_CCErrorBuffer)
   i_CCOldDBValue[l_Idx]      = fu_GetItem(i_CCErrorRow, l_Idx, i_CCErrorBuffer, c_OriginalValues)
   i_CCDWValue[l_Idx]         = fu_GetItem(i_CCErrorRow, l_Idx, i_CCErrorBuffer, c_CurrentValues)
   i_CCColumnErrorCode[l_Idx] = c_CCErrorNone
   i_CCColumnMethod[l_Idx]    = c_CCMethodNone
   i_CCColumnValue[l_Idx]     = c_CCUseDWValue
   i_CCSpecialValue[l_Idx]    = l_NullString
NEXT

//------------------------------------------------------------------
//  Initialize i_CCUser to NULL.  If the developer sets it, we
//  will use it in the error messages.
//------------------------------------------------------------------

SetNull(i_CCUser)

//------------------------------------------------------------------
//  If the record is NewModified!, then it does not exist in the
//  database.  We must have gotten the concurrency error because
//  the keys are not unique.  Identify the concurrency error as
//  such.
//------------------------------------------------------------------

IF l_RowStatus = NewModified! THEN

   //---------------------------------------------------------------
   //  Insert a row to replace the row that we can't reselect
   //  from the database.
   //---------------------------------------------------------------

   l_FixRow = i_ServiceDW.InsertRow(0)

   //---------------------------------------------------------------
   //  Set the error to indicate that we had a key conflict.
   //---------------------------------------------------------------

   i_CCErrorCode = c_CCErrorKeyConflict

   //---------------------------------------------------------------
   //  By default, PowerClass does not ask for user intervention.
   //---------------------------------------------------------------

   i_CCRowMethod = c_CCMethodNone

   //---------------------------------------------------------------
   //  The default PowerClass method of handling this error will
   //  be to try to reinsert the row into the database.
   //---------------------------------------------------------------

   i_CCRowValue = c_CCUseDWValue

   //----------
   //  Since we may try to reinsert the record, perform validation.
   //----------

   i_CCValidate = c_CCValidateRow

   //---------------------------------------------------------------
   //  Finish filling in the developer information variables.
   //---------------------------------------------------------------

   FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
      i_CCColumnErrorCode[l_Idx] = c_CCErrorKeyConflict
      SetNull(i_CCNewDBValue[l_Idx])
   NEXT
ELSE

   //---------------------------------------------------------------
   //  Now copy the broken row so that we keep it as the original
   //  row.  We need the original row and a copy for:
   //     1) In case the user cancels AND
   //     2) have a row to do a RESELECTROW() on.
   //---------------------------------------------------------------

   l_FixRow = i_ServiceDW.RowCount() + 1
   l_Check  = i_ServiceDW.RowsCopy(i_CCErrorRow,    i_CCErrorRow, &
                                   i_CCErrorBuffer, i_ServiceDW,  &
                                   l_FixRow,        Primary!)

   //---------------------------------------------------------------
   //  Get the record as it currently exists in the database.
   //---------------------------------------------------------------

   i_InReselect = TRUE
   l_Check = i_ServiceDW.ReselectRow(l_FixRow)
   i_InReselect = FALSE

   IF l_Check <> 1 THEN

    	//------------------------------------------------------------
      //  Failure -- we did not get a row back from RESELECTROW().
    	//------------------------------------------------------------

     	//------------------------------------------------------------
      //  Since the record has already been deleted from the
      //  database, if we are trying to delete it, then there
      //  is not an error.
    	//------------------------------------------------------------

      IF i_CCErrorBuffer = Delete! THEN

    		//---------------------------------------------------------
         //  Since we didn't get back the row we wanted, get rid
         //  of the l_FixRow.
    		//---------------------------------------------------------

         l_Check = i_ServiceDW.RowsDiscard(l_FixRow, l_FixRow, Primary!)
         l_FixRow = 0

    		//---------------------------------------------------------
         //  Since we don't have an error, the "bad" row should
         //  be non-existent.
    		//---------------------------------------------------------

         l_Check = i_ServiceDW.RowsDiscard(i_CCErrorRow, i_CCErrorRow, &
                                           i_CCErrorBuffer)

    		//---------------------------------------------------------
         //  Since we discarded a deleted row, we need to shove
         //  the skip count back.
    		//---------------------------------------------------------

         i_CCSkipDeleteRows[i_CCWhichUpdate] = i_CCErrorRow - 1

    		//---------------------------------------------------------
         //  Clear the error condition since we are trying to
         //  delete a row that has already been deleted.
     		//---------------------------------------------------------

         i_CCErrorCode = c_CCErrorNone

     		//---------------------------------------------------------
         //  If the developer is updating more than one table,
         //  then we need to re-do the entire transaction in
         //  case something got modified in the other table(s).
     		//---------------------------------------------------------

         IF i_CCWhichUpdate > 1 THEN

            IF fu_SetCCRollback() <> c_Success THEN
					l_Return = c_Fatal
				END IF

    			//------------------------------------------------------
            //  Make sure that everything is still Ok after the
            //  rollback.
    			//------------------------------------------------------

            IF l_Return = c_Success THEN

               //----------
               //  Since we rolled everything back, we will need
               //  to retry the save in its entirety.
               //----------

               l_RetrySave = TRUE
            END IF
         END IF
      ELSE

     		//---------------------------------------------------------
         //  Since RESELECTROW() was unable to retrieve the row
         //  from the database, l_FixRow contains the original
         //  data in the DataWindow.  That is OK since we will
         //  overwrite it later.
     		//---------------------------------------------------------

     		//---------------------------------------------------------
         //  The record no longer exists in the database.
     		//---------------------------------------------------------

         i_CCErrorCode = c_CCErrorNonExistent

      	//---------------------------------------------------------
         //  By default, PowerClass does not ask for user
         //  intervention.
     		//---------------------------------------------------------

         i_CCRowMethod = c_CCMethodNone

     		//---------------------------------------------------------
         //  If c_CCEnableInsert is TRUE, the developer has told
         //  us that it this DataWindow has all of the columns
         //  need to insert rows into the database.  Therefore,
         //  the default PowerClass method of handling this error
         //  will be to re-insert the row into the database.
         //  If the developer has told use that the DataWindow
         //  does not contain the columns neccessary to insert
         //  into the database, our only choice is to drop the
         //  the user's changes and delete the row.
     		//---------------------------------------------------------

         IF i_ServiceDW.i_EnableCCInsert THEN
            i_CCRowValue = c_CCUseDWValue
         ELSE
            i_CCRowValue = c_CCUseNewDB
         END IF

     		//---------------------------------------------------------
         //  If we are going to turn this into a NewModified!
         //  record, we will do validation.
     		//---------------------------------------------------------

         IF i_CCRowValue = c_CCUseDWValue THEN
            i_CCValidate = c_CCValidateRow
         ELSE
            i_CCValidate = c_CCValidateNone
         END IF

     		//---------------------------------------------------------
         //  Finish filling in the developer information variables.
     		//---------------------------------------------------------

         FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
            i_CCColumnErrorCode[l_Idx] = c_CCErrorNonExistent
            SetNull(i_CCNewDBValue[l_Idx])
         NEXT
      END IF
   ELSE

     	//------------------------------------------------------------
      //  Success -- got a row back from RESELECTROW().
     	//------------------------------------------------------------

     	//------------------------------------------------------------
      //  If a column is not updatable, it does not get retrieved
      //  by RESELECTROW().  We have to patch these values in.
     	//------------------------------------------------------------

      FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
         IF NOT i_CCColumnUpdateable[l_Idx] THEN
            fu_SetItem(l_FixRow, l_Idx, i_CCOldDBValue[l_Idx])
         END IF
      NEXT

     	//------------------------------------------------------------
      //  We have the current values for the row from the database.
      //  Mark the row as not being modified for the time being.
      //  In PowerBuilder, we have to call SETITEMSTATUS() twice
      //  to get the status back to NotModified!
      //
      //     - Convert NewModified!  to DataModified!.
      //     - Convert DataModified! to NotModified!.
     	//------------------------------------------------------------

      i_ServiceDW.SetItemStatus(l_FixRow, 0, Primary!, DataModified!)
      i_ServiceDW.SetItemStatus(l_FixRow, 0, Primary!, NotModified!)

     	//------------------------------------------------------------
      //  Fill in the new database value elements.
     	//------------------------------------------------------------

      FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
         i_CCNewDBValue[l_Idx] = fu_GetItem(l_FixRow, l_Idx, &
                                 Primary!, c_CurrentValues)
      NEXT

     	//------------------------------------------------------------
      //  See if this record has been deleted from the DataWindow,
      //  but has been updated in the database.
     	//------------------------------------------------------------

      IF i_CCErrorBuffer = Delete! THEN

     		//---------------------------------------------------------
         //  The record no longer exists in the DataWindow.
     		//---------------------------------------------------------

         i_CCErrorCode = c_CCErrorDeleteModified

     		//---------------------------------------------------------
         //  By default, PowerClass does not ask for user
         //  intervention.
        	//---------------------------------------------------------

         i_CCRowMethod = c_CCMethodNone

     		//---------------------------------------------------------
         //  The default PowerClass method of handling this error
         //  will be to delete the row from the database.
     		//---------------------------------------------------------

         i_CCRowValue = c_CCUseDWValue

     		//---------------------------------------------------------
         //  Since we are either going to delete the record or
         //  change it to be NotModified!, there should not be
         //  a need to perform validation.
     		//---------------------------------------------------------

         i_CCValidate = c_CCValidateNone

     		//---------------------------------------------------------
         //  Finish filling in the developer information variables.
     		//---------------------------------------------------------

         FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
            i_CCColumnValue[l_Idx] = c_CCUseNewDB
            i_CCColumnErrorCode[l_Idx] = c_CCErrorDeleteModified
         NEXT
      ELSE

     		//---------------------------------------------------------
         //  If we get to here, the record exists in the database,
         //  but we have some sort of overlap error.  The following
         //  code determines the overlap errors.
     		//---------------------------------------------------------

      	//---------------------------------------------------------
         //  Initialize i_CCErrorCode to indicate that there is
         //  not an error on the row.  This will be changed if
         //  and when we actually find the error.
     		//---------------------------------------------------------

         i_CCErrorCode = c_CCErrorNone

     		//---------------------------------------------------------
         //  By default, PowerClass does not ask for user
         //  intervention.
     		//---------------------------------------------------------

         i_CCRowMethod = c_CCMethodNone

     		//---------------------------------------------------------
         //  The default PowerClass method of handling this error
         //  will be to merge the columns to the database.  For
         //  now, assume that the DataWindow value will be used.
         //  If a newer value is found in the database, it will
         //  be used as the default value.
     		//---------------------------------------------------------

         i_CCRowValue = c_CCUseDWValue

     		//---------------------------------------------------------
         //  Since we may be updating columns, we should perform
         //  validation.
     		//---------------------------------------------------------

         i_CCValidate = c_CCValidateRow

     		//---------------------------------------------------------
         //  Finish filling in the developer information variables.
     		//---------------------------------------------------------

         FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns

      		//------------------------------------------------------
            //  If the old DB and the new DB values are different,
            //  then there was a collision on this column.
       		//------------------------------------------------------

            l_IsSame = FALSE
            IF i_CCOldDBValue[l_Idx] = i_CCNewDBValue[l_Idx] THEN
               l_IsSame = TRUE
            ELSE
               IF IsNull(i_CCOldDBValue[l_Idx]) <> FALSE THEN
               	IF IsNull(i_CCNewDBValue[l_Idx]) <> FALSE THEN
                  	l_IsSame = TRUE
               	END IF
               END IF
            END IF

       		//------------------------------------------------------
            //  Are the old DB and new DB values the same?
       		//------------------------------------------------------

            IF NOT l_IsSame THEN

       			//---------------------------------------------------
               //  If the DataWindow value has not changed then
               //  this is a non-overlap error.  If it has changed,
               //  then we have an overlap error.
       			//---------------------------------------------------

               l_IsSame = FALSE
               IF i_CCOldDBValue[l_Idx] = i_CCDWValue[l_Idx] THEN
                  l_IsSame = TRUE
               ELSE
                  IF IsNull(i_CCOldDBValue[l_Idx]) <> FALSE THEN
                  	IF IsNull(i_CCDWValue[l_Idx]) <> FALSE THEN
                  	   l_IsSame = TRUE
                  	END IF
                  END IF
               END IF

               IF l_IsSame THEN
                  IF i_CCErrorCode = c_CCErrorNone THEN
                     i_CCErrorCode = c_CCErrorNonOverlap
                  END IF

                  i_CCColumnErrorCode[l_Idx] = c_CCErrorNonOverlap
                  i_CCColumnValue[l_Idx]     = c_CCUseNewDB
               ELSE
                  i_CCErrorCode = c_CCErrorOverlap

        				//------------------------------------------------
                  //  If the current DataWindow value is the same
                  //  as the new DB value, then we have a "match"
                  //  error because everybody agrees as to what
                  //  the value in the database should be.
         			//------------------------------------------------

                  l_IsSame = FALSE
                  IF i_CCNewDBValue[l_Idx] = i_CCDWValue[l_Idx] THEN
                     l_IsSame = TRUE
                  ELSE
                     IF IsNull(i_CCNewDBValue[l_Idx]) <> FALSE THEN
                     	IF IsNull(i_CCDWValue[l_Idx]) <> FALSE THEN
                       	 	l_IsSame = TRUE
                     	END IF
                     END IF
                  END IF
                  IF l_IsSame THEN
                     i_CCColumnErrorCode[l_Idx] = c_CCErrorOverlapMatch
                  ELSE
                     i_CCColumnErrorCode[l_Idx] = c_CCErrorOverlap
                  END IF
               END IF
            END IF

         	//------------------------------------------------------
            //  If we got an error on this column, then bump the
            //  number of column errors (informational purposes
            //  only).
         	//------------------------------------------------------

            IF i_CCColumnErrorCode[l_Idx] <> c_CCErrorNone THEN
               i_CCNumColumns = i_CCNumColumns + 1
            END IF
         NEXT
      END IF
   END IF
END IF

//------------------------------------------------------------------
//  Reset l_Return
//------------------------------------------------------------------

l_Return = c_Success

//------------------------------------------------------------------
//  See if we still have an error.
//------------------------------------------------------------------

IF i_CCErrorCode <> c_CCErrorNone THEN

	//---------------------------------------------------------------
   //  Remember if the transaction has been rolled back yet.
	//---------------------------------------------------------------

   l_Rollback = i_CCDidRollback

	//---------------------------------------------------------------
   //  This event provides the developer the opportunity to fix
   //  concurrency errors.  If the event is used, it must be
   //  coded by the developer.
	//---------------------------------------------------------------

   i_ServiceDW.Event pcd_Concurrency(i_CCNumErrors, i_CCNumRows, &
		i_CCNumColumns, i_CCErrorCode, i_CCRowStatus, &
		i_ServiceDW.i_DWSRV_EDIT.i_NumColumns, &
		i_CCColumnName[], i_CCColumnUpdateable[], i_CCColumnErrorCode[], &
		i_CCColumnStatus[], i_CCOldDBValue[], i_CCNewDBValue[], &
		i_CCDWValue[], i_CCUser, i_CCRowMethod, i_CCRowValue, &
		i_CCValidate, i_CCColumnMethod[], i_CCColumnValue[], &
 		i_CCSpecialValue[])
	IF Error.i_FWError <> c_Success THEN
		l_Return = c_Fatal
	END IF

	//---------------------------------------------------------------
   //  Make sure that the developer did not abort the update
   //  process because of the concurrency error.
	//---------------------------------------------------------------

   IF l_Return = c_Success THEN

		//------------------------------------------------------------
      //  If the transaction had not been rolled back before the
      //  developer's concurrency error event and it is now, then
      //  the developer must have performed a rollback.  We must
      //  indicate that the entire save process must be performed
      //  again.
		//------------------------------------------------------------

      IF i_CCDidRollback THEN
         IF l_Rollback <> i_CCDidRollback THEN
            l_RetrySave = TRUE
         END IF
      END IF

		//------------------------------------------------------------
      //  Validate the developer's return values.
		//------------------------------------------------------------

      STRING  l_TmpStr

      l_TmpStr = ""
      IF i_CCRowMethod < c_CCMethodNone OR &
         i_CCRowMethod > c_CCMethodSpecify THEN
         l_TmpStr = l_TmpStr + "      Row Method = " + &
                    String(i_CCRowMethod)  + "~n"
      END IF
      IF i_CCRowValue < c_CCUseOldDB OR &
         i_CCRowValue > c_CCUseSpecial THEN
         l_TmpStr = l_TmpStr + "      Row Value  = " + &
                    String(i_CCRowValue)    + "~n"
      END IF
      IF i_CCValidate < c_CCValidateNone OR &
         i_CCValidate > c_CCValidateRow  THEN
         l_TmpStr = l_TmpStr + "      Validate   = " + &
                    String(i_CCValidate)  + "~n"
      END IF
      FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
         IF i_CCColumnMethod[l_Idx] < c_CCMethodNone OR &
            i_CCColumnMethod[l_Idx] > c_CCMethodSpecify THEN
            l_TmpStr = l_TmpStr + "      Column Method[" + &
                       String(l_Idx) + "] = " + &
                       String(i_CCColumnMethod[l_Idx]) + "~n"
         END IF

         IF i_CCColumnValue[l_Idx] < c_CCUseOldDB OR &
            i_CCColumnValue[l_Idx] > c_CCUseSpecial THEN
            l_TmpStr = l_TmpStr + "      Column Value[" + &
                       String(l_Idx) + "]  = " + &
                       String(i_CCColumnMethod[l_Idx]) + "~n"
         END IF
      NEXT

      IF Len(l_TmpStr) > 0 THEN
  			l_ErrorStrings[1] = "PowerClass Error"
   		l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   		l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   		l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   		l_ErrorStrings[5] = "pcd_Concurrency"
         l_ErrorStrings[6] = l_TmpStr
         FWCA.MSG.fu_DisplayMessage("CCValueError", &
			                           6, l_ErrorStrings[])
      END IF

      //------------------------------------------------------------
      //  See if we are to open the window to allow user
      //  intervention for concurrency errors.
      //------------------------------------------------------------

      l_Found = FALSE
      IF i_CCErrorCode = c_CCErrorNonOverLap  OR &
         i_CCErrorCode = c_CCErrorOverLap     OR &
         i_CCErrorCode = c_CCErrorKeyConflict THEN

         //---------------------------------------------------------
         //  Make sure that the user can actually modify the
         //  columns before we open the window.
         //---------------------------------------------------------

         i_CCRowMethod = c_CCMethodNone

         FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
            IF i_CCColumnMethod[l_Idx] = c_CCMethodSpecify THEN
               IF i_ServiceDW.i_DWSRV_EDIT.i_ColVisible[l_Idx] THEN
                  l_Found = TRUE

                  //------------------------------------------------
                  //  Need to do the whole loop to check all
                  //  columns for tab order and visiblity.
                  //------------------------------------------------
               ELSE

                  //------------------------------------------------
                  //  If the user can't see or modify this column,
                  //  then mark the column as not requiring user
                  //  intervention.
                  //------------------------------------------------

                  i_CCColumnMethod[l_Idx] = c_CCMethodNone
               END IF
            END IF
         NEXT
      END IF

      //------------------------------------------------------------
      //  If requested, open the window to allow user intervention
      //  for errors.
      //------------------------------------------------------------

      IF i_CCRowMethod = c_CCMethodSpecify OR l_Found THEN

         //---------------------------------------------------------
         //  Since we are going interactive, rollback the
         //  transaction and free the database.  We don't
         //  want the database tied up while the user is
         //  making their descision.
         //---------------------------------------------------------

         l_Return = fu_SetCCRollback()

         //---------------------------------------------------------
         //  Make sure that everything is still Ok after the
         //  rollback.
         //---------------------------------------------------------

         IF l_Return = c_Success THEN

            //------------------------------------------------------
            //  Since we rolled everything back, we will need to
            //  retry the save in its entirety.
            //------------------------------------------------------

            l_RetrySave = TRUE

            //------------------------------------------------------
            //  Move the copy of the broken row to the Delete!
            //  buffer so that it will not be visible while the
            //  user works with the DataWindow.
            //------------------------------------------------------

            l_TmpRow = i_ServiceDW.DeletedCount() + 1
            l_Check  = i_ServiceDW.RowsMove(l_FixRow, l_FixRow, &
                                            Primary!, i_ServiceDW, &
                                            l_TmpRow, Delete!)

            //------------------------------------------------------
            //  Set up i_CCUserRow with the default values.  This
            //  row will be deleted by the concurrency error
            //  window.
            //------------------------------------------------------

            i_CCUserRow = i_ServiceDW.InsertRow(0)

            //------------------------------------------------------
            //  Set the values recommended by PowerClass and/or
            //  the developer into the new row and scroll to it.
            //------------------------------------------------------

            fu_SetCCRow(i_CCUserRow, TRUE)
            IF i_CCErrorBuffer = Primary! THEN
               i_ServiceDW.ScrollToRow(i_CCErrorRow)
            END IF

            //------------------------------------------------------
            //  Make sure that this DataWindow is on top.
            //------------------------------------------------------

            l_WinState = i_ServiceDW.i_Window.WindowState
            l_CurrentDW = FWCA.MGR.i_WindowCurrentDW
				i_ServiceDW.SetFocus()

            //------------------------------------------------------
            //  Make sure that the user can see the data in the
            //  DataWindow.
            //------------------------------------------------------

            IF i_ServiceDW.i_IsEmpty THEN
               i_ServiceDW.Modify(i_ServiceDW.i_NormalTextColors)
            END IF

            //------------------------------------------------------
            //  Turn redraw on while the error window is displayed.
            //------------------------------------------------------

            i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)

            //------------------------------------------------------
            //  Open the error window for user intervention.
            //------------------------------------------------------

            l_WindowType = FWCA.MGR.fu_GetDefault("Framework", "User Concurrency")
				IF l_WindowType <> "" THEN
					FWCA.MGR.fu_OpenWindow(l_Window, l_WindowType, 0, i_ServiceDW)
				ELSE
					l_Return = c_Fatal
				END IF

            //------------------------------------------------------
            //  Restore redraw to its original state.
            //------------------------------------------------------

            i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)

            //------------------------------------------------------
            //  If the DataWindow was empty, restore the empty
            //  colors.
            //------------------------------------------------------

            IF i_ServiceDW.i_IsEmpty THEN
               i_ServiceDW.Modify(i_ServiceDW.i_EmptyTextColors)
            END IF

            //------------------------------------------------------
            //  Restore the window state and current DataWindow.
            //------------------------------------------------------

            IF i_CCUserStatus <> c_CCUserCancel THEN
               IF l_WinState = Minimized! THEN
                  i_ServiceDW.i_Window.WindowState = Minimized!
               END IF
               IF IsNull(l_CurrentDW) <> FALSE THEN
               ELSE
                  IF l_CurrentDW <> i_ServiceDW THEN
                     l_CurrentDW.SetFocus()
                  END IF
               END IF
            END IF

            //------------------------------------------------------
            //  Restore the copy of the broken row to the
            //  Primary! buffer.
            //------------------------------------------------------

            l_TmpRow = i_ServiceDW.DeletedCount()
            l_Check  = i_ServiceDW.RowsMove(l_TmpRow, l_TmpRow, &
                                            Delete!, i_ServiceDW, &
                                            l_FixRow, Primary!)

            //------------------------------------------------------
            //  See if the user canceled.  If they did, we will
            //  leave the original row in its current state with
            //  the concurrency errors.
            //------------------------------------------------------

            IF i_CCUserStatus = c_CCUserCancel THEN
               l_Return = c_Fatal
            END IF
         END IF
      END IF

   END IF

   //---------------------------------------------------------------
   //  Check l_Return as either the developer or the user may have
   //  aborted the save process at this point.
   //---------------------------------------------------------------

   IF l_Return = c_Success THEN

   	//------------------------------------------------------------
      //  Based on the error code, process the concurrency error
      //  according to the developer's and/or user's instructions.
   	//------------------------------------------------------------

      CHOOSE CASE i_CCErrorCode

   		//---------------------------------------------------------
         //  For the columns that the developer and/or user
         //  processed, stuff the values into the DataWindow
         //  so that UPDATE() will get them on the next pass.
   		//---------------------------------------------------------

         CASE c_CCErrorNonOverlap, &
              c_CCErrorOverlap,    &
              c_CCErrorOverlapMatch

   			//------------------------------------------------------
            //  We need to patch the requested values into the
            //  DataWindow.
            //------------------------------------------------------

            fu_SetCCRow(l_FixRow, FALSE)

   		//---------------------------------------------------------
         //  The row does not exist in the database.  Should we
         //  reinsert it?  Make sure that the row status is New!.
         //  It will become NewModified! after the fu_SetCCRow()
         //  routine.
   		//---------------------------------------------------------

         CASE c_CCErrorNonExistent
            IF i_CCRowValue = c_CCUseNewDB THEN

    				//---------------------------------------------------
               //  We are not going to reinsert the record into
               //  the database to replace the row deleted by
               //  another user.  Discard the fixed row.
    				//---------------------------------------------------

               l_Check = i_ServiceDW.RowsDiscard(l_FixRow, l_FixRow, &
                                                 Primary!)

    				//---------------------------------------------------
               //  The fixed row does not exist anymore.
    				//---------------------------------------------------

               l_FixRow = 0

    				//---------------------------------------------------
               //  If the developer is updating more than one
               //  table, then we need to re-do the entire
               //  transaction in case something got modified in
               //  the other table(s).
    				//---------------------------------------------------

               IF i_CCWhichUpdate > 1 THEN

                  l_Return = fu_SetCCRollback()

    					//------------------------------------------------
                  //  Make sure that everything is still Ok after
                  //  the rollback.
    					//------------------------------------------------

                  IF l_Return = c_Success THEN

    						//---------------------------------------------
                     //  Since we rolled everything back, we will
                     //  need to retry the save in its entirety.
    						//---------------------------------------------

                     l_RetrySave = TRUE
                  END IF
               END IF
            ELSE

    				//---------------------------------------------------
               //  We are going to reinsert the record into the
               //  database to replace the row deleted by another
               //  user.  Set the row values as specified by the
               //  developer.
    				//---------------------------------------------------

               FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
                  i_CCColumnValue[l_Idx] = i_CCRowValue
               NEXT

               i_ServiceDW.SetItemStatus(l_FixRow, 0, Primary!, New!)
               fu_SetCCRow(l_FixRow, TRUE)
            END IF

    		//---------------------------------------------------------
         //  The row was deleted from the DataWindow, but was
         //  updated in the database.  Should we still delete it?
    		//---------------------------------------------------------

         CASE c_CCErrorDeleteModified
            IF i_CCRowValue = c_CCUseNewDB THEN

    				//---------------------------------------------------
               //  We are not going to delete the record that was
               //  updated in the database by another user.
    				//---------------------------------------------------

               FOR l_Idx = 1 TO i_ServiceDW.i_DWSRV_EDIT.i_NumColumns
                  i_CCColumnValue[l_Idx] = i_CCRowValue
               NEXT
               fu_SetCCRow(l_FixRow, FALSE)

    				//---------------------------------------------------
               //  This row came from the Delete! buffer, but
               //  since we are not deleting it, just leave it
               //  at the end of the Primary! buffer.  Since we
               //  have taken care of all the processing that
               //  needs to be done, set l_FixRow to 0 so that
               //  no more processing takes place.
    				//---------------------------------------------------

               l_FixRow = 0
            ELSE

    				//---------------------------------------------------
               //  Move the fixed row to the Delete! buffer
               //  so that it will be deleted.  Put it right
               //  after the broken row in the Delete! buffer
               //  so that when the broken row gets discarded
               //  the fixed row will be in the correct position.
    				//---------------------------------------------------

               l_TmpRow = i_CCErrorRow + 1
               l_Check  = i_ServiceDW.RowsMove(l_FixRow, l_FixRow, &
                                               Primary!, i_ServiceDW, &
                                               l_TmpRow, Delete!)

    				//---------------------------------------------------
               //  The fixed row does not "exist" anymore.
    				//---------------------------------------------------

               l_FixRow = 0
            END IF

    		//---------------------------------------------------------
         //  For key conflicts, trigger pcd_SetKey again to try
         //  to set unique keys.
         //---------------------------------------------------------

         CASE c_CCErrorKeyConflict

            fu_SetCCRow(l_FixRow, FALSE)

    			//------------------------------------------------------
            //  Initialize variables for use by the developer.
    			//------------------------------------------------------

            l_Return = c_Success
   
    			//------------------------------------------------------
            //  Save the database error information.
    			//------------------------------------------------------

            l_CCError           = i_CCError
            l_CCErrorCode       = i_CCErrorCode
            l_CCErrorMessage    = i_CCErrorMessage
            l_CCErrorRow        = i_CCErrorRow
            l_CCErrorBuffer     = i_CCErrorBuffer
            l_CCDevErrorMessage = i_CCDevErrorMessage

    			//------------------------------------------------------
            //  Reset the database error codes.
    			//------------------------------------------------------

            i_CCError           = FALSE
            i_CCErrorCode       = 0
            i_CCErrorMessage    = ""
            i_CCErrorRow        = 0
            i_CCDevErrorMessage = ""

    			//------------------------------------------------------
            //  This event provides the developer the opportunity
            //  to set values for the key columns in the
            //  DataWindow.  If this event is used, it must be
            //  coded by the developer.
     			//------------------------------------------------------

            i_ServiceDW.Event pcd_SetKey(i_ServiceDW.i_DBCA)
				IF Error.i_FWError <> c_Success THEN
					l_Return = c_Fatal
				END IF

    			//------------------------------------------------------
            //  If there was an error while setting the keys,
            //  then we may need to rollback the transaction.
    			//------------------------------------------------------

            IF l_Return <> c_Success THEN

               //---------------------------------------------------
               //  Save the error parms as the information may get
 					//  cleared by the rollback process.
               //---------------------------------------------------

				   l_ErrorStrings[1] = "PowerClass Error"
   				l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   				l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   				l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   				l_ErrorStrings[5] = "pcd_SetKey"

               //---------------------------------------------------
               //  Do the rollback.
               //---------------------------------------------------

               fu_SetCCRollback()

               //---------------------------------------------------
               //  There was an error earlier but we did not
               //  display it because we didn't want to hold
               //  up the ROLLBACK process.  Display the error
               //  now if the developer requested it.
               //---------------------------------------------------

               FWCA.MSG.fu_DisplayMessage("SetKeyError", &
                                          5, l_ErrorStrings[])
 
               //---------------------------------------------------
               //  Make sure that the error variables still
               //  indicate failure.
               //---------------------------------------------------

               l_Return = c_Fatal
            END IF

            //------------------------------------------------------
            //  Restore the database error information.
            //------------------------------------------------------

            i_CCError           = l_CCError
            i_CCErrorCode       = l_CCErrorCode
            i_CCErrorMessage    = l_CCErrorMessage
            i_CCErrorRow        = l_CCErrorRow
            i_CCErrorBuffer     = l_CCErrorBuffer
            i_CCDevErrorMessage = l_CCDevErrorMessage

      END CHOOSE

      //------------------------------------------------------------
      //  Process validation if there is still a concurrency
      //  error.
      //------------------------------------------------------------

      IF i_CCErrorCode <> c_CCErrorNone THEN
      IF l_Return       =  c_Success     THEN

      	//---------------------------------------------------------
         //  See if validation was requested.
      	//---------------------------------------------------------

         IF i_CCValidate = c_CCValidateRow THEN

      		//------------------------------------------------------
            //  Make sure that there is a row to validate.
      		//------------------------------------------------------

            IF l_FixRow > 0 THEN
               i_ServiceDW.i_IgnoreVal = FALSE
               l_Return = i_ServiceDW.i_DWSRV_EDIT.fu_ValidateRow(l_FixRow)
               i_ServiceDW.i_IgnoreVal = TRUE
            END IF
         END IF
      END IF
      END IF
   END IF

   IF l_Return = c_Success THEN

      //------------------------------------------------------------
      //  Since we had a concurrency error, we want to update
      //  this row again.  Set i_CCSkip*Rows[] to skip the rows
      //  that have already been successfully updated and get
      //  ready to try this row again.
      //------------------------------------------------------------

      CHOOSE CASE i_CCErrorBuffer
         CASE Delete!
            i_CCSkipDeleteRows[i_CCWhichUpdate]  = i_CCErrorRow - 1
         CASE Filter!
            i_CCSkipFilterRows[i_CCWhichUpdate]  = i_CCErrorRow - 1
         CASE Primary!
            i_CCSkipPrimaryRows[i_CCWhichUpdate] = i_CCErrorRow - 1
         CASE ELSE
      END CHOOSE
		l_RetrySave = TRUE
   END IF
END IF

//------------------------------------------------------------------
//  If something bad happened, clean up.  We need to discard the
//  fixed row and restore the original broken row.
//------------------------------------------------------------------

IF l_Return <> c_Success THEN

   //---------------------------------------------------------------
   //  Discard the fixed row.
   //---------------------------------------------------------------

   IF l_FixRow > 0 THEN
      l_Check = i_ServiceDW.RowsDiscard(l_FixRow, l_FixRow, Primary!)
   END IF

   //---------------------------------------------------------------
   //  We will leave the original "bad" row since the save
   //  operation was canceled.
   //---------------------------------------------------------------

ELSE

   //---------------------------------------------------------------
   //  Make sure that we really had a concurrency error and that
   //  this was really not a false alarm (e.g. deleting a row
   //  that has already been deleted in the database).
   //---------------------------------------------------------------

   IF i_CCErrorCode <> c_CCErrorNone THEN

   	//------------------------------------------------------------
      //  If we get to here, there was a concurrency error but it
      //  has gotten corrected (hopefully).  Make sure that the
      //  fixed row is in the correct buffer at the correct
      //  position.  Then discard the original broken row.
   	//------------------------------------------------------------

      IF l_FixRow > 0 THEN

    		//---------------------------------------------------------
         //  Get ready to move the fixed row to the correct buffer.
         //  Put it right after the broken row so that when the
         //  broken row gets discarded the fixed row will be in
         //  the correct position.
     		//---------------------------------------------------------

         l_TmpRow = i_CCErrorRow + 1
         IF l_TmpRow <> l_FixRow OR i_CCErrorBuffer <> Primary! THEN
				l_Check = i_ServiceDW.RowsMove(l_FixRow, l_FixRow, &
                                           Primary!, i_ServiceDW, &
                                           l_TmpRow, i_CCErrorBuffer)
			END IF
      END IF

    	//------------------------------------------------------------
      //  Now discard the original broken row.
    	//------------------------------------------------------------

      l_TmpRow = i_CCErrorRow
      l_Check  = i_ServiceDW.RowsDiscard(l_TmpRow, l_TmpRow, &
                                         i_CCErrorBuffer)
   END IF
END IF

//------------------------------------------------------------------
//  Depending on how the concurrency error was handled, the current
//  selections might have changed.  We need to make sure that the
//  correct rows are selected.
//------------------------------------------------------------------

IF i_ServiceDW.RowCount() > 0 THEN

   //---------------------------------------------------------------
   //  Since the order of the rows may have gotten shuffled,
   //  clear all of the selected rows.
   //---------------------------------------------------------------

   i_ServiceDW.SelectRow(0, FALSE)

   //---------------------------------------------------------------
   //  Attempt to reselect the rows.
   //---------------------------------------------------------------

	l_RowCount = i_ServiceDW.RowCount()
	FOR l_Idx = 1 TO i_ServiceDW.i_NumSelected
		l_Row = i_ServiceDW.Find(l_ReselectRow[l_Idx], 1, l_RowCount)
		IF l_Row > 0 THEN
			l_NumReselected = l_NumReselected + 1
			l_ReselectedRow[l_NumReselected] = l_Row
		END IF
	NEXT

	IF l_NumReselected > 0 THEN
		i_ServiceDW.fu_SetSelectedRows(l_NumReselected, l_ReselectedRow[], &
			i_ServiceDW.c_IgnoreChanges, i_ServiceDW.c_NoRefreshChildren)
	END IF

   //---------------------------------------------------------------
   //  If we were unable to find the old i_CursorRow, then set
   //  the cursor position to the same row position it was
   //  before the retrieve.
   //---------------------------------------------------------------

   IF i_ServiceDW.i_CursorRow = 0 THEN
      i_ServiceDW.i_CursorRow = l_SaveRow
   END IF

   //---------------------------------------------------------------
   //  Make sure that the cursor row is legal.
   //---------------------------------------------------------------

   IF i_ServiceDW.i_CursorRow < 1 THEN
      i_ServiceDW.i_CursorRow = 1
   END IF

   IF i_ServiceDW.i_CursorRow > i_ServiceDW.RowCount() THEN
      i_ServiceDW.i_CursorRow = i_ServiceDW.RowCount()
   END IF

   //---------------------------------------------------------------
   //  Now set up i_SelectedRows for retrieval.
   //---------------------------------------------------------------

   i_ServiceDW.i_NumSelected = i_ServiceDW.fu_GetSelectedRows(&
                               i_ServiceDW.i_SelectedRows[])

   //---------------------------------------------------------------
   //  Restore the cursor row in case it got changed during the
   //  processing of the concurrency error.
   //---------------------------------------------------------------

   i_ServiceDW.ScrollToRow(i_ServiceDW.i_CursorRow)

   //---------------------------------------------------------------
   //  Move the cursor to the original column.
   //---------------------------------------------------------------

   IF l_SaveColumn > 0 THEN
      IF l_SaveColumn <> i_ServiceDW.GetColumn() THEN
         i_ServiceDW.SetColumn(l_SaveColumn)
      END IF
   END IF
ELSE

   //---------------------------------------------------------------
   //  No rows are left after processing the concurrency error.
   //  Make the DataWindow empty and reset the status variables.
   //---------------------------------------------------------------

   i_ServiceDW.i_CursorRow   = 0
   i_ServiceDW.i_AnchorRow   = 0
   i_ServiceDW.i_CurrentMode = i_ServiceDW.c_ViewMode
END IF

//------------------------------------------------------------------
//  Restore redraw, RFC, and validation processing.
//------------------------------------------------------------------

i_ServiceDW.i_IgnoreRFC = FALSE
i_ServiceDW.i_IgnoreVal = FALSE
i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)

//------------------------------------------------------------------
//  If this row was the same row we got a concurrency error on the
//  last time we tried to update, bump the retry count.  If there
//  are too many retries, abort the update.
//------------------------------------------------------------------

IF i_CCErrorRow > 0 THEN
   IF i_CCLastBadRow[i_CCWhichUpdate] = i_CCErrorRow THEN

		//------------------------------------------------------------
      //  Bump the retry count.
		//------------------------------------------------------------

      i_CCNumRetry[i_CCWhichUpdate] = i_CCNumRetry[i_CCWhichUpdate] + 1

		//------------------------------------------------------------
      //  If c_CCMaxNumRetry is 0, we will keep retrying forever.
		//------------------------------------------------------------

      IF c_CCMaxNumRetry <> 0 THEN
         IF i_CCNumRetry[i_CCWhichUpdate] >= c_CCMaxNumRetry THEN
   			l_ErrorStrings[1] = "PowerClass Error"
   			l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   			l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   			l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   			l_ErrorStrings[5] = "fu_ProcessCCStatus"
            FWCA.MSG.fu_DisplayMessage("CCExceededRetry", &
                                       5, l_ErrorStrings[])

            l_Return        = c_Fatal
         END IF
      END IF
   ELSE
      i_CCLastBadRow[i_CCWhichUpdate] = i_CCErrorRow
      i_CCNumRetry[i_CCWhichUpdate]   = 1
   END IF
END IF

//------------------------------------------------------------------
//  If this event was successful, we have to see if the transaction
//  was rolled back.  If it was, we need to stop the save process
//  and restart it, so that all updates get sent to the database
//  again.
//------------------------------------------------------------------

IF l_Return = c_Success THEN
   IF l_RetrySave THEN
      i_ServiceDW.i_DWSRV_EDIT.i_RetrySave = TRUE
      l_Return = c_Fatal
   END IF
ELSE
	IF i_CCUserStatus = c_CCUserCancel THEN
		l_Return = c_UserCancel
	END IF
END IF

RETURN l_Return

end function

public subroutine fu_initcc ();//******************************************************************
//  PC Module     : n_DWSRV_CC
//  Subroutine    : fu_InitCC
//  Description   : Gets the concurrency error codes for the 
//                  database.
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_ID, l_ErrorCodes, l_DupCodes, l_ErrorStrings[]
INTEGER l_Pos

//------------------------------------------------------------------
//  Determine the type of database we have and make sure we are 
//  using more than just key columns to update the with.
//------------------------------------------------------------------

l_ID = Upper(OBJCA.DB.fu_GetDatabase(i_ServiceDW.i_DBCA, &
                                     OBJCA.DB.c_DB_ID))

IF l_ID <> "SYB" AND l_ID <> "SYC" AND l_ID <> "SYT" THEN
   IF i_ServiceDW.Describe("datawindow.table.updatewhere") = "0" THEN
   	l_ErrorStrings[1] = "PowerClass Error"
   	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   	l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   	l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   	l_ErrorStrings[5] = "Constructor"
      FWCA.MSG.fu_DisplayMessage("UpdateWhereError", &
		                           5, l_ErrorStrings[])
		i_ServiceDW.i_EnableCC = FALSE
	END IF
END IF

IF l_ID = "" THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName()
   l_ErrorStrings[5] = "Constructor"
	l_ErrorStrings[6] = i_ServiceDW.i_DBCA.DBMS
   FWCA.MSG.fu_DisplayMessage("CCUnknownDB", &
		                         6, l_ErrorStrings[])
	i_ServiceDW.i_EnableCC = FALSE
END IF

//------------------------------------------------------------------
//  Get the error codes used by the database for indicating a 
//  concurrency error.
//------------------------------------------------------------------

l_ErrorCodes = OBJCA.DB.fu_GetDatabase(i_ServiceDW.i_DBCA, &
                                       OBJCA.DB.c_DB_CCError)

DO
	l_Pos = Pos(l_ErrorCodes, ",")
	i_NumCCErrorCodes = i_NumCCErrorCodes + 1
	IF l_Pos > 0 THEN
 		i_CCErrorCodes[i_NumCCErrorCodes] = Long(MID(l_ErrorCodes, 1, l_Pos - 1))
		l_ErrorCodes = MID(l_ErrorCodes, l_Pos + 1)
	ELSE
 		i_CCErrorCodes[i_NumCCErrorCodes] = Long(l_ErrorCodes)
		l_ErrorCodes = ""
	END IF
LOOP UNTIL l_ErrorCodes = ""

//------------------------------------------------------------------
//  Get the duplicate error codes used by the database for 
//  indicating a concurrency error.
//------------------------------------------------------------------

l_DupCodes = OBJCA.DB.fu_GetDatabase(i_ServiceDW.i_DBCA, &
                                     OBJCA.DB.c_DB_CCDuplicate)

DO
	l_Pos = Pos(l_DupCodes, ",")
	i_NumCCDupCodes = i_NumCCDupCodes + 1
	IF l_Pos > 0 THEN
 		i_CCDupCodes[i_NumCCDupCodes] = Long(MID(l_DupCodes, 1, l_Pos - 1))
		l_DupCodes = MID(l_DupCodes, l_Pos + 1)
	ELSE
 		i_CCDupCodes[i_NumCCDupCodes] = Long(l_DupCodes)
		l_DupCodes = ""
	END IF
LOOP UNTIL l_DupCodes = ""

end subroutine

on n_dwsrv_cc.create
TriggerEvent( this, "constructor" )
end on

on n_dwsrv_cc.destroy
TriggerEvent( this, "destructor" )
end on

