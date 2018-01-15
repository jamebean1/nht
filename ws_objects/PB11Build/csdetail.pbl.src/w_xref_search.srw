$PBExportHeader$w_xref_search.srw
forward
global type w_xref_search from w_response
end type
type p_1 from picture within w_xref_search
end type
type st_2 from statictext within w_xref_search
end type
type st_1 from statictext within w_xref_search
end type
type uo_search_criteria from u_xref_search_criteria within w_xref_search
end type
type ln_1 from line within w_xref_search
end type
type ln_2 from line within w_xref_search
end type
type ln_3 from line within w_xref_search
end type
type ln_4 from line within w_xref_search
end type
end forward

global type w_xref_search from w_response
integer width = 2048
integer height = 1972
string title = "Search Provider"
long backcolor = 79748288
p_1 p_1
st_2 st_2
st_1 st_1
uo_search_criteria uo_search_criteria
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
end type
global w_xref_search w_xref_search

type variables
INT		i_nBaseWidth
INT		i_nBaseHeight
STRING	i_cSourceType
STRING	i_cSearchID
end variables

event pc_search;call super::pc_search;//********************************************************************************************
//
//  Event:   pc_search
//  Purpose: To perform search
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  06/08/01 C. Jackson  Original Version
//  06/26/01 C. Jackson  Remove no records message, taken care of by ancestry
//
//********************************************************************************************

LONG 		l_nRowsToSelect[]
STRING 	l_cNoRowsFound, l_cSourceType, l_cCurrUser
INT 		l_nResponse

IF Error.i_FWError = c_Fatal THEN RETURN

CHOOSE CASE uo_search_criteria.dw_matched_records.RowCount()
//	CASE 0
//		messagebox(gs_AppName,'There are no records that match your search.  Please try again.')
	CASE IS > 0
		l_nRowsToSelect[1] = 1
		uo_search_criteria.dw_matched_records.fu_SetSelectedRows(1, l_nRowsToSelect[], &
										uo_search_criteria.dw_matched_records.c_IgnoreChanges, &
										uo_search_criteria.dw_matched_records.c_NoRefreshChildren)
	
END CHOOSE


end event

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: Define the characteristics for the current window, including toolbar, datawindows, 
//           tabs, and MS Word location.
//
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  06/18/01 C. Jackson  Original Version
//  02/07/03 C. Jackson  Set checkbox based on previously defined Cross Reference Type
//  02/18/03 C. Jackson  Set focus to first column in search criteria datawindow
//***********************************************************************************************

long l_nRow
string l_cXRefSourceType

fw_SetOptions(c_Default + c_ToolbarTop )			

// initialize the resize service for this window
i_nBaseWidth = Width
i_nBaseHeight = Height - 76   // this offset value was needed to make the sizing correct.

of_SetResize (TRUE)

IF IsValid (inv_resize) THEN
	inv_resize.of_SetOrigSize ((Width - 30), (Height - 178))
	inv_resize.of_SetMinSize ((Width - 30), (Height - 178))
	
END IF

l_nRow = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details.GetRow()
l_cXRefSourceType = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details.GetItemString(l_nRow,'case_log_xref_source_type')

CHOOSE CASE w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.i_cXRefSourceType
		
	CASE 'C'
		uo_search_criteria.rb_group.Checked = FALSE
		uo_search_criteria.rb_provider.Checked = FALSE
		uo_search_criteria.rb_member.Checked = TRUE
	CASE 'E'
		uo_search_criteria.rb_provider.Checked = FALSE
		uo_search_criteria.rb_member.Checked = FALSE
		uo_search_criteria.rb_group.Checked = TRUE
	CASE ELSE
		uo_search_criteria.rb_group.Checked = FALSE
		uo_search_criteria.rb_member.Checked = FALSE
		uo_search_criteria.rb_provider.Checked = TRUE
END CHOOSE

uo_search_criteria.dw_search_criteria.SetFocus()
uo_search_criteria.dw_search_criteria.SetColumn(1)
end event

on w_xref_search.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_2=create st_2
this.st_1=create st_1
this.uo_search_criteria=create uo_search_criteria
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.uo_search_criteria
this.Control[iCurrent+5]=this.ln_1
this.Control[iCurrent+6]=this.ln_2
this.Control[iCurrent+7]=this.ln_3
this.Control[iCurrent+8]=this.ln_4
end on

on w_xref_search.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.uo_search_criteria)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event pc_closequery;call super::pc_closequery;//**********************************************************************************************
//
//  Event:   pc_closequery
//  Purpose: Please see PowerClass documentation for this event
//
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  2/21/2001 K. Claver    Added code to prevent the window from closing if in the middle of a search
//
//**********************************************************************************************
 
IF IsValid( THIS.uo_search_criteria ) THEN
 IF THIS.uo_search_criteria.i_bInSearch THEN
  Error.i_FWError = c_Fatal
 END IF
END IF

 
end event

event open;call super::open;//**********************************************************************************************
//
//  Event:   open
//  Purpose: Open the Xref Search Window with default Source Type
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  02/05/03 C. Jackson  Original Version
//**********************************************************************************************


end event

type p_1 from picture within w_xref_search
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_2 from statictext within w_xref_search
integer x = 201
integer y = 60
integer width = 1499
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Cross Reference Search"
boolean focusrectangle = false
end type

type st_1 from statictext within w_xref_search
integer width = 3392
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type uo_search_criteria from u_xref_search_criteria within w_xref_search
integer y = 192
integer width = 3182
integer height = 1704
integer taborder = 30
boolean border = false
end type

on uo_search_criteria.destroy
call u_xref_search_criteria::destroy
end on

type ln_1 from line within w_xref_search
long linecolor = 8421504
integer linethickness = 4
integer beginy = 184
integer endx = 3502
integer endy = 184
end type

type ln_2 from line within w_xref_search
long linecolor = 16777215
integer linethickness = 4
integer beginy = 188
integer endx = 3502
integer endy = 188
end type

type ln_3 from line within w_xref_search
boolean visible = false
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1828
integer endx = 3502
integer endy = 1828
end type

type ln_4 from line within w_xref_search
boolean visible = false
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1824
integer endx = 3502
integer endy = 1824
end type

