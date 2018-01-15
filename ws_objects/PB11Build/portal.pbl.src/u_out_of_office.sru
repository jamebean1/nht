$PBExportHeader$u_out_of_office.sru
$PBExportComments$Out of Office User Object
forward
global type u_out_of_office from u_container_std
end type
type st_route from statictext within u_out_of_office
end type
type dw_routedetails from u_dw_std within u_out_of_office
end type
type cb_edit from commandbutton within u_out_of_office
end type
type cb_add from commandbutton within u_out_of_office
end type
type cb_remove from commandbutton within u_out_of_office
end type
type dw_outofofficedetails from u_dw_std within u_out_of_office
end type
type st_1 from statictext within u_out_of_office
end type
type dw_csrlist from u_outliner_std within u_out_of_office
end type
type gb_out from groupbox within u_out_of_office
end type
end forward

global type u_out_of_office from u_container_std
integer width = 3040
integer height = 1712
st_route st_route
dw_routedetails dw_routedetails
cb_edit cb_edit
cb_add cb_add
cb_remove cb_remove
dw_outofofficedetails dw_outofofficedetails
st_1 st_1
dw_csrlist dw_csrlist
gb_out gb_out
end type
global u_out_of_office u_out_of_office

type variables
STRING	i_cSuperDept
STRING	i_cFirstName
STRING   i_cLastName
STRING   i_cFullName
STRING   i_cOutUserID
STRING   i_cSuperID
STRING   i_cDeptID

BOOLEAN  i_bUserSelected = FALSE

LONG     i_nRtn
LONG     i_nOutlinerRow
LONG     i_nExpandedRows[]
LONG     i_nCounter = 0
end variables

forward prototypes
public subroutine fu_refresh ()
end prototypes

public subroutine fu_refresh ();
end subroutine

on u_out_of_office.create
int iCurrent
call super::create
this.st_route=create st_route
this.dw_routedetails=create dw_routedetails
this.cb_edit=create cb_edit
this.cb_add=create cb_add
this.cb_remove=create cb_remove
this.dw_outofofficedetails=create dw_outofofficedetails
this.st_1=create st_1
this.dw_csrlist=create dw_csrlist
this.gb_out=create gb_out
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_route
this.Control[iCurrent+2]=this.dw_routedetails
this.Control[iCurrent+3]=this.cb_edit
this.Control[iCurrent+4]=this.cb_add
this.Control[iCurrent+5]=this.cb_remove
this.Control[iCurrent+6]=this.dw_outofofficedetails
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_csrlist
this.Control[iCurrent+9]=this.gb_out
end on

on u_out_of_office.destroy
call super::destroy
destroy(this.st_route)
destroy(this.dw_routedetails)
destroy(this.cb_edit)
destroy(this.cb_add)
destroy(this.cb_remove)
destroy(this.dw_outofofficedetails)
destroy(this.st_1)
destroy(this.dw_csrlist)
destroy(this.gb_out)
end on

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: Initialization
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/19/20 C. Jackson  Original Version
//  10/30/01 C. Jackson  Add 'Active' <> 'N' into department outliner
//**********************************************************************************************

STRING l_cDeptName, l_cKeys[], l_cSuperLogin, l_cDeptID
LONG   l_nRow, l_nLevels, l_nCounter, l_nDeptRow


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
//// Set the options for dw_csrlist level 1
//dw_csrlist.fu_HLRetrieveOptions(1, &
//		"group.bmp", &
//		"group.bmp", &
//		"cusfocus.cusfocus_user_dept.user_dept_id", & 
//		" ", &
//		"cusfocus.cusfocus_user_dept.dept_desc ", &
//		"cusfocus.cusfocus_user_dept.dept_desc ", &
//		"cusfocus.cusfocus_user_dept", & 
//		"cusfocus.cusfocus_user_dept.active <> 'N'", & 
//		dw_csrlist.c_KeyString)
//
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

dw_csrlist.fu_HLOptions (dw_csrlist.c_DrillDownOnClick + &
	dw_csrlist.c_HideBoxes  + dw_csrlist.c_RetrieveAsNeeded )
	
// get the supervisor dept
l_cSuperLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
SELECT user_dept_id INTO :l_cDeptID
  FROM cusfocus.cusfocus_user
 WHERE user_id = :l_cSuperLogin
 USING SQLCA;

//Scroll to the supervisors department by default
l_nDeptRow = dw_csrlist.fu_HLFindRow(l_cDeptID, 1)

dw_csrlist.fu_HLSetSelectedRow(l_nDeptRow)

IF NOT ISNULL(l_cDeptID) OR l_cDeptID <> '' THEN
	dw_csrlist.fu_HLExpandBranch()
END IF
	

// Disable the command buttons by default
cb_add.Enabled = FALSE
cb_remove.Enabled = FALSE
cb_edit.Enabled = FALSE

// Get the Supervisor Department
i_cSuperID = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT user_dept_id INTO :i_cSuperDept
  FROM cusfocus.cusfocus_user
 WHERE user_id = :i_cSuperID
 USING SQLCA;
 
//Get the Department Name
SELECT dept_desc INTO :l_cDeptName
  FROM cusfocus.cusfocus_user_dept
 WHERE user_dept_id = :i_cSuperDept
 USING SQLCA;
 
//Initialize the resize service
THIS.of_SetResize( TRUE )

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( dw_csrlist, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( dw_outofofficedetails, THIS.inv_resize.FIXEDRIGHT)
	THIS.inv_resize.of_Register( dw_routedetails, THIS.inv_resize.FIXEDRIGHT)
	THIS.inv_resize.of_Register( gb_out, THIS.inv_resize.FIXEDRIGHT )
	THIS.inv_resize.of_Register( cb_add, THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( cb_edit, THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( cb_remove, THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( st_route, THIS.inv_resize.FIXEDRIGHT)
END IF
end event

type st_route from statictext within u_out_of_office
integer x = 1312
integer y = 876
integer width = 1733
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Routing Properties"
boolean focusrectangle = false
end type

type dw_routedetails from u_dw_std within u_out_of_office
integer x = 1266
integer y = 948
integer width = 1733
integer height = 420
integer taborder = 0
string dataobject = "d_route_detail"
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
//  09/20/00 C. Jackson  Original Version
//	 8/22/2001 K. Claver  Added c_NoEnablePopup constant.
//
//**********************************************************************************************

fu_SetOptions (SQLCA, c_NullDW, c_Default + c_ShowEmpty + c_HideHighlight + c_NoEnablePopup)
end event

type cb_edit from commandbutton within u_out_of_office
integer x = 2565
integer y = 1548
integer width = 320
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Edit"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: open the w_out_of_office window for editing
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/20/00 C. Jackson  Original Version
//
//***********************************************************************************************

LONG   l_nAssigned, l_nIndex, l_nOutConfidLevel

// Get the security for selected CSR
SELECT usr_confidentiality_level INTO :l_nOutConfidLevel
  FROM cusfocus.cusfocus_user
 WHERE user_id = :i_cOutUserID
 USING SQLCA;
 
// Check to see if the selected CSR has cases routed to them
SELECT count(*) INTO :l_nAssigned
  FROM cusfocus.out_of_office
 WHERE assigned_to_user_id = :i_cOutUserID
 USING SQLCA;
 
IF w_supervisor_portal.i_nSuperConfidLevel < l_nOutConfidLevel THEN
	messagebox(gs_AppName,'You do not have the authority to edit Out of Office properties for '+i_cFullName+'.')
ELSE

	FWCA.MGR.fu_OpenWindow(w_out_of_office, i_cFullName+':'+i_cOutUserID)
END IF


end event

type cb_add from commandbutton within u_out_of_office
integer x = 1682
integer y = 1548
integer width = 320
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Set"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to remove the enter from the out of office table
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/27/00 C. Jackson  Original Version
//  04/05/01 C. Jackson  Set mdi Title to Out of Office if the marked out user is the logged in user
//                       (SCR 1408)
//  5/29/2002 K. Claver  Moved enabling of the buttons to after all other processing to prevent
//								 a select error(SCR 3113)
//
//***********************************************************************************************

STRING l_cNewKey, l_cSupervisor, l_cKeys[]
LONG   l_nRtn, l_nRow, l_nAssigned, l_nSelectedRow, l_nIndex, l_nCounter, l_nRowCount
LONG   l_nExpandStatus, l_nExpandedRows[], l_nExpandCounter, l_nLevel, l_nIndex1, l_nOutConfidLevel
DATETIME l_dtCreateDate

// Get the security for selected CSR
SELECT usr_confidentiality_level INTO :l_nOutConfidLevel
  FROM cusfocus.cusfocus_user
 WHERE user_id = :i_cOutUserID
 USING SQLCA;
 
// Check to see if the selected CSR has cases routed to them
SELECT count(*) INTO :l_nAssigned
  FROM cusfocus.out_of_office
 WHERE assigned_to_user_id = :i_cOutUserID
 USING SQLCA;
 
IF l_nAssigned > 0 THEN
	l_nRtn = messagebox(gs_AppName,i_cFullName+' is being routed cases, do you wish to continue?', Question!, YesNo!)
	IF l_nRtn <> 1 THEN
		RETURN
	END IF
END IF

 
IF w_supervisor_portal.i_nSuperConfidLevel < l_nOutConfidLevel THEN
	messagebox(gs_AppName,'You do not have the authority to set Out of Office properties for '+i_cFullName+'.')
ELSE


	DELETE cusfocus.out_of_office
	 WHERE out_user_id = :i_cOutUserId
	 USING SQLCA;
	 
	l_cSupervisor = OBJCA.WIN.fu_GetLogin(SQLCA)
	l_dtCreateDate = w_supervisor_portal.fw_gettimestamp()
	l_cNewKey = w_supervisor_portal.fw_getkeyvalue('out_of_office')
	
	INSERT INTO cusfocus.out_of_office (out_of_office_id, out_user_id, updated_by, updated_timestamp)
	VALUES (:l_cNewKey, :i_cOutUserID, :l_cSupervisor, :l_dtCreateDate)
	USING SQLCA;									 
	
	UPDATE cusfocus.cusfocus_user
		SET out_of_office_bmp = 'out_of_office.bmp'
	 WHERE user_id = :i_cOutUserID
	 USING SQLCA;
	
	// Reset the detail datawindow
	l_nRtn = dw_outofofficedetails.Retrieve(i_cOutUserID)
	IF l_nRtn > 0 THEN
		gb_out.Text = 'Out of Office Properties for '+i_cFullName
	END IF
	IF l_nRtn = 0 THEN
		dw_outofofficedetails.fu_SetOptions(SQLCA, dw_outofofficedetails.c_nullDW, dw_outofofficedetails.c_ShowEmpty + &
														dw_outofofficedetails.c_NoEnablePopup)
	END IF

	// Refresh the outliner Datawindow
	// Loop through level 1 records to see what is currently expanded
	l_nRowCount = dw_csrlist.RowCount()
	
	l_nExpandCounter = 0
	
	// Loop through level 1 records to see what is currently expanded
	l_nRowCount = dw_csrlist.RowCount()
	
	l_nExpandCounter = 0

	FOR l_nIndex = 1 TO l_nRowCount
		l_nLevel = dw_csrlist.fu_HLGetRowLevel(l_nIndex)
		IF l_nLevel = 1 THEN
			l_nExpandStatus = dw_csrlist.GetItemNumber(l_nIndex,"expanded")
			IF l_nExpandStatus = 1 THEN
				l_nExpandCounter++
				l_nExpandedRows[l_nExpandCounter] = l_nIndex
			END IF
		END IF
			
	NEXT
	
	// Get my current row
	l_nRow = dw_csrlist.fu_HLFindRow(i_cOutUserID,2)
	
	l_nSelectedRow = dw_csrlist.GetRow()
	
	dw_csrlist.SetRedraw(FALSE)
	dw_csrlist.Hide()

	dw_csrlist.fu_HLCollapseBranch()
	dw_csrlist.fu_HLRefresh(2, dw_csrlist.c_ReselectRows)
	dw_csrlist.fu_HLGetRowKey(l_nSelectedRow, l_cKeys[])
	l_nIndex = UpperBound (l_cKeys[])
	
	// Expand all previously expanded branches
	FOR l_nIndex1 = 1 to l_nExpandCounter
		dw_csrlist.fu_HLSetSelectedRow(l_nExpandedRows[l_nIndex1])
		dw_csrlist.ScrollToRow(l_nExpandedRows[l_nIndex1])
		dw_csrlist.fu_HLExpandBranch()
	NEXT

	FOR l_nCounter = 1 to l_nIndex
		l_nRow = dw_csrlist.fu_HLFindRow(l_cKeys[l_nCounter], l_nCounter)

		IF l_nCounter < l_nIndex THEN
			dw_csrlist.i_ClickedRow = l_nRow
			dw_csrlist.fu_HLExpandBranch()
		ELSE
			dw_csrlist.fu_HLSetSelectedRow(l_nRow)
			dw_csrlist.ScrollToRow(l_nRow)
		END IF
		dw_csrlist.fu_HLExpandBranch()
	NEXT
	
	dw_csrlist.Show()
	dw_csrlist.SetRedraw(TRUE)
	
END IF

// Refresh other objects in supervisor portal that show Out of Office status
w_supervisor_portal.tab_1.tabpage_reassign_cases.uo_reassigncases.fu_Refresh()
w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.fu_Refresh()
w_supervisor_portal.tab_1.tabpage_critical_cases.uo_criticalcases.fu_Refresh()

// If the user marked out of office is the logged in user, then update the mdi frame title
IF i_cOutUserID = l_cSupervisor THEN
	IF ISVALID(w_mdi) THEN
		w_mdi.Title = w_mdi.title + ' *** Out of Office'
		m_mdi.m_file.m_outofoffice.Check()
	END IF
END IF

IF w_supervisor_portal.i_nSuperConfidLevel >= l_nOutConfidLevel THEN
	// Enable/disable buttons accordingly
	cb_Add.Enabled = FALSE
	cb_remove.Enabled = TRUE
	cb_edit.Enabled = TRUE
END IF

end event

type cb_remove from commandbutton within u_out_of_office
integer x = 2112
integer y = 1548
integer width = 320
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Remove"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To remove out of office records for selected user
//  
//  Date
//  -------- ----------- -----------------------------------------------------------------------
//  09/27/00 C. Jackson  Original Version
//  04/05/01 C. Jackson  Set mdi Title to Noraml if the marked out user is the logged in user
//                       (SCR 1408)
//  5/29/2002 K. Claver  Moved enabling of the buttons to after all other processing to prevent
//								 a select error(SCR 3113)
//  06/26/02 C. Jackson  Add security check
//
//**********************************************************************************************

STRING l_cBMP, l_cRouteID, l_cKeys[], l_cMdiTitle, l_cSupervisor
LONG l_nRtn, l_nRow, l_nRouteCount, l_nOutCount, l_nIndex, l_nCounter, l_nSelectedRow, l_nIndex1
LONG l_nExpandCounter, l_nExpandedRows[], l_nRowCount, l_nLevel, l_nExpandStatus, l_nPos
LONG l_nOutConfidLevel


// Get the security for selected CSR
SELECT usr_confidentiality_level INTO :l_nOutConfidLevel
  FROM cusfocus.cusfocus_user
 WHERE user_id = :i_cOutUserID
 USING SQLCA;
 
 IF SQLCA.SQLCODE = 0  THEN

	IF w_supervisor_portal.i_nSuperConfidLevel < l_nOutConfidLevel THEN
		messagebox(gs_AppName,'You do not have the authority to remove Out of Office properties for '+i_cFullName+'.')
	ELSE
	
		SELECT assigned_to_user_id INTO :l_cRouteID FROM cusfocus.out_of_office
		where out_user_id = :i_cOutUserID
		USING SQLCA;
		
		
		 
		DELETE cusfocus.out_of_office
		 WHERE out_user_id = :i_cOutUserID
		 USING SQLCA;
		
		// Check to see if the 'route to' csr needs to have their bitmap changed or not
		IF NOT ISNULL(l_cRouteID) AND l_cRouteID <> '' THEN
			SELECT count(*) INTO :l_nRouteCount
			FROM cusfocus.out_of_office
		  WHERE assigned_to_user_id = :l_cRouteID
		  USING SQLCA;
		  
		  // what is current bitmap for this person?
		  SELECT out_of_office_bmp INTO :l_cBMP
			 FROM cusfocus.cusfocus_user
			WHERE user_id = :l_cRouteID
			USING SQLCA;
			
			IF l_nRouteCount = 0 AND (l_cBMP = 'routed.bmp' OR l_cBMP = 'route_to.bmp') THEN
				UPDATE cusfocus.cusfocus_user 
					SET out_of_office_bmp = 'person.bmp'
				 WHERE user_id = :l_cRouteID
				 USING SQLCA;
				 
			END IF
		  
		END IF
		 
		SETNULL(l_nRouteCount) 
		SETNULL(l_cBMP)
		
		//Check to see if cases are being routed to this CSR or not
		SELECT count(*) INTO :l_nRouteCount
		  FROM cusfocus.out_of_office
		 WHERE assigned_to_user_id = :i_cOutUserID
		 USING SQLCA;
		
		IF l_nRouteCount > 0 THEN
			l_cBMP = 'route_to.bmp'
		ELSE
			l_cBMP = 'person.bmp'
		END IF
		 
		UPDATE cusfocus.cusfocus_user
			SET out_of_office_bmp = :l_cBMP
		 WHERE user_id = :i_cOutUserID
		 USING SQLCA;
		 
		// Reset the detail datawindow
		l_nRtn = dw_outofofficedetails.Retrieve(i_cOutUserID)
		IF l_nRtn = 0 THEN
			gb_out.Text = 'Out of Office Properties'
			dw_outofofficedetails.fu_SetOptions(SQLCA, dw_outofofficedetails.c_nullDW, dw_outofofficedetails.c_ShowEmpty + &
															dw_outofofficedetails.c_NoEnablePopup)
		END IF
		
		// Refresh the outliner Datawindow
		// Loop through level 1 records to see what is currently expanded
		l_nRowCount = dw_csrlist.RowCount()
		
		l_nExpandCounter = 0
		
		// Loop through level 1 records to see what is currently expanded
		l_nRowCount = dw_csrlist.RowCount()
		
		l_nExpandCounter = 0
		
		FOR l_nIndex = 1 TO l_nRowCount
			l_nLevel = dw_csrlist.fu_HLGetRowLevel(l_nIndex)
			IF l_nLevel = 1 THEN
				l_nExpandStatus = dw_csrlist.GetItemNumber(l_nIndex,"expanded")
				IF l_nExpandStatus = 1 THEN
					l_nExpandCounter++
					l_nExpandedRows[l_nExpandCounter] = l_nIndex
				END IF
			END IF
				
		NEXT
		
		// Get my current row
		l_nRow = dw_csrlist.fu_HLFindRow(i_cOutUserID,2)
		
		l_nSelectedRow = dw_csrlist.GetRow()
		
		dw_csrlist.SetRedraw(FALSE)
		dw_csrlist.Hide()
		
		dw_csrlist.fu_HLCollapseBranch()
		dw_csrlist.fu_HLRefresh(2, dw_csrlist.c_ReselectRows)
		dw_csrlist.fu_HLGetRowKey(l_nSelectedRow, l_cKeys[])
		l_nIndex = UpperBound (l_cKeys[])
		
		// Expand all previously expanded branches
		FOR l_nIndex1 = 1 to l_nExpandCounter
			dw_csrlist.fu_HLSetSelectedRow(l_nExpandedRows[l_nIndex1])
			dw_csrlist.ScrollToRow(l_nExpandedRows[l_nIndex1])
			dw_csrlist.fu_HLExpandBranch()
		NEXT
		
		FOR l_nCounter = 1 to l_nIndex
			l_nRow = dw_csrlist.fu_HLFindRow(l_cKeys[l_nCounter], l_nCounter)
		
			IF l_nCounter < l_nIndex THEN
				dw_csrlist.i_ClickedRow = l_nRow
				dw_csrlist.fu_HLExpandBranch()
			ELSE
				dw_csrlist.fu_HLSetSelectedRow(l_nRow)
				dw_csrlist.ScrollToRow(l_nRow)
			END IF
			dw_csrlist.fu_HLExpandBranch()
		NEXT
		
		dw_csrlist.Show()
		dw_csrlist.SetRedraw(TRUE)
		
		// Refresh other objects on Supervisor Portal that reflect out of office status
		w_supervisor_portal.tab_1.tabpage_reassign_cases.uo_reassigncases.fu_Refresh()
		w_supervisor_portal.tab_1.tabpage_performance_statistics.uo_performance.fu_Refresh()
		w_supervisor_portal.tab_1.tabpage_critical_cases.uo_criticalcases.fu_Refresh()
		
		// If the user marked out of office is the logged in user, then update the mdi frame title
		l_cSupervisor = OBJCA.WIN.fu_GetLogin(SQLCA)
		
		IF i_cOutUserID = l_cSupervisor THEN
			IF ISVALID(w_mdi) THEN
				l_cMdiTitle = w_mdi.Title
				l_nPos =  POS(l_cMdiTitle,' *** Out of Office')
				l_cMdiTitle = MID(l_cMdiTitle, 1, l_nPos - 1)
				w_mdi.Title = l_cMdiTitle
			END IF
		END IF
		
		// Enable/disable buttons accordingly
		cb_Add.Enabled = TRUE
		cb_remove.Enabled = FALSE
		cb_edit.Enabled = FALSE
		
	END IF
	
end if
end event

type dw_outofofficedetails from u_dw_std within u_out_of_office
integer x = 1307
integer y = 284
integer width = 1632
integer height = 296
integer taborder = 20
string dataobject = "d_out_of_office_details"
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: set options on the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/20/00 C. Jackson  Original Version
//	 8/22/2001 K. Claver  Added c_NoEnablePopup constant.
//
//**********************************************************************************************

fu_SetOptions (SQLCA, c_NullDW, c_Default + c_ShowEmpty + c_NoEnablePopup)
end event

type st_1 from statictext within u_out_of_office
integer x = 23
integer y = 28
integer width = 201
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "CSR~'s:"
boolean focusrectangle = false
end type

type dw_csrlist from u_outliner_std within u_out_of_office
integer x = 37
integer y = 104
integer width = 1184
integer height = 1540
integer taborder = 10
borderstyle borderstyle = stylelowered!
integer i_bmpheight = 12
integer i_bmpwidth = 12
end type

event po_pickedrow;call super::po_pickedrow;//***********************************************************************************************
//
//  Event:   po_PickedRow
//  Purpose: Get the row key of the selected row to process the Case reassign
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/14/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING	l_cKeys[], l_cRowDesc, l_cRouteID, l_cRouteFirst, l_cRouteLast
LONG		l_nLevel, l_nPos1, l_nReturn, l_nCount, l_nRtn
S_CSR_INFO l_csr_info

dw_outofofficedetails.fu_SetOptions(SQLCA, dw_outofofficedetails.c_nullDW, &
	dw_outofofficedetails.c_ShowEmpty + dw_outofofficedetails.c_EnablePopup + &
	dw_outofofficedetails.c_NoEnablePopup)

// If this event was trigger by another function/event then set defaults.
IF clickedlevel = 2 THEN
	i_nOutlinerRow = clickedrow
	
	i_bUserSelected = TRUE

	// Get the key of the Picked Row and view it's details
	l_cRowDesc = fu_HLGetRowDesc(i_nOutlinerRow)
	l_csr_info = w_supervisor_portal.fw_GetCSRInfo(l_cRowDesc)
	i_cFullName = l_csr_info.user_full_name
	i_cOutUserID = l_csr_info.user_id
	i_cDeptID = l_csr_info.user_dept_id
	
	// Check to see if there is already an Out of Office record to enable/disable buttons
	SELECT count(*) INTO :l_nCount
	  FROM cusfocus.out_of_office
	 WHERE out_user_id = :i_cOutUserID
	 USING SQLCA;
	 
	IF l_nCount > 0 THEN
		cb_add.Enabled = FALSE
		cb_remove.Enabled = TRUE
		cb_edit.Enabled = TRUE
	ELSE
		cb_add.Enabled = TRUE
		cb_remove.Enabled = FALSE
		cb_edit.Enabled = FALSE
	END IF
	 
	dw_outofofficedetails.SetRedraw(FALSE)
	dw_outofofficedetails.Hide()
	dw_routedetails.SetRedraw(FALSE)
	dw_routedetails.Hide()
	l_nRtn = dw_outofofficedetails.Retrieve(i_cOutUserID)
	IF l_nRtn > 0 THEN
		gb_Out.Text = 'Out of Office Properties for '+i_cFullName
	ELSE
		gb_out.Text = 'Out of Office Properties'
	END IF
		
	IF l_nRtn = 0 THEN
		dw_outofofficedetails.fu_SetOptions(SQLCA, dw_outofofficedetails.c_nullDW, dw_outofofficedetails.c_ShowEmpty + &
		dw_outofofficedetails.c_NoEnablePopup)
	END IF
	
	dw_routedetails.SetTrans(SQLCA)
	l_nRtn = dw_routedetails.Retrieve(i_cOutUserID)
	IF l_nRtn > 0 THEN
		st_route.Text = "CSR's with cases routed to " + i_cFullName + ":"
	ELSE
		st_route.Text = 'Routing Properties'
	END IF
	
	// Get Route To CSR info to change title
	SELECT user_first_name, user_last_name INTO :l_cRouteFirst, :l_cRouteLast
	  FROM cusfocus.cusfocus_user
	 WHERE user_id = :i_cOutUserID
	 USING SQLCA;
	 
	IF l_nRtn = 0 THEN
		dw_routedetails.fu_SetOptions(SQLCA, dw_routedetails.c_nullDW, dw_routedetails.c_ShowEmpty + &
		dw_routedetails.c_NoEnablePopup + dw_routedetails.c_HideHighlight)
	END IF
	
	dw_outofofficedetails.Show()
	dw_outofofficedetails.SetRedraw(TRUE)
	dw_routedetails.Show()
	dw_routedetails.SetRedraw(TRUE)
	 
ELSE
	// Level 1
	cb_add.Enabled = FALSE
	cb_remove.Enabled = FALSE
	cb_edit.Enabled = FALSE
	i_bUserSelected = FALSE
	l_nRtn = dw_outofofficedetails.Retrieve('')
	IF l_nRtn = 0 THEN
		dw_outofofficedetails.fu_SetOptions(SQLCA, dw_outofofficedetails.c_nullDW, dw_outofofficedetails.c_ShowEmpty + &
														dw_outofofficedetails.c_NoEnablePopup)
	END IF
END IF


end event

type gb_out from groupbox within u_out_of_office
integer x = 1271
integer y = 196
integer width = 1696
integer height = 416
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Out of Office Properties"
end type

