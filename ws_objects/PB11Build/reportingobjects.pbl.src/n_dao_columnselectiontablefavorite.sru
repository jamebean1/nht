$PBExportHeader$n_dao_columnselectiontablefavorite.sru
$PBExportComments$DAO for the ReportDatabase table. GLH
forward
global type n_dao_columnselectiontablefavorite from n_dao_reference_data
end type
end forward

global type n_dao_columnselectiontablefavorite from n_dao_reference_data
end type
global n_dao_columnselectiontablefavorite n_dao_columnselectiontablefavorite

type variables
Protected:
	Long		il_RprtCnfgID
end variables

forward prototypes
public function string of_validate ()
public subroutine of_new ()
end prototypes

public function string of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate()
//	Arguments:  NONE
//	Overview:   Verify uniqueness and that required fields have values.
//	Created by:	Blake Doerr
//	History: 	08-30-2002 - First Created 
//-----------------------------------------------------------------------------------------------------------------------------------
DWItemStatus	lenum_DWItemStatus

Long		ll_Idnty
Long		ll_RprtCnfgID
Long		ll_userid
Long		ll_CreatedByUserID
Long		ll_count
Long		ll_ToClmnSlctnTbleIdnty
Long		ll_FrmClmnSlctnTbleIdnty
String	ls_ColumnName
String	ls_ColumnText
String	ls_ColumnDescription
String	ls_TablePath
String	ls_Datawindow

ll_Idnty							= This.GetItemNumber(1, 'Idnty')
ll_RprtCnfgID					= This.GetItemNumber(1, 'RprtCnfgID')
ll_FrmClmnSlctnTbleIdnty	= This.GetItemNumber(1, 'FrmClmnSlctnTbleIdnty')
ll_userid						= This.GetItemNumber(1, 'UserID')
ll_CreatedByUserID			= This.GetItemNumber(1, 'CreatedByUserID')
ll_ToClmnSlctnTbleIdnty		= This.GetItemNumber(1, 'ToClmnSlctnTbleIdnty')
ls_ColumnName					= This.GetItemString(1, 'ColumnName')
ls_ColumnText					= This.GetItemString(1, 'ColumnText')
ls_ColumnDescription			= This.GetItemString(1, 'ColumnDescription')
ls_TablePath					= This.GetItemString(1, 'TablePath')
lenum_DWItemStatus			= This.GetItemStatus(1, 0, Primary!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify Report Database description has been filled out.
//-----------------------------------------------------------------------------------------------------------------------------------
If isnull(ls_ColumnText) or Len(Trim(ls_ColumnText)) = 0 Then
	of_send_validation_message(1,'ColumnSelectionTableFavorite','ColumnText')
	Return 'The field with focus can not be empty'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify Report Database description has been filled out.
//-----------------------------------------------------------------------------------------------------------------------------------
If isnull(ls_ColumnDescription) or Len(Trim(ls_ColumnDescription)) = 0 Then
	of_send_validation_message(1,'ColumnSelectionTableFavorite','ColumnDescription')
	Return 'The field with focus can not be empty'
End If

If lenum_DWItemStatus = NewModIfied! Then
	ll_Idnty = 0
End If

If IsNull(ll_RprtCnfgID) Then
	If IsNull(ll_userid) Then
		Select	Count(*)
		Into		:ll_count
		From		ColumnSelectionTableFavorite	(NoLock)
		Where		RTrim(LTrim(ColumnText))		= :ls_ColumnText
		And		FrmClmnSlctnTbleIdnty			= :ll_FrmClmnSlctnTbleIdnty
		And		Idnty									<> :ll_Idnty
		Using		SQLCA;
	Else
		Select	Count(*)
		Into		:ll_count
		From		ColumnSelectionTableFavorite	(NoLock)
		Where		RTrim(LTrim(ColumnText))		= :ls_ColumnText
		And		FrmClmnSlctnTbleIdnty			= :ll_FrmClmnSlctnTbleIdnty
		And		Idnty									<> :ll_Idnty
		And		(UserID								= :ll_userid
		Or			UserID								Is Null)
		Using		SQLCA;
	End If
Else
	If IsNull(ll_userid) Then
		Select	Count(*)
		Into		:ll_count
		From		ColumnSelectionTableFavorite	(NoLock)
		Where		RTrim(LTrim(ColumnText))		= :ls_ColumnText
		And		FrmClmnSlctnTbleIdnty			= :ll_FrmClmnSlctnTbleIdnty
		And		RprtCnfgID							= :ll_RprtCnfgID
		And		Idnty									<> :ll_Idnty
		Using		SQLCA;
	Else
		Select	Count(*)
		Into		:ll_count
		From		ColumnSelectionTableFavorite	(NoLock)
		Where		RTrim(LTrim(ColumnText))		= :ls_ColumnText
		And		FrmClmnSlctnTbleIdnty			= :ll_FrmClmnSlctnTbleIdnty
		And		RprtCnfgID							= :ll_RprtCnfgID
		And		Idnty									<> :ll_Idnty
		And		(UserID								= :ll_userid
		Or			UserID								Is Null)
		Using		SQLCA;
	End If
End If

If ll_count > 0 Then
	of_send_validation_message(1,'ColumnSelectionTableFavorite','ColumnText')
	If IsNull(ll_userid) Then
		Return 'A column with that name has already been defined in the database.  Since this is available to all users, it may conflict with a favorite column that you cannot see for another user'
	ElseIf IsNull(ll_RprtCnfgID) Then
		Return 'A column with that name has already been defined in the database.  Since this is available for all reports, it may conflict with a favorite column that you cannot see for another report'
	End If
End If

Return ''
end function

public subroutine of_new ();this.insertrow(0)
This.SetItem(1, 'CreatedByUserID', gn_globals.il_userid)
This.SetItem(1, 'UserID', gn_globals.il_userid)
This.SetItemStatus(1, 0, Primary!, NotModified!)
end subroutine

on n_dao_columnselectiontablefavorite.create
call super::create
end on

on n_dao_columnselectiontablefavorite.destroy
call super::destroy
end on

event constructor;call super::constructor;this.dataobject = 'd_dao_columnselectiontablefavorite'
is_qualifier = 'ColumnSelectionTableFavorite'
it_transobject = SQLCA
This.of_SetTransObject(it_transobject)
end event

event ue_getitem;call super::ue_getitem;Choose Case Lower(Trim(as_column))
	Case 'gui'
		Return 'w_columnselectiontablefavorite_maint'
	Case 'allowallusers'
		If IsNull(This.GetItemNumber(1, 'UserID')) Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'reportidisavailable'
		If il_RprtCnfgID > 0 And Not IsNull(il_RprtCnfgID) Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'security'
		If This.RowCount() <= 0 Then Return 'Error:  The column favorite could not be found'
		
		If This.GetItemNumber(1, 'UserID') <> gn_globals.il_userid Then
//			If Not gn_globals.in_security.of_check_role(gn_globals.il_userid, 1) Then
//				Return 'Error:  This favorite column is global, but you are not the creator of the expression or a system administrator'
//			End If
		End If
	Case 'access'
		If This.RowCount() <= 0 Then Return '0'
		
		If This.GetItemNumber(1, 'CreatedByUserID') <> gn_globals.il_userid Then
//			If Not gn_globals.in_security.of_check_role(gn_globals.il_userid, 1) Then
//				Return '0'
//			End If
		End If

		Return '1'
	Case 'applyrprtcnfgid'
		If Not IsNull(This.GetItemNumber(1, 'RprtCnfgID')) Then
			Return 'Y'
		Else
			Return 'N'
		End If
End Choose

Return ''
end event

event ue_setitem;call super::ue_setitem;Long ll_null
SetNull(ll_null)

Choose Case Lower(Trim(as_column))
	Case 'allowallusers'
		Choose Case Upper(Trim(as_data))
			Case 'Y'
				This.SetItem(1, 'UserID', ll_null)
			Case Else
				This.SetItem(1, 'UserID', gn_globals.il_userid)
		End Choose
	Case 'applyrprtcnfgid'
		Choose Case Upper(Trim(as_data))
			Case 'Y'
				This.SetItem(1, 'RprtCnfgID', il_RprtCnfgID)
			Case Else
				This.SetItem(1, 'RprtCnfgID', ll_null)
		End Choose
End Choose

Return True
end event

event ue_setitemvalidate;call super::ue_setitemvalidate;Choose Case Lower(Trim(as_column))
	Case 'rprtcnfgid'
		il_RprtCnfgID = Long(as_data)
End Choose

Return True
end event

