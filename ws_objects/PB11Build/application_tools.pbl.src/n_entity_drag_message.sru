$PBExportHeader$n_entity_drag_message.sru
$PBExportComments$This is an object that can hold entity names and their unique key values.  Can be used for a drag drop message.
forward
global type n_entity_drag_message from nonvisualobject
end type
end forward

global type n_entity_drag_message from nonvisualobject autoinstantiate
end type

type variables
String 	is_drag_entity
String	is_key[]
String	is_entity_data
String	is_Action
String	is_DestinationEntity
Long		il_DestinationReportConfigID
end variables

forward prototypes
public function string of_get_entity ()
public subroutine of_set_entity (string as_entity)
public subroutine of_get_keys (ref string as_keys[])
public subroutine of_set_data (string as_entity_data)
public function string of_get_data ()
public subroutine of_set_destination_entity (string as_entity)
public subroutine of_set_destination_reportconfigid (long al_reportconfigid)
public subroutine of_set_action (string as_action)
public function string of_get_action ()
public function long of_get_destination_reportconfigid ()
public subroutine of_get_keys (string as_keyname, ref string as_key[])
public function string of_get_destination_entity ()
public subroutine of_add_item (string as_string)
end prototypes

public function string of_get_entity ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_entity()
// Overview:    Return the entity name
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_drag_entity
end function

public subroutine of_set_entity (string as_entity);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_entity()
// Arguments:   as_entity - The entity name you want to set
// Overview:    This will set the entity name
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_drag_entity = as_entity
end subroutine

public subroutine of_get_keys (ref string as_keys[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_keys()
// Overview:    Return the array of keys
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

as_keys[] = is_key[]
end subroutine

public subroutine of_set_data (string as_entity_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_data()
// Arguments:   as_entity_data - The entity data you want to set
// Overview:    This will set the entity data
// Created by:  Blake Doerr
// History:     5/25/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_entity_data = as_entity_data
end subroutine

public function string of_get_data ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_data()
// Overview:    This will get the entity data
// Created by:  Blake Doerr
// History:     5/25/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_entity_data
end function

public subroutine of_set_destination_entity (string as_entity);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_destination_entity()
// Arguments:   as_entity - The entity name you want to go to
// Overview:    This will set the entity name
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_DestinationEntity = as_entity
end subroutine

public subroutine of_set_destination_reportconfigid (long al_reportconfigid);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_destination_reportconfigid()
// Arguments:   al_reportconfigid - The destination report config id
// Overview:    This will set the entity name
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

il_DestinationReportConfigID = al_reportconfigid
end subroutine

public subroutine of_set_action (string as_action);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_set_action()
// Arguments:   as_action - The action name you want to set
// Overview:    This will set the entity name
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

is_Action = as_action
end subroutine

public function string of_get_action ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_action()
// Overview:    Returns the action
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_Action
end function

public function long of_get_destination_reportconfigid ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_destination_reportconfigid()
// Overview:    Returns the report config id
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return il_DestinationReportConfigID
end function

public subroutine of_get_keys (string as_keyname, ref string as_key[]);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_get_keys()
//	Arguments:  as_keyname 	- The name of the key column for which you want an array of values
//					as_key[] - The array of key values for the specified keycolumn
//	Overview:   This function fills the provided array as_key with the values of the key column
//					specified in as_keyname
//	Created by:	Scott Creed
//	History: 	04.26.2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long						ll_i, ll_j
string					ls_arg[], ls_key[]
string					ls_empty[]
//n_string_functions	ln_string

as_keyname = lower(as_keyname)

for ll_i = 1 to upperbound( is_key[])
	
	ls_arg[] = ls_empty[]
	
	gn_globals.in_string_functions.of_parse_string( is_key[ll_i], "||", ls_arg[])
	
	for ll_j = 1 to upperbound( ls_arg[])
		
		ls_key = ls_empty[]
		
		gn_globals.in_string_functions.of_parse_string( ls_arg[ll_j], "=", ls_key[])
		
		if upperbound(ls_key) < 2 then continue
		
		if lower(trim(ls_key[1])) = as_keyname then
			as_key[upperbound(as_key[]) + 1] = ls_key[2]
		end if
		
	next
	
next

return
end subroutine

public function string of_get_destination_entity ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_get_entity()
// Overview:    Return the entity name
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return is_DestinationEntity
end function

public subroutine of_add_item (string as_string);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_add_item()
// Arguments:   as_string - This will add an item to the array
// Overview:    This will add an item to the array
// Created by:  Blake Doerr
// History:     6/5/99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//n_string_functions ln_string_functions
String	ls_values[]
String	ls_null
SetNull(ls_null)
Long	ll_index

If Len(Trim(gn_globals.in_string_functions.of_find_argument(as_string, '||', 'Entity'))) > 0 Then
	This.of_set_entity(gn_globals.in_string_functions.of_find_argument(as_string, '||', 'Entity'))
	gn_globals.in_string_functions.of_replace_argument('Entity', as_string, '||', ls_null)
End If

If Pos(as_string, '||') > 0 Then
	gn_globals.in_string_functions.of_parse_string(as_string, '||', ls_values[])
	
	For ll_index = 1 To UpperBound(ls_values[])
		This.of_add_item(ls_values[ll_index])
	Next
Else
	is_key[UpperBound(is_key) + 1] = as_string
End If
end subroutine

on n_entity_drag_message.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_entity_drag_message.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

