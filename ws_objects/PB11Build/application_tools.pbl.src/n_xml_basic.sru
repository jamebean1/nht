$PBExportHeader$n_xml_basic.sru
forward
global type n_xml_basic from nonvisualobject
end type
end forward

global type n_xml_basic from nonvisualobject
end type
global n_xml_basic n_xml_basic

type variables
PUBLIC PrivateWrite string  xml
PUBLIC PrivateWrite string  text
Public PrivateWrite n_xml_basic in_xml[]
end variables

forward prototypes
public function boolean replacenode (string as_key, string value)
public subroutine of_reset ()
public function string of_replace_returns (string as_string)
public function n_xml_basic selectnodes (string as_key)
public function n_xml_basic selectsinglenode (string as_key)
public subroutine loadxml (string as_document)
public function string getnextkey (string as_lastkey)
end prototypes

public function boolean replacenode (string as_key, string value);long l_pos,l_pos2
string s_find,s_return,s_endfind,s_xmltemp,s_xmlnew

//-----------------------------------------------------------------------------------------------------------------------------------
// Generate the Start Tag they are looking for
//-----------------------------------------------------------------------------------------------------------------------------------
s_find = '<' + as_key + '>'


//-----------------------------------------------------------------------------------------------------------------------------------
// Find it's position
//-----------------------------------------------------------------------------------------------------------------------------------
l_pos = pos (xml,s_find)

//-----------------------------------------------------------------------------------------------------------------------------------
// If it is empty then return error/ Else compute the start character for the item.
//-----------------------------------------------------------------------------------------------------------------------------------
if l_pos = 0 then 

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Generate the Start Tag they are looking for
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_find = '<' + as_key + '/>'
	l_pos = pos (xml,s_find)
	
	if l_pos = 0 then 
		return false
	end if 
	
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// This is they tag for the endpoint
//-----------------------------------------------------------------------------------------------------------------------------------
s_endfind = '</' + as_key + '>'

//-----------------------------------------------------------------------------------------------------------------------------------
// If it is empty then look for the next tag.  Everything between these points are the value
//-----------------------------------------------------------------------------------------------------------------------------------

l_pos2 = pos (xml,s_endfind,l_pos + len(s_find) - 1)

If l_pos2 = 0 then 
	l_pos2 = pos(xml,'<',l_pos)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If it is still empty then this must be the last value in the string
	//-----------------------------------------------------------------------------------------------------------------------------------
	if l_pos2 = 0 then l_pos2 = len(xml)
	s_endfind = ''
	
End If

l_pos2 = l_pos2 + len (s_endfind)


s_xmlnew = s_find + value + s_endfind

xml = replace(xml,l_pos,l_pos2 - l_pos,s_xmlnew)


return true
end function

public subroutine of_reset ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	FunctionName()
//	Arguments:  None.
//	Overview:   Reset the object.
//	Created by:	Denton Newham
//	History: 	07/13/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
n_xml_basic ln_null[]

//-----------------------------------------------------------------------------------------------------------------------------------
// Reset the instance variables.
//-----------------------------------------------------------------------------------------------------------------------------------
xml 		= ''
text 		= ''
in_xml[] = ln_null[]
end subroutine

public function string of_replace_returns (string as_string);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_replace_returns()
//	Arguments:  as_string - the string to process.
//	Overview:   Replaces any return characters or tab characters with empty quotes.
//	Created by:	Kristin Ferrier
//	History: 	02/12/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string
string ls_value

long l_pos_r, l_pos_t

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is no CR's or TC's just return.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = string(trim(as_string))

l_pos_r = pos(ls_value,'~r~n')
l_pos_t = pos(ls_value,'~t')

if l_pos_r = 0 and l_pos_t = 0 then return ls_value

//-----------------------------------------------------------------------------------------------------------------------------------
// Replace CR's and TC's with empty quotes
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.oF_replace_all(ls_value,'~r~n','')
gn_globals.in_string_functions.oF_replace_all(ls_value,'~t','')

return ls_value

end function

public function n_xml_basic selectnodes (string as_key);long l_pos,l_pos2,ll_count
string s_find,s_return,s_endfind
string ls_xml
boolean b_done
n_xml_basic ln_node


ls_xml  = xml

ln_node = create n_xml_basic	
ln_node.loadxml(ls_xml)

do while not b_done
	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Generate the Start Tag they are looking for
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_find = '<' + as_key + '>'
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// Find it's position
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_pos = pos (ls_xml,s_find)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If it is empty then return error/ Else compute the start character for the item.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if l_pos = 0 then 
	
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Generate the Start Tag they are looking for
		//-----------------------------------------------------------------------------------------------------------------------------------
		s_find = '<' + as_key + '/>'
		l_pos = pos (ls_xml,s_find)
		
		if l_pos = 0 then 
			b_done = true
			continue
		end if 
		
	end if
	l_pos = l_pos + len(s_find)
	
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// This is they tag for the endpoint
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_endfind = '</' + as_key + '>'
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If it is empty then look for the next tag.  Everything between these points are the value
	//-----------------------------------------------------------------------------------------------------------------------------------
	
	l_pos2 = pos (ls_xml,s_endfind,l_pos)
	
	If l_pos2 = 0 then 
		l_pos2 = pos(ls_xml,'<',l_pos)
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// If it is still empty then this must be the last value in the string
		//-----------------------------------------------------------------------------------------------------------------------------------
		if l_pos2 = 0 then l_pos2 = len(ls_xml)
		s_endfind = ''
		
	End If

	string s_xmltemp
	ll_count ++
	s_return = trim(mid(ls_xml,l_pos,l_pos2 - l_pos))
	if s_return <> '' then 
		s_xmltemp = s_find + s_return + s_endfind
	else 
		s_xmltemp = ''
	end if
	
	ln_node.in_xml[ll_count] = create n_xml_basic
	ln_node.in_xml[ll_count].loadxml(s_find + s_return + s_endfind)
	ln_node.in_xml[ll_count].text = trim(s_return)
	
	ls_xml = replace (ls_xml,1,l_pos2 + len(s_endfind) - 1,'')

Loop



return ln_node 
end function

public function n_xml_basic selectsinglenode (string as_key);long l_pos,l_pos2
string s_find,s_return,s_endfind,s_xmltemp
n_xml_basic ln_node
//-----------------------------------------------------------------------------------------------------------------------------------
// Generate the Start Tag they are looking for
//-----------------------------------------------------------------------------------------------------------------------------------
s_find = '<' + as_key + '>'

ln_node = create n_xml_basic
ln_node.in_xml[1] = create n_xml_basic


//-----------------------------------------------------------------------------------------------------------------------------------
// Find it's position
//-----------------------------------------------------------------------------------------------------------------------------------
l_pos = pos (xml,s_find)

//-----------------------------------------------------------------------------------------------------------------------------------
// If it is empty then return error/ Else compute the start character for the item.
//-----------------------------------------------------------------------------------------------------------------------------------
if l_pos = 0 then 

	//-----------------------------------------------------------------------------------------------------------------------------------
	// Generate the Start Tag they are looking for
	//-----------------------------------------------------------------------------------------------------------------------------------
	s_find = '<' + as_key + '/>'
	l_pos = pos (xml,s_find)
	
	if l_pos = 0 then 
		return ln_node
	end if 
	
end if
l_pos = l_pos + len(s_find)

//-----------------------------------------------------------------------------------------------------------------------------------
// This is they tag for the endpoint
//-----------------------------------------------------------------------------------------------------------------------------------
s_endfind = '</' + as_key + '>'

//-----------------------------------------------------------------------------------------------------------------------------------
// If it is empty then look for the next tag.  Everything between these points are the value
//-----------------------------------------------------------------------------------------------------------------------------------

l_pos2 = pos (xml,s_endfind,l_pos)

If l_pos2 = 0 then 
	l_pos2 = pos(xml,'<',l_pos)
	
	//-----------------------------------------------------------------------------------------------------------------------------------
	// If it is still empty then this must be the last value in the string
	//-----------------------------------------------------------------------------------------------------------------------------------
	if l_pos2 = 0 then l_pos2 = len(xml)
	s_endfind = ''
	
End If



s_return =mid(xml,l_pos,l_pos2 - l_pos)
if s_return <> '' then 
	s_xmltemp = s_find + s_return + s_endfind
else 
	s_xmltemp = ''
end if

ln_node.loadxml(s_xmltemp)
ln_node.text =  trim(this.of_replace_returns(s_return))
ln_node.in_xml[1].loadxml(s_xmltemp)
ln_node.in_xml[1].text = trim(s_return)



return ln_node 
end function

public subroutine loadxml (string as_document);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      loadxml
//	Overrides:  No
//	Arguments:	
//	Overview:   Load the XML Doc into the object
//	Created by: Jake Pratt
//	History:    12.27.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
//n_string_functions ln_string


xml = as_document



end subroutine

public function string getnextkey (string as_lastkey);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	getnextkey()
//	Arguments:  as_lastkey - The qualifier for last key gotten.
//	Overview:   Get the qualifier for the next node.
//	Created by:	Denton Newham
//	History: 	07/13/2001 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Declarations.
//-----------------------------------------------------------------------------------------------------------------------------------
String 	ls_key, ls_find, ls_null
Long		ll_pos, ll_start, ll_tagstart, ll_tagend

SetNull(ls_null)

//-----------------------------------------------------------------------------------------------------------------------------------
// Create the End Tag for the last key.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_find = '</' + as_lastkey + '>'

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the end of the last key.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_pos = Pos(text, ls_find)

//-----------------------------------------------------------------------------------------------------------------------------------
// If the last key isn't found, then assume we need to start from the beginning.
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_pos = 0 Then 
	ll_start = 1
Else
	ll_start = ll_pos + Len(ls_find)
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the find to the beginning of the next tag.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_find = '<'

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the beginning of the next tag in the document.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_pos = Pos(text, ls_find, ll_start)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we don't find another tag, return a null.
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_pos = 0 Or Mid(text, ll_pos + 1, 1) = '/' Then Return ls_null
ll_tagstart = ll_pos

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the find to the end of the tag.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_find = '>'

//-----------------------------------------------------------------------------------------------------------------------------------
// Find the end of the next tag in the document.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_pos = Pos(text, ls_find, ll_pos)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we don't find the end of the tag, return a null.
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_pos = 0 Then Return ls_null
ll_tagend = ll_pos

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the key.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_key = Mid(text, ll_tagstart + 1, ll_tagend - ll_tagstart - 1)

//-----------------------------------------------------------------------------------------------------------------------------------
// Return the key.
//-----------------------------------------------------------------------------------------------------------------------------------
Return ls_key

end function

on n_xml_basic.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xml_basic.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      destructor
//	Overrides:  No
//	Arguments:	
//	Overview:   destroy any node objects created on this node.
//	Created by: Jake Pratt
//	History:    12.30.1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long i_i
for i_i = 1 to upperbound(in_xml)
	if isvalid(in_xml[i_i]) then 
		destroy in_xml[i_i]
	end if
next
end event

