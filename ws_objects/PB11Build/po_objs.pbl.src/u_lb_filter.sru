$PBExportHeader$u_lb_filter.sru
$PBExportComments$List box filter class
forward
global type u_lb_filter from listbox
end type
end forward

global type u_lb_filter from listbox
int X=5
int Y=4
int Width=800
int Height=400
int TabOrder=1
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean MultiSelect=true
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
global u_lb_filter u_lb_filter

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

STRING			i_LoadTable
STRING			i_LoadCode
STRING			i_LoadDesc
STRING			i_LoadWhere
STRING			i_LoadKeyword

end variables

forward prototypes
public function integer fu_selectcode (ref string codes[])
public function integer fu_setcode (string default_code[])
public function integer fu_loadcode (string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public function integer fu_refreshcode ()
public function integer fu_wiredw (datawindow filter_dw, string filter_column, transaction filter_transobj)
public function integer fu_buildfilter (boolean filter_reset)
public subroutine fu_unwiredw ()
public function string fu_getidentity ()
end prototypes

event po_valempty;////******************************************************************
////  PO Module     : u_LB_Filter
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
////  PO Module     : u_LB_Filter
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
//  PO Module     : u_LB_Filter
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

public function integer fu_selectcode (ref string codes[]);//******************************************************************
//  PO Module     : u_LB_Filter
//  Function      : fu_SelectCode
//  Description   : Select the code associated with the description
//                  from this object.
//
//  Parameters    : STRING Codes[] -
//                     Returns the selected code(s).
//
//  Return Value  : INTEGER -
//                     Returns the number of selected.
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

RETURN OBJCA.FIELD.fu_SelectCode(THIS, codes[])

end function

public function integer fu_setcode (string default_code[]);//******************************************************************
//  PO Module     : u_LB_Filter
//  Subroutine    : fu_SetCode
//  Description   : Sets default value(s) for this object.
//
//  Parameters    : STRING Default_Code[] -
//                     The value(s) to set for this object.
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

RETURN OBJCA.FIELD.fu_SetCode(THIS, default_code[])

end function

public function integer fu_loadcode (string table_name, string column_code, string column_desc, string where_clause, string all_keyword);//******************************************************************
//  PO Module     : u_LB_Filter
//  Function      : fu_LoadCode
//  Description   : Load a code table using codes and descriptions
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

RETURN OBJCA.FIELD.fu_LoadCode(THIS, i_FilterTransObj, table_name, &
                        column_code, column_desc, where_clause, &
								all_keyword)

end function

public function integer fu_refreshcode ();//******************************************************************
//  PO Module     : u_LB_Filter
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

public function integer fu_wiredw (datawindow filter_dw, string filter_column, transaction filter_transobj);//******************************************************************
//  PO Module     : u_LB_Filter
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
//  PO Module     : u_LB_Filter
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

INTEGER  l_TextCnt, l_Idx, l_Jdx
STRING   l_ColumnType, l_Concat, l_NewFilter, l_OR
STRING   l_Quotes, l_Other, l_TextList[]

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

l_TextCnt   = THIS.fu_SelectCode(l_TextList[])
IF l_TextCnt = 0 THEN
   l_TextCnt = 1
   l_TextList[1] = ""
END IF

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

FOR l_Idx = 1 TO l_TextCnt
   i_FilterValue = TRIM(l_TextList[l_Idx])
   IF i_FilterValue = "" THEN
		
		i_FilterError = c_ValOK

      //------------------------------------------------------------
      //  If we get a validation error, abort the filter.
      //------------------------------------------------------------
		
		Event po_ValEmpty()

      IF i_FilterError = c_ValFailed THEN
         SetFocus()
         RETURN -1
		ELSE
			RETURN  0
      END IF
   END IF

   IF i_FilterValue <> "" THEN
      l_Jdx = l_Jdx + 1
      l_TextList[l_Jdx] = l_TextList[l_Idx]
   END IF

NEXT

l_TextCnt = l_Jdx

IF l_TextCnt = 1 THEN
   IF l_TextList[1] = "" THEN
      RETURN 0
   END IF
END IF

//------------------------------------------------------------------
//  Assume that it does not contain anything that needs quoting.
//------------------------------------------------------------------

l_Quotes = ""
l_OR     = ""
l_Other  = ""

//------------------------------------------------------------------
//  See what type of data this filter object contains.
//------------------------------------------------------------------

l_ColumnType = Upper(i_FilterDW.Describe(i_FilterColumn + ".ColType"))
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

FOR l_Idx = 1 TO l_TextCnt
	i_FilterError = c_ValOK
   i_FilterValue = l_TextList[l_Idx]

   //---------------------------------------------------------------
   //  If we get a validation error, abort the filter.
   //---------------------------------------------------------------
	
	Event po_Validate(i_FilterValue)

   IF i_FilterError = c_ValFailed THEN
      SetFocus()
      RETURN -1
   END IF

   //---------------------------------------------------------------
   //  Add the validated value.
   //---------------------------------------------------------------

   l_TextList[l_Idx] = i_FilterValue
   l_Other = l_Other + l_OR + i_FilterColumn + " = " + &
                       l_Quotes + l_TextList[l_Idx] + l_Quotes
   l_OR = " OR "
NEXT

//------------------------------------------------------------------
//  Add the snippet generated by the this object to our new 
//  filter statement.
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
//  PO Module     : u_LB_Filter
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
//  PO Module     : u_LB_Filter
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
//  PO Module     : u_LB_Filter
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

IF NOT IsValid(SECCA.MGR) THEN
	Enabled = FALSE
END IF
SetNull(i_FilterDW)
end event

event destructor;//******************************************************************
//  PO Module     : u_LB_Filter
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
//  PO Module     : u_LB_Filter
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

