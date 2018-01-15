$PBExportHeader$u_tabpage_options_other.sru
$PBExportComments$Carve Out Options preferences tab
forward
global type u_tabpage_options_other from u_container_std
end type
type cbx_hide_sent_correspondence from checkbox within u_tabpage_options_other
end type
type em_workdeskrefresh from editmask within u_tabpage_options_other
end type
type st_2 from statictext within u_tabpage_options_other
end type
type st_1 from statictext within u_tabpage_options_other
end type
type cbx_rt_groups from checkbox within u_tabpage_options_other
end type
type cbx_rt_providers from checkbox within u_tabpage_options_other
end type
type cbx_rt_members from checkbox within u_tabpage_options_other
end type
type cbx_blankreport from checkbox within u_tabpage_options_other
end type
type gb_blankreport from groupbox within u_tabpage_options_other
end type
type gb_1 from groupbox within u_tabpage_options_other
end type
type gb_realtime from groupbox within u_tabpage_options_other
end type
type gb_2 from groupbox within u_tabpage_options_other
end type
end forward

global type u_tabpage_options_other from u_container_std
integer width = 1929
integer height = 1560
boolean border = false
string text = "Other"
event ue_initpage ( )
event ue_savepage ( )
cbx_hide_sent_correspondence cbx_hide_sent_correspondence
em_workdeskrefresh em_workdeskrefresh
st_2 st_2
st_1 st_1
cbx_rt_groups cbx_rt_groups
cbx_rt_providers cbx_rt_providers
cbx_rt_members cbx_rt_members
cbx_blankreport cbx_blankreport
gb_blankreport gb_blankreport
gb_1 gb_1
gb_realtime gb_realtime
gb_2 gb_2
end type
global u_tabpage_options_other u_tabpage_options_other

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
			CASE 'BLANK_REPORT'
				IF l_cValue = 'Y' THEN
					cbx_blankreport.Checked = TRUE
				ELSE
					cbx_blankreport.Checked = FALSE
				END IF
				
			CASE 'REALTIME_MEMBERS'
				IF l_cValue = 'Y' THEN
					cbx_rt_members.Checked = TRUE
				ELSE
					cbx_rt_members.Checked = FALSE
				END IF
			
			CASE 'REALTIME_PROVIDERS'
				IF l_cValue = 'Y' THEN
					cbx_rt_providers.Checked = TRUE
				ELSE
					cbx_rt_providers.Checked = FALSE
				END IF
				
			CASE 'REALTIME_GROUPS'
				IF l_cValue = 'Y' THEN
					cbx_rt_groups.Checked = TRUE
				ELSE
					cbx_rt_groups.Checked = FALSE
				END IF
				
			Case 'WORKDESK REFRESH RATE'
				IF l_nRow > 0 THEN
					em_workdeskrefresh.text = string(long(l_cValue)/60)
					em_workdeskrefresh.Enabled = TRUE
				Else
					em_workdeskrefresh.Enabled = FALSE
				End IF
				
			CASE 'HIDE SENT CORRESPONDENCE'
				IF l_cValue = 'Y' THEN
					cbx_hide_sent_correspondence.Checked = TRUE
				ELSE
					cbx_hide_sent_correspondence.Checked = FALSE
				END IF
				
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
			CASE 'BLANK_REPORT'
				IF cbx_blankreport.Checked THEN
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
				ELSE
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
				END IF
				
			CASE 'REALTIME_MEMBERS'
				IF cbx_rt_members.Checked THEN
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
				ELSE
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
				END IF
				
			CASE 'REALTIME_PROVIDERS'
				IF cbx_rt_providers.Checked THEN
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
				ELSE
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
				END IF
				
			CASE 'REALTIME_GROUPS'
				IF cbx_rt_groups.Checked THEN
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
				ELSE
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
				END IF
				
			CASE 'HIDE SENT CORRESPONDENCE'
				IF cbx_hide_sent_correspondence.Checked THEN
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'Y' )
				ELSE
					i_wParentWindow.i_dsOptions.SetItem(l_nRow, 'option_value', 'N' )
				END IF
				
			CASE 'WORKDESK REFRESH RATE'
				IF em_workdeskrefresh.Enabled THEN
					
					l_cValue = em_workdeskrefresh.Text
					l_nNumValue = LONG (l_cValue) 
					IF (l_nNumValue <= 0) THEN
						
						MessageBox (gs_appname, 'The refresh rate must be equal to or greater than 1.')
						i_wParentWindow.i_bSaveFailed = TRUE
						i_wParentWindow.i_bCloseWindow = FALSE
						em_workdeskrefresh.SetFocus ()
						em_workdeskrefresh.SelectText (1, Len (l_cValue))
						RETURN
						
					ELSE
						
						l_nRow = i_wParentWindow.i_dsOptions.Find ('option_name = "workdesk refresh rate"', 1, &
																				 i_wParentWindow.i_dsOptions.RowCount ())
						IF l_nRow > 0 THEN
							l_cValue = String(Long(l_cValue) * 60)
							i_wParentWindow.i_dsOptions.SetItem (l_nRow, 'option_value', l_cValue)
						ELSE
							
							MessageBox (gs_appname, 'Workdesk Refresh Rate option not found, so change will not ')
							i_wParentWindow.i_bSaveFailed = TRUE
							i_wParentWindow.i_bCloseWindow = TRUE
							RETURN
							
						END IF
						
					END IF
					
				END IF				
				
		END CHOOSE
		
	NEXT
	
	i_wParentWindow.i_bSaveFailed = FALSE
	i_wParentWindow.i_bCloseWindow = TRUE
	
END IF


end event

on u_tabpage_options_other.create
int iCurrent
call super::create
this.cbx_hide_sent_correspondence=create cbx_hide_sent_correspondence
this.em_workdeskrefresh=create em_workdeskrefresh
this.st_2=create st_2
this.st_1=create st_1
this.cbx_rt_groups=create cbx_rt_groups
this.cbx_rt_providers=create cbx_rt_providers
this.cbx_rt_members=create cbx_rt_members
this.cbx_blankreport=create cbx_blankreport
this.gb_blankreport=create gb_blankreport
this.gb_1=create gb_1
this.gb_realtime=create gb_realtime
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_hide_sent_correspondence
this.Control[iCurrent+2]=this.em_workdeskrefresh
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cbx_rt_groups
this.Control[iCurrent+6]=this.cbx_rt_providers
this.Control[iCurrent+7]=this.cbx_rt_members
this.Control[iCurrent+8]=this.cbx_blankreport
this.Control[iCurrent+9]=this.gb_blankreport
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_realtime
this.Control[iCurrent+12]=this.gb_2
end on

on u_tabpage_options_other.destroy
call super::destroy
destroy(this.cbx_hide_sent_correspondence)
destroy(this.em_workdeskrefresh)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cbx_rt_groups)
destroy(this.cbx_rt_providers)
destroy(this.cbx_rt_members)
destroy(this.cbx_blankreport)
destroy(this.gb_blankreport)
destroy(this.gb_1)
destroy(this.gb_realtime)
destroy(this.gb_2)
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

type cbx_hide_sent_correspondence from checkbox within u_tabpage_options_other
integer x = 197
integer y = 1168
integer width = 1216
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide Sent Correspondence Messagebox"
end type

type em_workdeskrefresh from editmask within u_tabpage_options_other
integer x = 942
integer y = 892
integer width = 137
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "#####"
double increment = 1
string minmax = "0~~10000"
end type

type st_2 from statictext within u_tabpage_options_other
integer x = 1102
integer y = 908
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "minutes"
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpage_options_other
integer x = 178
integer y = 908
integer width = 777
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Refresh the Workdesk every "
boolean focusrectangle = false
end type

type cbx_rt_groups from checkbox within u_tabpage_options_other
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

type cbx_rt_providers from checkbox within u_tabpage_options_other
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

type cbx_rt_members from checkbox within u_tabpage_options_other
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

type cbx_blankreport from checkbox within u_tabpage_options_other
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
string text = "Display Blank Report When No Information Returned"
end type

type gb_blankreport from groupbox within u_tabpage_options_other
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

type gb_1 from groupbox within u_tabpage_options_other
integer x = 27
integer y = 800
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
string text = "Workdesk Refresh Rate"
end type

type gb_realtime from groupbox within u_tabpage_options_other
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
string text = "Display Blank Report - Supervisor Portal Reports Only"
end type

type gb_2 from groupbox within u_tabpage_options_other
integer y = 1068
integer width = 1801
integer height = 236
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sent Correspondence Messagebox"
end type

