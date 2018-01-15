$PBExportHeader$u_ds_field_list.sru
$PBExportComments$Datastore used to retrieve the list of configurable fields for a given source type.
forward
global type u_ds_field_list from datastore
end type
end forward

global type u_ds_field_list from datastore
string dataobject = "d_field_list"
end type
global u_ds_field_list u_ds_field_list

on u_ds_field_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_ds_field_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

