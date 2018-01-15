$PBExportHeader$u_tab_args_conv.sru
forward
global type u_tab_args_conv from u_tab_std
end type
type tabpage_args from u_tabpage_args within u_tab_args_conv
end type
type tabpage_args from u_tabpage_args within u_tab_args_conv
end type
type tabpage_convert from u_tabpage_convert within u_tab_args_conv
end type
type tabpage_convert from u_tabpage_convert within u_tab_args_conv
end type
end forward

global type u_tab_args_conv from u_tab_std
integer width = 3177
integer height = 552
boolean fixedwidth = true
alignment alignment = center!
tabpage_args tabpage_args
tabpage_convert tabpage_convert
end type
global u_tab_args_conv u_tab_args_conv

on u_tab_args_conv.create
this.tabpage_args=create tabpage_args
this.tabpage_convert=create tabpage_convert
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_args
this.Control[iCurrent+2]=this.tabpage_convert
end on

on u_tab_args_conv.destroy
call super::destroy
destroy(this.tabpage_args)
destroy(this.tabpage_convert)
end on

type tabpage_args from u_tabpage_args within u_tab_args_conv
integer x = 18
integer y = 112
integer width = 3141
integer height = 424
end type

type tabpage_convert from u_tabpage_convert within u_tab_args_conv
integer x = 18
integer y = 112
integer width = 3141
integer height = 424
end type

