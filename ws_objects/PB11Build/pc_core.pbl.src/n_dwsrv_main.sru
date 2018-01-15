$PBExportHeader$n_dwsrv_main.sru
$PBExportComments$DataWindow service ancestor
forward
global type n_dwsrv_main from nonvisualobject
end type
end forward

global type n_dwsrv_main from nonvisualobject
end type
global n_dwsrv_main n_dwsrv_main

type variables
//-----------------------------------------------------------------------------------------
//  DataWindow Service Constants.
//-----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_Success		= 0
CONSTANT INTEGER	c_Fatal			= -1
CONSTANT INTEGER	c_UserCancel		= -2
CONSTANT INTEGER	c_No			= 0
CONSTANT INTEGER	c_Yes			= 1
CONSTANT INTEGER	c_Off			= 0
CONSTANT INTEGER	c_On			= 1

CONSTANT INTEGER	c_SearchObject		= 1
CONSTANT INTEGER	c_FilterObject		= 2
CONSTANT INTEGER	c_FindObject		= 3

CONSTANT INTEGER	c_ColorAttribute		= 1
CONSTANT INTEGER	c_BGColorAttribute		= 2
CONSTANT INTEGER	c_BorderAttribute		= 3

CONSTANT INTEGER	c_CurrentValues		= 1
CONSTANT INTEGER	c_OriginalValues		= 2

CONSTANT INTEGER	c_New			= 1
CONSTANT INTEGER	c_Insert			= 2
CONSTANT INTEGER	c_View			= 3
CONSTANT INTEGER	c_Modify			= 4
CONSTANT INTEGER	c_Delete			= 5
CONSTANT INTEGER	c_First			= 6
CONSTANT INTEGER	c_Previous		= 7
CONSTANT INTEGER	c_Next			= 8
CONSTANT INTEGER	c_Last			= 9
CONSTANT INTEGER	c_Query			= 10
CONSTANT INTEGER	c_Search			= 11
CONSTANT INTEGER	c_Filter			= 12
CONSTANT INTEGER	c_Sort			= 13
CONSTANT INTEGER	c_Save			= 14
CONSTANT INTEGER	c_SaveRowsAs		= 15
CONSTANT INTEGER	c_Print			= 16
CONSTANT INTEGER	c_Close			= 17
CONSTANT INTEGER	c_Copy			= 18

CONSTANT INTEGER	c_ResetQuery		= 19
CONSTANT INTEGER	c_Accept			= 20
CONSTANT INTEGER	c_OK			= 21
CONSTANT INTEGER	c_Cancel			= 22
CONSTANT INTEGER	c_Retrieve		= 23
CONSTANT INTEGER	c_Message		= 24
CONSTANT INTEGER	c_ResetSearch		= 25
CONSTANT INTEGER	c_ResetFilter		= 26

CONSTANT INTEGER	c_AllControls		= 100
CONSTANT INTEGER	c_ModeControls		= 101
CONSTANT INTEGER	c_ScrollControls		= 102
CONSTANT INTEGER	c_SeekControls		= 103
CONSTANT INTEGER	c_ContentControls		= 104

//-----------------------------------------------------------------------------------------
//  DataWindow Service Instance Variables.
//-----------------------------------------------------------------------------------------

U_DW_MAIN		i_ServiceDW

INTEGER		i_NumDW
U_DW_MAIN		i_DW[]
U_DW_MAIN		i_ParentDW[]
U_DW_MAIN		i_RootDW
WINDOW		i_CloseWindow

BOOLEAN		i_InUpdate
BOOLEAN		i_InReselect
BOOLEAN		i_InSave
BOOLEAN		i_InValidation
BOOLEAN		i_InClose
BOOLEAN		i_InModeChange
BOOLEAN		i_InRefreshParent
BOOLEAN		i_InDrag

BOOLEAN		i_RetrySave
BOOLEAN		i_HaveNew
BOOLEAN		i_HaveModify
BOOLEAN		i_ItemValidated
INTEGER		i_UpdateCnt
STRING			i_UpdateSettings
STRING			i_UpdateReset
INTEGER		i_SaveStatus

BOOLEAN		i_CCError
LONG			i_CCErrorCode
STRING			i_CCErrorMessage
INTEGER		i_CCWhichUpdate
INTEGER		i_CCMaxNumUpdate
BOOLEAN		i_CCDidRollback

INTEGER		i_NumColumns
STRING			i_UpdateTable
STRING			i_ColName[]
STRING			i_ColType[]
BOOLEAN		i_ColVisible[]
STRING			i_ColValMsg[]
BOOLEAN		i_ColRequired[]
BOOLEAN		i_ColNilIsNull[]
BOOLEAN		i_ColKey[]
BOOLEAN		i_ColUpdate[]
STRING			i_ColTable[]
STRING			i_ColDBCol[]
INTEGER		i_ColLowTabOrder
BOOLEAN		i_GotColInfo

INTEGER		i_DragMethod
INTEGER		i_DragColumns[]
INTEGER		i_DropColumns[]
INTEGER		i_NumDrop
INTEGER		i_NumDrag
STRING			i_DragRowIcon
STRING			i_DragRowsIcon
STRING			i_DragNoDropIcon
U_DW_MAIN		i_DropDW

end variables

forward prototypes
public subroutine fu_deleteuow (datawindow dw_name)
public subroutine fu_setviewmode (integer yes_or_no)
public subroutine fu_setinactivemode (integer yes_or_no)
public subroutine fu_batchattributes (integer on_or_off)
public subroutine fu_setattribute (string column_name, integer attribute_type, string attribute_value)
public subroutine fu_initbutton ()
public subroutine fu_initmenu ()
public subroutine fu_setcontrol (integer control_type)
public subroutine fu_setcontrol (integer control_type, boolean control_state)
public function integer fu_getobjects (integer control_type, ref userobject controls[])
public subroutine fu_securecontrols ()
public subroutine fu_unwire (powerobject control_name)
public subroutine fu_wire (powerobject control_name)
public function integer fu_query (integer query_state)
public subroutine fu_queryreset ()
public subroutine fu_filterreset ()
public subroutine fu_searchreset ()
public subroutine fu_initccstatus ()
public subroutine fu_updateccstatus (long error_row, dwbuffer error_buffer)
public function integer fu_checkccstatus (long error_code, string error_message)
public function integer fu_new (long start_row, long num_rows)
public function integer fu_delete (long num_rows, long delete_rows[], integer changes)
public function integer fu_modify ()
public subroutine fu_setitem (long row_nbr, integer col_nbr, string value)
public function string fu_getitem (long row_nbr, integer col_nbr, dwbuffer buffer, integer values)
public subroutine fu_getcolinfo ()
public function integer fu_displayvalerror (string id, string error_message)
public function integer fu_displayvalerror (string id)
public function integer fu_displayvalerror ()
public function integer fu_save (integer changes)
public subroutine fu_resetccretry ()
public function integer fu_processccstatus ()
public subroutine fu_resetccstatus ()
public function integer fu_search (integer changes, integer reselect)
public function integer fu_filter (integer changes, integer reselect)
public function integer fu_itemerror (long row_nbr, string text)
public subroutine fu_itemfocuschanged ()
public function integer fu_rollback ()
public function boolean fu_checkchanges ()
public function integer fu_commit ()
public function integer fu_validate ()
public function integer fu_validatecol (long row_nbr, integer col_nbr)
public function integer fu_new (datawindow current_dw, long start_row, long num_rows)
public function integer fu_refresh (datawindow current_dw, integer children, string mode)
public subroutine fu_buildviewmode (unsignedlong view_color, string view_border)
public subroutine fu_setattribute (string column_name, integer attribute_type, unsignedlong attribute_value)
public function integer fu_setupdate (string table_name, string key_names[], string update_names[])
public function boolean fu_checkinstance (datawindow current_dw)
public function boolean fu_findinstance (datawindow current_dw, long row_nbr)
public function long fu_getinstancerow (datawindow current_dw)
public subroutine fu_setinstance (datawindow current_dw)
public subroutine fu_adduow (integer number_links, datawindow link_dw[])
public subroutine fu_allowcontrol (integer control_type, boolean control_state)
public subroutine fu_initcc ()
public function integer fu_getchildrencnt (datawindow current_dw)
public function integer fu_save (datawindow dw_name, integer changes, integer check_who)
public function integer fu_validaterow (long row_nbr)
public function integer fu_view (datawindow current_dw, integer refresh)
public function integer fu_modify (datawindow current_dw, integer refresh)
public function boolean fu_findshare (datawindow current_dw)
public function integer fu_itemchanged (long row_nbr, string text)
public function boolean fu_checkchangesuow ()
public subroutine fu_resetupdateuow ()
public subroutine fu_resetupdate ()
public function integer fu_drag ()
public subroutine fu_wiredrag (string drag_columns[], integer drag_method, datawindow drop_dw)
public subroutine fu_wiredrop (string drop_columns[])
public function integer fu_drop (dragobject drag_dw, long row_nbr)
public subroutine fu_setdragindicator (string single_row, string multiple_rows, string no_drop)
public function integer fu_copy (long num_rows, long copy_rows[], integer changes)
public function integer fu_promptchanges ()
public function integer fu_dragwithin (dragobject drag_dw, long row_nbr)
public function integer fu_getsavestatus ()
public subroutine fu_autoconfigmenu ()
public function integer fu_getchildrenlist (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[])
public function integer fu_getchildren (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[])
public function integer fu_validateuow ()
public function integer fu_dddwfind (long row_nbr, dwobject dwo, string text)
public function integer fu_dddwsearch (long row_nbr, dwobject dwo, string text)
public subroutine fu_buildinactivemode (unsignedlong inactive_color, boolean inactive_text, boolean inactive_col, boolean inactive_line)
public subroutine fu_getcolinfodef (integer a_ncolcount)
end prototypes

public subroutine fu_deleteuow (datawindow dw_name);
end subroutine

public subroutine fu_setviewmode (integer yes_or_no);RETURN
end subroutine

public subroutine fu_setinactivemode (integer yes_or_no);RETURN
end subroutine

public subroutine fu_batchattributes (integer on_or_off);
end subroutine

public subroutine fu_setattribute (string column_name, integer attribute_type, string attribute_value);
end subroutine

public subroutine fu_initbutton ();
end subroutine

public subroutine fu_initmenu ();
end subroutine

public subroutine fu_setcontrol (integer control_type);
end subroutine

public subroutine fu_setcontrol (integer control_type, boolean control_state);
end subroutine

public function integer fu_getobjects (integer control_type, ref userobject controls[]);RETURN 0
end function

public subroutine fu_securecontrols ();
end subroutine

public subroutine fu_unwire (powerobject control_name);
end subroutine

public subroutine fu_wire (powerobject control_name);
end subroutine

public function integer fu_query (integer query_state);RETURN 0
end function

public subroutine fu_queryreset ();
end subroutine

public subroutine fu_filterreset ();
end subroutine

public subroutine fu_searchreset ();
end subroutine

public subroutine fu_initccstatus ();
end subroutine

public subroutine fu_updateccstatus (long error_row, dwbuffer error_buffer);
end subroutine

public function integer fu_checkccstatus (long error_code, string error_message);RETURN 0
end function

public function integer fu_new (long start_row, long num_rows);RETURN 0
end function

public function integer fu_delete (long num_rows, long delete_rows[], integer changes);RETURN 0
end function

public function integer fu_modify ();RETURN 0
end function

public subroutine fu_setitem (long row_nbr, integer col_nbr, string value);//******************************************************************
//  PC Module     : n_DWSRV_MAIN
//  Subroutine    : fu_SetItem
//  Description   : Sets a column value for a row in the DataWindow 
//                  based on the data type of the column.
//
//  Parameters    : LONG    Row_Nbr -
//                     The row that is to be updated.
//                  INTEGER Col_Nbr -
//                     The column to be updated.
//                  STRING  Value -
//                     The value to be updated. NULL will set the
//                     value to null.
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

INTEGER  l_Space, l_NullNumber
STRING   l_Type, l_Date, l_Time, l_NullString
DATE     l_NullDate
DATETIME l_NullDateTime
DECIMAL  l_NullDec
TIME     l_NullTime

//------------------------------------------------------------------
//  Determine the type of column.
//------------------------------------------------------------------

l_Type = Upper(i_ServiceDW.Describe("#" + String(col_nbr) + ".coltype"))
IF Left(l_Type, 4) = "CHAR" THEN
	l_Type = "CHAR"
END IF
IF Left(l_Type, 3) = "DEC" THEN
	l_Type = "DEC"
END IF

//------------------------------------------------------------------
//  Set the new value into the column.
//------------------------------------------------------------------

CHOOSE CASE l_Type

	CASE "DATE"

      IF value <> "NULL" THEN
			i_ServiceDW.SetItem(row_nbr, col_nbr, Date(value))
		ELSE
			SetNull(l_NullDate)
			i_ServiceDW.SetItem(row_nbr, col_nbr, l_NullDate)
		END IF

	CASE "DATETIME"
 
      IF value <> "NULL" THEN
	      l_Space = Pos(value, " ")
  			IF l_Space > 0 THEN
     			l_Date = Mid(value, 1, l_Space - 1)
     			l_Time = Mid(value, l_Space + 1)
     			i_ServiceDW.SetItem(row_nbr, col_nbr, &
           		DateTime(Date(l_Date), Time(l_Time)))
  			ELSE
     			i_ServiceDW.SetItem(row_nbr, col_nbr, DateTime(Date(value)))
  			END IF
		ELSE
			SetNull(l_NullDateTime)
			i_ServiceDW.SetItem(row_nbr, col_nbr, l_NullDateTime)
		END IF

	CASE "DEC"

      IF value <> "NULL" THEN
	     	i_ServiceDW.SetItem(row_nbr, col_nbr, Dec(value))
		ELSE
			SetNull(l_NullDec)
			i_ServiceDW.SetItem(row_nbr, col_nbr, l_NullDec)
		END IF

	CASE "NUMBER", "LONG", "ULONG", "REAL"

      IF value <> "NULL" THEN
	      i_ServiceDW.SetItem(row_nbr, col_nbr, Double(value))
		ELSE
			SetNull(l_NullNumber)
			i_ServiceDW.SetItem(row_nbr, col_nbr, l_NullNumber)
		END IF

	CASE "TIME", "TIMESTAMP"

      IF value <> "NULL" THEN
	      i_ServiceDW.SetItem(row_nbr, col_nbr, Time(value))
		ELSE
			SetNull(l_NullTime)
			i_ServiceDW.SetItem(row_nbr, col_nbr, l_NullTime)
		END IF
 
	CASE "BLOB"

	CASE ELSE

      IF value <> "NULL" THEN
	      i_ServiceDW.SetItem(row_nbr, col_nbr, value)
		ELSE
			SetNull(l_NullString)
			i_ServiceDW.SetItem(row_nbr, col_nbr, l_NullString)
		END IF

END CHOOSE

end subroutine

public function string fu_getitem (long row_nbr, integer col_nbr, dwbuffer buffer, integer values);//******************************************************************
//  PC Module     : n_DWSRV_MAIN
//  Function      : fu_GetItem
//  Description   : Returns the current data from the specified
//                  field as a string.  If the field is NULL,
//                  the return value will be NULL.
//
//  Parameters    : LONG     Row_Nbr -
//                     The row number for the field from
//                     which to get the data.
//
//                  INTEGER  Col_Nbr -
//                     The column number for the field from
//                     which to get the data.
//
//                  DWBUFFER Buffer -
//                     Specified which DataWindow buffer to
//                     retrieve the data from (e.g. Primary!).
//
//                  INTEGER  Values -
//                     Specifies if the current values in
//                     the DataWindow or the orignal values
//                     from the database are to be returned.
//                     Values are:
//                        c_CCCurrentValues
//                        c_CCOriginalValues
//
//  Return Value  : STRING -
//                     The data at the specifed row and
//                     column.  May be NULL.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_Original
STRING   l_Type
STRING   l_Return
DECIMAL  l_Decimal
DATE     l_Date
DATETIME l_DateTime
TIME     l_Time

//------------------------------------------------------------------
//  Initialize the return to indicate that no data was found.
//------------------------------------------------------------------

SetNull(l_Return)

//------------------------------------------------------------------
//  Determine the type of column.
//------------------------------------------------------------------

l_Type = Upper(i_ServiceDW.Describe("#" + String(col_nbr) + ".coltype"))
IF Left(l_Type, 4) = "CHAR" THEN
	l_Type = "CHAR"
END IF
IF Left(l_Type, 3) = "DEC" THEN
	l_Type = "DEC"
END IF

//------------------------------------------------------------------
//  Determine what values we are getting from the DataWindow.
//------------------------------------------------------------------

l_Original = (values = c_OriginalValues)

//------------------------------------------------------------------
//  Based on the column data type, get the data from the specified
//  cell and and convert it to string.
//------------------------------------------------------------------

CHOOSE CASE l_Type

   CASE "DATE"

      l_Date = i_ServiceDW.GetItemDate(row_nbr, col_nbr, buffer, l_Original)

      IF IsNull(l_Date) <> FALSE THEN
      ELSE
         l_Return = String(l_Date)
      END IF

   CASE "DATETIME"

      l_DateTime = i_ServiceDW.GetItemDateTime(row_nbr, col_nbr, buffer, l_Original)

      IF IsNull(l_DateTime) <> FALSE THEN
      ELSE
         l_Return = String(l_DateTime)
      END IF

   CASE "DEC"

      l_Decimal = i_ServiceDW.GetItemDecimal(row_nbr, col_nbr, buffer, l_Original)

      IF IsNull(l_Decimal) <> FALSE THEN
      ELSE
         l_Return = String(l_Decimal)
      END IF

   CASE "NUMBER", "LONG", "ULONG", "REAL"

      IF IsNull(i_ServiceDW.GetItemNumber(row_nbr, col_nbr, buffer, l_Original)) <> FALSE THEN
      ELSE
         l_Return = String(i_ServiceDW.GetItemNumber(row_nbr, col_nbr, buffer, l_Original))
      END IF

   CASE "TIME", "TIMESTAMP"

      l_Time = i_ServiceDW.GetItemTime(row_nbr, col_nbr, buffer, l_Original)

      IF IsNull(l_Time) <> FALSE THEN
      ELSE
         l_Return = String(l_Time)
      END IF

	CASE "BLOB", "!", "?"
		//--------------------------------------------------
		// If this column is type "blob", an invalid item, or 
		// if there is no value, then skip validation     
		//--------------------------------------------------

   CASE ELSE

      IF IsNull(i_ServiceDW.GetItemString(row_nbr, col_nbr, buffer, l_Original)) <> FALSE THEN
      ELSE
     		l_Return = i_ServiceDW.GetItemString(row_nbr, col_nbr, buffer, l_Original)
		END IF

END CHOOSE

RETURN l_Return

end function

public subroutine fu_getcolinfo ();//******************************************************************
//  PC Module     : n_DWSRV_MAIN
//  Subroutine    : fu_GetColInfo
//  Description   : Get information about the columns in the 
//                  DataWindow.
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

STRING  l_EditStyles[], l_Check, l_Col, l_DBName
INTEGER l_Idx, l_Jdx, l_NumStyles, l_Pos, l_LowTab, l_TabOrder
BOOLEAN l_Found

//------------------------------------------------------------------
//  We can not find out what edit style the column is from
//  PowerBuilder.  Therefore, we will have to cycle through all the
//  possible types to see if we get a valid response.  Set up
//  an array containing all known styles.
//------------------------------------------------------------------

l_EditStyles[1] = ".Edit"
l_EditStyles[2] = ".DDDW"
l_EditStyles[3] = ".DDLB"
l_EditStyles[4] = ".EditMask"
l_NumStyles     = UpperBound(l_EditStyles[])

//------------------------------------------------------------------
//  Get the number of columns.
//------------------------------------------------------------------

i_NumColumns  = Integer(i_ServiceDW.Describe("datawindow.column.count"))
i_UpdateTable = i_ServiceDW.Describe("datawindow.table.updatetable")
IF i_UpdateTable = "?" OR i_UpdateTable = "!" THEN
	i_UpdateTable = ""
END IF
i_UpdateSettings = ""
i_UpdateReset = ""

l_LowTab = 9999
i_ColLowTabOrder = 1
FOR l_Idx = 1 TO i_NumColumns
	l_Col = "#" + String(l_Idx)

	//---------------------------------------------------------------
	//  Get the column data type.
	//---------------------------------------------------------------

	i_ColType[l_Idx] = Upper(i_ServiceDW.Describe(l_Col + ".coltype"))
	IF Left(i_ColType[l_Idx], 4) = "CHAR" THEN
		i_ColType[l_Idx] = "CHAR"
	ELSEIF Left(i_ColType[l_Idx], 3) = "DEC" THEN
		i_ColType[l_Idx] = "DEC"
	END IF

	//---------------------------------------------------------------
	//  Get the column name, visible, key, and update.
	//---------------------------------------------------------------

	i_ColName[l_Idx]			= i_ServiceDW.Describe(l_Col + ".name")
	i_ColVisible[l_Idx]		= (i_ServiceDW.Describe(l_Col + ".visible") = "1")
	i_ColKey[l_Idx]			= (Upper(i_ServiceDW.Describe(l_Col + ".key")) = "YES")
	i_ColUpdate[l_Idx]		= (Upper(i_ServiceDW.Describe(l_Col + ".update")) = "YES")

	//---------------------------------------------------------------
	//  Determine if the column is the lowest tab order.
	//---------------------------------------------------------------

	IF i_ColVisible[l_Idx] THEN
		l_TabOrder = Integer(i_ServiceDW.Describe(l_Col + ".TabSequence"))
		IF l_TabOrder > 0 THEN
			IF l_TabOrder < l_LowTab THEN
				i_ColLowTabOrder = l_Idx
				l_LowTab = l_TabOrder
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  If the column is updateable, get the update table.
	//---------------------------------------------------------------

	l_DBName = i_ServiceDW.Describe(l_Col + ".dbname")
	l_Pos = Pos(l_DBName, ".")
	IF l_Pos > 0 THEN
		i_ColTable[l_Idx] = MID(l_DBName, 1, l_Pos - 1)
		i_ColDBCol[l_Idx] = MID(l_DBName, l_Pos + 1)
	ELSE
		IF i_ColUpdate[l_Idx] THEN
			i_ColTable[l_Idx] = i_UpdateTable
			IF l_DBName <> "" THEN
				i_ColDBCol[l_Idx] = l_DBName
			ELSE
				i_ColDBCol[l_Idx] = i_ColName[l_Idx]
			END IF
		ELSE
			i_ColTable[l_Idx] = ""
			i_ColDBCol[l_Idx] = ""
		END IF
	END IF
 
	//---------------------------------------------------------------
	//  Get the validation message.
	//---------------------------------------------------------------

	i_ColValMsg[l_Idx]  = i_ServiceDW.Describe(l_Col + ".validationmsg")	
	IF i_ColValMsg[l_Idx] = "?" THEN
		i_ColValMsg[l_Idx] = ""
	END IF

	//------------------------------------------------------------------
	//  Get the required field and nilisnull values.
	//------------------------------------------------------------------

	l_Found = FALSE
	FOR l_Jdx = 1 TO l_NumStyles
   	l_Check = Upper(i_ServiceDW.Describe(l_Col + &
					 l_EditStyles[l_Jdx] + ".Required"))
   	IF l_Check <> "?" THEN

      	l_Found = TRUE
			i_ColRequired[l_Idx] = (l_Check = "YES")

			//---------------------------------------------------------
      	//  The column responded.  Now we can see if empty
      	//  strings are to be treated as NULL.
      	//---------------------------------------------------------

      	l_Check = Upper(i_ServiceDW.Describe(l_Col + &
					 	 l_EditStyles[l_Jdx] + ".NilIsNull"))

      	i_ColNilIsNull[l_Idx] = (l_Check = "YES")
			EXIT
   	END IF
	NEXT

	IF NOT l_Found THEN
		i_ColRequired[l_Idx]  = FALSE
		i_ColNilIsNull[l_Idx] = FALSE
	END IF

	//---------------------------------------------------------------
	//  If an update table exists then build the string to restore
	//  the original update settings in case the developer does a
	//  multiple table update.
	//---------------------------------------------------------------

	IF i_UpdateTable <> "" THEN
		IF i_ColKey[l_Idx] THEN
			i_UpdateSettings = i_UpdateSettings + l_Col + ".key=yes~t"
		ELSE
			i_UpdateSettings = i_UpdateSettings + l_Col + ".key=no~t"
		END IF
		IF i_ColUpdate[l_Idx] THEN
			i_UpdateSettings = i_UpdateSettings + l_Col + ".update=yes~t"
		ELSE
			i_UpdateSettings = i_UpdateSettings + l_Col + ".update=no~t"
		END IF
		i_UpdateReset    = i_UpdateReset + l_Col + ".key=no~t"
		i_UpdateReset    = i_UpdateReset + l_Col + ".update=no~t"
	END IF
NEXT

i_GotColInfo = TRUE
end subroutine

public function integer fu_displayvalerror (string id, string error_message);RETURN 0
end function

public function integer fu_displayvalerror (string id);RETURN 0
end function

public function integer fu_displayvalerror ();RETURN 0
end function

public function integer fu_save (integer changes);RETURN 0
end function

public subroutine fu_resetccretry ();
end subroutine

public function integer fu_processccstatus ();RETURN 0
end function

public subroutine fu_resetccstatus ();
end subroutine

public function integer fu_search (integer changes, integer reselect);RETURN 0
end function

public function integer fu_filter (integer changes, integer reselect);RETURN 0
end function

public function integer fu_itemerror (long row_nbr, string text);RETURN 0
end function

public subroutine fu_itemfocuschanged ();
end subroutine

public function integer fu_rollback ();RETURN 0
end function

public function boolean fu_checkchanges ();RETURN FALSE
end function

public function integer fu_commit ();RETURN 0
end function

public function integer fu_validate ();RETURN 0
end function

public function integer fu_validatecol (long row_nbr, integer col_nbr);RETURN 0
end function

public function integer fu_new (datawindow current_dw, long start_row, long num_rows);RETURN 0
end function

public function integer fu_refresh (datawindow current_dw, integer children, string mode);RETURN 0
end function

public subroutine fu_buildviewmode (unsignedlong view_color, string view_border);RETURN
end subroutine

public subroutine fu_setattribute (string column_name, integer attribute_type, unsignedlong attribute_value);
end subroutine

public function integer fu_setupdate (string table_name, string key_names[], string update_names[]);RETURN 0
end function

public function boolean fu_checkinstance (datawindow current_dw);RETURN FALSE
end function

public function boolean fu_findinstance (datawindow current_dw, long row_nbr);RETURN FALSE
end function

public function long fu_getinstancerow (datawindow current_dw);RETURN 0
end function

public subroutine fu_setinstance (datawindow current_dw);
end subroutine

public subroutine fu_adduow (integer number_links, datawindow link_dw[]);
end subroutine

public subroutine fu_allowcontrol (integer control_type, boolean control_state);
end subroutine

public subroutine fu_initcc ();
end subroutine

public function integer fu_getchildrencnt (datawindow current_dw);RETURN 0
end function

public function integer fu_save (datawindow dw_name, integer changes, integer check_who);RETURN 0
end function

public function integer fu_validaterow (long row_nbr);RETURN 0
end function

public function integer fu_view (datawindow current_dw, integer refresh);RETURN 0
end function

public function integer fu_modify (datawindow current_dw, integer refresh);RETURN 0
end function

public function boolean fu_findshare (datawindow current_dw);RETURN FALSE
end function

public function integer fu_itemchanged (long row_nbr, string text);RETURN 0
end function

public function boolean fu_checkchangesuow ();RETURN FALSE
end function

public subroutine fu_resetupdateuow ();
end subroutine

public subroutine fu_resetupdate ();
end subroutine

public function integer fu_drag ();RETURN 0
end function

public subroutine fu_wiredrag (string drag_columns[], integer drag_method, datawindow drop_dw);
end subroutine

public subroutine fu_wiredrop (string drop_columns[]);
end subroutine

public function integer fu_drop (dragobject drag_dw, long row_nbr);RETURN 0
end function

public subroutine fu_setdragindicator (string single_row, string multiple_rows, string no_drop);
end subroutine

public function integer fu_copy (long num_rows, long copy_rows[], integer changes);RETURN 0
end function

public function integer fu_promptchanges ();RETURN 0
end function

public function integer fu_dragwithin (dragobject drag_dw, long row_nbr);RETURN 0
end function

public function integer fu_getsavestatus ();//******************************************************************
//  PC Module     : n_DWSRV_Main
//  Function      : fu_GetSaveStatus
//  Description   : Return the button that was selected for the 
//                  save.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                     0 - No save prompt was displayed.
//                     1 - save was done.
//                     2 - save was not done.
//                     3 - save was cancelled.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

RETURN i_SaveStatus

end function

public subroutine fu_autoconfigmenu ();
end subroutine

public function integer fu_getchildrenlist (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[]);RETURN 0
end function

public function integer fu_getchildren (datawindow current_dw, ref u_dw_main children_dw[], ref boolean share_dw[]);RETURN 0
end function

public function integer fu_validateuow ();RETURN 0
end function

public function integer fu_dddwfind (long row_nbr, dwobject dwo, string text);RETURN 0
end function

public function integer fu_dddwsearch (long row_nbr, dwobject dwo, string text);RETURN 0
end function

public subroutine fu_buildinactivemode (unsignedlong inactive_color, boolean inactive_text, boolean inactive_col, boolean inactive_line);RETURN
end subroutine

public subroutine fu_getcolinfodef (integer a_ncolcount);//******************************************************************
//  PC Module     : n_DWSRV_MAIN
//  Subroutine    : fu_GetColInfoDef
//  Description   : Get information about the columns in the 
//                  DataWindow.  Set column count to value passed.
//
//  Parameters    : a_nColCount - Column Count for the datawindow
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

STRING  l_EditStyles[], l_Check, l_Col, l_DBName
INTEGER l_Idx, l_Jdx, l_NumStyles, l_Pos, l_LowTab, l_TabOrder
BOOLEAN l_Found

//------------------------------------------------------------------
//  We can not find out what edit style the column is from
//  PowerBuilder.  Therefore, we will have to cycle through all the
//  possible types to see if we get a valid response.  Set up
//  an array containing all known styles.
//------------------------------------------------------------------

l_EditStyles[1] = ".Edit"
l_EditStyles[2] = ".DDDW"
l_EditStyles[3] = ".DDLB"
l_EditStyles[4] = ".EditMask"
l_NumStyles     = UpperBound(l_EditStyles[])

//------------------------------------------------------------------
//  Get the number of columns.
//------------------------------------------------------------------

i_NumColumns  = a_nColCount
i_UpdateTable = i_ServiceDW.Describe("datawindow.table.updatetable")
IF i_UpdateTable = "?" OR i_UpdateTable = "!" THEN
	i_UpdateTable = ""
END IF
i_UpdateSettings = ""
i_UpdateReset = ""

l_LowTab = 9999
i_ColLowTabOrder = 1
FOR l_Idx = 1 TO i_NumColumns
	l_Col = "#" + String(l_Idx)

	//---------------------------------------------------------------
	//  Get the column data type.
	//---------------------------------------------------------------

	i_ColType[l_Idx] = Upper(i_ServiceDW.Describe(l_Col + ".coltype"))
	IF Left(i_ColType[l_Idx], 4) = "CHAR" THEN
		i_ColType[l_Idx] = "CHAR"
	ELSEIF Left(i_ColType[l_Idx], 3) = "DEC" THEN
		i_ColType[l_Idx] = "DEC"
	END IF

	//---------------------------------------------------------------
	//  Get the column name, visible, key, and update.
	//---------------------------------------------------------------

	i_ColName[l_Idx]			= i_ServiceDW.Describe(l_Col + ".name")
	i_ColVisible[l_Idx]		= (i_ServiceDW.Describe(l_Col + ".visible") = "1")
	i_ColKey[l_Idx]			= (Upper(i_ServiceDW.Describe(l_Col + ".key")) = "YES")
	i_ColUpdate[l_Idx]		= (Upper(i_ServiceDW.Describe(l_Col + ".update")) = "YES")

	//---------------------------------------------------------------
	//  Determine if the column is the lowest tab order.
	//---------------------------------------------------------------

	IF i_ColVisible[l_Idx] THEN
		l_TabOrder = Integer(i_ServiceDW.Describe(l_Col + ".TabSequence"))
		IF l_TabOrder > 0 THEN
			IF l_TabOrder < l_LowTab THEN
				i_ColLowTabOrder = l_Idx
				l_LowTab = l_TabOrder
			END IF
		END IF
	END IF

	//---------------------------------------------------------------
	//  If the column is updateable, get the update table.
	//---------------------------------------------------------------

	l_DBName = i_ServiceDW.Describe(l_Col + ".dbname")
	l_Pos = Pos(l_DBName, ".")
	IF l_Pos > 0 THEN
		i_ColTable[l_Idx] = MID(l_DBName, 1, l_Pos - 1)
		i_ColDBCol[l_Idx] = MID(l_DBName, l_Pos + 1)
	ELSE
		IF i_ColUpdate[l_Idx] THEN
			i_ColTable[l_Idx] = i_UpdateTable
			IF l_DBName <> "" THEN
				i_ColDBCol[l_Idx] = l_DBName
			ELSE
				i_ColDBCol[l_Idx] = i_ColName[l_Idx]
			END IF
		ELSE
			i_ColTable[l_Idx] = ""
			i_ColDBCol[l_Idx] = ""
		END IF
	END IF
 
	//---------------------------------------------------------------
	//  Get the validation message.
	//---------------------------------------------------------------

	i_ColValMsg[l_Idx]  = i_ServiceDW.Describe(l_Col + ".validationmsg")	
	IF i_ColValMsg[l_Idx] = "?" THEN
		i_ColValMsg[l_Idx] = ""
	END IF

	//------------------------------------------------------------------
	//  Get the required field and nilisnull values.
	//------------------------------------------------------------------

	l_Found = FALSE
	FOR l_Jdx = 1 TO l_NumStyles
   	l_Check = Upper(i_ServiceDW.Describe(l_Col + &
					 l_EditStyles[l_Jdx] + ".Required"))
   	IF l_Check <> "?" THEN

      	l_Found = TRUE
			i_ColRequired[l_Idx] = (l_Check = "YES")

			//---------------------------------------------------------
      	//  The column responded.  Now we can see if empty
      	//  strings are to be treated as NULL.
      	//---------------------------------------------------------

      	l_Check = Upper(i_ServiceDW.Describe(l_Col + &
					 	 l_EditStyles[l_Jdx] + ".NilIsNull"))

      	i_ColNilIsNull[l_Idx] = (l_Check = "YES")
			EXIT
   	END IF
	NEXT

	IF NOT l_Found THEN
		i_ColRequired[l_Idx]  = FALSE
		i_ColNilIsNull[l_Idx] = FALSE
	END IF

	//---------------------------------------------------------------
	//  If an update table exists then build the string to restore
	//  the original update settings in case the developer does a
	//  multiple table update.
	//---------------------------------------------------------------

	IF i_UpdateTable <> "" THEN
		IF i_ColKey[l_Idx] THEN
			i_UpdateSettings = i_UpdateSettings + l_Col + ".key=yes~t"
		ELSE
			i_UpdateSettings = i_UpdateSettings + l_Col + ".key=no~t"
		END IF
		IF i_ColUpdate[l_Idx] THEN
			i_UpdateSettings = i_UpdateSettings + l_Col + ".update=yes~t"
		ELSE
			i_UpdateSettings = i_UpdateSettings + l_Col + ".update=no~t"
		END IF
		i_UpdateReset    = i_UpdateReset + l_Col + ".key=no~t"
		i_UpdateReset    = i_UpdateReset + l_Col + ".update=no~t"
	END IF
NEXT

i_GotColInfo = TRUE
end subroutine

on n_dwsrv_main.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwsrv_main.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

