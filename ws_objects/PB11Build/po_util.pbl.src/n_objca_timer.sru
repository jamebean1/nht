$PBExportHeader$n_objca_timer.sru
$PBExportComments$Timer utilities data store
forward
global type n_objca_timer from n_objca_mgr
end type
end forward

global type n_objca_timer from n_objca_mgr
string DataObject="d_objca_timer_main"
end type
global n_objca_timer n_objca_timer

type variables
//----------------------------------------------------------------------------------------
//  Timer Constants
//----------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------
//  Timer Instance Variables
//----------------------------------------------------------------------------------------


end variables

forward prototypes
public subroutine fu_timeron ()
public subroutine fu_timermark (string label)
public subroutine fu_timeroff (string label)
public function decimal fu_timerelapsed (time start_time, time end_time)
public function integer fu_timer (string timer_title)
public subroutine fu_timercalc (datawindow dw_seq_name, datawindow dw_call_name)
end prototypes

public subroutine fu_timeron ();//******************************************************************
//  PO Module     : n_OBJCA_TIMER
//  Function      : fu_TimerOn
//  Description   : Turns the timing operation on.
//
//  Parameters    : (None)
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

Reset()
i_TimerOn = TRUE
fu_TimerMark("Start Timing")
end subroutine

public subroutine fu_timermark (string label);//******************************************************************
//  PO Module     : n_OBJCA_TIMER
//  Function      : fu_TimerMark
//  Description   : Marks a spot in the code with a time.
//
//  Parameters    : STRING  Label -
//                     A label associated with the marked time.
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

LONG l_Rows

IF i_TimerOn THEN
   InsertRow(0)
	l_Rows = RowCount()
	SetItem(l_Rows, "label", label)
   SetItem(l_Rows, "time", Now())
END IF
end subroutine

public subroutine fu_timeroff (string label);//******************************************************************
//  PO Module     : n_OBJCA_TIMER
//  Function      : fu_TimerOff
//  Description   : Marks a spot in the code with a time.
//
//  Parameters    : STRING  Label -
//                     A label associated with the last marked time.
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

IF i_TimerOn THEN
   fu_TimerMark(label)
	
	DO WHILE Yield()
	LOOP

	fu_TimerMark("Posted Processing")
	
	i_TimerOn = FALSE
END IF
end subroutine

public function decimal fu_timerelapsed (time start_time, time end_time);//******************************************************************
//  PO Module     : n_OBJCA_TIMER
//  Function      : fu_TimerElapsed
//  Description   : Calculates the elapsed time.
//
//  Parameters    : TIME Start_Time  -
//                     The starting time.
//                  TIME Ending_Time -
//                     The ending time.
//
//  Return Value  : DECIMAL
//                     The elapsed time between the parameters.
//
//  Change History:
//
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1994-1996.  All Rights Reserved.
//******************************************************************

DECIMAL  l_TotalTime
INTEGER  l_IStart_ff, l_IEnd_ff, l_ff
LONG     l_Seconds
STRING   l_StartTime, l_LendTime, l_SStart_ff, l_SEnd_ff

l_Seconds   = SecondsAfter(start_time, end_time)

l_StartTime = String(start_time, "hh:mm:ss:ff")
l_SStart_ff = Right(l_StartTime, 2)
l_IStart_ff = Integer(l_SStart_ff)

l_LendTime  = String(end_time, "hh:mm:ss:ff")
l_SEnd_ff   = Right(l_LendTime, 2)
l_IEnd_ff   = Integer(l_SEnd_ff)

IF l_IStart_ff > l_IEnd_ff THEN
    l_Seconds = l_Seconds - 1
    l_ff = (100 - l_IStart_ff) + l_IEnd_ff
ELSE
    l_ff = l_IEnd_ff - l_IStart_ff
END IF

l_TotalTime = l_Seconds + (l_ff /100)

RETURN l_TotalTime
end function

public function integer fu_timer (string timer_title);//******************************************************************
//  PO Module     : n_OBJCA_TIMER
//  Function      : fu_Timer
//  Description   : Display the TIMER window.
//
//  Parameters    : STRING Timer_Title -
//                     Title for the timer window.
//
//  Return Value  : INTEGER
//                      0 = window open OK
//                     -1 = window open failed
//
//  Change History:  
//    
//  Date     Person     Description of Change
//  -------- ---------- --------------------------------------------
//
//******************************************************************
//  Copyright ServerLogic 1992-1996.  All Rights Reserved.
//******************************************************************

STRING  l_Object
INTEGER l_Return
WINDOW  l_Window

//------------------------------------------------------------------
//  Open the timer response window.
//------------------------------------------------------------------

l_Object = OBJCA.MGR.fu_GetDefault("Objects", "TimerDisplay")
IF l_Object <> "" THEN
	l_Return = OpenWithParm(l_Window, timer_title, l_Object)
	IF l_Return <> -1 THEN
   	l_Return = 0
	END IF
ELSE
	l_Return = -1
END IF

RETURN l_Return
end function

public subroutine fu_timercalc (datawindow dw_seq_name, datawindow dw_call_name);//******************************************************************
//  PO Module     : n_OBJCA_TIMER
//  Function      : fu_TimerCalc
//  Description   : Calculates the timings and puts the values
//                  into the given DataWindows.
//
//  Parameters    : DATAWINDOW DW_Seq_Name -
//                     Name of the timing sequence DataWindow.
//                  DATAWINDOW DW_Call_Name - 
//                     Name of the timing call DataWindow.
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

INTEGER     l_RowCnt,     l_Idx,   l_NumTimes
DECIMAL{2}  l_SubElapsed, l_TotElapsed, l_Total, l_Percent, l_Sum
STRING      l_Label
TIME        l_FirstT,     l_SecondT
LONG        l_Row

l_NumTimes = RowCount()

//------------------------------------------------------------------
//  Loop through the timer values and calculate the intervals and
//  sub-intervals.  Then load the datawindows with the timings.
//------------------------------------------------------------------

IF l_NumTimes > 0 THEN
   l_Total  = fu_TimerElapsed(GetItemTime(1, "time"), &
                              GetItemTime(l_NumTimes, "time"))
   l_RowCnt = 0
   l_Sum    = 0

   l_Idx = 2
   DO WHILE l_Idx <= l_NumTimes

      l_Label = GetItemString(l_Idx, "label")
		
		IF Len(l_Label) > 0 THEN
         l_TotElapsed = 0

         l_FirstT     = GetItemTime(l_Idx - 1, "time")
         l_SecondT    = GetItemTime(l_Idx, "time")
         l_SubElapsed = fu_TimerElapsed(l_FirstT, l_SecondT)
         l_TotElapsed = l_TotElapsed + l_SubElapsed
         l_Sum        = l_Sum        + l_SubElapsed              

         dw_seq_name.InsertRow(0)
         dw_call_name.InsertRow(0)

         l_RowCnt = l_RowCnt + 1
         IF l_Total > 0 THEN
            l_Percent = 100.0 * l_TotElapsed / l_Total
         ELSE
            l_Percent = 0.0
         END IF

         dw_seq_name.SetItem(l_RowCnt, "process", " " + l_Label)
         dw_seq_name.SetItem(l_RowCnt, "elapsed", l_TotElapsed)
         dw_seq_name.SetItem(l_RowCnt, "percent", l_Percent)
         dw_seq_name.SetItem(l_RowCnt, "total", l_Sum)

         dw_call_name.SetItem(l_RowCnt, "process", " " + l_Label)
         dw_call_name.SetItem(l_RowCnt, "elapsed", l_TotElapsed)      
      END IF

      l_Idx = l_Idx + 1
   LOOP
	
	l_Row = Find("label = 'Start Timing'", 1, l_NumTimes)
	IF l_Row > 0 THEN
		DeleteRow(l_Row)
	END IF

END IF

RETURN
end subroutine

on n_objca_timer.create
call datastore::create
TriggerEvent( this, "constructor" )
end on

on n_objca_timer.destroy
call datastore::destroy
TriggerEvent( this, "destructor" )
end on

