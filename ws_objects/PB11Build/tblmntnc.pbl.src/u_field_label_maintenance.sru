$PBExportHeader$u_field_label_maintenance.sru
$PBExportComments$Special module for updating the labels of the "fixed" demographic fields.
forward
global type u_field_label_maintenance from u_container_std
end type
type rb_search from radiobutton within u_field_label_maintenance
end type
type rb_demographic from radiobutton within u_field_label_maintenance
end type
type st_preview_selector from statictext within u_field_label_maintenance
end type
type dw_preview_window from u_dw_std within u_field_label_maintenance
end type
type st_field_label_assignment from statictext within u_field_label_maintenance
end type
type st_source_type from statictext within u_field_label_maintenance
end type
type dw_label_assignment from u_dw_std within u_field_label_maintenance
end type
type ddlb_source_types from dropdownlistbox within u_field_label_maintenance
end type
type gb_preview from groupbox within u_field_label_maintenance
end type
end forward

global type u_field_label_maintenance from u_container_std
integer width = 3579
integer height = 1592
rb_search rb_search
rb_demographic rb_demographic
st_preview_selector st_preview_selector
dw_preview_window dw_preview_window
st_field_label_assignment st_field_label_assignment
st_source_type st_source_type
dw_label_assignment dw_label_assignment
ddlb_source_types ddlb_source_types
gb_preview gb_preview
end type
global u_field_label_maintenance u_field_label_maintenance

type variables
INTEGER	i_nPreviousIndex

STRING	i_cSourceType
STRING	i_cPreviewObjects[2]
end variables

forward prototypes
public subroutine fu_updatepreview ()
public function integer fu_updatecontaineronsourcechange (integer index)
public subroutine fu_showcurrentlabelsinpreview ()
end prototypes

public subroutine fu_updatepreview ();/*****************************************************************************************
   Function:   fu_UpdatePreview
   Purpose:    Update the preview datawindow to display the correct view for the selected
					options on this window.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cSourceName, l_cViewName, l_cDataObject

l_cSourceName = ddlb_source_types.Text
IF rb_demographic.checked THEN
	l_cViewName = "Demographic"
	l_cDataObject = i_cPreviewObjects[2]
ELSE
	l_cViewName = "Search"
	l_cDataObject = i_cPreviewObjects[1]
END IF

// Update the group box title
gb_preview.Text = l_cSourceName + " " + l_cViewName + " Preview"

// prevent refreshing of the datawindow until all changes are made
dw_preview_window.SetRedraw (FALSE)

// update the datawindow in the control
dw_preview_window.DataObject = l_cDataObject
dw_preview_window.fu_SetOptions (SQLCA, dw_preview_window.c_NullDW, dw_preview_window.c_Default)

// update the preview pane to show the current defined labels
fu_ShowCurrentLabelsInPreview ()
dw_preview_window.SetRedraw (TRUE)
end subroutine

public function integer fu_updatecontaineronsourcechange (integer index);/*****************************************************************************************
   Function:   fu_UpdateContainerOnSourceChange
   Purpose:    Update the preview pane to show labels as currently defined.
   Parameters: INTEGER	index - the index of the selected entry in the Source Type list box.
   Returns:    INTEGER	 0 - Success
								-1 - Failed

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/13/03 M. Caruso    Created.
*****************************************************************************************/

INTEGER l_nReturn

CHOOSE CASE LOWER (ddlb_source_types.Text (index))
	CASE "member"
		i_cSourceType = "C"
		i_cPreviewObjects[1] = "d_search_consumer"
		i_cPreviewObjects[2] = "d_demographics_consumer"
		
	CASE "provider"
		i_cSourceType = "P"
		i_cPreviewObjects[1] = "d_search_provider"
		i_cPreviewObjects[2] = "d_demographics_provider"
		
	CASE "employer group"
		i_cSourceType = "E"
		i_cPreviewObjects[1] = "d_search_employer"
		i_cPreviewObjects[2] = "d_demographics_employer"
		
	CASE "other"
		i_cSourceType = "O"
		i_cPreviewObjects[1] = "d_search_other"
		i_cPreviewObjects[2] = "d_demographics_other"
		
END CHOOSE

l_nReturn = -1

//IF dw_label_assignment.SetTransObject (SQLCA) = 1 THEN
	IF dw_label_assignment.fu_Retrieve (dw_label_assignment.c_PromptChanges, dw_label_assignment.c_NoReselectRows) = 0 THEN
		fu_UpdatePreview ()
		l_nReturn = 0
	END IF
//END IF

RETURN l_nReturn
end function

public subroutine fu_showcurrentlabelsinpreview ();/*****************************************************************************************
   Function:   fu_ShowCurrentLabelsInPreview
   Purpose:    Update the preview pane to show labels as currently defined.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
	07/01/03 M. Caruso    Added code to update the city_state_zip_t combined label.
	07/07/03 M. Caruso    Modified to call gf_AllowQuotesInLabels ().
*****************************************************************************************/

STRING	l_cLabelName, l_cLabelText, l_cPrefix, l_cComboLabel
INTEGER	l_nRowCount, l_nRow, l_nPosition

l_nRowCount = dw_label_assignment.RowCount()
IF l_nRowCount > 0 THEN
	
	FOR l_nRow = 1 TO l_nRowCount
		
		l_cLabelName = dw_label_assignment.GetItemString (l_nRow, "column_name") + "_t" // this field does not appear in the display
		l_cLabelText = gf_AllowQuotesInLabels (dw_label_assignment.GetItemString (l_nRow, "field_label") + ":")

		IF dw_preview_window.Describe (l_cLabelName + ".Text") <> "!" THEN
	
			// update the label in the preview window if the label item exists
			dw_preview_window.Modify (l_cLabelName + ".Text='" + l_cLabelText + "'")
	
		END IF
		
		// build the combined label text
		l_nPosition = Pos (l_cLabelName, '_city_t', 1)
		IF l_nPosition > 0 THEN
			
			l_cPrefix = Left (l_cLabelName, Pos (l_cLabelName, '_', 1))
			l_cComboLabel = dw_label_assignment.GetItemString (dw_label_assignment.Find ("column_name = '" + l_cPrefix + "city'", 1, l_nRowCount), 'field_label') + ', ' + &
								 dw_label_assignment.GetItemString (dw_label_assignment.Find ("column_name = '" + l_cPrefix + "state'", 1, l_nRowCount), 'field_label') + ', ' + &
								 dw_label_assignment.GetItemString (dw_label_assignment.Find ("column_name = '" + l_cPrefix + "zip'", 1, l_nRowCount), 'field_label')
								
		END IF
		
	NEXT
	
	// update the combined City, State, Zip label if it exists
	IF dw_preview_window.Describe ("city_state_zip_t.Text") <> "!" THEN
		
		// update the label in the preview window if the label item exists
		dw_preview_window.Modify ("city_state_zip_t.Text='" + gf_AllowQuotesInLabels (l_cComboLabel) + "'")

	END IF
	
END IF
end subroutine

on u_field_label_maintenance.create
int iCurrent
call super::create
this.rb_search=create rb_search
this.rb_demographic=create rb_demographic
this.st_preview_selector=create st_preview_selector
this.dw_preview_window=create dw_preview_window
this.st_field_label_assignment=create st_field_label_assignment
this.st_source_type=create st_source_type
this.dw_label_assignment=create dw_label_assignment
this.ddlb_source_types=create ddlb_source_types
this.gb_preview=create gb_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_search
this.Control[iCurrent+2]=this.rb_demographic
this.Control[iCurrent+3]=this.st_preview_selector
this.Control[iCurrent+4]=this.dw_preview_window
this.Control[iCurrent+5]=this.st_field_label_assignment
this.Control[iCurrent+6]=this.st_source_type
this.Control[iCurrent+7]=this.dw_label_assignment
this.Control[iCurrent+8]=this.ddlb_source_types
this.Control[iCurrent+9]=this.gb_preview
end on

on u_field_label_maintenance.destroy
call super::destroy
destroy(this.rb_search)
destroy(this.rb_demographic)
destroy(this.st_preview_selector)
destroy(this.dw_preview_window)
destroy(this.st_field_label_assignment)
destroy(this.st_source_type)
destroy(this.dw_label_assignment)
destroy(this.ddlb_source_types)
destroy(this.gb_preview)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    Initialize the container object and it's controls.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
	06/12/03 M. Caruso    Moved the bulk of this code to fu_UpdateContainerOnSourceChange.
*****************************************************************************************/

ddlb_source_types.SelectItem(1)

dw_label_assignment.SetTransObject (SQLCA)
fu_UpdateContainerOnSourceChange (1)
i_nPreviousIndex = 1
end event

type rb_search from radiobutton within u_field_label_maintenance
integer x = 210
integer y = 568
integer width = 453
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search View"
boolean automatic = false
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Perform this functionality when this radio button is clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
*****************************************************************************************/

IF NOT this.checked THEN
	
	rb_demographic.checked = FALSE
	this.checked = TRUE
	
	// add code to update the preview datawindow...
	fu_UpdatePreview ()
	
END IF
end event

type rb_demographic from radiobutton within u_field_label_maintenance
integer x = 210
integer y = 480
integer width = 576
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Demographic View"
boolean checked = true
boolean automatic = false
borderstyle borderstyle = stylelowered!
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Perform this functionality when this radio button is clicked.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
*****************************************************************************************/

IF NOT this.checked THEN
	
	rb_search.checked = FALSE
	this.checked = TRUE
	
	// add code to update the preview datawindow...
	fu_UpdatePreview ()
	
END IF
end event

type st_preview_selector from statictext within u_field_label_maintenance
integer x = 78
integer y = 384
integer width = 430
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Preview Mode"
boolean focusrectangle = false
end type

type dw_preview_window from u_dw_std within u_field_label_maintenance
integer x = 78
integer y = 816
integer width = 3415
integer height = 724
integer taborder = 30
string dataobject = ""
boolean vscrollbar = true
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_SetOptions
   Purpose:    Set the options for this datawindow control to define it's functionality.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions( SQLCA, c_NullDW, c_Default )
end event

type st_field_label_assignment from statictext within u_field_label_maintenance
integer x = 1285
integer y = 28
integer width = 594
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Demographic Fields"
boolean focusrectangle = false
end type

type st_source_type from statictext within u_field_label_maintenance
integer x = 78
integer y = 28
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Source Type"
boolean focusrectangle = false
end type

type dw_label_assignment from u_dw_std within u_field_label_maintenance
integer x = 1285
integer y = 112
integer width = 2208
integer height = 600
integer taborder = 20
string dataobject = "d_tm_fieldlabel_maintenance"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_SetOptions
   Purpose:    Set the options for this datawindow control to define it's functionality.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions( SQLCA, & 
					c_NullDW, & 
					c_SelectOnRowFocusChange + &
					c_ModifyOK + &
					c_ModifyOnOpen + &
					c_NoEnablePopup + &
					c_NoRetrieveOnOpen + &
					c_NoInactiveRowPointer + &
					c_NoActiveRowPointer )
end event

event editchanged;call super::editchanged;/*****************************************************************************************
   Event:      editChanged
   Purpose:    Update the preview datawindow as the user edits a field label.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
	07/01/03 M. Caruso    Added code to update the city_state_zip_t combined label.
	07/03/03 M. Caruso    Modified to call gf_AllowQuotesInLabels (). Also corrected the
								 code that updates the label. It had been set to display the
								 combolabel value instead of the data argument.
*****************************************************************************************/

INTEGER	l_nPosition
STRING	l_cLabelName, l_cComboLabel, l_cPrefix

l_cLabelName = GetItemString (row, "column_name") + "_t" // this field does not appear in the display

// determine if the city_state_zip_t combined label should be updated
CHOOSE CASE l_cLabelName
	CASE 'consum_city_t', 'employ_city_t', 'provid_city_t', 'other_city_t'
		l_cPrefix = Left (l_cLabelName, Pos (l_cLabelName, '_', 1))
		l_cComboLabel = data + ', ' + &
							 GetItemString (Find ("column_name = '" + l_cPrefix + "state'", 1, RowCount()), 'field_label') + ', ' + &
							 GetItemString (Find ("column_name = '" + l_cPrefix + "zip'", 1, RowCount()), 'field_label')
		
	CASE 'consum_state_t', 'employ_state_t', 'provid_state_t', 'other_state_t'
		l_cPrefix = Left (l_cLabelName, Pos (l_cLabelName, '_', 1))
		l_cComboLabel = GetItemString (Find ("column_name = '" + l_cPrefix + "city'", 1, RowCount()), 'field_label') + ', ' + &
							 data + ', ' + &
							 GetItemString (Find ("column_name = '" + l_cPrefix + "zip'", 1, RowCount()), 'field_label')
		
	CASE 'consum_zip_t', 'employ_zip_t', 'provid_zip_t', 'other_zip_t'
		l_cPrefix = Left (l_cLabelName, Pos (l_cLabelName, '_', 1))
		l_cComboLabel = GetItemString (Find ("column_name = '" + l_cPrefix + "city'", 1, RowCount()), 'field_label') + ', ' + &
							 GetItemString (Find ("column_name = '" + l_cPrefix + "state'", 1, RowCount()), 'field_label') + ', ' + &
							 data
		
	CASE ELSE
		l_cComboLabel = ''
		
END CHOOSE

// update this specific label
IF dw_preview_window.Describe (l_cLabelName + ".Text") <> "!" THEN
	
	// update the label in the preview window if the label item exists
	dw_preview_window.Modify (l_cLabelName + ".Text='" + gf_AllowQuotesInLabels (data) + ":'")
	
END IF

// update the combined label if needed
IF l_cComboLabel <> "" THEN
	IF dw_preview_window.Describe ("city_state_zip_t.Text") <> "!" THEN
		
		// update the label in the preview window if the label item exists
		dw_preview_window.Modify ("city_state_zip_t.Text='" + gf_AllowQuotesInLabels (l_cComboLabel) + ":'")
		
	END IF
END IF
end event

event losefocus;call super::losefocus;/*****************************************************************************************
   Event:      loseFocus
   Purpose:    Perform these actions when this datawindow loses focus.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/11/03 M. Caruso    Created.
*****************************************************************************************/

AcceptText ()
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve data from the database for this DataWindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/13/03 M. Caruso    Created.
*****************************************************************************************/

Retrieve (i_cSourceType)

end event

type ddlb_source_types from dropdownlistbox within u_field_label_maintenance
integer x = 78
integer y = 112
integer width = 951
integer height = 400
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"Member","Provider","Employer Group","Other"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;/*****************************************************************************************
   Event:      selectionChanged
   Purpose:    Update the rest of the container based on the newly selected item.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/10/03 M. Caruso    Created.
	06/12/03 M. Caruso    Make sure the user is prompted to save changes if they exist
								 before retrieving new records.
	06/12/03 M. Caruso    Moved the bulk of this code to fu_UpdateContainerOnSourceChange.
								 Added code to handle Cancel operation in Save prompt.
*****************************************************************************************/

IF fu_UpdateContainerOnSourceChange (index) = 0 THEN
	i_nPreviousIndex = index
ELSE
	SelectItem (i_nPreviousIndex)
END IF
end event

type gb_preview from groupbox within u_field_label_maintenance
integer x = 37
integer y = 744
integer width = 3497
integer height = 820
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Preview"
borderstyle borderstyle = stylelowered!
end type

