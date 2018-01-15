$PBExportHeader$w_report_security.srw
$PBExportComments$Report Security Window
forward
global type w_report_security from w_response_std
end type
type cb_report_collapse from u_cb_cancel within w_report_security
end type
type cb_report_expand from u_cb_cancel within w_report_security
end type
type cb_user_collapse from u_cb_cancel within w_report_security
end type
type cb_user_expand from u_cb_cancel within w_report_security
end type
type cb_ok from u_cb_ok within w_report_security
end type
type cb_cancel from u_cb_cancel within w_report_security
end type
type cb_remove from commandbutton within w_report_security
end type
type cb_add from commandbutton within w_report_security
end type
type dw_reportlist from u_outliner_std within w_report_security
end type
type st_2 from statictext within w_report_security
end type
type st_1 from statictext within w_report_security
end type
type dw_csrlist from u_outliner_std within w_report_security
end type
end forward

global type w_report_security from w_response_std
integer width = 2875
integer height = 1964
string title = "Report Security"
cb_report_collapse cb_report_collapse
cb_report_expand cb_report_expand
cb_user_collapse cb_user_collapse
cb_user_expand cb_user_expand
cb_ok cb_ok
cb_cancel cb_cancel
cb_remove cb_remove
cb_add cb_add
dw_reportlist dw_reportlist
st_2 st_2
st_1 st_1
dw_csrlist dw_csrlist
end type
global w_report_security w_report_security

type variables
STRING i_cDeptDesc[]
STRING i_cUserDesc[]
STRING i_cReportUserDesc[]
STRING i_cReportDesc[]
STRING i_cReportUserKeys[]
STRING i_cReportID[]
STRING i_cUserID[]
STRING i_cDelUserID[]
STRING i_cReportUser[]
STRING i_cLogin
STRING i_cDelReportID[]
STRING i_cDelReportUserID[]

LONG i_nDeptCntr
LONG i_nUserCntr
LONG i_nReportCntr
LONG i_nReportUserCntr
LONG i_nDeptListLevel
LONG i_nReportListLevel
LONG i_nReportListRows[]
LONG i_nNumReportSelected
LONG i_nNumDeptSelected
LONG i_nNumUserSelected
LONG i_nNumReportUserSelected
LONG i_nDeleteCount

DATASTORE i_dsUsers
DATASTORE i_dsReportList
DATASTORE i_dsReportSecurity
//??DATASTORE i_dsReportSecurityUsers
//??DATASTORE i_dsReportUsers

BOOLEAN i_bAdd
BOOLEAN i_bDelete
end variables

forward prototypes
public subroutine fu_initialselect ()
end prototypes

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

LONG l_nLastRow, l_nIndex, l_nRowCount

i_nDeptCntr = 0
i_nUserCntr = 0

i_nDeptListLevel = 1

l_nLastRow = dw_csrlist.RowCount()

DO
	//	Check to see if this row is selected
	l_nIndex = dw_csrlist.fu_HLGetSelectedRow(l_nIndex)

	// If this row is selected
	IF l_nIndex > 0 THEN
		
		// Add it to the row count
		l_nRowCount = l_nRowCount + 1
		
		// Add it to the array
		IF i_nDeptListLevel = 1 THEN
			i_nDeptCntr ++
			i_cDeptDesc[l_nIndex] = dw_csrlist.fu_HLGETRowDesc(l_nIndex)
			i_cDeptDesc[i_nDeptCntr] = i_cDeptDesc[l_nIndex]
		ELSE
			i_nUserCntr ++
			i_cUserDesc[l_nIndex] = dw_csrlist.fu_HLGetRowDesc(l_nIndex)
			i_cUserDesc[i_nUserCntr] = i_cUserDesc[l_nIndex]
		END IF
		
		// Set up to check the next row
		l_nIndex = l_nIndex + 1
		
		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
		
	END IF

	if i_nDeptListLevel = 1 THEN
		i_nNumDeptSelected = l_nRowCount
	ELSE
		i_nNumUserSelected = l_nRowCount
	END IF
	
LOOP UNTIL l_nIndex = 0


end subroutine

on w_report_security.create
int iCurrent
call super::create
this.cb_report_collapse=create cb_report_collapse
this.cb_report_expand=create cb_report_expand
this.cb_user_collapse=create cb_user_collapse
this.cb_user_expand=create cb_user_expand
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cb_remove=create cb_remove
this.cb_add=create cb_add
this.dw_reportlist=create dw_reportlist
this.st_2=create st_2
this.st_1=create st_1
this.dw_csrlist=create dw_csrlist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_report_collapse
this.Control[iCurrent+2]=this.cb_report_expand
this.Control[iCurrent+3]=this.cb_user_collapse
this.Control[iCurrent+4]=this.cb_user_expand
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_remove
this.Control[iCurrent+8]=this.cb_add
this.Control[iCurrent+9]=this.dw_reportlist
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.dw_csrlist
end on

on w_report_security.destroy
call super::destroy
destroy(this.cb_report_collapse)
destroy(this.cb_report_expand)
destroy(this.cb_user_collapse)
destroy(this.cb_user_expand)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cb_remove)
destroy(this.cb_add)
destroy(this.dw_reportlist)
destroy(this.st_2)
destroy(this.st_1)
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
//  03/29/01 C. Jackson  Remove fu_HLExpand for report list datawindow (SCR 1570)
//
//***********************************************************************************************

STRING l_cDeptID, l_cReportName, l_cReportID[], l_cUserID[], l_cReportSecurityID
STRING l_cFirstName, l_cLastName, l_cFullName, l_cDeptDesc, l_cUserAndDept
LONG l_nDeptRow, l_nNumReports, l_nIndex, l_nSecurityCount, l_nReportRow, l_nIndex1, ll_user_row, ll_user_rowcount


i_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

i_nDeleteCount = 0

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

IF UPPER(i_cLogin) <> 'CFADMIN' THEN
// 9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//IF UPPER(i_cLogin) <> 'SYSADMIN' THEN
	
	dw_csrlist.fu_HLRetrieveOptions(2, &
			"person.bmp", &
			"person.bmp", &
			"cusfocus.cusfocus_user.user_id", & 
			"cusfocus.cusfocus_user_dept.user_dept_id", & 
			"cusfocus.cusfocus_user.user_last_name + ', ' + cusfocus.cusfocus_user.user_first_name", &
			"cusfocus.cusfocus_user.user_last_name + ', ' + cusfocus.cusfocus_user.user_first_name", &
			"cusfocus.cusfocus_user", & 
			"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
			"cusfocus.cusfocus_user.active <> 'N' " + &
			"AND cusfocus.cusfocus_user.user_id <> '" + i_cLogin + "'" , &
			dw_csrlist.c_KeyString)
			
ELSE
	dw_csrlist.fu_HLRetrieveOptions(2, &
			"person.bmp", &
			"person.bmp", &
			"cusfocus.cusfocus_user.user_id", & 
			"cusfocus.cusfocus_user_dept.user_dept_id", & 
			"cusfocus.cusfocus_user.user_last_name + ', ' + cusfocus.cusfocus_user.user_first_name", &
			"cusfocus.cusfocus_user.user_last_name + ', ' + cusfocus.cusfocus_user.user_first_name", &
			"cusfocus.cusfocus_user", & 
			"cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id AND " + &
			"cusfocus.cusfocus_user.active <> 'N'", &
			dw_csrlist.c_KeyString)

END IF
			
		
dw_csrlist.fu_HLCreate(SQLCA,2)

dw_reportlist.fu_HLOptions(dw_reportlist.c_MultiSelect + dw_reportlist.c_ShowLines)

dw_reportlist.fu_HLInsertOptions(1, dw_reportlist.c_KeyString + dw_reportlist.c_SortString + dw_reportlist.c_ShowLines)
dw_reportlist.fu_HLInsertOptions(2, dw_reportlist.c_KeyString + dw_reportlist.c_SortString)

dw_reportlist.fu_HLCreate(SQLCA, 2)

i_dsReportList = CREATE Datastore
IF UPPER(i_cLogin) = 'CFADMIN' THEN
// 9.1.2006 JWhite SQL2005 Mandates change from sysadmin to cfadmin
//IF UPPER(i_cLogin) = 'SYSADMIN' THEN
	i_dsReportList.DataObject = "d_ds_report_list_sysadmin"
	i_dsReportList.SetTransObject(SQLCA)
	l_nNumReports = i_dsReportList.Retrieve()
ELSE
	i_dsReportList.DataObject = "d_ds_report_list"
	i_dsReportList.SetTransObject(SQLCA)
	l_nNumReports = i_dsReportList.Retrieve(i_cLogin)
END IF

FOR l_nIndex = 1 TO l_nNumReports
	// Get Report Title
	l_cReportName = i_dsReportList.GetItemString(l_nIndex,'report_name')
	l_cReportID[l_nIndex] = i_dsReportList.GetItemString(l_nIndex,'report_id')
	dw_reportlist.fu_HLInsertRow(1, l_cReportName, l_cReportName, l_cReportID[l_nIndex], "", "report.bmp", "report.bmp", 1)
NEXT

dw_reportlist.fu_HLInsertSort()

// Get a list of users
i_dsUsers = CREATE DataStore
i_dsUsers.DataObject = 'd_ds_userlist'
i_dsUsers.SetTransObject(SQLCA)
ll_user_rowcount = i_dsUsers.Retrieve()

// Now add in existing report security
i_dsReportSecurity = CREATE DataStore
i_dsReportSecurity.DataObject = 'd_ds_report_security'
i_dsReportSecurity.SetTransObject(SQLCA)
l_nSecurityCount = i_dsReportSecurity.Retrieve()

FOR l_nIndex = 1 TO l_nSecurityCount
	l_cReportSecurityID = i_dsReportSecurity.GetItemString(l_nIndex,'report_id')

	l_cUserID[l_nIndex] = i_dsReportSecurity.GetItemString(l_nIndex,'user_id')
	
	ll_user_row = i_dsUsers.Find("user_id = '" + l_cUserID[l_nIndex] + "'", 1, ll_user_rowcount)
	IF ll_user_row > 0 THEN
		l_cFirstName = i_dsUsers.object.user_first_name[ll_user_row]
		l_cLastName = i_dsUsers.object.user_last_name[ll_user_row]
		l_cDeptDesc = i_dsUsers.object.dept_desc[ll_user_row]
	ELSE
		l_cFirstName = ''
		l_cLastName = ''
		l_cDeptDesc = ''
	END IF
//?? replaced with datastore
//	SELECT user_first_name, user_last_name, user_dept_id INTO :l_cFirstName, :l_cLastName, :l_cDeptID
//	  FROM cusfocus.cusfocus_user
//	 WHERE user_id = :l_cUserID[l_nIndex]
//	 USING SQLCA;
//	 
//	SELECT dept_desc INTO :l_cDeptDesc
//	  FROM cusfocus.cusfocus_user_dept
//	 WHERE user_dept_id = :l_cDeptID
//	 USING SQLCA;
	 
	l_cFullName = l_cLastName + ', ' + l_cFirstName
	l_cUserAndDept = l_cFullName + ' - ' + l_cDeptDesc
	
	l_nReportRow = dw_reportlist.fu_HLFindRow(l_cReportSecurityID, 1)	

	FOR l_nIndex1 = 1 TO l_nNumReports
		IF l_cReportID[l_nIndex1] = l_cReportSecurityID THEN
			
			// Do not display the logged in supervisors name under the report
			IF l_cUserID[l_nIndex] <> i_cLogin THEN
				dw_reportlist.fu_HLInsertRow( 2, l_cUserAndDept, l_cUserAndDept, &
							l_cUserID[l_nIndex], l_cReportSecurityID, 'person.bmp', 'person.bmp', 1)
							
			END IF
			
		END IF
		
	NEXT
			 
NEXT
		
dw_reportlist.fu_HLInsertSort()
		
//dw_reportlist.fu_HLExpand(2)

// Now add in existing report security
//??i_dsReportUsers = CREATE DataStore
//??i_dsReportUsers.DataObject = 'd_ds_report_users'
//??i_dsReportUsers.SetTransObject(SQLCA)
//??i_nReportUserCntr = i_dsReportUsers.Retrieve()

// get the supervisor dept
i_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
ll_user_row = i_dsUsers.Find("user_id = '" + i_cLogin + "'", 1, ll_user_rowcount)
IF ll_user_row > 0 THEN
	l_cDeptID = i_dsUsers.object.user_dept_id[ll_user_row]
ELSE
	l_cDeptID = ''
END IF
//?? replaced with datastore
//SELECT user_dept_id INTO :l_cDeptID
//  FROM cusfocus.cusfocus_user
// WHERE user_id = :i_cLogin
// USING SQLCA;
 
l_nDeptRow = dw_csrlist.fu_HLFindRow(l_cDeptID, 1)

dw_csrlist.fu_HLSetSelectedRow(l_nDeptRow)

IF NOT ISNULL(l_cDeptID) AND l_cDeptID <> '' THEN
	dw_csrlist.fu_HLExpandBranch()
	fu_initialselect()
END IF

//Initialize the resize service
THIS.of_SetResize( TRUE )

THIS.inv_resize.of_SetOrigSize (THIS.width, THIS.height)

THIS.inv_resize.of_SetMinSize (THIS.width, THIS.height)

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( dw_csrlist , THIS.inv_resize.SCALEBOTTOM )
	THIS.inv_resize.of_Register( cb_add , THIS.inv_resize.FIXEDBOTTOM )
	THIS.inv_resize.of_Register( cb_remove , THIS.inv_resize.FIXEDBOTTOM )
END IF

end event

type cb_report_collapse from u_cb_cancel within w_report_security
integer x = 2290
integer y = 1632
integer width = 343
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Collapse All"
end type

event clicked;call super::clicked;dw_reportlist.fu_hlcollapseall( )
end event

type cb_report_expand from u_cb_cancel within w_report_security
integer x = 1797
integer y = 1632
integer width = 320
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Expand All"
end type

event clicked;call super::clicked;dw_reportlist.fu_hlexpandall( )
end event

type cb_user_collapse from u_cb_cancel within w_report_security
integer x = 658
integer y = 1632
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Collapse All"
end type

event clicked;call super::clicked;dw_csrlist.fu_hlcollapseall( )
end event

type cb_user_expand from u_cb_cancel within w_report_security
integer x = 165
integer y = 1632
integer width = 320
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Expand All"
end type

event clicked;call super::clicked;dw_csrlist.fu_hlexpandall( )
end event

type cb_ok from u_cb_ok within w_report_security
integer x = 1093
integer y = 1756
integer width = 320
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;call super::clicked;//********************************************************************************************
//
//  Event:   clicked
//  Purpose: to save changes and exit
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  12/01/00 c. jackson  Original Version
//  12/19/00 C. Jackson  Add re-retrieve of w_supervisor_portal report datawindows with new info
//  03/29/01 C. Jackson  Add confirmation message if nothing has changed (SCR 1566)
//
//********************************************************************************************

LONG l_nLastRow, l_nIndex1, l_nIndex2, l_nLevel, l_nPos, l_nSecurityCount, l_nIndex
LONG l_nLastSelected, l_nRtn
STRING l_cReportName , l_cNewKey, l_cUserName, l_cUserID[]
STRING l_cUserAndDept
DATETIME l_dtCreateDate
S_CSR_INFO l_csr_info
//
//IF i_bAdd THEN
//	
//	FOR l_nIndex1 = 1 TO i_nNumReportSelected
//	
//		// Get Report ID for insert
//		SELECT report_id INTO :i_cReportID[l_nIndex1]
//		  FROM cusfocus.reports
//		 WHERE report_name = :i_cReportDesc[l_nIndex1]
//		 USING SQLCA;
//		
//		l_nLastRow = dw_reportlist.RowCount()
//	
//		FOR l_nIndex2 = 1 TO l_nLastRow
//			l_nLevel = dw_reportlist.fu_HLGetRowLevel(l_nIndex2)
//			
//			IF l_nLevel = 1 THEN
//				l_cReportName = dw_reportlist.fu_HLGetRowDesc(l_nIndex2)
//				
//			ELSE
//				l_cUserAndDept = dw_reportlist.fu_HLGetRowDesc(l_nIndex2)
//				l_nPos = POS(l_cUserAndDept,' - ')
//				l_cUserName = MID(l_cUserAndDept, 1, l_nPos)
//				
//				l_dtCreateDate = w_supervisor_portal.fw_gettimestamp()
//				l_cNewKey = w_supervisor_portal.fw_getkeyvalue('report_security')
//				
//				l_csr_info = w_supervisor_portal.fw_GetCSRInfo(l_cUserName)
//				l_cUserID[l_nIndex2] = l_csr_info.user_id
//				
//				// Get Report ID
//				SELECT report_id INTO :i_cReportID[l_nIndex1]
//				  FROM cusfocus.reports
//				 WHERE report_name = :l_cReportName
//				 USING SQLCA;
//				 
//				// Make sure this row doesn't already exist before inserted
//				SELECT count(*) INTO :l_nSecurityCount
//				  FROM cusfocus.report_security
//				 WHERE report_id = :i_cReportID[l_nIndex1]
//					AND user_id = :l_cUserID[l_nIndex2]
//				 USING SQLCA;
//				 
//				IF l_nSecurityCount = 0 THEN
//				 
//					INSERT INTO cusfocus.report_security (report_security_id, report_id, user_id, updated_by, updated_timestamp)
//							VALUES (:l_cNewKey, :i_cReportID[l_nIndex1], :l_cUserID[l_nIndex2], :i_cLogin, :l_dtCreateDate) USING SQLCA;
//							
//				END IF			
//				
//			END IF
//			
//		NEXT
//	
//	NEXT
//	
//	
//	IF SQLCA.SQLCode <> 0 THEN
//		messagebox(gs_AppName,'Unable to update report security, please see your System Administrator.')
//		i_bAdd = FALSE
//		RETURN
//	END IF
//	
//	
//ELSEIF i_bDelete THEN
//		
//		IF i_nReportListLevel = 2 THEN
//			
//		l_nLastRow = UPPERBOUND(i_nReportListRows[])
//		l_nLastSelected = i_nReportListRows[l_nLastRow]
//		dw_reportlist.fu_HLSetSelectedRow(l_nLastSelected - 1)
//		
//			FOR l_nIndex = 1 TO i_nDeleteCount
//				
//			  DELETE cusfocus.report_security
//				WHERE report_id = :i_cDelReportID[l_nIndex]
//				  AND user_id = :i_cDelReportUserID[l_nIndex]
//				USING SQLCA;
//			
//			NEXT 
//			
//		ELSE
//			
//			FOR l_nIndex = 1 TO i_nNumReportSelected
//				
//				i_dsReportSecurityUsers = CREATE DataStore
//				i_dsReportSecurityUsers.DataObject = 'd_ds_report_security_users'
//				i_dsReportSecurityUsers.SetTransObject(SQLCA)
//				i_nNumReportUserSelected = i_dsReportSecurityUsers.Retrieve(i_cReportID[l_nIndex]) 
//				
//				FOR l_nIndex1 = 1 TO i_nDeleteCount
//
//					DELETE cusfocus.report_security
//					 WHERE report_id = :i_cDelReportID[l_nIndex1]
//						AND user_id = :i_cDelReportUserID[l_nIndex1]
//					 USING SQLCA;
//				 
//				NEXT
//				
//			NEXT
//			
//		END IF
//		
//		IF SQLCA.SQLCode <> 0 THEN
//			messagebox(gs_AppName,'Unable to remove selected users, please see your System Administrator')
//			i_bDelete = FALSE
//		END IF
//		
//	ELSE
//		l_nRtn = messagebox(gs_AppName,'No changes made, do you wish to close?', Question!, YesNo!)
//		IF l_nRtn = 1 THEN
//			CLOSE(PARENT)
//			RETURN 0
//		ELSE
//			RETURN
//		END IF
//			
//		
//END IF

l_nRtn = i_dsReportSecurity.update( )
IF l_nRtn <> 1 THEN
	messagebox(gs_AppName,'Error updating Report Security - ' + SQLCA.sqlerrtext )
END IF
	
IF ISVALID(w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list) THEN
	w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.SetTransObject(SQLCA)
	w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.Retrieve(i_cLogin)
END IF
	
IF ISVALID(w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.dw_report_list) THEN	
	w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.dw_report_list.SetTransObject(SQLCA)
	w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.dw_report_list.Retrieve(i_cLogin)
END IF

DESTROY i_dsReportList
DESTROY i_dsUsers
DESTROY i_dsReportSecurity

CLOSE(PARENT)

end event

type cb_cancel from u_cb_cancel within w_report_security
integer x = 1449
integer y = 1756
integer width = 320
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;call super::clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to close window without saving changes
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/01/00 c. jackson  Original Version
//
//***********************************************************************************************

DESTROY i_dsReportList
DESTROY i_dsUsers
DESTROY i_dsReportSecurity


CLOSE(PARENT)


end event

type cb_remove from commandbutton within w_report_security
integer x = 1285
integer y = 492
integer width = 320
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<< Remove"
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

STRING l_cUserFullName, l_cUserLastName, l_cUserFirstName, l_cRowKeys[]
LONG l_nIndex, l_nIndex1,  l_nPos, l_nRtn, l_nDeleteCounter, l_nSelectedRow, l_nLastRow, l_nNextRow
LONG l_nLevel, l_nDelRow, l_nDelRows[], ll_user_row, ll_security_row

IF i_nReportListLevel = 2 THEN

	FOR l_nIndex = 1 TO i_nNumReportSelected
		
		// Get UserName from Row Description
		l_nPos = POS(i_cReportUserDesc[l_nIndex],' - ')
		l_cUserFullName = MID(i_cReportUserDesc[l_nIndex], 1, l_nPos - 1)
		l_nPos = POS(l_cUserFullName,', ')
		l_cUserLastName = MID(l_cUserFullName, 1, l_nPos - 1)
		l_cUserFirstName = MID(l_cUserFullName, l_nPos + 2)
		
//?? replaced with datastore
//		// Get userid from the cusfocus_user table
//		SELECT user_id INTO :i_cUserID[l_nIndex]
//		  FROM cusfocus.cusfocus_user
//		 WHERE user_first_name = :l_cUserFirstName
//			AND user_last_name = :l_cUserLastName
//		 USING SQLCA;
		 
		// Get Report ID 
		
		dw_reportlist.fu_HLGetRowKey(i_nReportListRows[l_nIndex],i_cReportUserKeys[])
		
		i_cReportID[l_nIndex] = i_cReportUserKeys[1]
		
		ll_user_row = i_dsUsers.Find("user_last_name = '" + l_cUserLastName + "' and user_first_name = '" + l_cUserFirstName + "'", 1, i_dsUsers.RowCount())
		IF ll_user_row > 0 THEN
			i_cUserID[l_nIndex] = i_dsUsers.object.user_id[ll_user_row]
		ELSE
			i_cUserID[l_nIndex] = ''
		END IF
		
		ll_security_row = i_dsReportSecurity.Find("user_id = '" + i_cUserID[l_nIndex] + "' and report_id = '" + i_cReportID[l_nIndex] + "'", 1, i_dsReportSecurity.RowCount())
		
		IF ll_security_row > 0 THEN
			i_dsReportSecurity.deleterow( ll_security_row )
		END IF
		
		// Put ids in array of cb_ok clicked
		i_nDeleteCount ++
		i_cDelReportID[i_nDeleteCount] = i_cReportID[l_nIndex]
		i_cDelReportUserID[i_nDeleteCount] = i_cUserID[l_nIndex]

	NEXT
	
	dw_reportlist.fu_HLDeleteSelectedRows(i_cReportUserKeys[])
	
ELSE
	
	// remove all users for this report? 
	
	l_nRtn = messagebox(gs_AppName,'Would you like to remove all users from the selected reports?', &
			Question!, OKCancel!,1)

	l_nDeleteCounter = 0
	l_nSelectedRow = 1
	
	l_nLastRow = dw_reportlist.RowCount()
	
	DO
		l_nSelectedRow = dw_reportlist.fu_HLGetSelectedRow(l_nSelectedRow)
		
		// If this row is selected, look at rows under it to see if they are level 2
		IF l_nSelectedRow > 0 THEN
			
			// Increment to the next row
			l_nNextRow = l_nSelectedRow + 1
			
			// Get the level of this row
			l_nLevel = dw_reportlist.fu_HLGetRowLevel(l_nNextRow)
			
			DO WHILE l_nLevel = 2
				
				l_nDeleteCounter ++
				i_nDeleteCount ++
				
				dw_reportlist.fu_HLGetRowKey(l_nNextRow, l_cRowKeys[])
	
				// Put ids in array for cb_ok clicked
				i_cDelReportID[i_nDeleteCount] = l_cRowKeys[1]
				i_cDelReportUserID[i_nDeleteCount] = l_cRowKeys[2]
				
				ll_security_row = i_dsReportSecurity.Find("user_id = '" +l_cRowKeys[2] + "' and report_id = '" +l_cRowKeys[1] + "'", 1, i_dsReportSecurity.RowCount())
				
				IF ll_security_row > 0 THEN
					i_dsReportSecurity.deleterow( ll_security_row )
				END IF
				
				l_nDelRow = dw_reportlist.fu_HLFindRow(l_cRowKeys[2],2)
				
				l_nDelRows[l_nDeleteCounter] = l_nNextRow
				
				l_nNextRow = l_nNextRow + 1
				
				l_nLevel = dw_reportlist.fu_HLGetRowLevel(l_nNextRow)
				
			LOOP
			
			l_nSelectedRow ++
			
			IF l_nSelectedRow > l_nLastRow THEN
				l_nSelectedRow = 0
			END IF
			
		END IF
		
	LOOP UNTIL l_nSelectedRow = 0
	
	FOR l_nIndex = l_nDeleteCounter TO 1 STEP -1
		
		dw_reportlist.fu_HLDeleteRow(l_nDelRows[l_nIndex])
		
	NEXT

END IF

i_bDelete = TRUE


end event

type cb_add from commandbutton within w_report_security
integer x = 1285
integer y = 352
integer width = 320
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add >>"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to move depts and users to 'report' datawindow  
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/16/00 C. Jackson  Original Version
//  07/06/01 C. Jackson  Add DESTROY i_dsUsers
//
//***********************************************************************************************

STRING l_cDeptID[], l_cUserID[], l_cUserFirstName[], l_cUserLastName[], l_cNewRowDesc[]
STRING l_cUserAndDept, l_cDeptDesc[], l_ckey[], l_cUserDept[], l_cFullName[], l_cUserReportDesc, ls_new_key
LONG l_nIndex, l_nIndex1, l_nDeptCount, l_nUserRow, l_nReportCntr, l_nReportUserFound, ll_report_rowcount, ll_report_row, ll_user_row, ll_new_row
S_CSR_INFO l_csr_info
DATETIME l_dtCreateDate


IF i_nDeptListLevel = 0 THEN
	messagebox(gs_AppName, 'Please select a user or department.')
	RETURN
	
ELSE

	IF i_nReportListLevel = 0 THEN
		
		//No reports selected
		messagebox(gs_AppName,'Please select a report.')
		RETURN
		
	ELSEIF i_nReportListLevel = 1 THEN
		
		ll_report_rowcount = i_dsReportList.Rowcount()
		
//??		dw_reportlist.Hide()
		dw_reportlist.SetReDraw(FALSE)
		
		FOR l_nReportCntr = 1 to i_nNumReportSelected

			ll_report_row = i_dsReportList.Find("report_name = '" + i_cReportDesc[l_nReportCntr] + "'", 1, ll_report_rowcount)
			IF ll_report_row > 0 THEN
				i_cReportID[l_nReportCntr] = i_dsReportList.object.report_id[ll_report_row]
			ELSE
				i_cReportID[l_nReportCntr] = ''
			END IF
			
//??? replaced with datastore
//			SELECT report_id INTO :i_cReportID[l_nReportCntr]
//			  FROM cusfocus.reports
//			 WHERE report_name = :i_cReportDesc[l_nReportCntr]
//			 USING SQLCA;
			
			IF i_nDeptListLevel = 1 THEN
				
				// ADD ALL USERS IN THE SPECIFIED DEPARTMENTS
				FOR l_nIndex = 1 TO i_nNumDeptSelected
					// Get Department Info
					i_dsUsers.SetFilter("dept_desc = '" + i_cDeptDesc[l_nIndex] + "'")
					i_dsUsers.Filter()
					l_nDeptCount = i_dsUsers.RowCount()

//?? replaced with datastore
//					SELECT user_dept_id, dept_desc INTO :l_cDeptID[l_nIndex], :l_cDeptDesc[l_nIndex]
//					  FROM cusfocus.cusfocus_user_dept
//					 WHERE dept_desc = :i_cDeptDesc[l_nIndex]
//					 USING SQLCA;
//					 
//					i_dsUsers = CREATE DataStore
//					i_dsUsers.DataObject = 'd_ds_userlist'
//					i_dsUsers.SetTransObject(SQLCA)
//					l_nDeptCount = i_dsUsers.Retrieve(l_cDeptID[l_nIndex])
					
					IF l_nDeptCount <> 0 THEN
						
						// There are users in the Department, process them...
						FOR l_nIndex1 = 1 TO l_nDeptCount
							l_cUserID[l_nIndex1] = i_dsUsers.GetItemString(l_nIndex1,'user_id')
							l_cUserFirstName[l_nIndex1] = i_dsUsers.GetItemString(l_nIndex1,'user_first_name')
							l_cUserLastName[l_nIndex1] = i_dsUsers.GetItemString(l_nIndex1,'user_last_name')
							l_cNewRowDesc[l_nIndex1] = l_cUserLastName[l_nIndex1] + ', '+ l_cUserFirstName[l_nIndex1]
							
						//Check to see if the user has already been added for this report
							dw_reportlist.fu_HLGetRowKey(l_nUserRow,l_ckey[])
							
							l_cUserAndDept = l_cNewRowDesc[l_nIndex1] + ' - ' + i_cDeptDesc[l_nIndex]
							
//??							l_cUserReportDesc = l_cUserAndDept+i_cReportID[l_nReportCntr]
							
							l_nReportUserFound = i_dsReportSecurity.Find("report_id = '" +  i_cReportID[l_nReportCntr] + "' and user_id = '" + l_cUserID[l_nIndex1] + "'", 1, i_dsReportSecurity.RowCount())

//?? replaced with other datastore
//							l_nReportUserFound = i_dsReportUsers.Find("user_dept = '"+l_cUserReportDesc+"'", &
//								1, i_dsReportUsers.RowCount())
								
							IF l_nReportUserFound < 1 THEN
	
								dw_reportlist.fu_HLInsertRow(2,l_cUserAndDept,l_cUserAndDept, &
										l_cUserID[l_nIndex1], i_cReportID[l_nReportCntr],  'person.bmp', 'person.bmp', 1)
										
								// Insert into report security datastore		
								ls_new_key = w_supervisor_portal.fw_getkeyvalue('report_security')
								l_dtCreateDate = w_supervisor_portal.fw_gettimestamp()
								ll_new_row = i_dsReportSecurity.InsertRow(0)
								i_dsReportSecurity.object.report_security_id[ll_new_row] = ls_new_key
								i_dsReportSecurity.object.report_id[ll_new_row] = i_cReportID[l_nReportCntr]
								i_dsReportSecurity.object.user_id[ll_new_row] = l_cUserID[l_nIndex1]
								i_dsReportSecurity.object.updated_by[ll_new_row] = i_cLogin
								i_dsReportSecurity.object.updated_timestamp[ll_new_row] = l_dtCreateDate
							END IF
							
	
							
						NEXT
						
						dw_reportList.fu_HLInsertSort()
						
						dw_reportList.fu_HLExpand(2)
						
					END IF
					
					
				NEXT
				
			ELSE
				
				IF i_nReportListLevel = 2 AND i_nDeptListLevel = 1 THEN
					messagebox(gs_AppName, 'Please select a valid report')
					RETURN
				ELSE
				
					// ADD INDIVIDUALLY SPECIFIED USERS
		
					FOR l_nIndex = 1 TO i_nNumUserSelected
			
						l_csr_info = w_supervisor_portal.fw_GetCSRInfo(i_cUserDesc[l_nIndex])
						l_cFullName[l_nIndex] = l_csr_info.user_last_name + ', ' + l_csr_info.user_first_name
						l_cUserID[l_nIndex] = l_csr_info.user_id
						l_cDeptID[l_nIndex] = l_csr_info.user_dept_id
						
						//Check to see if the user has already been added for this report
							dw_reportlist.fu_HLGetRowKey(l_nUserRow,l_ckey[])
							
						// Get Department Name
						ll_user_row = i_dsUsers.Find("user_dept_id = '" + l_cDeptID[l_nIndex] + "'", 1, i_dsUsers.RowCount())
						IF ll_user_row > 0 THEN
							l_cUserDept[l_nIndex] = i_dsUsers.object.dept_desc[ll_user_row]
						ELSE
							l_cUserDept[l_nIndex] = ''
						END IF

//?? replaced with datastore						
//						SELECT dept_desc INTO :l_cUserDept[l_nIndex]
//						  FROM cusfocus.cusfocus_user_dept
//						 WHERE user_dept_id = :l_cDeptID[l_nIndex]
//						 USING SQLCA;
						 
						l_cUserAndDept = i_cUserDesc[l_nIndex] + ' - ' +l_cUserDept[l_nIndex]
//??						l_cUserReportDesc = l_cUserAndDept+i_cReportID[l_nReportCntr]
						
						l_nReportUserFound = i_dsReportSecurity.Find("report_id = '" +  i_cReportID[l_nReportCntr] + "' and user_id = '" +l_cUserID[l_nIndex] + "'", 1, i_dsReportSecurity.RowCount())

//?? replaced with other datastore						
//						l_nReportUserFound = i_dsReportUsers.Find("user_dept = '"+l_cUserReportDesc+"'", &
//							1, i_dsReportUsers.RowCount())
						
						IF l_nReportUserFound = 0 THEN
							dw_reportlist.fu_HLInsertRow(2, l_cUserAndDept, l_cUserAndDept, &
									l_cUserID[l_nIndex], i_cReportID[l_nReportCntr], 'person.bmp', 'person.bmp', 1)

							// Insert into report security datastore		
							ls_new_key = w_supervisor_portal.fw_getkeyvalue('report_security')
							l_dtCreateDate = w_supervisor_portal.fw_gettimestamp()
							ll_new_row = i_dsReportSecurity.InsertRow(0)
							i_dsReportSecurity.object.report_security_id[ll_new_row] = ls_new_key
							i_dsReportSecurity.object.report_id[ll_new_row] = i_cReportID[l_nReportCntr]
							i_dsReportSecurity.object.user_id[ll_new_row] =l_cUserID[l_nIndex]
							i_dsReportSecurity.object.updated_by[ll_new_row] = i_cLogin
							i_dsReportSecurity.object.updated_timestamp[ll_new_row] = l_dtCreateDate
						END IF
		
						 
					NEXT
					
					dw_reportlist.fu_HLInsertSort()
					
					dw_reportlist.fu_HLExpand(2)
					
				END IF
				
			END IF
			
		NEXT
		
	END IF
	
END IF

i_dsUsers.SetFilter('')
i_dsUsers.Filter()

dw_reportlist.SetReDraw(TRUE)
dw_reportlist.Show()

end event

type dw_reportlist from u_outliner_std within w_report_security
integer x = 1659
integer y = 108
integer width = 1170
integer height = 1492
integer taborder = 10
borderstyle borderstyle = stylelowered!
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

STRING l_cReportKeys[], l_cUserReportDesc
LONG l_nLastRow, l_nIndex, l_nRowCount, l_nNewRow, l_nNextLevel, l_nNextRow, l_nDSRow

i_nReportCntr = 0
i_nReportUserCntr = 0

i_nReportListLevel = clickedlevel

l_nLastRow = THIS.RowCount()

DO
	//	Check to see if this row is selected
	l_nIndex = fu_HLGetSelectedRow(l_nIndex)

	// If this row is selected
	IF l_nIndex > 0 THEN
		
		l_nNextRow = l_nIndex + 1
		
		// Add it to the row count
		l_nRowCount = l_nRowCount + 1
		
		// Add it to the array
		IF i_nReportListLevel = 1 THEN
			
			i_nReportCntr ++
			i_cReportDesc[l_nIndex] = fu_HLGETRowDesc(l_nIndex)
			
			// Description of the selected report
			i_cReportDesc[i_nReportCntr] = i_cReportDesc[l_nIndex]
			
			// Get the report id
			fu_HLGetRowKey(l_nIndex,l_cReportKeys[])
			i_cReportID[i_nReportCntr] = l_cReportKeys[1]
			
			// Get the next row
			l_nNewRow = l_nIndex + 1
			
			// If this is level 2, put into datastore
			l_nNextLevel = fu_HLGetRowLevel(l_nNextRow)
			
			DO WHILE l_nNextLevel = 2
				
				// Get the Description of this row
				i_nReportUserCntr ++
				
				i_cReportUser[i_nReportUserCntr] = fu_HLGetRowDesc(l_nNextRow)
				
				l_nDSRow ++
				
				l_cUserReportDesc = i_cReportUser[i_nReportUserCntr]+i_cReportID[i_nReportCntr]
				
//??				i_dsReportUsers.InsertRow(0)

//??				i_dsReportUsers.SetItem(l_nDSRow,'user_dept',l_cUserReportDesc)
				
				// Set up to check the next row
				l_nNextRow = l_nNextRow + 1
				l_nNextLevel = fu_HLGetRowLevel(l_nNextRow)

			LOOP
			
		ELSE
			i_nReportUserCntr ++
			i_cReportUserDesc[l_nIndex] = fu_HLGETRowDesc(l_nIndex)
			
			// Description of selected user
			i_cReportUserDesc[i_nReportUserCntr] = i_cReportUserDesc[l_nIndex]
			
			// Get the report id
			fu_HLGetRowKey(l_nIndex,l_cReportKeys[])
			i_cReportID[l_nIndex] = l_cReportKeys[1]

			i_nReportListRows[i_nReportUserCntr] = l_nIndex
		END IF
		
		// Set up to check the next row
		l_nIndex = l_nIndex + 1
		
		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
		
	END IF
	
	i_nNumReportSelected = l_nRowCount
	
LOOP UNTIL l_nIndex = 0


end event

type st_2 from statictext within w_report_security
integer x = 1650
integer y = 20
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
string text = "Select Report:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_report_security
integer x = 46
integer y = 20
integer width = 722
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select User  / Department:"
boolean focusrectangle = false
end type

type dw_csrlist from u_outliner_std within w_report_security
integer x = 46
integer y = 108
integer width = 1170
integer height = 1492
integer taborder = 10
string dragicon = "contactperson.ico"
borderstyle borderstyle = stylelowered!
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

LONG l_nLastRow, l_nIndex, l_nRowCount 

i_nDeptCntr = 0
i_nUserCntr = 0

i_nDeptListLevel = clickedlevel

l_nLastRow = THIS.RowCount()

DO
	//	Check to see if this row is selected
	l_nIndex = fu_HLGetSelectedRow(l_nIndex)

	// If this row is selected
	IF l_nIndex > 0 THEN
		
		// Add it to the row count
		l_nRowCount = l_nRowCount + 1
		
		// Add it to the array
		IF i_nDeptListLevel = 1 THEN
			i_nDeptCntr ++
			i_cDeptDesc[l_nIndex] = fu_HLGETRowDesc(l_nIndex)
			i_cDeptDesc[i_nDeptCntr] = i_cDeptDesc[l_nIndex]
		ELSE
			i_nUserCntr ++
			i_cUserDesc[l_nIndex] = fu_HLGetRowDesc(l_nIndex)
			i_cUserDesc[i_nUserCntr] = i_cUserDesc[l_nIndex]
		END IF
		
		// Set up to check the next row
		l_nIndex = l_nIndex + 1
		
		IF l_nIndex > l_nLastRow THEN
			l_nIndex = 0
		END IF
		
	END IF
	
	IF i_nDeptListLevel = 1 THEN
		i_nNumDeptSelected = l_nRowCount
	ELSE
		i_nNumUserSelected = l_nRowCount
	END IF
	
LOOP UNTIL l_nIndex = 0


end event

