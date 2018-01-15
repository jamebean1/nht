$PBExportHeader$u_search_survey.sru
$PBExportComments$Search Criteria User Object
forward
global type u_search_survey from u_container_std
end type
type dw_matched_survey_results from u_dw_std within u_search_survey
end type
type dw_search_criteria from u_dw_search within u_search_survey
end type
type gb_1 from groupbox within u_search_survey
end type
end forward

global type u_search_survey from u_container_std
integer width = 3579
integer height = 1592
long backcolor = 79748288
dw_matched_survey_results dw_matched_survey_results
dw_search_criteria dw_search_criteria
gb_1 gb_1
end type
global u_search_survey u_search_survey

type variables
STRING      i_cSearchColumns[]
STRING      i_cSearchTable[]
STRING      i_cMatchedColumns[]
STRING      i_cSubjectID


W_RECORD_SURVEY_RESULTS i_wParentWindow
end variables

on u_search_survey.create
int iCurrent
call super::create
this.dw_matched_survey_results=create dw_matched_survey_results
this.dw_search_criteria=create dw_search_criteria
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_matched_survey_results
this.Control[iCurrent+2]=this.dw_search_criteria
this.Control[iCurrent+3]=this.gb_1
end on

on u_search_survey.destroy
call super::destroy
destroy(this.dw_matched_survey_results)
destroy(this.dw_search_criteria)
destroy(this.gb_1)
end on

type dw_matched_survey_results from u_dw_std within u_search_survey
event ue_selecttrigger pbm_dwnkey
integer y = 448
integer width = 3511
integer height = 1100
integer taborder = 20
string dataobject = "d_matched_survey_results"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	8/25/99  M. Caruso     Created.

****************************************************************************************/

IF (key = KeyEnter!) AND (GetRow() > 0) THEN
	i_wParentWindow.dw_folder.fu_SelectTab (2)
	RETURN -1
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;//**********************************************************************************************
//  Event:   pcd_retrieve
//  Purpose: To retrieve the matching survey records.
//  
//  Revisions:
//  Date     Developer     Description
//  ======== ============= =====================================================================
//  02/27/02 M. Caruso     Added post-search processing.
//**********************************************************************************************

LONG l_nReturn

IF NOT i_wParentWindow.i_bNewSurvey THEN
	
	l_nReturn = Retrieve()
	CHOOSE CASE l_nReturn
		CASE IS < 0
			Error.i_FWError = c_Fatal
			i_wParentWindow.dw_folder.fu_DisableTab(2)
			
		CASE 0
			i_wParentWindow.dw_folder.fu_DisableTab(2)
			
		CASE IS > 0
			i_wParentWindow.dw_folder.fu_EnableTab(2)
			IF l_nReturn = 1 THEN
				i_wparentwindow.dw_folder.fu_SelectTab(2)
			END IF
			
	END CHOOSE
	
END IF

i_wParentWindow.i_bNewSurvey = FALSE

end event

event pcd_setcontrol;call super::pcd_setcontrol;/***************************************************************************************

		Event:	pcd_setcontrol
		Purpose:	To determine if they have selected a real survey or not.

***************************************************************************************/
IF i_CursorRow > 0 THEN
	i_wParentWindow.i_cSurveyID = GetItemString(i_CursorRow, 'survey_id')
ELSE
	i_wParentWindow.i_cSurveyID = ''
END IF
end event

event clicked;call super::clicked;//*************************************************************************************************
//
//  Event:   clicked
//  Purpose: sort the datawindow by the column that was clicked.
//  
//  Date     Developer   Description
//  -------- ----------- -------------------------------------------------------------------------
//  05/25/99 M. Caruso   Created.
//  12/14/00 cjackson    Add fu_enable tab
//  4/30/2001 K. Claver  Removed sorting in favor of the service.
//
//*************************************************************************************************

LONG l_nRow

l_nRow = THIS.GetRow()

IF l_nRow <> 0 THEN
	
	w_record_survey_results.dw_folder.fu_EnableTab(2)
	
END IF



end event

event doubleclicked;call super::doubleclicked;/*****************************************************************************************
	Event:	doubleclicked
	Purpose:	automatically switch to the Survey Results tab when the user double-clicks on
            an entry in the mathced records list.
			  
	Revisions:
	Date     Developer     Description
	======== ============= ================================================================
	8/11/99  M. Caruso     Created.
	
	12/20/99 M. Caruso     Only process if row > 0
*****************************************************************************************/

IF row > 0 THEN
	w_record_survey_results.dw_folder.fu_SelectTab (2)
END IF
end event

event pcd_pickedrow;call super::pcd_pickedrow;//***********************************************************************************************
//
//  Event:   pcd_pickedrow
//  Purpose: Get the case subject id for use in results screen
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  04/26/01 C. Jackson  Original Version
//
//***********************************************************************************************

W_RECORD_SURVEY_RESULTS l_wParentWindow

STRING l_cCaseNumber
LONG l_nRow

IF i_CursorRow > 0 THEN

	l_cCaseNumber = THIS.GetItemString(i_CursorRow,'case_number')
	
	select case_subject_id INTO :i_cSubjectID
	  from cusfocus.case_log
	 where case_number = :l_cCaseNumber
	 using sqlca;
 
END IF


end event

event pcd_savebefore;call super::pcd_savebefore;/**************************************************************************************
	Event:	pcd_savebefore
	Purpose:	To verify the user has entered a Survey Type prior to saving.

	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	11/13/01 M. Caruso     Moved all validation to pcd_validaterow of the survey results
	                       datawindow.
**************************************************************************************/

//IF IsNull(i_wParentWindow.uo_survey_results.dw_survey_results.GetItemString(&
//		i_wParentWindow.uo_survey_results.dw_survey_results.i_CursorRow, 'letter_id')) THEN
//	MessageBox(gs_AppName, 'You must specify the Survey Type prior to saving.')
// 	Error.i_FWError = c_Fatal
//	i_wParentWindow.uo_survey_results.dw_survey_results.SetColumn('letter_id')
//END IF
//
//IF i_wParentWindow.fw_PopCustID( ) = -1 THEN
//	MessageBox( gs_AppName, "Error setting Customer ID prior to saving the survey", StopSign!, OK! )
//	Error.i_FWError = c_Fatal
//END IF
end event

type dw_search_criteria from u_dw_search within u_search_survey
event ue_searchtrigger pbm_dwnkey
integer x = 114
integer y = 84
integer width = 3305
integer height = 268
integer taborder = 30
string dataobject = "d_search_criteria"
boolean border = false
end type

event ue_searchtrigger;/****************************************************************************************

	Event:	ue_searchtrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	6/22/99  M. Caruso     Created.

****************************************************************************************/

IF key = KeyEnter! THEN
	m_record_survey_results.m_file.m_search.TriggerEvent (clicked!)
	RETURN 1
END IF
end event

event pc_validate;call super::pc_validate;CHOOSE CASE i_SearchColumn

	CASE "survey_rcvd_date","survey_create_date"

 		IF OBJCA.FIELD.fu_ValidateDate(i_SearchValue,"m/d/yyyy", TRUE) = 1 THEN Error.i_FWError = c_ValFailed

END CHOOSE
end event

event po_validate;/*****************************************************************************************
   Event:      po_validate
   Purpose:    Validate search criteria.

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	02/27/02 M. Caruso    Created.
	03/05/02 M. Caruso    Modified code to set appropriate values in i_SearchError for all
								 conditions.
*****************************************************************************************/

INTEGER	l_nValue
DATETIME	l_dtNull, l_dtValue
STRING	l_cNull, l_cSearchValue

SetNull (l_dtNull)
SetNull (l_cNull)

// validate the current column
CHOOSE CASE SearchColumn
	CASE 'letter_id', 'user_id', 'case_number'
		IF SearchValue = '' THEN
			SetItem (SearchRow, SearchColumn, l_cNull)
			i_SearchError = c_ValFixed
		ELSE
			i_SearchError = c_ValOK
		END IF
		
	CASE 'survey_rcvd_date'
		IF NOT IsNull (SearchValue) AND SearchValue <> '' THEN
			l_cSearchValue = SearchValue
			i_SearchError = OBJCA.FIELD.fu_ValidateDate (l_cSearchValue, 'mm/dd/yyyy', FALSE)
			IF i_SearchError = c_ValFailed THEN
				MessageBox (gs_appname, 'The Date Received field contains an invalid date.')
				SetItem (SearchRow, SearchColumn, l_dtNull)
				i_SearchError = c_ValFailed
			ELSE
				IF l_cSearchValue <> SearchValue THEN
					l_dtValue = DATETIME (DATE (l_cSearchValue), TIME (l_cSearchValue))
					SetItem (SearchRow, SearchColumn, l_dtValue)
					i_SearchError = c_ValFixed
				END IF
			END IF
		END IF
		
   CASE 'survey_create_date'
		IF NOT IsNull (SearchValue) AND SearchValue <> '' THEN
			l_cSearchValue = SearchValue
			i_SearchError = OBJCA.FIELD.fu_ValidateDate (l_cSearchValue, 'mm/dd/yyyy', FALSE)
			IF i_SearchError = c_ValFailed THEN
				MessageBox (gs_appname, 'The Date Entered field contains an invalid date.')
				SetItem (SearchRow, SearchColumn, l_dtNull)
			ELSE
				IF l_cSearchValue <> SearchValue THEN
					l_dtValue = DATETIME (DATE (l_cSearchValue), TIME (l_cSearchValue))
					SetItem (SearchRow, SearchColumn, l_dtValue)
					i_SearchError = c_ValFixed
				END IF
			END IF
		END IF
		
END CHOOSE
end event

type gb_1 from groupbox within u_search_survey
integer x = 18
integer y = 28
integer width = 3520
integer height = 412
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79748288
string text = "Search Criteria"
borderstyle borderstyle = stylelowered!
end type

