$PBExportHeader$n_dao_compositereportconfigdetailuser.sru
forward
global type n_dao_compositereportconfigdetailuser from n_dao
end type
end forward

global type n_dao_compositereportconfigdetailuser from n_dao
string dataobject = "d_data_compositereportconfigdetailuser"
end type
global n_dao_compositereportconfigdetailuser n_dao_compositereportconfigdetailuser

type variables
Protected:
	Long il_cmpsterprtcnfgusrid
	Long il_defaultreportheight = 500
	
end variables

forward prototypes
public function boolean of_ismodified ()
public subroutine of_resetupdate ()
public subroutine of_process_key (long al_key)
public function string of_retrieve (long al_cmpsterprtcnfgusrid)
public function string of_save ()
end prototypes

public function boolean of_ismodified ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_ismodified()
//	Overview:   This returns whether or not the view is modified
//	Created by:	Blake Doerr
//	History: 	6/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

Return This.ModifiedCount() + This.DeletedCount() > 0
end function

public subroutine of_resetupdate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_resetupdate()
//	Overview:   This will reset update
//	Created by:	Blake Doerr
//	History: 	6/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
This.ResetUpdate()
end subroutine

public subroutine of_process_key (long al_key);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_process_key()
//	Overview:   This will propagate the key
//	Created by:	Blake Doerr
//	History: 	6/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------
// Local Variables
//--------------------------------------------------------------------------
Long ll_index

//--------------------------------------------------------------------------
// Put the key into an instance variable
//--------------------------------------------------------------------------
il_cmpsterprtcnfgusrid = al_key

//--------------------------------------------------------------------------
// Set the key on all the rows in the primary buffer
//--------------------------------------------------------------------------
For ll_index = 1 To This.RowCount()
	If This.GetItemNumber(ll_index, 'crcdu_OrderID') <> 0 And IsNull(This.GetItemNumber(ll_index, 'crcdu_cmpsterprtcnfgusrid')) Then
		This.SetItem(ll_index, 'crcdu_cmpsterprtcnfgusrid', al_key)
	End If
Next

end subroutine

public function string of_retrieve (long al_cmpsterprtcnfgusrid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve()
//	Arguments:  al_cmpsterprtcnfgusrid - The ID for the user defined version of the composite report (may be passed as null)
//	Overview:   This will retrieve the composite report details and initialize them
//	Created by:	Blake Doerr
//	History: 	6/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return, ll_compositereportconfigdetailid, ll_index, ll_rowcount

//-----------------------------------------------------------------------------------------------------------------------------------
// Set the composite report config userid
//-----------------------------------------------------------------------------------------------------------------------------------
il_cmpsterprtcnfgusrid = al_cmpsterprtcnfgusrid

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the composite reports. 
//-----------------------------------------------------------------------------------------------------------------------------------
ll_rowcount = This.Retrieve(al_cmpsterprtcnfgusrid)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we didn't find what we were looking for, leave
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_rowcount < 0 Then
	Return 'Error Retrieving Composite Report Details'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Return success
//-----------------------------------------------------------------------------------------------------------------------------------
Return ''
end function

public function string of_save ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_save()
//	Overview:   This will save the view
//	Created by:	Blake Doerr
//	History: 	6/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return

ll_return = This.Update(True, False)

If ll_return > 0 Then
	Return ''
Else
	Return 'Could not save composite report detail:  ' + SQLCA.SQLErrText
End If
end function

event constructor;call super::constructor;This.of_settransobject(SQLCA)
end event

on n_dao_compositereportconfigdetailuser.create
call super::create
end on

on n_dao_compositereportconfigdetailuser.destroy
call super::destroy
end on

