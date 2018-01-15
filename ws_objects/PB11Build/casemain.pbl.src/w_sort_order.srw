$PBExportHeader$w_sort_order.srw
$PBExportComments$Sort Order Response Window
forward
global type w_sort_order from w_response_std
end type
type dw_sort_fields from datawindow within w_sort_order
end type
type sle_drag from singlelineedit within w_sort_order
end type
type dw_available_fields from datawindow within w_sort_order
end type
type cb_ok from commandbutton within w_sort_order
end type
type cb_cancel from commandbutton within w_sort_order
end type
type cb_2 from commandbutton within w_sort_order
end type
type st_1 from statictext within w_sort_order
end type
end forward

global type w_sort_order from w_response_std
integer x = 955
integer y = 512
integer width = 1737
integer height = 1348
string title = "Column Sort Window"
dw_sort_fields dw_sort_fields
sle_drag sle_drag
dw_available_fields dw_available_fields
cb_ok cb_ok
cb_cancel cb_cancel
cb_2 cb_2
st_1 st_1
end type
global w_sort_order w_sort_order

type variables
LONG i_nSelectedRow, i_nSortRowCount

S_COLUMNSORT		i_sColumnSort
end variables

event dragdrop;call super::dragdrop;/****************************************************************************************

			Event:	dragdrop
			Purpose:	To detmine the class of the object droped in order to know what to do.

****************************************************************************************/

IF ClassName(DraggedObject()) = 'dw_available_fields' THEN
	dw_available_fields.SelectRow(i_nSelectedRow, FALSE)
ELSE
	dw_sort_fields.DeleteRow(i_nSelectedRow)
END IF
end event

event pc_setoptions;call super::pc_setoptions;/***************************************************************************************

			Event:	pc_setwindow
			Purpose:	To get the available sort fields from the structure passed to the 
						window and populate them in the Available Fields DataWindow.

***************************************************************************************/

INT					l_nNumOfColumns, l_nCounter

//--------------------------------------------------------------------------------------
//
//		Get the display and datawindow columns from the structure and place them in the 
//		datawindow buffer.
//
//---------------------------------------------------------------------------------------

l_nNumOfColumns = UPPERBOUND(i_sColumnSort.column_name[])

FOR l_nCounter = 1 to l_nNumOfColumns
	dw_available_fields.InsertRow(l_nCounter)
	dw_available_fields.SetItem(l_nCounter, 'display_field_name', i_sColumnSort.label_name[l_nCounter])
   dw_available_fields.SetItem(l_nCounter, 'db_field_name', i_sColumnSort.column_name[l_nCounter])
NEXT


end event

on w_sort_order.create
int iCurrent
call super::create
this.dw_sort_fields=create dw_sort_fields
this.sle_drag=create sle_drag
this.dw_available_fields=create dw_available_fields
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cb_2=create cb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sort_fields
this.Control[iCurrent+2]=this.sle_drag
this.Control[iCurrent+3]=this.dw_available_fields
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_1
end on

on w_sort_order.destroy
call super::destroy
destroy(this.dw_sort_fields)
destroy(this.sle_drag)
destroy(this.dw_available_fields)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cb_2)
destroy(this.st_1)
end on

event pc_setvariables;call super::pc_setvariables;i_sColumnSort = powerobject_parm
end event

type dw_sort_fields from datawindow within w_sort_order
event mouse_down pbm_lbuttondown
integer x = 681
integer y = 160
integer width = 1015
integer height = 928
integer taborder = 20
string dragicon = "SORTDRAG.ICO"
string dataobject = "d_sort_order"
boolean vscrollbar = true
boolean border = false
string icon = "AppIcon!"
boolean livescroll = true
end type

on mouse_down;/****************************************************************************************

		Event:	mouse_down
		Purpose:	To determine where the user is beginning the drag

***************************************************************************************/

STRING l_cTemp
INT l_cTabLoc
LONG l_nRow

//------------------------------------------------------------------------------------
//
//		Find out where the user is and get the row of the datawindow.  If valid, begin
//		the drag process.
//
//------------------------------------------------------------------------------------

l_cTemp = This.GetObjectAtPointer()
l_cTabLoc = POS(l_cTemp, "~t", 1)

IF LEFT(l_cTemp, l_cTabLoc - 1) = 'display_field_name' THEN
	i_nSelectedRow = LONG(RIGHT(l_cTemp, LEN(l_cTemp) - l_cTabloc))
	IF i_nSelectedRow > 0 THEN
		THIS.Drag(BEGIN!)
	END IF
END IF
end on

on dragdrop;/****************************************************************************************

			Event:	dragdrop
			Purpose:	To determine where we are droping and what to do about it.

***************************************************************************************/

INT l_nTabLocation
LONG l_nHeaderHeight, l_nDetailHeight, l_nInsertRow
STRING l_cDescribeHeights, l_cSortField

//------------------------------------------------------------------------------------
//
//		Get the data in the 'dropped' column.  If the column is alread in the datawindow
//		don't add it.
//
//------------------------------------------------------------------------------------

l_cSortField = dw_available_fields.GetItemString(i_nSelectedRow, 'display_field_name')
IF THIS.FIND("display_field_name = '" + l_cSortField + "'", 1, THIS.RowCount()) <> 0 THEN
	dw_available_fields.SelectRow(i_nSelectedRow, FALSE)
	RETURN
END IF

//-------------------------------------------------------------------------------------
//
//		Now that we have a row to add, we need to determine where they dropped it to
//		determine row to insert for the sort order.
//
//-------------------------------------------------------------------------------------

l_cDescribeHeights = THIS.Describe("DataWindow.Header.Height DataWindow.Detail.Height")
l_nTabLocation = POS(l_cDescribeHeights, "~n")
l_nHeaderHeight = LONG(LEFT(l_cDescribeHeights, l_nTabLocation - 1))
l_nDetailHeight = LONG(RIGHT(l_cDescribeHeights, LEN(l_cDescribeHeights) - l_nTabLocation))

IF THIS.RowCount() = 0 THEN
	l_nInsertRow = 1
ELSE
   l_nInsertRow = 	THIS.PointerY() / l_nDetailHeight 
END IF

//-------------------------------------------------------------------------------------
//
//		Now we know the row, copy the data into the row and select it.
//
//-------------------------------------------------------------------------------------

dw_available_fields.RowsCopy(i_nSelectedRow, i_nSelectedRow, PRIMARY!, THIS, l_nInsertRow, PRIMARY!)
dw_available_fields.SelectRow(i_nSelectedRow, FALSE)

end on

type sle_drag from singlelineedit within w_sort_order
boolean visible = false
integer x = 46
integer y = 308
integer width = 832
integer height = 64
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = styleraised!
end type

type dw_available_fields from datawindow within w_sort_order
event mouse_down pbm_lbuttondown
integer x = 23
integer y = 160
integer width = 645
integer height = 928
integer taborder = 10
string dragicon = "SORTDRAG.ICO"
string dataobject = "d_available_fields"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

on mouse_down;/***************************************************************************************

			Event:	mouse_down
			Purpose:	To determine where the user is beginning the drag

***************************************************************************************/

STRING l_cTemp
INT l_cTabLoc
LONG l_nRow

//------------------------------------------------------------------------------------
//
//		Find out where the user is and get the row of the datawindow
//
//------------------------------------------------------------------------------------

l_cTemp = This.GetObjectAtPointer()
l_cTabLoc = POS(l_cTemp, "~t", 1)
i_nSelectedRow = LONG(RIGHT(l_cTemp, LEN(l_cTemp) - l_cTabloc))

//------------------------------------------------------------------------------------
//
//		If the row is valid, unhighlight all rows, highlight the select row and begin the
//		drag process.
//
//-------------------------------------------------------------------------------------

IF i_nSelectedRow > 0 THEN
	SelectRow(0, FALSE)
   SelectRow(i_nSelectedRow, TRUE)
	THIS.Drag(BEGIN!)
END IF


end on

on dragdrop;/****************************************************************************************

			Event:	dragdrop
			Purpose:	To determine where we are droping and what to do about it.

***************************************************************************************/

DRAGOBJECT l_doSource

//-------------------------------------------------------------------------------------
//
//		Get the DragObject and if its class name is the same we are dropping on ourself
//		so do nothing, otherwise delete the row out of the Sorted Fields datawindow.
//
//-------------------------------------------------------------------------------------

l_doSource = DraggedObject()

IF l_doSource.ClassName() <> THIS.ClassName() THEN
	dw_sort_fields.DeleteRow(i_nSelectedRow)
END IF
end on

type cb_ok from commandbutton within w_sort_order
integer x = 1019
integer y = 1120
integer width = 320
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

on clicked;/****************************************************************************************

			Event:		clicked
			Purpose:		To get the Sort string and return it when we close the response
							window.

***************************************************************************************/

INT 				l_nCounter
LONG 				l_nRowCount
STRING			l_cSortString

//--------------------------------------------------------------------------------------
//
//			Determine the number of rows in the Sort Datawindow and build the Sort String
//
//--------------------------------------------------------------------------------------

l_nRowCOunt = dw_sort_fields.RowCount()
FOR l_nCounter = 1 to l_nRowCount
	l_cSortString = l_cSortSTring + dw_sort_fields.GetItemSTring(l_nCounter, 'db_field_name') + " " + &
		dw_sort_fields.GetItemString(l_nCounter, 'order') 
	IF l_nCounter <> l_nRowCount THEN
		l_cSortString = l_cSortSTring + ", "
	END IF
NEXT 

//---------------------------------------------------------------------------------------
//
//		Close the Window and return the Sort string
//
//---------------------------------------------------------------------------------------

CloseWithReturn(Parent, l_cSortString)
end on

type cb_cancel from commandbutton within w_sort_order
integer x = 1381
integer y = 1120
integer width = 320
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

on clicked;/***************************************************************************************

			Event:	clicked
			Purpose:	To Close the window with no Sort string

**************************************************************************************/

CloseWithReturn(Parent,'')
end on

type cb_2 from commandbutton within w_sort_order
boolean visible = false
integer x = 1257
integer y = 1096
integer width = 334
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
boolean cancel = true
end type

event clicked;FWCA.MGR.fu_OpenWindow(w_still_under_construction, 0)
end event

type st_1 from statictext within w_sort_order
integer x = 23
integer y = 20
integer width = 1147
integer height = 132
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 77971394
boolean enabled = false
string text = "Drag the desired Available Column to the Sorted Columns list."
boolean focusrectangle = false
end type

