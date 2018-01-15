$PBExportHeader$w_system_options.srw
$PBExportComments$System options window.
forward
global type w_system_options from w_response_std
end type
type tab_folder from tab within w_system_options
end type
type tabpage_case from u_tabpage_options_case within tab_folder
end type
type tabpage_case from u_tabpage_options_case within tab_folder
end type
type tabpage_carve_out from u_tabpage_options_carve_out within tab_folder
end type
type tabpage_carve_out from u_tabpage_options_carve_out within tab_folder
end type
type tabpage_file_locs from u_tabpage_options_file_locs within tab_folder
end type
type tabpage_file_locs from u_tabpage_options_file_locs within tab_folder
end type
type tabpage_other from u_tabpage_options_other within tab_folder
end type
type tabpage_other from u_tabpage_options_other within tab_folder
end type
type tabpage_appeals from u_tabpage_options_appeals within tab_folder
end type
type tabpage_appeals from u_tabpage_options_appeals within tab_folder
end type
type tabpage_fax from u_tabpage_options_rightfax within tab_folder
end type
type tabpage_fax from u_tabpage_options_rightfax within tab_folder
end type
type tab_folder from tab within w_system_options
tabpage_case tabpage_case
tabpage_carve_out tabpage_carve_out
tabpage_file_locs tabpage_file_locs
tabpage_other tabpage_other
tabpage_appeals tabpage_appeals
tabpage_fax tabpage_fax
end type
type cb_cancel from commandbutton within w_system_options
end type
type cb_ok from commandbutton within w_system_options
end type
end forward

global type w_system_options from w_response_std
integer width = 1984
integer height = 2448
string title = "Options"
tab_folder tab_folder
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_system_options w_system_options

type variables
BOOLEAN			i_bCloseWindow
BOOLEAN			i_bSaveFailed

U_DSSYSOPTIONS	i_dsOptions
end variables

on w_system_options.create
int iCurrent
call super::create
this.tab_folder=create tab_folder
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_folder
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
end on

on w_system_options.destroy
call super::destroy
destroy(this.tab_folder)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Initialize the window and main objects on it.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/07/00 M. Caruso    Created.
*****************************************************************************************/

fw_SetOptions (c_NoEnablePopup + c_AutoPosition)

// initialize the options datastore and retrieve the options from the database
i_dsOptions = CREATE u_dsSysOptions
i_dsOptions.SetTransObject (SQLCA)
i_dsOptions.Retrieve ()

// initialize the tab pages
tab_folder.TabTriggerEvent ("ue_initpage")
end event

type tab_folder from tab within w_system_options
string tag = "Fax"
integer x = 27
integer y = 28
integer width = 1929
integer height = 2164
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_case tabpage_case
tabpage_carve_out tabpage_carve_out
tabpage_file_locs tabpage_file_locs
tabpage_other tabpage_other
tabpage_appeals tabpage_appeals
tabpage_fax tabpage_fax
end type

on tab_folder.create
this.tabpage_case=create tabpage_case
this.tabpage_carve_out=create tabpage_carve_out
this.tabpage_file_locs=create tabpage_file_locs
this.tabpage_other=create tabpage_other
this.tabpage_appeals=create tabpage_appeals
this.tabpage_fax=create tabpage_fax
this.Control[]={this.tabpage_case,&
this.tabpage_carve_out,&
this.tabpage_file_locs,&
this.tabpage_other,&
this.tabpage_appeals,&
this.tabpage_fax}
end on

on tab_folder.destroy
destroy(this.tabpage_case)
destroy(this.tabpage_carve_out)
destroy(this.tabpage_file_locs)
destroy(this.tabpage_other)
destroy(this.tabpage_appeals)
destroy(this.tabpage_fax)
end on

type tabpage_case from u_tabpage_options_case within tab_folder
integer x = 18
integer y = 112
integer height = 2036
end type

type tabpage_carve_out from u_tabpage_options_carve_out within tab_folder
integer x = 18
integer y = 112
integer width = 1893
integer height = 2036
end type

type tabpage_file_locs from u_tabpage_options_file_locs within tab_folder
integer x = 18
integer y = 112
integer width = 1893
integer height = 2036
end type

type tabpage_other from u_tabpage_options_other within tab_folder
integer x = 18
integer y = 112
integer width = 1893
integer height = 2036
end type

type tabpage_appeals from u_tabpage_options_appeals within tab_folder
integer x = 18
integer y = 112
integer width = 1893
integer height = 2036
string text = "Appeals"
string powertiptext = "Appeals"
end type

type tabpage_fax from u_tabpage_options_rightfax within tab_folder
string tag = "Fax"
boolean visible = false
integer x = 18
integer y = 112
integer width = 1893
integer height = 2036
boolean enabled = false
string text = "Fax"
end type

type cb_cancel from commandbutton within w_system_options
integer x = 1518
integer y = 2236
integer width = 411
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Close the window, ignoring any changes.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/11/00 M. Caruso    Created.
*****************************************************************************************/

CLOSE (PARENT)
end event

type cb_ok from commandbutton within w_system_options
integer x = 1079
integer y = 2236
integer width = 411
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Save the options and close the window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/08/00 M. Caruso    Created.
*****************************************************************************************/

// save the current settings back to the datastore
i_bSaveFailed = FALSE
i_bCloseWindow = TRUE
tab_folder.TabTriggerEvent ("ue_savepage")

IF NOT i_bSaveFailed THEN
	IF i_dsOptions.Update () = -1 THEN
		Messagebox (gs_appname, "An error occurred while saving the system options. " + &
										"Your changes could not be saved.")
	END IF
END IF

IF i_bCloseWindow THEN CLOSE (PARENT)
end event

