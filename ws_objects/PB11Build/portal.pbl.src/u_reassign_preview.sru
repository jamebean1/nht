$PBExportHeader$u_reassign_preview.sru
$PBExportComments$Case preview datawindow
forward
global type u_reassign_preview from u_tabpg_std
end type
type st_nonotes from statictext within u_reassign_preview
end type
type dw_reassign_preview from u_dw_std within u_reassign_preview
end type
end forward

global type u_reassign_preview from u_tabpg_std
integer width = 2976
integer height = 700
long backcolor = 80269524
st_nonotes st_nonotes
dw_reassign_preview dw_reassign_preview
end type
global u_reassign_preview u_reassign_preview

type variables

end variables

on u_reassign_preview.create
int iCurrent
call super::create
this.st_nonotes=create st_nonotes
this.dw_reassign_preview=create dw_reassign_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nonotes
this.Control[iCurrent+2]=this.dw_reassign_preview
end on

on u_reassign_preview.destroy
call super::destroy
destroy(this.st_nonotes)
destroy(this.dw_reassign_preview)
end on

event constructor;call super::constructor;//**********************************************************************************************
//
//  Event:   constructor
//  Purpose: To initialize resize service
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/16/00 C. Jackson  Original Version
//
//**********************************************************************************************

//Initialize the resize service
THIS.of_SetResize( TRUE )

//Set the datawindows to scale to right and bottom
IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( dw_reassign_preview, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF
end event

type st_nonotes from statictext within u_reassign_preview
boolean visible = false
integer x = 818
integer y = 324
integer width = 1330
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "There are no notes for this case."
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_reassign_preview from u_dw_std within u_reassign_preview
integer y = 24
integer width = 2967
integer height = 664
integer taborder = 10
string dataobject = "d_supervisor_preview_pane"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;//LONG		ll_rtn
//STRING	ls_CaseNumber
//
//IF (parent_dw.RowCount () > 0) THEN
//	ls_CaseNumber = parent_dw.GetItemString (Selected_Rows[num_selected], "case_number")
//ELSE
//	ls_CaseNumber = ''
//END IF
//
//ll_rtn = retrieve (ls_CaseNumber, i_wParentWindow.i_nRepConfidLevel)
end event

