$PBExportHeader$w_correspondence_history.srw
$PBExportComments$Window for viewing the history of a correspondence item.
forward
global type w_correspondence_history from w_response_std
end type
type dw_correspondence_history from u_dw_std within w_correspondence_history
end type
type dw_correspondence_info from u_dw_std within w_correspondence_history
end type
type cb_close from u_cb_close within w_correspondence_history
end type
end forward

global type w_correspondence_history from w_response_std
integer width = 2958
integer height = 1324
string title = "Correspondence History"
dw_correspondence_history dw_correspondence_history
dw_correspondence_info dw_correspondence_info
cb_close cb_close
end type
global w_correspondence_history w_correspondence_history

type variables
STRING	i_cCorrespondenceID
end variables

on w_correspondence_history.create
int iCurrent
call super::create
this.dw_correspondence_history=create dw_correspondence_history
this.dw_correspondence_info=create dw_correspondence_info
this.cb_close=create cb_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_correspondence_history
this.Control[iCurrent+2]=this.dw_correspondence_info
this.Control[iCurrent+3]=this.cb_close
end on

on w_correspondence_history.destroy
call super::destroy
destroy(this.dw_correspondence_history)
destroy(this.dw_correspondence_info)
destroy(this.cb_close)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pcd_setvariables
   Purpose:    Initialize instance variables for this window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/04/02 M. Caruso    Created.
*****************************************************************************************/

i_cCorrespondenceID = Message.StringParm
end event

type dw_correspondence_history from u_dw_std within w_correspondence_history
integer x = 23
integer y = 128
integer width = 2898
integer height = 944
integer taborder = 20
string dataobject = "d_crspnd_history_details"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve data.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/04/02 M. Caruso    Created.
*****************************************************************************************/

LONG		l_nRows
STRING	l_cMsg

l_nRows = Retrieve (i_cCorrespondenceID)
CHOOSE CASE l_nRows
	CASE IS < 0
		// an error occured
		l_cMsg = 'An error occured loading the correspondence history items.'
		
	CASE 0
		// the correspondence record has no history.  This is a problem
		l_cMsg = 'There are no history entries for the selected correspondence.'
		
	CASE ELSE
		// Good job!
		l_cMsg = ''
		
END CHOOSE

IF l_cMsg <> '' THEN	MessageBox (gs_appname, l_cMsg)
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize the datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/04/02 M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_NoEnablePopup + c_NoMenuButtonActivation)
end event

event buttonclicked;call super::buttonclicked;Long ll_hist_key
LONG							l_nRows[]
U_DW_STD						l_dwDocInfo
W_CREATE_MAINTAIN_CASE	l_wParentWindow
S_DOC_INFO					l_sDocInfo[]

l_wParentWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet()

IF IsValid(l_wParentWindow) THEN

	ll_hist_key = THIS.Object.correspondence_hist_key[row]
	
	l_dwDocInfo = l_wParentWindow.i_uoCaseCorrespondence.dw_correspondence_list
	l_dwDocInfo.fu_GetSelectedRows (l_nRows[])
	// gather correspondence details
	l_sDocInfo[1].a_cDocID = "History: " + String(ll_hist_key)
	l_sDocInfo[1].a_cDocName = l_dwDocInfo.GetItemString (l_nRows[1], 'letter_types_letter_name')
	l_sDocInfo[1].a_cCaseNumber = l_wParentWindow.i_cCurrentCase
	l_sDocInfo[1].a_cCaseType = l_wParentWindow.i_cCaseType
	l_sDocInfo[1].a_dtSent = l_dwDocInfo.GetItemDateTime (l_nRows[1], 'correspondence_corspnd_sent')
	l_sDocInfo[1].a_bFilled = TRUE

	IF NOT IsValid(l_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr) THEN
		l_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr = CREATE U_CORRESPONDENCE_MGR
	END IF
	l_wParentWindow.i_uoCaseCorrespondence.i_uoDocMgr.uf_processdocs (l_sDocInfo[], FALSE, FALSE)

END IF



end event

type dw_correspondence_info from u_dw_std within w_correspondence_history
integer x = 37
integer y = 24
integer width = 1975
integer height = 88
integer taborder = 10
string dataobject = "d_cpsnd_history_info"
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize the datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/04/02 M. Caruso    Created.
*****************************************************************************************/

fu_setOptions (SQLCA, c_NullDW, c_NoEnablePopup + &
										  c_NoMenuButtonActivation)
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve data.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	01/04/02 M. Caruso    Created.
*****************************************************************************************/

LONG		l_nRows
STRING	l_cMsg

l_nRows = Retrieve (i_cCorrespondenceID)
CHOOSE CASE l_nRows
	CASE IS < 0
		// an error occured
		l_cMsg = 'An error occured loading the correspondence history information.'
		
	CASE 0
		// the correspondence record was not found
		l_cMsg = 'The selected correspondence entry was not found.'
		
	CASE 1
		// continue retrieval of the detail list
		l_cMsg = ''
		
	CASE ELSE
		// more than one record matched.  This is a problem
		l_cMsg = 'Multiple correspondence entries were found. Please notify your system administrator.'
		
END CHOOSE

IF l_cMsg <> '' THEN
	MessageBox (gs_appname, l_cMsg)
END IF
end event

type cb_close from u_cb_close within w_correspondence_history
integer x = 2327
integer y = 1096
integer width = 411
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean default = true
end type

