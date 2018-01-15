$PBExportHeader$u_case_reminders.sru
$PBExportComments$Case Reminder User Object
forward
global type u_case_reminders from u_container_std
end type
type dw_case_reminder_history from u_dw_std within u_case_reminders
end type
type dw_calendar from u_calendar within u_case_reminders
end type
type dw_case_reminder from u_dw_std within u_case_reminders
end type
type dw_case_reminder_report from datawindow within u_case_reminders
end type
type gb_reminder_properties from groupbox within u_case_reminders
end type
end forward

global type u_case_reminders from u_container_std
integer width = 3575
integer height = 1592
long backcolor = 79748288
dw_case_reminder_history dw_case_reminder_history
dw_calendar dw_calendar
dw_case_reminder dw_case_reminder
dw_case_reminder_report dw_case_reminder_report
gb_reminder_properties gb_reminder_properties
end type
global u_case_reminders u_case_reminders

type variables
BOOLEAN                             i_bEnableCalendar
BOOLEAN                             i_bChangeMode
BOOLEAN										i_bFromRetrieve = FALSE
BOOLEAN 										i_bViewMode = TRUE

DATE                                    i_dCaseReminderDates[]
DATE                                    i_dOldReminderDate
DATE                                    i_dNewReminderDate

STRING                                 i_cCaseReminderID

W_CREATE_MAINTAIN_CASE i_wParentWindow
end variables

forward prototypes
public subroutine fu_activateinterface (string a_cstate)
public subroutine fu_printcasereminder ()
end prototypes

public subroutine fu_activateinterface (string a_cstate);/*****************************************************************************************
   Function:   fu_activateinterface
   Purpose:    Enable or disable reminder manipulation based on case status
   Parameters: a_cState - P = Protected
								  E = Enabled
								  D = Disabled
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	04/09/01 M. Caruso    Created.
	6/27/2001 K. Claver   Added a_cState parameter and modified the function to react accordingly.
	3/13/2002 K. Claver   Disable the menu items to modify or delete a reminder if the case is locked
*****************************************************************************************/

CONSTANT	LONG	l_nWhite = 16777215
CONSTANT	LONG	l_nTransparent = 79741120

BOOLEAN	l_bEnabled, l_bMenuEnabled
LONG		l_nStatus, l_nColor


// set the status and color values based on case status
CHOOSE CASE a_cState
	CASE "E"
		//Enabled
		l_bEnabled = TRUE
		l_bMenuEnabled = TRUE
		l_nColor = l_nWhite
		
		dw_case_reminder.fu_Modify( )		
		THIS.i_bViewMode = FALSE
	CASE "D"
		//Disabled
		l_bEnabled = FALSE
		l_bMenuEnabled = FALSE
		l_nColor = l_nTransparent		
		
		dw_case_reminder.fu_View( )
		THIS.i_bViewMode = TRUE
	CASE "P"
		//Protected
		l_bEnabled = FALSE
		l_bMenuEnabled = TRUE
		l_nColor = l_nWhite	
		
		dw_case_reminder.fu_View( )		
		THIS.i_bViewMode = TRUE
END CHOOSE 

// now update the status of the datawindows and fields.
SetRedraw (FALSE)

dw_calendar.enabled = l_bEnabled

dw_case_reminder.Object.reminder_recipient.background.color = l_nColor
dw_case_reminder.Object.reminder_subject.background.color = l_nColor
dw_case_reminder.Object.reminder_type_id.background.color = l_nColor
dw_case_reminder.Object.reminder_comments.background.color = l_nColor

m_create_maintain_case.m_file.m_new.enabled = l_bMenuEnabled

//Disable the menu items to modify or delete a reminder if the case is locked
IF THIS.i_wParentWindow.i_bCaseLocked THEN
	m_create_maintain_case.m_edit.m_modifycasereminder.enabled = FALSE
	m_create_maintain_case.m_edit.m_deletecasereminder.enabled = FALSE
ELSE
	m_create_maintain_case.m_edit.m_modifycasereminder.enabled = l_bMenuEnabled
	m_create_maintain_case.m_edit.m_deletecasereminder.enabled = l_bMenuEnabled
END IF

SetRedraw (TRUE)
end subroutine

public subroutine fu_printcasereminder ();/**************************************************************************************

		Function:	fu_printreminder
		Purpose:		To print the Case Reminder Report
		Parameters:	None
		Returns:		None

**************************************************************************************/

IF dw_case_reminder_history.RowCount() = 0 THEN
	MessageBox(gs_AppName, 'There are no Case Reminders to generate the Case Reminder' + &
			' Report.')
	RETURN
END IF

SetPointer(HOURGLASS!)
dw_case_reminder_report.SetTransObject(SQLCA)
dw_case_reminder_report.Retrieve( i_cCaseReminderID)
dw_case_reminder_report.Print()
end subroutine

on u_case_reminders.create
int iCurrent
call super::create
this.dw_case_reminder_history=create dw_case_reminder_history
this.dw_calendar=create dw_calendar
this.dw_case_reminder=create dw_case_reminder
this.dw_case_reminder_report=create dw_case_reminder_report
this.gb_reminder_properties=create gb_reminder_properties
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_case_reminder_history
this.Control[iCurrent+2]=this.dw_calendar
this.Control[iCurrent+3]=this.dw_case_reminder
this.Control[iCurrent+4]=this.dw_case_reminder_report
this.Control[iCurrent+5]=this.gb_reminder_properties
end on

on u_case_reminders.destroy
call super::destroy
destroy(this.dw_case_reminder_history)
destroy(this.dw_calendar)
destroy(this.dw_case_reminder)
destroy(this.dw_case_reminder_report)
destroy(this.gb_reminder_properties)
end on

event pc_setoptions;call super::pc_setoptions;/*****************************************************************************************
   Event:      pc_setoptions
   Purpose:    initialize the options for this container object

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/22/00 M. Caruso    Created to initialize the resize service.
	4/13/2001 K. Claver   Fixed the resize service.
*****************************************************************************************/

INTEGER	l_nNewHeight, l_nNewWidth, l_nNewX, l_nNewY
DECIMAL	l_nHeightOffset, l_nWidthOffset

of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	
	// calculate the resize ratio of the parent window from when it was created.
	IF i_wParentWindow.Width < 3579 THEN
		l_nWidthOffSet = 0
	ELSE
		l_nWidthOffSet = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
	END IF
	
	IF i_wParentWindow.Height < 1600 THEN
		l_nHeightOffSet = 0
	ELSE
		l_nHeightOffSet = i_wParentWindow.Height - i_wParentWindow.i_nBaseHeight
	END IF
	
	// initialize the container and register it with the parent window.
	l_nNewHeight = 1600 + l_nHeightOffset
	l_nNewWidth = 3579 + l_nWidthOffSet
	Resize (l_nNewWidth, l_nNewHeight)
	
	// initialize the reminder history datawindow.
	inv_resize.of_Register (dw_case_reminder_history, "ScaleToRight&Bottom")
	l_nNewHeight = dw_case_reminder_history.Height + l_nHeightOffset
	l_nNewWidth = dw_case_reminder_history.Width + l_nWidthOffset
	dw_case_reminder_history.resize (l_nNewWidth, l_nNewHeight)
	
	// initialize the reminder details group box.
	inv_resize.of_Register (gb_reminder_properties, "FixedToBottom&ScaleToRight")
	l_nNewX = gb_reminder_properties.X
	l_nNewY = gb_reminder_properties.Y + l_nHeightOffset
	l_nNewHeight = gb_reminder_properties.Height
	l_nNewWidth = gb_reminder_properties.Width + l_nWidthOffset
	gb_reminder_properties.resize (l_nNewWidth, l_nNewHeight)
	gb_reminder_properties.Move (l_nNewX, l_nNewY)
	
	// initialize the reminder details datawindow.
	inv_resize.of_Register (dw_case_reminder, "FixedToBottom")
	l_nNewX = dw_case_reminder.X
	l_nNewY = dw_case_reminder.Y + l_nHeightOffset
	dw_case_reminder.Move (l_nNewX, l_nNewY)
	
	// initialize the reminder calendar.
	inv_resize.of_Register (dw_calendar, "FixedToRight&Bottom")
	l_nNewX = dw_calendar.X + l_nWidthOffset
	l_nNewY = dw_calendar.Y + l_nHeightOffset
	dw_calendar.Move (l_nNewX, l_nNewY)
	
	// dw_case_reminder_report does not resize (not visible)
	
	//Register this object with the resize service.
	i_wParentWindow.inv_resize.of_Register (THIS, "ScaleToRight&Bottom")
	
END IF
end event

type dw_case_reminder_history from u_dw_std within u_case_reminders
integer x = 5
integer y = 20
integer width = 3547
integer height = 692
integer taborder = 30
string dataobject = "d_case_reminders_history"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_pickedrow;call super::pcd_pickedrow;/***************************************************************************************

		Event:	pcd_pickedrow
		Purpose:	To Disable the Calendar object when in View Mode.

**************************************************************************************/
i_bEnableCalendar = FALSE
end event

event pcd_retrieve;call super::pcd_retrieve;/***************************************************************************************
	Event:	pcd_retrieve
	Purpose:	To retrieve the Case Reminders and to set all the Reminder dates for
				the Calendar object.
				
	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	11/22/00 M. Caruso     Added code to resize the separator line
	04/09/01 M. Caruso     Added call to fu_activateinterface().
	6/27/2001 K. Claver    Changed calls to fu_activateinterface depending on the case
								  status.
**************************************************************************************/

LONG l_nReturn, l_nSelectedRows[], l_nNumber
INT  l_nCounter, l_nReminderYear, l_nReminderMonth
Date l_dEmptyArray[ ], l_dFirstDate[ ]

//-----------------------------------------------------------------------------------
//
//		Clear out the dynamic array with blank dates
//
//------------------------------------------------------------------------------------

PARENT.i_dCaseReminderDates = l_dEmptyArray

l_nReturn = Retrieve(i_wParentWindow.i_cSelectedCase)

CHOOSE CASE l_nReturn
	CASE IS < 0
		Error.i_FWError = c_Fatal
		
	CASE 0
		// set the status of the interface based on the case subject.
		CHOOSE CASE i_wParentWindow.i_uoCaseDetails.i_cCaseStatus
			CASE i_wParentWindow.i_cStatusOpen
				dw_case_reminder.fu_ChangeOptions( dw_case_reminder.c_ModifyOK )
				fu_activateinterface( "E" )
			CASE ELSE
				fu_activateinterface( "D" )
		END CHOOSE
	CASE IS > 0

//------------------------------------------------------------------------------------
//
//		Fill the clean dynamic array with the dates from the Retrieved data
//
//------------------------------------------------------------------------------------

		FOR l_nCounter = 1 to l_nReturn
			IF l_nCounter = 1 THEN
				//Get the first date, as this will be the month and year we want to set the
				//  calendar to when open.
				l_dFirstDate[l_nCounter] = Date(GetItemDateTime(l_nCounter, 'reminder_set_date'))
	
				l_nReminderYear = YEAR(l_dFirstDate[l_nCounter])
				l_nReminderMonth = MONTH(l_dFirstDate[l_nCounter])				
			END IF		
			
			i_dCaseReminderDates[l_nCounter] = Date(GetItemDateTime(l_nCounter, 'reminder_set_date'))
		NEXT
		dw_calendar.fu_CalSetDates(i_dCaseReminderDates[])		
		dw_calendar.fu_CalSetMonth(l_nReminderMonth, l_nReminderYear)
		
		// set the status of the interface based on the case subject.
		CHOOSE CASE i_wParentWindow.i_uoCaseDetails.i_cCaseStatus
			CASE i_wParentWindow.i_cStatusOpen
				fu_activateinterface( "P" )
			CASE ELSE
				fu_activateinterface( "D" )
		END CHOOSE				

END CHOOSE

// enable resizing of separator line
of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	inv_resize.of_Register( "l_1", inv_resize.SCALERIGHT )
END IF

end event

event pcd_savebefore;/****************************************************************************************

	Event:	pcd_savebefore
	Purpose:	To check and see if the user set a Reminder date.
		
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	02/02/00 C. Jackson    Added check for past date (Tracker 311)
	7/3/2001 K. Claver     Commented out check for past dates per version 4.2 SCR 2145

***************************************************************************************/

DATETIME l_dToday, l_dReminderDate

IF NOT m_create_maintain_case.i_bReminderDelete THEN

	l_dReminderDate = dw_case_reminder.GetItemDateTime(dw_case_reminder.i_CursorRow, 'reminder_set_date')
	l_dToday = DateTime(Today())
	
	IF dw_case_reminder.i_CursorRow > 0 THEN
//		IF l_dReminderDate < l_dToday THEN
//			MessageBox(gs_AppName,'Past Dates are not allowed.  Please enter a valid date.')
//			Error.i_FWError = c_Fatal
//			i_bEnableCalendar = TRUE
//			dw_calendar.SetFocus()
//		END IF
		IF ISNull(l_dReminderDate) THEN
			MessageBox(gs_AppName, 'A Case Reminder requires a Set Date.  Please enter a date.')
			Error.i_FWError = c_Fatal
			i_bEnableCalendar = TRUE
		END IF
	END IF

END IF
end event

on pcd_saveafter;/**************************************************************************************

		Event:	pcd_saveafter
		Purpose:	To Disbale the Calendar when in View mode.

***************************************************************************************/
i_bEnableCalendar = FALSE


end on

type dw_calendar from u_calendar within u_case_reminders
integer x = 2528
integer y = 836
integer width = 987
integer height = 712
integer taborder = 10
end type

event po_dayvalidate;call super::po_dayvalidate;/*************************************************************************************

		  Event:		po_dayvalidate
		Purpose: 	To enable the user from selecting a day while the Case Reminder
						Datawindow is in View mode.


**************************************************************************************/

IF NOT i_bEnableCalendar THEN 
	i_CalendarError = c_ValFailed
END IF
end event

event po_daychanged;call super::po_daychanged;/*************************************************************************************

			Event:	po_daychanged
		 Purpose:	To determine what day the user has selected for the Case Reminder.

*************************************************************************************/

DATE l_dNullDate

IF KeyDown(KeyControl!) THEN
	SetNull(l_dNullDate)
	dw_case_reminder.SEtItem(dw_case_reminder.i_CursorRow, 'reminder_set_date', &
			l_dNullDate)
ELSE
	dw_case_reminder.SEtItem(dw_case_reminder.i_CursorRow, 'reminder_set_date', &
							DateTime(Date(fu_CalGetYear(), fu_CalGetMonth(), i_SelectedDay)))
END IF
end event

type dw_case_reminder from u_dw_std within u_case_reminders
integer x = 32
integer y = 836
integer width = 2496
integer height = 724
integer taborder = 40
string dataobject = "d_case_reminders"
boolean border = false
end type

event pcd_validaterow;call super::pcd_validaterow;/**************************************************************************************

		Event:	pcd_validaterow
		Purpose:	Please see PowerClass documentation for this event.

		7/3/2001 K. Claver     Commented out check for past dates per version 4.2 SCR 2145

**************************************************************************************/
Date l_dReminderDate

IF IsNull(THIS.GetItemString(row_nbr,"reminder_type_id")) THEN
 	MessageBox(gs_AppName,"Please enter a reminder type before continuing.",Exclamation!)
	THIS.SetColumn("reminder_type_id")
 	Error.i_FWError = c_Fatal
	RETURN
END IF	
	
l_dReminderDate = Date( THIS.GetItemDateTime(THIS.i_CursorRow, 'reminder_set_date') )

//IF l_dReminderDate < Today( ) THEN
//	MessageBox(gs_AppName,'Past Dates are not allowed.  Please enter a valid date.')
//	Error.i_FWError = c_Fatal
//	i_bEnableCalendar = TRUE
//	dw_calendar.SetFocus()
//	RETURN
//END IF

IF ISNull(l_dReminderDate) THEN
	MessageBox(gs_AppName, 'A Case Reminder requires a Set Date.  Please enter a date.')
	Error.i_FWError = c_Fatal
	i_bEnableCalendar = TRUE
	dw_calendar.SetFocus()
	RETURN
END IF

end event

event pcd_modify;call super::pcd_modify;/************************************************************************************

		   	Event:		pcd_modify
      	 Purpose:		To Enable the Calendar Object for user Reminder Selection and
								to clear the Calendar of all selected dates except for the 
								record that is being modified.

************************************************************************************/
INT      l_nMonth, l_nYear
DATE     l_dReminderDate[]

IF THIS.RowCount( ) > 0 THEN
	PARENT.SetRedraw(FALSE)
	
	l_dReminderDate[1] = Date(GetItemDateTime(1, 'reminder_set_date'))
	
	IF NOT IsNull(l_dReminderDate[1]) THEN
		l_nYear = YEAR(l_dReminderDate[1])
		l_nMonth = MONTH(l_dReminderDate[1])
		
		dw_calendar.fu_CalSetMonth(l_nMonth, l_nYear)
		dw_calendar.fu_CalClearDates()
		dw_calendar.fu_CalSetDates(l_dReminderDate[])
		
		i_bEnableCalendar = TRUE
		i_bChangemode = TRUE
		
		PARENT.i_bViewMode = FALSE
		dw_calendar.enabled = TRUE
	END IF

	PARENT.SEtRedraw(TRUE)
	THIS.SetFocus( )
END IF


end event

event pcd_view;call super::pcd_view;/**************************************************************************************

		Event:	pcd_view
		Purpose:	To set the Calendar Dates when we go back into View Mode from Modify
					Mode.

**************************************************************************************/

IF i_bChangeMode THEN
	i_bChangeMode = FALSE
	dw_calendar.fu_CalSetDates(i_dCaseReminderDates[])
	PARENT.i_bViewMode = TRUE
END IF
end event

event pcd_new;call super::pcd_new;//****************************************************************************************
//
//  Event:    pcd_new
//  Purpose:  To clear and enable the Calendar object for Reminder selection and 
//				  to initialize the new row.
//
//  Date     Developer    Description
//  -------- ------------ ----------------------------------------------------------------
//  04/12/00 C. Jackson   Add reminder_viewed 'N' to SetItem statements (SCR 513)
//  12/08/00 M. Caruso    Added call to SetFocus ().
//****************************************************************************************

i_bEnableCalendar = TRUE

SetItem(i_CursorRow, 'case_number', i_wParentWindow.i_cCurrentCase)
SetItem(i_CursorRow, 'reminder_crtd_date', i_wParentWindow.fw_gettimestamp())
SetItem(i_CursorRow, 'reminder_author', OBJCA.WIN.fu_GetLogin(SQLCA))
SetItem(i_CursorRow, 'reminder_recipient', OBJCA.WIN.fu_GetLogin(SQLCA))
SetItem(i_CursorRow, 'case_type', i_wParentWindow.i_cCaseType)
SetItem(i_CursorRow, 'reminder_viewed','N')

//-------------------------------------------------------------------------
//
//		Change the New Row status back to New so that the user will not be
//		prompted for changes if they do not make any modifications after this
//		point.
//
//--------------------------------------------------------------------------

SetItemStatus(i_CursorRow, 0, PRIMARY!, NOTMODIFIED!)

dw_calendar.fu_CalClearDates()

fu_ActivateInterface( "E" )

SetFocus ()

end event

event pcd_retrieve;call super::pcd_retrieve;/************************************************************************************

			Event:		pcd_retrieve
		 Purpose:		To get the retrieval argument value from the parent dw and 
							retrieve the child dw.

***********************************************************************************/

LONG l_nReturn
Date l_dReminderDate[ ]
Integer l_nYear, l_nMonth

i_cCaseReminderID  = Parent_DW.GetItemSTring(Selected_Rows[1], 'reminder_id')

l_nReturn = Retrieve(i_cCaseReminderID)

PARENT.i_bViewMode = TRUE

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF
 
end event

event pcd_setkey;call super::pcd_setkey;//**********************************************************************************************
//
//  Event:   pcd_setkey
//  Purpose: To call the standards layer key generation function and place into the dw buffer
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  10/06/00 C. Jackson  Add table name to call to fw_getkeyvalue
//
//**********************************************************************************************

SetItem(i_CursorRow, 'reminder_id', i_wParentWindow.fw_GetKeyValue('reminders'))
end event

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

IF NOT i_bViewMode THEN
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

type dw_case_reminder_report from datawindow within u_case_reminders
boolean visible = false
integer x = 5
integer width = 3296
integer height = 1732
integer taborder = 20
string dataobject = "d_case_reminders_report"
boolean livescroll = true
end type

event constructor;//display the application name in the report if the section
//  is populated in the ini file
IF gs_AppName <> "" AND THIS.DataObject = "d_case_reminders_report" THEN
	THIS.Object.t_2.text = gs_AppName
END IF
end event

type gb_reminder_properties from groupbox within u_case_reminders
integer x = 5
integer y = 744
integer width = 3547
integer height = 828
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reminder Properties"
end type

