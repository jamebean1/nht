$PBExportHeader$n_evalcheck.sru
$PBExportComments$Stub evaluation checking class
forward
global type n_evalcheck from datastore
end type
end forward

global type n_evalcheck from datastore
end type
global n_evalcheck n_evalcheck

forward prototypes
public function integer fu_evalcheck ()
end prototypes

public function integer fu_evalcheck ();RETURN 0
end function

on n_evalcheck.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_evalcheck.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

