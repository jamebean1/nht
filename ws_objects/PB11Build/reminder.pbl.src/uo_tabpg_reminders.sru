$PBExportHeader$uo_tabpg_reminders.sru
forward
global type uo_tabpg_reminders from u_tabpg_std
end type
type uo_search_reminders from u_search_reminders within uo_tabpg_reminders
end type
type rb_all from radiobutton within uo_tabpg_reminders
end type
type rb_case from radiobutton within uo_tabpg_reminders
end type
type rb_noncase from radiobutton within uo_tabpg_reminders
end type
type dw_reminder_report from datawindow within uo_tabpg_reminders
end type
end forward

global type uo_tabpg_reminders from u_tabpg_std
integer width = 3680
integer height = 1608
string text = "Reminders"
event ue_newreminder ( )
event type integer ue_savereminder ( )
event ue_modifyreminder ( )
event ue_deletereminder ( )
event ue_sortdata ( )
event ue_refresh ( )
event ue_printreport ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
uo_search_reminders uo_search_reminders
rb_all rb_all
rb_case rb_case
rb_noncase rb_noncase
dw_reminder_report dw_reminder_report
end type
global uo_tabpg_reminders uo_tabpg_reminders

type variables
BOOLEAN i_bEnableCalendar
BOOLEAN i_bChangeMode
BOOLEAN i_bNewReminder
BOOLEAN i_bViewMode = TRUE
BOOLEAN i_bNeedRefresh = FALSE

STRING    i_cSaveMessage = "Would you like to Save the Reminders?"

STRING    i_cCaseReminder = "%"
STRING    i_cReminderID
STRING    i_cViewed
STRING    i_cAuthor

uo_tab_workdesk  i_tabParentTab
W_REMINDERS		i_wParentWindow

end variables

forward prototypes
public subroutine fu_calendardisplay (integer a_nrow)
public function boolean fu_checklocked (string a_ccasenumber)
end prototypes

event ue_newreminder();//***********************************************************************************************
//
//  Event:   ue_NewReminder
//  Purpose: Add a new reminder
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************  
Integer l_nReturn
Long ll_row

//l_nReturn = dw_reminder_detail.fu_Save( dw_reminder_detail.c_SaveChanges )
//?? new stuff
l_nReturn = uo_search_reminders.dw_reminder_detail.fu_Save( uo_search_reminders.dw_reminder_detail.c_SaveChanges )

IF l_nReturn < 0 THEN
	Error.i_FWError = uo_search_reminders.dw_reminder_detail.c_Fatal
END IF

//dw_reminder_detail.fu_New( 1 )
//?? new stuff
uo_search_reminders.dw_reminder_detail.fu_New( 1 )





end event

event type integer ue_savereminder();//***********************************************************************************************
//
//  Event:   ue_SaveReminder
//  Purpose: Save the reminder
//  Returns: 0 - Success
//				 -1, -2 - Failure
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  
//***********************************************************************************************  
LONG        l_nRowCount, l_nSelectedRow[], l_nRow
INTEGER		l_nReturn = 0
STRING		l_cReminderID, l_cReminderType, l_cRecipient, l_cFirstName, l_cLastName, l_cFullRecipient

//l_cRecipient = dw_reminder_detail.GetItemString(1,'reminder_recipient')
//
//SELECT user_first_name, user_last_name INTO :l_cFirstName, :l_cLastName FROM 
//		cusfocus.cusfocus_user WHERE user_id =:l_cRecipient
//		USING SQLCA;
//
//l_cFullRecipient = l_cFirstName + ' ' +l_cLastName
//
//i_bNewReminder = TRUE
//l_nReturn = dw_reminder_detail.fu_Save(&
//	dw_reminder_detail.c_SaveChanges)
//
//// Grab the reminder ID for use in scrolling to new row after retrieve
//l_cReminderID = dw_reminder_detail.GetItemString(1,'reminder_id')
//
//IF l_nReturn = 0 THEN
//	dw_reminder_list.fu_Retrieve(&
//		dw_reminder_list.c_IgnoreChanges, &
//		dw_reminder_list.c_ReselectRows)
//		
//	// Scroll to newly added row
//	IF m_cusfocus_reminders.i_bNewReminder THEN
//		l_nSelectedRow[1] = dw_reminder_list.Find("reminder_id = '"+ l_cReminderID +"'", 1, dw_reminder_list.RowCount())
//		IF l_nSelectedRow[1] > 0 THEN
//			dw_reminder_list.fu_SetSelectedRows(1, l_nSelectedRow[], dw_reminder_list.c_IgnoreChanges, dw_reminder_list.c_NoRefreshChildren)
//		END IF
//		m_cusfocus_reminders.i_bNewReminder = FALSE
//	END IF
//	
//	// Determine if the new reminder is for another recipient or 'self'
//	l_nRow = dw_reminder_detail.GetRow()
//	
//
//	// Re-retrieve the reminder detail datawindow
//	l_nRow = dw_reminder_list.GetRow()
//	IF l_nRow <> 0 THEN
//
//		l_cReminderID = dw_reminder_list.GetItemString(l_nRow,'reminder_id')
//				
//		l_nReturn = dw_reminder_detail.Retrieve(l_cReminderID)
//		
//		IF l_nReturn < 0 THEN
//			Error.i_FWError = dw_reminder_detail.c_Fatal
//		ELSE
//			THIS.fu_CalendarDisplay( l_nRow )
//		END IF
//	END IF
//	
//	IF NOT ISNULL(l_cRecipient) THEN
//		
//		IF l_cRecipient <> OBJCA.WIN.fu_GetLogin(SQLCA) THEN
//			messagebox(gs_AppName,'Reminder saved to Work Desk for '+l_cFullRecipient)
//		END IF
//	END IF
//	
//	dw_reminder_list.fu_View()
//	IF i_bNewReminder THEN
//		l_cReminderID = dw_reminder_detail.GetItemString(1,'reminder_id')
//		l_nSelectedRow[1] = dw_reminder_list.Find("reminder_id = '"+ l_cReminderID +"'", 1, dw_reminder_list.RowCount())
//		IF l_nSelectedRow[1] > 0 THEN
//			dw_reminder_detail.fu_SetSelectedRows(1, l_nSelectedRow[], dw_reminder_detail.c_IgnoreChanges, dw_reminder_detail.c_NoRefreshChildren)
//		END IF
//		i_bNewReminder = FALSE
//	END IF
//
//END IF
//
//THIS.i_bViewMode = TRUE

//??? New functionality
l_cRecipient = uo_search_reminders.dw_reminder_detail.GetItemString(uo_search_reminders.dw_reminder_detail.i_CursorRow,'reminder_recipient')

SELECT user_first_name, user_last_name INTO :l_cFirstName, :l_cLastName FROM 
		cusfocus.cusfocus_user WHERE user_id =:l_cRecipient
		USING SQLCA;

l_cFullRecipient = l_cFirstName + ' ' +l_cLastName

i_bNewReminder = TRUE
l_nReturn = uo_search_reminders.dw_reminder_detail.fu_Save(&
	uo_search_reminders.dw_reminder_detail.c_SaveChanges)

// Grab the reminder ID for use in scrolling to new row after retrieve
l_cReminderID = uo_search_reminders.dw_reminder_detail.GetItemString(uo_search_reminders.dw_reminder_detail.i_CursorRow,'reminder_id')

uo_search_reminders.dw_report.Retrieve(i_cAuthor, i_cCaseReminder)
	
// Scroll to newly added row
IF i_bNewReminder THEN
	l_nSelectedRow[1] = uo_search_reminders.dw_report.Find("reminder_id = '"+ l_cReminderID +"'", 1, uo_search_reminders.dw_report.RowCount())
	IF l_nSelectedRow[1] > 0 THEN
		uo_search_reminders.dw_report.SetRow(l_nSelectedRow[1])
		uo_search_reminders.dw_report.ScrollToRow(l_nSelectedRow[1])
//		uo_search_reminders.dw_report.SelectRow(0, FALSE)
//		uo_search_reminders.dw_report.SelectRow(l_nSelectedRow[1], TRUE)
	END IF
	i_bNewReminder = FALSE
END IF

// Determine if the new reminder is for another recipient or 'self'
l_nRow = uo_search_reminders.dw_reminder_detail.GetRow()


// Re-retrieve the reminder detail datawindow
l_nRow = uo_search_reminders.dw_report.GetRow()
IF l_nRow <> 0 THEN

	l_cReminderID = uo_search_reminders.dw_report.GetItemString(l_nRow,'reminder_id')
			
	l_nReturn = uo_search_reminders.dw_reminder_detail.Retrieve(l_cReminderID)
	
	IF l_nReturn < 0 THEN
		Error.i_FWError = uo_search_reminders.dw_reminder_detail.c_Fatal
	ELSE
		THIS.fu_CalendarDisplay( l_nRow )
	END IF
END IF

IF NOT ISNULL(l_cRecipient) THEN
	
	IF l_cRecipient <> OBJCA.WIN.fu_GetLogin(SQLCA) THEN
		messagebox(gs_AppName,'Reminder saved to Work Desk for '+l_cFullRecipient)
	END IF
END IF

//??? what is this?	dw_reminder_list.fu_View()
IF i_bNewReminder THEN
	//??? what is this doing?
//???		l_cReminderID = uo_search_reminders.dw_reminder_detail.GetItemString(1,'reminder_id')
//???		l_nSelectedRow[1] = uo_search_reminders.dw_report.Find("reminder_id = '"+ l_cReminderID +"'", 1, uo_search_reminders.dw_report.RowCount())
//???		IF l_nSelectedRow[1] > 0 THEN
//???			uo_search_reminders.dw_reminder_detail.fu_SetSelectedRows(1, l_nSelectedRow[], dw_reminder_detail.c_IgnoreChanges, dw_reminder_detail.c_NoRefreshChildren)
//???		END IF
	i_bNewReminder = FALSE
END IF


THIS.i_bViewMode = TRUE



RETURN l_nReturn
end event

event ue_modifyreminder();//***********************************************************************************************
//
//  Event:   ue_ModifyReminder
//  Purpose: Modify a reminder
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  3/13/2002  K. Claver   Added condition to check if the reminder is a case reminder.  Then, check
//                         if the case is locked before allow to modify.
//***********************************************************************************************  
String l_cCaseNumber
Long ll_return

//IF dw_reminder_list.RowCount() = 0 THEN
//	MessageBox(gs_AppName, "There are no rows to modify.")
//ELSE
//	//Get the case number from the record.  If a case related reminder, check if case locked
//	//  before allowing to delete.
//	l_cCaseNumber = dw_reminder_detail.Object.case_number[ 1 ]
//	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
//		IF THIS.fu_CheckLocked( l_cCaseNumber ) THEN
//			RETURN
//		END IF
//	END IF
//	
//	dw_reminder_detail.fu_Modify()
//END IF	

//??? New functionality
IF uo_search_reminders.dw_report.RowCount() = 0 THEN
	MessageBox(gs_AppName, "There are no rows to modify.")
ELSE
	//Get the case number from the record.  If a case related reminder, check if case locked
	//  before allowing to delete.
	l_cCaseNumber = uo_search_reminders.dw_report.Object.case_number[ 1 ]
	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
		IF THIS.fu_CheckLocked( l_cCaseNumber ) THEN
			RETURN
		END IF
	END IF
	
	uo_search_reminders.dw_reminder_detail.fu_Modify()
	uo_search_reminders.dw_reminder_detail.enabled = TRUE
END IF	
end event

event ue_deletereminder();//***********************************************************************************************
//
//  Event:   ue_DeleteReminder
//  Purpose: Delete a reminder
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  12/13/2001 K. Claver   Removed dependency on instance array of dates.  Now loads dates into
//								   the calendar after switch the month or year as loading all on the initial
//								   retrieve could take quite a while. 
//  3/13/2002  K. Claver   Added condition to check if the reminder is a case reminder.  Then, check
//                         if the case is locked before allow to delete.
//***********************************************************************************************  
INT                    l_nReturn
LONG						  l_Rows[]
STRING					  l_cCaseNumber

//IF dw_reminder_list.RowCount( ) = 0 THEN
//	MessageBox( gs_AppName, "There are no rows to delete.", StopSign!, OK! )
//ELSE
//	//Get the case number from the record.  If a case related reminder, check if case locked
//	//  before allowing to delete.
//	l_cCaseNumber = dw_reminder_detail.Object.case_number[ 1 ]
//	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
//		IF THIS.fu_CheckLocked( l_cCaseNumber ) THEN
//			RETURN
//		END IF
//	END IF	
//	
//	l_nReturn = MessageBox( gs_AppName, "Are you sure you want to delete this Reminder?", &
//									Question!, YesNo! )
//	
//	IF l_nReturn = 1 THEN
//		THIS.SetRedraw(FALSE)
//			
//		l_Rows[1] = dw_reminder_detail.i_CursorRow
//		dw_reminder_detail.fu_Delete(1, &
//											  l_Rows[], &
//											  dw_reminder_detail.c_IgnoreChanges)
//		
//		dw_reminder_detail.fu_Save(dw_reminder_detail.c_SaveChanges)
//		
//		
//		IF dw_reminder_detail.RowCount() > 0 THEN
//			dw_reminder_list.fu_Retrieve(dw_reminder_list.c_IgnoreChanges, &
//												  dw_reminder_list.c_NoReselectRows)
//												  dw_reminder_list.fu_View()
//		ELSE
//			dw_reminder_detail.fu_New(1)	
//		
//		END IF
//		
//		THIS.SetRedraw(TRUE)
//	END IF
//END IF

//??? New Functionality
IF uo_search_reminders.dw_report.RowCount( ) = 0 THEN
	MessageBox( gs_AppName, "There are no rows to delete.", StopSign!, OK! )
ELSE
	//Get the case number from the record.  If a case related reminder, check if case locked
	//  before allowing to delete.
	l_cCaseNumber = uo_search_reminders.dw_reminder_detail.Object.case_number[ 1 ]
	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
		IF THIS.fu_CheckLocked( l_cCaseNumber ) THEN
			RETURN
		END IF
	END IF	
	
	l_nReturn = MessageBox( gs_AppName, "Are you sure you want to delete this Reminder?", &
									Question!, YesNo! )
	
	IF l_nReturn = 1 THEN
		THIS.SetRedraw(FALSE)
			
		l_Rows[1] = uo_search_reminders.dw_reminder_detail.i_CursorRow
		uo_search_reminders.dw_reminder_detail.fu_Delete(1, &
											  l_Rows[], &
											  uo_search_reminders.dw_reminder_detail.c_IgnoreChanges)
		
		uo_search_reminders.dw_reminder_detail.fu_Save(uo_search_reminders.dw_reminder_detail.c_SaveChanges)
		
		
		uo_search_reminders.dw_report.Retrieve(i_cAuthor, i_cCaseReminder)
		IF uo_search_reminders.dw_reminder_detail.RowCount() = 0 THEN
			uo_search_reminders.dw_reminder_detail.fu_New(1)	
		END IF
		
		THIS.SetRedraw(TRUE)
	END IF
END IF


end event

event ue_sortdata();////********************************************************************************************
////
////  Function:		ue_sortdata
////  Description:	To sort both the Reminders and Case List Datawindows
////  
////  Date     Developer   Description
////  -------- ----------- ---------------------------------------------------------------------
////  04/03/00 C. Jackson  Changed dynamic building of sort of second datawindow (dw_case_list)
////                       to hardcoded.  The dynamic sort apparently doesn't work when there
////                       are 2 datawindows to sort.  (SCR 475)
////	 10/20/2000 K. Claver Moved from w_reminders.  Used to be fw_SortData
////							  
////********************************************************************************************							  
//
//INT				l_nCounter, l_nAnotherCounter, l_nColumnCount
//LONG				l_nSortError
//S_ColumnSort	l_sSortData
//STRING 			l_cTag, l_cSortString
//
//l_nAnotherCounter = 1
//
////Add the numeric version of the case number
//l_sSortData.label_name[l_nAnotherCounter] = dw_reminder_list.Describe(&
//		"numeric_casenum.Tag")
//
//l_sSortData.column_name[l_nAnotherCounter] = 'numeric_casenum'
//
////Add the author computed column
//l_nAnotherCounter ++
//
//l_sSortData.label_name[l_nAnotherCounter] = dw_reminder_list.Describe(&
//		"cc_reminder_author.Tag")
//
//l_sSortData.column_name[l_nAnotherCounter] = 'cc_reminder_author'
//
////Add the rest
//l_nColumnCount = LONG(dw_reminder_list.Describe("Datawindow.Column.Count")) 
//
//FOR l_nCounter = 1 to l_nColumnCount
//
//		l_cTag = dw_reminder_list.Describe("#" + String(l_nCounter) + ".Tag")
//
//		IF l_cTag <> '?' THEN
//			l_nAnotherCounter ++
//			l_sSortData.label_name[l_nAnotherCounter]  = l_cTag
//			l_sSortData.column_name[l_nAnotherCounter] = dw_reminder_list.Describe(&
//				"#" + String(l_nCounter) + ".Name")
//		END IF
//NEXT
//
//FWCA.MGR.fu_OpenWindow(w_sort_order, 0, l_sSortData)
//
//l_cSortString = Message.StringParm
//
//IF l_cSortString <> '' THEN
//	l_nSortError = dw_reminder_list.SetSort(l_cSortString)
//	l_nSortError = dw_reminder_list.Sort()
//END IF
//		
////??? for new functionality
//	//??? This is going to need some reworking. Need numeric case number
//	
end event

event ue_refresh();//***********************************************************************************************
//
//  Event:   ue_Refresh
//  Purpose: Refresh the data
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//  07/08/03 M. Caruso     Changed the options of fu_retrieve to include c_NoReselectRows so that
//									the child datawindow will update as well. Then added code to manually
//									reselect the previous row if possible.
//***********************************************************************************************

LONG		l_nNewRow, ll_currentrow
STRING	l_cOldID

IF THIS.i_bNeedRefresh THEN
	THIS.i_tabParentTab.SetRedraw( FALSE )
	
	// prepare to reselect the currently selected row.
//	IF dw_reminder_list.i_CursorRow > 0 THEN
//		l_cOldID = dw_reminder_list.GetItemString (dw_reminder_list.i_CursorRow, 'reminder_id')
//	END IF
//???
	// prepare to reselect the currently selected row.
	ll_currentrow = uo_search_reminders.dw_report.GetRow()
	IF ll_currentrow > 0 THEN
		l_cOldID = uo_search_reminders.dw_report.GetItemString (ll_currentrow, 'reminder_id')
	END IF
	
//???
	// this must pass c_NoRwselectRows to have the child update if no rows are returned.
	uo_search_reminders.dw_report.Retrieve(OBJCA.WIN.fu_GetLogin(SQLCA), THIS.i_cCaseReminder)

	// this must pass c_NoRwselectRows to have the child update if no rows are returned.
//	dw_reminder_list.fu_Retrieve( dw_reminder_list.c_PromptChanges, &
//											dw_reminder_list.c_NoReselectRows )
//

	//Refreshed.  Reset Variable.
	THIS.i_bNeedRefresh = FALSE
	
	// reselect the previously selected row if it is still in the result set.
//	IF dw_reminder_list.RowCount() > 0 AND l_cOldID <> "" THEN
//		
//		l_nNewRow = dw_reminder_list.Find ('reminder_id = ~'' + l_cOldID + '~'', 1, dw_reminder_list.RowCount())
//		IF l_nNewRow > 1 THEN
//			dw_reminder_list.SelectRow (1, FALSE)
//			dw_reminder_list.SetRow (l_nNewRow)
//			dw_reminder_list.SelectRow (l_nNewRow, TRUE)
//		END IF
//		
//	END IF

//???
	// reselect the previously selected row if it is still in the result set.
	IF uo_search_reminders.dw_report.RowCount() > 0 AND l_cOldID <> "" THEN
		
		l_nNewRow = uo_search_reminders.dw_report.Find ('reminder_id = ~'' + l_cOldID + '~'', 1, uo_search_reminders.dw_report.RowCount())
		IF l_nNewRow > 1 THEN
			uo_search_reminders.dw_report.SelectRow (1, FALSE)
			uo_search_reminders.dw_report.SetRow (l_nNewRow)
			uo_search_reminders.dw_report.SelectRow (l_nNewRow, TRUE)
		END IF
		
	END IF
	
	THIS.i_tabParentTab.SetRedraw( TRUE )
END IF


end event

event ue_printreport();/**************************************************************************************

		Event:	pc_print
		Purpose:	To print the Reminders report.

**************************************************************************************/

//------------------------------------------------------------------------------------
//
//		If there are no Reminders to print inform the user.
//
//------------------------------------------------------------------------------------

//??? new functionality
IF uo_search_reminders.dw_report.RowCount() = 0 THEN
	Messagebox(gs_AppName, 'There are no Reminders to generate the Reminder Report.')
	RETURN
END IF

//------------------------------------------------------------------------------------
//
//		Set the Transaction object for the Report data window, retrieve and print.
//
//------------------------------------------------------------------------------------
i_cReminderID = uo_search_reminders.dw_reminder_detail.GetItemString(uo_search_reminders.dw_reminder_detail.i_CursorRow,'reminder_id')

SetPointer(HOURGLASS!)
dw_reminder_report.SetTransObject(SQLCA)
dw_reminder_report.Retrieve(i_cReminderID)
dw_reminder_report.Print()
SetPointer(Arrow!)
end event

event ue_setmainfocus();//***********************************************************************************************
//
//  Event:   ue_SetMainFocus
//  Purpose: Set Focus to the main datawindow
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
//THIS.dw_reminder_list.SetFocus( )

//??? New functionality
uo_search_reminders.dw_report.SetFocus()
end event

event ue_setneedrefresh;//***********************************************************************************************
//
//  Event:   ue_SetNeedRefresh
//  Purpose: Set variable to indicate that this tab needs to be refreshed when selected
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
THIS.i_bNeedRefresh = TRUE
end event

public subroutine fu_calendardisplay (integer a_nrow);//**********************************************************************************************
//
//  Function: fu_calendardisplay
//  Purpose:  Update the calendar object based on the current row
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/17/01 C. Jackson  Original Version
//  12/13/2001 K. Claver Changed to pass the row in rather than using the GetRow method.
//  
//**********************************************************************************************
Datetime l_dtReminderDate
Long l_nMonth, l_nYear

//IF a_nRow > 0 THEN
//	l_dtReminderDate = dw_reminder_list.GetItemDateTime( a_nRow, "reminder_set_date" )
//	
//	l_nMonth = Month( Date( l_dtReminderDate ) )
//	l_nYear = Year( Date( l_dtReminderDate ) )
//	
//	dw_calendar.fu_CalSetMonth( l_nMonth, l_nYear )
//END IF

//??? New functionality
IF a_nRow > 0 THEN
	l_dtReminderDate = uo_search_reminders.dw_report.GetItemDateTime( a_nRow, "reminder_set_date" )
	
	l_nMonth = Month( Date( l_dtReminderDate ) )
	l_nYear = Year( Date( l_dtReminderDate ) )
	
	uo_search_reminders.dw_calendar.fu_CalSetMonth( l_nMonth, l_nYear )
END IF
end subroutine

public function boolean fu_checklocked (string a_ccasenumber);/*****************************************************************************************
   Function:   fu_CheckLocked
   Purpose:    Check if the passed case is locked
   Parameters: STRING - a_cCaseNumber - Number of the case to check
   Returns:    BOOLEAN - TRUE - Case locked by someone else
								 FALSE - Case not locked by someone else
   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	3/12/2002 K. Claver   Created.
	09/02/2004 K. Claver  Modified locked case message to inform the user that they can
								 add certain things to the case, but they cannot edit.
*****************************************************************************************/
Boolean l_bRV = FALSE
DateTime l_dtLockedDate
String l_cLockedBy

IF NOT IsNull( a_cCaseNumber ) AND Trim( a_cCaseNumber ) <> "" THEN	
	SELECT locked_by, locked_timestamp
	INTO :l_cLockedBy, :l_dtLockedDate
	FROM cusfocus.case_locks
	WHERE case_number = :a_cCaseNumber
	USING SQLCA;
	
	CHOOSE CASE SQLCA.SQLCode
		CASE -1
			MessageBox( gs_AppName, "Error determining lock status for the case."+ &
						" You will not be able to edit this case", StopSign!, OK! )
			l_bRV = TRUE
		CASE 0
			IF Upper( Trim( l_cLockedBy ) ) <> Upper( Trim( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
				MessageBox( gs_AppName, "This case is currently in use by "+l_cLockedBy+" since "+&
									String( l_dtLockedDate, "mm/dd/yyyy hh:mm:ss" )+".~r~n"+ &
									"You will only be able to add notes, attachments, correspondence,~r~n"+ &
									"contacts and reminders to this case.  No other edits are allowed", Information!, OK! )
				
				l_bRV = TRUE
			ELSE
				l_bRV = FALSE
			END IF
		CASE ELSE
			//SQLCA.SQLCode = 100 = No lock record found
	END CHOOSE
END IF

RETURN l_bRV
end function

on uo_tabpg_reminders.create
int iCurrent
call super::create
this.uo_search_reminders=create uo_search_reminders
this.rb_all=create rb_all
this.rb_case=create rb_case
this.rb_noncase=create rb_noncase
this.dw_reminder_report=create dw_reminder_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search_reminders
this.Control[iCurrent+2]=this.rb_all
this.Control[iCurrent+3]=this.rb_case
this.Control[iCurrent+4]=this.rb_noncase
this.Control[iCurrent+5]=this.dw_reminder_report
end on

on uo_tabpg_reminders.destroy
call super::destroy
destroy(this.uo_search_reminders)
destroy(this.rb_all)
destroy(this.rb_case)
destroy(this.rb_noncase)
destroy(this.dw_reminder_report)
end on

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   Constructor
//  Purpose: please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/24/2000 K. Claver   Added code to activate the resize service and register the objects
//***********************************************************************************************
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
//	THIS.inv_resize.of_Register( gb_1, THIS.inv_resize.SCALERIGHTBOTTOM )
//	THIS.inv_resize.of_Register( dw_reminder_list, THIS.inv_resize.SCALERIGHTBOTTOM )
//	THIS.inv_resize.of_Register( gb_2, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
//	THIS.inv_resize.of_Register( dw_reminder_detail, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
//	THIS.inv_resize.of_Register( dw_calendar, THIS.inv_resize.FIXEDRIGHTBOTTOM )
	THIS.inv_resize.of_Register( uo_search_reminders, THIS.inv_resize.SCALERIGHTBOTTOM )
END IF

uo_search_reminders.of_set_parent(THIS)
i_cAuthor = OBJCA.WIN.fu_GetLogin( SQLCA )


end event

type uo_search_reminders from u_search_reminders within uo_tabpg_reminders
integer x = 9
integer y = 80
integer taborder = 30
end type

on uo_search_reminders.destroy
call u_search_reminders::destroy
end on

type rb_all from radiobutton within uo_tabpg_reminders
integer x = 82
integer y = 4
integer width = 453
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "All"
boolean checked = true
end type

event clicked;/****************************************************************************************

		Event: 		clicked
		Purpose:		To retrieve All reminders.

***************************************************************************************/

i_cCaseReminder = '%'
//dw_reminder_list.fu_Retrieve(dw_reminder_list.c_IgnoreChanges, &		
//									  dw_reminder_list.c_NoReselectRows)
//dw_reminder_list.fu_View()

IF i_cAuthor = '' THEN
	i_cAuthor = OBJCA.WIN.fu_GetLogin( SQLCA )
END IF
uo_search_reminders.dw_report.retrieve(i_cAuthor, i_cCaseReminder)

//dw_reminder_detail.Enabled = TRUE
m_cusfocus_reminders.m_file.m_newreminder.Enabled = TRUE

end event

type rb_case from radiobutton within uo_tabpg_reminders
integer x = 718
integer y = 4
integer width = 539
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Case Related"
end type

event clicked;/****************************************************************************************

		Event: 		clicked
		Purpose:		To retrieve only Case Reminders.  Disable the New Reminder menu.

***************************************************************************************/

i_cCaseReminder = 'Y'

//dw_reminder_list.fu_Retrieve(dw_reminder_list.c_IgnoreChanges, &		
//									  dw_reminder_list.c_NoReselectRows)
//dw_reminder_list.fu_View()

IF i_cAuthor = '' THEN
	i_cAuthor = OBJCA.WIN.fu_GetLogin( SQLCA )
END IF
uo_search_reminders.dw_report.retrieve(i_cAuthor, i_cCaseReminder)

//dw_reminder_detail.Enabled = TRUE
m_cusfocus_reminders.m_file.m_newreminder.Enabled = TRUE

end event

type rb_noncase from radiobutton within uo_tabpg_reminders
integer x = 1403
integer y = 4
integer width = 635
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79748288
string text = "Non-Case Related"
end type

event clicked;/****************************************************************************************

		Event: 		clicked
		Purpose:		To retrieve NON CASE reminders.

***************************************************************************************/

i_cCaseReminder = 'N'
//dw_reminder_list.fu_Retrieve(dw_reminder_list.c_IgnoreChanges, &		
//									  dw_reminder_list.c_NoReselectRows)
//dw_reminder_list.fu_View()

IF i_cAuthor = '' THEN
	i_cAuthor = OBJCA.WIN.fu_GetLogin( SQLCA )
END IF
uo_search_reminders.dw_report.retrieve(i_cAuthor, i_cCaseReminder)

//dw_reminder_detail.Enabled = TRUE
m_cusfocus_reminders.m_file.m_newreminder.Enabled = TRUE

end event

type dw_reminder_report from datawindow within uo_tabpg_reminders
boolean visible = false
integer x = 457
integer y = 424
integer width = 411
integer height = 432
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_reminder_detail_report"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;IF gs_AppName <> "" AND THIS.DataObject = "d_reminder_detail_report" THEN
	THIS.Object.t_2.text = gs_AppName
END IF
end event

