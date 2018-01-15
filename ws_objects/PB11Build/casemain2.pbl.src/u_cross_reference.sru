$PBExportHeader$u_cross_reference.sru
$PBExportComments$Demographics User Object
forward
global type u_cross_reference from u_container_std
end type
type st_noaccess from statictext within u_cross_reference
end type
type st_nonotes from statictext within u_cross_reference
end type
type dw_case_preview from u_dw_std within u_cross_reference
end type
type dw_cross_reference from u_dw_std within u_cross_reference
end type
type st_case_preview from statictext within u_cross_reference
end type
type st_case_list from statictext within u_cross_reference
end type
end forward

global type u_cross_reference from u_container_std
integer width = 3579
integer height = 1600
borderstyle borderstyle = stylelowered!
st_noaccess st_noaccess
st_nonotes st_nonotes
dw_case_preview dw_case_preview
dw_cross_reference dw_cross_reference
st_case_preview st_case_preview
st_case_list st_case_list
end type
global u_cross_reference u_cross_reference

type variables
BOOLEAN						i_bViewNotes

STRING						i_cKeyValue

W_CREATE_MAINTAIN_CASE	i_wParentWindow
end variables

forward prototypes
public subroutine fu_selectcurrentcase ()
public function integer fu_checksecurity ()
end prototypes

public subroutine fu_selectcurrentcase ();//***********************************************************************************************
//
//  Function: fu_SelectCurrentCase
//  Purpose:  To select the current case in the case cross reference list.  
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/12/01 C. Jackson  Original Version
//  
//***********************************************************************************************


LONG		l_nRowCount, l_nSelectedRows[]

IF i_wParentWindow.i_cSelectedCase <> '' THEN
			
	l_nRowCount = dw_cross_reference.RowCount ()
	l_nSelectedRows[1] = dw_cross_reference.Find ("case_number = " + i_wParentWindow.i_cSelectedCase, 1, l_nRowCount)
	IF l_nSelectedRows[1] > 0 THEN
		
		dw_cross_reference.fu_SetSelectedRows (1, l_nSelectedRows[], dw_cross_reference.c_IgnoreChanges, dw_cross_reference.c_RefreshChildren)
		dw_cross_reference.Event pcd_PickedRow (1, l_nSelectedRows[])
		
	END IF
	
END IF
end subroutine

public function integer fu_checksecurity ();//********************************************************************************
//
//  Function: fu_CheckSecurity
//  Purpose:  To check the record confidentiality level
//  
//  Date     Developer   Description
//  -------- ----------- ---------------------------------------------------------
//  09/28/01 C. Jackson  Original Version
//  
//********************************************************************************

STRING l_cSourceID, l_cSourceType, l_cTakenBy
LONG l_nDemogConfid, l_nRow, l_nCaseConfid

l_nRow = dw_cross_reference.GetRow()

l_cSourceID = dw_cross_reference.GetItemString(l_nRow,'case_subject_id')
l_cSourceType = dw_cross_reference.GetItemString(l_nRow,'source_type')
l_nCaseConfid = dw_cross_reference.GetItemNumber(l_nRow,'case_log_confidentiality_level')
l_cTakenBy = dw_cross_reference.GetItemString(l_nRow,'case_log_case_log_taken_by')
 
// Check Case Security
IF (l_cTakenBy <> OBJCA.WIN.fu_GetLogin(SQLCA)) AND l_nCaseConfid > i_wParentWindow.i_nRepConfidLevel THEN
	RETURN 2 // Doesn't pass case security
ELSE

	// Check Demographic Security
	CHOOSE CASE l_cSourceType
			
		CASE 'C'
	
			SELECT confidentiality_level INTO :l_nDemogConfid
			 FROM cusfocus.consumer
			WHERE consumer_id = :l_cSourceID
			USING SQLCA;
			
		CASE 'E'
	
			SELECT confidentiality_level INTO :l_nDemogConfid
			 FROM cusfocus.employer_group
			WHERE group_id = :l_cSourceID
			USING SQLCA;
			
		CASE 'P'
	
			SELECT confidentiality_level INTO :l_nDemogConfid
			 FROM cusfocus.provider_of_service
			WHERE provider_key = CONVERT(INT,:l_cSourceID)
			USING SQLCA;
			
		CASE 'O'
	
			SELECT confidentiality_level INTO :l_nDemogConfid
			 FROM cusfocus.other_source
			WHERE customer_id = :l_cSourceID
			USING SQLCA;
			
	END CHOOSE
	
	

	IF l_nDemogConfid > i_wParentWindow.i_nRepRecConfidLevel THEN
		RETURN 1 // Doesn't pass Demographic Security
	ELSE
		RETURN 0 // Security is ok
	END IF

END IF


end function

on u_cross_reference.create
int iCurrent
call super::create
this.st_noaccess=create st_noaccess
this.st_nonotes=create st_nonotes
this.dw_case_preview=create dw_case_preview
this.dw_cross_reference=create dw_cross_reference
this.st_case_preview=create st_case_preview
this.st_case_list=create st_case_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_noaccess
this.Control[iCurrent+2]=this.st_nonotes
this.Control[iCurrent+3]=this.dw_case_preview
this.Control[iCurrent+4]=this.dw_cross_reference
this.Control[iCurrent+5]=this.st_case_preview
this.Control[iCurrent+6]=this.st_case_list
end on

on u_cross_reference.destroy
call super::destroy
destroy(this.st_noaccess)
destroy(this.st_nonotes)
destroy(this.dw_case_preview)
destroy(this.dw_cross_reference)
destroy(this.st_case_preview)
destroy(this.st_case_list)
end on

event pc_setoptions;call super::pc_setoptions;//***********************************************************************************************
//
//  Event:   pc_setoptions
//  Purpose: To initialize options 
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/12/01 C. Jackson  Original Version
//  4/13/2001 K. Claver  Fixed the resize code
//  
//***********************************************************************************************
  

INTEGER	l_nNewWidth, l_nNewHeight
DECIMAL	l_nWidthOffset, l_nHeightOffset

of_setresize (TRUE)
IF IsValid (inv_resize) THEN
	// calculate the resize ratio of the parent window from when it was created.
	IF i_wParentWindow.Width < 3579 THEN
		l_nWidthOffSet = 0
	ELSE
		l_nWidthOffSet = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
	END IF
	
	IF i_wParentWindow.Height < 1600 THEN
		l_nHeightOffSet = 0
	ELSE
		l_nHeightOffSet = i_wParentWindow.Height - i_wParentWindow.i_nBaseHeight
	END IF
	
	// adjust the height of this container in case the window has been resized.
	l_nNewHeight = 1600 + l_nHeightOffset
	l_nNewWidth = 3579 + l_nWidthOffSet
	Resize (l_nNewWidth, l_nNewHeight)
	
	// adjust the position of this datawindow in case the window has been resized.
	inv_resize.of_Register (dw_cross_reference, "ScaleToRight&Bottom")
	l_nNewWidth = dw_cross_reference.Width + l_nWidthOffset
	l_nNewHeight = dw_cross_reference.Height + l_nHeightOffset
	dw_cross_reference.Resize (l_nNewWidth, l_nNewHeight)
	
	// adjust the position of this text item in case the window has been resized.
	inv_resize.of_Register (st_case_preview, "FixedToBottom")
	st_case_preview.Y = st_case_preview.Y + l_nHeightOffset
	
	// adjust the position of this datawindow in case the window has been resized.
	inv_resize.of_Register (dw_case_preview, "FixedToBottom&ScaleToRight")
	dw_case_preview.Y = dw_case_preview.Y + l_nHeightOffset
	l_nNewWidth = dw_case_preview.Width + l_nWidthOffset
	dw_case_preview.Resize (l_nNewWidth, dw_case_preview.Height)
	
	//Register this control with the resize service
	i_wParentWindow.inv_resize.of_Register (THIS, "ScaleToRight&Bottom")
	
	//Register st_nonotes object with the resize service
	i_wParentWindow.inv_resize.of_Register (st_nonotes, "FixedToBottom")
	
END IF
end event

type st_noaccess from statictext within u_cross_reference
boolean visible = false
integer x = 1234
integer y = 1252
integer width = 1111
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Access denied to the details of this case."
boolean focusrectangle = false
end type

type st_nonotes from statictext within u_cross_reference
boolean visible = false
integer x = 1211
integer y = 1252
integer width = 1157
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "There are no notes for this case."
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_case_preview from u_dw_std within u_cross_reference
integer x = 23
integer y = 988
integer width = 3534
integer height = 592
integer taborder = 20
string dataobject = "d_case_notes"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: Intialize the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/12/01 C. Jackson  Original Version
//  3/1/2002 K. Claver   Added constants to enable modify so can copy notes
//***********************************************************************************************

fu_SetOptions (SQLCA, dw_cross_reference, c_DetailEdit + &
													c_HideHighlight + &
													c_NoShowEmpty + &
													c_NoMenuButtonActivation + &
													c_ModifyOK + &
													c_ModifyOnOpen )
end event

event pcd_retrieve;call super::pcd_retrieve;//***********************************************************************************************
//  Event:   pcd_retrieve
//  Purpose: Retrieve the data for the datawindow
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/12/01 C. Jackson  Original Version
//  12/10/01 C. Jackson  Change GetItemNumber to GetItemString for Case_number
//  03/08/02 M. Caruso   Added code to prevent detail retrieval if the user does not have
//								 security access to the case.
//  03/14/02 M. Caruso   Corrected the logic for retrieving records.
//***********************************************************************************************

INTEGER	l_nCaseConfidLevel
LONG		l_nRtn
STRING	l_cCaseNumber

IF (parent_dw.RowCount () > 0) AND (i_bViewNotes) THEN
	
	// the user has access to retrieve the case notes
	l_cCaseNumber = parent_dw.GetItemString (Selected_Rows[num_selected], "case_number")
	l_nCaseConfidLevel = Parent_DW.GetItemNumber (Parent_DW.GetRow (), 'case_log_confidentiality_level')
	l_nRtn = retrieve (l_cCaseNumber, i_wParentWindow.i_nRepConfidLevel)
	
ELSE
	
	// the user does not have access to the case notes
	fu_Reset (c_IgnoreChanges)
	l_nRtn = -1
	
END IF

CHOOSE CASE l_nRtn
	CASE -1
		// display no access message
		st_noaccess.Visible = TRUE
		st_nonotes.Visible = FALSE
		
	CASE 0
		// display no notes message
		st_nonotes.Visible = TRUE
		st_noaccess.Visible = FALSE

	CASE ELSE
		// make sure messages are hidden
		st_noaccess.Visible = FALSE
		st_nonotes.Visible = FALSE
		THIS.Function Post fu_Modify ()
		
END CHOOSE
end event

type dw_cross_reference from u_dw_std within u_cross_reference
event ue_selecttrigger pbm_dwnkey
integer x = 27
integer y = 24
integer width = 3534
integer height = 880
integer taborder = 10
string dataobject = "d_cross_reference"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;//***********************************************************************************************
//
//  Event:   ue_selecttrigger
//  Purpose: Trigger the search function when the user presses the Enter key.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/12/01 C. Jackson  Original Version
//  9/24/2001 K. Claver  Modified to move from the search screen forward.  This ensures that the
// 							 case and demographic security is taken into consideration and that the
//								 case details object is instantiated.
//  09/28/01 C. Jackson  Call function fu_CheckRecConfid before trying to go to the search tab,
//                       If the user doesn't have Demog security, they are told so immediatly
//                       and not taken to the Search tab. (SCR 2401)
//  10/09/01 C. Jackson  Add Security
//  3/4/2002 K. Claver   Modified to use the new version of the case search event.
//
//***********************************************************************************************

LONG		l_nRow, l_nReturn
String   l_cCaseNumber


IF (key = KeyEnter!) THEN
	IF THIS.RowCount( ) > 0 THEN
		l_nRow = THIS.GetRow( )
		
		IF l_nRow > 0 THEN
			l_cCaseNumber = THIS.Object.case_number[ l_nRow ]
			
			IF Trim( l_cCaseNumber ) <> "" AND NOT IsNull( l_cCaseNumber ) THEN

				// Make sure the user has the proper security to open this case
				l_nReturn = fu_CheckSecurity()
				
				CHOOSE CASE l_nReturn
					CASE 0  // All Security passed
					
						// Make sure the window is on the Search tab
						IF i_wParentWindow.dw_folder.i_CurrentTab <> 1 THEN
							i_wParentWindow.dw_folder.fu_SelectTab( 1 )
						END IF
						
						i_IgnoreRFC = TRUE
						// call ue_casesearch to process the query after the window is fully initialized.
						i_wParentWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber)
						
					CASE 1 // doesn't pass demographic security
						MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
									"for internal purposes.  You do not have access to view it.", &
									StopSign!, Ok! )

						RETURN 1
					CASE 2 // doesn't pass case security
			
						MessageBox( gs_AppName, "You do not have the proper security level to view this case.", &
									StopSign!, OK! )
						RETURN 1
					END CHOOSE
					
			END IF
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
//  02/12/01 C. Jackson  Original Version
//
//***********************************************************************************************

INTEGER	l_nWidthOffset, l_nWidth

fu_SetOptions (SQLCA, c_NullDW, c_SelectOnRowFocusChange + c_NoMenuButtonActivation + &
										  c_SortClickedOK + c_NoEnablePopup)

										  
of_SetResize (TRUE)
IF IsValid (inv_resize) THEN
	
	l_nWidthOffset = i_wParentWindow.Width - i_wParentWindow.i_nBaseWidth
	
	// make the separator line resizeable
	inv_resize.of_register ("l_1", "ScaleToRight")
	l_nWidth = INTEGER (Describe ("l_1.X2"))
	Modify ("l_1.X2=" + STRING (l_nWidth + l_nWidthOffset))
	
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;//***********************************************************************************************
//
//  Event:   pcd_retrieve
//  Purpose: To retrieve cross reference records
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/12/01 C. Jackson  Original Version
//  06/27/01 C. Jackson  If source type is P do retrieve on Provider_key
//  7/25/2001 K. Claver  Pass in source type so can differentiate between selects in the unions
//								 in the datawindow should their be a case subject id collision between the
//								 source types.
//  10/09/01 C. Jackson  Add userid in retrieval to use with comparison to taken_by in determining
//                       security access.
//
//***********************************************************************************************

STRING   l_cUserID
LONG		l_nReturn, l_nSelectedRows[], l_nRowCount

l_cUserID = OBJCA.WIN.fu_GetLogin(SQLCA)

THIS.SetTransObject(SQLCA)

IF i_wParentWindow.i_cSourceType = 'P' THEN
	l_nReturn = THIS.Retrieve (i_wParentWindow.i_cProviderKey, i_wParentWindow.i_cSourceType, i_wParentWindow.i_nRepRecConfidLevel, l_cUserID)
	
ELSE
	l_nReturn = THIS.Retrieve (i_wparentwindow.i_cCurrentCaseSubject, i_wParentWindow.i_cSourceType, i_wParentWindow.i_nRepRecConfidLevel, l_cUserID)
	
END IF

CHOOSE CASE l_nReturn
	CASE IS < 0
		Error.i_FWError = c_Fatal

		
END CHOOSE


end event

event pcd_pickedrow;call super::pcd_pickedrow;//***********************************************************************************************
//
//  Event:   pcd_pickedrow
//  Purpose: To find out what the user selected and to set the appropriate variables and tabs.
//  
//  Date     Developer   Description
//  -------- ----------- ------------------------------------------------------------------------
//  02/12/01 C. Jackson  Original Version
//  12/10/01 C. Jackson  Change GetItemNumber to GetItemString for case_number
//  
//***********************************************************************************************

STRING	l_cCaseRep
LONG		l_nLevel

i_wParentWindow.i_bCaseDetailUpdate = TRUE
i_wParentWindow.i_cSelectedCase = GetItemString (i_CursorRow, 'case_number') 

l_nLevel = GetItemNumber (i_CursorRow, "case_log_confidentiality_level")
l_cCaseRep = GetItemString (i_CursorRow, "case_log_case_log_case_rep")

IF (l_nLevel <= i_wParentWindow.i_nRepConfidLevel) OR (l_cCaseRep = OBJCA.WIN.fu_GetLogin(SQLCA)) THEN
	
	// the user has access to the selected case, so enable the appropriate items
	i_bViewNotes = TRUE
	
	m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled = TRUE
	m_create_maintain_case.m_file.m_printcasedetailreport.Enabled = TRUE
	
ELSE
	
	// the user does not have access to the selected case, so disable the appropriate items
	i_bViewNotes = FALSE
	
	m_create_maintain_case.m_file.m_viewcasedetailreport.Enabled = FALSE
	m_create_maintain_case.m_file.m_printcasedetailreport.Enabled = FALSE
	
END IF


end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  6/29/2001 K. Claver   Added code to retrieve the case when double click on a row
//  10/09/01 C. Jackson    Add Security
//  3/4/2002 K. Claver    Modified to use the new version of the case search event.
//***********************************************************************************************  

Long l_nReturn
String l_cCaseNumber

IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN
		l_cCaseNumber = THIS.Object.case_number[ row ]
		
		IF Trim( l_cCaseNumber ) <> "" AND NOT IsNull( l_cCaseNumber ) THEN
			
			// Make sure the user has the proper security to open this case
			l_nReturn = fu_CheckSecurity()
			
			CHOOSE CASE l_nReturn
				CASE 0 // All Security passed
			
					// Make sure the window is on the Search tab
					IF i_wParentWindow.dw_folder.i_CurrentTab <> 1 THEN
						i_wParentWindow.dw_folder.fu_SelectTab(1)
					END IF
					
					// call ue_casesearch to process the query after the window is fully initialized.
					i_wParentWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber)
					
				CASE 1 // doesn't pass demographic security
					MessageBox( gs_AppName, "The Demographic record associated with this case is secured~r~n"+ &
								"for internal purposes.  You do not have access to view it.", &
								StopSign!, Ok! )
					RETURN
				CASE 2 // doesn't pass case security
						MessageBox( gs_AppName, "You do not have the proper security level to view this case.", &
									StopSign!, OK! )
					RETURN 
			END CHOOSE
		END IF
	END IF
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;// This event, combined with the statement in ue_selecttrigger that
// sets i_IgnoreRFC to TRUE, will counteract the effect that pressing
// the Enter key has causing the next row to become current (and subsequently
// causing the wrong case to be opened).
//
// 11/07/2006 Created Rick Post

LONG ll_selected_row

ll_selected_row = THIS.GetSelectedRow(0)

IF currentrow <> ll_selected_row THEN
	SetRow(ll_selected_row)
END IF

i_IgnoreRFC = FALSE

end event

type st_case_preview from statictext within u_cross_reference
integer x = 23
integer y = 916
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Preview:"
boolean focusrectangle = false
end type

type st_case_list from statictext within u_cross_reference
boolean visible = false
integer x = 23
integer y = 4
integer width = 503
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cross References:"
boolean focusrectangle = false
end type

