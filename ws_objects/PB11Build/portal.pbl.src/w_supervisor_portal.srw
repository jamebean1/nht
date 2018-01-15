$PBExportHeader$w_supervisor_portal.srw
$PBExportComments$Supervisor Portal Window
forward
global type w_supervisor_portal from w_main_std
end type
type tab_1 from tab within w_supervisor_portal
end type
type tabpage_performance_statistics from userobject within tab_1
end type
type uo_performance from u_performance within tabpage_performance_statistics
end type
type tabpage_performance_statistics from userobject within tab_1
uo_performance uo_performance
end type
type tabpage_critical_cases from userobject within tab_1
end type
type uo_criticalcases from u_critical_cases within tabpage_critical_cases
end type
type tabpage_critical_cases from userobject within tab_1
uo_criticalcases uo_criticalcases
end type
type tabpage_reassign_cases from userobject within tab_1
end type
type uo_reassigncases from u_reassign_cases within tabpage_reassign_cases
end type
type tabpage_reassign_cases from userobject within tab_1
uo_reassigncases uo_reassigncases
end type
type tabpage_out_of_office from userobject within tab_1
end type
type uo_outofoffice from u_out_of_office within tabpage_out_of_office
end type
type tabpage_out_of_office from userobject within tab_1
uo_outofoffice uo_outofoffice
end type
type tabpage_reports from userobject within tab_1
end type
type uo_reports from u_reports within tabpage_reports
end type
type tabpage_reports from userobject within tab_1
uo_reports uo_reports
end type
type tab_1 from tab within w_supervisor_portal
tabpage_performance_statistics tabpage_performance_statistics
tabpage_critical_cases tabpage_critical_cases
tabpage_reassign_cases tabpage_reassign_cases
tabpage_out_of_office tabpage_out_of_office
tabpage_reports tabpage_reports
end type
end forward

global type w_supervisor_portal from w_main_std
integer x = 0
integer y = 0
integer width = 3246
integer height = 2504
string title = "Supervisor Portal"
string menuname = "m_supervisor_portal"
long backcolor = 79748288
event ue_regbuttontotop ( )
tab_1 tab_1
end type
global w_supervisor_portal w_supervisor_portal

type variables
STRING  				i_cSelected
STRING 				i_cUserID
STRING 				i_cShowBlankReport
BOOLEAN 				i_bFirstOpen
BOOLEAN 				i_bOutOfOffice
BOOLEAN 				i_bPrintDetailHistory
LONG 					i_nSuperConfidLevel

DATASTORE			i_dsFieldLabels

U_REGISTERBUTTON	i_uoregisterbutton
end variables

forward prototypes
public subroutine fw_sortdata ()
public function s_csr_info fw_getcsrinfo (ref string row_desc)
public subroutine wf_registerbutton ()
public subroutine fw_checkoutofoffice ()
public function integer fw_getrecconfidlevel (string a_ccurrentcasesubject, string a_csourcetype)
end prototypes

event ue_regbuttontotop;//************************************************************************************************
//
//  Event:   ue_RegButtonToTop
//  Purpose: To bring the registration button to the top
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  02/16/01 C. Jackson  Original Version
//
//************************************************************************************************

// if registration mode is on, bring the register button to the top
IF SECCA.MGR.i_RegistrationMode = TRUE THEN
	i_uoregisterbutton.BringToTop = TRUE
END IF


end event

public subroutine fw_sortdata ();
end subroutine

public function s_csr_info fw_getcsrinfo (ref string row_desc);//*****************************************************************************************
//
//  Function: fw_GetCSRInfo
//  Purpose:  break apart row_desc 
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------
//  10/13/00 C. Jackson  Original Version
//
//*****************************************************************************************

LONG l_nPos
S_CSR_INFO l_csr_info

l_nPos = POS(row_desc,', ')
IF l_nPos > 0 THEN
	l_csr_info.user_first_name = TRIM(MID(row_desc,l_nPos + 1))
	l_csr_info.user_last_name = TRIM(MID(row_desc,1,l_nPos - 1))
END IF

// Get the userid from the database
SELECT user_id, user_dept_id INTO :l_csr_info.user_id, :l_csr_info.user_dept_id
  FROM cusfocus.cusfocus_user
 WHERE user_first_name = :l_csr_info.user_first_name
   AND user_last_name = :l_csr_info.user_last_name
 USING SQLCA;

l_csr_info.user_full_name = l_csr_info.user_first_name + ' ' + l_csr_info.user_last_name

RETURN l_csr_info


end function

public subroutine wf_registerbutton ();//***********************************************************************************************
//
//  Function: wf_registerbutton
//  Purpose:  To bring the register button to the front
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  02/16/01 C. Jackson  Original Version
//
//***********************************************************************************************

LONG l_nIndex
USEROBJECT 	uo_objectontop

FOR l_nIndex = 1 TO UpperBound( THIS.Control )
	CHOOSE CASE THIS.Control[l_nIndex].ClassName()
		CASE 'u_registerbutton'
			i_uoregisterbutton = THIS.Control[l_nIndex]
		
	END CHOOSE

NEXT

end subroutine

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
i_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

// If the user is currently mark as out of the office, setting the Check on the menu item
SELECT count(*) INTO :l_nCount
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cUserID
 USING SQLCA;
 
// Update the clicked property based on whether not the user if Out of Office 
IF l_nCount > 0 THEN
	m_supervisor_portal.m_file.m_outofoffice.Check()
	i_bOutOfOffice = TRUE
ELSE
	m_supervisor_portal.m_file.m_outofoffice.UnCheck()
	i_bOutOfOffice = FALSE
END IF







end subroutine

public function integer fw_getrecconfidlevel (string a_ccurrentcasesubject, string a_csourcetype);//****************************************************************************************
//
//	  Function:	fw_GetRecConfidLevel
//		Purpose:	To Retrieve the source record confidentiality level
//    
// Parameters: a_cCurrentCaseSubject - The id of the record
//					a_cSourceType - The record type(member, provider, etc)
//    Returns: The confidentiality of the record
//						
//	 Date     Developer    Description
//	 -------- ------------ ----------------------------------------------------------------
//	 3/1/2001 K. Claver    Original version.
//**************************************************************************************/
Integer l_nConfidLevel

SetNull( l_nConfidLevel )

CHOOSE CASE a_cSourceType
	CASE "P"
		SELECT cusfocus.provider_of_service.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.provider_of_service
		WHERE cusfocus.provider_of_service.provider_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE "E"
		SELECT cusfocus.employer_group.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.employer_group
		WHERE cusfocus.employer_group.group_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE "C"
		SELECT cusfocus.consumer.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.consumer
		WHERE cusfocus.consumer.consumer_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE "O"
		SELECT cusfocus.other_source.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.other_source
		WHERE cusfocus.other_source.customer_id = :a_cCurrentCaseSubject
		USING SQLCA;
END CHOOSE	
		
RETURN l_nConfidLevel
end function

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions	
//  Purpose: To set uo_dw_main options, and set the PowerClass Message object 
//						
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  09/07/00 C. Jackson    Original Version
//
//**********************************************************************************************

fw_SetOptions(c_Default + c_ToolbarTop)

WINDOWOBJECT l_woObject[]

//Initialize the resize service
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_SetOrigSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
	THIS.inv_resize.of_SetMinSize( ( THIS.Width - 30 ), ( THIS.Height - 178 ) )
END IF

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( tab_1 , THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( tab_1.tabpage_critical_cases.uo_criticalcases , THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( tab_1.tabpage_out_of_office.uo_outofoffice , THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( tab_1.tabpage_performance_statistics.uo_performance , THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( tab_1.tabpage_reports.uo_reports , THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( tab_1.tabpage_reassign_cases.uo_reassigncases , THIS.inv_resize.SCALERIGHTBOTTOM )
END IF

m_supervisor_portal.m_administration.m_managereports.Enabled = TRUE

fw_CheckOutOfOffice()

// Check to see if registration mode, if so, bring the register button to the top
IF SECCA.MGR.i_RegistrationMode = TRUE THEN
	wf_registerbutton()
END IF



end event

on w_supervisor_portal.create
int iCurrent
call super::create
if this.MenuName = "m_supervisor_portal" then this.MenuID = create m_supervisor_portal
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_supervisor_portal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;//**********************************************************************************************
//
//  Event:   Open
//  Purpose: Set properties on the Window
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/06/00 C. Jackson  Original Version
//  02/16/01 C. Jackson  Add PostEvent('ue_regbuttontotop')
//  06/26/02 C. Jackson  Change confidentiality_level to usr_confidentiality_level
//  10/4/2002 K. Claver  Added check for show blank report system option.
//**********************************************************************************************  

// Get the Logged in Supervisor's security level
SELECT usr_confidentiality_level INTO :i_nSuperConfidLevel
  FROM cusfocus.cusfocus_user
 WHERE user_id = :i_cUserID
 USING SQLCA;
 
// Check if should show blank reports
SELECT Upper( option_value )
INTO :THIS.i_cShowBlankReport
FROM cusfocus.system_options
WHERE Upper( option_name ) = 'BLANK_REPORT'
USING SQLCA;

IF IsNull( THIS.i_cShowBlankReport ) OR Trim( THIS.i_cShowBlankReport ) = "" THEN
	THIS.i_cShowBlankReport = "N"
END IF
 
i_bFirstOpen = TRUE

// if registration mode is on, bring the register button to the top
IF SECCA.MGR.i_RegistrationMode = TRUE THEN
	PostEvent('ue_regbuttontotop')
END IF


end event

event pc_print;call super::pc_print;//*************************************************************************************************
//
//  event:   pc_print
//  purpose: to print the Case Detail History Report
//  
//  date     developer   description
//  -------- ----------- --------------------------------------------------------------------------
//  01/14/01 cjackson    Original Version
//
//*************************************************************************************************

LONG			l_nRowCount, l_nRow
STRING		l_cCaseNumber
DATAWINDOW	l_dwReportDW, l_dwCritical, l_dwReassign

SetPointer(HOURGLASS!)

l_dwReportDW = tab_1.tabpage_reassign_cases.uo_reassigncases.dw_case_detail_report
//l_dwCritical = w_supervisor_portal.tab_1.tabpage_critical_cases.uo_criticalcases.tab_details.tabpage_results.dw_critical_detail
//l_dwReassign = w_supervisor_portal.tab_1.tabpage_reassign_cases.uo_reassigncases.tab_details.tabpage_results.dw_reassign_list

CHOOSE CASE i_cSelected
	CASE 'Critical Cases'
//		l_nRow = l_dwCritical.GetRow ()
//		l_cCaseNumber = l_dwCritical.GetItemString(l_nRow,"case_log_case_number")
		l_cCaseNumber = w_supervisor_portal.tab_1.tabpage_critical_cases.uo_criticalcases.uo_search_criticalcases.of_get_case_number( )
	CASE 'Reassign Cases'
//		l_nRow = l_dwReassign.GetRow ()
//		l_cCaseNumber = l_dwReassign.GetItemString (l_nRow, "case_log_case_number")
		l_cCaseNumber = w_supervisor_portal.tab_1.tabpage_reassign_cases.uo_reassigncases.uo_search_reassigncases.of_get_case_number( )
END CHOOSE

IF l_cCaseNumber = '' THEN
	MessageBox (gs_appname, 'You cannot run this report from here.')
	RETURN
END IF

// if we're still here, continue running the report.
l_dwReportDW.SetTransObject(SQLCA)
l_dwReportDW.Retrieve (l_cCaseNumber, i_nSuperConfidLevel)

l_dwReportDW.Print ()
l_dwReportDW.Reset ()



end event

event pc_setvariables;call super::pc_setvariables;//**********************************************************************************************
//  Event:   pc_SetVariables
//  Purpose: Set instance variables on the Window
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  06/19/03 M. Caruso   Created.
//**********************************************************************************************

i_dsFieldLabels = CREATE DataStore
i_dsFieldLabels.DataObject = 'd_field_labels'
i_dsFieldLabels.SetTransObject(SQLCA)
i_dsFieldLabels.Retrieve()

end event

event pc_close;call super::pc_close;//**********************************************************************************************
//  Event:   pc_Close
//  Purpose: Clean up items in memory before closing the window.
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  06/19/03 M. Caruso   Created.
//**********************************************************************************************

IF IsValid (i_dsFieldLabels) THEN DESTROY i_dsFieldLabels

end event

type tab_1 from tab within w_supervisor_portal
integer x = 14
integer y = 12
integer width = 3173
integer height = 2300
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_performance_statistics tabpage_performance_statistics
tabpage_critical_cases tabpage_critical_cases
tabpage_reassign_cases tabpage_reassign_cases
tabpage_out_of_office tabpage_out_of_office
tabpage_reports tabpage_reports
end type

on tab_1.create
this.tabpage_performance_statistics=create tabpage_performance_statistics
this.tabpage_critical_cases=create tabpage_critical_cases
this.tabpage_reassign_cases=create tabpage_reassign_cases
this.tabpage_out_of_office=create tabpage_out_of_office
this.tabpage_reports=create tabpage_reports
this.Control[]={this.tabpage_performance_statistics,&
this.tabpage_critical_cases,&
this.tabpage_reassign_cases,&
this.tabpage_out_of_office,&
this.tabpage_reports}
end on

on tab_1.destroy
destroy(this.tabpage_performance_statistics)
destroy(this.tabpage_critical_cases)
destroy(this.tabpage_reassign_cases)
destroy(this.tabpage_out_of_office)
destroy(this.tabpage_reports)
end on

event selectionchanged;//************************************************************************************************
//
//  Event:   Clicked
//  Purpose: set the user objects depending on which picture was selected
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  09/06/00 C. Jackson  Original Version
//  02/16/01 C. Jackson  Add call to wf_registerbutton to bring registration button to top if
//                       in registration mode.
//  
//************************************************************************************************

STRING l_cLabel
LONG l_nIndex

i_bFirstOpen = FALSE

CHOOSE CASE newindex
		
	CASE 1
		i_cSelected = 'Performance Statistics'
		m_supervisor_portal.m_file.m_search.Enabled = FALSE
		m_supervisor_portal.m_file.m_clearsearchcriteria.Enabled = FALSE
		m_supervisor_portal.m_file.m_cancelsearch.Enabled = FALSE
		m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
		m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.Enabled = FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_AddEditReports.Enabled =  FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_ReportSecurity.Enabled =  FALSE
	CASE 2
		i_cSelected = 'Critical Cases'
		m_supervisor_portal.m_file.m_search.Enabled = TRUE
		m_supervisor_portal.m_file.m_clearsearchcriteria.Enabled = TRUE
		m_supervisor_portal.m_file.m_cancelsearch.Enabled = TRUE
		IF THIS.tabpage_critical_cases.uo_criticalcases.i_nCount > 0 THEN
			m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = TRUE
			m_supervisor_portal.m_file.m_casedetail.Enabled = TRUE
		END IF
		m_supervisor_portal.m_Administration.m_ManageReports.Enabled = FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_AddEditReports.Enabled =  FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_ReportSecurity.Enabled =  FALSE
		THIS.tabpage_critical_cases.uo_criticalcases.ddlb_sourcetype.Text = '(All)'
		THIS.tabpage_critical_cases.uo_criticalcases.ddlb_priority.Text = '(All)'
		THIS.tabpage_critical_cases.uo_criticalcases.ddlb_casetype.Text = '(All)'
		THIS.tabpage_critical_cases.uo_criticalcases.em_aging.Text = '30'
		THIS.tabpage_critical_cases.uo_criticalcases.fu_Clear()
	CASE 3
		i_cSelected = 'Reassign Cases'
		m_supervisor_portal.m_file.m_search.Enabled = FALSE
		m_supervisor_portal.m_file.m_clearsearchcriteria.Enabled = FALSE
		m_supervisor_portal.m_file.m_cancelsearch.Enabled = FALSE
		IF THIS.tabpage_reassign_cases.uo_reassigncases.i_nNumCases > 0 THEN
			m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = TRUE
			m_supervisor_portal.m_file.m_casedetail.Enabled = TRUE
		ELSE
			m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
			m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
		END IF
		m_supervisor_portal.m_Administration.m_ManageReports.Enabled = FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_AddEditReports.Enabled =  FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_ReportSecurity.Enabled =  FALSE
	CASE 4
		i_cSelected = 'Out of Office Management'
		m_supervisor_portal.m_file.m_search.Enabled = FALSE
		m_supervisor_portal.m_file.m_clearsearchcriteria.Enabled = FALSE
		m_supervisor_portal.m_file.m_cancelsearch.Enabled = FALSE
		m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
		m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.Enabled = FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_AddEditReports.Enabled =  FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.m_ReportSecurity.Enabled =  FALSE
		THIS.tabpage_out_of_office.uo_outofoffice.fu_Refresh()
	CASE 5
		i_cSelected = 'Reports'
		m_supervisor_portal.m_file.m_search.Enabled = FALSE
		m_supervisor_portal.m_file.m_clearsearchcriteria.Enabled = FALSE
		m_supervisor_portal.m_file.m_cancelsearch.Enabled = FALSE
		m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
		m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
		m_supervisor_portal.m_Administration.m_ManageReports.Enabled = TRUE
		m_supervisor_portal.m_Administration.m_ManageReports.m_AddEditReports.Enabled =  TRUE
		m_supervisor_portal.m_Administration.m_ManageReports.m_ReportSecurity.Enabled =  TRUE
END CHOOSE

THIS.SetFocus()

// if registration mode is on, bring the register button to the top
IF SECCA.MGR.i_RegistrationMode = TRUE THEN
	i_uoregisterbutton.BringToTop = TRUE
END IF


end event

type tabpage_performance_statistics from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3136
integer height = 2180
boolean border = true
long backcolor = 80269524
string text = "Performance Statistics"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
uo_performance uo_performance
end type

on tabpage_performance_statistics.create
this.uo_performance=create uo_performance
this.Control[]={this.uo_performance}
end on

on tabpage_performance_statistics.destroy
destroy(this.uo_performance)
end on

type uo_performance from u_performance within tabpage_performance_statistics
event destroy ( )
integer x = 9
integer y = 12
integer width = 3049
integer height = 1716
integer taborder = 160
borderstyle borderstyle = styleraised!
end type

on uo_performance.destroy
call u_performance::destroy
end on

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//   Event:   pcd_setoptions
//	Purpose: To Set Options
//	
//	Date     Developer   Description
//	-------- ----------- ----------------------------------------------------------------------
//	10/20/00 C. Jackson  Original Version
//
//**********************************************************************************************


end event

type tabpage_critical_cases from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3136
integer height = 2180
boolean border = true
long backcolor = 80269524
string text = "Critical Cases"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
uo_criticalcases uo_criticalcases
end type

on tabpage_critical_cases.create
this.uo_criticalcases=create uo_criticalcases
this.Control[]={this.uo_criticalcases}
end on

on tabpage_critical_cases.destroy
destroy(this.uo_criticalcases)
end on

type uo_criticalcases from u_critical_cases within tabpage_critical_cases
event destroy ( )
integer x = -37
integer y = 12
integer width = 3049
integer height = 2220
integer taborder = 40
borderstyle borderstyle = styleraised!
end type

on uo_criticalcases.destroy
call u_critical_cases::destroy
end on

type tabpage_reassign_cases from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3136
integer height = 2180
boolean border = true
long backcolor = 80269524
string text = "Reassign Cases"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
uo_reassigncases uo_reassigncases
end type

on tabpage_reassign_cases.create
this.uo_reassigncases=create uo_reassigncases
this.Control[]={this.uo_reassigncases}
end on

on tabpage_reassign_cases.destroy
destroy(this.uo_reassigncases)
end on

type uo_reassigncases from u_reassign_cases within tabpage_reassign_cases
event destroy ( )
integer x = -18
integer y = -4
integer width = 3049
integer height = 2164
integer taborder = 100
borderstyle borderstyle = styleraised!
end type

on uo_reassigncases.destroy
call u_reassign_cases::destroy
end on

type tabpage_out_of_office from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3136
integer height = 2180
boolean border = true
long backcolor = 80269524
string text = "Out of Office"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
uo_outofoffice uo_outofoffice
end type

on tabpage_out_of_office.create
this.uo_outofoffice=create uo_outofoffice
this.Control[]={this.uo_outofoffice}
end on

on tabpage_out_of_office.destroy
destroy(this.uo_outofoffice)
end on

type uo_outofoffice from u_out_of_office within tabpage_out_of_office
event destroy ( )
integer y = 16
integer width = 3049
integer height = 1716
integer taborder = 140
borderstyle borderstyle = styleraised!
end type

on uo_outofoffice.destroy
call u_out_of_office::destroy
end on

type tabpage_reports from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3136
integer height = 2180
boolean border = true
long backcolor = 80269524
string text = "Reports"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
uo_reports uo_reports
end type

on tabpage_reports.create
this.uo_reports=create uo_reports
this.Control[]={this.uo_reports}
end on

on tabpage_reports.destroy
destroy(this.uo_reports)
end on

type uo_reports from u_reports within tabpage_reports
event destroy ( )
integer y = 12
integer width = 3049
integer height = 1716
integer taborder = 50
borderstyle borderstyle = styleraised!
end type

on uo_reports.destroy
call u_reports::destroy
end on

