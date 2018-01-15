$PBExportHeader$u_case_housekeeping.sru
$PBExportComments$Case Housekeeping User Object
forward
global type u_case_housekeeping from u_container_std
end type
type cb_2 from commandbutton within u_case_housekeeping
end type
type cb_1 from commandbutton within u_case_housekeeping
end type
type st_5 from statictext within u_case_housekeeping
end type
type em_2 from editmask within u_case_housekeeping
end type
type st_4 from statictext within u_case_housekeeping
end type
type lb_1 from u_lb_search within u_case_housekeeping
end type
type em_1 from editmask within u_case_housekeeping
end type
type gb_1 from groupbox within u_case_housekeeping
end type
type gb_2 from groupbox within u_case_housekeeping
end type
type dw_outliner from u_outliner_std within u_case_housekeeping
end type
type gb_3 from groupbox within u_case_housekeeping
end type
end forward

global type u_case_housekeeping from u_container_std
integer width = 3461
integer height = 912
long backcolor = 79748288
cb_2 cb_2
cb_1 cb_1
st_5 st_5
em_2 em_2
st_4 st_4
lb_1 lb_1
em_1 em_1
gb_1 gb_1
gb_2 gb_2
dw_outliner dw_outliner
gb_3 gb_3
end type
global u_case_housekeeping u_case_housekeeping

type variables
W_CASE_HOUSEKEEPING i_wParentWindow
end variables

forward prototypes
public function integer fu_getallchildkeys (long selectedrow, ref string keylist[])
end prototypes

public function integer fu_getallchildkeys (long selectedrow, ref string keylist[]);/*****************************************************************************************
   Function:   fu_GetAllChildKeys
   Purpose:    Retrieve the keys for all child records of the specified entry.
   Parameters: LONG		selectedrow - The row whose children are being sought.
					STRING	keylist[] - the array of child keys. (BY REFERENCE)
   Returns:    INTEGER	 0 - success
								-1 - failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/15/02 M. Caruso    Created.
*****************************************************************************************/

INTEGER		l_nLevel
LONG			l_nRowCount, l_nRow, l_nIndex
STRING		l_cSQLSelect, l_cSyntax, l_cValue, l_cTmpKeys[], l_cError
DATASTORE	l_dsKeyList

dw_outliner.fu_HLGetRowKey (selectedrow, l_cTmpKeys[])
l_nLevel = dw_outliner.fu_HLGetRowLevel (selectedrow)
l_cValue = l_cTmpKeys[l_nLevel]

// build the select statement to retreive all of the child records
IF l_nLevel = 1 THEN
	l_cSQLSelect = "SELECT category_id, category_lineage " + &
						"FROM cusfocus.categories " + &
						"WHERE case_type = '" + l_cValue + "' " + &
						"ORDER BY category_lineage"
ELSE
	l_cSQLSelect = "SELECT category_id, category_lineage " + &
						"FROM cusfocus.categories " + &
						"WHERE category_lineage like (" + &
							"SELECT category_lineage+'%' " + &
							"FROM cusfocus.categories " + &
							"WHERE category_id = '" + l_cValue + "')" + &
						"ORDER BY category_lineage"
END IF

l_cSyntax = SQLCA.SyntaxFromSQL (l_cSQLSelect, '', l_cError)

IF Len (l_cError) > 0 THEN
	RETURN -1
ELSE
	
	// Generate new DataStore
	l_dsKeyList = CREATE DATASTORE
	l_dsKeyList.Create (l_cSyntax, l_cError)
	IF Len (l_cError) > 0 THEN
		RETURN -1
	END IF
	
END IF

l_dsKeyList.SetTransObject (SQLCA)
l_nRowCount = l_dsKeyList.Retrieve ()
FOR l_nRow = 1 TO l_nRowCount
	
	l_nIndex = UpperBound (keylist[]) + 1
	keylist[l_nIndex] = l_dsKeyList.GetItemString (l_nRow, 'category_id')
	
NEXT

// remove the datastore from memory
IF IsValid (l_dsKeyList) THEN
	DESTROY l_dsKeyList
END IF

RETURN 0
end function

on u_case_housekeeping.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_5=create st_5
this.em_2=create em_2
this.st_4=create st_4
this.lb_1=create lb_1
this.em_1=create em_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_outliner=create dw_outliner
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.em_2
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.lb_1
this.Control[iCurrent+7]=this.em_1
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.dw_outliner
this.Control[iCurrent+11]=this.gb_3
end on

on u_case_housekeeping.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_5)
destroy(this.em_2)
destroy(this.st_4)
destroy(this.lb_1)
destroy(this.em_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_outliner)
destroy(this.gb_3)
end on

type cb_2 from commandbutton within u_case_housekeeping
integer x = 1554
integer y = 208
integer width = 114
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;/***************************************************************************************

		Event:	clicked
		Purpose:	Please see PB documentation for this event
**************************************************************************************/
String l_cParm, l_cX, l_cY, l_cValue, l_cInitialDate

l_cX = String( ( THIS.X + THIS.Width + w_case_housekeeping.X - 5 ) )
l_cY = String( ( THIS.Y + THIS.Height + w_case_housekeeping.Y + PARENT.Y ) )

l_cInitialDate = em_1.Text

IF l_cInitialDate = "" OR IsNull( l_cInitialDate ) OR Year( Date( l_cInitialDate ) ) < 1753 OR &
   l_cInitialDate = "00/00/0000" THEN
	l_cInitialDate = String( w_case_housekeeping.fw_GetTimestamp( ), "mm/dd/yyyy" )
END IF	

l_cParm = ( l_cInitialDate+"&"+l_cX+"&"+l_cY )

FWCA.MGR.fu_OpenWindow( w_calendar, l_cParm )

// Get the date passed back
l_cValue = Message.StringParm

// If it's a date, update the field.
IF IsDate( l_cValue ) THEN
	em_1.Text = l_cValue
ELSE
	em_1.Text = ""
END IF
end event

type cb_1 from commandbutton within u_case_housekeeping
integer x = 1554
integer y = 100
integer width = 114
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;/***************************************************************************************

		Event:	clicked
		Purpose:	Please see PB documentation for this event
**************************************************************************************/
String l_cParm, l_cX, l_cY, l_cValue, l_cInitialDate

l_cX = String( ( THIS.X + THIS.Width + w_case_housekeeping.X - 5 ) )
l_cY = String( ( THIS.Y + THIS.Height + w_case_housekeeping.Y + PARENT.Y ) )

l_cInitialDate = em_2.Text

IF l_cInitialDate = "" OR IsNull( l_cInitialDate ) OR Year( Date( l_cInitialDate ) ) < 1753 OR &
   l_cInitialDate = "00/00/0000" THEN
	l_cInitialDate = String( w_case_housekeeping.fw_GetTimestamp( ), "mm/dd/yyyy" )
END IF	

l_cParm = ( l_cInitialDate+"&"+l_cX+"&"+l_cY )

FWCA.MGR.fu_OpenWindow( w_calendar, l_cParm )

// Get the date passed back
l_cValue = Message.StringParm

// If it's a date, update the field.
IF IsDate( l_cValue ) THEN
	em_2.Text = l_cValue
ELSE
	em_2.Text = ""
END IF
end event

type st_5 from statictext within u_case_housekeeping
integer x = 841
integer y = 220
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "To:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_2 from editmask within u_case_housekeeping
event ue_invalidate pbm_custom75
integer x = 1029
integer y = 100
integer width = 521
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

event ue_invalidate;/***************************************************************************************

		Event:	ue_invalidate
		Purpose:	To determine if the user did not enter a date or if they did not enter
					valid date.

**************************************************************************************/

IF Text = '' THEN
	Messagebox(gs_AppName, 'Please enter a From Date.', StopSign!, OK!)
ELSE
	MessageBox(gs_AppName, 'Please enter a valid From Date', StopSign!, OK!)
END IF
SetFocus()

end event

type st_4 from statictext within u_case_housekeeping
integer x = 846
integer y = 112
integer width = 178
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "From:"
alignment alignment = right!
boolean focusrectangle = false
end type

type lb_1 from u_lb_search within u_case_housekeeping
integer x = 87
integer y = 72
integer width = 530
integer height = 416
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
string facename = "Tahoma"
end type

type em_1 from editmask within u_case_housekeeping
event ue_invalidate pbm_custom75
integer x = 1029
integer y = 208
integer width = 521
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

event ue_invalidate;/***************************************************************************************

		Event:	ue_invalidate
		Purpose:	To determine if the user did not enter a date or if they did not enter
					valid date.

**************************************************************************************/

IF Text = '' THEN
	Messagebox(gs_AppName, 'Please enter a To Date.', StopSign!, OK!)
ELSE
	MessageBox(gs_AppName, 'Please enter a valid To Date', StopSign!, OK!)
END IF
SetFocus()

end event

event constructor;/***************************************************************************************

		Event:	Constructor
		Purpose:	Please see PB documentation for this event
**************************************************************************************/

//Set to default to today's date
THIS.Text = String( w_case_housekeeping.fw_GetTimeStamp( ), "mm/dd/yyyy" )
end event

type gb_1 from groupbox within u_case_housekeeping
integer x = 55
integer y = 8
integer width = 599
integer height = 512
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Case Status"
end type

type gb_2 from groupbox within u_case_housekeeping
integer x = 823
integer y = 8
integer width = 887
integer height = 328
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Opened Date"
end type

type dw_outliner from u_outliner_std within u_case_housekeeping
event ue_postbringtotop ( )
integer x = 1915
integer y = 68
integer width = 1454
integer height = 796
integer taborder = 60
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
end type

event ue_postbringtotop;/***************************************************************************************

		Event:	ue_postbringtotop
		Purpose:	Bring this object to the top after processing has completed
**************************************************************************************/
THIS.BringToTop = TRUE
end event

on po_rdoubleclicked;//
//	Override and comment this out.  We do not want r-button cabality.
//	LAW 10/9/95
end on

event rowfocuschanged;call super::rowfocuschanged;//STRING l_cKeyValue[]
//LONG   l_nReturnRow, l_nSearchRow
//INT    l_nUpperBound
//
//IF KeyDown(KeyUpArrow!) THEN
//	IF fu_HLGetRowLevel(i_FocusRow) = i_nMaxLevels THEN
//		
//      fu_HLClearSelectedRows()
//		fu_HLSetSelectedRow(i_FocusRow)
//
//		l_nReturnRow = fu_HLGetROwKey(i_FocusRow, l_cKeyValue[])
//		
//		l_nUpperBound = UpperBound(l_cKeyValue[])
//
//		i_cSelectedCategory = l_cKeyValue[l_nUpperBound]
//	
//		dw_category_description.Retrieve(i_cSelectedCategory)
//
//		l_nSearchRow = FIND("key1 ='" + l_cKeyValue[1] + "'", 1, RowCount())
//
////		i_cRootCategoryName = GetItemString(l_nSearchRow, 'stringdesc')
//
////		dw_case_detail.SetItem(1, 'category_id', i_cSelectedCategory)
////		dw_case_detail.SetItem(1, 'root_category_name', i_cRootCategoryName)
//
//	END IF
//
//ELSEIF KeyDown(KeyDownArrow!) THEN
//
//	IF fu_HLGetRowLevel(i_FocusRow) = i_nMaxLevels THEN
//
//      fu_HLClearSelectedRows()
//		fu_HLSetSelectedRow(i_focusRow)
//
//		l_nReturnRow = fu_HLGetROwKey(i_FocusRow, l_cKeyValue[])
//		
//		l_nUpperBound = UpperBound(l_cKeyValue[])
//
//		i_cSelectedCategory = l_cKeyValue[l_nUpperBound]
//	
//		dw_category_description.Retrieve(i_cSelectedCategory)
//
//		l_nSearchRow = FIND("key1 ='" + l_cKeyValue[1] + "'", 1, RowCount())
//
//		i_cRootCategoryName = GetItemString(l_nSearchRow, 'stringdesc')
//
//		dw_case_detail.SetItem(1, 'category_id', i_cSelectedCategory)
//		dw_case_detail.SetItem(1, 'root_category_name', i_cRootCategoryName)
//
//	END IF
//
//END IF
end event

on rbuttondown;//
//		Overide ancestor and comment out.  We do not want rbutton capability.
//		LAW 10/9/95.
end on

event constructor;call super::constructor;/***************************************************************************************

		Event:	Constructor
		Purpose:	Please see PB documentation for this event
**************************************************************************************/

//Bring this object out in front of the group box after processing has finished
THIS.Event Post ue_postbringtotop( )
end event

type gb_3 from groupbox within u_case_housekeeping
integer x = 1879
integer y = 8
integer width = 1527
integer height = 884
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Excluded Category"
end type

event constructor;/***************************************************************************************

		Event:	Constructor
		Purpose:	Please see PB documentation for this event
**************************************************************************************/
THIS.BringToTop = FALSE
end event

