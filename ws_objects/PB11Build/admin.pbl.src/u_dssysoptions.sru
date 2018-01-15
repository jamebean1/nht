$PBExportHeader$u_dssysoptions.sru
$PBExportComments$System Options Datastore object
forward
global type u_dssysoptions from datastore
end type
end forward

global type u_dssysoptions from datastore
string dataobject = "d_sysoptions"
end type
global u_dssysoptions u_dssysoptions

on u_dssysoptions.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_dssysoptions.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

