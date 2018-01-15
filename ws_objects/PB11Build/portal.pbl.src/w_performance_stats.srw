$PBExportHeader$w_performance_stats.srw
$PBExportComments$Reports window
forward
global type w_performance_stats from w_main_std
end type
type dw_supervisor_report from u_dw_std within w_performance_stats
end type
end forward

global type w_performance_stats from w_main_std
integer x = 0
integer y = 0
integer width = 3653
integer height = 1904
string title = "Performance Statistics"
string menuname = "m_supervisor_reports"
event ue_printreport ( )
dw_supervisor_report dw_supervisor_report
end type
global w_performance_stats w_performance_stats

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
//  5/22/2002 K. Claver  Added code to bring the window to the top after printing.
//***********************************************************************************************
dw_supervisor_report.Print( )
THIS.BringToTop = TRUE
end event

on w_performance_stats.create
int iCurrent
call super::create
if this.MenuName = "m_supervisor_reports" then this.MenuID = create m_supervisor_reports
this.dw_supervisor_report=create dw_supervisor_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_supervisor_report
end on

on w_performance_stats.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_supervisor_report)
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
//  05/04/01 C. Jackson  Add Open Case by CSR
//
//***********************************************************************************************

STRING l_cWhere, l_cOldSelect, l_cNewSelect, l_cLogin, l_cOrderBy, l_cTitle, l_cUser
LONG l_nPos, l_nReportRows


// Determine which report to run
CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReport
	CASE 'd_csr_activity_report'
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				dw_supervisor_report.fu_Swap("d_csr_activity_caserep", c_IgnoreChanges, &
						dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
			CASE 'case_log_taken_by'
				dw_supervisor_report.fu_Swap("d_csr_activity_takenby", c_IgnoreChanges, &
						dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
			END CHOOSE
	CASE 'd_open_case_levels'
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				dw_supervisor_report.fu_swap("d_open_case_rep", c_IgnoreChanges, &
				       dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
			CASE 'case_log_taken_by'
				dw_supervisor_report.fu_swap("d_open_taken_by", c_IgnoreChanges, &
				       dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
			END CHOOSE
	CASE 'd_csr_aging'
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				dw_supervisor_report.fu_swap("d_csr_aging_case_rep", c_IgnoreChanges, &
						dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
			CASE 'case_log_taken_by'
				dw_supervisor_report.fu_swap("d_csr_aging_taken_by", c_IgnoreChanges, &
						dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
		END CHOOSE
	CASE 'd_master_vs_indiv'
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				dw_supervisor_report.fu_swap("d_linked_case_rep", c_IgnoreChanges, &
						dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
			CASE 'case_log_taken_by'
				dw_supervisor_report.fu_swap("d_linked_case_taken", c_IgnoreChanges, &
						dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
		END CHOOSE
	CASE 'd_open_cases_by_csr'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// JWhite Added 8.29.2005 - Adding the option to let the Open Case by CSR report run by Owner as well as Taken By
		//-----------------------------------------------------------------------------------------------------------------------------------
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				l_nReportRows = dw_supervisor_report.fu_swap('d_open_cases_by_csr_owner', c_IgnoreChanges, dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
			CASE 'case_log_taken_by'
				l_nReportRows = dw_supervisor_report.fu_swap('d_open_cases_by_csr', c_IgnoreChanges, dw_supervisor_report.c_NoMenuButtonActivation+dw_supervisor_report.c_NoEnablePopup)
		END CHOOSE
	
END CHOOSE

l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReport
	CASE 'd_open_cases_by_csr'
		dw_supervisor_report.SetTransObject(SQLCA)
		
		IF UPPERBOUND(w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cUserArr) > 1 THEN
			// Should not get here, but handle it just in case
			messagebox(gs_AppName,'This report can only be run on one user at a time.')
			RETURN
		ELSE
				l_cUser = w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cUserArr[1]
				dw_supervisor_report.Retrieve(l_cLogin, l_cUser)
		END IF
		
	CASE 'd_master_vs_indiv'

		// Retrieve the report
		
		dw_supervisor_report.Retrieve( w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_dtFirstDate, &
												 w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_dtLastDate, &
												 w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cUserArr, &
												 l_cLogin )
		
		//Resort and recalc groups
		dw_supervisor_report.Sort( )
		dw_supervisor_report.GroupCalc( )
	
	CASE ELSE

		l_cWhere = Message.StringParm
		
		dw_supervisor_report.SetTransObject(SQLCA)
		
		l_cOldSelect = dw_supervisor_report.GetSQLSelect()
		// Check for Order By Clause
		l_nPos = POS(l_cOldSelect,'ORDER BY')
		IF l_nPos > 0 THEN
			// break out order by to be added to end of new select statement
			l_cOrderBy = MID(l_cOldSelect, l_nPos)
			l_cOldSelect = MID(l_cOldSelect, 1, l_nPos - 1)
		END IF
		
		l_cNewSelect = l_cOldSelect + ' ' + l_cWhere + ' ' + l_cOrderBy
		
		dw_supervisor_report.SetSQLSelect(l_cNewSelect)
		
		// Retrieve the report
		l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
		
		dw_supervisor_report.Retrieve(l_cLogin,w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cSubtitle)
	END CHOOSE
	

// Get Window Title
SELECT report_name INTO :l_cTitle
  FROM cusfocus.reports
 WHERE report_dtwndw_frmt_strng = :w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReport
 USING SQLCA;
 
THIS.Title = l_cTitle

//Initialize the resize service
THIS.of_SetResize( TRUE )

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_SetOrigSize ((Width - 30), (Height - 178))
	THIS.inv_resize.of_SetMinSize ((Width - 30), (Height - 178))

	THIS.inv_resize.of_Register( dw_supervisor_report, THIS.inv_resize.SCALERIGHTBOTTOM )
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
//
//**********************************************************************************************

fw_SetOptions(c_Default + c_ToolbarTop)

dw_supervisor_report.fu_SetOptions(SQLCA, dw_supervisor_report.c_NullDW, &
		dw_supervisor_report.c_Default)
		
		
end event

event pc_setvariables;call super::pc_setvariables;STRING l_cParm

l_cParm = PCCA.parm[1]


end event

type dw_supervisor_report from u_dw_std within w_performance_stats
integer width = 3607
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
//  4/9/2002 K. Claver   Changed from default options
//
//**********************************************************************************************

fu_SetOptions(SQLCA,c_NullDW, c_NoMenuButtonActivation+c_NoEnablePopup )
end event

