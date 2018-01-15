$PBExportHeader$n_datastore_append.sru
forward
global type n_datastore_append from datastore
end type
end forward

global type n_datastore_append from datastore
end type
global n_datastore_append n_datastore_append

on n_datastore_append.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datastore_append.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event retrievestart;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      RetrieveStart
//	Overrides:  No
//	Arguments:	
//	Overview:   Retrieve the rows and ADD them to the Existing rows in the datastore.
//	Created by: Denton Newham
//	History:    07/25/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return 2
end event

