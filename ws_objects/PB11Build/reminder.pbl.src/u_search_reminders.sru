$PBExportHeader$u_search_reminders.sru
forward
global type u_search_reminders from u_search
end type
type st_slider from u_slider_control_horizontal within u_search_reminders
end type
type dw_reminder_detail from u_dw_std within u_search_reminders
end type
type dw_calendar from u_calendar within u_search_reminders
end type
end forward

global type u_search_reminders from u_search
integer width = 3552
integer height = 1516
event ue_post_constructor ( )
event type string ue_template_restore ( )
event ue_template_save ( )
event ue_resize ( )
st_slider st_slider
dw_reminder_detail dw_reminder_detail
dw_calendar dw_calendar
end type
global u_search_reminders u_search_reminders

type variables
n_column_sizing_service in_columnsizingservice_detail

long il_conf_level
long	il_reportconfigid

datastore	ids_savedreport

blob	iblob_syntax
string	is_syntax, is_original_syntax
string is_user

uo_tabpg_reminders uo_parent_tabpg
String i_cLogin
end variables

forward prototypes
public subroutine of_set_conf_level (long al_conf_level)
public subroutine of_reset ()
public function string of_get_case_number ()
public function long of_retrieve (string as_arguments)
public subroutine of_set_parent (uo_tabpg_reminders auo_tabpg_reminders)
end prototypes

event ue_post_constructor();uo_titlebar.of_delete_button('Customize...')
uo_titlebar.of_add_button('Restore Original View', 'restore' )

long l_sliderpos
st_slider.of_add_upper_object(dw_report)
st_slider.of_add_lower_object(dw_reminder_detail)
st_slider.of_add_lower_object(dw_calendar)
st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()


n_registry ln_registry
l_sliderpos  			= 						long(	ln_registry.of_get_registry_key('users\' +  gn_globals.is_username + '\' + This.ClassName() + '\slidery'))

If l_sliderpos > 0 And Not IsNull(l_sliderpos) Then
	//st_slider.y = Min(Max(l_sliderpos, st_separator.Y + st_separator.Height + 100), Height - 100)
End If

// 11/27/06 RAP - With proper security, users can save report templates
IF gn_globals.il_view_confidentiality_level > 2 THEN
	uo_titlebar.of_add_button('Save View As Template', 'save template' )
	uo_titlebar.of_add_button('Restore Template View', 'restore template' )
END IF

i_cLogin = OBJCA.WIN.fu_GetLogin( SQLCA )
end event

event type string ue_template_restore();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null, ll_pos
string	ls_null, ls_syntax, ls_parm
blob		lb_syntax

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator


OpenWithParm(w_template_restore, il_reportconfigid)
ll_blobID = Message.DoubleParm

If Not IsNull(ll_blobid) and ll_blobid > 0 Then
	ln_blob_manipulator = Create n_blob_manipulator
	
	iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobid)
	
	ls_syntax = String(iblob_currentstate)
	
	// Make sure we converted it correctly - RAP 11/4/08
	ll_pos = Pos( ls_syntax, "release" )
	IF ll_pos = 0 THEN
		ls_syntax = string(iblob_currentstate, EncodingANSI!)
	END IF
	
	Destroy ln_blob_manipulator
End If

RETURN ls_syntax

end event

event ue_template_save();//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null
string	ls_null, ls_syntax
blob		lb_syntax

//----------------------------------------------------------------------------------------------------------------------------------
// 11/27/06 RAP - Do not save the filter with the datawindow syntax
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report.SetFilter("")
dw_report.Filter()
ls_syntax = dw_report.Describe("DataWindow.Syntax")

ls_syntax = String(il_reportconfigid) + "/" + ls_syntax
OpenWithParm(w_template_save, ls_syntax)


end event

public subroutine of_set_conf_level (long al_conf_level);il_conf_level = al_conf_level
end subroutine

public subroutine of_reset ();dw_report.Reset()
of_retrieve("")
dw_reminder_detail.Reset()

end subroutine

public function string of_get_case_number ();Long ll_row
String ls_case_number

ll_row = dw_report.GetRow()

If ll_row > 0 and ll_row <= dw_report.RowCount() Then 
	ls_case_number = dw_report.GetItemString(ll_row, 'case_number')
END IF

RETURN ls_case_number

end function

public function long of_retrieve (string as_arguments);long ll_rows, ll_row, ll_casenumber
string ls_case_number

// Set these in case of a restored view
is_user = as_arguments

ll_rows = dw_report.Retrieve(is_user)
ll_row = dw_report.GetRow()

If ll_row > 0 and ll_row <= dw_report.RowCount() Then 
	ls_case_number = dw_report.GetItemString(ll_row, 'case_number')
//	ll_row = tab_case_preview.tabpage_transfer_notes.dw_transfer_notes.Retrieve(dw_report.GetItemString(dw_report.GetRow(), 'case_transfer_id'))
End If

If Not isnull(il_conf_level) Then
//	ll_row = tab_case_preview.tabpage_case_preview.dw_case_preview.Retrieve(ls_case_number, il_conf_level)
End If

return ll_rows

end function

public subroutine of_set_parent (uo_tabpg_reminders auo_tabpg_reminders);uo_parent_tabpg = auo_tabpg_reminders
end subroutine

on u_search_reminders.create
int iCurrent
call super::create
this.st_slider=create st_slider
this.dw_reminder_detail=create dw_reminder_detail
this.dw_calendar=create dw_calendar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_slider
this.Control[iCurrent+2]=this.dw_reminder_detail
this.Control[iCurrent+3]=this.dw_calendar
end on

on u_search_reminders.destroy
call super::destroy
destroy(this.st_slider)
destroy(this.dw_reminder_detail)
destroy(this.dw_calendar)
end on

event ue_retrieve;call super::ue_retrieve;long ll_row, ll_casenumber
string ls_case_number

dw_report.Retrieve(gn_globals.is_login, gn_globals.in_date_manipulator.of_now(), il_conf_level)
ll_row = dw_report.GetRow()

If ll_row > 0 and ll_row <= dw_report.RowCount() Then 
	ls_case_number = dw_report.GetItemString(ll_row, 'case_number')
	ll_row = dw_reminder_detail.Retrieve(dw_report.GetItemString(dw_report.GetRow(), 'reminder_id'))
End If



end event

event resize;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Resize
// Overrides:  yes!!!!!!!!!!!!!!!!
// Overview:   Resize the controls that were added to u_search
// Created by: JWhite
// History:    7/27/06 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

This.of_setredraw(False)

Call Super::resize

st_slider.Visible 			= Not IsValid(iu_overlaying_report)
//dw_report_detail.Visible  	= Not IsValid(iu_overlaying_report)

If Not IsValid(iu_overlaying_report) Then
	st_slider.Y = Height - 768
	dw_reminder_detail.Y = Height - 744
	st_slider.Width = Width
	dw_report.Height = st_slider.Y - dw_report.Y
//	dw_reminder_detail.Width = dw_report.Width
	dw_reminder_detail.Height = Height - dw_reminder_detail.Y
	dw_calendar.Y = dw_reminder_detail.Y
	IF dw_reminder_detail.Height < 728 THEN
		dw_calendar.Height = dw_reminder_detail.Height
	ELSE
		dw_calendar.Height = 728
	END IF
End If	
This.of_setredraw(True)
end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//					aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by:
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_row
String ls_syntax
Datawindow ldw_data

Choose Case Lower(Trim(as_message))
	Case 'filter' //This is when the datawindow is filtered
		If dw_report.RowCount() = 0 Then
			dw_reminder_detail.Reset()
		Else
			ll_row = dw_report.GetRow()
			If ll_row > 0 And ll_row <= dw_report.RowCount() And Not IsNull(ll_row) Then
				dw_report.Event RowFocusChanged(ll_row)
			End If
		End If

	Case 'selectall'
		
	Case 'button clicked'
		Choose Case string(as_arg)
			Case 'restore'
					dw_report.Create(is_original_syntax)
					dw_report.EVENT TRIGGER ue_refresh_services()
					dw_report.TriggerEvent('ue_retrieve')
					THIS.TriggerEvent('resize')
			Case 'save template'
					THIS.EVENT ue_template_save()
			Case 'restore template'
					ls_syntax = THIS.EVENT ue_template_restore()
					dw_report.Create(ls_syntax)
					dw_report.TriggerEvent('ue_refresh_services')
					dw_report.TriggerEvent('ue_retrieve')
					THIS.TriggerEvent('resize')
			End Choose
	Case Else
		IF ClassName(as_arg) = "dw_report" THEN
			   ll_row = dw_report.GetRow()
	   		dw_report.Event RowFocusChanged(ll_row)
		END IF
End Choose


end event

event ue_refreshtheme;call super::ue_refreshtheme;st_slider.backcolor = gn_globals.in_theme.of_get_barcolor()

end event

event constructor;call super::constructor;This.Post Event ue_post_constructor()	


//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long	ll_rows, ll_pos
long	ll_blobobjectid
n_blob_manipulator ln_blob_manipulator
blob	lblob_datawindow_syntax
string	l_sMsg, ls_syntax

dw_reminder_detail.SetTransObject(SQLCA)
dw_report.SetTransObject(SQLCA)

ln_blob_manipulator = Create n_blob_manipulator
//----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore, set the dataobject and the transaction
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport = Create datastore
ids_savedreport.DataObject = 'd_data_savedreport_user_reportconfig'
ids_savedreport.SetTransObject(SQLCA)

//----------------------------------------------------------------------------------------------------------------------------------
// Store the original syntax in case we want to revert to it
//-----------------------------------------------------------------------------------------------------------------------------------
is_original_syntax = dw_report.Object.Datawindow.Syntax


//----------------------------------------------------------------------------------------------------------------------------------
// Get the rprtcnfgid so that we can look in SavedReport table to see if a previous saved syntax exists
//-----------------------------------------------------------------------------------------------------------------------------------
  SELECT cusfocus.reportconfig.rprtcnfgid  
    INTO :il_reportconfigid  
    FROM cusfocus.reportconfig  
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Reminders'   
           ;

ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_reportconfigid)

//----------------------------------------------------------------------------------------------------------------------------------
// Check to see if a row exists for 'D'efault syntax. If it does exist, get the blob ID and set the original syntax
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.SetFilter("svdrprttpe = 'D'")
ll_rows = ids_savedreport.Filter()
ll_rows = ids_savedreport.RowCount()
IF ll_rows > 0 THEN
	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
	
	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
		is_original_syntax = String(iblob_currentstate)

		// Make sure we converted it correctly - RAP 11/4/08
		ll_pos = Pos( is_original_syntax, "release" )
		IF ll_pos = 0 THEN
			is_original_syntax = string(iblob_currentstate, EncodingANSI!)
		END IF
		
		dw_report.Create(is_original_syntax)
		dw_report.SetTransObject(SQLCA)
	END IF
END IF

//----------------------------------------------------------------------------------------------------------------------------------
// Filter for last 'S'aved syntax.
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.SetFilter("svdrprttpe = 'S'")
ll_rows = ids_savedreport.Filter()
ll_rows = ids_savedreport.RowCount()

//----------------------------------------------------------------------------------------------------------------------------------
// Check to see if a row exists. If it does exist, get the blob ID and recreate the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rows > 0 Then
	ll_blobobjectid = ids_savedreport.GetItemNumber(1, 'svdrprtblbobjctid')
	
	If Not IsNull(ll_blobobjectid) and ll_blobobjectid > 0 Then
		
		iblob_currentstate = ln_blob_manipulator.of_retrieve_blob(ll_blobobjectid)
		
		ls_syntax = String(iblob_currentstate)
		
		// Make sure we converted it correctly - RAP 11/4/08
		ll_pos = Pos( ls_syntax, "release" )
		IF ll_pos = 0 THEN
			ls_syntax = string(iblob_currentstate, EncodingANSI!)
		END IF
		
		If dw_report.Create(ls_syntax, l_sMsg) <> 1 THEN
			dw_report.Create(is_original_syntax)
		Else
			dw_report.SetTransObject(SQLCA)
		End If
		
	End If
End If

Destroy ln_blob_manipulator

end event

type dw_report from u_search`dw_report within u_search_reminders
event ue_retrieve ( )
event ue_checktrans ( string a_ccasenumber )
event ue_selecttrigger pbm_dwnkey
event ue_refresh_services ( )
integer width = 2190
integer height = 640
string dataobject = "d_search_reminders"
end type

event dw_report::ue_retrieve();LONG l_nRtn

SetPointer( Hourglass! )

//l_nRtn = THIS.Retrieve( gn_globals.is_login, DateTime(gn_globals.in_date_manipulator.of_now()), il_conf_level )
l_nRtn = this.Retrieve(i_cLogin, uo_parent_tabpg.i_cCaseReminder )

//IF l_nRtn < 0 THEN
//   Error.i_FWError = SQLCA.SQLErrText
//END IF

SetPointer( Arrow! )

end event

event dw_report::ue_checktrans(string a_ccasenumber);///****************************************************************************************
//
//	Event:	ue_checktrans
//	Purpose:	Check the transfer status of the case
//	
//	Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	9/25/2001 K. Claver    Created
//****************************************************************************************/
//Integer l_nTransCount, li_row
//String l_cCaseStatus, l_cCurrentCSR, l_cUpdatedBy, l_cTransferFrom
//String l_cTransType, l_cCaseViewed
//
//li_row = THIS.GetRow()
//l_cTransType = THIS.Object.case_transfer_type[ li_row ]
//					
////Only do the ownership check if not a copy
//IF l_cTransType <> 'C' THEN
//	//Check if there is a transfer.  Case could have been closed
//	//  by someone else.
//	SELECT Count( * )
//	INTO :l_nTransCount
//	FROM cusfocus.case_transfer
//	WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
//			cusfocus.case_transfer.case_transfer_type = 'O'
//	USING SQLCA;
//	
//	IF l_nTransCount = 0 THEN
//		//Check if has been re-opened or is still open and the current user 
//		//  is the rep(owner).
//		SELECT cusfocus.case_log.case_status_id, 
//				 cusfocus.case_log.case_log_case_rep, 
//				 cusfocus.case_log.updated_by
//		INTO :l_cCaseStatus,
//			  :l_cCurrentCSR,
//			  :l_cUpdatedBy
//		FROM cusfocus.case_log
//		WHERE cusfocus.case_log.case_number = :a_cCaseNumber
//		USING SQLCA;
//	ELSE	
//		//Check to see if the case has already been viewed or is still owned by
//		//  the current user.			
//		SELECT cusfocus.case_transfer.case_transfer_to,
//				 cusfocus.case_transfer.case_transfer_from,
//				 cusfocus.case_transfer.case_viewed
//		INTO :l_cCurrentCSR,
//			  :l_cTransferFrom,
//			  :l_cCaseViewed
//		FROM cusfocus.case_transfer
//		WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
//				cusfocus.case_transfer.case_transfer_type = 'O'
//		USING SQLCA;
//	END IF
////	
////	//Display the appropriate message if the current user 
////	//  is no longer the owner of the case
////	IF l_cCaseStatus = "C" THEN
////		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been closed by "+l_cUpdatedBy+".", &
////						StopSign!, Ok! )
////	ELSEIF l_cCaseStatus = "V" THEN
////		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been voided by "+l_cUpdatedBy+".", &
////						StopSign!, Ok! )
////	ELSEIF ( l_nTransCount = 0 ) AND ( NOT IsNull( l_cCurrentCSR ) ) AND &
////			 ( Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
////		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been reopened by "+l_cCurrentCSR+".", &
////						StopSign!, Ok! )	 
////	ELSEIF Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN			
////		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been transferred to "+l_cCurrentCSR+" by "+l_cTransferFrom+".", &
////						StopSign!, Ok! )
////	END IF			
//	
//	//Update the case_viewed flag if the current user is the
//	//  same as the transfer to and the case is open.
//	IF l_nTransCount > 0 AND Upper( l_cCurrentCSR ) = Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN
//		IF IsNull( l_cCaseViewed ) THEN
//			THIS.Object.case_viewed[ li_Row ] = "Y"
//			UPDATE cusfocus.case_transfer
//			SET cusfocus.case_transfer.case_viewed = 'Y'
//			WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
//					cusfocus.case_transfer.case_transfer_type = 'O'
//			USING SQLCA;
//		ELSE
//			THIS.Object.case_viewed[ li_Row ] = "Y"
//		END IF
//		m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
//	END IF		
//END IF
end event

event dw_report::ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	9/25/2001 K. Claver    Created
	3/4/2002  K. Claver    Modified to use the new version of the case search event
****************************************************************************************/

W_CREATE_MAINTAIN_CASE	l_wCaseWindow
Long			l_nRow
Integer		li_return
LONG			l_nCaseNumber
INTEGER     l_nRV
STRING      l_cViewed, l_cReminderID, l_cCaseNumber, l_cExistReminder, l_cCaseReminder

// if the user double-clicked on a row, process it.
IF ( key = KeyEnter! ) AND ( THIS.GetRow() > 0 ) THEN
	
	// Get the selected case number
	l_nRow = GetRow( )
	l_cCaseNumber = THIS.Object.case_number[ l_nRow ]
	
	SELECT reminder_id, case_reminder INTO :l_cExistReminder, :l_cCaseReminder
	  FROM cusfocus.reminders
	 WHERE case_number = :l_cCaseNumber
	 USING SQLCA;
	 
	IF ISNULL(l_cExistReminder) THEN
		l_cExistReminder = ''
	END IF
	
	IF l_cExistReminder = '' then
		IF l_cCaseReminder = 'Y' THEN
			messagebox(gs_AppName,'This reminder has been deleted and the case has been closed.  ' + &
						  'The window will be refreshed')
			THIS.Retrieve(i_cLogin, uo_parent_tabpg.i_cCaseReminder )			  
			RETURN
		END IF
	ELSE
		
		// Determine if there is a related Case and set the Viewed flag to Y
		
		l_cViewed = THIS.GetItemString(l_nRow,"reminders_reminder_viewed")
		
		IF l_cViewed = 'N' THEN				
			UPDATE cusfocus.reminders
				SET reminder_viewed = 'Y'
			 WHERE case_number = :l_cCaseNumber
			 USING SQLCA;
			 
			m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
			 
			 
			l_nRV = THIS.Retrieve( i_cLogin, uo_parent_tabpg.i_cCaseReminder )
				
			IF l_nRV < 0 THEN
				MessageBox(gs_AppName, "The Work Desk was unable to refresh your reminders.")
			END IF							  
		END IF
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			
			// Open w_create_maintain_case
			FWCA.MGR.fu_OpenWindow( w_create_maintain_case, -1 )
			l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet( )
			
			IF IsValid( l_wCaseWindow ) THEN
				 
				// Make sure the window is on the Search tab
				IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
					li_return = l_wCaseWindow.dw_folder.fu_SelectTab( 1 )
				END IF
				
				IF li_return = -1 THEN
					RETURN -1
				ELSE
					// call ue_casesearch to process the query after the window is fully initialized.
					l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber )
				END IF
				
			END IF
			uo_parent_tabpg.i_cViewed = THIS.GetItemString(l_nRow,'reminders_reminder_viewed')
		
			uo_parent_tabpg.i_cAuthor = THIS.GetItemString(l_nRow,'reminder_author')	 
			
			IF uo_parent_tabpg.i_cViewed = 'Y' AND UPPER(uo_parent_tabpg.i_cAuthor)  = UPPER( OBJCA.WIN.fu_GetLogin( SQLCA ) )  THEN
				m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
			ELSE
				m_cusfocus_reminders.m_edit.m_markunread.Enabled = FALSE
				
			END IF	
		END IF
		RETURN -1
	END IF
END IF

end event

event dw_report::ue_refresh_services();in_datawindow_graphic_service_manager.of_init(dw_report)

in_datawindow_graphic_service_manager.of_destroy_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_show_fields')
in_datawindow_graphic_service_manager.of_destroy_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_destroy_service('n_sort_service')

in_datawindow_graphic_service_manager.of_add_service('n_rowfocus_service')
in_datawindow_graphic_service_manager.of_add_service('n_column_sizing_service')
in_datawindow_graphic_service_manager.of_add_service('n_show_fields')
in_datawindow_graphic_service_manager.of_add_service('n_group_by_service')
in_datawindow_graphic_service_manager.of_add_service('n_datawindow_formatting_service')
in_datawindow_graphic_service_manager.of_add_service('n_aggregation_service')
in_datawindow_graphic_service_manager.of_add_service('n_sort_service')

in_datawindow_graphic_service_manager.of_Create_services()

end event

event dw_report::constructor;call super::constructor;long	ll_reportconfigid
string ls_user_id

in_datawindow_graphic_service_manager = Create n_datawindow_graphic_service_manager

THIS.EVENT TRIGGER ue_refresh_services()


//this.TriggerEvent('ue_retrieve')

  SELECT cusfocus.reportconfig.rprtcnfgid  
    INTO :il_reportconfigid  
    FROM cusfocus.reportconfig  
   WHERE cusfocus.reportconfig.rprtcnfgnme = 'Search Reminders'   
           ;

// Get confidentiality level
ls_User_ID = OBJCA.WIN.fu_GetLogin( SQLCA )
SELECT confidentiality_level 
INTO :il_conf_level
FROM cusfocus.cusfocus_user 
WHERE user_id = :ls_User_ID USING SQLCA;


Properties.of_init(il_reportconfigid)
end event

event dw_report::destructor;call super::destructor;//----------------------------------------------------------------------------------------------------------------------------------
// variable Declaration
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rows, ll_new_row, ll_blobID, ll_null
string	ls_null, ls_syntax
blob		lb_syntax

n_blob_manipulator ln_blob_manipulator
ln_blob_manipulator = Create n_blob_manipulator

//----------------------------------------------------------------------------------------------------------------------------------
// Ensure these variables are null
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(ll_null)
SetNull(ls_null)

//----------------------------------------------------------------------------------------------------------------------------------
// 11/27/06 RAP - Do not save the filter with the datawindow syntax
//-----------------------------------------------------------------------------------------------------------------------------------
dw_report.SetFilter("")
dw_report.Filter()

//----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the datastore then get the syntax for the datawindow & convert it into a blob object
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rows = ids_savedreport.Retrieve(gn_globals.il_userid, il_reportconfigid)
lb_syntax = blob(dw_report.Describe("DataWindow.Syntax"))
 
//----------------------------------------------------------------------------------------------------------------------------------
// If we dont' have a row, then insert a new row and set the values. Otherwise update the existing row and blob.
//-----------------------------------------------------------------------------------------------------------------------------------
If ids_savedreport.RowCount() = 0 Then
	ll_new_row = ids_savedreport.InsertRow(0)
	
	ll_blobID = ln_blob_manipulator.of_insert_blob(lb_syntax, dw_report.dataobject)
	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtfldrid', ls_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrprtcnfgid', il_reportconfigid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprttpe', 'S')
	ids_savedreport.SetItem(ll_new_row, 'svdrprtdstrbtnmthd', ls_null)	
	ids_savedreport.SetItem(ll_new_row, 'svdrprtuserid', gn_globals.il_userid)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnusrID', ll_null)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsnlvl', 1)
	ids_savedreport.SetItem(ll_new_row, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
Else
	ll_blobID = ids_savedreport.getitemnumber(1, 'svdrprtblbobjctid')
	ln_blob_manipulator.of_update_blob(lb_syntax, ll_blobID, FALSE)
	
	ids_savedreport.SetItem(1, 'svdrprtblbobjctid', ll_blobID)
	ids_savedreport.SetItem(1, 'svdrprtdscrptn', 'Saved datawindow for user:' + gn_globals.is_login + ' and datawindow:' + dw_report.dataobject)
	ids_savedreport.SetItem(1, 'svdrprtrvsndte', gn_globals.in_date_manipulator.of_now())
End If


//----------------------------------------------------------------------------------------------------------------------------------
// Save the changes to the database
//-----------------------------------------------------------------------------------------------------------------------------------
ids_savedreport.Update()


//----------------------------------------------------------------------------------------------------------------------------------
// Destroy the objects
//-----------------------------------------------------------------------------------------------------------------------------------
Destroy	ln_blob_manipulator
Destroy 	in_datawindow_graphic_service_manager
Destroy 	ids_savedreport
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;long ll_row, ll_case_conf_level
String ls_transfer_id, ls_viewed_case, ls_owner

uo_parent_tabpg.i_bEnableCalendar = FALSE

uo_parent_tabpg.fu_CalendarDisplay( currentrow )

If Not IsNull(il_conf_level) and currentrow > 0 Then
	ll_row = dw_reminder_detail.Retrieve(this.object.reminder_id[currentrow])
	//??? trying this because modify reminder does not enable this DW
	IF ll_row > 0 THEN
		dw_reminder_detail.i_isempty = FALSE
	END IF
End If


end event

event dw_report::doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/23/2000 K. Claver   Added code to retrieve the case when double click on a row
//  3/4/2002   K. Claver   Modified to use the new version of the case search event
//***********************************************************************************************  
w_create_maintain_case l_wCaseWindow
String l_cCaseNumber
INTEGER li_return

IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN
		l_cCaseNumber = THIS.GetItemString( row, "case_number" )
		
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			//Check the transfer status
//			THIS.Event Trigger ue_CheckTrans( l_cCaseNumber )

			// Open w_create_maintain_case
			FWCA.MGR.fu_OpenWindow(w_create_maintain_case, -1)
			l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet()
			
			IF IsValid (l_wCaseWindow) THEN
				
				// Make sure the window is on the Search tab
				IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
					li_return = l_wCaseWindow.dw_folder.fu_SelectTab(1)
				END IF
				
				IF li_return = -1 THEN
					RETURN -1
				ELSE
					// call ue_casesearch to process the query after the window is fully initialized.
					l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber)
				END IF
				
			END IF						
		END IF
	END IF
END IF
end event

event dw_report::ue_dwnkey;//this.triggerevent('ue_selecttrigger')

THIS.Event Trigger ue_selecttrigger( key, keyflags )
end event

event dw_report::rbuttondown;////----------------------------------------------------------------------------------------------------------------------------------
////	Event:      rbuttondown
////	Overrides:  No
////	Arguments:	
////	Overview:   This will redirect the event just in case some service want to respond
////	Created by: Blake Doerr
////	History:    2/23/00 - First Created 
////-----------------------------------------------------------------------------------------------------------------------------------
//
//n_menu_dynamic ln_menu_dynamic
//
//If AutomaticallyPresentRightClickMenu Then
//	ln_menu_dynamic = Create n_menu_dynamic
//	ln_menu_dynamic.of_set_text('Report Options')
//End If
//
//If IsValid(in_datawindow_graphic_service_manager) Then
//	in_datawindow_graphic_service_manager.of_redirect_event('rbuttondown', xpos, ypos, row, dwo, ln_menu_dynamic)
//End If
//
//IF m_cusfocus_reminders.m_edit.m_markunread.Enabled THEN
//	ln_menu_dynamic.of_add_item('-','','')
//	ln_menu_dynamic.of_add_item('Mark Unread','mark unread','', THIS)
//END IF
//
//If AutomaticallyPresentRightClickMenu Then
//	This.Event ue_rbuttondown(xpos, ypos, row, dwo, ln_menu_dynamic)
//	This.of_showmenu(ln_menu_dynamic)
//End If
//
//
end event

event dw_report::ue_notify;call super::ue_notify;Choose Case Lower(Trim(as_message))
	Case 'mark unread'
		m_cusfocus_reminders.m_edit.m_markunread.Event Clicked()
END CHOOSE
end event

event dw_report::clicked;call super::clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Manage the calendar object based on the current row
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/17/01 C. Jackson  Call the update calendar function (SCR 1595)
//  02/28/02 C. Jackson  Added code to set m_markunread status.
//  03/03/03 M. Caruso   Added row > 0 check before changing m_markunread status.
//**********************************************************************************************

STRING l_cCaseNumber

uo_parent_tabpg.fu_CalendarDisplay( row )

IF row > 0 THEN
	
	l_cCaseNumber = THIS.GetItemString(row,'case_number')
	
	IF NOT IsNull(l_cCaseNumber) and l_cCaseNumber <> '' THEN
	
		uo_parent_tabpg.i_cViewed = THIS.GetItemString(row,'reminders_reminder_viewed')
		
		uo_parent_tabpg.i_cAuthor = THIS.GetItemString(row,'reminder_author')	 
		
		IF uo_parent_tabpg.i_cViewed = 'Y' AND UPPER(uo_parent_tabpg.i_cAuthor)  = UPPER( OBJCA.WIN.fu_GetLogin( SQLCA ) )  THEN
			m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
		ELSE
			m_cusfocus_reminders.m_edit.m_markunread.Enabled = FALSE
			
		END IF	
		
	ELSE
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = FALSE
	END IF
	
END IF


end event

type uo_titlebar from u_search`uo_titlebar within u_search_reminders
string tag = "Appeal Tracker"
end type

event uo_titlebar::constructor;call super::constructor;This.of_delete_button('criteria')
This.of_delete_button('customize')
This.of_delete_button('retrieve')

end event

type st_separator from u_search`st_separator within u_search_reminders
end type

type st_slider from u_slider_control_horizontal within u_search_reminders
integer y = 748
integer height = 24
boolean bringtotop = true
long backcolor = 15780518
boolean enabled = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      Clicked
// Overrides:  No
// Overview:   Moves the position of the pane control to the coordinated specified in 
//					in the instance variable ib_automove_up, and then repositions/resizes
//					all objects being controlled by the pane control.
//
// Created by: 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------
// Turn the redraw off for reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(False)

//-----------------------------------------------------
// If the pane controlled has been previously doubleclicked,
// then reset the pane control to its previous position, else
// set the pane control to the position specified by
// ib_doubleclick_up.
// ib_doubleclick_up = True - Expand Up
// ib_doubleclick_up = False - Expand Down
//-----------------------------------------------------
If ib_click Then

	//-----------------------------------------------------
	// Set the Y coordinate for the pane control to the
	// previous position
	//-----------------------------------------------------
	This.Y = of_get_prev_ypos()
	ib_click = False
	
Else

	//-----------------------------------------------------
	// Store the current Y coordinate, and move the pane
	// control up or down based on the variable ib_doubleclick_up.
	// ib_doubleclick_up = True - Expand Up
	// ib_doubleclick_up = False - Expand Down
	//-----------------------------------------------------
	of_set_prev_ypos(This.Y)
	if ib_automove_up then
		This.Y = of_min_Y()
	Else
		This.Y = of_max_Y()
	End IF
	ib_click = True

End If

//-----------------------------------------------------
// Turn redraw back on for the reference window
//-----------------------------------------------------
if ib_redraw_off then iw_reference.SetRedraw(True)
 
end event

type dw_reminder_detail from u_dw_std within u_search_reminders
integer x = 5
integer y = 784
integer width = 2487
integer height = 716
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_reminder_detail"
boolean border = false
end type

event editchanged;//******************************************************************
//  PC Module     : u_DW_Stds
//  Event         : EditChanged
//  Description   : This event is used to indicate that the input
//                  needs to be validated.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//  12/3/99  M. Caruso  Created, based on ancestor function
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF NOT uo_parent_tabpg.i_bViewMode THEN
	IF IsValid(i_DWSRV_EDIT) THEN
		IF NOT i_IsQuery THEN
			i_DWSRV_EDIT.i_ItemValidated = FALSE
			i_DWSRV_EDIT.i_HaveModify    = TRUE
		END IF
		
		IF i_DDDWFind THEN
			IF data <> "" THEN
				IF Upper(dwo.dddw.allowedit) = 'YES' THEN
					i_DWSRV_EDIT.fu_DDDWFind(row, dwo, data)
				END IF
			END IF
		ELSE
			IF i_DDDWSearch AND data <> "" THEN
				IF Upper(dwo.dddw.allowedit) = 'YES' THEN
					i_DWSRV_EDIT.fu_DDDWSearch(row, dwo, data)
				END IF
			END IF
		END IF
	END IF
END IF
end event

event itemchanged;call super::itemchanged;//**********************************************************************************************
//
//  Event:   itemchanged
//  Purpose: Get casetype 
//  
//  Date     Developer     Description
//  -------- ------------- ---------------------------------------------------------------------
//  04/26/00 C. Jackson    Original Version
//  07/14/00 C. Jackson    Add logic to validate the Case Number against the case table (716)
//	 12/10/2001 K. Claver   Changed to use the parameters passed to the event(data, dwo and row).
//									Also changed to ensure that a blanked case number field = null.
//  
//**********************************************************************************************  
STRING l_cCaseType, l_cNull
LONG l_nCaseCount
BOOLEAN l_bContinue

SetNull( l_cNull )

CHOOSE CASE Upper( dwo.Name )
	CASE "CASE_NUMBER"
		IF NOT ( IsNull( data ) ) AND Trim( data ) <> "" THEN // Case Reminder		 
			// Check to see if this is a valid case and get the case type
			SELECT Count( * ) INTO :l_nCaseCount
			FROM cusfocus.case_log
			WHERE case_number = :data
			USING SQLCA;
			 
			IF l_nCaseCount > 0 THEN
				// we have a match, continue
				SELECT cusfocus.case_log.case_type
				INTO :l_cCaseType
				FROM cusfocus.case_log
				WHERE cusfocus.case_log.case_number = :data
				USING SQLCA;				

				dw_reminder_detail.Object.case_type[ row ] = l_cCaseType
				dw_reminder_detail.Object.case_reminder[ row ] = "Y"
				
				l_bContinue = TRUE				
			ELSE // Not a valid Case Number
				messagebox( gs_AppName, "Case Number does not exist. Please enter a valid Case Number", StopSign!, OK! )
				l_bContinue = FALSE				
			END IF			
		ELSE // Non Case Reminder
			dw_reminder_detail.Object.case_reminder[ row ] = "N"
			dw_reminder_detail.Object.case_type[ row ] = l_cNull
			dw_reminder_detail.Object.reminder_dlt_case_clsd[ row ] = "N"
			dw_reminder_detail.Object.case_number[ row ] = l_cNull
			l_bContinue = TRUE
		END IF
		
		IF l_bContinue THEN
			RETURN 0
		ELSE 
			RETURN 1
		END IF
END CHOOSE

end event

event pcd_modify;call super::pcd_modify;//************************************************************************************
//
//		   	Event:		pcd_modify
//      	 Purpose:		To Enable the Calendar Object for user Reminder Selection and
//								to clear the Calendar of all selected dates except for the 
//								record that is being modified.
//
//**********************************************************************************/
INT      l_nMonth, l_nYear
DATE     l_dReminderDate[]

uo_parent_tabpg.i_bChangeMode = TRUE
uo_parent_tabpg.i_bEnableCalendar = TRUE

PARENT.SetRedraw(FALSE)

l_dReminderDate[1] = Date(GetItemDateTime(i_CursorRow, 'reminder_set_date'))


IF IsNULL(l_dReminderDate[1]) THEN
	RETURN
END IF

l_nYear = YEAR(l_dReminderDate[1])
l_nMonth = MONTH(l_dReminderDate[1])

dw_calendar.fu_CalSetMonth(l_nMonth, l_nYear)

dw_calendar.fu_CalClearDates()
dw_calendar.fu_CalSetDates(l_dReminderDate[])

PARENT.SetRedraw(TRUE)

uo_parent_tabpg.i_bViewMode = FALSE

end event

event pcd_new;call super::pcd_new;//****************************************************************************************
//
//  Event:	  pcd_new
//  Purpose:  To clear and enable the Calendar object for Reminder selection and 
//				  to initialize the new row.
//
//  Date     Developer    Description
//  -------- ------------ ---------------------------------------------------------------
//  04/12/00 C. Jackson   Add reminder_viewed 'N' to insert (SCR 513)
//
//****************************************************************************************
DATE     l_dReminderDate[]
INTEGER li_month, li_year

uo_parent_tabpg.i_bEnableCalendar = TRUE

SELECT getdate( ) INTO :l_dReminderDate[1] FROM cusfocus.one_row;

//l_dReminderDate[1] = Date(Parent.fu_gettimestamp())
SetItem(i_CursorRow, 'reminder_crtd_date', l_dReminderDate[1])
SetItem(i_CursorRow, 'reminder_set_date', l_dReminderDate[1])
SetItem(i_CursorRow, 'reminder_author', OBJCA.WIN.fu_GetLogin(SQLCA))
SetItem(i_CursorRow, 'reminder_recipient', OBJCA.WIN.fu_GetLogin(SQLCA))
SetItem(i_CursorRow, 'reminder_viewed','N')

//-------------------------------------------------------------------------
//
//		Change the New Row status back to New so that the user will not be
//		prompted for changes if they do not make any modifications after this
//		point.
//
//--------------------------------------------------------------------------

SetItemStatus(i_CursorRow, 0, PRIMARY!, NOTMODIFIED!) 

li_Year = YEAR(l_dReminderDate[1])
li_Month = MONTH(l_dReminderDate[1])

dw_calendar.fu_CalSetMonth(li_Month, li_Year)
dw_calendar.fu_CalClearDates()
dw_calendar.fu_CalSetDates(l_dReminderDate[])

uo_parent_tabpg.i_bViewMode = FALSE


end event

event pcd_retrieve;call super::pcd_retrieve;///************************************************************************************
//
//			Event:		pcd_retrieve
//		 Purpose:		To get the retrieval argument value from the parent dw and 
//							retrieve the child dw.
//
//***********************************************************************************/

LONG l_nReturn
STRING ls_reminder_id

SetPointer( Hourglass! )

ls_Reminder_ID  = dw_report.GetItemSTring(dw_report.GetRow(), 'reminder_id')

l_nReturn = Retrieve(ls_Reminder_ID)

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF
 
SetPointer( Arrow! )

uo_parent_tabpg.i_bViewMode = TRUE
end event

event pcd_setkey;call super::pcd_setkey;///****************************************************************************************
//
//			Event:	pcd_setKey
//		 Purpose:	To call the standards layer key generation function and place into the
//						dw buffer.
//
//****************************************************************************************/

SetItem(i_CursorRow, 'reminder_id', uo_parent_tabpg.fu_GetKeyValue('reminders'))
end event

event pcd_setoptions;call super::pcd_setoptions;///****************************************************************************************
//
//		Event:	pcd_setoptions
//		Purpose:	To set the datawindow characteristics
//
//****************************************************************************************/
u_dw_std dw_null

SetNull(dw_null)
THIS.fu_SetOptions( SQLCA, & 
						  dw_null, & 
						  c_ModifyOK + &
						  c_NewOK + &
						  c_NewModeOnEmpty + &
						  c_DeleteOK + &
						  c_ViewAfterSave + &
						  c_NoMenuButtonActivation + &
						  c_NoRetrieveOnOpen ) 
//THIS.fu_SetOptions( SQLCA, & 
//						  dw_null, & 
//						  c_ModifyOK + &
//						  c_NewOK + &
//						  c_NewModeOnEmpty + &
//						  c_DeleteOK + &
//						  c_ViewAfterSave + &
//						  c_RefreshParent + &
//						  c_NoMenuButtonActivation + &
//						  c_NoRetrieveOnOpen ) 
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "reminder_comments", THIS.inv_resize.SCALERIGHT )
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;i_CursorRow = currentrow
end event

type dw_calendar from u_calendar within u_search_reminders
event ue_setdates ( integer a_nmonth,  integer a_nyear )
integer x = 2537
integer y = 772
integer width = 1006
integer height = 728
integer taborder = 20
boolean bringtotop = true
end type

event ue_setdates(integer a_nmonth, integer a_nyear);//*********************************************************************************************
//
//  Event:   ue_SetDates
//  Purpose: To set the dates in the calendar if change month and year rather than loading them
//				 all when the list datawindow is retrieved.
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/13/2001 K. Claver Created
//							  
//*********************************************************************************************
DataStore l_dsDates
Integer l_nRows, l_nIndex
String l_cLogin
Date l_dReminderDates[ ]

l_dsDates = CREATE DataStore
l_dsDates.DataObject = "d_reminder_dates"
l_dsDates.SetTransObject( SQLCA )

l_nRows = l_dsDates.Retrieve( i_cLogin, a_nMonth, a_nYear, uo_parent_tabpg.i_cCaseReminder )
										
IF l_nRows > 0 THEN
	//Get the calendar dates
	FOR l_nIndex = 1 TO l_nRows
		l_dReminderDates[ l_nIndex ] = Date( l_dsDates.GetItemDateTime( l_nIndex, "reminder_set_date" ) )
	NEXT
	
	THIS.fu_CalSetDates( l_dReminderDates )
END IF

DESTROY l_dsDates

dw_report.SetFocus( )
end event

event constructor;call super::constructor;/*************************************************************************************

			Event:	Constructor
		 Purpose:	Please see PB documentation for this event
		 
---------- --------- -----------------------------------------------------------------
10/20/2000 K. Claver Initialize the calendar
*************************************************************************************/
THIS.fu_CalCreate()
end event

event po_daychanged;call super::po_daychanged;/*************************************************************************************

			Event:	po_daychanged
		 Purpose:	To determine what day the user has selected for the Case Reminder.

*************************************************************************************/

DATE l_dNullDate

//----------------------------------------------------------------------------------
//	
//		Check to see if the user de-selected a Date with the Control key
//
//----------------------------------------------------------------------------------

IF KeyDown(KeyControl!) THEN
	SetNull(l_dNullDate)
	dw_reminder_detail.SetItem(dw_reminder_detail.i_CursorRow, 'reminder_set_date', &
										l_dNullDate)
ELSE	
	dw_reminder_detail.SetItem(dw_reminder_detail.i_CursorRow, 'reminder_set_date', &
										Date(fu_CalGetYear(), fu_CalGetMonth(), i_SelectedDay))
END IF
end event

event po_dayvalidate;call super::po_dayvalidate;/*************************************************************************************

		  Event:		po_dayvalidate
		Purpose: 	To enable the user from selecting a day while the Case Reminder
						Datawindow is in View mode.


**************************************************************************************/

IF NOT uo_parent_tabpg.i_bEnableCalendar THEN 
	i_CalendarError = c_ValFailed
END IF
end event

event po_monthchanged;call super::po_monthchanged;//*********************************************************************************************
//
//  Event:   po_monthchanged
//  Purpose: Please see PowerClass documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/13/2001 K. Claver Added call to the event to set the dates for the month changed to.
//							  
//*********************************************************************************************
THIS.Event Trigger ue_SetDates( selectedmonth, Integer( THIS.fu_CalGetYear( ) ) )
end event

event po_yearchanged;call super::po_yearchanged;//*********************************************************************************************
//
//  Event:   po_yearchanged
//  Purpose: Please see PowerClass documentation for this event
//  
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  12/13/2001 K. Claver Added call to the event to set the dates for the month of the year 
//								 changed to.							  
//*********************************************************************************************
THIS.Event Trigger ue_SetDates( Integer( THIS.fu_CalGetMonth( ) ), selectedyear )
end event

