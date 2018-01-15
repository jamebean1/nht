$PBExportHeader$n_appealdetail_duedate.sru
forward
global type n_appealdetail_duedate from nonvisualobject
end type
end forward

global type n_appealdetail_duedate from nonvisualobject
end type
global n_appealdetail_duedate n_appealdetail_duedate

type variables
string 	is_use_case_time
end variables

forward prototypes
public function datetime of_get_due_date (long al_datetermid)
public function datetime of_recalculate_due_date (long al_datetermid, datetime adt_start_datetime)
public function datetime of_get_due_date (long al_datetermid, datetime adt_startdate)
public function long of_get_weekend_days (datetime adt_start, datetime adt_end, long al_days)
public function long of_get_ignored_days (long al_datetermid, datetime adt_startdate, datetime adt_enddate)
public function datetime of_get_reminder_due_date (long al_datetermid, datetime adt_startdate)
public function string of_check_timer_setting ()
public function datetime of_get_caselog_time (long al_casenumber)
public function long of_isweekendday (datetime adt_datetime)
end prototypes

public function datetime of_get_due_date (long al_datetermid);datastore	lds_dateterm
datetime		ldt_now, ldt_duedate
long			ll_hours, ll_ignored_days


lds_dateterm = Create datastore
lds_dateterm.DataObject = 'd_data_dateterm'
lds_dateterm.SetTransObject(SQLCA)
lds_dateterm.Retrieve(al_datetermid)

ldt_now = gn_globals.in_date_manipulator.of_now()

If lds_dateterm.RowCount() > 0 Then
	ll_hours = lds_dateterm.GetItemNumber(1, 'NumberHours')
	
	ldt_duedate = gn_globals.in_date_manipulator.of_date_add('HOUR', ll_hours, ldt_now)
	
	ll_ignored_days = of_get_ignored_days(al_datetermid, ldt_now, ldt_duedate)
	
	If ll_ignored_days > 0 Then
		ldt_duedate = gn_globals.in_date_manipulator.of_date_add('DAY', ll_ignored_days, ldt_duedate)
	End If
	
End If


Destroy lds_dateterm


Return ldt_duedate
end function

public function datetime of_recalculate_due_date (long al_datetermid, datetime adt_start_datetime);datetime ldt_duedate
datastore	lds_dateterm
long			ll_hours, ll_ignored_days


lds_dateterm = Create datastore
lds_dateterm.DataObject = 'd_data_dateterm'
lds_dateterm.SetTransObject(SQLCA)
lds_dateterm.Retrieve(al_datetermid)

If lds_dateterm.RowCount() > 0 Then
	ll_hours = lds_dateterm.GetItemNumber(1, 'NumberHours')
	
	ldt_duedate = gn_globals.in_date_manipulator.of_date_add('HOUR', ll_hours, adt_start_datetime)
	
	ll_ignored_days = of_get_ignored_days(al_datetermid, adt_start_datetime, ldt_duedate)
	
	If ll_ignored_days > 0 Then
		ldt_duedate = gn_globals.in_date_manipulator.of_date_add('DAY', ll_ignored_days, ldt_duedate)
	End If
	
End If


Destroy lds_dateterm

Return ldt_duedate
end function

public function datetime of_get_due_date (long al_datetermid, datetime adt_startdate);datastore	lds_dateterm
datetime		ldt_now, ldt_duedate
long			ll_hours, ll_ignored_days, ll_weekend_days

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the datastore and retrieve it for this datetermID
//-----------------------------------------------------------------------------------------------------------------------------------
lds_dateterm = Create datastore
lds_dateterm.DataObject = 'd_data_dateterm'
lds_dateterm.SetTransObject(SQLCA)
lds_dateterm.Retrieve(al_datetermid)

//-----------------------------------------------------------------------------------------------------------------------------------
// If you find a row then get the number of hours for this term
//-----------------------------------------------------------------------------------------------------------------------------------
If lds_dateterm.RowCount() > 0 Then
	ll_hours = lds_dateterm.GetItemNumber(1, 'NumberHours')
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If it is a term that used Days instead of hours, then multiply the value by 24 to get an hour figure for the days
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lower(lds_dateterm.GetItemString(1, 'timeunit')) = 'd' Then ll_hours = ll_hours * 24
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add the number of hours to the start date that was passed in
	//-----------------------------------------------------------------------------------------------------------------------------------
	ldt_duedate = gn_globals.in_date_manipulator.of_date_add('HOUR', ll_hours, adt_startdate)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If weekends are not used in this calculation, find out how many weekend days are between the
	// start date and due date and then add those days to the due date
	//
	// If the number is more than 7 we will need to redo the calculation - Something to think about
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lds_dateterm.GetItemString(1, 'WeekendsUsed') = 'N' Then
		ll_weekend_days = of_get_weekend_days(adt_startdate, ldt_duedate, 0)

		//Fixing bug at Western.
		// When calculating the number of weekend days, you need to get the number of days, then add it and recheck the number of days
		// as it isn't taking into account some of the days it is adding could be weekend days. Elegant solution forthcoming, but this 
		// should fix the problem in the meantime with minimal impact.
		long ll_weekend_days2
		ll_weekend_days2 = of_get_weekend_days(adt_startdate, gn_globals.in_date_manipulator.of_date_add('DAY', ll_weekend_days, ldt_duedate), 0)
		
		If ll_weekend_days2 > 0 Then
			ldt_duedate = gn_globals.in_date_manipulator.of_date_add('DAY', ll_weekend_days2, ldt_duedate)
		End If
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the number of ignored days that fall between the start date and the due date
	//-----------------------------------------------------------------------------------------------------------------------------------
	ll_ignored_days = of_get_ignored_days(al_datetermid, adt_startdate, ldt_duedate)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If ignored days were found then add them to the due date
	//-----------------------------------------------------------------------------------------------------------------------------------
	If ll_ignored_days > 0 Then
		ldt_duedate = gn_globals.in_date_manipulator.of_date_add('DAY', ll_ignored_days, ldt_duedate)
	End If

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Check to see if weekends are used. If they are not used, then ensure the due date doesn't fall on a Saturday or Sunday.
	//-----------------------------------------------------------------------------------------------------------------------------------
	If lower(lds_dateterm.GetItemString(1, 'WeekendsUsed')) = 'n' Then
			If of_isweekendday(ldt_duedate) = 1 Then
				ldt_duedate = gn_globals.in_date_manipulator.of_date_add('DAY', 1, ldt_duedate)
				
				If of_isweekendday(ldt_duedate) = 1 Then
					ldt_duedate = gn_globals.in_date_manipulator.of_date_add('DAY', 1, ldt_duedate)
				End If
			End If
	End If

End If


Destroy lds_dateterm


Return ldt_duedate
end function

public function long of_get_weekend_days (datetime adt_start, datetime adt_end, long al_days);long	ll_days

DECLARE lsp_count_weekend_days PROCEDURE FOR sp_count_weekend_days
        @adt_start = :adt_start,
        @adt_end = :adt_end;

EXECUTE lsp_count_weekend_days;

FETCH lsp_count_weekend_days INTO :ll_days;

CLOSE lsp_count_weekend_days;

Return ll_days


end function

public function long of_get_ignored_days (long al_datetermid, datetime adt_startdate, datetime adt_enddate);long	ll_ignored_days, ll_rowcount
datastore	lds_dateterm

lds_dateterm = Create datastore
lds_dateterm.DataObject = 'd_data_datetermdateexclusion'
lds_dateterm.SetTransObject(SQLCA)
lds_dateterm.Retrieve(al_datetermid, adt_startdate, adt_enddate)

ll_rowcount = lds_dateterm.RowCount()

If ll_rowcount > 0 Then
	//Get the number of these days that fall between the start date and end date
	
	
	ll_ignored_days = ll_rowcount
Else
	ll_ignored_days = 0	
End If



Destroy lds_dateterm

Return ll_ignored_days
end function

public function datetime of_get_reminder_due_date (long al_datetermid, datetime adt_startdate);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  al_datetermid	- 	The datetermID that this event uses
//					adt_startdate	-	The date the event starts on.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Joel White
//	History: 	9/23/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datetime		ldt_duedate
long			ll_reminderhours
datastore	lds_dateterm

lds_dateterm = Create datastore
lds_dateterm.DataObject = 'd_data_dateterm'
lds_dateterm.SetTransObject(SQLCA)
lds_dateterm.Retrieve(al_datetermid)


If lds_dateterm.RowCount() > 0 Then
	ll_reminderhours = lds_dateterm.GetItemNumber(1, 'reminderhours') * -1
	
	ldt_duedate = gn_globals.in_date_manipulator.of_date_add('hour', ll_reminderhours, adt_startdate)
	
End If


return ldt_duedate
end function

public function string of_check_timer_setting ();//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  None
//	Overview:   This function gets the value from System_Options for the New Appeal System.
//	Created by:	Joel White
//	History: 	9/2/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


string ls_use_case_time

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the value for the 'new appeal system' from the System_Options table
//-----------------------------------------------------------------------------------------------------------------------------------
SELECT option_value
  INTO :ls_use_case_time
  FROM cusfocus.system_options
 WHERE option_name = 'appeal timer'
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
		Return 'N'
	CASE 0
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Good things happened.
		//-----------------------------------------------------------------------------------------------------------------------------------\
		Return ls_use_case_time
	CASE 100
		//-----------------------------------------------------------------------------------------------------------------------------------
		// No value was found for the 'new appeal system' record in the System_Options table
		//-----------------------------------------------------------------------------------------------------------------------------------
		MessageBox (gs_appname, 'The configuration record for new appeal system was not found.')
		Return 'N'
End Choose
end function

public function datetime of_get_caselog_time (long al_casenumber);long ll_casenumber
datetime ldt_case_time


  SELECT cusfocus.case_log.case_log_opnd_date  
    INTO :ldt_case_time  
    FROM cusfocus.case_log  
   WHERE cusfocus.case_log.case_number = :al_casenumber   
           ;

Return ldt_case_time

end function

public function long of_isweekendday (datetime adt_datetime);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  adt_datetime 	- The date to be checked to see if it falls on a weekend day
//	Overview:   This script takes a date and ensures the date doesn't fall on a weekend day.
//	Created by:	Joel White
//	History: 	1/31/2006 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_return

ll_return = 0


string	ls_isweekendday

DECLARE lsp_isweekendday PROCEDURE FOR sp_isweekendday
        @adt_date = :adt_datetime;

EXECUTE lsp_isweekendday;

FETCH lsp_isweekendday INTO :ls_isweekendday;

CLOSE lsp_isweekendday;

If ls_isweekendday = 'Y' Then
	ll_return = 1
End If

Return ll_return
end function

on n_appealdetail_duedate.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_appealdetail_duedate.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
is_use_case_time = of_check_timer_setting()

end event

