$PBExportHeader$u_performance.sru
$PBExportComments$Reports User Object
forward
global type u_performance from u_container_std
end type
type st_5 from statictext within u_performance
end type
type st_4 from statictext within u_performance
end type
type dw_print_supervisor_report from u_dw_std within u_performance
end type
type cb_print from commandbutton within u_performance
end type
type cb_view from commandbutton within u_performance
end type
type dw_report_list from u_dw_std within u_performance
end type
type st_3 from statictext within u_performance
end type
type b_calendar_to from commandbutton within u_performance
end type
type b_calendar_from from commandbutton within u_performance
end type
type st_2 from statictext within u_performance
end type
type rb_takenby from radiobutton within u_performance
end type
type rb_owner from radiobutton within u_performance
end type
type st_1 from statictext within u_performance
end type
type st_to from statictext within u_performance
end type
type st_from from statictext within u_performance
end type
type em_to from editmask within u_performance
end type
type em_from from editmask within u_performance
end type
type ddlb_date from dropdownlistbox within u_performance
end type
type dw_csrreport from u_outliner_std within u_performance
end type
type cb_remove from commandbutton within u_performance
end type
type cb_add from commandbutton within u_performance
end type
type dw_csrlist from u_outliner_std within u_performance
end type
end forward

global type u_performance from u_container_std
integer width = 3040
integer height = 1692
st_5 st_5
st_4 st_4
dw_print_supervisor_report dw_print_supervisor_report
cb_print cb_print
cb_view cb_view
dw_report_list dw_report_list
st_3 st_3
b_calendar_to b_calendar_to
b_calendar_from b_calendar_from
st_2 st_2
rb_takenby rb_takenby
rb_owner rb_owner
st_1 st_1
st_to st_to
st_from st_from
em_to em_to
em_from em_from
ddlb_date ddlb_date
dw_csrreport dw_csrreport
cb_remove cb_remove
cb_add cb_add
dw_csrlist dw_csrlist
end type
global u_performance u_performance

type variables
STRING i_cRowDesc[]
STRING i_cDelRowDesc[]
STRING i_cReport
STRING i_cUserList
STRING i_cDateType
STRING i_cReportBy
STRING i_cSubtitle
STRING i_cDateParms
STRING i_cUserArr[ ]
STRING i_cReportOn

LONG i_nLevel
LONG i_nSelectedRow
LONG i_nDelRow
LONG i_nNumSelected
LONG i_nDelSelected

DATASTORE i_dsUsers

DATE i_dtFromDate
DATE i_dtToDate

DATETIME i_dtFirstDate
DATETIME i_dtLastDate

BOOLEAN i_bExternal
end variables

forward prototypes
public subroutine fu_refresh ()
public subroutine fu_initialselect ()
end prototypes

public subroutine fu_refresh ();//**********************************************************************************************
//
//  Function: fu_refresh
//  Purpose:  To refresh the outliners
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  10/24/00 C. Jackson  Original Version
//
//**********************************************************************************************

LONG l_nLastRow, l_nIndex, l_nNumSelected, l_nSelectedRow[], l_nLevel

dw_csrlist.Hide()
dw_csrlist.SetRedraw(FALSE)
	
l_nLastRow = dw_csrlist.RowCount()

l_nIndex = 1
DO
  l_nIndex = dw_csrlist.fu_HLGetSelectedRow(l_nIndex)

  IF l_nIndex > 0 THEN
    l_nNumSelected = l_nNumSelected + 1
    l_nSelectedRow[l_nNumSelected] = l_nIndex
    l_nIndex = l_nIndex + 1

    IF l_nIndex > l_nLastRow THEN
      l_nIndex = 0
    END IF
	 
  END IF
  
LOOP UNTIL l_nIndex = 0

IF l_nNumSelected <> 0 THEN

	l_nLevel = dw_csrlist.fu_HLGetRowLevel(l_nSelectedRow[1])
	
	IF l_nLevel = 1 THEN
		// Refresh and expand
		dw_csrlist.fu_HLRefresh(2, dw_csrlist.c_ReselectRows)
		dw_csrlist.fu_HLExpandBranch()
	ELSE
		// Just refresh
		dw_csrlist.fu_HLRefresh(2, dw_csrlist.c_ReselectRows)
	END IF
	
END IF

dw_csrlist.SetRedraw(TRUE)
dw_csrlist.Show()


end subroutine

public subroutine fu_initialselect ();//********************************************************************************
//
//  Function: fu_initialselect
//  Purpose:  to set selected row, etc.
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------
//  11/09/00  C. Jackson Original Version
//
//********************************************************************************

LONG l_nlvl1cntr, l_nlvl2cntr, l_nLastRow, l_nIndex, l_nRowCount

l_nLvl1Cntr = 0
l_nLvl2Cntr = 0

i_nLevel = 1

l_nLastRow = dw_csrlist.RowCount()

DO
	//	Check to see if this row is selected
	l_nIndex = dw_csrlist.fu_HLGetSelectedRow(l_nIndex)

	// If this row is selected
	IF l_nIndex > 0 THEN
		
		// Add it to the row count
		l_nRowCount = l_nRowCount + 1
		
		// Add it to the array
		i_nSelectedRow = l_nIndex
		i_cRowDesc[l_nIndex] = dw_csrlist.fu_HLGETRowDesc(i_nSelectedRow)
		IF i_nLevel = 1 THEN
			l_nLvl1Cntr ++
			i_cRowDesc[l_nLvl1Cntr] = i_cRowDesc[l_nIndex]
		ELSE
			l_nLvl2Cntr ++
			i_cRowDesc[l_nLvl2Cntr] = i_cRowDesc[l_nIndex]
		END IF
		
		// Set up to check the next row
		l_nIndex = l_nIndex + 1
		
		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
		
	END IF
	
	i_nNumSelected = l_nRowCount 
	
LOOP UNTIL l_nIndex = 0


end subroutine

on u_performance.create
int iCurrent
call super::create
this.st_5=create st_5
this.st_4=create st_4
this.dw_print_supervisor_report=create dw_print_supervisor_report
this.cb_print=create cb_print
this.cb_view=create cb_view
this.dw_report_list=create dw_report_list
this.st_3=create st_3
this.b_calendar_to=create b_calendar_to
this.b_calendar_from=create b_calendar_from
this.st_2=create st_2
this.rb_takenby=create rb_takenby
this.rb_owner=create rb_owner
this.st_1=create st_1
this.st_to=create st_to
this.st_from=create st_from
this.em_to=create em_to
this.em_from=create em_from
this.ddlb_date=create ddlb_date
this.dw_csrreport=create dw_csrreport
this.cb_remove=create cb_remove
this.cb_add=create cb_add
this.dw_csrlist=create dw_csrlist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.dw_print_supervisor_report
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_view
this.Control[iCurrent+6]=this.dw_report_list
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.b_calendar_to
this.Control[iCurrent+9]=this.b_calendar_from
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.rb_takenby
this.Control[iCurrent+12]=this.rb_owner
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.st_to
this.Control[iCurrent+15]=this.st_from
this.Control[iCurrent+16]=this.em_to
this.Control[iCurrent+17]=this.em_from
this.Control[iCurrent+18]=this.ddlb_date
this.Control[iCurrent+19]=this.dw_csrreport
this.Control[iCurrent+20]=this.cb_remove
this.Control[iCurrent+21]=this.cb_add
this.Control[iCurrent+22]=this.dw_csrlist
end on

on u_performance.destroy
call super::destroy
destroy(this.st_5)
destroy(this.st_4)
destroy(this.dw_print_supervisor_report)
destroy(this.cb_print)
destroy(this.cb_view)
destroy(this.dw_report_list)
destroy(this.st_3)
destroy(this.b_calendar_to)
destroy(this.b_calendar_from)
destroy(this.st_2)
destroy(this.rb_takenby)
destroy(this.rb_owner)
destroy(this.st_1)
destroy(this.st_to)
destroy(this.st_from)
destroy(this.em_to)
destroy(this.em_from)
destroy(this.ddlb_date)
destroy(this.dw_csrreport)
destroy(this.cb_remove)
destroy(this.cb_add)
destroy(this.dw_csrlist)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To set User Object options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/12/00 C. Jackson  Original Version
//  11/01/01 C. Jackson  Correct department outliner to not include inactive departments
//
//***********************************************************************************************

STRING l_cStringDate, l_cSuperLogin, l_cDeptID, l_cDateParm
LONG l_nDeptRow, l_nRtn, l_nRow

// Initialize reassign From Outliner Datawindow
dw_csrlist.fu_HLOptions (dw_csrlist.c_MultiSelect)

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
		dw_csrlist.c_KeyString )

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
		"cusfocus.cusfocus_user.active <> 'N'", & 
		dw_csrlist.c_KeyString + dw_csrlist.c_BMPFromColumn)
		
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
	fu_initialselect()
END IF

// Initialize destination outliner datawindow

dw_csrreport.fu_HLOptions(dw_csrreport.c_MultiSelect + dw_csrreport.c_ShowLines)

dw_csrreport.fu_HLInsertOptions(1, dw_csrreport.c_KeyString + dw_csrreport.c_SortString + dw_csrreport.c_ShowLines)
dw_csrreport.fu_HLInsertOptions(2, dw_csrreport.c_KeyString + dw_csrreport.c_SortString)

dw_csrreport.fu_HLCreate(dw_csrreport.c_DefaultTransaction, 2)

// Set default for date drop down
ddlb_Date.SelectItem(4)
i_cDateType = "TODAY"

// Set rb_owner by default
rb_owner.Checked = TRUE
i_cReportBy = "case_log_case_rep"
rb_takenby.Checked = FALSE

IF UPPER(l_cSuperLogin) = 'CFADMIN' THEN
// 9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//IF UPPER(l_cSuperLogin) = 'SYSADMIN' THEN
	dw_report_list.fu_Swap('d_report_list_sysadmin', c_SaveChanges, c_Default)
ELSE
	dw_report_list.fu_Swap('d_report_list', c_SaveChanges, c_Default)
END IF

dw_report_list.SetTransObject(SQLCA)
l_nRtn = dw_report_list.Retrieve(l_cSuperLogin)	

IF l_nRtn > 0 THEN
	l_nRow = dw_report_list.GetRow()
	i_cReport = dw_report_list.GetItemString(l_nRow,'report_dtwndw_frmt_strng')
	i_cDateParms = dw_report_list.GetItemString(l_nRow,'date_parms')
	IF i_cDateParms = 'N' THEN
		ddlb_date.Enabled = FALSE
	ELSE
		ddlb_date.Enabled = TRUE
	END IF

ELSE
	SETNULL(i_cReport)
END IF

l_cStringDate = STRING(Today())
em_to.Text = l_cStringDate

i_dtToDate = Today()


//Initialize the resize service
THIS.of_SetResize( TRUE )

THIS.inv_resize.of_SetOrigSize (THIS.width, THIS.height)

THIS.inv_resize.of_SetMinSize (THIS.width, THIS.height)

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( dw_csrlist , THIS.inv_resize.SCALEBOTTOM )
	THIS.inv_resize.of_Register( dw_csrreport , THIS.inv_resize.SCALEBOTTOM )
	THIS.inv_resize.of_Register( dw_report_list , THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( cb_add , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( cb_remove , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( cb_print , THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( cb_view , THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( st_1 , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( st_2 , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( st_3 , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( rb_owner , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( rb_takenby , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( ddlb_date , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( st_from , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( st_to , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( em_from , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( em_to , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( b_calendar_from , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( b_calendar_to , THIS.inv_resize.FIXEDBOTTOM )
END IF


end event

type st_5 from statictext within u_performance
integer x = 1719
integer y = 16
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
string text = "Report on:"
boolean focusrectangle = false
end type

type st_4 from statictext within u_performance
integer x = 27
integer y = 16
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
string text = "Available:"
boolean focusrectangle = false
end type

type dw_print_supervisor_report from u_dw_std within u_performance
boolean visible = false
integer x = 270
integer y = 128
integer width = 485
integer height = 404
integer taborder = 20
boolean enabled = false
string dataobject = "d_csr_activity_caserep"
end type

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: To set the datawindow options
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/24/00 C. Jackson  Original Version
//
//***********************************************************************************************

fu_SetOptions (SQLCA, c_NullDW, c_Default)
end event

type cb_print from commandbutton within u_performance
integer x = 2377
integer y = 1568
integer width = 297
integer height = 80
integer taborder = 110
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
//  10/23/00 C. Jackson  Original Version
//  11/08/00 C. Jackson  Add code to reset SQL select back to l_cOldSelect if there are not rows
//                       (SCR 913)
//  05/04/01 C. Jackson  Add code for Open Cases by CSR
//  07/10/01 C. Jackson  Initialize l_dtToday (SCR 2168)
//  5/22/2002 K. Claver  Corrected date validation.  Need to format the date string to accomodate
//								 for users that do not have the date formatted to a 4 digit year in their
//								 regional settings.  Also added code to check if the from date is greater
//								 than the to date.
//
//**********************************************************************************************

STRING l_cUserFullName, l_cUser, l_cWhere, l_cReportOn, l_cDayName, l_cToday, l_cOrderBy
STRING l_cOldSelect, l_cNewSelect, l_cLogin, l_cUserArr[ ], l_cNullArr[]
LONG l_nDWRowCount, l_nIndex, l_nRowLevel, l_nYear, l_nMonth, l_nDayNumber, l_nReportRows
LONG l_nPos
BOOLEAN l_bMultiUser
DATE l_dtToday, l_dFirstDate, l_dLastDate
DateTime l_dtFirstDate, l_dtLastDate
Integer l_nUserIdx = 0
S_CSR_INFO l_csr_info

l_dtToday = Today()

IF ISNULL(i_cReport) THEN
	messagebox(gs_AppName,'Please select a report to view')
	RETURN
END IF

IF rb_owner.Checked THEN
	l_cReportOn = 'O'
ELSE
	l_cReportOn = 'T'
END IF

// Make sure the date is valid
IF i_cDateType = 'RANGE' THEN
	em_from.GetData(l_dFirstDate)
	em_to.GetData(l_dLastDate)
	
	IF (YEAR(l_dFirstDate) < 1753 OR string(l_dFirstDate, "mm/dd/yyyy") = '01/01/1900' ) THEN
		messagebox(gs_AppName,'Please enter a valid From Date.', StopSign!, OK!)
		em_from.SetFocus()
		RETURN
	ELSEIF (YEAR(l_dLastDate) < 1753 OR string(l_dLastDate, "mm/dd/yyyy") = '01/01/1900') THEN
		messagebox(gs_AppName,'Please enter a valid To Date.', StopSign!, OK!)
		em_to.SetFocus()
		RETURN
	ELSEIF l_dFirstDate > l_dLastDate THEN
		MessageBox( gs_AppName, "From Date must be less than To Date", StopSign!, OK! )
		em_from.SetFocus()
		RETURN
	END IF
	
END IF

// Determine which report to run
CHOOSE CASE i_cReport
		
	CASE 'd_csr_activity_report'
		CHOOSE CASE i_cReportBy
			CASE 'case_log_case_rep'
				dw_print_supervisor_report.fu_Swap("d_csr_activity_caserep", c_IgnoreChanges, &
						dw_print_supervisor_report.c_Default)
			CASE 'case_log_taken_by'
				dw_print_supervisor_report.fu_Swap("d_csr_activity_takenby", c_IgnoreChanges, &
						dw_print_supervisor_report.c_Default)
			END CHOOSE
	CASE 'd_open_case_levels'
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				dw_print_supervisor_report.fu_swap("d_open_case_rep", c_IgnoreChanges, &
				       dw_print_supervisor_report.c_Default)
			CASE 'case_log_taken_by'
				dw_print_supervisor_report.fu_swap("d_open_taken_by", c_IgnoreChanges, &
				       dw_print_supervisor_report.c_Default)
			END CHOOSE
	CASE 'd_csr_aging'
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				dw_print_supervisor_report.fu_swap("d_csr_aging_case_rep", c_IgnoreChanges, &
						dw_print_supervisor_report.c_Default)
			CASE 'case_log_taken_by'
				dw_print_supervisor_report.fu_swap("d_csr_aging_taken_by", c_IgnoreChanges, &
						dw_print_supervisor_report.c_Default)
		END CHOOSE
	CASE 'd_master_vs_indiv'
		CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
			CASE 'case_log_case_rep'
				dw_print_supervisor_report.fu_swap("d_linked_case_rep", c_IgnoreChanges, &
						dw_print_supervisor_report.c_Default)
			CASE 'case_log_taken_by'
				dw_print_supervisor_report.fu_swap("d_linked_case_taken", c_IgnoreChanges, &
						dw_print_supervisor_report.c_Default)
		END CHOOSE
	CASE 'd_open_cases_by_csr'
			dw_print_supervisor_report.fu_swap("d_open_cases_by_csr", c_IgnoreChanges, &
					dw_print_supervisor_report.c_Default)
		
END CHOOSE


// Clear out user list
SETNULL(i_cUserList)

// Get the user list
l_nDWRowCount = dw_csrreport.RowCount()

IF i_cReport = 'd_open_cases_by_csr' THEN
	IF l_nDWRowCount > 2 THEN // Since dept moves over with user, 2 counting dept
		messagebox(gs_AppName,'This report can only be run on one user at a time.')
		RETURN
	END IF
END IF

FOR l_nIndex = 1 TO l_nDWRowCount
	l_nRowLevel = dw_csrreport.fu_HLGetRowLevel(l_nIndex)
	IF l_nRowLevel = 2 THEN
		l_cUserFullName = dw_csrreport.fu_HLGetRowDesc(l_nIndex)	
		l_csr_info = w_supervisor_portal.fw_GetCSRInfo(l_cUserFullName)
		l_cUser = "'"+l_csr_info.user_id+"'"
		
		//Add to a string array for the linked case report
		l_nUserIdx ++
		l_cUserArr[ l_nUserIdx ] = l_csr_info.user_id
		
		IF ISNULL(i_cUserList) OR i_cUserList = '' THEN
			i_cUserList = l_cUser
		ELSE
			i_cUserList = i_cUserList + ', ' + l_cUser
			l_bMultiUser = TRUE
			
		END IF
		
	END IF
	
NEXT

IF ISNULL(i_cUserList) OR ( UpperBound( l_cUserArr ) = 0 AND i_cReport = 'd_master_vs_indiv' ) THEN
	messagebox(gs_AppName,'Please select user(s) or department(s) to report on.')
	RETURN
END IF

IF l_bMultiUser THEN
	i_cUserList = "("+i_cUserList+")"
	l_cWhere =  " AND (cusfocus.case_log."+i_cReportBy+" in " + i_cUserList + " ) " 
ELSE
	l_cWhere =  " AND (cusfocus.case_log."+i_cReportBy+" = " + i_cUserList + " ) "
END IF

CHOOSE CASE i_cDateParms
		CASE 'Y'
	// Look at Date parameters
	l_nYear = YEAR(l_dtToday)
	l_nMonth = MONTH(l_dtToday)
	l_cToday = STRING(l_dtToday, "mm-dd-yyyy")
	
	CHOOSE CASE i_cDateType
			
		CASE "YTD"
			l_dFirstDate = Date( "01-01-"+string(l_nYear) )
			l_dLastDate = l_dtToday
			
			l_cWhere = l_cWhere + " AND ( case_log_opnd_date > '01-01-"+string(l_nYear)+" 00:00:00.000' ) " +& 
										 " AND ( case_log_opnd_date < '"+l_cToday+" 23:59:59.999' ) " 
			i_cSubTitle = "From:  01-01-" + string(l_nYear)+" To: " + l_cToday
			
		CASE "MTD"
			l_dFirstDate = Date( string(l_nMonth)+"-01-"+string(l_nYear) )
			l_dLastDate = l_dtToday
			
			l_cWhere = l_cWhere + " AND ( case_log_opnd_date > '"+string(l_nMonth)+"-01-"+string(l_nYear)+" 00:00:00.000' ) " +& 
										 " AND ( case_log_opnd_date < '"+l_cToday+" 23:59:59.999' ) "
			i_cSubTitle = "From:  " + string(l_nMonth) + "-01-"+string(l_nYear) + " To: " + l_cToday
			
		CASE "WEEK"
			l_nDayNumber = DAYNUMBER(l_dtToday)
	
			CHOOSE CASE l_nDayNumber
				CASE 1
					l_dFirstDate = l_dtToday
					l_dLastDate = RelativeDate(l_dtToday, 6 )
				CASE 2
					l_dFirstDate = RelativeDate(l_dtToday, -1)
					l_dLastDate = RelativeDate(l_dtToday, 5 )
				CASE 3
					l_dFirstDate = RelativeDate(l_dtToday, -2)
					l_dLastDate = RelativeDate(l_dtToday, 4 )
				CASE 4
					l_dFirstDate = RelativeDate(l_dtToday, -3)
					l_dLastDate = RelativeDate(l_dtToday, 3 )
				CASE 5
					l_dFirstDate = RelativeDate(l_dtToday, -4)
					l_dLastDate = RelativeDate(l_dtToday, 2 )
				CASE 6
					l_dFirstDate = RelativeDate(l_dtToday, -5)
					l_dLastDate = RelativeDate(l_dtToday, 1 )
				CASE 7
					l_dFirstDate = RelativeDate(l_dtToday, -6)
					l_dLastDate = l_dtToday
				
			END CHOOSE		
			
			l_cWhere = l_cWhere + " AND ( case_log_opnd_date > '"+string(l_dFirstDate)+" 00:00:00.000' ) " +& 
										 " AND ( case_log_opnd_date < '"+string(l_dLastDate)+" 23:59:59.999' ) " 
			
			i_cSubTitle = "From: "+ string(l_dFirstDate)+"  To: "+string(l_dLastDate)
			
		CASE "TODAY"
			l_dFirstDate = l_dtToday
			l_dLastDate = l_dtToday
		
			l_cWhere = l_cWhere + " AND (case_log_opnd_date > '"+string(l_dFirstDate)+" 00:00:00.000' ) " + &
										 " AND (case_log_opnd_date < '"+string(l_dLastDate)+" 23:59:59.999' ) "
			i_cSubTitle = "From: "+string(l_dFirstDate)+"  To: "+string(l_dLastDate)
			
		CASE "RANGE"
			em_from.GetData(l_dFirstDate)
			em_to.GetData(l_dLastDate)
			l_cWhere = l_cWhere + " AND (case_log_opnd_date > '"+string(l_dFirstDate)+" 00:00:00.000' ) " + &
										 " AND (case_log_opnd_date < '"+string(l_dLastDate)+" 23:59:59.999') "
			i_cSubTitle = "From: "+string(l_dFirstDate)+"  To: "+string(l_dLastDate)
					
	END CHOOSE
	
END CHOOSE

l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

CHOOSE CASE i_cReport
		
	CASE 'd_open_cases_by_csr'
		
		dw_print_supervisor_report.fu_swap("d_open_cases_by_csr", c_IgnoreChanges, &
				dw_print_supervisor_report.c_Default)		
		
		dw_print_supervisor_report.SetTransObject(SQLCA)
		
		IF UPPERBOUND(l_cUserArr) > 1 THEN
			// Should never get here, but coded just in case
			messagebox(gs_AppName,'This report can only be run on one user at a time.')
			RETURN
		ELSE
			l_cUser = l_cUserArr[1]
			l_nReportRows = dw_print_supervisor_report.Retrieve(l_cLogin,l_cUser)
		END IF
		
	CASE 'd_master_vs_indiv'
		// Retrieve the report for linked cases
		l_dtFirstDate = DateTime( l_dFirstDate, Time( "00:00:00.000" ) )
		l_dtLastDate = DateTime( l_dLastDate, Time( "23:59:59.999" ) )
		
		l_nReportRows = dw_print_supervisor_report.Retrieve( l_dtFirstDate, l_dtLastDate, l_cUserArr, l_cLogin )
		
		//Resort and recalc groups
		dw_print_supervisor_report.Sort( )
		dw_print_supervisor_report.GroupCalc( )
		
	CASE ELSE
		dw_print_supervisor_report.SetTransObject(SQLCA)
		
		l_cOldSelect = dw_print_supervisor_report.GetSQLSelect()
		
		// Check to see if we have an Order By clause to pull out
		l_nPos = POS(l_cOldSelect,'ORDER BY')
		IF l_nPos > 0 THEN
			// break out order by to be added to end of new select statement
			l_cOrderBy = MID(l_cOldSelect, l_nPos)
			l_cOldSelect = MID(l_cOldSelect, 1, l_nPos - 1)
		END IF
		
		l_cNewSelect = l_cOldSelect + ' ' + l_cWhere + ' ' + l_cOrderBy
		
		dw_print_supervisor_report.SetSQLSelect(l_cNewSelect)
		
		l_nReportRows = dw_print_supervisor_report.Retrieve(l_cLogin,i_cSubtitle)
	END CHOOSE

IF ( NOT ISNULL(l_nReportRows) AND l_nReportRows > 0 ) OR w_supervisor_portal.i_cShowBlankReport = "Y" THEN
	
	IF ( IsNull( l_nReportRows ) OR l_nReportRows <= 0 ) AND w_supervisor_portal.i_cShowBlankReport = "Y" THEN
		messagebox(gs_AppName,'No data to report on.')
	END IF
	
	SetPointer(Hourglass!)
	
	dw_print_supervisor_report.Print()
	SetPointer(Arrow!)

ELSE
	messagebox(gs_AppName,'No data to report on.')
	dw_print_supervisor_report.SetSQLSelect(l_cOldSelect)
	
END IF


end event

type cb_view from commandbutton within u_performance
integer x = 2702
integer y = 1568
integer width = 297
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&View"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To launch the requested report
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  10/18/00 C. Jackson  Original Version
//  11/08/00 C. Jackson  Add code to reset SQL select back to l_cOldSelect if there are not rows
//                       (SCR 913)
//  03/30/01 C. Jackson  If the report window is already open, close it, before trying to run
//                       another report.  (SCR 1574)
//  05/04/01 C. Jackson  Add code for Open Cases by CSR
//  01/28/02 C. Jackson  Add date validation
//  5/22/2002 K. Claver  Corrected date validation.  Must format the date to accomodate for users
//								 that do not have date formatted to a 4 digit year in their regional settings.
//								 Also added code to check if the from date is greater than the to date.
//************************************************************************************************

STRING l_cUserFullName, l_cUser, l_cWhere, l_cReportOn, l_cDayName, l_cParm, l_cToday, l_cLogin
STRING l_cOldSelect, l_cNewSelect, l_cOrderBY, l_cExtSource, l_cExtCommand, l_cNullArr[ ]
LONG l_nDWRowCount, l_nIndex, l_nRowLevel, l_nYear, l_nMonth, l_nDayNumber, l_nReportRows
LONG l_nDWRow, l_nPos, l_nLen, l_nFileNum
BOOLEAN l_bMultiUser
DATE l_dtToday, l_dFirstDate, l_dLastDate
DateTime l_dtFirstDate, l_dtLastDate
Integer l_nUserIdx
S_CSR_INFO l_csr_info

//Set user array to null
i_cUserArr = l_cNullArr

l_dtToday = Today()

// Clear out user list
SETNULL(i_cUserList)

SETNULL(i_cReport)
l_nDWRow = dw_report_list.GetRow()

IF l_nDWRow = 0 THEN
	messagebox(gs_AppName,'Please select a report.')
ELSE
	i_cReport = dw_report_list.GetItemString(l_nDWRow,'report_dtwndw_frmt_strng')
END IF

// Make sure the date is valid
IF i_cDateType = 'RANGE' THEN
	em_from.GetData(l_dFirstDate)
	em_to.GetData(l_dLastDate)
	
	IF (YEAR(l_dFirstDate) < 1753 OR string(l_dFirstDate, "mm/dd/yyyy") = '01/01/1900' ) THEN
		messagebox(gs_AppName,'Please enter a valid From Date.', StopSign!, OK!)
		em_from.SetFocus()
		RETURN
	ELSEIF (YEAR(l_dLastDate) < 1753 OR string(l_dLastDate, "mm/dd/yyyy") = '01/01/1900') THEN
		messagebox(gs_AppName,'Please enter a valid To Date.', StopSign!, OK!)
		em_to.SetFocus()
		RETURN
	ELSEIF l_dFirstDate > l_dLastDate THEN
		MessageBox( gs_AppName, "From Date must be less than To Date", StopSign!, OK! )
		em_from.SetFocus()
		RETURN
	END IF

END IF

IF rb_owner.Checked THEN
	l_cReportOn = 'O'
ELSE
	l_cReportOn = 'T'
END IF

// Get the user list
l_nDWRowCount = dw_csrreport.RowCount()

IF i_cReport = 'd_open_cases_by_csr' THEN
	IF l_nDWRowCount > 2 THEN // Since dept moves over with user, 2 counting dept
		messagebox(gs_AppName,'This report can only be run on one user at a time.')
		RETURN
	END IF
END IF

	FOR l_nIndex = 1 TO l_nDWRowCount
		l_nRowLevel = dw_csrreport.fu_HLGetRowLevel(l_nIndex)
		IF l_nRowLevel = 2 THEN
			l_cUserFullName = dw_csrreport.fu_HLGetRowDesc(l_nIndex)	
			l_csr_info = w_supervisor_portal.fw_GetCSRInfo(l_cUserFullName)
			l_cUser = "'"+l_csr_info.user_id+"'"
			
			//Add to a string array for the linked case report
			l_nUserIdx ++
			i_cUserArr[ l_nUserIdx ] = l_csr_info.user_id
			
			IF ISNULL(i_cUserList) OR i_cUserList = '' THEN
				i_cUserList = l_cUser
			ELSE
				i_cUserList = i_cUserList + ', ' + l_cUser
				l_bMultiUser = TRUE
				
			END IF
			
		END IF
		
	NEXT
	
	IF ISNULL(i_cUserList) OR ( UpperBound( i_cUserArr ) = 0 AND i_cReport = 'd_master_vs_indiv' ) THEN
		CHOOSE CASE i_cReport
			CASE 'd_open_cases_by_csr'
				messagebox(gs_AppName,'Please select a user to report on.')
			CASE ELSE
				messagebox(gs_AppName,'Please select user(s) or department(s) to report on.')
		END CHOOSE
		RETURN
	END IF
	
	IF l_bMultiUser THEN
		i_cUserList = "("+i_cUserList+")"
		l_cWhere =  " AND (cusfocus.case_log."+i_cReportBy+" in " + i_cUserList + " ) " 
	ELSE
		l_cWhere =  " AND (cusfocus.case_log."+i_cReportBy+" = " + i_cUserList + " ) "
	END IF
	
	CHOOSE CASE i_cDateParms
		CASE 'Y'
		// Look at Date parameters
		l_nYear = YEAR(l_dtToday)
		l_nMonth = MONTH(l_dtToday)
		l_cToday = STRING(l_dtToday, "mm-dd-yyyy")
		
		CHOOSE CASE i_cDateType
				
			CASE "YTD"
				l_dFirstDate = Date( "01-01-"+string(l_nYear) )
				l_dLastDate = l_dtToday
				
				l_cWhere = l_cWhere + " AND ( case_log_opnd_date > '01-01-"+string(l_nYear)+" 00:00:00.000' ) " +& 
											 " AND ( case_log_opnd_date < '"+l_cToday+" 23:59:59.999' ) " 
				i_cSubTitle = "From:  01-01-" + string(l_nYear)+" To: " + l_cToday
				
			CASE "MTD"
				l_dFirstDate = Date( string(l_nMonth)+"-01-"+string(l_nYear) )
				l_dLastDate = l_dtToday
				
				l_cWhere = l_cWhere + " AND ( case_log_opnd_date > '"+string(l_nMonth)+"-01-"+string(l_nYear)+" 00:00:00.000' ) " +& 
											 " AND ( case_log_opnd_date < '"+l_cToday+" 23:59:59.999' ) "
				i_cSubTitle = "From:  " + string(l_nMonth) + "-01-"+string(l_nYear) + " To: " + l_cToday
				
			CASE "WEEK"
				l_nDayNumber = DAYNUMBER(l_dtToday)
		
				CHOOSE CASE l_nDayNumber
					CASE 1
						l_dFirstDate = l_dtToday
						l_dLastDate = RelativeDate(l_dtToday, 6 )
					CASE 2
						l_dFirstDate = RelativeDate(l_dtToday, -1)
						l_dLastDate = RelativeDate(l_dtToday, 5 )
					CASE 3
						l_dFirstDate = RelativeDate(l_dtToday, -2)
						l_dLastDate = RelativeDate(l_dtToday, 4 )
					CASE 4
						l_dFirstDate = RelativeDate(l_dtToday, -3)
						l_dLastDate = RelativeDate(l_dtToday, 3 )
					CASE 5
						l_dFirstDate = RelativeDate(l_dtToday, -4)
						l_dLastDate = RelativeDate(l_dtToday, 2 )
					CASE 6
						l_dFirstDate = RelativeDate(l_dtToday, -5)
						l_dLastDate = RelativeDate(l_dtToday, 1 )
					CASE 7
						l_dFirstDate = RelativeDate(l_dtToday, -6)
						l_dLastDate = l_dtToday
					
				END CHOOSE		
				
				l_cWhere = l_cWhere + " AND ( case_log_opnd_date > '"+string(l_dFirstDate)+" 00:00:00.000' ) " +& 
											 " AND ( case_log_opnd_date < '"+string(l_dLastDate)+" 23:59:59.999' ) " 
				
				i_cSubTitle = "From: "+ string(l_dFirstDate)+"  To: "+string(l_dLastDate)
				
			CASE "TODAY"
				l_dFirstDate = l_dtToday
				l_dLastDate = l_dtToday
			
				l_cWhere = l_cWhere + " AND (case_log_opnd_date > '"+string(l_dFirstDate)+" 00:00:00.000' ) " + &
											 " AND (case_log_opnd_date < '"+string(l_dLastDate)+" 23:59:59.999' ) "
				i_cSubTitle = "From: "+string(l_dFirstDate)+"  To: "+string(l_dLastDate)
				
			CASE "RANGE"
				em_from.GetData(l_dFirstDate)
				em_to.GetData(l_dLastDate)
				l_cWhere = l_cWhere + " AND (case_log_opnd_date > '"+string(l_dFirstDate)+" 00:00:00.000' ) " + &
											 " AND (case_log_opnd_date < '"+string(l_dLastDate)+" 23:59:59.999') "
				i_cSubTitle = "From: "+string(l_dFirstDate)+"  To: "+string(l_dLastDate)
						
		END CHOOSE
		
	END CHOOSE
	
	//Set the date instance variables
	i_dtFromDate = l_dFirstDate
	i_dtToDate = l_dLastDate
	
	PCCA.parm[1] = l_cWhere
	l_cParm = PCCA.parm[1]
	
	// Determine which report to run
	CHOOSE CASE i_cReport
		CASE 'd_csr_activity_report'
			CHOOSE CASE i_cReportBy
				CASE 'case_log_case_rep'
					dw_print_supervisor_report.fu_Swap("d_csr_activity_caserep", c_IgnoreChanges, &
							dw_print_supervisor_report.c_Default)
				CASE 'case_log_taken_by'
					dw_print_supervisor_report.fu_Swap("d_csr_activity_takenby", c_IgnoreChanges, &
							dw_print_supervisor_report.c_Default)
				END CHOOSE
		CASE 'd_open_case_levels'
			CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
				CASE 'case_log_case_rep'
					dw_print_supervisor_report.fu_swap("d_open_case_rep", c_IgnoreChanges, &
							 dw_print_supervisor_report.c_Default)
				CASE 'case_log_taken_by'
					dw_print_supervisor_report.fu_swap("d_open_taken_by", c_IgnoreChanges, &
							 dw_print_supervisor_report.c_Default)
				END CHOOSE
		CASE 'd_csr_aging'
			CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
				CASE 'case_log_case_rep'
					dw_print_supervisor_report.fu_swap("d_csr_aging_case_rep", c_IgnoreChanges, &
							dw_print_supervisor_report.c_Default)
				CASE 'case_log_taken_by'
					dw_print_supervisor_report.fu_swap("d_csr_aging_taken_by", c_IgnoreChanges, &
							dw_print_supervisor_report.c_Default)
			END CHOOSE
		CASE 'd_master_vs_indiv'
			CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
				CASE 'case_log_case_rep'
					dw_print_supervisor_report.fu_swap("d_linked_case_rep", c_IgnoreChanges, &
							dw_print_supervisor_report.c_Default)
				CASE 'case_log_taken_by'
					dw_print_supervisor_report.fu_swap("d_linked_case_taken", c_IgnoreChanges, &
							dw_print_supervisor_report.c_Default)
			END CHOOSE
			
		CASE 'd_open_cases_by_csr'
			//-----------------------------------------------------------------------------------------------------------------------------------
			// JWhite Added 8.29.2005 - Adding the option to let the Open Case by CSR be run by Owner as well as Taken By
			//-----------------------------------------------------------------------------------------------------------------------------------
			CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
				CASE 'case_log_case_rep'
					dw_print_supervisor_report.fu_swap('d_open_cases_by_csr_owner', c_IgnoreChanges, dw_print_supervisor_report.c_Default)
				CASE 'case_log_taken_by'
					dw_print_supervisor_report.fu_swap('d_open_cases_by_csr', c_IgnoreChanges, dw_print_supervisor_report.c_Default)
			END CHOOSE



	END CHOOSE
	
	l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
	
	CHOOSE CASE i_cReport
		CASE 'd_open_cases_by_csr'
			dw_print_supervisor_report.SetTransObject(SQLCA)
			
			IF UPPERBOUND(i_cUserArr) > 1 THEN
				// Should not get here, but handle it just in case
				messagebox(gs_AppName,'This report can only be run on one user at a time.')
			ELSE
				l_cUser = i_cUserArr[1]
				//-----------------------------------------------------------------------------------------------------------------------------------
				// JWhite Added 8.29.2005 - Adding the option to let the Open Case by CSR report run by Owner as well as Taken By
				//-----------------------------------------------------------------------------------------------------------------------------------
				CHOOSE CASE w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cReportBy
					CASE 'case_log_case_rep'
						l_nReportRows = dw_print_supervisor_report.Retrieve(l_cLogin, l_cUser)
					CASE 'case_log_taken_by'
						l_nReportRows = dw_print_supervisor_report.Retrieve(l_cLogin, l_cUser)
				END CHOOSE
			END IF

			
		CASE 'd_master_vs_indiv'
			// Retrieve the report for linked cases
			l_dtFirstDate = DateTime( l_dFirstDate, Time( "00:00:00.000" ) )
			l_dtLastDate = DateTime( l_dLastDate, Time( "23:59:59.999" ) )
			
			//Set the instance variables for the view window retrieve
			i_dtFirstDate = l_dtFirstDate
			i_dtLastDate = l_dtLastDate
			
			l_nReportRows = dw_print_supervisor_report.Retrieve( l_dtFirstDate, l_dtLastDate, i_cUserArr, l_cLogin )
			
			//Resort and recalc groups
			dw_print_supervisor_report.Sort( )
			dw_print_supervisor_report.GroupCalc( )
			
		CASE ELSE
	
			// Set the new select statement on the Print Report window to be used to determine if there are records to view
			dw_print_supervisor_report.SetTransObject(SQLCA)
			
			l_cOldSelect = dw_print_supervisor_report.GetSQLSelect()
			// Check for OrderBy Clause
			l_nPos = POS(l_cOldSelect,'ORDER BY')
			IF l_nPos > 0 THEN
				//break out order by to be added to end of new select statement
				l_cOrderBy = MID(l_cOldSelect, l_nPos )
				l_cOldSelect = MID(l_cOldSelect, 1, l_nPos - 1)
			END IF
			
			l_cNewSelect = l_cOldSelect + ' ' + l_cWhere + ' ' + l_cOrderBy
			
			dw_print_supervisor_report.SetSQLSelect(l_cNewSelect)
			
			// Retrieve the report
			l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
			
			l_nReportRows = dw_print_supervisor_report.Retrieve(l_cLogin,w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.i_cSubtitle)
		
		END CHOOSE
	
	IF ISVALID(w_performance_stats) THEN
		CLOSE(w_performance_stats)
	END IF
	
	// If no rows on the Print Report window, then there is nothing to view
	IF l_nReportRows > 0 OR w_supervisor_portal.i_cShowBlankReport = "Y" THEN
		IF l_nReportRows <= 0 AND w_supervisor_portal.i_cShowBlankReport = "Y" THEN
			messagebox(gs_AppName,'No data to report on.')
		END IF
		
		FWCA.MGR.fu_openwindow(w_performance_stats,-1,l_cWhere)
	ELSE
		messagebox(gs_AppName,'No data to report on.')
		dw_print_supervisor_report.SetSQLSelect(l_cOldSelect)
	END IF
	

end event

type dw_report_list from u_dw_std within u_performance
integer x = 14
integer y = 1000
integer width = 3003
integer height = 540
integer taborder = 0
string dataobject = "d_report_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

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
//  Purpose: To allow the user to select their report
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/18/00 C. Jackson  Original Version
//  05/04/01 C. Jackson  Add code for new report Open Cases By CSR
//  
//***********************************************************************************************

LONG l_nRow

l_nRow = THIS.GetRow()

IF l_nRow <> 0 THEN
	i_cReport = THIS.GetItemString(l_nRow,'report_dtwndw_frmt_strng')
	
	CHOOSE CASE i_cReport
		CASE 'd_open_cases_by_csr'
			//-----------------------------------------------------------------------------------------------------------------------------------
			// JWhite 8.29.2005 - Changing the Open Cases by CSR report to allow Owner, instead of just Taken By 
			//-----------------------------------------------------------------------------------------------------------------------------------
			rb_owner.Checked = FALSE
			rb_owner.Enabled = TRUE
			rb_takenby.Checked = TRUE
			ddlb_date.Enabled = FALSE
			st_from.Visible = FALSE
			st_to.Visible = FALSE
			em_from.Visible = FALSE
			em_to.Visible = FALSE
			b_calendar_from.Visible = FALSE
			b_calendar_to.Visible = FALSE
			i_cReportBy = 'case_log_taken_by'
		CASE ELSE
			rb_owner.Enabled = TRUE

	END CHOOSE
	i_cDateParms = THIS.GetItemString(l_nRow,'date_parms')
	
	IF i_cDateParms = 'N' THEN
		ddlb_date.Enabled = FALSE
		em_from.Enabled = FALSE
		em_to.Enabled = FALSE
		b_calendar_from.Enabled = FALSE
		b_calendar_to.Enabled = FALSE
	ELSE
		ddlb_date.Enabled = TRUE
		em_from.Enabled = TRUE
		em_to.Enabled = TRUE
		b_calendar_from.Enabled = TRUE
		b_calendar_to.Enabled = TRUE
	END IF

	m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
	m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE

END IF
end event

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

type st_3 from statictext within u_performance
integer x = 14
integer y = 936
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report to View:"
boolean focusrectangle = false
end type

type b_calendar_to from commandbutton within u_performance
boolean visible = false
integer x = 2789
integer y = 892
integer width = 110
integer height = 80
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
//  10/11/00 C. Jackson  Original Version
//  5/22/2002 K. Claver  Changed messageboxes to display stopsign.
//
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = w_supervisor_portal.X + PARENT.X + THIS.X
l_nY = w_supervisor_portal.Y + PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX - 820 )
l_cY = String( l_nY + l_nHeight + 466 )

//Only one button(calendar) so open the calendar window
l_cCalendarDate = em_to.Text
IF l_cCalendarDate = 'none' OR l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT.GetParent() )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid date set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dtToDate = l_dtCalendarDate

IF em_from.Text = '00/00/0000' THEN
	messagebox(gs_AppName,'A From date is required', StopSign!, OK!)
	em_from.SetFocus()
END IF
IF i_dtFromDate > i_dtToDate THEN
	messagebox(gs_AppName,'To date must be greater than From date', StopSign!, OK!)
	em_to.SetFocus()
ELSE
	//Add the date to the datawindow
	em_to.Text = string(l_dtCalendarDate)
END IF

end event

type b_calendar_from from commandbutton within u_performance
boolean visible = false
integer x = 2789
integer y = 784
integer width = 110
integer height = 80
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
//  10/18/00 C. Jackson  Original Version
//  01/17/01 C. Jackson  Change position of From button calendar (SCR 1367)
//  05/09/02 C. Jackson  Get To Date before comparing to From Date (SCR 3045)
//  5/22/2002 K. Claver  Changed messagebox to display stopsign.
//
//***********************************************************************************************

Date l_dtCalendarDate
String l_cCalendarDate, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight, l_nWidth

//Get the button's dimensions to position the calendar window
l_nX = w_supervisor_portal.X + PARENT.X + THIS.X
l_nY = w_supervisor_portal.Y + PARENT.Y + THIS.Y
l_nHeight = THIS.Height
l_cX = String( l_nX - 750 )
l_cY = String( l_nY + l_nHeight + 466 )

l_cCalendarDate = em_from.Text
IF l_cCalendarDate = 'none' OR l_cCalendarDate = "00/00/0000" THEN
	l_cCalendarDate = STRING(Today())
END IF

l_cParm = l_cCalendarDate +"&"+l_cX+"&"+l_cY 

//open the calendar window
OpenWithParm( w_calendar, l_cParm , PARENT.GetParent() )

//Get the date passed back
l_cCalendarDate = Message.StringParm

//If it's not a valid set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtCalendarDate = Date( Message.StringParm )
ELSE
	SetNull( l_dtCalendarDate )
END IF

i_dtFromDate = l_dtCalendarDate
i_dtToDate = DATE(em_to.Text)

IF i_dtToDate < i_dtFromDate THEN
	messagebox(gs_AppName,'From Date must be less than To Date', StopSign!, OK!)
	em_from.SetFocus()
ELSE
	//Add the date to the datawindow
	em_from.Text = string(l_dtCalendarDate)
	
	//Move the cursor to the next field
	em_to.SetFocus()

END IF


end event

type st_2 from statictext within u_performance
integer x = 14
integer y = 764
integer width = 315
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report By:"
boolean focusrectangle = false
end type

type rb_takenby from radiobutton within u_performance
integer x = 681
integer y = 832
integer width = 343
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Taken By"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: to get the report by parameter
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/18/00 C. Jackson  Original Version
//
//**********************************************************************************************

i_cReportBy = "case_log_taken_by"
end event

type rb_owner from radiobutton within u_performance
integer x = 110
integer y = 832
integer width = 462
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current Owner"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: to get the report by parameter
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/18/00 C. Jackson  Original Version
//
//**********************************************************************************************

i_cReportBy = "case_log_case_rep"
end event

type st_1 from statictext within u_performance
integer x = 1335
integer y = 776
integer width = 320
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date Type:"
boolean focusrectangle = false
end type

type st_to from statictext within u_performance
boolean visible = false
integer x = 2286
integer y = 900
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
string text = "To:"
boolean focusrectangle = false
end type

type st_from from statictext within u_performance
boolean visible = false
integer x = 2213
integer y = 792
integer width = 169
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From:"
boolean focusrectangle = false
end type

type em_to from editmask within u_performance
boolean visible = false
integer x = 2391
integer y = 884
integer width = 379
integer height = 96
integer taborder = 90
integer textsize = -10
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

type em_from from editmask within u_performance
boolean visible = false
integer x = 2391
integer y = 776
integer width = 379
integer height = 96
integer taborder = 80
integer textsize = -10
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

type ddlb_date from dropdownlistbox within u_performance
integer x = 1335
integer y = 840
integer width = 814
integer height = 572
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"YTD (Year to Date)","MTD (Month to Date)","This Week (Sun-Sat)","Today (12:00 am-12:00)","Specify Date Range"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;//*********************************************************************************************
//
//  Event:   selectionchanged
//  Purpose: Determine date for reporting
//  
//  Date     Develop     Description
//  -------- ----------- ----------------------------------------------------------------------
//  10/18/00 C. Jackson  Original Version
//
//*********************************************************************************************


CHOOSE CASE Index
	CASE 1
		// YTD
		i_cDateType = "YTD"
		em_from.Visible = FALSE
		st_from.Visible = FALSE
		b_calendar_from.Visible = FALSE
		em_to.Visible = FALSE
		st_to.Visible = FALSE
		b_calendar_TO.Visible = FALSE
		
	CASE 2
		// MTD
		i_cDateType = "MTD"
		em_from.Visible = FALSE
		st_from.Visible = FALSE
		b_calendar_from.Visible = FALSE
		em_to.Visible = FALSE
		st_to.Visible = FALSE
		b_calendar_TO.Visible = FALSE
		
	CASE 3
		// THIS WEEK
		i_cDateType = "WEEK"
		em_from.Visible = FALSE
		st_from.Visible = FALSE
		b_calendar_from.Visible = FALSE
		em_to.Visible = FALSE
		st_to.Visible = FALSE
		b_calendar_TO.Visible = FALSE
		
	CASE 4
		// TODAY
		i_cDateType = "TODAY"
		em_from.Visible = FALSE
		st_from.Visible = FALSE
		b_calendar_from.Visible = FALSE
		em_to.Visible = FALSE
		st_to.Visible = FALSE
		b_calendar_TO.Visible = FALSE
		
	CASE 5
		// SPECIFY RANGE
		i_cDateType = "RANGE"
		em_from.Visible = TRUE
		st_from.Visible = TRUE
		b_calendar_from.Visible = TRUE
		em_to.Visible = TRUE
		st_to.Visible = TRUE
		b_calendar_to.Visible = TRUE
		em_from.SetFocus()
		
END CHOOSE


end event

type dw_csrreport from u_outliner_std within u_performance
integer x = 1719
integer y = 80
integer width = 1289
integer height = 660
integer taborder = 40
borderstyle borderstyle = stylelowered!
integer i_bmpheight = 12
integer i_bmpwidth = 12
end type

event po_pickedrow;call super::po_pickedrow;//**********************************************************************************************
//
//  Event:   po_pickedrow
//  Purpose: To get the row key 
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/13/00 C. Jackson  Original Version
//
//**********************************************************************************************

STRING l_cDeptID[]
LONG l_nLastRow, l_nIndex, l_nRowCount, l_nNumSelected, l_nLvl1Cntr, l_nLvl2Cntr, l_nLevel

l_nLvl1Cntr = 0
l_nLvl2Cntr = 0

l_nLevel = clickedlevel

l_nLastRow = THIS.RowCount()

DO
	//	Check to see if this row is selected
	l_nIndex = fu_HLGetSelectedRow(l_nIndex)

	// If this row is selected
	IF l_nIndex > 0 THEN
		
		// Add it to the row count
		l_nRowCount = l_nRowCount + 1
		
		// Add it to the array
		i_nDelRow = l_nIndex
		i_cDelRowDesc[l_nIndex] = fu_HLGETRowDesc(i_nDelRow)
		
		IF l_nLevel = 1 THEN
			l_nLvl1Cntr ++
			i_cDelRowDesc[l_nLvl1Cntr] = i_cDelRowDesc[l_nIndex]
		ELSE
			l_nLvl2Cntr ++
			i_cDelRowDesc[l_nLvl2Cntr] = i_cDelRowDesc[l_nIndex]
		END IF
		
		// Set up to check the next row
		l_nIndex = l_nIndex + 1
		
		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
		
	END IF
	
	i_nDelSelected = l_nRowCount
	
LOOP UNTIL l_nIndex = 0


end event

type cb_remove from commandbutton within u_performance
integer x = 1390
integer y = 448
integer width = 256
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To remove selected rows from the list
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/18/00 C. Jackson  Original Version
//
//**********************************************************************************************

STRING l_cDeletedKeys[], l_cNextRowDesc, l_cPrevRowDesc
LONG l_nSelectedRow[], l_nLastRow, l_nIndex, l_nNumSelected, l_nRow, l_nLevel
LONG l_nNextRow, l_nPrevRow
	
l_nLastRow = dw_csrreport.RowCount()
l_nIndex = 1

DO
	
	l_nIndex = dw_csrreport.fu_HLGetSelectedRow(l_nIndex)
	IF l_nIndex > 0 THEN
	
		l_nNumSelected = l_nNumSelected + 1

	 	l_nRow = dw_csrreport.fu_HLGetSelectedRow(l_nIndex)
		dw_csrreport.fu_HLGetRowKey(l_nRow, l_cDeletedKeys[])

		l_nLevel = dw_csrreport.fu_HLGetRowLevel(l_nRow)
		
		IF l_nLevel = 2 THEN
			IF l_nLastRow = 2 THEN
				dw_csrreport.fu_HLSetSelectedRow(1)
				l_nRow = 1
			END IF
			// Look at next row and previous rows to see if the dept needs to be removed
			l_cNextRowDesc = dw_csrreport.fu_HLGetRowDesc(l_nRow + 1)

			SELECT count(*) INTO :l_nNextRow
			  FROM cusfocus.cusfocus_user_dept
			 WHERE dept_desc = :l_cNextRowDesc
			 USING SQLCA;

			IF ISNULL(l_cNextRowDesc) OR l_cNextRowDesc = '' THEN
				l_nNextRow = 1
			END IF
			 
			l_cPrevRowDesc = dw_csrreport.fu_HLGetRowDesc(l_nRow - 1)
			 
			SELECT count(*) INTO :l_nPrevRow
			  FROM cusfocus.cusfocus_user_dept
			 WHERE dept_desc = :l_cPrevRowDesc
			 USING SQLCA;
			 
			IF ISNULL(l_cPrevRowDesc) OR l_cPrevRowDesc = '' THEN
				l_nPrevRow = 1
			END IF
			  
			IF l_nPrevRow = 1 THEN
				IF l_nNextRow = 1 THEN
					dw_csrreport.fu_HLSetSelectedRow(l_nRow - 1)
				END IF
			END IF

		END IF

		l_nSelectedRow[l_nNumSelected] = l_nIndex
		
		l_nIndex = l_nIndex + 1

		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
	
	END IF
  
LOOP UNTIL l_nIndex = 0

dw_csrreport.fu_HLDeleteSelectedRows(l_cDeletedKeys[])
	
l_nIndex++

end event

type cb_add from commandbutton within u_performance
integer x = 1390
integer y = 304
integer width = 256
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to move depts and users to 'query' datawindow  
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/16/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING l_cRowDesc, l_cBMP[], l_cDeptID[], l_cUserID[], l_cUserFirstName[], l_cUserLastName[]
STRING l_cNewRowDesc[], l_cUserDept[], l_cFullName[], l_cUserName[], l_cDeptExists[], l_cUserExists[]
LONG l_nIndex1 , l_nIndex2, l_nIndex3, l_nIndex4, l_nLastRow, l_nDeptCount, l_nRtn, l_nDeptRow
S_CSR_INFO l_csr_info

IF i_nLevel = 1 THEN
	// Process Departments
	
	FOR l_nIndex1 = 1 TO i_nNumSelected
		l_cDeptExists[l_nIndex1] = 'FALSE'
		
		// Make sure isn't already on report side before moving
		l_nLastRow = dw_csrreport.RowCount()

		IF l_nLastRow = 0 THEN 
			l_nLastRow = 1
		END IF
		
		FOR l_nIndex2 = 1 TO l_nLastRow
			l_cRowDesc = dw_csrreport.fu_HLGetRowDesc(l_nIndex2)
			IF l_cRowDesc = i_cRowDesc[l_nIndex1] THEN
				l_cDeptExists[l_nIndex1] = 'TRUE'
				CONTINUE
			END IF
			
		NEXT
		
			
		// Get Department ID
		SELECT user_dept_id INTO :l_cDeptID[l_nIndex1]
		  FROM cusfocus.cusfocus_user_dept
		 WHERE dept_desc = :i_cRowDesc[l_nIndex1]
		 USING SQLCA;
		 
		i_dsUsers = CREATE Datastore
		i_dsUsers.DataObject = "d_ds_userdeptlist"
		i_dsUsers.SetTransObject(SQLCA)
		l_nDeptCount = i_dsusers.Retrieve(l_cDeptID[l_nIndex1])
		 
		IF l_cDeptExists[l_nIndex1] = 'FALSE' THEN
		// The Department doesn't already exist, need to add it.

			IF l_nDeptCount = 0 THEN
				l_nRtn = messagebox(gs_AppName,"There are no users in the "+i_cRowDesc[l_nIndex1]+&
						" department on which to report.")
			ELSE
				dw_csrreport.fu_HLInsertRow(1, i_cRowDesc[l_nIndex1], i_cRowDesc[l_nIndex1], &
					l_cDeptID[l_nIndex1], "", "smallminus.bmp", &
					"smallplus.bmp", 1)
				
			END IF					
		
		END IF
		
		// Now process the users under the department
		
		IF l_nDeptCount <> 0 THEN
			// There are users in the department, process them...
			FOR l_nIndex3 = 1 TO l_nDeptCount
				l_cUserID[l_nIndex3] = i_dsUsers.GetItemString(l_nIndex3,'user_id')
				l_cUserFirstName[l_nIndex3] = i_dsUsers.GetItemString(l_nIndex3,'user_first_name')
				l_cUserLastName[l_nIndex3] = i_dsUsers.GetItemString(l_nIndex3,'user_last_name')
				l_cBMP[l_nIndex3] = i_dsUsers.GetItemString(l_nIndex3,'out_of_office_bmp')
				l_cNewRowDesc[l_nIndex3] = l_cUserLastName[l_nIndex3]+', '+l_cUserFirstName[l_nIndex3]
				
				// Loop through users on the right to see if there is a match
				FOR l_nIndex4 = 1 TO l_nLastRow
					l_cRowDesc = dw_csrreport.fu_HLGetRowDesc(l_nIndex4)
					IF l_cRowDesc = l_cNewRowDesc[l_nIndex3] THEN
						l_cNewRowDesc[l_nIndex3] = 'EXISTS'
						CONTINUE
					END IF
			
				NEXT
				
				IF l_cNewRowDesc[l_nIndex3] <> UPPER('Exists') THEN
						dw_csrreport.fu_HLInsertRow(2, l_cNewRowDesc[l_nIndex3], l_cNewRowDesc[l_nIndex3], &
									l_cUserID[l_nIndex3],l_cDeptID[l_nIndex1],l_cBMP[l_nIndex3],l_cBMP[l_nIndex3], 1)
									
									
				END IF


			NEXT
				
		dw_csrreport.fu_HLInsertSort()				
		dw_csrreport.fu_HLExpand(2)				
		
		END IF

		
	NEXT
	
ELSE
	// Level 2 - Process Users
	FOR l_nIndex1 = 1 TO i_nNumSelected
		l_cDeptExists[l_nIndex1] = 'FALSE'
		l_cUserExists[l_nIndex1] = 'FALSE'
		
		l_csr_info = w_supervisor_portal.fw_GetCSRInfo(i_cRowDesc[l_nIndex1])
		l_cFullName[l_nIndex1] = l_csr_info.user_last_name + ', ' + l_csr_info.user_first_name
		l_cUserID[l_nIndex1] = l_csr_info.user_id
		l_cDeptID[l_nIndex1] = l_csr_info.user_dept_id
		
		// Get bitmap for this user
		SELECT out_of_office_bmp INTO :l_cBMP[l_nIndex1]
		  FROM cusfocus.cusfocus_user
		 WHERE user_id = :l_csr_info.user_id
		 USING SQLCA;
		 
		// Get Department Name
		SELECT dept_desc INTO :l_cUserDept[l_nIndex1]
		  FROM cusfocus.cusfocus_user_dept
		 WHERE user_dept_id = :l_cDeptID[l_nIndex1]
		 USING SQLCA;
		 
		l_cUserName[l_nIndex1] = l_csr_info.user_last_name + ', ' + l_csr_info.user_first_name
		 
		// Make sure Department isn't already on report side before moving
		l_nLastRow = dw_csrreport.RowCount()

		IF l_nLastRow = 0 THEN 
			l_nLastRow = 1
		END IF
		
		// Make sure the user is not already on this list
		FOR l_nIndex2 = 1 TO l_nLastRow
			l_cRowDesc = dw_csrreport.fu_HLGetRowDesc(l_nIndex2)
			
			IF l_cRowDesc = l_cUserDept[l_nIndex1] THEN
				l_cDeptExists[l_nIndex1] = 'TRUE'

				CONTINUE
			END IF
			IF l_cRowDesc = l_cUserName[l_nIndex1] THEN
				l_cUserExists[l_nIndex1] = 'TRUE'
				CONTINUE
			END IF
			
		NEXT

		IF l_cDeptExists[l_nIndex1] = 'FALSE' THEN
			// Add Department to the list

			dw_csrreport.fu_HLInsertRow(1, l_cUserDept[l_nIndex1], l_cUserDept[l_nIndex1], &
									l_cDeptID[l_nIndex1], "", "smallminus.bmp", "smallplus.bmp", 1)
		END IF
		
		IF l_cUserExists[l_nIndex1] = 'FALSE' THEN
			// Add User under the department

			dw_csrreport.fu_HLInsertRow(2, l_cUserName[l_nIndex1], l_cUserName[l_nIndex1], &
					l_cUserID[l_nIndex1],l_cDeptID[l_nIndex1],l_cBMP[l_nIndex1],l_cBMP[l_nIndex1], 1)
									
		END IF
		
	NEXT

	dw_csrreport.fu_HLInsertSort()
	dw_csrreport.fu_HLExpand(2)

END IF

DESTROY i_dsUsers


end event

type dw_csrlist from u_outliner_std within u_performance
integer x = 27
integer y = 84
integer width = 1289
integer height = 660
integer taborder = 10
string dragicon = "contactperson.ico"
borderstyle borderstyle = stylelowered!
integer i_bmpheight = 12
integer i_bmpwidth = 12
end type

event po_pickedrow;call super::po_pickedrow;//**********************************************************************************************
//
//  Event:   po_pickedrow
//  Purpose: To get the row key 
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/13/00 C. Jackson  Original Version
//
//**********************************************************************************************

STRING l_cDeptID[]
LONG l_nLastRow, l_nIndex, l_nRowCount, l_nNumSelected, l_nLvl1Cntr, l_nLvl2Cntr

l_nLvl1Cntr = 0
l_nLvl2Cntr = 0

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
		i_cRowDesc[l_nIndex] = fu_HLGETRowDesc(i_nSelectedRow)
		IF i_nLevel = 1 THEN
			l_nLvl1Cntr ++
			i_cRowDesc[l_nLvl1Cntr] = i_cRowDesc[l_nIndex]
		ELSE
			l_nLvl2Cntr ++
			i_cRowDesc[l_nLvl2Cntr] = i_cRowDesc[l_nIndex]
		END IF
		
		// Set up to check the next row
		l_nIndex = l_nIndex + 1
		
		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
		
	END IF
	
	i_nNumSelected = l_nRowCount
	
LOOP UNTIL l_nIndex = 0


end event

