$PBExportHeader$u_dw_find.sru
$PBExportComments$Find class
forward
global type u_dw_find from datawindow
end type
end forward

global type u_dw_find from datawindow
int Width=594
int Height=96
int TabOrder=1
string DataObject="d_find"
BorderStyle BorderStyle=StyleLowered!
event po_validate pbm_custom75
event po_identify pbm_custom74
end type
global u_dw_find u_dw_find

type variables
//----------------------------------------------------------------------------------------
// Find Object Constants
//----------------------------------------------------------------------------------------

CONSTANT STRING	c_ObjectName	= "Find"
CONSTANT INTEGER	c_ValOK		= 0
CONSTANT INTEGER	c_ValFailed	= 1
CONSTANT INTEGER	c_ValFixed	= 2

//----------------------------------------------------------------------------------------
//  Find Object Instance Variables
//----------------------------------------------------------------------------------------

DATAWINDOW		i_FindDW
BOOLEAN		i_FrameWorkDW
STRING			i_FindColumn

INTEGER		i_FindError

STRING			i_ColType
STRING			i_GetText
BOOLEAN		i_GotOrder
BOOLEAN		i_Ascending

end variables

forward prototypes
public function integer fu_wiredw (datawindow find_dw, string find_column)
public subroutine fu_unwiredw ()
public function string fu_getidentity ()
end prototypes

event po_validate;//******************************************************************
//  PO Module     : u_DW_Find
//  Event         : po_Validate
//  Description   : Provides validation for the find object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Sep
STRING   l_Date, l_Time

CHOOSE CASE i_ColType
   CASE "CHAR"

   CASE "DECIMAL", "NUMBER", "LONG", "ULONG", "REAL"
      IF Len(i_GetText) = 0 THEN
         i_GetText = "0"
      ELSE
         IF NOT IsNumber(i_GetText) THEN
            i_FindError = c_ValFailed
         END IF
      END IF

   CASE "DATE"
      IF NOT IsDate(i_GetText) THEN
         i_FindError = c_ValFailed
      END IF

   CASE "DATETIME"
      l_Sep = Pos(i_GetText, " ")
      IF l_Sep = 0 THEN
         l_Sep = Pos(i_GetText, ",")
      END IF
      IF l_Sep = 0 THEN
         l_Sep = Pos(i_GetText, ";")
      END IF

      IF l_Sep = 0 THEN
         IF NOT IsDate(i_GetText) THEN
            i_FindError = c_ValFailed
         END IF
      ELSE
         l_Date = Mid(i_GetText, 1, l_Sep - 1)
         l_Time = Mid(i_GetText, l_Sep + 1)
         IF NOT IsDate(l_Date) THEN
            i_FindError = c_ValFailed
         ELSE
            IF NOT IsTime(l_Time) THEN
               i_FindError = c_ValFailed
            ELSE
               i_GetText = l_Date + ";" + l_Time
            END IF
         END IF
      END IF

   CASE "TIME", "TIMESTAMP"
      IF NOT IsTime(i_GetText) THEN
         i_FindError = c_ValFailed
      END IF

   CASE ELSE
END CHOOSE
end event

public function integer fu_wiredw (datawindow find_dw, string find_column);//******************************************************************
//  PO Module     : u_DW_Find
//  Subroutine    : fu_WireDW
//  Description   : Wires a column in a DataWindow to this object.
//
//  Parameters    : DATAWINDOW Find_DW -
//                        The DataWindow that is to be wired to
//                        this find object.
//                  STRING Find_Column -
//                        The column in the DataWindow that
//                        the find object should search through.
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

IF IsValid(find_dw) THEN

   //---------------------------------------------------------------
   //  Remember the DataWindow column for searching.
   //---------------------------------------------------------------

   i_FindDW     = find_dw
   i_FindColumn = find_column
   i_GotOrder   = FALSE

   //---------------------------------------------------------------
   //  Insert a empty row into the find object so that the user
   //  has a row to type in.  Also, set the focus indicator off.
   //---------------------------------------------------------------

   IF RowCount() = 0 THEN
      InsertRow(0)
      SetRowFocusIndicator(Off!)
   END IF

   //---------------------------------------------------------------
   //  Determine if the DataWindow is a Framework DataWindow.
   //---------------------------------------------------------------

	IF i_FindDW.TriggerEvent("po_Identify") = 1 THEN
		i_FrameWorkDW = TRUE
		i_FindDW.DYNAMIC fu_Wire(THIS)
	END IF

	IF NOT IsValid(SECCA.MGR) THEN
		Enabled       = TRUE
	END IF
   l_Return = 0
END IF

RETURN l_Return
end function

public subroutine fu_unwiredw ();//******************************************************************
//  PO Module     : u_DW_Find
//  Subroutine    : fu_UnwireDW
//  Description   : Un-wires a DataWindow from the find object.
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
	i_FindDW.DYNAMIC fu_Unwire(THIS)
END IF

SetNull(i_FindDW)
IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF

end subroutine

public function string fu_getidentity ();//******************************************************************
//  PO Module     : u_DW_Find
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

event editchanged;//******************************************************************
//  PO Module     : u_DW_Find
//  Event         : EditChanged
//  Description   : Find the first value in the associated
//                  DataWindow that matches the text entered into
//                  this field.  The entered text doesn't have to
//                  be an exact match.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER   l_Sep
REAL      l_Num1,      l_Num2
LONG      l_RowCount,  l_RowNbr, l_Pos,  l_Start, l_End
DATE      l_Date1,     l_Date2
DATETIME  l_DateTime1, l_DateTime2
TIME      l_Time1,     l_Time2
STRING    l_Str1,      l_Str2
STRING    l_Date,      l_Time,   l_FindStr

//------------------------------------------------------------------
//  Determine the data type of the column to search on.  If it is
//  a number or a string column, use FIND() to select the first
//  row that has a value grater than or equal to the search text.
//------------------------------------------------------------------

IF IsNull(i_FindColumn) <> FALSE THEN
   RETURN
END IF

IF NOT IsValid(i_FindDW) THEN
   RETURN
END IF

l_RowCount = i_FindDW.RowCount()
IF l_RowCount < 1 THEN
   RETURN
END IF

IF NOT i_GotOrder THEN

   i_ColType = Upper(i_FindDW.Describe(i_FindColumn + ".ColType"))

   l_Pos     = Pos(i_ColType, "(")
   IF l_Pos > 0 THEN
      i_ColType = Mid(i_ColType, 1, l_Pos - 1)
   END IF

   //---------------------------------------------------------------
   //  Assume ascending until proven otherwise.
   //---------------------------------------------------------------

   i_Ascending = TRUE

   IF l_RowCount > 1 THEN

      CHOOSE CASE i_ColType
         CASE "CHAR"
            l_Str1 = Upper(i_FindDW.GetItemString(1, i_FindColumn))
            l_Str2 = Upper(i_FindDW.GetItemString(l_RowCount, i_FindColumn))

            IF IsNull(l_Str1) <> FALSE THEN
            ELSE
               IF IsNull(l_Str2) <> FALSE THEN
               ELSE
                  IF l_Str2 <> l_Str1 THEN
                     i_GotOrder  = TRUE
                     i_Ascending = (l_Str2 > l_Str1)
                  END IF
               END IF
            END IF

         CASE "DECIMAL"
            l_Num1 = i_FindDW.GetItemDecimal(1, i_FindColumn)
            l_Num2 = i_FindDW.GetItemDecimal(l_RowCount, i_FindColumn)

            IF IsNull(l_Num1) <> FALSE THEN
            ELSE
               IF IsNull(l_Num2) <> FALSE THEN
               ELSE
                  IF l_Num1 <> l_Num2 THEN
                     i_GotOrder  = TRUE
                     i_Ascending = (l_Num2 > l_Num1)
                  END IF
               END IF
            END IF

         CASE "NUMBER", "LONG", "ULONG", "REAL"
            l_Num1 = i_FindDW.GetItemNumber(1, i_FindColumn)
            l_Num2 = i_FindDW.GetItemNumber(l_RowCount, i_FindColumn)

            IF IsNull(l_Num1) <> FALSE THEN
            ELSE
               IF IsNull(l_Num2) <> FALSE THEN
               ELSE
                  IF l_Num1 <> l_Num2 THEN
                     i_GotOrder  = TRUE
                     i_Ascending = (l_Num2 > l_Num1)
                  END IF
               END IF
            END IF

         CASE "DATE"
            l_Date1 = i_FindDW.GetItemDate(1, i_FindColumn)
            l_Date2 = i_FindDW.GetItemDate(l_RowCount, i_FindColumn)

            IF IsNull(l_Date1) <> FALSE THEN
            ELSE
               IF IsNull(l_Date2) <> FALSE THEN
               ELSE
                  IF l_Date1 <> l_Date2 THEN
                     i_GotOrder  = TRUE
                     i_Ascending = (l_Date2 > l_Date1)
                  END IF
               END IF
            END IF

         CASE "DATETIME"
            l_DateTime1 = i_FindDW.GetItemDateTime(1, i_FindColumn)
            l_DateTime2 = i_FindDW.GetItemDateTime(l_RowCount, i_FindColumn)

            IF IsNull(l_DateTime1) <> FALSE THEN
            ELSE
               IF IsNull(l_DateTime2) <> FALSE THEN
               ELSE
                  IF l_DateTime1 <> l_DateTime2 THEN
                     i_GotOrder  = TRUE
                     i_Ascending = (l_DateTime2 > l_DateTime1)
                  END IF
               END IF
            END IF

         CASE "TIME", "TIMESTAMP"
            l_Time1 = i_FindDW.GetItemTime(1, i_FindColumn)
            l_Time2 = i_FindDW.GetItemTime(l_RowCount, i_FindColumn)

            IF IsNull(l_Time1) <> FALSE THEN
            ELSE
               IF IsNull(l_Time2) <> FALSE THEN
               ELSE
                  IF l_Time1 <> l_Time2 THEN
                     i_GotOrder  = TRUE
                     i_Ascending = (l_Time2 > l_Time1)
                  END IF
               END IF
            END IF

         CASE ELSE
      END CHOOSE
   END IF
END IF

IF i_Ascending THEN
   l_Start = 1
   l_End   = l_RowCount
ELSE
   l_Start = l_RowCount
   l_End   = 1
END IF

l_RowNbr    = 0
i_GetText   = GetText()
i_FindError = c_ValOK
THIS.TriggerEvent("po_Validate")

IF i_FindError = c_ValOK THEN
   CHOOSE CASE i_ColType
      CASE "CHAR"
         i_GetText = OBJCA.MGR.fu_QuoteString(i_GetText, "'")
         l_FindStr = "Upper("  + i_FindColumn +  ") >= " + &
                     "Upper('" + i_GetText    + "')"
         l_RowNbr  = i_FindDW.Find(l_FindStr, l_Start,  l_End)

      CASE "DECIMAL", "NUMBER", "LONG", "ULONG", "REAL"
         l_FindStr = i_FindColumn + " >= " + i_GetText
         l_RowNbr  = i_FindDW.Find(l_FindStr, l_Start, l_End)

      CASE "DATE"
         l_FindStr = i_FindColumn + " >= Date(~"" + &
                     i_GetText    + "~")"
         l_RowNbr  = i_FindDW.Find(l_FindStr, l_Start, l_End)

      CASE "DATETIME"
         l_Sep = Pos(i_GetText, ";")
         IF l_Sep = 0 THEN
            l_FindStr = i_FindColumn + " >= Date(~"" + &
                        i_GetText    + "~")"
         ELSE
            l_Date    = Mid(i_GetText, 1, l_Sep - 1)
            l_Time    = Mid(i_GetText, l_Sep + 1)
            l_FindStr = i_FindColumn + " >= DateTime(Date(~"" + &
                        l_Date + "~", Time(~"" + l_Time + "~"))"
         END IF
         l_RowNbr = i_FindDW.Find(l_FindStr, l_Start, l_End)

      CASE "TIME", "TIMESTAMP"
         l_FindStr = i_FindColumn + " >= Time(~"" + &
                     i_GetText    + "~")"
         l_RowNbr  = i_FindDW.Find(l_FindStr, l_Start, l_End)
      CASE ELSE
   END CHOOSE
END IF

//------------------------------------------------------------------
//  If a value is found, set the row in the DataWindow.
//------------------------------------------------------------------

IF i_FindError = c_ValOK THEN
   IF l_RowNbr > 0 THEN
      i_FindDW.ScrollToRow(l_RowNbr)
   ELSE
      IF Len(i_GetText) > 0 THEN
         i_FindDW.ScrollToRow(l_End)
      END IF
   END IF
END IF

i_FindError = c_ValOK

end event

event constructor;//******************************************************************
//  PO Module     : u_DW_Find
//  Event         : Constructor
//  Description   : Initializes the find object.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF
SetNull(i_FindDW)
end event

event destructor;//******************************************************************
//  PO Module     : u_DW_Find
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

IF IsNull(i_FindDW) = FALSE THEN
	THIS.fu_UnwireDW()
END IF
end event

event getfocus;//******************************************************************
//  PO Module     : u_DW_Find
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

IF IsValid(i_FindDW) THEN
	IF i_FrameWorkDW THEN
		i_FindDW.DYNAMIC fu_Activate()
	END IF
END IF
end event

