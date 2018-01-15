$PBExportHeader$w_formatting_service_response.srw
forward
global type w_formatting_service_response from w_formatting_service
end type
end forward

global type w_formatting_service_response from w_formatting_service
boolean minbox = false
windowtype windowtype = response!
end type
global w_formatting_service_response w_formatting_service_response

on w_formatting_service_response.create
call super::create
end on

on w_formatting_service_response.destroy
call super::destroy
end on

type cb_apply from w_formatting_service`cb_apply within w_formatting_service_response
end type

type tab_control from w_formatting_service`tab_control within w_formatting_service_response
end type

type cb_restoreoriginal from w_formatting_service`cb_restoreoriginal within w_formatting_service_response
end type

type cb_cancel from w_formatting_service`cb_cancel within w_formatting_service_response
end type

type cb_ok from w_formatting_service`cb_ok within w_formatting_service_response
end type

type ln_6 from w_formatting_service`ln_6 within w_formatting_service_response
end type

type ln_7 from w_formatting_service`ln_7 within w_formatting_service_response
end type

type st_4 from w_formatting_service`st_4 within w_formatting_service_response
end type

