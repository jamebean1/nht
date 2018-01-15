$PBExportHeader$n_dao_compositereportconfiguser.sru
forward
global type n_dao_compositereportconfiguser from n_dao
end type
end forward

global type n_dao_compositereportconfiguser from n_dao
string dataobject = "d_data_compositereportconfiguser"
end type
global n_dao_compositereportconfiguser n_dao_compositereportconfiguser

type variables
Protected:
	Boolean ib_canchangeviews = False
	Boolean ib_CanChangeReports = False
	Long il_cmpsterprtcnfgusrid

	n_update_tools in_update_tools
	
Public:	
n_dao_compositereportconfigdetailuser in_dao_compositereportconfigdetailuser
end variables

forward prototypes
public subroutine of_set_report_properties (n_report_composite an_properties)
public function boolean of_ismodified ()
public function string of_retrieve (long al_reportconfigid, long al_userid)
public function string of_save ()
end prototypes

public subroutine of_set_report_properties (n_report_composite an_properties);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_set_report_properties()
//	Arguments:  as_viewtype	- The view type
//					as_viewname - The name of the view
//					ab_isdefault - Whether or not it is the default
//	Overview:   This will return the properties of the report
//	Created by:	Blake Doerr
//	History: 	6/5/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_index, ll_row, ll_upperbound
String ls_expanded

If This.RowCount() > 0 Then
	This.SetItem(1, 'CurrentViewType', an_Properties.ViewType)
	This.SetItem(1, 'ViewName', an_Properties.ViewName)
	If an_Properties.IsDefault Then
		This.SetItem(1, 'IsDefault', 'Y')
	Else
		This.SetItem(1, 'IsDefault', 'N')
	End If
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Discard the rows
//-----------------------------------------------------------------------------------------------------------------------------------
in_dao_compositereportconfigdetailuser.Reset()

//-----------------------------------------------------------------------------------------------------------------------------------
// Loop through all the passed in reports
//-----------------------------------------------------------------------------------------------------------------------------------
ll_upperbound	= Min(UpperBound(an_Properties.ChildReportParameters[]), UpperBound(an_Properties.ChildReportCmpsteRprtCnfgDtlID[]))
ll_upperbound	= Min(ll_upperbound, UpperBound(an_Properties.ChildReportHeight[]))
ll_upperbound	= Min(ll_upperbound, UpperBound(an_Properties.ChildReportIsExpanded[]))
ll_upperbound	= Min(ll_upperbound, UpperBound(an_Properties.ChildReportSearchObject[]))

For ll_index = 1 To ll_upperbound
	If Not IsValid(an_Properties.ChildReportSearchObject[ll_index]) Then Continue
	If IsNull(an_Properties.ChildReportCmpsteRprtCnfgDtlID[ll_index]) Then Continue
	ll_row = in_dao_compositereportconfigdetailuser.InsertRow(0)

	If an_Properties.ChildReportIsExpanded[ll_index] Then
		ls_expanded = 'Y'
	Else
		ls_expanded = 'N'
	End If

	in_dao_compositereportconfigdetailuser.SetItem(ll_row, 'CmpsteRprtCnfgUsrID', il_CmpsteRprtCnfgUsrID)
	in_dao_compositereportconfigdetailuser.SetItem(ll_row, 'CmpsteRprtCnfgDtlID', an_Properties.ChildReportCmpsteRprtCnfgDtlID[ll_index])
	in_dao_compositereportconfigdetailuser.SetItem(ll_row, 'Height', an_Properties.ChildReportHeight[ll_index])
	in_dao_compositereportconfigdetailuser.SetItem(ll_row, 'OrderID', ll_index * 10)
	in_dao_compositereportconfigdetailuser.SetItem(ll_row, 'Expanded', ls_expanded)
	in_dao_compositereportconfigdetailuser.SetItem(ll_row, 'Parameters', an_Properties.ChildReportParameters[ll_index])
Next
end subroutine

public function boolean of_ismodified ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_ismodified()
//	Overview:   This returns whether or not the view is modified
//	Created by:	Blake Doerr
//	History: 	6/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

If ib_canchangeviews Or ib_CanChangeReports Then
	Return This.ModifiedCount() + This.DeletedCount() > 0 Or in_dao_compositereportconfigdetailuser.of_ismodified()
Else
	Return This.ModifiedCount() + This.DeletedCount() > 0
End If


end function

public function string of_retrieve (long al_reportconfigid, long al_userid);//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_retrieve()
//	Arguments:  al_reportconfigid - The report config id
//					al_userid			- The user id
//	Overview:   This will retrieve the composite report record and initialize it
//	Created by:	Blake Doerr
//	History: 	6/2/00 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------------------------------------------------------------------------------
// Local Variables
//-----------------------------------------------------------------------------------------------------------------------------------
Long ll_return, ll_index

//-----------------------------------------------------------------------------------------------------------------------------------
// Retrieve the composite report views
//-----------------------------------------------------------------------------------------------------------------------------------
SetNull(il_cmpsterprtcnfgusrid)
ll_return = This.Retrieve(al_reportconfigid, al_userid)

//-----------------------------------------------------------------------------------------------------------------------------------
// If we didn't find what we were looking for, leave
//-----------------------------------------------------------------------------------------------------------------------------------
If ll_return <= 0 Then
	Return 'The composite report definition was not found'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Filter down to the default view
//-----------------------------------------------------------------------------------------------------------------------------------
This.SetFilter('isdefault = "Y"')
This.Filter()

//-----------------------------------------------------------------------------------------------------------------------------------
// If there is not a default, unfilter
//-----------------------------------------------------------------------------------------------------------------------------------
If This.RowCount() = 0 Then
	This.SetFilter('')
	This.Filter()
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Get the composite report id
//-----------------------------------------------------------------------------------------------------------------------------------
il_cmpsterprtcnfgusrid 				= This.GetItemNumber(1, 'cmpsterprtcnfgusrid')
ib_canchangeviews 					= Upper(This.GetItemString(1, 'canchangeview')) = 'Y'
ib_CanChangeReports 					= Upper(This.GetItemString(1, 'canchangereports')) = 'Y'

in_dao_compositereportconfigdetailuser.of_retrieve(il_cmpsterprtcnfgusrid)

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

//--------------------------------------------------------------------------
// Local Variables
//--------------------------------------------------------------------------
String 	ls_return
n_dao ln_dao

//--------------------------------------------------------------------------
// May need to write some logic to prevent deleting and inserting the same record
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
// Begin the transaction
//--------------------------------------------------------------------------
in_update_tools.of_begin_transaction()

//--------------------------------------------------------------------------
// Update the datastore
//--------------------------------------------------------------------------
ln_dao = in_update_tools.of_manage_update({This})

//--------------------------------------------------------------------------
// Rollback and return an error if there was one
//--------------------------------------------------------------------------
If IsValid(ln_dao) Then
	in_update_tools.of_rollback_transaction()
	Return 'Could not save composite report:  ' + SQLCA.SQLErrText
End If

//----------------------------------------------------------------------------------
// If we can't change the views or reports, there is no reason to update the detail
//----------------------------------------------------------------------------------
If Not ib_CanChangeReports Then
	in_update_tools.of_commit_transaction()
	This.ResetUpdate()
	Return ''
End If

//--------------------------------------------------------------------------
// Delete previous details from this report
//--------------------------------------------------------------------------
Delete	CompositeReportConfigDetailUser
Where		CmpsteRprtCnfgUsrID				= :il_cmpsterprtcnfgusrid
Using		SQLCA;

//--------------------------------------------------------------------------
// Rollback and return an error if there was one
//--------------------------------------------------------------------------
If SQLCA.SQLCode < 0 Then
	in_update_tools.of_rollback_transaction()
	Return 'Could not save composite report:  ' + SQLCA.SQLErrText
End If

//--------------------------------------------------------------------------
// Process the keys and update the detail
//--------------------------------------------------------------------------
ls_return = in_dao_compositereportconfigdetailuser.of_save()

//--------------------------------------------------------------------------
// If there was an error on the detail return
//--------------------------------------------------------------------------
If ls_return <> '' Then
	in_update_tools.of_rollback_transaction()
	Return 'Could not save composite report:  ' + SQLCA.SQLErrText
End If

//--------------------------------------------------------------------------
// Commit the transaction
//--------------------------------------------------------------------------
in_update_tools.of_commit_transaction()

//--------------------------------------------------------------------------
// Reset the update statuses
//--------------------------------------------------------------------------
This.ResetUpdate()
in_dao_compositereportconfigdetailuser.of_resetupdate()

//--------------------------------------------------------------------------
// Return success
//--------------------------------------------------------------------------
Return ''
end function

event constructor;call super::constructor;This.of_settransobject(SQLCA)

in_dao_compositereportconfigdetailuser = Create n_dao_compositereportconfigdetailuser
in_update_tools = Create n_update_tools

in_update_tools.of_settransobject(SQLCA)
end event

on n_dao_compositereportconfiguser.create
call super::create
end on

on n_dao_compositereportconfiguser.destroy
call super::destroy
end on

event destructor;call super::destructor;Destroy in_dao_compositereportconfigdetailuser
Destroy in_update_tools
end event

