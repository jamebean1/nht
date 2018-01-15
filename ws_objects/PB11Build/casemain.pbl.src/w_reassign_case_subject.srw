$PBExportHeader$w_reassign_case_subject.srw
$PBExportComments$Re-Assign Case Subject Response Window
forward
global type w_reassign_case_subject from w_response_std
end type
type st_3 from statictext within w_reassign_case_subject
end type
type p_1 from picture within w_reassign_case_subject
end type
type st_1 from statictext within w_reassign_case_subject
end type
type st_2 from statictext within w_reassign_case_subject
end type
type cb_clear from commandbutton within w_reassign_case_subject
end type
type rb_employer from radiobutton within w_reassign_case_subject
end type
type rb_provider from radiobutton within w_reassign_case_subject
end type
type rb_consumer from radiobutton within w_reassign_case_subject
end type
type gb_1 from groupbox within w_reassign_case_subject
end type
type cb_search from commandbutton within w_reassign_case_subject
end type
type dw_search_criteria from u_dw_search within w_reassign_case_subject
end type
type dw_matched_records from u_dw_std within w_reassign_case_subject
end type
type ln_1 from line within w_reassign_case_subject
end type
type ln_2 from line within w_reassign_case_subject
end type
type cb_ok from commandbutton within w_reassign_case_subject
end type
type cb_cancel from commandbutton within w_reassign_case_subject
end type
type ln_3 from line within w_reassign_case_subject
end type
type ln_4 from line within w_reassign_case_subject
end type
end forward

global type w_reassign_case_subject from w_response_std
integer x = 343
integer y = 220
integer width = 2930
integer height = 2084
string title = "Reassign Other Case Source"
st_3 st_3
p_1 p_1
st_1 st_1
st_2 st_2
cb_clear cb_clear
rb_employer rb_employer
rb_provider rb_provider
rb_consumer rb_consumer
gb_1 gb_1
cb_search cb_search
dw_search_criteria dw_search_criteria
dw_matched_records dw_matched_records
ln_1 ln_1
ln_2 ln_2
cb_ok cb_ok
cb_cancel cb_cancel
ln_3 ln_3
ln_4 ln_4
end type
global w_reassign_case_subject w_reassign_case_subject

type variables
BOOLEAN	i_bButtonClose

INTEGER	i_nRepSecurityLevel

STRING	i_cCriteriaColumn[]
STRING	i_cSearchTable[]
STRING	i_cSearchColumn[]

STRING	i_cCaseSubject
STRING	i_cProviderType

STRING	i_cConsumer = 'C'
STRING	i_cEmployer  = 'E'
STRING	i_cProvider   = 'P'

STRING	i_cSourceType = 'C'

STRING	i_cAllCases
end variables

on w_reassign_case_subject.create
int iCurrent
call super::create
this.st_3=create st_3
this.p_1=create p_1
this.st_1=create st_1
this.st_2=create st_2
this.cb_clear=create cb_clear
this.rb_employer=create rb_employer
this.rb_provider=create rb_provider
this.rb_consumer=create rb_consumer
this.gb_1=create gb_1
this.cb_search=create cb_search
this.dw_search_criteria=create dw_search_criteria
this.dw_matched_records=create dw_matched_records
this.ln_1=create ln_1
this.ln_2=create ln_2
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.ln_3=create ln_3
this.ln_4=create ln_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.p_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_clear
this.Control[iCurrent+6]=this.rb_employer
this.Control[iCurrent+7]=this.rb_provider
this.Control[iCurrent+8]=this.rb_consumer
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.cb_search
this.Control[iCurrent+11]=this.dw_search_criteria
this.Control[iCurrent+12]=this.dw_matched_records
this.Control[iCurrent+13]=this.ln_1
this.Control[iCurrent+14]=this.ln_2
this.Control[iCurrent+15]=this.cb_ok
this.Control[iCurrent+16]=this.cb_cancel
this.Control[iCurrent+17]=this.ln_3
this.Control[iCurrent+18]=this.ln_4
end on

on w_reassign_case_subject.destroy
call super::destroy
destroy(this.st_3)
destroy(this.p_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_clear)
destroy(this.rb_employer)
destroy(this.rb_provider)
destroy(this.rb_consumer)
destroy(this.gb_1)
destroy(this.cb_search)
destroy(this.dw_search_criteria)
destroy(this.dw_matched_records)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.ln_3)
destroy(this.ln_4)
end on

event pc_setvariables;call super::pc_setvariables;/***************************************************************************************
	Event:	pc_setvariables
	Purpose:	Get the parameters passed to this window.

	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	07/27/01 M. Caruso     Added i_nRepSecurityLevel.
***************************************************************************************/

i_cAllCases = PCCA.Parm[1]
i_nRepSecurityLevel = INTEGER (PCCA.Parm[2])

i_bButtonClose = FALSE
end event

event pc_close;call super::pc_close;/***************************************************************************************
	Event:	pc_close
	Purpose:	Process this when closing the window.

	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	04/22/02 M. Caruso     Created.
***************************************************************************************/

// set the return values to '' the window was not closed using a command button.
IF NOT i_bButtonClose THEN

	PCCA.Parm[1] = ''
	PCCA.Parm[2] = ''
	PCCA.Parm[3] = ''
	PCCA.Parm[4] = ''
	
END IF
end event

event resize;call super::resize;st_1.width = this.workspacewidth()
st_2.width = st_1.width
ln_1.endx = st_1.width
ln_2.endx = st_1.width
ln_3.endx = st_1.width
ln_4.endx = st_1.width
end event

type st_3 from statictext within w_reassign_case_subject
integer x = 201
integer y = 60
integer width = 1691
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Reassign Case"
boolean focusrectangle = false
end type

type p_1 from picture within w_reassign_case_subject
integer x = 37
integer y = 24
integer width = 146
integer height = 128
boolean originalsize = true
string picturename = "Notepad Large Icon (White).bmp"
boolean focusrectangle = false
end type

type st_1 from statictext within w_reassign_case_subject
integer width = 3301
integer height = 168
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type st_2 from statictext within w_reassign_case_subject
integer x = 5
integer y = 1824
integer width = 3310
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 134217730
boolean focusrectangle = false
end type

type cb_clear from commandbutton within w_reassign_case_subject
integer x = 2427
integer y = 344
integer width = 411
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Clear"
end type

event clicked;//*********************************************************************************************
//  Event:   clicked
//  Purpose: Reset the search criteria fields to blank.
//  
//  Date     Developer   Describe
//  -------- ----------- ----------------------------------------------------------------------
//  07/27/01 M. Caruso   Created.
//*********************************************************************************************

dw_search_criteria.SetRedraw (FALSE)

dw_search_Criteria.DeleteRow (0)
dw_search_Criteria.InsertRow (0)

dw_search_criteria.SetRedraw (TRUE)

dw_matched_records.Reset()

dw_search_criteria.SetFocus ()
end event

type rb_employer from radiobutton within w_reassign_case_subject
integer x = 928
integer y = 292
integer width = 421
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 77971394
string text = "Group"
end type

event clicked;/****************************************************************************************

	Event:		clicked
	Purpose:		To swap the Search Criteria and Matching Record DataWindows
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	3/30/00  M. Caruso     Only process if the radio button was not already selected.
								  Insert a blank row after changing the dataobject for the search
								  datawindow so that it will display.

*****************************************************************************************/

IF dw_search_criteria.DataObject <> 'd_reassign_search_employer' THEN

	//---------------------------------------------------------------------------------------
	// 
	//		Swap datawindow objects for the search datawindow control
	//
	//---------------------------------------------------------------------------------------
	
	dw_search_criteria.DataObject = 'd_reassign_search_employer'
	dw_search_criteria.InsertRow (0)
	
	//--------------------------------------------------------------------------------------
	//
	//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
	//		record datawindow is uo_dw_main...
	//
	//--------------------------------------------------------------------------------------
	
	dw_matched_records.fu_Swap('d_reassign_matched_employers', &
										dw_matched_records.c_PromptChanges, &
										dw_matched_records.c_SelectOnRowFocusChange + &
										dw_matched_records.c_NoRetrieveOnOpen + &
										dw_matched_records.c_TabularFormStyle + &
										dw_matched_records.c_NoActiveRowPointer + &
										dw_matched_records.c_NoInactiveRowPointer + &
										dw_matched_records.c_SortClickedOK + &
										dw_matched_records.c_NoMenuButtonActivation + &
										dw_matched_records.c_NoEnablePopup)
	
	//--------------------------------------------------------------------------------------
	//
	//		Set the search arrays for a Employer search
	//
	//--------------------------------------------------------------------------------------
	
	i_cCriteriaColumn[1] = "employ_group_name"
	i_cCriteriaColumn[2] = "group_id"
	i_cCriteriaColumn[3] = "employ_city"
	i_cCriteriaColumn[4] = "employ_zip"
	
	i_cSearchTable[1] = "cusfocus.employer_group"
	i_cSearchTable[2] = "cusfocus.employer_group"
	i_cSearchTable[3] = "cusfocus.employer_group"
	i_cSearchTable[4] = "cusfocus.employer_group"
	
	i_cSearchColumn[1] = "employ_group_name"
	i_cSearchColumn[2] = "group_id"
	i_cSearchColumn[3] = "employ_city"
	i_cSearchColumn[4] = "employ_zip"
	
	//--------------------------------------------------------------------------------------
	//
	//		Wire the search datawindow to UO_DW_MAIN and set the Source Type instance variable 
	//		to Employerinstance variable.
	//
	//---------------------------------------------------------------------------------------
	
	dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, i_cSearchTable[], &
		i_cSearchColumn[], SQLCA)
	
	i_cSourceType = i_cEmployer
	dw_search_criteria.SetFocus()

END IF
end event

type rb_provider from radiobutton within w_reassign_case_subject
integer x = 1755
integer y = 292
integer width = 421
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 77971394
string text = "Provider"
end type

event clicked;/****************************************************************************************

	Event:		clicked
	Purpose:		To swap the Search Criteria and Matching Record DataWindows
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	3/30/00  M. Caruso     Only process if the radio button was not already selected.
								  Insert a blank row after changing the dataobject for the search
								  datawindow so that it will display.

*****************************************************************************************/

IF dw_search_criteria.DataObject <> 'd_reassign_search_provider' THEN

	//---------------------------------------------------------------------------------------
	// 
	//		Swap datawindow objects for the search datawindow control
	//
	//---------------------------------------------------------------------------------------
	
	dw_search_criteria.DataObject = 'd_reassign_search_provider'
	dw_search_criteria.InsertRow (0)
	
	//--------------------------------------------------------------------------------------
	//
	//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
	//		record datawindow is uo_dw_main...
	//
	//--------------------------------------------------------------------------------------
	
	dw_matched_records.fu_Swap('d_reassign_matched_providers', &
										dw_matched_records.c_PromptChanges, &
										dw_matched_records.c_SelectOnRowFocusChange + &
										dw_matched_records.c_NoRetrieveOnOpen + &
										dw_matched_records.c_TabularFormStyle + &
										dw_matched_records.c_NoActiveRowPointer + &
										dw_matched_records.c_NoInactiveRowPointer + &
										dw_matched_records.c_SortClickedOK + &
										dw_matched_records.c_NoMenuButtonActivation + &
										dw_matched_records.c_NoEnablePopup)
	
	//--------------------------------------------------------------------------------------
	//
	//		Set the search arrays for a Provider search
	//
	//--------------------------------------------------------------------------------------
	
	i_cCriteriaColumn[1] = "provid_name"
	i_cCriteriaColumn[2] = "provider_id"
	i_cCriteriaColumn[3] = "vendor_id"
	i_cCriteriaColumn[4] = "provid_city"
	i_cCriteriaColumn[5] = "provid_zip"
	i_cCriteriaColumn[6] = "provider_type"
	
	i_cSearchTable[1] = "cusfocus.provider_of_service"
	i_cSearchTable[2] = "cusfocus.provider_of_service"
	i_cSearchTable[3] = "cusfocus.provider_of_service"
	i_cSearchTable[4] = "cusfocus.provider_of_service"
	i_cSearchTable[5] = "cusfocus.provider_of_service"
	i_cSearchTable[6] = "cusfocus.provider_of_service"
	
	i_cSearchColumn[1] = "provid_name"
	i_cSearchColumn[2] = "provider_id"
	i_cSearchColumn[3] = "vendor_id"
	i_cSearchColumn[4] = "provid_city"
	i_cSearchColumn[5] = "provid_zip"
	i_cSearchColumn[6] = "provider_type"
	
	//--------------------------------------------------------------------------------------
	//
	//		Wire the search datawindow to UO_DW_MAIN, Load the Provider Type DropDownList Box
	//		and set the Source Type instance variable to Provider instance variable.
	//
	//---------------------------------------------------------------------------------------
	
	dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, i_cSearchTable[], &
		i_cSearchColumn[], SQLCA)
	
	Error.i_FWError = dw_search_criteria.fu_LoadCode("provider_type", &
											"cusfocus.provider_types", &
											"provider_type", &
											"provid_type_desc", &
											"active='Y'", "(All)")
	
	i_cSourceType = i_cProvider
	dw_search_criteria.SetFocus()
	
END IF
end event

type rb_consumer from radiobutton within w_reassign_case_subject
integer x = 101
integer y = 292
integer width = 421
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 77971394
string text = "Member"
boolean checked = true
end type

event clicked;/****************************************************************************************

	Event:		clicked
	Purpose:		To swap the Search Criteria and Matching Record DataWindows
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	3/30/00  M. Caruso     Only process if the radio button was not already selected.
								  Insert a blank row after changing the dataobject for the search
								  datawindow so that it will display.

*****************************************************************************************/

IF dw_search_criteria.DataObject <> 'd_reassign_search_consumer' THEN
	//---------------------------------------------------------------------------------------
	// 
	//		Swap datawindow objects for the search datawindow control
	//
	//---------------------------------------------------------------------------------------
	
	dw_search_criteria.DataObject = 'd_reassign_search_consumer'
	dw_search_criteria.InsertRow (0)
	
	//--------------------------------------------------------------------------------------
	//
	//		Swap datawindows objects for the matching records. Use SWAP_DW since the matching
	//		record datawindow is uo_dw_main...
	//
	//--------------------------------------------------------------------------------------
	
	dw_matched_records.fu_Swap('d_reassign_matched_consumers', &
										dw_matched_records.c_PromptChanges, &
										dw_matched_records.c_SelectOnRowFocusChange + &
										dw_matched_records.c_NoRetrieveOnOpen + &
										dw_matched_records.c_TabularFormStyle + &
										dw_matched_records.c_NoActiveRowPointer + &
										dw_matched_records.c_NoInactiveRowPointer + &
										dw_matched_records.c_SortClickedOK + &
										dw_matched_records.c_NoMenuButtonActivation + &
										dw_matched_records.c_NoEnablePopup)
	
	//--------------------------------------------------------------------------------------
	//
	//		Set the search arrays for a Consumer search
	//
	//--------------------------------------------------------------------------------------
	
	i_cCriteriaColumn[1] = "consumer_id"
	i_cCriteriaColumn[2] = "consum_last_name"
	i_cCriteriaColumn[3] = "consum_city"
	i_cCriteriaColumn[4] = "consum_zip"
	i_cCriteriaColumn[5] = "consum_dob"
	i_cCriteriaColumn[6] = "consum_ssn"
	i_cCriteriaColumn[7] = "consum_first_name"
	
	i_cSearchTable[1] 	= "cusfocus.consumer"
	i_cSearchTable[2] 	= "cusfocus.consumer"
	i_cSearchTable[3] 	= "cusfocus.consumer"
	i_cSearchTable[4] 	= "cusfocus.consumer"
	i_cSearchTable[5] 	= "cusfocus.consumer"
	i_cSearchTable[6] 	= "cusfocus.consumer"
	i_cSearchTable[7] 	= "cusfocus.consumer"
	
	
	i_cSearchColumn[1]	= "consumer_id"
	i_cSearchColumn[2] 	= "consum_last_name"
	i_cSearchColumn[3] 	= "consum_city"
	i_cSearchColumn[4] 	= "consum_zip"
	i_cSearchColumn[5] 	= "consum_dob"
	i_cSearchColumn[6] 	= "consum_ssn"
	i_cSearchColumn[7] 	= "consum_first_name"
	
	//--------------------------------------------------------------------------------------
	//
	//		Wire the search datawindow to UO_DW_MAIN and set the Source Type instance variable 
	//		to Consumer instance variable.
	//
	//---------------------------------------------------------------------------------------
	
	dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, i_cSearchTable[], &
		i_cSearchColumn[], SQLCA)
	
	i_cSourceType = i_cConsumer
	dw_search_criteria.SetFocus()

END IF
end event

type gb_1 from groupbox within w_reassign_case_subject
integer x = 27
integer y = 192
integer width = 2249
integer height = 264
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 77971394
string text = "Source Type"
end type

type cb_search from commandbutton within w_reassign_case_subject
integer x = 2427
integer y = 212
integer width = 411
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

event clicked;/****************************************************************************************

	Event:	clicked
	Purpose:	To initiate a search
	
	Revisions:
	Date     Developer     Description
	======== ============= ===============================================================
	8/23/99  M. Caruso     Added code to prevent "Retrieve All" queries.
	
	9/1/99   M. Caruso     Corrected the name of the triggered event from pc_search to
	                       pcd_search.

****************************************************************************************/

LONG     l_nRow
BOOLEAN  l_bContinue
INTEGER  l_iTotalColumns, l_iIndex, l_iCurrentCol
STRING   l_sColType, l_sValue, l_sColumnDef

/***************************************************************************************
Check for search criteria.  If no entries were made, abort the search process.
***************************************************************************************/
l_bContinue = FALSE
l_iTotalColumns = Integer (dw_search_criteria.Object.DataWindow.Column.Count)
l_nRow = dw_search_criteria.GetRow()
l_iCurrentCol = dw_search_criteria.GetColumn ()  // save current column to be reset later

FOR l_iIndex = 1 to l_iTotalColumns
	
	dw_search_criteria.SetColumn (l_iIndex)
	l_sColumnDef = dw_search_criteria.GetColumnName () + '.ColType'
	l_sColType = Upper (dw_search_criteria.Describe (l_sColumnDef))
	
	CHOOSE CASE Left (l_sColType, 4)
		CASE "CHAR"
			l_sValue = Trim (dw_search_criteria.GetItemString (l_nRow, l_iIndex))
			
		CASE "INT","LONG","NUMB","REAL","DECI"
			l_sValue = Trim (String (dw_search_criteria.GetItemNumber (l_nRow, l_iIndex)))
			
		CASE "DATE"
			IF l_sColType = "DATETIME" THEN
				l_sValue = Trim (String (dw_search_criteria.GetItemDateTime (l_nRow, l_iIndex)))
			ELSE
				l_sValue = Trim (String (dw_search_criteria.GetItemDate (l_nRow, l_iIndex)))
			END IF
			
		CASE "TIME"
			l_sValue = Trim (String (dw_search_criteria.GetItemTime (l_nRow, l_iIndex)))
			
	END CHOOSE
	
	IF (NOT (IsNull (l_sValue))) THEN
		
		// Full wildcard searching and empty string entries are blocked.
		IF (l_sValue <> "%") AND (l_sValue <> "") THEN
			l_bContinue = TRUE
			EXIT
		END IF
		
	END IF
	
NEXT

// reset the current column in the search criteria datawindow
dw_search_criteria.SetColumn (l_iCurrentCol)

IF l_bContinue THEN

	dw_matched_records.TriggerEvent('pcd_search')
	
ELSE
	
	MessageBox ("No Search Criteria", "You must enter criteria to perform a search.")
	
END IF
end event

type dw_search_criteria from u_dw_search within w_reassign_case_subject
integer x = 27
integer y = 464
integer width = 2866
integer height = 516
integer taborder = 30
string dataobject = "d_reassign_search_consumer"
boolean border = false
end type

event pc_validate;call super::pc_validate;/********************************************************************************

		Event:	pc_validate
		Purpose:	To append a % to Name, City, and Zip fields to perform a LIKE search

		History
		Date			Comments
		==============================================================================
		6/9/95		Created 

************************************************************************************/

//
//		Determine which Search Criteria DataWindow is being used 
//		(Consumer, Employer, Provider, Other, or Case).
//

DATE		l_dWatcomDate
STRING 	l_cNullSTring

CHOOSE CASE THIS.DataObject
	
	CASE 'd_reassign_search_consumer'
		
		CHOOSE CASE i_SearchColumn
					
			CASE 'consum_last_name','consum_first_name'
//--------------------------------------------------------------------------------------
//	
//		Determine if the user has already entered a %
//
//-------------------------------------------------------------------------------------
			
				IF RIGHT(i_SearchValue, 1) <>'%' AND i_SearchValue <> '' THEN
					SetItem(i_SearchRow, i_SearchColumn, i_SearchValue + '%')
 					Error.i_FWError = c_ValFixed
				END IF

			CASE 'consum_ssn'

				IF TRIM(i_SearchValue) = '' THEN
					SETNULL(i_SearchValue)
					SetItem(i_SearchRow, i_SearchColumn, i_SearchValue)
 					Error.i_FWError = c_ValFixed
				END IF
			
			END CHOOSE
      
	CASE 'd_reassign_search_employer'

		CHOOSE CASE THIS.GetColumnName() 

			CASE 'employ_group_name'

				IF RIGHT(i_SearchValue, 1) <> '%' AND i_SearchValue <> '' THEN
						SetItem(i_SearchRow, i_SearchColumn, i_SearchValue + '%')
 						Error.i_FWError = c_ValFixed
				END IF
		
		END CHOOSE

	CASE 'd_reassign_search_provider'
	
		CHOOSE CASE THIS.GetColumnName() 
	
			CASE 'provid_name' 

				IF RIGHT(i_SearchValue, 1) <> '%' AND i_SearchValue <> '' THEN
					SetItem(i_SearchRow, i_SearchColumn, i_SearchValue + '%')
 					Error.i_FWError = c_ValFixed
				END IF
			
		END CHOOSE
END CHOOSE
end event

event getfocus;call super::getfocus;/*****************************************************************************************
   Event:      losefocus
   Purpose:    Code to process when this datawindow loses focus.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/27/01 M. Caruso    Created.
*****************************************************************************************/

cb_Search.Default = TRUE
end event

event losefocus;call super::losefocus;/*****************************************************************************************
   Event:      losefocus
   Purpose:    Code to process when this datawindow loses focus.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/27/01 M. Caruso    Created.
*****************************************************************************************/

cb_Search.Default = FALSE
end event

type dw_matched_records from u_dw_std within w_reassign_case_subject
integer x = 27
integer y = 1008
integer width = 2811
integer height = 792
integer taborder = 10
string dataobject = "d_reassign_matched_consumers"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_search;call super::pcd_search;/***********************************************************************************

		Event:	pcd_search	
		Purpose:	To get the info from the first row in the search if there was one.

**********************************************************************************/
IF RowCount() > 0 THEN	
	CHOOSE CASE i_cSourceType
		CASE i_cConsumer
			i_cCaseSubject = GetItemString(1, 'consumer_id')

		CASE i_cEmployer
			i_cCaseSubject = GetItemString(1, 'group_id')

		CASE i_cProvider
			i_cCaseSubject = GetItemString(1, 'provider_id')

	END CHOOSE
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/**************************************************************************************

		Event:	pcd_retrieve
		Purpose:	To retrieve the matching records.

**************************************************************************************/
LONG l_nReturn

l_nReturn = Retrieve (i_nRepSecurityLevel)

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
END IF

end event

event pcd_pickedrow;call super::pcd_pickedrow;/***********************************************************************************

	Event:	pcd_pickedrow
	Purpose:	To get the casesubject based on what the source type is.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==========================================================
	8/22/00  M. Caruso     Added code to gather the provider type if the source type
	                       is Provider.
***********************************************************************************/	

IF i_CursorRow > 0 THEN	
	CHOOSE CASE i_cSourceType
		CASE i_cConsumer
			i_cCaseSubject = GetItemString(i_CursorRow, 'consumer_id')

		CASE i_cEmployer
			i_cCaseSubject = GetItemString(i_CursorRow, 'group_id')

		CASE i_cProvider
			i_cCaseSubject = GetItemString(i_CursorRow, 'provider_id')
			i_cProviderType = GetItemString(i_CursorRow, 'provider_of_service_provider_type')

	END CHOOSE
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/***************************************************************************************

	
			Event:	pcd_setoptions
			Purpose:	set the options for u_dw_main, 
						initialize the search datawindow, and wire it to u_dw_main.

***************************************************************************************/

//-------------------------------------------------------------------------------------
//
//		Set U_DW_MAIN Options
//
//-------------------------------------------------------------------------------------

fu_SetOptions (SQLCA, &
					c_NullDW, &
					c_SelectOnRowFocusChange + &
					c_NoRetrieveOnOpen + & 
					c_TabularFormStyle + &
					c_NoActiveRowPointer + &
					c_NoInactiveRowPointer + &
					c_SortClickedOK + &
					c_NoMenuButtonActivation + &
					c_NoEnablePopup)

//--------------------------------------------------------------------------------------
//
//		Initialize the Search Arrays for the Search datawindow.
//
//---------------------------------------------------------------------------------------

i_cCriteriaColumn[1] = "consumer_id"
i_cCriteriaColumn[2] = "consum_last_name"
i_cCriteriaColumn[3] = "consum_city"
i_cCriteriaColumn[4] = "consum_zip"
i_cCriteriaColumn[5] = "consum_dob"
i_cCriteriaColumn[6] = "consum_ssn"
i_cCriteriaColumn[7] = "consum_first_name"

i_cSearchTable[1] 	= "cusfocus.consumer"
i_cSearchTable[2] 	= "cusfocus.consumer"
i_cSearchTable[3] 	= "cusfocus.consumer"
i_cSearchTable[4] 	= "cusfocus.consumer"
i_cSearchTable[5] 	= "cusfocus.consumer"
i_cSearchTable[6] 	= "cusfocus.consumer"
i_cSearchTable[7] 	= "cusfocus.consumer"

i_cSearchColumn[1] 	= "consumer_id"
i_cSearchColumn[2] 	= "consum_last_name"
i_cSearchColumn[3] 	= "consum_city"
i_cSearchColumn[4] 	= "consum_zip"
i_cSearchColumn[5] 	= "consum_dob"
i_cSearchColumn[6] 	= "consum_ssn"
i_cSearchColumn[7] 	= "consum_first_name"

i_cSourceType = i_cConsumer

//---------------------------------------------------------------------------------------
//
//		Wire the Search datawindow to U_DW_MAIN
//
//---------------------------------------------------------------------------------------

dw_search_criteria.fu_WireDW(i_cCriteriaColumn[], dw_matched_records, i_cSearchTable[], &
	i_cSearchColumn[], SQLCA)

dw_search_criteria.SetFocus()

end event

event rowfocuschanged;call super::rowfocuschanged;/*****************************************************************************************
   Event:      rowfocuschanged
   Purpose:    Code to process after the current row in the datawindow has changed.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/27/01 M. Caruso    Created.
*****************************************************************************************/

STRING	l_cFieldName
LONG	l_nSecurityLevel

IF RowCount () > 0 THEN
	
	CHOOSE CASE i_cSourceType
		CASE 'C'
			l_cFieldName = 'confidentiality_level'
	
		CASE 'P'
			l_cFieldName = 'provider_of_service_confidentiality_leve'
		
		CASE 'E'
			l_cFieldName = 'confidentiality_level'
			
	END CHOOSE
	
	l_nSecurityLevel = GetItemNumber (currentrow, l_cFieldName)
	IF l_nSecurityLevel > i_nRepSecurityLevel THEN
		cb_OK.Enabled = FALSE
	ELSE
		cb_OK.Enabled = TRUE
	END IF
	
END IF
end event

event losefocus;call super::losefocus;/*****************************************************************************************
   Event:      losefocus
   Purpose:    Code to process when this datawindow loses focus.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/27/01 M. Caruso    Created.
*****************************************************************************************/

cb_OK.Default = FALSE
end event

event getfocus;call super::getfocus;/*****************************************************************************************
   Event:      losefocus
   Purpose:    Code to process when this datawindow gets focus.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	07/27/01 M. Caruso    Created.
*****************************************************************************************/

cb_OK.Default = TRUE
end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//  Event:   doubleclicked
//  Purpose: Use the Id of the selected entry as the new case subject for the cases.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  07/27/01 M. Caruso   Created.
//***********************************************************************************************
			  
IF cb_OK.Enabled AND dwo.Type <> "text" THEN
	cb_OK.TriggerEvent(Clicked!)
END IF
end event

type ln_1 from line within w_reassign_case_subject
long linecolor = 16777215
integer linethickness = 4
integer beginy = 1820
integer endx = 3502
integer endy = 1820
end type

type ln_2 from line within w_reassign_case_subject
long linecolor = 8421504
integer linethickness = 4
integer beginy = 1816
integer endx = 3502
integer endy = 1816
end type

type cb_ok from commandbutton within w_reassign_case_subject
integer x = 1902
integer y = 1872
integer width = 411
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean cancel = true
boolean default = true
end type

event clicked;//********************************************************************************************
//
//  Event:   clicked
//  Purpose: To get the selected record info and return it and close.
//
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------------------
//  08/22/00 M. Caruso   Pass back the provider type value as well.
//  06/26/01 C. Jackson  If the source type is provider, then get the provider_key
//  04/22/02 M. Caruso   Set i_bButtonClose to TRUE.
//  06/26/02 M. Caruso   Added code to handle new condition (i_cAllCases = 'X') which prompts
//                       for confirmation of Other Source record deletion because the case
//								 being re-assigned is the only one assigned to that Case Subject.
//  02/04/03 M. Caruso   Prompt the user to confirm case transfer, then prompt to delete the
//								 Other source record if all related cases are being re-assigned.
//********************************************************************************************

LONG   l_nNumSelectedRows, l_nSelectedRows[], l_nProviderKey
INT    l_nResponse
STRING l_cDeleteOther

//--------------------------------------------------------------------------------------
//
//		Make sure the user selected something.
//
//--------------------------------------------------------------------------------------

l_nNumSelectedRows = dw_matched_records.fu_GetSelectedRows(l_nSelectedRows[])

IF l_nNumSelectedRows = 0 THEN
	MessageBox(gs_AppName, 'You have not selected a Case Subject to Re-Assign.' + &
		                                              '  Please select a Case Subject.')
	RETURN
END IF

// force the user to confirm the re-assignment

IF MessageBox (gs_AppName, 'Are you sure you want to reassign the case(s)?', Question!, YesNo!) = 1 THEN

// if all cases are being re-assigned, prompt to delete the user to delete the case subject.
	CHOOSE CASE i_cAllCases
		CASE 'Y'
			l_nResponse = MessageBox(gs_AppName, 'You are about to re-assign ALL cases ' + &
				'to the selected Case Subject.  Would you like to delete the Other Source ' + &
				'record from the database now?', QUESTION!, YESNO!)
		
		CASE 'X'
			l_nResponse = MessageBox(gs_AppName, 'You are about to re-assign this case ' + &
				'to the selected Case Subject.  Since there are no other cases for the current ' + &
				'case subject, would you like to delete the Other Source record ' + &
				'from the database now?', QUESTION!, YESNO!)
		
		CASE ELSE
			l_nResponse = 2
			
	END CHOOSE
	
	IF l_nResponse = 1 THEN
		l_cDeleteOther = 'T'
	ELSE
		l_cDeleteOther = 'F'
	END IF
	
ELSE
	RETURN
END IF

IF i_cSourceType = 'P' THEN
	// Check for vendor 
	IF IsNull(i_cCaseSubject) THEN
		i_cCaseSubject = dw_matched_records.GetItemString(dw_matched_records.i_CursorRow, 'provider_of_service_vendor_id')
		SELECT provider_key INTO :l_nProviderKey
		  FROM cusfocus.provider_of_service
		 WHERE vendor_id = :i_cCaseSubject
		 USING SQLCA;
	ELSE // provider
		SELECT provider_key INTO :l_nProviderKey
		  FROM cusfocus.provider_of_service
		 WHERE provider_id = :i_cCaseSubject
		 USING SQLCA;
	END IF
	 
	 i_cCaseSubject = STRING(l_nProviderKey)
END IF
	
PCCA.Parm[1] = i_cCaseSubject
PCCA.Parm[2] = i_cSourceType
PCCA.Parm[3] = i_cProviderType
PCCA.Parm[4] = l_cDeleteOther

i_bButtonClose = TRUE

Close(Parent)


end event

type cb_cancel from commandbutton within w_reassign_case_subject
integer x = 2354
integer y = 1872
integer width = 411
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;/****************************************************************************************
	Event:	clicked
	Purpose:	To return empty strings (the user canceled) and close.

	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	04/22/02 M. Caruso     Set the third parameter to '' and set i_bButtonClose to TRUE.
	02/06/03 M. Caruso     Added PCCA.Parm[4] = '' to match return of OK button.
***************************************************************************************/

PCCA.Parm[1] = ''
PCCA.Parm[2] = ''
PCCA.Parm[3] = ''
PCCA.Parm[4] = ''

i_bButtonClose = TRUE

Close(parent)
end event

type ln_3 from line within w_reassign_case_subject
long linecolor = 16777215
integer linethickness = 4
integer beginy = 172
integer endx = 3502
integer endy = 172
end type

type ln_4 from line within w_reassign_case_subject
long linecolor = 8421504
integer linethickness = 4
integer beginy = 168
integer endx = 3502
integer endy = 168
end type

