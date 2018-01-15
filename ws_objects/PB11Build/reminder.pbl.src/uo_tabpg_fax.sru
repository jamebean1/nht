$PBExportHeader$uo_tabpg_fax.sru
forward
global type uo_tabpg_fax from u_tabpg_std
end type
type gb_1 from groupbox within uo_tabpg_fax
end type
type dw_preview from u_dw_std within uo_tabpg_fax
end type
type gb_2 from groupbox within uo_tabpg_fax
end type
type dw_opencases from u_dw_std within uo_tabpg_fax
end type
end forward

global type uo_tabpg_fax from u_tabpg_std
integer width = 3602
integer height = 1612
string text = "Open Cases"
event ue_refresh ( )
event ue_setmainfocus ( )
event ue_setneedrefresh ( )
gb_1 gb_1
dw_preview dw_preview
gb_2 gb_2
dw_opencases dw_opencases
end type
global uo_tabpg_fax uo_tabpg_fax

type prototypes
FUNCTION long ShellExecuteA(long hwnd, string lpOperation, string lpFile, string lpParameters, string lpDirectory, long nShowCmd) LIBRARY "SHELL32.DLL" alias for "ShellExecuteA;Ansi"
end prototypes

type variables
W_REMINDERS		i_wParentWindow
uo_tab_workdesk  i_tabParentTab
Boolean i_bNeedRefresh = FALSE


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
	
	dw_opencases.fu_Retrieve( dw_opencases.c_IgnoreChanges, &
									  dw_opencases.c_ReselectRows )								  
									  
	//Need to manually retrieve the child datawindows on refresh
	//  as the non-PowerClass tab architecture doesn't handle the
	//  retrieve of the child datawindows(with the exception of
	//  rowfocuschange in the parent datawindow).
	dw_preview.fu_Retrieve( dw_preview.c_IgnoreChanges, &
									dw_preview.c_ReselectRows )
									
	//Refreshed.  Reset Variable.
	THIS.i_bNeedRefresh = FALSE
	
	THIS.i_tabParentTab.SetRedraw( TRUE )
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
THIS.dw_opencases.SetFocus( )
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

on uo_tabpg_fax.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.dw_preview=create dw_preview
this.gb_2=create gb_2
this.dw_opencases=create dw_opencases
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_preview
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.dw_opencases
end on

on uo_tabpg_fax.destroy
call super::destroy
destroy(this.gb_1)
destroy(this.dw_preview)
destroy(this.gb_2)
destroy(this.dw_opencases)
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
	THIS.inv_resize.of_Register( dw_opencases, THIS.inv_resize.SCALERIGHTBOTTOM )
	THIS.inv_resize.of_Register( gb_2, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
	THIS.inv_resize.of_Register( dw_preview, THIS.inv_resize.FIXEDBOTTOM_SCALERIGHT )
//	THIS.inv_resize.of_Register( st_notes, THIS.inv_resize.FIXEDBOTTOM )
END IF

i_wParentWindow = W_REMINDERS
end event

type gb_1 from groupbox within uo_tabpg_fax
integer x = 14
integer y = 4
integer width = 3557
integer height = 1140
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fax Queue"
end type

type dw_preview from u_dw_std within uo_tabpg_fax
integer x = 41
integer y = 1212
integer width = 3502
integer height = 340
integer taborder = 30
string dataobject = "d_appealtracker_preview"
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
	10/17/2000 K. Claver    Set dw_opencases as the parent datawindow
	10/24/2000 K. Claver		Enabled resize and registered note_text
	3/1/2002   K. Claver    Enabled modify for the datawindow to allow the user to copy the
									case notes
******************************************************************************************/
THIS.fu_SetOptions( SQLCA, &
						  dw_opencases, & 
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
//LONG l_nRtn = 0, ll_casenumber
//INTEGER l_nRow
//STRING l_cSelected
//
//SetPointer( Hourglass! )
//
//IF UpperBound( selected_rows ) > 0 THEN
//	l_nRow = selected_rows[ 1 ]
//ELSE
//	//Use the PB method to get the current selected row.
//	l_nRow = Parent_DW.GetSelectedRow( 0 )
//END IF
//
//IF l_nRow > 0 THEN
//	ll_casenumber = Parent_DW.GetItemNumber( l_nRow, "casenumber")
//
//	l_nRtn = THIS.Retrieve( ll_casenumber, i_wParentWindow.i_nRepConfidLevel )
//	
//ELSE
//	THIS.fu_Reset( c_IgnoreChanges )
////	st_notes.Visible = TRUE
//END IF
//
//IF l_nRtn < 0 THEN
//   Error.i_FWError = c_Fatal
//ELSEIF l_nRtn = 0 THEN
////	st_notes.Visible = TRUE
//ELSE
////	st_notes.Visible = FALSE
//	THIS.Function Post fu_Modify( )
//END IF
//
//SetPointer( Arrow! )
end event

type gb_2 from groupbox within uo_tabpg_fax
integer x = 14
integer y = 1156
integer width = 3557
integer height = 424
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fax Detail Preview"
end type

type dw_opencases from u_dw_std within uo_tabpg_fax
event ue_selecttrigger pbm_dwnkey
event ue_checktrans ( string a_ccasenumber )
integer x = 41
integer y = 72
integer width = 3502
integer height = 1040
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_faxlist"
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

//W_CREATE_MAINTAIN_CASE	l_wCaseWindow
//Long			l_nRow
//String      l_cCaseNumber
//
//// if the user double-clicked on a row, process it.
//IF ( key = KeyEnter! ) AND ( THIS.GetRow() > 0 ) THEN
//	
//	// Get the selected case number
//	l_nRow = GetRow( )
//	l_cCaseNumber = THIS.Object.case_number[ l_nRow ]
//	
//	IF NOT IsNull( l_cCaseNumber ) AND Trim( l_cCaseNumber ) <> "" THEN
//		//Check the transfer status of the case
//		THIS.Event Trigger ue_CheckTrans( l_cCaseNumber )
//		
//		// Open w_create_maintain_case
//		FWCA.MGR.fu_OpenWindow( w_create_maintain_case, -1 )
//		l_wCaseWindow = FWCA.MGR.i_MDIFrame.GetActiveSheet( )
//		
//		IF IsValid( l_wCaseWindow ) THEN
//			 
//			// Make sure the window is on the Search tab
//			IF l_wCaseWindow.dw_folder.i_CurrentTab <> 1 THEN
//				l_wCaseWindow.dw_folder.fu_SelectTab( 1 )
//			END IF
//			
//			// call ue_casesearch to process the query after the window is fully initialized.
//			l_wCaseWindow.dw_folder.Event Post ue_casesearch( l_cCaseNumber )
//			
//		END IF
//	END IF
//	RETURN -1
//END IF
end event

event ue_checktrans(string a_ccasenumber);///****************************************************************************************
//
//	Event:	ue_checktrans
//	Purpose:	Check the transfer status of the case
//	
//	Revisions:
//	Date     Developer     Description
//	======== ============= ==============================================================
//	9/25/2001 K. Claver    Created
//****************************************************************************************/
//Integer l_nTransCount
//String l_cCaseStatus, l_cCurrentCSR, l_cUpdatedBy, l_cTransferFrom
//
////Check if there is a transfer.  Case could have been closed
////  by someone else.
//SELECT Count( * )
//INTO :l_nTransCount
//FROM cusfocus.case_transfer
//WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
//		cusfocus.case_transfer.case_transfer_type = 'O'
//USING SQLCA;
//
//IF l_nTransCount = 0 THEN
//	//Check if has been re-opened or is still open and the current user 
//	//  is the rep(owner).
//	SELECT cusfocus.case_log.case_status_id, 
//			 cusfocus.case_log.case_log_case_rep, 
//			 cusfocus.case_log.updated_by
//	INTO :l_cCaseStatus,
//		  :l_cCurrentCSR,
//		  :l_cUpdatedBy
//	FROM cusfocus.case_log
//	WHERE cusfocus.case_log.case_number = :a_cCaseNumber
//	USING SQLCA;
//ELSE	
//	//Check to see if the case has already been viewed or is still owned by
//	//  the current user.			
//	SELECT cusfocus.case_transfer.case_transfer_to,
//			 cusfocus.case_transfer.case_transfer_from
//	INTO :l_cCurrentCSR,
//		  :l_cTransferFrom
//	FROM cusfocus.case_transfer
//	WHERE cusfocus.case_transfer.case_number = :a_cCaseNumber AND 
//			cusfocus.case_transfer.case_transfer_type = 'O'
//	USING SQLCA;
//END IF
//
////Display the appropriate message if the current user 
////  is no longer the owner of the case
//IF l_cCaseStatus = "C" THEN
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been closed by "+l_cUpdatedBy+".", &
//					StopSign!, Ok! )
//ELSEIF l_cCaseStatus = "V" THEN
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been voided by "+l_cUpdatedBy+".", &
//					StopSign!, Ok! )
//ELSEIF ( l_nTransCount = 0 ) AND ( NOT IsNull( l_cCurrentCSR ) ) AND &
//		 ( Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) ) THEN
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been reopened by "+l_cCurrentCSR+".", &
//					StopSign!, Ok! )	 
//ELSEIF Upper( l_cCurrentCSR ) <> Upper( OBJCA.WIN.fu_GetLogin( SQLCA ) ) THEN			
//	MessageBox( gs_AppName, "Case #"+a_cCaseNumber+" has been transferred to "+l_cCurrentCSR+" by "+l_cTransferFrom+".", &
//					StopSign!, Ok! )
//END IF			
end event

event pcd_setoptions;call super::pcd_setoptions;/*****************************************************************************************
	Event:	pcd_setoptions
	Purpose:	Define the characteristics for the datawindow

	Revisions:
	Date     Developer      Description
	======== ============== ===============================================================
	10/17/2000 K. Claver    Set sort service and select on row focus change options
	10/24/2000 K. Claver		Enabled resize and registered l_1 line
	9/20/2002  K. Claver    Added c_NoRetrieveOnOpen
******************************************************************************************/
THIS.fu_SetKey( "case_number" )

THIS.fu_SetOptions( SQLCA, &
						  c_NullDW, & 
						  c_SelectOnRowFocusChange+ &
						  c_SortClickedOK+ &
						  c_NoMenuButtonActivation+ &
						  c_RetrieveAsNeeded+ &
						  c_NoEnablePopup+ &
						  c_NoRetrieveOnOpen )
						  
THIS.of_SetResize( TRUE )

IF IsValid( THIS.inv_resize ) THEN
	THIS.inv_resize.of_Register( "l_1", THIS.inv_resize.SCALERIGHT )
END IF
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
LONG l_nRtn

SetPointer( Hourglass! )

THIS.Retrieve()

//l_nRtn = THIS.Retrieve( OBJCA.WIN.fu_GetLogin( SQLCA ), PARENT.fu_GetTimestamp( ) )
//
//IF l_nRtn < 0 THEN
//   Error.i_FWError = c_Fatal
//ELSEIF l_nRtn = 0 THEN
////	st_notes.Visible = FALSE
//END IF

SetPointer( Arrow! )
end event

event doubleclicked;call super::doubleclicked;//***********************************************************************************************
//
//  Event:   doubleclicked
//  Purpose: Please see PB documentation for this event
//  
//  Date     Developer     Description
//  -------- ------------- ----------------------------------------------------------------------
//  10/23/2000 K. Claver   Added code to retrieve the case when double click on a row
//  3/4/2002   K. Claver   Modified to use the new version of the case search event
//***********************************************************************************************  
w_create_maintain_case l_wCaseWindow
long	ll_blobobjectid
String l_cCaseNumber



IF THIS.RowCount( ) > 0 THEN
	IF row > 0 THEN
		ll_blobobjectid = THIS.GetItemNumber( row, "blbobjctid" )
		
		IF NOT IsNull( ll_blobobjectid ) AND ll_blobobjectid <> 0 THEN
			Long l_nFileNum, l_nAttachmentKey, l_nAttachFileNum
			Integer l_nIndex, l_nLoop, l_nWriteRV, l_nRV
			Blob l_blFile, l_blFilePart
			Double l_dblFileSize
			ContextKeyword l_ckTemp
			String l_cTemp[ ], l_cFileName, l_cWriteFileName, l_cAttachFileLog
			n_cst_kernel32 l_uoKernelFuncs
			
			SetPointer( HourGlass! )
			
			//Attempt to get the file image
			SELECTBLOB blbobjctdta
			INTO :l_blFile
			FROM blobobject
			WHERE blbobjctid = :ll_blobobjectid
			USING SQLCA;
			
			Select	blbobjctqlfr
			INTO		:l_cFileName
			FROM		blobobject
			Where		blbobjctid = :ll_blobobjectid
			USING		SQLCA;
			
			IF SQLCA.SQLCode <> 0 THEN
				MessageBox( gs_AppName, "Failed to retrieve the file image from the database.  Error returned:~r~n"+ &
								SQLCA.SQLErrText, StopSign!, OK! )
			ELSEIF Trim( l_cFileName ) <> "" THEN
				//Prepare to open the document.
				// Get the Temp Path from Environment Variables to write the file
				// out before attempt to open.
				#IF defined PBDOTNET THEN
					l_cTemp[1] = System.IO.Path.GetTempPath()
				#ELSE
					l_ckTemp = CREATE ContextKeyword
					l_ckTemp.GetContextKeywords( "TEMP", l_cTemp ) 
					
					//Have the needed info.  Destroy the object.
					DESTROY l_ckTemp
				#END IF
				
				//If temp Path is not available, use Root drive.
				IF NOT l_uoKernelFuncs.of_DirectoryExists( l_cTemp[ 1 ] ) THEN 
					l_cTemp[ 1 ] = 'C:\'
				END IF
				
				//Get rid of any potential white space.
				l_cTemp[ 1 ] = Trim( l_cTemp[ 1 ] )
				
				//Add the directory to the file name.
				IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
					l_cWriteFileName = ( l_cTemp[ 1 ]+l_cFileName )
				ELSE
					l_cWriteFileName = ( l_cTemp[ 1 ]+"\"+l_cFileName )
				END IF
				
				//Write the file out.
				l_nFileNum = FileOpen( l_cWriteFileName, StreamMode!, Write!, LockReadWrite!, Replace! )
					
				IF l_nFileNum > 0 THEN
					//Find out how many reads to make on the image
					l_dblFileSize = Len( l_blFile )
					
					IF l_dblFileSize <= 32765 THEN
						l_nLoop = 1
					ELSEIF Mod( l_dblFileSize, 32765 ) = 0 THEN
						l_nLoop = ( l_dblFileSize / 32765 )
					ELSE
						l_nLoop = Ceiling( l_dblFileSize / 32765 )
					END IF
					
					//Write the file.
					IF l_nLoop = 1 THEN
						l_nWriteRV = FileWrite( l_nFileNum, l_blFile )
					ELSE
						l_blFilePart = BlobMid( l_blFile, 1, 32765 )
						FOR l_nIndex = 1 TO l_nLoop				
							l_nWriteRV = FileWrite( l_nFileNum, l_blFilePart )
							
							IF l_nWriteRV = -1 THEN					
								EXIT
							ELSE
								l_blFilePart = BlobMid( l_blFile, ( ( 32765 * l_nIndex ) + 1 ), 32765 )
							END IF							
						NEXT
					END IF
					
					IF l_nWriteRV = -1 THEN
						FileClose( l_nFileNum )
						FileDelete( l_cFileName )
									
						MessageBox( gs_AppName, "Unable to write to file "+l_cWriteFileName+".", &
										StopSign!, OK! )									
					ELSE
						FileClose( l_nFileNum )
						
						// API call script
						l_nRV = ShellExecuteA( 0, "open", l_cFileName, "" , l_cTemp[ 1 ], 1 )
						
						IF l_nRV = 31 THEN
							//No application associated with this file type.  Let the user pick one.
							l_nRV = ShellExecuteA( 0, "open", "rundll32.exe", ( "shell32.dll,OpenAs_RunDLL "+l_cFileName ), l_cTemp[ 1 ], 1 ) 
						END IF
						
						IF l_nRV >= 0 AND l_nRV <= 32 THEN
							MessageBox( gs_AppName, 'Bad Things' )
						ELSE
							//Log the file being opened to the attachments log file.
							IF Mid( l_cTemp[ 1 ], Len( l_cTemp[ 1 ] ), 1 ) = "\" THEN
								l_cAttachFileLog = ( l_cTemp[ 1 ]+"cfattachfile.log" )
							ELSE
								l_cAttachFileLog = ( l_cTemp[ 1 ]+"\"+"cfattachfile.log" )
							END IF
							
							l_nAttachFileNum = FileOpen( l_cAttachFileLog, LineMode!, Write!, LockWrite!, Append! )
							
							IF l_nAttachFileNum > 0 THEN
								FileWrite( l_nAttachFileNum, l_cWriteFileName )
								
								FileClose( l_nAttachFileNum )
							END IF
						END IF
					END IF
				ELSE
					MessageBox( gs_AppName, "Could not open the file for write", StopSign!, OK! )
				END IF						
			ELSE
				MessageBox( gs_AppName, "File name not populated.  Could not open file", StopSign!, OK! )
			END IF
			
			SetPointer( Arrow! )
			
			
			
			
			

				
		END IF						
	END IF
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;//Modify ("casenumber.background.color='0~tif(" + String (currentrow) + " = GetRow (),rgb(0,255,0),rgb(255,255,255)) '")
end event

