$PBExportHeader$n_multimedia.sru
$PBExportComments$Play a Sound
forward
global type n_multimedia from nonvisualobject
end type
end forward

global type n_multimedia from nonvisualobject autoinstantiate
end type

type prototypes

FUNCTION boolean sndPlaySoundA (string SoundName, uint Flags) &
	   LIBRARY "winmm.dll" alias for "sndPlaySoundA;Ansi"

end prototypes

forward prototypes
public subroutine of_play_sound (string as_sound)
public function boolean of_play_sound (string as_sound, long al_flags)
end prototypes

public subroutine of_play_sound (string as_sound);sndPlaySoundA (as_sound,3)

end subroutine

public function boolean of_play_sound (string as_sound, long al_flags);Return sndPlaySoundA (as_sound, al_flags)

end function

on n_multimedia.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_multimedia.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

