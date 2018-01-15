$PBExportHeader$u_reassign_detail.sru
$PBExportComments$Results and Preview tab objects for u_reassign_cases
forward
global type u_reassign_detail from u_tab_std
end type
type tabpage_results from u_reassign_results within u_reassign_detail
end type
type tabpage_results from u_reassign_results within u_reassign_detail
end type
type tabpage_preview from u_reassign_preview within u_reassign_detail
end type
type tabpage_preview from u_reassign_preview within u_reassign_detail
end type
end forward

global type u_reassign_detail from u_tab_std
integer width = 3227
integer height = 1028
integer textsize = -8
tabpage_results tabpage_results
tabpage_preview tabpage_preview
end type
global u_reassign_detail u_reassign_detail

type variables
STRING  i_cCaseNumber
end variables

on u_reassign_detail.create
this.tabpage_results=create tabpage_results
this.tabpage_preview=create tabpage_preview
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_results
this.Control[iCurrent+2]=this.tabpage_preview
end on

on u_reassign_detail.destroy
call super::destroy
destroy(this.tabpage_results)
destroy(this.tabpage_preview)
end on

event selectionchanged;call super::selectionchanged;////****************************************************************************************
////
////  Event:   selectionchanged
////  Purpose: Retrieve data based on Results tab
////  
////  Date
////  -------- ----------- -----------------------------------------------------------------
////  10/11/00 C. Jackson  Original Version
////
////****************************************************************************************
//LONG l_nRtn, l_nRow
//
//IF newindex = 2 THEN
//
//	// Disable case history report menu items
//	IF oldindex = 1 THEN
//		m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
//		m_supervisor_portal.m_file.m_casedetail.Enabled = FAlSE
//	END IF
//
//	// Display preview pane
//	l_nRow = tabpage_results.dw_reassign_list.GetRow()
//	CHOOSE CASE l_nRow
//		CASE 1
//			i_cCaseNumber = tabpage_results.dw_reassign_list.GetItemString(l_nRow,'case_log_case_number')
//			tabpage_preview.dw_reassign_preview.SetTrans(SQLCA)
//			l_nRtn = tabpage_preview.dw_reassign_preview.Retrieve(i_cCaseNumber)
//		CASE 0
//			tabpage_preview.st_nonotes.Visible = TRUE
//			
//		CASE IS > 1
//			tabpage_preview.st_nonotes.Visible = FALSE
//		
//	END CHOOSE		
//	
//END IF
//
//IF oldindex = 2 AND newindex = 1 THEN
//	m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = TRUE
//	m_supervisor_portal.m_file.m_casedetail.Enabled = TRUE
//	
//END IF
end event

event constructor;call super::constructor;//**********************************************************************************************
//
//  Event:   constructor
//  Purpose: To initialize resize service
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/16/00 C. Jackson  Original Version
//
//**********************************************************************************************

//Initialize the resize service
THIS.of_SetResize( TRUE )

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( u_reassign_detail, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF
end event

type tabpage_results from u_reassign_results within u_reassign_detail
integer x = 18
integer y = 112
integer width = 3191
integer height = 900
string text = "Results"
end type

type tabpage_preview from u_reassign_preview within u_reassign_detail
integer x = 18
integer y = 112
integer width = 3191
integer height = 900
string text = "Preview"
end type

