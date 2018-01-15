$PBExportHeader$w_reopen_case.srw
$PBExportComments$Re-open Case processing window.
forward
global type w_reopen_case from w_main_std
end type
type p_1 from picture within w_reopen_case
end type
type st_5 from statictext within w_reopen_case
end type
type st_3 from statictext within w_reopen_case
end type
type st_2 from statictext within w_reopen_case
end type
type st_1 from statictext within w_reopen_case
end type
type st_nodata_message from statictext within w_reopen_case
end type
type cb_cancel from commandbutton within w_reopen_case
end type
type cb_ok from commandbutton within w_reopen_case
end type
type dw_reopen_history from u_dw_std within w_reopen_case
end type
type dw_reopen_details from u_dw_std within w_reopen_case
end type
type ln_1 from line within w_reopen_case
end type
type ln_2 from line within w_reopen_case
end type
type ln_3 from line within w_reopen_case
end type
type ln_4 from line within w_reopen_case
end type
type ln_5 from line within w_reopen_case
end type
type ln_6 from line within w_reopen_case
end type
type ln_7 from line within w_reopen_case
end type
type ln_8 from line within w_reopen_case
end type
type st_4 from statictext within w_reopen_case
end type
end forward

global type w_reopen_case from w_main_std
string tag = "Re-open Case #: "
integer width = 2926
integer height = 1672
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
p_1 p_1
st_5 st_5
st_3 st_3
st_2 st_2
st_1 st_1
st_nodata_message st_nodata_message
cb_cancel cb_cancel
cb_ok cb_ok
dw_reopen_history dw_reopen_history
dw_reopen_details dw_reopen_details
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
ln_5 ln_5
ln_6 ln_6
ln_7 ln_7
ln_8 ln_8
st_4 st_4
end type
global w_reopen_case w_reopen_case

type variables
BOOLEAN		i_bReopenCase
BOOLEAN		i_bCloseWindow

DATETIME		i_dtLastClosed

STRING		i_cLastClosedBy
STRING		i_cCaseNumber
STRING		i_cLogID

S_REOPEN_PARMS	i_sParms
end variables

on w_reopen_case.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_5=create st_5
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.st_nodata_message=create st_nodata_message
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_reopen_history=create dw_reopen_history
this.dw_reopen_details=create dw_reopen_details
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.ln_5=create ln_5
this.ln_6=create ln_6
this.ln_7=create ln_7
this.ln_8=create ln_8
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_nodata_message
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.cb_ok
this.Control[iCurrent+9]=this.dw_reopen_history
this.Control[iCurrent+10]=this.dw_reopen_details
this.Control[iCurrent+11]=this.ln_1
this.Control[iCurrent+12]=this.ln_2
this.Control[iCurrent+13]=this.ln_3
this.Control[iCurrent+14]=this.ln_4
this.Control[iCurrent+15]=this.ln_5
this.Control[iCurrent+16]=this.ln_6
this.Control[iCurrent+17]=this.ln_7
this.Control[iCurrent+18]=this.ln_8
this.Control[iCurrent+19]=this.st_4
end on

on w_reopen_case.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_nodata_message)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_reopen_history)
destroy(this.dw_reopen_details)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.ln_5)
destroy(this.ln_6)
destroy(this.ln_7)
destroy(this.ln_8)
destroy(this.st_4)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_SetVariables
   Purpose:    set instance variables from window parameters

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

i_sParms = message.PowerObjectParm

i_cCaseNumber = i_sParms.case_number
i_dtLastClosed = i_sParms.last_closed
i_cLastClosedBy = i_sParms.last_closed_by
end event

event close;call super::close;/*****************************************************************************************
   Event:      close
   Purpose:    Set return variables as necessary to control reopen functionality.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

IF i_bReopenCase THEN
	
	i_sParms.reopen = 'Y'
	i_sParms.log_id = i_cLogID
	
ELSE
	
	i_sParms.reopen = 'N'
	i_sParms.log_id = ''
	
END IF

Message.PowerObjectParm = i_sParms
end event

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    set instance variables from window parameters

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

Title = Tag + i_cCaseNumber
end event

type p_1 from picture within w_reopen_case
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_5 from statictext within w_reopen_case
integer x = 201
integer y = 60
integer width = 1499
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Reopen Case"
boolean focusrectangle = false
end type

type st_3 from statictext within w_reopen_case
integer width = 3502
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_2 from statictext within w_reopen_case
integer x = 32
integer y = 224
integer width = 457
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reopen Case Details"
boolean focusrectangle = false
end type

type st_1 from statictext within w_reopen_case
integer x = 37
integer y = 808
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reopen History"
boolean focusrectangle = false
end type

type st_nodata_message from statictext within w_reopen_case
boolean visible = false
integer x = 87
integer y = 900
integer width = 1902
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "This case has not previously been reopened."
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_reopen_case
integer x = 2459
integer y = 1460
integer width = 320
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Close the window and abort the reopen process.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

dw_reopen_details.SetItemStatus (dw_reopen_details.i_CursorRow, 0, Primary!, NotModified!)
dw_reopen_details.fu_ResetUpdate ()
i_bReopenCase = FALSE
CLOSE (Parent)
end event

type cb_ok from commandbutton within w_reopen_case
integer x = 2103
integer y = 1460
integer width = 320
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Save the reopen log entry and close the window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/



IF dw_reopen_details.fu_save (dw_reopen_details.c_savechanges) = dw_reopen_details.c_Success THEN
	
	i_bReopenCase = TRUE
	i_cLogID = dw_reopen_details.GetItemString (dw_reopen_details.i_CursorRow, 'reopen_log_id')
	
ELSE
	
	IF i_bCloseWindow THEN
		MessageBox (gs_appname, 'An error occurred while trying to log this action. ' + &
										'This case cannot be reopened without being logged.')
	END IF
	i_bReopenCase = FALSE
	dw_reopen_details.SetItemStatus (dw_reopen_details.i_CursorRow, 0, Primary!, NotModified!)
	dw_reopen_details.fu_ResetUpdate ()
	
END IF

IF i_bCloseWindow THEN CLOSE (Parent)
end event

type dw_reopen_history from u_dw_std within w_reopen_case
integer x = 73
integer y = 888
integer width = 2779
integer height = 476
integer taborder = 0
string dataobject = "d_reopen_history"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize this datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
	12/19/00 M. Caruso    Removed c_NoRetrieveOnOpen
	12/20/00 M. Caruso    Added c_NoEnablePopup
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_NoShowEmpty + c_NoMenuButtonActivation + c_NoEnablePopup)
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    retrieve records for this datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

CHOOSE CASE retrieve (i_ccasenumber)
	CASE IS < 0
		st_nodata_message.Visible = FALSE
		MessageBox (gs_appname, 'An error has occurred retrieving the case reopen history.')
		
	CASE 0
		st_nodata_message.Visible = TRUE
		
	CASE ELSE
		st_nodata_message.Visible = FALSE
		
END CHOOSE
end event

type dw_reopen_details from u_dw_std within w_reopen_case
integer x = 73
integer y = 312
integer width = 2802
integer height = 496
integer taborder = 10
string dataobject = "d_reopen_details"
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    initialize this datawindow

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
	12/19/00 M. Caruso    Added c_NoEnablePopup to the option list.
*****************************************************************************************/

fu_SetOptions (SQLCA, c_NullDW, c_NewOK + c_NewOnOpen + c_NewModeOnEmpty + &
					c_NoMenuButtonActivation + c_NoEnablePopup)
i_EnablePopup = FALSE
end event

event pcd_new;call super::pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    Initialize a new reopen case entry

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

SetItem (i_CursorRow, "case_number", i_cCaseNumber)
SetItem (i_CursorRow, "last_closed_by", i_cLastClosedBy)
SetItem (i_CursorRow, "last_closed_timestamp", i_dtLastClosed)
SetItem (i_CursorRow, "reopened_by", OBJCA.WIN.fu_GetLogin (SQLCA))
SetItem (i_CursorRow, "reopened_timestamp", fw_GetTimeStamp ())

SetColumn ("reopened_reason")
end event

event pcd_savebefore;call super::pcd_savebefore;/*****************************************************************************************
   Event:      pcd_savebefore
   Purpose:    Set ID # and perform validation before saving.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cText

l_cText = GetItemString (i_CursorRow, 'reopened_reason')
IF IsNull (l_cText) OR l_cText = '' THEN
	
	MessageBox (gs_appname, 'You must enter a reason for reopening the case.')
	Error.i_FWError = c_Fatal
	i_bCloseWindow = FALSE
	
ELSE
	
	SetItem (i_CursorRow, 'reopen_log_id', fw_GetKeyValue ('reopen_log'))
	Error.i_FWError = c_Success
	i_bCloseWindow = TRUE
	
END IF
end event

type ln_1 from line within w_reopen_case
long linecolor = 8421504
integer linethickness = 4
integer beginx = 402
integer beginy = 836
integer endx = 2894
integer endy = 836
end type

type ln_2 from line within w_reopen_case
long linecolor = 16777215
integer linethickness = 4
integer beginx = 402
integer beginy = 840
integer endx = 2894
integer endy = 840
end type

type ln_3 from line within w_reopen_case
long linecolor = 8421504
integer linethickness = 4
integer beginx = 512
integer beginy = 248
integer endx = 2894
integer endy = 248
end type

type ln_4 from line within w_reopen_case
long linecolor = 16777215
integer linethickness = 4
integer beginx = 512
integer beginy = 252
integer endx = 2894
integer endy = 252
end type

type ln_5 from line within w_reopen_case
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1408
integer endx = 3401
integer endy = 1408
end type

type ln_6 from line within w_reopen_case
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1412
integer endx = 3401
integer endy = 1412
end type

type ln_7 from line within w_reopen_case
long linecolor = 8421504
integer linethickness = 4
integer beginy = 184
integer endx = 3401
integer endy = 184
end type

type ln_8 from line within w_reopen_case
long linecolor = 16777215
integer linethickness = 4
integer beginy = 188
integer endx = 3401
integer endy = 188
end type

type st_4 from statictext within w_reopen_case
integer y = 1416
integer width = 3502
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217747
boolean focusrectangle = false
end type

