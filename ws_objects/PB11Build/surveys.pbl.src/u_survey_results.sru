$PBExportHeader$u_survey_results.sru
$PBExportComments$Survey Results User Object
forward
global type u_survey_results from u_container_std
end type
type dw_survey_report from datawindow within u_survey_results
end type
type dw_survey_results from u_dw_std within u_survey_results
end type
end forward

global type u_survey_results from u_container_std
integer width = 3579
integer height = 1592
long backcolor = 79748288
dw_survey_report dw_survey_report
dw_survey_results dw_survey_results
end type
global u_survey_results u_survey_results

type variables
W_RECORD_SURVEY_RESULTS i_wParentWindow

end variables

on u_survey_results.create
int iCurrent
call super::create
this.dw_survey_report=create dw_survey_report
this.dw_survey_results=create dw_survey_results
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_survey_report
this.Control[iCurrent+2]=this.dw_survey_results
end on

on u_survey_results.destroy
call super::destroy
destroy(this.dw_survey_report)
destroy(this.dw_survey_results)
end on

type dw_survey_report from datawindow within u_survey_results
boolean visible = false
integer width = 3333
integer height = 1768
integer taborder = 20
string dataobject = "d_survey_results_report"
boolean livescroll = true
end type

event constructor;IF gs_AppName <> "" AND THIS.DataObject = "d_survey_results_report" THEN
	THIS.Object.t_2.text = gs_AppName
END IF
end event

type dw_survey_results from u_dw_std within u_survey_results
integer x = 5
integer y = 4
integer width = 3547
integer height = 1572
integer taborder = 10
string dataobject = "d_survey_results"
boolean border = false
end type

event pcd_validaterow;call super::pcd_validaterow;/*****************************************************************************************
   Event:      pcd_validaterow
   Purpose:    Determine if the current record is valid

   Revisions:
   Date     Developer    Description
   ======== ============ =================================================================
	11/12/01 M. Caruso    Added code to validate the case_number and letter_id columns.
	03/06/02 M. Caruso    Added validation of 'survey_create_date'.
*****************************************************************************************/

STRING	l_cCaseNumber, l_cTemp
DATETIME l_dtRcvd, l_dtEntered

IF in_save THEN

	// fill in the Date Entered if not already done
	l_dtEntered = GetItemDateTime (row_nbr, 'survey_create_date')
	IF IsNull (l_dtEntered) THEN
		
		l_dtEntered = i_wParentWindow.fw_GetTimeStamp ()
		SetItem (row_nbr, 'survey_create_date', l_dtEntered)
	
	END IF

	// validate date received.
	l_dtRcvd = GetItemDateTime (row_nbr,"survey_rcvd_date")
	IF IsNull (l_dtRcvd) THEN
		
		MessageBox(FWCA.MGR.i_ApplicationName,"You must enter the date received prior to saving.",Exclamation!)
		THIS.SetColumn("survey_rcvd_date")
		Error.i_FWError = c_ValFailed
		RETURN
		
	ELSE
		
		IF l_dtEntered < l_dtRcvd THEN
			
			messagebox (gs_AppName, 'Date Received must be prior or equal to the Date Entered~r~n' + &
											'prior to saving.')
			This.SetColumn ("survey_rcvd_date")
			Error.i_FWError = c_ValFailed
			RETURN
			
		END IF	
		
	END IF
	
	// validate the case_number
	l_cCaseNumber = GetItemString (row_nbr, "case_number")
	IF IsNull (l_cCaseNumber) OR l_cCaseNumber = '' THEN
		
		MessageBox (FWCA.MGR.i_ApplicationName, "You must specify a case number prior to saving.",Exclamation!)
		This.SetColumn ("case_number")
		Error.i_FWError = c_ValFailed
		RETURN
		
	ELSE
		
		// Make sure this case exists
		SELECT case_number INTO :l_cTemp
		  FROM cusfocus.case_log
		 WHERE case_number = :l_cCaseNumber
		 USING SQLCA;
		 
		IF SQLCA.SQLCode <> 0 THEN
			
			messagebox (FWCA.MGR.i_ApplicationName, 'Case #' + l_cCaseNumber + ' was not found. You must~r~n' + &
																 'enter a valid case number prior to saving.')
			This.SetColumn ("case_number")
			Error.i_FWError = c_ValFailed
			RETURN
			
		END IF
		
	END IF
	
	// validate the letter_id
	IF IsNull (GetItemString (row_nbr, "letter_id")) THEN
		
		MessageBox (FWCA.MGR.i_ApplicationName, "You must specify the Survey Type prior to saving.",Exclamation!)
		This.SetColumn ("letter_id")
		Error.i_FWError = c_ValFailed
		RETURN
		
	END IF
	
END IF
end event

event pcd_setkey;call super::pcd_setkey;//***********************************************************************************************
//
//  Event:   pcd_setkey
//  Purpose: To get a key value for a new row.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  10/06/00 C. Jackson  Add table name to call to fw_getkeyvalue
//
//***********************************************************************************************
String l_cSurveyID

l_cSurveyID = i_wParentWindow.fw_getkeyvalue('survey_results')

SetItem(i_CursorRow, 'survey_id', l_cSurveyID)

i_wParentWindow.i_cSurveyID = l_cSurveyID


end event

event pcd_validatecol;call super::pcd_validatecol;//**********************************************************************************************
//  Event:   pcd_validatecol
//  Purpose: To verify the date entered is a valid date and to add the /'s if the user has not 
//           by calling the Validate_Date PowerClass function.
//			  
//  Revisions:
//  Date     Developer     Description
//  ======== ============= =====================================================================
//  
//**********************************************************************************************

CHOOSE CASE col_name
	CASE 'survey_rcvd_date'
		Error.i_FWError = OBJCA.FIELD.fu_ValidateDate (col_text, 'm/d/yyyy', TRUE)
	
END CHOOSE


end event

event pcd_new;call super::pcd_new;/**************************************************************************************
	Event:	pcd_new	
	Purpose:	To set some defaults and mark the row as NEW after setting them.

	Revisions:
	Date     Developer     Description
	======== ============= =============================================================
	11/13/01 M. Caruso     Commented the SetItemStatus line so that validation occurs
	                       every time the datawindow is saved.
	03/06/02 M. Caruso     Commented the lines that set the created and received date
								  default values.
**************************************************************************************/


//SetItem(i_CursorRow, 'survey_create_date', DateTime(Today()))
//SetItem(i_CursorRow, 'survey_rcvd_date', DateTime(Today()))
SetItem(i_CursorRow, 'user_id', OBJCA.WIN.fu_GetLogin(SQLCA))

//SetItemStatus(i_CursorRow, 0, PRIMARY!, NOTMODIFIED!)

//Open up the fields for editing.
THIS.Object.letter_id.Protect = "0"
THIS.Object.case_number.Edit.DisplayOnly = "No"
THIS.Object.letter_id.Background.Color = String( RGB( 255, 255, 255 ) )
THIS.Object.case_number.Background.Color = String( RGB( 255, 255, 255 ) )

//Set the new boolean variable so the refresh parent ancestor code doesn't 
//  attempt to retrieve all rows when switch back to search screen
i_wParentWindow.i_bNewSurvey = TRUE


end event

event pcd_retrieve;call super::pcd_retrieve;/***************************************************************************************
	Event:	pcd_retrieve
	Purpose:	To retrieve the data.

	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	11/13/01 M. Caruso     Corrected color for the protected fields to ButtonFace.
***************************************************************************************/

LONG l_nReturn

i_wParentWindow.i_cSurveyID = Parent_DW.GetItemString(Selected_Rows[1], &
					'survey_id')

l_nReturn = Retrieve(i_wParentWindow.i_cSurveyID )

IF l_nReturn < 0 THEN
 	Error.i_FWError = c_Fatal
ELSE
	//Lock down the fields.
	THIS.Object.letter_id.Protect = "1"
	THIS.Object.case_number.Edit.DisplayOnly = "Yes"
	THIS.Object.letter_id.Background.Color = "79741120"
	THIS.Object.case_number.Background.Color = "79741120"
END IF
end event

event itemchanged;call super::itemchanged;//**********************************************************************************************
//
//  Event:   itemchanged
//  Purpose: Validate the case number
//  
//  Date     Developer   Description
//  -------- ----------- -----------------------------------------------------------------------
//  04/27/01 C. Jackson  Original Version
//  11/12/01 M. Caruso   Updated the error message to match the one in pcd_validaterow.
//**********************************************************************************************

//LONG		l_nCount
//DATETIME	l_dtEntered, l_dtRcvd
//
//CHOOSE CASE dwo.Name
//
//	CASE 'case_number'
//		THIS.AcceptText()
//
//		// Make sure this case exists
//		SELECT COUNT (*) INTO :l_nCount
//		  FROM cusfocus.case_log
//		 WHERE case_number = :data
//		 USING SQLCA;
//		 
//		IF l_nCount <= 0 THEN
//			
//			messagebox (gs_AppName, 'Case #' + data + ' was not found. You must~r~n' + &
//											'enter a valid case number prior to saving.')
//			This.SelectText (1, Len (data))
//			RETURN 1
//			
//		END IF
//		
//	CASE 'survey_rcvd_date'
//		l_dtEntered = GetItemDateTime (row, 'survey_create_date')
//		l_dtRcvd = DateTime (Date (Left (data, 10)), Time ('23:59:59.999'))
//		IF l_dtEntered < l_dtRcvd THEN
//			
//			messagebox (gs_AppName, 'Date Received must be prior or equal to the Date Entered~r~n' + &
//											'prior to saving.')
//			This.SelectText (1, Len (data))
//			RETURN 1
//			
//		END IF
//		
//END CHOOSE
end event

