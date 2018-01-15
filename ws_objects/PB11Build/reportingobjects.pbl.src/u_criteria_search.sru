$PBExportHeader$u_criteria_search.sru
$PBExportComments$This is inherited from uo_report_criteria and will hold all search specific code
forward
global type u_criteria_search from uo_report_criteria
end type
type dw_dynamic_criteria from u_datawindow within u_criteria_search
end type
type st_criteria_dynamic from u_hover_button_publish_click within u_criteria_search
end type
type st_criteria_basic from u_hover_button_publish_click within u_criteria_search
end type
type st_tab_filler from statictext within u_criteria_search
end type
type dw_report_criteria from u_datawindow within u_criteria_search
end type
end forward

global type u_criteria_search from uo_report_criteria
integer width = 3593
integer height = 496
long backcolor = 255
boolean ib_allowdynamiccriteria = true
event ue_resize pbm_size
dw_dynamic_criteria dw_dynamic_criteria
st_criteria_dynamic st_criteria_dynamic
st_criteria_basic st_criteria_basic
st_tab_filler st_tab_filler
dw_report_criteria dw_report_criteria
end type
global u_criteria_search u_criteria_search

type variables
Protected:
	Long		il_original_x_position
	Long		il_original_y_position
	Blob		iblob_currentstate
	Blob		iblob_currentstate_dynamic
	String	is_criteria_dataobjectname						= ''
	String	is_dynamic_dataobjectname						= ''
	Boolean	ib_statestored 						= False
end variables

forward prototypes
public subroutine of_restore_defaults_dynamic ()
public subroutine of_init (datawindow adw_data)
public subroutine of_save_state ()
public subroutine of_restore_state ()
end prototypes

event ue_resize;If Not ib_AllowDynamicCriteria Then
	dw_report_criteria.Width 	= Width - dw_report_criteria.X
	dw_report_criteria.Height 	= Height - dw_report_criteria.Y
	This.Backcolor = gn_globals.in_theme.of_get_backcolor()
	st_criteria_basic.Visible 		= False
	st_criteria_dynamic.Visible 	= False
	st_tab_filler.Visible 			= False
ElseIf Not ib_ShowDynamicCriteria Then
	dw_report_criteria.Visible 	= True
	dw_dynamic_criteria.Visible 	= False
	dw_report_criteria.X 			= il_original_x_position
	dw_report_criteria.Y 			= il_original_y_position
	dw_report_criteria.Width 		= Width - dw_report_criteria.X
	dw_report_criteria.Height 		= Height - dw_report_criteria.Y
	dw_report_criteria.Border 		= False
	st_criteria_basic.Visible 		= False
	st_criteria_dynamic.Visible 	= False
	This.Backcolor = gn_globals.in_theme.of_get_backcolor()
	st_tab_filler.Visible 			= False
Else
	dw_report_criteria.X 				= st_criteria_basic.X + st_criteria_basic.Width - 4
	dw_report_criteria.Y					= 0
	dw_report_criteria.Width 			= Width - dw_report_criteria.X
	dw_report_criteria.Height 			= Height - dw_report_criteria.Y
	dw_report_criteria.Border 			= True
	dw_report_criteria.BorderStyle 	= StyleRaised!
	dw_dynamic_criteria.X 				= dw_report_criteria.X
	dw_dynamic_criteria.Y 				= dw_report_criteria.Y
	dw_dynamic_criteria.Width 			= dw_report_criteria.Width
	dw_dynamic_criteria.Height 		= dw_report_criteria.Height
	st_criteria_basic.Visible 			= True
	st_criteria_dynamic.Visible 		= True
	st_tab_filler.Visible 				= True
	This.Backcolor = gn_globals.in_theme.of_get_barcolor()
	
	st_criteria_basic.BringToTop = True
	st_criteria_dynamic.BringToTop = True
	dw_dynamic_criteria.BringToTop = True
	dw_report_criteria.BringToTop = True
	st_tab_filler.BringToTop = True
	
End If

end event

public subroutine of_restore_defaults_dynamic ();
end subroutine

public subroutine of_init (datawindow adw_data);super::of_init(adw_data)

n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager
NonVisualObject ln_service

ln_datawindow_graphic_service_manager = dw_dynamic_criteria.of_get_service_manager()

ln_service = ln_datawindow_graphic_service_manager.of_get_service('n_datawindow_formatting_service')
If IsValid(ln_service) Then
	ln_service.Dynamic of_set_isdynamiccriteria(True)
End If

end subroutine

public subroutine of_save_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will save the state as a blob object in memory to save objects
//	Created by:	Joel White
//	History: 	12/15/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the state is already stored
//-----------------------------------------------------------------------------------------------------------------------------------
If ib_statestored Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the full state into the blob object
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report_criteria.GetFullState(iblob_currentstate)
dw_dynamic_criteria.GetFullState(iblob_currentstate_dynamic)

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
is_criteria_dataobjectname = dw_report_criteria.DataObject
is_dynamic_dataobjectname = dw_dynamic_criteria.DataObject

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the dataobject to empty string in order to clear the objects
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report_criteria.DataObject = ''
dw_dynamic_criteria.DataObject = ''

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that the state is stored
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = True
end subroutine

public subroutine of_restore_state ();//----------------------------------------------------------------------------------------------------------------------------------
//	Overview:   This will restored the datawindow state from the blob object variable
//	Created by:	Joel White
//	History: 	12/15/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// If the state is not stored, return
//-----------------------------------------------------------------------------------------------------------------------------------
If Not ib_statestored Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// If the dataobject name is valid, set the dataobject to preserve the variable on the control
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(is_criteria_dataobjectname) > 0 Then dw_report_criteria.DataObject = is_criteria_dataobjectname
If Len(is_dynamic_dataobjectname) > 0 Then dw_dynamic_criteria.DataObject = is_dynamic_dataobjectname

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the full state of the dataobject
//-----------------------------------------------------------------------------------------------------------------------------------
If Len(iblob_currentstate) > 0 Then dw_report_criteria.SetFullState(iblob_currentstate)
If Len(iblob_currentstate_dynamic) > 0 Then dw_dynamic_criteria.SetFullState(iblob_currentstate_dynamic)

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the transaction object
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(dw_report_criteria.GetTransObject()) Then dw_report_criteria.SetTransObject(dw_report_criteria.GetTransObject())
If IsValid(dw_dynamic_criteria.GetTransObject()) Then dw_dynamic_criteria.SetTransObject(dw_dynamic_criteria.GetTransObject())

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the current state blob object to null to save memory
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(iblob_currentstate)
SetNull(iblob_currentstate_dynamic)

//-----------------------------------------------------------------------------------------------------------------------------------
// Turn off the state stored boolean
//-----------------------------------------------------------------------------------------------------------------------------------
ib_statestored = False
end subroutine

on u_criteria_search.create
int iCurrent
call super::create
this.dw_dynamic_criteria=create dw_dynamic_criteria
this.st_criteria_dynamic=create st_criteria_dynamic
this.st_criteria_basic=create st_criteria_basic
this.st_tab_filler=create st_tab_filler
this.dw_report_criteria=create dw_report_criteria
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dynamic_criteria
this.Control[iCurrent+2]=this.st_criteria_dynamic
this.Control[iCurrent+3]=this.st_criteria_basic
this.Control[iCurrent+4]=this.st_tab_filler
this.Control[iCurrent+5]=this.dw_report_criteria
end on

on u_criteria_search.destroy
call super::destroy
destroy(this.dw_dynamic_criteria)
destroy(this.st_criteria_dynamic)
destroy(this.st_criteria_basic)
destroy(this.st_tab_filler)
destroy(this.dw_report_criteria)
end on

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Contructor
// Overrides:  No
// Overview:   This will trigger the refreshtheme event
// Created by: Joel White
// History:    12/3/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ib_AllowDynamicCriteria = True
dw_report_criteria.Width = 10000
il_original_x_position	= dw_report_criteria.X
il_original_y_position	= dw_report_criteria.Y
This.Height = dw_report_criteria.Y + dw_report_criteria.Height

st_criteria_basic.of_set_parent(this)
st_criteria_dynamic.of_set_parent(this)
st_tab_filler.move( st_criteria_basic.X + st_criteria_basic.Width - 20, st_criteria_basic.Y + 8)

this.event ue_notify( 'basic criteria',"")
end event

event ue_refreshtheme();call super::ue_refreshtheme;
If Not ib_ShowDynamicCriteria Then
	This.Backcolor = gn_globals.in_theme.of_get_backcolor()
Else
	This.Backcolor = gn_globals.in_theme.of_get_barcolor()
	dw_report_criteria.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_backcolor()) +  "'")
End If

dw_dynamic_criteria.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_backcolor()) +  "'")

st_tab_filler.backcolor = gn_globals.in_theme.of_get_backcolor()
st_criteria_dynamic.backcolor = gn_globals.in_theme.of_get_backcolor()
st_criteria_basic.backcolor 	= gn_globals.in_theme.of_get_backcolor()


dw_report_criteria.Event ue_refreshtheme()








end event

event ue_notify(string as_message, any as_arg);call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Joel White
// History:   	4/18/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

NonVisualObject ln_service

Choose Case lower(trim( as_message))
   Case 'menucommand'
		Choose Case Lower(Trim(as_arg))
			Case 'resetcriteria'
				This.of_restore_Defaults_dynamic()
			Case 'createcustomcriteria'
				ib_ShowDynamicCriteria = Not ib_ShowDynamicCriteria
				If ib_ShowDynamicCriteria Then
					st_criteria_dynamic.TriggerEvent('clicked')
				Else
					st_criteria_basic.TriggerEvent('clicked')
				End If
				This.TriggerEvent('ue_resize')
		End Choose
	Case 'before retrieve'
	Case 'after retrieve'
	case 'basic criteria'
		If ib_ShowDynamicCriteria Then
			st_tab_filler.y = st_criteria_basic.y + 8
	
			dw_dynamic_criteria.visible = false
			dw_report_criteria.visible = TRUE
		End If
	case 'dynamic criteria'
		If ib_ShowDynamicCriteria Then
			st_tab_filler.y = st_criteria_dynamic.Y + 8
			dw_report_criteria.visible = FALSE
			dw_dynamic_criteria.visible = TRUE
		End If
	Case 'restore defaults'
		ln_service = dw_dynamic_criteria.of_get_service('n_datawindow_formatting_service')
		If IsValid(ln_service) Then ln_service.Dynamic of_init_criteria_datawindow()
end choose

st_tab_filler.bringtotop = TRUE
end event

type sle_customtitle from uo_report_criteria`sle_customtitle within u_criteria_search
end type

type dw_dynamic_criteria from u_datawindow within u_criteria_search
event type long ue_get_rprtcnfgid ( )
event type datawindow ue_get_report_datawindow ( )
boolean visible = false
integer x = 69
integer y = 512
integer width = 3515
integer height = 476
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_custom_criteria_blank"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event type long ue_get_rprtcnfgid();Return il_reportconfigid
end event

event type datawindow ue_get_report_datawindow();Return dw_report
end event

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   Initialize the services and Set The Transaction Object
// Created by: Joel White
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.SetTransObject(SQLCA)
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

ln_datawindow_graphic_service_manager = This.of_get_service_manager()
ln_datawindow_graphic_service_manager.of_add_service('n_autofill')
ln_datawindow_graphic_service_manager.of_add_service('n_keydown_date_defaults')
ln_datawindow_graphic_service_manager.of_add_service('n_calendar_column_service')
ln_datawindow_graphic_service_manager.of_add_service('n_dropdowndatawindow_caching_service')
ln_datawindow_graphic_service_manager.of_add_service('n_datawindow_formatting_service')
ln_datawindow_graphic_service_manager. of_add_service ('n_multi_select_dddw_service')
ln_datawindow_graphic_service_manager. of_add_service ('n_column_sizing_service')
ln_datawindow_graphic_service_manager.of_create_services()

end event

event itemfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ItemFocusChanged
//	Overrides:  No
//	Arguments:	
//	Overview:   Selects the text in the column when the focus changes to it.

//	Created by: Joel White
//	History:    8.20.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

this.selecttext( 1, 2000)

end event

event rbuttondown;call super::rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      rbuttondown
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the rbuttondown to the parent object
//	Created by: Joel White
//	History:    8.23.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Window lw_window
GraphicObject lgo_parent
m_dynamic lm_dynamic_menu
n_menu_dynamic ln_menu_dynamic

This.BringToTop = True
st_tab_filler.BringToTop = True

ln_menu_dynamic = Create n_menu_dynamic
ln_menu_dynamic.of_set_target_name('uo_report_criteria')
ln_menu_dynamic.of_set_target(This)

This.of_get_service_manager().of_redirect_event('rbuttondown', xpos, ypos, row, dwo, ln_menu_dynamic)

Parent.of_build_menu(ln_menu_dynamic)

lm_dynamic_menu = Create m_dynamic
lm_dynamic_menu.of_set_menuobject(ln_menu_dynamic)

//----------------------------------------------------------------------------------------------------------------------------------
// display the already created menu object.
//-----------------------------------------------------------------------------------------------------------------------------------
lgo_parent = Parent.getparent()

//----------------------------------------------------------------------------------------------------------------------------------
// Find the ultimate parent window and return it.
//-----------------------------------------------------------------------------------------------------------------------------------
DO WHILE lgo_parent.TypeOf() <> Window!	
	lgo_parent = lgo_parent.GetParent()
LOOP

lw_window = lgo_parent

//----------------------------------------------------------------------------------------------------------------------------------
// Pop the menu differently based on the window type
//-----------------------------------------------------------------------------------------------------------------------------------
if lw_window.windowtype = Response! Or lw_window.windowtype = Popup! Or Not isvalid(w_mdi.getactivesheet()) Or (w_mdi.getactivesheet() <> lw_window) then
	lm_dynamic_menu.popmenu(lw_window.pointerx(), lw_window.pointery())
else
	lm_dynamic_menu.popmenu(w_mdi.pointerx(), w_mdi.pointery())
end if

end event

event ue_refreshtheme;call super::ue_refreshtheme;This.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_backcolor()) +  "'")
end event

type st_criteria_dynamic from u_hover_button_publish_click within u_criteria_search
boolean visible = false
integer x = 9
integer y = 128
integer width = 329
integer height = 76
long textcolor = 0
long backcolor = 80269524
string text = "Custom"
boolean border = true
long bordercolor = 79741120
borderstyle borderstyle = styleraised!
end type

event ue_refreshtheme();//Overridden
end event

event constructor;call super::constructor;this.is_message = 'dynamic criteria'
end event

type st_criteria_basic from u_hover_button_publish_click within u_criteria_search
boolean visible = false
integer x = 9
integer y = 44
integer width = 329
integer height = 76
boolean bringtotop = true
long textcolor = 0
long backcolor = 80269524
string text = "Basic"
boolean border = true
long bordercolor = 79741120
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;this.is_message = 'basic criteria'
end event

event ue_refreshtheme();//Overridden
end event

type st_tab_filler from statictext within u_criteria_search
integer x = 311
integer y = 52
integer width = 27
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
long textcolor = 16777215
long backcolor = 21053512
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_report_criteria from u_datawindow within u_criteria_search
integer x = 69
integer width = 3515
integer height = 476
boolean border = false
end type

event constructor;call super::constructor;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Constructor
// Overrides:  No
// Overview:   Initialize the services and Set The Transaction Object
// Created by: Joel White
// History:    6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.SetTransObject(SQLCA)
n_datawindow_graphic_service_manager ln_datawindow_graphic_service_manager

ln_datawindow_graphic_service_manager = This.of_get_service_manager()
ln_datawindow_graphic_service_manager.of_add_service('n_autofill')
ln_datawindow_graphic_service_manager.of_add_service('n_keydown_date_defaults')
ln_datawindow_graphic_service_manager.of_add_service('n_calendar_column_service')
ln_datawindow_graphic_service_manager.of_add_service('n_dropdowndatawindow_caching_service')
ln_datawindow_graphic_service_manager. of_add_service ('n_multi_select_dddw_service')
ln_datawindow_graphic_service_manager.of_create_services()
end event

event itemfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ItemFocusChanged
//	Overrides:  No
//	Arguments:	
//	Overview:   Selects the text in the column when the focus changes to it.

//	Created by: Joel White
//	History:    8.20.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

this.selecttext( 1, 2000)

end event

event rbuttondown;call super::rbuttondown;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      rbuttondown
//	Overrides:  No
//	Arguments:	
//	Overview:   This will redirect the rbuttondown to the parent object
//	Created by: Joel White
//	History:    8.23.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Parent.Event ue_showmenu()
end event

event ue_refreshtheme;call super::ue_refreshtheme;This.Modify("Datawindow.Color = '" + String(gn_globals.in_theme.of_get_backcolor()) +  "'")
end event

