$PBExportHeader$w_edit_sent_crrspndnce.srw
$PBExportComments$Window for documenting the need to edit sent correspondence.
forward
global type w_edit_sent_crrspndnce from w_main_std
end type
type st_4 from statictext within w_edit_sent_crrspndnce
end type
type p_1 from picture within w_edit_sent_crrspndnce
end type
type st_3 from statictext within w_edit_sent_crrspndnce
end type
type st_2 from statictext within w_edit_sent_crrspndnce
end type
type cb_cancel from commandbutton within w_edit_sent_crrspndnce
end type
type cb_ok from commandbutton within w_edit_sent_crrspndnce
end type
type dw_reopen_history from u_dw_std within w_edit_sent_crrspndnce
end type
type dw_reopen_details from u_dw_std within w_edit_sent_crrspndnce
end type
type ln_1 from line within w_edit_sent_crrspndnce
end type
type ln_2 from line within w_edit_sent_crrspndnce
end type
type st_1 from statictext within w_edit_sent_crrspndnce
end type
type ln_3 from line within w_edit_sent_crrspndnce
end type
type ln_4 from line within w_edit_sent_crrspndnce
end type
type ln_5 from line within w_edit_sent_crrspndnce
end type
type ln_6 from line within w_edit_sent_crrspndnce
end type
end forward

global type w_edit_sent_crrspndnce from w_main_std
string tag = "Re-open Case #: "
integer width = 2862
integer height = 1752
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
st_4 st_4
p_1 p_1
st_3 st_3
st_2 st_2
cb_cancel cb_cancel
cb_ok cb_ok
dw_reopen_history dw_reopen_history
dw_reopen_details dw_reopen_details
ln_1 ln_1
ln_2 ln_2
st_1 st_1
ln_3 ln_3
ln_4 ln_4
ln_5 ln_5
ln_6 ln_6
end type
global w_edit_sent_crrspndnce w_edit_sent_crrspndnce

type variables
BOOLEAN		ib_accepted
BOOLEAN		i_bCloseWindow

DATETIME		i_dtLastClosed

STRING		i_cLastClosedBy
STRING		i_cCaseNumber
STRING		i_cLogID

S_REOPEN_PARMS	i_sParms
end variables

forward prototypes
public function boolean of_validate ()
end prototypes

public function boolean of_validate ();STRING	l_cText
Long		ll_max_ID

l_cText = dw_reopen_details.GetItemString (1, 'reason')
IF IsNull (l_cText) OR l_cText = '' THEN
	
	Error.i_FWError = c_Fatal
	i_bCloseWindow = FALSE
	MessageBox (gs_appname, 'You must enter a reason for editing the sent correspondence.')
	
	Return False
	
ELSE

  SELECT max( cusfocus.correspondence_history.correspondence_hist_key)  
    INTO :ll_max_ID  
    FROM cusfocus.correspondence_history  ;

	
	//SetItem (i_CursorRow, 'correspondence_hist_key', fw_GetKeyValue ('correspondence_history'))
	dw_reopen_details.SetItem (1, 'correspondence_hist_key', ll_max_ID)
	Error.i_FWError = c_Success
	i_bCloseWindow = TRUE
	
	Return True
	
END IF
end function

on w_edit_sent_crrspndnce.create
int iCurrent
call super::create
this.st_4=create st_4
this.p_1=create p_1
this.st_3=create st_3
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_reopen_history=create dw_reopen_history
this.dw_reopen_details=create dw_reopen_details
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_1=create st_1
this.ln_3=create ln_3
this.ln_4=create ln_4
this.ln_5=create ln_5
this.ln_6=create ln_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.dw_reopen_history
this.Control[iCurrent+8]=this.dw_reopen_details
this.Control[iCurrent+9]=this.ln_1
this.Control[iCurrent+10]=this.ln_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.ln_3
this.Control[iCurrent+13]=this.ln_4
this.Control[iCurrent+14]=this.ln_5
this.Control[iCurrent+15]=this.ln_6
end on

on w_edit_sent_crrspndnce.destroy
call super::destroy
destroy(this.st_4)
destroy(this.p_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_reopen_history)
destroy(this.dw_reopen_details)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_1)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.ln_5)
destroy(this.ln_6)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_SetVariables
   Purpose:    set instance variables from window parameters

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

i_cCaseNumber = message.StringParm
//i_dtLastClosed = i_sParms.last_closed
//i_cLastClosedBy = i_sParms.last_closed_by
end event

event close;/*****************************************************************************************
   Event:      close
   Purpose:    Set return variables as necessary to control reopen functionality.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

//IF i_bReopenCase THEN
//	
//	i_sParms.reopen = 'Y'
//	i_sParms.log_id = i_cLogID
//	
//ELSE
//	
//	i_sParms.reopen = 'N'
//	i_sParms.log_id = ''
//	
//END IF

//Message.PowerObjectParm = i_sParms

//CLOSEwithreturn (Parent, 0)
//IF i_bCloseWindow THEN CLOSEwithreturn (Parent, 1)
If ib_accepted = True Then
	Message.DoubleParm = 1
Else
	Message.DoubleParm = 0
End If
//TriggerEvent('pc_close')


end event

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_SetOptions
   Purpose:    set instance variables from window parameters

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

Title = "Edit Sent Correspondence"
end event

type st_4 from statictext within w_edit_sent_crrspndnce
integer x = 32
integer y = 928
integer width = 626
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 12632256
string text = "Correspondence History"
boolean focusrectangle = false
end type

type p_1 from picture within w_edit_sent_crrspndnce
integer x = 55
integer y = 20
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Letter.bmp"
boolean focusrectangle = false
end type

type st_3 from statictext within w_edit_sent_crrspndnce
integer x = 238
integer y = 52
integer width = 800
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Edit Sent Correspondence"
boolean focusrectangle = false
end type

type st_2 from statictext within w_edit_sent_crrspndnce
integer width = 2898
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

type cb_cancel from commandbutton within w_edit_sent_crrspndnce
integer x = 2368
integer y = 1540
integer width = 421
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
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
ib_accepted = FALSE
Close(Parent)
end event

type cb_ok from commandbutton within w_edit_sent_crrspndnce
integer x = 1906
integer y = 1540
integer width = 421
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
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

If of_validate() <> True Then Return -1


IF dw_reopen_details.fu_save (dw_reopen_details.c_savechanges) = dw_reopen_details.c_Success THEN
	
	i_cLogID = String(dw_reopen_details.GetItemNumber (dw_reopen_details.i_CursorRow, 'correspondence_hist_key'))
	
	ib_accepted = True
	Close(Parent)
	
ELSE
	
	IF i_bCloseWindow THEN
		MessageBox (gs_appname, 'An error occurred while trying to log this action. ' + &
										'This case cannot be reopened without being logged.')
	END IF
	ib_accepted = FALSE
	dw_reopen_details.SetItemStatus (dw_reopen_details.i_CursorRow, 0, Primary!, NotModified!)
	dw_reopen_details.fu_ResetUpdate ()
	
END IF


end event

type dw_reopen_history from u_dw_std within w_edit_sent_crrspndnce
integer x = 27
integer y = 988
integer width = 2775
integer height = 484
integer taborder = 0
string dataobject = "d_sent_correspondence_history"
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

//fu_SetOptions (SQLCA, c_NullDW, c_NoShowEmpty + c_NoMenuButtonActivation + c_NoEnablePopup)
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
		//st_nodata_message.Visible = FALSE
		MessageBox (gs_appname, 'An error has occurred retrieving the case reopen history.')
		
	CASE 0
		//st_nodata_message.Visible = TRUE
		
	CASE ELSE
		//st_nodata_message.Visible = FALSE
		this.SetTransObject(SQLCA)
		this.retrieve(i_ccasenumber)
END CHOOSE


end event

type dw_reopen_details from u_dw_std within w_edit_sent_crrspndnce
integer y = 224
integer width = 2825
integer height = 712
integer taborder = 10
string dataobject = "d_edit_crrspndnce_reason"
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

event pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    Initialize a new reopen case entry

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

SetItem (i_CursorRow, "correspondence_id", i_cCaseNumber)
SetItem (i_CursorRow, "updated_by", OBJCA.WIN.fu_GetLogin (SQLCA))
SetItem (i_CursorRow, "updated_timestamp", fw_GetTimeStamp ())
SetItem	(i_CursorRow, "action", "Edit Sent")

SetColumn ("reason")

dw_reopen_history.SetTransObject(SQLCA)
dw_reopen_history.Retrieve(i_cCaseNumber)
end event

event pcd_savebefore;call super::pcd_savebefore;/*****************************************************************************************
   Event:      pcd_savebefore
   Purpose:    Set ID # and perform validation before saving.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	12/04/00 M. Caruso    Created.
*****************************************************************************************/

//STRING	l_cText
//Long		ll_max_ID
//
//l_cText = GetItemString (i_CursorRow, 'reason')
//IF IsNull (l_cText) OR l_cText = '' THEN
//	
//	Error.i_FWError = c_Fatal
//	i_bCloseWindow = FALSE
//	MessageBox (gs_appname, 'You must enter a reason for editing the sent correspondence.')
//	
//ELSE
//
//  SELECT max( cusfocus.correspondence_history.correspondence_hist_key)  
//    INTO :ll_max_ID  
//    FROM cusfocus.correspondence_history  ;
//
//	
//	//SetItem (i_CursorRow, 'correspondence_hist_key', fw_GetKeyValue ('correspondence_history'))
//	SetItem (i_CursorRow, 'correspondence_hist_key', ll_max_ID)
//	Error.i_FWError = c_Success
//	i_bCloseWindow = TRUE
//	
//END IF
end event

event editchanged;call super::editchanged;AcceptText()
end event

type ln_1 from line within w_edit_sent_crrspndnce
long linecolor = 8421504
integer linethickness = 1
integer beginx = 5
integer beginy = 1492
integer endx = 2898
integer endy = 1492
end type

type ln_2 from line within w_edit_sent_crrspndnce
long linecolor = 16777215
integer linethickness = 1
integer beginx = 5
integer beginy = 1496
integer endx = 2894
integer endy = 1496
end type

type st_1 from statictext within w_edit_sent_crrspndnce
integer y = 1500
integer width = 3017
integer height = 180
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type ln_3 from line within w_edit_sent_crrspndnce
long linecolor = 8421504
integer linethickness = 1
integer beginy = 188
integer endx = 2894
integer endy = 188
end type

type ln_4 from line within w_edit_sent_crrspndnce
long linecolor = 16777215
integer linethickness = 1
integer beginy = 192
integer endx = 2889
integer endy = 192
end type

type ln_5 from line within w_edit_sent_crrspndnce
long linecolor = 16777215
integer linethickness = 1
integer beginx = 690
integer beginy = 956
integer endx = 2811
integer endy = 956
end type

type ln_6 from line within w_edit_sent_crrspndnce
long linecolor = 8421504
integer linethickness = 1
integer beginx = 690
integer beginy = 960
integer endx = 2811
integer endy = 960
end type

