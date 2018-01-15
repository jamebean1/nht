$PBExportHeader$w_financial_compensation.srw
$PBExportComments$Financial Compensation Response window
forward
global type w_financial_compensation from w_response_std
end type
type dw_financial_compensation from u_dw_std within w_financial_compensation
end type
type cb_ok from commandbutton within w_financial_compensation
end type
type cb_cancel from commandbutton within w_financial_compensation
end type
end forward

global type w_financial_compensation from w_response_std
integer x = 549
integer y = 420
integer width = 2907
integer height = 1420
string title = "Financial Compensation:"
dw_financial_compensation dw_financial_compensation
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_financial_compensation w_financial_compensation

type variables
STRING i_cCaseNumber
STRING i_cPreviousMessageText
end variables

event pc_setoptions;call super::pc_setoptions;/***************************************************************************************

		Event:	pc_setoptions
		Purpose:	To get the case number from PCCA, set the Title of the window, set the
					options for uo_dw_main and to save the current PC Message object text
					into an instance variable to be stored when we close.

****************************************************************************************/

i_cCaseNumber = PCCA.Parm[1]

THIS.Title = This.Title + ' Case Number - ' + i_cCaseNumber

dw_financial_compensation.fu_SetOptions( SQLCA, & 
 		dw_financial_compensation.c_NullDW, & 
 		dw_financial_compensation.c_NewOK + &
 		dw_financial_compensation.c_ModifyOK + &
 		dw_financial_compensation.c_ModifyOnOpen + &
 		dw_financial_compensation.c_NewModeOnEmpty + &
 		dw_financial_compensation.c_FreeFormStyle  ) 

i_cPreviousMessageText = FWCA.MSG.fu_GetMessage("ChangesOne", FWCA.MSG.c_MSG_Text)
FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, &
	"Do you want to save the changes to the Financial Compensation Window?")


end event

on w_financial_compensation.create
int iCurrent
call super::create
this.dw_financial_compensation=create dw_financial_compensation
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_financial_compensation
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
end on

on w_financial_compensation.destroy
call super::destroy
destroy(this.dw_financial_compensation)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event close;call super::close;FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, i_cPreviousMessageText)
end event

type dw_financial_compensation from u_dw_std within w_financial_compensation
integer x = 14
integer y = 4
integer width = 2834
integer height = 1100
integer taborder = 10
string dataobject = "d_financial_compensation"
boolean border = false
end type

event pcd_savebefore;/**************************************************************************************

		Event:	pcd_savebefore
		Purpose:	To check record values prior to updating.

*************************************************************************************/
DATETIME l_dtTimeStamp

//-----------------------------------------------------------------------------------
//
//		If the approved columns have data in them make sure the approved by column
//		is populated.  If not prompt the user.
//
//-----------------------------------------------------------------------------------

IF NOT IsNull(GetItemNumber(i_CursorRow, 'fin_comp_amt_aprvd')) OR &
	NOT IsNull(GetItemDecimal(i_CursorRow, 'fin_comp_days_aprvd')) OR &
	 NOT IsNull(GetItemNumber(i_CursorRow, 'fin_comp_visits_aprvd')) THEN

		IF IsNull(GetItemString(i_CursorRow, 'fin_comp_approved_by')) THEN
		Messagebox(gs_AppName,"You must enter a value in the Approved By" + &
			" field in order to udpate the Financial Compensation.")
 		Error.i_FWError = c_Fatal
		SetFocus()
		SetColumn('fin_comp_approved_by')
		RETURN
	END IF
END IF

//----------------------------------------------------------------------------------
//
//		Make sure the user has selected a Compenstation Type.  If not, inform them
//
//-----------------------------------------------------------------------------------

IF IsNull(GetItemSTring(i_CursorRow, 'compensation_type')) THEN
	MessageBox(gs_AppName, "You must enter a Compensation Type.")
 	Error.i_FWError = c_Fatal
	SetFocus()
	SetColumn('compensation_type')
	RETURN
END IF

//---------------------------------------------------------------------------------
//
//		Set who updated and when.
//
//---------------------------------------------------------------------------------

THIS.SetItem(i_CursorRow, 'updated_by', OBJCA.WIN.fu_GetLogin(SQLCA)) 
THIS.SetItem(i_CursorRow, 'updated_timestamp', Parent.fw_GetTimeStamp())


end event

event pcd_validatecol;call super::pcd_validatecol;/****************************************************************************************

			Event:	pcd_validatecol
			Purpose:	To wipe out the approved_by column every time the user enters
						a value into the various aprvd fields.

***************************************************************************************/
STRING l_cApprovedNull

CHOOSE CASE col_name
	CASE "fin_comp_days_aprvd","fin_comp_visits_aprvd"
 		IF Integer(GetText()) <> GetItemNumber(i_CursorRow, col_name) THEN
				SetNull(l_cApprovedNull)
				SetItem(i_CursorRow,"fin_comp_approved_by", l_cApprovedNull)
		END IF
	CASE "fin_comp_amt_aprvd"
 		IF Dec(GetText()) <> GetItemDecimal(i_CursorRow, col_name) THEN
				SetNull(l_cApprovedNull)
				SetItem(i_CursorRow,"fin_comp_approved_by", l_cApprovedNull)
		END IF
	CASE "fin_comp_visits_aprvd"
 		IF INTEGER(GetText()) <> GetItemNumber(i_CursorRow, col_name) THEN
			SETNULL(l_cApprovedNull)
			SetItem(i_CursorRow, 'fin_comp_approved_by', l_cApprovedNull)
		END IF
END CHOOSE

end event

event pcd_retrieve;call super::pcd_retrieve;/*************************************************************************************

		Event:	pcd_retrieve
		Purpose:	To retrieve the record.

*************************************************************************************/
LONG  l_nReturn

l_nReturn = Retrieve(i_cCaseNumber)

IF l_nReturn < 0 THEN
    Error.i_FWError = c_Fatal
END IF
end event

event pcd_new;call super::pcd_new;/**************************************************************************************

		Event:	pcd_new
		Purpose:	To initalize a new record.

*************************************************************************************/

SetItem(i_CursorRow, "case_number", i_cCaseNumber)
SetItemStatus(i_CursorRow, 0, PRIMARY!, NOTMODIFIED!)

end event

type cb_ok from commandbutton within w_financial_compensation
integer x = 2144
integer y = 1160
integer width = 320
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

on clicked;/*************************************************************************************

		Event:	clicked
		Purpose:	To save the changes and close the window.

************************************************************************************/
LONG l_nReturn

dw_financial_compensation.AcceptText()

l_nReturn = dw_financial_compensation.fu_Save(dw_financial_compensation.c_SaveChanges)

IF l_nReturn = dw_financial_compensation.c_Success THEN														
	close(parent)
END IF

end on

type cb_cancel from commandbutton within w_financial_compensation
integer x = 2505
integer y = 1160
integer width = 320
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

on clicked;/*************************************************************************************

		Event:	clicked
		Purpose:	To cancel and close.

************************************************************************************/
Close(parent)
end on

