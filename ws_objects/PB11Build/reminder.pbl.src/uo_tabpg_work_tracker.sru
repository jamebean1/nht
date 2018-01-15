$PBExportHeader$uo_tabpg_work_tracker.sru
forward
global type uo_tabpg_work_tracker from u_tabpg_std
end type
type uo_search_work_tracker from u_search_work_tracker within uo_tabpg_work_tracker
end type
type st_notes from statictext within uo_tabpg_work_tracker
end type
type gb_1 from groupbox within uo_tabpg_work_tracker
end type
type gb_2 from groupbox within uo_tabpg_work_tracker
end type
end forward

global type uo_tabpg_work_tracker from u_tabpg_std
integer width = 3936
integer height = 1612
string text = "Inbox"
event ue_refresh ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
event ue_delete_work_tracker ( )
event ue_set_new_icon ( )
event ue_remove_new_icon ( )
uo_search_work_tracker uo_search_work_tracker
st_notes st_notes
gb_1 gb_1
gb_2 gb_2
end type
global uo_tabpg_work_tracker uo_tabpg_work_tracker

type variables
W_REMINDERS		i_wParentWindow
uo_tab_workdesk  i_tabParentTab
Boolean i_bNeedRefresh = FALSE
end variables

event ue_refresh();//***********************************************************************************************
//
//  Event:   ue_Refresh
//  Purpose: Refresh the data
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************
long ll_NewRow, ll_row

IF THIS.i_bNeedRefresh THEN
	THIS.i_tabParentTab.SetRedraw( FALSE )	
	
//	dw_opencases.fu_Retrieve( dw_opencases.c_IgnoreChanges, &
//									  dw_opencases.c_ReselectRows )								  
//									  
//	//Need to manually retrieve the child datawindows on refresh
//	//  as the non-PowerClass tab architecture doesn't handle the
//	//  retrieve of the child datawindows(with the exception of
//	//  rowfocuschange in the parent datawindow).
//	dw_preview.fu_Retrieve( dw_preview.c_IgnoreChanges, &
//									dw_preview.c_ReselectRows )

	uo_search_work_tracker.of_set_conf_level(i_wParentWindow.i_nRepConfidLevel ) 
	uo_search_work_tracker.TriggerEvent('ue_retrieve')
	THIS.Event ue_setmainfocus()
									
	//Refreshed.  Reset Variable.
	THIS.i_bNeedRefresh = FALSE
	
	THIS.i_tabParentTab.SetRedraw( TRUE )
END IF

end event

event ue_setmainfocus();//***********************************************************************************************
//
//  Event:   ue_SetMainFocus
//  Purpose: Set Focus to the main datawindow
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
THIS.uo_search_work_tracker.dw_report.SetFocus( )
end event

event ue_setneedrefresh;//***********************************************************************************************
//
//  Event:   ue_SetNeedRefresh
//  Purpose: Set variable to indicate that this tab needs to be refreshed when selected
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
THIS.i_bNeedRefresh = TRUE
end event

event ue_delete_work_tracker();Integer l_nRow, l_nSelectedRow[ 1 ]
String ls_case_number, ls_user_id

IF uo_search_work_tracker.dw_report.RowCount( ) > 0 THEN
	l_nRow = uo_search_work_tracker.dw_report.GetRow(  )
	
	IF l_nRow > 0 THEN
		ls_case_number = uo_search_work_tracker.dw_report.Object.case_number[ l_nRow ]
		//Remove the row from the work tracking table
		ls_User_ID = OBJCA.WIN.fu_GetLogin(SQLCA)
		
		DELETE cusfocus.work_tracking
		WHERE cusfocus.work_tracking.case_number = :ls_Case_Number AND 
				cusfocus.work_tracking.user_id = :ls_user_id
		USING SQLCA;

		uo_search_work_tracker.dw_report.deleterow( l_nRow )
		IF uo_search_work_tracker.dw_report.RowCount( ) > 0 THEN
			l_nRow = uo_search_work_tracker.dw_report.GetRow(  )
			uo_search_work_tracker.dw_report.object.selectrowindicator[l_nRow] = 'Y'
		END IF
			
	END IF
END IF
	
	
	
end event

event ue_set_new_icon();THIS.picturename =  "exclamation_icon.gif"

end event

event ue_remove_new_icon();THIS.picturename =  ""

end event

on uo_tabpg_work_tracker.create
int iCurrent
call super::create
this.uo_search_work_tracker=create uo_search_work_tracker
this.st_notes=create st_notes
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search_work_tracker
this.Control[iCurrent+2]=this.st_notes
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.gb_2
end on

on uo_tabpg_work_tracker.destroy
call super::destroy
destroy(this.uo_search_work_tracker)
destroy(this.st_notes)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   Constructor
//  Purpose: please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/24/2000 K. Claver   Added code to activate the resize service and register the objects
//  10/26/2000 M. Caruso   Added code to set the parent window reference
//***********************************************************************************************
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( gb_1, THIS.inv_resize.SCALERIGHTBOTTOM )
//	THIS.inv_resize.of_Register( dw_opencases, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( gb_2, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
//	THIS.inv_resize.of_Register( dw_preview, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( st_notes, THIS.inv_resize.FIXEDBOTTOM )
END IF

i_wParentWindow = W_REMINDERS


end event

event resize;//long	ll_upper_height, ll_lower_height, ll_width
//
////Setredraw(FALSE)
//
//ll_upper_height = Round(This.Height * .55, 0)
//ll_lower_height = Round(This.Height * .45, 0)
//ll_width = This.Width
//
//dw_opencases.height = ll_upper_height - 120
//gb_1.height = dw_opencases.height + 70
//
//gb_2.y = gb_1.y + gb_1.height + 20
//gb_2.height = ll_lower_height - 20
//
//dw_preview.height = gb_2.height - 120
//dw_preview.y = gb_2.y + 60
//
//st_notes.y = gb_2.y + (gb_2.height / 2)
//st_notes.x = gb_2.x + (gb_2.width / 2) - (st_notes.width/2)
//
//gb_1.Width = ll_width - (2 * gb_1.x)
//gb_2.Width = gb_1.Width
//
//dw_opencases.Width = gb_1.Width - 55
//dw_preview.Width = gb_1.Width - 55


uo_search_work_tracker.height = this.height - (2 * uo_search_work_tracker.y)
uo_search_work_tracker.width = this.width - (2 * uo_search_work_tracker.x )


//Setredraw(TRUE)

end event

type uo_search_work_tracker from u_search_work_tracker within uo_tabpg_work_tracker
event destroy ( )
integer x = 5
integer y = 16
integer taborder = 30
end type

on uo_search_work_tracker.destroy
call u_search_work_tracker::destroy
end on

type st_notes from statictext within uo_tabpg_work_tracker
boolean visible = false
integer x = 1385
integer y = 1308
integer width = 882
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 1090519039
string text = "There are no notes for this case."
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within uo_tabpg_work_tracker
boolean visible = false
integer x = 14
integer y = 4
integer width = 3557
integer height = 1032
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Open Cases"
end type

type gb_2 from groupbox within uo_tabpg_work_tracker
boolean visible = false
integer x = 14
integer y = 1036
integer width = 3557
integer height = 556
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Preview"
end type

