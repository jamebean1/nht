$PBExportHeader$u_title_button_bar.sru
$PBExportComments$This is the title bar on u_search that allows you to add buttons dynamically.  It also displays the title.
forward
global type u_title_button_bar from u_dynamic_gui
end type
type st_ellipsis from u_hover_button_publish_click within u_title_button_bar
end type
type st_close from u_hover_button_publish_click within u_title_button_bar
end type
type st_background from u_theme_strip within u_title_button_bar
end type
type st_title2 from u_theme_strip within u_title_button_bar
end type
type st_title from u_hover_button within u_title_button_bar
end type
end forward

global type u_title_button_bar from u_dynamic_gui
integer width = 4544
integer height = 68
boolean border = false
st_ellipsis st_ellipsis
st_close st_close
st_background st_background
st_title2 st_title2
st_title st_title
end type
global u_title_button_bar u_title_button_bar

type variables
Protected:
	u_hover_button_publish_click iu_buttons[], iu_last_invisible_button
	Long il_buttonoffset = 25, il_minimum_x = 0
	p_picture_publish_click ip_picture_publish_click
	Boolean ib_expanded, ib_we_are_out_of_room = False
	Long il_title_indention = 0
	Long il_save_width, il_save_height
end variables

forward prototypes
public subroutine of_enable_button (string as_buttontext, boolean ab_enabledisable)
public subroutine of_hide_button (string as_buttontext, boolean ab_hide)
public subroutine of_settitle2 (string as_title)
public subroutine of_settitle (string as_title)
public subroutine of_set_minimum_x (long al_x)
public subroutine of_rename_button (string as_oldtext, string as_newtext)
public subroutine of_add_button (string as_buttontext, string as_argument)
public subroutine of_add_button (string as_buttontext, string as_argument, powerobject ao_parent)
public subroutine of_delete_button (string as_buttontext)
end prototypes

public subroutine of_enable_button (string as_buttontext, boolean ab_enabledisable);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_enable_button()
// Arguments:   as_buttontext	-	This will be the text on the button you want to delete
//						ab_enabledisable - True or False
// Overview:    This will delete a button
// Created by:  Blake Doerr
// History:     06/20/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_upperbound
Long		ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
u_hover_button lu_deal_button
DragObject 		ldo_temp

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the upperbound of the buttons
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = UpperBound(iu_buttons[])

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through the buttons and if we find the right one, close it
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If IsValid(iu_buttons[ll_index]) Then
		If Lower(iu_buttons[ll_index].Text) = Lower(as_buttontext) Then
			iu_buttons[ll_index].Enabled = ab_enabledisable
			Exit
		End If
	End If
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// If we are enabling the x, make it invisible
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(as_buttontext) = 'x' Then st_close.Enabled = ab_enabledisable
end subroutine

public subroutine of_hide_button (string as_buttontext, boolean ab_hide);
Long	ll_index, ll_upperbound

ll_upperbound = UpperBound(iu_buttons[])

if as_buttontext = 'x' then
	st_close.visible = NOT ab_hide
else
	For ll_index = 1 To ll_upperbound
		If Lower(iu_buttons[ll_index].Text) = Lower(as_buttontext) Then
			iu_buttons[ll_index].visible = NOT ab_hide
		End If
	Next
end if

//#IF  defined PBDOTNET THEN
//	THIS.Event Resize(0, width, height)
//#ELSE
	This.TriggerEvent('Resize')
//#END IF

end subroutine

public subroutine of_settitle2 (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_settitle()
// Arguments:   as_title the title that you want to assign
// Overview:    This will set the title for the title bar
// Created by:  Blake Doerr
// History:     11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_height, ll_width
n_gettextsize ln_gettextsize

st_title2.Text = ' ' + Trim(as_title)

ll_height = st_title2.Height
ll_width = st_title2.Width

ln_gettextsize.of_gettextsize(st_title2, st_title2.text, ll_height, ll_width)

st_title2.Width = PixelsToUnits(ll_width, XPixelsToUnits!) + 100

of_set_minimum_x(st_title2.X + st_title2.Width + 40)
end subroutine

public subroutine of_settitle (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_settitle()
// Arguments:   as_title the title that you want to assign
// Overview:    This will set the title for the title bar
// Created by:  Blake Doerr
// History:     11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
Long ll_height, ll_width
n_gettextsize ln_gettextsize

st_title.Text = ' ' + Trim(as_title)

ll_height = st_title.Height
ll_width = st_title.Width

//This will find out the total width of the title based on font, size and other properties
ln_gettextsize.of_gettextsize(st_title, st_title.text, ll_height, ll_width)

//st_title.Height = ll_height
st_title.Width = PixelsToUnits(ll_width, XPixelsToUnits!) + 100

st_title2.X = st_title.X + st_title.Width + 40

If il_minimum_x < st_title.X + st_title.Width + 40 Then
	If st_title2.Visible Then
		This.of_set_minimum_x(st_title2.X + st_title2.Width + 40)
	Else
		This.of_set_minimum_x(st_title.X + st_title.Width + 40)
	End If
End If
end subroutine

public subroutine of_set_minimum_x (long al_x);//----------------------------------------------------------------------------------------------------------------------------------
// Function:      of_set_minimum_x
// Overview:   This will set the minimum x that the buttons can move to
// Created by: Blake Doerr
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If il_minimum_x <> al_x Then
	il_minimum_x = al_x
//	#IF  defined PBDOTNET THEN
//		THIS.Event Resize(0, width, height)
//	#ELSE
		This.TriggerEvent('Resize')
//	#END IF
End If
end subroutine

public subroutine of_rename_button (string as_oldtext, string as_newtext);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_add_button()
// Arguments:   as_buttontext	-	This will be the text on the button
//					 as_eventtotrigger - This will be the event the button will trigger on this userobject
// Overview:    This will add a button (make visible) and set the text and redirect the event call to the userobject
// Created by:  Blake Doerr
// History:     11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//Declarations
n_gettextsize ln_gettextsize
Long ll_upperbound, ll_index
Long ll_height = 1000, ll_width = 1000
u_hover_button_publish_click lu_deal_button
DragObject ldo_temp

//If they want a close button, put a little X
Choose Case Lower(as_oldtext)
	Case 'x', '...', 'expandbutton', 'collapsebutton'
	Case Else
		For ll_index = 1 To UpperBound(iu_buttons[])
			If Not IsValid(iu_buttons[ll_index]) Then Continue
			If Lower(Trim(iu_buttons[ll_index].Text)) = Lower(Trim(as_oldtext)) Then lu_deal_button = iu_buttons[ll_index]
		Next
		
		If IsValid(lu_deal_button) Then
			lu_deal_button.of_set_button_text(as_newtext)
			lu_deal_button.Width = 1000

			//Get the best size for the button based on the text within it
			ll_height = lu_deal_button.Height
			ll_width = lu_deal_button.Width
			
			ln_gettextsize.of_gettextsize(lu_deal_button, lu_deal_button.text, ll_height, ll_width)
			
			lu_deal_button.Width = PixelsToUnits(ll_width, XPixelsToUnits!) + 50
		End If
End Choose

//#IF  defined PBDOTNET THEN
//	THIS.Event Resize(0, width, height)
//#ELSE
	This.TriggerEvent('Resize')
//#END IF

end subroutine

public subroutine of_add_button (string as_buttontext, string as_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_add_button()
// Arguments:   as_buttontext	-	This will be the text on the button
//					 as_eventtotrigger - This will be the event the button will trigger on this userobject
// Overview:    This will add a button (make visible) and set the text and redirect the event call to the userobject
// Created by:  Blake Doerr
// History:     11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_add_button(as_buttontext, as_argument, This)
end subroutine

public subroutine of_add_button (string as_buttontext, string as_argument, powerobject ao_parent);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_add_button()
// Arguments:   as_buttontext	-	This will be the text on the button
//					 as_eventtotrigger - This will be the event the button will trigger on this userobject
// Overview:    This will add a button (make visible) and set the text and redirect the event call to the userobject
// Created by:  Blake Doerr
// History:     11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//Declarations
n_gettextsize ln_gettextsize
Long ll_upperbound, ll_index
Long ll_height = 1000, ll_width = 1000
u_hover_button_publish_click lu_deal_button
DragObject ldo_temp

//If they want a close button, put a little X
Choose Case Lower(as_buttontext)
	Case 'x'
		lu_deal_button =  st_close
		
		If Not st_close.Visible Then
			as_buttontext = 'û'
			st_close.Visible = True
		End If
	Case '...'
		lu_deal_button = st_ellipsis
		
		If Not st_ellipsis.Visible Then
			st_ellipsis.Visible = True
			as_argument = 'ellipsis'
			as_buttontext = st_ellipsis.Text
		End If
	Case 'expandbutton', 'collapsebutton'
		If Not IsValid(ip_picture_publish_click) Or IsNull(ip_picture_publish_click) Then
			st_title.X = st_title.X + 80
			st_title2.X = st_title2.X + 80
			il_title_indention = il_title_indention + 80
			
			ip_picture_publish_click = This.of_OpenUserObject('p_picture_publish_click', 10, 10)
			ip_picture_publish_click.of_set_parent(This)
			ip_picture_publish_click.of_set_target(ao_parent, 'expandorcollapse', io_parent)
			ip_picture_publish_click.of_set_sound('Module - SmartSearch - HideShow Object.wav')
			ip_picture_publish_click.Height 	= 55
			ip_picture_publish_click.Width 	= 45
		End If
		
		If Lower(as_buttontext) = 'expandbutton' Then
			ip_picture_publish_click.PictureName = 'smallplus.bmp'
			ib_expanded = False
		Else
			ip_picture_publish_click.PictureName = 'smallminus.bmp'			
			ib_expanded = True
		End If
		
		ip_picture_publish_click.OriginalSize = True
		
		Return
	Case Else
		For ll_index = 1 To UpperBound(iu_buttons[])
			If Not IsValid(iu_buttons[ll_index]) Then Continue
			If Not Lower(iu_buttons[ll_index].Text) = Lower(as_buttontext) Then Continue
			
			lu_deal_button = iu_buttons[ll_index]
			Exit
		Next
		
		If Not IsValid(lu_deal_button) Then
			ll_upperbound = UpperBound(iu_buttons[]) + 1
			ldo_temp = This.of_OpenUserObject('u_hover_button_publish_click', 10000, 2)
			lu_deal_button = ldo_temp
			lu_deal_button.of_set_button_text(as_buttontext)
			lu_deal_button.Width = 1000
			iu_buttons[ll_upperbound] = lu_deal_button
		
			//Get the best size for the button based on the text within it
			ll_height = lu_deal_button.Height
			ll_width = lu_deal_button.Width
			
			ln_gettextsize.of_gettextsize(lu_deal_button, lu_deal_button.text, ll_height, ll_width)
			
			lu_deal_button.Width = PixelsToUnits(ll_width, XPixelsToUnits!) + 50
		End If
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Change the sound for certain buttons
		//-----------------------------------------------------------------------------------------------------------------------------------
		Choose Case Lower(Trim(as_argument))
			Case 'criteria', 'filters', 'back', 'forward', 'close'
				lu_deal_button.of_set_sound('Module - SmartSearch - HideShow Object.wav')
		End Choose		
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// Set all the properties for the buttons
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(lu_deal_button) Then
	lu_deal_button.of_set_argument(as_argument)
	lu_deal_button.of_set_parent(ao_parent)
	lu_deal_button.Visible = True
End If

//#IF  defined PBDOTNET THEN
//	THIS.Event Resize(0, width, height)
//#ELSE
	This.TriggerEvent('Resize')
//#END IF


end subroutine

public subroutine of_delete_button (string as_buttontext);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_delete_button()
// Arguments:   as_buttontext	-	This will be the text on the button you want to delete
// Overview:    This will delete a button
// Created by:  Blake Doerr
// History:     11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_upperbound
Long		ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the upperbound of the buttons
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound = UpperBound(iu_buttons[])

Choose Case Lower(as_buttontext)
	Case 'x'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Make the close button invisible if necessary
		//-----------------------------------------------------------------------------------------------------------------------------------
		If st_close.Visible Then
			st_close.Visible = False
//			#IF  defined PBDOTNET THEN
//				THIS.Event Resize(0, width, height)
//			#ELSE
				This.TriggerEvent('Resize')
//			#END IF
		End If
	Case 'collapsebutton', 'expandbutton'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the picture button is visible destroy it
		//-----------------------------------------------------------------------------------------------------------------------------------
		If IsValid(ip_picture_publish_click) Then
			This.of_closeuserobject(ip_picture_publish_click)
			st_title.X = st_title.X - il_title_indention
			st_title2.X = st_title2.X - il_title_indention
			il_title_indention = 0
//			#IF  defined PBDOTNET THEN
//				THIS.Event Resize(0, width, height)
//			#ELSE
				This.TriggerEvent('Resize')
//			#END IF
		End If
	Case Else
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Loop through the buttons and if we find the right one, hide it
		//-----------------------------------------------------------------------------------------------------------------------------------
		For ll_index = 1 To ll_upperbound
			If Not IsValid(iu_buttons[ll_index]) Then Continue
			If Not Lower(iu_buttons[ll_index].Text) = Lower(as_buttontext) Then Continue
		
			iu_buttons[ll_index].Visible = False
//			#IF  defined PBDOTNET THEN
//				THIS.Event Resize(0, width, height)
//			#ELSE
				This.TriggerEvent('Resize')
//			#END IF
			Exit
		Next
End Choose

This.Event ue_notify('button deleted', as_buttontext)

end subroutine

on u_title_button_bar.create
int iCurrent
call super::create
this.st_ellipsis=create st_ellipsis
this.st_close=create st_close
this.st_background=create st_background
this.st_title2=create st_title2
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_ellipsis
this.Control[iCurrent+2]=this.st_close
this.Control[iCurrent+3]=this.st_background
this.Control[iCurrent+4]=this.st_title2
this.Control[iCurrent+5]=this.st_title
end on

on u_title_button_bar.destroy
call super::destroy
destroy(this.st_ellipsis)
destroy(this.st_close)
destroy(this.st_background)
destroy(this.st_title2)
destroy(this.st_title)
end on

event resize;call super::resize;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Resize
// Overrides:  No
// Overview:   This will resize the controls on the userobject
// Created by: Blake Doerr
// History:    11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------
// Local Variables
//---------------------------------------------------------------
Long ll_upperbound, ll_index, ll_total_width = 0, ll_left_boundary, ll_right_boundary, ll_start_position

st_background.Width = Width
u_hover_button_publish_click	lu_relative_button, lu_buttons_visible[]

//---------------------------------------------------------------
// Find the upperbound of the button array
//---------------------------------------------------------------
ll_upperbound = UpperBound(iu_buttons[])
ll_right_boundary = Width - 100
st_ellipsis.Visible = False

//---------------------------------------------------------------
// If the close button is visible, position it
//---------------------------------------------------------------
If st_close.Visible Then
	ll_right_boundary = ll_right_boundary - 75
	st_close.X 			= Width - st_close.Width - 20
	st_close.Y 			= -24
End If


//---------------------------------------------------------------
// Find the total width of all the buttons added together.  Also
//  create an array of valid and visible buttons
//---------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	If Not IsValid(iu_buttons[ll_index]) Then Continue
	If Not iu_buttons[ll_index].Visible Then Continue
	
	lu_buttons_visible[UpperBound(lu_buttons_visible[]) + 1] = iu_buttons[ll_index]
	ll_total_width = ll_total_width  + iu_buttons[ll_index].Width
Next

//---------------------------------------------------------------
// Now get the upperbound of the visible buttons
//---------------------------------------------------------------
ll_upperbound = UpperBound(lu_buttons_visible[])

//---------------------------------------------------------------
// Find the total width and the boundaries
//---------------------------------------------------------------
ll_total_width = ll_total_width  + ((ll_upperbound - 1) * il_buttonoffset)
ll_left_boundary	= il_minimum_x
ll_start_position	= ll_right_boundary - ll_total_width
ib_we_are_out_of_room = ll_start_position < ll_left_boundary

//---------------------------------------------------------------
// Loop through the buttons repositioning them
//---------------------------------------------------------------
FOR ll_index = ll_upperbound To 1 Step -1
	
	If ib_we_are_out_of_room And Not st_ellipsis.Visible Then
		lu_buttons_visible[ll_index].X = 10000
		iu_last_invisible_button	= lu_buttons_visible[ll_index]
		If ll_start_position > ll_left_boundary Or (lu_buttons_visible[ll_index].Width - st_ellipsis.Width) > (ll_left_boundary - ll_start_position) Then
//			st_ellipsis.Width = lu_buttons_visible[ll_index].Width
			st_ellipsis.Visible = True
			st_ellipsis.X = ll_start_position + (lu_buttons_visible[ll_index].Width - st_ellipsis.Width)
		End If
	Else
		lu_buttons_visible[ll_index].X 	= ll_start_position
	End If

	ll_start_position 					= ll_start_position + lu_buttons_visible[ll_index].Width + il_buttonoffset
NEXT

//---------------------------------------------------------------
// Bring the objects to the top
//---------------------------------------------------------------
st_title.BringToTop = True
If IsValid(ip_picture_publish_click) Then
	ip_picture_publish_click.BringToTop = True
End If
end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   This will make the object visible and trigger the resize event
// Created by: Blake Doerr
// History:    11/24/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

st_title.Text = ''
//#IF  defined PBDOTNET THEN
//	THIS.Event Resize(0, width, height)
//#ELSE
	This.TriggerEvent('Resize')
//#END IF
TriggerEvent('ue_refreshtheme')

il_title_indention = This.X


end event

event ue_refreshtheme;call super::ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This will refresh the theme on all buttons
// Created by: Blake Doerr
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index

FOR ll_index = 1 TO UpperBound(iu_buttons[])
	iu_buttons[ll_index].TriggerEvent('ue_refreshtheme')
NEXT

st_title.TriggerEvent('ue_refreshtheme')

//#if defined PBWEBFORM then
//this.visible = false
//#end if

end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//					aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	2/29/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
m_dynamic lm_dynamic
Long ll_index
Boolean lb_first_menuitem_is_set = False
Window lw_window
Choose Case Lower(Trim(as_message))
   Case 'expandcollapseclicked'
		If IsValid(ip_picture_publish_click) And Not IsNull(ip_picture_publish_click) Then
			If ib_expanded Then
				ip_picture_publish_click.PictureName = 'smallplus.bmp'
				ib_expanded = False
			Else
				ip_picture_publish_click.PictureName = 'smallminus.bmp'			
				ib_expanded = True
			End If
			
			ip_picture_publish_click.OriginalSize = True		
		End If
	Case 'doubleclicked'
		If IsValid(ip_picture_publish_click) Then
			ip_picture_publish_click.Event Clicked()
		End If
	Case 'button clicked', 'buttonclicked'
		Choose Case Lower(Trim(String(as_arg)))
			Case 'ellipsis'
				If Not ib_we_are_out_of_room Then Return
				If Not IsValid(iu_last_invisible_button) Or IsNull(iu_last_invisible_button) Then Return
				lm_dynamic = Create m_dynamic

				//---------------------------------------------------------------
				// Loop through the buttons repositioning them
				//---------------------------------------------------------------
				FOR ll_index = UpperBound(iu_buttons[]) To 1 Step -1
					If Not IsValid(iu_buttons[ll_index]) Then Continue
					If Not iu_buttons[ll_index].Visible Then Continue
					If Not lb_first_menuitem_is_set Then
						lm_dynamic.of_set_object(iu_buttons[ll_index].of_get_parent())
						lb_first_menuitem_is_set = True
					End If
					lm_dynamic.of_add_item(lm_dynamic, iu_buttons[ll_index].of_get_button_text(), 'button clicked', iu_buttons[ll_index].of_get_argument(), iu_buttons[ll_index].of_get_parent())
			
					If iu_buttons[ll_index] = iu_last_invisible_button Then Exit
				NEXT

				//----------------------------------------------------------------------------------------------------------------------------------
				// display the already created menu object.
				//-----------------------------------------------------------------------------------------------------------------------------------
				lw_window = This.of_getparentwindow()
				
				if lw_window.windowtype = Response! Or lw_window.windowtype = Popup! then
					lm_dynamic.popmenu( lw_window.pointerx(), lw_window.pointery())
				else
					lm_dynamic.popmenu( w_mdi.pointerx(), w_mdi.pointery())
				end if
				
				Destroy lm_dynamic
				gn_globals.in_theme.of_clear_hoverhighlight()
		End Choose
	Case Else
End Choose
		

end event

type st_ellipsis from u_hover_button_publish_click within u_title_button_bar
boolean visible = false
integer x = 3442
integer y = 16
integer width = 96
integer height = 124
integer textsize = -12
fontcharset fontcharset = symbol!
fontfamily fontfamily = anyfont!
string facename = "Wingdings"
boolean underline = false
string text = "   "
alignment alignment = right!
long bordercolor = 80263581
end type

event constructor;call super::constructor;This.of_set_parent(Parent)
This.of_set_argument('ellipsis')
end event

type st_close from u_hover_button_publish_click within u_title_button_bar
boolean visible = false
integer x = 3877
integer width = 105
integer height = 124
integer textsize = -20
fontcharset fontcharset = symbol!
fontfamily fontfamily = anyfont!
string facename = "Wingdings"
boolean underline = false
string text = "û"
long bordercolor = 80263581
end type

type st_background from u_theme_strip within u_title_button_bar
event ue_lbuttondown pbm_lbuttondown
integer width = 4096
integer height = 68
integer textsize = -16
end type

event rbuttondown;call super::rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      rbuttondown
// Overrides:  No
// Overview:   Pass this event to the parent object so he can handle it
// Created by: Blake Doerr
// History:    6/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Parent.TriggerEvent('rbuttondown')
end event

event doubleclicked;call super::doubleclicked;Parent.Event ue_notify('doubleclicked', '')
end event

type st_title2 from u_theme_strip within u_title_button_bar
integer x = 398
integer width = 46
integer height = 56
boolean bringtotop = true
integer textsize = -8
long backcolor = 10789024
end type

event rbuttondown;call super::rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      rbuttondown
// Overrides:  No
// Overview:   Pass this event to the parent object so he can handle it
// Created by: Blake Doerr
// History:    6/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Parent.TriggerEvent('rbuttondown')
end event

event doubleclicked;call super::doubleclicked;Parent.Event ue_notify('doubleclicked', '')
end event

type st_title from u_hover_button within u_title_button_bar
integer x = 27
integer width = 357
integer height = 52
boolean bringtotop = true
integer weight = 700
fontcharset fontcharset = ansi!
long backcolor = 10789024
string text = "Sample Title"
end type

event rbuttondown;call super::rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      rbuttondown
// Overrides:  No
// Overview:   Pass this event to the parent object so he can handle it
// Created by: Blake Doerr
// History:    6/22/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Parent.TriggerEvent('rbuttondown')
end event

event doubleclicked;call super::doubleclicked;Parent.Event ue_notify('doubleclicked', '')
end event

event clicked;call super::clicked;u_dynamic_gui lu_dynamic_gui
UserObject lu_userobject
PowerObject lo_object
Window	lw_window
Long		ll_xposition, ll_yposition, ll_objecty

//-----------------------------------------------------------------------------------------------------------------------------------
// Do who's your daddy, until we find a window
//-----------------------------------------------------------------------------------------------------------------------------------
lo_object = Parent
//ll_xposition = This.X + Parent.X
//ll_yposition = This.Y + Parent.Y

Do While lo_object.TypeOf() <> Window!
	Choose Case Left(Lower(Trim(ClassName(lo_object))), 5)
		Case 'u_sea', 'u_dyn'
			lu_dynamic_gui = lo_object
			If IsValid(lu_dynamic_gui.io_parent) Then
				lo_object = lu_dynamic_gui.io_parent
			Else
				lo_object = lo_object.GetParent()			
			End If
		Case Else
			lo_object = lo_object.GetParent()			
	End Choose

	Choose Case lo_object.TypeOf()
		Case Window!
			lw_window = lo_object
		//	ll_xposition = ll_xposition + lw_window.X
		//	ll_yposition = ll_yposition + lw_window.Y
			
		Case UserObject!
			lu_userobject = lo_object
		//	ll_xposition = ll_xposition + lu_userobject.X
		//	ll_yposition = ll_yposition + lu_userobject.Y
	End Choose
Loop

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the window
//-----------------------------------------------------------------------------------------------------------------------------------
lw_window	= lo_object

//-----------------------------------------------------------------------------------------------------------------------------------
// To get the X position you just need to subtract the Datawindow EditMask's X and subtract if from the Datawindow.PointerX
//		This gives you the Delta X from the object to the pointer.  Now you just have to subtract that from w_frame.PointerX
//-----------------------------------------------------------------------------------------------------------------------------------
ll_xposition 	= ll_xposition + w_mdi.PointerX() - This.PointerX()

//-----------------------------------------------------------------------------------------------------------------------------------
// Y is exactly the same it is just a little more involved to find the Datawindow EditMask's Y.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_objecty 		= ll_yposition + This.Height

//-----------------------------------------------------------------------------------------------------------------------------------
// Calculate the actual y position
//-----------------------------------------------------------------------------------------------------------------------------------
ll_yposition = w_mdi.PointerY() - (This.PointerY() - ll_objecty) + 5

If IsValid(io_parent) Then
	io_parent.Event Dynamic ue_notify('open menu', String(ll_xposition) + ',' + String(ll_yposition))
Else
	Parent.GetParent().Event Dynamic ue_notify('open menu', String(ll_xposition) + ',' + String(ll_yposition))
End If



end event

