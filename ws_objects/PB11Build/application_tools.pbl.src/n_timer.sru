$PBExportHeader$n_timer.sru
$PBExportComments$<doc>Non-Visual Timer Object.  Allows you to have non-visual objects that execute code based on time.
forward
global type n_timer from timing
end type
end forward

global type n_timer from timing
event ue_notify ( string as_message,  string as_arg )
end type
global n_timer n_timer

type variables
Private:
powerobject ipo_object
string is_event
double idbl_timerincrement //48797
end variables

forward prototypes
public subroutine of_stop ()
public subroutine of_start (double id_interval)
public subroutine of_set_event (powerobject apo_object, string as_event)
end prototypes

event ue_notify(string as_message, string as_arg);//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   responds to menu selection to disable timers for debugging purposes  RAID 48797
//	Created by: Cathy Barnes (Jake Pratt)
//	History:    5/14/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

choose case lower(as_arg)
	case 'on'
		this.start(idbl_timerincrement)
	case 'off'
		this.stop()
end choose
end event

public subroutine of_stop ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Stop the timer.</Description>
<Arguments>
	<Argument Name="Argument1">Description</Argument>
	<Argument Name="Argument1">Description</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
this.Stop()
end subroutine

public subroutine of_start (double id_interval);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Start a timer with the specified interval.</Description>
<Arguments>
	<Argument Name="id_interval">Interval to trigger timer on in milliseconds.</Argument>
	<Argument Name="Argument1">Description</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
this.Start(id_interval)
idbl_timerincrement = id_interval	//48797
end subroutine

public subroutine of_set_event (powerobject apo_object, string as_event);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This fuction specifies the object and event to call when the timer occurs.  You should call this before calling start().</Description>
<Arguments>
	<Argument Name="apo_object">Object to trigger event on when the timer elapses</Argument>
	<Argument Name="as_event">Event to trigger when the timer elapses.</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_event
// Arguments:   apo_object - the object to call when the timer is fired
//					is_event - the event to trigger when the timer is fired
// Overview:    This sets the object and event that should be called when the timer is fired.
// Created by:  Scott Creed
// History:     6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

ipo_object = apo_object
is_event = as_event
end subroutine

on n_timer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_timer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event timer;ipo_object.triggerevent(is_event)
end event

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
Non-Visual Timer Object.  Allows you to have non-visual objects that execute code based on time.
</Abstract>----------------------------------------------------------------------------------------------------*/
gn_globals.in_subscription_service.of_subscribe(this,'timerdebug')	//48797
end event

