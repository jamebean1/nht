$PBExportHeader$u_reassign_results.sru
$PBExportComments$Case results datawindow
forward
global type u_reassign_results from u_tabpg_std
end type
type dw_reassign_list from u_dw_std within u_reassign_results
end type
end forward

global type u_reassign_results from u_tabpg_std
integer width = 2976
integer height = 848
long backcolor = 80269524
dw_reassign_list dw_reassign_list
end type
global u_reassign_results u_reassign_results

type variables

end variables

forward prototypes
public function boolean fu_accessok (string case_number, string user_id)
end prototypes

public function boolean fu_accessok (string case_number, string user_id);//***********************************************************************************************
//
//  Function: fu_AccessOK
//  Purpose:  to check the users access to the selected case
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  01/03/01 C. Jackson  Original Version
//  01/04/01 C. Jackson  Correct security
//  3/6/2001 K. Claver   Added demographic security
//
//***********************************************************************************************

BOOLEAN l_bAccessOK
LONG l_nCaseConfid, l_nUserConfid
Integer l_nRecConfid, l_nUserRecConfid
String l_cSourceType, l_cSubjectID

SELECT confidentiality_level,
		 case_subject_id,
		 source_type
  INTO :l_nCaseConfid,
  		 :l_cSubjectID,
		 :l_cSourceType
  FROM cusfocus.case_log
 WHERE case_number = :case_number
 USING SQLCA;
 
//Get the record confidentiality level
l_nRecConfid = w_supervisor_portal.fw_GetRecConfidLevel( l_cSubjectID, l_cSourceType )
 
SELECT  confidentiality_level,
		  rec_confidentiality_level
  INTO :l_nUserConfid,
  		 :l_nUserRecConfid
  FROM cusfocus.cusfocus_user
 WHERE user_id = :user_id
 USING SQLCA;
 
IF l_nUserConfid >= l_nCaseConfid AND &
   ( l_nUserRecConfid >= l_nRecConfid OR IsNull( l_nRecConfid ) ) THEN
	l_bAccessOK = TRUE
ELSE
	l_bAccessOK = FALSE
END IF

RETURN l_bAccessOK



end function

on u_reassign_results.create
int iCurrent
call super::create
this.dw_reassign_list=create dw_reassign_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_reassign_list
end on

on u_reassign_results.destroy
call super::destroy
destroy(this.dw_reassign_list)
end on

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
	THIS.inv_resize.of_Register( dw_reassign_list, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF
end event

type dw_reassign_list from u_dw_std within u_reassign_results
integer width = 2944
integer height = 700
integer taborder = 10
string dataobject = "d_reassign_list"
boolean hscrollbar = true
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

fu_SetOptions (SQLCA, c_NullDW, c_SelectOnClick + c_NoEnablePopup + c_MultiSelect + c_SortClickedOK)


end event

event clicked;call super::clicked;////**********************************************************************************************
////
////  Event:   clicked
////  Purpose: add sorting, enable menus as necessary
////  
////  Date     Developer   Description
////  -------- ----------- -----------------------------------------------------------------------
////  10/30/00 C. Jackson  Original Version
////  02/05/01 C. Jackson  Make sure there are rows before allowing sort (SCR 1405)
////
////**********************************************************************************************
//
//STRING l_cname, l_cSourceType, l_cLogin, l_cCaseNumber
//LONG l_nRow, l_nNumSelected, l_nSelected[], l_nUserSecurity, l_nCaseSecurity, l_nSelectedRow[]
//BOOLEAN l_bAccessOK
//BOOLEAN l_bPreview
//
//l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)
//
//l_nNumSelected = THIS.fu_GetSelectedRows(l_nSelectedRow[])
//
//IF l_nNumSelected > 1 THEN
//	l_bPreview = FALSE
//ELSE
//	l_bPreview = TRUE
//END IF
//
//l_nRow = THIS.GetRow()
//
//IF l_nRow > 0 THEN
//	l_cCaseNumber = THIS.GetItemString(l_nRow,'case_log_case_number')
//	
//	l_bAccessOK = fu_AccessOK(l_cCaseNumber,l_cLogin)
//	
//	w_supervisor_portal.tab_1.tabpage_reassign_cases.uo_reassigncases.tab_details.tabpage_preview.Enabled = FALSE
//	
//	IF l_bAccessOK THEN
//		IF l_bPreview THEN
//			w_supervisor_portal.tab_1.tabpage_reassign_cases.uo_reassigncases.tab_details.tabpage_preview.Enabled = TRUE
//		END IF
//	END IF
//	
//	l_nNumSelected =  THIS.fu_GetSelectedRows(l_nSelected[])
//	
//	IF l_nNumSelected > 1 THEN
//		m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
//		m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
//	
//	ELSE 
//		l_nRow = THIS.GetRow()
//		
//		// Get Security level of Case
//		
//		IF l_bAccessOK THEN
//			m_supervisor_portal.m_file.m_casedetail.Enabled = TRUE
//			m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = TRUE
//		ELSE
//			m_supervisor_portal.m_file.m_casedetail.Enabled = FALSE
//			m_supervisor_portal.m_file.m_viewcasedetailreport.Enabled = FALSE
//		END IF
//	
//	END IF
//	
//END IF
end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Open the selected case
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  12/05/00 c. jackson  Original Version
//  3/4/2002 K. Claver   Modified to use the new version of the case search event
//
//***********************************************************************************************

w_create_maintain_case l_wCaseWindow
String l_cCaseNumber

IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN
		l_cCaseNumber = THIS.GetItemString( row, "case_log_case_number" )
		
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			
			// Open w_create_maintain_case
			FWCA.MGR.fu_OpenWindow(w_create_maintain_case, -1)
			l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet()
			
			IF IsValid (l_wCaseWindow) THEN
				
				// Make sure the window is on the Search tab
				IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
					l_wCaseWindow.dw_folder.fu_SelectTab(1)
				END IF
				
				// call ue_casesearch to process the query after the window is fully initialized.
				l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber )
				
			END IF						

		END IF
	END IF
END IF


end event

event constructor;call super::constructor;this.object.l_1.x1 = 4
end event

