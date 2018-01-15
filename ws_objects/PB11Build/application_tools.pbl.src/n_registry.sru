$PBExportHeader$n_registry.sru
$PBExportComments$<doc>
forward
global type n_registry from nonvisualobject
end type
end forward

global type n_registry from nonvisualobject autoinstantiate
end type

forward prototypes
private function string of_get_valuename (string as_keystring)
public subroutine of_set_registry_key (string s_keystring, string s_data)
public function boolean of_set_system_value (string as_key, string as_value)
public function boolean of_set_user_value (string as_key, string as_value)
public subroutine of_delete_registry_key (string s_keystring)
public subroutine of_delete_system_registry_key (string s_keystring)
public subroutine of_delete_user_registry_key (string s_keystring)
private function string of_get_keystring (string as_keystring)
public function string of_get_registry_key (string s_keystring)
public subroutine of_get_registry_keys (string s_keystring, ref string s_keys[])
public function boolean of_get_registry_value_from_cache (string as_registryname, ref string as_registryvalue)
public subroutine of_get_registry_values (string s_keystring, ref string s_keys[], ref string s_values[])
public subroutine of_get_system_registry_keys (string s_keystring, ref string s_keys[])
public subroutine of_get_system_registry_values (string s_keystring, ref string s_keys[], ref string s_values[])
public function string of_get_system_value (string as_key)
public function string of_get_system_value (string as_key, string as_default)
public subroutine of_get_user_registry_keys (string s_keystring, ref string s_keys[])
public subroutine of_get_user_registry_values (string s_keystring, ref string s_keys[], ref string s_values[])
public function string of_get_user_value (string as_key)
public function string of_get_user_value (string as_key, string as_default)
public subroutine of_add_registry_value_to_cache (string as_registryname, string as_registryvalue)
public function string of_get_registry_key (string s_keystring, boolean ab_usecaching)
end prototypes

private function string of_get_valuename (string as_keystring);//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_registry_key, ls_registry_name, ls_registry_data
Long		ll_position

//-----------------------------------------------------------------------------------------------------------------------------------
// make sure the string is not null and trimmed and has a whack at the beginning
//-----------------------------------------------------------------------------------------------------------------------------------
If IsNull(as_keystring) Then as_keystring = ''
as_keystring = Trim(as_keystring)

If Left(as_keystring, 1) <> '\' Then
	as_keystring = '\' + as_keystring
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reverse the string and find the first whack
//-----------------------------------------------------------------------------------------------------------------------------------
ls_registry_key = Reverse(as_keystring)
ll_position = Pos(ls_registry_key, '\')

//-----------------------------------------------------------------------------------------------------------------------------------
// Cut the registry name out.  Cut the registry key out.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_registry_name 	= Left(ls_registry_key, ll_position - 1)
Return Reverse(ls_registry_name)
end function

public subroutine of_set_registry_key (string s_keystring, string s_data);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  s_keystring 	- 	This is the registry key string
//					s_data			-	This is the data to set into the registry entry
//	Overview:   This will set a registry value
//	Created by:	Joel White
//	History: 	4/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_registry_key, ls_registry_name, ls_registry_data
Long		ll_position

//-----------------------------------------------------------------------------------------------------------------------------------
// If this is a user setting, send it to the windows registry
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Left(Trim(s_keystring), 5)) = 'users' Or Lower(Left(Trim(s_keystring), 6)) = '\users' Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the key and the name
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_registry_key 	= of_get_keystring(s_keystring)
	ls_registry_name	= of_get_valuename(s_keystring)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the key into the Registry
	//-----------------------------------------------------------------------------------------------------------------------------------
	RegistrySet(ls_registry_key, ls_registry_name, RegString!, s_data)
Else
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Declare a procedure to set the registry value
	//-----------------------------------------------------------------------------------------------------------------------------------
	DECLARE lsp_setregistry PROCEDURE FOR sp_set_registry_value  
				@keystring = :s_keystring,   
				@keyvalue = :s_data ;
				
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Execute the procedure
	//-----------------------------------------------------------------------------------------------------------------------------------
	Execute lsp_setregistry;

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Close the stored procedure
	//-----------------------------------------------------------------------------------------------------------------------------------
	Close lsp_setregistry;
	
//	gn_globals.in_cache.of_refresh_cache("Registry")
End If
end subroutine

public function boolean of_set_system_value (string as_key, string as_value);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will set a system registry value</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string</Argument>
	<Argument Name="s_data">This is the data to set into the registry entry</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>4/6/2005</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_key
long l_currency

s_key = 'system\' + as_key
this.of_set_registry_key(s_key,as_value)

return true
end function

public function boolean of_set_user_value (string as_key, string as_value);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will set a user registry value</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string</Argument>
	<Argument Name="s_data">This is the data to set into the registry entry</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_key
long l_currency

s_key = 'users\' + string(gn_globals.is_login) + '\' + as_key
this.of_set_registry_key(s_key,as_value)

return true
end function

public subroutine of_delete_registry_key (string s_keystring);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  s_keystring 	- This is the registry key string to delete
//	Overview:   This will delete a registry key
//	Created by:	Joel White
//	History: 	4/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------



string	s_keys[]
string	s_values[]
string	s_void[]
string	s_key
long		l_pos
long		l_i
long		l_PrntID
long		l_RgstryID

//-----------------------------------------------------------------------------------------------------------------------------------
// If this is a user setting, send it to the windows registry
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Left(Trim(s_keystring), 5)) = 'users' Or Lower(Left(Trim(s_keystring), 6)) = '\users' Then
	RegistryDelete(s_keystring, '')
	RegistryDelete(of_get_keystring(s_keystring), of_get_valuename(s_keystring))
Else
	
	this.of_get_registry_keys(s_keystring, s_keys)
	
	l_i = 1
	do while l_i <= upperbound( s_keys)
		this.of_delete_registry_key( s_keystring + '\' + s_keys[l_i])
		l_i++
	loop
	
	s_keys = s_void
	
	this.of_get_registry_values( s_keystring, s_keys, s_values)
	
	l_i=1
	do while l_i <= upperbound( s_keys)
		this.of_delete_registry_key( s_keystring + '\' + s_keys[l_i])
		l_i++
	loop
	
	do while s_keystring > ''
	
		l_prntID = l_RgstryID
		
		l_pos = pos(s_keystring, '\')
	
		if l_pos = 0 then
			s_key = s_keystring
		else
			s_key = left( s_keystring, l_pos - 1)
		end if
		
//		if l_prntid = 0 then
//			select RgstryID into :l_RgstryID
//			from Registry
//			where RgstryKyNme = :s_key
//			and	RgstryID = RgstryPrntID;
//		else
//			select RgstryID into :l_RgstryID
//			from Registry
//			where RgstryKyNme = :s_key
//			and	RgstryPrntID = :l_PrntID;
//		end if
//		
		if SQLCA.SQLCODE <> 0 then RETURN
		
		if l_pos > 0 then
			s_keystring = mid( s_keystring, l_pos + 1, 9999)
		else
			s_keystring = ''
		end if
		
	loop
	
//	delete from Registry
//	where RgstryID = :l_RgstryID
//	and	RgstryPrntID = :l_PrntID;
//	
	commit;
End If
end subroutine

public subroutine of_delete_system_registry_key (string s_keystring);
s_keystring = 'system\' + s_keystring

this.of_delete_registry_key(s_keystring)

end subroutine

public subroutine of_delete_user_registry_key (string s_keystring);
s_keystring = 'users\' + gn_globals.is_login + '\' + s_keystring

this.of_delete_registry_key(s_keystring)

end subroutine

private function string of_get_keystring (string as_keystring);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	 of_get_keystring()
// Arguments:   as_keystring	- none
// Overview:    Return the registry key name by removing the registry key value
// Created by:  Joel White
// History:     04/07/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
String	ls_registry_key, ls_registry_name, ls_registry_data
Long		ll_position

//-----------------------------------------------------------------------------------------------------------------------------------
// Add a whack at the beginning
//-----------------------------------------------------------------------------------------------------------------------------------
as_keystring = Trim(as_keystring)
If Left(as_keystring, 1) <> '\' Then
	as_keystring = '\' + as_keystring
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Reverse the string after adding the prefix
//-----------------------------------------------------------------------------------------------------------------------------------
as_keystring = 'HKEY_CURRENT_USER\Software\CusFocus\' + as_keystring 
as_keystring = Reverse(as_keystring)

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the whack
//-----------------------------------------------------------------------------------------------------------------------------------
ll_position = Pos(as_keystring, '\')

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the key string
//-----------------------------------------------------------------------------------------------------------------------------------
Return Reverse(Mid(as_keystring, ll_position + 1, Len(as_keystring)))

end function

public function string of_get_registry_key (string s_keystring);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return a registry key</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Return This.of_get_registry_key(s_keystring, True)
end function

public subroutine of_get_registry_keys (string s_keystring, ref string s_keys[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  s_keystring 	- This is the registry key string
//					s_keys[]			- The array of keys by reference to be populated by the function
//	Overview:   This will return an array of registry keys
//	Created by:	Joel White
//	History: 	4/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string	s_key
long		l_pos
long		li_RgstryID
long		li_PrntID
long		l_i

//-----------------------------------------------------------------------------------------------------------------------------------
// If this is a user setting, send it to the windows registry
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Left(Trim(s_keystring), 5)) = 'users' Or Lower(Left(Trim(s_keystring), 6)) = '\users' Then

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add a whack at the beginning
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_keystring = Trim(s_keystring)
	If Left(s_keystring, 1) <> '\' Then
		s_keystring = '\' + s_keystring
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reverse the string after adding the prefix
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_keystring = 'HKEY_CURRENT_USER\Software\CusFocus' + s_keystring 
	s_keystring = Reverse(s_keystring)

	RegistryKeys(s_keystring, s_keys[])
Else
	do while s_keystring > ''
	
		l_pos = pos(s_keystring, '\')
		if l_pos > 0 then
			s_key = left( s_keystring, l_pos - 1)
		else
			s_key = s_keystring
		end if
	
//		if li_PrntID = 0 then
//			select RgstryID into :li_RgstryID
//			from	Registry
//			where	RgstryKyNme = :s_key
//			and	RgstryPrntID = RgstryID;
//		else
//			select rgstryid into :li_RgstryID
//			from	Registry
//			where	RgstryKyNme = :s_key
//			and	RgstryPrntID = :li_PrntID;
//		end if
//	
		if SQLCA.SQLCode <> 0 then
			return
		end if
	
		li_PrntID = li_RgstryID
	
		if l_pos > 0 then
			s_keystring = mid( s_keystring, l_pos + 1, 99999)
		else
			s_keystring = ''
		end if
	
	loop
	
//	declare	lcur_Registry cursor for
//	Select RgstryKyNme
//	from	Registry
//	where	RgstryPrntID = :li_PrntID;
////	and	((RgstryDtaVle = '') or (RgstryDtaVle is NULL));
//	
//	open lcur_Registry;
//	
//	Do while SQLCA.SQLCode = 0
//	
//		Fetch lcur_Registry
//		into	:s_key;
//		
//		if SQLCA.SQLCode = 0 then
//			l_i++
//			s_keys[l_i] = s_key
//		end if
//	
//	loop
//	
//	close lcur_Registry;
End If	

end subroutine

public function boolean of_get_registry_value_from_cache (string as_registryname, ref string as_registryvalue);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_registry_value()
//	Overview:   This will return the cached registry value
//	Created by:	Joel White
//	History: 	4/6/2005 - First Created
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_row
String	ls_findstring = ''
n_dao		ln_registry


If Not IsValid(gn_globals) Then Return False
//If Not IsValid(gn_globals.in_cache) Then Return False
//ln_registry = gn_globals.in_cache.of_get_cache_reference("Registry")
//-----------------------------------------------------------------------------------------------------------------------------------
// Return if there are no rows
//-----------------------------------------------------------------------------------------------------------------------------------
If Not IsValid(ln_registry) Then Return False
If ln_registry.RowCount() <= 0 Then Return False

//-----------------------------------------------------------------------------------------------------------------------------------
// Add the clause for the name
//-----------------------------------------------------------------------------------------------------------------------------------
ls_findstring = 'Lower(registryname) = "' + Lower(as_registryname) + '"'

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the row we need
//-----------------------------------------------------------------------------------------------------------------------------------
ll_row = ln_registry.Find(ls_findstring, 1, ln_registry.RowCount())

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the value if it's valid
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_row > 0 And Not IsNull(ll_row) And ll_row <= ln_registry.RowCount() Then
	as_registryvalue = ln_registry.GetItemString(ll_row, 'registryvalue')
	Return True
Else
	Return False
End If
end function

public subroutine of_get_registry_values (string s_keystring, ref string s_keys[], ref string s_values[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return an array of registry values based on the keys</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string</Argument>
	<Argument Name="s_keys[]">This argument is not used, it should be deleted from the function</Argument>
	<Argument Name="s_values[]">This argument the array of values by reference to be populated by this function</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>4/8/2005</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string	s_key
string	s_vle
long		l_pos
long		li_RgstryID
long		li_PrntID
long		l_i

//-----------------------------------------------------------------------------------------------------------------------------------
// If this is a user setting, send it to the windows registry
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Left(Trim(s_keystring), 5)) = 'users' Or Lower(Left(Trim(s_keystring), 6)) = '\users' Then

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Add a whack at the beginning
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_keystring = Trim(s_keystring)
	If Left(s_keystring, 1) <> '\' Then
		s_keystring = '\' + s_keystring
	End If
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Reverse the string after adding the prefix
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_keystring = 'HKEY_CURRENT_USER\Software\CustomerFocus\' + s_keystring 
	s_keystring = Reverse(s_keystring)

	RegistryValues(s_keystring, s_values[])
Else
	do while s_keystring > ''
	
		l_pos = pos(s_keystring, '\')
		if l_pos > 0 then
			s_key = left( s_keystring, l_pos - 1)
		else
			s_key = s_keystring
		end if
	
//		if li_PrntID = 0 then
//			select RgstryID into :li_RgstryID
//			from	Registry
//			where	RgstryKyNme = :s_key
//			and	RgstryPrntID = RgstryID;
//		else
//			select rgstryid into :li_RgstryID
//			from	Registry
//			where	RgstryKyNme = :s_key
//			and	RgstryPrntID = :li_PrntID;
//		end if
//	
//		if SQLCA.SQLCode <> 0 then
//			return
//		end if
//	
//		li_PrntID = li_RgstryID
//	
//		if l_pos > 0 then
//			s_keystring = mid( s_keystring, l_pos + 1, 99999)
//		else
//			s_keystring = ''
//		end if
//	
	loop
//	
//	declare	lcur_Registry cursor for
//	Select 	RgstryDtaVle
//	from		Registry
//	where		RgstryPrntID = :li_PrntID;
//	
//	open lcur_Registry;
//	
//	Do while SQLCA.SQLCode = 0
//	
//		Fetch lcur_Registry
//		into	:s_vle;
//		
//		if SQLCA.SQLCode = 0 then
//			l_i++
//			s_values[l_i] = s_vle
//		end if
//	
//	loop
//	
//	close lcur_Registry;
End If	

end subroutine

public subroutine of_get_system_registry_keys (string s_keystring, ref string s_keys[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return an array of system registry keys</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string to retrieve</Argument>
	<Argument Name="s_keys[]">The array of keys by reference to be populated by the function</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

s_keystring = 'system\' + s_keystring

this.of_get_registry_keys( s_keystring, s_keys)
end subroutine

public subroutine of_get_system_registry_values (string s_keystring, ref string s_keys[], ref string s_values[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return an array of system registry values based on the keys</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string</Argument>
	<Argument Name="s_keys[]">This argument is not used, it should be deleted from the function</Argument>
	<Argument Name="s_values[]">This argument the array of values by reference to be populated by this function</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

s_keystring = 'system\' + s_keystring

this.of_get_registry_values( s_keystring, s_keys, s_values)
end subroutine

public function string of_get_system_value (string as_key);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return a system registry value, system values are stored on the database</Description>
<Arguments>
	<Argument Name="as_key">This is the registry key string</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
string s_key
long l_currency


s_key = 'system\' + as_key
return of_get_registry_key(s_key)




end function

public function string of_get_system_value (string as_key, string as_default);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return a system registry value, if it does not exist, it will return the default</Description>
<Arguments>
	<Argument Name="as_key">This is the registry key string</Argument>
	<Argument Name="as_default">This is the default to return if not found</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_key
string s_value
long l_currency


s_key = 'system\' + as_key
s_value = of_get_registry_key(s_key)

if s_value = '' or IsNull(s_value) then 
	of_set_registry_key('system\' + as_key,as_default)
	return as_default
else 
	return of_get_registry_key(s_key)
end if







end function

public subroutine of_get_user_registry_keys (string s_keystring, ref string s_keys[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return an array of user registry keys</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string to retrieve</Argument>
	<Argument Name="s_keys[]">The array of keys by reference to be populated by the function</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>04/6/2005</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

s_keystring = 'users\' + string(gn_globals.is_login) + '\' + s_keystring

this.of_get_registry_keys( s_keystring, s_keys)
end subroutine

public subroutine of_get_user_registry_values (string s_keystring, ref string s_keys[], ref string s_values[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return an array of user registry values based on the keys</Description>
<Arguments>
	<Argument Name="s_keystring">This is the registry key string</Argument>
	<Argument Name="s_keys[]">This argument is not used, it should be deleted from the function</Argument>
	<Argument Name="s_values[]">This argument the array of values by reference to be populated by this function</Argument>
</Arguments>
<CreatedBy>Joel White</CreatedBy>
<Created>4/6/2005</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

s_keystring = 'users\' + gn_globals.is_login + '\' + s_keystring

this.of_get_registry_values( s_keystring, s_keys, s_values)
end subroutine

public function string of_get_user_value (string as_key);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return a user registry value</Description>
<Arguments>
	<Argument Name="as_key">This is the registry key string</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_key
long l_currency


s_key = 'users\' + string(gn_globals.is_login) + '\' + as_key
return of_get_registry_key(s_key)




end function

public function string of_get_user_value (string as_key, string as_default);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return a system registry value, if it does not exist, it will return the default</Description>
<Arguments>
	<Argument Name="as_key">This is the registry key string</Argument>
	<Argument Name="as_default">This is the default to return if not found</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/6/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string s_key
string s_value
long l_currency


s_key = 'users\' + string(gn_globals.is_login) + '\' + as_key
s_value = of_get_registry_key(s_key)

if s_value = '' or IsNull(s_value) then 
	of_set_registry_key('users\' + string(gn_globals.is_login) + '\' + as_key,as_default)
	return as_default
else
	return s_value
end if






end function

public subroutine of_add_registry_value_to_cache (string as_registryname, string as_registryvalue);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_registry_value()
//	Overview:   This will return the cached registry value
//	Created by:	Joel White
//	History: 	4/7/2005 - First Created
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long 		ll_row
n_dao		ln_registry

If Not IsValid(gn_globals) Then Return
//If Not IsValid(gn_globals.in_cache) Then Return

//ln_registry = gn_globals.in_cache.of_get_cache_reference("Registry")
If Not IsValid(ln_registry) Then Return
ll_row = ln_registry.InsertRow(0)
ln_registry.SetItem(ll_row, 'registryname', as_registryname)
ln_registry.SetItem(ll_row, 'registryvalue', as_registryvalue)
end subroutine

public function string of_get_registry_key (string s_keystring, boolean ab_usecaching);//----------------------------------------------------------------------------------------------------------------------------------
//	Arguments:  s_keystring 	- This is the registry key string
//					ab_usecaching	- This specifies whether or not you want to use registry caching for database system entries, the default is True
//	Overview:   This will return a registry key
//	Created by:	Joel White
//	History: 	4/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------



string 	s_data, s_key, s_keystring_orig
Boolean	lb_Found = False

String	ls_registry_key, ls_registry_name, ls_registry_data
Long		ll_position, l_pos, li_prntid, li_rgstryid


//-----------------------------------------------------------------------------------------------------------------------------------
// If this is a user setting, send it to the windows registry
//-----------------------------------------------------------------------------------------------------------------------------------
If Lower(Left(Trim(s_keystring), 5)) = 'users' Or Lower(Left(Trim(s_keystring), 6)) = '\users' Then
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Get the key and the name
	//-----------------------------------------------------------------------------------------------------------------------------------
	ls_registry_key 	= of_get_keystring(s_keystring)
	ls_registry_name	= of_get_valuename(s_keystring)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Set the key into the Registry
	//-----------------------------------------------------------------------------------------------------------------------------------
	RegistryGet(ls_registry_key, ls_registry_name, RegString!, s_data)
Else

	/// Request the Value from the Cache Service	
	If ab_usecaching Then
		lb_Found = of_get_registry_value_from_cache(s_keystring, s_data)
	End If

	If Not lb_Found Then
/*		DECLARE lsp_getregistry PROCEDURE FOR sp_get_registry_value  
					@keystring = :s_keystring,   
					@returnvalue = :s_data output;
					
		Execute lsp_getregistry;
		
		fetch lsp_getregistry into :s_data;
		
		Close lsp_getregistry;
*/
	s_keystring_orig = s_keystring
	do while s_keystring > ''
		
			l_pos = pos(s_keystring, '\')
			if l_pos > 0 then
				s_key = left( s_keystring, l_pos - 1)
			else
				s_key = s_keystring
			end if
		
//			if li_PrntID = 0 then
//				select RgstryID into :li_RgstryID
//				from	Registry (nolock)
//				where	RgstryKyNme = :s_key
//
//				and	RgstryPrntID = RgstryID;
//			else
//				select rgstryid into :li_RgstryID
//				from	Registry (nolock)
//				where	RgstryKyNme = :s_key
//				and	RgstryPrntID = :li_PrntID;
//			end if
//		
			if SQLCA.SQLCode < 0 then
				return ''
			end if
		
			li_PrntID = li_RgstryID
		
			if l_pos > 0 then
				s_keystring = mid( s_keystring, l_pos + 1, 99999)
			else
				s_keystring = ''
			end if
		
		loop

//		select RgstryDtaVle into :s_data
//			from	Registry (nolock)
//			WHERE	RgstryID = :li_PrntID;
		
		If ab_usecaching Then
			of_add_registry_value_to_cache(s_keystring_orig, s_data)
		End If
	End If
End If

if isnull(s_data) then
	s_data = ''
end if
return s_data

end function

on n_registry.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_registry.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Overrides:  No
//	Arguments:	
//	Overview:   This object will manage registry keys for you.  System keys are stored on the database because they
//					need to be available for all users.  User keys are stored in the Client Windows registry under 
//					HKEY_CURRENT_USER\Software\CusFocus\users\%username%.  System registry values are cached, 
//					so if it's absolutely critical that a system entry is the latest value, use the functions that allow you 
//					to specify whether caching is on or off.
//	Created by: Joel White
//	History:    4/11/2005 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------



end event

