$PBExportHeader$n_objca_date.sru
$PBExportComments$Date utilities data store
forward
global type n_objca_date from n_objca_mgr
end type
end forward

global type n_objca_date from n_objca_mgr
string dataobject = ""
end type
global n_objca_date n_objca_date

type variables
//-----------------------------------------------------------------------------------------
//  Date Constants
//-----------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------
//  Date Instance Variables
//-----------------------------------------------------------------------------------------

INTEGER	i_NumWeekDays	= 5
INTEGER	i_WeekDays[] 	= {2, 3, 4, 5, 6}

INTEGER	i_NumWeekEnds	= 2
INTEGER	i_WeekEnds[]	= {7, 1}

INTEGER	i_NumHolidays	= 0
STRING		i_HolidayName[]
DATE		i_HolidayDate[]

TIME		i_WorkDayStart[7]
TIME		i_WorkDayEnd[7]

INTEGER	i_NumSchedules
INTEGER	i_ScheduleDay[]
STRING		i_ScheduleName[]
TIME		i_ScheduleStart[]
TIME		i_ScheduleEnd[]


end variables

forward prototypes
public function string fu_setdateoracle (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string)
public function string fu_setdatesqlserver (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string)
public function string fu_setdatewatcom (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string)
public function string fu_setdatexdb (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string)
public function integer fu_setweekday (integer begin_day, integer end_day)
public function integer fu_setweekend (integer begin_day, integer end_day)
public function integer fu_setholiday (string holiday_name, date holiday_date)
public function integer fu_setworkday (integer day_of_the_week, time begin_time, time end_time)
public function long fu_datetojulian (date calendar_date, boolean use_current_year)
public function date fu_juliantodate (long julian_date, boolean use_current_year)
public function boolean fu_verifyleap (date calendar_date)
public function date fu_getholiday (string holiday_name, integer holiday_year)
public function string fu_getnextholiday (date calendar_date)
public function boolean fu_verifybegofmonth (date calendar_date)
public function boolean fu_verifyendofmonth (date calendar_date)
public function boolean fu_verifyweekday (date calendar_date)
public function boolean fu_verifyweekend (date calendar_date)
public function date fu_getendofmonth (date calendar_date)
public subroutine fu_getdatepartsfromjulian (long julian_date, boolean use_current_year, ref integer calendar_day, ref integer calendar_month, ref integer calendar_year)
public function date fu_getbegofweekday (date calendar_date)
public function date fu_getbegofweekend (date calendar_date)
public function date fu_getendofweekday (date calendar_date)
public function date fu_getendofweekend (date calendar_date)
public function date fu_addmonths (date calendar_date, long add_months)
public function date fu_addweeks (date calendar_date, long add_weeks)
public function time fu_secondstotime (long seconds)
public function long fu_timetoseconds (time time_of_day)
public subroutine fu_gettimepartsfromseconds (long seconds_of_day, ref long hours, ref long minutes, ref long seconds)
public function boolean fu_verifyholiday (date calendar_date)
public function integer fu_deleteschedule (integer day_of_the_week, string schedule_name)
public function integer fu_resetschedule (integer day_of_the_week)
public function integer fu_setschedule (integer day_of_the_week, string schedule_name, time begin_time, time end_time)
public function boolean fu_verifyschedule (integer day_of_the_week, time time_of_day)
public function boolean fu_verifyworkday (integer day_of_the_week, time time_of_day)
public function string fu_getschedule (integer day_of_the_week, time time_of_day)
public function time fu_getendofschedule (integer day_of_the_week, string schedule_name)
public function time fu_getbegofschedule (integer day_of_the_week, string schedule_name)
public function integer fu_verifyweek ()
public function string fu_setdatedb (string column_string, string date_string, string date_format, string relative_operator, transaction transaction_object)
end prototypes

public function string fu_setdateoracle (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetDateOracle
//  Description   : Format a date/datetime comparison string
//                  to be used in a WHERE clause for ORACLE.
//                  If the Time String is blank, use TRUNC
//                  function to truncate the time data. Else
//                  use DATETIME function to Convert DateTime
//                  string for ORACLE
//
//  Parameters    : STRING Month_String - 
//                     String containing the month value.
//
//                  STRING Day_String - 
//                     String containing the day value.
//
//                  STRING Year_String - 
//                     String containing the year value.
//
//                  STRING Hour_String - 
//                     String containing the hour value.
//
//                  STRING Minute_String - 
//                     String containing the minute value.
//
//                  STRING Second_String - 
//                     String containing the seconds value.
//
//                  STRING Fraction_String - 
//                     String containing the fractions value.
//
//                  STRING Meridian_String - 
//                     String containing the meridian indicator.
//
//                  STRING Relative_Operator - 
//                     String containing a valid relative operator.
//
//                  STRING Column_String - 
//                     String containing the column name.
//
//  Return Value  : STRING l_Compare_String - 
//                     The column name, relative operator,
//                     and Date or datetime string formatted for
//                     use in WHERE clause for ORACLE.
//
//  Change History:
//
//  Date       Person      Description of Change
//  --------   ----------- -----------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All rights reserved.
//******************************************************************

STRING l_compare_string, l_Hour_Format, l_Time_String, l_Date_Format

//------------------------------------------------------------------
// Examine the Month_String and translate to ORACLE default format.
//------------------------------------------------------------------

IF IsNumber(Month_String) THEN
   CHOOSE CASE Month_String
      CASE "01" , "1"
         Month_String = "JAN"
      CASE "02" , "2"
         Month_String = "FEB"
      CASE "03" , "3"
         Month_String = "MAR"
      CASE "04" , "4"
         Month_String = "APR"
      CASE "05" , "5"
         Month_String = "MAY"
      CASE "06" , "6"
         Month_String = "JUN"
      CASE "07" , "7"
         Month_String = "JUL"
      CASE "08" , "8"
         Month_String = "AUG"
      CASE "09" , "9"
         Month_String = "SEP"
      CASE "10"
         Month_String = "OCT"
      CASE "11"
         Month_String = "NOV"
      CASE "12"
         Month_String = "DEC"
   END CHOOSE
ELSE

   // Month_String is not a number

   CHOOSE CASE Len(Month_String)
      CASE IS > 3
         Month_String = Left(Month_String, 3)
   END CHOOSE
END IF

//------------------------------------------------------------------
//  Determine the date format.
//------------------------------------------------------------------

IF Len(Year_String) = 2 THEN
	l_Date_Format = "DD-MON-YY"
ELSE
	l_Date_Format = "DD-MON-YYYY"
END IF

//------------------------------------------------------------------
//  Build compare string based on whether or not the Hour_String
//  is blank.
//------------------------------------------------------------------

CHOOSE CASE Hour_String

   CASE ""

      l_compare_string = "TRUNC(" + Column_String + ")" + " " + &
         Relative_Operator + " " + "TO_DATE('" + Day_String + "-"     + &
         Month_String + "-" + Year_String + "', '" + l_Date_Format + "')"

   CASE ELSE

      //------------------------------------------------------------
      // Add current century to 2 digit years since time parameters
      // are non-blank
      //------------------------------------------------------------

      IF Len(Year_String) = 2 THEN
         Year_String = &
            Left(Right(String(Year(Today())), 4), 2) + Year_String
      END IF

      //------------------------------------------------------------
      // String the time parameters with delimiters.
      //------------------------------------------------------------

      l_Time_String = Hour_String   + ":" + &
                      Minute_String + ":" + &
                      Second_String

      //------------------------------------------------------------
      // Build time format based on meridian string passed.
      //------------------------------------------------------------

      CHOOSE CASE Meridian_String
         CASE ""
            l_Hour_Format = "HH24:MI:SS"

         CASE "A" , "P"
            Meridian_String = Meridian_String + "M"
            l_Hour_Format   = "HH:MI:SS " + Meridian_String
            l_Time_String   = l_Time_String + " " + Meridian_String

         CASE "AM" , "PM"
            l_Hour_Format = "HH:MI:SS " + Meridian_String
            l_Time_String = l_Time_String + " " + Meridian_String

         CASE ELSE
            l_Hour_Format = "HH:MI:SS"
      END CHOOSE

      //------------------------------------------------------------
      // Build the compare string.
      //------------------------------------------------------------

      l_compare_string = &
         Column_String + " " + &
         Relative_Operator + " " + "TO_DATE('" + Day_String + &
         "-" + Month_String + "-" + Year_String + " " + &
         l_Time_String + "', '" + l_Date_Format + " " + &
         l_Hour_Format + "')"
END CHOOSE

RETURN l_compare_string
end function

public function string fu_setdatesqlserver (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);//***************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetDateSQLServer
//  Description   : Format a date/datetime comparison string
//                  to be used in a WHERE clause for
//                  SQLServer.
//
//  Parameters    : STRING Month_String - 
//                     String containing the month value.
//
//                  STRING Day_String - 
//                     String containing the day value.
//
//                  STRING Year_String - 
//                     String containing the year value.
//
//                  STRING Hour_String -
//                     String containing the hour value.
//
//                  STRING Minute_String - 
//                     String containing the minute value.
//
//                  STRING Second_String - 
//                     String containing the seconds value.
//
//                  STRING Fraction_String - 
//                     String containing the fractions value.
//
//                  STRING Meridian_String - 
//                     String containing the meridian indicator.
//
//                  STRING Relative_Operator - 
//                     String containing a valid relative operator.
//
//                  STRING Column_String - 
//                     String containing the column name.
//
//  Return Value  : STRING l_Compare_String -
//                     The column name, relative operator,
//                     and Date or datetime string formatted for
//                     use in WHERE clause for SQLServer.
//
//  Change History:
//
//  Date       Person      Description of Change
//  --------   ----------- -----------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All rights reserved.
//******************************************************************

INT    l_Counter
STRING l_Select_String, l_Time_String

//------------------------------------------------------------------
// If Month_String is not numeric, translate into default format.
//------------------------------------------------------------------

IF IsNumber(Month_String) THEN
ELSE
   CHOOSE CASE Month_String
      CASE "JAN" , "JANUARY"
         Month_String = "01"
      CASE "FEB" , "FEBRUARY"
         Month_String = "02"
      CASE "MAR" , "MARCH"
         Month_String = "03"
      CASE "APR" , "APRIL"
         Month_String = "04"
      CASE "MAY"
         Month_String = "05"
      CASE "JUN" , "JUNE"
         Month_String = "06"
      CASE "JUL" , "JULY"
         Month_String = "07"
      CASE "AUG" , "AUGUST"
         Month_String = "08"
      CASE "SEP" , "SEPTEMBER"
         Month_String = "09"
      CASE "OCT" , "OCTOBER"
         Month_String = "10"
      CASE "NOV" , "NOVEMBER"
         Month_String = "11"
      CASE "DEC" , "DECEMBER"
         Month_String = "12"
   END CHOOSE
END IF

//------------------------------------------------------------------
// If Month_String is not 2 characters long, pad with leading zero.
//------------------------------------------------------------------

IF Len(Month_String) = 1 THEN
   Month_String = "0" + Month_String
END IF

//------------------------------------------------------------------
// Add current century to 2 digit years.
//------------------------------------------------------------------

IF Len(Year_String) = 2 THEN
   Year_String = &
      Left(Right(String(Year(Today())), 4), 2) + Year_String
END IF

//------------------------------------------------------------------
// Format the compare string based on a blank or non-blank
// Hour_String.
//------------------------------------------------------------------

CHOOSE CASE Hour_String

   CASE ""
      l_Select_String = column_string + " " + &
         Relative_Operator + " '" + Month_String + "/" + &
         Day_String + "/" + Year_String + "'"

   CASE ELSE

      //------------------------------------------------------------
      // Set Fraction_String to 3 characters: 0's if blank, pad with
      // 0's if > 0 and < 3, else truncate to 3 characters.
      //------------------------------------------------------------

      CHOOSE CASE Len(Fraction_String)
         CASE 0
            Fraction_String = "000"
         CASE IS > 3
            Fraction_String = Left(Fraction_String, 3)
         CASE IS > 0
            FOR l_Counter = (Len(Fraction_String) + 1) TO 3
               Fraction_String = Fraction_String + "0"
            NEXT
      END CHOOSE

      //------------------------------------------------------------
      // String time parameters together with delimiters.
      //------------------------------------------------------------

      l_Time_String = Hour_String + ":" + Minute_String + ":" + &
         Second_String + ":" + Fraction_String

      //------------------------------------------------------------
      // Format the Meridian_String, and append to the time string.
      //------------------------------------------------------------

      CHOOSE CASE Meridian_String
         CASE "P" , "A"
            Meridian_String = Meridian_String + "M"
            l_Time_String   = l_Time_String + Meridian_String
         CASE "PM" , "AM"
            l_Time_String = l_Time_String + Meridian_String
      END CHOOSE

      //------------------------------------------------------------
      // Build the compare string.
      //------------------------------------------------------------

      l_Select_String = column_string + " " + &
         Relative_Operator + " " + "CONVERT( DATETIME , " + &
         "~"" + Month_String + "/" + Day_String + "/" + &
         Year_String + " " + l_Time_String + "~")"
END CHOOSE

RETURN l_Select_String
end function

public function string fu_setdatewatcom (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetDateWATCOM
//  Description   : Format a date/datetime comparison string
//                  to be used in a WHERE clause for WATCOM.
//
//  Parameters    : STRING Month_String - 
//                     String containing the month value.
//
//                  STRING Day_String - 
//                     String containing the day value.
//
//                  STRING Year_String - 
//                     String containing the year value.
//
//                  STRING Hour_String - 
//                     String containing the hour value.
//
//                  STRING Minute_String - 
//                     String containing the minute value.
//
//                  STRING Second_String - 
//                     String containing the seconds value.
//
//                  STRING Fraction_String - 
//                     String containing the fractions value.
//
//                  STRING Meridian_String - 
//                     String containing the meridian indicator.
//
//                  STRING Relative_Operator - 
//                     String containing a valid relative operator.
//
//                  STRING Column_String - 
//                     String containing the column name.
//
//  Return Value  : STRING l_Compare_String - 
//                     The column name, relative operator,
//                     and Date or datetime string formatted for
//                     use in WHERE clause for SYBASE SQL AnyWhere.
//
//  Change History:
//
//  Date       Person      Description of Change
//  --------   ----------- -----------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All rights reserved.
//******************************************************************

INT     l_Counter
STRING  l_Select_String, l_Time_String

//------------------------------------------------------------------
// If Month_String is not numeric, translate into default format.
//------------------------------------------------------------------

IF IsNumber(Month_String) THEN
ELSE
   CHOOSE CASE Month_String
      CASE "JAN" , "JANUARY"
         Month_String = "01"
      CASE "FEB" , "FEBRUARY"
         Month_String = "02"
      CASE "MAR" , "MARCH"
         Month_String = "03"
      CASE "APR" , "APRIL"
         Month_String = "04"
      CASE "MAY"
         Month_String = "05"
      CASE "JUN" , "JUNE"
         Month_String = "06"
      CASE "JUL" , "JULY"
         Month_String = "07"
      CASE "AUG" , "AUGUST"
         Month_String = "08"
      CASE "SEP" , "SEPTEMBER"
         Month_String = "09"
      CASE "OCT" , "OCTOBER"
         Month_String = "10"
      CASE "NOV" , "NOVEMBER"
         Month_String = "11"
      CASE "DEC" , "DECEMBER"
         Month_String = "12"
   END CHOOSE
END IF

//------------------------------------------------------------------
// If Month_String is not 2 characters long, pad with leading zero.
//------------------------------------------------------------------

IF Len(Month_String) = 1 THEN
   Month_String = "0" + Month_String
END IF

//------------------------------------------------------------------
// Add current century to 2 digit years.
//------------------------------------------------------------------

IF Len(Year_String) = 2 THEN
   Year_String = &
      Left(Right(String(Year(Today())), 4), 2) + Year_String
END IF

//------------------------------------------------------------------
// Format the compare string based on a blank or non-blank
// Hour_String.
//------------------------------------------------------------------

CHOOSE CASE Hour_String

   CASE ""
      l_Select_String = column_string + " " + &
         Relative_Operator + " '" +  Year_String + &
         "-" + Month_String + "-" + Day_String + "'"

   CASE ELSE

      //------------------------------------------------------------
      // Set Fraction_String to 6 characters: 0's if blank, pad with
      // 0's if > 0 and < 6, else truncate to 6 characters.
      //------------------------------------------------------------

      CHOOSE CASE Len(Fraction_String)
         CASE 0
            Fraction_String = "000000"
         CASE IS > 6
            Fraction_String = Left(Fraction_String, 6)
         CASE IS > 0
            FOR l_Counter = (Len(Fraction_String) + 1) TO 6
               Fraction_String = Fraction_String + "0"
            NEXT
      END CHOOSE

      //------------------------------------------------------------
      // String time parameters together with delimiters then build
      // the compare string.
      //------------------------------------------------------------

      l_Time_String = Hour_String + ":" + Minute_String + ":" + &
         Second_String + "." + Fraction_String


      l_Select_String = column_string + " " + &
         Relative_Operator + " " + "DATETIME('" + Year_String + &
         "-" + Month_String + "-" + Day_String + " " + &
         l_Time_String + "')"
END CHOOSE

RETURN l_Select_String
end function

public function string fu_setdatexdb (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetDateXDB
//  Description   : Format a date/datetime comparison string
//                  to be used in a WHERE clause for XDB.
//
//  Parameters    : STRING Month_String - 
//                     String containing the month value.
//
//                  STRING Day_String - 
//                     String containing the day value.
//
//                  STRING Year_String - 
//                     String containing the year value.
//
//                  STRING Hour_String - 
//                     String containing the hour value.
//
//                  STRING Minute_String - 
//                     String containing the minute value.
//
//                  STRING Second_String - 
//                     String containing the seconds value.
//
//                  STRING Fraction_String - 
//                     String containing the fractions value.
//
//                  STRING Meridian_String - 
//                     String containing the meridian indicator.
//
//                  STRING Relative_Operator - 
//                     String containing a valid relative operator.
//
//                  STRING Column_String - 
//                     String containing the column name.
//
//  Return Value  : STRING l_Compare_String - 
//                     The column name, relative operator,
//                     and Date or datetime string formatted for
//                     use in WHERE clause for XDB.
//
//  Change History:
//
//  Date       Person      Description of Change
//  --------   ----------- -----------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All rights reserved.
//******************************************************************

INT     l_Counter
STRING  l_Select_String, l_Hour_Format, l_Time_String

//------------------------------------------------------------------
// If Month_String is not numeric, translate into default format.
//------------------------------------------------------------------

IF IsNumber(Month_String) THEN
ELSE
   CHOOSE CASE Month_String
      CASE "JAN" , "JANUARY"
         Month_String = "01"
      CASE "FEB" , "FEBRUARY"
         Month_String = "02"
      CASE "MAR" , "MARCH"
         Month_String = "03"
      CASE "APR" , "APRIL"
         Month_String = "04"
      CASE "MAY"
         Month_String = "05"
      CASE "JUN" , "JUNE"
         Month_String = "06"
      CASE "JUL" , "JULY"
         Month_String = "07"
      CASE "AUG" , "AUGUST"
         Month_String = "08"
      CASE "SEP" , "SEPTEMBER"
         Month_String = "09"
      CASE "OCT" , "OCTOBER"
         Month_String = "10"
      CASE "NOV" , "NOVEMBER"
         Month_String = "11"
      CASE "DEC" , "DECEMBER"
         Month_String = "12"
   END CHOOSE
END IF

//------------------------------------------------------------------
// If Month_String is not 2 characters long, pad with leading zero.
//------------------------------------------------------------------

IF Len(Month_String) = 1 THEN
   Month_String = "0" + Month_String
END IF

//------------------------------------------------------------------
// Add current century to 2 digit years.
//------------------------------------------------------------------

IF Len(Year_String) = 2 THEN
   Year_String = &
      Left(Right(String(Year(Today())), 4), 2) + Year_String
END IF

//------------------------------------------------------------------
// Format the compare string based on a blank or non-blank
// Hour_String.
//------------------------------------------------------------------

CHOOSE CASE Hour_String

   CASE ""
      l_Select_String = column_string + " " + &
         Relative_Operator + " " + Month_String + "/" + &
         Day_String + "/" + Year_String

   CASE ELSE

      //------------------------------------------------------------
      // Set Fraction_String to 6 characters: 0's if blank, pad with
      // 0's if > 0 and < 6, else truncate to 6 characters.
      //------------------------------------------------------------

      CHOOSE CASE Len(Fraction_String)
         CASE 0
            Fraction_String = "000000"
         CASE IS > 6
            Fraction_String = Left(Fraction_String, 6)
         CASE IS > 0
            FOR l_Counter = (Len(Fraction_String) + 1) TO 6
               Fraction_String = Fraction_String + "0"
            NEXT
      END CHOOSE

      //------------------------------------------------------------
      // String time parameters together with delimiters.
      //------------------------------------------------------------

      l_Time_String = "-" + Hour_String + "." + Minute_String + &
         "." + Second_String + "." + Fraction_String

      //------------------------------------------------------------
      // Format the Meridian_String, and append to the time string.
      //------------------------------------------------------------

      CHOOSE CASE Meridian_String
         CASE ""
            l_Hour_Format = "HH:MM:SS"
         CASE "P"
            Meridian_String = Meridian_String + "M"
            l_Hour_Format   = "HH:MM:PM " + Meridian_String
            l_Time_String   = l_Time_String + " " + Meridian_String
         CASE "PM"
            l_Hour_Format = "HH:MM:PM " + Meridian_String
            l_Time_String = l_Time_String + " " + Meridian_String
         CASE "A"
            Meridian_String = Meridian_String + "M"
            l_Hour_Format   = "HH:MM:AM " + Meridian_String
            l_Time_String   = l_Time_String + " " + Meridian_String
         CASE "AM"
            l_Hour_Format = "HH:MM:AM " + Meridian_String
            l_Time_String = l_Time_String + " " + Meridian_String
         CASE ELSE
            l_Hour_Format = "HH:MM:SS"
      END CHOOSE

      //------------------------------------------------------------
      // Build the compare string.
      //------------------------------------------------------------

      l_Select_String = column_string + " " + &
         Relative_Operator + " " + "TIMESTAMP('" + Year_String + &
         "-" + Month_String + "-" + Day_String + &
         l_Time_String + "')"
END CHOOSE

RETURN l_Select_String
end function

public function integer fu_setweekday (integer begin_day, integer end_day);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetWeekDay
//  Description   : Stores the starting and ending weekdays.
//
//  Parameters    : INTEGER - Begin_Day - 
//                     Start day of the week
//						  INTEGER - End_Day   - 
//                     End day for the week
//
//  Return Value  : INTEGER -
//                      0 = valid day     
//                     -1 = invalid day
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Start, l_Idx, l_Jdx

//------------------------------------------------------------------
//  Make sure we have valid day numbers.
//------------------------------------------------------------------

IF begin_day < 1 OR begin_day > 7 THEN
   RETURN -1
END IF

IF end_day < 1 OR end_day > 7 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Determine the number of days.
//------------------------------------------------------------------

l_Start = begin_day
IF end_day < begin_day THEN
   i_NumWeekdays = 7 - begin_day + end_day + 1
ELSE
   i_NumWeekdays = end_day - begin_day + 1
END IF

//------------------------------------------------------------------
//  Store the day number in an array.
//------------------------------------------------------------------

l_Jdx = -1
FOR l_Idx = 1 TO i_NumWeekdays
   l_Jdx = l_Jdx + 1
   i_WeekDays[l_Idx] = l_Start + l_Jdx
   IF i_WeekDays[l_Idx] = 7 THEN
      l_Start = 0
      l_Jdx = 0
   END IF
NEXT

RETURN 0

end function

public function integer fu_setweekend (integer begin_day, integer end_day);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetWeekEnd
//  Description   : Stores the starting and ending weekends.
//
//  Parameters    : INTEGER - Begin_Day - 
//                     Start day of the weekend
//						  INTEGER - End_Day   - 
//                     End day for the weekend
//
//  Return Value  : INTEGER -
//                      0 = valid day
//                     -1 = invalid day
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Start, l_Idx, l_Jdx

//------------------------------------------------------------------
//  Make sure we have valid day numbers.
//------------------------------------------------------------------

IF begin_day < 1 OR begin_day > 7 THEN
   RETURN -1
END IF

IF end_day < 1 OR end_day > 7 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Determine the number of days.
//------------------------------------------------------------------

l_Start = begin_day
IF end_day < begin_day THEN
   i_NumWeekends = 7 - begin_day + end_day + 1
ELSE
   i_NumWeekends = end_day - begin_day + 1
END IF

//------------------------------------------------------------------
//  Store the day number in an array.
//------------------------------------------------------------------

l_Jdx = -1
FOR l_Idx = 1 TO i_NumWeekends
   l_Jdx = l_Jdx + 1
   i_WeekEnds[l_Idx] = l_Start + l_Jdx
   IF i_WeekEnds[l_Idx] = 7 THEN
      l_Start = 0
      l_Jdx = 0
   END IF
NEXT

RETURN 0

end function

public function integer fu_setholiday (string holiday_name, date holiday_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetHoliday
//  Description   : Sets the holidays
//
//  Parameters    : STRING Holiday_Name - 
//                     The name of the holiday.
//						  DATE   Holiday_Date - 
//                     The date of the holiday.
//
//  Return Value  : INTEGER -
//                      0 = valid date  
//                     -1 = invalid holiday
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

i_NumHolidays = i_NumHolidays + 1
i_HolidayName[i_NumHolidays] = holiday_name
i_HolidayDate[i_NumHolidays] = holiday_date

RETURN 0

end function

public function integer fu_setworkday (integer day_of_the_week, time begin_time, time end_time);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetWorkDay
//  Description   : Sets the beginning and ending times for a 
//                  workday.
//
//  Parameters    : STRING Day_of_The_Week - 
//                     The day of the week to set the workday
//                     times for.
//						  TIME   Begin_Time      - 
//                     The beginning time of the workday.
//						  TIME   End_Time      - 
//                     The ending time of the workday.
//
//  Return Value  : INTEGER -
//                      0 = valid time  
//                     -1 = invalid time
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN -1
END IF

i_WorkDayStart[day_of_the_week] = begin_time
i_WorkDayEnd[day_of_the_week]   = end_time

RETURN 0
end function

public function long fu_datetojulian (date calendar_date, boolean use_current_year);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_DateToJulian
//  Description   : Converts a date to a Julian date.  The Julian
//                  date is calculated as the number of days since 
//                  the beginning of the year (TRUE) or the
//                  number of days since 1/1/1900 (FALSE).
//
//  Parameters    : DATE    Calendar_Date    -
//                     Calendar date to convert.
//                  BOOLEAN Use_Current_Year -
//                     Return number from the beginning of the year
//                     (TRUE), or from 1/1/1900 (FALSE).
//
//  Return Value  : LONG - 
//                     The Julian date.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF use_current_year THEN
   RETURN DaysAfter(Date("01/01/" + String(Year(calendar_date))), &
                    calendar_date) + 1
ELSE
   RETURN DaysAfter(Date("01/01/1900"), calendar_date) + 1
END IF


end function

public function date fu_juliantodate (long julian_date, boolean use_current_year);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_JulianToDate
//  Description   : Converts a Julian date using either the number
//                  of days from the beginning of the year (TRUE)
//                  or the number of days from the 1/1/1900 (FALSE)
//						  to a calendar date (yyyy-mm-dd) 
//
//  Parameters    : LONG    Julian_Date      -
//                     Julian date.
//                  BOOLEAN Use_Current_Year - 
//                     (TRUE) returns the date using the number of
//                     days from the beginning of the year
//                     or from 1/1/1900 (FALSE).
//
//  Return Value  : DATE - 
//                     Calendar date.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Accumulator, l_Year, l_Month, l_Day
LONG l_RemainingDays

l_Year			 = 0
l_RemainingDays = 0

//------------------------------------------------------------------
//  Determine if we are using a julian date from the beginning of
//  the year or from 1900.
//------------------------------------------------------------------

IF NOT use_current_year THEN

   //---------------------------------------------------------------
   //  If the year is 1900 (< 366 days), we handle processing a bit 
   //  differently.  We don't want to trigger the DO loop because we 
   //  already know the year.
   //---------------------------------------------------------------

   CHOOSE CASE julian_date
	   CASE 1 TO 365
		   l_RemainingDays = julian_date
	   CASE ELSE					
		   l_RemainingDays = 366	
   END CHOOSE

   //---------------------------------------------------------------
   //  This loop figures out what year it is when its NOT 1900.
   //---------------------------------------------------------------

   DO UNTIL l_RemainingDays <= 365
	   l_Accumulator    = l_Accumulator + 365
	   l_Year           = l_Year + 1
	   IF fu_VerifyLeap(Date(l_Year, 1, 1)) THEN						
		   l_Accumulator = l_Accumulator + 1		
	   END IF
	   l_RemainingDays  = julian_date - l_Accumulator
   LOOP
   l_Year = l_Year + 1900
ELSE
   l_RemainingDays = julian_date
   l_Year = Year(Today())
END IF

//------------------------------------------------------------------
//  Now let's take l_DaysRemaining and figure what month and day 
//  it is. If the year is a leap year and it's on or before 
//  Feb 29th, processing is handled differently.  This will 
//  figure the month and day.
//------------------------------------------------------------------

IF fu_VerifyLeap(Date(l_Year, 1, 1)) THEN									
   IF l_RemainingDays < 60 THEN							
	   l_RemainingDays = l_RemainingDays + 1	
	   CHOOSE CASE l_RemainingDays
		   CASE 1 TO 31
			   l_Month = 1
			   l_Day	  = l_RemainingDays
		   CASE 32 TO 59
			   l_Month = 2
			   l_Day	  = l_RemainingDays - 31
		   CASE 60
			   l_Month = 2											
			   l_Day   = 29
	   END CHOOSE
	   GOTO Finish
   END IF
END IF

//------------------------------------------------------------------
// If it's not a leap year or after Feb 29th, this will figure 
// what month and day it is.
//------------------------------------------------------------------

CHOOSE CASE l_RemainingDays
   CASE 1 TO 31								//January
	   l_Month = 1
	   l_Day	  = l_RemainingDays
   CASE 32 TO 59								//February
	   l_Month = 2
	   l_Day	  = l_RemainingDays - 31
   CASE 60 TO 90								//March
	   l_Month = 3
	   l_Day	  = l_RemainingDays - 59
   CASE 91 TO 120								//April
	   l_Month = 4
	   l_Day	  = l_RemainingDays - 90
   CASE 121 TO 151							//May
	   l_Month = 5
	   l_Day	  = l_RemainingDays - 120
   CASE 152 TO 181							//June
	   l_Month = 6
	   l_Day	  = l_RemainingDays - 151
   CASE 182 TO 212							//July
	   l_Month = 7
	   l_Day	  = l_RemainingDays - 181
   CASE 213 TO 243							//August
	   l_Month = 8
	   l_Day	  = l_RemainingDays - 212
	CASE 244 TO 273							//September
	   l_Month = 9
	   l_Day	  = l_RemainingDays - 243
   CASE 274 TO 304							//October
	   l_Month = 10
	   l_Day	  = l_RemainingDays - 273
   CASE 305 TO 334							//November
	   l_Month = 11
	   l_Day	  = l_RemainingDays - 304
   CASE  366									//Last Day of December in a leap year.
	   l_Month = 12
	   l_Day	  = 31
   CASE ELSE									//Rest of December
	   l_Month = 12
	   l_Day	  = l_RemainingDays - 334
END CHOOSE

//------------------------------------------------------------------
//  Now, convert the three variables into one variable of type DATE
//  and return it.
//------------------------------------------------------------------

Finish:

RETURN Date(l_Year,l_Month,l_Day)


end function

public function boolean fu_verifyleap (date calendar_date);
//******************************************************************
//  PC Module     : n_OBJCA_DATE
//  Function      : fu_VerifyLeap
//  Description   : Determines whether a supplied year is a leap year.
//						  NOTE: Only works with calendar dates since 1900.
//						  1900 is used as a base date to determine whether 
//						  a specified year is a leap year.
//
//  Parameters    : DATE Calendar_Date -
//                     Calendar date to check.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - leap year
//							  FALSE - not a leap year
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Year

//------------------------------------------------------------------
//  Get the year from the date for examination.
//------------------------------------------------------------------

l_Year = Year(calendar_date)

//------------------------------------------------------------------
//  Determine whether it is a leap year by examining the remainder
//  (modulus) after dividing the given year by four.  If it's 
//  0, then divide by 100.  If that remainder is 0 then dividing by
//  400 must also be 0 to be a leap year.  If dividing by 100 is not
//  0 then it is a leap year.
//------------------------------------------------------------------

IF Mod(l_Year, 4) = 0 THEN
	IF Mod(l_Year, 100) = 0 THEN
		IF Mod(l_Year, 400) = 0 THEN
			RETURN TRUE
		ELSE
			RETURN FALSE
		END IF
	ELSE
		RETURN TRUE
	END IF
ELSE
	RETURN FALSE
END IF

end function

public function date fu_getholiday (string holiday_name, integer holiday_year);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetHoliday
//  Description   : Finds the date for a holiday for the given year.
//
//  Parameters    : STRING Holiday_Name  - 
//                     The name of the holiday.
//                  INTEGER Holiday_Year -
//                     The year the holiday should be searched in.
//
//  Return Value  : DATE - 
//                     The date that the holiday falls on
//							  (Returns NULL if holiday isn't found)
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

DATE l_NullDate
LONG l_Year, l_Idx

//------------------------------------------------------------------
//  We need a four digit year because that's how there stored.  This
//  function, like PowerBuilder, assumes that years 0 - 49 are after
//  the year 2000 and years 50 - 99 are after 1900.
//------------------------------------------------------------------

IF holiday_year < 100 THEN
   CHOOSE CASE holiday_year
	   CASE 0 TO 49
		   l_Year = l_Year + 2000
	   CASE ELSE
		   l_Year = l_Year + 1900
   END CHOOSE
ELSE
   l_Year = holiday_year
END IF

//------------------------------------------------------------------
//  Find the holiday name in the array.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumHolidays
   IF i_HolidayName[l_Idx] = holiday_name AND &
      Year(i_HolidayDate[l_Idx]) = l_Year THEN
      RETURN i_HolidayDate[l_Idx]
   END IF
NEXT

SetNull(l_NullDate) 

RETURN l_NullDate

end function

public function string fu_getnextholiday (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetNextHoliday
//  Description   : Determines the next holiday scheduled after a
//						  given date.
//
//  Parameters    : DATE Calendar_date -
//                     The calendar date to check with.
//
//  Return Value  : STRING - 
//                     The name of the next holiday.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING	l_HolidayName
LONG		l_Idx, l_DaysAfter, l_NextDays

//------------------------------------------------------------------
//  Use the DaysAfter function to determine the minimum number of
//  days to the next holiday.
//------------------------------------------------------------------

l_NextDays = 32765
l_HolidayName = ""

FOR l_Idx = 1 TO i_NumHolidays
   l_DaysAfter = DaysAfter(calendar_date, i_HolidayDate[l_Idx])
   IF l_DaysAfter > 0 THEN
      IF l_DaysAfter < l_NextDays THEN
         l_NextDays = l_DaysAfter
         l_HolidayName = i_HolidayName[l_Idx]
      END IF
   END IF
NEXT

RETURN l_HolidayName
end function

public function boolean fu_verifybegofmonth (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifyBegOfMonth
//  Description   : Determines whether the given date is the first
//						  day of the month.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to check with.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - Date is the first day.
//							  FALSE - Date is not the first day.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Day

//------------------------------------------------------------------
//  Get the day from the date.
//------------------------------------------------------------------

l_Day = Day(calendar_date)

//------------------------------------------------------------------
//  If the day is 1 then it's the first day of the month.
//------------------------------------------------------------------

IF l_Day = 1 THEN
	RETURN TRUE
END IF

RETURN FALSE

end function

public function boolean fu_verifyendofmonth (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifyEndOfMonth
//  Description   : Determines whether the given date is the last
//						  day of the month.  NOTE: Only works with calendar
//						  dates since 1900.  1900 is used as a base date in
//						  fu_VerifyLeap to determine whether a specified 
//						  year is a leap year.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to verify with.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - Date is the last day.
//							  FALSE - Date is not the last day.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Year, l_Month, l_Day

//------------------------------------------------------------------
//  Get the date parts of the date for examination.
//------------------------------------------------------------------

l_Year  = Year(calendar_date)
l_Month = Month(calendar_date)
l_Day	  = Day(calendar_date)

//------------------------------------------------------------------
//  Verify that it's the end of the month by determining what month
//  it is and seeing if the day is the last day of the month.
//------------------------------------------------------------------

CHOOSE CASE l_Month
	CASE 1
		IF l_Day = 31 THEN
			RETURN TRUE
		END IF
	CASE 2
		IF fu_VerifyLeap(calendar_date) THEN
			IF l_Day = 29 THEN	
				RETURN TRUE
			END IF
		ELSE
			IF l_Day = 28 THEN
				RETURN TRUE
			END IF
		END IF
	CASE 3
		IF l_Day = 31 THEN
			RETURN TRUE
		END IF
	CASE 4
		IF l_Day = 30 THEN
			RETURN TRUE
		END IF
	CASE 5
		IF l_Day = 31 THEN
			RETURN TRUE
		END IF
	CASE 6
		IF l_Day = 30 THEN
			RETURN TRUE
		END IF
	CASE 7
		IF l_Day = 31 THEN
			RETURN TRUE
		END IF
	CASE 8
		IF l_Day = 31 THEN
			RETURN TRUE
		END IF
	CASE 9
		IF l_Day = 30 THEN
			RETURN TRUE
		END IF
	CASE 10
		IF l_Day = 31 THEN
			RETURN TRUE
		END IF
	CASE 11
		IF l_Day = 30 THEN
			RETURN TRUE
		END IF
	CASE 12
		IF l_Day = 31 THEN
			RETURN TRUE
		END IF
END CHOOSE

RETURN FALSE
end function

public function boolean fu_verifyweekday (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifyWeekday
//  Description   : Determines whether the given date is a weekday.
//
//  Parameters    : DATE Calendar_date -
//                     The calendar date to verify with.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - Date is a weekday.
//							  FALSE - Date is not a weekday.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DayNumber

//------------------------------------------------------------------
//  Get the day number from the given date.
//------------------------------------------------------------------

l_DayNumber = DayNumber(calendar_date)

FOR l_Idx = 1 TO i_NumWeekDays
   IF i_WeekDays[l_Idx] = l_DayNumber THEN
      RETURN TRUE
   END IF
NEXT

RETURN FALSE
end function

public function boolean fu_verifyweekend (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifyWeekEnd
//  Description   : Determines whether the given date is a weekend.
//
//  Parameters    : DATE Calendar_date -
//                     The calendar date to verify with.
//
//  Return Value  : BOOLEAN -
//                     TRUE  - Date is a weekend.
//							  FALSE - Date is not a weekend.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DayNumber

//------------------------------------------------------------------
//  Get the day number from the given date.
//------------------------------------------------------------------

l_DayNumber = DayNumber(calendar_date)

FOR l_Idx = 1 TO i_NumWeekEnds
   IF i_WeekEnds[l_Idx] = l_DayNumber THEN
      RETURN TRUE
   END IF
NEXT

RETURN FALSE
end function

public function date fu_getendofmonth (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetEndOfMonth
//  Description   : Determines the last day of the month for a 
//						  given date.  NOTE: Only works with calendar
//						  dates since 1900.  1900 is used as a base date in
//						  fu_VerifyLeap to determine whether a specified 
//						  year is a leap year.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to calculate with.
//
//  Return Value  : DATE - 
//                     The last day of the month.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Year, l_Month, l_Day

//------------------------------------------------------------------
//  Break the given date into parts for examination.
//------------------------------------------------------------------

l_Year  = Year(calendar_date)
l_Month = Month(calendar_date)
l_Day   = Day(calendar_date)

//------------------------------------------------------------------
//  Determine what month it is and set the day to the last day of
//  that month.
//------------------------------------------------------------------

CHOOSE CASE l_Month
	CASE 1
		l_Day = 31
	CASE 2
		IF fu_VerifyLeap(calendar_date) THEN
			l_Day = 29
		ELSE
			l_Day = 28
		END IF
	CASE 3
		l_Day = 31
	CASE 4
		l_Day = 30
	CASE 5
		l_Day = 31
	CASE 6
		l_Day = 30
	CASE 7
		l_Day = 31
	CASE 8
		l_Day = 31
	CASE 9
		l_Day = 30
	CASE 10
		l_Day = 31
	CASE 11
		l_Day = 30
	CASE 12
		l_Day = 31
END CHOOSE

//------------------------------------------------------------------
//  Convert the result to date and return it.
//------------------------------------------------------------------

RETURN Date(l_Year, l_Month, l_Day)

end function

public subroutine fu_getdatepartsfromjulian (long julian_date, boolean use_current_year, ref integer calendar_day, ref integer calendar_month, ref integer calendar_year);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetDatePartsFromJulian
//  Description   : Converts a Julian date (number of days since 1900)
//                  into month, day, and year and returns each separately.
//
//  Parameters    : LONG    Julian_Date      -
//                     Julian date.
//                  BOOLEAN Use_Current_Year - 
//                     (TRUE) returns the date using the number of
//                     days from the beginning of the year
//                     or from 1/1/1900 (FALSE).
//                  INTEGER Calendar_Day     -
//                     Calendar day from the julian date.
//                  INTEGER Calendar_Month   -
//                     Calendar month from the julian date.
//                  INTEGER Calendar_Year    -
//                     Calendar year from the julian date.
//
//  Return Value  : (None)
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

DATE l_CalDate

//------------------------------------------------------------------
//  Convert the Julian date to a calendar date.
//------------------------------------------------------------------

l_CalDate = fu_JulianToDate(julian_date, use_current_year)

//------------------------------------------------------------------
//  Get the year, month, and day from the resultant date and return
//  it.
//------------------------------------------------------------------

calendar_year  = Year(l_CalDate)
calendar_month = Month(l_CalDate)
calendar_day	= Day(l_CalDate)

RETURN
end subroutine

public function date fu_getbegofweekday (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetBegOfWeekDay
//  Description   : Returns the beginning date of the weekday for
//						  a specified date.  If the specified date falls
//						  on a weekend (the non-working period, not the 
//						  calendar weekend), it returns the beginning date
//						  of the following work week.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to use to determine the 
//                     beginning of the week.
//
//  Return Value  : DATE - 
//                     The beginning date of the weekday.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DaysBefore, l_DayNumber, l_DaysAfter
DATE    l_NullDate

//------------------------------------------------------------------
//  Make sure the weekend and weekday ranges are continuous.
//------------------------------------------------------------------

IF fu_VerifyWeek() = -1 THEN
   SetNull(l_NullDate)
   RETURN l_NullDate
END IF

//------------------------------------------------------------------
//  Determine the day number of the given date.
//------------------------------------------------------------------

l_DayNumber = DayNumber(calendar_date)

//------------------------------------------------------------------
//  Determine what date the beginning of the work week occurs on.
//------------------------------------------------------------------

l_DaysBefore = 0

FOR l_Idx = 1 TO i_NumWeekDays
   IF i_WeekDays[l_Idx] <> l_DayNumber THEN
      l_DaysBefore = l_DaysBefore - 1
   ELSE
      RETURN RelativeDate(calendar_date, l_DaysBefore)
   END IF
NEXT

//------------------------------------------------------------------
//  If a weekday was not found the given date must fall on a 
//  weekend.  Determine the beginning date of the next weekday.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumWeekEnds
   IF i_WeekEnds[l_Idx] = l_DayNumber THEN
      l_DaysAfter = i_NumWeekEnds - l_Idx + 1
      RETURN RelativeDate(calendar_date, l_DaysAfter)
   END IF
NEXT

end function

public function date fu_getbegofweekend (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetBegOfWeekEnd
//  Description   : Returns the beginning date of the weekend for
//						  a specified date.  If the specified date falls
//						  on a weekday (the working period, not the 
//						  calendar weekday), it returns the beginning date
//						  of the following weekend.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to use to determine the 
//                     beginning of the weekend.
//
//  Return Value  : DATE - 
//                     The beginning date of the weekend.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DaysBefore, l_DayNumber, l_DaysAfter
DATE    l_NullDate

//------------------------------------------------------------------
//  Make sure the weekend and weekday ranges are continuous.
//------------------------------------------------------------------

IF fu_VerifyWeek() = -1 THEN
   SetNull(l_NullDate)
   RETURN l_NullDate
END IF

//------------------------------------------------------------------
//  Determine the day number of the given date.
//------------------------------------------------------------------

l_DayNumber = DayNumber(calendar_date)

//------------------------------------------------------------------
//  Determine what date the beginning of the weekend occurs on.
//------------------------------------------------------------------

l_DaysBefore = 0

FOR l_Idx = 1 TO i_NumWeekEnds
   IF i_WeekEnds[l_Idx] <> l_DayNumber THEN
      l_DaysBefore = l_DaysBefore - 1
   ELSE
      RETURN RelativeDate(calendar_date, l_DaysBefore)
   END IF
NEXT

//------------------------------------------------------------------
//  If a weekend was not found the given date must fall on a 
//  weekday.  Determine the beginning date of the next weekend.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumWeekDays
   IF i_WeekDays[l_Idx] = l_DayNumber THEN
      l_DaysAfter = i_NumWeekDays - l_Idx + 1
      RETURN RelativeDate(calendar_date, l_DaysAfter)
   END IF
NEXT

end function

public function date fu_getendofweekday (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetEndOfWeekDay
//  Description   : Returns the ending date of the weekday for
//						  a specified date.  If the specified date falls
//						  on a weekend (the non-working period, not the 
//						  calendar weekend), it returns the ending date
//						  of the following work week.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to use to determine the 
//                     ending of the week.
//
//  Return Value  : DATE - 
//                     The ending date of the weekday.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DayNumber, l_DaysAfter
DATE    l_NullDate

//------------------------------------------------------------------
//  Make sure the weekend and weekday ranges are continuous.
//------------------------------------------------------------------

IF fu_VerifyWeek() = -1 THEN
   SetNull(l_NullDate)
   RETURN l_NullDate
END IF

//------------------------------------------------------------------
//  Determine the day number of the given date.
//------------------------------------------------------------------

l_DayNumber = DayNumber(calendar_date)

//------------------------------------------------------------------
//  Determine what date the ending of the work week occurs on.
//------------------------------------------------------------------

l_DaysAfter = 0

FOR l_Idx = i_NumWeekDays TO 1 STEP -1
   IF i_WeekDays[l_Idx] <> l_DayNumber THEN
      l_DaysAfter = l_DaysAfter + 1
   ELSE
      RETURN RelativeDate(calendar_date, l_DaysAfter)
   END IF
NEXT

//------------------------------------------------------------------
//  If a weekday was not found the given date must fall on a 
//  weekend.  Determine the ending date of the next weekday.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumWeekEnds
   IF i_WeekEnds[l_Idx] = l_DayNumber THEN
      l_DaysAfter = (i_NumWeekEnds - l_Idx) + i_NumWeekDays
      RETURN RelativeDate(calendar_date, l_DaysAfter)
   END IF
NEXT

end function

public function date fu_getendofweekend (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetEndOfWeekEnd
//  Description   : Returns the ending date of the weekend for
//						  a specified date.  If the specified date falls
//						  on a weekday (the working period, not the 
//						  calendar weekday), it returns the ending date
//						  of the following workend.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to use to determine the 
//                     ending of the weekend.
//
//  Return Value  : DATE - 
//                     The ending date of the weekend.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DayNumber, l_DaysAfter
DATE    l_NullDate

//------------------------------------------------------------------
//  Make sure the weekend and weekday ranges are continuous.
//------------------------------------------------------------------

IF fu_VerifyWeek() = -1 THEN
   SetNull(l_NullDate)
   RETURN l_NullDate
END IF

//------------------------------------------------------------------
//  Determine the day number of the given date.
//------------------------------------------------------------------

l_DayNumber = DayNumber(calendar_date)

//------------------------------------------------------------------
//  Determine what date the ending of the weekend occurs on.
//------------------------------------------------------------------

l_DaysAfter = 0

FOR l_Idx = i_NumWeekEnds TO 1 STEP -1
   IF i_WeekEnds[l_Idx] <> l_DayNumber THEN
      l_DaysAfter = l_DaysAfter + 1
   ELSE
      RETURN RelativeDate(calendar_date, l_DaysAfter)
   END IF
NEXT

//------------------------------------------------------------------
//  If a weekend was not found the given date must fall on a 
//  weekday.  Determine the ending date of the next weekend.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumWeekDays
   IF i_WeekDays[l_Idx] = l_DayNumber THEN
      l_DaysAfter = (i_NumWeekDays - l_Idx) + i_NumWeekEnds
      RETURN RelativeDate(calendar_date, l_DaysAfter)
   END IF
NEXT

end function

public function date fu_addmonths (date calendar_date, long add_months);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_AddMonths
//  Description   : Adds the specified number of months to the given
//						  date and determines the new date.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to add the months to.
//						  LONG Add_Months    -
//                     The number of months to add to the date.
//
//  Return Value  : DATE - 
//                     The new date.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1997.  All Rights Reserved.
//******************************************************************

LONG    l_Day, l_Month, l_Year, l_Counter
DATE    l_Date
BOOLEAN l_Finished

//------------------------------------------------------------------
//  First, break apart the supplied date for calculations.
//------------------------------------------------------------------

l_Year	 = Year(calendar_date)
l_Month   = Month(calendar_date)
l_Day	    = Day(calendar_date)

//------------------------------------------------------------------
// If the months are positive, determine the new date by adding the
// number of months to it.
//------------------------------------------------------------------

IF add_months > 0 THEN
	l_Counter = 1
	DO UNTIL l_Counter > add_months
		l_Month = l_Month + 1
		IF l_Month > 12 THEN
			l_Year = l_Year + 1
			l_Month = 1
		END IF
		l_Counter = l_Counter + 1
	LOOP

//------------------------------------------------------------------
// If the months are negative, determine the new date by subtracting
// the number of months from it.
//------------------------------------------------------------------

ELSE
	l_Counter = -1
	DO UNTIL l_Counter < add_months
		l_Month = l_Month - 1
		IF l_Month < 1 THEN
			l_Year = l_Year - 1
			l_Month = 12
		END IF
		l_Counter = l_Counter - 1
	LOOP
END IF

//------------------------------------------------------------------
// Convert the result and return it.
//------------------------------------------------------------------

l_Finished = FALSE
DO
	l_Date = Date(l_Year, l_Month, l_Day)
	IF String(l_Date, "yyyymmdd") = "19000101" THEN
		l_Day = l_Day - 1
	ELSE
		l_Finished = TRUE
	END IF
LOOP UNTIL l_Finished

RETURN l_Date

end function

public function date fu_addweeks (date calendar_date, long add_weeks);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_AddWeeks
//  Description   : Adds the specified number of weeks to the given
//						  date and determines the new date.
//
//  Parameters    : DATE Calendar_Date -
//                     The calendar date to add the weeks to.
//						  LONG Add_Weeks    -
//                     The number of weeks to add to the date.
//
//  Return Value  : DATE - 
//                     The new date.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_NumDays

//------------------------------------------------------------------
//  Convert the number of weeks to days and the supplied date to
//  Julian so we can perform calculations.
//------------------------------------------------------------------

l_NumDays = add_weeks * 7

RETURN RelativeDate(calendar_date, l_NumDays)
end function

public function time fu_secondstotime (long seconds);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SecondstoTime
//  Description   : Determines the TIME value for a specific number
//						  of seconds
//
//  Parameters    : LONG Seconds -
//                     The number of seconds to convert.
//
//  Return Value  : TIME - 
//                     The time value (00:00:00)
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Hours, l_Minutes, l_Seconds

//------------------------------------------------------------------
//  Convert the supplied seconds into hours, minutes and seconds.
//------------------------------------------------------------------

fu_GetTimePartsFromSeconds(seconds, l_Hours, l_Minutes, l_Seconds)

//------------------------------------------------------------------
//  Convert the results to a TIME data type and return it.
//------------------------------------------------------------------

RETURN Time(l_Hours, l_Minutes, l_Seconds)

end function

public function long fu_timetoseconds (time time_of_day);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_TimeToSeconds
//  Description   : Returns the total number of seconds for a time
//						  value.
//
//  Parameters    : TIME Time_Of_Day -
//                     The time of day to convert to seconds.
//
//  Return Value  : LONG - 
//                     The total number of seconds.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Hours, l_Minutes, l_Seconds

//------------------------------------------------------------------
//  Get the hours, minutes, and seconds of the supplied time for use
//  in calculations.
//------------------------------------------------------------------

l_Hours   = Hour(time_of_day)
l_Minutes = Minute(time_of_day)
l_Seconds = Second(time_of_day)

//------------------------------------------------------------------
//  Convert hours and minutes to seconds by multiplying them by the 
//  number of seconds in each.  Add them together and return the
//  result.
//------------------------------------------------------------------

RETURN (l_Hours * 3600) + (l_Minutes * 60) + l_Seconds

end function

public subroutine fu_gettimepartsfromseconds (long seconds_of_day, ref long hours, ref long minutes, ref long seconds);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetTimePartsFromSeconds
//  Description   : Returns the hours, minutes and seconds from a
//						  supplied value.
//
//  Parameters    : LONG Seconds_Of_Day -
//                     The number of seconds to convert.
//						  LONG Hours          - 
//                     The number of hours.
//						  LONG Minutes        - 
//                     The number of minutes.
//						  LONG Seconds        - 
//                     The number of seconds.
//
//  Return Value  : (None)
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Initialize.
//------------------------------------------------------------------

hours	  = 0
minutes = 0
seconds = seconds_of_day

//------------------------------------------------------------------
//  Calculate the number of hours by dividing the number of seconds
//  in an hour into the supplied number.
//------------------------------------------------------------------

DO UNTIL seconds < 3600
	hours   = hours + 1
	seconds = seconds - 3600
LOOP

//------------------------------------------------------------------
//  Calculate the number of minutes by dividing the number of seconds
//  in a minute into the remainder from above.
//------------------------------------------------------------------

DO UNTIL seconds < 60
	minutes = minutes + 1
	seconds = seconds - 60
LOOP

//------------------------------------------------------------------
//  The leftover seconds are less than 60, so that's the remaining
//  seconds.
//------------------------------------------------------------------

RETURN
end subroutine

public function boolean fu_verifyholiday (date calendar_date);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifyHoliday
//  Description   : Checks to see if the passed date is a scheduled 
//						  holiday.
//
//  Parameters    : DATE   Calendar_Date
//                     Calendar date to verify.
//
//  Return Value  : BOOLEAN - 
//                     TRUE  - scheduled holiday.
//							  FALSE - not a scheduled holiday.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

LONG l_Idx

//------------------------------------------------------------------
//  Loop through holiday array looking for the supplied date.  
//  If it's there, the date is a holiday.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumHolidays
   IF i_HolidayDate[l_Idx] = calendar_date THEN
      RETURN TRUE
   END IF
NEXT

RETURN FALSE

end function

public function integer fu_deleteschedule (integer day_of_the_week, string schedule_name);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_DeleteSchedule
//  Description   : Deletes the given scheduled break/meeting
//                  for a specific day.
//
//  Parameters    : INTEGER Day_of_The_Week - 
//                     The day of the week to delete the scheduled
//                     time for.
//                  STRING  Schedule_Name      -
//                     The name of the schedule to delete.
//
//  Return Value  : INTEGER - 
//                      0 if successful.
//                     -1 if unsuccessful.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Jdx

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Remove the scheduled break/metting for the given day.
//------------------------------------------------------------------

l_Jdx = 0
FOR l_Idx = 1 TO i_NumSchedules
   IF i_ScheduleDay[l_Idx] <> day_of_the_week AND &
      i_ScheduleName[l_Idx] <> schedule_name THEN
      l_Jdx = l_Jdx + 1
      i_ScheduleDay[l_Jdx]   = i_ScheduleDay[l_Idx]
      i_ScheduleName[l_Jdx]  = i_ScheduleName[l_Idx]
      i_ScheduleStart[l_Jdx] = i_ScheduleStart[l_Idx]
      i_ScheduleEnd[l_Jdx]   = i_ScheduleEnd[l_Idx]
   END IF
NEXT

i_NumSchedules = l_Jdx

RETURN 0
end function

public function integer fu_resetschedule (integer day_of_the_week);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_ResetSchedule
//  Description   : Resets the scheduled break/meeting times for 
//                  a specific day.
//
//  Parameters    : INTEGER Day_of_The_Week - 
//                     The day of the week to reset the scheduled
//                     break/meeting times for.
//
//  Return Value  : INTEGER - 
//                      0 if successful.
//                     -1 if unsuccessful.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_Jdx

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Remove the scheduled breaks/meetings for the given day.
//------------------------------------------------------------------

l_Jdx = 0
FOR l_Idx = 1 TO i_NumSchedules
   IF i_ScheduleDay[l_Idx] <> day_of_the_week THEN
      l_Jdx = l_Jdx + 1
      i_ScheduleDay[l_Jdx]   = i_ScheduleDay[l_Idx]
      i_ScheduleName[l_Jdx]  = i_ScheduleName[l_Idx]
      i_ScheduleStart[l_Jdx] = i_ScheduleStart[l_Idx]
      i_ScheduleEnd[l_Jdx]   = i_ScheduleEnd[l_Idx]
   END IF
NEXT

i_NumSchedules = l_Jdx

RETURN 0
end function

public function integer fu_setschedule (integer day_of_the_week, string schedule_name, time begin_time, time end_time);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_SetSchedule
//  Description   : Sets a scheduled break/meeting time for a 
//                  specific day.
//
//  Parameters    : INTEGER Day_of_The_Week - 
//                     The day of the week to set the scheduled
//                     break/meeting times for.
//                  STRING  Schedule_Name   -
//                     Name given to the scheduled break/meeting.
//						  TIME   Begin_Time       - 
//                     The beginning time of the break/meeting.
//						  TIME   End_Time         - 
//                     The ending time of the break/meeting.
//
//  Return Value  : INTEGER - 
//                      0 if successful.
//                     -1 if unsuccessful.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN l_ScheduleFound
INTEGER l_Idx

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN -1
END IF

//------------------------------------------------------------------
//  Determine if a break/meeting for the given day already exists.
//------------------------------------------------------------------

l_ScheduleFound = FALSE

FOR l_Idx = 1 TO i_NumSchedules
   IF i_ScheduleDay[l_Idx] = day_of_the_week AND &
      i_ScheduleName[l_Idx] = schedule_name THEN
      l_ScheduleFound = TRUE
      EXIT
   END IF
NEXT

//------------------------------------------------------------------
//  If a break/meeting is not found then add it.
//------------------------------------------------------------------

IF NOT l_ScheduleFound THEN
   i_NumSchedules = i_NumSchedules + 1
   i_ScheduleDay[i_NumSchedules]   = day_of_the_week
   i_ScheduleName[i_NumSchedules]  = schedule_name
   i_ScheduleStart[i_NumSchedules] = begin_time
   i_ScheduleEnd[i_NumSchedules]   = end_time
END IF

RETURN 0
end function

public function boolean fu_verifyschedule (integer day_of_the_week, time time_of_day);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifySchedule
//  Description   : Determines if the given time falls within a
//                  scheduled break/meeting time for the given day.
//
//  Parameters    : STRING Day_of_The_Week - 
//                     The day of the week to check.
//                  TIME   Time_Of_Day     -
//                     The time of day to check with.
//
//  Return Value  : INTEGER - 
//                      0 if successful.
//                     -1 if unsuccessful.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN FALSE
END IF

//------------------------------------------------------------------
//  Determine if the time is during a break/meeting.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSchedules
   IF i_ScheduleDay[l_Idx] = day_of_the_week AND &
      i_ScheduleStart[l_Idx] <= time_of_day AND &
      i_ScheduleEnd[l_Idx] >= time_of_day THEN
      RETURN TRUE
   END IF
NEXT

RETURN FALSE
end function

public function boolean fu_verifyworkday (integer day_of_the_week, time time_of_day);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifyWorkDay
//  Description   : Determines if the given time falls within 
//                  work time for the given day.
//
//  Parameters    : STRING Day_of_The_Week - 
//                     The day of the week to check.
//                  TIME   Time_Of_Day     -
//                     The time of day to check with.
//
//  Return Value  : BOOLEAN - 
//                     TRUE if workday.
//                     FALSE if not workday.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN FALSE
END IF

//------------------------------------------------------------------
//  Determine if the time is during work time.
//------------------------------------------------------------------

IF i_WorkDayStart[day_of_the_week] <= time_of_day AND &
   i_WorkDayEnd[day_of_the_week] >= time_of_day THEN
   RETURN TRUE
ELSE
   RETURN FALSE
END IF
end function

public function string fu_getschedule (integer day_of_the_week, time time_of_day);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetSchedule
//  Description   : Returns the name of the break/meeting if the
//                  time falls within a schedule.
//
//  Parameters    : STRING Day_of_The_Week - 
//                     The day of the week to check.
//                  TIME   Time_Of_Day     -
//                     The time of day to check with.
//
//  Return Value  : STRING - 
//                     Name of schedule if found.
//                     Empty string ("") if not found.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN ""
END IF

//------------------------------------------------------------------
//  Determine if the time is during a break/meeting.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSchedules
   IF i_ScheduleDay[l_Idx] = day_of_the_week AND &
      i_ScheduleStart[l_Idx] <= time_of_day AND &
      i_ScheduleEnd[l_Idx] >= time_of_day THEN
      RETURN i_ScheduleName[l_Idx]
   END IF
NEXT

RETURN ""
end function

public function time fu_getendofschedule (integer day_of_the_week, string schedule_name);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetEndOfSchedule
//  Description   : Returns the end time of the given scheduled 
//                  break/meeting for a specific day.
//
//  Parameters    : INTEGER Day_of_The_Week - 
//                     The day of the week to find the scheduled
//                     end time for.
//                  STRING  Schedule_Name      -
//                     The name of the schedule to find.
//
//  Return Value  : TIME - 
//                     Ending time for the break/meeting.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx
TIME    l_NullTime

SetNull(l_NullTime)

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN l_NullTime
END IF

//------------------------------------------------------------------
//  Find the scheduled break/meeting for the given day.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSchedules
   IF i_ScheduleDay[l_Idx] = day_of_the_week AND &
      i_ScheduleName[l_Idx] = schedule_name THEN
      RETURN i_ScheduleEnd[l_Idx]
   END IF
NEXT

RETURN l_NullTime
end function

public function time fu_getbegofschedule (integer day_of_the_week, string schedule_name);//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_GetBegOfSchedule
//  Description   : Returns the beginning time of the given scheduled 
//                  break/meeting for a specific day.
//
//  Parameters    : INTEGER Day_of_The_Week - 
//                     The day of the week to find the scheduled
//                     begin time for.
//                  STRING  Schedule_Name      -
//                     The name of the schedule to find.
//
//  Return Value  : TIME - 
//                     Beginning time for the break/meeting.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx
TIME    l_NullTime

SetNull(l_NullTime)

IF day_of_the_week < 1 OR day_of_the_week > 7 THEN
   RETURN l_NullTime
END IF

//------------------------------------------------------------------
//  Find the scheduled break/meeting for the given day.
//------------------------------------------------------------------

FOR l_Idx = 1 TO i_NumSchedules
   IF i_ScheduleDay[l_Idx] = day_of_the_week AND &
      i_ScheduleName[l_Idx] = schedule_name THEN
      RETURN i_ScheduleStart[l_Idx]
   END IF
NEXT

RETURN l_NullTime
end function

public function integer fu_verifyweek ();//******************************************************************
//  PO Module     : n_OBJCA_DATE
//  Function      : fu_VerifyWeek
//  Description   : Verify that the developer has defined a valid 
//                  range for weekends and weekdays.
//
//  Parameters    : (None)
//
//  Return Value  : INTEGER -
//                      0 = valid definition.
//                     -1 = invalid definition.
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

INTEGER l_Idx, l_DaySum

IF i_NumWeekEnds + i_NumWeekDays <> 7 THEN
   RETURN -1
END IF

l_DaySum = 0
FOR l_Idx = 1 TO i_NumWeekEnds
   l_DaySum = l_DaySum + i_WeekEnds[l_Idx]
NEXT

FOR l_Idx = 1 TO i_NumWeekDays
   l_DaySum = l_DaySum + i_WeekDays[l_Idx]
NEXT

IF l_DaySum <> 28 THEN
   RETURN -1
ELSE
   RETURN 0
END IF
end function

public function string fu_setdatedb (string column_string, string date_string, string date_format, string relative_operator, transaction transaction_object);/****************************************************************************************
  PC Module     : n_OBJCA_DATE
  Function      : fu_SetDateDB
  Description   : Format a date/datetime comparison string to be used in a WHERE clause
                  for various Databases.

  Parameters    : STRING Column_String - 
                     String containing the column name.

                  STRING Date_String   - 
                     String containing the Date/DateTime.

                  STRING Date_Format   - 
                     String containing a valid Powerbuilder 
                     Date or DateTime format.

                  STRING Relative_Operator - 
                     String containing a valid relative
                     operator.

                  TRANSACTION Transaction_Object -
                     The transaction object for this DataWindow.

  Return Value  : STRING l_Return_String -
                     The column name, relative operator, and Date or datetime string
							formatted for use in a WHERE clause for the DBMS requested.

  Change History:

  Date       Person      Description of Change
  --------   ----------- ----------------------------------------------------------------
  8/10/99    M. Caruso   Added "SQL SERVER (32 BIT)" to the list of recognized databases.
								 
  11/1/99    M. Caruso   Added "Sybase System 11 (32 BIT)" to the list of recognized
                         databases.
								 
  11/27/2001 K. Claver   Added code to accomodate for Microsoft SQL Server.
*****************************************************************************************
  Copyright ServerLogic 1992-1996.  All rights reserved.
****************************************************************************************/

STRING   l_Chars[], l_Char, l_Return_String,   l_Month_Chars
STRING   l_Day_Chars, l_Year_Chars, l_Hours_Chars, l_Minutes_Chars
STRING   l_Seconds_Chars, l_Fractions_Chars, l_Null_Chars[]
STRING   l_Meridian_Chars, l_Prior_Delimiter, l_Delimiter, l_DBMS
INT      l_Counter, l_Counter_2, l_Date_Length, l_Format_Length
INT      l_Counter_3

BOOLEAN  l_Next_Parameter        = FALSE
BOOLEAN  l_Next_Delimiter_Found  = FALSE

//------------------------------------------------------------------
// Use the Date_Format string to parse the Date_String.
// For each format field (delimited by space, colon, dash, etc)
// load all format string characters into l_Chars[] hold array.
// Check 1st character to determine field type. ("M" is valid for
// Minutes as well as months, so check for colon as prior delimiter
// for Minute fields.  Once the field type is known, loop through
// the date string and load the appropriate variable until the next
// delimiter is found. Then advance to the next format field.
//------------------------------------------------------------------

l_Format_Length = Len(Date_Format)
l_Date_Length   = Len(Date_String)

DO UNTIL l_Counter >= l_Format_Length
   l_Counter_2            = 0
   l_Chars[]              = l_Null_Chars[]
   l_Next_Parameter       = FALSE
   l_Next_Delimiter_Found = FALSE

   //---------------------------------------------------------------
   // Loop thru the format field and load the format characters
   // until the next delimiter is found.
   //---------------------------------------------------------------

   DO UNTIL l_Next_Parameter

      l_Counter    = l_Counter   + 1
      l_Counter_2  = l_Counter_2 + 1

      l_Chars[ l_Counter_2 ] = &
         Upper( Mid( Date_Format , l_Counter , 1 ))

      IF  l_Chars[ l_Counter_2 ] = " " OR &
          l_Chars[ l_Counter_2 ] = ":" OR &
          l_Chars[ l_Counter_2 ] = "/" OR &
          l_Chars[ l_Counter_2 ] = "-" OR &
          l_Chars[ l_Counter_2 ] = "," OR &
          l_Chars[ l_Counter_2 ] = "." OR &
          l_Chars[ l_Counter_2 ] = ""  THEN
         l_Delimiter       = l_Chars[ l_Counter_2 ]
         l_Next_Parameter  = TRUE
      END IF

      IF l_Counter_2       = l_Format_Length THEN
         l_Counter         = l_Counter_2
         l_Next_Parameter  = TRUE
      END IF
   LOOP

   //---------------------------------------------------------------
   //  Check 1st character to see what kind of field it is.  Then
   //  loop thru the Date string loading the appropriate variable,
   //  until the next delimiter is found.
   //---------------------------------------------------------------

   CHOOSE CASE l_Chars[1]

      CASE "D"

         //---------------------------------------------------------
         //  Day field, so load day variable.
         //---------------------------------------------------------

         DO UNTIL l_Next_Delimiter_Found
            IF l_Counter_3 = l_Date_Length THEN
               l_Next_Delimiter_Found = TRUE
               EXIT
            END IF

            l_Counter_3 = l_Counter_3 + 1
            l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

            CHOOSE CASE l_Char
               CASE ":" , "-" , " " , "/" , "," , "." , ""
                  l_Next_Delimiter_Found = TRUE
               CASE ELSE
                  l_Day_Chars = l_Day_Chars + l_Char
            END CHOOSE
         LOOP

      CASE "Y"

         //---------------------------------------------------------
         //  Year field, so load Year variable.
         //---------------------------------------------------------

         DO UNTIL l_Next_Delimiter_Found
            IF l_Counter_3 = l_Date_Length THEN
               l_Next_Delimiter_Found = TRUE
               EXIT
            END IF

            l_Counter_3 = l_Counter_3 + 1
            l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

            CHOOSE CASE l_Char
               CASE ":" , "-" , " " , "/" , "," , "." , ""
                  l_Next_Delimiter_Found = TRUE
               CASE ELSE
                  l_Year_Chars = l_Year_Chars + l_Char
            END CHOOSE
         LOOP

      CASE "H"

         //---------------------------------------------------------
         //  Hour field, so load Hour variable.
         //---------------------------------------------------------

         DO UNTIL l_Next_Delimiter_Found
            IF l_Counter_3 = l_Date_Length THEN
               l_Next_Delimiter_Found = TRUE
               EXIT
            END IF

            l_Counter_3 = l_Counter_3 + 1
            l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

            CHOOSE CASE l_Char
               CASE ":" , "-" , " " , "/" , "," , "." , ""
                  l_Next_Delimiter_Found = TRUE
               CASE ELSE
                  l_Hours_Chars = l_Hours_Chars + l_Char
            END CHOOSE
         LOOP

      CASE "S"

         //---------------------------------------------------------
         //  Seconds field, so load seconds variable.
         //---------------------------------------------------------

         DO UNTIL l_Next_Delimiter_Found
            IF l_Counter_3 = l_Date_Length THEN
               l_Next_Delimiter_Found = TRUE
               EXIT
            END IF

            l_Counter_3 = l_Counter_3 + 1
            l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

            CHOOSE CASE l_Char
               CASE ":" , "-" , " " , "/" , "," , "." , ""
                  l_Next_Delimiter_Found = TRUE
               CASE ELSE
                  l_Seconds_Chars = l_Seconds_Chars + l_Char
            END CHOOSE
         LOOP

      CASE "F"

         //---------------------------------------------------------
         //  Fractions field, so load Fractions variable.
         //---------------------------------------------------------

         DO UNTIL l_Next_Delimiter_Found
            IF l_Counter_3 = l_Date_Length THEN
               l_Next_Delimiter_Found = TRUE
               EXIT
            END IF

            l_Counter_3 = l_Counter_3 + 1
            l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

            CHOOSE CASE l_Char
               CASE ":" , "-" , " " , "/" , "," , "." , ""
                  l_Next_Delimiter_Found = TRUE
               CASE ELSE
                  l_Fractions_Chars = l_Fractions_Chars + l_Char
            END CHOOSE
         LOOP

      CASE "A", "P"

         //---------------------------------------------------------
         //  Meridian field, so load Meridian variable.
         //---------------------------------------------------------

         DO UNTIL l_Next_Delimiter_Found
            IF l_Counter_3 = l_Date_Length THEN
               l_Next_Delimiter_Found = TRUE
               EXIT
            END IF

            l_Counter_3 = l_Counter_3 + 1
            l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

            CHOOSE CASE l_Char
               CASE ":" , "-" , " " , "/" , "," , "." , ""
                  l_Next_Delimiter_Found = TRUE
               CASE ELSE
                  l_Meridian_Chars = l_Meridian_Chars + l_Char
            END CHOOSE
         LOOP

      CASE "M"

         //---------------------------------------------------------
         //  Check prior delimiter to determine if this is a Month
         //  or Minute field.
         //---------------------------------------------------------

         CHOOSE CASE l_Prior_Delimiter

            CASE ":"

               //---------------------------------------------------
               // Minute field, so load minute variable.
               //---------------------------------------------------

               DO UNTIL l_Next_Delimiter_Found
                  IF l_Counter_3 = l_Date_Length THEN
                     l_Next_Delimiter_Found = TRUE
                     EXIT
                  END IF

                  l_Counter_3 = l_Counter_3 + 1
                  l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

                  CHOOSE CASE l_Char
                     CASE ":" , "-" , " " , "/" , "," , "." , ""
                        l_Next_Delimiter_Found = TRUE
                     CASE ELSE
                        l_Minutes_Chars = l_Minutes_Chars + l_Char
                  END CHOOSE
               LOOP

            CASE ELSE

               //---------------------------------------------------
               // Month field, so load Month variable.
               //---------------------------------------------------

               DO UNTIL l_Next_Delimiter_Found
                  IF l_Counter_3 = l_Date_Length THEN
                     l_Next_Delimiter_Found = TRUE
                     EXIT
                  END IF

                  l_Counter_3 = l_Counter_3 + 1
                  l_Char = Upper( Mid( Date_String , l_Counter_3, 1 ))

                  CHOOSE CASE l_Char
                     CASE ":" , "-" , " " , "/" , "," , "." , ""
                        l_Next_Delimiter_Found = TRUE
                     CASE ELSE
                        l_Month_Chars = l_Month_Chars + l_Char
                  END CHOOSE
               LOOP
         END CHOOSE
      CASE ELSE

         //---------------------------------------------------------
         // Character is not a known format character, so
         // skip it.
         //---------------------------------------------------------

         l_Counter_3 = l_Counter_3 + 1
         l_Next_Delimiter_Found = TRUE
   END CHOOSE

   //---------------------------------------------------------------
   // Set prior delimiter field to check in next
   // iteration.
   //---------------------------------------------------------------

   l_Prior_Delimiter = l_Delimiter
LOOP

//------------------------------------------------------------------
// Pad any short month or day fields with a leading zero.
//------------------------------------------------------------------

IF Len(l_Month_Chars) = 1 THEN
   l_Month_Chars = "0" + l_Month_Chars
END IF

IF Len(l_Day_Chars) = 1 THEN
   l_Day_Chars = "0" + l_Day_Chars
END IF

//------------------------------------------------------------
// Call appropriate format function based on DBMS passed.
//------------------------------------------------------------

l_DBMS = OBJCA.DB.fu_GetDatabase(transaction_object, OBJCA.DB.c_DB_Id)

CHOOSE CASE Upper(l_DBMS)
   CASE "OR6", "OR7", "O71", "O72", "O73"
      l_Return_String =                      &
         fu_SetDateOracle(l_Month_Chars,     &
                          l_Day_Chars,       &
                          l_Year_Chars,      &
                          l_Hours_Chars,     &
                          l_Minutes_Chars,   &
                          l_Seconds_Chars,   &
                          l_Fractions_Chars, &
                          l_Meridian_Chars,  &
                          Relative_Operator, &
                          Column_String)

   CASE "ODBC_ANYWHERE", "SYBASE SQL ANYWHERE 5.0", "ADAPTIVE SERVER ANYWHERE 6.0"
      l_Return_String =                      &
         fu_SetDateWatcom(l_Month_Chars,     &
                          l_Day_Chars,       &
                          l_Year_Chars,      &
                          l_Hours_Chars,     &
                          l_Minutes_Chars,   &
                          l_Seconds_Chars,   &
                          l_Fractions_Chars, &
                          l_Meridian_Chars,  &
                          Relative_Operator, &
                          Column_String )

   CASE "XDB"
      l_Return_String =                  &
         fu_SetDateXDB(l_Month_Chars,     &
                       l_Day_Chars,       &
                       l_Year_Chars,      &
                       l_Hours_Chars,     &
                       l_Minutes_Chars,   &
                       l_Seconds_Chars,   &
                       l_Fractions_Chars, &
                       l_Meridian_Chars,  &
                       Relative_Operator, &
                       Column_String)

   CASE "SYB", "SYT", "SYC", "MSS", "SQL SERVER (32 BIT)", "SYBASE SYSTEM 11 (32 BIT)", "SNC"
      l_Return_String =                         &
         fu_SetDateSQLServer(l_Month_Chars,     &
                             l_Day_Chars,       &
                             l_Year_Chars,      &
                             l_Hours_Chars,     &
                             l_Minutes_Chars,   &
                             l_Seconds_Chars,   &
                             l_Fractions_Chars, &
                             l_Meridian_Chars,  &
                             Relative_Operator, &
                             Column_String)

   CASE "IN5", "IN7"
		l_Return_String = Column_String + " " + &
			               Relative_Operator + " '" + &
                        l_Month_Chars + "/" + &
                        l_Day_Chars + "/" + &
                        l_Year_Chars + "'"
   CASE "IBM" 

   CASE "MDI"

   CASE "NET"

END CHOOSE

RETURN l_Return_String
end function

on constructor;INTEGER l_Idx

FOR l_Idx = 1 TO 7
   i_WorkDayStart[l_Idx] = Time("8:00")
   i_WorkDayEnd[l_Idx]   = Time("17:00")
NEXT
end on

on n_objca_date.create
call super::create
end on

on n_objca_date.destroy
call super::destroy
end on

