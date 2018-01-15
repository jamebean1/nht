$PBExportHeader$n_objca_field.sru
$PBExportComments$Field utilities data store
forward
global type n_objca_field from n_objca_mgr
end type
end forward

global type n_objca_field from n_objca_mgr
string dataobject = ""
end type
global n_objca_field n_objca_field

forward prototypes
public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string column_pict, string where_clause, string all_keyword)
public function integer fu_loadcode (datawindow dw_name, string dw_column, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public function string fu_selectcode (powerobject control_name)
public function integer fu_setcode (powerobject control_name, string default_code)
public function integer fu_setcode (powerobject control_name, string default_code[])
public function integer fu_setcode (datawindow dw_name, string dw_column, string default_code)
public function integer fu_validatedate (ref string value, string format, boolean display_error)
public function integer fu_validatedec (ref string value, string format, boolean display_error)
public function integer fu_validatedom (ref string value, string format, boolean display_error)
public function integer fu_validatedow (ref string value, string format, boolean display_error)
public function integer fu_validatemon (ref string value, string format, boolean display_error)
public function integer fu_validatetime (ref string value, string format, boolean display_error)
public function integer fu_validateyear (ref string value, string format, boolean display_error)
public function integer fu_validateint (ref string value, string format, boolean display_error)
public function integer fu_validatemaxlen (string value, long length, boolean display_error)
public function integer fu_validateminlen (string value, long length, boolean display_error)
public function integer fu_validatege (string value, real compare, boolean display_error)
public function integer fu_validategt (string value, real compare, boolean display_error)
public function integer fu_validatele (string value, real compare, boolean display_error)
public function integer fu_validatelt (string value, real compare, boolean display_error)
public function integer fu_validatelength (string value, long length, boolean display_error)
public function integer fu_selectcode (powerobject control_name, ref string codes[])
public function integer fu_validatefmt (ref string value, string pattern, boolean display_error)
public function integer fu_validatephone (ref string value, boolean display_error)
public function integer fu_validatezip (ref string value, boolean display_error)
public function string fu_selectcode (datawindow dw_name, string dw_column)
end prototypes

public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_LoadCode
//  Description   : Load a non-DataWindow, non-picture object using
//                  codes and descriptions from the database.
//
//  Parameters    : POWEROBJECT Control_Name  - 
//                     Name of the control to load its code table.
//                  TRANSACTION Trans_Object - 
//                     Transaction object.
//                  STRING      Table_Name   - 
//                     Table from where the column with the code
//                     values resides.
//                  STRING      Column_Code  - 
//                     Column name with the code values.
//                  STRING      Column_Desc  - 
//                     Column name with the code descriptions.
//                  STRING      Where_Clause - 
//                     WHERE cause statement to restrict the code 
//                     values.
//                  STRING      All_Keyword  - 
//                     Keyword to denote select all values 
//                     (e.g. "(All)").
//
//  Return Value  : INTEGER -
//                      0 = Load successful.
//                     -1 = Load failed.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN         l_IsNumber
LONG            l_Nbr
STRING          l_SQLString, l_Code, l_Desc, l_Type, l_CodeDesc
STRING          l_ErrorStrings[], l_Tab, l_Separator
DROPDOWNLISTBOX l_DDLBName
LISTBOX         l_LBName
EDITMASK        l_EMName

//------------------------------------------------------------------
//  Determine the type of object.
//------------------------------------------------------------------

CHOOSE CASE TypeOf(control_name)
	CASE DropDownListBox!
		l_DDLBName = control_name
		l_Type     = "DDLB"
		l_DDLBName.Reset()
	CASE EditMask!
		l_EMName   = control_name
		l_Type     = "EM"
	CASE ListBox!
		l_LBName   = control_name
		l_Type     = "LB"
		l_LBName.Reset()
END CHOOSE

//------------------------------------------------------------------
//  Declare a dynamic SQL cursor to hold the data while loading the
//  drop down list box.
//------------------------------------------------------------------

trans_object.SQLCode = 0
DECLARE Control_Cursor DYNAMIC CURSOR FOR SQLSA ;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorDeclareError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Build the SQL SELECT statement to get the data.
//------------------------------------------------------------------

l_SQLString = "SELECT " + column_code + ", " + &
              column_desc + " FROM " + table_name
IF Trim(where_clause) <> "" THEN
   l_SQLString = l_SQLString + " WHERE " + where_clause
END IF

//------------------------------------------------------------------
//  Prepare the SQL statement for execution.
//------------------------------------------------------------------

PREPARE SQLSA FROM :l_SQLString USING trans_object;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorPrepareError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Open the dynamic cursor.
//------------------------------------------------------------------

OPEN DYNAMIC Control_Cursor ;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorOpenError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  If a keyword has been given to selct all, add it as a selection
//  to the drop down list box.
//------------------------------------------------------------------

IF l_Type = "EM" THEN
	l_CodeDesc = ""
	l_Tab      = "~t"
	l_Separator= "/"
END IF

IF All_Keyword <> "" THEN
   l_Code = "(ALL)"
   l_Desc = all_keyword
   IF l_Type = "EM" THEN
		l_CodeDesc = l_Desc + l_tab + l_Code + l_Separator
	ELSE
      l_Desc = String(l_Desc, Fill("@", 80)) + "||" + l_Code
	   IF l_Type = "DDLB" THEN
			l_DDLBName.AddItem(l_Desc)
		ELSE
			l_LBName.AddItem(l_Desc)
		END IF
	END IF
END IF

//------------------------------------------------------------------
//  Determine if the code column is a number or a string.
//------------------------------------------------------------------

FETCH Control_Cursor INTO :l_Code, :l_Desc ;

IF trans_object.SQLCode = 0 OR trans_object.SQLCode = 100 THEN
   l_IsNumber = FALSE
ELSE
   l_IsNumber = TRUE
END IF

CLOSE Control_Cursor ;
OPEN DYNAMIC Control_Cursor ;

//------------------------------------------------------------------
//  For each row in the cursor, add the description and code to the
//  drop down list box.
//------------------------------------------------------------------

IF l_IsNumber THEN
   DO WHILE trans_object.SQLCode = 0
      FETCH Control_Cursor INTO :l_Nbr, :l_Desc ;
      IF trans_object.SQLCode = 0 THEN
         IF IsNull(l_Desc) <> FALSE THEN
  		      l_Nbr = -99999
  	      END IF

         IF l_Type = "DDLB" THEN
            IF column_code <> column_desc THEN
               l_Desc = String(l_Desc, Fill("@", 80)) + &
                        "||" + String(l_Nbr)
				END IF
				l_DDLBName.AddItem(l_Desc)
			ELSEIF l_Type = "LB" THEN
            IF column_code <> column_desc THEN
               l_Desc = String(l_Desc, Fill("@", 80)) + &
                        "||" + String(l_Nbr)
				END IF
				l_LBName.AddItem(l_Desc)
			ELSE
				l_CodeDesc = l_CodeDesc + l_Desc + l_Tab + &
				             String(l_Nbr) + l_Separator
			END IF
      ELSE
         IF trans_object.SQLCode <> 100 THEN
	         l_ErrorStrings[1] = "PowerObjects Error"
	         l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	         l_ErrorStrings[3] = ""
	         l_ErrorStrings[4] = ClassName()
	         l_ErrorStrings[5] = "fu_LoadCode"
            l_ErrorStrings[6] = trans_object.SQLErrText
            OBJCA.MSG.fu_DisplayMessage("CursorFetchError", &
                                        6, l_ErrorStrings[])
            RETURN -1
         END IF
      END IF
   LOOP
ELSE
   DO WHILE trans_object.SQLCode = 0
      FETCH Control_Cursor INTO :l_Code, :l_Desc ;
      IF trans_object.SQLCode = 0 THEN
         IF IsNull(l_Desc) <> FALSE THEN
  		      l_Code = "NULL"
  	      END IF
         IF l_Type = "DDLB" THEN
            IF column_code <> column_desc THEN
               l_Desc = String(l_Desc, Fill("@", 80)) + &
                        "||" + l_Code
				END IF
				l_DDLBName.AddItem(l_Desc)
			ELSEIF l_Type = "LB" THEN
            IF column_code <> column_desc THEN
               l_Desc = String(l_Desc, Fill("@", 80)) + &
                        "||" + l_Code
				END IF
				l_LBName.AddItem(l_Desc)
			ELSE
				l_CodeDesc = l_CodeDesc + l_Desc + l_Tab + &
				             l_Code + l_Separator
			END IF
      ELSE
         IF trans_object.SQLCode <> 100 THEN
	         l_ErrorStrings[1] = "PowerObjects Error"
	         l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	         l_ErrorStrings[3] = ""
	         l_ErrorStrings[4] = ClassName()
	         l_ErrorStrings[5] = "fu_LoadCode"
            l_ErrorStrings[6] = trans_object.SQLErrText
            OBJCA.MSG.fu_DisplayMessage("CursorFetchError", &
                                        6, l_ErrorStrings[])
            RETURN -1
         END IF
      END IF
   LOOP
END IF

//------------------------------------------------------------------
//  Close the dynamic cursor.
//------------------------------------------------------------------

CLOSE Control_Cursor ;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorCloseError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

IF l_Type = "EM" THEN
	l_EMName.DisplayData  = l_CodeDesc
	l_EMName.UseCodeTable = TRUE
	l_EMName.Spin         = TRUE
END IF

//------------------------------------------------------------------
//  Do any cleanup and exit the function.
//------------------------------------------------------------------

RETURN 0
end function

public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string column_pict, string where_clause, string all_keyword);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_LoadCode
//  Description   : Load a non-DataWindow, picture object using
//                  codes and descriptions from the database.
//
//  Parameters    : POWEROBJECT Control_Name  - 
//                     Name of the control to load its code table.
//                  TRANSACTION Trans_Object - 
//                     Transaction object.
//                  STRING      Table_Name   - 
//                     Table from where the column with the code
//                     values resides.
//                  STRING      Column_Code  - 
//                     Column name with the code values.
//                  STRING      Column_Desc  - 
//                     Column name with the code descriptions.
//                  STRING      Column_Pict  - 
//                     Column name with the pictures.
//                  STRING      Where_Clause - 
//                     WHERE cause statement to restrict the code 
//                     values.
//                  STRING      All_Keyword  - 
//                     Keyword to denote select all values 
//                     (e.g. "(All)").
//
//  Return Value  : INTEGER -
//                      0 = Load successful.
//                     -1 = Load failed.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN                l_IsNumber
LONG                   l_Nbr
STRING                 l_SQLString, l_Code, l_Desc, l_Type
STRING                 l_ErrorStrings[], l_Pict
DROPDOWNPICTURELISTBOX l_DDLBName
PICTURELISTBOX         l_LBName

//------------------------------------------------------------------
//  Determine the type of object.
//------------------------------------------------------------------

CHOOSE CASE TypeOf(control_name)
	CASE DropDownPictureListBox!
		l_DDLBName = control_name
		l_Type     = "DDLB"
		l_DDLBName.Reset()
	CASE PictureListBox!
		l_LBName   = control_name
		l_Type     = "LB"
		l_LBName.Reset()
END CHOOSE

//------------------------------------------------------------------
//  Declare a dynamic SQL cursor to hold the data while loading the
//  drop down list box.
//------------------------------------------------------------------

trans_object.SQLCode = 0
DECLARE Control_Cursor DYNAMIC CURSOR FOR SQLSA ;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorDeclareError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Build the SQL SELECT statement to get the data.
//------------------------------------------------------------------

l_SQLString = "SELECT " + column_code + ", " + &
              column_desc + ", " + column_pict + " FROM " + &
				  table_name
IF Trim(where_clause) <> "" THEN
   l_SQLString = l_SQLString + " WHERE " + where_clause
END IF

//------------------------------------------------------------------
//  Prepare the SQL statement for execution.
//------------------------------------------------------------------

PREPARE SQLSA FROM :l_SQLString USING trans_object;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorPrepareError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Open the dynamic cursor.
//------------------------------------------------------------------

OPEN DYNAMIC Control_Cursor ;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorOpenError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  If a keyword has been given to selct all, add it as a selection
//  to the drop down list box.
//------------------------------------------------------------------

IF all_keyword <> "" THEN
   l_Code = "(ALL)"
   l_Desc = all_keyword
   l_Desc = String(l_Desc, Fill("@", 80)) + "||" + l_Code
   IF l_Type = "DDLB" THEN
		l_DDLBName.AddItem(l_Desc)
		l_DDLBName.AddPicture("")
	ELSE
		l_LBName.AddItem(l_Desc)
		l_LBName.AddPicture("")
	END IF
END IF

//------------------------------------------------------------------
//  Determine if the code column is a number or a string.
//------------------------------------------------------------------

FETCH Control_Cursor INTO :l_Code, :l_Desc, :l_Pict ;

IF trans_object.SQLCode = 0 OR trans_object.SQLCode = 100 THEN
   l_IsNumber = FALSE
ELSE
   l_IsNumber = TRUE
END IF

CLOSE Control_Cursor ;
OPEN DYNAMIC Control_Cursor ;

//------------------------------------------------------------------
//  For each row in the cursor, add the description and code to the
//  drop down list box.
//------------------------------------------------------------------

IF l_IsNumber THEN
   DO WHILE trans_object.SQLCode = 0
      FETCH Control_Cursor INTO :l_Nbr, :l_Desc, :l_Pict ;
      IF trans_object.SQLCode = 0 THEN
         IF IsNull(l_Desc) <> FALSE THEN
  		      l_Nbr = -99999
  	      END IF

         IF column_code <> column_desc THEN
            l_Desc = String(l_Desc, Fill("@", 80)) + &
                     "||" + String(l_Nbr)
			END IF
			IF l_Type = "DDLB" THEN
 				l_DDLBName.AddItem(l_Desc)
				l_DDLBName.AddPicture(l_Pict)
			ELSEIF l_Type = "LB" THEN
				l_LBName.AddItem(l_Desc)
				l_LBName.AddPicture(l_Pict)
		END IF
      ELSE
         IF trans_object.SQLCode <> 100 THEN
	         l_ErrorStrings[1] = "PowerObjects Error"
	         l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	         l_ErrorStrings[3] = ""
	         l_ErrorStrings[4] = ClassName()
	         l_ErrorStrings[5] = "fu_LoadCode"
            l_ErrorStrings[6] = trans_object.SQLErrText
            OBJCA.MSG.fu_DisplayMessage("CursorFetchError", &
                                        6, l_ErrorStrings[])
            RETURN -1
         END IF
      END IF
   LOOP
ELSE
   DO WHILE trans_object.SQLCode = 0
      FETCH Control_Cursor INTO :l_Code, :l_Desc, :l_Pict ;
      IF trans_object.SQLCode = 0 THEN
         IF IsNull(l_Desc) <> FALSE THEN
  		      l_Code = "NULL"
  	      END IF
         IF column_code <> column_desc THEN
            l_Desc = String(l_Desc, Fill("@", 80)) + &
                     "||" + l_Code
			END IF
			IF l_Type = "DDLB" THEN
 				l_DDLBName.AddItem(l_Desc)
				l_DDLBName.AddPicture(l_Pict)
			ELSEIF l_Type = "LB" THEN
				l_LBName.AddItem(l_Desc)
				l_LBName.AddPicture(l_Pict)
			END IF
      ELSE
         IF trans_object.SQLCode <> 100 THEN
	         l_ErrorStrings[1] = "PowerObjects Error"
	         l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	         l_ErrorStrings[3] = ""
	         l_ErrorStrings[4] = ClassName()
	         l_ErrorStrings[5] = "fu_LoadCode"
            l_ErrorStrings[6] = trans_object.SQLErrText
            OBJCA.MSG.fu_DisplayMessage("CursorFetchError", &
                                        6, l_ErrorStrings[])
            RETURN -1
         END IF
      END IF
   LOOP
END IF

//------------------------------------------------------------------
//  Close the dynamic cursor.
//------------------------------------------------------------------

CLOSE Control_Cursor ;

IF trans_object.SQLCode <> 0 THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
   l_ErrorStrings[6] = trans_object.SQLErrText
   OBJCA.MSG.fu_DisplayMessage("CursorCloseError", &
                               6, l_ErrorStrings[])
   RETURN -1
END IF

//------------------------------------------------------------------
//  Do any cleanup and exit the function.
//------------------------------------------------------------------

RETURN 0
end function

public function integer fu_loadcode (datawindow dw_name, string dw_column, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_LoadCode
//  Description   : Load a DataWindow column using codes and 
//                  descriptions from the database.
//
//  Parameters    : DATAWINDOW  DW_Name -
//                     Name of the DataWindow with the code table
//                     to load.
//                  STRING      DW_Column -
//                     Column name with the code table to load.
//                  TRANSACTION Trans_Object -
//                     Transaction object.
//                  STRING      Table_Name -
//                     Table from where the column with the
//                     code values resides.
//                  STRING      Column_Code -
//                     Column name with the code code values.
//                  STRING      Column_Desc -
//                     Column name with the code descriptions.
//                  STRING      Where_Clause -
//                     WHERE clause statement to restrict the
//                     code values.
//                  STRING      All_Keyword -
//                     Keyword to denote select all values
//                     (e.g. "(All)")
//
//  Return Value  : INTEGER -
//                      0 = Load successful.
//                     -1 = Load failed.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1993-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN          l_Found, l_IsNumber
INTEGER          l_Idx, l_Jdx, l_NewWidth
LONG             l_Error, l_Nbr
STRING           l_SQLString, l_ErrStr, l_EditStyle[], l_ColType
STRING           l_Describe, l_Modify, l_Attrib, l_Style, l_Tab
STRING           l_ErrorStrings[], l_Code, l_Desc, l_Separator
STRING           l_CodeDesc, l_Return, l_DropWidth
DATAWINDOWCHILD  l_DWC

STRING           c_ColAttrib[]  =            &
                    { ".BackGround.Color",   & 
                      ".Background.Mode",    &
                      ".Border",             &
                      ".Color",              &
                      ".Font.CharSet",       &
                      ".Font.Face",          &
                      ".Font.Family",        &
                      ".Font.Height",        &
                      ".Font.Italic",        &
                      ".Font.Pitch",         &
                      ".Font.Strikethrough", &
                      ".Font.Underline",     &
                      ".Font.Weight",        &
                      ".Font.Width",         &
                      ".Height",             &
                      ".Width" }

//------------------------------------------------------------------
//  Determine the edit style of the column.
//------------------------------------------------------------------

l_EditStyle[1] = "DDLB.Required"
l_EditStyle[2] = "EditMask.Required"
l_EditStyle[3] = "DDDW.Required"

l_Found = FALSE
FOR l_Idx = 1 TO 3
	l_Style = dw_name.Describe(dw_column + "." + l_EditStyle[l_Idx])
	IF l_Style <> "?" THEN
		l_Style = Upper(Mid(l_EditStyle[l_Idx], 1, &
		             Pos(l_EditStyle[l_Idx], ".") - 1))
		l_Found = TRUE
		EXIT
	END IF
NEXT

IF NOT l_Found THEN
	l_ErrorStrings[1] = "PowerObjects Error"
	l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	l_ErrorStrings[3] = ""
	l_ErrorStrings[4] = ClassName()
	l_ErrorStrings[5] = "fu_LoadCode"
	OBJCA.MSG.fu_DisplayMessage("NoCodeTable", 5, l_ErrorStrings[])
	RETURN -1
END IF

//------------------------------------------------------------------
//  Load the appropriate code table.
//------------------------------------------------------------------

CHOOSE CASE l_Style

	CASE "DDDW"
		
      //------------------------------------------------------------
      //  Build the SQL SELECT statement.
      //------------------------------------------------------------

      l_SQLString = "SELECT " + column_desc + ", " + &
                    column_code + " FROM " + table_name

      IF Trim(where_clause) <> "" THEN
         l_SQLString = l_SQLString + " WHERE " + where_clause
      END IF

      //------------------------------------------------------------
      //  Get the child DataWindow.  If column is not a DDDW column,
      //  then return with error.  Otherwise, we need to set the
      //  Select statement in the drop down DataWindow.
      //------------------------------------------------------------

      l_Error = dw_name.GetChild(dw_column, l_DWC)

      IF l_Error <> 1 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         OBJCA.MSG.fu_DisplayMessage("DDDWFindError", 5, &
			                            l_ErrorStrings[])
         RETURN -1
		END IF

      //------------------------------------------------------------
      //  Set the transaction object.
      //------------------------------------------------------------

      l_Error = l_DWC.SetTransObject(trans_object)

      IF l_Error <> 1 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         OBJCA.MSG.fu_DisplayMessage("DDDWTransactionError", 5, &
			                            l_ErrorStrings[])
		   RETURN -1
		END IF

      //------------------------------------------------------------
      //  Assign the Select statement to the drop down DataWindow.
      //------------------------------------------------------------

      l_Modify = "DataWindow.Table.Select='" + &
                 OBJCA.MGR.fu_QuoteString(l_SQLString, "'")  + "'"
      l_ErrStr = l_DWC.Modify(l_Modify)

		IF l_ErrStr <> "" THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         OBJCA.MSG.fu_DisplayMessage("DDDWModifyError", 5, &
			                            l_ErrorStrings[])
   		RETURN -1
		END IF

      //------------------------------------------------------------
      //  Retrieve the data for the child DataWindow.
      //------------------------------------------------------------

		l_Error = l_DWC.Retrieve()

		IF l_Error < 0 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         OBJCA.MSG.fu_DisplayMessage("DDDWRetrieveError", 5, &
			                            l_ErrorStrings[])
   		RETURN -1
		END IF

		//------------------------------------------------------------
		//  If an ALL keyword is given, insert it into the first row
		//  on the child DataWindow.
		//------------------------------------------------------------
		
		IF Trim(all_keyword) <> "" THEN
			IF l_DWC.InsertRow(1) > 0 THEN
				l_Attrib = l_DWC.Describe("#1.ColType")
				IF Upper(l_Attrib) <> "NUMBER" THEN
					l_DWC.SetItem(1, 1, all_keyword)
				END IF
				
				l_Attrib = l_DWC.Describe("#2.ColType")
				IF Upper(l_Attrib) = "NUMBER" THEN
					l_DWC.SetItem(1, 2, -99999)
				ELSE
					l_DWC.SetItem(1, 2, "^")
				END IF
			END IF
		END IF
		
		//------------------------------------------------------------
		//  Set the attributes of the column to be the same as the
		//  parent column.
		//------------------------------------------------------------

		l_Jdx = UpperBound(c_ColAttrib[])
		FOR l_Idx = 1 TO l_Jdx
   		l_Describe = dw_column + c_ColAttrib[l_Idx]
   		l_Attrib   = dw_name.Describe(l_Describe)

   		IF c_ColAttrib[l_Idx] = ".Font.Face" THEN
      		IF l_Attrib = "?" OR l_Attrib = "!" THEN
         		l_Attrib = "Arial"
      		END IF
      		l_Attrib = "'" + l_Attrib + "'"
         ELSEIF c_ColAttrib[l_Idx] = ".Width" THEN
            IF l_Attrib = "?" OR l_Attrib = "!" THEN
               l_Attrib = "0"
            ELSE
               l_DropWidth = dw_name.Describe(dw_column + ".DDDW.PercentWidth")
               IF l_Attrib <> "?" AND l_Attrib <> "!" THEN
                  l_NewWidth = Ceiling(Integer(l_Attrib) * (Integer(l_DropWidth)/100))
                  l_Attrib = String(l_NewWidth)
               END IF
            END IF
   		ELSE
      		IF l_Attrib = "?" OR l_Attrib = "!" THEN
         		l_Attrib = "0"
      		END IF
   		END IF

   		l_Modify = "#1" + c_ColAttrib[l_Idx] + "=" + l_Attrib
   		l_ErrStr = l_DWC.Modify(l_Modify)

		NEXT

		//------------------------------------------------------------
		//  Make sure the border for the child column is off.
		//------------------------------------------------------------

		l_Modify = "#1" + ".Border=0"
		l_ErrStr = l_DWC.Modify(l_Modify)

	CASE "DDLB", "EDITMASK"
      
		//------------------------------------------------------------
      //  Determine the columns data type.
      //------------------------------------------------------------

      l_ColType = dw_name.Describe(dw_column + ".ColType")
      CHOOSE CASE UPPER(l_ColType)
         CASE "NUMBER"
            l_IsNumber = TRUE
         CASE ELSE
            l_IsNumber = FALSE
      END CHOOSE

      //------------------------------------------------------------
      //  Declare a dynamic SQL cursor to hold the data while 
      //  loading the code table.
      //------------------------------------------------------------

      trans_object.SQLCode = 0
      DECLARE Column_Cursor DYNAMIC CURSOR FOR SQLSA ;

      IF trans_object.SQLCode <> 0 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         l_ErrorStrings[6] = trans_object.SQLErrText
         OBJCA.MSG.fu_DisplayMessage("CursorDeclareError", &
                                     6, l_ErrorStrings[])
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  Build the SQL SELECT statement to get the data.
      //------------------------------------------------------------

      l_SQLString = "SELECT " + column_code + ", " + &
                    column_desc + " FROM " + table_name
      IF Trim(where_clause) <> "" THEN
         l_SQLString = l_SQLString + " WHERE " + where_clause
      END IF

      //------------------------------------------------------------
      //  Prepare the SQL statement for execution.
      //------------------------------------------------------------

      PREPARE SQLSA FROM :l_SQLString USING trans_object ;

      IF trans_object.SQLCode <> 0 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         l_ErrorStrings[6] = trans_object.SQLErrText
         OBJCA.MSG.fu_DisplayMessage("CursorPrepareError", &
                                     6, l_ErrorStrings[])
         RETURN -1
      END IF

      //------------------------------------------------------------
      //  Open the dynamic cursor.
      //------------------------------------------------------------

      OPEN DYNAMIC Column_Cursor ;

      IF trans_object.SQLCode <> 0 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         l_ErrorStrings[6] = trans_object.SQLErrText
         OBJCA.MSG.fu_DisplayMessage("CursorOpenError", &
                                     6, l_ErrorStrings[])
         RETURN -1
      END IF
		
      //------------------------------------------------------------
      //  If the column type is "DDLB", clear all the values.
      //------------------------------------------------------------
		
		IF l_Style = "DDLB" THEN
			dw_name.ClearValues(dw_column)
		ELSE
			l_CodeDesc  = ""
			l_Tab       = "~t"
			l_Separator = "/"
		END IF

      //------------------------------------------------------------
      //  If a keyword has been given to select all, add it as a 
      //  selection to the code table.
      //------------------------------------------------------------

      l_Idx = 0
      IF TRIM(all_keyword) <> "" THEN
         l_Idx = l_Idx + 1
         IF l_IsNumber THEN
            l_Code = String(-99999)
         ELSE
            l_Code = "^"
         END IF
         l_Desc = all_keyword
         l_Desc = l_Desc + "~t" + l_Code
			IF l_Style = "DDLB" THEN
            dw_name.SetValue(dw_column, l_Idx, l_Desc)
			ELSE
				l_CodeDesc = l_Desc + l_Separator
			END IF
      END IF

      //------------------------------------------------------------------
      //  For each row in the cursor, add the description and code 
      //  to the code table.
      //------------------------------------------------------------------

      IF NOT l_IsNumber THEN
         DO WHILE trans_object.SQLCode = 0
            FETCH Column_Cursor INTO :l_Code, :l_Desc ;
            IF trans_object.SQLCode = 0 THEN
               IF IsNull(l_Desc) <> FALSE THEN
                  l_Desc = l_Code
               END IF
					IF l_Style = "DDLB" THEN
                  l_Idx = l_Idx + 1
                  IF column_code <> column_desc THEN
                     l_Desc = l_Desc + "~t" + l_Code
                  END IF
                  dw_name.SetValue(dw_column, l_Idx, l_Desc)
					ELSE
						l_CodeDesc = l_CodeDesc + l_Desc + l_Tab + &
						             l_Code + l_Separator
					END IF
            ELSE
               IF trans_object.SQLCode <> 100 THEN
	               l_ErrorStrings[1] = "PowerObjects Error"
	               l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	               l_ErrorStrings[3] = ""
	               l_ErrorStrings[4] = ClassName()
	               l_ErrorStrings[5] = "fu_LoadCode"
                  l_ErrorStrings[6] = trans_object.SQLErrText
         			OBJCA.MSG.fu_DisplayMessage("CursorFetchError", &
                                              6, l_ErrorStrings[])
                  RETURN -1
               END IF
            END IF
         LOOP
      ELSE
         DO WHILE trans_object.SQLCode = 0
            FETCH Column_Cursor INTO :l_Nbr, :l_Desc ;
            IF trans_object.SQLCode = 0 THEN
               IF IsNull(l_Desc) <> FALSE THEN
                  l_Desc = String(l_Nbr)
               END IF
					IF l_Style = "DDLB" THEN
                  l_Idx = l_Idx + 1
                  IF column_code <> column_desc THEN
                     l_Desc = l_Desc + "~t" + String(l_Nbr)
                  END IF
                  dw_name.SetValue(dw_column, l_Idx, l_Desc)
					ELSE
						l_CodeDesc = l_CodeDesc + l_Desc + l_Tab + &
						             String(l_Nbr) + l_Separator
					END IF
            ELSE
               IF trans_object.SQLCode <> 100 THEN
	               l_ErrorStrings[1] = "PowerObjects Error"
	               l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	               l_ErrorStrings[3] = ""
	               l_ErrorStrings[4] = ClassName()
	               l_ErrorStrings[5] = "fu_LoadCode"
                  l_ErrorStrings[6] = trans_object.SQLErrText
         			OBJCA.MSG.fu_DisplayMessage("CursorFetchError", &
                                              6, l_ErrorStrings[])
                  RETURN -1
               END IF
            END IF
         LOOP
      END IF

      //------------------------------------------------------------
      //  Close the dynamic cursor.
      //------------------------------------------------------------

      CLOSE Column_Cursor ;

      IF trans_object.SQLCode <> 0 THEN
	      l_ErrorStrings[1] = "PowerObjects Error"
	      l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	      l_ErrorStrings[3] = ""
	      l_ErrorStrings[4] = ClassName()
	      l_ErrorStrings[5] = "fu_LoadCode"
         l_ErrorStrings[6] = trans_object.SQLErrText
         OBJCA.MSG.fu_DisplayMessage("CursorCloseError", &
                                     6, l_ErrorStrings[])
         RETURN -1
      END IF
		
      IF l_Style = "EDITMASK" THEN
		   l_Return = dw_name.Modify(dw_column + ".values='" + l_CodeDesc + "'")
		   IF l_Return <> "" THEN
			   RETURN -1
		   END IF
		END IF
	
	CASE ELSE
		
		RETURN -1
		
END CHOOSE

RETURN 0
end function

public function string fu_selectcode (powerobject control_name);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_SelectCode
//  Description   : Select the code associated with the description
//                  from a non-datawindow control.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name with the code table.
//
//  Return Value  : STRING - 
//                     Return the code as a string.  If no value
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

STRING                 l_Text, l_Type
INTEGER                l_Pos, l_Tab, l_Slash
DROPDOWNPICTURELISTBOX l_PDDLBName
DROPDOWNLISTBOX        l_DDLBName
EDITMASK               l_EMName

//------------------------------------------------------------------
//  Determine the type of object.
//------------------------------------------------------------------

CHOOSE CASE TypeOf(control_name)
	CASE DropDownListBox!
		l_DDLBName  = control_name
		l_Text      = l_DDLBName.Text
		l_Type      = "DDLB"
	CASE DropDownPictureListBox!
		l_PDDLBName = control_name
		l_Text      = l_PDDLBName.Text
		l_Type      = "PDDLB"
	CASE EditMask!
		l_EMName    = control_name
		l_Type      = "EM"
END CHOOSE

//------------------------------------------------------------------
//  Pull the code from the end of the text. If the code is empty, 
//  return the description from the function.
//------------------------------------------------------------------

CHOOSE CASE l_Type

	CASE "DDLB", "PDDLB"
		
		IF Pos(l_Text, "||") > 0 THEN
   		l_Text = Mid(l_Text, Pos(l_Text, "||") + 2)
		END IF
		
	CASE "EM"
		
		IF l_EMName.Spin AND l_EMName.UseCodeTable THEN
   		l_Pos   = Pos(l_EMName.DisplayData, l_EMName.Text)
   		l_Tab   = Pos(l_EMName.DisplayData, "~t", l_Pos)
   		l_Slash = Pos(l_EMName.DisplayData, "/", l_Tab)
   		l_Text  = Mid(l_EMName.DisplayData, l_Tab + 1, l_Slash - l_Tab - 1)
		ELSE
			l_Text  = l_EMName.Text
		END IF
		
END CHOOSE

//------------------------------------------------------------------
//  If the code is NULL or (ALL), return an empty string from the
//  function.
//------------------------------------------------------------------

IF l_Text = "NULL" OR l_Text = "-99999" OR l_Text = "(ALL)" THEN
   l_Text = ""
END IF

//-------------------------------------------------------------------
//  Do any cleanup and exit the function.
//-------------------------------------------------------------------

RETURN l_Text

end function

public function integer fu_setcode (powerobject control_name, string default_code);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Subroutine    : fu_SetCode
//  Description   : Sets a default value for this control.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control to set a default code for.
//                  STRING      Default_Code -
//                     The value to set for this control.
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

LONG                   l_NumItems, l_Idx
STRING                 l_Value, l_Type
DROPDOWNPICTURELISTBOX l_PDDLBName
DROPDOWNLISTBOX        l_DDLBName
EDITMASK               l_EMName
SINGLELINEEDIT         l_SLEName

//------------------------------------------------------------------
//  Determine the type of object.
//------------------------------------------------------------------

CHOOSE CASE TypeOf(control_name)
	CASE DropDownListBox!
		l_DDLBName  = control_name
		l_NumItems  = l_DDLBName.TotalItems()
		l_Type      = "DDLB"
	CASE DropDownPictureListBox!
		l_PDDLBName = control_name
		l_NumItems  = l_PDDLBName.TotalItems()
		l_Type      = "PDDLB"
	CASE EditMask!
		l_EMName    = control_name
		l_Type      = "EM"
	CASE SingleLineEdit!
		l_SLEName   = control_name
		l_Type      = "SLE"
END CHOOSE

CHOOSE CASE l_Type

	CASE "DDLB", "PDDLB"
		
   	IF l_Type = "DDLB" THEN
			l_DDLBName.SelectItem(0)
		ELSE
			l_PDDLBName.SelectItem(0)	
		END IF

		FOR l_Idx = 1 TO l_NumItems
   		IF l_Type = "DDLB" THEN
				l_Value = l_DDLBName.Text(l_Idx)
			ELSE
				l_Value = l_PDDLBName.Text(l_Idx)	
			END IF

			l_Value = MID(l_Value, Pos(l_Value, "||") + 2)

			IF l_Value = default_code THEN
   			IF l_Type = "DDLB" THEN
					l_DDLBName.SelectItem(l_Idx)
				ELSE
					l_PDDLBName.SelectItem(l_Idx)	
				END IF
	   		RETURN 0
   		END IF
		NEXT
		
   	IF l_Type = "DDLB" THEN
			l_DDLBName.Text = ""
		ELSE
			l_PDDLBName.Text = ""
		END IF

	CASE "EM"
		
		l_EMName.Text = default_code
		RETURN 0
		
	CASE "SLE"
		
		l_SLEName.Text = default_code
		RETURN 0

END CHOOSE

RETURN -1
end function

public function integer fu_setcode (powerobject control_name, string default_code[]);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Subroutine    : fu_SetCode
//  Description   : Sets a default value for a list box control.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control to set a default code for.
//                  STRING      Default_Code[] -
//                     An array of default values.
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

LONG           l_NumItems, l_Idx, l_NumCodes, l_Jdx
STRING         l_Value, l_Type, l_Code
PICTURELISTBOX l_PLBName
LISTBOX        l_LBName

//------------------------------------------------------------------
//  Determine the type of object.
//------------------------------------------------------------------

CHOOSE CASE TypeOf(control_name)
	CASE ListBox!
		l_LBName   = control_name
		l_NumItems = l_LBName.TotalItems()
		l_Type     = "LB"
	CASE PictureListBox!
		l_PLBName  = control_name
		l_NumItems = l_PLBName.TotalItems()
		l_Type     = "PLB"
END CHOOSE

//------------------------------------------------------------------
//  Set the default values.
//------------------------------------------------------------------

l_NumCodes = UpperBound(default_code[])

//------------------------------------------------------------------
// Make sure all items in the LB or PLB are deselected.
//------------------------------------------------------------------

IF l_Type = "LB" THEN
	l_LBName.SetState(0, FALSE)
ELSE
	l_PLBName.SetState(0, FALSE)
END IF

//------------------------------------------------------------------
// Set the state to TRUE for every element in the array default_code[].
//------------------------------------------------------------------

FOR l_Idx = 1 TO l_NumCodes
   l_Code = TRIM(default_code[l_Idx])
   FOR l_Jdx = 1 TO l_NumItems
      IF l_Type = "LB" THEN
			l_Value = l_LBName.Text(l_Jdx)
		ELSE
			l_Value = l_PLBName.Text(l_Jdx)			
		END IF

		l_Value = MID(l_Value, Pos(l_Value, "||") + 2)

		IF l_Value = l_Code THEN
      	IF l_Type = "LB" THEN
				l_LBName.SetState(l_Jdx, TRUE)
			ELSE
				l_PLBName.SetState(l_Jdx, TRUE)			
			END IF
         EXIT
      END IF
   NEXT
NEXT 

RETURN 0
end function

public function integer fu_setcode (datawindow dw_name, string dw_column, string default_code);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Subroutine    : fu_SetCode
//  Description   : Sets a default value for a DataWindow column.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     DataWindow to set the default value for.
//                  STRING     DW_Column -
//                     The column in the DataWindow to set the
//                     default code for.
//                  STRING     Default_Code  -
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

STRING  l_ColType
INTEGER l_Return

//------------------------------------------------------------------
//  Set the default code depending on the edit style of the column.
//------------------------------------------------------------------

l_ColType  = Upper(dw_name.Describe(dw_column + ".ColType"))
IF l_ColType = "?" THEN
   RETURN -1
END IF
IF Left(l_ColType, 3) = "DEC" OR &
   l_ColType = "LONG" OR &
	l_ColType = "ULONG" OR &
	l_ColType = "REAL" THEN
   l_ColType = "NUMBER"
END IF
IF Left(l_ColType, 4) = "CHAR" THEN
   l_ColType = "STRING"
END IF

CHOOSE CASE l_ColType
   CASE "NUMBER"
      l_Return = dw_name.SetItem(dw_name.GetRow(), dw_column, Double(default_code))
   CASE "STRING"
      l_Return = dw_name.SetItem(dw_name.GetRow(), dw_column, default_code)
   CASE "DATE"
      l_Return = dw_name.SetItem(dw_name.GetRow(), dw_column, Date(default_code))
   CASE "DATETIME"
      l_Return = dw_name.SetItem(dw_name.GetRow(), dw_column, DateTime(Date(default_code)))
   CASE "TIME"
      l_Return = dw_name.SetItem(dw_name.GetRow(), dw_column, Time(default_code))
END CHOOSE

IF l_Return = 1 THEN
   l_Return = 0
END IF

RETURN l_Return
end function

public function integer fu_validatedate (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateDate
//  Description   : Check the value for a correct date.  If a format
//                  is given, return the value using the format.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a date.
//                  STRING  Format - 
//                     Format to return the date in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_Value, l_ValueAdd, l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)
l_Value = Value

//------------------------------------------------------------------
//  If the value includes time, remove it.
//------------------------------------------------------------------

IF Pos(l_Value, " ") > 0 THEN
   l_Value = Mid(l_Value, 1, Pos(l_Value, " "))
END IF

//------------------------------------------------------------------
//  See if the value is a valid date.
//------------------------------------------------------------------

IF IsDate(l_Value) THEN
   l_Error = 0
   Value   = l_Value
   IF Trim(Format) <> "" THEN
      Value = String(Date(Value), Lower(Format))
   END IF
ELSE

   //---------------------------------------------------------------
   //  If not, try adding the current year and retesting. 
   //---------------------------------------------------------------

   l_ValueAdd = l_Value + " " + String(Year(Today()))
   IF IsDate(l_ValueAdd) THEN
      l_Error = 0
      Value   = l_ValueAdd
      IF Trim(Format) <> "" THEN
         Value = String(Date(Value), Lower(Format))
      END IF

   ELSE
	
  		//------------------------------------------------------------
  		//  If the date has no delimiters, create a date based
		//  on the length of the value.
  		//------------------------------------------------------------

  		IF IsNumber(l_Value) THEN
	      CHOOSE CASE Len(l_Value)
           	CASE 1, 2
					l_Value = String(Month(Today())) + " " + &
			                l_Value + " " + &
			                String(Year(Today()))
				CASE 4
              	l_Value = Left(l_Value, 2)  + " " + &
                       	 Right(l_Value, 2) + " " + &
                       	 String(Year(Today()))
           	CASE 6
              	l_Value = Left(l_Value, 2)   + " " + &
                       	 Mid(l_Value, 3, 2) + " " + &
                       	 Right(l_Value, 2)
           	CASE 8
              	l_Value = Left(l_Value, 2)   + " " + &
                       	 Mid(l_Value, 3, 2) + " " + &
                       	 Right(l_Value, 4)
         END CHOOSE

         //---------------------------------------------------------
         //  Check the value again for a valid date.
         //---------------------------------------------------------

         IF IsDate(l_Value) THEN
           	l_Error = 0
           	Value   = l_Value
           	IF Trim(Format) <> "" THEN
              	Value = String(Date(l_Value), Lower(Format))
           	END IF
         END IF
      END IF
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateDate"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValDateError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValDateError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatedec (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateDec
//  Description   : Check the value for a correct decimal or real
//                  number.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a number.
//                  STRING  Format - 
//                     Format to return the number in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check to see if the value is a number.
//------------------------------------------------------------------

IF IsNumber(Value) THEN

   l_Error = 0

   //---------------------------------------------------------------
   //  If a format is given, apply the format and return the value.
   //---------------------------------------------------------------

   IF Trim(Format) <> "" THEN
      Value = String(Dec(Value), Format)
   END IF   
END IF


IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateDec"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValDecError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValDecError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatedom (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateDOM
//  Description   : Check the value for a correct day of the month.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a day of the month.
//                  STRING  Format - 
//                     Format to return the day in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check the value to see if it is a valid number.
//------------------------------------------------------------------

IF IsNumber(Value) THEN

   //---------------------------------------------------------------
   //  Check the value to see if it is an integer.
   //---------------------------------------------------------------

   IF Match(Value, "^[0-9]+$") THEN

      //------------------------------------------------------------
      //  Make sure the day of the month is between 1 and 31.
      //------------------------------------------------------------

      IF Integer(Value) > 0 AND Integer(Value) < 32 THEN

         l_Error = 0

         //------------------------------------------------------------
         //  If a format is given, apply the format and return the
         //  value.
         //------------------------------------------------------------

         IF Len(Value) = 1 AND Upper(Format) = "DD" THEN
            Value = "0" + Value
         END IF
      END IF
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateDOM"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValDOMError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValDOMError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatedow (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateDOW
//  Description   : Check the value for a correct day of the week.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a day of the week.
//                  STRING  Format - 
//                     Format to return the day in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_DayPos, l_Error
STRING   l_Value,  l_DayStr, l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)
l_Value = Value

//------------------------------------------------------------------
//  Build a string with valid days of the week.
//------------------------------------------------------------------

l_DayStr = " monday    " + &
           " tuesday   " + &
           " wednesday " + &
           " thursday  " + &
           " friday    " + &
           " saturday  " + &
           " sunday    "

//------------------------------------------------------------------
//  Make sure the value doesn't have a blank inside the string.
//------------------------------------------------------------------

IF Pos(l_Value, " ") = 0 THEN

   //---------------------------------------------------------------
   //  Locate the value in the day of the week string.  If all or
   //  part of the value is contained in the string, get the day
   //  of the week from the string.
   //---------------------------------------------------------------

   l_DayPos = Pos(l_DayStr, " " + Lower(l_Value))
   IF l_DayPos > 0 THEN
      l_Error = 0
      Value   = Trim(Mid(l_DayStr, l_DayPos, 10))

      //------------------------------------------------------------
      //  If a format is given, apply the format and return the
      //  value.
      //------------------------------------------------------------

      CHOOSE CASE Upper(Format)
         CASE "DDD"
            Value = Upper(Left(Value, 1)) + Mid(Value, 2, 2)   
         CASE "DDDD"
            Value = Upper(Left(Value, 1)) + Mid(Value, 2)
      END CHOOSE
   END IF
END IF
IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateDOW"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValDOWError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValDOWError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatemon (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateMon
//  Description   : Check the value for a correct month of the year.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a month of the year.
//                  STRING  Format - 
//                     Format to return the month in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_MonthPos, l_Pos, l_MonthType, l_Error
STRING   l_Value, l_MonthStr, l_MonthNum, l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error  = 1
Value    = Trim(Value)
l_Value  = Value

//------------------------------------------------------------------
//  Build a string with months of the year as strings and numbers.
//------------------------------------------------------------------

l_MonthStr = " january  " + &
             " february " + &
             " march    " + &
             " april    " + &
             " may      " + &
             " june     " + &
             " july     " + &
             " august   " + &
             " september" + &
             " october  " + &
             " november " + &
             " december "

l_MonthNum = " 01 02 03 04 05 06 07 08 09 10 11 12"

//------------------------------------------------------------------
//  Make sure the value doesn't have any embedded blanks.
//------------------------------------------------------------------

IF Pos(l_Value, " ") = 0 THEN

   //---------------------------------------------------------------
   //  If the value is numeric and has a length of 1, add a
   //  leading zero so a comparison can be done with the numeric
   //  months of the year string.
   //---------------------------------------------------------------

   IF Len(l_Value) = 1 AND Pos("1234567890", l_Value) > 0 THEN
      l_Value = "0" + l_Value
   END IF

   //---------------------------------------------------------------
   //  Check to see if the value is contained in one of the months
   //  of the year strings.  If so, extract the full month or
   //  month number from the string and return the value.
   //---------------------------------------------------------------

   l_MonthPos = Pos(l_MonthStr, " " + Lower(l_Value))
   IF l_MonthPos = 0 THEN
      l_MonthPos = Pos(l_MonthNum, " " + l_Value)
      IF l_MonthPos > 0 THEN
         l_Value     = Trim(Mid(l_MonthNum, l_MonthPos, 3))
         l_MonthType = 1      
      END IF
   ELSE
      l_Value     = Trim(Mid(l_MonthStr, l_MonthPos, 10))
      l_MonthType = 2
   END IF

   //---------------------------------------------------------------
   //  If a format is given, apply the format to the month and
   //  return the value.
   //---------------------------------------------------------------

   IF l_MonthPos > 0 THEN

      l_Error = 0

      CHOOSE CASE Upper(Format)
         CASE "M"
            IF l_MonthType = 2 THEN
               l_Pos   = Int((l_MonthPos - 1)/10) + 1
               l_Value = Trim(Mid(l_MonthNum, (l_Pos - 1)*3+1, 3))
            END IF
            IF Left(l_Value, 1) = "0" THEN
               Value = Right(l_Value, 1)
            ELSE
               Value = Trim(l_Value)
            END IF
         CASE "MM"
            IF l_MonthType = 2 THEN
               l_Pos   = Int((l_MonthPos - 1)/10) + 1
               l_Value = Trim(Mid(l_MonthNum, (l_Pos - 1)*3+1, 3))
            END IF
            Value = Trim(l_Value)
         CASE "MMM"
            IF l_MonthType = 1 THEN
               l_Pos   = Int((l_MonthPos - 1)/3) + 1
               l_Value = Trim(Mid(l_MonthStr, (l_Pos - 1)*10+1, 10))
            END IF
            Value = Upper(Left(l_Value, 1)) + Mid(l_Value, 2, 2)   
         CASE "MMMM"
            IF l_MonthType = 1 THEN
               l_Pos   = Int((l_MonthPos - 1)/3) + 1
               l_Value = Trim(Mid(l_MonthStr, (l_Pos - 1)*10+1, 10))
            END IF
            Value = Upper(Left(l_Value,1)) + Mid(l_Value, 2)
      END CHOOSE
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateMon"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValMonthError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValMonthError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatetime (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateTime
//  Description   : Check the value for a correct time.  If a format
//                  is given, return the value using the format.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a time.
//                  STRING  Format - 
//                     Format to return the time in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_Value, l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check to see if the value is a valid time.  If a format is
//  given, apply the format to the string and return the value.
//------------------------------------------------------------------

IF IsTime(Value) THEN
   l_Error = 0
   IF Trim(Format) <> "" THEN
      Value = String(Time(Value), Lower(Format))
   END IF
ELSE

   //---------------------------------------------------------------
   //  If no format is given, try to determine an appropriate
   //  format based on the length of the value.
   //---------------------------------------------------------------

   IF IsNumber(Value) THEN
      l_Value = Value
      CHOOSE CASE Len(l_Value)
         CASE 4
            l_Value = Left(l_Value, 2) + ":" + Right(l_Value, 2)
         CASE 6
            l_Value = Left(l_Value, 2)   + ":" + &
                      Mid(l_Value, 3, 2) + ":" + &
                      Right(l_Value, 2)
      END CHOOSE

      //-------------------------------------------------------------
      //  After formatting the value, check again for a valid time.
      //-------------------------------------------------------------

      IF IsTime(l_Value) THEN
         l_Error = 0
         Value   = l_Value
         IF Trim(Format) <> "" THEN
            Value = String(Time(Value), Lower(Format))
         END IF
      END IF
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateTime"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValTimeError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValTimeError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validateyear (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateYear
//  Description   : Check the value for a correct year.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a year.
//                  STRING  Format - 
//                     Format to return the year in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check to see if the value is a valid number.
//------------------------------------------------------------------

IF IsNumber(Value) THEN

   //---------------------------------------------------------------
   //  Check to see if the value is a valid integer.
   //---------------------------------------------------------------

   IF Match(Value, "^[0-9]+$") THEN

      //------------------------------------------------------------
      //  Make sure the length of the value is either 1, 2, or 4
      //  characters.  If a format is given, apply the format and
      //  return the value.
      //------------------------------------------------------------

      CHOOSE CASE Len(Value)
         CASE 1
            l_Error = 0
            Value   = "0" + Value

         CASE 2
            l_Error = 0
            IF Upper(Format) = "YYYY" THEN
               Value = Left(String(Year(Today())), 2) + Value
            END IF

         CASE 4
            l_Error = 0
            IF Upper(Format) = "YY" THEN
               Value = Right(Value, 2)
            END IF
      END CHOOSE
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateYear"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValYearError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValYearError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validateint (ref string value, string format, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateInt
//  Description   : Check the value for a correct integer number.
//
//  Parameters    : REF STRING  Value  - 
//                     String containing a number.
//                  STRING  Format - 
//                     Format to return the number in.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check to see if the value is a valid number.
//------------------------------------------------------------------

IF IsNumber(Value) THEN

   //---------------------------------------------------------------
   //  Check to see if the value is an integer with an
   //  optional -/+.
   //---------------------------------------------------------------

   IF Match(Value, "^[\+\-]?[0-9]+$") THEN

      l_Error = 0

      //---------------------------------------------------------------
      //  If a format is given, apply the format and return the
      //  value.
      //---------------------------------------------------------------

      IF Trim(Format) <> "" THEN
         Value = String(Integer(Value), Format)
      END IF
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateInt"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValIntError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValIntError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatemaxlen (string value, long length, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateMaxLen
//  Description   : Checks that the value is not more than Length
//                  long.
//
//  Parameters    : STRING  Value  - 
//                     String to test for the length.
//                  STRING  Length - 
//                     The maximum length to test for.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
REAL     l_ErrorNumbers[]
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

IF Len(Value) <= Length THEN
   l_Error = 0
END IF

IF l_Error = 1 THEN
   IF display_error THEN
      l_ErrorNumbers[1] = Length
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateMaxLen"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValMaxLenError", &
                                  1, l_ErrorNumbers[], &
											 6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValMaxLenError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validateminlen (string value, long length, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateMinLen
//  Description   : Checks that the value is at least Length
//                  long.
//
//  Parameters    : STRING  Value  - 
//                     String to test for the length.
//                  STRING  Length - 
//                     The minimum length to test for.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
REAL     l_ErrorNumbers[]
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

IF Len(Value) >= Length THEN
   l_Error = 0
END IF

IF l_Error = 1 THEN
   IF display_error THEN
      l_ErrorNumbers[1] = Length
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateMinLen"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValMinLenError", &
                                  1, l_ErrorNumbers[], &
											 6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValMinLenError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatege (string value, real compare, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateGE
//  Description   : Check the value to see if it is greater than
//                  or equal to another number.
//
//  Parameters    : STRING  Value  - 
//                     String containing a number.
//                  STRING  Compare - 
//                     Number to use in the comparison.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
REAL     l_ErrorNumbers[]
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check if the value is a valid number.  If so, check to see if
//  the value is greater than or equal to the second number.
//------------------------------------------------------------------

l_Error = fu_ValidateDec(Value, "", display_error)
IF l_Error = 0 THEN
   IF Real(Value) >= compare THEN
      l_Error = 0
   ELSE
      l_Error = 1
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
      l_ErrorNumbers[1] = compare
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateGE"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValGEError", &
                                  1, l_ErrorNumbers[], &
											 6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValGEError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validategt (string value, real compare, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateGT
//  Description   : Check the value to see if it is greater than
//                  another number.
//
//  Parameters    : STRING  Value  - 
//                     String containing a number.
//                  STRING  Compare - 
//                     Number to use in the comparison.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
REAL     l_ErrorNumbers[]
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check if the value is a valid number.  If so, check to see if
//  the value is greater than or equal to the second number.
//------------------------------------------------------------------

l_Error = fu_ValidateDec(Value, "", display_error)
IF l_Error = 0 THEN
   IF Real(Value) > compare THEN
      l_Error = 0
   ELSE
      l_Error = 1
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
      l_ErrorNumbers[1] = compare
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateGT"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValGTError", &
                                  1, l_ErrorNumbers[], &
											 6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValGTError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatele (string value, real compare, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateLE
//  Description   : Check the value to see if it is less than
//                  or equal to another number.
//
//  Parameters    : STRING  Value  - 
//                     String containing a number.
//                  STRING  Compare - 
//                     Number to use in the comparison.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
REAL     l_ErrorNumbers[]
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check if the value is a valid number.  If so, check to see if
//  the value is greater than or equal to the second number.
//------------------------------------------------------------------

l_Error = fu_ValidateDec(Value, "", display_error)
IF l_Error = 0 THEN
   IF Real(Value) <= compare THEN
      l_Error = 0
   ELSE
      l_Error = 1
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
      l_ErrorNumbers[1] = compare
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateLE"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValLEError", &
                                  1, l_ErrorNumbers[], &
											 6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValLEError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatelt (string value, real compare, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateLT
//  Description   : Check the value to see if it is less than
//                  another number.
//
//  Parameters    : STRING  Value  - 
//                     String containing a number.
//                  STRING  Compare - 
//                     Number to use in the comparison.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
REAL     l_ErrorNumbers[]
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check if the value is a valid number.  If so, check to see if
//  the value is greater than or equal to the second number.
//------------------------------------------------------------------

l_Error = fu_ValidateDec(Value, "", display_error)
IF l_Error = 0 THEN
   IF Real(Value) < compare THEN
      l_Error = 0
   ELSE
      l_Error = 1
   END IF
END IF

IF l_Error = 1 THEN
   IF display_error THEN
      l_ErrorNumbers[1] = compare
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateLT"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValLTError", &
                                  1, l_ErrorNumbers[], &
											 6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValLTError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatelength (string value, long length, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateLength
//  Description   : Checks the length of a value.
//
//  Parameters    : STRING  Value  - 
//                     String to test for the length.
//                  STRING  Length - 
//                     The length to test for.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
REAL     l_ErrorNumbers[]
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

IF Len(Value) = Length THEN
   l_Error = 0
END IF

IF l_Error = 1 THEN
   IF display_error THEN
      l_ErrorNumbers[1] = Length
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateLength"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValLenError", &
                                  1, l_ErrorNumbers[], &
											 6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValLenError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_selectcode (powerobject control_name, ref string codes[]);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_SelectCode
//  Description   : Select the codes associated with the description
//                  from a non-DataWindow control.
//
//  Parameters    : POWEROBJECT Control_Name -
//                     Control name with the code table.
//                  STRING      Codes[] - 
//                     Array of codes corresponding to the currently
//                     selected items in the controls code table.
//
//  Return Value  : INTEGER - 
//                     Number of items selected.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER        l_Cnt, l_Idx, l_NumItems, l_State
STRING         l_Value, l_NullArray[], l_Type
PICTURELISTBOX l_PLBName
LISTBOX        l_LBName

//------------------------------------------------------------------
//  Determine the type of object.
//------------------------------------------------------------------

CHOOSE CASE TypeOf(control_name)
	CASE PictureListBox!
		l_PLBName = control_name
		l_NumItems= l_PLBName.TotalItems()
		l_Type    = "LBPICT"
	CASE ListBox!
		l_LBName  = control_name
		l_NumItems= l_LBName.TotalItems()
		l_Type    = "LB"
END CHOOSE

//------------------------------------------------------------------
//  Pull the code from each item selected in the control.
//------------------------------------------------------------------

l_Cnt = 0
FOR l_Idx = 1 TO l_NumItems
   IF l_Type = "LB" THEN
		l_State = l_LBName.State(l_Idx)
	ELSE
		l_State = l_PLBName.State(l_Idx)	
	END IF
	
	IF l_State = 1 THEN
      l_Cnt        = l_Cnt + 1

		IF l_Type = "LB" THEN
			l_Value = l_LBName.Text(l_Idx)
		ELSE
			l_Value = l_PLBName.Text(l_Idx)	
		END IF

      IF Pos(l_Value, "||") > 0 THEN
     	   codes[l_Cnt] = Mid(l_Value, Pos(l_Value, "||") + 2)
     	   IF codes[l_Cnt] = "NULL"   OR &
            codes[l_Cnt] = "-99999" OR &
            codes[l_Cnt] = "(ALL)" THEN
            l_Cnt   = 0
        	   codes[] = l_NullArray[]
            EXIT
         END IF
      ELSE
         codes[l_Cnt] = l_Value
      END IF
   END IF
NEXT

//------------------------------------------------------------------
//  Do any cleanup and exit the function.
//------------------------------------------------------------------

RETURN l_Cnt
end function

public function integer fu_validatefmt (ref string value, string pattern, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateFMT
//  Description   : Check the value to see if it matches the given
//                  pattern or format.
//
//  Parameters    : STRING  Value  - 
//                     String containing the value to match.
//                  STRING  Pattern - 
//                     Pattern to check the value against.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_ErrorStrings[]

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Check that the value matches the given pattern.
//------------------------------------------------------------------

IF Match(Value, Pattern) THEN
   l_Error = 0
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateFmt"
      l_ErrorStrings[6] = Value
		l_ErrorStrings[7] = Pattern
      OBJCA.MSG.fu_DisplayMessage("ValFormatError", &
                                  7, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValFormatError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatephone (ref string value, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidatePhone
//  Description   : Check the value for a correct phone number.
//
//  Parameters    : STRING  Value  - 
//                     String containing a phone number.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error, l_Idx
STRING   l_ErrorStrings[], l_Value

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

//------------------------------------------------------------------
//  Remove any formatting of the phone number from the value.
//------------------------------------------------------------------

IF Match(Value, "^[0-9()/\-x ]+$") THEN
   l_Value = ""
   FOR l_Idx = 1 TO Len(Value)
      IF Pos("0123456789", Mid(Value, l_Idx, 1)) > 0 THEN
         l_Value = l_Value + Mid(Value, l_Idx, 1)
      END IF
   NEXT

   //---------------------------------------------------------------
   //  Determine the format of the phone number by the length of
   //  the value.  Return the value using the format:
   //     (nnn) nnn-nnnn xnnnn
   //---------------------------------------------------------------

   CHOOSE CASE Len(l_Value)
      CASE 7
         l_Error = 0
         Value   = Left(l_Value, 3) + "-" + Right(l_Value, 4)

      CASE 10
         l_Error = 0
         Value   = "(" + Left(l_Value, 3) + ") " + &
                   Mid(l_Value, 4, 3) + "-" + Right(l_Value, 4)

      CASE is > 10
         l_Error = 0
         Value   = "(" + Left(l_Value, 3) + ") " + &
                   Mid(l_Value, 4, 3) + "-" + &
                   Mid(l_Value, 7, 4) + &
                   " x" + Mid(l_Value, 11)

      CASE ELSE
   END CHOOSE
END IF

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidatePhone"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValPhoneError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValPhoneError"
   END IF
END IF

RETURN l_Error
end function

public function integer fu_validatezip (ref string value, boolean display_error);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_ValidateZip
//  Description   : Check the value for a correct zip code.
//
//  Parameters    : STRING  Value  - 
//                     String containing a zip code.
//						  BOOLEAN Display_Error - 
//                     Controls whether an error message displays. 				
//
//  Return Value  : INTEGER -
//                     0 = OK.
//                     1 = Error.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER  l_Error
STRING   l_ErrorStrings[], l_Match

//------------------------------------------------------------------
//  Assume an error.
//------------------------------------------------------------------

l_Error = 1
Value   = Trim(Value)

CHOOSE CASE Len(Value)
   CASE 5
      l_Match = "^[0-9]+$"
      IF Match(Value, l_Match) THEN
         l_Error = 0
      END IF

   //---------------------------------------------------------------
   //  See if we have a Canadian Zip Code (e.g. A9A 9A9)
   //---------------------------------------------------------------

   CASE 6
      l_Match = "^[A-Za-z][0-9][A-Za-z][0-9][A-Za-z][0-9]$"
      IF Match(Value, l_Match) THEN
         l_Error = 0
         Value   = Left(Value, 3) + " " + Right(Value, 3)
         Value   = Upper(Value)
      END IF

   CASE 7
      l_Match = "^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$"
      IF Match(Value, l_Match) THEN
         l_Error = 0
         Value   = Upper(Value)
      END IF

   CASE 9
      l_Match = "^[0-9]+$"
      IF Match(Value, l_Match) THEN
         l_Error = 0
         Value   = Left(Value, 5) + "-" + Right(Value, 4)
      END IF

   CASE 10
      l_Match = "^[0-9][0-9][0-9][0-9][0-9][ -][0-9][0-9][0-9][0-9]$"
      IF Match(Value, l_Match) THEN
         l_Error = 0
         Value   = Left(Value, 5) + "-" + Right(Value, 4)
      END IF
   CASE ELSE
END CHOOSE

IF l_Error = 1 THEN
   IF display_error THEN
	   l_ErrorStrings[1] = "PowerObjects Error"
	   l_ErrorStrings[2] = OBJCA.MGR.i_ApplicationName
	   l_ErrorStrings[3] = ""
	   l_ErrorStrings[4] = ClassName()
	   l_ErrorStrings[5] = "fu_ValidateZip"
      l_ErrorStrings[6] = Value
      OBJCA.MSG.fu_DisplayMessage("ValZipError", &
                                  6, l_ErrorStrings[])
	ELSE
		OBJCA.MGR.i_Parm.Validation_ID = "ValZipError"
   END IF
END IF

RETURN l_Error
end function

public function string fu_selectcode (datawindow dw_name, string dw_column);//******************************************************************
//  PO Module     : n_OBJCA_FIELD
//  Function      : fu_SelectCode
//  Description   : Select the code associated with the description
//                  from a DataWindow column that has a code table.
//
//  Parameters    : DATAWINDOW DW_Name -
//                     DataWindow that contains the column.
//                  STRING     DW_Column -
//                     The column in the DataWindow to get the
//                     code from.
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
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING  l_ColType
STRING  l_Return

//------------------------------------------------------------------
//  Get the value for the column depending on the edit style.
//------------------------------------------------------------------

l_ColType  = UPPER(dw_name.Describe(dw_column + ".ColType"))
IF l_ColType = "?" THEN
   RETURN ""
END IF
IF Left(l_ColType, 3) = "DEC" OR &
   l_ColType = "LONG" OR &
	l_ColType = "ULONG" OR &
	l_ColType = "REAL" THEN
   l_ColType = "NUMBER"
END IF
IF Left(l_ColType, 4) = "CHAR" THEN
   l_ColType = "STRING"
END IF

CHOOSE CASE l_ColType
   CASE "NUMBER"
      l_Return = String(dw_name.GetItemNumber(dw_name.GetRow(), dw_column))
   CASE "STRING"
      l_Return = dw_name.GetItemString(dw_name.GetRow(), dw_column)
   CASE "DATE"
      l_Return = String(dw_name.GetItemDate(dw_name.GetRow(), dw_column))
   CASE "DATETIME"
      l_Return = String(dw_name.GetItemDateTime(dw_name.GetRow(), dw_column),'mm/dd/yyyy hh:mm:ss.ffffff')
   CASE "TIME"
      l_Return = String(dw_name.GetItemTime(dw_name.GetRow(), dw_column))
END CHOOSE

//------------------------------------------------------------------
//  If the code is -99999 or ^ , return an empty string from the
//  function.
//------------------------------------------------------------------

IF IsNull(l_Return) <> FALSE OR l_Return = "-99999" OR l_Return = "^" THEN
   l_Return = ""
END IF

RETURN l_Return

end function

on n_objca_field.create
call super::create
end on

on n_objca_field.destroy
call super::destroy
end on

