$PBExportHeader$u_critical_cases.sru
$PBExportComments$Critical Cases User Object
forward
global type u_critical_cases from u_container_std
end type
type dw_appeal_criteria from datawindow within u_critical_cases
end type
type uo_search_criticalcases from u_search_criticalcases within u_critical_cases
end type
type ddlb_casetype from dropdownlistbox within u_critical_cases
end type
type b_calendar_to from commandbutton within u_critical_cases
end type
type b_calendar_from from commandbutton within u_critical_cases
end type
type st_3 from statictext within u_critical_cases
end type
type rb_aging from radiobutton within u_critical_cases
end type
type st_daterange from statictext within u_critical_cases
end type
type em_dateto from editmask within u_critical_cases
end type
type em_datefrom from editmask within u_critical_cases
end type
type st_aging from statictext within u_critical_cases
end type
type em_aging from editmask within u_critical_cases
end type
type st_2 from statictext within u_critical_cases
end type
type st_1 from statictext within u_critical_cases
end type
type ddlb_priority from dropdownlistbox within u_critical_cases
end type
type ddlb_sourcetype from dropdownlistbox within u_critical_cases
end type
type dw_csrlist from u_outliner_std within u_critical_cases
end type
type st_4 from statictext within u_critical_cases
end type
type st_to from statictext within u_critical_cases
end type
type st_from from statictext within u_critical_cases
end type
type rb_range from radiobutton within u_critical_cases
end type
type gb_1 from groupbox within u_critical_cases
end type
end forward

global type u_critical_cases from u_container_std
integer width = 3109
integer height = 2168
dw_appeal_criteria dw_appeal_criteria
uo_search_criticalcases uo_search_criticalcases
ddlb_casetype ddlb_casetype
b_calendar_to b_calendar_to
b_calendar_from b_calendar_from
st_3 st_3
rb_aging rb_aging
st_daterange st_daterange
em_dateto em_dateto
em_datefrom em_datefrom
st_aging st_aging
em_aging em_aging
st_2 st_2
st_1 st_1
ddlb_priority ddlb_priority
ddlb_sourcetype ddlb_sourcetype
dw_csrlist dw_csrlist
st_4 st_4
st_to st_to
st_from st_from
rb_range rb_range
gb_1 gb_1
end type
global u_critical_cases u_critical_cases

type variables
STRING i_cRowDesc
STRING i_cUserID
STRING i_cFirstName
STRING i_cLastName
STRING i_cSourceType = '(All)'
STRING i_cPriority = '(All)'
STRING i_cCaseType = '(All)'
STRING i_cDateType = 'Aging'
STRING i_cSelect

DATE   i_dBegDate
DATE   i_dEndDate

LONG   i_nSelectedRow
LONG   i_nNumSelected = 1
LONG   i_nLevel = 1
LONG   i_nDays
LONG   i_nCount = 1

BOOLEAN i_bFirstOpen


end variables

forward prototypes
public subroutine fu_refresh ()
public subroutine fu_clearoutliner ()
public subroutine fu_retrieve ()
public subroutine fu_clearcriteria ()
public subroutine fu_clear ()
end prototypes

public subroutine fu_refresh ();////************************************************************************************************
////
////  Function: fu_refresh
////  Purpose:  to refresh the outliner datawindows
////  
////  Date     Developer   Description
////  -------- ----------- -------------------------------------------------------------------------
////  12/14/00 cjackson    Original Version
////
////************************************************************************************************
//
//LONG l_nLastRow, l_nIndex, l_nNumSelected, l_nSelectedRow[], l_nLevel
//
////??? Is this used? - RAP
//MessageBox("fu_refresh", "In here!")
////???
//
//dw_csrlist.Hide()
//dw_csrlist.SetRedraw(FALSE)
//	
//l_nLastRow = dw_csrlist.RowCount()
//
//l_nIndex = 1
//
//DO
//	
//  l_nIndex = dw_csrlist.fu_HLGetSelectedRow(l_nIndex)
//
//  IF l_nIndex > 0 THEN
//    l_nNumSelected = l_nNumSelected + 1
//    l_nSelectedRow[l_nNumSelected] = l_nIndex
//    l_nIndex = l_nIndex + 1
//
//    IF l_nIndex > l_nLastRow THEN
//      l_nIndex = 0
//    END IF
//	 
//  END IF
//  
//LOOP UNTIL l_nIndex = 0
//
//IF l_nNumSelected <> 0 THEN
//
//	l_nLevel = dw_csrlist.fu_HLGetRowLevel(l_nSelectedRow[1])
//	
//	IF l_nLevel = 1 THEN
//		// Refresh and expand
//		dw_csrlist.fu_HLRefresh(2, dw_csrlist.c_ReselectRows)
//		dw_csrlist.fu_HLExpandBranch()
//	ELSE
//		// Just refresh
//		dw_csrlist.fu_HLRefresh(2, dw_csrlist.c_ReselectRows)
//	END IF
//	
//END IF
//
//dw_csrlist.SetRedraw(TRUE)
//dw_csrlist.Show()
//
//
//THIS.fu_retrieve()
//
end subroutine

public subroutine fu_clearoutliner ();////******************************************************************************************
////
////  Function: fu_clearoutliner
////  Purpose:  to clear out previously retrieved rows
////  
////  Date     Developer   Description
////  -------- ----------- -------------------------------------------------------------------
////  12/19/00 cjackson    Original Version
////
////******************************************************************************************
//
//STRING l_cOldSelect, l_cDeptID, l_cWhere, l_cNewSelect
//LONG l_nPos
//U_DW_STD l_dwResults
//
////??? what do we want to do here? - RAP
////??? Is this used? - RAP
//MessageBox("fu_clearoutliner", "In here!")
////???
//
//l_dwResults = tab_details.tabpage_results.dw_critical_detail
//
//l_dwResults.fu_SetOptions( SQLCA, & 
//		l_dwResults.c_NullDW, & 
//		l_dwResults.c_SelectOnRowFocusChange + &
//		l_dwResults.c_NewModeOnEmpty + &
//		l_dwResults.c_ViewOnSelect + &
//		l_dwResults.c_NoActiveRowPointer + &
//		l_dwResults.c_TabularFormStyle + &
//		l_dwResults.c_NoInactiveRowPointer + &
//		l_dwResults.c_NoMenuButtonActivation + &
//		l_dwResults.c_RetrieveAsNeeded) 
//		
//// Get old SELECT statement
//l_dwResults.SetTransObject(SQLCA)
//
//l_cOldSelect = l_dwResults.GetSQLSelect()
//
//// Pull out the old where clause
//l_nPos = POS(l_cOldSelect, 'WHERE')
//IF l_nPos > 0 THEN 
//	l_cOldSelect = TRIM(MID(l_cOldSelect,1,(l_nPos - 1)))
//END IF	
//
//l_cDeptID = '0'
//
//// Specify new WHERE clause
//
//l_cWhere = " WHERE ( cusfocus_user_a.user_dept_id  *= cusfocus.cusfocus_user_dept.user_dept_id) and  "+&
//         "( cusfocus_user_b.user_id = cusfocus.case_log.case_log_taken_by) and " +&
//			"( cusfocus.case_log.case_log_case_rep = cusfocus_user_a.user_id ) and  "+&
//			"( cusfocus.case_log.source_type = cusfocus.source_types.source_type ) and  "+&
//			"( cusfocus.case_log.confidentiality_level = cusfocus.confidentiality_levels.confidentiality_level ) and"+&
//			"( cusfocus.case_log.case_type = cusfocus.case_types.case_type ) and"+&
//			"( cusfocus.case_log.case_status_id = 'O') and " +&
//			"( cusfocus_user_a.user_dept_id = '"+l_cDeptID+"' )"
//			
//// Add the new where clause to old_select
//
//l_cNewSelect = l_cOldSelect + l_cWhere
//
//// Set the SELECT statement for the DW
//l_dwResults.SetSQLSelect(l_cNewSelect)
//tab_details.tabpage_results.of_SetStopQuery(FALSE)
//
//i_nCount = l_dwResults.Retrieve()
//
//// Disable case history detail report if there are no row to report on
//IF ISNULL(i_nCount) or (i_nCount = 0) THEN
//	m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
//	m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
//END IF
//
//tab_details.tabpage_preview.Enabled = FALSE
//tab_details.SelectTab(1)
//
//
end subroutine

public subroutine fu_retrieve ();////******************************************************************************************
////
////  Function: fu_retrieve
////  Purpose:  to retreive the datawindows
////  
////  Date     Developer   Description
////  -------- ----------- -------------------------------------------------------------------
////  10/24/00 C. Jackson  Original Version
////
////******************************************************************************************
//
//STRING l_cDeptID, l_cOldSelect, l_cWhere, l_cNewSelect
//LONG l_nPos, l_nDeptRow
//U_DW_STD l_dwResults
//
////??? Is this used? - RAP
//MessageBox("fu_retrieve", "In here!")
////???
//
//l_dwResults = tab_details.tabpage_results.dw_critical_detail
//
//ddlb_sourcetype.Text = '(All)'
//ddlb_priority.Text = '(All)'
//ddlb_casetype.Text = '(All)'
//em_aging.Text = '30'
//
//// Retrieve Default Cases
//l_dwResults.fu_SetOptions( SQLCA, & 
//		l_dwResults.c_NullDW, & 
//		l_dwResults.c_SelectOnRowFocusChange + &
//		l_dwResults.c_NewModeOnEmpty + &
//		l_dwResults.c_ViewOnSelect + &
//		l_dwResults.c_NoActiveRowPointer + &
//		l_dwResults.c_TabularFormStyle + &
//		l_dwResults.c_NoInactiveRowPointer + &
//		l_dwResults.c_NoMenuButtonActivation + &
//		l_dwResults.c_RetrieveAsNeeded) 
//		
//// Get old SELECT statement
//l_dwResults.SetTransObject(SQLCA)
//
//l_cOldSelect = l_dwResults.GetSQLSelect()
//
//// Pull out the old where clause
//l_nPos = POS(l_cOldSelect, 'WHERE')
//IF l_nPos > 0 THEN 
//	l_cOldSelect = TRIM(MID(l_cOldSelect,1,(l_nPos - 1)))
//END IF	
//
//l_cDeptID = '0'
//
//// Specify new WHERE clause
//
//l_cWhere = " WHERE ( cusfocus.case_log.case_log_case_rep = cusfocus_user_a.user_id ) and  "+&
//			"( cusfocus.case_log.source_type = cusfocus.source_types.source_type ) and  "+&
//			"( cusfocus.case_log.confidentiality_level = cusfocus.confidentiality_levels.confidentiality_level ) and"+&
//			"( cusfocus.case_log.case_type = cusfocus.case_types.case_type ) and"+&
//			"( cusfocus.case_log.case_status_id = 'O') and " +&
//			"( cusfocus_user_a.user_dept_id = '"+l_cDeptID+"' )"
//			
//// Add the new where clause to old_select
//
//l_cNewSelect = l_cOldSelect + l_cWhere
//
//// Set the SELECT statement for the DW
//l_dwResults.SetSQLSelect(l_cNewSelect)
//tab_details.tabpage_results.of_SetStopQuery(FALSE)
//i_nCount = l_dwResults.Retrieve()
//
//// Disable case history detail report if there are no row to report on
//IF ISNULL(i_nCount) or (i_nCount = 0) THEN
//	m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
//	m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
//END IF
//
//dw_csrlist.fu_HLSetSelectedRow(1)
//
//rb_aging.Checked = TRUE
//rb_aging.TriggerEvent(Clicked!)
//rb_aging.SetFocus()
//
//
end subroutine

public subroutine fu_clearcriteria ();//*******************************************************************************
//
//  Function: fu_clearcriteria
//  Purpose:  To clear search fields
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------
//  10/10/00 C. Jackson  Original Version
//  05/09/02 C. Jackson  Re-retrieve blank Note Preview tab (SCR 3046)
//  5/23/2002 K. Claver  Fixed to respect non-implicit conversions in Sybase.
// 							 Also fixed to reset the transaction object on the preview datawindow.
//
//*******************************************************************************

STRING l_cDeptID, l_cOldSelect, l_cWhere, l_cNewSelect
LONG l_nPos
U_DW_STD l_dwResults
U_DW_STD l_dwPreview
DataWindowChild ldwc_line_of_business, ldwc_appeal_type, ldwc_service_type

uo_search_criticalcases.of_reset()

//l_dwResults = tab_details.tabpage_results.dw_critical_detail

dw_csrlist.fu_HLClearSelectedRows()
dw_csrlist.fu_HLCollapse(2)

ddlb_sourcetype.Text = '(All)'
ddlb_priority.Text = '(All)'
ddlb_casetype.Text = '(All)'
rb_aging.Checked = TRUE
rb_aging.TriggerEvent(Clicked!)
rb_aging.SetFocus()
em_aging.Text = '30'
em_datefrom.Text = 'none'
em_dateto.Text = 'none'
//em_datefrom.Text = '00/00/0000'
//em_dateto.Text = '00/00/0000'

dw_appeal_criteria.GetChild('appeal_type', ldwc_Appeal_Type)
ldwc_appeal_type.setfilter('appealtypeid = 0')
ldwc_appeal_type.filter()
		
dw_appeal_criteria.GetChild('service_type', ldwc_Service_Type)
ldwc_service_type.setfilter('service_type_id = 0')
ldwc_service_type.filter()

dw_appeal_criteria.object.line_of_business[1] = 0
dw_appeal_criteria.object.appeal_type[1] = 0
dw_appeal_criteria.object.service_type[1] = 0

// Re-retrieve

// Retrieve Default Cases

//l_dwResults.fu_SetOptions( SQLCA, & 
// 		l_dwResults.c_NullDW, & 
// 		l_dwResults.c_SelectOnRowFocusChange + &
// 		l_dwResults.c_NewModeOnEmpty + &
// 		l_dwResults.c_ViewOnSelect + &
// 		l_dwResults.c_NoActiveRowPointer + &
// 		l_dwResults.c_TabularFormStyle + &
// 		l_dwResults.c_NoInactiveRowPointer + &
//		l_dwResults.c_NoMenuButtonActivation + &
//		l_dwResults.c_RetrieveAsNeeded) 

// get the supervisor dept

//SELECT user_dept_id INTO :l_cDeptID
//  FROM cusfocus.cusfocus_user
// WHERE user_id = :i_cUserID
// USING SQLCA;
// 
//// Get old SELECT statement
//l_dwResults.SetTransObject(SQLCA)
//
//l_cOldSelect = l_dwResults.GetSQLSelect()
//
//// Pull out the old where clause
//l_nPos = POS(l_cOldSelect, 'WHERE')
//IF l_nPos > 0 THEN 
//	l_cOldSelect = TRIM(MID(l_cOldSelect,1,(l_nPos - 1)))
//END IF	
//
//// Specify new WHERE clause
//
//l_cWhere = " WHERE ( cusfocus_user_a.user_dept_id  = '0' )"
//
//// Add the new where clause to old_select
//
//l_cNewSelect = l_cOldSelect + l_cWhere
//
//// Set the SELECT statement for the DW
//l_dwResults.SetSQLSelect(l_cNewSelect)
//
//tab_details.tabpage_results.of_SetStopQuery(FALSE)
//
//l_dwResults.Retrieve()
//
//tab_details.tabpage_preview.dw_critical_preview.SetTransObject( SQLCA )
//tab_details.tabpage_preview.dw_critical_preview.Retrieve('0',1)
//
//
end subroutine

public subroutine fu_clear ();//******************************************************************************************
//
//  Function: fu_clear
//  Purpose:  to clear out previously retrieved rows
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------
//  12/19/00 cjackson    Original Version
//  03/27/01 C. Jackson  Scroll and expand to the user's deparment (SCR 1513)
//
//******************************************************************************************

STRING l_cOldSelect, l_cDeptID, l_cWhere, l_cNewSelect, l_cSuperLogin
LONG l_nPos, l_nDeptRow
U_DW_STD l_dwResults

uo_search_criticalcases.of_reset()

//l_dwResults = tab_details.tabpage_results.dw_critical_detail

ddlb_sourcetype.Text = '(All)'
ddlb_priority.Text = '(All)'
ddlb_casetype.Text = '(All)'
em_aging.Text = '30'

//l_dwResults.fu_SetOptions( SQLCA, & 
//		l_dwResults.c_NullDW, & 
//		l_dwResults.c_SelectOnRowFocusChange + &
//		l_dwResults.c_NewModeOnEmpty + &
//		l_dwResults.c_ViewOnSelect + &
//		l_dwResults.c_NoActiveRowPointer + &
//		l_dwResults.c_TabularFormStyle + &
//		l_dwResults.c_NoInactiveRowPointer + &
//		l_dwResults.c_NoMenuButtonActivation + &
//		l_dwResults.c_RetrieveAsNeeded) 
		
//// Get old SELECT statement
//l_dwResults.SetTransObject(SQLCA)
//
//l_cOldSelect = l_dwResults.GetSQLSelect()
//
//// Pull out the old where clause
//l_nPos = POS(l_cOldSelect, 'WHERE')
//IF l_nPos > 0 THEN 
//	l_cOldSelect = TRIM(MID(l_cOldSelect,1,(l_nPos - 1)))
//END IF	
//
//l_cDeptID = '0'
//
//// Specify new WHERE clause
//
//l_cWhere = " WHERE ( cusfocus_user_a.user_dept_id  *= cusfocus.cusfocus_user_dept.user_dept_id) and  "+&
//         "( cusfocus_user_b.user_id = cusfocus.case_log.case_log_taken_by) and " +&
//			"( cusfocus.case_log.case_log_case_rep = cusfocus_user_a.user_id ) and  "+&
//			"( cusfocus.case_log.source_type = cusfocus.source_types.source_type ) and  "+&
//			"( cusfocus.case_log.confidentiality_level = cusfocus.confidentiality_levels.confidentiality_level ) and"+&
//			"( cusfocus.case_log.case_status_id = 'O') and " +&
//			"( cusfocus.case_log.case_type = cusfocus.case_types.case_type ) and"+&
//			"( cusfocus_user_a.user_dept_id = '"+l_cDeptID+"' )"
//			
//// Add the new where clause to old_select
//
//l_cNewSelect = l_cOldSelect + l_cWhere
//
//// Set the SELECT statement for the DW
//l_dwResults.SetSQLSelect(l_cNewSelect)
//tab_details.tabpage_results.of_SetStopQuery(FALSE)
//i_nCount = l_dwResults.Retrieve()
//
//// Disable case history detail report if there are no row to report on
//IF ISNULL(i_nCount) or (i_nCount = 0) THEN
	m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
	m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
//END IF

dw_csrlist.SetReDraw(FALSE)
dw_csrlist.Hide()

dw_csrlist.fu_HLCollapseAll()

// Set to the user's department
l_cSuperLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
SELECT user_dept_id INTO :l_cDeptID
  FROM cusfocus.cusfocus_user
 WHERE user_id = :l_cSuperLogin
 USING SQLCA;
 
l_nDeptRow = dw_csrlist.fu_HLFindRow(l_cDeptID, 1)

dw_csrlist.SetReDraw(FALSE)
dw_csrlist.Hide()

dw_csrlist.fu_HLSetSelectedRow(l_nDeptRow)

IF NOT ISNULL(l_cDeptID) OR l_cDeptID <> '' THEN
	dw_csrlist.fu_HLExpandBranch()
END IF

dw_csrlist.Show()
dw_csrlist.SetReDraw(TRUE)

rb_aging.Checked = TRUE
rb_aging.TriggerEvent(Clicked!)
rb_aging.SetFocus()



end subroutine

on u_critical_cases.create
int iCurrent
call super::create
this.dw_appeal_criteria=create dw_appeal_criteria
this.uo_search_criticalcases=create uo_search_criticalcases
this.ddlb_casetype=create ddlb_casetype
this.b_calendar_to=create b_calendar_to
this.b_calendar_from=create b_calendar_from
this.st_3=create st_3
this.rb_aging=create rb_aging
this.st_daterange=create st_daterange
this.em_dateto=create em_dateto
this.em_datefrom=create em_datefrom
this.st_aging=create st_aging
this.em_aging=create em_aging
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_priority=create ddlb_priority
this.ddlb_sourcetype=create ddlb_sourcetype
this.dw_csrlist=create dw_csrlist
this.st_4=create st_4
this.st_to=create st_to
this.st_from=create st_from
this.rb_range=create rb_range
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_appeal_criteria
this.Control[iCurrent+2]=this.uo_search_criticalcases
this.Control[iCurrent+3]=this.ddlb_casetype
this.Control[iCurrent+4]=this.b_calendar_to
this.Control[iCurrent+5]=this.b_calendar_from
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.rb_aging
this.Control[iCurrent+8]=this.st_daterange
this.Control[iCurrent+9]=this.em_dateto
this.Control[iCurrent+10]=this.em_datefrom
this.Control[iCurrent+11]=this.st_aging
this.Control[iCurrent+12]=this.em_aging
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.ddlb_priority
this.Control[iCurrent+16]=this.ddlb_sourcetype
this.Control[iCurrent+17]=this.dw_csrlist
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.st_to
this.Control[iCurrent+20]=this.st_from
this.Control[iCurrent+21]=this.rb_range
this.Control[iCurrent+22]=this.gb_1
end on

on u_critical_cases.destroy
call super::destroy
destroy(this.dw_appeal_criteria)
destroy(this.uo_search_criticalcases)
destroy(this.ddlb_casetype)
destroy(this.b_calendar_to)
destroy(this.b_calendar_from)
destroy(this.st_3)
destroy(this.rb_aging)
destroy(this.st_daterange)
destroy(this.em_dateto)
destroy(this.em_datefrom)
destroy(this.st_aging)
destroy(this.em_aging)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_priority)
destroy(this.ddlb_sourcetype)
destroy(this.dw_csrlist)
destroy(this.st_4)
destroy(this.st_to)
destroy(this.st_from)
destroy(this.rb_range)
destroy(this.gb_1)
end on

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: Initialization
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/28/20 C. Jackson  Original Version
//  03/27/01 C. Jackson  Scroll to and Expand the user's department (SCR 1513)
//
//**********************************************************************************************

STRING l_cSuperLogin, l_cDeptID
LONG l_nDeptRow, l_nIndex
DATAWINDOWCHILD ldwc_line_of_business, ldwc_appeal_type, ldwc_service_type

// Set the options for dw_csrlist level 1
dw_csrlist.fu_HLRetrieveOptions(1, &
		"smallminus.bmp", &
		"smallplus.bmp", &
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		" ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept.dept_desc ", &
		"cusfocus.cusfocus_user_dept", & 
		"cusfocus.cusfocus_user_dept.active <> 'N'", & 
		dw_csrlist.c_KeyString)

// Set the options for dw_csrlist level 2
dw_csrlist.fu_HLRetrieveOptions(2, &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.out_of_office_bmp", &
		"cusfocus.cusfocus_user.user_id", & 
		"cusfocus.cusfocus_user_dept.user_dept_id", & 
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user.user_last_name + ',  ' + cusfocus.cusfocus_user.user_first_name", &
		"cusfocus.cusfocus_user", & 
		"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
		"cusfocus.cusfocus_user.active <> 'N' ", & 
		dw_csrlist.c_KeyString + dw_csrlist.c_BMPFromColumn)
		
dw_csrlist.fu_HLOptions (dw_csrlist.c_DrillDownOnClick + &
	dw_csrlist.c_HideBoxes  )	
		
dw_csrlist.fu_HLCreate(SQLCA,2)	

// get the supervisor dept
l_cSuperLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
SELECT user_dept_id INTO :l_cDeptID
  FROM cusfocus.cusfocus_user
 WHERE user_id = :l_cSuperLogin
 USING SQLCA;
 
l_nDeptRow = dw_csrlist.fu_HLFindRow(l_cDeptID, 1)

dw_csrlist.fu_HLSetSelectedRow(l_nDeptRow)

IF NOT ISNULL(l_cDeptID) OR l_cDeptID <> '' THEN
	dw_csrlist.fu_HLExpandBranch()
//	fu_initialselect()
END IF

IF w_supervisor_portal.i_cSelected = 'Critical Cases' THEN
	i_bFirstOpen = TRUE
   fu_retrieve()
END IF

i_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

//Initialize the resize service
THIS.of_SetResize( TRUE )

THIS.inv_resize.of_SetOrigSize (THIS.width, THIS.height)

THIS.inv_resize.of_SetMinSize (THIS.width, THIS.height)

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( dw_csrlist, THIS.inv_resize.SCALERIGHT )
	THIS.inv_resize.of_Register( st_1, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( st_2, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( st_3, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( st_aging, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( st_daterange, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( st_from, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( st_to, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( ddlb_casetype, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( ddlb_priority, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( ddlb_sourcetype, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( gb_1, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register(dw_appeal_criteria, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( rb_aging, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( rb_range, THIS.inv_resize.FIXEDRIGHT )
//	tHIS.inv_resize.of_Register( tab_details, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( em_aging, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( em_datefrom, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( em_dateto, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( b_calendar_from, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( b_calendar_to, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( uo_search_criticalcases, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF


ddlb_casetype.SelectItem (1)

l_nIndex = ddlb_casetype.FindItem ( 'configurable', 0)
ddlb_casetype.DeleteItem ( l_nIndex )
ddlb_casetype.InsertItem ( gs_ConfigCaseType,  l_nIndex )

dw_appeal_criteria.SetTransObject(SQLCA)
dw_appeal_criteria.Retrieve()
dw_appeal_criteria.InsertRow(0)

dw_appeal_criteria.GetChild('line_of_business', ldwc_line_of_business)
ldwc_line_of_business.InsertRow(1)
ldwc_line_of_business.setitem(1, 'line_of_business_name', '(All)')
ldwc_line_of_business.setitem(1, 'line_of_business_id', 0)

dw_appeal_criteria.GetChild('appeal_type', ldwc_Appeal_Type)
ldwc_appeal_type.InsertRow(1)
ldwc_appeal_type.setitem(1, 'appealname', '(All)')
ldwc_appeal_type.setitem(1, 'appealtypeid', 0)
ldwc_appeal_type.setfilter('appealtypeid = 0')
ldwc_appeal_type.filter()
		
dw_appeal_criteria.GetChild('service_type', ldwc_Service_Type)
ldwc_service_type.InsertRow(1)
ldwc_service_type.setitem(1, 'service_type_name', '(All)')
ldwc_service_type.setitem(1, 'service_type_id', 0)
ldwc_service_type.setfilter('service_type_id = 0')
ldwc_service_type.filter()

dw_appeal_criteria.object.line_of_business[1] = 0
dw_appeal_criteria.object.appeal_type[1] = 0
dw_appeal_criteria.object.service_type[1] = 0

// This radio button disappears...why? Dunno...
rb_range.SetFocus()
dw_csrlist.SetFocus()

end event

type dw_appeal_criteria from datawindow within u_critical_cases
integer x = 2277
integer y = 104
integer width = 686
integer height = 576
integer taborder = 30
string title = "none"
string dataobject = "d_appeal_criteria"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string 	 ls_column_name
long		ll_return, ll_line_of_business_id
DATAWINDOWCHILD ldwc_appeal_type, ldwc_service_type

ls_column_name = this.getcolumnname()

Choose Case ls_column_name
	CASE 'line_of_business'
		GetChild('appeal_type', ldwc_Appeal_Type)
		ll_return = ldwc_Appeal_Type.SetFilter("appealtypeid = 0 or line_of_business_id = " + data)
		ll_return = ldwc_appeal_type.Filter()
		GetChild('service_type', ldwc_Service_Type)
		ldwc_service_type.setfilter('service_type_id = 0')
		ldwc_service_type.filter()
		dw_appeal_criteria.object.appeal_type[1] = 0
		dw_appeal_criteria.object.service_type[1] = 0
		
	CASE 'appeal_type'
		GetChild('service_type', ldwc_Service_Type)
		ll_line_of_business_id = THIS.Object.line_of_business[row]
		ll_return = ldwc_service_Type.SetFilter("service_type_id = 0 or (line_of_business_id = " + String(ll_line_of_business_id) + " and appealtypeid = " + data + ")")
		ll_return = ldwc_service_type.Filter()
		dw_appeal_criteria.object.service_type[1] = 0
		
End Choose


end event

type uo_search_criticalcases from u_search_criticalcases within u_critical_cases
integer x = 14
integer y = 736
integer width = 2985
integer taborder = 130
end type

on uo_search_criticalcases.destroy
call u_search_criticalcases::destroy
end on

type ddlb_casetype from dropdownlistbox within u_critical_cases
integer x = 1239
integer y = 544
integer width = 891
integer height = 564
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"Issue/Concern","Inquiry","Configurable","Proactive","(All)"}
borderstyle borderstyle = stylelowered!
end type

type b_calendar_to from commandbutton within u_critical_cases
boolean visible = false
integer x = 2057
integer y = 196
integer width = 110
integer height = 80
integer taborder = 70
integer textsize = -8
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
//  10/11/00 C. Jackson  Original Version
//
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = w_supervisor_portal.X + PARENT.X + THIS.X
l_nY = w_supervisor_portal.Y + PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX - 650 )
l_cY = String( l_nY + l_nHeight + 463 )

//Only one button(calendar) so open the calendar window
l_cCalendarDate = em_dateto.Text
IF l_cCalendarDate = 'none' OR l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT.GetParent() )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's a date, convert to a datetime.  Otherwise, set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

//Add the date to the datawindow
em_dateto.Text = string(l_dtCalendarDate)


end event

type b_calendar_from from commandbutton within u_critical_cases
boolean visible = false
integer x = 2057
integer y = 104
integer width = 110
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
string text = "..."
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the calendar window to allow for date selection
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/11/00 C. Jackson  Original Version
//
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = w_supervisor_portal.X + PARENT.X + THIS.X
l_nY = w_supervisor_portal.Y + PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX - 650 )
l_cY = String( l_nY + l_nHeight + 463 )

//Only one button(calendar) so open the calendar window
l_cCalendarDate = em_datefrom.Text
IF l_cCalendarDate = 'none' OR l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT.GetParent() )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's a date, convert to a datetime.  Otherwise, set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

//Add the date to the datawindow
em_datefrom.Text = string(l_dtCalendarDate)


end event

type st_3 from statictext within u_critical_cases
integer x = 1243
integer y = 480
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Type:"
boolean focusrectangle = false
end type

type rb_aging from radiobutton within u_critical_cases
integer x = 1239
integer y = 184
integer width = 352
integer height = 68
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aging"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: change date criteria based on date search type
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/10/00 C. Jackson  Original Version
//
//***********************************************************************************************

i_cDateType = 'Aging'

st_daterange.Visible = FALSE
em_datefrom.Visible = FALSE
st_from.Visible = FALSE
st_to.Visible = FALSE
em_dateto.Visible = FALSE
b_calendar_from.Visible = FALSE
b_calendar_to.Visible = FALSE

st_aging.Visible = TRUE
em_aging.Visible = TRUE

end event

type st_daterange from statictext within u_critical_cases
boolean visible = false
integer x = 1655
integer y = 32
integer width = 535
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Opened Date:"
boolean focusrectangle = false
end type

type em_dateto from editmask within u_critical_cases
boolean visible = false
integer x = 1760
integer y = 200
integer width = 288
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type em_datefrom from editmask within u_critical_cases
boolean visible = false
integer x = 1760
integer y = 108
integer width = 283
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

type st_aging from statictext within u_critical_cases
integer x = 1806
integer y = 124
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aging in Days:"
boolean focusrectangle = false
end type

type em_aging from editmask within u_critical_cases
integer x = 1810
integer y = 200
integer width = 311
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1~~9999"
end type

event losefocus;//Add this here to default the value in the field to 1 if
//  the user clears it out.
IF Trim( THIS.Text ) = "" OR Trim( THIS.Text ) = "0" THEN
	THIS.Text = "1"
END IF
end event

type st_2 from statictext within u_critical_cases
integer x = 1723
integer y = 308
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Priority:"
boolean focusrectangle = false
end type

type st_1 from statictext within u_critical_cases
integer x = 1239
integer y = 308
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Source Type:"
boolean focusrectangle = false
end type

type ddlb_priority from dropdownlistbox within u_critical_cases
integer x = 1723
integer y = 376
integer width = 407
integer height = 396
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"High","Normal","Low","(All)"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_sourcetype from dropdownlistbox within u_critical_cases
integer x = 1239
integer y = 376
integer width = 411
integer height = 460
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"Member","Group","Provider","Other","(All)"}
borderstyle borderstyle = stylelowered!
end type

type dw_csrlist from u_outliner_std within u_critical_cases
integer x = 69
integer y = 64
integer width = 1125
integer height = 644
integer taborder = 30
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
integer i_bmpheight = 12
integer i_bmpwidth = 12
end type

event po_pickedrow;call super::po_pickedrow;//***********************************************************************************************
//
//  Event:   po_PickedRow
//  Purpose: Get the row key of the selected row to process the Case Re-Assign
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/28/00 c. jackson  Original Version
//  10/13/00 c. jackson  Add call to function fw_GetCSRInfo
//  12/04/00 c. jackson  Remove automatic retrieve of results tab.
//
//***********************************************************************************************

STRING l_cDeptID, l_cWhere, l_cWhereClause, l_cSelect, l_cNewSelect
LONG l_nIndex, l_nRowCount, l_nLastRow, l_nPos
S_CSR_INFO l_csr_info
U_DW_STD l_dwResults
U_DW_STD l_dwPreview
W_SUPERVISOR_PORTAL l_wParent

//l_dwResults = tab_details.tabpage_results.dw_critical_detail

i_nLevel = clickedlevel

l_nLastRow = THIS.RowCount()

DO
	//	Check to see if this row is selected
	l_nIndex = fu_HLGetSelectedRow(l_nIndex)

	// If this row is selected
	IF l_nIndex > 0 THEN
		
		// Add it to the row count
		l_nRowCount = l_nRowCount + 1
		
		// Add it to the array
		i_nSelectedRow = l_nIndex
		i_cRowDesc = fu_HLGETRowDesc(i_nSelectedRow)
		
		// Set up to check the next row
		l_nIndex = l_nIndex + 1
		
		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
		
	END IF
	
	i_nNumSelected = l_nRowCount
	
LOOP UNTIL l_nIndex = 0

//IF clickedlevel = 1 THEN
//	i_nLevel = 1
//	// Get the Department Id for form query
//	SELECT user_dept_id INTO :l_cDeptID
//	  FROM cusfocus.cusfocus_user_dept
//	 WHERE dept_desc = :i_cRowDesc
//	 USING SQLCA;
//	 l_cWhereClause = " and ( cusfocus_user_a.user_dept_id = '"+l_cDeptID + "') "
//	 
//END IF
//	
//
//IF clickedlevel = 2 THEN
//		i_nLevel = 2
//		l_csr_info = w_supervisor_portal.fw_GetCSRInfo(i_cRowDesc)
//		
//	 l_cWhereClause = " and ( cusfocus_user_a.user_id = '"+l_csr_info.user_id + "') "
//
//END IF
//
//// Get old SELECT statement
//l_dwResults.SetTransObject(SQLCA)
//
//l_cSelect = l_dwResults.GetSQLSelect()
//
//// Pull out the old where clause
//l_nPos = POS(l_cSelect, 'WHERE')
//IF l_nPos > 0 THEN 
//	l_cSelect = TRIM(MID(l_cSelect,1,(l_nPos - 1)))
//END IF	
//
//// Specify new WHERE clause
//
//l_cWhere = " WHERE ( cusfocus_user_a.user_dept_id  *= cusfocus.cusfocus_user_dept.user_dept_id) and  "+&
//         "( cusfocus_user_b.user_id = cusfocus.case_log.case_log_taken_by) and " +&
//         "( cusfocus.case_log.case_log_case_rep = cusfocus_user_a.user_id ) and  "+&
//         "( cusfocus.case_log.source_type = cusfocus.source_types.source_type ) and  "+&
//         "( cusfocus.case_log.confidentiality_level = cusfocus.confidentiality_levels.confidentiality_level ) and"+&
//			"( cusfocus.case_log.case_status_id = 'O') and " +&
//			"( cusfocus.case_log.case_type = cusfocus.case_types.case_type ) "+&
//			l_cWhereClause
//
//			
//// Add the new where clause to old_select
//l_cNewSelect = l_cSelect + l_cWhere
//
//i_cSelect = l_cNewSelect
//
THIS.TriggerEvent(rowfocuschanged!)
//
//fu_clearoutliner()
//

end event

event po_selectedrow;call super::po_selectedrow;//**********************************************************************************************
//
//  Event:   po_selectedrow
//  Purpose: Retrieve list datawindow based on item selected in this outliner
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/10/00 C. Jackson  Original Version
//  10/13/00 C. Jackson  Add call to function fw_GetCSRInfo
//  11/10/00 C. Jackson  Add 'IsValid' around enabling of menus
//
//**********************************************************************************************

STRING l_cDeptID, l_cWhere, l_cWhereClause, l_cSelect, l_cNewSelect
LONG l_nIndex, l_nRowCount, l_nLastRow, l_nPos
U_DW_STD l_dwResults
U_DW_STD l_dwPreview
S_CSR_INFO l_csr_info

dw_csrlist.SetRedraw(FALSE)
dw_csrlist.Hide()

//??? Don't think we need this with the new stuff - RAP
//l_dwResults = tab_details.tabpage_results.dw_critical_detail  
//
//IF i_nLevel = 1 THEN
//	// Get the Department Id for form query
//	SELECT user_dept_id INTO :l_cDeptID
//	  FROM cusfocus.cusfocus_user_dept
//	 WHERE dept_desc = :i_cRowDesc
//	 USING SQLCA;
//	 l_cWhereClause = " and ( cusfocus_user_a.user_dept_id = '"+l_cDeptID + "') "
//
//END IF
//	
//IF i_nLevel = 2 THEN
//	l_csr_info = w_supervisor_portal.fw_GetCSRInfo(i_cRowDesc)
//	
//	l_cWhereClause = " and ( cusfocus_user_a.user_id = '"+ l_csr_info.user_id + "') "
//
//END IF
//
//// Get old SELECT statement
//l_dwResults.SetTransObject(SQLCA)
//
//l_cSelect = l_dwResults.GetSQLSelect()
//
//// Pull out the old where clause
//l_nPos = POS(l_cSelect, 'WHERE')
//IF l_nPos > 0 THEN 
//	l_cSelect = TRIM(MID(l_cSelect,1,(l_nPos - 1)))
//END IF	
//
//// Specify new WHERE clause
//
//l_cWhere = " WHERE ( cusfocus.cusfocus_user_a.user_dept_id  *= cusfocus.cusfocus_user_dept.user_dept_id) and  "+&
//         "( cusfocus_user_b.user_id = cusfocus.case_log.case_log_taken_by) and " +&
//         "( cusfocus.case_log.case_log_case_rep = cusfocus.cusfocus_user_a.user_id ) and  "+&
//         "( cusfocus.case_log.source_type = cusfocus.source_types.source_type ) and  "+&
//         "( cusfocus.case_log.confidentiality_level = cusfocus.confidentiality_levels.confidentiality_level ) and"+&
//			"( cusfocus.case_log.case_status_id = 'O') and " +&
//			"( cusfocus.case_log.case_type = cusfocus.case_types.case_type ) "+&
//			l_cWhereClause
//
//// Add the new where clause to old_select
//
//l_cNewSelect = l_cSelect + l_cWhere
//
//// Set the SELECT statement for the DW
//l_dwResults.SetSQLSelect(l_cNewSelect)
//
//tab_details.tabpage_results.of_SetStopQuery(FALSE)
//
//l_nRowCount = 0
////l_nRowCount = l_dwResults.Retrieve()
//l_dwResults.Reset()

IF NOT IsValid(m_supervisor_portal.m_file) THEN
	RETURN
END IF
IF IsValid(m_supervisor_portal.m_file) THEN
	IF l_nRowCount = 0 THEN
		m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
		m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
	ELSE
		m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = TRUE
		m_supervisor_portal.m_file.m_casedetail.Enabled = TRUE
	END IF
END IF


dw_csrlist.Show()
dw_csrlist.SetRedraw(TRUE)


end event

type st_4 from statictext within u_critical_cases
integer x = 50
integer width = 736
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select Department or User:"
boolean focusrectangle = false
end type

type st_to from statictext within u_critical_cases
boolean visible = false
integer x = 1659
integer y = 204
integer width = 96
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "to:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_from from statictext within u_critical_cases
boolean visible = false
integer x = 1591
integer y = 112
integer width = 165
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "from:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_range from radiobutton within u_critical_cases
integer x = 1239
integer y = 104
integer width = 347
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Range"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: change date criteria based on date search type
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/10/00 C. Jackson  Original Version
//
//***********************************************************************************************

i_cDateType = 'DateRange'

st_daterange.Visible = TRUE
em_datefrom.Visible = TRUE
st_from.Visible = TRUE
st_to.Visible = TRUE
em_dateto.Visible = TRUE
b_calendar_from.Visible = TRUE
b_calendar_to.Visible = TRUE

st_aging.Visible = FALSE
em_aging.Visible = FALSE

end event

type gb_1 from groupbox within u_critical_cases
integer x = 1216
integer width = 1774
integer height = 704
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Criteria"
end type

