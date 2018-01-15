$PBExportHeader$w_std_reports.srw
$PBExportComments$Standard reports window
forward
global type w_std_reports from w_main_std
end type
type uo_folder from u_folder within w_std_reports
end type
end forward

global type w_std_reports from w_main_std
integer width = 3653
integer height = 1908
string title = "Standard Reports"
string menuname = "m_std_reports"
boolean maxbox = false
boolean resizable = false
long backcolor = 79748288
event ue_print pbm_custom01
uo_folder uo_folder
end type
global w_std_reports w_std_reports

type variables
U_STD_REPORTS		iuo_std_reports
U_STD_PRINT_PREVIEW	iou_std_print_preview
STRING			is_current_dataobject
end variables

event ue_print;call super::ue_print;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			w_std_reports
		Event:			ue_print
		Abstract:		Trigger the event to print the datawindow
----------------------------------------------------------------------------------------*/
WINDOWOBJECT	lwo_objects[]

IF IsValid(iou_std_print_preview) THEN

	IF uo_folder.i_CurrentTab <> 2 THEN
		iou_std_print_preview.TriggerEvent("ue_refresh")
	END IF

	iou_std_print_preview.TriggerEvent("ue_print")

ELSE

	OpenUserObject(iou_std_print_preview,51,169)
	lwo_objects[1] = iou_std_print_preview
	uo_folder.fu_AssignTab(2,lwo_objects)
	iou_std_print_preview.PostEvent("ue_print")

END IF

end event

event pc_setoptions;call super::pc_setoptions;/*----------------------------------------------------------------------------------------
		Application:	Customer Focus 1.0

		Object:			w_std_reports
		Event:			pc_setoptions
		Abstract:		Set up this window and the folder object
		
     Revisions: Developer     Date     Description
	             ============= ======== ==================================================
		          M. Caruso     05/21/99 Change toolbar initialization from c_ToolbarLeft
					                        to c_ToolbarTop

----------------------------------------------------------------------------------------*/
WINDOWOBJECT	lwo_objects[]

fw_SetOptions(c_default + c_ToolBarTop)	//RAE  4/5/99; MPC   5/21/99

uo_folder.fu_TabOptions("Arial",9,uo_folder.c_DefaultVisual)
uo_folder.fu_TabCurrentOptions("Arial",9,uo_folder.c_DefaultVisual)
uo_folder.fu_TabDisableOptions("Arial",9,uo_folder.c_TextDisableRegular)

uo_folder.fu_AssignTab(1,"Standard Report Catalog" )
uo_folder.fu_AssignTab(2,"Print Preview")

OpenUserObject(iuo_std_reports,23,104)
lwo_objects[1] = iuo_std_reports
uo_folder.fu_AssignTab(1,lwo_objects)

uo_folder.fu_folderCreate(2,2)

uo_folder.fu_DisableTab(2)
m_std_reports.m_file.m_printreport.Enabled = FALSE

uo_folder.fu_SelectTab(1)
end event

on w_std_reports.create
int iCurrent
call super::create
if this.MenuName = "m_std_reports" then this.MenuID = create m_std_reports
this.uo_folder=create uo_folder
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_folder
end on

on w_std_reports.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_folder)
end on

type uo_folder from u_folder within w_std_reports
integer y = 4
integer width = 3634
integer height = 1720
integer taborder = 10
end type

event po_tabclicked;call super::po_tabclicked;/*----------------------------------------------------------------------------------------
		Application:	Cusotomer Focus 1.0

		Object:			uo_folder
		Event:			po_tabclicked
		Abstract:		Set up the print preview tab if necessary and trigger the retrieve
		
		Revisions:
		Date     Developer     Description
		======== ============= =============================================================
		3/22/00  M. Caruso     Set focus to dw_std_reports when switch back to tab 1
----------------------------------------------------------------------------------------*/
WINDOWOBJECT	lwo_objects[]

CHOOSE CASE i_SelectedTabName

   CASE "Standard Reports"
		
   CASE "Print Preview"

		IF NOT IsValid(iou_std_print_preview) THEN
			OpenUserObject(iou_std_print_preview,23,104)
			lwo_objects[1] = iou_std_print_preview
			uo_folder.fu_AssignTab(2,lwo_objects)
		ELSE
			iou_std_print_preview.TriggerEvent("ue_refresh")
		END IF

		m_std_reports.m_file.m_printreport.Enabled = TRUE

END CHOOSE

end event

