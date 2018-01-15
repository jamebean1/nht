$PBExportHeader$ds_login_list.sru
$PBExportComments$Datastore for managing login list.
forward
global type ds_login_list from datastore
end type
end forward

global type ds_login_list from datastore
string dataobject = "d_active_logins"
end type
global ds_login_list ds_login_list

on ds_login_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ds_login_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

