$PBExportHeader$u_outliner_std.sru
forward
global type u_outliner_std from u_outliner
end type
end forward

global type u_outliner_std from u_outliner
string i_textfont = "Tahoma"
end type
global u_outliner_std u_outliner_std

forward prototypes
public subroutine fu_hlrowaction (long row, long key_down, integer action_type)
end prototypes

public subroutine fu_hlrowaction (long row, long key_down, integer action_type);//******************************************************************
//  PO Module     : u_Outliner_Std
//  Subroutine    : fu_HLRowAction
//  Description   : Determines what action to take on a record.
//
//  Parameters    : LONG Row - 
//                     Row number.
//                  LONG Key_Down - 
//                     Key action for multiple selection.
//                  INTEGER Action_Type -
//                     The event we are comming from.
//
//  Return Value  : (None)
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  03/16/00 C. Jackson Corrected commenting out from 4/28/99  (See below)
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_BeginRow, l_EndRow, l_PreviousRow, l_SelectedRow
LONG l_ClickedRow, l_KeyDown, l_FindRow, l_PreviousLevel

//------------------------------------------------------------------
//  Get the clicked row and see if the user held the CTRL or SHIFT
//  key down.
//------------------------------------------------------------------

l_ClickedRow = row
l_KeyDown    = key_down

IF l_ClickedRow <= 0 THEN
   RETURN
END IF

//------------------------------------------------------------------
//  Save the clicked row and determine the level of the row.
//------------------------------------------------------------------

i_DragRow     = 0
l_PreviousRow = i_ClickedRow
l_PreviousLevel = fu_HLGetRowLevel(l_PreviousRow)
i_ClickedRow  = l_ClickedRow
i_ClickedLevel= GetItemNumber(i_ClickedRow, "level")

//------------------------------------------------------------------
//  Determine if branching is to be done.
//------------------------------------------------------------------
//?? Make it expand and collapse on single click - RAP 3/31/08
//??IF i_BranchMethod = action_type THEN
   IF GetItemNumber(i_ClickedRow, "expanded") = 1 THEN
      THIS.fu_HLCollapseBranch()
   ELSE
      THIS.fu_HLExpandLevel()
   END IF
//??END IF
         
//------------------------------------------------------------------
//  Determine if this record may be selected.
//------------------------------------------------------------------

IF i_SelectMethod = action_type THEN

   i_SelectedRow   = i_ClickedRow
   i_SelectedLevel = i_ClickedLevel

   //---------------------------------------------------------------
   //  If drag and drop is allowed, put the outliner in dragdrop
   //  mode.
   //---------------------------------------------------------------

   IF i_AllowDragDrop THEN
      IF i_DragOnLastLevel AND i_ClickedLevel <> i_MaxLevels THEN
      ELSE
         DragIcon    = "dragrows.ico"
         i_DragRow   = i_ClickedRow
			i_DragLevel = i_ClickedLevel
         Drag(Begin!)
      END IF
   END IF

   //---------------------------------------------------------------
   //  Outliner allows multiple record selection and the CTRL key 
   //  was pressed.
	//
	//  WBC - 4/28/99   Removed multiselect check
	//  CAJ - 3/16/00   Undid this bit of code.  Removed comments from 
	//                  next 2 lines, they are needed, and commented
	//                  out the following.
   //---------------------------------------------------------------

   IF l_KeyDown = 9 AND i_MultiSelect AND &
      i_LastSelectedLevel = i_ClickedLevel THEN 

//   IF l_KeyDown = 9 AND i_LastSelectedLevel = i_ClickedLevel THEN   // Comment out new code from WBC (4/28/99)
                                                                      // It removed needed functionality! CAJ 3/16/00

      IF GetItemNumber(i_ClickedRow, "selected") = 1 THEN
         SetItem(i_ClickedRow, "selected", 0)
         i_AnchorRow = 0
      ELSE
         SetItem(i_ClickedRow, "selected", 1)
         i_AnchorRow = i_ClickedRow
      END IF

   //---------------------------------------------------------------
   //  Outliner allows multiple record selection and the SHIFT key 
   //  was pressed.
   //---------------------------------------------------------------

   ELSEIF l_KeyDown = 5 AND i_MultiSelect AND &
      i_LastSelectedLevel = i_ClickedLevel THEN

      IF i_AnchorRow = 0 THEN
         i_AnchorRow = i_ClickedRow  
      END IF

      IF i_ClickedRow >= i_AnchorRow THEN
         l_BeginRow = i_AnchorRow
         l_EndRow = i_ClickedRow
      ELSE
         l_EndRow = i_AnchorRow
         l_BeginRow = i_ClickedRow
      END IF
		
      l_FindRow = l_BeginRow - 1
      DO
	      l_BeginRow = l_FindRow + 1
	      l_FindRow = Find("level = " + String(i_ClickedLevel), &
			                 l_BeginRow, l_EndRow)
	      IF l_FindRow > 0 THEN
				IF GetItemNumber(l_FindRow, "heightline") > 0 THEN
		         SetItem(l_FindRow, "selected", 1)
				END IF
	      END IF
      LOOP WHILE l_FindRow > 0 AND l_FindRow < l_EndRow

   //---------------------------------------------------------------
   //  A single record was selected.
   //---------------------------------------------------------------

   ELSE

      IF i_ClickedRow <> l_PreviousRow OR &
         GetItemNumber(i_ClickedRow, "selected") = 0 THEN

			//---------------------------------------------------------
			//  WBC - 4/28/99  If a right click is done do not let it
			//                 select a category.
			//---------------------------------------------------------

/*SL*/   IF action_type <> c_RightClick THEN
				i_LastSelectedLevel = i_ClickedLevel
				l_BeginRow = 1
				l_EndRow = RowCount()
				DO
					l_SelectedRow = Find("selected = 1", &
												l_BeginRow, l_EndRow)
					IF l_SelectedRow > 0 THEN
						SetItem(l_SelectedRow, "selected", 0)
						l_BeginRow = l_BeginRow + 1
					END IF
				LOOP UNTIL l_SelectedRow <= 0
	
				i_AnchorRow = i_ClickedRow
				SetItem(i_ClickedRow, "selected", 1)
/*SL*/	END IF
      ELSE
         IF l_KeyDown = 9 AND NOT i_MultiSelect THEN
            i_AnchorRow = 0
            SetItem(i_ClickedRow, "selected", 0)
            i_SelectedRow = 0
            i_SelectedLevel = 0
         END IF
      END IF
   END IF

   //---------------------------------------------------------------
   //  Trigger the po_SelectedRow event to allow the developer to
   //  code something.
   //---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//  WBC - 4/28/99  If a right click is done do not let it
	//                 select a category.
	//---------------------------------------------------------------

/*SL*/ IF action_type <> c_RightClick THEN
		i_RowError = 0
		
		Event po_SelectedRow(i_SelectedRow, i_SelectedLevel, i_MaxLevels)
	
		IF i_RowError = -1 THEN
			RETURN
		END IF
/*SL*/ 	END IF
END IF

//------------------------------------------------------------------
//  Determine if a drill down must be done.
//
//  WBC - 4/28/99  Let validation and pickedrow fire on any click
//------------------------------------------------------------------

/*SL*/ //IF i_DrillDownMethod = action_type THEN

/*SL*/ //   IF i_DrillOnLastLevel THEN
/*SL*/ //      IF i_ClickedLevel <> i_MaxLevels THEN
/*SL*/ //         RETURN
/*SL*/ //      END IF
/*SL*/ //   END IF

   //---------------------------------------------------------------
   //  Allow the developer to validate the currently selected row.
   //---------------------------------------------------------------
	
	//---------------------------------------------------------------
	//  WBC - 4/28/99  If a right click is done do not let it
	//                 select a category.
	//---------------------------------------------------------------

/*SL*/ IF action_type <> c_RightClick THEN

	i_RowError = 0
	
	Event po_ValidateRow(i_ClickedRow, i_ClickedLevel, &
	                     l_PreviousRow, l_PreviousLevel, &
								i_MaxLevels)

   IF i_RowError = -1 THEN
      RETURN
   END IF

   //---------------------------------------------------------------
   //  Trigger the po_PickedRow event to allow the developer to
   //  code something.
   //---------------------------------------------------------------

   Event po_PickedRow(i_ClickedRow, i_ClickedLevel, i_MaxLevels)

/*SL*/  END IF
/*SL*/  //END IF

end subroutine

on u_outliner_std.create
call super::create
end on

on u_outliner_std.destroy
call super::destroy
end on

