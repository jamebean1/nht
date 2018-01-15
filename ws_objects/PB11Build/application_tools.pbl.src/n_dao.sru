$PBExportHeader$n_dao.sru
forward
global type n_dao from datastore
end type
end forward

global type n_dao from datastore
event type boolean ue_setitem ( long ll_row,  string as_column,  any as_data )
event type string ue_getitem ( integer ll_row,  string as_column )
event type boolean ue_setitemvalidate ( long al_row,  string as_column,  any as_data )
end type
global n_dao n_dao

type variables
n_string_functions in_string_functions
n_dao in_parent
transaction it_transobject
string is_error
n_daomessage in_message


any ia_oldvalue
any ia_newvalue
string  is_currentcolumn

string is_columnarray[]
string is_validatecolumnarray[]
end variables

forward prototypes
public subroutine of_setdata (string as_datastring)
public subroutine of_setparent (n_dao an_dao)
public function string of_save ()
public function string of_validate_required ()
public function integer of_getcolumnnumber (string as_columnname)
public function string of_validate_dates ()
public function string of_getcolumnlist ()
public function transaction of_gettransobject ()
public function n_daomessage of_getmessageobject ()
public subroutine of_settransobject (transaction axctn_transaction)
public function boolean of_setitem (long al_row, string as_column, any as_data)
public function string of_getdata (string as_string)
public function string of_getdata (string as_columns[])
public function string of_getitem (long ll_row, string as_column)
public function string of_check_for_returns (string as_string)
end prototypes

event ue_setitem;//----------------------------------------------------------------------------------------------------------------------------------
// This event will be used to execute any rules that are related to a specific column on the dao 
//-----------------------------------------------------------------------------------------------------------------------------------

return true
end event

event ue_getitem;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      ue_getitem
//	Overrides:  No
//	Arguments:	
//	Overview:   stub event
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

return ''
end event

public subroutine of_setdata (string as_datastring);//----------------------------------------------------------------------------------------------------------------------------------
// This functio is used to quickly set the values into the dao
//-----------------------------------------------------------------------------------------------------------------------------------
this.importstring(as_datastring)
end subroutine

public subroutine of_setparent (n_dao an_dao);//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_setparent
//	Overrides:  No
//	Arguments:	
//	Overview:   set this objects parent variable
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

in_parent = an_dao
end subroutine

public function string of_save ();//----------------------------------------------------------------------------------------------------------------------------------
// Save this and any child values into the db.
//-----------------------------------------------------------------------------------------------------------------------------------

return ''
end function

public function string of_validate_required ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_validate_required()
// Arguments:   none returns column name of error
// Overview:    make sure all required columns have a value.
// Created by:  Jake Pratt
// History:     1/28/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long i_i,l_row
//integer i_col
//string s_ColNme


For i_i = 1 to upperbound(is_validatecolumnarray)
	
	l_row = this.find('isnull(' + is_validatecolumnarray[i_i] + ')' + ' or trim(string(' + is_validatecolumnarray[i_i] + '))=""',1,this.rowcount())
	if l_row > 0 and is_validatecolumnarray[i_i] <> '' then 
		return is_validatecolumnarray[i_i]
	end if
	
Next

return ''	
//
//this.FindRequired ( primary!, l_row , i_col, s_ColNme, TRUE)




end function

public function integer of_getcolumnnumber (string as_columnname);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_getcolumnnumber()
// Arguments:   none
// Overview:    Get the column number of the column passed in.
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


long i,y

if upperbound(is_columnarray) = 0 then
	i = long(this.describe("DataWindow.Column.Count"))
	for y = 1 to i
		is_columnarray[y] = this.describe("#"+ string(y) +".name")
	Next
end if

for y = 1 to upperbound(is_columnarray)
	if is_columnarray[y] = as_columnname then return y
Next


return 0
end function

public function string of_validate_dates ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_validate_dates()
// Arguments:   none returns column name of error
// Overview:    Validate that dates are in range
// Created by:  Jake Pratt
// History:     1/28/1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
integer i,y
datetime dt_date
string s_col,s_type


i = long(this.describe("DataWindow.Column.Count"))
for y = 1 to i
	s_type = left(lower(this.describe("#"+ string(y) +".coltype")),4)
	if s_type = 'date' then
		if this.rowcount() > 0 then
			dt_date = this.getitemdatetime(1,y)
			if date(dt_date) > 2076-12-31 or  date(dt_date) < 1980-01-01 then
				s_col = this.describe("#"+ string(y) +".name")
				return s_col
			end if
		end if
	end if	
Next


return ''
end function

public function string of_getcolumnlist ();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_getcolumnlist
//	Overrides:  No
//	Arguments:	
//	Overview:   get a list of columns on the dao.
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

long l_column_count,i_i
string s_string,s_virtual_string

l_column_count = long(this.describe("datawindow.column.count"))

for i_i = 1 to l_column_count
	
	s_string = s_string + this.describe("#" + string(i_i) + '.name')
	if i_i <> l_column_count then s_string = s_string + ','

next


return s_string


end function

public function transaction of_gettransobject ();//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_gettranobject()
// Arguments:   get hte transaction object on this dao.
// Overview:    Get the transaction used by the dao
// Created by:  Blake Doerr
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------


If IsValid(it_transobject) Then
	Return it_transobject
Else
	Return SQLCA
End If
end function

public function n_daomessage of_getmessageobject ();return in_message
end function

public subroutine of_settransobject (transaction axctn_transaction);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_Settranobject()
// Arguments:   set hte transaction object on to this dao.
// Overview:    DocumentScriptFunctionality
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

this.settransobject(axctn_transaction)
it_transobject = axctn_transaction
end subroutine

public function boolean of_setitem (long al_row, string as_column, any as_data);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  of_setitem()
// Arguments:   al_row - row
//					 as_column -  columnname to set the value into.
//					 as_data -  data to be set	into the column
// Overview:    DocumentScriptFunctionality
// Created by:  Jake Pratt
// History:     12/1/98 - First Created 
//	05/21/2001	HMD	18997	Add a case for date columns with variable = null
//-----------------------------------------------------------------------------------------------------------------------------------

decimal ld_data
datetime ldt_data
string ls_type
string	ls_data


ia_newvalue = as_data
is_currentcolumn = as_column

ls_type = this.Describe(as_column+".Coltype")


if isnull(al_row) or al_row = 0 or al_row > rowcount()  or rowcount() = 0 then return false

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','long','deci'
	
		// Added by jake to handle null numbers comming over as an empty string.
		ld_data = dec(as_data)

		IF Classname(as_data) = 'string' then 
			if as_data = '' then 
				setnull(ld_data)
			End If
		end if
		
		ia_oldvalue = this.getitemnumber(al_row,as_column)
		this.setitem(al_row,as_column,ld_data)

		
	Case 'date'
		
		choose case lower(classname( as_data))
			case 'string'
				ldt_data = gn_globals.in_string_functions.of_convert_string_to_datetime( string( as_data))
			case 'date'
				ldt_data = datetime(as_data)
			case 'datetime'
				ldt_data = as_data
			//-----------------------------------------------------------------------------------------------------------------------------------
			// BEGIN ADDED HMD 05/21/2001 18997 - When passing in a null datetime, the classname was getting 'null'
			// so the column was getting set to the the variable default of '1900-01-01' instead of null
			//-----------------------------------------------------------------------------------------------------------------------------------
			case else
				SetNull(ldt_data)
			//-----------------------------------------------------------------------------------------------------------------------------------
			// END ADDED HMD 05/21/2001 18997
			//-----------------------------------------------------------------------------------------------------------------------------------

		end choose

		ia_oldvalue = this.getitemdatetime(al_row,as_column)
		this.setitem(al_row,as_column,ldt_data)


	Case 'char'
		
		ls_data = string( as_data)

		//----------------------------------------------------------------------------------------------------------------------------------
		// This is because the setitem function replaces the carriages returns with the literal ~r~n
		//-----------------------------------------------------------------------------------------------------------------------------------
		if pos(ls_data,'~r~n') > 0 then 
			gn_globals.in_string_functions.of_replace_all(ls_data,'~r~n','~~r~~n')
		end if 



		ia_oldvalue = this.getitemstring(al_row,as_column)
		this.setitem(al_row,as_column,ls_data)


	Case Else

		
		if not this.event ue_setitem(al_row,lower(as_column),as_data) then return false
		
End Choose


//----------------------------------------------------------------------------------------------------------------------------------
// This is an event fur use in writing itemchanged code on the dao instead of on the client.
//-----------------------------------------------------------------------------------------------------------------------------------
if not this.event ue_setitemvalidate(al_row,lower(as_column),as_data) then return false

		
		
if isvalid(gn_globals.in_subscription_service) then
	gn_globals.in_subscription_service.of_message(lower(as_column),as_data,this)
end if

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is a valid message object, notify it that a column has changed and pass it the
//	row number and column name
//-----------------------------------------------------------------------------------------------------------------------------------
if isvalid(in_message) then
//	in_message.event ue_notify_client('ColumnChange',lower(as_column))
	ls_data = string(as_data)
	if isnull(ls_data) then ls_data = ''
	in_message.event ue_notify_client('ColumnChange',string(al_row) + '||' + lower(as_column) + '||' + string(ls_data))
end if

ia_newvalue = gn_globals.il_nullnumber
ia_oldvalue =  gn_globals.il_nullnumber
is_currentcolumn = ''



return true
end function

public function string of_getdata (string as_string);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  GetData()
// Arguments:   string = column name to be passed
// Overview:    Call the main GETDATA function converted to an array.
// Created by:  Jake Pratt
// History:     9/9/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
n_string_functions ln_string
string ls_array[]

gn_globals.in_string_functions.of_parse_string(as_string,',',ls_array)

return of_GetData(ls_array)
end function

public function string of_getdata (string as_columns[]);//----------------------------------------------------------------------------------------------------------------------------------
// Function:  	GetData()
// Arguments:  as_columns -   Array of Columns to get the data for.
// Overview:   Create a tab delimited string to get the data
// Created by:  Jake Pratt
// History:     9/9/98 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_counter,ll_rowcounter,ll_columnnumber,i_i, ll_rowcount, ll_columncount
string ls_return_string,ls_type
String ls_error,ls_syntax,s_value
datastore ids_data
any la_value

//----------------------------------------------------------------------------------------------------------------------------------
// Don't cause errors.
//-----------------------------------------------------------------------------------------------------------------------------------
ll_columncount = upperbound(as_columns)
ll_rowcount = this.rowcount()

if  ll_columncount = 0 then return ''
if ll_rowcount = 0 then return ''

//----------------------------------------------------------------------------------------------------------------------------------
// if there is only one column then call the get itemfunction
//-----------------------------------------------------------------------------------------------------------------------------------
if ll_columncount = 1 AND  ll_rowcount = 1 then
	ls_return_string = of_getitem(1,as_columns[1])
	if not isnull(ls_return_string)  then 
		return of_getitem(1,as_columns[1])
	else
		return ""
	end if 
end if


//----------------------------------------------------------------------------------------------------------------------------------
// Create a datastore for use in creating the virtual column list
//-----------------------------------------------------------------------------------------------------------------------------------
ids_data = create datastore
ls_syntax = 'release 7;~r~ndatawindow(units=0 timer_interval=0 color=16777215 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 110 print.margin.right = 110 print.margin.top = 97 print.margin.bottom = 97 print.paper.source = 0 print.paper.size = 0 print.prompt=no )~r~nheader(height=69 color="536870912" )~r~nsummary(height=1 color="536870912" )~r~nfooter(height=1 color="536870912" )~r~ndetail(height=81 color="536870912" )~r~ntable('


//----------------------------------------------------------------------------------------------------------------------------------
// create a column for each one passed
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcounter = upperbound(as_columns)

for ll_counter = 1 to ll_rowcounter

	ls_type = this.Describe(as_columns[ll_counter] + ".ColType")
	if ls_type = '' or isnull(ls_type) or ls_type = '!' then 
		ls_type = 'char(255)'
	end if

	ls_syntax = ls_syntax + 	' column=(type=' + string(ls_type) + ' updatewhereclause=no name=' + as_columns[ll_counter] + ' dbname="'+ as_columns[ll_counter] + ' " ) ~r~n'
	
Next

ids_data.create(ls_syntax + ')',ls_error)

//----------------------------------------------------------------------------------------------------------------------------------
// Insert a row for each on in this dw.
//-----------------------------------------------------------------------------------------------------------------------------------
long ll_error
ll_rowcount = this.rowcount()
for ll_counter = 1 to ll_rowcount
	ll_error = ids_data.insertrow(0)
next

//----------------------------------------------------------------------------------------------------------------------------------
// get the data
//-----------------------------------------------------------------------------------------------------------------------------------
for ll_counter = 1 to ll_rowcounter
//??? RAP changed for .Net, doesn't seem to work the other way
//	#IF defined PBDOTNET THEN
//		ll_columnnumber = 0
//	#ELSE
		ll_columnnumber = of_getcolumnnumber(as_columns[ll_counter])
//	#END IF

	//----------------------------------------------------------------------------------------------------------------------------------
	// if the column is real, set the data into the buffer of our new dw.
	// else set it in by hand.
	//-----------------------------------------------------------------------------------------------------------------------------------
	if ll_columnnumber > 0 then
		ll_rowcount = THIS.RowCount()
		for i_i = 1 to ll_rowcount
			la_value = this.Object.Data[i_i, ll_columnnumber]
			ids_data.Object.Data[i_i, ll_counter] = this.Object.Data[i_i, ll_columnnumber]
//			ids_data.setitem(i_i,ll_counter,la_value)
		next
//		ids_data.Object.Data[1,ll_counter, ll_rowcount, ll_counter] = this.Object.Data[1, ll_columnnumber, ll_rowcount, ll_columnnumber ]
	else
		Choose Case Lower(Trim(as_columns[ll_counter]))
			Case 'daorownumber'
				for i_i = 1 to ids_data.rowcount()
					ids_data.setitem(i_i, ll_counter, i_i)
				next
			Case Else
				for i_i = 1 to ids_data.rowcount()
					s_value = of_getitem(i_i,as_columns[ll_counter])
					ids_data.setitem(i_i,ll_counter,s_value)
				next
		End Choose
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

public function string of_getitem (long ll_row, string as_column);//----------------------------------------------------------------------------------------------------------------------------------
// Function:    of_getitem()
// Arguments:   none
// Overview:    Do a getitem and if it is not found try the virtual column list.
// Created by:  Jake Pratt
// History:     06.04.99 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string ls_type,ls_value
ls_type = this.Describe(as_column+".Coltype")
		

//----------------------------------------------------------------------------------------------------------------------------------
// Process each column based on the column type.  IF INVALID  PLACE AN EMPTY STRING.
//-----------------------------------------------------------------------------------------------------------------------------------
Choose Case lower(left(ls_type,4))
		
	Case 'numb','deci','long'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = string(this.getitemnumber(ll_row,as_column))

	Case 'date'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = string(this.getitemdatetime(ll_row,as_column),'yyyy-mm-dd hh:mm:ss') 

	Case 'char'
		if isnull(ll_row) or ll_row < 1 or ll_row > this.rowcount() then return ''
		ls_value = this.getitemstring(ll_row,as_column) 

		//----------------------------------------------------------------------------------------------------------------------------------
		// This is because the setitem function replaces the carriages returns with the literal ~r~n
		//-----------------------------------------------------------------------------------------------------------------------------------
		if pos(ls_value,'~~r~~n') > 0 then 
			gn_globals.in_string_functions.of_replace_all(ls_value,'~~r~~n','~r~n')
		end if 

	Case Else
		ls_value = this.event ue_getitem(ll_row,as_column)


End Choose

if isnull(ls_value) then ls_value = ''

return ls_value
end function

public function string of_check_for_returns (string as_string);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_check_for_returns()
//	Arguments:  as_string - the string to process.
//	Overview:   Changes the string data to be campatible with an importstring by putting quotes around the column with CR's in it.
//	Created by:	Jake Pratt
//	History: 	3.31.2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
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

on n_dao.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dao.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      dberror
//	Overrides:  No
//	Arguments:	
//	Overview:   Set the instance variable for the error text.
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

if buffer <> delete! then
	is_error = sqlerrtext
end if
end event

event sqlpreview;//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      sqlpreview
//	Overrides:  No
//	Arguments:	
//	Overview:   Issue the deletes so as not to run into any cascade delete failures
//	Created by: Jake Pratt
//	History:    7-27-1999 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string s_sql
if buffer=delete!  then
	execute immediate :sqlsyntax using it_transobject;
	if it_transobject.SQLCode<>0 then

		this.is_error = it_transobject.sqlerrtext
		//gl_dberrcde=sqlca.SQLDBCode
		//gs_dberrtxt=sqlca.SQLERRTEXT
		return 1
	else
		return 2
	end if
end if



end event

event constructor;in_message = create n_daomessage

end event

event destructor;destroy in_message
end event

