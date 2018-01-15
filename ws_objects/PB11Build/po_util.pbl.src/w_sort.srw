$PBExportHeader$w_sort.srw
$PBExportComments$Window to sort DataWindow records
forward
global type w_sort from Window
end type
type st_direction from statictext within w_sort
end type
type st_sorted from statictext within w_sort
end type
type st_source from statictext within w_sort
end type
type dw_sorted from datawindow within w_sort
end type
type dw_source from datawindow within w_sort
end type
type cb_cancel from commandbutton within w_sort
end type
type cb_ok from commandbutton within w_sort
end type
end forward

shared variables

end variables

global type w_sort from Window
int X=485
int Y=621
int Width=1710
int Height=909
boolean TitleBar=true
string Title="Specify Sort Columns"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
st_direction st_direction
st_sorted st_sorted
st_source st_source
dw_sorted dw_sorted
dw_source dw_source
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_sort w_sort

type variables
DATAWINDOW	i_DataWindow
DATAWINDOW	i_DragDW

INTEGER	i_DragRow


end variables

event open;//******************************************************************
//  PO Module     : w_Sort
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

INTEGER l_Idx, l_Jdx, l_NumSort, l_Pos, l_ColumnCnt, l_Row
STRING  l_SortString, l_Sort, l_name, l_SortName[], l_SortDirection[]
BOOLEAN l_Found

i_DataWindow = OBJCA.WIN.i_Parm.DW_Name

//------------------------------------------------------------------
//  Get the sort string, if any, from the DataWindow.
//------------------------------------------------------------------

l_NumSort = 0
l_SortString = i_DataWindow.Describe("datawindow.table.sort")
IF Len(l_SortString) > 0 THEN
	DO
		l_Pos = Pos(l_SortString, ",")
		IF l_Pos > 0 THEN
			l_NumSort = l_NumSort + 1
			l_Sort = TRIM(MID(l_SortString, 1, l_Pos - 1))
			l_SortString = TRIM(MID(l_SortString, l_Pos + 1))
		ELSE
			l_NumSort = l_NumSort + 1
			l_Sort = l_SortString
			l_SortString = ""
		END IF

		l_SortDirection[l_NumSort] = Upper(Right(l_Sort, 1))
		l_Sort = TRIM(Replace(l_Sort, Len(l_Sort), 1, ""))
		IF Pos(l_Sort, "#") = 0 THEN
			IF IsNumber(l_Sort) THEN
  	       	l_SortName[l_NumSort] = i_DataWindow.Describe("#" + l_Sort + ".name")
			ELSE
				l_SortName[l_NumSort] = l_Sort
			END IF
		ELSE
   	   l_SortName[l_NumSort] = i_DataWindow.Describe(l_Sort + ".name")
		END IF
	LOOP UNTIL l_SortString = ""
END IF
	
//------------------------------------------------------------------
//  Get the columns from the DataWindow.  If a column is already set
//  as sorted, move the row to the sorted DataWindow.
//------------------------------------------------------------------

l_ColumnCnt = Integer(i_DataWindow.Describe("datawindow.column.count"))

FOR l_Idx = 1 TO l_ColumnCnt
	l_Found = FALSE
	l_Name = i_DataWindow.Describe("#" + String(l_Idx) + ".name")
	
	FOR l_Jdx = 1 TO l_NumSort
		IF l_Name = l_SortName[l_Jdx] THEN   
			l_Sort = l_SortDirection[l_Jdx]
			l_Found = TRUE
			EXIT
		END IF
	NEXT

	IF l_Found THEN
		l_Row  = dw_sorted.InsertRow(0)
		dw_sorted.SetItem(l_Row, "sort_column", l_Name)
		dw_sorted.SetItem(l_Row, "sort_order", l_Sort)
	ELSE
		l_Row  = dw_source.InsertRow(0)
		dw_source.SetItem(l_Row, "source_column", l_Name)
	END IF
NEXT

//------------------------------------------------------------------
//  Set the window attributes.
//------------------------------------------------------------------

BackColor   = OBJCA.WIN.i_WindowColor

IF OBJCA.WIN.i_WindowColor <> OBJCA.WIN.c_Gray THEN
   dw_source.BorderStyle = StyleShadowBox!
	dw_sorted.BorderStyle = StyleShadowBox!
END IF

st_source.FaceName = OBJCA.WIN.i_WindowTextFont
st_source.TextSize = OBJCA.WIN.i_WindowTextSize
st_source.TextColor = OBJCA.WIN.i_WindowTextColor
st_source.BackColor = OBJCA.WIN.i_WindowColor

st_sorted.FaceName = OBJCA.WIN.i_WindowTextFont
st_sorted.TextSize = OBJCA.WIN.i_WindowTextSize
st_sorted.TextColor = OBJCA.WIN.i_WindowTextColor
st_sorted.BackColor = OBJCA.WIN.i_WindowColor

st_direction.FaceName = OBJCA.WIN.i_WindowTextFont
st_direction.TextSize = OBJCA.WIN.i_WindowTextSize
st_direction.TextColor = OBJCA.WIN.i_WindowTextColor
st_direction.BackColor = OBJCA.WIN.i_WindowColor

cb_ok.FaceName = OBJCA.WIN.i_WindowTextFont
cb_ok.TextSize = OBJCA.WIN.i_WindowTextSize

cb_cancel.FaceName = OBJCA.WIN.i_WindowTextFont
cb_cancel.TextSize = OBJCA.WIN.i_WindowTextSize

dw_source.SetRowFocusIndicator(Off!)
dw_sorted.SetRowFocusIndicator(Off!)

//------------------------------------------------------------------
//  Position the window in the center.
//------------------------------------------------------------------

OBJCA.MGR.fu_CenterWindow(THIS)

end event

on w_sort.create
this.st_direction=create st_direction
this.st_sorted=create st_sorted
this.st_source=create st_source
this.dw_sorted=create dw_sorted
this.dw_source=create dw_source
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={ this.st_direction,&
this.st_sorted,&
this.st_source,&
this.dw_sorted,&
this.dw_source,&
this.cb_cancel,&
this.cb_ok}
end on

on w_sort.destroy
destroy(this.st_direction)
destroy(this.st_sorted)
destroy(this.st_source)
destroy(this.dw_sorted)
destroy(this.dw_source)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type st_direction from statictext within w_sort
int X=1335
int Y=45
int Width=289
int Height=65
boolean Enabled=false
string Text="Ascending"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_sorted from statictext within w_sort
int X=732
int Y=45
int Width=458
int Height=65
boolean Enabled=false
string Text="Sort Columns:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_source from statictext within w_sort
int X=65
int Y=45
int Width=458
int Height=65
boolean Enabled=false
string Text="Source Columns:"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_sorted from datawindow within w_sort
int X=718
int Y=109
int Width=906
int Height=505
int TabOrder=20
string DragIcon="DragRow.ico"
string DataObject="d_sort_sorted"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean LiveScroll=true
string Icon="dragrow.ico"
end type

event clicked;//******************************************************************
//  PO Module     : w_Sort.dw_Sorted
//  Event         : Clicked
//  Description   : Select records to drag.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsNull(DWO) <> FALSE THEN RETURN

IF DWO.Name = "sort_column" THEN
	i_DragRow = row
	i_DragDW = THIS
	THIS.Drag(Begin!)
END IF

end event

event dragdrop;//******************************************************************
//  PO Module     : w_Sort.dw_Sorted
//  Event         : DragDrop
//  Description   : Drops the record.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_Row

i_DragDW.Drag(End!)

//------------------------------------------------------------------
//  Move the record to this DataWindow and remove it from the
//  dragged DataWindow.
//------------------------------------------------------------------

SetReDraw(FALSE)
IF i_DragDW = THIS THEN
	IF row = 0 THEN row = RowCount() + 1
	RowsMove(i_DragRow, i_DragRow, Primary!, THIS, row, Primary!)
ELSE
	l_Row = InsertRow(row)
   SetItem(l_Row, "sort_column", dw_source.GetItemString(i_DragRow, "source_column"))
   dw_source.DeleteRow(i_DragRow)
END IF
i_DragRow = 0
SetReDraw(TRUE)

end event

type dw_source from datawindow within w_sort
int X=55
int Y=109
int Width=613
int Height=505
int TabOrder=10
string DragIcon="Dragrow.ico"
string DataObject="d_sort_source"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean LiveScroll=true
string Icon="dragrow.ico"
end type

event clicked;//******************************************************************
//  PO Module     : w_Sort.dw_Source
//  Event         : Clicked
//  Description   : Select records to drag.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF IsNull(DWO) <> FALSE THEN RETURN

IF DWO.Name = "source_column" THEN
	i_DragRow = row
	i_DragDW = THIS
	THIS.Drag(Begin!)
END IF

end event

event dragdrop;//******************************************************************
//  PO Module     : w_Sort.dw_Source
//  Event         : DragDrop
//  Description   : Drops the record.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER    l_Row

//------------------------------------------------------------------
//  Make sure the dragged record is not dropped on itself.
//------------------------------------------------------------------

IF i_DragDW = THIS THEN
	THIS.Drag(Cancel!)
	i_DragRow = 0
	RETURN
END IF

dw_sorted.Drag(End!)

//------------------------------------------------------------------
//  Move the record to this DataWindow and remove it from the
//  dragged DataWindow.
//------------------------------------------------------------------

SetReDraw(FALSE)
l_Row = InsertRow(0)
SetItem(l_Row, "source_column", dw_sorted.GetItemString(i_DragRow, "sort_column"))
Sort()
dw_sorted.DeleteRow(i_DragRow)
i_DragRow = 0
SetReDraw(TRUE)

end event

type cb_cancel from commandbutton within w_sort
int X=933
int Y=673
int Width=330
int Height=93
int TabOrder=40
string Text=" Cancel"
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Sort.cb_Cancel
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

CloseWithReturn(PARENT, -1)

end event

type cb_ok from commandbutton within w_sort
int X=417
int Y=673
int Width=330
int Height=93
int TabOrder=30
string Text=" OK"
boolean Default=true
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//******************************************************************
//  PO Module     : w_Sort.cb_OK
//  Event         : Clicked
//  Description   : If sort records are selected, set the sort
//                  criteria for the DataWindow and sort it.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Rows
STRING  l_SortString, l_Comma

SetPointer(HourGlass!)

i_DataWindow.SetReDraw(FALSE)

l_Rows = dw_sorted.RowCount()
l_SortString = ""
l_Comma = ""
FOR l_Idx = 1 TO l_Rows
	l_SortString = l_SortString + l_Comma + &
                  dw_sorted.GetItemString(l_Idx, "sort_column") + &
                   " " + dw_sorted.GetItemString(l_Idx, "sort_order")
	l_Comma = ","
NEXT

i_DataWindow.SetSort(l_SortString)
i_DataWindow.Sort()

i_DataWindow.SetReDraw(TRUE)

CloseWithReturn(PARENT, 0)
end event

