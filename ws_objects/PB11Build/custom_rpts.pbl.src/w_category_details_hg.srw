$PBExportHeader$w_category_details_hg.srw
$PBExportComments$Window used to select multiple categories
forward
global type w_category_details_hg from w_response_std
end type
type cb_rem_all from commandbutton within w_category_details_hg
end type
type dw_category_details from u_dw_std within w_category_details_hg
end type
type cb_cancel from commandbutton within w_category_details_hg
end type
type cb_ok from commandbutton within w_category_details_hg
end type
type cb_remove from commandbutton within w_category_details_hg
end type
type cb_add from commandbutton within w_category_details_hg
end type
type st_6 from statictext within w_category_details_hg
end type
type ddlb_case_type from dropdownlistbox within w_category_details_hg
end type
type st_5 from statictext within w_category_details_hg
end type
type dw_category_org from u_outliner_std within w_category_details_hg
end type
end forward

global type w_category_details_hg from w_response_std
integer width = 2921
integer height = 1552
string title = "Category Details"
cb_rem_all cb_rem_all
dw_category_details dw_category_details
cb_cancel cb_cancel
cb_ok cb_ok
cb_remove cb_remove
cb_add cb_add
st_6 st_6
ddlb_case_type ddlb_case_type
st_5 st_5
dw_category_org dw_category_org
end type
global w_category_details_hg w_category_details_hg

type variables
STRING i_sCategoryList[]
STRING i_cKeys[]
STRING i_cCaseType = 'M'
STRING i_cCaseTypeDesc = 'Compliment'

LONG i_nLevel
LONG i_nRow
LONG i_nCounter = 0

S_CATEGORY_INFO	i_sCurrentCategory

DATASTORE i_dsCategoryList

W_REPORT_PARMS_HG i_wParentWindow
end variables

forward prototypes
public function integer fw_initcategory (string case_type)
end prototypes

public function integer fw_initcategory (string case_type);//*********************************************************************************************
//
//  Event:   fw_initcategory
//  Purpose: Initlialize the category tree view based on the specified case_type.
//	
//	Parameters:
//		STRING	case_type		The ID used to determine the case type
//	Returns:
//		INTEGER	 0 = success
//					-1 = failure
//					
//  Date     Developer     Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//*********************************************************************************************
	
CONSTANT	INTEGER	l_nMaxLevels = 5
STRING	l_cParentCategoryID, l_cTableName,l_cWhereClause
INTEGER	l_nIndex

FOR l_nIndex = 1 TO l_nMaxLevels
	IF l_nIndex = 1 THEN
		l_cTableName = "cusfocus.categories"
		l_cParentCategoryID = ""
		l_cWhereClause = l_cTableName + ".category_level = 1 AND " + &
							  l_cTableName + ".case_type = '" + case_type + "'"
	ELSE
		l_cTableName = "cusfocus.category_" + STRING (l_nIndex - 1) + "_vw"
		l_cParentCategoryID = l_cTableName + ".prnt_category_id"
		l_cWhereClause = l_cTableName + ".case_type = '" + case_type + "'"
	END IF
	
	// define retrieval options for all levels
	dw_category_org.fu_HLRetrieveOptions (l_nIndex, &
		"open.bmp", "closed.bmp", l_cTableName + ".category_id", + &
		l_cParentCategoryID, l_cTableName + ".category_name", &
		l_cTableName + ".category_name", l_cTableName, &
		l_cWhereClause, dw_category_org.c_KeyString)
NEXT

dw_category_org.fu_HLOptions(dw_category_org.c_SingleSelect + dw_category_org.c_ShowLines)

// now create the outliner datawindow
IF dw_category_org.fu_HLCreate (SQLCA, l_nMaxLevels) = 0 THEN
	IF dw_category_org.RowCount() > 0 THEN
		
		// select the first item in the tree view
		dw_category_org.fu_HLSetSelectedRow (1)
		dw_category_org.TriggerEvent ("po_pickedRow")
		
	ELSE
		
		// clear the current category information because there is no current category.
		i_scurrentcategory.case_type = case_type
		i_scurrentcategory.category_id = ''
		i_scurrentcategory.parent_id = ''
		i_scurrentcategory.lineage = ''
		i_scurrentcategory.level = 1
		
	END IF
	RETURN 0
ELSE
	RETURN -1
END IF
end function

on w_category_details_hg.create
int iCurrent
call super::create
this.cb_rem_all=create cb_rem_all
this.dw_category_details=create dw_category_details
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_remove=create cb_remove
this.cb_add=create cb_add
this.st_6=create st_6
this.ddlb_case_type=create ddlb_case_type
this.st_5=create st_5
this.dw_category_org=create dw_category_org
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_rem_all
this.Control[iCurrent+2]=this.dw_category_details
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_remove
this.Control[iCurrent+6]=this.cb_add
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.ddlb_case_type
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.dw_category_org
end on

on w_category_details_hg.destroy
call super::destroy
destroy(this.cb_rem_all)
destroy(this.dw_category_details)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_remove)
destroy(this.cb_add)
destroy(this.st_6)
destroy(this.ddlb_case_type)
destroy(this.st_5)
destroy(this.dw_category_org)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To set options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/19/02 C. Jackson  Original Version
//***********************************************************************************************

LONG l_nUpper, l_nSearchRow, l_nIndex

fw_SetOptions (c_NoEnablePopup)

IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_dissat_report_hg' THEN
	i_cCaseType = 'C'
ELSE
	IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_case_inquiry_report_hg' THEN
		i_cCaseType = w_case_inquiry_parms_hg.i_cCaseType
	ELSE
		i_cCaseType = w_report_parms_hg.i_cCaseType
	END IF
END IF

CHOOSE CASE i_cCaseType
	CASE 'M'
		ddlb_case_type.SelectItem (1)
	CASE 'I'
		ddlb_case_type.SelectItem (2)
	CASE 'C' 
		ddlb_case_type.SelectItem (3)
	CASE 'P'
		ddlb_case_type.SelectItem (4)
END CHOOSE

Post fw_initcategory (i_cCaseType)

IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_dissat_report_hg' THEN
	ddlb_case_type.Enabled = FALSE
END IF

i_dsCategoryList = CREATE DATASTORE
i_dsCategoryList.dataobject = 'd_nv_category_hg'
i_dsCategoryList.SetTransObject (SQLCA)
i_dsCategoryList.Retrieve()

dw_category_details.fu_SetOptions(SQLCA, dw_category_details.c_NullDW, &
		dw_category_details.c_SelectOnClick + dw_category_details.c_DeleteOK  + &
		dw_category_details.c_NoRetrieveOnOpen + dw_category_details.c_NoEnablePopup)
		
IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_case_inquiry_report_hg' THEN
	l_nUpper = UpperBound( w_case_inquiry_parms_hg.i_sReportParmsHG.category_array )
ELSE
	l_nUpper = UpperBound( w_report_parms_hg.i_sReportParmsHG.category_array )
END IF

IF l_nUpper > 0 THEN
	cb_remove.Enabled = TRUE
	cb_rem_all.Enabled = TRUE
	
	FOR l_nIndex = 1 TO l_nUpper
		IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_case_inquiry_report_hg' THEN		
			l_nSearchRow = i_dsCategoryList.Find ( "category_id = '"+w_case_inquiry_parms_hg.i_sReportParmsHG.category_array[l_nIndex]+"'", 1, i_dsCategoryList.RowCount() ) 					
		ELSE
			l_nSearchRow = i_dsCategoryList.Find ( "category_id = '"+w_report_parms_hg.i_sReportParmsHG.category_array[l_nIndex]+"'", 1, i_dsCategoryList.RowCount() ) 					
		END IF
		i_dsCategoryList.SelectRow(l_nSearchRow, TRUE)		
			IF l_nSearchRow > 0 THEN
				
				i_dsCategoryList.RowsMove( l_nSearchRow, l_nSearchRow, Primary!, dw_category_details, dw_category_details.rowcount() + 1, Primary! )												  
				dw_category_details.Sort()
				
			END IF
		
	NEXT
ELSE
	cb_remove.Enabled = FALSE
	cb_rem_all.Enabled = FALSE
END IF


fw_SetOptions(c_CloseNoSave)



end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_Close
   Purpose:    Perform this just before the window closes.  The close process cannot be
					stopped at this point.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/10/03 M. Caruso    Created.
*****************************************************************************************/

PCCA.Parm = i_sCategoryList[]
end event

type cb_rem_all from commandbutton within w_category_details_hg
integer x = 1289
integer y = 616
integer width = 343
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remo&ve All"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Clear All Selected Categories
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/20/02 C. Jackson  Original Version
//***********************************************************************************************

STRING l_cCategoryId
LONG l_nRowCount, l_nIndex, l_nRows[], l_nSearchRow, l_nRow[]

l_nRowCount = dw_category_details.RowCount()

IF l_nRowCount = 0 THEN
	
	messagebox(gs_AppName,'There are no categories to delete.')
	
ELSE

	DO UNTIL dw_category_details.RowCount() = 0
		
		dw_category_details.RowsMove( dw_category_details.RowCount(), dw_category_details.RowCount(), &
			Primary!, i_dsCategoryList, i_dsCategoryList.rowcount() + 1, Primary! )
		
	LOOP
	
END IF
	
	
	
	

end event

type dw_category_details from u_dw_std within w_category_details_hg
integer x = 1746
integer y = 72
integer width = 1129
integer height = 1356
integer taborder = 20
string dataobject = "d_category"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;THIS.Retrieve()
end event

type cb_cancel from commandbutton within w_category_details_hg
integer x = 1289
integer y = 1320
integer width = 343
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ca&ncel"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Close with no parameters
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//***********************************************************************************************

CLOSE(Parent)
end event

type cb_ok from commandbutton within w_category_details_hg
integer x = 1289
integer y = 1196
integer width = 343
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Close with parameters
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//***********************************************************************************************

LONG l_nIndex, l_nDWRowcount
STRING l_cNull

SetNull(l_cNull)

// Clear out the array
IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_case_inquiry_report_hg' THEN
	w_case_inquiry_parms_hg.i_sReportParmsHG.category_array = w_case_inquiry_parms_hg.i_cResetArray
ELSE
	w_report_parms_hg.i_sReportParmsHG.category_array = w_report_parms_hg.i_cResetArray
END IF

l_nDwRowCount = dw_category_details.RowCount()

IF l_nDWRowCount > 0 THEN
	FOR l_nIndex = 1 TO l_nDwRowCount
		
		i_sCategoryList[l_nIndex] = dw_category_details.GetItemString(l_nIndex,'category_id')
		
//		IF w_supervisor_portal.uo_reports.i_cDataWindow = 'd_case_inquiry_report_hg' THEN		
//			w_case_inquiry_parms_hg.i_sReportParmsHG.category_array[l_nIndex] = &
//					dw_category_details.GetItemString(l_nIndex,'category_id')
//			
//		ELSE
//			
//			w_report_parms_hg.i_sReportParmsHG.category_array[l_nIndex] = &
//					dw_category_details.GetItemString(l_nIndex,'category_id')
//		END IF



		
	NEXT
	
	IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_case_inquiry_report_hg' THEN
		w_case_inquiry_parms_hg.i_bMultiCategory = TRUE
	ELSE
		w_report_parms_hg.i_bMultiCategory = TRUE
	END IF
	
ELSE

	IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_case_inquiry_report_hg' THEN

		w_case_inquiry_parms_hg.dw_category_org.fu_HLClearSelectedRows()
		w_case_inquiry_parms_hg.i_bMultiCategory = FALSE
	ELSE
		w_report_parms_hg.dw_category_org.fu_HLClearSelectedRows()
		w_report_parms_hg.i_bMultiCategory = FALSE
	END IF
	

END IF

CLOSE(Parent)



end event

type cb_remove from commandbutton within w_category_details_hg
integer x = 1289
integer y = 448
integer width = 343
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Remove"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Remove selected Categories
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/20/02 C. Jackson  Original Version
//**********************************************************************************************

STRING l_cCategoryID
LONG l_nRow[], l_nSearchRow, l_nSelectedRows[], l_nSelected


l_nSelected = dw_category_details.fu_GetSelectedRows(l_nRow[])

IF l_nSelected = 0 THEN
	IF dw_category_details.RowCount() = 0 THEN
		messagebox(gs_AppName,'There are no categories to delete.')
	ELSE
		messagebox(gs_AppName,'Please select a category to delete.')
	END IF
	
ELSE
	
	// Find selected row in non-visual datawindow
	l_cCategoryID = dw_category_details.GetItemString(l_nRow[1],'category_id')
	
	l_nSearchRow = dw_category_details.Find ( "category_id = '"+l_cCategoryID+"'", 1, dw_category_details.RowCount() ) 	
	
	dw_category_details.SelectRow(l_nRow[1], TRUE)		
	
	IF l_nSearchRow > 0 THEN
		
		dw_category_details.RowsMove( l_nRow[1], l_nRow[1], Primary!, i_dsCategoryList, i_dsCategoryList.rowcount() + 1, Primary! )												  
		
		
	END IF
	
	IF dw_category_details.GetRow() = 0 THEN
		cb_remove.Enabled = FALSE
		cb_rem_all.Enabled = FALSE
	END IF
	
END IF


end event

type cb_add from commandbutton within w_category_details_hg
integer x = 1289
integer y = 328
integer width = 343
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Add"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Add selected categories to the list for reporting
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/19/02 C. Jackson  Original Version
//**********************************************************************************************

LONG l_nSearchRow, l_nSelectedRows[]

// Find selected row in non-visual datawindow
l_nSearchRow = i_dsCategoryList.Find ( "category_id = '"+Message.StringParm+"'", 1, i_dsCategoryList.RowCount() ) 	

i_dsCategoryList.SelectRow(l_nSearchRow, TRUE)		

IF l_nSearchRow > 0 THEN
	cb_remove.Enabled = TRUE
	cb_rem_all.Enabled = TRUE
	
	i_dsCategoryList.RowsMove( l_nSearchRow, l_nSearchRow, Primary!, dw_category_details, dw_category_details.rowcount() + 1, Primary! )												  
	dw_category_details.Sort()
	
END IF


end event

type st_6 from statictext within w_category_details_hg
integer x = 37
integer y = 16
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Type:"
boolean focusrectangle = false
end type

type ddlb_case_type from dropdownlistbox within w_category_details_hg
integer x = 37
integer y = 84
integer width = 1129
integer height = 448
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"Compliment","Inquiry","Issue/Concern","Proactive"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//*******************************************************************************************
//
//  Event:   selectionchanged
//  Purpose: Update the contents of the category tree control based on the new selection.
//  
//  Date     Developer   Desription
//  -------- ----------- --------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//*******************************************************************************************

i_cCaseTypeDesc = This.Text(index)

// Initialize dw_category_org for the new case type.
CHOOSE CASE This.Text(index)
	CASE "Compliment"
		i_cCaseType = "M"
		
	CASE "Inquiry"
		i_cCaseType = "I"
		
	CASE "Issue/Concern"
		i_cCaseType = "C"
		
	CASE "Proactive"
		i_cCaseType = "P"
		
END CHOOSE

fw_initcategory (i_cCaseType)


end event

type st_5 from statictext within w_category_details_hg
integer x = 37
integer y = 252
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Category:"
boolean focusrectangle = false
end type

type dw_category_org from u_outliner_std within w_category_details_hg
integer x = 37
integer y = 316
integer width = 1129
integer height = 1112
integer taborder = 10
boolean hscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;//********************************************************************************************
//
//  Event:   po_pickedrow
//  Purpose: Retrieve the details of the selected row into the detail datawindow.
//
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//********************************************************************************************

// If this event was trigger by another function/event then set defaults.
IF IsNull (clickedlevel) THEN
	i_nLevel = 1
	i_nRow = 1
ELSE
	i_nLevel = clickedlevel
	i_nRow = clickedrow
END IF

// Get the key of the Picked Row and view it's details
fu_HLGetRowKey(i_nRow, i_ckeys[])
Message.StringParm = i_ckeys[i_nLevel]


end event

event po_validaterow;call super::po_validaterow;//********************************************************************************************
//
//  Event:   po_ValidateRow
//  Purpose: Provides an opportunity for the developer to validate a previously selected row 
//           before moving on with the currently selected row.
//
//  Parameters: LONG    ClickedRow - Row number of the new record.
//              INTEGER ClickedLevel - Level of the new record.
//              LONG    SelectedRow - Row number of the currently selected record.
//              INTEGER SelectedLevel - Level of the currently selected record.
//              INTEGER MaxLevels - Maximum levels for outliner.
//
//   Return Value: i_RowError - Indicates if an error has occured in the processing of this event.  
//	              Return -1 to stop the new row from becoming the current row.
//					  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  03/18/02 C. Jackson  Original version
//********************************************************************************************

STRING	l_cKeys1[], l_cKeys2[]
INTEGER	l_nNumKeys1, l_nNumKeys2
BOOLEAN	l_bHasChildren

// Check if the current row has visible children.
IF selectedrow = 0 THEN selectedrow = 1

l_nNumKeys1 = fu_HLGetRowKey (selectedrow, l_cKeys1[])
l_nNumKeys2 = fu_HLGetRowKey (selectedrow + 1, l_cKeys2[])
IF l_nNumKeys2 > l_nNumKeys1 THEN
	
	IF l_cKeys1[l_nNumKeys1] = l_cKeys2[l_nNumKeys1] THEN
		l_bHasChildren = TRUE
	ELSE
		l_bHasChildren = FALSE
	END IF
	
ELSE
	
	l_bHasChildren = FALSE
	
END IF

// If the current row does not have visible children, collapse that row.
IF NOT l_bHasChildren THEN
	
	i_ClickedRow = selectedrow
	fu_HLCollapseBranch ()
	i_ClickedRow = clickedrow
	
END IF
end event

event po_selectedrow;//**********************************************************************************************
//
//  Event:   po_selectedrow
//  Purpose: Store the key information about the current category.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//**********************************************************************************************

STRING	l_cKeys[], l_cCurrentKey
INTEGER	l_nLevel

// get the level
i_scurrentcategory.level = selectedlevel

// get the category ID
fu_HLGetRowKey (SelectedRow, l_cKeys[])
i_scurrentcategory.category_id = l_cKeys[i_scurrentcategory.level]

// get the parent ID case_type and lineage
SELECT prnt_category_id, case_type, category_lineage
  INTO :i_scurrentcategory.parent_id, :i_scurrentcategory.case_type, :i_scurrentcategory.lineage
  FROM cusfocus.categories
 WHERE category_id = :i_scurrentcategory.category_id
 USING SQLCA;
 

end event

