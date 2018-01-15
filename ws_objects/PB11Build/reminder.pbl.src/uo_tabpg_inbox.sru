$PBExportHeader$uo_tabpg_inbox.sru
forward
global type uo_tabpg_inbox from u_tabpg_std
end type
type st_notes from statictext within uo_tabpg_inbox
end type
type dw_transfernotes from u_dw_std within uo_tabpg_inbox
end type
type dw_preview from u_dw_std within uo_tabpg_inbox
end type
type dw_inbox from u_dw_std within uo_tabpg_inbox
end type
type gb_1 from groupbox within uo_tabpg_inbox
end type
type gb_2 from groupbox within uo_tabpg_inbox
end type
type gb_3 from groupbox within uo_tabpg_inbox
end type
end forward

global type uo_tabpg_inbox from u_tabpg_std
boolean visible = false
integer width = 3602
integer height = 1612
boolean enabled = false
string text = " Inbox"
event ue_refresh ( )
event ue_deletecopy ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
st_notes st_notes
dw_transfernotes dw_transfernotes
dw_preview dw_preview
dw_inbox dw_inbox
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global uo_tabpg_inbox uo_tabpg_inbox

type variables
W_REMINDERS		i_wParentWindow
uo_tab_workdesk  i_tabParentTab
Boolean i_bNeedRefresh = FALSE
STRING i_cViewedCase
STRING i_cOwner
end variables

event ue_refresh;//***********************************************************************************************
//
//  Event:   ue_Refresh
//  Purpose: Refresh the data
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//***********************************************************************************************

IF THIS.i_bNeedRefresh THEN
	THIS.i_tabParentTab.SetRedraw( FALSE )
	
	dw_inbox.fu_Retrieve( dw_inbox.c_IgnoreChanges, &
								 dw_inbox.c_ReselectRows )							 
								 
	//Need to manually retrieve the child datawindows on refresh
	//  as the non-PowerClass tab architecture doesn't handle the
	//  retrieve of the child datawindows(with the exception of
	//  rowfocuschange in the parent datawindow).
	dw_transfernotes.fu_Retrieve( dw_transfernotes.c_IgnoreChanges, &
											dw_transfernotes.c_ReselectRows )
									
	dw_preview.fu_Retrieve( dw_preview.c_IgnoreChanges, &
									dw_preview.c_ReselectRows )
									
	//Refreshed.  Reset Variable.
	THIS.i_bNeedRefresh = FALSE
	
	THIS.i_tabParentTab.SetRedraw( TRUE )
END IF
end event

event ue_deletecopy;//***********************************************************************************************
//
//  Event:   ue_DeleteCopy
//  Purpose: Delete selected copy rows in the inbox
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/25/2000 K. Claver   Original Version
//***********************************************************************************************  
Integer l_nRow, l_nSelectedRow[ 1 ]

IF dw_inbox.RowCount( ) > 0 THEN
	l_nRow = dw_inbox.GetSelectedRow( l_nRow )
	
	IF l_nRow > 0 THEN
		IF dw_inbox.Object.case_transfer_type[ l_nRow ] = "C" THEN
			//Update the copy_deleted flag
			dw_inbox.Object.copy_deleted[ l_nRow ] = 1
			dw_inbox.fu_Save( dw_inbox.c_SaveChanges )
			
			l_nSelectedRow[ 1 ] = l_nRow
			
			dw_inbox.fu_Delete( 1, l_nSelectedRow, dw_inbox.c_IgnoreChanges )
			
			//Empty the delete buffer so won't attempt to delete from
			//  the database
			dw_inbox.fu_ResetUpdate( )	
			
			IF dw_inbox.RowCount( ) > 0 THEN
				IF l_nRow > 2 THEN
					l_nSelectedRow[ 1 ] = ( l_nRow - 1 )
				ELSE
					l_nSelectedRow[ 1 ] = 1
				END IF
					
				dw_inbox.fu_SetSelectedRows( 1, l_nSelectedRow, dw_inbox.c_IgnoreChanges, dw_inbox.c_RefreshChildren )
				
				l_nRow = l_nSelectedRow[ 1 ]
				
				IF dw_inbox.Object.case_transfer_type[ l_nRow ] = "O" THEN
					m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
				ELSE
					m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
				END IF				
			ELSE
				m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
				dw_transfernotes.fu_Reset( dw_transfernotes.c_IgnoreChanges )
			END IF			
		END IF
	END IF
END IF
	
	
	
end event

event ue_setmainfocus;//***********************************************************************************************
//
//  Event:   ue_SetMainFocus
//  Purpose: Set Focus to the main datawindow
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
THIS.dw_inbox.SetFocus( )
end event

event ue_setneedrefresh;//***********************************************************************************************
//
//  Event:   ue_SetNeedRefresh
//  Purpose: Set variable to indicate that this tab needs to be refreshed when selected
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/20/2002 K. Claver   Original Version
//***********************************************************************************************
THIS.i_bNeedRefresh = TRUE
end event

on uo_tabpg_inbox.create
int iCurrent
call super::create
this.st_notes=create st_notes
this.dw_transfernotes=create dw_transfernotes
this.dw_preview=create dw_preview
this.dw_inbox=create dw_inbox
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_notes
this.Control[iCurrent+2]=this.dw_transfernotes
this.Control[iCurrent+3]=this.dw_preview
this.Control[iCurrent+4]=this.dw_inbox
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.gb_3
end on

on uo_tabpg_inbox.destroy
call super::destroy
destroy(this.st_notes)
destroy(this.dw_transfernotes)
destroy(this.dw_preview)
destroy(this.dw_inbox)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event constructor;call super::constructor;//***********************************************************************************************
//
//  Event:   Constructor
//  Purpose: please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/24/2000 K. Claver   Added code to activate the resize service and register the objects
//  10/26/2000 M. Caruso   Added code to set the parent window reference
//***********************************************************************************************
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( gb_1, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( dw_inbox, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( gb_3, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( dw_transfernotes, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( gb_2, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( dw_preview, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( st_notes, THIS.inv_resize.FIXEDBOTTOM )
END IF

i_wParentWindow = W_REMINDERS

end event

type st_notes from statictext within uo_tabpg_inbox
boolean visible = false
integer x = 1385
integer y = 1308
integer width = 882
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 1090519039
string text = "There are no notes for this case."
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_transfernotes from u_dw_std within uo_tabpg_inbox
boolean visible = false
integer x = 41
integer y = 792
integer width = 3502
integer height = 212
integer taborder = 20
boolean enabled = false
string dataobject = "d_transfer_notes"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Set dw_inbox as the parent datawindow
	10/24/2000 K. Claver		Enabled resize and registered case_transfer_notes
******************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  dw_inbox, & 
						  c_NoMenuButtonActivation+ &
						  c_NoEnablePopup+ &
						  c_NoRetrieveOnOpen )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "case_transfer_notes", THIS.inv_resize.SCALERIGHT )
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
	Event:	pcd_retrieve
	Purpose:	Retrieve rows into the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Added code to retrieve based on the row selected in the parent
									and the key column
******************************************************************************************/
LONG l_nRtn = 0
INTEGER l_nRow
String l_cSelected

SetPointer( Hourglass! )

IF UpperBound( selected_rows ) > 0 THEN
	l_nRow = selected_rows[ 1 ]
ELSE
	//Use the PB method to get the current selected row.
	l_nRow = Parent_DW.GetSelectedRow( 0 )
END IF

IF l_nRow > 0 THEN
	l_cSelected = Parent_DW.GetItemString( l_nRow, "case_transfer_id")

	IF NOT IsNull( l_cSelected ) AND Trim( l_cSelected ) <> "" THEN
		l_nRtn = THIS.Retrieve( l_cSelected )
	END IF
ELSE
	THIS.fu_Reset( c_IgnoreChanges )
END IF
	
IF l_nRtn < 0 THEN
	Error.i_FWError = c_Fatal
END IF

SetPointer( Arrow! )
end event

type dw_preview from u_dw_std within uo_tabpg_inbox
boolean visible = false
integer x = 41
integer y = 1096
integer width = 3502
integer height = 472
integer taborder = 20
boolean enabled = false
string dataobject = "d_case_notes_new"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Set dw_inbox as the parent datawindow
	10/24/2000 K. Claver		Enabled resize and registered note_text
	3/1/2002   K. Claver    Enabled modify for the datawindow to allow the user to copy the
									case notes
******************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  dw_inbox, & 
						  c_NoMenuButtonActivation+ &
						  c_NoEnablePopup+ &
						  c_ModifyOK+ &
						  c_HideHighlight+ &
						  c_NoRetrieveOnOpen )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "note_text", THIS.inv_resize.SCALERIGHT )
END IF
end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
	Event:	pcd_retrieve
	Purpose:	Retrieve rows into the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Added code to retrieve based on the row selected in the parent
									and the key column
	10/26/2000 M. Caruso    Added the security level retrieval argument.
	3/1/2002   K. Claver    Added call to fu_Modify to enable the notes field to be copied.
									Need to do this after each retrieve as the datawindow goes back
									into view mode.
******************************************************************************************/
LONG l_nRtn = 0
INTEGER l_nRow
STRING l_cSelected

SetPointer( Hourglass! )

IF UpperBound( selected_rows ) > 0 THEN
	l_nRow = selected_rows[ 1 ]
ELSE
	//Use the PB method to get the current selected row.
	l_nRow = Parent_DW.GetSelectedRow( 0 )
END IF

IF l_nRow > 0 THEN
	l_cSelected = Parent_DW.GetItemString( l_nRow, "case_number")
	
	l_nRtn = THIS.Retrieve( l_cSelected, i_wParentWindow.i_nRepConfidLevel )
ELSE
	THIS.fu_Reset( c_IgnoreChanges )
	st_notes.Visible = TRUE
END IF

IF l_nRtn < 0 THEN
   Error.i_FWError = c_Fatal
ELSEIF l_nRtn = 0 THEN
	st_notes.Visible = TRUE
ELSE
	st_notes.Visible = FALSE
	THIS.Function Post fu_Modify( )
END IF

SetPointer( Arrow! )
end event

type dw_inbox from u_dw_std within uo_tabpg_inbox
event ue_selecttrigger pbm_dwnkey
event ue_checktrans ( long a_nrow,  string a_ccasenumber )
boolean visible = false
integer x = 41
integer y = 72
integer width = 3502
integer height = 620
integer taborder = 10
boolean enabled = false
string dataobject = "d_inbox"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event ue_selecttrigger;/****************************************************************************************

	Event:	ue_selecttrigger
	Purpose:	Trigger the search function when the user presses the Enter key.
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	9/25/2001 K. Claver    Created
	3/4/2002  K. Claver    Modified to use the new version of the case search event
****************************************************************************************/

W_CREATE_MAINTAIN_CASE	l_wCaseWindow
Long			l_nRow
String      l_cCaseNumber

// if the user double-clicked on a row, process it.
IF ( key = KeyEnter! ) AND ( THIS.GetRow() > 0 ) THEN
	
	// Get the selected case number
	l_nRow = GetRow( )
	l_cCaseNumber = THIS.Object.case_number[ l_nRow ]
	
	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
		//Check the transfer status of the case
		THIS.Event Trigger ue_CheckTrans( l_nRow, l_cCaseNumber )
		
		// Open w_create_maintain_case
		FWCA.MGR.fu_OpenWindow( w_create_maintain_case, -1 )
		l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet( )
		
		IF IsValid( l_wCaseWindow ) THEN
			 
			// Make sure the window is on the Search tab
			IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
				l_wCaseWindow.dw_folder.fu_SelectTab( 1 )
			END IF
			
			// call ue_casesearch to process the query after the window is fully initialized.
			l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber )
			
		END IF
	END IF
	RETURN -1
END IF
end event

event ue_checktrans;/****************************************************************************************

	Event:	ue_checktrans
	Purpose:	Check the transfer status of the case
	
	Revisions:
	Date     Developer     Description
	======== ============= ==============================================================
	9/25/2001 K. Claver    Created
****************************************************************************************/
Integer l_nTransCount
String l_cCurrentCSR, l_cTransferFrom, l_cCaseViewed, l_cCaseStatus = "O"
String l_cUpdatedBy, l_cTransType

l_cTransType = THIS.Object.case_transfer_type[ a_nRow ]
					
//Only do the ownership check if not a copy
IF l_cTransType <> 'C' THEN
	//Check if the transfer still exists.  Case could have been closed
	//  by someone else.
	SELECT Count( * )
	INTO :l_nTransCount
	FROM cusfocus.case_transfer
	WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
			cusfocus.case_transfer.case_transfer_type = 'O'
	USING SQLCA;
	
	IF l_nTransCount = 0 THEN
		//Check if has been re-opened or is still open and the current user 
		//  is the rep(owner).
		SELECT cusfocus.case_log.case_status_id, 
				 cusfocus.case_log.case_log_case_rep, 
				 cusfocus.case_log.updated_by
		INTO :l_cCaseStatus,
			  :l_cCurrentCSR,
			  :l_cUpdatedBy
		FROM cusfocus.case_log
		WHERE cusfocus.case_log.case_number = :a_cCaseNumber
		USING SQLCA;
	ELSE	
		//Check to see if the case has already been viewed or is still owned by
		//  the current user.			
		SELECT cusfocus.case_transfer.case_transfer_to,
				 cusfocus.case_transfer.case_transfer_from,
				 cusfocus.case_transfer.case_viewed
		INTO :l_cCurrentCSR,
			  :l_cTransferFrom,
			  :l_cCaseViewed
		FROM cusfocus.case_transfer
		WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
				cusfocus.case_transfer.case_transfer_type = 'O'
		USING SQLCA;
	END IF
	
	//Display the appropriate message if the current user 
	//  is no longer the owner of the case
	IF l_cCaseStatus = "C" THEN
		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been closed by "+l_cUpdatedBy+".", &
						StopSign!, Ok! )
	ELSEIF l_cCaseStatus = "V" THEN
		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been voided by "+l_cUpdatedBy+".", &
						StopSign!, Ok! )
	ELSEIF ( l_nTransCount = 0 ) AND ( NOT IsNull( l_cCurrentCSR ) ) AND &
			 ( Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been reopened by "+l_cCurrentCSR+".", &
						StopSign!, Ok! )	 
	ELSEIF Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN			
		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been transferred to "+l_cCurrentCSR+" by "+l_cTransferFrom+".", &
						StopSign!, Ok! )
	END IF
	
	//Update the case_viewed flag if the current user is the
	//  same as the transfer to and the case is open.
	IF l_nTransCount > 0 AND Upper( l_cCurrentCSR ) = Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN
		IF IsNull( l_cCaseViewed ) THEN
			THIS.Object.case_viewed[ a_nRow ] = "Y"
			THIS.fu_Save( THIS.c_SaveChanges )
		ELSE
			THIS.Object.case_viewed[ a_nRow ] = "Y"
			THIS.SetItemStatus( a_nRow, 0, Primary!, NotModified! )
		END IF
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
	END IF		
END IF
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Set sort service and select on row focus change options
	9/20/2002  K. Claver    Added c_NoRetrieveOnOpen
******************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  c_NullDW, & 
						  c_SelectOnRowFocusChange+ &
						  c_SortClickedOK+ &
						  c_ModifyOK+ &
						  c_DeleteOK+ &
						  c_ViewAfterSave+ &
						  c_NoMenuButtonActivation+ &
						  c_RetrieveAsNeeded+ &
						  c_NoRetrieveOnOpen )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "l_footer", THIS.inv_resize.SCALERIGHT )
END IF
						  
i_EnablePopup = TRUE

end event

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
	Event:	pcd_retrieve
	Purpose:	Retrieve rows into the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Added code to retrieve the datawindow based on the user id and
									the current date and time.
******************************************************************************************/
LONG l_nRtn, l_nRow

SetPointer( Hourglass! )

l_nRtn = THIS.Retrieve( OBJCA.WIN.fu_GetLogin( SQLCA ), PARENT.fu_GetTimestamp( ) )

IF l_nRtn < 0 THEN
   Error.i_FWError = c_Fatal
ELSEIF l_nRtn = 0 THEN
	dw_transfernotes.fu_Reset( c_IgnoreChanges )
	st_notes.Visible = FALSE
END IF

SetPointer( Arrow! )

l_nRow = THIS.GetRow()

THIS.SelectRow(0,FALSE)

IF l_nrow > 0 THEN

	i_wParentWindow.i_cCaseNumber = THIS.GetItemSTring(l_nrow,'case_number')

   i_cViewedCase = THIS.GetItemString(l_nrow,'case_viewed')
	
   i_cOwner = THIS.GetItemString(l_nrow,'case_log_case_rep')	 

	 IF i_cViewedCase = 'Y' AND UPPER(i_cOwner)  = UPPER( OBJCA.WIN.fu_GetLogin( SQLCA ) )  THEN
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
	ELSE
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = FALSE
	END IF
	 
END IF

end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/23/2000 K. Claver   Added code to retrieve the case when double click on a row
//  3/4/2002   K. Claver   Modified to use the new version of the case search event.
//***********************************************************************************************  
w_create_maintain_case l_wCaseWindow
String l_cCaseNumber

IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN
		l_cCaseNumber = THIS.Object.case_number[ row ]
		
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			//Check the transfer status of the case
			THIS.Event Trigger ue_CheckTrans( row, l_cCaseNumber )
			
			// Open w_create_maintain_case
			FWCA.MGR.fu_OpenWindow(w_create_maintain_case, -1)
			l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet()
			
			IF IsValid (l_wCaseWindow) THEN
				
				// Make sure the window is on the Search tab
				IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
					l_wCaseWindow.dw_folder.fu_SelectTab(1)
				END IF
				
				// call ue_casesearch to process the query after the window is fully initialized.
				l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber)
				
			END IF						
		END IF
	END IF
END IF
end event

event pcd_update;//***********************************************************************************************
//
//  Event:   pcd_update
//  Purpose: Update the changed data.  Overrides the ancestor!
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/24/2000 K. Claver   Added code to update the case_viewed flag in the datawindow
//***********************************************************************************************
IF IsNull( transaction_object ) = FALSE THEN
	IF THIS.Update( TRUE, TRUE ) = c_Fatal THEN
   	Error.i_FWError = c_Fatal
	END IF
END IF
end event

event clicked;call super::clicked;/*****************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	12/18/2000 K. Claver    Added code to enable/disable the delete menu item based on the
									transfer type.
******************************************************************************************/
IF row > 0 THEN
	IF THIS.Object.case_transfer_type[ row ] = "C" THEN
		m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
	ELSE
		m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
	END IF

	i_wParentWindow.i_cCaseNumber = THIS.GetItemSTring(row,'case_number')

   i_cViewedCase = THIS.GetItemString(row,'case_viewed')
	
   i_cOwner = THIS.GetItemString(row,'case_log_case_rep')	 

	 IF i_cViewedCase = 'Y' AND UPPER(i_cOwner)  = UPPER( OBJCA.WIN.fu_GetLogin( SQLCA ) )  THEN
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
	ELSE
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = FALSE
	END IF
	 
END IF


end event

event pcd_pickedrow;call super::pcd_pickedrow;////**********************************************************************************************
////
////  Event:   pcd_pickedrow
////  Purpose: Change settings according to currently selected row
////  
////  Date     Developer   Description
////  -------- ----------- -----------------------------------------------------------------------
////  02/25/03 C. Jackson  Original Version
////**********************************************************************************************
//
//LONG l_nRow
//STRING l_cCaseNumber, l_cOwner, l_cViewed
//
//l_nRow = THIS.GetRow()
//
//IF l_nRow > 0 THEN
//
//	i_wParentWindow.i_cCaseNumber = THIS.GetItemString(l_nRow,'case_number')
//	
//	messagebox('cj_debug','selected case_number: '+i_wParentWindow.i_cCaseNumber)
//	
//	SELECT case_viewed
//	  INTO :l_cViewed
//	  FROM cusfocus.case_transfer
//	 WHERE case_number = :i_wParentWindow.i_cCaseNumber
//	 USING SQLCA;
//		 
//	IF l_cViewed = 'Y' THEN
//	
//		SELECT cusfocus.case_log.case_log_case_rep 
//		  INTO :l_cOwner
//		  FROM cusfocus.case_log
//		 WHERE case_number = :i_wParentWindow.i_cCaseNumber
//		 USING SQLCA;
//		 
//		IF UPPER(l_cOwner)  = UPPER( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN
//			// enable popup
//			messagebox('cj_debug','would allow popup here')
//			
//		END IF
//
//			 
//	END IF
//		
//END IF
//	
//
end event

type gb_1 from groupbox within uo_tabpg_inbox
boolean visible = false
integer x = 14
integer y = 4
integer width = 3557
integer height = 716
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Case Transfers and Copies"
end type

type gb_2 from groupbox within uo_tabpg_inbox
boolean visible = false
integer x = 14
integer y = 1036
integer width = 3557
integer height = 556
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Case Preview"
end type

type gb_3 from groupbox within uo_tabpg_inbox
boolean visible = false
integer x = 14
integer y = 724
integer width = 3557
integer height = 308
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Transfer Notes"
end type

