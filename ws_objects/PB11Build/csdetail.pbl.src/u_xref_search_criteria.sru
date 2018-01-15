$PBExportHeader$u_xref_search_criteria.sru
$PBExportComments$Search Criteria User Object
forward
global type u_xref_search_criteria from u_container_std
end type
type st_2 from statictext within u_xref_search_criteria
end type
type st_1 from statictext within u_xref_search_criteria
end type
type rb_group from radiobutton within u_xref_search_criteria
end type
type rb_member from radiobutton within u_xref_search_criteria
end type
type rb_provider from radiobutton within u_xref_search_criteria
end type
type cb_details from commandbutton within u_xref_search_criteria
end type
type cb_cancel from commandbutton within u_xref_search_criteria
end type
type cb_ok from commandbutton within u_xref_search_criteria
end type
type cb_search from commandbutton within u_xref_search_criteria
end type
type cb_clear from commandbutton within u_xref_search_criteria
end type
type dw_search_criteria from u_dw_search within u_xref_search_criteria
end type
type dw_matched_records from u_dw_std within u_xref_search_criteria
end type
type dw_case_detail_report from datawindow within u_xref_search_criteria
end type
type ln_1 from line within u_xref_search_criteria
end type
type ln_2 from line within u_xref_search_criteria
end type
type ln_3 from line within u_xref_search_criteria
end type
type ln_4 from line within u_xref_search_criteria
end type
type st_3 from statictext within u_xref_search_criteria
end type
type ln_5 from line within u_xref_search_criteria
end type
type ln_6 from line within u_xref_search_criteria
end type
end forward

global type u_xref_search_criteria from u_container_std
integer width = 2994
integer height = 1708
long backcolor = 79748288
event ue_rowselected pbm_custom01
st_2 st_2
st_1 st_1
rb_group rb_group
rb_member rb_member
rb_provider rb_provider
cb_details cb_details
cb_cancel cb_cancel
cb_ok cb_ok
cb_search cb_search
cb_clear cb_clear
dw_search_criteria dw_search_criteria
dw_matched_records dw_matched_records
dw_case_detail_report dw_case_detail_report
ln_1 ln_1
ln_2 ln_2
ln_3 ln_3
ln_4 ln_4
st_3 st_3
ln_5 ln_5
ln_6 ln_6
end type
global u_xref_search_criteria u_xref_search_criteria

type variables
BOOLEAN	i_bCancelSearch
BOOLEAN  i_bInSearch = FALSE

INTEGER	i_nRepSecurityLevel
INTEGER  i_nProviderKey

STRING	i_cCriteriaColumn[]
STRING	i_cSearchTable[]
STRING	i_cSearchColumn[]
STRING   i_cSearchType 
STRING   i_cMemberID
STRING   i_cSourceType = 'P'

W_XREF_SEARCH i_wParentWindow


end variables

forward prototypes
public subroutine fu_resizeline ()
public subroutine fu_updatedemographicfieldlabels ()
end prototypes

public subroutine fu_resizeline ();//***********************************************************************************************
//
//  Function: fu_resizeline
//  Purpose:  resize the footer separator line in the current matched records datawindow.
//
//  Date     Developer    Description
//  -------- ----------- ------------------------------------------------------------------------
//  06/18/01 C. Jackson  Original Version 
//***********************************************************************************************

INTEGER	l_nWidth, l_nWidthOffset

l_nWidthOffset = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
l_nWidth = INTEGER (dw_matched_records.Describe ("l_1.X2"))
dw_matched_records.Modify ("l_1.X2=" + STRING (l_nWidth + l_nWidthOffset))
end subroutine

public subroutine fu_updatedemographicfieldlabels ();/*****************************************************************************************
   Function:   fu_UpdateDemographicFieldLabels
   Purpose:    Update the labels of the datawindows on this container object.
   Parameters: NONE
   Returns:    NONE

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	06/11/03 M. Caruso    Created.
	07/03/03 M. Caruso    Modified to call gf_AllowQuotesInLabels ().
*****************************************************************************************/

INTEGER		l_nRowCount, l_nRow
STRING		l_cSQL, l_cSyntax, l_cErrorMsg, l_cLabelName, l_cLabelText
DATASTORE	l_dsFieldLables

// build the SQL for the datastore
l_cSQL = "SELECT column_name, field_label " + &
			"FROM cusfocus.field_definitions " + &
			"WHERE field_order = 0 " + &
			"AND source_type = '" + i_cSourceType + "'"
			
// convert the SQl to datastore syntax
l_cSyntax = SQLCA.SyntaxFromSQL(l_cSQL, '', l_cErrorMsg)

// create the datastore and retrieve the records
IF Len(l_cErrorMsg) > 0 THEN
	MessageBox (gs_appname, l_cErrorMsg)
	RETURN
ELSE
	l_dsFieldLables = CREATE DataStore
	l_dsFieldLables.Create(l_cSyntax, l_cErrorMsg)
	IF Len(l_cErrorMsg) > 0 THEN
		MessageBox (gs_appname, l_cErrorMsg)
		RETURN
	END IF
END IF

l_dsFieldLables.SetTransObject(SQLCA)
l_nRowCount = l_dsFieldLables.Retrieve()

// update the datawindows
FOR l_nRow = 1 TO l_nRowCount
	
	l_cLabelName = l_dsFieldLables.GetItemString (l_nRow, "column_name") + '_t'
	l_cLabelText = gf_AllowQuotesInLabels (l_dsFieldLables.GetItemString (l_nRow, "field_label") + ':')
	
	IF dw_search_criteria.Describe (l_cLabelName + ".Text") <> "!" THEN
		dw_search_criteria.Modify (l_cLabelName + ".Text='" + l_cLabelText + "'")
	END IF
	
	IF dw_matched_records.Describe (l_cLabelName + ".Text") <> "!" THEN
		dw_matched_records.Modify (l_cLabelName + ".Text='" + l_cLabelText + "'")
	END IF
	
NEXT
end subroutine

on u_xref_search_criteria.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.rb_group=create rb_group
this.rb_member=create rb_member
this.rb_provider=create rb_provider
this.cb_details=create cb_details
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cb_search=create cb_search
this.cb_clear=create cb_clear
this.dw_search_criteria=create dw_search_criteria
this.dw_matched_records=create dw_matched_records
this.dw_case_detail_report=create dw_case_detail_report
this.ln_1=create ln_1
this.ln_2=create ln_2
this.ln_3=create ln_3
this.ln_4=create ln_4
this.st_3=create st_3
this.ln_5=create ln_5
this.ln_6=create ln_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rb_group
this.Control[iCurrent+4]=this.rb_member
this.Control[iCurrent+5]=this.rb_provider
this.Control[iCurrent+6]=this.cb_details
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.cb_ok
this.Control[iCurrent+9]=this.cb_search
this.Control[iCurrent+10]=this.cb_clear
this.Control[iCurrent+11]=this.dw_search_criteria
this.Control[iCurrent+12]=this.dw_matched_records
this.Control[iCurrent+13]=this.dw_case_detail_report
this.Control[iCurrent+14]=this.ln_1
this.Control[iCurrent+15]=this.ln_2
this.Control[iCurrent+16]=this.ln_3
this.Control[iCurrent+17]=this.ln_4
this.Control[iCurrent+18]=this.st_3
this.Control[iCurrent+19]=this.ln_5
this.Control[iCurrent+20]=this.ln_6
end on

on u_xref_search_criteria.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_group)
destroy(this.rb_member)
destroy(this.rb_provider)
destroy(this.cb_details)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cb_search)
destroy(this.cb_clear)
destroy(this.dw_search_criteria)
destroy(this.dw_matched_records)
destroy(this.dw_case_detail_report)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.ln_3)
destroy(this.ln_4)
destroy(this.st_3)
destroy(this.ln_5)
destroy(this.ln_6)
end on

event pc_setvariables;call super::pc_setvariables;//*********************************************************************************************
//
//  Event:   pc_setvariables
//  Purpose: Initialize instance variables for this window.
//						
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  07/26/01 M. Caruso     Created.
//*********************************************************************************************

STRING	l_cUserID

l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT rec_confidentiality_level INTO :i_nRepSecurityLevel
FROM cusfocus.cusfocus_user WHERE user_id = :l_cUserID;

IF IsNull (i_nRepSecurityLevel) THEN
	i_nRepSecurityLevel = 0
END IF
end event

event pc_setoptions;call super::pc_setoptions;//**********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To Set Defaults
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/31/02 C. Jackson  Original Version
//  02/06/03 C. Jackson  Set radio button to source type of previously defined XRef, or provider
//                       by default
//**********************************************************************************************

LONG l_nRow

l_nRow = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details.GetRow()

i_cSourceType = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details.GetItemString(l_nRow,'case_log_xref_source_type')

CHOOSE CASE i_cSourceType
	CASE 'C'
		rb_member.Checked = TRUE
		rb_member.Event Trigger clicked( )
		
	CASE 'E'
		rb_group.Checked = TRUE
		rb_group.Event Trigger clicked( )
		
	CASE ELSE
		rb_provider.Checked = TRUE
		rb_provider.Event Trigger clicked( )
		
END CHOOSE

//dw_search_criteria.SetRedraw(FALSE)
//dw_matched_records.SetRedraw(FALSE)
//
////------------------------------------------------------------------------------------
////		Swap datawindow objects for the search datawindow control
////------------------------------------------------------------------------------------
//dw_search_criteria.DataObject = 'd_xref_search_provider'
//dw_search_criteria.InsertRow(0)
//
//dw_matched_records.fu_Swap('d_xref_matched_providers', dw_matched_records.c_IgnoreChanges, &
//									dw_matched_records.c_SelectOnRowFocusChange + &
//									dw_matched_records.c_NoRetrieveOnOpen + &
//									dw_matched_records.c_TabularFormStyle + &
//									dw_matched_records.c_NoActiveRowPointer + &
//									dw_matched_records.c_NoInactiveRowPointer + &
//									dw_matched_records.c_NoMenuButtonActivation + &
//									dw_matched_records.c_SortClickedOK )
//
////------------------------------------------------------------------------------------
////		Wire the Search object to uo_dw_main and load the Provider types
////------------------------------------------------------------------------------------
//i_cCriteriaColumn[1] = 'provider_id'
//i_cSearchTable[1] = 'cusfocus.provider_of_service'
//i_cSearchColumn[1] = 'provider_id'
//i_cCriteriaColumn[2] = 'vendor_id'
//i_cSearchTable[2] = 'cusfocus.provider_of_service'
//i_cSearchColumn[2] = 'vendor_id'
//i_cCriteriaColumn[3] = 'provid_name'
//i_cSearchTable[3] = 'cusfocus.provider_of_service'
//i_cSearchColumn[3] = 'provid_name'
//i_cCriteriaColumn[4] = 'provid_name_2'
//i_cSearchTable[4] = 'cusfocus.provider_of_service'
//i_cSearchColumn[4] = 'provid_name_2'
//
//dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, &
//	i_cSearchTable[], i_cSearchColumn[], SQLCA)
//	
//w_xref_search.Title = 'Search Provider'
//dw_search_criteria.SetTransObject (SQLCA)
//
//dw_search_criteria.InsertRow (0)
//
//dw_search_criteria.SetRedraw(TRUE)
//dw_matched_records.SetRedraw(TRUE)
//
//SetReDraw(TRUE)
//THIS.Show()
//
end event

type st_2 from statictext within u_xref_search_criteria
integer x = 32
integer y = 24
integer width = 498
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cross Reference Type"
boolean focusrectangle = false
end type

type st_1 from statictext within u_xref_search_criteria
integer x = 32
integer y = 224
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search Criteria"
boolean focusrectangle = false
end type

type rb_group from radiobutton within u_xref_search_criteria
integer x = 1120
integer y = 96
integer width = 402
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Group"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To Set Source type for swap
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  01/28/03 C. Jackson  Original Version
//**********************************************************************************************

i_cSourceType = 'E'

dw_search_criteria.SetRedraw(FALSE)
dw_matched_records.SetRedraw(FALSE)


//------------------------------------------------------------------------------------
//		Swap datawindow objects for the search datawindow control
//------------------------------------------------------------------------------------
dw_search_criteria.DataObject = 'd_xref_search_group'
dw_search_criteria.InsertRow(0)

dw_matched_records.fu_Swap('d_xref_matched_groups', dw_matched_records.c_IgnoreChanges, &
									dw_matched_records.c_SelectOnRowFocusChange + &
									dw_matched_records.c_NoRetrieveOnOpen + &
									dw_matched_records.c_TabularFormStyle + &
									dw_matched_records.c_NoActiveRowPointer + &
									dw_matched_records.c_NoInactiveRowPointer + &
									dw_matched_records.c_NoMenuButtonActivation + &
									dw_matched_records.c_NoQuery + &
									dw_matched_records.c_SortClickedOK )

i_cCriteriaColumn[1] = "group_id"
i_cSearchTable[1] = "cusfocus.employer_group"
i_cSearchColumn[1] = "group_id"

i_cCriteriaColumn[2] = "employ_group_name"
i_cSearchTable[2] = "cusfocus.employer_group"
i_cSearchColumn[2] = "employ_group_name"

//------------------------------------------------------------------------------------
//		Wire the Search object to uo_dw_main.
//------------------------------------------------------------------------------------

dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, &
	i_cSearchTable[], i_cSearchColumn[], SQLCA)
	
w_xref_search.Title = 'Search Group'
dw_search_criteria.SetTransObject (SQLCA)

dw_search_criteria.InsertRow (0)

fu_UpdateDemographicFieldLabels ()

dw_search_criteria.SetRedraw(TRUE)
dw_matched_records.SetRedraw(TRUE)

dw_search_criteria.SetFocus()
dw_search_criteria.SetColumn(1)
end event

type rb_member from radiobutton within u_xref_search_criteria
integer x = 640
integer y = 96
integer width = 402
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Member"
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To Set Source type for swap
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/31/02 C. Jackson  Original Version
//**********************************************************************************************

i_cSourceType = 'C'

dw_search_criteria.SetRedraw(FALSE)
dw_matched_records.SetRedraw(FALSE)


//------------------------------------------------------------------------------------
//		Swap datawindow objects for the search datawindow control
//------------------------------------------------------------------------------------
dw_search_criteria.DataObject = 'd_xref_search_consumer'
dw_search_criteria.InsertRow(0)

dw_matched_records.fu_Swap('d_xref_matched_consumers', dw_matched_records.c_IgnoreChanges, &
									dw_matched_records.c_SelectOnRowFocusChange + &
									dw_matched_records.c_NoRetrieveOnOpen + &
									dw_matched_records.c_TabularFormStyle + &
									dw_matched_records.c_NoActiveRowPointer + &
									dw_matched_records.c_NoInactiveRowPointer + &
									dw_matched_records.c_NoMenuButtonActivation + &
									dw_matched_records.c_NoQuery + &
									dw_matched_records.c_SortClickedOK )

i_cCriteriaColumn[1] = "consumer_id"
i_cSearchTable[1] = "cusfocus.consumer"
i_cSearchColumn[1] = "consumer_id"
i_cCriteriaColumn[2] = "consum_last_name"
i_cSearchTable[2] = "cusfocus.consumer"
i_cSearchColumn[2] = "consum_last_name"
i_cCriteriaColumn[3] = "consum_first_name"
i_cSearchTable[3] = "cusfocus.consumer"
i_cSearchColumn[3] = "consum_first_name"

//------------------------------------------------------------------------------------
//		Wire the Search object to uo_dw_main.
//------------------------------------------------------------------------------------

dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, &
	i_cSearchTable[], i_cSearchColumn[], SQLCA)
	
w_xref_search.Title = 'Search Member'
dw_search_criteria.SetTransObject (SQLCA)

dw_search_criteria.InsertRow (0)

fu_UpdateDemographicFieldLabels ()

dw_search_criteria.SetRedraw(TRUE)
dw_matched_records.SetRedraw(TRUE)

dw_search_criteria.SetFocus()
dw_search_criteria.SetColumn(1)
end event

type rb_provider from radiobutton within u_xref_search_criteria
integer x = 160
integer y = 96
integer width = 402
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Provider"
boolean checked = true
end type

event clicked;//**********************************************************************************************
//
//  Event:   clicked
//  Purpose: To Set Source type for swap
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  05/31/02 C. Jackson  Original Version
//**********************************************************************************************

i_cSourceType = 'P'

dw_search_criteria.SetRedraw(FALSE)
dw_matched_records.SetRedraw(FALSE)


//------------------------------------------------------------------------------------
//		Swap datawindow objects for the search datawindow control
//------------------------------------------------------------------------------------
dw_search_criteria.DataObject = 'd_xref_search_provider'
dw_search_criteria.InsertRow(0)

dw_matched_records.fu_Swap('d_xref_matched_providers', dw_matched_records.c_IgnoreChanges, &
									dw_matched_records.c_SelectOnRowFocusChange + &
									dw_matched_records.c_NoRetrieveOnOpen + &
									dw_matched_records.c_TabularFormStyle + &
									dw_matched_records.c_NoActiveRowPointer + &
									dw_matched_records.c_NoInactiveRowPointer + &
									dw_matched_records.c_NoMenuButtonActivation + &
									dw_matched_records.c_SortClickedOK )

//------------------------------------------------------------------------------------
//		Wire the Search object to uo_dw_main and load the Provider types
//------------------------------------------------------------------------------------
i_cCriteriaColumn[1] = 'provider_id'
i_cSearchTable[1] = 'cusfocus.provider_of_service'
i_cSearchColumn[1] = 'provider_id'
i_cCriteriaColumn[2] = 'vendor_id'
i_cSearchTable[2] = 'cusfocus.provider_of_service'
i_cSearchColumn[2] = 'vendor_id'
i_cCriteriaColumn[3] = 'provid_name'
i_cSearchTable[3] = 'cusfocus.provider_of_service'
i_cSearchColumn[3] = 'provid_name'
i_cCriteriaColumn[4] = 'provid_name_2'
i_cSearchTable[4] = 'cusfocus.provider_of_service'
i_cSearchColumn[4] = 'provid_name_2'

dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, &
	i_cSearchTable[], i_cSearchColumn[], SQLCA)
	
w_xref_search.Title = 'Search Provider'
dw_search_criteria.SetTransObject (SQLCA)

dw_search_criteria.InsertRow (0)

fu_UpdateDemographicFieldLabels ()

dw_search_criteria.SetRedraw(TRUE)
dw_matched_records.SetRedraw(TRUE)

dw_search_criteria.SetFocus()
dw_search_criteria.SetColumn(1)
end event

type cb_details from commandbutton within u_xref_search_criteria
integer x = 32
integer y = 1564
integer width = 320
integer height = 88
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Details"
end type

event clicked;//***********************************************************************************************
//
//  Event:   clicked
//  Purpose: To open the Demographics Details for the selected Cross Reference
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  01/15/02 C. Jackson  Original Version
//  01/28/03 C. Jackson  Add Group Cross Reference
//***********************************************************************************************

STRING l_cParent, l_cParm, l_cXRefSourceType, l_cXRefSubjectID, l_cXRefProviderType
LONG l_nRow

l_cParent = 'u_xref_search_criteria'

l_nRow = dw_matched_records.GetRow()

IF rb_provider.Checked THEN 
	l_cXRefSourceType = 'P' 
ELSEIF rb_member.Checked THEN
	l_cXRefSourceType = 'C'
ELSE
	l_cXRefSourceType = 'E'
END IF

IF l_cXRefSourceType = 'P' THEN
	l_cXRefSubjectID  = STRING(dw_matched_records.GetItemNumber(l_nRow,'provider_key'))
	l_cXRefProviderType = dw_matched_records.GetItemString(l_nRow,'provider_type')
	l_cParm = l_cParent + ',' + l_cXRefSourceType + ',' + l_cXRefSubjectId + ',' + l_cXRefProviderType
	
ELSEIF l_cXRefSourcetype = 'C' THEN
	l_cXRefSubjectID  = STRING(dw_matched_records.GetItemString(l_nRow,'consumer_id'))
	l_cParm = l_cParent + ',' + l_cXRefSourceType + ',' + l_cXRefSubjectId
ELSE
	l_cXRefSubjectID  = STRING(dw_matched_records.GetItemString(l_nRow,'group_id'))
	l_cParm = l_cParent + ',' + l_cXRefSourceType + ',' + l_cXRefSubjectId
END IF

FWCA.MGR.fu_OpenWindow(w_cross_ref_details, l_cParm)


end event

type cb_cancel from commandbutton within u_xref_search_criteria
integer x = 1659
integer y = 1564
integer width = 320
integer height = 88
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ca&ncel"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To close with window with no return
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  06/19/01 C. Jackson  Original Version
//  10/30/01 C. Jackson  Correct Cross Reference
//  11/28/01 C. Jackson  Added If statement to prevent processing if currently searching
//  12/15/02 C. Jackson  Add security to prevent a user with inadequate security from seeing the
//                       Cross Referenced Name.  ('Access Denied' is displayed)
//  05/31/02 C. Jackson  Removed code setting Cross Ref Values, has been moved to buttonclicked 
//                       of u_tabpage_case_details
//************************************************************************************************

	Close(w_xref_search)
	

end event

type cb_ok from commandbutton within u_xref_search_criteria
integer x = 1312
integer y = 1564
integer width = 320
integer height = 88
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: Get the selected row information and populate the case_log_xref_subject_id
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  06/19/01 C. Jackson  Original Version
//  07/06/01 C. Jackson  SetItemStatus of xref_source_type back to DataModified! so it will be 
//                       saved.  (SCR 2140)
//  09/25/01 C. Jackson  Add name fields to search (SCR 2426)
//  10/30/01 C. Jackson  Correct Cross Reference 
//  11/28/01 C. Jackson  Only process if not currently doing a search
//  12/15/02 C. Jackson  Add security to prevent a user with inadequate security from seeing the
//                       Cross Referenced Name.  ('Access Denied' is displayed)
//************************************************************************************************

STRING l_cProviderKey, l_cName, l_cName2, l_cName3, l_cXRefSubjectID, l_cProviderType, l_cNull
STRING l_cXRefCCSubject, l_cProviderName, l_cProviderName2, l_cConsumLastName, l_cConsumFirstName
STRING l_cLogin, l_cParm
LONG l_nRow, l_nProviderKey, l_nUserSecurity, l_nDemogSecurity
DataWindow l_dwCaseDetails
UserObject l_uoCaseDetails

SETNULL(l_cNull)

l_cLogin = OBJCA.WIN.fu_GetLogin(SQLCA)

SELECT rec_confidentiality_level 
  INTO :l_nUserSecurity
  FROM cusfocus.cusfocus_user
 WHERE user_id = :l_cLogin
 USING SQLCA;

IF NOT i_bInSearch THEN // only process if not currently doing a search

	l_dwCaseDetails = w_create_maintain_case.i_uoCaseDetails.tab_folder.tabpage_case_details.dw_case_details
	
	l_nRow = dw_matched_records.GetRow()
	
	IF l_nRow <= 0 THEN
	
		messagebox(gs_AppName,'No record selected.')
		RETURN
		
	ELSE
	
		CHOOSE CASE i_cSourceType
			CASE 'P'
				l_nProviderKey = dw_matched_records.GetItemNumber(l_nRow,'provider_key')
				l_cXRefSubjectID = STRING(l_nProviderKey)
				
			CASE 'C'
				l_cXRefSubjectID = dw_matched_records.GetItemString(l_nRow,'consumer_id')
				
			CASE 'E'
				l_cXRefSubjectID = dw_matched_records.GetItemString(l_nRow,'group_id')
	
		END CHOOSE
		
		l_cXRefSubjectID = i_cSourceType + l_cXRefSubjectID

		CloseWithReturn(w_xref_search,l_cXRefSubjectID)
	
	END IF
	
END IF


end event

type cb_search from commandbutton within u_xref_search_criteria
integer x = 1609
integer y = 304
integer width = 320
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Search"
end type

event clicked;//************************************************************************************************
//
//  Event:   clicked
//  Purpose: To trigger the pc_search event from PowerClass
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  06/18/01 C. Jackson  Original Version
//  07/26/01 M. Caruso   Added code to check Vendor ID field when searching Providers.
//  09/25/01 C. Jackson  Add name fields to the search (SCR 2426)
//  11/28/01 C. Jackson  Added If statement to prevent processing if currently searching
//  01/28/03 C. Jackson  Add Group Cross Reference
//************************************************************************************************

DataWindow l_dwSearchCriteria
BOOLEAN l_bContinue
LONG l_nRow, l_nIndex
STRING l_cValue

IF NOT i_bInSearch THEN  // only process if not currently doing a search

	l_dwSearchCriteria = w_xref_search.uo_search_criteria.dw_search_criteria
	
	dw_search_criteria.AcceptText()
	
	IF IsValid(l_dwSearchCriteria) THEN
			
		/***************************************************************************************
		Check for search criteria.  If no entries were made, abort the search process.
		***************************************************************************************/
		l_bContinue = FALSE
		l_nRow = l_dwSearchCriteria.GetRow()
		
		IF i_cSourceType = 'P' THEN
			
		
			l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'provider_id'))
			IF IsNull (l_cValue) OR l_cValue = '' THEN
				l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'vendor_id'))
				IF IsNull (l_cValue) OR l_cValue = '' THEN
					l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'provid_name'))
					IF IsNull (l_cValue) OR l_cValue = '' THEN
						l_cValue = Trim (l_dwSearchCriteria.GetItemString(l_nRow, 'provid_name_2'))
					END IF
				END IF
				
			END IF
				
			IF IsNull (l_cValue) OR l_cValue = '' THEN
				l_bContinue = FALSE
			ELSE
				// Full wildcard searching and empty string entries are blocked.
				IF (l_cValue <> "%") THEN
					l_bContinue = TRUE
				END IF
			END IF
				
		ELSEIF i_cSourceType = 'C' THEN
			
			l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'consumer_id'))
			IF IsNull (l_cValue ) OR l_cValue = '' THEN
				l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'consum_last_name'))
				IF IsNull (l_cValue) OR l_cValue = '' THEN
					l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'consum_first_name'))
				END IF
				
			END IF
				
			IF IsNull (l_cValue) OR l_cValue = '' THEN
				l_bContinue = FALSE
			ELSE
				
				// Full wildcard searching and empty string entries are blocked.
				IF (l_cValue <> "%") THEN
					l_bContinue = TRUE
				END IF
				
			END IF

		ELSEIF i_cSourceType = 'E' THEN
			
			l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'group_id'))
			IF IsNull (l_cValue ) OR l_cValue = '' THEN
				l_cValue = Trim (l_dwSearchCriteria.GetItemString (l_nRow, 'employ_group_name'))
				
			END IF
				
			IF IsNull (l_cValue) OR l_cValue = '' THEN
				l_bContinue = FALSE
			ELSE
				
				// Full wildcard searching and empty string entries are blocked.
				IF (l_cValue <> "%") THEN
					l_bContinue = TRUE
				END IF
				
			END IF

		END IF
		
		
		IF l_bContinue THEN
			
	
				i_bInSearch = TRUE
				w_xref_search.TriggerEvent('pc_search')
				i_bInSearch = FALSE
			
		ELSE
			
			MessageBox ("No Search Criteria", "You must enter criteria to perform a search.")
			IF dw_search_criteria.DataObject = 'd_xref_search_provider' THEN
	
				dw_search_criteria.SetFocus()
				dw_search_criteria.SetColumn('provider_id')
				
			ELSEIF dw_search_criteria.DataObject = 'd_xref_search_consumer' THEN
				
				dw_search_criteria.SetFocus()
				dw_search_criteria.SetColumn('consumer_id')
				
			ELSE
				
				dw_search_criteria.SetFocus()
				dw_search_criteria.SetColumn('group_id')
			
			END IF
	
			
		END IF
					
				
	END IF
	
	
END IF
end event

type cb_clear from commandbutton within u_xref_search_criteria
integer x = 1609
integer y = 432
integer width = 320
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Clear"
end type

event clicked;//*********************************************************************************************
//
//  Event:   clicked
//  Purpose: Cancel the current search on the search tab.
//  
//  Date     Developer   Describe
//  -------- ----------- ----------------------------------------------------------------------
//  06/18/01 C. Jackson  Original Version
//  09/25/01 C. Jackson  Add name fields (SCR 2426)
//  11/28/01 C. Jackson  Added If statement to prevent processing if currently searching
//  01/28/03 C. Jackson  Add Group Cross Reference
//*********************************************************************************************

STRING l_cNull

IF NOT i_bInSearch THEN  // only process if not currently doing a search
	
	SETNULL(l_cNull)
	
	IF dw_search_criteria.DataObject = 'd_xref_search_provider' THEN
	
		dw_search_criteria.SetItem(1,'provider_id',l_cNull)
		dw_search_criteria.SetItem(1,'vendor_id',l_cNull)
		dw_search_criteria.SetItem(1,'provid_name',l_cNull)
		dw_search_criteria.SetItem(1,'provid_name_2',l_cNull)
		dw_search_criteria.SetFocus()
		dw_search_criteria.SetColumn('provider_id')
		
	ELSEIF dw_search_criteria.DataObject = 'd_xref_search_consumer' THEN
		
		dw_search_criteria.SetItem(1,'consumer_id',l_cNull)
		dw_search_criteria.SetItem(1,'consum_last_name',l_cNull)
		dw_search_criteria.SetItem(1,'consum_first_name',l_cNull)
		dw_search_criteria.SetFocus()
		dw_search_criteria.SetColumn('consumer_id')
		
	ELSE
		
		dw_search_criteria.SetItem(1,'group_id',l_cNull)
		dw_search_criteria.SetItem(1,'employ_group_name',l_cNull)
		dw_search_criteria.SetFocus()
		dw_search_criteria.SetColumn('group_id')
	
	END IF
	
	// Trigger search to blank out results datawindow
	dw_matched_records.Reset()
	cb_details.Enabled = FALSE
	
END IF
end event

type dw_search_criteria from u_dw_search within u_xref_search_criteria
event ue_searchtrigger pbm_dwnkey
integer x = 59
integer y = 296
integer width = 1541
integer height = 352
integer taborder = 40
string dataobject = "d_xref_search_provider"
boolean border = false
end type

event getfocus;call super::getfocus;/*****************************************************************************************
   Event:      getfocus
   Purpose:    Code to process when this datawindow gains focus.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/26/01 M. Caruso    Created.
*****************************************************************************************/

cb_OK.Default = FALSE
cb_Search.Default = TRUE

end event

type dw_matched_records from u_dw_std within u_xref_search_criteria
event ue_selecttrigger pbm_dwnkey
integer x = 32
integer y = 712
integer width = 1947
integer height = 768
integer taborder = 70
string dataobject = "d_xref_matched_providers"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_retrieve;call super::pcd_retrieve;//*********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: To retrieve the data, set appropriate tabs and select appropriate 
//           rows.
//						
//  Date     Developer     Description
//  -------- ------------- --------------------------------------------------------------------
//  06/18/01 C. Jackson    Original Version
//  08/07/01 C. Jackson    SetReDraw(FALSE) before retrieve and then to TRUE after so that all
//                         records are displayed before the user is able to select one.
//*********************************************************************************************

STRING l_cXRefSubjectID
LONG l_nReturn

THIS.SetReDraw(FALSE)
l_nReturn = Retrieve (i_nRepSecurityLevel)

IF l_nReturn > 0 THEN
	cb_details.Enabled = TRUE
END IF

CHOOSE CASE l_nReturn
	CASE IS < 0
		Error.i_FWError = c_Fatal
		
	CASE 0
		Error.i_FWError = c_Success
		
	CASE ELSE
		Error.i_FWError = c_Success
		
		CHOOSE CASE DataObject
			CASE 'd_xref_matched_consumers'
				i_cSearchType = 'C'
				l_cXRefSubjectID = GetItemString(1, 'consumer_id')
	
			CASE 'd_xref_matched_providers'
				i_cSearchType = 'P'
				l_cXRefSubjectID = GetItemString(1, 'provider_id')
		END CHOOSE
END CHOOSE


THIS.SetReDraw(TRUE)
end event

event pcd_pickedrow;call super::pcd_pickedrow;//****************************************************************************************
//
//		Event:	pcd_pickedrow
//		Purpose:	To determine what row the user selected and get the Cross Reference ID
//						
//	 Date     Developer    Description
//	 -------- ------------ ----------------------------------------------------------------
//	 06/18/01 C. Jackson   Original Version
//
//**************************************************************************************/

STRING l_cXRefSubjectID

CHOOSE CASE DataObject

	CASE 'd_xref_matched_consumers'
		l_cXRefSubjectID = GetItemString(i_CursorRow, 'consumer_id')
	
	CASE 'd_matched_providers'
		l_cXRefSubjectID = GetItemString(i_CursorRow, 'provider_id')
		
END CHOOSE


end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: automatically grab the ID of the selected Consumer/Provider and insert into the
//           case_log_xref_subject_id field on the details tab
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  06/18/01 C. Jackson  Original Version
//  07/27/01 M. Caruso   Check if OK button is Enabled before triggering clicked event.
//  08/09/01 M. Caruso   Only process is rows exist in the datawindow.
//***********************************************************************************************

IF NOT i_bInSearch THEN
				  
	IF RowCount () > 0 THEN
		IF cb_OK.Enabled THEN
			cb_OK.TriggerEvent(Clicked!)
		END IF
	END IF
	
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: initialize the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  06/18/01 C. Jackson  Original Version
//***********************************************************************************************

fu_SetOptions( SQLCA, c_NullDW, c_SelectOnRowFocusChange + &
 										  c_NoRetrieveOnOpen + &
										  c_TabularFormStyle + &
										  c_NoActiveRowPointer + &
										  c_NoInactiveRowPointer + &
										  c_NoMenuButtonActivation + &
										  c_NoEnablePopup + &
										  c_SortClickedOK )

of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	
	// make the separator line resizeable
	inv_resize.of_Register ("l_1", "ScaleToRight")
	
END IF
end event

event retrieverow;call super::retrieverow;//***********************************************************************************************
//
//  Event:   retrieverow
//  Purpose: Occurs after a row has been retrieved.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  06/18/01 C. Jackson  Original Version
//  
//***********************************************************************************************


IF i_bcancelsearch THEN
	RETURN 1
ELSE
	RETURN 0
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;/*****************************************************************************************
   Event:      rowfocuschanged
   Purpose:    Code to process after the current row in the datawindow has changed.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/26/01 M. Caruso    Created.
	06/30/03 M. Caruso    Removed conditional setting of confidentiality_level field name
								 since all datawindows now reference it as the same name.
*****************************************************************************************/

STRING	l_cFieldName
LONG	l_nSecurityLevel

IF RowCount () > 0 THEN
	
//	IF i_cSourceType = 'C' OR i_cSourceType = 'E' THEN
//		l_cFieldName = 'confidentiality_level'
//	ELSE
//		l_cFieldName = 'provider_of_service_confidentiality_leve'
//	END IF
//
//	l_nSecurityLevel = GetItemNumber (currentrow, l_cFieldName)

	l_nSecurityLevel = GetItemNumber (currentrow, 'confidentiality_level')
	IF l_nSecurityLevel > i_nRepSecurityLevel THEN
		cb_OK.Enabled = FALSE
		cb_Details.Enabled = FALSE
	ELSE
		cb_OK.Enabled = TRUE
		cb_Details.Enabled = TRUE
	END IF
	
END IF
end event

event getfocus;call super::getfocus;/*****************************************************************************************
   Event:      getfocus
   Purpose:    Code to process when this datawindow gains focus.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/26/01 M. Caruso    Created.
*****************************************************************************************/

cb_Search.Default = FALSE
cb_OK.Default = TRUE
end event

type dw_case_detail_report from datawindow within u_xref_search_criteria
boolean visible = false
integer x = 5
integer width = 3301
integer height = 1704
integer taborder = 110
string dataobject = "d_case_detail_history_report"
boolean livescroll = true
end type

type ln_1 from line within u_xref_search_criteria
long linecolor = 8421504
integer linethickness = 4
integer beginx = 398
integer beginy = 248
integer endx = 1970
integer endy = 248
end type

type ln_2 from line within u_xref_search_criteria
long linecolor = 16777215
integer linethickness = 4
integer beginx = 398
integer beginy = 252
integer endx = 1970
integer endy = 252
end type

type ln_3 from line within u_xref_search_criteria
long linecolor = 8421504
integer linethickness = 4
integer beginx = 558
integer beginy = 52
integer endx = 1970
integer endy = 52
end type

type ln_4 from line within u_xref_search_criteria
long linecolor = 16777215
integer linethickness = 4
integer beginx = 558
integer beginy = 56
integer endx = 1970
integer endy = 56
end type

type st_3 from statictext within u_xref_search_criteria
integer y = 1516
integer width = 3500
integer height = 184
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217747
boolean focusrectangle = false
end type

type ln_5 from line within u_xref_search_criteria
long linecolor = 8421504
integer linethickness = 4
integer beginx = 5
integer beginy = 1508
integer endx = 3502
integer endy = 1508
end type

type ln_6 from line within u_xref_search_criteria
long linecolor = 16777215
integer linethickness = 4
integer beginx = 5
integer beginy = 1512
integer endx = 3502
integer endy = 1512
end type

