$PBExportHeader$uo_tabpg_opencases.sru
forward
global type uo_tabpg_opencases from u_tabpg_std
end type
type st_notes from statictext within uo_tabpg_opencases
end type
type gb_1 from groupbox within uo_tabpg_opencases
end type
type gb_2 from groupbox within uo_tabpg_opencases
end type
type uo_search_open_cases from u_search_opencases within uo_tabpg_opencases
end type
end forward

global type uo_tabpg_opencases from u_tabpg_std
integer width = 3936
integer height = 1612
string text = "Inbox"
event ue_refresh ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
event ue_deletecopy ( )
st_notes st_notes
gb_1 gb_1
gb_2 gb_2
uo_search_open_cases uo_search_open_cases
end type
global uo_tabpg_opencases uo_tabpg_opencases

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
integer li_return

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

	uo_search_open_cases.of_set_conf_level(i_wParentWindow.i_nRepConfidLevel ) 
	uo_search_open_cases.TriggerEvent('ue_retrieve')
	
	//Refreshed.  Reset Variable.
	THIS.i_bNeedRefresh = FALSE
	
	THIS.i_tabParentTab.SetRedraw( TRUE )
END IF

IF this.picturename = "exclamation_icon.gif" THEN
	li_return = uo_search_open_cases.dw_report.find("case_viewed = 'N'", 1, uo_search_open_cases.dw_report.rowcount())
	IF li_return < 1 THEN
		this.picturename = ""
		i_wParentWindow.of_hide_systray_icon( )
	END IF
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
THIS.uo_search_open_cases.dw_report.SetFocus( )
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

event ue_deletecopy();Integer l_nRow, l_nSelectedRow[ 1 ]
String ls_case_number

IF uo_search_open_cases.dw_report.RowCount( ) > 0 THEN
	l_nRow = uo_search_open_cases.dw_report.GetRow(  )
	
	IF l_nRow > 0 THEN
		IF uo_search_open_cases.dw_report.Object.case_transfer_type[ l_nRow ] = "C" THEN
			ls_case_number = uo_search_open_cases.dw_report.Object.case_number[ l_nRow ]
			//Update the copy_deleted flag
			UPDATE cusfocus.case_transfer
			SET cusfocus.case_transfer.copy_deleted = 1
			WHERE cusfocus.case_transfer.case_number = :ls_Case_Number AND 
					cusfocus.case_transfer.case_transfer_type = 'C'
			USING SQLCA;

			uo_search_open_cases.dw_report.deleterow( l_nRow )

			l_nRow = uo_search_open_cases.dw_report.GetRow()
			IF l_nRow > 0 THEN
				uo_search_open_cases.dw_report.object.selectrowindicator[l_nRow] = 'Y'
				IF uo_search_open_cases.dw_report.Object.case_transfer_type[ l_nRow ] = "C" THEN
					m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
				ELSE
					m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
				END IF
			ELSE
				m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
			END IF
			
		END IF
	END IF
END IF
	
	
	
end event

on uo_tabpg_opencases.create
int iCurrent
call super::create
this.st_notes=create st_notes
this.gb_1=create gb_1
this.gb_2=create gb_2
this.uo_search_open_cases=create uo_search_open_cases
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_notes
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.uo_search_open_cases
end on

on uo_tabpg_opencases.destroy
call super::destroy
destroy(this.st_notes)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.uo_search_open_cases)
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

//??? RAP .Net is weird with resize!!!
#IF not defined PBDOTNET THEN
	uo_search_open_cases.height = this.height - (2 * uo_search_open_cases.y)
	uo_search_open_cases.width = this.width - (2 * uo_search_open_cases.x )
#END IF

//Setredraw(TRUE)

end event

type st_notes from statictext within uo_tabpg_opencases
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

type gb_1 from groupbox within uo_tabpg_opencases
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

type gb_2 from groupbox within uo_tabpg_opencases
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

type uo_search_open_cases from u_search_opencases within uo_tabpg_opencases
integer x = 9
integer y = 8
integer taborder = 20
boolean bringtotop = true
end type

on uo_search_open_cases.destroy
call u_search_opencases::destroy
end on

event constructor;call super::constructor;//this.i_wParentWindow = W_REMINDERS
end event

