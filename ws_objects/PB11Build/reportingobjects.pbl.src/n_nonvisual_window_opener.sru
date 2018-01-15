$PBExportHeader$n_nonvisual_window_opener.sru
forward
global type n_nonvisual_window_opener from nonvisualobject
end type
end forward

global type n_nonvisual_window_opener from nonvisualobject
end type
global n_nonvisual_window_opener n_nonvisual_window_opener

forward prototypes
public subroutine of_openwindowwithparm (string as_windowname, powerobject ao_parameter)
public subroutine of_openwindow (string as_windowname)
end prototypes

public subroutine of_openwindowwithparm (string as_windowname, powerobject ao_parameter);Window lw_window
OpenWithParm(lw_window, ao_parameter, as_windowname, w_mdi)
end subroutine

public subroutine of_openwindow (string as_windowname);Window lw_window
Open(lw_window, as_windowname, w_mdi)
end subroutine

on n_nonvisual_window_opener.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_nonvisual_window_opener.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

