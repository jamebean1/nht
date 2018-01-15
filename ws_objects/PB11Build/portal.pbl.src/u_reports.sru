$PBExportHeader$u_reports.sru
$PBExportComments$Reports User Object
forward
global type u_reports from u_container_std
end type
type dw_pre_retrieve_report from u_dw_std within u_reports
end type
type dw_report_list from u_dw_std within u_reports
end type
type st_1 from statictext within u_reports
end type
type cb_view from commandbutton within u_reports
end type
type cb_print from commandbutton within u_reports
end type
end forward

global type u_reports from u_container_std
integer width = 3040
integer height = 1712
dw_pre_retrieve_report dw_pre_retrieve_report
dw_report_list dw_report_list
st_1 st_1
cb_view cb_view
cb_print cb_print
end type
global u_reports u_reports

type variables
STRING i_cRowDesc[]
STRING i_cDelRowDesc[]
STRING i_cReport
STRING i_cUserList
STRING i_cDateType
STRING i_cReportBy
STRING i_cSubtitle
STRING i_cDateParms
STRING i_cDataWindow
STRING i_cLogin
STRING i_clineofbusiness
STRING i_cCloseCode
STRING i_csubscribertype
STRING i_cparentgroup
STRING i_cgroup
STRING i_cstartdate
STRING i_cenddate
STRING i_cProvKeyString
STRING i_cUserName
STRING i_cAllExceptFEP

STRING i_cSourceID
DATE i_dStartDate
DATE i_dEndDate

LONG i_nLevel
LONG i_nSelectedRow
LONG i_nDelRow
LONG i_nNumSelected
LONG i_nDelSelected
LONG i_nsampleset
LONG i_nClosedDays
LONG i_nProvKeys[ ]
LONG i_nUserNameLen

DATASTORE i_dsUsers

DATE i_dtFromDate
DATE i_dtToDate

DATETIME i_dtStartDate
DATETIME i_dtEndDate

BOOLEAN i_bExternal

OLEOBJECT i_olereport

U_STD_PRINT_PREVIEW	iou_std_print_preview

S_REPORT_PARMS i_sUOReportParms
S_REPORT_PARMS	i_sResetParms

end variables

forward prototypes
public subroutine fu_getreport ()
public subroutine fu_populate_array ()
public subroutine fu_prep_report_hg ()
public function integer fu_getparms ()
public subroutine fu_getdata (string a_cviewtype)
end prototypes

public subroutine fu_getreport ();
end subroutine

public subroutine fu_populate_array ();//********************************************************************************************
//
//  Function: fu_populate_array
//  Purpose:  To put user information into array
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/09/02 C. Jackson  Original Version
//********************************************************************************************

LONG l_nIndex

IF NOT IsNull(i_sUOReportParms.category_array[1]) AND TRIM(i_sUOReportParms.category_array[1]) <> '' THEN
	FOR l_nIndex = 1 TO UPPERBOUND (i_sUOReportParms.category_array)
		
		IF l_nIndex = 1 THEN
			i_sUOReportParms.category_id = i_sUOReportParms.category_array[1]
		ELSE
			i_sUOReportParms.category_id = i_sUOReportParms.category_id + ";" + i_sUOReportParms.category_array[l_nIndex]
		END IF
		
	NEXT
	
END IF

FOR l_nIndex = 1 TO UPPERBOUND (i_sUOReportParms.user_array)
	
	IF l_nIndex = 1 THEN
		i_sUOReportParms.user_list = i_sUOReportParms.user_array[1]
	ELSE
		i_sUOReportParms.user_list = i_sUOReportParms.user_list + ";" + i_sUOReportParms.user_array[l_nIndex]
	END IF
	
NEXT



end subroutine

public subroutine fu_prep_report_hg ();//********************************************************************************************
//
//  Function: fu_prep_report_hg
//  Purpose:  To prep data for report
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  03/27/02 C. Jackson  Original Version
//  07/10/03 M. Caruso   Reorganized category_array code to check UpperBound before
//								 referencing array entries.
//********************************************************************************************

LONG l_nIndex
	
FOR l_nIndex = 1 TO UPPERBOUND (i_sUOReportParms.category_array)
	
	IF l_nIndex = 1 THEN
		IF NOT IsNull(i_sUOReportParms.category_array[1]) AND TRIM(i_sUOReportParms.category_array[1]) <> '' THEN
			i_sUOReportParms.category_id = i_sUOReportParms.category_array[1]
		ELSE
			CONTINUE
		END IF
	ELSE
		i_sUOReportParms.category_id = i_sUOReportParms.category_id + ";" + i_sUOReportParms.category_array[l_nIndex]
	END IF
	
NEXT

FOR l_nIndex = 1 TO UPPERBOUND (i_sUOReportParms.user_array)
	
	IF l_nIndex = 1 THEN
		i_sUOReportParms.user_list = i_sUOReportParms.user_array[1]
	ELSE
		i_sUOReportParms.user_list = i_sUOReportParms.user_list + ";" + i_sUOReportParms.user_array[l_nIndex]
	END IF
	
NEXT

end subroutine

public function integer fu_getparms ();//********************************************************************************************
//
//  Function: fu_getparms()
//  Purpose:  To open the required parameter window and pass them back
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  10/04/01 C. Jackson  Orignal Version
//  10/19/01 C. Jackson  Add Critical Providers Analysis Report and Critical Groups Analysis 
//                       Report
//  03/13/02 C. Jackson  Change name of Vermont report objects to ..._vt.
//  01/08/02 C. Jackson  Add HealthGuard Reports
//  10/20/04 C. Haxel    Add Transfer Time Report
//********************************************************************************************

STRING l_cWindowTitle
BOOLEAN l_bOK
LONG l_nArraySize


CHOOSE CASE i_cDatawindow

	CASE 'd_tot_contact', 'd_tot_contact_act'
		RETURN 0

	CASE 'd_transfer_time_report'
	// Transfer Time Report
		l_cWindowTitle = 'Transfer Time Report'
		OpenWithParm(w_transfer_time_parms,l_cWindowTitle)
		
	CASE 'd_call_cntr_contact_rpt'
	// Call Center Contact Report
		l_cWindowTitle = 'Call Center Contact Report'
		OpenWithParm(w_date_parms,l_cWindowTitle)
		
	CASE 'd_case_detail_history_report_multi'
	// Case Detail History Report
		Open(w_case_detail_parms)

	CASE 'd_case_timings_report'
	// Case Timings
		l_cWindowTitle = 'Case Timings Report'
		OpenWithParm(w_performance_parms, l_cWindowTitle)
		
	CASE 'd_category_analysis_report'
	// Category Analysis Report
		l_cWindowTitle = 'Category Analysis Report'
		OpenWithParm(w_performance_parms, l_cWindowTitle)
		
	CASE 'd_contact_meth_report'
	// Contact Method Report
		l_cWindowTitle = 'Contact Method Report'
		OpenWithParm(w_performance_parms, l_cWindowTitle)

	CASE 'd_consumer_rpt_nested'
	// Member Profile Report
		Open(w_consumer_parms)

	CASE 'd_critical_mem_report'
	// Critical Members Analysis Report
		l_cWindowTitle = 'Critical Members Analysis Report'
		OpenWithParm(w_critical_parms,l_cWindowTitle)
	
	CASE 'd_critical_prov_report'
	//  Critical Providers Analysis Report
		l_cWindowTitle = 'Critical Providers Analysis Report'
		OpenWithParm(w_critical_parms,l_cWindowTitle)
		
	CASE 'd_critical_grp_report'
	// Critical Groups Analysis Report
		l_cWindowTitle = 'Critical Groups Analysis Report'
		OpenWithParm(w_critical_parms,l_cWindowTitle)

	CASE 'd_group_contact_nested'
	// Group Contact Activity
		l_cWindowTitle = 'Group Contact Activity'
		OpenWithParm(w_group_parms, l_cWindowTitle)
		
	CASE 'd_grp_mem_rpt_card_nested'
	// Group Membership Report Card
		l_cWindowTitle = 'Group Membership Report Card'
		OpenWithParm(w_group_parms, l_cWindowTitle)
	
	CASE 'd_inq_act_by_category'
	// Group Inquiry Activity
		l_cWindowTitle = 'Group Inquiry Activity'
		OpenWithParm(w_group_parms, l_cWindowTitle)
	
	CASE 'd_iss_act_by_category'
	// Group Issue/Concern Activity
		l_cWindowTitle = 'Group Issue/Concern Activity'
		OpenWithParm(w_group_parms, l_cWindowTitle)

	CASE 'd_prov_contact_act_nested'
	// Provider Contact Activity
		l_cWindowTitle = 'Provider Contact Activity'
		OpenWithParm(w_std_rpt_parms, l_cWindowTitle)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 1.31.2006 - Adding in an appeals report for Western.
	//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 'd_appeal_activity'
		l_cWindowTitle = 'Appeals Activity'
		OpenWithParm(w_appeal_parms, l_cWindowTitle)	
		
	CASE 'd_appeal_outcomes'
		l_cWindowTitle = 'Appeals Outcomes'
		OpenWithParm(w_appeal_parms, l_cWindowTitle)	
		
	CASE 'd_appeal_timeliness'
		l_cWindowTitle = 'Appeals Timeliness'
		OpenWithParm(w_appeal_parms, l_cWindowTitle)	
		
	CASE 'd_appeal_summary'
		l_cWindowTitle = 'Appeals Summary'
		OpenWithParm(w_date_parms, l_cWindowTitle)	
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite End Added 1.31.2006 - Adding in an appeals report for Western.
	//-----------------------------------------------------------------------------------------------------------------------------------

	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 4.3.2006 - Adding in an appeals report for Western.
	//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 'd_appeal_open_cases'
		l_cWindowTitle = 'Open Appeals Detail'
		OpenWithParm(w_appeal_parms, l_cWindowTitle)	
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite End Added 4.3.2006 - Adding in an appeals report for Western.
	//-----------------------------------------------------------------------------------------------------------------------------------

	CASE 'd_svc_center_act_nested'
	// Provider Report Card
		l_cWindowTitle = 'Provider Report Card'
		OpenWithParm(w_std_rpt_parms, l_cWindowTitle)

	// Vermont Custom Reports
	CASE 'd_case_counts_vt'
	// Case Counts Report
		Open(w_case_counts_vt)

	CASE 'd_case_timeliness_vt'
	// Case Timeliness Report
		Open(w_case_timeliness_vt)

	CASE 'd_inquiry_sampling_vt'
	// Inquiry Sampling Report
		Open(w_inquiry_sampling_vt)
		
	// HealthGuard Custom Reports
	CASE 'd_case_inquiry_report_hg'
	//Case Inquiry Report
		Open(w_case_inquiry_parms_hg)
		
	CASE 'd_dept_report_hg','d_dissat_report_hg','d_rcvd_report_hg','d_rcvd_rslvd_report_hg','d_rep_report_hg'
	// Department Report
		OPEN(w_report_parms_hg)
		
	CASE 'd_month_appl_lvl_hg'
		OPEN (w_appeals_parms_hg)
		
	// PHCS Custom Reports
	CASE 'd_customer_contact_activity_phcs'
	// Provider Report Card
		Open(w_customer_contacts_phcs)

	
END CHOOSE

i_sUOReportParms = message.PowerObjectParm
CHOOSE CASE i_cDataWindow

	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite Added 1.31.2006
	//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 'd_appeal_activity', 'd_appeal_summary', 'd_appeal_open_cases', 'd_appeal_outcomes', 'd_appeal_timeliness'
		IF (string(i_sUOReportParms.date_parm1) <> '' ) AND (NOT ISNULL(i_sUOReportParms.date_parm1) ) 	THEN
			l_bOK = TRUE
		END IF
	//-----------------------------------------------------------------------------------------------------------------------------------
	// JWhite End Added 1.31.2006
	//-----------------------------------------------------------------------------------------------------------------------------------

	CASE 'd_transfer_time_report'
		IF (string(i_sUOReportParms.date_parm1) <> '' ) AND (NOT ISNULL(i_sUOReportParms.date_parm1) ) 	THEN
			l_bOK = TRUE
		END IF
	CASE 'd_case_inquiry_report_hg','d_dept_report_hg','d_dissat_report_hg','d_rcvd_report_hg','d_rcvd_rslvd_report_hg','d_rep_report_hg','d_month_appl_lvl_hg'
		IF (string(i_sUOReportParms.start_date_string) <> '' ) AND (NOT ISNULL(i_sUOReportParms.start_date_string) ) THEN
			l_bOK = TRUE
		END IF
		
	CASE 'd_call_cntr_contact_rpt'
		IF (string(i_sUOReportParms.date_parm1) <> '' ) AND (NOT ISNULL(i_sUOReportParms.date_parm1) ) THEN
			l_bOK = TRUE
		END IF
	CASE 'd_prov_contact_act_nested','d_svc_center_act_nested'
		IF (string(i_sUOReportParms.date_parm3) <> '' ) AND (NOT ISNULL(i_sUOReportParms.date_parm3) ) THEN
			l_bOK = TRUE
		END IF
	CASE 'd_case_counts_vt', 'd_case_timeliness_vt', &
		  'd_case_timings_report', 'd_category_analysis_report', 'd_consumer_rpt_nested', &
		  'd_contact_meth_report', 'd_critical_mem_report', 'd_group_contact_nested', &
		  'd_grp_mem_rpt_card_nested', 'd_inq_act_by_category', 'd_inquiry_sampling_vt', &
		  'd_iss_act_by_category', 'd_critical_prov_report', 'd_critical_grp_report', &
		  'd_customer_contact_activity_phcs'
		IF i_sUOReportParms.string_parm1 <> '' AND NOT ISNULL (i_sUOReportParms.string_parm1) THEN
			l_bOK = TRUE
		END IF
	CASE 'd_case_detail_history_report_multi'
		l_nArraySize = UPPERBOUND(i_sUOReportParms.case_number[])
		IF ( i_sUOReportParms.user_or_dept <> '' AND NOT ISNULL(i_sUOReportParms.user_or_dept) OR &
		     l_nArraySize > 0 ) THEN
			l_bOK = TRUE
		END IF
	CASE ELSE
		l_bOK = FALSE
END CHOOSE

IF l_bOK THEN
	RETURN 0
ELSE
	RETURN -1
END IF
end function

public subroutine fu_getdata (string a_cviewtype);//**********************************************************************************************
//
//  Function: fu_GetData
//  Purpose:  Retrieve the print and preview datawindows 
//	 Parameters:  a_cViewType - P - Print
//										 V - View
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/09/01 C. Jackson  Original Version
//  11/06/01 C. Jackson  Correct retrieval of Provider Contact Activity
//  11/15/01 C. Jackson  Add User Name to retrieval arguments
//	 5/20/2002 K. Claver  Added parameter so could move print and view code into this function
//								 so could post this function to avoid a Dr. Watson/GPF issue(SCR 3095)
//  08/27/02 C. Jackson  Change fu_retrieve to select count to avoid loss of memory cache (SCR 3153)
//  9/19/2002 K. Claver  Changed d_svc_center_act_nested and d_prov_contact_act_nested to retrieve
//								 using a string array.
//  01/08/02 C. Jackson  Add HealthGuard Reports
//  02/17/03 C. Jackson  Add back in retrieves
//  09/30/04 C. Haxel    Changed date format in retrieve of d_tot_contact_act to accomocate new 
//                       proc
//  10/09/04 C. Haxel    Add SQLCA.dbParm = "StaticBind = " around Category Analysis Report
//                       to prevent Sybase error.
//  10/20/04 C. Haxel    Add Transfer Time Report
//**********************************************************************************************
STRING l_cWhere, l_cOldSelect, l_cNewSelect, l_cOrderBy, l_cStartDate, l_cEndDate, l_cRem
STRING l_cCaseType, l_cUserName, l_cReturnParm, l_cID, l_cSourceType, l_cProvName, l_cVendID
STRING l_cSubjectID[], l_cNewSubjectID[], l_cGroupID, l_cGroupName, l_cYear, l_cCaseTypes[]
STRING l_cOtherCloseID, l_cOtherCloseString, l_cSourceID, l_sProviderKeys, l_cCaseStatusList
STRING l_cNewLabelX, l_cNewDataWidth, l_cModString, l_cCaseTypeList, l_cSourceTypeList
STRING l_cSQLString, l_cCount, l_cProvKeys[ ], l_cSourceTypes[]
LONG l_nPos, l_nUserKey, l_nYear, l_nPos1, l_nID, l_nRowCount, l_nCaseCount[], l_nIndex
LONG l_nStartRow, l_nConsumerCount, l_nRow, l_nArraySize
LONG l_nSecurityLevel, l_nPos2, l_nReturn, l_nParmReturn, l_nProviderCount, l_nKeyIndex
LONG l_nRightEdge, l_nOldDataX, l_nOldDataWidth, l_nNewDataX, l_nTempReturn, l_nProvKey, l_nRV
LONG ll_parm1, ll_parm2, ll_parm3, ll_parm4
DATE l_dtDate, l_dEndDate, l_dStartDate
DATETIME l_dtStartDT, l_dtEndDT
DATASTORE l_dsDataList,  l_dsOtherCloseCode, l_dsProvKeys
DATAWINDOWCHILD	l_dwcChild
BOOLEAN l_bPrintOK

CHOOSE CASE i_cDataWindow
		
	CASE 'd_transfer_time_report'
		i_cDataWindow = 'd_transfer_time_report'
	CASE 'd_appeal_activity'
		i_cDataWindow = 'd_appeal_activity'
	CASE 'd_appeal_outcomes'
		i_cDataWindow = 'd_appeal_outcomes'
	CASE 'd_appeal_timeliness'
		i_cDataWindow = 'd_appeal_timeliness'
	CASE 'd_appeal_open_cases'
		i_cDataWindow = 'd_appeal_open_cases'	
	CASE 'd_case_inquiry_report_hg' 
		IF i_sUOReportParms.note_selection = 'All' THEN
			i_cDataWindow = 'd_case_inquiry_all_hg' 
		ELSE
			i_cDataWindow = 'd_case_inquiry_first_hg' 
		END IF
	CASE 'd_dept_report_hg'
		CHOOSE CASE i_sUOReportParms.source_type
			CASE 'C'
				i_cDataWindow = 'd_dept_mbr_hg'
			CASE 'E'
				i_cDataWindow = 'd_dept_grp_hg'
			CASE 'P'
				i_cDataWindow = 'd_dept_prov_hg'
			CASE 'A'
				i_cDataWindow = 'd_dept_all_hg'
		END CHOOSE
	CASE 'd_dissat_report_hg'
		CHOOSE CASE i_sUOReportParms.source_type
			CASE 'C'
				i_cDataWindow = 'd_dissat_mbr_hg'
			CASE 'E'
				i_cDataWindow = 'd_dissat_grp_hg'
			CASE 'P'
				i_cDataWindow = 'd_dissat_prov_hg'
			CASE 'A'
				i_cDataWindow = 'd_dissat_all_hg'
		END CHOOSE
	CASE 'd_rcvd_report_hg'
		CHOOSE CASE i_sUOReportParms.source_type
			CASE 'C'
				i_cDataWindow = 'd_rcvd_mbr_hg'
			CASE 'E'
				i_cDataWindow = 'd_rcvd_grp_hg'
			CASE 'P'
				i_cDataWindow = 'd_rcvd_prov_hg'
			CASE 'A'
				i_cDataWindow = 'd_rcvd_all_hg'
		END CHOOSE
	CASE 'd_rcvd_rslvd_report_hg'
		CHOOSE CASE i_sUOReportParms.source_type
			CASE 'C'
				i_cDataWindow = 'd_rcvd_rslvd_mbr_hg'
			CASE 'E'
				i_cDataWindow = 'd_rcvd_rslvd_grp_hg'
			CASE 'P'
				i_cDataWindow = 'd_rcvd_rslvd_prov_hg'
			CASE 'A'
				i_cDataWindow = 'd_rcvd_rslvd_all_hg'
		END CHOOSE
	CASE 'd_rep_report_hg'
		CHOOSE CASE i_sUOReportParms.source_type
			CASE 'C'
				i_cDataWindow = 'd_rep_mbr_hg'
			CASE 'E'
				i_cDataWindow = 'd_rep_grp_hg'
			CASE 'P'
				i_cDataWindow = 'd_rep_prov_hg'
			CASE 'A'
				i_cDataWindow = 'd_rep_all_hg'
		END CHOOSE
	CASE 'd_month_appl_lvl_hg'
		CHOOSE CASE i_sUOReportParms.appeal_level
			CASE '1'
				i_cDataWindow = 'd_month_appl_lvl_one_hg'
			CASE '2'
				i_cDataWindow = 'd_month_appl_lvl_two_hg'
			CASE '3'
				i_cDataWindow = 'd_month_appl_lvl_three_hg'
		END CHOOSE
	CASE 'd_customer_contact_activity_phcs'
		CHOOSE CASE i_sUOReportParms.string_parm1
			CASE 'Y'
				i_cDataWindow = 'd_customer_contact_activity_summary_phcs'
			CASE 'N'
				i_cDataWindow = 'd_customer_contact_activity_phcs'
		END CHOOSE
END CHOOSE

dw_pre_retrieve_report.fu_swap(i_cDataWindow, c_SaveChanges, &
	dw_pre_retrieve_report.c_Default + dw_pre_retrieve_report.c_NoRetrieveOnOpen)

//// Get current position of data field
//l_nOldDataX = LONG(dw_pre_retrieve_report.Describe("cc_user_name.X"))
//l_nOldDataWidth = LONG(dw_pre_retrieve_report.Describe("cc_user_name.Width"))
//
//// Find the right edge of data field
//l_nRightEdge = l_nOldDataX + l_nOldDataWidth
//
//// Calculate width of new data field
//l_cNewDataWidth = STRING(i_nUserNameLen * 28)
//
//// Get X Coordinate for data field
//l_nNewDataX = l_nRightEdge - LONG(l_cNewDataWidth)
//
//// Get X Coordinate for label field
//l_cNewLabelX = string(l_nNewDataX - 380)
//
//// Now move the fields to their new positions
//l_cModString = "cc_user_name_t.X = '" + l_cNewLabelX  + "'"
//dw_pre_retrieve_report.Modify(l_cModString)
//
//l_cModString = "cc_user_name.X = '" + string(l_nNewDataX) + "'"
//dw_pre_retrieve_report.Modify(l_cModString)
//
//l_cModString = "cc_user_name.Width = '" + l_cNewDataWidth  + "'"
//dw_pre_retrieve_report.Modify(l_cModString)

CHOOSE CASE i_cDataWindow
	
	CASE 'd_transfer_time_report'
	// Call Center Contact Report
		IF IsNull (i_sUOReportParms.date_parm1) THEN
			RETURN
		END IF
	
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
	  SELECT count(cusfocus.case_log.case_number) INTO :l_nReturn
		 FROM cusfocus.case_log  
		WHERE ( cusfocus.case_log.case_log_opnd_date >= :i_sUOReportParms.date_parm1 ) AND  
				( cusfocus.case_log.case_log_opnd_date <= :i_sUOReportParms.date_parm2)   
	  USING SQLCA;
	  
	  IF l_nReturn > 0 THEN
				
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_sUOReportParms.date_parm1,&
			i_sUOReportParms.date_parm2,i_sUOReportParms.string_parm1,i_sUOReportParms.string_parm2,i_sUOReportParms.string_parm3,i_sUOReportParms.string_parm4,i_sUOReportParms.string_parm5,i_sUOReportParms.string_parm6)
			
		END IF
		
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite - Added 1.31.2006
// RAP - Modified 11/14/2006 - ll_parm3 = line of business, ll_parm4 = service type
//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'd_appeal_activity', 'd_appeal_outcomes'
		
		ll_parm1 = Long(i_sUOReportParms.string_parm1)
		ll_parm2 = Long(i_sUOReportParms.string_parm2)
		ll_parm3 = Long(i_sUOReportParms.string_parm3)
		ll_parm4 = Long(i_sUOReportParms.string_parm4)
		
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_sUOReportParms.date_parm1, i_sUOReportParms.date_parm2, ll_parm3, ll_parm1, ll_parm4, ll_parm2, i_sUOReportParms.string_parm5, i_sUOReportParms.string_parm6, 'N')

	Case 'd_appeal_timeliness'
		
		ll_parm1 = Long(i_sUOReportParms.string_parm1)
		ll_parm2 = Long(i_sUOReportParms.string_parm2)
		ll_parm3 = Long(i_sUOReportParms.string_parm3)
		ll_parm4 = Long(i_sUOReportParms.string_parm4)
		
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_sUOReportParms.date_parm1, i_sUOReportParms.date_parm2, ll_parm3, ll_parm1, ll_parm4)

	Case 'd_appeal_summary'
		
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_sUOReportParms.date_parm1, i_sUOReportParms.date_parm2, 'N')

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite - End Added 1.31.2006
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite - End Added 4.3.2006
//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'd_appeal_open_cases'
		
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_sUOReportParms.date_parm1, i_sUOReportParms.date_parm2, ll_parm1, 'N')

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite - End Added 4.3.2006
//-----------------------------------------------------------------------------------------------------------------------------------
		
		

CASE 'd_call_cntr_contact_rpt'
	// Call Center Contact Report
		IF IsNull (i_sUOReportParms.date_parm1) THEN
			RETURN
		END IF
	
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
	  SELECT count(cusfocus.case_log.case_number) INTO :l_nReturn
		 FROM cusfocus.case_log  
		WHERE ( cusfocus.case_log.case_log_opnd_date >= :i_sUOReportParms.date_parm1 ) AND  
				( cusfocus.case_log.case_log_opnd_date <= :i_sUOReportParms.date_parm2)   
	  USING SQLCA;
	  
	  IF l_nReturn > 0 THEN
				
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_sUOReportParms.date_parm1,&
			i_sUOReportParms.date_parm2,i_cUserName)
			
		END IF
				
	CASE 'd_case_detail_history_report_multi'
	// Case Detail History Report
					i_sUOReportParms = message.PowerObjectParm
					l_nArraySize = UPPERBOUND(i_sUOReportParms.case_number[])
					IF ISNULL(i_sUOReportParms.user_or_dept) AND l_nArraySize = 0 THEN
						RETURN
					ELSE
						fu_populate_array()
						CHOOSE CASE i_sUOReportParms.case_status
							CASE '0'
								l_dsDataList = CREATE DataStore
								l_dsDataList.dataobject = 'dddw_case_status_list'
								l_dsDataList.SetTransObject(SQLCA)
								l_dsDataList.Retrieve()
								FOR l_nIndex = 1 TO l_dsDataList.RowCount()
									l_cCaseTypes[l_nIndex] = l_dsDataList.GetItemString(l_nIndex,'case_status_id')
								NEXT
								DESTROY l_dsDataList
							CASE ELSE
								l_cCaseTypes[1] = i_sUOReportParms.case_status
								
						END CHOOSE
						
						CHOOSE CASE i_sUOReportParms.source_type
							CASE '0'
								l_dsDataList = CREATE DataStore
								l_dsDataList.dataobject = 'dddw_source_type_list'
								l_dsDataList.SetTransObject (SQLCA)
								l_dsDataList.Retrieve ()
								FOR l_nIndex = 1 TO l_dsDataList.RowCount()
									l_cSourceTypes[l_nIndex] = l_dsDataList.GetItemString (l_nIndex, 'source_type')
								NEXT
								DESTROY l_dsDataList
								
							CASE ELSE
								l_cSourceTypes[1] = i_sUOReportParms.source_type
						END CHOOSE
						
						SELECT confidentiality_level INTO :l_nSecurityLevel
						  FROM cusfocus.cusfocus_user
						 WHERE user_id = :i_cLogin
						 USING SQLCA;
						
						dw_pre_retrieve_report.SetTransObject(SQLCA)
						
IF upperbound(i_sUOReportParms.case_number[]) = 0 THEN
	i_sUOReportParms.case_number[1] = ''
END IF
						l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_or_dept, i_sUOReportParms.case_status, i_sUOReportParms.source_type, &
							  i_sUOReportParms.start_date, i_sUOReportParms.end_date, l_nSecurityLevel, &
							  i_sUOReportParms.user_list, i_sUOReportParms.category_array, i_sUOReportParms.category_selected, &
							  i_sUOReportParms.case_type, i_sUOReportParms.case_number, i_sUOReportParms.case_selected)
							  
						dw_pre_retrieve_report.Object.appname_t.Text = gs_AppName
			
					END IF
	
	CASE 'd_case_timings_report'
	// Case Timings Report
		IF i_sUOReportParms.string_parm1 <> '' THEN
			
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			
			IF i_sUOReportParms.string_parm1 = 'D' THEN
			
				IF i_sUOReportParms.string_parm3 = 'T' THEN
				
					SELECT count(cusfocus.case_log.case_log_taken_by) INTO :l_nReturn
					FROM cusfocus.case_log, cusfocus.cusfocus_user 
					WHERE ( ( cusfocus.case_log.case_log_taken_by in ( select user_id
											  from cusfocus.cusfocus_user
											  where user_dept_id = :i_sUOReportParms.string_parm2 ) 
								 AND cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_taken_by ) ) 
								 AND cusfocus.case_log.case_log_clsd_date is not null 
								 AND cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 
								 AND cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
					 USING SQLCA;
				
				ELSE
				
					SELECT count(cusfocus.case_log.case_log_case_rep) INTO :l_nReturn
					FROM cusfocus.case_log, 
						cusfocus.cusfocus_user 
					WHERE ( (cusfocus.case_log.case_log_case_rep in ( select user_id
											  from cusfocus.cusfocus_user
											  where user_dept_id = :i_sUOReportParms.string_parm2 ) 
								 AND cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_case_rep ) )
					
								 AND cusfocus.case_log.case_log_clsd_date is not null 
								 AND cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 
								 AND cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
					 USING SQLCA;
				
				END IF		
				
			ELSE
				
				IF i_sUOReportParms.string_parm3 = 'T' THEN
				
					SELECT count(cusfocus.case_log.case_log_taken_by) INTO :l_nReturn
					FROM cusfocus.case_log, 
						cusfocus.cusfocus_user 
					WHERE ( (cusfocus.case_log.case_log_taken_by = :i_sUOReportParms.string_parm2 AND  
						cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_taken_by ) ) AND
						cusfocus.case_log.case_log_clsd_date is not null AND
						cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 AND  
							  cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
							  USING SQLCA;
				
				ELSE
				
					SELECT count(cusfocus.case_log.case_log_case_rep) INTO :l_nReturn
					FROM cusfocus.case_log, 
						cusfocus.cusfocus_user 
					WHERE ( (cusfocus.case_log.case_log_case_rep = :i_sUOReportParms.string_parm2 AND  
						cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_case_rep ) ) AND
						cusfocus.case_log.case_log_clsd_date is not null AND
						cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 AND  
							  cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
				USING SQLCA;
				
				END IF			
				
			END IF
	
		END IF
		
		IF l_nReturn > 0 THEN
			
			l_nReturn = dw_pre_retrieve_report.Retrieve (i_sUOReportParms.string_parm1, &
													 i_sUOReportParms.string_parm2, &
													 i_sUOReportParms.string_parm3, &
													 i_sUOReportParms.date_parm1, &
													 i_sUOReportParms.date_parm2, &
													 i_cUserName)
			
		END IF
		
	
	CASE 'd_category_analysis_report'
	// Category Analysis Report 
		IF i_sUOReportParms.string_parm1 <> '' THEN
	
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			
			
			SQLCA.dbParm = "StaticBind = 0"			
			l_nReturn = dw_pre_retrieve_report.Retrieve (i_sUOReportParms.string_parm1, &
													 i_sUOReportParms.string_parm2, &
													 i_sUOReportParms.string_parm3, &
													 i_sUOReportParms.date_parm1, &
													 i_sUOReportParms.date_parm2, &
													 i_cUserName)
			SQLCA.dbParm = "StaticBind = 1"			
												
			dw_pre_retrieve_report.Sort( )
			dw_pre_retrieve_report.GroupCalc( )
			
		END IF
	
	CASE 'd_consumer_rpt_nested'
	// Member Profile Report
		IF i_sUOReportParms.string_parm1 <> '' THEN
	
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			
			l_nYear = Year(Today())
			
			l_dStartDate = Date(i_sUOReportParms.date_parm1)
			
			 IF Mod ( l_nYear, 4 ) = 0 THEN
				l_dEndDate = RelativeDate(l_dStartDate, 365)
			ELSE
				l_dEndDate = RelativeDate(l_dStartDate, 365)
			END IF
					
			  SELECT count(cusfocus.consumer.consumer_id) INTO :l_nReturn
				 FROM cusfocus.consumer, cusfocus.case_log
				WHERE cusfocus.consumer.consumer_id = :i_sUOReportParms.string_parm1
				  AND (cusfocus.case_log.case_log_opnd_date between :l_dStartDate and :l_dEndDate)
				  AND cusfocus.case_log.source_type = 'C'
				  AND cusfocus.case_log.case_subject_id = cusfocus.consumer.consumer_id
				USING SQLCA;
			
		END IF
		
		IF l_nReturn > 0 THEN
	
			l_nReturn = dw_pre_retrieve_report.Retrieve(i_sUOReportParms.date_parm1,&
						 i_sUOReportParms.string_parm1, i_cUserName)
			
		END IF
		
	
	CASE 'd_contact_meth_report'
	// Contact Methods Report
		IF i_sUOReportParms.string_parm1 <> '' THEN
			
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			IF i_sUOReportParms.string_parm1 = 'D' THEN
			
				IF i_sUOReportParms.string_parm3 = 'T' THEN
				
					SELECT count(cusfocus.case_log.case_log_taken_by) INTO :l_nReturn
					FROM cusfocus.case_log, cusfocus.cusfocus_user 
					WHERE ( ( cusfocus.case_log.case_log_taken_by in ( select user_id
											  from cusfocus.cusfocus_user
											  where user_dept_id = :i_sUOReportParms.string_parm2 ) 
								 AND cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_taken_by ) ) 
								 AND cusfocus.case_log.case_log_clsd_date is not null 
								 AND cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 
								 AND cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
					 USING SQLCA;
				
				ELSE
				
					SELECT count(cusfocus.case_log.case_log_case_rep) INTO :l_nReturn
					FROM cusfocus.case_log, 
						cusfocus.cusfocus_user 
					WHERE ( (cusfocus.case_log.case_log_case_rep in ( select user_id
											  from cusfocus.cusfocus_user
											  where user_dept_id = :i_sUOReportParms.string_parm2 ) 
								 AND cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_case_rep ) )
					
								 AND cusfocus.case_log.case_log_clsd_date is not null 
								 AND cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 
								 AND cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
					 USING SQLCA;
				
				END IF		
				
			ELSE
				
				IF i_sUOReportParms.string_parm3 = 'T' THEN
				
					SELECT count(cusfocus.case_log.case_log_taken_by) INTO :l_nReturn
					FROM cusfocus.case_log, 
						cusfocus.cusfocus_user 
					WHERE ( (cusfocus.case_log.case_log_taken_by = :i_sUOReportParms.string_parm2 AND  
						cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_taken_by ) ) AND
						cusfocus.case_log.case_log_clsd_date is not null AND
						cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 AND  
							  cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
							  USING SQLCA;
				
				ELSE
				
					SELECT count(cusfocus.case_log.case_log_case_rep) INTO :l_nReturn
					FROM cusfocus.case_log, 
						cusfocus.cusfocus_user 
					WHERE ( (cusfocus.case_log.case_log_case_rep = :i_sUOReportParms.string_parm2 AND  
						cusfocus.cusfocus_user.user_id = cusfocus.case_log.case_log_case_rep ) ) AND
						cusfocus.case_log.case_log_clsd_date is not null AND
						cusfocus.case_log.case_log_clsd_date >= :i_sUOReportParms.date_parm1 AND  
							  cusfocus.case_log.case_log_clsd_date <= :i_sUOReportParms.date_parm2
				USING SQLCA;
				
				END IF			
				
			END IF
	
		END IF
		
		IF l_nReturn > 0 THEN
			
			IF i_sUOReportParms.string_parm3= 'T' THEN
				l_nReturn = dw_pre_retrieve_report.Retrieve (i_sUOReportParms.string_parm1, &
														 i_sUOReportParms.string_parm2, &
														 '', '', &
														 i_sUOReportParms.date_parm1, &
														 i_sUOReportParms.date_parm2, i_cUserName)
			ELSE
				l_nReturn = dw_pre_retrieve_report.Retrieve ('', '', &
														 i_sUOReportParms.string_parm1, &
														 i_sUOReportParms.string_parm2, &
														 i_sUOReportParms.date_parm1, &
														 i_sUOReportParms.date_parm2, i_cUserName)
			END IF
			
		END IF		
	
	CASE 'd_critical_mem_report', 'd_critical_prov_report', 'd_critical_grp_report'
	// Critical Members Analysis Report, Critical Providers Analysis Report, Critical Groups Analysis Report
		IF i_sUOReportParms.string_parm1 <> '' THEN
				
			i_dtStartDate = i_sUOReportParms.date_parm1
			i_dtEndDate = i_sUOReportParms.date_parm2
			
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			
					IF i_sUOReportParms.string_parm1 = '(All)' THEN
					
						IF i_sUOReportParms.string_parm2 = '(All)' THEN
					
							 SELECT count(cusfocus.case_log.case_number) INTO :l_nReturn
								FROM cusfocus.case_log, cusfocus.consumer, cusfocus.employer_group
							  WHERE cusfocus.case_log.source_type = 'C'
								 AND cusfocus.case_log.group_id = cusfocus.employer_group.group_id
								 AND cusfocus.case_log.case_subject_id = cusfocus.consumer.consumer_id
								 AND cusfocus.case_log.case_log_opnd_date >= :i_dtStartDate
								 AND cusfocus.case_log.case_log_opnd_date <= :i_dtEndDate
								 AND cusfocus.case_log.case_type in ('C','I','M','P')
								 AND cusfocus.case_log.case_status_id in ('C','O','V')
							 USING SQLCA;
					
						ELSE
							
							 SELECT count(cusfocus.case_log.case_number) INTO :l_nReturn
								FROM cusfocus.case_log, cusfocus.consumer, cusfocus.employer_group
							  WHERE cusfocus.case_log.source_type = 'C'
								 AND cusfocus.case_log.group_id = cusfocus.employer_group.group_id
								 AND cusfocus.case_log.case_subject_id = cusfocus.consumer.consumer_id
								 AND cusfocus.case_log.case_log_opnd_date >= :i_dtStartDate
								 AND cusfocus.case_log.case_log_opnd_date <= :i_dtEndDate
								 AND cusfocus.case_log.case_type in ('C','I','M','P')
								 AND cusfocus.case_log.case_status_id = :i_sUOReportParms.string_parm2
							 USING SQLCA;
							 
						END IF
					
					ELSE
					
						IF i_sUOReportParms.string_parm2 = '(All)' THEN
					
							 SELECT count(cusfocus.case_log.case_number) INTO :l_nReturn
								FROM cusfocus.case_log, cusfocus.consumer, cusfocus.employer_group
							  WHERE cusfocus.case_log.source_type = 'C'
								 AND cusfocus.case_log.group_id = cusfocus.employer_group.group_id
								 AND cusfocus.case_log.case_subject_id = cusfocus.consumer.consumer_id
								 AND cusfocus.case_log.case_log_opnd_date >= :i_dtStartDate
								 AND cusfocus.case_log.case_log_opnd_date <= :i_dtEndDate
								 AND cusfocus.case_log.case_type = :i_sUOReportParms.string_parm1
								 AND cusfocus.case_log.case_status_id in ('C','O','V')
							 USING SQLCA;
					
					
						ELSE
					
							 SELECT count(cusfocus.case_log.case_number) INTO :l_nReturn
								FROM cusfocus.case_log, cusfocus.consumer, cusfocus.employer_group
							  WHERE cusfocus.case_log.source_type = 'C'
								 AND cusfocus.case_log.group_id = cusfocus.employer_group.group_id
								 AND cusfocus.case_log.case_subject_id = cusfocus.consumer.consumer_id
								 AND cusfocus.case_log.case_log_opnd_date >= :i_dtStartDate
								 AND cusfocus.case_log.case_log_opnd_date <= :i_dtEndDate
								 AND cusfocus.case_log.case_type = :i_sUOReportParms.string_parm1
								 AND cusfocus.case_log.case_status_id = :i_sUOReportParms.string_parm2
							 USING SQLCA;
							 
						END IF
						
					END IF
										 
				END IF
				
				IF l_nReturn > 0 THEN
						
					i_dtStartDate = i_sUOReportParms.date_parm1
					i_dtEndDate = i_sUOReportParms.date_parm2

					l_nReturn = dw_pre_retrieve_report.Retrieve(i_dtStartDate, i_dtEndDate, i_sUOReportParms.string_parm1, &
								i_sUOReportParms.num_parm1, i_sUOReportParms.string_parm2, i_cUserName)
				END IF
			
	
	CASE 'd_iss_act_by_category'
	// Group Contact Activity
		IF i_sUOReportParms.string_parm1 <> '' THEN
			i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
			i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
			
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			
	  SELECT count(categories_b.category_id) INTO :l_nReturn
		 FROM cusfocus.case_log,   
				cusfocus.categories categories_a,   
				cusfocus.categories categories_b,   
				cusfocus.employer_group  
		WHERE ( cusfocus.case_log.category_id = categories_a.category_id ) and  
				( cusfocus.case_log.root_category_name = categories_b.category_name ) and  
				( cusfocus.employer_group.group_id = cusfocus.case_log.case_subject_id ) and  
				( cusfocus.case_log.case_type = 'C' ) AND  
				( cusfocus.case_log.case_log_opnd_date >= :i_dStartDate )  AND  
				( cusfocus.case_log.source_type = 'E' ) AND  
				( cusfocus.case_log.case_subject_id = :i_sUOReportParms.string_parm1  ) AND  
				( cusfocus.case_log.case_log_opnd_date <= :i_dEndDate )    
				USING SQLCA;
			
		END IF

		IF l_nReturn > 0 THEN
			i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
			i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
			
			l_nReturn = dw_pre_retrieve_report.retrieve(i_dStartDate, i_dEndDate, i_cUserName, i_sUOReportParms.string_parm1, i_cUserName)
	
		END IF
		
		
	CASE 'd_inq_act_by_category'
		IF i_sUOReportParms.string_parm1 <> '' THEN
			i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
			i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
			
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
		
		  SELECT count(categories_b.category_id) INTO :l_nReturn
			 FROM cusfocus.case_log,   
					cusfocus.categories categories_a,   
					cusfocus.categories categories_b,   
					cusfocus.employer_group  
			WHERE ( cusfocus.case_log.category_id = categories_a.category_id ) and  
					( cusfocus.case_log.root_category_name = categories_b.category_name ) and  
					( cusfocus.employer_group.group_id = cusfocus.case_log.case_subject_id ) and  
					( cusfocus.case_log.case_type = 'I' ) AND  
					( cusfocus.case_log.case_log_opnd_date >= :i_dStartDate )  AND  
					( cusfocus.case_log.source_type = 'E' ) AND  
					( cusfocus.case_log.case_subject_id = :i_sUOReportParms.string_parm1 ) AND  
					( cusfocus.case_log.case_log_opnd_date <= :i_dEndDate )    
					USING SQLCA;
			END IF
			
			IF l_nReturn > 0 THEN
				i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
				i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
				
				l_nReturn = dw_pre_retrieve_report.retrieve(i_dStartDate, i_dEndDate, i_cUserName, i_sUOReportParms.string_parm1, i_cUserName)
		
			END IF			
		
	CASE 'd_grp_mem_rpt_card_nested'
	
		IF i_sUOReportParms.string_parm1 <> '' THEN
			i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
			i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
			
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			
		  SELECT count(cusfocus.employer_group.group_id)  INTO :l_nReturn
			 FROM cusfocus.employer_group  
			WHERE cusfocus.employer_group.group_id = :i_sUOReportParms.string_parm1   
			USING SQLCA;
	
		END IF
		
		IF l_nReturn > 0 THEN
			i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
			i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
			
			l_nReturn = dw_pre_retrieve_report.retrieve(i_dStartDate, i_dEndDate, i_cUserName, i_sUOReportParms.string_parm1, i_cUserName)
	
		END IF

	CASE 'd_group_contact_nested'
	// Group Contact Activity
		IF i_sUOReportParms.string_parm1 <> '' THEN
			i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
			i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
			
			dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
			dw_pre_retrieve_report.SetTransObject(SQLCA)
			
		  SELECT count(cusfocus.employer_group.group_id) INTO :l_nReturn
			 FROM cusfocus.case_log,   
					cusfocus.employer_group  
			WHERE ( cusfocus.case_log.case_log_opnd_date >= :i_dStartDate ) and
					( cusfocus.case_log.case_log_opnd_date <= :i_dEndDate ) AND
					( cusfocus.employer_group.group_id = cusfocus.case_log.case_subject_id ) and  
					( cusfocus.case_log.case_status_id <> 'V' ) AND  
					( cusfocus.case_log.source_type = 'E' )  AND  
					cusfocus.case_log.case_subject_id = :i_sUOReportParms.string_parm1    
			USING SQLCA;
		
		END IF
		
		IF l_nReturn > 0 THEN
			i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
			i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
			
			l_nReturn = dw_pre_retrieve_report.retrieve(i_dStartDate, i_dEndDate, i_cUserName, i_sUOReportParms.string_parm1, i_cUserName)
	
		END IF
		
	CASE 'd_svc_center_act_nested', 'd_prov_contact_act_nested'
	// Provider Report Card 
	
		FOR l_nIndex = 1 TO UpperBound(i_sUOReportParms.long_parm1)
			
		  SELECT count(*) INTO :l_nReturn
			 FROM cusfocus.case_log
			WHERE case_subject_id = convert(varchar(30),:i_sUOReportParms.long_parm1[l_nIndex])
			USING SQLCA;
			
			IF l_nReturn > 0 THEN
				EXIT
			END IF
		
		NEXT
		
		
		IF UpperBound (i_sUOReportParms.long_parm1) < 1 THEN
			RETURN
		ELSE
			i_nProvKeys = i_sUOReportParms.long_parm1
			i_dStartDate = i_sUOReportParms.date_parm3
			i_dEndDate = i_sUOReportParms.date_parm4
			
			
			IF UpperBound( i_nProvKeys ) > 0 THEN
				FOR l_nKeyIndex = 1 TO UpperBound( i_nProvKeys )
					l_cProvKeys[ l_nKeyIndex ] = String( i_nProvKeys[ l_nKeyIndex ] )
				NEXT
			END IF			
		END IF
		
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.Modify("t_provid.Text = '" + i_sUOReportParms.string_parm1 + "'")
		dw_pre_retrieve_report.Modify("t_vendid.Text = '" + i_sUOReportParms.string_parm2 + "'")
		
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
	//  	l_nReturn = dw_pre_retrieve_report.Retrieve(i_dStartDate, i_dEndDate, i_cUserName, l_cProvKeys, i_cUserName)		 
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_dStartDate, i_dEndDate, i_cUserName, l_cProvKeys)	
		
	CASE 'd_tot_contact' 
	// Total Contact Activity
		dw_pre_retrieve_report.Modify("cc_user_name.Text = '" + i_cUserName + "'")
		dw_pre_retrieve_report.GetChild("d_open_cases",l_dwcChild)
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		l_dwcChild.SetTransObject(SQLCA)
		l_dwcChild.Retrieve(Today())
		dw_pre_retrieve_report.GetChild("d_closed_cases",l_dwcChild)
		l_dwcChild.SetTransObject(SQLCA)
		l_dwcChild.Retrieve(Today())
		dw_pre_retrieve_report.GetChild("d_total_cases",l_dwcChild)
		l_dwcChild.SetTransObject(SQLCA)
		l_nReturn = l_dwcChild.Retrieve(Today())
	
	CASE 'd_tot_contact_act' 
	// Annual Contact Activity
		THIS.SetRedraw(FALSE)
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		l_cStartDate = '1/1/' + String (Year (Today ()))
		l_cEndDate = '12/31/' + String (Year (Today ()))
		l_dStartDate = Date (l_cStartDate)
		l_dEndDate = Date (l_cEndDate)
		l_dtStartDT = DateTime (l_dStartDate)
		l_dtEndDT = DateTime (l_dEndDate)
		
	  SELECT count(cusfocus.case_log.case_number)  INTO :l_nReturn
		 FROM cusfocus.case_log,   
				cusfocus.case_types  
		WHERE ( cusfocus.case_log.case_type = cusfocus.case_types.case_type ) and  
				( cusfocus.case_log.case_log_opnd_date between :l_dStartDate and :l_dEndDate ) AND  
				( cusfocus.case_log.case_status_id <> 'V' )     
		USING SQLCA;
		
		
		IF l_nReturn > 0 THEN
			dw_pre_retrieve_report.Retrieve(l_dtStartDT,l_dtEndDT,TRIM(i_cUserName))
		END IF
		
		THIS.SetRedraw(TRUE)
		
	// Vermont Custom Reports
	CASE 'd_case_counts_vt'
	// Case Counts Report
		i_cLineOfBusiness = i_sUOReportParms.string_parm4
		i_cSubscriberType = i_sUOReportParms.string_parm1
		i_cParentGroup = i_sUOReportParms.string_parm2
		i_cGroup = i_sUOReportParms.string_parm3
		i_cStartDate = i_sUOReportParms.string_parm5
		i_cEndDate = i_sUOReportParms.string_parm6
		i_cAllExceptFEP = i_sUOReportParms.string_parm7
		l_nPos = POS(i_cEndDate,' ')
		i_cEndDate = MID(i_cEndDate,1,l_nPos - 1) + " 23:59:59"
	
		IF i_cLineOfBusiness = "()" THEN
			i_cLineOfBusiness = ''
		END IF
		
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, i_cStartDate, i_cEndDate)
			
	
	CASE 'd_case_timeliness_vt'
	// Case Timeliness Report
		i_cLineOfBusiness = i_sUOReportParms.string_parm4
		i_cSubscriberType = i_sUOReportParms.string_parm1
		i_cParentGroup = i_sUOReportParms.string_parm2
		i_cGroup = i_sUOReportParms.string_parm3
		i_cStartDate = i_sUOReportParms.string_parm5
		i_cEndDate = i_sUOReportParms.string_parm6
		i_cAllExceptFEP = i_sUOReportParms.string_parm7
		l_nPos = POS(i_cEndDate,' ')
		i_cEndDate = MID(i_cEndDate,1,l_nPos - 1) + " 23:59:59"
		i_nClosedDays = i_sUOReportParms.num_parm1
		
		IF i_cLineOfBusiness = "()" THEN
			i_cLineOfBusiness = ''
		END IF
	
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
	
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, &
		i_cStartDate, i_cEndDate, i_nClosedDays, i_cUserName)
	
	CASE 'd_inquiry_sampling_vt'
	// Inquiry Sampling Report
		i_cLineOfBusiness = i_sUOReportParms.string_parm4
		i_cSubscriberType = i_sUOReportParms.string_parm1
		i_cParentGroup = i_sUOReportParms.string_parm2
		i_cGroup = i_sUOReportParms.string_parm3
		i_cStartDate = i_sUOReportParms.string_parm5
		i_cEndDate = i_sUOReportParms.string_parm6
		i_cAllExceptFEP = i_sUOReportParms.string_parm7
		l_nPos = POS(i_cEndDate,' ')
		i_cEndDate = MID(i_cEndDate,1,l_nPos - 1) + " 23:59:59"
		i_nSampleSet = i_sUOReportParms.num_parm1
		
		IF i_cLineOfBusiness = "()" THEN
			i_cLineOfBusiness = ''
		END IF
		
		dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_pre_retrieve_report.SetTransObject(SQLCA)
		
		l_nReturn = dw_pre_retrieve_report.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, &
		i_cStartDate, i_cEndDate, i_nSampleSet, i_cUserName)
		
	// HealthGuard Custom Reports
	CASE 'd_case_inquiry_all_hg','d_case_inquiry_first_hg'
	// Case Inquiry Report
	 IF i_sUOReportParms.report_type <> '' THEN
	  
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.category_id, i_sUOReportParms.start_date_string, &
							  i_sUOReportParms.end_date_string, i_sUOReportParms.report_type)
						  
		END IF

	// Department Report All Source Types, Provider
	CASE 'd_dept_all_hg','d_dept_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
		             i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Department Report Group
	CASE 'd_dept_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
		             i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Department Report Member
	CASE 'd_dept_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
		             i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF

	// Dissatisfaction Report All Source Types, Providers
	CASE 'd_dissat_all_hg','d_dissat_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
		
	// Dissatisfaction Report Groups
	CASE 'd_dissat_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
		
	// Dissatisfaction Report Members
	CASE 'd_dissat_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received Report All Source Types, Providers
	CASE 'd_rcvd_all_hg','d_rcvd_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received Report Group
	CASE 'd_rcvd_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received Report Member
	CASE 'd_rcvd_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received-Resolved Report All Source Types, Providers
	CASE 'd_rcvd_rslvd_all_hg','d_rcvd_rslvd_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received-Resolved Report Group
	CASE 'd_rcvd_rslvd_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received-Resolved Report Member
	CASE 'd_rcvd_rslvd_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Representative Report All Source Types, Providers
	CASE 'd_rep_all_hg','d_rep_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Representative Report Group
	CASE 'd_rep_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Representative Report Member
	CASE 'd_rep_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_pre_retrieve_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_pre_retrieve_report.SetTransObject(SQLCA)
		  fu_prep_report_hg()
		  l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
		
	CASE 'd_month_appl_lvl_one_hg','d_month_appl_lvl_two_hg','d_month_appl_lvl_three_hg'
		l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.start_date_string, i_sUOReportParms.end_date_string, &
		              i_sUOReportParms.appeal_level, i_sUOReportParms.report_type)
						  
	CASE 'd_customer_contact_activity_phcs','d_customer_contact_activity_summary_phcs'
		l_nReturn = dw_pre_retrieve_report.retrieve(i_sUOReportParms.start_date, i_sUOReportParms.end_date, i_sUOReportParms.user_array[], gs_ConfigCaseType)

END CHOOSE

IF l_nReturn > 0 OR w_supervisor_portal.i_cShowBlankReport = "Y" THEN
	IF l_nReturn <= 0 AND w_supervisor_portal.i_cShowBlankReport = "Y" THEN
		messagebox(gs_AppName,'No data found for this report')
		
		IF a_cViewType = "P" THEN
			l_nRow = dw_pre_retrieve_report.InsertRow( 0 )
			
			IF i_cDataWindow = "d_prov_contact_act_nested" OR i_cDataWindow = "d_svc_center_act_nested" THEN
				IF NOT IsNull( i_sUOReportParms.string_parm1 ) AND Trim( i_sUOReportParms.string_parm1 ) <> "" THEN
					SELECT provider_key, vendor_id, provid_name
					INTO :l_nProvKey, :l_cVendID, :l_cProvName
					FROM cusfocus.provider_of_service
					WHERE provider_id = :i_sUOReportParms.string_parm1
					USING SQLCA;
					
					dw_pre_retrieve_report.Object.provider_of_service_provid_name[ l_nRow ] = l_cProvName
					dw_pre_retrieve_report.Object.provider_id[ l_nRow ] = i_sUOReportParms.string_parm1
					dw_pre_retrieve_report.Object.provider_of_service_provider_key[ l_nRow ] = l_nProvKey
					dw_pre_retrieve_report.Object.vendor_id[ l_nRow ] = l_cVendID
				END IF
			END IF
		END IF
	END IF
	
	IF a_cViewType = "P" THEN
		// Print the report
		SetPointer(HOURGLASS!)
		dw_pre_retrieve_report.Print()
		SetPointer(Arrow!)
	ELSEIF a_cViewType = "V" THEN
		//View the report
		i_sUOReportParms.datawindow_name = i_cDataWindow
		//If the window is already open, simply call an event to load the report.
		//  Necessary as for some reason the open event of the window isn't
		//  re-fired when fu_openwindow is called.
		IF IsValid( w_supervisor_reports ) THEN
			w_supervisor_reports.Event Trigger ue_getreport( i_sUOReportParms )
		ELSE
			FWCA.MGR.fu_OpenWindow(w_supervisor_reports,-1,i_sUOReportParms)
		END IF
	END IF
ELSE
	messagebox(gs_AppName,'No data found for this report')
END IF
end subroutine

on u_reports.create
int iCurrent
call super::create
this.dw_pre_retrieve_report=create dw_pre_retrieve_report
this.dw_report_list=create dw_report_list
this.st_1=create st_1
this.cb_view=create cb_view
this.cb_print=create cb_print
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_pre_retrieve_report
this.Control[iCurrent+2]=this.dw_report_list
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_view
this.Control[iCurrent+5]=this.cb_print
end on

on u_reports.destroy
call super::destroy
destroy(this.dw_pre_retrieve_report)
destroy(this.dw_report_list)
destroy(this.st_1)
destroy(this.cb_view)
destroy(this.cb_print)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: to set options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  11/16/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING l_cFirstName, l_cLastName, l_cMI

dw_pre_retrieve_report.fu_SetOptions(SQLCA, dw_pre_retrieve_report.c_NullDW, &
		dw_pre_retrieve_report.c_Default+ dw_pre_retrieve_report.c_NoRetrieveOnOpen)
		
i_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

// Get User Name for reports
SELECT user_first_name, user_last_name, user_mi INTO :l_cFirstName, :l_cLastName, :l_cMI
  FROM cusfocus.cusfocus_user
 WHERE user_id = :i_cLogin
 USING SQLCA;
 
IF IsNull(l_cFirstName) THEN
	l_cFirstName = ''
END IF

IF IsNull(l_cMI) THEN
	l_cMI = ''
END IF
 
i_cUserName = TRIM(l_cLastName +', '+l_cFirstName + ' ' +l_cMI)

i_nUserNameLen = LEN(i_cUserName)

IF UPPER(i_cLogin) = 'CFADMIN' THEN
// 9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//IF UPPER(i_cLogin) = 'SYSADMIN' THEN
	dw_report_list.fu_swap('d_external_report_list_sysadmin', c_SaveChanges, c_Default)
ELSE
	dw_report_list.fu_swap('d_external_report_list', c_SaveChanges, c_Default)
END IF
	
// Retrieve report list
dw_report_list.SetTransObject(SQLCA)
dw_report_list.Retrieve(i_cLogin)

//Initialize the resize service
THIS.of_SetResize( TRUE )

THIS.inv_resize.of_SetOrigSize (THIS.width, THIS.height)

THIS.inv_resize.of_SetMinSize (THIS.width, THIS.height)

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( dw_report_list , THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( cb_print , THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( cb_view , THIS.inv_resize.FIXEDRIGHTBOTTOM )
END IF


end event

type dw_pre_retrieve_report from u_dw_std within u_reports
boolean visible = false
integer x = 119
integer y = 400
integer width = 649
integer height = 768
integer taborder = 10
boolean enabled = false
string dataobject = "d_call_cntr_contact_rpt"
end type

type dw_report_list from u_dw_std within u_reports
integer x = 14
integer y = 92
integer width = 3008
integer height = 1484
integer taborder = 10
string dataobject = "d_external_report_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event constructor;call super::constructor;//*********************************************************************************************
//
//  Event:   constructor
//  Purpose: Set up resize
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  11/13/00 C. Jackson  Original Version
//  5/1/2002 K. Claver   Changed to just scaleright.  Also added resize for the line.
//
//*********************************************************************************************

//Initialize the resize service
THIS.of_SetResize( TRUE )

////Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( 'report_desc', THIS.inv_resize.SCALERIGHT )
	THIS.inv_resize.of_Register( 'l_1', THIS.inv_resize.SCALERIGHT )
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: set options on the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/15/00 C. Jackson  Original Version
//
//**********************************************************************************************

fu_SetOptions (SQLCA, c_NullDW, c_SelectOnRowFocusChange + c_NoEnablePopup + c_SortClickedOK)
end event

event clicked;call super::clicked;//***********************************************************************************************
//  
//  Event:   clicked
//  Purpose: Make sure the Case History report isn't available
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/04/00 c. jackson  Original Version
//
//***********************************************************************************************

m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: To open report for view
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/05/00 c. jackson  Original Version
//
//***********************************************************************************************

cb_view.TriggerEvent(Clicked!)
end event

type st_1 from statictext within u_reports
integer x = 27
integer y = 16
integer width = 873
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Report to Print or Preview"
boolean focusrectangle = false
end type

type cb_view from commandbutton within u_reports
integer x = 2702
integer y = 1600
integer width = 297
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&View"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to View selected report
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  11/16/00 C. Jackson  Original Version  
//  01/04/01 C. Jackson  display a messagebox if Crystal or Access not installed (SCR 1187,1226)
//  03/30/01 C. Jackson  Close the report window if it is already open (SCR 1574)
//  06/27/01 C. Jackson  Initialize l_cAppPath to null
//  10/09/01 C. Jackson  remove retrieves, being done in fu_getdata instead (SCR 2143)
//  5/20/2002 K. Claver  Changed to call an event on the window to load the report if the window
//								 is already open.  Necessary as for some reason the open event isn't
//								 re-fired when fu_openwindow is called.
//  5/20/2002 K. Claver  Moved view code to fu_getdata function so could post the function(SCR 3095)
//***********************************************************************************************

STRING l_cExtSource,  l_cAppPath, l_cDataWindow, l_cMacro, l_cPath
LONG l_nDWRow, l_nFileNum, l_nPos, l_nReturn, l_nParmReturn
BOOLEAN l_bAppRunning, l_bAlreadyRunning
inet linet_base
Long l_nRV

SETNULL(l_cAppPath)

l_nDWRow = dw_report_list.GetRow()

IF l_nDWRow <> 0 THEN
	l_cExtSource = dw_report_list.GetItemString(l_nDWRow,'reports_external_source')
	
	l_cPath = dw_report_list.GetItemString(l_nDWRow,'reports_path')
	
	CHOOSE CASE l_cExtSource
		CASE 'MSACCESS'
				RegistryGet( &
					"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\MSAccess.exe","",RegString!, l_cAppPath)
				IF ISNULL(l_cAppPath) THEN
					Messagebox(gs_AppName,'This workstation does not have Microsoft Access installed.')
					RETURN
				END IF
				
				l_cMacro = dw_report_list.GetItemString(l_nDWRow,'reports_macro')
				
				l_cAppPath = l_cAppPath + ' "' + l_cPath + '" /x ' + l_cMacro

				RUN(l_cAppPath,Maximized!)
	
		CASE "CRYSTAL"	
			RegistryGet( &
				"HKEY_LOCAL_MACHINE\SOFTWARE\Seagate Software\Crystal Reports", "Path", RegString!, l_cAppPath )
			IF ISNULL (l_cAppPath) THEN
				Messagebox(gs_AppName,'This workstation does not have Seagate Crystal Reports installed.')
				RETURN
			END IF
			
			Run(l_cPath, Normal!)
			
		CASE "INTERNET"
		
				If Len(l_cPath) > 0 and Not IsNull(l_cPath) Then
					IF lower(MID(l_cPath,1,5)) = "https" THEN l_cPath = MID(l_cPath,9)
					IF lower(MID(l_cPath,1,4)) = "http" THEN l_cPath = MID(l_cPath,8)
					
					GetContextService("Internet", linet_base)
					l_nRV = linet_base.HyperlinkToURL(l_cPath)
				END IF

		CASE ELSE
			i_cDataWindow = dw_report_list.GetItemString(l_nDWRow,'reports_report_dtwndw_frmt_strng')

		IF (i_cDataWindow <> 'd_tot_contact') AND (i_cDataWindow <> 'd_tot_contact_act') THEN
			// Get the parms
			l_nParmReturn = fu_GetParms()
		ELSE
			l_nParmReturn = 0
		END IF
		
		IF l_nParmReturn = 0 THEN
			// Retrieve the datawindow to determine if we need to open the report window
			PARENT.Function Post fu_GetData( "V" )
		END IF	
	END CHOOSE
END IF


end event

type cb_print from commandbutton within u_reports
integer x = 2377
integer y = 1600
integer width = 297
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To print the selected report
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  11/30/00 C. Jackson  Original Version
//  07/06/01 C. Jackson  Add DESTROY l_dsOtherCloseCode
//  08/08/01 C. Jackson  Correct end date to have " 23:59:59" at the end rather than default of
//                       " 00:00:00"
//  08/08/01 M. Caruso   Corrected parameter gathering for d_grp_mem_rpt_card_nested.
//  11/15/01 C. Jackson  Remove fu_GetLogin.  It is already called in pc_setoptions.
//  5/20/2002 K. Claver  Moved print code to fu_getdata function so could post the function(SCR 3095)
//**********************************************************************************************

LONG l_nRow, l_nParmReturn, l_nReturn
BOOLEAN l_bPrintOK

l_nRow = dw_report_list.GetRow()

IF l_nRow <> 0 THEN

	i_cDataWindow = dw_report_list.GetItemString(l_nRow,'reports_report_dtwndw_frmt_strng')
	
	IF ISNULL(i_cDataWindow) THEN
		messagebox(gs_Appname,'External reports cannot be printed directly, please View report then '+ &
				'print from the external application.')
				
	ELSE
		// Swap the print datawindow to the specified datawindow.
		
		IF (i_cDataWindow <> 'd_tot_contact') AND (i_cDataWindow <> 'd_tot_contact_act') THEN
			l_nParmReturn = fu_GetParms()
		ELSE
			
			l_nParmReturn = 0
			
		END IF
			
		IF l_nParmReturn = 0 THEN
			
			// swap the data window and do the retrieve
			PARENT.Function Post fu_GetData( "P" )			

		END IF	
	END IF	
END IF


end event

