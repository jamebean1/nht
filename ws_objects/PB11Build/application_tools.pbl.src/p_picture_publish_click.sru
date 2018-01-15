$PBExportHeader$p_picture_publish_click.sru
forward
global type p_picture_publish_click from picture
end type
end forward

global type p_picture_publish_click from picture
integer width = 165
integer height = 144
boolean focusrectangle = false
end type
global p_picture_publish_click p_picture_publish_click

type variables
Protected:
	PowerObject io_object, io_parent
	String is_message
	String is_soundfilename = ''
	
	//Argument Types
	String		is_stringparm
	PowerObject	io_powerobjectparm
	Double		idble_doubleparm
	
	String		is_ArgumentType
end variables

forward prototypes
public subroutine of_set_sound (string as_soundfilename)
public subroutine of_set_target (powerobject ao_target, string as_message, powerobject ao_argument)
public subroutine of_set_parent (powerobject ao_parent)
public subroutine of_set_target (powerobject ao_target, string as_message, string as_argument)
public subroutine of_set_target (powerobject ao_target, string as_message, double adble_argument)
end prototypes

public subroutine of_set_sound (string as_soundfilename);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_sound()
//	Arguments:  as_soundfilename - The name of the sound file
//	Overview:   This will set the name of the sound file to play when clicked
//	Created by:	Blake Doerr
//	History: 	3/1/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_soundfilename = as_soundfilename
end subroutine

public subroutine of_set_target (powerobject ao_target, string as_message, powerobject ao_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_target()
//	Arguments:  ao_target - The target object
//					as_message - The message to pass to the object
//					as_argument - The argument to pass to the object
//	Overview:   This will set the object to notify when I am pressed
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

io_object 	= ao_target
is_message 	= as_message
io_powerobjectparm = ao_argument

is_argumenttype = 'powerobject'

end subroutine

public subroutine of_set_parent (powerobject ao_parent);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_parent()
//	Arguments:  ao_parent - The parent object
//	Overview:   This will set the parent object in order to pass a message later
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


io_parent = ao_parent
end subroutine

public subroutine of_set_target (powerobject ao_target, string as_message, string as_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_target()
//	Arguments:  ao_target - The target object
//					as_message - The message to pass to the object
//					as_argument - The argument to pass to the object
//	Overview:   This will set the object to notify when I am pressed
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

io_object 	= ao_target
is_message 	= as_message
is_stringparm = as_argument

is_argumenttype = 'string'

end subroutine

public subroutine of_set_target (powerobject ao_target, string as_message, double adble_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_target()
//	Arguments:  ao_target - The target object
//					as_message - The message to pass to the object
//					as_argument - The argument to pass to the object
//	Overview:   This will set the object to notify when I am pressed
//	Created by:	Blake Doerr
//	History: 	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

io_object 	= ao_target
is_message 	= as_message
idble_doubleparm = adble_argument

is_argumenttype = 'double'

end subroutine

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Clicked
//	Overrides:  No
//	Arguments:	
//	Overview:   Notify my target object that I have been clicked
//	Created by: Blake Doerr
//	History:    2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_multimedia ln_multimedia

If IsValid(io_object) And Not IsNull(io_object) Then
	Choose Case is_argumenttype
		Case 'string'
			io_object.Event Dynamic ue_notify(is_message, is_stringparm)
		Case 'powerobject'
			io_object.Event Dynamic ue_notify(is_message, io_powerobjectparm)
		Case 'double'
			io_object.Event Dynamic ue_notify(is_message, idble_doubleparm)
	End Choose
End If

If IsValid(io_parent) And Not IsNull(io_parent) Then
	io_parent.Event Dynamic ue_notify('expandcollapseclicked', '')
End If

If is_soundfilename > '' Then
	ln_multimedia.of_play_sound(is_soundfilename)
Else
	ln_multimedia.of_play_sound('start.wav')
	ln_multimedia.post of_play_sound('done.wav')
End If

end event

on p_picture_publish_click.create
end on

on p_picture_publish_click.destroy
end on

