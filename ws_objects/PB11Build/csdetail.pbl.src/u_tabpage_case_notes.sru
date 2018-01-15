$PBExportHeader$u_tabpage_case_notes.sru
$PBExportComments$The Case Notes tab page
forward
global type u_tabpage_case_notes from u_tabpg_std
end type
type st_nonotes from statictext within u_tabpage_case_notes
end type
type dw_case_notes from u_dw_std within u_tabpage_case_notes
end type
end forward

global type u_tabpage_case_notes from u_tabpg_std
integer width = 3534
integer height = 784
string text = "Case Notes"
st_nonotes st_nonotes
dw_case_notes dw_case_notes
end type
global u_tabpage_case_notes u_tabpage_case_notes

type variables
W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder
end variables

on u_tabpage_case_notes.create
int iCurrent
call super::create
this.st_nonotes=create st_nonotes
this.dw_case_notes=create dw_case_notes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nonotes
this.Control[iCurrent+2]=this.dw_case_notes
end on

on u_tabpage_case_notes.destroy
call super::destroy
destroy(this.st_nonotes)
destroy(this.dw_case_notes)
end on

event constructor;call super::constructor;//**********************************************************************************************
//
//  Event:   constructor
//  Purpose: set values for instance variables
//
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  09/29/00 M. Caruso   Created.
//  10/31/00 M. Caruso   Add resize code.
//  04/13/01 K. Claver   Changed to correctly use the new resize service.
//  04/25/01 C. Jackson  Add resize for st_nonotes.
//
//**********************************************************************************************


i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder

THIS.of_SetResize( TRUE )
IF IsValid (THIS.inv_resize) THEN
	// resize the datawindow
	THIS.inv_resize.of_Register (dw_case_notes, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (st_nonotes, "ScaleToRight&Bottom")
END IF
end event

type st_nonotes from statictext within u_tabpage_case_notes
boolean visible = false
integer x = 1326
integer y = 356
integer width = 869
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "There are no notes for this case."
boolean focusrectangle = false
end type

type dw_case_notes from u_dw_std within u_tabpage_case_notes
integer x = 14
integer y = 12
integer width = 3497
integer height = 756
integer taborder = 10
string dataobject = "d_case_notes"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;//*********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: process the data retrieval for this datawindow.
//
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  09/29/00 M. Caruso   Created.
//  10/26/00 M. Caruso   Added security level as a second retrieval argument.
//  04/28/01 C. Jackson  Set st_nonotes visible if there are no notes for the selected case.
//  
//*********************************************************************************************

LONG ll_rtn


ll_rtn = retrieve (i_wParentWindow.i_cCurrentCase, i_wParentWindow.i_nRepConfidLevel)

IF ll_rtn < 0 THEN
	MessageBox (gs_AppName, 'There was an error retrieving the case notes for this case.')
	st_nonotes.Visible = TRUE
ELSEIF ll_rtn = 0 THEN
	st_nonotes.Visible = TRUE
ELSE
	st_nonotes.Visible = FALSE
END IF



end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Intialize this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	9/29/00  M. Caruso    Created.
	11/28/00 M. Caruso    Added c_NoMenuButtonActivation to the options list.
	2/28/2002 K. Claver   Added c_ModifyOK and c_ModifyOnOpen to the list of options for the
								 datawindow to allow the users to copy the prior case notes.  Set
								 the notes field to display only so they will not be able to modify.
*****************************************************************************************/
//fu_SetOptions (SQLCA, c_NullDW, c_NoShowEmpty + c_NoMenuButtonActivation + &
//					c_ModifyOK + c_ModifyOnOpen + c_HideHighlight )
					
fu_SetOptions (SQLCA, c_NullDW, c_NoShowEmpty + c_NoMenuButtonActivation + &
					c_ModifyOK + c_ModifyOnOpen + c_ShowHighlight + c_SelectonRowFocuschange )
end event

