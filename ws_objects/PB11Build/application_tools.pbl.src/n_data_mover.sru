$PBExportHeader$n_data_mover.sru
$PBExportComments$<doc> Functions which move data from one datastore to another or from a datastore to a datawindow.
forward
global type n_data_mover from nonvisualobject
end type
end forward

global type n_data_mover from nonvisualobject
end type
global n_data_mover n_data_mover

forward prototypes
public function string of_check_for_returns (string as_string)
public subroutine of_cleardata (powerobject apo)
public function long of_copy_data (powerobject apo_source, powerobject apo_destination)
public function long of_copy_data (powerobject apo_source, powerobject apo_destination, boolean ab_clear_data, string as_buffer)
public function string of_getcolumnlist (powerobject apo)
public function string of_getdata (powerobject apo, string as_columns[])
public function string of_getdata (powerobject apo, string as_columns[], string as_buffer)
public function string of_getitem (powerobject apo, long al_row, string as_column)
public subroutine of_setdata (powerobject apo, string as_data)
end prototypes

public function string of_check_for_returns (string as_string);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Changes the string data to be campatible with an importstring by putting quotes around the column with CR's in it.</Description>
<Arguments>
	<Argument Name="as_string">String that may have carriage return</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
//n_string_functions ln_string
string ls_value, ls_reversed

long l_pos, l_posbegin, l_posreturnend, l_postabend


//-----------------------------------------------------------------------------------------------------------------------------------
// If there is no CR's just return.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = string(trim(as_string))

l_pos = pos(ls_value,'~~r~~n')

if l_pos = 0 then return ls_value


//-----------------------------------------------------------------------------------------------------------------------------------
// This cleans up the "'s so we can put quotes around the column
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.oF_replace_all(ls_value,'"','""')

l_pos = pos(ls_value,'~~r~~n')

//-----------------------------------------------------------------------------------------------------------------------------------
//  This loop adds quotes after the column with the carriage return.
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_pos > 0 


	//-----------------------------------------------------------------------------------------------------------------------------------
	// Look Right for a ~r~n or ~t and replace it with a ~"~r~n or ~"~t
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_postabend = pos(ls_value,"~t",l_pos)
	l_posreturnend = pos(ls_value,'~r~n',l_pos)


	//-----------------------------------------------------------------------------------------------------------------------------------
	// If didn't find any tabs or returns we are at the end so add a quote to the end.
	// Else
	//    Either add a quote to the Tab or return at the end of this field.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if l_postabend = 0 and l_posreturnend = 0 then
		ls_value = ls_value + '~"'
		exit
	else
		if l_postabend < l_posreturnend or l_posreturnend = 0 then 
			ls_value = Replace ( ls_value, l_postabend, 1, "~"~t" ) 
			l_pos = l_postabend
		else
			ls_value = Replace ( ls_value, l_posreturnend, 2, "~"~r~n" ) 
			l_pos = l_posreturnend
		end if
	end if


	l_pos = pos(ls_value,'~~r~~n',l_pos)

Loop


//-----------------------------------------------------------------------------------------------------------------------------------
// The first loop added the quotes after the string.  
// To add the quote before, we will reverse the string and follow the same logic.
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = reverse(ls_value)


l_pos = pos(ls_value,'n~~r~~')


//-----------------------------------------------------------------------------------------------------------------------------------
//  This loop adds quotes after the column with the carriage return.  Keep in mind that the data is reveresed so we look for different strings.
//-----------------------------------------------------------------------------------------------------------------------------------
Do While l_pos > 0 


	//-----------------------------------------------------------------------------------------------------------------------------------
	// Look Right for a ~r~n or ~t and replace it with a ~"~r~n or ~"~t
	//-----------------------------------------------------------------------------------------------------------------------------------
	l_postabend = pos(ls_value,"~t",l_pos)
	l_posreturnend = pos(ls_value,'~n~r',l_pos)

	//-----------------------------------------------------------------------------------------------------------------------------------
	// If didn't find any tabs or returns we are at the end so add a quote to the end.
	// Else
	//    Either add a quote to the Tab or return at the end of this field.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if l_postabend = 0 and l_posreturnend = 0 then
		ls_value = ls_value + '~"'
		exit
	else
		if l_postabend < l_posreturnend or l_posreturnend = 0  then 
			ls_value = Replace ( ls_value, l_postabend, 1, "~"~t" ) 
			l_pos = l_postabend
		else
			ls_value = Replace ( ls_value, l_posreturnend,2, "~"~n~r" ) 
			l_pos = l_posreturnend
		end if
	end if

	l_pos = pos(ls_value,'n~~r~~',l_pos)

Loop


//-----------------------------------------------------------------------------------------------------------------------------------
//  Now reverse the string to get it back to normal
//-----------------------------------------------------------------------------------------------------------------------------------
ls_value = reverse(ls_value)


//-----------------------------------------------------------------------------------------------------------------------------------
// Finally replace our fake cr's with real ones.
//-----------------------------------------------------------------------------------------------------------------------------------
gn_globals.in_string_functions.oF_replace_all(ls_value,'~~r~~n','~r~n')


return ls_value
end function

public subroutine of_cleardata (powerobject apo);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Clears the data from the passed in DW or Datastore.</Description>
<Arguments>
	<Argument Name="apo">Reference to the object to be reset.</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

datawindow	ldw
datastore	lds

choose case apo.typeof()
	case datawindow!
		ldw = apo
	case datastore!
		lds = apo
	case else
		return
end choose

if isvalid( ldw) then
	ldw.setredraw(false)
	ldw.post setredraw(true)
	ldw.reset()
else
	lds.reset()
end if

return
end subroutine

public function long of_copy_data (powerobject apo_source, powerobject apo_destination);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Replaces data in APO_Destination with data from APO_Source</Description>
<Arguments>
	<Argument Name="apo_source">Source for the data</Argument>
	<Argument Name="apo_destination">Destination target for the data</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string	ls_data
string	ls_columns[]
string	ls_column_string
//n_string_functions	ln_string

ls_column_string = this.of_getcolumnlist( apo_destination)

gn_globals.in_string_functions.of_parse_string( ls_column_string, ",", ls_columns)

ls_data = this.of_getdata( apo_source, ls_columns[])

this.of_cleardata( apo_destination)

this.of_setdata( apo_destination, ls_data)

return 0
end function

public function long of_copy_data (powerobject apo_source, powerobject apo_destination, boolean ab_clear_data, string as_buffer);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Adds data in APO_Destination with data from APO_Source,if ab_clear_data is false, it will preserve the original data in apo_destination.   </Description>
<Arguments>
	<Argument Name="apo_source">Source for the data</Argument>
	<Argument Name="apo_destination">Destination target for the data</Argument>
	<Argument Name="ab_cleardata">True will clear the data from the destination before importing new data set.</Argument>
	<Argument Name="as_buffer">Specifies the buffer to use when retrieving data from apo_source.</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string	ls_data
string	ls_columns[]
string	ls_column_string
//n_string_functions	ln_string

ls_column_string = this.of_getcolumnlist( apo_destination)

gn_globals.in_string_functions.of_parse_string( ls_column_string, ",", ls_columns)

ls_data = this.of_getdata( apo_source, ls_columns[],as_buffer)

if ab_clear_data then
	this.of_cleardata( apo_destination)
end if

this.of_setdata( apo_destination, ls_data)

return 0
end function

public function string of_getcolumnlist (powerobject apo);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Retuns a comman delimited list of column names in the passed in DW/Datastore</Description>
<Arguments>
	<Argument Name="apo">Object to inspect.</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
long l_column_count,i_i
string s_string,s_virtual_string
string	ls_describe
datawindow	ldw
datastore	lds

if apo.typeof() = datawindow! then
	ldw = apo
elseif apo.typeof() = datastore! then
	lds = apo
end if

if isvalid(ldw) then
	l_column_count = long(ldw.describe("datawindow.column.count"))
elseif isvalid(lds) then
	l_column_count = long(lds.describe("datawindow.column.count"))
end if

for i_i = 1 to l_column_count
	
	if i_i > 1 then
		ls_describe = ls_describe + "~t"
	end if
	
	ls_describe = ls_describe + "#" + string(i_i) + ".name"
	
next

if isvalid( ldw) then
	s_string = ldw.describe(ls_describe)
elseif isvalid(lds) then
	s_string = lds.describe(ls_describe)
end if

//n_string_functions	ln_string

gn_globals.in_string_functions.of_replace_all( s_string, "~n", ",")

return s_string


end function

public function string of_getdata (powerobject apo, string as_columns[]);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the data in apo in a format compatible with importstring (tab delimited).   Columns to get are specified using as_columns </Description>
<Arguments>
	<Argument Name="apo">Source for the data</Argument>
	<Argument Name="as_columns[]">Array of columns. String Datawill be returned in Array Order</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
long ll_counter,ll_rowcounter,ll_columnnumber,i_i
string ls_return_string,ls_type
String ls_error,ls_syntax,s_value
long	ll_rowcount
datastore ids_data
datawindow	ldw
datastore	lds
string	ls_describe
string	ls_source_colname_describe
string	ls_source_coltype_describe
string	ls_source_colnames, ls_source_colname[]
string	ls_source_coltypes, ls_source_coltype[]
string	ls_coltype[]
long		ll_colid[]
string	ls_value_array[], ls_null[]
long		ll_source_column_count
long		ll_i

//n_string_functions	ln_string

choose case typeof(apo)
	case datawindow!
		ldw = apo
		ll_rowcount = ldw.rowcount()
	case datastore!
		lds = apo
		ll_rowcount = lds.rowcount()
end choose

//----------------------------------------------------------------------------------------------------------------------------------
// Don't cause errors.
//-----------------------------------------------------------------------------------------------------------------------------------
if  upperbound(as_columns) = 0 then return ''

if ll_rowcount = 0 then return ''

//----------------------------------------------------------------------------------------------------------------------------------
// if there is only one column then call the get itemfunction
//-----------------------------------------------------------------------------------------------------------------------------------
if upperbound(as_columns) = 1 AND  ll_rowcount = 1 then
	ls_return_string = of_getitem(apo, 1,as_columns[1])
	if not isnull(ls_return_string)  then 
		return of_getitem(apo, 1,as_columns[1])
	else
		return ""
	end if 
end if


//----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore for use in creating the virtual column list
//-----------------------------------------------------------------------------------------------------------------------------------
ids_data = create datastore
ls_syntax = 'release 9;~r~ndatawindow(units=0 timer_interval=0 color=16777215 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )~r~nheader(height=69 color="536870912" )~r~nsummary(height=1 color="536870912" )~r~nfooter(height=1 color="536870912" )~r~ndetail(height=81 color="536870912" )~r~ntable('

if isvalid(ldw) then
	ll_source_column_count = long(ldw.describe("datawindow.column.count"))
elseif isvalid(lds) then
	ll_source_column_count = long(lds.describe("datawindow.column.count"))
end if

for ll_i = 1 to ll_source_column_count
	if ll_i > 1 then
		ls_source_colname_describe = ls_source_colname_describe + "~t"
		ls_source_coltype_describe = ls_source_coltype_describe + "~t"
	end if
	ls_source_colname_describe = ls_source_colname_describe + "#" + string(ll_i) + ".name"
	ls_source_coltype_describe = ls_source_coltype_describe + "#" + string(ll_i) + ".coltype"
next

if isvalid(ldw) then
	ls_source_colnames = ldw.describe(ls_source_colname_describe)
	ls_source_coltypes = ldw.describe(ls_source_coltype_describe)
else
	ls_source_colnames = lds.describe(ls_source_colname_describe)
	ls_source_coltypes = lds.describe(ls_source_coltype_describe)
end if

gn_globals.in_string_functions.of_parse_string(ls_source_colnames, "~n", ls_source_colname[])
gn_globals.in_string_functions.of_parse_string(ls_source_coltypes, "~n", ls_source_coltype[])

//----------------------------------------------------------------------------------------------------------------------------------
// create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcounter = upperbound(as_columns)

for ll_counter = 1 to ll_rowcounter

/*
	if isvalid(ldw) then
		ls_type = ldw.Describe(as_columns[ll_counter] + ".ColType")
	elseif isvalid(lds) then
		ls_type = lds.Describe(as_columns[ll_counter] + ".ColType")
	end if

	if ls_type = '' or isnull(ls_type) or ls_type = '!' then 
		ls_type = 'char(255)'
	end if

*/
	
	ls_coltype[ll_counter] = 'char(255)'
	ll_colid[ll_counter] = 0
	
	for ll_i = 1 to ll_source_column_count
		if ls_source_colname[ll_i] = as_columns[ll_counter] then
			ls_coltype[ll_counter] = ls_source_coltype[ll_i]
			ll_colid[ll_counter] = ll_i
		end if
	next	

	ls_type = ls_coltype[ll_counter]
	
	ls_syntax = ls_syntax + 	' column=(type=' + string(ls_type) + ' updatewhereclause=no name=' + as_columns[ll_counter] + ' dbname="'+ as_columns[ll_counter] + ' " ) ~r~n'
	
Next

ids_data.create(ls_syntax + ')',ls_error)

//----------------------------------------------------------------------------------------------------------------------------------
// Insert a ruw for each on in this dw.
//-----------------------------------------------------------------------------------------------------------------------------------
for ll_counter = 1 to ll_rowcount
	ids_data.insertrow(0)
next

//----------------------------------------------------------------------------------------------------------------------------------
// get the data
//-----------------------------------------------------------------------------------------------------------------------------------
for ll_counter = 1 to ll_rowcounter

/*
	if isvalid(ldw) then
		ll_columnnumber = long(ldw.describe(as_columns[ll_counter] + ".id"))
	elseif isvalid(lds) then
		ll_columnnumber = long(lds.describe(as_columns[ll_counter] + ".id"))
	end if		
*/

	ll_columnnumber = ll_colid[ll_counter]
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// if the column is real, set the data into the buffer of our new dw.
	// else set it in by hand.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if ll_columnnumber > 0 then
		if isvalid(ldw) then
			ids_data.object.data[1,ll_counter, ll_rowcount, ll_counter] = ldw.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber ]
		else
			ids_data.object.data[1,ll_counter, ll_rowcount, ll_counter] = lds.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber ]
		end if			
	else
		
		s_value = of_getitem(apo, 1,as_columns[ll_counter])
		
		if s_value = '' then continue
		
		for i_i = 1 to ll_rowcount
			ids_data.setitem(i_i,ll_counter,s_value)
		next
		
	end if
	
Next

//----------------------------------------------------------------------------------------------------------------------------------
// get the data to be returned.
//-----------------------------------------------------------------------------------------------------------------------------------

ls_return_string = ids_data.object.datawindow.data//describe("DataWindow.Data")
ls_return_string = of_check_for_returns(ls_return_string)
destroy ids_data

return ls_return_string
end function

public function string of_getdata (powerobject apo, string as_columns[], string as_buffer);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Returns the data in apo in a format compatible with importstring (tab delimited).   Columns to get are specified using as_columns </Description>
<Arguments>
	<Argument Name="apo">Source for the data</Argument>
	<Argument Name="as_columns[]">Array of columns. String Datawill be returned in Array Order</Argument>
	<Argument Name="as_buffer">Buffer to access data from.  Valid values are 'primary','deleted','filtered'</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
long ll_counter,ll_rowcounter,ll_columnnumber,i_i,ll_deleted_count,ll_filter_count
string ls_return_string,ls_type
String ls_error,ls_syntax,s_value
long	ll_rowcount
datastore ids_data
datawindow	ldw
datastore	lds
string	ls_describe
string	ls_source_colname_describe
string	ls_source_coltype_describe
string	ls_source_colnames, ls_source_colname[]
string	ls_source_coltypes, ls_source_coltype[]
string	ls_coltype[]
long		ll_colid[]
string	ls_value_array[], ls_null[]
long		ll_source_column_count
long		ll_i

//n_string_functions	ln_string

choose case typeof(apo)
	case datawindow!
		ldw = apo
		ll_rowcount = ldw.rowcount()
		ll_deleted_count = ldw.deletedcount()
		ll_filter_count = ldw.filteredcount()
case datastore!
		lds = apo
		ll_rowcount = lds.rowcount()
		ll_deleted_count = lds.deletedcount()
		ll_filter_count = lds.filteredcount()
end choose

//----------------------------------------------------------------------------------------------------------------------------------
// Don't cause errors.
//-----------------------------------------------------------------------------------------------------------------------------------
if  upperbound(as_columns) = 0 then return ''


// Removed 7.26.02 JDW
//if ll_rowcount = 0 then return ''

//Added 7.26.02 JDW
Choose Case lower(as_buffer)
	Case 'primary'
			If ll_rowcount = 0 THen Return ''
	Case 'deleted'
			If ll_deleted_count = 0 THen Return ''
	Case 'filtered'
			If ll_filter_count = 0 THen Return ''
End Choose

//----------------------------------------------------------------------------------------------------------------------------------
// if there is only one column then call the get itemfunction
//-----------------------------------------------------------------------------------------------------------------------------------
if upperbound(as_columns) = 1 AND  ll_rowcount = 1 then
	ls_return_string = of_getitem(apo, 1,as_columns[1])
	if not isnull(ls_return_string)  then 
		return of_getitem(apo, 1,as_columns[1])
	else
		return ""
	end if 
end if


//----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore for use in creating the virtual column list
//-----------------------------------------------------------------------------------------------------------------------------------
ids_data = create datastore
ls_syntax = 'release 5;~r~ndatawindow(units=0 timer_interval=0 color=16777215 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )~r~nheader(height=69 color="536870912" )~r~nsummary(height=1 color="536870912" )~r~nfooter(height=1 color="536870912" )~r~ndetail(height=81 color="536870912" )~r~ntable('

if isvalid(ldw) then
	ll_source_column_count = long(ldw.describe("datawindow.column.count"))
elseif isvalid(lds) then
	ll_source_column_count = long(lds.describe("datawindow.column.count"))
end if

for ll_i = 1 to ll_source_column_count
	if ll_i > 1 then
		ls_source_colname_describe = ls_source_colname_describe + "~t"
		ls_source_coltype_describe = ls_source_coltype_describe + "~t"
	end if
	ls_source_colname_describe = ls_source_colname_describe + "#" + string(ll_i) + ".name"
	ls_source_coltype_describe = ls_source_coltype_describe + "#" + string(ll_i) + ".coltype"
next

if isvalid(ldw) then
	ls_source_colnames = ldw.describe(ls_source_colname_describe)
	ls_source_coltypes = ldw.describe(ls_source_coltype_describe)
else
	ls_source_colnames = lds.describe(ls_source_colname_describe)
	ls_source_coltypes = lds.describe(ls_source_coltype_describe)
end if

gn_globals.in_string_functions.of_parse_string(ls_source_colnames, "~n", ls_source_colname[])
gn_globals.in_string_functions.of_parse_string(ls_source_coltypes, "~n", ls_source_coltype[])

//----------------------------------------------------------------------------------------------------------------------------------
// create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcounter = upperbound(as_columns)

for ll_counter = 1 to ll_rowcounter

/*
	if isvalid(ldw) then
		ls_type = ldw.Describe(as_columns[ll_counter] + ".ColType")
	elseif isvalid(lds) then
		ls_type = lds.Describe(as_columns[ll_counter] + ".ColType")
	end if

	if ls_type = '' or isnull(ls_type) or ls_type = '!' then 
		ls_type = 'char(255)'
	end if

*/
	
	ls_coltype[ll_counter] = 'char(255)'
	ll_colid[ll_counter] = 0
	
	for ll_i = 1 to ll_source_column_count
		if ls_source_colname[ll_i] = as_columns[ll_counter] then
			ls_coltype[ll_counter] = ls_source_coltype[ll_i]
			ll_colid[ll_counter] = ll_i
		end if
	next	

	ls_type = ls_coltype[ll_counter]
	
	ls_syntax = ls_syntax + 	' column=(type=' + string(ls_type) + ' updatewhereclause=no name=' + as_columns[ll_counter] + ' dbname="'+ as_columns[ll_counter] + ' " ) ~r~n'
	
Next

ids_data.create(ls_syntax + ')',ls_error)

//----------------------------------------------------------------------------------------------------------------------------------
// Insert a ruw for each on in this dw.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(as_buffer)
	Case 'primary'
		for ll_counter = 1 to ll_rowcount
			ids_data.insertrow(0)
		next
	Case 'deleted'
		for ll_counter = 1 to ll_deleted_count
			ids_data.insertrow(0)
		next
	Case 'filtered'
		for ll_counter = 1 to ll_filter_count
			ids_data.insertrow(0)
		next
End Choose
//----------------------------------------------------------------------------------------------------------------------------------
// get the data
//-----------------------------------------------------------------------------------------------------------------------------------
for ll_counter = 1 to ll_rowcounter

/*
	if isvalid(ldw) then
		ll_columnnumber = long(ldw.describe(as_columns[ll_counter] + ".id"))
	elseif isvalid(lds) then
		ll_columnnumber = long(lds.describe(as_columns[ll_counter] + ".id"))
	end if		
*/

	ll_columnnumber = ll_colid[ll_counter]
	
	//----------------------------------------------------------------------------------------------------------------------------------
	// if the column is real, set the data into the buffer of our new dw.
	// else set it in by hand.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if ll_columnnumber > 0 then
		Choose Case lower(as_buffer)
			Case 'primary'		
				if isvalid(ldw) then
					ids_data.object.data[1,ll_counter, ll_rowcount, ll_counter] = ldw.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber ]
				else
					ids_data.object.data[1,ll_counter, ll_rowcount, ll_counter] = lds.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber ]
				end if
			Case 'deleted'
				if isvalid(ldw) then
					ids_data.object.data[1,ll_counter, ll_deleted_count, ll_counter] = ldw.Object.Data.delete[1, ll_columnnumber, ll_deleted_count, ll_columnnumber ]
				else
					ids_data.object.data[1,ll_counter, ll_deleted_count, ll_counter] = lds.Object.Data.delete[1, ll_columnnumber, ll_deleted_count, ll_columnnumber ]
				end if
			Case 'filtered'
				if isvalid(ldw) then
					ids_data.object.data[1,ll_counter, ll_filter_count, ll_counter] = ldw.Object.Data.filter[1, ll_columnnumber, ll_filter_count, ll_columnnumber ]
				else
					ids_data.object.data[1,ll_counter, ll_filter_count, ll_counter] = lds.Object.Data.filter[1, ll_columnnumber, ll_filter_count, ll_columnnumber ]
				end if

		End Choose	
	else
		
		s_value = of_getitem(apo, 1,as_columns[ll_counter])
		
		if s_value = '' then continue
		
		for i_i = 1 to ll_rowcount
			ids_data.setitem(i_i,ll_counter,s_value)
		next
		
	end if
	
Next

//----------------------------------------------------------------------------------------------------------------------------------
// get the data to be returned.
//-----------------------------------------------------------------------------------------------------------------------------------

ls_return_string = ids_data.object.datawindow.data//describe("DataWindow.Data")
ls_return_string = of_check_for_returns(ls_return_string)
destroy ids_data

return ls_return_string
end function

public function string of_getitem (powerobject apo, long al_row, string as_column);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Obsolete Function - Use of_getitem instead.</Description>
<Arguments>
	<Argument Name="apo">Source for the data</Argument>
	<Argument Name="al_row">Row to Access</Argument>
	<Argument Name="as_column">Column to Access</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/

string ls_type,ls_value
long	ll_rowcount
//n_string_functions	ln_string_functions
datawindow	ldw
datastore	lds

choose case apo.typeof()
	case datawindow!
		ldw = apo
	case datastore!
		lds = apo
	case else
		return ''
end choose

if isvalid(ldw) then
	ls_type = ldw.Describe(as_column+".Coltype")
	ll_rowcount = ldw.rowcount()
else
	ls_type = lds.Describe(as_column+".Coltype")
	ll_rowcount = lds.rowcount()
end if
	

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','deci','long'
		if isnull(al_row) or al_row < 1 or al_row > ll_rowcount then return ''
		if isvalid(ldw) then
			ls_value = string(ldw.getitemnumber(al_row,as_column))
		else
			ls_value = string(lds.getitemnumber(al_row,as_column))
		end if			

	Case 'date'
		if isnull(al_row) or al_row < 1 or al_row > ll_rowcount then return ''
		if isvalid(ldw) then
			ls_value = string(ldw.getitemdatetime(al_row,as_column)) 
		else
			ls_value = string(lds.getitemdatetime(al_row,as_column)) 
		end if

	Case 'char'
		if isnull(al_row) or al_row < 1 or al_row > ll_rowcount then return ''
		if isvalid(ldw) then
			ls_value = ldw.getitemstring(al_row,as_column) 
		else
			ls_value = lds.getitemstring(al_row,as_column) 
		end if			

		//----------------------------------------------------------------------------------------------------------------------------------
		// This is because the setitem function replaces the carriages returns with the literal ~r~n
		//-----------------------------------------------------------------------------------------------------------------------------------
		if pos(ls_value,'~~r~~n') > 0 then 
			gn_globals.in_string_functions.of_replace_all(ls_value,'~~r~~n','~r~n')
		end if 

	Case Else
		if isvalid(ldw) then
			ls_value = string(ldw.event dynamic ue_getitem(al_row,as_column))
		else
			ls_value = string(lds.event dynamic ue_getitem(al_row,as_column))
		end if


End Choose

if isnull(ls_value) then ls_value = ''


return ls_value
end function

public subroutine of_setdata (powerobject apo, string as_data);/*<Documentation>----------------------------------------------------------------------------------------------------
<Description>Set Data into a DW/Datastore. Data must be in ImportString format.</Description>
<Arguments>
	<Argument Name="apo">Source for the data</Argument>
	<Argument Name="as_data">Data to be set into the DW/Datastore</Argument>
</Arguments>
<CreatedBy>Jake Pratt</CreatedBy>
<Created>6/2/2003</Created>
</Documentation>----------------------------------------------------------------------------------------------------*/
//----------------------------------------------------------------------------------------------------------------------------------
// This functio is used to quickly set the values into the target object
//-----------------------------------------------------------------------------------------------------------------------------------
datawindow	ldw
datastore	lds

choose case apo.typeof()
	case datawindow!
		ldw = apo
	case datastore!
		lds = apo
	case else
		return
end choose

if isvalid(ldw) then
	ldw.setredraw(false)
	ldw.post setredraw(true)
	ldw.importstring(as_data)
	ldw.sort()
	ldw.filter()
elseif isvalid(lds) then
	lds.importstring(as_data)
	lds.sort()
	lds.filter()
end if



return
	
	
end subroutine

on n_data_mover.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_data_mover.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;/*<Abstract>----------------------------------------------------------------------------------------------------
This object allows the developer to easily move data from one DW or Datastore to another DataStore or DW.  This 
is typically done by using the of_getdata functions and using import string on the target DW/Datastore.
</Abstract>----------------------------------------------------------------------------------------------------*/



end event

