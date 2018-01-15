$PBExportHeader$w_edit_report.srw
$PBExportComments$Edit Reports Window
forward
global type w_edit_report from w_response_std
end type
type cb_delete from commandbutton within w_edit_report
end type
type cb_save from u_cb_ok within w_edit_report
end type
type cb_cancel from commandbutton within w_edit_report
end type
type cb_ok from u_cb_ok within w_edit_report
end type
type st_1 from statictext within w_edit_report
end type
type dw_edit_report_details from u_dw_std within w_edit_report
end type
type cb_new from u_cb_new within w_edit_report
end type
type dw_edit_report_list from u_dw_std within w_edit_report
end type
end forward

global type w_edit_report from w_response_std
integer x = 219
integer y = 556
integer width = 3602
integer height = 1804
string title = "Add / Edit Reports"
cb_delete cb_delete
cb_save cb_save
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
dw_edit_report_details dw_edit_report_details
cb_new cb_new
dw_edit_report_list dw_edit_report_list
end type
global w_edit_report w_edit_report

type variables
STRING i_cReportID
STRING i_cDelReportID
STRING    i_cSaveMessage = "Would you like to Save the Report?"
STRING i_cLogin

LONG i_nListRow

BOOLEAN i_bNew
BOOLEAN i_bStandard = FALSE



end variables

on w_edit_report.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.dw_edit_report_details=create dw_edit_report_details
this.cb_new=create cb_new
this.dw_edit_report_list=create dw_edit_report_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_save
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_edit_report_details
this.Control[iCurrent+7]=this.cb_new
this.Control[iCurrent+8]=this.dw_edit_report_list
end on

on w_edit_report.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_save)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.dw_edit_report_details)
destroy(this.cb_new)
destroy(this.dw_edit_report_list)
end on

event pc_setoptions;call super::pc_setoptions;//************************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: to set window options
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  11/28/00 C. Jackson  Original Version
//
//************************************************************************************************

STRING l_cDWString
LONG l_nRtn

i_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

fw_SetOptions (c_NoEnablePopup)

//Retrieve the datawindow
dw_edit_report_list.SetTransObject(SQLCA)

l_nRtn = dw_edit_report_list.Retrieve(i_cLogin)

dw_edit_report_list.PostEvent(Clicked!)


end event

event open;call super::open;//**********************************************************************************************
//
//  Event:   open
//  Purpose: to set the first row as selected
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/04/00 c. jackson  Original Verison
//
//**********************************************************************************************

LONG  l_nSelectedRow[1], l_nRow

l_nRow = dw_edit_report_list.GetRow()

IF l_nRow <> 0 THEN

	l_nSelectedRow[1] = 1

	dw_edit_report_list.fu_SetSelectedRows(1, l_nSelectedRow[], dw_edit_report_list.c_IgnoreChanges, &
		dw_edit_report_list.c_NoRefreshChildren)
		
	i_cReportID = dw_edit_report_list.GetItemString(1,'report_id')
	
	dw_edit_report_details.fu_Retrieve(dw_edit_report_details.c_PromptChanges, dw_edit_report_details.c_ReselectRows)
	
	dw_edit_report_details.SetFocus()
	
ELSEIF l_nRow = 0 THEN
	// There are no reports, make the New button the default
	
	cb_New.SetFocus()
	cb_New.Default = TRUE
	

END IF


end event

event close;call super::close;//***********************************************************************************************
//
//  Event:   close
//  Purpose: Re-retrieve parent window
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/05/01 C. Jackson  Original Version
//
//***********************************************************************************************
	
	IF ISVALID(w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list) THEN
		w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.SetTransObject(SQLCA)
		w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.Retrieve(i_cLogin)
	END IF

end event

type cb_delete from commandbutton within w_edit_report
integer x = 494
integer y = 1564
integer width = 320
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;//***********************************************************************************************
//  
//  Event:   clicked
//  Purpose: To delete the selected record
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  06/15/01 C. Jackson  Correct logic to delete parent rather than child
//  
//***********************************************************************************************

Integer l_nRows[1], l_nRtn, l_nOption

IF dw_edit_report_details.RowCount( ) > 0 THEN
	l_nOption = MessageBox( gs_AppName, &
									"Are you sure you want to delete the selected report?", &
									Question!, &
									YesNo! )
									
	IF l_nOption = 1 THEN
		l_nRows[ 1 ] = 1

		l_nRtn = dw_edit_report_list.fu_Delete( 1, &
													  l_nRows, &
													  dw_edit_report_list.c_IgnoreChanges )

		IF l_nRtn < 0 THEN
			Error.i_FWError = c_Fatal
		ELSE
			
			l_nRtn = dw_edit_report_list.fu_Save( dw_edit_report_list.c_SaveChanges )

	
			IF l_nRtn < 0 THEN
				Error.i_FWError = c_Fatal
				
			ELSE
				
				dw_edit_report_details.fu_Retrieve( dw_edit_report_details.c_IgnoreChanges, &
													  dw_edit_report_details.c_NoReselectRows )		
													  
			END IF
			
		END IF
			
	END IF
	
END IF


end event

type cb_save from u_cb_ok within w_edit_report
integer x = 2542
integer y = 1568
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save"
end type

event clicked;call super::clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To save the changes and close the window.
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  01/11/01 C. Jackson  Original Version
//  01/29/01 C. Jackson  Re-retrieve reports list on supervisor portal (SCR 1400)
//  06/15/01 C. Jackson  Make sure there is a selected row before trying to save
//
//************************************************************************************************

STRING l_cExtSource, l_cPath, l_cMacro, l_cReportID, l_cUserID, l_cUpdatedBy
DATETIME l_dUpdatedTimestamp
LONG l_nReturn, l_nIndex, l_nRow

dw_edit_report_details.AcceptText()

l_nRow = dw_edit_report_details.GetRow()

IF l_nRow > 0 THEN

	IF NOT i_bStandard THEN
	
		// Make sure required fields are entered before continuing
		l_cExtSource = dw_edit_report_details.GetItemString(l_nRow,'external_source')
		l_cPath = dw_edit_report_details.GetItemString(l_nRow,'path')
		l_cMacro = dw_edit_report_details.GetItemString(l_nRow,'macro')
		
		IF ISNULL(l_cPath) OR l_cPath = '' THEN
			messagebox(gs_AppName,'Path is required.')
			dw_edit_report_details.SetFocus()
			dw_edit_report_details.SetColumn('path')
			RETURN
		END IF
		
		IF UPPER(l_cExtSource) = 'MSACCESS' THEN
		
			IF ISNULL(l_cMacro) OR l_cMacro = '' THEN
				messagebox(gs_AppName,'Macro is required for a Microsoft Access Report.')
				dw_edit_report_details.SetFocus()
				RETURN
				
			ELSE
		
				l_nReturn = dw_edit_report_details.fu_Save(dw_edit_report_details.c_SaveChanges)
				
				IF l_nReturn = dw_edit_report_details.c_Success THEN		
					
					// Re-retrieve report lists
					IF ISVALID(w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list) THEN
						w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.SetTransObject(SQLCA)
						w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.Retrieve(i_cLogin)
					END IF
					
					dw_edit_report_list.Retrieve(i_cLogin)
						
					
				END IF
		
			END IF
		END IF
		
	ELSE
		
		l_nReturn = dw_edit_report_details.fu_Save(dw_edit_report_details.c_SaveChanges)
		
		IF l_nReturn = dw_edit_report_details.c_Success THEN		
			
			// Re-retrieve report lists
			IF ISVALID(w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list) THEN
				w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.SetTransObject(SQLCA)
				w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.Retrieve(i_cLogin)
			END IF
			
			dw_edit_report_list.Retrieve(i_cLogin)
				
			
		END IF
	
	END IF
	
END IF
end event

type cb_cancel from commandbutton within w_edit_report
integer x = 3246
integer y = 1568
integer width = 320
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to close without saving
//  
//  Date     Developer   Desription
//  -------- ----------- ------------------------------------------------------------------------
//  01/11/01 C. Jackson  Original Version
//
//***********************************************************************************************

dw_edit_report_details.SetItemStatus (dw_edit_report_details.i_CursorRow, 0, Primary!, NotModified!)
dw_edit_report_details.fu_ResetUpdate ()
CLOSE (Parent)


end event

type cb_ok from u_cb_ok within w_edit_report
integer x = 2889
integer y = 1568
integer width = 320
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To save the changes and close the window.
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  01/11/01 C. Jackson  Original Version
//  01/29/01 C. Jackson  Re-retrieve reports list on supervisor portal (SCR 1400)
//
//************************************************************************************************

STRING l_cExtSource, l_cPath, l_cMacro, l_cReportId, l_cUserID, l_cUpdatedBy
DATETIME l_dUpdatedTimeStamp
LONG l_nReturn, l_nIndex, l_nRow

dw_edit_report_details.AcceptText()

l_nRow = dw_edit_report_details.GetRow()

IF l_nRow > 0 THEN

	IF NOT i_bStandard THEN
		// Make sure required fields are entered before continuing
		l_cExtSource = dw_edit_report_details.GetItemString(l_nRow,'external_source')
		l_cPath = dw_edit_report_details.GetItemString(l_nRow,'path')
		l_cMacro = dw_edit_report_details.GetItemString(l_nRow,'macro')
		
		IF ISNULL(l_cPath) OR l_cPath = '' THEN
			messagebox(gs_AppName,'Path is required.')
			dw_edit_report_details.SetFocus()
			dw_edit_report_details.SetColumn('path')
			RETURN
		END IF
		
		IF UPPER(l_cExtSource) = 'MSACCESS' THEN
		
			IF ISNULL(l_cMacro) OR l_cMacro = '' THEN
				messagebox(gs_AppName,'Macro is required for a Microsoft Access Report.')
				dw_edit_report_details.SetFocus()
				RETURN
				
			ELSE
		
				l_nReturn = dw_edit_report_details.fu_Save(dw_edit_report_details.c_SaveChanges)
				
				IF l_nReturn = dw_edit_report_details.c_Success THEN		
					
					// Update the report list
					IF ISVALID(w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list) THEN
						w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.SetTransObject(SQLCA)
						w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.Retrieve(i_cLogin)
					END IF
					
				END IF
		
			END IF
		END IF
		
	END IF
	
ELSE
	
	l_nReturn = dw_edit_report_details.fu_Save(dw_edit_report_details.c_SaveChanges)
	
	IF l_nReturn = dw_edit_report_details.c_Success THEN		
		
		// Update the report list
		IF ISVALID(w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list) THEN
			w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.SetTransObject(SQLCA)
			w_supervisor_portal.tab_1.tabpage_reports.uo_reports.dw_report_list.Retrieve(i_cLogin)
		END IF
		
	END IF
	
END IF


CLOSE(PARENT)
	


end event

type st_1 from statictext within w_edit_report
integer x = 27
integer y = 984
integer width = 407
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report Details:"
boolean focusrectangle = false
end type

type dw_edit_report_details from u_dw_std within w_edit_report
event buttonclicked pbm_dwnbuttonclicked
integer x = 14
integer y = 1060
integer width = 3552
integer height = 464
integer taborder = 20
string dataobject = "d_edit_report_details"
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;//*************************************************************************************************
//
//  Event:   buttonclicked
//  Purpose: Get the path of the new report
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  02/09/01 C. Jackson  Original Version
//  09/25/01 C. Jackosn  Correct spelling error in message (SCR 2424)
//  
//*************************************************************************************************

STRING l_cExtSource, l_cPath, l_cFile, l_cReport

l_cExtSource = UPPER(THIS.GetItemString(1,'external_source'))

IF l_cExtSource = 'MSACCESS' THEN
	GetFileOpenName("Select MSAccess .mdb file", &
		+ l_cPath, l_cFile, "EXE", &
		+ "Microsoft Access .mdb Files (*.MDB),*.MDB")
	THIS.SetItem(1,'path',l_cPath)
	
ELSEIF l_cExtSource = 'CRYSTAL' THEN
	GetFileOpenName("Select Crystal Reports Executable", &
		l_cPath, l_cReport, "EXE", &
		"Crystal Reports Executable Files (*.EXE),*.EXE," + &
		"Crystal Reports Report Files (*.RPT),*.RPT")
	THIS.SetItem(1,'path',l_cPath)
	
	

ELSE
	MessageBox(gs_AppName, 'Please select an external source type before selecting report path.')
	SetColumn('external_source')
	actionreturncode = 3

END IF


//
//		GetFileOpenName("Select Document Image File", &
//				+ l_cFileandPath, l_cFileName, "DOC", &
//				+ "Acrobat Files (*.PDF),*.PDF," &
//				+ "Excel Files (*.XLS),*.XLS," &
//				+ "Doc Files (*.DOC),*.DOC")
//
end event

event pcd_setoptions;call super::pcd_setoptions;//**********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: Set options
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  12/01/00 c. jackson  Original Version
//
//**********************************************************************************************

fu_SetOptions (SQLCA, c_NullDW, c_NewOK + c_ModifyOK + c_ModifyOnOpen + c_NoEnablePopup + &
		c_ShowEmpty + c_NoMenuButtonActivation + c_DeleteOK)
end event

event itemchanged;call super::itemchanged;//**********************************************************************************************
//
//  Event:   itemchanged
//  Purpose: Set updated_by and update_timestamp
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  11/28/00 C. Jackson  Original Version
//  01/14/01 C. Jackson  Ensure that the report name is unique (SCR 1300)
//
//**********************************************************************************************

STRING l_cColName, l_cExtSource
LONG l_nReportCount
DATETIME l_dtTimeStamp

l_cColName = dwo.name

// Make sure the report name is unique
CHOOSE CASE l_cColName
	CASE 'report_name'
		
		SELECT count(*) INTO :l_nReportCount
		  FROM cusfocus.reports
		 WHERE report_name = :data
		USING SQLCA;
		
		IF l_nReportCount > 0 THEN
			messagebox(gs_AppName,'"'+data+'" is already used, please select another report name.')
			RETURN 1
		END IF
		
	CASE 'external_source'

		
		
	   IF UPPER(data) <> 'MSACCESS' THEN
	
			THIS.Modify ("macro_t.Visible=FALSE")
			THIS.Modify ("macro.Visible=FALSE" )
			
		ELSE

			THIS.Modify ("macro_t.Visible=TRUE")
			THIS.Modify ("macro.Visible=TRUE" )
			
		END IF
		// Clear out the path
		THIS.SetItem(1,'path','')
		THIS.SetColumn('path')
		
END CHOOSE


end event

event pcd_retrieve;call super::pcd_retrieve;//***********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: To retrieve the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/04/00 c. jackson  Original Version
//  01/13/01 C. Jackson  Remove protect statement in date_parms column, this has been removed 
//                       from the datawindow 
//  06/15/01 C. Jackson  Make the 'browse file' button not visible if this is a standard report
//                       SCR 2107)
//
//***********************************************************************************************

STRING l_cdwString, l_cDataWindow, l_cSource
LONG l_nRow

THIS.Retrieve(i_cReportID)

l_nRow = THIS.GetRow()

cb_delete.Enabled = FALSE

IF l_nRow <> 0 THEN
	l_cdwString = THIS.GetItemString(l_nRow,'report_dtwndw_frmt_strng')

   // This is a standard report, user can't change name, desc, source or path
	IF NOT ISNULL(l_cdwString) OR l_cdwString <> '' THEN
		THIS.Object.report_name.Protect = 1
		THIS.Object.report_name.Background.Color = 12632256
		THIS.Object.report_desc.Protect = 1
		THIS.Object.report_desc.Background.Color = 12632256
		THIS.Object.external_source.Protect = 1
		THIS.Object.external_source.Background.Color = 12632256
		THIS.Object.path.Protect = 1
		THIS.Object.path.Background.Color = 12632256
		THIS.Object.b_fileopen.Visible = 0
	ELSE	
		// This is a user define report user can change fields
		i_bStandard = FALSE
		cb_delete.Enabled = TRUE
		THIS.Object.report_name.Protect = 0
		THIS.Object.report_name.Background.Color = 16777215
		THIS.Object.report_desc.Protect = 0
		THIS.Object.report_desc.Background.Color = 16777215
		THIS.Object.external_source.Protect = 0
		THIS.Object.external_source.Background.Color = 16777215
		THIS.Object.path.Protect = 0
		THIS.Object.path.Background.Color = 16777215
		THIS.Object.b_fileopen.Visible = 1
		THIS.SetColumn('report_name')
			
	END IF
	
	
		// Display the macro field if this is an Access report
		
		l_cSource = THIS.GetItemString(l_nRow,'external_source')
		
		IF UPPER(l_cSource) = 'MSACCESS' THEN
			THIS.Modify ("macro_t.Visible=TRUE")
			THIS.Modify ("macro.Visible=TRUE" )
		ELSEIF UPPER(l_cSource) = 'CRYSTAL' THEN
			THIS.Modify ("macro_t.Visible=FALSE") 
			THIS.Modify ("macro.Visible=FALSE" )
		ELSE
			i_bStandard = TRUE
		END IF

	
ELSE	
		THIS.Object.report_name.Protect = 1
		THIS.Object.report_name.Background.Color = 12632256
		THIS.Object.report_desc.Protect = 1
		THIS.Object.report_desc.Background.Color = 12632256
		THIS.Object.external_source.Protect = 1
		THIS.Object.external_source.Background.Color = 12632256
		THIS.Object.path.Protect = 1
		THIS.Object.path.Background.Color = 12632256
	
	
END IF


end event

type cb_new from u_cb_new within w_edit_report
integer x = 18
integer y = 1568
integer width = 320
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: to get report_id for inserting new row
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  11/28/00 C. Jackson  Original Version
//
//************************************************************************************************

STRING l_cNewReportKey
LONG l_nRow, l_nSelectedRows[], l_nNewRow
DATETIME l_dtCreateDate

l_dtCreateDate = PARENT.fw_GetTimeStamp ()

IF i_bNew THEN
	cb_save.TriggerEvent(Clicked!)
END IF

call super::clicked

dw_edit_report_details.fu_Reset( dw_edit_report_details.c_SaveChanges )
dw_edit_report_details.fu_new(1)

i_bNew = TRUE

dw_edit_report_details.SetFocus()

l_cNewReportKey = fw_getkeyvalue('reports')
l_cNewReportKey = fw_getkeyvalue('reports')
l_nRow = dw_edit_report_details.GetRow()
l_nRow = dw_edit_report_details.GetRow()

// Open fields for edit
dw_edit_report_details.Object.report_name.Protect = 0
dw_edit_report_details.Object.report_name.Background.Color = 16777215
dw_edit_report_details.Object.report_desc.Protect = 0
dw_edit_report_details.Object.report_desc.Background.Color = 16777215
dw_edit_report_details.Object.owner.Protect = 0
dw_edit_report_details.Object.owner.Background.Color = 16777215
dw_edit_report_details.Object.external_source.Protect = 0
dw_edit_report_details.Object.external_source.Background.Color = 16777215
dw_edit_report_details.Object.path.Protect = 0
dw_edit_report_details.Object.path.Background.Color = 16777215


dw_edit_report_details.SetItem(l_nRow,'external_source','MSACCESS')
dw_edit_report_details.Modify ("macro_t.Visible=TRUE")
dw_edit_report_details.Modify ("macro.Visible=TRUE" )
dw_edit_report_details.SetItem(l_nRow,'path','')
dw_edit_report_details.SetItem(l_nRow,'report_name','')
dw_edit_report_details.SetItem(l_nRow,'report_desc','')
dw_edit_report_details.SetItem(l_nRow,'owner',i_cLogin)

dw_edit_report_details.SetItem(l_nRow,'report_id',l_cNewReportKey)
dw_edit_report_details.SetItem(l_nRow,'updated_by',i_cLogin)
dw_edit_report_details.SetItem(l_nRow,'updated_timestamp',l_dtCreateDate)

dw_edit_report_details.SetColumn('report_name')

dw_edit_report_details.SetItemStatus(l_nRow, 0, Primary! ,NotModified!)



end event

type dw_edit_report_list from u_dw_std within w_edit_report
integer x = 18
integer y = 20
integer width = 3552
integer height = 936
integer taborder = 10
string dataobject = "d_edit_report_list"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: Initialize the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  11/28/00 C. Jackson  Original Version
//
//***********************************************************************************************


		fu_SetOptions( SQLCA, & 
			c_NullDW, & 
			c_SelectOnRowFocusChange + &
			c_NewOK + &
			c_ModifyOK + &
			c_DeleteOK + &
			c_NoEnablePopup + &
			c_ModifyOnOpen + &
			c_ModifyOnSelect + &
			c_NoRetrieveOnOpen + &
			c_RefreshChild + &
			c_TabularFormStyle + &
			c_NoInactiveRowPointer + &
			c_ShowHighlight  ) 

end event

event clicked;call super::clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: to enable/disable Delete button
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  11/29/00 C. Jackson  Original Version
//
//***********************************************************************************************

STRING l_cdwString, l_cReportName, l_cReportDesc, l_cOwner, l_cExtSource
STRING l_cExtRepName, l_cExtCommand
LONG l_nReturn

// Check to see if previous row was changed
CHOOSE CASE THIS.GetItemStatus(i_nListRow,0,Primary!)
	CASE NewModified!, DataModified!
		// Prompt the user to save the current report
		l_nReturn = MessageBox( gs_appname, 'The current report has unsaved changes.  Save it now?', &
			Question!, YesNoCancel! )
		CHOOSE CASE l_nReturn
			CASE 1
				// Save the report
				dw_edit_report_details.fu_Save( dw_edit_report_details.c_SaveChanges )
				THIS.fu_Save (c_SaveChanges)
			CASE 2
				// Ignore the changes and continue
				THIS.fu_ResetUpdate( )
				RETURN 0
			CASE 3
				RETURN 1
				
		END CHOOSE
		
END CHOOSE

i_nListRow = THIS.GetRow()

IF i_nListRow <> 0 THEN

	// Make sure this column can be changed for this report
	l_cdwString = THIS.GetItemString(i_nListRow,'report_dtwndw_frmt_strng')
	
	i_cReportID = THIS.GetItemString(i_nListRow,'report_id')
	
	dw_edit_report_details.AcceptText()
	
	FWCA.MSG.fu_SetMessage ("ChangesOne", FWCA.MSG.c_MSG_Text, 'Would you like to save changes?')
	dw_edit_report_details.fu_Retrieve(dw_edit_report_details.c_PromptChanges,dw_edit_report_details.c_ReselectRows)

END IF

dw_edit_report_details.SetFocus()

dw_edit_report_details.SetColumn(1)


end event

