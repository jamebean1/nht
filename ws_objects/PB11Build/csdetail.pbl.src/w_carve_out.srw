$PBExportHeader$w_carve_out.srw
$PBExportComments$Window for entering/editing carve out information.
forward
global type w_carve_out from w_response_std
end type
type st_2 from statictext within w_carve_out
end type
type p_1 from picture within w_carve_out
end type
type dw_calendar from u_calendar within w_carve_out
end type
type dw_carve_out from u_dw_std within w_carve_out
end type
type cb_cancel from commandbutton within w_carve_out
end type
type cb_ok from commandbutton within w_carve_out
end type
type ln_1 from line within w_carve_out
end type
type ln_2 from line within w_carve_out
end type
type ln_3 from line within w_carve_out
end type
type st_1 from statictext within w_carve_out
end type
type ln_4 from line within w_carve_out
end type
type ln_6 from line within w_carve_out
end type
type ln_8 from line within w_carve_out
end type
type st_3 from statictext within w_carve_out
end type
end forward

global type w_carve_out from w_response_std
integer width = 2537
integer height = 1216
string title = "Carve Out Information"
st_2 st_2
p_1 p_1
dw_calendar dw_calendar
dw_carve_out dw_carve_out
cb_cancel cb_cancel
cb_ok cb_ok
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
st_1 st_1
ln_4 ln_4
ln_6 ln_6
ln_8 ln_8
st_3 st_3
end type
global w_carve_out w_carve_out

type variables
STRING	i_cEntryID
STRING	i_cCaseNumber
STRING   i_cCaseType

DateTime i_dtInitialEstEnd
end variables

forward prototypes
public function long fw_calculatedays (long row)
end prototypes

public function long fw_calculatedays (long row);/*****************************************************************************************
   Function:   fw_calculatedays
   Purpose:    Calculate the number of days a carve out entry was open.
   Parameters: LONG	row - the row number of the entry to calculate for.
   Returns:    LONG NULL - the calculation failed.
							 >0 - the number of days the carve out entry was open.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/08/01 M. Caruso    Created.
	3/27/2001 K. Claver   Added a day to the value returned from the DaysAfter function to
								 accomodate for the first day in the date calculation.
*****************************************************************************************/

LONG	l_nNumDays, l_nNull
DATE	l_dStartDate, l_dEndDate

SetNull (l_nNull)

l_dStartDate = Date (dw_carve_out.GetItemDateTime (row, 'start_date'))
l_dEndDate = Date (dw_carve_out.GetItemDateTime (row, 'end_date'))

// verify a valid start date
IF IsNull (l_dStartDate) THEN
	MessageBox (gs_appname, 'Carve Out days cannot be calculated because a start date was not entered.', StopSign!, OK!)
	RETURN l_nNull
END IF

// verify a valid end date
IF IsNull (l_dEndDate) THEN
	MessageBox (gs_appname, 'Carve Out days cannot be calculated because an end date was not entered.', StopSign!, OK!)
	RETURN l_nNull
END IF

//Make sure the end date is at least the same day as the start date.  The message
//  will come from the pcd_validaterow event for the datawindow.
IF l_dEndDate < l_dStartDate THEN
	RETURN l_nNull
END IF

// perform the calulation
l_nNumDays = DaysAfter (l_dStartDate, l_dEndDate)

//If the number of days is less than 1, needs to return 1
IF l_nNumDays < 1 THEN
	l_nNumDays = 1
END IF

RETURN l_nNumDays
end function

on w_carve_out.create
int iCurrent
call super::create
this.st_2=create st_2
this.p_1=create p_1
this.dw_calendar=create dw_calendar
this.dw_carve_out=create dw_carve_out
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.st_1=create st_1
this.ln_4=create ln_4
this.ln_6=create ln_6
this.ln_8=create ln_8
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.dw_calendar
this.Control[iCurrent+4]=this.dw_carve_out
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.ln_1
this.Control[iCurrent+8]=this.ln_2
this.Control[iCurrent+9]=this.ln_3
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.ln_4
this.Control[iCurrent+12]=this.ln_6
this.Control[iCurrent+13]=this.ln_8
this.Control[iCurrent+14]=this.st_3
end on

on w_carve_out.destroy
call super::destroy
destroy(this.st_2)
destroy(this.p_1)
destroy(this.dw_calendar)
destroy(this.dw_carve_out)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.st_1)
destroy(this.ln_4)
destroy(this.ln_6)
destroy(this.ln_8)
destroy(this.st_3)
end on

event pc_setvariables;call super::pc_setvariables;/*****************************************************************************************
   Event:      pc_setvariables
   Purpose:    initialize instance variables for this window.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/26/01	M. Caruso    Created.
	4/2/2001 K. Claver    Added case type.
*****************************************************************************************/

i_cEntryID = PCCA.Parm[1]
i_cCaseNumber = PCCA.Parm[2]
i_cCaseType = PCCA.Parm[3]

end event

type st_2 from statictext within w_carve_out
integer x = 201
integer y = 60
integer width = 1600
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Carve Out"
boolean focusrectangle = false
end type

type p_1 from picture within w_carve_out
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type dw_calendar from u_calendar within w_carve_out
boolean visible = false
integer x = 434
integer y = 304
integer taborder = 30
end type

type dw_carve_out from u_dw_std within w_carve_out
event ue_dropdown pbm_dwndropdown
event buttonclicked pbm_dwnbuttonclicked
integer x = 37
integer y = 200
integer width = 2491
integer height = 736
integer taborder = 10
string dataobject = "d_carve_out_entry"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;/****************************************************************************************
			Event:	buttonclicked
		 Purpose:	Please see PB documentation for this event
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	03/01/01 M. Caruso     Added code to display a calendar window when the user clicks
								  the elipsis button next to a date field.
	03/19/01 M. Caruso     Update the date field only if a new value is passed back.
	3/27/2001 K. Claver    Added code to default the number of days when an end date
								  is entered.
**************************************************************************************/

BOOLEAN	l_bProcessCalendar
INTEGER	l_nX, l_nY, l_nHeight
LONG		l_nNumDays, l_nFuture
DATE		l_dStartDate, l_dEndDate
DATETIME	l_dtValue, l_dtInitial
STRING	l_cValue, l_cParm, l_cX, l_cY, l_cColName

CHOOSE CASE dwo.name
	CASE 'b_start_cal'
		l_bProcessCalendar = TRUE
		l_cColName = 'start_date'
		
	CASE 'b_est_end_cal'
		l_bProcessCalendar = TRUE
		l_cColName = 'est_end_date'
		
	CASE 'b_end_cal'
		l_bProcessCalendar = TRUE
		l_cColName = 'end_date'
		
//	CASE 'b_day_calculator'
//		// calculate the number of days from start to end.
//		l_bProcessCalendar = FALSE
//		dw_carve_out.AcceptText ()
//		l_nNumDays = fw_calculatedays (row)
//		
//		IF l_nNumDays > 0 THEN	
//			dw_carve_out.SetItem (row, 'num_days', l_nNumDays)
//		END IF
		
	CASE ELSE
		l_bProcessCalendar = FALSE
		
END CHOOSE

IF l_bProcessCalendar THEN
	
	// set focus to the column associated with the selected button
	SetColumn (l_cColName)

	// Get the button's dimensions to position the calendar window
	l_nX = Integer (dwo.X) + dw_carve_out.X + PARENT.X
	l_nY = Integer (dwo.Y) + Integer (dwo.Height) + dw_carve_out.Y + PARENT.Y
	l_cX = String (l_nX)
	l_cY = String (l_nY)
	
	// open the calendar window
	AcceptText ()
	l_dtValue = GetItemDateTime (row, l_cColName)
	l_dtInitial = l_dtValue
	l_cParm = (String (Date (l_dtValue), "mm/dd/yyyy")+"&"+l_cX+"&"+l_cY)
	FWCA.MGR.fu_OpenWindow (w_calendar, l_cParm)
	
	// Get the date passed back
	l_cValue = Message.StringParm
	
	// If it's a date, convert to a datetime and update the field.
	IF IsDate (l_cValue) THEN
		l_dtValue = DateTime (Date (l_cValue), Time ("00:00:00.000"))
		SetItem (row, l_cColName, l_dtValue)
		
		//If changed the end date, recalculate the total days.
		IF dwo.Name = 'b_end_cal' THEN

			//Calculate the total days
			l_nNumDays = fw_calculatedays( row )
			
			//Set the value into the datawindow
			THIS.Object.num_days[ row ] = l_nNumDays
		END IF
	ELSE
		SetNull( l_dtValue )
		THIS.SetItem( row, l_cColName, l_dtValue )
	END IF
	
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
   Event:      pcd_setoptions
   Purpose:    Initialize this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/01	M. Caruso    Created.
*****************************************************************************************/

IF i_cEntryID = '' THEN
	fu_SetOptions (SQLCA, c_NullDW, c_NewOK + &
											  c_ModifyOK + &
											  c_NewOnOpen + &
											  c_NewModeOnEmpty + &
											  c_NoEnablePopup)
ELSE
	fu_SetOptions (SQLCA, c_NullDW, c_NewOK + &
											  c_ModifyOK + &
											  c_ModifyOnOpen + &
											  c_NewModeOnEmpty + &
											  c_NoEnablePopup)
END IF

end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
   Event:      pcd_retrieve
   Purpose:    Retrieve data for this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/01	M. Caruso    Created.
*****************************************************************************************/

CHOOSE CASE retrieve (i_cEntryID)
	CASE IS < 0
		// an error occurred, so notify the user and close the window.
		MessageBox (gs_appname, 'An error occurred while trying to retrieve carve out information.~r~n' + &
										'Please notify your system administrator.')
		cb_cancel.postevent ('clicked')
		
	CASE 0
		// record was not found, so create a new carve out entry
//		fu_New (1)

		//Set the initial estimated end date variable to null
		SetNull( PARENT.i_dtInitialEstEnd )
		
	CASE ELSE
		// this means everything went well...
		
		//Set the estimated end date to what was retrieved
		PARENT.i_dtInitialEstEnd = THIS.Object.est_end_date[ 1 ]
		
END CHOOSE
end event

event pcd_new;call super::pcd_new;/*****************************************************************************************
   Event:      pcd_new
   Purpose:    Set default values for a new record in this datawindow.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/01	M. Caruso    Created.
	4/17/2001 K. Claver   Added code to populate the case type and source type fields in the
								 datawindow.
*****************************************************************************************/

LONG	l_nRow

l_nRow = GetRow ()

// set default information for the new record
SetItem (l_nRow, 'case_number', i_cCaseNumber)
SetItem (l_nRow, 'created_by', OBJCA.WIN.fu_GetLogin (SQLCA))
SetItem (l_nRow, 'created_timestamp', fw_GetTimeStamp ())
SetItem (l_nRow, 'reminder_prompt', 'N')
THIS.SetItem( l_nRow, 'case_type', PCCA.Parm[ 3 ] )
THIS.SetItem( l_nRow, 'source_type', PCCA.Parm[ 4 ] )

// reset the status of this item to NEW!
SetItemStatus (1, 0, Primary!, NotModified!)

end event

event pcd_setkey;call super::pcd_setkey;/*****************************************************************************************
   Event:      pcd_setkey
   Purpose:    Set the key value for new records

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	03/08/01 M. Caruso    Created.
*****************************************************************************************/

LONG	l_nRow

l_nRow = GetRow ()
IF l_nRow > 0 THEN
	
	SetItem (l_nRow, 'co_id', fw_getkeyvalue ('carve_out_entries'))
	
END IF
end event

event pcd_savebefore;call super::pcd_savebefore;/*****************************************************************************************
   Event:      pcd_savebefore
   Purpose:    Prepare to save the record.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/01	M. Caruso    Created.
*****************************************************************************************/

BOOLEAN	l_bDaysSet
LONG		l_nRow
INTEGER	l_nNumDays
STRING	l_cEndDate

l_nRow = GetRow ()
l_cEndDate = String (Date (GetItemDateTime (l_nRow, 'end_date')), 'mm/dd/yyyy')
IF IsDate (l_cEndDate) THEN
	
	l_nNumDays = GetItemNumber (l_nRow, 'num_days')
	IF IsNull (l_nNumDays) OR l_nNumDays = 0 THEN
		
		// calculate carve out days for this entry.
		dw_carve_out.AcceptText ()
		l_nNumDays = fw_calculatedays (l_nRow)
		
		IF l_nNumDays > 0 THEN	
			dw_carve_out.SetItem (l_nRow, 'num_days', l_nNumDays)
			l_bDaysSet = TRUE
		ELSE
			l_bDaysSet = FALSE
		END IF
		
	ELSE
		l_bDaysSet = TRUE
	END IF
	
	IF l_bDaysSet THEN
		
		// Set remaining "closing" information
		dw_carve_out.SetItem (l_nRow, 'closed_by', OBJCA.WIN.fu_GetLogin (SQLCA))
		dw_carve_out.SetItem (l_nRow, 'closed_timestamp', fw_GetTimeStamp ())
		
	END IF
	
END IF
end event

event pcd_validaterow;call super::pcd_validaterow;/****************************************************************************************
	Event:	pcd_validaterow
	Purpose:	Validate data in the current row.
						
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	03/09/01 M. Caruso     Created.
****************************************************************************************/

STRING	l_cValue
DATETIME	l_dtStart, l_dtEnd, l_dtEstEnd

IF in_save THEN
	
	// Check that the reason field has a value.
	l_cValue = GetItemString (row_nbr, 'reason')
	IF IsNull (l_cValue) OR l_cValue = '' THEN
		MessageBox (gs_appname, 'You must enter a reason for this carve out entry.', StopSign!, OK!)
		Error.i_FWError = c_ValFailed
		RETURN
	END IF
	
	// Ensure that a start date has been set.
	l_dtStart = GetItemDateTime (row_nbr, 'start_date')
	IF IsNull (l_dtStart) OR l_dtStart = DateTime (Date ('1900-01-01')) THEN
		MessageBox (gs_appname, 'You must enter a valid start date for this carve out entry.', StopSign!, OK!)
		Error.i_FWError = c_ValFailed
		RETURN
	END IF
	
	// Ensure that the end date is later than the start date
	l_dtEnd = THIS.GetItemDateTime( row_nbr, "end_date" )
	IF NOT IsNull( l_dtEnd ) AND Date( l_dtEnd ) < Date( l_dtStart ) THEN
		MessageBox( gs_AppName, "The end date must be greater than or equal to the start date.", StopSign!, OK! )
		Error.i_FWError = c_ValFailed
		RETURN
	END IF
	
	// Ensure that the estimated end date is later than the start date
	l_dtEstEnd = THIS.GetItemDateTime( row_nbr, "est_end_date" )
	IF NOT IsNull( l_dtEstEnd ) AND Date( l_dtEstEnd ) < Date( l_dtStart ) THEN
		MessageBox( gs_AppName, "The estimated end date must be greater than or equal to the start date.", StopSign!, OK! )
		Error.i_FWError = c_ValFailed
		RETURN
	END IF
	
END IF
end event

type cb_cancel from commandbutton within w_carve_out
integer x = 2043
integer y = 1012
integer width = 411
integer height = 90
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;/*****************************************************************************************
   Event:      clicked
   Purpose:    Close the window and ignore any changes that have been made.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/01	M. Caruso    Created.
	03/08/01 M. Caruso    Pass back '0' to indicate process was cancelled.
*****************************************************************************************/

dw_carve_out.fu_ResetUpdate ()
PCCA.Parm[1] = '0'
CLOSE (PARENT)
end event

type cb_ok from commandbutton within w_carve_out
integer x = 1600
integer y = 1012
integer width = 411
integer height = 90
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: Closed the window and save any changes that have been made.
//  
//  Date
//  -------- ----------- -----------------------------------------------------------------------
//  02/27/01 M. Caruso   Created.
//  03/08/01 M. Caruso   Pass back '1' to indicate process was completed with changes.
//  03/30/01 K. Claver   Added code to check for changes and re-calculate the total days if 
//                       changes were made.
//  04/02/01 K. Claver   Added code to add a reminder.
//  02/05/03 C. Jackson  Don't allow a future date in the End Date field.
//**********************************************************************************************

Integer l_nNull, l_nRV, l_nCount
String l_cReminderID, l_cUser, l_cReason, l_cCarveID
DateTime l_dtEstEnd, l_dtToday, l_dtStart, l_dtEnd

SetNull( l_nNull )

//Accept all changes into the datawindow
dw_carve_out.AcceptText( )

IF dw_carve_out.RowCount( ) > 0 THEN
	//First check for valid years as a year earlier than 1753 will fail on insert or update to
	//  a MS-SQL Server database.
	l_dtStart = dw_carve_out.Object.start_date[ 1 ]
	l_dtEnd = dw_carve_out.Object.end_date[ 1 ]
	
	l_dtEstEnd = dw_carve_out.Object.est_end_date[ 1 ]
	
	IF NOT IsNull( l_dtStart ) THEN
		IF Year( Date( l_dtStart ) ) < 1753 THEN
			MessageBox( gs_AppName, "Invalid year for Start Date.  Please enter a year later than 1752.", StopSign!, OK! )
			dw_carve_out.SetFocus( )
			dw_carve_out.SetColumn( 'start_date' )
			RETURN
		END IF
	END IF
			
	IF NOT IsNull( l_dtEnd ) THEN
		IF Year( Date( l_dtEnd ) ) < 1753 THEN
			MessageBox( gs_AppName, "Invalid year for End Date.  Please enter a year later than 1752.", StopSign!, OK! )	
			dw_carve_out.SetFocus( )
			dw_carve_out.SetColumn( 'end_date' )
			RETURN
		ELSE
			IF DaysAfter(today(),DATE(l_dtEnd)) > 0 THEN
				messagebox(gs_AppName,'The end date must not be in the future.', StopSign!, OK! )
				dw_carve_out.SetFocus( )
				dw_carve_out.SetColumn( 'end_date' )
				
				RETURN
			END IF
		END IF
	END IF
				
	IF NOT IsNull( l_dtEstEnd ) THEN
		IF Year( Date( l_dtEstEnd ) ) < 1753 THEN
			MessageBox( gs_AppName, "Invalid year for Est. End Date.  Please enter a year later than 1752.", StopSign!, OK! )		
			dw_carve_out.SetFocus( )
			dw_carve_out.SetColumn( 'est_end_date' )
RETURN
		END IF
	END IF
	
	IF dw_carve_out.GetItemStatus( 1, 0, Primary! ) = DataModified! OR &
		dw_carve_out.GetItemStatus( 1, 0, Primary! ) = NewModified! THEN
		//Something has changed.  Recalculate the total days.
		IF NOT IsNull( dw_carve_out.Object.start_date[ 1 ] ) AND &
		   NOT IsNull( dw_carve_out.Object.end_date[ 1 ] ) THEN
			dw_carve_out.Object.num_days[ 1 ] = PARENT.fw_CalculateDays( 1 )
		ELSE
			dw_carve_out.Object.num_days[ 1 ] = l_nNull
		END IF
	END IF
END IF

IF dw_carve_out.fu_save (dw_carve_out.c_savechanges) = c_Success THEN
	IF dw_carve_out.RowCount( ) > 0 THEN
		//Get the carve out id for the entry just saved.
		l_cCarveID = dw_carve_out.Object.co_id[ 1 ]
		
		//Check if there is an existing reminder for this Carve out entry
		SELECT Count( * )
		INTO :l_nCount
		FROM cusfocus.reminders
		WHERE cusfocus.reminders.co_id = :l_cCarveID
		USING SQLCA;
		
		//If the estimated end date has been cleared, check for an existing reminder and
		//  see if they want to delete.
		IF NOT IsNull( PARENT.i_dtInitialEstEnd ) AND &
			IsNull( dw_carve_out.Object.est_end_date[ 1 ] ) THEN
			IF l_nCount > 0 THEN
				l_nRV = MessageBox( gs_AppName, "Would you like to delete the associated reminder?", &
									     Question!, YesNo! )
								
				IF l_nRV = 1 THEN
					//Delete the reminder
					DELETE cusfocus.reminders
					WHERE cusfocus.reminders.co_id = :l_cCarveID
					USING SQLCA;
					
					IF SQLCA.SQLCode <> 0 THEN
						MessageBox( gs_AppName, "Error deleting carve out return reminder", Stopsign!, OK! )
						
						Error.i_FWError = c_Fatal
						RETURN
					END IF
				END IF
			END IF
		END IF
	
		//Ask if want to set a carve out reminder if the estimated end date is populated
		IF NOT IsNull( dw_carve_out.Object.est_end_date[ 1 ] ) AND &
			IsNull( dw_carve_out.Object.end_date[ 1 ] ) THEN
			
			l_dtEstEnd = dw_carve_out.Object.est_end_date[ 1 ]
			l_cReason = dw_carve_out.Object.reason[ 1 ]
			
			IF l_nCount > 0 THEN
				//Update the current reminder
				UPDATE cusfocus.reminders
				SET cusfocus.reminders.reminder_set_date = :l_dtEstEnd,
					 cusfocus.reminders.reminder_comments = :l_cReason
				WHERE cusfocus.reminders.co_id = :l_cCarveID
				USING SQLCA;
				
				IF SQLCA.SQLCode <> 0 THEN
					MessageBox( gs_AppName, "Error updating carve out return reminder", Stopsign!, OK! )
					
					Error.i_FWError = c_Fatal
					RETURN
				END IF	
			ELSE			
				//Ask if they want to insert a reminder.
				l_nRV = MessageBox( gs_AppName, &
										  'Do you want to set a "Case Carve Out Return" Case Reminder?', &
										  Question!, &
										  YesNo! )
										  
				IF l_nRV = 1 THEN
					l_cReminderID = PARENT.fw_GetKeyValue( "reminders" )
					l_dtToday = PARENT.fw_GetTimeStamp( )
					l_cUser = OBJCA.WIN.fu_GetLogin( SQLCA )
					
					//If the length of the carve out reason is greater than 255, need to truncate to
					//  fit in the reminders comment field.
					IF Len( Trim( l_cReason ) ) > 255 THEN
						l_cReason = ( Mid( Trim( l_cReason ), 1, 252 )+"..." )
					END IF				
					
					INSERT cusfocus.reminders( reminder_id, 
														reminder_type_id,
														reminder_viewed,
														case_number,
														case_type,
														case_reminder,
														co_id,
														reminder_crtd_date,
														reminder_set_date,
														reminder_subject,
														reminder_comments,
														reminder_dlt_case_clsd,
														reminder_author,
														reminder_recipient )
					VALUES( :l_cReminderID,
							  '1',
							  'N',
							  :i_cCaseNumber,
							  :i_cCaseType,
							  'Y',
							  :l_cCarveID,
							  :l_dtToday,
							  :l_dtEstEnd,
							  'Case Carve Out Return',
							  :l_cReason,
							  'N',
							  :l_cUser,
							  :l_cUser )
					USING SQLCA;
							  
					IF SQLCA.SQLCode <> 0 THEN
						MessageBox( gs_AppName, "Error setting carve out return reminder", Stopsign!, OK! )
						
						Error.i_FWError = c_Fatal
						RETURN
					END IF			
				END IF
			END IF
		END IF
	END IF
	
	PCCA.Parm[1] = '1'
	CLOSE (PARENT)
END IF
end event

type ln_1 from line within w_carve_out
long linecolor = 8421504
integer linethickness = 4
integer beginy = 188
integer endx = 2528
integer endy = 188
end type

type ln_2 from line within w_carve_out
long linecolor = 16777215
integer linethickness = 4
integer beginy = 192
integer endx = 2528
integer endy = 192
end type

type ln_3 from line within w_carve_out
long linecolor = 8421504
integer linethickness = 4
integer beginy = 188
integer endx = 2500
integer endy = 188
end type

type st_1 from statictext within w_carve_out
integer width = 2533
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

type ln_4 from line within w_carve_out
long linecolor = 8421504
integer linethickness = 4
integer beginy = 188
integer endx = 2500
integer endy = 188
end type

type ln_6 from line within w_carve_out
long linecolor = 16777215
integer linethickness = 4
integer beginy = 952
integer endx = 2528
integer endy = 952
end type

type ln_8 from line within w_carve_out
long linecolor = 8421504
integer linethickness = 4
integer beginy = 948
integer endx = 2528
integer endy = 948
end type

type st_3 from statictext within w_carve_out
integer y = 956
integer width = 2533
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217730
boolean focusrectangle = false
end type

