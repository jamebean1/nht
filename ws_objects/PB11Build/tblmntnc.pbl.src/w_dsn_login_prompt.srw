$PBExportHeader$w_dsn_login_prompt.srw
$PBExportComments$Prompt the user to enter a username and password for the selected DSN in u_iim_config.dw_tab_details.
forward
global type w_dsn_login_prompt from w_response_std
end type
type st_password from statictext within w_dsn_login_prompt
end type
type st_username from statictext within w_dsn_login_prompt
end type
type sle_password from singlelineedit within w_dsn_login_prompt
end type
type sle_username from singlelineedit within w_dsn_login_prompt
end type
type st_prompt from statictext within w_dsn_login_prompt
end type
type cb_cancel from commandbutton within w_dsn_login_prompt
end type
type cb_ok from commandbutton within w_dsn_login_prompt
end type
end forward

global type w_dsn_login_prompt from w_response_std
integer width = 1842
integer height = 644
string title = "CustomerFocus"
boolean controlmenu = false
long backcolor = 79748288
st_password st_password
st_username st_username
sle_password sle_password
sle_username sle_username
st_prompt st_prompt
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_dsn_login_prompt w_dsn_login_prompt

type variables
INTEGER		i_nCloseMethod

S_DSN_PARMS	i_sParms
end variables

on w_dsn_login_prompt.create
int iCurrent
call super::create
this.st_password=create st_password
this.st_username=create st_username
this.sle_password=create sle_password
this.sle_username=create sle_username
this.st_prompt=create st_prompt
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_password
this.Control[iCurrent+2]=this.st_username
this.Control[iCurrent+3]=this.sle_password
this.Control[iCurrent+4]=this.sle_username
this.Control[iCurrent+5]=this.st_prompt
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_ok
end on

on w_dsn_login_prompt.destroy
call super::destroy
destroy(this.st_password)
destroy(this.st_username)
destroy(this.sle_password)
destroy(this.sle_username)
destroy(this.st_prompt)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    Get any values being passed to the window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/00  M. Caruso    Created.
*****************************************************************************************/

i_sParms = PowerObject_Parm
end event

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    Initialize the window with any passed values.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/00  M. Caruso    Created.
*****************************************************************************************/

fw_SetOptions (c_AutoPosition)

sle_username.text = i_sParms.username
sle_password.text = i_sParms.password
st_prompt.text += (i_sParms.dsn_name + ":")
end event

event pc_close;call super::pc_close;/*****************************************************************************************
   Event:      pc_close
   Purpose:    Return the new values for username and password to the calling window

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/00  M. Caruso    Created.
*****************************************************************************************/

message.powerobjectparm = i_sParms
end event

event pc_closequery;call super::pc_closequery;/*****************************************************************************************
   Event:      pc_CloseQuery
   Purpose:    Verify that the useranme and password are set or give the user the chance
					to stop the close process and set them.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/17/00  M. Caruso    Created.
	11/25/2002 K. Claver  Commented out the check for a blank password as the client may
								 use a username without a password.
*****************************************************************************************/

INTEGER	l_nRtn

CHOOSE CASE i_nCloseMethod
	CASE 1
		i_sParms.username = sle_username.text
		i_sParms.password = sle_password.text
		IF sle_username.text = "" THEN
	
			l_nRtn = MessageBox (gs_AppName, &
										'The login information is not complete.  Data accessed~r~n' + &
										'by this data source will not available.  Do you wish~r~n' + &
										'to complete this information?', StopSign!, YesNo!, 1)
										
			IF l_nRtn = 1 THEN
				Error.i_FWError = c_Fatal
			ELSE
				Error.i_FWError = c_Success
			END IF
		
		ELSE
			Error.i_FWError = c_Success
		END IF
		
	CASE 0
		i_sParms.username = ""
		i_sParms.password = ""
		Error.i_FWError = c_Success
		
END CHOOSE

end event

event key;call super::key;/*****************************************************************************************
   Event:      key
   Purpose:    Trigger a Cancel-style close of the window when the user presses the ESC key

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	4/3/00   M. Caruso    Created.
*****************************************************************************************/


IF key = KeyEscape! THEN cb_cancel.triggerevent ("clicked")
end event

event open;call super::open;IF gs_AppName <> "" THEN
	THIS.Title = gs_AppName
END IF
end event

type st_password from statictext within w_dsn_login_prompt
integer x = 599
integer y = 292
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_username from statictext within w_dsn_login_prompt
integer x = 599
integer y = 188
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Username:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_password from singlelineedit within w_dsn_login_prompt
integer x = 1047
integer y = 284
integer width = 599
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type sle_username from singlelineedit within w_dsn_login_prompt
integer x = 1047
integer y = 180
integer width = 599
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_prompt from statictext within w_dsn_login_prompt
integer x = 64
integer y = 56
integer width = 1723
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please enter your login information for "
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_dsn_login_prompt
integer x = 1326
integer y = 424
integer width = 320
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;call super::clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Close the window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/00  M. Caruso    Created.
*****************************************************************************************/

i_nCloseMethod = 0

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   Close(FWCA.MGR.i_WindowCurrent)
END IF
end event

type cb_ok from commandbutton within w_dsn_login_prompt
integer x = 969
integer y = 424
integer width = 320
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Close the window, returning the new values.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	2/28/00  M. Caruso    Created.
*****************************************************************************************/

i_nCloseMethod = 1

IF IsValid(FWCA.MGR.i_WindowCurrent) THEN
   Close(FWCA.MGR.i_WindowCurrent)
END IF
end event

