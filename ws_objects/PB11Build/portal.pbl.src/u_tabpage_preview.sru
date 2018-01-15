$PBExportHeader$u_tabpage_preview.sru
$PBExportComments$Critical Case Preview
forward
global type u_tabpage_preview from u_tabpg_std
end type
type st_nonotes from statictext within u_tabpage_preview
end type
type dw_critical_preview from u_dw_std within u_tabpage_preview
end type
end forward

global type u_tabpage_preview from u_tabpg_std
integer width = 2976
integer height = 616
long backcolor = 80269524
st_nonotes st_nonotes
dw_critical_preview dw_critical_preview
end type
global u_tabpage_preview u_tabpage_preview

type variables
BOOLEAN i_bStopQuery = TRUE
end variables

forward prototypes
public subroutine of_setstopquery (boolean stop_query)
end prototypes

public subroutine of_setstopquery (boolean stop_query);//*******************************************************************************
//
//  Function: of_SetStopQuery
//  Purpose:  To set the stop query instance variable
//  
//  Date     Developer   Description
//  -------- ----------- --------------------------------------------------------
//  10/10/00 C. Jackson  Original Version
//
//*******************************************************************************

i_bStopQuery = stop_query
end subroutine

on u_tabpage_preview.create
int iCurrent
call super::create
this.st_nonotes=create st_nonotes
this.dw_critical_preview=create dw_critical_preview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nonotes
this.Control[iCurrent+2]=this.dw_critical_preview
end on

on u_tabpage_preview.destroy
call super::destroy
destroy(this.st_nonotes)
destroy(this.dw_critical_preview)
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
	THIS.inv_resize.of_Register( dw_critical_preview, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF
end event

type st_nonotes from statictext within u_tabpage_preview
boolean visible = false
integer x = 928
integer y = 272
integer width = 1115
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

type dw_critical_preview from u_dw_std within u_tabpage_preview
integer width = 2971
integer height = 612
integer taborder = 10
string dataobject = "d_supervisor_preview_pane"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

