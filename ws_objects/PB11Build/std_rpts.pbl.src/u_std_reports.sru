$PBExportHeader$u_std_reports.sru
$PBExportComments$List of standard reports
forward
global type u_std_reports from u_container_std
end type
type dw_std_reports from u_dw_std within u_std_reports
end type
end forward

global type u_std_reports from u_container_std
integer width = 3579
integer height = 1592
boolean border = false
dw_std_reports dw_std_reports
end type
global u_std_reports u_std_reports

type variables
W_STD_REPORTS		iw_parent
STRING			is_current_dataobject
end variables

event pc_setvariables;call super::pc_setvariables;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			u_std_reports
		Event:			pc_setvariables
		Abstract:		Set up this tab's parent
----------------------------------------------------------------------------------------*/

iw_parent = PARENT
end event

event pc_setoptions;call super::pc_setoptions;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			u_std_reports
		Event:			pc_setoptions
		Abstract:		Set up the reports datawindow
----------------------------------------------------------------------------------------*/

dw_std_reports.fu_SetOptions( SQLCA, & 
 		dw_std_reports.c_NullDW, & 
 		dw_std_reports.c_SelectOnClick + &
 		dw_std_reports.c_NoInactiveRowPointer  ) 
end event

on u_std_reports.create
int iCurrent
call super::create
this.dw_std_reports=create dw_std_reports
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_std_reports
end on

on u_std_reports.destroy
call super::destroy
destroy(this.dw_std_reports)
end on

type dw_std_reports from u_dw_std within u_std_reports
event ue_selecttrigger pbm_dwnkey
integer x = 14
integer y = 12
integer width = 3547
integer height = 1540
string dataobject = "d_std_reports"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/25/99  M. Caruso     Created.

****************************************************************************************/

IF (key = KeyEnter!) AND (GetRow() > 0) THEN
	w_std_reports.uo_folder.fu_SelectTab (2)
	RETURN -1
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;//**********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: To retrieve data to the datawindow
//  
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  05/04/00 C. Jackson    Retrieve the datawindow object for the first report on the list (595)
//  
//**********************************************************************************************  

LONG	ll_rtn, l_nSelected[]

ll_rtn = THIS.Retrieve()

CHOOSE CASE ll_rtn
	CASE IS < 0
		Error.i_FWError = c_Fatal
		
	CASE 0
		Error.i_FWError = c_Success
		
	CASE IS > 0
		SetFocus ()
		l_nSelected[1] = 1
		fu_SetSelectedRows (1, l_nSelected[], c_IgnoreChanges, c_NoRefreshChildren)
		TriggerEvent ("clicked")
		Error.i_FWError = c_Success
		
END CHOOSE

// Retrieve the first datawindow object name
iw_parent.is_current_dataobject = THIS.GetItemString(i_CursorRow,"report_dtwndw_frmt_strng")


end event

event pcd_pickedrow;call super::pcd_pickedrow;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			dw_std_reports
		Event:			pcd_pickedrow
		Abstract:		Get the name of the dataobject and set up the instance variable
----------------------------------------------------------------------------------------*/

iw_parent.is_current_dataobject = THIS.GetItemString(i_CursorRow,"report_dtwndw_frmt_strng")
end event

event clicked;call super::clicked;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			dw_std_reports
		Event:			clicked - extended
		Abstract:		See if a row is highlighted and disable or enable the print preview
							tab if not
----------------------------------------------------------------------------------------*/

IF Error.i_FWError = c_Success THEN
	IF THIS.GetSelectedRow(0) < 1 THEN
		iw_parent.uo_folder.fu_DisableTab(2)
		m_std_reports.m_file.m_printreport.Enabled = FALSE
	ELSE
		iw_parent.uo_folder.fu_EnableTab(2)
		m_std_reports.m_file.m_printreport.Enabled = TRUE
	END IF
END IF

end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
	Event:	doubleclicked
	Purpose: Switch to the Print Preview tab displaying the selected report.
	
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	3/22/00  M. Caruso     Created based on doubleclicked event of dw_case_history on the
								  demographics screen.
*****************************************************************************************/

IF row > 0 THEN
	
	IF (dwo.Type = "column") OR (dwo.Type = "compute") THEN
		// if a row was selected, switch tabs.
		w_std_reports.uo_folder.fu_SelectTab(2)
		
	END IF
	
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Enable arrow key row selection

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/22/00  M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions( SQLCA, c_NullDW, c_SelectOnRowFocusChange)
end event

