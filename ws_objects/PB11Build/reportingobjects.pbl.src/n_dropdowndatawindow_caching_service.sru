$PBExportHeader$n_dropdowndatawindow_caching_service.sru
$PBExportComments$Datawindow Service - This is the DDDW caching service.  It is a datawindow service that calls the global DDDW caching manager.
forward
global type n_dropdowndatawindow_caching_service from nonvisualobject
end type
end forward

global type n_dropdowndatawindow_caching_service from nonvisualobject
event ue_notify ( string as_message,  any as_arg )
end type
global n_dropdowndatawindow_caching_service n_dropdowndatawindow_caching_service

type variables
Protected:
PowerObject io_datasource
String is_exclude[]
DatawindowChild	idwc_children[]
String				is_dataobjectname[]

Boolean	ib_retrievestart_has_been_triggered = False
Boolean	ib_retrieveend_has_been_triggered = False

Boolean	ib_subscribed = False
end variables

forward prototypes
public subroutine of_retrievestart ()
public subroutine of_beforeinsertrow ()
public subroutine of_exclude_column (string as_columnname)
public function boolean of_iscacheable ()
protected function boolean of_isexcluded (string as_columnname)
public subroutine of_retrieveend (long rowcount)
public subroutine of_init (powerobject ao_datasource)
public subroutine of_refresh ()
public subroutine of_afterinsertrow ()
public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield)
end prototypes

event ue_notify;//----------------------------------------------------------------------------------------------------------------------------------
// Event:      ue_notify
// Overrides:  No
// Arguments:	as_message (String)    	- The message being triggered
//					aany_argument (Any) 		- The argument for the message
// Overview:   This event receives messages both internally and from the subscription service
// 
// Created by: Blake Doerr
// History:   	7/6/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


Choose Case Lower(Trim(as_message))
   Case 'refresh'
		This.of_refresh()
	Case 'group by happened', 'after view restored'
		This.of_init(io_datasource)
   Case Else
End Choose

end event

public subroutine of_retrievestart ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:      of_retrievestart()
// Overview:   This will loop through the datawindows looking for dropdowns to cache.
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


//gn_globals.in_dddw_cache.of_retrievestart(idwc_children[], is_dataobjectname[])

/*

String is_column_name, ls_name, ls_displaycolumn, ls_datacolumn, ls_columnname
Long ll_index
DatawindowChild ldwc_temp


//This will loop through the datawindow columns and describe the dddw.name.  If there is a name it will
//  make sure that there are no rows in the dddw before it caches.  This is important because if a dddw has retrieval arguments
//  it will already have rows in it.  This also prevents caching when the datawindow has already been retrieved.
If IsValid(idw_data) Then
	If Not ib_retrieved Then
		ib_retrieved = True
		
		For ll_index = 1 to Long(idw_data.Describe("DataWindow.Column.Count"))
			ls_name 				= idw_data.Describe("#" + string(ll_index) + ".dddw.name"			)
			ls_columnname 		= idw_data.Describe("#" + string(ll_index) + ".name"			)
			
			If ls_name <> '!' And ls_name <> '?' And Trim(ls_columnname) <> '' Then
				If Not of_isexcluded(ls_name) Then
					idw_data.GetChild(ls_columnname, ldwc_temp)
					If IsValid(ldwc_temp) Then
						//If Len(Trim(ldwc_temp.Describe("Table.Arguments"))) = 0 Then
							If ldwc_temp.RowCount() = 0 Then
								gn_globals.in_dddw_cache.of_cache(ls_name, ldwc_temp)
							End If
						//End If
					End If
				End If
			End If
		Next
	
	End If
End If
*/
end subroutine

public subroutine of_beforeinsertrow ();//Just redirect this event to the retrievestart function
This.of_retrievestart()
end subroutine

public subroutine of_exclude_column (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_exclude_column()
// Arguments:   as_columnname - the column name that you want the service to ignore
// Overview:    This will add a column for the service to ignore
// Created by:  Blake Doerr
// History:     6/8/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_exclude[UpperBound(is_exclude[]) + 1] = Trim(as_columnname)
end subroutine

public function boolean of_iscacheable ();Return UpperBound(idwc_children[]) > 0
end function

protected function boolean of_isexcluded (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_isexcluded()
// Arguments:   as_columnname - The column name to check
// Overview:    Check to see if a column is excluded
// Created by:  Blake Doerr
// History:     6/8/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Long ll_index


//----------------------------------------------------------------------------------------------------------------------------------
// Loop through the columns and check for existence
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(is_exclude[])
	If Lower(Trim(as_columnname)) = Lower(Trim(is_exclude[ll_index])) Then Return True
Next

Return False
end function

public subroutine of_retrieveend (long rowcount);//----------------------------------------------------------------------------------------------------------------------------------
// Function:   of_retrieveend()
// Overview:   This will loop through the datawindows looking for dropdowns to cache.
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If Not ib_retrieveend_has_been_triggered Then
	If rowcount > 0 Then
		gn_globals.in_dddw_cache.of_retrieveend(idwc_children[], is_dataobjectname[])
		ib_retrieveend_has_been_triggered = True
	End If
End If

end subroutine

public subroutine of_init (powerobject ao_datasource);//----------------------------------------------------------------------------------------------------------------------------------
// Event:      of_init()
// Overview:   Initialize the service
// Created by: Blake Doerr
// History:    6/4/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------
// Local Variables
//--------------------------------------------------------------------------------------------
Long 	ll_index
Long	ll_columncount
String	ls_name
String	ls_columnname
DatawindowChild ldwc_temp
io_datasource = ao_datasource
n_datawindow_tools ln_datawindow_tools
datawindowchild	ldwc_empty[]
string				ls_empty[]

idwc_children[] 		= ldwc_empty[]
is_dataobjectname[]	= ls_empty[]

//--------------------------------------------------------------------------------------------
// Return if the datawindow isn't valid
//--------------------------------------------------------------------------------------------
If Not IsValid(ao_datasource) Then Return
ln_datawindow_tools = Create n_datawindow_tools

//--------------------------------------------------------------------------------------------
// Get the number of columns
//--------------------------------------------------------------------------------------------
ll_columncount = Long(ao_datasource.Dynamic Describe("DataWindow.Column.Count"))

//--------------------------------------------------------------------------------------------
// Loop through all the columns and get the dropdowns
//--------------------------------------------------------------------------------------------
For ll_index = 1 To ll_columncount
	//--------------------------------------------------------------------------------------------
	// Get the name of the dropdowndatawindow
	//--------------------------------------------------------------------------------------------
	ls_name 				= ao_datasource.Dynamic Describe("#" + string(ll_index) + ".dddw.name")

	//--------------------------------------------------------------------------------------------
	// Continue if it isn't a dropdown
	//--------------------------------------------------------------------------------------------
	If ls_name = '!' Or ls_name = '?' Then Continue

	//--------------------------------------------------------------------------------------------
	// Get the name of the column
	//--------------------------------------------------------------------------------------------
	ls_columnname		= ao_datasource.Dynamic Describe("#" + string(ll_index) + ".name")
	
	//--------------------------------------------------------------------------------------------
	// If it's excluded, continue
	//--------------------------------------------------------------------------------------------
	If of_isexcluded(ls_columnname) Then Continue
	
	//--------------------------------------------------------------------------------------------
	// Get a pointer to the datawindowchild
	//--------------------------------------------------------------------------------------------
	ao_datasource.Dynamic GetChild(ls_columnname, ldwc_temp)
	
	//--------------------------------------------------------------------------------------------
	// If it isn't valid, continue
	//--------------------------------------------------------------------------------------------
	If Not IsValid(ldwc_temp) Then Continue

	//--------------------------------------------------------------------------------------------
	// If this dropdown isn't for cacheing, continue
	//--------------------------------------------------------------------------------------------
	If Not ln_datawindow_tools.of_IsComputedField(ldwc_temp, 'cacheinit') Then Continue

	//--------------------------------------------------------------------------------------------
	// Make sure that there aren't arguments
	//--------------------------------------------------------------------------------------------
	//If Len(Trim(ldwc_temp.Describe("Table.Arguments"))) = 0 Then Continue

	//--------------------------------------------------------------------------------------------
	// Add it to the array
	//--------------------------------------------------------------------------------------------
	idwc_children		[UpperBound(idwc_children[]) + 1] 		= ldwc_temp
	is_dataobjectname	[UpperBound(is_dataobjectname[]) + 1] 	= ls_name
Next

Destroy ln_datawindow_tools

if isvalid(gn_globals.in_subscription_service) and NOT ib_subscribed then
	gn_globals.in_subscription_service.of_subscribe( this, 'group by happened', io_datasource)
	gn_globals.in_subscription_service.of_subscribe( this, 'after view restored', io_datasource)
	ib_subscribed = TRUE
end if
end subroutine

public subroutine of_refresh ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_refresh()
//	Overview:   This will reretrieve all the dropdowns on the datawindow
//	Created by:	Blake Doerr
//	History: 	7/6/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
Transaction lxctn_transaction

//-----------------------------------------------------------------------------------------------------------------------------------
// Return if the datawindow isn't valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(io_datasource) Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the transaction from the datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case io_datasource.TypeOf()
	Case Datawindow!
		lxctn_transaction = io_datasource.Dynamic gettransobject()
	Case Datastore!
		lxctn_transaction = SQLCA
End Choose

//-----------------------------------------------------------------------------------------------------------------------------------
// If the transaction isn't valid, use SQLCA
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(lxctn_transaction) Then lxctn_transaction = SQLCA

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve each datawindow child
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To UpperBound(idwc_children[])
	If IsValid(idwc_children[ll_index]) Then
		idwc_children[ll_index].SetTransObject(lxctn_transaction)
		idwc_children[ll_index].Retrieve()
	End If
Next

if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message('dropdowns refreshed', io_datasource, io_datasource)
end if
end subroutine

public subroutine of_afterinsertrow ();//Just redirect this event to the retrievestart function
This.of_retrieveend(io_datasource.Dynamic RowCount())
end subroutine

public subroutine of_build_menu (ref n_menu_dynamic an_menu_dynamic, string as_objectname, boolean ab_iscolumn, boolean ab_iscomputedfield);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_build_menu()
//	Arguments:  am_dynamic 				- The dynamic menu to add to
//					as_objectname			- The name of the object that the menu is being presented for
//					ab_iscolumn				- Whether or not the object is a column
//					ab_iscomputedfield	- Whether or not the object is a computed field
//	Overview:   This will allow this service to create its own menu
//	Created by:	Blake Doerr
//	History: 	3/1/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Make sure that objects are valid
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(an_menu_dynamic) Then Return
If Not IsValid(io_datasource) Then Return
If Not This.of_IsCacheable() Then Return

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a spacer since the menu has items already
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('-', '', '', This)

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the menu items for this service
//-----------------------------------------------------------------------------------------------------------------------------------
an_menu_dynamic.of_add_item('&Refresh Dropdowns', 'refresh', 	'', This)

end subroutine

on n_dropdowndatawindow_caching_service.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dropdowndatawindow_caching_service.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

