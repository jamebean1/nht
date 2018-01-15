$PBExportHeader$u_dddw_search_main.sru
$PBExportComments$DDDW search class (ancestor)
forward
global type u_dddw_search_main from datawindow
end type
end forward

global type u_dddw_search_main from datawindow
integer width = 731
integer height = 92
integer taborder = 1
event po_valempty ( )
event po_validate ( ref string searchvalue )
event po_identify pbm_custom73
end type
global u_dddw_search_main u_dddw_search_main

type variables
//----------------------------------------------------------------------------------------
//  Search Object Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName	= "Search"
CONSTANT INTEGER	c_ValOK		= 0
CONSTANT INTEGER	c_ValFailed	= 1

//----------------------------------------------------------------------------------------
//  Search Object Instance Variables
//----------------------------------------------------------------------------------------

DATAWINDOW		i_SearchDW
BOOLEAN		i_FrameWorkDW

TRANSACTION		i_SearchTransObj
STRING			i_SearchTable
STRING			i_SearchColumn
STRING			i_SearchDBColumn
STRING			i_SearchValue
STRING			i_SearchOriginal

INTEGER		i_SearchError

STRING			i_LoadTable
STRING			i_LoadCode
STRING			i_LoadDesc
STRING			i_LoadWhere
STRING			i_LoadKeyword

BOOLEAN		i_DWCValid
DATAWINDOWCHILD	i_DWC
STRING			i_DWCColName

end variables

forward prototypes
public function string fu_selectcode ()
public function integer fu_refreshcode ()
public function integer fu_resetcode ()
public function integer fu_setcode (string default_code)
public function integer fu_loadcode (string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public function integer fu_buildsearch (boolean search_reset)
public function integer fu_wiredw (datawindow search_dw, string search_table, string search_column, transaction search_transobj)
public subroutine fu_unwiredw ()
public function string fu_getidentity ()
end prototypes

event po_valempty;////******************************************************************
////  PO Module     : u_DDDW_Search_Main
////  Event         : po_ValEmpty
////  Description   : Provides the opportunity for the developer to
////                  generate errors when the user has not made a
////                  selection in the this object.
////
////  Return Value  : i_SearchError -
////                     c_ValOK     = OK
////                     c_ValFailed = Error, criteria is required.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1994-1996.  All Rights Reserved.
////******************************************************************
//
////-------------------------------------------------------------------
////  Return c_ValFailed to indicate that this search object is required.
////-------------------------------------------------------------------
//
////OBJCA.MSG.fu_DisplayMessage("RequiredField")
////i_SearchError = c_ValFailed
end event

event po_validate;////******************************************************************
////  PO Module     : u_DDDW_Search_Main
////  Event         : po_Validate
////  Description   : Provides the opportunity for the developer to
////                  write code to validate the fields in this
////                  object.
////
////  Parameters    : REF STRING SearchValue - 
////                         The input the user has made.
////
////  Return Value  : i_SearchError - 
////
////                  If the developer codes the validation 
////                  testing, then the developer should set
////                  one of the following validation return
////                  values:
////
////                  c_ValOK     = The validation test passed and 
////                                the data is to be accepted.
////                  c_ValFailed = The validation test failed and 
////                                the data is to be rejected.  
////                                Do not allow the user to move 
////                                off of this field.
////
////  Change History:
////
////  Date     Person     Description of Change
////  -------- ---------- --------------------------------------------
////
////******************************************************************
////  Copyright ServerLogic 1992-1996.  All Rights Reserved.
////******************************************************************
//
////i_SearchError OBJCA.FIELD.fu_ValidateMaxLen(SearchValue, 10, TRUE)
end event

event po_identify;//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Event         : po_Identify
//  Description   : Identifies this object as belonging to a 
//                  ServerLogic product.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

end event

public function string fu_selectcode ();//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Function      : fu_SelectCode
//  Description   : Select the code associated with the description
//                  from this object.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     Returns the code as a string.  If no value
//                     is selected, a NULL string is returned.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Check to see if the FIELD manager exists.  If not, create it.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.FIELD) THEN
	OBJCA.MGR.fu_CreateManagers(OBJCA.MGR.c_FieldManager)
END IF

//------------------------------------------------------------------
// Get the selected value.
//------------------------------------------------------------------

RETURN OBJCA.FIELD.fu_SelectCode(THIS, i_DWCColName)

end function

public function integer fu_refreshcode ();//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Function      : fu_RefreshCode
//  Description   : Re-retrieves the data into this DataWindow.  
//                  Note that the fu_LoadCode() routine does the 
//                  first retrieve.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = Error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN          l_HaveAllKeyWord, l_IsNumber
LONG             l_Error
STRING           l_ColStr, l_AllKeyWord, l_Attrib, l_ErrorStrings[]
DATAWINDOWCHILD  l_DWC

//------------------------------------------------------------------
//  Set the number and name of the DDDW column.
//------------------------------------------------------------------

l_ColStr = Describe("#1.Name")

//------------------------------------------------------------------
//  Get the child DataWindow.  If column is not a DDDW column,
//  then return with error.  Otherwise, we need to do the retrieve.
//------------------------------------------------------------------

l_Error = GetChild(l_ColStr, l_DWC)

IF l_Error <> 1 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = GetParent().ClassName()
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_RefreshCode"
   OBJCA.MSG.fu_DisplayMessage("DDDWFindError", 5, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Get the ALL keyword from the child DataWindow.
//------------------------------------------------------------------

l_HaveAllKeyWord = FALSE
IF l_DWC.RowCount() > 0 THEN
   l_Attrib   = l_DWC.Describe("#2.ColType")
   l_IsNumber = (Upper(l_Attrib) = "NUMBER")
      
   IF l_IsNumber THEN
      l_AllKeyWord     = String(l_DWC.GetItemNumber(1, 2))
      l_HaveAllKeyWord = (l_AllKeyWord = "-99999")
   ELSE
      l_AllKeyWord     = l_DWC.GetItemString(1, 2)
      l_HaveAllKeyWord = (l_AllKeyWord = "(ALL)")
   END IF

   IF l_HaveAllKeyWord THEN
      l_AllKeyWord = l_DWC.GetItemString(1, 1)
   END IF
END IF

//------------------------------------------------------------------
//  Insert a row for the user into the parent DataWindow.
//------------------------------------------------------------------

Reset()
l_Error = InsertRow(0)

IF l_Error < 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = GetParent().ClassName()
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_RefreshCode"
   OBJCA.MSG.fu_DisplayMessage("DDDWInsertError", 5, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Retrieve the data for the child DataWindow.
//------------------------------------------------------------------

l_Error = l_DWC.Retrieve()

IF l_Error < 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = GetParent().ClassName()
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_RefreshCode"
   OBJCA.MSG.fu_DisplayMessage("DDDWRetrieveError", 5, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  If an ALL keyword is given, re-insert it into the first row
//  on the child DataWindow.
//------------------------------------------------------------------

IF l_HaveAllKeyWord THEN
   IF l_DWC.InsertRow(1) > 0 THEN
      l_DWC.SetItem(1, 1, l_AllKeyWord)

      IF l_IsNumber THEN
         l_DWC.SetItem(1, 2, -99999)
      ELSE
         l_DWC.SetItem(1, 2, "(ALL)")
      END IF
   END IF
END IF

//------------------------------------------------------------------
//  Indicate that there not any errors.
//------------------------------------------------------------------

RETURN 0
end function

public function integer fu_resetcode ();//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Function      : fu_ResetCode
//  Description   : Clears the selection in the DDDW search object.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = Insert Error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Error
STRING  l_ErrorStrings[]

Reset()
l_Error = InsertRow(0)

IF l_Error < 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = GetParent().ClassName()
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_ResetCode"
   OBJCA.MSG.fu_DisplayMessage("DDDWInsertError", 5, l_ErrorStrings[])
   RETURN -1
END IF

RETURN 0
end function

public function integer fu_setcode (string default_code);//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Subroutine    : fu_SetCode
//  Description   : Sets a default value for this object.
//
//  Parameters    : STRING Default_Code -
//                     The value to set for this object.
//
//  Return Value  : INTEGER -
//                      0 = set OK.
//                     -1 = set failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Check to see if the FIELD manager exists.  If not, create it.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.FIELD) THEN
	OBJCA.MGR.fu_CreateManagers(OBJCA.MGR.c_FieldManager)
END IF

//------------------------------------------------------------------
//  Set the default value.
//------------------------------------------------------------------

RETURN OBJCA.FIELD.fu_SetCode(THIS, i_DWCColName, default_code)

end function

public function integer fu_loadcode (string table_name, string column_code, string column_desc, string where_clause, string all_keyword);//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Function      : fu_LoadCode
//  Description   : Load the code table using codes and descriptions
//                  from the database.
//
//  Parameters    : STRING Table_Name   - 
//                     Table from where the column with the code
//                     values resides.
//                  STRING Column_Code  - 
//                     Column name with the code values.
//                  STRING Column_Desc  - 
//                     Column name with the code descriptions.
//                  STRING Where_Clause - 
//                     WHERE cause statement to restrict the code 
//                     values.
//                  STRING All_Keyword  - 
//                     Keyword to denote select all values (e.g. 
//                     "(All)").
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

i_LoadTable   = table_name
i_LoadCode    = column_code
i_LoadDesc    = column_desc
i_LoadWhere   = where_clause
i_LoadKeyword = all_keyword

//------------------------------------------------------------------
//  Check to see if the FIELD manager exists.  If not, create it.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.FIELD) THEN
	OBJCA.MGR.fu_CreateManagers(OBJCA.MGR.c_FieldManager)
END IF

//------------------------------------------------------------------
//  Load the code table.
//------------------------------------------------------------------

RETURN OBJCA.FIELD.fu_LoadCode(THIS, i_DWCColName, i_SearchTransObj, &
                               table_name, column_code, column_desc, &
										 where_clause, all_keyword)

end function

public function integer fu_buildsearch (boolean search_reset);//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Function      : fu_BuildSearch
//  Description   : Extends the WHERE clause of a SQL Select 
//                  with the values in this search object.
//
//  Parameters    : BOOLEAN Search_Reset -
//                     Should the SQL Select be reset to its
//                     original state before the building begins.
//
//  Return Value  : INTEGER -
//                      0 = build OK.
//                     -1 = validation error.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_GroupByPos, l_OrderByPos
STRING   l_Text, l_ColumnType, l_Concat, l_NewSelect
STRING   l_GroupBy, l_OrderBy, l_Quotes, l_Other

//------------------------------------------------------------------
//  See if the DataWindow search criteria needs to be reset to its
//  original syntax.
//------------------------------------------------------------------

IF search_reset THEN
	
   //---------------------------------------------------------------
   //  If this is a PowerClass datawindow, grab the original select
   //  statement from it.
   //---------------------------------------------------------------
   
	IF i_SearchDW.TriggerEvent("po_identify") = 1 THEN
		IF i_SearchDW.DYNAMIC fu_GetIdentity() = "DataWindow" THEN
			i_SearchOriginal = i_SearchDW.DYNAMIC fu_GetSQLSelect()
		END IF
	END IF
	
   i_SearchDW.Modify('datawindow.table.select="' + &
                     i_SearchOriginal + '"')
END IF

l_NewSelect = i_SearchDW.Describe("datawindow.table.select")
l_Text      = THIS.fu_SelectCode()

//------------------------------------------------------------------
//  If this object has been un-wired, don't include in build.
//------------------------------------------------------------------

IF IsNull(i_SearchDW) <> FALSE THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  If the SQL statement for this DataWindow does not currently
//  have a WHERE clause, then we need to add one.  If it already
//  does have a WHERE clause, we will just concatenate additional
//  criteria to it.
//------------------------------------------------------------------

IF Pos(Upper(l_NewSelect), "WHERE") = 0 THEN
   l_Concat = " WHERE "
ELSE
   l_Concat = " AND "
END IF

//------------------------------------------------------------------
//  See if we have an "GROUP BY" clause and remove it from the
//  select statement for the time being.
//------------------------------------------------------------------

l_GroupBy    = ""
l_GroupByPos = Pos(Upper(l_NewSelect), "GROUP BY")
IF l_GroupByPos > 0 THEN
   l_GroupBy   = " " + Mid(l_NewSelect, l_GroupByPos)
   l_NewSelect = Mid(l_NewSelect, 1, l_GroupByPos - 1)
ELSE

   //---------------------------------------------------------------
   //  See if we have an "ORDER BY" clause and remove it from the
   //  select statement for the time being.
   //---------------------------------------------------------------

   l_OrderBy    = ""
   l_OrderByPos = Pos(Upper(l_NewSelect), "ORDER BY")
   IF l_OrderByPos > 0 THEN
      l_OrderBy   = " " + Mid(l_NewSelect, l_OrderByPos)
      l_NewSelect = Mid(l_NewSelect, 1, l_OrderByPos - 1)
   END IF
END IF

//------------------------------------------------------------------
//  Check to see if the developer made this a required field for
//  search criteria.
//------------------------------------------------------------------

IF l_Text = "" THEN
	i_SearchError = c_ValOK
   i_SearchValue = l_Text

   //---------------------------------------------------------------
   //  If we get a validation error, abort the search.
   //---------------------------------------------------------------

   Event po_ValEmpty()

   IF i_SearchError = c_ValFailed THEN
      SetFocus()
      RETURN -1
   ELSE
      RETURN 0
   END IF
END IF

//------------------------------------------------------------------
//  Assume that it does not contain anything that needs quoting.
//------------------------------------------------------------------

l_Quotes = ""

//------------------------------------------------------------------
//  See what type of data this search object contains.
//------------------------------------------------------------------

l_ColumnType = Upper(i_SearchDW.Describe(i_SearchColumn + ".ColType"))
IF Left(l_ColumnType, 3) = "DEC" THEN
   l_ColumnType = "NUMBER"
END IF

CHOOSE CASE l_ColumnType
   CASE "NUMBER", "LONG", "ULONG", "REAL"
   CASE "DATE"
   CASE "DATETIME"
   CASE "TIME"

      //------------------------------------------------------------
      //  We have a data type that needs to be quoted (e.g. STRING).
      //------------------------------------------------------------

   CASE ELSE
      l_Quotes = "'"
END CHOOSE

//------------------------------------------------------------------
//  Stuff the current token in and perform valdiation.
//------------------------------------------------------------------

i_SearchError = c_ValOK
i_SearchValue = l_Text

//------------------------------------------------------------------
//  If we get a validation error, abort the search.
//------------------------------------------------------------------

Event po_Validate(i_SearchValue)

IF i_SearchError = c_ValFailed THEN
   SetFocus()
   RETURN -1
END IF

//------------------------------------------------------------------
//  If we got to here, validation must have been successful. 
//  Validation may have modified the token.  Grab it back.
//------------------------------------------------------------------

l_Text = i_SearchValue

//------------------------------------------------------------------
//  Add the validated value.
//------------------------------------------------------------------

l_Other = l_Quotes + l_Text + l_Quotes

//------------------------------------------------------------------
//  Add the snippet of SQL generated by the this object to our new 
//  SQL statement.
//------------------------------------------------------------------

IF Len(l_Other) > 0 THEN
   l_NewSelect = l_NewSelect + l_Concat + "(" + i_SearchTable + &
                               "." + i_SearchDBColumn + &
                               " IN (" + l_Other + "))"
END IF

//------------------------------------------------------------------
//  Stuff the parameter with the completed SQL statement.
//------------------------------------------------------------------

l_NewSelect = "datawindow.table.select='" + &
              OBJCA.MGR.fu_QuoteString(l_NewSelect, "'") + &
              OBJCA.MGR.fu_QuoteString(l_GroupBy, "'")   + &
              OBJCA.MGR.fu_QuoteString(l_OrderBy, "'")   + "'"
i_SearchDW.Modify(l_NewSelect)

RETURN 0
end function

public function integer fu_wiredw (datawindow search_dw, string search_table, string search_column, transaction search_transobj);//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Subroutine    : fu_WireDW
//  Description   : Wires a column in a DataWindow to this object.
//
//  Parameters    : DATAWINDOW Search_DW -
//                     The DataWindow that is to be wired to
//                     this object.
//                  STRING Search_Table -
//                     The table in the database that this
//                     object should build the WHERE clause for.
//                  STRING Search_Column -
//                     The column in the database that this
//                     object should build the WHERE clause for.
//                  TRANSACTION Search_TransObj - 
//                     Transaction object associated with the
//                     DataWindow.
//
//  Return Value  : INTEGER -
//                      0 = valid DataWindow.
//                     -1 = invalid DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

INTEGER l_Return = -1

//------------------------------------------------------------------
//  Make sure that we were passed a valid DataWindow to be wired.
//------------------------------------------------------------------

IF IsValid(search_dw) THEN

   //---------------------------------------------------------------
   //  Remember the DataWindow tabe and column for searching.
   //---------------------------------------------------------------

   i_SearchDW       = search_dw
   i_SearchTable    = search_table
   i_SearchColumn   = search_column
   i_SearchTransObj = search_transobj
   i_SearchOriginal = i_SearchDW.Describe("datawindow.table.select")
   
   //---------------------------------------------------------------
   //  Find the database column name using the datawindow column
	//  name.  If the datawindow column doesn't exist, assume the
	//  name is the database column name. Since we don't have a
	//  datawindow column to check, we have to assume the column
	//  type is string.
   //---------------------------------------------------------------

   i_SearchDBColumn = i_SearchDW.Describe(i_SearchColumn + ".dbname")
	IF IsNull(i_SearchDBColumn) OR i_SearchDBColumn = "!" OR &
		i_SearchDBColumn = "?" THEN
		i_SearchDBColumn = i_SearchColumn
	ELSE
		IF Pos(i_SearchDBColumn, ".") > 0 THEN
			i_SearchDBColumn = Mid(i_SearchDBColumn, Pos(i_SearchDBColumn, ".") + 1)
		END IF
	END IF

   //---------------------------------------------------------------
   //  Determine if the DataWindow is a Framework DataWindow.
   //---------------------------------------------------------------

	IF i_SearchDW.TriggerEvent("po_Identify") = 1 THEN
		i_FrameWorkDW = TRUE
		i_SearchDW.DYNAMIC fu_Wire(THIS)
	END IF
	
	IF NOT IsValid(SECCA.MGR) THEN
		Enabled       = TRUE
	END IF
   l_Return         = 0

END IF

RETURN l_Return
end function

public subroutine fu_unwiredw ();//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Subroutine    : fu_UnwireDW
//  Description   : Un-wires a DataWindow from this object.
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
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  If the DataWindow is a Framework DataWindow, send a message to
//  it to unwire it.
//------------------------------------------------------------------

IF i_FrameWorkDW THEN
	i_SearchDW.DYNAMIC fu_Unwire(THIS)
END IF

SetNull(i_SearchDW)
IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF


end subroutine

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Subroutine    : fu_GetIdentity
//  Description   : Returns the identity of this object.
//
//  Parameters    : (None)
//
//  Return Value  : STRING -
//                     Identity of this object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN c_ObjectName
end function

event resize;//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Event         : Resize
//  Description   : Resizes the search object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_XPos, l_YPos
LONG     l_Width, l_Height
STRING   l_Modify, l_ErrStr

l_Width  = UnitsToPixels(Width, XUnitsToPixels!) - 2
l_Height = UnitsToPixels(Height, YUnitsToPixels!) - 2

IF Border THEN
   IF BorderStyle = StyleBox! THEN
      Border = FALSE
   END IF
	
   //---------------------------------------------------------------
   //  Adjust the width and height of the DDDW column based on the
   //  border style of the datawindow control.  If the datawindow
   //  control's border overlaps the DDDW column (even if just 
   //  barely!) the column will behave as if it is disabled (i.e.
   //  you won't be able to drop the DDDW.
   //---------------------------------------------------------------
   
	CHOOSE CASE BorderStyle
      CASE StyleLowered!
         l_XPos   = -1
         l_YPos   = -2
         l_Width  = l_Width - 2
			l_Height = l_Height - 3
      CASE StyleRaised!
         l_XPos   = 1
         l_YPos   = -2
         l_Width  = l_Width - 2
			l_Height = l_Height - 2
      CASE StyleShadowBox!
         l_XPos   = 0
         l_YPos   = -2
         l_Width  = l_Width - 1
   END CHOOSE
ELSE
   IF TitleBar THEN
      l_XPos   = 0
      l_YPos   = -1
      l_Height = l_Height - 1
   ELSE
      l_XPos   = 1
      l_YPos   = 0
      l_Width  = l_Width  - 2
      l_Height = l_Height - 2
   END IF
END IF

l_XPos     = PixelsToUnits(l_XPos,   XPixelsToUnits!)
l_YPos     = PixelsToUnits(l_YPos,   YPixelsToUnits!)
l_Width    = PixelsToUnits(l_Width,  XPixelsToUnits!)
l_Height   = PixelsToUnits(l_Height, YPixelsToUnits!)

l_Modify = "#1.X=" + String(l_XPos)
l_ErrStr = Modify(l_Modify)

l_Modify = "#1.Y=" + String(l_YPos)
l_ErrStr = Modify(l_Modify)

l_Modify = "#1.Width=" + String(l_Width)
l_ErrStr = Modify(l_Modify)

IF i_DWCValid THEN
   l_ErrStr = i_DWC.Modify(l_Modify)
END IF

l_Modify = "#1.Height=" + String(l_Height)
l_ErrStr = Modify(l_Modify)

IF i_DWCValid THEN
   l_ErrStr = i_DWC.Modify(l_Modify)
END IF
end event

event constructor;//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Event         : Constructor
//  Description   : Initializes the search object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING     l_Modify, l_Attrib, l_ErrStr
USEROBJECT l_UserObject
WINDOW     l_Window

IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF
SetNull(i_SearchDW)

IF Parent.TypeOf() = UserObject! THEN
   l_UserObject = Parent
   l_Attrib     = String(l_UserObject.BackColor)
ELSE
   l_Window     = Parent
   l_Attrib     = String(l_Window.BackColor)
END IF

l_Modify = "DataWindow.Color=" + l_Attrib
l_ErrStr = Modify(l_Modify)

l_Modify = "DataWindow.Header.Color=" + l_Attrib
l_ErrStr = Modify(l_Modify)

l_Modify = "DataWindow.Detail.Color=" + l_Attrib
l_ErrStr = Modify(l_Modify)

l_Modify = "DataWindow.Footer.Color=" + l_Attrib
l_ErrStr = Modify(l_Modify)

l_Modify = "#1.DDDW.UseAsBorder=Yes"
l_ErrStr = Modify(l_Modify)

l_Modify = "#1.Border=0"
l_ErrStr = Modify(l_Modify)

//------------------------------------------------------------------
//  Set the number and name of the DDDW column.
//------------------------------------------------------------------

i_DWCColName = Describe("#1.Name")

//------------------------------------------------------------------
//  Get the child DataWindow.
//------------------------------------------------------------------

i_DWCValid = (GetChild(i_DWCColName, i_DWC) = 1)
#IF  defined PBDOTNET THEN
	THIS.resize( width, height)
#ELSE
	This.TriggerEvent('Resize')
#END IF

end event

event destructor;//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Event         : Destructor
//  Description   : When this object is destroyed, unwire it from
//                  the DataWindow.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsNull(i_SearchDW) = FALSE THEN
	THIS.fu_UnwireDW()
END IF
end event

event getfocus;//******************************************************************
//  PO Module     : u_DDDW_Search_Main
//  Event         : GetFocus
//  Description   : If the DataWindow is a Framework DW, make it
//                  active.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsValid(i_SearchDW) THEN
	IF i_FrameWorkDW THEN
		i_SearchDW.DYNAMIC fu_Activate()
	END IF
END IF
end event

on u_dddw_search_main.create
end on

on u_dddw_search_main.destroy
end on

