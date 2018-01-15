$PBExportHeader$u_tab_case_details.sru
$PBExportComments$This tab folder contains the various detail tabs used on the case screen.
forward
global type u_tab_case_details from u_tab_std
end type
type tabpage_case_notes from u_tabpage_case_notes within u_tab_case_details
end type
type tabpage_case_notes from u_tabpage_case_notes within u_tab_case_details
end type
type tabpage_case_details from u_tabpage_case_details within u_tab_case_details
end type
type tabpage_case_details from u_tabpage_case_details within u_tab_case_details
end type
type tabpage_case_properties from u_tabpage_case_properties within u_tab_case_details
end type
type tabpage_case_properties from u_tabpage_case_properties within u_tab_case_details
end type
type tabpage_carve_out from u_tabpage_carve_out within u_tab_case_details
end type
type tabpage_carve_out from u_tabpage_carve_out within u_tab_case_details
end type
type tabpage_case_attachments from u_tabpage_case_attachments within u_tab_case_details
end type
type tabpage_case_attachments from u_tabpage_case_attachments within u_tab_case_details
end type
type tabpage_case_forms from u_tabpage_case_forms within u_tab_case_details
end type
type tabpage_case_forms from u_tabpage_case_forms within u_tab_case_details
end type
type tabpage_category from u_tabpage_category within u_tab_case_details
end type
type tabpage_category from u_tabpage_category within u_tab_case_details
end type
type tabpage_appeals from u_tabpage_appeals within u_tab_case_details
end type
type tabpage_appeals from u_tabpage_appeals within u_tab_case_details
end type
type tabpage_eligibility from u_tabpage_eligibility within u_tab_case_details
end type
type tabpage_eligibility from u_tabpage_eligibility within u_tab_case_details
end type
end forward

global type u_tab_case_details from u_tab_std
integer width = 3552
integer height = 904
integer textsize = -8
string facename = "Tahoma"
boolean fixedwidth = true
boolean raggedright = false
boolean boldselectedtext = true
alignment alignment = center!
tabpage_case_notes tabpage_case_notes
tabpage_case_details tabpage_case_details
tabpage_case_properties tabpage_case_properties
tabpage_carve_out tabpage_carve_out
tabpage_case_attachments tabpage_case_attachments
tabpage_case_forms tabpage_case_forms
tabpage_category tabpage_category
tabpage_appeals tabpage_appeals
tabpage_eligibility tabpage_eligibility
end type
global u_tab_case_details u_tab_case_details

type variables
W_CREATE_MAINTAIN_CASE	i_wParentWindow

Boolean i_bFromNew

//JWhite Added 9.1.2005
string is_using_new_appeals
end variables

on u_tab_case_details.create
this.tabpage_case_notes=create tabpage_case_notes
this.tabpage_case_details=create tabpage_case_details
this.tabpage_case_properties=create tabpage_case_properties
this.tabpage_carve_out=create tabpage_carve_out
this.tabpage_case_attachments=create tabpage_case_attachments
this.tabpage_case_forms=create tabpage_case_forms
this.tabpage_category=create tabpage_category
this.tabpage_appeals=create tabpage_appeals
this.tabpage_eligibility=create tabpage_eligibility
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_case_notes
this.Control[iCurrent+2]=this.tabpage_case_details
this.Control[iCurrent+3]=this.tabpage_case_properties
this.Control[iCurrent+4]=this.tabpage_carve_out
this.Control[iCurrent+5]=this.tabpage_case_attachments
this.Control[iCurrent+6]=this.tabpage_case_forms
this.Control[iCurrent+7]=this.tabpage_category
this.Control[iCurrent+8]=this.tabpage_appeals
this.Control[iCurrent+9]=this.tabpage_eligibility
end on

on u_tab_case_details.destroy
call super::destroy
destroy(this.tabpage_case_notes)
destroy(this.tabpage_case_details)
destroy(this.tabpage_case_properties)
destroy(this.tabpage_carve_out)
destroy(this.tabpage_case_attachments)
destroy(this.tabpage_case_forms)
destroy(this.tabpage_category)
destroy(this.tabpage_appeals)
destroy(this.tabpage_eligibility)
end on

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    initialize the tab folder

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	09/28/00 M. Caruso    Created.
	10/30/00 M. Caruso    Added resizing code.
	4/13/2001 K. Claver   Changed to correctly use the new resize service.
	11/30/20001 K. Claver Added tabpage_case_attachments to the list of tabpages
								 registered with the resize service.
	1/16/2002 K. Claver   Added tabpage_case_forms to the list of tabs registered
								 with the resize service.
*****************************************************************************************/

i_wParentWindow = w_create_maintain_case

THIS.of_SetResize (TRUE)
IF IsValid (THIS.inv_resize) THEN
	// register and resize the tabs
	THIS.inv_resize.of_Register (tabpage_case_notes, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (tabpage_case_details, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (tabpage_case_properties, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (tabpage_carve_out, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (tabpage_category, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (tabpage_case_attachments, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (tabpage_case_forms, "ScaleToRight&Bottom")
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 8.30.2005 - Adding Appeals Tab
	//-----------------------------------------------------------------------------------------------------------------------------------
	THIS.inv_resize.of_Register (tabpage_appeals, "ScaleToRight&Bottom")
END IF


end event

event selectionchanging;call super::selectionchanging;/*****************************************************************************************
   Event:      selectionchanging
   Purpose:    Please see PB documentation for this event

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/29/00 K. Claver    Added code to check to save changes after picked a category and
								 before switch tabs.
	03/30/01 K. Claver    Added code to enable/disable the delete menu item if on the
	 							 carveout tab, there are rows to delete and the case is open.
	07/26/01 M. Caruso    Added code to manage the availability of the category tree view.
	01/25/02 K. Claver    Adjusted the position of the category tabe in relation to the
								 newly added attachments and forms tabs.
	03/25/02 K. Claver    Added code to check if the case is locked before enabling the
								 delete menu item.
	01/31/03 M. Caruso    Updated rule for enabling categories tab tree view/datawindow to
								 be enabled whenever the case is open.
	02/17/03 M. Caruso    All code for enabling/disabling category tree view has been moved
								 to fu_SetOpenCaseGUI, fu_SetClosedCaseGUI and fu_SetLockedCaseGUI
	08-30-05 J. White		 Got rid of the old commented out code to clean things up.							 
*****************************************************************************************/

STRING			l_cCaseStatus, l_cCategoryID
U_DW_STD			l_dwCaseDetails
U_OUTLINER_STD	l_tvCategories

CHOOSE CASE newindex
	CASE 4
		IF w_create_maintain_case.i_uoCaseDetails.i_cCaseStatus = "O" AND &
			tabpage_carve_out.dw_carve_out_list.RowCount( ) > 0 AND &
			NOT w_create_maintain_case.i_bCaseLocked THEN
			m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = TRUE
		ELSE
			m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
		END IF
		
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Carve Out'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Carve Out'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Carve Out'
		
	CASE 7
		// set the availability of the category selection tree
		l_dwCaseDetails = tabpage_case_details.dw_case_details
		
		l_cCaseStatus = l_dwCaseDetails.GetItemString (1, 'case_log_case_status_id')
		l_cCategoryID = l_dwCaseDetails.GetItemString (1, 'case_log_category_id')
		
		// Update the following menu item as for all other tabs.
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
		
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'
				
	CASE ELSE
		m_create_maintain_case.m_edit.m_deletecasereminder.Enabled = FALSE
		
		m_create_maintain_case.m_edit.m_deletecasereminder.Text					= '&Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.MicroHelp			= 'Delete Case Reminder'
		m_create_maintain_case.m_edit.m_deletecasereminder.ToolBarItemText	= 'Delete Case Reminder'
		
END CHOOSE




end event

event selectionchanged;call super::selectionchanged;//***********************************************************************************************
//
//  Event:   selectionchanged
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  2/28/2002 K. Claver    Added code to set the focus to the datawindow on each of the tabs
//									when the tab is switched to so can use the arrow keys to move up and down
//									the list(if one exists).
//***********************************************************************************************  

//Need to set the focus to the list datawindow each time a tab is selected
//  so can immediately arrow down the list.
CHOOSE CASE newindex
	CASE 1
		tabpage_case_notes.dw_case_notes.SetFocus( )
	CASE 2
		tabpage_case_details.dw_case_details.SetFocus( )
	CASE 3
		tabpage_case_properties.dw_case_properties.SetFocus( )
	CASE 4
		tabpage_carve_out.dw_carve_out_list.SetFocus( )
	CASE 5
		tabpage_case_attachments.dw_attachment_list.SetFocus( )
	CASE 6
		tabpage_case_forms.dw_case_form_list.SetFocus( )
	CASE 7
		tabpage_category.dw_categories.SetFocus( )
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 8.30.2005 - Adding the setfocus to the Appeals tab
	//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 8
		tabpage_appeals.dw_detail.SetFocus( )
END CHOOSE
end event

type tabpage_case_notes from u_tabpage_case_notes within u_tab_case_details
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
string text = "Notes"
end type

type tabpage_case_details from u_tabpage_case_details within u_tab_case_details
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
string text = "Details"
end type

type tabpage_case_properties from u_tabpage_case_properties within u_tab_case_details
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
string text = "  Properties   "
end type

type tabpage_carve_out from u_tabpage_carve_out within u_tab_case_details
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
end type

type tabpage_case_attachments from u_tabpage_case_attachments within u_tab_case_details
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
string text = "Attachments"
end type

type tabpage_case_forms from u_tabpage_case_forms within u_tab_case_details
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
string text = "Forms"
end type

type tabpage_category from u_tabpage_category within u_tab_case_details
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
end type

type tabpage_appeals from u_tabpage_appeals within u_tab_case_details
string tag = "Appeals"
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
string text = "Appeals"
end type

type tabpage_eligibility from u_tabpage_eligibility within u_tab_case_details
boolean visible = false
integer x = 18
integer y = 100
integer width = 3515
integer height = 788
string text = "Eligibility"
end type

