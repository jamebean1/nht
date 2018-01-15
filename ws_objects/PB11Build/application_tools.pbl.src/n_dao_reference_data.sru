$PBExportHeader$n_dao_reference_data.sru
forward
global type n_dao_reference_data from n_dao
end type
end forward

global type n_dao_reference_data from n_dao
string dataobject = "d_pricebuilder_dao_prvsn"
end type
global n_dao_reference_data n_dao_reference_data

type variables
n_dao  in_update_array[]
string is_update_name[]

string is_qualifier

n_concurrency in_checkout 

boolean ib_readonly
end variables

forward prototypes
public function n_dao of_get_child (string as_name)
public subroutine of_new ()
public function string of_validate ()
public subroutine of_resetupdate ()
public subroutine of_settransobject (transaction axctn_transaction)
public function string of_setkey ()
public function string of_copy ()
public subroutine of_send_validation_message (long al_row, string as_type, string as_column)
public function string of_get_qualifier ()
public function boolean of_changed ()
public function boolean of_transaction ()
public function string of_delete ()
public function string of_retrieve (long al_value)
public subroutine of_add_child (string as_name, string as_dwobject)
public function string of_save ()
end prototypes

public function n_dao of_get_child (string as_name);long i_i

for i_i = 1 to upperbound (is_update_name)
	if lower(is_update_name[i_i]) = lower(as_name) then 
		return in_update_array[i_i]
	end if
next
end function

public subroutine of_new ();this.insertrow(0)

end subroutine

public function string of_validate ();
return ''


end function

public subroutine of_resetupdate ();
long i_i

for i_i = 1 to upperbound(in_update_array)
	
	in_update_array[i_i].resetupdate()

next



end subroutine

public subroutine of_settransobject (transaction axctn_transaction);long i_i
for i_i = 1 to upperbound (in_update_array) 
	in_update_array[i_i].it_transobject = axctn_transaction
	in_update_array[i_i].settransobject(axctn_transaction)
next
end subroutine

public function string of_setkey ();long i_i,i_key,i_y
n_update_tools ln_tools

ln_tools = create n_update_tools

//----------------------------------------------------------------------------------------------------------------------------------
// If this is a new record generate a key else get the corrent key
//-----------------------------------------------------------------------------------------------------------------------------------
if this.getitemstatus(1,0,primary!) = NewModified! then 
	i_key = ln_tools.of_get_key(is_qualifier)
	this.setitem(1,1,i_key)
Else
	i_key = this.getitemnumber(1,1)
End IF

for i_i = 1 to upperbound(in_update_array)
	For i_y = 1 to in_update_array[i_i].rowcount()
		if in_update_array[i_i].getitemstatus(i_y,0,primary!) = NewModified! then
			in_update_array[i_i].setitem(i_y,1,i_key)
		end if
	next
next

destroy ln_tools

return ''
end function

public function string of_copy ();long i_i,i_y

for i_i = 1 to upperbound(in_update_array) 
	
	for i_y = 1 to in_update_array[i_i].rowcount()
		
		if in_update_array[i_i].GetItemStatus(i_y,0,PRIMARY!)<>NEW! then
			in_update_array[i_i].SetItemStatus(i_y,0,PRIMARY!,NEWMODIFIED!)
		end if
	next
	
	for i_y = 1 to in_update_array[i_i].filteredcount()
		
		if in_update_array[i_i].GetItemStatus(i_y,0,Filter!)<>NEW! then
			in_update_array[i_i].SetItemStatus(i_y,0,FIlter!,NEWMODIFIED!)
		end if
	next
	
next 

return ''

end function

public subroutine of_send_validation_message (long al_row, string as_type, string as_column);in_message.event ue_notify_client('Validation',string(al_row) + '||' + lower(as_type) + '||' + string(as_column))
		
end subroutine

public function string of_get_qualifier ();return is_qualifier
end function

public function boolean of_changed ();long i_i


if this.rowcount() = 0 then return false
for i_i = 1 to upperbound(in_update_array) 
	
	if in_update_array[i_i].modifiedcount() + in_update_array[i_i].deletedcount() > 0 then return true

next


return false

end function

public function boolean of_transaction ();return true
end function

public function string of_delete ();n_dao ln_datastores[],ln_error
n_update_tools ln_tools
long i_i,i_y




ln_datastores = in_update_array//{this}

for i_i = 1 to upperbound(ln_datastores)
	if ln_datastores[i_i].rowcount() <> 0 then
		For i_y = ln_datastores[i_i].rowcount() to 1 step -1 
			ln_datastores[i_i].deleterow(i_y)
		next
	end if 
next




//if this.rowcount() <> 0 then 
//	this.deleterow(1)
//end if



ln_tools  = create n_update_tools
ln_tools.of_begin_transaction()
ln_error = ln_tools.of_manage_update(ln_datastores)
if isvalid(ln_error) then 
	ln_tools.of_rollback_transaction()
	destroy ln_tools
	return 'Could not delete because of the following error ~r~n' + ln_error.is_error
end if

if not of_transaction() then 
	ln_tools.of_rollback_transaction()
	destroy ln_tools
	return ln_error.is_error		
end if


ln_tools.of_commit_transaction()
destroy ln_tools



return ''
end function

public function string of_retrieve (long al_value);long i_i

in_update_array[1].retrieve(al_value)
in_update_array[2].retrieve(al_value,is_qualifier)
in_update_array[3].retrieve(al_value,is_qualifier)

for i_i = 4 to upperbound(in_update_array) 
	
	in_update_array[i_i].retrieve(al_value)

next



//in_checkout.of_add_tableid(is_qualifier,al_value)
//if in_checkout.of_checkout( gn_globals.il_userid) = false then 
//	ib_readonly = true
//	return in_checkout.of_get_messagestring()
//else
//	return ''
//end if 
//
//

Return ''
end function

public subroutine of_add_child (string as_name, string as_dwobject);long l_new_position

l_new_position = upperbound(in_update_array)
l_new_position ++

if left(as_dwobject,1) = 'd' then 
	in_update_array[l_new_position] = create n_dao
	in_update_array[l_new_position].dataobject = as_dwobject
	is_update_name[l_new_position] = as_name
	in_update_array[l_new_position].in_parent = this	
else
	in_update_array[l_new_position] = create using as_dwobject
	is_update_name[l_new_position] = as_name	
	in_update_array[l_new_position].in_parent = this
end if

end subroutine

public function string of_save ();//----------------------------------------------------------------------------------------------------------------------------------
//	Event:      of_save
//	Arguments:	none
//	Overview:   Save and Validate all dao's
//	Created by: Jake Pratt
//	History:    8/2/2000 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

string s_return
long l_old
n_dao ln_datastores[],ln_error
n_update_tools ln_tools

If ib_readonly then return 'This item is read-only and may not be saved'
	
if this.rowcount() <> 0 then 
	
	s_return = of_validate()
	if s_return <> '' then 
		return s_return
	end if 
	
	s_return = of_setkey()
	if s_return <> '' then 
		return s_return
	end if 
	
end if


ln_datastores = in_update_array

ln_tools  = create n_update_tools
ln_tools.of_begin_transaction()
ln_error = ln_tools.of_manage_update(ln_datastores)
if isvalid(ln_error) then 
	ln_tools.of_rollback_transaction()
	destroy ln_tools
	return ln_error.is_error
end if

if not of_transaction() then 
	ln_tools.of_rollback_transaction()
	destroy ln_tools
	return ln_error.is_error		
end if


ln_tools.of_commit_transaction()




if this.getitemstatus(1,0,Primary!) = NewModified! Then
	in_checkout.of_add_tableid(is_qualifier,this.getitemnumber(1,1))
	in_checkout.of_checkout( gn_globals.il_userid) 
end if



of_resetupdate()




destroy ln_tools



return ''
end function

on n_dao_reference_data.create
call super::create
end on

on n_dao_reference_data.destroy
call super::destroy
end on

event constructor;call super::constructor;in_update_array[1] = this

of_add_child('Attributes','d_dao_generalconfig_attributes')
of_add_child('Comment','d_dao_generalcomment')



in_checkout = create n_concurrency



end event

event destructor;call super::destructor;long i_i


if isvalid(in_checkout) then 
	in_checkout.of_checkin()
	destroy in_checkout
end if

for i_i = upperbound(in_update_array)  to 1 step -1
	if in_update_array[i_i] <> this then
		destroy in_update_array[i_i]
	end if
next





end event

event type boolean ue_setitem(long ll_row, string as_column, any as_data);call super::ue_setitem;n_dao ln_dao
string s_column
long i_i

if lower(as_column) = 'comment' then 
	
	ln_dao = this.of_get_child('Comment')
	if string(as_data) = '' or isnull(string(as_data))  then
		if ln_dao.rowcount() = 1 then ln_dao.deleterow(1)
	else
		
		if ln_dao.rowcount() > 0 then
			ln_dao.of_setitem(1,'GnrlCmntTxt',as_data)
		else
			ln_dao.insertrow(0)
			ln_dao.setitem(1,'GnrlCmntQlfr',is_qualifier + 'Comment')
			ln_dao.of_setitem(1,'GnrlCmntTxt',as_data)				
		end if
	end if
	

	
end if

//----------------------------------------------------------------------------------------------------------------------------------
// IF the column is an attribute put it into the attribute datawindow
//-----------------------------------------------------------------------------------------------------------------------------------
if right(as_column,9) = 'attribute' then
	ln_dao = this.of_get_child('Attributes')
	s_column = lower(left(as_column,len(as_column) - 9))

	i_i = ln_dao.find('lower(gnrlcnfgqlfr) = "' + s_column + '"',1,ln_dao.rowcount())
	
	if string(as_data) = '' or isnull(string(as_data))  then
		ln_dao.deleterow(i_i)
	else
		if i_i > 0 then
			ln_dao.setitem(i_i,'gnrlcnfgmulti',as_data)
		else
			i_i = ln_dao.insertrow(0)
			ln_dao.setitem(i_i,'gnrlcnfgtblnme',is_qualifier)
			ln_dao.setitem(i_i,'gnrlcnfgqlfr',s_column)
			ln_dao.setitem(i_i,'gnrlcnfgmulti',as_data)				
		end if
	end if
end if

return true
end event

event ue_getitem;call super::ue_getitem;n_dao ln_dao
string s_column,s_remark
long i_i
 

if lower(as_column) = 'comment' then 
	
	ln_dao = this.of_get_child('Comment')
	if ln_dao.rowcount() = 1 then 
		return ln_dao.of_getitem(1,'GnrlCmntTxt')
	end if
	
end if

if right(as_column,9) = 'attribute' then

	ln_dao = this.of_get_child('Attributes')
	
	s_column = left(as_column,len(as_column) - 9)
	For i_i = 1 to ln_dao.rowcount()
		if  lower(ln_dao.getitemstring(i_i,'gnrlcnfgqlfr')) = lower(s_column) then
			s_remark = ln_dao.getitemstring(i_i,'gnrlcnfgmulti')
		end if
	next
	
	if isnull(s_remark) then s_remark = ''
	
	return s_remark
	
End IF
return ''
end event

