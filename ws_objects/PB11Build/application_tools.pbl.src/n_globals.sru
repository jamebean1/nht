$PBExportHeader$n_globals.sru
$PBExportComments$<doc>This is a non-visual that will hold all the global variables and services for the application
forward
global type n_globals from nonvisualobject
end type
end forward

global type n_globals from nonvisualobject
end type
global n_globals n_globals

type variables
// Services instanciated globallly
n_subscription_service in_subscription_service
n_theme in_theme
n_multimedia in_multimedia
n_navigation_manager  in_navigation_manager
//n_dao_security in_security
n_messagebox in_messagebox
n_dropdowndatawindow_caching_manager in_dddw_cache
//n_transaction_pool in_transaction_pool
//n_ds_generalconfiguration in_ds_generalconfiguration
//n_memory_management	in_memory_management
//t_KeyManager	it_KeyManager
//n_audit_logout	in_audit_logout
n_string_functions in_string_functions
n_date_manipulator in_date_manipulator
//n_pdf_generator in_pdf_generator



//Drop Down Manager
n_drpdwnppup_manager gnv_drpdwnppup_mngr

//DAO Data Caching object
n_cache_data in_cache
//n_performance_statistics_manager in_performance_statistics_manager

// Global Variables
string is_username
long il_userid
string is_customername
string is_inifilename
long il_contactid
long il_baid
string is_nickname
long il_nullnumber
string is_windowsdirectory
string is_nullstring
double il_color_depth

long il_default_uom
long il_system_uom
boolean ib_maximize
Boolean ib_using_trusted_connection = False
string is_noninteractive = 'N'

long il_spid
boolean ib_debug = false
long il_batchid


string	is_login

datastore ids_syntax

LONG	il_view_confidentiality_level

end variables

forward prototypes
public subroutine of_global_sql_error (long al_error, string as_error)
public function long of_get_generalconfiguration (string s_gnrlcnfgtblnme, string s_gnrlcnfgqlfr, long i_gnrlcnfghdrid, long i_gnrlcnfgdtlid, ref string s_gnrlcnfgmulti)
public function window of_opensheet (string aw_window)
public subroutine of_log_error (string as_error)
public function powerobject of_get_frame ()
public function powerobject of_get_object (string as_argument)
public subroutine of_init ()
end prototypes

public subroutine of_global_sql_error (long al_error, string as_error);

end subroutine

public function long of_get_generalconfiguration (string s_gnrlcnfgtblnme, string s_gnrlcnfgqlfr, long i_gnrlcnfghdrid, long i_gnrlcnfgdtlid, ref string s_gnrlcnfgmulti);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_get_general_configuration()
// Arguments:   see list	
// Overview:    Pass qualitifer to get a GC ENTRY.
// Created by:  
// History:     
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String ls_value

//-----------------------------------------------------------------------------------------------------------------------------------
// If the value is cached, get it from the datastore
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Trim(s_gnrlcnfgtblnme)) = 'system' Then
//	If IsValid(in_ds_generalconfiguration) Then
//
//		ls_value = in_ds_generalconfiguration.of_get_generalconfig_value(s_gnrlcnfgtblnme, s_gnrlcnfgqlfr, i_gnrlcnfghdrid, i_gnrlcnfgdtlid)
//		If Not IsNull(ls_value) Then
//			s_gnrlcnfgmulti = ls_value
//			Return 0
//		End If
//	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// If the value was not cached, get it from the database
//-----------------------------------------------------------------------------------------------------------------------------------
SELECT cusfocus.generalconfiguration.gnrlcnfgmulti INTO :s_gnrlcnfgmulti
FROM cusfocus.generalconfiguration  
WHERE ( cusfocus.generalconfiguration.gnrlcnfgtblnme = :s_gnrlcnfgtblnme ) AND  
      ( cusfocus.generalconfiguration.gnrlcnfgqlfr = :s_gnrlcnfgqlfr ) AND  
      ( cusfocus.generalconfiguration.gnrlcnfghdrid = :i_gnrlcnfghdrid ) AND  
      ( cusfocus.generalconfiguration.gnrlcnfgdtlid = :i_gnrlcnfgdtlid )   ;

Return SQLCA.SQLCODE

end function

public function window of_opensheet (string aw_window);//----------------------------------------------------------------------------------------------------------------------------------
// Function:      of_opensheet
// Overview:   This will open sheets while managing their state (minimized/maximized) because we don't like powerbuilder behaviour
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------


window iw_window,iw_currentwindow
iw_currentwindow = w_mdi_frame.getactivesheet()

if isvalid(iw_currentwindow) then 
	if iw_currentwindow.windowstate  = Maximized! then
		ib_maximize = true
		OpenSheet(iw_window,aw_window,w_mdi_frame,0,Layered!)	
		iw_window.windowstate = maximized!
	else
		OpenSheet(iw_window,aw_window,w_mdi_frame,0,Layered!)	
	end if
else
	OpenSheet(iw_window,aw_window,w_mdi_frame,0,Layered!)	
end if

return iw_window
end function

public subroutine of_log_error (string as_error);
end subroutine

public function powerobject of_get_frame ();Return w_mdi_frame
end function

public function powerobject of_get_object (string as_argument);PowerObject lo_null

Choose Case Lower(Trim(as_argument))
	Case 'n_subscription_service'
		Return in_subscription_service
	Case 'n_theme'
		Return in_theme
//	Case 'n_multimedia'
//		Return in_multimedia
	Case 'n_navigation_manager'
		Return in_navigation_manager
//	Case 'n_dao_security'
//		Return in_security
	Case 'n_messagebox'
		Return in_messagebox
//	Case 'n_dropdowndatawindow_caching_manager'
//		Return in_dddw_cache
//	Case 'n_transaction_pool'
//		Return in_transaction_pool
//	Case 'n_ds_generalconfiguration'
//		Return in_ds_generalconfiguration
//	Case 'n_memory_management'
//		Return in_memory_management
//	Case 't_KeyManager'
//		Return it_KeyManager
////	Case 'n_drpdwnppup_manager'
//		Return gnv_drpdwnppup_mngr
	Case 'n_cache_data'
		Return in_cache
//	Case 'n_performance_statistics_manager'
//		Return in_performance_statistics_manager
End Choose

Return lo_null
end function

public subroutine of_init ();//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_init
// Overview:   This will create all the services and initialize them if needed
// Created by: 
// History:    
//-----------------------------------------------------------------------------------------------------------------------------------

in_subscription_service 				= create n_subscription_service

in_theme 									= create n_theme
in_navigation_manager 					= Create n_navigation_manager  
//in_dddw_cache 								= Create n_dropdowndatawindow_caching_manager
//in_security 								= Create n_dao_security
//in_transaction_pool						= Create n_transaction_pool
in_cache										= Create	n_cache_data
//in_performance_statistics_manager	= Create n_performance_statistics_manager
//in_memory_management						= Create n_memory_management
//it_KeyManager								= Create t_KeyManager
//in_audit_logout							= Create	n_audit_logout
in_string_functions						= Create n_string_functions
in_date_manipulator						= Create n_date_manipulator
//in_pdf_generator 							= Create n_pdf_generator
gnv_drpdwnppup_mngr						= Create  n_drpdwnppup_manager
in_messagebox = Create n_messagebox

is_login = OBJCA.WIN.fu_GetLogin (SQLCA)

//If Not IsValid(in_ds_generalconfiguration) Then
//	in_ds_generalconfiguration		= Create	n_ds_generalconfiguration
//	in_ds_generalconfiguration.of_init('System')
//End If
//
//-----------------------------------------------------------------------------------------------------------------------------------
// Get the number of colors for the system.
//-----------------------------------------------------------------------------------------------------------------------------------
environment env

GetEnvironment(env)
il_color_depth = env.NumberOfColors

If il_color_depth < 16 Then
	il_color_depth = 65000
End If

//----------------------------------------------------------------------------------------------------------------------------------
// Initialize the security object by telling it the userid
//-----------------------------------------------------------------------------------------------------------------------------------
//in_security.of_init(il_userid)

//----------------------------------------------------------------------------------------------------------------------------------
// Initialize the audit logout feature
//-----------------------------------------------------------------------------------------------------------------------------------
//if Not in_audit_logout.of_init() then Destroy in_audit_logout

//----------------------------------------------------------------------------------------------------------------------------------
// Set the UserID into an instance variable that will be available on n_globals
//-----------------------------------------------------------------------------------------------------------------------------------
  SELECT cusfocus.cusfocus_user.id, 
         cusfocus.cusfocus_user.view_confidentiality_level  
    INTO :il_userid, :il_view_confidentiality_level  
    FROM cusfocus.cusfocus_user  
   WHERE cusfocus.cusfocus_user.user_id = :is_login
           ;

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the database SPID
//-----------------------------------------------------------------------------------------------------------------------------------
select @@SPID into :il_spid from master..sysprocesses noholdlock where spid = @@spid;
end subroutine

on n_globals.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_globals.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;


Destroy in_subscription_service
Destroy in_navigation_manager
Destroy in_messagebox


Destroy ids_syntax
end event

event constructor;//of_init()

//-----------------------------------------------------------------------------------------------------------------------------------
// Setup the datastore that will get the user stored report syntax
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_rowcount

ids_syntax	= Create datastore
ids_syntax.Dataobject = 'd_data_syntaxstorage'
ids_syntax.SetTransObject(SQLCA)


ids_syntax.Retrieve(is_login)

ll_rowcount = ids_syntax.RowCount()

ll_rowcount = ll_rowcount
end event

