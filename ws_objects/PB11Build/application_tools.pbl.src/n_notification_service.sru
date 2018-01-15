$PBExportHeader$n_notification_service.sru
forward
global type n_notification_service from nonvisualobject
end type
end forward

global type n_notification_service from nonvisualobject
end type
global n_notification_service n_notification_service

type variables
datastore ids_subscriptions
end variables

forward prototypes
public subroutine of_notify_message (string as_message, string as_argument)
end prototypes

public subroutine of_notify_message (string as_message, string as_argument);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_notify_message()
//	Arguments:  string - as_message, string as_arguement
//	Overview:   Send messages to message recipients
//	Created by:	Jake Pratt
//	History: 	3/10/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long 		l_users[],l_rowcount,i_i,i_y,i_z,l_roles[]
string 	s_fromlist[], s_methodofdelivery[], s_sourcetype[],s_email[]
string 	s_args[], s_values[],s_object,s_entity,s_action
n_datastore_tools ln_datastore_tools
//n_String_functions ln_String
string 	s_subject
boolean 	b_fromlist_found = false
//n_notification_message_generic ln_notification_message_generic
//n_tickler_message ln_tickler_message
string 	s_messagetext, s_messageactions, s_action_description
datastore ln_datastore
//n_jmail_service ln_jmail_service

//--------------------------------------------------------------
// Filter the DescriptionList and Get values into an array.
//-------------------------------------------------------------
ids_subscriptions.setfilter('name = "' + as_message + '"')
ids_subscriptions.filter()

l_rowcount =  ids_subscriptions.rowcount()
if l_rowcount = 0 then return 

l_users 			= ids_subscriptions.object.sourceid[1,l_rowcount]
s_sourcetype 	= ids_subscriptions.object.sourcetype[1,l_rowcount]
s_methodofdelivery = ids_subscriptions.object.methodofdelivery[1,l_rowcount]
s_fromlist 		= ids_subscriptions.object.fromlist[1,l_rowcount]
s_email  		= ids_subscriptions.object.CntctEMlAddrss[1,l_rowcount]


//-------------------------------------------------------------------------------------------
// Delete any users who have resticted the From User/Role and this user doesn't qualify
//Look through the l_users and process any fromlists.
//-------------------------------------------------------------------------------------------
For i_i = 1 to upperbound(l_users)
	if len(s_fromlist[i_i]) > 0 then 
		
		gn_globals.in_string_functions.of_parse_arguments ( s_fromlist[i_i], s_args, s_values )

		b_fromlist_found = false
		
		//---------------------------------------------------------
		// There could be up two two args, Users and Roles
		//---------------------------------------------------------
		for i_y = 1 to upperbound(s_args)
			
			//---------------------------------------------------------
			// Process the UsersFromList
			//---------------------------------------------------------
			if s_args[i_y] = 'users' then 
				s_values[i_y] =  ',' + s_values[i_y] + ','
				if pos(s_values[i_y], ',' + string(gn_globals.il_userid) + ',') > 0 then 
					b_fromlist_found = true
				end if
			else
				//---------------------------------------------------------
				// Process the RolesFromList
				//----------------------------------------------------------
				ln_datastore_tools = create n_datastore_tools
				ln_datastore_tools.of_get_values ( 'select UserRoleRoleID from Userrole Where UserRoleUserID = ' + string(gn_globals.il_userid), l_roles )
				destroy ln_datastore_tools
				for i_z = 1 to upperbound(l_roles)
					s_values[i_y] =  ',' + s_values[i_y] + ','
					if pos(s_values[i_y],',' + string(l_roles[i_z]) + ',') > 0 then 
						b_fromlist_found = true
						exit
					end if
				next
				
			end if
			if b_fromlist_found then exit
			
		next
		
		if not b_fromlist_found  then 
			s_methodofdelivery[i_i] = 'NoSend'
		end if
		
	end if
next
	

//-----------------------------------------------------------------
// Determine Message Handler Object From Message Table
//-----------------------------------------------------------------
Select NotificationObject
Into :s_object
From Message (NOLOCK)
Where Name = :as_message;

//----------------------------------------------------------------
// If Null, Then use Default of n_notification_message_generic
//----------------------------------------------------------------

if s_object = '' or isnull(s_object) then 
	s_object = 	'n_notification_message_generic'
end if
	

if lower(left(s_object,2)) = 'n_' then 
	//----------------------------------------------------------------
	//Create Message Handler Object and call the text handler functions
	//----------------------------------------------------------------
//	ln_notification_message_generic = create using s_object
	s_subject =  left(as_message,49)
//	ln_notification_message_generic.of_process_message(as_message,as_argument, l_users,s_subject,  s_messagetext,s_entity,s_action,s_action_description)

else
	
	s_object = 'Execute ' + s_object + " @vc_message=?, @vc_args=?"     //'"+ as_message + "','" + as_argument + "'"
	//----------------------------------------------------------------
	//if the Message handler object is an SP, call it now.
	//----------------------------------------------------------------
	DECLARE lc_getmessage DYNAMIC Cursor FOR SQLSA ;
	PREPARE SQLSA FROM :s_object ;
	OPEN DYNAMIC lc_getmessage using :as_message, :as_argument ;
	FETCH lc_getmessage INTO :s_subject, :s_messagetext ;
	CLOSE lc_getmessage ;

	
end if


//----------------------------------------------------------------
// Now send the messages
//----------------------------------------------------------------
//ln_tickler_message = create n_tickler_message
//ln_jmail_service = create n_jmail_service
for i_i = 1 to upperbound(l_users)

	//----------------------------------------------------------------
	//Send Messages Via Tickler
	//----------------------------------------------------------------
	if s_methodofdelivery[i_i] = 'tickler' then 

		if len(s_action) > 0 and not isnull(s_action) then
		//	ln_tickler_message.of_set_attachment ( s_action_description, s_entity, s_action)
		end if 
//		ln_tickler_message.of_send_ticklermessage ( gn_globals.il_userid, l_users[i_i], 'U',s_subject, s_messagetext, s_entity, s_action )

	end if
	
	//----------------------------------------------------------------
	// Send Messages Via Email.
	//----------------------------------------------------------------
	if s_methodofdelivery[i_i] = 'email' then 
		
//		ln_jmail_service.of_send_mail ( 'DEFAULT', "sysuser", "RAIV System", {s_email[i_i]}, {s_email[i_i]}, s_subject, s_messagetext, {""} )

	end if
next
//Destroy n_tickler_message
//destroy ln_jmail_service
end subroutine

on n_notification_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_notification_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
//ids_subscriptions = gn_globals.in_cache.of_get_cache_reference('NotificationSubscriptions')
end event

