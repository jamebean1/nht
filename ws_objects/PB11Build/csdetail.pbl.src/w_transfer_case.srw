$PBExportHeader$w_transfer_case.srw
$PBExportComments$Transfer Case Response window
forward
global type w_transfer_case from w_response_std
end type
type p_1 from picture within w_transfer_case
end type
type st_5 from statictext within w_transfer_case
end type
type st_3 from statictext within w_transfer_case
end type
type cb_transferhistory from commandbutton within w_transfer_case
end type
type st_2 from statictext within w_transfer_case
end type
type tv_tfer_to from treeview within w_transfer_case
end type
type st_1 from statictext within w_transfer_case
end type
type dw_transfer_case from u_dw_std within w_transfer_case
end type
type dw_transfer_history from u_dw_std within w_transfer_case
end type
type cb_ok from commandbutton within w_transfer_case
end type
type cb_cancel from commandbutton within w_transfer_case
end type
type dw_trash from u_dw_std within w_transfer_case
end type
type ln_1 from line within w_transfer_case
end type
type ln_2 from line within w_transfer_case
end type
type ln_3 from line within w_transfer_case
end type
type ln_4 from line within w_transfer_case
end type
type st_4 from statictext within w_transfer_case
end type
end forward

global type w_transfer_case from w_response_std
integer x = 366
integer y = 312
integer width = 2747
integer height = 2148
string title = "Tfer/Copy Case:"
long backcolor = 79748288
event ue_disable ( boolean a_btransfer )
event ue_enable ( )
p_1 p_1
st_5 st_5
st_3 st_3
cb_transferhistory cb_transferhistory
st_2 st_2
tv_tfer_to tv_tfer_to
st_1 st_1
dw_transfer_case dw_transfer_case
dw_transfer_history dw_transfer_history
cb_ok cb_ok
cb_cancel cb_cancel
dw_trash dw_trash
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
st_4 st_4
end type
global w_transfer_case w_transfer_case

type variables
DataStore	i_dsCusFocusUsers

INT			i_nCaseConfidLevel
INT			i_nRepConfidLevel
INT			i_nRecordConfidLevel

STRING		i_cCaseNumber
STRING		i_cCaseType
STRING		i_cPreviousMessageText
STRING		i_cTransferTo
STRING		i_cUserLastName
STRING		i_cTakenBy

STRING		i_cCaseReminderType = '1'

BOOLEAN		i_bNewTransfer = FALSE
BOOLEAN		i_bOriginator = FALSE
BOOLEAN		i_bControlsEnabled = TRUE
BOOLEAN		ib_xfer_from_queue = FALSE

STRING						i_cSourceConsumer  = 'C'
STRING						i_cSourceEmployer  = 'E'
STRING						i_cSourceProvider  = 'P'
STRING						i_cSourceOther     = 'O'
//For use when determining if the current user can close the case rather than have
//  CustomerFocus route it back to the person who originally took the case.
STRING						i_cCloseBy

end variables

forward prototypes
public subroutine fw_createcasereminder ()
public subroutine fw_checkstatus (u_dw_std a_dwcheck, integer a_nrow)
public function integer fw_getrecconfidlevel (string a_ccurrentcasesubject, string a_csourcetype)
public function string fw_checkroute (string a_ctfertoid)
public subroutine fw_closeby ()
public function string of_check_work_queue (string as_id, string as_type)
public subroutine of_email ()
end prototypes

event ue_disable;/****************************************************************************************

			Event:	ue_Disable
		 Purpose:	Disable the controls on the window if the current user isn't the owner
		 				of the case
						 
		 Parameters:  Boolean - a_bTransfer - True = Disable for transfer purposes
		 												  False = Disable for copy purposes
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	11/3/2000 K. Claver    Original Version
	2/11/2002 K. Claver    Added boolean parameter to accomodate for new copy only
								  functionality.
	06/13/03 M. Caruso     Set i_bControlsEnabled to FALSE.
***************************************************************************************/
u_dw_std l_dwControl
TreeView l_tvControl
CommandButton l_cbControl
Integer l_nIndex, l_nDWIndex

SetPointer( HourGlass! )

FOR l_nIndex = 1 TO UpperBound( THIS.Control )
	CHOOSE CASE THIS.Control[ l_nIndex ].TypeOf( )
		CASE DataWindow!
			l_dwControl = THIS.Control[ l_nIndex ]
			
			IF NOT a_bTransfer AND ( ClassName( l_dwControl ) = "dw_transfer_history" OR &
				ClassName( l_dwControl ) = "dw_trash" ) THEN
				CONTINUE
			ELSE
				IF ClassName( l_dwControl ) = "dw_transfer_case" THEN
					//Disable event processing for the button
					l_dwControl.Object.b_calendar.SuppressEventProcessing='Yes'
				END IF
				
				FOR l_nDWIndex = 1 TO Integer( l_dwControl.Object.Datawindow.Column.Count )
					IF NOT a_bTransfer AND l_nDWIndex = 6 THEN
						//Skip the notes field if disabling for copy
						CONTINUE
					ELSE
						l_dwControl.Modify( "#"+String( l_nDWIndex )+".Background.Color = '"+ &
												  String( RGB( 214, 211, 206 ) )+"'" )
						l_dwControl.Modify( "#"+String( l_nDWIndex )+".Protect='1'" )
					END IF
				NEXT
			END IF
		CASE TreeView!
			IF a_bTransfer THEN
				l_tvControl = THIS.Control[ l_nIndex ]
				l_tvControl.Enabled = FALSE
			END IF
		CASE CommandButton!
			IF a_bTransfer THEN
				l_cbControl = THIS.Control[ l_nIndex ]
				IF ClassName( l_cbControl ) <> "cb_cancel" THEN
					l_cbControl.Enabled = FALSE
				END IF
			END IF
	END CHOOSE
NEXT

i_bControlsEnabled = FALSE

SetPointer( Arrow! )
end event

event ue_enable;/****************************************************************************************

			Event:	ue_Enable
		 Purpose:	Enable the controls if the user selects an owner.
						 
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	2/11/2002 K. Claver    Original Version
	06/13/03 M. Caruso     Set i_bControlsEnabled to TRUE.
***************************************************************************************/
u_dw_std l_dwControl
TreeView l_tvControl
CommandButton l_cbControl
Integer l_nIndex, l_nDWIndex

SetPointer( HourGlass! )

FOR l_nIndex = 1 TO UpperBound( THIS.Control )
	CHOOSE CASE THIS.Control[ l_nIndex ].TypeOf( )
		CASE DataWindow!
			l_dwControl = THIS.Control[ l_nIndex ]
			
			IF ClassName( l_dwControl ) = "dw_transfer_case" THEN
				//Enable event processing for the button
				l_dwControl.Object.b_calendar.SuppressEventProcessing='No'
			END IF
			
			FOR l_nDWIndex = 1 TO Integer( l_dwControl.Object.Datawindow.Column.Count )
				l_dwControl.Modify( "#"+String( l_nDWIndex )+".Background.Color = '"+ &
										  String( RGB( 255, 255, 255 ) )+"'" )
										  
				IF NOT THIS.i_bOriginator AND l_nDWIndex = 9 THEN
					CONTINUE
				ELSE
					l_dwControl.Modify( "#"+String( l_nDWIndex )+".Protect='0'" )
				END IF
			NEXT
		CASE TreeView!
			l_tvControl = THIS.Control[ l_nIndex ]
			l_tvControl.Enabled = TRUE
		CASE CommandButton!
			l_cbControl = THIS.Control[ l_nIndex ]
			IF ClassName( l_cbControl ) <> "cb_cancel" THEN
				l_cbControl.Enabled = TRUE
			END IF
	END CHOOSE
NEXT

i_bControlsEnabled = TRUE

SetPointer( Arrow! )
end event

public subroutine fw_createcasereminder ();//**************************************************************************************
//
//  Function:  fw_createcasereminder
//  Purpose:   To create a Case Reminder for the user the case is being 
//             transfered to.
//				 
//  Date
//  -------- ------------ -------------------------------------------------------------
//  04/12/00 C. Jackson   Add add reminder_viewed 'N' to SetItem (SCR 513)
//	 10/9/2000 K. Claver   Commented out because no longer want to insert a case
//								  reminder for a case transfer.
//
//*************************************************************************************

//STRING l_cReminderID, l_cTransferComments, l_cUserID
//DATETIME   l_dtCurrentDate
//
////----------------------------------------------------------------------------------
////
////		Get the transfer comments out of the datawindow and we will use them in the
////		reminder comments for the new case rep.
////
////----------------------------------------------------------------------------------
//
//l_cTransferComments = dw_transfer_case.GetItemString(dw_transfer_case.i_CursorRow, &
//		'case_transfer_notes')
//
//l_dtCurrentDate = fw_gettimestamp()
//l_cReminderID = fw_getkeyvalue()
//l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)
//
////------------------------------------------------------------------------------------
////
////		Insert a record into the Reminders table.
////
////------------------------------------------------------------------------------------
//
//INSERT INTO cusfocus.reminders (reminder_id, reminder_type_id, reminder_viewed, case_number, case_type,
//		case_reminder, reminder_crtd_date, reminder_set_date, reminder_subject, 
//		reminder_comments, reminder_dlt_case_clsd, reminder_author, reminder_recipient)
//		 VALUES (:l_cReminderID, :i_cCaseReminderType, 'N', :i_cCaseNumber, :i_cCaseType, 'Y',
//		 :l_dtCurrentDate, :l_dtCurrentDate, 'Case Transfer', :l_cTransferComments, 'Y', 
// 		 :l_cUserID, : i_cTransferTo);
//
//IF SQLCA.SQLCode = -1 THEN
//	MessageBox(STRING(SQLCA.SQLDBCode), SQLCA.SQLErrText)
//	ROLLBACK;
//ELSE
//	COMMIT;
//END IF

end subroutine

public subroutine fw_checkstatus (u_dw_std a_dwcheck, integer a_nrow);/****************************************************************************************
		Function:	fw_CheckStatus
		 Purpose:	Check status of a datawindow row and column and display a message
		 Returns:   None
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	10/27/2000 K. Claver   Original Version
****************************************************************************************/
DWItemStatus l_dwisStatus

l_dwisStatus = a_dwCheck.GetItemStatus( a_nRow, 0, Primary! )

CHOOSE CASE l_dwisStatus
	CASE New!
		Messagebox( a_dwCheck.DataObject, "New" )
	CASE NewModified!
		Messagebox( a_dwCheck.DataObject, "NewModified" )
	CASE DataModified!
		Messagebox( a_dwCheck.DataObject, "DataModified" )
	CASE NotModified!
		Messagebox( a_dwCheck.DataObject, "NotModified" )
END CHOOSE
end subroutine

public function integer fw_getrecconfidlevel (string a_ccurrentcasesubject, string a_csourcetype);//****************************************************************************************
//
//	  Function:	fw_GetRecConfidLevel
//		Purpose:	To Retrieve the source record confidentiality level
//    
// Parameters: a_cCurrentCaseSubject - The id of the record
//					a_cSourceType - The record type(member, provider, etc)
//    Returns: The confidentiality of the record
//						
//	 Date     Developer    Description
//	 -------- ------------ ----------------------------------------------------------------
//	 3/1/2001 K. Claver    Original version.
//**************************************************************************************/
Integer l_nConfidLevel

SetNull( l_nConfidLevel )

CHOOSE CASE a_cSourceType
	CASE i_cSourceProvider
		SELECT cusfocus.provider_of_service.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.provider_of_service
		WHERE cusfocus.provider_of_service.provider_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE i_cSourceEmployer
		SELECT cusfocus.employer_group.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.employer_group
		WHERE cusfocus.employer_group.group_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE i_cSourceConsumer
		SELECT cusfocus.consumer.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.consumer
		WHERE cusfocus.consumer.consumer_id = :a_cCurrentCaseSubject
		USING SQLCA;
	CASE i_cSourceOther
		SELECT cusfocus.other_source.confidentiality_level
		INTO :l_nConfidLevel
		FROM cusfocus.other_source
		WHERE cusfocus.other_source.customer_id = :a_cCurrentCaseSubject
		USING SQLCA;
END CHOOSE	
		
RETURN l_nConfidLevel
end function

public function string fw_checkroute (string a_ctfertoid);/****************************************************************************************
		Function:	fw_CheckRoute
		 Purpose:	Check for routing
		 Returns:   The route to ID plus the notify flag enclosed in parens.
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	10/24/2000 K. Claver   Original Version
****************************************************************************************/
String l_cRouteTo, l_cNotify
Integer l_nCount, l_nConfLevel

//Check if there is routing in the first place
SELECT Count( * )
INTO :l_nCount
FROM cusfocus.out_of_office
WHERE cusfocus.out_of_office.out_user_id = :a_cTferToID
USING SQLCA;

IF l_nCount > 0 THEN
	//Check who is routing to and if to notify the user about the routing
	SELECT cusfocus.out_of_office.assigned_to_user_id,
			 cusfocus.out_of_office.notify
	INTO :l_cRouteTo,
		  :l_cNotify
	FROM cusfocus.out_of_office
	WHERE cusfocus.out_of_office.out_user_id = :a_cTferToID
	USING SQLCA;
	
	//Set the transfer to variable to the route to and add on the notify
	//  flag if set to notify
	IF NOT IsNull( l_cRouteTo ) AND Trim( l_cRouteTo ) <> "" THEN
		//Check the confidentiality level of the person to route to.  Need to
		//  know this so can determine if should route to the person.
		SELECT cusfocus.cusfocus_user.confidentiality_level
		INTO :l_nConfLevel
		FROM cusfocus.cusfocus_user
		WHERE cusfocus.cusfocus_user.user_id = :l_cRouteTo
		USING SQLCA;
		
		IF l_nConfLevel >= i_nCaseConfidLevel THEN
			a_cTferToID = l_cRouteTo
		
			IF Upper( l_cNotify ) = "Y" THEN
				a_cTferToID += "(Y)"
			ELSE
				a_cTferToID += "(N)"
			END IF
		ELSE
			a_cTferToID = "Security Error: " + l_cRouteTo
		END IF
	END IF
END IF

RETURN a_cTferToID
end function

public subroutine fw_closeby ();//*********************************************************************************************
//
//  Function: fw_CloseBy
//  Purpose:  To determine who is allowed to close a transferred case
//
//  Parameters: None
//  Returns: None
//							
//  Date     Developer   Description
//  -------- ----------- ----------------------------------------------------------------------
//  2/21/2002 K. Claver  Created
//*********************************************************************************************
SELECT option_value
INTO :THIS.i_cCloseBy
FROM cusfocus.system_options
WHERE Upper( option_name ) = 'RETURN FOR CLOSE'
USING SQLCA;

IF SQLCA.SQLCode <> 0 THEN
	MessageBox( gs_AppName, "Error determining return for closure settings" )
	SetNull( THIS.i_cCloseBy )
ELSE
	THIS.i_cCloseBy = Trim( Upper( THIS.i_cCloseBy ) )
	
	IF THIS.i_cCloseBy = "" THEN
		SetNull( THIS.i_cCloseBy )
	END IF
END IF
end subroutine

public function string of_check_work_queue (string as_id, string as_type);// This function will check the work_queue flag on the cusfocus_user_dept table.
// It can check for a specific user by passing in 'user as the second parameter,
// or for a department by passing in 'dept'
//
// 01/04/2007 RAP

String ls_work_queue

IF as_type = 'user' THEN
	SELECT cusfocus.cusfocus_user_dept.work_queue
	INTO :ls_work_queue
	FROM cusfocus.cusfocus_user, cusfocus.cusfocus_user_dept
	WHERE cusfocus.cusfocus_user.user_id = :as_id
	  AND cusfocus.cusfocus_user.user_dept_id = cusfocus.cusfocus_user_dept.user_dept_id
	USING SQLCA;
ELSE // 'dept'
	SELECT cusfocus.cusfocus_user_dept.work_queue
	INTO :ls_work_queue
	FROM cusfocus.cusfocus_user_dept
	WHERE cusfocus.cusfocus_user_dept.user_dept_id = :as_id
	USING SQLCA;
END IF
RETURN ls_work_queue 
end function

public subroutine of_email ();//////////////////////////////////////////////////////////////
// This function will send the email confirmation(s)
//
// 01/23/2008 RAP
/////////////////////////////////////////////////////////////
string ls_runstring, ls_mailto, ls_cc, ls_subject, ls_body, ls_email, ls_rep, ls_xfer_type, ls_owner
long ll_row, ll_rowcount, ll_recipient_count, ll_sent_count
string ls_source_type, ls_source_name, ls_lob, ls_category
datetime ldt_duedate
string ls_recipients

mailsession lms_MAPISession
mailmessage lmm_Message

lms_MAPISession = CREATE mailsession
IF lms_MAPISession.MailLogon() = MailReturnSuccess! THEN

	dw_transfer_case.AcceptText()
	ls_owner = ""
	ls_mailto = ""
	ls_cc = ""
	ls_subject = dw_transfer_case.object.case_transfer_subject[ 1 ]
	ls_body = dw_transfer_case.object.case_transfer_notes[ 1 ]
	IF IsNull(ls_body) THEN
		ls_body = ""
	END IF
	IF IsNull(ls_subject) THEN
		ls_subject = ""
	END IF
	ll_rowcount = dw_transfer_history.RowCount( )
	
	FOR ll_row = 1 to ll_rowcount
		ls_rep = dw_transfer_history.Object.case_transfer_to[ ll_row ]
		ls_xfer_type = dw_transfer_history.Object.case_transfer_type[ ll_row ]
	
		SELECT ISNULL(EMAIL, 'XXX')
		INTO :ls_email
		FROM CUSFOCUS.CUSFOCUS_USER
		WHERE ACTIVE = 'Y'
		AND USER_ID = :ls_rep
		USING SQLCA;
		
		IF ls_email <> "XXX" THEN
//			IF lms_MAPISession.MailResolveRecipient(ls_email) = MailReturnSuccess! THEN
				ll_recipient_count++
			    lmm_Message.Recipient[ ll_recipient_count ].Name = ls_email
//			 ls_recipients[ ll_recipient_count ] = ls_email
				IF ls_xfer_type = "O" THEN
//				ls_mailto = ls_email
					ls_owner = ls_rep
//			ELSE
//				IF LEN(ls_cc) > 0 THEN
//					ls_cc += "; " + ls_email
//				ELSE
//					ls_cc = ls_email
//				END IF
				END IF
			END IF

//		ELSE
//			MessageBox(gs_appname, "Unable to resolve email address (" + ls_email + ") for (" + ls_rep + ")" )
//		END IF
	
	NEXT
	
	// Send a copy to the person doing the xfer
	ls_rep = OBJCA.WIN.fu_GetLogin( SQLCA )
	SELECT ISNULL(EMAIL, 'XXX')
	INTO :ls_email
	FROM CUSFOCUS.CUSFOCUS_USER
	WHERE ACTIVE = 'Y'
	AND USER_ID = :ls_rep
	USING SQLCA;
	
	IF ls_email <> "XXX" THEN
//		IF lms_MAPISession.MailResolveRecipient(ls_email) = MailReturnSuccess! THEN
			ll_recipient_count++
		    lmm_Message.Recipient[ ll_recipient_count ].Name = ls_email
//		 ls_recipients[ ll_recipient_count ] = ls_email
//		IF LEN(ls_mailto) > 0 THEN
//			ls_mailto += "; " + ls_email
//		ELSE
//			ls_mailto = ls_email
//		END IF

//		ELSE
//			MessageBox(gs_appname, "Unable to resolve email address (" + ls_email + ") for (" + ls_rep + ")" )
//		END IF
	END IF
	
	// Additional message body
	SELECT 
				case cl.source_type
				when 'C' then 'Member'
				when 'E' then 'Employer Group'
				when 'P' then 'Provider'
				else 'Other'
				end as source_type,   
				cl.source_name,   
				cat.category_name
	INTO
			:ls_source_type,
			:ls_source_name,
			:ls_category
	FROM cusfocus.case_log cl   
				inner join cusfocus.categories cat on cl.category_id = cat.category_id  
	WHERE
			cl.case_number = :i_cCaseNumber
	USING SQLCA;
	
	SELECT
		a.duedate,
		lob.line_of_business_name
	INTO
		:ldt_duedate,
		:ls_lob
	FROM 
		cusfocus.appealheader a
		inner join cusfocus.line_of_business lob on a.line_of_business_id = lob.line_of_business_id
	WHERE
		a.case_number = :i_cCaseNumber
	USING SQLCA;
	
	IF IsNull(ls_lob) OR ls_lob = "" THEN // No appeal
		ls_body += " ~r~n~r~nYou are receiving a CustomerFocus Case" +&
		"~r~n~r~nSource Type: " + ls_source_type +&
		"~r~nSource Name: " + ls_source_name +&
		"~r~nCategory: " + ls_category
		
		IF ls_owner = "" THEN
			ls_body += "~r~n~r~nPlease login to complete work on this case."
		ELSE
			ls_body += "~r~n~r~nOwnership has been transferred to " + ls_owner + ". Please login to complete work on this case."
		END IF
	ELSE
		ls_body += "~r~n~r~nYou are receiving a CustomerFocus Appeals and Grievance Case" +&
		"~r~n~r~nLine of Business: " + ls_lob +&
		"~r~nSource Type: " + ls_source_type +&
		"~r~nSource Name: " + ls_source_name +&
		"~r~nCategory: " + ls_category 
		
		IF ls_owner = "" THEN
			ls_body += "~r~n~r~nPlease login to complete work on this case."
		ELSE
			ls_body += "~r~n~r~nOwnership has been transferred to " + ls_owner + ". Please login to complete work on this case."
		END IF
	END IF

    lmm_Message.Subject = ls_subject
    lmm_Message.NoteText = ls_body

	// RAP 1/2/2009 - Separate emails are sent out because Novell Groupwise (Geisinger) doesn't work
	//		correctly with multiple recipients on one message.
//	FOR ll_row = 1 to ll_recipient_count
//	    lmm_Message.Recipient[ 1 ].Name = ls_recipients[ll_row]
//	    IF lms_MAPISession.MailSend( lmm_Message ) = MailReturnSuccess! THEN
//			ll_sent_count++
//		END IF
//	NEXT
	IF lms_MAPISession.MailAddress(lmm_Message) = MailReturnSuccess! THEN
	    IF lms_MAPISession.MailSend( lmm_Message ) = MailReturnSuccess! THEN
			ll_recipient_count = Upperbound(lmm_Message.recipient)
			FOR ll_row = 1 to ll_recipient_count
				 IF ll_row = 1 THEN
					ls_recipients = lmm_Message.recipient[ll_row].name
				ELSE
					ls_recipients += "; " + lmm_Message.recipient[ll_row].name
				END IF
			NEXT
			MessageBox( gs_AppName, "Email was sent to " + ls_recipients )
		ELSE
			MessageBox( gs_AppName, "Email was NOT sent (Send Error).",  Exclamation!)
		END IF
	ELSE
		MessageBox( gs_AppName, "Email was NOT sent (Address Error).",  Exclamation!)
	END IF
END IF

//ls_runstring = "rundll32 url.dll,FileProtocolHandler mailto:" + ls_mailto + "&subject=" + ls_subject + "&body=" + ls_body
//IF LEN(ls_cc) > 0 THEN
//	ls_runstring += "&cc=" + ls_cc
//END IF
//run(ls_runstring) 
//
//

DESTROY lms_MAPISession

end subroutine

event pc_setoptions;call super::pc_setoptions;/****************************************************************************************

			Event:	pc_setoptions
		 Purpose:	Get the parms passed in PCCA, populate the child dddw of application
						users, set the options for PC dws, place the Case Number in the title
						of the window and change PC Message object text.
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/9/99   M. Caruso     Check if the DDDW used for case_transfer_to has any rows in it.
	                       If so, continue normally.  If not, notify the user of the
								  problem and close the window automatically.
	10/15/2000 K. Claver   Changed to use the treeview for the transfer to person rather than
								  a drop down.
   06/13/03 M. Caruso     Added condition to disable the controls based on i_bControlsEnabled.
***************************************************************************************/

String l_cCasePriority, l_cOwner, l_cCurrentUser, l_cSubjectID, l_cSourceType, ls_work_queue
DateTime l_dtOpenedDate
Long l_nDaysOpen, ll_return

i_cCaseNumber = PCCA.Parm[1]
i_cCaseType = PCCA.Parm[2]
//i_nCaseConfidLevel = INTEGER(PCCA.Parm[3])
i_cUserLastName = PCCA.Parm[4]
i_nRepConfidLevel = INTEGER(PCCA.Parm[5])

////Begin embedded sql to find the case priority, confidentiality level and originator
SELECT cusfocus.case_log.case_priority, cusfocus.case_log.confidentiality_level,
		 cusfocus.case_log.case_log_taken_by, cusfocus.case_log.case_log_opnd_date,
		 cusfocus.case_log.case_log_case_rep, cusfocus.case_log.case_subject_id, 
		 cusfocus.case_log.source_type
INTO :l_cCasePriority, :i_nCaseConfidLevel, :i_cTakenBy, :l_dtOpenedDate, :l_cOwner,
	  :l_cSubjectID, :l_cSourceType
FROM cusfocus.case_log
WHERE cusfocus.case_log.case_number = :i_cCaseNumber
USING SQLCA;
////End embedded sql

// Find out if this is currently owned by a work queue
ls_work_queue = of_check_work_queue(l_cOwner, 'user')
IF ls_work_queue = 'Y' THEN 
	ib_xfer_from_queue = TRUE
ELSE
	ib_xfer_from_queue = FALSE
END IF

i_dsCusFocusUsers = CREATE DataStore
i_dsCusFocusUsers.DataObject = "dddw_transfer_cusfocus_users"
i_dsCusFocusUsers.SetTransObject(SQLCA)
l_cCurrentUser = OBJCA.WIN.fu_GetLogin(SQLCA)
IF ib_xfer_from_queue THEN // If owned by a work queue, you can xfer to yourself
	i_dsCusFocusUsers.Retrieve( l_cOwner )
ELSE                        // Otherwise, you should be left out of the list
	i_dsCusFocusUsers.Retrieve( l_cCurrentUser )
END IF

IF i_dsCusFocusUsers.RowCount() = 0 THEN
	MessageBox (gs_AppName,"The "+gs_AppName+" system has only one user registered.~r~n" + &
	                            "Case transfers require at least two registered users.")
	This.Visible = FALSE
	cb_cancel.PostEvent(Clicked!)
ELSE
	//Get the demographics security for the case
	i_nRecordConfidLevel = fw_GetRecConfidLevel( l_cSubjectID, l_cSourceType )
	
	CHOOSE CASE l_cCasePriority
		CASE "H"
			l_cCasePriority = "HIGH"
		CASE "N"
			l_cCasePriority = "NORMAL"
		CASE "L"
			l_cCasePriority = "LOW"
		CASE ELSE
			l_cCasePriority = "UNKNOWN"
	END CHOOSE
	
	//Figure the days open
	l_nDaysOpen = DaysAfter( Date( l_dtOpenedDate ), Today( ) )
	
	Title += ' Case # - '+i_cCaseNumber+'   Taken By - '+Upper( i_cTakenBy )+'   Priority - '+l_cCasePriority+ &
				'   Days Open - '+String( l_nDaysOpen )
		
	//If the current user isn't the same as the case owner, disable the window	
	IF Upper( l_cCurrentUser ) <> Upper( l_cOwner ) AND &
	   Upper( l_cCurrentUser ) <> Upper( i_cTakenBy ) AND &
		ib_xfer_from_queue = FALSE THEN
		IF i_bControlsEnabled THEN THIS.Event Trigger ue_Disable( TRUE )
	END IF
	
	i_cPreviousMessageText = FWCA.MSG.fu_GetMessage("ChangesOne", FWCA.MSG.c_MSG_Text)
	FWCA.MSG.fu_SetMessage("ChangesOne", FWCA.MSG.c_MSG_Text, &
		'Do you wish to save this Case Transfer Information?')
		
	//Build the treeview
	tv_tfer_to.Event Trigger ue_build( )	
END IF


end event

on w_transfer_case.create
int iCurrent
call super::create
this.p_1=create p_1
this.st_5=create st_5
this.st_3=create st_3
this.cb_transferhistory=create cb_transferhistory
this.st_2=create st_2
this.tv_tfer_to=create tv_tfer_to
this.st_1=create st_1
this.dw_transfer_case=create dw_transfer_case
this.dw_transfer_history=create dw_transfer_history
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_trash=create dw_trash
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.cb_transferhistory
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.tv_tfer_to
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_transfer_case
this.Control[iCurrent+9]=this.dw_transfer_history
this.Control[iCurrent+10]=this.cb_ok
this.Control[iCurrent+11]=this.cb_cancel
this.Control[iCurrent+12]=this.dw_trash
this.Control[iCurrent+13]=this.ln_1
this.Control[iCurrent+14]=this.ln_2
this.Control[iCurrent+15]=this.ln_3
this.Control[iCurrent+16]=this.ln_4
this.Control[iCurrent+17]=this.st_4
end on

on w_transfer_case.destroy
call super::destroy
destroy(this.p_1)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.cb_transferhistory)
destroy(this.st_2)
destroy(this.tv_tfer_to)
destroy(this.st_1)
destroy(this.dw_transfer_case)
destroy(this.dw_transfer_history)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_trash)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.st_4)
end on

event closequery;/***************************************************************************************

	Event:	closequery
	Purpose:	Please see PB documentation for this event
				
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	2/22/2001 K. Claver    Overrode and added code to ask if the user wants to save before
								  exiting.
****************************************************************************************/
Integer l_nRV

IF dw_transfer_history.ModifiedCount( ) > 0 THEN
	l_nRV = MessageBox( gs_AppName, "Do you want to save your changes before closing?", &
							  Question!, YesNoCancel! )
							  
	CHOOSE CASE l_nRV
		CASE 1
			cb_ok.Event Trigger clicked( )
		CASE 2
			dw_transfer_case.fu_ResetUpdate( )
			dw_transfer_history.fu_ResetUpdate( )
			
			PCCA.Parm[1] = ''
			PCCA.Parm[2] = ''
		CASE 3
			RETURN 1
	END CHOOSE
ELSEIF IsNumber( PCCA.Parm[1] ) THEN
	//The first parm is still set to the case number.  Transfer hasn't happened.
	PCCA.Parm[1] = ''
	PCCA.Parm[2] = ''
END IF
end event

event pc_close;call super::pc_close;/***************************************************************************************

	Event:	pc_close
	Purpose:	Please see PowerClass documentation for this event
				
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	2/14/2002 K. Claver    Destroy the users datastore.
****************************************************************************************/
IF IsValid( i_dsCusFocusUsers ) THEN
	DESTROY i_dsCusFocusUsers
END IF
end event

type p_1 from picture within w_transfer_case
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_5 from statictext within w_transfer_case
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
string text = "Transfer Case"
boolean focusrectangle = false
end type

type st_3 from statictext within w_transfer_case
integer width = 3602
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type cb_transferhistory from commandbutton within w_transfer_case
integer x = 37
integer y = 1924
integer width = 389
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&View History"
end type

event clicked;FWCA.MGR.fu_OpenWindow( w_view_transfer_history, PARENT.i_cCaseNumber )
end event

type st_2 from statictext within w_transfer_case
integer x = 1399
integer y = 1000
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 79741120
string text = "Transfer/Copy List:"
boolean focusrectangle = false
end type

type tv_tfer_to from treeview within w_transfer_case
event ue_build ( )
event ue_changelabel ( treeviewitem a_tviitem,  long a_nitemhandle,  long a_ndwrow,  string a_cchange )
integer x = 37
integer y = 1080
integer width = 1275
integer height = 748
integer taborder = 20
string dragicon = "contactperson.ico"
boolean dragauto = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean disabledragdrop = false
boolean hideselection = false
boolean singleexpand = true
string picturename[] = {"routed.bmp","person.bmp","out_of_office.bmp","lowconfid.bmp","smallminus.bmp","route_to.bmp",""}
integer picturewidth = 16
integer pictureheight = 16
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event ue_build();//////////////////////////////////////////////////////////////////////////////
//
//	Method/Event:  tv_tfer_to.ue_build
//
//	Description:   Builds the treeview parent and child nodes
//
// Returns:  		None
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Software Engineer     Date        Comments
// ------------------------------------------
//	K. Claver             6/13/2000   Initial version
//
//////////////////////////////////////////////////////////////////////////////
Integer l_nIndex, l_nRow, l_nRowCount, l_nChildHandle = 0, l_nHistRow
Integer l_nConfLevel, l_nRepRecConfLevel, li_route_conf
String l_cFullName, l_cFirstName, l_cLastName, l_cDepartment, l_cChildBitmap
String l_cUserID, l_cTferType, l_cRouteTo
TreeViewItem l_tviUser, l_tviDept
DataStore lds_Departments

SetPointer( HourGlass! )

lds_Departments = CREATE DataStore
lds_Departments.DataObject = "d_user_department"
lds_Departments.SetTransObject( SQLCA )
l_nRowCount = lds_Departments.Retrieve( )

THIS.SetRedraw( FALSE )

//Parent level
IF l_nRowCount > 0 THEN
	FOR l_nIndex = 1 TO l_nRowCount
		l_tviDept.Label = Trim( lds_Departments.Object.dept_desc[ l_nIndex ] )
		l_tviDept.Data = lds_Departments.Object.user_dept_id[ l_nIndex ]
		l_tviDept.Level = 1
		l_tviDept.ItemHandle = l_nIndex
//		l_tviDept.PictureIndex = 1
//		l_tviDept.SelectedPictureIndex = 1
		l_tviDept.Children = FALSE
		
		THIS.InsertItemLast( 0, l_tviDept )
	NEXT
END IF

//Sort the child datawindow
i_dsCusFocusUsers.Sort( )

//Child level
IF i_dsCusFocusUsers.RowCount( ) > 0 THEN
	IF l_nRowCount > 0 THEN
		FOR l_nIndex = 1 TO l_nRowCount
			l_cDepartment = Trim( lds_Departments.Object.user_dept_id[ l_nIndex ] )
			
			l_nRow = i_dsCusFocusUsers.Find( "user_dept_id = '"+l_cDepartment+"'", 1, i_dsCusFocusUsers.RowCount( ) )
				
			IF l_nRow > 0 THEN
				DO
					//add to the treeview
					l_cLastName = Trim( i_dsCusFocusUsers.GetItemString( l_nRow, "user_last_name" ) )
					l_cFirstName = Trim( i_dsCusFocusUsers.GetItemString( l_nRow, "user_first_name" ) )
					IF l_cLastName = "" OR IsNull( l_cLastName ) THEN
						l_cFullName = l_cFirstName
					ELSEIF l_cFirstName = "" OR IsNull( l_cFirstName ) THEN
						l_cFullName = l_cLastName
					ELSEIF ( l_cLastName = "" OR IsNull( l_cLastName ) ) AND &
							 ( l_cFirstName = "" OR IsNull( l_cFirstName ) ) THEN
						l_cFullName = "<No Name>"
					ELSE
						l_cFullName = l_cLastName+", "+l_cFirstName
					END IF
					
					l_nChildHandle = ( l_nRow + l_nRowCount )
					
					l_tviUser.Label = l_cFullName
					l_cUserID = Trim( i_dsCusFocusUsers.GetItemString( l_nRow, "user_id" ) )
					l_tviUser.Data = l_cUserID
					l_tviUser.Level = 2
					
					//Determine which bitmap to display
					//First, check if the person already exists in the transfer history datawindow
					l_nHistRow = dw_transfer_history.Find( "case_transfer_to = '"+l_cUserID+"'", 1, dw_transfer_history.RowCount( ) )
					IF l_nHistRow > 0 THEN
						//First, store this item's handle in the history datawindow for delete functionality
						dw_transfer_history.Object.treeview_handle[ l_nHistRow ] = l_nChildHandle
						dw_transfer_history.SetItemStatus( l_nHistRow, 0, Primary!, NotModified! )
						
						//Get the transfer type
						l_cTferType = dw_transfer_history.Object.case_transfer_type[ l_nHistRow ]
						
						//Now, change the text
						IF l_cTferType = "O" THEN
							l_tviUser.Label = ( l_cFullName+"(Owner)" )
						ELSE
							l_tviUser.Label = ( l_cFullName+"(Copy)" )
						END IF					
					END IF
					
					//If not found in the transfer history datawindow, check if out of office and confidentiality
					//  level.
					l_cChildBitmap = Upper( Trim( i_dsCusFocusUsers.GetItemString( l_nRow, "out_of_office_bmp" ) ) )
					l_nConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nRow, "confidentiality_level" )
					l_nRepRecConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nRow, "rec_confidentiality_level" )
					
					IF l_cChildBitmap = "OUT_OF_OFFICE.BMP" THEN
						//First, check if has routing set up
						SELECT cusfocus.out_of_office.assigned_to_user_id
						INTO :l_cRouteTo
						FROM cusfocus.out_of_office
						WHERE cusfocus.out_of_office.out_user_id = :l_cUserID
						USING SQLCA;
						
						IF IsNull( l_cRouteTo ) OR Trim( l_cRouteTo ) = "" THEN						
							//Out of office
							l_tviUser.PictureIndex = 3
							l_tviUser.SelectedPictureIndex = 3
						ELSE
							//Out of office with routing
							l_tviUser.PictureIndex = 1
							l_tviUser.SelectedPictureIndex = 1
						END IF
					ELSEIF l_nConfLevel < i_nCaseConfidLevel OR l_nRepRecConfLevel < i_nRecordConfidLevel THEN
						//Person doesn't have the right confidentiality level to transfer the case
						l_tviUser.PictureIndex = 4
						l_tviUser.SelectedPictureIndex = 4
					ELSE
						//Default to person.bmp
						l_tviUser.PictureIndex = 2
						l_tviUser.SelectedPictureIndex = 2
					END IF
					
					l_tviUser.ItemHandle = l_nChildHandle
					l_tviUser.Children = FALSE				
					
					//Set the treeview handle in the instance datawindow child for easy lookup
					//  for routing later.
					i_dsCusFocusUsers.SetItem( l_nRow, "treeview_handle", l_nChildHandle )
					
					//Insert the treeview item
					THIS.InsertItemLast( l_nIndex, l_tviUser )
					
					l_nRow ++
					IF l_nRow > i_dsCusFocusUsers.RowCount( ) THEN
						EXIT
					END IF
					
					//Since this version of PB can't differentiate between a null value and a 
					//  variable that is not null, must put this code here.
					IF NOT IsNull( l_cDepartment ) AND &
					   IsNull( Trim( i_dsCusFocusUsers.GetItemString( l_nRow, "user_dept_id" ) ) ) THEN
						EXIT
					END IF
				LOOP UNTIL l_cDepartment <> Trim( i_dsCusFocusUsers.GetItemString( l_nRow, "user_dept_id" ) )
			END IF
		NEXT
	END IF
END IF

THIS.SetRedraw( TRUE )

IF IsValid( lds_Departments ) THEN Destroy lds_Departments

SetPointer( Arrow! )
end event

event ue_changelabel(treeviewitem a_tviitem, long a_nitemhandle, long a_ndwrow, string a_cchange);/****************************************************************************************
			Event:	ue_ChangeLabel
		 Purpose:	Change the label on the treeview item to reflect owner or copy
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/11/2000 K. Claver    Created
**************************************************************************************/
//If the treeview item isn't valid, attempt to get one.
IF String( a_tviItem.Data ) = "" THEN
	IF a_nItemHandle = 0 THEN
		IF a_cChange <> "" THEN
			a_nItemHandle = dw_transfer_history.Object.treeview_handle[ a_nDWRow ]
		ELSE
			a_nItemHandle = dw_trash.Object.treeview_handle[ a_nDWRow ]
		END IF
	END IF
	
	THIS.GetItem( a_nItemHandle, a_tviItem )
END IF

//If already marked as Copy or Owner, have to get rid of the prior flag and add on the
//  new.  Otherwise, just add on.
IF Match( a_tviItem.Label, "(Copy)" ) OR Match( a_tviItem.Label, "(Owner)" ) THEN
	a_tviItem.Label = ( Mid( a_tviItem.Label, 1, ( Pos( a_tviItem.Label, "(" ) - 1 ) )+a_cChange )
ELSE
	a_tviItem.Label += a_cChange
END IF

THIS.SetItem( a_nItemHandle, a_tviItem )

end event

event clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Method/Event:  tv_tfer_to.clicked
//
//	Description:   Transfers the clicked user id to the dw_transfer_case datawindow
//
// Returns:  		See PB documentation for this event
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Software Engineer     Date        Comments
// ------------------------------------------
//	K. Claver             6/13/2000   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//TreeViewItem ltvi_Clicked
//Integer li_RV
//String ls_Data
//
//IF handle > 0 THEN
//	li_RV = THIS.GetItem( handle, ltvi_Clicked )
//	
//	IF li_RV = 1 THEN
//		IF ltvi_Clicked.Level = 2 THEN
//			ls_Data = String( ltvi_Clicked.Data )
//		
//			dw_transfer_case.Object.case_transfer_to[ 1 ] = ls_Data
//		ELSE
//			SetNull( ls_Data )
//			dw_transfer_case.Object.case_transfer_to[ 1 ] = ls_Data
//			dw_transfer_case.SetItemStatus( 1, 0, Primary!, NotModified! )
//		END IF
//	END IF
//END IF
//	
//	
end event

event doubleclicked;/****************************************************************************************
			Event:	doubleclicked
		 Purpose:	Please see PB documentation for this event
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/5/2000 K. Claver    Added code to allow the user to double click a user to add to
								  the transfer list.
**************************************************************************************/
dwObject l_dwoDummy
TreeviewItem l_tviItem

THIS.GetItem( handle, l_tviItem )

IF l_tviItem.Level = 2 THEN
	dw_transfer_history.Event Trigger dragdrop( THIS, 1, l_dwoDummy )
END IF
end event

type st_1 from statictext within w_transfer_case
integer x = 37
integer y = 1000
integer width = 462
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transfer/Copy To:"
boolean focusrectangle = false
end type

type dw_transfer_case from u_dw_std within w_transfer_case
integer x = 18
integer y = 196
integer width = 2693
integer height = 796
integer taborder = 10
string dataobject = "d_transfer_case"
boolean border = false
end type

event pcd_savebefore;/**************************************************************************************

		Event:	pcd_savebefore
	 Purpose:	To check to see if the Transfer To is null.  If so, prompt the user and
					place the focus to the Transfer To dddw.

**************************************************************************************/

IF IsNull( i_cTransferTo ) THEN
		MessageBox( gs_AppName,'A Transfer To is Required prior to Transferring a Case.'+ &
					   ' Please enter a Transfer To.' )
 	Error.i_FWError = c_Fatal
	tv_tfer_to.SetFocus( )
END IF

end event

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
			Event:	pcd_retrieve
		 Purpose:	Retrieve the datawindow
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/2/2000 K. Claver    Added code to retrieve the datawindow by case number
								  and add the current user as the transfer to id
**************************************************************************************/
String l_cCurrentUser, l_cTransferFrom, l_cOwner, l_cNull
Integer l_nRowCount, l_nUserConfLevel, l_nRow
Long ll_RFC_count

l_nRowCount = THIS.Retrieve( i_cCaseNumber )

l_cCurrentUser = OBJCA.WIN.fu_GetLogin( SQLCA )

IF l_nRowCount = 0 THEN
	THIS.fu_New( 1 )
	l_cTransferFrom = "(Not Yet Transferred)"
ELSE
	l_cTransferFrom = THIS.Object.case_transfer_from[ 1 ]
	SetNull( l_cNull )
	THIS.Object.case_transfer_notes[ 1 ] = l_cNull
	THIS.Object.case_transfer_code[ 1 ] = l_cNull
	THIS.fu_ResetUpdate( )
END IF

//Get the user confidentiality level
SELECT cusfocus.cusfocus_user.confidentiality_level
INTO :l_nUserConfLevel
FROM cusfocus.cusfocus_user
WHERE cusfocus.cusfocus_user.user_id = :l_cCurrentUser
USING SQLCA;

//Disable the Return For Close checkbox if the current user is different than the originator
// 10/01/08 - RAP - Return for close now allows anyone in the ownership chain to set it,
//                          but it can only be set once.
IF l_nUserConfLevel < i_nCaseConfidLevel THEN
	THIS.Object.return_for_close.Protect = "1"
END IF
IF Upper( l_cCurrentUser ) = Upper( i_cTakenBy ) THEN
	PARENT.i_bOriginator = TRUE
ELSE
	PARENT.i_bOriginator = FALSE
END IF

//If return for closure is set to anyone, make the return for close option not visible
Parent.fw_closeby()
IF NOT IsNull( Parent.i_cCloseBy ) AND Parent.i_cCloseBy = "ANY" THEN
	THIS.Object.return_for_close.Visible = "0"
END IF
	
// Disable notify_originator_close and return_for_close
// if being transferred from a work queue
IF ib_xfer_from_queue THEN 
	THIS.object.notify_originator_close.visible = "0"
	THIS.object.return_for_close.visible = "0"
	THIS.object.t_2.visible = "0"
	THIS.object.l_1.visible = "0"
	THIS.object.l_2.visible = "0"
END IF
//Set the groupbox text
//THIS.Object.gb_transfer_from.text = "Transfer From "+Upper( l_cTransferFrom )

// Only one return for close is allowed
SELECT count(*) INTO :ll_RFC_count
FROM cusfocus.case_transfer
WHERE case_transfer_type = 'O'
AND case_number = :i_cCaseNumber
AND return_for_close = 1
USING SQLCA;

// If not found here, check history
IF ll_RFC_count = 0 THEN
	SELECT count(*) INTO :ll_RFC_count
	FROM cusfocus.case_transfer_history
	WHERE case_transfer_type = 'O'
	AND case_number = :i_cCaseNumber
	AND return_for_close = 1
	USING SQLCA;
END IF

IF ll_RFC_count > 0 THEN
	THIS.object.return_for_close[1] = 0
	THIS.object.notify_originator_close[1] = 0
	THIS.object.notify_originator_close.visible = "0"
	THIS.object.return_for_close.visible = "0"
	THIS.object.t_2.visible = "0"
	THIS.object.l_1.visible = "0"
	THIS.object.l_2.visible = "0"
END IF	

end event

event itemchanged;call super::itemchanged;/****************************************************************************************
			Event:	itemchanged
		 Purpose:	See PB documentation for this event
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/2/2000 K. Claver    Added code to append the transfer code description to the
								  transfer notes.
	11/1/2000 K. Claver    Added code to not allow both notify when close and return for
								  close to be checked
**************************************************************************************/
DatawindowChild l_dwcTransferCode
Integer l_nRow
String l_cTransferDesc, l_cTransferNotes, l_cUpperName

l_cUpperName = Upper( dwo.Name )

CHOOSE CASE l_cUpperName
	CASE "CASE_TRANSFER_CODE" 
		THIS.GetChild( "case_transfer_code", l_dwcTransferCode )
		
		l_nRow = l_dwcTransferCode.Find( "case_transfer_code = '"+data+"'", 1, l_dwcTransferCode.RowCount( ) )
	
		IF l_nRow > 0 THEN
			l_cTransferDesc = l_dwcTransferCode.GetItemString( l_nRow, "code_desc" )
			l_cTransferNotes = THIS.Object.case_transfer_notes[ 1 ]
			
			IF IsNull( l_cTransferNotes ) THEN
				l_cTransferNotes = ""
			END IF
			
			//Add the code description on to the notes
			l_cTransferNotes += l_cTransferDesc
			THIS.Object.case_transfer_notes[ 1 ] = l_cTransferNotes
		END IF
	CASE "NOTIFY_ORIGINATOR_CLOSE"
		//Doesn't make sense to have both notify and return checked
		IF data = "1" THEN
			IF THIS.Object.return_for_close[ row ] = 1 THEN
				THIS.Object.return_for_close[ row ] = 0
			END IF
		END IF
	CASE "RETURN_FOR_CLOSE"
		//Doesn't make sense to have both notify and return checked
		IF data = "1" THEN
			IF THIS.Object.notify_originator_close[ row ] = 1 THEN
				THIS.Object.notify_originator_close[ row ] = 0
			END IF
		END IF
	CASE "CASE_TRANSFER_EMAIL_CONFIRMATION"
		IF data = "Y" THEN
			THIS.object.case_transfer_subject[ row ] = "Please review case #" + parent.i_ccasenumber
		ELSE
			THIS.object.case_transfer_subject[ row ] = ""
		END IF
END CHOOSE
end event

event buttonclicked;call super::buttonclicked;/****************************************************************************************
			Event:	buttonclicked
		 Purpose:	Please see PB documentation for this event
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/5/2000 K. Claver    Added code to display a calendar window when click the 
								  elipsis button next to the transfer deadline field.
**************************************************************************************/
DateTime l_dtDeadline
String l_cDeadline, l_cParm, l_cX, l_cY
Integer l_nX, l_nY, l_nHeight

//Get the button's dimensions to position the calendar window
l_nX = ( Integer( THIS.Object.b_calendar.X ) + PARENT.X )
l_nY = ( Integer( THIS.Object.b_calendar.Y ) + PARENT.Y )
l_nHeight = Integer( THIS.Object.b_calendar.Height )
l_cX = String( l_nX + 10 )
l_cY = String( l_nY + l_nHeight + 25 )

//Only one button(calendar) so open the calendar window
THIS.AcceptText( )
l_dtDeadline = THIS.Object.case_transfer_deadline[ 1 ]
l_cParm = ( String( Date( l_dtDeadline ), "mm/dd/yy" )+"&"+l_cX+"&"+l_cY )
OpenWithParm( w_calendar, l_cParm, PARENT )

//Get the date passed back
l_cDeadline = Message.StringParm

//If it's a date, convert to a datetime.  Otherwise, set to null.
IF IsDate( Message.StringParm ) THEN
	l_dtDeadline = DateTime( Date( Message.StringParm ), Time( "00:00:00.000" ) )
ELSE
	SetNull( l_dtDeadline )
END IF

//Add the date to the datawindow
THIS.Object.case_transfer_deadline[ 1 ] = l_dtDeadline


end event

event pcd_setoptions;call super::pcd_setoptions;/****************************************************************************************
			Event:	pcd_setoptions
		 Purpose:	Event to set options for the datawindow
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	
**************************************************************************************/
THIS.fu_SetOptions( SQLCA, & 
						  THIS.c_NullDW, & 
						  THIS.c_NoDrop+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_ModifyOnOpen+ &
						  THIS.c_NewOK+ &
						  THIS.c_NewOnOpen+ &
						  THIS.c_IgnoreNewRows+ &
						  THIS.c_NoEnablePopup )
end event

type dw_transfer_history from u_dw_std within w_transfer_case
event ue_lbuttonup pbm_dwnlbuttonup
integer x = 1399
integer y = 1080
integer width = 1275
integer height = 748
integer taborder = 30
string dragicon = "editcorrespondence.ico"
string dataobject = "d_transfer_history"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;/****************************************************************************************
		
			Event:	pcd_retrieve
		 Purpose:	To retrieve the Case Transfer History for the current case.

-----------------------------------------------------------------------------------------
6/19/2001  K. Claver   Changed to retrieve a datastore for current transfers comparison.
****************************************************************************************/

//LONG l_nReturn
//
////Instead of retrieving this datawindow, let's retrieve the datastore for comparison of
////  transfers.
//i_dsCurrentTransfers = CREATE DataStore
//i_dsCurrentTransfers.DataObject = "d_transfer_history"
//i_dsCurrentTransfers.SetTransObject( SQLCA )
//l_nReturn = i_dsCurrentTransfers.Retrieve( i_cCaseNumber )
//
//IF l_nReturn < 0 THEN
// 	Error.i_FWError = c_Fatal
//END IF
end event

event itemchanged;call super::itemchanged;//**********************************************************************************************
//
//  Event:   itemchanged
//  Purpose: See PB documentation for this event
//  
//  Date
//  -------- ----------- -----------------------------------------------------------------------
//  10/02/00 K. Claver   Added code to prevent the user from assigning more than one owner to 
//                       the case
//  01/05/01 C. Jackson  Add Full name for messagebox
//  06/13/03 M. Caruso   Made enable/disable of fields conditional based on i_bControlsEnabled.
//**********************************************************************************************

String l_cDWOName, l_cOwnerID, l_cRowID, l_cOwnerFullName, l_cRowFullName
Integer l_nOwnerRow, l_nRV, l_nHandle
TreeViewItem l_tviItem
DWItemStatus l_dwisStatus

l_cDWOName = Upper( dwo.Name )

IF l_cDWOName = "CASE_TRANSFER_TYPE" THEN
	IF data = "O" THEN
		l_nOwnerRow = THIS.Find( "case_transfer_type = 'O'", 1, THIS.RowCount( ) )
		IF l_nOwnerRow > 0 THEN
			l_cOwnerID = THIS.Object.case_transfer_to[ l_nOwnerRow ]
			l_cRowID = THIS.Object.case_transfer_to[ row ]
			
			// Get full names for messagebox
			SELECT user_first_name + ' ' + user_last_name INTO :l_cOwnerFullName
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :l_cOwnerID
			 USING SQLCA;
			 
			SELECT user_first_name + ' ' + user_last_name INTO :l_cRowFullName
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :l_cRowID
			 USING SQLCA;
			
			l_nRV = MessageBox( gs_AppName, l_cOwnerFullName+" is currently set as owner.  Set "+l_cRowFullName+" as owner?", &
							Question!, YesNo! )
							
			IF l_nRV = 1 THEN
				//Get the itemhandle so can change the label on the prior owner
				tv_tfer_to.Event Trigger ue_ChangeLabel( l_tviItem, 0, l_nOwnerRow, "(Copy)" )
				
				//Get the itemhandle so can change the label of the current owner
				tv_tfer_to.Event Trigger ue_ChangeLabel( l_tviItem, 0, row, "(Owner)" )
				
				THIS.Object.case_transfer_type[ l_nOwnerRow ] = "C"
				i_cTransferTo = l_cRowID
			ELSE
				i_cTransferTo = l_cOwnerID
				RETURN 2
			END IF
		ELSE
			//Get the itemhandle so can change the label of the current owner
			tv_tfer_to.Event Trigger ue_ChangeLabel( l_tviItem, 0, row, "(Owner)" )
		END IF
		
		// enable the controls if they are disabled
		IF NOT i_bControlsEnabled THEN PARENT.Event Trigger ue_Enable( )
	ELSE
		//Check for a current owner row.  If doesn't exist, reload and disable the transfer
		//  options, if the user chooses that option.
		l_nOwnerRow = THIS.Find( "case_transfer_type = 'O'", 1, THIS.RowCount( ) )
		IF l_nOwnerRow = 0 OR l_nOwnerRow = row THEN
			dw_transfer_case.AcceptText( )
			l_dwisStatus = dw_transfer_case.GetItemStatus( 1, 0, Primary! )
			IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
				l_nRV = MessageBox( gs_AppName, "You will lose all of your transfer property changes if you set~r~n"+ &
										  "all users as being copied on this case.  Continue?", Question!, YesNo! )
				IF l_nRV = 1 THEN
					dw_transfer_case.fu_Retrieve( dw_transfer_case.c_IgnoreChanges, dw_transfer_case.c_NoReselectRows )
				ELSEIF l_nRV = 2 THEN
					RETURN 2
				END IF
			END IF
		END IF
				
		//Disable the transfer properties if they are enabled
		IF i_bControlsEnabled THEN PARENT.Event Trigger ue_Disable( FALSE )
		
		//Get the itemhandle so can change the label
		tv_tfer_to.Event Trigger ue_ChangeLabel( l_tviItem, 0, row, "(Copy)" )
		
		//Set the focus back to this object
		THIS.SetFocus( )
	END IF
END IF
		
	

end event

event dragdrop;call super::dragdrop;/****************************************************************************************
			Event:	dragdrop
		 Purpose:	See PB documentation for this event
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	10/2/2000 K. Claver    Added code to copy the information dragged from the treeview
								  to the datawindow.
****************************************************************************************/
Integer l_nRow, l_nItemHandle, l_nTVLevel, l_nPicIndex, l_nIDRow, l_nToConfLevel
Integer l_nPriorOwnerHandle, l_nRV = 1, l_nOrigItemHandle, l_nRepRecConfLevel, li_return
Long ll_pos
DateTime l_dtNull
TreeViewItem l_tviTferTo, l_tviParentItem, l_tviNoData
TreeView l_tvObject
Boolean l_bExpanded, l_bChanged, lb_xfer_to_queue
String l_cTferToID, l_cTferFromID, l_cNotify, l_cRouteToID, l_cTferToFullName, ls_work_queue
STRING l_cRouteToFullName

string	ls_fromdeptID, ls_todeptID

SetPointer( Hourglass! )
SetRedraw( FALSE )

SetNull( l_dtNull )

//Only process if came from a TreeView item.
IF source.TypeOf( ) = TreeView! THEN
	//Set the pointer to the treeview into a treeview variable
	l_tvObject = source
	
	//Get the transfer from ID
	IF ib_xfer_from_queue THEN
		l_cTferFromID = i_cUserLastName
	ELSE
		l_cTferFromID = OBJCA.WIN.fu_GetLogin( SQLCA )
	END IF
	
	//Get the dragged treeview item.
	l_nItemHandle = l_tvObject.FindItem( CurrentTreeItem!, 0 )
	l_tvObject.GetItem( l_nItemHandle, l_tviTferTo )

	IF l_tviTferTo.Level = 1 THEN
		ls_work_queue = PARENT.of_check_work_queue(l_tviTferTo.Data, 'dept')
	ELSE
		ls_work_queue = PARENT.of_check_work_queue(l_tviTferTo.Data, 'user')
	END IF

	IF ls_work_queue = 'Y' THEN 
		lb_xfer_to_queue = TRUE
	ELSE
		lb_xfer_to_queue = FALSE
	END IF
	
	//If dragged a level 1 item, transfer all children.
	IF l_tviTferTo.Level = 1 AND l_tviTferTo.Children AND NOT lb_xfer_to_queue THEN
		l_tviParentItem = l_tviTferTo
		
		//Store whether the parent tree item is expanded.  Necessary because
		//  Finditem( ) with ChildTreeItem! causes the node to expand. 
		l_bExpanded = l_tviParentItem.Expanded
	
		//Set redraw off so doesn't show node expansion.
		l_tvObject.SetRedraw( FALSE )
		
		l_nItemHandle = l_tvObject.FindItem( ChildTreeItem!, l_tviTferTo.ItemHandle )
		l_nOrigItemHandle = l_nItemHandle
		l_tvObject.GetItem( l_nItemHandle, l_tviTferTo )
		l_nTVLevel = l_tviTferTo.Level
		l_nPicIndex = l_tviTferTo.PictureIndex
		
		//Get the to user
		l_cTferToID = String( l_tviTferTo.Data )
		
		//Check for routing
		l_cRouteToID = PARENT.fw_CheckRoute( l_cTferToID )
		
		IF Mid(l_cRouteToID,1,14) = "Security Error" THEN
			MessageBox( gs_AppName, "User "+l_cTferToID+"'s cases are being routed to user "+Mid(l_cRouteToID,17)+".~r~n"+ &
							"User "+Mid(l_cRouteToID,17)+" does not have the proper security level to take this case.", &
							StopSign!, Ok! )
			//Don't continue
			l_nRV = 0
		END IF
		
		//If routing is set up, check notify flag and strip off end of route to id.
		IF Pos( l_cRouteToID, "(" ) > 0 THEN
			SetPointer( Arrow! )
			
			l_cNotify = Mid( l_cRouteToID, Pos( l_cRouteToID, "(" ) )
			l_cRouteToID = Mid( l_cRouteToID, 1, ( Pos( l_cRouteToID, "(" ) - 1 ) )
			
			// Get Full Names for messagebox
			SELECT user_first_name + ' ' + user_last_name INTO :l_cTferToFullName
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :l_cTferToID
			 USING SQLCA;
			 
			SELECT user_first_name + ' ' + user_last_name INTO :l_cRouteToFullName
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :l_cRouteToID
			 USING SQLCA;
			 
			//Check to see if transfer to self as a result of routing
			IF l_cRouteToID = l_cTferFromID THEN
				MessageBox( gs_AppName, "You are currently being routed "+l_cTferToFullName+"'s cases.  "+ &
								"You cannot transfer a case to yourself.", Stopsign!, Ok! )
				SetRedraw( TRUE )
				//Don't continue
				l_nRV = 0
			END IF

			IF l_nRV = 1 THEN
				//If set to notify before route, then do so
				IF l_cNotify = "(Y)" THEN
					l_nRV = MessageBox( gs_AppName, l_cTferToFullName+"'s cases are being routed to "+l_cRouteToFullName+"."+ &
											  "~r~nContinue?", Question!, YesNo!, 1 )
				END IF 
												
				SetPointer( Hourglass! )
					
				//Change to the transfer to ID	
				IF l_nRV = 1 THEN
					l_bChanged = TRUE
					l_cTferToID = l_cRouteToID
				END IF
			END IF
		END IF
		
		IF l_nRV = 1 THEN
			//Get the confidentiality level
			l_nIDRow = i_dsCusFocusUsers.Find( "user_id ='"+l_cTferToID+"'", 1, i_dsCusFocusUsers.RowCount( ) )
			IF l_nIDRow > 0 THEN
				l_nToConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "confidentiality_level" )
				l_nRepRecConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "rec_confidentiality_level" )
			END IF
			
			//If changed, means routing.  Need to change the treeviewitem we're pointing to
			IF l_bChanged THEN
				l_nItemHandle = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "treeview_handle" )
				l_tvObject.GetItem( l_nItemHandle, l_tviTferTo )
				l_nTVLevel = l_tviTferTo.Level
				l_nPicIndex = l_tviTferTo.PictureIndex
				
				l_bChanged = FALSE
			END IF			
			
			DO
				//Check if we've already added them to the datawindow
				IF THIS.Find( "case_transfer_to = '"+l_cTferToID+"'", 1, THIS.RowCount( ) ) < 1 THEN
					//Picture index 3 tells us that the person
					//  is marked out of office.  Skip out of office
					//  users.  Also skip if the confidentiality levels aren't
					//  correct.
					IF ( l_nPicIndex <> 3 ) AND &
						( l_nToConfLevel >= i_nCaseConfidLevel ) AND &
						( ( l_nRepRecConfLevel >= i_nRecordConfidLevel ) OR &
						( IsNull( i_nRecordConfidLevel ) ) ) THEN
						
						//Add a row
						l_nRow = THIS.InsertRow( 0 )
						
						//Insert the values
						THIS.Object.case_number[ l_nRow ] = i_cCaseNumber
						
						//Determine if should mark as owner or copy
						IF THIS.Find( "case_transfer_type = 'O'", 1, THIS.RowCount( ) ) = 0 THEN
							THIS.Object.case_transfer_type[ l_nRow ] = "O"
							IF NOT i_bControlsEnabled THEN PARENT.Event Trigger ue_Enable( )
						ELSE
							THIS.Object.case_transfer_type[ l_nRow ] = "C"
						END IF
						
						THIS.Object.notify_transfer_close[ l_nRow ] = 0
						THIS.Object.case_transfer_from[ l_nRow ] = l_cTferFromID
						THIS.Object.case_transfer_to[ l_nRow ] = l_cTferToID
						THIS.Object.case_transfer_date[ l_nRow ] = l_dtNull
						THIS.Object.treeview_handle[ l_nRow ] = l_nItemHandle
						
						//JWhite	Added 8.1.2006
						SELECT cusfocus.cusfocus_user.user_dept_id  
						  INTO :ls_fromdeptID  
						  FROM cusfocus.cusfocus_user  
						 WHERE cusfocus.cusfocus_user.user_id = :l_cTferFromID   ;
							 
						SELECT cusfocus.cusfocus_user.user_dept_id  
						  INTO :ls_todeptID  
						  FROM cusfocus.cusfocus_user  
						 WHERE cusfocus.cusfocus_user.user_id = :l_cTferToID   ;
							 
						THIS.Object.case_transfer_transfer_to_dept[ l_nRow ] = ls_todeptID
						THIS.Object.case_transfer_transfer_from_dept[ l_nRow ] = ls_fromdeptID
						//End JWhite Added 8.1.2006
						
						//Change the treeview text
						IF THIS.Object.case_transfer_type[ l_nRow ] = "O" THEN
							l_tvObject.Event Dynamic Trigger ue_ChangeLabel( l_tviTferTo, l_nItemHandle, 0, "(Owner)" )
						ELSE
							l_tvObject.Event Dynamic Trigger ue_ChangeLabel( l_tviTferTo, l_nItemHandle, 0, "(Copy)" )
						END IF
					END IF
				END IF
				
				l_nItemHandle = l_tvObject.FindItem( NextVisibleTreeItem!, l_nOrigItemHandle )
				IF l_nItemHandle > 0 THEN
					l_nOrigItemHandle = l_nItemHandle
					
					l_tvObject.GetItem( l_nItemHandle, l_tviTferTo )
					l_nTVLevel = l_tviTferTo.Level
					l_nPicIndex = l_tviTferTo.PictureIndex
					
					//Get the next to user confidentiality level
					l_cTferToID = String( l_tviTferTo.Data )
					//Check for routing
					l_cRouteToID = PARENT.fw_CheckRoute( l_cTferToID )

					IF Mid(l_cRouteToID,1,14) = "Security Error" THEN
						MessageBox( gs_AppName, "User "+l_cTferToID+"'s cases are being routed to user "+Mid(l_cRouteToID,17)+".~r~n"+ &
										"User "+Mid(l_cRouteToID,17)+" does not have the proper security level to take this case.", &
										StopSign!, Ok! )
						//Don't continue
						l_nRV = 0
					END IF

					//Check notify flag and strip off end of route to id
					IF Pos( l_cRouteToID, "(" ) > 0 THEN
						SetPointer( Arrow! )
						
						l_cNotify = Mid( l_cRouteToID, Pos( l_cRouteToID, "(" ) )
						l_cRouteToID = Mid( l_cRouteToID, 1, ( Pos( l_cRouteToID, "(" ) - 1 ) )
						
						// Get FullNames for messagebox
						SELECT user_first_name + ' ' + user_last_name INTO :l_cTferToFullName
						  FROM cusfocus.cusfocus_user
						 WHERE user_id = :l_cTferToID
						 USING SQLCA;
						 
						SELECT user_first_name + ' ' + user_last_name INTO :l_cRouteToFullName
						  FROM cusfocus.cusfocus_user
						 WHERE user_id = :l_cRouteToID
						 USING SQLCA;
						 
						//Check to see if transfer to self as a result of routing
						IF l_cRouteToID = l_cTferFromID THEN
							MessageBox( gs_AppName, "You are currently being routed "+l_cTferToFullName+"'s cases.  "+ &
											"You cannot transfer a case to yourself.", Stopsign!, Ok! )
							SetRedraw( TRUE )				
							//Don't continue
							l_nRV = 0
						END IF
			
						IF l_nRV = 1 THEN
							//If set to notify before route, then do so
							IF l_cNotify = "(Y)" THEN
								l_nRV = MessageBox( gs_AppName, l_cTferToFullName+"'s cases are being routed to "+l_cRouteToFullName+"."+ &
														  "~r~nContinue?", Question!, YesNo!, 1 )
							END IF							  
							
							SetPointer( Hourglass! )						  
								
							//Change the transfer to id	
							IF l_nRV = 1 THEN
								l_bChanged = TRUE
								l_cTferToID = l_cRouteToID
							END IF
						END IF
					END IF	
					
					IF l_nRV = 1 THEN
						l_nIDRow = i_dsCusFocusUsers.Find( "user_id = '"+l_cTferToID+"'", 1, i_dsCusFocusUsers.RowCount( ) )
						IF l_nIDRow > 0 THEN
							l_nToConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "confidentiality_level" )
							l_nRepRecConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "rec_confidentiality_level" )
						
							//If changed, means routing.  Need to change the treeviewitem we're pointing to
							IF l_bChanged THEN
								l_nItemHandle = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "treeview_handle" )
								l_tvObject.GetItem( l_nItemHandle, l_tviTferTo )
								l_nTVLevel = l_tviTferTo.Level
								l_nPicIndex = l_tviTferTo.PictureIndex
								
								l_bChanged = FALSE
							END IF
						END IF
					END IF
				ELSE
					EXIT
				END IF
			LOOP UNTIL l_nTVLevel = 1		
			
			//Retract the node if wasn't expanded originally.
			IF NOT l_bExpanded THEN
				l_tviParentItem.Expanded = FALSE
			END IF
			
			IF ( l_nTVLevel <> 1 ) AND &
				( l_nToConfLevel >= i_nRepConfidLevel ) THEN
				THIS.ScrollToRow( l_nRow )
			END IF
			
			l_tvObject.SetRedraw( TRUE )
		END IF
	ELSEIF l_tviTferTo.Level = 2 AND NOT lb_xfer_to_queue THEN
		//If dragged level 2 item and the user isn't out of the office and the
		//  user confidentiality level is greater than or equal to the case confidentiality
		//  level, transfer just the dragged item.
		
		//Get the transfer to user id and the picture index
		l_cTferToID = String( l_tviTferTo.Data )
		l_nPicIndex = l_tviTferTo.PictureIndex
		
		//Check for routing
		l_cRouteToID = PARENT.fw_CheckRoute( l_cTferToID )
		
		IF Mid(l_cRouteToID,1,14) = "Security Error" THEN
			MessageBox( gs_AppName, "User "+l_cTferToID+"'s cases are being routed to user "+Mid(l_cRouteToID,17)+".~r~n"+ &
							"User "+Mid(l_cRouteToID,17)+" does not have the proper security level to take this case.", &
							StopSign!, Ok! )
			//Don't continue
			l_nRV = 0
		END IF
		
		//Check notify flag and strip off end of route to id
		IF Pos( l_cRouteToID, "(" ) > 0 THEN
			SetPointer( Arrow! )
			
			l_cNotify = Mid( l_cRouteToID, Pos( l_cRouteToID, "(" ) )
			l_cRouteToID = Mid( l_cRouteToID, 1, ( Pos( l_cRouteToID, "(" ) - 1 ) )
			
			// Get full names for messagebox
			SELECT user_first_name + ' ' + user_last_name INTO :l_cTferToFullName
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :l_cTferToID
			 USING SQLCA;
			
			SELECT user_first_name + ' ' + user_last_name INTO : l_cRouteToFullName
			  FROM cusfocus.cusfocus_user
			 WHERE user_id = :l_cRouteToID
			 USING SQLCA;

			//Check to see if transfer to self as a result of routing
			IF l_cRouteToID = l_cTferFromID THEN
				MessageBox( gs_AppName, "You are currently being routed "+l_cTferToFullName+"'s cases.  "+ &
								"You cannot transfer a case to yourself.", Stopsign!, Ok! )
				SetRedraw( TRUE )
				//Don't continue
				l_nRV = 0
			END IF
			
			IF l_nRV = 1 THEN
				//If set to notify before route, then do so
				IF l_cNotify = "(Y)" THEN
					l_nRV = MessageBox( gs_AppName, l_cTferToFullName+"'s cases are being routed to "+l_cRouteToFullName+"."+ &
											  "~r~nContinue?", Question!, YesNo!, 1 )
				END IF
												 
				SetPointer( Hourglass! )
										  
				//Change the transfer to ID						  
				IF l_nRV = 1 THEN
					l_bChanged = TRUE
					l_cTferToID = l_cRouteToID
				END IF
			END IF
		END IF
		
		IF l_nRV = 1 THEN
			l_nIDRow = i_dsCusFocusUsers.Find( "user_id = '"+l_cTferToID+"'", 1, i_dsCusFocusUsers.RowCount( ) )
			IF l_nIDRow > 0 THEN
				l_nToConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "confidentiality_level" )
				l_nRepRecConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "rec_confidentiality_level" )
			
				//If changed, means routing.  Need to change the treeviewitem we're pointing to
				IF l_bChanged THEN
					l_nItemHandle = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "treeview_handle" )
					l_tvObject.GetItem( l_nItemHandle, l_tviTferTo )
					l_nPicIndex = l_tviTferTo.PictureIndex
					
					l_bChanged = FALSE
				END IF
			END IF
			
			IF l_nPicIndex <> 3 AND & 
				l_nToConfLevel >= i_nCaseConfidLevel AND &
				( l_nRepRecConfLevel >= i_nRecordConfidLevel OR &
				  IsNull( i_nRecordConfidLevel ) ) AND &
				THIS.Find( "case_transfer_to = '"+l_cTferToID+"'", 1, THIS.RowCount( ) ) < 1 THEN
				
				//Add a row
				l_nRow = THIS.InsertRow( 0 )
				
				//Insert the values
				THIS.Object.case_number[ l_nRow ] = i_cCaseNumber
				
				//Determine if should mark as owner or copy
				IF THIS.Find( "case_transfer_type = 'O'", 1, THIS.RowCount( ) ) = 0 THEN
					THIS.Object.case_transfer_type[ l_nRow ] = "O"
					IF NOT i_bControlsEnabled THEN PARENT.Event Trigger ue_Enable( )
				ELSE
					THIS.Object.case_transfer_type[ l_nRow ] = "C"
				END IF
				THIS.Object.notify_transfer_close[ l_nRow ] = 0
				THIS.Object.case_transfer_from[ l_nRow ] = l_cTferFromID
				THIS.Object.case_transfer_to[ l_nRow ] = l_cTferToID
				THIS.Object.case_transfer_date[ l_nRow ] = l_dtNull
				THIS.Object.treeview_handle[ l_nRow ] = l_nItemHandle
				
				//JWhite	Added 8.1.2006
				SELECT cusfocus.cusfocus_user.user_dept_id  
				  INTO :ls_fromdeptID  
				  FROM cusfocus.cusfocus_user  
				 WHERE cusfocus.cusfocus_user.user_id = :l_cTferFromID   ;
					 
				SELECT cusfocus.cusfocus_user.user_dept_id  
				  INTO :ls_todeptID  
				  FROM cusfocus.cusfocus_user  
				 WHERE cusfocus.cusfocus_user.user_id = :l_cTferToID   ;
					 
				THIS.Object.case_transfer_transfer_to_dept[ l_nRow ] = ls_todeptID
				THIS.Object.case_transfer_transfer_from_dept[ l_nRow ] = ls_fromdeptID
				
				//Change the treeview text
				IF THIS.Object.case_transfer_type[ l_nRow ] = "O" THEN
					l_tvObject.Event Dynamic Trigger ue_ChangeLabel( l_tviTferTo, l_nItemHandle, 0, "(Owner)" )
				ELSE
					l_tvObject.Event Dynamic Trigger ue_ChangeLabel( l_tviTferTo, l_nItemHandle, 0, "(Copy)" )
				END IF
						
				THIS.ScrollToRow( l_nRow )		
			END IF
		END IF
	ELSEIF l_tviTferTo.Level = 2 AND lb_xfer_to_queue AND THIS.RowCount() < 1 THEN // Work Queue
		
		//Get the transfer to user id and the picture index
		l_cTferToID = String( l_tviTferTo.Data )
		l_nPicIndex = l_tviTferTo.PictureIndex
		l_cTferToFullName	= l_tviTferTo.Label
		
		IF l_cTferFromID = l_cTferToID THEN
			IF li_return > 0 THEN
				MessageBox( gs_AppName, "The case already exists in work queue "+l_cTferToFullName+".  ", Stopsign!, Ok! )
				SetRedraw( TRUE )
				//Don't continue
				l_nRV = 0
			END IF
		END IF
		
		IF l_nRV = 1 THEN
			// Add security to work queues
			l_nIDRow = i_dsCusFocusUsers.Find( "user_id = '"+l_cTferToID+"'", 1, i_dsCusFocusUsers.RowCount( ) )
			IF l_nIDRow > 0 THEN
				l_nToConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "confidentiality_level" )
				l_nRepRecConfLevel = i_dsCusFocusUsers.GetItemNumber( l_nIDRow, "rec_confidentiality_level" )
			END IF
			IF l_nToConfLevel >= i_nCaseConfidLevel AND &
				( l_nRepRecConfLevel >= i_nRecordConfidLevel OR &
				  IsNull( i_nRecordConfidLevel ) ) THEN

				//Add a row
				l_nRow = THIS.InsertRow( 0 )
				
				//Insert the values
				THIS.Object.case_number[ l_nRow ] = i_cCaseNumber
				
				//Determine if should mark as owner or copy
				THIS.Object.case_transfer_type[ l_nRow ] = "O"
				THIS.Object.case_transfer_type.Protect = 1
				IF NOT i_bControlsEnabled THEN PARENT.Event Trigger ue_Enable( )
				
				THIS.Object.notify_transfer_close[ l_nRow ] = 0
				THIS.Object.case_transfer_from[ l_nRow ] = l_cTferFromID
				THIS.Object.case_transfer_to[ l_nRow ] = l_cTferToID
				THIS.Object.case_transfer_date[ l_nRow ] = l_dtNull
				THIS.Object.treeview_handle[ l_nRow ] = l_nItemHandle
				
				//JWhite	Added 8.1.2006
				SELECT cusfocus.cusfocus_user.user_dept_id  
				  INTO :ls_fromdeptID  
				  FROM cusfocus.cusfocus_user  
				 WHERE cusfocus.cusfocus_user.user_id = :l_cTferFromID   ;
					 
				SELECT cusfocus.cusfocus_user.user_dept_id  
				  INTO :ls_todeptID  
				  FROM cusfocus.cusfocus_user  
				 WHERE cusfocus.cusfocus_user.user_id = :l_cTferToID   ;
					 
				THIS.Object.case_transfer_transfer_to_dept[ l_nRow ] = ls_todeptID
				THIS.Object.case_transfer_transfer_from_dept[ l_nRow ] = ls_fromdeptID
					
				//Change the treeview text
				IF THIS.Object.case_transfer_type[ l_nRow ] = "O" THEN
					l_tvObject.Event Dynamic Trigger ue_ChangeLabel( l_tviTferTo, l_nItemHandle, 0, "(Owner)" )
				ELSE
					l_tvObject.Event Dynamic Trigger ue_ChangeLabel( l_tviTferTo, l_nItemHandle, 0, "(Copy)" )
				END IF
						
				THIS.ScrollToRow( l_nRow )		
			END IF
		END IF
	END IF
END IF

SetPointer( Arrow! )
SetRedraw( TRUE )
IF IsValid(l_tvObject) THEN l_tvObject.SetRedraw(TRUE)
end event

event pcd_setoptions;call super::pcd_setoptions;/****************************************************************************************
			Event:	pcd_setoptions
		 Purpose:	Event to set options for the datawindow
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/10/2000 K. Claver   Added code to enable drag and drop to the trash can datawindow
**************************************************************************************/
String l_cColumns[ ]
Integer l_nIndex

THIS.fu_SetOptions( SQLCA, & 
						  THIS.c_NullDW, & 
						  THIS.c_DeleteOK+ &
						  THIS.c_DropOK+ &
						  THIS.c_DragOK+ &
						  THIS.c_SelectOnClick+ &
						  THIS.c_ModifyOK+ &
						  THIS.c_ModifyOnOpen+ &
						  THIS.c_SortClickedOK+ &
						  THIS.c_NoEnablePopup+ &
						  THIS.c_NoRetrieveOnOpen )
						  
FOR l_nIndex = 1 TO Integer( THIS.Object.Datawindow.Column.Count )
	l_cColumns[ l_nIndex ] = THIS.Describe( "#"+String( l_nIndex )+".Name" )
NEXT

THIS.fu_WireDrag( l_cColumns, THIS.c_MoveRows, dw_trash ) 

THIS.i_FromEvent = TRUE

IF IsValid (THIS.i_DWSRV_EDIT) THEN	
	THIS.i_DWSRV_EDIT.fu_SetDragIndicator( "editcorrespondence.ico", "editcorrespondence.ico", "editcorrespondence.ico" )
END IF
end event

event pcd_update;call super::pcd_update;/****************************************************************************************
			Event:	pcd_update
		 Purpose:	Update the datawindow
						
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	10/24/2000 K. Claver   Added code to change the case_log_case_rep field in the case_log
								  table.
****************************************************************************************/
Integer l_nOwnerRow
String l_cCaseNumber, l_cNewOwner

IF Error.i_FWError <> c_Fatal THEN
	IF THIS.RowCount( ) > 0 AND THIS.GetNextModified( 0, Primary! ) > 0 THEN
		//Get the owner row and case number and attempt to update the 
		//  case_log_case_rep field
		l_nOwnerRow = THIS.Find( "case_transfer_type = 'O'", 1, THIS.RowCount( ) )
		
		IF l_nOwnerRow > 0 THEN
			i_cTransferTo = THIS.Object.case_transfer_to[ l_nOwnerRow ]
		END IF		
	END IF
END IF
end event

type cb_ok from commandbutton within w_transfer_case
integer x = 1865
integer y = 1924
integer width = 389
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;/***************************************************************************************

	Event:	clicked
	Purpose:	Please see PB documentation for this event
				
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/4/2000 K. Claver    Added code to only save the case transfer datawindow if it is not
								  a new transfer.
	12/7/2000 K. Claver   Added code to refresh the workdesk(if open) after a successful
								 transfer.
	10/3/2001 K. Claver   Changed to use embedded SQL for the select and delete of the current
								 owner row prior to inserting a new one.  This will help to ensure that
								 there is only one owner row after the transfer happens.
	1/2/2002  K. Claver   Moved call to MessageBox to after COMMIT or ROLLBACK to prevent
								 database locks.
	3/7/2002  K. Claver   Moved update to case log case rep to this event as
								 it is part of a successful transfer and should be rolled
								 back with the transaction if the transfer fails.
	9/26/2002 K. Claver   Moved the resetting of the autocommit value to inside the if-then
								 block that initially sets it to ensure that it's set back to the
								 original setting.
****************************************************************************************/
LONG l_nReturn
Integer l_nIndex, l_nNotifyClose, l_nReturnClose, l_nCurrOwnRow = 0, l_nNewOwnRow, l_nRV, l_nRowCount
Integer l_nCloseQuest = 1
DateTime l_dtTferDate, l_dtTferDeadline
String l_cTferNote, l_cTferCode, l_cType, l_cTransferID, l_cOwnerID, l_cCurrentUser, l_cKeyVals[ ]
Boolean l_bAutoCommit
STRING ls_queue_id, ls_send_email, ls_subject
INTEGER li_queue_id

// Get the email flag
ls_send_email = dw_transfer_case.object.case_transfer_email_confirmation[ 1 ]

//Get the current user and timestamp
l_cCurrentUser = OBJCA.WIN.fu_GetLogin( SQLCA )
l_dtTferDate = PARENT.fw_GetTimeStamp( )

//Check for an owner.  If no rows, no need to continue.
IF dw_transfer_history.RowCount( ) > 0 THEN
	l_nNewOwnRow = dw_transfer_history.Find( "case_transfer_type = 'O'", 1, dw_transfer_history.RowCount( ) )
	IF l_nNewOwnRow > 0 THEN
		l_cOwnerID = dw_transfer_history.Object.case_transfer_to[ l_nNewOwnRow ]
	END IF

	//Check for current owners
	SELECT count( * )
	INTO :l_nCurrOwnRow
	FROM cusfocus.case_transfer
	WHERE cusfocus.case_transfer.case_number = :PARENT.i_cCaseNumber AND
			cusfocus.case_transfer.case_transfer_type = 'O'
	USING SQLCA;
	
	IF SQLCA.SQLCode <> 0 THEN
		MessageBox( gs_AppName, "Error determining if there is a current owner of the case.", StopSign!, OK! )
		RETURN
	END IF
	
	//Get key values for the transfers
	IF dw_transfer_history.RowCount( ) > 0 THEN
		FOR l_nIndex = 1 TO dw_transfer_history.RowCount( )
			l_cKeyVals[ l_nIndex ] = PARENT.fw_GetKeyValue( "case_transfer" )	
		NEXT
	END IF
	
	//Store the autocommit value.  Turn off autocommit so can roll back.
	l_bAutoCommit = SQLCA.AutoCommit
	SQLCA.AutoCommit = FALSE

	//If neither contain an owner row, just sending copies
	IF l_nNewOwnRow > 0 AND l_nCurrOwnRow > 0 THEN
		//Check if the current user is the current owner of the case.
		IF Upper( l_cCurrentUser ) = Upper( l_cOwnerID ) AND &
			dw_transfer_case.GetItemStatus( 1, 0, Primary! ) = NotModified! AND &
			dw_transfer_history.ModifiedCount( ) = 0 THEN
			
		ELSE
			//Check confidentiality levels
			IF i_nCaseConfidLevel > i_nRepConfidLevel THEN
				l_nReturn = MessageBox(gs_AppName+" WARNING!", "You are about to transfer a case " + &
								"that has a higher Confidentiality Level than you.  You will no longer be " + &
								"able to access this case.  Do you want to proceed with the Case Transfer?", &
								QUESTION!, YESNO!)
				IF l_nReturn = 2 THEN
					SQLCA.AutoCommit = l_bAutoCommit
					RETURN
				END IF
			END IF
			
			//If have a new owner defined, need to delete the current owner
			//  before save the new owner.
			IF l_nNewOwnRow > 0 AND l_nCurrOwnRow > 0 THEN
				//Delete all of the prior owner rows for this case if a new one is defined.  This
				//  ensures that if there are multiple owner rows, they will all be deleted before
				//  the new one is inserted.
				DELETE cusfocus.case_transfer
				WHERE cusfocus.case_transfer.case_number = :PARENT.i_cCaseNumber AND
						cusfocus.case_transfer.case_transfer_type = 'O'
				USING SQLCA;
				
				IF SQLCA.SQLCode <> 0 THEN
					ROLLBACK USING SQLCA;
					SQLCA.AutoCommit = l_bAutoCommit
					MessageBox( gs_AppName, 'Transfer/Copy unsuccessful for Case # '+PARENT.i_cCaseNumber+'.', StopSign!, OK! )
					RETURN
				END IF		
			END IF
		END IF
	END IF
	
	//Set the information from the transfer case datawindow into the transfer history
	//  datawindow to be saved
	IF dw_transfer_history.RowCount( ) > 0 THEN
		dw_transfer_case.AcceptText( )
		l_cTferNote = dw_transfer_case.Object.case_transfer_notes[ 1 ]
		l_nNotifyClose = dw_transfer_case.Object.notify_originator_close[ 1 ]
		l_nReturnClose = dw_transfer_case.Object.return_for_close[ 1 ]
		l_cTferCode = dw_transfer_case.Object.case_transfer_code[ 1 ]
		l_dtTferDeadline = dw_transfer_case.Object.case_transfer_deadline[ 1 ]
		ls_subject =  dw_transfer_case.Object.case_transfer_subject[ 1 ]
		
		FOR l_nIndex = 1 TO dw_transfer_history.RowCount( )
			IF dw_transfer_history.GetItemStatus( l_nIndex, 0, Primary! ) = New! OR &
				dw_transfer_history.GetItemStatus( l_nIndex, 0, Primary! ) = NewModified! THEN
				//Get a new key value
				l_cTransferID = l_cKeyVals[ l_nIndex ]	
					
				dw_transfer_history.Object.case_transfer_id[ l_nIndex ] = l_cTransferID
			END IF
			
			dw_transfer_history.Object.case_transfer_date[ l_nIndex ] = l_dtTferDate
			IF ib_xfer_from_queue THEN
				dw_transfer_history.Object.case_transfer_from[ l_nIndex ] = PARENT.i_cUserLastName
			ELSE
				dw_transfer_history.Object.case_transfer_from[ l_nIndex ] = l_cCurrentUser
			END IF
			dw_transfer_history.Object.notify_originator_close[ l_nIndex ] = l_nNotifyClose
			dw_transfer_history.Object.return_for_close[ l_nIndex ] = l_nReturnClose
			dw_transfer_history.Object.case_transfer_deadline[ l_nIndex ] = l_dtTferDeadline
			dw_transfer_history.Object.case_transfer_code[ l_nIndex ] = l_cTferCode
			dw_transfer_history.Object.case_transfer_notes[ l_nIndex ] = l_cTferNote
			dw_transfer_history.Object.email_confirmation[ l_nIndex ] = ls_send_email
			dw_transfer_history.Object.subject[ l_nIndex ] = ls_subject
		NEXT
	END IF
	
	//Reset the update status so doesn't attempt to save to the database
	dw_transfer_case.fu_ResetUpdate( )
		
	//Save the history and trash datawindows
	//First, get rid of any rows that might have ended up in the delete buffer
	dw_transfer_history.RowsDiscard( 1, dw_transfer_history.DeletedCount( ), Delete! )
	IF dw_transfer_history.fu_Save(dw_transfer_history.c_SaveChanges) = c_Success THEN		
		IF l_nNewOwnRow = 0 THEN
			//Just copies
			PCCA.Parm[1] = "SUCCESS"
			COMMIT USING SQLCA;
			MessageBox (gs_AppName, 'Transfer/Copy successful for Case # '+PARENT.i_cCaseNumber+'.')
			IF ls_send_email = "Y" THEN
				of_email()
			END IF
		ELSE
			//Update the case log case rep to the new owner
			UPDATE cusfocus.case_log
			SET case_log_case_rep = :PARENT.i_cTransferTo,
				 updated_by = :l_cCurrentUser,
				 updated_timestamp = :l_dtTferDate
			WHERE case_number = :PARENT.i_cCaseNumber
			USING SQLCA;
			
			IF SQLCA.SQLCode <> 0 THEN
				PCCA.Parm[1] = "FAILURE"
				ROLLBACK USING SQLCA;
				SQLCA.AutoCommit = l_bAutoCommit
				MessageBox (gs_AppName, 'Transfer/Copy unsuccessful for Case # '+PARENT.i_cCaseNumber+'.')
				RETURN
			ELSE
				PCCA.Parm[1] = "SUCCESS"
				COMMIT USING SQLCA;
				MessageBox (gs_AppName, 'Transfer/Copy successful for Case # '+PARENT.i_cCaseNumber+'.')
				IF ls_send_email = "Y" THEN
					of_email()
				END IF
			END IF
		END IF	
	ELSE
		PCCA.Parm[1] = "FAILURE"
		ROLLBACK USING SQLCA;
		SQLCA.AutoCommit = l_bAutoCommit
		MessageBox (gs_AppName, "Transfer/Copy unsuccessful for Case # "+PARENT.i_cCaseNumber+".")
		RETURN
	END IF
	
	//Set the autocommit value back
	SQLCA.AutoCommit = l_bAutoCommit
ELSE
	l_nCloseQuest = MessageBox( gs_AppName, "You have not selected a user to transfer~r~n"+ &
										 "or send a copy of this case to.  Exit?", &
										 Question!, YesNo! )
END IF

IF l_nCloseQuest = 1 THEN
	Close( PARENT )
END IF
	
end event

type cb_cancel from commandbutton within w_transfer_case
integer x = 2277
integer y = 1924
integer width = 389
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;/****************************************************************************************

			Event:	clicked
		 Purpose:	User has canceld out of this window.  Set the parm's to empty strings
						and close the window.

****************************************************************************************/
Integer l_nRV

//Make sure changes are in the Primary buffer
dw_transfer_case.AcceptText( )

IF dw_transfer_history.ModifiedCount( ) > 0  OR &
   dw_transfer_case.ModifiedCount( ) > 0 THEN
	l_nRV = MessageBox( gs_AppName, "Changes have not been saved.  Are you sure you wish to cancel?", &
						  	Question!, YesNo! )
							  
	IF l_nRV = 1 THEN						  
  
		PCCA.Parm[1] = ''
		PCCA.Parm[2] = ''
		
		//Cancelling out...not saving.
		dw_transfer_case.fu_ResetUpdate( )
		dw_transfer_history.fu_ResetUpdate( )
		
		Close(Parent)
	END IF
ELSE
	//Cancelling out...not saving.
	dw_transfer_case.fu_ResetUpdate( )
	dw_transfer_history.fu_ResetUpdate( )
	
	PCCA.Parm[1] = ''
	PCCA.Parm[2] = ''
	
	Close(Parent)	
END IF

	

end event

type dw_trash from u_dw_std within w_transfer_case
integer x = 1403
integer y = 1888
integer width = 201
integer height = 168
integer taborder = 60
string dataobject = "d_trash"
boolean border = false
end type

event pcd_setoptions;call super::pcd_setoptions;/****************************************************************************************
			Event:	pcd_setoptions
		 Purpose:	Event to set options for the datawindow
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/10/2000 K. Claver   Added code to enable drag and drop from the transfer history 
								  datawindow
**************************************************************************************/
String l_cColumns[ ]
Integer l_nIndex

THIS.fu_SetOptions( SQLCA, &
					     THIS.c_NullDW, &
						  THIS.c_DropOK+ &
						  THIS.c_DeleteOK+ &
						  THIS.c_DeleteSavedOK )
						  
THIS.i_EnablePopup = FALSE

FOR l_nIndex = 1 TO Integer( THIS.Object.Datawindow.Column.Count )
	l_cColumns[ l_nIndex ] = THIS.Describe( "#"+String( l_nIndex )+".Name" )
NEXT

THIS.fu_WireDrop( l_cColumns ) 
end event

event dragdrop;call super::dragdrop;/****************************************************************************************
			Event:	dragdrop
		 Purpose:	Please see PB documentation for this event
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	10/10/2000 K. Claver   Added code to ask the user if they really want to delete the
								  dragged rows.  If not, restore the rows to the transfer window.
	06/13/03 M. Caruso     Made enable/disable of fields conditional based on i_bControlsEnabled.
**************************************************************************************/
TreeViewItem l_tviNoData
Integer l_nRow, l_nRV = 0, l_nSelectedRow, l_nDelRow[ ], l_nOwnerRow
String l_cTransID
DWItemStatus l_dwisStatus

IF source.TypeOf() = TreeView! THEN
	// do not do anything if the item being dropped is from the TreeView control
	RETURN 0
ELSE
	//Check if any owner rows are left
	l_nOwnerRow = dw_transfer_history.Find( "case_transfer_type = 'O'", 1, dw_transfer_history.RowCount( ) )
	IF l_nOwnerRow = 0 THEN
		dw_transfer_case.AcceptText( )
		l_dwisStatus = dw_transfer_case.GetItemStatus( 1, 0, Primary! )
		IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
			l_nRV = MessageBox( gs_AppName, "You will lose all of your transfer property changes if you set~r~n"+ &
									  "all users as being copied on this case.  Continue?", Question!, YesNo! )
			IF l_nRV = 1 THEN
				dw_transfer_case.fu_Retrieve( dw_transfer_case.c_IgnoreChanges, dw_transfer_case.c_NoReselectRows )	
			END IF
		END IF
		
		IF l_nRV <> 2 THEN
			IF i_bControlsEnabled THEN PARENT.Event Trigger ue_Disable( FALSE )
		END IF
	END IF
	
	IF l_nRV = 0 THEN
		l_nRV = MessageBox( gs_AppName, "Are you sure you want to delete the selected row?", Question!, YesNo! )
	END IF
	
	IF l_nRV = 1 THEN	
		FOR l_nRow = 1 TO THIS.RowCount( )
			tv_tfer_to.Event Trigger ue_changelabel( l_tviNoData, 0, l_nRow, "" )
		NEXT
		
		IF THIS.RowCount( ) > 0 THEN
			//Make sure the transfer id exists
			l_cTransID = THIS.Object.case_transfer_id[ 1 ]
			//Set to datamodified so will actually move to the delete buffer.
			THIS.SetItemStatus( 1, 0, Primary!, DataModified! )
			//Using DeleteRow() as fu_Delete() prompts for delete verification.
			THIS.DeleteRow( 1 )
			
			IF NOT IsNull( l_cTransID ) AND Trim( l_cTransID ) <> "" THEN
				IF THIS.fu_Save( THIS.c_SaveChanges ) <> c_Success THEN
					MessageBox( gs_AppName, "Unable to delete records from the database" )
				END IF
			ELSE
				THIS.RowsDiscard( 1, 1, Delete! )
			END IF
		END IF
	ELSE
		IF THIS.Object.case_transfer_type[ 1 ] = "O" THEN
			IF NOT i_bControlsEnabled THEN PARENT.Event Trigger ue_Enable( )
		END IF
		
		THIS.RowsMove( 1, THIS.RowCount( ), Primary!, dw_transfer_history, &
							( dw_transfer_history.RowCount( ) + 1 ), Primary! )
		dw_transfer_history.ScrollToRow( dw_transfer_history.RowCount( ) )
	END IF
END IF
end event

type ln_1 from line within w_transfer_case
long linecolor = 8421504
integer linethickness = 4
integer beginy = 184
integer endx = 3502
integer endy = 184
end type

type ln_2 from line within w_transfer_case
long linecolor = 16777215
integer linethickness = 4
integer beginy = 188
integer endx = 3502
integer endy = 188
end type

type ln_3 from line within w_transfer_case
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1856
integer endx = 3502
integer endy = 1856
end type

type ln_4 from line within w_transfer_case
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1860
integer endx = 3502
integer endy = 1860
end type

type st_4 from statictext within w_transfer_case
integer y = 1880
integer width = 3502
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217747
boolean focusrectangle = false
end type

