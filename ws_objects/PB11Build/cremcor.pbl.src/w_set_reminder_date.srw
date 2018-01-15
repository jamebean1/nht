$PBExportHeader$w_set_reminder_date.srw
$PBExportComments$Set Reminder Date Response DataWindow
forward
global type w_set_reminder_date from w_response_std
end type
type dw_calendar from u_calendar within w_set_reminder_date
end type
type mle_reminder_comments from multilineedit within w_set_reminder_date
end type
type st_1 from statictext within w_set_reminder_date
end type
type st_2 from statictext within w_set_reminder_date
end type
type cb_ok from commandbutton within w_set_reminder_date
end type
type cb_cancel from commandbutton within w_set_reminder_date
end type
type em_reminder_date from editmask within w_set_reminder_date
end type
end forward

global type w_set_reminder_date from w_response_std
integer x = 978
integer y = 640
integer width = 2697
integer height = 1056
string title = "Case Reminder"
long backcolor = 79748288
dw_calendar dw_calendar
mle_reminder_comments mle_reminder_comments
st_1 st_1
st_2 st_2
cb_ok cb_ok
cb_cancel cb_cancel
em_reminder_date em_reminder_date
end type
global w_set_reminder_date w_set_reminder_date

event pc_setoptions;call super::pc_setoptions;//****************************************************************************************
//
//		Event:	pc_setoptions
//		Purpose:	Set the Reminder date to Todya and select the field.
//		
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------
//  03/20/00 C. Jackson  Added fu_CalCreate()   (SCR 319)
//
//****************************************************************************************/

em_reminder_date.Text = STring(Today(),"m/d/yyyy")

dw_calendar.fu_CalCreate()



end event

on w_set_reminder_date.create
int iCurrent
call super::create
this.dw_calendar=create dw_calendar
this.mle_reminder_comments=create mle_reminder_comments
this.st_1=create st_1
this.st_2=create st_2
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.em_reminder_date=create em_reminder_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_calendar
this.Control[iCurrent+2]=this.mle_reminder_comments
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.em_reminder_date
end on

on w_set_reminder_date.destroy
call super::destroy
destroy(this.dw_calendar)
destroy(this.mle_reminder_comments)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.em_reminder_date)
end on

type dw_calendar from u_calendar within w_set_reminder_date
integer x = 1627
integer y = 56
integer taborder = 20
end type

event po_daychanged;call super::po_daychanged;//*************************************************************************************
//
//			Event:	po_daychanged
//		 Purpose:	To determine what day the user has selected for the Case Reminder.
//
// Date     Developer   Description
// -------- ----------- --------------------------------------------------------------
// 03/20/00 C. Jackson  Original Version
//
//*************************************************************************************/

DATE l_dNullDate, l_dDate
INTEGER l_nGetYear, l_nGetMonth
STRING l_cDate, l_cToday

em_reminder_date.Text = STring(Today(),"m/d/yyyy")

//----------------------------------------------------------------------------------
//	
//		Check to see if the user de-selected a Date with the Control or Shift key
//
//----------------------------------------------------------------------------------

IF KeyDown(KeyControl!) THEN
	SetNull(l_dNullDate)
	em_reminder_date.Text = " "
ELSEIF KeyDown(keyShift!) THEN
	SetNull(l_dNullDate)
	em_reminder_date.Text = " "
	
// Get the date using Calendar functions	
ELSE	
	l_nGetYear = fu_CalGetYear()
	l_nGetMonth = fu_CalGetMonth()
   l_cDate = (string(l_nGetMonth) + '/' + string(i_selectedday) + '/'+ string(l_nGetYear))
	
	em_reminder_date.text = l_cDate
END IF


end event

type mle_reminder_comments from multilineedit within w_set_reminder_date
integer x = 64
integer y = 288
integer width = 1504
integer height = 492
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean vscrollbar = true
integer limit = 255
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_set_reminder_date
integer x = 64
integer y = 208
integer width = 745
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Case Reminder Comments:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_set_reminder_date
integer x = 64
integer y = 68
integer width = 571
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
boolean enabled = false
string text = "Case Reminder Date:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_set_reminder_date
integer x = 1943
integer y = 816
integer width = 320
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;//****************************************************************************************
//
//		Event:	clicked
//		Purpose:	To check that the Reminder Date is a valid date.  If not inform the user
//					otherwise return the Reminder Date and comments.
//
// Date     Developer   Description
// -------- ----------- -----------------------------------------------------------------
// 03/21/00 C. Jackson  Add Past Date check		
//
//***************************************************************************************/

STRING l_cToday

	l_cToday = String (Today())
	IF DATE(em_reminder_date.Text) < DATE(l_cToday) THEN
		MessageBox(gs_AppName,'Past Dates are not allowed.  Please enter a valid date.')
 		Error.i_FWError = c_Fatal
		dw_calendar.SetFocus()
		RETURN
	END IF

IF NOT IsDate(em_reminder_date.Text) THEN
	MessageBox(gs_AppName, 'Please enter a valid date')
		//	Verify that the date selected on the calendar is not in the past
	dw_calendar.SetFocus()
	RETURN
ELSE
	PCCA.Parm[1]  = em_reminder_date.Text
	PCCA.Parm[2] = TRIM(mle_reminder_comments.Text)
	
	Close(Parent)
END IF

end event

type cb_cancel from commandbutton within w_set_reminder_date
integer x = 2304
integer y = 816
integer width = 320
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

on clicked;/****************************************************************************************

		Event:	clicked
		Purpose:	The user has selected the Cancel button.  Pass back an empty string and
					close the windiw.

***************************************************************************************/

PCCA.Parm[1] = ''
Close(parent)
end on

type em_reminder_date from editmask within w_set_reminder_date
integer x = 654
integer y = 64
integer width = 443
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yyyy"
end type

