$PBExportHeader$u_hover_button_publish_click.sru
$PBExportComments$This is inherited from u_hover_button.  It can be instantiated dynamically and will pubish that it is clicked to the parent object with a message that you can define.
forward
global type u_hover_button_publish_click from u_hover_button
end type
end forward

global type u_hover_button_publish_click from u_hover_button
integer height = 72
alignment alignment = center!
long bordercolor = 80263328
end type
global u_hover_button_publish_click u_hover_button_publish_click

type variables
Protected:

String is_message = 'Button Clicked', is_argument = 'You forgot to give the button an argument'
PowerObject ipo_parent
String is_wavefile = ''
end variables

forward prototypes
public subroutine of_set_argument (string as_argument)
public subroutine of_set_button_text (string as_text)
public subroutine of_set_parent (powerobject apo_powerobject)
public subroutine of_set_sound (string as_sound)
public function string of_get_argument ()
public function string of_get_button_text ()
public function powerobject of_get_parent ()
end prototypes

public subroutine of_set_argument (string as_argument);is_argument = as_argument
end subroutine

public subroutine of_set_button_text (string as_text);This.Text = as_text
end subroutine

public subroutine of_set_parent (powerobject apo_powerobject);ipo_parent = apo_powerobject
end subroutine

public subroutine of_set_sound (string as_sound);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_sound()
// Arguments:   as_sound - the wave file to override the default wav for the button's clicked
// Overview:    Set the wave file to override the default wav for the button's clicked
// Created by:  Blake Doerr
// History:     6/24/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_wavefile = as_sound
end subroutine

public function string of_get_argument ();Return is_argument
end function

public function string of_get_button_text ();Return This.Text
end function

public function powerobject of_get_parent ();Return ipo_parent
end function

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  yes
// Overview:   This is the code for the clicked event
// Created by: Blake Doerr
// History:    6/24/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

 
If This.Enabled Then
	If is_wavefile = '' Then
		Call super::Clicked
	Else
		n_multimedia ln_multimedia
		ln_multimedia.of_play_sound(is_wavefile)
	End If
	
	
	
	ipo_parent.Event Dynamic ue_notify(is_message, is_argument)
End If
end event

on u_hover_button_publish_click.create
end on

on u_hover_button_publish_click.destroy
end on

