$PBExportHeader$n_class_functions.sru
$PBExportComments$<doc> This object is used to inspect information about PowerBuilder Classes.
forward
global type n_class_functions from nonvisualobject
end type
end forward

global type n_class_functions from nonvisualobject autoinstantiate
end type

type variables

Private:
	string	is_valid_object[]
end variables

forward prototypes
public function boolean of_hasfunction (powerobject apo, string as_functionname, string as_arguments)
public function boolean of_isancestor (powerobject ao_object, string as_ancestor)
public function boolean of_isvalid (string as_classname)
end prototypes

public function boolean of_hasfunction (powerobject apo, string as_functionname, string as_arguments);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This function will return true or false based on if the passed in object supports the function specified</Description>
<Arguments>
	<Argument Name="apo">The object to query</Argument>
	<Argument Name="as_functionname">Function to search for</Argument>
	<Argument Name="as_arguments">Comma delimited list of arguements for the function</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/


classdefinition		lcd
scriptdefinition		lsd
string					ls_args[]
//n_string_functions	ln_string

if NOT isvalid( apo) then RETURN FALSE

gn_globals.in_string_functions.of_parse_string( as_arguments, ',', ls_args[])

lcd = apo.classdefinition

if isvalid(lcd) then
	lsd = lcd.FindMatchingFunction(as_functionname, ls_args[])
	if isvalid(lsd) then RETURN TRUE
end if


return FALSE
end function

public function boolean of_isancestor (powerobject ao_object, string as_ancestor);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This function returns true if ao_object is inherited from the class as_ancestor</Description>
<Arguments>
	<Argument Name="ao_object">Object to inspect</Argument>
	<Argument Name="as_ancestor">Name of the ancestor object</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

classdefinition		lcd_object

if NOT isvalid( ao_object) then RETURN FALSE

lcd_object = ao_object.classdefinition

Do while isvalid(lcd_object)
	
	if lower(lcd_object.name) = lower(as_ancestor) then 
		return true
	else
		lcd_object = lcd_object.ancestor
	end if

loop


return FALSE
end function

public function boolean of_isvalid (string as_classname);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This function returns true if the object exists in the library list</Description>
<Arguments>
	<Argument Name="as_classname">Class name of the object to find</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>5/30/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

classdefinition	lcd
long					ll_i, ll_objects

as_classname = lower(as_classname)

ll_objects = upperbound( is_valid_object[])

for ll_i = 1 to ll_objects
	if is_valid_object[ll_i] = as_classname then
		return TRUE
	end if
next

lcd = FindClassDefinition(as_classname)

if isvalid( lcd) then
	is_valid_object[ll_objects + 1] = as_classname
	return TRUE
end if

return FALSE
end function

on n_class_functions.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_class_functions.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This object contains functions that allow the developer to query for information about a class including 
if the object is in the library path, inherits from and ancestor or has a specific function.
</Abstract>----------------------------------------------------------------------------------------------------*/



end event

