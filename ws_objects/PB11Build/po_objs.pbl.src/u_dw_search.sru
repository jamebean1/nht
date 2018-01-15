﻿$PBExportHeader$u_dw_search.sru
$PBExportComments$DataWindow search class
forward
global type u_dw_search from datawindow
end type
end forward

global type u_dw_search from datawindow
integer width = 1422
integer height = 636
integer taborder = 1
string dataobject = "d_main"
event po_validate ( string searchvalue,  string searchcolumn,  integer searchrow,  string searchvalmsg,  boolean searchrequirederror )
event po_identify pbm_custom74
end type
global u_dw_search u_dw_search

type variables
//----------------------------------------------------------------------------------------
//  Search Object Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName	= "Search DW"
CONSTANT INTEGER	c_ValOK		= 0
CONSTANT INTEGER	c_ValFailed	= 1
CONSTANT INTEGER	c_ValFixed	= 2
CONSTANT INTEGER	c_ValNotProcessed	= -9

//----------------------------------------------------------------------------------------
//  Search Object Instance Variables
//----------------------------------------------------------------------------------------

DATAWINDOW		i_SearchDW
BOOLEAN		i_FrameWorkDW

STRING			i_ColumnName[]
STRING			i_ColumnTabOrder[]
STRING			i_ColumnEditStyle[]
STRING			i_ColumnDefault[]

TRANSACTION		i_SearchTransObj
STRING			i_SearchTable[]
STRING			i_SearchDBColumn[]
STRING			i_SearchDWColumn[]
INTEGER		i_NumSearch

STRING			i_LoadTable[]
STRING			i_LoadCode[]
STRING			i_LoadDesc[]
STRING			i_LoadWhere[]
STRING			i_LoadKeyword[]

INTEGER		i_SearchRow	= 1
STRING			i_SearchColumn
STRING			i_SearchValue
STRING			i_SearchValMsg
BOOLEAN		i_SearchRequired

INTEGER		i_SearchError
BOOLEAN		i_SearchRequiredError
BOOLEAN		i_SearchModified
STRING			i_SearchOriginal

INTEGER		i_InItemError
BOOLEAN		i_IgnoreVal
BOOLEAN		i_DisplayRequired
BOOLEAN		i_ItemValidated

BOOLEAN		i_DWCValid
DATAWINDOWCHILD	i_DWC
STRING			i_DWCColName

STRING			i_DateFormat

end variables

forward prototypes
public function integer fu_setcode (string search_column, string default_code)
public function integer fu_showcolumn (string search_column)
public function integer fu_hidecolumn (string search_column)
public function integer fu_enablecolumn (string search_column)
public function integer fu_disablecolumn (string search_column)
public function integer fu_refreshcode (string search_column)
public subroutine fu_reset ()
public function string fu_selectcode (string search_column)
public function integer fu_wiredw (string column_name[], datawindow search_dw, string search_table[], string search_column[], transaction search_transobj)
public function integer fu_loadcode (string search_column, string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public subroutine fu_unwiredw ()
public function string fu_getidentity ()
public function integer fu_buildsearch (boolean search_reset)
end prototypes

event po_validate;////******************************************************************
////  PO Module     : u_DW_Search
////  Event         : po_Validate
////  Description   : Provides the opportunity for the developer to
////                  write code to validate the fields in this
////                  DataWindow.
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
////                  c_ValFixed  = The validation test failed.  
////                                However, the data was able to be
////                                modified by developer to pass the
////                                validation test.  If a developer
////                                returns this code, they are 
////                                responsible for doing a SetItem()
////                                to place the fixed value into the
////                                column.  Note that if the 
////                                DataWindow validation routines 
////                                are used, they will do the 
////                                SetItem(), if necessary.
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
////------------------------------------------------------------------
////  The following parameters are available for the developer within
////  this event:
////
////      STRING SearchValue -
////         The input the user has made.
////
////      STRING SearchColumn -
////         The name of the column being validated, folded
////         to lower case.
////
////      INTEGER SearchRow -
////         The row number of this DataWindow.  This value is
////         always equal to 1.
////
////      STRING SearchValMsg -
////         The validation error message provided by
////         PowerBuilder's extended column definition.
////
////      BOOLEAN SearchRequiredError -
////         This column is a required field and the user has
////         not entered anything.
////------------------------------------------------------------------
//
////------------------------------------------------------------------
////  Determine which column to validate.
////------------------------------------------------------------------
//
//CHOOSE CASE SearchColumn
//
////   //-------------------------------------------------------------
////   //  Enter the code for each column you want to validate.
////   //  <column> should be replaced by the name of the column
////   //  from the DataWindow.  Use the i_SearchError variable to
////   //  return the status of the validation.  Some sample
////   //  validation functions are listed below.  
////   //-------------------------------------------------------------
//
////   CASE "<column1>"
//
////      i_SearchError = OBJCA.FIELD.fu_ValidateInt(SearchValue, "##,##0", TRUE)
//
////   CASE "<column2>"
//
////      IF OBJCA.FIELD.fu_ValidateDec(SearchValue, "", TRUE) <> c_ValFailed THEN
////         IF Real(SearchValue) < 0 THEN
////            MessageBox("Search Error", "<error_message>")
////            i_SearchError = c_ValFailed
////         END IF
////      END IF
//
////   CASE "<column3>"
//
////      IF Upper(Left(SearchValue, 1)) = "Y"  THEN
////         SetItem(SearchRow, SearchColumn, "Yes")
////         i_SearchError = c_ValFixed
////      ELSE
////         IF Upper(Left(SearchValue, 1)) = "N"  THEN
////            SetItem(SearchRow, SearchColumn, "No")
////            i_SearchError = c_ValFixed
////         ELSE
////            MessageBox("Search Error", &
////                "Valid responses are 'Y' and 'N'")
////            i_SearchError = c_ValFailed
////         END IF
////      END IF
//
////   CASE "<column4>"
//
////      IF SearchRequiredError THEN
////         IF MessageBox("Search Error", &
////                "Do you want a default value of 'Active'?", &
////                Question!, YesNo!, 1) = 1 THEN
////            SetItem(SearchRow, SearchColumn, "Active")
////            i_SearchError = c_ValFixed
////         ELSE
////            i_SearchError = c_ValFailed
////         END IF
////      END IF
//
////   CASE "<column5>"  
////
////      //----------------------------------------------------------
////      //  Generate a default value for a CheckBox
////      //----------------------------------------------------------
////
////      IF SearchRequiredError THEN
////         SetItem(SearchRow, SearchColumn, "N")
////         i_SearchError = c_ValFixed
////      END IF
//
//END CHOOSE
end event

event po_identify;//******************************************************************
//  PO Module     : u_DW_Search
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

public function integer fu_setcode (string search_column, string default_code);//******************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_SetCode
//  Description   : Sets a default value for a column in this
//                  object.
//
//  Parameters    : STRING Search_Column -
//                     The column in this DataWindow to set the
//                     default code for.
//                  STRING Default_Code  -
//                     The default value to set.
//
//  Return Value  : INTEGER -
//                      0 = set OK.
//                     -1 = set failed or invalid column.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

//------------------------------------------------------------------
//  Check to see if the FIELD manager exists.  If not, create it.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.FIELD) THEN
	OBJCA.MGR.fu_CreateManagers(OBJCA.MGR.c_FieldManager)
END IF

//------------------------------------------------------------------
//  Save the default value.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSearch
	IF i_ColumnName[l_Idx] = search_column THEN
		i_ColumnDefault[l_Idx] = default_code
		EXIT
	END IF
NEXT

//------------------------------------------------------------------
//  Set the default value.
//------------------------------------------------------------------

RETURN OBJCA.FIELD.fu_SetCode(THIS, search_column, default_code)

end function

public function integer fu_showcolumn (string search_column);//******************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_ShowColumn
//  Description   : Make a column on this DataWindow visible.
//
//  Parameters    : STRING Search_Column -
//                     The column in this DataWindow to set to
//                     visible.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = invalid column.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING l_Return

l_Return = Modify(search_column + ".Visible=1")


IF l_Return = "" THEN
   RETURN 0
ELSE
   RETURN -1
END IF

end function

public function integer fu_hidecolumn (string search_column);//******************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_HideColumn
//  Description   : Make a column on this DataWindow invisible.
//
//  Parameters    : STRING Search_Column -
//                     The column in this DataWindow to set to
//                     invisible.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = invalid column.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING l_Return

l_Return = Modify(search_column + ".Visible=0")

IF l_Return = "" THEN
   RETURN 0
ELSE
   RETURN -1
END IF

end function

public function integer fu_enablecolumn (string search_column);//******************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_EnableColumn
//  Description   : Make a column on this DataWindow enabled.
//
//  Parameters    : STRING Search_Column -
//                     The column in this DataWindow to set to
//                     enable.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = invalid column.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx
STRING  l_Return = "?"

FOR l_Idx = 1 TO i_NumSearch
   IF i_ColumnName[l_Idx] = search_column THEN
      l_Return = Modify(search_column + ".TabSequence=" + i_ColumnTabOrder[l_Idx])
      EXIT
   END IF
NEXT

IF l_Return = "" THEN
   RETURN 0
ELSE
   RETURN -1
END IF

end function

public function integer fu_disablecolumn (string search_column);//******************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_DisableColumn
//  Description   : Make a column on this DataWindow disabled.
//
//  Parameters    : STRING Search_Column -
//                     The column in this DataWindow to set to
//                     disable.
//
//  Return Value  : INTEGER -
//                      0 = OK.
//                     -1 = invalid column.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Return

l_Return = Modify(search_column + ".TabSequence=0")

IF l_Return = "" THEN
   RETURN 0
ELSE
   RETURN -1
END IF

end function

public function integer fu_refreshcode (string search_column);//******************************************************************
//  PO Module     : u_DW_Search
//  Function      : fu_RefreshCode
//  Description   : Re-retrieves the data into a code table.
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

BOOLEAN          l_IsNumber, l_HaveAllKeyword
INTEGER          l_Idx
LONG             l_Error
STRING           l_EditStyle, l_Table, l_Code, l_Desc, l_Where
STRING           l_Keyword, l_Attrib, l_AllKeyword, l_ErrorStrings[]
DATAWINDOWCHILD  l_DWC

//------------------------------------------------------------------
//  Determine the edit style of the column.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSearch
   IF i_ColumnName[l_Idx] = search_column THEN
      l_EditStyle = i_ColumnEditStyle[l_Idx]
      l_Table     = i_LoadTable[l_Idx]
      l_Code      = i_LoadCode[l_Idx]
      l_Desc      = i_LoadDesc[l_Idx]
      l_Where     = i_LoadWhere[l_Idx]
      l_Keyword   = i_LoadKeyword[l_Idx]
      EXIT
   END IF
NEXT

CHOOSE CASE l_EditStyle

   CASE "DDDW"

      //------------------------------------------------------------
      //  Get the child DataWindow.  If column is not a DDDW column,
      //  then return with error.  Otherwise, we need to do the 
      //  retrieve.
      //------------------------------------------------------------

      l_Error = GetChild(search_column, l_DWC)

      IF l_Error <> 1 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = GetParent().ClassName()
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_RefreshCode"
         OBJCA.MSG.fu_DisplayMessage("DDDWFindError", 5, &
			                            l_ErrorStrings[])
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  Get the ALL keyword from the child DataWindow.
      //------------------------------------------------------------

      l_HaveAllKeyWord = FALSE
      IF l_DWC.RowCount() > 0 THEN
         l_Attrib   = l_DWC.Describe("#2.ColType")
         l_IsNumber = (Upper(l_Attrib) = "NUMBER")
      
         IF l_IsNumber THEN
            l_AllKeyWord     = String(l_DWC.GetItemNumber(1, 2))
            l_HaveAllKeyWord = (l_AllKeyWord = "-99999")
         ELSE
            l_AllKeyWord     = l_DWC.GetItemString(1, 2)
            l_HaveAllKeyWord = (l_AllKeyWord = "^")
         END IF
      END IF

      //------------------------------------------------------------
      //  Retrieve the data for the child DataWindow.
      //------------------------------------------------------------

      l_Error = l_DWC.Retrieve()
      
		IF l_Error < 0 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = GetParent().ClassName()
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_RefreshCode"
         OBJCA.MSG.fu_DisplayMessage("DDDWRetrieveError", 5, &
			                            l_ErrorStrings[])
         RETURN -1
      END IF

      //------------------------------------------------------------------
      //  If an ALL keyword is given, re-insert it into the first 
      //  row on the child DataWindow.
      //------------------------------------------------------------------

      IF l_HaveAllKeyWord THEN
         IF l_DWC.InsertRow(1) > 0 THEN
            l_DWC.SetItem(1, 1, l_Keyword)

            IF l_IsNumber THEN
               l_DWC.SetItem(1, 2, -99999)
            ELSE
               l_DWC.SetItem(1, 2, "^")
            END IF
         END IF
      END IF

   CASE "DDLB"

      RETURN THIS.fu_LoadCode(search_column, l_Table, l_Code, &
                              l_Desc, l_Where, l_Keyword)

   CASE "EDITMASK"

      RETURN THIS.fu_LoadCode(search_column, l_Table, l_Code, &
                              l_Desc, l_Where, l_Keyword)

   CASE ELSE

      RETURN -1

END CHOOSE

RETURN 0


end function

public subroutine fu_reset ();//******************************************************************
//  PO Module     : u_DW_Search
//  Function      : fu_Reset
//  Description   : Clears the search criteria from this object.
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

INTEGER l_Idx

SetReDraw(FALSE)

RowsDiscard(1, 1, Primary!)
InsertRow(0)

FOR l_Idx = 1 TO i_NumSearch
   IF i_ColumnDefault[l_Idx] <> "" THEN
      THIS.fu_SetCode(i_ColumnName[l_Idx], i_ColumnDefault[l_Idx])
   END IF
NEXT

SetReDraw(TRUE)


end subroutine

public function string fu_selectcode (string search_column);//******************************************************************
//  PO Module     : u_DW_Search
//  Function      : fu_SelectCode
//  Description   : Select the code associated with the description
//                  from this object.
//
//  Parameters    : STRING Search_Column -
//                     The column to get the value from.
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

RETURN OBJCA.FIELD.fu_SelectCode(THIS, search_column)

end function

public function integer fu_wiredw (string column_name[], datawindow search_dw, string search_table[], string search_column[], transaction search_transobj);//******************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_WireDW
//  Description   : Wires columns in this DataWindow to the search
//                  DataWindow.
//
//  Parameters    : STRING Column_Name -
//                     The columns in this DataWindow that are to
//                     be wired to the database table/columns.
//                  DATAWINDOW Search_DW -
//                     The search DataWindow that is to be wired to
//                     this object.
//                  STRING Search_Table  -
//                     The tables in the database that the search
//                     object should build the WHERE clause for.
//                  STRING Search_Column -
//                     The columns in the database that the search
//                     object should build the WHERE clause for.
//                  TRANSACTION Search_TransObj - 
//                     Transaction object associated with the
//                     search DataWindow.
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

INTEGER l_Idx, l_Jdx, l_NumStyles, l_Return = -1
STRING  l_EditStyles[], l_Describe, l_Style, l_Other, l_ColType

//------------------------------------------------------------------
//  Make sure that we were passed a valid DataWindow to be wired.
//------------------------------------------------------------------

IF IsValid(search_dw) THEN

   //---------------------------------------------------------------
   //  Remember the DataWindow tables and columns for searching.
   //---------------------------------------------------------------

   i_ColumnName[]     = column_name[]
   i_SearchDW         = search_dw
   i_SearchTable[]    = search_table[]
   i_SearchDWColumn[] = search_column[]
   i_SearchOriginal   = i_SearchDW.Describe("datawindow.table.select")
   i_SearchTransObj   = search_transobj

   //---------------------------------------------------------------
   //  Determine the edit style for each column.
   //---------------------------------------------------------------

   i_NumSearch = UpperBound(search_column[])

   l_EditStyles[1] = "Edit.Required"
   l_EditStyles[2] = "DDDW.Required"
   l_EditStyles[3] = "DDLB.Required"
   l_EditStyles[4] = "EditMask.Required"
   l_EditStyles[5] = "CheckBox.3D"
   l_EditStyles[6] = "RadioButtons.3D"

   l_NumStyles     = UpperBound(l_EditStyles[])

   FOR l_Idx = 1 TO i_NumSearch
      i_LoadTable[l_Idx]       = ""
      i_LoadCode[l_Idx]        = ""
      i_LoadDesc[l_Idx]        = ""
      i_LoadWhere[l_Idx]       = ""
      i_LoadKeyword[l_Idx]     = ""
      i_ColumnEditStyle[l_Idx] = "UNKNOWN"
      i_ColumnDefault[l_Idx]   = ""
      i_ColumnTabOrder[l_Idx]  = Describe(i_ColumnName[l_Idx] + ".TabSequence")
	
   	//------------------------------------------------------------
   	//  Find the database column name using the datawindow column
		//  name.  If the datawindow column doesn't exist, assume the
		//  name is the database column name. Since we don't have a
		//  datawindow column to check, we have to assume the column
		//  type is string.
   	//------------------------------------------------------------

   	i_SearchDBColumn[l_Idx] = i_SearchDW.Describe(i_SearchDWColumn[l_Idx] + ".dbname")
		IF IsNull(i_SearchDBColumn[l_Idx]) OR i_SearchDBColumn[l_Idx] = "!" OR &
			i_SearchDBColumn[l_Idx] = "?" THEN
			i_SearchDBColumn[l_Idx] = i_SearchDWColumn[l_Idx]
		ELSE
			IF Pos(i_SearchDBColumn[l_Idx], ".") > 0 THEN
				i_SearchDBColumn[l_Idx] = Mid(i_SearchDBColumn[l_Idx], Pos(i_SearchDBColumn[l_Idx], ".") + 1)
			END IF
		END IF

      FOR l_Jdx = 1 TO l_NumStyles
         l_Describe = i_ColumnName[l_Idx] + "." + l_EditStyles[l_Jdx]
         l_Style = Describe(l_Describe)
         IF l_Style <> "?" THEN
            i_ColumnEditStyle[l_Idx] = UPPER(MID(l_EditStyles[l_Jdx], &
                                       1, POS(l_EditStyles[l_Jdx], ".") - 1))
            IF i_ColumnEditStyle[l_Idx] = "CHECKBOX" THEN
               l_Other = Describe(i_ColumnName[l_Idx] + ".CheckBox.Other")
               IF l_Other = "?" OR l_Other = "" THEN
                  l_ColType = UPPER(Describe(i_ColumnName[l_Idx] + ".ColType"))
                  IF l_ColType = "NUMBER" THEN
                     Modify(i_ColumnName[l_Idx] + ".CheckBox.Other='-99999'")
                     i_ColumnDefault[l_Idx] = "-99999"
                     SetItem(i_SearchRow, i_ColumnName[l_Idx], -99999)
                  ELSE
                     Modify(i_ColumnName[l_Idx] + ".CheckBox.Other='^'")
                     i_ColumnDefault[l_Idx] = "^"
                     SetItem(i_SearchRow, i_ColumnName[l_Idx], "^")
                  END IF
               END IF
            END IF
            EXIT
         END IF
      NEXT
   NEXT

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
   l_Return = 0

END IF

RETURN l_Return
end function

public function integer fu_loadcode (string search_column, string table_name, string column_code, string column_desc, string where_clause, string all_keyword);//******************************************************************
//  PO Module     : u_DW_Search
//  Function      : fu_LoadCode
//  Description   : Load the columns code table using codes and 
//                  descriptions from the database.
//
//  Parameters    : STRING Search_Column -
//                     The column in this DataWindow to load the
//                     code table for.
//                  STRING Table_Name    - 
//                     Table from where the column with the code
//                     values resides.
//                  STRING Column_Code   - 
//                     Column name with the code values.
//                  STRING Column_Desc   - 
//                     Column name with the code descriptions.
//                  STRING Where_Clause  - 
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER          l_Idx

//------------------------------------------------------------------
//  Save which column is loaded.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSearch
   IF i_ColumnName[l_Idx]  = search_column THEN
      i_LoadTable[l_Idx]   = table_name
      i_LoadCode[l_Idx]    = column_code
      i_LoadDesc[l_Idx]    = column_desc
      i_LoadWhere[l_Idx]   = where_clause
      i_LoadKeyword[l_Idx] = all_keyword
      EXIT
   END IF
NEXT

//------------------------------------------------------------------
//  Check to see if the FIELD manager exists.  If not, create it.
//------------------------------------------------------------------

IF NOT IsValid(OBJCA.FIELD) THEN
	OBJCA.MGR.fu_CreateManagers(OBJCA.MGR.c_FieldManager)
END IF

//------------------------------------------------------------------
//  Load the code table.
//------------------------------------------------------------------

RETURN OBJCA.FIELD.fu_LoadCode(THIS, search_column, i_SearchTransObj, &
                               table_name, column_code, column_desc, &
										 where_clause, all_keyword)

end function

public subroutine fu_unwiredw ();//******************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_UnwireDW
//  Description   : Un-wires this DataWindow from a the search
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
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

INTEGER     l_Idx

//------------------------------------------------------------------
//  Make sure we have a valid column to be unwired.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSearch
   i_SearchDWColumn[l_Idx]  = ""
   i_SearchDBColumn[l_Idx]  = ""
   i_SearchTable[l_Idx]     = ""
   i_LoadTable[l_Idx]       = ""
   i_LoadCode[l_Idx]        = ""
   i_LoadDesc[l_Idx]        = ""
   i_LoadWhere[l_Idx]       = ""
   i_LoadKeyword[l_Idx]     = ""
   i_ColumnName[l_Idx]      = ""
   i_ColumnTabOrder[l_Idx]  = ""
   i_ColumnEditStyle[l_Idx] = ""
   i_ColumnDefault[l_Idx]   = ""
NEXT

i_NumSearch = 0

//------------------------------------------------------------------
//  If the DataWindow is a Framework DataWindow, send a message to
//  it to unwire it.
//------------------------------------------------------------------

IF i_FrameWorkDW THEN
	i_SearchDW.DYNAMIC fu_Unwire(THIS)
END IF

//------------------------------------------------------------------
//  Indicate that none of the columns in this DataWindow
//  are wired to the search DataWindow.  Disable this object 
//  since it is not wired to a DataWindow.
//------------------------------------------------------------------

SetNull(i_SearchDW)
IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF

RETURN 
end subroutine

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_DW_Search
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

public function integer fu_buildsearch (boolean search_reset);//****************************************************************************************
//  PO Module     : u_DW_Search
//  Subroutine    : fu_BuildSearch
//  Description   : Extends the WHERE clause of a SQL Select with the values in this 
//                  search object.
//
//  Parameters    : BOOLEAN Search_Reset -
//                     Should the SQL Select be reset to its
//                     original state before the building begins.
//
//  Return Value  : INTEGER -
//                     0 = build OK.
//                    -1 = build failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- ------------------------------------------------------------------
//  10/30/01 C. Jackson Correct handling of single quotes
//  11/27/01 C. Jackson Comment out section that parses out a string with a comma.  Since
//                      provider names can have a comma, need to keep that as a string.
//	 12/17/2001 K. Claver Added DO-LOOP-WHILE loop to handle search strings with multiple
//								 apostrophes.  Need to change them all to double.
//  3/26/2002 K. Claver Added code to accomodate for searching on cases that are not linked
//								by allowing the user to enter the words "Not Linked" in place of a
//							   master case number.  Not generally recommended to modify a base
//								class object for an application specific need.
//****************************************************************************************

BOOLEAN  l_Found, l_Date, l_RedrawOff
INTEGER  l_GroupByPos, l_OrderByPos, l_Idx, l_ColumnCnt, l_CurrentCol
INTEGER  l_Pos
STRING   l_Text, l_ColType, l_Concat, l_NewSelect, l_EditStyle
STRING   l_GroupBy, l_OrderBy, l_Quotes, l_Other, l_SearchDWColumn
STRING   l_DateFormat, l_Operator, l_Block, l_Not, l_Lower, l_Upper
STRING   l_Value, l_CC, l_ColumnName, l_SearchTable, l_BeginText, l_EndText
STRING   l_SearchDBColumn, l_PriorOp, l_NextDay, l_SearchDate

//------------------------------------------------------------------
//  Do an AcceptText so the last column before the search will be
//  validated.
//------------------------------------------------------------------

IF AcceptText() = -1 THEN
   RETURN -1
ELSE
	
   //---------------------------------------------------------------
   //  Determine if redraw should be turned off.
   //---------------------------------------------------------------

   l_RedrawOff = FALSE
   IF GetFocus() = THIS THEN
      l_RedrawOff = TRUE
      SetRedraw(FALSE)
   END IF
	
   l_ColumnCnt = Integer(Describe("datawindow.column.count"))
   l_CurrentCol = GetColumn()
   FOR l_Idx = 1 TO l_ColumnCnt
      SetColumn(l_Idx)
      THIS.TriggerEvent(ItemChanged!)
      IF i_SearchError = c_ValFailed THEN
			IF l_RedrawOff THEN
				SetRedraw(TRUE)
			END IF
         RETURN -1
      END IF
   NEXT
   SetColumn(l_CurrentCol)
	IF l_RedrawOff THEN
		SetRedraw(TRUE)
	END IF
END IF

//------------------------------------------------------------------
//  Reset the original SQL Select.
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
//  Cycle through each wired column in this DataWindow looking for
//  search criteria to add to the SQL Select.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSearch
   l_ColumnName     = i_ColumnName[l_Idx]
   l_SearchTable    = i_SearchTable[l_Idx]
   l_SearchDWColumn = i_SearchDWColumn[l_Idx]
   l_SearchDBColumn = i_SearchDBColumn[l_Idx]
   l_EditStyle      = i_ColumnEditStyle[l_Idx]

   l_Text           = THIS.fu_SelectCode(l_ColumnName)
	
	//Accomodate for searching on cases that are not linked by use of the words "Not Linked"
	IF Trim( Upper( l_ColumnName ) ) = "MASTER_CASE_NUMBER" THEN
		IF Trim( Upper( l_Text ) ) = "NOT LINKED" THEN
			l_NewSelect += ( l_Concat+&
								  "("+ &
	                       l_SearchTable+"."+ &
                          l_SearchDBColumn+" is null)" )
			CONTINUE
		END IF
	END IF
	
	l_Pos = POS(l_Text,"'",1)
	IF  l_Pos > 0 THEN
		DO
			// Change single quotes to '' for query purposes
			l_BeginText = MID(l_text,1,l_Pos - 1)
			l_EndText = MID(l_text,l_Pos)
			l_Text = l_BeginText + "'" + l_EndText
			l_Pos = Pos( l_Text, "'", ( l_Pos + 2 ) )
		LOOP WHILE l_Pos > 0		
	END IF	

   IF l_Text = "" THEN
      CONTINUE
   END IF

   //---------------------------------------------------------------
   //  Assume that it does not contain anything that needs quoting.
   //---------------------------------------------------------------

   l_Date   = FALSE
   l_Quotes = ""
	

   //---------------------------------------------------------------
   //  See what type of data this search column contains.
   //---------------------------------------------------------------

   l_ColType = Upper(i_SearchDW.Describe(l_SearchDWColumn + ".ColType"))
   IF l_ColType = "!" THEN
		l_ColType = UPPER(Describe(l_ColumnName + ".ColType"))
	END IF

	IF Left(l_ColType, 3) = "DEC" THEN
      l_ColType = "NUMBER"
   END IF
   IF Left(l_ColType, 4) = "CHAR" THEN
      l_ColType = "STRING"
   END IF
	

   CHOOSE CASE l_ColType
      CASE "NUMBER", "LONG", "ULONG", "REAL"
      CASE "DATE", "DATETIME"

         //---------------------------------------------------------
         //  If we have a DATE type and the format is not
         //  specified in the column, then use the short format.
         //---------------------------------------------------------

         IF NOT IsValid(OBJCA.DATES) THEN
	         OBJCA.MGR.fu_CreateManagers(OBJCA.MGR.c_DateManager)
         END IF

			l_Date = TRUE
         l_DateFormat = i_SearchDW.Describe(l_SearchDWColumn + &
                                            ".Edit.Format")
         IF l_DateFormat = "" OR l_DateFormat = "?" OR l_DateFormat = "!" THEN
            l_DateFormat = i_DateFormat
         END IF

      CASE "TIME"
      CASE ELSE

         //---------------------------------------------------------
         //  We have a data type that needs to be quoted 
         //  (e.g. STRING).
         //---------------------------------------------------------

         l_Quotes = "'"

   END CHOOSE
	

   CHOOSE CASE l_EditStyle

      CASE "EDIT"
         //---------------------------------------------------------
         //  Parse the value that the user entered and pass each 
         //  unrecognized token through validation.
         //---------------------------------------------------------

         l_Other = ""

         DO WHILE l_Text <> ""

   			//------------------------------------------------------
   			//  Look for an OR or AND command.
   			//------------------------------------------------------

				IF Pos(l_Text, "|") = 1 THEN
					l_Text = Trim(Mid(l_Text, Pos(l_Text, "|") + 1))
 					l_CC = " OR "

				ELSEIF Pos(Upper(l_Text), "OR ") = 1 THEN
 					l_Text = Trim(Mid(l_Text, Pos(l_Text, "OR ") + 3))
 					l_CC = " OR "

   			ELSEIF Pos(l_Text, "&") = 1 THEN
					l_Text = Trim(Mid(l_Text, Pos(l_Text, "&") + 1))
 					l_CC = " AND "

   			ELSEIF Pos(Upper(l_Text), "AND ") = 1 THEN
					l_Text = Trim(Mid(l_Text, Pos(l_Text, "AND ") + 4))
 					l_CC = " AND "

//   			ELSEIF Pos(l_Text, ",") = 1  THEN
//					l_Text = Trim(Mid(l_Text, Pos(l_Text, ",") + 1))
// 					l_CC = " OR "

   			ELSE
					l_CC = ""

				END IF

   			//------------------------------------------------------
   			//  Look for the next "OR" command.
   			//------------------------------------------------------

   			l_Found = FALSE
				IF Pos(l_Text, "|") > 0 THEN
					IF Pos(l_Text, "~~|") = Pos(l_Text, "|") - 1 THEN
 						IF Pos(l_Text, "|", Pos(l_Text, "~~|") + 2) > 0 THEN
		     				l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, "|", Pos(l_Text, "~~|") + 2) - 1))
      					l_Text  = Trim(Mid(l_Text, Pos(l_Text, "|", Pos(l_Text, "~~|") + 2)))
							l_Found = TRUE
						END IF
					ELSE
	     				l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, "|") - 1))
      				l_Text  = Trim(Mid(l_Text, Pos(l_Text, "|")))
						l_Found = TRUE
					END IF
				END IF

 				IF NOT l_Found AND Pos(Upper(l_Text), " OR ") > 0 THEN
      			l_Block = Trim(Mid(l_Text, 1, Pos(Upper(l_Text), " OR ") - 1))
      			l_Text  = Trim(Mid(l_Text, Pos(Upper(l_Text), " OR ")))
					l_Found = TRUE
				END IF

   			//------------------------------------------------------
   			//  Look for the next "AND" command.
   			//------------------------------------------------------

				IF NOT l_Found AND Pos(l_Text, "&") > 0 THEN
					IF Pos(l_Text, "~~&") = Pos(l_Text, "&") - 1 THEN
 						IF Pos(l_Text, "&", Pos(l_Text, "~~&") + 2) > 0 THEN
		     				l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, "&", Pos(l_Text, "~~&") + 2) - 1))
      					l_Text  = Trim(Mid(l_Text, Pos(l_Text, "&", Pos(l_Text, "~~&") + 2)))
							l_Found = TRUE
						END IF
					ELSE
	     				l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, "&") - 1))
      				l_Text  = Trim(Mid(l_Text, Pos(l_Text, "&")))
						l_Found = TRUE
					END IF
				END IF

				IF NOT l_Found AND Pos(Upper(l_Text), " AND ") > 0 THEN
      			l_Block = Trim(Mid(l_Text, 1, Pos(Upper(l_Text), " AND ") - 1))
      			l_Text  = Trim(Mid(l_Text, Pos(Upper(l_Text), " AND ")))
					l_Found = TRUE
				END IF
 
   			//------------------------------------------------------
   			//  Look for the next "," command.
   			//------------------------------------------------------

//       commented out.  Need to be able to search on a string containing a "," rather than
//       parsing it out as this section does. 
//
//				IF NOT l_Found AND Pos(l_Text, ",") > 0 THEN
//					IF Pos(l_Text, "~~,") = Pos(l_Text, ",") - 1 THEN
// 						IF Pos(l_Text, ",", Pos(l_Text, "~~,") + 2) > 0 THEN
//		     				l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, ",", Pos(l_Text, "~~,") + 2) - 1))
//      					l_Text  = Trim(Mid(l_Text, Pos(l_Text, ",", Pos(l_Text, "~~,") + 2)))
//							l_Found = TRUE
//						END IF
//					ELSE
//	     				l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, ",") - 1))
//      				l_Text  = Trim(Mid(l_Text, Pos(l_Text, ",")))
//						l_Found = TRUE
//					END IF
//				END IF

      
   			//------------------------------------------------------
   			//  We're not sure what it is.  Could be a "NOT" or a 
   			//  "TO" or a...?
   			//------------------------------------------------------

				IF NOT l_Found THEN
      			l_Block = Trim(l_Text)
      			l_Text  = ""
					
   			END IF

            //------------------------------------------------------
            //  Look for any escape characters and strip it off.  
            //  Typically they would be around the keywords &, 
            //  and, |, or.
            //------------------------------------------------------

            DO
               l_Pos = Pos(l_Block, "~~")
               IF l_Pos > 0 THEN
                  l_Block = Replace(l_Block, l_Pos, 1, "")
		         END IF
            LOOP UNTIL l_Pos = 0

            //------------------------------------------------------
            //  Look for an "NOT" command and strip it off.
            //------------------------------------------------------

            l_Not = ""
            IF Pos(Lower(l_Block), "not ") = 1 THEN
               l_Not = "NOT"
               l_Block = Mid(Trim(l_Block), 5)
               IF l_Block = "" THEN EXIT
            END IF

            //------------------------------------------------------
            //  Look for an "TO" command.
            //------------------------------------------------------

            IF Pos(Lower(l_Block), " to ") > 0 THEN

               //---------------------------------------------------
               //  We found a "TO" command.  Grab the token 
               //  preceeding the "TO" and validate it.
               //---------------------------------------------------

               l_Lower = Mid(l_Block, 1, Pos(Lower(l_Block), &
                             " to ") - 1)

               //---------------------------------------------------
               //  Grab the token that comes after the "TO" and 
               //  validate it.
               //---------------------------------------------------

               l_Upper = Trim(Mid(l_Block, Pos(Lower(l_Block), &
                              " to ") + 4))

               //------------------------------------------------------------
               //  If the data is of type DATE, then we need to 
               //  convert the DATE formats to a format that will be
               //  accepted by the database that we are connected to.
               //------------------------------------------------------------

               IF l_Date THEN
         			l_Lower = OBJCA.DATES.fu_SetDateDB(l_SearchTable + "." + &
                                          l_SearchDBColumn,     &
                                          l_Lower,              &
                                          l_DateFormat,         &
                                          " >= ",               &
                                          i_SearchTransObj)
         			l_Upper = OBJCA.DATES.fu_SetDateDB(l_SearchTable + "." + &
                                          l_SearchDBColumn,     &
                                          l_Upper,              &
                                          l_DateFormat,         &
                                          " <= ",               &
                                          i_SearchTransObj)

						//------------------------------------------------
                  //  Convert the "TO" command to a recognizable SQL 
                  //  statement.
                  //------------------------------------------------

                  l_Other = l_Other + l_CC + l_Not + "(" + &
                                   l_Lower + " AND " + l_Upper + ")"
               ELSE

                  //------------------------------------------------
                  //  Convert the "TO" command to a recognizable SQL 
                  //  statement.
                  //------------------------------------------------

                  l_Other = l_Other + l_CC + &
                                      l_SearchTable + "." + &
                                      l_SearchDBColumn +  " " + &
                                      l_Not + " BETWEEN " + &
                                      l_Quotes + &
                                      l_Lower + l_Quotes + &
                                      " AND " + &
                                      l_Quotes + l_Upper + l_Quotes
               END IF
 
            ELSE

               //------------------------------------------------------
               //  Well, we don't have a "TO" command.  See if we 
               //  have some other sort of operator.
               //------------------------------------------------------

               IF Pos(l_Block, ">=") = 1 THEN
                  l_Value = Trim(Mid(l_Block, 3))
                  IF l_Not = "NOT" THEN
                     l_Operator = " < "
                  ELSE
                     l_Operator = " >= "
                  END IF
               ELSEIF Pos(l_Block, "<=") = 1 THEN
                  l_Value = Trim(Mid(l_Block, 3))
                  IF l_Not = "NOT" THEN
                     l_Operator = " > "
                  ELSE
                     l_Operator = " <= "
                  END IF
               ELSEIF Pos(l_Block, ">") = 1 THEN
                  l_Value = Trim(Mid(l_Block, 2))
                  IF l_Not = "NOT" THEN
                     l_Operator = " <= "
                  ELSE
                     l_Operator = " > "
                  END IF
               ELSEIF Pos(l_Block, "<") = 1 THEN
                  l_Value = Trim(Mid(l_Block, 2))
                  IF l_Not = "NOT" THEN
                     l_Operator = " >= "
                  ELSE
                     l_Operator = " < "
                  END IF
               ELSE
                  l_Value = l_Block
                  IF l_Not = "NOT" THEN
                     IF Pos(l_Value, "*") > 0 OR &
                        Pos(l_Value, "%") > 0 THEN
                        l_Operator = " NOT LIKE "
                     ELSE
                        l_Operator = " <> "
                     END IF
                  ELSE
                     IF Pos(l_Value, "*") > 0 OR &
                        Pos(l_Value, "%") > 0 THEN
                        l_Operator = " LIKE "
                     ELSE
                        l_Operator = " = "
                     END IF
                  END IF
               END IF

               //---------------------------------------------------
               //  If the data is of type DATE, then we need to 
               //  convert the DATE formats to a format that will 
               //  be accepted by the database that we are connected
               //  to.
               //---------------------------------------------------

               IF l_Date THEN
						l_PriorOp = l_Operator
						
						//Need to accomodate for timestamps in the database if they exist
						l_Operator = ">="	
						
						IF Pos( Trim( l_Value ),  " " ) > 0 THEN
							//Has timestamp.  Take off before figure next day
							l_SearchDate = Mid( l_Value, 1, ( Pos( l_Value, " " ) - 1 ) )
						ELSE
							l_SearchDate = l_Value
						END IF
						
						l_Value = OBJCA.DATES.fu_SetDateDB(l_SearchTable + "." + &
                                          l_SearchDBColumn,       &
                                          l_Value,              &
                                          l_DateFormat,         &
                                          l_Operator,           &
                                          i_SearchTransObj)

                  //------------------------------------------------
                  //  Convert the operator command to a recognizable
                  //  SQL statement.
                  //------------------------------------------------

                  l_Other = l_Other + l_CC + l_Value
						
						l_Operator = "<"
						
						l_NextDay = OBJCA.DATES.fu_SetDateDB(l_SearchTable + "." + &
                                          l_SearchDBColumn,       &
                                          ( String( RelativeDate( Date( l_SearchDate ), 1 ), "mm/dd/yyyy" ) ), &
                                          l_DateFormat,         &
                                          l_Operator,           &
                                          i_SearchTransObj)
														
						l_Other = l_Other + " AND " + l_CC + l_NextDay								

						l_Operator = l_PriorOp
               ELSE

                  //------------------------------------------------------
                  //  Convert the operator command to a recognizable
                  //  SQL statement.
                  //------------------------------------------------------

						l_Other = l_Other + l_CC + l_SearchTable + "." + &
                                             l_SearchDBColumn + &
                                             l_Operator + &
                                             l_Quotes + &
                                             l_Value + &
                                             l_Quotes	
															
               END IF
            END IF
         LOOP

         //---------------------------------------------------------
         //  If we found a valid where clause, concatenate it onto 
         //  the new SQL statement that we are building.
         //---------------------------------------------------------

         IF Len(l_Other) > 0 THEN
            l_NewSelect = l_NewSelect + l_Concat + "(" + l_Other + ")"
         END IF

      CASE ELSE

         //---------------------------------------------------------
         //  Add the validated value.
         //---------------------------------------------------------

         l_Other = l_Quotes + l_Text + l_Quotes

         //---------------------------------------------------------
         //  Add the snippet of SQL generated by the this object to
         //  our new SQL statement.
         //---------------------------------------------------------

         IF Len(l_Other) > 0 THEN
            l_NewSelect = l_NewSelect + l_Concat + "(" + &
                                        l_SearchTable + "." + &
                                        l_SearchDBColumn + &
                                        " IN (" + l_Other + "))"
         END IF

   END CHOOSE

   l_Concat = " AND "

NEXT

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

event itemchanged;//******************************************************************
//  PO Module     : u_DW_Search
//  Event         : ItemChanged
//  Description   : This event is used to trigger validation
//                  checking when a field has changed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Return, l_NumStyles, l_Idx
STRING   l_EditStyles[], l_Describe, l_Required, l_ErrorStrings[]

//------------------------------------------------------------------
//  If the ignore validation flag is set, return.
//------------------------------------------------------------------

IF i_IgnoreVal THEN
   GoTo Finished
END IF

//------------------------------------------------------------------
//  If validation is to be done, find the current row and column
//  that needs to be validated.
//------------------------------------------------------------------

i_SearchRow    = GetRow()
i_SearchColumn = GetColumnName()
i_SearchValue  = GetText()

IF i_SearchRow = 0 OR i_SearchColumn = "" THEN
   GoTo Finished
END IF

//------------------------------------------------------------------
//  Set the validation information that can be used by the developer
//  to code the po_Validate event.
//------------------------------------------------------------------

i_SearchValMsg = Describe(i_SearchColumn + ".ValidationMsg")
   IF i_SearchValMsg = "?" THEN
      i_SearchValMsg = ""
   END IF

//------------------------------------------------------------------
//  We can not find out what edit style the column is from
//  PowerBuilder.  Therefore, we have to cycle through all the
//  possible types seeing if we get a valid response.  Set up
//  an array containing all known styles.
//------------------------------------------------------------------

l_EditStyles[1] = ".Edit"
l_EditStyles[2] = ".DDDW"
l_EditStyles[3] = ".DDLB"
l_EditStyles[4] = ".EditMask"
l_NumStyles     = UpperBound(l_EditStyles[])

//------------------------------------------------------------------
//  For each edit style that we know about, see if this column
//  will respond to a DESCRIBE().
//------------------------------------------------------------------

i_SearchRequiredError = FALSE
FOR l_Idx = 1 TO l_NumStyles
   l_Describe = i_SearchColumn + l_EditStyles[l_Idx] + ".Required"
   l_Required = Upper(Describe(l_Describe))
   IF l_Required <> "?" THEN
      i_SearchRequired  = (l_Required  = "YES")
      IF i_SearchValue = "" AND i_SearchRequired THEN
         i_SearchRequiredError = TRUE
         EXIT
      END IF
   END IF
NEXT

//------------------------------------------------------------------
//  If l_Required is "?", then this must be a CheckBox or
//  RadioButton column.
//------------------------------------------------------------------

IF l_Required = "?" THEN
   i_SearchRequired  = FALSE
END IF

//------------------------------------------------------------------
//  Initialize i_SearchError to indicate that validation processing
//  has not been done.  Initialize i_DisplayRequired to indicate
//  that required field errors should be reported.  If the
//  developer does not want PowerClass to do required field
//  reporting, they can set this flag to FALSE.
//------------------------------------------------------------------

i_SearchError     = c_ValNotProcessed
i_DisplayRequired = TRUE

//------------------------------------------------------------------
//  po_Validate performs validation on column by column basis.
//  This event must be coded by the developer.
//
//  Validation routines are expected to do their own error
//  display.
//------------------------------------------------------------------

Event po_Validate(i_SearchValue, &
                  i_SearchColumn, &
                  i_SearchRow, &
						i_SearchValMsg, &
						i_SearchRequiredError)

//------------------------------------------------------------------
//  We need to display the required field error if:
//     a) If we have a required field error AND
//     b) The developer's routine did not catch or process
//        it AND
//     c) The developer said it was Ok to display it.
//------------------------------------------------------------------

IF i_SearchRequiredError THEN
   IF i_SearchError = c_ValNotProcessed OR &
	   i_SearchError = c_ValOK THEN
      IF i_DisplayRequired THEN

         //---------------------------------------------------------
         //  Display the required field message.
         //---------------------------------------------------------

	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = GetParent().ClassName()
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "ItemChanged"
         OBJCA.MSG.fu_DisplayMessage("RequiredField", 5, &
			                            l_ErrorStrings[])
 
         //---------------------------------------------------------
         //  Since this is a required field, we have an error.
         //---------------------------------------------------------

         i_SearchError = c_ValFailed
      END IF
   END IF
END IF

//------------------------------------------------------------------
//  Indictate that the DataWindow has been through validation.
//  Since ItemError! may be called immediately, i_ItemValidated
//  tells us not to re-try the validation process (which
//  would display another validation error message box).
//------------------------------------------------------------------

i_ItemValidated = TRUE

Finished:

//------------------------------------------------------------------
//  If we were not triggered by ItemError and the developer did
//  not process the error, then indicate success.
//------------------------------------------------------------------

IF i_InItemError = 0 THEN
   IF i_SearchError = c_ValNotProcessed THEN
      i_SearchError = c_ValOk
   END IF
END IF

//------------------------------------------------------------------
//  The validation return code is interpreted as follows:
//     c_ValOk (0):
//        The the data was accepted.
//     c_ValFailed (1):
//        The data should be rejected and focus should be returned
//        to the field in error.
//     c_ValFixed (2):
//        The text was reformatted and placed back into the field
//        using SetItem().  The text now passes validation.
//     c_ValNotProcessed (-9):
//        The field was not validated by the developer's
//        po_Validate event.  Let PowerBuilder handle the
//        validation.
//------------------------------------------------------------------

l_Return = i_SearchError
IF l_Return = c_ValNotProcessed THEN
   l_Return = c_ValOk
END IF

//------------------------------------------------------------------
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN l_Return
end event

event constructor;//******************************************************************
//  PO Module     : u_DW_Search
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

//------------------------------------------------------------------
//  Grab the default date format.
//------------------------------------------------------------------

i_DateFormat = OBJCA.MGR.fu_GetDefault("Global", "DateFormat")

//------------------------------------------------------------------
//  Insert an empty row.
//------------------------------------------------------------------

InsertRow(0)
SetNull(i_SearchDW)
end event

event itemerror;//******************************************************************
//  PO Module     : u_DW_Search
//  Event         : ItemError
//  Description   : This event is used to disable the display
//                  of the generic PowerBuilder validation error
//                  message.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Return
STRING   l_ErrorStrings[]

i_InItemError = 1

//------------------------------------------------------------------
//  Don't display the error message from Powerbuilder, but
//  allow focus to change.
//------------------------------------------------------------------

IF i_IgnoreVal THEN
   l_Return = 3
   GOTO Finished
END IF

//------------------------------------------------------------------
//  Trigger the ItemChanged! event to initiate the validation
//  process only if it has not already run (i_ItemValidated tells
//  if it has already been run).  ItemChanged! can be triggered
//  before this event by AcceptText().
//------------------------------------------------------------------

IF NOT i_ItemValidated THEN

   //---------------------------------------------------------------
   //  See if we are worried about required field checking every
   //  time the user moves.  If not, then see if ItemError was
   //  triggered because of a required field error.  If so, then
   //  we don't need to do any more processing for ItemError.
   //---------------------------------------------------------------

   THIS.TriggerEvent(ItemChanged!)

   //---------------------------------------------------------------
   //  Unless the developer specified that validation error
   //  messages were not to be displayed, set the action code
   //  appropriately.
   //---------------------------------------------------------------

   CHOOSE CASE i_SearchError
      CASE c_ValOk

         //---------------------------------------------------------
         //  The developer told us that the value is good.
         //  Tell PowerBuilder to accept it and move.
         //---------------------------------------------------------

         l_Return = 2

      CASE c_ValFixed

         //---------------------------------------------------------
         //  The value was bad, but it was fixed using
         //  SetItem().  Therefore, we don't want to accept
         //  the user's text over the correction.  Just
         //  reject the user's value and move.
         //---------------------------------------------------------

         l_Return = 3

      CASE c_ValFailed

         //---------------------------------------------------------
         //  The value failed validation and the developer was
         //  unable to fix it.  Reject the value and stay put.
         //---------------------------------------------------------

         l_Return = 1

      CASE c_ValNotProcessed

         //---------------------------------------------------------
         //  The developer did not do any processing in the
         //  po_Validate event.  See if ItemError! was
         //  triggered because of a required field error.  If
         //  it was, we don't want PowerBuilder to display an
         //  error message.
         //---------------------------------------------------------

         IF i_SearchRequiredError THEN
            i_SearchError   = c_ValOk
            l_Return = 3
         ELSE

            //------------------------------------------------------
            //  PowerBuilder thinks something is wrong and we
            //  now know that it is not a required field error.
            //  If there is a validation error message in the
            //  DataWindow call Display_DW_Val_Error() to
            //  display it.
            //------------------------------------------------------

            IF Len(Trim(i_SearchValMsg)) > 0 THEN
	            l_ErrorStrings[1] = "PowerObjects Error"
	            l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	            l_ErrorStrings[3] = GetParent().ClassName()
	            l_ErrorStrings[4] = ClassName()
	            l_ErrorStrings[5] = "ItemError"
               l_ErrorStrings[6] = i_SearchValMsg
               OBJCA.MSG.fu_DisplayMessage("ValDevOKError", &
                                           6, l_ErrorStrings[])
               i_SearchError   = c_ValFailed
               l_Return = 1
            ELSE

               //---------------------------------------------------
               //  Nothing else to do but let PowerBuilder
               //  display the message.
               //---------------------------------------------------

               i_SearchError   = c_ValFailed
               l_Return = 0
            END IF
         END IF
      CASE ELSE

         //---------------------------------------------------------
         //  If we get to here, then the developer gave us back
         //  a bad validation return.
         //---------------------------------------------------------

         i_SearchError   = c_ValFailed
         l_Return = 0
   END CHOOSE

ELSE

   //---------------------------------------------------------------
   //  The developer said that validation errors were not to
   //  be displayed, but there is an error with the data.
   //  Reject the value and don't move.
   //---------------------------------------------------------------

   l_Return = 1
END IF

//------------------------------------------------------------------
//  Clear the validation state flag indicating that it is Ok to
//  do validation checking.
//------------------------------------------------------------------

i_ItemValidated = FALSE

Finished:

i_InItemError = 0

//------------------------------------------------------------------
//  If the developer extends this event then they should check
//  AncestorReturnValue first to see if they should process their
//  code.  Unless the developer changes the RETURN value in their
//  code, PowerBuilder will use the AncestorReturnValue.
//------------------------------------------------------------------

RETURN l_Return
end event

event itemfocuschanged;//******************************************************************
//  PO Module     : u_DW_Search
//  Event         : ItemFocusChanged
//  Description   : This event is used to indicate when a focus
//                  changes between items in a DataWindow.
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
//  If validation processing is off, we do not want to do
//  anything.
//------------------------------------------------------------------

IF i_IgnoreVal THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Clear the validation state flag indicating the validation
//  needs to be run.
//------------------------------------------------------------------

i_ItemValidated = FALSE

end event

event editchanged;//******************************************************************
//  PO Module     : u_DW_Search
//  Event         : EditChanged
//  Description   : This event is used to indicate when a change
//                  has been made to a field in the DataWindow and
//                  validation needs to be performed.
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
//  If the ignore validation flag is set, return.
//------------------------------------------------------------------

IF i_IgnoreVal THEN
   RETURN
END IF

//------------------------------------------------------------------
//  This flag indicates that the DataWindow has been modified.
//------------------------------------------------------------------

i_SearchModified = TRUE

end event

event destructor;//******************************************************************
//  PO Module     : u_DW_Search
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
//  PO Module     : u_DW_Search
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

on u_dw_search.create
end on

on u_dw_search.destroy
end on

