$PBExportHeader$n_subscription_service.sru
$PBExportComments$This is the subscription service.  This object publishes synchronous and asynchronous (RAMQ) messages and also triggers subscriptions.
forward
global type n_subscription_service from nonvisualobject
end type
type str_subscription from structure within n_subscription_service
end type
end forward

type str_subscription from structure
	powerobject		in_object
	string		in_message
	powerobject		il_object
	boolean		ib_singleobject
end type

global type n_subscription_service from nonvisualobject
end type
global n_subscription_service n_subscription_service

type variables
Private:
str_subscription istr_subscription[]
long ll_array_bound
//datastore  in_subscription
String is_DDE_ServerName = 'RightAngleConfig'

n_date_manipulator	in_date_manipulator
n_notification_service in_notification_service
end variables

forward prototypes
public subroutine of_message_dde (string as_message, string as_arg)
public subroutine of_subscribe (powerobject ao_object, string as_message)
public subroutine of_subscribe (powerobject ao_object, string as_message, powerobject as_publisherid)
public subroutine of_set_ddeserver (string as_servername)
public subroutine of_message (string as_message, any as_arg)
public function boolean of_message_asynch (string as_message, string as_argument)
public subroutine of_collect_garbage ()
public function boolean of_message_asynch (string as_message, string as_argument, datetime adt_next_run_date)
public function boolean of_message_asynch (string as_message, string as_argument, datetime adt_next_run_date, string as_hostcomputer, boolean ab_gnglobalsisvalid, ref transaction axctn_transaction)
public function boolean of_message_asynch (string as_message, string as_argument, datetime adt_next_run_date, long al_batchid)
public function boolean of_message_asynch (string as_message, string as_argument, long al_batchid)
public subroutine of_message (string as_message, any as_arg, powerobject al_publisherid)
protected subroutine of_post_data_subscription_message (string as_message, string as_argument)
public function string of_commit_batch (long al_batchid)
public function long of_get_batchid ()
end prototypes

public subroutine of_message_dde (string as_message, string as_arg);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_message_dde()
// Arguments:   as_message - This is the message to send
//					 as_arg	-	  This is the argument to send
// Overview:    DocumentScriptFunctionality
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//Send a remote message to the DDE server
ExecRemote(as_message + '@@@' + String(as_arg), is_DDE_ServerName, "Messages")

end subroutine

public subroutine of_subscribe (powerobject ao_object, string as_message);powerobject ll_object

setnull(ll_object)
ll_array_bound++

//----------------------------------------------------------------------------------------------------------------------------------
// Save this subscription into the array of subscriptions
//-----------------------------------------------------------------------------------------------------------------------------------
istr_subscription[ll_array_bound].in_object = ao_object
istr_subscription[ll_array_bound].in_message = as_message
istr_subscription[ll_array_bound].il_object = ll_object
istr_subscription[ll_array_bound].ib_singleobject = false
end subroutine

public subroutine of_subscribe (powerobject ao_object, string as_message, powerobject as_publisherid);
ll_array_bound++

istr_subscription[ll_array_bound].in_object = ao_object
istr_subscription[ll_array_bound].in_message = as_message
istr_subscription[ll_array_bound].il_object = as_publisherid
istr_subscription[ll_array_bound].ib_singleobject = true
end subroutine

public subroutine of_set_ddeserver (string as_servername);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_ddeserver()
// Arguments:   as_servername - This is the name of the dde server to publish the message to
// Overview:    This is the name of the dde server to publish the message to
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_dde_servername = as_servername
end subroutine

public subroutine of_message (string as_message, any as_arg);
//----------------------------------------------------------------------------------------------------------------------------------
// This function simply creates a null and calls the overloaded of_message with the additional arguement.
//-----------------------------------------------------------------------------------------------------------------------------------
powerobject ll_null

setnull(ll_null)
of_message(as_message,as_arg,ll_null)
end subroutine

public function boolean of_message_asynch (string as_message, string as_argument);
datetime					ldt_rundatetime

ldt_rundatetime = in_date_manipulator.of_now()

return of_message_asynch( as_message, as_argument, ldt_rundatetime)

////----------------------------------------------------------------------------------------------------------------------------------
//// Function:  of_publish()
//// Arguments:   as_message - The message to publish
////						as_argument - The arguments for the message (typically of the form column=value,column=value...)
//// Overview:    This function will schedule all of the processes that subscribe 
////						to the message as_message as defined in the subscription table.
////					
//// Created by:  Scott Creed
//// History:     5/13/99 - First Created 
////-----------------------------------------------------------------------------------------------------------------------------------
//
//long	l_mssgeid
//long	l_prcssgrpid
//long	l_subscriptions
//long	l_i
//long	l_id
//string	s_prcssqnme
//datetime dt_now
//
//n_update_tools	ln_tools
//n_date_manipulator ln_date_manipulator
//
//string	ls_columnname
//
////----------------------------------------------------------------------------------------------------------------------------------
//// Get the id for the message to publish
////-----------------------------------------------------------------------------------------------------------------------------------
//
//ls_columnname = in_subscription.describe( "#1.name")
//in_subscription.setfilter( "lower(" + ls_columnname + ") = '" + lower( as_message) + "'")
//in_subscription.filter()
//
//l_subscriptions = in_subscription.rowcount()
//
//if l_subscriptions < 1 then
//	return TRUE
//end if
//
//ln_tools = create n_update_tools
//dt_now = ln_date_manipulator.of_now()
////----------------------------------------------------------------------------------------------------------------------------------
//// Now loop through all the subscriptions for the message and schedule them
////-----------------------------------------------------------------------------------------------------------------------------------
//
//ln_tools.of_begin_transaction()
//	
//for l_i = 1 to l_subscriptions
//	//l_prcssgrpid = in_subscription.getitemnumber( l_i, "cprcssgrpid")
//	//s_prcssqnme = in_subscription.getitemstring( l_i, "cprcssqnme")
//	l_prcssgrpid = in_subscription.getitemnumber( l_i, 2)
//	s_prcssqnme = in_subscription.getitemstring( l_i, 3)
//
//	l_id = ln_tools.of_get_key('processschedulerii')
//	
//	insert into processschedulerII
//	values	(:l_id,
//				:l_prcssgrpid,
//				:dt_now,
//				'A',
//				'N',
//				'Primary',
//				:s_prcssqnme);
//	
//	if sqlca.sqlcode <> 0 then
//		ln_tools.of_rollback_transaction()
//		destroy ln_tools
//		return FALSE
//	end if
//	
//	insert into processparameter
//	select 	:l_id,
//				prcssgrprltnid,
//				:as_message + ":" + :as_argument
//	from	processgrouprelation
//	where	prcssgrprltnprcssgrpid = :l_prcssgrpid;
//		
//	if sqlca.sqlcode <> 0 then
//		ln_tools.of_rollback_transaction()
//		destroy ln_tools
//		return FALSE
//	end if
//	
//next
//
//ln_tools.of_commit_transaction()
//	
//destroy n_update_tools
//
//return TRUE
end function

public subroutine of_collect_garbage ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_collect_garbage
// Arguments:   None
// Overview:    This function will shrink the subscription array to remove subscriptions where
//						either the publisher 
// Created by:  Scott Creed
// History:     7.1.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
 
str_subscription lstr_subscription[]
long	ll_max
long	ll_i, ll_j

ll_max = upperbound( istr_subscription)

for ll_i = 1 to ll_max
	if isvalid( istr_subscription[ll_i].in_object) and isvalid( istr_subscription[ll_i].il_object) then
		ll_j++
		lstr_subscription[ll_j] = istr_subscription[ll_i]
	end if
	yield()
	if upperbound( istr_subscription) <> ll_max then
		return
	end if
next

istr_subscription = lstr_subscription
ll_array_bound = ll_j

return
end subroutine

public function boolean of_message_asynch (string as_message, string as_argument, datetime adt_next_run_date);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_Message_Asynch
//	Arguments:  as_message 			- The message being published
//					as_argument 		- The argument for the message being published
//					adt_next_run_date - The date/time that this message is requesting that the response be scheduled
//	Overview:   This function publishes messages that will be processed by a RAMQ processor.  All messages sent to this
//					function will be inserted into the PublishedMessage table.  RAMQ itself is responsible for scheduling
//					responses based on the subscriptions in the Subscription table.
//	Created by:	Scott Creed
//	History: 	07.12.2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string					ls_hstcmptr

ls_hstcmptr = gn_globals.is_login + " - " + string(gn_globals.il_spid)

//insert into publishedmessage
//	(	message,
//		argument,
//		publisheddate,
//		status,
//		scheduledresponsedate,
//		hstCmptr
//	)
//values 
//	( 		:as_message,
//			:as_argument,
//			Current_TimeStamp,
//			'N',
//			:adt_next_run_date,
//			:ls_hstcmptr
//	);
	
if sqlca.sqlcode = - 1 then
	return FALSE
end if

if not isvalid(in_notification_service) then 
	in_notification_service = create n_notification_service
end if
in_notification_service.of_notify_message(as_message,as_argument)

//-----------------------------------------------------------------------------------------------------------------------------------
// #48688 
// 5/12/2004 - Pat Newgent
// Unneccessary code which causes the client machine to wait while RAMQ is intantiated
// and polls for processes.  This often yields to the client machine being blocked
// for extended periods of time.
//-----------------------------------------------------------------------------------------------------------------------------------
//if isvalid( gn_globals) then
//	gn_globals.in_subscription_service.post of_message( 'Poll Publishing RAMQ', '')
//end if

//-----------------------------------------------------------------------------------------------------------------------------------
// 12/1/2003 - ERW - forward the message to local subscriptions
//-----------------------------------------------------------------------------------------------------------------------------------
of_post_data_subscription_message(as_message, as_argument)



return TRUE


end function

public function boolean of_message_asynch (string as_message, string as_argument, datetime adt_next_run_date, string as_hostcomputer, boolean ab_gnglobalsisvalid, ref transaction axctn_transaction);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_Message_Asynch
//	Arguments:  as_message 			- The message being published
//					as_argument 		- The argument for the message being published
//					adt_next_run_date - The date/time that this message is requesting that the response be scheduled
//					as_hostcomputer	- The name of the host computer to publish under
//					ab_gnglobalsisvalid - Whether or not gn_globals is valid.  If you are multi-threading, it won't be.
//					axctn_transaction	- The transaction object to use for the insert.
//	Overview:   This function publishes messages that will be processed by a RAMQ processor.  All messages sent to this
//					function will be inserted into the PublishedMessage table.  RAMQ itself is responsible for scheduling
//					responses based on the subscriptions in the Subscription table.
//	Created by:	Denton Newham
//	History: 	11.03.2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not IsValid(axctn_transaction) Then Return False

Insert Into publishedmessage
	(	message,
		argument,
		publisheddate,
		status,
		scheduledresponsedate,
		hstCmptr
	)
Values 
	( 		:as_message,
			:as_argument,
			Current_TimeStamp,
			'N',
			:adt_next_run_date,
			:as_hostcomputer
	)
Using axctn_transaction;
	
If axctn_transaction.sqlcode = - 1 Then Return False

If ab_gnglobalsisvalid Then
	if not isvalid(in_notification_service) then 
		in_notification_service = create n_notification_service
	end if
	in_notification_service.of_notify_message(as_message,as_argument)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// #48688 
	// 5/12/2004 - Pat Newgent
	// Unneccessary code which causes the client machine to wait while RAMQ is intantiated
	// and polls for processes.  This often yields to the client machine being blocked
	// for extended periods of time.
	//-----------------------------------------------------------------------------------------------------------------------------------
	//	If IsValid(gn_globals.in_subscription_service) Then
	//		gn_globals.in_subscription_service.Post of_message( 'Poll Publishing RAMQ', '')		
	//	End If
End If


//-----------------------------------------------------------------------------------------------------------------------------------
// 12/1/2003 - ERW - forward the message to local subscriptions
//-----------------------------------------------------------------------------------------------------------------------------------
of_post_data_subscription_message(as_message, as_argument)



Return True


end function

public function boolean of_message_asynch (string as_message, string as_argument, datetime adt_next_run_date, long al_batchid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_Message_Asynch
//	Arguments:  as_message 			- The message being published
//					as_argument 		- The argument for the message being published
//					adt_next_run_date - The date/time that this message is requesting that the response be scheduled
//	Overview:   This function publishes messages that will be processed by a RAMQ processor.  All messages sent to this
//					function will be inserted into the PublishedMessage table.  RAMQ itself is responsible for scheduling
//					responses based on the subscriptions in the Subscription table.
//	Created by:	Pat Newgent
//	History: 	11.11.2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string					ls_hstcmptr

ls_hstcmptr = gn_globals.is_login + " - " + string(gn_globals.il_spid)

//insert into publishedmessage
//	(	message,
//		argument,
//		publisheddate,
//		status,
//		scheduledresponsedate,
//		hstCmptr,
//		batchid
//	)
//values 
//	( 		:as_message,
//			:as_argument,
//			Current_TimeStamp,
//			'D',
//			:adt_next_run_date,
//			:ls_hstcmptr,
//			:al_batchid
//	);
	
if sqlca.sqlcode = - 1 then
	return FALSE
end if

if not isvalid(in_notification_service) then 
	in_notification_service = create n_notification_service
end if
in_notification_service.of_notify_message(as_message,as_argument)

//-----------------------------------------------------------------------------------------------------------------------------------
// #48688 
// 5/12/2004 - Pat Newgent
// Unneccessary code which causes the client machine to wait while RAMQ is intantiated
// and polls for processes.  This often yields to the client machine being blocked
// for extended periods of time.
//-----------------------------------------------------------------------------------------------------------------------------------
//if isvalid( gn_globals) then
//	gn_globals.in_subscription_service.post of_message( 'Poll Publishing RAMQ', '')
//end if


//-----------------------------------------------------------------------------------------------------------------------------------
// 12/1/2003 - ERW - forward the message to local subscriptions
//-----------------------------------------------------------------------------------------------------------------------------------
of_post_data_subscription_message(as_message, as_argument)


return TRUE


end function

public function boolean of_message_asynch (string as_message, string as_argument, long al_batchid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	of_message_asynch()
// Arguments:  as_message - The message to publish
//					as_argument - The arguments for the message (typically of the form column=value,column=value...)
//					al_batchid - The batchid is used to group messages together
// Overview:   This function creates publishedmessage records.
//					
// Created by:  Pat Newgent
// History:     11/5/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

datetime					ldt_rundatetime

ldt_rundatetime = in_date_manipulator.of_now()

return of_message_asynch( as_message, as_argument, ldt_rundatetime, al_batchid)

end function

public subroutine of_message (string as_message, any as_arg, powerobject al_publisherid);long li_count 
//----------------------------------------------------------------------------------------------------------------------------------
// Loop through the subscriptions looking for the objects subscribing to this message
//-----------------------------------------------------------------------------------------------------------------------------------
For li_count = 1 to ll_array_bound	
	if not isvalid(istr_subscription[li_count].in_object) then continue
	if Lower(Trim(istr_subscription[li_count].in_message)) = Lower(Trim(as_message)) then
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// IF this object is subscribing to another object or any object trigger the event.
		// JWP Modified to only send to null objects if the ib_singleobject is false
		//-----------------------------------------------------------------------------------------------------------------------------------
		if istr_subscription[li_count].il_object = al_publisherid or (isnull(istr_subscription[li_count].il_object) and istr_subscription[li_count].ib_singleobject = false ) then	
			istr_subscription[li_count].in_object.event dynamic ue_notify(as_message,as_arg)
		end if


	end if	
Next


end subroutine

protected subroutine of_post_data_subscription_message (string as_message, string as_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  as_message
//					as_argument
//	Overview:   Synchronize by routing messages to local RamQ
//	Created by:	Eric Wellnitz
//	History: 	12/1/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_registry ln_registry

if isvalid( gn_globals) then
	if (ln_registry.of_get_user_value('UseDataSubscription') = 'Y') then
		gn_globals.in_subscription_service.post of_message("sync" + "||" + as_message, as_argument)
	end if
end if

end subroutine

public function string of_commit_batch (long al_batchid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_commit_batch()
//	Arguments:  al_batchid	-	Represents the grouping of publishedmessages to update
//	Overview:   Updates the status of publishedmessages to 'N' so that can be processed
//	Created by:	Pat Newgent
//	History: 	11/6/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Update PublishedMessage
Set	Status = 'N'
Where	 BatchID = :al_batchid
Using SQLCA;

if sqlca.sqlcode <> 0 then 
	Return sqlca.sqlerrtext
End if

Return ''
end function

public function long of_get_batchid ();n_update_tools ln_update
long	ll_key

ln_update = create n_update_tools

ll_key = ln_update.of_get_Key('PublishedMessageBatch')

Destroy ln_update

Return ll_key
end function

on n_subscription_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_subscription_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;If IsValid(in_notification_service) Then destroy in_notification_service

end event

