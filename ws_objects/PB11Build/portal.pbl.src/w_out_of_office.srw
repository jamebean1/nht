$PBExportHeader$w_out_of_office.srw
$PBExportComments$Out of Office Window
forward
global type w_out_of_office from w_response_std
end type
type cb_clear from commandbutton within w_out_of_office
end type
type st_1 from statictext within w_out_of_office
end type
type dw_setoutofoffice from u_dw_std within w_out_of_office
end type
type dw_csrlist from u_outliner_std within w_out_of_office
end type
type cb_save from u_cb_save within w_out_of_office
end type
type cb_cancel from u_cb_cancel within w_out_of_office
end type
end forward

global type w_out_of_office from w_response_std
integer width = 1774
integer height = 1392
string title = "Set up of Office"
cb_clear cb_clear
st_1 st_1
dw_setoutofoffice dw_setoutofoffice
dw_csrlist dw_csrlist
cb_save cb_save
cb_cancel cb_cancel
end type
global w_out_of_office w_out_of_office

type variables
STRING   i_cRouteUserID
STRING   i_cOldRouteID
STRING   i_cOutUserID
STRING   i_cRouteFirstName
STRING   i_cRouteLastName
STRING   i_cFullName
STRING   i_cClearRoute = ''
STRING   i_cBMP

BOOLEAN  i_bUserSelected = FALSE
BOOLEAN  i_bNewOutOfOffice
BOOLEAN  i_bBadDate = FALSE


end variables

on w_out_of_office.create
int iCurrent
call super::create
this.cb_clear=create cb_clear
this.st_1=create st_1
this.dw_setoutofoffice=create dw_setoutofoffice
this.dw_csrlist=create dw_csrlist
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_clear
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_setoutofoffice
this.Control[iCurrent+4]=this.dw_csrlist
this.Control[iCurrent+5]=this.cb_save
this.Control[iCurrent+6]=this.cb_cancel
end on

on w_out_of_office.destroy
call super::destroy
destroy(this.cb_clear)
destroy(this.st_1)
destroy(this.dw_setoutofoffice)
destroy(this.dw_csrlist)
destroy(this.cb_save)
destroy(this.cb_cancel)
end on

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
// 
//  Event:   pc_setoptions
//  Purpose: Initialization
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/20/00 C. Jackson  Original Version
//  10/30/01 C. Jackson  Add 'Active' <> 'N' into department outliner
//**********************************************************************************************

LONG l_nRetrieved, l_nRow, l_nLevels, l_nCounter, l_nDWRow
STRING l_cKeys[]

title = 'Edit Out of Office for '+i_cFullName

// Is there already a route for this CSR?


SETNULL(i_cClearRoute)

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
		"cusfocus.cusfocus_user.active <> 'N'", & 
		dw_csrlist.c_KeyString + dw_csrlist.c_BMPFromColumn)
		
dw_csrlist.fu_HLCreate(SQLCA,2)							

dw_setoutofoffice.SetTransObject(SQLCA)
l_nRetrieved = dw_setoutofoffice.Retrieve(i_cOutUserID)

// Scroll to the Route To CSR if there is one
l_nDWRow = dw_setoutofoffice.GetRow()
IF l_nDWRow > 0 THEN

	i_cRouteUserID = dw_setoutofoffice.GetItemString(l_nDWRow,'assigned_to_user_id')
	
	IF i_cRouteUserID <> '' AND NOT ISNULL(i_cRouteUserID) THEN
		
		l_nRow = dw_csrlist.fu_HLFindRow(i_cRouteUserID,2)
		
		l_nLevels = dw_csrlist.fu_HLGetRowKey (l_nRow, l_cKeys[])
		
		dw_csrlist.SetRedraw(FALSE)
		dw_csrlist.Hide()
		
		dw_csrlist.fu_HLCollapse (1)
		
		FOR l_nCounter = 1 to l_nLevels
			l_nRow = dw_csrlist.fu_HLFindRow(l_cKeys[l_nCounter], l_nCounter)
			// collapse all subtrees of the current level
			IF l_nCounter > 1 THEN
				dw_csrlist.fu_HLCollapse(l_nCounter+1)
			END IF
			// expand only the appropriate branch
			IF l_nCounter < l_nLevels THEN
				dw_csrlist.i_ClickedRow = l_nRow
				dw_csrlist.fu_HLExpandBranch()
			ELSE
				dw_csrlist.fu_HLSetSelectedRow(l_nRow)
				dw_csrlist.ScrollToRow(l_nRow)
			END IF
		NEXT
		
		dw_csrlist.fu_HLSetSelectedRow (l_nRow)
		
		dw_csrlist.Show()
		dw_csrlist.SetRedraw(TRUE)
		
	ELSE
		dw_setoutofoffice.SetFocus()
		dw_setoutofoffice.SetColumn(4)
		
	END IF
	
END IF

IF l_nRetrieved = 0 THEN
	i_bNewOutOfOffice = TRUE
	
END IF


end event

event pc_setvariables;call super::pc_setvariables;//**********************************************************************************************
//
//  Event:   pc_setvariables
//  Purpose: To get the userid and name out of string_parm
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/20/00 C. Jackson  Original Version
//
//**********************************************************************************************

STRING l_cPassed
LONG   l_nPos

l_cPassed = string_parm

l_nPos = POS(l_cPassed,':')
i_cFullName = TRIM(MID(l_cPassed,1,l_nPos - 1))
i_cOutUserID = TRIM(MID(l_cPassed,l_nPos + 1,l_nPos - 1))



end event

type cb_clear from commandbutton within w_out_of_office
integer x = 1207
integer y = 724
integer width = 494
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear &Routing"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To clear the selected row in the outliner datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/21/00 C. Jackson  Original Version
//
//***********************************************************************************************
LONG l_nDWRow

dw_csrlist.fu_HLClearSelectedRows()

l_nDWRow = dw_setoutofoffice.GetRow()

i_cClearRoute = dw_setoutofoffice.GetItemString(l_nDWRow,'assigned_to_user_id')
dw_setoutofoffice.SetItem(l_nDWRow,'notify','N')

dw_setoutofoffice.SetItem(l_nDWRow,'assigned_to_user_id','')
dw_setoutofoffice.SetItem(l_nDWRow,'reason','')


end event

type st_1 from statictext within w_out_of_office
integer x = 23
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
string text = "Route to CSR:"
boolean focusrectangle = false
end type

type dw_setoutofoffice from u_dw_std within w_out_of_office
integer x = 14
integer y = 880
integer width = 1714
integer height = 220
integer taborder = 20
string dataobject = "d_set_out_of_office"
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
//
//**********************************************************************************************

dw_setoutofoffice.fu_SetOptions( SQLCA, & 
 		dw_setoutofoffice.c_NullDW, & 
 		dw_setoutofoffice.c_NewOK + &
 		dw_setoutofoffice.c_ModifyOK + &
 		dw_setoutofoffice.c_ModifyOnOpen + &
 		dw_setoutofoffice.c_NewModeOnEmpty + &
 		dw_setoutofoffice.c_FreeFormStyle  )
		 


end event

event clicked;call super::clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Verify that a Route To user was selected before the notify check box can be enabled
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/21/00 C. Jackson  Original Version
//
//**********************************************************************************************

STRING l_cColName, l_cRouteUserID, l_cNotify
LONG l_nRow

l_nRow = THIS.GetRow()

l_cNotify = THIS.GetItemString(l_nRow,'notify')

l_cColName = dwo.name
CHOOSE CASE l_cColName
	CASE "notify"
		IF NOT i_bUserSelected THEN
			l_cRouteUserID = THIS.GetItemString(l_nRow,'assigned_to_user_id')
			
			IF i_cOutUserID = l_cRouteUserID THEN
				THIS.SetItem(l_nRow,'Notify','N')
			ELSEIF ISNULL(l_cRouteUserID) THEN
				messagebox(gs_AppName,'A user has not been selected to route cases to...no one to Notify')
			ELSE
				IF l_cNotify = 'Y' THEN
					THIS.SetItem(l_nRow,'Notify','N')
				ELSE
					THIS.SetItem(l_nRow,'Notify','Y')
				END IF
			END IF
			RETURN 1
		END IF
END CHOOSE

RETURN 0


end event

event pcd_savebefore;call super::pcd_savebefore;//***********************************************************************************************
//
//  Event:   pcd_savebefore
//  Purpose: Set defaults for update
//  
//  Date
//  -------- ----------- ------------------------------------------------------------------------
//  09/25/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING l_cNewKey, l_cSupervisor
DATETIME l_dtCreateDate
LONG l_nRow

l_nRow = dw_setoutofoffice.GetRow()

l_cNewKey = fw_getkeyvalue('out_of_office')
l_cSupervisor = OBJCA.WIN.fu_GetLogin(SQLCA)
l_dtCreateDate = w_supervisor_portal.fw_gettimestamp()

dw_setoutofoffice.SetItem(l_nRow,'out_of_office_id',l_cNewKey)
dw_setoutofoffice.SetItem(l_nRow,'out_user_id',i_cOutUserID)
dw_setoutofoffice.SetItem(l_nRow,'out_of_office_updated_by',l_cSupervisor)
dw_setoutofoffice.SetItem(l_nRow,'out_of_office_updated_timestamp',l_dtCreateDate)


end event

type dw_csrlist from u_outliner_std within w_out_of_office
integer x = 37
integer y = 96
integer width = 1083
integer height = 740
integer taborder = 10
borderstyle borderstyle = stylelowered!
end type

event po_pickedrow;call super::po_pickedrow;//***********************************************************************************************
//
//  Event:   po_PickedRow
//  Purpose: Get the row key of the selected row to process the Case reassign
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  09/14/00 C. Jackson  Original Version
//  11/26/01 C. Jackson  Disable the setoutofoffice datawindow if the selected user is out of 
//                       office.  (SCR 2518)
//  06/26/02 C. Jackson  Change confidentiality_level to usr_confidentiality_level
//
//***********************************************************************************************

STRING	l_cKeys[], l_cRowDesc, l_cRouteFullName, l_cRouteUserID, l_cOutSecurity, l_cNull
LONG		l_nLevel, l_nPos1, l_nReturn, l_nCount, l_nDWRow, l_nRow, l_nOutCount, l_nRouteCount
LONG     l_nRouteConfidLevel, l_nOutConfidLevel
S_CSR_INFO l_csr_info

SetNull(l_cNull)

// If this event was trigger by another function/event then set defaults.
IF clickedlevel = 2 THEN
	l_nRow = clickedrow
	
	i_bUserSelected = TRUE
	
	dw_setoutofoffice.Enabled = TRUE

	// Get the key of the Picked Row and view it's details
	l_cRowDesc = fu_HLGetRowDesc(l_nRow)
	l_csr_info = w_supervisor_portal.fw_GetCSRInfo(l_cRowDesc)
	
	SELECT usr_confidentiality_level INTO :l_nRouteConfidLevel
	  FROM cusfocus.cusfocus_user
	 WHERE user_id = :l_csr_info.user_id
	 USING SQLCA;
	 
	// Check to see if this route to CSR is Out of Office themselves
	SELECT count(*) INTO :l_nOutCount
	  FROM cusfocus.out_of_office
	 WHERE out_user_id = :l_csr_info.user_id
	 USING SQLCA;
	 
   // Cannot route of Out of Office			 
	IF l_nOutCount = 0 THEN
		
		// Cannot route to same CSR
		IF l_csr_info.user_id <> i_cOutUserID THEN
			
			SELECT usr_confidentiality_level INTO :l_nOutConfidLevel
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :i_cOutUserID
			 USING SQLCA;
			 
			IF l_nRouteConfidLevel >= l_nOutConfidLevel THEN
				l_nDWRow = dw_setoutofoffice.GetRow()
				
				// See if there is an old route
				SELECT assigned_to_user_id INTO :i_cOldRouteID
				  FROM cusfocus.out_of_office
				 WHERE out_user_id = :I_cOutUserID
				 USING SQLCA;
				 
				 IF NOT ISNULL(i_cOldRouteID) AND i_cOldRouteID <> '' THEN
					// Get the corresponding bitmap for this CSR
					SELECT out_of_office_bmp INTO :i_cBMP
					  FROM cusfocus.cusfocus_user
					 WHERE user_id = :i_cOldRouteID
					 USING SQLCA;
					 
				END IF
				
				dw_setoutofoffice.SetItem(l_nDWRow,'assigned_to_user_id',l_csr_info.user_id)
				dw_setoutofoffice.SetItem(l_nDWRow,'notify','Y')
				
			ELSE
				messagebox(gs_AppName,l_csr_info.user_full_name+' does not have the authority to receive cases for '+&
				           i_cFullName)
				THIS.fu_HLClearSelectedRows()
				
			END IF
			
		ELSE
			messagebox(gs_AppName,'Cannot route to the same CSR')
			THIS.fu_HLClearSelectedRows()
				
		END IF
		
	ELSE 
		messagebox(gs_AppName,l_csr_info.user_full_name+' is Out of the Office.')
		dw_setoutofoffice.SetItem(1,'assigned_to_user_id',l_cNull)
		dw_setoutofoffice.SetItem(1,'reason',l_cNull)
		dw_setoutofoffice.SetItem(1,'notify','N')
		dw_setoutofoffice.Enabled = FALSE
		THIS.fu_HLClearSelectedRows()
		
	END IF
			 
ELSE
	i_bUserSelected = FALSE
	 
END IF


end event

type cb_save from u_cb_save within w_out_of_office
integer x = 1019
integer y = 1152
integer width = 320
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;call super::clicked;//*****************************************************************************************
//
//  Event:    clicked
//  Purpose:  Trigger the save and re-retrieve the parent's list datawindow
//   
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------
//	 09/22/00 C. Jackson    Original Version
//
//*****************************************************************************************

STRING l_cDeptID, l_cEnabled, l_cBMP, l_cSupervisor, l_cWindowTitle, l_cRouteID, l_cKeys[]
STRING l_cOldRoute
LONG l_nRow, l_nRtn, l_nPos, l_nRouteCount, l_nOutCount, l_nSelectedRow, l_nIndex
LONG l_nCounter, l_nIndex1, l_nExpandCounter, l_nExpandedRows[], l_nRowCount, l_nLevel
LONG l_nExpandStatus, l_nOldRouteCount
U_OUTLINER_STD l_dwOutCSRList
U_DW_STD l_dwOutDetails, l_dwRouteDetails

l_dwOutCSRList = w_supervisor_portal.tab_1.tabpage_out_of_office.uo_outofoffice.dw_csrlist
l_dwoutDetails = w_supervisor_portal.tab_1.tabpage_out_of_office.uo_outofoffice.dw_outofofficedetails
l_dwRouteDetails = w_supervisor_portal.tab_1.tabpage_out_of_office.uo_outofoffice.dw_routedetails

l_nRow = dw_setoutofoffice.GetRow()
l_cRouteID = dw_setoutofoffice.GetItemString(l_nRow,'assigned_to_user_id_1')

// If there was a previous Route to CSR on this set them back
SELECT count (*) INTO :l_nOldRouteCount
  FROM cusfocus.out_of_office
 WHERE assigned_to_user_id = :i_cOldRouteID
 USING SQLCA;
 
IF l_nOldRouteCount = 0 THEN
	IF i_cBMP = 'routed.bmp' OR i_cBMP = 'route_to.bmp'  THEN
		UPDATE cusfocus.cusfocus_user
		   SET out_of_office_bmp = 'person.bmp'
		 WHERE user_id = :i_cOldRouteID
		 USING SQLCA;
		 
	END IF
	
END IF

// Check to see if this was previously routed to another user
SELECT assigned_to_user_id INTO :l_cOldRoute
  FROM cusfocus.out_of_office
 WHERE out_user_id = :i_cOutUserID
 USING SQLCA;
 
IF NOT ISNULL(i_cClearRoute) THEN
	// Check to see if this CSR is being routed cases for another user
	SELECT count(*) INTO :l_nRouteCount
	  FROM cusfocus.out_of_office
	 WHERE assigned_to_user_id = :i_cClearRoute
	 USING SQLCA;
  
	 IF l_nRouteCount = 0 THEN
		// This was the only 'route' record for this CSR, make sure they are not out of office 
		SELECT count(*) INTO :l_nOutCount
		  FROM cusfocus.out_of_office
		 WHERE out_user_id = :i_cClearRoute
		 USING SQLCA;
		 
		IF l_nOutCount > 0 THEN
			l_cBMP = 'out_of_office.bmp'
		ELSE
			l_cBMP = 'person.bmp'
		END IF
		
		UPDATE cusfocus.cusfocus_user
		   SET out_of_office_bmp = :l_cBMP
		 WHERE user_id = :i_cClearRoute
		 USING SQLCA;
		
	END IF
	 
ELSE
	// Set BMP for routed ID
	IF NOT ISNULL(l_cRouteID) OR l_cRouteID <> '' THEN
		UPDATE cusfocus.cusfocus_user
			SET out_of_office_bmp = 'routed.bmp'
		 WHERE user_id = :i_cOutUserID
		 USING SQLCA;
	END IF

END IF

IF ISNULL(l_cRouteID) OR l_cRouteID = '' THEN
	UPDATE cusfocus.cusfocus_user
		SET out_of_office_bmp = 'out_of_office.bmp'
	 WHERE user_id = :i_cOutUserID
	 AND out_of_office_bmp = 'routed.bmp'
	 USING SQLCA;
ELSE
	UPDATE cusfocus.cusfocus_user
	   SET out_of_office_bmp = 'route_to.bmp'
	 WHERE user_id = :l_cRouteID
	 USING SQLCA;
END IF

// Refresh the outliner Datawindow

// Loop through level 1 records to see what is currently expanded
l_nRowCount = l_dwOutCSRList.RowCount()

l_nExpandCounter = 0

// Loop through level 1 records to see what is currently expanded
l_nRowCount = l_dwOutCSRList.RowCount()

l_nExpandCounter = 0

FOR l_nIndex = 1 TO l_nRowCount
	l_nLevel = l_dwOutCSRList.fu_HLGetRowLevel(l_nIndex)
	IF l_nLevel = 1 THEN
		l_nExpandStatus = l_dwOutCSRList.GetItemNumber(l_nIndex,"expanded")
		IF l_nExpandStatus = 1 THEN
			l_nExpandCounter++
			l_nExpandedRows[l_nExpandCounter] = l_nIndex
		END IF
	END IF
		
NEXT

// Get my current row
l_nRow = l_dwOutCSRList.fu_HLFindRow(i_cOutUserID,2)

l_nSelectedRow = l_dwOutCSRList.GetRow()

l_dwOutCSRList.SetRedraw(FALSE)
l_dwOutCSRList.Hide()

l_dwOutCSRList.fu_HLCollapseBranch()
l_dwOutCSRList.fu_HLRefresh(2, l_dwOutCSRList.c_ReselectRows)
l_dwOutCSRList.fu_HLGetRowKey(l_nSelectedRow, l_cKeys[])
l_nIndex = UpperBound (l_cKeys[])

// Expand all previously expanded branches
FOR l_nIndex1 = 1 to l_nExpandCounter
	l_dwOutCSRList.fu_HLSetSelectedRow(l_nExpandedRows[l_nIndex1])
	l_dwOutCSRList.ScrollToRow(l_nExpandedRows[l_nIndex1])
	l_dwOutCSRList.fu_HLExpandBranch()
NEXT

FOR l_nCounter = 1 to l_nIndex
	l_nRow = l_dwOutCSRList.fu_HLFindRow(l_cKeys[l_nCounter], l_nCounter)

	IF l_nCounter < l_nIndex THEN
		l_dwOutCSRList.i_ClickedRow = l_nRow
		l_dwOutCSRList.fu_HLExpandBranch()
	ELSE
		l_dwOutCSRList.fu_HLSetSelectedRow(l_nRow)
		l_dwOutCSRList.ScrollToRow(l_nRow)
	END IF
	l_dwOutCSRList.fu_HLExpandBranch()
NEXT

l_dwOutCSRList.Show()
l_dwOutCSRList.SetRedraw(TRUE)


// Re-retrieve the list datawindow
l_cDeptID = w_supervisor_portal.tab_1.tabpage_out_of_office.uo_outofoffice.i_cDeptID

// Re-retrieve the detail dataindows
l_nRtn = l_dwoutDetails.Retrieve(i_cOutUserID)
IF l_nRtn = 0 THEN
	l_dwoutDetails.fu_SetOptions(SQLCA, &
	l_dwoutDetails.c_nullDW, &
	l_dwoutDetails.c_ShowEmpty)
END IF

l_nRtn = l_dwRouteDetails.Retrieve(i_cOutUserID)
IF l_nRtn = 0 THEN
	l_dwRouteDetails.fu_SetOptions(SQLCA, &
	l_dwRouteDetails.c_nullDW, &
	l_dwRouteDetails.c_ShowEmpty)
END IF

CLOSE(parent)
	
	
end event

type cb_cancel from u_cb_cancel within w_out_of_office
integer x = 1381
integer y = 1152
integer width = 320
integer height = 76
integer taborder = 40
boolean bringtotop = true
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
//  Purpose: close window
//  
//  Date
//  -------- ----------- ------------------------------------------------------------------------
//  09/20/00 C. Jackson  Original Version
//
//***********************************************************************************************y

dw_setoutofoffice.fu_Reset(c_IgnoreChanges)
Close(Parent)
end event

