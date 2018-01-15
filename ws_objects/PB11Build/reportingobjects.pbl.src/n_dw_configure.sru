$PBExportHeader$n_dw_configure.sru
forward
global type n_dw_configure from nonvisualobject
end type
end forward

global type n_dw_configure from nonvisualobject
end type
global n_dw_configure n_dw_configure

forward prototypes
public subroutine of_apply_dw_changes (datawindow adw_data, string as_changes)
public function string of_get_dw_changes (datawindow adw_data, string as_qualifier)
public function boolean of_add_attributecolumn (datawindow adw_object, string as_qualifier, string as_attrname)
end prototypes

public subroutine of_apply_dw_changes (datawindow adw_data, string as_changes);string as_values[]
long i_i
//n_string_functions ln_string_functions
string s_value_name,s_value_attribute, s_value_value,s_syntax,s_table

gn_globals.in_string_functions.of_parse_string ( as_changes, ",", as_values[])

// Check the Labels for differences
for i_i = 1 to upperbound(as_values)

	s_value_name = trim(left(as_values[i_i],pos(as_values[i_i],'.') - 1))
	s_value_attribute  = trim(mid(as_values[i_i],pos(as_values[i_i],'.') + 1,pos(as_values[i_i],'=') - pos(as_values[i_i],'.') - 1))
	s_value_value  = trim(mid(as_values[i_i],pos(as_values[i_i],'=') + 1,len(as_values[i_i]) - pos(as_values[i_i],'=')))

	if lower( s_value_name)  = 'table' then 
		s_table = s_value_value
	end if

	if lower(right(s_value_name,9)) = 'attribute' and lower(s_value_attribute) = 'visible' then 
		of_add_attributecolumn(adw_data,s_table,left(s_value_name,len(s_value_name) - 9))
	end if

	if s_value_name  = 'Datawindow' then 
		adw_data.modify("DataWindow.Detail.Height='" + s_value_value + "'")
	else
		s_syntax = s_value_name + "." + s_value_attribute +" = '" + s_value_value  + "'"
		s_syntax = adw_data.modify(s_syntax)
	end if
	
	
next

	

return
end subroutine

public function string of_get_dw_changes (datawindow adw_data, string as_qualifier);datastore ldw_datastore
long i_i,l_row,l_max_y
string s_original,s_value
string ls_columnname[],ls_headername[],ls_headertext[],ls_columntype[],s_syntax,ls_null[]
n_datawindow_tools ln_datawindow_tools
string s_syntaxchanges

ldw_datastore = create datastore
ldw_datastore.dataobject = adw_data.dataobject


ln_datawindow_tools = create n_datawindow_tools
ln_datawindow_tools.of_get_columns(adw_data,ls_columnname,ls_headername,ls_headertext,ls_columntype)


s_syntax = s_syntax + 'Table.Name=' + as_qualifier + ','



for i_i = 1 to upperbound(ls_columnname)
	
	s_value = adw_data.describe(ls_columnname[i_i] + '.visible')
	s_original = ldw_datastore.describe(ls_columnname[i_i] + '.visible')
	
	// This is because sometimes 0 is stored weird.
	if s_original = '"1	0"' then s_original = '0'
	if s_value = '"1	0"' then s_value = '0'
	
	// This is so we will not process virtual columns tha tare not visible.
	if s_value = '0'  and s_original  = '!' then continue

	// THis is so we don't overrte columns that have custom visible attrs
	if len(s_original) > 5 then s_original = s_value
	
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_columnname[i_i] + '.visible=' + s_value +  ','
	end if
	
	// Check the X
	s_value = adw_data.describe(ls_columnname[i_i] + '.y')
	s_original = ldw_datastore.describe(ls_columnname[i_i] + '.y')
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_columnname[i_i] + '.y=' + s_value + ','
	end if

	if long(s_value) > l_max_y and adw_data.describe(ls_columnname[i_i] + '.visible') = '1'  then 
		l_max_y = long(s_value) + long(adw_data.describe(ls_columnname[i_i] + '.height'))
	end if

	
	// Check the y
	s_value = adw_data.describe(ls_columnname[i_i] + '.x')
	s_original = ldw_datastore.describe(ls_columnname[i_i] + '.x')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_columnname[i_i] + '.x=' + s_value + ','
	end if
	
	// Check the width
	s_value = adw_data.describe(ls_columnname[i_i] + '.width')
	s_original = ldw_datastore.describe(ls_columnname[i_i] + '.width')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_columnname[i_i] + '.width=' + s_value + ','
	end if
	
	//PD,2/23/2003. Added to Check the height
	s_value = adw_data.describe(ls_columnname[i_i] + '.height')
	s_original = ldw_datastore.describe(ls_columnname[i_i] + '.height')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_columnname[i_i] + '.height=' + s_value + ','
	end if

	// Check the Tab Sequence
	s_value = adw_data.describe(ls_columnname[i_i] + '.tabsequence')
	s_original = ldw_datastore.describe(ls_columnname[i_i] + '.tabsequence')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_columnname[i_i] + '.tabsequence=' + s_value +  ','
	end if
 

next


// Check the Labels for differences
for i_i = 1 to upperbound(ls_columnname)
	
	s_value = adw_data.describe(ls_headername[i_i] + '.visible')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.visible')

	// This is because sometimes 0 is stored weird.
	if s_original = '"1	0"' then s_original = '0'
	if s_value =  '"1	0"' then s_value = '0'

	// This is so we will not process virtual columns tha tare not visible.
	if s_value = '0'  and s_original  = '!' then continue

	// THis is so we don't overrte columns that have custom visible attrs
	if len(s_original) > 5 then s_original = s_value
	
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.visible=' + s_value +  ','
	end if
	
	// Check the X
	s_value = adw_data.describe(ls_headername[i_i] + '.y')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.y')
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.y=' + s_value + ','
	end if
	
	if long(s_value) > l_max_y and adw_data.describe(ls_headername[i_i] + '.visible') = '1'  then 
		l_max_y = long(s_value) + long(adw_data.describe(ls_headername[i_i] + '.height'))
	end if

	
	// Check the X
	s_value = adw_data.describe(ls_headername[i_i] + '.width')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.width')
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.width=' + s_value + ','
	end if
	
	//PD,2/23/2003. Added to Check the height
	s_value = adw_data.describe(ls_headername[i_i] + '.height')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.height')
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.height=' + s_value + ','
	end if
	
	// Check the y
	s_value = adw_data.describe(ls_headername[i_i] + '.x')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.x')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.x=' + s_value + ','
	end if
	
	// Check the y
	s_value = adw_data.describe(ls_headername[i_i] + '.text')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.text')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.text=' + s_value + ','
	end if
	
	
	
next

// This section handles the graphics.  We only save x and y for graphics.
ls_headername[] =  ls_null

ln_datawindow_tools.of_get_objects ( adw_data, 'bitmap', ls_headername[], false )
for i_i = 1 to upperbound(ls_headername)

	s_value = adw_data.describe(ls_headername[i_i] + '.visible')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.visible')

	// This is because sometimes 0 is stored weird.
	if s_original = '"1	0"' then s_original = '0'
	if s_value =  '"1	0"' then s_value = '0'
	
	// This is so we will not process virtual columns tha tare not visible.
	if s_value = '0'  and s_original  = '!' then continue

	// THis is so we don't overrte columns that have custom visible attrs
	if len(s_original) > 5 then s_original = s_value
	
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.visible=' + s_value +  ','
	end if

	// Check the graphics
	s_value = adw_data.describe(ls_headername[i_i] + '.x')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.x')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.x=' + s_value + ','
	end if

	// Check the X
	s_value = adw_data.describe(ls_headername[i_i] + '.y')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.y')
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.y=' + s_value + ','
	end if
	
	if long(s_value) > l_max_y and adw_data.describe(ls_headername[i_i] + '.visible') = '1'  then 
		l_max_y = long(s_value) + long(adw_data.describe(ls_headername[i_i] + '.height'))
	end if

		
next

// This section handles the graphics.  We only save x and y for graphics.
ls_headername[] =  ls_null

ln_datawindow_tools.of_get_objects ( adw_data, 'compute', ls_headername[], false )
for i_i = 1 to upperbound(ls_headername)

	s_value = adw_data.describe(ls_headername[i_i] + '.visible')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.visible')

	// This is because sometimes 0 is stored weird.
	if s_original = '"1	0"' then s_original = '0'
	if s_value =  '"1	0"' then s_value = '0'
	
	// This is so we will not process virtual columns tha tare not visible.
	if s_value = '0'  and s_original  = '!' then continue

	// THis is so we don't overrte columns that have custom visible attrs
	if len(s_original) > 5 then s_original = s_value
	
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.visible=' + s_value +  ','
	end if

	// Check the graphics
	s_value = adw_data.describe(ls_headername[i_i] + '.x')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.x')

	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.x=' + s_value + ','
	end if

	// Check the X
	s_value = adw_data.describe(ls_headername[i_i] + '.y')
	s_original = ldw_datastore.describe(ls_headername[i_i] + '.y')
	if s_value <> s_original then 
		s_syntax = s_syntax + ls_headername[i_i] + '.y=' + s_value + ','
	end if
	
	if long(s_value) > l_max_y and adw_data.describe(ls_headername[i_i] + '.visible') = '1'  then 
		l_max_y = long(s_value) + long(adw_data.describe(ls_headername[i_i] + '.height'))
	end if
		
next


s_syntax = s_syntax + 'Datawindow.Detail=' + string(l_max_y + 36)

destroy ldw_datastore

return s_syntax


end function

public function boolean of_add_attributecolumn (datawindow adw_object, string as_qualifier, string as_attrname);n_datawindow_syntax ln_datawindow_syntax
n_create_gc_dwsyntax ln_syntax
string s_columnname,s_syntax,s_multi,s_width,s_type,s_attrlabel,s_objects
long l_column_number


// Get the colum type for the GC Entry
select GnrlCnfgMulti ,GnrlCnfgQlfr
Into :s_multi,:s_attrlabel
from generalconfiguration
where GnrlCnfgTblNme = :as_qualifier
and 	GnrlCnfgQlfr = :as_attrname
and  GnrlCnfgHdrID = 0
and  GnrlCnfgDtlID = 0;

//This is the DAO Compatible column name
s_columnname = as_attrname + 'attribute'

s_objects = adw_object.Describe("DataWindow.Objects")
if pos(lower(s_objects),lower(s_columnname)) > 0 then return false



Choose Case s_multi
CASE 'mm/dd/yyyy','[date]','[date] [time]'
	s_type = 'datetime'
CASE else
	if pos(s_multi,'#0') > 0 then 
		s_type  = 'number'
	else
		s_type = 'char(80)'
	end if
End Choose



// This object will mod the syntax for us.
ln_datawindow_syntax = create n_datawindow_syntax
ln_datawindow_syntax.of_set_datasource(adw_object)


// Add the column and get back the syntax
l_column_number = ln_datawindow_syntax.of_add_column(s_type,s_columnname,'')
s_syntax = ln_datawindow_syntax.of_get_syntax()
adw_object.create(s_syntax)


//Use the GC Creator to add the column
ln_syntax.of_create_single_gc(adw_object,s_multi,s_columnname,l_column_number)

s_width = string(len(as_attrname) * 35)

// Now add the GUI's for the column.
s_syntax = 'text(band=detail alignment="1" text="' + s_attrlabel + ':" visible = "0" border="0" color="0" x="571" y="8" height="56" width="' + s_width + '"  name=' + as_attrname + 'attribute_t' + '  font.face="Arial" font.height="-8" font.weight="700"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
s_syntax = adw_object.Modify("Create " + s_syntax)
s_syntax = adw_object.Modify(s_columnname + '.height=64')
destroy ln_datawindow_syntax

return true
end function

on n_dw_configure.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dw_configure.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

