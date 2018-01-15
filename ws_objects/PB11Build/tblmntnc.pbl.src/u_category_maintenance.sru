$PBExportHeader$u_category_maintenance.sru
$PBExportComments$Special container object for maintaining the category lists.
forward
global type u_category_maintenance from u_container_std
end type
type dw_category_details from u_dw_std within u_category_maintenance
end type
type st_case_types from statictext within u_category_maintenance
end type
type ddlb_case_type from dropdownlistbox within u_category_maintenance
end type
type st_categoryorg from statictext within u_category_maintenance
end type
type dw_category_org from u_outliner_std within u_category_maintenance
end type
type gb_category_details from groupbox within u_category_maintenance
end type
end forward

global type u_category_maintenance from u_container_std
integer width = 3579
integer height = 1592
boolean border = false
long backcolor = 79748288
event ue_setfocus ( )
dw_category_details dw_category_details
st_case_types st_case_types
ddlb_case_type ddlb_case_type
st_categoryorg st_categoryorg
dw_category_org dw_category_org
gb_category_details gb_category_details
end type
global u_category_maintenance u_category_maintenance

type variables
BOOLEAN				i_bCategoryChanged
BOOLEAN				i_bNewCategory
BOOLEAN           i_bNewSubCategory

STRING				i_cCategoryID

S_CATEGORY_INFO	i_sCurrentCategory
end variables

forward prototypes
public subroutine uf_updatedisplay (string category_id, integer level)
public function integer uf_initcategorytree (string case_type)
end prototypes

event ue_setfocus;//**********************************************************************************************
//
//  Event:   ue_setfocus
//  Purpose: To set focus on the detail datawindow
//  
//  Date
//  -------- ----------- -----------------------------------------------------------------------
//  08/28/00 C. Jackson  Original Version
//  
//**********************************************************************************************

dw_category_details.SetFocus()
dw_category_details.SetColumn('category_name')
end event

public subroutine uf_updatedisplay (string category_id, integer level);//*********************************************************************************************
//
//  Event:   uf_updatedisplay
//  Purpose: Provide a single function to update the category tree view whenever a change is 
//           made to a category (insert, insert child, delete or edit).
//				
//  Arguments: STRING	category_id	- The ID of the new category
//             INTEGER	level - The level the category is on
//  Returns:   None
//	
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  08/30/99 M. Caruso   Created.
//  08/24/00 C. Jackson  Added logic to handle refreshing for a child or sibling insert
//  
//*********************************************************************************************

LONG		l_nRow
INTEGER	l_nLevels, l_nCounter
STRING	l_cKeys[]

// first, update the data in the outliner object
dw_category_org.fu_HLRefresh (0, dw_category_org.c_NoReselectRows)

// Expand the branch leading to the specified row.
l_nRow = dw_category_org.fu_HLFindRow (category_id, level)
l_nLevels = dw_category_org.fu_HLGetRowKey (l_nRow, l_cKeys[])

dw_category_org.SetRedraw(FALSE)
dw_category_org.Hide()

dw_category_org.fu_HLCollapse (1)

FOR l_nCounter = 1 to l_nLevels
	l_nRow = dw_category_org.fu_HLFindRow(l_cKeys[l_nCounter], l_nCounter)
	// collapse all subtrees of the current level
	IF l_nCounter > 1 THEN
		dw_category_org.fu_HLCollapse(l_nCounter+1)
	END IF
	// expand only the appropriate branch
	IF l_nCounter < l_nLevels THEN
		dw_category_org.i_ClickedRow = l_nRow
		dw_category_org.fu_HLExpandBranch()
	ELSE
		dw_category_org.fu_HLSetSelectedRow(l_nRow)
		dw_category_org.ScrollToRow(l_nRow)
	END IF
NEXT

dw_category_org.fu_HLSetSelectedRow (l_nRow)

dw_category_org.Show()
dw_category_org.SetRedraw(TRUE)




end subroutine

public function integer uf_initcategorytree (string case_type);/**************************************************************************************
	Event:	uf_initcategorytree
	Purpose:	Initlialize the category tree view based on the specified case_type.
	
	Parameters:
		STRING	case_type		The ID used to determine the case type
	Returns:
		INTEGER	 0 = success
					-1 = failure
					
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	8/26/99  M. Caruso     Created.
	8/30/99  M. Caruso     Added automated creation of Where Clause for each level of the
								  window to correct issues displaying lower levels.
	10/20/00 M. Caruso     Added call to po_pickedrow if a row is selected.
	02/20/01 M. Caruso     Changed the method for clearing the detail side if no
								  categories are retrieved for the specified case type to use
								  fu_reset and	fu_new instead of fu_retrieve with an invalid ID.
****************************************************************************************/
	
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

// now create the outliner datawindow
IF dw_category_org.fu_HLCreate (SQLCA, l_nMaxLevels) = 0 THEN
	IF dw_category_org.RowCount() > 0 THEN
		
		// select the first item in the tree view
		dw_category_org.fu_HLSetSelectedRow (1)
		dw_category_org.TriggerEvent ("po_pickedRow")
		
		// enable the insert child menu item
		m_table_maintenance.m_edit.m_insertchildrecord.Enabled = TRUE
		
	ELSE
		
		// clear the current category information because there is no current category.
		i_scurrentcategory.case_type = case_type
		i_scurrentcategory.category_id = ''
		i_scurrentcategory.parent_id = ''
		i_scurrentcategory.lineage = ''
		i_scurrentcategory.level = 1
		
		// clear the detail datawindow
		dw_category_details.fu_reset (dw_category_details.c_promptchanges)
		dw_category_details.fu_New (1)
		
		// disable the insert child menu item
		m_table_maintenance.m_edit.m_insertchildrecord.Enabled = FALSE
		
	END IF
	RETURN 0
ELSE
	RETURN -1
END IF
end function

on u_category_maintenance.create
int iCurrent
call super::create
this.dw_category_details=create dw_category_details
this.st_case_types=create st_case_types
this.ddlb_case_type=create ddlb_case_type
this.st_categoryorg=create st_categoryorg
this.dw_category_org=create dw_category_org
this.gb_category_details=create gb_category_details
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_category_details
this.Control[iCurrent+2]=this.st_case_types
this.Control[iCurrent+3]=this.ddlb_case_type
this.Control[iCurrent+4]=this.st_categoryorg
this.Control[iCurrent+5]=this.dw_category_org
this.Control[iCurrent+6]=this.gb_category_details
end on

on u_category_maintenance.destroy
call super::destroy
destroy(this.dw_category_details)
destroy(this.st_case_types)
destroy(this.ddlb_case_type)
destroy(this.st_categoryorg)
destroy(this.dw_category_org)
destroy(this.gb_category_details)
end on

event pc_setoptions;call super::pc_setoptions;/****************************************************************************************
	Event:	pc_setoptions
	Purpose:	initialize options for the datawindows
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	8/26/99  M. Caruso     Created.
	02/20/01 M. Caruso     Removed call to fu_setoptions for dw_category_details and added
								  code to set the default item in ddlb_case_type to 1 and
								  initialize the treeview to show Configurable categories
   01/24/02 C. Jackson    Modify to allow for configurable case type
	08/16/2004 K. Claver   uf_initcategorytree was not called with correct initial case type.  
								  Changed to 'C' for Issue/Concern.
****************************************************************************************/

LONG l_nIndex

dw_category_org.fu_HLOptions (dw_category_org.c_DrillDownOnClick)
ddlb_case_type.SelectItem (1)

l_nIndex = ddlb_case_type.FindItem ( 'configurable', 0)
ddlb_case_type.DeleteItem ( l_nIndex )
ddlb_case_type.InsertItem ( gs_ConfigCaseType,  l_nIndex )

// Post this function call so dw_category_details has a chance to initialize properly.
Post uf_initcategorytree ("C")
ddlb_case_type.SelectItem ( 'Issue/Concern', 0 )
end event

type dw_category_details from u_dw_std within u_category_maintenance
integer x = 1829
integer y = 196
integer width = 1531
integer height = 1260
integer taborder = 20
string dataobject = "d_category_details"
boolean border = false
end type

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
	Event         : pcd_Retrieve
	Description   : Retrieve data from the database for this DataWindow.

	Parameters    : DATAWINDOW Parent_DW -
            	        Parent of this DataWindow.  If this 
                     DataWindow is root-level, this value will
                     be NULL.
	                LONG       Num_Selected -
                     The number of selected records in the
                     parent DataWindow.
                   LONG       Selected_Rows[] -
                     The row numbers of the selected records
                     in the parent DataWindow.

	Return Value  : Error.i_FWError -
                     c_Success - the event completed succesfully.
                     c_Fatal   - the event encountered an error.

	Change History:

	Date     Person     Description of Change
	-------- ---------- --------------------------------------------
	8/26/99  M. Caruso  Created.
****************************************************************************************/

LONG 		l_nRtn, l_nRow
STRING	l_cCategoryID


IF i_bNewCategory THEN
	SETNULL(l_cCategoryID)
ELSE
	l_cCategoryID = Message.StringParm
END IF

l_nRtn = Retrieve(l_cCategoryID)

IF l_nRtn < 0 THEN
   Error.i_FWError = c_Fatal
END IF

IF i_bNewCategory THEN
	dw_category_details.fu_New (1)
	dw_category_details.SetFocus()
	dw_category_details.SetColumn('category_name')
END IF


end event

event itemchanged;call super::itemchanged;/****************************************************************************************
	Event:	itemchanged
	Purpose: Prep the system to update the updated_by and updated_timestamp columns when
	         the changed category is saved.
				
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	11/4/99  M. Caruso    Created.
****************************************************************************************/

i_bCategoryChanged = TRUE
end event

event pcd_validatebefore;call super::pcd_validatebefore;/****************************************************************************************
	Event:	pcd_validatebefore
	Purpose: Update the updated_by and updated_timestamp fields if the category info
	         changed.
				
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	11/4/99  M. Caruso    Created.
****************************************************************************************/

DATETIME	l_dtTimeStamp

// only update the info if during the save process.
IF in_save THEN
	
	IF i_bCategoryChanged THEN
		
		SetItem(i_CursorRow, 'updated_by', OBJCA.WIN.fu_GetLogin(SQLCA))
		l_dtTimeStamp = w_table_maintenance.fw_GetTimeStamp()
		SetItem(i_CursorRow, 'updated_timestamp', l_dtTimeStamp)
		
		// reset i_bCategoryChanged
		i_bCategoryChanged = FALSE
		
	END IF
	
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/20/01 M. Caruso    Added c_IgnoreNewRows option.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_NewOK + c_ModifyOK + c_ModifyOnOpen + &
		c_DeleteOK + c_ModifyOnSelect + c_NoMenuButtonActivation + &
		c_NoRetrieveOnOpen + c_NoEnablePopup + c_IgnoreNewRows)
		
		
end event

event pcd_new;call super::pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    insert a new category record into the list for the current case type.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/19/00 M. Caruso    Created.
*****************************************************************************************/

IF i_bNewSubCategory THEN
	SetItem (1, 'category_name', '(New Sub-Category)')
ELSE
	SetItem (1, 'category_name', '(New Category)')
END IF

SetItem (1, 'category_desc', '')
SetItem (1, 'active', "Y")
SetItem (1, 'categories_case_type', i_sCurrentCategory.case_type)
end event

event pcd_savebefore;call super::pcd_savebefore;/*****************************************************************************************
   Event:      pcd_savebefore
   Purpose:    Set remaining required values before saving the record.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/19/00 M. Caruso    Created.
*****************************************************************************************/

INTEGER		li_Level, li_Count, li_Offset
LONG			ll_Row
STRING		ls_CategoryID, ls_ParentID, ls_UserID, ls_Lineage
DATETIME		ldt_TimeStamp
DATASTORE	l_dsCategoryList

IF i_bNewCategory THEN
	// define the values for this category
	ls_CategoryID = w_table_maintenance.fw_GetKeyValue ('categories')
	IF i_bNewSubCategory THEN
		// set values as new child
		li_Level = i_sCurrentCategory.level + 1
		ls_ParentID = i_sCurrentCategory.category_id
		li_Offset = 0
	ELSE
		// set values as new sibling
		li_Level = i_sCurrentCategory.level
		ls_ParentID = i_sCurrentCategory.parent_id
		li_Offset = 2
	END IF
	
	// get the new lineage value
	l_dsCategoryList = CREATE datastore
	l_dsCategoryList.DataObject = "d_category_list"
	l_dsCategoryList.SetTransObject(SQLCA)
	l_dsCategoryList.Retrieve()
		
	FOR li_Count = 1 TO 99
		ls_Lineage = Left (i_sCurrentCategory.lineage, Len (i_sCurrentCategory.lineage) - li_Offset) + STRING (li_Count, "00")
		ll_Row = l_dsCategoryList.Find ("category_lineage = '" + ls_Lineage + "'", 1,  l_dsCategoryList.RowCount())
		IF ll_Row = 0 THEN
			EXIT
		END IF
	NEXT
	DESTROY l_dsCategoryList
	
	// set the values into the record
	SetItem (1, 'category_id', ls_CategoryID)
	SetItem (1, 'category_level', li_Level)
	SetItem (1, 'category_lineage', ls_Lineage)
	SetItem (1, 'prnt_category_id', ls_ParentID)
END IF

// update for all categories
ls_UserID = OBJCA.WIN.fu_GetLogin (SQLCA)
ldt_TimeStamp = w_table_maintenance.fw_GetTimeStamp ()
SetItem (1, 'updated_by', ls_UserID)
SetItem (1, 'updated_timestamp', ldt_TimeStamp)
end event

event pcd_validaterow;call super::pcd_validaterow;/*****************************************************************************************
   Event:      pcd_validaterow
   Purpose:    Validate the data before allowing a save.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/20/00 M. Caruso    Created.
*****************************************************************************************/

STRING l_cNewCatName

// If the user hasn't changed the default category name, then don't let them save
l_cNewCatName = GetItemString(1,'category_name')
CHOOSE CASE TRIM (l_cNewCatName)
	CASE '(New Category)', '(New Sub-Category)', ''
		messagebox(gs_AppName,'Please enter a valid Category Name')
		SetFocus()
		SetColumn('category_name')
		Error.i_FWError = c_Fatal
		
	CASE ELSE
		IF IsNull (l_cNewCatName) THEN Error.i_FWError = c_Fatal
		
END CHOOSE
end event

event pcd_saveafter;call super::pcd_saveafter;/*****************************************************************************************
   Event:      pcd_saveafter
   Purpose:    Finish updating the interface.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	10/20/00 M. Caruso    Created.
*****************************************************************************************/

// update the current category information.
i_sCurrentCategory.category_id = GetItemString (i_CursorRow, "category_id")
i_sCurrentCategory.level = GetItemNumber (i_CursorRow, "category_level")
i_sCurrentCategory.lineage = GetItemString (i_CursorRow, "category_lineage")
i_sCurrentCategory.parent_id = GetItemString (i_CursorRow, "prnt_category_id")

// update the tree view
uf_updatedisplay (i_sCurrentCategory.category_id, i_sCurrentCategory.level)

//  If this is a new subcategory, expand the level after adding and saving
IF i_bNewSubCategory THEN
	dw_category_org.fu_HLExpandLevel()
	i_bNewSubCategory = FALSE
END IF

// reset new category status markers since the category has been saved.
i_bNewCategory = FALSE
i_bNewSubCategory = FALSE
end event

type st_case_types from statictext within u_category_maintenance
integer x = 142
integer y = 36
integer width = 1042
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Types:"
boolean focusrectangle = false
end type

type ddlb_case_type from dropdownlistbox within u_category_maintenance
integer x = 142
integer y = 112
integer width = 946
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
string item[] = {"Configurable","Inquiry","Issue/Concern","Proactive"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;/****************************************************************************************
	Event:	selectionchanged
	Purpose:	Update the contents of the category tree control based on the new selection.
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	8/26/99  M. Caruso     Created.
	10/19/00 M. Caruso     Added selection of Proactive to maintain those categories. Also
								  moved the po_pickedrow event call to uf_initcategorytree().
	02/20/01 M. Caruso     Removed code to prompt for saving changes.
	01/24/02 C. Jackson    Modify to allow to configurable case type
****************************************************************************************/

CONSTANT	INTEGER	l_nMaxLevels = 5

INTEGER	l_nSaved, l_nIndex
STRING	l_cCaseType, l_cParentCategoryID, l_cTableName

// Set the state of the detail record to NotModified!, saved or not.
dw_category_details.SetItemStatus(1, 0, Primary!, NotModified!)


// Initialize dw_category_org for the new case type.
CHOOSE CASE This.Text(index)
	CASE "Inquiry"
		l_cCaseType = "I"
		
	CASE "Issue/Concern"
		l_cCaseType = "C"
		
	CASE "Proactive"
		l_cCaseType = "P"
		
	CASE ELSE
		l_cCaseType = "M"
		
END CHOOSE
Parent.uf_initcategorytree (l_cCaseType)
end event

type st_categoryorg from statictext within u_category_maintenance
integer x = 142
integer y = 228
integer width = 1042
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Category Organization:"
boolean focusrectangle = false
end type

type dw_category_org from u_outliner_std within u_category_maintenance
integer x = 142
integer y = 304
integer height = 1240
integer taborder = 20
borderstyle borderstyle = stylelowered!
end type

event po_validaterow;call super::po_validaterow;/****************************************************************************************
	Event        : po_ValidateRow
	Description  : Provides an opportunity for the developer to
                  validate a previously selected row before
                  moving on with the currently selected row.

	Parameters   : LONG    ClickedRow - 
                     Row number of the new record.
                  INTEGER ClickedLevel - 
                     Level of the new record.
                  LONG    SelectedRow - 
                     Row number of the currently selected record.
                  INTEGER SelectedLevel - 
                     Level of the currently selected record.
                  INTEGER MaxLevels - 
                     Maximum levels for outliner.

	Return Value  : i_RowError -
                     Indicates if an error has occured in the 
                     processing of this event.  Return -1
                     to stop the new row from becoming the 
                     current row.

	Change History: 

	Date     Person     Description of Change
	-------- ---------- -------------------------------------------------------------------
	8/27/99  M. Caruso  Created.
   9/10/99  M. Caruso  Added functionality that allows only one selected top-level folder.
	9/13/99  M. Caruso  Make sure selectedrow is set before processing the outliner update.
	02/20/01 M. Caruso  Removed code to prompt for saving changes.
*****************************************************************************************/

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

event po_pickedrow;/****************************************************************************************
	Event:	po_pickedrow
	Purpose:	Retrieve the details of the selected row into the detail datawindow.
	
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	8/26/99  M. Caruso    Created.
	02/20/01 M. Caruso    Set i_bNewCategory to FALSE before calling fu_retrieve.
****************************************************************************************/

STRING	l_cKeys[]
LONG		l_nLevel, l_nRow

// If this event was trigger by another function/event then set defaults.
IF IsNull (clickedlevel) THEN
	l_nLevel = 1
	l_nRow = 1
ELSE
	l_nLevel = clickedlevel
	l_nRow = clickedrow
END IF

// Get the key of the Picked Row and view it's details
i_bNewCategory = FALSE
fu_HLGetRowKey(l_nRow, l_cKeys[])
Message.StringParm = l_cKeys[l_nLevel]
Parent.dw_category_details.fu_retrieve(c_PromptChanges, c_NoReselectRows)


end event

event po_selectedrow;/****************************************************************************************
	Event:	po_selectedrow
	Purpose:	Store the key information about the current category.
	
	Revisions:
	Date     Developer    Description
	======== ============ ================================================================
	8/27/99  M. Caruso    Created.
	
	8/30/99  M. Caruso    Disable m_insertchildrecord if the level of the selected record
								 is already at maximum depth supported by the tree view.
****************************************************************************************/

STRING	l_cKeys[], l_cCurrentKey
INTEGER	l_nLevel

// update the status of the insert child record menu item
IF selectedlevel < maxlevels THEN
	m_table_maintenance.m_edit.m_insertchildrecord.Enabled = TRUE
ELSE
	m_table_maintenance.m_edit.m_insertchildrecord.Enabled = FALSE
END IF

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
 
IF SQLCA.SQLCode <> 0 THEN
	MessageBox (gs_AppName, "Unable to gather information about the current category.")
END IF
	
end event

type gb_category_details from groupbox within u_category_maintenance
integer x = 1746
integer y = 44
integer width = 1691
integer height = 1504
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Category Details"
borderstyle borderstyle = stylelowered!
end type

