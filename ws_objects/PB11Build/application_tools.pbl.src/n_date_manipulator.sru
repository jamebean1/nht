$PBExportHeader$n_date_manipulator.sru
$PBExportComments$<doc>A utility class that handles the chores of working with dates and datetimes within PowerBuilder. Consult the Developer's website for complete documentation on how you may be able to use this object.
forward
global type n_date_manipulator from nonvisualobject
end type
end forward

global type n_date_manipulator from nonvisualobject
end type
global n_date_manipulator n_date_manipulator

forward prototypes
public function boolean of_check_date (ref datetime adt_reference)
public function date of_date (long al_year, long al_month, long al_day)
public function datetime of_date_add (string as_datepart, long al_number, datetime adt_date)
public function date of_date_add (string as_datepart, long al_number, date ad_date)
public function string of_get_client_dateeditmask ()
public function string of_get_client_dateformat ()
public function string of_get_client_datetimeformat ()
public function string of_get_client_timeformat ()
public function date of_today ()
public function datetime of_get_day_of_month (datetime adt_datetime, string as_firstsecondthirdfourthlast, string as_sundaymondaytuesdaywednesdaythursdayf)
public function date of_get_first_of_month (date ad_date)
public function datetime of_get_first_of_month (datetime adt_date)
public function date of_get_last_of_month (date ad_date)
public function datetime of_get_last_of_month (datetime adt_date)
public function date of_max (date ad_date1, date ad_date2)
public function datetime of_max (datetime adt_datetime1, datetime adt_datetime2)
public function time of_max (time at_time1, time at_time2)
public function date of_min (date ad_date1, date ad_date2)
public function datetime of_min (datetime adt_datetime1, datetime adt_datetime2)
public function time of_min (time at_time1, time at_time2)
public function datetime of_now ()
public function string of_get_timezone_bias ()
end prototypes

public function boolean of_check_date (ref datetime adt_reference);
//-----------------------------------------------------------------------------------------------------------------------------------
//	Message Parm structure for MessageBox message components
//-----------------------------------------------------------------------------------------------------------------------------------
datetime ldt_frmdte, ldt_todte

ldt_frmdte = DateTime(1900-01-01,Time("00:00:00"))
ldt_todte = DateTime(2078-12-31,Time("23:59:00"))

//-----------------------------------------------------------------------------------------------------------------------------------
//	Check if date outside of acceptable date ranges for the smalldatetime datatype.
//-----------------------------------------------------------------------------------------------------------------------------------
If adt_reference < ldt_frmdte or adt_reference > ldt_todte Then
	Return False
Else
	Return True
End If
end function

public function date of_date (long al_year, long al_month, long al_day);
//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure the date is never higher than 31
//-----------------------------------------------------------------------------------------------------------------------------------
al_day = Max(31, al_day)

//-----------------------------------------------------------------------------------------------------------------------------------
// Clip the day based on the month
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case al_month
	Case 4, 6, 9, 11
		al_day = Max(30, al_day)
	Case 2
		If Mod(al_year, 4) > 0 Then
			al_day = Max(28, al_day)
		Else
			al_day = Max(29, al_day)
		End If
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the date
//-----------------------------------------------------------------------------------------------------------------------------------
return Date(al_year, al_month, al_day)
end function

public function datetime of_date_add (string as_datepart, long al_number, datetime adt_date);
/*Table of Valid Arguments to the Procedure
Datepart		Abbv	Valid Range
-----------------------------
year			yy		1753-9999
quarter		qq		1-4
month			mm		1-12
day of year	dy		1-366
day			dd		1-31
week			wk		1-53
weekday		dw		1-7 (Sun.-Sat.)
hour			hh		0-23
minute		mi		0-59
second		ss		0-59
millisecond	ms		0-999 */

DECLARE lsp_date_manipulator PROCEDURE FOR sp_datemanipulator
        @sdt_date = :adt_date,
        @vc20_datepart = :as_datepart,
        @i_number = :al_number;

EXECUTE lsp_date_manipulator;

FETCH lsp_date_manipulator INTO :adt_date;

CLOSE lsp_date_manipulator;

Return adt_date
end function

public function date of_date_add (string as_datepart, long al_number, date ad_date);
/*Table of Valid Arguments to the Procedure
Datepart		Abbv	Valid Range
-----------------------------
year			yy		1753-9999
quarter		qq		1-4
month			mm		1-12
day of year	dy		1-366
day			dd		1-31
week			wk		1-53
weekday		dw		1-7 (Sun.-Sat.)
hour			hh		0-23
minute		mi		0-59
second		ss		0-59
millisecond	ms		0-999 */

time t_time

t_time = Time("00:00:00")

ad_date = Date(of_date_add(as_datepart,al_number,DateTime(ad_date,t_time)))

Return ad_date
end function

public function string of_get_client_dateeditmask ();
string s_dateformat
//n_string_functions ln_string

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the windows shortdate format.
//-----------------------------------------------------------------------------------------------------------------------------------
RegistryGet("HKEY_CURRENT_USER\Control Panel\International","sShortDate",RegString!,s_dateformat)

s_dateformat = lower(s_dateformat)

if pos(s_dateformat,'mm') = 0 and pos (s_dateformat,'m') > 0 then 
	gn_globals.in_string_functions.of_replace_all(s_dateformat,'m','mm')
end if

if pos(s_dateformat,'dd') = 0 and pos (s_dateformat,'d') > 0 then 
	gn_globals.in_string_functions.of_replace_all(s_dateformat,'d','dd')
end if

Return s_dateformat


end function

public function string of_get_client_dateformat ();

string s_dateformat

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the windows shortdate format.
//-----------------------------------------------------------------------------------------------------------------------------------
RegistryGet("HKEY_CURRENT_USER\Control Panel\International","sShortDate",RegString!,s_dateformat)

Return s_dateformat


end function

public function string of_get_client_datetimeformat ();
string s_timeformat

Return this.of_get_client_dateformat() + " " + this.of_get_client_timeformat()
end function

public function string of_get_client_timeformat ();
string s_timeformat

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the windows shortdate format.
//-----------------------------------------------------------------------------------------------------------------------------------
RegistryGet("HKEY_CURRENT_USER\Control Panel\International","sTimeFormat",RegString!,s_timeformat)

Return s_timeformat
end function

public function date of_today ();
Return Date(this.of_now())

end function

public function datetime of_get_day_of_month (datetime adt_datetime, string as_firstsecondthirdfourthlast, string as_sundaymondaytuesdaywednesdaythursdayf);
//-----------------------------------------------------------------------------------------------------------------------------------
// Local Varibles
//-----------------------------------------------------------------------------------------------------------------------------------
DateTime ldt_null
Date 		ld_result
Long 		ll_daynumber, ll_referencedaynumber, ll_daystoincrement

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the daynumber based on the string day passed in
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_sundaymondaytuesdaywednesdaythursdayf))
	Case 'sunday'
		ll_daynumber = 1
	Case 'monday'
		ll_daynumber = 2		
	Case 'tuesday'
		ll_daynumber = 3	
	Case 'wednesday'
		ll_daynumber = 4		
	Case 'thursday'
		ll_daynumber = 5		
	Case 'friday'
		ll_daynumber = 6		
	Case 'saturday'
		ll_daynumber = 7		
	Case Else
		Return ldt_null
End Choose


//-----------------------------------------------------------------------------------------------------------------------------------
// Find the right day of the month
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case Lower(Trim(as_firstsecondthirdfourthlast))
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we are not doing last dddd of the month, we start with the first day of the month and move forward
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'first', 'second', 'third', 'fourth'
		ld_result 	= Date(This.of_get_first_of_month(adt_datetime))
		ll_referencedaynumber = DayNumber(ld_result)

		If ll_referencedaynumber <= ll_daynumber Then
			ll_daystoincrement = ll_daynumber - ll_referencedaynumber
		Else
			ll_daystoincrement = 7 - (ll_referencedaynumber - ll_daynumber)
		End If

		Choose Case Lower(Trim(as_firstsecondthirdfourthlast))
		Case 'second'
			ll_daystoincrement = ll_daystoincrement + 7
		Case 'third'
			ll_daystoincrement = ll_daystoincrement + 14
		Case 'fourth'
			ll_daystoincrement = ll_daystoincrement + 21
		End Choose
		
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If we are doing last dddd of the month, we start with the last day of the month and move backward
	//-----------------------------------------------------------------------------------------------------------------------------------
	Case 'last'
		ld_result = Date(This.of_get_last_of_month(adt_datetime))
		ll_referencedaynumber = DayNumber(ld_result)

		If ll_referencedaynumber >= ll_daynumber Then
			ll_daystoincrement = ll_daynumber - ll_referencedaynumber
		Else
			ll_daystoincrement = - (7 - (ll_daynumber - ll_referencedaynumber))
		End If
	
	Case Else
		Return ldt_null
End Choose

Return DateTime(RelativeDate(ld_result, ll_daystoincrement), Time(adt_datetime))



end function

public function date of_get_first_of_month (date ad_date);

Return date(year(ad_date), month(ad_date), 1)
end function

public function datetime of_get_first_of_month (datetime adt_date);
date d_date
time t_time

d_date = this.of_get_first_of_month(date(adt_date))

t_time = Time("00:00:00")

Return datetime(d_date,t_time)

end function

public function date of_get_last_of_month (date ad_date);

if month(ad_date) = 12 then
	return date(year(ad_date), 12, 31)
else
	return relativedate(date(year(ad_date), month(ad_date) + 1, 1), -1)
end if


//Return relativedate(relativedate(relativedate(ad_date, 15 - day(ad_date)),30),-day(relativedate(relativedate(ad_date, 15 - day(ad_date)),30)))

//long l_month, l_year
//string s_date
//date d_date
//time t_time
//
//l_month = month(ad_date)
//l_year = year(ad_date)
//
//If l_month = 12 Then
//	l_month = 1
//	l_year = l_year + 1
//Else
//	l_month = l_month + 1
//End If
//
//s_date = string(l_month) + "/01/" + string(l_year)
//
//d_date = Date(s_date)
//
//d_date = RelativeDate(d_date,-1) 
//Return d_date
end function

public function datetime of_get_last_of_month (datetime adt_date);
date d_date
time t_time

d_date = this.of_get_last_of_month(date(adt_date))

t_time = Time("23:59:00")

Return datetime(d_date,t_time)

end function

public function date of_max (date ad_date1, date ad_date2);
If ad_date1 > ad_date2 Then
	Return ad_date1
Else
	Return ad_date2
End If
end function

public function datetime of_max (datetime adt_datetime1, datetime adt_datetime2);
If adt_datetime1 > adt_datetime2 Then
	Return adt_datetime1
Else
	Return adt_datetime2 
End If
end function

public function time of_max (time at_time1, time at_time2);
If at_time1 > at_time2 Then
	Return at_time1
Else
	Return at_time2
End If
end function

public function date of_min (date ad_date1, date ad_date2);
If ad_date1 < ad_date2 Then
	Return ad_date1
Else
	Return ad_date2
End If
end function

public function datetime of_min (datetime adt_datetime1, datetime adt_datetime2);
If adt_datetime1 < adt_datetime2 Then
	Return adt_datetime1
Else
	Return adt_datetime2 
End If
end function

public function time of_min (time at_time1, time at_time2);

If at_time1 < at_time2 Then
	Return at_time1
Else
	Return at_time2
End If
end function

public function datetime of_now ();

datetime ldt_now

DECLARE lsp_getdatetime PROCEDURE FOR sp_getdatetime;
	 
EXECUTE lsp_getdatetime;
	 
Fetch lsp_getdatetime into :ldt_now;
	 
CLOSE lsp_getdatetime;

Return ldt_now
end function

public function string of_get_timezone_bias ();

string	ls_bias
long		ll_bias
long		ll_hour,ll_min
//n_win32_api_calls ln_win32

//ln_win32 = create n_win32_api_calls

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the windows shortdate format.  It it stored in minutes.
//-----------------------------------------------------------------------------------------------------------------------------------
//ll_bias = ln_win32.of_get_timezone_bias() * -1

//-----------------------------------------------------------------------------------------------------------------------------------
// Convert minutes to an hhmm string.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_hour = truncate(ll_bias/60,0)
ll_min = (ll_bias - (ll_hour * 60))
ll_min = sign(ll_min) * ll_min //makes this part positive

ls_bias = string(ll_hour,"00") + string(ll_min,"00")
if len(ls_bias) = 4 then ls_bias = '+' + ls_bias

//destroy ln_win32

Return ls_bias
end function

on n_date_manipulator.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_date_manipulator.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

