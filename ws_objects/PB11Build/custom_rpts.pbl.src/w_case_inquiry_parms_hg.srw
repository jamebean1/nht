$PBExportHeader$w_case_inquiry_parms_hg.srw
$PBExportComments$Used to gather parameters for the HealthGuard Case Inquiry Report
forward
global type w_case_inquiry_parms_hg from w_response_std
end type
type rb_allcases from radiobutton within w_case_inquiry_parms_hg
end type
type rb_allappeals from radiobutton within w_case_inquiry_parms_hg
end type
type rb_levelone from radiobutton within w_case_inquiry_parms_hg
end type
type rb_leveltwo from radiobutton within w_case_inquiry_parms_hg
end type
type rb_external from radiobutton within w_case_inquiry_parms_hg
end type
type cbx_complaint from checkbox within w_case_inquiry_parms_hg
end type
type cbx_grievance from checkbox within w_case_inquiry_parms_hg
end type
type cb_category_details from commandbutton within w_case_inquiry_parms_hg
end type
type ddlb_case_type from dropdownlistbox within w_case_inquiry_parms_hg
end type
type st_category from statictext within w_case_inquiry_parms_hg
end type
type dw_category_org from u_outliner_std within w_case_inquiry_parms_hg
end type
type rb_all from radiobutton within w_case_inquiry_parms_hg
end type
type rb_first from radiobutton within w_case_inquiry_parms_hg
end type
type cb_cancel from commandbutton within w_case_inquiry_parms_hg
end type
type cb_ok from commandbutton within w_case_inquiry_parms_hg
end type
type b_calendar_from from commandbutton within w_case_inquiry_parms_hg
end type
type b_calendar_to from commandbutton within w_case_inquiry_parms_hg
end type
type em_from from editmask within w_case_inquiry_parms_hg
end type
type em_to from editmask within w_case_inquiry_parms_hg
end type
type st_from from statictext within w_case_inquiry_parms_hg
end type
type st_to from statictext within w_case_inquiry_parms_hg
end type
type gb_date_range from groupbox within w_case_inquiry_parms_hg
end type
type st_case_type from statictext within w_case_inquiry_parms_hg
end type
type gb_note_selection from groupbox within w_case_inquiry_parms_hg
end type
type gb_1 from groupbox within w_case_inquiry_parms_hg
end type
type gb_selection_criteria from groupbox within w_case_inquiry_parms_hg
end type
end forward

global type w_case_inquiry_parms_hg from w_response_std
integer width = 1947
integer height = 1884
string title = "Case Inquiry Report Parameters"
rb_allcases rb_allcases
rb_allappeals rb_allappeals
rb_levelone rb_levelone
rb_leveltwo rb_leveltwo
rb_external rb_external
cbx_complaint cbx_complaint
cbx_grievance cbx_grievance
cb_category_details cb_category_details
ddlb_case_type ddlb_case_type
st_category st_category
dw_category_org dw_category_org
rb_all rb_all
rb_first rb_first
cb_cancel cb_cancel
cb_ok cb_ok
b_calendar_from b_calendar_from
b_calendar_to b_calendar_to
em_from em_from
em_to em_to
st_from st_from
st_to st_to
gb_date_range gb_date_range
st_case_type st_case_type
gb_note_selection gb_note_selection
gb_1 gb_1
gb_selection_criteria gb_selection_criteria
end type
global w_case_inquiry_parms_hg w_case_inquiry_parms_hg

type variables
STRING i_cDetailView

BOOLEAN	i_bOK
BOOLEAN	i_bMultiCategory

INTEGER  i_nNumSelected1
INTEGER  i_nNumSelected2
INTEGER  i_nNumSelected3

DATE		i_dFromDate
DATE		i_dToDate

DATETIME i_dtStartDate
DATETIME i_dtEndDate

STRING	i_cUserType
STRING	i_cUserList
STRING	i_cWindowTitle
STRING   i_cDateColumn
STRING   i_cWhereGroupID
STRING   i_cWhereProfID
STRING   i_cCaseType = 'M'
STRING   i_cSourceType = 'A'
STRING   i_cSingleCategory

//S_REPORT_PARMS_HG	i_sReportParmsHG
S_REPORT_PARMS		i_sReportParmsHG
S_CATEGORY_INFO	i_sCurrentCategory

STRING  i_cResetArray[]
end variables

forward prototypes
public subroutine fw_initcategory (string case_type)
public subroutine fw_calcdaterange ()
end prototypes

public subroutine fw_initcategory (string case_type);//*********************************************************************************************
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
		IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_dissat_report_hg' THEN
			l_cWhereClause = l_cTableName + ".category_level = 1 AND " + &
							  l_cTableName + ".case_type = 'C'"
		ELSE
			l_cWhereClause = l_cTableName + ".category_level = 1 AND " + &
								  l_cTableName + ".case_type = '" + case_type + "'"
		END IF
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

dw_category_org.fu_HLOptions(dw_category_org.c_ShowLines)

dw_category_org.fu_HLCreate (SQLCA, l_nMaxLevels)

em_from.SetFocus()
end subroutine

public subroutine fw_calcdaterange ();/*****************************************************************************************
   Function:   fw_calcdaterange
   Purpose:    Calculate the date range specified on the window.
   Parameters: NONE
   Returns:    NONE

   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson   Original Version
*****************************************************************************************/

DATE		l_dStartDate, l_dEndDate
TIME		l_tStartOfDay, l_tEndOfDay

l_tStartOfDay = Time ('00:00:00.000')
l_tEndOfDay = Time ('23:59:59.999')

em_from.GetData (l_dStartDate)
em_to.GetData (l_dEndDate)
i_dtStartDate = DATETIME (l_dStartDate, l_tStartOfDay)
i_dtEndDate = DATETIME (l_dEndDate, l_tEndOfDay)
end subroutine

on w_case_inquiry_parms_hg.create
int iCurrent
call super::create
this.rb_allcases=create rb_allcases
this.rb_allappeals=create rb_allappeals
this.rb_levelone=create rb_levelone
this.rb_leveltwo=create rb_leveltwo
this.rb_external=create rb_external
this.cbx_complaint=create cbx_complaint
this.cbx_grievance=create cbx_grievance
this.cb_category_details=create cb_category_details
this.ddlb_case_type=create ddlb_case_type
this.st_category=create st_category
this.dw_category_org=create dw_category_org
this.rb_all=create rb_all
this.rb_first=create rb_first
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.b_calendar_from=create b_calendar_from
this.b_calendar_to=create b_calendar_to
this.em_from=create em_from
this.em_to=create em_to
this.st_from=create st_from
this.st_to=create st_to
this.gb_date_range=create gb_date_range
this.st_case_type=create st_case_type
this.gb_note_selection=create gb_note_selection
this.gb_1=create gb_1
this.gb_selection_criteria=create gb_selection_criteria
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_allcases
this.Control[iCurrent+2]=this.rb_allappeals
this.Control[iCurrent+3]=this.rb_levelone
this.Control[iCurrent+4]=this.rb_leveltwo
this.Control[iCurrent+5]=this.rb_external
this.Control[iCurrent+6]=this.cbx_complaint
this.Control[iCurrent+7]=this.cbx_grievance
this.Control[iCurrent+8]=this.cb_category_details
this.Control[iCurrent+9]=this.ddlb_case_type
this.Control[iCurrent+10]=this.st_category
this.Control[iCurrent+11]=this.dw_category_org
this.Control[iCurrent+12]=this.rb_all
this.Control[iCurrent+13]=this.rb_first
this.Control[iCurrent+14]=this.cb_cancel
this.Control[iCurrent+15]=this.cb_ok
this.Control[iCurrent+16]=this.b_calendar_from
this.Control[iCurrent+17]=this.b_calendar_to
this.Control[iCurrent+18]=this.em_from
this.Control[iCurrent+19]=this.em_to
this.Control[iCurrent+20]=this.st_from
this.Control[iCurrent+21]=this.st_to
this.Control[iCurrent+22]=this.gb_date_range
this.Control[iCurrent+23]=this.st_case_type
this.Control[iCurrent+24]=this.gb_note_selection
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_selection_criteria
end on

on w_case_inquiry_parms_hg.destroy
call super::destroy
destroy(this.rb_allcases)
destroy(this.rb_allappeals)
destroy(this.rb_levelone)
destroy(this.rb_leveltwo)
destroy(this.rb_external)
destroy(this.cbx_complaint)
destroy(this.cbx_grievance)
destroy(this.cb_category_details)
destroy(this.ddlb_case_type)
destroy(this.st_category)
destroy(this.dw_category_org)
destroy(this.rb_all)
destroy(this.rb_first)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.b_calendar_from)
destroy(this.b_calendar_to)
destroy(this.em_from)
destroy(this.em_to)
destroy(this.st_from)
destroy(this.st_to)
destroy(this.gb_date_range)
destroy(this.st_case_type)
destroy(this.gb_note_selection)
destroy(this.gb_1)
destroy(this.gb_selection_criteria)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//  Event:   pc_setoptions
//  Purpose: To set User Object options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/13/02 C. Jackson  Original Version
//***********************************************************************************************

fw_SetOptions (c_NoEnablePopup)

ddlb_case_type.SelectItem (3)

Post fw_initcategory ("C")

i_cCaseType = 'C'		


end event

event pc_closequery;call super::pc_closequery;/*****************************************************************************************
   Event:      pc_closequery
   Purpose:    Perform final window processing and determine if Close process should
					continue.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
	06/20/02 C. Jackson  Add Another checkbox for No Appeals
*****************************************************************************************/

STRING	l_cStartDate, l_cEndDate, l_cBlankDate = '00/00/0000', l_cKeys[], l_cSelectedKeys[]
LONG     l_nIndex, l_nLastRow, l_nNumSelected

IF i_bOK THEN
	
	l_cStartDate = em_from.Text
	l_cEndDate = em_to.Text
	
	IF l_cStartDate = l_cBlankDate THEN
		
		IF l_cEndDate = l_cBlankDate THEN
			MessageBox (gs_appname, 'You must specify Begin and End dates.')
		ELSE
			MessageBox (gs_appname, 'You must specify a Begin Date.')
		END IF
		Error.i_FWError = c_Fatal
		em_from.SetFocus ()
		RETURN 0
		
	ELSE
		
		IF l_cEndDate = l_cBlankDate THEN
	
			// if a custom date range is specified and either date is not set, notify the user
			MessageBox (gs_appname, 'You must specify an end date.')
			Error.i_FWError = c_Fatal
			em_to.SetFocus ()
			RETURN 0
			
		ELSE
		
			IF DaysAfter(Date(l_cEndDate),Date(l_cStartDate)) > 0 THEN
				messagebox(gs_AppName, 'The End Date must be greater than the Begin Date.')
				Error.i_FWError = c_Fatal
				em_to.SetFocus()
				RETURN 0
			END IF			
			
		END IF
		
		
	END IF
	
	IF rb_levelone.Checked THEN
		i_sReportParmsHG.appeal_level = '1'
	ELSEIF rb_leveltwo.Checked THEN
		i_sReportParmsHG.appeal_level = '2'
	ELSEIF rb_external.Checked THEN
		i_sReportParmsHG.report_type = '3'
		i_sReportParmsHG.appeal_level = '3'
	ELSEIF rb_allappeals.Checked THEN
		i_sReportParmsHG.report_type = 'All'
		i_sReportParmsHG.appeal_level = 'All'
	ELSE
		i_sReportParmsHG.report_type = 'None'
		i_sReportParmsHG.appeal_level = 'None'
	END IF
	
	
	IF cbx_complaint.Checked THEN
		IF cbx_grievance.Checked THEN
			IF i_sReportParmsHG.appeal_level = '1' THEN
				i_sReportParmsHG.report_type = '1-Both'
			ELSE
				i_sReportParmsHG.report_type = '2-Both'			
			END IF
		ELSE
			IF i_sReportParmsHG.appeal_level = '1' THEN
				i_sReportParmsHG.report_type = '1-Complaint'
			ELSE
				i_sReportParmsHG.report_type = '2-Complaint'
			END IF
		END IF
	ELSEIF cbx_grievance.Checked THEN
		IF i_sReportParmsHG.appeal_level = '1' THEN
			i_sReportParmsHG.report_type = '1-Grievance'
		ELSE
			i_sReportParmsHG.report_type = '2-Grievance'
		END IF
		
	ELSE
		IF i_sReportParmsHG.appeal_level = '1' OR &
		   i_sReportParmsHG.appeal_level = '2' THEN

			MessageBox (gs_appname, 'You must specify Complaint, Grievance or Both.')
			Error.i_FWError = c_Fatal
			cbx_Complaint.SetFocus ()
			RETURN 0
		END IF
			
			
	END IF
	
		
	// determine the specified date range
	fw_CalcDateRange ()
	
	// convert date to string to pass to stored procedure
	l_cStartDate = STRING(i_dtStartDate)
	l_cEndDate = STRING(i_dtEndDate)
	
	// set the return values based on the settings in the window.
	i_sReportParmsHG.start_date_string = l_cStartDate
	i_sReportParmsHG.end_date_string = l_cEndDate
	
ELSE
	
	// set blank return values
	SetNull(i_sReportParmsHG.start_date)
	SetNull(i_sReportParmsHG.end_date)
	
END IF


end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Pass the return values via Message.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

message.PowerObjectParm = i_sReportParmsHG
end event

type rb_allcases from radiobutton within w_case_inquiry_parms_hg
integer x = 1243
integer y = 1068
integer width = 535
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All Cases"
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To disable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************


cbx_Complaint.Checked = FALSE
cbx_Grievance.Checked = FALSE
cbx_Complaint.Enabled = FALSE
cbx_Grievance.Enabled = FALSE


end event

type rb_allappeals from radiobutton within w_case_inquiry_parms_hg
integer x = 1243
integer y = 976
integer width = 535
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All Appeal Levels"
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To disable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************


cbx_Complaint.Checked = FALSE
cbx_Grievance.Checked = FALSE
cbx_Complaint.Enabled = FALSE
cbx_Grievance.Enabled = FALSE


end event

type rb_levelone from radiobutton within w_case_inquiry_parms_hg
integer x = 1243
integer y = 700
integer width = 480
integer height = 80
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Level I Appeals"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To enable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************

cbx_Complaint.Enabled = TRUE
cbx_Grievance.Enabled = TRUE

end event

type rb_leveltwo from radiobutton within w_case_inquiry_parms_hg
integer x = 1243
integer y = 792
integer width = 494
integer height = 80
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Level II Appeals"
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To enable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************

cbx_Complaint.Enabled = TRUE
cbx_Grievance.Enabled = TRUE

end event

type rb_external from radiobutton within w_case_inquiry_parms_hg
integer x = 1243
integer y = 884
integer width = 535
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "External Appeals"
borderstyle borderstyle = stylelowered!
end type

event clicked;//***********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To disable the Complaint and Grievance checkboxes if selected
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/30/02 C. Jackson  Original version
//***********************************************************************************************

cbx_Complaint.Checked = FALSE
cbx_Grievance.Checked = FALSE
cbx_Complaint.Enabled = FALSE
cbx_Grievance.Enabled = FALSE

end event

type cbx_complaint from checkbox within w_case_inquiry_parms_hg
integer x = 1243
integer y = 1288
integer width = 402
integer height = 80
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Complaint"
borderstyle borderstyle = stylelowered!
end type

type cbx_grievance from checkbox within w_case_inquiry_parms_hg
integer x = 1243
integer y = 1376
integer width = 402
integer height = 80
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grievance"
borderstyle borderstyle = stylelowered!
end type

type cb_category_details from commandbutton within w_case_inquiry_parms_hg
integer x = 1125
integer y = 1656
integer width = 110
integer height = 80
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Open the details datawindow for categories
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//  06/03/02 C. Jackson  Disable ddlb_case_type if multiple categories
//  07/10/03 M. Caruso   Set category_array based on PCCA.Parm which is returned from the child
//								 window.
//**********************************************************************************************

LONG l_nSelected

FWCA.MGR.fu_OpenWindow(w_category_details_hg, 0)

// get the selected category IDs from the returned variable (PCCA.Parm)
i_sReportParmsHG.category_array = PCCA.Parm

IF UpperBound( i_sReportParmsHG.category_array ) > 0 THEN	
	
	// Disable the outliner if multiple have been selected
	l_nSelected = 1
	l_nSelected = dw_category_org.fu_HLGetSelectedRow(l_nSelected)

	IF l_nSelected > 0 THEN
		//Need to deselect all rows in Category Outliner
		dw_category_org.fu_HLClearSelectedRows()

	END IF
	
	dw_category_org.Enabled = FALSE	
	ddlb_case_type.Enabled = FALSE
	IF POS(st_category.Text,"(") = 0 THEN
		st_category.Text = st_category.Text + '  (Multiple, See Details)'
	END IF		
ELSE
	
	st_category.text = 'Category:'
	dw_category_org.Enabled = TRUE
	ddlb_case_type.Enabled = TRUE
	
	l_nSelected = 1
	l_nSelected = dw_category_org.fu_HLGetSelectedRow(l_nSelected)
	
	IF l_nSelected = 0 THEN
		// If there are no rows selected then select the first
		dw_category_org.fu_HLSetSelectedRow(1)
	END IF


END IF



end event

type ddlb_case_type from dropdownlistbox within w_case_inquiry_parms_hg
integer x = 87
integer y = 452
integer width = 1015
integer height = 448
integer taborder = 70
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

type st_category from statictext within w_case_inquiry_parms_hg
integer x = 87
integer y = 572
integer width = 1024
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

type dw_category_org from u_outliner_std within w_case_inquiry_parms_hg
integer x = 87
integer y = 648
integer width = 1015
integer height = 1084
integer taborder = 80
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
fu_HLGetRowKey(l_nRow, l_cKeys[])
i_cSingleCategory = l_cKeys[l_nLevel]




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

type rb_all from radiobutton within w_case_inquiry_parms_hg
integer x = 1467
integer y = 124
integer width = 320
integer height = 80
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All Notes"
borderstyle borderstyle = stylelowered!
end type

type rb_first from radiobutton within w_case_inquiry_parms_hg
integer x = 1083
integer y = 124
integer width = 338
integer height = 80
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "First Note"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_case_inquiry_parms_hg
integer x = 1531
integer y = 1660
integer width = 320
integer height = 108
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the Cancel button

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

i_bOK = FALSE
Close (PARENT)
end event

type cb_ok from commandbutton within w_case_inquiry_parms_hg
integer x = 1531
integer y = 1524
integer width = 320
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Process the OK button

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

STRING l_cGroupId, l_cProfID
DATE l_dStartDate, l_dEndDate
BOOLEAN	l_bBadDate = FALSE
LONG l_nSelectedRows1[], l_nSelectedRows2[], l_nSelectedRows3[], l_nIndex, l_nSelected
LONG l_nLength

IF rb_first.Checked = TRUE THEN
	i_sReportParmsHG.note_selection = 'First'
ELSE
	i_sReportParmsHG.note_selection = 'All'
END IF

l_dStartDate = DATE(em_from.Text)
l_dEndDate = DATE(em_to.Text)

IF YEAR(l_dStartDate) < 1753 THEN
	messagebox(gs_AppName,'Please enter a valid start date.')
	em_from.SetFocus()
	l_bBadDate = TRUE
	
ELSEIF YEAR(l_dEndDate) < 1753 THEN
	messagebox(gs_AppName,'Please enter a valid end date.')
	em_to.SetFocus()

	l_bBadDate = TRUE
	
END IF


IF NOT i_bMultiCategory THEN
		
	i_sReportParmsHG.category_array[1] = i_cSingleCategory
		
END IF
	
	
IF l_bBadDate THEN
	
	RETURN
	
ELSE
	
	i_bOK = TRUE
	
	CloseWithReturn (PARENT, i_sReportParmsHG)

END IF



end event

type b_calendar_from from commandbutton within w_case_inquiry_parms_hg
integer x = 654
integer y = 92
integer width = 110
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/13/02 C. Jackson  Original Version
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = PARENT.X + THIS.X
l_nY = PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX )
l_cY = String( l_nY + l_nHeight )

l_cCalendarDate = em_from.Text
IF l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dFromDate = l_dtCalendarDate
i_dToDate = date(em_to.text)

// Validate the value against the TO field
IF (em_to.Text <> '00/00/0000') AND (i_dToDate < i_dFromDate) THEN
	
	messagebox(gs_AppName,'Begin Date must be less than End Date.')
	em_from.SetFocus()
	
ELSE

	//Add the date to the datawindow
	em_from.Text = string(l_dtCalendarDate)
	
	//Move the cursor to the next field
	em_to.SetFocus()

END IF


end event

type b_calendar_to from commandbutton within w_case_inquiry_parms_hg
integer x = 654
integer y = 200
integer width = 110
integer height = 80
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/13/02 C. Jackson  Original Version
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = PARENT.X + THIS.X
l_nY = PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX )
l_cY = String( l_nY + l_nHeight )

//Only one button(calendar) so open the calendar window
l_cCalendarDate = em_to.Text
IF l_cCalendarDate = 'none' OR l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid date set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dToDate = l_dtCalendarDate

IF em_from.Text = '00/00/0000' THEN
	messagebox(gs_AppName,'A Begin Date is required.')
	em_from.SetFocus()
END IF
IF i_dFromDate > i_dToDate THEN
	messagebox(gs_AppName,'The End Date must be greater than the Begin Date.')
	em_to.SetFocus()
ELSE
	//Add the date to the datawindow
	em_to.Text = string(l_dtCalendarDate)
END IF

end event

type em_from from editmask within w_case_inquiry_parms_hg
integer x = 261
integer y = 88
integer width = 379
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type em_to from editmask within w_case_inquiry_parms_hg
integer x = 261
integer y = 192
integer width = 379
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "00/00/0000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type st_from from statictext within w_case_inquiry_parms_hg
integer x = 73
integer y = 92
integer width = 183
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
boolean enabled = false
string text = "Begin:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_to from statictext within w_case_inquiry_parms_hg
integer x = 91
integer y = 208
integer width = 165
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
boolean enabled = false
string text = "End:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_date_range from groupbox within w_case_inquiry_parms_hg
integer x = 32
integer y = 12
integer width = 763
integer height = 308
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date"
borderstyle borderstyle = stylelowered!
end type

type st_case_type from statictext within w_case_inquiry_parms_hg
integer x = 87
integer y = 376
integer width = 361
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

type gb_note_selection from groupbox within w_case_inquiry_parms_hg
integer x = 997
integer y = 12
integer width = 855
integer height = 312
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Note Selection"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_case_inquiry_parms_hg
integer x = 1166
integer y = 616
integer width = 686
integer height = 568
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Level"
borderstyle borderstyle = stylelowered!
end type

type gb_selection_criteria from groupbox within w_case_inquiry_parms_hg
integer x = 1166
integer y = 1208
integer width = 686
integer height = 276
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Type"
borderstyle borderstyle = stylelowered!
end type

