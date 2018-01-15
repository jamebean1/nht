$PBExportHeader$n_cache_data.sru
forward
global type n_cache_data from nonvisualobject
end type
end forward

global type n_cache_data from nonvisualobject
event ue_notify ( string as_message,  any aany_argument )
end type
global n_cache_data n_cache_data

type prototypes
//Windows NT Function Calls
function int GetWindowsDirectoryA(ref string as_dir, int nSize) library 'kernel32.dll' alias for "GetWindowsDirectoryA;Ansi"

//Windows 32-bit Function Calls
function long GetTempPathA(long nBufferLength,ref string lpBugger) library 'kernel32.dll' alias for "GetTempPathA;Ansi"


end prototypes

type variables
boolean ib_recache = false

Public n_object_data Objects

Private:
	string 		is_temp_directory
	n_dao 		idao_cache[]
	string 		is_cache_title[]
	string 		is_auto_retrieve[]
	boolean 		ib_retrieved[]
	boolean 		ib_storelocal[]
	
	string		is_CacheDatawindowName[]
	string		is_AutomaticallyRetrieve[]
	
	

	Boolean	ib_subscribed_to_refresh_cache = False

end variables

forward prototypes
public function string of_get_cache_as_string (string as_title)
public function datastore of_get_cache_reference (string as_title)
public function string of_get_value (string as_cache_name, string as_value_name, string as_key_name, string as_key)
public subroutine of_init ()
private function n_dao of_find_cache (string as_title)
public function n_dao of_get_cache (string as_title)
public function string of_get_value (string as_cache_name, string as_value_name, string as_key_name, long al_key)
public subroutine of_refresh ()
public subroutine of_refresh_cache (string as_cache_title)
public subroutine of_retrieve_cache (string as_cache_title)
public subroutine of_retrieve_cache_all ()
end prototypes

event ue_notify(string as_message, any aany_argument);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	2/11/2003 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case Lower(Trim(as_message))
   Case 'refresh cache'
		If Lower(Trim(ClassName(aany_argument))) = 'string' Then This.of_refresh_cache(String(aany_argument))
   Case Else
End Choose

end event

public function string of_get_cache_as_string (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_cache_as_string()
//	Arguments:  as_title  - name of the cache
//	Overview:   Return a string representing the data that can be imported
//	Created by:	Blake Doerr
//	History: 	10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long li_i
n_dao ln_cache
n_dao ln_return_cache
String	ls_return

For li_i = 1 to upperbound(is_cache_title)
	
	if lower(is_cache_title[li_i]) = lower(as_title) then 
		if ib_retrieved[li_i] = false then 
			of_retrieve_cache(is_cache_title[li_i])
		end if
		ln_return_cache = create n_dao
		ln_return_cache.dataobject = idao_cache[li_i].dataobject

		if idao_cache[li_i].rowcount() > 0 then
			ls_return = idao_cache[li_i].Describe("Datawindow.Data")
			Return ls_return
		End if
		Exit
	End if
next

return ''
end function

public function datastore of_get_cache_reference (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_cache()
//	Arguments:  as_title  - name of the cache
//	Overview:   Return a copy of the cache. We don't return the cache so no-one can filter it.
//	Created by:	Jake Pratt
//	History: 	10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long li_i
n_dao ln_cache
n_dao ln_return_cache

For li_i = 1 to upperbound(is_cache_title)

	if lower(is_cache_title[li_i]) = lower(as_title) then 
		if ib_retrieved[li_i] = false then 
			of_retrieve_cache(is_cache_title[li_i])
		end if
		ln_return_cache = idao_cache[li_i]
	end if 
	
next

return ln_return_cache
end function

public function string of_get_value (string as_cache_name, string as_value_name, string as_key_name, string as_key);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_value()
//	Arguments:  as_cache_name - name of the cache to retrieve data from
//					as_value_name - name fo the value you want
//					al_id - id value you want from the cache
//	Overview:   Find the value of the cache
//	Created by:	Jake Pratt
//	History: 	10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_dao ln_cache
long ll_find_row
string ls_coltype

//-----------------------------------------------------------------------------------------------------------------------------------
// First find the cache, if it isn't valid, then return and error
//-----------------------------------------------------------------------------------------------------------------------------------
ln_cache = of_find_cache(as_cache_name)
if not isvalid(ln_cache)  then return 'No Cache Found'


//-----------------------------------------------------------------------------------------------------------------------------------
// Now find the row, this function assumes that the id is a string
//-----------------------------------------------------------------------------------------------------------------------------------
ll_find_row = ln_cache.find(as_key_name + ' = "' + as_key + '"' ,1,ln_cache.rowcount())
if ll_find_row > 0 then	
	
		
	ls_coltype = left(lower(ln_cache.describe(as_value_name + ".ColType")),4)	
	Choose Case ls_coltype	
			
		case 'char'
			
			return ln_cache.getitemstring(ll_find_row,as_value_name)
	
		Case 'numb'	,'long','deci'
			
			return string(	 ln_cache.getitemnumber(ll_find_row,as_value_name))

		case else
			
			return 'The caching service does not support the datatype that you requested'

	end choose
	
		
			
else
	
	return	'No Value Found'
	
end if



end function

public subroutine of_init ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_init()
//	Arguments:  none
//	Overview:   initialize the data caches.
//	Created by:	Jake Pratt
//	History: 	10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
String		ls_CacheName[]
String		ls_CacheDatawindowName[]
String		ls_CacheToHardDrive[]
String		ls_AutomaticallyRetrieve[]
Long			ll_index

Datastore	ln_datastore
ln_datastore = Create Datastore
ln_datastore.DataObject = 'd_dao_cachedatawindow'
ln_datastore.SetTransObject(SQLCA)
If ln_datastore.Retrieve() > 0 Then
	is_cache_title[]					= ln_datastore.Object.CacheName.Primary
	is_CacheDatawindowName[]		= ln_datastore.Object.CacheDatawindowName.Primary
	is_AutomaticallyRetrieve[]		= ln_datastore.Object.AutomaticallyRetrieve.Primary
	
	for ll_index = 1 to upperbound(is_cache_title)
		ib_retrieved[ll_index] = false
	next
	
	
End If

Destroy ln_datastore

/*
This data is now stored in the database in a table called CacheDatawindow
of_create_cache('Product','d_cache_product',TRUE)
of_create_cache('Locale','d_cache_locale',True)
of_create_cache('UOM','d_cache_uom',True)
of_create_cache('DealType','d_cache_dealtype',True)
of_create_cache('DealHeaderTemplate','d_cache_dealheadertemplate',true)
of_create_cache('DealDetailTemplate','d_cache_dealdetailtemplate',true)
of_create_cache('Chemical','d_cache_chemical',true)
of_create_cache('UnitToUnitConversion','d_cache_unittounitconversion',True)
of_create_cache('Prvsn','d_cache_prvsn',true)
of_create_cache('Currency','d_cache_currency',true)
of_create_cache('PrvsnValidTemplate','d_cache_prvsnvalidtemplate',True)
of_create_cache('PlannedTransferTemplateReport','d_cache_plannedtransfertemplatereport',True)
of_create_cache('PlannedMovementTemplate','d_cache_plannedMovementtemplate',True)
of_create_cache('SchedulingPeriod','d_cache_schedulingperiod',True)
of_create_cache('PrvsnAttributeType','d_cache_prvsnattributetype',True)
of_create_cache('RawPriceHeader','d_cache_rawpriceheader',True)
of_create_cache('MovementHeaderType','d_cache_movementheadertype',False)
of_create_cache('PayableHeaderTemplate','d_cache_payableheadertemplate',True)
of_create_cache('RequiredPrvsnAttributeType','d_cache_requiredprvsnattributetype',True)
of_create_cache('SourceSystem','d_cache_sourcesystem',True)
of_create_cache('LabAnalysisTemplate','d_cache_labanalysistemplate',True)
of_create_cache('LabAnalysisCommoditySpec','d_cache_labanalysiscommodityspec',True)
of_create_cache('ProductLocale','d_cache_productlocale',True)
of_create_cache('PriceType','d_cache_pricetype',False)
of_create_cache('GravityTable','d_cache_gravitytable',False)
of_create_cache('MovementHeaderTemplate','d_cache_movementheadertemplate',True)
of_create_cache('NetOutHeaderTemplate','d_cache_netoutheadertemplate',False)
of_create_cache('Vrble','d_cache_vrble',False)
of_create_cache('dddw_deal_rawpriceheaderlist','dddw_deal_rawpriceheaderlist',False)
of_create_cache('dddw_deal_tradeperiodoptions','dddw_deal_tradeperiodoptions',False)
of_create_cache('dddw_deal_forumulatabletrule','dddw_deal_forumulatabletrule',False)
of_create_cache('TaxRule','d_cache_taxrule',True)
of_create_cache('PositionHolder','d_cache_positionholder',True)
of_create_cache('BusinessAssociate','d_cache_businessassociate',False)
of_create_cache('MovementDocumentTemplate','d_cache_movementdocumenttemplate',True)
of_create_cache('Contact','d_cache_contact',False)
of_create_cache('ExchangeRateMethod','d_get_exchange_rate_method', False)
of_create_cache('ExchangeRate','d_get_exchange_rate', False)
of_create_cache('SubSystem','d_cache_subsystem', False)
of_create_cache('CommoditySubgroupSpecification','d_cache_commoditysubgroupspecification',False)

of_create_cache('Entity', 'd_entity_information_cache', False)
of_create_cache('EntityAction', 'd_entityaction_information_cache', False)
of_create_cache('EntityColumn', 'd_entitycolumn_information_cache', False)
of_create_cache('EntityNavigation', 'd_entity_navigate_reports_cache', False)
of_create_cache('EntityParameter', 'd_entity_navigate_parameter_cache', False)
of_create_cache('EntityDefaultReport', 'd_entity_default_report', False)
of_create_cache('ReportConfig', 'd_reportconfig_information_cache', False)

of_create_cache('NotificationSubscriptions','d_cache_notification_subscriptions',False)

of_create_cache('AccountingPeriod','d_cache_accountingperiod',False)
of_create_cache('SalesInvoiceType','d_cache_salesinvoicetype',False)
of_create_cache('Term','d_cache_term',False)
of_create_cache('Registry','d_cache_registry_system',false)
of_create_cache('GeneralConfiguration','d_cache_generalconfiguration_system',false)
of_create_cache('ReportConfigStatistics','d_data_reportconfigstatistics',false)
of_create_cache('DesktopTools','d_desktopserviceviewer_getreports_cache',false)
of_create_cache('PivotTableView','d_pivot_table_view_cache',false)
of_create_cache('NestedReportView','d_reportconfignested_cache',false)
of_create_cache('ReportView','d_dataobject_state_cache',false)
of_create_cache('ReportConfigDistributionMethod', 'd_reportconfigdistributionmethod', False)
of_create_cache('dddw_deal_postedpricelist_noarg','dddw_deal_postedpricelist_noarg',True)
of_find_cache('dddw_deal_postedpricelist_noarg')

of_create_cache('dddw_deal_data_rawpricelclecrrncyuom','dddw_deal_data_rawpricelclecrrncyuom',True)
of_find_cache('dddw_deal_data_rawpricelclecrrncyuom')

of_create_cache("TemplateRule",'d_templaterule',false)
of_find_cache('TemplateRule')
*/
end subroutine

private function n_dao of_find_cache (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_find_cache()
//	Arguments:  as_title  - name of the cache
//	Overview:   Private - Return the cache itself. Only safe if we don't filter
//						if filtering is needed, then we use of_get_cache.
//	Created by:	Jake Pratt
//	History: 	10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long li_i
n_dao ln_cache


For li_i = 1 to upperbound(is_cache_title)
	
	if lower(is_cache_title[li_i]) = lower(as_title) then 
		if ib_retrieved[li_i] = false then 
			of_retrieve_cache(is_cache_title[li_i])
		end if
			
		return idao_cache[li_i]

	end if
	
next

return ln_cache
end function

public function n_dao of_get_cache (string as_title);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_cache()
//	Arguments:  as_title  - name of the cache
//	Overview:   Return a copy of the cache. We don't return the cache so no-one can filter it.
//	Created by:	Jake Pratt
//	History: 	10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long li_i
n_dao ln_cache
n_dao ln_return_cache

For li_i = 1 to upperbound(is_cache_title)
	
	if lower(is_cache_title[li_i]) = lower(as_title) then 
		if ib_retrieved[li_i] = false then 
			of_retrieve_cache(is_cache_title[li_i])
		end if
		ln_return_cache = create n_dao
		ln_return_cache.dataobject = idao_cache[li_i].dataobject

		//-----------------------------------------------------------------------------------------------------------------------------------
		// 9/16/2002 - RPN
		// Replaced the object.data copy with RowsCopy to prevent memory leak in application
		//-----------------------------------------------------------------------------------------------------------------------------------
		//if idao_cache[li_i].rowcount() > 0 then ln_return_cache.object.data = idao_cache[li_i].object.data
		
		if idao_cache[li_i].rowcount() > 0 then
			idao_cache[li_i].Rowscopy (1, idao_cache[li_i].Rowcount(), Primary!, ln_return_cache, 1, Primary!)
		End if
		
		Exit
		
	end if
	
next

return ln_return_cache
end function

public function string of_get_value (string as_cache_name, string as_value_name, string as_key_name, long al_key);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_value()
//	Arguments:  as_cache_name - name of the cache to retrieve data from
//					as_value_name - name fo the value you want
//					al_id - id value you want from the cache
//	Overview:   Find the value of the cache
//	Created by:	Jake Pratt
//	History: 	10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_dao ln_cache
long ll_find_row
string ls_coltype

//-----------------------------------------------------------------------------------------------------------------------------------
// First find the cache, if it isn't valid, then return and error
//-----------------------------------------------------------------------------------------------------------------------------------
ln_cache = of_find_cache(as_cache_name)
if not isvalid(ln_cache)  then return 'No Cache Found'


//-----------------------------------------------------------------------------------------------------------------------------------
// Now find the row, this function assumes that the id is a string
//-----------------------------------------------------------------------------------------------------------------------------------
ll_find_row = ln_cache.find(as_key_name + ' = ' +  string(al_key) ,1,ln_cache.rowcount())
if ll_find_row > 0 then	
	
	ls_coltype = left(lower(ln_cache.describe(as_value_name + ".ColType")),4)	
	Choose Case ls_coltype
			
		case 'char'
			
			return ln_cache.getitemstring(ll_find_row,as_value_name)
	
		Case 'numb','long','deci'
			
			return string(	 ln_cache.getitemnumber(ll_find_row,as_value_name))
			
		Case 'date'
			
			return string( ln_cache.getitemdatetime(ll_find_row,as_value_name), 'yyyy-mm-dd')

		case else
			
			return 'The caching service does not support the datatype that you requested'

	end choose
	
		
			
else
	
	return	'No Value Found'
	
end if

end function

public subroutine of_refresh ();Long ll_index
string s_filename

For ll_index = 1 To UpperBound(idao_cache[])
	
	// Check for Invalid Caches
	If Not IsValid(idao_cache[ll_index]) Then Continue
	If Not IsValid(idao_cache[ll_index].Object) Then Continue
	If Not ib_retrieved[ll_index] Then Continue
	If is_cache_title[ll_index] = 'ReportConfigStatistics' Then Continue
	
	
	// Reset the Cache.  It will retrieve the next time it is asked for
	idao_cache[ll_index].reset()
	ib_retrieved[ll_index] = False


Next


If IsValid(gn_globals) Then
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_message('cache refreshed', '')
	End If
End If

If IsValid(Objects) Then Objects.of_destroy_objects()
end subroutine

public subroutine of_refresh_cache (string as_cache_title);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_refresh_cache()
//	Arguments:  as_cache_title - The title of the cache you want to refresh.
//	Overview:   DocumentScriptFunctionality
//	Created by:	Denton Newham
//	History: 	3/7/2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index, l_localrow
string s_filename
n_date_manipulator ln_date_manipulator

for ll_index = 1 to UpperBound(is_cache_title)
	if is_cache_title[ll_index] = as_cache_title then 

		If ll_index > UpperBound(idao_cache) then Continue
		If Not IsValid(idao_cache[ll_index]) Then Continue
		If Not IsValid(idao_cache[ll_index].Object) Then Continue
		If Lower(Trim(is_cache_title[ll_index])) = Lower('ReportConfigStatistics') Then Continue
		
		idao_cache[ll_index].reset()
		idao_cache[ll_index].settransobject(sqlca)
		
		Choose Case Lower(Trim(is_cache_title[ll_index]))
			Case Lower('ReportConfig')
				of_refresh_cache('ReportConfigDistributionMethod')
				of_refresh_cache('EntityReportConfig')
		End Choose
	
		ib_retrieved[ll_index] = FALSE
		Exit
	end if 
next
	
If IsValid(gn_globals) Then
	If IsValid(gn_globals.in_subscription_service) Then
		gn_globals.in_subscription_service.of_message('cache refreshed', as_cache_title)
	End If
End If
end subroutine

public subroutine of_retrieve_cache (string as_cache_title);long ll_upperbound,i_i
long l_localrow,l_serverrow
datetime dt_local_datetime,dt_server_datetime
string s_filename
//n_string_functions ln_string

If Not ib_subscribed_to_refresh_cache Then
	If IsValid(gn_globals) Then
		If IsValid(gn_globals.in_subscription_service) Then
			gn_globals.in_subscription_service.of_subscribe(This, 'refresh cache')
			ib_subscribed_to_refresh_cache = True
		End If
	End If
End If

for i_i = 1 to upperbound(is_cache_title)
	if is_cache_title[i_i] = as_cache_title then 
		ll_upperbound = i_i

		if ib_retrieved[i_i] = true then return
		
		idao_cache[i_i ] = create n_dao
		idao_cache[i_i ].dataobject = is_cachedatawindowname[i_i]
		
		If Not IsValid(idao_cache[i_i]) Then Continue
		If Not IsValid(idao_cache[i_i].Object) Then Continue		
		
		exit
	end if 
next

idao_cache[ll_upperbound ].settransobject(sqlca)

Choose Case Lower(Trim(is_cache_title[ll_upperbound]))
	Case Lower('EntityNavigation'), Lower('EntityReportConfigFavorites')
		idao_cache[ll_upperbound].Retrieve(gn_globals.il_userid)
	Case Lower('PivotTableView'), Lower('NestedReportView')
		idao_cache[ll_upperbound].Retrieve(0, gn_globals.il_userid, 0)
	Case Lower('ReportView')
		idao_cache[ll_upperbound].Retrieve(0, gn_globals.il_userid, 'All')
	Case Lower('ReportConfig')
		idao_cache[ll_upperbound].Retrieve(0, 'R')
	Case Lower('ReportConfigStatistics')
	Case Lower('ReportConfigDistributionMethod')
		idao_cache[ll_upperbound].Retrieve(0)
	Case Else
		idao_cache[ll_upperbound ].Retrieve()
End Choose


ib_retrieved[ll_upperbound] = true 
end subroutine

public subroutine of_retrieve_cache_all ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve_cache_all()
//	Arguments:  none
//	Overview:   Loops through and retrieves all caching objects
//	Created by:	Pat Newgent
//	History: 	4/15/2004 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long i 

If upperbound(is_cache_title[]) > 0 then 
	gn_globals.in_subscription_service.of_message('update statusbar', 'percent=0||message=loading cache...')
	
	For i = 1 to upperbound(is_cache_title[])
		gn_globals.in_subscription_service.of_message('update statusbar', 'percent=' + string(Long(i/upperbound(is_cache_title[]) * 100)) +'||message=loading cache...')
		this.of_retrieve_cache(is_cache_title[i])
	Next
	gn_globals.in_subscription_service.of_message('update statusbar', 'percent=100||message=loading cache...')
	
End If
end subroutine

on n_cache_data.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cache_data.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      constructur
//	Overrides:  No
//	Arguments:	
//	Overview:   creat ethe cache data
//	Created by: Jake Pratt
//	History:    10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Objects = Create n_object_data 
of_init()

end event

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   destroy the caches
//	Created by: Jake Pratt
//	History:    10/5/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long i_i




For i_i = 1 to upperbound(idao_cache)
	if isvalid(idao_cache[i_i]) then 
		destroy idao_cache[i_i]
	end if
next

Destroy Objects
end event

