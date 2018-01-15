$PBExportHeader$n_messagebox.sru
forward
global type n_messagebox from nonvisualobject
end type
end forward

global type n_messagebox from nonvisualobject
end type
global n_messagebox n_messagebox

forward prototypes
public function integer of_messagebox (string s_message, icon icon_type, button button_type, integer default_button)
public function integer of_messagebox_question (string s_message, button buttontype, integer defaultbutton)
public function integer of_messagebox_validation (string s_message)
end prototypes

public function integer of_messagebox (string s_message, icon icon_type, button button_type, integer default_button);long i_rtn

i_rtn=MessageBox("CustomerFocus", s_message, Icon_Type,button_type, default_button)



return i_rtn
end function

public function integer of_messagebox_question (string s_message, button buttontype, integer defaultbutton);string s_ncknme

If IsNull(gn_globals.is_nickname) or Trim(gn_globals.is_nickname)="" Then
	s_ncknme="?"
Else
	s_ncknme=", "+ trim(gn_globals.is_nickname) + "?"
End If

s_message = s_message + s_ncknme



return of_messagebox(s_message,Question!,buttontype,defaultbutton)
end function

public function integer of_messagebox_validation (string s_message);string s_ncknme

If IsNull(gn_globals.is_nickname) or Trim(gn_globals.is_nickname)="" Then
	s_ncknme="."
Else
	s_ncknme=", "+ trim(gn_globals.is_nickname) + "."
End If

s_message = s_message + s_ncknme



return of_messagebox(s_message,Information!,OK!,1)
end function

on n_messagebox.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_messagebox.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

