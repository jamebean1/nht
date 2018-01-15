$PBExportHeader$u_sle_filter.sru
$PBExportComments$Single line edit filter class
forward
global type u_sle_filter from singlelineedit
end type
end forward

global type u_sle_filter from singlelineedit
int Width=800
int Height=96
int TabOrder=1
BorderStyle BorderStyle=StyleLowered!
long BackColor=16777215
int TextSize=-9
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event po_valempty ( )
event po_validate ( ref string filtervalue )
event po_identify pbm_custom73
end type
global u_sle_filter u_sle_filter

type variables
//----------------------------------------------------------------------------------------
//  Filter Object Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName	= "Filter"
CONSTANT INTEGER	c_ValOK		= 0
CONSTANT INTEGER	c_ValFailed	= 1

//----------------------------------------------------------------------------------------
// Filter Object Instance Variables
//----------------------------------------------------------------------------------------

DATAWINDOW		i_FilterDW
BOOLEAN		i_FrameWorkDW

TRANSACTION		i_FilterTransObj
STRING			i_FilterTable
STRING			i_FilterColumn
STRING			i_FilterValue
STRING			i_FilterOriginal

INTEGER		i_FilterError

STRING			i_DateFormat

end variables

forward prototypes
public function integer fu_setcode (string default_code)
public function integer fu_wiredw (datawindow filter_dw, string filter_column, transaction filter_transobj)
public function integer fu_buildfilter (boolean filter_reset)
public subroutine fu_unwiredw ()
public function string fu_getidentity ()
end prototypes

event po_valempty;////******************************************************************
////  PO Module     : u_SLE_Filter
////  Event         : po_ValEmpty
////  Description   : Provides the opportunity for the developer to
////                  generate errors when the user has not made a
////                  selection in the this object.
////
////  Return Value  : i_FilterError -
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
////  Return c_ValFailed to indicate that this filter object is required.
////-------------------------------------------------------------------
//
////OBJCA.MSG.fu_DisplayMessage("RequiredField")
////i_FilterError = c_ValFailed
end event

event po_validate;////******************************************************************
////  PO Module     : u_SLE_Filter
////  Event         : po_Validate
////  Description   : Provides the opportunity for the developer to
////                  write code to validate the fields in this
////                  object.
////
////  Parameters    : REF STRING FilterValue - 
////                         The input the user has made.
////
////  Return Value  : i_FilterError -
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
////i_FilterError = OBJCA.FIELD.fu_ValidateMaxLen(FilterValue, 10, TRUE)
end event

event po_identify;//******************************************************************
//  PO Module     : u_SLE_Filter
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
//  PO Module     : u_SLE_Filter
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

public function integer fu_wiredw (datawindow filter_dw, string filter_column, transaction filter_transobj);//******************************************************************
//  PO Module     : u_SLE_Filter
//  Subroutine    : fu_WireDW
//  Description   : Wires a column in a DataWindow to this object.
//
//  Parameters    : DATAWINDOW Filter_DW -
//                     The DataWindow that is to be wired to
//                     this object.
//                  STRING Filter_Column -
//                     The column in the DataWindow that
//                     this object should filter through.
//                  TRANSACTION Filter_TransObj - 
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

IF IsValid(filter_dw) THEN

   //---------------------------------------------------------------
   //  Remember the DataWindow tabe and column for filtering.
   //---------------------------------------------------------------

   i_FilterDW       = filter_dw
   i_FilterColumn   = filter_column
   i_FilterTransObj = filter_transobj
   i_FilterOriginal = i_FilterDW.Describe("datawindow.table.filter")
   IF i_FilterOriginal = "?" THEN
      i_FilterOriginal = ""
   END IF
   
   //---------------------------------------------------------------
   //  Determine if the DataWindow is a Framework DataWindow.
   //---------------------------------------------------------------

	IF i_FilterDW.TriggerEvent("po_Identify") = 1 THEN
		i_FrameWorkDW = TRUE
		i_FilterDW.DYNAMIC fu_Wire(THIS)
	END IF
	
	IF NOT IsValid(SECCA.MGR) THEN
		Enabled       = TRUE
	END IF
   l_Return         = 0

END IF

RETURN l_Return
end function

public function integer fu_buildfilter (boolean filter_reset);//******************************************************************
//  PO Module     : u_SLE_Filter
//  Subroutine    : fu_BuildFilter
//  Description   : Extends the filter clause of a DataWindow
//                  with the values in this filter object.
//
//  Parameters    : BOOLEAN Filter_Reset -
//                     Should the DataWindow filter be reset to its
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

BOOLEAN  l_Date, l_Found
INTEGER  l_OrderByPos, l_Pos
STRING   l_Operator, l_Text, l_ColumnType, l_Concat, l_NewFilter
STRING   l_Quotes, l_Other, l_Block, l_Not
STRING   l_Lower, l_Upper, l_Value, l_CC

//------------------------------------------------------------------
//  See if the DataWindow filter criteria needs to be reset to its
//  original syntax.
//------------------------------------------------------------------

IF filter_reset THEN
	
   //---------------------------------------------------------------
   //  If this is a PowerClass datawindow, grab the original filter
   //  clause from it.
   //---------------------------------------------------------------
   
	IF i_FilterDW.TriggerEvent("po_identify") = 1 THEN
		IF i_FilterDW.DYNAMIC fu_GetIdentity() = "DataWindow" THEN
			i_FilterOriginal = i_FilterDW.DYNAMIC fu_GetFilter()
		END IF
	END IF
	
   i_FilterDW.Modify('datawindow.table.filter="' + &
                     i_FilterOriginal + '"')
END IF

l_NewFilter = i_FilterDW.Describe("datawindow.table.filter")
IF l_NewFilter = "?" THEN
   l_NewFilter = ""
END IF

l_Text      = TRIM(Text)

//------------------------------------------------------------------
//  If this object has been un-wired, don't include in build.
//------------------------------------------------------------------

IF IsNull(i_FilterDW) <> FALSE THEN
   RETURN -1
END IF

l_Concat = ""
IF l_NewFilter <> "" THEN
   l_Concat = " AND "
END IF

//------------------------------------------------------------------
//  Check to see if the developer made this a required field for
//  filter criteria.
//------------------------------------------------------------------

IF l_Text = "" THEN
	i_FilterError = c_ValOK
   i_FilterValue = l_Text

   //---------------------------------------------------------------
   //  If we get a validation error, abort the filter.
   //---------------------------------------------------------------
	
	Event po_ValEmpty()

   IF i_FilterError = c_ValFailed THEN
      SetFocus()
      RETURN -1
   ELSE
      RETURN 0
   END IF
END IF

//------------------------------------------------------------------
//  If the user has typed something into the object, we need to 
//  validate it and add it to our new filter statement
//------------------------------------------------------------------

l_Date   = FALSE
l_Quotes = ""

//------------------------------------------------------------------
//  See what type of data this filter object contains.
//------------------------------------------------------------------

l_ColumnType = Upper(i_FilterDW.Describe(i_FilterColumn + ".ColType"))
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
      l_Date = TRUE
 
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

      i_FilterError = c_ValOK
      i_FilterValue = l_Lower

      //------------------------------------------------------------
      //  If we get a validation error, abort the filter.
      //------------------------------------------------------------
		
		Event po_Validate(i_FilterValue)

      IF i_FilterError = c_ValFailed THEN
         SetFocus()
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  If we got to here, validation must have been successful. 
      //  Validation may have modified the token.  Grab it back.
      //------------------------------------------------------------

      l_Lower = i_FilterValue

      //------------------------------------------------------------
      //  Grab the token that comes after the "TO" and validate it.
      //------------------------------------------------------------

      l_Upper = Trim(Mid(l_Block, Pos(Lower(l_Block), " to ") + 4))

      //------------------------------------------------------------
      //  Stuff the current token in and perform valdiation.
      //------------------------------------------------------------

      i_FilterError = c_ValOK
      i_FilterValue = l_Upper

      //------------------------------------------------------------
      //  If we get a validation error, abort the filter.
      //------------------------------------------------------------
		
		Event po_Validate(i_FilterValue)

      IF i_FilterError = c_ValFailed THEN
         SetFocus()
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  If we got to here, validation must have been successful. 
      //  Validation may have modified the token.  Grab it back.
      //------------------------------------------------------------

      l_Upper = i_FilterValue

      //------------------------------------------------------------
      //  If the data is of type DATE, then we need to convert the 
      //  DATE formats to a format that will be accepted by the 
      //  DataWindow.
      //------------------------------------------------------------

      IF l_Date THEN
         l_Lower = i_FilterColumn + " >= DATE('" + &
                   String(Date(l_Lower), i_DateFormat) + "')"

         l_Upper = i_FilterColumn + " <= DATE('" + &
                   String(Date(l_Upper), i_DateFormat) + "')"

         //---------------------------------------------------------
         //  Convert the "TO" command to a recognizable filter
         //  statement.
         //---------------------------------------------------------

         l_Other = l_Other + l_CC + l_Not + "(" + &
                             l_Lower + " AND " + l_Upper + ")"
      ELSE

         //---------------------------------------------------------
         //  Convert the "TO" command to a recognizable filter
         //  statement.
         //---------------------------------------------------------

         l_Other = l_Other + l_CC + l_Not + "(" + &
                             i_FilterColumn + " >= " + &
                             l_Quotes + l_Lower + l_Quotes + &
                             " AND " + i_FilterColumn + " <= " + &
                             l_Quotes + l_Upper + l_Quotes + ")"
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
            l_Operator = " <> "
         ELSE
            l_Operator = " = "
         END IF
      END IF

      //------------------------------------------------------------
      //  Stuff the current token in and perform valdiation.
      //------------------------------------------------------------

      i_FilterError = c_ValOK
      i_FilterValue = l_Value

      //------------------------------------------------------------
      //  If we get a validation error, abort the filter.
      //------------------------------------------------------------
		
		Event po_Validate(i_FilterValue)

      IF i_FilterError = c_ValFailed THEN
         SetFocus()
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  If we got to here, validation must have been successful. 
      //  Validation may have modified the token.  Grab it back.
      //------------------------------------------------------------

      l_Value = i_FilterValue

      //------------------------------------------------------------
      //  If the data is of type DATE, then we need to convert the 
      //  DATE formats to a format that will be accepted by the 
      //  DataWindow.
      //------------------------------------------------------------

      IF l_Date THEN
         l_Value = i_FilterColumn + l_Operator + "DATE('" + &
                   String(Date(l_Value), i_DateFormat) + "')"

         //---------------------------------------------------------
         //  Convert the operator command to a recognizable filter 
         //  statement.
         //---------------------------------------------------------

         l_Other = l_Other + l_CC + l_Value

      ELSE

         //---------------------------------------------------------
         //  Convert the operator command to a recognizable filter
         //  statement.
         //---------------------------------------------------------

         IF Left(l_Value, 1) = "*" AND Right(l_Value, 1) = "*" THEN
            IF l_Not <> "" THEN
               l_Operator = " = "
            ELSE
               l_Operator = " > "
            END IF
            l_Value = "POS(" + i_FilterColumn + ", '" + &
                      l_Value + "')" + l_Operator + "0"
         ELSEIF Left(l_Value, 1) = "*" THEN
            IF l_Not <> "" THEN
               l_Operator = " <> "
            ELSE
               l_Operator = " = "
            END IF
            l_Value = "RIGHT(" + i_FilterColumn + ", " + &
                      String(LEN(l_Value) - 1) + ")" + l_Operator + "'" + &
                      Right(l_Value, LEN(l_Value) - 1) + "'"
         ELSEIF Right(l_Value, 1) = "*" THEN
            IF l_Not <> "" THEN
               l_Operator = " <> "
            ELSE
               l_Operator = " = "
            END IF
            l_Value = "LEFT(" + i_FilterColumn + ", " + &
                      String(LEN(l_Value) - 1) + ")" + l_Operator + "'" + &
                      Left(l_Value, LEN(l_Value) - 1) + "'"
         ELSE
            l_Value = i_FilterColumn + l_Operator + l_Quotes + &
                      l_Value + l_Quotes
         END IF

         l_Other = l_Other + l_CC + l_Value

      END IF
   END IF
LOOP

//------------------------------------------------------------------
//  If we found a valid where clause, concatenate it onto the new 
//  filter statement that we are building.
//------------------------------------------------------------------

IF Len(l_Other) > 0 THEN
   l_NewFilter = l_NewFilter + l_Concat + "(" + l_Other + ")"
END IF

//------------------------------------------------------------------
//  Stuff the parameter with the completed filter statement.
//------------------------------------------------------------------

l_NewFilter = 'datawindow.table.filter="' + l_NewFilter + '"'
i_FilterDW.Modify(l_NewFilter)

RETURN 0
end function

public subroutine fu_unwiredw ();//******************************************************************
//  PO Module     : u_SLE_Filter
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
	i_FilterDW.DYNAMIC fu_Unwire(THIS)
END IF

SetNull(i_FilterDW)
IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF


end subroutine

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_SLE_Filter
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

event constructor;//******************************************************************
//  PO Module     : u_SLE_Filter
//  Event         : Constructor
//  Description   : Initializes the Filter object.
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
SetNull(i_FilterDW)
end event

event destructor;//******************************************************************
//  PO Module     : u_SLE_Filter
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

IF IsNull(i_FilterDW) = FALSE THEN
	THIS.fu_UnwireDW()
END IF
end event

event getfocus;//******************************************************************
//  PO Module     : u_SLE_Filter
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

IF IsValid(i_FilterDW) THEN
	IF i_FrameWorkDW THEN
		i_FilterDW.DYNAMIC fu_Activate()
	END IF
END IF
end event

