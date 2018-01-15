$PBExportHeader$u_theme_strip.sru
forward
global type u_theme_strip from statictext
end type
end forward

shared variables

end variables

global type u_theme_strip from statictext
int Width=4124
int Height=73
boolean FocusRectangle=false
long TextColor=16777215
long BackColor=29018038
int TextSize=-9
int Weight=700
string FaceName="Tahoma"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event ue_mousemove pbm_mousemove
event ue_refreshtheme ( )
end type
global u_theme_strip u_theme_strip

type variables
long il_y
end variables

forward prototypes
public subroutine of_hide_all ()
end prototypes

event ue_mousemove;//----------------------------------------------------------------------------------------------------------------------------------
//  Send a message to clear any highlighted hover buttons
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_theme.of_clear_hoverhighlight()
end event

event ue_refreshtheme;
backcolor = gn_globals.in_theme.of_get_barcolor()
end event

public subroutine of_hide_all ();
end subroutine

event constructor;this.triggerevent('ue_refreshtheme')


end event

