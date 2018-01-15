$PBExportHeader$n_menu_dynamic.sru
$PBExportComments$<doc>
forward
global type n_menu_dynamic from nonvisualobject
end type
end forward

global type n_menu_dynamic from nonvisualobject
end type
global n_menu_dynamic n_menu_dynamic

type variables
Public 	Boolean	Checked 	= False
Public 	Boolean	Default	= False
Public 	Boolean	Enabled	= True
Public 	Boolean	Visible	= True
Public 	String	Tag

Public ProtectedWrite	n_menu_dynamic Item[]
Public ProtectedWrite	Any				Data
Public ProtectedWrite	String			MessageName
Public ProtectedWrite	String			Text
Public ProtectedWrite	PowerObject		MessageTarget
Public ProtectedWrite	String			MessageTargetName
Public ProtectedWrite	Boolean			HasChildren

Protected:
	String	is_appending_options[]
end variables

forward prototypes
public subroutine disable ()
public subroutine enable ()
public subroutine hide ()
public subroutine show ()
public subroutine uncheck ()
public function n_menu_dynamic of_add_item (string as_text, string as_message, any aany_argument, powerobject ao_message_target)
public function n_menu_dynamic of_insert_item (long al_position, string as_text, string as_message, any aany_argument)
public function n_menu_dynamic of_insert_item (long al_position, string as_text, string as_message, any aany_argument, powerobject ao_message_target)
public function boolean of_isappending (string as_type)
public subroutine of_set_message (string as_message, any aany_argument)
public subroutine of_set_target (powerobject ao_target)
public subroutine of_set_text (string as_text)
public function n_menu_dynamic of_add_item (string as_text, string as_message, any aany_argument)
public subroutine of_append_menu (n_menu_dynamic an_menu_dynamic)
public subroutine of_append_options (string as_type)
public function n_menu_dynamic of_find_menu (string as_menutext)
public subroutine check ()
public subroutine of_set_target_name (string as_target_name)
public function string of_get_xml ()
end prototypes

public subroutine disable ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will disable the menu item</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Enabled = False
end subroutine

public subroutine enable ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will enable the menu item</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Enabled = True
end subroutine

public subroutine hide ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will hide the menu item</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Enabled = False
end subroutine

public subroutine show ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will show the menu item</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Visible = True
end subroutine

public subroutine uncheck ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will uncheck the menu item</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Checked = False
end subroutine

public function n_menu_dynamic of_add_item (string as_text, string as_message, any aany_argument, powerobject ao_message_target);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will add an item to the menu</Description>
<Arguments>
	<Argument Name="as_text">The text to show on the menu item</Argument>
	<Argument Name="as_message">The message to publish when selected</Argument>
	<Argument Name="aany_argument">The argument to send with the published message when selected</Argument>
	<Argument Name="ao_message_target">The object that will recieve the message</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Return This.of_insert_item(UpperBound(Item[]) + 1, as_text, as_message, aany_argument, ao_message_target)
end function

public function n_menu_dynamic of_insert_item (long al_position, string as_text, string as_message, any aany_argument);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will insert an item into the menu before a specified position, rather than the end of the menu like of_add_item().</Description>
<Arguments>
	<Argument Name="al_position">The position of the new item, others will be shifted down</Argument>
	<Argument Name="as_text">The text to show on the menu item</Argument>
	<Argument Name="as_message">The message to publish when selected</Argument>
	<Argument Name="aany_argument">The argument to send with the published message when selected</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Return This.of_insert_item(al_position, as_text, as_message, aany_argument, MessageTarget)

end function

public function n_menu_dynamic of_insert_item (long al_position, string as_text, string as_message, any aany_argument, powerobject ao_message_target);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will insert an item into the menu before a specified position, rather than the end of the menu like of_add_item().</Description>
<Arguments>
	<Argument Name="al_position">The position of the new item, others will be shifted down</Argument>
	<Argument Name="as_text">The text to show on the menu item</Argument>
	<Argument Name="as_message">The message to publish when selected</Argument>
	<Argument Name="aany_argument">The argument to send with the published message when selected</Argument>
	<Argument Name="ao_message_target">The object that will recieve the message</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long	ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
n_menu_dynamic ln_menu_dynamic_children[]
n_menu_dynamic ln_menu_dynamic_empty[]
n_menu_dynamic ln_menu_dynamic

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the position for the item, correcting for the upperbound
//-----------------------------------------------------------------------------------------------------------------------------------
al_position = Min(al_position, UpperBound(Item[]) + 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the position is one, set the target instance for defaulting later
//-----------------------------------------------------------------------------------------------------------------------------------
If al_position = 1 Then This.of_set_target(ao_message_target)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the menu and set the variables
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic = Create n_menu_dynamic
ln_menu_dynamic.of_set_text(as_text)
ln_menu_dynamic.of_set_message(as_message, aany_argument)
ln_menu_dynamic.of_set_target(ao_message_target)
If IsValid(ao_message_target) And Not IsValid(MessageTarget) Then
	MessageTarget = ao_message_target
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Fill the array up to the point of insertion
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = 1 To al_position - 1
	ln_menu_dynamic_children[ll_index] = Item[ll_index]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the new item into the array
//-----------------------------------------------------------------------------------------------------------------------------------
ln_menu_dynamic_children[al_position] = ln_menu_dynamic

//-----------------------------------------------------------------------------------------------------------------------------------
// Fill the rest of the array
//-----------------------------------------------------------------------------------------------------------------------------------
For ll_index = al_position + 1 To UpperBound(Item[]) + 1		//KCS Added the +1 on the upper bound to prevent dropping the last entry.
	ln_menu_dynamic_children[ll_index] = Item[ll_index - 1]
Next

//-----------------------------------------------------------------------------------------------------------------------------------
// Set that this now has children
//-----------------------------------------------------------------------------------------------------------------------------------
HasChildren	= True

//-----------------------------------------------------------------------------------------------------------------------------------
// Clear the array and set the new array into it
//-----------------------------------------------------------------------------------------------------------------------------------
Item[] = ln_menu_dynamic_empty
Item[] = ln_menu_dynamic_children[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Set whether or not the item is visible
//-----------------------------------------------------------------------------------------------------------------------------------
This.Visible = as_text <> '-' Or UpperBound(Item[]) > 1

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the new item
//-----------------------------------------------------------------------------------------------------------------------------------
Return ln_menu_dynamic
end function

public function boolean of_isappending (string as_type);Long	ll_index

For ll_index = 1 To UpperBound(is_appending_options[])
	If Lower(Trim(is_appending_options[ll_index])) = Lower(Trim(as_type)) Then Return True
Next

Return False
end function

public subroutine of_set_message (string as_message, any aany_argument);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will set the message and argument for this single item</Description>
<Arguments>
	<Argument Name="as_message">The message to publish</Argument>
	<Argument Name="aany_argument">The argument to send with the published message</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

MessageName	= as_message
Data 			= aany_argument
end subroutine

public subroutine of_set_target (powerobject ao_target);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will set the default target for this menu item and all children menu items</Description>
<Arguments>
	<Argument Name="ao_target">The target object</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

MessageTarget = ao_target
end subroutine

public subroutine of_set_text (string as_text);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will set the text for this menu item</Description>
<Arguments>
	<Argument Name="as_text">The text to show on the menu item</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Text = as_text
end subroutine

public function n_menu_dynamic of_add_item (string as_text, string as_message, any aany_argument);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will add an item to the menu</Description>
<Arguments>
	<Argument Name="as_text">The text to show on the menu item</Argument>
	<Argument Name="as_message">The message to publish when selected</Argument>
	<Argument Name="aany_argument">The argument to send with the published message when selected</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Return This.of_add_item(as_text, as_message, aany_argument, MessageTarget)
end function

public subroutine of_append_menu (n_menu_dynamic an_menu_dynamic);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will append a menu to this menu</Description>
<Arguments>
	<Argument Name="an_menu_dynamic">The menu to append</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Item[UpperBound(Item[]) + 1] = an_menu_dynamic
end subroutine

public subroutine of_append_options (string as_type);is_appending_options[UpperBound(is_appending_options[]) + 1] = as_type
end subroutine

public function n_menu_dynamic of_find_menu (string as_menutext);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will find a menu item based on the text passed in, this is not case sensitive</Description>
<Arguments>
	<Argument Name="as_menutext">The menu text to search for</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Long	ll_index
n_menu_dynamic ln_menu_dynamic

For ll_index = 1 To UpperBound(Item[])
	If Lower(Trim(Item[ll_index].Text)) = Lower(Trim(as_menutext)) Then
		Return Item[ll_index]
	End If
	
	If Item[ll_index].HasChildren Then
		ln_menu_dynamic = Item[ll_index].of_find_menu(as_menutext)
		If IsValid(ln_menu_dynamic) Then Return ln_menu_dynamic
	End If
Next

Return ln_menu_dynamic
end function

public subroutine check ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will check the menu item</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

Checked = True
end subroutine

public subroutine of_set_target_name (string as_target_name);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will set the target name for this menu.  This is only used to put a target on XML menus.</Description>
<Arguments>
	<Argument Name="as_target_name">The target object name</Argument>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

MessageTargetName = as_target_name
end subroutine

public function string of_get_xml ();/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>This will return an xml version of the menu.  This is used for the reporting API (Web Reporting)</Description>
<Arguments>
</Arguments>
<CreatedBy>Blake Doerr</CreatedBy>
<Created>10/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Objects
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string_functions

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long		ll_index
String	ls_xml_document
String	ls_text
String	ls_message
String	ls_data

//-----------------------------------------------------------------------------------------------------------------------------------
// Begin the xml node
//-----------------------------------------------------------------------------------------------------------------------------------
ls_xml_document = '<MenuItem'

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the visible attribute
//-----------------------------------------------------------------------------------------------------------------------------------
ls_xml_document = ls_xml_document + ' Visible="'

If Visible Then
	ls_xml_document = ls_xml_document + 'Y'

Else
	ls_xml_document = ls_xml_document + 'N'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the enabled attribute
//-----------------------------------------------------------------------------------------------------------------------------------
ls_xml_document = ls_xml_document + '" Enabled="'

If Enabled Then
	ls_xml_document = ls_xml_document + 'Y'
Else
	ls_xml_document = ls_xml_document + 'N'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the menu text attribute
//-----------------------------------------------------------------------------------------------------------------------------------
ls_text		= Text
gn_globals.in_string_functions.of_replace_all(ls_text, '&', '!@#$%')
gn_globals.in_string_functions.of_replace_all(ls_text, '!@#$%', '&amp;')
gn_globals.in_string_functions.of_replace_all(ls_text, '"', '&quot;')

ls_xml_document = ls_xml_document + '" Text="' + ls_text


//-----------------------------------------------------------------------------------------------------------------------------------
// If there are not children, we need to set the other attributes
//-----------------------------------------------------------------------------------------------------------------------------------
If UpperBound(Item[]) = 0 Then
	ls_xml_document = ls_xml_document + '" Default="'

	If Default Then
		ls_xml_document = ls_xml_document + 'Y'
	Else
		ls_xml_document = ls_xml_document + 'N'
	End If
	
	ls_xml_document = ls_xml_document + '" Checked="'
	
	If Checked Then
		ls_xml_document = ls_xml_document + 'Y'
	Else
		ls_xml_document = ls_xml_document + 'N'
	End If

	ls_message	= MessageName

	gn_globals.in_string_functions.of_replace_all(ls_message, '&', '!@#$%')
	gn_globals.in_string_functions.of_replace_all(ls_message, '!@#$%', '&amp;')
	gn_globals.in_string_functions.of_replace_all(ls_message, '"', '&quot;')
	
	If MessageTargetName <> '' Or Not IsValid(MessageTarget) Then
		ls_xml_document = ls_xml_document + '" TargetObject="' + MessageTargetName
	Else
		ls_xml_document = ls_xml_document + '" TargetObject="' + ClassName(MessageTarget)
	End If

	ls_xml_document = ls_xml_document + '" Message="' + ls_message + '"'
	
	If Lower(ClassName(Data)) = 'string' Then
		ls_data = String(Data)
		
		gn_globals.in_string_functions.of_replace_all(ls_data, '&', '!@#$%')
		gn_globals.in_string_functions.of_replace_all(ls_data, '!@#$%', '&amp;')
		gn_globals.in_string_functions.of_replace_all(ls_data, '"', '&quot;')
		
		ls_xml_document = ls_xml_document + ' MenuArgument="' + ls_data + '"'
	End If
	
	ls_xml_document = ls_xml_document + '/>'
Else
	If Trim(Text) <> "" Then
		ls_xml_document = ls_xml_document + '">'
	Else
		ls_xml_document = ""
	End If
	
	For ll_index = 1 To UpperBound(Item[])
		If Not IsValid(Item[ll_index]) Then Continue
		
		ls_xml_document = ls_xml_document + '~r~n' + Item[ll_index].of_get_xml()
	Next
	
	If Trim(Text) <> "" Then
		ls_xml_document = ls_xml_document + '~r~n</MenuItem>'
	End If
End If


Return ls_xml_document 
end function

on n_menu_dynamic.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_menu_dynamic.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;Long	ll_index

For ll_index = UpperBound(Item[]) To 1 Step -1
	If IsValid(Item[ll_index]) Then Destroy Item[ll_index]
Next
end event

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This is a nonvisual menu object.  You can use this object to build menus and then set them onto the m_dynamic graphic object in order to display them.  This allows you to either store a menu definition in memory or easily pass the menu object around to be added to.  There are also functions to allow you to find menu items and modify them (disable unwanted menu items, for example).
</Abstract>----------------------------------------------------------------------------------------------------*/



end event

