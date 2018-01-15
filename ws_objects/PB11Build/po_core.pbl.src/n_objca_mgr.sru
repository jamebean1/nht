$PBExportHeader$n_objca_mgr.sru
$PBExportComments$Application service to handle class defaults
forward
global type n_objca_mgr from datastore
end type
type s_resources from structure within n_objca_mgr
end type
type s_rect from structure within n_objca_mgr
end type
end forward

type s_resources from structure
	unsignedlong		dwlength
	unsignedlong		dwmemoryload
	unsignedlong		dwtotalphys
	unsignedlong		dwavailphys
	unsignedlong		dwtotalpagefile
	unsignedlong		dwavailpagefile
	unsignedlong		dwtotalvirtual
	unsignedlong		dwavailvirtual
end type

type s_rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type n_objca_mgr from datastore
string dataobject = "d_objca_mgr_std"
end type
global n_objca_mgr n_objca_mgr

type prototypes
//******************************************************************
//  Externals	: ServerLogic Windows Functions
//  Description	: Provides the global external functions
//  		  definitions for Windows functions
//  		  used by the ServerLogic Libraries.
//
//  Change History	:
//
//  Date	Person	      Description of Change
//  --------	----------    --------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

FUNCTION UNSIGNEDINT GetFreeSystemResources	&
      (UNSIGNEDINT	nSysResource)		&
LIBRARY "USER.DLL"

SUBROUTINE GlobalMemoryStatus			&
      (ref S_RESOURCES	lpmstMemStat)		&
LIBRARY "KERNEL32.DLL" alias for "GlobalMemoryStatus;Ansi"
end prototypes

type variables
//----------------------------------------------------------------------------------------
//  Object Manager Constants
//----------------------------------------------------------------------------------------

CONSTANT INTEGER	c_Fatal			= -1
CONSTANT INTEGER	c_Success		= 0

STRING	c_DefaultManagers		= "000|"
STRING	c_UtilityManager		= "001|"
STRING	c_TimerManager		= "002|"
STRING	c_FieldManager		= "003|"
STRING	c_DateManager		= "004|"
STRING	c_LogManager		= "005|"

CONSTANT ULONG	c_White			= 16777215
CONSTANT ULONG	c_Black			= 0
CONSTANT ULONG	c_Gray			= 80269524
CONSTANT ULONG	c_LightGray		= 80269524
CONSTANT ULONG	c_DarkGray		= 8421504
CONSTANT ULONG	c_Red			= 255
CONSTANT ULONG	c_DarkRed		= 128
CONSTANT ULONG	c_Green			= 65280
CONSTANT ULONG	c_DarkGreen		= 32768
CONSTANT ULONG	c_Blue			= 16711680
CONSTANT ULONG	c_DarkBlue		= 8388608
CONSTANT ULONG	c_Magenta		= 16711935
CONSTANT ULONG	c_DarkMagenta		= 8388736
CONSTANT ULONG	c_Cyan			= 16776960
CONSTANT ULONG	c_DarkCyan		= 8421376
CONSTANT ULONG	c_Yellow			= 65535
CONSTANT ULONG	c_DarkYellow		= 32896
CONSTANT ULONG	c_Brown			= 32896

CONSTANT INTEGER	c_APP_Object		= 1
CONSTANT INTEGER	c_APP_Name		= 2
CONSTANT INTEGER	c_APP_Rev		= 3
CONSTANT INTEGER	c_APP_Bitmap		= 4
CONSTANT INTEGER	c_APP_INIFile		= 5
CONSTANT INTEGER	c_APP_Copyright		= 6

CONSTANT STRING	c_Default			= "000|"
CONSTANT STRING	c_LogAppend		= "001|"
CONSTANT STRING	c_LogOverwrite		= "002|"
CONSTANT STRING	c_LogSystemMsg		= "003|"
CONSTANT STRING	c_NoLogSystemMsg	= "004|"

//----------------------------------------------------------------------------------------
//  Object Manager Instance Variables
//----------------------------------------------------------------------------------------

ENVIRONMENT		i_Env
STRING			i_ODBCFile
STRING			i_DirDelim
STRING			i_SystemFile

INTEGER		i_FrameWidth	= 2
INTEGER		i_FrameHeight	= 2
INTEGER		i_BorderWidth	= 1
INTEGER		i_BorderHeight	= 1
INTEGER		i_TitleHeight	= 20
INTEGER		i_ControlWidth	= 22

APPLICATION		i_ApplicationObject
STRING			i_ApplicationName
STRING			i_ApplicationRev
STRING			i_ApplicationBitmap
STRING			i_ApplicationINI
STRING			i_ApplicationCopyright

S_PARMS		i_Parm
STRING			i_WindowTextFont
INTEGER		i_WindowTextSize
ULONG			i_WindowTextColor
ULONG			i_WindowColor

BOOLEAN		i_TimerOn
WINDOW		i_MicroHelp
STRING			i_CurrentLog

STRING 		i_ProgName      
STRING		i_ProgVersion   
STRING		i_ProgBMP       
STRING		i_PlaqueDisplay 
STRING		i_PlaqueBMP     
STRING		i_ProgINI       
STRING		i_AdmUseLogin
STRING		i_Source
STRING		i_RegKey
STRING		i_DevMode
end variables

forward prototypes
public function integer fu_about (string application_name, string application_rev, string application_copyright, string application_bitmap)
public function unsignedlong fu_bitmask (unsignedlong operand1, unsignedlong operand2)
public subroutine fu_centerwindow (window window_name)
public function integer fu_connect (transaction trans_object, boolean allow_correction)
public function integer fu_fileconfirm (string from_directory, string to_directory, string files[], ref boolean copymove[])
public function integer fu_filecopy (string from_file, string to_file)
public function integer fu_filecopymove (string from_directory, string to_directory, string files[], string copy_or_move, boolean confirm, boolean display)
public function integer fu_filemove (string from_file, string to_file)
public function integer fu_filesaveas (datawindow datawindow, ref string directory)
public function string fu_formatstring (string format_string, integer num_numbers, real number_parms[], integer num_strings, string string_parms[])
public subroutine fu_getcascadesize (ref integer cascade_y, ref integer cascade_x)
public function integer fu_getconnectinfo (string ini_file, string ini_section, ref transaction trans_object)
public subroutine fu_getframesize (ref integer frame_width, ref integer frame_height)
public function string fu_getlogin (transaction trans_object)
public subroutine fu_getscreensize (ref integer screen_width, ref integer screen_height)
public subroutine fu_getresources (ref unsignedinteger resources[])
public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string column_pict, string where_clause, string all_keyword)
public function integer fu_loadcode (datawindow dw_name, string dw_column, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword)
public function integer fu_login (string login_title, integer grace_logins, boolean attempt_connection, string login_bitmap, ref transaction trans_object)
public function boolean fu_message (string message_title, ref string message_text, boolean display_only, unsignedlong back_color, unsignedlong text_color)
public function integer fu_microhelp (window mdi_frame, integer update_seconds, boolean show_clock, boolean show_resources)
public function integer fu_plaque (string application_name, string application_rev, string application_bitmap)
public function string fu_quotestring (string quote_string, string quote_char)
public function integer fu_recordconfirm (string labels[], string action, ref boolean confirm[])
public subroutine fu_resizecontrols (powerobject container_name, ref integer original_sizes[], boolean zoom)
public subroutine fu_resizeresolution (powerobject container_name, integer resolution_width, integer resolution_height, boolean resize_controls)
public function string fu_selectcode (powerobject control_name)
public function string fu_selectcode (datawindow dw_name, string dw_column)
public function integer fu_setcode (powerobject control_name, string default_code)
public function integer fu_setcode (powerobject control_name, string default_code[])
public function integer fu_setcode (datawindow dw_name, string dw_column, string default_code)
public function integer fu_setlogin (ref transaction trans_object, string usr_login, string usr_password)
public function integer fu_syserror (string syserror_title)
public function integer fu_timer (string timer_title)
public subroutine fu_timercalc (datawindow dw_seq_name, datawindow dw_call_name)
public function decimal fu_timerelapsed (time start_time, time end_time)
public subroutine fu_timermark (string label)
public subroutine fu_timeroff (string label)
public subroutine fu_timeron ()
public function integer fu_validatedate (ref string value, string format, boolean display_error)
public function integer fu_validatedec (ref string value, string format, boolean display_error)
public function integer fu_validatedom (ref string value, string format, boolean display_error)
public function integer fu_validatedow (ref string value, string format, boolean display_error)
public function integer fu_validatemon (ref string value, string format, boolean display_error)
public function integer fu_validatetime (ref string value, string format, boolean display_error)
public function integer fu_validateyear (ref string value, string format, boolean display_error)
public function integer fu_validateint (ref string value, string format, boolean display_error)
public function integer fu_validatemaxlen (string value, long length, boolean display_error)
public function integer fu_validateminlen (string value, long length, boolean display_error)
public function integer fu_validatege (string value, real compare, boolean display_error)
public function integer fu_validategt (string value, real compare, boolean display_error)
public function integer fu_validatele (string value, real compare, boolean display_error)
public function integer fu_validatelt (string value, real compare, boolean display_error)
public function integer fu_undelete (datawindow dw_name)
public function integer fu_validatelength (string value, long length, boolean display_error)
public function string fu_setdatedb (string column_string, string date_string, string date_format, string relative_operator, transaction transaction_object)
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
public function integer fu_sort (datawindow dw_name)
public subroutine fu_setapplication (integer info_type, string info_value)
public function string fu_getapplication (integer info_type)
public function integer fu_about ()
public function integer fu_plaque ()
public subroutine fu_setapplication (string app_name, string app_rev, string app_bitmap, string app_inifile, string app_copyright)
public subroutine fu_setmicrohelp (string help_id)
public subroutine fu_microhelpposition ()
public subroutine fu_microhelpclose ()
public subroutine fu_setmicrohelp (string help_id, integer num_strings, string string_parms[])
public function integer fu_createmanagers (string managers)
public function integer fu_destroymanagers (string managers)
public function integer fu_selectcode (powerobject control_name, ref string codes[])
public function integer fu_getconnectinfo (string reg_key, ref transaction trans_object)
public function integer fu_setlog (string string_parms[])
public function string fu_getdefault (string object_type, string default_type)
public function integer fu_setdefault (string object_type, string default_type, string value)
public function integer fu_logwrite (string log_id, string log_strings[])
public function integer fu_logstart (string log_id)
public function integer fu_logend (string log_id)
public subroutine fu_traceon ()
public subroutine fu_traceoff ()
public subroutine fu_logoptions (string log_id, string file_name, string column_titles[], string options)
public subroutine fu_logoptions (string log_id, transaction trans_object, string column_titles[], string options)
public subroutine fu_drillresize (powerobject container_name, ref integer original_sizes[], ref integer index, boolean zoom, boolean got_sizes)
public subroutine fu_zoomcontrols (dragobject control_name, ref integer original_sizes[], integer index, real scale_area, boolean got_sizes)
public function integer fu_validatezip (ref string value, boolean display_error)
public function integer fu_validatefmt (ref string value, string pattern, boolean display_error)
public function integer fu_validatephone (ref string value, boolean display_error)
public function integer fu_filesaveas (datastore datastore, ref string directory)
end prototypes

public function integer fu_about (string application_name, string application_rev, string application_copyright, string application_bitmap);RETURN 0
end function

public function unsignedlong fu_bitmask (unsignedlong operand1, unsignedlong operand2);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_BitMask
//  Description   : Returns the logical AND of the parameters.
//
//  Parameters    : UNSIGNEDLONG Operand1
//                  UNSIGNEDLONG Operand2
//
//  Return Value  : UNSIGNEDLONG
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN      l_Bit1,   l_Bit2
INTEGER      l_Idx
UNSIGNEDLONG l_Return, l_Divided

//------------------------------------------------------------------
//  Initialize the return value to cleared state.
//------------------------------------------------------------------

l_Return = 0

//------------------------------------------------------------------
//  Step through each bit.  If both bits are set then set the
//  corresponding bit in the return value.
//------------------------------------------------------------------

FOR l_Idx = 1 TO 32

   //---------------------------------------------------------------
   //  Right shift the return value.
   //---------------------------------------------------------------

   l_Return /= 2

   //---------------------------------------------------------------
   //  See if the the first operand is odd.  If it is, then we know
   //  the low order bit is set.  Since dividing by 2 shifts a value
   //  right by one bit, we can save l_Divided into the operand so
   //  that the next time through the loop we'll be ready to test
   //  the next bit.
   //---------------------------------------------------------------

   l_Divided = Operand1 / 2
   l_Bit1    = (2 * l_Divided <> Operand1)
   Operand1  = l_Divided

   //---------------------------------------------------------------
   //  See if the the second operand is odd.  If it is, then we know
   //  the low order bit is set.  Since dividing by 2 shifts a value
   //  right by one bit, we can save l_Divided into the operand so
   //  that the next time through the loop we'll be ready to test
   //  the next bit.
   //---------------------------------------------------------------

   l_Divided = Operand2 / 2
   l_Bit2    = (2 * l_Divided <> Operand2)
   Operand2  = l_Divided

   //---------------------------------------------------------------
   //  If both bits are set, then set the high bit in the return
   //  value.  It will get shifted to the appropriate position by
   //  the time we are done.
   //---------------------------------------------------------------

   IF l_Bit1 AND l_Bit2 THEN
      l_Return += 2147483648
   END IF
NEXT

RETURN l_Return
end function

public subroutine fu_centerwindow (window window_name);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_CenterWindow
//  Description   : Centers the window in the middle of the screen.
//
//  Parameters    : WINDOW Window_Name  -
//                     Name of window to center.
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

INTEGER  l_ScreenWidth, l_ScreenHeight

//------------------------------------------------------------------
//  Get the screen width and height.
//------------------------------------------------------------------

fu_GetScreenSize(l_ScreenWidth, l_ScreenHeight)

//------------------------------------------------------------------
//  Center the window.
//------------------------------------------------------------------

Window_Name.Move((l_ScreenWidth  - Window_Name.Width)  / 2, &
                 (l_ScreenHeight - Window_Name.Height) / 2)

end subroutine

public function integer fu_connect (transaction trans_object, boolean allow_correction);RETURN 0
end function

public function integer fu_fileconfirm (string from_directory, string to_directory, string files[], ref boolean copymove[]);RETURN 0
end function

public function integer fu_filecopy (string from_file, string to_file);RETURN 0
end function

public function integer fu_filecopymove (string from_directory, string to_directory, string files[], string copy_or_move, boolean confirm, boolean display);RETURN 0
end function

public function integer fu_filemove (string from_file, string to_file);RETURN 0
end function

public function integer fu_filesaveas (datawindow datawindow, ref string directory);RETURN 0
end function

public function string fu_formatstring (string format_string, integer num_numbers, real number_parms[], integer num_strings, string string_parms[]);//******************************************************************
//  PO Module     : n_POManager
//  Function      : fu_FormatString
//  Description   : Substitues values into a string.  Number
//                  substitutions are made when "%<pos>d" is
//                  found and string substitutions are made
//                  when "%<pos>s" is found.  If there are not
//                  enough parameters (e.g. %2d was specified,
//                  but no numbers were passed), the format
//                  string and all spaces following it  will
//                  be deleted from the output. An example
//                  string passed as Format_String would be:
//                     "Str #2: %2s; Str #1: %1s, Num: %1d"
//
//  Parameters    : STRING  Format_String -
//                     The format string which specifies
//                     the substitutions are to be done.
//
//                  INTEGER Num_Numbers -
//                     The number of real parameters to
//                     be substituted into the Format_String.
//
//                  REAL    Number_Parms[] -
//                     An array containing the REAL
//                     parameters to be substituted into
//                     the Format_String.
//
//                  INTEGER Num_Strings -
//                     The number of string parameters to
//                     be substituted into the Format_String.
//
//                  STRING  String_Parms[] -
//                     An array containing the string
//                     parameters to be substituted into
//                     the Format_String.
//
//  Return Value  : STRING -
//                     The string produced by the formatting.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

STRING   c_FormatChar = "%"

BOOLEAN  l_Quoted,    l_DoSub,     l_KillFormat
INTEGER  l_Length,    l_FormatPos, l_ParmNum, l_EndPos, l_Idx
INTEGER  l_Zero,      l_Nine,      l_TmpAsc
STRING   l_FormatStr, l_SubStr,    l_Num,     l_TmpChar

//------------------------------------------------------------------
//  See if there are any formatting characters in Format_String.
//  If there are not, then we can just return Format_String.
//------------------------------------------------------------------

l_FormatPos = Pos(Format_String, c_FormatChar)
IF l_FormatPos = 0 THEN
   l_FormatStr = Format_String
   RETURN l_FormatStr
END IF

//------------------------------------------------------------------
//  Find every format character in Format_String and determine
//  its type and substitution number and then substitute it.
//------------------------------------------------------------------

l_FormatStr = Format_String
l_Length    = Len(l_FormatStr)
l_Zero      = Asc("0")
l_Nine      = Asc("9")

DO WHILE l_FormatPos > 0

   //---------------------------------------------------------------
   //  We found a character that may begin a format.  See if it
   //  is quoted.
   //---------------------------------------------------------------

   l_Quoted = FALSE
   IF l_FormatPos > 1 THEN
      l_Idx     = l_FormatPos - 1
      l_TmpChar = Mid(l_FormatStr, l_Idx, 1)

      DO WHILE l_TmpChar = "~~"
         l_Quoted = (NOT l_Quoted)
         l_Idx    = l_Idx - 1
         IF l_Idx > 0 THEN
            l_TmpChar = Mid(l_FormatStr, l_Idx, 1)
         ELSE
            l_TmpChar = ""
         END IF
      LOOP
   END IF

   //---------------------------------------------------------------
   //  If the character has not already been quoted, then figure
   //  its position parameter.
   //---------------------------------------------------------------

   IF NOT l_Quoted THEN
      IF l_FormatPos < l_Length THEN
         l_Num     = "0"

         l_EndPos  = l_FormatPos + 1
         l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)
         l_TmpAsc  = Asc(l_TmpChar)

         DO WHILE l_TmpAsc >= l_Zero AND l_TmpAsc <= l_Nine
            l_Num    = l_Num    + l_TmpChar
            l_EndPos = l_EndPos + 1
            IF l_EndPos <= l_Length THEN
               l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)
               l_TmpAsc  = Asc(l_TmpChar)
            ELSE
               l_TmpChar = ""
               l_TmpAsc  = 0
            END IF
         LOOP

         //---------------------------------------------------------
         //  If not parameter position was specified, assume 1.
         //---------------------------------------------------------

         l_ParmNum = Integer(l_Num)

         IF l_ParmNum < 1 THEN
            l_ParmNum = 1
         END IF

         //---------------------------------------------------------
         //  See if we have a string substitution.
         //---------------------------------------------------------

         l_DoSub      = FALSE
         l_KillFormat = FALSE

         IF l_TmpChar = "s" THEN

            //------------------------------------------------------
            //  Is it a valid parameter number?
            //------------------------------------------------------

            l_DoSub = (l_ParmNum <= Num_Strings)
            IF l_DoSub THEN
               l_SubStr = String_Parms[l_ParmNum]
					IF IsNull(l_SubStr) THEN
						l_SubStr = ""
					END IF
            ELSE
               l_KillFormat = TRUE
            END IF
         ELSE

            //------------------------------------------------------
            //  See if we have a number substitution.
            //------------------------------------------------------

            IF l_TmpChar = "d" THEN

               //---------------------------------------------------
               //  Is it a valid parameter number?
               //---------------------------------------------------

               l_DoSub = (l_ParmNum <= Num_Numbers)

               IF l_DoSub THEN
                  l_SubStr = String(Number_Parms[l_ParmNum])
						IF IsNull(l_SubStr) THEN
							l_SubStr = ""
						END IF
               ELSE
                  l_KillFormat = TRUE
               END IF
            END IF
         END IF

         //---------------------------------------------------------
         //  Nothing to substitute - kill the format.
         //---------------------------------------------------------

         IF l_KillFormat THEN
            l_DoSub = TRUE

            IF l_EndPos < l_Length THEN
               l_EndPos  = l_EndPos + 1
               l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)

               DO WHILE l_TmpChar = " "
                  l_EndPos = l_EndPos + 1
                  IF l_EndPos <= l_Length THEN
                     l_TmpChar = Mid(l_FormatStr, l_EndPos, 1)
                  ELSE
                     l_TmpChar = ""
                  END IF
               LOOP

               l_EndPos = l_EndPos - 1
            END IF

            l_SubStr = ""
         END IF

         IF l_DoSub THEN
            l_FormatStr = Replace(l_FormatStr,                &
                                  l_FormatPos,                &
                                  l_EndPos - l_FormatPos + 1, &
                                  l_SubStr)
            l_Length    = Len(l_FormatStr)
            l_FormatPos = l_FormatPos + Len(l_SubStr) - 1
         END IF
      END IF
   END IF

   //---------------------------------------------------------------
   //  Find the next format character.
   //---------------------------------------------------------------

   l_FormatPos = Pos(l_FormatStr, c_FormatChar, l_FormatPos + 1)
LOOP

RETURN l_FormatStr
end function

public subroutine fu_getcascadesize (ref integer cascade_y, ref integer cascade_x);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Subroutine    : fu_GetCascadeSize
//  Description   : Returns the X and Y positions for cascading a
//                  window.
//
//  Parameters    : ref INTEGER Cascade_Y -
//                     The number of Y units down to position a
//                     window.
//                  ref INTEGER Cascade_X -
//                     The number of X units over to position a
//                     window.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

Cascade_X = PixelsToUnits(i_TitleHeight - (2 * i_BorderWidth) + &
                          (i_FrameWidth * 2), XPixelsToUnits!)
Cascade_Y = PixelsToUnits(i_TitleHeight - (2 * i_BorderHeight) + &
                          (i_FrameHeight * 2), YPixelsToUnits!)

RETURN
end subroutine

public function integer fu_getconnectinfo (string ini_file, string ini_section, ref transaction trans_object);RETURN 0
end function

public subroutine fu_getframesize (ref integer frame_width, ref integer frame_height);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_GetFrameSize
//  Description   :
//
//  Parameters    : ref INTEGER  Frame_Width -
//                     Width of the window frame.
//                  ref INTEGER  Frame_Height -
//                     Height of the window frame.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

Frame_Width  = PixelsToUnits(i_FrameWidth,  XPixelsToUnits!)
Frame_Height = PixelsToUnits(i_FrameHeight, YPixelsToUnits!)

RETURN
end subroutine

public function string fu_getlogin (transaction trans_object);RETURN ""
end function

public subroutine fu_getscreensize (ref integer screen_width, ref integer screen_height);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_GetScreenSize
//  Description   :
//
//  Parameters    : ref INTEGER Screen_Width -
//                     Screen width.
//                  ref INTEGER Screen_Height -
//                     Screen height.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

Screen_Width  = PixelsToUnits(i_ENV.ScreenWidth, XPixelsToUnits!)
Screen_Height = PixelsToUnits(i_ENV.ScreenHeight, YPixelsToUnits!)

RETURN
end subroutine

public subroutine fu_getresources (ref unsignedinteger resources[]);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_GetResources
//  Description   :
//
//  Parameters    : ref UNSIGNEDINTEGER  Resources[] -
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

INTEGER       l_Idx
S_RESOURCES   l_MemStatus

IF NOT i_Env.Win16 THEN
	l_MemStatus.dwLength = 32
	GlobalMemoryStatus(l_MemStatus)

	Resources[3] = 100 - l_MemStatus.dwMemoryLoad
	Resources[2] = 100.0 * (l_MemStatus.dwAvailPhys / &
   	            l_MemStatus.dwTotalPhys)
	Resources[1] = 100.0 * (l_MemStatus.dwAvailPageFile / &
   	            l_MemStatus.dwTotalPageFile)

	FOR l_Idx = 1 TO 3
   	IF Resources[l_Idx] < 0 THEN
      	Resources[l_Idx] = 0
   	END IF
   	IF Resources[l_Idx] > 100 THEN
      	Resources[l_Idx] = 100
   	END IF
	NEXT
ELSE
   Resources[3] = GetFreeSystemResources(2)
   Resources[2] = GetFreeSystemResources(1)
   Resources[1] = GetFreeSystemResources(0)
END IF

end subroutine

public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword);RETURN 0
end function

public function integer fu_loadcode (powerobject control_name, transaction trans_object, string table_name, string column_code, string column_desc, string column_pict, string where_clause, string all_keyword);RETURN 0
end function

public function integer fu_loadcode (datawindow dw_name, string dw_column, transaction trans_object, string table_name, string column_code, string column_desc, string where_clause, string all_keyword);RETURN 0
end function

public function integer fu_login (string login_title, integer grace_logins, boolean attempt_connection, string login_bitmap, ref transaction trans_object);RETURN 0
end function

public function boolean fu_message (string message_title, ref string message_text, boolean display_only, unsignedlong back_color, unsignedlong text_color);RETURN TRUE
end function

public function integer fu_microhelp (window mdi_frame, integer update_seconds, boolean show_clock, boolean show_resources);RETURN 0
end function

public function integer fu_plaque (string application_name, string application_rev, string application_bitmap);RETURN 0
end function

public function string fu_quotestring (string quote_string, string quote_char);//******************************************************************
//  PO Module     : n_POManager
//  Function      : fu_QuoteString
//  Description   : Adds the PowerBuilder escape character ("~")
//                  to prevent PowerBuilder from doing special
//                  interpetion of the character specifed by
//                  Quote_Char.
//
//  Parameters    : STRING Quote_String -
//                     The string that needs to be quoted.
//
//                  STRING Quote_Char
//                     The character to be quoted.
//
//  Return Value  : STRING -
//                     The result of the quoting operation.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

BOOLEAN  l_Quoted
INTEGER  l_QuotePos,   l_StartPos, l_Idx
STRING   l_QuotedChar, l_FixedStr, l_TmpChar

//------------------------------------------------------------------
//  See if there are any characters to be quoted in Quote_String.
//  If there are not, then we can just return Quote_String.
//------------------------------------------------------------------

l_QuotePos = Pos(Quote_String, Quote_Char)
IF l_QuotePos = 0 THEN
   l_FixedStr = Quote_String
   RETURN l_FixedStr
END IF

//------------------------------------------------------------------
//  For every character to be quoted in Fix_String, we need to
//  precede it with the PowerBuilder quote character (~), if it
//  has not already been quoted.
//------------------------------------------------------------------

l_FixedStr   = ""
l_StartPos   = 1
l_QuotedChar = "~~" + Quote_Char

DO WHILE l_QuotePos > 0

   //---------------------------------------------------------------
   //  We found a character that needs to be quoted.  Make sure
   //  that it is not already quoted.
   //---------------------------------------------------------------

   l_Quoted = FALSE
   IF l_QuotePos > 1 THEN
      l_Idx     = l_QuotePos - 1
      l_TmpChar = Mid(Quote_String, l_Idx, 1)

      DO WHILE l_TmpChar = "~~"
         l_Quoted = (NOT l_Quoted)
         l_Idx    = l_Idx - 1
         IF l_Idx > 0 THEN
            l_TmpChar = Mid(Quote_String, l_Idx, 1)
         ELSE
            l_TmpChar = ""
         END IF
      LOOP
   END IF

   //---------------------------------------------------------------
   //  If the character has not already been quoted, then add
   //  the string and the quoted character.
   //---------------------------------------------------------------

   IF NOT l_Quoted THEN
      l_FixedStr = l_FixedStr +                   &
                   Mid(Quote_String, l_StartPos,    &
                       l_QuotePos - l_StartPos) + &
                   l_QuotedChar
      l_StartPos = l_QuotePos + 1
   END IF

   //---------------------------------------------------------------
   //  Find the next character to be quoted.
   //---------------------------------------------------------------

   l_QuotePos = Pos(Quote_String, Quote_Char, l_QuotePos + 1)
LOOP

//------------------------------------------------------------------
//  Add what remains of the string after the last quoted character.
//------------------------------------------------------------------

l_FixedStr = l_FixedStr + Mid(Quote_String, l_StartPos)

RETURN l_FixedStr
end function

public function integer fu_recordconfirm (string labels[], string action, ref boolean confirm[]);RETURN 0
end function

public subroutine fu_resizecontrols (powerobject container_name, ref integer original_sizes[], boolean zoom);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_ResizeControls
//  Description   : Resize the controls within a window or user
//                  object.
//
//  Parameters    : POWEROBJECT Container_Name  -
//                     Name of window or user object containing the
//                     controls to resize.
//                  INTEGER     Original_Size  -
//                     An array containing the original X, Y, Width,
//                     and Height of the objects on the window or
//                     user object.  The developer passes an empty
//                     array.  The first two elements include the
//                     original Height and Width of the window or
//                     user object.
//                  BOOLEAN     Zoom            -
//                     Should the objects be resized by cropping
//                     (FALSE) or zooming (TRUE).
// 
//  Return Value  : (None)
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
// 10/23/98  Beth Byers	If the new width or height = 0 , set it to 1
//								to avoid divide by zero errors
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

WINDOW          l_Window
USEROBJECT      l_UserObject
DRAGOBJECT      l_ControlName
OBJECT          l_TypeOf
LINE            l_LineName
OVAL            l_OvalName
RECTANGLE       l_RectName
ROUNDRECTANGLE  l_RoundRectName
TAB             l_Tab
INTEGER         l_NewWidth, l_NewHeight, l_Idx, l_NumControls
INTEGER         l_OrigWidth, l_OrigHeight
INTEGER         l_X, l_Y, l_Width, l_Height, l_Index, l_Total
INTEGER         l_X1, l_X2, l_Y1, l_Y2, l_Jdx, l_NumTabs
INTEGER         l_TabSizes[], l_TabIndex
REAL            l_NewScaleX, l_NewScaleY, l_AspectRatio
REAL            l_NewScaleArea, l_TmpNewWidth, l_TmpNewHeight
BOOLEAN         l_GotSizes
STRING          l_POObject, l_Type

//------------------------------------------------------------
//  Determine if the original sizes of the controls in the
//  window or user object are already there.
//------------------------------------------------------------

l_Index = 0
l_Total = UpperBound(original_sizes[])
IF l_Total > 2 THEN
   l_GotSizes = TRUE
ELSE
   l_GotSizes = FALSE
END IF

//------------------------------------------------------------
//  Determine if the container for the controls is a window or
//  a custom user object.
//------------------------------------------------------------

IF container_name.TypeOf() = Window! THEN
   l_Window     = container_name

	//---------------------------------------------------------
	//  If the new width or height = 0 , set them to = 1
	//---------------------------------------------------------

   l_NewWidth   = l_Window.WorkSpaceWidth()
	IF l_NewWidth = 0 then l_NewWidth = 1
   l_NewHeight  = l_Window.WorkSpaceHeight()
	IF l_NewHeight = 0 then l_NewHeight = 1
   
	l_Index = l_Index + 1
   IF NOT l_GotSizes AND l_Total = 0 THEN
      original_sizes[l_Index] = l_NewWidth
   END IF
   l_Index = l_Index + 1
   IF NOT l_GotSizes AND l_Total = 0 THEN
      original_sizes[l_Index] = l_NewHeight
   END IF
	
	IF l_Window.WindowState = Maximized! AND original_sizes[1] > 0 THEN
		original_sizes[1] = original_sizes[1] * -1
		original_sizes[2] = original_sizes[2] * -1
	END IF

	//---------------------------------------------------------
	//  Determine if the container has changed size.  If not, 
	//  return.
	//---------------------------------------------------------

	IF l_NewWidth = original_sizes[1] AND &
   	l_NewHeight = original_sizes[2] THEN
   	RETURN
	END IF
ELSE
   l_UserObject = container_name
	
	//---------------------------------------------------------
	//  If the new width or height = 0 , set them to = 1
	//---------------------------------------------------------

   l_NewWidth   = l_UserObject.Width
	IF l_NewWidth = 0 then l_NewWidth = 1
   l_NewHeight  = l_UserObject.Height
	IF l_NewHeight = 0 then l_NewHeight = 1

   l_Index = l_Index + 1
   IF NOT l_GotSizes AND l_Total = 0 THEN
      original_sizes[l_Index] = l_NewWidth
   END IF
   l_Index = l_Index + 1
   IF NOT l_GotSizes AND l_Total = 0 THEN
      original_sizes[l_Index] = l_NewHeight
   END IF
END IF

l_OrigWidth  = Abs(original_sizes[1])
l_OrigHeight = Abs(original_sizes[2])

IF container_name.TypeOf() = Window! THEN
   l_Window.SetRedraw(FALSE)
	IF l_Window.WindowState <> Maximized! AND original_sizes[1] < 0 THEN
		original_sizes[1] = original_sizes[1] * -1
		original_sizes[2] = original_sizes[2] * -1
	END IF
END IF

//------------------------------------------------------------
//  Calculate the ratio of the new size to the original size.
//------------------------------------------------------------

l_AspectRatio = l_OrigWidth / l_OrigHeight
l_NewScaleX   = l_NewWidth  / l_OrigWidth
l_NewScaleY   = l_NewHeight / l_OrigHeight

IF l_NewWidth/l_NewHeight <= l_AspectRatio THEN
   l_TmpNewWidth  = l_NewWidth
   l_TmpNewHeight = l_NewWidth / l_AspectRatio
ELSE
   l_TmpNewHeight = l_NewHeight
   l_TmpNewWidth  = l_NewHeight * l_AspectRatio
END IF

l_NewScaleArea = SQRT ((l_TmpNewWidth * l_TmpNewHeight) / &
                       (l_OrigWidth * l_OrigHeight))

IF zoom THEN
	l_NewScaleX = l_NewScaleArea
	l_NewScaleY = l_NewScaleArea
END IF
	
//------------------------------------------------------------
//  Fix the size of the controls
//------------------------------------------------------------

IF container_name.TypeOf() = Window! THEN
   l_NumControls = UpperBound(l_Window.Control[])
ELSE
   l_NumControls = UpperBound(l_UserObject.Control[])
END IF

FOR l_Idx = 1 TO l_NumControls
   IF container_name.TypeOf() = Window! THEN
      l_TypeOf      = l_Window.Control[l_Idx].TypeOf()
		CHOOSE CASE l_TypeOf
			CASE Line!
				l_Type = "LINE"
				l_LineName = l_Window.Control[l_Idx]
			CASE Oval!
				l_Type = "OVAL"
				l_OvalName = l_Window.Control[l_Idx]
			CASE Rectangle!
				l_Type = "RECTANGLE"
				l_RectName = l_Window.Control[l_Idx]
			CASE RoundRectangle!
				l_Type = "ROUNDRECTANGLE"
				l_RoundRectName = l_Window.Control[l_Idx]
			CASE ELSE
//??				#IF NOT defined PBDOTNET THEN
					l_Type = "DRAGOBJECT"
					l_ControlName = l_Window.Control[l_Idx]
//??				#ELSE
//??					l_Type = ""
//??				#END IF
		END CHOOSE
   ELSE
      l_TypeOf      = l_UserObject.Control[l_Idx].TypeOf()
		CHOOSE CASE l_TypeOf
			CASE Line!
				l_Type = "LINE"
				l_LineName = l_UserObject.Control[l_Idx]
			CASE Oval!
				l_Type = "OVAL"
				l_OvalName = l_UserObject.Control[l_Idx]
			CASE Rectangle!
				l_Type = "RECTANGLE"
				l_RectName = l_UserObject.Control[l_Idx]
			CASE RoundRectangle!
				l_Type = "ROUNDRECTANGLE"
				l_RoundRectName = l_UserObject.Control[l_Idx]
			CASE ELSE
//??				#IF NOT defined PBDOTNET THEN
					l_Type = "DRAGOBJECT"
					l_ControlName = l_UserObject.Control[l_Idx]
//??				#ELSE
//??					l_Type = ""
//??				#END IF
		END CHOOSE
   END IF

   IF NOT l_GotSizes THEN
		CHOOSE CASE l_Type
			CASE "LINE"
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_LineName.BeginX
            l_X1 = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_LineName.BeginY
            l_Y1 = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_LineName.EndX
            l_X2 = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_LineName.EndY
            l_Y2 = original_sizes[l_Index]
			CASE "OVAL"
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_OvalName.X
            l_X = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_OvalName.Y
            l_Y = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_OvalName.Width
            l_Width = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_OvalName.Height
            l_Height = original_sizes[l_Index]
			CASE "RECTANGLE"
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RectName.X
            l_X = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RectName.Y
            l_Y = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RectName.Width
            l_Width = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RectName.Height
            l_Height = original_sizes[l_Index]
			CASE "ROUNDRECTANGLE"
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RoundRectName.X
            l_X = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RoundRectName.Y
            l_Y = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RoundRectName.Width
            l_Width = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_RoundRectName.Height
            l_Height = original_sizes[l_Index]
			CASE "DRAGOBJECT"
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_ControlName.X
            l_X = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_ControlName.Y
            l_Y = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_ControlName.Width
            l_Width = original_sizes[l_Index]
            l_Index = l_Index + 1
            original_sizes[l_Index] = l_ControlName.Height
            l_Height = original_sizes[l_Index]
		END CHOOSE
   ELSE
		IF l_Type = "LINE" THEN
         l_Index = l_Index + 1
         l_X1 = original_sizes[l_Index]
         l_Index = l_Index + 1
         l_Y1 = original_sizes[l_Index]
         l_Index = l_Index + 1
         l_X2 = original_sizes[l_Index]
         l_Index = l_Index + 1
         l_Y2 = original_sizes[l_Index]
		ELSE
         l_Index = l_Index + 1
         l_X = original_sizes[l_Index]
         l_Index = l_Index + 1
         l_Y = original_sizes[l_Index]
         l_Index = l_Index + 1
         l_Width = original_sizes[l_Index]
         l_Index = l_Index + 1
         l_Height = original_sizes[l_Index]
		END IF
   END IF

   l_Index = l_Index + 1

   IF l_ControlName.TriggerEvent("po_identify") = 1 THEN
		l_POObject = l_ControlName.DYNAMIC fu_GetIdentity()
	ELSE
      l_POObject = ""
	END IF

	IF zoom THEN
		IF l_Type = "DRAGOBJECT" AND l_POObject <> "Folder" AND &
			l_POObject <> "Calendar" THEN
			fu_ZoomControls(l_ControlName, original_sizes[], &
                         l_Index, l_NewScaleArea, l_GotSizes)
		END IF
	END IF

   IF l_POObject <> "Container" THEN
		CHOOSE CASE l_Type
			CASE "LINE"
		      l_LineName.BeginX = l_NewScaleX * l_X1
            l_LineName.BeginY = l_NewScaleY * l_Y1
            l_LineName.EndX   = l_NewScaleX * l_X2
            l_LineName.EndY   = l_NewScaleY * l_Y2
			CASE "OVAL"
     	      l_OvalName.Move(l_NewScaleX * l_X, &
                            l_NewScaleY * l_Y)
     	      l_OvalName.Resize(l_NewScaleX * l_Width, &
                              l_NewScaleY * l_Height)
			CASE "RECTANGLE"
     	      l_RectName.Move(l_NewScaleX * l_X, &
                            l_NewScaleY * l_Y)
     	      l_RectName.Resize(l_NewScaleX * l_Width, &
                              l_NewScaleY * l_Height)
			CASE "ROUNDRECTANGLE"
     	      l_RoundRectName.Move(l_NewScaleX * l_X, &
                                 l_NewScaleY * l_Y)
     	      l_RoundRectName.Resize(l_NewScaleX * l_Width, &
                                   l_NewScaleY * l_Height)
			CASE "DRAGOBJECT"
				IF l_ControlName.TypeOf() = Tab! THEN
					l_Tab = l_ControlName
					l_NumTabs = UpperBound(l_Tab.Control[])
					IF NOT l_GotSizes THEN
						l_TabIndex = 0
					   FOR l_Jdx = 1 TO l_NumTabs
							l_TabIndex++
							l_TabSizes[l_TabIndex] = l_Tab.Control[l_Jdx].Width
							l_TabIndex++
							l_TabSizes[l_TabIndex] = l_Tab.Control[l_Jdx].Height
					   NEXT
					END IF
				END IF
     	      l_ControlName.Move(l_NewScaleX * l_X, &
                               l_NewScaleY * l_Y)
     	      l_ControlName.Resize(l_NewScaleX * l_Width, &
                                 l_NewScaleY * l_Height)
		END CHOOSE
   END IF
	
   //---------------------------------------------------------------
   //  If the control is a user object or tab object, drill the 
   //  resize operation down to the next level.
   //---------------------------------------------------------------
	
	IF l_Type = "DRAGOBJECT" THEN
		CHOOSE CASE l_ControlName.TypeOf()
			CASE UserObject!
				IF l_POObject <> "Container" THEN
				   fu_DrillResize(l_ControlName, Original_Sizes[], &
				                  l_Index, Zoom, l_GotSizes)
				END IF
			CASE Tab!
				l_TabIndex = 0
				FOR l_Jdx = 1 TO l_NumTabs
					IF NOT l_GotSizes THEN
						l_Index = l_Index + 1
						l_TabIndex++
						Original_Sizes[l_Index] = l_TabSizes[l_TabIndex]
						l_Index = l_Index + 1
						l_TabIndex++
						Original_Sizes[l_Index] = l_TabSizes[l_TabIndex]
					ELSE
						l_Index = l_Index + 2
					END IF
					fu_DrillResize(l_Tab.Control[l_Jdx], &
					               Original_Sizes[], l_Index, &
										Zoom, l_GotSizes)
				NEXT
		END CHOOSE
	END IF
NEXT

IF container_name.TypeOf() = Window! THEN
   l_Window.SetRedraw(TRUE)
END IF

RETURN
end subroutine

public subroutine fu_resizeresolution (powerobject container_name, integer resolution_width, integer resolution_height, boolean resize_controls);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_ResizeResolution
//  Description   : Resize the controls on the window or user object
//                  based on the ratio of the size it was 
//                  developed under vs displayed under.
//
//  Parameters    : POWEROBJECT Container_Name  -
//                     Name of window or user object containing the
//                     controls to resize.
//                  INTEGER  Resolution_Width  -
//                     Resolution width of the window when it was
//                     developed.
//                  INTEGER  Resolution_Height -
//                     Resolution height of the window when it was
//                     developed.
//                  BOOLEAN  Resize_Controls   -
//                     Cause the controls in the container to be 
//                     resized after the window is resized.  Set
//                     to FALSE if the containers RESIZE event
//                     already includes a call to fu_ResizeControls
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

WINDOW     l_Window
USEROBJECT l_UserObject
INTEGER    l_Width, l_Height, l_NewWidth, l_NewHeight, l_Sizes[]

//------------------------------------------------------------------
//  Determine if the container was developed in the same resolution
//  as its being displayed in.
//------------------------------------------------------------------

IF i_ENV.ScreenWidth <> resolution_width OR &
   i_ENV.ScreenHeight <> resolution_height THEN

   //---------------------------------------------------------------
   //  Determine the type of container, window or user object.  Get
   //  the width and height of the object.
   //---------------------------------------------------------------

   IF container_name.TypeOf() = Window! THEN
      l_Window     = container_name
      l_Width      = l_Window.WorkSpaceWidth()
      l_Height     = l_Window.WorkSpaceHeight()
   ELSE
      l_UserObject = container_name
      l_Width      = l_UserObject.Width
      l_Height     = l_UserObject.Height
   END IF

   //---------------------------------------------------------------
   //  Calculate the new width and height depending on the ratio
   //  of the resolution during development and display.
   //---------------------------------------------------------------

   l_NewWidth  = l_Width * (i_ENV.ScreenWidth / &
                 resolution_width)
   l_NewHeight = l_Height * (i_ENV.ScreenHeight / &
                 resolution_height)

   //---------------------------------------------------------------
   //  Resize the container with the new width and height.
   //---------------------------------------------------------------

   IF container_name.TypeOf() = Window! THEN
      l_Window.Resize(l_NewWidth, l_NewHeight)
   ELSE
      l_UserObject.Resize(l_NewWidth, l_NewHeight)
   END IF

   //---------------------------------------------------------------
   //  Resize the controls in the container.
   //---------------------------------------------------------------

   IF resize_controls THEN
      l_Sizes[1] = l_Width
      l_Sizes[2] = l_Height
      fu_ResizeControls(container_name, l_Sizes[], TRUE)
   END IF

END IF

RETURN
end subroutine

public function string fu_selectcode (powerobject control_name);RETURN ""
end function

public function string fu_selectcode (datawindow dw_name, string dw_column);RETURN ""
end function

public function integer fu_setcode (powerobject control_name, string default_code);RETURN 0
end function

public function integer fu_setcode (powerobject control_name, string default_code[]);RETURN 0
end function

public function integer fu_setcode (datawindow dw_name, string dw_column, string default_code);RETURN 0
end function

public function integer fu_setlogin (ref transaction trans_object, string usr_login, string usr_password);RETURN 0
end function

public function integer fu_syserror (string syserror_title);RETURN 0
end function

public function integer fu_timer (string timer_title);RETURN 0
end function

public subroutine fu_timercalc (datawindow dw_seq_name, datawindow dw_call_name);
end subroutine

public function decimal fu_timerelapsed (time start_time, time end_time);RETURN 0.0
end function

public subroutine fu_timermark (string label);
end subroutine

public subroutine fu_timeroff (string label);
end subroutine

public subroutine fu_timeron ();
end subroutine

public function integer fu_validatedate (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validatedec (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validatedom (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validatedow (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validatemon (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validatetime (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validateyear (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validateint (ref string value, string format, boolean display_error);RETURN 0
end function

public function integer fu_validatemaxlen (string value, long length, boolean display_error);RETURN 0
end function

public function integer fu_validateminlen (string value, long length, boolean display_error);RETURN 0
end function

public function integer fu_validatege (string value, real compare, boolean display_error);RETURN 0
end function

public function integer fu_validategt (string value, real compare, boolean display_error);RETURN 0
end function

public function integer fu_validatele (string value, real compare, boolean display_error);RETURN 0
end function

public function integer fu_validatelt (string value, real compare, boolean display_error);RETURN 0
end function

public function integer fu_undelete (datawindow dw_name);RETURN 0
end function

public function integer fu_validatelength (string value, long length, boolean display_error);RETURN 0
end function

public function string fu_setdatedb (string column_string, string date_string, string date_format, string relative_operator, transaction transaction_object);RETURN ""
end function

public function string fu_setdateoracle (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);RETURN ""
end function

public function string fu_setdatesqlserver (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);RETURN ""
end function

public function string fu_setdatewatcom (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);RETURN ""
end function

public function string fu_setdatexdb (string month_string, string day_string, string year_string, string hour_string, string minute_string, string second_string, string fraction_string, string meridian_string, string relative_operator, string column_string);RETURN ""
end function

public function integer fu_setweekday (integer begin_day, integer end_day);RETURN 0
end function

public function integer fu_setweekend (integer begin_day, integer end_day);RETURN 0
end function

public function integer fu_setholiday (string holiday_name, date holiday_date);RETURN 0
end function

public function integer fu_setworkday (integer day_of_the_week, time begin_time, time end_time);RETURN 0
end function

public function long fu_datetojulian (date calendar_date, boolean use_current_year);RETURN 0
end function

public function date fu_juliantodate (long julian_date, boolean use_current_year);RETURN Date(1901, 1, 1)
end function

public function boolean fu_verifyleap (date calendar_date);RETURN FALSE
end function

public function date fu_getholiday (string holiday_name, integer holiday_year);RETURN Date(1901, 1, 1)
end function

public function string fu_getnextholiday (date calendar_date);RETURN ""
end function

public function boolean fu_verifybegofmonth (date calendar_date);RETURN FALSE
end function

public function boolean fu_verifyendofmonth (date calendar_date);RETURN FALSE
end function

public function boolean fu_verifyweekday (date calendar_date);RETURN FALSE
end function

public function boolean fu_verifyweekend (date calendar_date);RETURN FALSE
end function

public function date fu_getendofmonth (date calendar_date);RETURN Date(1901, 1, 1)
end function

public subroutine fu_getdatepartsfromjulian (long julian_date, boolean use_current_year, ref integer calendar_day, ref integer calendar_month, ref integer calendar_year);
end subroutine

public function date fu_getbegofweekday (date calendar_date);RETURN Date(1901, 1, 1)
end function

public function date fu_getbegofweekend (date calendar_date);RETURN Date(1901, 1, 1)
end function

public function date fu_getendofweekday (date calendar_date);RETURN Date(1901, 1, 1)
end function

public function date fu_getendofweekend (date calendar_date);RETURN Date(1901, 1, 1)
end function

public function date fu_addmonths (date calendar_date, long add_months);RETURN Date(1901, 1, 1)
end function

public function date fu_addweeks (date calendar_date, long add_weeks);RETURN Date(1901, 1, 1)
end function

public function time fu_secondstotime (long seconds);RETURN Time("12:00:00")
end function

public function long fu_timetoseconds (time time_of_day);RETURN 0
end function

public subroutine fu_gettimepartsfromseconds (long seconds_of_day, ref long hours, ref long minutes, ref long seconds);
end subroutine

public function boolean fu_verifyholiday (date calendar_date);RETURN FALSE
end function

public function integer fu_deleteschedule (integer day_of_the_week, string schedule_name);RETURN 0
end function

public function integer fu_resetschedule (integer day_of_the_week);RETURN 0
end function

public function integer fu_setschedule (integer day_of_the_week, string schedule_name, time begin_time, time end_time);RETURN 0
end function

public function boolean fu_verifyschedule (integer day_of_the_week, time time_of_day);RETURN FALSE
end function

public function boolean fu_verifyworkday (integer day_of_the_week, time time_of_day);RETURN FALSE
end function

public function string fu_getschedule (integer day_of_the_week, time time_of_day);RETURN ""
end function

public function time fu_getendofschedule (integer day_of_the_week, string schedule_name);RETURN Time("12:00:00")
end function

public function time fu_getbegofschedule (integer day_of_the_week, string schedule_name);RETURN Time("12:00:00")
end function

public function integer fu_verifyweek ();RETURN 0
end function

public function integer fu_sort (datawindow dw_name);RETURN 0
end function

public subroutine fu_setapplication (integer info_type, string info_value);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Subroutine    : fu_SetApplication
//  Description   : Sets application information.
//
//  Parameters    : INTEGER Info_Type -
//                     The type of application information to set.
//                  STRING Info_Value -
//                     The application information.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE info_type
	CASE c_APP_Name
		i_ApplicationName        = info_value
	CASE c_APP_Rev
		i_ApplicationRev         = info_value
	CASE c_APP_Bitmap
		i_ApplicationBitmap      = info_value
	CASE c_APP_INIFile
		i_ApplicationINI         = info_value
	CASE c_APP_Copyright
		i_ApplicationCopyright   = info_value
END CHOOSE

end subroutine

public function string fu_getapplication (integer info_type);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_GetApplication
//  Description   : Gets application information.
//
//  Parameters    : INTEGER Info_Type -
//                     The type of application information to get.
//
//  Return Value  : STRING -
//                     The value of the information that was 
//                     requested.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

CHOOSE CASE info_type
	CASE c_APP_Name
		RETURN i_ApplicationName
	CASE c_APP_Rev
		RETURN i_ApplicationRev
	CASE c_APP_Bitmap
		RETURN i_ApplicationBitmap
	CASE c_APP_INIFile
		RETURN i_ApplicationINI
	CASE c_APP_Copyright
		RETURN i_ApplicationCopyright
END CHOOSE

end function

public function integer fu_about ();RETURN 0
end function

public function integer fu_plaque ();RETURN 0
end function

public subroutine fu_setapplication (string app_name, string app_rev, string app_bitmap, string app_inifile, string app_copyright);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Subroutine    : fu_SetApplication
//  Description   : Sets application information.
//
//  Parameters    : STRING App_Name -
//                     Application name.
//                  STRING App_Rev -
//                     Application revision.
//                  STRING App_Bitmap -
//                     Application bitmap.
//                  STRING App_INIFile -
//                     Application INI file name.
//                  STRING App_Copyright -
//                     Application copyright message.
//
//  Return Value  : (None)
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

i_ApplicationName      = app_name
i_ApplicationRev       = app_rev
i_ApplicationBitmap    = app_bitmap
i_ApplicationINI       = app_inifile
i_ApplicationCopyright = app_copyright

end subroutine

public subroutine fu_setmicrohelp (string help_id);
end subroutine

public subroutine fu_microhelpposition ();
end subroutine

public subroutine fu_microhelpclose ();
end subroutine

public subroutine fu_setmicrohelp (string help_id, integer num_strings, string string_parms[]);
end subroutine

public function integer fu_createmanagers (string managers);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_CreateManagers
//  Description   : Create utility managers.
//
//  Parameters    : STRING Managers -
//                     Managers to be created.
//
//  Return Value  : INTEGER
//                      0 = managers created successfully
//                     -1 = manager creation failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

N_OBJCA_MGR l_Tmp
STRING      l_Object

//------------------------------------------------------------------
//  Check to see if the window utility manager was requested.
//------------------------------------------------------------------

IF Pos(Managers, c_UtilityManager) > 0 THEN
	l_Object = fu_GetDefault("Objects", "Utility")
	IF l_Object <> "" THEN
		l_Tmp = Create Using l_Object
		OBJCA.WIN = l_Tmp
	END IF
END IF
	
//---------------------------------------------------------------
//  Check to see if the timer utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_TimerManager) > 0 THEN
	l_Object = fu_GetDefault("Objects", "Timer")
	IF l_Object <> "" THEN
		l_Tmp = Create Using l_Object
		OBJCA.TIMER = l_Tmp
	END IF
END IF	

//---------------------------------------------------------------
//  Check to see if the field utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_FieldManager) > 0 THEN
	l_Object = fu_GetDefault("Objects", "Field")
	IF l_Object <> "" THEN
		l_Tmp = Create Using l_Object
		OBJCA.FIELD = l_Tmp
	END IF
END IF

//---------------------------------------------------------------
//  Check to see if the date utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_DateManager) > 0 THEN
	l_Object = fu_GetDefault("Objects", "Date")
	IF l_Object <> "" THEN
		l_Tmp = Create Using l_Object
		OBJCA.DATES = l_Tmp
	END IF
END IF

//---------------------------------------------------------------
//  Check to see if the log manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_LogManager) > 0 THEN
	l_Object = fu_GetDefault("Objects", "Log")
	IF l_Object <> "" THEN
		l_Tmp = Create Using l_Object
		OBJCA.LOG = l_Tmp
	END IF
END IF

RETURN 0
end function

public function integer fu_destroymanagers (string managers);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_DestroyManagers
//  Description   : Destroy utility managers.
//
//  Parameters    : STRING Managers -
//                     Managers to be destroyed.
//
//  Return Value  : INTEGER
//                      0 = managers destroyed successfully
//                     -1 = manager destruction failed
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Check to see if the log manager was requested.
//------------------------------------------------------------------

IF Pos(Managers, c_LogManager) > 0 THEN
	IF IsValid(OBJCA.LOG) THEN
	   IF OBJCA.LOG.i_CurrentLog <> "" THEN
		   OBJCA.LOG.fu_LogEnd(OBJCA.LOG.i_CurrentLog)
	   END IF
		Destroy(OBJCA.LOG)
	END IF
END IF

//------------------------------------------------------------------
//  Check to see if the window utility manager was requested.
//------------------------------------------------------------------

IF Pos(Managers, c_UtilityManager) > 0 THEN
	IF IsValid(OBJCA.WIN) THEN
		Destroy(OBJCA.WIN)
	END IF
END IF
	
//---------------------------------------------------------------
//  Check to see if the timer utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_TimerManager) > 0 THEN
	IF IsValid(OBJCA.TIMER) THEN
		Destroy(OBJCA.TIMER)
	END IF
END IF	

//---------------------------------------------------------------
//  Check to see if the field utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_FieldManager) > 0 THEN
	IF IsValid(OBJCA.FIELD) THEN
		Destroy(OBJCA.FIELD)
	END IF
END IF

//---------------------------------------------------------------
//  Check to see if the date utility manager was requested.
//---------------------------------------------------------------

IF Pos(Managers, c_DateManager) > 0 THEN
	IF IsValid(OBJCA.DATES) THEN
		Destroy(OBJCA.DATES)
	END IF
END IF

RETURN 0
end function

public function integer fu_selectcode (powerobject control_name, ref string codes[]);RETURN 0
end function

public function integer fu_getconnectinfo (string reg_key, ref transaction trans_object);RETURN 0
end function

public function integer fu_setlog (string string_parms[]);RETURN 0
end function

public function string fu_getdefault (string object_type, string default_type);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_GetDefault
//  Description   : Gets the default value for an object.
//
//  Parameters    : STRING Object_Type -
//                     Type of object (e.g. calendar).
//                  STRING Default_Type -
//                     The part of the object the default value
//                     applies to (e.g. text).
//
//  Return Value  : STRING -
//                     Returns default value in a string.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG   l_NumDefaults, l_Row
STRING l_Value

l_NumDefaults = RowCount()

l_Row = Find("object_type = '" + object_type + &
             "' AND default_type = '" + default_type + "'", &
				 1, l_NumDefaults)
IF l_Row > 0 THEN
	l_Value = GetItemString(l_Row, "value")
	IF IsNull(l_Value) <> FALSE THEN
		l_Value = ""
	END IF
ELSE
	l_Value = ""
END IF

RETURN l_Value
end function

public function integer fu_setdefault (string object_type, string default_type, string value);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_SetDefault
//  Description   : Sets the default value for an object.
//
//  Parameters    : STRING Object_Type -
//                     Type of object (e.g. calendar).
//                  STRING Default_Type -
//                     The part of the object the default value
//                     applies to (e.g. text).
//                  STRING Value -
//                     The default value to set.
//
//  Return Value  : INTEGER -
//                      0 - Default value set.
//                     -1 - Object, default, or parameter not found.
//
//  Change History: 
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

LONG l_NumDefaults, l_Row

l_NumDefaults = RowCount()

l_Row = Find("object_type = '" + object_type + &
             "' AND default_type = '" + default_type + "'", &
				 1, l_NumDefaults)
IF l_Row > 0 THEN
	SetItem(l_Row, "value", value)
	RETURN 0
ELSE
	RETURN -1
END IF
end function

public function integer fu_logwrite (string log_id, string log_strings[]);RETURN 0
end function

public function integer fu_logstart (string log_id);RETURN 0
end function

public function integer fu_logend (string log_id);RETURN 0
end function

public subroutine fu_traceon ();
end subroutine

public subroutine fu_traceoff ();
end subroutine

public subroutine fu_logoptions (string log_id, string file_name, string column_titles[], string options);
end subroutine

public subroutine fu_logoptions (string log_id, transaction trans_object, string column_titles[], string options);
end subroutine

public subroutine fu_drillresize (powerobject container_name, ref integer original_sizes[], ref integer index, boolean zoom, boolean got_sizes);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_DrillResize
//  Description   : Resize the controls within a user object and
//                  make a recursive call to drill through user
//                  objects and tab objects.
//
//  Parameters    : POWEROBJECT Container_Name  -
//                     Name of window or user object containing the
//                     controls to resize.
//                  REF INTEGER Original_Size   -
//                     An array containing the original X, Y, Width,
//                     and Height of the objects on the window or
//                     user object.  The developer passes an empty
//                     array.  The first two elements include the
//                     original Height and Width of the window or
//                     user object.
//                  REF INTEGER Index           -
//                     The last referenced index in the array of
//                     original sizes.
//                  BOOLEAN     Zoom            -
//                     Should the objects be resized by cropping
//                     (FALSE) or zooming (TRUE).
//                  BOOLEAN     Got_Sizes       -
//                     Whether or not the original sizes have been
//                     saved into the Original_Sizes[] array yet.
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

USEROBJECT      l_UserObject
DRAGOBJECT      l_ControlName
OBJECT          l_TypeOf
LINE            l_LineName
OVAL            l_OvalName
RECTANGLE       l_RectName
ROUNDRECTANGLE  l_RoundRectName
TAB             l_Tab
INTEGER         l_NewWidth, l_NewHeight, l_Idx, l_NumControls
INTEGER         l_OrigWidth, l_OrigHeight, l_X, l_Y, l_Width
INTEGER         l_X1, l_X2, l_Y1, l_Y2, l_Jdx, l_NumTabs, l_Height
INTEGER         l_TabSizes[], l_TabIndex
REAL            l_NewScaleX, l_NewScaleY, l_AspectRatio
REAL            l_NewScaleArea, l_TmpNewWidth, l_TmpNewHeight
STRING          l_POObject, l_Type

//------------------------------------------------------------------
//  Calculate the new width and height of the user object.
//------------------------------------------------------------------

l_UserObject = container_name
l_NewWidth   = l_UserObject.Width
l_NewHeight  = l_UserObject.Height

//------------------------------------------------------------------
//  Grab the original width and height of the user object.
//------------------------------------------------------------------

IF l_UserObject.GetParent().TypeOf() = Tab! THEN
   l_OrigWidth  = Abs(original_sizes[Index - 1])
   l_OrigHeight = Abs(original_sizes[Index])
ELSE
	l_OrigWidth = Abs(original_sizes[Index - 2])
	l_OrigHeight = Abs(original_sizes[Index - 1])
END IF

//------------------------------------------------------------
//  Calculate the ratio of the new size to the original size.
//------------------------------------------------------------

l_AspectRatio = l_OrigWidth / l_OrigHeight
l_NewScaleX   = l_NewWidth  / l_OrigWidth
l_NewScaleY   = l_NewHeight / l_OrigHeight

IF l_NewWidth/l_NewHeight <= l_AspectRatio THEN
   l_TmpNewWidth  = l_NewWidth
   l_TmpNewHeight = l_NewWidth / l_AspectRatio
ELSE
   l_TmpNewHeight = l_NewHeight
   l_TmpNewWidth  = l_NewHeight * l_AspectRatio
END IF

l_NewScaleArea = SQRT ((l_TmpNewWidth * l_TmpNewHeight) / &
                       (l_OrigWidth * l_OrigHeight))

IF zoom THEN
	l_NewScaleX = l_NewScaleArea
	l_NewScaleY = l_NewScaleArea
END IF
	
//------------------------------------------------------------
//  Fix the size of the controls
//------------------------------------------------------------

l_NumControls = UpperBound(l_UserObject.Control[])

FOR l_Idx = 1 TO l_NumControls
   l_TypeOf      = l_UserObject.Control[l_Idx].TypeOf()
	CHOOSE CASE l_TypeOf
		CASE Line!
			l_Type = "LINE"
			l_LineName = l_UserObject.Control[l_Idx]
		CASE Oval!
			l_Type = "OVAL"
			l_OvalName = l_UserObject.Control[l_Idx]
		CASE Rectangle!
			l_Type = "RECTANGLE"
			l_RectName = l_UserObject.Control[l_Idx]
		CASE RoundRectangle!
			l_Type = "ROUNDRECTANGLE"
			l_RoundRectName = l_UserObject.Control[l_Idx]
		CASE ELSE
			l_Type = "DRAGOBJECT"
			l_ControlName = l_UserObject.Control[l_Idx]
	END CHOOSE

   IF NOT Got_Sizes THEN
		CHOOSE CASE l_Type
			CASE "LINE"
            Index = Index + 1
            original_sizes[Index] = l_LineName.BeginX
            l_X1 = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_LineName.BeginY
            l_Y1 = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_LineName.EndX
            l_X2 = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_LineName.EndY
            l_Y2 = original_sizes[Index]
			CASE "OVAL"
            Index = Index + 1
            original_sizes[Index] = l_OvalName.X
            l_X = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_OvalName.Y
            l_Y = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_OvalName.Width
            l_Width = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_OvalName.Height
            l_Height = original_sizes[Index]
			CASE "RECTANGLE"
            Index = Index + 1
            original_sizes[Index] = l_RectName.X
            l_X = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_RectName.Y
            l_Y = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_RectName.Width
            l_Width = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_RectName.Height
            l_Height = original_sizes[Index]
			CASE "ROUNDRECTANGLE"
            Index = Index + 1
            original_sizes[Index] = l_RoundRectName.X
            l_X = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_RoundRectName.Y
            l_Y = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_RoundRectName.Width
            l_Width = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_RoundRectName.Height
            l_Height = original_sizes[Index]
			CASE "DRAGOBJECT"
            Index = Index + 1
            original_sizes[Index] = l_ControlName.X
            l_X = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_ControlName.Y
            l_Y = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_ControlName.Width
            l_Width = original_sizes[Index]
            Index = Index + 1
            original_sizes[Index] = l_ControlName.Height
            l_Height = original_sizes[Index]
		END CHOOSE
   ELSE
		IF l_Type = "LINE" THEN
         Index = Index + 1
         l_X1 = original_sizes[Index]
         Index = Index + 1
         l_Y1 = original_sizes[Index]
         Index = Index + 1
         l_X2 = original_sizes[Index]
         Index = Index + 1
         l_Y2 = original_sizes[Index]
		ELSE
         Index = Index + 1
         l_X = original_sizes[Index]
         Index = Index + 1
         l_Y = original_sizes[Index]
         Index = Index + 1
         l_Width = original_sizes[Index]
         Index = Index + 1
         l_Height = original_sizes[Index]
		END IF
   END IF

   Index = Index + 1

   IF l_ControlName.TriggerEvent("po_identify") = 1 THEN
		l_POObject = l_ControlName.DYNAMIC fu_GetIdentity()
	ELSE
      l_POObject = ""
	END IF

	IF zoom THEN
		IF l_Type = "DRAGOBJECT" AND l_POObject <> "Folder" AND &
			l_POObject <> "Calendar" THEN
			fu_ZoomControls(l_ControlName, original_sizes[], &
                         Index, l_NewScaleArea, got_sizes)
		END IF
	END IF

   IF l_POObject <> "Container" THEN
		CHOOSE CASE l_Type
			CASE "LINE"
		      l_LineName.BeginX = l_NewScaleX * l_X1
            l_LineName.BeginY = l_NewScaleY * l_Y1
            l_LineName.EndX   = l_NewScaleX * l_X2
            l_LineName.EndY   = l_NewScaleY * l_Y2
			CASE "OVAL"
     	      l_OvalName.Move(l_NewScaleX * l_X, &
                            l_NewScaleY * l_Y)
    	      l_OvalName.Resize(l_NewScaleX * l_Width, &
                              l_NewScaleY * l_Height)
			CASE "RECTANGLE"
     	      l_RectName.Move(l_NewScaleX * l_X, &
                            l_NewScaleY * l_Y)
    	      l_RectName.Resize(l_NewScaleX * l_Width, &
                              l_NewScaleY * l_Height)
			CASE "ROUNDRECTANGLE"
     	      l_RoundRectName.Move(l_NewScaleX * l_X, &
                                 l_NewScaleY * l_Y)
     	      l_RoundRectName.Resize(l_NewScaleX * l_Width, &
                                   l_NewScaleY * l_Height)
			CASE "DRAGOBJECT"
				IF l_ControlName.TypeOf() = Tab! THEN
					l_Tab = l_ControlName
					l_NumTabs = UpperBound(l_Tab.Control[])
					IF NOT Got_Sizes THEN
						l_TabIndex = 0
						FOR l_Jdx = 1 TO l_NumTabs
							l_TabIndex++
							l_TabSizes[l_TabIndex] = l_Tab.Control[l_Jdx].Width
							l_TabIndex++
							l_TabSizes[l_TabIndex] = l_Tab.Control[l_Jdx].Height
						NEXT
					END IF
				END IF
				
     	      l_ControlName.Move(l_NewScaleX * l_X, &
                               l_NewScaleY * l_Y)
     	      l_ControlName.Resize(l_NewScaleX * l_Width, &
                                 l_NewScaleY * l_Height)
		END CHOOSE
	END IF
   	
   //---------------------------------------------------------------
   //  If the control is a user object or tab object, drill the 
   //  resize operation down to the next level.
   //---------------------------------------------------------------
	
	IF l_Type = "DRAGOBJECT" THEN
		CHOOSE CASE l_ControlName.TypeOf()
			CASE UserObject!
				IF l_POObject <> "Container" THEN
				   fu_DrillResize(l_ControlName, Original_Sizes[], &
				                  Index, Zoom, Got_Sizes)
				END IF
			CASE Tab!
				l_TabIndex = 0
				FOR l_Jdx = 1 TO l_NumTabs
					IF NOT Got_Sizes THEN
						Index = Index + 1
						l_TabIndex++
						Original_Sizes[Index] = l_TabSizes[l_TabIndex]
						Index = Index + 1
						l_TabIndex++
						Original_Sizes[Index] = l_TabSizes[l_TabIndex]
					ELSE
						Index = Index + 2
					END IF
					fu_DrillResize(l_Tab.Control[l_Jdx], &
					               Original_Sizes[], Index, &
										Zoom, Got_Sizes)
				NEXT
		END CHOOSE
	END IF
NEXT

RETURN
end subroutine

public subroutine fu_zoomcontrols (dragobject control_name, ref integer original_sizes[], integer index, real scale_area, boolean got_sizes);//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Function      : fu_ZoomControls
//  Description   : Resize the text size of the control.
//
//  Parameters    : DRAGOBJECT Control_Name  -
//                     Name of the control to zoom.
//                  INTEGER    Original_Size -
//                     An array containing the original X, Y, Width,
//                     and Height of the objects on the window or
//                     user object.
//                  INTEGER    Index         -
//                     The current referenced index in the array of
//                     original sizes.
//                  REAL       Scale_Area    -
//                     Resize ratio.
//                  BOOLEAN    Got_Sizes     -
//                     Whether or not the original sizes have been
//                     saved into the Original_Sizes[] array yet.
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

DATAWINDOW      l_DW
CHECKBOX        l_CheckBox
COMMANDBUTTON   l_CommandButton
DROPDOWNLISTBOX l_DropDownListBox
DROPDOWNPICTURELISTBOX l_DropDownPictureListBox
EDITMASK        l_EditMask
GROUPBOX        l_GroupBox
LISTBOX         l_ListBox
PICTURELISTBOX  l_PictureListBox
MULTILINEEDIT   l_MultiLineEdit
PICTUREBUTTON   l_PictureButton
RADIOBUTTON     l_RadioButton
SINGLELINEEDIT  l_SingleLineEdit
STATICTEXT      l_StaticText
LISTVIEW        l_ListView
TREEVIEW        l_TreeView
TAB             l_Tab
INTEGER         l_Zoom

CHOOSE CASE control_name.TypeOf()
   CASE CheckBox!
      l_CheckBox = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_CheckBox.TextSize
      END IF
      l_CheckBox.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE CommandButton!
      l_CommandButton = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_CommandButton.TextSize
		END IF
      l_CommandButton.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE DataWindow!
	   l_DW = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = INTEGER(l_DW.Describe("datawindow.zoom"))
		END IF
      l_Zoom = Ceiling(scale_area * original_sizes[index])
      l_DW.Modify("datawindow.zoom=" + String(l_Zoom))
   CASE DropDownListBox!
      l_DropDownListBox = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_DropDownListBox.TextSize
		END IF
      l_DropDownListBox.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE DropDownPictureListBox!
      l_DropDownPictureListBox = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_DropDownPictureListBox.TextSize
		END IF
      l_DropDownPictureListBox.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE EditMask!
      l_EditMask = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_EditMask.TextSize
		END IF
      l_EditMask.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE GroupBox!
      l_GroupBox = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_GroupBox.TextSize
		END IF
      l_GroupBox.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE ListBox!
      l_ListBox = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_ListBox.TextSize
		END IF
      l_ListBox.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE PictureListBox!
      l_PictureListBox = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_PictureListBox.TextSize
		END IF
      l_PictureListBox.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE MultiLineEdit!
      l_MultiLineEdit = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_MultiLineEdit.TextSize
		END IF
      l_MultiLineEdit.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE PictureButton!
      l_PictureButton = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_PictureButton.TextSize
		END IF
      l_PictureButton.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE RadioButton!
      l_RadioButton = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_RadioButton.TextSize
		END IF
      l_RadioButton.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE SingleLineEdit!
      l_SingleLineEdit = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_SingleLineEdit.TextSize
		END IF
      l_SingleLineEdit.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE StaticText!
      l_StaticText = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_StaticText.TextSize
		END IF
      l_StaticText.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE ListView!
      l_ListView = control_name
 	   IF NOT got_sizes THEN
         original_sizes[index] = l_ListView.TextSize
		END IF
      l_ListView.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE TreeView!
      l_TreeView = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_TreeView.TextSize
		END IF
      l_TreeView.TextSize = Ceiling(original_sizes[index] * scale_area)
   CASE Tab!
      l_Tab = control_name
      IF NOT got_sizes THEN
         original_sizes[index] = l_Tab.TextSize
		END IF
      l_Tab.TextSize = Ceiling(original_sizes[index] * scale_area)
END CHOOSE

RETURN
end subroutine

public function integer fu_validatezip (ref string value, boolean display_error);RETURN 0
end function

public function integer fu_validatefmt (ref string value, string pattern, boolean display_error);RETURN 0
end function

public function integer fu_validatephone (ref string value, boolean display_error);RETURN 0
end function

public function integer fu_filesaveas (datastore datastore, ref string directory);RETURN 0
end function

on n_objca_mgr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_objca_mgr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//******************************************************************
//  PO Module     : n_OBJCA_MGR
//  Event         : Constructor
//  Description   : Initializes the PowerObjects environment.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1995.  All Rights Reserved.
//******************************************************************

//------------------------------------------------------------------
//  Get the PowerBuilder environment.
//------------------------------------------------------------------

IF i_Env.pbmajorrevision = 0 THEN
	GetEnvironment(i_Env)

   //---------------------------------------------------------------
   //  Set operating system dependent variables.
   //---------------------------------------------------------------

	CHOOSE CASE i_Env.OSType

    	CASE AIX!, HPUX!, OSF1!, SOL2!
   	   i_DirDelim   = "/"
			i_ODBCFile   = "odbc.ini"
			i_SystemFile = "pb.ini"

   	CASE Macintosh!
      	i_DirDelim   = ":"
			i_ODBCFile   = "ODBC Preferences"
			i_SystemFile = "pb.ini"
		
  		CASE ELSE
      	i_DirDelim   = "\"
			i_ODBCFile   = "odbc.ini"
			i_SystemFile = "pb.ini"
	
END CHOOSE

	SetNull(i_Parm.PowerObject_Parm)
	SetNull(i_Parm.String_Parm)
	SetNull(i_Parm.Double_Parm)

END IF
end event

