$PBExportHeader$u_tabpage_options_rightfax.sru
$PBExportComments$Carve Out Options preferences tab
forward
global type u_tabpage_options_rightfax from u_container_std
end type
type cbx_rt_groups from checkbox within u_tabpage_options_rightfax
end type
type cbx_rt_providers from checkbox within u_tabpage_options_rightfax
end type
type cbx_rt_members from checkbox within u_tabpage_options_rightfax
end type
type cbx_blankreport from checkbox within u_tabpage_options_rightfax
end type
type gb_blankreport from groupbox within u_tabpage_options_rightfax
end type
type gb_realtime from groupbox within u_tabpage_options_rightfax
end type
end forward

global type u_tabpage_options_rightfax from u_container_std
integer width = 1929
integer height = 1560
boolean border = false
string text = "Other"
event ue_initpage ( )
event ue_savepage ( )
cbx_rt_groups cbx_rt_groups
cbx_rt_providers cbx_rt_providers
cbx_rt_members cbx_rt_members
cbx_blankreport cbx_blankreport
gb_blankreport gb_blankreport
gb_realtime gb_realtime
end type
global u_tabpage_options_rightfax u_tabpage_options_rightfax

type variables
BOOLEAN				i_bFirstOpen

STRING				i_cAvailabilityValues[16]

W_SYSTEM_OPTIONS	i_wParentWindow

GraphicObject     i_goControl
end variables

event ue_initpage();//********************************************************************************************
//
//  Event:   ue_initpage
//  Purpose: Initialize the interface for this page
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  01/30/03 C. Jackson  Original Version
//********************************************************************************************

INTEGER	l_nRow, l_nMaxRows
STRING	l_cOption, l_cValue


// prevent resetting the next time this tab is selected.
IF i_bFirstOpen THEN
	
	i_bFirstOpen = FALSE

	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount ()
	FOR l_nRow = 1 TO l_nMaxRows

		l_cOption = Upper (i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_name'))
		l_cValue = i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_value')

		CHOOSE CASE l_cOption
			CASE 'RIGHTFAX_TABENABLED'
				IF l_cValue = 'Y' THEN
					cbx_blankreport.Checked = TRUE
				ELSE
					cbx_blankreport.Checked = FALSE
				END IF
				
//			CASE 'REALTIME_MEMBERS'
//				IF l_cValue = 'Y' THEN
//					cbx_rt_members.Checked = TRUE
//				ELSE
//					cbx_rt_members.Checked = FALSE
//				END IF
//			
//			CASE 'REALTIME_PROVIDERS'
//				IF l_cValue = 'Y' THEN
//					cbx_rt_providers.Checked = TRUE
//				ELSE
//					cbx_rt_providers.Checked = FALSE
//				END IF
//				
//			CASE 'REALTIME_GROUPS'
//				IF l_cValue = 'Y' THEN
//					cbx_rt_groups.Checked = TRUE
//				ELSE
//					cbx_rt_groups.Checked = FALSE
//				END IF
				
		END CHOOSE

	NEXT
	
END IF
end event

event ue_savepage();//*********************************************************************************************
//
//  Event:   ue_savepage
//  Purpose: Save the options
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  01/30/03 C. Jackson  Original Version
//*********************************************************************************************

LONG		l_nRow, l_nNumValue, l_nMaxRows, l_nIndex
STRING	l_cOption, l_cValue

IF NOT i_wParentWindow.i_bSaveFailed THEN

	l_nMaxRows = i_wParentWindow.i_dsOptions.RowCount ()
	FOR l_nRow = 1 to l_nMaxRows
		l_cOption = Upper (i_wParentWindow.i_dsOptions.GetItemString (l_nRow, 'option_name'))
		CHOOSE CASE l_cOption
			CASE 'RIGHTFAX_TABENABLED'
				IF cbx_blankreport.Checked THEN
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
				ELSE
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
				END IF
				
//			CASE 'REALTIME_MEMBERS'
//				IF cbx_rt_members.Checked THEN
//					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
//				ELSE
//					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
//				END IF
//				
//			CASE 'REALTIME_PROVIDERS'
//				IF cbx_rt_providers.Checked THEN
//					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
//				ELSE
//					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
//				END IF
//				
//			CASE 'REALTIME_GROUPS'
//				IF cbx_rt_groups.Checked THEN
//					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
//				ELSE
//					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
//				END IF
				
		END CHOOSE
		
	NEXT
	
	i_wParentWindow.i_bSaveFailed = FALSE
	i_wParentWindow.i_bCloseWindow = TRUE
	
END IF


end event

on u_tabpage_options_rightfax.create
int iCurrent
call super::create
this.cbx_rt_groups=create cbx_rt_groups
this.cbx_rt_providers=create cbx_rt_providers
this.cbx_rt_members=create cbx_rt_members
this.cbx_blankreport=create cbx_blankreport
this.gb_blankreport=create gb_blankreport
this.gb_realtime=create gb_realtime
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_rt_groups
this.Control[iCurrent+2]=this.cbx_rt_providers
this.Control[iCurrent+3]=this.cbx_rt_members
this.Control[iCurrent+4]=this.cbx_blankreport
this.Control[iCurrent+5]=this.gb_blankreport
this.Control[iCurrent+6]=this.gb_realtime
end on

on u_tabpage_options_rightfax.destroy
call super::destroy
destroy(this.cbx_rt_groups)
destroy(this.cbx_rt_providers)
destroy(this.cbx_rt_members)
destroy(this.cbx_blankreport)
destroy(this.gb_blankreport)
destroy(this.gb_realtime)
end on

event pc_setvariables;call super::pc_setvariables;//*********************************************************************************************
//
//  Event:   pc_setvariables
//  Purpose: initialize instance variables for this page
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  01/30/03 C. Jackson  Original Version
//
//*********************************************************************************************

i_bFirstOpen = TRUE

i_wParentWindow = w_system_options
end event

type cbx_rt_groups from checkbox within u_tabpage_options_rightfax
boolean visible = false
integer x = 192
integer y = 612
integer width = 1111
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enable Real-Time for Employer Groups"
end type

type cbx_rt_providers from checkbox within u_tabpage_options_rightfax
boolean visible = false
integer x = 192
integer y = 520
integer width = 896
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enable Real-Time for Providers"
end type

type cbx_rt_members from checkbox within u_tabpage_options_rightfax
boolean visible = false
integer x = 192
integer y = 428
integer width = 896
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enable Real-Time for Members"
end type

type cbx_blankreport from checkbox within u_tabpage_options_rightfax
integer x = 192
integer y = 132
integer width = 1467
integer height = 80
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Enable Fax table on Workdesk"
end type

type gb_blankreport from groupbox within u_tabpage_options_rightfax
boolean visible = false
integer x = 27
integer y = 312
integer width = 1801
integer height = 432
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Real-Time Demographics"
end type

type gb_realtime from groupbox within u_tabpage_options_rightfax
integer x = 27
integer y = 28
integer width = 1801
integer height = 236
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fax System Configuration"
end type

