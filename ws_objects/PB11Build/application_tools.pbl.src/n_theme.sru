$PBExportHeader$n_theme.sru
$PBExportComments$<doc>This object is used to look up the value of theme colors in RAIV.  It is available on gn_globals as in_theme.
forward
global type n_theme from nonvisualobject
end type
end forward

global type n_theme from nonvisualobject
event ue_refreshtheme ( )
end type
global n_theme n_theme

type variables
long il_bar
long il_backcolor
long il_bordercolor
long il_editcolor
StaticText iu_last_button
String is_theme
Boolean ib_disable_mousemove = False
end variables

forward prototypes
public function long of_get_backcolor ()
public function long of_get_barcolor ()
public function long of_get_bordercolor ()
public function boolean of_get_disablemousemove ()
public function string of_get_theme ()
public subroutine of_set_hoverhighlight (statictext au_hover_button)
public subroutine of_set_theme (string as_themename)
public subroutine of_set_hover_highlight (statictext au_hover_button)
public subroutine of_clear_hoverhighlight ()
public function long of_get_gradient1 ()
public function integer of_get_gradient2 ()
end prototypes

event ue_refreshtheme();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This will tell the frame to refresh the theme all over the application
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------


If IsValid(gn_globals.of_get_frame()) Then
	gn_globals.of_get_frame().Dynamic Event ue_refreshtheme()
End If

If IsValid(gn_globals) Then
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_message('ThemeChange', '')
	End If
End If
end event

public function long of_get_backcolor ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_backcolor()
// Overview:    Return the back color for the theme
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

return il_backcolor
end function

public function long of_get_barcolor ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_barcolor()
// Overview:    Return the bar color for the theme
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

return il_bar
end function

public function long of_get_bordercolor ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_bordercolor()
// Overview:    Return the border color for the theme
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

return il_bordercolor
end function

public function boolean of_get_disablemousemove ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_disablemousemove()
// Overview:    This will return whether or not to show mousemove highlights.
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------


Return ib_disable_mousemove
end function

public function string of_get_theme ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_theme()
// Overview:    This will return the current theme name.
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------


Return is_theme
end function

public subroutine of_set_hoverhighlight (statictext au_hover_button);//----------------------------------------------------------------------------------------------------------------------------------
// If the last button selected was not the same as the current then unhighlight it
//-----------------------------------------------------------------------------------------------------------------------------------
if iu_last_button <> au_hover_button then of_clear_hoverhighlight()

 
//----------------------------------------------------------------------------------------------------------------------------------
// store off the hover button used
//-----------------------------------------------------------------------------------------------------------------------------------
iu_last_button = au_hover_button

//----------------------------------------------------------------------------------------------------------------------------------
// Highlight the new button
//-----------------------------------------------------------------------------------------------------------------------------------
if au_hover_button.backcolor <> il_backcolor then 
	au_hover_button.textcolor = il_backcolor
else
	au_hover_button.textcolor = il_bar
end if
end subroutine

public subroutine of_set_theme (string as_themename);//----------------------------------------------------------------------------------------------------
// Sets the system theme to the theme specified.</Description>
//----------------------------------------------------------------------------------------------------

//Declarations
Long ll_barcolor, ll_backcolor, ll_bordercolor
String ls_disable_mousemove

//Set the theme into an instance variable for later
is_theme = as_themename

//Get the color settings from the database
Select	barcolor,
			backcolor,
			bordercolor,
			disablemousemove
Into		:ll_barcolor,
			:ll_backcolor,
			:ll_bordercolor,
			:ls_disable_mousemove
From 		cusfocus.theme
Where 	themename = :as_themename;

//If the row isn't found use default settings
If IsNull(ll_barcolor) Then
		il_backcolor = 12632256
		il_bar	= 0
		il_bordercolor = 8421504
		ib_disable_mousemove = True
Else
	il_bar 					= ll_barcolor
	il_backcolor 			= ll_backcolor
	il_bordercolor 		= ll_bordercolor
	ib_disable_mousemove = (ls_disable_mousemove = 'Y')
End If

//Trigger the event to refresh the theme all over the application
This.Event ue_refreshtheme()
end subroutine

public subroutine of_set_hover_highlight (statictext au_hover_button);//----------------------------------------------------------------------------------------------------------------------------------
// If the last button selected was not the same as the current then unhighlight it
//-----------------------------------------------------------------------------------------------------------------------------------
if iu_last_button <> au_hover_button then of_clear_hoverhighlight()

 
//----------------------------------------------------------------------------------------------------------------------------------
// store off the hover button used
//-----------------------------------------------------------------------------------------------------------------------------------
iu_last_button = au_hover_button

//----------------------------------------------------------------------------------------------------------------------------------
// Highlight the new button
//-----------------------------------------------------------------------------------------------------------------------------------
if au_hover_button.backcolor <> il_backcolor then 
	au_hover_button.textcolor = il_backcolor
else
	au_hover_button.textcolor = il_bar
end if
end subroutine

public subroutine of_clear_hoverhighlight ();//----------------------------------------------------------------------------------------------------------------------------------
// Clear the highlight on the hover button
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(iu_last_button) then
	if iu_last_button.backcolor = il_bar then
		iu_last_button.textcolor = 16777215
	else
		iu_last_button.textcolor = 0
	end if
end if

end subroutine

public function long of_get_gradient1 ();string ls_mod,ls_value,ls_value2
long li_blue,li_green,li_red,ll_rgb

	
ll_rgb = of_get_backcolor()


li_Blue = ll_rgb / 65536
li_Green = ( ll_rgb - li_Blue * 65536) / 256
li_Red = ll_rgb - li_Blue * 65536 - li_Green * 256


li_Red += ( 255 / 18 )
IF li_Red >255 THEN li_Red = 255
li_Green += ( 255 / 18 )
IF li_Green > 255 THEN li_Green = 255
li_Blue += ( 255 / 18 )
IF li_Blue > 255 THEN li_Blue = 255

ls_value = string(rgb(li_red,li_green,li_blue))

Return long(ls_value)



end function

public function integer of_get_gradient2 ();//----------------------------------------------------------------------------------------------------
// Generates a color similar to the back color but slightly darker (also darker than gradient1).  
// Useful for creating matching objects which are differentiated from the back color.
//----------------------------------------------------------------------------------------------------

string ls_mod,ls_value,ls_value2
long li_blue,li_green,li_red,ll_rgb

	
ll_rgb = of_get_backcolor()


li_Blue = ll_rgb / 65536
li_Green = ( ll_rgb - li_Blue * 65536) / 256
li_Red = ll_rgb - li_Blue * 65536 - li_Green * 256


li_Red += ( 255 / 13 )
IF li_Red >255 THEN li_Red = 255
li_Green += ( 255 / 13 )
IF li_Green > 255 THEN li_Green = 255
li_Blue += ( 255 / 13 )
IF li_Blue > 255 THEN li_Blue = 255

ls_value2 = string(rgb(li_red,li_green,li_blue))


Return long(ls_value2)

end function

on n_theme.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_theme.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   This will initialize the theme object
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

n_registry in_registry
String ls_theme

//----------------------------------------------------------------------------------------------------------------------------------
// The default theme has colors that work if the setting is 256 colors
//-----------------------------------------------------------------------------------------------------------------------------------
is_theme = 'Default Theme'

//----------------------------------------------------------------------------------------------------------------------------------
// Check the registry for the previous theme.
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals) Then
	ls_theme = in_registry.of_get_registry_key('users\' +  gn_globals.is_username + '\global settings\cusfocus\theme')
	If Trim(ls_theme) <> '' And Not IsNull(ls_theme) Then
		is_theme = ls_theme
	End If
End If

of_set_theme(is_theme)
end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Destructor
// Overrides:  No
// Overview:   This will save the theme to the registry
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------


n_registry in_registry

in_registry.of_set_registry_key('users\' + gn_globals.is_username + '\global settings\cusfocus\theme', is_theme)

end event

