$PBExportHeader$u_dynamic_gui_tab_control.sru
forward
global type u_dynamic_gui_tab_control from u_dynamic_gui
end type
type r_back from rectangle within u_dynamic_gui_tab_control
end type
type ln_top_insde from line within u_dynamic_gui_tab_control
end type
type ln_rght_insde from line within u_dynamic_gui_tab_control
end type
type ln_lft_insde from line within u_dynamic_gui_tab_control
end type
type ln_1 from line within u_dynamic_gui_tab_control
end type
type ln_2 from line within u_dynamic_gui_tab_control
end type
type ln_4 from line within u_dynamic_gui_tab_control
end type
type st_tab_txt from statictext within u_dynamic_gui_tab_control
end type
end forward

global type u_dynamic_gui_tab_control from u_dynamic_gui
integer width = 2674
integer height = 1184
long backcolor = 33554432
long tabbackcolor = 79416533
long picturemaskcolor = 25166016
event ue_refreshtheme ( )
event ue_showmenu ( )
r_back r_back
ln_top_insde ln_top_insde
ln_rght_insde ln_rght_insde
ln_lft_insde ln_lft_insde
ln_1 ln_1
ln_2 ln_2
ln_4 ln_4
st_tab_txt st_tab_txt
end type
global u_dynamic_gui_tab_control u_dynamic_gui_tab_control

type variables
Protected:
	u_dynamic_gui iu_dynamic_gui 
	Boolean	ib_IsSelected = False
	Boolean	ib_IsVertical = True
	Boolean	ib_WeAreResizing = False
end variables

forward prototypes
public subroutine of_select ()
public subroutine of_deselect ()
public function u_dynamic_gui of_get_gui ()
public function boolean of_isselected ()
public subroutine of_init (u_dynamic_gui au_dynamic_gui)
public subroutine of_set_title (string as_title)
public subroutine of_init (u_dynamic_gui au_dynamic_gui, boolean ab_isvertical)
public subroutine of_refresh ()
end prototypes

event ue_refreshtheme;call super::ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_refreshtheme
//	Overrides:  No
//	Arguments:	
//	Overview:   This will reset the colors based on the theme and whether it is selected or not
//	Created by: Blake Doerr
//	History:    4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the color based on whether or not it is selected
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_IsSelected Then
	st_tab_txt.backcolor = gn_globals.in_theme.of_get_backcolor()
	st_tab_txt.textcolor = 0
	r_back.visible 		= True
Else
	st_tab_txt.backcolor = gn_globals.in_theme.of_get_barcolor()
	r_back.visible 		= False
	st_tab_txt.textcolor = 16777215
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the backcolor to buttonface
//-----------------------------------------------------------------------------------------------------------------------------------
This.backcolor = 5329233
/*
If ib_isselected Then
	This.BackColor = 8421504
Else
	This.BackColor = 0
End If
*/
end event

event ue_showmenu;call super::ue_showmenu;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_showmenu
//	Overrides:  No
//	Arguments:	
//	Overview:   Present the menu of the object that we are containing
//	Created by: Blake Doerr
//	History:    4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(iu_dynamic_gui) Then
	iu_dynamic_gui.Event ue_showmenu()
End If
end event

public subroutine of_select ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_select()
//	Overview:   Make the object visible
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Make the object visible
//-----------------------------------------------------------------------------------------------------------------------------------
This.Height = 75
If IsValid(iu_dynamic_gui) Then
	iu_dynamic_gui.TabOrder 	= 10
	iu_dynamic_gui.Visible 		= True
	iu_dynamic_gui.BringToTop 	= True
	iu_dynamic_gui.SetFocus()
	ib_IsSelected 					= True
	ln_4.Visible					= Not ib_isvertical
	st_tab_txt.Weight = 700
	This.of_set_title(st_tab_txt.Text)
	
	io_parent.Event Dynamic ue_notify('Tab Selected', This)
	
	If ib_IsVertical Then
		st_tab_txt.Y = 1
	Else
		st_tab_txt.Y = 5
	End If
	
	This.Event ue_refreshtheme()
End If
end subroutine

public subroutine of_deselect ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_deselect()
//	Overview:   Make the object invisible
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Make the object invisible
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(iu_dynamic_gui) Then
	iu_dynamic_gui.TabOrder 	= 0
	iu_dynamic_gui.Visible 		= False
	iu_dynamic_gui.BringToTop 	= False
	ib_IsSelected 					= False
	ln_4.Visible					= ib_isvertical
	This.Event ue_refreshtheme()
	st_tab_txt.Y = 5
	st_tab_txt.Weight = 400
	This.of_set_title(st_tab_txt.Text)
End If

This.Height = 69
end subroutine

public function u_dynamic_gui of_get_gui ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_gui()
//	Overview:   This will return the gui that we are controlling
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return iu_dynamic_gui
end function

public function boolean of_isselected ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_isselected()
//	Overview:   Return whether or not the object is select
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return whether or not the object is selected
//-----------------------------------------------------------------------------------------------------------------------------------
Return ib_isselected
end function

public subroutine of_init (u_dynamic_gui au_dynamic_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  au_dynamic_gui - The object to control
//	Overview:   This will set the object to control
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_init(au_dynamic_gui, True)
end subroutine

public subroutine of_set_title (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_title()
// Arguments:   as_title the title that you want to assign
// Overview:    This will set the title for the tab
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_height, ll_width
n_gettextsize ln_gettextsize

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the text and get the dimensions of the static text
//-----------------------------------------------------------------------------------------------------------------------------------
st_tab_txt.Text 	= as_title
ll_height 			= st_tab_txt.Height
ll_width 			= st_tab_txt.Width

//-----------------------------------------------------------------------------------------------------------------------------------
// This will find out the total width of the title based on font, size and other properties
//-----------------------------------------------------------------------------------------------------------------------------------
ln_gettextsize.of_gettextsize(st_tab_txt, st_tab_txt.text, ll_height, ll_width)

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the Width of this Object
//-----------------------------------------------------------------------------------------------------------------------------------
This.Width = PixelsToUnits(ll_width, XPixelsToUnits!) + 75
If Not ib_WeAreResizing Then
	#IF  defined PBDOTNET THEN
		THIS.EVENT resize(0, width, height)
	#ELSE
		THIS.TriggerEvent('Resize')
	#END IF
End If

end subroutine

public subroutine of_init (u_dynamic_gui au_dynamic_gui, boolean ab_isvertical);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  au_dynamic_gui - The object to control
//					ab_isvertical - whether or not the orientation is vertical
//	Overview:   This will set the object to control
//	Created by:	Blake Doerr
//	History: 	4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the object as a pointer
//-----------------------------------------------------------------------------------------------------------------------------------
If iu_dynamic_gui <> au_dynamic_gui Then gn_globals.in_subscription_service.of_subscribe(This, 'Object Text Changed', au_dynamic_gui)

iu_dynamic_gui = au_dynamic_gui

If Not IsValid(iu_dynamic_gui) Then Return

This.of_refresh()

//-----------------------------------------------------------------------------------------------------------------------------------
// Do some hard stuff if it's false
//-----------------------------------------------------------------------------------------------------------------------------------
ln_4.Visible = Not ab_isvertical
ln_2.Visible = ab_isvertical

end subroutine

public subroutine of_refresh ();String	ls_title
Any		lany_return

If Not IsValid(iu_dynamic_gui) Then Return

lany_return = iu_dynamic_gui.Event Dynamic ue_getitem('text', '')

If Lower(Trim(ClassName(lany_return))) = 'string' Then
	ls_title = String(lany_return)
End If

If IsNull(ls_title) Or Trim(ls_title) = '' Then
	ls_title = iu_dynamic_gui.Text
End If

This.of_set_title(ls_title)
end subroutine

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      Constructor
//	Overrides:  No
//	Arguments:	
//	Overview:   Stuff
//	Created by: Blake Doerr
//	History:    4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

this.Event ue_refreshtheme()
This.Height = 69
end event

on u_dynamic_gui_tab_control.create
int iCurrent
call super::create
this.r_back=create r_back
this.ln_top_insde=create ln_top_insde
this.ln_rght_insde=create ln_rght_insde
this.ln_lft_insde=create ln_lft_insde
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_4=create ln_4
this.st_tab_txt=create st_tab_txt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.r_back
this.Control[iCurrent+2]=this.ln_top_insde
this.Control[iCurrent+3]=this.ln_rght_insde
this.Control[iCurrent+4]=this.ln_lft_insde
this.Control[iCurrent+5]=this.ln_1
this.Control[iCurrent+6]=this.ln_2
this.Control[iCurrent+7]=this.ln_4
this.Control[iCurrent+8]=this.st_tab_txt
end on

on u_dynamic_gui_tab_control.destroy
call super::destroy
destroy(this.r_back)
destroy(this.ln_top_insde)
destroy(this.ln_rght_insde)
destroy(this.ln_lft_insde)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_4)
destroy(this.st_tab_txt)
end on

event resize;call super::resize;st_tab_txt.Width = Width - (st_tab_txt.X * 2) + 2

st_tab_txt.Height = This.Height - 7
end event

event ue_notify;call super::ue_notify;
Choose Case Lower(Trim(as_message))
	Case 'object text changed'
		This.of_refresh()
		If IsValid(io_parent) Then
//??? Will this work for .Net?
			io_parent.TriggerEvent('Resize')
		End If
End Choose
end event

type r_back from rectangle within u_dynamic_gui_tab_control
boolean visible = false
long linecolor = 12632256
linestyle linestyle = transparent!
integer linethickness = 5
long fillcolor = 16777215
integer x = 603
integer y = 712
integer width = 32000
integer height = 216
end type

type ln_top_insde from line within u_dynamic_gui_tab_control
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer beginx = 14
integer beginy = 8
integer endx = 311
integer endy = 8
end type

type ln_rght_insde from line within u_dynamic_gui_tab_control
boolean visible = false
long linecolor = 8421504
integer linethickness = 5
integer beginx = 315
integer beginy = 12
integer endx = 315
integer endy = 84
end type

type ln_lft_insde from line within u_dynamic_gui_tab_control
boolean visible = false
long linecolor = 16777215
integer linethickness = 5
integer beginx = 9
integer beginy = 12
integer endx = 9
integer endy = 88
end type

type ln_1 from line within u_dynamic_gui_tab_control
long linecolor = 8421504
integer linethickness = 5
integer beginy = 88
integer endx = 32000
integer endy = 88
end type

type ln_2 from line within u_dynamic_gui_tab_control
long linecolor = 16777215
integer linethickness = 5
integer beginy = 68
integer endx = 32000
integer endy = 68
end type

type ln_4 from line within u_dynamic_gui_tab_control
integer linethickness = 5
integer endx = 32000
end type

type st_tab_txt from statictext within u_dynamic_gui_tab_control
integer x = 5
integer y = 4
integer width = 521
integer height = 64
integer taborder = 1
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421504
long backcolor = 12632256
string text = "tab"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;Parent.of_select()
end event

event rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      RButtonDown
//	Overrides:  No
//	Arguments:	
//	Overview:   This will cascade the event to the parent object
//	Created by: Blake Doerr
//	History:    4/11/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Parent.Event ue_showmenu()
end event

