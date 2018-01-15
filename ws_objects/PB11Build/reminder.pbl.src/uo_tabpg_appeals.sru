$PBExportHeader$uo_tabpg_appeals.sru
forward
global type uo_tabpg_appeals from u_tabpg_std
end type
type uo_search_appealtracker from u_search_appealtracker within uo_tabpg_appeals
end type
type gb_1 from groupbox within uo_tabpg_appeals
end type
type gb_2 from groupbox within uo_tabpg_appeals
end type
end forward

global type uo_tabpg_appeals from u_tabpg_std
integer width = 3602
integer height = 1612
string text = "Open Cases"
event ue_refresh ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
uo_search_appealtracker uo_search_appealtracker
gb_1 gb_1
gb_2 gb_2
end type
global uo_tabpg_appeals uo_tabpg_appeals

type variables
W_REMINDERS		i_wParentWindow
uo_tab_workdesk  i_tabParentTab
Boolean i_bNeedRefresh = FALSE

string	is_run_for_login

n_column_sizing_service in_columnsizingservice
n_datawindow_graphic_service_manager in_datawindow_graphic_service_manager
u_filter_strip	iu_filter
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
DataWindowChild dwc_keyword
INTEGER li_return

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

	li_return = uo_search_appealtracker.dw_report.GetChild("key_word_1", dwc_keyword)
	dwc_keyword.SetTransObject(sqlca)
	dwc_keyword.Retrieve()
	li_return = uo_search_appealtracker.dw_report.GetChild("key_word_2", dwc_keyword)
	dwc_keyword.SetTransObject(sqlca)
	dwc_keyword.Retrieve()
	
	uo_search_appealtracker.of_set_conf_level(i_wParentWindow.i_nRepConfidLevel ) 
	uo_search_appealtracker.TriggerEvent('ue_retrieve')
	
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
THIS.uo_search_appealtracker.dw_report.SetFocus( )
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

on uo_tabpg_appeals.create
int iCurrent
call super::create
this.uo_search_appealtracker=create uo_search_appealtracker
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search_appealtracker
this.Control[iCurrent+2]=this.gb_1
this.Control[iCurrent+3]=this.gb_2
end on

on uo_tabpg_appeals.destroy
call super::destroy
destroy(this.uo_search_appealtracker)
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
//	THIS.inv_resize.of_Register( st_notes, THIS.inv_resize.FIXEDBOTTOM )
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
//uo_search_appealtracker.height = ll_upper_height - 120
//gb_1.height = uo_search_appealtracker.height + 70
//
//gb_2.y = gb_1.y + gb_1.height + 20
//gb_2.height = ll_lower_height - 20
//
//dw_preview.height = gb_2.height - 120
//dw_preview.y = gb_2.y + 60
//
////st_notes.y = gb_2.y + (gb_2.height / 2)
////st_notes.x = gb_2.x + (gb_2.width / 2) - (st_notes.width/2)
//
//gb_1.Width = ll_width - (2 * gb_1.x)
//gb_2.Width = gb_1.Width
//
//uo_search_appealtracker.Width = gb_1.Width - 55
//dw_preview.Width = gb_1.Width - 55


uo_search_appealtracker.height = this.height - (2 * uo_search_appealtracker.y)
uo_search_appealtracker.width = this.width - (2 * uo_search_appealtracker.x )
end event

type uo_search_appealtracker from u_search_appealtracker within uo_tabpg_appeals
integer x = 18
integer y = 16
integer width = 3511
integer height = 1584
integer taborder = 50
end type

on uo_search_appealtracker.destroy
call u_search_appealtracker::destroy
end on

event constructor;call super::constructor;i_wParentWindow = Parent.i_wParentWindow
end event

type gb_1 from groupbox within uo_tabpg_appeals
boolean visible = false
integer x = 14
integer y = 4
integer width = 3557
integer height = 132
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Open Appeals"
end type

type gb_2 from groupbox within uo_tabpg_appeals
boolean visible = false
integer x = 14
integer y = 1036
integer width = 3557
integer height = 556
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Appeal Preview"
end type

