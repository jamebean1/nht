$PBExportHeader$w_show_fields.srw
forward
global type w_show_fields from window
end type
type uo_showfields from u_show_fields_dynamic within w_show_fields
end type
end forward

global type w_show_fields from window
integer x = 1189
integer y = 556
integer width = 2528
integer height = 1344
boolean titlebar = true
string title = "Column Selection/Formatting"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
uo_showfields uo_showfields
end type
global w_show_fields w_show_fields

on w_show_fields.create
this.uo_showfields=create uo_showfields
this.Control[]={this.uo_showfields}
end on

on w_show_fields.destroy
destroy(this.uo_showfields)
end on

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Open
// Overrides:  No
// Overview:   This will initialize the show fields service.
// Created by: Denton Newham
// History:    1/19/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(Message.PowerObjectParm) Then
	uo_showfields.of_init(Message.PowerObjectParm)
End If

f_center_window(this)
end event

type uo_showfields from u_show_fields_dynamic within w_show_fields
integer y = 4
integer height = 1280
integer taborder = 1
end type

on uo_showfields.destroy
call u_show_fields_dynamic::destroy
end on

