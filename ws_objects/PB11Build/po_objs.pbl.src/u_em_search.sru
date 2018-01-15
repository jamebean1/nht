﻿$PBExportHeader$u_em_search.sru
$PBExportComments$Spin box search class
forward
global type u_em_search from editmask
end type
end forward

global type u_em_search from editmask
integer width = 800
integer height = 96
integer taborder = 10
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "XXXXXXXXXXXXXXXXXXXX"
string displaydata = "1~t1/2~t2/3~t3/"
double increment = 1
string minmax = "~~"
event po_valempty ( )
event po_validate ( ref string searchvalue )
event po_identify pbm_custom73
end type
global u_em_search u_em_search

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

STRING			i_DateFormat

end variables

forward prototypes
public function string fu_selectcode ()
public function integer fu_setcode (string default_code)
public function integer fu_loadcode (string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public function integer fu_refreshcode ()
public function integer fu_wiredw (datawindow search_dw, string search_table, string search_column, transaction search_transobj)
public subroutine fu_unwiredw ()
public function string fu_getidentity ()
public function integer fu_buildsearch (boolean search_reset)
end prototypes

event po_valempty;////******************************************************************
////  PO Module     : u_EM_Search
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
////  PO Module     : u_EM_Search
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
////i_SearchError = OBJCA.FIELD.fu_ValidateMaxLen(SearchValue, 10, TRUE)
end event

event po_identify;//******************************************************************
//  PO Module     : u_EM_Search
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
//  PO Module     : u_EM_Search
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
//  Get the selected value.
//------------------------------------------------------------------

RETURN OBJCA.FIELD.fu_SelectCode(THIS)

end function

public function integer fu_setcode (string default_code);//******************************************************************
//  PO Module     : u_EM_Search
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

RETURN OBJCA.FIELD.fu_SetCode(THIS, default_code)

end function

public function integer fu_loadcode (string table_name, string column_code, string column_desc, string where_clause, string all_keyword);//******************************************************************
//  PO Module     : u_EM_Search
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

RETURN OBJCA.FIELD.fu_LoadCode(THIS, i_SearchTransObj, table_name, &
                        column_code, column_desc, where_clause, &
								all_keyword)

end function

public function integer fu_refreshcode ();//******************************************************************
//  PO Module     : u_EM_Search
//  Function      : fu_RefreshCode
//  Description   : Refresh code table using codes and 
//                  descriptions from the database.
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
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

RETURN fu_LoadCode(i_LoadTable, i_LoadCode, i_LoadDesc, &
                   i_LoadWhere, i_LoadKeyword)


end function

public function integer fu_wiredw (datawindow search_dw, string search_table, string search_column, transaction search_transobj);//******************************************************************
//  PO Module     : u_EM_Search
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
//  PO Module     : u_EM_Search
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
//  PO Module     : u_EM_Search
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

public function integer fu_buildsearch (boolean search_reset);//******************************************************************
//  PO Module     : u_EM_Search
//  Subroutine    : fu_BuildSearch
//  Description   : Extends the WHERE clause of a SQL Select 
//                  with the values in this object.
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
//  10/8/98	Beth Byers	Call fu_SetDateDB to get the appropriate date 
//								format to add to the SQL if the edit mask data 
//								type is DATE or DATETIME.
//  12/17/2001 K. Claver Added code to change all single apostrophes
// 							 to double apostrophes for SQL Server.
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN	l_Date
INTEGER  l_GroupByPos, l_OrderByPos, l_Pos
STRING   l_Text, l_ColumnType, l_Concat, l_NewSelect, l_BeginText
STRING   l_EndText
STRING   l_GroupBy, l_OrderBy, l_Quotes, l_Other, l_DateFormat

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
l_Date   = FALSE

//------------------------------------------------------------------
//  See what type of data this search object contains.
//------------------------------------------------------------------

l_ColumnType = Upper(i_SearchDW.Describe(i_SearchColumn + ".ColType"))
IF l_ColumnType = "!" THEN
	CHOOSE CASE MaskDataType
		CASE DateMask!
			l_ColumnType = "DATE"
		CASE DateTimeMask!
			l_ColumnType = "DATETIME"
		CASE TimeMask!
			l_ColumnType = "TIME"
		CASE DecimalMask!
			l_ColumnType = "NUMBER"
		CASE NumericMask!
			l_ColumnType = "NUMBER"
	END CHOOSE
END IF

IF Left(l_ColumnType, 3) = "DEC" THEN
   l_ColumnType = "NUMBER"
END IF

CHOOSE CASE l_ColumnType
   CASE "NUMBER", "LONG", "ULONG", "REAL"
		
      //------------------------------------------------------------
      //  If we have a DATE or DATETIME type and the format is not
      //  specified in the column, then use the short format.
      //------------------------------------------------------------
		
   CASE "DATE","DATETIME"
      IF NOT IsValid(OBJCA.DATES) THEN
	      OBJCA.MGR.fu_CreateManagers(OBJCA.MGR.c_DateManager)
      END IF

		l_Date = TRUE
      l_DateFormat = i_SearchDW.Describe(i_SearchColumn + ".Edit.Format")
      IF l_DateFormat = "" OR l_DateFormat = "?" OR l_dateFormat = "!" THEN
         l_DateFormat = i_DateFormat
      END IF
 
		
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

//---------------------------------------------------------------
//  Change all apostrophes to double apostrophes for SQL server
//---------------------------------------------------------------
l_Pos = POS( i_SearchValue, "'", 1 )
IF  l_Pos > 0 THEN
	DO
		// Change single quotes to '' for query purposes
		l_BeginText = MID( i_SearchValue, 1, l_Pos - 1 )
		l_EndText = MID( i_SearchValue, l_Pos )
		i_SearchValue = l_BeginText+"'"+l_EndText
		l_Pos = Pos( i_SearchValue, "'", ( l_Pos + 2 ) )
	LOOP WHILE l_Pos > 0		
END IF

//------------------------------------------------------------------
//  If we got to here, validation must have been successful. 
//  Validation may have modified the token.  Grab it back.
//------------------------------------------------------------------

l_Text = i_SearchValue

//------------------------------------------------------------------
//  Add the validated value.
//------------------------------------------------------------------

IF l_date THEN
	//------------------------------------------------------------
   //  If the data is of type DATE, then we need to convert the 
   //  DATE formats to a format that will be accepted by the 
   //  database that we are connected to.
   //------------------------------------------------------------

	l_Other = OBJCA.DATES.fu_SetDateDB(i_SearchTable + "." + &
                                          i_SearchDBColumn,     &
                                          l_Text,              &
                                          l_DateFormat,         &
                                          " >= ",               &
                                          i_SearchTransObj)
ELSE

	l_Other = l_Quotes + l_Text + l_Quotes
END IF

//------------------------------------------------------------------
//  Add the snippet of SQL generated by this object to our new 
//  SQL statement.
//------------------------------------------------------------------

IF Len(l_Other) > 0 THEN
	
	IF l_date THEN
  		l_NewSelect = l_NewSelect + l_Concat +  l_Other 
	ELSE
   	l_NewSelect = l_NewSelect + l_Concat + "(" + i_SearchTable + &
                               "." + i_SearchDBColumn + &
                               " IN (" + l_Other + "))"
	END IF
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

event constructor;//******************************************************************
//  PO Module     : u_EM_Search
//  Event         : Constructor
//  Description   : Initializes the Search object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/8/98	Beth Byers	Get the default date format
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Grab the default date format.
//------------------------------------------------------------------

i_DateFormat = OBJCA.MGR.fu_GetDefault("Global", "DateFormat")

IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF
SetNull(i_SearchDW)


end event

event destructor;//******************************************************************
//  PO Module     : u_EM_Search
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
//  PO Module     : u_EM_Search
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

on u_em_search.create
end on

on u_em_search.destroy
end on

