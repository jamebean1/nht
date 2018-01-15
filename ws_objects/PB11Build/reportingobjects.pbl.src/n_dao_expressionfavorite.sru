$PBExportHeader$n_dao_expressionfavorite.sru
$PBExportComments$DAO for the ReportDatabase table. GLH
forward
global type n_dao_expressionfavorite from n_dao_reference_data
end type
end forward

global type n_dao_expressionfavorite from n_dao_reference_data
end type
global n_dao_expressionfavorite n_dao_expressionfavorite

type variables
Protected:
	String 	is_expressiontypename
	Long		il_SourceID
end variables

forward prototypes
public function string of_validate ()
public subroutine of_new ()
end prototypes

public function string of_validate ();//----------------------------------------------------------------------------------------------------------------------------------
//	Function:	of_validate()
//	Arguments:  NONE
//	Overview:   Verify uniqueness and that required fields have values.
//	Created by:	
//-----------------------------------------------------------------------------------------------------------------------------------
DWItemStatus	lenum_DWItemStatus

Long		ll_Idnty
Long		ll_SourceID
Long		ll_userid
Long		ll_CreatedByUserID
Long		ll_count
String	ls_Type
String	ls_ColumnName
String	ls_ColumnDescription
String	ls_Expression
String	ls_Datawindow

ll_Idnty						= This.GetItemNumber(1, 'Idnty')
ls_Type						= This.GetItemString(1, 'Type')
ll_SourceID					= This.GetItemNumber(1, 'SourceID')
ll_userid					= This.GetItemNumber(1, 'UserID')
ll_CreatedByUserID		= This.GetItemNumber(1, 'CreatedByUserID')
ls_ColumnName				= This.GetItemString(1, 'ColumnName')
ls_ColumnDescription		= This.GetItemString(1, 'ColumnDescription')
ls_Expression				= This.GetItemString(1, 'Expression')
lenum_DWItemStatus		= This.GetItemStatus(1, 0, Primary!)

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify Report Database description has been filled out.
//-----------------------------------------------------------------------------------------------------------------------------------
If isnull(ls_Type) or Len(Trim(ls_Type)) = 0 Then
	of_send_validation_message(1,'ExpressionFavorite','Type')
	Return 'The field with focus can not be empty'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify Report Database description has been filled out.
//-----------------------------------------------------------------------------------------------------------------------------------
If isnull(ls_ColumnName) or Len(Trim(ls_ColumnName)) = 0 Then
	of_send_validation_message(1,'ExpressionFavorite','ColumnName')
	Return 'The field with focus can not be empty'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify Report Database description has been filled out.
//-----------------------------------------------------------------------------------------------------------------------------------
If isnull(ls_ColumnDescription) or Len(Trim(ls_ColumnDescription)) = 0 Then
	of_send_validation_message(1,'ExpressionFavorite','ColumnDescription')
	Return 'The field with focus can not be empty'
End If

//-----------------------------------------------------------------------------------------------------------------------------------
// Verify Report Database description has been filled out.
//-----------------------------------------------------------------------------------------------------------------------------------
If isnull(ls_Expression) or Len(Trim(ls_Expression)) = 0 Then
	of_send_validation_message(1,'ExpressionFavorite','Expression')
	Return 'The field with focus can not be empty'
End If

If lenum_DWItemStatus = NewModIfied! Then
	ll_Idnty = 0
End If

If IsNull(ll_SourceID) Then
	If IsNull(ll_userid) Then
		Select	Count(*)
		Into		:ll_count
		From		cusfocus.expressionfavorite	(NoLock)
		Where		RTrim(LTrim(columnname))		= :ls_ColumnName
		And		type									= :ls_Type
		And		idnty									<> :ll_Idnty
		Using		SQLCA;
	Else
		Select	Count(*)
		Into		:ll_count
		From		cusfocus.expressionfavorite	(NoLock)
		Where		RTrim(LTrim(columnname))		= :ls_ColumnName
		And		type									= :ls_Type
		And		idnty									<> :ll_Idnty
		And		(userid								= :ll_userid
		Or			userid								Is Null)
		Using		SQLCA;
	End If
Else
	If IsNull(ll_userid) Then
		Select	Count(*)
		Into		:ll_count
		From		cusfocus.expressionfavorite	(NoLock)
		Where		RTrim(LTrim(columnname))		= :ls_ColumnName
		And		type									= :ls_Type
		And		(sourceid								= :ll_SourceID
		Or			sourceid								Is Null)
		And		idnty									<> :ll_Idnty
		Using		SQLCA;
	Else
		Select	Count(*)
		Into		:ll_count
		From		cusfocus.expressionfavorite	(NoLock)
		Where		RTrim(LTrim(columnname))		= :ls_ColumnName
		And		type									= :ls_Type
		And		(sourceid								= :ll_SourceID
		Or			sourceid								Is Null)
		And		(userid								= :ll_userid
		Or			userid								Is Null)
		And		idnty									<> :ll_Idnty
		Using		SQLCA;
	End If
End If

If ll_count > 0 Then
	This.of_send_validation_message(1,'ExpressionFavorite','ColumnName')
	
	If IsNull(ll_SourceID) Then
		Return 'An expression with that name has already been defined in the database.  Since this expression is being saved for all ' + is_expressiontypename + 's, this name could be taken by any expression on those ' + is_expressiontypename + 's' 
	ElseIf IsNull(ll_userid) Then
		Return 'An expression with that name has already been defined in the database.  Since this expression is being saved for all users, this name could be taken by any expression that you cannot see for another user' 
	Else
		Return 'An expression with that name has already been defined in the database'
	End If
End If

Return ''
end function

public subroutine of_new ();this.insertrow(0)
This.SetItem(1, 'CreatedByUserID', gn_globals.il_userid)
This.SetItem(1, 'UserID', gn_globals.il_userid)
This.SetItemStatus(1, 0, Primary!, NotModified!)
end subroutine

on n_dao_expressionfavorite.create
call super::create
end on

on n_dao_expressionfavorite.destroy
call super::destroy
end on

event constructor;call super::constructor;this.dataobject = 'd_dao_expressionfavorite'
is_qualifier = 'ExpressionFavorite'
it_transobject = SQLCA
This.of_SetTransObject(it_transobject)
end event

event ue_getitem;call super::ue_getitem;Choose Case Lower(Trim(as_column))
	Case 'gui'
		Return 'w_expressionfavorite_maintenance'
	Case 'allowallusers'
		If IsNull(This.GetItemNumber(1, 'UserID')) Then
			Return 'Y'
		Else
			Return 'N'
		End If
	Case 'expressiontypename'
		If Len(is_expressiontypename) > 0 Then
			Return is_expressiontypename
		Else
			Return ''
		End If
	Case 'saveforsourceid'
		If IsNull(This.GetItemNumber(1, 'SourceID')) Then
			Return 'N'
		Else
			Return 'Y'
		End If
	Case 'sourceidprovided'
		If IsNull(This.GetItemNumber(1, 'SourceID')) And IsNull(il_SourceID) Then
			Return 'N'
		Else
			Return 'Y'
		End If
	Case 'security'
		If This.RowCount() <= 0 Then Return 'Error:  The expression could not be found'
		
		If This.GetItemNumber(1, 'CreatedByUserID') <> gn_globals.il_userid Then
//			If Not gn_globals.in_security.of_check_role(gn_globals.il_userid, 1) Then
//				Return 'Error:  This expression is global, but you are not the creator of the expression or a system administrator'
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
End Choose

Return ''
end event

event ue_setitem;call super::ue_setitem;Long ll_null
SetNull(ll_null)

Choose Case Lower(Trim(as_column))
	Case 'allowallusers'
		Choose Case Upper(Trim(as_column))
			Case 'Y'
				This.SetItem(1, 'UserID', ll_null)
			Case Else
				This.SetItem(1, 'UserID', gn_globals.il_userid)
		End Choose
	Case 'expressiontypename'
		is_expressiontypename = as_data
	Case 'saveforsourceid'
		Choose Case Upper(Trim(as_data))
			Case 'Y'
				This.SetItem(1, 'SourceID', il_SourceID)
			Case Else
				il_SourceID = This.GetItemNumber(1, 'SourceID')
				This.SetItem(1, 'SourceID', ll_null)
		End Choose
End Choose

Return True
end event

