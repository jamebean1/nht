$PBExportHeader$w_supervisor_reports.srw
$PBExportComments$Reports window
forward
global type w_supervisor_reports from w_main_std
end type
type dw_print_report from u_dw_std within w_supervisor_reports
end type
end forward

global type w_supervisor_reports from w_main_std
integer x = 0
integer y = 0
integer width = 3653
integer height = 1904
string title = "Supervisor Reports"
string menuname = "m_supervisor_reports"
event ue_printreport ( )
event ue_getreport ( s_report_parms l_sreportparms )
dw_print_report dw_print_report
end type
global w_supervisor_reports w_supervisor_reports

type variables
STRING i_cLogin
STRING i_cSourceID
STRING i_cCaseTypes[]
STRING i_cSourceTypes[]
STRING i_cCaseStatus[]
STRING i_cSubscriberType
STRING i_cParentGroup
STRING i_cAllExceptFEP
STRING i_cGroup
STRING i_cLineOfBusiness
STRING i_cCloseCode
STRING i_cStartDate
STRING i_cEndDate
STRING i_cCaseType
STRING i_cCaseStatusID
STRING i_cDataWindow
STRING i_cUserName

LONG i_nProvKeys[ ]
LONG i_nSecurityLevel
LONG i_nClosedDays
LONG i_nSampleSet
LONG i_nUserNameLen

DATETIME i_dtStartDate
DATETIME i_dtEndDate
DATE i_dStartDate
DATE i_dEndDate

BOOLEAN i_bOutOfOffice
BOOLEAN i_bReportCancel
BOOLEAN i_bGotParms = FALSE

S_REPORT_PARMS i_sUOReportParms
S_REPORT_PARMS	i_sResetParms

end variables

forward prototypes
public subroutine fw_checkoutofoffice ()
public subroutine fw_prep_report_hg ()
public function integer fu_getdata ()
end prototypes

event ue_printreport;//***********************************************************************************************
//
//  Event:   ue_printreport
//  Purpose: print reports
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  4/9/2002 K. Claver   Added in place of calling the pc_print event on the window as the reports
//								 may or may not show as empty to the foundation class as many display
//								 just the sub-reports.
//	 5/22/2002 K. Claver  Added code to bring the window to the top after printing.
//***********************************************************************************************
dw_print_report.Print( )
THIS.BringToTop = TRUE
end event

event ue_getreport;//***********************************************************************************************
//
//  Event:   ue_GetReport
//  Purpose: Swap datawindow and retrieve new report.  Added to be called from u_reports View button
//				 as for some reason the open event of this window isn't re-fired when the window is
//				 already opened and fu_OpenWindow is called on it.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  5/20/2002 K. Claver  Original Version
//  06/20/03 M. Caruso   Changed dw_print_report.fu_swap to use c_Default for properties.
//  07/02/03 M. Caruso   Added the c_NoRetrieveOnOpen property to dw_print_report.fu_swap to prevent
//								 a SQL error on opening of the window.
//***********************************************************************************************
Integer l_nReturn
Long l_nUserKey, l_nProvKey, l_nRow
String l_cLogin, l_cUserName, l_cTitle, l_cProvName, l_cVendID

i_sUOReportParms = l_sReportParms
i_cDataWindow = i_sUOReportParms.Datawindow_Name

SECCA.MGR.fu_GetUsrInfo(l_nUserKey,l_cLogin,l_cUserName)

// Swap the report to the specified report datawindow
dw_print_report.fu_swap(i_cDataWindow, dw_print_report.c_SaveChanges, dw_print_report.c_Default + dw_print_report.c_NoRetrieveOnOpen)
	
// Retrieve the data for the report
l_nReturn = fu_GetData()

IF l_nReturn = -1 AND ( i_cDataWindow = "d_prov_contact_act_nested" OR &
   i_cDataWindow = "d_svc_center_act_nested" ) THEN
	l_nRow = dw_print_report.InsertRow( 0 )
				
	IF NOT IsNull( i_sUOReportParms.string_parm1 ) AND Trim( i_sUOReportParms.string_parm1 ) <> "" THEN
		SELECT provider_key, vendor_id, provid_name
		INTO :l_nProvKey, :l_cVendID, :l_cProvName
		FROM cusfocus.provider_of_service
		WHERE provider_id = :i_sUOReportParms.string_parm1
		USING SQLCA;
		
		dw_print_report.Object.provider_of_service_provid_name[ l_nRow ] = l_cProvName
		dw_print_report.Object.provider_id[ l_nRow ] = i_sUOReportParms.string_parm1
		dw_print_report.Object.provider_of_service_provider_key[ l_nRow ] = l_nProvKey
		dw_print_report.Object.vendor_id[ l_nRow ] = l_cVendID
	END IF
END IF

// Get Window Title
SELECT report_name INTO :l_cTitle
  FROM cusfocus.reports
 WHERE report_dtwndw_frmt_strng = :i_cDataWindow
 USING SQLCA;
 
THIS.Title = l_cTitle

//Initialize the resize service
THIS.of_SetResize( TRUE )

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_SetOrigSize ((Width - 30), (Height - 178))
	THIS.inv_resize.of_SetMinSize ((Width - 30), (Height - 178))

	THIS.inv_resize.of_Register( dw_print_report, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF




end event

public subroutine fw_checkoutofoffice ();//********************************************************************************************
//
//  Function: fw_checkoutofoffice
//  Purpose:  To mark the out of office menu item
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/15/00 cjackson    Original Verison
//
//********************************************************************************************

LONG l_nCount

// Get userid
i_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

// If the user is currently mark as out of the office, setting the Check on the menu item
SELECT count(*) INTO :l_nCount
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cLogin
 USING SQLCA;
 
// Update the clicked property based on whether not the user if Out of Office 
IF l_nCount > 0 THEN
	m_supervisor_reports.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_supervisor_reports.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF







end subroutine

public subroutine fw_prep_report_hg ();//********************************************************************************************
//
//  Function: fw_prep_report_hg
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

public function integer fu_getdata ();//**********************************************************************************************
//
//  Function: fu_GetData
//  Purpose:  Retrieve the print and preview datawindows
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  11/07/01 C. Jackson  Original Version
//  11/14/01 C. Jackson  Add User Name in Re
//  4/9/2002 K. Claver   Removed c_Default from fu_Swap and included c_NoMenuButtonActivation and
//								 c_NoEnablePopup.
//  05/08/02 C. Jackson  Correct report name for Inquiry Sampling (SCR 2886)
//  08/29/02 C. Jackson  Add Retrieve as needed to eliminate out of memory errors
//  01/08/02 C. Jackson  Add HealthGuard Reports
//  06/20/03 M. Caruso   Changed dw_print_report.fu_swap to use c_Default for properties.
//  07/02/03 M. Caruso   Added the c_NoRetrieveOnOpen property to dw_print_report.fu_swap to prevent
//								 a SQL error on opening of the window.
//  09/30/04 C. Haxel    Changed date format in retrieve of d_tot_contact_act to accomocate new 
//                       proc
//  10/09/04 C. Haxel    Add SQLCA.dbParm = "StaticBind = " around Category Analysis Report
//                       to prevent Sybase error.
//**********************************************************************************************

STRING l_cWhere, l_cOldSelect, l_cNewSelect, l_cOrderBy, l_cStartDate, l_cEndDate, l_cRem
STRING l_cCaseTypes[], l_cSourceTypes[], l_cUserName, l_cReturnParm, l_cID, l_cSourceType
STRING l_cSubjectID[], l_cNewSubjectID[], l_cGroupID, l_cGroupName, l_cYear
STRING l_cOtherCloseID, l_cOtherCloseString, l_cSourceID, l_sProviderKeys
STRING l_cNewDataWidth, l_cNewLabelX, l_cModString, l_cProvKeys[ ]
LONG l_nPos, l_nUserKey, l_nYear, l_nPos1, l_nID, l_nRowCount, l_nCaseCount[], l_nIndex
LONG l_nStartRow, l_nConsumerCount, l_nRow
LONG l_nSecurityLevel, l_nPos2, l_nReturn, l_nParmReturn, l_nProviderCount
LONG l_nOldDataX, l_nOldDataWidth, l_nRightEdge, l_nNewDataX
long ll_parm1, ll_parm2, ll_parm3, ll_parm4
DATE l_dtDate, l_dEndDate, l_dStartDate
DATETIME l_dtStartDT, l_dtEndDT
DATASTORE l_dsDataList,  l_dsOtherCloseCode, l_dsProvKeys
DATAWINDOWCHILD	ldwc_child
BOOLEAN l_bPrintOK

CHOOSE CASE i_cDataWindow
	CASE 'd_transfer_time_report'
		i_cDataWindow = 'd_transfer_time_report'
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite Added 1.31.2006 - Adding some stock appeals reports
//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'd_appeal_activity'
		i_cDataWindow = 'd_appeal_activity'
	Case 'd_appeal_outcomes'
		i_cDataWindow = 'd_appeal_outcomes'
	Case 'd_appeal_timeliness'
		i_cDataWindow = 'd_appeal_timeliness'
	Case 'd_appeal_summary'
		i_cDataWindow = 'd_appeal_summary'		
//-----------------------------------------------------------------------------------------------------------------------------------
// End Added JWhite 1.31.2006 
//-----------------------------------------------------------------------------------------------------------------------------------
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
	
dw_print_report.fu_swap(w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow, &
								dw_print_report.c_SaveChanges, &
								dw_print_report.c_Default + &
								dw_print_report.c_NoRetrieveOnOpen)
	
//// Get current position of data field
//l_nOldDataX = LONG(dw_print_report.Describe("cc_user_name.X"))
//l_nOldDataWidth = LONG(dw_print_report.Describe("cc_user_name.Width"))
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
//dw_print_report.Modify(l_cModString)
//
//l_cModString = "cc_user_name.X = '" + string(l_nNewDataX) + "'"
//dw_print_report.Modify(l_cModString)
//
//l_cModString = "cc_user_name.Width = '" + l_cNewDataWidth  + "'"
//dw_print_report.Modify(l_cModString)
//	
	
CHOOSE CASE i_cDataWindow
	
CASE 'd_transfer_time_report'
// Call Center Contact Report
	IF IsNull (i_sUOReportParms.date_parm1) THEN
		RETURN -1
	END IF

	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)

	l_nReturn = dw_print_report.Retrieve(i_sUOReportParms.date_parm1,&
		i_sUOReportParms.date_parm2,i_sUOReportParms.string_parm1, i_sUOReportParms.string_parm2, i_sUOReportParms.string_parm3, i_sUOReportParms.string_parm4, i_sUOReportParms.string_parm5, i_sUOReportParms.string_parm6)
		
//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite - Added 1.31.2006
//-----------------------------------------------------------------------------------------------------------------------------------
Case 'd_appeal_activity', 'd_appeal_outcomes'
	
	ll_parm1 = Long(i_sUOReportParms.string_parm1)
	ll_parm2 = Long(i_sUOReportParms.string_parm2)
	ll_parm3 = Long(i_sUOReportParms.string_parm3)
	ll_parm4 = Long(i_sUOReportParms.string_parm4)
	
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)
	
	l_nReturn = dw_print_report.Retrieve(i_sUOReportParms.date_parm1, i_sUOReportParms.date_parm2, ll_parm3, ll_parm1, ll_parm4, ll_parm2, i_sUOReportParms.string_parm5, i_sUOReportParms.string_parm6, 'N')

Case 'd_appeal_timeliness'
	
	ll_parm1 = Long(i_sUOReportParms.string_parm1)
	ll_parm2 = Long(i_sUOReportParms.string_parm2)
	ll_parm3 = Long(i_sUOReportParms.string_parm3)
	ll_parm4 = Long(i_sUOReportParms.string_parm4)
	
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)
	
	l_nReturn = dw_print_report.Retrieve(i_sUOReportParms.date_parm1, i_sUOReportParms.date_parm2, ll_parm3, ll_parm1, ll_parm4)

Case 'd_appeal_summary'
	
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)
	
	l_nReturn = dw_print_report.Retrieve(i_sUOReportParms.date_parm1, i_sUOReportParms.date_parm2, 'N')

//-----------------------------------------------------------------------------------------------------------------------------------
// JWhite - End Added 1.31.2006
//-----------------------------------------------------------------------------------------------------------------------------------

		
CASE 'd_call_cntr_contact_rpt'
// Call Center Contact Report
	IF IsNull (i_sUOReportParms.date_parm1) THEN
		RETURN -1
	END IF

	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)

	l_nReturn = dw_print_report.Retrieve(i_sUOReportParms.date_parm1,&
		i_sUOReportParms.date_parm2,i_cUserName)
		
CASE 'd_case_detail_history_report_multi'
// Case Detail History Report
	IF ISNULL(i_sUOReportParms.string_parm1) THEN
		RETURN -1
	ELSE
		CHOOSE CASE i_sUOReportParms.string_parm1
			CASE '0'
				l_dsDataList = CREATE DataStore
				l_dsDataList.dataobject = 'dddw_case_status_list'
				dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
				l_dsDataList.SetTransObject(SQLCA)
				l_dsDataList.Retrieve()
				FOR l_nIndex = 1 TO l_dsDataList.RowCount()
					l_cCaseTypes[l_nIndex] = l_dsDataList.GetItemString(l_nIndex,'case_status_id')
				NEXT
				DESTROY l_dsDataList
			CASE ELSE
				l_cCaseTypes[1] = i_sUOReportParms.string_parm1
				
		END CHOOSE
		
		CHOOSE CASE i_sUOReportParms.string_parm2
			CASE '0'
				l_dsDataList = CREATE DataStore
				l_dsDataList.dataobject = 'dddw_source_type_list'
				dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
				l_dsDataList.SetTransObject (SQLCA)
				l_dsDataList.Retrieve ()
				FOR l_nIndex = 1 TO l_dsDataList.RowCount()
					l_cSourceTypes[l_nIndex] = l_dsDataList.GetItemString (l_nIndex, 'source_type')
				NEXT
				DESTROY l_dsDataList
				
			CASE ELSE
				l_cSourceTypes[1] = i_sUOReportParms.string_parm2
		END CHOOSE
		
		SELECT confidentiality_level INTO :l_nSecurityLevel
		  FROM cusfocus.cusfocus_user
		 WHERE user_id = :i_cLogin
		 USING SQLCA;
		 
 		dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_report.SetTransObject(SQLCA)
		IF upperbound(i_sUOReportParms.case_number[]) = 0 THEN
			i_sUOReportParms.case_number[1] = ''
		END IF
		l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_or_dept, i_sUOReportParms.case_status, &
							i_sUOReportParms.source_type, i_sUOReportParms.start_date, i_sUOReportParms.end_date, &
							l_nSecurityLevel, i_sUOReportParms.user_list, i_sUOReportParms.category_array, &
							i_sUOReportParms.category_selected, i_sUOReportParms.case_type, &
							i_sUOReportParms.case_number, i_sUOReportParms.case_selected)
					
	dw_print_report.Object.appname_t.Text = gs_AppName

	END IF
	


CASE 'd_case_timings_report'
// Case Timings Report
	IF i_sUOReportParms.string_parm1 <> '' THEN
		
		dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_report.SetTransObject(SQLCA)
		l_nReturn = dw_print_report.Retrieve (i_sUOReportParms.string_parm1, &
												 i_sUOReportParms.string_parm2, &
												 i_sUOReportParms.string_parm3, &
												 i_sUOReportParms.date_parm1, &
												 i_sUOReportParms.date_parm2, &
												 i_cUserName)
		
	END IF

CASE 'd_category_analysis_report'
// Category Analysis Report 
	IF i_sUOReportParms.string_parm1 <> '' THEN

		dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_report.SetTransObject(SQLCA)
		
		SQLCA.dbParm = "StaticBind = 0" 
		l_nReturn = dw_print_report.Retrieve (i_sUOReportParms.string_parm1, &
												 i_sUOReportParms.string_parm2, &
												 i_sUOReportParms.string_parm3, &
												 i_sUOReportParms.date_parm1, &
												 i_sUOReportParms.date_parm2, &
												 i_cUserName)
 		SQLCA.dbParm = "StaticBind = 0" 
											
		dw_print_report.Sort( )
		dw_print_report.GroupCalc( )
		
	END IF

CASE 'd_consumer_rpt_nested'
// Member Profile Report
	IF i_sUOReportParms.string_parm1 <> '' THEN

		dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_report.SetTransObject(SQLCA)
		l_nReturn = dw_print_report.Retrieve(i_sUOReportParms.date_parm1,&
					 i_sUOReportParms.string_parm1, i_cUserName)
		
	END IF

CASE 'd_contact_meth_report'
// Contact Methods Report
	IF i_sUOReportParms.string_parm1 <> '' THEN
		
		dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_report.SetTransObject(SQLCA)

		IF i_sUOReportParms.string_parm3= 'T' THEN
			l_nReturn = dw_print_report.Retrieve (i_sUOReportParms.string_parm1, &
													 i_sUOReportParms.string_parm2, &
													 '', '', &
													 i_sUOReportParms.date_parm1, &
													 i_sUOReportParms.date_parm2, i_cUserName)
		ELSE
			l_nReturn = dw_print_report.Retrieve ('', '', &
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
		
		dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_report.SetTransObject(SQLCA)
		
		l_nReturn = dw_print_report.Retrieve(i_dtStartDate,i_dtEndDate, i_sUOReportParms.string_parm1, &
					i_sUOReportParms.num_parm1, i_sUOReportParms.string_parm2, i_cUserName)
	END IF

CASE 'd_group_contact_nested', 'd_grp_mem_rpt_card_nested', 'd_inq_act_by_category', 'd_iss_act_by_category'
// Group Contact Activity
	IF i_sUOReportParms.string_parm1 <> '' THEN
		i_dStartDate = date('01/01/'+i_sUOReportParms.string_parm2)
		i_dEndDate = date('12/31/'+i_sUOReportParms.string_parm2)
		
		dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		dw_print_report.SetTransObject(SQLCA)
		l_nReturn = dw_print_report.retrieve(i_dStartDate, i_dEndDate, i_cUserName, i_sUOReportParms.string_parm1, i_cUserName)

	END IF

CASE 'd_prov_contact_act_nested'
// Provider Contact Activity 

	IF UpperBound (i_sUOReportParms.long_parm1) < 1 THEN
		RETURN -1
	ELSE
		i_dStartDate = i_sUOReportParms.date_parm3
		i_dEndDate = i_sUOReportParms.date_parm4
		i_nProvKeys = i_sUOReportParms.long_parm1
	END IF
	
//	FOR l_nIndex = 1 TO UPPERBOUND (i_sUOReportParms.long_parm1)
//		IF l_nIndex = 1 THEN
//			l_cProvKeys = string(i_sUOReportParms.long_parm1[l_nIndex])
//		ELSE
//			l_cProvKeys = l_cProvKeys + ", " + string(i_sUOReportParms.long_parm1[l_nIndex])
//		END IF
//		
//	NEXT

	IF UpperBound( i_nProvKeys ) > 0 THEN
		FOR l_nIndex = 1 TO UpperBound( i_nProvKeys )
			l_cProvKeys[ l_nIndex ] = String( i_nProvKeys[ l_nIndex ] )
		NEXT
	END IF
	
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.Modify("t_provid.Text = '" + i_sUOReportParms.string_parm1 + "'")
	dw_print_report.Modify("t_vendid.Text = '" + i_sUOReportParms.string_parm2 + "'")
	dw_print_report.SetTransObject(SQLCA)

	l_nReturn = dw_print_report.Retrieve(i_dStartDate, i_dEndDate, i_cUserName, l_cProvKeys)					
		
CASE  'd_svc_center_act_nested'
// Provider Contact Activity 

	IF UpperBound (i_sUOReportParms.long_parm1) < 1 THEN
		RETURN -1
	ELSE
		i_dStartDate = i_sUOReportParms.date_parm3
		i_dEndDate = i_sUOReportParms.date_parm4
		i_nProvKeys = i_sUOReportParms.long_parm1
	END IF
	
//	FOR l_nIndex = 1 TO UPPERBOUND (i_sUOReportParms.long_parm1)
//		IF l_nIndex = 1 THEN
//			l_cProvKeys = string(i_sUOReportParms.long_parm1[l_nIndex])
//		ELSE
//			l_cProvKeys = l_cProvKeys + ", " + string(i_sUOReportParms.long_parm1[l_nIndex])
//		END IF
//		
//	NEXT
//	
//	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
//	dw_print_report.SetTransObject(SQLCA)
//
//	l_nReturn = dw_print_report.Retrieve(i_dStartDate, i_dEndDate, i_cUserName, l_cProvKeys, i_cUserName)		
	IF UpperBound( i_nProvKeys ) > 0 THEN
		FOR l_nIndex = 1 TO UpperBound( i_nProvKeys )
			l_cProvKeys[ l_nIndex ] = String( i_nProvKeys[ l_nIndex ] )
		NEXT
	END IF
	
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.Modify("t_provid.Text = '" + i_sUOReportParms.string_parm1 + "'")
	dw_print_report.Modify("t_vendid.Text = '" + i_sUOReportParms.string_parm2 + "'")
	dw_print_report.SetTransObject(SQLCA)

	l_nReturn = dw_print_report.Retrieve(i_dStartDate, i_dEndDate, i_cUserName, l_cProvKeys)	

CASE 'd_tot_contact' 
// Total Contact Activity
	dw_print_report.Modify("cc_user_name.Text = '" + i_cUserName + "'")
	dw_print_report.GetChild("d_open_cases",ldwc_child)
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	ldwc_child.SetTransObject(SQLCA)
	ldwc_child.Retrieve(Today())
	dw_print_report.GetChild("d_closed_cases",ldwc_child)
	ldwc_child.SetTransObject(SQLCA)
	ldwc_child.Retrieve(Today())
	dw_print_report.GetChild("d_total_cases",ldwc_child)
	ldwc_child.SetTransObject(SQLCA)
	l_nReturn = ldwc_child.Retrieve(Today())

CASE 'd_tot_contact_act' 
// Annual Contact Activity
	THIS.SetRedraw(FALSE)
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)

	l_cStartDate = '1/1/' + String (Year (Today ()))
	l_dStartDate = Date (l_cStartDate)
	l_dtStartDT = DateTime(l_dSTartDate)
	
	l_cEndDate = '12/31/' + String (Year (Today ()))
	l_dEndDate = Date (l_cEndDate)
	l_dtEndDT = DateTime (l_dEndDate)
	l_nReturn = dw_print_report.Retrieve(l_dtStartDT, l_dtEndDT, i_cUserName)
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
	
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)
	l_nReturn = dw_print_report.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, i_cStartDate, i_cEndDate, i_cCloseCode, i_cUserName)

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

	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)

	l_nReturn = dw_print_report.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, i_cStartDate, &
		i_cEndDate, i_nClosedDays,  i_cUserName)

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
	
	dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	dw_print_report.SetTransObject(SQLCA)
	
	l_nReturn = dw_print_report.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, i_cStartDate, &
		i_cEndDate, i_nSampleSet, i_cUserName)
		
// HealthGuard Custom Reports
CASE 'd_case_inquiry_all_hg','d_case_inquiry_first_hg'
// Case Inquiry Report
	IF NOT IsNull(i_sUOReportParms.report_type) AND TRIM(i_sUOReportParms.report_type) <> '' THEN
	  
	   dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	   dw_print_report.SetTransObject(SQLCA)
      fw_prep_report_hg()

	   l_nReturn = dw_print_report.retrieve(i_sUOReportParms.category_id, i_sUOReportParms.start_date_string, &
		              i_sUOReportParms.end_date_string, i_sUOReportParms.report_type)
			
	   FOR l_nIndex = 1 TO dw_print_report.GetRow()
			
			IF dw_print_report.GetItemString(l_nIndex,'case_type') = 'M' THEN
				dw_print_report.SetItem(l_nIndex,'case_type',gs_ConfigCaseType)
			END IF
		
	   NEXT
						  
	 END IF	
	 
CASE 'd_dept_all_hg','d_dept_prov_hg'
	// Department Report All Source Types, Providers
	IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
	  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	  dw_print_report.SetTransObject(SQLCA)
	  fw_prep_report_hg()
	  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
					 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
					 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
	END IF

CASE 'd_dept_grp_hg'
	// Department Report Groups
	IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
	  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	  dw_print_report.SetTransObject(SQLCA)
	  fw_prep_report_hg()
	  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
					 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
					 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
					 i_sUOReportParms.group, i_sUOReportParms.category_id, &
					 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
	END IF
CASE 'd_dept_mbr_hg'
	// Department Report Members
	IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
	  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	  dw_print_report.SetTransObject(SQLCA)
	  fw_prep_report_hg()
	  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
					 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
					 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
					 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
					 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
	END IF
	
CASE 'd_dissat_all_hg','d_dissat_prov_hg'
	// Dissatisfaction Report All Source Types, Providers
	IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
	  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	  dw_print_report.SetTransObject(SQLCA)
	  fw_prep_report_hg()
	  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
					 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
					 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
	END IF
	
CASE 'd_dissat_grp_hg'
	// Dissatisfaction Report Groups
	IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
	  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	  dw_print_report.SetTransObject(SQLCA)
	  fw_prep_report_hg()
	  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
					 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
					 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
					 i_sUOReportParms.group, i_sUOReportParms.category_id, &
					 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
	END IF
	
CASE 'd_dissat_mbr_hg'
	// Dissatisfaction Report Members
	IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
	  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
	  dw_print_report.SetTransObject(SQLCA)
	  fw_prep_report_hg()
	  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
					 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
					 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
					 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
					 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
	END IF
		// Received Report All Source Types, Providers
	CASE 'd_rcvd_all_hg','d_rcvd_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received Report Group
	CASE 'd_rcvd_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received Report Member
	CASE 'd_rcvd_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF

	// Received-Resolved Report All Source Types, Providers
	CASE 'd_rcvd_rslvd_all_hg','d_rcvd_rslvd_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received-Resolved Report Group
	CASE 'd_rcvd_rslvd_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Received-Resolved Report Member
	CASE 'd_rcvd_rslvd_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Representative Report All Source Types, Providers
	CASE 'd_rep_all_hg','d_rep_prov_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Representative Report Group
	CASE 'd_rep_grp_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	// Representative Report Member
	CASE 'd_rep_mbr_hg'
		IF NOT IsNull(i_sUOReportParms.user_type) AND TRIM(i_sUOReportParms.user_type) <> '' THEN
		  dw_print_report.Modify("t_owner.Text = '" + gs_owner + "'")
		  dw_print_report.SetTransObject(SQLCA)
		  fw_prep_report_hg()
		  l_nReturn = dw_print_report.retrieve(i_sUOReportParms.user_type, &
						 i_sUOReportParms.user_list, i_sUOReportParms.received_resolved, &
						 i_sUOReportParms.lob, i_sUOReportParms.region, i_sUOReportParms.consolidated_group, &
						 i_sUOReportParms.group, i_sUOReportParms.pcp, i_sUOReportParms.category_id, &
						 i_sUOReportParms.start_date_string,i_sUOReportParms.end_date_string)
		END IF
	CASE 'd_month_appl_lvl_one_hg','d_month_appl_lvl_two_hg','d_month_appl_lvl_three_hg'
		dw_print_report.retrieve(i_sUOReportParms.start_date_string, i_sUOReportParms.end_date_string, &
		            i_sUOReportParms.appeal_level, i_sUOReportParms.report_type)
		
	CASE 'd_customer_contact_activity_phcs','d_customer_contact_activity_summary_phcs'
		l_nReturn = dw_print_report.retrieve(i_sUOReportParms.start_date, i_sUOReportParms.end_date, i_sUOReportParms.user_array[], gs_ConfigCaseType)
		
END CHOOSE

  dw_print_report.Object.DataWindow.Retrieve.AsNeeded


IF l_nReturn > 0 THEN
	RETURN 0
ELSE
	RETURN -1
END IF
end function

on w_supervisor_reports.create
int iCurrent
call super::create
if this.MenuName = "m_supervisor_reports" then this.MenuID = create m_supervisor_reports
this.dw_print_report=create dw_print_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_print_report
end on

on w_supervisor_reports.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_print_report)
end on

event open;call super::open;//***********************************************************************************************
//
//  Event:   open
//  Purpose: Open supervisor reports
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/19/00 C. Jackson  Original Version
//  11/10/00 C. Jackson  Add new reports
//  05/08/01 C. Jackson  Add Vermont reports
//  07/06/01 C. Jackson  Add DESTORY datastores
//  08/08/01 C. Jackson  Correct end date to have " 23:59:59" at the end rather than default of
//                       " 00:00:00"
//  08/08/01 M. Caruso   Added 'Category Analysis' and 'Contact Method' reports
//  10/09/01 C. Jackson  Move retrieves out, now retrieved via fu_getData and a sharedata (SCR 2143)
//  4/9/2002 K. Claver   Removed c_Default from fu_Swap and included c_NoMenuButtonActivation and
//								 c_NoEnablePopup.
//  5/20/2002 K. Claver  Cleaned up unused variables and changed to reference window instance
//								 variable populated by structure passed to the window.
//***********************************************************************************************

IF ClassName( Message.PowerObjectParm ) = "s_report_parms" THEN
	THIS.Event Trigger ue_getreport( Message.PowerObjectParm )
END IF
end event

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To set options
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/20/00 C. Jackson  Original Version
//  11/07/01 C. Jackson  Get Users name for display in reports
//
//**********************************************************************************************

STRING l_cFirstName, l_cLastName, l_cMI

fw_SetOptions(c_Default + c_ToolbarTop)

dw_print_report.fu_SetOptions(SQLCA, dw_print_report.c_NullDW, &
		dw_print_report.c_Default+ dw_print_report.c_NoRetrieveOnOpen)
		
		
fw_CheckOutOfOffice()

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
 
i_cUserName = l_cLastName +', '+l_cFirstName + ' ' +l_cMI

i_nUserNameLen = LEN(i_cUserName)

end event

event resize;call super::resize;//*********************************************************************
//
//  Event:   Resize
//  Purpose: To enable print menu item
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------
//  11/08/01 C. Jackson  Original Version
//*********************************************************************

IF sizetype <> 1  then
	m_supervisor_reports.m_file.m_printreport.Enabled = TRUE
END IF
end event

type dw_print_report from u_dw_std within w_supervisor_reports
integer y = 12
integer width = 3611
integer height = 1716
integer taborder = 10
string dataobject = "d_csr_activity_caserep"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: To set options
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/20/00 C. Jackson  Original Version
//  06/20/03 M. Caruso   Changed fu_setoptions to use c_Default for properties.
//**********************************************************************************************

fu_SetOptions(SQLCA,c_NullDW, c_Default)
end event

event pcd_retrieve;call super::pcd_retrieve;//***********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: to retrieve the report information
//  
//  Date     Developer    Description
//  -------- ------------ -----------------------------------------------------------------------
//  04/05/01 C. Jackson   Original Version
//  7/11/2001 K. Claver   Added code to populate the application name for the case detail history
//								  report.
//  08/08/01 C. Jackson   Add CloseCode retrieval arg for display on report header
//  9/19/2002 K. Claver   Changed to pass array of strings to d_svc_center_act_nested and
//									d_prov_contact_act_nested
//***********************************************************************************************
Integer l_nIndex
String l_cProvKeys[ ]
LONG l_nSecurityLevel

CHOOSE CASE w_supervisor_portal.tab_1.tabpage_reports.uo_reports.i_cDataWindow
		
	CASE 'd_grp_mem_rpt_card_nested', 'd_inq_act_by_category', 'd_iss_act_by_category', &
			'd_group_contact_nested'
		THIS.retrieve(i_dStartDate, i_dEndDate, i_cLogin, i_cSourceID,i_cUserName)
		
	CASE "d_case_detail_history_report_multi"
					SELECT confidentiality_level INTO :l_nSecurityLevel
					  FROM cusfocus.cusfocus_user
					 WHERE user_id = :i_cLogin
					 USING SQLCA;

					THIS.retrieve(i_sUOReportParms.user_or_dept, i_sUOReportParms.case_status, i_sUOReportParms.source_type, &
		              i_sUOReportParms.start_date, i_sUOReportParms.end_date, l_nSecurityLevel, &
						  i_sUOReportParms.user_list, i_sUOReportParms.category_array, i_sUOReportParms.category_selected, &
						  i_sUOReportParms.case_type, i_sUOReportParms.case_number, i_sUOReportParms.case_selected)
		
		THIS.Object.appname_t.Text = gs_AppName
		
	CASE "d_svc_center_act_nested", "d_prov_contact_act_nested"
		IF UpperBound( i_nProvKeys ) > 0 THEN
			FOR l_nIndex = 1 TO UpperBound( i_nProvKeys )
				l_cProvKeys[ l_nIndex ] = String( i_nProvKeys[ l_nIndex ] )
			NEXT
		END IF
		
		THIS.Retrieve(i_dStartDate, i_dEndDate, i_cLogin, l_cProvKeys)

	// Vermont Custom Reports
	CASE 'd_inquiry_sampling_vt'
		
		IF i_cLineOfBusiness = "()" THEN
			i_cLineOfBusiness = ''
		END IF
		
		THIS.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, i_cStartDate, &
			i_cEndDate, i_nSampleSet)
			
	CASE 'd_case_timeliness_vt'
		
		IF i_cLineOfBusiness = "()" THEN
			i_cLineOfBusiness = ''
		END IF

		THIS.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, i_cStartDate, &
			i_cEndDate, i_nClosedDays)

	CASE 'd_case_counts_vt'
		
		IF i_cLineOfBusiness = "()" THEN
			i_cLineOfBusiness = ''
		END IF

		THIS.Retrieve(i_cSubscriberType, i_cParentGroup, i_cGroup, i_cLineOfBusiness, i_cAllExceptFEP, i_cStartDate, i_cEndDate)

	// HealthGuard Custom Reports
	CASE 'd_case_inquiry_report_hg'
		THIS.retrieve(i_sUOReportParms.category_id, i_sUOReportParms.start_date, &
		              i_sUOReportParms.end_date, i_sUOReportParms.report_type)
						  
		
			
		
END CHOOSE


end event

