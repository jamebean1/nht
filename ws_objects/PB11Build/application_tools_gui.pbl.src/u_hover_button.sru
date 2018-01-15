$PBExportHeader$u_hover_button.sru
forward
global type u_hover_button from statictext
end type
end forward

shared variables

end variables

global type u_hover_button from statictext
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 16777215
long backcolor = 21053512
string text = "none"
long bordercolor = 79741120
boolean focusrectangle = false
event ue_mousemove pbm_mousemove
event ue_refreshtheme ( )
end type
global u_hover_button u_hover_button

type variables
long il_y
end variables

forward prototypes
public subroutine of_hide_all ()
public subroutine of_enable (boolean ab_enabledisable)
end prototypes

event ue_mousemove;//----------------------------------------------------------------------------------------------------------------------------------
//  Send a message to highlight this hover button
//-----------------------------------------------------------------------------------------------------------------------------------
If This.Enabled Then
	gn_globals.in_theme.of_set_hoverhighlight(this)
End If
end event

event ue_refreshtheme;backcolor = gn_globals.in_theme.of_get_barcolor()
bordercolor = gn_globals.in_theme.of_get_bordercolor()
end event

public subroutine of_hide_all ();
end subroutine

public subroutine of_enable (boolean ab_enabledisable);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_enable()
//	Arguments:  ab_enabledisable - True or False
//	Overview:   This will enable or disable a button
//	Created by:	Blake Doerr
//	History: 	6/21/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.Enabled = ab_enabledisable 
end subroutine

event constructor;this.triggerevent('ue_refreshtheme')
end event

event clicked;n_multimedia ln_multimedia

If This.Enabled Then
	ln_multimedia.of_play_sound('start.wav')
	ln_multimedia.post of_play_sound('done.wav')
End If
end event

on u_hover_button.create
end on

on u_hover_button.destroy
end on

