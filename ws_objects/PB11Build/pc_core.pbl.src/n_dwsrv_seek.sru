$PBExportHeader$n_dwsrv_seek.sru
$PBExportComments$DataWindow service for search, filter, and query mode handling
forward
global type n_dwsrv_seek from n_dwsrv_main
end type
end forward

global type n_dwsrv_seek from n_dwsrv_main
end type
global n_dwsrv_seek n_dwsrv_seek

type variables
//-----------------------------------------------------------------------------------------
// Search/Filter/Find Service Constants
//-----------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------
//  Search/Filter/Find Service Instance Variables
//-----------------------------------------------------------------------------------------

INTEGER		i_NumSearch
DRAGOBJECT		i_Search[]

INTEGER		i_NumFilter
DRAGOBJECT		i_Filter[]

INTEGER		i_NumFind
DRAGOBJECT		i_Find[]

BOOLEAN		i_GotQueryMode
STRING			i_QueryMode
STRING			i_NormalMode
end variables

forward prototypes
public function integer fu_getobjects (integer control_type, ref userobject controls[])
public subroutine fu_unwire (powerobject control_name)
public subroutine fu_wire (powerobject control_name)
public function integer fu_query (integer query_state)
public subroutine fu_buildquerymode ()
public subroutine fu_queryreset ()
public subroutine fu_searchreset ()
public subroutine fu_filterreset ()
public function integer fu_filter (integer changes, integer reselect)
public function integer fu_search (integer changes, integer reselect)
end prototypes

public function integer fu_getobjects (integer control_type, ref userobject controls[]);//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Subroutine    : fu_GetObjects
//  Description   : Return the number and array of requested 
//                  objects.
//
//  Parameters    : INTEGER Control_Type -
//                     Type of control to return.  Values are:
//                        c_Search
//                        c_Filter
//                        c_Find
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

CHOOSE CASE control_type

	CASE c_SearchObject
		controls[] = i_Search[]
		RETURN i_NumSearch

	CASE c_FilterObject
		controls[] = i_Filter[]
		RETURN i_NumFilter

	CASE c_FindObject
		controls[] = i_Find[]
		RETURN i_NumFind

END CHOOSE
end function

public subroutine fu_unwire (powerobject control_name);//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Subroutine    : fu_Unwire
//  Description   : Unwire a search, filter or find object from this
//                  DataWindow service.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name to unwire.
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

INTEGER    l_Idx, l_Jdx
STRING     l_Type
POWEROBJECT l_Seek

//------------------------------------------------------------------
//  Determine what type of object it is.
//------------------------------------------------------------------

l_Seek = control_name
l_Type = l_Seek.DYNAMIC fu_GetIdentity()

CHOOSE CASE l_Type

	CASE "Search", "Search DW"
		
		l_Jdx = 0
		FOR l_Idx = 1 TO i_NumSearch
			IF i_Search[l_Idx] <> l_Seek THEN
				l_Jdx = l_Jdx + 1
				i_Search[l_Jdx] = i_Search[l_Idx]
			END IF
		NEXT
		i_NumSearch = l_Jdx

	CASE "Filter", "Filter DW"
		
		l_Jdx = 0
		FOR l_Idx = 1 TO i_NumFilter
			IF i_Filter[l_Idx] <> l_Seek THEN
				l_Jdx = l_Jdx + 1
				i_Filter[l_Jdx] = i_Filter[l_Idx]
			END IF
		NEXT
		i_NumFilter = l_Jdx

	CASE "Find"
		
		l_Jdx = 0
		FOR l_Idx = 1 TO i_NumFind
			IF i_Find[l_Idx] <> l_Seek THEN
				l_Jdx = l_Jdx + 1
				i_Find[l_Jdx] = i_Find[l_Idx]
			END IF
		NEXT
		i_NumFind = l_Jdx

END CHOOSE

end subroutine

public subroutine fu_wire (powerobject control_name);//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Subroutine    : fu_Wire
//  Description   : Wire a search, filter or find object to this
//                  DataWindow service.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name to wire.
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

BOOLEAN    l_Found
INTEGER    l_Idx
STRING     l_Type
POWEROBJECT l_Seek

//------------------------------------------------------------------
//  Determine what type of object it is.
//------------------------------------------------------------------

l_Seek = control_name
l_Type = l_Seek.DYNAMIC fu_GetIdentity()

CHOOSE CASE l_Type

	CASE "Search", "Search DW"
		
		l_Found = FALSE
		FOR l_Idx = 1 TO i_NumSearch
			IF i_Search[l_Idx] = l_Seek THEN
				l_Found = TRUE
				EXIT
			END IF
		NEXT

		IF NOT l_Found THEN
			i_NumSearch = i_NumSearch + 1
			i_Search[i_NumSearch] = l_Seek
		END IF

	CASE "Filter", "Filter DW"
		
		l_Found = FALSE
		FOR l_Idx = 1 TO i_NumFilter
			IF i_Filter[l_Idx] = l_Seek THEN
				l_Found = TRUE
				EXIT
			END IF
		NEXT

		IF NOT l_Found THEN
			i_NumFilter = i_NumFilter + 1
			i_Filter[i_NumFilter] = l_Seek
		END IF

	CASE "Find"
		
		l_Found = FALSE
		FOR l_Idx = 1 TO i_NumFind
			IF i_Find[l_Idx] = l_Seek THEN
				l_Found = TRUE
				EXIT
			END IF
		NEXT

		IF NOT l_Found THEN
			i_NumFind = i_NumFind + 1
			i_Find[i_NumFind] = l_Seek
		END IF

END CHOOSE

end subroutine

public function integer fu_query (integer query_state);//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Function      : fu_Query
//  Description   : Put the DataWindow into or out of QUERY mode.
//
//  Parameters    : INTEGER Query_State -
//                     The state to put the DataWindow into.
//                     Values are:
//                        c_On
//                        c_Off
//
//  Return Value  : INTEGER -
//                      0 - query set operation successful.
//                     -1 - query set operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_NumColumns
STRING  l_Select, l_ErrorStrings[]

//------------------------------------------------------------------
//  Determine which state to put the DataWindow into.
//------------------------------------------------------------------

IF query_state = c_On THEN

	//---------------------------------------------------------------
	//  Make sure this DataWindow can go into QUERY mode.
	//---------------------------------------------------------------

	IF NOT i_ServiceDW.i_AllowQuery THEN
   	l_ErrorStrings[1] = "PowerClass Error"
   	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   	l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   	l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   	l_ErrorStrings[5] = "fu_Query"
		FWCA.MSG.fu_DisplayMessage("QueryNotAllowed", &
                               	 5, l_ErrorStrings[])
		RETURN c_Fatal
	END IF
	
	//---------------------------------------------------------------
	//  Determine if this DataWindow is part of a unit-of-work.  If 
	//  it is then handle the changes.  If not, handle the changes 
	//  for this DataWindow only.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_UOW) THEN
		IF i_ServiceDW.i_DWSRV_UOW.fu_Save(i_ServiceDW, &
                                         i_ServiceDW.c_PromptChanges, &
                                         i_ServiceDW.c_CheckAll) &
         <> c_Success THEN
      	RETURN c_Fatal
		END IF
	ELSE
		IF IsValid(i_ServiceDW.i_DWSRV_EDIT) THEN
			IF i_ServiceDW.i_DWSRV_EDIT.fu_Save(i_ServiceDW.c_PromptChanges) <> c_Success THEN
				RETURN c_Fatal
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  Assume that we will not have any errors.
	//---------------------------------------------------------------

	Error.i_FWError = c_Success

	//---------------------------------------------------------------
	//  Display the query prompt.
	//---------------------------------------------------------------

	IF IsValid(FWCA.MDI) THEN
		IF FWCA.MGR.i_ShowMicrohelp THEN
		   FWCA.MDI.fu_SetMicroHelp("Query")
		END IF
	END IF

	//---------------------------------------------------------------
	//  If the DataWindow is in VIEW mode then change the the columns
 	//  so that they will become editable.
	//---------------------------------------------------------------

	IF IsValid(i_ServiceDW.i_DWSRV_CUES) THEN
		i_ServiceDW.i_DWSRV_CUES.fu_SetViewMode(c_Off)
	ELSE
		i_ServiceDW.Modify("datawindow.readonly=no")
	END IF

	//---------------------------------------------------------------
	//  All of the columns on the DataWindow may not be modifiable.
	//  However, the user may want to enter a query clause for
	//  non-modifiable columns, so we need to make sure that all
	//  fields on the DataWindow have a tab order and are unprotected
	//  so the user can type into them.
	//---------------------------------------------------------------

	IF NOT i_GotQueryMode THEN
		fu_BuildQueryMode()
	END IF

	IF Len(i_QueryMode) > 0 THEN
		i_ServiceDW.Modify(i_QueryMode)
	END IF

	//---------------------------------------------------------------
	//  Set the cursor to the first visible column.
	//---------------------------------------------------------------

	l_NumColumns = Integer(i_ServiceDW.Describe("datawindow.column.count"))
	FOR l_Idx = 1 TO l_NumColumns
		IF i_ServiceDW.Describe("#" + String(l_Idx) + ".visible") = "1" THEN
			i_ServiceDW.SetColumn(l_Idx)
			EXIT
		END IF
	NEXT

	//---------------------------------------------------------------
	//  Reset the original SQL statement in the DataWindow.
	//---------------------------------------------------------------

	IF Len(i_ServiceDW.i_StoredProc) = 0 THEN
		l_Select = OBJCA.MGR.fu_QuoteString(i_ServiceDW.i_SQLSelect, "'")
		i_ServiceDW.Modify("datawindow.table.select='" + l_Select + "'")
	END IF

	//---------------------------------------------------------------
	//  Put the DataWindow into QUERY mode.
	//---------------------------------------------------------------

	i_ServiceDW.Modify("datawindow.querymode=yes")
	i_ServiceDW.i_IsQuery = TRUE
 
	//---------------------------------------------------------------
	//  If the DataWindow is current, then set control, else make the
	//  DataWindow active which will set control.
	//---------------------------------------------------------------

   IF i_ServiceDW.i_IsCurrent THEN
		IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
			i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_AllControls)
		END IF
	ELSE
	   i_ServiceDW.fu_Activate()
	END IF

	//---------------------------------------------------------------
	//  If the DataWindow is empty then set the text colors back
	//  to normal.
	//---------------------------------------------------------------

	IF i_ServiceDW.i_IsEmpty THEN
		i_ServiceDW.Modify(i_ServiceDW.i_NormalTextColors)
	END IF

	//---------------------------------------------------------------
	//  Set the row indicator.
	//---------------------------------------------------------------

	i_ServiceDW.fu_SetIndicatorRow()

	//---------------------------------------------------------------
	//  Turn RFC and validation processing off while we are in
	//  QUERY mode.  It will be tuned back on when we leave QUERY
	//  mode.
	//---------------------------------------------------------------

	i_ServiceDW.i_IgnoreRFC = TRUE
	i_ServiceDW.i_IgnoreVal = TRUE

	//---------------------------------------------------------------
	//  Trigger the pcd_query event for the developer to extend if 
	//  this function was not called from this event.
	//---------------------------------------------------------------

	IF NOT i_ServiceDW.i_FromEvent THEN
		i_ServiceDW.i_InProcess = TRUE
		i_ServiceDW.TriggerEvent("pcd_Query")
		i_ServiceDW.i_InProcess = FALSE
	END IF

	//---------------------------------------------------------------
	//  If the DataWindow does not have focus (e.g. a button does),
	//  then SetFocus to it.
	//---------------------------------------------------------------

	i_ServiceDW.SetFocus()

ELSEIF query_state = c_Off THEN

	//---------------------------------------------------------------
	//  Assume that we will not have any errors.
	//---------------------------------------------------------------

	Error.i_FWError = c_Success
	
	//---------------------------------------------------------------
	//  Make sure the DataWindow was in QUERY mode before we try
	//  to take it out.
	//---------------------------------------------------------------

	IF i_ServiceDW.i_IsQuery THEN

		//------------------------------------------------------------
		//  Take the DataWindow out of QUERY mode.
		//------------------------------------------------------------

		i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)
		i_ServiceDW.Modify("datawindow.querymode=no")
		i_ServiceDW.i_IsQuery = FALSE
		i_ServiceDW.fu_Reset(i_ServiceDW.c_IgnoreChanges)

		//------------------------------------------------------------
		//  Set the row indicator.
		//------------------------------------------------------------

		i_ServiceDW.fu_SetIndicatorRow()

		//------------------------------------------------------------
		// If columns on the datawindow were modifiable, make sure that
		// all fields on the datawindow that have a taborder and are
		// unprotected so that the user can type into them.
		//------------------------------------------------------------

		IF Len(i_NormalMode) > 0 THEN
			i_ServiceDW.Modify(i_NormalMode)
		END IF

		//------------------------------------------------------------
		//  Turn RFC and validation processing back on.
		//------------------------------------------------------------

		i_ServiceDW.i_IgnoreRFC = FALSE
		i_ServiceDW.i_IgnoreVal = FALSE
		i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)

		//------------------------------------------------------------
		//  If the menu/button control service is active, reset the
		//  controls now that we are out of QUERY mode.
		//------------------------------------------------------------

		IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
			IF i_ServiceDW.i_IsCurrent THEN
				i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_AllControls)
			END IF
		END IF

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

public subroutine fu_buildquerymode ();//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Subroutine    : fu_BuildQueryMode
//  Description   : Build a string that can be given to MODIFY
//                  that allows the user to edit in all visible
//                  column in a DataWindow.
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

INTEGER l_NumColumns, l_Idx
STRING  l_Attr

//------------------------------------------------------------------
//  Get the number of columns from the DataWindow.
//------------------------------------------------------------------

l_NumColumns = Integer(i_ServiceDW.Describe("datawindow.column.count"))

//------------------------------------------------------------------
//  Build a string for query mode and normal mode.
//------------------------------------------------------------------

i_QueryMode = ""
i_NormalMode = ""
FOR l_Idx = 1 TO l_NumColumns
	IF i_ServiceDW.Describe("#" + String(l_Idx) + ".visible") <> "0" THEN
		l_Attr = i_ServiceDW.Describe("#" + String(l_Idx) + ".protect")
		IF Pos(l_Attr, '"') = 1 THEN
			l_Attr = MID(l_Attr, 2, Len(l_Attr) - 2)
		END IF

		i_NormalMode = i_NormalMode + "#" + String(l_Idx) + ".protect='" + &
			l_Attr + "'~t"
		i_NormalMode = i_NormalMode + "#" + String(l_Idx) + ".tabsequence=" + &
			i_ServiceDW.Describe("#" + String(l_Idx) + ".tabsequence") + "~t"
		i_QueryMode = i_QueryMode + "#" + String(l_Idx) + ".protect='0'~t"
		i_QueryMode = i_QueryMode + "#" + String(l_Idx) + &
			".tabsequence=" + String(l_Idx) + "~t"
	END IF
NEXT

i_GotQueryMode = TRUE
end subroutine

public subroutine fu_queryreset ();//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Subroutine    : fu_QueryReset
//  Description   : Reset the query criteria when the DataWindow is
//                  in QUERY mode.
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

INTEGER l_NumCols, l_NumRows, l_Idx, l_Jdx, l_SaveCol
BOOLEAN l_FirstVisible

//------------------------------------------------------------------
//  The DataWindow must be query mode for the criteria to be reset.
//------------------------------------------------------------------

IF i_ServiceDW.i_AllowQuery AND i_ServiceDW.i_IsQuery THEN

	//---------------------------------------------------------------
	//  Turn redraw off while we cycle through the columns.
	//---------------------------------------------------------------

	i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_Off)

	//---------------------------------------------------------------
	//  Get the number of rows and columns from the DataWindow.
	//---------------------------------------------------------------

	l_NumCols = Integer(i_ServiceDW.Describe("datawindow.column.count"))
	l_NumRows = i_ServiceDW.RowCount()

	//---------------------------------------------------------------
	//  Cycle through each row and column and reset its criteria.
	//---------------------------------------------------------------

	l_FirstVisible = FALSE
	FOR l_Idx = 1 TO l_NumRows
		i_ServiceDW.SetRow(l_Idx)
		FOR l_Jdx = 1 TO l_NumCols
			IF i_ServiceDW.Describe("#" + String(l_Jdx) + ".visible") <> "0" THEN
				i_ServiceDW.SetColumn(l_Jdx)
				i_ServiceDW.SetText("")
				IF NOT l_FirstVisible THEN
					l_SaveCol = l_Jdx
					l_FirstVisible = TRUE
				END IF
			END IF
		NEXT
	NEXT

	//---------------------------------------------------------------
	//  Set the cursor back on the first visible column.
	//---------------------------------------------------------------

	i_ServiceDW.SetRow(1)
	i_ServiceDW.SetColumn(l_SaveCol)
	i_ServiceDW.fu_SetRedraw(i_ServiceDW.c_On)

END IF

end subroutine

public subroutine fu_searchreset ();//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Subroutine    : fu_SearchReset
//  Description   : Reset the search criteria in the search objects.
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

STRING   l_Array[]
INTEGER  l_Idx
OBJECT   l_Type

//------------------------------------------------------------------
//  Determine the type of each search objects and then reset it.
//------------------------------------------------------------------

l_Array[1] = ""

FOR l_Idx = 1 TO i_NumSearch
	l_Type = i_Search[l_Idx].TypeOf()
	CHOOSE CASE l_Type

		CASE DROPDOWNLISTBOX!

			i_Search[l_Idx].DYNAMIC fu_SetCode("")

		CASE DROPDOWNPICTURELISTBOX!

			i_Search[l_Idx].DYNAMIC fu_SetCode("")

		CASE LISTBOX!

			i_Search[l_Idx].DYNAMIC fu_SetCode(l_Array[])

		CASE PICTURELISTBOX!

			i_Search[l_Idx].DYNAMIC fu_SetCode(l_Array[])

		CASE EDITMASK!

			i_Search[l_Idx].DYNAMIC fu_SetCode("")
	
		CASE SINGLELINEEDIT!

			i_Search[l_Idx].DYNAMIC fu_SetCode("")

		CASE DATAWINDOW!

			IF i_Search[l_Idx].DYNAMIC fu_GetIdentity() = "Search DW" THEN
				i_Search[l_Idx].DYNAMIC fu_Reset()
			ELSE
				i_Search[l_Idx].DYNAMIC fu_SetCode("")
			END IF

	END CHOOSE
NEXT

end subroutine

public subroutine fu_filterreset ();//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Subroutine    : fu_FilterReset
//  Description   : Reset the filter criteria in the filter objects.
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

STRING   l_Array[]
INTEGER  l_Idx
OBJECT   l_Type

//------------------------------------------------------------------
//  Determine the type of each filter objects and then reset it.
//------------------------------------------------------------------

l_Array[1] = ""

FOR l_Idx = 1 TO i_NumFilter
	l_Type = i_Filter[l_Idx].TypeOf()
	CHOOSE CASE l_Type

		CASE DROPDOWNLISTBOX!

			i_Filter[l_Idx].DYNAMIC fu_SetCode("")

		CASE DROPDOWNPICTURELISTBOX!

			i_Filter[l_Idx].DYNAMIC fu_SetCode("")

		CASE LISTBOX!

			i_Filter[l_Idx].DYNAMIC fu_SetCode(l_Array[])

		CASE PICTURELISTBOX!

			i_Filter[l_Idx].DYNAMIC fu_SetCode(l_Array[])

		CASE EDITMASK!

			i_Filter[l_Idx].DYNAMIC fu_SetCode("")
	
		CASE SINGLELINEEDIT!

			i_Filter[l_Idx].DYNAMIC fu_SetCode("")

		CASE DATAWINDOW!

			IF i_Filter[l_Idx].DYNAMIC fu_GetIdentity() = "Filter DW" THEN
				i_Filter[l_Idx].DYNAMIC fu_Reset()
			ELSE
				i_Filter[l_Idx].DYNAMIC fu_SetCode("")
			END IF

	END CHOOSE
NEXT

end subroutine

public function integer fu_filter (integer changes, integer reselect);//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Function      : fu_Filter
//  Description   : Filter the DataWindow according to the
//                  filter criteria.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//                  INTEGER Reselect -
//                     If records are currently selected, should
//                     they be reselected after the filter.
//                     Values are:
//                        c_ReselectRows
//                        c_NoReselectRows
//
//  Return Value  : INTEGER -
//                      0 - filter operation successful.
//                     -1 - filter operation failed.
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
BOOLEAN l_Reset
STRING  l_ErrorStrings[]

//------------------------------------------------------------------
//  Display the filter prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Filter")
	END IF
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Set the filter flag.
//------------------------------------------------------------------

i_ServiceDW.i_IsFilter = TRUE

//------------------------------------------------------------------
//  Cycle through the filter objects to build the filter clause.
//------------------------------------------------------------------

l_Reset = TRUE
FOR l_Idx = 1 TO i_NumFilter
	IF i_Filter[l_Idx].DYNAMIC fu_BuildFilter(l_Reset) <> c_Success THEN
		i_Filter[l_Idx].SetFocus()
		Error.i_FWError = c_Fatal
		GOTO Finished
	END IF
	l_Reset = FALSE
NEXT
 
//------------------------------------------------------------------
//  Filter the DataWindow.
//------------------------------------------------------------------

IF i_ServiceDW.fu_Retrieve(changes, reselect) <> c_Success THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------------
//  If no rows were found then put up a message.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsEmpty OR i_ServiceDW.RowCount() = 0 THEN
   l_ErrorStrings[1] = "PowerClass Error"
   l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
   l_ErrorStrings[5] = "fu_Filter"
	FWCA.MSG.fu_DisplayMessage("ZeroFilterRows", &
                               5, l_ErrorStrings[])
	IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
		i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_AllControls)
	END IF
ELSE
	i_ServiceDW.SetFocus()
END IF

Finished:

//------------------------------------------------------------------
//  Trigger the pcd_filter event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_ServiceDW.i_FromEvent THEN
	i_ServiceDW.i_InProcess = TRUE
	i_ServiceDW.TriggerEvent("pcd_Filter")
	i_ServiceDW.i_InProcess = FALSE
END IF

//------------------------------------------------------------------
//  Clear the filter flag.
//------------------------------------------------------------------

i_ServiceDW.i_IsFilter = FALSE

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

public function integer fu_search (integer changes, integer reselect);//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Function      : fu_Search
//  Description   : Retrieve the DataWindow according to the
//                  search criteria.
//
//  Parameters    : INTEGER Changes -
//                     If changes exist, what should be done.
//                     Values are:
//                        c_IgnoreChanges
//                        c_PromptChanges
//                        c_SaveChanges
//                  INTEGER Reselect -
//                     If records are currently selected, should
//                     they be reselected after the search.
//                     Values are:
//                        c_ReselectRows
//                        c_NoReselectRows
//
//  Return Value  : INTEGER -
//                      0 - search operation successful.
//                     -1 - search operation failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  12/11/03 M. Caruso  Added check of i_ShowZeroSearchRowsPrompt
//								before displaying ZeroSearchRows prompt.
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx
BOOLEAN l_Reset
STRING  l_ErrorStrings[]

//------------------------------------------------------------------
//  Display the search prompt.
//------------------------------------------------------------------

IF IsValid(FWCA.MDI) THEN
	IF FWCA.MGR.i_ShowMicrohelp THEN
	   FWCA.MDI.fu_SetMicroHelp("Search")
	END IF
END IF

//------------------------------------------------------------------
//  Assume that we will not have any errors.
//------------------------------------------------------------------

Error.i_FWError = c_Success

//------------------------------------------------------------------
//  Cycle through the search objects to build the WHERE clause.
//------------------------------------------------------------------

l_Reset = TRUE
FOR l_Idx = 1 TO i_NumSearch
	IF i_Search[l_Idx].DYNAMIC fu_BuildSearch(l_Reset) <> c_Success THEN
		i_Search[l_Idx].SetFocus()
		Error.i_FWError = c_Fatal
		GOTO Finished
	END IF
	l_Reset = FALSE
NEXT
 
//------------------------------------------------------------------
//  If the DataWindow was in query mode, then get out.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsQuery THEN
	fu_Query(c_Off)
END IF

//------------------------------------------------------------------
//  Retrieve the DataWindow.
//------------------------------------------------------------------

IF i_ServiceDW.fu_Retrieve(changes, reselect) <> c_Success THEN
	Error.i_FWError = c_Fatal
	GOTO Finished
END IF

//------------------------------------------------------------
//  If the DataWindow was in VIEW mode then put it in that mode for query.
//------------------------------------------------------------

IF i_ServiceDW.i_AllowQuery	THEN
	IF i_ServiceDW.i_CurrentMode = i_ServiceDW.c_ViewMode THEN
		IF IsValid(i_ServiceDW.i_DWSRV_CUES) THEN
			i_ServiceDW.i_DWSRV_CUES.fu_SetViewMode(c_On)
		ELSE
			i_ServiceDW.Modify("datawindow.readonly=yes")
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  If no rows were found then put up a message.
//------------------------------------------------------------------

IF i_ServiceDW.i_IsEmpty OR i_ServiceDW.RowCount() = 0 THEN
   IF i_ServiceDW.i_ShowZeroSearchRowsPrompt THEN
		l_ErrorStrings[1] = "PowerClass Error"
   	l_ErrorStrings[2] = FWCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = i_ServiceDW.i_Window.ClassName()
   	l_ErrorStrings[4] = i_ServiceDW.ClassName() + " - " + ClassName()
	   l_ErrorStrings[5] = "fu_Search"
		FWCA.MSG.fu_DisplayMessage("ZeroSearchRows", &
      	                         5, l_ErrorStrings[])
	END IF
	IF IsValid(i_ServiceDW.i_DWSRV_CTRL) THEN
		i_ServiceDW.i_DWSRV_CTRL.fu_SetControl(i_ServiceDW.c_AllControls)
	END IF
ELSE
	i_ServiceDW.SetFocus()
END IF

Finished:

//------------------------------------------------------------------
//  Trigger the pcd_search event for the developer to extend if 
//  this function was not called from this event.
//------------------------------------------------------------------

IF NOT i_ServiceDW.i_FromEvent THEN
	i_ServiceDW.i_InProcess = TRUE
	i_ServiceDW.TriggerEvent("pcd_Search")
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

on n_dwsrv_seek.create
call super::create
end on

on n_dwsrv_seek.destroy
call super::destroy
end on

event destructor;call super::destructor;//******************************************************************
//  PC Module     : n_DWSRV_SEEK
//  Event         : Destructor
//  Description   : Unwire the controls from the DataWindow.
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

//------------------------------------------------------------------
//  Unwire any search objects that were wired.
//------------------------------------------------------------------

FOR l_Idx = i_NumSearch TO 1 STEP -1
	IF IsValid(i_Search[l_Idx]) THEN
		i_Search[l_Idx].DYNAMIC fu_UnwireDW()
	END IF
NEXT

//------------------------------------------------------------------
//  Unwire any filter objects that were wired.
//------------------------------------------------------------------

FOR l_Idx = i_NumFilter TO 1 STEP -1
	IF IsValid(i_Filter[l_Idx]) THEN
		i_Filter[l_Idx].DYNAMIC fu_UnwireDW()
	END IF
NEXT

//------------------------------------------------------------------
//  Unwire any find objects that were wired.
//------------------------------------------------------------------

FOR l_Idx = i_NumFind TO 1 STEP -1
	IF IsValid(i_Find[l_Idx]) THEN
		i_Find[l_Idx].DYNAMIC fu_UnwireDW()
	END IF
NEXT

end event

