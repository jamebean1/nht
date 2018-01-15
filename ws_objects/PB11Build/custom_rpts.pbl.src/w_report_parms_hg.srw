$PBExportHeader$w_report_parms_hg.srw
$PBExportComments$Used to gather parameters similar to the Performance Statistics reports.
forward
global type w_report_parms_hg from w_response_std
end type
type cbx_all from checkbox within w_report_parms_hg
end type
type st_5 from statictext within w_report_parms_hg
end type
type ddlb_source_type from dropdownlistbox within w_report_parms_hg
end type
type cb_category_details from commandbutton within w_report_parms_hg
end type
type ddlb_case_type from dropdownlistbox within w_report_parms_hg
end type
type cb_pcp_details from commandbutton within w_report_parms_hg
end type
type sle_pcp from singlelineedit within w_report_parms_hg
end type
type cb_con_group_details from commandbutton within w_report_parms_hg
end type
type sle_con_group from singlelineedit within w_report_parms_hg
end type
type cb_group_id_details from commandbutton within w_report_parms_hg
end type
type sle_group_id from singlelineedit within w_report_parms_hg
end type
type cb_region_details from commandbutton within w_report_parms_hg
end type
type sle_region from singlelineedit within w_report_parms_hg
end type
type cb_lob_details from commandbutton within w_report_parms_hg
end type
type sle_lob from singlelineedit within w_report_parms_hg
end type
type st_category from statictext within w_report_parms_hg
end type
type dw_category_org from u_outliner_std within w_report_parms_hg
end type
type st_10 from statictext within w_report_parms_hg
end type
type st_4 from statictext within w_report_parms_hg
end type
type st_3 from statictext within w_report_parms_hg
end type
type st_2 from statictext within w_report_parms_hg
end type
type st_1 from statictext within w_report_parms_hg
end type
type rb_closed from radiobutton within w_report_parms_hg
end type
type rb_opened from radiobutton within w_report_parms_hg
end type
type cb_cancel from commandbutton within w_report_parms_hg
end type
type cb_ok from commandbutton within w_report_parms_hg
end type
type b_calendar_from from commandbutton within w_report_parms_hg
end type
type b_calendar_to from commandbutton within w_report_parms_hg
end type
type st_report_subject from statictext within w_report_parms_hg
end type
type em_from from editmask within w_report_parms_hg
end type
type em_to from editmask within w_report_parms_hg
end type
type st_from from statictext within w_report_parms_hg
end type
type st_to from statictext within w_report_parms_hg
end type
type dw_user_list from u_outliner_std within w_report_parms_hg
end type
type gb_date_range from groupbox within w_report_parms_hg
end type
type st_case_type from statictext within w_report_parms_hg
end type
end forward

global type w_report_parms_hg from w_response_std
integer width = 3374
integer height = 1836
string title = "Report Parameters"
cbx_all cbx_all
st_5 st_5
ddlb_source_type ddlb_source_type
cb_category_details cb_category_details
ddlb_case_type ddlb_case_type
cb_pcp_details cb_pcp_details
sle_pcp sle_pcp
cb_con_group_details cb_con_group_details
sle_con_group sle_con_group
cb_group_id_details cb_group_id_details
sle_group_id sle_group_id
cb_region_details cb_region_details
sle_region sle_region
cb_lob_details cb_lob_details
sle_lob sle_lob
st_category st_category
dw_category_org dw_category_org
st_10 st_10
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
rb_closed rb_closed
rb_opened rb_opened
cb_cancel cb_cancel
cb_ok cb_ok
b_calendar_from b_calendar_from
b_calendar_to b_calendar_to
st_report_subject st_report_subject
em_from em_from
em_to em_to
st_from st_from
st_to st_to
dw_user_list dw_user_list
gb_date_range gb_date_range
st_case_type st_case_type
end type
global w_report_parms_hg w_report_parms_hg

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

on w_report_parms_hg.create
int iCurrent
call super::create
this.cbx_all=create cbx_all
this.st_5=create st_5
this.ddlb_source_type=create ddlb_source_type
this.cb_category_details=create cb_category_details
this.ddlb_case_type=create ddlb_case_type
this.cb_pcp_details=create cb_pcp_details
this.sle_pcp=create sle_pcp
this.cb_con_group_details=create cb_con_group_details
this.sle_con_group=create sle_con_group
this.cb_group_id_details=create cb_group_id_details
this.sle_group_id=create sle_group_id
this.cb_region_details=create cb_region_details
this.sle_region=create sle_region
this.cb_lob_details=create cb_lob_details
this.sle_lob=create sle_lob
this.st_category=create st_category
this.dw_category_org=create dw_category_org
this.st_10=create st_10
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.rb_closed=create rb_closed
this.rb_opened=create rb_opened
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.b_calendar_from=create b_calendar_from
this.b_calendar_to=create b_calendar_to
this.st_report_subject=create st_report_subject
this.em_from=create em_from
this.em_to=create em_to
this.st_from=create st_from
this.st_to=create st_to
this.dw_user_list=create dw_user_list
this.gb_date_range=create gb_date_range
this.st_case_type=create st_case_type
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_all
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.ddlb_source_type
this.Control[iCurrent+4]=this.cb_category_details
this.Control[iCurrent+5]=this.ddlb_case_type
this.Control[iCurrent+6]=this.cb_pcp_details
this.Control[iCurrent+7]=this.sle_pcp
this.Control[iCurrent+8]=this.cb_con_group_details
this.Control[iCurrent+9]=this.sle_con_group
this.Control[iCurrent+10]=this.cb_group_id_details
this.Control[iCurrent+11]=this.sle_group_id
this.Control[iCurrent+12]=this.cb_region_details
this.Control[iCurrent+13]=this.sle_region
this.Control[iCurrent+14]=this.cb_lob_details
this.Control[iCurrent+15]=this.sle_lob
this.Control[iCurrent+16]=this.st_category
this.Control[iCurrent+17]=this.dw_category_org
this.Control[iCurrent+18]=this.st_10
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.st_2
this.Control[iCurrent+22]=this.st_1
this.Control[iCurrent+23]=this.rb_closed
this.Control[iCurrent+24]=this.rb_opened
this.Control[iCurrent+25]=this.cb_cancel
this.Control[iCurrent+26]=this.cb_ok
this.Control[iCurrent+27]=this.b_calendar_from
this.Control[iCurrent+28]=this.b_calendar_to
this.Control[iCurrent+29]=this.st_report_subject
this.Control[iCurrent+30]=this.em_from
this.Control[iCurrent+31]=this.em_to
this.Control[iCurrent+32]=this.st_from
this.Control[iCurrent+33]=this.st_to
this.Control[iCurrent+34]=this.dw_user_list
this.Control[iCurrent+35]=this.gb_date_range
this.Control[iCurrent+36]=this.st_case_type
end on

on w_report_parms_hg.destroy
call super::destroy
destroy(this.cbx_all)
destroy(this.st_5)
destroy(this.ddlb_source_type)
destroy(this.cb_category_details)
destroy(this.ddlb_case_type)
destroy(this.cb_pcp_details)
destroy(this.sle_pcp)
destroy(this.cb_con_group_details)
destroy(this.sle_con_group)
destroy(this.cb_group_id_details)
destroy(this.sle_group_id)
destroy(this.cb_region_details)
destroy(this.sle_region)
destroy(this.cb_lob_details)
destroy(this.sle_lob)
destroy(this.st_category)
destroy(this.dw_category_org)
destroy(this.st_10)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_closed)
destroy(this.rb_opened)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.b_calendar_from)
destroy(this.b_calendar_to)
destroy(this.st_report_subject)
destroy(this.em_from)
destroy(this.em_to)
destroy(this.st_from)
destroy(this.st_to)
destroy(this.dw_user_list)
destroy(this.gb_date_range)
destroy(this.st_case_type)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//  Event:   pc_setoptions
//  Purpose: To set User Object options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  03/13/02 C. Jackson  Original Version
//***********************************************************************************************

STRING l_cStringDate, l_cSuperLogin, l_cDeptID, l_cDateParm
LONG l_nDeptRow, l_nRtn, l_nRow
DATAWINDOWCHILD	ldwc_FieldList

fw_SetOptions (c_NoEnablePopup)

// Since default Source type is All, disable details buttons
cb_lob_details.Enabled = FALSE
cb_region_details.Enabled = FALSE
cb_con_group_details.Enabled = FALSE
cb_group_id_details.Enabled = FALSE
cb_pcp_details.Enabled = FALSE

// Build the User/Dept Tree View
dw_user_list.fu_HLRetrieveOptions (1, &
		"group.bmp", &
		"group.bmp", &
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		" ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept", & 
		"cusfocus.cusfocus_user_dept.active <> 'N'", & 
		dw_user_list.c_KeyString )

IF w_supervisor_portal.tab_1.tabpage_reports.uo_reportS.i_cDataWindow <> 'd_dept_report_hg' THEN // Don't allow user selection of Dept Report
	dw_user_list.fu_HLRetrieveOptions (2, &
			"cusfocus.cusfocus_user.out_of_office_bmp", &
			"cusfocus.cusfocus_user.out_of_office_bmp", &
			"cusfocus.cusfocus_user.user_id", & 
			"cusfocus.cusfocus_user_dept.user_dept_id", & 
			"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
			"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
			"cusfocus.cusfocus_user", & 
			"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
			"cusfocus.cusfocus_user.active <> 'N'", & 
			dw_user_list.c_KeyString + dw_user_list.c_BMPFromColumn)
		
	dw_user_list.fu_HLOptions(dw_user_list.c_MultiSelect + dw_user_list.c_ShowLines)
	
	dw_user_list.fu_HLCreate (SQLCA, 2)
	
ELSE
	
	dw_user_list.fu_HLOptions(dw_user_list.c_MultiSelect + dw_user_list.c_ShowLines)
	
	dw_user_list.fu_HLCreate (SQLCA, 1)


END IF


IF w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow = 'd_dissat_report_hg' THEN
	ddlb_case_type.SelectItem (3)
	Post fw_initcategory ("C")
ELSE
	ddlb_case_type.SelectItem (1)
	Post fw_initcategory ("M")	
END IF

CHOOSE CASE w_supervisor_portal.tab_1.tabpage_reports.uo_reportS.i_cDataWindow
	CASE 'd_rcvd_rslvd_report_hg','d_dissat_report_hg','d_rcvd_report_hg','d_rep_report_hg', 'd_dept_report_hg'
		sle_lob.Enabled = TRUE
		sle_region.Enabled = TRUE
		sle_con_group.Enabled = TRUE
		sle_group_id.Enabled = TRUE
		sle_pcp.Enabled = TRUE
		cb_lob_details.Enabled = TRUE
		cb_region_details.Enabled = TRUE
		cb_con_group_details.Enabled = TRUE
		cb_group_id_details.Enabled = TRUE
		cb_pcp_details.Enabled = TRUE
		
END CHOOSE

CHOOSE CASE w_supervisor_portal.tab_1.tabpage_reports.uo_reportS.i_cDataWindow
		
	CASE 'd_rcvd_rslvd_report_hg'
		dw_user_list.fu_HLOptions(dw_user_list.c_SingleSelect + dw_user_list.c_ShowLines)
      THIS.Title = 'Received-Resolved Report Parameters'
	CASE 'd_rcvd_report_hg'
		dw_user_list.fu_HLOptions(dw_user_list.c_SingleSelect + dw_user_list.c_ShowLines)
		rb_opened.Enabled = FALSE
		rb_closed.Enabled = FALSE
		rb_opened.Visible = FALSE
		rb_closed.Visible = FALSE
		i_cDateColumn = 'O'
      THIS.Title = 'Received Report Parameters'
	CASE 'd_dept_report_hg'
		rb_opened.Enabled = FALSE
		rb_closed.Enabled = FALSE
		rb_opened.Visible = FALSE
		rb_closed.Visible = FALSE
		i_cDateColumn = 'O'
		st_report_subject.Text = 'Department:'
		dw_user_list.fu_HLOptions(dw_user_list.c_MultiSelect + dw_user_list.c_ShowLines)
		ddlb_case_type.Enabled = FALSE
		dw_category_org.Enabled = FALSE
		cb_category_details.Enabled = FALSE
      THIS.Title = 'Department Report Parameters'
	CASE 'd_rep_report_hg'
		dw_user_list.fu_HLOptions(dw_user_list.c_SingleSelect + dw_user_list.c_ShowLines)
		ddlb_case_type.Enabled = FALSE
		dw_category_org.Enabled = FALSE
		cb_category_details.Enabled = FALSE
      THIS.Title = 'Representative Report Parameters'
	CASE 'd_dissat_report_hg'
		dw_user_list.fu_HLOptions(dw_user_list.c_SingleSelect + dw_user_list.c_ShowLines)
		rb_opened.Enabled = FALSE
		rb_closed.Enabled = FALSE
		rb_opened.Visible = FALSE
		rb_closed.Visible = FALSE
		i_cDateColumn = 'O'
		ddlb_case_type.SelectItem("Issue/Concern",0)
		ddlb_case_type.Enabled = FALSE
//		ddlb_source_type.DeleteItem ( 1 )
      THIS.Title = 'Dissatisfaction Report Parameters'
		
END CHOOSE

i_cSourceType = 'C'		

ddlb_source_type.SelectItem ('Member',0)




end event

event pc_closequery;call super::pc_closequery;/*****************************************************************************************
   Event:      pc_closequery
   Purpose:    Perform final window processing and determine if Close process should
					continue.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

STRING	l_cStartDate, l_cEndDate, l_cBlankDate = '00/00/0000', l_cKeys[], l_cSelectedKeys[]
LONG     l_nIndex, l_nLastRow, l_nNumSelected

IF i_bOK THEN
	
	l_cStartDate = em_from.Text
	l_cEndDate = em_to.Text
	
	// validate subject selection
	IF i_cUserType = '' OR IsNull(i_cUserType) THEN
		
		MessageBox (gs_appname, 'You must select a User or Department from the list.')
		Error.i_FWError = c_Fatal
		RETURN 0
		
	ELSE
		
		l_nLastRow = dw_user_list.RowCount()
		l_nIndex = 1
		l_nNumSelected = 0
		
		IF cbx_all.Checked = FALSE THEN
			DO
			  l_nIndex = dw_user_list.fu_HLGetSelectedRow(l_nIndex)
			  
			  IF l_nIndex > 0 THEN
				 l_nNumSelected = l_nNumSelected + 1
				 
				 dw_user_list.fu_HLGetRowKey(l_nIndex, l_cKeys[])
				 
				 i_sReportParmsHG.user_array[l_nNumSelected] = l_cKeys[UPPERBOUND(l_cKeys)]
				 
				 l_nIndex = l_nIndex + 1
				 
				 IF l_nIndex > l_nLastRow THEN
					l_nIndex = 0
				 END IF
				 
			  END IF
			  
			LOOP UNTIL l_nIndex = 0
	
		END IF
		
	END IF
	
	// if a custom date range is specified and either date is not set, notify the user
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
		
	// determine the specified date range
	fw_CalcDateRange ()
	
	// convert date to string to pass to stored procedure
	l_cStartDate = STRING(i_dtStartDate)
	l_cEndDate = STRING(i_dtEndDate)
	
	// set the return values based on the settings in the window.
	i_sReportParmsHG.user_type = i_cUserType
	i_sReportParmsHG.source_type = i_cSourceType
	i_sReportParmsHG.received_resolved = i_cDateColumn
	i_sReportParmsHG.user_list = i_cUserList
	i_sReportParmsHG.lob = sle_lob.Text
	i_sReportParmsHG.region = sle_region.Text
	i_sReportParmsHG.group = sle_group_id.Text
	i_sReportParmsHG.consolidated_group = sle_con_group.Text
	i_sReportParmsHG.pcp = sle_pcp.Text
	i_sReportParmsHG.start_date_string = l_cStartDate
	i_sReportParmsHG.end_date_string = l_cEndDate
	
ELSE
	
	// set blank return values
	i_sReportParmsHG.user_type = ''
	i_sReportParmsHG.source_type = ''	
	i_sReportParmsHG.received_resolved = ''
	i_sReportParmsHG.user_list = ''
	i_sReportParmsHG.lob = ''
	i_sReportParmsHG.region = ''
	i_sReportParmsHG.group = ''
	i_sReportParmsHG.consolidated_group = ''
	i_sReportParmsHG.pcp = ''
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

type cbx_all from checkbox within w_report_parms_hg
integer x = 855
integer y = 752
integer width = 160
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
string text = "All"
borderstyle borderstyle = stylelowered!
end type

event clicked;//**********************************************************************************************
//
//  Event:   Clicked
//  Purpose: To enable/disable Department outliner
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/30/02 C. Jackson  Original Version
//**********************************************************************************************

IF this.Checked THEN
	
	dw_user_list.fu_HLClearSelectedRows()
	dw_user_list.Enabled = FALSE
	i_cUserType = 'D'
	i_cuserlist = 'All'
ELSE
	
	dw_user_list.Enabled = TRUE
	SetNull(i_cUserType)
	SetNull(i_cuserlist)
	
END IF
end event

type st_5 from statictext within w_report_parms_hg
integer x = 32
integer y = 32
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
string text = "Source Type:"
boolean focusrectangle = false
end type

type ddlb_source_type from dropdownlistbox within w_report_parms_hg
integer x = 32
integer y = 100
integer width = 983
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
string item[] = {"All","Member","Provider","Employer Group"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//*******************************************************************************************
//
//  Event:   selectionchanged
//  Purpose: Make changes according the Source Type selected
//  
//  Date     Developer   Desription
//  -------- ----------- --------------------------------------------------------------------
//  03/22/02 C. Jackson  Original Version
//*******************************************************************************************

// Clear out any retrieval argument fields
sle_lob.SelectText(1,1000)
sle_lob.Clear()

sle_region.SelectText(1,1000)
sle_region.Clear()

sle_con_group.SelectText(1,1000)
sle_con_group.Clear()

sle_group_id.SelectText(1,1000)
sle_group_id.Clear()

sle_pcp.SelectText(1,1000)
sle_pcp.Clear()

// Enable/Disable fields according the source type selected
CHOOSE CASE text
	CASE 'All'
		i_cSourceType = 'A'
		sle_lob.Enabled = FALSE
		sle_region.Enabled = FALSE
		sle_con_group.Enabled = FALSE
		sle_group_id.Enabled = FALSE
		sle_pcp.Enabled = FALSE
		cb_lob_details.Enabled = FALSE
		cb_region_details.Enabled = FALSE
		cb_con_group_details.Enabled = FALSE
		cb_group_id_details.Enabled = FALSE
		cb_pcp_details.Enabled = FALSE
		
	CASE 'Member'
		i_cSourceType = 'C'		
		sle_lob.Enabled = TRUE
		sle_region.Enabled = TRUE
		sle_con_group.Enabled = TRUE
		sle_group_id.Enabled = TRUE
		sle_pcp.Enabled = TRUE
		cb_lob_details.Enabled = TRUE
		cb_region_details.Enabled = TRUE
		cb_con_group_details.Enabled = TRUE
		cb_group_id_details.Enabled = TRUE
		cb_pcp_details.Enabled = TRUE
		
	CASE 'Provider'
		i_cSourceType = 'P'		
		sle_lob.Enabled = FALSE
		sle_region.Enabled = FALSE
		sle_con_group.Enabled = FALSE
		sle_group_id.Enabled = FALSE
		sle_pcp.Enabled = FALSE
		cb_lob_details.Enabled = FALSE
		cb_region_details.Enabled = FALSE
		cb_con_group_details.Enabled = FALSE
		cb_group_id_details.Enabled = FALSE
		cb_pcp_details.Enabled = FALSE
		
	CASE 'Employer Group'
		i_cSourceType = 'E'		
		sle_lob.Enabled = TRUE
		sle_region.Enabled = TRUE
		sle_con_group.Enabled = TRUE
		sle_group_id.Enabled = TRUE
		sle_pcp.Enabled = FALSE
		cb_lob_details.Enabled = TRUE
		cb_region_details.Enabled = TRUE
		cb_con_group_details.Enabled = TRUE
		cb_group_id_details.Enabled = TRUE
		cb_pcp_details.Enabled = FALSE
		
END CHOOSE


end event

type cb_category_details from commandbutton within w_report_parms_hg
integer x = 2281
integer y = 1624
integer width = 110
integer height = 80
integer taborder = 120
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
//  06/03/02 C. Jackson  Disable ddlb_case_type is multiple categories
//  07/10/03 M. Caruso   Set category_array using PCCA.Parm which is returned by the Child window.
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

type ddlb_case_type from dropdownlistbox within w_report_parms_hg
integer x = 1088
integer y = 100
integer width = 1129
integer height = 448
integer taborder = 100
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

type cb_pcp_details from commandbutton within w_report_parms_hg
integer x = 3200
integer y = 1292
integer width = 110
integer height = 80
integer taborder = 220
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
//  Purpose: Open the details datawindow for PCP
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//**********************************************************************************************

// Clear out old values
sle_pcp.SelectText(1,60000)
sle_pcp.Clear()

CHOOSE CASE i_cSourceType
	CASE 'C'
	i_cDetailView = 'd_prof_id_mbr_hg'
	
	FWCA.MGR.fu_OpenWindow(w_criteria_details_hg, 0) 
	
	IF NOT IsNull(message.stringparm) AND TRIM(message.stringparm) <> '' THEN
		
		sle_pcp.ReplaceText(message.stringparm)
		
	END IF
	
END CHOOSE
end event

type sle_pcp from singlelineedit within w_report_parms_hg
integer x = 2281
integer y = 1284
integer width = 901
integer height = 96
integer taborder = 210
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_con_group_details from commandbutton within w_report_parms_hg
integer x = 3200
integer y = 700
integer width = 110
integer height = 80
integer taborder = 180
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
//  Purpose: Open the details datawindow for consolidated group
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//**********************************************************************************************

// Clear out old values
sle_con_group.SelectText(1,60000)
sle_con_group.Clear()

CHOOSE CASE i_cSourceType
	CASE 'C'
		i_cDetailView = 'd_con_group_mbr_hg'
	CASE 'E'
		i_cDetailView = 'd_con_group_grp_hg'
END CHOOSE

FWCA.MGR.fu_OpenWindow(w_criteria_details_hg, 0) 

IF NOT IsNull(message.stringparm) AND TRIM(message.stringparm) <> '' THEN
	
	sle_con_group.ReplaceText(message.stringparm)
	
END IF
end event

type sle_con_group from singlelineedit within w_report_parms_hg
integer x = 2281
integer y = 692
integer width = 901
integer height = 96
integer taborder = 170
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_group_id_details from commandbutton within w_report_parms_hg
integer x = 3200
integer y = 996
integer width = 110
integer height = 80
integer taborder = 200
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
//  Purpose: Open the details datawindow for group id
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//**********************************************************************************************

// Clear out old values
sle_group_id.SelectText(1,60000)
sle_group_id.Clear()

CHOOSE CASE i_cSourceType
	CASE 'C'
		i_cDetailView = 'd_group_id_mbr_hg'
	CASE 'E'
		i_cDetailView = 'd_group_id_grp_hg'
END CHOOSE

FWCA.MGR.fu_OpenWindow(w_criteria_details_hg, 0) 

IF NOT IsNull(message.stringparm) AND TRIM(message.stringparm) <> '' THEN
	
	sle_group_id.ReplaceText(message.stringparm)
	
END IF
end event

type sle_group_id from singlelineedit within w_report_parms_hg
integer x = 2281
integer y = 988
integer width = 901
integer height = 96
integer taborder = 190
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_region_details from commandbutton within w_report_parms_hg
integer x = 3200
integer y = 404
integer width = 110
integer height = 80
integer taborder = 160
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
//  Purpose: Open the details datawindow for region
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//**********************************************************************************************

// Clear out old values
sle_region.SelectText(1,60000)
sle_region.Clear()

CHOOSE CASE i_cSourceType
	CASE 'C'
		i_cDetailView = 'd_region_mbr_hg'
	CASE 'E'
		i_cDetailView = 'd_region_grp_hg'
END CHOOSE

FWCA.MGR.fu_OpenWindow(w_criteria_details_hg, 0) 

IF NOT IsNull(message.stringparm) AND TRIM(message.stringparm) <> '' THEN
	
	sle_region.ReplaceText(message.stringparm)
	
END IF
end event

type sle_region from singlelineedit within w_report_parms_hg
integer x = 2281
integer y = 396
integer width = 901
integer height = 96
integer taborder = 150
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_lob_details from commandbutton within w_report_parms_hg
integer x = 3200
integer y = 108
integer width = 110
integer height = 80
integer taborder = 140
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
//  Purpose: Open the details datawindow for line of business
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//**********************************************************************************************

// Clear out old values
sle_lob.SelectText(1,60000)
sle_lob.Clear()

CHOOSE CASE i_cSourceType
	CASE 'C'
		i_cDetailView = 'd_lob_mbr_hg'
	CASE 'E'
		i_cDetailView = 'd_lob_grp_hg'
END CHOOSE
		

FWCA.MGR.fu_OpenWindow(w_criteria_details_hg, 0) 

IF NOT IsNull(message.stringparm) AND TRIM(message.stringparm) <> '' THEN
	
	sle_lob.ReplaceText(message.stringparm)
	
END IF
end event

type sle_lob from singlelineedit within w_report_parms_hg
integer x = 2281
integer y = 100
integer width = 901
integer height = 96
integer taborder = 130
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_category from statictext within w_report_parms_hg
integer x = 1093
integer y = 248
integer width = 1129
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

type dw_category_org from u_outliner_std within w_report_parms_hg
integer x = 1088
integer y = 316
integer width = 1129
integer height = 1388
integer taborder = 110
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

type st_10 from statictext within w_report_parms_hg
integer x = 2281
integer y = 1212
integer width = 242
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PCP:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_report_parms_hg
integer x = 2281
integer y = 620
integer width = 553
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consolidated Group:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_report_parms_hg
integer x = 2281
integer y = 916
integer width = 265
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Group ID:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_report_parms_hg
integer x = 2281
integer y = 328
integer width = 521
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Region:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_report_parms_hg
integer x = 2281
integer y = 32
integer width = 521
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Line of Business:"
boolean focusrectangle = false
end type

type rb_closed from radiobutton within w_report_parms_hg
integer x = 498
integer y = 360
integer width = 402
integer height = 80
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resolved"
borderstyle borderstyle = stylelowered!
end type

type rb_opened from radiobutton within w_report_parms_hg
integer x = 69
integer y = 360
integer width = 361
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Received"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_report_parms_hg
integer x = 2990
integer y = 1596
integer width = 320
integer height = 108
integer taborder = 240
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

type cb_ok from commandbutton within w_report_parms_hg
integer x = 2642
integer y = 1596
integer width = 320
integer height = 108
integer taborder = 230
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

IF rb_opened.Checked = TRUE THEN
	i_cDateColumn = 'O'
ELSE
	i_cDateColumn = 'C'
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

// Check lengths of retrieval args (limited to 2000 in the stored procedures
l_nLength = LEN(sle_lob.text)
IF l_nLength > 700 THEN
	messagebox(gs_AppName,'Please select fewer Lines of Business, or select None.')
	sle_lob.SetFocus()
	
	RETURN
	
END IF
l_nLength = LEN(sle_region.text)
IF l_nLength > 700 THEN
	messagebox(gs_AppName,'Please select fewer Regions, or select None.')
	sle_region.SetFocus()
	
	RETURN
	
END IF

l_nLength = LEN(sle_con_group.text)
IF l_nLength > 700 THEN
	messagebox(gs_AppName,'Please select fewer consolidated_groups, or select None.')
	sle_con_group.SetFocus()
	
	RETURN
	
END IF

l_nLength = LEN(sle_group_id.text)
IF l_nLength > 700 THEN
	messagebox(gs_AppName,'Please select fewer group_ids, or select None.')
	sle_group_id.SetFocus()
	
	RETURN
	
END IF

l_nLength = LEN(sle_pcp.text)
IF l_nLength > 700 THEN
	messagebox(gs_AppName,'Please select fewer pcps, or select None.')
	sle_pcp.SetFocus()
	
	RETURN
	
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

type b_calendar_from from commandbutton within w_report_parms_hg
integer x = 837
integer y = 468
integer width = 110
integer height = 80
integer taborder = 50
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

type b_calendar_to from commandbutton within w_report_parms_hg
integer x = 837
integer y = 600
integer width = 110
integer height = 80
integer taborder = 70
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

type st_report_subject from statictext within w_report_parms_hg
integer x = 27
integer y = 760
integer width = 480
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Department/User:"
boolean focusrectangle = false
end type

type em_from from editmask within w_report_parms_hg
integer x = 443
integer y = 464
integer width = 379
integer height = 84
integer taborder = 40
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

type em_to from editmask within w_report_parms_hg
integer x = 443
integer y = 592
integer width = 379
integer height = 84
integer taborder = 60
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

type st_from from statictext within w_report_parms_hg
integer x = 114
integer y = 468
integer width = 325
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
string text = "Begin Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_to from statictext within w_report_parms_hg
integer x = 160
integer y = 608
integer width = 279
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
string text = "End Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_user_list from u_outliner_std within w_report_parms_hg
integer x = 32
integer y = 832
integer width = 983
integer height = 876
integer taborder = 90
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;call super::po_pickedrow;/*****************************************************************************************
   Event:      po_pickedrow
   Purpose:    

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/13/02 C. Jackson  Original Version
*****************************************************************************************/

// determine the subject type
IF clickedlevel = 1 THEN
	
	i_cUserType = 'D'
	
ELSE

	i_cUserType = 'U'
	
END IF


end event

type gb_date_range from groupbox within w_report_parms_hg
integer x = 32
integer y = 284
integer width = 983
integer height = 452
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

type st_case_type from statictext within w_report_parms_hg
integer x = 1088
integer y = 32
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

