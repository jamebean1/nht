$PBExportHeader$n_daomessage.sru
forward
global type n_daomessage from nonvisualobject
end type
end forward

global type n_daomessage from nonvisualobject
event ue_notify_client ( string s_message,  string arg )
end type
global n_daomessage n_daomessage

type variables
powerobject io_client[]
n_dao in_dao
end variables

forward prototypes
public subroutine of_resetclientobject (powerobject ao_powerobject)
public subroutine of_setclientobject (powerobject ao_powerobject)
end prototypes

event ue_notify_client;//----------------------------------------------------------------------------------------------------------------------------------
// Function:    ue_notify_client()
// Overview:    trigger this event to notify the client of a event
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_count

for ll_count = 1 to upperbound(io_client)
	if isvalid(io_client[ll_count]) then
		io_client[ll_count].Event dynamic ue_notify(lower(s_message),arg)
	end if
Next
end event

public subroutine of_resetclientobject (powerobject ao_powerobject);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_setclientobject()
// Overview:    Set a reference to the client object
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_max
long i_i

for i_i = 1 to upperbound(io_client) 
	if io_client [i_i] = ao_powerobject then 
		setnull(io_client[i_i])
	end if
next


end subroutine

public subroutine of_setclientobject (powerobject ao_powerobject);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_setclientobject()
// Overview:    Set a reference to the client object
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_max
long i_i

// make sure we don't already have this object
for i_i = 1 to upperbound(io_client) 
	if io_client [i_i] = ao_powerobject then return
next

// look for a whole first since there is probably one available
for i_i = 1 to upperbound(io_client) 
	if isnull(io_client [i_i]) then
		io_client[i_i] = ao_powerobject		
		return
	end if
		
next

// No holes so let's extend the array.
ll_max = upperbound(io_client)
ll_max++

io_client[ll_max] = ao_powerobject
end subroutine

on n_daomessage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_daomessage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

