$PBExportHeader$w_basewindow.srw
$PBExportComments$This is the base object for all windows except for the frame.
forward
global type w_basewindow from window
end type
end forward

shared variables
int si_title_bar_height
end variables

global type w_basewindow from window
integer x = 672
integer y = 264
integer width = 1582
integer height = 992
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 12632256
event ue_srch pbm_custom06
event ue_prnt pbm_custom08
event ue_wndw_pstn_chngd pbm_windowposchanged
event ue_refreshtheme ( )
event ue_commontasks_reset ( )
event ue_commontasks_settarget ( powerobject ao_target )
event ue_commontasks_additem ( string as_menutext,  string as_message,  string as_argument )
event ue_commontasks_setgui ( powerobject ao_gui )
event ue_commontasks_showmenu ( )
event ue_set_desktopserviceviewer ( powerobject au_desktopserviceviewer )
event type long ue_open_tool ( string as_parameters )
event type u_dynamic_gui ue_get_desktopserviceviewer ( )
end type
global w_basewindow w_basewindow

type variables
int ii_cascade_position=1
w_basewindow iw_active_sheet
Boolean ib_open = False
Protected:
	u_dynamic_gui iu_menuoptions
	u_dynamic_gui iu_DesktopServiceViewer
end variables

forward prototypes
public subroutine wf_cscde ()
public function boolean wf_othrs_of_me_opn ()
end prototypes

on ue_wndw_pstn_chngd;//if isvalid( w_drpdwnppup) then w_drpdwnppup.wf_pstn_drpdwnppup()

//if isvalid( gnv_drpdwnppup_mngr) then
//
//	gnv_drpdwnppup_mngr.position_visible()
//
//end if
end on

event ue_refreshtheme;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_refreshtheme
// Overrides:  No
// Overview:   This will cause all controls to refresh their theme
// Created by: Blake Doerr
// History:    6/2/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_array, ll_count

ll_array=UpperBound(control)
for ll_count = 1 to ll_array
		if isvalid(control[ll_count]) then
			control[ll_count].triggerevent('ue_refreshtheme')
		end if
next

end event

event ue_commontasks_reset();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_commontasks_reset
//	Overrides:  No
//	Arguments:	
//	Overview:   Reset the common tasks object
//	Created by: Blake Doerr
//	History:    12/10/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(iu_menuoptions) Then
	iu_menuoptions.Dynamic of_reset()
End If
end event

event ue_commontasks_settarget(powerobject ao_target);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_commontasks_settarget
//	Overrides:  No
//	Arguments:	
//	Overview:   Set the target for the menu options
//	Created by: Blake Doerr
//	History:    12/10/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(iu_menuoptions) Then
	iu_menuoptions.Dynamic of_set_target(ao_target)
End If
end event

event ue_commontasks_additem(string as_menutext, string as_message, string as_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_commontasks_reset
//	Overrides:  No
//	Arguments:	
//	Overview:   Reset the common tasks object
//	Created by: Blake Doerr
//	History:    12/10/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(iu_menuoptions) Then
	iu_menuoptions.Dynamic of_add_item(as_menutext, as_message, as_argument)
End If
end event

event ue_commontasks_setgui(powerobject ao_gui);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_commontasks_setgui
//	Overrides:  No
//	Arguments:	
//	Overview:   Set the target for the menu options
//	Created by: Blake Doerr
//	History:    12/10/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

iu_menuoptions = ao_gui
end event

event ue_commontasks_showmenu();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_commontasks_showmenu
//	Overrides:  No
//	Arguments:	
//	Overview:   Reset the common tasks object
//	Created by: Blake Doerr
//	History:    12/10/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If IsValid(iu_menuoptions) Then
	iu_menuoptions.Dynamic of_showmenu()
End If
end event

event ue_set_desktopserviceviewer(u_dynamic_gui au_desktopserviceviewer);iu_DesktopServiceViewer = au_desktopserviceviewer
end event

event type long ue_open_tool(string as_parameters);If IsValid(iu_DesktopServiceViewer) Then
	iu_DesktopServiceViewer.Dynamic Event ue_notify('open', as_parameters)
Else
	Return -1
End If

Return 1
end event

event type u_dynamic_gui ue_get_desktopserviceviewer();Return iu_DesktopServiceViewer
end event

public subroutine wf_cscde ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:   wf_cscde
// Overrides:  No
// Overview:   This will cascade the window
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declare a local variable to hold a pointer to the active sheet.
//

w_basewindow w_sheet
window w_tmp
int i_TitleBarHeight, i_mdi_1, i_frame, i_sheet

i_TitleBarHeight = si_title_bar_height

//Assign the frame's active sheet to my local variable.
//
w_tmp=parentwindow()
if w_tmp<>w_mdi_frame then
	return
end if
w_sheet = parentwindow().getactivesheet()
iw_active_sheet=this

//Check to see if there is currently an active sheet...
//  If so, this sheet number will be one greater than the active sheet.
//
If isvalid(w_sheet) Then

	ii_cascade_position = w_sheet.ii_cascade_position + 1

end if

//Move the sheet to its cascade position.
//  (Notice that if this is the first sheet, it will be moved to 0,0)
//
This.Move (si_title_bar_height * (ii_cascade_position - 1), si_title_bar_height * (ii_cascade_position - 1) )

//If this is the first sheet, calculate the titlebar height.
//This will be the offset for positioning future sheets.
//
If ii_cascade_position = 1 Then

	i_mdi_1 =  w_mdi_frame.mdi_1.y
	i_frame = w_mdi_frame.workspacey()
	i_sheet = this.workspacey() 

	si_title_bar_height =  this.workspacey() - w_mdi_frame.workspacey() - w_mdi_frame.mdi_1.y 
//this.workspacey() + w_mdi_frame.mdi_1.y - w_mdi_frame.workspacey()

End If

//The following logic is checking to make sure I didn't just move the window off of the screen.
// If I did, reset the sheet's number to one and start cascading at the top again.
//
If this.workspacex() + this.workspacewidth() > parentwindow().workspacex() + parentwindow().workspacewidth() or &
	this.workspacey() + this.workspaceheight() > parentwindow().workspacey() + parentwindow().workspaceheight() Then

	ii_cascade_position = 1
	This.Move ( si_title_bar_height * (ii_cascade_position - 1), si_title_bar_height * (ii_cascade_position - 1) )

End If

end subroutine

public function boolean wf_othrs_of_me_opn ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:      wf_othrs_of_me_opn
// Overview:   This will return whether or not there are other windows of the same classname open
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//Declarations
window w_temp
string s_clss

w_temp=w_mdi_frame.GetFirstSheet()
do until IsValid(w_temp)=false
	if w_temp.classname()=this.classname() then
		return true
	end if
	w_temp=w_mdi_frame.GetNextSheet(w_temp)
loop

return false
end function

event close;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Close
// Overrides:  No
// Overview:   DocumentScriptFunctionality
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

// Publish a message that the window is closing
gn_globals.in_subscription_service.of_message('CloseWindow',This)
end event

event open;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Event Name
// Overrides:  No
// Overview:   Publish a message that the window is open
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Declarations
iw_active_sheet=this

// Publish a message that the window has opened
gn_globals.in_subscription_service.of_message('OpenWindow',This)


end event

event activate;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      activate
// Overrides:  No
// Overview:   This will publish the message that the window is activated and sets the open variable to true
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


gn_globals.in_subscription_service.of_message('ActivateWindow',This)
ib_open = true
end event

event clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   This will manage dropdownpopup windows.  When you click on the window itself we need to close all popups
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

if isvalid( w_drpdwnppup) then close( w_drpdwnppup)

if isvalid( gn_globals.gnv_drpdwnppup_mngr) then
	 gn_globals.gnv_drpdwnppup_mngr.hideall()
end if
end event

event hide;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Hide
// Overview:   Close all popups
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

if isvalid(  gn_globals.gnv_drpdwnppup_mngr) then
	 gn_globals.gnv_drpdwnppup_mngr.close_drpdwnppups( this, FALSE)
end if
end event

on w_basewindow.create
end on

on w_basewindow.destroy
end on

