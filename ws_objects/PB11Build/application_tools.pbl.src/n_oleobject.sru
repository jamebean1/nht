$PBExportHeader$n_oleobject.sru
forward
global type n_oleobject from oleobject
end type
end forward

global type n_oleobject from oleobject
end type
global n_oleobject n_oleobject

type variables
Protected:
	PowerObject	io_messageobject
end variables

forward prototypes
public subroutine of_set_messageobject (powerobject ao_messageobject)
end prototypes

public subroutine of_set_messageobject (powerobject ao_messageobject);io_messageobject = ao_messageobject
end subroutine

on n_oleobject.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_oleobject.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event externalexception;Action = ExceptionIgnore!

If IsValid(io_messageobject) Then
	io_messageobject.Event Dynamic ue_notify('External Exception', description + ' (Error Code:  ' + String(resultcode) + ')')
End If
end event

