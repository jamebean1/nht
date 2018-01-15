$PBExportHeader$n_fwca_error.sru
$PBExportComments$Error class used by PowerClass to communicate errors between classes
forward
global type n_fwca_error from error
end type
end forward

global type n_fwca_error from error
end type
global n_fwca_error n_fwca_error

type variables
//-----------------------------------------------------------------------------------------
//  Error Object Constants
//-----------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------
//  Error Object Instance Variables
//-----------------------------------------------------------------------------------------

INTEGER		i_FWError
end variables

on n_fwca_error.create
call error::create
TriggerEvent( this, "constructor" )
end on

on n_fwca_error.destroy
call error::destroy
TriggerEvent( this, "destructor" )
end on

