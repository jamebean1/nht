$PBExportHeader$u_sle_search.sru
$PBExportComments$Single line edit search class
forward
global type u_sle_search from singlelineedit
end type
end forward

global type u_sle_search from singlelineedit
integer width = 800
integer height = 96
integer taborder = 1
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
event po_valempty ( )
event po_validate ( ref string searchvalue )
event po_identify pbm_custom73
end type
global u_sle_search u_sle_search

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

STRING			i_DateFormat

end variables

forward prototypes
public function integer fu_setcode (string default_code)
public function integer fu_wiredw (datawindow search_dw, string search_table, string search_column, transaction search_transobj)
public subroutine fu_unwiredw ()
public function string fu_getidentity ()
public function integer fu_buildsearch (boolean search_reset)
end prototypes

event po_valempty;////******************************************************************
////  PO Module     : u_SLE_Search
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
////  PO Module     : u_SLE_Search
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
//  PO Module     : u_SLE_Search
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

public function integer fu_setcode (string default_code);//******************************************************************
//  PO Module     : u_SLE_Search
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

public function integer fu_wiredw (datawindow search_dw, string search_table, string search_column, transaction search_transobj);//******************************************************************
//  PO Module     : u_SLE_Search
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
//  PO Module     : u_SLE_Search
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
//  PO Module     : u_SLE_Search
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
//  PO Module     : u_SLE_Search
//  Subroutine    : fu_BuildSearch
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
//  12/17/2001 K. Claver Added code to change all single apostrophes
//								 in the search value to double apostrophes
//								 for SQL Server.
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_Date, l_Found
INTEGER  l_GroupByPos, l_OrderByPos, l_Pos
STRING   l_Operator, l_Text, l_ColumnType, l_Concat, l_NewSelect
STRING   l_GroupBy, l_OrderBy, l_Quotes, l_Other, l_Block, l_Not
STRING   l_Lower, l_Upper, l_Value, l_CC, l_DateFormat, l_BeginText
STRING   l_EndText

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
l_Text      = TRIM(Text)

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
//  If the user has typed something into the object, we need to 
//  validate it and add it to our new select statement
//------------------------------------------------------------------

l_Date   = FALSE
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

      //------------------------------------------------------------
      //  If we have a DATE type and the format is not
      //  specified in the column, then use the short format.
      //------------------------------------------------------------

   CASE "DATE", "DATETIME"
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
      //  We have a data type that needs to be quoted 
      //  (e.g. STRING).
      //------------------------------------------------------------

   CASE ELSE
      l_Quotes = "'"
END CHOOSE

//------------------------------------------------------------------
//  Parse the value that the user entered and pass each unrecognized
//  token through validation.
//------------------------------------------------------------------

l_Other = ""

DO WHILE l_Text <> ""

   //---------------------------------------------------------------
   //  Look for an OR or AND command.
   //---------------------------------------------------------------

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

   ELSEIF Pos(l_Text, ",") = 1  THEN
		l_Text = Trim(Mid(l_Text, Pos(l_Text, ",") + 1))
 		l_CC = " OR "

   ELSE
		l_CC = ""

	END IF

   //---------------------------------------------------------------
   //  Look for the next "OR" command.
   //---------------------------------------------------------------

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

   //---------------------------------------------------------------
   //  Look for the next "AND" command.
   //---------------------------------------------------------------

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
 
   //---------------------------------------------------------------
   //  Look for the next "," command.
   //---------------------------------------------------------------

	IF NOT l_Found AND Pos(l_Text, ",") > 0 THEN
		IF Pos(l_Text, "~~,") = Pos(l_Text, ",") - 1 THEN
 			IF Pos(l_Text, ",", Pos(l_Text, "~~,") + 2) > 0 THEN
		     	l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, ",", Pos(l_Text, "~~,") + 2) - 1))
      		l_Text  = Trim(Mid(l_Text, Pos(l_Text, ",", Pos(l_Text, "~~,") + 2)))
				l_Found = TRUE
			END IF
		ELSE
	     	l_Block = Trim(Mid(l_Text, 1, Pos(l_Text, ",") - 1))
      	l_Text  = Trim(Mid(l_Text, Pos(l_Text, ",")))
			l_Found = TRUE
		END IF
	END IF
      
   //---------------------------------------------------------------
   //  We're not sure what it is.  Could be a "NOT" or a "TO" 
   //  or a...?
   //---------------------------------------------------------------

	IF NOT l_Found THEN
      l_Block = Trim(l_Text)
      l_Text  = ""
   END IF

   //---------------------------------------------------------------
   //  Look for any escape characters and strip it off.  Typically
   //  they would be around the keywords &, and, |, or.
   //---------------------------------------------------------------

   DO
      l_Pos = Pos(l_Block, "~~")
      IF l_Pos > 0 THEN
         l_Block = Replace(l_Block, l_Pos, 1, "")
		END IF
   LOOP UNTIL l_Pos = 0

   //---------------------------------------------------------------
   //  Look for an "NOT" command and strip it off.
   //---------------------------------------------------------------

   l_Not = ""
   IF Pos(Lower(l_Block), "not ") = 1 THEN
      l_Not = "NOT"
      l_Block = Mid(Trim(l_Block), 5)
      IF l_Block = "" THEN EXIT
   END IF

   //---------------------------------------------------------------
   //  Look for an "TO" command.
   //---------------------------------------------------------------

   IF Pos(Lower(l_Block), " to ") > 0 THEN

      //------------------------------------------------------------
      //  We found a "TO" command.  Grab the token preceeding the 
      //  "TO" and validate it.
      //------------------------------------------------------------

      l_Lower = Mid(l_Block, 1, Pos(Lower(l_Block), " to ") - 1)

      //------------------------------------------------------------
      //  Stuff the current token in and perform valdiation.
      //------------------------------------------------------------
      
		i_SearchError = c_ValOK
      i_SearchValue = l_Lower

      //------------------------------------------------------------
      //  If we get a validation error, abort the search.
      //------------------------------------------------------------
		
		Event po_Validate(i_SearchValue)

      IF i_SearchError = c_ValFailed THEN
         SetFocus()
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  If we got to here, validation must have been successful. 
      //  Validation may have modified the token.  Grab it back.
      //------------------------------------------------------------

      l_Lower = i_SearchValue

      //------------------------------------------------------------
      //  Grab the token that comes after the "TO" and validate it.
      //------------------------------------------------------------

      l_Upper = Trim(Mid(l_Block, Pos(Lower(l_Block), " to ") + 4))

      //------------------------------------------------------------
      //  Stuff the current token in and perform valdiation.
      //------------------------------------------------------------
      
		i_SearchError = c_ValOK
      i_SearchValue = l_Upper

      //------------------------------------------------------------
      //  If we get a validation error, abort the search.
      //------------------------------------------------------------
		
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

      //------------------------------------------------------------
      //  If we got to here, validation must have been successful. 
      //  Validation may have modified the token.  Grab it back.
      //------------------------------------------------------------

      l_Upper = i_SearchValue

      //------------------------------------------------------------
      //  If the data is of type DATE, then we need to convert the 
      //  DATE formats to a format that will be accepted by the 
      //  database that we are connected to.
      //------------------------------------------------------------

      IF l_Date THEN
         l_Lower = OBJCA.DATES.fu_SetDateDB(i_SearchTable + "." + &
                                          i_SearchDBColumn,     &
                                          l_Lower,              &
                                          l_DateFormat,         &
                                          " >= ",               &
                                          i_SearchTransObj)
         l_Upper = OBJCA.DATES.fu_SetDateDB(i_SearchTable + "." + &
                                          i_SearchDBColumn,     &
                                          l_Upper,              &
                                          l_DateFormat,         &
                                          " <= ",               &
                                          i_SearchTransObj)

         //---------------------------------------------------------
         //  Convert the "TO" command to a recognizable SQL 
         //  statement.
         //---------------------------------------------------------

         l_Other = l_Other + l_CC + l_Not + "(" + &
                             l_Lower + " AND " + l_Upper + ")"
      ELSE

         //---------------------------------------------------------
         //  Convert the "TO" command to a recognizable SQL 
         //  statement.
         //---------------------------------------------------------

         l_Other = l_Other + l_CC + i_SearchTable + "." + &
                             i_SearchDBColumn +  " " + l_Not + &
                             " BETWEEN " + l_Quotes + &
                             l_Lower + l_Quotes + " AND " + &
                             l_Quotes + l_Upper + l_Quotes
      END IF
 
   ELSE

      //------------------------------------------------------------
      //  Well, we don't have a "TO" command.  See if we have some 
      //  other sort of operator.
      //------------------------------------------------------------

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

      //------------------------------------------------------------
      //  Stuff the current token in and perform valdiation.
      //------------------------------------------------------------
      
		i_SearchError = c_ValOK
      i_SearchValue = l_Value

      //------------------------------------------------------------
      //  If we get a validation error, abort the search.
      //------------------------------------------------------------
		
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

      //------------------------------------------------------------
      //  If we got to here, validation must have been successful. 
      //  Validation may have modified the token.  Grab it back.
      //------------------------------------------------------------

      l_Value = i_SearchValue

      //------------------------------------------------------------
      //  If the data is of type DATE, then we need to convert the 
      //  DATE formats to a format that will be accepted by the 
      //  database that we are connected to.
      //------------------------------------------------------------

      IF l_Date THEN
         l_Value = OBJCA.DATES.fu_SetDateDB(i_SearchTable + "." + &
                                          i_SearchDBColumn,     &
                                          l_Value,              &
                                          l_DateFormat,         &
                                          l_Operator,           &
                                          i_SearchTransObj)

         //---------------------------------------------------------
         //  Convert the operator command to a recognizable SQL 
         //  statement.
         //---------------------------------------------------------

         l_Other = l_Other + l_CC + l_Value

      ELSE

         //---------------------------------------------------------
         //  Convert the operator command to a recognizable SQL 
         //  statement.
         //---------------------------------------------------------

         l_Other = l_Other + l_CC + i_SearchTable + "." + &
                             i_SearchDBColumn + &
                             l_Operator + l_Quotes + &
                             l_Value    + l_Quotes
      END IF
   END IF
LOOP

//------------------------------------------------------------------
//  If we found a valid where clause, concatenate it onto the new 
//  SQL statement that we are building.
//------------------------------------------------------------------

IF Len(l_Other) > 0 THEN
   l_NewSelect = l_NewSelect + l_Concat + "(" + l_Other + ")"
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
//  PO Module     : u_SLE_Search
//  Event         : Constructor
//  Description   : Initializes the Search object.
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
//  Grab the default date format.
//------------------------------------------------------------------

i_DateFormat = OBJCA.MGR.fu_GetDefault("Global", "DateFormat")

IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF
SetNull(i_SearchDW)
end event

event destructor;//******************************************************************
//  PO Module     : u_SLE_Search
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
//  PO Module     : u_SLE_Search
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

on u_sle_search.create
end on

on u_sle_search.destroy
end on

