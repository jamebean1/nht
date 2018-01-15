$PBExportHeader$n_dropdowndatawindow_caching_manager.sru
$PBExportComments$This is the DDDW caching manager.  It will be a global object called from n_dropdowndatawindow_caching_service that will cache DDDW's.
forward
global type n_dropdowndatawindow_caching_manager from nonvisualobject
end type
end forward

global type n_dropdowndatawindow_caching_manager from nonvisualobject
end type
global n_dropdowndatawindow_caching_manager n_dropdowndatawindow_caching_manager

type variables
Private:
   DatawindowChild idwc_cache[]
   String is_dataobject[], is_data[], is_dataobjects
end variables

forward prototypes
public subroutine of_clear ()
public subroutine of_retrieveend (datawindowchild adwc_children[], string as_dropdowndatawindowname[])
public function string of_get_cache (string as_dddw_name)
public subroutine of_add_cache (string as_dddw_name, string as_data)
public subroutine of_retrievestart (datawindowchild adwc_children[], string as_dropdowndatawindowname[])
end prototypes

public subroutine of_clear ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_clear()
//	Overview:   Clear the cached dropdowns
//	Created by:	Blake Doerr
//	History: 	7/11/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

String ls_empty[]

is_dataobject[]	= ls_empty[]
is_data[]			= ls_empty[]
is_dataobjects		= ''
end subroutine

public subroutine of_retrieveend (datawindowchild adwc_children[], string as_dropdowndatawindowname[]);//-----------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------
Long 	ll_upperbound, ll_upperbound2
Long	ll_index, ll_index2

//-----------------------------------------------------------------------------------------------
// Get the upperbounds of the arrays
//-----------------------------------------------------------------------------------------------
ll_upperbound = Min(UpperBound(as_dropdowndatawindowname[]), UpperBound(adwc_children[]))
ll_upperbound2 = Min(UpperBound(is_dataobject[]), UpperBound(is_data[]))

//-----------------------------------------------------------------------------------------------
// Loop through all the passed in children and look for cacheing opportunities
//-----------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	//-----------------------------------------------------------------------------------------------
	// If the datawindowchild isn't valid, continue
	//-----------------------------------------------------------------------------------------------
	If Not IsValid(adwc_children[ll_index]) Then Continue
	
	//-----------------------------------------------------------------------------------------------
	// Continue if the rowcount is zero
	//-----------------------------------------------------------------------------------------------
	If adwc_children[ll_index].RowCount() <= 0 and adwc_children[ll_index].filteredcount() <= 0 Then Continue
	
	//-----------------------------------------------------------------------------------------------
	// If the dropdown is cached, continue
	//-----------------------------------------------------------------------------------------------
	If Pos(',' + is_dataobjects + ',', ',' + Trim(as_dropdowndatawindowname[ll_index]) + ',') > 0 Then Continue

	//-----------------------------------------------------------------------------------------------
	// Add the data
	//-----------------------------------------------------------------------------------------------
	is_dataobject[UpperBound(is_dataobject[]) + 1] 	= as_dropdowndatawindowname[ll_index]
	is_data[UpperBound(is_data[]) + 1] 					= adwc_children[ll_index].Describe("Datawindow.Data")
	is_dataobjects = is_dataobjects + ',' + as_dropdowndatawindowname[ll_index] + ','
Next
end subroutine

public function string of_get_cache (string as_dddw_name);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_return_cache_data()
//	Arguments:  as_dddw_name - name of dddw you want the cache for.
//	Overview:   Return the ImportString of data for the dddw
//	Created by:	Jake Pratt
//	History: 	10/10/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long li_count


For li_count = 1 to upperbound(is_dataobject[])
	
	if is_dataobject[li_count] = as_dddw_name then 
		return is_data[li_count]
	end if
next

return ''
end function

public subroutine of_add_cache (string as_dddw_name, string as_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_add_cache
//	Overrides:  No
//	Arguments:	
//	Overview:   Add a new dddw to the cache
//	Created by: Jake Pratt
//	History:    10/10/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_dataobject[ upperbound(is_dataobject[]) + 1] = as_dddw_name
is_data[ upperbound(is_data[]) + 1] = as_data

end subroutine

public subroutine of_retrievestart (datawindowchild adwc_children[], string as_dropdowndatawindowname[]);//-----------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------
Long 	ll_upperbound, ll_upperbound2
Long	ll_index, ll_index2
DatawindowChild ldwc_child[]
String			ls_dataobject[]

//-----------------------------------------------------------------------------------------------
// Get the upperbounds of the arrays
//-----------------------------------------------------------------------------------------------
ll_upperbound = Min(UpperBound(as_dropdowndatawindowname[]), UpperBound(adwc_children[]))
ll_upperbound2 = Min(UpperBound(is_dataobject[]), UpperBound(is_data[]))

//-----------------------------------------------------------------------------------------------
// Loop through all the passed in children and look for cacheing opportunities
//-----------------------------------------------------------------------------------------------
For ll_index = 1 To ll_upperbound
	//-----------------------------------------------------------------------------------------------
	// If the datawindowchild isn't valid, continue
	//-----------------------------------------------------------------------------------------------
	If Not IsValid(adwc_children[ll_index]) Then Continue

	//-----------------------------------------------------------------------------------------------
	// If the datawindowchild already has rows, don't repopulate
	//-----------------------------------------------------------------------------------------------
	If adwc_children[ll_index].rowcount() > 0 or adwc_children[ll_index].filteredcount() > 0  Then Continue

	//-----------------------------------------------------------------------------------------------
	// If the dropdown isn't cached, continue
	//-----------------------------------------------------------------------------------------------
	If Not Pos(',' + is_dataobjects + ',', ',' + Trim(as_dropdowndatawindowname[ll_index]) + ',') > 0 Then 
		//-----------------------------------------------------------------------------------------------
		// This will determine if there are multiple dropdowns of the same type.  If so, we should
		//		retrieve the first one and let the others get cached
		//-----------------------------------------------------------------------------------------------
		For ll_index2 = ll_index + 1 To ll_upperbound
			If Lower(Trim(as_dropdowndatawindowname[ll_index])) = Lower(Trim(as_dropdowndatawindowname[ll_index2])) Then
				adwc_children[ll_index].SetTransObject(SQLCA)
				adwc_children[ll_index].Retrieve()
				ldwc_child[1]	= adwc_children[ll_index]
				ls_dataobject[1] = as_dropdowndatawindowname[ll_index]
				This.of_retrieveend(ldwc_child[], ls_dataobject[])
				ll_upperbound2 = Min(UpperBound(is_dataobject[]), UpperBound(is_data[]))	
				Exit
			End If
		Next
	
		Continue
	End If
	
	//-----------------------------------------------------------------------------------------------
	// Find the cached dropdown
	//-----------------------------------------------------------------------------------------------
	For ll_index2 = 1 To ll_upperbound2
		If as_dropdowndatawindowname[ll_index] = is_dataobject[ll_index2] Then
			//-----------------------------------------------------------------------------------------------
			// Import the data and refilter just in case
			//-----------------------------------------------------------------------------------------------
			adwc_children[ll_index].ImportString(is_data[ll_index2])
			adwc_children[ll_index].Filter()
			Exit
		End If
	Next
Next
end subroutine

on n_dropdowndatawindow_caching_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dropdowndatawindow_caching_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

