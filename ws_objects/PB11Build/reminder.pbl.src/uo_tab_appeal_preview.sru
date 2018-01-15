$PBExportHeader$uo_tab_appeal_preview.sru
forward
global type uo_tab_appeal_preview from u_tab_std
end type
type tabpage_case_preview from userobject within uo_tab_appeal_preview
end type
type dw_case_preview from u_datawindow within tabpage_case_preview
end type
type tabpage_case_preview from userobject within uo_tab_appeal_preview
dw_case_preview dw_case_preview
end type
type tabpage_appeal_preview from userobject within uo_tab_appeal_preview
end type
type dw_appeal_preview from u_datawindow within tabpage_appeal_preview
end type
type tabpage_appeal_preview from userobject within uo_tab_appeal_preview
dw_appeal_preview dw_appeal_preview
end type
end forward

global type uo_tab_appeal_preview from u_tab_std
integer width = 2190
integer height = 564
integer textsize = -8
boolean boldselectedtext = true
tabpage_case_preview tabpage_case_preview
tabpage_appeal_preview tabpage_appeal_preview
end type
global uo_tab_appeal_preview uo_tab_appeal_preview

on uo_tab_appeal_preview.create
this.tabpage_case_preview=create tabpage_case_preview
this.tabpage_appeal_preview=create tabpage_appeal_preview
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_case_preview
this.Control[iCurrent+2]=this.tabpage_appeal_preview
end on

on uo_tab_appeal_preview.destroy
call super::destroy
destroy(this.tabpage_case_preview)
destroy(this.tabpage_appeal_preview)
end on

type tabpage_case_preview from userobject within uo_tab_appeal_preview
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 2153
integer height = 444
long backcolor = 67108864
string text = "Case Preview / Notes"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_case_preview dw_case_preview
end type

on tabpage_case_preview.create
this.dw_case_preview=create dw_case_preview
this.Control[]={this.dw_case_preview}
end on

on tabpage_case_preview.destroy
destroy(this.dw_case_preview)
end on

type dw_case_preview from u_datawindow within tabpage_case_preview
integer width = 2149
integer height = 388
integer taborder = 10
string dataobject = "d_case_notes_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event retrievestart;call super::retrievestart;THIS.SetTransObject(SQLCA)
end event

type tabpage_appeal_preview from userobject within uo_tab_appeal_preview
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 2153
integer height = 444
long backcolor = 67108864
string text = "Appeal Preview / Events"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_appeal_preview dw_appeal_preview
end type

on tabpage_appeal_preview.create
this.dw_appeal_preview=create dw_appeal_preview
this.Control[]={this.dw_appeal_preview}
end on

on tabpage_appeal_preview.destroy
destroy(this.dw_appeal_preview)
end on

type dw_appeal_preview from u_datawindow within tabpage_appeal_preview
integer width = 2139
integer height = 424
integer taborder = 11
string dataobject = "d_appealtracker_preview"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event retrievestart;call super::retrievestart;THIS.SetTransObject(SQLCA)
end event

