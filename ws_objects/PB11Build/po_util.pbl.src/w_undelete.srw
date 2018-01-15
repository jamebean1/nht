$PBExportHeader$w_undelete.srw
$PBExportComments$Window to undelete DataWindow records
forward
global type w_undelete from Window
end type
type dw_undelete from datawindow within w_undelete
end type
type cb_cancel from commandbutton within w_undelete
end type
type cb_ok from commandbutton within w_undelete
end type
end forward

shared variables

end variables

global type w_undelete from Window
int X=485
int Y=620
int Width=1490
int Height=820
boolean TitleBar=true
string Title="Undelete Records"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
dw_undelete dw_undelete
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_undelete w_undelete

type variables
DATAWINDOW	i_DataWindow

LONG		i_CurrentRow
LONG		i_AnchorRow

end variables

forward prototypes
public subroutine fw_settaborder ()
end prototypes

public subroutine fw_settaborder ();//******************************************************************
//  PO Module     : w_Undelete
//  Function      : fw_SetTabOrder
//  Description   : Sets the tab order for all the DW's to 0.
//
//  Parameters    : None
//
//  Return Value  : None
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

INTEGER	l_ColCount,l_idx
STRING	l_ColSynthax

l_Colcount = Integer(dw_undelete.Object.DataWindow.Column.Count)

FOR l_idx=1 TO l_Colcount
	l_ColSynthax = "#" + String(l_idx) + ".TabSequence = 0"
	dw_undelete.Modify(l_ColSynthax)	
NEXT
end subroutine

event open;//******************************************************************
//  PO Module     : w_Undelete
//  Event         : Open
//  Description   : Allows processing before window becomes visible.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Space, l_DeletedCount

//------------------------------------------------------------------
//  Set the DataWindow attributes.
//------------------------------------------------------------------

i_DataWindow = OBJCA.WIN.i_Parm.DW_Name

dw_undelete.DataObject  = i_DataWindow.DataObject
dw_undelete.TitleBar    = i_DataWindow.TitleBar
dw_undelete.Title       = i_DataWindow.Title
dw_undelete.Border      = i_DataWindow.Border
dw_undelete.BorderStyle = i_DataWindow.BorderStyle
dw_undelete.VScrollBar  = i_DataWindow.VScrollBar
dw_undelete.HScrollBar  = i_DataWindow.HScrollBar
dw_undelete.Height      = i_DataWindow.Height
dw_undelete.Width       = i_DataWindow.Width
dw_undelete.Reset()

//------------------------------------------------------------------
//  Resize the window and command buttons.
//------------------------------------------------------------------

Width       = dw_undelete.Width + (2 * dw_undelete.X) + 40
Height      = dw_undelete.Height + cb_ok.Height + (3 * dw_undelete.Y) + 100
BackColor   = OBJCA.WIN.i_WindowColor

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   dw_undelete.BorderStyle = StyleShadowBox!
END IF

l_Space     = (WorkSpaceWidth() - (cb_ok.Width + cb_cancel.Width)) / 3
cb_ok.X     = l_Space
cb_ok.Y     = dw_undelete.Height + (2 * dw_undelete.Y)
cb_ok.FaceName = OBJCA.WIN.i_WindowTextFont
cb_ok.TextSize = OBJCA.WIN.i_WindowTextSize

cb_cancel.X = cb_ok.Width + (2 * l_Space)
cb_cancel.Y = dw_undelete.Height + (2 * dw_undelete.Y)
cb_cancel.FaceName = OBJCA.WIN.i_WindowTextFont
cb_cancel.TextSize = OBJCA.WIN.i_WindowTextSize

//------------------------------------------------------------------
//  Move the deleted records to this DataWindow.
//------------------------------------------------------------------

l_DeletedCount = i_DataWindow.DeletedCount()
i_DataWindow.RowsCopy(1, l_DeletedCount, Delete!, &
                      dw_undelete, 1, Primary!)

//------------------------------------------------------------------
//  Make sure the tab sequence of all columns is zero.
//------------------------------------------------------------------
fw_SetTabOrder()

//------------------------------------------------------------------
//  Position the window in the center.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)
dw_undelete.SetFocus()
end event

on w_undelete.create
this.dw_undelete=create dw_undelete
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={ this.dw_undelete,&
this.cb_cancel,&
this.cb_ok}
end on

on w_undelete.destroy
destroy(this.dw_undelete)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type dw_undelete from datawindow within w_undelete
int X=50
int Y=40
int Width=1362
int Height=504
int TabOrder=10
boolean LiveScroll=true
end type

event clicked;//******************************************************************
//  PO Module     : w_Undelete.dw_Undelete
//  Event         : Clicked
//  Description   : Select records to undelete.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

LONG   l_Idx, l_BeginRow, l_EndRow, l_PreviousRow
LONG   l_ClickedRow, l_KeyDown
BOOLEAN	l_Shift, l_Ctrl

l_Shift = FALSE
l_Ctrl = FALSE

IF KeyDown(KeyShift!) THEN
	l_Shift = TRUE
ELSEIF KeyDown(KeyControl!) THEN
	l_Ctrl = TRUE
END IF

l_ClickedRow = row

IF l_ClickedRow <= 0 THEN
   RETURN
END IF

//------------------------------------------------------------------
//  CTRL pressed for multiple record selection.
//------------------------------------------------------------------

IF l_Ctrl THEN

   l_PreviousRow = i_CurrentRow
   i_CurrentRow = l_ClickedRow

	IF IsSelected(i_CurrentRow) THEN
      i_AnchorRow = 0
      SelectRow(i_CurrentRow, FALSE)
   ELSE
      i_AnchorRow = i_CurrentRow
      SelectRow(i_CurrentRow, TRUE)
   END IF
   SetRow(i_CurrentRow)

//------------------------------------------------------------------
//  SHIFT pressed for multiple record selection.
//------------------------------------------------------------------

ELSEIF l_Shift THEN

   l_PreviousRow = i_CurrentRow
   i_CurrentRow = l_ClickedRow

   IF i_AnchorRow = 0 THEN
      i_AnchorRow = l_PreviousRow
   END IF

   IF i_CurrentRow >= i_AnchorRow THEN
      l_BeginRow = i_AnchorRow
      l_EndRow = i_CurrentRow
   ELSE
      l_EndRow = i_AnchorRow
      l_BeginRow = i_CurrentRow
   END IF

   FOR l_Idx = l_BeginRow TO l_EndRow
      SelectRow(l_Idx, TRUE)
   NEXT
   SetRow(l_EndRow)

//------------------------------------------------------------------
//  Single record selection.
//------------------------------------------------------------------

ELSE

   i_CurrentRow = l_ClickedRow
   i_AnchorRow = 0
   SelectRow(0, FALSE)
   SelectRow(i_CurrentRow, TRUE)
   SetRow(i_CurrentRow)

END IF
end event

type cb_cancel from commandbutton within w_undelete
int X=855
int Y=584
int Width=329
int Height=92
int TabOrder=30
string Text=" Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Undelete.cb_Cancel
//  Event         : Clicked
//  Description   : Cancel any record selections
//                  and close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

Close(PARENT)

end event

type cb_ok from commandbutton within w_undelete
int X=283
int Y=584
int Width=329
int Height=92
int TabOrder=20
string Text=" OK"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Undelete.cb_Ok
//  Event         : Clicked
//  Description   : If records are selected, move them from the
//                  Delete! buffer to the Primary! buffer and 
//                  close the window.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Idx, l_Rows, l_ScrollToRow, l_Return
BOOLEAN l_FirstMove

SetPointer(HourGlass!)

i_DataWindow.SetReDraw(FALSE)

l_Rows = dw_undelete.RowCount()
l_FirstMove = TRUE
FOR l_Idx = l_Rows To 1 STEP -1
   IF dw_undelete.IsSelected(l_Idx) THEN
      l_Return = i_DataWindow.RowsMove(l_Idx, l_Idx, Delete!, &
                            i_DataWindow, 1, Primary!)
      IF l_FirstMove THEN
         l_ScrollToRow = l_Idx
         l_FirstMove   = FALSE
      END IF
   END IF
NEXT

i_DataWindow.SetReDraw(TRUE)

Close(PARENT)
end event

