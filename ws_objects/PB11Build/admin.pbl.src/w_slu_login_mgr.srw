$PBExportHeader$w_slu_login_mgr.srw
$PBExportComments$Manage user logins.
forward
global type w_slu_login_mgr from w_main_std
end type
type cb_delete from u_cb_delete within w_slu_login_mgr
end type
type dw_login_list from u_dw_std within w_slu_login_mgr
end type
type cb_ok from u_cb_close within w_slu_login_mgr
end type
type cb_save from u_cb_save within w_slu_login_mgr
end type
type cb_cancel from u_cb_cancel within w_slu_login_mgr
end type
end forward

global type w_slu_login_mgr from w_main_std
integer width = 2519
integer height = 1492
string title = "User Login Management"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_delete cb_delete
dw_login_list dw_login_list
cb_ok cb_ok
cb_save cb_save
cb_cancel cb_cancel
end type
global w_slu_login_mgr w_slu_login_mgr

type variables
long il_selected_rows[]
end variables

on w_slu_login_mgr.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.dw_login_list=create dw_login_list
this.cb_ok=create cb_ok
this.cb_save=create cb_save
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.dw_login_list
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.cb_save
this.Control[iCurrent+5]=this.cb_cancel
end on

on w_slu_login_mgr.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.dw_login_list)
destroy(this.cb_ok)
destroy(this.cb_save)
destroy(this.cb_cancel)
end on

type cb_delete from u_cb_delete within w_slu_login_mgr
integer x = 393
integer y = 1252
integer width = 320
integer taborder = 50
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;//******************************************************************
//  Event         : Clicked
//  Description   : Enable the Save button.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  8/9/00   M. Caruso  Created.
//******************************************************************
long	ll_messagebox_return, i
string ls_login_name

cb_save.enabled = TRUE

ll_messagebox_return = gn_globals.in_messagebox.of_messagebox("Deleting an active user(s) in the system will immediately terminate the user's connection to the database and may result in a loss of work. ~r~n ~r~nAre you sure that you wish to delete this user(s)?", Question!, YesNoCancel!, 3)

If ll_messagebox_return <> 1 Then
	//Do Nothing
Else
	//Call the stored proc to kill the login and pass the login name.
	For i = 1 to UpperBound(il_selected_rows[])
		ls_login_name = dw_login_list.GetItemString(il_selected_rows[i], 'user_id')

		DECLARE sp_kill_login procedure for sp_kill_login
		@vc_login_name = :ls_login_name;
	
		execute sp_kill_login;
		
		IF SQLCA.SQLCode = -1 THEN 
			MessageBox("SQL error", SQLCA.SQLErrText)
		Else
			dw_login_list.DeleteRow(il_selected_rows[i])
			dw_login_list.Update()
			dw_login_list.SetItemStatus(il_selected_rows[i], 0, Primary!, NotModified!)
		END IF
	Next
	
End If



end event

type dw_login_list from u_dw_std within w_slu_login_mgr
integer x = 37
integer y = 32
integer width = 2418
integer height = 1176
integer taborder = 10
string dataobject = "d_login_mgr"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
boolean i_retrieveonopen = true
end type

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve the license information from the database.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/8/00   M. Caruso    Created.
*****************************************************************************************/

CHOOSE CASE Retrieve ()
	CASE 0
		messagebox (gs_AppName, 'There are no users logged in to CustomerFocus.')
		
	CASE IS < 0
		messagebox (gs_AppName, 'CustomerFocus was unable to retrieve the user login list.')
		
END CHOOSE
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    define the functionality of this datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	8/7/00   M. Caruso    Created.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_DeleteOK + c_SelectOnClick + &
										  c_Multiselect + c_NoEnablePopup)
end event

event pcd_pickedrow;call super::pcd_pickedrow;il_selected_rows[] = selected_rows[]


end event

type cb_ok from u_cb_close within w_slu_login_mgr
integer x = 1778
integer y = 1252
integer width = 320
integer taborder = 40
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

type cb_save from u_cb_save within w_slu_login_mgr
integer x = 37
integer y = 1252
integer width = 320
integer taborder = 30
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type cb_cancel from u_cb_cancel within w_slu_login_mgr
integer x = 2135
integer y = 1252
integer width = 320
integer taborder = 20
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
end type

event clicked;call super::clicked;//******************************************************************
//  Event         : Clicked
//  Description   : Close the current window when processing is done.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  8/8/00   M. Caruso  Created.
//******************************************************************

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   Close(FWCA.MGR.i_WindowCurrent)
END IF

end event

