$PBExportHeader$u_statictext.sru
forward
global type u_statictext from statictext
end type
end forward

global type u_statictext from statictext
int Width=243
int Height=77
boolean Enabled=false
string Text="none"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event ue_refreshtheme ( unsignedlong wparam,  long lparam )
end type
global u_statictext u_statictext

event constructor;
this.triggerevent("ue_refreshtheme")
end event

