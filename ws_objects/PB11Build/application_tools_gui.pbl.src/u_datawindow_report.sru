$PBExportHeader$u_datawindow_report.sru
forward
global type u_datawindow_report from u_datawindow
end type
end forward

global type u_datawindow_report from u_datawindow
boolean automaticallypresentrightclickmenu = true
event type long ue_get_rprtcnfgid ( )
event ue_timer ( )
end type
global u_datawindow_report u_datawindow_report

type variables
Protected:
	n_report Properties
	
	n_timer 		in_timer
	DateTime		idt_NextRefresh
	String		is_RecurrenceString	= ''
	Boolean		ib_AutoRefreshIsOn	= False
end variables

forward prototypes
public subroutine of_set_properties (n_report an_report)
public function n_report of_get_properties ()
public function datetime of_getrefreshtime ()
public function boolean of_hsplitscroll ()
public function boolean of_isautorefreshon ()
end prototypes

event type long ue_get_rprtcnfgid();Return Properties.RprtCnfgID
end event

event ue_timer();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_timer
//	Overrides:  No
//	Arguments:	
//	Overview:   This will occur when the timer event happens
//	Created by: Blake Doerr
//	History:    6/19/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
DateTime ldt_now
Long		ll_setrow
Long		ll_scrolltorow
Long		ll_rowcount
Long		ll_lastrowonpage

ldt_now = DateTime(Today(), Now())

If ldt_now > idt_NextRefresh And ib_AutoRefreshIsOn Then
	ll_setrow = This.GetRow()
	ll_scrolltorow 	= Long(This.Describe("DataWindow.FirstRowOnPage"))
	ll_lastrowonpage	= Long(This.Describe("DataWindow.LastRowOnPage"))
	ll_rowcount = This.RowCount()
	
	Parent.Dynamic Event ue_notify('button clicked', 'retrieve')
	This.Event ue_notify('reset timer', '')
	
	If This.RowCount() <= 0 Then Return
	
	If ll_lastrowonpage = ll_rowcount And ll_scrolltorow > 1 Then
		ll_scrolltorow = This.RowCount()
	End If
	
	If ll_setrow = ll_rowcount Then
		ll_setrow = This.RowCount()
	End If
	
	If Not IsNull(ll_scrolltorow) And ll_scrolltorow > 1 Then
		This.ScrollToRow(Min(This.RowCount(), ll_scrolltorow))
	End If
	
	If Not IsNull(ll_setrow) And ll_setrow > 1 Then
		This.SetRow(Min(This.RowCount(), ll_setrow))
	End If
End If

Parent.Dynamic Event ue_notify('set rowcount', '')

If Not ib_AutoRefreshIsOn Then Destroy in_timer
end event

public subroutine of_set_properties (n_report an_report);Properties = an_report
end subroutine

public function n_report of_get_properties ();Return Properties
end function

public function datetime of_getrefreshtime ();Return idt_NextRefresh
end function

public function boolean of_hsplitscroll ();Return This.HSplitScroll
end function

public function boolean of_isautorefreshon ();Return ib_AutoRefreshIsOn
end function

on u_datawindow_report.create
call super::create
end on

on u_datawindow_report.destroy
call super::destroy
end on

event retrievestart;call super::retrievestart;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      retrievestart
// Overrides:  Yes
// Overview:   Connects the datawindow to the database using the reporting transaction object.
// Created by: Blake Doerr
// History:    01/26/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
long 		l_rtrn
String 	ls_dataobject
String	ls_storagepagesize

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

ib_WeAreRetrieving = True

//-----------------------------------------------------------------------------------------------------------------------------------
// If the ancestor rejected the retrieve, return the return value
//-----------------------------------------------------------------------------------------------------------------------------------
If AncestorReturnValue = 1 Then
	ib_WeAreRetrieving = False
	Return AncestorReturnValue
End If

//If Properties.TrackStatistics Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_begin_parent(Properties.Name + ' (Retrieving Report)', 'Reporting')
//	End If
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the current page storage size
//-----------------------------------------------------------------------------------------------------------------------------------
ls_storagepagesize = This.Describe("Datawindow.storagepagesize")
ls_storagepagesize = Trim(Mid(ls_storagepagesize, Pos(ls_storagepagesize, '=') + 1))

//-----------------------------------------------------------------------------------------------------------------------------------
// Modify the storage size if necessary
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Long(ls_storagepagesize)
	Case Is < 33000
		If Properties.IsLargeReport Then This.Modify("datawindow.storagepagesize='LARGE'")
	Case Else
		If Not Properties.IsLargeReport Then This.Modify("datawindow.storagepagesize='MEDIUM'")
End Choose

//-----------------------------------------------------
// Set the transactionobject
//-----------------------------------------------------
This.SetTransObject(Properties.TransactionObject)

//----------------------------------------------------------------------------------------------------------------------------------
// Show the status of the process in the status bar
// It is important to start with 0 (it makes the status bar visible) and end with
// 100 (It makes the status bar invisible)
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not gb_runningasaservice Then
//	w_frame.of_position_statusbar('Retrieving Data',0)
//	w_frame.of_position_statusbar('Retrieving Data',25)
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// If the ancestor rejected the retrieve, return the return value
//-----------------------------------------------------------------------------------------------------------------------------------
if AncestorReturnValue = 2 then Return AncestorReturnValue
end event

event retrieveend;call super::retrieveend;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      retrievend
// Overrides:  Yes
// Overview:   Refresh the filter object and redirect the event to the rowfocusservice
// Created by: Blake Doerr
// History:    01/26/1998 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_count
Long		ll_null
SetNull(ll_null)

ib_WeAreRetrieving = True

//-----------------------------------------------------------------------------------------------------------------------------------
// Track statistics for the report events
//-----------------------------------------------------------------------------------------------------------------------------------
//If Properties.TrackStatistics And Not IsNull(Properties.RetrieveStartDateTime) Then
//	If gn_globals.in_performance_statistics_manager.of_are_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_get_statistics_object().of_end_parent(Properties.Name + ' (Retrieving Report)')
//	End If
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Store the retrieval time for statistics
//-----------------------------------------------------------------------------------------------------------------------------------
//If Properties.TrackStatistics And Not IsNull(Properties.RetrieveStartDateTime) Then
//	If gn_globals.in_performance_statistics_manager.of_are_report_statistics_on() Then
//		gn_globals.in_performance_statistics_manager.of_add_reportstatistics(Properties.RprtCnfgID, Properties.RetrieveStartDateTime, DateTime(Today(), Now()), rowcount, Properties.UserID, Properties.ReportDatabaseID, ll_null, ll_null, This.is_LastSQLPreview)
//	End If
//End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Modify the status bar
//-----------------------------------------------------------------------------------------------------------------------------------
//If Not gb_runningasaservice Then
//	w_mdi.of_position_statusbar('Retrieving Data',70)
//	w_mdi.of_position_statusbar('Done',90)
//	w_mdi.of_position_statusbar('Done',100)
////End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Publish a message so that others can respond
//-----------------------------------------------------------------------------------------------------------------------------------
If IsValid(gn_globals.in_subscription_service) Then
	gn_globals.in_subscription_service.of_message('retrieveend', This, This)
End If

ib_WeAreRetrieving = False
end event

event itemfocuschanged;call super::itemfocuschanged;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ItemFocusChanged
//	Overrides:  No
//	Arguments:	
//	Overview:   Selects the text in the column when the focus changes to it.
//	Created by: Scott Creed
//	History:    8.20.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

this.selecttext( 1, 2000)

end event

event ue_notify;call super::ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:        ue_notify
// Overrides:  No
// Arguments:	as_message (String)    - The message being triggered
//		aany_argument (Any) - The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   2/24/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Window lw_window
//n_string_functions ln_string_functions
//n_recurrence ln_recurrence
long ll_return
boolean lb_current_refresh_state
string ls_RecurrenceString

Choose Case Lower(Trim(as_message))
	Case 'horizontalsplitscrolling'
		If IsValid(This.Object) Then
			This.HSplitScroll = Not This.HSplitScroll
			If This.HSplitScroll Then 
				This.Object.DataWindow.HorizontalScrollSplit = 500
			End If
		End If
		
	Case 'toggle autorefresh data', 'set autorefresh time'
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Store the current refresh state so that it can be restored if the user cancels out of the window
		//-----------------------------------------------------------------------------------------------------------------------------------
		lb_current_refresh_state = ib_AutoRefreshIsOn

		If Lower(Trim(as_message)) = 'toggle autorefresh data' Then
			ib_AutoRefreshIsOn = Not ib_AutoRefreshIsOn
			If Not ib_AutoRefreshIsOn Then
				If IsValid(in_timer) Then Destroy in_timer
				Parent.Dynamic Event ue_notify('set rowcount', '')
				Return
			End If
		End If
		
		ib_AutoRefreshIsOn = True

		OpenWithParm(lw_window, is_RecurrenceString, 'w_recurrence', w_mdi)
		ls_RecurrenceString = Message.StringParm
		ll_return = Message.DoubleParm
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If the user cancelled out of the window, then restore the refresh state
		//-----------------------------------------------------------------------------------------------------------------------------------
		if ll_return = -1 then 
			ib_AutoRefreshIsOn = lb_current_refresh_state
			Return
		End IF

		If IsNull(ls_RecurrenceString) Or ls_RecurrenceString = '' Then
			is_RecurrenceString = ''
			ib_AutoRefreshIsOn = False
			Parent.Dynamic Event ue_notify('set rowcount', '')
			Return
		else
			//-----------------------------------------------------------------------------------------------------------------------------------
			// Store the new recurrence pattern
			//-----------------------------------------------------------------------------------------------------------------------------------
			is_RecurrenceString = ls_RecurrenceString
		End If
		
		This.Event ue_notify('reset timer', '')
		
	Case 'reset timer'
		If IsValid(in_timer) Then Destroy in_timer
		
		If Not ib_AutoRefreshIsOn Then Return
		
		gn_globals.in_string_functions.of_replace_argument('StartDate', is_RecurrenceString, '||', String(Today()))
		gn_globals.in_string_functions.of_replace_argument('StartTime', is_RecurrenceString, '||', String(Now()))

//		ln_recurrence = Create n_recurrence
//		idt_NextRefresh = ln_recurrence.of_determine_datetime(is_RecurrenceString, True)
//		Destroy ln_recurrence
		in_timer = Create n_timer
		in_timer.of_set_event(This, 'ue_timer')
		in_timer.of_start(5)
		This.Event ue_notify('set rowcount', '')
End Choose

end event

event destructor;call super::destructor;If IsValid(in_timer) Then Destroy in_timer
end event

