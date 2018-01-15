$PBExportHeader$u_tabpage_category.sru
$PBExportComments$Tab page for categorization of cases.
forward
global type u_tabpage_category from u_tabpg_std
end type
type dw_category_description from u_dw_std within u_tabpage_category
end type
type dw_categories from u_outliner_std within u_tabpage_category
end type
end forward

global type u_tabpage_category from u_tabpg_std
integer width = 3534
integer height = 784
string text = "Category"
dw_category_description dw_category_description
dw_categories dw_categories
end type
global u_tabpage_category u_tabpage_category

type variables
STRING						i_cCaseType

W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder
end variables

forward prototypes
public function integer of_defineview (string case_type)
public subroutine fu_collapseiftoplevel (long current_row)
end prototypes

public function integer of_defineview (string case_type);/*****************************************************************************************
   Function:   of_defineview
   Purpose:    define and create the tree view for the outliner
   Parameters: STRING	case_type - the case type, needed to retrieve related categories.
   Returns:    INTEGER 	0 - Success
							  -1 - Failure

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/29/00  M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nMaxLevels

IF case_type = i_cCaseType THEN
	
	// abort if the case type has not changed.
	RETURN 0
	
ELSE

	// update the current case type
	i_cCaseType = case_type
	// determine the number of levels for the current case type
	SELECT MAX (category_level) INTO :l_nMaxLevels FROM cusfocus.categories WHERE
				case_type = :case_type USING SQLCA;
	
	IF l_nMaxLevels > 0 THEN
		dw_categories.fu_HLRetrieveOptions(1, &
					"open.bmp", &
					"closed.bmp", &
					"cusfocus.categories.category_id", &
					"", &
					"cusfocus.categories.category_name", &
					"cusfocus.categories.category_name", &
					"cusfocus.categories", &
					"cusfocus.categories.category_level = 1 " + &
					"AND cusfocus.categories.case_type = '" + case_type + "' AND " + &
					"cusfocus.categories.active = 'Y'", &
					dw_categories.c_KeyString)
	ELSE
		// error and return
		MessageBox (gs_AppName, &
					'CustomerFocus is unable to process this case because there are no categories ~r~n' + &
					'defined for this case type. Please notify your system administrator.')
		RETURN -1
	END IF
		
	IF l_nMaxLevels > 1 THEN
		dw_categories.fu_HLRetrieveOptions(2, &
					"open.bmp", &
					"closed.bmp", &
					"cusfocus.category_1_vw.category_id", &			
					"cusfocus.category_1_vw.prnt_category_id", &
					"cusfocus.category_1_vw.category_name", &
					"cusfocus.category_1_vw.category_name", &
					"cusfocus.category_1_vw", &
					"cusfocus.category_1_vw.case_type = '" + case_type + "' AND " + &
					"cusfocus.category_1_vw.active = 'Y'", &
					dw_categories.c_KeyString)
	END IF
	
	IF l_nMaxLevels > 2 THEN
		dw_categories.fu_HLRetrieveOptions(3, &
					"open.bmp", &
					"closed.bmp", &
					"cusfocus.category_2_vw.category_id", &			
					"cusfocus.category_2_vw.prnt_category_id", &
					"cusfocus.category_2_vw.category_name", &
					"cusfocus.category_2_vw.category_name", &
					"cusfocus.category_2_vw", &
					"cusfocus.category_2_vw.case_type = '" + case_type + "' AND " + &
					"cusfocus.category_2_vw.active = 'Y'", &
					dw_categories.c_KeyString)
	END IF
	
	IF l_nMaxLevels > 3 THEN
		dw_categories.fu_HLRetrieveOptions(4, &
					"open.bmp", &
					"closed.bmp", &
					"cusfocus.category_3_vw.category_id", &			
					"cusfocus.category_3_vw.prnt_category_id", &
					"cusfocus.category_3_vw.category_name", &
					"cusfocus.category_3_vw.category_name", &
					"cusfocus.category_3_vw", &
					"cusfocus.category_3_vw.case_type = '" + case_type + "' AND " + &
					"cusfocus.category_3_vw.active = 'Y'", &
					dw_categories.c_KeyString)
	END IF
	
	IF l_nMaxLevels > 4 THEN
		dw_categories.fu_HLRetrieveOptions(5, &
					"open.bmp", &
					"closed.bmp", &
					"cusfocus.category_4_vw.category_id", &			
					"cusfocus.category_4_vw.prnt_category_id", &
					"cusfocus.category_4_vw.category_name", &
					"cusfocus.category_4_vw.category_name", &
					"cusfocus.category_4_vw", &
					"cusfocus.category_4_vw.case_type = '" + case_type + "' AND " + &
					"cusfocus.category_4_vw.active = 'Y'", &
					dw_categories.c_KeyString)
	END IF
	
	i_wParentWindow.i_uoCaseDetails.i_nMaxLevels = l_nMaxLevels
	
	IF l_nMaxLevels > 0 THEN
		dw_categories.fu_HLOptions (dw_categories.c_DrillDownOnLastLevel + &
											 dw_categories.c_HideRowFocusIndicator)
		dw_categories.fu_HLCreate (SQLCA, i_wParentWindow.i_uoCaseDetails.i_nMaxLevels)
	END IF
	
	RETURN 0
	
END IF
end function

public subroutine fu_collapseiftoplevel (long current_row);/*****************************************************************************************
   Function:   fu_collapseiftoplevel
   Purpose:    Make sure that a top level entry does not get expanded
   Parameters: LONG	current_row - the Id of the selected row in the outliner.
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/30/00 M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nCurrentLevel, l_nNextLevel
LONG		l_nMaxRows

l_nMaxRows = dw_categories.RowCount ()
l_nCurrentLevel = dw_categories.GetItemNumber (current_row, "Level")
IF current_row < l_nMaxRows THEN
	l_nNextLevel = dw_categories.GetItemNumber (current_row + 1, "Level")
ELSE
	l_nNextLevel = l_nCurrentLevel
END IF

IF l_nNextLevel <= l_nCurrentLevel THEN
	dw_categories.SetItem (current_row, "expanded", 0)
END IF
end subroutine

on u_tabpage_category.create
int iCurrent
call super::create
this.dw_category_description=create dw_category_description
this.dw_categories=create dw_categories
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_category_description
this.Control[iCurrent+2]=this.dw_categories
end on

on u_tabpage_category.destroy
call super::destroy
destroy(this.dw_category_description)
destroy(this.dw_categories)
end on

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    set values for instance variables

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/29/00  M. Caruso    Created.
	10/31/00 M. Caruso    Add resize code.
*****************************************************************************************/
i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder

THIS.of_SetResize (TRUE)
IF IsValid (THIS.inv_resize) THEN
	// resize the category tree view
	THIS.inv_resize.of_Register (dw_categories, "ScaleToRight&Bottom")
	// resize the description datawindow
	THIS.inv_resize.of_Register (dw_category_description, THIS.inv_resize.FIXEDRIGHT_SCALEBOTTOM)
END IF
end event

type dw_category_description from u_dw_std within u_tabpage_category
integer x = 1842
integer y = 12
integer width = 1664
integer height = 768
integer taborder = 20
boolean enabled = false
string dataobject = "d_category_description"
boolean border = false
borderstyle borderstyle = styleraised!
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize the datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/29/00  M. Caruso    Created.
*****************************************************************************************/

INTEGER	l_nNewHeight, l_nNewWidth, l_nWidthOffset, l_nHeightOffset

fu_SetOptions (SQLCA, c_NullDW, c_Default + c_NoMenuButtonActivation)
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    retrieve the description for the selected category

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/29/00  M. Caruso    Created.
*****************************************************************************************/

IF retrieve (i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory) < 0 THEN
	messagebox (gs_AppName, 'There was an error retrieving the description for the selected category.')
END IF
end event

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/13/2001 K. Claver   Added code to resize the category description field in the datawindow.
*****************************************************************************************/
THIS.of_SetResize( TRUE )
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "category_desc", THIS.inv_resize.FIXEDRIGHT_SCALEBOTTOM )
END IF
	
end event

event clicked;call super::clicked;STRING ls_link
inet linet_base
Long l_nRV

IF dwo.type = "column" THEN
	
	// Adding the ability to open a link with a single click if they 
	//	click on the new link field
	Choose Case dwo.Name
		Case 'link'
			
		ls_link = THIS.GetItemString(row,'link')
		
		//RPost 10.19.2006 Changed the way 
		If Len(ls_link) > 0 and Not IsNull(ls_link) Then
			IF lower(MID(ls_link,1,5)) = "https" THEN ls_link = MID(ls_link,9)
			IF lower(MID(ls_link,1,4)) = "http" THEN ls_link = MID(ls_link,8)
			
			GetContextService("Internet", linet_base)
			l_nRV = linet_base.HyperlinkToURL(ls_link)
		END IF
	END CHOOSE
END IF
end event

type dw_categories from u_outliner_std within u_tabpage_category
integer x = 18
integer y = 12
integer width = 1733
integer height = 756
integer taborder = 10
boolean hscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event po_selectedrow;call super::po_selectedrow;/*****************************************************************************************
   Event:      po_selectedrow
   Purpose:    update the description field for the newly selected row

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/29/00  M. Caruso    Created.
	01/03/01 M. Caruso    Added code to set the category name on dw_case_details.
*****************************************************************************************/

INTEGER	l_nNumKeys
LONG		l_nRow
STRING	l_cKeyList[], l_cRootKey, l_cCategoryName
U_DW_STD	l_dwCaseDetails

l_dwCaseDetails = i_tabfolder.tabpage_case_details.dw_case_details

// get the key of the selected category
l_nNumKeys = fu_HLGetRowKey (selectedrow, l_cKeyList[])
IF l_nNumKeys > 0 THEN
	
	// gather information about the selected category
	i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory = l_cKeyList[l_nNumKeys]
	l_nRow = fu_HLFindRow (l_cKeyList[l_nNumKeys], l_nNumKeys)
	l_cCategoryName = fu_HLGetRowDesc (l_nRow)
	
	l_cRootKey = l_cKeyList[1]
	l_nRow = fu_HLFindRow (l_cRootKey, 1)
	i_wParentWindow.i_uoCaseDetails.i_cRootCategoryName = fu_HLGetRowDesc (l_nRow)
	
ELSE
	
	// update the settings to indicate that no category is selected.
	i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory = ''
	l_cCategoryName = ''
	i_wParentWindow.i_uoCaseDetails.i_cRootCategoryName = ''
	
END IF

// update the description field to reflect the newly selected category
dw_category_description.fu_retrieve (dw_category_description.c_ignorechanges, &
												 dw_category_description.c_noreselectrows)

// update the case details datawindow with the new category information.
l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_category_id', &
								 i_wParentWindow.i_uoCaseDetails.i_cSelectedCategory)
l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'categories_category_name', l_cCategoryName)
l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_root_category_name', &
								 i_wParentWindow.i_uoCaseDetails.i_cRootCategoryName)

end event

event po_pickedrow;call super::po_pickedrow;/*****************************************************************************************
   Event:      po_pickedrow
   Purpose:    Process the picked row.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/01/00 M. Caruso    Created.
*****************************************************************************************/

fu_CollapseIfTopLevel (clickedrow)
												 

end event

