$PBExportHeader$uo_tab_workdesk.sru
forward
global type uo_tab_workdesk from u_tab_std
end type
type tabpage_opencases from uo_tabpg_opencases within uo_tab_workdesk
end type
type tabpage_opencases from uo_tabpg_opencases within uo_tab_workdesk
end type
type tabpage_reminders from uo_tabpg_reminders within uo_tab_workdesk
end type
type tabpage_reminders from uo_tabpg_reminders within uo_tab_workdesk
end type
type tabpage_appeal from uo_tabpg_appeals within uo_tab_workdesk
end type
type tabpage_appeal from uo_tabpg_appeals within uo_tab_workdesk
end type
type tabpage_workqueues from uo_tabpg_workqueues within uo_tab_workdesk
end type
type tabpage_workqueues from uo_tabpg_workqueues within uo_tab_workdesk
end type
type tabpage_work_tracker from uo_tabpg_work_tracker within uo_tab_workdesk
end type
type tabpage_work_tracker from uo_tabpg_work_tracker within uo_tab_workdesk
end type
end forward

global type uo_tab_workdesk from u_tab_std
integer width = 3630
integer height = 1844
integer textsize = -8
string facename = "Tahoma"
boolean fixedwidth = true
boolean raggedright = false
boolean boldselectedtext = true
alignment alignment = center!
tabpage_opencases tabpage_opencases
tabpage_reminders tabpage_reminders
tabpage_appeal tabpage_appeal
tabpage_workqueues tabpage_workqueues
tabpage_work_tracker tabpage_work_tracker
event ue_newreminder ( )
event ue_savereminder ( )
event ue_modifyreminder ( )
event ue_sortdata ( )
event ue_refresh ( )
event ue_printreport ( )
event ue_deletecopy ( )
event ue_delete ( )
event ue_enablemenuitems ( boolean a_benable )
end type
global uo_tab_workdesk uo_tab_workdesk

type variables
W_REMINDERS		i_wParentWindow
STRING i_cCaseNumber
STRING i_cReminderID
LONG i_nCurrentTab

string	is_using_new_appeals
string	is_using_fax
end variables

forward prototypes
public subroutine of_check_appeal_setting ()
public subroutine of_check_fax_setting ()
end prototypes

event ue_newreminder;//***********************************************************************************************
//
//  Event:   ue_NewReminder
//  Purpose: Trigger the event(s) on the tabpage to add a new reminder
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************  
tabpage_reminders.Event Trigger ue_NewReminder( )
end event

event ue_savereminder;//***********************************************************************************************
//
//  Event:   ue_SaveReminder
//  Purpose: Trigger the event(s) on the tabpage to save a reminder
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************  
tabpage_reminders.Event Trigger ue_SaveReminder( )
THIS.Event Trigger ue_EnableMenuItems( TRUE )
end event

event ue_modifyreminder;//***********************************************************************************************
//
//  Event:   ue_ModifyReminder
//  Purpose: Trigger the event(s) to modify a reminder
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************  
tabpage_reminders.Event Trigger ue_ModifyReminder( )
end event

event ue_sortdata;//***********************************************************************************************
//
//  Event:   ue_SortData
//  Purpose: Trigger the event(s) on the tabpage to sort the reminders
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************  
tabpage_reminders.Event Trigger ue_SortData( )
end event

event ue_refresh();//***********************************************************************************************
//
//  Event:   ue_Refresh
//  Purpose: Trigger the event(s) on the tabpage(s) to refresh the workdesk
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//  10/26/2000 M. Caruso   Added code to set the rep confidentiality level on the parent window.
//  6/27/2001  K. Claver   Added event call to reset the refresh variable and timer on the workdesk
//									window.
//  9/20/2002  K. Claver   Changed to only refresh the current tab
//***********************************************************************************************  
U_TABPG_STD	l_uoTabPage
INTEGER		l_nIndex
STRING		l_cUserID

// update the rep confidentiality level for this window.
l_cUserID = OBJCA.WIN.fu_GetLogin( SQLCA )
SELECT confidentiality_level INTO :i_wParentWindow.i_nRepConfidLevel
  FROM cusfocus.cusfocus_user WHERE user_id = :l_cUserID USING SQLCA;

FOR l_nIndex = 1 TO UpperBound( THIS.Control )
	IF THIS.Control[ l_nIndex ].TypeOf( ) = UserObject! THEN
		//Notify the tab that it needs to be refreshed
		THIS.Control[ l_nIndex ].Event Dynamic Trigger ue_SetNeedRefresh( )
		
		IF l_nIndex = THIS.SelectedTab THEN
			//Refresh the current tab
			THIS.Control[ l_nIndex ].Event Dynamic Trigger ue_Refresh( )
		END IF
	END IF
NEXT

//Reset the refresh variables on the parent
i_wParentWindow.Event Trigger ue_ResetRefresh( )


end event

event ue_printreport;//***********************************************************************************************
//
//  Event:   ue_PrintReport
//  Purpose: Trigger the event(s) on the tabpage to print a reminder report
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************  
tabpage_reminders.Event Trigger ue_PrintReport( )
end event

event ue_deletecopy();//***********************************************************************************************
//
//  Event:   ue_DeleteCopy
//  Purpose: Trigger the event(s) on the inbox tabpage to delete highlighted copy rows
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//  4/4/2001   K. Claver   Added code to allow deletions of copies from the expired cases tab.
//***********************************************************************************************  
Integer l_nSelectedRow

IF THIS.SelectedTab = 1 THEN
	tabpage_opencases.Event Trigger ue_DeleteCopy( )	
	
END IF

IF tabpage_opencases.uo_search_open_cases.dw_report.RowCount( ) > 0 THEN
	l_nSelectedRow = tabpage_opencases.uo_search_open_cases.dw_report.GetRow(  )
	IF l_nSelectedRow > 0 THEN
		IF tabpage_opencases.uo_search_open_cases.dw_report.Object.case_transfer_type[ l_nSelectedRow ] = "C" THEN
			m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
		ELSE
			m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
		END IF
	ELSE
		m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
	END IF
ELSE
	m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
END IF
end event

event ue_delete();//***********************************************************************************************
//
//  Event:   ue_Delete
//  Purpose: Trigger the event(s) on the appropriate tabpage to delete
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************
IF THIS.SelectedTab = 1 THEN
	tabpage_opencases.Event Trigger ue_DeleteCopy( )
ELSEIF THIS.SelectedTab = 2 THEN
	tabpage_reminders.Event Trigger ue_DeleteReminder( )
ELSEIF THIS.SelectedTab = 4 THEN
	tabpage_workqueues.Event Trigger ue_DeleteFax( )
ELSEIF THIS.SelectedTab = 5 THEN
	tabpage_work_tracker.Event Trigger ue_Delete_work_tracker( )
END IF
end event

event ue_enablemenuitems(boolean a_benable);/**************************************************************************************

			Event:	ue_enablemenuitems
			Purpose:	To enable/disable menu items for reminders

*************************************************************************************/
Integer l_nSelectedRow

IF a_bEnable THEN
	m_cusfocus_reminders.m_file.m_newreminder.Enabled = TRUE
	m_cusfocus_reminders.m_file.m_savereminder.Enabled = TRUE
	IF tabpage_reminders.uo_search_reminders.dw_report.RowCount( ) > 0 THEN
		m_cusfocus_reminders.m_file.m_print.Enabled = TRUE
		m_cusfocus_reminders.m_edit.m_modifyreminder.Enabled = TRUE
		m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
		m_cusfocus_reminders.m_edit.m_sort.Enabled = TRUE
	END IF
	
	IF THIS.SelectedTab <> 1 And  THIS.SelectedTab <> 4 And  THIS.SelectedTab <> 5 THEN
		m_cusfocus_reminders.m_edit.m_deletereminder.text = "&Delete Reminder"
		m_cusfocus_reminders.m_edit.m_deletereminder.toolbaritemtext = "Delete Reminder"
		m_cusfocus_reminders.m_edit.m_deletereminder.MicroHelp = "Deletes the selected Reminder"	
	ELSE
		IF THIS.SelectedTab = 1 THEN
			
			IF tabpage_opencases.uo_search_open_cases.dw_report.RowCount( ) > 0 THEN
				l_nSelectedRow = tabpage_opencases.uo_search_open_cases.dw_report.GetRow( )
				IF l_nSelectedRow > 0 THEN
					IF tabpage_opencases.uo_search_open_cases.dw_report.Object.case_transfer_type[ l_nSelectedRow ] = "C" THEN
						m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
					ELSE
						m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
					END IF
				ELSE
					m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
				END IF
			ELSE
				m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
			END IF
		END IF
	END IF
ELSE
	m_cusfocus_reminders.m_file.m_newreminder.Enabled = FALSE
	m_cusfocus_reminders.m_file.m_savereminder.Enabled = FALSE
	m_cusfocus_reminders.m_file.m_print.Enabled = FALSE
	m_cusfocus_reminders.m_edit.m_modifyreminder.Enabled = FALSE
	
	IF THIS.SelectedTab <> 1 THEN
		IF THIS.SelectedTab = 4 THEN	
			m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
			m_cusfocus_reminders.m_edit.m_deletereminder.text = "&Delete Fax"
			m_cusfocus_reminders.m_edit.m_deletereminder.toolbaritemtext = "Delete Fax"
			m_cusfocus_reminders.m_edit.m_deletereminder.MicroHelp = "Deletes the selected Fax"	
// Taken out to prevent triple retrieve.
// Voided and closed cases still disappear and cases
// transferred into a work queue still show up.
//			tabpage_workqueues.i_bNeedRefresh = TRUE
//			tabpage_workqueues.EVENT ue_refresh()
		ELSEIF THIS.SelectedTab = 5 THEN	
			m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
			m_cusfocus_reminders.m_edit.m_deletereminder.text = "&Delete Work Dashboard"
			m_cusfocus_reminders.m_edit.m_deletereminder.toolbaritemtext = "Delete Work Dashboard"
			m_cusfocus_reminders.m_edit.m_deletereminder.MicroHelp = "Deletes the selected Work Dashboard"	
		ELSE
			m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
			m_cusfocus_reminders.m_edit.m_deletereminder.text = "&Delete Reminder"
			m_cusfocus_reminders.m_edit.m_deletereminder.toolbaritemtext = "Delete Reminder"
			m_cusfocus_reminders.m_edit.m_deletereminder.MicroHelp = "Deletes the selected Reminder"
		END IF
	ELSE
		m_cusfocus_reminders.m_edit.m_deletereminder.text = "&Delete Copy"
		m_cusfocus_reminders.m_edit.m_deletereminder.toolbaritemtext = "Delete Copy"
		m_cusfocus_reminders.m_edit.m_deletereminder.MicroHelp = "Deletes the selected Copy"
		
		IF THIS.SelectedTab = 1 THEN
			
			IF tabpage_opencases.uo_search_open_cases.dw_report.RowCount( ) > 0 THEN
				l_nSelectedRow = tabpage_opencases.uo_search_open_cases.dw_report.GetRow( )
				IF l_nSelectedRow > 0 THEN
					IF tabpage_opencases.uo_search_open_cases.dw_report.Object.case_transfer_type[ l_nSelectedRow ] = "C" THEN
						m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
					ELSE
						m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
					END IF
				ELSE
					m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
				END IF
			ELSE
				m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
			END IF
		END IF
			
	END IF
	
	m_cusfocus_reminders.m_edit.m_sort.Enabled = FALSE
END IF
end event

public subroutine of_check_appeal_setting ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function gets the value from System_Options for the New Appeal System.
//	Created by:	Joel White
//	History: 	9/2/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


string ls_using_new_appeals

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the value for the 'new appeal system' from the System_Options table
//-----------------------------------------------------------------------------------------------------------------------------------
SELECT option_value
  INTO :is_using_new_appeals
  FROM cusfocus.system_options
 WHERE option_name = 'new appeal system'
 USING SQLCA;


//-----------------------------------------------------------------------------------------------------------------------------------
// Check the SQL Return 
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE SQLCA.SQLCode
	CASE -1
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Error happened, show a message box to show the user an error occurred.
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'Error retrieving new appeal system configuration.')
		is_using_new_appeals = 'N'
	CASE 0
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Good things happened.
		//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 100
		//-----------------------------------------------------------------------------------------------------------------------------------
		// No value was found for the 'new appeal system' record in the System_Options table
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'The configuration record for new appeal system was not found.')
		is_using_new_appeals = 'N'
End Choose
end subroutine

public subroutine of_check_fax_setting ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function gets the value from System_Options for the New Appeal System.
//	Created by:	Joel White
//	History: 	9/2/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


string ls_using_fax

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the value for the 'new appeal system' from the System_Options table
//-----------------------------------------------------------------------------------------------------------------------------------
SELECT option_value
  INTO :is_using_fax
  FROM cusfocus.system_options
 WHERE option_name = 'rightfax_tabenabled'
 USING SQLCA;


//-----------------------------------------------------------------------------------------------------------------------------------
// Check the SQL Return 
//-----------------------------------------------------------------------------------------------------------------------------------
CHOOSE CASE SQLCA.SQLCode
	CASE -1
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Error happened, show a message box to show the user an error occurred.
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'Error retrieving fax system configuration.')
		is_using_fax = 'N'
	CASE 0
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Good things happened.
		//-----------------------------------------------------------------------------------------------------------------------------------
	CASE 100
		//-----------------------------------------------------------------------------------------------------------------------------------
		// No value was found for the 'new appeal system' record in the System_Options table
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'The configuration record for fax system was not found.')
		is_using_fax = 'N'
End Choose
end subroutine

on uo_tab_workdesk.create
this.tabpage_opencases=create tabpage_opencases
this.tabpage_reminders=create tabpage_reminders
this.tabpage_appeal=create tabpage_appeal
this.tabpage_workqueues=create tabpage_workqueues
this.tabpage_work_tracker=create tabpage_work_tracker
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_opencases
this.Control[iCurrent+2]=this.tabpage_reminders
this.Control[iCurrent+3]=this.tabpage_appeal
this.Control[iCurrent+4]=this.tabpage_workqueues
this.Control[iCurrent+5]=this.tabpage_work_tracker
end on

on uo_tab_workdesk.destroy
call super::destroy
destroy(this.tabpage_opencases)
destroy(this.tabpage_reminders)
destroy(this.tabpage_appeal)
destroy(this.tabpage_workqueues)
destroy(this.tabpage_work_tracker)
end on

event selectionchanged;call super::selectionchanged;//***********************************************************************************************
//
//  Event:   selectionchanged
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/00 K. Claver     Added code to trigger the event to enable/disable menu items
//									depending on which is the current tab
//  12/11/01 K. Claver     Added code to set the focus to the list datawindow on each of the tabs
//									when the tab is switched to so can use the arrow keys to move up and down
//									the list or use the enter key to open the case.
//  09/20/02 K. Claver     Changed to refresh the tab that has been switched to if the timer has 
//									shown that it is ok to refresh.
//  02/26/03 M. Caruso     Post-ed the calls to ue_EnableMenuItems to resolve an issue with how
//									the menu items were being set.
//***********************************************************************************************  

//Enable or disable the menu items depending on which tab is selected

IF newindex = 2 THEN
	THIS.Event Post ue_EnableMenuItems( TRUE )
ELSE
	THIS.Event Post ue_EnableMenuItems( FALSE )
END IF

//Attempt to refresh the tab.  If the tab isn't set to be refreshed, it will not refresh.
THIS.Control[ newindex ].Event Dynamic Trigger ue_Refresh( )

//Need to set the focus to the list datawindow each time a tab is selected
//  so can immediately arrow down the list.
THIS.Control[ newindex ].Event Dynamic Trigger ue_SetMainFocus( )
end event

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   constructor
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/26/2000 M. Caruso   Added code to set the parent window reference
//***********************************************************************************************  

i_wParentWindow = W_REMINDERS

end event

event selectionchanging;call super::selectionchanging;//***********************************************************************************************
//
//  Event:   selectionchanging
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  12/20/2000 K. Claver   Added code to check if a reminder needs to be saved and can be saved
//									before allowing the tabs to switch
//***********************************************************************************************
Integer l_nRV, l_nCurrentRow
DWItemStatus l_dwisStatus

i_wParentWindow.i_nCurrentTab = newindex

IF newindex <> 2 THEN
	//check if the reminder has status of newmodified or datamodified
	IF tabpage_reminders.uo_search_reminders.dw_reminder_detail.RowCount( ) > 0 THEN
		tabpage_reminders.uo_search_reminders.dw_reminder_detail.AcceptText( )
		
		//Check the status of the current row
		l_nCurrentRow = tabpage_reminders.uo_search_reminders.dw_reminder_detail.GetRow( )
		l_dwisStatus = tabpage_reminders.uo_search_reminders.dw_reminder_detail.GetItemStatus( l_nCurrentRow, 0, Primary! )
		
		IF l_dwisStatus = NewModified! OR l_dwisStatus = DataModified! THEN
			l_nRV = MessageBox( gs_AppName, "Do you wish to save the current reminder?", Question!, YesNo! )
			
			IF l_nRV = 1 THEN
				l_nRV = tabpage_reminders.Event Trigger ue_savereminder( )
				
				IF l_nRV < 0 THEN
					//Don't allow the tab to switch if the save failed
					RETURN 1
				END IF
				// will have to change this for search reminders
			ELSEIF tabpage_reminders.uo_search_reminders.dw_report.RowCount( ) > 0 THEN
				//Select the first row, re-retrieve the details and scroll to the first row.
				tabpage_reminders.uo_search_reminders.dw_report.SelectRow( 0, FALSE )
				tabpage_reminders.uo_search_reminders.dw_report.SelectRow( 1, TRUE )
				tabpage_reminders.uo_search_reminders.dw_reminder_detail.fu_Retrieve( tabpage_reminders.uo_search_reminders.dw_reminder_detail.c_IgnoreChanges, &
																				  tabpage_reminders.uo_search_reminders.dw_reminder_detail.c_NoReselectRows )
				tabpage_reminders.uo_search_reminders.dw_report.ScrollToRow( 1 )
			ELSE
				//Otherwise, reset the detail datawindow
				tabpage_reminders.uo_search_reminders.dw_reminder_detail.fu_Reset( tabpage_reminders.uo_search_reminders.dw_reminder_detail.c_IgnoreChanges )
			END IF
		END IF
	END IF
END IF
end event

type tabpage_opencases from uo_tabpg_opencases within uo_tab_workdesk
integer x = 18
integer y = 100
integer width = 3593
integer height = 1728
end type

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   constructor
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  12/8/2000 K. Claver    Added code to set the parent tab reference
//***********************************************************************************************  
THIS.i_tabParentTab = PARENT
end event

type tabpage_reminders from uo_tabpg_reminders within uo_tab_workdesk
integer x = 18
integer y = 100
integer width = 3593
integer height = 1728
end type

event ue_refresh;call super::ue_refresh;//***********************************************************************************************
//
//  Event:   ue_refresh
//  Purpose: refresh the tabpage
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Added code to disable the menu items after the refresh if not on this
//									tab page
//***********************************************************************************************  
IF PARENT.SelectedTab <> 2 THEN
	PARENT.Event Trigger ue_EnableMenuItems( FALSE )
END IF
end event

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   constructor
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  12/8/2000 K. Claver    Added code to set the parent tab reference
//***********************************************************************************************  
THIS.i_tabParentTab = PARENT
end event

type tabpage_appeal from uo_tabpg_appeals within uo_tab_workdesk
integer x = 18
integer y = 100
integer width = 3593
integer height = 1728
string text = "Appeal Tracker"
end type

event constructor;call super::constructor;THIS.i_tabParentTab = PARENT

of_check_appeal_setting()

If is_using_new_appeals <> 'Y' Then
	tabpage_appeal.enabled = FALSE
	tabpage_appeal.visible = FALSE
End If
end event

type tabpage_workqueues from uo_tabpg_workqueues within uo_tab_workdesk
integer x = 18
integer y = 100
integer width = 3593
integer height = 1728
end type

event constructor;call super::constructor;THIS.i_tabParentTab = PARENT

end event

type tabpage_work_tracker from uo_tabpg_work_tracker within uo_tab_workdesk
integer x = 18
integer y = 100
integer width = 3593
integer height = 1728
string text = "Work Dashboard"
end type

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   constructor
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  12/8/2000 K. Claver    Added code to set the parent tab reference
//***********************************************************************************************  
THIS.i_tabParentTab = PARENT
end event

