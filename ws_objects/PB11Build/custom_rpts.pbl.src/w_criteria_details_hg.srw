$PBExportHeader$w_criteria_details_hg.srw
$PBExportComments$Window used to select multiple retrieval args.
forward
global type w_criteria_details_hg from w_response
end type
type cb_cancel from commandbutton within w_criteria_details_hg
end type
type cb_ok from commandbutton within w_criteria_details_hg
end type
type dw_details from u_dw_std within w_criteria_details_hg
end type
end forward

global type w_criteria_details_hg from w_response
integer width = 1280
integer height = 1348
string title = "Selection"
cb_cancel cb_cancel
cb_ok cb_ok
dw_details dw_details
end type
global w_criteria_details_hg w_criteria_details_hg

type variables
LONG i_nReturn
STRING i_cDetailView
STRING i_cSourceType

BOOLEAN i_bCancel

w_report_parms_hg i_wParentWindow
end variables

on w_criteria_details_hg.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_details=create dw_details
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_details
end on

on w_criteria_details_hg.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_details)
end on

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To Set the options
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//**********************************************************************************************

fw_SetOptions (c_NoEnablePopup)

dw_details.fu_Swap(i_cDetailView, dw_details.c_IgnoreChanges, &
									dw_details.c_SelectOnClick + &
									dw_details.c_MultiSelect + &
									dw_details.c_NoEnablePopup + &
									dw_details.c_NoMenuButtonActivation + &
									dw_details.c_SortClickedOK )

dw_details.SetTransObject(SQLCA)

dw_details.fu_Retrieve(dw_details.c_IgnoreChanges, dw_details.c_ReselectRows)

IF i_nReturn < 12 THEN
	dw_details.Width = 1090
END IF
	


end event

event pc_setvariables;call super::pc_setvariables;//*******************************************************************************************
//
//  Event:   pc_setvariables
//  Purpose: Get vars from message.stringparm
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------------------
//  03/21/02 C. Jackson  Original Version
//*******************************************************************************************

i_cDetailView = w_report_parms_hg.i_cDetailView
i_cSourceType = w_report_parms_hg.i_cSourceType


end event

event pc_closequery;call super::pc_closequery;//**********************************************************************************************
//
//  Event:   pc_closequery
//  Purpose: Get the values selected by the user
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  03/18/02 C. Jackson  Original Version
//**********************************************************************************************

STRING l_cString, l_cDWColumn, l_cDisplayColumn
LONG  l_nNumRows, l_nSelectedRows[ ], l_nIndex

IF NOT i_bCancel THEN
	
	l_nNumRows = dw_details.fu_GetSelectedRows(l_nSelectedRows[])
	
	CHOOSE CASE dw_details.DataObject
		CASE 'd_lob_mbr_hg'
			l_cDWColumn = 'consum_generic_1'
			l_cDisplayColumn = 'sle_lob'
			
		CASE 'd_lob_grp_hg'
			l_cDWColumn = 'employ_generic_3'
			l_cDisplayColumn = 'sle_lob'
			
		CASE 'd_region_mbr_hg'
			l_cDWColumn = 'consum_generic_2'
			l_cDisplayColumn = 'sle_region'
			
		CASE 'd_region_grp_hg'
			l_cDWColumn = 'employ_generic_2'
			l_cDisplayColumn = 'sle_region'
			
		CASE 'd_con_group_mbr_hg'
			l_cDWColumn = 'group_id'
			l_cDisplayColumn = 'sle_con_group'
			
		CASE 'd_con_group_grp_hg'
			l_cDWColumn = 'employ_generic_5'
			l_cDisplayColumn = 'sle_con_group'
			
		CASE 'd_group_id_mbr_hg'
			l_cDWColumn = 'consum_generic_3'
			l_cDisplayColumn = 'sle_group_id'
			
		CASE 'd_group_id_grp_hg'
			l_cDWColumn = 'group_id'
			l_cDisplayColumn = 'sle_group_id'
			
		CASE 'd_prof_id_mbr_hg'
			l_cDWColumn = 'prof_id'
			l_cDisplayColumn = 'sle_pcp'
			
	END CHOOSE
	
	FOR l_nIndex = 1 TO l_nNumRows
	
		IF l_nIndex = 1 THEN
			l_cString = dw_details.GetItemString(l_nSelectedRows[l_nIndex],l_cDWColumn)
		ELSE
			l_cString = l_cString +';'+dw_details.GetItemString(l_nSelectedRows[l_nIndex],l_cDWColumn)
			
		END IF
		
	NEXT
	
	Message.stringparm = l_cString

END IF
end event

type cb_cancel from commandbutton within w_criteria_details_hg
integer x = 896
integer y = 1128
integer width = 320
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ca&ncel"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Close with no parameters
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//***********************************************************************************************

i_bCancel = TRUE

CLOSE(Parent)
end event

type cb_ok from commandbutton within w_criteria_details_hg
integer x = 544
integer y = 1128
integer width = 320
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: Close with parameters
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//***********************************************************************************************

CLOSE(Parent)
end event

type dw_details from u_dw_std within w_criteria_details_hg
integer x = 55
integer y = 16
integer width = 1161
integer height = 1080
integer taborder = 10
string dataobject = ""
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;//*********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: to retrieve the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  03/15/02 C. Jackson  Original Version
//*********************************************************************************************

i_nReturn = THIS.Retrieve()


end event

event pcd_setoptions;call super::pcd_setoptions;//************************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: to set the datawindow options
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  03/28/02 C. Jackson  Original Version
//************************************************************************************************

fu_SetOptions(SQLCA, dw_details.c_NullDW, &
				dw_details.c_NoRetrieveOnOpen + &
				dw_details.c_MultiSelect + &
				dw_details.c_SelectOnClick + &
				dw_details.c_NoEnablePopup + &
				dw_details.c_NoMenubuttonActivation)





end event

