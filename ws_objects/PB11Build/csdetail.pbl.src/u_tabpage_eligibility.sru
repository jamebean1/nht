$PBExportHeader$u_tabpage_eligibility.sru
$PBExportComments$Eligibility tab object.
forward
global type u_tabpage_eligibility from u_tabpg_std
end type
type st_current from statictext within u_tabpage_eligibility
end type
type cb_date_search from commandbutton within u_tabpage_eligibility
end type
type st_date from statictext within u_tabpage_eligibility
end type
type sle_search_date from singlelineedit within u_tabpage_eligibility
end type
type cb_update from commandbutton within u_tabpage_eligibility
end type
type cb_cancel from commandbutton within u_tabpage_eligibility
end type
type dw_eligibility_list from u_dw_std within u_tabpage_eligibility
end type
end forward

global type u_tabpage_eligibility from u_tabpg_std
integer width = 3534
integer height = 792
string text = "Eligibility History"
st_current st_current
cb_date_search cb_date_search
st_date st_date
sle_search_date sle_search_date
cb_update cb_update
cb_cancel cb_cancel
dw_eligibility_list dw_eligibility_list
end type
global u_tabpage_eligibility u_tabpage_eligibility

type variables
W_CREATE_MAINTAIN_CASE	i_wParentWindow
U_TAB_CASE_DETAILS		i_tabFolder
U_DW_STD						i_dwCaseDetails

Boolean						i_bModified
Boolean						i_bDisable
Transaction eTrans

long il_selected_row
end variables

forward prototypes
public subroutine fu_settabgui ()
public subroutine of_retrieve (string as_case)
public subroutine of_set_bold (long al_row, boolean ab_bold)
end prototypes

public subroutine fu_settabgui ();/*****************************************************************************************
   Function:   fu_SetTabGUI
   Purpose:    Set the status of the interface items
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/18/02 M. Caruso    Created.
	04/26/02 M. Caruso    Replaced call to fu_CheckLocked with reference to i_bCaseLocked.
	9/26/2002 K. Claver   Added boolean to enable/disable mtm exclude checkbox if case locked/unlocked.
*****************************************************************************************/

BOOLEAN	l_bCaseLocked, l_bAvailable, l_bAllowNew, l_bAllowModify, l_bRecordsExist
BOOLEAN	l_bAllowExclude
LONG		l_nCount
STRING	l_cCaseStatus, l_cOptionName, l_cSourceTypes


// set the button status
IF l_bCaseLocked OR l_cCaseStatus <> 'O' OR TRIM (i_wParentWindow.i_cCurrentCase) = "" THEN


ELSE
	
	
END IF


end subroutine

public subroutine of_retrieve (string as_case);string sMemberID, sProgramNumber, sCarrier, sDesc, ls_begin_date
long ll_row, ll_handle, ll_begin_date

ll_handle = eTrans.DBHandle()

IF ll_handle < 1 THEN
	CONNECT USING eTrans;
	
	IF eTrans.SQLCode <> 0 THEN
		MessageBox(gs_AppName, "Unable to connect to Eligibility Database -" + eTrans.sqlerrtext )
		RETURN
	END IF
	
	dw_eligibility_list.fu_SetOptions (eTrans, &
						dw_eligibility_list.c_NullDW, &
						dw_eligibility_list.c_MasterList+ &
						dw_eligibility_list.c_NoRetrieveOnOpen + &
						dw_eligibility_list.c_NoShowEmpty + &
						dw_eligibility_list.c_NoDelete + &
						dw_eligibility_list.c_NoEnablePopup + &
						dw_eligibility_list.c_NoMenuButtonActivation + &
						dw_eligibility_list.c_SortClickedOK )
END IF

sMemberID = i_wParentWindow.i_cCurrentCaseSubject
					
// retrieve eligibility data
IF dw_eligibility_list.retrieve (sMemberID) > 0 THEN

	// if a row has been selected before, scroll to it and select it
	SELECT case_log_generic_1, case_log_generic_2, IsNull(case_log_generic_3, '')
	INTO :sProgramNumber, :sCarrier, :ls_begin_date
	FROM cusfocus.case_log
	WHERE case_number = :as_case
	USING SQLCA;

	IF ls_begin_date = '' THEN
		ll_row = dw_eligibility_list.find("prog_nbr = '" + sProgramNumber + "' AND carrier = '" + sCarrier + "'", 1, dw_eligibility_list.RowCount())
	ELSE
		ll_row = dw_eligibility_list.find("prog_nbr = '" + sProgramNumber + "' AND carrier = '" + sCarrier + "' AND display_start = '" + ls_begin_date + "'", 1, dw_eligibility_list.RowCount())
	END IF
	IF ll_row > 0 THEN
		dw_eligibility_list.scrolltorow( ll_row )
		dw_eligibility_list.setrow( ll_row )
		sDesc = dw_eligibility_list.object.description[ll_row]
		st_current.text = "Current selection: " + sProgramNumber + " " + sCarrier + " " + ls_begin_date + " " + sDesc
		of_set_bold(ll_row, TRUE)
		il_selected_row = ll_row
	ELSE
		dw_eligibility_list.selectrow(0, false)
		st_current.text = "Current selection: none"
		il_selected_row = 0
	END IF

END IF


end subroutine

public subroutine of_set_bold (long al_row, boolean ab_bold);IF ab_bold THEN
	dw_eligibility_list.object.selected[al_row] = 'Y'
ELSE
	dw_eligibility_list.object.selected[al_row] = 'N'
END IF

end subroutine

on u_tabpage_eligibility.create
int iCurrent
call super::create
this.st_current=create st_current
this.cb_date_search=create cb_date_search
this.st_date=create st_date
this.sle_search_date=create sle_search_date
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.dw_eligibility_list=create dw_eligibility_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_current
this.Control[iCurrent+2]=this.cb_date_search
this.Control[iCurrent+3]=this.st_date
this.Control[iCurrent+4]=this.sle_search_date
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.dw_eligibility_list
end on

on u_tabpage_eligibility.destroy
call super::destroy
destroy(this.st_current)
destroy(this.cb_date_search)
destroy(this.st_date)
destroy(this.sle_search_date)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.dw_eligibility_list)
end on

event constructor;call super::constructor;/*****************************************************************************************
   Event:      constructor
   Purpose:    set values for instance variables

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/26/01 M. Caruso    Created.
	03/23/01 M. Caruso    Added new interface items for total days and carve out reason.
	3/27/2001 K. Claver   Added code to set the pointer variable for the case details datawindow
	4/13/2001 K. Claver   Changed to correctly use the new resize service.
*****************************************************************************************/
string sUID, sPWD, sServer, sDatabase

SELECT server_name, database_name, user_id, password
INTO :sServer, :sDatabase, :sUID, :sPWD
FROM cusfocus.eligibility_datasource
WHERE eligibility_datasource_name = 'ghpv_eligibility'
USING SQLCA;

//------------------------------------------------------------
//  Create a transaction object to obtain eligibility data
//------------------------------------------------------------
eTrans = CREATE Transaction
eTrans.DBMS = SECCA.MGR.i_SecTrans.DBMS
eTrans.Database   = SECCA.MGR.i_SecTrans.Database
eTrans.ServerName = sServer
eTrans.DBParm = " Database='" + sDatabase + "'"
eTrans.Logid = sUID
eTrans.logpass = sPWD


i_wParentWindow = w_create_maintain_case
i_tabFolder = i_wparentwindow.i_uoCaseDetails.tab_folder
i_dwCaseDetails = i_tabFolder.tabpage_case_details.dw_case_details

THIS.of_SetResize (TRUE)
IF IsValid (THIS.inv_resize) THEN
	// resize the carve out list view
	THIS.inv_resize.of_Register (dw_eligibility_list, "ScaleToRight&Bottom")
	THIS.inv_resize.of_Register (cb_update, "FixedToRight&Bottom")
	THIS.inv_resize.of_Register (cb_cancel, "FixedToRight&Bottom")
	THIS.inv_resize.of_Register (st_date, "FixedToRight&Bottom")
	THIS.inv_resize.of_Register (sle_search_date, "FixedToRight&Bottom")
	THIS.inv_resize.of_Register (cb_date_search, "FixedToRight&Bottom")
	THIS.inv_resize.of_Register (st_current, "FixedToRight&Bottom")
END IF

end event

event destructor;call super::destructor;IF IsValid(eTrans) THEN
	DISCONNECT USING eTrans;
	DESTROY eTrans
END IF
end event

type st_current from statictext within u_tabpage_eligibility
integer x = 1381
integer y = 652
integer width = 1161
integer height = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_date_search from commandbutton within u_tabpage_eligibility
integer x = 878
integer y = 672
integer width = 448
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Find Date"
end type

event clicked;string ls_date, ls_temp, ls_mm, ls_dd, ls_yyyy
long ll_row, ll_pos

ls_temp = sle_search_date.text
ll_pos = POS(ls_temp, '/')
IF ll_pos = 2 THEN
	ls_mm = '0' + MID(ls_temp,1,1)
ELSEIF ll_pos = 3 THEN
	ls_mm = MID(ls_temp,1,2)
ELSE
	MessageBox(gs_AppName, "Please enter a date in MM/DD/YYYY format")
	RETURN
END IF

ls_temp = MID(ls_temp, ll_pos + 1)
ll_pos = POS(ls_temp, '/')
IF ll_pos = 2 THEN
	ls_dd = '0' + MID(ls_temp,1,1)
ELSEIF ll_pos = 3 THEN
	ls_dd = MID(ls_temp,1,2)
ELSE
	MessageBox(gs_AppName, "Please enter a date in MM/DD/YYYY format")
	RETURN
END IF

ls_yyyy = MID(ls_temp, ll_pos + 1)

ls_date = ls_yyyy + ls_mm + ls_dd

IF IsNumber(ls_date) THEN

	ll_row = dw_eligibility_list.find("ymdeff_ms <= " + ls_date + " AND ymdend_ms >= " + ls_date , 1, dw_eligibility_list.RowCount())
	IF ll_row > 0 THEN
		dw_eligibility_list.scrolltorow( ll_row )
		dw_eligibility_list.setrow( ll_row )
	END IF

END IF

end event

type st_date from statictext within u_tabpage_eligibility
integer x = 23
integer y = 688
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date (MM/DD/YYYY):"
boolean focusrectangle = false
end type

type sle_search_date from singlelineedit within u_tabpage_eligibility
integer x = 517
integer y = 676
integer width = 352
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_update from commandbutton within u_tabpage_eligibility
integer x = 2578
integer y = 672
integer width = 448
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;U_DW_STD	l_dwCaseDetails
string sProgramNumber, sCarrier, sCase, sDesc, ls_begin_date
long ll_row, ll_begin_date

ll_row = dw_eligibility_list.getselectedrow( 0)

IF ll_row > 0 THEN

	sCase = i_wParentWindow.i_cCurrentCase
	sProgramNumber = dw_eligibility_list.object.prog_nbr[ll_row]
	sCarrier = dw_eligibility_list.object.carrier[ll_row]
	ls_begin_date = dw_eligibility_list.object.display_start[ll_row]
	sDesc = dw_eligibility_list.object.description[ll_row]

	UPDATE cusfocus.case_log
	SET case_log_generic_1 = :sProgramNumber,
	case_log_generic_2 = :sCarrier,
	case_log_generic_3 = :ls_begin_date
	WHERE case_number = :sCase
	USING SQLCA;

	IF SQLCA.SQLCode <> 0 THEN
		MessageBox(gs_AppName, "Unable to update Eligibility -" + SQLCA.sqlerrtext )
		RETURN
	END IF

	// update the case detail datawindow because the case has changed.
	l_dwCaseDetails = i_tabfolder.tabpage_case_details.dw_case_details
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'updated_by', OBJCA.WIN.fu_GetLogin (SQLCA))
	l_dwCaseDetails.SetItem (l_dwCaseDetails.i_CursorRow, 'case_log_updated_timestamp', i_wParentWindow.fw_GetTimestamp ())
	
	i_wParentWindow.i_uoCaseDetails.fu_savecase (l_dwCaseDetails.c_savechanges)

	st_current.text = "Current selection: " + sProgramNumber + " " + sCarrier + " " + ls_begin_date + " " + sDesc
	IF il_selected_row > 0 THEN
		of_set_bold(il_selected_row, FALSE)
	END IF
	il_selected_row = ll_row
	of_set_bold(ll_row, TRUE)

END IF

	

end event

type cb_cancel from commandbutton within u_tabpage_eligibility
integer x = 3058
integer y = 672
integer width = 448
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;string sProgramNumber, sCarrier, sCase, ls_begin_date
long ll_row

IF dw_eligibility_list.rowcount() > 0 THEN

	sCase = i_wParentWindow.i_cCurrentCase

	// if a row has been selected before, scroll to it and select it
	SELECT case_log_generic_1, case_log_generic_2, IsNull(case_log_generic_3, '')
	INTO :sProgramNumber, :sCarrier, :ls_begin_date
	FROM cusfocus.case_log
	WHERE case_number = :sCase
	USING SQLCA;

	IF ls_begin_date = '' THEN
		ll_row = dw_eligibility_list.find("prog_nbr = '" + sProgramNumber + "' AND carrier = '" + sCarrier + "'", 1, dw_eligibility_list.RowCount())
	ELSE
		ll_row = dw_eligibility_list.find("prog_nbr = '" + sProgramNumber + "' AND carrier = '" + sCarrier + "' AND display_start = '" + ls_begin_date + "'", 1, dw_eligibility_list.RowCount())
	END IF
	IF ll_row > 0 THEN
		dw_eligibility_list.scrolltorow( ll_row )
		dw_eligibility_list.setrow( ll_row )
	END IF

END IF

end event

type dw_eligibility_list from u_dw_std within u_tabpage_eligibility
event ue_selecttrigger pbm_dwnkey
integer x = 14
integer y = 12
integer width = 3497
integer height = 620
integer taborder = 10
string dataobject = "d_eligibility_history"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/*****************************************************************************************
   Event:      ue_selecttrigger
   Purpose:    Open the entry for editing by pressing the ENTER key

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/09/01 M. Caruso    Created.
	05/01/02 M. Caruso    Enable functionality only if the Modify button is Enabled.
*****************************************************************************************/

IF key = KeyEnter! AND THIS.RowCount( ) > 0 THEN
	
		cb_update.TriggerEvent ('clicked')
	
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;///*****************************************************************************************
//   Event:      pcd_setoptions
//   Purpose:    Initialize this datawindow.
//
//   Revisions:
//   Date     Developer    Description
//   ======== ============ =================================================================
//	02/27/01 M. Caruso    Created.
//*****************************************************************************************/
//
//fu_SetOptions (eTrans, &
//					c_NullDW, &
//					c_MasterList+ &
//					c_NoRetrieveOnOpen + &
//					c_NoShowEmpty + &
//					c_NoEnablePopup + &
//					c_DeleteOK + &
//					c_NoMenuButtonActivation + &
//					c_SortClickedOK )
end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
   Event:      doubleclicked
   Purpose:    Open the entry for editing

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/09/01 M. Caruso    Created.
	03/23/01 M. Caruso    Only process if the case is open.
	03/30/01 K. Claver    Added condition to allow the modify window to be opened if click
								 on a computed field.  Needed for double-click on computed created
								 by and closed by fields.
	05/01/02 M. Caruso    Enable functionality only if the Modify button is Enabled.
*****************************************************************************************/

IF ( dwo.Type = 'column' OR dwo.Type = 'compute' ) AND NOT i_bDisable THEN
	
		cb_update.TriggerEvent ('clicked')
	
END IF
end event

