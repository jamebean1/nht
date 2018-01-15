$PBExportHeader$uo_tabpg_expiredcases.sru
forward
global type uo_tabpg_expiredcases from u_tabpg_std
end type
type st_notes from statictext within uo_tabpg_expiredcases
end type
type rb_transcases from radiobutton within uo_tabpg_expiredcases
end type
type rb_mycases from radiobutton within uo_tabpg_expiredcases
end type
type rb_all from radiobutton within uo_tabpg_expiredcases
end type
type dw_expiredcases from u_dw_std within uo_tabpg_expiredcases
end type
type dw_preview from u_dw_std within uo_tabpg_expiredcases
end type
type gb_2 from groupbox within uo_tabpg_expiredcases
end type
type gb_1 from groupbox within uo_tabpg_expiredcases
end type
type gb_3 from groupbox within uo_tabpg_expiredcases
end type
type dw_transfernotes from u_dw_std within uo_tabpg_expiredcases
end type
end forward

global type uo_tabpg_expiredcases from u_tabpg_std
integer width = 3602
integer height = 1612
string text = "Expired Cases"
event ue_refresh ( )
event ue_deletecopy ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
st_notes st_notes
rb_transcases rb_transcases
rb_mycases rb_mycases
rb_all rb_all
dw_expiredcases dw_expiredcases
dw_preview dw_preview
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
dw_transfernotes dw_transfernotes
end type
global uo_tabpg_expiredcases uo_tabpg_expiredcases

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
	
	dw_expiredcases.fu_Retrieve( dw_expiredcases.c_IgnoreChanges, &
										  dw_expiredcases.c_ReselectRows )
										  
	//Need to manually retrieve the child datawindows on refresh
	//  as the non-PowerClass tab architecture doesn't handle the
	//  retrieve of the child datawindows(with the exception of
	//  rowfocuschange in the parent datawindow).
	dw_transfernotes.fu_Retrieve( dw_transfernotes.c_IgnoreChanges, &
											dw_transfernotes.c_ReselectRows )
									
	dw_preview.fu_Retrieve( dw_preview.c_IgnoreChanges, &
									dw_preview.c_ReselectRows )
									
	//Set the focus back to the list datawindow
	dw_expiredcases.SetFocus( )
	
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

IF dw_expiredcases.RowCount( ) > 0 AND dw_expiredcases.DataObject = "d_expiredcases" THEN
	l_nRow = dw_expiredcases.GetSelectedRow( l_nRow )
	
	IF l_nRow > 0 THEN
		IF dw_expiredcases.Object.case_transfer_type[ l_nRow ] = "C" THEN
			//Update the copy_deleted flag
			dw_expiredcases.Object.copy_deleted[ l_nRow ] = 1
			dw_expiredcases.fu_Save( dw_expiredcases.c_SaveChanges )
			
			l_nSelectedRow[ 1 ] = l_nRow
			
			dw_expiredcases.fu_Delete( 1, l_nSelectedRow, dw_expiredcases.c_IgnoreChanges )
			
			//Empty the delete buffer so won't attempt to delete from
			//  the database
			dw_expiredcases.fu_ResetUpdate( )	
			
			IF dw_expiredcases.RowCount( ) > 0 THEN
				IF l_nRow > 2 THEN
					l_nSelectedRow[ 1 ] = ( l_nRow - 1 )
				ELSE
					l_nSelectedRow[ 1 ] = 1
				END IF
					
				dw_expiredcases.fu_SetSelectedRows( 1, l_nSelectedRow, dw_expiredcases.c_IgnoreChanges, dw_expiredcases.c_RefreshChildren )
				
				l_nRow = l_nSelectedRow[ 1 ]
				
				IF dw_expiredcases.Object.case_transfer_type[ l_nRow ] = "O" THEN
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
THIS.dw_expiredcases.SetFocus( )
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

on uo_tabpg_expiredcases.create
int iCurrent
call super::create
this.st_notes=create st_notes
this.rb_transcases=create rb_transcases
this.rb_mycases=create rb_mycases
this.rb_all=create rb_all
this.dw_expiredcases=create dw_expiredcases
this.dw_preview=create dw_preview
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.dw_transfernotes=create dw_transfernotes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_notes
this.Control[iCurrent+2]=this.rb_transcases
this.Control[iCurrent+3]=this.rb_mycases
this.Control[iCurrent+4]=this.rb_all
this.Control[iCurrent+5]=this.dw_expiredcases
this.Control[iCurrent+6]=this.dw_preview
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_3
this.Control[iCurrent+10]=this.dw_transfernotes
end on

on uo_tabpg_expiredcases.destroy
call super::destroy
destroy(this.st_notes)
destroy(this.rb_transcases)
destroy(this.rb_mycases)
destroy(this.rb_all)
destroy(this.dw_expiredcases)
destroy(this.dw_preview)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.dw_transfernotes)
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
	THIS.inv_resize.of_Register( dw_expiredcases, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( gb_3, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( dw_transfernotes, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( gb_2, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( dw_preview, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( st_notes, THIS.inv_resize.FIXEDBOTTOM )
END IF

i_wParentWindow = W_REMINDERS
end event

type st_notes from statictext within uo_tabpg_expiredcases
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

type rb_transcases from radiobutton within uo_tabpg_expiredcases
integer x = 1394
integer y = 68
integer width = 745
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferred Cases"
end type

event clicked;/*****************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/23/2000 K. Claver    Added code to fire the event on the expired cases list
									and pass it a parameter to determine which dataobject to set
									and show.
******************************************************************************************/
dw_expiredcases.Event Trigger ue_Change( "T" )
end event

type rb_mycases from radiobutton within uo_tabpg_expiredcases
integer x = 709
integer y = 68
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "My Cases"
end type

event clicked;/*****************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/23/2000 K. Claver    Added code to fire the event on the expired cases list
									and pass it a parameter to determine which dataobject to set
									and show.
******************************************************************************************/
dw_expiredcases.Event Trigger ue_Change( "M" )
end event

type rb_all from radiobutton within uo_tabpg_expiredcases
integer x = 73
integer y = 68
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "All Cases"
boolean checked = true
end type

event clicked;/*****************************************************************************************
	Event:	clicked
	Purpose:	Please see PB documentation for this event

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/23/2000 K. Claver    Added code to fire the event on the expired cases list
									and pass it a parameter to determine which dataobject to set
									and show.
******************************************************************************************/
dw_expiredcases.Event Trigger ue_Change( "A" )
end event

type dw_expiredcases from u_dw_std within uo_tabpg_expiredcases
event ue_change ( string a_cchangetype )
event ue_selecttrigger pbm_dwnkey
event ue_checktrans ( integer a_nrow,  string a_ccasenumber )
integer x = 41
integer y = 152
integer width = 3502
integer height = 544
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_expiredcases"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event ue_change;/*****************************************************************************************
	Event:	ue_Change
	Purpose:	Change the dataobject and re-retrieve

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/23/2000 K. Claver    Original Version
******************************************************************************************/
String l_cNewDataObject
Integer l_nSelectedRow

CHOOSE CASE a_cChangeType
	CASE "A"
		l_cNewDataObject = "d_expiredcases"
	CASE "M"
		l_cNewDataObject = "d_myexpiredcases"
	CASE "T"
		l_cNewDataObject = "d_transexpiredcases"
	CASE ELSE
		l_cNewDataObject = "d_expiredcases"
END CHOOSE

IF Upper( l_cNewDataObject ) <> Upper( THIS.DataObject ) THEN
	THIS.DataObject = l_cNewDataObject
	THIS.SetTransObject( SQLCA )
	THIS.fu_Retrieve( THIS.c_IgnoreChanges, THIS.c_NoReselectRows )
	
	IF THIS.RowCount( ) > 0 AND a_cChangeType = "A" THEN
		l_nSelectedRow = THIS.GetSelectedRow( 0 )
		IF l_nSelectedRow > 0 THEN
			IF THIS.Object.case_transfer_type[ l_nSelectedRow ] = "C" THEN
				m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = TRUE
			ELSE
				m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
			END IF
		ELSE
			m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
		END IF
	ELSE
		m_cusfocus_reminders.m_edit.m_deletereminder.Enabled = FALSE
	END IF
END IF
end event

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
		//Check the transfer status
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

event ue_checktrans;//***********************************************************************************************
//
//  Event:   ue_checktrans
//  Purpose: Check the transfer status of the case before opening.
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  9/25/2001 K. Claver   Created
//*********************************************************************************************** 
Integer l_nTransCount, l_nInactivePos
String l_cCurrentCSR, l_cTransferFrom, l_cCaseViewed, l_cCaseStatus = "O"
String l_cUpdatedBy, l_cTransType, l_cTransferTo

l_cTransferTo = THIS.Object.transfer_to[ a_nRow ]

//Check for the inactive flag.  If exists, remove.
l_nInactivePos = Pos( Upper( l_cTransferTo ), "(INACTIVE)" )
IF l_nInactivePos > 0 THEN
	l_cTransferTo = Trim( Mid( l_cTransferTo, 1, ( l_nInactivePos - 1 ) ) )
END IF
		
IF THIS.DataObject = "d_expiredcases" THEN
	l_cTransType = THIS.Object.case_transfer_type[ a_nRow ]
ELSE
	//Only owner rows on the other datawindows
	l_cTransType = "O"
END IF		

//Only do the ownership check if not a copy and the case has been transferred to the current user.
IF l_cTransType <> "C" AND Upper( l_cTransferTo ) = Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN
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
						StopSign!, OK! )
	ELSEIF l_cCaseStatus = "V" THEN
		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been voided by "+l_cUpdatedBy+".", &
						StopSign!, OK! )
	ELSEIF ( l_nTransCount = 0 ) AND ( NOT IsNull( l_cCurrentCSR ) ) AND &
			 ( Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been reopened by "+l_cCurrentCSR+".", &
						StopSign!, OK! )	 
	ELSEIF Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN			
		MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been transferred to "+l_cCurrentCSR+" by "+l_cTransferFrom+".", &
						StopSign!, OK! )
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

event pcd_setoptions;call super::pcd_setoptions;//***********************************************************************************************
//
//  Event:   pcd_setoptions
//  Purpose: Set the datawindow options
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/20/2000 K. Claver   Original Version
//  10/24/2000 K. Claver	Enabled resize and registered l_1 line
//  9/20/2002  K. Claver   Added c_NoRetrieveOnOpen
//***********************************************************************************************
THIS.fu_SetOptions( SQLCA, &
						  c_NullDW, & 
						  c_SelectOnRowFocusChange+ &
						  c_SortClickedOK+ &
						  c_ModifyOK+ &
						  c_ViewAfterSave+ &
						  c_NoMenuButtonActivation+ &
						  c_RetrieveAsNeeded+ &
						  c_DeleteOK+ &
						  c_NoRetrieveOnOpen )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "l_1", THIS.inv_resize.SCALERIGHT )
END IF

i_EnablePopup = TRUE
end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/23/2000 K. Claver   Added code to retrieve the case when double click on a row
//  12/8/2000 K. Claver    Added code to check the case status(open, transfer to, etc) before allowing
//									the user to open.
//  3/4/2002  K. Claver    Modified to use the new version of the case search event
//***********************************************************************************************  
w_create_maintain_case l_wCaseWindow
String l_cCaseNumber

IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN		
		l_cCaseNumber = THIS.Object.case_number[ row ]
		
		IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
			//Check the transfer status
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

event pcd_retrieve;call super::pcd_retrieve;/*****************************************************************************************
	Event:	pcd_retrieve
	Purpose:	Retrieve rows into the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/00 K. Claver      Added code to retrieve the datawindow based on the user id and
									the current date and time.
	01/22/03 C. Jackson     Set the Record Type to blank if the signed on user is not the
	                        owner of the case.
	02/13/03 M. Caruso	   Reversed previous change and implemented functionality in the
									datawindow.
	03/03/03 M. Caruso      Added CHOOSE CASE to set i_cOwner based on who the datawindow
									selected.
******************************************************************************************/
LONG l_nRtn, l_nRow
LONG l_nIndex

SetPointer( Hourglass! )

l_nRtn = THIS.Retrieve( OBJCA.WIN.fu_GetLogin( SQLCA ), &
							   PARENT.fu_GetTimestamp( ), &
								i_wParentWindow.i_nRepConfidLevel )

IF l_nRtn < 0 THEN
   Error.i_FWError = c_Fatal
ELSEIF l_nRtn = 0 THEN
	dw_transfernotes.fu_Reset( c_IgnoreChanges )
	st_notes.Visible = TRUE
	THIS.SetFocus( )
//	
//ELSE
//	
//	// the following value replacement only applies to this datawindow object.
//	IF dw_expiredcases.DataObject = "d_expiredcases" THEN
//		
//		FOR l_nIndex = 1 TO l_nRtn
//		
//			IF OBJCA.WIN.fu_GetLogin(SQLCA) <> dw_expiredcases.GetItemString(l_nIndex,'transfer_to') THEN
//				dw_expiredcases.SetItem(l_nIndex,'case_transfer_type','')
//				THIS.SetItemStatus( l_nIndex, 0, Primary!, NotModified! )
//			END IF
//		
//		NEXT
//		
//	END IF

END IF

l_nRow = THIS.GetRow()

IF l_nrow > 0 THEN

	i_wParentWindow.i_cCaseNumber = THIS.GetItemString(l_nrow,'case_number')

   i_cViewedCase = THIS.GetItemString(l_nrow,'case_viewed')
	
   CHOOSE CASE dw_expiredcases.DataObject
		CASE "d_expiredcases"
			i_cOwner = THIS.GetItemString(l_nrow,'case_log_case_rep')
			
		CASE "d_myexpiredcases"
			i_cOwner = THIS.GetItemString(l_nrow,'transfer_to')
			
		CASE "d_transexpiredcases"
			i_cOwner = OBJCA.WIN.fu_GetLogin(SQLCA)
			
	END CHOOSE

	 IF i_cViewedCase = 'Y' AND UPPER(i_cOwner)  = UPPER( OBJCA.WIN.fu_GetLogin( SQLCA ) )  THEN
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = TRUE
	ELSE
		m_cusfocus_reminders.m_edit.m_markunread.Enabled = FALSE
	END IF
	 
END IF


SetPointer( Arrow! )
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
	4/4/2001 K. Claver    Added code to enable/disable the delete menu item based on the
									transfer type.
******************************************************************************************/
IF row > 0 AND THIS.DataObject = "d_expiredcases" THEN
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

type dw_preview from u_dw_std within uo_tabpg_expiredcases
integer x = 41
integer y = 1096
integer width = 3502
integer height = 472
integer taborder = 40
string dataobject = "d_case_notes_new"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

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
LONG l_nRtn
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

dw_expiredcases.SetFocus( )
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Set dw_opencases as the parent datawindow
	10/24/2000 K. Claver		Enabled resize and registered note_text
	3/1/2002   K. Claver    Enabled modify for the datawindow to allow the user to copy the
									case notes
	9/20/2002  K. Claver    Added c_NoRetrieveOnOpen
******************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  dw_expiredcases, & 
						  c_NoMenuButtonActivation+ &
						  c_ModifyOK+ &
						  c_HideHighlight+ &
						  c_NoRetrieveOnOpen )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "note_text", THIS.inv_resize.SCALERIGHT )
END IF
end event

type gb_2 from groupbox within uo_tabpg_expiredcases
integer x = 14
integer y = 1036
integer width = 3557
integer height = 556
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Case Preview"
end type

type gb_1 from groupbox within uo_tabpg_expiredcases
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
string text = "Expired Cases"
end type

type gb_3 from groupbox within uo_tabpg_expiredcases
integer x = 14
integer y = 724
integer width = 3557
integer height = 308
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transfer Notes"
end type

type dw_transfernotes from u_dw_std within uo_tabpg_expiredcases
integer x = 41
integer y = 792
integer width = 3502
integer height = 212
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_transfer_notes"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

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

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Set dw_opencases as the parent datawindow
	10/24/2000 K. Claver		Enabled resize and registered case_transfer_notes
******************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  dw_expiredcases, & 
						  c_NoMenuButtonActivation+ &
						  c_NoEnablePopup+ &
						  c_NoRetrieveOnOpen )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "case_transfer_notes", THIS.inv_resize.SCALERIGHT )
END IF
end event

